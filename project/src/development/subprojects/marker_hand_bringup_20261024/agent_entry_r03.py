"""R21 board startup with fsynced boundaries; production package is unchanged.

Run via start_agent_r03.py after boot-bound Base stop. Output: startup-phases.jsonl.
Next: inspect the last phase and board health before any further hardware action.
"""
import functools
import json
import os
from pathlib import Path
import runpy
import sys
import time

ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
LOG = ROOT / 'var/marker-hand-20261024-a03'
BOOT = '92f1a779-d821-46cd-a8d1-69a2a26cbc1f'
assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT

def phase(name):
    with (LOG / 'startup-phases.jsonl').open('a') as out:
        out.write(json.dumps(dict(phase=name, pid=os.getpid(), monotonic_ns=time.monotonic_ns())) + '\n')
        out.flush()
        os.fsync(out.fileno())

def instrument(target, name, label):
    original = getattr(target, name)
    @functools.wraps(original)
    def traced(*args, **kwargs):
        phase('before_' + label)
        try:
            result = original(*args, **kwargs)
        except BaseException:
            phase('error_' + label)
            raise
        phase('after_' + label)
        return result
    setattr(target, name, traced)

phase('before_runtime_import')
sys.path.insert(0, str(ROOT / 'python'))
sys.path.insert(0, str(ROOT / 'board/pynq_z2/scripts'))
from pynq_multimodal_game.agent import cli
from pynq_multimodal_game.agent.c6i_backend import C6IOverlaySession
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
from pynq_multimodal_game.agent.vision_backend import SharedVisionSupervisor
from pynq_multimodal_game.agent.osd_backend import C6IOsdRuntimeBackend
from pynq_multimodal_game.agent.transport import AgentServer
from pynq_multimodal_game.input_osd import InputOsdService
from voice_volume_fusion import BorrowedVolumeControl

instrument(cli, '_load_shared_vision_overlay', 'overlay_load')
instrument(C6IOverlaySession, 'open', 'session_open')
instrument(C6IShellRuntimeBackend, 'open', 'shell_open')
instrument(SharedVisionSupervisor, 'prepare', 'vision_prepare')
instrument(SharedVisionSupervisor, 'start', 'vision_start')
instrument(BorrowedVolumeControl, 'open', 'volume_open')
instrument(InputOsdService, 'open', 'osd_open')
instrument(C6IOsdRuntimeBackend, 'open', 'backend_open')
instrument(AgentServer, 'start', 'server_start')

original_factory = SharedVisionSupervisor.__init__
@functools.wraps(original_factory)
def traced_init(self, worker_factory, input_provider):
    @functools.wraps(worker_factory)
    def traced_factory(run_id):
        phase('before_vision_worker_factory')
        worker = worker_factory(run_id)
        phase('after_vision_worker_factory')
        for name in ('prepare_preview', 'start'):
            if hasattr(worker, name):
                instrument(worker, name, 'vision_worker_' + name)
        return worker
    return original_factory(self, traced_factory, input_provider)
SharedVisionSupervisor.__init__ = traced_init

phase('after_runtime_import')
sys.argv = [str(ROOT / 'start_board_test.py'), '--game-controls',
            '--physical-audio-confirmed', '--osd-test-stimuli']
runpy.run_path(str(ROOT / 'start_board_test.py'), run_name='__main__')
