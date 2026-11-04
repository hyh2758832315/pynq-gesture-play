"""OpenCV DMA goldens; run before run_xsim.ps1 -Dma. No board access.

Outputs golden/dma_*.hex and dma_summary.json; next RTL test then full route.
"""
import json
from pathlib import Path
import numpy as np
import cv2

ROOT = Path(__file__).resolve().parent
MAGIC = 0x534b4e36


def main():
    rng = np.random.default_rng(20261006)
    requests, replies = [], []
    cases = []
    def add(h, w, kind='normal'):
        fid = len(cases)+1
        bgr = rng.integers(0, 256, (h,w,3), dtype=np.uint8)
        hsv = cv2.cvtColor(bgr, cv2.COLOR_BGR2HSV)
        mask = cv2.inRange(hsv, (0,20,70), (20,255,255))
        header = [MAGIC, w|(h<<16), fid, 0xff141400, 0xff46]
        raw = bgr.tobytes()
        data = np.frombuffer(raw+b'\0'*((-len(raw))%4), dtype='<u4').tolist()
        status = 0
        if kind == 'short':
            data = data[:1]
            fallback = np.zeros_like(bgr).reshape(-1,3)
            fallback[0] = bgr.reshape(-1,3)[0]
            mask = cv2.inRange(cv2.cvtColor(fallback.reshape(h,w,3), cv2.COLOR_BGR2HSV), (0,20,70),(20,255,255))
            status = 1
        elif kind == 'long':
            data += [0x12345678, 0xabcdef00]
            status = 1
        elif kind in ('bad_magic', 'bad_dimensions', 'bad_threshold', 'bad_value_bounds', 'early_header'):
            if kind == 'bad_magic': header[0] = 0
            if kind == 'bad_dimensions': header[1] = h<<16
            if kind == 'bad_threshold': header[3] = 0xff14b400
            if kind == 'bad_value_bounds': header[4] = 0x0046
            if kind == 'early_header': data = []
            mask = np.empty((0,), np.uint8)
            status = 1
        elif kind == 'bad_keep': status = 1
        words = header+data
        for i,x in enumerate(words):
            keep = 7 if kind == 'bad_keep' and i==5 else 15
            requests.append(int(x)|(keep<<32)|(int(i==len(words)-1)<<36))
        raw_mask = mask.tobytes()
        output = np.frombuffer(raw_mask+b'\0'*((-len(raw_mask))%4), dtype='<u4').tolist()
        count = h*w if mask.size else 0
        output += [MAGIC,fid,header[1],count,status,0,0,0]
        replies.extend(int(x)|(int(i==len(output)-1)<<32) for i,x in enumerate(output))
        cases.append(dict(h=h,w=w,kind=kind,fid=fid))
    for h,w in [(1,1),(1,2),(1,3),(1,5),(1,7),(48,64),(360,640),(720,1280)]: add(h,w)
    for kind in ['short','long','bad_keep','bad_magic','bad_dimensions','bad_threshold','bad_value_bounds','early_header']: add(2,4,kind)
    add(3,5) # clean next frame after all malformed packet responses
    out = ROOT/'golden'
    out.mkdir(exist_ok=True)
    (out/'dma_input.hex').write_text(''.join(f'{x:010x}\n' for x in requests),encoding='ascii')
    (out/'dma_expected.hex').write_text(''.join(f'{x:09x}\n' for x in replies),encoding='ascii')
    (out/'dma_sizes.svh').write_text(f'localparam NI={len(requests)},NO={len(replies)},NF={len(cases)};\n',encoding='ascii')
    (out/'dma_summary.json').write_text(json.dumps(dict(cases=cases,input_words=len(requests),output_words=len(replies),opencv=cv2.__version__),indent=2)+'\n',encoding='utf8')
    print('DMA_GOLDEN_GENERATED',len(requests),len(replies),len(cases))


if __name__=='__main__': main()
