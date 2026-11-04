"""Validate the Studio-installed R49 candidate through an isolated board run.

Run: .venv/Scripts/python.exe -B tools/r49_validate_installed.py
Outputs: build/studio-r49/board-stop.json, arm-*.json, board-checks.json,
board-test.log and board-release.json. Next: restore normal autostart only
after the explicit cleanup receipt and empty-owner checks succeed.
"""
import json
import base64
import hashlib
import argparse
from pathlib import Path
import shlex
import sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.system_loader import SystemLoader,run_process
from pynq_multimodal_game.studio.device import RemoteDeviceSession
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output',type=Path,default=ROOT/'build/studio-r49')
parser.add_argument('--remote-tag',default='r49-canvas-validation-a02')
parser.add_argument('--fist-only',action='store_true')
args=parser.parse_args()
import re
assert re.fullmatch(r'r[0-9]+-canvas-validation-a[0-9]+',args.remote_tag)
out=args.output.resolve()
ui=json.loads((out/'ui-system.json').read_text())
receipt=json.loads(Path(ui['receipt']).read_text())
assert receipt['result']=='PASS'
installed=next(s['result'] for s in receipt['steps'] if s['name']=='installed')
root=installed['root'];identity=receipt['manifest_sha256']
def ssh(code,timeout=180):
    return run_process(['ssh','-o','BatchMode=yes','-o','ConnectTimeout=8','-b','192.168.2.1',
                        'pynq-z2',code],timeout=timeout)
def py(code):
    return run_process(['ssh','-o','BatchMode=yes','-b','192.168.2.1','pynq-z2',
        'sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=60)
device=RemoteDeviceSession('192.168.2.99',8765,expected_build_id=0xC0061000,
                           source_address='192.168.2.1',source_ids=())
stopped=SystemLoader(device).remote('stop',receipt['transaction'],identity)
(out/'board-stop.json').write_text(json.dumps(stopped,indent=2))
assert not stopped['running'] and not stopped['owners']
print('Studio-owned system stopped with cleanup receipt',flush=True)
remote='/home/xilinx/voice-view-game/'+args.remote_tag
py(f"from pathlib import Path\np=Path({remote!r});p.mkdir(exist_ok=False)\n")
for name in ('r49_canvas_board.py','r49_canvas_benchmark.py'):
    data=(ROOT/'tools'/name).read_bytes()
    encoded=base64.b64encode(data).decode('ascii')
    py(f"import base64,hashlib\nfrom pathlib import Path\ndata=base64.b64decode({encoded!r})\nassert hashlib.sha256(data).hexdigest()=={hashlib.sha256(data).hexdigest()!r}\np=Path({(remote+'/'+name)!r})\nwith p.open('xb') as f:f.write(data)\n")
for tag,package in (('before',installed['previous_root']),('after',root)):
    command=shlex.join(['sudo','-n','/usr/local/share/pynq-venv/bin/python','-B',remote+'/r49_canvas_benchmark.py',
        '--package',package,'--output',remote+'/arm-'+tag+'.json'])
    raw=ssh(command)
    result=json.loads(raw.decode().splitlines()[-1])
    (out/('arm-'+tag+'.json')).write_text(json.dumps(result,indent=2))
    print(tag,result,flush=True)
before=py(f"import json,sys\nfrom pathlib import Path\nsys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')\nimport system_board as b\nr=Path({root!r});b.verify(r,{identity!r});b.gate(None,Path('/proc/sys/kernel/random/boot_id').read_text().strip())\nprint(json.dumps([str(p) for p in (r/'var/vision').rglob('stop_receipt.json')]))\n")
old_receipts=json.loads(before)
command=shlex.join(['sudo','-n','/usr/local/share/pynq-venv/bin/python','-B','-u',remote+'/r49_canvas_board.py',
                    '--package',root,'--output',remote+'/run']+(['--fist-only'] if args.fist_only else []))
raw=ssh(command,timeout=360)
(out/'board-test.log').write_bytes(raw)
checked=json.loads(ssh('cat '+shlex.quote(remote+'/run/checks.json')))
(out/'board-checks.json').write_text(json.dumps(checked,indent=2))
assert checked['result']=='PASS' and checked['normal_entry_returned']
release=py(f"import json,sys\nfrom pathlib import Path\nsys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')\nimport system_board as b\nb.gate(None,Path('/proc/sys/kernel/random/boot_id').read_text().strip())\nb.verify(Path({root!r}),{identity!r})\nreceipts=[dict(path=str(p),value=json.loads(p.read_text())) for p in Path({root!r}+'/var/vision').rglob('stop_receipt.json') if str(p) not in {old_receipts!r}]\nassert receipts and all(r['value'].get('cleanup_confirmed') and not r['value'].get('error') for r in receipts)\nprint(json.dumps(dict(result='PASS',owners=[],receipts=receipts)))\n")
(out/'board-release.json').write_bytes(release)
print(json.dumps(dict(result='PASS',checks=len(checked['checks']),preview=checked['preview'],released=True)),flush=True)
