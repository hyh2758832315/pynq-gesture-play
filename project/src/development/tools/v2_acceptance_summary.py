"""Gate the v2 release on original offline, Studio, GPU, serial and normal receipts.

Run: .venv/Scripts/python.exe -B tools/v2_acceptance_summary.py
Output: build/studio-v2/acceptance-summary.json. Next: refresh/seal/publish snapshot.
No network/hardware operation. Physical posture observation remains separate.
"""
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1];out=ROOT/'build/studio-v2'
IDENTITY='5f53d85d5bcdb8c871d387683cbf7b6b12c899b380b9370642c9bd2ff41e9d56'
def read(path):return json.loads(path.read_text(encoding='utf-8'))
ui=read(out/'ui-system.json');system=read(Path(ui['receipt']))
assert system['result']=='PASS' and system['manifest_sha256']==IDENTITY
games=read(out/'installed-game-checks.json')
assert games['result']=='PASS' and games['manifest_sha256']==IDENTITY
assert len(games['checks'])==16 and all(v['passed'] for v in games['checks'])
memory=read(out/'gpu/board-checks.json');physical=read(out/'physical/board-checks.json')
assert memory['result']=='PASS' and physical['result']=='AUTOMATED_PASS_OBSERVATION_PENDING'
assert memory['manifest_sha256']==physical['manifest_sha256']==IDENTITY
assert all(v['passed'] for v in memory['checks']+physical['checks'])
for folder in ('gpu','physical'):
    assert read(out/folder/'restart-evidence.json')['result']=='PASS'
    released=read(out/folder/'board-release.json')
    assert released['result']=='PASS' and released['owners']==[]
assert read(out/'gpu/memory-hand-release.json')['result']=='PASS'
assert read(out/'physical/physical-release.json')['result']=='PASS'
normal=read(out/'normal-ready.json');connect=read(out/'after-restart.json')
assert normal['result']=='READY' and normal['manifest_sha256']==IDENTITY
assert connect['result']=='PASS'
h=normal['snapshot']['vision']['hand_session']
assert h['max_seconds'] is None and not h['preview_allowed'] and not h['video_paused'] and not h['error']
assert read(out/'snapshot-launcher.json')['result']=='PASS'
assert read(out/'release-credential-scan.json')['result']=='PASS'
report=dict(result='PASS',version='2.0',manifest_sha256=IDENTITY,
    system_receipt=ui['receipt'],games_pc_pynq_cases=len(games['checks']),
    gpu_creative_checks=len(memory['checks']),physical_protocol_checks=len(physical['checks']),
    restart_and_17_off_confirmed=True,studio_reconnect=True,normal_service=True,
    validation_input_removed=True,preview=False,mechanical_verified=False,
    limits=['This revision has protocol/SDK serial evidence; no new human posture observation.',
            'No fresh SD-image installation or unbounded-duration reliability claim.'])
(out/'acceptance-summary.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
print(json.dumps(report))
