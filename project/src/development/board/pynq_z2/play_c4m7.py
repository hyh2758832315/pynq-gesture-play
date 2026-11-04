from __future__ import annotations

import argparse
import os
from pathlib import Path
import time
from typing import Any

import verify_c4m2 as c4m2
import verify_c4m3 as c4m3
import verify_c4m5 as c4m5
import verify_c4m7 as c4m7


def wait_for_dma(dma_channel: Any, timeout_seconds: float, frame_index: int) -> None:
    deadline = time.perf_counter() + timeout_seconds
    while not dma_channel.idle:
        if dma_channel.error:
            status = dma_channel._mmio.read(dma_channel._offset + 4)
            raise RuntimeError(
                f"frame {frame_index} DMA error: status=0x{status:08X}"
            )
        if time.perf_counter() >= deadline:
            status = dma_channel._mmio.read(dma_channel._offset + 4)
            raise TimeoutError(
                f"frame {frame_index} DMA timeout: status=0x{status:08X}"
            )
    dma_channel.wait()


def play_replay(
    bitstream: Path,
    replay_path: Path,
    timeout_seconds: float,
    loops: int,
) -> None:
    import numpy as np
    from pynq import MMIO, Overlay, allocate
    from pynq_multimodal_game.demo import (
        build_demo_scene,
        create_demo_assets,
        create_demo_engine,
    )
    from pynq_multimodal_game.gpu_abi import (
        pack_asset_bundle_packet,
        pack_command_bank,
        pack_palette_packet,
        pack_tilemap_packet,
    )
    from pynq_multimodal_game.replay import load_control_jsonl
    from pynq_multimodal_game.scene_compiler import SceneCompiler

    hwh = bitstream.with_suffix(".hwh")
    overlay = Overlay(str(bitstream), download=True)

    def mmio(instance: str) -> Any:
        address, size = c4m2.ip_address(overlay, hwh, instance)
        return MMIO(address, size)

    build_mmio = mmio(c4m2.BUILD_ID_IP)
    packet_mmio = mmio(c4m2.PACKET_STATUS_IP)
    completion_mmio = mmio(c4m2.RENDER_COMPLETION_IP)
    cycles_mmio = mmio(c4m2.RENDER_CYCLES_IP)
    render_status_mmio = mmio(c4m2.RENDER_STATUS_IP)
    present_mmio = mmio(c4m3.PRESENT_COMPLETION_IP)
    palette_packet_mmio = mmio(c4m7.PALETTE_PACKET_STATUS_IP)
    palette_generation_mmio = mmio(c4m7.PALETTE_GENERATION_STATUS_IP)
    asset_packet_mmio = mmio(c4m7.ASSET_PACKET_STATUS_IP)
    asset_generation_mmio = mmio(c4m7.ASSET_GENERATION_STATUS_IP)
    tilemap_packet_mmio = mmio(c4m7.TILEMAP_PACKET_STATUS_IP)
    tilemap_generation_mmio = mmio(c4m7.TILEMAP_GENERATION_STATUS_IP)
    dma = getattr(overlay, c4m2.DMA_IP)

    build_id = build_mmio.read(c4m7.GPIO_DATA_OFFSET)
    if build_id != c4m7.EXPECTED_BUILD_ID:
        raise RuntimeError(
            f"BUILD_ID mismatch: expected 0x{c4m7.EXPECTED_BUILD_ID:08X}, "
            f"got 0x{build_id:08X}"
        )

    controls = load_control_jsonl(replay_path)
    assets = create_demo_assets()
    engine = create_demo_engine()
    compiler = SceneCompiler(
        sprite_atlas=assets.renderer.sprite_atlas,
        tile_atlas=assets.renderer.tile_atlas,
        palettes=assets.renderer.palettes,
    )
    generation = 0xC4070001
    state = engine.initial_state()
    first_state = engine.step(state, controls[0])
    first_scene = build_demo_scene(first_state, engine.config, assets)
    first_frame = compiler.compile(
        first_scene,
        submit_seq=0xC4070000,
        palette_generation=generation,
        asset_generation=generation,
        tilemap_generation=generation,
    )
    if len(first_frame.tilemaps) != 1:
        raise RuntimeError("C1 scene must compile one tilemap")

    c4m5.transfer_dma(
        dma, allocate, pack_asset_bundle_packet(first_frame.assets, generation=generation)
    )
    c4m2.wait_for_value(
        asset_packet_mmio, c4m7.GPIO_DATA_OFFSET, 1, timeout_seconds, "asset accepted count"
    )
    c4m2.wait_for_value(
        asset_generation_mmio, c4m7.GPIO_DATA_OFFSET, generation, timeout_seconds, "asset generation"
    )
    c4m5.transfer_dma(
        dma, allocate, pack_palette_packet(first_frame.palette_banks, generation=generation)
    )
    c4m2.wait_for_value(
        palette_packet_mmio,
        c4m7.GPIO_DATA_OFFSET,
        1,
        timeout_seconds,
        "palette accepted count",
    )
    c4m2.wait_for_value(
        palette_generation_mmio,
        c4m7.GPIO_DATA_OFFSET,
        generation,
        timeout_seconds,
        "palette generation",
    )
    c4m5.transfer_dma(
        dma,
        allocate,
        pack_tilemap_packet(first_frame.tilemaps[0], target_id=0, generation=generation),
    )
    c4m2.wait_for_value(
        tilemap_packet_mmio,
        c4m7.GPIO_DATA_OFFSET,
        1,
        timeout_seconds,
        "tilemap accepted count",
    )
    c4m2.wait_for_value(
        tilemap_generation_mmio,
        c4m7.GPIO_DATA_OFFSET,
        generation,
        timeout_seconds,
        "tilemap generation",
    )

    frame_buffer = allocate(shape=(c4m2.PAYLOAD_BYTES,), dtype=np.uint8)
    maximum_render_cycles = 0
    over_budget_frames = 0
    completed_frames = 0
    completed_loops = 0
    started_at = time.perf_counter()
    try:
        while loops == 0 or completed_loops < loops:
            state = engine.initial_state()
            for tick_index, control in enumerate(controls):
                state = engine.step(state, control)
                scene = build_demo_scene(state, engine.config, assets)
                submit_seq = 0xC4070000 + completed_frames
                frame = compiler.compile(
                    scene,
                    submit_seq=submit_seq,
                    palette_generation=generation,
                    asset_generation=generation,
                    tilemap_generation=generation,
                )
                payload = frame.header.to_bytes() + pack_command_bank(frame.commands)
                frame_buffer[:] = np.frombuffer(payload, dtype=np.uint8)
                frame_buffer.flush()
                before_present = present_mmio.read(c4m7.GPIO2_DATA_OFFSET)
                dma.sendchannel.transfer(frame_buffer)
                wait_for_dma(dma.sendchannel, timeout_seconds, completed_frames)
                c4m2.wait_for_value(
                    completion_mmio,
                    c4m7.GPIO_DATA_OFFSET,
                    submit_seq,
                    timeout_seconds,
                    "render completed sequence",
                )
                c4m3.wait_for_increment(
                    present_mmio,
                    c4m7.GPIO2_DATA_OFFSET,
                    before_present,
                    timeout_seconds,
                    "present completed count",
                )
                render_cycles = cycles_mmio.read(c4m7.GPIO_DATA_OFFSET)
                maximum_render_cycles = max(maximum_render_cycles, render_cycles)
                if render_cycles > 100_000_000 // engine.config.ticks_per_second:
                    over_budget_frames += 1
                renderer_status = c4m2.decode_render_status(
                    render_status_mmio.read(c4m7.GPIO_DATA_OFFSET)
                )
                if renderer_status != (False, 0, 0, 0):
                    raise RuntimeError(
                        f"frame {completed_frames} renderer status mismatch: "
                        f"{renderer_status}"
                    )
                completed_frames += 1
                if completed_frames % 30 == 0:
                    elapsed_seconds = time.perf_counter() - started_at
                    print(
                        f"C4M7_PLAYBACK_PROGRESS frame={completed_frames} "
                        f"loop={completed_loops + 1} tick={tick_index + 1}/{len(controls)} "
                        f"fps={completed_frames / elapsed_seconds:.2f}",
                        flush=True,
                    )
            completed_loops += 1
    finally:
        frame_buffer.freebuffer()

    elapsed_seconds = time.perf_counter() - started_at
    frames_per_second = completed_frames / elapsed_seconds
    print(
        f"C4M7_PLAYBACK_STATUS=PASS frames={completed_frames} loops={completed_loops} "
        f"elapsed={elapsed_seconds:.3f}s fps={frames_per_second:.2f} "
        f"max_render_cycles={maximum_render_cycles} "
        f"over_budget_frames={over_budget_frames}"
    )


def main() -> None:
    parser = argparse.ArgumentParser(description="Play a C1 replay on the C4M7 overlay")
    parser.add_argument("bitstream", type=Path)
    parser.add_argument("--replay", type=Path, required=True)
    parser.add_argument("--timeout-seconds", type=float, default=2.0)
    parser.add_argument(
        "--loops",
        type=int,
        default=1,
        help="number of replay loops; 0 runs continuously",
    )
    args = parser.parse_args()
    if os.geteuid() != 0:
        raise PermissionError("PYNQ Overlay loading requires root; run with sudo -n")
    if args.timeout_seconds <= 0 or args.loops < 0:
        parser.error("timeout must be positive and loops must be non-negative")
    bitstream = args.bitstream.resolve()
    if not bitstream.is_file() or not bitstream.with_suffix(".hwh").is_file():
        raise FileNotFoundError("bitstream and matching HWH are required")
    replay_path = args.replay.resolve()
    if not replay_path.is_file():
        raise FileNotFoundError("C1 replay file is required")
    play_replay(bitstream, replay_path, args.timeout_seconds, args.loops)


if __name__ == "__main__":
    main()