# Run via remote.py; output unique receipt; inspect before next board phase.
import json,pathlib
assert pathlib.Path('/proc/sys/kernel/random/boot_id').read_text().strip()=='92f1a779-d821-46cd-a8d1-69a2a26cbc1f'
import ast,hashlib,os,subprocess,sys
root=pathlib.Path('/home/xilinx/voice-view-game/c6i-pl-vision-volume-osd-r21-marker-r02-20261023')

manifest=json.loads((root/'deployment_manifest.json').read_text())
for name,digest in manifest['sha256'].items():
    path=root/name
    assert hashlib.sha256(path.read_bytes()).hexdigest().upper()==digest
    if name.endswith('.py'):ast.parse(path.read_text(encoding='utf-8-sig'),filename=name,feature_version=(3,10))
env=dict(os.environ,PYTHONPATH=str(root/'python'),PYTHONDONTWRITEBYTECODE='1')
commands=[[sys.executable,'-B',str(root/'tools/check_admission_package.py')],[sys.executable,'-B',str(root/'start_board_test.py'),'--check-only','--game-controls'],
          [sys.executable,'-B',str(root/'start_board_test.py'),'--check-only','--game-controls','--volume-disable-sampling']]
for command in commands:
    result=subprocess.run(command,cwd=root,env=env,capture_output=True,text=True,timeout=120)
    print(json.dumps(dict(command=command,returncode=result.returncode,stdout=result.stdout,stderr=result.stderr,hardware_access=False)),flush=True)
    assert result.returncode==0
print('C0E_ARM_SHA_AST_AND_PREFLIGHT_PASS',flush=True)
