"""Restore the accepted installed system to the normal default hand service.

Run: .venv/Scripts/python.exe -B tools/v2_restore_normal.py
Output: build/studio-v2/normal-start.json, normal-ready.json. Next: player control.
No test input, image preview or experiment duration limit; closes after readiness.
"""
import hashlib
import json
from pathlib import Path
import sys
import time
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.system_loader import SystemLoader,run_process
from pynq_multimodal_game.studio.device import RemoteDeviceSession,DeviceState
out=ROOT/'build/studio-v2'
ui=json.loads((out/'ui-system.json').read_text(encoding='utf-8'))
r=json.loads(Path(ui['receipt']).read_text(encoding='utf-8'));assert r['result']=='PASS'
identity=r['manifest_sha256']
assert identity==hashlib.sha256((ROOT/'build/ps-ui-v2-canvas-menu-r02/deployment_manifest.json').read_bytes()).hexdigest()
code='expected='+repr(identity)+'''
import json,subprocess,sys
from pathlib import Path
base=Path('/home/xilinx/voice-view-game/.studio-system');sys.path.insert(0,str(base/'boot'))
import system_board as b
a=json.loads((base/'active.json').read_text());assert a['manifest_sha256']==expected
config=json.loads((base/'boot/config.json').read_text());assert config['hand_enabled'] is True
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip();b.gate(None,boot)
command=b.field_command(Path(a['root']),lifetime_seconds=None)
assert '--hand-serial-seconds' not in command
subprocess.run(['systemctl','enable','voice-view-shell.service'],check=True)
subprocess.run(['systemctl','start','--no-block','voice-view-shell.service'],check=True)
print(json.dumps(dict(result='PASS',root=a['root'],command=command,preview=False,input_injected=False)))
'''
raw=run_process(['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','ConnectTimeout=20',
 'pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=60)
(out/'normal-start.json').write_bytes(raw)
d=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000)
try:
    deadline=time.monotonic()+600
    while d.connect().state is not DeviceState.READY:
        if time.monotonic()>deadline:raise TimeoutError('Normal service readiness unconfirmed')
        time.sleep(3)
    snapshot=d.video_status()['snapshot'];h=snapshot['vision']['hand_session']
    assert not snapshot.get('last_error') and not h.get('error') and h['max_seconds'] is None
    assert not h['preview_allowed'] and not h['video_paused']
    (out/'normal-ready.json').write_text(json.dumps(dict(result='READY',manifest_sha256=identity,
        snapshot=snapshot,input_injected=False,extra_observer=False),indent=2),encoding='utf-8')
    print('READY: normal service, bundled hand, real camera; no validation input or duration limit')
finally:d.disconnect()
