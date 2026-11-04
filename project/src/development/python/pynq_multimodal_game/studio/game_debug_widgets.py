from __future__ import annotations

from .theme import ACCENT

from dataclasses import asdict
import json
from pathlib import Path
import struct
from typing import Any, Mapping

from PySide6.QtCore import QPointF, Qt, Signal
from PySide6.QtGui import QColor, QImage, QMouseEvent, QPainter, QPen, QPixmap
from PySide6.QtWidgets import (
    QAbstractItemView,
    QComboBox,
    QHBoxLayout,
    QHeaderView,
    QLabel,
    QLineEdit,
    QPushButton,
    QStyle,
    QToolButton,
    QTabWidget,
    QTableWidget,
    QTableWidgetItem,
    QVBoxLayout,
    QWidget,
)

from ..game_runner import GameFrame
from ..game_testing import AuditEvent
from ..gpu_abi import COMMAND_WORDS, GpuCommand, PacketHeader
from ..scene import LOGICAL_HEIGHT, LOGICAL_WIDTH


class InteractiveGameViewport(QLabel):
    logical_position_changed = Signal(int, int)

    def __init__(self) -> None:
        super().__init__()
        self.setObjectName("gameViewport")
        self.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.setMinimumSize(320, 180)
        self.setMouseTracking(True)
        self._image = QImage()
        self._logical_position: tuple[int, int] | None = None

    @property
    def logical_position(self) -> tuple[int, int] | None:
        return self._logical_position

    def set_frame(self, image: QImage) -> None:
        self._image = image
        self._refresh_pixmap()

    def clear_frame(self, text: str = "") -> None:
        self._image = QImage()
        self._logical_position = None
        self.clear()
        self.setText(text)

    def resizeEvent(self, event) -> None:  # type: ignore[no-untyped-def]
        super().resizeEvent(event)
        self._refresh_pixmap()

    def mousePressEvent(self, event: QMouseEvent) -> None:
        if event.button() == Qt.MouseButton.LeftButton:
            self._update_pointer(event.position())
        super().mousePressEvent(event)

    def mouseMoveEvent(self, event: QMouseEvent) -> None:
        if event.buttons() & Qt.MouseButton.LeftButton:
            self._update_pointer(event.position())
        super().mouseMoveEvent(event)

    def paintEvent(self, event) -> None:  # type: ignore[no-untyped-def]
        super().paintEvent(event)
        if self._logical_position is None:
            return
        point = self._logical_to_widget(*self._logical_position)
        painter = QPainter(self)
        painter.setRenderHint(QPainter.RenderHint.Antialiasing)
        painter.setPen(QPen(QColor(ACCENT), 1))
        painter.drawLine(int(point.x()) - 9, int(point.y()), int(point.x()) + 9, int(point.y()))
        painter.drawLine(int(point.x()), int(point.y()) - 9, int(point.x()), int(point.y()) + 9)

    def _update_pointer(self, position: QPointF) -> None:
        logical = self._widget_to_logical(position)
        if logical is None:
            return
        self._logical_position = logical
        self.logical_position_changed.emit(*logical)
        self.update()

    def _content_geometry(self) -> tuple[float, float, float]:
        scale = min(self.width() / LOGICAL_WIDTH, self.height() / LOGICAL_HEIGHT)
        width = LOGICAL_WIDTH * scale
        height = LOGICAL_HEIGHT * scale
        return (self.width() - width) / 2.0, (self.height() - height) / 2.0, scale

    def _widget_to_logical(self, position: QPointF) -> tuple[int, int] | None:
        offset_x, offset_y, scale = self._content_geometry()
        x = (position.x() - offset_x) / scale
        y = (position.y() - offset_y) / scale
        if not 0 <= x < LOGICAL_WIDTH or not 0 <= y < LOGICAL_HEIGHT:
            return None
        return min(LOGICAL_WIDTH - 1, int(x)), min(LOGICAL_HEIGHT - 1, int(y))

    def _logical_to_widget(self, x: int, y: int) -> QPointF:
        offset_x, offset_y, scale = self._content_geometry()
        return QPointF(offset_x + (x + 0.5) * scale, offset_y + (y + 0.5) * scale)

    def _refresh_pixmap(self) -> None:
        if self._image.isNull():
            return
        self.setPixmap(
            QPixmap.fromImage(self._image).scaled(
                self.size(),
                Qt.AspectRatioMode.KeepAspectRatio,
                Qt.TransformationMode.FastTransformation,
            )
        )


class AuditConsole(QWidget):
    def __init__(self) -> None:
        super().__init__()
        self._events: list[AuditEvent] = []
        layout = QVBoxLayout(self)
        layout.setContentsMargins(0, 0, 0, 0)
        layout.setSpacing(6)
        filters = QHBoxLayout()
        title = QLabel("执行记录")
        title.setObjectName("mutedLabel")
        layout.addWidget(title)
        self.category_filter = QComboBox()
        self.category_filter.addItem("全部类别", "")
        self.target_filter = QComboBox()
        self.target_filter.addItem("全部目标", "")
        self.search = QLineEdit()
        self.search.setPlaceholderText("筛选动作、结果或参数")
        self.clear_button = QToolButton()
        self.clear_button.setIcon(self.style().standardIcon(QStyle.StandardPixmap.SP_DialogResetButton))
        self.clear_button.setToolTip("清空视图")
        self.clear_button.setFixedSize(32, 32)
        filters.addWidget(self.category_filter)
        filters.addWidget(self.target_filter)
        filters.addWidget(self.search, 1)
        filters.addWidget(self.clear_button)
        layout.addLayout(filters)

        self.table = QTableWidget(0, 8)
        self.table.setObjectName("auditTable")
        self.table.setHorizontalHeaderLabels(
            ("时间", "Tick", "目标", "类别", "动作", "结果", "参数", "Run ID")
        )
        self.table.setAlternatingRowColors(True)
        self.table.setWordWrap(False)
        self.table.verticalHeader().setDefaultSectionSize(26)
        self.table.setEditTriggers(QAbstractItemView.EditTrigger.NoEditTriggers)
        self.table.setSelectionBehavior(QAbstractItemView.SelectionBehavior.SelectRows)
        self.table.verticalHeader().hide()
        header = self.table.horizontalHeader()
        header.setSectionResizeMode(QHeaderView.ResizeMode.ResizeToContents)
        header.setSectionResizeMode(6, QHeaderView.ResizeMode.Stretch)
        header.setSectionResizeMode(7, QHeaderView.ResizeMode.Interactive)
        header.resizeSection(7, 100)
        layout.addWidget(self.table, 1)
        self.summary = QLabel("尚未运行测试")
        self.summary.setObjectName("mutedLabel")
        layout.addWidget(self.summary)
        self.category_filter.currentIndexChanged.connect(self._apply_filters)
        self.target_filter.currentIndexChanged.connect(self._apply_filters)
        self.search.textChanged.connect(self._apply_filters)
        self.clear_button.clicked.connect(self.clear_view)

    @property
    def events(self) -> tuple[AuditEvent, ...]:
        return tuple(self._events)

    def append_event(self, event: AuditEvent) -> None:
        self._events.append(event)
        self._ensure_filter_value(self.category_filter, event.category)
        self._ensure_filter_value(self.target_filter, event.target)
        self._append_row(event)
        self._apply_filters()
        self.table.scrollToBottom()

    def clear_view(self) -> None:
        self.table.setRowCount(0)

    def set_summary(self, text: str, *, passed: bool | None = None) -> None:
        self.summary.setText(text)
        if passed is True:
            self.summary.setObjectName("resultPass")
        elif passed is False:
            self.summary.setObjectName("resultFail")
        else:
            self.summary.setObjectName("mutedLabel")
        self.summary.style().unpolish(self.summary)
        self.summary.style().polish(self.summary)

    def export_jsonl(self, path: Path) -> None:
        with Path(path).open("w", encoding="utf-8", newline="\n") as stream:
            for event in self._events:
                stream.write(json.dumps(asdict(event), ensure_ascii=False, sort_keys=True) + "\n")

    def _append_row(self, event: AuditEvent) -> None:
        row = self.table.rowCount()
        self.table.insertRow(row)
        seconds = event.timestamp_ns / 1_000_000_000
        values = (
            f"{seconds:.3f}",
            "-" if event.tick is None else str(event.tick),
            event.target.upper(),
            event.category,
            event.action,
            event.result,
            json.dumps(dict(event.details), ensure_ascii=False, sort_keys=True),
            event.run_id or "-",
        )
        for column, value in enumerate(values):
            item = QTableWidgetItem(value)
            item.setToolTip(value)
            item.setData(Qt.ItemDataRole.UserRole, event)
            if column == 5 and event.result in ("failed", "error"):
                item.setForeground(QColor("#ff9687"))
            elif column == 5 and event.result in ("passed", "consumed", "ok"):
                item.setForeground(QColor("#9edb9a"))
            self.table.setItem(row, column, item)

    def _apply_filters(self) -> None:
        category = self.category_filter.currentData() or ""
        target = self.target_filter.currentData() or ""
        search = self.search.text().strip().casefold()
        for row in range(self.table.rowCount()):
            item = self.table.item(row, 0)
            if item is None:
                continue
            event = item.data(Qt.ItemDataRole.UserRole)
            text = " ".join(
                (event.action, event.result, json.dumps(dict(event.details), ensure_ascii=False))
            ).casefold()
            visible = (
                (not category or event.category == category)
                and (not target or event.target == target)
                and (not search or search in text)
            )
            self.table.setRowHidden(row, not visible)

    @staticmethod
    def _ensure_filter_value(combo: QComboBox, value: str) -> None:
        if combo.findData(value) < 0:
            combo.addItem(value, value)


class GameInspector(QTabWidget):
    def __init__(self) -> None:
        super().__init__()
        self.setObjectName("gameInspector")
        self.status_table = self._make_table(("字段", "值"))
        self.scene_table = self._make_table(("字段", "值"))
        self.command_table = self._make_table(("#", "Opcode", "Flags", "Words"))
        self.resource_table = self._make_table(("类型", "Generation", "Bytes", "CRC32"))
        self.device_table = self._make_table(("字段", "值"))
        self.addTab(self.status_table, "状态")
        self.addTab(self.scene_table, "Scene")
        self.addTab(self.command_table, "命令")
        self.addTab(self.resource_table, "资源")
        self.addTab(self.device_table, "设备")
        self.show_device({})

    def show_frame(self, frame: GameFrame) -> None:
        status = {
            "tick": frame.snapshot.tick_id,
            "status": frame.snapshot.status,
            "score": frame.snapshot.score,
            "values": frame.snapshot.values or {},
            "frame_crc32": f"{frame.frame_crc32:08X}",
            "scene_sha256": frame.scene_sha256,
            "commands": frame.command_count,
            "predicted_cycles": frame.predicted_cycles,
        }
        self._fill_pairs(self.status_table, status)
        words = struct.unpack("<16I", frame.scene_packet[:64])
        self._fill_pairs(
            self.scene_table,
            {
                "frame_id": words[2],
                "submit_seq": words[3],
                "command_count": words[4],
                "camera_x": _signed_u32(words[5]),
                "camera_y": _signed_u32(words[6]),
                "background_rgb": f"#{words[7] & 0xFFFFFF:06X}",
                "palette_generation": words[8],
                "asset_generation": words[10],
                "tilemap_generation": words[11],
            },
        )
        self._show_commands(frame)
        self._show_resources(frame)

    def show_device(self, snapshot: Mapping[str, Any]) -> None:
        self._fill_pairs(self.device_table, {
            "数据来源": "PYNQ / 最近回读" if snapshot else "PYNQ / 等待回读",
            **{key: snapshot[key] for key in (
                "runtime_mode", "state", "game_tick", "game_status", "game_score",
                "accepted_input_id", "consumed_input_id", "test_complete",
                "assertions_passed", "assertions_failed", "last_error",
            ) if key in snapshot},
            **{key: value for key, value in snapshot.items() if key not in (
                "runtime_mode", "state", "game_tick", "game_status", "game_score",
                "accepted_input_id", "consumed_input_id", "test_complete",
                "assertions_passed", "assertions_failed", "last_error",
            )},
        })

    def mark_device_historical(self) -> None:
        item = self.device_table.item(0, 1)
        if item is not None:
            text = "PYNQ / 历史快照" if self.device_table.rowCount() > 1 else "PYNQ / 等待回读"
            item.setText(text)
            item.setToolTip(text)

    def _show_commands(self, frame: GameFrame) -> None:
        self.command_table.setRowCount(0)
        payload = frame.scene_packet[64:]
        size = COMMAND_WORDS * 4
        for index in range(frame.command_count):
            words = struct.unpack("<8I", payload[index * size : (index + 1) * size])
            command = GpuCommand(words)
            self._append_values(
                self.command_table,
                (index, command.opcode.name, f"0x{command.flags:02X}", " ".join(f"{word:08X}" for word in words)),
            )

    def _show_resources(self, frame: GameFrame) -> None:
        self.resource_table.setRowCount(0)
        for name, packet in (
            ("ASSET", frame.asset_packet),
            ("PALETTE", frame.palette_packet),
            ("TILEMAP", frame.tilemap_packet),
        ):
            if packet is None:
                self._append_values(self.resource_table, (name, "unchanged", "-", "-"))
                continue
            header = PacketHeader.from_bytes(packet[:64])
            self._append_values(
                self.resource_table,
                (name, header.generation, len(packet), f"{header.payload_crc32:08X}"),
            )

    @staticmethod
    def _make_table(headers: tuple[str, ...]) -> QTableWidget:
        table = QTableWidget(0, len(headers))
        table.setHorizontalHeaderLabels(headers)
        table.setAlternatingRowColors(True)
        table.setWordWrap(False)
        table.verticalHeader().hide()
        table.verticalHeader().setDefaultSectionSize(26)
        table.setEditTriggers(QAbstractItemView.EditTrigger.NoEditTriggers)
        table.horizontalHeader().setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
        return table

    @staticmethod
    def _append_values(table: QTableWidget, values: tuple[object, ...]) -> None:
        row = table.rowCount()
        table.insertRow(row)
        for column, value in enumerate(values):
            text = "--" if value is None else str(value)
            item = QTableWidgetItem(text)
            item.setToolTip(text)
            table.setItem(row, column, item)

    def _fill_pairs(self, table: QTableWidget, values: Mapping[str, Any]) -> None:
        table.setRowCount(0)
        for key, value in values.items():
            rendered = json.dumps(value, ensure_ascii=False, sort_keys=True) if isinstance(value, (dict, list)) else str(value)
            self._append_values(table, (key, rendered))


def _signed_u32(value: int) -> int:
    return value if value < 0x80000000 else value - 0x100000000