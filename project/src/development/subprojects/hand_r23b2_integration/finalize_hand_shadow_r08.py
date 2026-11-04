"""Bind the R08 post-receive monotonic-clock fix to the immutable R07 source.

Run: .venv/Scripts/python.exe -I -B subprojects/hand_r23b2_integration/finalize_hand_shadow_r08.py
Output: b68-hand-source-r08/source_manifest.json and its SHA-256.
Next: run offline tests, package R08, and verify the board before loading.
"""
import ast
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OLD = ROOT / 'b55-hand-source-r07'
NEW = ROOT / 'b68-hand-source-r08'
CHANGED = {
    'src/pynq_usb_hand/game_bridge.py',
    'tests/test_game_bridge.py',
    'tools/shadow_receiver.py',
}

old_manifest = json.loads((OLD / 'source_manifest.json').read_text(encoding='utf-8'))
new_manifest = json.loads((NEW / 'source_manifest.json').read_text(encoding='utf-8'))
if old_manifest != new_manifest:
    raise RuntimeError('Initial copied manifest differs from frozen R07 source')
for relative, expected in old_manifest['sha256'].items():
    old_file = OLD / relative
    new_file = NEW / relative
    if hashlib.sha256(old_file.read_bytes()).hexdigest() != expected:
        raise RuntimeError('Old frozen source mismatch: ' + relative)
    actual = hashlib.sha256(new_file.read_bytes()).hexdigest()
    if relative not in CHANGED and actual != expected:
        raise RuntimeError('Unexpected change: ' + relative)
    if relative.endswith('.py'):
        ast.parse(new_file.read_text(encoding='utf-8-sig'), filename=relative,
                  feature_version=(3, 10))
    new_manifest['sha256'][relative] = actual
if not all(new_manifest['sha256'][relative] != old_manifest['sha256'][relative]
           for relative in CHANGED):
    raise RuntimeError('Expected only targeted clock source, test and caller to change')
manifest = NEW / 'source_manifest.json'
manifest.write_text(json.dumps(new_manifest, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'result': 'HAND_R08_POST_RECEIVE_CLOCK_SOURCE_PASS',
                  'changed': sorted(CHANGED),
                  'manifest_sha256': hashlib.sha256(manifest.read_bytes()).hexdigest(),
                  'files': len(new_manifest['sha256'])}, indent=2))
