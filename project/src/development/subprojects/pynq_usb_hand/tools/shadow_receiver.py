"""Bounded observation-only child; never imports a serial or actuator backend.

Run through HandShadowSession; standalone arguments are shown by --help.
Outputs: ready.json and immutable shadow.json. Next: inspect real source/stop cause.
"""
import argparse
from collections import Counter, deque
import json
import os
from pathlib import Path
import socket
import sys
import time

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'src'))
from pynq_usb_hand.game_bridge import DatagramReceiver


def write(path,value):
    with path.open('x',encoding='utf-8') as out:
        json.dump(value,out,indent=2);out.flush();os.fsync(out.fileno())


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--session',required=True)
    parser.add_argument('--game-run',required=True)
    parser.add_argument('--peer-port',type=int,required=True)
    parser.add_argument('--output-dir',type=Path,required=True)
    parser.add_argument('--seconds',type=float,required=True)
    args=parser.parse_args()
    if not 0<args.seconds<=600 or not 0<args.peer_port<65536:raise ValueError('Bounded lifetime and local peer required')
    if not args.output_dir.is_dir():raise ValueError('Owner-created output directory required')
    output=args.output_dir/'shadow.json'
    if output.exists() or (args.output_dir/'ready.json').exists():raise FileExistsError('Preserve previous session')
    sock=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
    sock.bind(('127.0.0.1',0));sock.connect(('127.0.0.1',args.peer_port))
    receiver=DatagramReceiver(sock,session_id=args.session,game_run=args.game_run,max_age=.5)
    write(args.output_dir/'ready.json',dict(pid=os.getpid(),parent_pid=os.getppid(),session=args.session,
                                          game_run=args.game_run,address=sock.getsockname()))
    started=time.monotonic();cpu=time.process_time()
    gestures=Counter();events=deque(maxlen=16);last_frame=0;frames=0;invalid=0;age_max=0.
    reason='duration_complete'
    try:
        while time.monotonic()-started<args.seconds:
            now=time.monotonic();observation=receiver.poll(now)
            if frames==0 and now-started>1:
                reason='source_missing';break
            if receiver.stopped:
                reason=receiver.stopped;break
            if observation is not None and observation.frame_id!=last_frame:
                frames+=1;last_frame=observation.frame_id
                invalid+=not observation.valid
                gestures[str(observation.gesture)]+=1
                age_max=max(age_max,now-observation.source_at)
                events.append(dict(frame=last_frame,gesture=observation.gesture,valid=observation.valid))
            time.sleep(.02)
    finally:
        sock.close()
        forbidden=[name for name in ('serial','pynq','orca_core','pynq_usb_hand.orca_backend') if name in sys.modules]
        write(output,dict(status='SHADOW_OBSERVED' if frames and not forbidden else 'SHADOW_NO_OBSERVATIONS',
                          pid=os.getpid(),session=args.session,game_run=args.game_run,stop_reason=reason,
                          frames=frames,invalid_frames=invalid,gestures=dict(gestures),events=list(events),
                          max_source_age_seconds=age_max,wall_seconds=time.monotonic()-started,
                          cpu_seconds=time.process_time()-cpu,forbidden_modules=forbidden,
                          actuator_constructed=False,serial_opened=False,hardware_motion=False))
    if forbidden:raise RuntimeError('Unexpected hardware import in observation-only child')


if __name__=='__main__':main()
