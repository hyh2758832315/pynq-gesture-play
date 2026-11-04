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
WRAPPER_B64 = 'IiIiUjIxIGJvYXJkIHN0YXJ0dXAgd2l0aCBmc3luY2VkIGJvdW5kYXJpZXM7IHByb2R1Y3Rpb24gcGFja2FnZSBpcyB1bmNoYW5nZWQuCgpSdW4gdmlhIHN0YXJ0X2FnZW50X3IwMy5weSBhZnRlciBib290LWJvdW5kIEJhc2Ugc3RvcC4gT3V0cHV0OiBzdGFydHVwLXBoYXNlcy5qc29ubC4KTmV4dDogaW5zcGVjdCB0aGUgbGFzdCBwaGFzZSBhbmQgYm9hcmQgaGVhbHRoIGJlZm9yZSBhbnkgZnVydGhlciBoYXJkd2FyZSBhY3Rpb24uCiIiIgppbXBvcnQgZnVuY3Rvb2xzCmltcG9ydCBqc29uCmltcG9ydCBvcwpmcm9tIHBhdGhsaWIgaW1wb3J0IFBhdGgKaW1wb3J0IHJ1bnB5CmltcG9ydCBzeXMKaW1wb3J0IHRpbWUKClJPT1QgPSBQYXRoKCcvaG9tZS94aWxpbngvdm9pY2Utdmlldy1nYW1lL2M2aS1wbC12aXNpb24tdm9sdW1lLW9zZC1yMjEtbWFya2VyLXIwMi0yMDI2MTAyMycpCkxPRyA9IFJPT1QgLyAndmFyL21hcmtlci1oYW5kLTIwMjYxMDI0LWEwMycKQk9PVCA9ICc5MmYxYTc3OS1kODIxLTQ2Y2QtYThkMS02OWEyYTI2Y2JjMWYnCmFzc2VydCBQYXRoKCcvcHJvYy9zeXMva2VybmVsL3JhbmRvbS9ib290X2lkJykucmVhZF90ZXh0KCkuc3RyaXAoKSA9PSBCT09UCgpkZWYgcGhhc2UobmFtZSk6CiAgICB3aXRoIChMT0cgLyAnc3RhcnR1cC1waGFzZXMuanNvbmwnKS5vcGVuKCdhJykgYXMgb3V0OgogICAgICAgIG91dC53cml0ZShqc29uLmR1bXBzKGRpY3QocGhhc2U9bmFtZSwgcGlkPW9zLmdldHBpZCgpLCBtb25vdG9uaWNfbnM9dGltZS5tb25vdG9uaWNfbnMoKSkpICsgJ1xuJykKICAgICAgICBvdXQuZmx1c2goKQogICAgICAgIG9zLmZzeW5jKG91dC5maWxlbm8oKSkKCmRlZiBpbnN0cnVtZW50KHRhcmdldCwgbmFtZSwgbGFiZWwpOgogICAgb3JpZ2luYWwgPSBnZXRhdHRyKHRhcmdldCwgbmFtZSkKICAgIEBmdW5jdG9vbHMud3JhcHMob3JpZ2luYWwpCiAgICBkZWYgdHJhY2VkKCphcmdzLCAqKmt3YXJncyk6CiAgICAgICAgcGhhc2UoJ2JlZm9yZV8nICsgbGFiZWwpCiAgICAgICAgdHJ5OgogICAgICAgICAgICByZXN1bHQgPSBvcmlnaW5hbCgqYXJncywgKiprd2FyZ3MpCiAgICAgICAgZXhjZXB0IEJhc2VFeGNlcHRpb246CiAgICAgICAgICAgIHBoYXNlKCdlcnJvcl8nICsgbGFiZWwpCiAgICAgICAgICAgIHJhaXNlCiAgICAgICAgcGhhc2UoJ2FmdGVyXycgKyBsYWJlbCkKICAgICAgICByZXR1cm4gcmVzdWx0CiAgICBzZXRhdHRyKHRhcmdldCwgbmFtZSwgdHJhY2VkKQoKcGhhc2UoJ2JlZm9yZV9ydW50aW1lX2ltcG9ydCcpCnN5cy5wYXRoLmluc2VydCgwLCBzdHIoUk9PVCAvICdweXRob24nKSkKc3lzLnBhdGguaW5zZXJ0KDAsIHN0cihST09UIC8gJ2JvYXJkL3B5bnFfejIvc2NyaXB0cycpKQpmcm9tIHB5bnFfbXVsdGltb2RhbF9nYW1lLmFnZW50IGltcG9ydCBjbGkKZnJvbSBweW5xX211bHRpbW9kYWxfZ2FtZS5hZ2VudC5jNmlfYmFja2VuZCBpbXBvcnQgQzZJT3ZlcmxheVNlc3Npb24KZnJvbSBweW5xX211bHRpbW9kYWxfZ2FtZS5hZ2VudC5jNmlfc2hlbGwgaW1wb3J0IEM2SVNoZWxsUnVudGltZUJhY2tlbmQKZnJvbSBweW5xX211bHRpbW9kYWxfZ2FtZS5hZ2VudC52aXNpb25fYmFja2VuZCBpbXBvcnQgU2hhcmVkVmlzaW9uU3VwZXJ2aXNvcgpmcm9tIHB5bnFfbXVsdGltb2RhbF9nYW1lLmFnZW50Lm9zZF9iYWNrZW5kIGltcG9ydCBDNklPc2RSdW50aW1lQmFja2VuZApmcm9tIHB5bnFfbXVsdGltb2RhbF9nYW1lLmFnZW50LnRyYW5zcG9ydCBpbXBvcnQgQWdlbnRTZXJ2ZXIKZnJvbSBweW5xX211bHRpbW9kYWxfZ2FtZS5pbnB1dF9vc2QgaW1wb3J0IElucHV0T3NkU2VydmljZQpmcm9tIHZvaWNlX3ZvbHVtZV9mdXNpb24gaW1wb3J0IEJvcnJvd2VkVm9sdW1lQ29udHJvbAoKaW5zdHJ1bWVudChjbGksICdfbG9hZF9zaGFyZWRfdmlzaW9uX292ZXJsYXknLCAnb3ZlcmxheV9sb2FkJykKaW5zdHJ1bWVudChDNklPdmVybGF5U2Vzc2lvbiwgJ29wZW4nLCAnc2Vzc2lvbl9vcGVuJykKaW5zdHJ1bWVudChDNklTaGVsbFJ1bnRpbWVCYWNrZW5kLCAnb3BlbicsICdzaGVsbF9vcGVuJykKaW5zdHJ1bWVudChTaGFyZWRWaXNpb25TdXBlcnZpc29yLCAncHJlcGFyZScsICd2aXNpb25fcHJlcGFyZScpCmluc3RydW1lbnQoU2hhcmVkVmlzaW9uU3VwZXJ2aXNvciwgJ3N0YXJ0JywgJ3Zpc2lvbl9zdGFydCcpCmluc3RydW1lbnQoQm9ycm93ZWRWb2x1bWVDb250cm9sLCAnb3BlbicsICd2b2x1bWVfb3BlbicpCmluc3RydW1lbnQoSW5wdXRPc2RTZXJ2aWNlLCAnb3BlbicsICdvc2Rfb3BlbicpCmluc3RydW1lbnQoQzZJT3NkUnVudGltZUJhY2tlbmQsICdvcGVuJywgJ2JhY2tlbmRfb3BlbicpCmluc3RydW1lbnQoQWdlbnRTZXJ2ZXIsICdzdGFydCcsICdzZXJ2ZXJfc3RhcnQnKQoKb3JpZ2luYWxfZmFjdG9yeSA9IFNoYXJlZFZpc2lvblN1cGVydmlzb3IuX19pbml0X18KQGZ1bmN0b29scy53cmFwcyhvcmlnaW5hbF9mYWN0b3J5KQpkZWYgdHJhY2VkX2luaXQoc2VsZiwgd29ya2VyX2ZhY3RvcnksIGlucHV0X3Byb3ZpZGVyKToKICAgIEBmdW5jdG9vbHMud3JhcHMod29ya2VyX2ZhY3RvcnkpCiAgICBkZWYgdHJhY2VkX2ZhY3RvcnkocnVuX2lkKToKICAgICAgICBwaGFzZSgnYmVmb3JlX3Zpc2lvbl93b3JrZXJfZmFjdG9yeScpCiAgICAgICAgd29ya2VyID0gd29ya2VyX2ZhY3RvcnkocnVuX2lkKQogICAgICAgIHBoYXNlKCdhZnRlcl92aXNpb25fd29ya2VyX2ZhY3RvcnknKQogICAgICAgIGZvciBuYW1lIGluICgncHJlcGFyZV9wcmV2aWV3JywgJ3N0YXJ0Jyk6CiAgICAgICAgICAgIGlmIGhhc2F0dHIod29ya2VyLCBuYW1lKToKICAgICAgICAgICAgICAgIGluc3RydW1lbnQod29ya2VyLCBuYW1lLCAndmlzaW9uX3dvcmtlcl8nICsgbmFtZSkKICAgICAgICByZXR1cm4gd29ya2VyCiAgICByZXR1cm4gb3JpZ2luYWxfZmFjdG9yeShzZWxmLCB0cmFjZWRfZmFjdG9yeSwgaW5wdXRfcHJvdmlkZXIpClNoYXJlZFZpc2lvblN1cGVydmlzb3IuX19pbml0X18gPSB0cmFjZWRfaW5pdAoKcGhhc2UoJ2FmdGVyX3J1bnRpbWVfaW1wb3J0JykKc3lzLmFyZ3YgPSBbc3RyKFJPT1QgLyAnc3RhcnRfYm9hcmRfdGVzdC5weScpLCAnLS1nYW1lLWNvbnRyb2xzJywKICAgICAgICAgICAgJy0tcGh5c2ljYWwtYXVkaW8tY29uZmlybWVkJywgJy0tb3NkLXRlc3Qtc3RpbXVsaSddCnJ1bnB5LnJ1bl9wYXRoKHN0cihST09UIC8gJ3N0YXJ0X2JvYXJkX3Rlc3QucHknKSwgcnVuX25hbWU9J19fbWFpbl9fJykK'
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
