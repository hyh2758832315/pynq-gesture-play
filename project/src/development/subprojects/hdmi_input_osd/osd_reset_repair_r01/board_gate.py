"""Read-only PYNQ resource gate for the OSD reset repair.

Run: .venv/Scripts/python.exe -I -B subprojects/marker_hand_bringup_20261024/remote.py subprojects/hdmi_input_osd/osd_reset_repair_r01/board_gate.py --output build/hosd/osd-reset-r01/board-gate-UNIQUE.json
Output: a remote.py receipt containing current boot, owners, services and locks.
Next: continue only if the current boot is idle; recheck immediately before load.
"""
import json
from pathlib import Path
import subprocess


def command(*args):
    result = subprocess.run(args, capture_output=True, text=True, timeout=5)
    return dict(returncode=result.returncode, stdout=result.stdout[-6000:], stderr=result.stderr[-1000:])


owners = []
business = []
for proc in Path('/proc').glob('[0-9]*'):
    try:
        pid = int(proc.name)
        maps = (proc / 'maps').read_text(errors='replace')
        cmdline = (proc / 'cmdline').read_bytes().replace(b'\0', b' ').decode(errors='replace').strip()
        if '/dev/mem' in maps or '/dev/uio' in maps:
            owners.append(dict(pid=pid, cmdline=cmdline[-320:]))
        if any(word in cmdline for word in ('start_board_test.py', 'pynq_usb_hand',
                                             'board_buttons.py', 'marker-hand-20261024-a03')):
            business.append(dict(pid=pid, cmdline=cmdline[-320:]))
    except (FileNotFoundError, PermissionError, ProcessLookupError):
        continue

locks = {}
for name in ('/var/lock/voice-view-c6i.lock', '/run/lock/voice_pcm_audio.lock',
             '/var/lock/voice-view-c6i-volume-owner.json'):
    path = Path(name)
    locks[name] = path.read_text(errors='replace')[-1000:] if path.exists() else None

services = {name: command('systemctl', 'show', name, '-p', 'ActiveState', '-p', 'MainPID', '-p', 'Result')
            for name in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service')}
ports = command('ss', '-ltnp')
idle_services = all(item['returncode'] == 0 and 'ActiveState=inactive' in item['stdout']
                    and 'MainPID=0' in item['stdout'] for item in services.values())
idle = not owners and not business and idle_services and all(not value for value in locks.values())
print(json.dumps(dict(boot_id=Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
                      owners=owners, business=business, services=services, locks=locks,
                      ports=ports, verdict='READ_ONLY_IDLE_GATE_PASS' if idle else 'BOARD_BUSY'),
                 ensure_ascii=False), flush=True)
