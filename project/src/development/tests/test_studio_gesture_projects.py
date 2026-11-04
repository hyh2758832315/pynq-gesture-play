"""Build and replay the editable gesture projects through the real Studio UI."""
import os
from pathlib import Path

import pytest

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")
from PySide6.QtCore import Qt
from PySide6.QtWidgets import QApplication
from pynq_multimodal_game.game_package import validate_game_package
from pynq_multimodal_game.game_testing import GameTestCase
from pynq_multimodal_game.game_validation import run_game_test
from pynq_multimodal_game.studio.device import RemoteDeviceSession
from pynq_multimodal_game.studio.game_workspace import GameWorkspace
from subprojects.ps_ui_r23b2.tools.prepare_studio_projects import prepare


@pytest.mark.parametrize("item_id", ("game1", "game2", "game3", "game4"))
def test_r23_studio_builds_and_replays_matching_gesture_project(tmp_path, item_id):
    app = QApplication.instance() or QApplication([])
    prepare(tmp_path)
    workspace = GameWorkspace(
        projects_root=tmp_path,
        device=RemoteDeviceSession("127.0.0.1", 8765, expected_build_id=0xC0061000),
    )
    try:
        workspace.input_target.setCurrentIndex(workspace.input_target.findData("pynq"))
        for index in range(workspace.game_list.count()):
            item = workspace.game_list.item(index)
            if Path(item.data(Qt.ItemDataRole.UserRole)).name == item_id:
                workspace.game_list.setCurrentRow(index)
                break
        assert workspace._active_project.name == item_id
        assert workspace.test_case_list.item(0).text() == "手势测试 / 未保存"
        package = workspace.build_active_project()
        manifest = validate_game_package(package).manifest
        assert manifest.target_build_id == 0xC0061000
        assert manifest.volume_inputs is None
        for path in sorted((tmp_path / item_id / "tests/replays").glob("*.json")):
            report = run_game_test(package, GameTestCase.load(path))
            assert report.passed, report.to_dict()
    finally:
        workspace.stop(wait=True)
        workspace.close()
        app.processEvents()
