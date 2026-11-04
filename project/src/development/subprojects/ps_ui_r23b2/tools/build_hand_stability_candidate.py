"""Build the isolated R35 hand candidate and pair PS SHA pins.
Run: .venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/tools/build_hand_stability_candidate.py
Outputs: build/hand-r35-default-stability-20261026-r05 and build/r35-hand-build.json.
Next: offline candidate tests, then build_deployment_candidate.py with a NEW output.
Board: PYNQ-Z2 xc7z020clg400-1; existing Vivado2026.1 R23b2 unchanged.
"""
import hashlib
import json
from pathlib import Path
import re
import shutil
ROOT = Path(__file__).resolve().parents[3]
SOURCE = ROOT / 'subprojects/ps_ui_r23b2'
BASE = ROOT / 'build/hand-r28-source-wait-20261026-r04'
OUTPUT = ROOT / 'build/hand-r35-default-stability-20261026-r05'
def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()
def build():
    if OUTPUT.exists(): raise FileExistsError('Preserve previous candidate')
    pins = SOURCE / 'hand_child/serial_sources.json'
    manifest = json.loads(pins.read_text(encoding='utf-8'))
    for name, expected in manifest['sha256'].items():
        if sha(BASE / name) != expected: raise ValueError('Baseline changed: ' + name)
    shutil.copytree(BASE, OUTPUT, ignore=shutil.ignore_patterns('__pycache__','*.pyc','.pytest_cache'))
    relative = 'src/pynq_usb_hand/gesture_consumer.py'
    shutil.copy2(SOURCE / 'hand_overrides/gesture_consumer.py', OUTPUT / relative)
    for test in (SOURCE / 'hand_test_overrides').glob('test_*.py'):
        shutil.copy2(test, OUTPUT / 'tests' / test.name)
    frozen = json.loads((OUTPUT / 'frozen_manifest.json').read_text(encoding='utf-8'))
    for name, expected in frozen['sha256'].items():
        if sha(OUTPUT / name) != expected: raise ValueError('Frozen asset changed: ' + name)
    for name in manifest['sha256']:
        if name != relative and sha(BASE / name) != sha(OUTPUT / name):
            raise ValueError('Unexpected runtime change: ' + name)
    record = json.loads((OUTPUT / 'approval_candidate.json').read_text(encoding='utf-8'))
    record['changed_sha256'][relative] = sha(OUTPUT / relative)
    record.update(baseline=str(BASE), default_stability_seconds=.1,
                  hardware_tested=False, release_ready=False)
    (OUTPUT / 'approval_candidate.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
    manifest['sha256'][relative] = sha(OUTPUT / relative)
    pins.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
    bridge = SOURCE / 'python/pynq_multimodal_game/hand_shadow_bridge.py'
    text = bridge.read_text(encoding='utf-8')
    text, count = re.subn(r'("'+re.escape(relative)+r'": ")[a-f0-9]+',
                         lambda m:m[1]+sha(OUTPUT / relative), text)
    if count != 1: raise ValueError('Missing hand source pin')
    text, count = re.subn(r'SERIAL_MANIFEST_SHA256 = "[a-f0-9]+"',
                         'SERIAL_MANIFEST_SHA256 = "'+sha(pins)+'"', text)
    if count != 1: raise ValueError('Missing serial manifest pin')
    bridge.write_text(text,encoding='utf-8')
    result = dict(hand_root=str(OUTPUT), baseline=str(BASE), changed_runtime=[relative],
                  changed_sha256=sha(OUTPUT / relative), frozen_files=len(frozen['sha256']),
                  hardware_tested=False, release_ready=False)
    (ROOT / 'build/r35-hand-build.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(result,indent=2))
if __name__ == '__main__': build()
