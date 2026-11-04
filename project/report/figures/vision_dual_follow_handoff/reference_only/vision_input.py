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
        self._menu_expires_at: float | None = None
        self._ui_latest = None
        self._menu_armed = False
        self._menu_pending = False
        self._menu_sequence = 0
        self._menu_fist = False
        self._menu_fist_latched = False
        self._menu_fist_authorized = False
        self._menu_source_seen = False
        self._menu_release_since = self._menu_release_last = None

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
                self._reset_menu_confirmation(block_fist=self._menu_source_seen)
                self._receiver = VisionResultReceiver(self._receiver.timeout_s)
                self._ui_latest = None
                self._epoch = config_epoch
                self._pending = None
                self._clear_menu_input()
            previous = self._receiver.expire(now)
            if not previous.valid and not self._menu_is_fresh(now):
                self._clear_menu_input()
            previous_run = previous.run_id
            result = self._receiver.consume(packet, now)
            if self._receiver.ignored_packet:
                if not result.valid:
                    self._pending = None
                    if (result.status != 'INVALID' or result.message != 'Vision reports no valid hand'
                            or not self._menu_is_fresh(now)):
                        self._clear_menu_input()
                else:
                    # A duplicate may reduce the source lease, never extend
                    # pending actions or menu coordinates beyond that lease.
                    deadline = now + self._receiver.timeout_s - (
                        result.server_age_ms + result.local_age_ms) / 1000.
                    if self._pending is not None:
                        self._pending = (self._pending[0], min(self._pending[1], deadline))
                    if self._menu_expires_at is not None:
                        self._menu_expires_at = min(self._menu_expires_at, deadline)
                    if self._ui_latest is not None:
                        self._ui_latest = (*self._ui_latest[:2], min(self._ui_latest[2], deadline))
                return VisionInputReceipt(result, self._epoch, self._consumed_seq, self._consumed_tick)
            if result.run_id != previous_run:
                self._reset_menu_confirmation(block_fist=self._menu_source_seen)
                self._menu_source_seen = bool(result.run_id)
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
                    self._menu_expires_at = now + self._receiver.timeout_s - result.server_age_ms / 1000.
            # This separately tagged coordinate can drive menu UI even
            # when the recognizer rejects a clipped hand for gameplay.
            ui = packet.get('ui_pointer') if isinstance(packet, dict) else None
            edge_menu = False
            if (isinstance(ui, dict) and ui.get('schema') == 'menu-pointer-v1'
                    and not self._suspended and result.run_id == packet.get('run_id')
                    and result.frame_id == packet.get('frame') == control.get('frame_id')
                    and (result.valid or (result.status == 'INVALID'
                         and result.message == 'Vision reports no valid hand'))
                    and result.server_age_ms is not None
                    and 0 <= result.server_age_ms < self._receiver.timeout_s * 1000):
                point = (ui.get('u'), ui.get('v'))
                if all(type(v) in (int, float) and math.isfinite(v) and -1 <= v <= 1 for v in point):
                    identity = (result.run_id, config_epoch, result.frame_id)
                    if self._ui_latest is None or self._ui_latest[0] != identity:
                        self._ui_latest = (identity, tuple(float(v) for v in point),
                            now + self._receiver.timeout_s - result.server_age_ms / 1000.)
                    self._menu_pointer, self._menu_expires_at = self._ui_latest[1:]
                    edge_menu = (not result.valid and result.status == 'INVALID'
                        and result.message == 'Vision reports no valid hand'
                        and control.get('reason') == 'FRAME_EDGE')
            new_menu_pose = (not self._suspended and isinstance(packet, dict)
                and result.run_id == packet.get('run_id')
                and result.frame_id == packet.get('frame', result.frame_id) == control.get('frame_id')
                and (result.run_id != previous_run or result.frame_id > previous.frame_id)
                and self._menu_is_fresh(now) and (result.valid or edge_menu))
            if new_menu_pose:
                self._observe_menu_pose(packet, control, now, result.server_age_ms)
            return VisionInputReceipt(result, self._epoch, self._consumed_seq, self._consumed_tick)

    def _reset_menu_confirmation(self, *, block_fist=False):
        self._menu_fist = self._menu_fist_authorized = False
        self._menu_fist_latched = block_fist
        self._menu_release_since = self._menu_release_last = None

    def _observe_menu_pose(self, packet, control, now, age_ms):
        # Confirm current FIST directly. No preceding PAPER or transition
        # deadline. A token is consumed once across page changes; UNKNOWN never
        # re-arms it, and one erroneous release frame cannot cause a double click.
        stable = packet.get("stable", control.get("stable_gesture"))
        label = packet.get("rps", control.get("rps_gesture"))
        self._menu_fist = stable == '0' and label == 'ROCK'
        if self._menu_fist:
            self._menu_release_since = self._menu_release_last = None
            if not self._menu_fist_latched:
                self._menu_sequence += 1
                self._menu_pending = True
                self._menu_fist_latched = True
                self._menu_fist_authorized = True
        elif (stable,label) in (('5','PAPER'),('2','SCISSORS')):
            self._menu_pending = False
            source_at = now - age_ms / 1000.
            # Re-arm from fresh release observations at the producer's cadence.
            # A fixed 250 ms gap permanently latched the previous page's fist
            # when recognition ran below 4 fps; stale streams still reset.
            if (self._menu_release_last is None
                    or source_at-self._menu_release_last > self._receiver.timeout_s):
                self._menu_release_since = source_at
            self._menu_release_last = source_at
            if source_at-self._menu_release_since >= .1:
                self._menu_fist_latched = False
        else:
            self._menu_pending = False
            self._menu_release_since = self._menu_release_last = None

    def _clear_menu_input(self) -> None:
        self._menu_pointer = None
        self._menu_expires_at = None
        self._menu_armed = False
        self._menu_pending = False
        self._menu_fist = False

    def sample_menu_control(self, *, tick_id: int) -> ControlState:
        with self._lock:
            now = self._now()
            result = self._receiver.expire(now)
            valid = self._menu_is_fresh(now)
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
                fist_score=1.0 if valid and self._menu_fist and self._menu_fist_authorized else 0.0, fist_event=event,
                voice_source=ControlSource.REAL, voice_seq=0, audio_valid=False,
                low_voice_active=False, high_voice_event=False, low_confidence=0.0, high_confidence=0.0,
            )

    def peek_menu_control(self, *, tick_id: int = 0) -> ControlState:
        """Read the newest fresh hand position without consuming any gesture action."""
        with self._lock:
            now = self._now()
            result = self._receiver.expire(now)
            valid = self._menu_is_fresh(now)
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

    def _menu_is_fresh(self, now: float) -> bool:
        return (not self._suspended and self._menu_pointer is not None
                and self._menu_expires_at is not None and now <= self._menu_expires_at)

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
                "games": ["game1", "game2", "game3", "game4"]}

    def __init__(self, **kwargs: Any) -> None:
        kwargs.setdefault("fist_enabled", True)
        super().__init__(**kwargs)
        self._classification: tuple[str | None, str, int | None, HandGesture | None, bool] | None = None
        self._hand_classification = None  # passive hand state, independent of direction admission
        self._game_position: tuple[tuple, tuple[float, float] | None] | None = None
        self._motion_cache = None  # (source identity, point, absolute source deadline)
        self._motion_loss_allowed = False
        self._no_hand_frame: tuple[str, str, int, float, str] | None = None
        self._gestures = GestureState()

    def discard_game_events(self) -> None:
        """Discard consumer edges without invalidating the shared producer."""
        with self._lock:
            self._pending = None
            self._menu_pending = False
            self._menu_armed = False
            self._gestures.consume()
            self._motion_cache = None
            self._motion_loss_allowed = False

    def peek_hand_classification(self) -> dict[str, Any] | None:
        """Copy the latest classified frame without sampling game/menu events.

        The source timestamp ages with the cached frame, so repeated peeks
        cannot make an old hand observation fresh again.
        """
        with self._lock:
            now = self._now()
            result = self._receiver.expire(now)
            if not result.run_id or result.frame_id < 1:
                return None
            identity = (result.run_id, self._epoch, result.frame_id)
            no_hand = (self._no_hand_frame is not None
                       and self._no_hand_frame[:3] == identity
                       and result.status == "INVALID"
                       and result.message == "Vision reports no valid hand")
            if no_hand:
                source_at = self._no_hand_frame[3]
            else:
                if result.server_age_ms is None or result.local_age_ms is None:
                    return None
                age = (result.server_age_ms + result.local_age_ms) / 1000.0
                if not math.isfinite(age) or age < 0 or age > now:
                    return None
                source_at = now - age
            gesture = (self._hand_classification[3] if self._hand_classification is not None
                       and self._hand_classification[:3] == identity else None)
            return {"run_id": result.run_id, "config_epoch": self._epoch,
                    "frame_id": result.frame_id, "observed_at": now,
                    "source_at": source_at,
                    "valid": (result.valid or no_hand) and not self._suspended
                    and 0 <= now - source_at < self._receiver.timeout_s,
                    # Distinguish an explicit no-hand frame from a visible hand
                    # whose three-state classification is temporarily unknown.
                    # The hand owner may hold the last recognized pose for the
                    # latter, while no-hand requests default immediately.
                    "gesture": ("default" if no_hand and self._no_hand_frame[4]=='NO_HAND'
                                else None if gesture is None else gesture.value)}

    def publish(self, packet: Any, *, config_epoch: str = "default") -> VisionInputReceipt:
        with self._lock:
            previous = self.receipt
            accepted = super().publish(packet, config_epoch=config_epoch)
            result = accepted.result
            if config_epoch != previous.config_epoch or result.run_id != previous.result.run_id:
                self._motion_cache = None
                self._motion_loss_allowed = False
            if not self._receiver.ignored_packet:
                control = packet.get('control', {}) if isinstance(packet, dict) else {}
                self._motion_loss_allowed = (
                    result.status == 'INVALID' and result.message == 'Vision reports no valid hand'
                    and isinstance(control, dict) and control.get('reason') in ('NO_HAND', 'FRAME_EDGE')
                    and packet.get('run_id') == result.run_id
                    and packet.get('frame') == control.get('frame_id') == result.frame_id)
                if not result.valid and not self._motion_loss_allowed:
                    self._motion_cache = None
            elif result.valid and self._motion_cache is not None:
                # Repeated frames may shorten the original deadline, never renew it.
                identity, point, deadline = self._motion_cache
                age = (result.server_age_ms + result.local_age_ms) / 1000.
                self._motion_cache = (identity, point, min(deadline, self._now() + .25 - age))
            no_hand = (result.status == "INVALID"
                       and result.message == "Vision reports no valid hand"
                       and isinstance(packet.get('control'),dict)
                       and packet['control'].get('reason') in ('NO_HAND','FRAME_EDGE')
                       and (result.run_id != previous.result.run_id
                            or result.frame_id > previous.result.frame_id))
            if no_hand:
                self._no_hand_frame = (result.run_id, config_epoch, result.frame_id,
                                       self._now() - result.server_age_ms / 1000.0,
                                       packet['control']['reason'])
            elif not self._receiver.ignored_packet and (
                    result.run_id != previous.result.run_id or result.frame_id >= previous.result.frame_id):
                same_marker = (self._no_hand_frame is not None
                    and self._no_hand_frame[:3]==(result.run_id,config_epoch,result.frame_id)
                    and result.status=='INVALID' and isinstance(packet,dict)
                    and isinstance(packet.get('control'),dict)
                    and packet['control'].get('reason')==self._no_hand_frame[4])
                if not same_marker:
                    self._no_hand_frame = None
            elif (result.valid or result.status != "INVALID"
                  or result.message != "Vision reports no valid hand"):
                self._no_hand_frame = None
            if not result.valid:
                self._classification = None
                self._game_position = None
            elif (config_epoch != previous.config_epoch or result.run_id != previous.result.run_id
                  or result.frame_id > previous.result.frame_id):
                control = packet["control"]
                # Keep both axes, independently of cardinal direction and the
                # separately tagged menu pointer. Only accepted frames update it.
                if any(name in control for name in ("smooth_uv", "u", "v")):
                    point = control.get("smooth_uv")
                    if point is None:
                        point = (control.get("u"), control.get("v"))
                    if (not isinstance(point, (list, tuple)) or len(point) != 2
                            or any(type(v) not in (int, float) or not math.isfinite(v)
                                   or not -1 <= v <= 1 for v in point)):
                        point = None
                    else:
                        point = (float(point[0]), float(point[1]))
                else:
                    # Compatibility for old packets that contain direction only.
                    point = ({"LEFT": -1., "RIGHT": 1.}.get(result.direction, 0.),
                             {"UP": -1., "DOWN": 1.}.get(result.direction, 0.))
                if packet.get("frame", result.frame_id) != result.frame_id:
                    point = None
                self._game_position = ((result.run_id, config_epoch, result.frame_id), point)
                self._motion_cache = (self._game_position[0], point,
                    self._now() + .25 - result.server_age_ms / 1000.) if point is not None else None
                stable = packet.get("stable", control.get("stable_gesture"))
                label = packet.get("rps", control.get("rps_gesture"))
                choice = self._GESTURES.get(stable) if isinstance(stable, str) else None
                gesture = choice[1] if choice and label == choice[0] else None
                if packet.get("frame", result.frame_id) != result.frame_id:
                    gesture = None
                classified = any(name in packet for name in ("stable", "rps")) or any(
                    name in control for name in ("stable_gesture", "rps_gesture"))
                self._classification = (result.run_id, config_epoch, result.frame_id, gesture, classified)
            # Clipping a contour affects classification, not the measured
            # centroid. Reuse the already validated same-frame display point;
            # never turn it into a gesture or renew it from duplicate frames.
            if (not self._receiver.ignored_packet and not result.valid
                    and self._motion_loss_allowed and control.get('reason') == 'FRAME_EDGE'):
                identity = (result.run_id, config_epoch, result.frame_id)
                ui = packet.get('ui_pointer')
                point = (ui.get('u'), ui.get('v')) if isinstance(ui, dict) else ()
                position_ok = (isinstance(ui, dict) and ui.get('schema') == 'menu-pointer-v1'
                    and len(point) == 2
                    and all(type(v) in (int, float) and math.isfinite(v) and -1 <= v <= 1 for v in point)
                    and self._ui_latest is not None and self._ui_latest[0] == identity)
                if not position_ok:
                    self._motion_cache = None
                    self._motion_loss_allowed = False
                elif (config_epoch != previous.config_epoch or result.run_id != previous.result.run_id
                        or result.frame_id > previous.result.frame_id):
                    self._game_position = (identity, self._ui_latest[1])
                    self._motion_cache = (identity, self._ui_latest[1],
                        self._now() + .25 - result.server_age_ms / 1000.)
                elif self._motion_cache is not None and self._motion_cache[0] == identity:
                    self._game_position = self._motion_cache[:2]
                    # A duplicate can shorten, but cannot extend, source age.
                    self._motion_cache = (*self._motion_cache[:2], min(self._motion_cache[2],
                        self._now() + .25 - result.server_age_ms / 1000.))
            # A FRAME_EDGE rejects the direction controller, not an already
            # stable same-frame shape. Copy that classification for the passive
            # hand only; game/menu event admission above remains independent.
            if not self._receiver.ignored_packet:
                edge = (self._no_hand_frame is not None
                        and self._no_hand_frame[:3] == (result.run_id,config_epoch,result.frame_id)
                        and self._no_hand_frame[4]=='FRAME_EDGE')
                matched = (isinstance(packet,dict) and packet.get('run_id')==result.run_id
                           and packet.get('frame',result.frame_id)==result.frame_id
                           and isinstance(packet.get('control'),dict)
                           and packet.get('control',{}).get('frame_id')==result.frame_id)
                if matched and (result.valid or edge):
                    if (config_epoch!=previous.config_epoch or result.run_id!=previous.result.run_id
                            or result.frame_id>previous.result.frame_id):
                        stable=packet.get('stable',packet['control'].get('stable_gesture'))
                        label=packet.get('rps',packet['control'].get('rps_gesture'))
                        choice=self._GESTURES.get(stable) if isinstance(stable,str) else None
                        gesture=choice[1] if choice and label==choice[0] else None
                        self._hand_classification=(result.run_id,config_epoch,result.frame_id,gesture)
                else:
                    self._hand_classification=None
            return accepted

    def sample_with_receipt(self, *, tick_id: int,
                            timestamp_ns: int | None = None) -> tuple[GameInput, dict[str, Any]]:
        with self._lock:
            sample, receipt = super().sample_with_receipt(tick_id=tick_id, timestamp_ns=timestamp_ns)
            identity = (receipt["run_id"], receipt["config_epoch"], receipt["source_frame_id"])
            position = (self._game_position[1] if self._game_position is not None
                        and self._game_position[0] == identity else None)
            cache = self._motion_cache
            fresh = (cache is not None and cache[0][:2] == identity[:2]
                     and self._now() <= cache[2] and not self._suspended)
            classified_valid = sample.hand_valid and position is not None and fresh
            edge_position = (not sample.hand_valid and position is not None and fresh
                             and self._motion_loss_allowed and receipt['source_status'] == 'INVALID')
            held = (not sample.hand_valid and not edge_position and fresh and self._motion_loss_allowed
                    and receipt['source_status'] == 'INVALID')
            valid = classified_valid or edge_position or held
            if held:
                position = cache[1]
            sample = replace(sample, hand_valid=valid,
                             hand_x=position[0] if valid else 0.,
                             hand_y=position[1] if valid else 0.)
            source_gesture = (self._classification[3] if classified_valid and self._classification is not None
                              and self._classification[:3] == identity else None)
            classified = (self._classification is not None and self._classification[:3] == identity
                          and self._classification[4])
            legacy_event = sample.fist_event
            if classified or not classified_valid:
                self._gestures.update(source_gesture)
            else:
                self._gestures.apply_legacy(fist=legacy_event)
            sample = replace(sample, **self._gestures.consume())
            receipt.update(hand_valid=sample.hand_valid, hand_x=sample.hand_x,
                           motion_held=bool(held),
                           motion_edge_position=bool(edge_position),
                           motion_source_frame_id=cache[0][2] if valid else None,
                           motion_max_age_ms=250,
                           hand_y=sample.hand_y, control_mapping="RAW_GESTURE",
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
            self._hand_classification = None
            self._game_position = None
            self._motion_cache = None
            self._motion_loss_allowed = False
            self._gestures.cancel()

    def resume(self) -> None:
        with self._lock:
            super().resume()
            self._classification = None
            self._hand_classification = None
            self._game_position = None
            self._motion_cache = None
            self._motion_loss_allowed = False
            self._gestures.cancel()

    def release(self, message: str = "Vision producer stopped") -> None:
        with self._lock:
            super().release(message)
            self._classification = None
            self._hand_classification = None
            self._game_position = None
            self._motion_cache = None
            self._motion_loss_allowed = False
            self._gestures.cancel()
