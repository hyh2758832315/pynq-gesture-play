"""Collect v2 real serial shutdown receipts after the finite test released.

Run: .venv/Scripts/python.exe -B tools/v2_collect_physical_release.py
Output: build/studio-v2/physical/physical-release.json. Next: normal service.
Reads saved receipts only; never opens serial or measures actuators.
"""
import json
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.system_loader import run_process
out=ROOT/'build/studio-v2/physical'
owner=json.loads((out/'test-owner.json').read_text(encoding='utf-8'))
released=json.loads((out/'board-release.json').read_text(encoding='utf-8'))
assert released['result']=='PASS' and released['owners']==[]
code='owner='+repr(owner)+'''
import json
from pathlib import Path
root=Path(owner['root']);assert root.parent==Path('/home/xilinx/voice-view-game')
assert root.name.startswith('studio-system-')
rows=[]
for p in (root/'var/vision').rglob('serial-motion.json'):
 if p.stat().st_mtime<owner['started']:continue
 r=json.loads(p.read_text())
 assert r['backend_closed'] and r['release_confirmed'] and r['release_confirmed_ids']==list(range(1,18))
 assert r['controller']['lifecycle']=='CLOSED' and not r.get('error') and not r['controller'].get('error')
 rows.append(dict(path=str(p),receipt=r))
assert len(rows)>=2,'Original session and actual restarted session must both release'
print(json.dumps(dict(result='PASS',manifest_sha256=owner['manifest_sha256'],mechanical_verified=False,receipts=rows)))
'''
raw=run_process(['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','ConnectTimeout=20',
 'pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=40)
(out/'physical-release.json').write_bytes(raw)
print('PASS: both real serial sessions CLOSED, 17 OFF; no mechanical observation claim')
