"""Recreate the isolated button-only software candidate from frozen R21.

Run: .venv/Scripts/python.exe -B subprojects/button_only/stage_button_package.py
Output: D:/vvg_button_only_package_stage with button-specific Python and games.
Next: build_button_games.py, verify_button_only.py, then pair routed hardware.
"""

from __future__ import annotations

import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "deliveries/c6i-pl-vision-volume-osd-r21-marker-r02-20261023"
DEST = Path("D:/vvg_button_only_package_stage")
SOFTWARE = ROOT / "subprojects/button_only/software"
FILES = {
    "game_sdk.py": "python/pynq_multimodal_game/game_sdk.py",
    "button_input.py": "python/pynq_multimodal_game/button_input.py",
    "button_osd.py": "python/pynq_multimodal_game/button_osd.py",
    "cli.py": "python/pynq_multimodal_game/agent/cli.py",
    "vision_backend.py": "python/pynq_multimodal_game/agent/vision_backend.py",
    "button_osd_backend.py": "python/pynq_multimodal_game/agent/button_osd_backend.py",
    "pl_button_factory.py": "python/pynq_multimodal_game/agent/pl_button_factory.py",
    "start_board_test.py": "start_board_test.py",
}


def main() -> None:
    if DEST.exists():
        raise SystemExit(f"Refusing to overwrite existing package stage: {DEST}")
    parent = json.loads((SOURCE / "candidate_stage.json").read_text())
    if parent["target_build_id"] != "0xC0060E00":
        raise SystemExit("Frozen R21 package identity changed")
    shutil.copytree(SOURCE, DEST)
    for source_name, relative_target in FILES.items():
        shutil.copyfile(SOFTWARE / source_name, DEST / relative_target)
    for suffix in (".bit", ".hwh", ".xsa"):
        old = DEST / ("overlay/c6v_candidate" + suffix)
        if old.exists():
            old.unlink()
    for relative in ("candidate_stage.json", "deployment_manifest.json",
                     "overlay/board_test_manifest.json"):
        old = DEST / relative
        if old.exists():
            old.unlink()
    (DEST / "BUTTON_STAGE_README.txt").write_text(
        "Button-only software source is staged. Hardware pairing and board admission are pending.\n"
        "Run build_button_games.py, verify_button_only.py, then finalize the new bit/HWH manifest.\n"
    )
    print(DEST)


if __name__ == "__main__":
    main()
