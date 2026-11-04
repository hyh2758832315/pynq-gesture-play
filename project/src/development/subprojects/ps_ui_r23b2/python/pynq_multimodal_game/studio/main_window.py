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
from .audio_workspace import AudioWorkspace
from .game_workspace import GameWorkspace
from .remote_io import AgentIoWorker
from .video_workspace import VideoWorkspace
from .workspaces import AdapterWorkspace, CapabilityWorkspace, VisionWorkspace


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
        self.platform_input.addItem("声视融合候选 / 0xC0060900", 0xC0060900)
        self.platform_input.addItem("双音量融合 / 0xC0060E00", 0xC0060E00)
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
        self.setWindowTitle("Voice View Studio")
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
        camera_port = 8081 if agent_build_id in (0xC0060800, 0xC0060900, 0xC0060E00) else 8088
        self.vision_workspace = VisionWorkspace(f"http://{camera_host}:{camera_port}/camera.mjpg")
        if agent_host:
            self.vision_workspace.set_vision_agent(agent_host, source_address=agent_source_address,
                expected_build_id=agent_build_id if agent_build_id in (0xC0060900, 0xC0060E00) else None)
            self.vision_workspace.vision_agent_port.setValue(agent_port if agent_build_id in (0xC0060800, 0xC0060900, 0xC0060E00) else 8766)
        self.vision_workspace.camera_status_changed.connect(self._on_camera_status)
        self._add_workspace(
            "Vision",
            QStyle.StandardPixmap.SP_DesktopIcon,
            self.vision_workspace,
        )
        self.audio_workspace = AudioWorkspace(self.device)
        self._add_workspace(
            "Audio",
            QStyle.StandardPixmap.SP_MediaVolume,
            self.audio_workspace,
        )
        self.game_workspace = GameWorkspace(
            device=self.device if isinstance(self.device, RemoteDeviceSession) else None
        )
        self.game_workspace.log_requested.connect(self.append_log)
        self.game_workspace.activity_changed.connect(self._on_workspace_feedback)
        self.game_workspace.input_target.setCurrentIndex(self.game_workspace.input_target.findData("pynq"))
        self._add_workspace("Game", QStyle.StandardPixmap.SP_MediaPlay, self.game_workspace)
        self.video_workspace = VideoWorkspace(
            self.device if isinstance(self.device, RemoteDeviceSession) else None
        )
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
        self.navigation.currentRowChanged.connect(self._select_workspace)
        self.navigation.setCurrentRow(2)
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
        self.navigation.setCurrentRow(index)

    def _select_workspace(self, index: int) -> None:
        self.workspace_stack.setCurrentIndex(index)

    def toggle_device(self) -> None:
        if self.remote_mode:
            if self.remote_thread is not None and self.remote_thread.isRunning():
                self._stop_remote(wait=False)
            else:
                self._start_remote()
            return
        if self.device.snapshot.state is DeviceState.READY:
            snapshot = self.device.disconnect()
        else:
            snapshot = self.device.connect()
        self._render_device_state()
        self.append_log(f"Device {snapshot.state.value}: {snapshot.message}")

    def configure_pynq(self) -> None:
        default_host = str(self.settings.value("pynq/host", "192.168.2.99"))
        default_port = int(self.settings.value("pynq/port", 8765))
        default_source_address = str(
            self.settings.value("pynq/source_address", "192.168.2.1")
        )
        dialog = PynqConnectionDialog(
            default_host,
            default_port,
            default_source_address,
            self,
            expected_build_id=int(self.settings.value("pynq/build_id", 0xC0060700)),
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
        if expected_build_id not in (0xC0060700, 0xC0060800, 0xC0060900, 0xC0060E00):
            raise ValueError("Unsupported PYNQ platform BUILD_ID")
        if (
            self.game_workspace._device_thread is not None
            or self.video_workspace.upload_thread is not None
            or self.video_workspace.control_thread is not None
        ):
            message = "板端任务执行中，请稍后修改 PYNQ 连接"
            self.append_log(message)
            self._on_workspace_feedback("Device / PYNQ", message, "waiting", None)
            return
        self._stop_remote(wait=True)
        self.audio_workspace.stop()
        if self.audio_workspace.observer_busy:
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
        self.remote_mode = True
        self._received_count = 0
        self._last_received_at = None
        self._last_readout_at = None
        self._readout_current = False
        self.vision_workspace.set_camera_host(host.strip(), port=8081 if expected_build_id in (0xC0060800, 0xC0060900, 0xC0060E00) else 8088)
        self.vision_workspace.set_vision_agent(host.strip(), source_address=source_address,
            expected_build_id=expected_build_id if expected_build_id in (0xC0060900, 0xC0060E00) else None)
        self.vision_workspace.vision_agent_port.setValue(port if expected_build_id in (0xC0060800, 0xC0060900, 0xC0060E00) else 8766)
        self.game_workspace.set_device(session)
        self.video_workspace.set_upload_target(session)
        self.audio_workspace.set_device(session)
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
        self._background_timer.stop()
        self.game_workspace.timer.stop()
        self.game_workspace._pynq_status_timer.stop()
        self.game_workspace.stop(wait=True)
        self.vision_workspace.stop()
        if self.vision_workspace._http_attached() or self.vision_workspace.control_busy:
            self.append_log("Vision workers still stopping; window close postponed")
            event.ignore()
            return
        self.audio_workspace.stop()
        if self.audio_workspace.observer_busy:
            self.append_log("Audio observer still stopping; window close postponed")
            event.ignore()
            return
        self.video_workspace.stop(wait=True)
        self._stop_remote(wait=True)
        super().closeEvent(event)

    def _start_remote(self) -> None:
        if not isinstance(self.device, RemoteDeviceSession) or self.remote_thread is not None:
            return
        thread = QThread(self)
        worker = AgentIoWorker(self.device)
        worker.moveToThread(thread)
        thread.started.connect(worker.run)
        worker.snapshot_changed.connect(self._on_device_snapshot)
        worker.frame_received.connect(self._on_remote_frame)
        worker.finished.connect(thread.quit)
        worker.finished.connect(worker.deleteLater)
        thread.finished.connect(self._remote_finished)
        self.remote_thread = thread
        self.remote_worker = worker
        self._connection_pending = True
        self.device_button.setEnabled(False)
        self._render_device_state()
        thread.start()

    def _stop_remote(self, *, wait: bool) -> None:
        worker = self.remote_worker
        thread = self.remote_thread
        if worker is not None:
            worker.stop()
        if wait and thread is not None and thread.isRunning():
            thread.quit()
            thread.wait(2000)
        if wait and thread is not None and not thread.isRunning():
            self._remote_finished()

    def _remote_finished(self) -> None:
        sender = self.sender()
        if isinstance(sender, QThread) and sender is not self.remote_thread:
            return
        thread = self.remote_thread
        self.remote_worker = None
        self.remote_thread = None
        self._connection_pending = False
        if thread is not None:
            thread.deleteLater()
        self.device_button.setEnabled(True)
        self._render_device_state()

    def _on_device_snapshot(self, snapshot: DeviceSnapshot) -> None:
        if self.sender() is not None and self.sender() is not self.remote_worker:
            return
        self._connection_pending = False
        if snapshot.state is DeviceState.READY and self._display_snapshot.state is not DeviceState.READY:
            self.vision_workspace.begin_stream_session()
            self.audio_workspace.begin_stream_session()
        if snapshot.state is not DeviceState.READY:
            self._received_count = 0
            self._last_received_at = None
            self._last_received_source = None
            self._readout_current = False
            self.vision_workspace.mark_stream_historical()
            self.audio_workspace.mark_stream_historical()
        self._render_device_state(snapshot)
        self.game_workspace.refresh_device_state()
        self.video_workspace.refresh_device_state(snapshot.state is DeviceState.READY)
        self.device_button.setEnabled(True)
        self.append_log(f"Device {snapshot.state.value}: {snapshot.message}")

    def _on_remote_frame(self, frame: ProtocolFrame) -> None:
        if self.sender() is not None and self.sender() is not self.remote_worker:
            return
        if self._display_snapshot.state is not DeviceState.READY:
            return
        self._received_count += 1
        self._last_received_at = monotonic()
        self._last_received_source = frame.source_id
        if frame.source_id == FIXTURE_VISION_SOURCE_ID:
            self.vision_workspace.accept_frame(frame)
        elif frame.source_id == FIXTURE_AUDIO_SOURCE_ID:
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
            text = "RX 本地模拟 / 未订阅"
        elif self._display_snapshot.state is not DeviceState.READY:
            text = "RX 未连接"
        elif self._last_received_at is None:
            text = "RX source 1/2 / 等待数据"
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
        brand = QLabel("VOICE / VIEW")
        brand.setObjectName("brandLabel")
        actions.addWidget(brand)
        separator = QLabel("PYNQ CONTROL")
        separator.setObjectName("mutedLabel")
        actions.addWidget(separator)
        actions.addStretch()
        self.device_label = QLabel()
        actions.addWidget(self.device_label)
        self.device_button = QPushButton("连接模拟器")
        self.device_button.setObjectName("deviceButton")
        self.device_button.clicked.connect(self.toggle_device)
        self.device_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_DriveNetIcon))
        actions.addWidget(self.device_button)
        self.device_settings_button = QPushButton("连接 PYNQ…")
        self.device_settings_button.setObjectName("primaryAction")
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
            labels = {
                DeviceState.READY: "AGENT READY",
                DeviceState.DISCONNECTED: "AGENT OFFLINE",
                DeviceState.CONNECTING: "AGENT CONNECTING",
                DeviceState.ERROR: "AGENT ERROR / 重连中" if self.remote_thread is not None else "AGENT ERROR",
            }
            self.device_label.setText(labels[state])
            self.device_button.setText(
                "连接中…" if self._connection_pending else
                "断开 PYNQ" if self.remote_thread is not None else "连接 PYNQ"
            )
            target = snapshot.name
            self.device_settings_button.setText("PYNQ 设置")
        else:
            self.device_label.setText("SIM READY" if ready else "SIM OFFLINE")
            self.device_button.setText("断开模拟器" if ready else "连接模拟器")
            target = "PYNQ 未连接 / 本地模拟后端"
        self.target_label.setText(target)
        self.target_label.setToolTip(f"{target}\n{snapshot.message}")
        prefix = "BUILD_ID" if self.remote_mode else "SIM BUILD_ID"
        build = f"0x{snapshot.build_id:08X}" if ready and snapshot.build_id is not None else "--"
        self.build_label.setText(f"{prefix} {build}")
        self.build_label.setToolTip(
            "板端 HELLO 校验值" if self.remote_mode else "模拟器能力配置，非板端握手"
        )
        self.device_label.setToolTip(snapshot.message)
        names = {
            DeviceState.READY: "deviceReady",
            DeviceState.CONNECTING: "deviceWaiting",
            DeviceState.DISCONNECTED: "deviceOffline",
            DeviceState.ERROR: "deviceError",
        }
        self.device_label.setObjectName(names[state])
        self.device_label.style().unpolish(self.device_label)
        self.device_label.style().polish(self.device_label)
        self._refresh_background_status()