"""Continue only readiness confirmation of the already-running Studio load.

Run: .venv/Scripts/python.exe -B -u tools/studio_r60_continue_load.py
Output: build/studio-r60-live/ui-system.json and recovery/receipt.json.
Next: synchronize the verified games, then start the normal default service.
No upload, hardware restart, game playback, input injection or preview.
"""
import json
from pathlib import Path
import sys,time
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.system_loader import SystemLoader,run_process
from pynq_multimodal_game.studio.device import RemoteDeviceSession,DeviceState
out=ROOT/'build/studio-r60-live'
original=ROOT/'games_gesture/.loads/d704f915f8e64fad9cc5d19bc581572a/receipt.json'
receipt=json.loads(original.read_text(encoding='utf-8'))
tid=receipt['transaction'];assert tid=='70df5689e1b747739206289443b72160'
code=f"""import json
from pathlib import Path
p=Path('/home/xilinx/voice-view-game/.studio-system')/{tid!r}
start=p/'start.json'
print(json.dumps(dict(start=json.loads(start.read_text()) if start.exists() else None,
 console=(p/'console.log').read_text(errors='replace').splitlines()[-5:] if (p/'console.log').exists() else [])))
"""
deadline=time.monotonic()+900
while True:
    try:
        state=json.loads(run_process(['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','ConnectTimeout=20',
            'pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=40))
    except (RuntimeError,TimeoutError) as error:
        print('Waiting for installer connection: '+str(error),flush=True)
        if time.monotonic()>deadline:raise
        time.sleep(15)
        continue
    if state['start']:break
    if time.monotonic()>deadline:raise TimeoutError('Original installer has not committed its startup receipt; no new process started')
    time.sleep(15)
assert state['start']['manifest_sha256']==receipt['manifest_sha256']
receipt=dict(receipt,steps=[*receipt['steps'],dict(name='installed',result=state['start'])],
             original_native_receipt=str(original),launcher_exit=1)
observed=out/'installed-observation.json'
observed.write_text(json.dumps(receipt,indent=2),encoding='utf-8')
print('Original Studio transaction installed; awaiting normal Agent READY',flush=True)
d=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000,timeout=3)
try:
    deadline=time.monotonic()+600
    while d.connect().state is not DeviceState.READY:
        if time.monotonic()>deadline:raise TimeoutError('Agent readiness not confirmed')
        time.sleep(3)
    r=SystemLoader(d).confirm_installed(observed,out/'recovery')
    result=dict(result=r['result'],studio_framework=True,native_install=str(original),
                receipt=str(out/'recovery/receipt.json'),hand_enabled=False,preview=False,input_injected=False)
    (out/'ui-system.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps(result),flush=True)
finally:d.disconnect()
