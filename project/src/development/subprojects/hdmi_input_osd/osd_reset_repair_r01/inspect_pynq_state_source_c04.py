"""Read PYNQ's installed global-state path contract without touching hardware.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hdmi_input_osd/osd_reset_repair_r01/inspect_pynq_state_source_c04.py --output build/hosd/osd-reset-r01/pynq-state-source-c04.json --timeout 30
Output: exclusive local JSON receipt of path definitions and matching file metadata.
Next: determine whether bootpy's failed metadata came from a persistent cache.
"""
import json
from pathlib import Path

source = Path('/usr/local/share/pynq-venv/lib/python3.10/site-packages/pynq/pl_server/global_state.py')
lines = source.read_text().splitlines()
matches = [(index + 1, line) for index, line in enumerate(lines)
           if 'STATE' in line or 'state_file' in line or 'get_global' in line or 'load_global' in line]
print(json.dumps(dict(boot_id=Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
                      source=str(source), lines=matches), ensure_ascii=False), flush=True)
