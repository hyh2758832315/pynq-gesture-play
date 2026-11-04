import os
from io import BytesIO
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from threading import Event, Thread
import json
import sys
import time
import traceback

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")

import pytest
from PySide6.QtCore import QBuffer, QEventLoop, QIODevice, QTimer
from PySide6.QtGui import QColor, QImage, QPainter
from PySide6.QtWidgets import QApplication

from pynq_multimodal_game.scene import LOGICAL_HEIGHT, LOGICAL_WIDTH
from pynq_multimodal_game.agent import AgentController, AgentServer, MockRuntimeBackend
from pynq_multimodal_game.streaming import encode_fixture_frame, encode_fixture_series
from pynq_multimodal_game.studio.app import main
from pynq_multimodal_game.studio.device import DeviceSnapshot, DeviceState
from pynq_multimodal_game.studio.main_window import StudioMainWindow
from pynq_multimodal_game.studio.theme import STUDIO_STYLESHEET
from pynq_multimodal_game.studio.workspaces import read_mjpeg_frame, rgb_to_qimage, vision_debug_tile


def _voice_snapshot():
    from pynq_multimodal_game.agent.voice_backend import VoiceSupervisor
    voice = VoiceSupervisor(lambda: None).observation()
    voice.update(state="RUNNING", producer_run="run", audio_epoch="epoch", packets=1, samples=960,
        cpu={"submitted": 1, "received": 1}, pcm={"packet_index": 0, "sample_hz": 48000,
        "stride": 4, "samples": [index % 80 * 300 - 12000 for index in range(240)], "historical": False})
    return {"profile": "C6I_VISION_VOICE_S3", "build_id": 0xC0060900, "voice": voice}


def test_studio_preview_stop_unblocks_idle_mjpeg_read(qt_app):
    import importlib.util
    from pathlib import Path
    from pynq_multimodal_game.studio.workspaces import CameraPreviewWorker

    script = Path(__file__).resolve().parents[1] / "board/pynq_z2/scripts/vision_async_runtime.py"
    spec = importlib.util.spec_from_file_location("vision_async_studio_stop", script)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    preview = module.BytesPreview("127.0.0.1", 0)
    worker = CameraPreviewWorker(f"http://127.0.0.1:{preview.server.server_port}/camera.mjpg")
    thread = Thread(target=worker.run)
    thread.start()
    try:
        deadline = time.monotonic() + 2
        while "video" not in preview.demand() and time.monotonic() < deadline:
            time.sleep(0.01)
        assert "video" in preview.demand()
        started = time.monotonic()
        worker.stop()
        thread.join(timeout=1)
        assert not thread.is_alive()
        assert time.monotonic() - started < 1
        deadline = time.monotonic() + 0.8
        while preview.demand() and time.monotonic() < deadline:
            time.sleep(0.025)
        assert preview.demand() == frozenset()
    finally:
        worker.stop()
        thread.join(timeout=2)
        preview.close()


def test_r23_studio_preview_demand_starts_only_after_play_and_releases_on_stop(qt_app):
    import importlib.util
    from pathlib import Path

    script = Path(__file__).resolve().parents[1] / "board/pynq_z2/scripts/vision_async_runtime.py"
    spec = importlib.util.spec_from_file_location("vision_async_r23_demand", script)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    preview = module.BytesPreview("127.0.0.1", 0)
    window = StudioMainWindow(agent_host="127.0.0.1", agent_build_id=0xC0061000)
    window.vision_workspace.camera_url.setText(
        f"http://127.0.0.1:{preview.server.server_port}/camera.mjpg")
    try:
        assert preview.demand() == frozenset()
        window.vision_workspace.start_camera()
        _process_until(qt_app, lambda: "video" in preview.demand())
        assert not window.vision_workspace.vision_start_button.isEnabled()
        window.vision_workspace.stop_camera(wait=True)
        _process_until(qt_app, lambda: preview.demand() == frozenset())
    finally:
        window.close()
        preview.close()


def test_r23_studio_result_json_is_requested_only_while_previewing(qt_app, monkeypatch):
    import importlib.util
    from pathlib import Path

    root = Path(__file__).resolve().parents[1]
    script = root / "subprojects/ps_ui_r23b2/board/pynq_z2/scripts/vision_async_runtime.py"
    monkeypatch.setenv("VVG_VISION_RUNTIME_DIR", str(root / "handoffs/gesture_vision_v61/runtime"))
    spec = importlib.util.spec_from_file_location("r23_studio_result_demand", script)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    preview = module.BytesPreview("127.0.0.1", 0)
    window = StudioMainWindow(agent_host="127.0.0.1", agent_build_id=0xC0061000)
    window.vision_workspace.camera_url.setText(
        f"http://127.0.0.1:{preview.server.server_port}/camera.mjpg")
    try:
        assert preview.demand() == frozenset() and not preview.wants_result()
        window.vision_workspace.camera_button.click()
        _process_until(qt_app, lambda: "video" in preview.demand() and preview.wants_result())
        window.vision_workspace.camera_button.click()
        _process_until(qt_app, lambda: not window.vision_workspace._http_attached())
        _process_until(qt_app, lambda: preview.demand() == frozenset() and not preview.wants_result(),
                       timeout_ms=2500)
    finally:
        window.close()
        preview.close()


def test_volume_page_silence_repeat_epoch_and_fault(qt_app, monkeypatch):
    from test_volume_monitor import volume_fixture
    from pynq_multimodal_game.volume_monitor import VolumeStatusPublisher
    from pynq_multimodal_game.studio import audio_workspace as module
    now = [10.0]
    monkeypatch.setattr(module, "monotonic", lambda: now[0])
    publisher = VolumeStatusPublisher(lambda: volume_fixture(l1_sum=0, mean_abs=0))
    publisher.sample_once()
    workspace = module.AudioWorkspace()
    try:
        workspace.accept_observation(publisher.status())
        assert workspace.volume_level.format() == "0.00"
        assert "实时" in workspace.canvas_source.text()
        now[0] = 10.6
        workspace.accept_observation(publisher.status())
        assert "历史" in workspace.canvas_source.text() and len(workspace._volume_history) == 1
        publisher.reader = lambda: volume_fixture(epoch=2, window_count=0, l1_sum=None, mean_abs=None)
        publisher.sample_once()
        workspace.accept_observation(publisher.status())
        assert not workspace._volume_history and workspace._image.isNull()
        assert workspace.volume_level.format().startswith("--")
        publisher.reader = lambda: volume_fixture(faults=2, state=4, snapshot_valid=False, sample_count=None, window_count=None, l1_sum=None, mean_abs=None, thresholds=None)
        publisher.sample_once()
        workspace.accept_observation(publisher.status())
        assert "故障" in workspace.readouts["state"].toolTip()
        assert "0x02" in workspace.readouts["health"].toolTip()
    finally:
        workspace.stop(); workspace.deleteLater(); qt_app.processEvents()


def test_volume_page_real_http_stop_keeps_publisher(qt_app):
    from test_volume_monitor import volume_fixture
    from pynq_multimodal_game.volume_monitor import VolumeStatusPublisher, make_volume_server
    from pynq_multimodal_game.studio.audio_workspace import AudioWorkspace
    publisher = VolumeStatusPublisher(volume_fixture)
    publisher.start()
    server = make_volume_server(publisher, port=0)
    thread = Thread(target=server.serve_forever, kwargs={"poll_interval": 0.02})
    thread.start()
    workspace = AudioWorkspace()
    workspace.volume_url.setText(f"http://127.0.0.1:{server.server_port}/status")
    try:
        workspace.start_observation()
        _process_until(qt_app, lambda: workspace._volume_snapshot is not None)
        assert workspace.observer_busy and not workspace.observation_source.isEnabled()
        workspace.stop(); qt_app.processEvents()
        assert not workspace.observer_busy and publisher._thread.is_alive()
        assert "历史" in workspace.canvas_source.text()
    finally:
        workspace.stop(); workspace.deleteLater(); qt_app.processEvents()
        server.shutdown(); server.server_close(); thread.join(1); publisher.close()


def test_fused_volume_page_cache_age_disabled_and_fault_are_historical(qt_app):
    from copy import deepcopy
    from test_volume_monitor import volume_fixture
    from pynq_multimodal_game.studio.audio_workspace import AudioWorkspace
    from pynq_multimodal_game.studio.device import RemoteDeviceSession
    identity = {"profile": "C6I_VISION_VOLUME_V1", "build_id": 0xC0060C00}
    volume = {**identity, "error": None, "sampling_enabled": True, "poller_alive": True,
        "lease_retained": True, "latch": {"producer_run": "a" * 32, "source_epoch": 1,
            "error": None, "last_receipt": None},
        "observation": {"sequence": 1, "cache_age_ms": 600.0, "error": None, "snapshot": volume_fixture()}}
    result = {"ok": True, "snapshot": {**identity, "volume": volume}}
    page = AudioWorkspace(RemoteDeviceSession("localhost", 8765, expected_build_id=0xC0060C00))
    try:
        assert page.observation_source.currentData() == "fused-volume"
        page.accept_observation(result)
        assert page.contract_value.text() == "C0C / C0060C00"
        assert "历史" in page.canvas_source.text()
        fresh = deepcopy(result)
        fresh["snapshot"]["volume"]["observation"]["snapshot"].update(window_count=2, sample_count=1954)
        fresh["snapshot"]["volume"]["observation"]["cache_age_ms"] = 0.0
        page.accept_observation(fresh)
        assert "实时" in page.canvas_source.text()
        fresh["snapshot"]["volume"]["error"] = "source fault"
        page.accept_observation(fresh)
        assert "历史" in page.canvas_source.text() and "source fault" in page.stream_status.text()
        volume.update(observation=None, sampling_enabled=False, poller_alive=False)
        page.accept_observation(result)
        assert page.readouts["state"].text() == "采样关闭" and page._image.isNull()
        assert page.volume_level.format() == "--"
    finally:
        page.stop(); page.deleteLater(); qt_app.processEvents()

def test_volume_studio_launch_option_smoke(qt_app):
    from unittest.mock import patch
    from pynq_multimodal_game.studio.qt_app import run_studio
    with patch("pynq_multimodal_game.studio.workspaces.VisionWorkspace.start_camera") as camera:
        assert run_studio(["studio", "--smoke-test", "--camera-preview", "--volume-monitor", "http://127.0.0.1:1/status"]) == 0
    camera.assert_not_called()


def test_volume_studio_capture_sizes(qt_app, tmp_path):
    import math
    import os
    from pathlib import Path
    from threading import Thread
    from PySide6.QtGui import QFont
    from test_volume_monitor import volume_fixture
    from pynq_multimodal_game.volume_monitor import VolumeStatusPublisher, make_volume_server
    started = time.monotonic()
    def fixture():
        count = 101 + int((time.monotonic() - started) / 0.02000896)
        level = int((1 + math.sin(count / 12)) * 70)
        return volume_fixture(sample_count=count * 977, window_count=count, l1_sum=level * 977,
                              mean_abs=level, thresholds={"quiet": 9770, "soft": 48850, "loud": 97700})
    publisher = VolumeStatusPublisher(fixture, source_kind="fixture")
    server = make_volume_server(publisher, port=0)
    thread = Thread(target=server.serve_forever, kwargs={"poll_interval": 0.01})
    publisher.start(); thread.start()
    window = StudioMainWindow()
    page = window.audio_workspace
    try:
        font = QFont("Bahnschrift", 10)
        font.setFamilies(["Bahnschrift", "Microsoft YaHei UI", "Noto Sans CJK SC"])
        window.setFont(font); window.setStyleSheet(STUDIO_STYLESHEET)
        window.select_workspace(1); window.show(); qt_app.processEvents()
        for count in range(1, 101):
            value = fixture(); level = int((1 + math.sin(count / 12)) * 70)
            value.update(sample_count=count * 977, window_count=count, l1_sum=level * 977, mean_abs=level)
            page.accept_observation(dict(publisher.status(), snapshot=value))
        page.volume_url.setText(f"http://127.0.0.1:{server.server_port}/status")
        page.start_observation()
        _process_until(qt_app, lambda: page._volume_snapshot is not None and page._volume_snapshot["window_count"] > 100)
        output = Path(os.environ.get("VOL1_CAPTURE_ROOT", str(tmp_path)))
        output.mkdir(parents=True, exist_ok=True)
        for width, height in ((1440, 900), (1080, 700)):
            window.resize(width, height); qt_app.processEvents()
            image = window.grab().toImage()
            assert image.width() == width and image.height() == height
            assert not page._image.isNull() and "模拟夹具" in page.canvas_source.text()
            colors = {image.pixelColor(horizontal, vertical).name() for horizontal in range(0, width, 20) for vertical in range(0, height, 20)}
            assert len(colors) > 20
            path = output / f"studio-vol1-{width}x{height}.png"
            assert image.save(str(path))
            print(f"VOL1_NATIVE_CAPTURE={path} colors={len(colors)} synthetic=true")
        page.stop(); qt_app.processEvents()
        assert not page.observer_busy and publisher._thread.is_alive()
    finally:
        page.stop(); window.close(); qt_app.processEvents()
        server.shutdown(); server.server_close(); thread.join(1); publisher.close()
    assert not thread.is_alive() and not publisher._thread.is_alive()


def test_voice_mailbox_coalesces_slow_ui_to_one_pending_notification(qt_app):
    from pynq_multimodal_game.studio.audio_workspace import VoiceMonitorWorker
    worker = VoiceMonitorWorker(None)
    notifications = []
    worker.received.connect(lambda: notifications.append(True))
    for index in range(10000):
        worker.publish((True, {"index": index}))
    assert len(notifications) == 1
    assert worker.take_latest() == (True, {"index": 9999})
    assert worker.take_latest() is None
    worker.publish((False, "offline"))
    assert len(notifications) == 2 and worker.take_latest() == (False, "offline")


def test_fused_studio_native_capture_sizes(qt_app, tmp_path):
    from dataclasses import asdict
    from pathlib import Path
    from PySide6.QtGui import QFont
    from test_volume_monitor import fused_volume_fixture
    from pynq_multimodal_game.game_sdk import VolumeSignal
    from pynq_multimodal_game.vision_input import GameVisionInputProvider
    from pynq_multimodal_game.studio.device import RemoteDeviceSession
    window = StudioMainWindow(agent_build_id=0xC0060C00)
    page, game = window.audio_workspace, window.game_workspace
    device = RemoteDeviceSession("127.0.0.1", 8765, expected_build_id=0xC0060C00)
    page.set_device(device)
    provider = GameVisionInputProvider(clock=lambda: 1.)
    provider.publish({"run_id": "r" * 32, "frame": 7, "stable": "5", "rps": "PAPER",
        "server_age_ms": 0, "control": {"schema": "gesture-control-v1", "frame_id": 7,
        "action_event_seq": 0, "valid": True, "direction": "RIGHT"}})
    _sample, visual = provider.sample_for_game("game1", tick_id=4)
    visual.update(scene_tick=4, scene_sha256="a" * 64, sink_completion="confirmed", game_run="b" * 32)
    snapshot = fused_volume_fixture()
    snapshot.update(state="running", runtime_mode="game", game_tick=4, game_id="game1-volume-v1",
        scene_sha256="a" * 64, vision={"input_capabilities": provider.capabilities}, vision_consumption=visual,
        volume_consumption={"signal": asdict(VolumeSignal("a" * 32, 1, 1, "LOUD", 977, 1)),
            "game_id": "game1-volume-v1", "game_run": "b" * 32, "sample_tick": 4, "scene_tick": 4,
            "scene_sha256": "a" * 64, "sink_completion": "confirmed", "hardware_acked": True,
            "logic_consumed": True, "logic_executed": True, "game_effects": {"attacks_fired": 1}})
    font = QFont("Bahnschrift", 10)
    font.setFamilies(["Bahnschrift", "Microsoft YaHei UI", "Noto Sans CJK SC"])
    window.setFont(font); window.setStyleSheet(STUDIO_STYLESHEET)
    output = Path(os.environ.get("C0C_CAPTURE_ROOT", str(tmp_path)))
    output.mkdir(parents=True, exist_ok=True)
    try:
        page.accept_observation({"ok": True, "snapshot": snapshot})
        page.stream_status.setText("C0C / 合成输入 / 软件仿真")
        game._apply_pynq_snapshot(snapshot)
        window.show(); qt_app.processEvents()
        for width, height in ((1440, 900), (1080, 700)):
            window.resize(width, height)
            for index, title in ((0, "vision"), (1, "audio"), (2, "game")):
                window.select_workspace(index); qt_app.processEvents()
                image = window.grab().toImage()
                assert (image.width(), image.height()) == (width, height)
                assert not image.isNull()
                if title == "audio":
                    assert not page._image.isNull() and page.contract_value.text() == "C0C / C0060C00"
                if title == "game":
                    assert game.viewport.minimumHeight() >= 180
                    assert game.vision_readout_values["volume_sink"].toolTip() == "已确认 / tick 4"
                    assert all(label.height() >= label.fontMetrics().height() for label in game.vision_readout_values.values())
                    assert game.view_tabs.widget(0).horizontalScrollBar().maximum() == 0
                path = output / f"studio-c0c-{title}-{width}x{height}.png"
                assert image.save(str(path))
                print(f"C0C_NATIVE_CAPTURE={path} synthetic=true")
    finally:
        game._pynq_status_timer.stop(); window.close(); qt_app.processEvents()


def test_voice_page_repeated_pcm_does_not_refresh_and_new_epoch_clears_history(qt_app, monkeypatch):
    from copy import deepcopy
    from pynq_multimodal_game.studio import audio_workspace as module
    now = [10.0]
    monkeypatch.setattr(module, "monotonic", lambda: now[0])
    workspace = module.AudioWorkspace()
    snapshot = _voice_snapshot()
    try:
        workspace.accept_observation({"snapshot": snapshot})
        assert "实时片段" in workspace.canvas_source.text() and not workspace._image.isNull()
        workspace.series_mode.setCurrentIndex(1)
        assert "0-6 kHz" in workspace.canvas_source.text()
        now[0] = 10.6
        workspace.accept_observation({"snapshot": snapshot})
        assert "历史" in workspace.canvas_source.text() and workspace._last_pcm_at == 10.0
        fresh = deepcopy(snapshot)
        fresh["voice"].update(audio_epoch="epoch-2", state="READY", packets=0, samples=0, pcm=None, cpu={})
        workspace.accept_observation({"snapshot": fresh})
        assert workspace._last_pcm_at is None and workspace._image.isNull()
        assert workspace.readouts["source_age"].toolTip() == "待实测"
    finally:
        workspace.stop()
        workspace.deleteLater()
        qt_app.processEvents()


def test_voice_page_real_tcp_worker_stop_does_not_stop_board(qt_app):
    from dataclasses import replace
    from pynq_multimodal_game.studio.audio_workspace import AudioWorkspace
    from pynq_multimodal_game.studio.device import RemoteDeviceSession

    class Backend(MockRuntimeBackend):
        @property
        def snapshot(self):
            return replace(super().snapshot, profile="C6I_VISION_VOICE_S3", voice=_voice_snapshot()["voice"])

    controller = AgentController(Backend(build_id=0xC0060900))
    server = AgentServer(controller)
    server.start()
    workspace = AudioWorkspace(RemoteDeviceSession(*server.address, expected_build_id=0xC0060900))
    try:
        workspace.start_observation()
        _process_until(qt_app, lambda: workspace._voice_snapshot is not None)
        assert workspace.observer_busy and not workspace.observe_button.isEnabled()
        workspace.stop()
        qt_app.processEvents()
        assert not workspace.observer_busy and controller.snapshot.state.value == "idle"
        assert "历史" in workspace.canvas_source.text()
        workspace.start_observation()
        _process_until(qt_app, lambda: workspace.observer_busy)
        workspace.stop()
        assert controller.snapshot.state.value == "idle"
    finally:
        workspace.stop()
        workspace.deleteLater()
        server.close()
        controller.close()
        qt_app.processEvents()


@pytest.mark.parametrize("build_id", (0xC0060700, 0xC0060800, 0xC0060900, 0xC0060C00, 0xC0061000))
def test_studio_platform_identity_reaches_remote_session(qt_app, build_id):
    from pynq_multimodal_game.studio.main_window import PynqConnectionDialog

    dialog = PynqConnectionDialog("127.0.0.1", 8765, "", expected_build_id=build_id)
    assert dialog.expected_build_id == build_id
    assert dialog.connection == ("127.0.0.1", 8765, None)
    window = StudioMainWindow(agent_host="127.0.0.1", agent_build_id=build_id)
    try:
        assert window.device._expected_build_id == build_id
        assert window.vision_workspace.vision_agent_port.value() == (8765 if build_id in (0xC0060800, 0xC0060900, 0xC0060C00, 0xC0061000) else 8766)
        camera_port = 8081 if build_id in (0xC0060800, 0xC0060900, 0xC0060C00, 0xC0061000) else 8088
        assert window.vision_workspace.camera_url.text() == f"http://127.0.0.1:{camera_port}/camera.mjpg"
        assert window.workspace_count == (5 if build_id == 0xC0061000 else 6)
        if build_id == 0xC0061000:
            assert window.audio_workspace is None
            assert window.navigation.item(1).text() == "Game"
            window.select_workspace(1)
            assert window.workspace_stack.currentWidget() is window.game_workspace
        else:
            assert window.audio_workspace is not None
            assert window.navigation.item(1).text() == "Audio"
        assert window.vision_workspace.vision_start_button.isEnabled() is (build_id != 0xC0061000)
        window.use_remote_device("127.0.0.1", 8765, persist=False, connect=False,
                                 expected_build_id=build_id)
        assert window.device._expected_build_id == build_id
        assert window.vision_workspace.vision_agent_port.value() == (8765 if build_id in (0xC0060800, 0xC0060900, 0xC0060C00, 0xC0061000) else 8766)
        assert window.vision_workspace.camera_url.text() == f"http://127.0.0.1:{camera_port}/camera.mjpg"
    finally:
        window.close()
        dialog.close()


def test_r23_audio_page_is_removed_and_restored_when_profile_changes(qt_app):
    window = StudioMainWindow(agent_host="127.0.0.1", agent_build_id=0xC0061000)
    try:
        assert window.audio_workspace is None
        assert window.workspace_count == 5
        window.select_workspace(2)
        assert window.workspace_stack.currentWidget() is window.video_workspace

        window.use_remote_device("127.0.0.1", 8765, persist=False,
                                 connect=False, expected_build_id=0xC0060800)
        assert window.audio_workspace is not None
        assert window.workspace_count == 6
        assert window.navigation.item(1).text() == "Audio"
        assert window.workspace_stack.currentWidget() is window.video_workspace
        window.select_workspace(1)
        assert window.workspace_stack.currentWidget() is window.audio_workspace

        window.use_remote_device("127.0.0.1", 8765, persist=False,
                                 connect=False, expected_build_id=0xC0061000)
        assert window.audio_workspace is None
        assert window.workspace_count == 5
        assert window.workspace_stack.currentWidget() is window.game_workspace
        assert window.navigation.item(1).text() == "Game"
    finally:
        window.close()


@pytest.mark.parametrize("worker_name", ("CameraPreviewWorker", "VisionDebugWorker", "VisionResultWorker"))
def test_vision_http_workers_bind_configured_direct_source(qt_app, monkeypatch, worker_name):
    from types import SimpleNamespace
    from pynq_multimodal_game.studio import workspaces

    worker = getattr(workspaces, worker_name)("http://192.168.2.99:8081/camera.mjpg",
                                            source_address="192.168.2.1")
    if worker_name == "VisionDebugWorker":
        worker.enabled.set()
    captured = []

    def stopped(*args, **kwargs):
        raise OSError("test receiver stopped")

    def connection(host, port, **kwargs):
        captured.append((host, port, kwargs["source_address"]))
        worker.stop()
        return SimpleNamespace(request=stopped, connect=stopped, close=lambda: None)

    monkeypatch.setattr(workspaces, "HTTPConnection", connection)
    worker.run()
    assert captured == [("192.168.2.99", 8081, ("192.168.2.1", 0))]


def test_studio_cli_passes_fusion_identity_to_window(qt_app, monkeypatch):
    from unittest.mock import MagicMock
    from pynq_multimodal_game.studio import qt_app as entry

    window_type = MagicMock()
    monkeypatch.setattr(entry, "StudioMainWindow", window_type)
    assert entry.run_studio(["studio", "--smoke-test", "--agent-host", "127.0.0.1",
                             "--agent-port", "8875", "--agent-build-id", "0xC0060800"]) == 0
    assert window_type.call_args.kwargs["agent_build_id"] == 0xC0060800
    assert window_type.call_args.kwargs["agent_port"] == 8875


def test_studio_shortcut_preview_starts_subscription_without_board_start(qt_app, monkeypatch):
    from unittest.mock import MagicMock
    from pynq_multimodal_game.studio import qt_app as entry

    window_type = MagicMock()
    monkeypatch.setattr(entry, "StudioMainWindow", window_type)
    assert entry.run_studio(["studio", "--smoke-test", "--camera-preview",
                             "--agent-host", "192.168.2.99", "--agent-build-id", "0xC0060800",
                             "--agent-source-address", "192.168.2.1"]) == 0
    assert window_type.call_args.kwargs["agent_source_address"] == "192.168.2.1"
    window = window_type.return_value
    window.select_workspace.assert_called_once_with(0)
    window.vision_workspace.start_camera.assert_called_once_with()
    window.vision_workspace.start_vision.assert_not_called()
    window.close.assert_called_once_with()


def test_vision_service_controls_wait_for_agent_readiness_and_stop(qt_app):
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent.vision_backend import VisionRuntimeBackend
    from pynq_multimodal_game.studio.workspaces import VisionWorkspace

    supervisor = MagicMock()
    supervisor.status.return_value = {"state": "STARTING", "owner_held": True,
                                      "cleanup_confirmed": False, "session_id": "guard-ui"}
    controller = AgentController(VisionRuntimeBackend(supervisor))
    server = AgentServer(controller)
    server.start()
    workspace = VisionWorkspace()
    workspace.vision_agent_host.setText(server.address[0])
    workspace.vision_agent_port.setValue(server.address[1])
    try:
        workspace.vision_start_button.click()
        assert workspace.control_busy and not workspace.vision_stop_button.isEnabled()
        _process_until(qt_app, lambda: not workspace.control_busy)
        assert workspace.vision_service_status.text() == "启动中 / 占用"
        assert supervisor.start.call_count == 1
        supervisor.status.return_value = {"state": "RUNNING", "owner_held": True}
        workspace.vision_status_button.click()
        _process_until(qt_app, lambda: not workspace.control_busy)
        assert workspace.vision_service_status.text() == "运行中 / 占用"
        assert not workspace.camera_running
        supervisor.stop.side_effect = lambda: setattr(supervisor.status, "return_value",
            {"state": "IDLE", "owner_held": False, "cleanup_confirmed": True})
        workspace.vision_stop_button.click()
        _process_until(qt_app, lambda: not workspace.control_busy)
        assert workspace.vision_service_status.text() == "空闲"
        assert workspace.vision_agent_host.isEnabled()
    finally:
        workspace.stop()
        _process_until(qt_app, lambda: not workspace.control_busy)
        workspace.close()
        server.close()
        controller.close()


def test_vision_control_rejects_gpu_and_preserves_http_independence(qt_app):
    from pynq_multimodal_game.studio.workspaces import VisionWorkspace

    controller = AgentController(MockRuntimeBackend(build_id=0xC0060700))
    server = AgentServer(controller)
    server.start()
    workspace = VisionWorkspace()
    workspace.vision_agent_host.setText(server.address[0])
    workspace.vision_agent_port.setValue(server.address[1])
    try:
        workspace.vision_start_button.click()
        _process_until(qt_app, lambda: not workspace.control_busy)
        assert workspace.vision_service_status.text() == "链路错误"
        assert "VISION_ONLY" in workspace.vision_service_status.toolTip()
        assert workspace.camera_button.isEnabled()
        assert not workspace._control_timer.isActive()
        assert workspace.vision_agent_host.isEnabled()
    finally:
        workspace.stop()
        workspace.close()
        server.close()
        controller.close()


def test_vision_control_cleanup_failure_remains_visible(qt_app):
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent.vision_backend import VisionRuntimeBackend
    from pynq_multimodal_game.studio.workspaces import VisionWorkspace

    supervisor = MagicMock()
    supervisor.status.return_value = {"state": "FAULT", "owner_held": True,
                                      "cleanup_confirmed": False}
    supervisor.stop.side_effect = RuntimeError("DMA halt unconfirmed")
    controller = AgentController(VisionRuntimeBackend(supervisor))
    server = AgentServer(controller)
    server.start()
    workspace = VisionWorkspace()
    workspace.vision_agent_host.setText(server.address[0])
    workspace.vision_agent_port.setValue(server.address[1])
    try:
        workspace.vision_stop_button.click()
        _process_until(qt_app, lambda: not workspace.control_busy)
        assert workspace.vision_service_status.text() == "故障 / 占用"
        assert "DMA halt unconfirmed" in workspace.vision_service_status.toolTip()
        assert workspace.vision_stop_button.isEnabled()
        assert workspace._control_timer.isActive()
    finally:
        workspace.stop()
        workspace.close()
        server.close()
        controller.close()


def test_vision_result_worker_recovers_and_releases_duplicate(qt_app: QApplication) -> None:
    from pynq_multimodal_game.studio.workspaces import VisionResultWorker

    payload = b"{}"
    calls = []

    class ResultHandler(BaseHTTPRequestHandler):
        def do_GET(self) -> None:
            calls.append((self.path, time.monotonic()))
            body = payload
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)

        def log_message(self, format: str, *args: object) -> None:
            pass

    server = ThreadingHTTPServer(("127.0.0.1", 0), ResultHandler)
    serving = Thread(target=server.serve_forever, daemon=True)
    serving.start()
    worker = VisionResultWorker(f"http://127.0.0.1:{server.server_port}/camera.mjpg")
    running = Thread(target=worker.run, daemon=True)
    running.start()
    try:
        _process_until(qt_app, lambda: worker.snapshot()[1] is True)
        assert worker.snapshot()[0].status == "WAITING"
        payload = b"not-json"
        _process_until(qt_app, lambda: worker.snapshot()[0].status == "ERROR")
        result = {"run_id": "run-http", "server_age_ms": 0, "control": {
            "schema": "gesture-control-v1", "frame_id": 1, "action_event_seq": 8,
            "direction": "RIGHT", "valid": True,
        }}
        payload = json.dumps(result).encode()
        _process_until(qt_app, lambda: worker.snapshot()[0].valid)
        _process_until(qt_app, lambda: worker.snapshot()[0].status == "STALE")
        result["control"]["frame_id"] = 2
        payload = json.dumps(result).encode()
        _process_until(qt_app, lambda: worker.snapshot()[0].valid)
        result["control"]["valid"] = False
        payload = json.dumps(result).encode()
        _process_until(qt_app, lambda: worker.snapshot()[0].status == "INVALID")
        assert worker.snapshot()[0].direction == "IDLE"
        assert all(path == "/result.json" for path, _ in calls)
        assert all(later[1] - earlier[1] >= 0.08 for earlier, later in zip(calls, calls[1:]))
    finally:
        worker.stop()
        running.join(timeout=2)
        server.shutdown()
        server.server_close()
        serving.join(timeout=2)
    assert not running.is_alive()
    assert worker.snapshot()[0].status == "OFFLINE"


def test_vision_result_worker_stop_interrupts_blocked_response(qt_app: QApplication) -> None:
    from pynq_multimodal_game.studio.workspaces import VisionResultWorker

    entered, release = Event(), Event()

    class SlowResult(BaseHTTPRequestHandler):
        def do_GET(self) -> None:
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", "100")
            self.end_headers()
            entered.set()
            release.wait(3)

        def log_message(self, format: str, *args: object) -> None:
            pass

    server = ThreadingHTTPServer(("127.0.0.1", 0), SlowResult)
    serving = Thread(target=server.serve_forever, daemon=True)
    serving.start()
    worker = VisionResultWorker(f"http://127.0.0.1:{server.server_port}/camera.mjpg")
    running = Thread(target=worker.run, daemon=True)
    running.start()
    try:
        assert entered.wait(1)
        started = time.monotonic()
        worker.stop()
        running.join(timeout=0.3)
        assert not running.is_alive(), "".join(traceback.format_stack(sys._current_frames().get(running.ident or 0)))
        assert time.monotonic() - started < 0.3
    finally:
        worker.stop()
        release.set()
        running.join(timeout=2)
        server.shutdown()
        server.server_close()
        serving.join(timeout=2)


def test_vision_judgement_survives_image_failure_and_reconnects(qt_app: QApplication) -> None:
    result = {"run_id": "run-observer-a", "server_age_ms": 0, "control": {
        "schema": "gesture-control-v1", "frame_id": 1, "action_event_seq": 8,
        "direction": "RIGHT", "valid": True,
    }}
    payload = json.dumps(result).encode()

    class ObservationHandler(BaseHTTPRequestHandler):
        def do_GET(self) -> None:
            if self.path != "/result.json":
                self.send_error(503)
                return
            body = payload
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)

        def log_message(self, format: str, *args: object) -> None:
            pass

    server = ThreadingHTTPServer(("127.0.0.1", 0), ObservationHandler)
    serving = Thread(target=server.serve_forever, daemon=True)
    serving.start()
    window = StudioMainWindow()
    vision = window.vision_workspace
    try:
        vision.camera_url.setText(f"http://127.0.0.1:{server.server_port}/camera.mjpg")
        vision.start_camera()
        _process_until(qt_app, lambda: vision._result_snapshot.valid and '恢复中' in vision.stream_status.text())
        assert vision._camera_thread is not None and vision._camera_thread.isRunning()
        assert vision._result_thread is not None and vision._result_thread.isRunning()
        assert vision.result_direction_value.text() == "RIGHT"
        assert vision.result_network_value.text() == "可达"
        assert '恢复中' in vision.stream_status.text()
        assert vision.camera_button.isEnabled() and not vision.camera_url.isEnabled()
        assert window.game_workspace.session is None
        _process_until(qt_app, lambda: vision._result_snapshot.status == "STALE")
        assert vision.result_direction_value.text() == "IDLE"
        assert "历史" in vision.result_frame_value.text()
        payload = b"invalid json"
        _process_until(qt_app, lambda: vision._result_snapshot.status == "ERROR")
        assert vision.result_network_value.text() == "可达"
        result["run_id"] = "run-observer-b"
        result["control"]["action_event_seq"] = 90
        payload = json.dumps(result).encode()
        _process_until(qt_app, lambda: vision._result_snapshot.valid)
        assert vision._result_snapshot.run_id == "run-observer-b"
        assert vision.result_run_value.toolTip() == "run-observer-b"
        result["control"]["valid"] = False
        payload = json.dumps(result).encode()
        _process_until(qt_app, lambda: vision._result_snapshot.status == "INVALID")
        assert vision.result_direction_value.text() == "IDLE"
        assert vision.stop_camera(wait=True)
        vision._refresh_camera()
        assert not vision._http_attached() and not vision._camera_timer.isActive()
        assert vision._result_snapshot.status == "OFFLINE"
        assert vision.camera_url.isEnabled()
        result["control"]["valid"] = True
        result["control"]["frame_id"] = 2
        payload = json.dumps(result).encode()
        vision.camera_button.click()
        _process_until(qt_app, lambda: vision._result_snapshot.valid)
        assert vision._result_snapshot.frame_id == 2
        assert not vision._result_snapshot.action_event
    finally:
        window.close()
        server.shutdown()
        server.server_close()
        serving.join(timeout=2)
    assert not vision._http_attached()
    assert not vision._camera_timer.isActive()


def test_vision_control_wait_failure_vetoes_close_without_stopping_board(qt_app, monkeypatch):
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent import AgentCommand
    from pynq_multimodal_game.agent.vision_backend import VisionRuntimeBackend
    from pynq_multimodal_game.studio import workspaces

    deny_wait = Event()
    deny_wait.set()
    class UnconfirmedThread(workspaces.QThread):
        def wait(self, *args, **kwargs):
            return False if deny_wait.is_set() else super().wait(*args, **kwargs)
    monkeypatch.setattr(workspaces, "QThread", UnconfirmedThread)
    supervisor = MagicMock()
    supervisor.status.return_value = {"state": "IDLE", "owner_held": False}
    controller = AgentController(VisionRuntimeBackend(supervisor))
    server = AgentServer(controller)
    server.start()
    window = StudioMainWindow()
    window.show()
    vision = window.vision_workspace
    vision.vision_agent_host.setText(server.address[0])
    vision.vision_agent_port.setValue(server.address[1])
    try:
        vision.request_vision_control(AgentCommand.VISION_STATUS)
        thread = vision._control_thread
        assert not window.close()
        assert window.isVisible() and vision._control_thread is thread
        assert "close postponed" in window.session_log.toPlainText()
        supervisor.stop.assert_not_called()
        deny_wait.clear()
        _process_until(qt_app, lambda: not vision.control_busy)
        assert window.close()
        supervisor.stop.assert_not_called()
    finally:
        deny_wait.clear()
        window.close()
        _process_until(qt_app, lambda: not vision.control_busy)
        server.close()
        controller.close()


def test_vision_wait_failure_retains_threads_and_vetoes_close(qt_app: QApplication, monkeypatch) -> None:
    from pynq_multimodal_game.studio import workspaces

    deny_wait = Event()
    deny_wait.set()

    class UnconfirmedThread(workspaces.QThread):
        def wait(self, *args, **kwargs):
            if deny_wait.is_set():
                return False
            return super().wait(*args, **kwargs)

    monkeypatch.setattr(workspaces, "QThread", UnconfirmedThread)
    window = StudioMainWindow()
    window.show()
    vision = window.vision_workspace
    try:
        vision.camera_url.setText("http://127.0.0.1:1/camera.mjpg")
        vision.start_camera()
        threads = (vision._camera_thread, vision._debug_thread, vision._result_thread)
        assert not window.close()
        assert window.isVisible()
        assert threads == (vision._camera_thread, vision._debug_thread, vision._result_thread)
        assert vision._camera_timer.isActive()
        assert "close postponed" in window.session_log.toPlainText()
        deny_wait.clear()
        _process_until(qt_app, lambda: not vision._http_attached())
        assert window.close()
    finally:
        deny_wait.clear()
        window.close()


def test_vision_result_readouts_keep_state_colors_and_bound_identity(qt_app: QApplication) -> None:
    from pynq_multimodal_game.studio.vision_receiver import VisionResultSnapshot
    from PySide6.QtGui import QPalette

    window = StudioMainWindow()
    window.setStyleSheet(STUDIO_STYLESHEET)
    window.select_workspace(0)
    window.resize(1080, 700)
    window.show()
    vision = window.vision_workspace
    try:
        for status, expected in (("ACTIVE", "#9edb9a"), ("ERROR", "#ff9687"), ("WAITING", "#efc078"), ("OFFLINE", "#aeb8bd")):
            vision._result_snapshot = VisionResultSnapshot(status=status, run_id="W" * 200, frame_id=10 ** 100)
            vision._render_result(True)
            qt_app.processEvents()
            assert vision.result_status_value.palette().color(QPalette.ColorRole.WindowText) == QColor(expected)
            for label in (vision.result_run_value, vision.result_frame_value):
                assert label.fontMetrics().horizontalAdvance(label.text()) <= 140
                assert len(label.toolTip()) > len(label.text())
    finally:
        window.close()


@pytest.fixture(scope="module")
def qt_app() -> QApplication:
    app = QApplication.instance() or QApplication([])
    return app


def test_rgb_to_qimage_copies_logical_frame() -> None:
    rgb = bytes((18, 52, 86)) * (LOGICAL_WIDTH * LOGICAL_HEIGHT)

    image = rgb_to_qimage(rgb)

    assert image.width() == LOGICAL_WIDTH
    assert image.height() == LOGICAL_HEIGHT
    assert image.pixelColor(0, 0) == QColor(18, 52, 86)


def test_camera_http_503_recovers_real_image_without_reopening_workspace(qt_app):
    image=QImage(64,36,QImage.Format.Format_RGB888);image.fill(QColor('green'))
    encoded=QBuffer();assert encoded.open(QIODevice.OpenModeFlag.WriteOnly)
    assert image.save(encoded,'JPEG');jpeg=bytes(encoded.data())
    available=Event()
    class Handler(BaseHTTPRequestHandler):
        def do_GET(self):
            if self.path!='/camera.mjpg' or not available.is_set():self.send_error(503);return
            self.send_response(200)
            self.send_header('Content-Type','multipart/x-mixed-replace; boundary=frame')
            self.end_headers()
            try:self.wfile.write(b'--frame\r\nContent-Type: image/jpeg\r\nContent-Length: '+
                str(len(jpeg)).encode()+b'\r\n\r\n'+jpeg+b'\r\n')
            except OSError:pass
        def log_message(self,*args):pass
    server=ThreadingHTTPServer(('127.0.0.1',0),Handler)
    serving=Thread(target=server.serve_forever,daemon=True);serving.start()
    window=StudioMainWindow();vision=window.vision_workspace
    try:
        vision.camera_url.setText(f'http://127.0.0.1:{server.server_port}/camera.mjpg')
        vision.start_camera();thread=vision._camera_thread;worker=vision._camera_worker
        _process_until(qt_app,lambda:'恢复中' in vision.stream_status.text())
        available.set()
        _process_until(qt_app,lambda:worker._frames>0,timeout_ms=4000)
        assert vision._camera_thread is thread and thread.isRunning()
        _process_until(qt_app,lambda:not vision._preview_image.isNull())
        assert vision._preview_image.size()==image.size()
        assert vision.stop_camera(wait=True)
    finally:
        window.close();server.shutdown();server.server_close();serving.join(2)


def test_read_mjpeg_frame_checks_length_and_boundary() -> None:
    payload = b"--frame\r\nContent-Type: image/jpeg\r\nContent-Length: 4\r\n\r\ntest\r\n"
    assert read_mjpeg_frame(BytesIO(payload)) == b"test"
    with pytest.raises(EOFError, match="Truncated MJPEG frame"):
        read_mjpeg_frame(BytesIO(payload[:-2]))


def test_vision_debug_tiles_follow_teammate_sheet_order(qt_app: QApplication) -> None:
    sheet = QImage(960, 360, QImage.Format.Format_RGB888)
    colors = [QColor(name) for name in ("red", "green", "blue", "yellow", "cyan", "magenta")]
    painter = QPainter(sheet)
    for index, color in enumerate(colors):
        painter.fillRect((index % 3) * 320, (index // 3) * 180, 320, 180, color)
    painter.end()
    window = StudioMainWindow()
    try:
        vision = window.vision_workspace
        vision._debug_sheet = sheet
        vision._debug_received_at = time.monotonic()
        vision._debug_message = ""
        for index, color in enumerate(colors):
            tile = vision_debug_tile(sheet, index)
            assert tile.size().width() == 320 and tile.size().height() == 180
            assert tile.pixelColor(100, 100) == color
            vision.vision_views.setCurrentRow(index + 1)
            assert vision._image.pixelColor(100, 100) == color
        with pytest.raises(ValueError, match="960 x 360"):
            vision_debug_tile(QImage(32, 24, QImage.Format.Format_RGB888), 0)
    finally:
        window.close()


def test_vision_debug_http_recovers_and_switches_from_cache(qt_app: QApplication) -> None:
    sheet = QImage(960, 360, QImage.Format.Format_RGB888)
    sheet.fill(QColor("cyan"))
    encoded = QBuffer()
    assert encoded.open(QIODevice.OpenModeFlag.WriteOnly)
    assert sheet.save(encoded, "JPEG")
    jpeg = bytes(encoded.data())
    requests = []

    class DebugHandler(BaseHTTPRequestHandler):
        def do_GET(self) -> None:
            if self.path == "/result.json":
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.send_header("Content-Length", "2")
                self.end_headers()
                self.wfile.write(b"{}")
                return
            requests.append((self.path, time.monotonic()))
            attempt = len(requests)
            payload = b"" if attempt == 1 else b"bad jpeg" if attempt == 2 else jpeg
            self.send_response(503 if attempt == 1 else 200)
            self.send_header("Content-Type", "image/jpeg")
            self.send_header("Content-Length", str(len(payload)))
            self.end_headers()
            self.wfile.write(payload)

        def log_message(self, format: str, *args: object) -> None:
            pass

    server = ThreadingHTTPServer(("127.0.0.1", 0), DebugHandler)
    server_thread = Thread(target=server.serve_forever, daemon=True)
    server_thread.start()
    window = StudioMainWindow()
    vision = window.vision_workspace
    try:
        vision.camera_url.setText(f"http://127.0.0.1:{server.server_port}/camera.mjpg")
        vision.vision_views.setCurrentRow(1)
        vision.start_camera()
        _process_until(qt_app, lambda: len(requests) >= 1)
        assert vision._image.isNull()
        _process_until(qt_app, lambda: "960 x 360" in vision._debug_message)
        assert vision._debug_sheet.isNull()
        _process_until(qt_app, lambda: not vision._debug_sheet.isNull())
        count = len(requests)
        for index in range(1, 7):
            vision.vision_views.setCurrentRow(index)
            assert vision._image.width() == 320
            assert vision._image.pixelColor(100, 100).green() > 240
        assert len(requests) == count
        assert all(path == "/debug.jpg" for path, _ in requests)
        assert not hasattr(vision,'debug_poll_fps')
        assert vision._camera_timer.interval()==16
        vision.stop_camera(wait=True)
        _process_until(qt_app, lambda: vision._camera_thread is None and vision._debug_thread is None)
        assert "历史画面" in vision.canvas_source.text()
        vision.start_camera()
        assert vision._debug_sheet.isNull()
    finally:
        window.close()
        server.shutdown()
        server.server_close()
        server_thread.join(timeout=2)
    assert vision._debug_thread is None
    assert vision._camera_thread is None


def test_vision_debug_stop_interrupts_idle_wait(qt_app: QApplication) -> None:
    from pynq_multimodal_game.studio.workspaces import VisionDebugWorker

    worker = VisionDebugWorker("http://127.0.0.1:1/camera.mjpg")
    finished = Event()

    def run() -> None:
        worker.run()
        finished.set()

    thread = Thread(target=run, daemon=True)
    thread.start()
    worker.stop()
    assert finished.wait(1)
    thread.join(timeout=1)
    assert not thread.is_alive()


def test_vision_camera_preview_displays_and_reconnects(qt_app: QApplication) -> None:
    image = QImage(32, 24, QImage.Format.Format_RGB888)
    image.fill(QColor(240, 20, 20))
    encoded = QBuffer()
    assert encoded.open(QIODevice.OpenModeFlag.WriteOnly)
    assert image.save(encoded, "JPEG")
    jpeg = bytes(encoded.data())

    class CameraHandler(BaseHTTPRequestHandler):
        def do_GET(self) -> None:
            if self.path == "/result.json":
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.send_header("Content-Length", "2")
                self.end_headers()
                self.wfile.write(b"{}")
                return
            assert self.path == "/camera.mjpg"
            self.send_response(200)
            self.send_header("Content-Type", "multipart/x-mixed-replace; boundary=frame")
            self.end_headers()
            try:
                for _ in range(200):
                    self.wfile.write(
                        b"--frame\r\nContent-Type: image/jpeg\r\nContent-Length: "
                        + str(len(jpeg)).encode("ascii") + b"\r\n\r\n" + jpeg + b"\r\n"
                    )
                    self.wfile.flush()
                    time.sleep(0.02)
            except (BrokenPipeError, ConnectionResetError, ConnectionAbortedError):
                pass

        def log_message(self, format: str, *args: object) -> None:
            pass

    server = ThreadingHTTPServer(("127.0.0.1", 0), CameraHandler)
    server_thread = Thread(target=server.serve_forever, daemon=True)
    server_thread.start()
    window = StudioMainWindow()
    window.show()
    vision = window.vision_workspace
    try:
        window.select_workspace(0)
        vision.camera_url.setText(f"http://127.0.0.1:{server.server_port}/camera.mjpg")
        for _ in range(2):
            vision.camera_button.click()
            _process_until(qt_app, lambda: int(vision.frames_value.text()) >= 2)
            assert vision.contract_value.text() == "camera.mjpeg"
            assert vision.canvas.pixmap() is not None
            assert vision._image.pixelColor(0, 0).red() > 200
            assert vision._image.width() == 32 and vision._image.height() == 24
            assert "32 x 24" in vision.canvas_source.text()
            assert "HTTP" in window.camera_status.text()
            assert "PC 离线" in window.device_label.text()
            vision.camera_button.click()
            _process_until(qt_app, lambda: vision._camera_thread is None)
        vision.camera_button.click()
        _process_until(qt_app, lambda: int(vision.frames_value.text()) >= 2)
    finally:
        window.close()
        server.shutdown()
        server.server_close()
        server_thread.join(timeout=2)
    assert not vision.camera_running
    assert not vision._camera_timer.isActive()


def test_vision_camera_preview_reports_connection_failure(qt_app: QApplication, monkeypatch) -> None:
    from pynq_multimodal_game.studio import workspaces

    lifecycle = []

    class TrackedThread(workspaces.QThread):
        def wait(self, *args, **kwargs):
            result = super().wait(*args, **kwargs)
            lifecycle.append(("wait", result))
            return result

        def deleteLater(self):
            lifecycle.append(("delete", None))
            super().deleteLater()

    monkeypatch.setattr(workspaces, "QThread", TrackedThread)

    class UnavailableCamera(BaseHTTPRequestHandler):
        def do_GET(self) -> None:
            self.send_error(503)

        def log_message(self, format: str, *args: object) -> None:
            pass

    server = ThreadingHTTPServer(("127.0.0.1", 0), UnavailableCamera)
    server_thread = Thread(target=server.serve_forever, daemon=True)
    server_thread.start()
    window = StudioMainWindow()
    window.show()
    try:
        vision = window.vision_workspace
        vision.camera_url.setText(f"http://127.0.0.1:{server.server_port}/camera.mjpg")
        vision.camera_button.click()
        _process_until(qt_app, lambda: '恢复中' in vision.stream_status.text())
        assert vision._camera_thread is not None and vision._camera_thread.isRunning()
        assert window.camera_status.text() == "CAM 自动重连"
        assert vision.camera_button.isEnabled()
        vision.stop_camera(wait=True)
        assert sum(action=='delete' for action,_ in lifecycle)==3
        assert all(result is True for action,result in lifecycle if action=='wait')
    finally:
        window.close()
        server.shutdown()
        server.server_close()
        server_thread.join(timeout=2)


def test_vision_camera_cleanup_runs_from_gui_refresh(qt_app: QApplication) -> None:
    window = StudioMainWindow()
    vision = window.vision_workspace
    try:
        vision.camera_url.setText("invalid://localhost/camera.mjpg")
        vision.start_camera()
        vision._camera_timer.stop()
        thread = vision._camera_thread
        assert thread is not None
        _process_until(qt_app, thread.isFinished)
        assert vision._camera_thread is thread
        vision._refresh_camera()
        assert vision._camera_thread is None
        assert vision._camera_worker is None
        assert vision.camera_button.isEnabled()
        assert vision.stream_status.text() == "Expected an HTTP MJPEG URL"
    finally:
        window.close()


def test_main_window_switches_workspaces_and_keeps_pc_authoring_offline(
    qt_app: QApplication,
) -> None:
    window = StudioMainWindow()
    assert window.workspace_count == 6
    assert window.navigation.currentRow() == 2
    assert window.workspace_stack.currentIndex() == 2
    assert window.workspace_stack.widget(3) is window.video_workspace

    for iteration in range(100):
        window.select_workspace(iteration % window.workspace_count)
    assert window.workspace_stack.currentIndex() == 3
    assert window.device.snapshot.state is DeviceState.DISCONNECTED

    assert window.game_workspace.session is None
    assert "PC" in window.game_workspace.viewport.text()
    assert window.game_workspace.input_target.currentData() == "pc"
    window.game_workspace.game_list.setCurrentRow(0)
    assert window.game_workspace._active_project is not None
    assert window.game_workspace._active_project.name == "game1"
    assert window.game_workspace.code_editor.project_root.name == "game1"
    window.game_workspace.show_pynq_output()
    assert window.game_workspace.session is None
    assert window.game_workspace.timer.isActive() is False
    window.close()
    assert window.game_workspace.timer.isActive() is False


def test_rgb_to_qimage_rejects_wrong_size() -> None:
    with pytest.raises(ValueError, match="RGB frame"):
        rgb_to_qimage(b"short")


def test_device_summary_and_log_remain_available_on_all_pages(qt_app: QApplication) -> None:
    window = StudioMainWindow()
    window.show()
    try:
        assert window.remote_thread is None
        assert "离线" in window.target_label.text()
        assert "未订阅" in window.receive_status.text()
        assert window.session_log.isHidden()
        for index in range(window.workspace_count):
            window.select_workspace(index)
            qt_app.processEvents()
            assert window.status_bar.isVisible()
            assert window.log_button.isVisible()
        window.log_button.click()
        assert window.session_log.isVisible()
        window.log_button.click()
        assert window.session_log.isHidden()
    finally:
        window.close()
    assert not window._background_timer.isActive()


def test_device_readout_is_marked_historical_after_disconnect(qt_app: QApplication) -> None:
    window = StudioMainWindow()
    try:
        window.use_remote_device("127.0.0.1", 8765, persist=False, connect=False)
        ready = DeviceSnapshot(DeviceState.READY, "localhost test", 0xC0060700, "ok", 1)
        window._on_device_snapshot(ready)
        assert "0xC0060700" in window.build_label.text()
        assert "等待数据" in window.receive_status.text()
        window._on_workspace_feedback("Game / PYNQ", "暂停完成", "success", {"state": "paused"})
        assert "最近回读" in window.readout_status.text()
        error = DeviceSnapshot(DeviceState.ERROR, "localhost test", None, "test connection lost", 2)
        window._on_device_snapshot(error)
        assert window.device_label.objectName() == "deviceError"
        assert window.device_label.toolTip() == "test connection lost"
        assert "历史回读" in window.readout_status.text()
        assert window.build_label.text() == "BUILD_ID --"
        window._on_device_snapshot(ready)
        assert "历史回读" in window.readout_status.text()
        assert "等待数据" in window.receive_status.text()
    finally:
        window.close()


def test_device_configuration_preserves_target_while_io_busy(
    qt_app: QApplication,
) -> None:
    window = StudioMainWindow()
    window.use_remote_device("127.0.0.1", 8765, persist=False, connect=False)
    original = window.device
    window.load_workspace.thread = object()
    try:
        window.use_remote_device("127.0.0.2", 8766, persist=False, connect=False)
        assert window.device is original
        assert window.game_workspace.device is None
        assert window.load_workspace.device is original
        assert window.vision_workspace.camera_url.text() == "http://127.0.0.1:8088/camera.mjpg"
        assert "任务执行中" in window.task_status.toolTip()
    finally:
        window.load_workspace.thread = None
        window.close()


def test_theme_keeps_text_backgrounds_transparent() -> None:
    widget_rule = STUDIO_STYLESHEET.split("}", maxsplit=1)[0]
    assert "background:" not in widget_rule
    assert "QLabel {\n    background: transparent;\n}" in STUDIO_STYLESHEET


def test_theme_uses_high_contrast_selection_controls() -> None:
    assert "QComboBox, QLineEdit, QSpinBox, QDoubleSpinBox" in STUDIO_STYLESHEET
    assert "color: #f4f7f8;" in STUDIO_STYLESHEET
    assert "QComboBox QAbstractItemView" in STUDIO_STYLESHEET
    assert "selection-background-color: #e8377e;" in STUDIO_STYLESHEET
    assert "selection-color: #201018;" in STUDIO_STYLESHEET
    assert "QListWidget#testCaseList::item" in STUDIO_STYLESHEET


def test_theme_separates_action_selection_from_device_errors() -> None:
    pressed_rule = STUDIO_STYLESHEET.split("QPushButton:pressed", 1)[1].split("}", 1)[0]
    assert "#e8377e" in pressed_rule
    assert "#ff6b57" not in pressed_rule
    assert 'QLabel[status="error"]' in STUDIO_STYLESHEET
    assert 'QLabel[status="waiting"]' in STUDIO_STYLESHEET
    assert "QPushButton:disabled" in STUDIO_STYLESHEET
    assert "Microsoft YaHei UI" in STUDIO_STYLESHEET


def test_console_entrypoint_builds_and_closes_real_window(
    qt_app: QApplication,
) -> None:
    assert main(("voice-view-studio", "--smoke-test")) == 0


def test_remote_agent_updates_fixture_workspaces_and_closes_thread(
    qt_app: QApplication,
) -> None:
    server = AgentServer(AgentController(MockRuntimeBackend(build_id=0xC0060700)))
    server.start()
    host, port = server.address
    replacement: AgentServer | None = None
    window = StudioMainWindow(agent_host=host, agent_port=port)
    window.show()
    try:
        window.toggle_device()
        _process_until(qt_app, lambda: window.device.snapshot.state is DeviceState.READY)
        window.select_workspace(4)
        server.publish_data(
            encode_fixture_frame(2, 1, bytes((255, 0, 0, 0, 255, 0))),
            source_id=1,
        )
        server.publish_data(encode_fixture_series([0.0, 1.0, 0.0]), source_id=2)
        _process_until(qt_app, lambda: window.audio_workspace.stream_buffer.counters.accepted == 1)
        window.vision_workspace.flush_stream()
        window.audio_workspace.flush_stream()
        assert window.vision_workspace.contract_value.text() == "fixture.frame2d"
        assert window.vision_workspace.canvas.pixmap().isNull() is False
        assert window.audio_workspace.contract_value.text() == "fixture.series"
        assert window.audio_workspace.canvas.pixmap().isNull() is False
        assert window._received_count == 2
        assert "RX 2 包" in window.receive_status.text()
        assert window.status_bar.isVisible()
        assert window.workspace_stack.currentIndex() == 4

        server.close()
        _process_until(qt_app, lambda: window.device.snapshot.state is DeviceState.ERROR)
        qt_app.processEvents()
        assert "RX 未连接" in window.receive_status.text()
        assert "历史" in window.audio_workspace.canvas_source.text()
        replacement = AgentServer(
            AgentController(MockRuntimeBackend(build_id=0xC0060700)),
            host=host,
            port=port,
        )
        replacement.start()
        _process_until(qt_app, lambda: window.device.snapshot.state is DeviceState.READY)
        qt_app.processEvents()
        assert "等待数据" in window.receive_status.text()
        replacement.publish_data(encode_fixture_series([0.0, 0.2, 1.0]), source_id=2)
        _process_until(qt_app, lambda: window._received_count == 1)
        assert window.audio_workspace.stream_buffer.counters.out_of_order == 0
        window.audio_workspace.flush_stream()
        assert "seq 1" in window.audio_workspace.stream_status.text()
    finally:
        window.close()
        server.close()
        if replacement is not None:
            replacement.close()
    assert window.remote_thread is None or window.remote_thread.isRunning() is False


def test_window_configures_remote_agent_without_cli_arguments(
    qt_app: QApplication,
) -> None:
    server = AgentServer(AgentController(MockRuntimeBackend(build_id=0xC0060700)))
    server.start()
    window = StudioMainWindow()
    window.show()
    try:
        window.use_remote_device(
            *server.address,
            source_address=server.address[0],
            persist=False,
            connect=True,
        )
        _process_until(qt_app, lambda: window.device.snapshot.state is DeviceState.READY)

        assert window.remote_mode is True
        assert window.device._client.source_address == server.address[0]
        assert window.vision_workspace.camera_url.text() == f"http://{server.address[0]}:8088/camera.mjpg"
        assert window.game_workspace.device is None
        assert window.load_workspace.device is window.device
        assert window.game_workspace.input_target.currentData() == "pc"
        assert "AGENT READY" in window.device_label.text()
        window.vision_workspace.camera_url.setText("http://127.0.0.1:9000/custom.mjpg")
        window.vision_workspace.set_camera_host("192.168.2.99")
        assert window.vision_workspace.camera_url.text() == "http://127.0.0.1:9000/custom.mjpg"
    finally:
        window.close()
        server.close()


def test_connection_dialog_uses_active_r23_target_instead_of_stale_settings(
    qt_app: QApplication, monkeypatch,
) -> None:
    from PySide6.QtWidgets import QDialog
    from pynq_multimodal_game.studio import main_window as module

    window = StudioMainWindow(agent_host="127.0.0.1", agent_port=8875,
                              agent_source_address="127.0.0.2", agent_build_id=0xC0061000)
    previous_build_id = window.settings.value("pynq/build_id")
    window.settings.setValue("pynq/build_id", 0xC0060800)
    captured = {}

    class Dialog:
        def __init__(self, host, port, source_address, parent, *, expected_build_id):
            captured.update(host=host, port=port, source_address=source_address,
                            build_id=expected_build_id)

        def exec(self):
            return QDialog.DialogCode.Rejected

    try:
        monkeypatch.setattr(module, "PynqConnectionDialog", Dialog)
        window.configure_pynq()
        assert captured == {"host": "127.0.0.1", "port": 8875,
                            "source_address": "127.0.0.2", "build_id": 0xC0061000}
    finally:
        if previous_build_id is None:
            window.settings.remove("pynq/build_id")
        else:
            window.settings.setValue("pynq/build_id", previous_build_id)
        window.close()


def test_r23_studio_connects_after_agent_is_already_running(qt_app: QApplication) -> None:
    from dataclasses import replace
    from pynq_multimodal_game.agent.core import AgentState

    class ButtonBackend(MockRuntimeBackend):
        @property
        def snapshot(self):
            return replace(super().snapshot, profile="C6I_VISION_BUTTON_V1",
                           state=AgentState.RUNNING)

    server = AgentServer(AgentController(ButtonBackend(build_id=0xC0061000)))
    server.start()
    window = StudioMainWindow(agent_host=server.address[0], agent_port=server.address[1],
                              agent_build_id=0xC0061000)
    window.show()
    try:
        window.toggle_device()
        _process_until(qt_app, lambda: window.device.snapshot.state is DeviceState.READY)
        assert "AGENT READY" in window.device_label.text()
        assert window.device._source_ids == ()
        assert window.audio_workspace is None
        assert window.workspace_count == 5
        assert [window.navigation.item(index).text() for index in range(5)] == [
            "Vision", "Game", "Video", "PL GPU", "加载到 PYNQ"]
        from pynq_multimodal_game.protocol import MessageType, ProtocolFrame
        received_before = window._received_count
        window._on_remote_frame(ProtocolFrame(
            MessageType.DATA, encode_fixture_series([0.0, 1.0]), source_id=2))
        assert window._received_count == received_before
        window.toggle_device()
        _process_until(qt_app, lambda: window.remote_thread is None)
        window.toggle_device()
        _process_until(qt_app, lambda: window.device.snapshot.state is DeviceState.READY)
    finally:
        window.close()
        server.close()


def test_replacing_connected_agent_keeps_new_background_session(qt_app: QApplication) -> None:
    first = AgentServer(AgentController(MockRuntimeBackend(build_id=0xC0060700)))
    second = AgentServer(AgentController(MockRuntimeBackend(build_id=0xC0060700)))
    first.start()
    second.start()
    window = StudioMainWindow()
    window.show()
    try:
        window.use_remote_device(*first.address, persist=False, connect=True)
        _process_until(qt_app, lambda: "AGENT READY" in window.device_label.text())
        window.use_remote_device(*second.address, persist=False, connect=True)
        _process_until(qt_app, lambda: "AGENT READY" in window.device_label.text())
        assert window.remote_thread is not None and window.remote_thread.isRunning()
        assert str(second.address[1]) in window.target_label.text()
        second.publish_data(encode_fixture_series([0.0, 0.5]), source_id=2)
        _process_until(qt_app, lambda: window._received_count == 1)
        assert window.audio_workspace.stream_buffer.counters.accepted == 1
    finally:
        window.close()
        first.close()
        second.close()


def _process_until(
    app: QApplication,
    predicate,
    *,
    timeout_ms: int = 2000,
) -> None:
    loop = QEventLoop()
    timer = QTimer()
    timer.setInterval(10)
    elapsed = 0

    def check() -> None:
        nonlocal elapsed
        app.processEvents()
        if predicate():
            loop.quit()
            return
        elapsed += timer.interval()
        if elapsed >= timeout_ms:
            loop.quit()

    timer.timeout.connect(check)
    timer.start()
    check()
    loop.exec()
    timer.stop()
    assert predicate()
