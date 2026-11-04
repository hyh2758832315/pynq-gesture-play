"""Freeze latest-pose hand semantics from the verified R12 candidate.

Run: .venv/Scripts/python.exe -B tools/build_hand_latest_pose.py
Output: build/hand-follow-latest-r13 and build/hand-follow-latest-r13-build.json.
Next: run focused offline tests, then build a paired Studio deployment candidate.
"""
import hashlib
import json
from pathlib import Path
import re
import shutil
import sys

ROOT=Path(__file__).resolve().parents[1]
source=ROOT/'subprojects/ps_ui_r23b2'
base=ROOT/'build/hand-follow-history-r12'
out=ROOT/'build/hand-follow-latest-r13'
sha=lambda path:hashlib.sha256(path.read_bytes()).hexdigest()
pins=source/'hand_child/serial_sources.json'
manifest=json.loads(pins.read_text(encoding='utf-8'))
before=dict(manifest['sha256'])
for name,digest in before.items():
    assert sha(base/name)==digest,name
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
contents,shadow_count=re.subn(r'("src/pynq_usb_hand/gesture_consumer.py": ")[a-f0-9]+(")',
    lambda match: match.group(1)+after[name]+match.group(2),contents)
assert shadow_count==1
contents,count=re.subn(r'SERIAL_MANIFEST_SHA256 = "[a-f0-9]+"',
    'SERIAL_MANIFEST_SHA256 = "'+sha(pins)+'"',contents)
assert count==1
bridge.write_text(contents,encoding='utf-8')
sys.path.insert(0,str(source/'python'))
from pynq_multimodal_game.hand_shadow_bridge import verify_shadow_sources
verify_shadow_sources(out)
(ROOT/'build/hand-follow-latest-r13-build.json').write_text(json.dumps(dict(
    base=str(base),output=str(out),before=before,after=after,
    serial_manifest_sha256=sha(pins),physical_tested=False),indent=2),encoding='utf-8')
print(json.dumps(dict(output=str(out),serial_manifest_sha256=sha(pins))))
