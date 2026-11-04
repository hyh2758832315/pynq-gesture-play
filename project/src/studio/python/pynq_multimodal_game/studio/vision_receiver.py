from __future__ import annotations

from dataclasses import dataclass
import math
from typing import Any


def vision_result_details(packet: dict) -> tuple[tuple[str, str], ...]:
    """Bounded display-only facts; optional bad diagnostics never veto control."""
    control = packet.get("control", {})

    def text(value):
        if isinstance(value, str):
            return " ".join(value.split())[:96] or "--"
        if type(value) is int:
            return str(value)[:24]
        if type(value) is float and math.isfinite(value):
            return f"{value:.1f}"
        if type(value) is bool:
            return "是" if value else "否"
        if isinstance(value, (tuple, list)) and len(value) == 2:
            return ", ".join(text(v) if not isinstance(v, (tuple, list, dict)) else "--" for v in value)
        return "--"

    return tuple((name, text(value)) for name, value in (
        ("原始 / 稳定", f"{text(packet.get('raw', packet.get('code')))} / {text(packet.get('stable'))}"),
        ("三态手势", packet.get("rps")),
        ("手部状态", packet.get("hand_state")),
        ("中心坐标", packet.get("centroid_640x360", packet.get("centroid"))),
        ("归一化位置", control.get("smooth_uv")),
        ("手指数", packet.get("fingers")),
        ("轮廓面积", packet.get("area")),
        ("缺陷比例 %", packet.get("ratio")),
        ("接触边界", packet.get("touches_frame_or_roi", packet.get("touches_roi"))),
        ("方向原因", control.get("reason")),
        ("动作序号", control.get("action_event_seq")),
    ))


@dataclass(frozen=True)
class VisionResultSnapshot:
    status: str = "WAITING"
    message: str = "Waiting for a vision result"
    run_id: str | None = None
    frame_id: int = 0
    action_event_seq: int | None = None
    direction: str = "IDLE"
    action_event: bool = False
    server_age_ms: float | None = None
    local_age_ms: float | None = None
    details: tuple[tuple[str, str], ...] = ()

    @property
    def valid(self) -> bool:
        return self.status == "ACTIVE"


class VisionResultReceiver:
    def __init__(self, timeout_s: float = 1.2) -> None:
        if not math.isfinite(timeout_s) or timeout_s <= 0:
            raise ValueError("Vision timeout must be finite and positive")
        self.timeout_s = timeout_s
        self._run_id: str | None = None
        self._frame_id = 0
        self._seq: int | None = None
        self._direction = "IDLE"
        self._fresh_at: float | None = None
        self._expires_at: float | None = None
        self._received_at: float | None = None
        self._server_age_ms: float | None = None
        self._status = "WAITING"
        self._message = "Waiting for a vision result"
        self._details: tuple[tuple[str, str], ...] = ()

    def _snapshot(self, now: float, *, event: bool = False) -> VisionResultSnapshot:
        return VisionResultSnapshot(
            self._status, self._message, self._run_id, self._frame_id, self._seq,
            self._direction, event, self._server_age_ms,
            max(0.0, (now - self._fresh_at) * 1000) if self._fresh_at is not None else None,
            self._details,
        )

    def release(self, now: float, message: str, *, status: str = "ERROR") -> VisionResultSnapshot:
        self._status, self._message = status, message
        self._direction, self._seq = "IDLE", None
        return self._snapshot(now)

    def expire(self, now: float) -> VisionResultSnapshot:
        if self._status == "ACTIVE":
            local_stale = self._fresh_at is None or now - self._fresh_at > self.timeout_s
            if self._expires_at is not None and now > self._expires_at:
                local_stale = True
            server_stale = (
                self._server_age_ms is not None and self._received_at is not None
                and self._server_age_ms + (now - self._received_at) * 1000 > self.timeout_s * 1000
            )
            if local_stale or server_stale:
                return self.release(now, "No fresh vision frame", status="STALE")
        return self._snapshot(now)

    def consume(self, packet: Any, now: float) -> VisionResultSnapshot:
        if packet == {} or packet == {"server_age_ms": None}:
            return self.release(now, "Waiting for a vision result", status="WAITING")
        try:
            if not isinstance(packet, dict):
                raise ValueError("Expected a vision result object")
            control = packet["control"]
            run_id, age = packet["run_id"], packet["server_age_ms"]
            frame_id, seq = control["frame_id"], control["action_event_seq"]
            direction, valid = control["direction"], control["valid"]
            if (
                not isinstance(run_id, str) or not run_id or len(run_id) > 256
                or control["schema"] != "gesture-control-v1"
                or type(frame_id) is not int or frame_id < 1
                or type(seq) is not int or seq < 0
                or type(age) not in (int, float) or not math.isfinite(age) or age < 0
                or type(valid) is not bool
                or direction not in ("IDLE", "LEFT", "RIGHT", "UP", "DOWN")
            ):
                raise ValueError("Invalid vision result fields")
            if run_id != self._run_id:
                self._run_id, self._frame_id, self._seq = run_id, 0, None
                self._fresh_at = None
                self._expires_at = None
                self._status, self._direction = "WAITING", "IDLE"
                self._details = ()
            if frame_id > self._frame_id or (frame_id == self._frame_id and not valid):
                self._details = vision_result_details(packet)
            self._server_age_ms, self._received_at = float(age), now
            if age > self.timeout_s * 1000:
                return self.release(now, "Server result is stale", status="STALE")
            if not valid:
                self._frame_id = max(self._frame_id, frame_id)
                return self.release(now, "Vision reports no valid hand", status="INVALID")
            self.expire(now)
            if frame_id <= self._frame_id:
                return self._snapshot(now)
            if self._seq is not None and seq < self._seq:
                self._frame_id = frame_id
                return self.release(now, "Vision event sequence moved backwards", status="INVALID")
            event = self._seq is not None and seq > self._seq
            self._frame_id, self._fresh_at, self._seq = frame_id, now, seq
            self._expires_at = now + self.timeout_s - age / 1000
            self._status, self._message, self._direction = "ACTIVE", "Fresh vision result", direction
            return self._snapshot(now, event=event)
        except (KeyError, TypeError, ValueError, OverflowError) as error:
            return self.release(now, str(error), status="INVALID")
