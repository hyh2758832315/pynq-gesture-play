"""Finish the original v2 Studio install after a pre-command SSH banner timeout.

Run: .venv/Scripts/python.exe -B -u tools/v2_finish_uploaded.py
Outputs: build/studio-v2/recovery/receipt.json and updated ui-system.json.
Next: isolated board acceptance. No second upload/transaction or force stop.
"""
import hashlib
import json
from pathlib import Path
import sys
import time
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession,DeviceState
from pynq_multimodal_game.studio.system_loader import SystemLoader,run_process
out=ROOT/'build/studio-v2'
source=ROOT/'games_gesture/.loads/d44167e8388c493dbc3e830fd2d16509/receipt.json'
r=json.loads(source.read_text(encoding='utf-8'));assert r['result']=='FAIL'
assert [s['name'] for s in r['steps']][-1]=='uploaded'
tid=r['transaction'];identity=r['manifest_sha256'];archive_sha=hashlib.sha256(source.with_name('package.tar.gz').read_bytes()).hexdigest()
code='tid='+repr(tid)+'\nidentity='+repr(identity)+'\narchive_sha='+repr(archive_sha)+'''
import json,hashlib
from pathlib import Path
base=Path('/home/xilinx/voice-view-game');meta=base/'.studio-system'/tid
assert not (meta/'start.json').exists() and not (base/('studio-system-'+tid)).exists()
assert hashlib.sha256((meta/'package.tar.gz').read_bytes()).hexdigest()==archive_sha
assert json.loads((meta/'prepare.json').read_text())['manifest_sha256']==identity
print(json.dumps(dict(original_upload_sha256=archive_sha,installation_not_started=True)))
'''
raw=run_process(['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','ConnectTimeout=20',
    'pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=60)
(out/'uploaded-verified.json').write_bytes(raw)
def runner(argv,**kwargs):return run_process(['ConnectTimeout=20' if a=='ConnectTimeout=8' else a for a in argv],**kwargs)
d=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000)
loader=SystemLoader(d,runner=runner)
installed=loader.remote('install',tid,identity)
r=dict(r,steps=[*r['steps'],dict(name='installed',result=installed)],original_failure=str(source))
observed=out/'installed-observation.json';observed.write_text(json.dumps(r,indent=2),encoding='utf-8')
print('Original Studio transaction installed; waiting for normal Agent READY',flush=True)
try:
    deadline=time.monotonic()+600
    while d.connect().state is not DeviceState.READY:
        if time.monotonic()>deadline:raise TimeoutError('Normal Agent readiness not confirmed')
        time.sleep(3)
    recovered=loader.confirm_installed(observed,out/'recovery')
    assert recovered['result']=='PASS'
    (out/'ui-system.json').write_text(json.dumps(dict(result='PASS',studio_framework=True,
        receipt=str(out/'recovery/receipt.json'),original_native_failure=str(source)),indent=2),encoding='utf-8')
    print('PASS: original Studio install and identity/readiness confirmed',flush=True)
finally:d.disconnect()
