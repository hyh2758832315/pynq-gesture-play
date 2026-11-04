"""Guard normal R43 board startup/shutdown for Studio content acceptance.

Run on PYNQ: sudo -n /usr/bin/python3 studio_r44_board_guard.py start load-a01
Outputs: /home/xilinx/voice-view-game/r44-studio-load/<label>/{start,stop}.json,console.log.
Next: test Studio loading, then invoke this file with stop and the same label.
No hand option, test-input hook, MMIO probe or persistent service is installed.
"""
import hashlib
import json
import os
from pathlib import Path
import re
import signal
import subprocess
import sys
import tarfile
import time

BASE = Path('/home/xilinx/voice-view-game')
ROOT = BASE / 'ps-ui-r43-creative-board-candidate-r31'
EXPECTED = 'd20cdba183227abe26494db43bad2580c5c3263252446aad9db7e94db104320a'
action, label = sys.argv[1:]
assert action in ('start', 'stop', 'status') and re.fullmatch(r'[a-z0-9-]+', label)
out = BASE / 'r44-studio-load' / label

def busy():
    result = []
    for proc in Path('/proc').glob('[0-9]*'):
        try:
            argv = (proc/'cmdline').read_bytes().split(b'\0')
            if any(Path(a.decode(errors='replace')).name in ('start_board_test.py', 'serial_motion_receiver.py',
                    'project1_live_ov5640.py', 'capture_camera_direct_plug.py') for a in argv):
                result.append(dict(pid=proc.name, command=b' '.join(argv).decode(errors='replace')))
            for fd in (proc/'fd').iterdir():
                try:
                    target = os.readlink(fd)
                    if target == '/dev/mem' or target.startswith(('/dev/uio', '/dev/ttyACM', '/dev/ttyUSB')):
                        result.append(dict(pid=proc.name, fd=str(fd), target=target))
                except OSError: pass
        except (OSError, ProcessLookupError): pass
    return result

boot = Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert hashlib.sha256((ROOT/'deployment_manifest.json').read_bytes()).hexdigest() == EXPECTED
if action == 'start':
    assert not busy(), busy()
    manifest = json.loads((ROOT/'deployment_manifest.json').read_text())
    for name, digest in manifest['sha256'].items():
        assert hashlib.sha256((ROOT/name).read_bytes()).hexdigest().upper() == digest, name
    out.mkdir(parents=True, exist_ok=False)
    with tarfile.open(out/'library-before.tar.gz', 'w:gz') as archive:
        archive.add(ROOT/'var/library', arcname='library')
    command = ['/usr/local/share/pynq-venv/bin/python', '-B', '-u', str(ROOT/'start_board_test.py')]
    with (out/'console.log').open('wb') as stream:
        child = subprocess.Popen(command, cwd=ROOT, stdout=stream, stderr=subprocess.STDOUT, start_new_session=True)
    start = dict(boot_id=boot, pid=child.pid, start_ticks=Path('/proc',str(child.pid),'stat').read_text().split()[21],
                 started=time.time(), manifest_sha256=EXPECTED, files=len(manifest['sha256']),
                 hand_enabled=False, command=command)
    (out/'start.json').write_text(json.dumps(start,indent=2))
    print(json.dumps(start),flush=True)
elif action == 'status':
    print(json.dumps(dict(boot_id=boot, owners=busy(), console=(out/'console.log').read_text(errors='replace').splitlines()[-30:])),flush=True)
else:
    start=json.loads((out/'start.json').read_text())
    assert start['boot_id']==boot
    proc=Path('/proc',str(start['pid']))
    if proc.exists() and proc.joinpath('stat').read_text().split()[2] != 'Z':
        assert proc.joinpath('stat').read_text().split()[21]==start['start_ticks']
        assert str(ROOT/'start_board_test.py').encode() in proc.joinpath('cmdline').read_bytes().split(b'\0')
        os.kill(start['pid'],signal.SIGINT)
        deadline=time.monotonic()+45
        while proc.exists() and proc.joinpath('stat').read_text().split()[2]!='Z' and time.monotonic()<deadline:
            time.sleep(.2)
    receipts={}
    for p in (ROOT/'var/vision').rglob('stop_receipt.json'):
        if p.stat().st_mtime>=start['started']:
            receipts[str(p.relative_to(ROOT))]=json.loads(p.read_text())
    owners=busy()
    clean=bool(receipts) and all(r.get('cleanup_confirmed') and r.get('error') is None for r in receipts.values())
    result=dict(boot_id=boot,pid=start['pid'],hardware_owners=owners,vision_receipts=receipts,
                board_released=not owners and clean)
    (out/'stop.json').write_text(json.dumps(result,indent=2))
    print(json.dumps(result),flush=True)
    if not result['board_released']: raise SystemExit(1)
