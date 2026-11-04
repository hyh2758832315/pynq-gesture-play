from __future__ import annotations

from collections import deque
from copy import deepcopy
from dataclasses import dataclass
from pathlib import Path
from typing import Protocol

from .game_actions import ActionPhase, GameAction, GameActionFrame
from .game_sdk import GameInput
from .voice_observations import VoiceRead


@dataclass(frozen=True)
class PolicySample:
    frame: GameActionFrame
    decisions: tuple[dict, ...]
    counters: dict[str, int]
    reason: str | None = None


class GameVoicePolicy(Protocol):
    def sample(self, game_input: GameInput, source: VoiceRead) -> PolicySample: ...
    def revoke(self, reason: str) -> None: ...


class TimedGameVoicePolicy:
    policy_id = "game1-timed-v1"

    def __init__(self, game_id: str, game_run: str, action_epoch: str) -> None:
        from .voice_service import VENDOR_ROOT, verify_frozen_source
        verify_frozen_source()
        from ._vendor.voice_rule_cooperative_20261012.game1_rules import voice_event_bridge
        if not voice_event_bridge.__file__ or not (
            VENDOR_ROOT / "game1_rules/voice_event_bridge.py"
        ).resolve() == Path(voice_event_bridge.__file__).resolve():
            raise ValueError("voice policy origin mismatch")
        self._bridge = voice_event_bridge.VoiceEventBridge()
        self.game_id, self.game_run, self.action_epoch = game_id, game_run, action_epoch
        GameActionFrame(game_id, game_run, action_epoch, self.policy_id, 0, 0, "WAITING")
        self._identity: tuple[str | None, str | None] | None = None
        self._last_tick: int | None = None
        self._last_time: int | None = None
        self._last_packet: int | None = None
        self._last_event: int | None = None
        self._last_decision: int | None = None
        self._fire_sequence = 0
        self._guard_sequence = 0
        self._fault: str | None = None
        self._trace: deque[dict] = deque(maxlen=128)
        self._counters = {key: 0 for key in ("recognized", "approved", "rejected", "cancelled")}

    @property
    def trace(self) -> tuple[dict, ...]:
        return tuple(deepcopy(self._trace))

    def revoke(self, reason: str) -> None:
        self._fault = self._fault or reason
        self._bridge.reset()

    def _result(self, game_input, status, actions=(), decisions=()):
        return PolicySample(GameActionFrame(
            self.game_id, self.game_run, self.action_epoch, self.policy_id,
            game_input.tick_id, game_input.timestamp_ns, status, tuple(actions),
        ), tuple(deepcopy(decisions)), dict(self._counters), self._fault)

    def sample(self, game_input: GameInput, source: VoiceRead) -> PolicySample:
        if self._fault is not None:
            return self._result(game_input, "FAULT")
        try:
            return self._sample(game_input, source)
        except (ValueError, TypeError, OverflowError) as error:
            self.revoke(str(error))
            return self._result(game_input, "FAULT")

    def _sample(self, game_input: GameInput, source: VoiceRead) -> PolicySample:
        now = game_input.timestamp_ns
        if type(now) is not int or now < 0 or type(game_input.tick_id) is not int:
            raise ValueError("invalid consumption time or tick")
        if self._last_tick is not None and (
            game_input.tick_id <= self._last_tick or now < self._last_time
        ):
            raise ValueError("policy consumption time or tick regressed")
        self._last_tick, self._last_time = game_input.tick_id, now
        if game_input.tone is not None:
            raise ValueError("timed actions and tone are exclusive")
        if source.status not in ("WAITING", "RUNNING"):
            raise ValueError(source.reason or "voice source revoked")
        if source.status == "WAITING":
            self._bridge.reset()
            return self._result(game_input, "WAITING")
        identity = (source.producer_run, source.audio_epoch)
        if not all(type(value) is str and value for value in identity):
            raise ValueError("voice source identity missing")
        if self._identity is not None and identity != self._identity:
            raise ValueError("voice source epoch changed")
        self._identity = identity
        if len(source.observations) > 64:
            raise ValueError("voice observation batch capacity exceeded")
        decision = self._bridge.update(now)
        pending = None
        decisions = []
        for observation in source.observations:
            if (observation.producer_run, observation.audio_epoch) != identity:
                raise ValueError("voice observation epoch mismatch")
            if (observation.schema != "voice-observation-v1" or len(observation.events) > 64
                    or type(observation.packet_index) is not int
                    or observation.packet_index < 0
                    or type(observation.decision_ns) is not int or not 0 <= observation.decision_ns <= now
                    or (self._last_packet is not None and observation.packet_index != self._last_packet + 1)
                    or (self._last_decision is not None and observation.decision_ns < self._last_decision)):
                raise ValueError("voice packet sequence or decision time invalid")
            self._last_packet = observation.packet_index
            self._last_decision = observation.decision_ns
            for event in observation.events:
                if (type(event.sequence) is not int or event.sequence < 1
                        or (self._last_event is not None and event.sequence != self._last_event + 1)):
                    raise ValueError("voice event sequence discontinuity")
                expected = {"attack": "HIGH_ONSET", "shield_on": "LOW_SEGMENT_ON", "shield_off": "LOW_SEGMENT_OFF"}
                if expected.get(event.source_event) != event.kind:
                    raise ValueError("voice fact kind mismatch")
                self._last_event = event.sequence
                self._counters["recognized"] += 1
                decision = self._bridge.update(now, event.source_event)
                outcome = "approved" if decision.attack or decision.reason == "shield_refresh" else "observed"
                if event.source_event == "attack" and not decision.attack:
                    outcome = "rejected"
                    self._counters["rejected"] += 1
                if outcome == "approved":
                    self._counters["approved"] += 1
                item = {"source_sequence": event.sequence, "source_event": event.source_event,
                        "packet_index": observation.packet_index, "decision_ns": observation.decision_ns,
                        "consumption_ns": now, "reason": decision.reason, "outcome": outcome}
                decisions.append(item)
                if decision.attack:
                    if pending is not None:
                        raise ValueError("multiple fire grants in one consumption tick")
                    pending = item
                if decision.reason == "shield_refresh":
                    self._guard_sequence += 1
                if decision.shield and pending is not None:
                    pending["outcome"] = "cancelled"
                    pending["reason"] = "cancelled_by_same_tick_guard"
                    self._counters["cancelled"] += 1
                    pending = None
        self._trace.extend(deepcopy(decisions))
        actions = []
        if pending is not None:
            self._fire_sequence += 1
            actions.append(GameAction("fire", self._fire_sequence, ActionPhase.TRIGGER, True,
                                      source_sequence=pending["source_sequence"]))
        actions.append(GameAction("guard", self._guard_sequence, ActionPhase.STATE, decision.shield,
                                  self._bridge.policy.deadline_ns if decision.shield else None))
        return self._result(game_input, "RUNNING", actions, decisions)


def create_voice_policy(contract, *, game_id: str, game_run: str, action_epoch: str) -> GameVoicePolicy:
    if contract.actions_schema != "game-actions-v1":
        raise ValueError("unsupported action schema")
    if set(contract.required_audio_capabilities) - {"audio.edges"}:
        raise ValueError("required audio capability unavailable (pitch is not provided)")
    registry = {TimedGameVoicePolicy.policy_id: TimedGameVoicePolicy}
    if contract.policy_id not in registry or contract.vision_mapping != "game1":
        raise ValueError("unsupported voice policy or vision mapping")
    return registry[contract.policy_id](game_id, game_run, action_epoch)