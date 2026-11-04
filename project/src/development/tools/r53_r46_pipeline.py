"""Continue the authorized R46 Studio/board acceptance and restore defaults.
Run: .venv/Scripts/python.exe -B -u tools/r53_r46_pipeline.py
Output: build/studio-r53/r46-pipeline.json and existing Studio/board receipts.
Never retries an installation or forcibly kills a hardware owner.
"""
from pathlib import Path
import sys,subprocess,time,json,shutil
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.system_loader import run_process
out=ROOT/'build/studio-r53';record=dict(result='RUNNING',steps=[])
def save(): (out/'r46-pipeline.json').write_text(json.dumps(record,indent=2),encoding='utf-8')
def run(args):
 print('START '+args[0],flush=True)
 subprocess.run([sys.executable,'-B','-u',*args],cwd=ROOT,check=True)
 record['steps'].append(args);save()
try:
 save();deadline=time.monotonic()+360
 while True:
  try:
   boot=run_process(['ssh','-b','192.168.2.1','-o','ConnectTimeout=5','pynq-z2','for u in bootpy.service clear_pl_statefile.service; do test $(systemctl show $u -p ActiveState --value) = inactive && test $(systemctl show $u -p Result --value) = success || exit 5; done; cat /proc/sys/kernel/random/boot_id'],timeout=12).decode().strip()
   if boot=='ae8046d6-f6c6-49a9-ab01-6d00dd02c70b':raise RuntimeError('Old boot remains')
   record['boot_id']=boot;save();break
  except Exception:
   if time.monotonic()>deadline:raise
   time.sleep(10)
 run(['tools/studio_r45_system_load.py','--deploy','--candidate','build/ps-ui-r53-snake-defaults-candidate-r46','--output','build/studio-r53-r46'])
 shutil.copyfile(out/'ui-system.json',out/'ui-system-r45-confirmed.json')
 shutil.copyfile(ROOT/'build/studio-r53-r46/ui-system.json',out/'ui-system.json')
 run(['tools/r53_studio_load_content.py'])
 run(['tools/r53_accept_board.py'])
 released=json.loads((out/'board-release.json').read_text());assert released['result']=='PASS' and released['owners']==[]
 raw=run_process(['ssh','-b','192.168.2.1','pynq-z2','sudo -n systemctl enable voice-view-shell.service && sudo -n systemctl start --no-block voice-view-shell.service'],timeout=30)
 record['default_service_restored']=True;save()
 run(['tools/studio_r48_connect_check.py','--tag','after-restart','--candidate','build/ps-ui-r53-snake-defaults-candidate-r46','--output','build/studio-r53'])
 record['result']='PASS'
except BaseException as error:
 record.update(result='FAIL',error=str(error));raise
finally:save()
