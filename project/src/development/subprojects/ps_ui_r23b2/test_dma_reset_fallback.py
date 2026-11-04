"""Fault-injection tests for the isolated R24 packet DMA shutdown candidate."""

from __future__ import annotations

import importlib.util
from pathlib import Path
import sys

import pytest


MODULE_NAME = "board.pynq_z2._r24_vision_dma_pool_test"
SOURCE = Path(__file__).resolve().parent / "board/pynq_z2/vision_dma_pool.py"
spec = importlib.util.spec_from_file_location(MODULE_NAME, SOURCE)
assert spec is not None and spec.loader is not None
dma = importlib.util.module_from_spec(spec)
sys.modules[MODULE_NAME] = dma
spec.loader.exec_module(dma)


class FakeSg:
    def __init__(self, *, reset_completes=True, halt_completes=False, error=False):
        self.control = 0x00010001
        self.status = 0x00011008 | (0x10 if error else 0)
        self.reset_completes = reset_completes
        self.halt_completes = halt_completes
        self.writes = []

    def read(self, offset):
        return {0x30: self.control, 0x34: self.status}[offset]

    def write(self, offset, value):
        assert offset == 0x30
        self.writes.append(value)
        if value & 4:
            if self.reset_completes:
                self.control = 0x00010002
                self.status = 0x00000009
        else:
            self.control = value
            if self.halt_completes:
                self.status = 0x00011009


class DrainedOwner:
    def __init__(self):
        self.checks = []

    def require_drained(self, epoch):
        self.checks.append(epoch)


def ring_for(fake):
    ring = object.__new__(dma.VisionPacketRing)
    ring._state = "RUNNING"
    ring._owner = DrainedOwner()
    ring._snapshot_token = None
    ring._read32, ring._write32 = fake.read, fake.write
    return ring


def test_sealed_packet_ring_resets_only_after_normal_halt_timeout():
    fake = FakeSg()
    ring = ring_for(fake)
    ring.halt(dma.CaptureEpochStatus(3, True, True, 0), timeout=.001)
    assert ring.state == "STOPPED"
    assert ring.stop_mode == "reset-after-halt-timeout"
    assert ring._owner.checks == [3, 3]
    assert len(fake.writes) == 2
    assert fake.writes[0] & 1 == 0 and fake.writes[0] & 4 == 0
    assert fake.writes[1] & 4 == 4
    assert fake.status & 9 == 9


def test_clean_halt_keeps_reset_unused():
    fake = FakeSg(halt_completes=True)
    ring = ring_for(fake)
    ring.halt(dma.CaptureEpochStatus(3, True, True, 0), timeout=.001)
    assert ring.state == "STOPPED"
    assert ring.stop_mode == "halt"
    assert len(fake.writes) == 1 and fake.writes[0] & 4 == 0


@pytest.mark.parametrize("reset_completes,error", [(False, False), (True, True)])
def test_failed_reset_or_dma_error_retains_memory(reset_completes, error):
    fake = FakeSg(reset_completes=reset_completes, error=error)
    ring = ring_for(fake)
    with pytest.raises((TimeoutError, RuntimeError), match="S2MM"):
        ring.halt(dma.CaptureEpochStatus(3, True, True, 0), timeout=.001)
    assert ring.state == "RETAINED"
    assert len(fake.writes) == (0 if error else 2)


def test_unsealed_source_cannot_write_dma_control():
    fake = FakeSg()
    ring = ring_for(fake)
    with pytest.raises(RuntimeError, match="sealed"):
        ring.halt(dma.CaptureEpochStatus(3, True, False, 0), timeout=.001)
    assert ring.state == "RETAINED"
    assert fake.writes == []


def test_rgb_halt_does_not_use_reset_fallback():
    fake = FakeSg()
    with pytest.raises(TimeoutError, match="halt not confirmed"):
        dma._halt_s2mm(fake.read, fake.write, 0xC9F0, .001)
    assert len(fake.writes) == 1

