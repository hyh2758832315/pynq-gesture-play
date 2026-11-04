"""No hardware: full demo order, cancel, lease and sole-owner arbitration."""
import json
import time
from types import SimpleNamespace

import pytest
from pynq_usb_hand.page_playback import PagePlayback,PageCommandChannel,PageHeartbeatExpired,DEMO_STATES
from pynq_usb_hand.motion import Motion,MotionSettings,MockBackend
from pynq_usb_hand.controller import Controller

class Channel:
    def __init__(self):self.command=('demo',1);self.states=[]
    def read(self):return self.command
    def publish(self,state):self.states.append(state)

class FakeController:
    def __init__(self):
        self.last_request=0;self.release_pending=False;self.playback_stage=None
        self.life='READY_IDLE';self.state='unknown';self.operation=None
        self.writes=[];self.renewals=0;self.arms=0;self.releases=0
    def status(self):return dict(lifecycle=self.life,estimated_state=self.state,operation=self.operation,
        session_id='s',enable_epoch=None if self.life=='CONNECTED_OFF' else 'e',error=None)
    def renew(self,**kw):self.renewals+=1
    def submit(self,state,request_id,**kw):
        assert self.life=='READY_IDLE'
        assert request_id>self.last_request
        self.last_request=request_id;self.life='MOVING';self.state=state
        self.operation=dict(request_id=request_id,status='running')
        self.playback_stage='default:target'
        self.writes.append(state)
        return 'accepted'
    def finish(self):
        self.life='READY_IDLE';self.operation['status']='played';self.playback_stage=self.state+':target'
    def pause_for_preview(self):self.life='CONNECTED_OFF';self.releases+=1
    def resume_preview(self):self.life='READY_IDLE';self.arms+=1

def test_all_eleven_demo_poses_then_final_default_and_off():
    ch=Channel();c=FakeController();p=PagePlayback(ch)
    for i in range(50):
        assert p.tick(c,float(i)) is True
        if c.life=='MOVING':c.finish()
        if ch.states[-1]['phase']=='DONE':break
    assert c.writes==[*DEMO_STATES,'default']
    assert ch.states[-1]['off'] and ch.states[-1]['index']==11
    assert c.releases==1
    for i in range(5):p.tick(c,100.+i)
    assert c.writes==[*DEMO_STATES,'default']

@pytest.mark.parametrize('cancel_at',range(11))
def test_return_waits_current_approved_motion_then_default_and_off(cancel_at):
    ch=Channel();c=FakeController();p=PagePlayback(ch)
    now=0.
    for _ in range(cancel_at):
        p.tick(c,now);c.finish();now+=3
    p.tick(c,now)
    assert c.life=='MOVING'
    ch.command=('idle',2)
    p.tick(c,now+.1)
    assert c.releases==0 and c.life=='MOVING'
    c.finish();p.tick(c,now+3)
    assert c.writes[-1]=='default'
    c.finish();p.tick(c,now+6);p.tick(c,now+6.1)
    assert c.life=='CONNECTED_OFF' and ch.states[-1]['off']
    assert c.writes==[*DEMO_STATES[:cancel_at+1],'default']

def test_preview_interruption_never_replays_old_demo_generation():
    ch=Channel();c=FakeController();p=PagePlayback(ch)
    p.tick(c,0);c.finish();p.interrupt()
    for i in range(6):
        p.tick(c,i+1.)
        if c.life=='MOVING':c.finish()
    assert c.writes==['demo:0','default']
    assert ch.states[-1]['phase']=='INTERRUPTED' and ch.states[-1]['off']
    ch.command=('demo',2);p.tick(c,10);p.tick(c,11)
    assert c.writes[-1]=='demo:0'

def test_live_handoff_waits_busy_pose_and_respects_single_request_sequence():
    ch=Channel();c=FakeController();p=PagePlayback(ch)
    p.tick(c,0)
    ch.command=('live',2)
    assert p.tick(c,.1) is True
    c.finish()
    assert p.tick(c,3.1) is False
    assert c.last_request==1
    c.submit('paper',request_id=2)
    assert p.tick(c,3.2) is False
    p.interrupt()  # Preview must not cancel the requested live mode permanently.
    c.finish()
    assert p.tick(c,6.2) is False

def test_channel_rejects_replay_heartbeat_and_wrong_identity(tmp_path):
    clock=[10.]
    channel=PageCommandChannel(tmp_path,'s','g',clock=lambda:clock[0])
    value=dict(schema='hand-page-command-v1',session='s',game_run='g',mode='demo',generation=1,sent_at=10.)
    path=tmp_path/'page-command.json'
    def write():path.write_text(json.dumps(value))
    write();assert channel.read()==('demo',1)
    value['mode']='live';write()
    with pytest.raises(ValueError,match='generation reused'):channel.read()
    value['mode']='demo';value['sent_at']=7.;write()
    with pytest.raises(ValueError,match='heartbeat'):channel.read()
    value['sent_at']=10.;value['session']='old';write()
    with pytest.raises(ValueError,match='identity'):channel.read()


def test_idle_off_waits_for_fresh_page_command_without_rearming(tmp_path):
    clock=[10.]
    channel=PageCommandChannel(tmp_path,'s','g',clock=lambda:clock[0])
    path=tmp_path/'page-command.json'
    value=dict(schema='hand-page-command-v1',session='s',game_run='g',mode='idle',generation=0,sent_at=10.)
    path.write_text(json.dumps(value))
    controller=FakeController();controller.life='CONNECTED_OFF';controller.state='default'
    playback=PagePlayback(channel)
    assert playback.tick(controller,clock[0])
    clock[0]=12.1
    assert playback.tick(controller,clock[0])
    assert controller.arms==0 and controller.writes==[]
    state=json.loads((tmp_path/'page-state.json').read_text())
    assert state['phase']=='WAITING_COMMAND' and state['off']
    assert state['release_confirmed_ids']==list(range(1,18))
    value.update(mode='demo',generation=1)  # Expired new command still cannot arm.
    path.write_text(json.dumps(value))
    assert playback.tick(controller,clock[0])
    assert controller.arms==0
    value['sent_at']=clock[0];path.write_text(json.dumps(value))
    assert playback.tick(controller,clock[0])
    assert controller.arms==1
    assert playback.tick(controller,clock[0]+.01)
    assert controller.writes==['demo:0']


@pytest.mark.parametrize('fault',('identity','generation','future'))
def test_page_wait_never_accepts_bad_identity_replay_or_future(tmp_path,fault):
    clock=[10.];channel=PageCommandChannel(tmp_path,'s','g',clock=lambda:clock[0])
    path=tmp_path/'page-command.json'
    value=dict(schema='hand-page-command-v1',session='s',game_run='g',mode='idle',generation=1,sent_at=10.)
    path.write_text(json.dumps(value))
    c=FakeController();c.life='CONNECTED_OFF';p=PagePlayback(channel);p.tick(c,10.)
    if fault=='identity':value['session']='foreign'
    elif fault=='generation':value['generation']=0
    elif fault=='future':value['sent_at']=11.
    path.write_text(json.dumps(value))
    with pytest.raises(ValueError):p.tick(c,clock[0])
    assert c.arms==0 and c.writes==[]


def test_off_expiry_never_replays_an_interrupted_demo_generation(tmp_path):
    clock=[10.];channel=PageCommandChannel(tmp_path,'s','g',clock=lambda:clock[0])
    path=tmp_path/'page-command.json'
    value=dict(schema='hand-page-command-v1',session='s',game_run='g',mode='demo',generation=1,sent_at=10.)
    path.write_text(json.dumps(value));c=FakeController();p=PagePlayback(channel)
    p.tick(c,10.);c.finish();p.interrupt();c.pause_for_preview()
    clock[0]=12.1;p.tick(c,clock[0]);assert p.interrupted
    value['sent_at']=clock[0];path.write_text(json.dumps(value))
    p.tick(c,clock[0]);assert c.arms==0 and c.writes==['demo:0']
    value['generation']=2;path.write_text(json.dumps(value))
    p.tick(c,clock[0]);assert c.arms==1


class ExpiringChannel(Channel):
    expired=False
    def read(self):
        if self.expired:raise PageHeartbeatExpired('simulated 3.831653s page gap')
        return self.command


@pytest.mark.parametrize('gap_at',range(11))
def test_expired_demo_finishes_approved_move_releases_then_resumes_without_replay(gap_at):
    ch=ExpiringChannel();c=FakeController();p=PagePlayback(ch)
    now=0.
    for _ in range(gap_at):
        p.tick(c,now);c.finish();now+=3
    p.tick(c,now)
    ch.expired=True
    p.tick(c,now+.5)
    assert c.life=='MOVING' and c.releases==0
    assert c.writes==list(DEMO_STATES[:gap_at+1])
    assert ch.states[-1]['phase']=='WAITING_COMMAND' and not ch.states[-1]['off']
    c.finish();p.tick(c,now+3)
    assert c.life=='CONNECTED_OFF' and c.releases==1 and p.index==gap_at+1
    for step in range(4):p.tick(c,now+4+step)
    assert c.arms==0 and ch.states[-1]['release_confirmed_ids']==list(range(1,18))
    ch.expired=False
    for step in range(50):
        p.tick(c,now+10+step)
        if c.life=='MOVING':c.finish()
        if ch.states[-1]['phase']=='DONE':break
    assert c.writes==[*DEMO_STATES,'default']
    assert ch.states[-1]['phase']=='DONE' and ch.states[-1]['off']
    assert p.command_gaps==1 and p.command_resumes==1


@pytest.mark.parametrize('cancel',('menu','preview'))
def test_page_gap_recovery_does_not_override_menu_or_preview_cancel(cancel):
    ch=ExpiringChannel();c=FakeController();p=PagePlayback(ch)
    p.tick(c,0);ch.expired=True;p.tick(c,2.1)
    c.finish();p.tick(c,3.1)
    if cancel=='preview':p.interrupt()
    else:ch.command=('idle',2)
    ch.expired=False
    for step in range(5):p.tick(c,4.+step)
    assert c.arms==0 and c.writes==['demo:0'] and ch.states[-1]['off']


def test_fresh_page_must_wait_for_confirmed_off_before_rearming():
    class DelayedOff(FakeController):
        def pause_for_preview(self):
            self.life='RELEASING';self.release_pending=True;self.releases+=1
    ch=ExpiringChannel();c=DelayedOff();p=PagePlayback(ch)
    p.tick(c,0);c.finish();ch.expired=True;p.tick(c,3.1)
    ch.expired=False;p.tick(c,3.2)
    assert c.arms==0 and c.releases==1 and c.writes==['demo:0']
    c.life='CONNECTED_OFF';c.release_pending=False;p.tick(c,3.3)
    assert c.arms==1

def test_actual_motion_routes_emit_default_then_target_without_feedback():
    backend=MockBackend()
    for state in DEMO_STATES:backend.poses[state]=dict(backend.poses['paper'])
    motion=Motion(backend,MotionSettings.fixed_playback(stage_waits=(3,3,3)))
    clock=[10.];motion.clock=lambda:clock[0]
    stages=[];motion.stage_callback=stages.append
    backend.torque=True
    class Cancel:
        def check(self):pass
        def wait(self,duration):clock[0]+=duration
    for state in DEMO_STATES:
        approved=clock[0]
        motion.run(state,Cancel(),approved_at=approved,approval_seconds=3)
        assert clock[0]==approved+3
        assert stages[-2:]==['default:target',state+':target']
    assert backend.sequence==0

def test_actual_controller_demo_completes_and_confirms_off():
    backend=MockBackend()
    for state in DEMO_STATES:backend.poses[state]=dict(backend.poses['paper'])
    c=Controller(lambda:backend,lease_seconds=5,settings=MotionSettings.fixed_playback(stage_waits=(3,3,3)),
        approval_seconds=.15,preview_interlock=True,demo_states=DEMO_STATES)
    try:
        c.wait_connected();c.arm();assert c.wait_idle(2)
        ch=Channel();p=PagePlayback(ch);deadline=time.monotonic()+6
        while time.monotonic()<deadline:
            p.tick(c,time.monotonic())
            if ch.states[-1]['phase']=='DONE':break
            time.sleep(.005)
        assert ch.states[-1]['phase']=='DONE' and ch.states[-1]['off']
        assert c.status()['error'] is None
        assert backend.sequence==0  # Mock startup also uses no feedback.
    finally:c.close()
    assert c.status()['lifecycle']=='CLOSED'
