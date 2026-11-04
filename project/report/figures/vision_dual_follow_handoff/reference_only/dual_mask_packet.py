"""DMS1 decoding and candidate epoch/status contracts; no hardware ownership."""

from dataclasses import dataclass
from numbers import Integral
import struct
from typing import Callable
import zlib

import numpy as np


MAGIC = 0x31534D44
VERSION_LENGTH = 0x00100001
PAIR_FORMAT = 0x00010802
TRAILER = struct.Struct("<16I")
CAPTURE_STATUS_MAGIC = 0x31545356
CAPTURE_STATUS_ABI = 0x00010000


@dataclass(frozen=True)
class DualMaskFrame:
    raw: np.ndarray
    filtered: np.ndarray
    frame_id: int
    config_id: int
    epoch: int
    thresholds: tuple[int, ...]


@dataclass(frozen=True)
class CaptureEpochStatus:
    epoch: int
    ready: bool
    sealed: bool
    faults: int

    def __post_init__(self):
        if isinstance(self.epoch, bool) or not isinstance(self.epoch, Integral) or not 0 <= self.epoch <= 0xFFFFFFFF:
            raise ValueError("capture status epoch must be uint32")
        if type(self.ready) is not bool or type(self.sealed) is not bool:
            raise ValueError("capture readiness and seal must be bool")
        if self.sealed and not self.ready:
            raise ValueError("capture seal requires an armed monitor")
        if isinstance(self.faults, bool) or not isinstance(self.faults, Integral) or not 0 <= self.faults <= 7:
            raise ValueError("unknown capture fault causes")


def read_capture_epoch_status(read32: Callable[[int], int]) -> CaptureEpochStatus:
    def word(offset: int) -> int:
        value = read32(offset)
        if isinstance(value, bool) or not isinstance(value, Integral) or not 0 <= value <= 0xFFFFFFFF:
            raise ValueError("capture register read must be uint32")
        return int(value)

    if word(0) != CAPTURE_STATUS_MAGIC or word(4) != CAPTURE_STATUS_ABI:
        raise ValueError("capture status interface identity mismatch")
    epoch = word(16)
    flags = word(8)
    causes = word(12)
    if word(16) != epoch:
        raise ValueError("capture status epoch changed during read")
    if flags & ~7 or causes & ~7 or bool(flags & 4) != bool(causes):
        raise ValueError("capture status reserved or inconsistent fault bits")
    return CaptureEpochStatus(epoch=epoch, ready=bool(flags & 1), sealed=bool(flags & 2), faults=causes)


class DualMaskEpochGate:
    def __init__(self, *, epoch: int):
        CaptureEpochStatus(epoch=epoch, ready=False, sealed=False, faults=0)
        self._epoch = int(epoch)
        self._pending: DualMaskFrame | None = None
        self._invalid = False
        self._delivered = False

    def _check(self, status: CaptureEpochStatus):
        if self._invalid or self._delivered:
            raise ValueError("capture epoch is invalid or already delivered")
        if type(status) is not CaptureEpochStatus or status.epoch != self._epoch or not status.ready or status.faults:
            self._invalid = True
            raise ValueError("capture epoch status rejected")

    def stage(self, packet: bytes, *, status: CaptureEpochStatus, **expected) -> None:
        try:
            self._check(status)
            if self._pending is not None or expected.get("epoch") != self._epoch:
                raise ValueError("capture epoch cannot overwrite or change identity")
            self._pending = decode_dual_mask(packet, **expected)
        except Exception:
            self._invalid = True
            raise

    def release(self, read_status: Callable[[], CaptureEpochStatus]) -> DualMaskFrame | None:
        try:
            if self._pending is None or self._invalid or self._delivered:
                raise ValueError("capture epoch has no releasable frame")
            status = read_status()
            self._check(status)
            if not status.sealed:
                return None
            result = self._pending
            self._pending = None
            self._delivered = True
            return result
        except Exception:
            self._invalid = True
            raise


def decode_dual_mask(
    packet: bytes,
    *,
    width: int,
    height: int,
    frame_id: int,
    config_id: int,
    epoch: int,
    thresholds: tuple[int, ...],
) -> DualMaskFrame:
    if type(packet) is not bytes:
        raise ValueError("immutable ordinary-memory DMA snapshot required")
    values = (width, height, frame_id, config_id, epoch)
    if any(isinstance(value, bool) or not isinstance(value, Integral) for value in values):
        raise ValueError("integer geometry and identity required")
    if not (1 <= width <= 640 and 1 <= height <= 360):
        raise ValueError("DMS1 geometry outside capability")
    if any(not 0 <= value <= 0xFFFFFFFF for value in (frame_id, config_id, epoch)):
        raise ValueError("DMS1 identity must be uint32")
    if len(thresholds) != 6 or any(
        isinstance(value, bool) or not isinstance(value, Integral) or not 0 <= value <= 255
        for value in thresholds
    ):
        raise ValueError("six threshold bytes required")
    pixels = int(width) * int(height)
    payload_bytes = ((pixels + 1) // 2) * 4
    if len(packet) != payload_bytes + TRAILER.size:
        raise ValueError("DMS1 exact packet length mismatch")
    tail = TRAILER.unpack_from(packet, payload_bytes)
    threshold_bytes = bytes(thresholds)
    expected = (
        MAGIC, VERSION_LENGTH, int(frame_id), int(config_id), int(epoch),
        (int(height) << 16) | int(width), pixels, payload_bytes, 0,
        int.from_bytes(threshold_bytes[:4], "little"),
        int.from_bytes(threshold_bytes[4:], "little"), PAIR_FORMAT, 0, 0, 0,
    )
    if tail[:15] != expected:
        raise ValueError("DMS1 version/identity/geometry/count/status/config mismatch")
    if zlib.crc32(memoryview(packet)[:-4]) != tail[15]:
        raise ValueError("DMS1 CRC32 mismatch")
    payload = np.frombuffer(packet, dtype=np.uint8, count=payload_bytes)
    if np.any(payload[pixels * 2:] != 0):
        raise ValueError("DMS1 nonzero padding")
    pairs = payload[:pixels * 2].reshape(int(height), int(width), 2)
    if np.any((pairs[:, :, 0] != 0) & (pairs[:, :, 0] != 255)):
        raise ValueError("DMS1 raw mask is not binary")
    return DualMaskFrame(
        raw=pairs[:, :, 0].copy(), filtered=pairs[:, :, 1].copy(),
        frame_id=int(frame_id), config_id=int(config_id), epoch=int(epoch),
        thresholds=tuple(int(value) for value in thresholds),
    )