"""Check installed video/preview handoff via normal Studio APIs (no injection).

Run: .venv/Scripts/python.exe -B tools/r15b_studio_video_acceptance.py --output NEW_DIR
Outputs: status/normal playback/real JPEG/restore receipts under NEW_DIR.
Next: enable the installed hand with Studio and perform human menu-restart check.
Does not install, restart the board, or create another hardware owner.
"""
import argparse,json,sys,time
from pathlib import Path
from http.client import HTTPConnection
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession,DeviceState

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    args=p.parse_args();out=args.output;out.mkdir(parents=True,exist_ok=False)
    d=RemoteDeviceSession('192.168.2.99',8765,expected_build_id=0xC0061000,
                          source_address='192.168.2.1',timeout=8)
    result=dict(result='RUNNING',synthetic_input=False,steps=[])
    def save(name,value):
        (out/(name+'.json')).write_text(json.dumps(value,indent=2),encoding='utf-8')
        result['steps'].append(name)
    try:
        assert d.connect().state is DeviceState.READY
        save('before',d.video_status())
        catalog=d.list_library('video');save('catalog',catalog)
        entries=catalog['library_items'];assert entries
        item=next((e['item_id'] for e in entries if e['item_id'].startswith('video-1-')),
                  entries[0]['item_id']);print('PLAY_VIDEO '+item,flush=True)
        played=d.play_library_item(item,library_kind='video');save('play',played)
        assert played['ok'],played
        time.sleep(3)
        before=d.video_status();save('playing',before)
        assert before['snapshot']['runtime_mode']=='video'
        connection=HTTPConnection('192.168.2.99',8081,timeout=40,source_address=('192.168.2.1',0))
        try:
            for index in range(3):
                deadline=time.monotonic()+40
                while True:
                    connection.request('GET','/debug.jpg');reply=connection.getresponse();frame=reply.read()
                    if reply.status!=503 or time.monotonic()>=deadline:break
                    time.sleep(.5)  # Same first-frame readiness retry as Studio.
                assert reply.status==200 and frame[:2]==b'\xff\xd8',(reply.status,len(frame))
                (out/f'camera-{index}.jpg').write_bytes(frame)
            preview=d.video_status();save('preview',preview)
            assert preview['snapshot']['runtime_mode']=='preview',preview
        finally:connection.close()
        print('PREVIEW_CLOSED',flush=True);time.sleep(5)
        after=d.video_status();save('restored',after)
        assert after['snapshot']['runtime_mode']=='video',after
        assert after['snapshot']['state']=='running',after
        save('menu',d.stop_video());time.sleep(1)
        menu=d.video_status();save('menu-ready',menu)
        assert menu['snapshot']['runtime_mode']=='menu',menu
        result['result']='PASS'
    except Exception as error:
        result.update(result='FAIL',error=str(error));raise
    finally:
        d.disconnect();(out/'result.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
        print(json.dumps(result),flush=True)

if __name__=='__main__':main()
