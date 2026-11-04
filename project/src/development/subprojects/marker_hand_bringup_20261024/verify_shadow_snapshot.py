"""Restore the immutable shadow candidate and verify its actual entry points.
Run: hand-python -I -B subprojects/marker_hand_bringup_20261024/verify_shadow_snapshot.py
Outputs: b12-restore-check.json, b12-restored, b12-actual-shadow.json/log directory.
Next: same package ARM tests after board recovery; no board or robot I/O here.
"""
import argparse
import hashlib
import json
import re
from pathlib import Path
import subprocess
import sys
import zipfile

REPO=Path(__file__).resolve().parents[2]
OUT=REPO/'subprojects/pynq_usb_hand/build/bridge-20261024'
CANDIDATE=REPO/'deliveries/c6i-pl-vision-volume-osd-r21-marker-r02-20261023'


def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--label',default='b12')
    parser.add_argument('--snapshot',default='b11-shadow-candidate')
    parser.add_argument('--prefix',default='source-bridge-r02')
    args=parser.parse_args()
    if any(not re.fullmatch(r'[a-zA-Z0-9_.-]+',x) for x in (args.label,args.snapshot,args.prefix)):
        raise ValueError('Simple artifact names required')
    archive=OUT/(args.snapshot+'.zip')
    expected=json.loads(archive.with_suffix('.json').read_text())['zip_sha256']
    assert sha(archive)==expected
    stage=OUT/(args.label+'-restored')
    record=dict(status='RUNNING',archive_sha256=expected,steps=[],hardware_access=False)
    with (OUT/(args.label+'-restore-check.json')).open('x') as receipt:
        try:
            stage.mkdir()
            with zipfile.ZipFile(archive) as source:
                assert source.testzip() is None
                for info in source.infolist():
                    assert not info.is_dir() and info.filename.startswith(args.prefix+'/')
                    target=(stage/info.filename).resolve()
                    assert target.is_relative_to(stage.resolve())
                    target.parent.mkdir(parents=True,exist_ok=True)
                    with target.open('xb') as out:out.write(source.read(info))
            hand=stage/args.prefix
            manifest=json.loads((hand/'source_manifest.json').read_text())
            for name,digest in manifest['sha256'].items():assert sha(hand/name)==digest,name
            common=[sys.executable,'-I','-B',str(hand/'tools/run_agent_shadow.py'),
                    '--candidate',str(CANDIDATE),'--candidate-manifest-sha',sha(CANDIDATE/'deployment_manifest.json'),
                    '--hand-root',str(hand),'--hand-manifest-sha',sha(hand/'source_manifest.json'),
                    '--hand-python',sys.executable,'--shadow-directory',str(hand/'must-not-exist-shadow')]
            def run(command,label,expected_code):
                response=subprocess.run(command,capture_output=True,text=True,timeout=30,cwd=REPO)
                record['steps'].append(dict(label=label,command=command,returncode=response.returncode,stdout=response.stdout,stderr=response.stderr))
                assert response.returncode==expected_code,(label,response.stderr)
                assert not (hand/'must-not-exist-shadow').exists()
                return response
            response=run([*common,'--check-only'],'staged_entry_preflight',0)
            assert 'HAND_AGENT_SHADOW_PREFLIGHT_PASS' in response.stdout
            bad=list(common);bad[bad.index('--candidate-manifest-sha')+1]='0'*64
            response=run([*bad,'--check-only'],'wrong_candidate_rejected',1)
            assert 'Manifest identity mismatch' in response.stderr
            response=run([*common,'--boot-id','not-this-board'],'real_launch_rejected_on_pc',1)
            assert 'Explicit current board identity' in response.stderr
            response=run([sys.executable,'-I','-B',str(hand/'tools/verify_shadow_session.py'),
                          '--candidate',str(CANDIDATE),'--output',str(OUT/(args.label+'-actual-shadow.json'))],
                         'staged_real_process_chain',0)
            assert 'FROZEN_RUNTIME_TWO_PROCESS_SHADOW_PASS' in response.stdout
            for name,digest in manifest['sha256'].items():assert sha(hand/name)==digest,name
            record.update(status='SHADOW_RESTORED_ENTRY_AND_PROCESS_PASS',entries=len(manifest['sha256']),
                          candidate_manifest_sha256=sha(CANDIDATE/'deployment_manifest.json'),
                          hand_manifest_sha256=sha(hand/'source_manifest.json'),board_pending=True)
        except BaseException as error:
            record.update(status='FAIL',error=repr(error));raise
        finally:json.dump(record,receipt,indent=2)
    print(record['status'],record['entries'])


if __name__=='__main__':main()
