"""PC authoring surface. Hardware deployment belongs to the content loader."""
from pathlib import Path
from tempfile import TemporaryDirectory

from PySide6.QtCore import Qt

from PySide6.QtWidgets import QComboBox, QFrame, QHBoxLayout, QLabel, QPushButton, QSizePolicy

from ..game_package import GamePackageBuilder
from .game_workspace import GameWorkspace


class AuthoringGameWorkspace(GameWorkspace):
    def __init__(self, *, projects_root=None, build_id=0xC0061000):
        self.profile_build_id = build_id
        self.before_run = lambda: True
        self._preview_cache = TemporaryDirectory(prefix="voice-view-pc-", ignore_cleanup_errors=True)
        super().__init__(projects_root=projects_root)
        self.code_editor.save_failed.connect(lambda message: self.activity_changed.emit(
            "Game / PC", f"保存失败，编辑内容已保留：{message}", "error", None))
        self.inspector.removeTab(self.inspector.indexOf(self.inspector.device_table))
        self._target_changed()
        self.position_label.setText("PC / 未运行")
        self.gesture_readout.setText("PC 手动输入 · 选择手势后点击箭头")
        self.telemetry_label.setSizePolicy(QSizePolicy.Policy.Ignored, QSizePolicy.Policy.Preferred)
        self.progress.setMinimumWidth(0)
        self.position_label.setSizePolicy(QSizePolicy.Policy.Ignored, QSizePolicy.Policy.Preferred)
        self.position_label.setMinimumWidth(68)
        self.controls_widget.layout().setSpacing(4)
        self.controls_widget.layout().setStretch(3, 1)
        self.input_controls.setMinimumHeight(0)
        self.viewport.setMinimumSize(320, 180)
        self.input_controls.layout().setVerticalSpacing(6)

    def _build_command_bar(self):
        bar = QFrame()
        bar.setObjectName("commandBar")
        row = QHBoxLayout(bar)
        row.addWidget(QLabel("游戏创作 · PC 预览与测试"))
        row.addStretch()
        self.pc_play_button = QPushButton("PC 试玩")
        self.pc_play_button.clicked.connect(self.start_project_play)
        self.pc_test_button = QPushButton("运行 PC 测试")
        self.pc_test_button.setObjectName("primaryAction")
        self.pc_test_button.clicked.connect(self.start_project_preview)
        row.addWidget(self.pc_play_button)
        row.addWidget(self.pc_test_button)
        # These model adapters keep the shared editor/test controls PC-only.
        # They have no remote choices, connections or visible layout entries.
        self.input_target = QComboBox(bar)
        self.input_target.addItem("PC", "pc")
        self.pynq_input_mode = QComboBox(bar)
        self.pynq_input_mode.addItem("确定性回放", "replay")
        self.input_target.hide()
        self.pynq_input_mode.hide()
        for name in ("test_device_button", "clear_state_button", "initialize_button",
                     "build_button", "install_button"):
            button = QPushButton(bar)
            button.hide()
            setattr(self, name, button)
        return bar

    def set_device(self, device):
        # Only the platform's input profile is relevant to a PC editor.
        self.profile_build_id = getattr(device, "expected_build_id", self.profile_build_id)
        self.device = None
        self._apply_profile_controls()
        self._update_test_case_visibility()
        self._refresh_action_states()

    def _soundless_profile(self):
        return self.profile_build_id == 0xC0061000

    def _submit_device_task(self, *args, **kwargs):
        raise RuntimeError("Game 页仅用于 PC；请使用统一加载入口")

    def _select_game(self):
        try:
            self.code_editor.save_all()
        except OSError as error:
            self.activity_changed.emit("Game / PC", f"保存失败，保持当前工程：{error}", "error", None)
            previous = self._active_project
            blocked = self.game_list.blockSignals(True)
            for index in range(self.game_list.count()):
                item = self.game_list.item(index)
                if Path(item.data(Qt.ItemDataRole.UserRole)) == previous:
                    self.game_list.setCurrentItem(item)
                    break
            self.game_list.blockSignals(blocked)
            return
        super()._select_game()

    def show_pynq_output(self):
        self.viewport.clear_frame("选择项目，开始 PC 试玩或运行测试")
        self.heading.setText("PC 游戏预览")
        self.status_label.setText("等待项目")
        self.board_readout.hide()

    def build_active_project(self):
        if self._active_project is None:
            return None
        self.code_editor.save_all()
        # The sandbox runner consumes an archive internally. No user-facing
        # release VVG is generated here; every release is rebuilt by the loader.
        info = GamePackageBuilder().build(
            self._active_project, Path(self._preview_cache.name) / "preview.vvg")
        self._built_package = info.path
        return info.path

    def start_project_play(self):
        if self._preview_thread is not None or self.before_run():
            super().start_project_play()

    def start_project_preview(self):
        if self.before_run():
            super().start_project_preview()

    def release_cache(self):
        if self._preview_thread is None:
            self._preview_cache.cleanup()
