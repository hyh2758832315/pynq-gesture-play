"""Pair a rebuilt GPU profile with the supplied Studio/board software.
Run: python -B tools/prepare_runtime.py --hardware BUILD/result --profile
     cache_pipeline_pair --out build/output/runtime_pair
Outputs a new SHA-bound Studio runtime; no board access.
Next: select it in Studio, or set PYNQ_RUNTIME before tools/start_studio.py.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys
from xml.etree import ElementTree as ET

ROOT=Path(__file__).resolve().parents[1]
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def save(path,data):path.write_text(json.dumps(data,indent=2)+'\n','utf-8')
def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--hardware',type=Path,required=True)
    parser.add_argument('--profile',choices=('baseline','cache_pipeline','cache_pipeline_pair'),required=True)
    parser.add_argument('--out',type=Path,required=True)
    args=parser.parse_args();hw=args.hardware.resolve();out=args.out.resolve()
    if out.exists():parser.error('Choose a fresh output directory')
    subprocess.run([sys.executable,'-B',str(ROOT/'tools/check_hardware.py'),str(hw)],check=True)
    tree=ET.fromstring((hw/'c6v_candidate.hwh').read_bytes())
    core=next(x for x in tree.iter('MODULE') if x.get('INSTANCE')=='core')
    params={x.get('NAME'):x.get('VALUE','').strip('"') for x in core.iter('PARAMETER')}
    flags={name:int(args.profile!='baseline') for name in ('TILE_DESCRIPTOR_CACHE_ENABLE','BLIT_PIXEL_PIPELINE_ENABLE','TILE_PIXEL_PIPELINE_ENABLE')}
    flags.update({name:int(args.profile=='cache_pipeline_pair') for name in ('TILE_PIXEL_PAIR_ENABLE','BLIT_PIXEL_PAIR_ENABLE','CLEAR_FILL_PIXEL_PAIR_ENABLE')})
    flags['UPLOAD_RENDER_OVERLAP_ENABLE']=0
    for key,value in flags.items():
        if params.get(key)!=str(value):raise ValueError(f'{key}: requested profile differs from hardware')
    shutil.copytree(ROOT/'board/runtime',out,ignore=shutil.ignore_patterns('__pycache__','*.pyc','var'))
    for name in ('c6v_candidate.bit','c6v_candidate.hwh','c6v_candidate.xsa'):
        shutil.copy2(hw/name,out/'overlay'/name)
    metadata=out/'overlay/board_test_manifest.json'
    data=json.loads(metadata.read_text('utf-8'))
    data.update(gpu_profile=args.profile,gpu_features=flags,board_pending=True,release_ready=False)
    data['sha256']={p.name:sha(p).upper() for p in (out/'overlay').iterdir() if p.suffix in ('.bit','.hwh','.xsa')}
    data['timing']=json.loads((hw/'hardware_check.json').read_text('utf-8'))['timing']
    save(metadata,data)
    stage=json.loads((out/'candidate_stage.json').read_text('utf-8'))
    stage.update(gpu_profile=args.profile,gpu_features=flags,bit_sha256=sha(out/'overlay/c6v_candidate.bit'),board_pending=True,release_ready=False)
    save(out/'candidate_stage.json',stage)
    plan=json.loads((out/'board_test_plan.json').read_text('utf-8'))
    plan.update(gpu_profile=args.profile,gpu_features=flags,bit_sha256=stage['bit_sha256'],board_pending=True)
    save(out/'board_test_plan.json',plan)
    save(out/'candidate_delta.json',dict(schema='gpu-runtime-pairing-v1',gpu_profile=args.profile,
         hardware_sha256=data['sha256'],software_template_manifest_sha256=sha(ROOT/'board/runtime/deployment_manifest.json')))
    manifest=json.loads((out/'deployment_manifest.json').read_text('utf-8'))
    manifest['sha256']={p.relative_to(out).as_posix():sha(p).upper() for p in out.rglob('*') if p.is_file() and p.name!='deployment_manifest.json'}
    save(out/'deployment_manifest.json',manifest)
    subprocess.run([sys.executable,'-B',str(out/'start_board_test.py'),'--check-only'],check=True)
    print('RUNTIME_PACKAGE_VERIFIED',out)
if __name__=='__main__':main()
