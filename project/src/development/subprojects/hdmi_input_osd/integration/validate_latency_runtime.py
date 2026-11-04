"""C0E source regression, with candidate-origin proof and frozen-R1 OSD tests.

Run: .venv/Scripts/python.exe -B .../validate_latency_runtime.py --label UNIQUE
Outputs: evidence/LABEL/{copied tests, logs} and LABEL.json. No board IO.
Next: resolve real failures, then pair hardware and perform ARM contracts.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

from stage_latency_runtime import HERE,REPO,TARGET


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--label',required=True)
    args=parser.parse_args()
    if not args.label.replace('-','').isalnum():parser.error('unsafe label')
    output=HERE/'evidence'/(args.label+'.json')
    work=output.with_suffix('')
    if output.exists() or work.exists():raise FileExistsError(work)
    work.mkdir()
    temporary=REPO/'build/hosd'/('lt-'+hashlib.sha256(args.label.encode()).hexdigest()[:8])
    if temporary.exists():raise FileExistsError(temporary)
    temporary.mkdir()
    origins={}
    files=[]
    for name in ('test_agent_transport.py','test_multimodal_input.py','test_vision_receiver.py','test_vision_preview.py'):
        source=REPO/'tests'/name
        original=source.read_text(encoding='utf-8')
        fixture_root=REPO if name in ('test_agent_transport.py','test_multimodal_input.py') else TARGET
        copied=original.replace('Path(__file__).resolve().parents[1]',f'Path({str(fixture_root)!r})')
        # Historical voice-action projects are fixtures, not shipped runtime source.
        copied=copied.replace(f'root / "candidates/game1-voice-s2"',f'Path({str(REPO)!r}) / "candidates/game1-voice-s2"')
        copied=copied.replace('0xC0060C00','0xC0060E00').replace('0xC0060D00','0xC0060E00').replace(
            'C6I_VISION_VOLUME_V1','C6I_PL_VISION_VOLUME_OSD_V1')
        if name=='test_vision_preview.py':
            assert copied.count('else 0xC0060B00')==1
            copied=copied.replace('else 0xC0060B00','else 0xC0060E00')
            # C0E deliberately asserts reset only after a clean STOP, enabling a
            # fresh epoch; retain the same fake register's exact state readback.
            copied=copied.replace('assert value == 1\n                reset_released = True',
                                  'assert value in (0, 1)\n                reset_released = bool(value)')
        target=work/name;target.write_text(copied,encoding='utf-8');files.append(str(target))
        origins[name]=dict(source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
                           copied_sha256=hashlib.sha256(target.read_bytes()).hexdigest())
    origin_test=work/'test_c0e_origin.py'
    origin_test.write_text(f'''from pathlib import Path
def test_actual_candidate_import_origin():
    import pynq_multimodal_game
    import pynq_multimodal_game.agent.vision_backend as backend
    import vision_async_runtime as runtime
    root=Path({str(TARGET)!r})
    assert Path(pynq_multimodal_game.__file__).is_relative_to(root)
    assert Path(runtime.__file__).is_relative_to(root)
    assert backend.C6IVolumeRuntimeBackend.BUILD_ID==0xC0060E00
    assert runtime.SharedDualMaskHardware.build_id=='0xC0060E00'
''',encoding='utf-8')
    env={**os.environ,'PYTHONPATH':os.pathsep.join((str(TARGET/'python'),str(TARGET/'board/pynq_z2/scripts'),str(HERE.parent),str(REPO/'tests'))),
         'PYTHONDONTWRITEBYTECODE':'1','VVG_VISION_RUNTIME_DIR':str(TARGET/'handoffs/gesture_vision_v61/runtime'),
         'VVG_OSD_TEST_ROOT':str(TARGET),'VVG_OSD_TEST_TMP':str(temporary/'private-tmp')}
    (temporary/'private-tmp').mkdir()
    commands=[
        [sys.executable,'-B',str(TARGET/'tools/osd_runtime_contract.py')],
        [sys.executable,'-B','-m','unittest','discover','-s',str(HERE.parent/'tests'),'-v'],
        [sys.executable,'-B','-m','pytest','-q','-p','no:cacheprovider','-o','pythonpath='+str(TARGET/'python'),
         '--basetemp',str(temporary/'pt'),str(origin_test),*files,str(HERE/'test_latency_stop.py')],
    ]
    receipt=dict(status='RUNNING',candidate=str(TARGET),origins=origins,runs=[],board_access=False,
                 excluded='R2 native-MMIO and R2 preview shutdown prototypes are not part of this R1-derived candidate.')
    try:
        for index,command in enumerate(commands):
            result=subprocess.run(command,cwd=REPO,env=env,capture_output=True,text=True,encoding='utf-8',errors='replace',timeout=600)
            path=work/f'{index:02d}.log';path.write_text(result.stdout+result.stderr,encoding='utf-8')
            receipt['runs'].append(dict(command=command,returncode=result.returncode,log=str(path),sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
            print('C0E_LOCAL_SUITE',index,result.returncode,flush=True)
        receipt['status']='PASS' if all(run['returncode']==0 for run in receipt['runs']) else 'FAIL'
    finally:
        with output.open('x',encoding='utf-8') as stream:json.dump(receipt,stream,indent=2)
    if receipt['status']!='PASS':raise SystemExit(1)


if __name__=='__main__':main()
