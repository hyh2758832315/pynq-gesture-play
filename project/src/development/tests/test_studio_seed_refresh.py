"""Managed seeds update automatically; edited legacy trees are recoverable."""
import json
from pathlib import Path

from subprojects.ps_ui_r23b2.tools import prepare_studio_projects as seeds


def test_clean_seed_updates_but_user_edits_survive(tmp_path, monkeypatch):
    seeds.prepare(tmp_path)
    edited = tmp_path / "game1/src/main.py"
    edited.write_text("# user change\n", encoding="utf-8")
    original = seeds.stage_gesture_project
    def revised(item_id, destination, **kwargs):
        original(item_id, destination, **kwargs)
        with (destination / "src/main.py").open("a", encoding="utf-8") as stream:
            stream.write("\n# new accepted release\n")
    monkeypatch.setattr(seeds, "stage_gesture_project", revised)
    result = seeds.prepare(tmp_path)
    assert result["conflicts"] == ["game1"]
    assert result["updated"] == ["game2", "game3", "game4"]
    assert edited.read_text("utf-8") == "# user change\n"
    for name in result["updated"]:
        assert "new accepted release" in (tmp_path / name / "src/main.py").read_text("utf-8")
        assert Path(result["backups"][name]).is_dir()
    assert seeds.prepare(tmp_path)["updated"] == []


def test_explicit_refresh_backs_up_legacy_and_removes_old_replays(tmp_path):
    seeds.prepare(tmp_path)
    for name in seeds.GAME_DISPLAY_NAMES:
        (tmp_path / seeds.MARKER / f"{name}.json").unlink()
        (tmp_path / name / "tests/replays/old.json").write_text("user replay", encoding="utf-8")
    assert len(seeds.prepare(tmp_path)["conflicts"]) == 4
    result = seeds.prepare(tmp_path, refresh_bundled=True)
    assert result["updated"] == list(seeds.GAME_DISPLAY_NAMES)
    for name, backup in result["backups"].items():
        assert (Path(backup) / "tests/replays/old.json").read_text("utf-8") == "user replay"
        assert not (tmp_path / name / "tests/replays/old.json").exists()
        marker = json.loads((tmp_path / seeds.MARKER / f"{name}.json").read_text("utf-8"))
        assert marker["sha256"] == seeds.source_hashes(tmp_path / name)
