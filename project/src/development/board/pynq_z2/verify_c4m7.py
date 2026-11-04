from __future__ import annotations

import argparse
import gc
import hashlib
import json
import os
from dataclasses import replace
from pathlib import Path
from typing import Any, Callable

import verify_c4m2 as c4m2
import verify_c4m3 as c4m3
import verify_c4m5 as c4m5


EXPECTED_BUILD_ID = 0xC0040700
EXPECTED_TICK_COUNT = 330
EXPECTED_FINAL_SCORE = 40
EXPECTED_FINAL_STATE_SHA256 = (
    "af10ca2b7564ad16fb59b0ed8bc730335975e618dfc47b3c950de553ac2abd86"
)
EXPECTED_FIRST_FRAME_CRC32 = 321335971
EXPECTED_LAST_FRAME_CRC32 = 2706781308
ROUTER_STATUS_IP = "router_status_gpio"
PALETTE_PACKET_STATUS_IP = "palette_packet_status_gpio"
PALETTE_GENERATION_STATUS_IP = "palette_generation_status_gpio"
ASSET_PACKET_STATUS_IP = "asset_packet_status_gpio"
ASSET_GENERATION_STATUS_IP = "asset_generation_status_gpio"
TILEMAP_PACKET_STATUS_IP = "tilemap_packet_status_gpio"
TILEMAP_GENERATION_STATUS_IP = "tilemap_generation_status_gpio"
TILEMAP_STATE_STATUS_IP = "tilemap_state_status_gpio"
GPIO_DATA_OFFSET = 0x0
GPIO2_DATA_OFFSET = 0x8
GOLDEN_SCHEMA = "pynq_multimodal_game.c4m7_golden.v1"
FrameReference = tuple[str, int, int]


def scene_payload(frame: Any) -> bytes:
    from pynq_multimodal_game.gpu_abi import pack_command_bank

    return frame.header.to_bytes() + pack_command_bank(frame.commands)


def command_payload(header: Any, commands: tuple[Any, ...]) -> bytes:
    from pynq_multimodal_game.gpu_abi import pack_command_bank

    return header.to_bytes() + pack_command_bank(commands)


def load_golden(golden_path: Path, replay_path: Path) -> tuple[FrameReference, ...]:
    payload = json.loads(golden_path.read_text(encoding="ascii"))
    expected_metadata = {
        "schema": GOLDEN_SCHEMA,
        "replay_sha256": hashlib.sha256(replay_path.read_bytes()).hexdigest(),
        "tick_count": EXPECTED_TICK_COUNT,
        "final_status": "WON",
        "final_score": EXPECTED_FINAL_SCORE,
        "final_state_sha256": EXPECTED_FINAL_STATE_SHA256,
        "first_frame_crc32": EXPECTED_FIRST_FRAME_CRC32,
        "last_frame_crc32": EXPECTED_LAST_FRAME_CRC32,
    }
    for field, expected in expected_metadata.items():
        if payload.get(field) != expected:
            raise RuntimeError(
                f"C4M7 golden {field} mismatch: {payload.get(field)!r}/{expected!r}"
            )
    frames = payload.get("frames")
    if not isinstance(frames, list) or len(frames) != EXPECTED_TICK_COUNT:
        raise RuntimeError("C4M7 golden frame count mismatch")
    references: list[FrameReference] = []
    for tick_index, frame in enumerate(frames):
        if not isinstance(frame, dict):
            raise RuntimeError(f"C4M7 golden frame {tick_index} is malformed")
        command_sha256 = frame.get("command_sha256")
        trace_crc32 = frame.get("trace_crc32")
        write_count = frame.get("write_count")
        if (
            not isinstance(command_sha256, str)
            or len(command_sha256) != 64
            or not isinstance(trace_crc32, int)
            or not isinstance(write_count, int)
        ):
            raise RuntimeError(f"C4M7 golden frame {tick_index} is malformed")
        references.append((command_sha256, trace_crc32, write_count))
    return tuple(references)


def verify_iteration(
    bitstream: Path,
    replay_path: Path,
    iteration: int,
    timeout_seconds: float,
    diagnose_prefixes: bool,
    frame_references: tuple[FrameReference, ...],
    overlay: Any | None = None,
    expected_build_id: int = EXPECTED_BUILD_ID,
    before_submit: Callable[[int], None] | None = None,
    after_present: Callable[[int], None] | None = None,
) -> None:
    from pynq import MMIO, Overlay, allocate
    from pynq_multimodal_game.demo import (
        build_demo_scene,
        create_demo_assets,
        create_demo_engine,
    )
    from pynq_multimodal_game.game import GameStatus, game_state_hash
    from pynq_multimodal_game.gpu_abi import (
        pack_asset_bundle_packet,
        pack_command_bank,
        pack_palette_packet,
        pack_tilemap_packet,
    )
    from pynq_multimodal_game.raster_trace import raster_trace_crc32, raster_writes
    from pynq_multimodal_game.replay import load_control_jsonl
    from pynq_multimodal_game.scene_compiler import SceneCompiler

    hwh = bitstream.with_suffix(".hwh")
    owns_overlay = overlay is None
    active_overlay = Overlay(str(bitstream), download=True) if owns_overlay else overlay

    def mmio(instance: str) -> Any:
        address, size = c4m2.ip_address(active_overlay, hwh, instance)
        return MMIO(address, size)

    build_mmio = mmio(c4m2.BUILD_ID_IP)
    packet_mmio = mmio(c4m2.PACKET_STATUS_IP)
    command_mmio = mmio(c4m2.COMMAND_STATUS_IP)
    completion_mmio = mmio(c4m2.RENDER_COMPLETION_IP)
    trace_mmio = mmio(c4m2.RENDER_TRACE_IP)
    render_status_mmio = mmio(c4m2.RENDER_STATUS_IP)
    present_mmio = mmio(c4m3.PRESENT_COMPLETION_IP)
    router_mmio = mmio(ROUTER_STATUS_IP)
    palette_packet_mmio = mmio(PALETTE_PACKET_STATUS_IP)
    palette_generation_mmio = mmio(PALETTE_GENERATION_STATUS_IP)
    asset_packet_mmio = mmio(ASSET_PACKET_STATUS_IP)
    asset_generation_mmio = mmio(ASSET_GENERATION_STATUS_IP)
    tilemap_packet_mmio = mmio(TILEMAP_PACKET_STATUS_IP)
    tilemap_generation_mmio = mmio(TILEMAP_GENERATION_STATUS_IP)
    tilemap_state_mmio = mmio(TILEMAP_STATE_STATUS_IP)
    dma = getattr(active_overlay, c4m2.DMA_IP)

    if build_mmio.read(GPIO_DATA_OFFSET) != expected_build_id:
        raise RuntimeError("BUILD_ID mismatch")
    if tilemap_state_mmio.read(GPIO_DATA_OFFSET) & 0xF:
        raise RuntimeError("unexpected initial tilemap ownership")

    controls = load_control_jsonl(replay_path)
    if len(controls) != EXPECTED_TICK_COUNT:
        raise RuntimeError("C1 replay tick count mismatch")
    assets = create_demo_assets()
    engine = create_demo_engine()
    compiler = SceneCompiler(
        sprite_atlas=assets.renderer.sprite_atlas,
        tile_atlas=assets.renderer.tile_atlas,
        palettes=assets.renderer.palettes,
    )
    generation = (iteration << 16) | 1
    state = engine.initial_state()
    state = engine.step(state, controls[0])
    first_scene = build_demo_scene(state, engine.config, assets)
    first_frame = compiler.compile(
        first_scene,
        submit_seq=0xC4070000 + iteration,
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
        asset_packet_mmio, GPIO_DATA_OFFSET, 1, timeout_seconds, "asset accepted count"
    )
    c4m2.wait_for_value(
        asset_generation_mmio, GPIO_DATA_OFFSET, generation, timeout_seconds, "asset generation"
    )
    c4m5.transfer_dma(
        dma, allocate, pack_palette_packet(first_frame.palette_banks, generation=generation)
    )
    c4m2.wait_for_value(
        palette_packet_mmio, GPIO_DATA_OFFSET, 1, timeout_seconds, "palette accepted count"
    )
    c4m2.wait_for_value(
        palette_generation_mmio, GPIO_DATA_OFFSET, generation, timeout_seconds, "palette generation"
    )
    c4m5.transfer_dma(
        dma,
        allocate,
        pack_tilemap_packet(first_frame.tilemaps[0], target_id=0, generation=generation),
    )
    c4m2.wait_for_value(
        tilemap_packet_mmio, GPIO_DATA_OFFSET, 1, timeout_seconds, "tilemap accepted count"
    )
    c4m2.wait_for_value(
        tilemap_generation_mmio, GPIO_DATA_OFFSET, generation, timeout_seconds, "tilemap generation"
    )
    if (
        asset_packet_mmio.read(GPIO2_DATA_OFFSET) != 0
        or asset_generation_mmio.read(GPIO2_DATA_OFFSET) != 0
        or palette_packet_mmio.read(GPIO2_DATA_OFFSET) != 0
        or palette_generation_mmio.read(GPIO2_DATA_OFFSET) != 0
        or tilemap_packet_mmio.read(GPIO2_DATA_OFFSET) != 0
        or tilemap_generation_mmio.read(GPIO2_DATA_OFFSET) != 0
        or not (tilemap_state_mmio.read(GPIO_DATA_OFFSET) & 0x1)
    ):
        raise RuntimeError("runtime resource upload status mismatch")

    if diagnose_prefixes:
        end_frame = first_frame.commands[-1]
        for prefix_index in range(1, len(first_frame.commands)):
            prefix_commands = first_frame.commands[:prefix_index] + (end_frame,)
            submit_seq = 0xC4078000 + prefix_index
            prefix_header = replace(
                first_frame.header,
                submit_seq=submit_seq,
                command_count=len(prefix_commands),
            )
            expected_writes = raster_writes(
                prefix_commands, assets=first_frame.assets, tilemaps=first_frame.tilemaps
            )
            before_present = present_mmio.read(GPIO2_DATA_OFFSET)
            c4m2.transfer_payload(
                dma,
                allocate,
                packet_mmio,
                command_payload(prefix_header, prefix_commands),
                timeout_seconds,
            )
            c4m2.wait_for_value(
                completion_mmio,
                GPIO_DATA_OFFSET,
                submit_seq,
                timeout_seconds,
                "prefix render completed sequence",
            )
            c4m3.wait_for_increment(
                present_mmio,
                GPIO2_DATA_OFFSET,
                before_present,
                timeout_seconds,
                "prefix present completed count",
            )
            actual_trace_crc32 = trace_mmio.read(GPIO_DATA_OFFSET)
            actual_write_count = trace_mmio.read(GPIO2_DATA_OFFSET)
            expected_trace_crc32 = raster_trace_crc32(expected_writes)
            expected_write_count = len(expected_writes)
            print(
                f"C4M7_PREFIX_{prefix_index:02d} trace={actual_trace_crc32:#010x}/"
                f"{expected_trace_crc32:#010x} writes={actual_write_count}/"
                f"{expected_write_count}"
            )
            if (
                actual_trace_crc32 != expected_trace_crc32
                or actual_write_count != expected_write_count
            ):
                raise RuntimeError(f"C4M7 prefix {prefix_index} render mismatch")
        print("C4M7_PREFIX_STATUS=PASS")
        return

    first_frame_crc32 = assets.renderer.crc32(assets.renderer.render(first_scene))
    state = engine.initial_state()
    for tick_index, control in enumerate(controls):
        state = engine.step(state, control)
        scene = build_demo_scene(state, engine.config, assets)
        submit_seq = 0xC4070000 + iteration + tick_index
        frame = compiler.compile(
            scene,
            submit_seq=submit_seq,
            palette_generation=generation,
            asset_generation=generation,
            tilemap_generation=generation,
        )
        command_bank = pack_command_bank(frame.commands)
        expected_command_sha256, expected_trace_crc32, expected_write_count = (
            frame_references[tick_index]
        )
        command_sha256 = hashlib.sha256(command_bank).hexdigest()
        if command_sha256 != expected_command_sha256:
            raise RuntimeError(
                f"C1 frame {tick_index} command bank hash mismatch: "
                f"{command_sha256}/{expected_command_sha256}"
            )
        before_present = present_mmio.read(GPIO2_DATA_OFFSET)
        if before_submit is not None:
            before_submit(tick_index)
        c4m2.transfer_payload(
            dma,
            allocate,
            packet_mmio,
            frame.header.to_bytes() + command_bank,
            timeout_seconds,
        )
        c4m2.wait_for_value(
            completion_mmio,
            GPIO2_DATA_OFFSET,
            tick_index + 1,
            timeout_seconds,
            "render completed count",
        )
        c4m2.wait_for_value(
            completion_mmio,
            GPIO_DATA_OFFSET,
            submit_seq,
            timeout_seconds,
            "render completed sequence",
        )
        c4m3.wait_for_increment(
            present_mmio,
            GPIO2_DATA_OFFSET,
            before_present,
            timeout_seconds,
            "present completed count",
        )
        if after_present is not None:
            after_present(tick_index)
        command_count, _, bank_valid = c4m2.decode_accepted_status(
            command_mmio.read(GPIO2_DATA_OFFSET)
        )
        completed_sequence = command_mmio.read(GPIO_DATA_OFFSET)
        actual_trace_crc32 = trace_mmio.read(GPIO_DATA_OFFSET)
        actual_write_count = trace_mmio.read(GPIO2_DATA_OFFSET)
        renderer_status = c4m2.decode_render_status(
            render_status_mmio.read(GPIO_DATA_OFFSET)
        )
        if (
            completed_sequence != submit_seq
            or command_count != len(frame.commands)
            or not bank_valid
            or actual_trace_crc32 != expected_trace_crc32
            or actual_write_count != expected_write_count
            or renderer_status != (False, 0, 0, 0)
        ):
            raise RuntimeError(
                f"C1 frame {tick_index} render mismatch: "
                f"sequence={completed_sequence:#010x}/{submit_seq:#010x} "
                f"commands={command_count}/{len(frame.commands)} bank_valid={bank_valid} "
                f"trace={actual_trace_crc32:#010x}/{expected_trace_crc32:#010x} "
                f"writes={actual_write_count}/{expected_write_count} "
                f"renderer_status={renderer_status}"
            )
    last_frame_crc32 = assets.renderer.crc32(assets.renderer.render(scene))

    if (
        state.status is not GameStatus.WON
        or state.score != EXPECTED_FINAL_SCORE
        or game_state_hash(state) != EXPECTED_FINAL_STATE_SHA256
        or first_frame_crc32 != EXPECTED_FIRST_FRAME_CRC32
        or last_frame_crc32 != EXPECTED_LAST_FRAME_CRC32
        or router_mmio.read(GPIO_DATA_OFFSET) != 0
        or router_mmio.read(GPIO2_DATA_OFFSET) != 0
    ):
        raise RuntimeError("C1 golden or router status mismatch")
    print(
        f"C4M7_LOAD_{iteration:02d}=PASS ticks={len(controls)} renders="
        f"{completion_mmio.read(GPIO2_DATA_OFFSET)} presents="
        f"{present_mmio.read(GPIO2_DATA_OFFSET)}"
    )
    del dma
    if owns_overlay:
        del active_overlay
        gc.collect()


def main() -> None:
    parser = argparse.ArgumentParser(description="Verify the PYNQ-Z2 C4M7 C1 replay")
    parser.add_argument("bitstream", type=Path, help="Path to c4_runtime_tilemap.bit")
    parser.add_argument(
        "--replay",
        type=Path,
        default=Path("data/replays/c1_demo_controls.jsonl"),
    )
    parser.add_argument("--golden", type=Path)
    parser.add_argument("--iterations", type=int, default=1)
    parser.add_argument("--timeout-seconds", type=float, default=10.0)
    parser.add_argument("--diagnose-prefixes", action="store_true")
    args = parser.parse_args()
    if os.geteuid() != 0:
        raise PermissionError("PYNQ Overlay loading requires root; run with sudo -n")
    if args.iterations < 1 or args.timeout_seconds <= 0:
        parser.error("iterations and timeout must be positive")
    bitstream = args.bitstream.resolve()
    if not bitstream.is_file() or not bitstream.with_suffix(".hwh").is_file():
        raise FileNotFoundError("bitstream and matching HWH are required")
    replay_path = args.replay.resolve()
    if not replay_path.is_file():
        raise FileNotFoundError("C1 replay file is required")
    golden_path = (
        args.golden.resolve()
        if args.golden is not None
        else replay_path.with_name("c1_demo_c4m7_golden.json")
    )
    if not golden_path.is_file():
        raise FileNotFoundError("C4M7 golden file is required")
    frame_references = load_golden(golden_path, replay_path)
    for iteration in range(1, args.iterations + 1):
        verify_iteration(
            bitstream,
            replay_path,
            iteration,
            args.timeout_seconds,
            args.diagnose_prefixes,
            frame_references,
        )
    print(f"C4M7_VERIFY_STATUS=PASS ({args.iterations}/{args.iterations})")


if __name__ == "__main__":
    main()