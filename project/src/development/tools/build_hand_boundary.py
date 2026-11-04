"""Freeze the offline-verified latest-frame handoff correction.

Run: .venv/Scripts/python.exe -B tools/build_hand_boundary.py
Outputs: build/hand-boundary-r15b and SHA receipt; no board access.
Next: run the deterministic boundary/owner tests and paired Studio build.
"""
import hashlib
import json
from pathlib import Path
import re
import shutil

ROOT=Path(__file__).resolve().parents[1]
source=ROOT/'subprojects/ps_ui_r23b2'
base=ROOT/'build/hand-page-resume-r14b'
out=ROOT/'build/hand-boundary-r15b'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pins=source/'hand_child/serial_sources.json'
manifest=json.loads(pins.read_text(encoding='utf-8'))
before=dict(json.loads((ROOT/'build/hand-page-resume-r14b-build.json').read_text(encoding='utf-8'))['after'])
for name,digest in before.items(): assert sha(base/name)==digest,name
assert not out.exists()
shutil.copytree(base,out,ignore=shutil.ignore_patterns('__pycache__','*.pyc','.pytest_cache'))
name='src/pynq_usb_hand/gesture_consumer.py'
shutil.copy2(source/'hand_overrides/gesture_consumer.py',out/name)
after={entry:sha(out/entry) for entry in before}
assert {entry for entry in before if before[entry]!=after[entry]}=={name}
manifest['sha256']=after
pins.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
bridge=source/'python/pynq_multimodal_game/hand_shadow_bridge.py'
contents=bridge.read_text(encoding='utf-8')
contents,n=re.subn(r'("src/pynq_usb_hand/gesture_consumer.py": ")[a-f0-9]+(")',
    lambda m:m.group(1)+after[name]+m.group(2),contents)
assert n==1
contents,n=re.subn(r'SERIAL_MANIFEST_SHA256 = "[a-f0-9]+"',
    'SERIAL_MANIFEST_SHA256 = "'+sha(pins)+'"',contents)
assert n==1
bridge.write_text(contents,encoding='utf-8')
(ROOT/'build/hand-boundary-r15b-build.json').write_text(json.dumps(dict(
    base=str(base),output=str(out),before=before,after=after,
    serial_manifest_sha256=sha(pins),physical_tested=False),indent=2),encoding='utf-8')
print(json.dumps(dict(output=str(out),serial_manifest_sha256=sha(pins))))
