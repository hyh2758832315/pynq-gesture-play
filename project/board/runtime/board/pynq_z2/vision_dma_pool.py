"""SG descriptor contracts and token-guarded three-slot packet DMA ring."""

from dataclasses import dataclass
from numbers import Integral
import math
import struct
import time

import numpy as np

from .dual_mask_packet import CaptureEpochStatus, DualMaskFrame, decode_dual_mask
from .vision_capture_control import VisionFrameOwnerControl, VisionFrameToken, capture_context_words


_DESCRIPTOR = struct.Struct("<16I")
_COMPLETE_FRAME = 0x8C000000
RGB_FRAME_BYTES = 1280 * 720 * 3
DUAL_MASK_PACKET_BYTES = 640 * 360 * 2 + 64
_VDMA_ERRORS = 0xC9F0


@dataclass(frozen=True)
class VisionCaptureFrame(DualMaskFrame):
    rgb: bytes | None = None


def _reset_stalled_s2mm(read32, write32, error_mask: int, timeout: float) -> None:
    """Recover a sealed SG receive channel whose normal halt cannot finish."""
    control, status = read32(0x30), read32(0x34)
    if control & 5 or status & error_mask or status & 8 != 8:
        raise RuntimeError("S2MM soft reset requires stopped, error-free SG channel")
    write32(0x30, control | 4)
    deadline = time.monotonic() + timeout
    while True:
        control, status = read32(0x30), read32(0x34)
        if not control & 4 and not control & 5 and status & 9 == 9 and not status & error_mask:
            return
        if time.monotonic() >= deadline:
            raise TimeoutError("S2MM soft reset not confirmed; resources retained")
        time.sleep(0.0001)


def _halt_s2mm(read32, write32, error_mask: int, timeout: float,
               *, reset_on_timeout: bool = False) -> str:
    if isinstance(timeout, bool) or not math.isfinite(timeout) or timeout <= 0:
        raise ValueError("positive finite S2MM halt timeout required")
    control = read32(0x30)
    if control & 5 != 1 or read32(0x34) & error_mask:
        raise RuntimeError("S2MM state changed before halt")
    write32(0x30, control & ~1)
    deadline = time.monotonic() + timeout
    stop_mode = "halt"
    while True:
        status = read32(0x34)
        if status & error_mask:
            raise RuntimeError("S2MM error during halt")
        if status & 1:
            break
        if time.monotonic() >= deadline:
            if not reset_on_timeout:
                raise TimeoutError("S2MM halt not confirmed; resources retained")
            _reset_stalled_s2mm(read32, write32, error_mask, timeout)
            stop_mode = "reset-after-halt-timeout"
            break
        time.sleep(0.0001)
    if read32(0x30) & 5:
        raise RuntimeError("S2MM control did not stop")
    return stop_mode


def _require_sealed(owner: VisionFrameOwnerControl, status: CaptureEpochStatus) -> None:
    if type(status) is not CaptureEpochStatus or not status.ready or not status.sealed or status.faults:
        raise RuntimeError("DMA halt requires a sealed error-free epoch")
    owner.require_drained(status.epoch)


@dataclass(frozen=True)
class VisionSgDescriptor:
    next_address: int
    buffer_address: int
    buffer_bytes: int

    def __post_init__(self) -> None:
        values = (self.next_address, self.buffer_address, self.buffer_bytes)
        if any(isinstance(value, bool) or not isinstance(value, Integral) for value in values):
            raise ValueError("SG descriptor requires integer addresses and length")
        if not 0 <= self.next_address <= 0xFFFFFFFF or self.next_address % 64:
            raise ValueError("SG next descriptor requires a 64-byte aligned uint32 address")
        if not 0 <= self.buffer_address <= 0xFFFFFFFF or self.buffer_address % 8:
            raise ValueError("SG buffer requires an 8-byte aligned uint32 address")
        if not 1 <= self.buffer_bytes < 1 << 26:
            raise ValueError("SG buffer length requires a nonzero 26-bit value")
        if self.buffer_address + self.buffer_bytes > 1 << 32:
            raise ValueError("SG buffer crosses the uint32 address space")

    def pack(self) -> bytes:
        return _DESCRIPTOR.pack(int(self.next_address), 0, int(self.buffer_address), 0,
                                0, 0, int(self.buffer_bytes), *([0] * 9))

    def completed_bytes(self, snapshot: bytes) -> int | None:
        if type(snapshot) is not bytes or len(snapshot) != _DESCRIPTOR.size:
            raise ValueError("SG completion requires an immutable 64-byte snapshot")
        words = _DESCRIPTOR.unpack(snapshot)
        if words[:7] != _DESCRIPTOR.unpack(self.pack())[:7] or any(words[8:]):
            raise ValueError("SG descriptor address, control or reserved words changed")
        if words[7] == 0:
            return None
        if words[7] != _COMPLETE_FRAME | int(self.buffer_bytes):
            raise ValueError("SG completion is not one error-free exact-length frame")
        return int(self.buffer_bytes)


class VisionPacketRing:
    def __init__(self, owner: VisionFrameOwnerControl, descriptors: tuple,
                 packets: tuple, read32, write32):
        if len(descriptors) != 3 or len(packets) != 3:
            raise ValueError("capture requires exactly three SG and packet slots")
        regions = []
        for buffers, alignment, exact_size in ((descriptors, 64, 64), (packets, 64, None)):
            for buffer in buffers:
                address, length = buffer.physical_address, memoryview(buffer).nbytes
                if (isinstance(address, bool) or not isinstance(address, Integral)
                        or address < 0 or address % alignment or address + length > 1 << 32
                        or length == 0 or exact_size is not None and length != exact_size):
                    raise ValueError("capture buffer physical range or alignment mismatch")
                regions.append((address, address + (length + 63) // 64 * 64))
        ordered = sorted(regions)
        if any(previous[1] > current[0] for previous, current in zip(ordered, ordered[1:])):
            raise ValueError("capture buffer physical ranges overlap")
        lengths = tuple(memoryview(buffer).nbytes for buffer in packets)
        if len(set(lengths)) != 1:
            raise ValueError("capture packet slots must have identical sizes")
        self._contracts = tuple(VisionSgDescriptor(
            descriptors[(slot + 1) % 3].physical_address, packet.physical_address, lengths[slot])
            for slot, packet in enumerate(packets))
        self._owner, self._descriptors, self._packets = owner, descriptors, packets
        self._read32, self._write32 = read32, write32
        self._state = "IDLE"
        self._snapshot_token = None
        self.stop_mode = None

    @property
    def state(self) -> str:
        return self._state

    def start(self) -> None:
        if self._state != "IDLE":
            raise RuntimeError("SG ring cannot be restarted or retried")
        self._state = "PREPARING"
        try:
            status, control = self._read32(0x34), self._read32(0x30)
            if status & 0x4770 or status & 9 != 9 or control & 5:
                raise RuntimeError("SG ring requires a halted error-free SG S2MM")
            for descriptor, packet, contract in zip(self._descriptors, self._packets, self._contracts):
                memoryview(descriptor).cast('B')[:] = contract.pack()
                packet.flush()
                descriptor.flush()
            self._write32(0x3C, 0)
            self._write32(0x38, self._descriptors[0].physical_address)
            self._write32(0x30, 0x10001)
            self._write32(0x44, 0)
            self._write32(0x40, self._descriptors[-1].physical_address)
            self._state = "RUNNING"
        except Exception:
            self._state = "RETAINED"
            raise


    def snapshot(self, token: VisionFrameToken) -> bytes:
        if self._state != "RUNNING" or self._snapshot_token is not None:
            raise RuntimeError("SG snapshot requires an unreused running slot")
        try:
            self._owner.require_held(token)
            if self._read32(0x34) & 0x4770:
                raise RuntimeError("packet DMA status contains errors")
            descriptor = self._descriptors[token.slot]
            descriptor.invalidate()
            if self._contracts[token.slot].completed_bytes(bytes(memoryview(descriptor))) is None:
                raise RuntimeError("claimed frame lacks SG completion")
            packet = self._packets[token.slot]
            packet.invalidate()
            result = bytes(memoryview(packet))
            self._owner.require_held(token)
            self._snapshot_token = token
            return result
        except Exception:
            self._state = "RETAINED"
            raise

    def rearm(self, token: VisionFrameToken) -> None:
        if self._state != "RUNNING" or token is None or token is not self._snapshot_token:
            raise RuntimeError("SG rearm requires this ring's snapshot token")
        try:
            self._owner.require_held(token)
            if self._read32(0x34) & 0x4770:
                raise RuntimeError("packet DMA fault before descriptor rearm")
            descriptor = self._descriptors[token.slot]
            memoryview(descriptor).cast('B')[:] = self._contracts[token.slot].pack()
            descriptor.flush()
            self._write32(0x40, descriptor.physical_address)
            self._snapshot_token = None
        except Exception:
            self._state = "RETAINED"
            raise

    def halt(self, status: CaptureEpochStatus, *, timeout: float = 2.0) -> None:
        if self._state != "RUNNING":
            raise RuntimeError("SG halt requires an unrepeated running ring")
        self._state = "HALTING"
        try:
            _require_sealed(self._owner, status)
            if self._snapshot_token is not None:
                raise RuntimeError("SG halt cannot abandon an unrearmed snapshot")
            self.stop_mode = _halt_s2mm(self._read32, self._write32, 0x4770, timeout,
                                        reset_on_timeout=True)
            self._owner.require_drained(status.epoch)
            self._state = "STOPPED"
        except Exception:
            self._state = "RETAINED"
            raise


class VisionRgbRing:
    def __init__(self, owner: VisionFrameOwnerControl, frames: tuple, read32, write32):
        if len(frames) != 3:
            raise ValueError("RGB capture requires exactly three frame slots")
        regions = []
        for frame in frames:
            address = frame.physical_address
            view = memoryview(frame)
            if (isinstance(address, bool) or not isinstance(address, Integral)
                    or address < 0 or address % 64 or address + RGB_FRAME_BYTES > 1 << 32
                    or view.nbytes != RGB_FRAME_BYTES or view.readonly or not view.c_contiguous):
                raise ValueError("RGB capture requires aligned contiguous 1280x720x3 buffers")
            regions.append((address, address + RGB_FRAME_BYTES))
        ordered = sorted(regions)
        if any(previous[1] > current[0] for previous, current in zip(ordered, ordered[1:])):
            raise ValueError("RGB frame physical ranges overlap")
        self._owner, self._frames = owner, frames
        self._read32, self._write32 = read32, write32
        self._state = "IDLE"
        self._snapshot_token = None

    @property
    def state(self) -> str:
        return self._state

    def start(self) -> None:
        if self._state != "IDLE":
            raise RuntimeError("RGB ring cannot be restarted or retried")
        self._state = "PREPARING"
        try:
            status, control = self._read32(0x34), self._read32(0x30)
            if status & _VDMA_ERRORS or not status & 1 or control & 5:
                raise RuntimeError("RGB ring requires a halted error-free S2MM")
            if self._read32(0x28) >> 24 & 0x1F:
                raise RuntimeError("RGB ring requires the initial frame store zero")
            for frame in self._frames:
                frame.flush()
            self._write32(0x30, 0x10003)
            settings = tuple((0xAC + slot * 4, frame.physical_address)
                             for slot, frame in enumerate(self._frames)) + ((0xA8, 3840), (0xA4, 3840), (0xA0, 720))
            for offset, value in settings:
                self._write32(offset, value)
            if (self._read32(0x30) & 0xFFFF != 3 or self._read32(0x34) & _VDMA_ERRORS
                    or any(self._read32(offset) != value for offset, value in settings)):
                raise RuntimeError("RGB ring configuration acknowledgement mismatch")
            self._state = "RUNNING"
        except Exception:
            self._state = "RETAINED"
            raise

    def snapshot(self, token: VisionFrameToken) -> bytes:
        if self._state != "RUNNING" or token is self._snapshot_token:
            raise RuntimeError("RGB snapshot requires an unreused running slot")
        try:
            self._owner.require_held(token)
            if self._read32(0x34) & _VDMA_ERRORS:
                raise RuntimeError("RGB DMA status contains errors")
            frame = self._frames[token.slot]
            frame.invalidate()
            result = bytes(memoryview(frame))
            self._owner.require_held(token)
            if self._read32(0x34) & _VDMA_ERRORS:
                raise RuntimeError("RGB DMA fault during snapshot")
            self._snapshot_token = token
            return result
        except Exception:
            self._state = "RETAINED"
            raise

    def halt(self, status: CaptureEpochStatus, *, timeout: float = 2.0) -> None:
        if self._state != "RUNNING":
            raise RuntimeError("RGB halt requires an unrepeated running ring")
        self._state = "HALTING"
        try:
            _require_sealed(self._owner, status)
            _halt_s2mm(self._read32, self._write32, _VDMA_ERRORS, timeout)
            self._owner.require_drained(status.epoch)
            self._state = "STOPPED"
        except Exception:
            self._state = "RETAINED"
            raise


class VisionCapturePool:
    def __init__(self, owner: VisionFrameOwnerControl, allocate, rgb_read32, rgb_write32,
                 packet_read32, packet_write32, read_status, *, timeout: float = 2.0):
        if isinstance(timeout, bool) or not math.isfinite(timeout) or timeout <= 0:
            raise ValueError("positive finite capture timeout required")
        self._owner, self._allocate, self._read_status = owner, allocate, read_status
        self._rgb_io, self._packet_io = (rgb_read32, rgb_write32), (packet_read32, packet_write32)
        self._timeout = timeout
        self._buffers = []
        self._state = "IDLE"
        self._epoch = self._config_id = 0
        self._thresholds = ()
        self.rgb = self.packets = None

    @property
    def state(self) -> str:
        return self._state

    def _new_buffer(self, shape):
        buffer = self._allocate(shape=shape, dtype=np.uint8)
        self._buffers.append(buffer)
        return buffer

    def _reject_epoch(self, reason, status):
        # Error path only: reads use the existing owner's handles; never a second MMIO owner.
        diagnostic = dict(expected_epoch=self._epoch, actual=repr(status), pool_state=self._state)
        try:
            diagnostic['owner_words'] = {hex(offset): int(self._owner._word(offset))
                for offset in (0x08, 0x4c, 0x50, 0x5c, 0x60, 0x64)}
            diagnostic['rgb_dma'] = {hex(offset): int(self._rgb_io[0](offset)) for offset in (0x30, 0x34)}
            diagnostic['packet_dma'] = {hex(offset): int(self._packet_io[0](offset)) for offset in (0x30, 0x34)}
        except Exception as error:
            diagnostic['read_error'] = repr(error)
        raise RuntimeError(reason + ': ' + repr(diagnostic))

    def _status(self) -> CaptureEpochStatus:
        status = self._read_status()
        if (type(status) is not CaptureEpochStatus or status.epoch != self._epoch
                or not status.ready or status.faults):
            self._reject_epoch("capture pool epoch status rejected", status)
        return status

    def start(self, *, epoch: int, config_id: int, thresholds: tuple[int, ...], frame_id: int = 1) -> None:
        capture_context_words(frame_id=frame_id, config_id=config_id, epoch=epoch, thresholds=thresholds)
        if frame_id == 0:
            raise ValueError("capture pool requires a nonzero first frame")
        if self._state != "IDLE":
            raise RuntimeError("capture pool cannot be restarted or retried")
        self._state = "PREPARING"
        try:
            initial = self._read_status()
            if type(initial) is not CaptureEpochStatus or initial != CaptureEpochStatus(0, False, False, 0):
                raise RuntimeError("capture pool requires fresh common reset status")
            frames = tuple(self._new_buffer((720, 1280, 3)) for _ in range(3))
            packets = tuple(self._new_buffer((DUAL_MASK_PACKET_BYTES,)) for _ in range(3))
            descriptors = tuple(self._new_buffer((64,)) for _ in range(3))
            self.rgb = VisionRgbRing(self._owner, frames, *self._rgb_io)
            self.packets = VisionPacketRing(self._owner, descriptors, packets, *self._packet_io)
            regions = sorted((buffer.physical_address,
                              buffer.physical_address + (memoryview(buffer).nbytes + 63) // 64 * 64)
                             for buffer in self._buffers)
            if any(previous[1] > current[0] for previous, current in zip(regions, regions[1:])):
                raise ValueError("capture pools share physical memory or cachelines")
            self._epoch, self._config_id, self._thresholds = epoch, config_id, thresholds
            self.rgb.start()
            self.packets.start()
            self._owner.arm(frame_id=frame_id, config_id=config_id, epoch=epoch, thresholds=thresholds)
            deadline = time.monotonic() + self._timeout
            while True:
                status = self._read_status()
                if type(status) is not CaptureEpochStatus or status.faults or status.sealed:
                    self._reject_epoch("capture epoch fault during ARM", status)
                if status.ready:
                    self._status()
                    break
                if status.epoch not in (0, epoch) or time.monotonic() >= deadline:
                    raise TimeoutError("capture epoch ARM not confirmed")
                time.sleep(0.0001)
            self._state = "RUNNING"
        except Exception:
            self._state = "RETAINED"
            raise

    def read(self, *, include_rgb: bool = False):
        if type(include_rgb) is not bool:
            raise ValueError("RGB snapshot demand must be bool")
        if self._state not in ("RUNNING", "DRAINING"):
            raise RuntimeError("capture pool is not running or draining")
        try:
            self._status()
            token = self._owner.claim()
            if token is None:
                return None
            packet = self.packets.snapshot(token)
            frame = decode_dual_mask(packet, width=640, height=360, frame_id=token.frame_id,
                                     config_id=self._config_id, epoch=self._epoch, thresholds=self._thresholds)
            if include_rgb:
                rgb = self.rgb.snapshot(token)
                frame = VisionCaptureFrame(frame.raw, frame.filtered, frame.frame_id, frame.config_id,
                                           frame.epoch, frame.thresholds, rgb)
            self._status()
            self.packets.rearm(token)
            self._owner.release(token)
            return frame
        except Exception:
            self._state = "RETAINED"
            raise

    def stop(self, on_frame) -> None:
        if self._state == "STOPPED":
            return
        if self._state != "RUNNING" or not callable(on_frame):
            raise RuntimeError("capture stop requires a running pool and a frame consumer")
        self._state = "DRAINING"
        try:
            self._owner.request_barrier()
            deadline = time.monotonic() + self._timeout
            while True:
                status = self._status()
                if status.sealed:
                    self._owner.require_drained(self._epoch)
                    break
                frame = self.read()
                if frame is not None:
                    on_frame(frame)
                if time.monotonic() >= deadline:
                    raise TimeoutError("capture barrier or owner drain not confirmed")
                if frame is None:
                    time.sleep(0.0001)
            self.packets.halt(status, timeout=self._timeout)
            self.rgb.halt(self._status(), timeout=self._timeout)
            if not self._status().sealed:
                raise RuntimeError("capture seal changed after DMA halt")
            self._owner.require_drained(self._epoch)
            for buffer in self._buffers:
                buffer.freebuffer()
            self._state = "STOPPED"
        except Exception:
            self._state = "RETAINED"
            raise
