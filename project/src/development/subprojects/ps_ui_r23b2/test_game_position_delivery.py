"""Exercise real controller -> provider -> game adapters, without board I/O.

Run: .venv/Scripts/python.exe -B -m pytest -q this_file
Set PYTHONPATH=subprojects/ps_ui_r23b2/python;. first.
Output: pytest assertions; next run source freshness and menu regressions.
"""
import pytest

from subprojects.ps_ui_r23b2.test_game_input_pause_diagnosis import ROOT, load
from subprojects.ps_ui_r23b2.test_latest_vision_order import packet
from pynq_multimodal_game.vision_input import GameVisionInputProvider


def adapters():
    return (load('position_game1', ROOT / 'subprojects/ps_ui_r23b2/game_overrides/game1_input_adapter.py').Game1InputAdapter(),
            load('position_game3', ROOT / 'subprojects/ps_ui_r23b2/game_overrides/game3_input_adapter.py'))


def positioned(frame, x, y):
    value = packet(frame)
    value['control'].update(direction='UP', u=x, v=y, smooth_uv=[x, y])
    # Menu/OSD coordinates are a separate consumer and must not overwrite games.
    value['ui_pointer'].update(u=-.9, v=.9)
    return value


@pytest.mark.parametrize('x,expected', [(.55, 1), (-.55, -1)])
def test_diagonal_hand_keeps_horizontal_movement_and_does_not_raise_center_shield(x, expected):
    control = load('position_controller', ROOT / 'handoffs/gesture_vision_v61/runtime/gesture_control.py').GestureControl()
    result = dict(centroid=(319.5+x*320, 179.5-.8*180), code='5', stable='5', rps='PAPER')
    value = positioned(1, x, -.8)
    value['control'] = control.update(result, 1, 100.)
    assert value['control']['direction'] == 'UP'
    source = GameVisionInputProvider(clock=lambda: 100.)
    source.publish(value)
    sample, receipt = source.sample_for_game('game3', tick_id=1)
    first, third = adapters()
    assert third.adapt(sample).direction == expected
    assert not first.adapt(sample).shield
    assert (sample.hand_x, sample.hand_y) == pytest.approx((x, -.8))
    assert receipt['hand_x'] == sample.hand_x


@pytest.mark.parametrize('method', ['sample', 'sample_with_receipt', 'sample_for_game'])
def test_all_game_entry_points_keep_same_coordinates(method):
    source = GameVisionInputProvider(clock=lambda: 100.)
    source.publish(positioned(1, .6, -.8))
    call = getattr(source, method)
    value = call('arbitrary-game', tick_id=1) if method == 'sample_for_game' else call(tick_id=1)
    sample = value if method == 'sample' else value[0]
    assert (sample.hand_x, sample.hand_y) == (.6, -.8)


def test_late_duplicate_and_ui_pointer_cannot_replace_game_coordinates():
    source = GameVisionInputProvider(clock=lambda: 100.)
    source.publish(positioned(2, .6, -.8))
    source.publish(positioned(1, -.9, .9))
    source.publish(positioned(2, -.7, .7))
    sample = source.sample(tick_id=1)
    assert (sample.hand_x, sample.hand_y) == (.6, -.8)
    assert source.peek_menu_control().hand_x == -.9


@pytest.mark.parametrize('boundary', ['hard_invalid', 'stale', 'suspend', 'release', 'new_run'])
def test_position_never_survives_invalidity_or_session_boundary(boundary):
    now = [100.]
    source = GameVisionInputProvider(clock=lambda: now[0])
    source.publish(positioned(1, .6, -.8))
    if boundary == 'hard_invalid':
        value = packet(2, valid=False)
        value['control']['reason'] = 'ERROR'
        source.publish(value)
    elif boundary == 'stale':
        now[0] += 2
    elif boundary == 'new_run':
        value = packet(1, run='next', valid=False)
        source.publish(value)
    else:
        getattr(source, boundary)()
    sample = source.sample(tick_id=1)
    assert not sample.hand_valid
    assert (sample.hand_x, sample.hand_y) == (0., 0.)


def test_legacy_direction_only_packets_still_work():
    value = packet(1)
    for name in ('smooth_uv', 'u', 'v'):
        value['control'].pop(name)
    source = GameVisionInputProvider(clock=lambda: 100.)
    source.publish(value)
    sample = source.sample(tick_id=1)
    assert (sample.hand_x, sample.hand_y) == (1., 0.)


@pytest.mark.parametrize('point', [[float('nan'), 0.], [2., 0.], [True, 0.], ['bad', 0.], [0.]])
def test_malformed_declared_coordinates_do_not_manufacture_a_direction(point):
    value = positioned(1, .6, -.8)
    value['control']['smooth_uv'] = point
    source = GameVisionInputProvider(clock=lambda: 100.)
    source.publish(value)
    sample = source.sample(tick_id=1)
    assert not sample.hand_valid
    assert (sample.hand_x, sample.hand_y) == (0., 0.)
