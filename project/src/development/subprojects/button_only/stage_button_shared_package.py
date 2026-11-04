"""Stage R23 software independently from the frozen R21 delivery.

Run: .venv/Scripts/python.exe -B subprojects/button_only/stage_button_shared_package.py
Output: D:/vvg_button_shared_package_stage with R23 Python sources, no deployable hardware.
Next: build_button_shared_games.py, verify_button_shared.py, then pair timing-clean R23 XSA.
"""

from __future__ import annotations

import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "deliveries/c6i-pl-vision-volume-osd-r21-marker-r02-20261023"
DEST = Path("D:/vvg_button_shared_package_stage")
SOFTWARE = ROOT / "subprojects/button_only/shared_id_software"
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
        raise SystemExit(f"Refusing to overwrite stage: {DEST}")
    parent = json.loads((SOURCE / "candidate_stage.json").read_text())
    if parent["target_build_id"] != "0xC0060E00":
        raise SystemExit("Frozen R21 package identity changed")
    shutil.copytree(SOURCE, DEST)
    for name, relative_target in FILES.items():
        shutil.copyfile(SOFTWARE / name, DEST / relative_target)
    for relative in ("overlay/c6v_candidate.bit", "overlay/c6v_candidate.hwh",
                     "overlay/c6v_candidate.xsa", "candidate_stage.json",
                     "deployment_manifest.json", "overlay/board_test_manifest.json"):
        stale = DEST / relative
        if stale.exists():
            stale.unlink()
    (DEST / "BUTTON_STAGE_README.txt").write_text(
        "R23 button software only. Pair a timing-clean 0xC0061000 XSA before board use.\n",
        encoding="utf-8",
    )
    print(DEST)


if __name__ == "__main__":
    main()
