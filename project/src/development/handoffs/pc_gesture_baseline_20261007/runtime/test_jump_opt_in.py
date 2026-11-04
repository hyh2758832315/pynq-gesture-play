from types import SimpleNamespace

from start_jump_board_test import configure_provider, verify
from pynq_multimodal_game.vision_input import VisionInputProvider
from pynq_multimodal_game.engine.side_scroller import SideScrollerEngine, SideScrollerCommand
from handoffs.gesture_vision_v61.runtime.gesture_control import GestureControl


def test_opt_in_does_not_change_global_default():
    cli = SimpleNamespace(VisionInputProvider=VisionInputProvider)
    configure_provider(cli)
    assert cli.VisionInputProvider()._fist_enabled is True
    assert VisionInputProvider()._fist_enabled is False


def test_real_controller_open_fist_provider_engine_and_hold():
    now = [1.0]
    cli = SimpleNamespace(VisionInputProvider=VisionInputProvider)
    configure_provider(cli)
    provider = cli.VisionInputProvider(clock=lambda: now[0])
    controller = GestureControl()
    engine = SideScrollerEngine()
    state = engine.initial_state()
    events = []
    for frame, stable in enumerate(('5', '5', '0', '0', '0'), 1):
        now[0] += .2
        control = controller.update({'centroid': [319, 179], 'code': stable,
                                     'stable': stable, 'touches_roi': False}, frame, now[0])
        provider.publish({'run_id': 'jump-test', 'server_age_ms': 0, 'control': control})
        sample = provider.sample(tick_id=frame - 1)
        events.append(sample.fist_event)
        state = engine.step(state, SideScrollerCommand(tick_id=frame - 1, jump=sample.fist_event))
        if frame == 3:
            assert state.z > 0
    assert events == [False, False, True, False, False]


def test_invalid_hand_clears_open_arm():
    controller = GestureControl()
    controller.update({'centroid': [319, 179], 'stable': '5'}, 1, 1.)
    controller.update({'centroid': None, 'code': 'NO_HAND'}, 2, 1.2)
    result = controller.update({'centroid': [319, 179], 'stable': '0'}, 3, 1.4)
    assert not result['action_event']


def test_modified_manifest_rejected_before_import(tmp_path):
    (tmp_path / 'deployment_manifest.json').write_text('{}')
    import pytest
    with pytest.raises(ValueError, match='frozen r8'):
        verify(tmp_path)
