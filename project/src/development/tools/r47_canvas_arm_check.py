"""Replay the scissors regression on the installed ARM Python, without hardware IO.

Run: .venv/Scripts/python.exe -B tools/r47_canvas_arm_check.py
Outputs: build/studio-r47/arm-canvas.json.
Next: use the ordinary HDMI canvas to confirm the physical-camera interaction.
"""
from pathlib import Path
import json
import shlex
import sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.system_loader import run_process

PROGRAM=r'''
import hashlib,json,sys,time
from pathlib import Path
root=Path(sys.argv[1]);expected=sys.argv[2]
assert hashlib.sha256((root/'deployment_manifest.json').read_bytes()).hexdigest()==expected
manifest=json.loads((root/'deployment_manifest.json').read_text())
name='python/pynq_multimodal_game/creative_pages.py'
assert hashlib.sha256((root/name).read_bytes()).hexdigest().upper()==manifest['sha256'][name]
sys.path.insert(0,str(root/'python'))
from pynq_multimodal_game.creative_pages import CanvasPage
from pynq_multimodal_game.vision_input import GameVisionInputProvider
checks=[]
started=time.process_time()
for outside in ((288,66),(250,90),(100,20)):
    now=[100.];source=GameVisionInputProvider(clock=lambda:now[0]);canvas=CanvasPage();frame=0
    def send(x,y,pose):
        global frame
        frame+=1;now[0]+=.15
        stable,rps={'fist':('0','ROCK'),'scissors':('2','SCISSORS'),
                    'paper':('5','PAPER'),None:('PENDING','UNKNOWN')}[pose]
        u,v=x*2/319-1,y*2/179-1
        packet=dict(run_id='arm-offline-canvas',frame=frame,server_age_ms=10,stable=stable,rps=rps,
            ui_pointer=dict(schema='menu-pointer-v1',u=u,v=v),
            control=dict(schema='gesture-control-v1',frame_id=frame,action_event_seq=0,
                direction='IDLE',valid=True,reason='OK',u=u,v=v,action_event=False))
        source.publish(packet,config_epoch='offline')
        return canvas.update(source.sample_menu_control(tick_id=frame),source.peek_hand_classification())
    assert send(288,31,'fist')=='select'
    assert send(*outside,'scissors') is None and canvas.revision==0
    assert send(100,90,'scissors')=='paint'
    assert canvas.pixels[90*256+100]==3
    for x,y,pose in ((140,90,'scissors'),(140,90,None),(*outside,'scissors'),(160,90,'scissors')):
        assert send(x,y,pose) is None
    assert canvas.revision==1 and canvas.pixels[90*256+160]==2
    send(180,90,'paper')
    assert send(180,90,'scissors')=='paint' and canvas.revision==2
    checks.append(dict(outside=outside,passed=True,stamps=canvas.revision))
print(json.dumps(dict(result='PASS',python=sys.version,manifest_sha256=expected,
    production_file_sha256=manifest['sha256'][name],checks=checks,cpu_seconds=time.process_time()-started,
    hardware_io=False,source='synthetic isolated provider; not the running camera')))
'''

def main():
    out=ROOT/'build/studio-r47'
    ui=json.loads((out/'ui-system.json').read_text(encoding='utf-8'))
    receipt=json.loads(Path(ui['receipt']).read_text(encoding='utf-8'))
    assert receipt['result']=='PASS'
    installed=next(s['result'] for s in receipt['steps'] if s['name']=='installed')
    command=shlex.join(['/usr/local/share/pynq-venv/bin/python','-B','-',
                       installed['root'],receipt['manifest_sha256']])
    raw=run_process(['ssh','-o','BatchMode=yes','-o','ConnectTimeout=8','pynq-z2',command],
                    input=PROGRAM.encode(),timeout=30)
    result=json.loads(raw.decode().strip().splitlines()[-1])
    (out/'arm-canvas.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps(result))

if __name__=='__main__':main()
