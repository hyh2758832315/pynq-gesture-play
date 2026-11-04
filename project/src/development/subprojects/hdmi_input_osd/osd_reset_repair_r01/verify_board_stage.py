"""Read-only SHA and ownership verification of the repaired OSD board stage.

Run through subprojects/marker_hand_bringup_20261024/remote.py with a fresh receipt.
Output: OSD_RESET_STAGE_VERIFIED and boot/SHA identities, or a failed receipt.
Next: stop only official Base trace DMAs, then perform one load/OSD ID probe.
"""
import hashlib
import json
from pathlib import Path
import subprocess

BOOT = 'ed3ea58a-1f10-41d7-94ae-64caec1cb94c'
ROOT = Path('/home/xilinx/voice-view-game/c6i-osd-reset-r22-probe-20261024/overlay')
EXPECTED = {
    'c6v_candidate.bit': '507833ade953e9fe33c51cf8ef0c76943026a8b2a3d8ed2ed93aa1c1f2c1cd42',
    'c6v_candidate.hwh': 'be2401b61307228c9c72d6f8963f7edc59b2f92e2bfb116c2c7a7a3abcdae097',
}
assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT
for name, expected in EXPECTED.items():
    assert hashlib.sha256((ROOT / name).read_bytes()).hexdigest() == expected, name
owners = []
for proc in Path('/proc').glob('[0-9]*'):
    try:
        maps = (proc / 'maps').read_text(errors='replace')
        if '/dev/mem' in maps or '/dev/uio' in maps:
            owners.append(proc.name)
    except (FileNotFoundError, ProcessLookupError):
        continue
assert not owners, owners
for name in ('/var/lock/voice-view-c6i.lock', '/run/lock/voice_pcm_audio.lock',
             '/var/lock/voice-view-c6i-volume-owner.json'):
    path = Path(name)
    assert not path.exists() or not path.read_bytes(), name
for name in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service'):
    result = subprocess.run(['systemctl', 'show', name, '-p', 'ActiveState', '-p', 'MainPID'],
                            capture_output=True, text=True, check=True, timeout=5)
    assert 'ActiveState=inactive' in result.stdout and 'MainPID=0' in result.stdout, name
print(json.dumps(dict(verdict='OSD_RESET_STAGE_VERIFIED', boot_id=BOOT, sha256=EXPECTED,
                      board_access='read-only', overlay_loaded=False)), flush=True)
