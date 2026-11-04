"""Offline only: real receiver protocol plus memory actuator, never serial.

Run: .venv/Scripts/python.exe -m pytest -q subprojects/ps_ui_r23b2/test_source_recovery.py
Expected: bounded routes, safe OFF, same-owner recovery and strict hard faults pass.
Next: pair the candidate; hardware/operator results remain pending.
"""
import json
import os
import socket
import select
import sys
import threading
import time
from pathlib import Path

import pytest

HAND = Path(os.environ.get('HAND_CANDIDATE_ROOT', Path(__file__).resolve().parents[2] / 'build/hand-r28-source-wait-20261026-r04'))
sys.path.insert(0, str(HAND / 'src'))
from pynq_usb_hand.actuator_owner import VisionActuatorOwner
from pynq_usb_hand.game_bridge import DatagramReceiver
from pynq_usb_hand.gesture_consumer import GestureObservation
from pynq_usb_hand.motion import MockBackend


def eventually(check, seconds=2):
    deadline = time.monotonic() + seconds
    while time.monotonic() < deadline:
        if check():
            return
        time.sleep(.005)
    assert check()


def packet(seq, *, at=10., frame=None, run='camera', gesture='paper'):
    return json.dumps(dict(schema='hand-passive-v1',session='session',sequence=seq,
        revoked=None,value=dict(game_run='game',observation=dict(run_id=run,
        config_epoch='epoch',frame_id=seq if frame is None else frame,
        source_at=at,observed_at=at,valid=True,gesture=gesture)))).encode()


def send(a,b,data):
    a.send(data)
    assert select.select([b],[],[],1)[0]


def test_aged_data_waits_without_refreshing_or_losing_identity():
    a, b = socket.socket(socket.AF_INET,socket.SOCK_DGRAM), socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
    try:
        b.bind(('127.0.0.1',0)); a.connect(b.getsockname())
        receiver=DatagramReceiver(b,session_id='session',game_run='game',recover_stale=True)
        send(a,b,packet(1)); assert receiver.poll(10).frame_id==1
        assert receiver.poll(10.51) is None and receiver.stopped is None
        assert receiver.waiting_for_fresh
        send(a,b,packet(2,at=10.,frame=1))  # sequence alone is not a fresh camera frame
        assert receiver.poll(10.6) is None
        send(a,b,packet(3,at=10.6)); assert receiver.poll(10.6).frame_id==3
        assert not receiver.waiting_for_fresh
        send(a,b,packet(4,at=10.7,run='different'))
        assert receiver.poll(10.7) is None and receiver.stopped=='source_identity'
    finally:
        a.close();b.close()


def test_recovery_does_not_soften_invalid_clock_or_protocol():
    for data,reason in ((packet(1,at=11),'invalid_source_clock'),(b'{}','channel_identity')):
        a,b=socket.socket(socket.AF_INET,socket.SOCK_DGRAM),socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
        try:
            b.bind(('127.0.0.1',0));a.connect(b.getsockname())
            receiver=DatagramReceiver(b,session_id='session',game_run='game',recover_stale=True)
            send(a,b,data);assert receiver.poll(10) is None;assert receiver.stopped==reason
        finally:
            a.close();b.close()


class MemoryBackend(MockBackend):
    stage_targets_authorized=True
    playback_authorized=True
    def __init__(self):
        super().__init__();self.arms=0
    def arm(self,cancel):
        self.arms+=1;return super().arm(cancel)
    def release(self):
        time.sleep(.04)  # real serial OFF verification can span owner polls
        return super().release()


class Receiver:
    def __init__(self):
        self.stopped=None;self.latest=None;self.waiting_for_fresh=False
        self.frozen=False;self.frame=0;self.gesture='paper';self.run='camera'
    def poll(self,now):
        if self.stopped:
            return None
        if not self.frozen:
            self.frame+=1
            self.latest=GestureObservation(self.run,'epoch',self.frame,now,now,True,self.gesture)
        self.waiting_for_fresh=self.latest is not None and now-self.latest.source_at>=.08
        return None if self.waiting_for_fresh else self.latest


def start_owner():
    receiver=Receiver();backend=MemoryBackend();phases=[];active=threading.Event();reports=[]
    owner=VisionActuatorOwner(receiver,lambda:backend,motor_ids=tuple(range(1,18)),
        stage_waits=(.001,)*3,max_seconds=5,approval_seconds=.25,
        max_age=.08,stable_seconds=.025,poll_seconds=.02,
        receiver_factory=lambda:receiver,on_preview_state=phases.append,
        source_recovery=True,source_off_seconds=.08,on_active=lambda _:active.set())
    thread=threading.Thread(target=lambda:reports.append(owner.run()));thread.start()
    assert active.wait(1)
    eventually(lambda: owner.audit is not None and any(p['controller']['operation'] for p in phases)
        or backend.writes)
    return owner,receiver,backend,phases,reports,thread


def finish(owner,reports,thread):
    owner.stop.set();thread.join(2);assert not thread.is_alive()
    assert reports and reports[0]['release_confirmed'],reports
    return reports[0]


def test_short_gap_completes_route_and_recovers_same_enable_without_off():
    owner,rx,backend,phases,reports,thread=start_owner()
    try:
        rx.frozen=True
        eventually(lambda:any(p['phase']=='WAITING_SOURCE' for p in phases))
        rx.gesture='scissors';rx.frozen=False
        eventually(lambda:owner.source_resumes==1)
        assert backend.arms==1
        assert not any(p['phase']=='WAITING_SOURCE_OFF' for p in phases)
        eventually(lambda:backend.poses['scissors'] in backend.writes)
    finally:
        report=finish(owner,reports,thread)
    assert report['error'] is None
    assert [p['state'] for p in report['operations']][:2]==['paper','scissors']


def test_long_gap_confirms_off_then_recovers_same_controller_only_latest():
    owner,rx,backend,phases,reports,thread=start_owner()
    try:
        first=phases[0]['controller']['session_id']
        rx.frozen=True
        eventually(lambda:any(p['phase']=='WAITING_SOURCE_OFF' for p in phases))
        assert not backend.torque
        assert phases[-1]['release_confirmed_ids']==list(range(1,18))
        assert all(p['controller']['operation']['status']!='cancelled' for p in phases
                   if p['controller']['operation'] is not None)
        rx.gesture='fist';rx.gesture='scissors';rx.frozen=False
        eventually(lambda:owner.source_resumes==1)
        eventually(lambda:backend.poses['scissors'] in backend.writes)
        assert all(p['controller']['session_id']==first for p in phases)
        assert all(p['controller']['lifecycle']=='CONNECTED_OFF' for p in phases
                   if p['phase']=='WAITING_SOURCE_OFF')
        assert backend.arms==2
    finally:
        report=finish(owner,reports,thread)
    assert report['error'] is None
    assert not any(p['state']=='rock' for p in report['operations'])


@pytest.mark.parametrize('reason',['producer_revoked','source_identity','invalid_source_clock'])
def test_waiting_never_recovers_revocation_or_hard_fault(reason):
    owner,rx,backend,phases,reports,thread=start_owner()
    rx.frozen=True
    eventually(lambda:any(p['phase']=='WAITING_SOURCE_OFF' for p in phases))
    rx.stopped=reason;thread.join(2)
    assert not thread.is_alive() and reports[0]['release_confirmed']
    assert backend.arms==1 and owner.source_resumes==0
    assert (reports[0]['error'] is None)==(reason=='producer_revoked')


def test_stop_while_waiting_off_never_rearms():
    owner,rx,backend,phases,reports,thread=start_owner()
    rx.frozen=True
    eventually(lambda:any(p['phase']=='WAITING_SOURCE_OFF' for p in phases))
    report=finish(owner,reports,thread)
    assert report['error'] is None and backend.arms==1


def test_unconfirmed_off_is_hard_fault_and_never_resumes():
    owner,rx,backend,phases,reports,thread=start_owner()
    backend.release=lambda:(7,)
    rx.frozen=True;thread.join(2)
    assert not thread.is_alive()
    assert not reports[0]['release_confirmed'] and reports[0]['error']
    assert backend.arms==1 and owner.source_resumes==0
    assert not any(p['phase']=='WAITING_SOURCE_OFF' for p in phases)
