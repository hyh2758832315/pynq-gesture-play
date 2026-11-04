from __future__ import annotations

from pathlib import Path
import sys
from typing import Any


BOARD_DIR = Path(__file__).parents[1] / "board" / "pynq_z2"
sys.path.insert(0, str(BOARD_DIR))

import verify_c6i
import verify_c6t


class FakeBuffer(bytearray):
    def __init__(self, size: int) -> None:
        super().__init__(size)
        self.freed = False

    def __setitem__(self, key: Any, value: Any) -> None:
        if isinstance(key, slice) and isinstance(value, int):
            value = bytes([value]) * len(self[key])
        super().__setitem__(key, value)

    def flush(self) -> None:
        pass

    def invalidate(self) -> None:
        pass

    def freebuffer(self) -> None:
        self.freed = True


class FakeMmio:
    def __init__(self) -> None:
        self.values: dict[int, int] = {}

    def read(self, offset: int) -> int:
        return self.values.get(offset, 0)

    def write(self, offset: int, value: int) -> None:
        self.values[offset] = value


class FakeRecvChannel:
    def __init__(self) -> None:
        self.buffer: FakeBuffer | None = None

    def transfer(self, buffer: FakeBuffer) -> None:
        self.buffer = buffer


class FakeDma:
    def __init__(self) -> None:
        self.mmio = FakeMmio()
        self.mmio.values[verify_c6t.S2MM_STATUS_OFFSET] = verify_c6t.DMA_IDLE_MASK
        self.recvchannel = FakeRecvChannel()


def make_verifier(size: int = 64) -> tuple[
    verify_c6i.ReturnFrameVerifier,
    FakeDma,
    FakeMmio,
    FakeMmio,
    FakeBuffer,
]:
    dma = FakeDma()
    control = FakeMmio()
    start = FakeMmio()
    status = FakeMmio()
    allocated: list[FakeBuffer] = []

    def allocate(*, shape: tuple[int], dtype: str) -> FakeBuffer:
        assert dtype == "u1"
        buffer = FakeBuffer(shape[0])
        allocated.append(buffer)
        return buffer

    verifier = verify_c6i.ReturnFrameVerifier(
        dma, control, start, status, allocate, 2, 0.1, size
    )
    return verifier, dma, control, status, allocated[0]


def complete_return(
    verifier: verify_c6i.ReturnFrameVerifier,
    dma: FakeDma,
    control: FakeMmio,
    status: FakeMmio,
    tick_index: int,
) -> None:
    assert dma.recvchannel.buffer is not None
    payload = verify_c6t.deterministic_return_payload(
        control.read(verify_c6t.GPIO_DATA_OFFSET),
        control.read(verify_c6t.GPIO2_DATA_OFFSET),
    )
    dma.recvchannel.buffer[:] = payload
    status.values[verify_c6t.GPIO_DATA_OFFSET] = len(payload)
    status.values[verify_c6t.GPIO2_DATA_OFFSET] = verifier.expected_count
    verifier.after_present(tick_index)


def test_frame_hooks_arm_before_waiting_for_return() -> None:
    verifier, dma, control, status, buffer = make_verifier()

    verifier.before_submit(17)

    assert dma.recvchannel.buffer is buffer
    assert control.read(verify_c6t.GPIO_DATA_OFFSET) == 64
    assert control.read(verify_c6t.GPIO2_DATA_OFFSET) == verifier.seed(17)
    complete_return(verifier, dma, control, status, 17)
    assert verifier.pending_tick is None
    assert len(verifier.throughputs) == 1


def test_return_mismatch_is_rejected_and_buffer_is_released() -> None:
    verifier, dma, _, status, buffer = make_verifier()
    verifier.before_submit(3)
    assert dma.recvchannel.buffer is not None
    dma.recvchannel.buffer[:] = bytes(64)
    status.values[verify_c6t.GPIO_DATA_OFFSET] = 64
    status.values[verify_c6t.GPIO2_DATA_OFFSET] = verifier.expected_count

    try:
        verifier.after_present(3)
    except RuntimeError as error:
        assert "return mismatch" in str(error)
    else:
        raise AssertionError("corrupt return payload was accepted")
    verifier.close()
    assert buffer.freed


def test_return_state_rejects_busy_or_restarted_source() -> None:
    state = FakeMmio()
    verify_c6i.verify_return_state(state)

    state.values[verify_c6t.GPIO2_DATA_OFFSET] = 1
    try:
        verify_c6i.verify_return_state(state)
    except RuntimeError as error:
        assert "busy=0 rejected=1" in str(error)
    else:
        raise AssertionError("rejected return start was accepted")