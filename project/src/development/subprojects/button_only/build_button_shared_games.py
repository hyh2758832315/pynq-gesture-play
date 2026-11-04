"""Build deterministic R23 button game packages against the new BUILD_ID.

Run: .venv/Scripts/python.exe -B subprojects/button_only/build_button_shared_games.py
Output: D:/vvg_button_shared_package_stage/games/button-only/*.vvg and button_games_receipt.json.
Next: run verify_button_shared.py; pair with a timing-clean R23 XSA only.
"""

from __future__ import annotations

import json
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
STAGE = Path("D:/vvg_button_shared_package_stage")
sys.path.insert(0, str(STAGE / "python"))

from pynq_multimodal_game.game_validation import build_verified_game
from pynq_multimodal_game.game_package import validate_game_package

OLD_ID = 0xC0060F00
NEW_ID = 0xC0061000


def main() -> None:
    output = STAGE / "games/button-only"
    sources = STAGE / "games/button-only-sources"
    if output.exists() or sources.exists():
        raise SystemExit("Refusing to overwrite button game packages or sources")
    output.mkdir()
    sources.mkdir()
    receipts = {}
    for game in ("game1", "game2", "game3"):
        name = f"{game}-button-v1"
        source = sources / name
        shutil.copytree(ROOT / "subprojects/button_only/games" / name, source)
        toml = source / "game.toml"
        data = toml.read_bytes()
        old = f"build_id = {OLD_ID}".encode("ascii")
        if data.count(old) != 1:
            raise ValueError(f"unexpected {name} BUILD_ID source")
        toml.write_bytes(data.replace(old, f"build_id = {NEW_ID}".encode("ascii")))
        package = output / f"{name}.vvg"
        built = build_verified_game(source, package)
        checked = validate_game_package(package)
        if checked.manifest.target_build_id != NEW_ID or built.sha256 != checked.sha256:
            raise ValueError(f"wrong R23 package identity: {name}")
        receipts[name] = {"sha256": checked.sha256, "length": checked.length,
                          "build_id": f"0x{NEW_ID:08X}"}
    (STAGE / "button_games_receipt.json").write_text(
        json.dumps(receipts, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(receipts, indent=2))


if __name__ == "__main__":
    main()
