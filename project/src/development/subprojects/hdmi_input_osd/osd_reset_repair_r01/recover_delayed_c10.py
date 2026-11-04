"""Read-only recovery of the single delayed R22 OSD probe after a physical reboot.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hdmi_input_osd/osd_reset_repair_r01/recover_delayed_c10.py --output build/hosd/osd-reset-r01/recover-delayed-c10.json --timeout 30
Output: exclusive local receipt with the prior boot's fsynced phase log and new boot state.
Next: inspect the last phase, old/new boot IDs, owners and service state. No MMIO.
"""
import json
from pathlib import Path
import subprocess

OLD_BOOT = '334bdcc3-25e6-46d2-89bb-d9fa513d8f21'
ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r22-osd-reset-r01-20261024')
LOG = ROOT / 'var/osd-reset-20261024-c02'


def command(*args):
    try:
        result = subprocess.run(args, capture_output=True, text=True, timeout=5)
        return dict(code=result.returncode, stdout=result.stdout[-3000:], stderr=result.stderr[-1000:])
    except subprocess.TimeoutExpired:
        return dict(error='timeout')


boot = Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert boot != OLD_BOOT, 'Physical reboot has not occurred'
events = [json.loads(line) for line in (LOG / 'osd-delayed.jsonl').read_text().splitlines()]
assert events and all(event['boot_id'] == OLD_BOOT for event in events)
owners = []
for process in Path('/proc').glob('[0-9]*/maps'):
    try:
        maps = process.read_text(errors='replace')
        if '/dev/mem' in maps or '/dev/uio' in maps:
            owners.append(int(process.parent.name))
    except (FileNotFoundError, ProcessLookupError):
        pass
print(json.dumps(dict(verdict='OSD_DELAYED_LOG_RECOVERED', boot_id=boot,
                      prior_boot_id=OLD_BOOT, event_count=len(events),
                      last=events[-1], phases=events, owners=owners,
                      bootpy=command('systemctl', 'show', 'bootpy.service', '-p', 'ActiveState',
                                     '-p', 'MainPID', '-p', 'Result', '-p', 'ExecMainStatus'),
                      journal_boots=command('journalctl', '--list-boots', '--no-pager'),
                      pstore_files=[p.name for p in Path('/sys/fs/pstore').iterdir()]
                      if Path('/sys/fs/pstore').is_dir() else []), ensure_ascii=False), flush=True)
