"""Finish the pending native R48 installation with default-hand video acceptance.
Run: .venv/Scripts/python.exe -B -u tools/r53_r48_finish.py
Output: build/studio-r53-r48-final/closure.json and linked native/API receipts.
Next: keep the installed default service and normal menu; no gesture injection.
"""
from pathlib import Path
import json
import argparse
import subprocess
import sys
import time
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession
from pynq_multimodal_game.studio.system_loader import SystemLoader,run_process
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output',type=Path,default=ROOT/'build/studio-r53-r48-final')
parser.add_argument('--candidate',type=Path,default=ROOT/'build/ps-ui-r53-video-hand-pause-candidate-r48')
parser.add_argument('--refresh-autostart',action='store_true')
parser.add_argument('--game-check',action='store_true')
parser.add_argument('--only-games',nargs='+',help='Rerun changed-package replays while retaining earlier unchanged-package evidence')
parser.add_argument('--reuse-content',action='store_true',help='Reuse a prior complete native content receipt after a test owner exits')
args=parser.parse_args()
out=args.output.resolve()
candidate=str(args.candidate.resolve())
record=dict(result='RUNNING',steps=[])
def save(): (out/'closure.json').write_text(json.dumps(record,indent=2),encoding='utf-8')
def run(args):
    print('START '+args[0],flush=True)
    subprocess.run([sys.executable,'-B','-u',*args],cwd=ROOT,check=True)
    record['steps'].append(args);save()
try:
    save();deadline=time.monotonic()+1200
    while not (out/'ui-system.json').exists():
        if time.monotonic()>deadline:raise TimeoutError('Native installation receipt not ready')
        time.sleep(2)
    ui=json.loads((out/'ui-system.json').read_text(encoding='utf-8'));assert ui['result']=='PASS',ui
    system=json.loads(Path(ui['receipt']).read_text(encoding='utf-8'));assert system['result']=='PASS'
    record['system_receipt']=ui['receipt'];save()
    if args.reuse_content:
        content_ui=json.loads((out/'ui-content.json').read_text(encoding='utf-8'))
        assert content_ui['result']=='PASS'
        assert json.loads(Path(content_ui['receipt']).read_text(encoding='utf-8'))['status']=='complete'
    else:
        run(['tools/r53_studio_load_content.py','--output',str(out)])
    if args.game_check:
        from uuid import uuid4
        run(['tools/r53_accept_board.py','--output',str(out),'--skip-videos','--check-restart',
             '--remote','/home/xilinx/voice-view-game/r54-game-'+uuid4().hex]
             + (['--only-games',*args.only_games] if args.only_games is not None else []))
    device=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000)
    released=(dict(running=False,owners=[]) if args.game_check else
              SystemLoader(device).remote('stop',system['transaction'],system['manifest_sha256']))
    (out/'installed-stop.json').write_text(json.dumps(released,indent=2),encoding='utf-8')
    assert not released['running'] and not released['owners']
    if args.refresh_autostart:
        run(['tools/install_studio_autostart.py','--enable-hand','--candidate',candidate,'--output',str(out)])
    run_process(['ssh','-b','192.168.2.1','-o','ConnectTimeout=8','pynq-z2',
        'sudo -n systemctl enable voice-view-shell.service && sudo -n systemctl start --no-block voice-view-shell.service'],timeout=30)
    record['default_start_requested']=True;save()
    run(['tools/studio_r48_connect_check.py','--tag','after-restart','--candidate',candidate,'--output',str(out)])
    run(['tools/r53_video_accept.py','--output',str(out),'--candidate',candidate])
    final=out/'final-studio';final.mkdir(exist_ok=True)
    run(['tools/studio_r48_connect_check.py','--tag','after-restart','--candidate',candidate,
         '--output',str(final),'--allow-hand-wait'])
    record['result']='PASS'
except BaseException as error:
    record.update(result='FAIL',error=str(error));raise
finally:save()
