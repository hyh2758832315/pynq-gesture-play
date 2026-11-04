import importlib.util
from pathlib import Path
import sys

import pytest

from pynq_multimodal_game.game_package import GamePackageBuilder
from pynq_multimodal_game.game_runner import GameRunner
from pynq_multimodal_game.game_sdk import GameInput, VolumeSignal


ROOT = Path(__file__).resolve().parents[1]


@pytest.fixture
def volume_builder(monkeypatch):
    monkeypatch.setattr(sys, "dont_write_bytecode", True)
    spec = importlib.util.spec_from_file_location("volume_variant_builder", ROOT / "candidates/volume-v1/build.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


@pytest.fixture
def stage_project(volume_builder):
    return volume_builder.stage_project


def signal(sequence, kind):
    return VolumeSignal("a" * 32, 1, sequence, kind, sequence * 977, sequence)


def sample(tick, volume=None):
    return GameInput(tick, tick * 1_000_000_000 // 60, False, 0, 0, 0, False, volume=volume)


def test_game1_volume_shield_is_36_ticks_and_attack_retains_cooldown(stage_project, tmp_path):
    project = stage_project("game1", tmp_path / "project")
    package = GamePackageBuilder().build(project, tmp_path / "volume.vvg")
    assert package.manifest.sdk_minor == 3
    assert package.manifest.target_build_id == 0xC0060C00
    assert package.manifest.volume_inputs.vision_mapping == "game1"
    events = {0: signal(1, "SOFT"), 1: signal(2, "LOUD"), 2: signal(3, "LOUD"), 37: signal(4, "LOUD")}
    with GameRunner(package.path, render_rgb=False) as runner:
        snapshots = [runner.step(sample(tick, events.get(tick))).snapshot for tick in range(38)]
    assert all(frame.values["shield_active"] for frame in snapshots[:36])
    assert snapshots[0].values["volume_shield_ticks_remaining"] == 36
    assert not snapshots[36].values["shield_active"]
    assert snapshots[36].values["volume_shield_ticks_remaining"] == 0
    assert snapshots[0].values["shield_energy"] > snapshots[35].values["shield_energy"]
    assert snapshots[1].values["attacks_fired"] == snapshots[2].values["attacks_fired"] == 1
    assert snapshots[37].values["attacks_fired"] == 2
    assert snapshots[3].values["volume_event_kind"] is None


def test_game1_volume_duplicate_does_not_extend_shield_and_new_run_is_clean(stage_project, tmp_path):
    package = GamePackageBuilder().build(stage_project("game1", tmp_path / "project"), tmp_path / "volume.vvg")
    event = signal(1, "SOFT")
    with GameRunner(package.path, render_rgb=False) as runner:
        for tick in range(37):
            frame = runner.step(sample(tick, event if tick < 2 else None))
            if tick == 1:
                assert frame.snapshot.values["volume_event_kind"] is None
                assert frame.snapshot.values["volume_shield_ticks_remaining"] == 35
        assert not frame.snapshot.values["shield_active"]
    with GameRunner(package.path, render_rgb=False) as runner:
        assert not runner.step(sample(0)).snapshot.values["shield_active"]


@pytest.fixture
def volume_platform(stage_project, monkeypatch):
    spec = importlib.util.spec_from_file_location("games.game3.src.volume_main", ROOT / "candidates/volume-v1/game3_main.py")
    module = importlib.util.module_from_spec(spec)
    monkeypatch.setitem(sys.modules, spec.name, module)
    spec.loader.exec_module(module)
    from games.game3.src.input_adapter import Command
    from games.game3.src.level import Block, SCALE
    return module.VolumePlatformGame, Command, Block, SCALE


def test_game3_volume_gate_requires_nearby_loud_and_opens_once(volume_platform):
    game_type, command_type, _, scale = volume_platform
    game = game_type()
    game.step_volume(0, command_type(jump=True), signal(1, "LOUD"))
    assert not game.gate_open and game.volume_effect is None
    game.step_volume(1, command_type(), signal(2, "LOUD"))
    assert not game.gate_open
    game.x = 730 * scale
    game.step_volume(2, command_type(), signal(3, "SOFT"))
    assert not game.gate_open
    game.step_volume(3, command_type(), signal(4, "LOUD"))
    assert game.gate_open and game.note_hits == 1 and game.volume_effect == "gate-open"
    game.step_volume(4, command_type(), signal(4, "LOUD"))
    game.step_volume(5, command_type(), signal(5, "LOUD"))
    assert game.note_hits == 1 and game.volume_effect is None


@pytest.mark.parametrize("direction,character", [(-1, "male"), (1, "female")])
def test_game3_soft_runs_one_full_lift_cycle_and_carries_both_characters(volume_platform, direction, character):
    game_type, command_type, _, scale = volume_platform
    game = game_type()
    game.step_volume(0, command_type(direction, True), None)
    game.x = 1004 * scale
    game.step_volume(1, command_type(), signal(1, "LOUD"))
    assert game.character == character and game.support == "lift" and game.lift_phase == "IDLE"
    effects, phases, heights = [], [], []
    for tick in range(2, 450):
        event = signal(2, "SOFT") if tick in (2, 50) else signal(3, "SOFT") if tick == 150 else None
        game.step_volume(tick, command_type(), event)
        effects.append(game.volume_effect)
        phases.append(game.lift_phase)
        heights.append(game.lift_y)
        assert game.support == "lift" and game.y + 20 * scale == game.lift_y
    assert effects.count("lift-start") == 1
    assert {"RISING", "HOLDING", "DESCENDING", "IDLE"} <= set(phases)
    assert heights.count(64 * scale) == 121
    assert game.lift_y == 144 * scale and game.lift_phase == "IDLE"
    assert game.health == 3 and game.status == "RUNNING"


def test_game3_volume_lift_retains_ceiling_crush_protection(volume_platform, monkeypatch):
    game_type, command_type, block_type, scale = volume_platform
    game = game_type()
    game.step_volume(0, command_type(jump=True), None)
    game.x = 1004 * scale
    game.step_volume(1, command_type(), None)
    original_solids = game.solids
    ceiling = block_type(1000 * scale, 112 * scale, 32 * scale, 12 * scale)
    monkeypatch.setattr(game, "solids", lambda: original_solids() + [("ceiling", ceiling)])
    game.step_volume(2, command_type(), signal(1, "SOFT"))
    assert game.lift_y == 144 * scale and game.y == 124 * scale
    assert game.lift_phase == "RISING" and game.health == 3


def test_game3_volume_package_is_deterministic_and_preserves_selection(stage_project, tmp_path):
    project = stage_project("game3", tmp_path / "project")
    builder = GamePackageBuilder()
    first = builder.build(project, tmp_path / "first.vvg")
    second = builder.build(project, tmp_path / "second.vvg")
    assert first.path.read_bytes() == second.path.read_bytes()
    assert first.manifest.volume_inputs.vision_mapping == "game3"
    assert first.manifest.target_build_id == 0xC0060C00
    for direction, character in ((-1, "male"), (1, "female")):
        with GameRunner(first.path, render_rgb=False) as runner:
            selected = runner.step(GameInput(0, 0, True, direction, 0, 1, True)).snapshot
            assert selected.status == "RUNNING" and selected.values["character"] == character
            frame = runner.step(sample(1, signal(1, "LOUD")))
            assert not frame.snapshot.values["gate_open"] and frame.snapshot.values["volume_effect"] is None


@pytest.mark.parametrize("game_id,character", [("game1", None), ("game3", "male"), ("game3", "female")])
def test_volume_schema4_asserted_routes_match_real_package_twice(volume_builder, tmp_path, game_id, character):
    from pynq_multimodal_game.game_testing import GameTestCase
    from pynq_multimodal_game.game_validation import run_game_test

    project = volume_builder.stage_project(game_id, tmp_path / "project")
    package = GamePackageBuilder().build(project, tmp_path / "volume.vvg")
    case = volume_builder.shield_case() if game_id == "game1" else volume_builder.platform_case(package.path, character)
    assert case.schema_version == 4 and GameTestCase.from_json(case.to_json()) == case
    first, second = run_game_test(package.path, case), run_game_test(package.path, case)
    assert first.passed, first.to_dict()
    assert second.passed, second.to_dict()
    assert first.frames == second.frames
    assert len(first.frames) == case.max_ticks + 1


@pytest.mark.parametrize("kind", ["SOFT", "LOUD"])
@pytest.mark.parametrize("fail_submission", [False, True])
def test_nonempty_volume_effect_requires_matching_real_scene_completion(stage_project, tmp_path, kind, fail_submission):
    from dataclasses import asdict
    import time
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from test_game_testing import _TicketSink

    class Sink(_TicketSink):
        fail = False

        def wait_scene(self, ticket):
            if self.fail:
                raise RuntimeError("real volume scene completion failed")
            super().wait_scene(ticket)

    package = GamePackageBuilder().build(stage_project("game1", tmp_path / "project"), tmp_path / "volume.vvg")
    event = signal(1, kind)
    game_input = sample(1, event)
    expires = time.monotonic() + 0.1
    with GameRunner(package.path, render_rgb=False) as runner:
        neutral = runner.step(sample(0))
        frame = runner.step(game_input)
    source = {"signal": asdict(event), "sample_tick": 1, "hardware_acked": True,
              "disposition": "consumed", "expires": expires}
    receipt = {"schema": "volume-input-receipt-v1", "game_run": "b" * 32, "sample_tick": 1,
               "sample_timestamp_ns": game_input.timestamp_ns, "signal": asdict(event), "hardware_acked": True,
               "logic_consumed": True, "source_receipt": source}
    runtime = PackagedGameRuntime(package.path, Sink())
    runtime._manifest, runtime._game_run, runtime._live_input = package.manifest, "b" * 32, object()
    try:
        runtime._submit(neutral, require_resources=True)
        runtime._sink.fail = fail_submission
        assert runtime._validate_actions(game_input, receipt) == (game_input, receipt)
        runtime._submit(frame, audio_receipt=receipt)
        assert runtime.volume_consumption is None and runtime.presented_frames == 1
        if fail_submission:
            with pytest.raises(RuntimeError, match="real volume scene completion failed"):
                runtime._drain()
            assert runtime.volume_consumption is None and runtime.presented_frames == 1
        else:
            runtime._drain()
            completed = runtime.volume_consumption
            assert completed["signal"] == asdict(event) and completed["scene_tick"] == 1
            assert completed["scene_sha256"] == frame.scene_sha256
            assert completed["sink_completion"] == "confirmed" and completed["logic_executed"] is True
            assert completed["game_effects"]["shield_active"] is (kind == "SOFT")
            assert completed["game_effects"]["attacks_fired"] == int(kind == "LOUD")
            assert runtime.audio_consumption is None
    finally:
        runtime._preview.stop()