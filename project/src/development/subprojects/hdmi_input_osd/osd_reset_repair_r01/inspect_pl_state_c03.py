"""Read-only PYNQ-Z2 PL-state inspection before one R22 board retest.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hdmi_input_osd/osd_reset_repair_r01/inspect_pl_state_c03.py --output build/hosd/osd-reset-r01/pl-state-c03.json --timeout 30
Output: exclusive local JSON receipt with cache file identity and FPGA manager state.
Next: if the cache is corrupt, preserve it and restore the official Base path before loading R22.
"""
import hashlib
import json
from pathlib import Path


root = Path('/usr/local/share/pynq-venv/lib/python3.10/site-packages/pynq/pl_server')
paths = [root / 'global_pl_state_.json', root / 'global_pl_state.json',
         Path('/sys/class/fpga_manager/fpga0/state'), Path('/sys/class/fpga_manager/fpga0/flags')]
files = {}
for path in paths:
    if not path.exists():
        files[str(path)] = {'exists': False}
        continue
    raw = path.read_bytes()
    info = dict(exists=True, size=len(raw), sha256=hashlib.sha256(raw).hexdigest(),
                prefix=raw[:400].decode('utf-8', errors='replace'),
                modified_ns=path.stat().st_mtime_ns)
    if path.suffix == '.json':
        try:
            info['json'] = json.loads(raw)
        except (ValueError, UnicodeError) as error:
            info['json_error'] = str(error)
    files[str(path)] = info
print(json.dumps(dict(boot_id=Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
                      files=files), ensure_ascii=False, default=str), flush=True)
