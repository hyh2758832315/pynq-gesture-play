"""Assemble the GPU figures and teammate redraw handoff.

Run from repository root: .venv/Scripts/python.exe -B contest_v3/tools/build_gpu_handoff.py
Requires PySide6 and PyMuPDF. Outputs a three-page PDF, editable handoff folder,
source/file manifests and ZIP. Next: check_package, redraw, inspect the final exports.
Only reads frozen sources; no hardware, process control or network access.
"""
from pathlib import Path
import hashlib,json,shutil,zipfile
import pymupdf
from PySide6.QtGui import QImage
from PySide6.QtCore import Qt

ROOT=Path(__file__).resolve().parents[1]
FIG=ROOT/'report/figures/gpu_buffer_timing'
PACK=ROOT/'report/figures/gpu_buffer_timing_handoff'
for name in ('figures','data','reference_only','scripts'):(PACK/name).mkdir(parents=True,exist_ok=True)
index=[]
def cp(src,dst,scope):
    dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst)
    index.append(dict(origin=src.relative_to(ROOT).as_posix(),copy=dst.relative_to(PACK).as_posix(),
        sha256=hashlib.sha256(src.read_bytes()).hexdigest(),scope=scope))
names=('01_gpu_buffers','02_gpu_present_timing','03_gpu_encoding_storage')
pdf=pymupdf.open()
for name in names:
    im=QImage(str(FIG/f'{name}.png'));assert not im.isNull()
    assert im.scaledToWidth(1600,Qt.TransformationMode.SmoothTransformation).save(str(FIG/f'{name}_preview.png'))
    for ext in ('json','drawio','svg','png','pdf'):cp(FIG/f'{name}.{ext}',PACK/'figures'/f'{name}.{ext}','Editable scene / export')
    cp(FIG/f'{name}_preview.png',PACK/'figures'/f'{name}_preview.png','Reading preview')
    with pymupdf.open(FIG/f'{name}.pdf') as d:assert len(d)==1;pdf.insert_pdf(d)
pdf.save(FIG/'gpu_buffer_timing_all.pdf');pdf.close()
cp(FIG/'gpu_buffer_timing_all.pdf',PACK/'figures/gpu_buffer_timing_all.pdf','Three-page figure set')
for p in (FIG/'data').iterdir():
    if p.is_file():cp(p,PACK/'data'/p.name,'Constructed examples, deterministic memory fixture or configuration-derived values')
base=ROOT/'board/runtime/python/pynq_multimodal_game'
sources=[base/p for p in ('gpu_abi.py','scene.py','scene_compiler.py','video_codec.py',
    'agent/c6i_backend.py','agent/c6i_video.py','agent/c6i_shell.py','agent/video_runtime.py','agent/game_runtime.py')]
rtl=ROOT/'build/hardware/c6_latency/c6_latency.srcs/sources_1/imports'
sources += [rtl/(name+'.sv') for name in ('scene2d_c4m7_core','scene2d_c4m3_core','scene2d_command_upload',
    'scene2d_frame_swap','scene2d_framebuffer','scene2d_palette_scanout','scene2d_video_timing',
    'scene2d_palette_store','scene2d_asset_bundle_store','scene2d_tilemap_store','scene2d_resource_upload',
    'scene2d_packet_router','scene2d_clear_fill_renderer','input_osd_top')]
sources += [ROOT/'build/hardware/c6_latency/c6_latency.srcs/sources_1/bd/c6v/c6v.bd']
for p in sources:cp(p,PACK/'reference_only'/p.name,'Frozen source reference; not a complete deployable project')
cp(ROOT/'tools/render_vision_diagram.py',PACK/'scripts/render_scene.py','Shared vector renderer')
cp(ROOT/'tools/verify_gpu_figure.py',PACK/'scripts/verify_gpu_figure.py','Production ABI / sink memory-fixture checks')
(PACK/'SOURCE_INDEX.json').write_text(json.dumps(index,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
evidence=dict(baseline='contest_v3 / R15b / BUILD_ID 0xC0061000',device='PYNQ-Z2 / xc7z020clg400-1',
    project_version='Vivado 2026.1 (existing XPR header)',hardware_access=False,
    source_sha256={p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in sources},
    source_scope='Imported RTL and frozen board runtime, not historical architecture targets',
    abstraction='Successful Scene submission; symbolic widths; steady-state bank A/B example. Palette commit is independent.')
(FIG/'evidence.json').write_text(json.dumps(evidence,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
cp(FIG/'evidence.json',PACK/'data/evidence.json','Source baseline, abstraction and hashes')
files=sorted(p for p in PACK.rglob('*') if p.is_file() and p.name!='FILE_MANIFEST.json' and
    not any(q in ('generated','regenerated_data','__pycache__') for q in p.relative_to(PACK).parts))
hashes={p.relative_to(PACK).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in files}
(PACK/'FILE_MANIFEST.json').write_text(json.dumps(dict(schema='gpu-redraw-handoff-v1',sha256=hashes),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
archive=PACK.with_suffix('.zip')
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED) as z:
    for p in [*files,PACK/'FILE_MANIFEST.json']:z.write(p,PACK.name+'/'+p.relative_to(PACK).as_posix())
with zipfile.ZipFile(archive) as z:assert z.testzip() is None
print(json.dumps(dict(archive=str(archive),files=len(files)+1,bytes=archive.stat().st_size),ensure_ascii=False))
