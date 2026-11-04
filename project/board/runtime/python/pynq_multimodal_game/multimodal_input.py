from __future__ import annotations

from copy import deepcopy
from dataclasses import asdict, replace
import threading
from uuid import uuid4

from .voice_observations import VoiceObservationBus, VoiceRead


class MultimodalGameInputProvider:
    def __init__(self, visual, audio: VoiceObservationBus, *, max_audio_age_ns: int) -> None:
        self._visual = visual
        self._audio = audio
        self._max_age_ns = max_audio_age_ns
        self._subscription = audio.subscribe(max_age_ns=max_audio_age_ns)
        self._lock = threading.RLock()
        self._audio_receipt: dict | None = None
        self._suspended = False
        self._released = False
        self._voice_read = VoiceRead("WAITING", None, None)

    @property
    def capabilities(self) -> dict:
        return {"schema": "local-game-multimodal-v1",
                "vision": deepcopy(getattr(self._visual, "capabilities", None)),
                "audio": {"schema": "voice-observation-v1", "software_only": True,
                          "action_mapped": False}}

    def _poll_audio(self, timestamp_ns):
        if self._released or self._suspended or self._subscription is None:
            return VoiceRead("STOPPED" if self._released else "WAITING", None, None,
                             reason="game voice subscription requires rearm")
        try:
            return self._subscription.poll(timestamp_ns)
        except Exception as error:
            self._subscription.close()
            return VoiceRead("FAULT", None, None, reason=f"{type(error).__name__}: {error}")

    def _sample(self, game_id, tick_id, timestamp_ns, *, current=False):
        with self._lock:
            voice_read = None
            if current:
                with self._audio.sampling_clock() as timestamp_ns:
                    voice_read = self._poll_audio(timestamp_ns)
            per_game = getattr(self._visual, "sample_for_game", None)
            with_receipt = getattr(self._visual, "sample_with_receipt", None)
            if game_id is not None and callable(per_game):
                value, visual_receipt = per_game(game_id, tick_id=tick_id, timestamp_ns=timestamp_ns)
            elif callable(with_receipt):
                value, visual_receipt = with_receipt(tick_id=tick_id, timestamp_ns=timestamp_ns)
            else:
                value = self._visual.sample(tick_id=tick_id, timestamp_ns=timestamp_ns)
                visual_receipt = None
            receipt = {"schema": "voice-input-receipt-v1", "sample_tick": value.tick_id,
                       "sample_timestamp_ns": value.timestamp_ns, "observation_sampled": False,
                       "action_mapped": False, "source_age_ns": None,
                       "source_age_verified": False, "events": []}
            if self._released or self._suspended or self._subscription is None:
                self._voice_read = VoiceRead("STOPPED" if self._released else "WAITING", None, None)
                receipt.update(source_status="STOPPED" if self._released else "WAITING",
                               reason="game voice subscription requires rearm")
            else:
                read = self._poll_audio(value.timestamp_ns) if voice_read is None else voice_read
                self._voice_read = read
                receipt.update(source_status=read.status, producer_run=read.producer_run,
                               audio_epoch=read.audio_epoch, decision_age_ns=read.decision_age_ns,
                               reason=read.reason, observation_sampled=read.status == "RUNNING")
                if read.latest is not None:
                    receipt.update(packet_index=read.latest.packet_index,
                                   decision_ns=read.latest.decision_ns)
                receipt["events"] = [
                    {**asdict(event), "packet_index": observation.packet_index,
                     "decision_ns": observation.decision_ns}
                    for observation in read.observations for event in observation.events
                ]
            self._audio_receipt = receipt
            return value, visual_receipt

    def sample_current_for_game(self, game_id: str, *, tick_id: int):
        return self._sample(game_id, tick_id, None, current=True)

    def sample_menu_control(self, *, tick_id: int):
        return self._visual.sample_menu_control(tick_id=tick_id)

    def sample_for_game(self, game_id: str, *, tick_id: int, timestamp_ns: int | None = None):
        return self._sample(game_id, tick_id, timestamp_ns)

    def new_game_session(self, manifest, game_run_id: str):
        if manifest.inputs is None:
            return MultimodalGameInputProvider(self._visual, self._audio, max_audio_age_ns=self._max_age_ns)
        return ActionGameInputSession(self._visual, self._audio, manifest=manifest,
                                      game_run=game_run_id, max_audio_age_ns=self._max_age_ns)

    def sample_with_receipt(self, *, tick_id: int, timestamp_ns: int | None = None):
        return self._sample(None, tick_id, timestamp_ns)

    def sample(self, *, tick_id: int, timestamp_ns: int | None = None):
        return self.sample_with_receipt(tick_id=tick_id, timestamp_ns=timestamp_ns)[0]

    def audio_receipt_for_tick(self, tick_id: int) -> dict | None:
        with self._lock:
            if self._audio_receipt is None:
                return None
            if type(tick_id) is not int or self._audio_receipt["sample_tick"] != tick_id:
                raise ValueError("audio receipt tick mismatch")
            return deepcopy(self._audio_receipt)

    def _close_subscription(self):
        if self._subscription is not None:
            self._subscription.close()
            self._subscription = None
        self._audio_receipt = None

    def rearm_audio(self) -> None:
        with self._lock:
            if self._suspended or self._released:
                raise RuntimeError("game voice subscription unavailable")
            if self._audio.status.status not in ("WAITING", "RUNNING"):
                raise RuntimeError("a fresh audio producer epoch is required")
            self._close_subscription()
            self._subscription = self._audio.subscribe(max_age_ns=self._max_age_ns)

    def suspend(self) -> None:
        with self._lock:
            self._visual.suspend()
            self._suspended = True
            self._close_subscription()

    def resume(self) -> None:
        with self._lock:
            self._visual.resume()
            self._suspended = False
            self._close_subscription()

    def release(self, message: str = "Game input stopped") -> None:
        with self._lock:
            self._visual.release(message)
            self._released = True
            self._close_subscription()


class ActionGameInputSession(MultimodalGameInputProvider):
    def __init__(self, visual, audio, *, manifest, game_run, max_audio_age_ns):
        self.manifest = manifest
        self.game_run = game_run
        self.action_epoch = uuid4().hex
        self._policy = self._new_policy()
        super().__init__(visual, audio, max_audio_age_ns=max_audio_age_ns)
        self._armed = True
        self._faulted = False
        self._terminal = False
        self._prepared_audio_rearm = None

    def _new_policy(self, action_epoch=None):
        from .game_voice_policy import create_voice_policy
        return create_voice_policy(self.manifest.inputs, game_id=self.manifest.game_id,
                                   game_run=self.game_run,
                                   action_epoch=self.action_epoch if action_epoch is None else action_epoch)

    @property
    def capabilities(self):
        result = super().capabilities
        result["audio"].update(action_mapped=True, actions_schema="game-actions-v1",
                               policy_id=self.manifest.inputs.policy_id)
        return result

    @property
    def action_permit(self):
        with self._lock:
            return {"game_run": self.game_run, "action_epoch": self.action_epoch,
                    "armed": self._armed and not self._suspended and not self._released,
                    "released": self._released}

    def _sample(self, game_id, tick_id, timestamp_ns, *, current=False):
        from .game_actions import GameActionFrame
        with self._lock:
            if game_id is not None and game_id != self.manifest.game_id:
                raise ValueError("game input session identity mismatch")
            value, visual_receipt = super()._sample(self.manifest.inputs.vision_mapping, tick_id,
                                                  timestamp_ns, current=current)
            if visual_receipt is not None:
                visual_receipt = deepcopy(visual_receipt)
                visual_receipt.update(game_id=self.manifest.game_id,
                                      vision_mapping=self.manifest.inputs.vision_mapping)
            if self._released or self._suspended or not self._armed:
                frame = GameActionFrame(self.manifest.game_id, self.game_run, self.action_epoch,
                                        self.manifest.inputs.policy_id, value.tick_id, value.timestamp_ns,
                                        "STOPPED" if self._released else "FAULT" if self._faulted else "WAITING")
                decisions, counters, reason = (), {}, "game action session requires rearm"
            else:
                if value.actions is not None:
                    self._policy.revoke("visual provider cannot supply action grants")
                result = self._policy.sample(value, self._voice_read)
                frame, decisions, counters, reason = result.frame, result.decisions, result.counters, result.reason
                if frame.status == "FAULT":
                    self._armed = False
                    self._faulted = True
            self._audio_receipt.update(
                schema="voice-action-receipt-v1", action_mapped=True,
                game_id=self.manifest.game_id, game_run=self.game_run,
                action_epoch=self.action_epoch, policy_id=self.manifest.inputs.policy_id,
                policy_status=frame.status, action_frame=asdict(frame), decisions=list(decisions),
                policy_counters=counters, policy_reason=reason,
            )
            return replace(value, actions=frame), visual_receipt

    def revoke_actions(self, reason="game action permission revoked"):
        with self._lock:
            self._prepared_audio_rearm = None
            self._policy.revoke(reason)
            self._armed = False
            self._faulted = reason != "game paused"
            self._terminal = self._terminal or reason == "game terminal"
            self._close_subscription()

    def prepare_audio_rearm(self):
        with self._lock:
            if self._terminal or self._released:
                raise RuntimeError("terminal actions require a new game session")
            self._prepared_audio_rearm = None
            action_epoch = uuid4().hex
            policy = self._new_policy(action_epoch)
            self._prepared_audio_rearm = action_epoch, policy

    def rearm_audio(self):
        with self._lock:
            if self._terminal:
                raise RuntimeError("terminal actions require a new game session")
            prepared = self._prepared_audio_rearm
            self._prepared_audio_rearm = None
            if prepared is None:
                action_epoch = uuid4().hex
                policy = self._new_policy(action_epoch)
            else:
                action_epoch, policy = prepared
            super().rearm_audio()
            self.action_epoch = action_epoch
            self._policy = policy
            self._armed = True
            self._faulted = False

    def suspend(self):
        with self._lock:
            self.revoke_actions("game paused")
            super().suspend()

    def resume(self):
        with self._lock:
            super().resume()
            self._armed = False

    def release(self, message="Game input stopped"):
        with self._lock:
            self.revoke_actions(message)
            super().release(message)