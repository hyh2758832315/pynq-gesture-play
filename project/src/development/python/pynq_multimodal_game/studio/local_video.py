"""Bounded, local video preview/testing; never creates a device session."""
from pathlib import Path
import threading
from time import monotonic

from PySide6.QtCore import QObject, QThread, QTimer, Qt, Signal, Slot
from PySide6.QtGui import QPixmap
from PySide6.QtWidgets import (
    QFileDialog, QHBoxLayout, QLabel, QListWidget, QListWidgetItem,
    QPushButton, QSizePolicy, QSplitter, QVBoxLayout, QWidget,
)

from ..video_codec import S2V1Reader, S2V1_FPS, decode_video_frames
from .workspaces import rgb_to_qimage


def local_frames(path):
    if Path(path).suffix.lower() == ".s2v":
        with S2V1Reader(path) as reader:
            for frame in reader.iter_frames():
                yield frame.rgb
    else:
        yield from decode_video_frames(path)


class LocalVideoWorker(QObject):
    completed = Signal(object)
    failed = Signal(str)
    finished = Signal()

    def __init__(self, path, *, testing=False):
        super().__init__()
        self.path = Path(path)
        self.testing = testing
        self.stopping = threading.Event()
        self.paused = threading.Event()
        self._lock = threading.Lock()
        self._latest = None

    def take_latest(self):
        with self._lock:
            value, self._latest = self._latest, None
            return value

    def stop(self):
        self.stopping.set()

    @Slot()
    def run(self):
        frames = local_frames(self.path)
        count = 0
        try:
            deadline = monotonic()
            for rgb in frames:
                if self.stopping.is_set():
                    return
                while self.paused.is_set():
                    if self.stopping.wait(0.03):
                        return
                    deadline = monotonic()
                if len(rgb) != 320 * 180 * 3:
                    raise ValueError("视频帧尺寸无效")
                count += 1
                with self._lock:
                    self._latest = (rgb, count)
                if not self.testing:
                    deadline = max(deadline + 1 / S2V1_FPS, monotonic())
                    if self.stopping.wait(max(0, deadline - monotonic())):
                        return
            if not count:
                raise ValueError("视频没有可解码帧")
            self.completed.emit({"path": str(self.path), "frames": count,
                                 "tested": self.testing})
        except Exception as error:
            self.failed.emit(str(error))
        finally:
            frames.close()
            self.finished.emit()


class LocalVideoWorkspace(QWidget):
    log_requested = Signal(str)
    activity_changed = Signal(str, str, str, object)
    sources_changed = Signal()

    def __init__(self):
        super().__init__()
        self.before_run = lambda: True
        self.thread = None
        self.worker = None
        self._image = None
        self.last_result = None
        root = QVBoxLayout(self)
        heading = QLabel("视频素材 · PC 预览与测试")
        heading.setObjectName("sectionLabel")
        root.addWidget(heading)
        split = QSplitter()
        library = QWidget()
        left = QVBoxLayout(library)
        self.library = QListWidget()
        self.library.currentRowChanged.connect(self._selection_changed)
        left.addWidget(self.library, 1)
        self.add_button = QPushButton("添加视频")
        self.add_button.clicked.connect(self.select_sources)
        self.remove_button = QPushButton("移除素材")
        self.remove_button.clicked.connect(self.remove_selected)
        left.addWidget(self.add_button)
        left.addWidget(self.remove_button)
        split.addWidget(library)
        content = QWidget()
        right = QVBoxLayout(content)
        self.preview = QLabel("添加视频后可在 PC 预览与测试")
        self.preview.setObjectName("gameViewport")
        self.preview.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.preview.setMinimumSize(320, 180)
        self.preview.setSizePolicy(QSizePolicy.Policy.Ignored, QSizePolicy.Policy.Expanding)
        right.addWidget(self.preview, 1)
        buttons = QHBoxLayout()
        self.play_button = QPushButton("PC 预览")
        self.play_button.clicked.connect(self.play)
        self.pause_button = QPushButton("暂停")
        self.pause_button.clicked.connect(self.pause)
        self.stop_button = QPushButton("停止")
        self.stop_button.clicked.connect(lambda: self.stop(wait=False))
        self.test_button = QPushButton("测试整段视频")
        self.test_button.clicked.connect(lambda: self.start(testing=True))
        for button in (self.play_button, self.pause_button, self.stop_button, self.test_button):
            buttons.addWidget(button)
        right.addLayout(buttons)
        self.status_value = QLabel("尚未选择视频")
        self.status_value.setWordWrap(True)
        self.status_value.setTextFormat(Qt.TextFormat.PlainText)
        right.addWidget(self.status_value)
        note = QLabel("预览源视频画面；测试检查整段解码。加载时统一转换、校验并安装到 PYNQ。")
        note.setWordWrap(True)
        note.setObjectName("mutedLabel")
        right.addWidget(note)
        split.addWidget(content)
        split.setSizes((240, 900))
        split.setStretchFactor(1, 1)
        root.addWidget(split, 1)
        self.timer = QTimer(self)
        self.timer.setInterval(33)
        self.timer.timeout.connect(self._flush)
        self._refresh()

    @property
    def is_busy(self):
        return self.thread is not None

    @property
    def source_paths(self):
        return tuple(Path(self.library.item(i).data(Qt.ItemDataRole.UserRole))
                     for i in range(self.library.count()))

    def select_sources(self):
        paths, _ = QFileDialog.getOpenFileNames(
            self, "添加视频素材", "", "视频 (*.mp4 *.mov *.mkv *.avi *.webm *.s2v);;所有文件 (*)")
        self.add_sources(paths)

    def add_sources(self, paths):
        if self.is_busy:
            raise RuntimeError("请先停止视频预览或测试")
        existing = set(self.source_paths)
        for path in paths:
            path = Path(path).resolve()
            if path in existing:
                continue
            from .default_content import video_title
            item = QListWidgetItem(video_title(path))
            item.setData(Qt.ItemDataRole.UserRole, str(path))
            item.setToolTip(str(path))
            self.library.addItem(item)
            existing.add(path)
        if self.library.currentRow() < 0 and self.library.count():
            self.library.setCurrentRow(0)
        self.sources_changed.emit()
        self._refresh()

    def remove_selected(self):
        if not self.is_busy:
            self.library.takeItem(self.library.currentRow())
            self.sources_changed.emit()
            self._refresh()

    def _selection_changed(self):
        self.last_result = None
        self._image = None
        self.preview.clear()
        self.preview.setText("点击 PC 预览")
        item = self.library.currentItem()
        self.status_value.setText(item.toolTip() if item else "尚未选择视频")
        self._refresh()

    def play(self):
        if self.worker and self.worker.paused.is_set():
            self.worker.paused.clear()
            self.status_value.setText("PC 预览中")
            self._refresh()
        elif not self.is_busy:
            self.start()

    def pause(self):
        if self.worker:
            self.worker.paused.set()
            self.status_value.setText("PC 预览已暂停")
            self._refresh()

    def start(self, *, testing=False):
        item = self.library.currentItem()
        if self.is_busy or item is None or not self.before_run():
            return
        self.last_result = None
        thread = QThread(self)
        worker = LocalVideoWorker(item.data(Qt.ItemDataRole.UserRole), testing=testing)
        worker.moveToThread(thread)
        thread.started.connect(worker.run)
        worker.completed.connect(self._completed)
        worker.failed.connect(self._failed)
        worker.finished.connect(worker.deleteLater)
        worker.finished.connect(thread.quit, Qt.ConnectionType.DirectConnection)
        thread.finished.connect(self._finished)
        self.thread, self.worker = thread, worker
        self.status_value.setText("正在完整解码测试…" if testing else "PC 预览中")
        self.activity_changed.emit("Video / PC", self.status_value.text(), "waiting", None)
        self.timer.start()
        thread.start()
        self._refresh()

    def _flush(self):
        latest = self.worker.take_latest() if self.worker else None
        if latest:
            rgb, count = latest
            self._image = rgb_to_qimage(rgb)
            self._render()

    def _render(self):
        if self._image is not None:
            self.preview.setPixmap(QPixmap.fromImage(self._image).scaled(
                self.preview.size(), Qt.AspectRatioMode.KeepAspectRatio,
                Qt.TransformationMode.FastTransformation))

    def _completed(self, result):
        self.last_result = result
        text = f"{'整段解码测试通过' if result['tested'] else '预览完成'} · {result['frames']} 帧"
        self.status_value.setText(text)
        self.activity_changed.emit("Video / PC", text, "success", None)

    def _failed(self, message):
        self.status_value.setText(f"视频失败：{message}")
        self.log_requested.emit(self.status_value.text())
        self.activity_changed.emit("Video / PC", message, "error", None)

    def _finished(self):
        if isinstance(self.sender(), QThread) and self.sender() is not self.thread:
            return
        self._flush()
        self.timer.stop()
        thread, worker = self.thread, self.worker
        self.thread = self.worker = None
        if self.status_value.text() == "正在停止…":
            self.status_value.setText("PC 视频已停止")
        if thread:
            thread.deleteLater()
        self._refresh()

    def stop(self, *, wait=True):
        if self.worker:
            self.worker.stop()
            self.status_value.setText("正在停止…")
        if wait and self.thread:
            if not self.thread.wait(3000):
                return False
            self._finished()
        self._refresh()
        return not self.is_busy

    def _refresh(self):
        selected = self.library.currentItem() is not None
        paused = self.worker is not None and self.worker.paused.is_set()
        self.play_button.setText("继续预览" if paused else "PC 预览")
        self.play_button.setEnabled(selected and (not self.is_busy or paused))
        self.pause_button.setEnabled(self.is_busy and not paused and not self.worker.testing)
        self.stop_button.setEnabled(self.is_busy)
        self.test_button.setEnabled(selected and not self.is_busy)
        for widget in (self.library, self.add_button, self.remove_button):
            widget.setEnabled(not self.is_busy)

    def resizeEvent(self, event):
        super().resizeEvent(event)
        self._render()
