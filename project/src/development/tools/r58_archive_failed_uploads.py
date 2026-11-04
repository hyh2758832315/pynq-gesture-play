"""Preserve two abandoned upload archives locally before reclaiming board cache.

Run: .venv/Scripts/python.exe -B tools/r58_archive_failed_uploads.py
Output: build/studio-r58-board/archived-uploads and cleanup.json.
Next: normal Studio storage preflight; no installed directory is deleted.
"""
import hashlib
import argparse
import json
from pathlib import Path
import re
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'python'))
from pynq_multimodal_game.studio.system_loader import run_process

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--ids',nargs='+',default=['1810eefdd62a4990a2f1ec99e96c243b','249d07a3b32346dd82f7d876aa244b1d'])
p.add_argument('--output',type=Path,default=Path(__file__).resolve().parents[1]/'build/studio-r58-board/archived-uploads')
a=p.parse_args()
IDS=tuple(a.ids)
assert IDS and all(re.fullmatch('[a-f0-9]{32}',ident) for ident in IDS)
BASE='/home/xilinx/voice-view-game/.studio-system'
OUT=a.output.resolve()


def remote(code):
    return json.loads(run_process(['ssh','-b','192.168.2.1','-o','BatchMode=yes',
        '-o','ConnectTimeout=8','pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],
        input=code.encode(),timeout=120))


def main():
    OUT.mkdir(parents=True,exist_ok=True)
    guard=f'''from pathlib import Path
import hashlib,json,shutil,time
base=Path({BASE!r});active=json.loads((base/'active.json').read_text())
items=[]
for ident in {IDS!r}:
 folder=base/ident;p=folder/'package.tar.gz'
 if p.resolve()!=p or folder.parent!=base:raise ValueError('Cache boundary')
 if (folder/'start.json').exists() or active['root'].endswith('studio-system-'+ident):
  raise ValueError('Not an abandoned upload')
 items.append(dict(id=ident,path=str(p),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),bytes=p.stat().st_size))
'''
    items=remote(guard+'print(json.dumps(items))\n')
    for item in items:
        dest=OUT/(item['id']+'.tar.gz')
        if not dest.exists():
            run_process(['scp','-q','-o','BindAddress=192.168.2.1','pynq-z2:'+item['path'],str(dest)],timeout=120)
        if hashlib.sha256(dest.read_bytes()).hexdigest()!=item['sha256']:
            raise ValueError('Local backup identity differs')
        item['local_backup']=str(dest)
    (OUT/'backups.json').write_text(json.dumps(items,indent=2),encoding='utf-8')
    result=remote(guard+f'''
expected={items!r}
for actual,saved in zip(items,expected):
 if any(actual[k]!=saved[k] for k in ('id','path','sha256','bytes')):raise ValueError('Cache changed')
audit=base/('archive-failed-uploads-'+str(time.time_ns())+'.json')
report=dict(backups=expected,before=shutil.disk_usage(base).free,removed=[])
audit.write_text(json.dumps(report,indent=2))
for item in items:
 Path(item['path']).unlink();report['removed'].append(item['id'])
 audit.write_text(json.dumps(report,indent=2))
report['after']=shutil.disk_usage(base).free
audit.write_text(json.dumps(report,indent=2));print(json.dumps(report))
''')
    (OUT/'cleanup.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps(dict(freed=result['after']-result['before'],free=result['after'],backups=str(OUT))))


if __name__=='__main__':main()
