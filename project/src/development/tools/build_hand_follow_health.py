"""Freeze bounded source recovery and follow diagnostics, preserving R10.

Run: .venv/Scripts/python.exe -B tools/build_hand_follow_health.py
Outputs: build/hand-follow-health-r11, SHA pins and build receipt.
Next: offline owner/SDK tests, then paired Studio system candidate.
"""
import hashlib
import json
from pathlib import Path
import re
import shutil

ROOT=Path(__file__).resolve().parents[1]
base=ROOT/'build/hand-qualified-follow-r10'
out=ROOT/'build/hand-follow-health-r11'
source=ROOT/'subprojects/ps_ui_r23b2'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pins=source/'hand_child/serial_sources.json'
manifest=json.loads(pins.read_text(encoding='utf-8'))
before=dict(manifest['sha256'])
for name,digest in before.items(): assert sha(base/name)==digest,name
assert not out.exists()
shutil.copytree(base,out,ignore=shutil.ignore_patterns('__pycache__','*.pyc','.pytest_cache'))
changed=('game_bridge.py','page_playback.py','actuator_owner.py')
for name in changed: shutil.copy2(source/'hand_overrides'/name,out/'src/pynq_usb_hand'/name)
after={name:sha(out/name) for name in before}
assert {n for n in before if before[n]!=after[n]}=={'src/pynq_usb_hand/'+n for n in changed}
manifest['sha256']=after
pins.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
bridge=source/'python/pynq_multimodal_game/hand_shadow_bridge.py'
text=bridge.read_text(encoding='utf-8')
text,count=re.subn(r'SERIAL_MANIFEST_SHA256 = "[a-f0-9]+"',
    'SERIAL_MANIFEST_SHA256 = "'+sha(pins)+'"',text)
assert count==1
old,new=before['src/pynq_usb_hand/game_bridge.py'],after['src/pynq_usb_hand/game_bridge.py']
assert text.count(old)==1
bridge.write_text(text.replace(old,new),encoding='utf-8')
record=dict(base=str(base),output=str(out),before=before,after=after,
    serial_manifest_sha256=sha(pins),physical_tested=False)
(ROOT/'build/hand-follow-health-r11-build.json').write_text(json.dumps(record,indent=2),encoding='utf-8')
print(json.dumps(dict(output=str(out),serial_manifest_sha256=sha(pins))))
