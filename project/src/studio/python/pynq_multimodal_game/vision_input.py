from __future__ import annotations

from collections.abc import Callable
from dataclasses import dataclass, replace
import math
import threading
import time
from typing import Any

from .controls import ControlSource, ControlState, Direction
from .game_sdk import GameInput, GestureState, HandGesture
from .studio.vision_receiver import VisionResultReceiver, VisionResultSnapshot


@dataclass(frozen=True)
class VisionInputReceipt:
    result: VisionResultSnapshot
    config_epoch: str
    consumed_action_seq: int | None
    consumed_tick: int | None


class VisionInputProvider:
    def __init__(self, *, timeout_s: float = 1.2, fist_enabled: bool = False,
                 clock: Callable[[], float] = time.monotonic) -> None:
        if type(fist_enabled) is not bool:
            raise ValueError("fist_enabled must be a bool")
        self._receiver = VisionResultReceiver(timeout_s)
        self._clock = clock
        self._fist_enabled = fist_enabled
        self._lock = threading.RLock()
        self._epoch = "default"
        self._suspended = False
        self._pending: tuple[int, float] | None = None
        self._fist_sequence = 0
        self._consumed_seq: int | None = None
        self._consumed_tick: int | None = None
        self._menu_pointer: tuple[float, float] | None = None
        self._menu_armed = False
        self._menu_pending = False
        self._menu_sequence = 0

    def _now(self) -> float:
        now = self._clock()
        if type(now) not in (int, float) or not math.isfinite(now) or now < 0:
            raise ValueError("vision clock must be finite and non-negative")
        return float(now)

    @property
    def capabilities(self) -> dict[str, Any]:
        return {"schema": "local-game-vision-v1", "mode": "legacy_horizontal", "games": []}

    def publish(self, packet: Any, *, config_epoch: str = "default") -> VisionInputReceipt:
        if not isinstance(config_epoch, str) or not config_epoch or len(config_epoch) > 256:
            raise ValueError("invalid vision configuration epoch")
        with self._lock:
            now = self._now()
            if config_epoch != self._epoch:
                self._receiver = VisionResultReceiver(self._receiver.timeout_s)
                self._epoch = config_epoch
                self._pending = None
                self._clear_menu_input()
            previous = self._receiver.expire(now)
            if not previous.valid:
                self._clear_menu_input()
            previous_run = previous.run_id
            result = self._receiver.consume(packet, now)
            if not result.valid or result.run_id != previous_run:
                self._pending = None
                self._clear_menu_input()
            control = packet.get("control", {}) if isinstance(packet, dict) else {}
            action = control.get("action_event", False) if isinstance(control, dict) else False
            if type(action) is not bool:
                result = self._receiver.release(now, "Invalid vision action flag", status="INVALID")
                self._pending = None
            elif (self._fist_enabled and result.valid and result.action_event and action
                  and control.get("action_kind") == "HEURISTIC_OPEN_TO_FIST"):
                if result.action_event_seq is not None and result.server_age_ms is not None:
                    self._pending = (result.action_event_seq,
                                     now + self._receiver.timeout_s - result.server_age_ms / 1000)
            if self._suspended:
                result = self._receiver.release(now, "Vision input paused", status="PAUSED")
                self._pending = None
            if not result.valid:
                self._clear_menu_input()
            elif result.run_id != previous.run_id or result.frame_id > previous.frame_id:
                point = control.get("smooth_uv")
                if point is None:
                    point = (control.get("u"), control.get("v"))
                if (not isinstance(point, (list, tuple)) or len(point) != 2
                        or any(type(value) not in (int, float) or not math.isfinite(value)
                               or not -1 <= value <= 1 for value in point)):
                    self._clear_menu_input()
                else:
                    self._menu_pointer = (float(point[0]), float(point[1]))
                    stable = packet.get("stable", control.get("stable_gesture"))
                    label = packet.get("rps", control.get("rps_gesture"))
                    if stable == "5" and label == "PAPER":
                        self._menu_armed = True
                    elif stable == "0" and label == "ROCK" and self._menu_armed:
                        self._menu_sequence += 1
                        self._menu_pending = True
                        self._menu_armed = False
            return VisionInputReceipt(result, self._epoch, self._consumed_seq, self._consumed_tick)

    def _clear_menu_input(self) -> None:
        self._menu_pointer = None
        self._menu_armed = False
        self._menu_pending = False

    def sample_menu_control(self, *, tick_id: int) -> ControlState:
        with self._lock:
            now = self._now()
            result = self._receiver.expire(now)
            valid = result.valid and not self._suspended and self._menu_pointer is not None
            if not valid:
                self._clear_menu_input()
            point = self._menu_pointer if valid else None
            event = valid and self._menu_pending
            self._menu_pending = False
            self._pending = None
            return ControlState(
                tick_id=tick_id, timestamp_ns=int(now * 1e9),
                gesture_source=ControlSource.REAL, gesture_seq=self._menu_sequence,
                hand_valid=valid, hand_x=point[0] if point else 0.0, hand_y=point[1] if point else 0.0,
                direction=Direction[result.direction] if valid else Direction.IDLE,
                fist_score=1.0 if event else 0.0, fist_event=event,
                voice_source=ControlSource.REAL, voice_seq=0, audio_valid=False,
                low_voice_active=False, high_voice_event=False, low_confidence=0.0, high_confidence=0.0,
            )

    def peek_menu_control(self, *, tick_id: int = 0) -> ControlState:
        """Read the newest fresh hand position without consuming any gesture action."""
        with self._lock:
            now = self._now()
            result = self._receiver.expire(now)
            valid = result.valid and not self._suspended and self._menu_pointer is not None
            point = self._menu_pointer if valid else None
            return ControlState(
                tick_id=tick_id, timestamp_ns=int(now * 1e9),
                gesture_source=ControlSource.REAL, gesture_seq=self._menu_sequence,
                hand_valid=valid, hand_x=point[0] if point else 0.0,
                hand_y=point[1] if point else 0.0,
                direction=Direction[result.direction] if valid else Direction.IDLE,
                fist_score=0.0, fist_event=False,
                voice_source=ControlSource.REAL, voice_seq=0, audio_valid=False,
                low_voice_active=False, high_voice_event=False,
                low_confidence=0.0, high_confidence=0.0,
            )

    @property
    def receipt(self) -> VisionInputReceipt:
        with self._lock:
            result = self._receiver.expire(self._now())
            return VisionInputReceipt(result, self._epoch, self._consumed_seq, self._consumed_tick)

    def sample(self, *, tick_id: int, timestamp_ns: int | None = None) -> GameInput:
        return self.sample_with_receipt(tick_id=tick_id, timestamp_ns=timestamp_ns)[0]

    def sample_with_receipt(self, *, tick_id: int, timestamp_ns: int | None = None) -> tuple[GameInput, dict[str, Any]]:
        with self._lock:
            now = self._now()
            result = self._receiver.expire(now)
            valid = result.valid and not self._suspended
            event = False
            if self._pending is not None:
                sequence, expires_at = self._pending
                if valid and now <= expires_at:
                    event = True
                    self._fist_sequence += 1
                    self._consumed_seq, self._consumed_tick = sequence, tick_id
                self._pending = None
            horizontal = {"LEFT": -1.0, "RIGHT": 1.0}.get(result.direction, 0.0) if valid else 0.0
            game_input = GameInput(tick_id=tick_id, timestamp_ns=int(now * 1e9) if timestamp_ns is None else timestamp_ns,
                                   hand_valid=valid, hand_x=horizontal, hand_y=0.0,
                                   fist_sequence=self._fist_sequence, fist_event=event)
            receipt = {"run_id": result.run_id, "config_epoch": self._epoch,
                       "source_frame_id": result.frame_id, "source_action_seq": result.action_event_seq,
                       "source_status": result.status, "source_direction": result.direction,
                       "server_age_ms": result.server_age_ms, "local_age_ms": result.local_age_ms,
                       "sample_tick": tick_id, "sample_timestamp_ns": game_input.timestamp_ns,
                       "hand_valid": valid, "hand_x": horizontal, "action_consumed": event,
                       "consumed_action_seq": self._consumed_seq if event else None}
            return game_input, receipt

    def suspend(self) -> None:
        with self._lock:
            self._suspended = True
            self._pending = None
            self._clear_menu_input()
            self._receiver.release(self._now(), "Vision input paused", status="PAUSED")

    def resume(self) -> None:
        with self._lock:
            self._suspended = False
            self._pending = None
            self._clear_menu_input()
            self._receiver.release(self._now(), "Waiting for a new vision frame", status="WAITING")

    def release(self, message: str = "Vision producer stopped") -> None:
        with self._lock:
            self._pending = None
            self._clear_menu_input()
            self._receiver.release(self._now(), message)


class GameVisionInputProvider(VisionInputProvider):
    _GESTURES = {"0": ("ROCK", HandGesture.FIST),
                 "2": ("SCISSORS", HandGesture.SCISSORS),
                 "5": ("PAPER", HandGesture.PAPER)}

    @property
    def capabilities(self) -> dict[str, Any]:
        return {"schema": "local-game-vision-v1", "mode": "games",
                "games": ["game1", "game2", "game3"]}

    def __init__(self, **kwargs: Any) -> None:
        kwargs.setdefault("fist_enabled", True)
        super().__init__(**kwargs)
        self._classification: tuple[str | None, str, int | None, HandGesture | None, bool] | None = None
        self._gestures = GestureState()

    def peek_hand_classification(self) -> dict[str, Any] | None:
        """Copy the latest classified frame without sampling game/menu events.

        The source timestamp ages with the cached frame, so repeated peeks
        cannot make an old hand observation fresh again.
        """
        with self._lock:
            now = self._now()
            result = self._receiver.expire(now)
            if (not result.run_id or result.frame_id < 1
                    or result.server_age_ms is None or result.local_age_ms is None):
                return None
            age = (result.server_age_ms + result.local_age_ms) / 1000.0
            if not math.isfinite(age) or age < 0 or age > now:
                return None
            identity = (result.run_id, self._epoch, result.frame_id)
            gesture = (self._classification[3] if self._classification is not None
                       and self._classification[:3] == identity else None)
            return {"run_id": result.run_id, "config_epoch": self._epoch,
                    "frame_id": result.frame_id, "observed_at": now,
                    "source_at": now - age,
                    "valid": result.valid and not self._suspended,
                    "gesture": None if gesture is None else gesture.value}

    def publish(self, packet: Any, *, config_epoch: str = "default") -> VisionInputReceipt:
        with self._lock:
            previous = self.receipt
            accepted = super().publish(packet, config_epoch=config_epoch)
            result = accepted.result
            if not result.valid:
                self._classification = None
            elif (config_epoch != previous.config_epoch or result.run_id != previous.result.run_id
                  or result.frame_id > previous.result.frame_id):
                control = packet["control"]
                stable = packet.get("stable", control.get("stable_gesture"))
                label = packet.get("rps", control.get("rps_gesture"))
                choice = self._GESTURES.get(stable) if isinstance(stable, str) else None
                gesture = choice[1] if choice and label == choice[0] else None
                if packet.get("frame", result.frame_id) != result.frame_id:
                    gesture = None
                classified = any(name in packet for name in ("stable", "rps")) or any(
                    name in control for name in ("stable_gesture", "rps_gesture"))
                self._classification = (result.run_id, config_epoch, result.frame_id, gesture, classified)
            return accepted

    def sample_with_receipt(self, *, tick_id: int,
                            timestamp_ns: int | None = None) -> tuple[GameInput, dict[str, Any]]:
        with self._lock:
            sample, receipt = super().sample_with_receipt(tick_id=tick_id, timestamp_ns=timestamp_ns)
            vertical = {"UP": -1.0, "DOWN": 1.0}.get(receipt["source_direction"], 0.0)
            identity = (receipt["run_id"], receipt["config_epoch"], receipt["source_frame_id"])
            source_gesture = (self._classification[3] if sample.hand_valid and self._classification is not None
                              and self._classification[:3] == identity else None)
            classified = (self._classification is not None and self._classification[:3] == identity
                          and self._classification[4])
            legacy_event = sample.fist_event
            if classified or not sample.hand_valid:
                self._gestures.update(source_gesture)
            else:
                self._gestures.apply_legacy(fist=legacy_event)
            sample = replace(sample, hand_y=vertical if sample.hand_valid else 0.0,
                             **self._gestures.consume())
            receipt.update(hand_y=sample.hand_y, control_mapping="RAW_GESTURE",
                           source_hand_gesture=None if source_gesture is None else source_gesture.value,
                           hand_gesture=None if sample.hand_gesture is None else sample.hand_gesture.value,
                           gesture_sequence=sample.gesture_sequence, gesture_changed=sample.gesture_changed,
                           fist_sequence=sample.fist_sequence, fist_event=sample.fist_event,
                           action_consumed=sample.fist_event,
                           consumed_action_seq=receipt["consumed_action_seq"] if legacy_event and sample.fist_event else None)
            return sample, receipt

    def sample_for_game(self, game_id: str, *, tick_id: int,
                        timestamp_ns: int | None = None) -> tuple[GameInput, dict[str, Any]]:
        sample, receipt = self.sample_with_receipt(tick_id=tick_id, timestamp_ns=timestamp_ns)
        receipt["game_id"] = game_id
        return sample, receipt

    def suspend(self) -> None:
        with self._lock:
            super().suspend()
            self._classification = None
            self._gestures.cancel()

    def resume(self) -> None:
        with self._lock:
            super().resume()
            self._classification = None
            self._gestures.cancel()

    def release(self, message: str = "Vision producer stopped") -> None:
        with self._lock:
            super().release(message)
            self._classification = None
            self._gestures.cancel()
