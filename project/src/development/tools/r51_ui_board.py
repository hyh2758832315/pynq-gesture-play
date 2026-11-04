"""R51 bounded ARM/HDMI album, transitions and restart automation.

Run: sudo -n /usr/local/share/pynq-venv/bin/python -B -u r51_ui_board.py
     --package PATH --hand-root PATH --hand-python PATH --output NEW_DIRECTORY
Outputs: checks.json, SDK-memory receipts, normal cleanup then a production re-exec.
Next: confirm new UI_SESSION_READY/empty album and normally stop the same PID.
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
from zipfile import ZipFile
from types import SimpleNamespace

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--package',type=Path,required=True)
parser.add_argument('--hand-root',type=Path,required=True)
parser.add_argument('--hand-python',type=Path,required=True)
parser.add_argument('--output',type=Path,required=True)
parser.add_argument('--video-id',default='default-sunset')
parser.add_argument('--section',choices=('full','video-restart','demo-recovery'),default='full')
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
from pynq_multimodal_game.game_testing import GameTestCase
from pynq_multimodal_game.game_validation import GameTestPlayback

report=dict(schema='r51-unattended-arm-hdmi-v1',result='RUNNING',
    boot_id=Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
    manifest_sha256=hashlib.sha256((args.package/'deployment_manifest.json').read_bytes()).hexdigest(),
    physical_hand=False,camera_and_gpu=True,synthetic_ui_input=True,section=args.section,
    checks=[],metrics=[],error=None)
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
        self.result_case=None
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
    def new_game_session(self,manifest,game_run):
        if self.result_case is None:return self.original.new_game_session(manifest,game_run)
        assert manifest.game_id=='game2' and manifest.inputs is None and self.result_case.seed==0
        return ResultInput(self.result_case,manifest)
    def __getattr__(self,name):return getattr(self.original,name)


class ResultInput:
    """Finite authored inputs with ordinary runtime/result UI, no terminal override."""
    def __init__(self,case,manifest):
        self.playback=GameTestPlayback(case,tick_hz=manifest.tick_hz,manifest=manifest)
    def sample_current_for_game(self,game_id,*,tick_id):
        assert game_id=='game2'
        return self.playback.input_at(tick_id),None
    def suspend(self):pass
    def resume(self):pass
    def release(self,message='stopped'):self.playback.close()

backend_ref=[]
submitted_demo=[]
loadings=[]
original_loading=C6IShellRuntimeBackend._show_content_loading
def record_loading(self,*a,**kw):
    result=original_loading(self,*a,**kw)
    title=a[0];now=time.monotonic()
    entry=next((v for v in loadings if v['title']==title),None)
    if entry is None and len(loadings)<80:
        entry=dict(title=title,at=now,frame=self._menu_frame_id,updates=0)
        loadings.append(entry)
    if entry is not None:
        entry.update(last_at=now,last_frame=self._menu_frame_id,updates=entry['updates']+1)
    else:
        report['loading_titles_truncated']=True
    return result
C6IShellRuntimeBackend._show_content_loading=record_loading
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
        def hold_until(x,y,predicate,label,seconds=8):
            # Input delivery and rendering run on another thread. Start the
            # real dwell and await its acknowledgement, not a guessed sleep.
            begin=time.monotonic();send(x,y,'paper',0)
            try:wait_for(predicate,seconds,label)
            finally:
                canvas=shell._canvas
                report.setdefault('ui_actions',[]).append(dict(label=label,
                    seconds=time.monotonic()-begin,page=shell.page.value,
                    dialog=canvas.dialog if canvas else None,
                    dialog_target=canvas.dialog_target if canvas else None,
                    dwell_progress=canvas.dialog_dwell.progress if canvas else None,
                    album_revision=shell._album_revision))
                save()
        def home_choice(x,y,page):
            send(x,y,'paper');send(x,y,'fist')
            wait_for(lambda:shell.page is page,5,'menu select '+page.value)
            scripted.set(valid=False)
        def back_dialog():
            hold_until(12,12,lambda:shell._canvas.dialog,'canvas return dwell')
            check('canvas-return-dwell',shell._canvas.dialog)
        if args.section=='demo-recovery':
            home_choice(92,132,MenuPage.HAND_DEMO)
            wait_for(lambda:hand.page_status().get('phase')=='PLAYING',10,'demo active')
            child_pid=hand.status()['child_pid']
            before=time.monotonic()
            # Withhold only this test session's page heartbeat. UDP vision,
            # state reads, UI and the checked SDK-memory child continue normally.
            publish_page=hand._publish_page
            def withhold_page():
                with hand._page_lock:hand._page_last_write=time.monotonic()+20
                publish_page()
            hand._publish_page=withhold_page
            try:
                time.sleep(3.84)
                wait_for(lambda:hand.page_status().get('phase')=='WAITING_COMMAND'
                         and hand.page_status().get('off'),8,'expired page confirmed OFF')
                state=hand.page_status()
                check('page-gap-keeps-owner-off',not hand.finished.is_set()
                      and hand.status()['child_pid']==child_pid
                      and state.get('release_confirmed_ids')==list(range(1,18)),state=state)
                wait_for(lambda:any(v['state'].get('phase')=='WAITING_COMMAND'
                                    for v in submitted_demo),4,'recovery status on HDMI')
                check('recovery-presented-on-hdmi',True)
            finally:
                hand._publish_page=publish_page
                with hand._page_lock:hand._page_last_write=-1
            wait_for(lambda:hand.page_status().get('command_resumes',0)>=1,8,'fresh command resumes')
            check('same-child-resumes',hand.status()['child_pid']==child_pid)
            wait_for(lambda:shell.page is MenuPage.HOME,65,'resumed demo completes')
            state=hand.page_status()
            check('resumed-demo-off-home',state.get('off') and state.get('command_gaps',0)>=1,
                  state=state)
            displayed=[]
            for value in submitted_demo:
                pose=value['state'].get('pose')
                if pose and (not displayed or displayed[-1]!=pose):displayed.append(pose)
            targets=['demo:'+str(i) for i in range(10)]+['demo:heart']
            check('resumed-targets-on-hdmi-once',[p for p in displayed if p in targets]==targets,
                  displayed=displayed)
        if args.section=='full':
            # Real menu -> real canvas, actual packed resources and present completion.
            home_choice(228,132,MenuPage.CANVAS)
            check('canvas-menu-entry',shell.page is MenuPage.CANVAS)
            begin=mark()
            for index,(shape,y) in enumerate(zip(('triangle','square','circle','star'),(31,66,101,136))):
                send(288,y,'paper')
                send(288,y,'fist')
                check('select-'+shape,shell._canvas.shape==shape,pointer=shell._canvas.pointer,
                      observed=shell._canvas._frame,shape=shell._canvas.shape)
                send(60+index*45,60,'paper')
                revision=shell._canvas.revision
                send(60+index*45,60,'fist')
                check('stamp-'+shape,shell._canvas.revision==revision+1)
                time.sleep(.3)
                check('held-fist-single-'+shape,shell._canvas.revision==revision+1)
            old=shell._canvas.size
            send(306,168,'paper');send(306,168,'fist');check('size-plus',shell._canvas.size>old)
            send(269,168,'paper');send(269,168,'fist');check('size-minus',shell._canvas.size==old)
            r=shell._canvas.revision
            for x in range(35,235,6):send(x,125,'fist',.08)
            check('continuous-brush',shell._canvas.revision>=r+15,stamps=shell._canvas.revision-r)
            check('fixed-canvas-memory',len(shell._canvas.pixels)==46080)
            back_dialog();hold_until(122,90,lambda:shell._album_revision==1,'first save')
            first=shell._album_pixels
            check('saved-snapshot',first==bytes(shell._canvas.pixels) and len(first)==46080)
            page=shell._canvas
            hold_until(12,168,lambda:shell.page is MenuPage.ALBUM,'album entry')
            check('album-entry',shell.page is MenuPage.ALBUM)
            send(100,90,'fist')
            check('album-read-only',shell._album_pixels is first)
            hold_until(12,12,lambda:shell.page is MenuPage.CANVAS,'album return')
            check('album-back-preserves-canvas',shell.page is MenuPage.CANVAS and shell._canvas is page)
            send(100,90,'paper');send(100,90,'fist')
            check('drawing-after-save-independent',shell._album_pixels is first and bytes(page.pixels)!=first)
            back_dialog();hold_until(122,90,lambda:shell._album_revision==2,'second save')
            check('latest-save-replaces',shell._album_revision==2 and shell._album_pixels==bytes(page.pixels)!=first)
            send(100,90,'paper')  # Leave the return button before another dwell.
            metric('canvas',begin)
            scripted.set(valid=False);time.sleep(.3)
            frame=shell._menu_frame_id;time.sleep(2)
            check('idle-canvas-no-submit',shell._menu_frame_id==frame)
            back_dialog();hold_until(198,90,lambda:not shell._canvas.dialog,'canvas clear')
            check('clear-canvas',not shell._canvas.dialog and set(shell._canvas.pixels)=={2})
            send(80,90,'paper');back_dialog()
            hold_until(274,90,lambda:shell.page is MenuPage.HOME,'canvas home')
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
            # HOME now resumes live following after the shell has verified
            # demo OFF. Its current generation must be LIVE, not remain OFF.
            wait_for(lambda:hand.page_status().get('phase')=='LIVE',8,'demo transfers to menu LIVE')
            check('demo-off-then-menu-live',hand._page_mode=='live')
            metric('demo',begin)
            home_choice(92,132,MenuPage.HAND_DEMO)
            wait_for(lambda:hand.page_status().get('pose')=='demo:0',10,'cancel target')
            hold_until(12,12,lambda:shell.page is MenuPage.HOME,'demo cancel',12)
            scripted.set(valid=False)
            wait_for(lambda:shell.page is MenuPage.HOME,12,'demo cancel OFF home')
            wait_for(lambda:hand.page_status().get('phase')=='LIVE',8,'cancel transfers to menu LIVE')
            check('demo-midway-off-then-menu-live',hand._page_mode=='live')
            for game in ('game1','game2','game3','game4'):
                shell.start_game(game);time.sleep(1)
                check(game+'-running',shell.snapshot.last_error is None)
                shell.open_game_menu();time.sleep(.25)
                check(game+'-pause',shell.game_menu_active)
                shell.resume_game();time.sleep(.25)
                shell.return_to_menu();time.sleep(.3)
            check('games-return-home',shell.page is MenuPage.HOME)
            # The normal game loop reaches actual terminal scenes; only its input
            # source is finite. Do not use test_case_json, which suppresses result UI.
            for name,outcome,action,x in (('rps-01-win','WON','restart',96),
                                          ('rps-02-lose','LOST','main-menu',224)):
                with ZipFile(args.package/'seed_games/game2.vvg') as archive:
                    scripted.result_case=GameTestCase.from_json(archive.read('tests/replays/'+name+'.json'))
                scripted.set(valid=False)
                shell.start_game('game2')
                wait_for(lambda:shell.game_menu_active,90,outcome+' result screen')
                game=shell._game
                check(outcome+'-actual-terminal',game.terminal_status==outcome and game.paused)
                check(outcome+'-score',shell._pause_renderer.score==game.last_frame.snapshot.score,
                      score=game.last_frame.snapshot.score,frame_id=shell._menu_frame_id)
                send(160,150,'paper');send(x,94,'paper',2.4)
                if action=='restart':
                    wait_for(lambda:shell._game is not None and shell._game is not game,
                             15,'result retry loading completes')
                    check('result-retry-fresh-game',shell._game is not game and not shell.game_menu_active
                          and shell._game.terminal_status is None)
                    shell.return_to_menu()
                else:
                    wait_for(lambda:shell.page is MenuPage.HOME and shell._game is None,
                             15,'result return loading completes')
                    check('result-return-menu',True)
                scripted.result_case=None
        else:
            # A nonempty real saved album must be cleared by the subsequent
            # full restart; an already-empty album would prove nothing.
            home_choice(228,132,MenuPage.CANVAS)
            send(288,101,'fist')
            wait_for(lambda:shell._canvas.shape=='circle',4,'restart setup select')
            send(80,80,'paper');send(80,80,'fist')
            wait_for(lambda:shell._canvas.revision>0,4,'restart setup paint')
            back_dialog();hold_until(122,90,lambda:shell._album_revision==1,'restart setup save')
            check('nonempty-album-before-restart',shell._album_pixels==bytes(shell._canvas.pixels)
                  and any(v!=2 for v in shell._album_pixels))
            send(80,90,'paper');back_dialog()
            hold_until(274,90,lambda:shell.page is MenuPage.HOME,'restart setup home')
        shell.play_library_video(args.video_id);time.sleep(15)
        check('video-after-creative-pages',shell.snapshot.last_error is None,
              frames=shell.snapshot.presented_frames)
        shell.return_to_menu();time.sleep(.5)
        # Short steady menu checks no test actions remain pending.
        begin=mark();scripted.set(valid=False);time.sleep(10)
        metric('idle-menu',begin)
        check('final-menu-no-error',shell.page is MenuPage.HOME and shell._last_error is None)
        check('album-survives-pages',
              (shell._album_revision==2 and shell._album_pixels is not None) if args.section=='full'
              else (shell._album_revision==1 and shell._album_pixels is not None))
        hold_until(12,12,lambda:shell._home_dialog,'home options')
        check('home-options',shell._home_dialog)
        hold_until(95,95,lambda:not shell._home_dialog,'home continue')
        check('home-continue',not shell._home_dialog and not shell._restart_requested)
        # Defer only delivery of the existing stop event until assertions have
        # been saved. The normal CLI cleanup/return73/exec path stays intact.
        callback=shell._restart_callback;requested=threading.Event()
        shell._restart_callback=requested.set
        old_startup_renderer=shell._startup_renderer
        old_startup_began=shell._startup_began
        hold_until(12,12,lambda:shell._home_dialog,'home options again')
        hold_until(225,95,requested.is_set,'home restart request')
        check('home-restart-request',requested.is_set() and shell._restart_requested)
        check('restart-uses-fresh-boot-display',shell._startup_renderer is not old_startup_renderer
              and shell._startup_began>old_startup_began and shell._startup_frame_id>0)
        expected_titles=(('CANVAS','ALBUM','MENU','HAND SHOW','OPTIONS')
                         if args.section=='full' else ('MENU','OPTIONS'))
        check('loading-feedback-all-pages',all(any(v['title']==name for v in loadings)
              for name in expected_titles))
        report['loadings']=loadings
        report['restart_expected']=True
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
        if report.get('restart_expected'):
            shell._restart_callback=callback
            callback()
        else:os.kill(os.getpid(),signal.SIGINT)

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
