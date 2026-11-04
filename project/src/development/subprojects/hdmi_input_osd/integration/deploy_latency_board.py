"""C0E identity-bound board phases, only after the user's completed-hand-test handover.
Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/deploy_latency_board.py ACTION
Actions: stage, arm, base, start, ready, inspect. No action on import.
Outputs: exclusive c0e-bNN receipts and var/pl-live-b01 on the independent board root.
Next: first-frame/STOP/restart, same-frame masks, GPU goldens/modes and matched latency/resource tests.
Never force-kill owners, delete locks, or repeat a failed hardware phase without diagnosis.
"""
import argparse,ast,hashlib,json,subprocess
from pathlib import Path
from board_common import HERE,REPO,remote,save,load,inspect_source,SSH
CHILD=REPO/'deliveries/c6i-pl-vision-volume-osd-r17-20261023'
BOARD='/home/xilinx/voice-view-game/'+CHILD.name
LOG='var/pl-live-b01'
def boot():
    state=json.loads(load('c0e-b01-readonly-handover')['stdout'])
    assert not state['processes'] and not state['hardware_mappers']
    return state['boot_id']
def prefix():
    return f"import json,pathlib\nassert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()=={boot()!r}\n"
def stage():
    package=load('latency-package-r01')
    archive=CHILD.with_suffix('.zip')
    assert package['status']=='C0E_PACKAGE_RESTORED_AND_PC_PREFLIGHT_PASS'
    assert hashlib.sha256(archive.read_bytes()).hexdigest()==package['sha256']
    file_count=len(json.loads((CHILD/'deployment_manifest.json').read_text())['sha256'])
    remote('c0e-b02-stage-create',prefix()+f"import os,pwd\nroot=pathlib.Path({BOARD!r})\nassert not root.exists()\nroot.mkdir()\np=pwd.getpwnam('xilinx')\nos.chown(root,p.pw_uid,p.pw_gid)\nprint('C0E_STAGE_CREATED')\n")
    command=['scp','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','BindAddress=192.168.2.1',str(archive),'pynq-z2:'+BOARD+'/package.zip']
    r=subprocess.run(command,capture_output=True,text=True,timeout=120)
    save('c0e-b02-stage-upload',dict(command=command,returncode=r.returncode,stdout=r.stdout,stderr=r.stderr))
    assert r.returncode==0
    source=prefix()+f"import hashlib,zipfile\nexpected_file_count={file_count}\nroot=pathlib.Path({BOARD!r})\nassert hashlib.sha256((root/'package.zip').read_bytes()).hexdigest()=={package['sha256']!r}\n"
    source+="""
with zipfile.ZipFile(root/'package.zip') as archive:
    assert archive.testzip() is None
    names=archive.namelist()
    assert len(names)==len(set(names))==expected_file_count+1
    for member in names:
        prefix_name=root.name+'/'
        assert member.startswith(prefix_name)
        relative=member[len(prefix_name):]
        destination=(root/relative).resolve()
        assert destination.is_relative_to(root) and not destination.exists()
        destination.parent.mkdir(parents=True,exist_ok=True)
        with destination.open('xb') as output:output.write(archive.read(member))
manifest=json.loads((root/'deployment_manifest.json').read_text())
assert manifest['build_id']=='0xC0060E00' and len(manifest['sha256'])==expected_file_count
for name,digest in manifest['sha256'].items():
    target=(root/name).resolve()
    assert target.is_relative_to(root) and hashlib.sha256(target.read_bytes()).hexdigest().upper()==digest,name
print(json.dumps(dict(stage='C0E_SHA_VERIFIED',files=len(manifest['sha256']),hardware_access=False)),flush=True)
"""
    remote('c0e-b02-stage-restore',source,timeout=90)
def arm():
    source=prefix()+f"import ast,hashlib,os,subprocess,sys\nroot=pathlib.Path({BOARD!r})\n"
    source+="""
manifest=json.loads((root/'deployment_manifest.json').read_text())
for name,digest in manifest['sha256'].items():
    path=root/name
    assert hashlib.sha256(path.read_bytes()).hexdigest().upper()==digest
    if name.endswith('.py'):ast.parse(path.read_text(encoding='utf-8-sig'),filename=name,feature_version=(3,10))
env=dict(os.environ,PYTHONPATH=str(root/'python'),PYTHONDONTWRITEBYTECODE='1')
commands=[[sys.executable,'-B',str(root/'start_board_test.py'),'--check-only','--game-controls'],
          [sys.executable,'-B',str(root/'start_board_test.py'),'--check-only','--game-controls','--volume-disable-sampling']]
for command in commands:
    result=subprocess.run(command,cwd=root,env=env,capture_output=True,text=True,timeout=120)
    print(json.dumps(dict(command=command,returncode=result.returncode,stdout=result.stdout,stderr=result.stderr,hardware_access=False)),flush=True)
    assert result.returncode==0
print('C0E_ARM_SHA_AST_AND_PREFLIGHT_PASS',flush=True)
"""
    remote('c0e-b03-arm-preflight',source,timeout=240)
def base():
    assert load('c0e-b03-arm-preflight')['returncode']==0
    template=REPO/'results/game-validation/game-volume-fusion-20261022/round14/f130-game3-base-normal-stop.json'
    source=json.loads(template.read_text())['remote_code']
    oldroot='/home/xilinx/voice-view-game/vision-volume-c0c-r14-autonomous-20261022'
    assert oldroot in source and '13f0774f-963f-47b0-a505-282f07e20956' in source
    source=source.replace(oldroot,BOARD).replace('var/game3-live-20261022',LOG).replace(
        '13f0774f-963f-47b0-a505-282f07e20956',boot()).replace('0xC0060C00','0xC0060E00')
    tree=ast.parse(source)
    count=0
    for node in ast.walk(tree):
        if isinstance(node,ast.Constant) and type(node.value) is int and node.value==504:
            node.value=len(json.loads((CHILD/'deployment_manifest.json').read_text())['sha256']);count+=1
    assert count==1
    remote('c0e-b04-base-normal-stop',ast.unparse(ast.fix_missing_locations(tree)),timeout=90,hardware_access=True)
def start():
    assert load('c0e-b04-base-normal-stop')['returncode']==0
    supervisor=f"import json,os,pathlib,subprocess,sys\nroot=pathlib.Path({BOARD!r})\nlog=root/{LOG!r}\n"
    supervisor+="""
command=[sys.executable,'-u','-B',str(root/'start_board_test.py'),'--game-controls','--physical-audio-confirmed','--osd-test-stimuli']
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
"""
    code=prefix()+f"import fcntl,hashlib,os,subprocess,sys\nroot=pathlib.Path({BOARD!r})\nlog=root/{LOG!r}\n"
    code+="""
for process in pathlib.Path('/proc').glob('[0-9]*/maps'):
    try:
        maps=process.read_text()
        assert '/dev/mem' not in maps and '/dev/uio' not in maps,str(process)
    except (FileNotFoundError,ProcessLookupError):pass
journal=pathlib.Path('/var/lock/voice-view-c6i-volume-owner.json')
assert not journal.exists() or json.loads(journal.read_text())['state']=='CLEAN'
for name in ('/var/lock/voice-view-c6i.lock','/run/lock/voice_pcm_audio.lock'):
    if pathlib.Path(name).exists():
        with pathlib.Path(name).open('rb') as stream:fcntl.flock(stream.fileno(),fcntl.LOCK_EX|fcntl.LOCK_NB)
manifest=json.loads((root/'deployment_manifest.json').read_text())
assert manifest['build_id']=='0xC0060E00'
for name,digest in manifest['sha256'].items():assert hashlib.sha256((root/name).read_bytes()).hexdigest().upper()==digest
base=json.loads((log/'base-stop.json').read_text())
assert base['boot_id']==pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert log.is_dir() and not (log/'load.attempt').exists()
with (log/'load.attempt').open('x') as output:
    json.dump(dict(boot_id=base['boot_id'],build_id='0xC0060E00'),output);output.flush();os.fsync(output.fileno())
"""
    code+=f"with (log/'stdout.log').open('xb') as out,(log/'stderr.log').open('xb') as err:\n    proc=subprocess.Popen([sys.executable,'-u','-B','-c',{supervisor!r}],cwd=root,stdin=subprocess.DEVNULL,stdout=out,stderr=err,start_new_session=True)\nprint(json.dumps(dict(phase='C0E_AGENT_LAUNCH_REQUESTED',supervisor_pid=proc.pid,boot_id=base['boot_id'])),flush=True)\n"
    remote('c0e-b05r02-agent-start',code,timeout=45,hardware_access=True)
def ready():
    code=prefix()+f"import threading,time\nlog=pathlib.Path({BOARD!r})/{LOG!r}\ndeadline=time.monotonic()+75\n"
    code+="""
while not (log/'service-start.json').exists() or 'voice-view-agent listening' not in (log/'stdout.log').read_text():
    assert not (log/'service-exit.json').exists()
    assert time.monotonic()<deadline
    threading.Event().wait(.25)
print(json.dumps(dict(service_start=json.loads((log/'service-start.json').read_text()),
stdout=(log/'stdout.log').read_text(),stderr=(log/'stderr.log').read_text())),flush=True)
"""
    remote('c0e-b06-agent-ready',code,timeout=90)
def inspect():remote('c0e-b07-readonly-after-start',inspect_source(current=BOARD,log=LOG),timeout=45)
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('action',choices=('stage','arm','base','start','ready','inspect'))
    args=p.parse_args();globals()[args.action]()

