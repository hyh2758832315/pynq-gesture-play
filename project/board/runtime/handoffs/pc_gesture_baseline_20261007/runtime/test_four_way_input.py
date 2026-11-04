from types import SimpleNamespace

import pytest

from four_way_input import FourWayVisionInputProvider
from start_4way_board_test import configure_provider
from pynq_multimodal_game.vision_input import VisionInputProvider
from pynq_multimodal_game.controls import Direction
from pynq_multimodal_game.engine.side_scroller import (
    GameConfig, SideScrollerCommand, SideScrollerEngine)


def packet(frame=1, seq=0, direction='UP', valid=True, run='four-way', age=0, action=False):
    return {'run_id': run, 'server_age_ms': age, 'control': {
        'schema': 'gesture-control-v1', 'frame_id': frame,
        'action_event_seq': seq, 'valid': valid, 'direction': direction,
        'action_event': action, 'action_kind': 'HEURISTIC_OPEN_TO_FIST'}}


@pytest.mark.parametrize('direction,x,y', [
    ('LEFT', -1, 0), ('RIGHT', 1, 0), ('UP', 0, -1),
    ('DOWN', 0, 1), ('IDLE', 0, 0)])
def test_axis_mapping_and_atomic_receipt(direction, x, y):
    provider = FourWayVisionInputProvider(clock=lambda: 1.)
    provider.publish(packet(direction=direction))
    sample, receipt = provider.sample_with_receipt(tick_id=0)
    assert sample.hand_valid
    assert (sample.hand_x, sample.hand_y) == (x, y)
    assert (receipt['hand_x'], receipt['hand_y']) == (x, y)
    assert receipt['source_direction'] == direction
    assert receipt['control_mapping'] == 'FOUR_WAY_OPEN_TO_FIST'


def test_invalid_stale_pause_resume_and_stop_zero_both_axes():
    now = [1.]
    provider = FourWayVisionInputProvider(clock=lambda: now[0])
    def neutral():
        sample = provider.sample(tick_id=0)
        assert not sample.hand_valid
        assert (sample.hand_x, sample.hand_y) == (0, 0)
        assert not sample.fist_event
    neutral()
    provider.publish(packet())
    assert provider.sample(tick_id=0).hand_y == -1
    provider.publish(packet(frame=2, valid=False))
    neutral()
    provider.publish(packet(frame=3, direction='DOWN'))
    now[0] += 1.21
    neutral()
    provider.publish(packet(frame=4))
    provider.suspend()
    neutral()
    provider.publish(packet(frame=5))
    neutral()
    provider.resume()
    neutral()
    provider.publish(packet(frame=6))
    assert provider.sample(tick_id=0).hand_y == -1
    provider.release()
    neutral()


def test_vertical_preserves_one_shot_jump_and_run_baseline():
    provider = FourWayVisionInputProvider(clock=lambda: 1.)
    provider.publish(packet())
    provider.publish(packet(frame=2, seq=1, action=True))
    sample = provider.sample(tick_id=0)
    assert sample.hand_y == -1 and sample.fist_event
    assert not provider.sample(tick_id=1).fist_event
    provider.publish(packet(frame=2, seq=1, action=True))
    assert not provider.sample(tick_id=2).fist_event
    provider.publish(packet(run='new-run', seq=8, action=True, direction='DOWN'))
    sample = provider.sample(tick_id=3)
    assert sample.hand_y == 1 and not sample.fist_event


def test_server_age_rejects_vertical_and_jump():
    provider = FourWayVisionInputProvider(clock=lambda: 1.)
    provider.publish(packet())
    provider.publish(packet(frame=2, seq=1, age=1201, action=True))
    sample = provider.sample(tick_id=0)
    assert not sample.hand_valid and not sample.fist_event
    assert sample.hand_x == sample.hand_y == 0


def test_default_runtime_is_unchanged():
    cli = SimpleNamespace(VisionInputProvider=VisionInputProvider)
    configure_provider(cli)
    assert cli.VisionInputProvider is FourWayVisionInputProvider
    original = VisionInputProvider(clock=lambda: 1.)
    original.publish(packet())
    assert original.sample(tick_id=0).hand_y == 0
    assert not original._fist_enabled


def test_provider_to_engine_vertical_motion_and_bounds():
    provider = FourWayVisionInputProvider(clock=lambda: 1.)
    engine = SideScrollerEngine(GameConfig(min_lane_y=-8, max_lane_y=8))
    state = engine.initial_state()
    tick = 0
    for frame, direction in enumerate(('UP', 'DOWN'), 1):
        provider.publish(packet(frame=frame, direction=direction))
        for _ in range(6):
            sample = provider.sample(tick_id=tick)
            mapped = Direction.UP if sample.hand_y < 0 else Direction.DOWN
            state = engine.step(state, SideScrollerCommand(tick_id=tick, direction=mapped))
            tick += 1
        assert state.lane_y == (-8 if direction == 'UP' else 8)


def test_game1_actual_template_consumes_vertical_and_jump():
    from pynq_multimodal_game.game_project import _SIDE_SCROLLER_MAIN_TEMPLATE
    namespace = {}
    exec(_SIDE_SCROLLER_MAIN_TEMPLATE, namespace)
    game = namespace['create_game']()
    provider = FourWayVisionInputProvider(clock=lambda: 1.)
    provider.publish(packet(direction='UP'))
    game.step(provider.sample(tick_id=0))
    assert game._state.lane_y == -4
    provider.publish(packet(frame=2, direction='DOWN'))
    game.step(provider.sample(tick_id=1))
    assert game._state.lane_y == 0
    provider.publish(packet(frame=3, seq=1, action=True, direction='DOWN'))
    game.step(provider.sample(tick_id=2))
    assert game._state.lane_y == 4 and game._state.z > 0
