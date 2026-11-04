"""Assemble an isolated complete v3 snapshot; never alter the shared Git tree.

Run: .venv/Scripts/python.exe -B tools/package_v3_release.py --output NEW_DIR
Output: board_runtime, hand, studio, source, verification, portable entrypoints.
Next: validate snapshot, seal with seal_v3_release.py, then publish after board PASS.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil

ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
a=p.parse_args();out=a.output.resolve();out.mkdir(parents=True,exist_ok=False)
if os.name=='nt':out=Path('\\\\?\\'+str(out))
skip={'.git','.venv','venv','__pycache__','.pytest_cache','.Xil','xsim.dir','build','deliveries',
      'output','results','artifacts','evidence','wheelhouse','.vscode','.reports','.loads','.backups',
      '.seed-manifests','.mypy_cache','.ruff_cache','node_modules'}
extensions={'.py','.sv','.v','.vh','.tcl','.xdc','.cpp','.hpp','.h','.c','.toml','.yaml','.yml',
    '.json','.md','.txt','.csv','.xml','.png','.npz','.npy','.ps1','.bat','.sh','.ini','.cfg',
    '.hwh','.xpr','.bd','.html','.css','.js','.svg','.qrc','.ipynb'}
origins={}
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def copy(src,dst):
    dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst)
    assert sha(src)==sha(dst)
    origins[dst.relative_to(out).as_posix()]=src.relative_to(ROOT).as_posix()
def tree(src,dst):
    for directory,dirs,files in os.walk(src):
        dirs[:]=[d for d in dirs if d not in skip and not d.endswith(('.runs','.cache','.gen','.hw','.ip_user_files'))]
        for name in files:
            f=Path(directory)/name
            if f.is_symlink() or f.suffix not in extensions and name not in ('LICENSE','NOTICE','COPYING'):continue
            if f.suffix=='.txt' and name.startswith(('FinalUnmatched','clockInfo','psipCongestion')):continue
            copy(f,dst/f.relative_to(src))
def frozen(src,dst,manifest_name):
    m=json.loads((src/manifest_name).read_text(encoding='utf-8'))
    for name,digest in m['sha256'].items():
        assert sha(src/name)==digest.lower(),name
        copy(src/name,dst/name)
    copy(src/manifest_name,dst/manifest_name)

candidate=ROOT/'build/ps-ui-video-handoff-r15b'
frozen(candidate,out/'board_runtime','deployment_manifest.json')
hand=ROOT/'build/hand-pause-recovery-r16'
tree(hand,out/'hand')
for name,digest in json.loads((candidate/'hand_child/serial_sources.json').read_text(encoding='utf-8'))['sha256'].items():
    assert sha(out/'hand'/name)==digest
tree(ROOT/'python',out/'studio/python')
tree(ROOT/'games_gesture',out/'studio/games_gesture')
for name in ('pyproject.toml','DESIGN.md'):copy(ROOT/name,out/'studio'/name)
for src in (ROOT/'media/default_videos').iterdir():
    if src.suffix in ('.mp4','.json'):copy(src,out/'studio/media/default_videos'/src.name)
for name in ('python','games','rtl','sim','src','scripts','board','tests','docs','subprojects','tools','xilinx-skill'):
    tree(ROOT/name,out/'source'/name)
for name in ('pyproject.toml','README.md','DESIGN.md','启动Studio.bat','启动PC游戏.bat'):
    copy(ROOT/name,out/'source'/name)
for name in ('gesture_vision_v61','pc_gesture_baseline_20261007'):
    tree(ROOT/'handoffs'/name,out/'source/handoffs'/name)
base=ROOT/'deliveries/c6i-pl-vision-button-osd-r23b2-shared-id-boardtest-20261024'
frozen(base,out/'source/deliveries'/base.name,'deployment_manifest.json')
for relative in (
    'studio-unified-start-final.xml','studio-boot-probe.xml','v3-autostart.xml',
    'v3-autostart-connect/receipt.json','v3-autostart-connect/board.json',
    'studio-video-handoff-r15b-acceptance-r02/result.json',
    'studio-video-handoff-r15b-hand-start/receipt.json',
    'studio-video-handoff-r15b-install-r03/ui-system.json',
    'menu-video-preview-recovery/regression-final.xml',
    'menu-video-preview-recovery/localhost.xml',
    'menu-video-preview-recovery/hand-integration-final.xml',
    'menu-video-preview-recovery/studio-final.xml','menu-video-preview-recovery/frozen.xml',
    'v3-acceptance-summary.json'):
    src=ROOT/'build'/relative
    if not src.is_file():raise FileNotFoundError(src)
    copy(src,out/'verification'/('acceptance-summary.json' if relative=='v3-acceptance-summary.json' else relative))
for src in (ROOT/'build/studio-unified-start-native').glob('simulated-*.png'):
    copy(src,out/'verification/studio-ui'/src.name)
copy(ROOT/'build/studio-unified-start-native/receipt.json',out/'verification/studio-ui/receipt.json')
for src in (ROOT/'tools/release_v3').iterdir():
    if src.is_file():copy(src,out/src.name)
(out/'.gitattributes').write_text('* -text\n',encoding='utf-8')
(out/'PROVENANCE.json').write_text(json.dumps(dict(version='3.0',date='2026-10-30',
    board='PYNQ-Z2 xc7z020clg400-1',vivado='2026.1',build_id='0xC0061000',
    runtime_manifest_sha256=sha(candidate/'deployment_manifest.json'),hand='R16 pause recovery',
    source_origin=origins),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(output=str(out),files=len(origins))))
