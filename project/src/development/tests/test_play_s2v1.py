from __future__ import annotations

from pathlib import Path
import struct
import sys
from typing import Any

import pytest

from pynq_multimodal_game.gpu_abi import PacketType, unpack_resource_packet
from pynq_multimodal_game.video_codec import (
    S2V1_HEIGHT,
    S2V1_WIDTH,
    S2V1Reader,
    encode_rgb_frames,
)


BOARD_DIR = Path(__file__).parents[1] / "board" / "pynq_z2"
sys.path.insert(0, str(BOARD_DIR))

import play_s2v1


class FakeClock:
    def __init__(self) -> None:
        self.value = 0.0

    def __call__(self) -> float:
        return self.value

    def sleep(self, seconds: float) -> None:
        self.value += seconds


class RecordingSink:
    def __init__(self) -> None:
        self.events: list[tuple[str, int]] = []
        self.closed = False

    @property
    def maximum_render_cycles(self) -> int:
        return 57_640

    def upload_tilemap(self, packet: bytes) -> None:
        header, _ = unpack_resource_packet(packet)
        self.events.append(("tilemap", header.generation))

    def upload_palette(self, packet: bytes) -> None:
        header, _ = unpack_resource_packet(packet)
        self.events.append(("palette", header.generation))

    def upload_asset(self, packet: bytes) -> None:
        header, _ = unpack_resource_packet(packet)
        self.events.append(("asset", header.generation))

    def submit_scene(self, packet: bytes) -> None:
        self.events.append(("scene", struct.unpack_from("<I", packet, 8)[0]))

    def close(self) -> None:
        self.closed = True


class FakeMmio:
    def __init__(self) -> None:
        self.values: dict[int, int] = {}

    def read(self, offset: int) -> int:
        return self.values.get(offset, 0)

    def write(self, offset: int, value: int) -> None:
        self.values[offset] = value


class FakeBuffer(bytearray):
    def __init__(self, size: int) -> None:
        super().__init__(size)
        self.flush_count = 0
        self.free_count = 0

    def __setitem__(self, key: Any, value: Any) -> None:
        if hasattr(value, "tobytes"):
            value = value.tobytes()
        super().__setitem__(key, value)

    def flush(self) -> None:
        self.flush_count += 1

    def freebuffer(self) -> None:
        self.free_count += 1


class FakeSendChannel:
    def __init__(self, complete) -> None:  # type: ignore[no-untyped-def]
        self.idle = True
        self.error = False
        self._mmio = FakeMmio()
        self._offset = 0
        self._complete = complete
        self.transfers: list[bytes] = []
        self.wait_count = 0

    def transfer(self, buffer: FakeBuffer, *, nbytes: int) -> None:
        payload = bytes(buffer[:nbytes])
        self.transfers.append(payload)
        self._complete(payload)

    def wait(self) -> None:
        self.wait_count += 1


class FakeDma:
    def __init__(self, complete) -> None:  # type: ignore[no-untyped-def]
        self.sendchannel = FakeSendChannel(complete)


class FakeC6IHardware:
    def __init__(self, tmp_path: Path, *, build_id: int = play_s2v1.EXPECTED_BUILD_ID) -> None:
        self.bitstream = tmp_path / "c6i.bit"
        self.bitstream.write_bytes(b"bit")
        self.bitstream.with_suffix(".hwh").write_text("<ROOT />", encoding="ascii")
        names = (
            play_s2v1.c4m2.BUILD_ID_IP,
            play_s2v1.c4m2.PACKET_STATUS_IP,
            play_s2v1.c4m2.RENDER_COMPLETION_IP,
            play_s2v1.c4m2.RENDER_CYCLES_IP,
            play_s2v1.c4m2.RENDER_STATUS_IP,
            play_s2v1.c4m3.PRESENT_COMPLETION_IP,
            play_s2v1.c4m7.PALETTE_PACKET_STATUS_IP,
            play_s2v1.c4m7.PALETTE_GENERATION_STATUS_IP,
            play_s2v1.c4m7.ASSET_PACKET_STATUS_IP,
            play_s2v1.c4m7.ASSET_GENERATION_STATUS_IP,
            play_s2v1.c4m7.TILEMAP_PACKET_STATUS_IP,
            play_s2v1.c4m7.TILEMAP_GENERATION_STATUS_IP,
        )
        self.addresses = {name: 0x1000 + index * 0x1000 for index, name in enumerate(names)}
        self.mmios = {address: FakeMmio() for address in self.addresses.values()}
        self.mmio(play_s2v1.c4m2.BUILD_ID_IP).values[0] = build_id
        self.mmio(play_s2v1.c4m2.RENDER_CYCLES_IP).values[0] = 57_640
        self.buffers: list[FakeBuffer] = []
        self.reject_type: PacketType | None = None
        self.dma = FakeDma(self._complete)
        self.overlay = type(
            "FakeOverlay",
            (),
            {
                "ip_dict": {
                    name: {"phys_addr": address, "addr_range": 0x1000}
                    for name, address in self.addresses.items()
                },
                play_s2v1.c4m2.DMA_IP: self.dma,
            },
        )()

    def mmio(self, name: str) -> FakeMmio:
        return self.mmios[self.addresses[name]]

    def allocate(self, *, shape: tuple[int], dtype: Any) -> FakeBuffer:
        assert str(dtype) in ("uint8", "<class 'numpy.uint8'>")
        buffer = FakeBuffer(shape[0])
        self.buffers.append(buffer)
        return buffer

    def sink(self) -> play_s2v1.C6IVideoSink:
        return play_s2v1.C6IVideoSink(
            self.bitstream,
            timeout_seconds=0.1,
            overlay_factory=lambda *_args, **_kwargs: self.overlay,
            mmio_factory=lambda address, _length: self.mmios[address],
            allocate=self.allocate,
        )

    def _complete(self, payload: bytes) -> None:
        try:
            header, _ = unpack_resource_packet(payload)
        except ValueError:
            packet = self.mmio(play_s2v1.c4m2.PACKET_STATUS_IP)
            packet.values[0] = (packet.read(0) + 1) & 0xFFFFFFFF
            submit_seq = struct.unpack_from("<I", payload, 8)[0]
            self.mmio(play_s2v1.c4m2.RENDER_COMPLETION_IP).values[0] = submit_seq
            present = self.mmio(play_s2v1.c4m3.PRESENT_COMPLETION_IP)
            present.values[8] = (present.read(8) + 1) & 0xFFFFFFFF
            return
        status_name, generation_name = {
            PacketType.PALETTE: (
                play_s2v1.c4m7.PALETTE_PACKET_STATUS_IP,
                play_s2v1.c4m7.PALETTE_GENERATION_STATUS_IP,
            ),
            PacketType.ASSET: (
                play_s2v1.c4m7.ASSET_PACKET_STATUS_IP,
                play_s2v1.c4m7.ASSET_GENERATION_STATUS_IP,
            ),
            PacketType.TILEMAP: (
                play_s2v1.c4m7.TILEMAP_PACKET_STATUS_IP,
                play_s2v1.c4m7.TILEMAP_GENERATION_STATUS_IP,
            ),
        }[header.packet_type]
        status = self.mmio(status_name)
        status.values[0] = (status.read(0) + 1) & 0xFFFFFFFF
        if header.packet_type is self.reject_type:
            status.values[8] = (status.read(8) + 1) & 0xFFFFFFFF
        self.mmio(generation_name).values[0] = header.generation


def _solid_rgb(red: int, green: int, blue: int) -> bytes:
    return bytes((red, green, blue)) * (S2V1_WIDTH * S2V1_HEIGHT)


def _video(path: Path) -> None:
    encode_rgb_frames(
        (
            _solid_rgb(252, 4, 4),
            _solid_rgb(4, 252, 4),
            _solid_rgb(4, 4, 252),
        ),
        path,
        gop_size=2,
    )


def test_player_submits_resources_in_hardware_order(tmp_path: Path) -> None:
    source = tmp_path / "fixture.s2v"
    _video(source)
    sink = RecordingSink()
    clock = FakeClock()

    with S2V1Reader(source) as reader:
        stats = play_s2v1.play_reader(
            reader,
            sink,
            clock=clock,
            sleep=clock.sleep,
        )

    assert sink.events == [
        ("tilemap", 1),
        ("palette", 1),
        ("asset", 1),
        ("scene", 0),
        ("asset", 2),
        ("scene", 1),
        ("palette", 2),
        ("asset", 3),
        ("scene", 2),
    ]
    assert stats.presented_frames == 3
    assert stats.completed_loops == 1
    assert stats.deadline_misses == 0
    assert stats.maximum_render_cycles == 57_640
    assert clock.value == pytest.approx(2 / 30)


def test_player_seek_reloads_palette_and_repeats_from_requested_frame(
    tmp_path: Path,
) -> None:
    source = tmp_path / "fixture.s2v"
    _video(source)
    sink = RecordingSink()
    clock = FakeClock()

    with S2V1Reader(source) as reader:
        stats = play_s2v1.play_reader(
            reader,
            sink,
            loops=2,
            start_frame=1,
            clock=clock,
            sleep=clock.sleep,
        )

    assert stats.presented_frames == 4
    assert [event for event in sink.events if event[0] == "tilemap"] == [
        ("tilemap", 1)
    ]
    assert [event for event in sink.events if event[0] == "palette"] == [
        ("palette", 1),
        ("palette", 2),
        ("palette", 1),
        ("palette", 2),
    ]
    assert [event for event in sink.events if event[0] == "scene"] == [
        ("scene", 1),
        ("scene", 2),
        ("scene", 1),
        ("scene", 2),
    ]


def test_player_rejects_invalid_loop_and_start_frame(tmp_path: Path) -> None:
    source = tmp_path / "fixture.s2v"
    _video(source)
    sink = RecordingSink()
    with S2V1Reader(source) as reader:
        with pytest.raises(ValueError, match="loops"):
            play_s2v1.play_reader(reader, sink, loops=-1)
        with pytest.raises(ValueError, match="outside"):
            play_s2v1.play_reader(reader, sink, start_frame=reader.frame_count)


def test_c6i_sink_drives_mmio_dma_and_reuses_buffer(tmp_path: Path) -> None:
    source = tmp_path / "fixture.s2v"
    _video(source)
    hardware = FakeC6IHardware(tmp_path)
    sink = hardware.sink()
    clock = FakeClock()
    try:
        with S2V1Reader(source) as reader:
            stats = play_s2v1.play_reader(
                reader,
                sink,
                clock=clock,
                sleep=clock.sleep,
            )
        assert stats.presented_frames == 3
        assert stats.maximum_render_cycles == 57_640
        assert len(hardware.buffers) == 1
        assert hardware.buffers[0].flush_count == 9
        assert len(hardware.dma.sendchannel.transfers) == 9
        assert hardware.dma.sendchannel.wait_count == 9
        assert hardware.mmio(play_s2v1.c4m3.PRESENT_COMPLETION_IP).read(8) == 3
    finally:
        sink.close()
    assert hardware.buffers[0].free_count == 1


def test_c6i_sink_rejects_resource_and_renderer_errors(tmp_path: Path) -> None:
    source = tmp_path / "fixture.s2v"
    _video(source)
    hardware = FakeC6IHardware(tmp_path)
    hardware.reject_type = PacketType.ASSET
    sink = hardware.sink()
    try:
        with S2V1Reader(source) as reader:
            with pytest.raises(RuntimeError, match="asset packet rejected"):
                play_s2v1.play_reader(reader, sink)
    finally:
        sink.close()

    hardware = FakeC6IHardware(tmp_path)
    hardware.mmio(play_s2v1.c4m2.RENDER_STATUS_IP).values[0] = 1
    sink = hardware.sink()
    try:
        with S2V1Reader(source) as reader:
            with pytest.raises(RuntimeError, match="renderer status mismatch"):
                play_s2v1.play_reader(reader, sink)
    finally:
        sink.close()


def test_c6i_sink_rejects_wrong_build_before_allocating(tmp_path: Path) -> None:
    hardware = FakeC6IHardware(tmp_path, build_id=0xBAD)
    with pytest.raises(RuntimeError, match="BUILD_ID mismatch"):
        hardware.sink()
    assert hardware.buffers == []