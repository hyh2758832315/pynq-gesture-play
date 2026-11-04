"""Verify and extract the inert R22 package on the current idle PYNQ boot.

Run via subprojects/marker_hand_bringup_20261024/remote.py.
Output: OSD_RESET_R22_BOARD_STAGE_PASS with archive and candidate identities.
Next: fresh owner gate, then start one instrumented integrated Agent instance.
"""
import hashlib
import json
from pathlib import Path, PurePosixPath
import subprocess
import zipfile

BOOT = 'ed3ea58a-1f10-41d7-94ae-64caec1cb94c'
NAME = 'c6i-pl-vision-volume-osd-r22-osd-reset-r01-20261024'
HOME = Path('/home/xilinx/voice-view-game')
ZIP = HOME / (NAME + '.zip')
ROOT = HOME / NAME
SHA = 'b156d72ddf24b9056e86040e67373e806913343afc5b57be1d1cc345b792230e'
assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT
assert not ROOT.exists() and ZIP.is_file()
assert hashlib.sha256(ZIP.read_bytes()).hexdigest() == SHA
for proc in Path('/proc').glob('[0-9]*/maps'):
    try:
        maps = proc.read_text(errors='replace')
        assert '/dev/mem' not in maps and '/dev/uio' not in maps, str(proc)
    except (FileNotFoundError, ProcessLookupError):
        continue
for service in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service'):
    state = subprocess.run(['systemctl', 'show', service, '-p', 'ActiveState', '-p', 'MainPID'],
                           capture_output=True, text=True, check=True, timeout=5).stdout
    assert 'ActiveState=inactive' in state and 'MainPID=0' in state, service
with zipfile.ZipFile(ZIP) as archive:
    names = archive.namelist()
    assert len(names) == len(set(names))
    for name in names:
        path = PurePosixPath(name)
        assert path.parts and path.parts[0] == NAME and '..' not in path.parts and not path.is_absolute(), name
    archive.extractall(HOME)
manifest = json.loads((ROOT / 'deployment_manifest.json').read_text())
assert manifest['bit_sha256'].lower() == '507833ade953e9fe33c51cf8ef0c76943026a8b2a3d8ed2ed93aa1c1f2c1cd42'
for name, expected in manifest['sha256'].items():
    path = (ROOT / name).resolve()
    assert path.is_relative_to(ROOT) and hashlib.sha256(path.read_bytes()).hexdigest().upper() == expected, name
check = subprocess.run(['/usr/local/share/pynq-venv/bin/python', '-B',
                        str(ROOT / 'tools/check_admission_package.py')],
                       cwd=ROOT, capture_output=True, text=True, check=True, timeout=60)
assert 'R22_OSD_RESET_PACKAGE_OFFLINE_CHECK_PASS' in check.stdout
print(json.dumps(dict(verdict='OSD_RESET_R22_BOARD_STAGE_PASS', boot_id=BOOT,
                      root=str(ROOT), archive_sha256=SHA, files=len(manifest['sha256']),
                      package_check=json.loads(check.stdout))), flush=True)
