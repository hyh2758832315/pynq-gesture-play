"""Studio source, replay and board-seed parity; no device/serial access."""
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import sys
import zipfile

import pytest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "subprojects/ps_ui_r23b2/python"))
from pynq_multimodal_game.game_testing import GameTestCase
from pynq_multimodal_game.game_validation import build_verified_game, run_game_test
from subprojects.ps_ui_r23b2.test_seed_helpers import build_bundled_games
from subprojects.ps_ui_r23b2.tools.prepare_studio_projects import prepare


def test_preparation_preserves_user_sources_and_replays(tmp_path):
    assert prepare(tmp_path)["created"] == ["game1", "game2", "game3"]
    edited = tmp_path / "game1/src/input_adapter.py"
    edited.write_text("# user-owned project changes\n", encoding="utf-8")
    replay = tmp_path / "game1/tests/replays/hand-attack-shield.json"
    replay.write_text("user replay edits", encoding="utf-8")
    result = prepare(tmp_path)
    assert not result["created"] and len(result["preserved"]) == 3
    assert edited.read_text(encoding="utf-8") == "# user-owned project changes\n"
    assert replay.read_text(encoding="utf-8") == "user replay edits"


def test_two_simultaneous_launches_preserve_one_complete_project_set(tmp_path):
    with ThreadPoolExecutor(max_workers=2) as pool:
        results = list(pool.map(prepare, (tmp_path, tmp_path)))
    assert sum(len(value["created"]) for value in results) == 3
    for item in ("game1", "game2", "game3"):
        assert (tmp_path / item / "game.toml").is_file()
        assert (tmp_path / item / "src/main.py").is_file()


@pytest.mark.parametrize("item_id", ("game1", "game2", "game3"))
def test_studio_projects_match_board_game_code_and_have_passing_gesture_replays(tmp_path, item_id):
    projects = tmp_path / "projects"
    prepare(projects)
    bundled = tmp_path / "board"
    bundled.mkdir()
    build_bundled_games(bundled)
    studio = build_verified_game(projects / item_id, tmp_path / "studio.vvg",
                                 target_build_id=0xC0061000)
    with zipfile.ZipFile(studio.path) as a, zipfile.ZipFile(bundled / "seed_games" / f"{item_id}.vvg") as b:
        names = lambda archive: {name for name in archive.namelist()
                                 if name != "package.json" and not name.startswith("tests/")}
        assert names(a) == names(b)
        assert all(a.read(name) == b.read(name) for name in names(a))
    paths = sorted((projects / item_id / "tests/replays").glob("*.json"))
    assert paths
    for path in paths:
        case = GameTestCase.load(path)
        assert all(event.kind.value not in ("tone", "voice", "volume") for event in case.events)
        assert case.assertions
        report = run_game_test(studio.path, case)
        assert report.passed, report.to_dict()
