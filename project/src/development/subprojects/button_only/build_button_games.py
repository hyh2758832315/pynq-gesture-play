"""Build deterministic BTN0/BTN1 game variants against the isolated runtime.

Run: .venv/Scripts/python.exe -B subprojects/button_only/build_button_games.py
Output: D:/vvg_button_only_package_stage/games/button-only/*.vvg.
Next: run offline button replay tests, then pair games with routed overlay.
"""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
STAGE = Path("D:/vvg_button_only_package_stage")
sys.path.insert(0, str(STAGE / "python"))

from pynq_multimodal_game.game_validation import build_verified_game
from pynq_multimodal_game.game_package import validate_game_package


def main() -> None:
    output = STAGE / "games/button-only"
    output.mkdir(exist_ok=True)
    for game in ("game1", "game2", "game3"):
        name = f"{game}-button-v1"
        path = output / f"{name}.vvg"
        info = (validate_game_package(path) if path.exists() else
                build_verified_game(ROOT / "subprojects/button_only/games" / name, path))
        if info.manifest.target_build_id != 0xC0060F00:
            raise RuntimeError("wrong button-only BUILD_ID")
        print(name, info.sha256, info.length)


if __name__ == "__main__":
    main()
