"""Diagnostic wrapper for the unmodified candidate entry.
Run on board via start_agent.py. Output startup-trace.jsonl; next inspect ready.
Only adds flushed startup timing; does not bypass loading, checks or cleanup.
"""
import json
import os
from pathlib import Path
import runpy
import sys
import time

ROOT=Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
LOG=ROOT/'var/marker-hand-20261024-a01'
seen=set()
files={'cli.py','c6i_backend.py','c6i_shell.py','c6i_video.py','vision_backend.py','vision_pl_fusion.py','pl_volume_factory.py','pl_volume_worker.py','transport.py'}
names={'open','start','create_worker','_load_shared_vision_overlay','_create_shared_vision_backend','_restore_shared_vision_interrupts'}
def trace(frame,event,arg):
    name=frame.f_code.co_name
    path=Path(frame.f_code.co_filename)
    key=(str(path),name,event)
    if path.name not in files or name not in names or event not in ('call','return') or key in seen:
        return
    if not path.is_relative_to(ROOT):
        return
    seen.add(key)
    entry=dict(file=str(path.relative_to(ROOT)),function=name,event=event,pid=os.getpid(),monotonic_ns=time.monotonic_ns())
    with (LOG/'startup-trace.jsonl').open('a') as stream:
        stream.write(json.dumps(entry)+'\n');stream.flush();os.fsync(stream.fileno())
    if path.name=='transport.py' and name=='start' and event=='return':
        sys.setprofile(None)
sys.setprofile(trace)
sys.argv=[str(ROOT/'start_board_test.py'),'--game-controls','--physical-audio-confirmed','--osd-test-stimuli']
runpy.run_path(str(ROOT/'start_board_test.py'),run_name='__main__')
