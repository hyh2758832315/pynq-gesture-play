"""Read-only board inventory before the isolated R21 marker comparison.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hdmi_input_osd/osd_reset_repair_r01/inspect_r21_preflight.py --output build/hosd/osd-reset-r01/r21-preflight-c01.json --timeout 30
Output: exclusive local JSON receipt with R21 package and current PL metadata.
Next: restore official Base only with an idle board, then normally stop Base DMA before R21 load.
"""
import hashlib
import json
from pathlib import Path
import subprocess

root = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
state = Path('/usr/local/share/pynq-venv/lib/python3.10/site-packages/pynq/pl_server/global_pl_state_.json')
items = {}
for name in ('deployment_manifest.json', 'overlay/c6v_candidate.bit', 'overlay/c6v_candidate.hwh'):
    path = root / name
    items[name] = dict(exists=path.is_file(), sha256=hashlib.sha256(path.read_bytes()).hexdigest() if path.is_file() else None)
boot = Path('/proc/sys/kernel/random/boot_id').read_text().strip()
service = subprocess.run(['systemctl', 'show', 'bootpy.service', '-p', 'ActiveState',
                          '-p', 'MainPID', '-p', 'Result'], capture_output=True,
                         text=True, check=True, timeout=5).stdout
print(json.dumps(dict(boot_id=boot, r21=items,
                      pl_state=state.read_text()[-1000:] if state.exists() else None,
                      boot_service=service)), flush=True)
