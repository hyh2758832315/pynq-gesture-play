import csv
import os
from pathlib import Path
import struct
import zlib

import numpy as np
import pytest

from board.pynq_z2.dual_mask_packet import (
    MAGIC, PAIR_FORMAT, TRAILER, VERSION_LENGTH, CaptureEpochStatus, DualMaskEpochGate, decode_dual_mask,
    CAPTURE_STATUS_ABI, CAPTURE_STATUS_MAGIC, read_capture_epoch_status,
)
from board.pynq_z2.vision_capture_control import (
    CAPTURE_CONTROL_ABI, CAPTURE_CONTROL_MAGIC, CAPTURE_OWNER_ABI, CONTEXT_OFFSETS,
    VisionCaptureControl, VisionFrameOwnerControl, VisionFrameToken, capture_context_words,
)
from board.pynq_z2.vision_dma_pool import (
    RGB_FRAME_BYTES, VisionCapturePool, VisionPacketRing, VisionRgbRing, VisionSgDescriptor,
)


BOUNDS = (0x54, 0x76, 0x98, 0xBA, 0xDC, 0xFE)


def test_vision_sg_descriptor_matches_production_layout_and_clears_complete():
    descriptor = VisionSgDescriptor(0x100040, 0x200008, 96)
    original = descriptor.pack()
    assert len(original) == 64
    assert struct.unpack('<16I', original) == (0x100040, 0, 0x200008, 0, 0, 0, 96, *([0]*9))
    assert descriptor.completed_bytes(original) is None
    completed = bytearray(original)
    struct.pack_into('<I', completed, 0x1C, 0x8C000060)
    assert descriptor.completed_bytes(bytes(completed)) == 96
    assert descriptor.pack() == original
    assert struct.unpack_from('<I', descriptor.pack(), 0x1C) == (0,)


@pytest.mark.parametrize('changes', (
    {'next_address': True}, {'next_address': 1.0}, {'next_address': -64},
    {'next_address': 1 << 32}, {'next_address': 0x100020},
    {'buffer_address': False}, {'buffer_address': -8},
    {'buffer_address': 1 << 32}, {'buffer_address': 0x200004},
    {'buffer_bytes': True}, {'buffer_bytes': 1.5}, {'buffer_bytes': 0},
    {'buffer_bytes': -1}, {'buffer_bytes': 1 << 26},
    {'buffer_address': 0xFFFFFFF8, 'buffer_bytes': 9},
))
def test_vision_sg_descriptor_rejects_invalid_memory_contract(changes):
    arguments = dict(next_address=0x100040, buffer_address=0x200008, buffer_bytes=96)
    arguments.update(changes)
    with pytest.raises(ValueError):
        VisionSgDescriptor(**arguments)


@pytest.mark.parametrize('word', (*range(7), *range(8, 16)))
def test_vision_sg_descriptor_rejects_corrupted_descriptor_words(word):
    descriptor = VisionSgDescriptor(0x100040, 0x200008, 96)
    words = list(struct.unpack('<16I', descriptor.pack()))
    words[7] = 0x8C000060
    words[word] ^= 1
    with pytest.raises(ValueError):
        descriptor.completed_bytes(struct.pack('<16I', *words))


@pytest.mark.parametrize('status', (1, 0x80000060, 0x84000060, 0x88000060,
                                  0x8C00005F, 0x8C000061, 0x9C000060,
                                  0xAC000060, 0xCC000060, 0xFC000060))
def test_vision_sg_descriptor_rejects_inexact_frame_or_transfer_errors(status):
    descriptor = VisionSgDescriptor(0x100040, 0x200008, 96)
    words = list(struct.unpack('<16I', descriptor.pack()))
    words[7] = status
    with pytest.raises(ValueError):
        descriptor.completed_bytes(struct.pack('<16I', *words))


@pytest.mark.parametrize('snapshot', (bytes(63), bytes(65), bytearray(64), memoryview(bytes(64))))
def test_vision_sg_descriptor_requires_immutable_exact_snapshot(snapshot):
    with pytest.raises(ValueError):
        VisionSgDescriptor(0x100040, 0x200008, 96).completed_bytes(snapshot)


class CaptureControlRegisters:
    def __init__(self):
        self.values = {0: CAPTURE_CONTROL_MAGIC, 4: CAPTURE_CONTROL_ABI, 8: 0, 12: 0}
        self.writes = []
        self.fail_write = None
        self.corrupt_context = False
        self.acknowledge = True

    def read(self, offset):
        if self.corrupt_context and offset == 0x24:
            return self.values.get(offset, 0) ^ 1
        return self.values.get(offset, 0)

    def write(self, offset, value):
        self.writes.append((offset, value))
        if self.fail_write == offset:
            raise OSError('injected control write failure')
        if offset in CONTEXT_OFFSETS:
            self.values[offset] = value
            self.values[12] |= 1 << CONTEXT_OFFSETS.index(offset)
        elif offset == 0x10 and self.acknowledge:
            self.values[8] |= value


def test_capture_control_context_matches_rtl_144bit_layout():
    words = capture_context_words(frame_id=0x10203000, config_id=0x40506000,
                                  epoch=0x70809000, thresholds=BOUNDS)
    assert words == (0xBA987654, 0x3000FEDC, 0x60001020, 0x90004050, 0x7080)
    assert struct.pack('<5I', *words)[:18] == struct.pack('<6BIII', *BOUNDS, 0x10203000, 0x40506000, 0x70809000)


@pytest.mark.parametrize('changes', (
    {'frame_id': True}, {'frame_id': -1}, {'config_id': 1 << 32},
    {'epoch': 0}, {'epoch': False}, {'epoch': 1.5},
    {'thresholds': ()}, {'thresholds': list(BOUNDS)},
    {'thresholds': BOUNDS[:-1] + (256,)}, {'thresholds': BOUNDS[:-1] + (True,)},
))
def test_capture_control_rejects_context_before_io(changes):
    registers = CaptureControlRegisters()
    control = VisionCaptureControl(registers.read, registers.write)
    arguments = dict(frame_id=1, config_id=2, epoch=3, thresholds=BOUNDS)
    arguments.update(changes)
    with pytest.raises(ValueError):
        control.arm(**arguments)
    assert not registers.writes
    control.arm(frame_id=1, config_id=2, epoch=3, thresholds=BOUNDS)


@pytest.mark.parametrize('commands', ((2, 4), (4, 2)))
def test_capture_control_arm_abort_barrier_are_once_only_without_reset(commands):
    registers = CaptureControlRegisters()
    control = VisionCaptureControl(registers.read, registers.write)
    control.arm(frame_id=1, config_id=2, epoch=3, thresholds=BOUNDS)
    assert [offset for offset, value in registers.writes] == [*CONTEXT_OFFSETS, 0x10]
    for command in commands:
        method = control.abort if command == 2 else control.request_barrier
        method()
        count = len(registers.writes)
        with pytest.raises(RuntimeError):
            method()
        assert len(registers.writes) == count
    assert registers.values[8] == 7
    assert registers.writes[-2:] == [(0x10, commands[0]), (0x10, commands[1])]
    with pytest.raises(RuntimeError):
        control.arm(frame_id=2, config_id=2, epoch=4, thresholds=BOUNDS)
    assert len(registers.writes) == 8


@pytest.mark.parametrize('fault', ('magic', 'abi', 'armed', 'configured', 'write', 'context', 'ack', 'word'))
def test_capture_control_fault_never_replays_or_resets(fault):
    registers = CaptureControlRegisters()
    if fault == 'magic':
        registers.values[0] ^= 1
    elif fault == 'abi':
        registers.values[4] ^= 1
    elif fault == 'armed':
        registers.values[8] = 1
    elif fault == 'configured':
        registers.values[12] = 1
    elif fault == 'write':
        registers.fail_write = 0x24
    elif fault == 'context':
        registers.corrupt_context = True
    elif fault == 'ack':
        registers.acknowledge = False
    elif fault == 'word':
        registers.values[0] = True
    control = VisionCaptureControl(registers.read, registers.write)
    with pytest.raises((ValueError, RuntimeError, OSError)):
        control.arm(frame_id=1, config_id=2, epoch=3, thresholds=BOUNDS)
    count = len(registers.writes)
    for action in (lambda: control.arm(frame_id=1, config_id=2, epoch=3, thresholds=BOUNDS),
                   control.abort, control.request_barrier):
        with pytest.raises(RuntimeError):
            action()
    assert len(registers.writes) == count


@pytest.mark.parametrize('fault', ('external_reset', 'context', 'ack', 'write'))
def test_capture_control_command_fault_prevents_reuse(fault):
    registers = CaptureControlRegisters()
    control = VisionCaptureControl(registers.read, registers.write)
    control.arm(frame_id=1, config_id=2, epoch=3, thresholds=BOUNDS)
    if fault == 'external_reset':
        registers.values[8] = 0
    elif fault == 'context':
        registers.corrupt_context = True
    elif fault == 'ack':
        registers.acknowledge = False
    elif fault == 'write':
        registers.fail_write = 0x10
    with pytest.raises((RuntimeError, OSError)):
        control.request_barrier()
    count = len(registers.writes)
    with pytest.raises(RuntimeError):
        control.abort()
    assert len(registers.writes) == count


class CaptureOwnerRegisters(CaptureControlRegisters):
    def __init__(self):
        super().__init__()
        self.values.update({4: CAPTURE_OWNER_ABI, 0x68: 3, 0x4C: 1, 0x50: 3,
                            0x54: 1, 0x58: 0, 0x5C: 3, 0x60: 0})
        self.owner_acknowledge = True

    def write(self, offset, value):
        super().write(offset, value)
        if offset in (0x40, 0x44):
            self.values[offset] = value
        if offset == 0x48 and self.owner_acknowledge:
            assert (self.values[0x40], self.values[0x44]) == (3, self.values[0x54])
            if value == 1:
                assert self.values[0x4C] == 1
                self.values[0x4C] = 2
            elif value == 2:
                assert self.values[0x4C] == 2
                released = self.values[0x60] + 1
                self.values.update({0x60: released, 0x5C: min(7, released+3),
                                    0x54: released+1, 0x58: released % 3, 0x4C: 1 if released < 7 else 4})


def armed_owner_control():
    registers = CaptureOwnerRegisters()
    control = VisionFrameOwnerControl(registers.read, registers.write)
    control.arm(frame_id=1, config_id=2, epoch=3, thresholds=BOUNDS)
    return registers, control


class CaptureBuffer(bytearray):
    def __init__(self, size, address, events):
        super().__init__(size)
        self.physical_address, self.events = address, events

    def flush(self):
        self.events.append(('flush', self.physical_address))

    def invalidate(self):
        self.events.append(('invalidate', self.physical_address))

    def freebuffer(self):
        self.events.append(('free', self.physical_address))


def packet_ring_fixture():
    registers, owner = armed_owner_control()
    events = []
    descriptors = tuple(CaptureBuffer(64, 0x100000 + slot*64, events) for slot in range(3))
    packets = tuple(CaptureBuffer(96, 0x200000 + slot*128, events) for slot in range(3))
    ring = VisionPacketRing(owner, descriptors, packets, lambda offset: 9 if offset == 0x34 else 0,
                            lambda offset, value: events.append(('write', offset, value)))
    return registers, owner, ring, descriptors, packets, events


def test_packet_ring_seven_frames_cache_order_and_no_replay():
    _, owner, ring, descriptors, packets, events = packet_ring_fixture()
    ring.start()
    assert events[:6] == [event for slot in range(3) for event in (
        ('flush', packets[slot].physical_address), ('flush', descriptors[slot].physical_address))]
    assert events[6:] == [('write', 0x3C, 0), ('write', 0x38, 0x100000),
                          ('write', 0x30, 0x10001), ('write', 0x44, 0), ('write', 0x40, 0x100080)]
    for frame_id in range(1, 8):
        token = owner.claim()
        descriptor, packet = descriptors[token.slot], packets[token.slot]
        struct.pack_into('<I', descriptor, 0x1C, 0x8C000060)
        packet[:] = bytes([frame_id])*96
        count = len(events)
        assert ring.snapshot(token) == bytes([frame_id])*96
        assert events[count:] == [('invalidate', descriptor.physical_address), ('invalidate', packet.physical_address)]
        with pytest.raises(RuntimeError):
            ring.snapshot(token)
        ring.rearm(token)
        assert struct.unpack_from('<I', descriptor, 0x1C) == (0,)
        assert events[-2:] == [('flush', descriptor.physical_address), ('write', 0x40, descriptor.physical_address)]
        count = len(events)
        with pytest.raises(RuntimeError):
            ring.rearm(token)
        assert len(events) == count
        owner.release(token)
    assert ring.state == 'RUNNING'


@pytest.mark.parametrize('fault', ('unclaimed', 'incomplete', 'dma_error', 'cache_error'))
def test_packet_ring_failure_retains_resources_without_retry(fault):
    _, owner, ring, descriptors, packets, events = packet_ring_fixture()
    ring.start()
    token = owner.claim()
    struct.pack_into('<I', descriptors[0], 0x1C, 0x8C000060)
    if fault == 'unclaimed':
        token = VisionFrameToken(token.epoch, token.frame_id, token.slot)
    elif fault == 'incomplete':
        struct.pack_into('<I', descriptors[0], 0x1C, 0)
    elif fault == 'dma_error':
        ring._read32 = lambda offset: 0x10
    else:
        def fail_cache():
            raise RuntimeError('cache invalidate failed')
        packets[0].invalidate = fail_cache
    count = len(events)
    with pytest.raises(RuntimeError):
        ring.snapshot(token)
    assert ring.state == 'RETAINED'
    assert not any(event[0] == 'write' for event in events[count:])
    count = len(events)
    with pytest.raises(RuntimeError):
        ring.snapshot(token)
    with pytest.raises(RuntimeError):
        ring.start()
    assert len(events) == count


def test_packet_ring_rearm_new_dma_error_preserves_completed_descriptor():
    _, owner, ring, descriptors, _, events = packet_ring_fixture()
    ring.start()
    token = owner.claim()
    struct.pack_into('<I', descriptors[0], 0x1C, 0x8C000060)
    ring.snapshot(token)
    ring._read32 = lambda offset: 0x10
    count = len(events)
    with pytest.raises(RuntimeError, match='fault before'):
        ring.rearm(token)
    assert ring.state == 'RETAINED'
    assert struct.unpack_from('<I', descriptors[0], 0x1C) == (0x8C000060,)
    assert len(events) == count


@pytest.mark.parametrize('address', (0x200008, 0x200040, 0x100000))
def test_packet_ring_rejects_shared_cacheline_and_descriptor_alias(address):
    _, owner, _, descriptors, packets, events = packet_ring_fixture()
    packets[1].physical_address = address
    with pytest.raises(ValueError):
        VisionPacketRing(owner, descriptors, packets, lambda offset: 9, lambda *args: None)
    assert events == []


def rgb_ring_fixture():
    registers, owner = armed_owner_control()
    events = []
    frames = tuple(CaptureBuffer(RGB_FRAME_BYTES, 0x1000000 + slot * 0x300000, events) for slot in range(3))
    dma = {0x34: 1, 0x30: 2, 0x28: 0}

    def write(offset, value):
        events.append(('write', offset, value))
        dma[offset] = value

    ring = VisionRgbRing(owner, frames, lambda offset: dma.get(offset, 0), write)
    return registers, owner, ring, frames, dma, events


def test_rgb_ring_programs_three_full_resolution_frames_vsize_last():
    _, owner, ring, frames, _, events = rgb_ring_fixture()
    ring.start()
    assert ring.state == 'RUNNING'
    assert events[:3] == [('flush', frame.physical_address) for frame in frames]
    assert events[3:] == [('write', 0x30, 0x10003), ('write', 0xAC, 0x1000000),
                          ('write', 0xB0, 0x1300000), ('write', 0xB4, 0x1600000),
                          ('write', 0xA8, 3840), ('write', 0xA4, 3840), ('write', 0xA0, 720)]
    for frame_id in range(1, 8):
        token = owner.claim()
        frames[token.slot][0] = frame_id
        snapshot = ring.snapshot(token)
        assert len(snapshot) == 0x2A3000 and snapshot[0] == frame_id
        assert events[-1] == ('invalidate', frames[token.slot].physical_address)
        with pytest.raises(RuntimeError):
            ring.snapshot(token)
        owner.release(token)
        frames[token.slot][0] = 0
        assert snapshot[0] == frame_id


@pytest.mark.parametrize('fault', ('unclaimed', 'dma_error', 'cache_error'))
def test_rgb_ring_snapshot_fault_retains_without_reset_or_retry(fault):
    _, owner, ring, frames, dma, events = rgb_ring_fixture()
    ring.start()
    token = owner.claim()
    if fault == 'unclaimed':
        token = VisionFrameToken(token.epoch, token.frame_id, token.slot)
    elif fault == 'dma_error':
        dma[0x34] = 0x10
    else:
        def fail_cache():
            raise RuntimeError('injected RGB cache failure')
        frames[0].invalidate = fail_cache
    count = len(events)
    with pytest.raises(RuntimeError):
        ring.snapshot(token)
    assert ring.state == 'RETAINED'
    with pytest.raises(RuntimeError):
        ring.start()
    assert len(events) == count


@pytest.mark.parametrize('fault', ('running', 'resetting', 'status', 'store', 'ack'))
def test_rgb_ring_start_fault_is_not_retried(fault):
    _, _, ring, _, dma, events = rgb_ring_fixture()
    if fault == 'running':
        dma[0x30] = 3
    elif fault == 'resetting':
        dma[0x30] = 6
    elif fault == 'status':
        dma[0x34] = 0x81
    elif fault == 'store':
        dma[0x28] = 1 << 24
    else:
        original_write = ring._write32

        def corrupt_write(offset, value):
            original_write(offset, value ^ 1 if offset == 0xA4 else value)
        ring._write32 = corrupt_write
    with pytest.raises(RuntimeError):
        ring.start()
    assert ring.state == 'RETAINED'
    count = len(events)
    with pytest.raises(RuntimeError):
        ring.start()
    assert len(events) == count


def drain_owner_fixture(owner):
    owner.request_barrier()
    for _ in range(7):
        owner.release(owner.claim())


def test_rgb_halt_requires_seal_and_owner_drain_without_reset():
    _, owner, ring, _, dma, events = rgb_ring_fixture()
    ring.start()
    drain_owner_fixture(owner)
    ring.halt(CaptureEpochStatus(3, True, True, 0))
    assert ring.state == 'STOPPED' and dma[0x30] == 0x10002
    assert events[-1] == ('write', 0x30, 0x10002)
    count = len(events)
    with pytest.raises(RuntimeError):
        ring.halt(CaptureEpochStatus(3, True, True, 0))
    assert len(events) == count


@pytest.mark.parametrize('fault', ('unsealed', 'epoch', 'source_fault', 'held', 'no_barrier', 'timeout', 'dma_error'))
def test_rgb_halt_fault_retains_without_free_reset_or_retry(fault):
    _, owner, ring, _, dma, events = rgb_ring_fixture()
    ring.start()
    status = CaptureEpochStatus(3, True, True, 0)
    if fault == 'held':
        owner.request_barrier()
        owner.claim()
    elif fault != 'no_barrier':
        drain_owner_fixture(owner)
    if fault == 'unsealed':
        status = CaptureEpochStatus(3, True, False, 0)
    elif fault == 'epoch':
        status = CaptureEpochStatus(4, True, True, 0)
    elif fault == 'source_fault':
        status = CaptureEpochStatus(3, True, True, 1)
    elif fault == 'timeout':
        dma[0x34] = 0
    elif fault == 'dma_error':
        dma[0x34] = 0x8001
    count = len(events)
    with pytest.raises((RuntimeError, TimeoutError)):
        ring.halt(status, timeout=0.001)
    assert ring.state == 'RETAINED'
    assert events[count:] == ([('write', 0x30, 0x10002)] if fault == 'timeout' else [])
    count = len(events)
    with pytest.raises(RuntimeError):
        ring.halt(status)
    assert len(events) == count


def test_owner_rejects_drained_flag_with_outstanding_frames():
    registers, owner = armed_owner_control()
    owner.request_barrier()
    registers.values[0x4C] = 4
    with pytest.raises(RuntimeError, match='outstanding'):
        owner.require_drained(3)


def test_capture_owner_control_seven_frames_three_slots_no_replay():
    registers, control = armed_owner_control()
    for frame_id in range(1, 8):
        token = control.claim()
        assert token == VisionFrameToken(3, frame_id, (frame_id-1) % 3)
        count = len(registers.writes)
        with pytest.raises(RuntimeError):
            control.claim()
        with pytest.raises(RuntimeError):
            control.release(VisionFrameToken(token.epoch, token.frame_id, token.slot))
        assert len(registers.writes) == count
        control.release(token)
        count = len(registers.writes)
        with pytest.raises(RuntimeError):
            control.release(token)
        assert len(registers.writes) == count
    assert registers.values[0x60] == 7
    assert control.claim() is None
    assert len(registers.writes) == 48
    assert [value for offset, value in registers.writes if offset == 0x48] == [1, 2]*7


@pytest.mark.parametrize('offset,value', ((4, CAPTURE_CONTROL_ABI), (0x68, 4)))
def test_capture_owner_control_rejects_identity_before_writes(offset, value):
    registers = CaptureOwnerRegisters()
    registers.values[offset] = value
    control = VisionFrameOwnerControl(registers.read, registers.write)
    with pytest.raises(RuntimeError):
        control.arm(frame_id=1, config_id=2, epoch=3, thresholds=BOUNDS)
    assert not registers.writes


def test_capture_owner_control_zero_frame_rejected_before_io():
    registers = CaptureOwnerRegisters()
    control = VisionFrameOwnerControl(registers.read, registers.write)
    with pytest.raises(ValueError):
        control.arm(frame_id=0, config_id=2, epoch=3, thresholds=BOUNDS)
    assert not registers.writes
    legacy = VisionCaptureControl(registers.read, registers.write)
    with pytest.raises(RuntimeError):
        legacy.arm(frame_id=1, config_id=2, epoch=3, thresholds=BOUNDS)
    assert not registers.writes


@pytest.mark.parametrize('offset,value', ((0x4C, 8), (0x4C, 16), (0x4C, 32), (0x4C, 3),
    (0x4C, 5), (0x4C, 6), (0x4C, True), (0x4C, 2), (0x50, 4), (0x54, 2), (0x58, 1),
    (0x5C, 4), (0x5C, 0), (0x60, 1), (8, 0), (0x24, 0)))
def test_capture_owner_control_bad_state_poison_no_retry(offset, value):
    registers, control = armed_owner_control()
    registers.values[offset] = value
    count = len(registers.writes)
    with pytest.raises((RuntimeError, ValueError)):
        control.claim()
    with pytest.raises(RuntimeError):
        control.claim()
    assert len(registers.writes) == count


@pytest.mark.parametrize('operation', ('claim', 'release'))
@pytest.mark.parametrize('offset', (0x40, 0x44, 0x48, None))
def test_capture_owner_control_command_fault_retains_and_never_replays(operation, offset):
    registers, control = armed_owner_control()
    token = control.claim() if operation == 'release' else None
    registers.fail_write = offset
    registers.owner_acknowledge = offset is not None
    with pytest.raises((OSError, RuntimeError)):
        control.release(token) if operation == 'release' else control.claim()
    count = len(registers.writes)
    with pytest.raises(RuntimeError):
        control.claim()
    with pytest.raises(RuntimeError):
        control.release(token)
    assert len(registers.writes) == count
    assert control._held_token is not None


def test_capture_owner_control_empty_poll_does_not_issue_command():
    registers, control = armed_owner_control()
    registers.values[0x4C] = 0
    count = len(registers.writes)
    assert control.claim() is None
    assert len(registers.writes) == count
    registers.values[0x4C] = 1
    token = control.claim()
    control.abort()
    control.request_barrier()
    control.release(token)
    assert registers.values[8] == 7 and registers.values[0x60] == 1


def expected_arguments(width=3, height=3, frame=0):
    return dict(width=width, height=height, frame_id=0x10203000 + frame,
                config_id=0x40506000 + frame, epoch=0x70809000 + frame, thresholds=BOUNDS)


def expected_masks(width, height, frame):
    indices = np.arange(width * height, dtype=np.uint32).reshape(height, width)
    return ((indices % 2) * 255).astype(np.uint8), ((indices * 17 + frame * 31) % 256).astype(np.uint8)


def make_packet(width=3, height=3, frame=0):
    raw, filtered = expected_masks(width, height, frame)
    payload = np.stack((raw, filtered), axis=2).tobytes()
    payload += bytes((-len(payload)) % 4)
    header = TRAILER.pack(
        MAGIC, VERSION_LENGTH, 0x10203000 + frame, 0x40506000 + frame, 0x70809000 + frame,
        (height << 16) | width, width * height, len(payload), 0,
        0xBA987654, 0xFEDC, PAIR_FORMAT, 0, 0, 0, 0,
    )
    body = payload + header[:-4]
    return body + struct.pack("<I", zlib.crc32(body))


def with_crc(packet):
    return bytes(packet[:-4]) + struct.pack("<I", zlib.crc32(packet[:-4]))


def capture_pool_fixture():
    registers = CaptureOwnerRegisters()
    owner = VisionFrameOwnerControl(registers.read, registers.write)
    events, allocated = [], []
    rgb_dma, packet_dma = {0x34: 1, 0x30: 2, 0x28: 0}, {0x34: 9, 0x30: 0}

    def allocate(*, shape, dtype):
        assert dtype == np.uint8
        buffer = CaptureBuffer(int(np.prod(shape)), 0x1000000 + len(allocated) * 0x300000, events)
        allocated.append(buffer)
        return buffer

    def write(dma, name, offset, value):
        events.append((name, offset, value))
        dma[offset] = value

    def read_packet(offset):
        if offset == 0x34 and registers.values[0x4C] == 2:
            slot, frame_id = registers.values[0x58], registers.values[0x54]
            packet = bytearray(make_packet(640, 360, frame_id))
            trailer = len(packet) - TRAILER.size
            struct.pack_into('<III', packet, trailer + 8, frame_id, 2, 3)
            allocated[3 + slot][:] = with_crc(packet)
            struct.pack_into('<I', allocated[6 + slot], 0x1C, 0x8C000000 | len(packet))
        return packet_dma.get(offset, 0)

    def status():
        flags = registers.values[8]
        return CaptureEpochStatus(3 if flags & 1 else 0, bool(flags & 1),
                                  bool(flags & 4 and registers.values[0x60] == 7), 0)

    pool = VisionCapturePool(owner, allocate, lambda offset: rgb_dma.get(offset, 0),
                             lambda offset, value: write(rgb_dma, 'rgb', offset, value), read_packet,
                             lambda offset, value: write(packet_dma, 'packet', offset, value), status)
    return pool, allocated, events, registers, rgb_dma, packet_dma


def test_capture_pool_delivers_seven_frames_and_frees_only_after_both_halts():
    pool, buffers, events, _, rgb_dma, packet_dma = capture_pool_fixture()
    pool.start(epoch=3, config_id=2, thresholds=BOUNDS)
    assert pool.state == 'RUNNING' and len(buffers) == 9
    first = pool.read()
    assert first.frame_id == 1 and first.epoch == 3
    delivered = [first]
    pool.stop(delivered.append)
    assert [frame.frame_id for frame in delivered] == list(range(1, 8))
    assert pool.state == pool.rgb.state == pool.packets.state == 'STOPPED'
    assert rgb_dma[0x30] == 0x10002 and packet_dma[0x30] == 0x10000
    assert events[-11:-9] == [('packet', 0x30, 0x10000), ('rgb', 0x30, 0x10002)]
    assert events[-9:] == [('free', buffer.physical_address) for buffer in buffers]
    assert not any(event[0] == 'invalidate' and event[1] == buffer.physical_address
                   for event in events for buffer in buffers[:3])
    count = len(events)
    pool.stop(delivered.append)
    assert len(events) == count


def test_capture_pool_partial_allocation_failure_retains_roots_without_dma_writes():
    pool, buffers, events, _, _, _ = capture_pool_fixture()
    original = pool._allocate

    def fail_allocate(**arguments):
        if len(buffers) == 4:
            raise MemoryError('injected CMA allocation failure')
        return original(**arguments)

    pool._allocate = fail_allocate
    with pytest.raises(MemoryError):
        pool.start(epoch=3, config_id=2, thresholds=BOUNDS)
    assert pool.state == 'RETAINED' and len(pool._buffers) == len(buffers) == 4 and not events
    with pytest.raises(RuntimeError):
        pool.start(epoch=3, config_id=2, thresholds=BOUNDS)
    with pytest.raises(RuntimeError):
        pool.stop(lambda frame: None)
    assert not events


def test_capture_pool_rgb_preview_is_immutable_and_from_the_same_held_token():
    pool, buffers, events, _, _, _ = capture_pool_fixture()
    pool.start(epoch=3, config_id=2, thresholds=BOUNDS)
    buffers[0][0] = 37
    captured = pool.read(include_rgb=True)
    assert captured.frame_id == 1 and captured.rgb[0] == 37
    assert ('invalidate', buffers[0].physical_address) in events
    buffers[0][0] = 0
    assert captured.rgb[0] == 37
    remaining = []
    pool.stop(remaining.append)
    assert [frame.frame_id for frame in remaining] == list(range(2, 8))


def test_capture_pool_drain_consumer_failure_retains_all_buffers():
    pool, buffers, events, _, _, _ = capture_pool_fixture()
    pool.start(epoch=3, config_id=2, thresholds=BOUNDS)

    def fail_consumer(frame):
        raise RuntimeError('injected drain consumer failure')

    with pytest.raises(RuntimeError, match='consumer failure'):
        pool.stop(fail_consumer)
    assert pool.state == 'RETAINED' and len(buffers) == 9
    assert not any(event[0] == 'free' for event in events)


def epoch_status(*, epoch=0x70809000, ready=True, sealed=False, faults=0):
    return CaptureEpochStatus(epoch=epoch, ready=ready, sealed=sealed, faults=faults)


@pytest.mark.parametrize("phase,frame", [(0, 0), (0, 1), (1, 0), (1, 1)])
def test_actual_tracked_capture_drain_exports(phase, frame):
    root = os.environ.get("DMS1_DRAIN_OUTPUT")
    if root is None:
        pytest.skip("DMS1_DRAIN_OUTPUT is required for actual tracked capture exports")
    directory = Path(root)
    assert len(list(directory.glob("*.bin"))) == 4
    packet = (directory / f"phase-{phase}-frame-{frame}.bin").read_bytes()
    assert len(packet) == 72
    assert zlib.crc32(packet[:-4]) == struct.unpack("<I", packet[-4:])[0]
    expected = dict(width=2, height=2, frame_id=frame + 1, config_id=2,
                    epoch=phase + 3, thresholds=(0, 22, 35, 255, 45, 255))
    result = decode_dual_mask(packet, **expected)
    np.testing.assert_array_equal(result.raw, np.full((2, 2), 255, dtype=np.uint8))
    np.testing.assert_array_equal(result.filtered, np.full((2, 2), 255, dtype=np.uint8))


@pytest.mark.parametrize("case_id", [0, 1, 2])
def test_actual_fence_registers_hold_until_barrier_and_both_drains(case_id):
    root = os.environ.get("DMS1_FENCE_OUTPUT")
    if root is None:
        pytest.skip("DMS1_FENCE_OUTPUT is required for actual epoch-fence exports")
    with (Path(root) / f"case{case_id}.csv").open(newline="", encoding="utf-8") as stream:
        rows = list(csv.DictReader(stream))
    assert len(rows) == 30
    entries = iter(rows)
    statuses = []
    for snapshot in range(5):
        def read32(offset):
            row = next(entries)
            assert int(row["snapshot"]) == snapshot
            assert int(row["offset"], 16) == offset
            assert int(row["response"], 16) == 0
            return int(row["value"], 16)
        statuses.append(read_capture_epoch_status(read32))
    with pytest.raises(StopIteration):
        next(entries)
    epoch = 0x71800002 + case_id * 256
    assert statuses == [CaptureEpochStatus(epoch, True, False, 0)] * 3 + [
        CaptureEpochStatus(epoch, True, True, 0), CaptureEpochStatus(epoch, True, False, 4),
    ]
    frame = epoch - 0x70809000
    gate = DualMaskEpochGate(epoch=epoch)
    assert gate.stage(make_packet(frame=frame), status=statuses[0], **expected_arguments(frame=frame)) is None
    for status in statuses[1:3]:
        assert gate.release(lambda: status) is None
    result = gate.release(lambda: statuses[3])
    assert result is not None and result.epoch == epoch
    raw, filtered = expected_masks(3, 3, frame)
    np.testing.assert_array_equal(result.raw, raw)
    np.testing.assert_array_equal(result.filtered, filtered)
    with pytest.raises(ValueError):
        gate.release(lambda: statuses[3])
    invalidated = DualMaskEpochGate(epoch=epoch)
    invalidated.stage(make_packet(frame=frame), status=statuses[0], **expected_arguments(frame=frame))
    with pytest.raises(ValueError):
        invalidated.release(lambda: statuses[4])
    with pytest.raises(ValueError):
        invalidated.release(lambda: statuses[3])


def test_epoch_gate_holds_until_sealed_and_delivers_once():
    gate = DualMaskEpochGate(epoch=0x70809000)
    assert gate.stage(make_packet(), status=epoch_status(), **expected_arguments()) is None
    assert gate.release(epoch_status) is None
    result = gate.release(lambda: epoch_status(sealed=True))
    assert result is not None and result.epoch == 0x70809000
    raw, filtered = expected_masks(3, 3, 0)
    np.testing.assert_array_equal(result.raw, raw)
    np.testing.assert_array_equal(result.filtered, filtered)
    with pytest.raises(ValueError):
        gate.release(lambda: epoch_status(sealed=True))


@pytest.mark.parametrize("change", [dict(faults=1), dict(faults=2), dict(faults=4), dict(faults=7),
                                         dict(epoch=0x70809001), dict(ready=False)])
def test_epoch_gate_late_fault_or_identity_change_never_releases(change):
    gate = DualMaskEpochGate(epoch=0x70809000)
    gate.stage(make_packet(), status=epoch_status(), **expected_arguments())
    with pytest.raises(ValueError):
        gate.release(lambda: epoch_status(sealed=True, **change))
    with pytest.raises(ValueError):
        gate.release(lambda: epoch_status(sealed=True))


@pytest.mark.parametrize("operation", ["crc", "overwrite", "identity", "read_error", "empty"])
def test_epoch_gate_failures_poison_without_retry(operation):
    gate = DualMaskEpochGate(epoch=0x70809000)
    if operation == "empty":
        with pytest.raises(ValueError):
            gate.release(lambda: epoch_status(sealed=True))
    elif operation == "crc":
        packet = bytearray(make_packet())
        packet[1] ^= 1
        with pytest.raises(ValueError):
            gate.stage(bytes(packet), status=epoch_status(), **expected_arguments())
    elif operation == "identity":
        with pytest.raises(ValueError):
            gate.stage(make_packet(frame=1), status=epoch_status(), **expected_arguments(frame=1))
    else:
        gate.stage(make_packet(), status=epoch_status(), **expected_arguments())
        if operation == "overwrite":
            with pytest.raises(ValueError):
                gate.stage(make_packet(), status=epoch_status(), **expected_arguments())
        else:
            def failed_read():
                raise OSError("status read failed")
            with pytest.raises(OSError):
                gate.release(failed_read)
    with pytest.raises(ValueError):
        gate.stage(make_packet(), status=epoch_status(), **expected_arguments())


@pytest.mark.parametrize("change", [dict(epoch=True), dict(epoch=-1), dict(epoch=2**32), dict(ready=1),
                                         dict(sealed=1), dict(ready=False, sealed=True), dict(faults=True), dict(faults=8), dict(faults=-1)])
def test_epoch_status_rejects_invalid_types_and_unknown_causes(change):
    with pytest.raises(ValueError):
        epoch_status(**change)


@pytest.mark.parametrize("field,value", [(0, 0), (4, 2), (8, 8), (12, 8), (8, 7),
                                        (8, 2), (16, -1), (16, True), (16, 2**32), (16, 1.5)])
def test_capture_register_reader_rejects_bad_identity_or_status(field, value):
    words = {0: CAPTURE_STATUS_MAGIC, 4: CAPTURE_STATUS_ABI, 8: 3, 12: 0, 16: 0x70809000}
    words[field] = value
    with pytest.raises(ValueError):
        read_capture_epoch_status(words.__getitem__)


def test_capture_register_reader_rejects_torn_epoch_and_poison_gate():
    words = iter([CAPTURE_STATUS_MAGIC, CAPTURE_STATUS_ABI, 0x70809000, 3, 0, 0x70809001])
    gate = DualMaskEpochGate(epoch=0x70809000)
    gate.stage(make_packet(), status=epoch_status(), **expected_arguments())
    with pytest.raises(ValueError):
        gate.release(lambda: read_capture_epoch_status(lambda offset: next(words)))
    with pytest.raises(ValueError):
        gate.release(lambda: epoch_status(sealed=True))


@pytest.mark.skipif(not os.environ.get("DMS1_STATUS_OUTPUT"), reason="explicit status RTL export directory required")
def test_actual_axi_register_reads_drive_epoch_quarantine():
    root = Path(os.environ["DMS1_STATUS_OUTPUT"])
    with (root / "reads.csv").open(newline="", encoding="ascii") as stream:
        rows = list(csv.DictReader(stream))
    assert len(rows) == 60
    statuses = []
    for snapshot in range(10):
        group = [row for row in rows if int(row["snapshot"]) == snapshot]
        assert [int(row["offset"], 16) for row in group] == [0, 4, 16, 8, 12, 16]
        records = iter(group)

        def read32(offset):
            row = next(records)
            assert int(row["offset"], 16) == offset and int(row["response"], 16) == 0
            return int(row["value"], 16)

        statuses.append(read_capture_epoch_status(read32))
        assert next(records, None) is None
    expected = [(0, False, False, 0), (0x70809000, True, False, 0), (0x70809000, True, False, 1),
                (0x70809000, True, True, 1), (0x70809001, True, True, 0), (0x70809001, True, True, 4),
                (0x70809002, True, True, 0), (0x70809002, True, True, 4), (0x70809003, True, False, 2),
                (0x70809003, True, False, 6)]
    assert [(status.epoch, status.ready, status.sealed, status.faults) for status in statuses] == expected
    gate = DualMaskEpochGate(epoch=0x70809000)
    gate.stage(make_packet(), status=statuses[1], **expected_arguments())
    assert gate.release(lambda: statuses[1]) is None
    with pytest.raises(ValueError):
        gate.release(lambda: statuses[2])
    with pytest.raises(ValueError):
        gate.release(lambda: statuses[3])
    recovered = DualMaskEpochGate(epoch=0x70809001)
    recovered.stage(make_packet(frame=1), status=statuses[4], **expected_arguments(frame=1))
    assert recovered.release(lambda: statuses[4]).epoch == 0x70809001
    for initial, failed, frame in [(4, 5, 1), (6, 7, 2)]:
        rejected = DualMaskEpochGate(epoch=statuses[initial].epoch)
        rejected.stage(make_packet(frame=frame), status=statuses[initial], **expected_arguments(frame=frame))
        with pytest.raises(ValueError):
            rejected.release(lambda: statuses[failed])


@pytest.mark.parametrize("width,height", [(1, 1), (2, 2), (3, 3), (640, 360)])
def test_decode_exact_arrays_own_memory(width, height):
    packet = make_packet(width, height)
    result = decode_dual_mask(packet, **expected_arguments(width, height))
    raw, filtered = expected_masks(width, height, 0)
    np.testing.assert_array_equal(result.raw, raw)
    np.testing.assert_array_equal(result.filtered, filtered)
    assert result.raw.flags.owndata and result.filtered.flags.owndata
    assert not np.shares_memory(result.raw, result.filtered)
    assert result.thresholds == BOUNDS and result.epoch == 0x70809000


@pytest.mark.parametrize("word", range(16))
def test_reject_every_trailer_field(word):
    packet = bytearray(make_packet())
    packet[len(packet) - TRAILER.size + word * 4] ^= 1
    if word != 15:
        packet = bytearray(with_crc(packet))
    with pytest.raises(ValueError):
        decode_dual_mask(bytes(packet), **expected_arguments())


@pytest.mark.parametrize("change", ["truncate", "append", "payload", "raw", "padding", "mutable"])
def test_reject_wire_corruption(change):
    packet = bytearray(make_packet())
    if change == "truncate":
        packet = packet[:-1]
    elif change == "append":
        packet += b"\0"
    elif change == "payload":
        packet[1] ^= 1
    elif change == "raw":
        packet[0] = 1
        packet = bytearray(with_crc(packet))
    elif change == "padding":
        packet[18] = 1
        packet = bytearray(with_crc(packet))
    with pytest.raises(ValueError):
        decode_dual_mask(packet if change == "mutable" else bytes(packet), **expected_arguments())


@pytest.mark.parametrize("field,value", [
    ("width", 0), ("height", 361), ("width", 3.0), ("frame_id", True),
    ("config_id", -1), ("epoch", 2**32), ("thresholds", (1, 2)),
    ("thresholds", (0, 0, 0, 0, 0, 256)), ("thresholds", (0, 0, 0, 0, 0, False)),
])
def test_reject_invalid_expectation(field, value):
    arguments = expected_arguments()
    arguments[field] = value
    with pytest.raises(ValueError):
        decode_dual_mask(make_packet(), **arguments)


@pytest.mark.skipif(not os.environ.get("DMS1_RTL_OUTPUT"), reason="explicit RTL export directory required")
def test_actual_rtl_exports():
    root = Path(os.environ["DMS1_RTL_OUTPUT"])
    files = sorted(root.glob("*.bin"))
    assert len(files) == 12
    accepted = rejected = 0
    for path in files:
        fields = path.stem.split("-")
        width, height, scenario = int(fields[0][1:]), int(fields[1][1:]), int(fields[-1])
        packet = path.read_bytes()
        tail = TRAILER.unpack_from(packet, len(packet) - TRAILER.size)
        assert zlib.crc32(packet[:-4]) == tail[-1]
        if scenario >= 2:
            with pytest.raises(ValueError):
                decode_dual_mask(packet, **expected_arguments(width, height))
            rejected += 1
        else:
            result = decode_dual_mask(packet, **expected_arguments(width, height, scenario))
            raw, filtered = expected_masks(width, height, scenario)
            np.testing.assert_array_equal(result.raw, raw)
            np.testing.assert_array_equal(result.filtered, filtered)
            accepted += 1
    assert (accepted, rejected) == (6, 6)


@pytest.mark.skipif(not os.environ.get("DMS1_CAPTURE_OUTPUT"), reason="explicit combined RTL exports required")
def test_actual_frontend_capture_against_board_gold():
    root = Path(os.environ["DMS1_CAPTURE_OUTPUT"])
    gold = Path(__file__).resolve().parents[1] / "results/game-validation/vision-pl-streaming-20261015/r259-frontend-reference"
    bounds = ((0, 22, 35, 255, 45, 255), (120, 120, 255, 255, 255, 255),
              (0, 179, 1, 255, 0, 255), (7, 90, 60, 210, 20, 240))
    files = sorted(root.glob("*.bin"))
    assert len(files) == 24
    pairs = 0
    for path in files:
        fields = path.stem.split("-")
        height, width, frame = int(fields[0][1:]), int(fields[1][1:]), int(fields[-1])
        arguments = expected_arguments(width // 2, height // 2, frame)
        arguments["thresholds"] = bounds[frame]
        result = decode_dual_mask(path.read_bytes(), **arguments)
        for name, actual in (("raw", result.raw), ("filtered", result.filtered)):
            reference = np.frombuffer((gold / (path.stem + f"-{name}.bin")).read_bytes(), dtype=np.uint8)
            np.testing.assert_array_equal(actual.reshape(-1), reference)
        pairs += result.raw.size
    assert pairs == 922468


@pytest.mark.parametrize("environment,fault_pixels", [
    ("DMS1_FAULT_OUTPUT", 1), ("DMS1_CDC_FAULT_OUTPUT", 2), ("DMS1_DIRECT_FAULT_OUTPUT", 1),
])
def test_actual_source_fault_packet_and_reset_recovery(environment, fault_pixels):
    output = os.environ.get(environment)
    if not output:
        pytest.skip("explicit source-fault RTL exports required: " + environment)
    root = Path(output)
    assert len(list(root.glob("*.bin"))) == 2
    arguments = dict(width=2, height=2, frame_id=1, config_id=2, epoch=3,
                     thresholds=(0, 22, 35, 255, 45, 255))
    failed = (root / "phase-0.bin").read_bytes()
    tail = TRAILER.unpack_from(failed, len(failed) - TRAILER.size)
    assert tail[6:9] == (fault_pixels, 4, 8)
    assert zlib.crc32(failed[:-4]) == tail[-1]
    with pytest.raises(ValueError):
        decode_dual_mask(failed, **arguments)
    recovered = decode_dual_mask((root / "phase-1.bin").read_bytes(), **arguments)
    np.testing.assert_array_equal(recovered.raw, np.full((2, 2), 255, dtype=np.uint8))
    np.testing.assert_array_equal(recovered.filtered, recovered.raw)