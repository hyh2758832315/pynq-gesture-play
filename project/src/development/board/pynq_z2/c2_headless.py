from __future__ import annotations

import argparse
import json
import os
from dataclasses import asdict
from pathlib import Path

from pynq_multimodal_game.demo import build_demo_scene, create_demo_assets, create_demo_engine
from pynq_multimodal_game.headless_runner import run_headless_replay
from pynq_multimodal_game.replay import load_control_jsonl


EXPECTED_BUILD_ID = 0xC0020001
BUILD_ID_IP = "build_id_gpio"
C1_GOLDEN = {
    "tick_count": 330,
    "final_status": "WON",
    "final_score": 40,
    "final_state_sha256": "af10ca2b7564ad16fb59b0ed8bc730335975e618dfc47b3c950de553ac2abd86",
    "first_frame_crc32": 321335971,
    "last_frame_crc32": 2706781308,
}


def golden_mismatches(report: object) -> dict[str, dict[str, object]]:
    observed = {
        "tick_count": report.tick_count,
        "final_status": report.final_status.value,
        "final_score": report.final_score,
        "final_state_sha256": report.final_state_sha256,
        "first_frame_crc32": report.first_frame_crc32,
        "last_frame_crc32": report.last_frame_crc32,
    }
    return {
        field: {"expected": expected, "observed": observed[field]}
        for field, expected in C1_GOLDEN.items()
        if observed[field] != expected
    }


def run(bitstream: Path, replay_path: Path, report_path: Path) -> None:
    if os.geteuid() != 0:
        raise PermissionError("PYNQ Overlay loading requires root; run this script with sudo")
    from pynq import MMIO, Overlay

    overlay = Overlay(str(bitstream), download=True)
    description = overlay.ip_dict.get(BUILD_ID_IP)
    if description is None:
        raise RuntimeError(f"{BUILD_ID_IP!r} is absent from HWH")
    build_id = MMIO(
        int(description["phys_addr"]), int(description["addr_range"])
    ).read(0)
    if build_id != EXPECTED_BUILD_ID:
        raise RuntimeError(
            f"BUILD_ID mismatch: expected 0x{EXPECTED_BUILD_ID:08X}, got 0x{build_id:08X}"
        )

    assets = create_demo_assets()
    result = run_headless_replay(
        create_demo_engine(),
        load_control_jsonl(replay_path),
        scene_builder=lambda state, engine: build_demo_scene(state, engine.config, assets),
        renderer=assets.renderer,
        pace=True,
    )
    payload = asdict(result.report)
    payload["final_status"] = result.report.final_status.value
    mismatches = golden_mismatches(result.report)
    payload["c1_golden_expected"] = C1_GOLDEN
    payload["c1_golden_mismatches"] = mismatches
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(
        json.dumps(payload, sort_keys=True, separators=(",", ":")) + "\n",
        encoding="ascii",
    )
    if mismatches:
        raise RuntimeError(f"C1 golden mismatch: {json.dumps(mismatches, sort_keys=True)}")
    print(
        f"C2_HEADLESS_STATUS=PASS ticks={result.report.tick_count} "
        f"score={result.report.final_score} hash={result.report.final_state_sha256}"
    )


def main() -> None:
    parser = argparse.ArgumentParser(description="Run the C2 headless golden replay")
    parser.add_argument("bitstream", type=Path)
    parser.add_argument("replay", type=Path)
    parser.add_argument("--report", type=Path, default=Path("c2_headless.report.json"))
    args = parser.parse_args()
    run(args.bitstream.resolve(), args.replay.resolve(), args.report.resolve())


if __name__ == "__main__":
    main()