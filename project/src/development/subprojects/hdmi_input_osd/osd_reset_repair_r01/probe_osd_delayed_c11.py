"""Corrected, boot-bound delayed R22 OSD STATUS read on PYNQ-Z2 / Vivado 2026.1.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hdmi_input_osd/osd_reset_repair_r01/probe_osd_delayed_c11.py --output build/hosd/osd-reset-r01/osd-delayed-c11.json --timeout 100
Output: exclusive PC receipt and fsynced board var/osd-reset-20261024-c11/osd-delayed.jsonl.
Next: execute only after a new-boot Base stop receipt and independent hardware
observation review. If it stalls, recover the last fsynced phase; do not retry.
"""
import fcntl
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

BOOT = Path('/proc/sys/kernel/random/boot_id').read_text().strip()
OLD_BOOT = '334bdcc3-25e6-46d2-89bb-d9fa513d8f21'
ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r22-osd-reset-r01-20261024')
LOG = ROOT / 'var/osd-reset-20261024-c11'
BIT_SHA = '507833ade953e9fe33c51cf8ef0c76943026a8b2a3d8ed2ed93aa1c1f2c1cd42'


def phase(name, **values):
    event = dict(phase=name, boot_id=BOOT, pid=os.getpid(),
                 monotonic_ns=time.monotonic_ns(),
                 loadavg=Path('/proc/loadavg').read_text().strip(), **values)
    with (LOG / 'osd-delayed.jsonl').open('a') as output:
        output.write(json.dumps(event) + '\n')
        output.flush()
        os.fsync(output.fileno())
    print(json.dumps(event), flush=True)


assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT
assert BOOT != OLD_BOOT, 'A new physical boot is required'
assert json.loads((LOG / 'base-stop.json').read_text())['boot_id'] == BOOT
assert hashlib.sha256((ROOT / 'overlay/c6v_candidate.bit').read_bytes()).hexdigest() == BIT_SHA
assert not (LOG / 'osd-delayed.attempt').exists()
assert not (LOG / 'osd-delayed.jsonl').exists()
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
for name in ('/var/lock/voice-view-c6i.lock', '/run/lock/voice_pcm_audio.lock'):
    with open(name, 'a+b') as lock:
        fcntl.flock(lock.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        lock.seek(0)
        assert not lock.read(), name
for service in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service'):
    state = subprocess.run(['systemctl', 'show', service, '-p', 'ActiveState',
                            '-p', 'MainPID', '-p', 'Result'], capture_output=True,
                           text=True, check=True, timeout=5).stdout
    assert 'ActiveState=inactive' in state and 'MainPID=0' in state and 'Result=success' in state

with (LOG / 'osd-delayed.attempt').open('x') as output:
    json.dump(dict(boot_id=BOOT, bit_sha256=BIT_SHA, pid=os.getpid()), output)
    output.flush()
    os.fsync(output.fileno())

sys.path.insert(0, str(ROOT / 'python'))
os.environ['XILINX_XRT'] = '/usr'
phase('before_import')
import pynq
from pynq_multimodal_game.agent.cli import _load_shared_vision_overlay
from pynq_multimodal_game.agent.c6i_backend import C6IOverlaySession
phase('after_import')

session = C6IOverlaySession(str(ROOT / 'overlay/c6v_candidate.bit'),
                           lock_path='/var/lock/voice-view-c6i.lock',
                           expected_build_id=0xC0060E00,
                           overlay_factory=_load_shared_vision_overlay,
                           mmio_factory=pynq.MMIO, allocate=pynq.allocate)
phase('before_session_open')
try:
    session.open()
    phase('after_session_open')
    lease = session.borrow('hdmi-input-osd', instances=frozenset({'input_osd_0'}))
    try:
        address = session.ip_address(lease, ROOT / 'overlay/c6v_candidate.hwh', 'input_osd_0')
        assert address == (0x43C20000, 4096)
        phase('before_mmio_map')
        io = lease.mmio('input_osd_0')
        phase('after_mmio_map')
        phase('before_id_read')
        identity = int(io.read(0))
        phase('after_id_read', value=identity)
        assert identity == 0x4F534401
        for index in range(6):
            time.sleep(5)
            phase('settle_heartbeat', seconds=(index + 1) * 5)
        phase('before_status_read')
        status = int(io.read(4))
        phase('after_status_read', value=status)
        assert status in (0, 1)
        phase('OSD_DELAYED_STATUS_PASS')
    finally:
        lease.close()
finally:
    phase('before_session_close')
    session.close()
    phase('after_session_close')
