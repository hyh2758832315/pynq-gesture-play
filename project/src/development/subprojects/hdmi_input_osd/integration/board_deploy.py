"""Explicit board phases; immutable receipts, normal stop and owner gates.

Run with approved board network: python -B .../board_deploy.py ACTION
Actions: stage -> preflight -> stop -> closed -> start -> ready.
Output: evidence/g16.. receipts and unique board runtime/log directory.
Next: automated OSD/HDMI modes, eight goldens, A/B and stability checks.
If normal cleanup fails, stop here; never force kill, delete locks or reload.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

from board_common import BOARD, CHILD, HERE, LOG, OLD, OLD_LOG, load, remote, save, inspect_source


def stage():
    sealed = load("g15-package")
    archive = CHILD.with_suffix(".zip")
    assert sealed["status"] == "PACKAGE_RESTORED_AND_PREFLIGHT_PASS"
    assert hashlib.sha256(archive.read_bytes()).hexdigest() == sealed["sha256"]
    remote("g16-stage-create", f"import os,pathlib,pwd\nroot=pathlib.Path({BOARD!r})\nassert not root.exists()\nroot.mkdir()\nowner=pwd.getpwnam('xilinx')\nos.chown(root,owner.pw_uid,owner.pw_gid)\nprint('NEW_STAGE_CREATED')\n")
    command = ["scp", "-o", "BatchMode=yes", "-o", "BindAddress=192.168.2.1", str(archive), "pynq-z2:" + BOARD + "/candidate.zip"]
    result = subprocess.run(command, capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=180)
    save("g16-scp", dict(command=command, returncode=result.returncode, stdout=result.stdout, stderr=result.stderr))
    assert result.returncode == 0, result.stderr
    source = f"import ast,hashlib,json,os,pathlib,subprocess,sys,zipfile\nroot=pathlib.Path({BOARD!r})\nexpected={sealed['sha256']!r}\n"
    source += '''archive=root/'candidate.zip'
assert hashlib.sha256(archive.read_bytes()).hexdigest()==expected
with zipfile.ZipFile(archive) as stream:
    assert stream.testzip() is None
    names=stream.namelist()
    manifests=[n for n in names if n.endswith('/deployment_manifest.json')]
    assert len(manifests)==1 and len(names)==len(set(names))
    prefix=manifests[0][:-len('deployment_manifest.json')]
    manifest=json.loads(stream.read(manifests[0]))
    assert manifest['build_id']=='0xC0060D00' and manifest['release_ready'] is False
    assert set(names)=={prefix+n for n in manifest['sha256']}|{manifests[0]}
    for name,digest in manifest['sha256'].items():
        path=(root/name).resolve()
        assert path.is_relative_to(root)
        data=stream.read(prefix+name)
        assert hashlib.sha256(data).hexdigest().upper()==digest,name
        if name.endswith('.py'):
            ast.parse(data.decode('utf-8-sig'),filename=name,feature_version=(3,10))
        path.parent.mkdir(parents=True,exist_ok=True)
        with path.open('xb') as output: output.write(data)
    with (root/'deployment_manifest.json').open('xb') as output: output.write(stream.read(manifests[0]))
print(json.dumps(dict(phase='ARM_STAGE_SHA_AST_PASS',files=len(manifest['sha256']),hardware_access=False)),flush=True)
environment=dict(os.environ,PYTHONPATH=str(root/'python'),VVG_OSD_TEST_ROOT=str(root),VVG_OSD_TEST_TMP=str(root/'var/offline-contract-tmp'))
commands=[[sys.executable,'-B',str(root/'start_board_test.py'),'--check-only','--game-controls'],
          [sys.executable,'-B',str(root/'tools/osd_runtime_contract.py')]]
for command in commands:
    result=subprocess.run(command,cwd=root,env=environment,capture_output=True,text=True,encoding='utf-8',timeout=120)
    print(json.dumps(dict(command=command,returncode=result.returncode,stdout=result.stdout,stderr=result.stderr,hardware_access=False)),flush=True)
    assert result.returncode==0
'''
    remote("g16-stage-arm-contract", source, timeout=180)


def preflight():
    remote("g16-old-preflight", inspect_source())


def stop():
    state = json.loads(load("g16-old-preflight")["stdout"])
    expected = state["service_start"]
    assert state["service_exit"] is None and expected["boot_id"] == state["boot_id"]
    source = f"import json,os,pathlib,signal\nexpected={expected!r}\nroot=pathlib.Path({OLD!r})/{OLD_LOG!r}\n"
    source += '''assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()==expected['boot_id']
assert json.loads((root/'service-start.json').read_text())==expected
assert not (root/'service-exit.json').exists()
process=pathlib.Path('/proc')/str(expected['pid'])
assert process.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]==expected['start_ticks']
assert process.joinpath('cmdline').read_bytes().split(bytes([0]))[:-1]==[s.encode() for s in expected['command']]
'''
    source += f"destination=pathlib.Path({BOARD!r})/{LOG!r}\ndestination.mkdir(parents=True)\n"
    source += '''with (destination/'stop-old.attempt').open('x') as output:
    json.dump(dict(identity=expected,forced=False),output)
    output.flush();os.fsync(output.fileno())
print(json.dumps(dict(phase='IDENTITY_BOUND_NORMAL_SIGTERM_ONCE',identity=expected)),flush=True)
os.kill(expected['pid'],signal.SIGTERM)
'''
    remote("g17-normal-stop-old", source)


def closed():
    source = "import contextlib,io,json,threading,time\nsource=" + repr(inspect_source()) + "\ndeadline=time.monotonic()+45\n"
    source += '''while True:
    buffer=io.StringIO()
    with contextlib.redirect_stdout(buffer): exec(compile(source,'<readonly>','exec'),{})
    state=json.loads(buffer.getvalue())
    if state['service_exit'] is not None and not state['processes'] and not state['hardware_mappers']: break
    if time.monotonic()>=deadline: break
    threading.Event().wait(.5)
print(json.dumps(state),flush=True)
assert state['service_exit'] is not None and state['service_exit']['returncode']==0
assert not state['processes'] and not state['hardware_mappers']
assert all(':'+str(p) not in state['ports'] for p in (8765,8081,8771))
assert all(entry['available'] and entry['bytes']==0 for entry in state['locks'].values())
assert state['volume_journal']['state']=='CLEAN'
'''
    remote("g17-old-clean-closed", source, timeout=60)


def start():
    receipt = load("g17-old-clean-closed")
    assert receipt["returncode"] == 0
    state = json.loads(receipt["stdout"])
    boot = state["boot_id"]
    supervisor = f"import json,os,pathlib,subprocess,sys\nroot=pathlib.Path({BOARD!r})\nlog=root/{LOG!r}\n"
    supervisor += '''command=[sys.executable,'-u','-B',str(root/'start_board_test.py'),'--game-controls','--physical-audio-confirmed','--osd-test-stimuli']
diagnostics=log/'volume-diagnostic'
diagnostics.mkdir()
os.environ['VVG_C0C_DIAGNOSTIC_DIR']=str(diagnostics)
worker=subprocess.Popen(command,cwd=root,stdin=subprocess.DEVNULL)
entry=dict(pid=worker.pid,start_ticks=pathlib.Path('/proc/'+str(worker.pid)+'/stat').read_text().rsplit(')',1)[1].split()[19],
           command=command,boot_id=pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip(),supervisor_pid=os.getpid())
with (log/'service-start.json').open('x') as output:
    json.dump(entry,output);output.flush();os.fsync(output.fileno())
code=worker.wait()
with (log/'service-exit.json').open('x') as output:
    json.dump(dict(returncode=code,pid=worker.pid,boot_id=entry['boot_id']),output);output.flush();os.fsync(output.fileno())
sys.exit(code)
'''
    source = f"import fcntl,hashlib,json,os,pathlib,subprocess,sys\nroot=pathlib.Path({BOARD!r})\nboot={boot!r}\nlog=root/{LOG!r}\n"
    source += '''assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()==boot
manifest=json.loads((root/'deployment_manifest.json').read_text())
assert manifest['build_id']=='0xC0060D00' and manifest['board_pending'] is True and manifest['release_ready'] is False
for name,digest in manifest['sha256'].items():
    path=(root/name).resolve()
    assert path.is_relative_to(root) and hashlib.sha256(path.read_bytes()).hexdigest().upper()==digest,name
for process in pathlib.Path('/proc').glob('[0-9]*/maps'):
    try:
        maps=process.read_text()
        assert '/dev/mem' not in maps and '/dev/uio' not in maps,str(process)
    except (FileNotFoundError,ProcessLookupError): pass
assert json.loads(pathlib.Path('/var/lock/voice-view-c6i-volume-owner.json').read_text())['state']=='CLEAN'
for name in ('/var/lock/voice-view-c6i.lock','/run/lock/voice_pcm_audio.lock'):
    with pathlib.Path(name).open('rb') as stream:
        fcntl.flock(stream.fileno(),fcntl.LOCK_EX|fcntl.LOCK_NB)
'''
    source += f"old=pathlib.Path({OLD!r})/{OLD_LOG!r}\n"
    source += '''assert json.loads((old/'service-exit.json').read_text())['returncode']==0
base=json.loads((old/'base-stop.json').read_text())
assert base['boot_id']==boot
with (log/'base-stop.json').open('x') as output:
    json.dump(dict(base,inherited_same_boot=True,source=str(old/'base-stop.json')),output)
with (log/'load.attempt').open('x') as output:
    json.dump(dict(boot_id=boot,build_id='0xC0060D00'),output);output.flush();os.fsync(output.fileno())
'''
    source += f"with (log/'stdout.log').open('xb') as output,(log/'stderr.log').open('xb') as error:\n    supervisor=subprocess.Popen([sys.executable,'-u','-B','-c',{supervisor!r}],cwd=root,stdin=subprocess.DEVNULL,stdout=output,stderr=error,start_new_session=True)\nprint(json.dumps(dict(phase='C0D_AGENT_LAUNCH_REQUESTED',supervisor_pid=supervisor.pid,boot_id=boot)),flush=True)\n"
    remote("g18-c0d-start", source, hardware_access=True)


def ready():
    source = f"import json,pathlib,threading,time\nroot=pathlib.Path({BOARD!r})/{LOG!r}\ndeadline=time.monotonic()+75\n"
    source += '''while not (root/'service-start.json').exists() or 'voice-view-agent listening' not in (root/'stdout.log').read_text():
    assert not (root/'service-exit.json').exists()
    assert time.monotonic()<deadline
    threading.Event().wait(.25)
print(json.dumps(dict(service_start=json.loads((root/'service-start.json').read_text()),stdout=(root/'stdout.log').read_text(),stderr=(root/'stderr.log').read_text())),flush=True)
'''
    remote("g18-c0d-ready", source, timeout=90)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=("stage", "preflight", "stop", "closed", "start", "ready"))
    args = parser.parse_args()
    globals()[args.action]()
