"""Deduplicate immutable deployed artifacts without removing any rollback path.
Run: .venv/Scripts/python.exe -B tools/r53_r47_storage.py
Output: build/studio-r53-r47/storage.json. Next: native Studio full installation.
"""
from pathlib import Path
import json
import argparse
import sys
sys.path.insert(0, 'python')
from pynq_multimodal_game.studio.system_loader import run_process
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output',type=Path,default=Path('build/studio-r53-r47'))
parser.add_argument('--roots',nargs='+',help='Exact installed directory basenames to compare')
parser.add_argument('--manifest-files',action='store_true',help='Only immutable files listed in each deployment manifest')
parser.add_argument('--suffixes',nargs='+',choices=('.s2v','.bit','.hwh','.vvg','.dcp','.artifact'),
                    default=('.s2v','.bit','.hwh','.vvg'),help='Immutable artifact types to compare')
args=parser.parse_args()

code = r'''
from pathlib import Path
import hashlib,json,os,shutil
base=Path('/home/xilinx/voice-view-game').resolve()
def sha_file(path):
 d=hashlib.sha256()
 with path.open('rb') as f:
  for block in iter(lambda:f.read(1048576),b''):d.update(block)
 return d.hexdigest()
groups={};hashes={};result=dict(before=shutil.disk_usage(base).free,linked=[])
for root in (sorted(base.glob('studio-system-*')) if selected_roots is None else [base/name for name in selected_roots]):
 if root.parent!=base or not root.name.startswith('studio-system-'):raise ValueError('Installed root boundary')
 if not root.is_dir() or root.is_symlink():
  if selected_roots is not None:raise ValueError('Selected installed root is absent or a symlink: '+str(root))
  continue
 identities=json.loads((root/'deployment_manifest.json').read_text())['sha256'] if manifest_only else None
 candidates=[root/name for name in identities] if manifest_only else root.rglob('*')
 for p in candidates:
  if (not manifest_only and p.suffix not in selected_suffixes) or not p.is_file() or p.is_symlink():continue
  if not p.resolve().is_relative_to(base):raise ValueError('Boundary')
  s=p.stat();key=(s.st_dev,s.st_ino,s.st_size)
  if key not in hashes:
   hashes[key]=sha_file(p)
  if manifest_only and hashes[key]!=identities[p.relative_to(root).as_posix()].lower():
   raise ValueError('Frozen deployment file identity')
  if p.suffix=='.artifact':
   manifest=json.loads(p.with_name('manifest.json').read_text())
   if (not p.is_relative_to(root/'var/library') or manifest['asset_path']!=p.name
       or manifest['sha256']!=hashes[key] or manifest['length']!=s.st_size):
    raise ValueError('Immutable library artifact identity')
  groups.setdefault((s.st_size,hashes[key]),[]).append(p)
for (size,sha),paths in groups.items():
 anchor=paths[0]
 for p in paths[1:]:
  if p.samefile(anchor):continue
  # Files are frozen manifest artifacts; recheck identity immediately before replacement.
  if sha_file(p)!=sha or sha_file(anchor)!=sha:
   raise ValueError('Identity changed')
  temp=p.with_name(p.name+'.r47-link')
  os.link(anchor,temp);os.replace(temp,p)
  result['linked'].append(dict(path=str(p),anchor=str(anchor),sha256=sha,bytes=size))
result['after']=shutil.disk_usage(base).free
(base/'.studio-system'/('dedupe-'+str(__import__('time').time_ns())+'.json')).write_text(json.dumps(result,indent=2))
print(json.dumps(result))
'''
code='selected_roots='+repr(args.roots)+'\nselected_suffixes='+repr(tuple(args.suffixes))+'\nmanifest_only='+repr(args.manifest_files)+'\n'+code
raw=run_process(['ssh','-b','192.168.2.1','-o','ConnectTimeout=8','pynq-z2',
 'sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=600)
out=args.output;out.mkdir(parents=True,exist_ok=True)
(out/'storage.json').write_bytes(raw)
r=json.loads(raw);print(dict(files=len(r['linked']),freed=r['after']-r['before'],free=r['after']))
