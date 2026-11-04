"""Package only the hash-bound R06 source using POSIX zip paths.

Run: .venv/Scripts/python.exe -I -B subprojects/hand_r23b2_integration/package_hand_shadow_r06.py
Output: b39-hand-source-r06.zip and printed source/archive SHA-256 values.
Next: transfer to a new board path, verify hashes, and run --check-only.
"""
import hashlib
import json
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile


ROOT = Path(__file__).resolve().parent
SOURCE = ROOT / 'b37-hand-source-r06'
OUTPUT = ROOT / 'b39-hand-source-r06.zip'
MANIFEST = SOURCE / 'source_manifest.json'
EXPECTED_MANIFEST_SHA = '4928de30b53217d2a1e750665dfb6eaf88a4d6845e1f48796c5f5ed705a07938'

if hashlib.sha256(MANIFEST.read_bytes()).hexdigest() != EXPECTED_MANIFEST_SHA:
    raise RuntimeError('R06 source manifest changed')
entries = json.loads(MANIFEST.read_text(encoding='utf-8'))['sha256']
with ZipFile(OUTPUT, 'x', compression=ZIP_DEFLATED, compresslevel=6) as archive:
    archive.write(MANIFEST, 'source_manifest.json')
    for relative, expected in sorted(entries.items()):
        path = (SOURCE / relative).resolve(strict=True)
        if not path.is_relative_to(SOURCE.resolve()) or hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            raise RuntimeError('R06 source mismatch: ' + relative)
        archive.write(path, relative)
print(json.dumps({'result': 'HAND_R06_ARCHIVE_PASS', 'files': len(entries),
                  'manifest_sha256': EXPECTED_MANIFEST_SHA,
                  'archive_sha256': hashlib.sha256(OUTPUT.read_bytes()).hexdigest()}))
