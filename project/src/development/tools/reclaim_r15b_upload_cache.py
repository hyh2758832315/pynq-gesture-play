"""Reclaim only eight completed Studio uploads backed up byte-for-byte on PC.

Run: .venv/Scripts/python.exe -B tools/reclaim_r15b_upload_cache.py
Output: build/menu-video-preview-recovery/cache-reclaimed.json.
Next: retry standard Studio installation. No installed tree/content is removed.
"""
import hashlib,json,re,sys,tarfile
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'python'))
from pynq_multimodal_game.studio.system_loader import run_process
plan=json.loads((ROOT/'build/menu-video-preview-recovery/cache-plan.json').read_text())
assert len(plan)==8
for item in plan:
    path=Path(item['archive']).resolve(strict=True)
    assert path.is_relative_to(ROOT/'games_gesture/.loads')
    assert re.fullmatch('[a-f0-9]{32}',item['transaction'])
    with tarfile.open(path,'r:gz') as archive:
        assert hashlib.sha256(archive.extractfile('deployment_manifest.json').read()).hexdigest()==item['manifest']
    item['sha256']=hashlib.sha256(path.read_bytes()).hexdigest()
code='plan='+repr(plan)+'''\nfrom pathlib import Path
import hashlib,json,shutil
base=Path('/home/xilinx/voice-view-game/.studio-system').resolve()
report=dict(before=shutil.disk_usage(base).free,removed=[])
for row in plan:
    path=base/row['transaction']/'package.tar.gz'
    if path.is_symlink() or path.resolve()!=path or path.parent.parent!=base:raise ValueError('Path boundary')
    if path.stat().st_size!=row['size']:raise ValueError('Size mismatch')
    if hashlib.sha256(path.read_bytes()).hexdigest()!=row['sha256']:raise ValueError('PC backup mismatch')
    record=json.loads((path.parent/'start.json').read_text())
    if record['manifest_sha256']!=row['manifest']:raise ValueError('Completed install mismatch')
audit=base/'r15b-cache-reclaimed.json'
audit.write_text(json.dumps(dict(plan=plan,verified=True)))
for row in plan:
    path=base/row['transaction']/'package.tar.gz'
    path.unlink()
    report['removed'].append(row)
    audit.write_text(json.dumps(report,indent=2))
report['after']=shutil.disk_usage(base).free
audit.write_text(json.dumps(report,indent=2));print(json.dumps(report))
'''
raw=run_process(['ssh','-o','BatchMode=yes','-o','ConnectTimeout=8','-b','192.168.2.1',
                 'pynq-z2','sudo -n /usr/local/share/pynq-venv/bin/python -B -'],input=code.encode(),timeout=240)
(ROOT/'build/menu-video-preview-recovery/cache-reclaimed.json').write_bytes(raw)
result=json.loads(raw);print(json.dumps(dict(freed=result['after']-result['before'],free=result['after'])))
