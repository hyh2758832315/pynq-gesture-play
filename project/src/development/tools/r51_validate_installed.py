"""Run isolated R51 GPU/SDK-memory tests and prove clean in-process re-exec.

Run: .venv/Scripts/python.exe -B tools/r51_validate_installed.py
Outputs: build/studio-r51/{board-checks,board-release,restart-evidence}.json
and board-test.log. Next: restore the installed normal autostart service.
No physical hand commands, video subscription or test input in production files.
"""
import base64
import argparse
import hashlib
import json
from pathlib import Path
import shlex
import sys
import time
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.device import RemoteDeviceSession
from pynq_multimodal_game.studio.system_loader import SystemLoader,run_process
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output',type=Path,default=ROOT/'build/studio-r51')
parser.add_argument('--remote',default='/home/xilinx/voice-view-game/r51-ui-validation-a01')
parser.add_argument('--video-id',default='default-sunset')
parser.add_argument('--physical',action='store_true')
parser.add_argument('--observer-confirmed',action='store_true')
parser.add_argument('--physical-entry',type=Path,help='Explicit isolated physical acceptance entry in this workspace')
parser.add_argument('--section',choices=('full','video-restart','demo-recovery'),default='full')
args=parser.parse_args()
if args.physical and not args.observer_confirmed:raise ValueError('Physical mode requires current observer clearance')
out=args.output.resolve();remote=args.remote
ui=json.loads((out/'ui-system.json').read_text())
receipt=json.loads(Path(ui['receipt']).read_text());assert receipt['result']=='PASS'
installed=next(s['result'] for s in receipt['steps'] if s['name']=='installed')
root=installed['root'];identity=receipt['manifest_sha256']
def py(code,timeout=180):
    return run_process(['ssh','-o','BatchMode=yes','-o','ConnectTimeout=8','-b','192.168.2.1',
        'pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=timeout)
device=RemoteDeviceSession('192.168.2.99',8765,source_address='192.168.2.1',
                           expected_build_id=0xC0061000,source_ids=())
stopped=SystemLoader(device).remote('stop',receipt['transaction'],identity)
(out/'board-stop.json').write_text(json.dumps(stopped,indent=2));assert not stopped['running'] and not stopped['owners']
py(f"from pathlib import Path\nPath({remote!r}).mkdir(exist_ok=False)\n")
entry_source=(ROOT/'subprojects/ps_ui_r23b2/tools/r43_physical_acceptance.py' if args.physical
              else ROOT/'tools/r51_ui_board.py')
if args.physical_entry is not None:
    if not args.physical or not args.physical_entry.resolve().is_relative_to(ROOT):
        raise ValueError('Physical test entry must be explicit and inside workspace')
    entry_source=args.physical_entry.resolve(strict=True)
sources=[(entry_source,'r51_ui_board.py')]
if not args.physical:sources.append((ROOT/'subprojects/ps_ui_r23b2/tools/r43_memory_child.py','r43_memory_child.py'))
for source,name in sources:
    raw=source.read_bytes();data=base64.b64encode(raw).decode()
    py(f"import base64,hashlib\nfrom pathlib import Path\nb=base64.b64decode({data!r});assert hashlib.sha256(b).hexdigest()=={hashlib.sha256(raw).hexdigest()!r}\nwith Path({(remote+'/'+name)!r}).open('xb') as f:f.write(b)\n")
command=['/usr/local/share/pynq-venv/bin/python','-B','-u',remote+'/r51_ui_board.py',
    '--package',root,'--hand-root',root+'/hand-runtime',
    '--hand-python','/home/xilinx/pynq-usb-hand/board-20261023-r01/venv/bin/python',
    '--output',remote+'/run','--video-id',args.video_id]
if args.physical:command+=['--observer-confirmed','--check-restart']
else:command+=['--section',args.section]
record=json.loads(py(f"import json,sys,subprocess,time\nfrom pathlib import Path\nsys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')\nimport system_board as b\nboot=Path('/proc/sys/kernel/random/boot_id').read_text().strip();b.verify(Path({root!r}),{identity!r});b.gate(None,boot)\nwith Path({(remote+'/console.log')!r}).open('xb') as f:p=subprocess.Popen({command!r},stdout=f,stderr=subprocess.STDOUT,start_new_session=True)\nprint(json.dumps(dict(root={root!r},boot_id=boot,pid=p.pid,start_ticks=b.processes()[p.pid]['ticks'],started=time.time(),manifest_sha256={identity!r},hand_enabled={args.physical!r})))\n"))
(out/'test-owner.json').write_text(json.dumps(record,indent=2))
print(('Observed physical test' if args.physical else 'Dedicated GPU/SDK-memory test')+' started PID '+str(record['pid']),flush=True)
# Include both full startup/library checks plus the expanded finite test body
# (two 957-tick terminal games, or the 180-second human window). Individual
# stage deadlines in the board helper remain unchanged.
deadline=time.monotonic()+(1200 if args.physical else 900);last=None;field_waited=False
while True:
    progress=json.loads(py(f"import json\nfrom pathlib import Path\np=Path({(remote+'/run/checks.json')!r});r=json.loads(p.read_text()) if p.exists() else {{}}\nlog=Path({(remote+'/console.log')!r}).read_text(errors='replace')\nprint(json.dumps(dict(result=r.get('result'),checks=len(r.get('checks',[])),error=r.get('error'),ready=log.count('UI_SESSION_READY '),reexec='UI_RESTART_CLEANUP_CONFIRMED' in log,field='PHYSICAL_FIELD_READY' in log,physical_phase=[l for l in log.splitlines() if l.startswith('PHYSICAL_PHASE')][-1:])))\n"))
    if progress!=last:print(json.dumps(progress),flush=True);last=progress
    if progress.get('result')=='FAIL':
        # Preserve the first failed assertion before the helper's normal exit.
        for source,target in (('run/checks.json','board-checks.json'),('console.log','board-test.log')):
            (out/target).write_bytes(py(f"from pathlib import Path\nprint(Path({(remote+'/'+source)!r}).read_text())\n"))
        try:
            cleanup=py(f"import json,sys\nfrom pathlib import Path\nsys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')\nimport system_board as b\nr={record!r};boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip();b.stop_owned(r,boot);b.gate(None,boot)\nprint(json.dumps(dict(result='PASS',owners=[])))\n")
            (out/'failure-release.json').write_bytes(cleanup)
        except Exception as error:
            (out/'failure-release-error.txt').write_text(str(error),encoding='utf-8')
        raise RuntimeError('Board test failed: '+str(progress))
    accepted='AUTOMATED_PASS_OBSERVATION_PENDING' if args.physical else 'PASS'
    if progress.get('result')==accepted and progress['ready']>=2 and progress['reexec']:break
    if args.physical and progress['field'] and not field_waited:
        field_waited=True
        print('HUMAN_WINDOW: no additional remote reads for 185 seconds',flush=True)
        time.sleep(185)
        continue
    if time.monotonic()>deadline:raise TimeoutError('Test/restart still owns the board; no force stop')
    time.sleep(5)
checks=py(f"from pathlib import Path\nprint(Path({(remote+'/run/checks.json')!r}).read_text())\n")
(out/'board-checks.json').write_bytes(checks)
log=py(f"from pathlib import Path\nprint(Path({(remote+'/console.log')!r}).read_text())\n")
(out/'board-test.log').write_bytes(log)
ready=[json.loads(line.split('UI_SESSION_READY ',1)[1]) for line in log.decode().splitlines() if line.startswith('UI_SESSION_READY ')]
assert ready[-1]['album_empty'] and ready[-1]['canvas_empty']
result=json.loads(py(f"import json,sys\nfrom pathlib import Path\nsys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')\nimport system_board as b\nr={record!r};boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip();rows=b.processes();assert r['pid'] in b.owned_tree(rows,r,boot)\nprint(json.dumps(dict(pid=r['pid'],start_ticks=rows[r['pid']]['ticks'],argv=[v.decode() for v in rows[r['pid']]['argv'] if v])))\n"))
assert result['start_ticks']==record['start_ticks']
(out/'restart-evidence.json').write_text(json.dumps(dict(result='PASS',same_pid=True,
    owner=result,sessions=ready,album_cleared=True,physical_hand=args.physical),indent=2))
# The re-exec now is the normal registered entry path with the same PID/ticks;
# use the existing exact-identity stop contract, never a broad process kill.
release=py(f"import json,sys\nfrom pathlib import Path\nsys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')\nimport system_board as b\nr={record!r};boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip();b.stop_owned(r,boot);b.gate(None,boot)\nreceipts=[json.loads(p.read_text()) for p in Path(r['root']+'/var/vision').rglob('stop_receipt.json') if p.stat().st_mtime>=r['started']]\nprint(json.dumps(dict(result='PASS',owners=[],receipts=receipts)))\n")
(out/'board-release.json').write_bytes(release)
if not args.physical:
    memory=json.loads(py(f"import json\nfrom pathlib import Path\nrows=[json.loads(p.read_text()) for p in Path({(remote+'/run')!r}).rglob('sdk-memory-evidence.json')]\nassert rows and all(r['physical_serial_open_forbidden'] and r['all_off'] and r['all_closed'] and r['playback_reads']==0 for r in rows)\nprint(json.dumps(dict(result='PASS',physical_hand=False,evidence=rows)))\n"))
    (out/'memory-hand-release.json').write_text(json.dumps(memory,indent=2))
print(json.dumps(dict(result='PASS',checks=len(json.loads(checks)['checks']),restart=True,released=True)),flush=True)
