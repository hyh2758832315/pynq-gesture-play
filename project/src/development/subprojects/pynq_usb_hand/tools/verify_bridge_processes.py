"""Exercise two real PC processes over private loopback datagrams; no robot I/O.

Run: hand-python -I -B tools/verify_bridge_processes.py --output NEW.json
Outputs: immutable JSON with process ids, channel observations and source SHA.
Next: repeat on ARM after board recovery; this is not physical-hand acceptance.
"""
import argparse
import hashlib
import json
import multiprocessing
import os
from pathlib import Path
import socket
import sys
import time
from types import SimpleNamespace
from uuid import uuid4

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'src'))
from pynq_usb_hand.game_bridge import GameFeed, DatagramPublisher, DatagramReceiver


def receive(peer, pipe, session):
    sock=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
    sock.bind(('127.0.0.1',0));sock.connect(peer)
    receiver=DatagramReceiver(sock,session_id=session,game_run='ipc-test-game',max_age=.8)
    seen=0
    pipe.send(dict(ready=True,pid=os.getpid(),address=sock.getsockname()))
    end=time.monotonic()+8
    while time.monotonic()<end:
        observation=receiver.poll(time.monotonic())
        if receiver.stopped:
            pipe.send(dict(stopped=receiver.stopped,pid=os.getpid()))
            sock.close();pipe.close();return
        if observation is not None and observation.frame_id!=seen:
            seen=observation.frame_id
            pipe.send(dict(frame=seen,gesture=observation.gesture,source_at=observation.source_at,pid=os.getpid()))
        time.sleep(.005)
    raise TimeoutError('Receive process exceeded bounded lifetime')


def receive_message(pipe):
    if not pipe.poll(5):raise TimeoutError('Child response deadline')
    return pipe.recv()


def probe(revoke):
    context=multiprocessing.get_context('spawn')
    parent,child=context.Pipe()
    sender_sock=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
    sender_sock.bind(('127.0.0.1',0))
    session=uuid4().hex
    process=context.Process(target=receive,args=(sender_sock.getsockname(),child,session))
    messages=[]
    try:
        process.start();child.close()
        messages.append(receive_message(parent))
        assert messages[-1]['ready'] and messages[-1]['pid']!=os.getpid()
        sender_sock.connect(tuple(messages[-1]['address']))
        feed=GameFeed();sender=DatagramPublisher(sender_sock,feed,session_id=session)
        for frame,gesture in ((1,'paper'),(2,'fist'),(3,'scissors')):
            value=SimpleNamespace(tick_id=frame,hand_valid=True,hand_gesture=gesture)
            receipt=dict(sample_tick=frame,hand_valid=True,hand_gesture=gesture,
                source_hand_gesture=gesture,server_age_ms=0,local_age_ms=0,
                run_id='vision-ipc-test',config_epoch='config-ipc-test',source_frame_id=frame)
            assert feed.offer('ipc-test-game',value,receipt,now=time.monotonic())
            assert sender.publish()
            message=receive_message(parent);messages.append(message)
            assert message['frame']==frame and message['gesture']==gesture
        if revoke:
            feed.revoke('pause');assert sender.publish()
        # Otherwise the source stops publishing; timeout must revoke on its own.
        messages.append(receive_message(parent))
        assert messages[-1]['stopped']==('producer_revoked' if revoke else 'stale_source')
        process.join(3)
        assert process.exitcode==0
        return dict(case='pause' if revoke else 'source_silent',events=messages,child_exit=process.exitcode)
    finally:
        if process.is_alive():
            process.terminate();process.join(3)
        sender_sock.close();parent.close();child.close()


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    args.output.parent.mkdir(parents=True,exist_ok=True)
    with args.output.open('x',encoding='utf-8') as out:
        report=dict(status='RUNNING',hardware_tested=False,real_serial_opens=0,
                    actuator_constructed=False,scope='two local processes, synthetic observations',parent_pid=os.getpid())
        try:
            report['cases']=[probe(True),probe(False)]
            report['status']='TWO_PROCESS_PASSIVE_BRIDGE_PASS'
        except BaseException as error:
            report.update(status='FAIL',error=repr(error));raise
        finally:
            report['source_sha256']={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in
                (Path(__file__),ROOT/'src/pynq_usb_hand/game_bridge.py')}
            json.dump(report,out,indent=2)
    print(report['status'])


if __name__=='__main__':
    multiprocessing.freeze_support()
    main()
