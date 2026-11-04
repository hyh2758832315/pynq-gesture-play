"""Restore large files from checked Git-friendly chunks, without network.

Run: python -B restore_assets.py
Output: exact frozen large assets. Next: python -B verify_release.py.
"""
import hashlib
import json
import os
from pathlib import Path

ROOT=Path(__file__).resolve().parent
if os.name=='nt' and not str(ROOT).startswith('\\\\?\\'):ROOT=Path('\\\\?\\'+str(ROOT))
def restore():
    manifest=ROOT/'LARGE_ASSETS.json'
    if not manifest.exists():return
    for name,entry in json.loads(manifest.read_text(encoding='utf-8')).items():
        dst=(ROOT/name).resolve()
        if not dst.is_relative_to(ROOT):raise ValueError('Asset path escapes release')
        if dst.exists():
            if hashlib.sha256(dst.read_bytes()).hexdigest()!=entry['sha256']:raise ValueError('Existing asset differs: '+name)
            continue
        dst.parent.mkdir(parents=True,exist_ok=True)
        tmp=dst.with_name(dst.name+'.restore-tmp');digest=hashlib.sha256()
        with tmp.open('xb') as stream:
            for item in entry['chunks']:
                part=(ROOT/item['path']).resolve()
                if not part.is_relative_to(ROOT):raise ValueError('Chunk path escapes release')
                data=part.read_bytes()
                if hashlib.sha256(data).hexdigest()!=item['sha256']:raise ValueError('Chunk identity: '+str(part))
                digest.update(data);stream.write(data)
        if digest.hexdigest()!=entry['sha256'] or tmp.stat().st_size!=entry['bytes']:
            raise ValueError('Reconstructed asset identity: '+name)
        tmp.replace(dst)
if __name__=='__main__':restore();print('V2_LARGE_ASSETS_PASS')
