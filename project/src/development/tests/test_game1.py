import math
from pathlib import Path
from zipfile import ZipFile

from pynq_multimodal_game.c1_adapter import (
    C1_FINAL_STATE_SHA256,
    c1_replay_to_test_case,
)
from pynq_multimodal_game.game_package import GamePackageBuilder
from pynq_multimodal_game.game_runner import GameRunner
from pynq_multimodal_game.game_sdk import GameInput, ToneSignal
from pynq_multimodal_game.game_testing import InputKind


ROOT = Path(__file__).resolve().parents[1]


def test_game1_all_gestures_control_position_and_only_fist_jumps(monkeypatch) -> None:
    import importlib.util
    import sys
    from pynq_multimodal_game.controls import Direction
    from pynq_multimodal_game.game_sdk import GestureState, HandGesture

    spec = importlib.util.spec_from_file_location("game1_input_adapter", ROOT / "games/game1/src/input_adapter.py")
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    monkeypatch.setattr(sys, "dont_write_bytecode", True)
    spec.loader.exec_module(module)
    adapter = module.Game1InputAdapter()
    state = GestureState()
    for tick, gesture in enumerate((HandGesture.PAPER, HandGesture.SCISSORS, HandGesture.FIST, HandGesture.FIST, None)):
        state.update(gesture)
        command = adapter.adapt(GameInput.from_logical_position(
            tick_id=tick, timestamp_ns=0, x=319, y=90, **state.consume(),
        ))
        assert command.direction is Direction.RIGHT
        assert command.jump is (tick in (2, 3))
    audio = adapter.adapt(GameInput.from_logical_position(
        tick_id=5, timestamp_ns=0, x=319, y=90, hand_gesture=HandGesture.SCISSORS,
        tone=ToneSignal(1, 1200, True, started=True),
    ))
    assert audio.attack and not audio.jump and audio.direction is Direction.RIGHT
    invalid = adapter.adapt(GameInput(6, 0, False, 0, 0, 1, True, hand_gesture=HandGesture.FIST))
    assert not invalid.jump and invalid.direction is Direction.IDLE


def test_c1_replay_conversion_is_deterministic() -> None:
    first = c1_replay_to_test_case(ROOT / "data/replays/c1_demo_controls.jsonl")
    second = c1_replay_to_test_case(ROOT / "data/replays/c1_demo_controls.jsonl")

    assert first.to_json() == second.to_json()
    assert first.max_ticks == 329
    assert [event.tick for event in first.events if "attack" in event.event_id] == [
        30,
        85,
        150,
        215,
        280,
    ]
    assert [event.tick for event in first.events if "shield" in event.event_id] == [145, 151]


def test_game1_package_build_is_deterministic(tmp_path: Path) -> None:
    builder = GamePackageBuilder()
    first = builder.build(ROOT / "games/game1", tmp_path / "first.vvg")
    second = builder.build(ROOT / "games/game1", tmp_path / "second.vvg")

    assert first.sha256 == second.sha256
    assert first.path.read_bytes() == second.path.read_bytes()


def test_game1_package_owns_content_and_uses_shared_engine(tmp_path: Path) -> None:
    package = GamePackageBuilder().build(
        ROOT / "games/game1", tmp_path / "game1.vvg"
    )
    expected_sources = {
        "src/assets.py",
        "src/input_adapter.py",
        "src/level.py",
        "src/main.py",
        "src/scene_builder.py",
        "src/snapshot.py",
    }

    assert expected_sources <= set(package.files)
    with ZipFile(package.path) as archive:
        source = b"\n".join(archive.read(name) for name in sorted(expected_sources))

    assert b"pynq_multimodal_game.engine.side_scroller" in source
    assert b"pynq_multimodal_game.demo" not in source
    assert b"pynq_multimodal_game.game import" not in source
    assert b"pynq_multimodal_game.c1_adapter" not in source


def test_game1_legacy_input_runs_in_extended_five_life_level(tmp_path: Path) -> None:
    test_case = c1_replay_to_test_case(ROOT / "data/replays/c1_demo_controls.jsonl")
    package = GamePackageBuilder().build(
        ROOT / "games/game1", tmp_path / "game1.vvg"
    )
    x, y = 160, 90
    fist_sequence = 0
    tone_frequency = 0.0
    tone_ticks = 0
    tone_total = 0
    tone_sequence = 0

    with GameRunner(package.path) as runner:
        final = None
        for tick in range(test_case.max_ticks + 1):
            fist = False
            for event in test_case.events_at(tick):
                if event.kind in (InputKind.HAND, InputKind.FIST):
                    assert event.x is not None and event.y is not None
                    x, y = event.x, event.y
                    fist = event.kind is InputKind.FIST
                    fist_sequence += int(fist)
                elif event.kind is InputKind.TONE:
                    assert event.frequency_hz is not None and event.duration_ms is not None
                    tone_frequency = event.frequency_hz
                    tone_ticks = max(1, math.ceil(event.duration_ms * 60 / 1000.0))
                    tone_total = tone_ticks
                    tone_sequence += 1
            tone = None
            if tone_ticks > 0:
                tone = ToneSignal(
                    sequence=tone_sequence,
                    frequency_hz=tone_frequency,
                    active=True,
                    started=tone_ticks == tone_total,
                )
                tone_ticks -= 1
            elif tone_total > 0:
                tone = ToneSignal(
                    sequence=tone_sequence,
                    frequency_hz=tone_frequency,
                    active=False,
                    ended=True,
                )
                tone_total = 0
            final = runner.step(
                GameInput.from_logical_position(
                    tick_id=tick,
                    timestamp_ns=tick * 16_666_667,
                    x=x,
                    y=y,
                    fist_sequence=fist_sequence,
                    fist_event=fist,
                    tone=tone,
                )
            )

    assert final is not None
    assert final.snapshot.status == "RUNNING"
    assert final.snapshot.values is not None
    assert final.snapshot.values["health"] > 0
    assert len(final.rgb) == 320*180*3


def test_timed_candidate_real_projectiles_scene_and_five_second_guard(tmp_path):
    from dataclasses import replace
    from pynq_multimodal_game.engine.side_scroller import GameConfig, GameEngine
    from pynq_multimodal_game.game_sdk import GameContext
    from test_game_voice_policy import make_policy, sample
    package = GamePackageBuilder().build(ROOT / "candidates/game1-voice-s2", tmp_path / "candidate.vvg")
    repeated = GamePackageBuilder().build(ROOT / "candidates/game1-voice-s2", tmp_path / "repeat.vvg")
    assert package.sha256 == repeated.sha256
    policy = make_policy()
    with GameRunner(package.path, render_rgb=False, game_run="test-run") as runner:
        runner._plugin._engine = GameEngine(GameConfig(action_mode="policy_timed"))
        runner._plugin.reset(GameContext(seed=0, tick_hz=60))
        times = (0, 490_000_000, 500_000_000, 1_000_000_000, 5_999_999_999, 6_000_000_000)
        for tick, now in enumerate(times):
            events = [(tick + 1, "attack" if tick < 3 else "shield_on")] if tick < 4 else ()
            result = sample(policy, tick, now, events, packet=tick if tick < 4 else None)
            if tick == 3:
                runner._plugin._state = replace(runner._plugin._state, shield_energy=0)
            frame = runner.step(GameInput(tick, now, True, 0, 0, 0, False, actions=result.frame))
            scene = runner._plugin.build_scene()
            values = frame.snapshot.values
            assert values["player_projectiles"] == (1 if tick < 2 else 2)
            assert sum(sprite.atlas_x in (64, 72, 80, 88) for sprite in scene.sprites) == values["player_projectiles"]
            assert any(sprite.atlas_x == 96 for sprite in scene.sprites) is (tick in (3, 4))
            if tick == 3:
                assert values["guard_remaining_ns"] == 5_000_000_000 and scene.hud.shield_energy == 5000
                assert values["shield_energy"] == 0 and values["shield_active"]
            if tick == 5:
                assert not values["shield_active"] and values["guard_remaining_ns"] == 0