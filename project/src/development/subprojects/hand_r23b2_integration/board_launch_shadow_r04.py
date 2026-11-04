"""Start the frozen R23b2 Agent with one R04 observation-only hand shadow.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hand_r23b2_integration/board_launch_shadow_r04.py --output subprojects/hand_r23b2_integration/b18-launch.json --timeout 30
Outputs: remote PID, b18-agent.log and b18-shadow-live/{publisher,ready,shadow}.json.
Next: inspect the Agent and shadow receipts; stop this PID before another load.
"""

import json
from pathlib import Path
import subprocess
import time


BOOT_ID = '00e0708c-60c5-4eec-8736-e2c80e93b631'
BASE = Path('/home/xilinx/voice-view-game')
CANDIDATE = BASE / 'c6i-pl-vision-button-osd-r23b2-shared-id-boardtest-20261024'
HAND = BASE / 'hand-shadow-r23b2-r04-20261024'
SHADOW = HAND / 'b18-shadow-live'
LOG = HAND / 'b18-agent.log'
PYNQ_PYTHON = Path('/usr/local/share/pynq-venv/bin/python')
HAND_PYTHON = Path('/home/xilinx/pynq-usb-hand/board-20261023-r01/venv/bin/python')

if Path('/proc/sys/kernel/random/boot_id').read_text().strip() != BOOT_ID:
    raise RuntimeError('Board boot changed since the idle gate')
if not all(path.is_file() for path in (CANDIDATE / 'start_board_test.py',
                                      HAND / 'tools/run_agent_shadow.py',
                                      PYNQ_PYTHON, HAND_PYTHON)):
    raise RuntimeError('Missing frozen source or interpreter')
if SHADOW.exists() or LOG.exists():
    raise RuntimeError('Output exists; never reuse an earlier run')

command = [str(PYNQ_PYTHON), '-u', '-I', '-B', str(HAND / 'tools/run_agent_shadow.py'),
           '--candidate', str(CANDIDATE),
           '--candidate-manifest-sha', '6ca286d0dd3479623620e6899d3f05133f8e40089e85646d38d754b45dcc78c8',
           '--hand-root', str(HAND),
           '--hand-manifest-sha', 'c630014cd3d828dcc6a4b17fdb10cb8522b37ac1489ac01703d31e5de9eb0e74',
           '--hand-python', str(HAND_PYTHON),
           '--shadow-directory', str(SHADOW), '--boot-id', BOOT_ID,
           '--seconds', '300']

with LOG.open('x') as output:
    process = subprocess.Popen(command, cwd=CANDIDATE,
                               stdin=subprocess.DEVNULL, stdout=output,
                               stderr=subprocess.STDOUT, start_new_session=True,
                               close_fds=True)
time.sleep(5)
print(json.dumps({'pid': process.pid, 'returncode_after_5s': process.poll(),
                  'boot_id': BOOT_ID, 'shadow_directory': str(SHADOW),
                  'log': str(LOG), 'log_tail': LOG.read_text(errors='replace')[-3000:]},
                 ensure_ascii=False), flush=True)
