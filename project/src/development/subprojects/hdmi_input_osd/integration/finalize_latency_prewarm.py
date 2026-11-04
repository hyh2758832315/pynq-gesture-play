"""Freeze a separately paired prewarm package from the immutable d02 software baseline.

Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/finalize_latency_prewarm.py
Outputs: deliveries/c6i-pl-vision-volume-osd-r18-prewarm-20261023.zip, independent restore and prewarm-package/pair receipts.
Next: ARM preflight and identity-bound board acceptance only after current boot ownership checks. No board access here.
"""
import ast
import hashlib
import json
from pathlib import Path
import runpy
import shutil
import zipfile

import finalize_latency_candidate as base

HERE=Path(__file__).resolve().parent
REPO=HERE.parents[2]
PARENT=REPO/'deliveries/c6i-pl-vision-volume-osd-r17-20261023-d02.zip'
TARGET=REPO/'deliveries/c6i-pl-vision-volume-osd-r18-prewarm-20261023'
ROOT=REPO/'build/hosd/c0e/prewarm-r01'


def main():
    assert not TARGET.exists() and not TARGET.with_suffix('.zip').exists()
    assert hashlib.sha256(PARENT.read_bytes()).hexdigest()=='fde5af827707c6b9c2cfc6cad779f3137222eb1b1747f5d71d465a9111466c59'
    review=base.load(base.EVIDENCE/'latency-prewarm-signoff-r01.json')
    assert review['status']=='C0E_TIMING_ROUTE_AND_SCOPED_REVIEW_PASS'
    for name,digest in review['files'].items():assert base.sha(ROOT/name)==digest,name
    assert base.load(base.EVIDENCE/'latency-prewarm-full-rate-r01.json')['status']=='TWO_FULL_720P_FRAMES_NO_OVERFLOW_PASS'
    assert base.load(REPO/'build/hosd/c0e-prewarm-numeric-r01/receipt.json')['status']=='BGR_FRONTEND_AND_CAPTURE_NUMERIC_PASS'
    verifier=runpy.run_path(str(PARENT.with_suffix('')/'board/pynq_z2/scripts/verify_vision_integration_sources.py'))
    assert verifier['verify_volume_candidate_bundle'](ROOT/'signoff')['status']=='OFFLINE_CANDIDATE_PAIR_PASS'
    with zipfile.ZipFile(PARENT) as archive:
        assert archive.testzip() is None and len(archive.namelist())==595
        prefix=PARENT.stem+'/'
        for member in archive.namelist():
            assert member.startswith(prefix)
            path=(TARGET/member[len(prefix):]).resolve()
            assert path.is_relative_to(TARGET)
            path.parent.mkdir(parents=True,exist_ok=True)
            with path.open('xb') as out:out.write(archive.read(member))
    manifest=base.load(TARGET/'deployment_manifest.json')
    for name,digest in manifest['sha256'].items():assert base.sha(TARGET/name).upper()==digest
    manifest['immediate_parent_archive_sha256']=base.sha(PARENT)
    manifest['prewarm_dilation_sha256']='c2a60d3490c616762bd76493087ea593fa550a251a170372feb4a5f1f06771a6'
    (TARGET/'deployment_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
    marker=base.load(TARGET/'candidate_stage.json')
    marker.update(stage='SOURCE_ONLY_HARDWARE_PENDING',release_ready=False,board_pending=True,
                  warning='Prewarm candidate construction in progress; do not deploy this tree.')
    (TARGET/'candidate_stage.json').write_text(json.dumps(marker,indent=2)+'\n',encoding='utf-8')
    for name in ('latency-prewarm-ab-r01.json','latency-prewarm-full-rate-r01.json',
                 'latency-diagnostics-restore-r02.json','latency-prewarm-synthesis-r01.json'):
        shutil.copyfile(base.EVIDENCE/name,TARGET/'verification'/name)
    shutil.copyfile(REPO/'build/hosd/c0e-prewarm-numeric-r01/receipt.json',TARGET/'verification/latency-prewarm-numeric-r01.json')
    # The runtime remains byte-identical to the actually ARM-tested d02 software.
    # Hardware sources and reports are replaced from the exact new reviewed design by the common finalizer.
    for name in manifest['sha256']:
        if name.startswith(('python/','board/')) and name.endswith('.py'):
            ast.parse((TARGET/name).read_text(encoding='utf-8-sig'),filename=name,feature_version=(3,10))
    base.TARGET=TARGET
    base.ROOT=ROOT
    base.REPORT=ROOT/'signoff'
    base.RECEIPT=base.EVIDENCE/'latency-prewarm-package-r01.json'
    base.RESTORED=REPO/'build/hosd/c0e/prewarm-package-restore-r01'
    base.REVIEW_RECEIPT=base.EVIDENCE/'latency-prewarm-signoff-r01.json'
    base.PAIR_RECEIPT=base.EVIDENCE/'latency-prewarm-pair-r01.json'
    base.VERIFICATION_RECEIPTS=('latency-prewarm-signoff-r01.json','latency-source-contract-r03.json',
                               'latency-games-r01.json','latency-bgr-packet-decode-r02.json')
    base.CANDIDATE_WARNING='Prewarm hardware/source pairing and offline tests passed; real ARM/board, coexistence and physical input acceptance still required.'
    base.main()


if __name__=='__main__':main()
