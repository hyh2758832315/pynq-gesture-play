"""Install only the paired button-only game packages in this delivery.

Run on PYNQ: sudo -n python3 start_board_test.py --check-only
             sudo -n python3 install_button_games.py
Output: var/library/games/{game1-button-v1,game2,game3-button-v1}/.
Next: start_board_test.py and verify menu/game button effects on HDMI.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "python"))

from pynq_multimodal_game.game_package import validate_game_package
from pynq_multimodal_game.library import AssetLibrary, LibraryKind


def main() -> None:
    manifest = json.loads((ROOT / "deployment_manifest.json").read_text())
    if manifest.get("build_id") != "0xC0060F00":
        raise ValueError("button-only delivery identity mismatch")
    library = AssetLibrary(ROOT / "var/library")
    current = {entry.manifest.item_id: entry for entry in library.scan(LibraryKind.GAME).entries}
    if library.scan(LibraryKind.GAME).issues:
        raise ValueError("existing game library has invalid entries")
    result = []
    for package_path in sorted((ROOT / "games/button-only").glob("*.vvg")):
        relative = package_path.relative_to(ROOT).as_posix()
        digest = hashlib.sha256(package_path.read_bytes()).hexdigest().upper()
        if manifest["sha256"].get(relative) != digest:
            raise ValueError(f"package hash mismatch: {relative}")
        package = validate_game_package(package_path)
        game = package.manifest
        if game.target_build_id != 0xC0060F00 or game.volume_inputs is not None:
            raise ValueError(f"wrong game input/build contract: {relative}")
        old = current.get(game.game_id)
        if old is not None:
            if old.manifest.sha256.lower() != digest.lower():
                raise ValueError(f"conflicting installed game: {game.game_id}")
        else:
            library.install_file(
                package_path, item_id=game.game_id, display_name=game.display_name,
                kind=LibraryKind.GAME, target_build_id=game.target_build_id,
                abi_major=game.abi_major, abi_minor=game.abi_minor)
        result.append(game.game_id)
    if set(result) != {"game1-button-v1", "game2", "game3-button-v1"}:
        raise ValueError("missing button game package")
    print(json.dumps({"status": "BUTTON_GAMES_INSTALLED", "games": result}))


if __name__ == "__main__":
    main()
