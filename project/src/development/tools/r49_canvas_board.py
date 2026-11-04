"""Isolated real-GPU canvas checks; no physical hand or preview subscriber.

Run on PYNQ: sudo python r49_canvas_board.py --package PATH --output NEW_DIR
Outputs: checks.json and the normal entry's vision stop receipts.
Next: verify clean release before restoring the installed autostart service.
The input override exists only in this test process, never in installed code.
"""
import argparse
from dataclasses import replace
import json
import os
from pathlib import Path
import runpy
import signal
import sys
import threading
import time
import traceback

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--package',type=Path,required=True)
p.add_argument('--output',type=Path,required=True)
p.add_argument('--fist-only',action='store_true',help='Check the simplified R50 canvas contract')
args=p.parse_args();args.output.mkdir(exist_ok=False,parents=True)
sys.path.insert(0,str(args.package/'python'))
os.environ['PYTHONPATH']=str(args.package/'python');os.environ['XILINX_XRT']='/usr'
from pynq_multimodal_game.agent.button_osd_backend import C6IButtonOsdRuntimeBackend
from pynq_multimodal_game.controls import MockControlAdapter,ControlSource
from pynq_multimodal_game.menu import MenuPage
report=dict(result='RUNNING',physical_hand=False,synthetic_ui_input=True,real_gpu=True,checks=[])
def save():
    (args.output/'checks.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
def check(name,condition,**details):
    report['checks'].append(dict(name=name,passed=bool(condition),**details));save()
    print(name,bool(condition),flush=True)
    if not condition:raise AssertionError(name)
class Inputs:
    def __init__(self,original):
        self.original=original;self.xy=(160,90);self.pose=None;self.frame=0;self.valid=False
        self.source_at=time.monotonic()
        self.base=MockControlAdapter(ControlSource.KEYBOARD).read(tick_id=0,timestamp_ns=0)
    def set(self,x,y,pose,valid=True):
        self.xy=(x,y);self.pose=pose;self.valid=valid;self.frame+=1;self.source_at=time.monotonic()
    def sample_menu_control(self,*,tick_id):
        return replace(self.base,tick_id=tick_id,timestamp_ns=time.monotonic_ns(),
            hand_valid=self.valid,hand_x=self.xy[0]*2/319-1,hand_y=self.xy[1]*2/179-1,
            gesture_seq=self.frame,fist_score=float(self.pose=='fist'),fist_event=self.pose=='fist')
    def peek_menu_control(self):return self.sample_menu_control(tick_id=0)
    def peek_hand_classification(self):
        return dict(run_id='r49-isolated-test',config_epoch='offline-input',frame_id=self.frame,
                    source_at=self.source_at,valid=self.valid,gesture=self.pose)
    def __getattr__(self,name):return getattr(self.original,name)
def exercise(shell):
    original=shell._live_input;source=Inputs(original);uploads=[]
    sink=shell._require_sink();upload=sink.upload_asset
    def counted(packet):
        result=upload(packet);uploads.append(len(packet));return result
    try:
        check('no-physical-hand',shell._hand_session is None)
        with shell._lock:shell._live_input=source;sink.upload_asset=counted
        def send(x,y,pose='paper',seconds=.35):
            with shell._lock:source.set(x,y,pose)
            time.sleep(seconds)
            if shell._last_error:raise RuntimeError(shell._last_error)
        send(228,132);send(228,132,'fist')
        check('menu-to-canvas',shell.page is MenuPage.CANVAS)
        for shape,y in zip(('triangle','square','circle','star'),(31,66,101,136)):
            send(288,y,'fist');check('select-'+shape,shell._canvas.shape==shape)
            send(100,90);before=shell._canvas.revision
            send(100,90,'scissors')
            if args.fist_only:
                check('scissors-neutral-'+shape,shell._canvas.revision==before)
                send(100,90,'fist')
            check('stamp-'+shape,shell._canvas.revision==before+1)
            send(100 if args.fist_only else 130,90,'fist' if args.fist_only else 'scissors')
            check('held-gesture-single-'+shape,shell._canvas.revision==before+1)
            if args.fist_only:
                start=len(uploads);send(100,90);send(100,90,'fist')
                check('identical-overlap-no-upload-'+shape,len(uploads)==start and shell._canvas.revision==before+1)
        for _ in range(3):send(306,168,'fist')
        check('max-size',shell._canvas.size==40)
        send(60,90)
        start=len(uploads);frames=shell._menu_frame_id;cpu=time.process_time();wall=time.monotonic()
        for n in range(40):send(35+n*5,80+(n%5)*3,seconds=.1)
        report['preview']=dict(uploads=len(uploads)-start,scenes=shell._menu_frame_id-frames,
                              process_cpu_seconds=time.process_time()-cpu,seconds=time.monotonic()-wall)
        check('moving-preview-no-asset-upload',len(uploads)==start,**report['preview'])
        check('moving-preview-presented',shell._menu_frame_id-frames>=15)
        before=shell._canvas.revision;start=len(uploads)
        for x in range(35,235,8):send(x,130,'fist',.12)
        check('continuous-brush',shell._canvas.revision-before>=10,stamps=shell._canvas.revision-before)
        check('brush-updates-background',len(uploads)>start)
        if args.fist_only:
            # Different shape/color overwrites the existing raster, not a new layer.
            send(288,66,'fist');send(100,90);send(100,90,'fist')
            check('overlap-new-color',shell._canvas.pixels[90*256+100]==4)
            check('fixed-memory-after-overlap',len(shell._canvas.pixels)==46080)
        send(12,12,seconds=2.4);check('return-dialog',shell._canvas.dialog)
        send(160,90,seconds=2.4);check('clear',set(shell._canvas.pixels)=={2})
        send(80,90);send(12,12,seconds=2.4);send(246,90,seconds=2.4)
        check('return-home',shell.page is MenuPage.HOME)
        check('gpu-no-error',shell._last_error is None)
        report['result']='PASS'
    except BaseException as error:
        report.update(result='FAIL',error=str(error),traceback=traceback.format_exc())
        print(report['traceback'],flush=True)
    finally:
        with shell._lock:
            source.set(160,90,None,False);shell._live_input=original;sink.upload_asset=upload
        save();os.kill(os.getpid(),signal.SIGINT)
original_open=C6IButtonOsdRuntimeBackend.open
scheduled=[]
def open_test(self):
    result=original_open(self)
    if not scheduled:
        scheduled.append(True)
        threading.Thread(target=exercise,args=(self,),name='r49-canvas-test',daemon=True).start()
    return result
C6IButtonOsdRuntimeBackend.open=open_test
sys.argv=[str(args.package/'start_board_test.py')]
try:runpy.run_path(sys.argv[0],run_name='__main__')
finally:
    report['normal_entry_returned']=True;save()
    if report['result']!='PASS':raise SystemExit(1)
