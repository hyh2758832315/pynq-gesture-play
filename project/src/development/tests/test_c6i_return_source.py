from __future__ import annotations

from pathlib import Path
from typing import Any

import pytest

from pynq_multimodal_game.agent import c6i_backend as c6i


ADDRESSES = {
    c6i.BUILD_ID_IP: 0x1000,
    c6i.CONTROL_IP: 0x2000,
    c6i.START_IP: 0x3000,
    c6i.STATUS_IP: 0x4000,
    c6i.STATE_IP: 0x5000,
}


class FakeFcntl:
    LOCK_EX = 1
    LOCK_NB = 2
    LOCK_UN = 8

    def __init__(self, *, fail_exclusive: bool = False) -> None:
        self.calls: list[tuple[int, int]] = []
        self.fail_exclusive = fail_exclusive

    def flock(self, descriptor: int, operation: int) -> None:
        self.calls.append((descriptor, operation))
        if self.fail_exclusive and operation & self.LOCK_EX:
            raise BlockingIOError("lock is held")


class FakeBuffer(bytearray):
    def __init__(self, size: int) -> None:
        super().__init__(size)
        self.flush_count = 0
        self.invalidate_count = 0
        self.free_count = 0

    def __setitem__(self, key: Any, value: Any) -> None:
        if isinstance(key, slice) and isinstance(value, int):
            value = bytes([value]) * len(self[key])
        super().__setitem__(key, value)

    def flush(self) -> None:
        self.flush_count += 1

    def invalidate(self) -> None:
        self.invalidate_count += 1

    def freebuffer(self) -> None:
        self.free_count += 1


class FakeMmio:
    def __init__(self) -> None:
        self.values: dict[int, int] = {}
        self.on_write = None

    def read(self, offset: int) -> int:
        return self.values.get(offset, 0)

    def write(self, offset: int, value: int) -> None:
        self.values[offset] = value
        if self.on_write is not None:
            self.on_write(offset, value)


class FakeRecvChannel:
    def __init__(self) -> None:
        self.buffer: FakeBuffer | None = None
        self.transfers = 0

    def transfer(self, buffer: FakeBuffer) -> None:
        self.buffer = buffer
        self.transfers += 1


class FakeDma:
    def __init__(self) -> None:
        self.mmio = FakeMmio()
        self.mmio.values[c6i.S2MM_STATUS_OFFSET] = c6i.DMA_IDLE_MASK
        self.recvchannel = FakeRecvChannel()


class FakeOverlay:
    def __init__(self, build_id: int) -> None:
        self.ip_dict = {
            name: {"phys_addr": address, "addr_range": 0x10000}
            for name, address in ADDRESSES.items()
        }
        self.return_dma = FakeDma()
        self.mmios = {address: FakeMmio() for address in ADDRESSES.values()}
        self.mmios[ADDRESSES[c6i.BUILD_ID_IP]].values[0] = build_id


class FakeHardware:
    def __init__(
        self,
        tmp_path: Path,
        monkeypatch: pytest.MonkeyPatch,
        *,
        build_id: int = 0xC0060700,
        size: int = 16,
    ) -> None:
        self.bitstream = tmp_path / "c6i.bit"
        self.bitstream.write_bytes(b"bit")
        self.bitstream.with_suffix(".hwh").write_text("<ROOT />", encoding="ascii")
        self.lock_path = tmp_path / "c6i.lock"
        self.overlay = FakeOverlay(build_id)
        self.overlay_loads = 0
        self.buffers: list[FakeBuffer] = []
        self.fcntl = FakeFcntl()
        real_import = c6i.importlib.import_module

        def import_module(name: str) -> Any:
            if name == "fcntl":
                return self.fcntl
            return real_import(name)

        monkeypatch.setattr(c6i.importlib, "import_module", import_module)
        self.source = c6i.C6IReturnSource(
            self.bitstream,
            size=size,
            timeout_seconds=0.5,
            lock_path=self.lock_path,
            overlay_factory=self.load_overlay,
            mmio_factory=lambda address, _length: self.overlay.mmios[address],
            allocate=self.allocate,
            require_root=False,
        )

    def load_overlay(self, *_args: Any, **_kwargs: Any) -> FakeOverlay:
        self.overlay_loads += 1
        return self.overlay

    def allocate(self, *, shape: tuple[int], dtype: str) -> FakeBuffer:
        assert dtype == "u1"
        buffer = FakeBuffer(shape[0])
        self.buffers.append(buffer)
        return buffer

    def complete_on_start(
        self, *, rejected: int = 0, returned_bytes: int | None = None
    ) -> None:
        control = self.overlay.mmios[ADDRESSES[c6i.CONTROL_IP]]
        start = self.overlay.mmios[ADDRESSES[c6i.START_IP]]
        status = self.overlay.mmios[ADDRESSES[c6i.STATUS_IP]]
        state = self.overlay.mmios[ADDRESSES[c6i.STATE_IP]]

        def complete(offset: int, value: int) -> None:
            if offset != c6i.GPIO_DATA_OFFSET or value != 1:
                return
            buffer = self.overlay.return_dma.recvchannel.buffer
            assert buffer is not None
            seed = control.read(c6i.GPIO2_DATA_OFFSET)
            buffer[:] = bytes((seed + index) & 0xFF for index in range(len(buffer)))
            status.values[c6i.GPIO_DATA_OFFSET] = (
                len(buffer) if returned_bytes is None else returned_bytes
            )
            status.values[c6i.GPIO2_DATA_OFFSET] = (
                status.read(c6i.GPIO2_DATA_OFFSET) + 1
            ) & 0xFFFFFFFF
            state.values[c6i.GPIO_DATA_OFFSET] = 0
            state.values[c6i.GPIO2_DATA_OFFSET] = rejected

        start.on_write = complete


def test_receive_updates_stats_and_reuses_persistent_buffer(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    hardware = FakeHardware(tmp_path, monkeypatch)
    hardware.complete_on_start()

    with hardware.source as source:
        first = source.receive(0x10)
        second = source.receive(0x20)
        assert first == bytes(range(0x10, 0x20))
        assert second == bytes(range(0x20, 0x30))
        assert source.stats.transfers == 2
        assert source.stats.total_bytes == 32
        assert source.stats.last_seed == 0x20
        assert source.stats.last_elapsed_seconds is not None
        assert source.stats.last_elapsed_seconds >= 0
        assert source.stats.dma_status == c6i.DMA_IDLE_MASK
        assert source.stats.packet_count == 2
        assert source.stats.rejected_count == 0

    assert len(hardware.buffers) == 1
    assert hardware.buffers[0].flush_count == 2
    assert hardware.buffers[0].invalidate_count == 2
    assert hardware.buffers[0].free_count == 1


def test_build_mismatch_cleans_up_open_resources(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    hardware = FakeHardware(tmp_path, monkeypatch, build_id=0xBAD)

    with pytest.raises(RuntimeError, match="BUILD_ID mismatch"):
        hardware.source.open()

    assert hardware.source._lock_file is None
    assert hardware.source._overlay is None
    assert hardware.buffers == []
    assert hardware.fcntl.calls[-1][1] == hardware.fcntl.LOCK_UN


def test_dma_error_is_reported(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    hardware = FakeHardware(tmp_path, monkeypatch)
    hardware.source.open()
    hardware.overlay.return_dma.mmio.values[c6i.S2MM_STATUS_OFFSET] = 0x10

    with pytest.raises(RuntimeError, match="S2MM DMA error status 0x00000010"):
        hardware.source.receive(1)
    hardware.source.close()


def test_dma_timeout_uses_deadline_without_waiting(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    hardware = FakeHardware(tmp_path, monkeypatch)
    hardware.source.open()
    hardware.overlay.return_dma.mmio.values[c6i.S2MM_STATUS_OFFSET] = 0
    readings = iter((10.0, 11.0))
    monkeypatch.setattr(c6i.time, "perf_counter", lambda: next(readings))

    with pytest.raises(TimeoutError, match="S2MM DMA timeout"):
        hardware.source.receive(2)
    hardware.source.close()


def test_receive_rejects_busy_before_dma_transfer(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    hardware = FakeHardware(tmp_path, monkeypatch)
    hardware.source.open()
    state = hardware.overlay.mmios[ADDRESSES[c6i.STATE_IP]]
    state.values[c6i.GPIO_DATA_OFFSET] = 1

    with pytest.raises(RuntimeError, match="C6I return source is busy: 1"):
        hardware.source.receive(2)

    assert hardware.overlay.return_dma.recvchannel.transfers == 0
    assert hardware.buffers[0].flush_count == 0
    hardware.source.close()


def test_packet_count_timeout_uses_shared_deadline_without_waiting(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    hardware = FakeHardware(tmp_path, monkeypatch)
    hardware.source.open()
    readings = iter((10.0, 11.0))
    monkeypatch.setattr(c6i.time, "perf_counter", lambda: next(readings))

    with pytest.raises(
        TimeoutError, match="return packet count timeout: expected 1, got 0"
    ):
        hardware.source.receive(3)
    hardware.source.close()


def test_returned_byte_mismatch_is_reported(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    hardware = FakeHardware(tmp_path, monkeypatch)
    hardware.complete_on_start(returned_bytes=15)
    hardware.source.open()

    with pytest.raises(
        RuntimeError, match="return byte count mismatch: expected 16, got 15"
    ):
        hardware.source.receive(4)
    hardware.source.close()


def test_rejected_counter_change_is_rejected(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    hardware = FakeHardware(tmp_path, monkeypatch)
    hardware.complete_on_start(rejected=1)
    hardware.source.open()

    with pytest.raises(RuntimeError, match="busy=0 rejected=1 baseline=0"):
        hardware.source.receive(3)
    hardware.source.close()


def test_repeated_close_frees_buffer_once(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    hardware = FakeHardware(tmp_path, monkeypatch)
    hardware.source.open()
    buffer = hardware.buffers[0]

    hardware.source.close()
    hardware.source.close()

    assert buffer.free_count == 1
    assert sum(
        operation == hardware.fcntl.LOCK_UN
        for _, operation in hardware.fcntl.calls
    ) == 1


def test_external_session_survives_return_source_close(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    hardware = FakeHardware(tmp_path, monkeypatch)
    session = c6i.C6IOverlaySession(
        hardware.bitstream,
        lock_path=hardware.lock_path,
        overlay_factory=hardware.load_overlay,
        mmio_factory=lambda address, _length: hardware.overlay.mmios[address],
        allocate=hardware.allocate,
        require_root=False,
    )
    source = c6i.C6IReturnSource(
        size=16,
        timeout_seconds=0.5,
        session=session,
    )
    hardware.complete_on_start()

    source.open()
    assert source.receive(0x10) == bytes(range(0x10, 0x20))
    source.close()

    assert session.is_open is True
    assert hardware.overlay_loads == 1
    assert hardware.buffers[0].free_count == 1
    session.close()
    assert session.is_open is False


def test_flock_competition_closes_lock_file_without_loading_overlay(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    hardware = FakeHardware(tmp_path, monkeypatch)
    hardware.fcntl.fail_exclusive = True

    with pytest.raises(BlockingIOError, match="lock is held"):
        hardware.source.open()

    assert hardware.source._lock_file is None
    assert hardware.overlay_loads == 0
    hardware.lock_path.unlink()
    assert not hardware.lock_path.exists()


def test_hwh_memrange_fallback_resolves_missing_gpio(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    hardware = FakeHardware(tmp_path, monkeypatch)
    del hardware.overlay.ip_dict[c6i.STATE_IP]
    hardware.bitstream.with_suffix(".hwh").write_text(
        '<ROOT><MEMRANGE INSTANCE="return_state_gpio" '
        'BASEVALUE="0x5000" HIGHVALUE="0x14FFF" /></ROOT>',
        encoding="ascii",
    )

    hardware.source.open()

    assert hardware.source._state_mmio is hardware.overlay.mmios[0x5000]
    hardware.source.close()