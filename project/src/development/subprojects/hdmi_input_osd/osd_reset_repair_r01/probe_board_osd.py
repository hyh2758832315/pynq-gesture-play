"""One boot-bound repaired Overlay load and OSD ID read, no Agent/AV start.

Run through subprojects/marker_hand_bringup_20261024/remote.py with a fresh receipt.
Output: fsynced var/osd-reset-20261024-a01/probe-phases.jsonl and OSD_RESET_ID_PROBE_PASS.
Next: inspect this receipt and boot state before any integrated Agent startup.
"""
import fcntl
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

BOOT = 'ed3ea58a-1f10-41d7-94ae-64caec1cb94c'
RUNTIME = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
STAGE = Path('/home/xilinx/voice-view-game/c6i-osd-reset-r22-probe-20261024/overlay')
LOG = RUNTIME / 'var/osd-reset-20261024-a01'
BIT_SHA = '507833ade953e9fe33c51cf8ef0c76943026a8b2a3d8ed2ed93aa1c1f2c1cd42'
HWH_SHA = 'be2401b61307228c9c72d6f8963f7edc59b2f92e2bfb116c2c7a7a3abcdae097'
assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT
assert json.loads((LOG / 'base-stop.json').read_text())['boot_id'] == BOOT
assert hashlib.sha256((STAGE / 'c6v_candidate.bit').read_bytes()).hexdigest() == BIT_SHA
assert hashlib.sha256((STAGE / 'c6v_candidate.hwh').read_bytes()).hexdigest() == HWH_SHA
manifest = json.loads((RUNTIME / 'deployment_manifest.json').read_text())
assert len(manifest['sha256']) == 628
for name, expected in manifest['sha256'].items():
    path = (RUNTIME / name).resolve()
    assert path.is_relative_to(RUNTIME) and hashlib.sha256(path.read_bytes()).hexdigest().upper() == expected, name
for proc in Path('/proc').glob('[0-9]*/maps'):
    try:
        maps = proc.read_text(errors='replace')
        assert '/dev/mem' not in maps and '/dev/uio' not in maps, str(proc)
    except (FileNotFoundError, ProcessLookupError):
        continue
for name in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service'):
    result = subprocess.run(['systemctl', 'show', name, '-p', 'ActiveState', '-p', 'MainPID'],
                            capture_output=True, text=True, check=True, timeout=5)
    assert 'ActiveState=inactive' in result.stdout and 'MainPID=0' in result.stdout, name
for name in ('/var/lock/voice-view-c6i.lock', '/run/lock/voice_pcm_audio.lock'):
    with open(name, 'rb') as stream:
        fcntl.flock(stream.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        assert not stream.read(), name

with (LOG / 'osd-probe.attempt').open('x') as out:
    json.dump(dict(boot_id=BOOT, bit_sha256=BIT_SHA, pid=os.getpid()), out)
    out.flush()
    os.fsync(out.fileno())


def phase(name, **values):
    entry = dict(phase=name, boot_id=BOOT, bit_sha256=BIT_SHA, pid=os.getpid(),
                 monotonic_ns=time.monotonic_ns(), **values)
    with (LOG / 'probe-phases.jsonl').open('a') as stream:
        stream.write(json.dumps(entry, default=str) + '\n')
        stream.flush()
        os.fsync(stream.fileno())
    print(json.dumps(entry, default=str), flush=True)


sys.path.insert(0, str(RUNTIME / 'python'))
os.environ['XILINX_XRT'] = '/usr'
phase('before_import')
import pynq
from pynq_multimodal_game.agent.cli import _load_shared_vision_overlay
from pynq_multimodal_game.agent.c6i_backend import C6IOverlaySession
phase('after_import')


def loader(bitstream, *, download):
    phase('before_overlay_metadata')
    overlay = _load_shared_vision_overlay(bitstream, download=False)
    phase('after_overlay_metadata', osd_present='input_osd_0' in overlay.ip_dict)
    if download:
        phase('before_overlay_download')
        overlay.download()
        phase('after_overlay_download')
    return overlay


session = C6IOverlaySession(str(STAGE / 'c6v_candidate.bit'),
                           lock_path='/var/lock/voice-view-c6i.lock',
                           expected_build_id=0xC0060E00, overlay_factory=loader,
                           mmio_factory=pynq.MMIO, allocate=pynq.allocate)
phase('before_session_open')
try:
    session.open()
    phase('after_session_open')
    lease = session.borrow('hdmi-input-osd', instances=frozenset({'input_osd_0'}))
    try:
        address = session.ip_address(lease, STAGE / 'c6v_candidate.hwh', 'input_osd_0')
        assert address == (0x43C20000, 4096), address
        phase('before_osd_mmio_map', address=address)
        mmio = lease.mmio('input_osd_0')
        phase('after_osd_mmio_map')
        phase('before_osd_id_read')
        osd_id = int(mmio.read(0))
        phase('after_osd_id_read', osd_id=osd_id)
        assert osd_id == 0x4F534401, hex(osd_id)
        mmio = None
    finally:
        lease.close()
    phase('OSD_RESET_ID_PROBE_PASS')
finally:
    phase('before_session_close')
    session.close()
    phase('after_session_close')
