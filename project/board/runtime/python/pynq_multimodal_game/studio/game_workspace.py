from __future__ import annotations

from dataclasses import asdict
import json
import os
from pathlib import Path
import secrets
import shutil
from tempfile import TemporaryDirectory
import threading
import uuid
from typing import Any, Callable

from PySide6.QtCore import QObject, QThread, Qt, QTimer, Signal, Slot
from PySide6.QtGui import QFont, QImage
from PySide6.QtWidgets import (
    QButtonGroup,
    QDoubleSpinBox,
    QComboBox,
    QFileDialog,
    QFrame,
    QGridLayout,
    QHBoxLayout,
    QInputDialog,
    QLabel,
    QListWidget,
    QListWidgetItem,
    QMenu,
    QProgressBar,
    QPushButton,
    QLineEdit,
    QScrollArea,
    QSizePolicy,
    QSplitter,
    QSpinBox,
    QStyle,
    QTabWidget,
    QTableWidget,
    QTableWidgetItem,
    QToolButton,
    QVBoxLayout,
    QWidget,
)

from ..game_package import GameManifest, validate_game_package
from ..game_project import GameProject
from ..game_runner import GameFrame
from ..game_sdk import GameInput, HandGesture, VolumeSignal
from ..game_testing import (
    AssertionOperator,
    AssertionResult,
    AssertionRule,
    AuditEvent,
    GameTestCase,
    InputEvent,
    InputKind,
    MAX_TEST_TICKS,
)
from ..game_validation import (
    GameTestReport, build_verified_game, compare_test_reports,
    run_game_test, save_test_report,
)
from .code_editor import ProjectCodeEditor
from .device import DeviceState, RemoteDeviceSession
from .game_debug_widgets import AuditConsole, GameInspector, InteractiveGameViewport
from .game_worker import GamePreviewWorker
from .workspaces import rgb_to_qimage


GESTURE_LABELS = {HandGesture.FIST: "握拳", HandGesture.SCISSORS: "剪刀", HandGesture.PAPER: "布"}
INPUT_LABELS = {InputKind.HAND: "手部位置", InputKind.FIST: "握拳事件", InputKind.GESTURE: "手势", InputKind.TONE: "音调", InputKind.CANCEL: "取消", InputKind.VOLUME: "音量事件"}


def default_projects_root() -> Path:
    configured = os.environ.get("VOICE_VIEW_GAME_PROJECTS_ROOT")
    if configured:
        return Path(configured).expanduser().resolve()
    source_projects = Path(__file__).resolve().parents[3] / "games"
    if source_projects.is_dir():
        return source_projects
    return Path.cwd() / "games"


class DeviceTaskWorker(QObject):
    completed = Signal(str, object)
    failed = Signal(str, str)
    progress_changed = Signal(str, int, int)
    finished = Signal()

    def __init__(
        self,
        action: str,
        operation: Callable[[], object] | None,
        progress_operation: Callable[[Callable[[int, int], None]], object] | None = None,
    ) -> None:
        super().__init__()
        self.action = action
        self.operation = operation
        self.progress_operation = progress_operation

    @Slot()
    def run(self) -> None:
        try:
            if self.progress_operation is not None:
                result = self.progress_operation(self._report_progress)
            elif self.operation is not None:
                result = self.operation()
            else:
                raise RuntimeError("device task has no operation")
            self.completed.emit(self.action, result)
        except Exception as error:
            self.failed.emit(self.action, str(error))
        finally:
            self.finished.emit()

    def _report_progress(self, received: int, total: int) -> None:
        self.progress_changed.emit(self.action, received, total)


class GameWorkspace(QWidget):
    log_requested = Signal(str)
    device_action_requested = Signal(str)
    activity_changed = Signal(str, str, str, object)
    test_report_ready = Signal(object)

    def __init__(
        self,
        *,
        projects_root: Path | None = None,
        device: RemoteDeviceSession | None = None,
    ) -> None:
        super().__init__()
        self.projects_root = Path(projects_root or default_projects_root())
        self.device = device
        self.device_action_requested.connect(self._run_device_action)
        self.session = None
        self.timer = QTimer(self)
        self.timer.setInterval(17)
        self._image = QImage()
        self._active_project: Path | None = None
        self._built_package: Path | None = None
        self._preview_thread: QThread | None = None
        self._preview_worker: GamePreviewWorker | None = None
        self._preview_stopping = False
        self._assertion_passed = 0
        self._assertion_failed = 0
        self._run_id = ""
        self._device_thread: QThread | None = None
        self._device_worker: DeviceTaskWorker | None = None
        self._device_task_details: dict[str, object] = {}
        self._validation_stop = threading.Event()
        self._pynq_running = False
        self._pynq_live = False
        self._pynq_paused = False
        self._last_pynq_accepted_input_id: str | None = None
        self._last_pynq_consumed_input_id: str | None = None
        self._last_volume_receipt_identity = None
        self._timeline_volume_run = uuid.uuid4().hex
        self._last_pc_frame: GameFrame | None = None
        self._last_pynq_snapshot: dict[str, Any] = {}
        self._pc_test_complete = False
        self._pynq_test_complete = False
        self._comparison_reported = False
        self._last_pc_report: dict[str, Any] | None = None
        self._last_pynq_report: dict[str, Any] | None = None
        self.test_report_ready.connect(self._accept_preflight_report)
        self._pynq_status_timer = QTimer(self)
        self._pynq_status_timer.setInterval(250)
        self._pynq_status_timer.timeout.connect(self._poll_pynq_status)

        root = QVBoxLayout(self)
        root.setContentsMargins(12, 10, 12, 10)
        root.setSpacing(8)
        root.addWidget(self._build_command_bar())
        workspace = QSplitter(Qt.Orientation.Horizontal)
        workspace.setObjectName("gameWorkspaceSplitter")
        workspace.addWidget(self._build_library_panel())
        center = QSplitter(Qt.Orientation.Vertical)
        self.content_splitter = center
        center.addWidget(self._build_content_tabs())
        self.audit_console = AuditConsole()
        self.audit_console.setMinimumHeight(145)
        self.audit_console.setFont(QFont("Bahnschrift", 10))
        center.addWidget(self.audit_console)
        center.setSizes((560, 220))
        workspace.addWidget(center)
        self.inspector = GameInspector()
        self.inspector.setMinimumWidth(260)
        workspace.addWidget(self.inspector)
        workspace.setSizes((210, 740, 300))
        workspace.setChildrenCollapsible(False)
        workspace.setStretchFactor(1, 1)
        root.addWidget(workspace, 1)
        self.show_pynq_output()
        self._refresh_projects()
        self._refresh_action_states()
        self.view_tabs.setCurrentIndex(0)
        if device is not None:
            self.set_device(device)

    def _build_command_bar(self) -> QFrame:
        bar = QFrame()
        bar.setObjectName("commandBar")
        layout = QVBoxLayout(bar)
        layout.setContentsMargins(10, 6, 10, 6)
        layout.setSpacing(6)
        target_row = QHBoxLayout()
        target_row.addWidget(QLabel("执行目标"))
        self.input_target = QComboBox()
        self.input_target.addItem("PC", "pc")
        self.input_target.addItem("PYNQ", "pynq")
        self.input_target.addItem("PC + PYNQ 对照", "compare")
        self.input_target.currentIndexChanged.connect(self._target_changed)
        self.input_target.setMinimumWidth(130)
        target_row.addWidget(self.input_target)
        self.pynq_input_mode = QComboBox()
        self.pynq_input_mode.addItem("确定性回放", "replay")
        self.pynq_input_mode.addItem("实时视觉", "vision")
        self.pynq_input_mode.currentIndexChanged.connect(self._refresh_action_states)
        target_row.addWidget(self.pynq_input_mode)
        self.test_device_button = QPushButton("设备状态")
        self.clear_state_button = QPushButton("停止并回菜单")
        self.initialize_button = QPushButton("重新扫描")
        for action, button in (
            ("test", self.test_device_button),
            ("clear", self.clear_state_button),
            ("initialize", self.initialize_button),
        ):
            button.clicked.connect(
                lambda _checked=False, current=action: self.device_action_requested.emit(current)
            )
            target_row.addWidget(button)
        target_row.addStretch()
        layout.addLayout(target_row)
        deploy_row = QHBoxLayout()
        self.pc_play_button = QPushButton("PC 试玩")
        self.pc_play_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaPlay))
        self.pc_play_button.clicked.connect(self.start_project_play)
        self.pc_test_button = QPushButton("运行 PC 测试")
        self.pc_test_button.setObjectName("primaryAction")
        self.pc_test_button.clicked.connect(self.start_project_preview)
        self.build_button = QPushButton("构建 VVG")
        self.build_button.clicked.connect(self.build_active_project)
        self.install_button = QPushButton("安装到 PYNQ")
        self.install_button.clicked.connect(self.install_active_project)
        deploy_row.addWidget(self.pc_play_button)
        deploy_row.addWidget(self.pc_test_button)
        deploy_row.addWidget(self.build_button)
        deploy_row.addWidget(self.install_button)
        deploy_row.addStretch()
        layout.addLayout(deploy_row)
        return bar

    def _build_library_panel(self) -> QFrame:
        panel = QFrame()
        panel.setObjectName("inspectorPanel")
        panel.setMinimumWidth(180)
        panel.setMaximumWidth(260)
        layout = QVBoxLayout(panel)
        layout.setContentsMargins(10, 10, 10, 10)
        title_row = QHBoxLayout()
        title = QLabel("游戏项目")
        title.setObjectName("sectionLabel")
        title_row.addWidget(title)
        title_row.addStretch()
        self.refresh_projects_button = self._tool_button(
            QStyle.StandardPixmap.SP_BrowserReload, "刷新项目列表"
        )
        self.refresh_projects_button.clicked.connect(self.refresh_projects)
        title_row.addWidget(self.refresh_projects_button)
        layout.addLayout(title_row)
        self.game_list = QListWidget()
        self.game_list.setObjectName("gameLibrary")
        self.game_list.itemSelectionChanged.connect(self._select_game)
        layout.addWidget(self.game_list, 1)
        self.new_game_button = QPushButton("新建游戏")
        self.new_game_button.clicked.connect(self._prompt_new_project)
        layout.addWidget(self.new_game_button)
        self.import_game_button = QPushButton("导入工程")
        self.import_game_button.clicked.connect(self._prompt_import_project)
        layout.addWidget(self.import_game_button)
        layout.addWidget(self._eyebrow("测试用例"))
        self.test_case_list = QListWidget()
        self.test_case_list.setObjectName("testCaseList")
        self.test_case_list.itemSelectionChanged.connect(self._select_test_case)
        layout.addWidget(self.test_case_list, 1)
        test_buttons = QHBoxLayout()
        self.new_test_button = QPushButton("新建")
        self.new_test_button.clicked.connect(self._new_test_case)
        self.delete_test_button = QPushButton("删除")
        self.delete_test_button.clicked.connect(self._delete_test_case)
        test_buttons.addWidget(self.new_test_button)
        test_buttons.addWidget(self.delete_test_button)
        layout.addLayout(test_buttons)
        return panel

    def _build_operation_panels(self) -> QHBoxLayout:
        row = QHBoxLayout()
        row.setSpacing(12)
        device = QFrame()
        device.setObjectName("workspacePanel")
        device_layout = QVBoxLayout(device)
        device_layout.addWidget(self._eyebrow("常规设备操作"))
        device_buttons = QHBoxLayout()
        self.test_device_button = QPushButton("测试")
        self.clear_state_button = QPushButton("清理状态")
        self.initialize_button = QPushButton("初始化")
        for action, button in (
            ("test", self.test_device_button),
            ("clear", self.clear_state_button),
            ("initialize", self.initialize_button),
        ):
            button.clicked.connect(
                lambda _checked=False, current=action: self.device_action_requested.emit(current)
            )
            device_buttons.addWidget(button)
        device_layout.addLayout(device_buttons)
        row.addWidget(device, 1)

        inputs = QFrame()
        inputs.setObjectName("workspacePanel")
        input_layout = QVBoxLayout(inputs)
        input_layout.addWidget(self._eyebrow("游戏与输入测试"))
        grid = QGridLayout()
        self.input_target = QComboBox()
        self.input_target.addItems(("PC", "PYNQ", "PC + PYNQ"))
        self.x_input = QSpinBox()
        self.x_input.setRange(0, 319)
        self.x_input.setValue(160)
        self.y_input = QSpinBox()
        self.y_input.setRange(0, 179)
        self.y_input.setValue(90)
        self.fist_button = QPushButton("输入握拳")
        self.fist_button.clicked.connect(self.inject_fist)
        self.frequency_input = QDoubleSpinBox()
        self.frequency_input.setRange(20.0, 20_000.0)
        self.frequency_input.setValue(440.0)
        self.frequency_input.setSuffix(" Hz")
        self.duration_input = QSpinBox()
        self.duration_input.setRange(1, 60_000)
        self.duration_input.setValue(500)
        self.duration_input.setSuffix(" ms")
        self.tone_button = QPushButton("输入声音")
        self.tone_button.clicked.connect(self.inject_tone)
        grid.addWidget(self.input_target, 0, 0)
        grid.addWidget(QLabel("X"), 0, 1)
        grid.addWidget(self.x_input, 0, 2)
        grid.addWidget(QLabel("Y"), 0, 3)
        grid.addWidget(self.y_input, 0, 4)
        grid.addWidget(self.fist_button, 0, 5)
        grid.addWidget(QLabel("频率"), 1, 0)
        grid.addWidget(self.frequency_input, 1, 1, 1, 3)
        grid.addWidget(self.duration_input, 1, 4)
        grid.addWidget(self.tone_button, 1, 5)
        input_layout.addLayout(grid)
        row.addWidget(inputs, 2)
        return row

    def _build_content_tabs(self) -> QTabWidget:
        self.view_tabs = QTabWidget()
        self.view_tabs.setObjectName("gameViewTabs")
        preview = QScrollArea()
        preview.setObjectName("gamePreviewScroll")
        preview.setWidgetResizable(True)
        preview.setFrameShape(QFrame.Shape.NoFrame)
        preview.setWidget(self._build_preview_page())
        self.view_tabs.addTab(preview, "游戏画面")
        self.code_editor = ProjectCodeEditor()
        self.code_editor.dirty_changed.connect(self._source_dirty_changed)
        self.view_tabs.addTab(self.code_editor, "游戏源代码")
        timeline = QScrollArea()
        timeline.setWidgetResizable(True)
        timeline.setWidget(self._build_timeline_page())
        self.view_tabs.addTab(timeline, "测试时间线")
        return self.view_tabs

    def _build_preview_page(self) -> QWidget:
        page = QWidget()
        page.setObjectName("gamePreviewPage")
        layout = QVBoxLayout(page)
        layout.setContentsMargins(0, 8, 0, 0)
        heading = QHBoxLayout()
        self.mode_label = self._eyebrow("GAME WORKSPACE / PYNQ HDMI")
        self.mode_label.hide()
        self.heading = QLabel("PYNQ Game Output")
        self.heading.setObjectName("sectionLabel")
        heading.addWidget(self.heading)
        heading.addStretch()
        self.status_label = self._eyebrow("HDMI OUT")
        heading.addWidget(self.status_label)
        layout.addLayout(heading)

        self.board_readout = QWidget()
        readout = QGridLayout(self.board_readout)
        readout.setContentsMargins(10, 6, 10, 6)
        readout.setHorizontalSpacing(12)
        readout.setVerticalSpacing(2)
        self.board_readout.setMaximumHeight(280)
        self.board_readout_values: dict[str, QLabel] = {}
        for index, (key, title) in enumerate((
            ("runtime_mode", "运行模式"), ("state", "状态"),
            ("game_tick", "Tick"), ("game_score", "得分"),
            ("accepted_input_id", "已接受输入"), ("consumed_input_id", "已消费输入"),
        )):
            name = QLabel(title)
            name.setObjectName("metricName")
            value = QLabel("--")
            value.setTextFormat(Qt.TextFormat.PlainText)
            value.setSizePolicy(QSizePolicy.Policy.Ignored, QSizePolicy.Policy.Preferred)
            value.setMinimumWidth(45)
            readout.addWidget(name, index // 2, (index % 2) * 2)
            readout.addWidget(value, index // 2, (index % 2) * 2 + 1)
            self.board_readout_values[key] = value
        self.board_source_label = QLabel("PYNQ / 等待回读")
        self.board_source_label.setObjectName("mutedLabel")
        self.board_source_label.setWordWrap(True)
        readout.addWidget(self.board_source_label, 3, 0, 1, 4)
        self.vision_readout = QWidget()
        vision_grid = QGridLayout(self.vision_readout)
        vision_grid.setContentsMargins(0, 6, 0, 0)
        vision_grid.setHorizontalSpacing(12)
        vision_grid.setVerticalSpacing(2)
        self.vision_readout_values: dict[str, QLabel] = {}
        for index, (key, title) in enumerate((
            ("mode", "视觉控制"), ("game_id", "消费游戏"),
            ("source_frame_id", "源帧"), ("ticks", "采样 / Scene tick"),
            ("gesture_direction", "分类 / 方向"), ("action", "输入 / 动作"),
            ("age", "源 / 本地年龄"), ("sink", "Scene 回执"),
            ("identity", "源 run / epoch"), ("scene_sha256", "Scene SHA"),
            ("audio_recognition", "声音识别"), ("audio_approval", "策略批准"),
            ("audio_effects", "游戏声音效果"), ("audio_sink", "声音 Scene"),
            ("volume_identity", "音量源 / 事件"), ("volume_chain", "ACK / 消费 / 执行"),
            ("volume_effects", "音量游戏效果"), ("volume_sink", "音量 Scene"),
        )):
            name = QLabel(title)
            name.setObjectName("metricName")
            value = QLabel("--")
            value.setTextFormat(Qt.TextFormat.PlainText)
            value.setSizePolicy(QSizePolicy.Policy.Ignored, QSizePolicy.Policy.Preferred)
            value.setMinimumWidth(45)
            name.setMinimumHeight(name.fontMetrics().height() + 2)
            value.setMinimumHeight(value.fontMetrics().height() + 2)
            vision_grid.addWidget(name, index // 2, (index % 2) * 2)
            vision_grid.addWidget(value, index // 2, (index % 2) * 2 + 1)
            self.vision_readout_values[key] = value
        readout.addWidget(self.vision_readout, 4, 0, 1, 4)
        self.vision_readout.hide()
        layout.addWidget(self.board_readout)

        viewport_panel = QFrame()
        self.viewport_panel = viewport_panel
        viewport_panel.setObjectName("viewportPanel")
        viewport_layout = QVBoxLayout(viewport_panel)
        self.viewport = InteractiveGameViewport()
        self.viewport.setSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Expanding)
        self.viewport.logical_position_changed.connect(self._set_logical_position)
        viewport_layout.addWidget(self.viewport, 1)
        self.controls_widget = QWidget()
        controls = QHBoxLayout(self.controls_widget)
        controls.setContentsMargins(0, 0, 0, 0)
        self.reset_button = self._tool_button(QStyle.StandardPixmap.SP_MediaStop, "复位")
        self.reset_button.clicked.connect(self.reset)
        self.play_button = self._tool_button(QStyle.StandardPixmap.SP_MediaPlay, "运行/暂停")
        self.play_button.setCheckable(True)
        self.play_button.clicked.connect(self.toggle_playback)
        self.step_button = self._tool_button(QStyle.StandardPixmap.SP_MediaSkipForward, "单步")
        self.step_button.clicked.connect(self.step_once)
        controls.addWidget(self.reset_button)
        controls.addWidget(self.play_button)
        controls.addWidget(self.step_button)
        self.progress = QProgressBar()
        self.progress.setTextVisible(False)
        controls.addWidget(self.progress, 1)
        self.position_label = QLabel("PYNQ / HDMI")
        controls.addWidget(self.position_label)
        viewport_layout.addWidget(self.controls_widget)
        layout.addWidget(viewport_panel, 1)

        actions = QGridLayout()
        self.x_input = QSpinBox()
        self.x_input.setRange(0, 319)
        self.x_input.setValue(160)
        self.y_input = QSpinBox()
        self.y_input.setRange(0, 179)
        self.y_input.setValue(90)
        self.hand_button = QPushButton("设置手部")
        self.hand_button.clicked.connect(self.inject_hand)
        self.gesture_button = self._tool_button(QStyle.StandardPixmap.SP_ArrowForward, "注入手势")
        self.gesture_button.setAccessibleName("注入手势")
        self.gesture_button.clicked.connect(self.inject_selected_gesture)
        self.fist_button = self.gesture_button
        self.gesture_group = QButtonGroup(self)
        self.gesture_buttons: dict[HandGesture, QToolButton] = {}
        gesture_choices = QWidget()
        choice_layout = QHBoxLayout(gesture_choices)
        choice_layout.setContentsMargins(0, 0, 0, 0)
        choice_layout.setSpacing(2)
        for gesture, label in GESTURE_LABELS.items():
            button = QToolButton()
            button.setText(label)
            button.setCheckable(True)
            button.setMinimumWidth(52)
            button.setFixedHeight(30)
            button.setToolTip(label)
            button.setAccessibleName(label)
            button.setProperty("gesture", gesture.value)
            self.gesture_group.addButton(button)
            self.gesture_buttons[gesture] = button
            choice_layout.addWidget(button)
        self.gesture_buttons[HandGesture.PAPER].setChecked(True)
        choice_layout.addStretch()
        self.gesture_readout = QLabel("手势 --  |  视觉待接入")
        self.gesture_readout.setObjectName("mutedLabel")
        self.gesture_readout.setWordWrap(True)
        self.frequency_input = QDoubleSpinBox()
        self.frequency_input.setRange(20.0, 20_000.0)
        self.frequency_input.setValue(440.0)
        self.frequency_input.setSuffix(" Hz")
        self.duration_input = QSpinBox()
        self.duration_input.setRange(1, 60_000)
        self.duration_input.setValue(500)
        self.duration_input.setSuffix(" ms")
        self.tone_button = QPushButton("音调")
        self.tone_button.clicked.connect(self.inject_tone)
        self.cancel_input_button = QPushButton("取消输入")
        self.cancel_input_button.clicked.connect(self.cancel_inputs)
        for label, widget, row, column, span in (
            ("X", self.x_input, 0, 0, 1),
            ("Y", self.y_input, 0, 2, 1),
            ("", self.hand_button, 2, 0, 1),
            ("", self.fist_button, 2, 2, 1),
            ("Hz", self.frequency_input, 3, 0, 3),
            ("时长", self.duration_input, 4, 0, 3),
            ("", self.tone_button, 5, 0, 1),
            ("", self.cancel_input_button, 5, 2, 1),
        ):
            if label:
                actions.addWidget(QLabel(label), row, column)
            actions.addWidget(widget, row, column + 1, 1, span)
        actions.addWidget(QLabel("手势"), 1, 0)
        actions.addWidget(gesture_choices, 1, 1, 1, 3)
        actions.addWidget(self.gesture_readout, 6, 0, 1, 4)
        self.telemetry_label = QLabel("FPS --  |  COMMANDS --  |  CRC --------")
        self.telemetry_label.setObjectName("mutedLabel")
        self.input_controls = QWidget()
        self.input_controls.setLayout(actions)
        self.input_controls.setMinimumHeight(self.input_controls.minimumSizeHint().height())
        layout.addWidget(self.input_controls)
        layout.addWidget(self.telemetry_label)
        return page

    def _build_timeline_page(self) -> QWidget:
        page = QWidget()
        layout = QVBoxLayout(page)
        layout.setContentsMargins(8, 8, 8, 8)
        identity = QHBoxLayout()
        identity.addWidget(QLabel("用例名称"))
        self.test_name_input = QLineEdit("Manual session")
        identity.addWidget(self.test_name_input, 1)
        identity.addWidget(QLabel("最大 Tick"))
        self.max_ticks_input = QSpinBox()
        self.max_ticks_input.setRange(1, MAX_TEST_TICKS)
        self.max_ticks_input.setValue(600)
        identity.addWidget(self.max_ticks_input)
        self.save_test_button = QPushButton("保存用例")
        self.save_test_button.clicked.connect(self.save_current_test_case)
        identity.addWidget(self.save_test_button)
        layout.addLayout(identity)

        event_tools = QHBoxLayout()
        event_tools.addWidget(self._eyebrow("输入事件"))
        event_tools.addWidget(QLabel("Tick"))
        self.event_tick_input = QSpinBox()
        self.event_tick_input.setRange(0, 1_000_000)
        event_tools.addWidget(self.event_tick_input)
        for label, kind in (
            ("添加手势", InputKind.GESTURE),
            ("添加音调", InputKind.TONE),
            ("添加取消", InputKind.CANCEL),
        ):
            button = QPushButton(label)
            button.clicked.connect(
                lambda _checked=False, current=kind: self._add_timeline_event(current)
            )
            event_tools.addWidget(button)
        volume_button = QToolButton()
        volume_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaVolume))
        volume_button.setToolTip("添加离线音量事件")
        volume_button.setPopupMode(QToolButton.ToolButtonPopupMode.InstantPopup)
        volume_menu = QMenu(volume_button)
        for kind in ("SOFT", "LOUD"):
            volume_menu.addAction(kind, lambda current=kind: self._add_timeline_event(InputKind.VOLUME, volume_kind=current))
        volume_button.setMenu(volume_menu)
        event_tools.addWidget(volume_button)
        self.delete_event_button = QPushButton("删除事件")
        self.delete_event_button.clicked.connect(self._delete_selected_event)
        event_tools.addWidget(self.delete_event_button)
        event_tools.addStretch()
        layout.addLayout(event_tools)
        self.timeline_table = QTableWidget(0, 4)
        self.timeline_table.setHorizontalHeaderLabels(("Tick", "类型", "参数 JSON", "事件 ID"))
        self.timeline_table.horizontalHeader().setStretchLastSection(True)
        layout.addWidget(self.timeline_table, 2)

        assertion_tools = QHBoxLayout()
        assertion_tools.addWidget(self._eyebrow("逐帧断言"))
        self.add_assertion_button = QPushButton("添加断言")
        self.add_assertion_button.clicked.connect(self._add_assertion_row)
        self.delete_assertion_button = QPushButton("删除断言")
        self.delete_assertion_button.clicked.connect(self._delete_selected_assertion)
        assertion_tools.addWidget(self.add_assertion_button)
        assertion_tools.addWidget(self.delete_assertion_button)
        assertion_tools.addStretch()
        layout.addLayout(assertion_tools)
        self.assertion_table = QTableWidget(0, 5)
        self.assertion_table.setHorizontalHeaderLabels(
            ("Tick", "字段", "比较", "期望 JSON", "失败说明")
        )
        self.assertion_table.horizontalHeader().setStretchLastSection(True)
        layout.addWidget(self.assertion_table, 1)
        return page

    def current_test_case(self) -> GameTestCase:
        events = []
        for row in range(self.timeline_table.rowCount()):
            tick = int(self.timeline_table.item(row, 0).text())
            kind_item = self.timeline_table.item(row, 1)
            kind = InputKind(kind_item.data(Qt.ItemDataRole.UserRole) or kind_item.text())
            params = json.loads(self.timeline_table.item(row, 2).text() or "{}")
            events.append(
                InputEvent(
                    tick=tick,
                    kind=kind,
                    event_id=self.timeline_table.item(row, 3).text(),
                    x=params.get("x"),
                    y=params.get("y"),
                    frequency_hz=params.get("frequency_hz"),
                    duration_ms=params.get("duration_ms"),
                    gesture=HandGesture(params["gesture"]) if params.get("gesture") is not None else None,
                    voice_events=tuple(params.get("voice_events", ())),
                    voice_status=params.get("voice_status"),
                    volume=VolumeSignal(**params["volume"]) if params.get("volume") is not None else None,
                )
            )
        assertions = []
        for row in range(self.assertion_table.rowCount()):
            expected_text = self.assertion_table.item(row, 3).text()
            try:
                expected = json.loads(expected_text)
            except json.JSONDecodeError:
                expected = expected_text
            assertions.append(
                AssertionRule(
                    tick=int(self.assertion_table.item(row, 0).text()),
                    field=self.assertion_table.item(row, 1).text(),
                    operator=AssertionOperator(self.assertion_table.item(row, 2).text()),
                    expected=expected,
                    message=self.assertion_table.item(row, 4).text(),
                )
            )
        events.sort(key=lambda event: event.tick)
        assertions.sort(key=lambda rule: rule.tick)
        selected = self.test_case_list.currentItem()
        test_id = "manual-session"
        if selected is not None and selected.data(Qt.ItemDataRole.UserRole):
            test_id = Path(selected.data(Qt.ItemDataRole.UserRole)).stem
        loaded = getattr(self, "_loaded_test_case", None)
        return GameTestCase(
            test_id=test_id,
            name=self.test_name_input.text().strip() or "Manual session",
            seed=loaded.seed if loaded is not None else 0,
            max_ticks=self.max_ticks_input.value(),
            events=tuple(events),
            assertions=tuple(assertions),
            schema_version=(4 if any(event.kind is InputKind.VOLUME for event in events) else
                            loaded.schema_version if loaded is not None else None),
            tick_timestamps_ns=loaded.tick_timestamps_ns if loaded is not None else (),
        )

    def save_current_test_case(self) -> Path | None:
        if self._active_project is None:
            self._record_audit("test", "save", "pc", "failed", {"reason": "no project"})
            return None
        test_case = self.current_test_case()
        path = self._active_project / "tests" / "replays" / f"{test_case.test_id}.json"
        test_case.save(path)
        self._refresh_test_cases(select=path)
        self._record_audit(
            "test",
            "save",
            "pc",
            "ok",
            {"path": str(path), "events": len(test_case.events), "assertions": len(test_case.assertions)},
        )
        return path

    def import_project(self, source: Path) -> Path:
        source = Path(source).resolve()
        manifest_path = source / "game.toml"
        if not manifest_path.is_file():
            raise ValueError("imported project has no game.toml")
        manifest = GameManifest.from_toml(manifest_path.read_bytes())
        destination = self.projects_root / manifest.game_id
        if destination.exists():
            raise FileExistsError(destination)
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copytree(source, destination)
        self._refresh_projects(select=destination)
        self._record_audit(
            "project", "import", "pc", "ok", {"source": str(source), "destination": str(destination)}
        )
        return destination

    def _prompt_import_project(self) -> None:
        source = QFileDialog.getExistingDirectory(self, "导入游戏工程", str(self.projects_root))
        if not source:
            return
        try:
            self.import_project(Path(source))
        except (OSError, ValueError) as error:
            self._record_audit("project", "import", "pc", "failed", {"error": str(error)})

    def _add_timeline_event(self, kind: InputKind, *, volume_kind: str = "SOFT") -> None:
        params: dict[str, object] = {}
        if kind in (InputKind.HAND, InputKind.FIST, InputKind.GESTURE):
            params = {"x": self.x_input.value(), "y": self.y_input.value()}
            if kind is InputKind.GESTURE:
                params["gesture"] = self.selected_gesture().value
        elif kind is InputKind.TONE:
            params = {
                "frequency_hz": self.frequency_input.value(),
                "duration_ms": self.duration_input.value(),
            }
        self._append_event_row(
            InputEvent(
                tick=self.event_tick_input.value(),
                kind=kind,
                event_id=uuid.uuid4().hex,
                x=params.get("x"),
                y=params.get("y"),
                frequency_hz=params.get("frequency_hz"),
                duration_ms=params.get("duration_ms"),
                gesture=HandGesture(params["gesture"]) if params.get("gesture") is not None else None,
                volume=VolumeSignal(self._timeline_volume_run, 1, self.event_tick_input.value() + 1,
                    volume_kind, (self.event_tick_input.value() + 1) * 977,
                    self.event_tick_input.value() + 1) if kind is InputKind.VOLUME else None,
            )
        )

    def _append_event_row(self, event: InputEvent) -> None:
        params = {
            key: value
            for key, value in {
                "x": event.x,
                "y": event.y,
                "frequency_hz": event.frequency_hz,
                "duration_ms": event.duration_ms,
                "gesture": None if event.gesture is None else event.gesture.value,
            }.items()
            if value is not None
        }
        if event.kind is InputKind.VOICE:
            params.update(voice_events=list(event.voice_events), voice_status=event.voice_status)
        if event.volume is not None:
            params["volume"] = asdict(event.volume)
        row = self.timeline_table.rowCount()
        self.timeline_table.insertRow(row)
        for column, value in enumerate(
            (event.tick, event.kind.value, json.dumps(params, sort_keys=True), event.event_id)
        ):
            self.timeline_table.setItem(row, column, QTableWidgetItem(str(value)))
        kind_item = self.timeline_table.item(row, 1)
        kind_item.setData(Qt.ItemDataRole.UserRole, event.kind.value)
        kind_item.setText(GESTURE_LABELS[event.gesture] if event.gesture is not None else "声音观察" if event.kind is InputKind.VOICE else INPUT_LABELS[event.kind])
        kind_item.setFlags(kind_item.flags() & ~Qt.ItemFlag.ItemIsEditable)

    def _add_assertion_row(self) -> None:
        row = self.assertion_table.rowCount()
        self.assertion_table.insertRow(row)
        values = (self.event_tick_input.value(), "status", "eq", '"RUNNING"', "")
        for column, value in enumerate(values):
            self.assertion_table.setItem(row, column, QTableWidgetItem(str(value)))

    def _delete_selected_event(self) -> None:
        row = self.timeline_table.currentRow()
        if row >= 0:
            self.timeline_table.removeRow(row)

    def _delete_selected_assertion(self) -> None:
        row = self.assertion_table.currentRow()
        if row >= 0:
            self.assertion_table.removeRow(row)

    def create_project(
        self,
        *,
        game_id: str,
        display_name: str,
        template: str = "blank",
    ) -> Path:
        project = GameProject.create(
            self.projects_root / game_id,
            game_id=game_id,
            display_name=display_name,
            template=template,
        )
        self._refresh_projects(select=project.root)
        self.log_requested.emit(f"创建游戏工程 {display_name}")
        return project.root

    def refresh_projects(self) -> None:
        self.code_editor.save_all()
        self._refresh_projects(select=self._active_project)
        self._record_audit(
            "project",
            "refresh",
            "pc",
            "ok",
            {"root": str(self.projects_root), "count": self.game_list.count()},
        )

    def set_device(self, device: RemoteDeviceSession | None) -> None:
        if self._device_thread is not None:
            raise RuntimeError("cannot replace the PYNQ device while a command is running")
        self.device = device
        self._last_pynq_snapshot = {}
        self.inspector.show_device({})
        self._refresh_board_readout()
        if device is not None:
            index = self.input_target.findData("pynq")
            if index >= 0:
                self.input_target.setCurrentIndex(index)
        self._refresh_action_states()

    def refresh_device_state(self) -> None:
        self._refresh_action_states()
        if self.device is None or self.device.snapshot.state is not DeviceState.READY:
            self.board_source_label.setText(
                "PYNQ / 历史快照 / 等待重新回读" if self._last_pynq_snapshot
                else "PYNQ / 未连接"
            )
            self.inspector.mark_device_historical()

    def _target_changed(self) -> None:
        target = str(self.input_target.currentData())
        self.pc_test_button.setText(
            {
                "pc": "运行 PC 测试",
                "pynq": "装载并运行",
                "compare": "装载并对照",
            }[target]
        )
        pynq = target == "pynq"
        self.board_readout.setVisible(target != "pc")
        self.viewport.setMinimumSize(320, 64)
        self.viewport.setMaximumHeight(64 if pynq else 16777215)
        self.viewport_panel.setMaximumHeight(116 if pynq else 16777215)
        self.telemetry_label.setVisible(not pynq)
        if pynq:
            self.content_splitter.setSizes((480, 180))
            self.inspector.setCurrentWidget(self.inspector.device_table)
            self.view_tabs.setCurrentIndex(0)
            self.heading.setText("PYNQ 控制与回读")
        else:
            self.inspector.setCurrentWidget(self.inspector.status_table)
            self.heading.setText("PC 参考预览" if target == "pc" else "PC / PYNQ 对照")
        page = self.view_tabs.widget(0)
        page.setMinimumHeight(page.minimumSizeHint().height())
        self._refresh_action_states()

    def _refresh_board_readout(self) -> None:
        for key, label in self.board_readout_values.items():
            value = self._last_pynq_snapshot.get(key)
            text = "--" if value is None else str(value)
            label.setToolTip(text)
            label.setText(label.fontMetrics().elidedText(
                text, Qt.TextElideMode.ElideRight, max(45, label.width())
            ))
        vision = self._last_pynq_snapshot.get("vision")
        vision = vision if isinstance(vision, dict) else {}
        capabilities = vision.get("input_capabilities")
        capabilities = capabilities if isinstance(capabilities, dict) else {}
        receipt = self._last_pynq_snapshot.get("vision_consumption")
        receipt = receipt if isinstance(receipt, dict) else {}
        self.vision_readout.setVisible(self._pynq_live or bool(vision) or bool(receipt))
        gesture = receipt.get("source_hand_gesture", receipt.get("hand_gesture"))
        gesture = {"fist": "石头", "scissors": "剪刀", "paper": "布"}.get(gesture, "--") if isinstance(gesture, str) else "--"
        valid = receipt.get("hand_valid")
        validity = "有效" if valid is True else "失效" if valid is False else "--"
        action = "动作" if receipt.get("action_consumed") is True else "无动作"
        completion = receipt.get("sink_completion")
        scene_sha = receipt.get("scene_sha256")
        confirmed = (completion == "confirmed" and type(receipt.get("sample_tick")) is int
                     and type(receipt.get("scene_tick")) is int and receipt["sample_tick"] >= 0
                     and receipt["sample_tick"] == receipt["scene_tick"]
                     and isinstance(scene_sha, str) and len(scene_sha) == 64
                     and all(value in "0123456789abcdefABCDEF" for value in scene_sha))
        mode = capabilities.get("mode")
        mode = mode if isinstance(mode, str) else None

        def field(key: str) -> str:
            value = receipt.get(key)
            return "--" if value is None else str(value)

        values = {
            "mode": {"games": "三游戏", "legacy_horizontal": "旧水平模式"}.get(mode, "未确认"),
            "game_id": receipt.get("game_id"), "source_frame_id": receipt.get("source_frame_id"),
            "ticks": f"{field('sample_tick')} / {field('scene_tick')}" if receipt else None,
            "gesture_direction": f"{gesture} / {field('source_direction')}" if receipt else None,
            "action": f"{validity} / {action} / {field('consumed_action_seq')}" if receipt else None,
            "age": f"{field('server_age_ms')} / {field('local_age_ms')} ms" if receipt else None,
            "sink": f"已确认 / {field('runtime_presented_frames')}" if confirmed else "待确认",
            "identity": f"{field('run_id')} / {field('config_epoch')}" if receipt else None,
            "scene_sha256": receipt.get("scene_sha256"),
        }
        audio = self._last_pynq_snapshot.get("audio_consumption")
        audio = audio if isinstance(audio, dict) else {}
        audio_tick = audio.get("sample_tick")
        audio_sha = audio.get("scene_sha256")
        audio_confirmed = audio.get("sink_completion") == "confirmed" and type(audio_tick) is int and audio_tick >= 0
        audio_confirmed = audio_confirmed and type(audio.get("scene_tick")) is int and audio_tick == audio.get("scene_tick") and isinstance(audio_sha, str) and len(audio_sha) == 64
        audio_confirmed = audio_confirmed and all(character in "0123456789abcdefABCDEF" for character in audio_sha)
        values.update(audio_recognition=json.dumps(audio.get("events", []), ensure_ascii=False) if audio else None,
                      audio_approval=json.dumps(audio.get("decisions", []), ensure_ascii=False) if audio.get("action_mapped") is True else "未映射",
                      audio_effects=json.dumps(audio.get("game_effects"), ensure_ascii=False) if audio.get("game_effects") is not None else None,
                      audio_sink=f"已确认 / tick {audio_tick}" if audio_confirmed else "待确认")
        volume = self._last_pynq_snapshot.get("volume_consumption")
        volume = volume if isinstance(volume, dict) else {}
        signal = volume.get("signal")
        valid_signal = None
        if isinstance(signal, dict):
            try:
                valid_signal = VolumeSignal(**signal)
            except (TypeError, ValueError):
                pass
        volume_tick, volume_sha = volume.get("sample_tick"), volume.get("scene_sha256")
        volume_confirmed = (valid_signal is not None and volume.get("sink_completion") == "confirmed" and type(volume_tick) is int
            and all(volume.get(key) is True for key in ("hardware_acked", "logic_consumed", "logic_executed"))
            and volume_tick >= 0 and type(volume.get("scene_tick")) is int and volume_tick == volume["scene_tick"]
            and isinstance(volume_sha, str) and len(volume_sha) == 64
            and all(character in "0123456789abcdefABCDEF" for character in volume_sha)
            and isinstance(volume.get("game_run"), str) and bool(volume["game_run"])
            and (self._last_pynq_snapshot.get("scene_sha256") is None or self._last_pynq_snapshot["scene_sha256"] == volume_sha)
            and (receipt.get("game_run") is None or receipt["game_run"] == volume["game_run"])
            and (self._last_pynq_snapshot.get("game_id") is None or self._last_pynq_snapshot["game_id"] == volume.get("game_id")))
        values.update(volume_identity=None if valid_signal is None else
                      f"{valid_signal.kind} / {valid_signal.producer_run} / {valid_signal.epoch} / #{valid_signal.sequence}",
                      volume_chain=None if valid_signal is None else " / ".join(
                          "是" if volume.get(key) is True else "否" for key in ("hardware_acked", "logic_consumed", "logic_executed")),
                      volume_effects=json.dumps(volume.get("game_effects"), ensure_ascii=False) if volume else None,
                      volume_sink=f"已确认 / tick {volume_tick}" if volume_confirmed else "待确认")
        self.vision_readout.setVisible(self._pynq_live or bool(vision) or bool(receipt) or bool(audio) or bool(volume))
        for key, label in self.vision_readout_values.items():
            value = values[key]
            text = "--" if value is None else str(value)
            label.setToolTip(text)
            label.setText(label.fontMetrics().elidedText(
                text, Qt.TextElideMode.ElideRight, max(45, label.width())
            ))
        if self._pynq_live:
            self.gesture_readout.setText(
                f"本地视觉 / {gesture} / {validity} / tick {field('sample_tick')}"
                if receipt else "本地视觉 / 等待消费回执"
            )

    def build_active_project(self) -> Path | None:
        if self._active_project is None:
            return None
        self.code_editor.save_all()
        manifest = GameManifest.from_toml(
            (self._active_project / "game.toml").read_bytes()
        )
        build_id = None if self.device is None else getattr(
            self.device, "expected_build_id", self.device.snapshot.build_id
        )
        fusion = build_id in (0xC0060800, 0xC0060900, 0xC0060E00) and self.input_target.currentData() in ("pynq", "compare")
        suffix = f"-{build_id:08X}" if fusion else ""
        output = self.projects_root / ".build" / f"{manifest.game_id}-{manifest.version}{suffix}.vvg"
        options = {"target_build_id": build_id} if fusion else {}
        info = build_verified_game(self._active_project, output, **options)
        self._built_package = info.path
        self.progress.setRange(0, 100)
        self.progress.setValue(10)
        self.position_label.setText("VVG BUILT")
        self.status_label.setText("ENCODED")
        self._record_audit(
            "build",
            "vvg",
            "pc",
            "ok",
            {"path": info.path.name, "bytes": info.length, "sha256": info.sha256,
             "double_build_verified": True},
        )
        self._refresh_action_states()
        return info.path

    def start_project_preview(self) -> None:
        target = str(self.input_target.currentData())
        live = self.pynq_input_mode.currentData() == "vision"
        if live and target != "pynq":
            self._record_audit("run", "prepare", target, "rejected", {"reason": "live vision requires PYNQ target"})
            return
        try:
            test_case = self.current_test_case()
            package = self.build_active_project()
        except (OSError, ValueError, json.JSONDecodeError) as error:
            self._record_audit("run", "prepare", target, "failed", {"error": str(error)})
            return
        if package is None:
            self._record_audit("run", "prepare", target, "failed", {"reason": "no project"})
            return
        self._prepare_run()
        self.audit_console.set_summary(f"运行 {test_case.name} / {target.upper()}", passed=None)
        if target in ("pc", "compare"):
            self._start_pc_preview(package, test_case)
        if target in ("pynq", "compare"):
            if self.device is None:
                self._record_audit("run", "start", "pynq", "failed", {"reason": "device unavailable"})
            else:
                device = self.device
                self._submit_device_task(
                    "run",
                    progress_operation=lambda progress: self._validated_deploy(
                        device, package, test_case, progress=progress, run=True,
                        live=live,
                    ),
                    details={"test_id": test_case.test_id,
                             "game_id": validate_game_package(package).manifest.game_id},
                )
                self._record_audit(
                    "run", "start", "pynq", "submitted",
                    {"test_id": test_case.test_id, "max_ticks": test_case.max_ticks},
                )
        self._refresh_action_states()

    def start_project_play(self) -> None:
        if str(self.input_target.currentData()) != "pc":
            self._record_audit("run", "play", "pc", "rejected", {"reason": "select PC target"})
            return
        if self._preview_thread is not None:
            self._record_audit("run", "stop", "pc", "submitted", {})
            self.stop(wait=False)
            return
        try:
            package = self.build_active_project()
        except (OSError, ValueError) as error:
            self._record_audit("run", "prepare", "pc", "failed", {"error": str(error)})
            return
        if package is None:
            return
        self._prepare_run()
        seed = secrets.randbits(32)
        self.audit_console.set_summary(f"PC 交互试玩 / Seed {seed}", passed=None)
        self._start_pc_preview(package, seed=seed)
        self._refresh_action_states()

    def _prepare_run(self) -> None:
        self.stop(wait=True)
        self._pynq_live = False
        self._run_id = uuid.uuid4().hex[:12]
        self._assertion_passed = 0
        self._assertion_failed = 0
        self._last_pc_frame = None
        self._last_pynq_snapshot = {}
        self._refresh_board_readout()
        self.board_source_label.setText("PYNQ / 等待本次运行回读")
        self._pc_test_complete = False
        self._pynq_test_complete = False
        self._comparison_reported = False
        self._last_pc_report = None
        self._last_pynq_report = None
        self.controls_widget.show()
        self.progress.setRange(0, 100)
        self.progress.setValue(10)
        self.position_label.setText("PREPARING")

    def _start_pc_preview(self, package: Path, test_case: GameTestCase | None = None, *, seed: int = 0) -> None:
        self._preview_stopping = False
        thread = QThread(self)
        worker = GamePreviewWorker(package, seed=seed)
        if test_case is not None:
            worker.load_test_case(test_case)
        worker.moveToThread(thread)
        thread.started.connect(worker.run)
        worker.ready.connect(self._preview_ready)
        worker.frame_ready.connect(self._show_project_frame)
        worker.audit_event.connect(self._accept_audit_event)
        worker.input_consumed.connect(self._show_input_state)
        worker.assertion_result.connect(self._accept_assertion_result)
        worker.state_changed.connect(self._preview_state_changed)
        worker.test_report_ready.connect(self._accept_test_report)
        worker.failed.connect(self._preview_failed)
        worker.finished.connect(thread.quit)
        worker.finished.connect(worker.deleteLater)
        thread.finished.connect(self._preview_finished)
        self._preview_thread = thread
        self._preview_worker = worker
        thread.start()
        self.status_label.setText("STARTING")
        self.play_button.setChecked(True)
        self._record_audit(
            "run",
            "start",
            "pc",
            "submitted",
            {"test_id": test_case.test_id, "max_ticks": test_case.max_ticks, "seed": test_case.seed, "mode": "test"}
            if test_case is not None else {"seed": seed, "mode": "interactive"},
        )

    def inject_hand(self) -> None:
        self.inject_selected_gesture()

    def inject_fist(self) -> None:
        self.gesture_buttons[HandGesture.FIST].setChecked(True)
        self.inject_selected_gesture()

    def selected_gesture(self) -> HandGesture:
        return HandGesture(self.gesture_group.checkedButton().property("gesture"))

    def inject_selected_gesture(self) -> None:
        if self._pynq_live:
            self._record_audit("input", "gesture", "pynq", "rejected", {"reason": "live vision owns input"})
            return
        worker = self._preview_worker
        target = str(self.input_target.currentData())
        x = self.x_input.value()
        y = self.y_input.value()
        input_id = uuid.uuid4().hex
        gesture = self.selected_gesture()
        details = {"input_id": input_id, "x": x, "y": y, "gesture": gesture.value}
        if worker is not None and target in ("pc", "compare"):
            worker.inject_gesture(x=x, y=y, gesture=gesture, input_id=input_id)
            self.gesture_readout.setText(f"PC 手动 / 待消费：{GESTURE_LABELS[gesture]}")
        if self.device is not None and target in ("pynq", "compare"):
            self._submit_device_task(
                "input:gesture",
                lambda: self.device.inject_game_input(
                    x=x, y=y, gesture=gesture.value, input_id=input_id
                ),
                details=details,
            )
            self.gesture_readout.setText(f"PYNQ 软件调试 / 待回执：{GESTURE_LABELS[gesture]}")
            self._record_audit("input", "gesture", "pynq", "submitted", details)

    def _show_input_state(self, game_input: GameInput, source: str) -> None:
        label = GESTURE_LABELS.get(game_input.hand_gesture, "未识别" if game_input.has_gesture_input else "旧版手部")
        self.gesture_readout.setText(f"{source} / 已消费：{label}  |  Tick {game_input.tick_id}")

    def inject_tone(self) -> None:
        if self._pynq_live:
            self._record_audit("input", "tone", "pynq", "rejected", {"reason": "live vision owns input"})
            return
        worker = self._preview_worker
        target = str(self.input_target.currentData())
        frequency_hz = self.frequency_input.value()
        duration_ms = self.duration_input.value()
        input_id = uuid.uuid4().hex
        if worker is not None and target in ("pc", "compare"):
            worker.inject_tone(
                frequency_hz=frequency_hz,
                duration_ms=duration_ms,
                input_id=input_id,
            )
        details = {
            "input_id": input_id,
            "frequency_hz": frequency_hz,
            "duration_ms": duration_ms,
        }
        if self.device is not None and target in ("pynq", "compare"):
            self._submit_device_task(
                "input:tone",
                lambda: self.device.inject_game_input(
                    frequency_hz=frequency_hz,
                    duration_ms=duration_ms,
                    input_id=input_id,
                ),
                details=details,
            )
            self._record_audit("input", "tone", "pynq", "submitted", details)

    def cancel_inputs(self) -> None:
        self.gesture_readout.setText("手势 --  |  已取消")
        target = str(self.input_target.currentData())
        if self._preview_worker is not None and target in ("pc", "compare"):
            self._preview_worker.cancel_inputs()
        if self.device is not None and target in ("pynq", "compare"):
            self._submit_device_task("input:cancel", self.device.cancel_game_input)
            self._record_audit("input", "cancel", "pynq", "submitted", {})

    def install_active_project(self) -> None:
        if self.device is None or self._built_package is None:
            self._record_audit("deploy", "install", "pynq", "failed", {"reason": "device or package unavailable"})
            return
        package = self._built_package
        try:
            test_case = self.current_test_case()
        except (ValueError, KeyError, json.JSONDecodeError) as error:
            self._record_audit("deploy", "prepare", "pynq", "failed", {"error": str(error)})
            return
        device = self.device
        self._run_id = uuid.uuid4().hex[:12]
        self._submit_device_task(
            "install",
            progress_operation=lambda progress: self._validated_deploy(
                device, package, test_case, progress=progress, run=False,
            ),
            details={"path": package.name},
        )
        self._record_audit("deploy", "install", "pynq", "submitted", {"path": package.name})

    def _validated_deploy(
        self, device: RemoteDeviceSession, package: Path, test_case: GameTestCase,
        *, progress: Callable[[int, int], None], run: bool,
        live: bool = False,
    ) -> dict[str, Any]:
        with TemporaryDirectory(prefix="voice-view-deploy-") as directory:
            staged = Path(directory) / "validated.vvg"
            shutil.copyfile(package, staged)
            report = run_game_test(staged, test_case, stop_event=self._validation_stop)
            report.save(self._report_path(report.package.manifest.game_id, report.run_id, "pc"))
            self.test_report_ready.emit(report)
            if not report.passed or self._validation_stop.is_set():
                raise RuntimeError("PC validation failed or cancelled; PYNQ upload was blocked")
            current = validate_game_package(package)
            if (current.sha256, current.length) != (report.package.sha256, report.package.length):
                raise RuntimeError("VVG changed after PC validation; PYNQ upload was blocked")
            if current.manifest.volume_inputs is not None and live:
                device.require_volume_input()
            install = device.install_game(staged, progress=progress)
            if not run:
                return install
            if self._validation_stop.is_set():
                raise RuntimeError("deployment cancelled after installation; game start was blocked")
            contract = current.manifest.volume_inputs or current.manifest.inputs
            vision = device.start_shared_vision(stop_event=self._validation_stop,
                game_id=contract.vision_mapping if contract is not None else current.manifest.game_id) if live else None
            if self._validation_stop.is_set():
                raise RuntimeError("deployment cancelled before game start")
            return {"install": install, "vision": vision, "live": live, "run": device.run_game(
                current.manifest.game_id, test_case_json=None if live else test_case.to_json(),
            )}

    def _report_path(self, game_id: str, run_id: str, target: str) -> Path:
        return self.projects_root / ".reports" / game_id / f"{run_id}-{target}.json"

    @Slot(object)
    def _accept_preflight_report(self, report: GameTestReport) -> None:
        self._accept_test_report(report, preflight=True)

    @Slot(object)
    def _accept_test_report(self, report: GameTestReport, *, preflight: bool = False) -> None:
        payload = report.to_dict()
        path = self._report_path(report.package.manifest.game_id, report.run_id, report.target)
        try:
            report.save(path)
        except OSError as error:
            self._record_audit("report", "save", report.target, "failed", {"error": str(error)})
            return
        if report.target == "pc" and (
            not preflight or str(self.input_target.currentData()) != "compare"
        ):
            self._last_pc_report = payload
            self._pc_test_complete = report.completed
        if not preflight:
            self.audit_console.set_summary(
                f"PC {payload['status'].upper()} / {payload['coverage']} / {len(report.frames)} tick",
                passed=report.passed,
            )
        self._record_audit(
            "report", "save", report.target, payload["status"],
            {"path": str(path), "sha256": report.package.sha256,
             "test_sha256": payload["test_sha256"], "coverage": payload["coverage"],
             "interactive": payload["interactive"], "errors": payload["errors"],
             "purpose": "preflight" if preflight else "run"},
        )
        self._report_comparison_if_ready()

    def _run_device_action(self, action: str) -> None:
        if self.device is None:
            self._record_audit("device", action, "pynq", "failed", {"reason": "not configured"})
            return
        operations = {
            "test": self.device.video_status,
            "clear": self.device.clear_shell_state,
            "initialize": self.device.initialize_shell,
        }
        operation = operations.get(action)
        if operation is None:
            self._record_audit("device", action, "pynq", "failed", {"reason": "unknown action"})
            return
        self._submit_device_task(f"device:{action}", operation)
        self._record_audit("device", action, "pynq", "submitted", {})

    def _submit_device_task(
        self,
        action: str,
        operation: Callable[[], object] | None = None,
        *,
        progress_operation: Callable[[Callable[[int, int], None]], object] | None = None,
        details: dict[str, object] | None = None,
    ) -> bool:
        if self._device_thread is not None:
            self._record_audit(
                "device", action, "pynq", "rejected", {"reason": "another command is running"}
            )
            return False
        thread = QThread(self)
        worker = DeviceTaskWorker(action, operation, progress_operation)
        worker.moveToThread(thread)
        thread.started.connect(worker.run)
        worker.progress_changed.connect(self._device_task_progress)
        worker.completed.connect(self._device_task_completed)
        worker.failed.connect(self._device_task_failed)
        worker.finished.connect(thread.quit)
        worker.finished.connect(worker.deleteLater)
        thread.finished.connect(self._device_task_finished)
        self._device_thread = thread
        self._device_worker = worker
        self._device_task_details = dict(details or {})
        if action != "poll":
            self.activity_changed.emit("Game / PYNQ", f"{action} 已提交", "waiting", None)
        if action in ("run", "install"):
            self._validation_stop.clear()
            self.status_label.setText("PC VALIDATING")
            self.activity_changed.emit("Game / PC", "部署前验证", "waiting", None)
        thread.start()
        self._refresh_action_states()
        return True

    def _device_task_progress(self, action: str, received: int, total: int) -> None:
        percent = 100 if total == 0 else round(received * 100 / total)
        self.progress.setRange(0, 100)
        self.progress.setValue(10 + round(percent * 0.65))
        self.position_label.setText(f"UPLOAD {received:,} / {total:,} B")
        self.status_label.setText("UPLOADING")
        self.activity_changed.emit(
            "Game / PYNQ", f"上传 {received:,} / {total:,} B", "waiting", None
        )

    def _device_task_completed(self, action: str, result: object) -> None:
        response = result if isinstance(result, dict) else {}
        if action == "run":
            self._pynq_live = response.get("live") is True
            run_result = response.get("run", {}) if isinstance(response, dict) else {}
            snapshot = run_result.get("snapshot", {}) if isinstance(run_result, dict) else {}
            self._pynq_running = True
            self._pynq_paused = False
            self._pynq_status_timer.start()
            self.progress.setValue(100)
            self.position_label.setText("INSTALLED / RUNNING")
            self.status_label.setText("PYNQ RUNNING")
            self._record_audit("run", "start", "pynq", "accepted", self._device_task_details)
            self._apply_pynq_snapshot(snapshot)
        else:
            snapshot = response.get("snapshot", {}) if isinstance(response, dict) else {}
            if action.startswith("input:"):
                category, audit_action = "input", action.split(":", 1)[1]
                self._record_audit(category, audit_action, "pynq", "accepted", self._device_task_details)
                self._apply_pynq_snapshot(snapshot)
            elif action.startswith("control:"):
                audit_action = action.split(":", 1)[1]
                self._record_audit("run", audit_action, "pynq", "ok", self._device_task_details)
                self._apply_pynq_snapshot(snapshot)
            elif action.startswith("device:"):
                audit_action = action.split(":", 1)[1]
                self._record_audit("device", audit_action, "pynq", "ok", {"snapshot": snapshot})
                self._apply_pynq_snapshot(snapshot)
            elif action == "install":
                self.progress.setValue(100)
                self.position_label.setText("LIBRARY VERIFIED")
                self.status_label.setText("INSTALLED")
                self._record_audit("deploy", "install", "pynq", "ok", self._device_task_details)
            elif action == "poll":
                self._apply_pynq_snapshot(snapshot)
        if action != "poll":
            self.activity_changed.emit("Game / PYNQ", f"{action} 完成", "success", None)

    def _device_task_failed(self, action: str, message: str) -> None:
        category = "input" if action.startswith("input:") else "device"
        audit_action = action.split(":", 1)[-1]
        if action == "run":
            category = "run"
        elif action == "install":
            category = "deploy"
        self.status_label.setText("DEVICE ERROR")
        self._record_audit(
            category,
            audit_action,
            "pynq",
            "failed",
            {**self._device_task_details, "error": message},
        )
        self.activity_changed.emit("Game / PYNQ", f"{action}: {message}", "error", None)
        self.board_source_label.setText("PYNQ / 最近请求失败 / 保留上次回读")
        self.inspector.mark_device_historical()

    def _device_task_finished(self) -> None:
        thread = self._device_thread
        self._device_thread = None
        self._device_worker = None
        self._device_task_details = {}
        if thread is not None:
            thread.deleteLater()
        self._refresh_action_states()

    def _poll_pynq_status(self) -> None:
        if self.device is None or not self._pynq_running or self._device_thread is not None:
            return
        self._submit_device_task("poll", self.device.video_status)

    def _apply_pynq_snapshot(self, snapshot: dict[str, Any]) -> None:
        if not snapshot:
            return
        self._last_pynq_snapshot = dict(snapshot)
        if "vision_consumption" in snapshot or snapshot.get("runtime_mode") == "menu":
            self._pynq_live = (snapshot.get("profile") in ("C6I_VISION", "C6I_VISION_VOICE_S3", "C6I_PL_VISION_VOLUME_OSD_V1")
                               and snapshot.get("runtime_mode") == "game"
                               and isinstance(snapshot.get("vision_consumption"), dict))
        remote_report = snapshot.get("game_test_report")
        if isinstance(remote_report, dict) and remote_report != self._last_pynq_report:
            try:
                manifest = GameManifest(**remote_report["package"]["manifest"])
                path = self._report_path(manifest.game_id, self._run_id or "readout", "pynq")
                save_test_report({**remote_report, "device_build_id": self.device.snapshot.build_id
                                  if self.device is not None else None}, path)
                self._last_pynq_report = remote_report
                self._record_audit("report", "save", "pynq", str(remote_report.get("status")),
                                   {"path": str(path), "sha256": remote_report["package"]["sha256"]})
            except (KeyError, TypeError, ValueError, OSError) as error:
                self._record_audit("report", "save", "pynq", "failed", {"error": str(error)})
        self.inspector.show_device({key: value for key, value in snapshot.items()
                        if key != "game_test_report"})
        volume = snapshot.get("volume_consumption")
        if isinstance(volume, dict) and volume.get("signal") is not None:
            identity = (volume.get("game_run"), volume.get("sample_tick"), volume.get("scene_sha256"))
            if identity != self._last_volume_receipt_identity:
                self._last_volume_receipt_identity = identity
                self._record_audit("volume", "scene", "pynq", str(volume.get("sink_completion", "pending")),
                                   volume, tick=volume.get("sample_tick"))
        self._refresh_board_readout()
        self.board_source_label.setText("PYNQ / 最近命令或状态查询回执")
        self.status_label.setText(f"PYNQ {str(snapshot.get('state', '--')).upper()}")
        self.activity_changed.emit("Game / PYNQ", "", "muted", dict(snapshot))
        state = str(snapshot.get("state", ""))
        self._pynq_paused = state == "paused"
        self._pynq_running = snapshot.get("runtime_mode") == "game"
        accepted = snapshot.get("accepted_input_id")
        consumed = snapshot.get("consumed_input_id")
        tick = snapshot.get("game_tick")
        if isinstance(accepted, str) and accepted != self._last_pynq_accepted_input_id:
            self._last_pynq_accepted_input_id = accepted
            self._record_audit(
                "input", "accept", "pynq", "accepted", {"input_id": accepted}, tick=tick
            )
        if isinstance(consumed, str) and consumed != self._last_pynq_consumed_input_id:
            self._last_pynq_consumed_input_id = consumed
            self._record_audit(
                "input", "consume", "pynq", "consumed", {"input_id": consumed}, tick=tick
            )
        if snapshot.get("test_complete") is True or (
            self._last_pynq_report is not None and self._last_pynq_report.get("status") == "failed"
        ):
            self._pynq_test_complete = True
            self._pynq_status_timer.stop()
            passed = int(snapshot.get("assertions_passed") or 0)
            failed = int(snapshot.get("assertions_failed") or 0)
            verified = self._last_pynq_report is not None and self._last_pynq_report.get("status") == "passed"
            result = "passed" if verified else "failed" if self._last_pynq_report else "pending"
            self.audit_console.set_summary(
                f"PYNQ {result.upper()}：{passed} 条断言通过，{failed} 条失败",
                passed=verified if self._last_pynq_report is not None else None,
            )
            self._record_audit(
                "run",
                "complete",
                "pynq",
                result,
                {"assertions_passed": passed, "assertions_failed": failed},
                tick=tick,
            )
            self._report_comparison_if_ready()

    def _report_comparison_if_ready(self) -> None:
        if (
            self._comparison_reported
            or str(self.input_target.currentData()) != "compare"
            or not self._pc_test_complete
            or not self._pynq_test_complete
        ):
            return
        if self._last_pc_report is None:
            return
        comparison = {"status": "pending", "reason": "PYNQ test report is unavailable"} if (
            self._last_pynq_report is None
        ) else compare_test_reports(self._last_pc_report, self._last_pynq_report)
        manifest = self._last_pc_report["package"]["manifest"]
        path = self._report_path(manifest["game_id"], self._run_id, "compare")
        try:
            save_test_report({
                "schema_version": 1, "run_id": self._run_id,
                "comparison": comparison, "pc_report": self._last_pc_report,
                "pynq_report": self._last_pynq_report,
                "hardware_acceptance": "pending",
            }, path)
        except OSError as error:
            self._record_audit("report", "save", "compare", "failed", {"error": str(error)})
            return
        self._comparison_reported = True
        self._record_audit(
            "comparison",
            "tick-trace",
            "compare",
            comparison["status"],
            {**comparison, "path": str(path)},
            tick=comparison.get("first_divergent_tick"),
        )
        self.audit_console.set_summary(
            f"PC / PYNQ {str(comparison['status']).upper()}",
            passed=None if comparison["status"] == "pending" else comparison["status"] == "passed",
        )

    def stop(self, *, wait: bool) -> None:
        self._validation_stop.set()
        worker = self._preview_worker
        thread = self._preview_thread
        if thread is not None:
            self._preview_stopping = True
            self.status_label.setText("STOPPING")
        if worker is not None:
            worker.stop()
        if wait and thread is not None and thread.isRunning():
            thread.quit()
            if not thread.wait(3000):
                self._refresh_action_states()
                raise RuntimeError("PC preview did not stop before timeout")
        device_thread = self._device_thread
        if wait and device_thread is not None and device_thread.isRunning():
            device_thread.quit()
            device_thread.wait(3000)
        if wait or thread is None:
            self._preview_finished()
        self._refresh_action_states()

    def toggle_playback(self, checked: bool) -> None:
        target = str(self.input_target.currentData())
        handled = False
        if self._preview_worker is not None and target in ("pc", "compare"):
            if checked:
                self._preview_worker.resume()
            else:
                self._preview_worker.pause()
            handled = True
        if self.device is not None and self._pynq_running and target in ("pynq", "compare"):
            action = "resume" if checked else "pause"
            operation = self.device.resume_game if checked else self.device.pause_game
            self._submit_device_task(f"control:{action}", operation)
            handled = True
        if handled:
            return
        self.play_button.setChecked(False)

    def step_once(self) -> None:
        target = str(self.input_target.currentData())
        handled = False
        if self._preview_worker is not None and target in ("pc", "compare"):
            self.play_button.setChecked(False)
            self._preview_worker.step_once()
            handled = True
        if self.device is not None and self._pynq_running and target in ("pynq", "compare"):
            self.play_button.setChecked(False)
            self._submit_device_task("control:step", self.device.step_game)
            handled = True
        if handled:
            return
        self.play_button.setChecked(False)

    def reset(self) -> None:
        self.gesture_readout.setText("手势 --  |  复位")
        target = str(self.input_target.currentData())
        handled = False
        if self._preview_worker is not None and target in ("pc", "compare"):
            self.play_button.setChecked(False)
            self._preview_worker.reset()
            handled = True
        if self.device is not None and self._pynq_running and target in ("pynq", "compare"):
            self.play_button.setChecked(False)
            self._submit_device_task("control:reset", self.device.reset_game)
            handled = True
        if handled:
            return
        self.play_button.setChecked(False)

    def show_pynq_output(self) -> None:
        self.stop(wait=True)
        self.timer.stop()
        self.play_button.setChecked(False)
        self.session = None
        self._image = QImage()
        self.viewport.clear_frame(
            "PYNQ-Z2 GAME OUTPUT\nHDMI 输出 / 画面在外接显示器"
        )
        self.mode_label.setText("GAME WORKSPACE / PYNQ HDMI")
        self.heading.setText("PYNQ 控制与回读")
        self.status_label.setText("HDMI OUT")
        self.controls_widget.hide()
        self._refresh_action_states()

    def _select_game(self) -> None:
        item = self.game_list.currentItem()
        if item is None:
            return
        value = item.data(Qt.ItemDataRole.UserRole)
        project = Path(value)
        self.timer.stop()
        self.session = None
        self._active_project = project
        self._built_package = None
        self.install_button.setEnabled(False)
        self.code_editor.open_project(project)
        self._refresh_test_cases()
        self.heading.setText(item.text())
        self.status_label.setText("SOURCE READY")
        self.view_tabs.setCurrentIndex(0)
        self._refresh_action_states()

    def _refresh_projects(self, *, select: Path | None = None) -> None:
        self.game_list.blockSignals(True)
        self.game_list.clear()
        preferred_item: QListWidgetItem | None = None
        if self.projects_root.is_dir():
            for manifest_path in sorted(self.projects_root.glob("*/game.toml")):
                try:
                    manifest = GameManifest.from_toml(manifest_path.read_bytes())
                except ValueError:
                    continue
                item = QListWidgetItem(f"{manifest.display_name}\n{manifest.version}")
                item.setData(Qt.ItemDataRole.UserRole, str(manifest_path.parent.resolve()))
                self.game_list.addItem(item)
                if select is not None and manifest_path.parent.resolve() == select.resolve():
                    preferred_item = item
        if preferred_item is None and self.game_list.count() > 0:
            preferred_item = self.game_list.item(0)
        if preferred_item is not None:
            self.game_list.setCurrentItem(preferred_item)
        self.game_list.blockSignals(False)
        if preferred_item is not None:
            self._select_game()

    def _prompt_new_project(self) -> None:
        game_id, accepted = QInputDialog.getText(self, "新建游戏", "游戏 ID")
        if not accepted or not game_id:
            return
        display_name, accepted = QInputDialog.getText(self, "新建游戏", "显示名称")
        if not accepted or not display_name:
            return
        template_name, accepted = QInputDialog.getItem(
            self,
            "新建游戏",
            "项目模板",
            ("空白 GamePlugin", "横版动作引擎"),
            editable=False,
        )
        if accepted:
            template = "side-scroller" if template_name == "横版动作引擎" else "blank"
            self.create_project(
                game_id=game_id,
                display_name=display_name,
                template=template,
            )

    def _source_dirty_changed(self, dirty: bool) -> None:
        if dirty:
            self._built_package = None
            self.install_button.setEnabled(False)
            self.status_label.setText("MODIFIED")
        self._refresh_action_states()

    def _preview_ready(self, info: object) -> None:
        if self._preview_stopping:
            return
        self.mode_label.setText("GAME WORKSPACE / PC PACKAGE PREVIEW")
        self.status_label.setText("RUNNING")
        self.controls_widget.show()
        self.view_tabs.setCurrentIndex(0)
        self._record_audit("run", "ready", "pc", "ok", {"package": str(info)})
        self._refresh_action_states()

    def _show_project_frame(self, frame: GameFrame) -> None:
        self._last_pc_frame = frame
        self._image = rgb_to_qimage(frame.rgb)
        self._refresh_pixmap()
        self.inspector.show_frame(frame)
        self.telemetry_label.setText(
            f"TICK {frame.snapshot.tick_id}  |  COMMANDS {frame.command_count}  |  CRC {frame.frame_crc32:08X}"
        )

    def _preview_failed(self, message: str) -> None:
        self.status_label.setText("ERROR")
        self._record_audit("run", "worker", "pc", "failed", {"error": message})
        self.audit_console.set_summary(f"运行失败: {message}", passed=False)

    def _preview_finished(self) -> None:
        sender = self.sender()
        if isinstance(sender, QThread) and sender is not self._preview_thread:
            return
        thread = self._preview_thread
        if self._preview_stopping:
            self.status_label.setText("STOPPED")
        self._preview_worker = None
        self._preview_thread = None
        self._preview_stopping = False
        if thread is not None:
            thread.deleteLater()
        self.play_button.setChecked(False)
        self._refresh_action_states()

    def _refresh_pixmap(self) -> None:
        if self._image.isNull():
            return
        self.viewport.set_frame(self._image)

    def _refresh_test_cases(self, *, select: Path | None = None) -> None:
        self.test_case_list.blockSignals(True)
        self.test_case_list.clear()
        manual = QListWidgetItem("Manual session / 未保存")
        manual.setData(Qt.ItemDataRole.UserRole, None)
        self.test_case_list.addItem(manual)
        if self._active_project is not None:
            replay_root = self._active_project / "tests" / "replays"
            for path in sorted(replay_root.glob("*.json")):
                try:
                    test_case = GameTestCase.load(path)
                except (OSError, ValueError, KeyError, json.JSONDecodeError):
                    continue
                item = QListWidgetItem(f"{test_case.name}\n{len(test_case.events)} events")
                item.setData(Qt.ItemDataRole.UserRole, str(path.resolve()))
                self.test_case_list.addItem(item)
                if select is not None and path.resolve() == select.resolve():
                    self.test_case_list.setCurrentItem(item)
        if self.test_case_list.currentItem() is None:
            self.test_case_list.setCurrentRow(1 if self.test_case_list.count() > 1 else 0)
        self.test_case_list.blockSignals(False)
        self._select_test_case()

    def _select_test_case(self) -> None:
        item = self.test_case_list.currentItem()
        path_value = None if item is None else item.data(Qt.ItemDataRole.UserRole)
        if not path_value:
            self._loaded_test_case = None
            self.test_name_input.setText("Manual session")
            self.max_ticks_input.setValue(600)
            self.timeline_table.setRowCount(0)
            self.assertion_table.setRowCount(0)
            self._refresh_action_states()
            return
        try:
            test_case = GameTestCase.load(Path(path_value))
        except (OSError, ValueError, KeyError, json.JSONDecodeError) as error:
            self._record_audit("test", "load", "pc", "failed", {"error": str(error)})
            return
        self._loaded_test_case = test_case
        self.test_name_input.setText(test_case.name)
        self.max_ticks_input.setValue(test_case.max_ticks)
        self.timeline_table.setRowCount(0)
        for event in test_case.events:
            self._append_event_row(event)
        self.assertion_table.setRowCount(0)
        for rule in test_case.assertions:
            row = self.assertion_table.rowCount()
            self.assertion_table.insertRow(row)
            values = (
                rule.tick,
                rule.field,
                rule.operator.value,
                json.dumps(rule.expected, ensure_ascii=False),
                rule.message,
            )
            for column, value in enumerate(values):
                self.assertion_table.setItem(row, column, QTableWidgetItem(str(value)))
        self._record_audit(
            "test", "load", "pc", "ok", {"path": str(path_value), "events": len(test_case.events)}
        )
        self._refresh_action_states()

    def _new_test_case(self) -> None:
        self.test_case_list.setCurrentRow(0)
        self.view_tabs.setCurrentIndex(2)
        self.test_name_input.setFocus()

    def _delete_test_case(self) -> None:
        item = self.test_case_list.currentItem()
        path_value = None if item is None else item.data(Qt.ItemDataRole.UserRole)
        if not path_value:
            return
        path = Path(path_value)
        try:
            path.unlink()
            self._record_audit("test", "delete", "pc", "ok", {"path": str(path)})
        except OSError as error:
            self._record_audit("test", "delete", "pc", "failed", {"error": str(error)})
        self._refresh_test_cases()

    def _set_logical_position(self, x: int, y: int) -> None:
        self.x_input.setValue(x)
        self.y_input.setValue(y)
        self.position_label.setText(f"X {x:03d} / Y {y:03d}")

    def _accept_audit_event(self, event: AuditEvent) -> None:
        if not event.run_id and self._run_id:
            event = AuditEvent(
                category=event.category,
                action=event.action,
                target=event.target,
                result=event.result,
                details=event.details,
                run_id=self._run_id,
                tick=event.tick,
                timestamp_ns=event.timestamp_ns,
            )
        self.audit_console.append_event(event)
        self.log_requested.emit(
            f"[{event.target.upper()}][{event.category}] {event.action}: {event.result} "
            f"{json.dumps(dict(event.details), ensure_ascii=False, sort_keys=True)}"
        )

    def _accept_assertion_result(self, result: AssertionResult) -> None:
        if result.passed:
            self._assertion_passed += 1
        else:
            self._assertion_failed += 1
        total = self._assertion_passed + self._assertion_failed
        self.audit_console.set_summary(
            f"断言 {self._assertion_passed}/{total} 通过，{self._assertion_failed} 失败",
            passed=self._assertion_failed == 0,
        )

    def _preview_state_changed(self, state: str) -> None:
        if self._preview_stopping:
            return
        self.status_label.setText(state.upper())
        if state == "paused":
            self.play_button.setChecked(False)
        elif state == "running":
            self.play_button.setChecked(True)
        elif state == "completed":
            self._pc_test_complete = True
            self.audit_console.set_summary(
                "PC 测试结束 / 等待完整报告",
                passed=None,
            )
            self._report_comparison_if_ready()
        elif state in ("lost", "won"):
            self.play_button.setChecked(False)
            self.audit_console.set_summary(f"PC 试玩结束 / {state.upper()}", passed=None)
            self._record_audit("run", "finish", "pc", state, {})
        self._refresh_action_states()

    def _record_audit(
        self,
        category: str,
        action: str,
        target: str,
        result: str,
        details: dict[str, object],
        *,
        tick: int | None = None,
    ) -> None:
        self._accept_audit_event(
            AuditEvent(
                category=category,
                action=action,
                target=target,
                result=result,
                details=details,
                run_id=self._run_id,
                tick=tick,
            )
        )

    def _refresh_action_states(self) -> None:
        project_ready = self._active_project is not None
        pc_ready = self._preview_worker is not None and not self._preview_stopping
        device_ready = (
            self.device is not None and self.device.snapshot.state is DeviceState.READY
        )
        device_idle = self._device_thread is None
        target = str(self.input_target.currentData()) if hasattr(self, "input_target") else "pc"
        target_ready = (
            (target == "pc" and pc_ready)
            or (target == "pynq" and device_ready and self._pynq_running)
            or (target == "compare" and pc_ready and device_ready and self._pynq_running)
        )
        target_uses_device = target in ("pynq", "compare")
        self.pynq_input_mode.setEnabled(device_idle and not self._pynq_running and self._preview_thread is None)
        pc_active = self._preview_thread is not None
        self.pc_play_button.setFixedWidth(max(
            self.pc_play_button.fontMetrics().horizontalAdvance(text)
            for text in ("PC 试玩", "停止试玩", "停止中")) + 48)
        self.pc_play_button.setText("停止中" if self._preview_stopping else "停止试玩" if pc_active else "PC 试玩")
        self.pc_play_button.setIcon(self.style().standardIcon(
            QStyle.StandardPixmap.SP_MediaStop if pc_active else QStyle.StandardPixmap.SP_MediaPlay))
        self.pc_play_button.setEnabled(project_ready and target == "pc" and device_idle and not self._preview_stopping)
        self.pc_play_button.setToolTip(
            "停止当前 PC 会话，等待线程退出后恢复编辑" if pc_active else
            "PC 手动试玩，独立会话 seed" if target == "pc" else "先选择 PC 执行目标")
        self.pc_test_button.setEnabled(
            project_ready and self._preview_thread is None and device_idle
            and (not target_uses_device or device_ready)
        )
        self.pc_test_button.setToolTip(
            "先连接 PYNQ Agent" if target_uses_device and not device_ready else
            "运行当前工程和测试用例" if project_ready else "先从左侧选择一个游戏工程"
        )
        self.build_button.setEnabled(project_ready and device_idle and self._preview_thread is None)
        self.build_button.setToolTip("构建确定性 VVG 包" if project_ready else "先选择游戏工程")
        self.install_button.setEnabled(
            self._built_package is not None and device_ready and device_idle
            and self._preview_thread is None
        )
        self.install_button.setToolTip(
            "验证当前用例通过后安装 VVG 到 PYNQ"
            if self._built_package is not None and device_ready
            else "需要已构建 VVG 且 PYNQ Agent 已连接"
        )
        for button in (
            self.hand_button,
            self.fist_button,
            self.tone_button,
            self.cancel_input_button,
        ):
            button.setEnabled(target_ready and not self._pynq_live and (device_idle or not target_uses_device))
            button.setToolTip(
                "向当前运行目标注入测试输入"
                if target_ready
                else "所选目标尚未运行或设备未连接"
            )
        for button in self.gesture_buttons.values():
            button.setEnabled(device_idle)
        playback_ready = (
            (target == "pc" and pc_ready)
            or (target == "pynq" and device_ready and self._pynq_running)
            or (target == "compare" and pc_ready and device_ready and self._pynq_running)
        )
        for button in (self.reset_button, self.play_button, self.step_button):
            button.setEnabled(playback_ready and (device_idle or not target_uses_device))
        if self._pynq_live:
            self.step_button.setEnabled(False)
        for button in (
            self.test_device_button,
            self.clear_state_button,
            self.initialize_button,
        ):
            button.setEnabled(device_ready and device_idle)
            button.setToolTip("PYNQ Agent 命令" if device_ready else "PYNQ Agent 未连接")
        self.new_test_button.setEnabled(project_ready)
        self.save_test_button.setEnabled(project_ready)
        selected_test = self.test_case_list.currentItem()
        self.delete_test_button.setEnabled(
            selected_test is not None
            and selected_test.data(Qt.ItemDataRole.UserRole) is not None
        )
        editing_ready = device_idle and self._preview_thread is None
        for widget in (self.game_list, self.test_case_list, self.code_editor,
                       self.new_game_button, self.import_game_button, self.refresh_projects_button,
                       self.new_test_button, self.save_test_button, self.delete_test_button,
                       self.input_target):
            widget.setEnabled(widget.isEnabled() and editing_ready if widget in (
                self.new_test_button, self.save_test_button, self.delete_test_button
            ) else editing_ready)
        self.view_tabs.widget(2).setEnabled(editing_ready)

    def resizeEvent(self, event) -> None:  # type: ignore[no-untyped-def]
        super().resizeEvent(event)
        self._refresh_pixmap()
        self._refresh_board_readout()

    def _tool_button(self, icon: QStyle.StandardPixmap, tooltip: str) -> QToolButton:
        button = QToolButton()
        button.setIcon(self.style().standardIcon(icon))
        button.setToolTip(tooltip)
        button.setFixedSize(38, 34)
        return button

    @staticmethod
    def _eyebrow(text: str) -> QLabel:
        label = QLabel(text)
        label.setObjectName("eyebrowLabel")
        return label
