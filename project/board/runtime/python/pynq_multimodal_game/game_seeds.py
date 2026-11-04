"""Verify and install the three bundled R23 games without replacing user content."""

from __future__ import annotations

from pathlib import Path
from zipfile import BadZipFile

from .game_package import validate_game_package
from .library import AssetLibrary, LibraryKind


SEED_GAME_IDS = ("game1", "game2", "game3", "game4")
BUTTON_BUILD_ID = 0xC0061000


def ensure_seed_games(package_root: Path, library: AssetLibrary, *, install: bool) -> tuple[str, ...]:
    """Check all bundles first; install only missing items on an actual board launch."""
    sources = []
    for item_id in SEED_GAME_IDS:
        package = validate_game_package(Path(package_root) / "seed_games" / f"{item_id}.vvg")
        if (package.manifest.game_id != item_id
                or package.manifest.target_build_id != BUTTON_BUILD_ID
                or package.manifest.volume_inputs is not None):
            raise ValueError(f"bundled game {item_id} has the wrong runtime contract")
        sources.append(package)
    if not install:
        return tuple(item.manifest.game_id for item in sources)

    existing = {entry.manifest.item_id: entry
                for entry in library.scan(LibraryKind.GAME).entries}
    missing = []
    for package in sources:
        item_id = package.manifest.game_id
        destination = library.root / LibraryKind.GAME.directory_name / item_id
        if destination.exists() and item_id not in existing:
            raise RuntimeError(f"installed game {item_id} is invalid; resolve it before startup")
        if item_id in existing:
            entry = existing[item_id]
            try:
                current = (package if entry.manifest.sha256 == package.sha256 else
                           validate_game_package(entry.asset, require_extension=False))
            except (OSError, ValueError, BadZipFile) as error:
                raise RuntimeError(f"installed game {item_id} is invalid; preserve it for inspection") from error
            if (current.manifest.game_id != item_id
                    or current.manifest.target_build_id != BUTTON_BUILD_ID
                    or current.manifest.volume_inputs is not None
                    or entry.manifest.target_build_id != BUTTON_BUILD_ID
                    or (entry.manifest.abi_major, entry.manifest.abi_minor) !=
                       (current.manifest.abi_major, current.manifest.abi_minor)):
                raise RuntimeError(f"installed game {item_id} has the wrong runtime contract; refusing replacement")
            continue
        missing.append(package)
    installed = []
    for package in missing:
        item_id = package.manifest.game_id
        library.install_file(
            package.path, item_id=item_id, display_name=package.manifest.display_name,
            kind=LibraryKind.GAME, target_build_id=BUTTON_BUILD_ID,
        )
        installed.append(item_id)
    return tuple(installed)
