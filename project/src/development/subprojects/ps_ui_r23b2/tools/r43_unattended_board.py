"""R43 bounded ARM/HDMI automation with a physically disabled hand backend.

Run: sudo -n /usr/local/share/pynq-venv/bin/python -B -u r43_unattended_board.py
     --package PATH --hand-root PATH --hand-python PATH --output NEW_DIRECTORY
Outputs: normal camera/GPU logs, checks.json and SDK-memory child receipts.
Next: inspect normal vision cleanup; physical hand/visual appearance remain pending.
No physical actuator, image subscription, extra MMIO probe, or persistent service.
"""
import argparse
from dataclasses import replace
import hashlib
import json
import os
from pathlib import Path
import resource
import runpy
import signal
import subprocess
import sys
import threading
import time
import traceback
from types import SimpleNamespace

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--package',type=Path,required=True)
parser.add_argument('--hand-root',type=Path,required=True)
parser.add_argument('--hand-python',type=Path,required=True)
parser.add_argument('--output',type=Path,required=True)
args=parser.parse_args()
args.output.mkdir(parents=True,exist_ok=False)
sys.path[:0]=[str(args.package/'python'),str(args.hand_root/'src')]
os.environ['PYTHONPATH']=str(args.package/'python')
os.environ['XILINX_XRT']='/usr'
from pynq_multimodal_game.agent.vision_backend import C6IButtonRuntimeBackend
from pynq_multimodal_game.agent.button_osd_backend import C6IButtonOsdRuntimeBackend
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
from pynq_multimodal_game.controls import MockControlAdapter,ControlSource
from pynq_multimodal_game.hand_shadow_bridge import create_serial_action_session
import pynq_multimodal_game.hand_serial_session as session_module
from pynq_multimodal_game.menu import MenuPage
from pynq_multimodal_game.startup_ui import CheckState

report=dict(schema='r43-unattended-arm-hdmi-v1',result='RUNNING',
    boot_id=Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
    manifest_sha256=hashlib.sha256((args.package/'deployment_manifest.json').read_bytes()).hexdigest(),
    physical_hand=False,camera_and_gpu=True,synthetic_ui_input=True,checks=[],metrics=[],error=None)
def save():
    temp=args.output/'checks.tmp'
    temp.write_text(json.dumps(report,indent=2,default=str),encoding='utf-8')
    temp.replace(args.output/'checks.json')
save()

# Redirect only this module's child spawn. The original SHA-checked child and
# manifest are still verified; this separate adapter cannot open physical serial.
real_popen=subprocess.Popen
def memory_popen(command,**kwargs):
    expected=str(args.package/'hand_child/serial_motion_receiver.py')
    assert command[3]==expected
    command=list(command)
    command.insert(3,str(Path(__file__).with_name('r43_memory_child.py')))
    return real_popen(command,**kwargs)
session_module.subprocess=SimpleNamespace(Popen=memory_popen,DEVNULL=subprocess.DEVNULL,
                                         TimeoutExpired=subprocess.TimeoutExpired)

class SyntheticHandSource:
    def peek_hand_classification(self):
        now=time.monotonic()
        return dict(run_id='r43-unattended-memory',config_epoch='test-only',
                    frame_id=int(now*20),source_at=now,observed_at=now,valid=True,gesture='paper')

gate=SimpleNamespace(passed=True,report_path=args.output/'checks.json',root=args.hand_root,
                     python=args.hand_python,port='/dev/memory-only')
hand_sessions=[]
def hand_factory(unused_real_provider):
    hand=create_serial_action_session(SyntheticHandSource(),gate=gate,package_root=args.package,
        output_dir=args.output,stage_waits=(3,3,3),approval_seconds=3,seconds=600)
    hand_sessions.append(hand)
    return hand
original_init=C6IButtonRuntimeBackend.__init__
def init(self,*a,**kw):
    assert not kw.get('hand_session_factory')
    kw.update(startup_hand=lambda:CheckState.SKIP,hand_session_factory=hand_factory)
    original_init(self,*a,**kw)
C6IButtonRuntimeBackend.__init__=init

class Inputs:
    def __init__(self,original):
        self.original=original
        self.xy=(160,90);self.pose=None;self.valid=False;self.seq=0;self.frame=0;self.source_at=time.monotonic()
        self.base=MockControlAdapter(ControlSource.KEYBOARD).read(tick_id=0,timestamp_ns=0)
    def set(self,x=160,y=90,pose=None,valid=True):
        self.xy=(x,y);self.pose=pose;self.valid=valid;self.seq+=1;self.frame+=1;self.source_at=time.monotonic()
    def sample_menu_control(self,*,tick_id):
        return replace(self.base,tick_id=tick_id,timestamp_ns=time.monotonic_ns(),
            hand_valid=self.valid,hand_x=self.xy[0]*2/319-1,hand_y=self.xy[1]*2/179-1,
            gesture_seq=self.seq,fist_score=1. if self.pose=='fist' else 0.,fist_event=self.pose=='fist')
    def peek_menu_control(self):return self.sample_menu_control(tick_id=0)
    def peek_hand_classification(self):
        return dict(run_id='r43-ui-script',config_epoch='test-only',frame_id=self.frame,
                    source_at=self.source_at,valid=self.valid,gesture=self.pose)
    def __getattr__(self,name):return getattr(self.original,name)

backend_ref=[]
submitted_demo=[]
original_submit=C6IShellRuntimeBackend._submit_menu_frame_locked
def record_submission(self):
    before=self._menu_frame_id
    result=original_submit(self)
    if self.page is MenuPage.HAND_DEMO and self._menu_frame_id!=before:
        value=dict(self._demo_status)
        key=(value.get('generation'),value.get('pose'),value.get('phase'),value.get('index'))
        if not submitted_demo or submitted_demo[-1]['key']!=key:
            submitted_demo.append(dict(key=key,at=time.monotonic(),frame=self._menu_frame_id,state=value))
            if len(submitted_demo)>256:raise AssertionError('bounded demo evidence overflow')
    return result
C6IShellRuntimeBackend._submit_menu_frame_locked=record_submission
def check(label,condition,**detail):
    report['checks'].append(dict(name=label,passed=bool(condition),**detail))
    save()
    print('R43_CHECK',label,bool(condition),flush=True)
    if not condition:raise AssertionError(label+': '+repr(detail))
def wait_for(predicate,seconds,label):
    deadline=time.monotonic()+seconds
    while time.monotonic()<deadline:
        if predicate():return
        if backend_ref and backend_ref[0]._last_error:raise RuntimeError(backend_ref[0]._last_error)
        if hand_sessions and hand_sessions[0].error:raise RuntimeError(hand_sessions[0].error)
        time.sleep(.1)
    raise TimeoutError(label)
def metric(label,before):
    now=time.monotonic();usage=resource.getrusage(resource.RUSAGE_SELF)
    report['metrics'].append(dict(stage=label,seconds=now-before[0],
       process_cpu_percent=100*(usage.ru_utime+usage.ru_stime-before[1])/(now-before[0]),
       peak_rss_kib=usage.ru_maxrss))
    save()
def mark():
    u=resource.getrusage(resource.RUSAGE_SELF)
    return time.monotonic(),u.ru_utime+u.ru_stime

def exercise(shell):
    original_input=shell._live_input
    scripted=Inputs(original_input)
    hand=hand_sessions[0]
    try:
        time.sleep(1)
        shell._live_input=scripted
        check('startup-and-real-gpu',shell._menu_frame_id>0 and shell._last_error is None,
              presented=shell._menu_frame_id)
        def send(x,y,pose='paper',seconds=.25):
            with shell._lock:scripted.set(x,y,pose)
            time.sleep(seconds)
        def home_choice(x,y,page):
            send(x,y,'paper');send(x,y,'fist')
            scripted.set(valid=False)
            wait_for(lambda:shell.page is page,5,'menu select '+page.value)
        def back_dialog():
            send(12,12,'paper',2.4)
            check('canvas-return-dwell',shell._canvas.dialog)
        # Real menu -> real canvas, actual packed resources and present completion.
        home_choice(228,132,MenuPage.CANVAS)
        check('canvas-menu-entry',shell.page is MenuPage.CANVAS)
        begin=mark()
        for index,(shape,y) in enumerate(zip(('triangle','square','circle','star'),(31,66,101,136))):
            send(288,y,'fist')
            check('select-'+shape,shell._canvas.shape==shape,pointer=shell._canvas.pointer,
                  observed=shell._canvas._frame,shape=shell._canvas.shape)
            send(60+index*45,60,'paper')
            revision=shell._canvas.revision
            send(60+index*45,60,'scissors')
            check('stamp-'+shape,shell._canvas.revision==revision+1)
            time.sleep(.3)
            check('held-scissors-single-'+shape,shell._canvas.revision==revision+1)
        old=shell._canvas.size
        send(306,168,'fist');check('size-plus',shell._canvas.size>old)
        send(269,168,'fist');check('size-minus',shell._canvas.size==old)
        r=shell._canvas.revision
        for x in range(35,235,6):send(x,125,'fist',.08)
        check('continuous-brush',shell._canvas.revision>=r+15,stamps=shell._canvas.revision-r)
        check('fixed-canvas-memory',len(shell._canvas.pixels)==46080)
        metric('canvas',begin)
        scripted.set(valid=False);time.sleep(.3)
        frame=shell._menu_frame_id;time.sleep(2)
        check('idle-canvas-no-submit',shell._menu_frame_id==frame)
        back_dialog();send(160,90,'paper',2.4)
        check('clear-canvas',not shell._canvas.dialog and set(shell._canvas.pixels)=={2})
        send(80,90,'paper');back_dialog();send(246,90,'paper',2.4)
        wait_for(lambda:shell.page is MenuPage.HOME,5,'canvas home')
        check('canvas-return-home',True)
        # Actual parent/UDP/child/SDK-memory page stage receipts drive HDMI.
        begin=mark()
        first_submission=len(submitted_demo)
        home_choice(92,132,MenuPage.HAND_DEMO)
        phases=[];poses=[];deadline=time.monotonic()+60
        while shell.page is MenuPage.HAND_DEMO and time.monotonic()<deadline:
            state=hand.page_status()
            if state.get('phase') not in phases:phases.append(state.get('phase'))
            pose=state.get('pose')
            if not poses or poses[-1]!=pose:poses.append(pose)
            if hand.error or shell._last_error:raise RuntimeError(hand.error or shell._last_error)
            time.sleep(.15)
        check('demo-auto-home',shell.page is MenuPage.HOME,poses=poses,phases=phases)
        targets=['demo:'+str(i) for i in range(10)]+['demo:heart']
        check('demo-all-targets-in-order',[p for p in poses if p in targets]==targets,poses=poses)
        displayed=[]
        for value in submitted_demo[first_submission:]:
            pose=value['state'].get('pose')
            if not displayed or displayed[-1]!=pose:displayed.append(pose)
        check('default-before-each-target',all(i>0 and displayed[i-1]=='default' for i,p in enumerate(displayed) if p in targets),displayed=displayed)
        check('all-targets-presented-on-gpu',[p for p in displayed if p in targets]==targets)
        wait_for(lambda:hand.page_status().get('off'),6,'demo final OFF')
        check('demo-final-off',hand.page_status().get('off'))
        metric('demo',begin)
        home_choice(92,132,MenuPage.HAND_DEMO)
        wait_for(lambda:hand.page_status().get('pose')=='demo:0',10,'cancel target')
        send(12,12,'paper',2.4)
        scripted.set(valid=False)
        wait_for(lambda:shell.page is MenuPage.HOME,12,'demo cancel OFF home')
        check('demo-midway-return-off',hand.page_status().get('off'))
        for game in ('game1','game2','game3'):
            shell.start_game(game);time.sleep(1)
            check(game+'-running',shell.snapshot.last_error is None)
            shell.open_game_menu();time.sleep(.25)
            check(game+'-pause',shell.game_menu_active)
            shell.resume_game();time.sleep(.25)
            shell.return_to_menu();time.sleep(.3)
        check('games-return-home',shell.page is MenuPage.HOME)
        shell.play_library_video('default-sunset');time.sleep(15)
        check('video-after-creative-pages',shell.snapshot.last_error is None,
              frames=shell.snapshot.presented_frames)
        shell.return_to_menu();time.sleep(.5)
        # Short steady menu checks no test actions remain pending.
        begin=mark();scripted.set(valid=False);time.sleep(10)
        metric('idle-menu',begin)
        check('final-menu-no-error',shell.page is MenuPage.HOME and shell._last_error is None)
        report['result']='PASS'
    except BaseException as error:
        report['result']='FAIL';report['error']=str(error);report['traceback']=traceback.format_exc()
        print(report['traceback'],flush=True)
    finally:
        scripted.set(valid=False)
        # No new real input enters hand playback: its feed remains test-only.
        shell._live_input=original_input
        report['submitted_demo']=submitted_demo
        save()
        os.kill(os.getpid(),signal.SIGINT)

original_open=C6IButtonOsdRuntimeBackend.open
def open_and_schedule(self):
    result=original_open(self)
    if not backend_ref:
        backend_ref.append(self)
        threading.Thread(target=exercise,args=(self,),name='r43-bounded-automation',daemon=True).start()
    return result
C6IButtonOsdRuntimeBackend.open=open_and_schedule
sys.argv=[str(args.package/'start_board_test.py')]
try:
    runpy.run_path(sys.argv[0],run_name='__main__')
finally:
    report['normal_entry_returned']=True
    report['final_hand_status']=[h.status() for h in hand_sessions]
    save()
    if report['result']!='PASS':raise SystemExit(1)
