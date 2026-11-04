from __future__ import annotations

import argparse
import os
from dataclasses import dataclass
from pathlib import Path
import struct
import time
from typing import Any, Callable, Protocol

import verify_c4m2 as c4m2
import verify_c4m3 as c4m3
import verify_c4m7 as c4m7

from pynq_multimodal_game.gpu_abi import PacketType, unpack_resource_packet
from pynq_multimodal_game.video_codec import S2V1_FPS, S2V1Reader


EXPECTED_BUILD_ID = 0xC0060700
MAX_PACKET_BYTES = 30_897


class VideoPacketSink(Protocol):
    @property
    def maximum_render_cycles(self) -> int: ...

    def upload_tilemap(self, packet: bytes) -> None: ...

    def upload_palette(self, packet: bytes) -> None: ...

    def upload_asset(self, packet: bytes) -> None: ...

    def submit_scene(self, packet: bytes) -> None: ...

    def close(self) -> None: ...


@dataclass(frozen=True)
class PlaybackStats:
    presented_frames: int
    completed_loops: int
    deadline_misses: int
    elapsed_seconds: float
    frames_per_second: float
    maximum_render_cycles: int


def play_reader(
    reader: S2V1Reader,
    sink: VideoPacketSink,
    *,
    loops: int = 1,
    start_frame: int = 0,
    clock: Callable[[], float] = time.perf_counter,
    sleep: Callable[[float], None] = time.sleep,
    progress: Callable[[int, int, int], None] | None = None,
) -> PlaybackStats:
    if loops < 0:
        raise ValueError("loops must be non-negative")
    if not 0 <= start_frame < reader.frame_count:
        raise ValueError("start frame is outside the video")
    period = 1.0 / S2V1_FPS
    presented_frames = 0
    completed_loops = 0
    deadline_misses = 0
    started = clock()
    sink.upload_tilemap(reader.read_tilemap_packet())
    while loops == 0 or completed_loops < loops:
        for frame in reader.iter_packet_frames(start_frame=start_frame):
            target = started + presented_frames * period
            remaining = target - clock()
            if remaining > 0:
                sleep(remaining)
            elif presented_frames > 0 and -remaining > period:
                deadline_misses += 1
            if frame.palette_packet is not None:
                sink.upload_palette(frame.palette_packet)
            sink.upload_asset(frame.asset_packet)
            sink.submit_scene(frame.scene_packet)
            presented_frames += 1
            if progress is not None:
                progress(presented_frames, frame.frame_index, completed_loops + 1)
        completed_loops += 1
    elapsed = clock() - started
    return PlaybackStats(
        presented_frames=presented_frames,
        completed_loops=completed_loops,
        deadline_misses=deadline_misses,
        elapsed_seconds=elapsed,
        frames_per_second=presented_frames / elapsed if elapsed > 0 else 0.0,
        maximum_render_cycles=sink.maximum_render_cycles,
    )


class C6IVideoSink:
    def __init__(
        self,
        bitstream: Path,
        *,
        timeout_seconds: float,
        expected_build_id: int = EXPECTED_BUILD_ID,
        overlay_factory: Callable[..., Any] | None = None,
        mmio_factory: Callable[..., Any] | None = None,
        allocate: Callable[..., Any] | None = None,
    ) -> None:
        import numpy as np

        if overlay_factory is None or mmio_factory is None or allocate is None:
            from pynq import MMIO, Overlay, allocate as pynq_allocate

            overlay_factory = overlay_factory or Overlay
            mmio_factory = mmio_factory or MMIO
            allocate = allocate or pynq_allocate

        self._np = np
        self._timeout_seconds = timeout_seconds
        hwh = bitstream.with_suffix(".hwh")
        self._overlay = overlay_factory(str(bitstream), download=True)

        def mmio(instance: str) -> Any:
            return mmio_factory(*c4m2.ip_address(self._overlay, hwh, instance))

        build_mmio = mmio(c4m2.BUILD_ID_IP)
        actual_build_id = int(build_mmio.read(c4m7.GPIO_DATA_OFFSET))
        if actual_build_id != expected_build_id:
            raise RuntimeError(
                f"BUILD_ID mismatch: expected 0x{expected_build_id:08X}, "
                f"got 0x{actual_build_id:08X}"
            )
        self._packet_mmio = mmio(c4m2.PACKET_STATUS_IP)
        self._completion_mmio = mmio(c4m2.RENDER_COMPLETION_IP)
        self._cycles_mmio = mmio(c4m2.RENDER_CYCLES_IP)
        self._render_status_mmio = mmio(c4m2.RENDER_STATUS_IP)
        self._present_mmio = mmio(c4m3.PRESENT_COMPLETION_IP)
        self._resource_status = {
            PacketType.PALETTE: (
                mmio(c4m7.PALETTE_PACKET_STATUS_IP),
                mmio(c4m7.PALETTE_GENERATION_STATUS_IP),
            ),
            PacketType.ASSET: (
                mmio(c4m7.ASSET_PACKET_STATUS_IP),
                mmio(c4m7.ASSET_GENERATION_STATUS_IP),
            ),
            PacketType.TILEMAP: (
                mmio(c4m7.TILEMAP_PACKET_STATUS_IP),
                mmio(c4m7.TILEMAP_GENERATION_STATUS_IP),
            ),
        }
        self._dma = getattr(self._overlay, c4m2.DMA_IP)
        self._buffer = allocate(shape=(MAX_PACKET_BYTES,), dtype=np.uint8)
        self._maximum_render_cycles = 0

    @property
    def maximum_render_cycles(self) -> int:
        return self._maximum_render_cycles

    def upload_tilemap(self, packet: bytes) -> None:
        self._upload_resource(packet, PacketType.TILEMAP)

    def upload_palette(self, packet: bytes) -> None:
        self._upload_resource(packet, PacketType.PALETTE)

    def upload_asset(self, packet: bytes) -> None:
        self._upload_resource(packet, PacketType.ASSET)

    def submit_scene(self, packet: bytes) -> None:
        if len(packet) != c4m2.PAYLOAD_BYTES:
            raise ValueError("S2V1 scene packet length mismatch")
        submit_seq = struct.unpack_from("<I", packet, 8)[0]
        expected_packet = (
            int(self._packet_mmio.read(c4m7.GPIO_DATA_OFFSET)) + 1
        ) & 0xFFFFFFFF
        before_present = int(self._present_mmio.read(c4m7.GPIO2_DATA_OFFSET))
        self._transfer(packet)
        c4m2.wait_for_value(
            self._packet_mmio,
            c4m7.GPIO_DATA_OFFSET,
            expected_packet,
            self._timeout_seconds,
            "scene packet count",
        )
        c4m2.wait_for_value(
            self._completion_mmio,
            c4m7.GPIO_DATA_OFFSET,
            submit_seq,
            self._timeout_seconds,
            "render completed sequence",
        )
        c4m3.wait_for_increment(
            self._present_mmio,
            c4m7.GPIO2_DATA_OFFSET,
            before_present,
            self._timeout_seconds,
            "present completed count",
        )
        render_status = c4m2.decode_render_status(
            int(self._render_status_mmio.read(c4m7.GPIO_DATA_OFFSET))
        )
        if render_status != (False, 0, 0, 0):
            raise RuntimeError(f"renderer status mismatch: {render_status}")
        self._maximum_render_cycles = max(
            self._maximum_render_cycles,
            int(self._cycles_mmio.read(c4m7.GPIO_DATA_OFFSET)),
        )

    def close(self) -> None:
        buffer, self._buffer = getattr(self, "_buffer", None), None
        if buffer is not None:
            buffer.freebuffer()

    def _upload_resource(self, packet: bytes, expected_type: PacketType) -> None:
        header, _ = unpack_resource_packet(packet)
        if header.packet_type is not expected_type:
            raise ValueError(
                f"expected {expected_type.name} packet, got {header.packet_type.name}"
            )
        packet_mmio, generation_mmio = self._resource_status[expected_type]
        expected_count = (
            int(packet_mmio.read(c4m7.GPIO_DATA_OFFSET)) + 1
        ) & 0xFFFFFFFF
        rejected_before = int(packet_mmio.read(c4m7.GPIO2_DATA_OFFSET))
        self._transfer(packet)
        c4m2.wait_for_value(
            packet_mmio,
            c4m7.GPIO_DATA_OFFSET,
            expected_count,
            self._timeout_seconds,
            f"{expected_type.name.lower()} accepted count",
        )
        c4m2.wait_for_value(
            generation_mmio,
            c4m7.GPIO_DATA_OFFSET,
            header.generation,
            self._timeout_seconds,
            f"{expected_type.name.lower()} generation",
        )
        rejected_after = int(packet_mmio.read(c4m7.GPIO2_DATA_OFFSET))
        if rejected_after != rejected_before:
            raise RuntimeError(
                f"{expected_type.name.lower()} packet rejected: "
                f"{rejected_before}->{rejected_after}"
            )

    def _transfer(self, payload: bytes) -> None:
        if self._buffer is None:
            raise RuntimeError("video sink is closed")
        if len(payload) > len(self._buffer):
            raise ValueError("S2V1 packet exceeds the DMA buffer")
        self._buffer[: len(payload)] = self._np.frombuffer(payload, dtype=self._np.uint8)
        self._buffer.flush()
        self._dma.sendchannel.transfer(self._buffer, nbytes=len(payload))
        deadline = time.perf_counter() + self._timeout_seconds
        while not self._dma.sendchannel.idle:
            if self._dma.sendchannel.error:
                status = self._dma.sendchannel._mmio.read(
                    self._dma.sendchannel._offset + 4
                )
                raise RuntimeError(f"MM2S DMA error: status=0x{status:08X}")
            if time.perf_counter() >= deadline:
                raise TimeoutError("MM2S DMA timeout")
        self._dma.sendchannel.wait()


def main() -> None:
    parser = argparse.ArgumentParser(description="Play an S2V1 video on the C6I overlay")
    parser.add_argument("bitstream", type=Path)
    parser.add_argument("--video", type=Path, required=True)
    parser.add_argument("--timeout-seconds", type=float, default=2.0)
    parser.add_argument("--loops", type=int, default=1)
    parser.add_argument("--start-frame", type=int, default=0)
    args = parser.parse_args()
    if not hasattr(os, "geteuid") or os.geteuid() != 0:
        raise PermissionError("PYNQ Overlay loading requires root; run with sudo -n")
    if args.timeout_seconds <= 0 or args.loops < 0 or args.start_frame < 0:
        parser.error("timeout must be positive; loops and start frame must be non-negative")
    bitstream = args.bitstream.resolve()
    video = args.video.resolve()
    if not bitstream.is_file() or not bitstream.with_suffix(".hwh").is_file():
        raise FileNotFoundError("bitstream and matching HWH are required")
    if not video.is_file():
        raise FileNotFoundError(video)

    sink: C6IVideoSink | None = None
    try:
        with S2V1Reader(video) as reader:
            sink = C6IVideoSink(bitstream, timeout_seconds=args.timeout_seconds)

            def report(completed: int, frame_index: int, loop: int) -> None:
                if completed % S2V1_FPS == 0:
                    print(
                        f"S2V1_PLAYBACK_PROGRESS frames={completed} "
                        f"loop={loop} frame={frame_index}",
                        flush=True,
                    )

            stats = play_reader(
                reader,
                sink,
                loops=args.loops,
                start_frame=args.start_frame,
                progress=report,
            )
        print(
            "S2V1_PLAYBACK_STATUS=PASS "
            f"frames={stats.presented_frames} loops={stats.completed_loops} "
            f"elapsed={stats.elapsed_seconds:.3f}s fps={stats.frames_per_second:.3f} "
            f"deadline_misses={stats.deadline_misses} "
            f"max_render_cycles={stats.maximum_render_cycles}",
            flush=True,
        )
    finally:
        if sink is not None:
            sink.close()


if __name__ == "__main__":
    main()