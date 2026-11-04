"""Ensure Studio-installed games survive the next startup without overwrites."""
from pathlib import Path
import sys

import pytest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "subprojects/ps_ui_r23b2/python"))
from pynq_multimodal_game.game_seeds import ensure_seed_games
from pynq_multimodal_game.game_validation import build_verified_game
from pynq_multimodal_game.library import AssetLibrary, LibraryKind
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
from pynq_multimodal_game.agent.core import ArtifactManifest
from pynq_multimodal_game.menu import MenuPage
from pynq_multimodal_game.video_codec import encode_rgb_frames, S2V1_WIDTH, S2V1_HEIGHT
from subprojects.ps_ui_r23b2.test_seed_helpers import build_bundled_games
from subprojects.ps_ui_r23b2.tools.prepare_studio_projects import prepare
from types import SimpleNamespace


def setup_library(tmp_path):
    build_bundled_games(tmp_path)
    library = AssetLibrary(tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0)
    ensure_seed_games(tmp_path, library, install=True)
    return library


@pytest.mark.parametrize("edited", (False, True))
def test_studio_export_and_user_edit_survive_restart_with_video(tmp_path, edited):
    library = setup_library(tmp_path)
    projects = tmp_path / "studio"
    prepare(projects)
    manifest = projects / "game1/game.toml"
    if edited:
        manifest.write_text(manifest.read_text(encoding="utf-8").replace(
            'display_name = "SKY RUN"', 'display_name = "MY SKY RUN"').replace(
            'version = "1.0.0"', 'version = "1.0.1"'), encoding="utf-8")
    package = build_verified_game(projects / "game1", tmp_path / "user.vvg", target_build_id=0xC0061000)
    original = next(entry for entry in library.scan(LibraryKind.GAME).entries if entry.manifest.item_id == "game1")
    assert package.sha256 != original.manifest.sha256
    # Match the .artifact path produced by Agent's actual upload commit.
    uploaded = tmp_path / "uploaded.artifact"
    uploaded.write_bytes(package.path.read_bytes())
    installer = C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000), library=library)
    installer.stage_file(ArtifactManifest.for_path(
        uploaded, artifact_kind="game.vvg", target_build_id=0xC0061000,
        abi_major=1, abi_minor=0), uploaded)
    result = installer.install_staged_library_item("game1", package.manifest.display_name, "game")
    assert result.sha256 == package.sha256
    installed = next(entry for entry in library.scan(LibraryKind.GAME).entries if entry.manifest.item_id == "game1")
    video = tmp_path / "studio.s2v"
    encode_rgb_frames([bytes((24, 48, 72)) * (S2V1_WIDTH * S2V1_HEIGHT)], video)
    clip = library.install_file(video, item_id="studio-video", display_name="Studio Video",
                                kind=LibraryKind.VIDEO, target_build_id=0xC0061000)
    before = installed.asset.read_bytes(), clip.asset.read_bytes()
    assert ensure_seed_games(tmp_path, library, install=True) == ()
    restarted = AssetLibrary(library.root, minimum_free_bytes=0, minimum_free_fraction=0)
    shell = C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000), library=restarted)
    shell.refresh_catalog()
    assert shell._game_entries["game1"].manifest.sha256 == package.sha256
    assert shell._game_entries["game1"].manifest.display_name == package.manifest.display_name
    shell._select_page_locked(MenuPage.VIDEOS)
    assert [item.item_id for item in shell._targets] == ["back", "video:studio-video"]
    assert before == (installed.asset.read_bytes(), clip.asset.read_bytes())


@pytest.mark.parametrize("fault", ("target", "identity", "corrupt", "abi"))
def test_invalid_installed_game_is_not_overwritten_or_accepted(tmp_path, fault):
    library = setup_library(tmp_path)
    source = tmp_path / "seed_games" / ("game2.vvg" if fault == "identity" else "game1.vvg")
    target = 0xC0061000
    if fault == "target":
        projects = tmp_path / "studio"
        prepare(projects)
        source = build_verified_game(projects / "game1", tmp_path / "wrong.vvg", target_build_id=0xC0060800).path
        target = 0xC0060800
    if fault == "corrupt":
        source = tmp_path / "bad.vvg"
        source.write_bytes(b"not a valid game archive")
    entry = library.install_file(source, item_id="game1", display_name="User", kind=LibraryKind.GAME,
                                 target_build_id=target, abi_major=2 if fault == "abi" else 1, replace=True)
    before = entry.asset.read_bytes()
    with pytest.raises((RuntimeError, ValueError)):
        ensure_seed_games(tmp_path, library, install=True)
    assert entry.asset.read_bytes() == before


def test_bad_existing_game_stops_before_any_missing_seed_is_written(tmp_path):
    library = setup_library(tmp_path)
    library.remove(LibraryKind.GAME, "game2")
    source = tmp_path / "bad.vvg"
    source.write_bytes(b"invalid user game")
    library.install_file(source, item_id="game3", display_name="Bad User Package", kind=LibraryKind.GAME,
                         target_build_id=0xC0061000, replace=True)
    with pytest.raises(RuntimeError, match="invalid"):
        ensure_seed_games(tmp_path, library, install=True)
    assert not (library.root / LibraryKind.GAME.directory_name / "game2").exists()
