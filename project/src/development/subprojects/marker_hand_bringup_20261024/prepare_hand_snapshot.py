"""Create an immutable source-only hand bridge candidate, no board access.
Run: .venv/Scripts/python.exe -I -B subprojects/marker_hand_bringup_20261024/prepare_hand_snapshot.py
Outputs: b06-hand-bridge-candidate.zip/json with full hashes, AST and PC evidence.
Next: restore to a new ARM directory and rerun tests after board recovery.
"""
import argparse
import ast
import hashlib
import json
import re
from pathlib import Path
import sys
import zipfile

REPO=Path(__file__).resolve().parents[2]
ROOT=REPO/'subprojects/pynq_usb_hand'
OUT=ROOT/'build/bridge-20261024'
sys.path.insert(0,str(ROOT/'src'))
from pynq_usb_hand.assets import verify_frozen

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--label',default='b06-hand-bridge-candidate')
    parser.add_argument('--regression',default='b01-regression')
    parser.add_argument('--prefix',default='source-bridge-r01')
    parser.add_argument('--extra-evidence',nargs='*',default=[])
    args=parser.parse_args()
    if any(not re.fullmatch(r'[a-zA-Z0-9_.-]+',name) for name in
           [args.label,args.regression,args.prefix,*args.extra_evidence]):raise ValueError('Simple artifact names required')
    verify_frozen(ROOT)
    regression=json.loads((OUT/(args.regression+'.json')).read_text())
    assert regression['tests_run']==168 and regression['failures']==0 and regression['errors']==0
    assert json.loads((OUT/'b02-frozen-game.json').read_text())['result']=='FROZEN_GAME_HAND_BRIDGE_PASS'
    assert json.loads((OUT/'b05-processes-host.json').read_text())['status']=='TWO_PROCESS_PASSIVE_BRIDGE_PASS'
    payload={}
    for directory in ('src','tests','tools','integration','assets','vendor'):
        for path in (ROOT/directory).rglob('*'):
            if not path.is_file() or '__pycache__' in path.parts or path.suffix=='.pyc':continue
            assert path.resolve().is_relative_to(ROOT.resolve())
            payload[path.relative_to(ROOT).as_posix()]=path.read_bytes()
    for name in ('README.md','HANDOFF.md','PLAYBACK_OFFLINE.md','BRIDGE_CANDIDATE.md','pyproject.toml','requirements-host.txt','run.py','frozen_manifest.json'):
        payload[name]=(ROOT/name).read_bytes()
    for name in (args.regression+'.json',args.regression+'.log','b02-frozen-game.json','b02-frozen-game.log','b05-processes-host.json',*args.extra_evidence):
        payload['evidence/'+name]=(OUT/name).read_bytes()
    for name,data in payload.items():
        if name.endswith('.py'):ast.parse(data.decode('utf-8-sig'),filename=name,feature_version=(3,10))
    hashes={name:hashlib.sha256(data).hexdigest() for name,data in sorted(payload.items())}
    manifest=dict(schema='hand-bridge-source-candidate-v1',release_ready=False,board_pending=True,
                  board_hook_installed=False,source_only=True,python310_ast=True,sha256=hashes)
    payload['source_manifest.json']=(json.dumps(manifest,indent=2)+'\n').encode()
    target=OUT/(args.label+'.zip')
    with zipfile.ZipFile(target,'x',compression=zipfile.ZIP_DEFLATED) as archive:
        for name,data in sorted(payload.items()):archive.writestr(args.prefix+'/'+name,data)
    with zipfile.ZipFile(target) as archive:
        assert archive.testzip() is None and len(archive.namelist())==len(payload)
        for name,digest in hashes.items():
            assert hashlib.sha256(archive.read(args.prefix+'/'+name)).hexdigest()==digest
    report=dict(status='HAND_BRIDGE_SOURCE_SNAPSHOT_PASS',zip_sha256=hashlib.sha256(target.read_bytes()).hexdigest(),
                entries=len(hashes),python310_ast=True,board_pending=True,release_ready=False,source_sha256=hashes)
    with target.with_suffix('.json').open('x') as out:json.dump(report,out,indent=2)
    print(report['status'],report['entries'],report['zip_sha256'])

if __name__=='__main__':main()
