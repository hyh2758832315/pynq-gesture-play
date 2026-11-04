"""Restore the official PYNQ-Z2 Base boot service on the idle current boot.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hdmi_input_osd/osd_reset_repair_r01/restore_base_c06.py --output build/hosd/osd-reset-r01/restore-base-c06.json --timeout 100
Output: exclusive PC receipt and fsynced board var/osd-reset-20261024-c02/base-restart.jsonl.
Next: require bootpy success, official Base identity and a fresh idle gate before R22.
"""
import fcntl
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time

BOOT = '334bdcc3-25e6-46d2-89bb-d9fa513d8f21'
ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r22-osd-reset-r01-20261024')
LOG = ROOT / 'var/osd-reset-20261024-c02'
PYNQ = Path('/usr/local/share/pynq-venv/lib/python3.10/site-packages/pynq')
HASHES = {'base.bit': 'd9aec0ff1cddeaf109dd08b1510c2ed38b4804bd29ef7648ee80eac8f06de505',
          'base.hwh': '94dee45319dfecb22d9684eb565916e62f910eb999650c9a99fda51bdc9158fe'}


def phase(name, **values):
    event = dict(phase=name, boot_id=BOOT, monotonic_ns=time.monotonic_ns(), **values)
    with (LOG / 'base-restart.jsonl').open('a') as output:
        output.write(json.dumps(event) + '\n')
        output.flush()
        os.fsync(output.fileno())
    print(json.dumps(event), flush=True)


assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT
assert not LOG.exists()
assert not (PYNQ / 'pl_server/global_pl_state_.json').exists()
for name, digest in HASHES.items():
    assert hashlib.sha256((PYNQ / 'overlays/base' / name).read_bytes()).hexdigest() == digest
for path in Path('/proc').glob('[0-9]*/maps'):
    try:
        maps = path.read_text(errors='replace')
        assert '/dev/mem' not in maps and '/dev/uio' not in maps, str(path)
    except (FileNotFoundError, ProcessLookupError):
        pass
for path in Path('/proc').glob('[0-9]*/cmdline'):
    try:
        cmdline = path.read_bytes().replace(b'\0', b' ').decode(errors='replace')
        assert not any(word in cmdline for word in ('start_board_test.py', 'pynq_usb_hand',
                                                    'board_buttons.py', 'run_agent_shadow.py')), cmdline
    except (FileNotFoundError, ProcessLookupError):
        pass
for name in ('/var/lock/voice-view-c6i.lock', '/run/lock/voice_pcm_audio.lock'):
    with open(name, 'a+b') as lock:
        fcntl.flock(lock.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        lock.seek(0)
        assert not lock.read(), name
for service in ('clear_pl_statefile.service', 'voice-view-shell.service'):
    result = subprocess.run(['systemctl', 'show', service, '-p', 'ActiveState', '-p', 'MainPID'],
                            capture_output=True, text=True, check=True, timeout=5)
    assert 'ActiveState=inactive' in result.stdout and 'MainPID=0' in result.stdout
LOG.mkdir(parents=True)
phase('before_official_base_restart')
result = subprocess.run(['systemctl', 'restart', 'bootpy.service'], capture_output=True,
                        text=True, timeout=80)
phase('after_official_base_restart', returncode=result.returncode,
      stdout=result.stdout[-1000:], stderr=result.stderr[-1000:])
state = subprocess.run(['systemctl', 'show', 'bootpy.service', '-p', 'ActiveState',
                        '-p', 'Result', '-p', 'ExecMainStatus'], capture_output=True,
                       text=True, check=True, timeout=5).stdout
phase('official_base_service_state', state=state)
assert result.returncode == 0 and 'Result=success' in state and 'ExecMainStatus=0' in state
