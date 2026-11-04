"""Full-width position input from real controller packets, without board I/O.

Run with PYTHONPATH=subprojects/ps_ui_r23b2/python;.:
  .venv/Scripts/python.exe -B -m pytest -q subprojects/ps_ui_r23b2/test_edge_position.py
Output: pytest assertions. Next: verify packaged Game3 on HDMI.
"""
import pytest

from handoffs.gesture_vision_v61.runtime.gesture_control import GestureControl
from pynq_multimodal_game.vision_input import GameVisionInputProvider
from pynq_multimodal_game.game_runner import GameRunner
from pynq_multimodal_game.game_sdk import GameInput, HandGesture
from subprojects.ps_ui_r23b2.test_pause_closure import game_root


def edge(frame, now, x=160, y=180):
    observed = dict(centroid=(x, y), code='0', stable='0', rps='ROCK',
                    touches_roi=True, error=None)
    return dict(run_id='camera', frame=frame, server_age_ms=20., stable='0', rps='ROCK',
                control=GestureControl().update(observed, frame, now),
                ui_pointer=dict(schema='menu-pointer-v1', u=(x-319.5)/320., v=(y-179.5)/180.))


@pytest.mark.parametrize('x,y', [(160,180),(480,180),(1,180),(638,180),(320,1),(320,358)])
def test_edge_position_works_without_previous_interior_frame(x,y):
    source=GameVisionInputProvider(clock=lambda:100.)
    value=edge(1,100.,x,y)
    assert not value['control']['valid'] and value['control']['smooth_uv'] is None
    source.publish(value)
    sample,receipt=source.sample_for_game('game3',tick_id=0)
    assert sample.hand_valid
    assert (sample.hand_x,sample.hand_y)==pytest.approx(((x-319.5)/320.,(y-179.5)/180.))
    assert not sample.fist_event and sample.hand_gesture is None
    assert not receipt['motion_held'] and receipt['motion_source_frame_id']==1
    assert source.peek_hand_classification()['gesture'] is None


def test_continuous_edge_positions_follow_latest_then_expire_without_replay_renewal():
    now=[100.];source=GameVisionInputProvider(clock=lambda:now[0])
    for frame in range(1,16):
        now[0]+=.1
        source.publish(edge(frame,now[0],100+frame))
        assert source.sample(tick_id=frame).hand_x==pytest.approx((100+frame-319.5)/320.)
    now[0]+=.1
    source.publish(edge(14,now[0],600))
    source.publish(edge(15,now[0],600))
    assert source.sample(tick_id=16).hand_x==pytest.approx((115-319.5)/320.)
    now[0]+=.131
    source.publish(edge(15,now[0],600))
    assert not source.sample(tick_id=17).hand_valid


@pytest.mark.parametrize('fault',['ERROR','FRAME_GAP','missing','nan','range','schema','frame','suspend','release','discard'])
def test_edge_never_bypasses_faults_or_session_clearing(fault):
    now=[100.];source=GameVisionInputProvider(clock=lambda:now[0])
    source.publish(edge(1,now[0]))
    assert source.sample(tick_id=0).hand_valid
    now[0]+=.03
    p=edge(2,now[0])
    if fault in ('suspend','release','discard'):
        getattr(source,'discard_game_events' if fault=='discard' else fault)()
    else:
        if fault in ('ERROR','FRAME_GAP'):p['control']['reason']=fault
        elif fault=='missing':p.pop('ui_pointer')
        elif fault=='nan':p['ui_pointer']['u']=float('nan')
        elif fault=='range':p['ui_pointer']['u']=2
        elif fault=='schema':p['ui_pointer']['schema']='unknown'
        elif fault=='frame':p['frame']=3
        source.publish(p)
    assert not source.sample(tick_id=1).hand_valid


def test_actual_game3_moves_at_quarter_screen_for_continuous_edge_frames(game_root):
    now=[100.];source=GameVisionInputProvider(clock=lambda:now[0])
    with GameRunner(game_root/'seed_games/game3.vvg',render_rgb=False) as runner:
        runner.step(GameInput(0,0,True,-1.,0.,1,True,hand_gesture=HandGesture.FIST))
        game=runner._plugin._game
        game.x=120*64
        for frame in range(1,16):
            now[0]+=.1
            source.publish(edge(frame,now[0]))
            before=game.x
            runner.step(source.sample(tick_id=frame))
            assert game.x<before


def test_old_edge_source_age_duplicate_cannot_renew_and_new_run_cannot_hold_old_point():
    now=[100.];source=GameVisionInputProvider(clock=lambda:now[0])
    p=edge(1,now[0]);p['server_age_ms']=240
    source.publish(p)
    assert source.sample(tick_id=0).hand_valid
    now[0]+=.02
    p['server_age_ms']=0
    source.publish(p)
    assert not source.sample(tick_id=1).hand_valid
    p=edge(2,now[0]);p['server_age_ms']=300
    source.publish(p)
    assert not source.sample(tick_id=2).hand_valid
    p=edge(3,now[0]);source.publish(p)
    assert source.sample(tick_id=3).hand_valid
    p=edge(1,now[0]);p['run_id']='new';p['control']['reason']='NO_HAND';p.pop('ui_pointer')
    source.publish(p)
    assert not source.sample(tick_id=4).hand_valid
