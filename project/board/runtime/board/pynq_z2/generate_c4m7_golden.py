from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


SCHEMA = "pynq_multimodal_game.c4m7_golden.v1"


def build_golden(replay_path: Path) -> dict[str, object]:
    from pynq_multimodal_game.demo import (
        build_demo_scene,
        create_demo_assets,
        create_demo_engine,
    )
    from pynq_multimodal_game.game import game_state_hash
    from pynq_multimodal_game.gpu_abi import pack_command_bank
    from pynq_multimodal_game.raster_trace import raster_trace_crc32, raster_writes
    from pynq_multimodal_game.replay import load_control_jsonl
    from pynq_multimodal_game.scene_compiler import SceneCompiler

    controls = load_control_jsonl(replay_path)
    assets = create_demo_assets()
    engine = create_demo_engine()
    compiler = SceneCompiler(
        sprite_atlas=assets.renderer.sprite_atlas,
        tile_atlas=assets.renderer.tile_atlas,
        palettes=assets.renderer.palettes,
    )
    frames: list[dict[str, object]] = []
    state = engine.initial_state()
    first_frame_crc32: int | None = None
    last_scene = None
    for tick_index, control in enumerate(controls):
        state = engine.step(state, control)
        scene = build_demo_scene(state, engine.config, assets)
        if first_frame_crc32 is None:
            first_frame_crc32 = assets.renderer.crc32(assets.renderer.render(scene))
        frame = compiler.compile(
            scene,
            submit_seq=0xC4070000 + tick_index,
            palette_generation=1,
            asset_generation=1,
            tilemap_generation=1,
        )
        command_bank = pack_command_bank(frame.commands)
        writes = raster_writes(
            frame.commands, assets=frame.assets, tilemaps=frame.tilemaps
        )
        frames.append(
            {
                "command_sha256": hashlib.sha256(command_bank).hexdigest(),
                "trace_crc32": raster_trace_crc32(writes),
                "write_count": len(writes),
            }
        )
        last_scene = scene
    if first_frame_crc32 is None or last_scene is None:
        raise RuntimeError("replay must contain at least one frame")
    return {
        "schema": SCHEMA,
        "replay_sha256": hashlib.sha256(replay_path.read_bytes()).hexdigest(),
        "tick_count": len(controls),
        "final_status": state.status.value,
        "final_score": state.score,
        "final_state_sha256": game_state_hash(state),
        "first_frame_crc32": first_frame_crc32,
        "last_frame_crc32": assets.renderer.crc32(assets.renderer.render(last_scene)),
        "frames": frames,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate the C4M7 frozen replay golden")
    parser.add_argument("replay", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    replay_path = args.replay.resolve()
    if not replay_path.is_file():
        raise FileNotFoundError("C1 replay file is required")
    golden = build_golden(replay_path)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", encoding="ascii", newline="\n") as stream:
        json.dump(golden, stream, sort_keys=True, separators=(",", ":"))
        stream.write("\n")
    print(
        f"C4M7_GOLDEN_STATUS=PASS frames={golden['tick_count']} "
        f"output={args.output}"
    )


if __name__ == "__main__":
    main()