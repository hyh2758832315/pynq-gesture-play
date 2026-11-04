"""Instrumented R22 integrated Agent test entry, run only by launch_agent_r22.py.

Output: fsynced startup-phases.jsonl and normal Agent stdout/stderr.
Next: inspect phases and Agent status, then perform controlled shutdown.
"""
import functools
import json
import os
from pathlib import Path
import runpy
import sys
import time

ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r22-osd-reset-r01-20261024')
LOG = ROOT / 'var/osd-reset-20261024-a02'
BOOT = 'ed3ea58a-1f10-41d7-94ae-64caec1cb94c'
assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT


def phase(name):
    with (LOG / 'startup-phases.jsonl').open('a') as output:
        output.write(json.dumps(dict(phase=name, pid=os.getpid(),
                                     monotonic_ns=time.monotonic_ns())) + '\n')
        output.flush()
        os.fsync(output.fileno())


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
