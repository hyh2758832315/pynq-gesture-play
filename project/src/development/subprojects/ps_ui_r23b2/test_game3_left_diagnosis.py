"""Reproduce left movement loss using the deployed R39 package, without I/O.

Run with PYTHONPATH=subprojects/ps_ui_r23b2/python;.:
  .venv/Scripts/python.exe -B -m pytest -q this_file
Output: assertions; next correlate edge loss versus world boundary with user.
"""
from pathlib import Path

from pynq_multimodal_game.game_runner import GameRunner
from pynq_multimodal_game.game_sdk import GameInput, HandGesture
from subprojects.ps_ui_r23b2.test_game_input_pause_diagnosis import load
from pynq_multimodal_game.button_osd import ObservationHub
from handoffs.gesture_vision_v61.runtime.gesture_control import GestureControl


ROOT = Path(__file__).resolve().parents[2]
PACKAGE = ROOT/'build/ps-ui-r39-button-controls-20261026-board-candidate-r26/seed_games/game3.vvg'
GameVisionInputProvider = load('pynq_multimodal_game.r39_diagnostic_input',
    PACKAGE.parents[1]/'python/pynq_multimodal_game/vision_input.py').GameVisionInputProvider


def publish(provider, control, hub, frame, now, *, edge=False, stable='5', centroid=(120, 180)):
    observed = dict(centroid=centroid, bbox=(0 if edge else 60, 60, 200, 290),
                    stable=stable, code=stable, rps={'5':'PAPER','0':'ROCK'}.get(stable, 'UNKNOWN'),
                    touches_roi=edge, error=None)
    packet = dict(run_id='camera', frame=frame, server_age_ms=10,
                  stable=stable, rps=observed['rps'], control=control.update(observed, frame, now),
                  ui_pointer=dict(schema='menu-pointer-v1', u=(centroid[0]-319.5)/320.,
                                  v=(centroid[1]-179.5)/180.))
    provider.publish(packet)
    hub.publish(observed, run_id='camera', config_epoch='default', frame_id=frame,
                observed_ns=int(now*1e9))
    return provider.sample_for_game('game3', tick_id=frame)[0]


def selected(runner):
    runner.step(GameInput(0, 0, True, -1., 0., 1, True, hand_gesture=HandGesture.FIST))
    return runner._plugin._game


def test_unknown_classification_by_itself_does_not_stop_left_movement():
    now = [100.]
    provider, control, hub = GameVisionInputProvider(clock=lambda:now[0]), GestureControl(), ObservationHub()
    with GameRunner(PACKAGE, render_rgb=False) as runner:
        game = selected(runner)
        game.x = 120*64  # Well clear of the starting boundary and obstacles.
        for frame, stable in enumerate(('5','PENDING','5','PENDING','5'), 1):
            now[0] += .1
            value = publish(provider, control, hub, frame, now[0], stable=stable)
            before = game.x
            runner.step(value)
            assert value.hand_valid and value.hand_x < -.35
            assert game.x < before


def test_frame_edge_rejection_stops_left_movement_while_marker_remains_present():
    now = [100.]
    provider, control, hub = GameVisionInputProvider(clock=lambda:now[0]), GestureControl(), ObservationHub()
    with GameRunner(PACKAGE, render_rgb=False) as runner:
        game = selected(runner)
        game.x = 120*64
        for frame in range(1, 13):
            now[0] += .1
            value = publish(provider, control, hub, frame, now[0], edge=frame >= 4)
            runner.step(value)
            assert hub.hand.valid
            if frame >= 4:
                assert not value.hand_valid and value.hand_x == 0.
        stopped = game.x
        now[0] += .1
        runner.step(publish(provider, control, hub, 13, now[0], edge=True))
        assert game.x == stopped and game.vx == 0
        now[0] += .1
        runner.step(publish(provider, control, hub, 14, now[0], edge=False))
        assert game.x < stopped


def test_world_left_boundary_clamps_position_even_with_continuous_valid_left_input():
    with GameRunner(PACKAGE, render_rgb=False) as runner:
        game = selected(runner)
        for tick in range(1, 35):
            runner.step(GameInput(tick, tick*1_000_000_000//60, True, -.8, 0., 0, False))
        assert game.x == 0 and game.facing == -1
