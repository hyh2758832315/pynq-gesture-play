from dataclasses import replace

import pytest

from pynq_multimodal_game.game_sdk import GameInput, ToneSignal
from pynq_multimodal_game.game_package import GameInputContract
from pynq_multimodal_game.game_voice_policy import TimedGameVoicePolicy, create_voice_policy
from pynq_multimodal_game.voice_observations import VoiceEvent, VoiceObservation, VoiceRead


def make_policy():
    return TimedGameVoicePolicy("game1-voice-s2", "test-run", "test-epoch")


def sample(policy, tick, now, events=(), *, packet=None, decided=None, status="RUNNING"):
    pairs = {"attack": "HIGH_ONSET", "shield_on": "LOW_SEGMENT_ON", "shield_off": "LOW_SEGMENT_OFF"}
    observations = () if packet is None else (VoiceObservation(
        "producer", "audio", packet, now if decided is None else decided, 0.0,
        tuple(VoiceEvent(sequence, pairs[name], name, 0) for sequence, name in events),
    ),)
    return policy.sample(GameInput(tick, now, True, 0, 0, 0, False),
                         VoiceRead(status, "producer", "audio", observations))


def fire(result):
    return any(action.action_id == "fire" for action in result.frame.actions)


def guard(result):
    return next(action for action in result.frame.actions if action.action_id == "guard")


def test_cooldown_exact_boundary_and_no_replay():
    policy = make_policy()
    assert fire(sample(policy, 0, 0, [(1, "attack")], packet=0))
    rejected = sample(policy, 1, 490_000_000, [(2, "attack")], packet=1)
    assert not fire(rejected) and rejected.decisions[0]["reason"] == "attack_blocked_by_cooldown"
    assert fire(sample(policy, 2, 500_000_000, [(3, "attack")], packet=2))
    assert not fire(sample(policy, 3, 1_000_000_000))


def test_guard_expiry_release_refresh_and_persistent_segment():
    policy = make_policy()
    assert guard(sample(policy, 0, 0, [(1, "shield_on")], packet=0)).deadline_ns == 5_000_000_000
    assert guard(sample(policy, 1, 1_000_000_000, [(2, "shield_on")], packet=1)).deadline_ns == 5_000_000_000
    assert guard(sample(policy, 2, 2_000_000_000, [(3, "shield_off")], packet=2)).active
    assert guard(sample(policy, 3, 3_000_000_000, [(4, "shield_on")], packet=3)).deadline_ns == 8_000_000_000
    assert guard(sample(policy, 4, 7_999_999_999)).active
    assert not guard(sample(policy, 5, 8_000_000_000)).active
    assert not guard(sample(policy, 6, 12_000_000_000)).active


@pytest.mark.parametrize("events", [[(1, "attack"), (2, "shield_on")], [(1, "shield_on"), (2, "attack")]])
def test_same_tick_guard_cancels_or_rejects_fire(events):
    policy = make_policy()
    result = sample(policy, 0, 0, events, packet=0)
    assert not fire(result) and guard(result).active
    assert result.decisions[0 if events[0][1] == "attack" else 1]["outcome"] in ("cancelled", "rejected")
    assert not fire(sample(policy, 1, 6_000_000_000))


def test_delayed_cpu_decision_uses_consumption_time():
    policy = make_policy()
    sample(policy, 0, 1_000_000_000)
    result = sample(policy, 1, 2_000_000_000, [(1, "shield_on")], packet=0, decided=100_000_000)
    assert guard(result).deadline_ns == 7_000_000_000
    assert result.decisions[0]["decision_ns"] == 100_000_000


def test_fault_and_duplicate_revoke_until_new_policy():
    policy = make_policy()
    sample(policy, 0, 0, [(1, "attack")], packet=0)
    assert sample(policy, 1, 1_000_000_000, [(1, "attack")], packet=1).frame.status == "FAULT"
    assert sample(policy, 2, 2_000_000_000).frame.status == "FAULT"
    policy = make_policy()
    assert sample(policy, 0, 0, status="FAULT").frame.actions == ()


def test_registry_capability_gate_and_tone_exclusivity():
    contract = GameInputContract("game-actions-v1", "game1-timed-v1", "game1")
    for invalid in (replace(contract, policy_id="unknown"), replace(contract, vision_mapping="game2"),
                    replace(contract, required_audio_capabilities=("audio.pitch",))):
        with pytest.raises(ValueError):
            create_voice_policy(invalid, game_id="game", game_run="run", action_epoch="epoch")
    policy = make_policy()
    game_input = GameInput(0, 0, True, 0, 0, 0, False, ToneSignal(1, 220, True))
    assert policy.sample(game_input, VoiceRead("RUNNING", "producer", "audio")).frame.status == "FAULT"


def test_policy_audit_is_bounded():
    policy = make_policy()
    for tick in range(140):
        result = sample(policy, tick, tick * 500_000_000, [(tick + 1, "attack")], packet=tick)
    assert len(policy.trace) == 128 and result.counters["approved"] == 140


def test_timed_engine_has_no_second_energy_or_cooldown_permission():
    from pynq_multimodal_game.engine.side_scroller import GameEngine, GameConfig, SideScrollerCommand
    engine = GameEngine(GameConfig(action_mode="policy_timed"))
    state = replace(engine.initial_state(), shield_energy=0, attack_cooldown=30)
    state = engine.step(state, SideScrollerCommand(0, shield=True))
    assert state.shield_active and state.shield_energy == 0
    state = engine.step(state, SideScrollerCommand(1, attack=True))
    assert len(state.player_projectiles) == 1 and engine.last_effects.fire_spawned
    state = engine.step(state, SideScrollerCommand(2, attack=True))
    assert len(state.player_projectiles) == 2 and engine.last_effects.fire_surviving
    assert not state.shield_active and state.attack_cooldown == 0


def test_engine_distinguishes_capacity_spawn_and_collision():
    from pynq_multimodal_game.engine.side_scroller import GameEngine, GameConfig, SideScrollerCommand, Obstacle
    engine = GameEngine(GameConfig(action_mode="policy_timed", max_player_projectiles=1))
    state = engine.step(engine.initial_state(), SideScrollerCommand(0, attack=True))
    engine.step(state, SideScrollerCommand(1, attack=True))
    assert engine.last_effects.fire_capacity_rejected and not engine.last_effects.fire_spawned
    engine = GameEngine(GameConfig(action_mode="policy_timed"), obstacles=(Obstacle(0, 0),))
    state = engine.step(engine.initial_state(), SideScrollerCommand(0, attack=True))
    assert engine.last_effects.fire_spawned and not engine.last_effects.fire_surviving
    assert len(state.player_projectiles) == 0


def test_schema3_voice_timestamps_and_legacy_json_omission():
    import json
    from pynq_multimodal_game.game_testing import GameTestCase, InputEvent, InputKind
    case = GameTestCase("virtual", "Virtual", max_ticks=2, events=(
        InputEvent(0, InputKind.VOICE, event_id="fact", voice_events=("attack",)),
    ), tick_timestamps_ns=(0, 490_000_000, 500_000_000))
    assert case.schema_version == 3 and GameTestCase.from_json(case.to_json()) == case
    legacy = json.loads(GameTestCase("legacy", "Legacy", max_ticks=2, events=(
        InputEvent(0, InputKind.HAND, event_id="hand", x=160, y=90),
    )).to_json())
    assert "tick_timestamps_ns" not in legacy
    assert "voice_events" not in legacy["events"][0] and "voice_status" not in legacy["events"][0]
    for invalid in ((0, 1), (0, 0, 1), (0, True, 2), (0, 1.5, 2), (0, -1, 2), (0, 1, 2**63)):
        with pytest.raises(ValueError, match="timestamp"):
            replace(case, tick_timestamps_ns=invalid)
    with pytest.raises(ValueError, match="schema 3"):
        replace(case, schema_version=2)


def test_same_policy_virtual_playback_is_deterministic_and_rearms():
    from pynq_multimodal_game.game_testing import GameTestCase, InputEvent, InputKind
    from pynq_multimodal_game.game_validation import GameTestPlayback
    from test_multimodal_input import candidate_manifest
    case = GameTestCase("rearm", "Rearm", max_ticks=4, events=(
        InputEvent(0, InputKind.VOICE, event_id="fire", voice_events=("attack",)),
        InputEvent(2, InputKind.VOICE, event_id="fault", voice_status="FAULT"),
        InputEvent(4, InputKind.VOICE, event_id="rearm", voice_status="REARM", voice_events=("attack",)),
    ), tick_timestamps_ns=(0, 500_000_000, 1_000_000_000, 1_500_000_000, 2_000_000_000))
    first = GameTestPlayback(case, tick_hz=60, manifest=candidate_manifest())
    second = GameTestPlayback(case, tick_hz=60, manifest=candidate_manifest())
    frames = []
    for tick in range(5):
        value = first.input_at(tick)
        assert value == second.input_at(tick)
        frames.append(value.actions)
    assert any(action.action_id == "fire" for action in frames[0].actions)
    assert not any(action.action_id == "fire" for action in frames[1].actions)
    assert frames[2].status == frames[3].status == "FAULT"
    assert frames[4].action_epoch != frames[0].action_epoch
    assert any(action.action_id == "fire" for action in frames[4].actions)
    assert first.audio_receipt["evidence_kind"] == "fixture-virtual"
    first.revoke_actions("terminal")
    first.close()
    second.close()


def test_runner_refuses_wrong_run_game_and_undeclared_action(tmp_path):
    from pathlib import Path
    from pynq_multimodal_game.game_package import GamePackageBuilder
    from pynq_multimodal_game.game_runner import GameRunner
    root = Path(__file__).resolve().parents[1]
    package = GamePackageBuilder().build(root / "candidates/game1-voice-s2", tmp_path / "candidate.vvg")
    frame = sample(make_policy(), 0, 0, [(1, "attack")], packet=0).frame
    with GameRunner(package.path, game_run="test-run", render_rgb=False) as runner:
        for invalid in (replace(frame, game_run="other"), replace(frame, game_id="other")):
            with pytest.raises(ValueError, match="binding"):
                runner.step(GameInput(0, 0, True, 0, 0, 0, False, actions=invalid))
        assert runner.step(GameInput(0, 0, True, 0, 0, 0, False, actions=frame)).snapshot.values["effects"]["fire_spawned"]
    package = GamePackageBuilder().build(root / "games/game1", tmp_path / "legacy.vvg")
    with GameRunner(package.path, render_rgb=False) as runner:
        with pytest.raises(ValueError, match="legacy"):
            runner.step(GameInput(0, 0, True, 0, 0, 0, False, actions=frame))


def test_schema3_roundtrip_pc_and_software_runtime(tmp_path):
    from pathlib import Path
    import threading
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from pynq_multimodal_game.game_testing import GameTestCase
    from pynq_multimodal_game.game_validation import build_verified_game, run_game_test, compare_test_reports, save_test_report
    root = Path(__file__).resolve().parents[1]
    artifacts = root / "results/game-validation/voice-s2-policy-20261013"
    package = build_verified_game(root / "candidates/game1-voice-s2", artifacts / "game1-voice-s2.vvg")
    case = GameTestCase.load(root / "candidates/game1-voice-s2/tests/replays/s2-boundaries.json")
    pc = run_game_test(package.path, case)
    pc.save(artifacts / "pc-report.json")
    assert pc.passed, pc.to_dict()

    class Sink:
        def upload_asset(self, packet): pass
        def upload_palette(self, packet): pass
        def upload_tilemap(self, packet): pass
        def submit_scene(self, packet): pass

    runtime = PackagedGameRuntime(package.path, Sink())
    runtime.load_test_case(case)
    complete = threading.Event()
    original = runtime._evaluate_assertions

    def evaluate(frame, game_input):
        original(frame, game_input)
        if frame.snapshot.tick_id == case.max_ticks:
            complete.set()

    runtime._evaluate_assertions = evaluate
    try:
        runtime.start()
        assert complete.wait(10), runtime.last_error
    finally:
        runtime.stop()
    software = runtime.test_report
    assert software is not None
    software["evidence_kind"] = "software-runtime-no-hardware"
    save_test_report(software, artifacts / "software-runtime-report.json")
    comparison = compare_test_reports(pc.to_dict(), software)
    save_test_report(comparison, artifacts / "comparison.json")
    assert comparison["status"] == "passed" and comparison["matched_ticks"] == 13
    receipt = runtime.audio_consumption
    assert receipt["schema"] == "voice-action-receipt-v1" and receipt["scene_tick"] == 12
    assert receipt["sink_completion"] == "confirmed" and receipt["evidence_kind"] == "fixture-virtual"
    assert receipt["effect_totals"]["fire_spawned"] == 3


def test_action_ticket_receipt_is_atomic_and_failure_preserves_completed_scene(tmp_path):
    from pathlib import Path
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from test_game_testing import _TicketSink
    from test_multimodal_input import candidate_manifest
    sink = _TicketSink()
    runtime = PackagedGameRuntime(Path("unused.vvg"), sink)
    runtime._manifest = candidate_manifest()
    runtime._game_id, runtime._game_run = "game1-voice-s2", "test-run"
    for tick in range(2):
        frame = SimpleNamespace(asset_packet=None, palette_packet=None, tilemap_packet=None,
                                scene_packet=bytes([tick]), scene_sha256=f"scene-{tick}",
                                snapshot=SimpleNamespace(tick_id=tick, status="RUNNING", score=0,
                                    values={"effects": {"tick_id": tick}, "fire_consumed": tick == 0}))
        receipt = {"schema": "voice-action-receipt-v1", "action_mapped": True,
                   "sample_tick": tick, "game_id": runtime._game_id, "game_run": runtime._game_run}
        runtime._submit(frame, audio_receipt=receipt)
    assert runtime.audio_consumption is None
    runtime._retire_oldest()
    completed = runtime.audio_consumption
    assert completed["sample_tick"] == completed["scene_tick"] == completed["game_effects"]["tick_id"] == 0
    runtime._wait_scene = lambda _ticket: (_ for _ in ()).throw(RuntimeError("expected ticket failure"))
    with pytest.raises(RuntimeError, match="expected ticket"):
        runtime._retire_oldest()
    assert runtime.audio_consumption == completed and len(runtime._pending_scenes) == 1
    runtime._wait_scene = sink.wait_scene
    runtime._drain()
    assert runtime.audio_consumption["scene_tick"] == 1
    runtime.stop()


def test_schema3_json_does_not_coerce_boolean_ticks_or_seed():
    import json
    from pynq_multimodal_game.game_testing import GameTestCase
    payload = {"schema_version": 3, "test_id": "strict", "name": "Strict", "seed": 0,
               "max_ticks": 1, "events": [{"tick": 0, "kind": "voice", "event_id": "edge", "voice_events": ["attack"]}]}
    for field in ("seed", "event"):
        invalid = json.loads(json.dumps(payload))
        if field == "seed":
            invalid["seed"] = True
        else:
            invalid["events"][0]["tick"] = True
        with pytest.raises(ValueError, match="integers"):
            GameTestCase.from_json(json.dumps(invalid))