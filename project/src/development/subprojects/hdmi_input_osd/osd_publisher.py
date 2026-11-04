"""Observation-only adapter for a future OSD lease; no device imports or event consumption.

The caller owns the OSD MMIO window and calls tick from a bounded observation
scheduler (default 30 Hz), independently of game ticks. Input timestamps must
be the ORIGINAL board monotonic observation times, never STATUS reception time.
"""
from __future__ import annotations

from dataclasses import dataclass
import math
from typing import Protocol


class RegisterIO(Protocol):
    def read(self, offset: int) -> int: ...
    def write(self, offset: int, value: int) -> None: ...


def _integer(value: int, name: str, minimum: int = 0) -> None:
    if type(value) is not int or value < minimum:
        raise ValueError(f"{name} must be an integer >= {minimum}")


def _finite(value: float, name: str) -> None:
    if type(value) not in (int, float) or not math.isfinite(value):
        raise ValueError(f"{name} must be finite")


@dataclass(frozen=True)
class HandObservation:
    producer_run: str
    frame_id: int
    observed_ns: int
    x: float  # normalized display coordinates [-1,1], after rotation/mirror
    y: float
    position_valid: bool
    fist: bool  # confirmed CURRENT classification, not a fist edge event

    def __post_init__(self) -> None:
        if not isinstance(self.producer_run, str) or not self.producer_run:
            raise ValueError("missing vision producer identity")
        _integer(self.frame_id, "frame_id", 1)
        _integer(self.observed_ns, "observed_ns")
        for name in ("x", "y"):
            value = getattr(self, name)
            _finite(value, name)
            if not -1 <= value <= 1:
                raise ValueError("position must be normalized")
        if type(self.position_valid) is not bool or type(self.fist) is not bool:
            raise ValueError("hand flags must be boolean")


@dataclass(frozen=True)
class AudioObservation:
    producer_run: str
    epoch: int
    sample_count: int
    observed_ns: int
    mean_abs: float
    soft: float
    loud: float
    healthy: bool

    def __post_init__(self) -> None:
        if not isinstance(self.producer_run, str) or not self.producer_run:
            raise ValueError("missing audio producer identity")
        for name in ("epoch", "sample_count", "observed_ns"):
            _integer(getattr(self, name), name)
        for name in ("mean_abs", "soft", "loud"):
            _finite(getattr(self, name), name)
        if self.mean_abs < 0 or not 0 < self.soft < self.loud:
            raise ValueError("invalid level or thresholds")
        if type(self.healthy) is not bool:
            raise ValueError("audio health must be boolean")


class OsdPublisher:
    ID = 0x4F534401

    def __init__(self, registers: RegisterIO, *, width: int = 1280, height: int = 720,
                 hand_age_ns: int = 250_000_000, audio_age_ns: int = 100_000_000,
                 rate_hz: int = 30) -> None:
        for name, value in (("width", width), ("height", height), ("rate_hz", rate_hz),
                            ("hand_age_ns", hand_age_ns), ("audio_age_ns", audio_age_ns)):
            _integer(value, name, 1)
        if width > 2048 or height > 1024 or rate_hz > 60:
            raise ValueError("unsupported geometry or rate")
        if hand_age_ns > 250_000_000 or audio_age_ns > 100_000_000:
            raise ValueError("display source-age budget exceeds hardware watchdog")
        if registers.read(0) != self.ID:
            raise ValueError("OSD register identity mismatch")
        self.io, self.width, self.height = registers, width, height
        self.hand_age_ns, self.audio_age_ns = hand_age_ns, audio_age_ns
        self.period_ns = (1_000_000_000 + rate_hz - 1) // rate_hz
        self.next_ns = 0
        self.hand: HandObservation | None = None
        self.audio: AudioObservation | None = None
        self.hand_seq = self.audio_seq = 0
        self.commits = self.busy_skips = 0

    def _accept_hand(self, incoming: HandObservation | None) -> None:
        old = self.hand
        if incoming is None:
            return
        if old is not None:
            if incoming.observed_ns < old.observed_ns:
                return
            if incoming.producer_run == old.producer_run and incoming.frame_id <= old.frame_id:
                if not incoming.position_valid and old.position_valid:
                    self.hand = HandObservation(old.producer_run, old.frame_id, old.observed_ns,
                                                old.x, old.y, False, False)
                return  # duplicate source never renews timestamp or changes geometry
        self.hand = incoming
        self.hand_seq = self.hand_seq % 0xFFFFFFFF + 1

    def _accept_audio(self, incoming: AudioObservation | None) -> None:
        old = self.audio
        if incoming is None:
            return
        if old is not None:
            if incoming.observed_ns < old.observed_ns:
                return
            if (incoming.producer_run, incoming.epoch) == (old.producer_run, old.epoch) and incoming.sample_count <= old.sample_count:
                # Fault on an existing identity may invalidate it immediately,
                # but is never permitted to refresh the source observation time.
                if not incoming.healthy and old.healthy:
                    self.audio = AudioObservation(old.producer_run, old.epoch, old.sample_count,
                        old.observed_ns, old.mean_abs, old.soft, old.loud, False)
                return
        self.audio = incoming
        self.audio_seq = self.audio_seq % 0xFFFFFFFF + 1

    @staticmethod
    def _frames(observed_ns: int, now_ns: int, budget_ns: int, cap: int) -> int:
        remaining = budget_ns - (now_ns - observed_ns)
        if observed_ns > now_ns or remaining <= 0:
            return 0
        # Floor prevents a nearly expired sample gaining a whole video frame.
        return min(cap, remaining * 60 // 1_000_000_000)

    def tick(self, hand: HandObservation | None, audio: AudioObservation | None,
             *, now_ns: int, enabled: bool = True) -> bool:
        _integer(now_ns, "now_ns")
        if type(enabled) is not bool:
            raise ValueError("enabled must be boolean")
        # Bad/future observations cannot poison the accepted source watermark.
        if hand is not None and hand.observed_ns <= now_ns:
            self._accept_hand(hand)
        if audio is not None and audio.observed_ns <= now_ns:
            self._accept_audio(audio)
        if now_ns < self.next_ns:
            return False
        self.next_ns = now_ns + self.period_ns
        if self.io.read(4) & 1:
            self.busy_skips += 1
            return False  # never wait, spin, queue, or overwrite an in-flight mailbox
        hf = af = x = y = level = soft_height = loud_height = 0
        fist = False
        if self.hand is not None:
            h = self.hand
            hf = self._frames(h.observed_ns, now_ns, self.hand_age_ns, 15) if h.position_valid else 0
            x = round((h.x + 1) * (self.width - 1) / 2)
            y = round((h.y + 1) * (self.height - 1) / 2)
            fist = h.fist
        if self.audio is not None:
            a = self.audio
            af = self._frames(a.observed_ns, now_ns, self.audio_age_ns, 6) if a.healthy else 0
            # Fixed relative range 0..2*LOUD. Never adapt to the current level.
            scale = 120 / a.loud
            level = min(240, round(a.mean_abs * scale))
            soft_height = max(1, min(119, round(a.soft * scale)))
            loud_height = 120
        flags = int(enabled) | (int(hf > 0) << 1) | (int(fist and hf > 0) << 2) | (int(af > 0) << 3)
        words = (flags, x | (y << 16), level | (soft_height << 16),
                 loud_height | (hf << 16) | (af << 24), self.hand_seq, self.audio_seq)
        for index, value in enumerate(words):
            self.io.write(0x10 + 4 * index, value)
        self.io.write(8, 1)
        self.commits += 1
        return True
