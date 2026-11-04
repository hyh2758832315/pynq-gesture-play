"""Install the PC-verified resume repair through Studio and accept real GPU output.
Run: .venv/Scripts/python.exe -B -u tools/r53_r47_pipeline.py
Outputs: build/studio-r53-r47/{pipeline,ui-system,ui-content,board-acceptance}.json.
Next: inspect acceptance and default-service restoration receipts. No forced cleanup.
"""
from pathlib import Path
import json
import subprocess
import sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.system_loader import run_process

out=ROOT/'build/studio-r53-r47'
candidate='build/ps-ui-r53-video-resume-candidate-r47'
record=dict(result='RUNNING',steps=[])

def save():
    (out/'pipeline.json').write_text(json.dumps(record,indent=2),encoding='utf-8')

def run(args):
    print('START '+args[0],flush=True)
    subprocess.run([sys.executable,'-B','-u',*args],cwd=ROOT,check=True)
    record['steps'].append(args);save()

restore=r'''
import json,sys,subprocess
from pathlib import Path
sys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')
import system_board as b
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
active=subprocess.run(['systemctl','is-active','--quiet','voice-view-shell.service']).returncode==0
if not active:
 b.gate(None,boot)
 subprocess.run(['systemctl','enable','voice-view-shell.service'],check=True)
 subprocess.run(['systemctl','start','--no-block','voice-view-shell.service'],check=True)
print(json.dumps(dict(boot_id=boot,already_active=active,start_requested=not active)))
'''

try:
    save()
    run(['tools/studio_r45_system_load.py','--deploy','--candidate',candidate,'--output',str(out)])
    run(['tools/r53_studio_load_content.py','--output',str(out)])
    run(['tools/r53_accept_board.py','--output',str(out),
         '--remote','/home/xilinx/voice-view-game/r53-menu-acceptance-a04'])
    record['result']='PASS'
except BaseException as error:
    record.update(result='FAIL',error=str(error));raise
finally:
    try:
        raw=run_process(['ssh','-b','192.168.2.1','-o','ConnectTimeout=8','pynq-z2',
            'sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=restore.encode(),timeout=30)
        record['restoration']=json.loads(raw)
        save()
        run(['tools/studio_r48_connect_check.py','--tag','after-restart',
             '--candidate',candidate,'--output',str(out)])
        record['default_restored']=True
    except BaseException as error:
        record['restoration_error']=str(error)
        record['result']='FAIL'
    save()
