"""Approval-anchored complete playback window, no completion cooldown/backlog."""
import os,sys,threading,time
from pathlib import Path
from unittest.mock import patch
ROOT=Path(__file__).resolve().parents[2]
HAND=Path(os.environ.get('HAND_CANDIDATE_ROOT', ROOT/'build/hand-r28-source-wait-20261026-r04'))
sys.path.insert(0,str(HAND/'src'))
from pynq_usb_hand.motion import Motion,MotionSettings,MockBackend,Cancellation,Cancelled
from pynq_usb_hand.controller import Controller
import pytest
from pynq_usb_hand.gesture_consumer import GestureConsumer, GestureObservation, LatestGesture


def test_ready_uses_fresh_latest_stable_gesture_without_new_stability_wait():
    class CheckedController:
        lease_seconds=5
        last_request=0
        approval_seconds=3
        phase='READY_IDLE'
        submitted=[]
        def status(self):
            return dict(mode='fixed-playback',lifecycle=self.phase,error=None,
                        session_id='session',enable_epoch='epoch')
        def renew(self,**keys):pass
        def release(self):raise AssertionError('unexpected release')
        def submit(self,state,**keys):
            assert self.phase=='READY_IDLE'
            self.submitted.append(state)
            self.phase='MOVING'
            return 'accepted'
    controller=CheckedController();slot=LatestGesture()
    consumer=GestureConsumer(controller,slot,source_identity=('run','cfg'),
                             max_age=.5,stable_seconds=.1,renew_interval=.2)
    def tick(frame,at,gesture):
        slot.offer(GestureObservation('run','cfg',frame,at,at,True,gesture))
        return consumer.tick(at)
    assert tick(1,1.,'paper')=='stabilizing'
    assert tick(2,1.2,'paper')=='accepted'
    # Busy observations are replaced, never submitted or queued.
    tick(3,3.8,'fist');tick(4,3.95,'scissors');tick(5,4.1,'scissors')
    assert controller.submitted==['paper']
    controller.phase='READY_IDLE'
    assert consumer.tick(4.2)=='duplicate_frame'
    assert tick(6,4.21,'scissors')=='accepted'
    assert controller.submitted==['paper','scissors']


def test_approval_wait_remains_interruptible_on_release():
    backend=MockBackend()
    controller=Controller(lambda:backend,lease_seconds=5,
        settings=MotionSettings.fixed_playback(stage_waits=(3,3,3)),approval_seconds=3)
    try:
        controller.wait_connected();controller.arm();assert controller.wait_idle()
        status=controller.status()
        assert controller.submit('rock',request_id=1,session_id=status['session_id'],
                                 enable_epoch=status['enable_epoch'])=='accepted'
        time.sleep(.03);started=time.monotonic();controller.release()
        assert controller.wait_idle(timeout=1)
        assert time.monotonic()-started<.5
        assert not backend.torque
        assert controller.status()['operation']['status']=='cancelled'
    finally:controller.close()

@pytest.mark.parametrize('state,offsets',[('default',[0]),('paper',[0,1,2]),('rock',[0,1,2]),('scissors',[0,1.5])])
def test_complete_route_in_three_seconds_including_writes_and_dispatch_delay(state,offsets):
    now=[10.2];clock=lambda:now[0];starts=[]
    backend=MockBackend();backend.torque=True;write=backend.write_compiled
    def timed_write(target,cancel):
        starts.append(now[0]);write(target,cancel);now[0]+=.1
    backend.write_compiled=timed_write
    motion=Motion(backend,MotionSettings.fixed_playback(stage_waits=(3,3,3)),clock=clock)
    cancel=Cancellation(100,clock=clock)
    with patch.object(cancel,'wait',side_effect=lambda seconds:now.__setitem__(0,now[0]+seconds)), \
            patch.object(backend,'sample',side_effect=AssertionError('PLAYBACK_READ_FORBIDDEN')):
        motion.run(state,cancel,approved_at=10.,approval_seconds=3.)
    assert now[0]==pytest.approx(13.)
    assert starts==pytest.approx([10.2]+[10+x for x in offsets[1:]])
    assert backend.writes[-1]==backend.poses[state]


def test_late_stage_does_not_burst_remaining_targets():
    now=[1.];backend=MockBackend();backend.torque=True
    motion=Motion(backend,MotionSettings.fixed_playback(stage_waits=(3,3,3)),clock=lambda:now[0])
    cancel=Cancellation(100,clock=lambda:now[0])
    with pytest.raises(TimeoutError,match='deadline missed'):
        motion.run('paper',cancel,approved_at=0.,approval_seconds=3.)
    assert backend.writes==[]


def test_acceptance_deadline_reopens_immediately_without_extra_period_or_queue():
    backend=MockBackend();settings=MotionSettings.fixed_playback(stage_waits=(3,3,3))
    controller=Controller(lambda:backend,lease_seconds=5,settings=settings,approval_seconds=.15)
    try:
        controller.wait_connected();controller.arm();assert controller.wait_idle()
        status=controller.status();keys=dict(session_id=status['session_id'],enable_epoch=status['enable_epoch'])
        with patch.object(backend,'sample',side_effect=AssertionError('PLAYBACK_READ_FORBIDDEN')):
            assert controller.submit('paper',request_id=1,**keys)=='accepted'
            assert controller.submit('rock',request_id=2,**keys)=='busy'
            assert controller.wait_idle(timeout=1)
            operation=controller.status()['operation']
            assert .15<=operation['completed_at']-operation['approved_at']<.23
            assert controller.submit('scissors',request_id=3,**keys)=='accepted'
            assert controller.wait_idle(timeout=1)
            assert controller.status()['operation']['state']=='scissors'
    finally:controller.close()
