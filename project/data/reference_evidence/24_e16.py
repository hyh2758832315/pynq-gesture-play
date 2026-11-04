"""Candidate AXI-Lite protocol; epoch allocation and DMA ownership stay external."""

from dataclasses import dataclass
from numbers import Integral
import struct
from threading import Lock
from typing import Callable


CAPTURE_CONTROL_MAGIC = 0x31435456
CAPTURE_CONTROL_ABI = 0x00010000
CAPTURE_OWNER_ABI = 0x00020000
CONTEXT_OFFSETS = (0x20, 0x24, 0x28, 0x2C, 0x30)


def capture_context_words(*, frame_id: int, config_id: int, epoch: int,
                          thresholds: tuple[int, ...]) -> tuple[int, ...]:
    if any(isinstance(value, bool) or not isinstance(value, Integral) or not 0 <= value <= 0xFFFFFFFF
           for value in (frame_id, config_id, epoch)) or epoch == 0:
        raise ValueError("capture identities require uint32 and a nonzero epoch")
    if type(thresholds) is not tuple or len(thresholds) != 6 or any(
            isinstance(value, bool) or not isinstance(value, Integral) or not 0 <= value <= 255
            for value in thresholds):
        raise ValueError("capture requires six threshold bytes")
    context = struct.pack("<6BIII", *thresholds, int(frame_id), int(config_id), int(epoch))
    return struct.unpack("<5I", context + bytes(2))


class VisionCaptureControl:
    _abi = CAPTURE_CONTROL_ABI

    def __init__(self, read32: Callable[[int], int], write32: Callable[[int, int], None]):
        self._read32 = read32
        self._write32 = write32
        self._state = "IDLE"
        self._flags = 0
        self._context: tuple[int, ...] = ()
        self._lock = Lock()

    def _word(self, offset: int) -> int:
        value = self._read32(offset)
        if isinstance(value, bool) or not isinstance(value, Integral) or not 0 <= value <= 0xFFFFFFFF:
            raise ValueError("capture control read must be uint32")
        return int(value)

    def _identity(self) -> None:
        if self._word(0) != CAPTURE_CONTROL_MAGIC or self._word(4) != self._abi:
            raise RuntimeError("capture control identity mismatch")

    def _context_matches(self) -> None:
        if self._word(0x0C) != 0x1F or tuple(self._word(offset) for offset in CONTEXT_OFFSETS) != self._context:
            raise RuntimeError("capture context readback mismatch")

    def arm(self, *, frame_id: int, config_id: int, epoch: int, thresholds: tuple[int, ...]) -> None:
        words = capture_context_words(frame_id=frame_id, config_id=config_id, epoch=epoch, thresholds=thresholds)
        with self._lock:
            if self._state != "IDLE":
                raise RuntimeError("capture control instance cannot be rearmed or retried")
            self._state = "ARMING"
            try:
                self._identity()
                if self._word(8) != 0 or self._word(0x0C) != 0:
                    raise RuntimeError("capture control requires a fresh common reset")
                self._context = words
                for offset, value in zip(CONTEXT_OFFSETS, words):
                    self._write32(offset, value)
                self._context_matches()
                self._write32(0x10, 1)
                if self._word(8) != 1:
                    raise RuntimeError("capture ARM acknowledgement mismatch")
                self._flags = 1
                self._state = "ARMED"
            except Exception:
                self._state = "FAULT"
                raise

    def _command(self, command: int) -> None:
        with self._lock:
            if self._state != "ARMED" or self._flags & command:
                raise RuntimeError("capture command requires an armed unrepeated transaction")
            self._state = "COMMAND"
            try:
                self._identity()
                self._context_matches()
                if self._word(8) != self._flags:
                    raise RuntimeError("capture control state changed outside this instance")
                self._write32(0x10, command)
                self._flags |= command
                if self._word(8) != self._flags:
                    raise RuntimeError("capture command acknowledgement mismatch")
                self._state = "ARMED"
            except Exception:
                self._state = "FAULT"
                raise

    def abort(self) -> None:
        self._command(2)

    def request_barrier(self) -> None:
        self._command(4)


@dataclass(frozen=True)
class VisionFrameToken:
    epoch: int
    frame_id: int
    slot: int


class VisionFrameOwnerControl(VisionCaptureControl):
    """ABI2 register ownership only; DMA/cache preparation remains the pool's duty."""

    _abi = CAPTURE_OWNER_ABI

    def __init__(self, read32: Callable[[int], int], write32: Callable[[int, int], None]):
        super().__init__(read32, write32)
        self._held_token: VisionFrameToken | None = None
        self._released = 0

    def _identity(self) -> None:
        super()._identity()
        if self._word(0x68) != 3:
            raise RuntimeError("capture owner capacity mismatch")

    def arm(self, *, frame_id: int, config_id: int, epoch: int, thresholds: tuple[int, ...]) -> None:
        capture_context_words(frame_id=frame_id, config_id=config_id, epoch=epoch, thresholds=thresholds)
        if frame_id == 0:
            raise ValueError("capture owner requires a nonzero first frame")
        super().arm(frame_id=frame_id, config_id=config_id, epoch=epoch, thresholds=thresholds)

    def _owner_state(self) -> int:
        self._identity()
        self._context_matches()
        if self._word(8) != self._flags:
            raise RuntimeError("capture control state changed outside this instance")
        status = self._word(0x4C)
        if status & ~7 or (status & 2 and status & 5) or status & 5 == 5:
            raise RuntimeError("capture owner is faulted, pending or inconsistent")
        granted = self._word(0x5C)
        released = self._word(0x60)
        if released != self._released or not released <= granted <= released + 3:
            raise RuntimeError("capture owner counters changed outside this instance")
        if status & 1 and granted == released:
            raise RuntimeError("capture owner availability without completed frame")
        if status & 4 and granted != released:
            raise RuntimeError("capture owner drain with outstanding frames")
        return status

    def _owner_command(self, token: VisionFrameToken, command: int) -> None:
        self._write32(0x40, token.epoch)
        self._write32(0x44, token.frame_id)
        self._write32(0x48, command)

    def require_held(self, token: VisionFrameToken) -> None:
        with self._lock:
            if self._state != "ARMED" or token is None or token is not self._held_token:
                raise RuntimeError("capture memory requires this instance's held token")
            try:
                if self._owner_state() != 2:
                    raise RuntimeError("capture owner no longer holds the claimed frame")
            except Exception:
                self._state = "FAULT"
                raise

    def require_drained(self, epoch: int) -> None:
        with self._lock:
            if self._state != "ARMED" or not self._flags & 4 or self._held_token is not None:
                raise RuntimeError("capture drain requires a barrier without a held frame")
            try:
                expected_epoch = struct.unpack_from("<III", struct.pack("<5I", *self._context), 6)[2]
                if (isinstance(epoch, bool) or not isinstance(epoch, Integral)
                        or epoch != expected_epoch or self._owner_state() != 4):
                    raise RuntimeError("capture owner drain or epoch mismatch")
            except Exception:
                self._state = "FAULT"
                raise

    def claim(self) -> VisionFrameToken | None:
        with self._lock:
            if self._state != "ARMED" or self._held_token is not None:
                raise RuntimeError("capture owner requires an armed instance without a held frame")
            try:
                status = self._owner_state()
                if status & 2:
                    raise RuntimeError("capture owner has an external CPU claim")
                if not status & 1:
                    return None
                first_frame, _, epoch = struct.unpack_from("<III", struct.pack("<5I", *self._context), 6)
                frame_id = first_frame + self._released
                slot = self._released % 3
                if frame_id > 0xFFFFFFFF or (
                        self._word(0x50), self._word(0x54), self._word(0x58)) != (epoch, frame_id, slot):
                    raise RuntimeError("capture owner frame token mismatch")
                token = VisionFrameToken(epoch, frame_id, slot)
                self._held_token = token
                self._owner_command(token, 1)
                if self._owner_state() != 2:
                    raise RuntimeError("capture owner claim acknowledgement mismatch")
                return token
            except Exception:
                self._state = "FAULT"
                raise

    def release(self, token: VisionFrameToken) -> None:
        with self._lock:
            if self._state != "ARMED" or token is not self._held_token or token is None:
                raise RuntimeError("capture owner release requires this instance's held token")
            try:
                if self._owner_state() != 2:
                    raise RuntimeError("capture owner no longer holds the claimed frame")
                self._owner_command(token, 2)
                self._released += 1
                if self._owner_state() & 2:
                    raise RuntimeError("capture owner release acknowledgement mismatch")
                self._held_token = None
            except Exception:
                self._state = "FAULT"
                raise