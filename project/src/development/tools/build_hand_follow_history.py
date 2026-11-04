"""Freeze bounded follow decisions on the existing R11 page status channel.

Run: .venv/Scripts/python.exe -B tools/build_hand_follow_history.py
Outputs: build/hand-follow-history-r12, SHA pins and build receipt.
Next: offline receiver/SDK tests, paired Studio package, observed board test.
"""
import hashlib
import json
from pathlib import Path
import re
import shutil

ROOT=Path(__file__).resolve().parents[1]
source=ROOT/'subprojects/ps_ui_r23b2'
base=ROOT/'build/hand-follow-health-r11'
out=ROOT/'build/hand-follow-history-r12'
sha=lambda path:hashlib.sha256(path.read_bytes()).hexdigest()
pins=source/'hand_child/serial_sources.json'
manifest=json.loads(pins.read_text(encoding='utf-8'))
before=dict(manifest['sha256'])
for name,digest in before.items(): assert sha(base/name)==digest,name
assert not out.exists()
shutil.copytree(base,out,ignore=shutil.ignore_patterns('__pycache__','*.pyc','.pytest_cache'))
name='src/pynq_usb_hand/page_playback.py'
shutil.copy2(source/'hand_overrides/page_playback.py',out/name)
after={name:sha(out/name) for name in before}
assert {n for n in before if before[n]!=after[n]}=={name}
manifest['sha256']=after
pins.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
bridge=source/'python/pynq_multimodal_game/hand_shadow_bridge.py'
contents=bridge.read_text(encoding='utf-8')
contents,count=re.subn(r'SERIAL_MANIFEST_SHA256 = "[a-f0-9]+"',
    'SERIAL_MANIFEST_SHA256 = "'+sha(pins)+'"',contents)
assert count==1
bridge.write_text(contents,encoding='utf-8')
(ROOT/'build/hand-follow-history-r12-build.json').write_text(json.dumps(dict(
    base=str(base),output=str(out),before=before,after=after,
    serial_manifest_sha256=sha(pins),physical_tested=False),indent=2),encoding='utf-8')
print(json.dumps(dict(output=str(out),serial_manifest_sha256=sha(pins))))
