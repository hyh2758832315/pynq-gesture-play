"""Stage the isolated approval-timed hand variant, preserving the base tree.
Run: .venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/tools/build_hand_approval_candidate.py
Outputs: build/hand-r28-source-wait-20261026-r04 plus approval_candidate.json.
Next: run its offline verifier, pair its five source hashes with PS, deploy.
"""
import hashlib,json,shutil
from pathlib import Path
ROOT=Path(__file__).resolve().parents[3]
OUTPUT=ROOT/'build/hand-r28-source-wait-20261026-r04'
def build():
    if OUTPUT.exists():raise FileExistsError('preserve previous hand candidate')
    shutil.copytree(ROOT/'build/hand-r27-preview-pause-20261025-r03',OUTPUT,
        ignore=shutil.ignore_patterns('.venv','build','.git','__pycache__','*.pyc'))
    changed={}
    for name in ('motion.py','controller.py','actuator_owner.py','gesture_consumer.py','game_bridge.py'):
        destination=OUTPUT/'src/pynq_usb_hand'/name
        shutil.copy2(ROOT/'subprojects/ps_ui_r23b2/hand_overrides'/name,destination)
        changed['src/pynq_usb_hand/'+name]=hashlib.sha256(destination.read_bytes()).hexdigest()
    frozen=json.loads((OUTPUT/'frozen_manifest.json').read_text())
    for name,digest in frozen['sha256'].items():
        assert hashlib.sha256((OUTPUT/name).read_bytes()).hexdigest()==digest
    record=dict(schema='hand-approval-candidate-v1',changed_sha256=changed,
        timing='single window starts when Controller.submit accepts; no following cooldown',
        frozen_files=len(frozen['sha256']),hardware_tested=False,release_ready=False)
    (OUTPUT/'approval_candidate.json').write_text(json.dumps(record,indent=2))
    print(json.dumps(record,indent=2))
if __name__=='__main__':build()
