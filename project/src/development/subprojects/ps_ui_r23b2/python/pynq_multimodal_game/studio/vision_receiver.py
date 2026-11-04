from __future__ import annotations

from collections import deque
from dataclasses import dataclass
import math
from typing import Any


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
        self._retired_runs: deque[str] = deque(maxlen=16)
        self.ignored_packet = False

    def _snapshot(self, now: float, *, event: bool = False) -> VisionResultSnapshot:
        return VisionResultSnapshot(
            self._status, self._message, self._run_id, self._frame_id, self._seq,
            self._direction, event, self._server_age_ms,
            max(0.0, (now - self._fresh_at) * 1000) if self._fresh_at is not None else None,
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
        self.ignored_packet = False
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
            # Compare identity before touching freshness or invalidation. A late
            # response belongs to its own observation, not the accepted frame.
            if run_id in self._retired_runs or (run_id == self._run_id and frame_id < self._frame_id):
                self.ignored_packet = True
                return self.expire(now)
            if run_id != self._run_id:
                if self._run_id is not None:
                    self._retired_runs.append(self._run_id)
                self._run_id, self._frame_id, self._seq = run_id, 0, None
                self._fresh_at = None
                self._expires_at = None
                self._status, self._direction = "WAITING", "IDLE"
            if frame_id == self._frame_id and valid:
                self.ignored_packet = True
                # Replays cannot revive a released frame or rejuvenate its
                # source timestamp. Conservative ages may only shorten its lease.
                if self._status == "ACTIVE" and self._fresh_at is not None:
                    origin = now - age / 1000.
                    self._server_age_ms = max(self._server_age_ms,
                        (self._fresh_at - origin) * 1000.)
                    self._received_at = self._fresh_at
                    self._expires_at = min(self._expires_at, origin + self.timeout_s)
                return self.expire(now)
            self.expire(now)
            self._server_age_ms, self._received_at = float(age), now
            self._frame_id, self._fresh_at = frame_id, now
            if age > self.timeout_s * 1000:
                return self.release(now, "Server result is stale", status="STALE")
            if not valid:
                return self.release(now, "Vision reports no valid hand", status="INVALID")
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
