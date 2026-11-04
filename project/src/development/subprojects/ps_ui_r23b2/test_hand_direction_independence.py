"""Replay actual directional admission with stable changing hand classes."""
import importlib.util
from pathlib import Path
import pytest
from pynq_multimodal_game.vision_input import GameVisionInputProvider
from pynq_multimodal_game.hand_shadow_bridge import LatestVisionFeed
from pynq_usb_hand.gesture_consumer import GestureConsumer,GestureObservation
from pynq_usb_hand.game_bridge import GameObservation,DatagramPublisher,DatagramReceiver
from subprojects.ps_ui_r23b2.test_hand_latest_boundary import Controller

ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('real_direction_control',ROOT/'handoffs/gesture_vision_v61/runtime/gesture_control.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)


def test_continuous_rock_paper_scissors_without_removing_hand_at_edge():
    now=[10.];provider=GameVisionInputProvider(clock=lambda:now[0])
    control=module.GestureControl()
    for frame,(stable,rps,expected,edge) in enumerate((
        ('0','ROCK','fist',False),('5','PAPER','paper',True),
        ('2','SCISSORS','scissors',True),('0','ROCK','fist',False)),1):
        now[0]+=.15
        result=dict(code=stable,stable=stable,rps=rps,centroid=(320.,250.),touches_roi=edge,error='')
        direction=control.update(result,frame,now[0])
        assert direction['valid'] is (not edge)
        provider.publish(dict(run_id='r',frame=frame,server_age_ms=10,
            stable=stable,rps=rps,control=direction),config_epoch='e')
        latest=provider.peek_hand_classification()
        assert latest['valid'] and latest['gesture']==expected


@pytest.mark.parametrize('reason',['ERROR','FRAME_GAP','COORDINATES'])
def test_real_fault_never_authorizes_a_hand_from_stable_label(reason):
    provider=GameVisionInputProvider(clock=lambda:10.)
    provider.publish(dict(run_id='r',frame=1,server_age_ms=10,stable='2',rps='SCISSORS',
        control=dict(schema='gesture-control-v1',frame_id=1,action_event_seq=0,
                     valid=False,reason=reason,direction='IDLE')),config_epoch='e')
    result=provider.peek_hand_classification()
    assert not result['valid'] and result['gesture'] is None


def test_edge_classification_is_not_revived_by_duplicate_error_or_resume():
    now=[10.];p=GameVisionInputProvider(clock=lambda:now[0])
    def packet(frame=1,reason='FRAME_EDGE',stable='5',rps='PAPER'):
        return dict(run_id='r',frame=frame,server_age_ms=10,stable=stable,rps=rps,
            control=dict(schema='gesture-control-v1',frame_id=frame,action_event_seq=0,
                valid=False,reason=reason,direction='IDLE'))
    p.publish(packet(),config_epoch='e')
    first=p.peek_hand_classification()
    assert first['gesture']=='paper'
    now[0]+=.2;p.publish(packet(),config_epoch='e')
    assert p.peek_hand_classification()['source_at']==pytest.approx(first['source_at'])
    p.publish(packet(reason='ERROR'),config_epoch='e')
    assert not p.peek_hand_classification()['valid']
    p.publish(packet(2),config_epoch='e')
    assert p.peek_hand_classification()['gesture']=='paper'
    p.suspend();p.resume()
    assert p.peek_hand_classification()['gesture'] is None


def test_edge_stable_label_disagreement_unknown_and_expiry_stay_neutral():
    now=[10.];p=GameVisionInputProvider(clock=lambda:now[0])
    for frame,stable,rps in ((1,'5','SCISSORS'),(2,'PENDING','UNKNOWN'),(3,'5','PAPER')):
        now[0]+=.1
        p.publish(dict(run_id='r',frame=frame,server_age_ms=10,stable=stable,rps=rps,
            control=dict(schema='gesture-control-v1',frame_id=frame,action_event_seq=0,
                valid=False,reason='FRAME_EDGE',direction='IDLE')),config_epoch='e')
        result=p.peek_hand_classification()
        assert result['gesture']==('paper' if frame==3 else None)
    now[0]+=1.3
    assert not p.peek_hand_classification()['valid']


POSES=(('0','ROCK','rock'),('5','PAPER','paper'),('2','SCISSORS','scissors'))

@pytest.mark.parametrize('start',POSES,ids=['rock','paper','scissors'])
@pytest.mark.parametrize('target',POSES,ids=['rock','paper','scissors'])
@pytest.mark.parametrize('edge_pair',[(False,False),(False,True),(True,False),(True,True)])
@pytest.mark.parametrize('target_at',[12.95,13.,13.1,15.])
@pytest.mark.parametrize('flicker',[False,True])
def test_all_continuous_transitions_through_real_direction_provider_wire(
        start,target,edge_pair,target_at,flicker):
    now=[10.];provider=GameVisionInputProvider(clock=lambda:now[0]);direction=module.GestureControl()
    feed=LatestVisionFeed(provider,observation_type=GestureObservation,envelope_type=GameObservation)
    class Wire:
        def __init__(self):self.data=[]
        def setblocking(self,_):pass
        def send(self,data):self.data.append(data);return len(data)
        def recv(self,_):
            if not self.data:raise BlockingIOError
            return self.data.pop(0)
    wire=Wire();pub=DatagramPublisher(wire,feed,session_id='s');frame=[0]
    def publish(at,pose,edge):
        now[0]=at;frame[0]+=1
        result=dict(code=pose[0],stable=pose[0],rps=pose[1],centroid=(320.,250.),touches_roi=edge,error='')
        control=direction.update(result,frame[0],at)
        assert control['reason'] in ('OK','FRAME_EDGE')  # no absent-hand frame
        provider.publish(dict(run_id='r',frame=frame[0],server_age_ms=10,
            stable=pose[0],rps=pose[1],control=control),config_epoch='e')
    publish(10.,start,edge_pair[0]);run=feed.read().game_run
    rx=DatagramReceiver(wire,session_id='s',game_run=run,clock=lambda:now[0])
    class Mailbox:
        def read(self):return rx.poll(now[0])
    c=Controller();consumer=GestureConsumer(c,Mailbox(),source_identity=('r','e'),
        max_age=.5,stable_seconds=.1,renew_interval=.2,qualified_gestures=True)
    def tick():assert pub.publish();return consumer.tick(now[0])
    assert tick()=='accepted'
    for at in (11.,12.,12.8,13.8,14.8):
        if at>=target_at:break
        publish(at,('PENDING','UNKNOWN','unknown') if flicker else start,edge_pair[0]);tick()
    publish(target_at,target,edge_pair[1])
    c.lifecycle='READY_IDLE' if target_at>=13. else 'MOVING'
    result=tick()
    if target_at<13.:
        assert result=='busy_dropped'
        now[0]=13.;c.lifecycle='READY_IDLE';result=tick()
    assert result==('unchanged' if start==target else 'accepted')
    assert c.requests==([start[2]] if start==target else [start[2],target[2]])
    # Holding the target after the next complete action adds no new request.
    c.lifecycle='READY_IDLE';now[0]+=.1;publish(now[0],target,edge_pair[1]);tick()
    assert 'default' not in c.requests
