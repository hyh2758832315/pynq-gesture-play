"""Boot-bound R22 OSD MMIO transaction probe without Agent, vision or audio.

Run via remote.py after base_stop_board_b01.py on boot 1b5b27d9... .
Output: fsynced var/osd-reset-20261024-b01/osd-transactions.jsonl.
Next: if every read/write succeeds, probe service lifecycle before full Agent.
"""
import fcntl
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

BOOT = '1b5b27d9-a744-4566-a20d-62bc24416136'
ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r22-osd-reset-r01-20261024')
LOG = ROOT / 'var/osd-reset-20261024-b01'
BIT_SHA = '507833ade953e9fe33c51cf8ef0c76943026a8b2a3d8ed2ed93aa1c1f2c1cd42'
assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT
assert json.loads((LOG / 'base-stop.json').read_text())['boot_id'] == BOOT
assert hashlib.sha256((ROOT / 'overlay/c6v_candidate.bit').read_bytes()).hexdigest() == BIT_SHA
assert not (LOG / 'osd-transactions.attempt').exists()
for proc in Path('/proc').glob('[0-9]*/maps'):
    try:
        maps = proc.read_text(errors='replace')
        assert '/dev/mem' not in maps and '/dev/uio' not in maps, str(proc)
    except (FileNotFoundError, ProcessLookupError):
        continue
for name in ('/var/lock/voice-view-c6i.lock', '/run/lock/voice_pcm_audio.lock'):
    with open(name, 'rb') as lock:
        fcntl.flock(lock.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        assert not lock.read(), name
for service in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service'):
    state = subprocess.run(['systemctl', 'show', service, '-p', 'ActiveState', '-p', 'MainPID'],
                           capture_output=True, text=True, check=True, timeout=5).stdout
    assert 'ActiveState=inactive' in state and 'MainPID=0' in state, service

with (LOG / 'osd-transactions.attempt').open('x') as output:
    json.dump(dict(boot_id=BOOT, bit_sha256=BIT_SHA, pid=os.getpid()), output)
    output.flush()
    os.fsync(output.fileno())


def phase(name, **values):
    event = dict(phase=name, boot_id=BOOT, pid=os.getpid(),
                 monotonic_ns=time.monotonic_ns(), **values)
    with (LOG / 'osd-transactions.jsonl').open('a') as output:
        output.write(json.dumps(event) + '\n')
        output.flush()
        os.fsync(output.fileno())
    print(json.dumps(event), flush=True)


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
        for offset, expected in ((0, 0x4F534401), (4, 0)):
            phase('before_read', offset=offset)
            value = int(io.read(offset))
            phase('after_read', offset=offset, value=value)
            assert value == expected, (offset, value)
        for index, value in enumerate((1, 0, 0, 0, 0, 0)):
            offset = 0x10 + 4 * index
            phase('before_write', offset=offset, value=value)
            io.write(offset, value)
            phase('after_write', offset=offset)
        phase('before_commit')
        io.write(8, 1)
        phase('after_commit')
        phase('before_busy_read')
        busy = int(io.read(4))
        phase('after_busy_read', busy=busy)
        assert busy in (0, 1)
        phase('OSD_MMIO_TRANSACTION_PASS')
    finally:
        lease.close()
finally:
    phase('before_session_close')
    session.close()
    phase('after_session_close')
