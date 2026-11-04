"""Read-only recovery of the R21 comparison log after physical power cycling.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hdmi_input_osd/osd_reset_repair_r01/recover_r21_compare_c01.py --output build/hosd/osd-reset-r01/recover-r21-compare-c01.json --timeout 30
Output: exclusive local receipt containing the prior boot's fsynced R21 phases and new boot state.
Next: use the last fsynced phase to classify the failure; do not repeat R21 MMIO automatically.
"""
import json
from pathlib import Path
import subprocess

OLD_BOOT = '0aa3d567-97fe-42d7-91be-332f0aaf6c22'
ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
LOG = ROOT / 'var/osd-r21-compare-20261024-c01/repeat-id.jsonl'


def command(*args):
    try:
        result = subprocess.run(args, capture_output=True, text=True, timeout=5)
        return dict(code=result.returncode, stdout=result.stdout[-3000:], stderr=result.stderr[-1000:])
    except subprocess.TimeoutExpired:
        return dict(error='timeout')


boot = Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert boot != OLD_BOOT, 'Physical reboot has not occurred'
events = [json.loads(line) for line in LOG.read_text().splitlines()]
assert events and all(event['boot_id'] == OLD_BOOT for event in events)
owners = []
for process in Path('/proc').glob('[0-9]*/maps'):
    try:
        maps = process.read_text(errors='replace')
        if '/dev/mem' in maps or '/dev/uio' in maps:
            owners.append(int(process.parent.name))
    except (FileNotFoundError, ProcessLookupError):
        pass
print(json.dumps(dict(verdict='R21_REPEAT_ID_LOG_RECOVERED', boot_id=boot,
                      prior_boot_id=OLD_BOOT, event_count=len(events),
                      last=events[-1], phases=events, owners=owners,
                      bootpy=command('systemctl', 'show', 'bootpy.service', '-p', 'ActiveState',
                                     '-p', 'MainPID', '-p', 'Result', '-p', 'ExecMainStatus'),
                      pstore_files=[p.name for p in Path('/sys/fs/pstore').iterdir()]
                      if Path('/sys/fs/pstore').is_dir() else []), ensure_ascii=False), flush=True)
