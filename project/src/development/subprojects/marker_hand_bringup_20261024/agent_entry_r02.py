"""Bounded startup instrumentation; original runtime/entry remain unchanged.
Run through start_agent_r02.py. Outputs startup-phases.jsonl; next inspect ready.
"""
import functools
import json
import os
from pathlib import Path
import runpy
import sys
import time
ROOT=Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
LOG=ROOT/'var/marker-hand-20261024-a02'
def phase(name):
    with (LOG/'startup-phases.jsonl').open('a') as out:
        out.write(json.dumps(dict(phase=name,pid=os.getpid(),monotonic_ns=time.monotonic_ns()))+'\n')
        out.flush();os.fsync(out.fileno())
def instrument(target,name,label):
    method=getattr(target,name)
    @functools.wraps(method)
    def traced(*args,**kwargs):
        phase('before_'+label)
        value=method(*args,**kwargs)
        phase('after_'+label)
        return value
    setattr(target,name,traced)
phase('before_runtime_import')
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.agent import cli
from pynq_multimodal_game.agent.c6i_backend import C6IOverlaySession
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
instrument(cli,'_load_shared_vision_overlay','overlay_load')
instrument(C6IOverlaySession,'open','session_open')
instrument(C6IShellRuntimeBackend,'open','shell_open')
phase('after_runtime_import')
sys.argv=[str(ROOT/'start_board_test.py'),'--game-controls','--physical-audio-confirmed','--osd-test-stimuli']
runpy.run_path(str(ROOT/'start_board_test.py'),run_name='__main__')
