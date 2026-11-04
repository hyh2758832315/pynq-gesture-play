"""Optional, passive latest-result adapter; no camera, SDK, socket or UI I/O.

The game owner may offer a copy of an ALREADY sampled GameInput + receipt.
It must never call a provider's consuming sample() a second time for this hand.
Startup/arm and physical permission remain outside this adapter.
"""
from dataclasses import dataclass
import math
import threading

from .motion import Cancelled


GESTURE_STATES = {"fist": "rock", "scissors": "scissors", "paper": "paper",
                  "default": "default"}


@dataclass(frozen=True)
class GestureObservation:
    run_id: str
    config_epoch: str
    frame_id: int
    observed_at: float
    source_at: float
    valid: bool
    gesture: str | None

    def __post_init__(self):
        if any(not isinstance(v, str) or not 0 < len(v) <= 256 for v in (self.run_id, self.config_epoch)):
            raise ValueError("Explicit source identity required")
        if type(self.frame_id) is not int or self.frame_id < 1 or type(self.valid) is not bool:
            raise ValueError("Invalid frame identity/validity")
        if any(type(v) not in (int, float) or not math.isfinite(v) or v < 0
               for v in (self.source_at, self.observed_at)) or self.source_at > self.observed_at:
            raise ValueError("Invalid monotonic source times")
        if self.gesture is not None and self.gesture not in GESTURE_STATES:
            raise ValueError("Unsupported gesture")

    @classmethod
    def from_game(cls, game_input, receipt, *, observed_at):
        """Copy facts without mutating inputs or consuming an event sequence.

        observed_at uses the same host's monotonic clock as receipt sampling;
        game logical timestamps are deliberately not used for freshness.
        """
        ages = (receipt.get("server_age_ms"), receipt.get("local_age_ms"))
        if any(type(v) not in (int, float) or not math.isfinite(v) or v < 0 for v in ages):
            raise ValueError("Missing source age; never substitute the game tick time")
        gesture = getattr(game_input.hand_gesture, "value", game_input.hand_gesture)
        if (receipt.get("sample_tick") != game_input.tick_id
                or receipt.get("hand_valid") is not game_input.hand_valid
                or receipt.get("hand_gesture") != gesture
                or receipt.get("source_hand_gesture") != gesture):
            raise ValueError("Input and source receipt disagree")
        return cls(receipt.get("run_id"), receipt.get("config_epoch"), receipt.get("source_frame_id"),
                   observed_at, observed_at - sum(ages) / 1000.0, game_input.hand_valid, gesture)


class LatestGesture:
    """One immutable slot. Producer never waits for the slower hand consumer."""
    def __init__(self):
        self._lock = threading.Lock()
        self._latest = None
        self._revoked = False

    def offer(self, observation):
        if not isinstance(observation, GestureObservation):
            raise TypeError("Expected an immutable GestureObservation")
        if not self._lock.acquire(blocking=False):
            return False
        try:
            if self._revoked:
                return False
            previous = self._latest
            if previous and (previous.run_id, previous.config_epoch) != (observation.run_id, observation.config_epoch):
                self._revoked = True
            if previous and (previous.run_id, previous.config_epoch) == (observation.run_id, observation.config_epoch):
                if observation.frame_id < previous.frame_id:
                    return False
                if observation.frame_id == previous.frame_id and observation.valid:
                    # Polling a cached frame cannot refresh its age or payload.
                    return False
            self._latest = observation
            return True
        finally:
            self._lock.release()

    def read(self):
        with self._lock:
            return self._latest


class LatestVisionMailbox:
    """Poll one PS vision snapshot; no game/menu sampling or queued frames."""

    def __init__(self, provider):
        if not callable(getattr(provider, "peek_hand_classification", None)):
            raise TypeError("a non-consuming hand classification view is required")
        self.provider = provider

    def read(self):
        try:
            snapshot = self.provider.peek_hand_classification()
            return None if snapshot is None else GestureObservation(**snapshot)
        except (AttributeError, KeyError, TypeError, ValueError):
            # A broken or absent producer is a missing source, never a pose.
            return None


class GestureConsumer:
    """Explicit checked session, stable classifications, no request backlog.

    Call tick from a bounded low-rate control source, never the render callback.
    Stale/invalid/restarted sources release and latch stopped. No auto-arm.
    """
    def __init__(self, controller, mailbox, *, source_identity, max_age, stable_seconds, renew_interval,
                 qualified_gestures=False):
        if (len(source_identity) != 2
                or any(not isinstance(v, str) or not 0 < len(v) <= 256 for v in source_identity)):
            raise ValueError("An explicit run/config identity is required")
        if any(type(v) not in (int, float) or not math.isfinite(v) or v <= 0
               for v in (max_age, stable_seconds, renew_interval)):
            raise ValueError("Explicit positive source/stability/renew budgets required")
        if renew_interval >= controller.lease_seconds or stable_seconds >= max_age:
            raise ValueError("Renew must precede lease and stability must fit freshness")
        status = controller.status()
        if status.get("mode") != "fixed-playback" or status["lifecycle"] != "READY_IDLE" or status["error"]:
            raise ValueError("Consumer requires an explicitly checked and armed playback session")
        self.controller, self.mailbox = controller, mailbox
        self.source_identity = tuple(source_identity)
        self.max_age, self.stable_seconds, self.renew_interval = max_age, stable_seconds, renew_interval
        if type(qualified_gestures) is not bool:
            raise ValueError('qualified_gestures must be boolean')
        self.qualified_gestures = qualified_gestures
        self.session_id, self.enable_epoch = status["session_id"], status["enable_epoch"]
        self.request_id = controller.last_request
        self.last_frame = -1
        self.last_source_at = -math.inf
        self.last_time = -math.inf
        self.last_renew = -math.inf
        self.candidate = None
        self.since = None
        self.candidate_last = None
        self.last_sent = None
        self.ready_frame = None
        self.stopped = False

    def stop(self, reason="stopped"):
        if not self.stopped:
            self.stopped = True
            self.controller.release()
        return reason

    def tick(self, now):
        if self.stopped:
            return "stopped"
        observation = self.mailbox.read()
        if callable(now):
            now = now()
        if type(now) not in (int, float) or not math.isfinite(now) or now < self.last_time:
            return self.stop("invalid_clock")
        self.last_time = now
        if observation is None:
            return self.stop("missing_source")
        if (observation.run_id, observation.config_epoch) != self.source_identity:
            return self.stop("source_changed")
        if not observation.valid or not observation.observed_at <= now or not 0 <= now - observation.source_at < self.max_age:
            return self.stop("invalid_or_stale_source")
        status = self.controller.status()
        if (status["session_id"], status["enable_epoch"]) != (self.session_id, self.enable_epoch):
            return self.stop("session_changed")
        if status["error"] or status["lifecycle"] not in ("READY_IDLE", "MOVING"):
            return self.stop("controller_not_ready")
        if now - self.last_renew >= self.renew_interval:
            try:
                self.controller.renew(session_id=self.session_id, enable_epoch=self.enable_epoch)
            except (RuntimeError, Cancelled):
                return self.stop("renew_failed")
            except TimeoutError:
                return self.stop("lease_expired")
            self.last_renew = now
        ready_latest = (status['lifecycle']=='READY_IDLE'
                        and observation.frame_id==self.ready_frame)
        if observation.frame_id <= self.last_frame and not ready_latest:
            return "duplicate_frame"
        # This is a marker for the current mailbox frame, never a saved pose or
        # queue. A newer observation supersedes it, including UNKNOWN/default.
        self.ready_frame = None
        self.last_frame = observation.frame_id
        if observation.source_at <= self.last_source_at and not ready_latest:
            return "nonadvancing_source_time"
        self.last_source_at = observation.source_at
        if status["lifecycle"] == "MOVING" and getattr(self.controller, "approval_seconds", None) is None:
            self.candidate, self.since = None, None
            return "busy_dropped"
        # In the qualified live source, None means a visible but unclassified
        # hand. It is not a new pose: keep the last approved state without
        # queueing an old frame. Explicit no-hand is the "default" gesture.
        if self.qualified_gestures and observation.gesture is None:
            self.candidate, self.since = None, None
            return "unclassified_hold"
        state = GESTURE_STATES.get(observation.gesture, "default")
        qualified = (observation.gesture == "default" or
                     self.qualified_gestures and observation.gesture in GESTURE_STATES)
        if (state != self.candidate or self.candidate_last is None
                or observation.source_at - self.candidate_last >= self.max_age):
            self.candidate, self.since = state, observation.source_at
            self.candidate_last = observation.source_at
            if not qualified:
                return "stabilizing"
        if observation.source_at < self.candidate_last:
            return "nonadvancing_source_time"
        self.candidate_last = observation.source_at
        # Track only the newest stable classification during playback. Never
        # submit while busy. READY may use this same latest frame once, provided
        # the source freshness check above still passes.
        if status["lifecycle"] == "MOVING":
            self.ready_frame = observation.frame_id
            return "busy_dropped"
        if not qualified and observation.source_at - self.since < self.stable_seconds:
            return "stabilizing"
        if state == self.last_sent:
            return "unchanged"
        self.request_id += 1
        result = self.controller.submit(state, request_id=self.request_id,
                                        session_id=self.session_id, enable_epoch=self.enable_epoch)
        if result == "accepted":
            self.last_sent = state
        elif result != "busy":
            return self.stop("submit_" + result)
        else:
            self.candidate, self.since = None, None
        return result
