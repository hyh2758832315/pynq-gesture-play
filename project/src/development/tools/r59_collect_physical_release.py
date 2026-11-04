"""Collect final physical-hand receipts after the isolated test has released.

Run: .venv/Scripts/python.exe -B tools/r59_collect_physical_release.py --output build/studio-r59-board/physical
Output: physical-release.json with original checked receipts and observation links.
Next: restore the accepted default service; this command never opens hardware.
"""
import argparse
import json
from pathlib import Path
import sys

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.system_loader import run_process

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--output',type=Path,required=True)
a=p.parse_args();out=a.output.resolve()
owner=json.loads((out/'test-owner.json').read_text(encoding='utf-8'))
released=json.loads((out/'board-release.json').read_text(encoding='utf-8'))
assert released['result']=='PASS' and released['owners']==[]
code='owner='+repr(owner)+'''
import json
from pathlib import Path
root=Path(owner['root'])
if root.parent!=Path('/home/xilinx/voice-view-game') or not root.name.startswith('studio-system-'):
 raise ValueError('Installed root boundary')
rows=[]
for path in (root/'var/vision').rglob('serial-motion.json'):
 if path.stat().st_mtime<owner['started']:continue
 r=json.loads(path.read_text())
 if (not r.get('release_confirmed') or r.get('release_confirmed_ids')!=list(range(1,18))
     or not r.get('backend_closed') or r['controller']['lifecycle']!='CLOSED'
     or r['controller'].get('error')):
  raise RuntimeError('Final physical release unconfirmed: '+str(path))
 rows.append(dict(path=str(path),receipt=r))
if not rows:raise RuntimeError('No physical release receipts')
print(json.dumps(dict(result='PASS',manifest_sha256=owner['manifest_sha256'],receipts=rows)))
'''
raw=run_process(['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','ConnectTimeout=8',
    'pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=30)
result=json.loads(raw)
result['observation']=json.loads((out/'observer.json').read_text(encoding='utf-8'))
assert result['observation']['passed'] is True
assert result['observation']['manifest_sha256']==owner['manifest_sha256']
(out/'physical-release.json').write_text(json.dumps(result,indent=2,ensure_ascii=False),encoding='utf-8')
print(json.dumps(dict(result='PASS',receipts=len(result['receipts']),observed=True)))
