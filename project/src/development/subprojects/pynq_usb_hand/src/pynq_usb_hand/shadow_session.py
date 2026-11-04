"""Independent observation-only process attached to an explicitly supplied feed.

The publisher thread handles file/JSON/socket/process work, never the game thread.
Only the first game is observed; revocation is permanent, with no child restart.
"""
import json
import math
import os
from pathlib import Path
import socket
import subprocess
import threading
import time
from uuid import uuid4

from .game_bridge import DatagramPublisher


class HandShadowSession:
    def __init__(self,feed,*,python,hand_root,output_dir,seconds=60):
        if type(seconds) not in (int,float) or not math.isfinite(seconds) or not 0<seconds<=600:
            raise ValueError('Explicit lifetime within 600 seconds required')
        self.feed=feed
        # Preserve the venv symlink on POSIX; resolving it would select base Python.
        self.python=Path(python).absolute()
        if not self.python.is_file():raise FileNotFoundError(self.python)
        self.hand_root=Path(hand_root).resolve(strict=True)
        self.entry=self.hand_root/'tools/shadow_receiver.py'
        if not self.entry.is_file():raise FileNotFoundError(self.entry)
        self.output_dir=Path(output_dir).absolute()
        self.seconds=seconds;self.session=uuid4().hex
        self._stop=threading.Event();self.finished=threading.Event();self._thread=None
        self.error=None

    def start(self):
        if self._thread is not None:raise RuntimeError('Shadow session cannot restart')
        self.output_dir.mkdir(mode=0o700,parents=False,exist_ok=False)
        self._thread=threading.Thread(target=self._run,name='hand-shadow-publisher',daemon=False)
        self._thread.start()

    def close(self):
        self.feed.revoke('shadow_closed');self._stop.set()
        if self._thread is not None:
            self._thread.join(8)
            if self._thread.is_alive():raise RuntimeError('Shadow worker cleanup not confirmed')

    def _run(self):
        child=None;sock=None;publisher=None
        started=time.monotonic();child_started=None
        record=dict(session=self.session,producer_pid=os.getpid(),actuator_constructed=False,child_restarted=False)
        try:
            deadline=started+self.seconds
            while time.monotonic()<deadline and not self._stop.is_set():
                value=self.feed.read()
                if self.feed.revoked is not None:
                    if publisher is not None:publisher.publish()
                    break
                if child is None and value is not None:
                    sock=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
                    sock.bind(('127.0.0.1',0))
                    command=[str(self.python),'-I','-B',str(self.entry),'--session',self.session,
                             '--game-run',value.game_run,'--peer-port',str(sock.getsockname()[1]),
                             '--output-dir',str(self.output_dir),'--seconds',str(self.seconds)]
                    record.update(command=command,game_run=value.game_run)
                    with (self.output_dir/'child-stdout.log').open('xb') as out,(self.output_dir/'child-stderr.log').open('xb') as err:
                        child=subprocess.Popen(command,stdin=subprocess.DEVNULL,stdout=out,stderr=err,
                                               creationflags=subprocess.CREATE_NO_WINDOW if os.name=='nt' else 0)
                    child_started=time.monotonic();record['launch_pid']=child.pid
                    ready_path=self.output_dir/'ready.json'
                    while True:
                        if child.poll() is not None:raise RuntimeError('Shadow exited before ready')
                        if self._stop.is_set():raise RuntimeError('Shadow startup cancelled')
                        if time.monotonic()-child_started>4:raise TimeoutError('Shadow readiness deadline')
                        try:
                            ready=json.loads(ready_path.read_text())
                            break
                        except (FileNotFoundError,json.JSONDecodeError):self._stop.wait(.02)
                    process_matches=(ready['pid']==child.pid or (os.name=='nt' and ready.get('parent_pid')==child.pid))
                    if (not process_matches or ready['session']!=self.session or ready['game_run']!=value.game_run
                            or ready['address'][0]!='127.0.0.1'):
                        raise ValueError('Shadow child identity mismatch')
                    record['child_pid']=ready['pid']
                    sock.connect(tuple(ready['address']))
                    publisher=DatagramPublisher(sock,self.feed,session_id=self.session)
                if child is not None:
                    if child.poll() is not None:break
                    publisher.publish()
                self._stop.wait(.1)
            self.feed.revoke('shadow_finished')
            if publisher is not None:publisher.publish()
        except Exception as error:
            self.error=f'{type(error).__name__}: {error}'
            self.feed.revoke('shadow_fault')
            if publisher is not None:publisher.publish()
        finally:
            try:
                if child is not None:
                    try:record['child_exit']=child.wait(timeout=2)
                    except subprocess.TimeoutExpired:
                        # This specific child never imports or owns an actuator.
                        child.terminate();record['child_exit']=child.wait(timeout=2)
                        record['child_terminated']=True
                        self.error=self.error or 'Shadow child did not close normally'
                if sock is not None:sock.close()
                record.update(error=self.error,feed_revoked=self.feed.revoked,elapsed=time.monotonic()-started,
                              publisher_dropped=None if publisher is None else publisher.dropped)
                with (self.output_dir/'publisher.json').open('x') as out:json.dump(record,out,indent=2)
            finally:self.finished.set()
