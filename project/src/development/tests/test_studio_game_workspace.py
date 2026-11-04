from __future__ import annotations

import os
from pathlib import Path
import threading
import time
import pytest

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")

from PySide6.QtCore import Qt
from PySide6.QtWidgets import QApplication

from pynq_multimodal_game.game_project import GameProject
from pynq_multimodal_game.studio.game_workspace import GameWorkspace
from pynq_multimodal_game.game_testing import GameTestCase, InputKind
from pynq_multimodal_game.studio.device import DeviceSnapshot, DeviceState, RemoteDeviceSession


ROOT = Path(__file__).resolve().parents[1]


class _BlockingGameDevice:
    def __init__(self) -> None:
        self.release_install = threading.Event()
        self.install_calls = 0
        self.snapshot = DeviceSnapshot(
            state=DeviceState.READY,
            name="PYNQ-Z2",
            build_id=0xC0060700,
            message="ready",
            generation=1,
        )

    def install_game(self, _path: Path, *, progress=None) -> dict[str, object]:
        self.install_calls += 1
        assert self.release_install.wait(2.0)
        if progress is not None:
            progress(100, 100)
        return {"ok": True}

    def run_game(
        self, _item_id: str, *, test_case_json: str | None = None
    ) -> dict[str, object]:
        assert test_case_json is not None
        return {
            "ok": True,
            "snapshot": {
                "state": "paused",
                "runtime_mode": "game",
                "game_tick": 600,
                "assertions_passed": 1,
                "assertions_failed": 0,
                "test_complete": True,
            },
        }


def test_game_workspace_keeps_empty_project_root_empty(tmp_path: Path) -> None:
    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=tmp_path / "games")

    assert workspace._active_project is None
    assert workspace.game_list.count() == 0
    assert workspace.pc_test_button.isEnabled() is False
    assert workspace.build_button.isEnabled() is False
    workspace.stop(wait=True)
    workspace.deleteLater()
    app.processEvents()


@pytest.mark.parametrize("build_id", (0xC0060800, 0xC0060900, 0xC0060C00))
def test_game_workspace_builds_selected_fusion_identity_while_offline(tmp_path, build_id):
    from pynq_multimodal_game.game_package import validate_game_package
    from pynq_multimodal_game.studio.device import RemoteDeviceSession

    app = QApplication.instance() or QApplication([])
    project = GameProject.create(tmp_path / "games" / "fusion", game_id="fusion", display_name="Fusion")
    original = project.manifest_path.read_bytes()
    device = RemoteDeviceSession("127.0.0.1", 8765, expected_build_id=build_id)
    workspace = GameWorkspace(projects_root=tmp_path / "games", device=device)
    try:
        assert device.snapshot.build_id is None
        workspace.input_target.setCurrentIndex(workspace.input_target.findData("pynq"))
        package = workspace.build_active_project()
        assert package.name.endswith(f"-{build_id:08X}.vvg")
        assert validate_game_package(package).manifest.target_build_id == build_id
        assert project.manifest_path.read_bytes() == original
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        device.disconnect()
        app.processEvents()


def test_game_workspace_selects_first_project_without_game1_special_case(
    tmp_path: Path,
) -> None:
    app = QApplication.instance() or QApplication([])
    projects_root = tmp_path / "games"
    GameProject.create(
        projects_root / "zeta", game_id="zeta", display_name="Zeta"
    )
    alpha = GameProject.create(
        projects_root / "alpha", game_id="alpha", display_name="Alpha"
    )

    workspace = GameWorkspace(projects_root=projects_root)

    assert workspace._active_project == alpha.root.resolve()
    workspace.stop(wait=True)
    workspace.deleteLater()
    app.processEvents()


def test_default_project_root_finds_game1_outside_repository_cwd(
    tmp_path: Path, monkeypatch,
) -> None:
    app = QApplication.instance() or QApplication([])
    monkeypatch.chdir(tmp_path)

    workspace = GameWorkspace()

    assert workspace.projects_root == ROOT / "games"
    assert workspace._active_project == (ROOT / "games/game1").resolve()
    assert workspace.game_list.count() >= 1
    workspace.stop(wait=True)
    workspace.deleteLater()
    app.processEvents()


def test_game1_is_selected_and_runs_current_test_to_completion() -> None:
    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=ROOT / "games")

    assert workspace._active_project == (ROOT / "games/game1").resolve()
    assert workspace.code_editor.project_root == (ROOT / "games/game1").resolve()
    assert workspace.code_editor.file_tree.topLevelItemCount() == 2
    dependencies = workspace.code_editor.file_tree.topLevelItem(1)
    assert dependencies.text(0) == "平台 API（只读）"
    assert [
        dependencies.child(index).text(0)
        for index in range(dependencies.childCount())
    ] == ["game_sdk.py", "scene.py", "engine/side_scroller.py"]
    workspace.code_editor._open_tree_item(dependencies.child(0))
    dependency_editor = workspace.code_editor.tabs.currentWidget()
    assert dependency_editor is not None and dependency_editor.isReadOnly()
    assert workspace.test_case_list.count() == 1 + len(list((ROOT / "games/game1/tests/replays").glob("*.json")))
    assert workspace.test_case_list.currentRow() == 1
    workspace.test_case_list.setCurrentRow(0)
    workspace.max_ticks_input.setValue(3)

    workspace.start_project_preview()

    deadline = time.monotonic() + 3.0
    while workspace._preview_thread is not None and time.monotonic() < deadline:
        app.processEvents()
        threading.Event().wait(0.01)
    app.processEvents()
    assert workspace._preview_thread is None
    assert workspace._last_pc_frame is not None
    assert workspace._last_pc_frame.snapshot.tick_id == 3
    assert any(
        event.target == "pc" and event.action == "ready"
        for event in workspace.audit_console.events
    )
    workspace.stop(wait=True)
    workspace.deleteLater()
    app.processEvents()


def test_game2_is_discovered_and_runs_its_golden_test() -> None:
    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=ROOT / "games")
    game2 = (ROOT / "games/game2").resolve()
    item = next(
        workspace.game_list.item(index)
        for index in range(workspace.game_list.count())
        if Path(
            workspace.game_list.item(index).data(Qt.ItemDataRole.UserRole)
        ).resolve()
        == game2
    )
    workspace.game_list.setCurrentItem(item)
    workspace._select_game()

    assert workspace._active_project == game2
    assert workspace.test_case_list.count() == 5
    assert workspace.test_case_list.currentRow() == 1
    assert workspace.max_ticks_input.value() == 958
    workspace.start_project_preview()

    try:
        deadline = time.monotonic() + workspace.max_ticks_input.value() / 60 * 3 + 8.0
        while workspace._preview_thread is not None and time.monotonic() < deadline:
            app.processEvents()
            threading.Event().wait(0.01)
        app.processEvents()
        assert workspace._preview_thread is None
        assert workspace._last_pc_frame is not None
        assert workspace._last_pc_frame.snapshot.status == "WON"
        assert workspace._last_pc_frame.snapshot.score == 3
        assert workspace._last_pc_report["status"] == "passed"
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()


def test_game3_is_discovered_and_runs_hero_selection_replay() -> None:
    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=ROOT / "games")
    game3 = (ROOT / "games/game3").resolve()
    item = next(workspace.game_list.item(index) for index in range(workspace.game_list.count()) if Path(workspace.game_list.item(index).data(Qt.ItemDataRole.UserRole)).resolve() == game3)
    workspace.game_list.setCurrentItem(item)
    workspace._select_game()
    workspace.test_case_list.setCurrentRow(4)
    assert workspace.test_case_list.count() == 5
    assert workspace.current_test_case().test_id == "kingdom-04-hero-selection"
    workspace.start_project_preview()
    try:
        deadline = time.monotonic() + 120 / 60 * 3 + 10
        while workspace._preview_thread is not None and time.monotonic() < deadline:
            app.processEvents()
            threading.Event().wait(0.01)
        app.processEvents()
        assert workspace._preview_thread is None
        assert workspace._last_pc_frame.snapshot.values["character"] == "female"
        assert workspace._last_pc_report["status"] == "passed"
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()


def test_game2_manual_play_ignores_replay_and_audits_seed(monkeypatch) -> None:
    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=ROOT / "games")
    game2 = (ROOT / "games/game2").resolve()
    item = next(workspace.game_list.item(index) for index in range(workspace.game_list.count()) if Path(workspace.game_list.item(index).data(Qt.ItemDataRole.UserRole)).resolve() == game2)
    workspace.game_list.setCurrentItem(item)
    monkeypatch.setattr("pynq_multimodal_game.studio.game_workspace.secrets.randbits", lambda bits: 1234)
    workspace.max_ticks_input.setValue(1)
    assert workspace.pc_play_button.isEnabled()
    workspace.pc_play_button.click()
    worker = workspace._preview_worker
    assert worker is not None and worker.seed == 1234 and worker._test_case is None
    try:
        deadline = time.monotonic() + 4
        while (workspace._last_pc_frame is None or workspace._last_pc_frame.snapshot.tick_id < 10) and time.monotonic() < deadline:
            app.processEvents()
            threading.Event().wait(0.01)
        assert workspace._last_pc_frame.snapshot.tick_id >= 10
        assert workspace._preview_thread is not None
        assert workspace._last_pc_report is None and not workspace._pc_test_complete
        assert workspace._last_pc_frame.snapshot.values["phase"] == "READY"
        start = next(event for event in reversed(workspace.audit_console.events) if event.action == "start" and event.target == "pc")
        assert start.details == {"seed": 1234, "mode": "interactive"}
        workspace.inject_fist()
        assert worker._next_input(11).hand_gesture.value == "fist"
    finally:
        workspace.stop(wait=True)
        app.processEvents()
        assert workspace._last_pc_report is None
        workspace.input_target.setCurrentIndex(1)
        assert not workspace.pc_play_button.isEnabled()
        workspace.deleteLater()
        app.processEvents()


def test_pc_play_button_stops_live_session_and_unlocks_controls(tmp_path):
    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=tmp_path / "games")
    workspace.create_project(game_id="pc-play", display_name="PC Play")
    try:
        workspace.pc_play_button.click()
        deadline = time.monotonic() + 5
        while workspace._last_pc_frame is None and time.monotonic() < deadline:
            app.processEvents()
            threading.Event().wait(0.01)
        assert workspace._last_pc_frame is not None
        assert workspace.pc_play_button.isEnabled() and workspace.pc_play_button.text() == "停止试玩"
        assert workspace.play_button.isEnabled() and workspace.reset_button.isEnabled()
        assert workspace.hand_button.isEnabled() and not workspace.game_list.isEnabled()
        workspace.play_button.click()
        assert workspace._preview_worker.paused
        workspace.reset_button.click()
        assert workspace._preview_worker._reset_requested.is_set()
        thread = workspace._preview_thread
        workspace.pc_play_button.click()
        assert workspace._preview_stopping and workspace._preview_thread is thread
        assert not workspace.pc_play_button.isEnabled() and not workspace.game_list.isEnabled()
        deadline = time.monotonic() + 5
        while workspace._preview_thread is not None and time.monotonic() < deadline:
            app.processEvents()
            threading.Event().wait(0.01)
        app.processEvents()
        assert workspace._preview_thread is None and workspace._preview_worker is None
        assert workspace.pc_play_button.isEnabled() and workspace.pc_play_button.text() == "PC 试玩"
        assert workspace.game_list.isEnabled() and workspace.build_button.isEnabled()
        assert workspace.input_target.isEnabled() and not workspace.play_button.isChecked()
        workspace.pc_play_button.click()
        assert workspace._preview_thread is not None
        workspace.stop(wait=True)
        workspace.pc_play_button.click()
        new_thread = workspace._preview_thread
        new_worker = workspace._preview_worker
        deadline = time.monotonic() + 5
        while workspace.status_label.text() != "RUNNING" and time.monotonic() < deadline:
            app.processEvents()
            threading.Event().wait(0.01)
        assert workspace._preview_thread is new_thread and workspace._preview_worker is new_worker
        assert new_thread.isRunning() and workspace.play_button.isEnabled()
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()


def test_game1_manual_death_unlocks_workspace_without_test_report(monkeypatch):
    from pynq_multimodal_game.game_sdk import HandGesture

    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=ROOT / "games")
    game1 = (ROOT / "games/game1").resolve()
    item = next(workspace.game_list.item(index) for index in range(workspace.game_list.count())
                if Path(workspace.game_list.item(index).data(Qt.ItemDataRole.UserRole)).resolve() == game1)
    workspace.game_list.setCurrentItem(item)
    monkeypatch.setattr("pynq_multimodal_game.studio.game_workspace.secrets.randbits", lambda bits: 1234)
    try:
        workspace.pc_play_button.click()
        workspace._preview_worker.inject_gesture(x=160, y=90, gesture=HandGesture.PAPER)
        deadline = time.monotonic() + 10
        while workspace._preview_thread is not None and time.monotonic() < deadline:
            app.processEvents()
            threading.Event().wait(0.01)
        app.processEvents()
        assert workspace._preview_thread is None, workspace._last_pc_frame.snapshot
        assert workspace._last_pc_frame.snapshot.status == "LOST"
        assert workspace.status_label.text() == "LOST"
        assert workspace._last_pc_report is None and not workspace._pc_test_complete
        assert workspace.pc_play_button.isEnabled() and workspace.build_button.isEnabled()
        assert workspace.game_list.isEnabled() and workspace.input_target.isEnabled()
        assert not workspace.play_button.isChecked() and not workspace.play_button.isEnabled()
        assert any(event.action == "finish" and event.result == "lost"
                   for event in workspace.audit_console.events)
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()


def test_game_workspace_switching_projects_ignores_stale_editor_updates(tmp_path: Path) -> None:
    app = QApplication.instance() or QApplication([])
    projects = tmp_path / "games"
    GameProject.create(projects / "alpha", game_id="alpha", display_name="Alpha")
    GameProject.create(projects / "beta", game_id="beta", display_name="Beta")
    workspace = GameWorkspace(projects_root=projects)
    old_editor = workspace.code_editor.tabs.currentWidget()
    workspace.game_list.setCurrentRow(1)
    old_editor.insertPlainText("stale")
    assert not workspace.code_editor.dirty
    assert workspace.code_editor.project_root == (projects / "beta").resolve()
    workspace.stop(wait=True)
    workspace.deleteLater()
    app.processEvents()


def test_game_workspace_creates_edits_and_builds_multifile_project(
    tmp_path: Path,
) -> None:
    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=tmp_path / "games")

    project = workspace.create_project(game_id="studio-test", display_name="Studio Test")
    assert project.is_dir()
    assert workspace.game_list.count() == 1
    assert workspace.view_tabs.tabText(0) == "游戏画面"
    assert workspace.view_tabs.tabText(1) == "游戏源代码"
    assert workspace.view_tabs.tabText(2) == "测试时间线"
    assert workspace.code_editor.project_root == project.resolve()
    assert workspace.pc_test_button.isEnabled() is True
    assert workspace.build_button.isEnabled() is True

    package = workspace.build_active_project()
    assert package is not None and package.is_file()
    assert workspace.install_button.isEnabled() is False
    workspace.stop(wait=True)
    workspace.deleteLater()
    app.processEvents()


def test_game_workspace_imports_and_refreshes_projects(tmp_path: Path) -> None:
    app = QApplication.instance() or QApplication([])
    projects_root = tmp_path / "managed-games"
    workspace = GameWorkspace(projects_root=projects_root)
    imported_source = GameProject.create(
        tmp_path / "incoming", game_id="imported", display_name="Imported"
    )

    imported = workspace.import_project(imported_source.root)

    assert imported == projects_root / "imported"
    assert workspace._active_project == imported.resolve()
    assert workspace.game_list.count() == 1
    GameProject.create(
        projects_root / "external", game_id="external", display_name="External"
    )
    workspace.refresh_projects()
    assert workspace.game_list.count() == 2
    assert workspace._active_project == imported.resolve()
    assert workspace.audit_console.events[-1].action == "refresh"
    workspace.stop(wait=True)
    workspace.deleteLater()
    app.processEvents()


def test_game_workspace_edits_saves_and_audits_test_case(tmp_path: Path) -> None:
    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=tmp_path / "games")
    project = workspace.create_project(game_id="timeline", display_name="Timeline")
    workspace.test_name_input.setText("Input audit")
    workspace.max_ticks_input.setValue(90)
    workspace.event_tick_input.setValue(3)
    workspace.x_input.setValue(80)
    workspace.y_input.setValue(60)

    workspace._add_timeline_event(InputKind.FIST)
    workspace._add_assertion_row()
    workspace.assertion_table.item(0, 0).setText("3")
    saved = workspace.save_current_test_case()

    assert saved == project / "tests" / "replays" / "manual-session.json"
    loaded = GameTestCase.load(saved)
    assert loaded.name == "Input audit"
    assert loaded.events[0].kind is InputKind.FIST
    assert (loaded.events[0].x, loaded.events[0].y) == (80, 60)
    assert workspace.test_case_list.count() == 2
    assert workspace.audit_console.table.rowCount() >= 1
    assert workspace.audit_console.events[-1].action == "save"
    assert workspace.hand_button.isEnabled() is False
    assert "尚未运行" in workspace.hand_button.toolTip()
    workspace._delete_test_case()
    assert saved.exists() is False
    assert workspace.test_case_list.count() == 1
    assert workspace.audit_console.events[-1].action == "delete"
    workspace.stop(wait=True)
    workspace.deleteLater()
    app.processEvents()


def test_workspace_three_gesture_controls_and_timeline_round_trip(tmp_path: Path) -> None:
    from pynq_multimodal_game.game_sdk import HandGesture
    from pynq_multimodal_game.studio.game_worker import GamePreviewWorker

    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=tmp_path / "games")
    try:
        workspace.create_project(game_id="gestures", display_name="Gestures")
        workspace.input_target.setCurrentIndex(workspace.input_target.findData("pc"))
        worker = GamePreviewWorker(Path("unused.vvg"))
        workspace._preview_worker = worker
        for tick, gesture in enumerate((HandGesture.PAPER, HandGesture.SCISSORS, HandGesture.FIST)):
            workspace.gesture_buttons[gesture].click()
            assert workspace.selected_gesture() is gesture
            assert sum(button.isChecked() for button in workspace.gesture_buttons.values()) == 1
            workspace.event_tick_input.setValue(tick)
            workspace._add_timeline_event(InputKind.GESTURE)
            workspace.inject_selected_gesture()
            game_input = worker._next_input(tick)
            assert game_input.hand_gesture is gesture
            workspace._show_input_state(game_input, "PC 手动")
            assert "已消费" in workspace.gesture_readout.text()
        case = workspace.current_test_case()
        assert case.schema_version == 2
        assert [event.gesture for event in case.events] == [HandGesture.PAPER, HandGesture.SCISSORS, HandGesture.FIST]
        assert GameTestCase.from_json(case.to_json()) == case
        workspace.cancel_inputs()
        assert worker._next_input(3).hand_gesture is None
        assert "已取消" in workspace.gesture_readout.text()
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()


def test_live_deploy_preserves_pc_gate_and_omits_replay_json(tmp_path, monkeypatch):
    from unittest.mock import MagicMock

    app = QApplication.instance() or QApplication([])
    device = _BlockingGameDevice()
    device.release_install.set()
    device.start_shared_vision = MagicMock(return_value={"ok": True})
    device.run_game = MagicMock(return_value={"ok": True})
    workspace = GameWorkspace(projects_root=tmp_path / "games", device=device)
    try:
        workspace.create_project(game_id="live-routing", display_name="Live Routing")
        package = workspace.build_active_project()
        case = workspace.current_test_case()
        workspace._validation_stop.clear()
        result = workspace._validated_deploy(device, package, case, progress=lambda *_: None, run=True, live=True)
        assert result["live"] and device.install_calls == 1
        assert list((tmp_path / "games/.reports/live-routing").glob("*-pc.json"))
        device.start_shared_vision.assert_called_once()
        assert device.start_shared_vision.call_args.kwargs["game_id"] == "live-routing"
        assert device.run_game.call_args.kwargs["test_case_json"] is None
        device.start_shared_vision.side_effect = RuntimeError("vision hardware FAULT")
        device.run_game.reset_mock()
        import pytest
        with pytest.raises(RuntimeError, match="vision hardware FAULT"):
            workspace._validated_deploy(device, package, case, progress=lambda *_: None, run=True, live=True)
        device.run_game.assert_not_called()
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()


def test_live_readout_uses_completed_scene_receipt_and_marks_history(tmp_path):
    from pynq_multimodal_game.vision_input import GameVisionInputProvider

    app = QApplication.instance() or QApplication([])
    device = _BlockingGameDevice()
    workspace = GameWorkspace(projects_root=tmp_path / "games", device=device)
    provider = GameVisionInputProvider(clock=lambda: 1.0)
    provider.publish({"run_id": "r" * 128, "frame": 7, "server_age_ms": 0, "stable": "2", "rps": "SCISSORS",
                      "control": {"schema": "gesture-control-v1", "frame_id": 7, "action_event_seq": 0,
                                  "valid": True, "direction": "RIGHT"}}, config_epoch="e" * 128)
    try:
        for game_id in ("game1", "game2", "game3"):
            sample, receipt = provider.sample_for_game(game_id, tick_id=42)
            assert receipt["source_hand_gesture"] == "scissors"
            receipt.update(scene_tick=42, scene_sha256="a" * 64, sink_completion="confirmed",
                           runtime_presented_frames=43)
            snapshot = {"profile": "C6I_VISION", "state": "running", "runtime_mode": "game", "game_tick": 42,
                        "vision": {"input_capabilities": provider.capabilities}, "vision_consumption": receipt}
            workspace._apply_pynq_snapshot(snapshot)
            assert workspace._pynq_live
            workspace._refresh_action_states()
            assert not workspace.hand_button.isEnabled() and not workspace.step_button.isEnabled()
            assert "本地视觉 / 剪刀" in workspace.gesture_readout.text()
            workspace.resize(1080, 700)
            workspace.show()
            app.processEvents()
            assert not workspace.vision_readout.isHidden()
            assert all(label.height() >= label.fontMetrics().height()
                       for label in workspace.vision_readout_values.values())
            assert workspace.view_tabs.widget(0).horizontalScrollBar().maximum() == 0
            assert workspace.vision_readout_values["mode"].toolTip() == "三游戏"
            assert workspace.vision_readout_values["game_id"].toolTip() == game_id
            assert workspace.vision_readout_values["source_frame_id"].toolTip() == "7"
            assert workspace.vision_readout_values["ticks"].toolTip() == "42 / 42"
            assert workspace.vision_readout_values["gesture_direction"].toolTip() == "剪刀 / RIGHT"
            assert workspace.vision_readout_values["scene_sha256"].toolTip() == "a" * 64
            assert workspace.vision_readout_values["sink"].toolTip() == "已确认 / 43"
            snapshot["vision_consumption"] = {**receipt, "scene_tick": 41}
            workspace._apply_pynq_snapshot(snapshot)
            assert workspace.vision_readout_values["sink"].toolTip() == "待确认"
            snapshot["vision"] = {"input_capabilities": {"mode": []}}
            snapshot["vision_consumption"] = {**receipt, "scene_sha256": "invalid"}
            workspace._apply_pynq_snapshot(snapshot)
            assert workspace.vision_readout_values["mode"].toolTip() == "未确认"
            assert workspace.vision_readout_values["sink"].toolTip() == "待确认"
            workspace._apply_pynq_snapshot({**snapshot, "vision_consumption": receipt})
        device.snapshot = DeviceSnapshot(DeviceState.ERROR, "test", None, "lost", 2)
        workspace.refresh_device_state()
        assert "历史" in workspace.board_source_label.text()
        assert workspace.vision_readout_values["scene_sha256"].toolTip() == "a" * 64
        workspace._device_task_failed("poll", "connection lost")
        assert "保留上次回读" in workspace.board_source_label.text()
        workspace._apply_pynq_snapshot({"state": "idle", "runtime_mode": "menu"})
        assert not workspace._pynq_live
        assert workspace.vision_readout.isHidden()
        assert workspace.vision_readout_values["scene_sha256"].toolTip() == "--"
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()


@pytest.mark.parametrize("build_id", (0xC0060800, 0xC0060900))
def test_studio_three_games_live_over_real_tcp_and_rejects_legacy(tmp_path, record_property, build_id):
    import json
    import shutil
    from test_c6i_shell import _Session, _Sink
    from pynq_multimodal_game.agent.core import AgentController
    from pynq_multimodal_game.agent.transport import AgentServer
    from pynq_multimodal_game.agent.vision_backend import C6IVisionRuntimeBackend, SharedVisionSupervisor
    from pynq_multimodal_game.agent.voice_backend import C6IVoiceFusionRuntimeBackend, VoiceSupervisor
    from test_voice_backend import FakeCapture
    from pynq_multimodal_game.library import AssetLibrary
    from pynq_multimodal_game.studio.device import RemoteDeviceSession
    from pynq_multimodal_game.vision_input import GameVisionInputProvider, VisionInputProvider

    app = QApplication.instance() or QApplication([])
    projects = tmp_path / "games"
    game_ids = ("game1", "game1-voice-s2", "game2", "game3") if build_id == 0xC0060900 else ("game1", "game2", "game3")
    for game_id in game_ids:
        source = ROOT / ("candidates" if game_id == "game1-voice-s2" else "games") / game_id
        shutil.copytree(source, projects / game_id,
                        ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
    evidence = []
    for provider_type in (VisionInputProvider, GameVisionInputProvider):
        provider = provider_type(clock=time.monotonic)
        workers = []

        class Worker:
            state = "IDLE"
            error = diagnostic_error = None
            frame_id = 0

            def __init__(self, run_id):
                self.run_id = run_id
                self.stopping = threading.Event()
                self.thread = None
                workers.append(self)

            def feed(self):
                self.frame_id += 1
                provider.publish({"run_id": self.run_id, "frame": self.frame_id, "stable": "5", "rps": "PAPER",
                                  "server_age_ms": 0, "control": {"schema": "gesture-control-v1",
                                  "frame_id": self.frame_id, "action_event_seq": 0, "valid": True, "direction": "RIGHT"}})

            def start(self):
                self.state = "RUNNING"
                self.feed()
                def publish():
                    while not self.stopping.wait(.05):
                        self.feed()
                self.thread = threading.Thread(target=publish)
                self.thread.start()

            def stop(self):
                self.stopping.set()
                if self.thread is not None:
                    self.thread.join(1)
                    assert not self.thread.is_alive()
                self.state = "STOPPED"

        session = _Session()
        session.build_id = build_id
        sink = _Sink()
        supervisor = SharedVisionSupervisor(Worker, provider)
        library = AssetLibrary(tmp_path / provider.capabilities["mode"], minimum_free_bytes=0, minimum_free_fraction=0)
        def voice_factory(**options):
            voice = VoiceSupervisor(FakeCapture, packet_limit=3, **options)
            prepare = voice.prepare
            voice.preparation_started = voice.preparation_elapsed = None

            def timed_prepare():
                voice.preparation_started = time.monotonic()
                try:
                    return prepare()
                finally:
                    voice.preparation_elapsed = time.monotonic() - voice.preparation_started
                    record_property("voice_preparation_seconds", voice.preparation_elapsed)

            voice.prepare = timed_prepare
            return voice

        voice_options = {"voice_factory": voice_factory} if build_id == 0xC0060900 else {}
        backend_type = C6IVoiceFusionRuntimeBackend if voice_options else C6IVisionRuntimeBackend
        backend = backend_type(session, supervisor, menu_fps=0, library=library,
                       sink_factory=lambda _session, _timeout: sink, **voice_options)
        backend.open()
        controller = AgentController(backend)
        server = AgentServer(controller)
        server.start()
        device = RemoteDeviceSession(*server.address, expected_build_id=build_id)
        workspace = GameWorkspace(projects_root=projects, device=device)
        try:
            assert device.connect().state is DeviceState.READY
            workspace.pynq_input_mode.setCurrentIndex(workspace.pynq_input_mode.findData("vision"))
            for game_id in game_ids:
                row = next(index for index in range(workspace.game_list.count())
                    if Path(workspace.game_list.item(index).data(Qt.ItemDataRole.UserRole)).name == game_id)
                workspace.game_list.setCurrentRow(row)
                assert workspace._active_project.name == game_id
                if workers:
                    workers[0].feed()
                workspace.start_project_preview()
                deadline = time.monotonic() + 20
                while workspace._device_thread is not None and time.monotonic() < deadline:
                    app.processEvents()
                    threading.Event().wait(0.01)
                app.processEvents()
                assert workspace._device_thread is None
                workspace._pynq_status_timer.stop()
                assert workspace._last_pc_report["status"] == "passed"
                if provider_type is VisionInputProvider:
                    assert not workspace._pynq_running and not workers
                    assert backend.snapshot.runtime_mode == "menu"
                    assert any("native game vision mode" in str(event.details) for event in workspace.audit_console.events)
                    evidence.append({"mode": "legacy_horizontal", "rejected_before_vision_start": True})
                    break
                failure = [str(event.details) for event in workspace.audit_console.events]
                if build_id == 0xC0060900:
                    voice = backend._voice
                    failure.append({"client_timeout": device._client.timeout, "voice": backend.voice_status,
                        "prepare_elapsed": getattr(voice, "preparation_elapsed", None),
                        "prepare_started": getattr(voice, "preparation_started", None)})
                assert workspace._pynq_running and workspace._pynq_live, failure
                assert backend._game._test_case is None
                if build_id == 0xC0060800:
                    assert backend._game._live_input is provider
                else:
                    backend._voice._thread_handle.join(10)
                    monitor = device.create_voice_monitor()
                    try:
                        observed = monitor.request()["snapshot"]["voice"]
                        assert observed["packets"] == observed["cpu"]["received"] == 3
                        assert len(observed["pcm"]["samples"]) == 240 and observed["pcm"]["historical"] is True
                        assert observed["runtime_registered"] is False and observed["release_ready"] is False
                    finally:
                        monitor.close()
                assert not workspace.hand_button.isEnabled() and not workspace.tone_button.isEnabled()
                assert not workspace.step_button.isEnabled()
                snapshot = device.video_status()["snapshot"]
                deadline = time.monotonic() + 3
                while ((snapshot.get("vision_consumption") or {}).get("source_hand_gesture") != "paper"
                       and time.monotonic() < deadline):
                    threading.Event().wait(.01)
                    snapshot = device.video_status()["snapshot"]
                workspace._apply_pynq_snapshot(snapshot)
                receipt = snapshot["vision_consumption"]
                assert receipt["game_id"] == game_id and receipt["source_hand_gesture"] == "paper", {"receipt": receipt,
                    "vision": snapshot.get("vision"), "audio": snapshot.get("audio_consumption")}
                assert workspace.vision_readout_values["game_id"].toolTip() == game_id
                if game_id == "game1-voice-s2":
                    assert snapshot["audio_consumption"]["game_id"] == game_id
                    assert snapshot["audio_consumption"]["action_mapped"] is True
                    assert workspace.vision_readout_values["audio_sink"].toolTip().startswith("已确认")
                assert workspace.vision_readout_values["sink"].toolTip().startswith("已确认")
                installed = device.list_library("game")["library_items"]
                assert any(item["item_id"] == game_id and item["sha256"] == workspace._last_pc_report["package"]["sha256"]
                           for item in installed)
                evidence.append({"game_id": game_id, "package_sha256": workspace._last_pc_report["package"]["sha256"],
                                 "receipt": receipt})
                device.disconnect()
                workspace.refresh_device_state()
                assert "历史" in workspace.board_source_label.text()
                workers[0].feed()
                assert device.connect().state is DeviceState.READY
                workspace.refresh_device_state()
                assert "历史" in workspace.board_source_label.text()
                workspace._apply_pynq_snapshot(device.video_status()["snapshot"])
                assert "历史" not in workspace.board_source_label.text()
                workspace._apply_pynq_snapshot(device.stop_video()["snapshot"])
                assert backend.snapshot.runtime_mode == "menu" and not sink.closed
            if provider_type is GameVisionInputProvider:
                assert len(workers) == (1 + len(game_ids) if build_id == 0xC0060900 else 1)
                assert all(not worker.thread.is_alive() for worker in workers[:-1])
                assert workers[-1].thread.is_alive()
        finally:
            workspace.stop(wait=True)
            workspace.deleteLater()
            device.disconnect()
            server.close()
            controller.close()
            backend.close()
            app.processEvents()
    record_property("studio_live_chain", json.dumps({"scope": "PC Qt/real TCP/upload/VVG; synthetic vision/fake GPU sink; 900 finite synthetic PCM/real CPU worker",
                    "build_id": build_id,
                    "hardware_acceptance": "pending", "cases": evidence}, sort_keys=True))


def test_studio_audio_scene_readout_requires_same_tick_and_sha(tmp_path):
    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=tmp_path)
    try:
        snapshot = {"vision": {}, "audio_consumption": {"sample_tick": 4, "scene_tick": 5,
            "scene_sha256": "a" * 64, "sink_completion": "confirmed", "events": [{"kind": "clap"}],
            "action_mapped": True, "decisions": [{"approved": True}], "game_effects": {"fire": 1}}}
        workspace._apply_pynq_snapshot(snapshot)
        values = workspace.vision_readout_values
        assert values["audio_sink"].toolTip() == "待确认"
        assert "clap" in values["audio_recognition"].toolTip() and "approved" in values["audio_approval"].toolTip()
        assert '"fire": 1' in values["audio_effects"].toolTip()
        snapshot["audio_consumption"]["scene_tick"] = 4
        workspace._apply_pynq_snapshot(snapshot)
        assert values["audio_sink"].toolTip() == "已确认 / tick 4"
        snapshot["audio_consumption"]["scene_sha256"] = "z" * 64
        workspace._apply_pynq_snapshot(snapshot)
        assert values["audio_sink"].toolTip() == "待确认"
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()


@pytest.mark.parametrize("fault", (None, "run", "game", "tick", "bool_tick", "sha", "current_sha", "ack", "consume", "execute", "signal"))
def test_studio_volume_scene_readout_requires_complete_bound_chain(tmp_path, fault):
    from dataclasses import asdict
    from pynq_multimodal_game.game_sdk import VolumeSignal
    receipt = {"signal": asdict(VolumeSignal("a" * 32, 1, 1, "LOUD", 977, 1)),
        "game_run": "b" * 32, "game_id": "game1-volume-v1", "sample_tick": 4, "scene_tick": 4,
        "scene_sha256": "a" * 64, "sink_completion": "confirmed", "game_effects": {"attacks_fired": 1},
        "hardware_acked": True, "logic_consumed": True, "logic_executed": True}
    snapshot = {"game_id": "game1-volume-v1", "scene_sha256": "a" * 64,
                "vision_consumption": {"game_run": "b" * 32}, "volume_consumption": receipt}
    if fault == "run": receipt["game_run"] = "c" * 32
    if fault == "game": receipt["game_id"] = "other"
    if fault == "tick": receipt["scene_tick"] = 5
    if fault == "bool_tick": receipt["sample_tick"] = receipt["scene_tick"] = True
    if fault == "sha": receipt["scene_sha256"] = "z" * 64
    if fault == "current_sha": snapshot["scene_sha256"] = "d" * 64
    if fault == "ack": receipt["hardware_acked"] = False
    if fault == "consume": receipt["logic_consumed"] = False
    if fault == "execute": receipt["logic_executed"] = False
    if fault == "signal": receipt["signal"]["sequence"] = True
    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=tmp_path)
    try:
        workspace._apply_pynq_snapshot(snapshot)
        assert workspace.vision_readout_values["volume_sink"].toolTip() == ("已确认 / tick 4" if fault is None else "待确认")
        count = len(workspace.audit_console.events)
        workspace._apply_pynq_snapshot(snapshot)
        assert len(workspace.audit_console.events) == count
    finally:
        workspace.stop(wait=True); workspace.deleteLater(); app.processEvents()


def test_studio_c0c_three_games_volume_status_and_scene_over_real_tcp(tmp_path, monkeypatch, record_property):
    import json
    import shutil
    from types import SimpleNamespace
    from test_c6i_shell import _Session, _Sink
    from test_volume_monitor import volume_fixture
    from pynq_multimodal_game.agent.core import AgentController
    from pynq_multimodal_game.agent.transport import AgentServer
    from pynq_multimodal_game.agent.vision_backend import C6IVolumeRuntimeBackend, SharedVisionSupervisor
    from pynq_multimodal_game.library import AssetLibrary
    from pynq_multimodal_game.studio.audio_workspace import AudioWorkspace
    from pynq_multimodal_game.studio.device import RemoteDeviceSession
    from pynq_multimodal_game.vision_input import GameVisionInputProvider
    from pynq_multimodal_game.volume_input import VolumeEventLatch
    import importlib.util

    spec = importlib.util.spec_from_file_location("studio_volume_builder", ROOT / "candidates/volume-v1/build.py")
    builder = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(builder)
    projects = tmp_path / "games"
    for game_id in ("game1", "game3"):
        builder.stage_project(game_id, projects / (game_id + "-volume-v1"))
    shutil.copytree(ROOT / "games/game2", projects / "game2", ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
    provider = GameVisionInputProvider(clock=lambda: 1.0)
    workers, lifecycle, evidence = [], [], []

    class Volume:
        offered = None
        reads = 0
        def __init__(self):
            self.acks = []
            self.stopping, self.thread = threading.Event(), None
            self.latch = VolumeEventLatch(SimpleNamespace(monitor=self.monitor,
                event=lambda: self.offered, acknowledge=self.acknowledge), producer_run="a" * 32)
        def monitor(self):
            assert self.thread is None or threading.current_thread() is self.thread
            self.reads += 1
            event = self.offered
            return volume_fixture(sample_count=self.reads * 977, window_count=self.reads,
                event=None if event is None else {"kind": event.kind,
                "epoch": event.epoch, "sequence": event.sequence, "source_sample": event.source_sample,
                "source_window": event.source_window, "age_ms": 0})
        def acknowledge(self, event):
            assert event is self.offered
            self.acks.append(event)
            self.offered = None
        def open(self):
            lifecycle.append("volume_open")
            self.latch.release()
            self.latch.poll_once()
            def poll():
                while not self.stopping.wait(.02):
                    self.latch.poll_once()
            self.thread = threading.Thread(target=poll)
            self.thread.start()
        def close(self):
            lifecycle.append("volume_close")
            self.stopping.set()
            self.thread.join(1)
            assert not self.thread.is_alive()
            self.latch.release()
        def status(self):
            latch = self.latch.status()
            observation = latch.pop("observation")
            return {"profile": "C6I_VISION_VOLUME_V1", "build_id": 0xC0060C00,
                "error": latch["error"], "sampling_enabled": True, "poller_alive": self.thread.is_alive(),
                "lease_retained": True, "latch": latch, "observation": observation}
        def offer(self, kind):
            sequence = len(self.acks) + 1
            self.offered = SimpleNamespace(kind=kind, epoch=1, sequence=sequence,
                source_sample=sequence * 977, source_window=sequence, expires=time.monotonic() + .1)
            deadline = time.monotonic() + 3
            while self.offered is not None and time.monotonic() < deadline:
                threading.Event().wait(.001)
            assert self.offered is None, self.latch.status()

    class Worker:
        state = "IDLE"
        error = diagnostic_error = None
        frame_id = 7
        def __init__(self, run_id):
            self.run_id = run_id
            workers.append(self)
        def start(self):
            self.state = "RUNNING"
            provider.publish({"run_id": self.run_id, "frame": 7, "stable": "5", "rps": "PAPER",
                "server_age_ms": 0, "control": {"schema": "gesture-control-v1", "frame_id": 7,
                "action_event_seq": 0, "valid": True, "direction": "RIGHT"}})
        def stop(self):
            self.state = "STOPPED"

    session, sink, volume = _Session(), _Sink(), Volume()
    session.build_id = 0xC0060C00
    supervisor = SharedVisionSupervisor(Worker, provider)
    backend = C6IVolumeRuntimeBackend(session, supervisor, volume_factory=lambda _owner: volume,
        menu_fps=0, library=AssetLibrary(tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0),
        sink_factory=lambda *_args: sink)
    backend.open()
    controller = AgentController(backend)
    server = AgentServer(controller)
    server.start()
    device = RemoteDeviceSession(*server.address, expected_build_id=0xC0060C00)
    app = QApplication.instance() or QApplication([])
    workspace, audio = GameWorkspace(projects_root=projects, device=device), AudioWorkspace(device)
    monitor = device.create_volume_monitor()
    try:
        assert device.connect().state is DeviceState.READY
        for _index in range(3):
            audio.accept_observation(monitor.request())
        assert not volume.acks and volume.thread.is_alive()
        assert audio.contract_value.text() == "C0C / C0060C00"
        workspace.pynq_input_mode.setCurrentIndex(workspace.pynq_input_mode.findData("vision"))
        for game_id, mapping, kinds in (("game1-volume-v1", "game1", ("SOFT", "LOUD")),
                                       ("game2", "game2", ()), ("game3-volume-v1", "game3", ("SOFT", "LOUD"))):
            row = next(index for index in range(workspace.game_list.count())
                if Path(workspace.game_list.item(index).data(Qt.ItemDataRole.UserRole)).name == game_id)
            workspace.game_list.setCurrentRow(row)
            workspace.start_project_preview()
            deadline = time.monotonic() + 20
            while workspace._device_thread is not None and time.monotonic() < deadline:
                app.processEvents()
                threading.Event().wait(.01)
            app.processEvents()
            workspace._pynq_status_timer.stop()
            assert workspace._device_thread is None and workspace._pynq_running and workspace._pynq_live, [
                str(event.details) for event in workspace.audit_console.events]
            assert workspace._last_pc_report["status"] == "passed" and backend._game._test_case is None
            assert backend._game._live_input._mapping == mapping
            game = backend._game
            complete = game._complete_scene
            def hold_event(frame, visual, receipt, complete=complete, game=game):
                complete(frame, visual, receipt)
                if receipt is not None and receipt.get("signal") is not None:
                    game.pause()
            monkeypatch.setattr(game, "_complete_scene", hold_event)
            for kind in kinds:
                if game.paused:
                    device.resume_game()
                volume.offer(kind)
                deadline = time.monotonic() + 3
                while time.monotonic() < deadline:
                    snapshot = device.video_status()["snapshot"]
                    receipt = snapshot.get("volume_consumption")
                    if receipt and (receipt.get("signal") or {}).get("sequence") == len(volume.acks):
                        break
                    threading.Event().wait(.001)
                assert receipt["signal"]["kind"] == kind and receipt["signal"]["sequence"] == len(volume.acks)
                assert receipt["hardware_acked"] and receipt["logic_consumed"] and receipt["logic_executed"]
                assert receipt["scene_sha256"] == snapshot["scene_sha256"]
                workspace._apply_pynq_snapshot(snapshot)
                assert workspace.vision_readout_values["volume_sink"].toolTip().startswith("已确认")
                if mapping == "game1":
                    assert receipt["game_effects"]["shield_active"]
                    assert receipt["game_effects"]["attacks_fired"] == int(kind == "LOUD")
                evidence.append({"game_id": game_id, "kind": kind, "receipt": receipt})
            observed = monitor.request()
            audio.accept_observation(observed)
            monitor.close()
            assert volume.thread.is_alive() and lifecycle == ["volume_open"]
            assert device.video_status()["snapshot"]["vision"]["state"] == "RUNNING"
            device.disconnect()
            workspace.refresh_device_state()
            assert "历史" in workspace.board_source_label.text()
            assert device.connect().state is DeviceState.READY
            workspace._apply_pynq_snapshot(device.video_status()["snapshot"])
            workspace._apply_pynq_snapshot(device.stop_video()["snapshot"])
            assert backend.snapshot.runtime_mode == "menu" and not sink.closed
        assert len(workers) == 1 and len(volume.acks) == 4
    finally:
        monitor.close(); audio.stop(); workspace.stop(wait=True)
        audio.deleteLater(); workspace.deleteLater(); device.disconnect()
        server.close(); controller.close(); backend.close(); app.processEvents()
    assert lifecycle == ["volume_open", "volume_close"]
    record_property("c0c_studio_chain", json.dumps({"scope": "native Qt/real localhost TCP/upload/VVG/Scene; synthetic vision/volume and fake GPU",
        "hardware_acceptance": "pending", "cases": evidence}, sort_keys=True))


def test_studio_voice_timeline_roundtrip_preserves_facts_seed_and_timestamps(tmp_path):
    from dataclasses import replace
    import shutil
    source = ROOT / "candidates/game1-voice-s2"
    project = tmp_path / "voice"
    shutil.copytree(source, project, ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
    case_path = project / "tests/replays/s2-boundaries.json"
    original = GameTestCase.load(case_path)
    original = replace(original, seed=19, tick_timestamps_ns=tuple(index * 16_666_667 for index in range(original.max_ticks + 1)))
    original.save(case_path)
    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=tmp_path)
    try:
        restored = workspace.current_test_case()
        assert restored.events == original.events and restored.assertions == original.assertions
        assert restored.seed == 19 and restored.schema_version == 3
        assert restored.tick_timestamps_ns == original.tick_timestamps_ns
        assert any("声音观察" == workspace.timeline_table.item(row, 1).text() for row in range(workspace.timeline_table.rowCount()))
        workspace.test_case_list.setCurrentRow(0)
        manual = workspace.current_test_case()
        assert manual.seed == 0 and manual.tick_timestamps_ns == ()
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()


def test_studio_volume_timeline_roundtrip_preserves_complete_schema4(tmp_path):
    import json
    from dataclasses import replace
    report = json.loads((ROOT / "deliveries/c6i-volume-games-c0c-v1-20261022/game1-volume-shield-attack.pc-report.json").read_text(encoding="utf-8"))
    original = GameTestCase.from_json(json.dumps(report["test_case"]))
    original = replace(original, seed=23,
        tick_timestamps_ns=tuple(index * 16_666_667 for index in range(original.max_ticks + 1)))
    project = GameProject.create(tmp_path / "timeline-volume", game_id="timeline-volume", display_name="Volume")
    case_path = project.root / "tests/replays" / (original.test_id + ".json")
    original.save(case_path)
    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=tmp_path)
    try:
        workspace._refresh_test_cases(select=case_path)
        assert workspace.current_test_case().to_json() == original.to_json()
        assert any(workspace.timeline_table.item(row, 1).text() == "音量事件"
                   for row in range(workspace.timeline_table.rowCount()))
        workspace.test_case_list.setCurrentRow(0)
        workspace._add_timeline_event(InputKind.VOLUME, volume_kind="LOUD")
        manual = workspace.current_test_case()
        assert manual.schema_version == 4 and manual.events[-1].volume.kind == "LOUD"
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()


def test_button_candidate_hides_legacy_sound_inputs_and_readouts(tmp_path):
    from pynq_multimodal_game.game_testing import InputEvent

    app = QApplication.instance() or QApplication([])
    button_device = RemoteDeviceSession("localhost", 8765, expected_build_id=0xC0061000)
    workspace = GameWorkspace(projects_root=tmp_path, device=button_device)
    try:
        assert workspace.tone_button.isHidden()
        assert workspace.frequency_input.isHidden()
        assert workspace.duration_input.isHidden()
        assert all(widget.isHidden() for widget in workspace._audio_timeline_widgets)
        assert all(widget.isHidden() for widget in workspace._audio_readout_widgets)
        workspace._add_timeline_event(InputKind.TONE)
        workspace._add_timeline_event(InputKind.VOLUME)
        assert workspace.timeline_table.rowCount() == 0
        workspace.inject_tone()
        assert workspace.audit_console.events[-1].result == "rejected"
        workspace._append_event_row(InputEvent(tick=1, kind=InputKind.TONE,
                                                event_id="historical-tone",
                                                frequency_hz=440, duration_ms=200))
        with pytest.raises(ValueError, match="不支持声音测试事件"):
            workspace.current_test_case()
        workspace.set_device(RemoteDeviceSession("localhost", 8765, expected_build_id=0xC0060C00))
        assert not workspace.tone_button.isHidden()
        assert all(not widget.isHidden() for widget in workspace._audio_timeline_widgets)
        assert workspace.current_test_case().events[0].kind is InputKind.TONE
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()


def test_button_candidate_hides_sound_replays_but_keeps_gesture_replays(tmp_path):
    import shutil

    shutil.copytree(ROOT / "games/game3", tmp_path / "game3")
    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(
        projects_root=tmp_path,
        device=RemoteDeviceSession("localhost", 8765, expected_build_id=0xC0061000),
    )
    try:
        assert workspace.test_case_list.item(0).text() == "手势测试 / 未保存"
        items = {Path(workspace.test_case_list.item(row).data(Qt.ItemDataRole.UserRole)).stem:
                 workspace.test_case_list.item(row)
                 for row in range(1, workspace.test_case_list.count())}
        assert items["kingdom-01-princess-win"].isHidden()
        assert not items["kingdom-04-hero-selection"].isHidden()
        assert not workspace.test_case_list.currentItem().isHidden()
        workspace.set_device(RemoteDeviceSession("localhost", 8765,
                                                 expected_build_id=0xC0060C00))
        assert workspace.test_case_list.item(0).text() == "Manual session / 未保存"
        assert not items["kingdom-01-princess-win"].isHidden()
        workspace.set_device(RemoteDeviceSession("localhost", 8765,
                                                 expected_build_id=0xC0061000))
        assert workspace.test_case_list.item(0).text() == "手势测试 / 未保存"
        assert items["kingdom-01-princess-win"].isHidden()
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()

def test_game_workspace_runs_pynq_test_without_blocking_ui(tmp_path: Path) -> None:
    app = QApplication.instance() or QApplication([])
    device = _BlockingGameDevice()
    workspace = GameWorkspace(
        projects_root=tmp_path / "games", device=device  # type: ignore[arg-type]
    )
    workspace.create_project(game_id="pynq-test", display_name="PYNQ Test")
    workspace.input_target.setCurrentIndex(workspace.input_target.findData("pynq"))

    workspace.start_project_preview()

    assert workspace._device_thread is not None
    assert workspace.pc_test_button.isEnabled() is False
    device.release_install.set()
    deadline = time.monotonic() + 3.0
    while workspace._device_thread is not None and time.monotonic() < deadline:
        app.processEvents()
        threading.Event().wait(0.01)
    app.processEvents()

    assert workspace._device_thread is None
    assert workspace._pynq_test_complete is True
    assert device.install_calls == 1
    assert workspace._last_pc_report is not None
    assert workspace._last_pc_report["status"] == "passed"
    assert list((tmp_path / "games/.reports/pynq-test").glob("*-pc.json"))
    assert workspace.board_readout_values["game_tick"].toolTip() == "600"
    assert workspace.board_readout_values["state"].toolTip() == "paused"
    assert workspace.inspector.currentWidget() is workspace.inspector.device_table
    assert any(
        event.target == "pynq" and event.action == "complete"
        for event in workspace.audit_console.events
    )
    workspace.stop(wait=True)
    workspace.deleteLater()
    app.processEvents()


def test_pynq_layout_keeps_reference_mode_and_marks_old_readout(tmp_path: Path) -> None:
    app = QApplication.instance() or QApplication([])
    device = _BlockingGameDevice()
    workspace = GameWorkspace(projects_root=tmp_path / "games", device=device)  # type: ignore[arg-type]
    try:
        assert workspace.input_target.currentData() == "pynq"
        assert workspace.viewport.maximumHeight() == 64
        workspace._apply_pynq_snapshot({"state": "paused", "game_tick": 12})
        workspace._apply_pynq_snapshot({"state": "paused", "game_tick": 12, "game_score": None})
        assert workspace.board_readout_values["game_score"].toolTip() == "--"
        device.snapshot = DeviceSnapshot(DeviceState.ERROR, "test", None, "lost", 2)
        workspace.refresh_device_state()
        assert "历史" in workspace.board_source_label.text()
        assert "历史" in workspace.inspector.device_table.item(0, 1).text()
        assert not workspace.play_button.isEnabled()
        workspace.input_target.setCurrentIndex(workspace.input_target.findData("pc"))
        assert workspace.viewport.maximumHeight() > 1000
        assert workspace.board_readout.isHidden()
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()


def test_deployment_blocks_failed_pc_assertions_before_upload(tmp_path: Path) -> None:
    app = QApplication.instance() or QApplication([])
    device = _BlockingGameDevice()
    workspace = GameWorkspace(projects_root=tmp_path / "games", device=device)  # type: ignore[arg-type]
    try:
        workspace.create_project(game_id="blocked", display_name="Blocked")
        workspace.max_ticks_input.setValue(1)
        workspace._add_assertion_row()
        workspace.assertion_table.item(0, 0).setText("1")
        workspace.assertion_table.item(0, 1).setText("score")
        workspace.assertion_table.item(0, 3).setText("999")
        workspace.start_project_preview()
        deadline = time.monotonic() + 3.0
        while workspace._device_thread is not None and time.monotonic() < deadline:
            app.processEvents()
            threading.Event().wait(0.01)
        app.processEvents()
        assert workspace._device_thread is None
        assert device.install_calls == 0
        assert workspace._last_pc_report is not None
        assert workspace._last_pc_report["status"] == "failed"
        assert any("upload was blocked" in str(event.details)
                   for event in workspace.audit_console.events)
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()


def test_studio_comparison_reports_first_divergence_and_exports_evidence(tmp_path: Path) -> None:
    import copy
    import json
    from pynq_multimodal_game.game_validation import run_game_test

    app = QApplication.instance() or QApplication([])
    workspace = GameWorkspace(projects_root=tmp_path / "games")
    try:
        workspace.create_project(game_id="compare", display_name="Compare")
        workspace.input_target.setCurrentIndex(workspace.input_target.findData("compare"))
        workspace.max_ticks_input.setValue(2)
        package = workspace.build_active_project()
        assert package is not None
        report = run_game_test(package, workspace.current_test_case())
        workspace._run_id = "comparison"
        workspace._accept_test_report(report)
        remote = copy.deepcopy(report.to_dict())
        remote["target"] = "pynq"
        remote["frames"][1]["state_sha256"] = "different"
        workspace._apply_pynq_snapshot({
            "state": "paused", "runtime_mode": "game", "test_complete": True,
            "game_test_report": remote, "assertions_passed": 0, "assertions_failed": 0,
        })
        events = [event for event in workspace.audit_console.events if event.category == "comparison"]
        assert events[-1].result == "failed"
        assert events[-1].details["first_divergent_tick"] == 1
        saved = json.loads(Path(events[-1].details["path"]).read_text(encoding="utf-8"))
        assert saved["pc_report"]["package"]["sha256"] == saved["pynq_report"]["package"]["sha256"]
        assert saved["hardware_acceptance"] == "pending"
    finally:
        workspace.stop(wait=True)
        workspace.deleteLater()
        app.processEvents()
