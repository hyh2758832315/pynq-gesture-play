"""Deterministic gesture handoff simulation; no board, serial or real sleeps."""
from pynq_usb_hand.gesture_consumer import GestureConsumer, GestureObservation, LatestGesture
from pynq_multimodal_game.vision_input import GameVisionInputProvider
from pynq_multimodal_game.hand_shadow_bridge import LatestVisionFeed
from pynq_usb_hand.game_bridge import GameObservation, DatagramPublisher, DatagramReceiver


class Controller:
    lease_seconds=5
    approval_seconds=3
    last_request=0
    lifecycle='READY_IDLE'
    def __init__(self): self.requests=[]
    def status(self):
        return dict(mode='fixed-playback',lifecycle=self.lifecycle,error=None,
                    session_id='s',enable_epoch='e')
    def renew(self,**_): pass
    def release(self): self.lifecycle='CONNECTED_OFF'
    def submit(self,state,request_id,**_):
        assert self.lifecycle=='READY_IDLE'
        self.requests.append(state);self.last_request=request_id;self.lifecycle='MOVING'
        return 'accepted'


def setup():
    c=Controller();slot=LatestGesture()
    consumer=GestureConsumer(c,slot,source_identity=('r','e'),max_age=.5,
        stable_seconds=.1,renew_interval=.2,qualified_gestures=True)
    def offer(frame,at,gesture):
        slot.offer(GestureObservation('r','e',frame,at,at,True,gesture))
        return consumer.tick(at)
    return c,consumer,offer


def test_busy_scissors_frame_is_usable_at_three_second_boundary():
    c,consumer,offer=setup()
    assert offer(1,10.,'fist')=='accepted'
    assert offer(2,12.95,'scissors')=='busy_dropped'
    c.lifecycle='READY_IDLE'  # same frame still fresh, route finished at 13.0
    assert consumer.tick(13.)=='accepted'
    assert c.requests==['rock','scissors']


def test_frame_edge_preserves_stable_hand_class_not_absent_hand_default():
    now=[10.]
    p=GameVisionInputProvider(clock=lambda:now[0])
    p.publish(dict(run_id='r',frame=1,server_age_ms=10,stable='2',rps='SCISSORS',
        control=dict(schema='gesture-control-v1',frame_id=1,action_event_seq=0,
                     valid=False,reason='FRAME_EDGE',direction='IDLE')),config_epoch='e')
    result=p.peek_hand_classification()
    assert result['valid'] and result['gesture']=='scissors'


def test_superseding_unknown_does_not_replay_previous_scissors():
    c,consumer,offer=setup()
    assert offer(1,10.,'fist')=='accepted'
    assert offer(2,12.8,'scissors')=='busy_dropped'
    assert offer(3,12.95,None)=='unclassified_hold'
    c.lifecycle='READY_IDLE'
    consumer.tick(13.)
    assert c.requests==['rock']


def test_expired_busy_frame_cannot_be_replayed_after_deadline():
    c,consumer,offer=setup()
    assert offer(1,10.,'fist')=='accepted'
    assert offer(2,12.4,'scissors')=='busy_dropped'
    c.lifecycle='READY_IDLE'
    assert consumer.tick(13.)=='invalid_or_stale_source'
    assert c.requests==['rock']


def test_provider_to_datagram_to_consumer_boundary_and_edge_trace():
    now=[10.]
    provider=GameVisionInputProvider(clock=lambda:now[0])
    feed=LatestVisionFeed(provider,observation_type=GestureObservation,envelope_type=GameObservation)
    class Wire:
        def __init__(self): self.data=[]
        def setblocking(self,_): pass
        def send(self,data): self.data.append(data);return len(data)
        def recv(self,_):
            if not self.data:raise BlockingIOError
            return self.data.pop(0)
    wire=Wire()
    def frame(n,at,stable,rps,reason=None):
        now[0]=at
        control=dict(schema='gesture-control-v1',frame_id=n,action_event_seq=0,
            valid=reason is None,direction='IDLE')
        if reason:control['reason']=reason
        provider.publish(dict(run_id='r',frame=n,server_age_ms=10,stable=stable,
            rps=rps,control=control),config_epoch='e')
    frame(1,10.,'0','ROCK')
    run=feed.read().game_run
    publisher=DatagramPublisher(wire,feed,session_id='wire')
    receiver=DatagramReceiver(wire,session_id='wire',game_run=run,clock=lambda:now[0])
    class Mailbox:
        def read(self):return receiver.poll(now[0])
    c=Controller()
    consumer=GestureConsumer(c,Mailbox(),source_identity=('r','e'),max_age=.5,
        stable_seconds=.1,renew_interval=.2,qualified_gestures=True)
    def tick():
        assert publisher.publish()
        return consumer.tick(now[0])
    assert tick()=='accepted'
    frame(2,12.95,'2','SCISSORS')
    assert tick()=='busy_dropped'
    now[0]=13.;c.lifecycle='READY_IDLE'
    assert tick()=='accepted'  # no extra camera frame needed
    frame(3,16.1,'PENDING','UNKNOWN','FRAME_EDGE');c.lifecycle='READY_IDLE'
    assert tick()=='unclassified_hold'
    assert c.requests==['rock','scissors']
    frame(4,16.2,'2','SCISSORS')
    assert tick()=='unchanged'
    frame(5,16.3,'NO_HAND','UNKNOWN','NO_HAND')
    assert tick()=='accepted'
    assert c.requests==['rock','scissors','default']
