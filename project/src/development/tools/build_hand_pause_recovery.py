"""Freeze idempotent OFF handoff for the Studio deployment candidate.

Run: .venv/Scripts/python.exe -B tools/build_hand_pause_recovery.py
Outputs: build/hand-pause-recovery-r16 and its build receipt; updates source pins.
Next: build_deployment_candidate.py with --hand-candidate build/hand-pause-recovery-r16.
No board access; existing frozen candidates remain unchanged.
"""
import hashlib
import json
from pathlib import Path
import re
import shutil

ROOT=Path(__file__).resolve().parents[1]
source=ROOT/'subprojects/ps_ui_r23b2'
base=ROOT/'build/hand-boundary-r15b'
out=ROOT/'build/hand-pause-recovery-r16'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pins=source/'hand_child/serial_sources.json'
manifest=json.loads(pins.read_text(encoding='utf-8'))
before=json.loads((ROOT/'build/hand-boundary-r15b-build.json').read_text(encoding='utf-8'))['after']
for name,digest in before.items():
    if sha(base/name)!=digest:raise ValueError(name)
if out.exists():raise FileExistsError(out)
shutil.copytree(base,out,ignore=shutil.ignore_patterns('__pycache__','*.pyc','.pytest_cache'))
name='src/pynq_usb_hand/controller.py'
shutil.copy2(source/'hand_overrides/controller.py',out/name)
after={entry:sha(out/entry) for entry in before}
assert {entry for entry in before if before[entry]!=after[entry]}=={name}
manifest['sha256']=after
pins.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
bridge=source/'python/pynq_multimodal_game/hand_shadow_bridge.py'
contents,n=re.subn(r'SERIAL_MANIFEST_SHA256 = "[a-f0-9]+"',
    'SERIAL_MANIFEST_SHA256 = "'+sha(pins)+'"',bridge.read_text(encoding='utf-8'))
assert n==1
bridge.write_text(contents,encoding='utf-8')
record=dict(base=str(base),output=str(out),before=before,after=after,
            serial_manifest_sha256=sha(pins),physical_tested=False)
(ROOT/'build/hand-pause-recovery-r16-build.json').write_text(json.dumps(record,indent=2),encoding='utf-8')
print(json.dumps(dict(output=str(out),serial_manifest_sha256=sha(pins))))
