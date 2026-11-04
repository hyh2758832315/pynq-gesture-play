"""Freeze R14 hand page resume and immediate default playback.

Run: .venv/Scripts/python.exe -B tools/build_hand_page_resume.py
Output: build/hand-page-resume-r14 and SHA receipt.
Next: run offline tests, build a paired Studio package, then field verify.
"""
import hashlib
import json
from pathlib import Path
import re
import shutil
import sys

ROOT=Path(__file__).resolve().parents[1]
source=ROOT/'subprojects/ps_ui_r23b2'
base=ROOT/'build/hand-follow-latest-r13'
out=ROOT/'build/hand-page-resume-r14b'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pins=source/'hand_child/serial_sources.json'
manifest=json.loads(pins.read_text(encoding='utf-8'))
before=dict(json.loads((ROOT/'build/hand-follow-latest-r13-build.json').read_text(encoding='utf-8'))['after'])
for name,digest in before.items():
    assert sha(base/name)==digest,name
assert not out.exists()
shutil.copytree(base,out,ignore=shutil.ignore_patterns('__pycache__','*.pyc','.pytest_cache'))
changed=('src/pynq_usb_hand/motion.py','src/pynq_usb_hand/controller.py',
         'src/pynq_usb_hand/actuator_owner.py')
for name in changed:
    shutil.copy2(source/'hand_overrides'/Path(name).name,out/name)
after={name:sha(out/name) for name in before}
assert {name for name in before if before[name]!=after[name]}==set(changed)
manifest['sha256']=after
pins.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
bridge=source/'python/pynq_multimodal_game/hand_shadow_bridge.py'
contents=bridge.read_text(encoding='utf-8')
contents,count=re.subn(r'SERIAL_MANIFEST_SHA256 = "[a-f0-9]+"',
    'SERIAL_MANIFEST_SHA256 = "'+sha(pins)+'"',contents)
assert count==1
bridge.write_text(contents,encoding='utf-8')
sys.path.insert(0,str(source/'python'))
from pynq_multimodal_game.hand_shadow_bridge import verify_shadow_sources
verify_shadow_sources(out)
(ROOT/'build/hand-page-resume-r14b-build.json').write_text(json.dumps(dict(
    base=str(base),output=str(out),changed=list(changed),before=before,after=after,
    serial_manifest_sha256=sha(pins),physical_tested=False),indent=2),encoding='utf-8')
print(json.dumps(dict(output=str(out),serial_manifest_sha256=sha(pins))))
