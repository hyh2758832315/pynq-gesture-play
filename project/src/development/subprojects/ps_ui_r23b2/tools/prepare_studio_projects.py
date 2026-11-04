"""Synchronize bundled Studio games, preserving locally edited projects.
Run: .venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/tools/prepare_studio_projects.py --refresh-bundled
Outputs: games_gesture/{game1,game2,game3}, provenance and .backups for replaced trees.
Next: restart Studio, run PC tests, then use its unified PYNQ loader.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from tempfile import TemporaryDirectory
import threading
import uuid
import shutil

if __package__:
    from .build_deployment_candidate import GAME_DISPLAY_NAMES, ROOT, stage_gesture_project
else:
    from build_deployment_candidate import GAME_DISPLAY_NAMES, ROOT, stage_gesture_project


MARKER = ".seed-manifests"
_prepare_lock = threading.Lock()


def source_hashes(root: Path) -> dict[str, str]:
    return {path.relative_to(root).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest()
            for path in sorted(root.rglob("*")) if path.is_file()
            and "__pycache__" not in path.parts
            and path.suffix != ".pyc"}


def prepare(output: Path, *, refresh_bundled: bool = False) -> dict:
    with _prepare_lock:
        return _prepare(output, refresh_bundled=refresh_bundled)


def _prepare(output: Path, *, refresh_bundled: bool) -> dict:
    output = output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    (output / MARKER).mkdir(exist_ok=True)
    created, preserved, updated, conflicts, backups = [], [], [], [], {}
    for item_id in GAME_DISPLAY_NAMES:
        target = output / item_id
        marker = output / MARKER / f"{item_id}.json"
        with TemporaryDirectory(prefix=".prepare-", dir=output) as temporary:
            staged = Path(temporary) / item_id
            stage_gesture_project(item_id, staged, include_tests=True)
            desired = source_hashes(staged)
            provenance = json.dumps(dict(schema=1, sha256=desired), indent=2)
            if target.exists():
                if target.is_symlink() or not target.resolve().is_relative_to(output):
                    raise ValueError("Bundled project must be a directory inside the project root")
                # Add the new PC example even to a locally edited project;
                # never replace an example that the user already changed.
                example_path=target/'tests/replays/00-pc-example.json'
                if not example_path.exists():
                    example_path.parent.mkdir(parents=True,exist_ok=True)
                    shutil.copy2(staged/'tests/replays/00-pc-example.json',example_path)
                current = source_hashes(target)
                if current == desired:
                    marker.write_text(provenance, encoding="utf-8")
                    preserved.append(item_id)
                    continue
                try:
                    previous = json.loads(marker.read_text(encoding="utf-8"))["sha256"]
                except (OSError, ValueError, KeyError):
                    previous = None
                if not refresh_bundled and current != previous:
                    preserved.append(item_id)
                    conflicts.append(item_id)
                    continue
                backup = output / ".backups" / uuid.uuid4().hex / item_id
                backup.parent.mkdir(parents=True)
                target.rename(backup)
                try:
                    staged.rename(target)
                except OSError:
                    backup.rename(target)
                    raise
                backups[item_id] = str(backup)
                updated.append(item_id)
                marker.write_text(provenance, encoding="utf-8")
                continue
            try:
                staged.rename(target)
            except OSError:
                if not target.is_dir():
                    raise
                preserved.append(item_id)
            else:
                created.append(item_id)
                marker.write_text(provenance, encoding="utf-8")
    return dict(schema="r23-studio-projects-v2", root=str(output), created=created,
                preserved=preserved, updated=updated, conflicts=conflicts, backups=backups)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "games_gesture")
    parser.add_argument("--refresh-bundled", action="store_true",
                        help="Back up and replace the three bundled games, including legacy trees")
    options = parser.parse_args()
    print(json.dumps(prepare(options.output, refresh_bundled=options.refresh_bundled), ensure_ascii=False), flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
