"""Package only the hash-bound R07 source using POSIX zip paths.

Run: .venv/Scripts/python.exe -I -B subprojects/hand_r23b2_integration/package_hand_shadow_r07.py
Output: b58-hand-source-r07.zip and printed source/archive SHA-256 values.
Next: transfer to a new board path, verify hashes, and run --check-only.
"""
import hashlib
import json
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile


ROOT = Path(__file__).resolve().parent
SOURCE = ROOT / 'b55-hand-source-r07'
OUTPUT = ROOT / 'b58-hand-source-r07.zip'
MANIFEST = SOURCE / 'source_manifest.json'
EXPECTED_MANIFEST_SHA = '6d3ef38b116bbfd7ecc84387ad84284580ff392194e94fdddb97f899b8dc8c7a'

if hashlib.sha256(MANIFEST.read_bytes()).hexdigest() != EXPECTED_MANIFEST_SHA:
    raise RuntimeError('R07 source manifest changed')
entries = json.loads(MANIFEST.read_text(encoding='utf-8'))['sha256']
with ZipFile(OUTPUT, 'x', compression=ZIP_DEFLATED, compresslevel=6) as archive:
    archive.write(MANIFEST, 'source_manifest.json')
    for relative, expected in sorted(entries.items()):
        path = (SOURCE / relative).resolve(strict=True)
        if not path.is_relative_to(SOURCE.resolve()) or hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            raise RuntimeError('R07 source mismatch: ' + relative)
        archive.write(path, relative)
print(json.dumps({'result': 'HAND_R07_ARCHIVE_PASS', 'files': len(entries),
                  'manifest_sha256': EXPECTED_MANIFEST_SHA,
                  'archive_sha256': hashlib.sha256(OUTPUT.read_bytes()).hexdigest()}))
