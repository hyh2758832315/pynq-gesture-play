"""Refresh only provenance-listed files in our unpublished v2 snapshot.

Run: .venv/Scripts/python.exe -B tools/v2_sync_release_snapshot.py
Output: exact r02 board_runtime/current sources and latest verification copies.
Next: snapshot tests, seal, inspect curated Git diff. Never accesses the board.
"""
import hashlib
import json
import os
from pathlib import Path
import shutil
ROOT=Path(__file__).resolve().parents[1]
out=ROOT/'build/v2-release-repo/releases/v2.0'
if os.name=='nt':out=Path('\\\\?\\'+str(out))
assert not (out/'SHA256SUMS.json').exists(),'Do not alter a sealed release'
p=json.loads((out/'PROVENANCE.json').read_text(encoding='utf-8'));origins=p['source_origin']
for name,origin in list(origins.items()):
    origin=origin.replace('build/ps-ui-v2-canvas-menu-r01/','build/ps-ui-v2-canvas-menu-r02/')
    src=ROOT/origin;dst=out/name
    if not src.is_file() or not dst.resolve().is_relative_to(out.resolve()):raise ValueError(name)
    shutil.copy2(src,dst);origins[name]=origin
def copy(src,dst):
    dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst)
    origins[dst.relative_to(out).as_posix()]=src.relative_to(ROOT).as_posix()
for name in ('v2-regression-r02.xml','v2-startup.xml','v2-hand-state.xml','v2-studio-final.xml',
             'v2-instance-r03.xml','v2-lifecycle-r02.xml'):
    copy(ROOT/'build'/name,out/'verification'/name)
for directory,dirs,files in os.walk(ROOT/'build/studio-v2'):
    dirs[:]=[d for d in dirs if d not in ('__pycache__','r60-cache-backup','r01-cache-backup')]
    for name in files:
        src=Path(directory)/name
        if src.suffix in ('.json','.xml','.txt','.log','.png'):
            copy(src,out/'verification'/src.relative_to(ROOT/'build/studio-v2'))
for src in (ROOT/'tools/release_v2').iterdir():
    if src.is_file():copy(src,out/src.name)
for src in sorted(set((ROOT/'tools').glob('v2_*.py')) | {
        ROOT/'tools/publish_v2_release.py',ROOT/'tools/seal_v2_release.py',ROOT/'tools/package_v2_release.py'}):
    copy(src,out/'source/tools'/src.name)
p['runtime_manifest_sha256']=hashlib.sha256((out/'board_runtime/deployment_manifest.json').read_bytes()).hexdigest()
assert p['runtime_manifest_sha256']=='5f53d85d5bcdb8c871d387683cbf7b6b12c899b380b9370642c9bd2ff41e9d56'
(out/'PROVENANCE.json').write_text(json.dumps(p,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('SNAPSHOT_REFRESHED',len(origins),p['runtime_manifest_sha256'])
