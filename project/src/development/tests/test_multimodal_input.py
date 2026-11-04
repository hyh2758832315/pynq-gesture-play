import pytest

from pynq_multimodal_game.game_sdk import GameInput, ToneSignal
from pynq_multimodal_game.multimodal_input import MultimodalGameInputProvider
from pynq_multimodal_game.vision_input import GameVisionInputProvider
from pynq_multimodal_game.voice_observations import VoiceObservationBus, VoiceResultValidator


def packet(direction="RIGHT", stable="0", label="ROCK"):
    return {"run_id": "vision", "server_age_ms": 0, "stable": stable, "rps": label,
            "control": {"schema": "gesture-control-v1", "frame_id": 1,
                        "action_event_seq": 0, "valid": True, "direction": direction}}


def audio_bus():
    bus = VoiceObservationBus()
    bus.begin_epoch("voice", "epoch")
    return bus


def test_composite_menu_preserves_visual_coordinates_without_polling_audio():
    visual = GameVisionInputProvider(clock=lambda: 1.)
    sample = packet(stable="5", label="PAPER")
    sample["control"].update(u=.2, v=-.3)
    visual.publish(sample)
    composite = MultimodalGameInputProvider(visual, audio_bus(), max_audio_age_ns=1_000_000_000)
    control = composite.sample_menu_control(tick_id=0)
    assert control.hand_valid and (control.hand_x, control.hand_y) == (.2, -.3)
    assert composite.audio_receipt_for_tick(0) is None


@pytest.mark.parametrize("game_id", ["game1", "game2", "game3"])
@pytest.mark.parametrize("direction,stable,label", [
    ("UP", "0", "ROCK"), ("RIGHT", "2", "SCISSORS"), ("DOWN", "5", "PAPER"),
])
def test_composite_preserves_original_game_aware_visual_mapping(game_id, direction, stable, label):
    original = GameVisionInputProvider(clock=lambda: 1.)
    wrapped = GameVisionInputProvider(clock=lambda: 1.)
    original.publish(packet(direction, stable, label))
    wrapped.publish(packet(direction, stable, label))
    composite = MultimodalGameInputProvider(wrapped, audio_bus(), max_audio_age_ns=1_000_000_000)
    expected = original.sample_for_game(game_id, tick_id=0, timestamp_ns=1_000_000_000)
    assert composite.sample_for_game(game_id, tick_id=0, timestamp_ns=1_000_000_000) == expected
    assert composite.audio_receipt_for_tick(0)["action_mapped"] is False


def test_current_sample_snapshot_is_locked_but_visual_allows_publication(monkeypatch):
    from threading import Event, Thread
    from pynq_multimodal_game import voice_observations
    bus = audio_bus()
    validator = VoiceResultValidator("voice", "epoch")
    entered, published = Event(), Event()
    producer = None
    clock_values = iter((1_000_000_000, 1_010_000_000))
    calls = []

    def publish():
        entered.set()
        bus.publish(validator.accept(("result", 1, [], .001, 1.005)))
        published.set()

    class Visual:
        def sample_for_game(self, game_id, *, tick_id, timestamp_ns):
            nonlocal producer
            assert provider._lock._is_owned() and not bus._lock._is_owned()
            if tick_id == 0:
                producer = Thread(target=publish)
                producer.start()
                assert entered.wait(2) and published.wait(2)
            return GameInput(tick_id, timestamp_ns, False, 0, 0, 0, False), None

    provider = MultimodalGameInputProvider(Visual(), bus, max_audio_age_ns=100_000_000)

    def clock():
        assert provider._lock._is_owned() and bus._lock._is_owned()
        calls.append("locked_clock")
        return next(clock_values)

    monkeypatch.setattr(voice_observations.time, "monotonic_ns", clock)
    bus.publish(validator.accept(("result", 0, [], .001, 1.)))
    try:
        first, _ = provider.sample_current_for_game("game1", tick_id=0)
        assert first.timestamp_ns == 1_000_000_000
        assert provider.audio_receipt_for_tick(0)["decision_age_ns"] == 0
        assert provider.audio_receipt_for_tick(0)["packet_index"] == 0
        assert published.wait(2)
        second, _ = provider.sample_current_for_game("game1", tick_id=1)
        assert second.timestamp_ns == 1_010_000_000
        receipt = provider.audio_receipt_for_tick(1)
        assert receipt["source_status"] == "RUNNING" and receipt["decision_age_ns"] == 5_000_000
        assert receipt["packet_index"] == 1 and calls == ["locked_clock"] * 2
    finally:
        if producer is not None:
            producer.join(2)


@pytest.mark.parametrize("staged", [False, True])
def test_action_rearm_prepares_policy_before_subscribing_to_live_decisions(monkeypatch, staged):
    from pynq_multimodal_game.multimodal_input import ActionGameInputSession
    visual = GameVisionInputProvider(clock=lambda: 1.)
    bus = audio_bus()
    session = ActionGameInputSession(visual, bus, manifest=candidate_manifest(),
                                    game_run="game-run", max_audio_age_ns=100_000_000)
    validator = VoiceResultValidator("voice", "epoch")
    session.suspend()
    policy, epochs = object(), []

    def prepare(action_epoch):
        assert session._subscription is None and not session.action_permit["armed"]
        epochs.append(action_epoch)
        bus.publish(validator.accept(("result", 0, [], .001, 1.)))
        bus.publish(validator.accept(("result", 1, [], .001, 1.2)))
        return policy

    monkeypatch.setattr(session, "_new_policy", prepare)
    if staged:
        session.prepare_audio_rearm()
        assert not session.action_permit["armed"] and session._subscription is None
    session.resume()
    session.rearm_audio()
    assert len(epochs) == 1 and session._prepared_audio_rearm is None
    assert session._policy is policy and session.action_epoch == epochs[0]
    assert session.action_permit["armed"] is True
    read = session._subscription.poll(1_200_000_000)
    assert read.status == "RUNNING" and read.observations == ()
    assert read.latest.packet_index == 1 and read.decision_age_ns == 0


@pytest.mark.parametrize("fails", [False, True])
def test_runtime_audio_resume_arms_before_waking_game(monkeypatch, tmp_path, fails):
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    monkeypatch.setattr(PackagedGameRuntime, "_create_preview", lambda *_args, **_kwargs: object())
    runtime = PackagedGameRuntime(tmp_path, object())
    runtime._thread = SimpleNamespace(is_alive=lambda: True)
    runtime._paused.set()
    runtime._wake.clear()
    calls = []

    def rearm():
        assert runtime.paused and not runtime._wake.is_set()
        assert runtime._submission_lock._is_owned()
        calls.append("rearm")
        if fails:
            raise RuntimeError("rearm failed")

    runtime._live_input = SimpleNamespace(resume=lambda: calls.append("resume"), rearm_audio=rearm)
    if fails:
        with pytest.raises(RuntimeError, match="rearm failed"):
            runtime.resume_audio()
        assert runtime.paused and not runtime._wake.is_set()
    else:
        runtime.resume_audio()
        assert not runtime.paused and runtime._wake.is_set()
    assert calls == ["resume", "rearm"]


def test_prepared_audio_policy_is_discarded_on_revocation(monkeypatch):
    from pynq_multimodal_game.multimodal_input import ActionGameInputSession
    session = ActionGameInputSession(GameVisionInputProvider(), audio_bus(), manifest=candidate_manifest(),
                                    game_run="game-run", max_audio_age_ns=100_000_000)
    monkeypatch.setattr(session, "_new_policy", lambda epoch: object())
    session.suspend()
    session.prepare_audio_rearm()
    assert session._prepared_audio_rearm is not None
    session.revoke_actions("start rejected")
    assert session._prepared_audio_rearm is None and not session.action_permit["armed"]


def test_runtime_timing_keeps_first_fault_and_previous_stage_durations(monkeypatch, tmp_path):
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    monkeypatch.setattr(PackagedGameRuntime, "_create_preview",
                        lambda self, **kwargs: SimpleNamespace(step=lambda value: object()))
    runtime = PackagedGameRuntime(tmp_path, object(), live_input=object())
    receipts = []
    clock_value = 0

    def clock():
        nonlocal clock_value
        clock_value += 10
        return clock_value

    def submit(frame, **kwargs):
        receipts.append(kwargs["audio_receipt"])
        if len(receipts) == 3:
            runtime._stop.set()

    monkeypatch.setattr("pynq_multimodal_game.agent.game_runtime.time.monotonic_ns", clock)
    monkeypatch.setattr(runtime, "_sample_live_input", lambda tick: (
        GameInput(tick, tick * 100_000_000, False, 0, 0, 0, False), None))
    monkeypatch.setattr(runtime, "_sample_audio_receipt", lambda tick: {
        "source_status": "RUNNING" if tick == 1 else "FAULT"})
    monkeypatch.setattr(runtime, "_validate_actions", lambda value, receipt: (value, receipt))
    monkeypatch.setattr(runtime, "_submit", submit)
    monkeypatch.setattr(runtime, "_revoke_terminal", lambda frame: None)
    monkeypatch.setattr(runtime, "_drain", lambda: None)
    runtime._run(1_000_000_000)
    assert runtime._last_error is None and len(receipts) == 3
    assert receipts[0]["runtime_timing"]["sample_interval_ns"] is None
    fault = receipts[1]["runtime_timing"]
    assert fault["sample_interval_ns"] == 100_000_000
    assert fault["previous_tick"] == {
        "tick": 1, "sampling_wall_ns": 10, "validation_wall_ns": 10,
        "preview_wall_ns": 10, "submission_wall_ns": 10, "preview_worker": None}
    assert receipts[2]["runtime_timing"] == fault


def test_runtime_preview_upload_overlap_keeps_tick_order_and_flushes_last_scene(monkeypatch, tmp_path):
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    calls, active = [], []
    def begin(value):
        active.append(value.tick_id)
        calls.append(('begin', value.tick_id))
    def finish():
        tick = active.pop()
        calls.append(('finish', tick))
        if tick == 3:
            runtime._stop.set()
        return tick
    preview = SimpleNamespace(begin_step=begin, finish_step=finish)
    monkeypatch.setattr(PackagedGameRuntime, '_create_preview', lambda *_args, **_kwargs: preview)
    runtime = PackagedGameRuntime(tmp_path, object(), live_input=object())
    runtime._preview_upload_overlap = True
    receipts = []
    monkeypatch.setattr(runtime, '_sample_live_input', lambda tick: (
        GameInput(tick, tick * 10, False, 0, 0, 0, False), dict(sample_tick=tick)))
    monkeypatch.setattr(runtime, '_sample_audio_receipt', lambda tick: dict(sample_tick=tick))
    monkeypatch.setattr(runtime, '_validate_actions', lambda value, receipt: (value, receipt))
    def submit(frame, **options):
        calls.append(('submit', frame))
        assert options['vision_receipt']['sample_tick'] == options['audio_receipt']['sample_tick'] == frame
        receipts.append(options['audio_receipt'])
    monkeypatch.setattr(runtime, '_submit', submit)
    monkeypatch.setattr(runtime, '_revoke_terminal', lambda frame: None)
    runtime._run(1_000_000_000)
    assert runtime._last_error is None and runtime._deferred_scene is None
    assert calls == [('begin', 1), ('finish', 1), ('begin', 2), ('submit', 1), ('finish', 2),
                     ('begin', 3), ('submit', 2), ('finish', 3), ('submit', 3)]
    assert 'overlapped_submission_wall_ns' in receipts[1]['runtime_timing']['previous_tick']


@pytest.mark.parametrize('fails', (False, True))
def test_runtime_deferred_scene_drain_never_replays_failed_submission(monkeypatch, tmp_path, fails):
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    monkeypatch.setattr(PackagedGameRuntime, '_create_preview', lambda *_args, **_kwargs: object())
    runtime = PackagedGameRuntime(tmp_path, object())
    pending = (object(), {'sample_tick': 1}, {'sample_tick': 1})
    runtime._deferred_scene = pending
    calls = []
    def submit(frame, **options):
        calls.append(frame)
        if fails:
            raise RuntimeError('submission rejected')
    monkeypatch.setattr(runtime, '_submit', submit)
    if fails:
        with pytest.raises(RuntimeError, match='submission rejected'):
            runtime._drain()
        with pytest.raises(RuntimeError, match='no replay'):
            runtime._drain()
        assert runtime._failed_deferred_scene is pending
    else:
        runtime._drain()
        runtime._drain()
        assert runtime._failed_deferred_scene is None
    assert calls == [pending[0]] and runtime._deferred_scene is None


@pytest.mark.parametrize('case', ('ready', 'not_paused', 'missing_capability'))
def test_runtime_preview_upload_overlap_requires_pause_and_capability(monkeypatch, tmp_path, case):
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    preview = object() if case == 'missing_capability' else SimpleNamespace(begin_step=lambda value: None,
                                                                         finish_step=lambda: None)
    monkeypatch.setattr(PackagedGameRuntime, '_create_preview', lambda *_args, **_kwargs: preview)
    runtime = PackagedGameRuntime(tmp_path, object())
    runtime._thread = SimpleNamespace(is_alive=lambda: True)
    if case != 'not_paused':
        runtime._paused.set()
    if case == 'ready':
        runtime.enable_preview_upload_overlap()
        assert runtime._preview_upload_overlap
    else:
        with pytest.raises(RuntimeError):
            runtime.enable_preview_upload_overlap()
        assert not runtime._preview_upload_overlap


def test_runtime_current_sample_delegates_before_timestamp_capture(monkeypatch):
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    import pynq_multimodal_game.agent.game_runtime as runtime_module
    expected = GameInput(3, 1_000_000_000, False, 0, 0, 0, False), None
    runtime = object.__new__(PackagedGameRuntime)
    runtime._game_id = "game1"
    calls = []

    def sample(game_id, *, tick_id):
        calls.append((game_id, tick_id))
        return expected

    runtime._live_input = SimpleNamespace(sample_current_for_game=sample)
    monkeypatch.setattr(runtime_module.time, "monotonic_ns", lambda: pytest.fail("early tick timestamp"))
    assert runtime._sample_live_input(3) is expected and calls == [("game1", 3)]


def test_composite_returns_exact_input_and_receipt_without_inventing_tones():
    class Visual:
        def sample_for_game(self, game_id, **kwargs):
            return value, receipt
    value = GameInput(0, 1_000_000_000, True, 0, 0, 0, False,
                      tone=ToneSignal(1, 440, True, started=True))
    receipt = {"original": "receipt"}
    provider = MultimodalGameInputProvider(Visual(), audio_bus(), max_audio_age_ns=100)
    actual, actual_receipt = provider.sample_for_game("game3", tick_id=0)
    assert actual is value and actual_receipt is receipt and actual.tone is value.tone
    with pytest.raises(ValueError, match="tick"):
        provider.audio_receipt_for_tick(1)


def test_current_wrong_game_rejected_before_audio_snapshot(monkeypatch):
    provider = MultimodalGameInputProvider(GameVisionInputProvider(), audio_bus(),
                                           max_audio_age_ns=100_000_000)
    session = provider.new_game_session(candidate_manifest(), "game-run")
    monkeypatch.setattr(session, "_poll_audio", lambda *_args: pytest.fail("audio polled before identity"))
    with pytest.raises(ValueError, match="identity"):
        session.sample_current_for_game("wrong-game", tick_id=0)


def test_audio_fault_and_lifecycle_leave_visual_and_shared_source_independent():
    visual = GameVisionInputProvider(clock=lambda: 1.)
    visual.publish(packet())
    bus = audio_bus()
    validator = VoiceResultValidator("voice", "epoch")
    provider = MultimodalGameInputProvider(visual, bus, max_audio_age_ns=1_000_000_000)
    bus.publish(validator.accept(("result", 0, [], 0.001, 1.)))
    provider.sample_for_game("game1", tick_id=0, timestamp_ns=1_000_000_000)
    receipt = provider.audio_receipt_for_tick(0)
    assert receipt["packet_index"] == 0 and receipt["observation_sampled"]
    receipt["events"].append({"mutated": True})
    assert provider.audio_receipt_for_tick(0)["events"] == []
    assert provider.audio_receipt_for_tick(0)["packet_index"] == 0
    provider.suspend()
    provider.resume()
    assert bus.status.status == "RUNNING"
    provider.sample_for_game("game1", tick_id=1, timestamp_ns=1_000_000_000)
    assert provider.audio_receipt_for_tick(1)["source_status"] == "WAITING"
    provider.rearm_audio()
    bus.invalidate("worker fault")
    visual.publish({**packet(), "control": {**packet()["control"], "frame_id": 2}})
    actual, _ = provider.sample_for_game("game1", tick_id=2, timestamp_ns=1_000_000_000)
    assert actual.hand_valid and actual.hand_x == 1 and actual.tone is None
    assert provider.audio_receipt_for_tick(2)["source_status"] == "FAULT"
    with pytest.raises(RuntimeError, match="fresh"):
        provider.rearm_audio()
    bus.begin_epoch("voice", "next")
    provider.rearm_audio()
    provider.release()
    assert bus.status.status == "WAITING"
    with pytest.raises(RuntimeError, match="unavailable"):
        provider.rearm_audio()


@pytest.mark.parametrize("bad", [
    {"schema": "voice-input-receipt-v1", "sample_tick": True, "action_mapped": False},
    {"schema": "voice-input-receipt-v1", "sample_tick": 1, "action_mapped": False},
    {"schema": "voice-input-receipt-v1", "sample_tick": 0, "action_mapped": True},
    {"schema": "approved-action-v1", "sample_tick": 0, "action_mapped": False},
])
def test_runtime_invalid_audio_sidecar_is_isolated_from_visual_input(monkeypatch, tmp_path, bad):
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    visual = GameVisionInputProvider(clock=lambda: 1.)
    visual.publish(packet())
    provider = MultimodalGameInputProvider(visual, audio_bus(), max_audio_age_ns=100)
    monkeypatch.setattr(provider, "audio_receipt_for_tick", lambda _tick: bad)
    monkeypatch.setattr(PackagedGameRuntime, "_create_preview", lambda *_args, **_kwargs: object())
    runtime = PackagedGameRuntime(tmp_path / "mock.vvg", object(), live_input=provider)
    runtime._game_id = "game1"
    value, receipt = runtime._sample_live_input(0)
    audio = runtime._sample_audio_receipt(0)
    assert value.hand_valid and receipt["game_id"] == "game1"
    assert audio["source_status"] == "FAULT" and audio["sample_tick"] == 0
    assert audio["action_mapped"] is False and runtime.last_error is None


def candidate_manifest():
    from dataclasses import replace
    from pathlib import Path
    from pynq_multimodal_game.game_package import GameManifest, GameInputContract
    manifest = GameManifest.from_toml((Path(__file__).resolve().parents[1] / "games/game1/game.toml").read_bytes())
    return replace(manifest, game_id="game1-voice-s2", sdk_minor=2,
                   inputs=GameInputContract("game-actions-v1", "game1-timed-v1", "game1"))


def test_action_session_alias_pause_rearm_and_source_independence():
    from pynq_multimodal_game.voice_observations import VoiceObservation, VoiceEvent
    visual = GameVisionInputProvider(clock=lambda: 1.)
    visual.publish(packet("UP"))
    bus = audio_bus()
    factory = MultimodalGameInputProvider(visual, bus, max_audio_age_ns=10_000_000_000)
    session = factory.new_game_session(candidate_manifest(), "run")
    bus.publish(VoiceObservation("voice", "epoch", 0, 1_000_000_000, 0.,
                                 (VoiceEvent(1, "LOW_SEGMENT_ON", "shield_on", 0),)))
    value, receipt = session.sample_for_game("game1-voice-s2", tick_id=0, timestamp_ns=1_000_000_000)
    assert value.hand_y == -1 and value.actions.actions[0].active
    assert receipt["game_id"] == "game1-voice-s2" and receipt["vision_mapping"] == "game1"
    audio = session.audio_receipt_for_tick(0)
    assert audio["schema"] == "voice-action-receipt-v1" and audio["action_mapped"]
    old_epoch = session.action_epoch
    session.suspend()
    assert not session.action_permit["armed"] and bus.status.status == "RUNNING"
    session.resume()
    assert session.sample(tick_id=1, timestamp_ns=1_100_000_000).actions.status == "WAITING"
    session.rearm_audio()
    assert session.action_epoch != old_epoch
    value = session.sample(tick_id=2, timestamp_ns=1_200_000_000)
    assert all(not action.active for action in value.actions.actions)
    session.release()
    fresh = factory.new_game_session(candidate_manifest(), "next-run")
    assert fresh.game_run == "next-run" and bus.status.status == "RUNNING"
    assert all(not action.active for action in fresh.sample(tick_id=0, timestamp_ns=1_300_000_000).actions.actions)


def test_action_session_fault_and_wrong_identity_never_grant():
    visual = GameVisionInputProvider(clock=lambda: 1.)
    bus = audio_bus()
    provider = MultimodalGameInputProvider(visual, bus, max_audio_age_ns=100)
    session = provider.new_game_session(candidate_manifest(), "run")
    with pytest.raises(ValueError, match="identity"):
        session.sample_for_game("game2", tick_id=0, timestamp_ns=1_000_000_000)
    bus.invalidate("test worker death")
    assert session.sample(tick_id=0, timestamp_ns=1_000_000_000).actions.status == "FAULT"
    assert not session.action_permit["armed"]
    with pytest.raises(RuntimeError, match="fresh"):
        session.rearm_audio()


@pytest.mark.parametrize("damage", ["missing", "tick", "run", "frame", "status"])
def test_runtime_bad_action_receipt_neutralizes_grants_before_game_step(monkeypatch, tmp_path, damage):
    from dataclasses import asdict
    from copy import deepcopy
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from test_game_voice_policy import make_policy, sample
    frame = sample(make_policy(), 0, 0, [(1, "attack")], packet=0).frame
    value = GameInput(0, 0, True, 1, -1, 0, False, actions=frame)
    receipt = {"schema": "voice-action-receipt-v1", "action_mapped": True, "sample_tick": 0,
               "sample_timestamp_ns": 0, "game_id": frame.game_id, "game_run": frame.game_run,
               "action_epoch": frame.action_epoch, "policy_id": frame.policy_id,
               "policy_status": "RUNNING", "source_status": "RUNNING", "action_frame": asdict(frame)}
    monkeypatch.setattr(PackagedGameRuntime, "_create_preview", lambda *_args, **_kwargs: object())
    runtime = PackagedGameRuntime(tmp_path / "mock.vvg", object())
    runtime._manifest = candidate_manifest()
    runtime._game_id, runtime._game_run = frame.game_id, frame.game_run
    actual, _ = runtime._validate_actions(value, deepcopy(receipt))
    assert actual is value
    if damage == "missing":
        receipt = None
    elif damage == "tick":
        receipt["sample_tick"] = True
    elif damage == "run":
        receipt["game_run"] = "wrong"
    elif damage == "frame":
        receipt["action_frame"]["actions"] = []
    else:
        receipt["source_status"] = "FAULT"
    actual, fault = runtime._validate_actions(value, receipt)
    assert actual.hand_x == 1 and actual.hand_y == -1
    assert actual.actions.status == "FAULT" and actual.actions.actions == ()
    assert fault["policy_status"] == "FAULT"


def test_action_terminal_requires_new_session_not_rearm():
    provider = MultimodalGameInputProvider(GameVisionInputProvider(), audio_bus(), max_audio_age_ns=100)
    session = provider.new_game_session(candidate_manifest(), "run")
    session.revoke_actions("game terminal")
    with pytest.raises(RuntimeError, match="terminal"):
        session.rearm_audio()
    assert not session.action_permit["armed"]
    session.release()