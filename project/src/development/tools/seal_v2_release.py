"""Seal the completed snapshot, split oversized Git blobs and verify ZIP bytes.

Run: .venv/Scripts/python.exe -B tools/seal_v2_release.py --repo build/v2-release-repo
Output: build/voice-view-full-v2.0.zip/.sha256 and release receipt/Git path list.
Next: verify restored snapshot, review only the listed diff, then push/tag/Release.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import zipfile

p=argparse.ArgumentParser(description=__doc__);p.add_argument('--repo',type=Path,required=True)
a=p.parse_args();repo=a.repo.resolve();root=repo/'releases/v2.0'
if os.name=='nt':root=Path('\\\\?\\'+str(root))
def sha(data):return hashlib.sha256(data).hexdigest()
def files():return sorted(f for f in root.rglob('*') if f.is_file() and '__pycache__' not in f.parts and f.suffix not in ('.pyc','.pyo'))
assert not (root/'SHA256SUMS.json').exists(),'Seal exactly once'
large={};originals={}
for f in files():
    if f.stat().st_size<=48*1024*1024:continue
    name=f.relative_to(root).as_posix();data=f.read_bytes();digest=sha(data)
    entry=dict(bytes=len(data),sha256=digest,chunks=[])
    for i,offset in enumerate(range(0,len(data),48*1024*1024)):
        piece=data[offset:offset+48*1024*1024];part=f'assets/chunks/{digest}.{i:03}.bin'
        target=root/part;target.parent.mkdir(parents=True,exist_ok=True)
        if target.exists():assert sha(target.read_bytes())==sha(piece)
        else:target.write_bytes(piece)
        entry['chunks'].append(dict(path=part,sha256=sha(piece)))
    large[name]=entry;originals[name]=digest
    # Only remove our just-copied oversized release file after checked chunks exist.
    assert f.resolve().is_relative_to(root.resolve()) and b''.join((root/c['path']).read_bytes() for c in entry['chunks'])==data
    f.unlink()
(root/'LARGE_ASSETS.json').write_text(json.dumps(large,indent=2)+'\n',encoding='utf-8')
hashes={f.relative_to(root).as_posix():sha(f.read_bytes()) for f in files()}
hashes.update(originals)
(root/'SHA256SUMS.json').write_text(json.dumps(dict(schema='voice-view-release-sha256-v1',version='2.0',files=hashes),indent=2)+'\n',encoding='utf-8')
paths=files();archive=repo.parent/'voice-view-full-v2.0.zip'
with zipfile.ZipFile(archive,'x',compression=zipfile.ZIP_DEFLATED,compresslevel=9) as z:
    for f in paths:
        info=zipfile.ZipInfo('voice-view-v2.0/'+f.relative_to(root).as_posix(),(2026,10,28,0,0,0))
        info.external_attr=0o100644<<16
        z.writestr(info,f.read_bytes(),compress_type=zipfile.ZIP_DEFLATED,compresslevel=9)
with zipfile.ZipFile(archive) as z:
    assert z.testzip() is None
    for name,digest in hashes.items():
        if name in large:
            rebuilt=hashlib.sha256()
            for part in large[name]['chunks']:rebuilt.update(z.read('voice-view-v2.0/'+part['path']))
            assert rebuilt.hexdigest()==digest
        else:assert sha(z.read('voice-view-v2.0/'+name))==digest
digest=sha(archive.read_bytes())
(repo.parent/'voice-view-full-v2.0.sha256').write_text(digest+'  '+archive.name+'\n',encoding='ascii')
gitpaths=['README.md']+['releases/v2.0/'+f.relative_to(root).as_posix() for f in paths]
(repo.parent/'voice-view-v2-git-paths.nul').write_bytes(b'\0'.join(p.encode('utf-8') for p in gitpaths)+b'\0')
result=dict(version='2.0',files=len(paths),restored_files=len(large),bytes=archive.stat().st_size,
            sha256=digest,archive=str(archive),zip_crc_and_sha_verified=True)
(repo.parent/'voice-view-v2-release-receipt.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps(result))
