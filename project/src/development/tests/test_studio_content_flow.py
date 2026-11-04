"""Offline content closure: real PC runner/codec, fake device receipts, real Qt UI."""
import json
import os
from pathlib import Path
import threading
import time
from types import SimpleNamespace

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")

import pytest
from PySide6.QtCore import QSettings, Qt
from PySide6.QtWidgets import QApplication, QPushButton

from pynq_multimodal_game.game_package import validate_game_package
from pynq_multimodal_game.game_project import GameProject
from pynq_multimodal_game.game_testing import GameTestCase, AssertionRule, AssertionOperator
from pynq_multimodal_game.studio import content_pipeline, local_video, main_window
from pynq_multimodal_game.studio.content_pipeline import ContentItem, file_identity, load_content
from pynq_multimodal_game.studio.device import DeviceState, video_library_identity
from pynq_multimodal_game.video_codec import encode_rgb_frames


@pytest.fixture(scope="module")
def app():
    return QApplication.instance() or QApplication([])


def until(app, predicate, seconds=10):
    deadline = time.monotonic() + seconds
    while time.monotonic() < deadline:
        app.processEvents()
        if predicate():
            return
        time.sleep(0.01)
    assert predicate()


@pytest.fixture
def project(tmp_path):
    project = GameProject.create(tmp_path / "games" / "sample", game_id="sample", display_name="测试游戏")
    GameTestCase(test_id="golden", name="基本测试", max_ticks=2).save(
        project.root / "tests/replays/golden.json")
    return project.root


@pytest.fixture
def video(tmp_path):
    path = tmp_path / "clip.s2v"
    encode_rgb_frames([bytes((255, 0, 0)) * (320 * 180),
                       bytes((0, 255, 0)) * (320 * 180)], path)
    return path


class FakeDevice:
    expected_build_id = 0xC0061000

    def __init__(self):
        self.installs = []
        self.library = []
        self.snapshot = SimpleNamespace(state=DeviceState.READY, name="local fake")

    def install_game(self, path, *, progress):
        return self.install("game", path, progress)

    def install_s2v(self, path, *, progress, display_name=None):
        return self.install("video", path, progress, display_name)

    def install(self, kind, path, progress, display_name=None):
        self.installs.append((kind, path))
        progress(path.stat().st_size, path.stat().st_size)
        item_id = (validate_game_package(path).manifest.game_id if kind == "game"
                   else video_library_identity(path, display_name)[0])
        self.library.append(dict(kind=kind, item_id=item_id, display_name=display_name, **file_identity(path)))
        return {"ok": True}

    def list_library(self, kind=None):
        return {"library_items": [item for item in self.library if kind is None or item["kind"] == kind]}


def test_batch_builds_game_encodes_video_verifies_all_library_identities(project, video, tmp_path):
    device = FakeDevice()
    result = load_content([ContentItem("game", project, "游戏"), ContentItem("video", video, "视频")],
                          device, tmp_path / "load")
    assert result["status"] == "complete"
    assert [kind for kind, path in device.installs] == ["game", "video"]
    assert all(item["state"] == "installed" for item in result["items"])
    assert result["items"][0]["tests"] == [{"name": "基本测试", "passed": True, "assertions": 0}]
    assert validate_game_package(device.installs[0][1]).manifest.target_build_id == 0xC0061000
    assert result["items"][1]["frames"] == 2
    assert json.loads((tmp_path / "load/receipt.json").read_text("utf-8")) == result


def test_four_videos_preserve_titles_and_distinct_ids_even_for_identical_content(video, tmp_path):
    paths = []
    for name in ("source", "一", "二", "三"):
        path = tmp_path / f"{name}.s2v"
        path.write_bytes(video.read_bytes())
        paths.append(path)
    result = load_content([ContentItem("video", p, p.stem) for p in paths], FakeDevice(), tmp_path / "four")
    assert result["status"] == "complete"
    assert len({r["library"]["item_id"] for r in result["items"]}) == 4
    assert [r["library"]["display_name"] for r in result["items"]] == [p.stem for p in paths]
    assert all(Path(r["package"]).is_file() for r in result["items"])


def test_duplicate_video_identity_prevents_entire_upload(video, tmp_path):
    device = FakeDevice()
    with pytest.raises(ValueError, match="重复的视频"):
        load_content([ContentItem("video", video, "同名")] * 2, device, tmp_path / "duplicate")
    assert not device.installs


def test_invalid_later_item_prevents_every_upload(project, tmp_path):
    device = FakeDevice()
    with pytest.raises(FileNotFoundError):
        load_content([ContentItem("game", project, "ok"),
                      ContentItem("video", tmp_path / "missing.mp4", "missing")], device, tmp_path / "load")
    assert device.installs == []
    receipt = json.loads((tmp_path / "load/receipt.json").read_text("utf-8"))
    assert receipt["status"] == "failed"
    assert receipt["items"][0]["state"] == "validated"


def test_failed_game_assertion_prevents_upload(project, tmp_path):
    GameTestCase(test_id="fail", name="错误断言", max_ticks=2,
                 assertions=(AssertionRule(1, "score", AssertionOperator.EQUAL, 999),)).save(
        project / "tests/replays/fail.json")
    device = FakeDevice()
    with pytest.raises(RuntimeError, match="PC 测试未通过"):
        load_content([ContentItem("game", project, "game")], device, tmp_path / "load")
    assert not device.installs


def test_readback_mismatch_keeps_partial_receipts(project, video, tmp_path):
    device = FakeDevice()
    original = device.list_library
    device.list_library = lambda kind=None: original(kind) if kind == "game" else {"library_items": []}
    with pytest.raises(RuntimeError, match="身份回读不一致"):
        load_content([ContentItem("game", project, "game"), ContentItem("video", video, "video")],
                     device, tmp_path / "load")
    receipt = json.loads((tmp_path / "load/receipt.json").read_text("utf-8"))
    assert [item["state"] for item in receipt["items"]] == ["installed", "unconfirmed"]


def test_cancel_after_preflight_prevents_upload(project, tmp_path):
    stop = threading.Event()
    def progress(message):
        if message.startswith("PC 验证"):
            stop.set()
    device = FakeDevice()
    with pytest.raises(RuntimeError):
        load_content([ContentItem("game", project, "game")], device, tmp_path / "load",
                     stop_event=stop, progress=progress)
    assert not device.installs
    assert json.loads((tmp_path / "load/receipt.json").read_text("utf-8"))["status"] == "cancelled"


@pytest.fixture
def window(app, project, tmp_path, monkeypatch):
    monkeypatch.setenv("VOICE_VIEW_GAME_PROJECTS_ROOT", str(project.parent))
    monkeypatch.setattr(main_window, "QSettings", lambda: QSettings(str(tmp_path / "settings.ini"), QSettings.IniFormat))
    from pynq_multimodal_game.studio.default_content import DEFAULT_VIDEO_VERSION
    settings=main_window.QSettings()
    settings.setValue('content/default-video-version',DEFAULT_VIDEO_VERSION)
    settings.setValue('content/videos',[])  # Explicit empty user library for isolated fixtures.
    win = main_window.StudioMainWindow(agent_build_id=0xC0061000)
    win.show()
    app.processEvents()
    yield win
    assert win.close()
    app.processEvents()


def test_prepare_only_uses_real_studio_validation_without_device_io(project,video,tmp_path):
    device=FakeDevice()
    result=load_content([ContentItem('game',project,'Game'),ContentItem('video',video,'Video')],
                        device,tmp_path/'prepare-only',prepare_only=True)
    assert result['status']=='validated' and not device.installs
    assert all(r['state']=='validated' for r in result['items'])


def test_pc_page_has_no_remote_target_or_deploy_control_and_runs_real_game(app, window):
    game = window.game_workspace
    assert game.device is None
    assert game.input_target.count() == 1 and game.input_target.currentData() == "pc"
    assert game.input_target.isHidden()
    texts = [button.text() for button in game.findChildren(QPushButton) if button.isVisible()]
    assert "PC 试玩" in texts and "运行 PC 测试" in texts
    assert not any("VVG" in text or "PYNQ" in text for text in texts)
    game.start_project_preview()
    until(app, lambda: game._preview_thread is None)
    assert game._last_pc_report["status"] == "passed"
    assert not (game.projects_root / ".build").exists()
    game.start_project_play()
    until(app, lambda: game._last_pc_frame is not None)
    assert game._preview_thread is not None
    window.select_workspace(window.workspace_stack.indexOf(window.video_workspace))
    assert game._preview_thread is None


def test_video_full_test_has_frames_and_no_device_calls(app, window, video):
    pane = window.video_workspace
    pane.add_sources([video, video])
    assert pane.source_paths == (video.resolve(),)
    pane.start(testing=True)
    until(app, lambda: not pane.is_busy)
    assert pane.last_result["frames"] == 2
    assert pane.last_result["tested"]
    assert pane.preview.pixmap() is not None and not pane.preview.pixmap().isNull()
    assert not hasattr(pane, "upload_target")


def test_video_pause_resume_and_stop_release_thread(app, window, monkeypatch, video):
    def frames(path):
        for _ in range(500):
            yield bytes((2, 3, 4)) * (320 * 180)
    monkeypatch.setattr(local_video, "local_frames", frames)
    pane = window.video_workspace
    pane.add_sources([video])
    pane.play()
    until(app, lambda: pane._image is not None)
    pane.pause()
    assert pane.worker.paused.is_set()
    pane.play()
    assert not pane.worker.paused.is_set()
    assert pane.stop(wait=True)
    assert not pane.is_busy and not pane.timer.isActive()


def test_connection_button_opens_real_configuration_not_simulator(window, monkeypatch):
    called = []
    monkeypatch.setattr(window, "configure_pynq", lambda: called.append(True))
    window.device_button.click()
    assert called == [True]
    assert "PC 离线" in window.device_label.text()


@pytest.mark.parametrize('mode',['start','install','retry','field'])
def test_system_start_slow_io_keeps_gui_heartbeat_and_cancel_alive(app,window,monkeypatch,tmp_path,mode):
    from PySide6.QtCore import QThread,QTimer
    from pynq_multimodal_game.studio.load_workspace import SystemLoader
    window.use_remote_device('192.0.2.1',8765,expected_build_id=0xC0061000,persist=False,connect=False)
    pane=window.load_workspace
    calls=[];beats=[]
    def slow_start(self,*args,stop_event,progress,**kw):
        calls.append(QThread.currentThread() is app.thread())
        progress('waiting for simulated board')
        stop_event.wait(.8)
        calls.append(stop_event.is_set())
        raise InterruptedError('simulated cancellation')
    monkeypatch.setattr(SystemLoader,{'start':'start_installed','install':'load',
                                   'retry':'resume_installed','field':'start_field'}[mode],slow_start)
    timer=QTimer();timer.setInterval(20);timer.timeout.connect(lambda:beats.append(time.monotonic()))
    timer.start()
    QTimer.singleShot(150,lambda:pane.cancel_button.click())
    try:
        if mode=='start':pane.project_start_button.click()
        else:
            pane.system_candidate=tmp_path
            pane._start_system(field=mode=='field',resume_receipt=tmp_path/'receipt.json' if mode=='retry' else None)
        until(app,lambda:not pane.is_busy,seconds=3)
        assert calls==[False,True],f'GUI thread / cancellation: {calls}'
        assert len(beats)>=3,f'GUI heartbeat stalled: {beats}'
    finally:
        timer.stop()
        pane.stop(wait=True)


def test_board_online_agent_stopped_keeps_deployment_and_start_available(window,monkeypatch):
    from pynq_multimodal_game.studio.device import DeviceState
    window.use_remote_device('192.0.2.1',8765,expected_build_id=0xC0061000,persist=False,connect=False)
    window.device.fail('connection refused')
    window._on_board_info(dict(ssh_ready=True,installed={'root':'package'},running=False))
    pane=window.load_workspace
    assert 'SSH' in window.board_label.text() and '未运行' in window.device_label.text()
    assert pane.project_start_button.isEnabled()
    assert window.device.snapshot.state is DeviceState.ERROR  # SSH must not pretend HELLO passed.
    called=[]
    monkeypatch.setattr(pane,'_start_system',lambda **kw:called.append(kw))
    pane.project_start_button.click()
    assert called==[dict(field=None,start_only=True)]
    assert not hasattr(pane,'field_start_button')
    assert not hasattr(pane,'field_observer')


@pytest.mark.parametrize('info,expected',[
    (dict(loader_busy=True),'启动检查'),
    (dict(running=True,startup_stage='内容库初始化'),'内容库初始化'),
    (dict(service={'ActiveState':'failed','Result':'exit-code'}),'自启动失败'),
])
def test_startup_stages_are_visible_before_agent_ready(window,info,expected):
    window.use_remote_device('192.0.2.1',8765,expected_build_id=0xC0061000,persist=False,connect=False)
    window.device.fail('connection refused')
    window._on_board_info(dict(ssh_ready=True,installed={'root':'package'},**info))
    assert expected in window.load_workspace.target_label.text()
    assert expected in window.device_label.toolTip()


def test_content_worker_bootstraps_offline_agent_before_upload(tmp_path,monkeypatch):
    from pynq_multimodal_game.studio import load_workspace as module
    from pynq_multimodal_game.studio.device import RemoteDeviceSession
    device=RemoteDeviceSession('192.0.2.1',8765,expected_build_id=0xC0061000)
    events=[]
    monkeypatch.setattr(module.SystemLoader,'ensure_running',lambda self,*a,**kw:events.append('start'))
    monkeypatch.setattr(module,'load_content',lambda *a,**kw:events.append('content') or {'items':[]})
    worker=module.ContentLoadWorker((),device,tmp_path/'content')
    worker.run()
    assert events==['start','content']
    events.clear()
    worker=module.ContentLoadWorker((),device,tmp_path/'prepare',prepare_only=True)
    worker.run()
    assert events==['content']


def test_system_load_stops_old_agent_receiver_before_replacement(window,monkeypatch):
    calls=[]
    monkeypatch.setattr(window,'_prepare_local_work',lambda kind:calls.append(kind) or True)
    monkeypatch.setattr(window,'_stop_remote',lambda *,wait:calls.append(('stop',wait)) or True)
    assert window.load_workspace.before_system_run()
    assert calls==['load',('stop',True)]


def test_system_load_does_not_continue_when_old_receiver_cannot_stop(window,monkeypatch):
    with monkeypatch.context() as patch:
        patch.setattr(window,'_prepare_local_work',lambda kind:True)
        patch.setattr(window,'_stop_remote',lambda *,wait:False)
        assert not window.load_workspace.before_system_run()
        assert not window.load_workspace.is_busy


def test_system_retry_is_persisted_bounded_and_uses_worker(app,window,tmp_path,monkeypatch):
    from pynq_multimodal_game.studio.load_workspace import ContentLoadWorkspace,SystemLoadWorker,SystemLoader
    from pynq_multimodal_game.studio.device import RemoteDeviceSession
    pane=window.load_workspace
    candidate=tmp_path/'candidate';candidate.mkdir()
    (candidate/'deployment_manifest.json').write_text('{}')
    pane.set_system_candidate(candidate)
    failed=tmp_path/'failure.json'
    failed.write_text(json.dumps(dict(schema='studio-system-load-v1',result='FAIL',
        hand_enabled=False,steps=[dict(name='installed')])))
    pane._remember_failed_start(failed)
    other=ContentLoadWorkspace(window.game_workspace,window.video_workspace,settings=window.settings)
    assert other.system_candidate==candidate and other._retry_receipt==failed
    assert not other.system_retry_button.isEnabled()  # no connected target
    other.set_device(RemoteDeviceSession('192.0.2.1',8765,expected_build_id=0xC0061000))
    assert other.system_retry_button.isEnabled()
    called=[]
    monkeypatch.setattr(other,'_start_system',lambda **kwargs:called.append(kwargs))
    other.system_retry_button.click()
    assert called==[dict(field=False,resume_receipt=failed)]
    worker=SystemLoadWorker(candidate,object(),tmp_path/'recovery','test',resume_receipt=failed)
    class Loader:
        def __init__(self,*args,**kwargs):pass
        def resume_installed(self,source,output,**options):
            assert source==failed and options['stop_event'] is worker.stopping
            return dict(schema='studio-system-load-v1',result='PASS')
        def load(self,*args,**kwargs):raise AssertionError('Retry must not reinstall')
    monkeypatch.setattr('pynq_multimodal_game.studio.load_workspace.SystemLoader',Loader)
    worker.completed.connect(other._completed);worker.run()
    assert not window.settings.contains('content/system-failure')
    assert other._retry_receipt is None
    other.close()


def test_loader_uses_worker_and_locks_authoring_until_completion(app, window, video):
    window.video_workspace.add_sources([video])
    loader = window.load_workspace
    device = FakeDevice()
    loader.set_device(device)
    loader.refresh_contents()
    for index in range(loader.items.count()):
        loader.items.item(index).setCheckState(Qt.CheckState.Checked)
    loader.start()
    assert loader.is_busy and not window.game_workspace.isEnabled()
    assert not window.video_workspace.isEnabled()
    until(app, lambda: not loader.is_busy, seconds=30)
    assert loader.last_receipt["status"] == "complete"
    assert window.game_workspace.isEnabled()
    assert len(device.installs) == 2


def test_close_veto_preserves_blocked_video_worker(app, window, monkeypatch, video):
    release = threading.Event()
    entered = threading.Event()
    def frames(path):
        entered.set()
        release.wait(8)
        yield bytes((0, 0, 0)) * (320 * 180)
    monkeypatch.setattr(local_video, "local_frames", frames)
    pane = window.video_workspace
    pane.add_sources([video])
    pane.start()
    assert entered.wait(1)
    try:
        assert not window.close()
        assert pane.thread is not None and pane.thread.isRunning()
    finally:
        release.set()
        until(app, lambda: not pane.is_busy)


def test_bad_video_is_failed_without_passing_or_stale_preview(app, window, tmp_path):
    path = tmp_path / "bad.s2v"
    path.write_bytes(b"invalid")
    pane = window.video_workspace
    pane.add_sources([path])
    pane.start(testing=True)
    until(app, lambda: not pane.is_busy)
    assert pane.last_result is None
    assert "失败" in pane.status_value.text()


def test_real_mp4_decoding_and_s2v_conversion(app, window, tmp_path):
    import av
    import numpy as np
    source = tmp_path / "source.mp4"
    with av.open(str(source), "w") as container:
        stream = container.add_stream("mpeg4", rate=30)
        stream.width, stream.height, stream.pix_fmt = 320, 180, "yuv420p"
        for value in (40, 90, 140, 190):
            frame = av.VideoFrame.from_ndarray(np.full((180, 320, 3), value, dtype=np.uint8), format="rgb24")
            for packet in stream.encode(frame):
                container.mux(packet)
        for packet in stream.encode():
            container.mux(packet)
    pane = window.video_workspace
    pane.add_sources([source])
    pane.start(testing=True)
    until(app, lambda: not pane.is_busy)
    assert pane.last_result["frames"] >= 2
    receipt = load_content([ContentItem("video", source, "MP4")], FakeDevice(), tmp_path / "mp4-load")
    assert receipt["items"][0]["frames"] == pane.last_result["frames"]
    assert receipt["status"] == "complete"


def test_current_three_gesture_games_pass_unified_preflight(tmp_path):
    root = Path(__file__).resolve().parents[1] / "games_gesture"
    device = FakeDevice()
    result = load_content([ContentItem("game", root / name, name)
                           for name in ("game1", "game2", "game3")], device, tmp_path / "production-load")
    assert result["status"] == "complete"
    assert len(device.installs) == 3
    assert all(case["passed"] for item in result["items"] for case in item["tests"])


def test_unified_load_over_real_local_tcp_without_starting_playback(project, video, tmp_path):
    from dataclasses import replace
    from pynq_multimodal_game.agent.core import AgentCommand, AgentController, LibraryItemSnapshot, MockRuntimeBackend
    from pynq_multimodal_game.agent.transport import AgentServer
    from pynq_multimodal_game.studio.device import RemoteDeviceSession

    class Backend(MockRuntimeBackend):
        def __init__(self):
            super().__init__(build_id=0xC0061000)
            self.installed = {}

        @property
        def snapshot(self):
            return replace(super().snapshot, profile="C6I_VISION_BUTTON_V1")

        def install_staged_library_item(self, item_id, display_name, library_kind):
            manifest = self._staged[0]
            item = LibraryItemSnapshot(item_id, display_name, library_kind, manifest.length, manifest.sha256)
            self.installed[item_id] = item
            return item

        def list_library_items(self, library_kind):
            return tuple(item for item in self.installed.values() if item.kind == library_kind)

    class Controller(AgentController):
        def __init__(self, *args, **kwargs):
            super().__init__(*args, **kwargs)
            self.calls = []

        def execute(self, request_id, command, **kwargs):
            self.calls.append(command)
            return super().execute(request_id, command, **kwargs)

    backend = Backend()
    controller = Controller(backend, upload_directory=tmp_path / "uploads")
    server = AgentServer(controller)
    server.start()
    session = RemoteDeviceSession(*server.address, expected_build_id=0xC0061000)
    try:
        assert session.connect().state is DeviceState.READY
        result = load_content([ContentItem("game", project, "game")] +
                             [ContentItem("video", video, name) for name in ("测试一", "测试二", "测试三", "测试四")],
                              session, tmp_path / "tcp-load")
        assert result["status"] == "complete"
        assert controller.calls.count(AgentCommand.LIBRARY_INSTALL) == 5
        assert controller.calls.count(AgentCommand.LIBRARY_LIST) >= 5
        assert len({r["library"]["item_id"] for r in result["items"] if r["kind"] == "video"}) == 4
        assert AgentCommand.LIBRARY_RUN not in controller.calls
        assert not {AgentCommand.RUN, AgentCommand.ACTIVATE, AgentCommand.SHELL_INITIALIZE,
                    AgentCommand.VISION_START}.intersection(controller.calls)
    finally:
        session.disconnect()
        server.close()
        controller.close()


def test_switching_away_stops_local_preview_and_releases_resources(app, window, monkeypatch, video):
    def frames(path):
        for _ in range(400):
            yield bytes((0, 12, 24)) * (320 * 180)
    monkeypatch.setattr(local_video, "local_frames", frames)
    pane = window.video_workspace
    pane.add_sources([video])
    window.select_workspace(window.workspace_stack.indexOf(pane))
    pane.play()
    until(app, lambda: pane._image is not None)
    window.select_workspace(window.workspace_stack.indexOf(window.game_workspace))
    assert not pane.is_busy and not pane.timer.isActive()


def test_connection_replace_retains_old_thread_until_shutdown_confirmed(window):
    class Thread:
        def isRunning(self): return True
        def quit(self): pass
        def wait(self, timeout): return False

    window.use_remote_device("127.0.0.1", 8123, persist=False, connect=False)
    old = window.device
    thread = Thread()
    window.remote_thread = thread
    try:
        window.use_remote_device("127.0.0.1", 8124, persist=False, connect=False)
        assert window.device is old
        assert window.remote_thread is thread
        assert window.load_workspace.device is old
    finally:
        window.remote_thread = None


def test_source_edits_survive_tab_close_and_project_switch(app, window, project):
    game = window.game_workspace
    editor = game.code_editor
    path = project / "src/main.py"
    editor.tabs.currentWidget().appendPlainText("# kept on tab close")
    editor._close_tab(editor.tabs.currentIndex())
    assert "# kept on tab close" in path.read_text("utf-8")
    editor.open_file(path)
    editor.tabs.currentWidget().appendPlainText("# kept on project switch")
    other = GameProject.create(project.parent / "other", game_id="other", display_name="Other")
    game.refresh_projects()
    assert "# kept on project switch" in path.read_text("utf-8")
    assert not editor.dirty


def test_write_failure_preserves_dirty_tab_and_vetoes_window_close(window, project, monkeypatch):
    editor = window.game_workspace.code_editor
    editor.tabs.currentWidget().appendPlainText("# unsaved")
    count = editor.tabs.count()
    errors = []
    editor.save_failed.connect(errors.append)
    with monkeypatch.context() as patch:
        def deny():
            raise PermissionError("fixture read-only source")
        patch.setattr(editor, "save_all", deny)
        editor._close_tab(editor.tabs.currentIndex())
        assert editor.tabs.count() == count and editor.dirty and errors
        assert not window.close()
        assert editor.dirty and window.isVisible()
    assert window.close()
    assert "# unsaved" in (project / "src/main.py").read_text("utf-8")
