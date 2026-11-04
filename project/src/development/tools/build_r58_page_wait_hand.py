"""Freeze the page OFF-wait correction without replacing a previous candidate.

Run: python -B tools/build_r58_page_wait_hand.py
Output: build/hand-r58-page-off-wait-r08, source SHA pins and build record.
Next: offline hand tests with this candidate, then a complete Studio package.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil

root=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--base',type=Path,default=root/'build/hand-r53-video-off-wait-r07')
p.add_argument('--output',type=Path,default=root/'build/hand-r58-page-off-wait-r08')
a=p.parse_args();source=root/'subprojects/ps_ui_r23b2'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pins=source/'hand_child/serial_sources.json';manifest=json.loads(pins.read_text(encoding='utf-8'))
for name,expected in manifest['sha256'].items():
    assert sha(a.base/name)==expected,name
assert not a.output.exists()
shutil.copytree(a.base,a.output,ignore=shutil.ignore_patterns('__pycache__','*.pyc','.pytest_cache'))
shutil.copy2(source/'hand_overrides/page_playback.py',a.output/'src/pynq_usb_hand/page_playback.py')
before=manifest['sha256'];after={name:sha(a.output/name) for name in before}
assert [name for name in before if before[name]!=after[name]]==['src/pynq_usb_hand/page_playback.py']
manifest['sha256']=after;pins.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
bridge=source/'python/pynq_multimodal_game/hand_shadow_bridge.py'
text,count=re.subn(r'SERIAL_MANIFEST_SHA256 = "[a-f0-9]+"',
    'SERIAL_MANIFEST_SHA256 = "'+sha(pins)+'"',bridge.read_text(encoding='utf-8'))
assert count==1;bridge.write_text(text,encoding='utf-8')
record=dict(base=str(a.base),output=str(a.output),before=before,after=after,
    serial_manifest_sha256=sha(pins),physical_tested=False)
(a.output.parent/(a.output.name+'-build.json')).write_text(json.dumps(record,indent=2),encoding='utf-8')
print(json.dumps(dict(output=str(a.output),serial_manifest_sha256=sha(pins))))
