"""Late/replayed results must not replace or rejuvenate a newer observation.

Run with PYTHONPATH=subprojects/ps_ui_r23b2/python;.:
  .venv/Scripts/python.exe -B -m pytest -q subprojects/ps_ui_r23b2/test_latest_vision_order.py
Output: assertion results only; no hardware or network access.
Next: run the normal menu/game integration checks and record board evidence.
"""
import pytest

from pynq_multimodal_game.game_sdk import HandGesture
from pynq_multimodal_game.studio.vision_receiver import VisionResultReceiver
from pynq_multimodal_game.vision_input import GameVisionInputProvider


def packet(frame, *, run='camera', age=20., valid=True, seq=0):
    return dict(run_id=run, frame=frame, server_age_ms=age, stable='5', rps='PAPER',
        ui_pointer=dict(schema='menu-pointer-v1', u=.7, v=.1),
        control=dict(schema='gesture-control-v1', frame_id=frame, action_event_seq=seq,
            valid=valid, direction='RIGHT' if valid else 'IDLE',
            reason='OK' if valid else 'NO_HAND', action_event=False,
            smooth_uv=[.7, .1], u=.7, v=.1))


@pytest.mark.parametrize('late', [packet(9, valid=False), packet(9, age=2000.)])
def test_older_result_cannot_stop_a_fresh_newer_direction(late):
    source = VisionResultReceiver()
    assert source.consume(packet(10), 10.).valid
    result = source.consume(late, 10.1)
    assert result.valid and result.frame_id == 10 and result.direction == 'RIGHT'
    assert result.server_age_ms == 20.
    assert source.expire(11.181).status == 'STALE'


def test_known_retired_run_cannot_replace_current_run():
    source = VisionResultReceiver()
    source.consume(packet(30, run='old'), 10.)
    source.consume(packet(1, run='current'), 10.1)
    result = source.consume(packet(31, run='old'), 10.2)
    assert result.run_id == 'current' and result.frame_id == 1 and result.valid
    assert source.consume(packet(2, run='current'), 10.3).valid


def test_stale_new_frame_cannot_be_revived_by_a_younger_duplicate_age():
    source = VisionResultReceiver()
    source.consume(packet(1), 10.)
    rejected = source.consume(packet(2, age=2000.), 10.1)
    assert rejected.status == 'STALE' and rejected.frame_id == 2
    assert not source.consume(packet(2, age=0.), 10.2).valid
    assert source.consume(packet(3), 10.3).valid


def test_duplicate_cannot_move_original_source_timestamp_forward():
    now = [10.]
    source = GameVisionInputProvider(clock=lambda: now[0])
    source.publish(packet(1, age=400.))
    first = source.peek_hand_classification()
    now[0] += .1
    source.publish(packet(1, age=0.))
    repeated = source.peek_hand_classification()
    assert repeated['source_at'] == pytest.approx(first['source_at'])
    assert repeated['frame_id'] == first['frame_id'] == 1


def test_duplicate_with_older_source_age_can_only_shorten_original_lease():
    source = VisionResultReceiver()
    source.consume(packet(1, age=100.), 10.)
    assert source.consume(packet(1, age=1100.), 10.1).valid
    assert source.expire(10.201).status == 'STALE'


def test_old_metadata_cannot_cancel_new_game_input_or_menu_confirmation():
    now = [10.]
    source = GameVisionInputProvider(clock=lambda: now[0])
    source.publish(packet(1))
    fist = packet(2, seq=1)
    fist.update(stable='0', rps='ROCK')
    source.publish(fist)
    old = packet(1)
    # Extra action metadata is not part of the accepted latest frame. Even a
    # bad old flag must not be processed against the current frame's identity.
    old['control']['action_event'] = 'bad-old-flag'
    source.publish(old)
    sample, receipt = source.sample_for_game('game1', tick_id=1)
    assert sample.hand_valid and sample.hand_gesture is HandGesture.FIST
    assert receipt['source_frame_id'] == 2
    assert source.sample_menu_control(tick_id=1).hand_valid


def test_same_frame_invalidation_still_releases_and_new_frame_recovers():
    source = VisionResultReceiver()
    source.consume(packet(1), 10.)
    invalid = source.consume(packet(1, valid=False), 10.1)
    assert not invalid.valid and invalid.direction == 'IDLE'
    assert not source.consume(packet(1), 10.2).valid
    assert source.consume(packet(2), 10.3).valid


def test_older_packet_cannot_cancel_latest_clipped_menu_pointer():
    now = [10.]
    source = GameVisionInputProvider(clock=lambda: now[0])
    clipped = packet(2, valid=False)
    clipped['control']['reason'] = 'FRAME_EDGE'
    source.publish(clipped)
    assert source.sample_menu_control(tick_id=1).hand_valid
    source.publish(packet(1, age=2000.))
    assert source.sample_menu_control(tick_id=2).hand_valid
    sample=source.sample_for_game('game1', tick_id=2)[0]
    assert sample.hand_valid and sample.hand_x == .7
    assert sample.hand_gesture is None and not sample.fist_event
    now[0] = 11.181
    assert not source.sample_menu_control(tick_id=3).hand_valid


def test_duplicate_shortening_also_expires_menu_and_classification():
    now = [10.]
    source = GameVisionInputProvider(clock=lambda: now[0])
    source.publish(packet(1, age=100.))
    now[0] = 10.1
    source.publish(packet(1, age=1100.))
    assert source.sample_menu_control(tick_id=1).hand_valid
    now[0] = 10.201
    assert not source.sample_menu_control(tick_id=2).hand_valid
    assert not source.peek_hand_classification()['valid']


def test_configuration_epoch_can_reset_frame_and_run_baselines():
    source = GameVisionInputProvider(clock=lambda: 10.)
    source.publish(packet(30, run='old'))
    source.publish(packet(1, run='current'))
    source.publish(packet(1, run='old'), config_epoch='new-config')
    sample, receipt = source.sample_for_game('game3', tick_id=1)
    assert sample.hand_valid and receipt['source_frame_id'] == 1
    assert receipt['run_id'] == 'old' and receipt['config_epoch'] == 'new-config'
