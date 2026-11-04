"""Assemble the vision redraw handoff from local figures and source evidence.

Run: python -B tools/build_vision_handoff.py (from contest_v3)
Requires PySide6, PyMuPDF. Outputs vision_dual_follow_handoff/ and ZIP;
also a combined three-page PDF. Next: run check_package and redraw scripts.
No hardware, process control, serial or network access.
"""
from pathlib import Path
import csv
import hashlib
import json
import shutil
import zipfile
import pymupdf
from PySide6.QtGui import QImage
from PySide6.QtCore import Qt

ROOT=Path(__file__).resolve().parents[1]
FIG=ROOT/'report/figures/vision_dual_follow'
PACK=ROOT/'report/figures/vision_dual_follow_handoff'
for sub in ('figures','data','reference_only','scripts'):(PACK/sub).mkdir(parents=True,exist_ok=True)
index=[]

def cp(src,dst,scope):
    dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst)
    index.append(dict(origin=str(src.relative_to(ROOT)).replace('\\','/'),
        copy=str(dst.relative_to(PACK)).replace('\\','/'),sha256=hashlib.sha256(src.read_bytes()).hexdigest(),scope=scope))

names=('01_vision_dual_follow','02_recognition_logic','03_dms1_osd_timing')
pdf=pymupdf.open()
for name in names:
    im=QImage(str(FIG/f'{name}.png'));assert not im.isNull()
    assert im.scaledToWidth(1600,Qt.TransformationMode.SmoothTransformation).save(str(FIG/f'{name}_preview.png'))
    for ext in ('png','svg','pdf','drawio','json'):cp(FIG/f'{name}.{ext}',PACK/'figures'/f'{name}.{ext}','Editable scene or export')
    cp(FIG/f'{name}_preview.png',PACK/'figures'/f'{name}_preview.png','Reading preview')
    with pymupdf.open(FIG/f'{name}.pdf') as doc:
        assert len(doc)==1;pdf.insert_pdf(doc)
pdf.save(FIG/'vision_dual_follow_all.pdf');pdf.close()
cp(FIG/'vision_dual_follow_all.pdf',PACK/'figures/vision_dual_follow_all.pdf','Three-page overview')
for src in (FIG/'data').iterdir():
    if src.is_file():cp(src,PACK/'data'/src.name,'Constructed offline example; scope in verification.json')
formats=[('Camera RGB storage',1280,720,3,1280*720*3,'Per-frame VDMA RGB storage; PS copy only on preview demand'),
         ('Raw mask',640,360,1,640*360,'0 or 255 per pixel'),
         ('Filtered mask',640,360,1,640*360,'0..255 per pixel'),
         ('DMS1 payload',640,360,2,640*360*2,'Interleaved raw and filtered'),
         ('DMS1 packet',640,360,2,640*360*2+64,'Payload plus 64 B trailer'),
         ('OSD mailbox',0,0,0,24,'Six uint32 shadow words; commit transaction is separate')]
with (PACK/'data/formats.csv').open('w',encoding='utf-8-sig',newline='') as f:
    w=csv.writer(f);w.writerow(['format','width','height','bytes_per_pixel','bytes','scope']);w.writerows(formats)

base=ROOT/'board/runtime'
sources=[base/'board/pynq_z2/scripts/vision_async_runtime.py',base/'board/pynq_z2/dual_mask_packet.py',
    base/'board/pynq_z2/vision_latest_capture.py',base/'board/pynq_z2/vision_dma_pool.py',base/'board/pynq_z2/vision_capture_control.py']
sources += [base/'python/pynq_multimodal_game'/s for s in ('agent/pl_button_factory.py','button_osd.py',
    'vision_input.py','hand_serial_session.py','hand_shadow_bridge.py','agent/button_osd_backend.py')]
sources += [base/'hand-runtime/src/pynq_usb_hand/gesture_consumer.py',base/'handoffs/gesture_vision_v61/runtime/gesture_control.py']
rtl=ROOT/'build/hardware/c6_latency/c6_latency.srcs/sources_1/imports'
sources += [rtl/'rtl'/s for s in ('axis_area2x2.sv','axis_rgb_dual_mask_capture.sv','axis_binary_mask_pair.sv',
    'axis_binary_gaussian5.sv','axis_dual_mask_packet.sv')]
sources += [rtl/s for s in ('axis_bgr_hsv_skin.sv','hsv_reciprocal.svh','input_osd_ctrl.sv','input_osd_pixels.sv','input_osd_top.sv')]
sources += [rtl/'voice-view-game/subprojects/hdmi_input_osd/latency_rtl'/s for s in ('axis_rgb_mask_frontend.sv','axis_binary_dilate9.sv')]
for src in sources:cp(src,PACK/'reference_only'/src.name,'Frozen implementation reference; not a complete deployment project')
cp(base/'handoffs/gesture_vision_v61/runtime/PROJECT1_LICENSE.txt',PACK/'reference_only/PROJECT1_LICENSE.txt','Original MIT attribution from vision source')
cp(ROOT/'tools/render_vision_diagram.py',PACK/'scripts/render_scene.py','Editable scene renderer')
cp(ROOT/'tools/verify_vision_figure.py',PACK/'scripts/verify_vision_figure.py','Production decoder / isolated rules / memory MMIO example verification')

identity={str(p.relative_to(ROOT)).replace('\\','/'):hashlib.sha256(p.read_bytes()).hexdigest()
    for p in (base/'deployment_manifest.json',base/'overlay/c6v_candidate.hwh')}
(PACK/'data/runtime_identity.json').write_text(json.dumps(dict(build_id='0xC0061000',runtime='R15b',hand_runtime='R16',
    source_sha256=identity,scope='Local frozen files, no board read'),indent=2)+'\n',encoding='utf-8')
(PACK/'SOURCE_INDEX.json').write_text(json.dumps(index,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(FIG/'evidence.json').write_text(json.dumps(dict(baseline='contest_v3 / R15b / R16 / 0xC0061000',
    source_sha256={str(p.relative_to(ROOT)).replace('\\','/'):hashlib.sha256(p.read_bytes()).hexdigest() for p in sources},
    validation='data/verification.json',hardware_access=False),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
files=sorted(p for p in PACK.rglob('*') if p.is_file() and p.name!='FILE_MANIFEST.json' and
    not any(part in ('generated','regenerated_data','__pycache__') for part in p.relative_to(PACK).parts))
hashes={str(p.relative_to(PACK)).replace('\\','/'):hashlib.sha256(p.read_bytes()).hexdigest() for p in files}
(PACK/'FILE_MANIFEST.json').write_text(json.dumps(dict(schema='vision-redraw-handoff-v1',sha256=hashes),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
archive=PACK.with_suffix('.zip')
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED) as z:
    for p in [*files,PACK/'FILE_MANIFEST.json']:z.write(p,PACK.name+'/'+str(p.relative_to(PACK)).replace('\\','/'))
with zipfile.ZipFile(archive) as z:assert z.testzip() is None
print(json.dumps(dict(archive=str(archive),files=len(files)+1,bytes=archive.stat().st_size),ensure_ascii=False))
