"""Extract the verified observation-only R07 archive into a new board path.

Run: .venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/remote_r22.py subprojects/hand_r23b2_integration/board_stage_shadow_r07.py --output subprojects/hand_r23b2_integration/b60-r07-stage.json
Input: b58-hand-source-r07.zip previously copied to BOARD_ARCHIVE.
Output: new HAND directory and b60-r07-stage.json receipt.
Next: check-only preflight and idle gate before an Agent launch.
"""
import ast
import hashlib
import json
from pathlib import Path
from zipfile import ZipFile


BASE = Path('/home/xilinx/voice-view-game')
BOARD_ARCHIVE = BASE / 'hand-r23b2-r07-20261024.zip'
HAND = BASE / 'hand-shadow-r23b2-r07-20261024'
ARCHIVE_SHA = '2cb28e10ca5c46d1340d4eb339f8afc8ccb0fc15490ba7a134c4353b9755c38f'
MANIFEST_SHA = '6d3ef38b116bbfd7ecc84387ad84284580ff392194e94fdddb97f899b8dc8c7a'

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
print(json.dumps({'result': 'HAND_R07_BOARD_STAGE_PASS', 'hand_root': str(HAND),
                  'archive_sha256': ARCHIVE_SHA, 'manifest_sha256': MANIFEST_SHA,
                  'files': len(entries)}, ensure_ascii=False), flush=True)
