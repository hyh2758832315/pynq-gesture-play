"""Offline owner/arbiter and overload recovery, without a serial device.

Run with HAND_CANDIDATE_ROOT and PYTHONPATH=<hand>/src;PS/python;python;.
Expected output: pytest assertions/XML. Next: paired Studio install and human test.
"""
import json
import threading
import time

from pynq_usb_hand.actuator_owner import VisionActuatorOwner
from pynq_usb_hand.game_bridge import DatagramReceiver
from pynq_usb_hand.gesture_consumer import GestureConsumer, GestureObservation, LatestGesture
from pynq_usb_hand.motion import MockBackend, MotionSettings
from pynq_usb_hand.controller import Controller
from pynq_usb_hand.page_playback import PagePlayback
from subprojects.ps_ui_r23b2.test_page_playback import Channel,FakeController


def packet(seq, *, gesture='paper', revoked=None):
    return json.dumps(dict(schema='hand-passive-v1', session='s', sequence=seq,
        revoked=revoked, value=dict(game_run='g', observation=dict(run_id='r',
        config_epoch='e', frame_id=seq, observed_at=10., source_at=10.,
        valid=True, gesture=gesture)))).encode()


def test_qualified_latest_pose_holds_unknown_and_default_has_no_dwell():
    backend=MockBackend()
    controller=Controller(lambda:backend,lease_seconds=5,
        settings=MotionSettings.fixed_playback(stage_waits=(.001,)*3),
        approval_seconds=.08)
    try:
        controller.wait_connected();controller.arm();assert controller.wait_idle()
        slot=LatestGesture()
        consumer=GestureConsumer(controller,slot,source_identity=('r','e'),
            max_age=.5,stable_seconds=.2,renew_interval=.2,qualified_gestures=True)
        def offer(frame,at,gesture):
            assert slot.offer(GestureObservation('r','e',frame,at,at,True,gesture))
            return consumer.tick(at)
        assert offer(1,10.,'paper')=='accepted'
        assert controller.wait_idle()
        assert offer(2,10.1,None)=='unclassified_hold'
        assert controller.status()['operation']['state']=='paper'
        began=time.monotonic()
        assert offer(3,10.2,'default')=='accepted'
        assert controller.wait_idle()
        default_operation=controller.status()['operation']
        assert default_operation['state']=='default'
        assert default_operation['ready_at']==default_operation['approved_at']
        assert time.monotonic()-began<.08
        assert offer(4,10.3,'paper')=='accepted'
        assert controller.wait_idle()
        assert controller.status()['operation']['state']=='paper'
        assert offer(5,10.4,'fist')=='accepted'
        assert offer(6,10.45,'scissors')=='busy_dropped'
        assert controller.wait_idle()
        # The current mailbox frame remains fresh after the approval window.
        # Real Controller + Motion must use it without requiring a new frame.
        assert consumer.tick(10.6)=='accepted'
        assert controller.wait_idle()
        assert controller.status()['operation']['state']=='scissors'
        assert consumer.tick(10.65)=='duplicate_frame'
        assert offer(7,10.7,'scissors')=='unchanged'
    finally:
        controller.close()


class Socket:
    def __init__(self, packets): self.packets=list(packets); self.reads=0
    def setblocking(self, _): pass
    def recv(self, _):
        self.reads+=1
        if not self.packets: raise BlockingIOError
        return self.packets.pop(0)


def test_receive_overload_waits_for_drained_tail_and_keeps_read_budget():
    sock=Socket([packet(i, gesture='paper' if i<70 else 'scissors') for i in range(1,71)])
    rx=DatagramReceiver(sock, session_id='s', game_run='g', budget=32, recover_stale=True)
    assert rx.poll(10.) is None and rx.stopped is None
    assert rx.waiting_for_fresh and sock.reads==32
    assert rx.poll(10.) is None and rx.stopped is None
    assert sock.reads==64
    assert rx.poll(10.).gesture=='scissors'
    assert rx.latest.frame_id==70 and not rx.waiting_for_fresh
    assert rx.overload_waits==2


def test_overload_cannot_hide_revocation_in_the_tail():
    sock=Socket([packet(i) for i in range(1,35)]+[packet(35,revoked='shutdown')])
    rx=DatagramReceiver(sock,session_id='s',game_run='g',recover_stale=True)
    assert rx.poll(10.) is None and rx.stopped is None
    assert rx.poll(10.) is None and rx.stopped=='producer_revoked'


def test_normal_follow_diagnostics_are_bounded_and_do_not_rearm_or_submit():
    channel=Channel(); channel.command=('live',1)
    controller=FakeController(); playback=PagePlayback(channel)
    observation=GestureObservation('r','e',1,10.,10.,True,'paper')
    assert playback.tick(controller,10.) is False
    playback.record_follow(controller,'stabilizing',observation,10.)
    writes=len(channel.states)
    for i in range(1,100):
        playback.record_follow(controller,'duplicate_frame',observation,10.+i*.005)
    assert len(channel.states)==writes
    playback.record_follow(controller,'unchanged',observation,11.)
    assert len(channel.states)==writes+1
    assert channel.states[-1]['follow']['decision']=='unchanged'
    assert channel.states[-1]['follow']['source_age_ms']==1000
    assert channel.states[-1]['follow_counts']['duplicate_frame']==99
    assert channel.states[-1]['follow_classes']['paper']==1
    assert not channel.states[-1]['follow_accepts']
    assert not controller.writes and not controller.arms and not controller.releases


def test_accepted_follow_remains_visible_after_page_goes_idle():
    channel=Channel();channel.command=('live',1)
    controller=FakeController();playback=PagePlayback(channel)
    assert playback.tick(controller,10.) is False
    controller.submit('rock',request_id=1)
    seen=GestureObservation('r','e',2,10.1,10.1,True,'fist')
    playback.record_follow(controller,'accepted',seen,10.1)
    controller.finish();channel.command=('idle',2)
    playback.tick(controller,13.2)
    assert channel.states[-1]['follow_accepts']==[dict(generation=1,mode='live',
        observed_at=10.1,frame_id=2,gesture='fist',request_id=1,state=None)]
    assert channel.states[-1]['follow_classes']['fist']==1


def eventually(check):
    deadline=time.monotonic()+2
    while time.monotonic()<deadline:
        if check(): return
        time.sleep(.01)
    assert check()


def test_same_live_page_repeated_follow_and_idle_handoff_reuse_one_owner():
    class Receiver:
        stopped=None; latest=None; waiting_for_fresh=False; frame=0; gesture='paper'
        def poll(self,now):
            self.frame+=1
            self.latest=GestureObservation('r','e',self.frame,now,now,True,self.gesture)
            return self.latest
    class Channel:
        command=('live',1)
        def __init__(self): self.states=[]
        def read(self): return self.command
        def publish(self,state): self.states.append(state)
    class Backend(MockBackend):
        stage_targets_authorized=True; playback_authorized=True
        def __init__(self): super().__init__(); self.arms=0
        def arm(self,cancel): self.arms+=1; super().arm(cancel)
    rx=Receiver(); channel=Channel(); backend=Backend(); reports=[]
    owner=VisionActuatorOwner(rx,lambda:backend,motor_ids=tuple(range(1,18)),
        stage_waits=(.001,)*3,max_seconds=15,approval_seconds=.12,poll_seconds=.02,
        max_age=.5,stable_seconds=.1,receiver_factory=lambda:rx,
        on_preview_state=lambda _:None,source_recovery=True,page_playback=PagePlayback(channel))
    thread=threading.Thread(target=lambda:reports.append(owner.run()))
    thread.start()
    try:
        for cycle in range(2):
            for gesture,state in (('paper','paper'),('fist','rock'),('scissors','scissors')):
                rx.gesture=gesture
                eventually(lambda: backend.poses[state] in backend.writes)
                time.sleep(.16)
                backend.writes.clear()
            if cycle==0:
                channel.command=('idle',2)
                eventually(lambda: channel.states and channel.states[-1]['off'])
                assert not backend.torque
                channel.command=('live',3)
    finally:
        owner.stop.set(); thread.join(3)
    assert not thread.is_alive() and reports[0]['error'] is None
    assert reports[0]['release_confirmed'] and backend.closed
    assert backend.arms==2
    assert [p['state'] for p in reports[0]['operations'] if p['state']!='default']==[
        'paper','rock','scissors','paper','rock','scissors']
