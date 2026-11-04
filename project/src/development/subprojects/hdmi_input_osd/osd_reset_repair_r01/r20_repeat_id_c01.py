"""Boot-bound R20 OSD repeated-read comparison; no Agent, audio, or vision.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hdmi_input_osd/osd_reset_repair_r01/r20_repeat_id_c01.py --output build/hosd/osd-reset-r01/r20-repeat-id-c01.json --timeout 120
Output: exclusive PC receipt and fsynced board R20 var/osd-r20-compare-20261024-c01/repeat-id.jsonl.
Next: inspect the last phase and board availability; if any read hangs, recover the log after reboot before another test.
"""
import fcntl
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

BOOT = '0aa3d567-97fe-42d7-91be-332f0aaf6c22'
ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r20-admission-r03-20261023')
LOG = ROOT / 'var/osd-r20-compare-20261024-c01'
BIT_SHA = 'ddab12d94487c01b4b526ed1e73e3bf12efe42301bcce1c0da543e60d6709106'
HWH_SHA = 'be2401b61307228c9c72d6f8963f7edc59b2f92e2bfb116c2c7a7a3abcdae097'


def phase(name, **values):
    event = dict(phase=name, boot_id=BOOT, pid=os.getpid(),
                 monotonic_ns=time.monotonic_ns(), **values)
    with (LOG / 'repeat-id.jsonl').open('a') as output:
        output.write(json.dumps(event) + '\n')
        output.flush()
        os.fsync(output.fileno())
    print(json.dumps(event), flush=True)


assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT
assert json.loads((LOG / 'base-stop.json').read_text())['verdict'] == 'R20_BASE_STOP_PASS'
assert hashlib.sha256((ROOT / 'overlay/c6v_candidate.bit').read_bytes()).hexdigest() == BIT_SHA
assert hashlib.sha256((ROOT / 'overlay/c6v_candidate.hwh').read_bytes()).hexdigest() == HWH_SHA
assert not (LOG / 'repeat-id.attempt').exists() and not (LOG / 'repeat-id.jsonl').exists()
manifest = json.loads((ROOT / 'deployment_manifest.json').read_text())
assert len(manifest['sha256']) == 644 and manifest['build_id'] == '0xC0060E00'
for name, digest in manifest['sha256'].items():
    path = (ROOT / name).resolve()
    assert path.is_relative_to(ROOT) and hashlib.sha256(path.read_bytes()).hexdigest().upper() == digest, name
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
for name in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service'):
    state = subprocess.run(['systemctl', 'show', name, '-p', 'ActiveState', '-p',
                            'MainPID', '-p', 'Result'], capture_output=True, text=True,
                           check=True, timeout=5).stdout
    assert all(item in state for item in ('ActiveState=inactive', 'MainPID=0', 'Result=success')), name
for name in ('/var/lock/voice-view-c6i.lock', '/run/lock/voice_pcm_audio.lock'):
    with open(name, 'a+b') as lock:
        fcntl.flock(lock.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        lock.seek(0)
        assert not lock.read(), name
with (LOG / 'repeat-id.attempt').open('x') as output:
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
        assert address == (0x43C20000, 4096), address
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
        phase('before_repeat_id_read')
        identity = int(io.read(0))
        phase('after_repeat_id_read', value=identity)
        assert identity == 0x4F534401
        for index in range(50):
            for offset, expected in ((0, 0x4F534401), (4, None)):
                phase('before_stress_read', index=index, offset=offset)
                value = int(io.read(offset))
                phase('after_stress_read', index=index, offset=offset, value=value)
                if expected is not None:
                    assert value == expected
            time.sleep(.1)
        phase('R20_REPEAT_READ_PASS', id_reads=52, status_reads=50)
    finally:
        lease.close()
finally:
    phase('before_session_close')
    session.close()
    phase('after_session_close')
