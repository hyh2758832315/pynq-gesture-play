"""Clear completed upload archives after matching installed copies, keep rollback roots.
Run: .venv/Scripts/python.exe -B tools/r54_clear_upload_caches.py
Output: build/studio-r54-fixed-board/upload-cache-cleanup.json.
Next: retry native Studio full-system installation. No board process is started.
"""
from pathlib import Path
import json
import argparse
import sys
sys.path.insert(0, 'python')
from pynq_multimodal_game.studio.system_loader import run_process
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--transactions',nargs='+')
parser.add_argument('--output',type=Path,default=Path('build/studio-r54-fixed-board/upload-cache-cleanup.json'))
options=parser.parse_args()

code = r'''
from pathlib import Path
import hashlib,json,shutil,tarfile,time
base=Path('/home/xilinx/voice-view-game').resolve();cache=base/'.studio-system'
active=json.loads((cache/'active.json').read_text())
ids=['617d849d04e3416785aa0c408e12ed60','e317ab06fce94c9490fb8747ac59c496',
     '578b6e0ecea04575989e897d74d62d32','26c79d6ce3c84f6ca4d26c545d1848d5',
     '0ede34d81775441abe490553de0af7a5']
if selected_ids is not None:ids=selected_ids
if any(len(i)!=32 or any(c not in '0123456789abcdef' for c in i) for i in ids):raise ValueError('Transaction identity')
record=dict(before=shutil.disk_usage(base).free,archives=[])
for ident in ids:
 folder=cache/ident;archive=folder/'package.tar.gz';root=base/('studio-system-'+ident)
 if archive.resolve()!=archive or archive.parent.parent!=cache or root.resolve()!=root:
  raise ValueError('Cache boundary or symlink')
 if str(root)==active['root']:raise ValueError('Active root excluded')
 start=json.loads((folder/'start.json').read_text())
 raw=(root/'deployment_manifest.json').read_bytes();sha=hashlib.sha256(raw).hexdigest()
 if sha!=start['manifest_sha256'].lower() or start['root']!=str(root):raise ValueError('Installed identity mismatch')
 with tarfile.open(archive,'r|gz') as bundle:
  for member in bundle:
   if member.name=='deployment_manifest.json':
    if bundle.extractfile(member).read()!=raw:raise ValueError('Archive manifest differs')
    break
  else:raise ValueError('No archive manifest')
 manifest=json.loads(raw)
 for name in manifest['sha256']:
  p=(root/name).resolve()
  if not p.is_relative_to(root) or not p.is_file():raise ValueError('Incomplete rollback copy')
 record['archives'].append(dict(path=str(archive),installed_root=str(root),
   manifest_sha256=sha,bytes=archive.stat().st_size))
audit=cache/('cache-cleanup-'+str(time.time_ns())+'.json')
audit.write_text(json.dumps(record,indent=2))
for value in record['archives']:
 Path(value['path']).unlink()
 value['removed']=True
 audit.write_text(json.dumps(record,indent=2))
record.update(after=shutil.disk_usage(base).free,audit=str(audit))
audit.write_text(json.dumps(record,indent=2));print(json.dumps(record))
'''
raw=run_process(['ssh','-b','192.168.2.1','-o','ConnectTimeout=8','pynq-z2',
                'sudo -n /usr/local/share/pynq-venv/bin/python -B -'],
                input=('selected_ids='+repr(options.transactions)+'\n'+code).encode(),timeout=180)
out=options.output;out.write_bytes(raw)
value=json.loads(raw)
print(dict(archives=len(value['archives']),freed=value['after']-value['before'],free=value['after']))
