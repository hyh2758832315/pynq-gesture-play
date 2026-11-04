"""Isolated C0E BGR numeric regression using frozen ARM4.5.4 RGB gold.

Run: .venv/Scripts/python.exe -B .../run_latency_bgr_numeric.py
Outputs: build/hosd/c0e-n01 sources, byte-permuted gold, logs and receipt.
The channel permutation changes input bytes only; ARM masks remain immutable.
Next: install only the tested frontend into C0E after the live reset sim ends.
"""
import hashlib
import argparse
import json
from pathlib import Path
import subprocess
import time

import numpy as np

HERE=Path(__file__).resolve().parent
REPO=HERE.parents[2]
OUTPUT=REPO/'build/hosd/c0e-n01'
FROZEN=Path('E:/vvl/c0e/latency-r02/rtl')
TOOLS=Path('D:/Xilinx/Vivado/2026.1/Vivado/bin')


def digest(path): return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    global OUTPUT
    parser=argparse.ArgumentParser()
    parser.add_argument('--output',type=Path,default=OUTPUT)
    parser.add_argument('--dilation',type=Path)
    args=parser.parse_args()
    OUTPUT=args.output.resolve()
    if not OUTPUT.is_relative_to(REPO/'build/hosd'):
        parser.error('output must remain under workspace build/hosd')
    OUTPUT.mkdir(parents=True,exist_ok=False)
    sources=OUTPUT/'source';sources.mkdir()
    gold=OUTPUT/'gold';gold.mkdir()
    capture=OUTPUT/'capture';capture.mkdir()
    baseline=REPO/'results/game-validation/vision-pl-streaming-20261015/r259-frontend-reference'
    manifest=json.loads((baseline/'manifest.json').read_text(encoding='utf-8-sig'))
    for item in manifest:
        original=baseline/item['path']
        if original.stat().st_size!=item['bytes'] or digest(original)!=item['sha256']:
            raise ValueError('ARM reference identity mismatch '+item['path'])
    for original in baseline.glob('*.bin'):
        data=original.read_bytes()
        if original.name.endswith('-input.bin'):
            data=np.frombuffer(data,dtype=np.uint8).reshape(-1,3)[:,::-1].tobytes()
        (gold/original.name).write_bytes(data)
    for original in sorted(FROZEN.glob('*.sv')):
        data=original.read_text(encoding='utf-8')
        if original.name=='axis_rgb_mask_frontend.sv':
            old='.s_axis_tdata({reduced_rgb[7:0], reduced_rgb[15:8], reduced_rgb[23:16]})'
            assert data.count(old)==1
            data='// C0E native DMA bytes match R1 capture_order=BGR; RGB fork bytes stay unchanged.\n'+data.replace(old,'.s_axis_tdata(reduced_rgb)')
        (sources/original.name).write_text(data,encoding='utf-8')
    if args.dilation is not None:
        override=args.dilation.resolve()
        assert override.name=='axis_binary_dilate9.sv'
        (sources/override.name).write_bytes(override.read_bytes())
    hsv=REPO/'handoffs/gesture_vision_v61/hardware/frontend/rtl'
    expected={'axis_bgr_hsv_skin.sv':'ee4cdea7dbcb22817613c0df98da69e708d2443912304b04605ad7458855e0c5',
              'hsv_reciprocal.svh':'213a330f8aa05f684999724602cc84b59692c8375538a294beed14fe79b398c9'}
    for name,value in expected.items():
        assert digest(hsv/name)==value
        (sources/name).write_bytes((hsv/name).read_bytes())
    original_tb=REPO/'tests/rtl/tb_axis_rgb_mask_frontend.sv'
    tb=original_tb.read_text(encoding='utf-8').replace(
        'E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r259-frontend-reference',gold.as_posix()).replace(
        'E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r274-capture-output',capture.as_posix())
    # Preserve the same semantic red/blue protocol stimuli under BGR byte order.
    tb=tb.replace("24'h0000ff","24'hSWAP").replace("24'hff0000","24'h0000ff").replace("24'hSWAP","24'hff0000")
    (sources/original_tb.name).write_text(tb,encoding='utf-8')
    receipt=dict(status='RUNNING',board_operations=False,source_sha256={p.name:digest(p) for p in sources.iterdir()},
                 gold_sha256={p.name:digest(p) for p in gold.iterdir()},steps=[],error=None,
                 semantics='Native BGR byte ordering; raw/filtered masks unchanged from SHA-verified ARM4.5.4 gold.')
    commands=[([str(TOOLS/'xvlog.bat'),'--sv','-i',str(sources),
               *[str(p) for p in sorted(sources.glob('*.sv'))]],OUTPUT)]
    for top in ('tb_axis_rgb_mask_frontend','tb_axis_rgb_dual_mask_capture'):
        commands += [([str(TOOLS/'xelab.bat'),top,'-s',top,'--mt','off','-L','xpm'],OUTPUT),
                     ([str(TOOLS/'xsim.bat'),top,'-runall'],OUTPUT)]
    try:
        for index,(command,cwd) in enumerate(commands):
            started=time.monotonic()
            result=subprocess.run(command,cwd=cwd,capture_output=True,timeout=900)
            output=(result.stdout+result.stderr).decode('utf-8',errors='replace')
            (OUTPUT/f'step-{index}.log').write_text(output,encoding='utf-8')
            receipt['steps'].append(dict(command=command,returncode=result.returncode,seconds=time.monotonic()-started))
            if result.returncode or 'Fatal:' in output or 'FATAL:' in output:
                raise RuntimeError(f'numeric stage {index} failed; preserve log')
            if index in (2,4) and output.count('TEST_PASS ')!=1:
                raise RuntimeError(f'numeric stage {index} missing unique PASS')
            print('C0E_NUMERIC_STAGE_PASS',index,round(time.monotonic()-started,3),flush=True)
        for path in sources.iterdir():
            assert digest(path)==receipt['source_sha256'][path.name]
        receipt['status']='BGR_FRONTEND_AND_CAPTURE_NUMERIC_PASS'
    except BaseException as failure:
        receipt.update(status='FAIL',error=repr(failure))
        raise
    finally:
        (OUTPUT/'receipt.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
    print(receipt['status'],flush=True)


if __name__=='__main__': main()
