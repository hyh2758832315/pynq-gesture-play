"""Studio API video acceptance on the installed default service, hand held OFF.
Run: .venv/Scripts/python.exe -B -u tools/r53_video_accept.py
Outputs: build/studio-r53-r48-final/videos.json with identity, frame and OFF evidence.
Next: retain normal menu/service; resume requires fresh real vision input.
No injected gestures, motor test commands, image subscription or Overlay reload.
"""
from pathlib import Path
import json
import argparse
import sys
import time
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession,DeviceState
from pynq_multimodal_game.studio.system_loader import run_process,system_board

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output',type=Path,default=ROOT/'build/studio-r53-r48-final')
parser.add_argument('--candidate',type=Path,default=ROOT/'build/ps-ui-r53-video-hand-pause-candidate-r48')
parser.add_argument('--resume-sintel',action='store_true',help='Observe the already-started Sintel after a client reply timeout; never replay PLAY')
args=parser.parse_args()
out=args.output.resolve()
candidate=args.candidate.resolve()
identity=system_board.sha(candidate/'deployment_manifest.json')
receipt_path=Path(json.loads((out/'ui-content.json').read_text(encoding='utf-8'))['receipt'])
receipt=json.loads(receipt_path.read_text(encoding='utf-8'));assert receipt['status']=='complete'
record=dict(result='RUNNING',manifest_sha256=identity,content_receipt=str(receipt_path),
            input_injected=False,motor_test_commands=False,preview=False,checks=[],videos={})
device=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000,timeout=3)
started=False
def save(): (out/('sintel-continuation.json' if args.resume_sintel else 'videos.json')).write_text(json.dumps(record,indent=2),encoding='utf-8')
def check(name,value):
    record['checks'].append(dict(name=name,passed=bool(value)));save()
    print(name+(' PASS' if value else ' FAIL'),flush=True)
    if not value:raise AssertionError(name)
def remote(code):
    return json.loads(run_process(['ssh','-b','192.168.2.1','-o','ConnectTimeout=8','pynq-z2',
        'sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=30))
def status():
    reply=device.video_status();assert reply['ok'];s=reply['snapshot']
    assert not s.get('last_error'),s
    return s
def off(s):
    hand=s['vision']['hand_session']
    assert hand['phase']=='PAUSED' and hand['video_paused'] is True and hand['preview_allowed'] is True,hand
    assert not hand.get('error'),hand
    return hand
try:
    save()
    owner=remote("""import json,hashlib,subprocess
from pathlib import Path
r=json.loads(Path('/home/xilinx/voice-view-game/.studio-system/active.json').read_text())
r['actual_manifest_sha256']=hashlib.sha256((Path(r['root'])/'deployment_manifest.json').read_bytes()).hexdigest()
r['service_active']=subprocess.run(['systemctl','is-active','--quiet','voice-view-shell.service']).returncode==0
r['service_enabled']=subprocess.run(['systemctl','is-enabled','--quiet','voice-view-shell.service']).returncode==0
print(json.dumps(r))
""")
    record['production_owner']=owner
    check('installed-default-identity',owner['manifest_sha256']==identity==owner['actual_manifest_sha256']
          and owner['service_active'] and owner['service_enabled'])
    if (candidate/'hand-runtime').is_dir():
        command=owner['command']
        check('default-uses-bundled-hand',
              command[command.index('--hand-readonly-root')+1]==owner['root']+'/hand-runtime')
    assert device.connect().state is DeviceState.READY
    listing=device.list_library()['library_items']
    for item in receipt['items']:
        check(item['item_id']+'-studio-identity',any(i['item_id']==item['item_id']
            and i['sha256']==item['sha256'] and i['length']==item['length'] for i in listing))
    check('production-mode-before',status()['runtime_mode']==('video' if args.resume_sintel else 'menu'))
    for item in receipt['items']:
        if item['kind']!='video':continue
        if args.resume_sintel and item['frames']!=5400:continue
        name=item['item_id'];detail=record['videos'][name]=dict(samples=[])
        if not args.resume_sintel:
            assert device.play_library_item(name,library_kind='video')['ok']
        started=True
        hand=off(status())
        detail['off_receipt']=remote("""import json
from pathlib import Path
values=[]
for p in Path(ROOT).rglob('control-state.json'):
 v=json.loads(p.read_text())
 if v.get('session')==SESSION and v.get('pid')==PID:values.append(dict(path=str(p),receipt=v))
assert len(values)==1
print(json.dumps(values[0]))
""".replace('ROOT',repr(owner['root']+'/var/vision')).replace('SESSION',repr(hand['session'])).replace('PID',str(hand['child_pid'])))
        off_receipt=detail['off_receipt']['receipt']
        check(name+'-17-off-before-play',off_receipt['phase']=='PAUSED'
            and off_receipt['release_confirmed_ids']==list(range(1,18))
            and off_receipt['controller']['lifecycle']=='CONNECTED_OFF'
            and off_receipt['controller']['enable_epoch'] is None)
        begin=time.monotonic();deadline=begin+item['frames']/20+180;next_notice=0
        while True:
            snap=status();off(snap);assert snap['active_sha256']==item['sha256']
            detail['samples'].append(dict(elapsed=time.monotonic()-begin,frame=snap['frame_index'],
                presented=snap['presented_frames'],loops=snap['completed_loops']))
            save()
            if time.monotonic()>next_notice:
                print(name+' '+str(snap['frame_index'])+'/'+str(item['frames']),flush=True)
                next_notice=time.monotonic()+30
            if (snap.get('completed_loops') or 0)>=1:break
            if time.monotonic()>deadline:raise TimeoutError('Full loop incomplete: '+name)
            time.sleep(5)
        check(name+'-full-loop',snap['presented_frames']>=item['frames'] and snap['frame_count']==item['frames'])
        paused=device.pause_video();check(name+'-pause',paused['snapshot']['state']=='paused')
        before=paused['snapshot']['presented_frames']
        assert device.seek_video(item['frames']//2)['ok'];assert device.start_video()['ok']
        deadline=time.monotonic()+15
        while True:
            time.sleep(1);snap=status();off(snap)
            if snap['presented_frames']>=before+3:break
            if time.monotonic()>deadline:raise TimeoutError('Seek did not present new frames')
        check(name+'-seek-resume',snap['state']=='running' and snap['frame_index']>=item['frames']//2)
        before=snap['presented_frames'];assert device.start_video()['ok'];time.sleep(1)
        snap=status();off(snap);check(name+'-repeat-run',snap['presented_frames']>before)
        stopped=device.stop_video();started=False
        check(name+'-return',stopped['ok'] and stopped['snapshot']['runtime_mode']=='menu')
        check(name+'-hand-pause-cleared',stopped['snapshot']['vision']['hand_session']['video_paused'] is False)
    deadline=time.monotonic()+5
    while True:
        final=status()
        current=final['vision']['hand_session']
        if current['phase']!='PAUSED' or current.get('error') or time.monotonic()>=deadline:break
        time.sleep(.2)
    record['final_snapshot']=final
    hand=final['vision']['hand_session']
    check('vision-and-hand-recovery',final['vision']['state']=='RUNNING'
        and not final['vision'].get('last_error') and not hand.get('error')
        and hand['phase'] in ('ACTIVE','RESUMING','WAITING_SOURCE','WAITING_SOURCE_OFF')
        and hand['video_paused'] is False)
    record['result']='PASS'
except BaseException as error:
    record.update(result='FAIL',error=str(error));raise
finally:
    if started:
        try:record['failure_return']=device.stop_video()
        except BaseException as error:record['failure_return_error']=str(error)
    device.disconnect();save()
