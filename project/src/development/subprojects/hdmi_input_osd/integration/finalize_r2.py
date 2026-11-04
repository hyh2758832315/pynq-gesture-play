"""Seal the software-only R2 child, with original hardware paired unchanged.

Run: .venv/Scripts/python.exe -B .../finalize_r2.py
Outputs: R2 ZIP, actual restore, g25-r2-package.json and final source audit.
Next: stage ARM contracts before any owner-bound board switch.
"""
import ast
import hashlib
import json
import os
from pathlib import Path
import runpy
import subprocess
import sys
import zipfile

HERE=Path(__file__).resolve().parent
REPO=HERE.parents[2]
ROOT=REPO/'deliveries/c6i-vision-volume-osd-r16-20261023-r2'


def sha(data): return hashlib.sha256(data).hexdigest()
def load(path): return json.loads(path.read_text(encoding='utf-8'))
def save(path,value):
    with path.open('x',encoding='utf-8') as output: json.dump(value,output,indent=2)


def main():
    dest=HERE/'evidence/g25-r2-package.json'
    archive=ROOT.with_suffix('.zip')
    restored=HERE/'evidence/g25-r2-restored'
    if dest.exists() or archive.exists() or restored.exists(): raise FileExistsError('preserve seal')
    assert load(HERE/'evidence/g24-r2-local-r02.json')['status']=='PASS'
    manifest=load(ROOT/'deployment_manifest.json')
    original=dict(manifest['sha256'])
    for name,digest in original.items():
        if name.startswith('overlay/'):
            assert sha((ROOT/name).read_bytes()).upper()==digest
    verifier=runpy.run_path(str(ROOT/'board/pynq_z2/scripts/verify_vision_integration_sources.py'))
    assert verifier['verify_volume_candidate_bundle'](ROOT/'overlay')==load(ROOT/'overlay/board_test_manifest.json')
    (ROOT/'tools/osd_preview_shutdown_contract.py').write_bytes((HERE/'test_preview_shutdown.py').read_bytes())
    (ROOT/'docs/hdmi_osd_integration.md').write_bytes((REPO/'docs/bringup/2026-10-22_pynq-z2_hdmi_input_osd_integration.md').read_bytes())
    contents={}
    for path in ROOT.rglob('*'):
        if not path.is_file(): continue
        name=path.relative_to(ROOT).as_posix()
        if name=='deployment_manifest.json' or name.startswith('var/') or '__pycache__' in path.parts: continue
        data=path.read_bytes()
        if name.endswith('.py'): ast.parse(data.decode('utf-8-sig'),filename=name,feature_version=(3,10))
        contents[name]=data
    parent='2e49d7fc2cb1f60a89ffd69b6d9510278d99897bdc06d609604f581e5a8fbb67'
    assert sha((REPO/'deliveries/c6i-vision-volume-osd-r16-20261022.zip').read_bytes())==parent
    delta={name:dict(before=original.get(name),after=sha(data).upper()) for name,data in contents.items()
           if original.get(name)!=sha(data).upper()}
    manifest.update(parent_archive_sha256=parent,software_revision='c0d-osd-native-u32-r2',
        osd_register_io='existing-owner-native-u32-view',preview_shutdown='drain-codec-before-stop-relay',
        sha256={name:sha(data).upper() for name,data in contents.items()})
    encoded=(json.dumps(manifest,indent=2)+'\n').encode()
    (ROOT/'deployment_manifest.json').write_bytes(encoded)
    contents['deployment_manifest.json']=encoded
    save(HERE/'evidence/g25-r2-source-delta.json',dict(status='FINAL_R2_SOURCE_AST_SHA_PASS',changes=delta,all_overlay_members_unchanged=True))
    with zipfile.ZipFile(archive,'x',compression=zipfile.ZIP_DEFLATED) as stream:
        for name,data in sorted(contents.items()): stream.writestr(ROOT.name+'/'+name,data)
    restored.mkdir()
    with zipfile.ZipFile(archive) as stream:
        assert stream.testzip() is None and len(stream.namelist())==len(contents)
        for name,data in contents.items():
            assert stream.read(ROOT.name+'/'+name)==data
            path=restored/name
            path.parent.mkdir(parents=True,exist_ok=True)
            path.write_bytes(data)
    record=dict(status='RUNNING',sha256=sha(archive.read_bytes()),files=len(contents)-1,bytes=archive.stat().st_size,
                hardware_unchanged=True,preflights=[],board_access=False)
    try:
        for root in (ROOT,restored):
            for extra in ([],['--volume-disable-sampling']):
                command=[sys.executable,'-B',str(root/'start_board_test.py'),'--check-only','--game-controls',*extra]
                result=subprocess.run(command,cwd=root,env={**os.environ,'PYTHONPATH':str(root/'python')},text=True,encoding='utf-8',errors='replace',capture_output=True,timeout=90)
                record['preflights'].append(dict(command=command,returncode=result.returncode,stdout=result.stdout,stderr=result.stderr))
                assert result.returncode==0,result.stdout+result.stderr
            assert not (root/'var').exists()
            for name,digest in manifest['sha256'].items(): assert sha((root/name).read_bytes()).upper()==digest
        record['status']='PACKAGE_RESTORED_AND_PREFLIGHT_PASS'
    except BaseException as error:
        record.update(status='FAIL',error=f'{type(error).__name__}: {error}')
        raise
    finally: save(dest,record)
    print(record['status'],record['sha256'],record['files'])


if __name__=='__main__': main()
