"""Read-only bounded recovery of R22 startup evidence after a physical reboot.

Run via remote.py with a fresh receipt after confirming the board is reachable.
Output: prior-boot R22 phase/stdout/stderr and vision preview startup logs.
Next: classify the last completed stage before modifying software or RTL.
"""
import json
from pathlib import Path
import subprocess

OLD_BOOT = 'ed3ea58a-1f10-41d7-94ae-64caec1cb94c'
ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r22-osd-reset-r01-20261024')
LOG = ROOT / 'var/osd-reset-20261024-a02'
boot = Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert boot != OLD_BOOT, 'This recovery script is intended for the next boot only'


def tail(path, limit=30000):
    return path.read_text(errors='replace')[-limit:] if path.is_file() else None


files = {name: tail(LOG / name) for name in ('service-start.json', 'service-exit.json',
         'load.attempt', 'stdout.log', 'stderr.log', 'startup-phases.jsonl')}
preview = {}
vision = ROOT / 'var/vision'
if vision.exists():
    for path in sorted(vision.rglob('preview-startup.jsonl')):
        if len(preview) >= 20:
            break
        preview[str(path.relative_to(ROOT))] = tail(path, 10000)
owners = []
for proc in Path('/proc').glob('[0-9]*'):
    try:
        command = proc.joinpath('cmdline').read_bytes().replace(b'\0', b' ').decode(errors='replace')
        if 'osd-reset-r22-agent-entry' in command or 'c6i-pl-vision-volume-osd-r22' in command:
            owners.append(dict(pid=int(proc.name), command=command[-600:]))
    except (FileNotFoundError, ProcessLookupError, PermissionError):
        pass
services = {}
for name in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service'):
    result = subprocess.run(['systemctl', 'show', name, '-p', 'ActiveState', '-p', 'MainPID'],
                            capture_output=True, text=True, timeout=5)
    services[name] = result.stdout[-500:]
print(json.dumps(dict(verdict='OSD_RESET_R22_POSTBOOT_EVIDENCE', boot_id=boot,
                      prior_boot_id=OLD_BOOT, files=files, preview=preview,
                      owners=owners, services=services)), flush=True)
