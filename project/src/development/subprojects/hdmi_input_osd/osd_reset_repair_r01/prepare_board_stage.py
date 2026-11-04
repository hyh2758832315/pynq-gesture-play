"""Create an exclusive, inert directory for the repaired OSD bit/HWH pair.

Run through subprojects/marker_hand_bringup_20261024/remote.py with a fresh receipt.
Output: OSD_RESET_STAGE_READY plus the target path; no FPGA access.
Next: SCP the two files, then run verify_board_stage.py before any load.
"""
import json
import os
from pathlib import Path
import pwd
import subprocess

BOOT = 'ed3ea58a-1f10-41d7-94ae-64caec1cb94c'
DEST = Path('/home/xilinx/voice-view-game/c6i-osd-reset-r22-probe-20261024')
assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT
for proc in Path('/proc').glob('[0-9]*/maps'):
    try:
        value = proc.read_text(errors='replace')
        assert '/dev/mem' not in value and '/dev/uio' not in value, str(proc)
    except (FileNotFoundError, ProcessLookupError):
        continue
for name in ('/var/lock/voice-view-c6i.lock', '/run/lock/voice_pcm_audio.lock',
             '/var/lock/voice-view-c6i-volume-owner.json'):
    path = Path(name)
    assert not path.exists() or not path.read_bytes(), name
for name in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service'):
    result = subprocess.run(['systemctl', 'show', name, '-p', 'ActiveState', '-p', 'MainPID'],
                            capture_output=True, text=True, check=True, timeout=5)
    assert 'ActiveState=inactive' in result.stdout and 'MainPID=0' in result.stdout, name
assert not DEST.exists()
DEST.mkdir()
(DEST / 'overlay').mkdir()
identity = pwd.getpwnam('xilinx')
for path in (DEST, DEST / 'overlay'):
    os.chown(path, identity.pw_uid, identity.pw_gid)
print(json.dumps(dict(verdict='OSD_RESET_STAGE_READY', boot_id=BOOT, path=str(DEST),
                      overlay_loaded=False)), flush=True)
