from __future__ import annotations

import json
import threading
from collections import deque
from time import monotonic

from PySide6.QtCore import QObject, QThread, Qt, Signal, Slot, QTimer
from PySide6.QtGui import QColor, QImage, QPainter, QPen
from PySide6.QtWidgets import QComboBox, QHBoxLayout, QLabel, QLineEdit, QProgressBar, QSizePolicy, QStyle, QToolButton, QWidget

from ..voice_monitor import validate_voice_monitor
from ..volume_monitor import VolumeMonitorSession, validate_volume_status, validate_fused_volume_status
from .device import RemoteDeviceSession
from .workspaces import AdapterWorkspace


class VoiceMonitorWorker(QObject):
    received = Signal()
    finished = Signal()

    def __init__(self, session) -> None:
        super().__init__()
        self.session = session
        self._stopping = threading.Event()
        self._mailbox_lock = threading.Lock()
        self._latest, self._pending = None, False

    def publish(self, payload) -> None:
        with self._mailbox_lock:
            self._latest = payload
            notify = not self._pending
            self._pending = True
        if notify:
            self.received.emit()

    def take_latest(self):
        with self._mailbox_lock:
            payload = self._latest
            self._latest, self._pending = None, False
            return payload

    @Slot()
    def run(self) -> None:
        previous_error = None
        try:
            while not self._stopping.is_set():
                try:
                    result = self.session.request()
                    if not self._stopping.is_set():
                        self.publish((True, result))
                    previous_error = None
                except (OSError, ConnectionError, ValueError, RuntimeError) as error:
                    self.session.close()
                    message = f"{type(error).__name__}: {error}"
                    if not self._stopping.is_set() and message != previous_error:
                        self.publish((False, message))
                    previous_error = message
                self._stopping.wait(0.2)
        finally:
            self.session.close()
            self.finished.emit()

    def stop(self) -> None:
        self._stopping.set()


class AudioWorkspace(AdapterWorkspace):
    def __init__(self, device=None) -> None:
        super().__init__("", "声音数据回读", "PCM")
        self.device = device
        self._observer_thread = self._observer_worker = None
        self._voice_snapshot = None
        self._last_pcm_identity = None
        self._last_pcm_at = None
        self._observing = False
        self._skipped_packets = 0
        self._volume_snapshot = None
        self._volume_origin = "来源未核"
        self._volume_title = "VOL1"
        self._volume_run = None
        self._volume_identity = None
        self._volume_at = None
        self._volume_history = deque(maxlen=100)
        controls = QHBoxLayout()
        self.observation_source = QComboBox()
        self.observation_source.addItem("900 / PCM", "pcm")
        self.observation_source.addItem("独立 VOL1 / 音量", "volume")
        self.observation_source.addItem("C0C / 融合音量", "fused-volume")
        self.observation_source.setCurrentIndex(2 if isinstance(device, RemoteDeviceSession) and device.expected_build_id == 0xC0060E00 else
                               0 if isinstance(device, RemoteDeviceSession) and device.expected_build_id == 0xC0060900 else 1)
        self.observation_source.currentIndexChanged.connect(self._refresh_controls)
        self.observe_button = QToolButton()
        self.observe_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaPlay))
        self.observe_button.setToolTip("开始只读声音观察")
        self.observe_button.setFixedSize(32, 32)
        self.observe_button.clicked.connect(self.start_observation)
        self.stop_button = QToolButton()
        self.stop_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaStop))
        self.stop_button.setToolTip("停止观察，保留板端运行")
        self.stop_button.setFixedSize(32, 32)
        self.stop_button.clicked.connect(self.stop)
        self.series_mode = QComboBox()
        self.series_mode.addItem("波形", "waveform")
        self.series_mode.addItem("抽样频谱", "spectrum")
        self.series_mode.setToolTip("每4个样本保留1点；频谱仅为抽样诊断，不作为音高观察")
        self.series_mode.currentIndexChanged.connect(self._render_voice)
        controls.addWidget(self.observe_button)
        controls.addWidget(self.stop_button)
        controls.addWidget(self.observation_source)
        controls.addWidget(self.series_mode)
        controls.addStretch()
        self.layout().insertLayout(1, controls)
        self.volume_connection = QWidget()
        volume_controls = QHBoxLayout(self.volume_connection)
        volume_controls.setContentsMargins(0, 0, 0, 0)
        self.volume_url = QLineEdit("http://192.168.2.99:8771/status")
        self.volume_url.setAccessibleName("VOL1状态地址")
        self.volume_source_address = QLineEdit()
        self.volume_source_address.setPlaceholderText("直连源 IP（可选）")
        self.volume_source_address.setAccessibleName("直连源IP")
        self.volume_source_address.setMaximumWidth(180)
        volume_controls.addWidget(QLabel("VOL1"))
        volume_controls.addWidget(self.volume_url, 1)
        volume_controls.addWidget(self.volume_source_address)
        self.layout().insertWidget(2, self.volume_connection)
        self.volume_level = QProgressBar()
        self.volume_level.setRange(0, 1000)
        self.volume_level.setFixedHeight(24)
        self.volume_level.setFormat("--")
        self.volume_level.setAccessibleName("窗平均绝对幅值")
        self.body_splitter.widget(0).layout().insertWidget(1, self.volume_level)
        inspector = self.body_splitter.widget(1).widget().layout()
        self.readouts = {}
        for key, title in (("state", "声音状态"), ("recognition", "识别事件"), ("cpu", "CPU提交 / 已收"),
                   ("epoch", "源 run / epoch"), ("age", "判决年龄 / 板端"), ("source_age", "来源年龄"),
                   ("volume", "窗幅值"), ("thresholds", "静音 / 中声 / 大声"), ("samples", "样本 / 窗数"),
                   ("health", "时钟 / 故障")):
            row = QHBoxLayout()
            name = QLabel(title)
            name.setObjectName("metricName")
            value = QLabel("--")
            value.setTextFormat(Qt.TextFormat.PlainText)
            value.setMinimumWidth(45)
            value.setSizePolicy(QSizePolicy.Policy.Ignored, QSizePolicy.Policy.Preferred)
            row.addWidget(name)
            row.addWidget(value, 1)
            inspector.insertLayout(inspector.count() - 2, row)
            self.readouts[key] = value
        self.stale_timer = QTimer(self)
        self.stale_timer.setInterval(200)
        self.stale_timer.timeout.connect(self._check_stale)
        self.stale_timer.start()
        self._refresh_controls()

    @property
    def observer_busy(self) -> bool:
        return self._observer_thread is not None

    def set_device(self, device) -> None:
        self.stop()
        if self.observer_busy:
            raise RuntimeError("Voice observer exit unconfirmed; keep previous connection")
        self.device = device
        if isinstance(device, RemoteDeviceSession) and device.expected_build_id == 0xC0060E00:
            self.observation_source.setCurrentIndex(2)
        elif self.observation_source.currentData() == "fused-volume":
            self.observation_source.setCurrentIndex(0 if isinstance(device, RemoteDeviceSession) and device.expected_build_id == 0xC0060900 else 1)
        self.mark_stream_historical()
        self._refresh_controls()

    def _refresh_controls(self) -> None:
        candidate = isinstance(self.device, RemoteDeviceSession) and self.device.expected_build_id == 0xC0060900
        volume = self.observation_source.currentData() == "volume"
        fused = self.observation_source.currentData() == "fused-volume"
        paired = isinstance(self.device, RemoteDeviceSession) and self.device.expected_build_id == 0xC0060E00
        self.observe_button.setEnabled((volume or fused and paired or candidate and not fused) and not self.observer_busy)
        self.stop_button.setEnabled(self.observer_busy)
        self.observation_source.setEnabled(not self.observer_busy)
        self.series_mode.setVisible(not (volume or fused))
        self.volume_connection.setVisible(volume)
        self.volume_connection.setEnabled(not self.observer_busy)
        self.volume_level.setVisible(volume or fused)

    def start_observation(self) -> None:
        if self.observer_busy:
            return
        try:
            if self.observation_source.currentData() == "volume":
                session = VolumeMonitorSession(self.volume_url.text().strip(), source_address=self.volume_source_address.text().strip() or None)
                self._voice_snapshot = None
                self._volume_at = None
            elif self.observation_source.currentData() == "fused-volume" and isinstance(self.device, RemoteDeviceSession):
                session = self.device.create_volume_monitor()
                self._voice_snapshot = None
                self._volume_at = None
            elif isinstance(self.device, RemoteDeviceSession):
                session = self.device.create_voice_monitor()
                self._volume_snapshot = None
            else:
                return
        except ValueError as error:
            self._failure(str(error))
            return
        thread = QThread(self)
        worker = VoiceMonitorWorker(session)
        worker.moveToThread(thread)
        thread.started.connect(worker.run)
        worker.received.connect(self._drain_observation)
        worker.finished.connect(thread.quit, Qt.ConnectionType.DirectConnection)
        worker.finished.connect(worker.deleteLater)
        thread.finished.connect(self._observer_finished)
        self._observer_thread, self._observer_worker = thread, worker
        self._observing = True
        self._refresh_controls()
        thread.start()

    @Slot()
    def _drain_observation(self) -> None:
        if self.sender() is not self._observer_worker or not self._observing:
            return
        payload = self._observer_worker.take_latest()
        if payload is not None:
            if payload[0]:
                self.accept_observation(payload[1])
            else:
                self._failure(payload[1])

    @Slot(object)
    def accept_observation(self, result: dict) -> None:
        if self.sender() is not None and (self.sender() is not self._observer_worker or not self._observing):
            return
        if result.get("schema") == "voice-volume-status-v1":
            self._accept_volume(result)
            return
        if isinstance(result.get("snapshot"), dict) and result["snapshot"].get("profile") == "C6I_PL_VISION_VOLUME_OSD_V1":
            self._accept_fused_volume(result)
            return
        self._volume_snapshot = None
        voice = validate_voice_monitor(result.get("snapshot"))
        prior = self._voice_snapshot
        if prior is not None and (voice["producer_run"], voice["audio_epoch"]) != (prior["producer_run"], prior["audio_epoch"]):
            self._last_pcm_identity, self._last_pcm_at = None, None
            self._skipped_packets = 0
            self._image = QImage()
            self.canvas.setText("等待当前 epoch PCM")
        self._voice_snapshot = voice
        self.contract_value.setText("voice-monitor-v1")
        self.contract_value.setToolTip(json.dumps(result["snapshot"], ensure_ascii=False, sort_keys=True))
        self.frames_value.setText(str(voice["packets"]))
        self.latency_value.setText("--")
        pcm = voice["pcm"]
        if pcm is not None:
            identity = (voice["producer_run"], voice["audio_epoch"], pcm["packet_index"])
            if identity != self._last_pcm_identity:
                if self._last_pcm_identity is not None and identity[:2] == self._last_pcm_identity[:2]:
                    self._skipped_packets += max(0, identity[2] - self._last_pcm_identity[2] - 1)
                self._last_pcm_identity, self._last_pcm_at = identity, monotonic()
            self._render_voice()
        self.drop_value.setText(str(self._skipped_packets))
        self.drop_value.setToolTip("仅观察支路跳过的PCM包；不代表采集丢包")
        recognition = voice["recognition"]
        events = [] if recognition is None else recognition["events"]
        names = {"HIGH_ONSET": "啊", "LOW_SEGMENT_ON": "哦开始", "LOW_SEGMENT_OFF": "哦结束"}
        cpu = voice["cpu"]
        age = voice["decision_age_ns"]
        values = {"state": voice["state"], "recognition": " / ".join(names[event["kind"]] for event in events) or "无事件",
                  "cpu": str(cpu.get("submitted", "--")) + " / " + str(cpu.get("received", "--")),
                  "epoch": str(voice["producer_run"] or "--") + " / " + str(voice["audio_epoch"] or "--"),
                  "age": "--" if age is None else f"{age / 1_000_000:.1f} ms",
                  "source_age": "有来源证据" if voice["source_age_verified"] else "待实测"}
        for key, text in values.items():
            label = self.readouts[key]
            label.setToolTip(text)
            label.setText(label.fontMetrics().elidedText(text, Qt.TextElideMode.ElideRight, max(45, label.width())))
        self.stream_status.setText(voice.get("first_error") or "PYNQ STATUS / 只读观察")
        self._check_stale()

    def _accept_fused_volume(self, result: dict) -> None:
        volume = validate_fused_volume_status(result.get("snapshot"))
        observation, latch = volume["observation"], volume["latch"]
        self._volume_title = "C0C"
        if observation is None:
            self.mark_stream_historical()
            self._volume_snapshot = None
            self._volume_history.clear()
            self._volume_identity = self._volume_run = None
            self._image = QImage()
            self.canvas.clear()
            self.volume_level.setValue(0)
            self.volume_level.setFormat("--")
            for label in self.readouts.values():
                label.setText("--")
                label.setToolTip("--")
            self.contract_value.setText("C0C / C0060E00")
            self.contract_value.setToolTip(json.dumps(result, ensure_ascii=False, sort_keys=True))
            self.readouts["state"].setText("等待音量缓存" if volume["sampling_enabled"] else "采样关闭")
            self.stream_status.setText(volume["error"] or self.readouts["state"].text())
            self.canvas_source.setText("C0C / Agent STATUS / 无有效窗")
            return
        latest = None if latch is None else latch.get("last_receipt")
        signal = None if latest is None else latest.get("signal")
        self._accept_volume({**observation, "producer_run": latch["producer_run"],
            "source_kind": "fused-control", "recent_events": [] if signal is None else [signal]}, fused=True)
        self.contract_value.setToolTip(json.dumps(result, ensure_ascii=False, sort_keys=True))
        error = volume["error"] or observation.get("error") or latch.get("error")
        if error or not volume["poller_alive"] or not volume["sampling_enabled"]:
            self.mark_stream_historical()
            self.stream_status.setText(error or "音量采样停止 / 历史")

    def _accept_volume(self, result: dict, *, fused: bool = False) -> None:
        if result.get("snapshot") is None:
            self._failure(result.get("error") or "VOL1无有效快照")
            return
        volume = validate_volume_status(result["snapshot"])
        run = (result["producer_run"], volume["epoch"])
        if run != self._volume_run:
            self._volume_history.clear()
            self._volume_identity, self._volume_at = None, None
            self._image = QImage()
            self.canvas.clear()
            self._volume_run = run
        self._volume_snapshot = volume
        self._volume_title = "C0C" if fused else "VOL1"
        self._volume_origin = {"fixture": "模拟夹具", "control": "控制接口", "unverified": "来源未核", "fused-control": "Agent STATUS / 缓存"}[result["source_kind"]]
        valid = volume["snapshot_valid"] and volume["mean_abs"] is not None
        if valid:
            identity = (*run, volume["window_count"])
            if identity != self._volume_identity:
                if self._volume_identity is not None and identity[-1] < self._volume_identity[-1]:
                    self._failure("VOL1窗计数回退，需核对源会话")
                    return
                self._volume_identity, self._volume_at = identity, monotonic() - result["cache_age_ms"] / 1000
                self._volume_history.append(volume["mean_abs"])
            loud = volume["thresholds"]["loud"] / 977
            self.volume_level.setValue(min(1000, round(volume["mean_abs"] / max(1, loud) * 1000)))
            self.volume_level.setFormat(f'{volume["mean_abs"]:.2f}')
            self._render_volume()
        else:
            self._volume_at = None
            self.volume_level.setValue(0)
            self.volume_level.setFormat("--")
        self.contract_value.setText("C0C / C0060E00" if fused else "VOL1 / C00C0001")
        self.contract_value.setToolTip(json.dumps(result, ensure_ascii=False, sort_keys=True))
        self.frames_value.setText(str(result["sequence"]))
        self.latency_value.setText(f'{result["cache_age_ms"]:.1f} ms / 缓存')
        self.drop_value.setText("--")
        thresholds = volume["thresholds"]
        events = [event for event in result.get("recent_events", []) if event["epoch"] == volume["epoch"]]
        event_text = "无事件"
        if events:
            latest = events[-1]
            event_text = f'{latest["kind"]} #{latest["sequence"]} / 历史'
        state = "故障" if volume["faults"] or volume["ack_error"] else "未使能" if not volume["enabled"] else "时钟未锁定" if not volume["clock_locked"] else "接收中" if valid else "等待完整窗"
        values = {"state": state, "recognition": event_text, "cpu": "--", "epoch": f'{run[0]} / {run[1]}',
                  "age": "--", "source_age": "窗计数 / 本机新鲜度", "volume": f'{volume["mean_abs"]:.2f}' if valid else "--",
                  "thresholds": "--" if thresholds is None else " / ".join(f'{thresholds[key] / 977:.2f}' for key in ("quiet", "soft", "loud")),
                  "samples": "--" if not volume["snapshot_valid"] else f'{volume["sample_count"]} / {volume["window_count"]}',
                  "health": f'{"锁定" if volume["clock_locked"] else "未锁定"} / 0x{volume["faults"]:02X} / ACK {int(volume["ack_error"])}'}
        for key, text in values.items():
            label = self.readouts[key]
            label.setToolTip(text)
            label.setText(label.fontMetrics().elidedText(text, Qt.TextElideMode.ElideRight, max(45, label.width())))
        self.stream_status.setText(self._volume_title + " / " + self._volume_origin + " / " + state)
        self._check_stale()

    def _render_volume(self) -> None:
        if not self._volume_history or self._volume_snapshot is None:
            return
        thresholds = self._volume_snapshot["thresholds"]
        maximum = max(1, thresholds["loud"] / 977 * 1.25, max(self._volume_history))
        self._image = QImage(640, 300, QImage.Format.Format_RGB888)
        self._image.fill(QColor("#202428"))
        painter = QPainter(self._image)
        font = self.font()
        font.setPixelSize(12)
        painter.setFont(font)
        painter.setRenderHint(QPainter.RenderHint.Antialiasing)
        painter.setPen(QColor("#aeb8bd"))
        painter.drawText(12, 18, f"L1 / 977    0 - {maximum:.1f}")
        for key, color in (("quiet", "#aeb8bd"), ("soft", "#38c7c9"), ("loud", "#efc078")):
            height = 275 - int(thresholds[key] / 977 / maximum * 240)
            painter.setPen(QPen(QColor(color), 1, Qt.PenStyle.DashLine))
            painter.drawLine(12, height, 560, height)
            painter.drawText(565, height + 4, key.upper())
        painter.setPen(QPen(QColor("#9edb9a"), 2))
        points = [(12 + index * 548 / 99, 275 - value / maximum * 240) for index, value in enumerate(self._volume_history)]
        for first, second in zip(points, points[1:]):
            painter.drawLine(round(first[0]), round(first[1]), round(second[0]), round(second[1]))
        if len(points) == 1:
            painter.drawEllipse(round(points[0][0]), round(points[0][1]), 3, 3)
        painter.end()
        self.canvas.setText("")
        self._refresh_pixmap()

    def _render_voice(self) -> None:
        if self._voice_snapshot is None or self._voice_snapshot.get("pcm") is None:
            return
        import numpy as np
        values = np.asarray(self._voice_snapshot["pcm"]["samples"], dtype=float)
        if self.series_mode.currentData() == "spectrum":
            values = np.abs(np.fft.rfft((values - values.mean()) * np.hanning(len(values))))
        self._show_fixture_series({"values": values.tolist()})
        self._check_stale()

    def _check_stale(self) -> None:
        if self._volume_snapshot is not None:
            fresh = self._volume_at is not None and monotonic() - self._volume_at <= 0.5
            if not fresh:
                self.volume_level.setValue(0)
                self.volume_level.setFormat("-- / 历史")
                self.readouts["volume"].setText("-- / 历史")
                self.readouts["state"].setText("历史 / " + self.readouts["state"].toolTip())
            self.canvas_source.setText(self._volume_title + " / " + self._volume_origin + " / 977样本窗均值 / " + ("实时" if fresh else "历史"))
            return
        if self._voice_snapshot is None:
            return
        voice = self._voice_snapshot
        historical = voice["state"] != "RUNNING" or self._last_pcm_at is None or monotonic() - self._last_pcm_at > 0.5
        if not self._observing and self._observer_thread is not None:
            historical = True
        suffix = "历史" if historical else "实时片段"
        axis = "0-6 kHz / 抽样" if self.series_mode.currentData() == "spectrum" else "20 ms / 标称48 kHz / 每4点抽样"
        self.canvas_source.setText("PYNQ PCM / " + axis + " / " + suffix)

    @Slot(str)
    def _failure(self, message: str) -> None:
        if self.sender() is not None and self.sender() is not self._observer_worker:
            return
        self.mark_stream_historical()
        self.stream_status.setText(message)

    def mark_stream_historical(self) -> None:
        super().mark_stream_historical()
        self._last_pcm_at = None
        self._volume_at = None
        self._check_stale()

    def _observer_finished(self) -> None:
        if isinstance(self.sender(), QThread) and self.sender() is not self._observer_thread:
            return
        thread = self._observer_thread
        self._observer_thread = self._observer_worker = None
        self._observing = False
        self.mark_stream_historical()
        if thread is not None:
            thread.deleteLater()
        self._refresh_controls()

    def stop(self) -> None:
        super().stop()
        self._observing = False
        if self._observer_worker is not None:
            self._observer_worker.stop()
        thread = self._observer_thread
        if thread is not None and thread.isRunning():
            thread.wait(1500)
        if thread is not None and not thread.isRunning():
            self._observer_finished()
        self.mark_stream_historical()