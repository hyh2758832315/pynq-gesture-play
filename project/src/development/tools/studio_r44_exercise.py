"""Exercise the exact Studio-installed content on real PYNQ GPU/HDMI.

Run: .venv/Scripts/python.exe -B tools/studio_r44_exercise.py
Outputs: build/studio-r44/exercise.json and bounded command receipts.
Next: normal stop/start with studio_r44_board_guard.py; verify library persistence.
No camera return, hand motion, custom MMIO reads or persistent input injector.
"""
from pathlib import Path
import argparse
import json
import sys
import time
from zipfile import ZipFile

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession,DeviceState


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--videos-only',action='store_true')
    parser.add_argument('--output',type=Path,default=ROOT/'build/studio-r44')
    args=parser.parse_args()
    output=args.output
    output.mkdir(parents=True,exist_ok=True)
    ui=json.loads((ROOT/'build/studio-r44/ui-load.json').read_text('utf-8'))
    assert ui['result']=='PASS'
    receipt=json.loads(Path(ui['receipt']).read_text('utf-8'))
    items=receipt['items']
    session=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',
                                expected_build_id=0xC0061000,timeout=2)
    report=dict(result='RUNNING',physical_board=True,hand_enabled=False,steps=[],error=None)
    def save():
        (output/('exercise-videos.json' if args.videos_only else 'exercise.json')).write_text(json.dumps(report,indent=2),encoding='utf-8')
    def check(name,value,condition=True):
        report['steps'].append(dict(name=name,passed=bool(condition),receipt=value))
        save();print(name, 'PASS' if condition else 'FAIL',flush=True)
        assert condition,name
        return value
    def status():
        result=session.video_status()
        snap=result['snapshot']
        assert result['ok'] and snap['last_error'] is None, result
        return snap
    def stop(label):
        result=session.stop_video()
        snap=result['snapshot']
        check(label,result,result['ok'] and snap['runtime_mode']=='menu' and snap['last_error'] is None)
    try:
        assert session.connect().state is DeviceState.READY
        for kind in ('game','video'):
            result=session.list_library(kind)
            listing={x['item_id']:x for x in result['library_items']}
            check(kind+'-identity',result,all(
                listing.get(r['item_id'],{}).get('sha256')==r['sha256'] and
                listing.get(r['item_id'],{}).get('length')==r['length']
                for r in items if r['kind']==kind))
        for record in (r for r in items if r['kind']=='game' and not args.videos_only):
            name=record['item_id']
            with ZipFile(record['package']) as archive:
                cases=[(n,archive.read(n).decode('utf-8')) for n in sorted(archive.namelist())
                       if n.startswith('tests/replays/') and n.endswith('.json')]
            for case_name,case_json in cases:
                launch=session.run_game(name,test_case_json=case_json)
                check(name+'-'+Path(case_name).stem+'-launch',launch,launch['ok'])
                deadline=time.monotonic()+max(35,json.loads(case_json)['max_ticks']/12+20)
                snap=status()
                while not snap.get('test_complete') and time.monotonic()<deadline:
                    time.sleep(1);snap=status()
                check(name+'-'+Path(case_name).stem+'-assertions',snap,
                      snap.get('test_complete') is True and snap.get('assertions_failed')==0
                      and (snap.get('assertions_passed') or 0)>0 and (snap.get('presented_frames') or 0)>0)
                stop(name+'-test-stop-menu')
            launch=session.run_game(name)
            time.sleep(1.2);before=status()
            check(name+'-normal-running',before,before['runtime_mode']=='game' and (before.get('presented_frames') or 0)>0)
            paused=session.pause_game()
            check(name+'-pause',paused,paused['snapshot']['state']=='paused')
            resumed=session.resume_game()
            time.sleep(.8);after=status()
            check(name+'-resume',after,after['state']=='running' and after['game_tick']>before['game_tick'])
            stop(name+'-stop-menu')
        for record in (r for r in items if r['kind']=='video'):
            name=record['item_id']
            started=time.monotonic()
            launch=session.play_library_item(name,library_kind='video')
            before=status()
            deadline=time.monotonic()+12
            while not (before.get('presented_frames') or 0) and time.monotonic()<deadline:
                time.sleep(.5);before=status()
            before['observed_start_seconds']=round(time.monotonic()-started,3)
            check(name+'-play',before,before['runtime_mode']=='video' and before['active_sha256']==record['sha256']
                  and before['frame_count']==record['frames'] and before['presented_frames']>0)
            paused=session.pause_video()
            check(name+'-pause',paused,paused['snapshot']['state']=='paused')
            seek=session.seek_video(record['frames']//2)
            check(name+'-seek',seek,seek['ok'])
            session.start_video()
            deadline=time.monotonic()+25
            snap=status()
            while (snap.get('completed_loops') or 0)<1 and time.monotonic()<deadline:
                time.sleep(1);snap=status()
            check(name+'-resume-loop',snap,(snap.get('completed_loops') or 0)>=1 and snap['presented_frames']>before['presented_frames'])
            # Exercise direct ownership transfer without an intermediate menu.
            if record is next(r for r in items if r['kind']=='video'):
                game=session.run_game('game1')
                check('video-to-game-direct',game,game['snapshot']['runtime_mode']=='game')
                again=session.play_library_item(name,library_kind='video')
                check('game-to-video-direct',again,again['snapshot']['runtime_mode']=='video')
            stop(name+'-stop-menu')
        final=status()
        check('final-camera-running-menu',final,final['runtime_mode']=='menu' and final['vision']['state']=='RUNNING'
              and final['vision']['last_error'] is None)
        report['result']='PASS'
    except Exception as error:
        report.update(result='FAIL',error=str(error));raise
    finally:
        try: report['final_stop']=session.stop_video()
        except Exception as error:report['stop_error']=str(error)
        session.disconnect();save()


if __name__=='__main__':main()
