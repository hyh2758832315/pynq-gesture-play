"""Check every immutable v2 file and restore large assets without network.

Run: python -B verify_release.py
Output: V2_RELEASE_SHA_PASS and count. Next: start Studio or board entry.
"""
import hashlib
import json
import os
from pathlib import Path
from restore_assets import restore
ROOT=Path(__file__).resolve().parent
if os.name=='nt' and not str(ROOT).startswith('\\\\?\\'):ROOT=Path('\\\\?\\'+str(ROOT))
restore()
m=json.loads((ROOT/'SHA256SUMS.json').read_text(encoding='utf-8'))
for name,digest in m['files'].items():
    f=(ROOT/name).resolve()
    if not f.is_relative_to(ROOT) or hashlib.sha256(f.read_bytes()).hexdigest()!=digest:
        raise ValueError('Release SHA mismatch: '+name)
print('V2_RELEASE_SHA_PASS',len(m['files']))
