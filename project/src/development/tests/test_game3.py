from pathlib import Path
import sys

import pytest

from collision import Poly, Vector, collide


ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "games/game3"


def test_collision_library_overlap_and_touch_contract() -> None:
    player = Poly.from_box(Vector(6, 9), 12, 18)
    floor = Poly.from_box(Vector(20, 28), 40, 16)
    assert not collide(player, floor)
    player.pos.y = 12
    assert collide(player, floor)


@pytest.fixture
def rules(monkeypatch):
    monkeypatch.setattr(sys, "dont_write_bytecode", True)
    from games.game3.src.rules import PlatformGame, overlaps
    from games.game3.src.input_adapter import Command
    from games.game3.src.level import Block, SCALE
    return PlatformGame, Command, Block, SCALE, overlaps


def test_character_selection_consumes_confirmation_without_jump(rules):
    game_type, command_type, _, scale, _ = rules
    for direction, character in ((-1, "male"), (1, "female")):
        game = game_type()
        game.step(0, command_type(direction, True))
        assert game.status == "RUNNING" and game.character == character
        assert game.y == 124 * scale and game.vy == 0
        game.step(1, command_type())
        assert game.grounded


def test_platform_consumes_native_selection_confirmation_and_new_jump(tmp_path):
    from handoffs.gesture_vision_v61.runtime.gesture_control import GestureControl
    from pynq_multimodal_game.game_package import GamePackageBuilder
    from pynq_multimodal_game.game_runner import GameRunner
    from pynq_multimodal_game.vision_input import GameVisionInputProvider

    package = GamePackageBuilder().build(PROJECT, tmp_path / "native-platform.vvg",
                                        target_build_id=0xC0060800)
    now = [1.0]
    provider = GameVisionInputProvider(clock=lambda: now[0])
    controller = GestureControl()
    snapshots = []
    with GameRunner(package.path, render_rgb=False) as runner:
        for tick, stable in enumerate(("5", "5", "0", "5", "0", "0")):
            now[0] += 0.2
            observed = {"centroid": [540, 179], "code": stable, "stable": stable,
                        "rps": {"5": "PAPER", "0": "ROCK"}[stable]}
            control = controller.update(observed, tick + 1, now[0])
            provider.publish({"run_id": "native", "server_age_ms": 0, "control": control,
                              "frame": tick + 1, "stable": stable, "rps": observed["rps"]})
            sample, receipt = provider.sample_for_game("game3", tick_id=tick)
            assert sample.hand_y == 0 and receipt["game_id"] == "game3"
            snapshots.append(runner.step(sample).snapshot)
    assert snapshots[0].status == "SELECT" and snapshots[0].values["character"] == "female"
    assert snapshots[2].status == "RUNNING" and snapshots[2].values["vy"] == 0
    assert snapshots[4].values["vy"] < 0
    assert snapshots[4].values["x"] > snapshots[2].values["x"]


def test_held_fist_repeats_jump_after_landing_without_resetting_air_velocity(rules):
    from games.game3.src.input_adapter import adapt
    from pynq_multimodal_game.game_sdk import GameInput, HandGesture

    game_type, _, _, scale, _ = rules
    game = game_type()
    game.step(0, adapt(GameInput(0, 0, True, 0, 0, 1, True,
                               hand_gesture=HandGesture.FIST, gesture_sequence=1)))
    assert game.status == "RUNNING" and game.y == 124 * scale and game.vy == 0
    jumps = 0
    for tick in range(1, 141):
        previous_grounded, previous_velocity = game.grounded, game.vy
        command = adapt(GameInput(tick, tick / 60, True, 0, 0, 1, False,
                                  hand_gesture=HandGesture.FIST, gesture_sequence=1))
        assert command.jump_held and not command.jump
        game.step(tick, command)
        if previous_grounded:
            assert game.vy == -416
            jumps += 1
        elif previous_velocity < 0:
            assert game.vy == previous_velocity + 24
    assert jumps >= 3


def test_real_vision_classification_confirms_and_repeats_without_heuristic_pulses(tmp_path):
    from pynq_multimodal_game.game_package import GamePackageBuilder
    from pynq_multimodal_game.game_runner import GameRunner
    from pynq_multimodal_game.game_sdk import HandGesture
    from pynq_multimodal_game.vision_input import GameVisionInputProvider

    package = GamePackageBuilder().build(PROJECT, tmp_path / "classified-platform.vvg",
                                        target_build_id=0xC0060C00)
    now = [1.0]
    provider = GameVisionInputProvider(clock=lambda: now[0])
    launches = 0
    previous = None
    with GameRunner(package.path, render_rgb=False) as runner:
        for tick in range(141):
            now[0] += 0.05
            provider.publish({"run_id": "classified", "server_age_ms": 0,
                              "frame": tick + 1, "stable": "0", "rps": "ROCK",
                              "control": {"schema": "gesture-control-v1", "frame_id": tick + 1,
                                          "action_event_seq": 0, "action_event": False,
                                          "valid": True, "direction": "IDLE"}})
            sample, receipt = provider.sample_for_game("game3", tick_id=tick)
            assert sample.hand_gesture is HandGesture.FIST and sample.fist_event is (tick == 0)
            assert receipt["source_hand_gesture"] == receipt["hand_gesture"] == "fist"
            snapshot = runner.step(sample).snapshot
            assert snapshot.status == "RUNNING"
            if tick == 0:
                assert snapshot.values["vy"] == 0 and snapshot.values["world_y"] == 124
            elif previous.values["grounded"]:
                assert snapshot.values["vy"] == -416
                launches += 1
            previous = snapshot
    assert launches >= 3


@pytest.mark.parametrize("valid,gesture", [(False, "fist"), (True, "paper"),
                                          (True, "scissors"), (True, None)])
def test_held_jump_requires_a_valid_current_fist(rules, valid, gesture):
    from games.game3.src.input_adapter import adapt
    from pynq_multimodal_game.game_sdk import GameInput, HandGesture

    game_type, command_type, _, _, _ = rules
    game = game_type()
    game.step(0, command_type(jump=True))
    for tick in range(1, 15):
        command = adapt(GameInput(tick, tick / 60, valid, 0, 0, 1, False,
                                  hand_gesture=HandGesture(gesture) if gesture else None))
        assert not command.jump and not command.jump_held
        game.step(tick, command)
        assert game.grounded


def test_held_fist_without_new_edge_confirms_character_selection(rules):
    from games.game3.src.input_adapter import adapt
    from pynq_multimodal_game.game_sdk import GameInput, HandGesture

    game_type, _, _, _, _ = rules
    game = game_type()
    game.step(0, adapt(GameInput(0, 0, True, 0, 0, 1, False,
                               hand_gesture=HandGesture.FIST, gesture_sequence=1)))
    assert game.status == "RUNNING" and game.vy == 0


def test_jump_lands_on_platform_and_bumps_reward_once(rules):
    game_type, command_type, _, scale, _ = rules
    game = game_type()
    game.step(0, command_type(jump=True))
    game.x = 146 * scale
    game.step(1, command_type(jump=True))
    for tick in range(2, 80):
        game.step(tick, command_type())
    assert game.head_bumps == 1 and game.score == 10
    assert game.grounded and game.y == 124 * scale
    game.x, game.y, game.vy = 584 * scale, 72 * scale, 180
    for tick in range(80, 100):
        game.step(tick, command_type())
    assert game.grounded and game.y == 92 * scale


def test_exact_touch_is_not_penetration_and_pit_is_fatal(rules):
    game_type, command_type, block_type, scale, overlaps = rules
    assert not overlaps(block_type(0, 0, 12, 20), block_type(0, 20, 40, 16))
    assert overlaps(block_type(0, 0, 12, 21), block_type(0, 20, 40, 16))
    game = game_type()
    game.step(0, command_type(jump=True))
    game.x = 400 * scale
    for tick in range(1, 60):
        game.step(tick, command_type())
    assert game.status == "RUNNING" and game.health == 4 and game.falls == 1
    assert game.x < 400*scale and game.invulnerable>0


def test_package_builds_and_both_characters_have_distinct_pixels(tmp_path):
    from pynq_multimodal_game.game_package import GamePackageBuilder
    from pynq_multimodal_game.game_runner import GameRunner
    from pynq_multimodal_game.game_sdk import GameInput

    package = GamePackageBuilder().build(PROJECT, tmp_path / "game3.vvg")
    images = []
    for direction, character in ((-1, "male"), (1, "female")):
        with GameRunner(package.path) as runner:
            selector = runner.step(GameInput(0, 0, True, direction, 0, 0, False))
            assert selector.snapshot.status == "SELECT"
            assert selector.snapshot.values["character"] == character
            frame = runner.step(GameInput(1, 1, True, 0, 0, 1, True))
            assert frame.snapshot.status == "RUNNING"
            assert frame.command_count <= 36 and len(frame.rgb) == 320 * 180 * 3
            images.append(frame.rgb)
    assert images[0] != images[1]


def test_switch_requires_landing_and_ignores_tone(rules):
    from pynq_multimodal_game.game_sdk import ToneSignal
    G,C,_,S,_=rules
    game=G();game.step(0,C(jump=True));game.x=736*S
    for tick in range(1,10):game.step(tick,C(tone=ToneSignal(1,220,True)))
    assert not game.gate_open
    game.step(10,C(jump=True))
    for tick in range(11,65):game.step(tick,C())
    assert game.gate_open and game.note_hits==1


def test_lift_position_carries_holds_and_down_passes_through(rules):
    G,C,_,S,_=rules
    game=G();game.step(0,C(jump=True));game.x=1004*S;game.step(1,C())
    assert game.support=='lift'
    for tick in range(2,110):game.step(tick,C(vertical=-1))
    assert game.lift_y==64*S and game.y+20*S==game.lift_y
    for tick in range(110,130):game.step(tick,C())
    assert game.lift_y==64*S
    game.y=124*S;game.grounded=True;game.support=None
    for tick in range(130,350):game.step(tick,C(vertical=1))
    assert game.lift_y==144*S and game.y==124*S
    assert game.health==5


def test_stomp_requires_downward_top_crossing_and_damage_has_grace(rules):
    game_type, command_type, _, scale, _ = rules
    game = game_type()
    game.step(0, command_type(jump=True))
    game.x, game.y, game.vy = game.enemies[0].x, 100 * scale, 256
    game.grounded = False
    for tick in range(1, 4):
        game.step(tick, command_type())
    assert game.stomps == 1 and not game.enemies[0].alive and game.vy < 0
    game = game_type()
    game.step(0, command_type(jump=True))
    game.x = game.enemies[0].x
    game.step(1, command_type())
    assert game.health == 4 and game.stomps == 0
    for tick in range(2, 10):
        game.step(tick, command_type())
    assert game.health == 4


def test_both_characters_share_physics_and_terminal_reselects(rules):
    game_type, command_type, _, scale, _ = rules
    games = [game_type(), game_type()]
    for game, direction in zip(games, (-1, 1)):
        game.step(0, command_type(direction, True))
        for tick in range(1, 40):
            game.step(tick, command_type(1, tick == 20))
    assert [(game.x, game.y, game.vx, game.vy) for game in games][0] == [(game.x, game.y, game.vx, game.vy) for game in games][1]
    game = games[0]
    game.health=1
    game.x, game.y = 410 * scale, 211 * scale
    for tick in range(40, 44):
        game.step(tick, command_type())
    assert game.status == "LOST"
    for tick in range(44, 110):
        game.step(tick, command_type(jump=tick == 109))
    assert game.status == "SELECT" and game.health == 5 and game.score == 0


def test_input_direction_is_independent_of_classification_and_invalid_hand(rules):
    from games.game3.src.input_adapter import adapt
    from pynq_multimodal_game.game_sdk import GameInput, HandGesture

    for gesture in (*HandGesture, None):
        command = adapt(GameInput(0, 0, True, 1, 0, 0, False, hand_gesture=gesture))
        assert command.direction == 1
    assert adapt(GameInput(0, 0, False, 1, 0, 1, True)).direction == 0
    assert not adapt(GameInput(0, 0, False, 1, 0, 1, True)).jump


def _level_playthrough(rules, character="female"):
    from pynq_multimodal_game.game_sdk import ToneSignal

    game_type, command_type, _, scale, _ = rules
    game = game_type()
    commands = [command_type(1 if character == "female" else -1, True)]
    game.step(0, commands[0])
    note_ticks = 0
    lift_complete = False
    milestones = {}
    for tick in range(1, 2200):
        world_x = game.x / scale
        direction, jump, tone = 1, False, None
        vertical=0
        if 1860 <= world_x < 1888 and game.grounded:jump=True
        if 378 <= world_x < 400 and game.grounded:
            jump = True
            milestones.setdefault("pit_jump", tick)
        if (530 <= world_x < 560 or 2048 <= world_x < 2080 or 2208 <= world_x < 2240) and game.grounded:
            jump = True
        if game.grounded and any(enemy.alive and -4 * scale <= enemy.x - game.x <= 48 * scale for enemy in game.enemies):
            jump = True
        if not game.gate_open and world_x >= 726:
            direction, jump = 0, game.grounded
            note_ticks += 1
            if 3 <= note_ticks <= 20:
                tone = ToneSignal(1, 220, True)
                milestones.setdefault("note_start", tick)
        if game.gate_open:
            milestones.setdefault("gate_open", tick)
        if world_x >= 1000 and not lift_complete:
            direction, jump = 0, False
            vertical=-1
            milestones.setdefault("lift_start", tick)
            if game.lift_y <= 64 * scale and game.grounded:
                lift_complete = True
                direction, jump, tone = 1, True, None
                milestones["lift_jump"] = tick
        command = command_type(direction, jump, tone, vertical=vertical)
        commands.append(command)
        game.step(tick, command)
        if game.status != "RUNNING":
            break
    return game, commands, milestones


@pytest.mark.parametrize("character", ("male", "female"))
def test_complete_level_with_real_movement_and_both_voice_mechanisms(rules, character):
    game, commands, milestones = _level_playthrough(rules, character)
    assert game.status == "WON", (vars(game), milestones)
    assert game.character == character and game.health > 0
    assert game.note_hits == 1 and game.gate_open and game.score >= 100
    assert len(commands) < 2200 and "lift_jump" in milestones


@pytest.mark.parametrize("replay", sorted((PROJECT / "tests/replays").glob("*.json")), ids=lambda path: path.stem)
def test_game3_asserted_replays_are_deterministic(tmp_path, replay):
    from pynq_multimodal_game.game_testing import GameTestCase
    from pynq_multimodal_game.game_validation import build_verified_game, run_game_test

    package = build_verified_game(PROJECT, tmp_path / "game3.vvg")
    case = GameTestCase.load(replay)
    first, second = run_game_test(package.path, case), run_game_test(package.path, case)
    assert first.passed, first.to_dict()
    assert second.passed, second.to_dict()
    assert first.frames == second.frames
    assert max(frame["command_count"] for frame in first.frames) <= 36


def test_reset_returns_to_selection_and_scene_budget_is_valid_everywhere(rules, monkeypatch):
    from games.game3.src.main import Game
    from pynq_multimodal_game.game_sdk import GameContext, GameInput
    from pynq_multimodal_game.scene_compiler import SceneCompiler

    game = Game()
    assets = game.assets()
    compiler = SceneCompiler(sprite_atlas=assets.sprite_atlas, tile_atlas=assets.tile_atlas, palettes=assets.palettes)
    game.step(GameInput(0, 0, True, 1, 0, 1, True))
    for world_x in range(0, 2548, 8):
        game._game.x = world_x * 64
        frame = compiler.compile(game.build_scene())
        assert frame.header.command_count <= 36
        assert len(game.build_scene().tile_layer.tiles) == 1600
        assert len(frame.tilemaps[0].tiles) <= 1020
    for lift_y in (64, 104, 144):
        game._game.x = 1004 * 64
        game._game.lift_y = lift_y * 64
        game._game.y = (lift_y - 20) * 64
        scene = game.build_scene()
        assert len(scene.sprites) <= 36
    snapshot = game.reset(GameContext(seed=7, tick_hz=60))
    assert snapshot.status == "SELECT" and snapshot.values["character"] == "male"
    assert game.assets() is assets


@pytest.mark.parametrize('studio', [False, True])
def test_finish_flag_base_touches_its_actual_ground(studio):
    import importlib.util
    from games.game3.src.assets import create_assets
    from games.game3.src.level import GOAL_X, GOAL_GROUND_Y, SCALE, level_blocks
    from games.game3.src.rules import PlatformGame
    from games.game3.src import scene_builder
    if studio:
        spec=importlib.util.spec_from_file_location('games.game3.src.studio_scene_builder',
            ROOT/'subprojects/ps_ui_r23b2/game_overrides/game3_scene_builder.py')
        scene_builder=importlib.util.module_from_spec(spec);spec.loader.exec_module(scene_builder)
    _, regions=create_assets();game=PlatformGame()
    game.status='RUNNING';game.x=GOAL_X*SCALE
    scene=scene_builder.build_scene(game,regions)
    ax,ay,width,height=regions['goal']
    flag=next(s for s in scene.sprites if (s.atlas_x,s.atlas_y,s.width,s.height)==(ax,ay,width,height))
    ground=next(b for b in level_blocks() if b.kind=='ground' and b.x<=flag.x<b.x+b.width)
    assert flag.y==96 and flag.y+flag.height==ground.y==GOAL_GROUND_Y


def test_lift_blocks_on_ceiling_instead_of_crushing_player(rules, monkeypatch):
    from games.game3.src import rules as rules_module
    from pynq_multimodal_game.game_sdk import ToneSignal

    game_type, command_type, block_type, scale, _ = rules
    original_blocks = rules_module.level_blocks()
    monkeypatch.setattr(rules_module, "level_blocks", lambda: (*original_blocks, block_type(992, 80, 48, 16)))
    game = game_type()
    game.step(0, command_type(jump=True))
    game.x = 1004 * scale
    game.step(1, command_type())
    for tick in range(2, 100):
        game.step(tick, command_type(vertical=-1))
    assert game.y >= 96 * scale and game.health == 5
    assert game.y + 20 * scale == game.lift_y


def test_game3_software_runtime_matches_pc_report(tmp_path):
    import threading
    import time
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from pynq_multimodal_game.game_testing import GameTestCase
    from pynq_multimodal_game.game_validation import build_verified_game, compare_test_reports, run_game_test
    from test_game2 import _Sink

    package = build_verified_game(PROJECT, tmp_path / "game3.vvg")
    case = GameTestCase.load(PROJECT / "tests/replays/kingdom-01-princess-win.json")
    pc_report = run_game_test(package.path, case)
    runtime = PackagedGameRuntime(package.path, _Sink())
    runtime.load_test_case(case)
    try:
        runtime.start()
        deadline = time.monotonic() + case.max_ticks / 60 * 3 + 12
        while not runtime.test_complete and runtime.last_error is None and time.monotonic() < deadline:
            threading.Event().wait(0.01)
        assert runtime.last_error is None and runtime.test_complete
        result = compare_test_reports(pc_report.to_dict(), runtime.test_report)
        assert result["status"] == "passed", result
        assert result["matched_ticks"] == 1501
        assert result["hardware_acceptance"] == "pending"
    finally:
        runtime.stop()
