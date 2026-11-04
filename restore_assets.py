"""Run: python -B restore_assets.py. Output: exact large video assets, no network.
Next: python -B project/tools/verify_package.py.
"""
import hashlib
import json
from pathlib import Path
import sys

ROOT=Path(__file__).resolve().parent
if sys.platform=='win32' and not str(ROOT).startswith('\\\\?\\'):
    ROOT=Path('\\\\?\\'+str(ROOT))

def checked_path(name):
    result=(ROOT/name).resolve()
    if not result.is_relative_to(ROOT): raise ValueError('Path escapes repository')
    return result

def digest_file(path):
    with path.open('rb') as stream: return hashlib.file_digest(stream,'sha256').hexdigest()

def main():
    manifest=json.loads((ROOT/'large_assets.json').read_text('utf-8'))
    for name,entry in manifest.items():
        target=checked_path(name)
        if target.exists():
            if target.stat().st_size!=entry['bytes'] or digest_file(target)!=entry['sha256']:
                raise ValueError('Existing asset differs: '+name)
            continue
        target.parent.mkdir(parents=True,exist_ok=True)
        temporary=target.with_name(target.name+'.restore-tmp')
        digest=hashlib.sha256()
        with temporary.open('xb') as output:
            for chunk in entry['chunks']:
                raw=checked_path(chunk['path']).read_bytes()
                if hashlib.sha256(raw).hexdigest()!=chunk['sha256']:
                    raise ValueError('Chunk differs: '+chunk['path'])
                digest.update(raw);output.write(raw)
        if temporary.stat().st_size!=entry['bytes'] or digest.hexdigest()!=entry['sha256']:
            raise ValueError('Restored asset differs: '+name)
        temporary.replace(target)
    print(json.dumps({'result':'PASS','restored_assets':len(manifest)}))

if __name__=='__main__': main()
