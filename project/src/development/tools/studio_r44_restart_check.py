"""Verify Studio content survives the normal entrypoint restarting.

Run after board guard starts load-a02: .venv/Scripts/python.exe -B tools/studio_r44_restart_check.py
Outputs: build/studio-r44/restart-check.json.
Next: stop load-a02 with the board guard and collect cleanup receipts.
"""
from pathlib import Path
import json
import sys
import time

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession,DeviceState


def main():
    output=ROOT/'build/studio-r44'
    path=Path(json.loads((output/'ui-load.json').read_text('utf-8'))['receipt'])
    original=json.loads(path.read_text('utf-8'))
    session=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',
                                expected_build_id=0xC0061000,timeout=2)
    report=dict(result='RUNNING',retained=[],error=None)
    try:
        deadline=time.monotonic()+45
        while session.connect().state is not DeviceState.READY:
            if time.monotonic()>deadline:raise RuntimeError(session.snapshot.message)
            time.sleep(3)
        for kind in ('game','video'):
            listing={e['item_id']:e for e in session.list_library(kind)['library_items']}
            for item in original['items']:
                if item['kind']!=kind:continue
                found=listing[item['item_id']]
                assert all(found[k]==item[k] for k in ('sha256','length'))
                report['retained'].append(found)
        assert len(report['retained'])==7
        # A previously uploaded video and latest game must still run after reseeding.
        video=next(r for r in original['items'] if r['kind']=='video')
        session.play_library_item(video['item_id'],library_kind='video')
        deadline=time.monotonic()+15
        snap=session.video_status()['snapshot']
        while not (snap.get('presented_frames') or 0) and time.monotonic()<deadline:
            time.sleep(.5);snap=session.video_status()['snapshot']
        assert snap['last_error'] is None and snap['active_sha256']==video['sha256'] and snap['presented_frames']>0
        report['video_after_restart']=snap
        session.run_game('game3')
        time.sleep(1.5)
        snap=session.video_status()['snapshot']
        assert snap['runtime_mode']=='game' and snap['last_error'] is None and snap['presented_frames']>0
        report['game_after_restart']=snap
        report['result']='PASS'
    except Exception as error:
        report.update(result='FAIL',error=str(error));raise
    finally:
        try:
            report['stop']=session.stop_video()
            assert report['stop']['snapshot']['runtime_mode']=='menu'
        except Exception as error:
            report.update(result='FAIL',stop_error=str(error))
        session.disconnect()
        (output/'restart-check.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
        print(json.dumps(dict(result=report['result'],retained=len(report['retained']),error=report['error'])),flush=True)
    if report['result']!='PASS':raise SystemExit(1)


if __name__=='__main__':main()
