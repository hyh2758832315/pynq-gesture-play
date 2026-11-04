from pathlib import Path
import json
import threading
import time
from types import SimpleNamespace
import uuid

from PySide6.QtCore import QObject, QThread, Qt, QTimer, Signal, Slot
from PySide6.QtWidgets import (
    QHBoxLayout, QLabel, QListWidget, QListWidgetItem, QPlainTextEdit,
    QPushButton, QVBoxLayout, QWidget, QFileDialog, QLineEdit, QCheckBox, QProgressBar,
)

from ..game_package import GameManifest
from .content_pipeline import ContentItem, load_content
from .device import DeviceState, RemoteDeviceSession
from .system_loader import SystemLoader


class ContentLoadWorker(QObject):
    message = Signal(str)
    completed = Signal(object)
    failed = Signal(str)
    finished = Signal()

    def __init__(self, items, device, output, *, prepare_only=False, candidate=None, ssh_alias='pynq-z2'):
        super().__init__()
        self.items, self.device, self.output = items, device, output
        self.stopping = threading.Event()
        self.prepare_only=prepare_only
        self.candidate, self.ssh_alias = candidate, ssh_alias

    def stop(self):
        self.stopping.set()

    @Slot()
    def run(self):
        bootstrap_output = None
        try:
            if (not self.prepare_only and isinstance(self.device, RemoteDeviceSession)
                    and self.device.snapshot.state is not DeviceState.READY):
                bootstrap_output = self.output.with_name(self.output.name+'-system')
                SystemLoader(self.device, ssh_alias=self.ssh_alias).ensure_running(
                    self.candidate, bootstrap_output,
                    stop_event=self.stopping, progress=self.message.emit)
                self.message.emit('项目启动记录：'+str(bootstrap_output/'receipt.json'))
            result = load_content(self.items, self.device, self.output,
                                  stop_event=self.stopping, progress=self.message.emit,
                                  prepare_only=self.prepare_only)
            self.completed.emit(result)
        except Exception as error:
            if bootstrap_output is not None:
                self.message.emit('项目启动记录：'+str(bootstrap_output/'receipt.json'))
            self.failed.emit(str(error))
        finally:
            self.finished.emit()


class SystemLoadWorker(QObject):
    # Keep this QObject's run slot independent. Overriding the registered run
    # slot of ContentLoadWorker dispatches through the GUI thread in PySide6.
    message = Signal(str)
    completed = Signal(object)
    failed = Signal(str)
    finished = Signal()

    def __init__(self,candidate,device,output,ssh_alias,*,field=False,resume_receipt=None,start_only=False):
        super().__init__()
        self.device,self.output=device,output
        self.stopping=threading.Event()
        self.candidate,self.ssh_alias=candidate,ssh_alias
        self.field=field
        self.resume_receipt=resume_receipt
        self.start_only=start_only

    def stop(self):
        self.stopping.set()

    @Slot()
    def run(self):
        try:
            loader=SystemLoader(self.device,ssh_alias=self.ssh_alias)
            options=dict(stop_event=self.stopping,progress=self.message.emit)
            if self.start_only:
                result=loader.start_installed(self.output,hand_enabled=self.field,**options)
            elif self.resume_receipt is not None:
                result=loader.resume_installed(self.resume_receipt,self.output,**options)
            elif self.field:
                result=loader.start_field(self.candidate,self.output,observer_confirmed=True,**options)
            else:
                result=loader.load(self.candidate,self.output,**options)
            self.completed.emit(result)
        except Exception as error:
            self.failed.emit(str(error))
        finally:self.finished.emit()


class ContentLoadWorkspace(QWidget):
    activity_changed = Signal(str, str, str, object)
    busy_changed = Signal(bool)

    def __init__(self, game_workspace, video_workspace, device=None, *, settings=None):
        super().__init__()
        self.game_workspace, self.video_workspace = game_workspace, video_workspace
        self.device = device
        self.settings=settings
        self._retry_receipt=None
        self.before_run = lambda: True
        self.before_system_run = lambda: self.before_run()
        self.thread = self.worker = None
        self.last_receipt = None
        self.output = None
        self._selection_initialized=False
        self.system_candidate = None
        self.board_info = None
        root = QVBoxLayout(self)
        heading = QLabel("一键加载到 PYNQ")
        heading.setObjectName("sectionLabel")
        root.addWidget(heading)
        description = QLabel("选择游戏工程与视频素材。统一完成构建、PC 验证、视频转换、上传安装和身份回读。")
        description.setWordWrap(True)
        root.addWidget(description)
        self.target_label = QLabel()
        self.target_label.setTextFormat(Qt.TextFormat.PlainText)
        root.addWidget(self.target_label)
        system_actions=QHBoxLayout()
        self.system_select_button=QPushButton('选择完整系统包')
        self.system_select_button.clicked.connect(self.choose_system)
        self.system_label=QLabel('未选择系统包；已安装的项目可直接启动')
        self.system_label.setTextFormat(Qt.TextFormat.PlainText)
        self.ssh_alias=QLineEdit(str(settings.value('pynq/ssh-alias','pynq-z2')) if settings else 'pynq-z2')
        self.ssh_alias.setMaximumWidth(130)
        self.ssh_alias.setToolTip('已配置密钥登录的 SSH 主机别名；用于 Agent 未启动时安装系统')
        self.system_load_button=QPushButton('安装完整项目')
        self.system_load_button.setToolTip('验证完整配对包，保留内容库，正常交接后启动；本入口不驱动实体手')
        self.system_load_button.clicked.connect(self.start_system)
        self.system_retry_button=QPushButton('重试已安装系统')
        self.system_retry_button.setToolTip('仅在原进程退出且资源释放已确认后重试；保留失败记录，不重新上传')
        self.system_retry_button.clicked.connect(self.retry_installed)
        for widget in (self.system_select_button,self.system_label):
            system_actions.addWidget(widget)
        system_actions.setStretch(1,1)
        root.addLayout(system_actions)
        install_actions=QHBoxLayout()
        install_actions.addWidget(QLabel('SSH 主机'))
        install_actions.addWidget(self.ssh_alias)
        install_actions.addWidget(self.system_load_button)
        self.project_start_button=QPushButton('启动／连接项目')
        self.project_start_button.setToolTip('自动等待开机检查；按板端默认配置启用灵巧手。项目已运行则直接连接，无实验倒计时')
        self.project_start_button.clicked.connect(self.start_installed)
        install_actions.addWidget(self.project_start_button)
        install_actions.addWidget(self.system_retry_button)
        install_actions.addStretch()
        root.addLayout(install_actions)
        hand_note=QLabel('灵巧手沿用板端默认配置；未接入时仅启动界面。')
        hand_note.setWordWrap(True)
        root.addWidget(hand_note)
        self.items = QListWidget()
        self.items.setObjectName("contentLoadList")
        root.addWidget(self.items, 1)
        actions = QHBoxLayout()
        self.refresh_button = QPushButton("刷新内容")
        self.refresh_button.clicked.connect(self.refresh_contents)
        self.prepare_button=QPushButton('构建并验证')
        self.prepare_button.setToolTip('在Studio内构建游戏、运行测试并转换视频；生成完整验证收据')
        self.prepare_button.clicked.connect(lambda:self.start(prepare_only=True))
        self.load_button = QPushButton("一键打包并加载")
        self.load_button.setObjectName("primaryAction")
        self.load_button.clicked.connect(self.start)
        self.cancel_button = QPushButton("取消任务")
        self.cancel_button.clicked.connect(lambda: self.stop(wait=False))
        for button in (self.refresh_button, self.prepare_button, self.load_button, self.cancel_button):
            actions.addWidget(button)
        actions.addStretch()
        root.addLayout(actions)
        self.status_label = QLabel("勾选内容后开始；游戏与视频进入板端内容库，由 HDMI 菜单选择运行。")
        self.status_label.setWordWrap(True)
        self.status_label.setTextFormat(Qt.TextFormat.PlainText)
        root.addWidget(self.status_label)
        self.wait_label=QLabel()
        root.addWidget(self.wait_label)
        self.wait_progress=QProgressBar()
        self.wait_progress.setRange(0,0)
        self.wait_progress.setTextVisible(False)
        self.wait_progress.setFixedHeight(6)
        root.addWidget(self.wait_progress)
        self._wait_started=None
        self._wait_timer=QTimer(self)
        self._wait_timer.setInterval(250)
        self._wait_timer.timeout.connect(self._update_wait)
        self.wait_label.hide();self.wait_progress.hide()
        self.log = QPlainTextEdit()
        self.log.setObjectName("sessionLog")
        self.log.setReadOnly(True)
        self.log.setMaximumBlockCount(300)
        root.addWidget(self.log, 1)
        self.items.itemChanged.connect(lambda _: self.refresh_device_state())
        self.refresh_contents()
        if self.settings is not None:
            saved=self.settings.value('content/system-candidate','')
            if saved and (Path(saved)/'deployment_manifest.json').is_file():self.set_system_candidate(saved)
            failure=self.settings.value('content/system-failure','')
            if failure:self._remember_failed_start(Path(failure))
            self.refresh_device_state()

        self.ssh_alias.editingFinished.connect(self._save_ssh_alias)

    def _save_ssh_alias(self):
        if self.settings is not None:
            self.settings.setValue('pynq/ssh-alias',self.ssh_alias.text().strip())

    @property
    def is_busy(self):
        return self.thread is not None

    def set_device(self, device):
        if self.is_busy:
            raise RuntimeError("加载任务未结束")
        self.device = device
        self.board_info = None
        self.refresh_device_state()

    def refresh_contents(self):
        if self.is_busy:
            return
        checked = {(entry.kind, entry.path) for entry in self.selected_items()}
        if not self._selection_initialized:
            from .default_content import default_video_paths
            checked.update(('video',p.resolve()) for p in default_video_paths())
            self._selection_initialized=True
        self.items.clear()
        for manifest_path in sorted(self.game_workspace.projects_root.glob("*/game.toml")):
            try:
                manifest = GameManifest.from_toml(manifest_path.read_bytes())
            except (OSError, ValueError):
                continue
            self._add(ContentItem("game", manifest_path.parent, manifest.display_name), checked)
        for path in self.video_workspace.source_paths:
            from .default_content import video_title
            self._add(ContentItem("video", path, video_title(path)), checked)
        self.refresh_device_state()

    def _add(self, content, checked):
        item = QListWidgetItem(f"{'游戏' if content.kind == 'game' else '视频'} · {content.title}")
        item.setData(Qt.ItemDataRole.UserRole, content)
        item.setToolTip(str(content.path))
        item.setFlags(item.flags() | Qt.ItemFlag.ItemIsUserCheckable)
        item.setCheckState(Qt.CheckState.Checked if (content.kind, content.path) in checked
                           else Qt.CheckState.Unchecked)
        self.items.addItem(item)

    def selected_items(self):
        return tuple(self.items.item(i).data(Qt.ItemDataRole.UserRole)
                     for i in range(self.items.count())
                     if self.items.item(i).checkState() == Qt.CheckState.Checked)

    def refresh_device_state(self):
        if self.is_busy and not self._wait_timer.isActive():
            self._wait_started=time.monotonic();self._wait_timer.start()
            self._update_wait()
        elif not self.is_busy:
            self._wait_timer.stop()
        self.wait_label.setVisible(self.is_busy)
        self.wait_progress.setVisible(self.is_busy)
        ready = self.device is not None and self.device.snapshot.state is DeviceState.READY
        remote = isinstance(self.device,RemoteDeviceSession)
        from .board_connection import board_startup_message
        text = ('程序已就绪，可加载内容；图像回传由 Vision 页单独开启' if ready else
                '板卡 SSH 已连接 · ' + board_startup_message(self.board_info)
                if self.board_info and self.board_info.get('ssh_ready') else
                '先配置板卡地址和 SSH 主机；程序未运行也可安装或启动，回传不是部署条件。')
        self.target_label.setText(text)
        self.target_label.setWordWrap(True)
        self.load_button.setEnabled((ready or remote) and bool(self.selected_items()) and not self.is_busy)
        self.prepare_button.setEnabled(bool(self.selected_items()) and not self.is_busy)
        self.cancel_button.setEnabled(self.is_busy)
        self.refresh_button.setEnabled(not self.is_busy)
        self.items.setEnabled(not self.is_busy)
        self.system_select_button.setEnabled(not self.is_busy)
        self.ssh_alias.setEnabled(not self.is_busy)
        self.system_load_button.setEnabled(not self.is_busy and self.system_candidate is not None
                                           and isinstance(self.device,RemoteDeviceSession))
        self.system_retry_button.setEnabled(not self.is_busy and self._retry_receipt is not None
                                           and isinstance(self.device,RemoteDeviceSession))
        self.project_start_button.setEnabled(remote and not self.is_busy)

    def _update_wait(self):
        elapsed=int(time.monotonic()-(self._wait_started or time.monotonic()))
        self.wait_label.setText(f'任务进行中 · 已等待 {elapsed//60:02d}:{elapsed%60:02d} · 可取消等待')

    def choose_system(self):
        path=QFileDialog.getExistingDirectory(self,'选择含 deployment_manifest.json 的完整系统目录')
        if path:self.set_system_candidate(path)

    def set_system_candidate(self,path):
        if self.is_busy:raise RuntimeError('加载任务未结束')
        path=Path(path)
        if not (path/'deployment_manifest.json').is_file():
            self._failed('该目录没有系统清单 deployment_manifest.json');return
        self.system_candidate=path
        self.system_label.setText(path.name)
        self.system_label.setToolTip(str(path))
        if self.settings is not None:self.settings.setValue('content/system-candidate',str(path.resolve()))
        self.refresh_device_state()

    def start_system(self):
        self._start_system(field=False)

    def start_field(self):
        self.start_installed()

    def start_installed(self):
        self._start_system(field=None,start_only=True)

    def _remember_failed_start(self,path):
        try:
            value=json.loads(path.read_text(encoding='utf-8'))
            valid=(isinstance(value,dict) and value.get('schema')=='studio-system-load-v1' and value.get('result')=='FAIL'
                   and value.get('hand_enabled') is False
                   and any(isinstance(step,dict) and step.get('name')=='installed'
                           for step in value.get('steps',[])))
        except (OSError,ValueError,TypeError):valid=False
        if valid:
            self._retry_receipt=path
            if self.settings is not None:self.settings.setValue('content/system-failure',str(path.resolve()))

    def retry_installed(self):
        if self._retry_receipt is not None:self._start_system(field=False,resume_receipt=self._retry_receipt)

    def _start_system(self,*,field,resume_receipt=None,start_only=False):
        if (self.is_busy or (self.system_candidate is None and resume_receipt is None and not start_only)
                or not isinstance(self.device,RemoteDeviceSession)):return
        if not self.before_system_run():return
        self.output=self.game_workspace.projects_root/'.loads'/uuid.uuid4().hex
        self.last_receipt=None
        self._retry_receipt=None
        thread=QThread(self)
        worker=SystemLoadWorker(self.system_candidate,self.device,self.output,self.ssh_alias.text().strip(),
                                field=field,resume_receipt=resume_receipt,start_only=start_only)
        worker.moveToThread(thread)
        thread.started.connect(worker.run)
        worker.message.connect(self._message)
        worker.completed.connect(self._completed)
        worker.failed.connect(self._failed)
        worker.finished.connect(worker.deleteLater)
        worker.finished.connect(thread.quit,Qt.ConnectionType.DirectConnection)
        thread.finished.connect(self._finished)
        self.thread,self.worker=thread,worker
        self.busy_changed.emit(True)
        self._message('通过 SSH 启动已安装项目，等待初始化完成' if start_only else
                      '校验完整系统；板卡有其他任务占用时停止加载')
        thread.start();self.refresh_device_state()

    def start(self, *, prepare_only=False):
        if (self.is_busy or not self.selected_items() or (not prepare_only and (self.device is None
                or (self.device.snapshot.state is not DeviceState.READY and not isinstance(self.device,RemoteDeviceSession))))):
            return
        needs_bootstrap=(not prepare_only and isinstance(self.device,RemoteDeviceSession)
                         and self.device.snapshot.state is not DeviceState.READY)
        if not (self.before_system_run() if needs_bootstrap else self.before_run()):
            return
        try:
            self.game_workspace.code_editor.save_all()
            if any(item.kind == "game" and item.path == self.game_workspace._active_project
                   for item in self.selected_items()):
                if self.game_workspace.save_current_test_case() is None:
                    raise ValueError("当前测试用例无效，先修正时间线")
        except (OSError, ValueError) as error:
            self._failed(f"源码保存失败：{error}")
            return
        self.output = self.game_workspace.projects_root / ".loads" / uuid.uuid4().hex
        self.last_receipt = None
        thread = QThread(self)
        device=self.device or SimpleNamespace(expected_build_id=self.game_workspace.profile_build_id)
        worker = ContentLoadWorker(self.selected_items(), device, self.output,prepare_only=prepare_only,
                                   candidate=self.system_candidate,ssh_alias=self.ssh_alias.text().strip())
        worker.moveToThread(thread)
        thread.started.connect(worker.run)
        worker.message.connect(self._message)
        worker.completed.connect(self._completed)
        worker.failed.connect(self._failed)
        worker.finished.connect(worker.deleteLater)
        worker.finished.connect(thread.quit, Qt.ConnectionType.DirectConnection)
        thread.finished.connect(self._finished)
        self.thread, self.worker = thread, worker
        self.busy_changed.emit(True)
        self._message("正在准备内容；所有 PC 验证通过后开始上传")
        thread.start()
        self.refresh_device_state()

    def _message(self, message):
        self.status_label.setText(message)
        self.log.appendPlainText(message)
        self.activity_changed.emit("加载 / PYNQ", message, "waiting", None)

    def _completed(self, receipt):
        self.last_receipt = receipt
        if receipt.get('schema')=='studio-system-load-v1':
            self._retry_receipt=None
            if self.settings is not None:self.settings.remove('content/system-failure')
        text = (f"已构建并验证 {len(receipt['items'])} 项内容，尚未上传。记录：{self.output / 'receipt.json'}"
                if receipt.get('status')=='validated' else
                f"已安装项目已启动，无运行时限；回传按需开启。记录：{self.output / 'receipt.json'}"
                if receipt.get('schema')=='studio-system-start-v1' else
                f"灵巧手已就绪，30 分钟现场实验窗口；回传关闭。记录：{self.output / 'receipt.json'}"
                if receipt.get('schema')=='studio-system-field-v1' else
                f"界面系统已启动，原游戏与视频已保留。记录：{self.output / 'receipt.json'}"
                if receipt.get('schema')=='studio-system-load-v1' else
                f"已安装并核对 {len(receipt['items'])} 项内容。记录：{self.output / 'receipt.json'}")
        self._message(text)
        self.activity_changed.emit("加载 / PYNQ", text, "success", None)

    def _failed(self, message):
        text = f"加载未完成：{message}"
        if self.output:
            receipt_path = self.output / 'receipt.json'
            bootstrap_path = self.output.with_name(self.output.name+'-system')/'receipt.json'
            if receipt_path.exists():
                text += f"\n已完成项和未确认项见 {receipt_path}"
            elif bootstrap_path.exists():
                text += f"\n项目启动未完成，记录见 {bootstrap_path}"
            self._remember_failed_start(self.output/'receipt.json')
        self.status_label.setText(text)
        self.log.appendPlainText(text)
        self.activity_changed.emit("加载 / PYNQ", text, "error", None)

    def _finished(self):
        if isinstance(self.sender(), QThread) and self.sender() is not self.thread:
            return
        thread, worker = self.thread, self.worker
        self.thread = self.worker = None
        if thread:
            thread.deleteLater()
        self.busy_changed.emit(False)
        self.refresh_device_state()

    def stop(self, *, wait=True):
        if self.worker:
            self.worker.stop()
            self._message("正在取消；已安装项会保留并记录，正在安装项需等回执")
        if wait and self.thread:
            if not self.thread.wait(3000):
                return False
            self._finished()
        return not self.is_busy
