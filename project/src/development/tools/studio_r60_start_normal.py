"""Start the existing normal autostart service after the Studio R60 upgrade.

Run: .venv/Scripts/python.exe -B -u tools/studio_r60_start_normal.py
Output: build/studio-r60-live/normal-start.json and ready.json.
Next: close this deployment client and let the player use HDMI normally.
No automated gestures, gameplay, preview or periodic test observer.
"""
import hashlib,json,time
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession,DeviceState
from pynq_multimodal_game.studio.system_loader import SystemLoader,run_process
out=ROOT/'build/studio-r60-live'
assert json.loads((out/'content-install.json').read_text(encoding='utf-8'))['result']=='PASS'
ui=json.loads((out/'ui-system.json').read_text(encoding='utf-8'))
r=json.loads(Path(ui['receipt']).read_text(encoding='utf-8'));assert r['result']=='PASS'
d=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000)
stopped=SystemLoader(d).remote('stop',r['transaction'],r['manifest_sha256'])
assert not stopped['running'] and not stopped['owners']
(out/'installed-stop.json').write_text(json.dumps(stopped,indent=2),encoding='utf-8')
sha=hashlib.sha256((ROOT/'python/pynq_multimodal_game/studio/system_autostart.py').read_bytes()).hexdigest()
code='expected='+repr(r['manifest_sha256'])+'\nhelper_sha='+repr(sha)+'''
import json,sys,hashlib,subprocess
from pathlib import Path
base=Path('/home/xilinx/voice-view-game/.studio-system')
sys.path.insert(0,str(base/'boot'))
import system_board as b
a=json.loads((base/'active.json').read_text());config=json.loads((base/'boot/config.json').read_text())
assert a['manifest_sha256']==expected and config['hand_enabled'] is True
assert hashlib.sha256((base/'boot/system_autostart.py').read_bytes()).hexdigest()==helper_sha
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip();b.gate(None,boot)
assert subprocess.run(['systemctl','is-enabled','--quiet','voice-view-shell.service']).returncode==0
command=b.field_command(Path(a['root']),lifetime_seconds=None)
assert '--hand-serial-seconds' not in command
subprocess.run(['systemctl','start','--no-block','voice-view-shell.service'],check=True)
print(json.dumps(dict(result='PASS',root=a['root'],command=command,preview=False,input_injected=False)))
'''
raw=run_process(['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','ConnectTimeout=20','pynq-z2',
    'sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=45)
(out/'normal-start.json').write_bytes(raw)
print('Normal service startup requested; real camera and bundled hand, no duration limit',flush=True)
try:
    deadline=time.monotonic()+600
    while d.connect().state is not DeviceState.READY:
        if time.monotonic()>deadline:raise TimeoutError('Normal service not ready; no automatic restart')
        time.sleep(3)
    deadline=time.monotonic()+90
    while True:
        status=d.video_status()['snapshot'];hand=status['vision']['hand_session']
        if status.get('last_error') or hand.get('error'):raise RuntimeError('Normal startup error: '+repr(status))
        if hand['phase']=='ACTIVE':break
        if time.monotonic()>deadline:raise TimeoutError('Normal hand startup still waiting')
        time.sleep(3)
    assert hand['max_seconds'] is None and not hand['preview_allowed'] and not hand['video_paused']
    ready=dict(result='READY',manifest_sha256=r['manifest_sha256'],snapshot=status,
        preview=False,input_injected=False,automated_gameplay=False,extra_observer=False)
    (out/'ready.json').write_text(json.dumps(ready,indent=2),encoding='utf-8')
    print('READY: deployment connection closing; pure real-camera player control',flush=True)
finally:d.disconnect()
