"""Package only the hash-bound R05 hand source with POSIX zip paths.

Run: .venv/Scripts/python.exe -I -B subprojects/hand_r23b2_integration/package_hand_shadow_r05.py
Output: b30-hand-source-r05.zip and printed archive/source SHA-256 values.
Next: transfer to a new board path, verify hashes, run --check-only before launch.
"""

import hashlib
import json
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile


ROOT = Path(__file__).resolve().parent
SOURCE = ROOT / 'b24-hand-source-r05'
OUTPUT = ROOT / 'b30-hand-source-r05.zip'
MANIFEST = SOURCE / 'source_manifest.json'
EXPECTED_MANIFEST_SHA = '9587f461484f36530e07c969b75ac196a6dc0f68f5d43ff7acbd2fc2101acf89'

if hashlib.sha256(MANIFEST.read_bytes()).hexdigest() != EXPECTED_MANIFEST_SHA:
    raise RuntimeError('R05 source manifest changed')
entries = json.loads(MANIFEST.read_text(encoding='utf-8'))['sha256']
with ZipFile(OUTPUT, 'x', compression=ZIP_DEFLATED, compresslevel=6) as archive:
    archive.write(MANIFEST, 'source_manifest.json')
    for relative, expected in sorted(entries.items()):
        path = (SOURCE / relative).resolve(strict=True)
        if not path.is_relative_to(SOURCE.resolve()) or hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            raise RuntimeError('R05 source mismatch: ' + relative)
        archive.write(path, relative)
print(json.dumps({'result': 'HAND_R05_ARCHIVE_PASS', 'files': len(entries),
                  'manifest_sha256': EXPECTED_MANIFEST_SHA,
                  'archive_sha256': hashlib.sha256(OUTPUT.read_bytes()).hexdigest()}))
