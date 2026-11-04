from __future__ import annotations

from datetime import datetime
from time import monotonic

from PySide6.QtCore import QSettings, QSize, Qt, QThread, QTimer
from PySide6.QtWidgets import (
    QComboBox,
    QDialog,
    QDialogButtonBox,
    QFormLayout,
    QFrame,
    QHBoxLayout,
    QLabel,
    QLineEdit,
    QListWidget,
    QListWidgetItem,
    QMainWindow,
    QPlainTextEdit,
    QPushButton,
    QSizePolicy,
    QSpinBox,
    QStackedWidget,
    QStyle,
    QToolButton,
    QVBoxLayout,
    QWidget,
)

from ..protocol import ProtocolFrame
from ..streaming import FIXTURE_AUDIO_SOURCE_ID, FIXTURE_VISION_SOURCE_ID
from .device import DeviceSnapshot, DeviceState, RemoteDeviceSession, SimulatedDeviceSession
from .authoring_game import AuthoringGameWorkspace
from .remote_io import AgentIoWorker
from .board_connection import probe_board, board_startup_message, board_startup_title
from .local_video import LocalVideoWorkspace
from .load_workspace import ContentLoadWorkspace
from .workspaces import AdapterWorkspace, CapabilityWorkspace, VisionWorkspace
from .branding import pynq_wordmark, studio_icon


class PynqConnectionDialog(QDialog):
    def __init__(
        self,
        host: str,
        port: int,
        source_address: str,
        parent: QWidget | None = None,
        *,
        expected_build_id: int = 0xC0060700,
    ) -> None:
        super().__init__(parent)
        self.setWindowTitle("PYNQ Agent 设置")
        layout = QFormLayout(self)
        self.host_input = QLineEdit(host)
        self.host_input.setPlaceholderText("例如 192.168.2.99")
        self.port_input = QSpinBox()
        self.port_input.setRange(1, 65535)
        self.port_input.setValue(port)
        self.source_address_input = QLineEdit(source_address)
        self.source_address_input.setPlaceholderText("例如 192.168.2.1；留空则自动选择")
        layout.addRow("主机", self.host_input)
        layout.addRow("端口", self.port_input)
        layout.addRow("源地址", self.source_address_input)
        self.platform_input = QComboBox()
        self.platform_input.addItem("C6I / 0xC0060700", 0xC0060700)
        self.platform_input.addItem("C6I VISION / 0xC0060800", 0xC0060800)
        self.platform_input.addItem("历史平台 / 0xC0060900", 0xC0060900)
        self.platform_input.addItem("历史平台 / 0xC0060C00", 0xC0060C00)
        self.platform_input.addItem("手势按键 / 0xC0061000", 0xC0061000)
        index = self.platform_input.findData(expected_build_id)
        if index < 0:
            raise ValueError("Unsupported PYNQ platform BUILD_ID")
        self.platform_input.setCurrentIndex(index)
        layout.addRow("目标平台", self.platform_input)
        buttons = QDialogButtonBox(
            QDialogButtonBox.StandardButton.Save
            | QDialogButtonBox.StandardButton.Cancel
        )
        buttons.accepted.connect(self.accept)
        buttons.rejected.connect(self.reject)
        buttons.button(QDialogButtonBox.StandardButton.Save).setText("连接")
        layout.addRow(buttons)

    @property
    def expected_build_id(self) -> int:
        return self.platform_input.currentData()

    @property
    def connection(self) -> tuple[str, int, str | None]:
        source_address = self.source_address_input.text().strip()
        return (
            self.host_input.text().strip(),
            self.port_input.value(),
            source_address or None,
        )


class StudioMainWindow(QMainWindow):
    def __init__(
        self,
        *,
        agent_host: str | None = None,
        agent_port: int = 8765,
        agent_source_address: str | None = None,
        agent_build_id: int = 0xC0060700,
    ) -> None:
        super().__init__()
        self.setWindowTitle("PYNQ Studio")
        self.setWindowIcon(studio_icon())
        self.resize(1440, 900)
        self.setMinimumSize(1080, 700)
        self.remote_mode = agent_host is not None
        self.device = (
            RemoteDeviceSession(
                agent_host,
                agent_port,
                source_address=agent_source_address,
                expected_build_id=agent_build_id,
            )
            if agent_host is not None
            else SimulatedDeviceSession()
        )
        self.remote_thread: QThread | None = None
        self.remote_worker: AgentIoWorker | None = None
        self.settings = QSettings()
        self._display_snapshot = self.device.snapshot
        self._connection_pending = False
        self._board_info = None
        self._received_count = 0
        self._last_received_at: float | None = None
        self._last_received_source: int | None = None
        self._last_readout_at: float | None = None
        self._readout_current = False
        self._task_message = "任务 --"

        root = QWidget()
        root.setObjectName("studioRoot")
        root_layout = QVBoxLayout(root)
        root_layout.setContentsMargins(0, 0, 0, 0)
        root_layout.setSpacing(0)
        root_layout.addWidget(self._build_top_bar())

        center = QHBoxLayout()
        center.setContentsMargins(0, 0, 0, 0)
        center.setSpacing(0)
        self.navigation = QListWidget()
        self.navigation.setObjectName("workspaceNavigation")
        self.navigation.setFixedWidth(144)
        self.navigation.setIconSize(QSize(20, 20))
        center.addWidget(self.navigation)

        self.workspace_stack = QStackedWidget()
        center.addWidget(self.workspace_stack, 1)
        center_widget = QWidget()
        center_widget.setLayout(center)
        root_layout.addWidget(center_widget, 1)
        self.status_bar = self._build_status_bar()
        root_layout.addWidget(self.status_bar)
        self.setCentralWidget(root)

        camera_host = agent_host or str(self.settings.value("pynq/host", "192.168.2.99"))
        camera_port = 8081 if agent_build_id in (0xC0060800, 0xC0060900, 0xC0060C00, 0xC0061000) else 8088
        self.vision_workspace = VisionWorkspace(f"http://{camera_host}:{camera_port}/camera.mjpg")
        if agent_host:
            self.vision_workspace.set_vision_agent(agent_host, source_address=agent_source_address,
                expected_build_id=agent_build_id if agent_build_id in (0xC0060900, 0xC0060C00) else None)
            self.vision_workspace.vision_agent_port.setValue(agent_port if agent_build_id in (0xC0060800, 0xC0060900, 0xC0060C00, 0xC0061000) else 8766)
        self.vision_workspace.set_vision_control_available(agent_build_id != 0xC0061000)
        self.vision_workspace.camera_status_changed.connect(self._on_camera_status)
        self._add_workspace(
            "Vision",
            QStyle.StandardPixmap.SP_DesktopIcon,
            self.vision_workspace,
        )
        self.audio_workspace: AudioWorkspace | None = None
        if agent_build_id != 0xC0061000:
            from .audio_workspace import AudioWorkspace

            self.audio_workspace = AudioWorkspace(self.device)
            self._add_workspace(
                "Audio",
                QStyle.StandardPixmap.SP_MediaVolume,
                self.audio_workspace,
            )
        self.game_workspace = AuthoringGameWorkspace(build_id=agent_build_id)
        self.game_workspace.log_requested.connect(self.append_log)
        self.game_workspace.activity_changed.connect(self._on_workspace_feedback)
        self._add_workspace("Game", QStyle.StandardPixmap.SP_MediaPlay, self.game_workspace)
        self.video_workspace = LocalVideoWorkspace()
        from .default_content import initial_video_sources
        self.video_workspace.add_sources(initial_video_sources(self.settings))
        self.video_workspace.sources_changed.connect(lambda: self.settings.setValue(
            "content/videos", [str(path) for path in self.video_workspace.source_paths]))
        self.video_workspace.log_requested.connect(self.append_log)
        self.video_workspace.activity_changed.connect(self._on_workspace_feedback)
        self._add_workspace(
            "Video",
            QStyle.StandardPixmap.SP_FileDialogDetailedView,
            self.video_workspace,
        )
        self._add_workspace(
            "PL GPU",
            QStyle.StandardPixmap.SP_DriveHDIcon,
            CapabilityWorkspace(),
        )
        self.load_workspace = ContentLoadWorkspace(
            self.game_workspace, self.video_workspace,
            self.device if isinstance(self.device, RemoteDeviceSession) else None,settings=self.settings)
        self.load_workspace.activity_changed.connect(self._on_workspace_feedback)
        self.load_workspace.busy_changed.connect(self._load_busy_changed)
        self._add_workspace("加载到 PYNQ", QStyle.StandardPixmap.SP_ArrowUp, self.load_workspace)
        self.game_workspace.before_run = lambda: self._prepare_local_work("game")
        self.video_workspace.before_run = lambda: self._prepare_local_work("video")
        self.load_workspace.before_run = lambda: self._prepare_local_work("load")
        self.load_workspace.before_system_run = self._prepare_system_work
        self.load_content_button.clicked.connect(lambda: self.select_workspace(
            self.workspace_stack.indexOf(self.load_workspace)))
        self.navigation.currentRowChanged.connect(self._select_workspace)
        self.navigation.setCurrentRow(self.workspace_stack.indexOf(self.game_workspace))
        backend = "remote PYNQ Agent" if self.remote_mode else "simulated device"
        self.append_log(f"Studio initialized with the {backend} backend")
        self._render_device_state()
        self._background_timer = QTimer(self)
        self._background_timer.setInterval(500)
        self._background_timer.timeout.connect(self._refresh_background_status)
        self._background_timer.start()

    @property
    def workspace_count(self) -> int:
        return self.workspace_stack.count()

    def select_workspace(self, index: int) -> None:
        if not 0 <= index < self.workspace_count:
            raise IndexError("workspace index is out of range")
        if self.navigation.item(index).isHidden():
            raise ValueError("workspace is unavailable for this PYNQ profile")
        self.navigation.setCurrentRow(index)

    def _select_workspace(self, index: int) -> None:
        previous = self.workspace_stack.currentWidget()
        selected = self.workspace_stack.widget(index)
        if previous is not selected:
            try:
                if previous is self.game_workspace:
                    self.game_workspace.stop(wait=True)
                if previous is self.video_workspace and not self.video_workspace.stop(wait=True):
                    raise RuntimeError("视频仍在停止，请稍后切页")
                if previous is self.vision_workspace and not self.vision_workspace.stop_camera(wait=True):
                    raise RuntimeError("回传仍在停止，请稍后切页")
            except RuntimeError as error:
                self.append_log(str(error))
                blocked = self.navigation.blockSignals(True)
                self.navigation.setCurrentRow(self.workspace_stack.indexOf(previous))
                self.navigation.blockSignals(blocked)
                return
        self.workspace_stack.setCurrentIndex(index)
        if selected is self.load_workspace:
            self.load_workspace.refresh_contents()

    def _prepare_local_work(self, kind: str) -> bool:
        if self.load_workspace.is_busy:
            self.append_log("加载任务进行中，请等待完成或取消")
            return False
        try:
            if kind != "game":
                self.game_workspace.stop(wait=True)
            if kind != "video" and not self.video_workspace.stop(wait=True):
                raise RuntimeError("视频线程仍在停止")
            if not self.vision_workspace.stop_camera(wait=True):
                raise RuntimeError("回传线程仍在停止")
        except RuntimeError as error:
            self.append_log(str(error))
            return False
        return True

    def _load_busy_changed(self, busy: bool) -> None:
        self.game_workspace.setEnabled(not busy)
        self.video_workspace.setEnabled(not busy)
        self.vision_workspace.setEnabled(not busy)
        self.device_settings_button.setEnabled(not busy)
        self.device_button.setEnabled(not busy)
        if not busy:
            self._render_device_state(self.device.snapshot)
            if (isinstance(self.device,RemoteDeviceSession) and self.remote_thread is None
                    and self.device.snapshot.state is DeviceState.READY):
                self._start_remote()

    def _prepare_system_work(self) -> bool:
        if not self._prepare_local_work('load'):
            return False
        if not self._stop_remote(wait=True):
            self.append_log('连接线程仍在停止，尚未开始更新系统')
            return False
        return True

    def _set_audio_workspace(self, device: RemoteDeviceSession,
                             *, enabled: bool) -> None:
        selected = self.workspace_stack.currentWidget()
        was_blocked = self.navigation.blockSignals(True)
        try:
            if enabled and self.audio_workspace is None:
                from .audio_workspace import AudioWorkspace

                audio = AudioWorkspace(device)
                item = QListWidgetItem(
                    self.style().standardIcon(QStyle.StandardPixmap.SP_MediaVolume),
                    "Audio")
                item.setSizeHint(QSize(132, 44))
                item.setToolTip("Audio")
                self.navigation.insertItem(1, item)
                self.workspace_stack.insertWidget(1, audio)
                self.audio_workspace = audio
            elif not enabled and self.audio_workspace is not None:
                audio = self.audio_workspace
                self.navigation.takeItem(1)
                self.workspace_stack.removeWidget(audio)
                audio.deleteLater()
                self.audio_workspace = None
                if selected is audio:
                    selected = self.game_workspace
            elif self.audio_workspace is not None:
                self.audio_workspace.set_device(device)
            index = self.workspace_stack.indexOf(selected)
            self.navigation.setCurrentRow(index)
            self.workspace_stack.setCurrentIndex(index)
        finally:
            self.navigation.blockSignals(was_blocked)

    def toggle_device(self) -> None:
        if self.load_workspace.is_busy:
            self.append_log("请先取消或完成加载任务，再断开连接")
            return
        if self.remote_mode:
            if self.remote_thread is not None and self.remote_thread.isRunning():
                if not self.vision_workspace.stop_camera(wait=True):
                    self.append_log("回传尚未停止，保留当前连接")
                    return
                self._stop_remote(wait=False)
            else:
                self._start_remote()
            return
        self.configure_pynq()

    def configure_pynq(self) -> None:
        if isinstance(self.device, RemoteDeviceSession):
            default_host, default_port, source_address, default_build_id = self.device.connection_settings
            default_source_address = source_address or ""
        else:
            default_host = str(self.settings.value("pynq/host", "192.168.2.99"))
            default_port = int(self.settings.value("pynq/port", 8765))
            default_source_address = str(self.settings.value("pynq/source_address", "192.168.2.1"))
            default_build_id = int(self.settings.value("pynq/build_id", 0xC0061000))
        dialog = PynqConnectionDialog(
            default_host,
            default_port,
            default_source_address,
            self,
            expected_build_id=default_build_id,
        )
        if dialog.exec() != QDialog.DialogCode.Accepted:
            return
        host, port, source_address = dialog.connection
        if not host:
            self.append_log("PYNQ Agent host must not be empty")
            return
        self.use_remote_device(
            host,
            port,
            source_address=source_address,
            persist=True,
            connect=True,
            expected_build_id=dialog.expected_build_id,
        )

    def use_remote_device(
        self,
        host: str,
        port: int,
        *,
        source_address: str | None = None,
        persist: bool,
        connect: bool,
        expected_build_id: int = 0xC0060700,
    ) -> None:
        if not host.strip() or not 1 <= port <= 65535:
            raise ValueError("PYNQ Agent host or port is invalid")
        if expected_build_id not in (0xC0060700, 0xC0060800, 0xC0060900, 0xC0060C00, 0xC0061000):
            raise ValueError("Unsupported PYNQ platform BUILD_ID")
        if (
            self.load_workspace.is_busy
        ):
            message = "板端任务执行中，请稍后修改 PYNQ 连接"
            self.append_log(message)
            self._on_workspace_feedback("Device / PYNQ", message, "waiting", None)
            return
        if not self._stop_remote(wait=True):
            self.append_log("旧连接停止待确认，保持原连接")
            return
        self.vision_workspace.stop()
        if self.vision_workspace._http_attached() or self.vision_workspace.control_busy:
            self.append_log("回传停止待确认，保持原连接")
            return
        if self.audio_workspace is not None:
            self.audio_workspace.stop()
        if self.audio_workspace is not None and self.audio_workspace.observer_busy:
            self.append_log("声音观察线程停止待确认，保持原连接")
            return
        if isinstance(self.device, RemoteDeviceSession):
            self.device.disconnect()
        session = RemoteDeviceSession(
            host.strip(),
            port,
            source_address=source_address,
            expected_build_id=expected_build_id,
        )
        self.device = session
        self._board_info = None
        self.remote_mode = True
        self._received_count = 0
        self._last_received_at = None
        self._last_readout_at = None
        self._readout_current = False
        self.vision_workspace.set_camera_host(host.strip(), port=8081 if expected_build_id in (0xC0060800, 0xC0060900, 0xC0060C00, 0xC0061000) else 8088)
        self.vision_workspace.set_vision_agent(host.strip(), source_address=source_address,
            expected_build_id=expected_build_id if expected_build_id in (0xC0060900, 0xC0060C00) else None)
        self.vision_workspace.vision_agent_port.setValue(port if expected_build_id in (0xC0060800, 0xC0060900, 0xC0060C00, 0xC0061000) else 8766)
        self.vision_workspace.set_vision_control_available(expected_build_id != 0xC0061000)
        self._set_audio_workspace(session, enabled=expected_build_id != 0xC0061000)
        self.game_workspace.set_device(session)
        self.load_workspace.set_device(session)
        if persist:
            self.settings.setValue("pynq/host", host.strip())
            self.settings.setValue("pynq/port", port)
            self.settings.setValue("pynq/source_address", source_address or "")
            self.settings.setValue("pynq/build_id", expected_build_id)
            self.settings.sync()
        self._render_device_state()
        route = source_address or "automatic route"
        self.append_log(f"PYNQ Agent configured: {host.strip()}:{port} via {route}")
        if connect:
            self._start_remote()

    def append_log(self, message: str) -> None:
        timestamp = datetime.now().strftime("%H:%M:%S")
        self.session_log.appendPlainText(f"[{timestamp}] {message}")

    def closeEvent(self, event) -> None:  # type: ignore[no-untyped-def]
        try:
            self.game_workspace.code_editor.save_all()
        except OSError as error:
            self._on_workspace_feedback("Game / PC", f"保存失败，窗口保持打开：{error}", "error", None)
            event.ignore()
            return
        if not self.load_workspace.stop(wait=True):
            self.append_log("加载任务仍在收尾，稍后可再次关闭")
            event.ignore()
            return
        self._background_timer.stop()
        self.game_workspace.timer.stop()
        self.game_workspace._pynq_status_timer.stop()
        try:
            self.game_workspace.stop(wait=True)
        except RuntimeError as error:
            self.append_log(str(error))
            event.ignore()
            return
        self.vision_workspace.stop()
        if self.vision_workspace._http_attached() or self.vision_workspace.control_busy:
            self.append_log("Vision workers still stopping; window close postponed")
            event.ignore()
            return
        if self.audio_workspace is not None:
            self.audio_workspace.stop()
        if self.audio_workspace is not None and self.audio_workspace.observer_busy:
            self.append_log("Audio observer still stopping; window close postponed")
            event.ignore()
            return
        if not self.video_workspace.stop(wait=True) or not self._stop_remote(wait=True):
            self.append_log("后台线程仍在停止，窗口暂不关闭")
            event.ignore()
            return
        self.game_workspace.release_cache()
        super().closeEvent(event)

    def _start_remote(self) -> None:
        if not isinstance(self.device, RemoteDeviceSession) or self.remote_thread is not None:
            return
        thread = QThread(self)
        from functools import partial
        worker = AgentIoWorker(self.device, board_probe=partial(
            probe_board,self.device,ssh_alias=self.load_workspace.ssh_alias.text().strip()))
        worker.moveToThread(thread)
        thread.started.connect(worker.run)
        worker.snapshot_changed.connect(self._on_device_snapshot)
        worker.frame_received.connect(self._on_remote_frame)
        worker.board_changed.connect(self._on_board_info)
        worker.finished.connect(thread.quit)
        worker.finished.connect(worker.deleteLater)
        thread.finished.connect(self._remote_finished)
        self.remote_thread = thread
        self.remote_worker = worker
        self._connection_pending = True
        self.device_button.setEnabled(False)
        self._render_device_state()
        thread.start()

    def _stop_remote(self, *, wait: bool) -> bool:
        worker = self.remote_worker
        thread = self.remote_thread
        if worker is not None:
            worker.stop()
        if wait and thread is not None and thread.isRunning():
            thread.quit()
            if not thread.wait(2000):
                return False
        if wait and thread is not None and not thread.isRunning():
            self._remote_finished()
        return self.remote_thread is None

    def _remote_finished(self) -> None:
        sender = self.sender()
        if isinstance(sender, QThread) and sender is not self.remote_thread:
            return
        thread = self.remote_thread
        self.remote_worker = None
        self.remote_thread = None
        self._connection_pending = False
        self._board_info = None
        self.load_workspace.board_info = None
        if thread is not None:
            thread.deleteLater()
        self.device_button.setEnabled(True)
        self._render_device_state()

    def _on_board_info(self, info) -> None:
        if self.sender() is not None and self.sender() is not self.remote_worker:
            return
        self._board_info = info
        self.load_workspace.board_info = info
        self.load_workspace.refresh_device_state()
        self._render_device_state()

    def _on_device_snapshot(self, snapshot: DeviceSnapshot) -> None:
        if self.sender() is not None and self.sender() is not self.remote_worker:
            return
        self._connection_pending = False
        if snapshot.state is DeviceState.READY and self._display_snapshot.state is not DeviceState.READY:
            self.vision_workspace.begin_stream_session()
            if self.audio_workspace is not None:
                self.audio_workspace.begin_stream_session()
        if snapshot.state is not DeviceState.READY:
            self._received_count = 0
            self._last_received_at = None
            self._last_received_source = None
            self._readout_current = False
            self.vision_workspace.mark_stream_historical()
            if self.audio_workspace is not None:
                self.audio_workspace.mark_stream_historical()
        self._render_device_state(snapshot)
        self.game_workspace.refresh_device_state()
        self.load_workspace.refresh_device_state()
        self.device_button.setEnabled(not self.load_workspace.is_busy)
        self.append_log(f"Device {snapshot.state.value}: {snapshot.message}")

    def _on_remote_frame(self, frame: ProtocolFrame) -> None:
        if self.sender() is not None and self.sender() is not self.remote_worker:
            return
        if self._display_snapshot.state is not DeviceState.READY:
            return
        if frame.source_id == FIXTURE_AUDIO_SOURCE_ID and self.audio_workspace is None:
            return
        self._received_count += 1
        self._last_received_at = monotonic()
        self._last_received_source = frame.source_id
        if frame.source_id == FIXTURE_VISION_SOURCE_ID:
            self.vision_workspace.accept_frame(frame)
        elif frame.source_id == FIXTURE_AUDIO_SOURCE_ID and self.audio_workspace is not None:
            self.audio_workspace.accept_frame(frame)
        self._refresh_background_status()

    def _on_camera_status(self, message: str, status: str) -> None:
        self.camera_status.setToolTip(message)
        self.camera_status.setText("CAM 错误" if status == "error" else message)
        self.camera_status.setProperty("status", status)
        self.camera_status.style().unpolish(self.camera_status)
        self.camera_status.style().polish(self.camera_status)
        if status == "error":
            self.append_log(f"Camera / HTTP: {message}")

    def _on_workspace_feedback(
        self, source: str, message: str, status: str, snapshot: object
    ) -> None:
        if message:
            self._task_message = f"{source}: {message}"
            self.task_status.setProperty("status", status)
            self.task_status.style().unpolish(self.task_status)
            self.task_status.style().polish(self.task_status)
        if status == "error" and "PYNQ" in source:
            self._readout_current = False
        if isinstance(snapshot, dict) and snapshot:
            self._last_readout_at = monotonic()
            self._readout_current = (
                self.remote_mode and self._display_snapshot.state is DeviceState.READY
            )
            self.readout_status.setToolTip(
                f"{source} / runtime_mode={snapshot.get('runtime_mode', '--')} / "
                f"state={snapshot.get('state', '--')} / 最近命令或查询回执"
            )
        self._refresh_background_status()

    def _refresh_background_status(self) -> None:
        if not self.remote_mode:
            text = "RX 离线 / 未订阅"
        elif self._display_snapshot.state is not DeviceState.READY:
            text = "RX 未连接"
        elif self._last_received_at is None:
            text = ("RX 按需回传 / 默认关闭" if getattr(self.device, "expected_build_id", 0) == 0xC0061000
                    else "RX source 1/2 / 等待数据")
        else:
            age = monotonic() - self._last_received_at
            text = f"RX {self._received_count:,} 包 / {age:.1f}s 前"
        self.receive_status.setText(text)
        self.receive_status.setToolTip(
            f"{text}\n最近 source: {self._last_received_source or '--'}\n"
            "计时来自本机接收 DATA；连接成功与收到数据分别显示"
        )
        if self._last_readout_at is None:
            text = "板端回读 --"
        else:
            age = monotonic() - self._last_readout_at
            prefix = "最近回读" if self._readout_current else "历史回读"
            text = f"{prefix} / {age:.1f}s 前"
        self.readout_status.setText(text)
        self.task_status.setToolTip(self._task_message)
        self.task_status.setText(self.task_status.fontMetrics().elidedText(
            self._task_message, Qt.TextElideMode.ElideRight, max(1, self.task_status.width())
        ))

    def _build_top_bar(self) -> QFrame:
        bar = QFrame()
        bar.setObjectName("topBar")
        bar.setFixedHeight(88)
        layout = QVBoxLayout(bar)
        layout.setContentsMargins(16, 8, 16, 8)
        layout.setSpacing(4)
        actions = QHBoxLayout()
        self.brand_logo = QLabel()
        self.brand_logo.setObjectName("brandLogo")
        self.brand_logo.setAccessibleName("AMD PYNQ")
        self.brand_logo.setToolTip("AMD PYNQ · Studio")
        self.brand_logo.setPixmap(pynq_wordmark().scaled(
            QSize(84, 40), Qt.AspectRatioMode.KeepAspectRatio,
            Qt.TransformationMode.SmoothTransformation))
        self.brand_logo.setFixedSize(84, 40)
        actions.addWidget(self.brand_logo)
        separator = QLabel("STUDIO")
        separator.setObjectName("mutedLabel")
        actions.addWidget(separator)
        actions.addStretch()
        self.device_label = QLabel()
        actions.addWidget(self.device_label)
        self.load_content_button = QPushButton("加载到 PYNQ")
        self.load_content_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_ArrowUp))
        actions.addWidget(self.load_content_button)
        self.device_button = QPushButton("连接 PYNQ")
        self.device_button.setObjectName("deviceButton")
        self.device_button.clicked.connect(self.toggle_device)
        self.device_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_DriveNetIcon))
        actions.addWidget(self.device_button)
        self.device_settings_button = QPushButton("连接 PYNQ…")
        self.device_settings_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_FileDialogDetailedView))
        self.device_button.setObjectName("primaryAction")
        self.device_settings_button.setToolTip("配置 PYNQ Agent 地址和端口")
        self.device_settings_button.clicked.connect(self.configure_pynq)
        actions.addWidget(self.device_settings_button)
        layout.addLayout(actions)
        identity = QHBoxLayout()
        self.target_label = QLabel()
        self.target_label.setObjectName("mutedLabel")
        self.target_label.setSizePolicy(QSizePolicy.Policy.Ignored, QSizePolicy.Policy.Preferred)
        identity.addWidget(self.target_label, 1)
        self.build_label = QLabel("BUILD_ID --")
        self.build_label.setObjectName("metricName")
        identity.addWidget(self.build_label)
        self.board_label = QLabel('板卡连接未检查')
        self.board_label.setObjectName('mutedLabel')
        identity.addWidget(self.board_label)
        layout.addLayout(identity)
        return bar

    def _build_status_bar(self) -> QFrame:
        bar = QFrame()
        bar.setObjectName("statusBar")
        layout = QVBoxLayout(bar)
        layout.setContentsMargins(12, 6, 12, 6)
        layout.setSpacing(6)
        summary = QHBoxLayout()
        self.receive_status = QLabel("RX 未连接")
        self.receive_status.setObjectName("mutedLabel")
        self.receive_status.setMinimumWidth(220)
        summary.addWidget(self.receive_status)
        self.camera_status = QLabel("CAM 未连接")
        self.camera_status.setProperty("status", "muted")
        summary.addWidget(self.camera_status)
        self.task_status = QLabel(self._task_message)
        self.task_status.setSizePolicy(QSizePolicy.Policy.Ignored, QSizePolicy.Policy.Preferred)
        summary.addWidget(self.task_status, 1)
        self.readout_status = QLabel("板端回读 --")
        self.readout_status.setObjectName("mutedLabel")
        self.readout_status.setMinimumWidth(170)
        summary.addWidget(self.readout_status)
        self.log_button = QToolButton()
        self.log_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_FileDialogDetailedView))
        self.log_button.setToolTip("会话日志")
        self.log_button.setCheckable(True)
        self.log_button.setFixedSize(32, 32)
        summary.addWidget(self.log_button)
        layout.addLayout(summary)
        self.session_log = QPlainTextEdit()
        self.session_log.setObjectName("sessionLog")
        self.session_log.setReadOnly(True)
        self.session_log.setMaximumBlockCount(300)
        self.session_log.setFixedHeight(120)
        self.session_log.setSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Expanding)
        layout.addWidget(self.session_log)
        self.session_log.hide()
        self.log_button.toggled.connect(self.session_log.setVisible)
        return bar

    def _add_workspace(
        self,
        label: str,
        icon: QStyle.StandardPixmap,
        workspace: QWidget,
    ) -> None:
        item = QListWidgetItem(self.style().standardIcon(icon), label)
        item.setSizeHint(QSize(132, 44))
        item.setToolTip(label)
        self.navigation.addItem(item)
        self.workspace_stack.addWidget(workspace)

    def _render_device_state(self, snapshot: DeviceSnapshot | None = None) -> None:
        snapshot = snapshot or self.device.snapshot
        self._display_snapshot = snapshot
        state = DeviceState.CONNECTING if self._connection_pending else snapshot.state
        ready = state is DeviceState.READY
        if self.remote_mode:
            ssh_ready = bool(self._board_info and self._board_info.get('ssh_ready'))
            labels = {
                DeviceState.READY: "AGENT READY",
                DeviceState.DISCONNECTED: "AGENT OFFLINE",
                DeviceState.CONNECTING: "程序连接中",
                DeviceState.ERROR: board_startup_title(self._board_info) if ssh_ready else '程序未连接',
            }
            self.device_label.setText(labels[state])
            self.device_button.setText(
                "连接中…" if self._connection_pending else
                "断开 PYNQ" if self.remote_thread is not None else "连接 PYNQ"
            )
            target = snapshot.name
            self.device_settings_button.setText("PYNQ 设置")
            self.board_label.setText('板卡已连接 · SSH' if ssh_ready else
                                     '板卡在线 · Agent' if ready else
                                     '板卡 SSH 未确认' if self._board_info else '板卡连接未检查')
            self.board_label.setToolTip(str(self._board_info.get('error','通过 SSH 登录并核对目标地址'))
                                       if self._board_info else '连接板卡与程序就绪分别检查')
        else:
            self.device_label.setText("PC 离线创作")
            self.device_button.setText("连接 PYNQ")
            self.device_settings_button.setText("PYNQ 设置")
            target = "PYNQ 未连接 · 可离线编辑、试玩和测试"
            self.board_label.setText('板卡连接未配置')
        self.target_label.setText(target)
        self.target_label.setToolTip(f"{target}\n{snapshot.message}")
        prefix = "BUILD_ID"
        build = f"0x{snapshot.build_id:08X}" if ready and snapshot.build_id is not None else "--"
        self.build_label.setText(f"{prefix} {build}")
        self.build_label.setToolTip(
            "板端 HELLO 校验值" if self.remote_mode else "尚未进行板端握手"
        )
        self.device_label.setToolTip(board_startup_message(self._board_info)
            if self.remote_mode and not ready and ssh_ready else snapshot.message)
        names = {
            DeviceState.READY: "deviceReady",
            DeviceState.CONNECTING: "deviceWaiting",
            DeviceState.DISCONNECTED: "deviceOffline",
            DeviceState.ERROR: "deviceError",
        }
        if (self.remote_mode and ssh_ready and state is DeviceState.ERROR
                and not self._board_info.get('startup_error')
                and (self._board_info.get('service') or {}).get('ActiveState') != 'failed'):
            names[DeviceState.ERROR] = 'deviceWaiting'
        self.device_label.setObjectName(names[state])
        self.device_label.style().unpolish(self.device_label)
        self.device_label.style().polish(self.device_label)
        self._refresh_background_status()
