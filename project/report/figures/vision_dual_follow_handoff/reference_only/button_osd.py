"""Independent hand-only HDMI OSD for the button-only overlay.

Run: imported by C6IButtonOsdRuntimeBackend after overlay admission.
Output: 30 Hz non-blocking hand marker MMIO updates; all former sound fields zero.
Next: inspect HDMI marker and OSD status on the board.
"""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from threading import Event, Thread
import math
import time


@dataclass(frozen=True)
class HandObservation:
    run: str
    frame: int
    observed_ns: int
    x: float
    y: float
    valid: bool
    fist: bool


class ObservationHub:
    def __init__(self):
        self.hand = None
        self.error = None

    def publish(self, observed, *, run_id, config_epoch, frame_id, observed_ns):
        try:
            point = observed.get("centroid")
            valid = bool(observed.get("bbox") is not None and point is not None
                         and len(point) == 2 and all(isinstance(v, (int, float))
                         and math.isfinite(v) for v in point)
                         and 0 <= point[0] < 640 and 0 <= point[1] < 360)
            x, y = ((2 * point[0] + .5) / 1279 * 2 - 1,
                    (2 * point[1] + .5) / 719 * 2 - 1) if valid else (0., 0.)
            fist = observed.get("stable") == "0" and observed.get("rps") == "ROCK"
            self.hand = HandObservation(f"{run_id}:{config_epoch}", frame_id,
                                        observed_ns, x, y, valid, valid and fist)
            self.error = None
        except Exception as error:
            self.error = f"{type(error).__name__}: {error}"
            self.clear()

    def clear(self):
        old = self.hand
        if old is not None:
            self.hand = HandObservation(old.run, old.frame, old.observed_ns,
                                        old.x, old.y, False, False)


class HandOsdPublisher:
    def __init__(self, mmio):
        if mmio.read(0) != 0x4F534401:
            raise ValueError("OSD register identity mismatch")
        self.io = mmio
        self.last = None
        self.sequence = 0
        self.commits = 0
        self.busy_skips = 0
        self.last_words = None

    def tick(self, hand, *, now_ns, enabled=True):
        if hand is not None and hand.observed_ns <= now_ns:
            if (self.last is None or hand.run != self.last.run or hand.frame > self.last.frame
                    or not hand.valid and self.last.valid):
                self.last = hand
                self.sequence = (self.sequence % 0xFFFFFFFF) + 1
        if self.io.read(4) & 1:
            self.busy_skips += 1
            return False
        h = self.last
        fresh = bool(h and h.valid and 0 <= now_ns - h.observed_ns < 250_000_000)
        ttl = min(15, (250_000_000 - (now_ns - h.observed_ns)) * 60 // 1_000_000_000) if fresh else 0
        x = round((h.x + 1) * 1279 / 2) if h else 0
        y = round((h.y + 1) * 719 / 2) if h else 0
        words = (int(enabled) | (int(ttl > 0) << 1) | (int(bool(h and h.fist and ttl)) << 2),
                 x | (y << 16), 0, ttl << 16, self.sequence, 0)
        for index, word in enumerate(words):
            self.io.write(0x10 + index * 4, word)
        self.io.write(8, 1)
        self.commits += 1
        self.last_words = words
        return True


class HandOsdService:
    INSTANCE = "input_osd_0"

    def __init__(self, session, hub):
        self.session, self.hub = session, hub
        self.lease = self.publisher = self.thread = None
        self.stop_event = Event()
        self.enabled = True
        self.error = None
        self.disabled_confirmed = False
        self.cycles = self.cpu_ns = self.max_cycle_ns = 0

    def open(self):
        self.lease = self.session.borrow("hdmi-hand-osd", instances=frozenset({self.INSTANCE}))
        self.lease.retain(self)
        try:
            actual = self.session.ip_address(
                self.lease, Path(self.lease.bitfile_name).with_suffix(".hwh"), self.INSTANCE)
            if actual != (0x43C20000, 4096):
                raise ValueError("hand OSD HWH address mismatch")
            self.publisher = HandOsdPublisher(self.lease.mmio(self.INSTANCE))
            self.thread = Thread(target=self._run, name="hdmi-hand-osd", daemon=True)
            self.thread.start()
        except BaseException:
            if self.thread is None:
                self.lease.close()
                self.lease = None
            raise
        return self

    def _run(self):
        try:
            while not self.stop_event.is_set():
                start, cpu = time.monotonic_ns(), time.thread_time_ns()
                self.publisher.tick(self.hub.hand, now_ns=start, enabled=self.enabled)
                self.cycles += 1
                self.cpu_ns += time.thread_time_ns() - cpu
                self.max_cycle_ns = max(self.max_cycle_ns, time.monotonic_ns() - start)
                self.stop_event.wait(max(0., (start + 33_333_334 - time.monotonic_ns()) / 1e9))
        except Exception as error:
            self.error = f"{type(error).__name__}: {error}"
        finally:
            try:
                self._disable()
            except Exception as error:
                self.error = self.error or f"disable: {type(error).__name__}: {error}"

    def _disable(self):
        deadline = time.monotonic() + .25
        committed = False
        while time.monotonic() < deadline:
            now_ns = time.monotonic_ns()
            if committed:
                if not self.publisher.io.read(4) & 1:
                    self.disabled_confirmed = True
                    return
            else:
                committed = self.publisher.tick(None, now_ns=now_ns, enabled=False)
            time.sleep(.002)
        raise RuntimeError("OSD disable ACK timed out; retain lease")

    def status(self):
        return {"schema": "hdmi-hand-osd-v1", "enabled": self.enabled,
                "thread_alive": self.thread is not None and self.thread.is_alive(),
                "error": self.error or self.hub.error, "cycles": self.cycles,
                "cpu_ns": self.cpu_ns, "max_cycle_ns": self.max_cycle_ns,
                "commits": 0 if self.publisher is None else self.publisher.commits,
                "busy_skips": 0 if self.publisher is None else self.publisher.busy_skips,
                "last_words": None if self.publisher is None else self.publisher.last_words,
                "disabled_confirmed": self.disabled_confirmed}

    def close(self):
        self.stop_event.set()
        if self.thread is not None:
            self.thread.join(1.)
            if self.thread.is_alive() or not self.disabled_confirmed:
                raise RuntimeError("hand OSD cleanup unconfirmed; retain Overlay lease")
        if self.lease is not None:
            self.lease.close()
            self.lease = None
