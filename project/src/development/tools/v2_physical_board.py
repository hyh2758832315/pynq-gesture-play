"""Finite v2 menu-follow/creative/preview/video ownership acceptance on PYNQ.

Run via r51_validate_installed.py --physical --observer-confirmed
 --physical-entry tools/v2_physical_board.py; needs installed package arguments.
Output: checks.json, original serial owner/startup/cleanup receipts.
Next: restore normal default service. Synthetic gestures exist only in this
isolated test process. Real checked serial backend; zero extra motor reads.
Protocol completion cannot certify physical posture without human observation.
"""
import argparse
from dataclasses import replace
import hashlib
import json
import os
from pathlib import Path
import runpy
import signal
import sys
import threading
import time
import traceback
import urllib.request

p=argparse.ArgumentParser(description=__doc__)
for name in ('package','hand-root','hand-python','output'):p.add_argument('--'+name,type=Path,required=True)
p.add_argument('--observer-confirmed',action='store_true',required=True)
p.add_argument('--video-id',required=True)
p.add_argument('--check-restart',action='store_true')
args=p.parse_args();args.output.mkdir(parents=True,exist_ok=False)
sys.path.insert(0,str(args.package/'python'))
from pynq_multimodal_game.agent.button_osd_backend import C6IButtonOsdRuntimeBackend
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
from pynq_multimodal_game.controls import MockControlAdapter,ControlSource
from pynq_multimodal_game.menu import MenuPage
from pynq_multimodal_game import hand_shadow_bridge

report=dict(schema='v2-autonomous-physical-protocol-v1',result='RUNNING',physical_hand=True,
    synthetic_test_source=True,mechanical_verified=False,checks=[],error=None,
    manifest_sha256=hashlib.sha256((args.package/'deployment_manifest.json').read_bytes()).hexdigest())
def save():
    temp=args.output/'checks.tmp';temp.write_text(json.dumps(report,indent=2),encoding='utf-8')
    temp.replace(args.output/'checks.json')
def check(name,condition,**detail):
    report['checks'].append(dict(name=name,passed=bool(condition),**detail));save()
    print('V2_PHYSICAL_CHECK',name,bool(condition),flush=True)
    if not condition:raise AssertionError(name)
save()

class HandFeed:
    pose='paper'
    def peek_hand_classification(self):
        now=time.monotonic();frame=int(now*20)
        return dict(run_id='v2-isolated-hand-test',config_epoch='v2-test',frame_id=frame,
                    observed_at=now,source_at=frame/20,valid=True,gesture=self.pose)
feed=HandFeed()
real_factory=hand_shadow_bridge.create_serial_action_session
def test_factory(provider,**kwargs):return real_factory(feed,**kwargs)
hand_shadow_bridge.create_serial_action_session=test_factory

class UI:
    def __init__(self,original):
        self.original=original;self.pose=None;self.valid=False;self.xy=(100,90);self.frame=0
        self.base=MockControlAdapter(ControlSource.KEYBOARD).read(tick_id=0,timestamp_ns=0)
    def set(self,x,y,pose='paper'):
        self.xy=x,y;self.pose=pose;self.valid=True;self.frame+=1
    def sample_menu_control(self,*,tick_id):
        return replace(self.base,timestamp_ns=time.monotonic_ns(),tick_id=tick_id,
            hand_valid=self.valid,hand_x=self.xy[0]*2/319-1,hand_y=self.xy[1]*2/179-1,
            fist_score=float(self.pose=='fist'),gesture_seq=self.frame)
    def peek_menu_control(self):return self.sample_menu_control(tick_id=0)
    def peek_hand_classification(self):
        now=time.monotonic()
        # UI fist is valid although the independent game classifier is UNKNOWN.
        return dict(run_id='v2-isolated-ui',config_epoch='test',frame_id=self.frame,
                    source_at=now,observed_at=now,valid=self.valid,gesture='paper' if self.pose=='paper' else None)
    def __getattr__(self,key):return getattr(self.original,key)

def exercise(shell):
    hand=shell._hand_session;original=shell._live_input;ui=UI(original);preview=None;callback=None
    def wait(predicate,label,seconds=12):
        end=time.monotonic()+seconds
        while time.monotonic()<end:
            if shell._last_error or hand.error:raise RuntimeError(shell._last_error or hand.error)
            if predicate():return
            time.sleep(.1)
        raise TimeoutError(label)
    def send(x,y,pose='paper',seconds=.3):
        with shell._lock:ui.set(x,y,pose)
        time.sleep(seconds)
    def live():return hand.page_status().get('phase')=='LIVE'
    def off():
        s=hand.status();v=hand.page_status()
        return (s.get('phase')=='PAUSED' and s.get('preview_allowed') is True or
                v.get('off') and v.get('release_confirmed_ids')==list(range(1,18)))
    try:
        shell._live_input=ui
        wait(lambda:hand.status()['phase']=='ACTIVE','physical owner active',30)
        child=hand.status()['child_pid']
        check('startup-readonly-17-check',hand.gate.passed is True)
        wait(live,'initial HOME follows without selecting another page')
        check('initial-home-live-after-startup',hand._page_mode=='live')
        for page,pose,target in ((MenuPage.HOME,'paper','paper'),
                                 (MenuPage.GAMES,'fist','rock'),
                                 (MenuPage.VIDEOS,'scissors','scissors')):
            with shell._lock:shell._select_page_locked(page)
            feed.pose=pose
            wait(lambda:live() and hand.page_status().get('pose')==target,page.value+' follows '+pose)
            check(page.value+'-live-follow',hand._page_mode=='live',state=hand.page_status())
            check(page.value+'-one-owner',hand.status()['child_pid']==child)
        with shell._lock:shell._select_page_locked(MenuPage.CANVAS)
        wait(off,'canvas confirmed OFF')
        check('canvas-off-before-drawing',True)
        send(288,66);send(288,66,'fist')
        wait(lambda:shell._canvas.shape=='square','shape confirm')
        send(100,90);send(100,90,'fist')
        wait(lambda:shell._canvas.revision>0,'UI fist paints UNKNOWN classification')
        check('ui-fist-unknown-classification-paints',shell._canvas.pixels[90*256+100]==4)
        begin=time.monotonic();cpu=time.process_time();revision=shell._canvas.revision
        for n in range(45):send(30+(n*5)%200,125,'fist',.08)
        elapsed=time.monotonic()-begin
        check('continuous-latest-only-brush',shell._canvas.revision>revision+20,
              stamps=shell._canvas.revision-revision,seconds=elapsed,
              parent_cpu_percent=100*(time.process_time()-cpu)/elapsed,
              raster_bytes=len(shell._canvas.pixels))
        ui.valid=False
        check('canvas-hand-remains-off',off())
        shell.return_to_menu();feed.pose='paper'
        wait(live,'canvas back resumes home')
        check('canvas-home-resumes-live',hand.status()['child_pid']==child)
        preview=urllib.request.urlopen('http://192.168.2.99:8081/camera.mjpg',timeout=12)
        wait(lambda:hand.status()['phase']=='PAUSED' and hand.status()['preview_allowed'],'preview OFF')
        data=preview.read(4096)
        check('preview-after-17-off',b'\xff\xd8' in data)
        preview.close();preview=None
        wait(live,'preview closes and live resumes',20)
        check('preview-resumes-same-owner',hand.status()['child_pid']==child)
        shell.play_library_video(args.video_id);time.sleep(8)
        check('video-paused-off',off() and shell.snapshot.last_error is None)
        shell.return_to_menu();wait(live,'video menu resumes live',20)
        check('video-resumes-same-owner',hand.status()['child_pid']==child)
        # Exercise actual standard restart request; defer its callback only
        # until this finite test report has been atomically saved.
        callback=shell._restart_callback;requested=threading.Event();shell._restart_callback=requested.set
        send(100,90);send(12,12,seconds=0)
        wait(lambda:shell._home_dialog,'home options',8)
        send(225,95,seconds=0);wait(requested.is_set,'full restart',8)
        check('home-full-restart-request',shell._restart_requested and shell._startup_frame_id>0)
        report['restart_expected']=True
        report['result']='AUTOMATED_PASS_OBSERVATION_PENDING'
    except BaseException as error:
        report.update(result='FAIL',error=str(error),traceback=traceback.format_exc())
        print(report['traceback'],flush=True)
    finally:
        if preview is not None:preview.close()
        ui.valid=False;hand.set_page_mode('idle');shell._live_input=original
        report['hand_output_dir']=str(hand.output_dir);save()
        if report.get('restart_expected'):
            shell._restart_callback=callback;callback()
        else:os.kill(os.getpid(),signal.SIGINT)

original_open=C6IButtonOsdRuntimeBackend.open
scheduled=False
def open_and_schedule(self):
    global scheduled
    result=original_open(self)
    if not scheduled:
        scheduled=True;threading.Thread(target=exercise,args=(self,),daemon=True,name='v2-finite-acceptance').start()
    return result
C6IButtonOsdRuntimeBackend.open=open_and_schedule
sys.argv=[str(args.package/'start_board_test.py'),'--hand-readonly-root',str(args.hand_root),
    '--hand-readonly-python',str(args.hand_python),'--hand-readonly-port',
    '/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00','--hand-serial-actions',
    '--hand-stage-waits','3','3','3','--hand-approval-seconds','3','--hand-serial-seconds','600']
runpy.run_path(sys.argv[0],run_name='__main__')
