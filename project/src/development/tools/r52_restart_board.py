"""Exercise one real home Restart, then exec the untouched installed entry.

Run on PYNQ: python -B -u r52_restart_board.py --package PATH --arguments JSON
             --output NEW_DIRECTORY
Outputs: before-restart.json, checks.json and ordinary entry logs.
Next: confirm new vision/hand identities, fresh 17-motor probe and normal stop.
Only UI dwell input is simulated; camera, startup checks and hand remain real.
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
p.add_argument('--arguments',required=True)
p.add_argument('--output',type=Path,required=True)
a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
sys.path.insert(0,str(a.package/'python'))
os.environ['XILINX_XRT']='/usr'
from pynq_multimodal_game.agent.button_osd_backend import C6IButtonOsdRuntimeBackend
from pynq_multimodal_game.controls import MockControlAdapter,ControlSource
from pynq_multimodal_game.startup_ui import StartupRenderer,StartupSnapshot,CheckState

def save(name,value):
    (a.output/name).write_text(json.dumps(value,indent=2,default=str))

def exercise(shell):
    callback=None
    try:
        time.sleep(1)
        # Stop the ordinary menu submit worker before the brief synchronous UI
        # check. No replacement camera provider or motor gesture feed is installed.
        shell._stop_menu()
        with shell._lock:
            before=shell.snapshot.vision
            assert before['state']=='RUNNING' and before['hand_session']['phase']=='ACTIVE'
            assert all(s in (CheckState.OK,CheckState.SKIP) for s in shell.startup_snapshot.states)
            save('before-restart.json',dict(vision=before,
                startup_states=shell.startup_snapshot.states,
                hand_output=str(shell._hand_session.output_dir),pid=os.getpid()))
            shell._album_pixels=bytes([2])*46080
            base=MockControlAdapter(ControlSource.KEYBOARD).read(tick_id=0,timestamp_ns=0)
            def control(x,y,t):
                return replace(base,hand_valid=True,hand_x=x*2/319-1,hand_y=y*2/179-1,
                               timestamp_ns=round(t*1e9))
            # Exactly the universal return and home-dialog dwell handlers used
            # by the real camera. The CLI callback is delayed only until evidence
            # is saved, then its normal cleanup/return73/re-exec runs unmodified.
            t=time.monotonic()
            shell.handle_control(control(12,12,t))
            assert shell.handle_control(control(12,12,t+2.1))=='back'
            callback=shell._restart_callback;requested=threading.Event()
            shell._restart_callback=requested.set
            shell.handle_control(control(225,95,t+2.2))
            assert shell.handle_control(control(225,95,t+4.3))=='restart'
            assert requested.is_set() and shell._restart_requested
            assert isinstance(shell._startup_renderer,StartupRenderer)
            assert shell._startup_snapshot==StartupSnapshot() and shell._startup_frame_id==1
            save('checks.json',dict(result='PASS',boot_renderer=True,
                 boot_snapshot_reset=True,real_hand=True,synthetic_hand_input=False,
                 restart_requested=True))
            shell._restart_callback=callback
        callback()
    except BaseException as error:
        save('checks.json',dict(result='FAIL',error=str(error),traceback=traceback.format_exc()))
        if callback is not None:shell._restart_callback=callback
        os.kill(os.getpid(),signal.SIGINT)

original_open=C6IButtonOsdRuntimeBackend.open
def open_and_schedule(self):
    result=original_open(self)
    threading.Thread(target=exercise,args=(self,),name='r52-single-restart',daemon=True).start()
    return result
C6IButtonOsdRuntimeBackend.open=open_and_schedule
sys.argv=[str(a.package/'start_board_test.py'),*json.loads(a.arguments)]
runpy.run_path(sys.argv[0],run_name='__main__')
