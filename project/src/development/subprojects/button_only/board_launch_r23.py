"""Start the isolated R23 PYNQ candidate and retain its output.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/button_only/board_launch_r23.py --output build/button_only/r23-launch-receipt.json --timeout 30
Output: a remote PID and /home/xilinx/voice-view-game/c6i-pl-vision-button-osd-r23b2-shared-id-boardtest-20261024/var/board_run.log.
Next: inspect the log and board state; do not start a second copy.
"""

import json
from pathlib import Path
import subprocess
import sys
import time

root = Path('/home/xilinx/voice-view-game/c6i-pl-vision-button-osd-r23b2-shared-id-boardtest-20261024')
entry = root / 'start_board_test.py'
log = root / 'var/board_run.log'
if not entry.is_file() or log.exists():
    raise RuntimeError('missing paired candidate or run log already exists')
log.parent.mkdir(exist_ok=True)
with log.open('x') as output:
    process = subprocess.Popen(
        [sys.executable, '-u', '-B', str(entry)], cwd=root,
        stdin=subprocess.DEVNULL, stdout=output, stderr=subprocess.STDOUT,
        start_new_session=True, close_fds=True,
    )
time.sleep(5)
print(json.dumps({'pid': process.pid, 'returncode_after_5s': process.poll(),
                  'log': str(log), 'log_tail': log.read_text(errors='replace')[-3000:]},
                 ensure_ascii=False), flush=True)
