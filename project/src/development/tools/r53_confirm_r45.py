from pathlib import Path
import sys,json,time
sys.path.insert(0,'python')
from pynq_multimodal_game.studio.system_loader import run_process,SystemLoader
from pynq_multimodal_game.studio.device import RemoteDeviceSession,DeviceState
out=Path('build/studio-r53');original=json.loads((out/'ui-system.json').read_text(encoding='utf-8'));r=json.loads(Path(original['receipt']).read_text(encoding='utf-8'))
(out/'ui-system-r45-timeout.json').write_text(json.dumps(original,indent=2))
raw=run_process(['ssh','-b','192.168.2.1','pynq-z2','cat /home/xilinx/voice-view-game/.studio-system/'+r['transaction']+'/start.json'],timeout=30)
installed=json.loads(raw);assert installed['manifest_sha256']==r['manifest_sha256']
r['steps'].append(dict(name='installed',result=installed));r['recovery_of']=original['receipt']
p=out/'r45-observed-install.json';p.write_text(json.dumps(r,indent=2),encoding='utf-8')
d=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000,timeout=3)
try:
 deadline=time.monotonic()+600
 while d.connect().state is not DeviceState.READY:
  if time.monotonic()>deadline:raise TimeoutError('Same installed process not ready; do not restart')
  time.sleep(10)
 confirmed=SystemLoader(d).confirm_installed(p,out/'r45-confirmation')
 (out/'ui-system.json').write_text(json.dumps(dict(result='PASS',receipt=str((out/'r45-confirmation/receipt.json').resolve()),physical_board=True,studio_framework=True,hand_enabled=False),indent=2),encoding='utf-8')
 print('R45 READY confirmed',flush=True)
finally:d.disconnect()

