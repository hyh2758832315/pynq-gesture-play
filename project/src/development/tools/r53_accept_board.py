"""Accept Studio's exact six artifacts on PYNQ and check the four menu cards.

Run: .venv/Scripts/python.exe -B tools/r53_accept_board.py
Outputs: build/studio-r53/{board-acceptance,board-release,menu-checks}.json,
PC/PYNQ replay comparisons and the ordinary board console.
Next: restore the default enabled service and verify native Studio reconnect.
Real GPU/camera, temporary UI input, no physical hand or image subscription.
"""
import base64
import argparse
import hashlib
import json
from pathlib import Path
import sys
import time
from zipfile import ZipFile
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession,DeviceState
from pynq_multimodal_game.studio.system_loader import SystemLoader,run_process
from pynq_multimodal_game.game_validation import compare_test_reports
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output',type=Path,default=ROOT/'build/studio-r53')
parser.add_argument('--remote',default='/home/xilinx/voice-view-game/r53-menu-acceptance-a03')
parser.add_argument('--video-id',help='Limit video acceptance to this installed item')
parser.add_argument('--skip-replays',action='store_true',help='Keep prior replay evidence; run menu and video checks only')
parser.add_argument('--skip-videos',action='store_true',help='Verify actual menu and all game replays, then release for default-hand video tests')
parser.add_argument('--check-restart',action='store_true',help='After games, exercise the actual home return/restart UI and verify new vision initialization')
parser.add_argument('--only-games',nargs='+',help='Limit replay reruns to changed packages; menu checks still cover all four games')
parser.add_argument('--only-case',help='Limit replay diagnosis to this JSON stem')
args=parser.parse_args()
out=args.output.resolve();remote=args.remote
system=json.loads(Path(json.loads((out/'ui-system.json').read_text())['receipt']).read_text())
content_path=Path(json.loads((out/'ui-content.json').read_text())['receipt'])
content=json.loads(content_path.read_text(encoding='utf-8'))
assert system['result']=='PASS' and content['status']=='complete'
installed=next(s['result'] for s in system['steps'] if s['name']=='installed')
root=installed['root'];identity=system['manifest_sha256']
def py(code,timeout=180):
    return run_process(['ssh','-o','BatchMode=yes','-o','ConnectTimeout=8','-b','192.168.2.1',
        'pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=timeout)
def save(name,value):
    (out/name).write_text(json.dumps(value,ensure_ascii=False,indent=2),encoding='utf-8')
device=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',expected_build_id=0xC0061000,timeout=3)
report=dict(result='RUNNING',manifest_sha256=identity,physical_board=True,physical_hand=False,steps=[],
            scope=dict(video_id=args.video_id,skip_replays=args.skip_replays,check_restart=args.check_restart,
                       only_games=args.only_games))
def check(name,value,**detail):
    report['steps'].append(dict(name=name,passed=bool(value),**detail));save('board-acceptance.json',report)
    print(name+(' PASS' if value else ' FAIL'),flush=True)
    if not value:raise AssertionError(name)
try:
    stopped=SystemLoader(device).remote('stop',system['transaction'],identity)
    save('installed-stop.json',stopped);assert not stopped['running'] and not stopped['owners']
except BaseException as error:
    report.update(result='FAIL',phase='installed-stop',error=str(error),test_owner_started=False)
    save('board-acceptance.json',report)
    raise
raw=(ROOT/'tools/r53_menu_board.py').read_bytes();encoded=base64.b64encode(raw).decode()
record=json.loads(py(f"""import json,sys,subprocess,time,base64,hashlib
from pathlib import Path
sys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')
import system_board as b
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip();b.verify(Path({root!r}),{identity!r});b.gate(None,boot)
folder=Path({remote!r});folder.mkdir(exist_ok=False)
data=base64.b64decode({encoded!r});assert hashlib.sha256(data).hexdigest()=={hashlib.sha256(raw).hexdigest()!r}
(folder/'r53_menu_board.py').write_bytes(data)
command=['/usr/local/share/pynq-venv/bin/python','-B','-u',str(folder/'r53_menu_board.py'),'--entry',{(root+'/start_board_test.py')!r},'--output',str(folder/'run')]
if {args.check_restart!r}:command.append('--check-restart')
with (folder/'console.log').open('xb') as f:p=subprocess.Popen(command,stdout=f,stderr=subprocess.STDOUT,start_new_session=True)
record=dict(root={root!r},boot_id=boot,pid=p.pid,start_ticks=b.processes()[p.pid]['ticks'],started=time.time(),manifest_sha256={identity!r},hand_enabled=False)
(folder/'owner.json').write_text(json.dumps(record,indent=2))
print(json.dumps(record))
"""))
save('test-owner.json',record)
print('Four-card test PID '+str(record['pid']),flush=True)
deadline=time.monotonic()+900;last=None
while True:
    value=json.loads(py(f"""import json
from pathlib import Path
p=Path({(remote+'/run/menu-checks.json')!r})
v=json.loads(p.read_text()) if p.exists() else {{}}
print(json.dumps(dict(result=v.get('result'),checks=len(v.get('checks',[])),error=v.get('error'))))
"""))
    if value!=last:print(json.dumps(value),flush=True);last=value
    if value.get('result')=='FAIL':
        menu=json.loads(py(f"from pathlib import Path\nprint(Path({(remote+'/run/menu-checks.json')!r}).read_text())\n"))
        save('menu-checks.json',menu)
        report.update(result='FAIL',phase='hdmi-menu',error=menu.get('error'),test_owner_started=True)
        save('board-acceptance.json',report)
        (out/'board-console.log').write_bytes(py(f"from pathlib import Path\nprint(Path({(remote+'/console.log')!r}).read_text())\n"))
        # The board helper requested normal SIGINT. Preserve any retained
        # cleanup owner and its original fault; never kill or reload over it.
        raise RuntimeError(str(value))
    if value.get('result')=='PASS':break
    if time.monotonic()>deadline:raise TimeoutError('Menu test still owns board; no restart')
    time.sleep(5)
menu=json.loads(py(f"from pathlib import Path\nprint(Path({(remote+'/run/menu-checks.json')!r}).read_text())\n"))
save('menu-checks.json',menu)
check('four-hdmi-menu-cards',menu['result']=='PASS' and menu['input_restored'])

def status():
    value=device.video_status();snapshot=value['snapshot']
    assert value['ok'] and not snapshot['last_error'],snapshot
    return snapshot
def stop(name):
    value=device.stop_video()
    check(name,value['ok'] and value['snapshot']['runtime_mode']=='menu')
try:
    assert device.connect().state is DeviceState.READY
    listing=device.list_library()['library_items']
    for r in content['items']:
        check(r['item_id']+'-studio-identity',any(
            e['item_id']==r['item_id'] and e['kind']==r['kind'] and e['sha256']==r['sha256']
            and e['length']==r['length'] for e in listing))
    for index,r in enumerate(content['items'],1):
        if r['kind']!='game' or args.skip_replays:continue
        if args.only_games is not None and r['item_id'] not in args.only_games:continue
        with ZipFile(r['package']) as archive:
            cases=[(n,archive.read(n).decode()) for n in sorted(archive.namelist())
                   if n.startswith('tests/replays/') and n.endswith('.json')]
        for case_index,(name,case_json) in enumerate(cases,1):
            if args.only_case and Path(name).stem!=args.only_case:continue
            label=r['item_id']+'-'+Path(name).stem
            launch=device.run_game(r['item_id'],test_case_json=case_json)
            assert launch['ok'];deadline=time.monotonic()+max(40,json.loads(case_json)['max_ticks']/20+30)
            started=time.monotonic();samples=[];snap=status()
            while not snap.get('test_complete'):
                samples.append(dict(elapsed=time.monotonic()-started,
                    **{k:v for k,v in snap.items() if k in ('state','runtime_mode','tick_id',
                        'game_tick','presented_frames','test_complete','game_menu_active','game_menu_outcome','last_error')}))
                if time.monotonic()>deadline:
                    save(label+'-timeout.json',dict(snapshot=snap,samples=samples,case=json.loads(case_json)))
                    raise TimeoutError('Replay incomplete: '+r['item_id']+name)
                time.sleep(1);snap=status()
            save(label+'-progress.json',samples)
            check(label+'-assertions',snap.get('assertions_failed')==0 and (snap.get('assertions_passed') or 0)>0
                  and (snap.get('presented_frames') or 0)>0)
            pc=json.loads((content_path.parent/str(index)/f'test-{case_index}.json').read_text(encoding='utf-8'))
            board=snap['game_test_report'];comparison=compare_test_reports(pc,board)
            save(label+'-pynq.json',board);save(label+'-comparison.json',comparison)
            check(label+'-pc-pynq',comparison['status']=='passed',comparison=comparison)
            stop(label+'-return')
    if args.check_restart:
        previous=status()['vision'];old_session=previous.get('session_id') or previous.get('run_id')
        assert old_session
        device.disconnect()
        py(f"from pathlib import Path\nPath({(remote+'/run/restart.request')!r}).write_text('after-game-replays')\n")
        deadline=time.monotonic()+660;next_owner_check=0
        while True:
            if time.monotonic()>=next_owner_check:
                next_owner_check=time.monotonic()+20
                try:
                    alive=json.loads(py(f"""import json
from pathlib import Path
p=Path('/proc/{record['pid']}');alive=False
try:
 s=(p/'stat').read_text().rsplit(')',1)[1].split()
 alive=s[0]!='Z' and s[19]=={record['start_ticks']!r}
except FileNotFoundError:pass
print(json.dumps(dict(alive=alive)))
"""))
                except (OSError,RuntimeError,TimeoutError):
                    alive=None
                if alive is not None and not alive['alive']:
                    console=py(f"from pathlib import Path\nprint(Path({(remote+'/console.log')!r}).read_text())\n").decode()
                    (out/'restart-failure-console.log').write_text(console,encoding='utf-8')
                    raise RuntimeError('Home restart exited before readiness: '+'\n'.join(console.splitlines()[-8:]))
            try:
                connected=device.connect()
                if connected.state is DeviceState.READY:
                    current=status();vision=current['vision']
                    new_session=vision.get('session_id') or vision.get('run_id')
                    if new_session and new_session!=old_session:break
            except (OSError,RuntimeError,TimeoutError):
                device.disconnect()
            if time.monotonic()>deadline:raise TimeoutError('Home UI restart did not finish new initialization')
            time.sleep(5)
        restarted=json.loads(py(f"from pathlib import Path\nprint(Path({(remote+'/run/restart-checks.json')!r}).read_text())\n"))
        console=py(f"from pathlib import Path\nprint(Path({(remote+'/console.log')!r}).read_text())\n").decode()
        check('home-ui-full-restart',restarted['result']=='REQUESTED' and restarted['input_restored']
              and restarted['home_dialog'] and 'UI_RESTART_CLEANUP_CONFIRMED' in console
              and console.count('UI_SESSION_READY')>=2 and current['runtime_mode']=='menu'
              and vision['state']=='RUNNING' and not vision.get('last_error'),
              old_vision_session=old_session,new_vision_session=new_session)
        save('home-restart.json',dict(result='PASS',request=restarted,snapshot=current))
    # Real-time long-video consumption, one status read per five seconds. No
    # camera return or competing display owner; record complete loop boundaries.
    for r in content['items']:
        if r['kind']!='video' or args.skip_videos:continue
        if args.video_id and r['item_id']!=args.video_id:continue
        name=r['item_id'];assert device.play_library_item(name,library_kind='video')['ok']
        # Opening S2V validates every packet before presenting the first frame.
        # Budget that phase separately from a conservative 20 fps board rate.
        video_started=time.monotonic()
        deadline=video_started+r['frames']/20+180;next_notice=0;samples=[]
        while True:
            snap=status()
            assert snap['runtime_mode']=='video' and snap['active_sha256']==r['sha256']
            samples.append(dict(frame=snap['frame_index'],presented=snap['presented_frames'],loops=snap['completed_loops'],
                                elapsed_seconds=time.monotonic()-video_started))
            report.setdefault('video_samples',{})[name]=samples
            save('board-acceptance.json',report)
            if time.monotonic()>next_notice:
                print(name+' '+str(snap['frame_index'])+'/'+str(r['frames'])+' loops='+str(snap['completed_loops']),flush=True)
                next_notice=time.monotonic()+15
            if (snap.get('completed_loops') or 0)>=1:break
            if time.monotonic()>deadline:raise TimeoutError('Long-video loop incomplete: '+name)
            time.sleep(5)
        check(name+'-full-loop',snap['frame_count']==r['frames'] and snap['presented_frames']>=r['frames'],samples=samples)
        paused=device.pause_video();check(name+'-pause',paused['snapshot']['state']=='paused')
        paused_frames=paused['snapshot']['presented_frames']
        assert device.seek_video(r['frames']//2)['ok'];assert device.start_video()['ok']
        deadline=time.monotonic()+15
        while True:
            time.sleep(1);resumed=status()
            if resumed['presented_frames']>=paused_frames+3:break
            if time.monotonic()>deadline:raise TimeoutError('Seek resume did not present new frames')
        check(name+'-seek-resume',resumed['state']=='running'
              and resumed['frame_index']>=r['frames']//2)
        frames_before=resumed['presented_frames']
        assert device.start_video()['ok']  # repeated RUN must preserve live resources too
        time.sleep(1);resumed=status()
        check(name+'-running-start-idempotent',resumed['presented_frames']>frames_before)
        stop(name+'-return')
    final=status();save('final-state.json',final)
    check('final-vision-and-menu',final['runtime_mode']=='menu' and final['vision']['state']=='RUNNING'
                         and not final['vision']['last_error'])
    report['result']='PASS'
except BaseException as error:
    report.update(result='FAIL',error=str(error));raise
finally:
    device.disconnect();save('board-acceptance.json',report)
    log=py(f"from pathlib import Path\nprint(Path({(remote+'/console.log')!r}).read_text())\n")
    (out/'board-console.log').write_bytes(log)
    release=json.loads(py(f"""import json,sys
from pathlib import Path
sys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')
import system_board as b
r={record!r};boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip()
b.stop_owned(r,boot);b.gate(None,boot)
receipts=[json.loads(p.read_text()) for p in Path(r['root']+'/var/vision').rglob('stop_receipt.json') if p.stat().st_mtime>=r['started']]
assert receipts and all(x['cleanup_confirmed'] and not x.get('error') for x in receipts)
print(json.dumps(dict(result='PASS',owners=[],receipts=receipts)))
"""))
    save('board-release.json',release)
print(json.dumps(dict(result=report['result'],checks=len(report['steps']),released=True)),flush=True)



