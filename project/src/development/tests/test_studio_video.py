import os

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")

from pathlib import Path
import threading

import pytest
from PySide6.QtCore import QEventLoop, QThread, QTimer
from PySide6.QtWidgets import QApplication, QSplitter

from pynq_multimodal_game.studio import video_workspace

from pynq_multimodal_game.studio.video_workspace import VideoWorkspace
from pynq_multimodal_game.video_codec import S2V1_HEIGHT, S2V1_WIDTH, S2V1Reader


@pytest.fixture(scope="module")
def qt_app() -> QApplication:
    return QApplication.instance() or QApplication([])


def test_video_workspace_encodes_previews_and_closes_thread(
    qt_app: QApplication,
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    frames = (
        bytes((252, 4, 4)) * (S2V1_WIDTH * S2V1_HEIGHT),
        bytes((4, 252, 4)) * (S2V1_WIDTH * S2V1_HEIGHT),
    )
    monkeypatch.setattr(
        video_workspace,
        "decode_video_frames",
        lambda *_args, **_kwargs: iter(frames),
    )
    window = VideoWorkspace()
    window.show()
    output = tmp_path / "studio.s2v"
    try:
        assert window.quality_profile.currentData() == "spatial-resident"
        window.start_encoding(Path("fixture.avi"), output)
        assert not window.play_button.isEnabled()
        assert not window.upload_button.isEnabled()
        _process_until(qt_app, lambda: not window.is_running)
        assert output.is_file()
        assert window.last_summary.frame_count == 2
        assert window.preview.pixmap().isNull() is False
        assert window.frames_value.text() == "2 frames"
        window.resize(1080, 700)
        qt_app.processEvents()
        assert window.width() == 1080
        preview = window.preview
        splitter = window.findChild(QSplitter)
        assert splitter is not None
        splitter.setSizes((380, 530))
        qt_app.processEvents()
        assert preview.pixmap().width() <= preview.width()
        assert preview.pixmap().height() <= preview.height()
        with S2V1Reader(output) as reader:
            assert reader.manifest["encoding"] == {
                "quality_profile": "spatial-resident"
            }
    finally:
        window.close()
    assert window.is_running is False


def test_video_workspace_cancels_background_encode(
    qt_app: QApplication,
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    started = threading.Event()
    release = threading.Event()
    frame = bytes((16, 32, 48)) * (S2V1_WIDTH * S2V1_HEIGHT)

    def delayed_frames(*_args, **_kwargs):  # type: ignore[no-untyped-def]
        started.set()
        release.wait(2)
        yield frame

    monkeypatch.setattr(video_workspace, "decode_video_frames", delayed_frames)
    window = VideoWorkspace()
    window.show()
    try:
        window.start_encoding(
            Path("fixture.avi"), tmp_path / "cancelled.s2v"
        )
        assert started.wait(2)
        window.stop(wait=False)
        release.set()
        _process_until(qt_app, lambda: not window.is_running)
        assert window.last_summary is None
        assert window.status_value.text() == "encoding cancelled"
        assert window.progress.value() == 0
    finally:
        release.set()
        window.close()


def test_video_workspace_uploads_in_background_and_cleans_thread(
    qt_app: QApplication,
    tmp_path: Path,
) -> None:
    class UploadTarget:
        def __init__(self) -> None:
            self.path: Path | None = None

        def upload_s2v(self, path: Path, *, progress=None):  # type: ignore[no-untyped-def]
            self.path = path
            if progress is not None:
                progress(0, 10)
                progress(4, 10)
                progress(10, 10)
            return {"ok": True, "state": "staged"}

    target = UploadTarget()
    workspace = VideoWorkspace(target)
    artifact = tmp_path / "upload.s2v"
    artifact.write_bytes(b"fixture")
    workspace.show()
    try:
        workspace.start_upload(artifact)
        assert not workspace.encode_button.isEnabled()
        assert not workspace.play_button.isEnabled()
        _process_until(qt_app, lambda: not workspace.is_uploading)

        assert target.path == artifact
        assert workspace.progress.value() == 100
        assert workspace.status_value.text() == "Staged on PYNQ Agent"
        assert workspace.upload_button.isEnabled()
        assert workspace.cancel_button.isEnabled() is False
        workspace.upload_thread = QThread(workspace)
        workspace._upload_completed({"ok": True, "state": "staged"})
        assert not workspace.encode_button.isEnabled()
        assert not workspace.play_button.isEnabled()
        workspace._upload_finished()
        assert workspace.encode_button.isEnabled()
        assert workspace.play_button.isEnabled()
    finally:
        workspace.close()


def test_video_workspace_controls_playback_in_background(
    qt_app: QApplication,
) -> None:
    class ControlTarget:
        def __init__(self) -> None:
            self.calls: list[tuple[str, int | None]] = []

        def upload_s2v(self, path: Path, *, progress=None):  # type: ignore[no-untyped-def]
            return {"ok": True, "state": "staged"}

        def start_video(self):  # type: ignore[no-untyped-def]
            self.calls.append(("play", None))
            return {"snapshot": {"state": "running"}}

        def pause_video(self):  # type: ignore[no-untyped-def]
            self.calls.append(("pause", None))
            return {"snapshot": {"state": "paused"}}

        def seek_video(self, frame_index: int):  # type: ignore[no-untyped-def]
            self.calls.append(("seek", frame_index))
            return {"snapshot": {"state": "paused"}}

        def stop_video(self):  # type: ignore[no-untyped-def]
            self.calls.append(("stop", None))
            return {"snapshot": {"state": "active"}}

    target = ControlTarget()
    workspace = VideoWorkspace(target)
    workspace.show()
    try:
        workspace._video_frame_count = 3
        workspace._playback_state = "staged"
        workspace.seek_slider.setRange(0, 2)
        workspace._set_playback_controls_enabled(True)

        workspace.start_control("play")
        assert not workspace.encode_button.isEnabled()
        assert not workspace.upload_button.isEnabled()
        _process_until(qt_app, lambda: not workspace.is_controlling)
        assert workspace.pause_button.isEnabled()
        assert workspace.encode_button.isEnabled()
        assert "最近命令快照" in workspace.playback_readout.text()
        assert "running" in workspace.playback_readout.text()

        workspace.start_control("pause")
        _process_until(qt_app, lambda: not workspace.is_controlling)
        workspace.seek_slider.setValue(2)
        workspace.seek_selected()
        _process_until(qt_app, lambda: not workspace.is_controlling)

        workspace.start_control("stop")
        _process_until(qt_app, lambda: not workspace.is_controlling)
        assert target.calls == [
            ("play", None),
            ("pause", None),
            ("seek", 2),
            ("stop", None),
        ]
        workspace.refresh_device_state(False)
        assert "历史命令快照" in workspace.playback_readout.text()
        assert not workspace.play_button.isEnabled()
        workspace.refresh_device_state(True)
        assert "历史命令快照" in workspace.playback_readout.text()
    finally:
        workspace.close()


def _process_until(
    app: QApplication,
    predicate,
    *,
    timeout_ms: int = 3000,
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