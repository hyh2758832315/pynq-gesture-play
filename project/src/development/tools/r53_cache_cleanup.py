"""Reclaim only obsolete, successfully unpacked Studio upload caches.
Run: .venv/Scripts/python.exe -B tools/r53_cache_cleanup.py
Output: build/studio-r53/cache-cleanup.json. Next: resume installed startup.
Preserves current/rollback archives, every installed tree and all receipts.
"""
from pathlib import Path
import sys,json
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.system_loader import run_process
code=r'''
from pathlib import Path
import json,hashlib,re,shutil
base=Path('/home/xilinx/voice-view-game');cache=base/'.studio-system'
active=json.loads((cache/'active.json').read_text());keep={Path(active['root']).name.removeprefix('studio-system-'),Path(active['previous_root']).name.removeprefix('studio-system-')}
result=dict(before=shutil.disk_usage(base).free,removed=[])
for folder in sorted(cache.iterdir()):
    if not folder.is_dir() or folder.is_symlink() or not re.fullmatch('[a-f0-9]{32}',folder.name) or folder.name in keep:continue
    archive=folder/'package.tar.gz';start=folder/'start.json'
    if not archive.is_file() or archive.is_symlink() or not start.is_file():continue
    record=json.loads(start.read_text());root=Path(record['root'])
    if root!=base/('studio-system-'+folder.name) or root.is_symlink():continue
    manifest=root/'deployment_manifest.json'
    if not manifest.is_file() or hashlib.sha256(manifest.read_bytes()).hexdigest()!=record['manifest_sha256']:continue
    info=dict(path=str(archive),bytes=archive.stat().st_size,sha256=hashlib.sha256(archive.read_bytes()).hexdigest(),root=str(root))
    # The extracted deployment, including its rollback assets, remains intact.
    if archive.resolve().parent!=folder.resolve() or folder.resolve().parent!=cache.resolve():raise ValueError('Cache boundary')
    archive.unlink();result['removed'].append(info)
result['after']=shutil.disk_usage(base).free
print(json.dumps(result))
'''
raw=run_process(['ssh','-o','BatchMode=yes','-b','192.168.2.1','pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=180)
(ROOT/'build/studio-r53/cache-cleanup.json').write_bytes(raw);print(raw.decode())
