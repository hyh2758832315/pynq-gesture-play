"""Restore frozen R1 as a protected C0E software work area; no board access.

Run: .venv/Scripts/python.exe -B .../stage_latency_runtime.py
Outputs: deliveries/c6i-pl-vision-volume-osd-r17-20261023, source-stage receipt.
Next: reviewed C0E factory/verifier changes, paired hardware and full packaging.
"""
import hashlib
import json
from pathlib import Path
import zipfile

HERE=Path(__file__).resolve().parent
REPO=HERE.parents[2]
TARGET=REPO/'deliveries/c6i-pl-vision-volume-osd-r17-20261023'
PARENT=REPO/'deliveries/c6i-vision-volume-osd-r16-20261022.zip'
PARENT_SHA='2e49d7fc2cb1f60a89ffd69b6d9510278d99897bdc06d609604f581e5a8fbb67'


def main():
    assert hashlib.sha256(PARENT.read_bytes()).hexdigest()==PARENT_SHA
    if TARGET.exists(): raise FileExistsError(TARGET)
    with zipfile.ZipFile(PARENT) as archive:
        assert archive.testzip() is None
        names=archive.namelist()
        assert len(names)==len(set(names))==559
        manifests=[name for name in names if name.endswith('/deployment_manifest.json')]
        assert len(manifests)==1
        prefix=manifests[0][:-len('deployment_manifest.json')]
        manifest=json.loads(archive.read(manifests[0]))
        assert len(manifest['sha256'])==558
        verified={}
        for member in names:
            if not member.startswith(prefix): raise ValueError('mixed ZIP root')
            name=member[len(prefix):]
            destination=(TARGET/name).resolve()
            if not destination.is_relative_to(TARGET): raise ValueError('unsafe member')
            data=archive.read(member)
            if name in manifest['sha256']:
                actual=hashlib.sha256(data).hexdigest().upper()
                if actual!=manifest['sha256'][name]: raise ValueError('R1 SHA mismatch '+name)
                verified[name]=actual
            destination.parent.mkdir(parents=True,exist_ok=True)
            with destination.open('xb') as stream: stream.write(data)
        assert set(verified)==set(manifest['sha256'])
    starter=TARGET/'start_board_test.py'
    original=starter.read_text(encoding='utf-8')
    guard='''# C0E source staging is intentionally non-deployable until paired finalization.
from pathlib import Path as _StagePath
import json as _StageJson
_stage = _StageJson.loads((_StagePath(__file__).parent / "candidate_stage.json").read_text())
if _stage.get("stage") != "PAIRED_PREFLIGHT_READY":
    raise RuntimeError("C0E hardware/software pairing and preflight are not complete")

'''
    starter.write_text(guard+original,encoding='utf-8')
    status=dict(stage='SOURCE_ONLY_HARDWARE_PENDING',target_build_id='0xC0060E00',
                profile='C6I_PL_VISION_VOLUME_OSD_V1',release_ready=False,board_pending=True,
                parent_zip_sha256=PARENT_SHA,parent_manifest_entries=len(verified),board_operations=False,
                warning='Copied overlay and deployment manifest are R1 baseline only. Entry is blocked until C0E paired finalization.')
    (TARGET/'candidate_stage.json').write_text(json.dumps(status,indent=2),encoding='utf-8')
    with (HERE/'evidence/latency-runtime-source-stage-r01.json').open('x',encoding='utf-8') as stream:
        json.dump(dict(status='FROZEN_R1_RESTORED_WITH_START_GUARD',target=str(TARGET),**status),stream,indent=2)
    print('C0E_SOURCE_ONLY_558_PARENT_SHA_VERIFIED',TARGET)


if __name__=='__main__': main()
