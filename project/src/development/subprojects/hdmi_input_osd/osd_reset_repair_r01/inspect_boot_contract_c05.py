"""Read-only inspection of the installed PYNQ boot.py before restarting Base.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hdmi_input_osd/osd_reset_repair_r01/inspect_boot_contract_c05.py --output build/hosd/osd-reset-r01/boot-contract-c05.json --timeout 30
Output: exclusive local JSON receipt with boot.py and service ExecStart.
Next: only restart bootpy after confirming the current boot is unowned.
"""
import hashlib
import json
from pathlib import Path
import subprocess


boot = Path('/boot/boot.py')
raw = boot.read_bytes()
service = subprocess.run(['systemctl', 'cat', 'bootpy.service'], capture_output=True,
                         text=True, check=True, timeout=5)
print(json.dumps(dict(boot_id=Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
                      bootpy_sha256=hashlib.sha256(raw).hexdigest(),
                      bootpy_source=raw.decode('utf-8', errors='replace'),
                      service=service.stdout), ensure_ascii=False), flush=True)
