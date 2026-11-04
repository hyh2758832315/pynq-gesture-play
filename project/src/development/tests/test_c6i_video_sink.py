from pathlib import Path
import struct
from typing import Any

import pytest

from pynq_multimodal_game.agent.c6i_backend import (
    BUILD_ID_IP, C6IOverlaySession, OVERLAP_CONTROL_IP,
    OVERLAP_CREDIT, OVERLAP_READY, OVERLAP_FILLING, OVERLAP_COMPLETION_HOLD,
    OVERLAP_PRESENT_DONE, OVERLAP_RELEASE_CONSUMED, OVERLAP_RESOURCE_IDLE,
    OVERLAP_GENERATION_REJECT, UPLOAD_RENDER_OVERLAP_BUILD_ID,
)
from pynq_multimodal_game.agent.c6i_video import (
    ASSET_GENERATION_STATUS_IP,
    ASSET_PACKET_STATUS_IP,
    C6IVideoSink,
    PACKET_STATUS_IP,
    PALETTE_GENERATION_STATUS_IP,
    PALETTE_PACKET_STATUS_IP,
    PRESENT_COMPLETION_IP,
    RENDER_COMPLETION_IP,
    RENDER_CYCLES_IP,
    RENDER_STATUS_IP,
    SCENE_DMA_IP,
    TILEMAP_GENERATION_STATUS_IP,
    TILEMAP_PACKET_STATUS_IP,
)
from pynq_multimodal_game.gpu_abi import PacketType, unpack_resource_packet
from pynq_multimodal_game.video_codec import S2V1_HEIGHT, S2V1_WIDTH, S2V1Reader, encode_rgb_frames


class _Mmio:
    def __init__(self, on_read: Any = None, on_write: Any = None) -> None:
        self.values: dict[int, int] = {}
        self.on_read = on_read
        self.on_write = on_write

    def read(self, offset: int) -> int:
        if self.on_read is not None:
            self.on_read()
        return self.values.get(offset, 0)

    def write(self, offset: int, value: int) -> None:
        self.values[offset] = value
        if self.on_write is not None:
            self.on_write(offset, value)


@pytest.mark.parametrize("wait_kind", ["value", "overlap"])
@pytest.mark.parametrize("completion", ["ready", "pending", "timeout"])
def test_gpu_wait_yields_without_extending_deadline(monkeypatch, wait_kind, completion):
    sink = C6IVideoSink.__new__(C6IVideoSink)
    sink._timeout_seconds = .01
    mmio = _Mmio()
    mmio.values[0] = 1 if completion == "ready" else 0
    sink._overlap_mmio = mmio if wait_kind == "overlap" else None
    if wait_kind == "overlap":
        mmio.values[8] = mmio.values[0]
    timestamps = iter((0., .02 if completion == "timeout" else .001))
    sleeps = []

    def yield_execution(interval):
        sleeps.append(interval)
        mmio.values[0] = mmio.values[8] = 1

    monkeypatch.setattr("pynq_multimodal_game.agent.c6i_video.time.perf_counter", lambda: next(timestamps))
    monkeypatch.setattr("pynq_multimodal_game.agent.c6i_video.time.sleep", yield_execution)

    def wait():
        if wait_kind == "overlap":
            sink._wait_overlap(1, 1, "fixture")
        else:
            sink._wait_for_value(mmio, 0, 1, "fixture")

    if completion == "timeout":
        with pytest.raises(TimeoutError, match="fixture timeout"):
            wait()
    else:
        wait()
    assert sleeps == ([.0001] if completion == "pending" else [])
    assert sink._timeout_seconds == .01


def test_sink_transfers_maximum_legal_asset_bundle():
    from pynq_multimodal_game.gpu_abi import pack_asset_bundle_packet
    from pynq_multimodal_game.scene import IndexedImage

    packet = pack_asset_bundle_packet((IndexedImage(510, 128, bytes(510 * 128)),
                                       IndexedImage(2, 64, bytes(2 * 64)),
                                       IndexedImage(2, 64, bytes(2 * 64))), generation=1)
    session = _Session()
    sink = C6IVideoSink(session=session, timeout_seconds=1)
    try:
        sink.upload_asset(packet)
        assert session.channel.transfers == 1
        assert session.mmios[ASSET_GENERATION_STATUS_IP].values[0] == 1
    finally:
        sink.close()


class _Buffer(bytearray):
    def __init__(self, size: int) -> None:
        super().__init__(size)
        self.free_count = 0

    def flush(self) -> None:
        pass

    def __setitem__(self, key: Any, value: Any) -> None:
        if hasattr(value, "tobytes"):
            value = value.tobytes()
        super().__setitem__(key, value)

    def freebuffer(self) -> None:
        self.free_count += 1


class _SendChannel:
    def __init__(self, session: Any) -> None:
        self._idle = True
        self.error = False
        self._mmio = _Mmio()
        self._offset = 0
        self._session = session
        self.transfers = 0
        self.buffer: _Buffer | None = None
        self.pending: bytes | None = None
        self.running = True
        self.stoppable = True
        self.stalled = False
        self.wait_error = False

    @property
    def idle(self) -> bool:
        if not self.stalled:
            self._session.tick()
        return self._idle

    def transfer(self, buffer: _Buffer, *, nbytes: int) -> None:
        assert self.buffer is None
        self.transfers += 1
        self.buffer = buffer
        self.pending = bytes(buffer[:nbytes])
        self._idle = False
        self._session.events.append("dma")

    def wait(self) -> None:
        if self.wait_error:
            raise RuntimeError("DMA wait failed")
        assert self._idle
        self.buffer = None

    def stop(self) -> None:
        if not self.stoppable:
            raise RuntimeError("DMA cannot stop")
        self.running = False
        self._mmio.values[4] = 1
        self.buffer = None
        self.pending = None


class _Session(C6IOverlaySession):
    def __init__(self, bitstream: Path | None = None, *, overlap: bool = False) -> None:
        super().__init__(
            bitstream or Path("fixture.bit"), require_root=False,
            expected_build_id=UPLOAD_RENDER_OVERLAP_BUILD_ID if overlap else 0xC0060700,
        )
        self.overlap = overlap
        self.auto_advance = True
        self.allow_present = True
        self.allow_ack = True
        self.ready: list[int] = []
        self.held: int | None = None
        self.presented = False
        self.release_pending: int | None = None
        self.consumed = 0
        self.sticky = 0
        self.events: list[str] = []
        self.read_events: list[str] = []
        names = (
            BUILD_ID_IP,
            OVERLAP_CONTROL_IP,
            PACKET_STATUS_IP,
            RENDER_COMPLETION_IP,
            RENDER_CYCLES_IP,
            RENDER_STATUS_IP,
            PRESENT_COMPLETION_IP,
            PALETTE_PACKET_STATUS_IP,
            PALETTE_GENERATION_STATUS_IP,
            ASSET_PACKET_STATUS_IP,
            ASSET_GENERATION_STATUS_IP,
            TILEMAP_PACKET_STATUS_IP,
            TILEMAP_GENERATION_STATUS_IP,
        )
        self.mmios = {name: _Mmio(self.tick) for name in names}
        self.mmios[BUILD_ID_IP].values[0] = UPLOAD_RENDER_OVERLAP_BUILD_ID if overlap else 0xC0060700
        self.mmios[OVERLAP_CONTROL_IP].on_write = self.release
        for name in (RENDER_STATUS_IP, RENDER_CYCLES_IP):
            self.mmios[name].on_read = lambda name=name: self.read_events.append(name)
        self.mmios[RENDER_CYCLES_IP].values[0] = 57_640
        self.overlay = type("Overlay", (), {})()
        self._overlay = self.overlay
        self.overlay.ip_dict = {OVERLAP_CONTROL_IP: {"phys_addr": 0, "addr_range": 4096}}
        self.channel = _SendChannel(self)
        setattr(self.overlay, SCENE_DMA_IP, type("Dma", (), {"sendchannel": self.channel})())
        self.open_count = 0
        self.close_count = 0
        self.buffers: list[_Buffer] = []

    def open(self) -> "_Session":
        self.open_count += 1
        if self.mmios[BUILD_ID_IP].read(0) != self._expected_build_id:
            raise RuntimeError("BUILD_ID mismatch")
        return self

    def close(self) -> None:
        self.close_count += 1

    def mmio(self, instance: str) -> _Mmio:
        return self.mmios[instance]

    def allocate(self, **kwargs: Any) -> _Buffer:
        buffer = _Buffer(kwargs["shape"][0])
        self.buffers.append(buffer)
        return buffer

    def release(self, offset: int, value: int) -> None:
        assert offset == 0
        self.release_pending = value & 1
        self.events.append("release")

    def status(self) -> None:
        status = self.sticky | (OVERLAP_RELEASE_CONSUMED if self.consumed else 0)
        if not self.ready and self.channel.pending is None:
            status |= OVERLAP_CREDIT
        if self.ready:
            status |= OVERLAP_READY
        if self.channel.pending is not None:
            status |= OVERLAP_FILLING
        if self.held is not None:
            status |= OVERLAP_COMPLETION_HOLD
            if self.presented:
                status |= OVERLAP_PRESENT_DONE
        if not self.ready and self.held is None and self.channel.pending is None:
            status |= OVERLAP_RESOURCE_IDLE
        self.mmios[OVERLAP_CONTROL_IP].values[8] = status

    def tick(self) -> None:
        if self.auto_advance:
            if self.channel.pending is not None and not self.channel.stalled:
                self.advance_upload()
            elif self.release_pending is not None and self.allow_ack:
                self.advance_ack()
            elif self.held is not None and not self.presented and self.allow_present:
                self.advance_present()
            elif self.held is None and self.ready:
                self.advance_render()
        self.status()

    def advance_upload(self) -> None:
        payload = self.channel.pending
        assert payload is not None
        self.channel.pending = None
        self.channel._idle = True
        self.events.append("upload")
        try:
            header, _ = unpack_resource_packet(payload)
        except ValueError:
            packet = self.mmios[PACKET_STATUS_IP]
            packet.values[0] = (packet.values.get(0, 0) + 1) & 0xFFFFFFFF
            packet.values[8] = (packet.values.get(8, 0) + 1) & 0xFFFFFFFF
            assert not self.ready
            self.ready.append(struct.unpack_from("<I", payload, 12)[0])
            return
        status, generation = {
            PacketType.PALETTE: (PALETTE_PACKET_STATUS_IP, PALETTE_GENERATION_STATUS_IP),
            PacketType.ASSET: (ASSET_PACKET_STATUS_IP, ASSET_GENERATION_STATUS_IP),
            PacketType.TILEMAP: (TILEMAP_PACKET_STATUS_IP, TILEMAP_GENERATION_STATUS_IP),
        }[header.packet_type]
        assert self.held is None and not self.ready
        self.mmios[status].values[0] = (self.mmios[status].values.get(0, 0) + 1) & 0xFFFFFFFF
        self.mmios[generation].values[0] = header.generation

    def advance_render(self) -> None:
        assert self.held is None
        self.held = self.ready.pop(0)
        self.presented = False
        self.events.append("render")
        completion = self.mmios[RENDER_COMPLETION_IP]
        completion.values[0] = self.held
        completion.values[8] = (completion.values.get(8, 0) + 1) & 0xFFFFFFFF

    def advance_present(self) -> None:
        assert self.held is not None and not self.presented
        self.events.append("present")
        present = self.mmios[PRESENT_COMPLETION_IP]
        present.values[0] = self.held
        present.values[8] = (present.values.get(8, 0) + 1) & 0xFFFFFFFF
        self.presented = True
        if not self.overlap:
            self.held = None

    def advance_ack(self) -> None:
        toggle = self.release_pending
        assert toggle is not None
        self.release_pending = None
        if toggle != self.consumed:
            self.consumed = toggle
            self.events.append("ack")
            if self.held is not None and self.presented:
                self.held = None
                self.presented = False


def test_shared_session_sink_submits_one_s2v1_frame_without_closing_session(
    tmp_path: Path,
) -> None:
    video = tmp_path / "fixture.s2v"
    rgb = bytes((8, 16, 24)) * (S2V1_WIDTH * S2V1_HEIGHT)
    encode_rgb_frames([rgb], video)
    session = _Session()
    sink = C6IVideoSink(timeout_seconds=0.1, session=session)  # type: ignore[arg-type]
    try:
        with pytest.raises(KeyError):
            _ = sink.resource_generations
        with S2V1Reader(video) as reader:
            tilemap_packet=reader.read_tilemap_packet()
            sink.upload_tilemap(tilemap_packet)
            with pytest.raises(KeyError):
                _ = sink.resource_generations
            frame = next(reader.iter_packet_frames())
            assert frame.palette_packet is not None
            sink.upload_palette(frame.palette_packet)
            sink.upload_asset(frame.asset_packet)
            assert sink.resource_generations == tuple(unpack_resource_packet(p)[0].generation
                for p in (frame.palette_packet,frame.asset_packet,tilemap_packet))
            sink.submit_scene(frame.scene_packet)
        assert sink.maximum_render_cycles == 57_640
        assert session.overlay.axi_dma.sendchannel.transfers == 4
    finally:
        sink.close()

    assert session.open_count == 1
    assert session.close_count == 0
    assert session.buffers[0].free_count == 1


def _scene(sequence: int) -> bytes:
    packet = bytearray(4160)
    packet[:4] = b"S2DG"
    struct.pack_into("<I", packet, 12, sequence)
    return bytes(packet)


def test_poisoned_sink_preserves_first_dma_error_without_resubmitting() -> None:
    session = _Session()
    sink = C6IVideoSink(timeout_seconds=0.1, session=session)
    session.channel.wait_error = True
    with pytest.raises(RuntimeError, match="DMA wait failed") as original:
        sink.enqueue_scene(_scene(9))
    transfers = session.channel.transfers
    for operation in (lambda: sink.enqueue_scene(_scene(10)), sink.drain):
        with pytest.raises(RuntimeError, match="video sink is poisoned") as repeated:
            operation()
        assert "DMA wait failed" in str(repeated.value)
        assert repeated.value.__cause__ is original.value
        assert sink._poison is original.value
        assert session.channel.transfers == transfers
    with pytest.raises(RuntimeError, match="video sink closed after failure") as closed:
        sink.close()
    assert closed.value.__cause__ is original.value
    assert session.buffers[0].free_count == 1


@pytest.mark.parametrize("uploaded,accepted", [(0, 0), (5, 3), (0xFFFFFFFE, 0xFFFFFFFE)])
def test_scene_gpio_upload_acceptance_difference_is_not_a_false_rejection(uploaded, accepted):
    session = _Session()
    session.mmios[PACKET_STATUS_IP].values.update({0: uploaded, 8: accepted})
    sink = C6IVideoSink(timeout_seconds=0.1, session=session)
    ticket = sink.enqueue_scene(_scene(7))
    assert ticket.completed
    assert ticket.accepted_count == (accepted + 1) & 0xFFFFFFFF
    assert sink._scene_rejected == (uploaded - accepted) & 0xFFFFFFFF
    sink.close()


def test_scene_uploaded_without_acceptance_is_rejected(monkeypatch):
    session = _Session()
    sink = C6IVideoSink(timeout_seconds=0.1, session=session)

    def reject_upload():
        session.channel.pending = None
        session.channel._idle = True
        packet = session.mmios[PACKET_STATUS_IP]
        packet.values[0] = (packet.values.get(0, 0) + 1) & 0xFFFFFFFF

    monkeypatch.setattr(session, "advance_upload", reject_upload)
    with pytest.raises(RuntimeError, match="scene packet rejected"):
        sink.enqueue_scene(_scene(9))
    assert not session.ready and session.held is None
    with pytest.raises(RuntimeError, match="video sink closed after failure"):
        sink.close()
    assert session.buffers[0].free_count == 1


def _p4_session(tmp_path: Path) -> _Session:
    bitstream = tmp_path / "p4.bit"
    bitstream.write_bytes(b"fixture")
    bitstream.with_suffix(".hwh").write_text(
        '<SYSTEM><MEMRANGE INSTANCE="overlap_control_gpio" '
        'BASEVALUE="0x1000" HIGHVALUE="0x1fff"/></SYSTEM>',
        encoding="utf-8",
    )
    bitstream.with_name("p4_manifest.txt").write_text(
        "BUILD_ID=0xC0060760\nUPLOAD_RENDER_OVERLAP_ENABLE=1\n",
        encoding="utf-8",
    )
    return _Session(bitstream, overlap=True)


def test_legacy_enqueue_is_synchronous_and_close_is_idempotent() -> None:
    session = _Session()
    sink = C6IVideoSink(timeout_seconds=0.1, session=session)
    ticket = sink.enqueue_scene(_scene(9))
    assert ticket.completed
    assert session.events == ["dma", "upload", "render", "present"]
    sink.wait_scene(ticket)
    sink.drain()
    sink.close()
    sink.close()
    sink.wait_scene(ticket)
    assert session.buffers[0].free_count == 1
    assert session.close_count == 0


@pytest.mark.parametrize("stop_result", ["halted", "raises", "unverified"])
def test_close_halts_idle_running_dma_before_freeing_buffer(monkeypatch, stop_result):
    session = _Session()
    sink = C6IVideoSink(timeout_seconds=0.1, session=session)
    ticket = sink.enqueue_scene(_scene(9))
    assert ticket.completed and not sink._dma_inflight
    assert session.channel.running
    buffer = session.buffers[0]
    original_stop = session.channel.stop
    stop_calls = []

    def stop():
        stop_calls.append("stop")
        assert buffer.free_count == 0 and not sink._closed
        if stop_result == "raises":
            raise RuntimeError("fixture stop failure")
        if stop_result == "halted":
            original_stop()

    monkeypatch.setattr(session.channel, "stop", stop)
    if stop_result == "halted":
        sink.close()
        sink.close()
        assert buffer.free_count == 1
        assert sink._buffer is None and sink._closed
        assert not session.channel.running and session.channel._mmio.read(4) & 1
    else:
        with pytest.raises(RuntimeError, match="buffer retained, session left open"):
            sink.close()
        assert buffer.free_count == 0
        assert sink._buffer is buffer and not sink._closed
        assert session.channel.running
    assert stop_calls == ["stop"]
    assert session.close_count == 0


def test_two_tickets_overlap_and_third_retires_before_dma(tmp_path: Path) -> None:
    session = _p4_session(tmp_path)
    sink = C6IVideoSink(timeout_seconds=0.1, session=session, upload_render_overlap=True)
    session.allow_present = False
    first = sink.enqueue_scene(_scene(11))
    assert session.held == 11 and not session.presented
    second = sink.enqueue_scene(_scene(12))
    assert not first.completed and not second.completed
    assert session.ready == [12]
    assert session.mmios[RENDER_COMPLETION_IP].values[0] == 11
    assert sink.maximum_render_cycles == 0
    assert len(session.buffers) == 1
    session.allow_present = True
    third = sink.enqueue_scene(_scene(13))
    assert first.completed and not second.completed and not third.completed
    dma_positions = [index for index, event in enumerate(session.events) if event == "dma"]
    assert dma_positions[1] < session.events.index("present")
    assert session.events.index("ack") < dma_positions[2]
    assert session.read_events[:2] == [RENDER_STATUS_IP, RENDER_CYCLES_IP]
    sink.wait_scene(first)
    assert session.events.count("ack") == 1
    sink.wait_scene(third)
    assert second.completed and third.completed
    assert session.events.count("ack") == 3
    sink.close()


@pytest.mark.parametrize("sequence", [0, 7, 0xFFFFFFFF])
def test_duplicate_sequences_and_counter_wrap(tmp_path: Path, sequence: int) -> None:
    session = _p4_session(tmp_path)
    for name, offset in ((PACKET_STATUS_IP, 0), (PACKET_STATUS_IP, 8), (RENDER_COMPLETION_IP, 8), (PRESENT_COMPLETION_IP, 8)):
        session.mmios[name].values[offset] = 0xFFFFFFFE
    sink = C6IVideoSink(timeout_seconds=0.1, session=session, upload_render_overlap=True)
    first = sink.enqueue_scene(_scene(sequence))
    second = sink.enqueue_scene(_scene(sequence))
    assert first is not second
    assert (first.accepted_count, first.render_count, first.present_count) == (0xFFFFFFFF,) * 3
    assert (second.accepted_count, second.render_count, second.present_count) == (0,) * 3
    sink.wait_scene(second)
    assert first.completed and second.completed
    third = sink.enqueue_scene(_scene((sequence + 1) & 0xFFFFFFFF))
    assert third.present_count == 1
    sink.close()
    assert third.completed


def test_delayed_present_and_ack_keep_ticket_and_statistics_pending(tmp_path: Path) -> None:
    session = _p4_session(tmp_path)
    sink = C6IVideoSink(timeout_seconds=0.1, session=session, upload_render_overlap=True)
    session.allow_present = False
    session.allow_ack = False
    ticket = sink.enqueue_scene(_scene(21))
    reads = 0
    ack_reads = 0

    def delayed_events() -> None:
        nonlocal reads, ack_reads
        reads += 1
        assert not ticket.completed and sink.maximum_render_cycles == 0
        if session.release_pending is not None:
            ack_reads += 1
            assert session.presented
            assert session.read_events[-2:] == [RENDER_STATUS_IP, RENDER_CYCLES_IP]
            if ack_reads == 4:
                session.allow_ack = True
        elif reads < 6:
            assert "release" not in session.events
        if reads == 6:
            session.allow_present = True
        session.tick()

    session.mmios[OVERLAP_CONTROL_IP].on_read = delayed_events
    sink.wait_scene(ticket)
    session.mmios[OVERLAP_CONTROL_IP].on_read = session.tick
    assert ticket.completed and ack_reads == 4
    assert sink.maximum_render_cycles == 57_640
    sink.close()


def test_resource_upload_drains_all_scenes(tmp_path: Path) -> None:
    video = tmp_path / "resource.s2v"
    encode_rgb_frames([bytes((8, 16, 24)) * (S2V1_WIDTH * S2V1_HEIGHT)], video)
    with S2V1Reader(video) as reader:
        resource = reader.read_tilemap_packet()
    session = _p4_session(tmp_path)
    sink = C6IVideoSink(timeout_seconds=0.1, session=session, upload_render_overlap=True)
    first = sink.enqueue_scene(_scene(1))
    second = sink.enqueue_scene(_scene(2))
    sink.upload_tilemap(resource)
    assert first.completed and second.completed
    assert session.events[-2:] == ["dma", "upload"]
    assert session.events.count("ack") == 2
    sink.close()


@pytest.mark.parametrize("fault", ["generation", "sticky", "render_count", "present_sequence", "ack_timeout"])
def test_completion_faults_poison_without_success_statistics(tmp_path: Path, fault: str) -> None:
    session = _p4_session(tmp_path)
    sink = C6IVideoSink(timeout_seconds=0.001, session=session, upload_render_overlap=True)
    ticket = sink.enqueue_scene(_scene(3))
    if fault == "generation":
        session.sticky = OVERLAP_GENERATION_REJECT
    elif fault == "sticky":
        session.mmios[RENDER_STATUS_IP].values[0] = 1 << 8
    elif fault == "render_count":
        session.mmios[RENDER_COMPLETION_IP].values[8] = 0
    elif fault == "present_sequence":
        session.mmios[PRESENT_COMPLETION_IP].values[0] = 9
    else:
        session.allow_ack = False
    with pytest.raises((RuntimeError, TimeoutError)):
        sink.wait_scene(ticket)
    assert not ticket.completed and sink.maximum_render_cycles == 0
    with pytest.raises(RuntimeError, match="poisoned"):
        sink.enqueue_scene(_scene(4))
    with pytest.raises(RuntimeError, match="closed after failure"):
        sink.close()
    sink.close()
    assert session.buffers[0].free_count == 1
    assert session.close_count == 0


@pytest.mark.parametrize("fault", ["timeout", "error", "wait"])
def test_dma_failures_retain_buffer_until_verified_halt(fault: str) -> None:
    session = _Session()
    sink = C6IVideoSink(timeout_seconds=0.001, session=session)
    channel = session.channel
    channel.stoppable = False
    if fault == "timeout":
        channel.stalled = True
    elif fault == "error":
        channel.error = True
        channel._mmio.values[4] = 0x40
    else:
        channel.wait_error = True
    with pytest.raises((RuntimeError, TimeoutError)):
        sink.enqueue_scene(_scene(1))
    assert channel.buffer is session.buffers[0]
    with pytest.raises(RuntimeError, match="poisoned"):
        sink.submit_scene(_scene(2))
    with pytest.raises(RuntimeError, match="buffer retained"):
        sink.close()
    assert session.buffers[0].free_count == 0
    assert channel.buffer is session.buffers[0]
    assert session.close_count == 0
    channel.stoppable = True
    with pytest.raises(RuntimeError, match="closed after failure"):
        sink.close()
    sink.close()
    assert session.buffers[0].free_count == 1
    assert channel.buffer is None


@pytest.mark.parametrize("invalid", ["old_build", "missing_hwh_gpio", "missing_manifest", "disabled", "manifest_build", "duplicate"])
def test_explicit_overlap_requires_production_capability_checks(tmp_path: Path, invalid: str) -> None:
    session = _p4_session(tmp_path)
    manifest = session.bitstream.with_name("p4_manifest.txt")
    if invalid == "old_build":
        session.mmios[BUILD_ID_IP].values[0] = 0xC0060700
    elif invalid == "missing_hwh_gpio":
        session.bitstream.with_suffix(".hwh").write_text("<SYSTEM/>", encoding="utf-8")
    elif invalid == "missing_manifest":
        manifest.unlink()
    elif invalid == "disabled":
        manifest.write_text("BUILD_ID=0xC0060760\nUPLOAD_RENDER_OVERLAP_ENABLE=0\n", encoding="utf-8")
    elif invalid == "manifest_build":
        manifest.write_text("BUILD_ID=0xC0060700\nUPLOAD_RENDER_OVERLAP_ENABLE=1\n", encoding="utf-8")
    else:
        manifest.write_text("BUILD_ID=0xC0060760\nUPLOAD_RENDER_OVERLAP_ENABLE=1\nUPLOAD_RENDER_OVERLAP_ENABLE=1\n", encoding="utf-8")
    assert not session.supports_upload_render_overlap()
    with pytest.raises(RuntimeError, match="P4 overlap requires|BUILD_ID mismatch"):
        C6IVideoSink(timeout_seconds=0.1, session=session, upload_render_overlap=True)
    assert not session.buffers and session.close_count == 0


def test_valid_p4_defaults_to_synchronous_but_still_acknowledges(tmp_path: Path) -> None:
    session = _p4_session(tmp_path)
    sink = C6IVideoSink(timeout_seconds=0.1, session=session)
    assert sink.enqueue_scene(_scene(1)).completed
    assert sink.enqueue_scene(_scene(2)).completed
    assert session.events.count("ack") == 2
    sink.close()


def test_invalid_p4_cannot_silently_use_legacy_protocol(tmp_path: Path) -> None:
    session = _p4_session(tmp_path)
    session.bitstream.with_name("p4_manifest.txt").unlink()
    with pytest.raises(RuntimeError, match="P4 overlap requires"):
        C6IVideoSink(timeout_seconds=0.1, session=session)


def test_manual_early_and_duplicate_toggles_do_not_release_future_results(tmp_path: Path) -> None:
    session = _p4_session(tmp_path)
    session.auto_advance = False
    control = session.mmios[OVERLAP_CONTROL_IP]
    control.write(0, 1)
    session.advance_ack()
    assert session.consumed == 1
    session.ready.append(7)
    session.advance_render()
    session.advance_present()
    control.write(0, 1)
    session.advance_ack()
    assert session.held == 7 and session.events.count("ack") == 1
    control.write(0, 0)
    session.advance_ack()
    assert session.held is None and session.events.count("ack") == 2


def test_foreign_ticket_is_rejected_without_poisoning(tmp_path: Path) -> None:
    first = C6IVideoSink(timeout_seconds=0.1, session=_p4_session(tmp_path), upload_render_overlap=True)
    second = C6IVideoSink(timeout_seconds=0.1, session=_Session())
    ticket = first.enqueue_scene(_scene(1))
    with pytest.raises(ValueError, match="another sink"):
        second.wait_scene(ticket)
    second.submit_scene(_scene(2))
    first.close()
    second.close()
