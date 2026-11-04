from __future__ import annotations

from datetime import datetime, timezone
import json
from pathlib import Path
import shutil

import pytest

from pynq_multimodal_game.library import AssetLibrary, LibraryKind


def _library(root: Path) -> AssetLibrary:
    return AssetLibrary(root, minimum_free_bytes=0, minimum_free_fraction=0)


def test_library_installs_scans_and_removes_persistent_file(tmp_path: Path) -> None:
    source = tmp_path / "clip.s2v"
    source.write_bytes(b"verified-s2v")
    library = _library(tmp_path / "library")

    installed = library.install_file(
        source,
        item_id="sintel-demo",
        display_name="Sintel Demo",
        kind=LibraryKind.VIDEO,
        target_build_id=0xC0060700,
        installed_at=datetime(2026, 9, 30, tzinfo=timezone.utc),
    )

    assert installed.asset.read_bytes() == b"verified-s2v"
    assert installed.manifest.item_id == "sintel-demo"
    assert installed.manifest.kind is LibraryKind.VIDEO
    restarted = _library(library.root).scan(LibraryKind.VIDEO)
    assert [entry.manifest.display_name for entry in restarted.entries] == [
        "Sintel Demo"
    ]
    assert restarted.issues == ()

    library.remove(LibraryKind.VIDEO, "sintel-demo")
    assert library.scan(LibraryKind.VIDEO).entries == ()


def test_library_replaces_existing_item_and_preserves_identity(tmp_path: Path) -> None:
    first = tmp_path / "first.vvg"
    second = tmp_path / "second.vvg"
    first.write_bytes(b"first")
    second.write_bytes(b"second")
    library = _library(tmp_path / "library")
    library.install_file(
        first,
        item_id="game1",
        display_name="Game 1",
        kind=LibraryKind.GAME,
        target_build_id=0xC0060700,
    )

    replaced = library.install_file(
        second,
        item_id="game1",
        display_name="Game 1",
        kind=LibraryKind.GAME,
        target_build_id=0xC0060700,
        replace=True,
    )

    assert replaced.asset.read_bytes() == b"second"
    assert [entry.manifest.item_id for entry in library.scan().entries] == ["game1"]


def test_library_cleans_staging_and_isolates_invalid_entries(tmp_path: Path) -> None:
    library = _library(tmp_path / "library")
    library.initialize()
    abandoned = library.staging_directory / "abandoned"
    abandoned.mkdir()
    (abandoned / "partial").write_bytes(b"partial")
    invalid = library.root / "videos" / "broken"
    invalid.mkdir()
    (invalid / "manifest.json").write_text("{}", encoding="utf-8")

    result = library.scan()

    assert not abandoned.exists()
    assert result.entries == ()
    assert len(result.issues) == 1
    assert result.issues[0].path == invalid


def test_library_rejects_manifest_path_escape(tmp_path: Path) -> None:
    library = _library(tmp_path / "library")
    library.initialize()
    entry = library.root / "videos" / "escape"
    entry.mkdir()
    payload = {
        "schema_version": 1,
        "item_id": "escape",
        "display_name": "Escape",
        "kind": "video",
        "asset_path": "../outside.s2v",
        "length": 1,
        "sha256": "0" * 64,
        "target_build_id": 0xC0060700,
        "abi_major": 1,
        "abi_minor": 0,
        "installed_at": "2026-09-30T00:00:00+00:00",
    }
    (entry / "manifest.json").write_text(json.dumps(payload), encoding="utf-8")

    result = library.scan(LibraryKind.VIDEO)

    assert result.entries == ()
    assert "single relative filename" in result.issues[0].message


def test_library_preserves_configured_free_space(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    source = tmp_path / "large.s2v"
    source.write_bytes(b"12345")
    library = AssetLibrary(
        tmp_path / "library", minimum_free_bytes=20, minimum_free_fraction=0
    )
    monkeypatch.setattr(
        shutil,
        "disk_usage",
        lambda _path: shutil._ntuple_diskusage(total=100, used=78, free=22),
    )

    with pytest.raises(OSError, match="free space"):
        library.install_file(
            source,
            item_id="too-large",
            display_name="Too Large",
            kind=LibraryKind.VIDEO,
            target_build_id=0xC0060700,
        )

    assert library.scan().entries == ()