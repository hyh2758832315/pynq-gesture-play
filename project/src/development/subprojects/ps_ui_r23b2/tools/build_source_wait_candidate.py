"""Pair the source-wait hand and PS candidates without changing old deliveries.

Run: .venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/tools/build_source_wait_candidate.py
Outputs: build/ps-ui-r28-direct-fist-20261026-board-candidate-r17,
         build/r28-source-wait-build.json and paired hand source hashes.
Next: offline tests/check-only, then a separately coordinated operator run with
      no PC observer, image demand, extra MMIO/serial reads or CPU probes.
"""
import hashlib
import json
from pathlib import Path
import re
import sys

ROOT=Path(__file__).resolve().parents[3]
SOURCE=ROOT/'subprojects/ps_ui_r23b2'
HAND=ROOT/'build/hand-r28-source-wait-20261026-r04'
OUTPUT=ROOT/'build/ps-ui-r28-direct-fist-20261026-board-candidate-r17'
sys.path.insert(0,str(Path(__file__).resolve().parent))
from build_hand_approval_candidate import build as build_hand
from build_deployment_candidate import build


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    if OUTPUT.exists():
        raise FileExistsError('Preserve previous candidate output')
    if not HAND.exists():
        build_hand()
    changes={}
    for name in ('motion.py','controller.py','actuator_owner.py','gesture_consumer.py','game_bridge.py'):
        relative='src/pynq_usb_hand/'+name
        if sha(HAND/relative)!=sha(SOURCE/'hand_overrides'/name):
            raise ValueError('Hand candidate no longer matches reviewed override: '+name)
        changes[relative]=sha(HAND/relative)
    frozen=json.loads((HAND/'frozen_manifest.json').read_text(encoding='utf-8'))
    for name,expected in frozen['sha256'].items():
        if sha(HAND/name).lower()!=expected.lower():
            raise ValueError('Frozen hand asset mismatch: '+name)
    record=json.loads((HAND/'approval_candidate.json').read_text(encoding='utf-8'))
    record.update(changed_sha256=changes,source_recovery=True,
        source_off_grace_seconds=1.0,source_freshness_seconds=.5,
        state_writes='transition only; existing owner loop; no added thread or playback READ',
        hardware_tested=False,release_ready=False)
    (HAND/'approval_candidate.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
    pins=SOURCE/'hand_child/serial_sources.json'
    manifest=json.loads(pins.read_text(encoding='utf-8'))
    manifest['sha256']={name:sha(HAND/name) for name in manifest['sha256']}
    pins.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
    bridge=SOURCE/'python/pynq_multimodal_game/hand_shadow_bridge.py'
    text=bridge.read_text(encoding='utf-8')
    for relative in ('src/pynq_usb_hand/game_bridge.py','src/pynq_usb_hand/gesture_consumer.py'):
        text,count=re.subn(r'("'+re.escape(relative)+r'": ")[a-f0-9]+',
            lambda match:match[1]+sha(HAND/relative),text)
        if count!=1:raise ValueError('Expected one source pin: '+relative)
    for variable,path in (('SERIAL_CHILD_SHA256',SOURCE/'hand_child/serial_motion_receiver.py'),
                           ('SERIAL_MANIFEST_SHA256',pins)):
        text,count=re.subn(variable+r' = "[a-f0-9]+"',variable+' = "'+sha(path)+'"',text)
        if count!=1:raise ValueError('Expected one serial pin: '+variable)
    bridge.write_text(text,encoding='utf-8')
    result=build(OUTPUT)
    result.update(hand_root=str(HAND),hand_sources=changes,
                  board_tested=False,operator_tested=False)
    (ROOT/'build/r28-source-wait-build.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(result,indent=2))


if __name__=='__main__':
    main()
