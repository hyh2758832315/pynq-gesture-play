"""Verify illustrative vision data with frozen decoder, OSD publisher and rule code.

Run: python -B tools/verify_vision_figure.py --source-root . --output report/figures/vision_dual_follow/data
Requires NumPy and OpenCV. No hardware imports, camera, sockets or serial access.
Outputs: verification.json, rules.csv, vote_trace.csv, dms1_example.bin,
dms1_trailer.csv and osd_registers.csv. Next: draw/review the data and preserve
the synthetic-example label; this is not a recognition accuracy test.
"""
from pathlib import Path
import argparse
import ast
import csv
from collections import deque
import hashlib
import importlib.util
import json
import math
import struct
import sys
import zlib

import cv2
import numpy as np


def module(path,name):
    spec=importlib.util.spec_from_file_location(name,path)
    obj=importlib.util.module_from_spec(spec);sys.modules[name]=obj;spec.loader.exec_module(obj)
    return obj


def write_csv(path,rows):
    with path.open('w',encoding='utf-8-sig',newline='') as f:
        w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--source-root',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True)
    a=p.parse_args();root=a.source_root;out=a.output;out.mkdir(parents=True,exist_ok=True)
    def source(key,relative):
        # Handoff contains flattened reference sources; project uses original paths.
        flat=root/'reference_only'/key
        return flat if flat.is_file() else root/relative
    paths={
        'decoder':source('dual_mask_packet.py','board/runtime/board/pynq_z2/dual_mask_packet.py'),
        'osd':source('button_osd.py','board/runtime/python/pynq_multimodal_game/button_osd.py'),
        'rules':source('vision_async_runtime.py','board/runtime/board/pynq_z2/scripts/vision_async_runtime.py')}
    dec=module(paths['decoder'],'figure_dual_mask_packet')
    w,h=640,360;pixels=w*h
    payload=bytearray(pixels*2);payload[:8]=bytes([255,255,0,64,255,128,0,0])
    thresholds=(0,20,20,255,70,255)
    tail=[dec.MAGIC,dec.VERSION_LENGTH,1,1,1,(h<<16)|w,pixels,len(payload),0,
          int.from_bytes(bytes(thresholds[:4]),'little'),int.from_bytes(bytes(thresholds[4:]),'little'),
          dec.PAIR_FORMAT,0,0,0]
    prefix=bytes(payload)+struct.pack('<15I',*tail)
    crc=zlib.crc32(prefix);packet=prefix+struct.pack('<I',crc)
    expected=dict(width=w,height=h,frame_id=1,config_id=1,epoch=1,thresholds=thresholds)
    decoded=dec.decode_dual_mask(packet,**expected)
    assert decoded.raw[0,:4].tolist()==[255,0,255,0]
    assert decoded.filtered[0,:4].tolist()==[255,64,128,0]
    rejected=[]
    for name,bad,kw in [('crc',packet[:-1]+bytes([packet[-1]^1]),expected),
                        ('identity',packet,{**expected,'frame_id':2})]:
        try:dec.decode_dual_mask(bad,**kw)
        except ValueError:rejected.append(name)
        else:raise AssertionError(name)
    (out/'dms1_example.bin').write_bytes(packet)
    names=['MAGIC','VERSION_LENGTH','frame_id','config_id','epoch','height_width','pixels','payload_bytes',
           'status','HSV_bytes_0_3','HSV_bytes_4_5','PAIR_FORMAT','reserved_12','reserved_13','reserved_14','CRC32']
    write_csv(out/'dms1_trailer.csv',[dict(word=i,packet_offset=len(payload)+i*4,field=n,
        value=v,hex=f'0x{v:08X}') for i,(n,v) in enumerate(zip(names,[*tail,crc]))])

    # Only the unmodified FullFrameTracker class is executed. The base provides
    # constructed per-frame features, rather than camera/image inference.
    class FeatureFixture:
        def __init__(self,*args):self.defect_depth=30.
        def infer(self,_):return dict(self.fixture)
    tree=ast.parse(paths['rules'].read_text(encoding='utf-8'))
    cls=next(n for n in tree.body if isinstance(n,ast.ClassDef) and n.name=='FullFrameTracker')
    ns=dict(OriginalContour=FeatureFixture,cv2=cv2,math=math,deque=deque)
    exec(compile(ast.Module(body=[cls],type_ignores=[]),str(paths['rules']),'exec'),ns)
    tracker=ns['FullFrameTracker']()
    rules=[]
    for name,n,area,ratio,code in [('fist',1,5000,10,'0'),('scissors',2,5000,20,'2'),
            ('paper',4,5000,30,'5'),('small',1,1999,10,'NO_HAND'),('ambiguous',2,5000,10,'REPOSITION')]:
        actual=tracker.classify_shape(n,area,ratio);assert actual==code
        rules.append(dict(case=name,fingers=n,area=area,ratio_percent=ratio,code=actual))
    write_csv(out/'rules.csv',rules)
    trace=[]
    for i,code in enumerate(['0','0','0','2','2','2'],1):
        tracker.fixture=dict(code=code,bbox=(100+i,80,200+i,230))
        result=tracker.infer(None)
        trace.append(dict(frame=f'F{i}',raw_code=code,stable=result['stable'],rps=result['rps'],
                          position_valid=True,marker='red_small' if result['stable']=='0' else 'green'))
    assert [r['stable'] for r in trace]==['PENDING','PENDING','0','PENDING','PENDING','2']
    write_csv(out/'vote_trace.csv',trace)

    osd=module(paths['osd'],'figure_button_osd')
    class MemoryMMIO:
        def __init__(self):self.busy=False;self.writes=[]
        def read(self,offset):return 0x4F534401 if offset==0 else int(self.busy)
        def write(self,offset,value):self.writes.append((offset,value))
    io=MemoryMMIO();pub=osd.HandOsdPublisher(io);hub=osd.ObservationHub()
    hub.publish(dict(centroid=(319.5,179.5),bbox=(100,80,400,300),stable='0',rps='ROCK'),
                run_id='example',config_epoch='epoch1',frame_id=1,observed_ns=1_000_000_000)
    assert pub.tick(hub.hand,now_ns=1_000_000_000)
    initial=list(pub.last_words);assert initial==[7,0x01680280,0,0x000F0000,1,0]
    io.busy=True;before=len(io.writes)
    assert pub.tick(hub.hand,now_ns=1_050_000_000) is False and len(io.writes)==before
    io.busy=False;pub.tick(hub.hand,now_ns=1_100_000_000)
    assert pub.last.observed_ns==1_000_000_000 and pub.sequence==1 and pub.last_words[3]==9<<16
    pub.tick(hub.hand,now_ns=1_250_000_000)
    assert pub.last_words[0]==1 and pub.last_words[3]==0
    write_csv(out/'osd_registers.csv',[dict(offset=f'0x{offset:02X}',field=name,value=value,hex=f'0x{value:08X}')
        for offset,name,value in zip([0x10,0x14,0x18,0x1c,0x20,0x24,8],
            ['FLAGS','XY','RESERVED0','TTL','HAND_SEQ','RESERVED1','COMMIT'],[*initial,1])])
    report=dict(result='PASS',scope='Constructed data and isolated production rules; no hardware or accuracy/FPS measurement',
        packet=dict(width=w,height=h,payload_bytes=len(payload),trailer_bytes=64,total_bytes=len(packet),
            crc32=f'0x{crc:08X}',example_first_bytes=packet[:8].hex(' ').upper(),rejected=rejected),
        vote_trace=trace,osd=dict(first_words=initial,busy_skips_without_write=True,
            duplicate_keeps_source_age=True,expired_hidden=True),
        source_sha256={k:hashlib.sha256(p.read_bytes()).hexdigest() for k,p in paths.items()})
    (out/'verification.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(dict(result='PASS',packet_bytes=len(packet),crc32=report['packet']['crc32'],
        rule_cases=len(rules),vote_frames=len(trace),hardware_access=False)))


if __name__=='__main__':main()
