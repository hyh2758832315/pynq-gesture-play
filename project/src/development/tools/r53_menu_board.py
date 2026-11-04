"""Check all four actual HDMI menu targets, then leave ordinary API testing ready.

Run on board: python -B -u r53_menu_board.py --entry INSTALLED/start_board_test.py
              --output NEW_DIRECTORY
Outputs: menu-checks.json; normal CLI keeps running until exact-owner SIGINT.
Next: use Studio's Agent API for replay/video acceptance and normal cleanup.
Only the temporary UI source is synthetic; no physical hand session is started.
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
p.add_argument('--entry',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
p.add_argument('--check-restart',action='store_true')
a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
sys.path.insert(0,str(a.entry.parent/'python'));os.environ['XILINX_XRT']='/usr'
from pynq_multimodal_game.agent.button_osd_backend import C6IButtonOsdRuntimeBackend
from pynq_multimodal_game.menu import MenuPage
from pynq_multimodal_game.controls import MockControlAdapter,ControlSource
report=dict(result='RUNNING',checks=[],physical_hand=False)
def save():
    tmp=a.output/'menu-checks.tmp';tmp.write_text(json.dumps(report,indent=2));tmp.replace(a.output/'menu-checks.json')
def check(name,value):
    report['checks'].append(dict(name=name,passed=bool(value)));save()
    if not value:raise AssertionError(name)
class Inputs:
    def __init__(self,original):
        self.original=original;self.xy=(160,90);self.pose='paper';self.valid=False
        self.base=MockControlAdapter(ControlSource.KEYBOARD).read(tick_id=0,timestamp_ns=0)
    def sample_menu_control(self,*,tick_id):
        return replace(self.base,tick_id=tick_id,timestamp_ns=time.monotonic_ns(),hand_valid=self.valid,
            hand_x=self.xy[0]*2/319-1,hand_y=self.xy[1]*2/179-1,fist_score=float(self.pose=='fist'))
    def peek_menu_control(self):return self.sample_menu_control(tick_id=0)
    def peek_hand_classification(self):
        return dict(run_id='r53-ui-only',config_epoch='isolated-test',frame_id=int(time.monotonic()*30),
                    source_at=time.monotonic()-.02,valid=self.valid,gesture=self.pose)
    def __getattr__(self,name):return getattr(self.original,name)
def exercise(shell):
    original=shell._live_input;source=Inputs(original)
    try:
        time.sleep(1);shell._live_input=source
        shell.return_to_menu()
        check('four-game-catalog',shell._game_ids[:4]==('game1','game2','game3','game4'))
        def wait(predicate,label):
            deadline=time.monotonic()+12
            while not predicate():
                if shell._last_error:raise RuntimeError(shell._last_error)
                if time.monotonic()>deadline:raise TimeoutError(label)
                time.sleep(.1)
        def send(x,y,pose):
            with shell._lock:
                source.xy=(x,y);source.pose=pose;source.valid=True
                poll=shell._menu_poll_id;page=shell.page;mode=shell.mode
            wait(lambda:shell._menu_poll_id>=poll+4 or shell.page!=page or shell.mode!=mode,
                 'input was not consumed: '+pose)
        for game_id,point in zip(('game1','game2','game3','game4'),((84,78),(236,78),(84,137),(236,137))):
            send(92,83,'paper');send(92,83,'fist');source.valid=False
            wait(lambda:shell.page is MenuPage.GAMES,'games submenu')
            check(game_id+'-card-layout',len(shell._targets)==5 and shell._targets[1].hit_width==140)
            send(*point,'paper');send(*point,'fist');source.valid=False
            wait(lambda:shell._active_game_id==game_id and shell.mode.value=='game',game_id)
            time.sleep(.8)
            check(game_id+'-gesture-selection',shell._active_game_id==game_id and shell.snapshot.last_error is None)
            shell.open_game_menu();check(game_id+'-pause-page',shell.game_menu_active)
            shell.resume_game();check(game_id+'-continue',not shell.game_menu_active)
            shell.return_to_menu();wait(lambda:shell.page is MenuPage.HOME,'return home')
            check(game_id+'-return',shell.page is MenuPage.HOME)
        shell._live_input=original
        report.update(result='PASS',input_restored=True)
        save()
        if a.check_restart:
            # This channel exists only in the finite, hand-disabled test owner.
            # The external verifier requests it after all exact-package replays.
            deadline=time.monotonic()+1800
            while not (a.output/'restart.request').exists():
                if time.monotonic()>deadline:raise TimeoutError('restart acceptance not requested')
                time.sleep(1)
            restart=dict(result='RUNNING',physical_hand=False)
            def save_restart():
                (a.output/'restart-checks.json').write_text(json.dumps(restart,indent=2))
            callback=shell._restart_callback
            def observed_restart():
                shell._live_input=original
                restart.update(result='REQUESTED',input_restored=True)
                save_restart()
                callback()  # Ordinary CLI cleanup and start_board_test re-exec.
            shell._restart_callback=observed_restart
            shell._live_input=source
            shell.return_to_menu()
            send(15,15,'paper')
            wait(lambda:shell._home_dialog,'home return dialog')
            restart['home_dialog']=True;save_restart()
            send(225,95,'paper')
            wait(lambda:shell._restart_requested,'home restart request')
    except BaseException as error:
        report.update(result='FAIL',error=str(error),traceback=traceback.format_exc(),
                      page=str(shell.page),mode=str(shell.mode),home_dialog=shell._home_dialog,
                      hovered=shell._input.hovered_id,confirm_armed=shell._input.confirm_armed)
        shell._live_input=original;save();os.kill(os.getpid(),signal.SIGINT)
    finally:save()
original_open=C6IButtonOsdRuntimeBackend.open
def open_and_test(self):
    result=original_open(self)
    assert self._hand_session is None
    threading.Thread(target=exercise,args=(self,),name='r53-finite-menu-test',daemon=True).start()
    return result
C6IButtonOsdRuntimeBackend.open=open_and_test
sys.argv=[str(a.entry)]
runpy.run_path(str(a.entry),run_name='__main__')

