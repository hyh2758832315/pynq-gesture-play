"""Restore official Base from the idle R20 state for an R21-only comparison.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hdmi_input_osd/osd_reset_repair_r01/r21_restore_base_c01.py --output build/hosd/osd-reset-r01/r21-restore-base-c01.json --timeout 100
Output: exclusive PC receipt and fsynced R21 var/osd-r21-compare-20261024-c01/base-restore.jsonl.
Next: verify official Base identity, idle owners, then normally stop Base DMA.
"""
import fcntl
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time

BOOT = '0aa3d567-97fe-42d7-91be-332f0aaf6c22'
ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
LOG = ROOT / 'var/osd-r21-compare-20261024-c01'
PYNQ = Path('/usr/local/share/pynq-venv/lib/python3.10/site-packages/pynq')
STATE = PYNQ / 'pl_server/global_pl_state_.json'
BASE_SHA = {'base.bit': 'd9aec0ff1cddeaf109dd08b1510c2ed38b4804bd29ef7648ee80eac8f06de505',
            'base.hwh': '94dee45319dfecb22d9684eb565916e62f910eb999650c9a99fda51bdc9158fe'}
R20_BIT = 'ddab12d94487c01b4b526ed1e73e3bf12efe42301bcce1c0da543e60d6709106'


def phase(name, **values):
    event = dict(phase=name, boot_id=BOOT, monotonic_ns=time.monotonic_ns(), **values)
    with (LOG / 'base-restore.jsonl').open('a') as stream:
        stream.write(json.dumps(event) + '\n')
        stream.flush()
        os.fsync(stream.fileno())
    print(json.dumps(event), flush=True)


assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT
assert not LOG.exists()
assert STATE.exists()
active = Path(json.loads(STATE.read_text())['bitfile_name']).resolve()
assert active.is_relative_to(Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r20-admission-r03-20261023'))
assert hashlib.sha256(active.read_bytes()).hexdigest() == R20_BIT
for name, digest in BASE_SHA.items():
    assert hashlib.sha256((PYNQ / 'overlays/base' / name).read_bytes()).hexdigest() == digest
for proc in Path('/proc').glob('[0-9]*/maps'):
    try:
        maps = proc.read_text(errors='replace')
        assert '/dev/mem' not in maps and '/dev/uio' not in maps, str(proc)
    except (FileNotFoundError, ProcessLookupError):
        pass
for proc in Path('/proc').glob('[0-9]*/cmdline'):
    try:
        command = proc.read_bytes().replace(b'\0', b' ').decode(errors='replace')
        assert not any(name in command for name in ('start_board_test.py', 'pynq_usb_hand',
                                                    'board_buttons.py', 'run_agent_shadow.py'))
    except (FileNotFoundError, ProcessLookupError):
        pass
locks = []
try:
    for name in ('/var/lock/voice-view-c6i.lock', '/run/lock/voice_pcm_audio.lock'):
        lock = open(name, 'a+b')
        locks.append(lock)
        fcntl.flock(lock.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        lock.seek(0)
        assert not lock.read(), name
    for name in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service'):
        state = subprocess.run(['systemctl', 'show', name, '-p', 'ActiveState',
                                '-p', 'MainPID', '-p', 'Result'], capture_output=True,
                               text=True, check=True, timeout=5).stdout
        assert all(item in state for item in ('ActiveState=inactive', 'MainPID=0', 'Result=success')), name
    LOG.mkdir(parents=True)
    phase('before_official_base_restart', prior_bit_sha256=R20_BIT)
    result = subprocess.run(['systemctl', 'restart', 'bootpy.service'], capture_output=True,
                            text=True, timeout=80)
    phase('after_official_base_restart', returncode=result.returncode,
          stdout=result.stdout[-1000:], stderr=result.stderr[-1000:])
    service = subprocess.run(['systemctl', 'show', 'bootpy.service', '-p', 'ActiveState',
                              '-p', 'MainPID', '-p', 'Result', '-p', 'ExecMainStatus'],
                             capture_output=True, text=True, check=True, timeout=5).stdout
    phase('official_base_service_state', state=service)
    assert result.returncode == 0 and 'Result=success' in service and 'ExecMainStatus=0' in service
    new_state = Path(json.loads(STATE.read_text())['bitfile_name']).resolve()
    assert new_state == (PYNQ / 'overlays/base/base.bit').resolve()
    phase('OFFICIAL_BASE_RESTORED', bit_sha256=hashlib.sha256(new_state.read_bytes()).hexdigest())
finally:
    for lock in reversed(locks):
        lock.close()
