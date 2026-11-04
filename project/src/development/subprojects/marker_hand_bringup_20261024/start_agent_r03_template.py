"""Boot-bound R21 startup launcher with persistent diagnostics.

Run after Base stop and load-only pass via remote.py. Output: service-start,
stdout/stderr, startup-phases and volume-diagnostic under marker-hand-a03.
Next: inspect the service state and phase log before any protocol test.
"""
import base64
import fcntl
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

BOOT = '92f1a779-d821-46cd-a8d1-69a2a26cbc1f'
ROOT = Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
LOG = ROOT / 'var/marker-hand-20261024-a03'
WRAPPER_B64 = 'REPLACE_WITH_BASE64'
assert Path('/proc/sys/kernel/random/boot_id').read_text().strip() == BOOT
assert json.loads((LOG / 'base-stop.json').read_text())['boot_id'] == BOOT
assert (LOG / 'load-only.attempt').exists()
manifest = json.loads((ROOT / 'deployment_manifest.json').read_text())
assert manifest['build_id'] == '0xC0060E00'
for name, digest in manifest['sha256'].items():
    assert hashlib.sha256((ROOT / name).read_bytes()).hexdigest().upper() == digest, name
for process in Path('/proc').glob('[0-9]*/maps'):
    try:
        maps = process.read_text()
        assert '/dev/mem' not in maps and '/dev/uio' not in maps, str(process)
    except (FileNotFoundError, ProcessLookupError):
        pass
for name in ('/var/lock/voice-view-c6i.lock', '/run/lock/voice_pcm_audio.lock'):
    with open(name, 'rb') as stream:
        fcntl.flock(stream.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        assert not stream.read()
wrapper = base64.b64decode(WRAPPER_B64)
assert wrapper.startswith(b'"""R21 board startup')
with (LOG / 'load.attempt').open('x') as out:
    json.dump(dict(boot_id=BOOT, pid=os.getpid(), wrapper_sha256=hashlib.sha256(wrapper).hexdigest()), out)
    out.flush()
    os.fsync(out.fileno())
with (LOG / 'agent_entry.py').open('xb') as out:
    out.write(wrapper)
    out.flush()
    os.fsync(out.fileno())
diagnostics = LOG / 'volume-diagnostic'
diagnostics.mkdir()
supervisor_code = '''import json,os,pathlib,subprocess,sys
root=pathlib.Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')
log=root/'var/marker-hand-20261024-a03'
os.environ['VVG_C0C_DIAGNOSTIC_DIR']=str(log/'volume-diagnostic')
command=[sys.executable,'-u','-B',str(log/'agent_entry.py')]
worker=subprocess.Popen(command,cwd=root,stdin=subprocess.DEVNULL)
entry=dict(pid=worker.pid,start_ticks=pathlib.Path('/proc/'+str(worker.pid)+'/stat').read_text().rsplit(')',1)[1].split()[19],command=command,boot_id=pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip(),supervisor_pid=os.getpid())
with (log/'service-start.json').open('x') as output:
    json.dump(entry,output);output.flush();os.fsync(output.fileno())
code=worker.wait()
with (log/'service-exit.json').open('x') as output:
    json.dump(dict(returncode=code,pid=worker.pid,boot_id=entry['boot_id']),output);output.flush();os.fsync(output.fileno())
sys.exit(code)
'''
with (LOG / 'stdout.log').open('xb') as out, (LOG / 'stderr.log').open('xb') as err:
    supervisor = subprocess.Popen([sys.executable, '-u', '-B', '-c', supervisor_code],
                                  cwd=ROOT, stdin=subprocess.DEVNULL, stdout=out,
                                  stderr=err, start_new_session=True)
print(json.dumps(dict(phase='C0E_AGENT_LAUNCH_REQUESTED', supervisor_pid=supervisor.pid, boot_id=BOOT)), flush=True)
