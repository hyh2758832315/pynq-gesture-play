"""Validate real-hand/camera initialization across one home Restart.

Run: .venv/Scripts/python.exe -B tools/r52_validate_restart.py
Outputs: build/studio-r52/restart-*.json and restart-console.log.
Next: restore the enabled ordinary service and verify native Studio reconnect.
Uses exact owned PID cleanup; never force-kills or reloads a retained owner.
"""
import base64
import hashlib
import json
from pathlib import Path
import sys
import time
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession
from pynq_multimodal_game.studio.system_loader import SystemLoader,run_process
out=ROOT/'build/studio-r52';remote='/home/xilinx/voice-view-game/r52-restart-validation-a01'
receipt=json.loads(Path(json.loads((out/'ui-system.json').read_text())['receipt']).read_text())
assert receipt['result']=='PASS'
installed=next(s['result'] for s in receipt['steps'] if s['name']=='installed')
root=installed['root'];identity=receipt['manifest_sha256']
def py(code,timeout=180):
    return run_process(['ssh','-o','BatchMode=yes','-o','ConnectTimeout=8','-b','192.168.2.1',
        'pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=timeout)
def save(name,value):
    (out/name).write_text(json.dumps(value,indent=2))
device=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000,source_ids=())
stopped=SystemLoader(device).remote('stop',receipt['transaction'],identity)
save('restart-before-stop.json',stopped);assert not stopped['running'] and not stopped['owners']
raw=(ROOT/'tools/r52_restart_board.py').read_bytes();encoded=base64.b64encode(raw).decode()
record=json.loads(py(f"""import json,sys,subprocess,time,base64,hashlib
from pathlib import Path
sys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')
import system_board as b
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
b.verify(Path({root!r}),{identity!r});b.gate(None,boot)
folder=Path({remote!r});folder.mkdir(exist_ok=False)
data=base64.b64decode({encoded!r});assert hashlib.sha256(data).hexdigest()=={hashlib.sha256(raw).hexdigest()!r}
(folder/'r52_restart_board.py').write_bytes(data)
ordinary=b.field_command(Path({root!r}),lifetime_seconds=None)
command=[*ordinary[:3],str(folder/'r52_restart_board.py'),'--package',{root!r},'--arguments',json.dumps(ordinary[4:]),'--output',str(folder/'run')]
with (folder/'console.log').open('xb') as f:p=subprocess.Popen(command,stdout=f,stderr=subprocess.STDOUT,start_new_session=True)
print(json.dumps(dict(root={root!r},boot_id=boot,pid=p.pid,start_ticks=b.processes()[p.pid]['ticks'],started=time.time(),manifest_sha256={identity!r},hand_enabled=True)))
"""))
save('restart-owner.json',record);print('Restart validation PID '+str(record['pid']),flush=True)
deadline=time.monotonic()+350;last=None
while True:
    progress=json.loads(py(f"""import json
from pathlib import Path
p=Path({(remote+'/run/checks.json')!r});r=json.loads(p.read_text()) if p.exists() else {{}}
log=Path({(remote+'/console.log')!r}).read_text(errors='replace')
print(json.dumps(dict(result=r.get('result'),error=r.get('error'),ready=log.count('UI_SESSION_READY '),reexec='UI_RESTART_CLEANUP_CONFIRMED' in log)))
"""))
    if progress!=last:print(json.dumps(progress),flush=True);last=progress
    if progress.get('result')=='FAIL':raise RuntimeError('Restart test failed: '+str(progress))
    if progress.get('result')=='PASS' and progress['ready']>=2 and progress['reexec']:break
    if time.monotonic()>deadline:raise TimeoutError('Initialization incomplete; leave exact owner for diagnosis')
    time.sleep(5)
device.connect()
try:status=device.video_status()
finally:device.disconnect()
save('restart-after-status.json',status)
vision=status['snapshot']['vision'];hand=vision['hand_session']
assert vision['state']=='RUNNING' and not vision['last_error'] and hand['phase']=='ACTIVE' and not hand['error']
evidence=json.loads(py(f"""import json,sys
from pathlib import Path
sys.path.insert(0,{(root+'/python')!r})
from pynq_multimodal_game.startup_checks import verify_hand_readonly_report
sys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')
import system_board as b
before=json.loads(Path({(remote+'/run/before-restart.json')!r}).read_text())
old=before['vision'];new={vision!r}
assert old['run_id']!=new['run_id'] and old['hand_session']['session']!=new['hand_session']['session']
rows=b.processes();r={record!r};boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
assert r['pid'] in b.owned_tree(rows,r,boot)
probes=[]
for p in Path({(root+'/var/vision')!r}).glob('hand-readonly-*.json'):
    if p.stat().st_mtime<r['started']:continue
    v=json.loads(p.read_text());verify_hand_readonly_report(v,port='/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00',motor_ids=tuple(range(1,18)))
    probes.append(dict(path=str(p),sha256=b.sha(p),result=v['result'],motors=len(v['motors']),reads=v['read_requests']))
assert len(probes)==2
oldhand=json.loads((Path(before['hand_output'])/'serial-motion.json').read_text())
assert oldhand['backend_closed'] and set(oldhand['release_confirmed_ids'])==set(range(1,18)) and not oldhand.get('error')
oldvision=[json.loads(p.read_text()) for p in Path({(root+'/var/vision')!r}).rglob('stop_receipt.json') if json.loads(p.read_text()).get('run_id')==old['run_id']]
assert len(oldvision)==1 and oldvision[0]['cleanup_confirmed'] and not oldvision[0].get('error')
print(json.dumps(dict(result='PASS',same_pid=True,new_vision=new['run_id'],old_vision=old['run_id'],new_hand_session=new['hand_session']['session'],old_hand_session=old['hand_session']['session'],probes=probes,old_hand_receipt=oldhand,old_vision_receipt=oldvision[0])))
"""))
save('restart-evidence.json',evidence)
log=py(f"from pathlib import Path\nprint(Path({(remote+'/console.log')!r}).read_text())\n")
(out/'restart-console.log').write_bytes(log)
ready=[json.loads(line.split('UI_SESSION_READY ',1)[1]) for line in log.decode().splitlines() if line.startswith('UI_SESSION_READY ')]
assert ready[-1]['album_empty'] and ready[-1]['canvas_empty']
release=json.loads(py(f"""import json,sys
from pathlib import Path
sys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')
import system_board as b
r={record!r};boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
b.stop_owned(r,boot);b.gate(None,boot)
print(json.dumps(dict(result='PASS',owners=[])))
"""))
save('restart-release.json',release)
print(json.dumps(dict(result='PASS',real_hand_reinitialized=True,vision_reinitialized=True,released=True)),flush=True)
