"""Bounded camera dropout and movement hysteresis; no hardware/network.

Run with PYTHONPATH=subprojects/ps_ui_r23b2/python;.:
  .venv/Scripts/python.exe -B -m pytest -q this_file
Output: assertions/JUnit when requested. Next: package and test real HDMI.
"""
from dataclasses import replace
from types import SimpleNamespace

import pytest

from pynq_multimodal_game.vision_input import GameVisionInputProvider
from pynq_multimodal_game.button_input import ButtonGameInputProvider
from pynq_multimodal_game.game_sdk import HandGesture, GameInput
from subprojects.ps_ui_r23b2.test_game_position_delivery import positioned
from subprojects.ps_ui_r23b2.test_game_input_pause_diagnosis import ROOT, load
from subprojects.ps_ui_r23b2.test_pause_closure import game_root
from pynq_multimodal_game.game_runner import GameRunner


def lost(frame, reason='NO_HAND'):
    p = positioned(frame, -.7, 0.)
    p['control'].update(valid=False, reason=reason)
    return p


def source():
    now=[100.]
    provider=GameVisionInputProvider(clock=lambda:now[0])
    p=positioned(1,-.7,0.)
    p.update(stable='0',rps='ROCK')
    provider.publish(p)
    return provider,now


@pytest.mark.parametrize('reason',['NO_HAND'])
def test_short_dropout_holds_only_position_then_stops_at_original_source_deadline(reason):
    provider,now=source()
    assert provider.sample(tick_id=0).hand_gesture is HandGesture.FIST
    now[0]=100.08
    provider.publish(lost(2,reason))
    sample,receipt=provider.sample_with_receipt(tick_id=1)
    assert sample.hand_valid and sample.hand_x==-.7
    assert sample.hand_gesture is None and not sample.fist_event
    assert receipt['motion_held'] is True
    assert receipt['motion_source_frame_id']==1
    # Frequent invalid frames and duplicate delivery cannot extend the lease.
    now[0]=100.20
    provider.publish(lost(3,reason));provider.publish(lost(3,reason))
    assert provider.sample(tick_id=2).hand_valid
    now[0]=100.231  # Frame 1 had 20 ms source age; deadline = 100.230.
    assert not provider.sample(tick_id=3).hand_valid
    provider.publish(positioned(4,.7,0.))
    assert provider.sample(tick_id=4).hand_x==.7


def test_missing_stream_or_repeated_valid_frame_cannot_extend_motion_age():
    provider,now=source()
    now[0]=100.20
    duplicate=positioned(1,-.7,0.);duplicate['server_age_ms']=0
    provider.publish(duplicate)
    assert provider.sample(tick_id=1).hand_valid
    now[0]=100.231
    sample=provider.sample(tick_id=2)
    assert not sample.hand_valid and not sample.fist_event


@pytest.mark.parametrize('boundary',['ERROR','FRAME_GAP','COORDINATES','suspend','release','discard','run','epoch'])
def test_fault_or_session_boundary_cancels_hold_immediately(boundary):
    provider,now=source();now[0]+=.03
    if boundary in ('suspend','release'):
        getattr(provider,boundary)()
    elif boundary=='discard':
        provider.discard_game_events()
        provider.publish(lost(2))
    else:
        p=lost(2,boundary if boundary not in ('run','epoch') else 'NO_HAND')
        if boundary=='run':p['run_id']='new'
        provider.publish(p,config_epoch='next' if boundary=='epoch' else 'default')
    assert not provider.sample(tick_id=1).hand_valid


def test_no_prior_position_and_button_session_switch_cannot_hold():
    provider=GameVisionInputProvider(clock=lambda:100.)
    provider.publish(lost(1))
    assert not provider.sample(tick_id=0).hand_valid
    provider,now=source()
    buttons=SimpleNamespace(clear=lambda:None,consume=lambda:None)
    ButtonGameInputProvider(provider,buttons).new_game_session(SimpleNamespace(game_id='game3'),'new')
    now[0]+=.03;provider.publish(lost(2))
    assert not provider.sample(tick_id=1).hand_valid


@pytest.mark.parametrize('game',['game1','game3'])
def test_deadzone_hysteresis_releases_in_center_reverses_immediately_and_resets(game):
    module=load('dropout_'+game,ROOT/f'subprojects/ps_ui_r23b2/game_overrides/{game}_input_adapter.py')
    adapter=module.Game1InputAdapter() if game=='game1' else module.Game3InputAdapter()
    def direction(tick,x,valid=True):
        command=adapter.adapt(GameInput(tick,tick*16_666_667,valid,x,0.,0,False))
        d=command.direction
        return d.name if game=='game1' else d
    left=-1 if game=='game3' else 'LEFT';right=1 if game=='game3' else 'RIGHT';idle=0 if game=='game3' else 'IDLE'
    assert direction(0,-.36)==left
    assert direction(1,-.34)==left
    assert direction(2,-.26)==left
    assert direction(3,-.22)==idle
    assert direction(4,-.34)==idle
    assert direction(5,-.36)==left
    assert direction(6,.40)==right
    assert direction(7,.40,False)==idle
    assert direction(8,.30)==idle
    direction(9,-.4);adapter.reset()
    assert direction(10,-.3)==idle
    direction(11,-.4)
    assert direction(80,-.3)==idle  # No latched direction across a pause/stall.


def test_actual_packaged_game3_keeps_velocity_across_one_lost_frame_then_stops(game_root):
    provider,now=source()
    with GameRunner(game_root/'seed_games/game3.vvg',render_rgb=False) as runner:
        runner.step(provider.sample(tick_id=0))
        game=runner._plugin._game
        assert game.status=='RUNNING'
        game.x=120*64
        for tick in range(1,6):
            now[0]+=.03
            provider.publish(positioned(tick+1,-.4 if tick==1 else -.3,0.))
            before=game.x
            runner.step(provider.sample(tick_id=tick))
            assert game.x<before  # Real per-instance adapter retains left at -.3.
        now[0]+=.03;provider.publish(lost(7))
        before=game.x
        value=provider.sample(tick_id=6)
        runner.step(value)
        assert game.x<before and value.hand_gesture is None and not value.fist_event
        for tick in range(7,19):
            now[0]+=.04
            runner.step(provider.sample(tick_id=tick))
        assert game.vx==0


def test_direction_freshness_does_not_extend_classification_or_arm_hand_game():
    provider,now=source();provider.sample(tick_id=0)
    now[0]+=.05;provider.publish(lost(2))
    sample,receipt=provider.sample_for_game('game2',tick_id=1)
    assert sample.hand_valid and sample.hand_gesture is None and not sample.fist_event
    assert receipt['source_frame_id']==2 and receipt['motion_source_frame_id']==1
    observation=provider.peek_hand_classification()
    assert observation['frame_id']==2 and observation['gesture'] is None
