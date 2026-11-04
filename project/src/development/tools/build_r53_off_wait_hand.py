"""Freeze the tested OFF-wait owner without changing the installed R06 tree.
Run: .venv/Scripts/python.exe -B tools/build_r53_off_wait_hand.py
Output: build/hand-r53-video-off-wait-r07 and updated PS source identity pins.
Next: offline tests with HAND_CANDIDATE_ROOT, then the Studio full package.
"""
from pathlib import Path
import hashlib
import json
import re
import shutil

root=Path(__file__).resolve().parents[1]
source=root/'subprojects/ps_ui_r23b2'
base=root/'build/hand-r43-creative-r06'
output=root/'build/hand-r53-video-off-wait-r07'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pins=source/'hand_child/serial_sources.json'
manifest=json.loads(pins.read_text(encoding='utf-8'))
for name,expected in manifest['sha256'].items():
    assert sha(base/name)==expected,name
assert not output.exists()
shutil.copytree(base,output,ignore=shutil.ignore_patterns('__pycache__','*.pyc','.pytest_cache'))
shutil.copy2(source/'hand_overrides/actuator_owner.py',output/'src/pynq_usb_hand/actuator_owner.py')
manifest['sha256']={name:sha(output/name) for name in manifest['sha256']}
pins.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
bridge=source/'python/pynq_multimodal_game/hand_shadow_bridge.py'
text,count=re.subn(r'SERIAL_MANIFEST_SHA256 = "[a-f0-9]+"',
                   'SERIAL_MANIFEST_SHA256 = "'+sha(pins)+'"',bridge.read_text(encoding='utf-8'))
assert count==1
bridge.write_text(text,encoding='utf-8')
print(json.dumps(dict(output=str(output),serial_manifest_sha256=sha(pins))))
