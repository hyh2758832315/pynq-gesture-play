"""Reclaim completed upload copies only after local backup and installed checks.

Run: python -B tools/r58_reclaim_upload_cache.py --output NEW_DIR --ui UI_JSON ...
Output: NEW_DIR/completed-cache-cleanup.json, retained local archives/install roots.
Next: normal Studio installation with its unchanged free-space gate.
"""
import argparse
import hashlib
import json
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'python'))
from pynq_multimodal_game.studio.system_loader import run_process

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--output',type=Path,required=True)
p.add_argument('--ui',type=Path,nargs='+',required=True)
a=p.parse_args();items=[]
for ui in a.ui:
    receipt=Path(json.loads(ui.read_text(encoding='utf-8'))['receipt'])
    r=json.loads(receipt.read_text(encoding='utf-8'));assert r['result']=='PASS'
    archive=receipt.with_name('package.tar.gz')
    items.append(dict(transaction=r['transaction'],manifest=r['manifest_sha256'],
        archive_sha=hashlib.sha256(archive.read_bytes()).hexdigest(),local_backup=str(archive)))
code='items='+repr(items)+'''\nfrom pathlib import Path
import hashlib,json,sys,shutil,time
sys.path.insert(0,'/home/xilinx/voice-view-game/.studio-system/boot')
import system_board as b
base=Path('/home/xilinx/voice-view-game');cache=base/'.studio-system'
boot=Path('/proc/sys/kernel/random/boot_id').read_text().strip();b.gate(None,boot)
report=dict(before=shutil.disk_usage(base).free,archives=[])
for item in items:
 tid=item['transaction'];root=base/('studio-system-'+tid);archive=cache/tid/'package.tar.gz'
 if len(tid)!=32 or any(c not in '0123456789abcdef' for c in tid):raise ValueError('Transaction boundary')
 if archive.resolve()!=archive or root.resolve()!=root:raise ValueError('Path boundary')
 b.verify(root,item['manifest'])
 if hashlib.sha256(archive.read_bytes()).hexdigest()!=item['archive_sha']:raise ValueError('Backup identity')
 report['archives'].append(dict(**item,path=str(archive),bytes=archive.stat().st_size))
audit=cache/('completed-cache-cleanup-'+str(time.time_ns())+'.json')
audit.write_text(json.dumps(report,indent=2))
for item in report['archives']:
 Path(item['path']).unlink();item['removed']=True
 audit.write_text(json.dumps(report,indent=2))
report['after']=shutil.disk_usage(base).free
audit.write_text(json.dumps(report,indent=2));print(json.dumps(report))
'''
raw=run_process(['ssh','-b','192.168.2.1','-o','BatchMode=yes','-o','ConnectTimeout=8',
    'pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=360)
a.output.mkdir(parents=True,exist_ok=True)
(a.output/'completed-cache-cleanup.json').write_bytes(raw)
r=json.loads(raw);print(dict(freed=r['after']-r['before'],free=r['after']))
