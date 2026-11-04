"""Launch one boot-bound R22 Agent with fsynced phase and process receipts.

Run via remote.py only after fresh board_gate.py passes; entry script staged by SCP.
Output: var/osd-reset-20261024-a02/{service-start,stdout,stderr,startup-phases}.
Next: inspect logs/owners/ports before any Agent protocol action.
"""
import fcntl
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

BOOT = 'ed3ea58a-1f10-41d7-94ae-64caec1cb94c'
HOME = Path('/home/xilinx/voice-view-game')
ROOT = HOME / 'c6i-pl-vision-volume-osd-r22-osd-reset-r01-20261024'
OLD_LOG = HOME / 'c6i-pl-vision-volume-osd-r21-marker-r02-20261023/var/osd-reset-20261024-a01'
LOG = ROOT / 'var/osd-reset-20261024-a02'
ENTRY = HOME / 'osd-reset-r22-agent-entry-r01.py'
ENTRY_SHA = '9198628f327d294dff080b68df78ab7847f78d2cbbff07ca063e0fa30c81064e'
BIT_SHA = '507833ade953e9fe33c51cf8ef0c76943026a8b2a3d8ed2ed93aa1c1f2c1cd42'
assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT
assert not LOG.exists() and ENTRY.is_file()
assert hashlib.sha256(ENTRY.read_bytes()).hexdigest() == ENTRY_SHA
assert json.loads((OLD_LOG / 'base-stop.json').read_text())['boot_id'] == BOOT
assert (OLD_LOG / 'osd-probe.attempt').exists()
assert 'OSD_RESET_ID_PROBE_PASS' in (OLD_LOG / 'probe-phases.jsonl').read_text()
manifest = json.loads((ROOT / 'deployment_manifest.json').read_text())
assert manifest['bit_sha256'].lower() == BIT_SHA
for name, digest in manifest['sha256'].items():
    path = (ROOT / name).resolve()
    assert path.is_relative_to(ROOT) and hashlib.sha256(path.read_bytes()).hexdigest().upper() == digest, name
for proc in Path('/proc').glob('[0-9]*/maps'):
    try:
        maps = proc.read_text(errors='replace')
        assert '/dev/mem' not in maps and '/dev/uio' not in maps, str(proc)
    except (FileNotFoundError, ProcessLookupError):
        continue
for lock in ('/var/lock/voice-view-c6i.lock', '/run/lock/voice_pcm_audio.lock'):
    with open(lock, 'rb') as stream:
        fcntl.flock(stream.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        assert not stream.read(), lock
for service in ('bootpy.service', 'clear_pl_statefile.service', 'voice-view-shell.service'):
    state = subprocess.run(['systemctl', 'show', service, '-p', 'ActiveState', '-p', 'MainPID'],
                           capture_output=True, text=True, check=True, timeout=5).stdout
    assert 'ActiveState=inactive' in state and 'MainPID=0' in state, service
check = subprocess.run([sys.executable, '-B', str(ROOT / 'start_board_test.py'), '--check-only'],
                       cwd=ROOT, capture_output=True, text=True, timeout=90)
assert check.returncode == 0, dict(stdout=check.stdout[-3000:], stderr=check.stderr[-3000:])
LOG.mkdir(parents=True)
with (LOG / 'load.attempt').open('x') as output:
    json.dump(dict(boot_id=BOOT, entry_sha256=ENTRY_SHA, bit_sha256=BIT_SHA,
                   launcher_pid=os.getpid(), check_stdout=check.stdout[-2000:]), output)
    output.flush()
    os.fsync(output.fileno())
supervisor_code = '''import json,os,pathlib,subprocess,sys
root=pathlib.Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r22-osd-reset-r01-20261024')
log=root/'var/osd-reset-20261024-a02'
entry=pathlib.Path('/home/xilinx/voice-view-game/osd-reset-r22-agent-entry-r01.py')
os.environ['VVG_C0C_DIAGNOSTIC_DIR']=str(log/'volume-diagnostic')
command=[sys.executable,'-u','-B',str(entry)]
worker=subprocess.Popen(command,cwd=root,stdin=subprocess.DEVNULL)
record=dict(pid=worker.pid,start_ticks=pathlib.Path('/proc/'+str(worker.pid)+'/stat').read_text().rsplit(')',1)[1].split()[19],command=command,boot_id=pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip(),supervisor_pid=os.getpid())
with (log/'service-start.json').open('x') as out:
 json.dump(record,out);out.flush();os.fsync(out.fileno())
code=worker.wait()
with (log/'service-exit.json').open('x') as out:
 json.dump(dict(returncode=code,pid=worker.pid,boot_id=record['boot_id']),out);out.flush();os.fsync(out.fileno())
sys.exit(code)
'''
(LOG / 'volume-diagnostic').mkdir()
with (LOG / 'stdout.log').open('xb') as stdout, (LOG / 'stderr.log').open('xb') as stderr:
    supervisor = subprocess.Popen([sys.executable, '-u', '-B', '-c', supervisor_code],
                                  cwd=ROOT, stdin=subprocess.DEVNULL, stdout=stdout,
                                  stderr=stderr, start_new_session=True)
print(json.dumps(dict(verdict='OSD_RESET_R22_AGENT_LAUNCH_REQUESTED', boot_id=BOOT,
                      supervisor_pid=supervisor.pid, root=str(ROOT))), flush=True)
