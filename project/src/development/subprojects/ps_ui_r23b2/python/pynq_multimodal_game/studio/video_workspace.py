from __future__ import annotations

import threading
import zipfile
from pathlib import Path
from typing import Any, Callable, Protocol, runtime_checkable

from PySide6.QtCore import QEvent, QObject, Qt, QThread, Signal, Slot
from PySide6.QtGui import QImage, QPixmap
from PySide6.QtWidgets import (
    QFileDialog,
    QComboBox,
    QFrame,
    QHBoxLayout,
    QLabel,
    QProgressBar,
    QPushButton,
    QScrollArea,
    QSizePolicy,
    QSlider,
    QSplitter,
    QStyle,
    QToolButton,
    QVBoxLayout,
    QWidget,
)

from ..video_codec import S2V1Reader, decode_video_frames, encode_rgb_frames
from .device import DeviceState
from .workspaces import rgb_to_qimage


class VideoUploadTarget(Protocol):
    def upload_s2v(
        self,
        path: Path,
        *,
        progress: Callable[[int, int], None] | None = None,
    ) -> dict[str, Any]: ...


@runtime_checkable
class VideoLibraryTarget(VideoUploadTarget, Protocol):
    def install_s2v(
        self,
        path: Path,
        *,
        progress: Callable[[int, int], None] | None = None,
    ) -> dict[str, Any]: ...


@runtime_checkable
class VideoControlTarget(VideoUploadTarget, Protocol):
    def start_video(self) -> dict[str, Any]: ...

    def pause_video(self) -> dict[str, Any]: ...

    def seek_video(self, frame_index: int) -> dict[str, Any]: ...

    def stop_video(self) -> dict[str, Any]: ...


class VideoEncodeWorker(QObject):
    completed = Signal(object, object)
    failed = Signal(str)
    finished = Signal()

    def __init__(
        self,
        source: Path,
        output: Path,
        *,
        max_frames: int | None,
        quality_profile: str,
    ) -> None:
        super().__init__()
        self.source = source
        self.output = output
        self.max_frames = max_frames
        self.quality_profile = quality_profile
        self._stopping = threading.Event()

    @Slot()
    def run(self) -> None:
        try:
            def frames():  # type: ignore[no-untyped-def]
                for frame in decode_video_frames(self.source, max_frames=self.max_frames):
                    if self._stopping.is_set():
                        raise RuntimeError("encoding cancelled")
                    yield frame

            summary = encode_rgb_frames(
                frames(),
                self.output,
                quality_profile=self.quality_profile,
            )
            if self._stopping.is_set():
                raise RuntimeError("encoding cancelled")
            with S2V1Reader(self.output) as reader:
                preview = next(reader.iter_frames()).rgb
            self.completed.emit(summary, preview)
        except Exception as error:
            self.failed.emit(str(error))
        finally:
            self.finished.emit()

    def stop(self) -> None:
        self._stopping.set()


class VideoUploadWorker(QObject):
    completed = Signal(object)
    progress_changed = Signal(int)
    failed = Signal(str)
    finished = Signal()

    def __init__(
        self,
        target: VideoUploadTarget,
        path: Path,
    ) -> None:
        super().__init__()
        self.target = target
        self.path = path
        self._stopping = threading.Event()

    @Slot()
    def run(self) -> None:
        try:
            if isinstance(self.target, VideoLibraryTarget):
                result = self.target.install_s2v(
                    self.path, progress=self._report_progress
                )
            else:
                result = self.target.upload_s2v(
                    self.path, progress=self._report_progress
                )
            if self._stopping.is_set():
                raise RuntimeError("upload paused")
            self.completed.emit(result)
        except Exception as error:
            self.failed.emit(str(error))
        finally:
            self.finished.emit()

    def stop(self) -> None:
        self._stopping.set()

    def _report_progress(self, received: int, total: int) -> None:
        if self._stopping.is_set():
            raise RuntimeError("upload paused")
        percent = 100 if total == 0 else round(received * 100 / total)
        self.progress_changed.emit(percent)


class VideoControlWorker(QObject):
    completed = Signal(object, str)
    failed = Signal(str)
    finished = Signal()

    def __init__(
        self,
        target: VideoControlTarget,
        action: str,
        *,
        frame_index: int | None = None,
    ) -> None:
        super().__init__()
        self.target = target
        self.action = action
        self.frame_index = frame_index

    @Slot()
    def run(self) -> None:
        try:
            if self.action == "play":
                result = self.target.start_video()
            elif self.action == "pause":
                result = self.target.pause_video()
            elif self.action == "seek":
                assert self.frame_index is not None
                result = self.target.seek_video(self.frame_index)
            elif self.action == "stop":
                result = self.target.stop_video()
            else:
                raise ValueError(f"unsupported video control action {self.action!r}")
            self.completed.emit(result, self.action)
        except Exception as error:
            self.failed.emit(str(error))
        finally:
            self.finished.emit()


class VideoWorkspace(QWidget):
    log_requested = Signal(str)
    activity_changed = Signal(str, str, str, object)

    def __init__(self, upload_target: VideoUploadTarget | None = None) -> None:
        super().__init__()
        self.upload_target = upload_target
        self.source_path: Path | None = None
        self.output_path: Path | None = None
        self.encode_thread: QThread | None = None
        self.encode_worker: VideoEncodeWorker | None = None
        self.upload_thread: QThread | None = None
        self.upload_worker: VideoUploadWorker | None = None
        self.control_thread: QThread | None = None
        self.control_worker: VideoControlWorker | None = None
        self.last_summary = None
        self._preview_image: QImage | None = None
        self._video_frame_count = 0
        self._playback_state = "idle"
        self._last_control_snapshot: dict[str, Any] = {}
        target_snapshot = getattr(upload_target, "snapshot", None)
        self._target_connected = upload_target is not None and (
            target_snapshot is None or target_snapshot.state is DeviceState.READY
        )

        root = QVBoxLayout(self)
        root.setContentsMargins(12, 10, 12, 10)
        root.setSpacing(8)
        heading = QLabel("PYNQ 视频控制")
        heading.setObjectName("sectionLabel")
        root.addWidget(heading)

        body = QSplitter(Qt.Orientation.Horizontal)
        body.setChildrenCollapsible(False)
        viewport = QFrame()
        viewport.setObjectName("viewportPanel")
        viewport_layout = QVBoxLayout(viewport)
        viewport_layout.setContentsMargins(12, 12, 12, 12)
        preview_label = QLabel("PC 参考预览 / S2V1 解码")
        preview_label.setObjectName("mutedLabel")
        viewport_layout.addWidget(preview_label)
        self.preview = QLabel("尚无 PC 预览")
        self.preview.setObjectName("gameViewport")
        self.preview.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.preview.setSizePolicy(QSizePolicy.Policy.Ignored, QSizePolicy.Policy.Ignored)
        self.preview.installEventFilter(self)
        viewport_layout.addWidget(self.preview, 1)
        viewport.setMinimumWidth(320)
        body.addWidget(viewport)

        inspector = QFrame()
        inspector.setObjectName("inspectorPanel")
        inspector.setMinimumWidth(300)
        inspector_layout = QVBoxLayout(inspector)
        inspector_layout.setContentsMargins(12, 12, 12, 12)
        inspector_layout.setSpacing(8)
        inspector_layout.addWidget(self._label("本地素材准备"))

        source_row = QHBoxLayout()
        self.source_value = QLabel("No source")
        self.source_value.setObjectName("mutedLabel")
        self.source_value.setSizePolicy(QSizePolicy.Policy.Ignored, QSizePolicy.Policy.Preferred)
        source_row.addWidget(self.source_value, 1)
        source_button = QToolButton()
        source_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_DialogOpenButton))
        source_button.setToolTip("Select source video")
        source_button.clicked.connect(self.select_source)
        source_row.addWidget(source_button)
        inspector_layout.addWidget(self._label("源视频"))
        inspector_layout.addLayout(source_row)

        output_row = QHBoxLayout()
        self.output_value = QLabel("No output")
        self.output_value.setObjectName("mutedLabel")
        self.output_value.setSizePolicy(QSizePolicy.Policy.Ignored, QSizePolicy.Policy.Preferred)
        output_row.addWidget(self.output_value, 1)
        output_button = QToolButton()
        output_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_DialogSaveButton))
        output_button.setToolTip("Select S2V1 output")
        output_button.clicked.connect(self.select_output)
        output_row.addWidget(output_button)
        inspector_layout.addWidget(self._label("S2V1 文件"))
        inspector_layout.addLayout(output_row)

        inspector_layout.addWidget(self._label("编码质量"))
        self.quality_profile = QComboBox()
        self.quality_profile.addItem("Spatial resident", "spatial-resident")
        self.quality_profile.addItem("Stable palette", "stable")
        self.quality_profile.addItem("Spatial quality", "spatial")
        self.quality_profile.addItem("Spatial shared", "spatial-shared")
        self.quality_profile.addItem("Legacy", "legacy")
        inspector_layout.addWidget(self.quality_profile)

        inspector_layout.addWidget(self._label("任务反馈"))
        self.progress = QProgressBar()
        self.progress.setRange(0, 100)
        self.progress.setValue(0)
        self.progress.setTextVisible(False)
        inspector_layout.addWidget(self.progress)
        self.status_value = QLabel("Idle")
        self.status_value.setObjectName("mutedLabel")
        self.status_value.setWordWrap(True)
        self.status_value.setTextFormat(Qt.TextFormat.PlainText)
        inspector_layout.addWidget(self.status_value)
        self.frames_value = QLabel("--")
        self.frames_value.setObjectName("metricValue")
        inspector_layout.addWidget(self.frames_value)

        controls = QHBoxLayout()
        self.encode_button = QPushButton("编码 S2V1")
        self.encode_button.clicked.connect(self.encode_selected)
        controls.addWidget(self.encode_button)
        self.upload_button = QPushButton("上传到 PYNQ")
        self.upload_button.setObjectName("primaryAction")
        self.upload_button.setEnabled(False)
        self.upload_button.clicked.connect(self.upload_selected)
        self.cancel_button = QToolButton()
        self.cancel_button.setIcon(
            self.style().standardIcon(QStyle.StandardPixmap.SP_DialogCancelButton)
        )
        self.cancel_button.setToolTip("取消编码或暂停上传")
        self.cancel_button.setEnabled(False)
        self.cancel_button.clicked.connect(lambda: self.stop(wait=False))
        controls.addWidget(self.cancel_button)
        inspector_layout.addLayout(controls)

        playback = QHBoxLayout()
        self.play_button = QToolButton()
        self.play_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaPlay))
        self.play_button.setToolTip("Play or resume video on PYNQ")
        self.play_button.clicked.connect(lambda: self.start_control("play"))
        playback.addWidget(self.play_button)
        self.pause_button = QToolButton()
        self.pause_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaPause))
        self.pause_button.setToolTip("Pause video on PYNQ")
        self.pause_button.clicked.connect(lambda: self.start_control("pause"))
        playback.addWidget(self.pause_button)
        self.stop_button = QToolButton()
        self.stop_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaStop))
        self.stop_button.setToolTip("Stop video on PYNQ")
        self.stop_button.clicked.connect(lambda: self.start_control("stop"))
        playback.addWidget(self.stop_button)
        self.seek_slider = QSlider(Qt.Orientation.Horizontal)
        self.seek_slider.setRange(0, 0)
        self.seek_slider.setToolTip("Seek video frame on PYNQ")
        self.seek_slider.sliderReleased.connect(self.seek_selected)
        playback.addWidget(self.seek_slider, 1)
        inspector_layout.insertWidget(0, self._label("板端上传与播放"))
        inspector_layout.insertWidget(1, self.upload_button)
        inspector_layout.insertLayout(2, playback)
        self.playback_readout = QLabel("PYNQ / 尚无命令回读")
        self.playback_readout.setObjectName("mutedLabel")
        self.playback_readout.setTextFormat(Qt.TextFormat.PlainText)
        self.playback_readout.setWordWrap(True)
        inspector_layout.insertWidget(3, self.playback_readout)
        for button in (self.play_button, self.pause_button, self.stop_button, self.cancel_button):
            button.setFixedSize(32, 32)
        self._set_playback_controls_enabled(False)
        inspector_layout.addStretch()
        scroll = QScrollArea()
        scroll.setWidgetResizable(True)
        scroll.setWidget(inspector)
        scroll.setMinimumWidth(320)
        body.addWidget(scroll)
        body.setSizes((760, 360))
        body.setStretchFactor(0, 1)
        root.addWidget(body, 1)

    @staticmethod
    def _label(text: str) -> QLabel:
        label = QLabel(text)
        label.setObjectName("metricName")
        return label

    @property
    def is_running(self) -> bool:
        return self.encode_thread is not None and self.encode_thread.isRunning()

    @property
    def is_uploading(self) -> bool:
        return self.upload_thread is not None and self.upload_thread.isRunning()

    @property
    def is_controlling(self) -> bool:
        return self.control_thread is not None and self.control_thread.isRunning()

    @property
    def is_busy(self) -> bool:
        return any(thread is not None for thread in (
            self.encode_thread, self.upload_thread, self.control_thread
        ))

    def _refresh_control_states(self) -> None:
        self.encode_button.setEnabled(not self.is_busy)
        self.upload_button.setEnabled(
            not self.is_busy and self._target_connected and self.output_path is not None
        )
        self.cancel_button.setEnabled(
            self.encode_thread is not None or self.upload_thread is not None
        )
        self._set_playback_controls_enabled(not self.is_busy and self._playback_state != "idle")

    def set_upload_target(self, target: VideoUploadTarget | None) -> None:
        if self.is_uploading or self.is_controlling:
            raise RuntimeError("cannot replace the PYNQ device while video I/O is active")
        self.upload_target = target
        self._last_control_snapshot = {}
        self._playback_state = "idle"
        self.playback_readout.setText("PYNQ / 尚无命令回读")
        target_snapshot = getattr(target, "snapshot", None)
        self.refresh_device_state(target is not None and (
            target_snapshot is None or target_snapshot.state is DeviceState.READY
        ))

    def refresh_device_state(self, connected: bool) -> None:
        self._target_connected = connected
        if not connected and self._last_control_snapshot:
            self.playback_readout.setText("PYNQ / 历史命令快照 / 等待重新回读")
        self._refresh_control_states()

    def select_source(self) -> None:
        selected, _ = QFileDialog.getOpenFileName(
            self,
            "Select source video",
            "",
            "Video files (*.mp4 *.mov *.mkv *.avi);;All files (*)",
        )
        if selected:
            self.source_path = Path(selected)
            self.source_value.setText(self.source_path.name)
            self.source_value.setToolTip(str(self.source_path))
            if self.output_path is None:
                self.output_path = self.source_path.with_suffix(".s2v")
                self.output_value.setText(self.output_path.name)
                self.output_value.setToolTip(str(self.output_path))

    def select_output(self) -> None:
        selected, _ = QFileDialog.getSaveFileName(
            self, "Select S2V1 output", "", "S2V1 video (*.s2v)"
        )
        if selected:
            self.output_path = Path(selected).with_suffix(".s2v")
            self.output_value.setText(self.output_path.name)
            self.output_value.setToolTip(str(self.output_path))

    def encode_selected(self) -> None:
        if self.source_path is None or self.output_path is None:
            self.status_value.setText("Select source and output")
            return
        self.start_encoding(
            self.source_path,
            self.output_path,
            quality_profile=str(self.quality_profile.currentData()),
        )

    def start_encoding(
        self,
        source: Path,
        output: Path,
        *,
        max_frames: int | None = None,
        quality_profile: str = "spatial-resident",
    ) -> None:
        if self.is_busy:
            raise RuntimeError("video workspace is already busy")
        self.source_path = Path(source)
        self.output_path = Path(output)
        self.last_summary = None
        self.source_value.setText(self.source_path.name)
        self.output_value.setText(self.output_path.name)
        self.source_value.setToolTip(str(self.source_path))
        self.output_value.setToolTip(str(self.output_path))
        self.status_value.setText("Encoding")
        self.progress.setRange(0, 0)
        self.encode_button.setEnabled(False)
        self.upload_button.setEnabled(False)
        self.cancel_button.setEnabled(True)
        self.activity_changed.emit("Video / PC", "编码已开始", "waiting", None)

        thread = QThread(self)
        worker = VideoEncodeWorker(
            self.source_path,
            self.output_path,
            max_frames=max_frames,
            quality_profile=quality_profile,
        )
        worker.moveToThread(thread)
        thread.started.connect(worker.run)
        worker.completed.connect(self._encoding_completed)
        worker.failed.connect(self._encoding_failed)
        worker.finished.connect(thread.quit)
        worker.finished.connect(worker.deleteLater)
        thread.finished.connect(self._encoding_finished)
        self.encode_thread = thread
        self.encode_worker = worker
        self._refresh_control_states()
        thread.start()

    def stop(self, *, wait: bool = True) -> None:
        worker = self.encode_worker
        thread = self.encode_thread
        if worker is not None:
            worker.stop()
        if wait and thread is not None and thread.isRunning():
            thread.quit()
            thread.wait(5000)
        upload_worker = self.upload_worker
        upload_thread = self.upload_thread
        if upload_worker is not None:
            upload_worker.stop()
        if wait and upload_thread is not None and upload_thread.isRunning():
            upload_thread.quit()
            upload_thread.wait(5000)
        control_thread = self.control_thread
        if wait and control_thread is not None and control_thread.isRunning():
            control_thread.quit()
            control_thread.wait(5000)

    def upload_selected(self) -> None:
        if self.output_path is None or not self.output_path.is_file():
            self.status_value.setText("Encode or select an S2V1 file")
            return
        self.start_upload(self.output_path)

    def start_upload(self, path: Path) -> None:
        if self.upload_target is None:
            raise RuntimeError("video upload requires a remote PYNQ Agent")
        if self.is_busy:
            raise RuntimeError("video workspace is already busy")
        source = Path(path)
        if not source.is_file():
            raise FileNotFoundError(source)
        self.output_path = source
        self.status_value.setText("Uploading")
        self.output_value.setText(source.name)
        self.output_value.setToolTip(str(source))
        self.activity_changed.emit("Video / PYNQ", "上传已开始", "waiting", None)
        self.progress.setRange(0, 100)
        self.progress.setValue(0)
        self.encode_button.setEnabled(False)
        self.upload_button.setEnabled(False)
        self.cancel_button.setEnabled(True)

        thread = QThread(self)
        worker = VideoUploadWorker(
            self.upload_target,
            source,
        )
        worker.moveToThread(thread)
        thread.started.connect(worker.run)
        worker.progress_changed.connect(self._upload_progress)
        worker.completed.connect(self._upload_completed)
        worker.failed.connect(self._upload_failed)
        worker.finished.connect(thread.quit)
        worker.finished.connect(worker.deleteLater)
        thread.finished.connect(self._upload_finished)
        self.upload_thread = thread
        self.upload_worker = worker
        self._refresh_control_states()
        thread.start()

    @Slot(object, object)
    def _encoding_completed(self, summary: object, preview_rgb: object) -> None:
        self.last_summary = summary
        frame_count = getattr(summary, "frame_count", 0)
        total_bytes = getattr(summary, "total_bytes", 0)
        bitrate = getattr(summary, "average_bitrate_bps", 0)
        self.frames_value.setText(f"{frame_count} frames")
        self._video_frame_count = frame_count
        self.seek_slider.setRange(0, max(frame_count - 1, 0))
        self.status_value.setText(f"{total_bytes:,} B / {bitrate / 1_000_000:.2f} Mb/s")
        if isinstance(preview_rgb, bytes):
            self._preview_image = rgb_to_qimage(preview_rgb)
            self.preview.setText("")
            self._render_preview()
        self.log_requested.emit(f"S2V1 encoded {frame_count} frames")
        self.activity_changed.emit("Video / PC", f"编码完成 / {frame_count} 帧", "success", None)

    @Slot(str)
    def _encoding_failed(self, message: str) -> None:
        self.status_value.setText(message)
        self.log_requested.emit(f"S2V1 encode failed: {message}")
        self.activity_changed.emit("Video / PC", message, "error", None)

    @Slot()
    def _encoding_finished(self) -> None:
        thread = self.encode_thread
        self.encode_worker = None
        self.encode_thread = None
        if thread is not None:
            thread.deleteLater()
        self.progress.setRange(0, 100)
        self.progress.setValue(100 if self.last_summary is not None else 0)
        self._refresh_control_states()

    @Slot(int)
    def _upload_progress(self, percent: int) -> None:
        self.progress.setValue(percent)
        self.activity_changed.emit("Video / PYNQ", f"上传 {percent}%", "waiting", None)

    @Slot(object)
    def _upload_completed(self, result: object) -> None:
        self.progress.setValue(100)
        installed = (
            isinstance(result, dict) and result.get("library_items") is not None
        )
        self.status_value.setText(
            "Installed in PYNQ library" if installed else "Staged on PYNQ Agent"
        )
        if self.output_path is not None:
            try:
                with S2V1Reader(self.output_path) as reader:
                    self._video_frame_count = reader.frame_count
            except (OSError, ValueError, zipfile.BadZipFile):
                self._video_frame_count = 0
            self.seek_slider.setRange(0, max(self._video_frame_count - 1, 0))
        self._playback_state = "staged"
        self._refresh_control_states()
        self.log_requested.emit(
            "S2V1 installed in PYNQ library"
            if installed
            else "S2V1 upload staged on PYNQ Agent"
        )
        self.activity_changed.emit("Video / PYNQ", self.status_value.text(), "success", None)

    @Slot(str)
    def _upload_failed(self, message: str) -> None:
        self.status_value.setText(message)
        self.log_requested.emit(f"S2V1 upload paused or failed: {message}")
        self.activity_changed.emit("Video / PYNQ", message, "error", None)

    @Slot()
    def _upload_finished(self) -> None:
        thread = self.upload_thread
        self.upload_worker = None
        self.upload_thread = None
        if thread is not None:
            thread.deleteLater()
        self._refresh_control_states()

    def seek_selected(self) -> None:
        if self._video_frame_count > 0:
            self.start_control("seek", frame_index=self.seek_slider.value())

    def start_control(self, action: str, *, frame_index: int | None = None) -> None:
        target = self.upload_target
        if not isinstance(target, VideoControlTarget):
            raise RuntimeError("video controls require a remote PYNQ Agent")
        if self.is_busy:
            raise RuntimeError("video workspace is already busy")
        self._set_playback_controls_enabled(False)
        self.status_value.setText(f"{action.title()} requested")
        self.activity_changed.emit("Video / PYNQ", f"{action} 已提交", "waiting", None)
        thread = QThread(self)
        worker = VideoControlWorker(target, action, frame_index=frame_index)
        worker.moveToThread(thread)
        thread.started.connect(worker.run)
        worker.completed.connect(self._control_completed)
        worker.failed.connect(self._control_failed)
        worker.finished.connect(thread.quit)
        worker.finished.connect(worker.deleteLater)
        thread.finished.connect(self._control_finished)
        self.control_thread = thread
        self.control_worker = worker
        self._refresh_control_states()
        thread.start()

    @Slot(object, str)
    def _control_completed(self, result: object, action: str) -> None:
        snapshot = result.get("snapshot") if isinstance(result, dict) else None
        state = snapshot.get("state") if isinstance(snapshot, dict) else None
        if isinstance(state, str):
            self._last_control_snapshot = dict(snapshot)
            self._playback_state = state
            frame_index = snapshot.get("frame_index") if isinstance(snapshot, dict) else None
            frame_count = snapshot.get("frame_count") if isinstance(snapshot, dict) else None
            if type(frame_index) is int and type(frame_count) is int:
                self.seek_slider.setValue(frame_index)
                self.status_value.setText(
                    f"PYNQ video {state}: {frame_index + 1}/{frame_count}"
                )
            else:
                self.status_value.setText(f"PYNQ video {state}")
            self.playback_readout.setText(f"最近命令快照 / {self.status_value.text()}")
        else:
            self.status_value.setText(f"PYNQ video {action} complete")
        self.log_requested.emit(f"S2V1 PYNQ video {action} complete")
        self.activity_changed.emit("Video / PYNQ", f"{action} 完成", "success", snapshot)

    @Slot(str)
    def _control_failed(self, message: str) -> None:
        self.status_value.setText(message)
        self.log_requested.emit(f"S2V1 PYNQ video control failed: {message}")
        self.activity_changed.emit("Video / PYNQ", message, "error", None)

    @Slot()
    def _control_finished(self) -> None:
        thread = self.control_thread
        self.control_worker = None
        self.control_thread = None
        if thread is not None:
            thread.deleteLater()
        self._refresh_control_states()

    def _set_playback_controls_enabled(self, enabled: bool) -> None:
        active = enabled and self.upload_target is not None and self._target_connected
        self.play_button.setEnabled(active and self._playback_state != "running")
        self.pause_button.setEnabled(active and self._playback_state == "running")
        self.stop_button.setEnabled(active and self._playback_state in ("running", "paused"))
        self.seek_slider.setEnabled(active and self._video_frame_count > 0)

    def resizeEvent(self, event) -> None:  # type: ignore[no-untyped-def]
        super().resizeEvent(event)
        self._render_preview()

    def eventFilter(self, watched: QObject, event: QEvent) -> bool:
        if watched is self.preview and event.type() is QEvent.Type.Resize:
            self._render_preview()
        return super().eventFilter(watched, event)

    def _render_preview(self) -> None:
        if self._preview_image is not None:
            self.preview.setPixmap(
                QPixmap.fromImage(self._preview_image).scaled(
                    self.preview.size(),
                    Qt.AspectRatioMode.KeepAspectRatio,
                    Qt.TransformationMode.FastTransformation,
                )
            )