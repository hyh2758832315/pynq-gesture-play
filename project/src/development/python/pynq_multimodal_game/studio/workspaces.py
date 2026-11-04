from __future__ import annotations

from .theme import ACCENT

import base64
from email.parser import BytesHeaderParser
from http.client import HTTPConnection, HTTPException, HTTPResponse
import json
import select
import socket
from threading import Event, Lock, Timer
import time
from urllib.parse import urlsplit

from PySide6.QtCore import QEvent, QObject, Qt, QThread, QTimer, Signal, Slot
from PySide6.QtGui import QColor, QImage, QPainter, QPen, QPixmap
from PySide6.QtWidgets import (
    QFrame,
    QGridLayout,
    QHBoxLayout,
    QHeaderView,
    QLabel,
    QListWidget,
    QListWidgetItem,
    QProgressBar,
    QPlainTextEdit,
    QLineEdit,
    QScrollArea,
    QSpinBox,
    QSizePolicy,
    QSplitter,
    QStyle,
    QTableWidget,
    QTableWidgetItem,
    QToolButton,
    QVBoxLayout,
    QWidget,
)

from ..scene import LOGICAL_HEIGHT, LOGICAL_WIDTH
from ..protocol import ProtocolFrame
from ..streaming import BoundedStreamBuffer, StreamSample
from .capabilities import CAPABILITY_MATRIX, C4M7_CAPABILITIES, CapabilityStatus
from .game_replay import DemoReplaySession, ReplayFrame
from .vision_receiver import VisionResultReceiver, VisionResultSnapshot
from .device import VisionAgentSession
from ..agent import AgentCommand


def rgb_to_qimage(rgb: bytes) -> QImage:
    expected = LOGICAL_WIDTH * LOGICAL_HEIGHT * 3
    if len(rgb) != expected:
        raise ValueError(f"RGB frame must contain {expected} bytes")
    return QImage(
        rgb,
        LOGICAL_WIDTH,
        LOGICAL_HEIGHT,
        LOGICAL_WIDTH * 3,
        QImage.Format.Format_RGB888,
    ).copy()


def read_mjpeg_frame(response: HTTPResponse) -> bytes:
    if response.readline(64) != b"--frame\r\n":
        raise EOFError("Missing MJPEG frame boundary")
    header_lines = []
    for _ in range(16):
        line = response.readline(4096)
        if line == b"\r\n":
            break
        if not line or len(line) >= 4096:
            raise EOFError("Invalid MJPEG frame headers")
        header_lines.append(line)
    else:
        raise ValueError("MJPEG frame headers are too long")
    headers = BytesHeaderParser().parsebytes(b"".join(header_lines) + b"\r\n")
    if headers.get_content_type() != "image/jpeg":
        raise ValueError("Expected a JPEG camera frame")
    length_text = headers.get("Content-Length")
    if length_text is None:
        raise ValueError("Missing MJPEG frame size")
    length = int(length_text)
    if not 0 < length <= 5_000_000:
        raise ValueError("Invalid MJPEG frame size")
    jpeg = response.read(length)
    if len(jpeg) != length or response.readline(4) != b"\r\n":
        raise EOFError("Truncated MJPEG frame")
    return jpeg


class CameraPreviewWorker(QObject):
    connected = Signal()
    reconnecting = Signal(str)
    failed = Signal(str)
    finished = Signal()

    def __init__(self, url: str, *, source_address: str | None = None) -> None:
        super().__init__()
        self.url = url
        self.source_address = source_address
        self._stopping = Event()
        self._lock = Lock()
        self._latest: tuple[QImage, float, int] | None = None
        self._frames = 0
        self.enabled = Event()
        self.enabled.set()

    def take_latest(self) -> tuple[QImage, float, int] | None:
        with self._lock:
            latest, self._latest = self._latest, None
            return latest

    def stop(self) -> None:
        self._stopping.set()

    @Slot()
    def run(self) -> None:
        connection: HTTPConnection | None = None
        response: HTTPResponse | None = None
        try:
            address = urlsplit(self.url)
            if address.scheme != "http" or not address.hostname or address.username or address.password:
                raise ValueError("Expected an HTTP MJPEG URL")
            retry=.25
            while not self._stopping.is_set():
                if not self.enabled.is_set():
                    self._stopping.wait(0.1)
                    continue
                source = {"source_address": (self.source_address, 0)} if self.source_address else {}
                connection = HTTPConnection(address.hostname, address.port or 80, timeout=2, **source)
                try:
                    connection.request("GET", address.path or "/camera.mjpg")
                    response = connection.getresponse()
                    if response.status==503:raise ConnectionError('Preview is recovering')
                    if response.status != 200:
                        raise ValueError(f"Camera HTTP status {response.status}")
                    if response.headers.get_content_type() != "multipart/x-mixed-replace":
                        raise ValueError("Expected an MJPEG camera stream")
                    self.connected.emit()
                    last_data=time.monotonic()
                    while not self._stopping.is_set() and self.enabled.is_set():
                        if not select.select([response.fp], [], [], 0.05)[0]:
                            if time.monotonic()-last_data>5:raise TimeoutError('No new preview frame')
                            continue
                        image = QImage.fromData(read_mjpeg_frame(response), "JPEG")
                        if image.isNull():raise EOFError("Invalid camera JPEG frame")
                        retry=.25;last_data=time.monotonic()
                        with self._lock:
                            self._frames += 1
                            self._latest = (image, last_data, self._frames)
                except (OSError,HTTPException,EOFError) as error:
                    if not self._stopping.is_set():
                        self.reconnecting.emit(str(error))
                        self._stopping.wait(retry);retry=min(3.,retry*2)
                finally:
                    if response is not None:response.close()
                    connection.close();response,connection=None,None
        except (OSError, HTTPException, RuntimeError, ValueError, EOFError) as error:
            if not self._stopping.is_set():
                self.failed.emit(str(error))
        finally:
            if response is not None:
                response.close()
            if connection is not None:
                connection.close()
            self.finished.emit()


VISION_DEBUG_VIEWS = (
    "输入与 ROI",
    "肤色阈值",
    "膨胀与高斯",
    "候选与选中轮廓",
    "凸包、缺陷与中心",
    "方向与死区",
)


def vision_debug_tile(image: QImage, index: int) -> QImage:
    if image.width() != 960 or image.height() != 360:
        raise ValueError("Expected a 960 x 360 vision debug sheet")
    if not 0 <= index < len(VISION_DEBUG_VIEWS):
        raise ValueError("Invalid vision debug view")
    return image.copy((index % 3) * 320, (index // 3) * 180, 320, 180)


class VisionDebugWorker(QObject):
    finished = Signal()

    def __init__(self, url: str, poll_fps: int | None = None, *, source_address: str | None = None) -> None:
        super().__init__()
        self.url = url
        self.source_address = source_address
        self.poll_fps = poll_fps
        self._generation = None
        self._stopping = Event()
        self.enabled = Event()
        self._lock = Lock()
        self._latest: tuple[QImage | None, float, str] | None = None

    def stop(self) -> None:
        self._stopping.set()

    def take_latest(self) -> tuple[QImage | None, float, str] | None:
        with self._lock:
            latest, self._latest = self._latest, None
            return latest

    @Slot()
    def run(self) -> None:
        try:
            address = urlsplit(self.url)
            if address.scheme != "http" or not address.hostname or address.username or address.password:
                raise ValueError("Expected an HTTP vision URL")
            while not self._stopping.is_set():
                if not self.enabled.is_set():
                    self._stopping.wait(0.1)
                    continue
                started = time.monotonic()
                source = {"source_address": (self.source_address, 0)} if self.source_address else {}
                connection = HTTPConnection(address.hostname, address.port or 80, timeout=0.8, **source)
                response: HTTPResponse | None = None
                image: QImage | None = None
                message = ""
                try:
                    path='/debug.jpg' if self._generation is None else f'/debug.jpg?after={self._generation}'
                    connection.request("GET", path, headers={"Cache-Control": "no-cache"})
                    response = connection.getresponse()
                    if response.status == 204:
                        pass  # No new frame; never decode the same JPEG again.
                    elif response.status == 503:
                        self._generation = None
                        message = "等待处理画面"
                    elif response.status != 200:
                        raise ValueError(f"Debug HTTP status {response.status}")
                    else:
                        if response.headers.get_content_type() != "image/jpeg":
                            raise ValueError("Expected a vision debug JPEG")
                        length = int(response.getheader("Content-Length", "0"))
                        if not 0 < length <= 5_000_000:
                            raise ValueError("Invalid vision debug JPEG size")
                        payload = response.read(length)
                        if len(payload) != length:
                            raise EOFError("Truncated vision debug JPEG")
                        generation=response.getheader('X-Preview-Generation')
                        self._generation=int(generation) if generation is not None else None
                        image = QImage.fromData(payload, "JPEG")
                        vision_debug_tile(image, 0)
                except (OSError, HTTPException, ValueError, EOFError) as error:
                    self._generation = None
                    image, message = None, str(error)
                finally:
                    if response is not None:
                        response.close()
                    connection.close()
                with self._lock:
                    self._latest = (image, time.monotonic(), message)
                delay = (.1 if image is None or self._generation is None else 0.) if self.poll_fps is None else max(
                    0.,1./max(1,self.poll_fps)-(time.monotonic()-started))
                self._stopping.wait(delay)
        except ValueError as error:
            with self._lock:
                self._latest = (None, time.monotonic(), str(error))
        finally:
            self.finished.emit()


class VisionResultWorker(QObject):
    finished = Signal()

    def __init__(self, url: str, *, source_address: str | None = None) -> None:
        super().__init__()
        self.url = url
        self.source_address = source_address
        self._stopping = Event()
        self._lock = Lock()
        self._io_lock = Lock()
        self._active_socket: socket.socket | None = None
        self._receiver = VisionResultReceiver()
        self._reachable: bool | None = None

    def snapshot(self) -> tuple[VisionResultSnapshot, bool | None]:
        with self._lock:
            return self._receiver.expire(time.monotonic()), self._reachable

    def _interrupt(self) -> None:
        with self._io_lock:
            active_socket = self._active_socket
            if active_socket is not None:
                try:
                    active_socket.shutdown(socket.SHUT_RDWR)
                except OSError:
                    pass

    def stop(self) -> None:
        self._stopping.set()
        with self._lock:
            self._receiver.release(time.monotonic(), "Observation disconnected", status="OFFLINE")
        self._interrupt()

    @Slot()
    def run(self) -> None:
        try:
            address = urlsplit(self.url)
            if address.scheme != "http" or not address.hostname or address.username or address.password:
                raise ValueError("Expected an HTTP vision URL")
            while not self._stopping.is_set():
                started = time.monotonic()
                source = {"source_address": (self.source_address, 0)} if self.source_address else {}
                connection = HTTPConnection(address.hostname, address.port or 80, timeout=0.1, **source)
                response: HTTPResponse | None = None
                deadline: Timer | None = None
                reachable = False
                try:
                    connection.connect()
                    with self._io_lock:
                        self._active_socket = connection.sock
                    deadline = Timer(0.8, self._interrupt)
                    deadline.daemon = True
                    deadline.start()
                    if self._stopping.is_set():
                        self._interrupt()
                        break
                    connection.request("GET", "/result.json", headers={"Cache-Control": "no-cache"})
                    response = connection.getresponse()
                    reachable = True
                    if response.status != 200:
                        raise ValueError(f"Result HTTP status {response.status}")
                    if response.headers.get_content_type() != "application/json":
                        raise ValueError("Expected a vision JSON result")
                    length = int(response.getheader("Content-Length", "0"))
                    if not 0 < length <= 262_144:
                        raise ValueError("Invalid vision JSON size")
                    if self._stopping.is_set():
                        break
                    payload = response.read(length)
                    if len(payload) != length:
                        raise EOFError("Truncated vision JSON result")
                    packet = json.loads(payload)
                    with self._lock:
                        if not self._stopping.is_set():
                            self._reachable = True
                            self._receiver.consume(packet, time.monotonic())
                except (OSError, HTTPException, ValueError, EOFError, RecursionError) as error:
                    with self._lock:
                        if not self._stopping.is_set():
                            self._reachable = reachable
                            self._receiver.release(time.monotonic(), str(error))
                finally:
                    if deadline is not None:
                        deadline.cancel()
                        deadline.join()
                    with self._io_lock:
                        self._active_socket = None
                    if response is not None:
                        response.close()
                    connection.close()
                self._stopping.wait(max(0.0, 0.1 - (time.monotonic() - started)))
        except ValueError as error:
            with self._lock:
                if not self._stopping.is_set():
                    self._receiver.release(time.monotonic(), str(error))
        finally:
            self.finished.emit()


class AdapterWorkspace(QWidget):
    def __init__(self, eyebrow: str, title: str, slot_name: str) -> None:
        super().__init__()
        self.stream_buffer = BoundedStreamBuffer()
        self.refresh_timer = QTimer(self)
        self.refresh_timer.setSingleShot(True)
        self.refresh_timer.setInterval(50)
        self.refresh_timer.timeout.connect(self.flush_stream)
        self._image = QImage()
        self._stream_is_agent = False
        root = QVBoxLayout(self)
        root.setContentsMargins(12, 10, 12, 10)
        root.setSpacing(8)
        heading = QLabel(title)
        heading.setObjectName("sectionLabel")
        root.addWidget(heading)

        body = QSplitter(Qt.Orientation.Horizontal)
        self.body_splitter = body
        body.setChildrenCollapsible(False)
        canvas_panel = QFrame()
        canvas_panel.setObjectName("workspacePanel")
        canvas_layout = QVBoxLayout(canvas_panel)
        canvas_layout.setContentsMargins(12, 12, 12, 12)
        self.canvas_source = QLabel(f"{slot_name} / 等待数据")
        self.canvas_source.setObjectName("mutedLabel")
        canvas_layout.addWidget(self.canvas_source)
        self.canvas = QLabel("等待数据")
        self.canvas.setObjectName("emptyCanvas")
        self.canvas.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.canvas.setSizePolicy(QSizePolicy.Policy.Ignored, QSizePolicy.Policy.Ignored)
        self.canvas.installEventFilter(self)
        canvas_layout.addWidget(self.canvas, 1)
        canvas_panel.setMinimumWidth(320)
        body.addWidget(canvas_panel)

        inspector = QFrame()
        inspector.setObjectName("inspectorPanel")
        inspector.setMinimumWidth(260)
        inspector_layout = QVBoxLayout(inspector)
        inspector_layout.setContentsMargins(12, 12, 12, 12)
        inspector_layout.setSpacing(10)
        inspector_layout.addWidget(QLabel("数据回读"))
        self.contract_value = _value_label("Pending adapter")
        self.frames_value = _value_label("0")
        self.latency_value = _value_label("--")
        self.drop_value = _value_label("0")
        inspector_layout.addWidget(_named_value("Topic", self.contract_value))
        inspector_layout.addWidget(_named_value("Frames / 会话", self.frames_value))
        inspector_layout.addWidget(_named_value("时标差 / UI", self.latency_value))
        self.latency_value.setToolTip("Agent: 源时间戳与 PC 时间差；HTTP: 解码完成至 UI 显示时间")
        inspector_layout.addWidget(_named_value("Dropped/stale/order", self.drop_value))
        inspector_layout.addStretch()
        self.stream_status = QLabel("No source attached")
        self.stream_status.setObjectName("mutedLabel")
        self.stream_status.setTextFormat(Qt.TextFormat.PlainText)
        self.stream_status.setWordWrap(True)
        inspector_layout.addWidget(self.stream_status)
        scroll = QScrollArea()
        scroll.setWidgetResizable(True)
        scroll.setWidget(inspector)
        scroll.setMinimumWidth(280)
        body.addWidget(scroll)
        body.setSizes((760, 300))
        body.setStretchFactor(0, 1)
        root.addWidget(body, 1)

    def accept_frame(self, frame: ProtocolFrame) -> bool:
        accepted = self.stream_buffer.push(frame)
        if accepted and not self.refresh_timer.isActive():
            self.refresh_timer.start()
        self._refresh_counters()
        return accepted

    def flush_stream(self) -> None:
        for sample in self.stream_buffer.drain():
            self._show_sample(sample)
        self._refresh_counters()

    def stop(self) -> None:
        self.refresh_timer.stop()

    def _show_sample(self, sample: StreamSample) -> None:
        self._stream_is_agent = True
        self.canvas_source.setText(f"Agent DATA / {sample.topic}")
        self.contract_value.setText(sample.topic)
        self.stream_status.setText(
            f"Source {sample.frame.source_id} / channel {sample.frame.channel_id} / seq {sample.frame.sequence}"
        )
        if sample.frame.timestamp_ns:
            latency_ms = max(0.0, (time.time_ns() - sample.frame.timestamp_ns) / 1_000_000)
            self.latency_value.setText(f"{latency_ms:.1f} ms")
        body = sample.body
        if sample.topic == "fixture.frame2d" and body is not None:
            self._show_fixture_frame(body)
        elif sample.topic in ("fixture.series", "fixture.spectrum") and body is not None:
            self._show_fixture_series(body)
        else:
            self._image = QImage()
            self.canvas.setPixmap(QPixmap())
            self.canvas.setText(f"{sample.topic.upper()}\n{len(sample.frame.payload)} BYTES")

    def _show_fixture_frame(self, body: dict[str, object]) -> None:
        width = body.get("width")
        height = body.get("height")
        encoded = body.get("data_base64")
        if not isinstance(width, int) or not isinstance(height, int) or not isinstance(encoded, str):
            raise ValueError("fixture.frame2d fields are invalid")
        rgb = base64.b64decode(encoded, validate=True)
        if len(rgb) != width * height * 3:
            raise ValueError("fixture.frame2d RGB length mismatch")
        self._image = QImage(rgb, width, height, width * 3, QImage.Format.Format_RGB888).copy()
        rectangles = body.get("rectangles", [])
        if isinstance(rectangles, list):
            painter = QPainter(self._image)
            painter.setPen(QPen(QColor(ACCENT), 1))
            for rectangle in rectangles:
                if (
                    isinstance(rectangle, list)
                    and len(rectangle) == 4
                    and all(isinstance(value, int) for value in rectangle)
                ):
                    painter.drawRect(*rectangle)
            painter.end()
        self.canvas.setText("")
        self._refresh_pixmap()

    def _show_fixture_series(self, body: dict[str, object]) -> None:
        values = body.get("values")
        if not isinstance(values, list) or not values or not all(isinstance(value, (int, float)) for value in values):
            raise ValueError("fixture series values are invalid")
        width, height = 640, 300
        self._image = QImage(width, height, QImage.Format.Format_RGB888)
        self._image.fill(QColor("#101820"))
        minimum = float(min(values))
        maximum = float(max(values))
        span = maximum - minimum or 1.0
        painter = QPainter(self._image)
        painter.setRenderHint(QPainter.RenderHint.Antialiasing)
        painter.setPen(QPen(QColor("#f2c14e"), 2))
        points = []
        for index, value in enumerate(values):
            x = int(index * (width - 1) / max(1, len(values) - 1))
            y = int((maximum - float(value)) * (height - 1) / span)
            points.append((x, y))
        for start, end in zip(points, points[1:]):
            painter.drawLine(start[0], start[1], end[0], end[1])
        painter.end()
        self.canvas.setText("")
        self._refresh_pixmap()

    def _refresh_pixmap(self) -> None:
        if self._image.isNull():
            return
        self.canvas.setPixmap(
            QPixmap.fromImage(self._image).scaled(
                self.canvas.size(),
                Qt.AspectRatioMode.KeepAspectRatio,
                Qt.TransformationMode.SmoothTransformation,
            )
        )

    def _refresh_counters(self) -> None:
        counters = self.stream_buffer.counters
        self.frames_value.setText(str(counters.accepted))
        self.drop_value.setText(
            f"{counters.dropped}/{counters.stale}/{counters.out_of_order}"
        )

    def mark_stream_historical(self) -> None:
        if not self._stream_is_agent and not self.refresh_timer.isActive():
            return
        self.flush_stream()
        self.refresh_timer.stop()
        if self._stream_is_agent:
            self.canvas_source.setText(f"Agent DATA / {self.contract_value.text()} / 历史")

    def begin_stream_session(self) -> None:
        self.refresh_timer.stop()
        self.stream_buffer = BoundedStreamBuffer()
        if self._stream_is_agent:
            self._refresh_counters()

    def resizeEvent(self, event) -> None:  # type: ignore[no-untyped-def]
        super().resizeEvent(event)
        self._refresh_pixmap()

    def eventFilter(self, watched: QObject, event: QEvent) -> bool:
        if watched is self.canvas and event.type() is QEvent.Type.Resize:
            self._refresh_pixmap()
        return super().eventFilter(watched, event)


class VisionControlWorker(QObject):
    received = Signal(object)
    failed = Signal(str)
    finished = Signal()

    def __init__(self, host: str, port: int, command: AgentCommand,
                 source_address: str | None = None, expected_build_id: int | None = None) -> None:
        super().__init__()
        self.session = VisionAgentSession(host, port, source_address=source_address, expected_build_id=expected_build_id)
        self.command = command
        self._stopping = Event()

    @Slot()
    def run(self) -> None:
        try:
            if not self._stopping.is_set():
                result = self.session.request(self.command, cancelled=self._stopping.is_set)
                if not self._stopping.is_set():
                    self.received.emit(result)
        except (ConnectionError, OSError, RuntimeError, ValueError) as error:
            if not self._stopping.is_set():
                self.failed.emit(str(error))
        finally:
            self.session.close()
            self.finished.emit()

    def stop(self) -> None:
        self._stopping.set()
        self.session.close()


class VisionWorkspace(AdapterWorkspace):
    camera_status_changed = Signal(str, str)

    def __init__(self, camera_url: str = "http://192.168.2.99:8088/camera.mjpg") -> None:
        super().__init__("VISION WORKSPACE", "视觉与相机回读", "FRAME VIEW")
        self._suggested_camera_url = camera_url
        self._control_thread: QThread | None = None
        self._control_worker: VisionControlWorker | None = None
        self._control_closing = False
        self._control_observing = False
        self._control_source_address: str | None = None
        self._control_expected_build_id: int | None = None
        self._control_timer = QTimer(self)
        self._control_timer.setInterval(1000)
        self._control_timer.timeout.connect(self._poll_vision_control)
        self._camera_thread: QThread | None = None
        self._camera_worker: CameraPreviewWorker | None = None
        self._camera_stopping = False
        self._camera_error = False
        self._rendered = 0
        self._fps_origin = None
        self._fps_origin_frames = 0
        self._image_fps = 0.
        self._debug_frames = 0
        self._last_result_render = 0.
        self._last_debug_render = 0.
        self._debug_thread: QThread | None = None
        self._debug_worker: VisionDebugWorker | None = None
        self._debug_sheet = QImage()
        self._debug_received_at = 0.0
        self._debug_message = "等待处理画面"
        self._preview_image = QImage()
        self._result_thread: QThread | None = None
        self._result_worker: VisionResultWorker | None = None
        self._result_snapshot = VisionResultSnapshot(status="OFFLINE", message="Observation disconnected")
        self._camera_timer = QTimer(self)
        self._camera_timer.setInterval(16)
        self._camera_timer.timeout.connect(self._refresh_camera)

        controls = QHBoxLayout()
        self.camera_url = QLineEdit(camera_url)
        self.camera_url.setPlaceholderText(camera_url)
        controls.addWidget(self.camera_url, 1)
        controls.addWidget(QLabel("自动帧率 · 最新画面"))
        self.camera_button = QToolButton()
        self.camera_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaPlay))
        self.camera_button.setToolTip("开启回传与灵巧手跟随；暂停板端页面交互和游戏")
        self.camera_button.clicked.connect(self.toggle_camera)
        controls.addWidget(self.camera_button)
        layout = self.layout()
        assert isinstance(layout, QVBoxLayout)
        layout.insertLayout(1, controls)
        service_controls = QHBoxLayout()
        service_controls.addWidget(QLabel("视觉 Agent"))
        self.vision_agent_host = QLineEdit(urlsplit(camera_url).hostname or "192.168.2.99")
        self.vision_agent_host.setMinimumWidth(120)
        self.vision_agent_host.setToolTip("VISION_ONLY Agent 主机")
        service_controls.addWidget(self.vision_agent_host, 1)
        self.vision_agent_port = QSpinBox()
        self.vision_agent_port.setRange(1, 65535)
        self.vision_agent_port.setValue(8766)
        self.vision_agent_port.setToolTip("VISION_ONLY Agent TCP 端口")
        service_controls.addWidget(self.vision_agent_port)
        self.vision_service_status = QLabel("未查询")
        self.vision_service_status.setTextFormat(Qt.TextFormat.PlainText)
        self.vision_service_status.setMinimumWidth(90)
        service_controls.addWidget(self.vision_service_status)
        self.vision_start_button = QToolButton()
        self.vision_stop_button = QToolButton()
        self.vision_status_button = QToolButton()
        for button, icon, tooltip, command in (
            (self.vision_start_button, QStyle.StandardPixmap.SP_MediaPlay, "启动板端视觉服务", AgentCommand.VISION_START),
            (self.vision_stop_button, QStyle.StandardPixmap.SP_MediaStop, "停止板端视觉服务 / 重试清理", AgentCommand.VISION_STOP),
            (self.vision_status_button, QStyle.StandardPixmap.SP_BrowserReload, "查询板端视觉状态", AgentCommand.VISION_STATUS),
        ):
            button.setIcon(self.style().standardIcon(icon))
            button.setToolTip(tooltip)
            button.setAccessibleName(tooltip)
            button.setFixedSize(32, 32)
            button.clicked.connect(lambda checked=False, selected=command: self.request_vision_control(selected))
            service_controls.addWidget(button)
        layout.insertLayout(2, service_controls)
        self.camera_url.setToolTip("HTTP MJPEG / 独立相机服务；相机 Overlay 与 C6I 分别运行")
        self.vision_views = QListWidget()
        self.vision_views.setAccessibleName("视觉回传画面")
        self.vision_views.addItems(["实时预览", *VISION_DEBUG_VIEWS])
        self.vision_views.setMinimumWidth(160)
        self.vision_views.setMaximumWidth(220)
        self.vision_views.setCurrentRow(0)
        self.vision_views.currentRowChanged.connect(self._select_vision_view)
        self.body_splitter.insertWidget(0, self.vision_views)
        self.body_splitter.setSizes((180, 680, 280))
        self.body_splitter.setStretchFactor(0, 0)
        self.body_splitter.setStretchFactor(1, 1)
        inspector_scroll = self.body_splitter.widget(2)
        assert isinstance(inspector_scroll, QScrollArea)
        inspector = inspector_scroll.widget()
        assert inspector is not None
        inspector_layout = inspector.layout()
        assert isinstance(inspector_layout, QVBoxLayout)
        self.result_status_value = _value_label("已断开")
        self.result_status_value.setObjectName("visionResultStatus")
        self.result_network_value = _value_label("已断开")
        self.result_run_value = _value_label("--")
        self.result_frame_value = _value_label("--")
        self.result_direction_value = _value_label("IDLE")
        self.result_age_value = _value_label("--")
        self.result_server_age_value = _value_label("--")
        self.image_fps_value = _value_label("--")
        self.result_details_value = QPlainTextEdit()
        self.result_details_value.setObjectName("visionResultDetails")
        self.result_details_value.setReadOnly(True)
        self.result_details_value.setMinimumHeight(180)
        self.result_details_value.setMaximumHeight(250)
        self.result_details_value.setAccessibleName("视觉识别详情")
        self.result_details_value.setToolTip("来自右侧源帧对应的 result.json；独立于图像回传，不假定同帧")
        for name, value in (
            ("回传帧率", self.image_fps_value),
            ("结果 HTTP", self.result_network_value),
            ("判断状态", self.result_status_value),
            ("Run", self.result_run_value),
            ("源帧", self.result_frame_value),
            ("方向", self.result_direction_value),
            ("新帧年龄 / 本机", self.result_age_value),
            ("结果年龄 / 服务端", self.result_server_age_value),
        ):
            value.setTextFormat(Qt.TextFormat.PlainText)
            inspector_layout.insertWidget(inspector_layout.count() - 2, _named_value(name, value))
        self.result_age_value.setToolTip("本机自最近新源帧起经过的时间；重复 HTTP 回包不续期")
        self.result_server_age_value.setToolTip("最近 JSON 报告的 server_age_ms，与图像年龄分别计算")
        # Keep the camera pixels unobstructed; all source/status text lives here.
        canvas_layout = self.canvas.parentWidget().layout()
        canvas_layout.removeWidget(self.canvas_source)
        self.canvas_source.setWordWrap(True)
        inspector_layout.insertWidget(0, self.canvas_source)
        details_panel = QWidget()
        details_layout = QVBoxLayout(details_panel)
        details_layout.setContentsMargins(0, 0, 0, 0)
        details_layout.setSpacing(6)
        details_label = QLabel("识别详情 / 独立结果帧")
        details_label.setObjectName("metricName")
        details_layout.addWidget(details_label)
        details_layout.addWidget(self.result_details_value)
        inspector_layout.insertWidget(inspector_layout.count() - 2, details_panel)
        self._render_result(None)

    @property
    def control_busy(self) -> bool:
        return self._control_thread is not None

    def set_vision_agent(self, host: str, *, source_address: str | None = None, expected_build_id: int | None = None) -> None:
        if self.control_busy or self._control_observing:
            return
        self.vision_agent_host.setText(host)
        self._control_source_address = source_address
        self._control_expected_build_id = expected_build_id

    def set_vision_control_available(self, available: bool) -> None:
        self._vision_control_available = available
        self._update_vision_controls()

    def request_vision_control(self, command: AgentCommand) -> None:
        if not getattr(self, "_vision_control_available", True):
            return
        if self.control_busy or self._control_closing:
            return
        host = self.vision_agent_host.text().strip()
        if not host:
            self._vision_control_failed("视觉 Agent 主机为空")
            return
        self._control_observing = True
        self._control_timer.start()
        thread = QThread(self)
        worker = VisionControlWorker(host, self.vision_agent_port.value(), command,
                                     self._control_source_address, expected_build_id=self._control_expected_build_id)
        worker.moveToThread(thread)
        thread.started.connect(worker.run)
        worker.received.connect(self._vision_control_received, Qt.ConnectionType.QueuedConnection)
        worker.failed.connect(self._vision_control_failed, Qt.ConnectionType.QueuedConnection)
        worker.finished.connect(thread.quit, Qt.ConnectionType.DirectConnection)
        worker.finished.connect(worker.deleteLater)
        thread.finished.connect(self._vision_control_finished)
        self._control_thread, self._control_worker = thread, worker
        self.vision_service_status.setText("请求中")
        self._update_vision_controls()
        thread.start()

    @Slot()
    def _poll_vision_control(self) -> None:
        if self._control_observing and not self.control_busy:
            self.request_vision_control(AgentCommand.VISION_STATUS)

    def _update_vision_controls(self) -> None:
        enabled = (getattr(self, "_vision_control_available", True)
                   and not self.control_busy and not self._control_closing)
        for widget in (self.vision_start_button, self.vision_stop_button, self.vision_status_button):
            widget.setEnabled(enabled)
        self.vision_agent_host.setEnabled(enabled and not self._control_observing)
        self.vision_agent_port.setEnabled(enabled and not self._control_observing)

    @Slot(object)
    def _vision_control_received(self, result: dict) -> None:
        if self._control_closing:
            return
        status = result["snapshot"]["vision"]
        state = status.get("state", "FAULT")
        held = status.get("owner_held") is True
        labels = {"IDLE": "空闲", "STARTING": "启动中", "RUNNING": "运行中",
                  "STOPPING": "停止中", "FAULT": "故障"}
        text = labels.get(state, "未知") + (" / 占用" if held else "")
        self.vision_service_status.setText(text)
        self.vision_service_status.setToolTip(json.dumps(result, ensure_ascii=False, indent=2))
        self._control_observing = state in ("STARTING", "RUNNING", "STOPPING") or held
        if not self._control_observing:
            self._control_timer.stop()

    @Slot(str)
    def _vision_control_failed(self, message: str) -> None:
        self.vision_service_status.setText("链路错误")
        self.vision_service_status.setToolTip(message + "；板端状态待确认")
        self._control_observing = False
        self._control_timer.stop()

    @Slot()
    def _vision_control_finished(self) -> None:
        thread = self._control_thread
        if thread is not None:
            if not thread.wait(100):
                QTimer.singleShot(25, self._vision_control_finished)
                return
            thread.deleteLater()
        self._control_thread, self._control_worker = None, None
        self._update_vision_controls()

    @property
    def camera_running(self) -> bool:
        return self._camera_thread is not None and self._camera_thread.isRunning()

    def set_camera_host(self, host: str, *, port: int = 8088) -> None:
        suggested = f"http://{host}:{port}/camera.mjpg"
        if not self._http_attached() and self.camera_url.text() == self._suggested_camera_url:
            self.camera_url.setText(suggested)
        self._suggested_camera_url = suggested

    def toggle_camera(self) -> None:
        if self._http_attached():
            self.stop_camera()
        else:
            self.start_camera()

    def start_camera(self) -> None:
        if self._http_attached():
            return
        self.refresh_timer.stop()
        self.stream_buffer.drain()
        self._camera_stopping = False
        self._camera_error = False
        self._rendered = 0
        self._fps_origin = None
        self._fps_origin_frames = 0
        self._image_fps = 0.
        self._debug_frames = 0
        self.image_fps_value.setText('--')
        self._image = QImage()
        self._preview_image = QImage()
        self._debug_sheet = QImage()
        self._debug_received_at = 0.0
        self._debug_message = "等待处理画面"
        self._result_snapshot = VisionResultSnapshot()
        self._render_result(None)
        self._stream_is_agent = False
        self.canvas_source.setText("HTTP MJPEG / 连接中")
        self.camera_status_changed.emit("CAM 连接中", "waiting")
        self.canvas.clear()
        self.canvas.setText("Connecting...")
        self.stream_status.setText("Connecting to camera")
        self.frames_value.setText("0")
        self.drop_value.setText("0/0/0")
        self.camera_url.setEnabled(False)
        self.camera_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaStop))
        self.camera_button.setToolTip("Disconnect camera")
        thread = QThread(self)
        worker = CameraPreviewWorker(self.camera_url.text().strip(), source_address=self._control_source_address)
        if self.vision_views.currentRow() > 0:
            worker.enabled.clear()
        worker.moveToThread(thread)
        thread.started.connect(worker.run)
        worker.connected.connect(self._camera_connected, Qt.ConnectionType.QueuedConnection)
        worker.reconnecting.connect(self._camera_reconnecting, Qt.ConnectionType.QueuedConnection)
        worker.failed.connect(self._camera_failed, Qt.ConnectionType.QueuedConnection)
        worker.finished.connect(thread.quit, Qt.ConnectionType.DirectConnection)
        worker.finished.connect(worker.deleteLater)
        self._camera_thread = thread
        self._camera_worker = worker
        self._camera_timer.start()
        thread.start()
        debug_thread = QThread(self)
        debug_worker = VisionDebugWorker(self.camera_url.text().strip(),
                        source_address=self._control_source_address)
        debug_worker.moveToThread(debug_thread)
        debug_thread.started.connect(debug_worker.run)
        debug_worker.finished.connect(debug_thread.quit, Qt.ConnectionType.DirectConnection)
        debug_worker.finished.connect(debug_worker.deleteLater)
        self._debug_thread, self._debug_worker = debug_thread, debug_worker
        self._select_vision_view(self.vision_views.currentRow())
        debug_thread.start()
        result_thread = QThread(self)
        result_worker = VisionResultWorker(self.camera_url.text().strip(), source_address=self._control_source_address)
        result_worker.moveToThread(result_thread)
        result_thread.started.connect(result_worker.run)
        result_worker.finished.connect(result_thread.quit, Qt.ConnectionType.DirectConnection)
        result_worker.finished.connect(result_worker.deleteLater)
        self._result_thread, self._result_worker = result_thread, result_worker
        result_thread.start()

    def _http_attached(self) -> bool:
        return any(thread is not None for thread in (
            self._camera_thread, self._debug_thread, self._result_thread,
        ))

    def _update_http_controls(self) -> None:
        attached = self._http_attached()
        self.camera_url.setEnabled(not attached)
        self.camera_button.setEnabled(not (attached and self._camera_stopping))
        icon = QStyle.StandardPixmap.SP_MediaStop if attached else QStyle.StandardPixmap.SP_MediaPlay
        self.camera_button.setIcon(self.style().standardIcon(icon))
        self.camera_button.setToolTip("关闭回传并恢复板端页面" if attached else "开启回传与灵巧手跟随；暂停板端页面交互和游戏")

    def stop_camera(self, *, wait: bool = False) -> bool:
        if not self._http_attached():
            return True
        self._camera_stopping = True
        self.camera_status_changed.emit("CAM 停止中", "waiting")
        self.stream_status.setText("Stopping camera")
        for worker in (self._camera_worker, self._debug_worker, self._result_worker):
            if worker is not None:
                worker.stop()
        self._result_snapshot = VisionResultSnapshot(status="OFFLINE", message="Observation disconnected")
        self._render_result(None)
        self._update_http_controls()
        stopped = True
        if wait:
            for thread in (self._camera_thread, self._debug_thread, self._result_thread):
                if thread is not None:
                    thread.quit()
                    if not thread.wait(4000):
                        stopped = False
            if not stopped:
                self.stream_status.setText("HTTP worker 停止超时，保留线程并等待清理")
                self._camera_timer.start()
            else:
                self._refresh_camera()
        return stopped

    def _render_result(self, reachable: bool | None) -> None:
        snapshot = self._result_snapshot
        labels = {
            "ACTIVE": "有效", "WAITING": "等待", "STALE": "过期",
            "INVALID": "失效", "ERROR": "链路错误", "OFFLINE": "已断开",
        }
        self.result_status_value.setText(labels.get(snapshot.status, snapshot.status))
        self.result_status_value.setToolTip(snapshot.message)
        color = "success" if snapshot.valid else (
            "muted" if snapshot.status == "OFFLINE" else "waiting" if snapshot.status == "WAITING" else "error"
        )
        if self.result_status_value.property("status") != color:
            self.result_status_value.setProperty("status", color)
            self.result_status_value.style().unpolish(self.result_status_value)
            self.result_status_value.style().polish(self.result_status_value)
        self.result_network_value.setText(
            "已断开" if snapshot.status == "OFFLINE" else
            "可达" if reachable is True else "不可达" if reachable is False else "等待"
        )
        run_id = snapshot.run_id or "--"
        self.result_run_value.setText(self.result_run_value.fontMetrics().elidedText(run_id, Qt.TextElideMode.ElideRight, 140))
        self.result_run_value.setToolTip(run_id)
        frame_text = (
            f"{snapshot.frame_id}{'' if snapshot.valid else ' / 历史'}" if snapshot.frame_id else "--"
        )
        self.result_frame_value.setText(self.result_frame_value.fontMetrics().elidedText(frame_text, Qt.TextElideMode.ElideRight, 140))
        self.result_frame_value.setToolTip(frame_text)
        self.result_direction_value.setText(snapshot.direction)
        self.result_age_value.setText(f"{snapshot.local_age_ms:.0f} ms" if snapshot.local_age_ms is not None else "--")
        self.result_server_age_value.setText(f"{snapshot.server_age_ms:.0f} ms" if snapshot.server_age_ms is not None else "--")
        details = "\n".join(f"{name}  {value}" for name, value in snapshot.details)
        prefix = f"源帧 {snapshot.frame_id}" if snapshot.frame_id else "等待识别结果"
        if snapshot.frame_id and not snapshot.valid:
            prefix += " / 历史"
        display = prefix + ("\n" + details if details else "")
        if self.result_details_value.toPlainText() != display:
            self.result_details_value.setPlainText(display)

    @Slot(int)
    def _select_vision_view(self, index: int) -> None:
        self._fps_origin=None
        self.image_fps_value.setText('--')
        if self._camera_worker is not None:
            if index <= 0:
                self._camera_worker.enabled.set()
            else:
                self._camera_worker.enabled.clear()
        if self._debug_worker is not None:
            if index > 0:
                self._debug_worker.enabled.set()
            else:
                self._debug_worker.enabled.clear()
        self._show_vision_view()

    def _show_vision_view(self) -> None:
        index = self.vision_views.currentRow()
        if index <= 0:
            self._image = self._preview_image
            if not self._image.isNull():
                self.canvas_source.setText(f"HTTP MJPEG / {self._image.width()} x {self._image.height()}")
        else:
            self._image = (
                vision_debug_tile(self._debug_sheet, index - 1)
                if not self._debug_sheet.isNull() else QImage()
            )
            age = max(0.0, time.monotonic() - self._debug_received_at)
            state = "历史画面" if self._camera_stopping or self._debug_message or age > 2.5 else "调试快照"
            self.canvas_source.setText(f"HTTP debug.jpg / {VISION_DEBUG_VIEWS[index - 1]} / {state}")
            self.latency_value.setText(f"接收后 {age:.1f} s" if self._debug_received_at else "--")
            self.stream_status.setText(self._debug_message or "调试图 / 320 x 180 / 自动帧率")
        if self._image.isNull():
            self.canvas.setPixmap(QPixmap())
            self.canvas.setText("等待画面" if index <= 0 else self._debug_message or "等待处理画面")
        else:
            self.canvas.setText("")
            self._refresh_pixmap()

    @Slot()
    def _camera_connected(self) -> None:
        self._camera_error=False
        if not self._camera_stopping and self.vision_views.currentRow() == 0:
            self.stream_status.setText("Camera connected")
            self.contract_value.setText("camera.mjpeg")
            self.canvas_source.setText("HTTP MJPEG / 等待帧")
            self.camera_status_changed.emit("CAM HTTP / 等待帧", "waiting")

    @Slot(str)
    def _camera_reconnecting(self,message):
        self.stream_status.setText('回传恢复中：'+message)
        self.canvas_source.setText('HTTP MJPEG / 历史画面 / 自动重连')
        self.image_fps_value.setText('--')
        self._fps_origin=None
        self.camera_status_changed.emit('CAM 自动重连','waiting')

    @Slot(str)
    def _camera_failed(self, message: str) -> None:
        self._camera_error = True
        self.stream_status.setText(message)
        self.canvas_source.setText("HTTP MJPEG / 历史画面")
        self.camera_status_changed.emit(f"CAM: {message}", "error")

    @Slot()
    def _camera_finished(self) -> None:
        if self._debug_worker is not None:
            self._debug_worker.stop()
        thread = self._camera_thread
        if thread is not None and not thread.wait(4000):
            return
        self._camera_thread = None
        self._camera_worker = None
        if thread is not None:
            thread.deleteLater()
        self._update_http_controls()
        if not self._camera_error:
            self.stream_status.setText("Camera stopped")
            self.canvas_source.setText("HTTP MJPEG / 历史画面")
            self.camera_status_changed.emit("CAM 已停止", "muted")

    @Slot()
    def _refresh_camera(self) -> None:
        now=time.monotonic()
        if self._result_worker is not None and now-self._last_result_render>=.1:
            self._result_snapshot, reachable = self._result_worker.snapshot()
            self._render_result(reachable)
            self._last_result_render=now
        result_thread = self._result_thread
        if result_thread is not None and result_thread.isFinished() and result_thread.wait(4000):
            result_thread.deleteLater()
            self._result_thread, self._result_worker = None, None
        debug_thread = self._debug_thread
        debug_worker = self._debug_worker
        debug_changed=False
        if debug_worker is not None and debug_thread is not None and not debug_thread.isFinished():
            snapshot = debug_worker.take_latest()
            if snapshot is not None:
                image, received_at, self._debug_message = snapshot
                if image is not None:
                    self._debug_sheet, self._debug_received_at = image, received_at
                    debug_changed=True
                    self._debug_frames+=1
                    if self.vision_views.currentRow()>0:self._record_image_rate(self._debug_frames,now)
        if debug_thread is not None and debug_thread.isFinished() and debug_thread.wait(4000):
            debug_thread.deleteLater()
            self._debug_thread = None
            self._debug_worker = None
        if self.vision_views.currentRow() > 0 and (debug_changed or now-self._last_debug_render>=.5):
            self._show_vision_view()
            self._last_debug_render=now
        thread = self._camera_thread
        if thread is not None and thread.isFinished():
            self._camera_finished()
        self._update_http_controls()
        if not self._http_attached():
            self._camera_timer.stop()
        worker = self._camera_worker
        if worker is None:
            return
        latest = worker.take_latest()
        if latest is None:
            return
        image, decoded_at, frame_count = latest
        if self.vision_views.currentRow()==0:self._record_image_rate(frame_count,now)
        self._preview_image = image
        if self.vision_views.currentRow() == 0:
            self._show_vision_view()
        self.camera_status_changed.emit(f"CAM {frame_count:,} 帧 / HTTP", "success")
        self.canvas.setText("")
        self._rendered += 1
        self.frames_value.setText(str(frame_count))
        self.drop_value.setText(f"{frame_count - self._rendered}/0/0")
        if self.vision_views.currentRow() == 0:
            self.latency_value.setText(f"UI {max(0, (time.monotonic() - decoded_at) * 1000):.0f} ms")

    def _record_image_rate(self, count, now):
        if self._fps_origin is None:
            self._fps_origin,self._fps_origin_frames=now,count
        elif now-self._fps_origin>=.75:
            self._image_fps=(count-self._fps_origin_frames)/(now-self._fps_origin)
            self.image_fps_value.setText(f'{self._image_fps:.1f} fps')
            self._fps_origin,self._fps_origin_frames=now,count

    def accept_frame(self, frame: ProtocolFrame) -> bool:
        if self._http_attached():
            return False
        return super().accept_frame(frame)

    def flush_stream(self) -> None:
        if not self._http_attached():
            super().flush_stream()

    def stop(self) -> None:
        self._control_closing = True
        self._control_observing = False
        self._control_timer.stop()
        if self._control_worker is not None:
            self._control_worker.stop()
        if self._control_thread is not None:
            self._control_thread.wait(4000)
        self._camera_timer.stop()
        self.stop_camera(wait=True)
        self._refresh_camera()
        super().stop()


class GameWorkspace(QWidget):
    log_requested = Signal(str)

    def __init__(self) -> None:
        super().__init__()
        self.session: DemoReplaySession | None = None
        self.timer = QTimer(self)
        self.timer.setInterval(17)
        self.timer.timeout.connect(self.advance)
        self._image = QImage()

        root = QVBoxLayout(self)
        root.setContentsMargins(22, 20, 22, 20)
        root.setSpacing(12)
        self.mode_label = _eyebrow("GAME WORKSPACE / PYNQ HDMI")
        root.addWidget(self.mode_label)
        heading_row = QHBoxLayout()
        self.heading = QLabel("PYNQ Game Output")
        self.heading.setObjectName("sectionLabel")
        heading_row.addWidget(self.heading)
        heading_row.addStretch()
        self.hardware_button = self._tool_button(
            QStyle.StandardPixmap.SP_ComputerIcon,
            "Show PYNQ HDMI output",
        )
        self.hardware_button.clicked.connect(self.show_pynq_output)
        heading_row.addWidget(self.hardware_button)
        self.status_label = QLabel("HDMI OUT")
        self.status_label.setObjectName("eyebrowLabel")
        heading_row.addWidget(self.status_label)
        root.addLayout(heading_row)

        body = QHBoxLayout()
        body.setSpacing(12)
        viewport_panel = QFrame()
        viewport_panel.setObjectName("viewportPanel")
        viewport_layout = QVBoxLayout(viewport_panel)
        viewport_layout.setContentsMargins(12, 12, 12, 12)
        self.viewport = QLabel()
        self.viewport.setObjectName("gameViewport")
        self.viewport.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.viewport.setMinimumSize(640, 360)
        self.viewport.setSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Expanding)
        viewport_layout.addWidget(self.viewport, 1)

        self.controls_widget = QWidget()
        controls = QHBoxLayout(self.controls_widget)
        controls.setContentsMargins(0, 0, 0, 0)
        self.reset_button = self._tool_button(QStyle.StandardPixmap.SP_MediaStop, "Reset replay")
        self.reset_button.clicked.connect(self.reset)
        self.play_button = self._tool_button(QStyle.StandardPixmap.SP_MediaPlay, "Play replay")
        self.play_button.setCheckable(True)
        self.play_button.clicked.connect(self.toggle_playback)
        self.step_button = self._tool_button(QStyle.StandardPixmap.SP_MediaSkipForward, "Advance one tick")
        self.step_button.clicked.connect(self.step_once)
        controls.addWidget(self.reset_button)
        controls.addWidget(self.play_button)
        controls.addWidget(self.step_button)
        self.progress = QProgressBar()
        self.progress.setRange(0, 1)
        self.progress.setTextVisible(False)
        controls.addWidget(self.progress, 1)
        self.position_label = QLabel("PYNQ / HDMI")
        self.position_label.setObjectName("mutedLabel")
        controls.addWidget(self.position_label)
        viewport_layout.addWidget(self.controls_widget)
        body.addWidget(viewport_panel, 4)

        telemetry = QFrame()
        telemetry.setObjectName("inspectorPanel")
        telemetry.setFixedWidth(280)
        telemetry_layout = QVBoxLayout(telemetry)
        telemetry_layout.setContentsMargins(16, 16, 16, 16)
        telemetry_layout.setSpacing(14)
        telemetry_layout.addWidget(_eyebrow("GAME LIBRARY"))
        self.game_list = QListWidget()
        self.game_list.setObjectName("gameLibrary")
        self.game_list.setFixedHeight(62)
        c1_replay = QListWidgetItem("C1 Demo Replay  /  PC PREVIEW")
        c1_replay.setData(Qt.ItemDataRole.UserRole, "c1_demo")
        self.game_list.addItem(c1_replay)
        self.game_list.itemSelectionChanged.connect(self._select_game)
        telemetry_layout.addWidget(self.game_list)
        telemetry_layout.addWidget(_eyebrow("FRAME TELEMETRY"))
        self.score_value = _value_label("--")
        self.health_value = _value_label("--")
        self.command_value = _value_label("--")
        self.cycle_value = _value_label("--")
        self.crc_value = _value_label("--------")
        metrics = (
            ("Score", self.score_value),
            ("Health", self.health_value),
            ("Commands", self.command_value),
            ("Predicted cycles", self.cycle_value),
            ("Frame CRC32", self.crc_value),
        )
        for name, value in metrics:
            telemetry_layout.addWidget(_named_value(name, value))
        telemetry_layout.addStretch()
        boundary = QLabel("REFERENCE RENDERER\n320 x 180 RGB")
        boundary.setObjectName("mutedLabel")
        telemetry_layout.addWidget(boundary)
        body.addWidget(telemetry)
        root.addLayout(body, 1)
        self.show_pynq_output()

    def _tool_button(self, icon: QStyle.StandardPixmap, tooltip: str) -> QToolButton:
        button = QToolButton()
        button.setIcon(self.style().standardIcon(icon))
        button.setToolTip(tooltip)
        button.setFixedSize(38, 34)
        return button

    def toggle_playback(self, checked: bool) -> None:
        if self.session is None:
            self.play_button.setChecked(False)
            return
        if checked:
            if self.session.finished:
                self.reset()
            self.timer.start()
            self.play_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaPause))
            self.play_button.setToolTip("Pause replay")
            self.log_requested.emit("Replay playback started")
        else:
            self.timer.stop()
            self.play_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaPlay))
            self.play_button.setToolTip("Play replay")
            self.log_requested.emit("Replay playback paused")

    def step_once(self) -> None:
        if self.session is None:
            return
        if self.play_button.isChecked():
            self.play_button.setChecked(False)
            self.toggle_playback(False)
        self.advance()

    def reset(self) -> None:
        if self.session is None:
            return
        self.timer.stop()
        self.play_button.setChecked(False)
        self.play_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaPlay))
        self.session.reset()
        self.status_label.setText("READY")
        self.advance()
        self.log_requested.emit("Replay reset to the first frame")

    def advance(self) -> None:
        if self.session is None:
            return
        frame = self.session.step()
        if frame is None:
            self.timer.stop()
            self.play_button.setChecked(False)
            self.play_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaPlay))
            return
        self._show_frame(frame)
        if self.session.finished:
            self.timer.stop()
            self.play_button.setChecked(False)
            self.play_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaPlay))
            self.log_requested.emit(
                f"Replay complete: {frame.status.value}, score {frame.score}"
            )

    def show_pynq_output(self) -> None:
        was_previewing = self.session is not None
        self.timer.stop()
        self.play_button.setChecked(False)
        self.play_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_MediaPlay))
        self.session = None
        self._image = QImage()
        self.viewport.clear()
        self.viewport.setText(
            "PYNQ-Z2 GAME OUTPUT\n"
            "HDMI 1280 x 720 @ 60 Hz\n"
            "C4M7 / BUILD 0xC0040700"
        )
        self.mode_label.setText("GAME WORKSPACE / PYNQ HDMI")
        self.heading.setText("PYNQ Game Output")
        self.status_label.setText("HDMI OUT")
        self.controls_widget.hide()
        self.progress.setRange(0, 1)
        self.progress.setValue(0)
        self.position_label.setText("PYNQ / HDMI")
        self.score_value.setText("--")
        self.health_value.setText("--")
        self.command_value.setText("PL")
        self.cycle_value.setText("100 MHz")
        self.crc_value.setText("HDMI")
        self.game_list.blockSignals(True)
        self.game_list.clearSelection()
        self.game_list.setCurrentRow(-1)
        self.game_list.blockSignals(False)
        if was_previewing:
            self.log_requested.emit("Switched to PYNQ HDMI output")

    def _select_game(self) -> None:
        item = self.game_list.currentItem()
        if item is None or item.data(Qt.ItemDataRole.UserRole) != "c1_demo":
            return
        self.timer.stop()
        self.play_button.setChecked(False)
        self.session = DemoReplaySession()
        self._image = QImage()
        self.viewport.clear()
        self.mode_label.setText("GAME WORKSPACE / PC PREVIEW")
        self.heading.setText("C1 Demo Replay")
        self.status_label.setText("PC PREVIEW")
        self.controls_widget.show()
        self.progress.setRange(0, self.session.total)
        self.position_label.setText(f"000 / {self.session.total:03d}")
        self.advance()
        self.log_requested.emit("PC Preview opened for C1 Demo Replay")

    def _show_frame(self, frame: ReplayFrame) -> None:
        self._image = rgb_to_qimage(frame.rgb)
        self._refresh_pixmap()
        self.progress.setValue(frame.position)
        self.position_label.setText(f"{frame.position:03d} / {frame.total:03d}")
        self.status_label.setText(frame.status.value)
        self.score_value.setText(str(frame.score))
        self.health_value.setText(str(frame.health))
        self.command_value.setText(str(frame.command_count))
        self.cycle_value.setText(f"{frame.predicted_cycles:,}")
        self.crc_value.setText(f"{frame.frame_crc32:08X}")

    def _refresh_pixmap(self) -> None:
        if self._image.isNull():
            return
        available = self.viewport.size()
        pixmap = QPixmap.fromImage(self._image).scaled(
            available,
            Qt.AspectRatioMode.KeepAspectRatio,
            Qt.TransformationMode.FastTransformation,
        )
        self.viewport.setPixmap(pixmap)

    def resizeEvent(self, event) -> None:  # type: ignore[no-untyped-def]
        super().resizeEvent(event)
        self._refresh_pixmap()


class CapabilityWorkspace(QWidget):
    def __init__(self) -> None:
        super().__init__()
        root = QVBoxLayout(self)
        root.setContentsMargins(12, 10, 12, 10)
        root.setSpacing(8)
        heading = QLabel("PL GPU 能力清单")
        heading.setObjectName("sectionLabel")
        root.addWidget(heading)
        profile_source = QLabel("静态冻结配置 / C4M7 / BUILD_ID 0xC0040700")
        profile_source.setObjectName("mutedLabel")
        root.addWidget(profile_source)

        stats = QGridLayout()
        profile = C4M7_CAPABILITIES
        values = (
            ("Logical", f"{profile.logical_size[0]} x {profile.logical_size[1]}"),
            ("HDMI", f"{profile.output_size[0]} x {profile.output_size[1]}"),
            ("Commands", str(profile.command_capacity)),
            ("Sprites", str(profile.max_sprites)),
            ("Asset slots", str(profile.asset_bundle_slots)),
            ("Tilemap slots", str(profile.tilemap_slots)),
        )
        for index, (name, value) in enumerate(values):
            stats.addWidget(_metric(name, value), index // 3, index % 3)
        root.addLayout(stats)

        table = QTableWidget(len(CAPABILITY_MATRIX), 3)
        table.setHorizontalHeaderLabels(("Capability", "Status", "Boundary"))
        table.setAlternatingRowColors(True)
        table.setEditTriggers(QTableWidget.EditTrigger.NoEditTriggers)
        table.setSelectionMode(QTableWidget.SelectionMode.NoSelection)
        table.verticalHeader().setVisible(False)
        table.horizontalHeader().setSectionResizeMode(0, QHeaderView.ResizeMode.ResizeToContents)
        table.horizontalHeader().setSectionResizeMode(1, QHeaderView.ResizeMode.ResizeToContents)
        table.horizontalHeader().setSectionResizeMode(2, QHeaderView.ResizeMode.Stretch)
        status_colors = {
            CapabilityStatus.VERIFIED: QColor("#9edb9a"),
            CapabilityStatus.PS_SOFTWARE: QColor(ACCENT),
            CapabilityStatus.FUTURE_RTL: QColor("#efc078"),
            CapabilityStatus.UNSUPPORTED: QColor("#ff9687"),
        }
        for row, capability in enumerate(CAPABILITY_MATRIX):
            cells = (
                QTableWidgetItem(capability.label),
                QTableWidgetItem(capability.status.value.upper()),
                QTableWidgetItem(capability.detail),
            )
            cells[1].setForeground(status_colors[capability.status])
            for column, cell in enumerate(cells):
                cell.setToolTip(cell.text())
                table.setItem(row, column, cell)
        root.addWidget(table, 1)


def _eyebrow(text: str) -> QLabel:
    label = QLabel(text)
    label.setObjectName("eyebrowLabel")
    return label


def _value_label(text: str) -> QLabel:
    label = QLabel(text)
    label.setObjectName("metricValue")
    return label


def _named_value(name: str, value: QLabel) -> QWidget:
    container = QWidget()
    layout = QHBoxLayout(container)
    layout.setContentsMargins(0, 0, 0, 0)
    label = QLabel(name)
    label.setObjectName("metricName")
    layout.addWidget(label)
    layout.addStretch()
    layout.addWidget(value)
    return container


def _metric(name: str, value: str) -> QWidget:
    container = QFrame()
    container.setObjectName("workspacePanel")
    layout = QVBoxLayout(container)
    layout.setContentsMargins(12, 10, 12, 10)
    layout.setSpacing(3)
    name_label = QLabel(name)
    name_label.setObjectName("metricName")
    layout.addWidget(name_label)
    layout.addWidget(_value_label(value))
    return container
