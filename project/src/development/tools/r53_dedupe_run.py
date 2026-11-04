from pathlib import Path
import sys,json
sys.path.insert(0,'python')
from pynq_multimodal_game.studio.system_loader import run_process
plan=json.loads(Path('build/studio-r53/dedupe-plan.json').read_text())
code="""from pathlib import Path
import json,hashlib,os,shutil
base=Path('/home/xilinx/voice-view-game').resolve()
plan=PLAN
result=dict(before=shutil.disk_usage(base).free,linked=[])
def sha(p):
 d=hashlib.sha256()
 with p.open('rb') as f:
  for b in iter(lambda:f.read(1048576),b''):d.update(b)
 return d.hexdigest()
for group in plan['groups']:
 paths=[Path(p) for p in group['paths']]
 for p in paths:
  if p.is_symlink() or not p.resolve().is_relative_to(base) or p.stat().st_size!=group['size']:raise ValueError('Boundary/identity')
 anchor=next((p for p in paths if 'studio-system-f670bdd61ad34ba0a5b49b624b04321f' in str(p)),paths[0])
 if sha(anchor)!=group['sha256']:raise ValueError('Anchor hash')
 for p in paths:
  if p.samefile(anchor):continue
  if sha(p)!=group['sha256']:raise ValueError('Target hash')
  tmp=p.with_name(p.name+'.r53-link')
  os.link(anchor,tmp);os.replace(tmp,p)
  result['linked'].append(dict(path=str(p),anchor=str(anchor),sha256=group['sha256']))
result['after']=shutil.disk_usage(base).free
(base/'.studio-system/dedupe-r53.json').write_text(json.dumps(result,indent=2));print(json.dumps(result))
""".replace('PLAN',repr(plan))
raw=run_process(['ssh','-b','192.168.2.1','pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=600)
Path('build/studio-r53/dedupe-result.json').write_bytes(raw);r=json.loads(raw);print(dict(files=len(r['linked']),freed=r['after']-r['before'],free=r['after']))
