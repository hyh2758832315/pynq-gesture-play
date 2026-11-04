"""Assemble the redraw handoff from existing figures and evidence (no board access).

Run from project root: .venv/Scripts/python.exe -B contest_v3/tools/build_hand_handoff.py
Requires PySide6 and PyMuPDF already used for the figures.
Outputs: hand_communication_handoff/ plus ZIP; updated four-plate PDF and figure ZIP.
Next: run handoff/scripts/check_data.py and review the four figure previews.
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
PROJECT=ROOT.parent
FIG=ROOT/'report/figures/hand_communication'
PACK=ROOT/'report/figures/hand_communication_handoff'
for sub in ('figures','data/raw','scripts','reference_only/runtime','reference_only/sdk','reference_only/licenses'):
    (PACK/sub).mkdir(parents=True,exist_ok=True)
index=[]

def cp(src,dst,scope):
    dst.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(src,dst)
    index.append(dict(origin=str(src),copy=str(dst.relative_to(PACK)).replace('\\','/'),
                      sha256=hashlib.sha256(src.read_bytes()).hexdigest(),scope=scope))

allpdf=pymupdf.open()
for name in ('01_logic','02_sequence','03_packet','04_comparison'):
    image=QImage(str(FIG/f'{name}.png'))
    assert not image.isNull()
    assert image.scaledToWidth(1700,Qt.TransformationMode.SmoothTransformation).save(str(FIG/f'{name}_preview.png'))
    for ext in ('png','svg','pdf','drawio','json'):
        src=FIG/f'{name}.{ext}'
        if src.is_file():cp(src,PACK/'figures'/src.name,'Editable figure / export')
    cp(FIG/f'{name}_preview.png',PACK/'figures'/f'{name}_preview.png','Reading preview')
    with pymupdf.open(FIG/f'{name}.pdf') as doc:
        assert len(doc)==1
        allpdf.insert_pdf(doc)
allpdf.save(FIG/'hand_communication_all.pdf')
allpdf.close()
cp(FIG/'hand_communication_all.pdf',PACK/'figures/hand_communication_all.pdf','Four-page overview')
for src in sorted((FIG/'comparison_data').glob('*.json')):
    cp(src,PACK/'data/raw'/src.name,'Archived board/offline measurement; scope retained')
for srcname,dstname in [('comparison_data.json','comparison_data.json'),('comparison_metrics.csv','comparison_metrics.csv'),
                       ('packet_check.json','packet_check.json'),('evidence.json','mechanism_evidence.json')]:
    cp(FIG/srcname,PACK/'data'/dstname,'Figure data and evidence')
cp(ROOT/'tools/render_system_diagram.py',PACK/'scripts/render_scene.py','PySide6 scene renderer')
cp(ROOT/'tools/plot_hand_comparison.py',PACK/'scripts/plot_comparison.py','Matplotlib data-figure renderer')

hand=ROOT/'board/runtime/hand-runtime'
sources=[hand/'assets/config.yaml']
sources += [hand/'src/pynq_usb_hand'/f'{s}.py' for s in ('gesture_consumer','controller','motion','orca_backend','transport','actuator_owner')]
sources += [hand/'tools/verify_offline.py',hand/'vendor/orca/orca_core/hardware/scs225_client.py',
            ROOT/'board/runtime/hand_child/serial_motion_receiver.py',
            ROOT/'board/runtime/python/pynq_multimodal_game/hand_serial_session.py']
for src in sources:cp(src,PACK/'reference_only/runtime'/src.name,'Source reference only; not a deployable runtime')
sdk=PROJECT/'subprojects/pynq_usb_hand/.venv/Lib/site-packages/scservo_sdk'
for src in sdk.glob('*.py'):cp(src,PACK/'reference_only/sdk'/src.name,'Local SDK used for memory-port encoding check')
dist=sdk.parent/'ftservo_python_sdk-2.0.0.dist-info'
cp(dist/'METADATA',PACK/'reference_only/sdk/METADATA','SDK distribution metadata')
license_file=next(dist.rglob('LICENSE'))
cp(license_file,PACK/'reference_only/sdk/LICENSE','Original SDK MIT license')
cp(hand/'vendor/orca/LICENSE',PACK/'reference_only/licenses/ORCA_LICENSE','Original Orca license')

values=['FF','FF','01','09','03','2A','08','00','00','00','01','F4','CB']
fields=['HEADER0','HEADER1','ID','LENGTH','WRITE','ADDRESS','POS_H','POS_L','TIME_H','TIME_L','SPEED_H','SPEED_L','CHECKSUM']
meanings=['帧头','帧头','电机1','7参数+2','写指令','起始寄存器0x2A','位置2048高字节','位置2048低字节',
          '时间0高字节','时间0低字节','速度500高字节','速度500低字节','取反和校验']
with (PACK/'data/packet_fields.csv').open('w',encoding='utf-8-sig',newline='') as f:
    w=csv.writer(f);w.writerow(['byte_index','hex','field','meaning'])
    w.writerows(zip(range(13),values,fields,meanings))

examples=[]
for name,code,params,kind in [
    ('position_id1_raw2048_time0_speed500',3,[42,8,0,0,0,1,244],'instruction'),
    ('write_success_ack_id1',0,[],'status'),
    ('read_register_block_id1',2,[16,48],'instruction'),
    ('torque_off_id1',3,[40,0],'instruction'),
    ('read_torque_id1',2,[40,1],'instruction'),
    ('torque_off_readback_id1',0,[0],'status')]:
    body=[1,len(params)+2,code,*params]
    packet=bytes([255,255,*body,(~sum(body))&255])
    examples.append(dict(name=name,kind=kind,id=1,instruction_or_error=code,parameters_or_data=params,
                         hex=packet.hex(' ').upper(),length=len(packet)))
(PACK/'data/protocol_examples.json').write_text(json.dumps(dict(baudrate=1000000,format='8N1',
    field_endian='big',checksum='(~sum(ID through final parameter/data)) & 0xFF',
    examples=examples,scope='Constructed protocol examples; position TX/ACK additionally checked with actual SDK memory port'),
    ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(PACK/'SOURCE_INDEX.json').write_text(json.dumps(index,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
files=sorted(f for f in PACK.rglob('*') if f.is_file() and f.name!='FILE_MANIFEST.json'
             and not any(part in ('generated','__pycache__','.matplotlib') for part in f.relative_to(PACK).parts))
manifest={str(f.relative_to(PACK)).replace('\\','/'):hashlib.sha256(f.read_bytes()).hexdigest() for f in files}
(PACK/'FILE_MANIFEST.json').write_text(json.dumps(dict(schema='hand-redraw-handoff-v1',sha256=manifest),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
handoff_zip=PACK.with_suffix('.zip')
with zipfile.ZipFile(handoff_zip,'w',zipfile.ZIP_DEFLATED) as z:
    for f in [*files,PACK/'FILE_MANIFEST.json']:z.write(f,PACK.name+'/'+str(f.relative_to(PACK)).replace('\\','/'))
figure_zip=FIG.parent/'hand_communication_figures.zip'
with zipfile.ZipFile(figure_zip,'w',zipfile.ZIP_DEFLATED) as z:
    for f in sorted(FIG.rglob('*')):
        if f.is_file() and '.matplotlib' not in f.parts and not f.name.endswith('_pdf_preview.png'):
            z.write(f,FIG.name+'/'+str(f.relative_to(FIG)).replace('\\','/'))
for archive in (handoff_zip,figure_zip):
    with zipfile.ZipFile(archive) as z:assert z.testzip() is None
print(json.dumps(dict(handoff=str(handoff_zip),files=len(files)+1,bytes=handoff_zip.stat().st_size,
                      sha256=hashlib.sha256(handoff_zip.read_bytes()).hexdigest()),ensure_ascii=False))
