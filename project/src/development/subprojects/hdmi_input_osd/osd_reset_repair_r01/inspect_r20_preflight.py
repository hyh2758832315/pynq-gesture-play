"""Read-only R20 board preflight; no MMIO or Overlay load.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hdmi_input_osd/osd_reset_repair_r01/inspect_r20_preflight.py --output build/hosd/osd-reset-r01/r20-preflight-c01.json --timeout 30
Output: exclusive local JSON receipt with service state, R20 package, and Base metadata.
Next: load R20 only after services are inactive, board ownership is clear, and Base DMA is safely halted.
"""
import hashlib
import json
from pathlib import Path
import subprocess


def run(*argv):
    try:
        p = subprocess.run(argv, capture_output=True, text=True, timeout=5)
        return dict(code=p.returncode, stdout=p.stdout[-3000:], stderr=p.stderr[-1000:])
    except subprocess.TimeoutExpired:
        return dict(error='timeout')


root = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r20-admission-r03-20261023')
files = {}
for name in ('deployment_manifest.json', 'overlay/c6v_candidate.bit', 'overlay/c6v_candidate.hwh'):
    path = root / name
    files[name] = dict(exists=path.is_file(), sha256=hashlib.sha256(path.read_bytes()).hexdigest() if path.is_file() else None)
state = Path('/usr/local/share/pynq-venv/lib/python3.10/site-packages/pynq/pl_server/global_pl_state_.json')
print(json.dumps(dict(boot_id=Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
                      r20=files, pl_state=state.read_text()[-1000:] if state.exists() else None,
                      clear_service=run('systemctl', 'show', 'clear_pl_statefile.service',
                                        '-p', 'ActiveState', '-p', 'SubState', '-p', 'MainPID',
                                        '-p', 'Result', '-p', 'ExecMainStatus'),
                      clear_status=run('systemctl', 'status', 'clear_pl_statefile.service', '--no-pager', '-l'),
                      boot_service=run('systemctl', 'show', 'bootpy.service', '-p', 'ActiveState',
                                       '-p', 'SubState', '-p', 'MainPID', '-p', 'Result'))), flush=True)
