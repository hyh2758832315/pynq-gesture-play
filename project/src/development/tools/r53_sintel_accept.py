"""Accept the installed Sintel through Studio API without another system reload.
Run: .venv/Scripts/python.exe -B -u tools/r53_sintel_accept.py
Output: build/studio-r53-r47-sintel/acceptance.json (raw progress and identity).
Next: aggregate with R47 a04 games/AMD evidence. No injected gestures/motor commands.
"""
from pathlib import Path
import json
import sys
import time
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession,DeviceState
from pynq_multimodal_game.studio.system_loader import run_process,system_board

out=ROOT/'build/studio-r53-r47-sintel';out.mkdir(exist_ok=False)
candidate=ROOT/'build/ps-ui-r53-video-resume-candidate-r47'
identity=system_board.sha(candidate/'deployment_manifest.json')
receipt_path=Path(json.loads((ROOT/'build/studio-r53-r47/ui-content.json').read_text(encoding='utf-8'))['receipt'])
receipt=json.loads(receipt_path.read_text(encoding='utf-8'));assert receipt['status']=='complete'
item=next(i for i in receipt['items'] if i['kind']=='video' and i['frames']==5400)
record=dict(result='RUNNING',manifest_sha256=identity,content_receipt=str(receipt_path),
            physical_board=True,input_injected=False,motor_commands=False,preview=False,samples=[],checks=[])
device=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000,timeout=3)
started=False
def save(): (out/'acceptance.json').write_text(json.dumps(record,indent=2),encoding='utf-8')
def check(name,value):
    record['checks'].append(dict(name=name,passed=bool(value)));save()
    print(name+(' PASS' if value else ' FAIL'),flush=True)
    if not value:raise AssertionError(name)
def status():
    reply=device.video_status();assert reply['ok'];s=reply['snapshot']
    assert not s.get('last_error'),s
    return s
try:
    save()
    code="""import json,hashlib,subprocess
from pathlib import Path
p=Path('/home/xilinx/voice-view-game/.studio-system/active.json')
r=json.loads(p.read_text());r['actual_manifest_sha256']=hashlib.sha256((Path(r['root'])/'deployment_manifest.json').read_bytes()).hexdigest()
r['service_active']=subprocess.run(['systemctl','is-active','--quiet','voice-view-shell.service']).returncode==0
r['service_enabled']=subprocess.run(['systemctl','is-enabled','--quiet','voice-view-shell.service']).returncode==0
print(json.dumps(r))
"""
    raw=run_process(['ssh','-b','192.168.2.1','-o','ConnectTimeout=8','pynq-z2',
        '/usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=30)
    owner=json.loads(raw);record['production_owner']=owner
    check('installed-default-identity',owner['manifest_sha256']==identity==owner['actual_manifest_sha256']
          and owner['service_active'] and owner['service_enabled'])
    assert device.connect().state is DeviceState.READY
    listing=device.list_library()['library_items']
    check('sintel-studio-identity',any(i['item_id']==item['item_id'] and i['sha256']==item['sha256']
          and i['length']==item['length'] for i in listing))
    check('production-menu-before',status()['runtime_mode']=='menu')
    assert device.play_library_item(item['item_id'],library_kind='video')['ok'];started=True
    begin=time.monotonic();deadline=begin+450;next_notice=0
    while True:
        snap=status();assert snap['active_sha256']==item['sha256']
        record['samples'].append(dict(elapsed=time.monotonic()-begin,frame=snap['frame_index'],
                                     presented=snap['presented_frames'],loops=snap['completed_loops']))
        save()
        if time.monotonic()>next_notice:
            print('SINTEL '+str(snap['frame_index'])+'/5400 loops='+str(snap['completed_loops']),flush=True)
            next_notice=time.monotonic()+30
        if (snap.get('completed_loops') or 0)>=1:break
        if time.monotonic()>deadline:raise TimeoutError('Sintel full loop incomplete')
        time.sleep(5)
    check('sintel-full-loop',snap['presented_frames']>=5400 and snap['frame_count']==5400)
    paused=device.pause_video();check('sintel-pause',paused['snapshot']['state']=='paused')
    before=paused['snapshot']['presented_frames']
    assert device.seek_video(2700)['ok'];assert device.start_video()['ok']
    deadline=time.monotonic()+15
    while True:
        time.sleep(1);snap=status()
        if snap['presented_frames']>=before+3:break
        if time.monotonic()>deadline:raise TimeoutError('Seek did not present new frames')
    check('sintel-seek-resume',snap['state']=='running' and snap['frame_index']>=2700)
    before=snap['presented_frames'];assert device.start_video()['ok'];time.sleep(1)
    check('sintel-repeat-run',status()['presented_frames']>before)
    stopped=device.stop_video();started=False
    check('sintel-return',stopped['ok'] and stopped['snapshot']['runtime_mode']=='menu')
    final=status();record['final_snapshot']=final
    check('vision-and-default-hand',final['vision']['state']=='RUNNING'
          and not final['vision'].get('last_error')
          and final['vision']['hand_session']['phase']=='ACTIVE'
          and not final['vision']['hand_session'].get('error'))
    record['result']='PASS'
except BaseException as error:
    record.update(result='FAIL',error=str(error));raise
finally:
    if started:
        try:record['failure_return']=device.stop_video()
        except BaseException as error:record['failure_return_error']=str(error)
    device.disconnect();save()
