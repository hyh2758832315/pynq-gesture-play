"""Extract the verified observation-only R08 archive into a new board path.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hand_r23b2_integration/board_stage_shadow_r08.py --output subprojects/hand_r23b2_integration/b72-r08-stage.json
Input: b71-hand-source-r08.zip previously copied to BOARD_ARCHIVE.
Output: new HAND directory and b72-r08-stage.json receipt.
Next: check-only preflight and idle gate before an Agent launch.
"""
import ast
import hashlib
import json
from pathlib import Path
from zipfile import ZipFile


BASE = Path('/home/xilinx/voice-view-game')
BOARD_ARCHIVE = BASE / 'hand-r23b2-r08-20261024.zip'
HAND = BASE / 'hand-shadow-r23b2-r08-20261024'
ARCHIVE_SHA = '821f1eef6253ae1aa1314cdaca3195bd1871bdd00110a6dc927a87f99ae2c6e7'
MANIFEST_SHA = 'c0cf78dc534b3968d942649464e43c3ae711e5ff8b54e26b39675d17579e6700'

if HAND.exists() or hashlib.sha256(BOARD_ARCHIVE.read_bytes()).hexdigest() != ARCHIVE_SHA:
    raise RuntimeError('Existing target or archive identity mismatch')
with ZipFile(BOARD_ARCHIVE) as archive:
    members = archive.namelist()
    if len(members) != len(set(members)) or any(
            Path(name).is_absolute() or '..' in Path(name).parts or '\\' in name
            for name in members):
        raise RuntimeError('Unsafe archive member')
    manifest_bytes = archive.read('source_manifest.json')
    if hashlib.sha256(manifest_bytes).hexdigest() != MANIFEST_SHA:
        raise RuntimeError('Manifest identity mismatch')
    entries = json.loads(manifest_bytes)['sha256']
    if set(members) != set(entries) | {'source_manifest.json'}:
        raise RuntimeError('Archive member set mismatch')
    for name, digest in entries.items():
        data = archive.read(name)
        if hashlib.sha256(data).hexdigest() != digest:
            raise RuntimeError('Source mismatch: ' + name)
        if name.endswith('.py'):
            ast.parse(data.decode('utf-8-sig'), filename=name, feature_version=(3, 10))
    HAND.mkdir(mode=0o755)
    archive.extractall(HAND)
print(json.dumps({'result': 'HAND_R08_BOARD_STAGE_PASS', 'hand_root': str(HAND),
                  'archive_sha256': ARCHIVE_SHA, 'manifest_sha256': MANIFEST_SHA,
                  'files': len(entries)}, ensure_ascii=False), flush=True)
