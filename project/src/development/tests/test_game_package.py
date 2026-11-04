from __future__ import annotations

import json
from pathlib import Path
from zipfile import ZipFile

import pytest

from pynq_multimodal_game.game_package import (
    GamePackageBuilder,
    validate_game_package,
)
from pynq_multimodal_game.game_project import GameProject
from pynq_multimodal_game.game_sdk import GAME_SDK_MINOR


def test_game_project_rejects_unknown_template(tmp_path: Path) -> None:
    with pytest.raises(ValueError, match="unknown game project template"):
        GameProject.create(
            tmp_path / "project", game_id="unknown-template",
            display_name="Unknown Template", template="missing",
        )


def test_game_project_build_is_deterministic_and_supports_multiple_files(tmp_path: Path) -> None:
    project = GameProject.create(tmp_path / "project", game_id="moving-dot", display_name="Moving Dot")
    (project.root / "src" / "rules.py").write_text("SPEED = 3\n", encoding="utf-8")
    builder = GamePackageBuilder()
    first = builder.build(project.root, tmp_path / "first.vvg")
    second = builder.build(project.root, tmp_path / "second.vvg")
    assert first.sha256 == second.sha256
    assert first.path.read_bytes() == second.path.read_bytes()
    assert first.manifest.game_id == "moving-dot"
    assert (first.manifest.sdk_major, first.manifest.sdk_minor) == (1, 1)
    assert "src/main.py" in first.files
    assert "src/rules.py" in first.files


def test_game_package_rejects_unsafe_archive_path(tmp_path: Path) -> None:
    package = tmp_path / "unsafe.vvg"
    with ZipFile(package, "w") as archive:
        archive.writestr("../escape.py", "pass\n")
        archive.writestr("game.toml", "")
        archive.writestr("package.json", "{}")
    with pytest.raises(ValueError, match="unsafe path"):
        validate_game_package(package)


def test_fusion_target_build_preserves_source_and_old_package(tmp_path):
    from pynq_multimodal_game.game_validation import build_verified_game
    project = GameProject.create(tmp_path / "project", game_id="fusion", display_name="Fusion")
    original_manifest = project.manifest_path.read_bytes()
    old = build_verified_game(project.root, tmp_path / "old.vvg")
    fusion = build_verified_game(project.root, tmp_path / "fusion.vvg", target_build_id=0xC0060800)
    repeated = build_verified_game(project.root, tmp_path / "fusion-repeat.vvg", target_build_id=0xC0060800)
    assert project.manifest_path.read_bytes() == original_manifest
    assert old.manifest.target_build_id == 0xC0060700
    assert fusion.manifest.target_build_id == 0xC0060800
    assert fusion.sha256 == repeated.sha256 and fusion.sha256 != old.sha256
    assert (fusion.manifest.sdk_major, fusion.manifest.sdk_minor) == (1, 1)
    with ZipFile(old.path) as original, ZipFile(fusion.path) as targeted:
        for name in original.namelist():
            if name not in ("game.toml", "package.json"):
                assert original.read(name) == targeted.read(name)


def test_game_package_rejects_tampered_source(tmp_path: Path) -> None:
    project = GameProject.create(tmp_path / "project", game_id="tamper-test", display_name="Tamper Test")
    original = GamePackageBuilder().build(project.root, tmp_path / "original.vvg")
    tampered = tmp_path / "tampered.vvg"
    with ZipFile(original.path, "r") as source, ZipFile(tampered, "w") as target:
        for name in source.namelist():
            payload = source.read(name)
            if name == "src/main.py":
                payload += b"\nTAMPERED = True\n"
            target.writestr(name, payload)
    with pytest.raises(ValueError, match="hash mismatch"):
        validate_game_package(tampered)


def test_game_package_metadata_lists_exact_project_files(tmp_path: Path) -> None:
    project = GameProject.create(tmp_path / "project", game_id="inventory", display_name="Inventory")
    package = GamePackageBuilder().build(project.root, tmp_path / "game.vvg")
    with ZipFile(package.path, "r") as archive:
        metadata = json.loads(archive.read("package.json"))
    assert set(metadata["files"]) == {"game.toml", "src/__init__.py", "src/main.py"}


def test_game_package_rejects_forbidden_source_import(tmp_path: Path) -> None:
    project = GameProject.create(tmp_path / "project", game_id="unsafe-source", display_name="Unsafe")
    (project.root / "src" / "main.py").write_text("import subprocess\n", encoding="utf-8")
    with pytest.raises(ValueError, match="forbidden import"):
        GamePackageBuilder().build(project.root, tmp_path / "unsafe.vvg")


def test_game_package_validates_forbidden_imports_in_nested_modules(tmp_path: Path) -> None:
    project = GameProject.create(tmp_path / "project", game_id="nested-unsafe", display_name="Nested Unsafe")
    nested = project.root / "src" / "rules"
    nested.mkdir()
    (nested / "unsafe.py").write_text("import socket\n", encoding="utf-8")
    with pytest.raises(ValueError, match="forbidden import"):
        GamePackageBuilder().build(project.root, tmp_path / "unsafe.vvg")


def test_game_package_accepts_older_sdk_minor_and_rejects_future_minor(tmp_path: Path) -> None:
    project = GameProject.create(tmp_path / "project", game_id="sdk-policy", display_name="SDK Policy")
    manifest = project.manifest_path.read_text(encoding="utf-8")
    project.manifest_path.write_text(manifest.replace("sdk_minor = 1", "sdk_minor = 0"), encoding="utf-8")
    package = GamePackageBuilder().build(project.root, tmp_path / "older.vvg")
    assert package.manifest.sdk_minor == 0
    project.manifest_path.write_text(
        manifest.replace("sdk_minor = 1", f"sdk_minor = {GAME_SDK_MINOR + 1}"), encoding="utf-8",
    )
    with pytest.raises(ValueError, match="game SDK version is not supported"):
        GamePackageBuilder().build(project.root, tmp_path / "future.vvg")


def test_action_manifest_legacy_bytes_and_sdk_gate(tmp_path, monkeypatch):
    from dataclasses import replace
    from pynq_multimodal_game import game_package as module
    from pynq_multimodal_game.game_package import GameInputContract, canonical_manifest
    root = Path(__file__).resolve().parents[1]
    baseline = {
        "game1": "b4c1ab6f02dac192cd0342a10d23f1b51db982691f278c23e675c63cb38b2106",
        "game2": "aa48c7db3066d84d0727a38bad4d4acb4ca267e2057461587beb42aa9086e111",
        "game3": "24b621c20ecae157da94a1b13a1572739004a73fdfbd92c963ef34963d8d95f7",
    }
    for game_id, expected in baseline.items():
        package = module.GamePackageBuilder().build(root / "games" / game_id, tmp_path / f"{game_id}.vvg")
        assert package.sha256 == expected
        assert "inputs" not in canonical_manifest(package.manifest)
        assert "volume_inputs" not in canonical_manifest(package.manifest)
    contract = GameInputContract("game-actions-v1", "game1-timed-v1", "game1")
    with pytest.raises(ValueError, match="SDK1.2"):
        replace(package.manifest, inputs=contract)
    candidate = replace(package.manifest, sdk_minor=2, inputs=contract)
    assert canonical_manifest(candidate)["inputs"]["required_audio_capabilities"] == ["audio.edges"]
    monkeypatch.setattr(module, "GAME_SDK_MINOR", 1)
    with pytest.raises(ValueError, match="not supported"):
        replace(candidate)
