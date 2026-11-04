"""Freeze an independently paired C0E package; never opens SSH or a device.
Run: .venv/Scripts/python.exe -B subprojects/hdmi_input_osd/integration/finalize_latency_candidate.py
Outputs: r17 ZIP, independent restoration and evidence/latency-package-r01.json.
Next: ARM and board acceptance only after shared-board ownership is available.
"""
import ast,hashlib,json,os,runpy,subprocess,sys,zipfile
from pathlib import Path
HERE=Path(__file__).resolve().parent
REPO=HERE.parents[2]
TARGET=REPO/'deliveries/c6i-pl-vision-volume-osd-r17-20261023'
ROOT=REPO/'build/hosd/c0e/postroute-r05'
REPORT=ROOT/'signoff'
EVIDENCE=HERE/'evidence'
RECEIPT=EVIDENCE/'latency-package-r01.json'
RESTORED=REPO/'build/hosd/c0e/package-restore-r01'
REVIEW_RECEIPT=EVIDENCE/'latency-signoff-r05.json'
PAIR_RECEIPT=EVIDENCE/'latency-pair-r01.json'
VERIFICATION_RECEIPTS=('latency-signoff-r05.json','latency-source-contract-r03.json','latency-games-r01.json','latency-bgr-packet-decode-r02.json')
CANDIDATE_WARNING='Paired offline candidate only. ARM, real-board acceleration and coexistence acceptance pending. Do not interrupt Copilot hand tests.'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def save(p,v):
    with p.open('x',encoding='utf-8') as f:json.dump(v,f,indent=2)
def main():
    receipt=RECEIPT
    archive=TARGET.with_suffix('.zip')
    restored=RESTORED
    if any(p.exists() for p in (receipt,archive,restored)):raise FileExistsError('preserve package evidence')
    review=load(REVIEW_RECEIPT)
    assert review['status']=='C0E_TIMING_ROUTE_AND_SCOPED_REVIEW_PASS'
    for name,digest in review['files'].items(): assert sha(ROOT/name)==digest,name
    parent=REPO/'deliveries/c6i-vision-volume-osd-r16-20261022.zip'
    parent_sha='2e49d7fc2cb1f60a89ffd69b6d9510278d99897bdc06d609604f581e5a8fbb67'
    assert sha(parent)==parent_sha
    contracts=load(EVIDENCE/'latency-source-contract-r03.json')
    assert contracts['status']=='PASS'
    games=load(EVIDENCE/'latency-games-r01.json')
    assert games['status']=='DOUBLE_BUILD_PC_AND_R15_FRAME_EQUIVALENCE_PASS'
    verifier=runpy.run_path(str(TARGET/'board/pynq_z2/scripts/verify_vision_integration_sources.py'))
    paired=verifier['verify_volume_candidate_bundle'](REPORT)
    assert paired['status']=='OFFLINE_CANDIDATE_PAIR_PASS'
    for name in verifier['CANDIDATE_FILES']:(TARGET/'overlay'/name).write_bytes((REPORT/name).read_bytes())
    (TARGET/'overlay/board_test_manifest.json').write_text(json.dumps(paired,indent=2)+'\n',encoding='utf-8')
    (TARGET/'overlay/osd_signoff_review.json').write_text(json.dumps(review,indent=2)+'\n',encoding='utf-8')
    (TARGET/'overlay/METHODOLOGY_RESOLUTION_REPORT.md').write_bytes((REPORT/'METHODOLOGY_RESOLUTION_REPORT.md').read_bytes())
    for p in (ROOT/'extended').iterdir():
        if p.is_file():
            target=TARGET/'overlay/extended-review'/p.name
            target.parent.mkdir(exist_ok=True)
            target.write_bytes(p.read_bytes())
    for name,digest in review['numeric_production_sources'].items():
        matches=[Path(p) for p in review['synthesis_sources'] if Path(p).name==name]
        assert matches and all(sha(p)==digest for p in matches)
        target=TARGET/'overlay/pl-vision-source'/name
        target.parent.mkdir(exist_ok=True)
        target.write_bytes(matches[0].read_bytes())
    include=Path('hsv_reciprocal.svh')
    (TARGET/'overlay/pl-vision-source'/include).write_bytes((REPO/'build/hosd/c0e-n02/source'/include).read_bytes())
    for name in VERIFICATION_RECEIPTS:
        dst=TARGET/'verification'/name
        dst.write_bytes((EVIDENCE/name).read_bytes())
    (TARGET/'docs/pl_timing_repair.md').write_bytes((REPO/'docs/bringup/2026-10-23_pynq-z2_pl_timing_repair.md').read_bytes())
    marker=load(TARGET/'candidate_stage.json')
    assert marker['stage']=='SOURCE_ONLY_HARDWARE_PENDING'
    original_marker=marker.copy()
    marker.update(stage='PAIRED_PREFLIGHT_READY',release_ready=False,board_pending=True,board_operations=False,
                  timing_review='C0E_TIMING_ROUTE_AND_SCOPED_REVIEW_PASS',
                  bit_sha256=paired['sha256']['c6v_candidate.bit'],
                  warning=CANDIDATE_WARNING)
    (TARGET/'candidate_stage.json').write_text(json.dumps(marker,indent=2)+'\n',encoding='utf-8')
    record=dict(status='RUNNING',board_access=False,release_ready=False,preflights=[])
    try:
        contents={}
        for p in sorted(TARGET.rglob('*')):
            if not p.is_file():continue
            name=p.relative_to(TARGET).as_posix()
            if name=='deployment_manifest.json' or '__pycache__' in p.parts or '.pytest_cache' in p.parts:continue
            if name.startswith(('var/','games/osd-c0d')):continue
            data=p.read_bytes()
            if name.endswith('.py'):ast.parse(data.decode('utf-8-sig'),filename=name,feature_version=(3,10))
            contents[name]=data
        package_shas={name:info['sha256'] for name,info in games['packages'].items()}
        for name,digest in package_shas.items(): assert sha(TARGET/'games/pl-c0e-r01'/name)==digest
        manifest=load(TARGET/'deployment_manifest.json')
        manifest.update(build_id='0xC0060E00',profile='C6I_PL_VISION_VOLUME_OSD_V1',
            purpose='pl-vision-and-independent-hdmi-osd-c0e',parent_archive_sha256=parent_sha,
            board_pending=True,release_ready=False,osd_game_directory='games/pl-c0e-r01',
            games_sha256=package_shas,game_sha256=package_shas['game1-C0060E00.vvg'],
            pl_vision=True,sha256={name:hashlib.sha256(data).hexdigest().upper() for name,data in contents.items()})
        manifest_bytes=(json.dumps(manifest,indent=2)+'\n').encode()
        (TARGET/'deployment_manifest.json').write_bytes(manifest_bytes)
        contents['deployment_manifest.json']=manifest_bytes
        with zipfile.ZipFile(archive,'x',compression=zipfile.ZIP_DEFLATED) as z:
            for name,data in sorted(contents.items()):z.writestr(TARGET.name+'/'+name,data)
        restored.mkdir(parents=True)
        with zipfile.ZipFile(archive) as z:
            assert z.testzip() is None and len(z.namelist())==len(set(z.namelist()))==len(contents)
            for name,data in contents.items():
                assert z.read(TARGET.name+'/'+name)==data
                out=restored/name
                out.parent.mkdir(parents=True,exist_ok=True)
                with out.open('xb') as f:f.write(data)
        for root in (TARGET,restored):
            assert verifier['verify_volume_candidate_bundle'](root/'overlay')['status']=='OFFLINE_CANDIDATE_PAIR_PASS'
            for name,digest in manifest['sha256'].items():assert sha(root/name).upper()==digest
            for options in ([],['--volume-disable-sampling']):
                command=[sys.executable,'-B',str(root/'start_board_test.py'),'--check-only','--game-controls',*options]
                result=subprocess.run(command,cwd=root,env={**os.environ,'PYTHONPATH':str(root/'python'),'PYTHONIOENCODING':'utf-8'},
                                      capture_output=True,text=True,encoding='utf-8',errors='replace',timeout=120)
                record['preflights'].append(dict(command=command,returncode=result.returncode,stdout=result.stdout,stderr=result.stderr))
                assert result.returncode==0,result.stdout+result.stderr
            assert not (root/'var').exists()
        assert sha(parent)==parent_sha
        save(PAIR_RECEIPT,paired)
        record.update(status='C0E_PACKAGE_RESTORED_AND_PC_PREFLIGHT_PASS',archive=str(archive),sha256=sha(archive),
                      bytes=archive.stat().st_size,manifest_files=len(contents)-1,restored=str(restored),
                      build_id='0xC0060E00',timing=review['timing'],board_pending=True)
    except BaseException as error:
        record.update(status='FAIL',error=f'{type(error).__name__}: {error}')
        original_marker['warning']='Finalization failed; preserve package/logs; do not deploy.'
        (TARGET/'candidate_stage.json').write_text(json.dumps(original_marker,indent=2)+'\n',encoding='utf-8')
        raise
    finally:save(receipt,record)
    print(record['status'],record['sha256'],record['bytes'],record['manifest_files'])
if __name__=='__main__':main()

