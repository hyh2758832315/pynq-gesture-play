"""Observed physical R43 acceptance, through the unchanged normal entry.

Run on PYNQ after observer/clearance confirmation:
 sudo -n /usr/local/share/pynq-venv/bin/python -B -u r43_physical_acceptance.py
 --package PATH --hand-root PATH --hand-python PATH --output NEW_DIRECTORY
 --observer-confirmed
Outputs: checks.json plus original startup, serial owner and vision receipts.
Next: collect physical observations and final 17 OFF/vision cleanup receipts.
No backend/serial/source substitution, extra motor reads, forced kill or PL change.
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

parser=argparse.ArgumentParser(description=__doc__)
for name in ('package','hand-root','hand-python','output'):
    parser.add_argument('--'+name,type=Path,required=True)
parser.add_argument('--observer-confirmed',action='store_true',required=True)
parser.add_argument('--video-id',default='default-sunset')
parser.add_argument('--check-restart',action='store_true')
args=parser.parse_args()
args.output.mkdir(parents=True,exist_ok=False)
sys.path.insert(0,str(args.package/'python'))
from pynq_multimodal_game.agent.button_osd_backend import C6IButtonOsdRuntimeBackend
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
from pynq_multimodal_game.controls import MockControlAdapter,ControlSource
from pynq_multimodal_game.menu import MenuPage

report=dict(schema='r43-observed-physical-v1',result='RUNNING',physical_hand=True,
    observer_confirmed=args.observer_confirmed,mechanical_verified=False,
    boot_id=Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
    manifest_sha256=hashlib.sha256((args.package/'deployment_manifest.json').read_bytes()).hexdigest(),
    checks=[],submitted_demo=[],error=None,field_window_complete=False)
def save():
    temp=args.output/'checks.tmp'
    temp.write_text(json.dumps(report,indent=2),encoding='utf-8')
    temp.replace(args.output/'checks.json')
save()

class Inputs:
    """Bounded menu-only UI actions; the hand retains its REAL vision provider."""
    def __init__(self,original):
        self.original=original;self.xy=(160,90);self.pose=None;self.valid=False
        self.seq=0;self.frame=0;self.source_at=time.monotonic()
        self.base=MockControlAdapter(ControlSource.KEYBOARD).read(tick_id=0,timestamp_ns=0)
    def set(self,x=160,y=90,pose=None,valid=True):
        self.xy=(x,y);self.pose=pose;self.valid=valid;self.seq+=1;self.frame+=1;self.source_at=time.monotonic()
    def sample_menu_control(self,*,tick_id):
        return replace(self.base,tick_id=tick_id,timestamp_ns=time.monotonic_ns(),
            hand_valid=self.valid,hand_x=self.xy[0]*2/319-1,hand_y=self.xy[1]*2/179-1,
            gesture_seq=self.seq,fist_score=float(self.pose=='fist'),fist_event=self.pose=='fist')
    def peek_menu_control(self):return self.sample_menu_control(tick_id=0)
    def peek_hand_classification(self):
        frame=int(time.monotonic()*20)
        return dict(run_id='r43-physical-ui-only',config_epoch='test',frame_id=frame,
                    source_at=frame/20,valid=self.valid,gesture=self.pose)
    def __getattr__(self,name):return getattr(self.original,name)

backend_ref=[]
hand_ref=[]
phase='startup'
original_submit=C6IShellRuntimeBackend._submit_menu_frame_locked
def record_submission(self):
    before=self._menu_frame_id
    result=original_submit(self)
    if self.page is MenuPage.HAND_DEMO and self._menu_frame_id!=before:
        state=dict(self._demo_status)
        key=(phase,state.get('generation'),state.get('pose'),state.get('phase'),state.get('index'))
        previous=report['submitted_demo'][-1]['key'] if report['submitted_demo'] else None
        if previous!=key:
            report['submitted_demo'].append(dict(key=key,at=time.monotonic(),frame=self._menu_frame_id,state=state))
            if len(report['submitted_demo'])>512:raise AssertionError('bounded evidence overflow')
    return result
C6IShellRuntimeBackend._submit_menu_frame_locked=record_submission

def check(name,condition,**detail):
    report['checks'].append(dict(name=name,passed=bool(condition),**detail))
    save();print('PHYSICAL_CHECK',name,bool(condition),flush=True)
    if not condition:raise AssertionError(name+': '+repr(detail))
def wait_for(predicate,seconds,label):
    deadline=time.monotonic()+seconds
    while time.monotonic()<deadline:
        if backend_ref[0]._last_error or hand_ref[0].error:
            raise RuntimeError(backend_ref[0]._last_error or hand_ref[0].error)
        if predicate():return
        time.sleep(.15)
    raise TimeoutError(label)

def exercise(shell):
    global phase
    hand=shell._hand_session;hand_ref.append(hand)
    real_input=shell._live_input;scripted=Inputs(real_input)
    preview=None
    restart_callback=None
    try:
        check('real-startup-readonly-gate',hand.gate.passed is True,report=str(hand.gate.report_path))
        check('original-physical-child',hand.entry==args.package/'hand_child/serial_motion_receiver.py',
              child_pid=hand.status()['child_pid'],session=hand.session)
        child_pid=hand.status()['child_pid']
        print('PHYSICAL_READY: full demo starts in 8 seconds; observe the actual hand and HDMI.',flush=True)
        shell._live_input=scripted
        time.sleep(8)
        def send(x,y,pose='paper',seconds=.3):
            with shell._lock:scripted.set(x,y,pose)
            time.sleep(seconds)
        def choose_hand():
            assert shell.page is MenuPage.HOME
            send(92,132);send(92,132,'fist')
            wait_for(lambda:shell.page is MenuPage.HAND_DEMO,6,'HAND entry')
            scripted.set(valid=False)
        def confirmed_off():
            # Video/preview suppress unused page I/O. The parent has separately
            # validated the interlock's 17-OFF receipt before exposing this pair.
            lifecycle=hand.status()
            if lifecycle.get('phase')=='PAUSED' and lifecycle.get('preview_allowed') is True:
                return True
            value=hand.page_status()
            return value.get('off') is True and value.get('release_confirmed_ids')==list(range(1,18))
        def await_home(label):
            wait_for(lambda:shell.page is MenuPage.HOME,12,label)
            wait_for(confirmed_off,8,label+' OFF')
            check(label,True,hand=hand.page_status())
            check(label+'-same-owner',hand.status()['child_pid']==child_pid)
        phase='full-demo'
        start=len(report['submitted_demo']);choose_hand()
        print('PHYSICAL_PHASE full-demo: 0..9 and heart, default before every target',flush=True)
        wait_for(lambda:shell.page is MenuPage.HOME,65,'full demo')
        poses=[]
        for row in report['submitted_demo'][start:]:
            pose=row['state'].get('pose')
            if not poses or poses[-1]!=pose:poses.append(pose)
        targets=['demo:'+str(i) for i in range(10)]+['demo:heart']
        check('all-eleven-physical-stage-receipts',[p for p in poses if p in targets]==targets,displayed=poses)
        check('default-before-every-target',all(i>0 and poses[i-1]=='default' for i,p in enumerate(poses) if p in targets))
        await_home('complete-auto-home-off')
        phase='cancel-default';choose_hand()
        wait_for(lambda:hand.page_status().get('pose')=='default' and hand.page_status().get('index',0)>=1,15,'default cancel point')
        print('PHYSICAL_PHASE cancel-default',flush=True)
        shell.return_to_menu();await_home('default-stage-cancel')
        phase='cancel-middle';choose_hand()
        wait_for(lambda:hand.page_status().get('pose')=='demo:5',25,'middle cancel point')
        print('PHYSICAL_PHASE cancel-middle through 2-second return button',flush=True)
        send(12,12,'paper',0)
        wait_for(lambda:shell.page is MenuPage.HOME,12,'middle dwell and loading')
        scripted.set(valid=False)
        await_home('middle-dwell-cancel')
        phase='preview-interlock';choose_hand()
        wait_for(lambda:hand.page_status().get('pose')=='demo:0',12,'preview handover point')
        print('PHYSICAL_PHASE preview handover: hand must be OFF before image encoding',flush=True)
        preview=urllib.request.urlopen('http://192.168.2.99:8081/camera.mjpg',timeout=12)
        wait_for(lambda:hand.status()['phase']=='PAUSED' and hand.status()['preview_allowed'],10,'preview 17 OFF')
        check('preview-after-physical-off',True,hand=hand.status())
        data=preview.read(4096)
        check('preview-real-jpeg',b'Content-Type: image/jpeg' in data and b'\xff\xd8' in data)
        preview.close();preview=None
        wait_for(lambda:not hand._requested(),5,'preview unsubscribe')
        wait_for(lambda:shell.page is MenuPage.HOME,15,'interrupted demo must not restart')
        await_home('preview-interruption-home')
        phase='canvas-with-hand-off'
        send(228,132);send(228,132,'fist');scripted.set(valid=False)
        wait_for(lambda:shell.page is MenuPage.CANVAS,6,'canvas')
        wait_for(confirmed_off,8,'canvas OFF')
        for index,(shape,y) in enumerate(zip(('triangle','square','circle','star'),(31,66,101,136))):
            send(288,y,'fist')
            wait_for(lambda:shell._canvas.shape==shape,4,'canvas select '+shape)
            check('canvas-'+shape,shell._canvas.shape==shape)
            send(50+index*40,90,'paper')
            revision=shell._canvas.revision
            send(50+index*40,90,'fist')
            wait_for(lambda:shell._canvas.revision>revision,4,'canvas paint '+shape)
            check('canvas-paint-'+shape,shell._canvas.revision>revision)
        check('canvas-hand-stays-off',confirmed_off())
        shell.return_to_menu();await_home('canvas-return')
        phase='video-with-hand-off'
        shell.play_library_video(args.video_id);time.sleep(8)
        check('video-hand-off',confirmed_off() and shell.snapshot.last_error is None)
        shell.return_to_menu();await_home('video-return')
        # All following input is physical camera input; no scripted menu driver
        # and no periodic inspection during the user's interaction window.
        phase='human-game-and-canvas'
        shell._live_input=real_input
        shell.start_game('game1')
        print('PHYSICAL_FIELD_READY: 180 seconds, real camera only; test gestures, pause, canvas and HAND.',flush=True)
        time.sleep(180)
        report['field_window_complete']=True
        phase='finish'
        shell._live_input=scripted;scripted.set(valid=False)
        shell.return_to_menu()
        wait_for(lambda:shell.page is MenuPage.HOME,12,'field return')
        wait_for(confirmed_off,10,'field OFF')
        check('field-final-home-off',True)
        check('one-child-entire-session',hand.status()['child_pid']==child_pid)
        if args.check_restart:
            phase='full-physical-restart'
            send(12,12,'paper',0)
            wait_for(lambda:shell._home_dialog,8,'home restart dialog')
            check('physical-home-restart-dialog',shell._home_dialog)
            restart_callback=shell._restart_callback
            requested=threading.Event()
            shell._restart_callback=requested.set
            previous_startup_renderer=shell._startup_renderer
            send(225,95,'paper',0)
            wait_for(requested.is_set,8,'home restart request')
            check('physical-home-restart-request',requested.is_set() and shell._restart_requested)
            check('physical-restart-boot-display',shell._startup_renderer is not previous_startup_renderer
                  and shell._startup_frame_id>0)
            report['restart_expected']=True
            report['old_hand_session']=hand.session
        report['result']='AUTOMATED_PASS_OBSERVATION_PENDING'
    except BaseException as error:
        report['result']='FAIL';report['error']=str(error);report['traceback']=traceback.format_exc()
        print(report['traceback'],flush=True)
    finally:
        if preview is not None:preview.close()
        scripted.set(valid=False)
        shell._live_input=scripted
        hand.set_page_mode('idle')
        report['hand_output_dir']=str(hand.output_dir)
        save()
        if report.get('restart_expected'):
            shell._live_input=real_input
            shell._restart_callback=restart_callback
            restart_callback()
        else:os.kill(os.getpid(),signal.SIGINT)

original_open=C6IButtonOsdRuntimeBackend.open
def open_and_schedule(self):
    result=original_open(self)
    if not backend_ref:
        backend_ref.append(self)
        threading.Thread(target=exercise,args=(self,),name='r43-observed-acceptance',daemon=True).start()
    return result
C6IButtonOsdRuntimeBackend.open=open_and_schedule
sys.argv=[str(args.package/'start_board_test.py'),
    '--hand-readonly-root',str(args.hand_root),'--hand-readonly-python',str(args.hand_python),
    '--hand-readonly-port','/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00',
    '--hand-serial-actions','--hand-stage-waits','3','3','3','--hand-approval-seconds','3',
    '--hand-serial-seconds','600']
try:
    runpy.run_path(sys.argv[0],run_name='__main__')
finally:
    report['normal_entry_returned']=True
    report['final_hand_status']=[h.status() for h in hand_ref]
    save()
    if report['result']!='AUTOMATED_PASS_OBSERVATION_PENDING':raise SystemExit(1)
