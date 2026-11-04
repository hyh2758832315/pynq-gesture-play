"""Normal v3 board entry, no synthetic input, preview or validation time limit.

Run: sudo -n /usr/local/share/pynq-venv/bin/python -B start_board.py --hand-python PATH
Output: HDMI/Agent and normal receipts. Next: player control; Ctrl+C releases.
--without-hand --check-only validates pairing without hardware access.
"""
import argparse
import os
from pathlib import Path
import sys
from restore_assets import restore
ROOT=Path(__file__).resolve().parent
def command(o):
    argv=[sys.executable,'-B','-u',str(ROOT/'board_runtime/start_board_test.py')]
    if o.check_only:argv+=['--check-only']
    if not o.without_hand:
        argv+=['--hand-readonly-root',str(ROOT/'board_runtime/hand-runtime'),
          '--hand-readonly-python',str(o.hand_python.absolute()),'--hand-readonly-port',
          '/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00','--hand-serial-actions',
          '--hand-stage-waits','3','3','3','--hand-approval-seconds','3']
    return argv
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--hand-python',type=Path,default=ROOT/'hand/.venv/bin/python')
    p.add_argument('--without-hand',action='store_true');p.add_argument('--check-only',action='store_true')
    o=p.parse_args();restore();os.chdir(ROOT/'board_runtime');os.execv(sys.executable,command(o))
