"""PYNQ root: python3 -u verify_skin_dma.py --bit camera_hand_skin_v6.bit --repeat 5.

Outputs exact same-frame skin masks and transfer-inclusive timing, NOT camera
FPS. Stop other camera/DMA owners first; no reboot. Optional --input raw.npz
must contain unannotated uint8 bgr. Next: guarded real-camera validation mode.
"""
import argparse
import os
from pathlib import Path
import time
import cv2
import numpy as np
from skin_dma import SkinDMA,validate_input


def assert_no_other_owner():
    ancestors=set();pid=os.getpid()
    while pid and pid not in ancestors:
        ancestors.add(pid)
        try:pid=int((Path('/proc')/str(pid)/'stat').read_text().rsplit(')',1)[1].split()[1])
        except (OSError,ValueError,IndexError):break
    names={'project1_live_ov5640.py','capture_camera_direct_plug.py','run_camera_live_guarded.py',
           'run_accel_guarded.py','verify_dma.py','verify_skin_dma.py'}
    for path in Path('/proc').glob('[0-9]*/cmdline'):
        if int(path.parent.name) in ancestors:continue
        try:tokens=path.read_bytes().decode(errors='replace').split('\0')
        except OSError:continue
        if any(Path(t).name in names for t in tokens if t):
            raise RuntimeError(f'Stop other camera/DMA owner pid={path.parent.name} first')


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--bit',type=Path,required=True)
    parser.add_argument('--input',type=Path)
    parser.add_argument('--repeat',type=int,default=5)
    args=parser.parse_args()
    if not 1<=args.repeat<=100:parser.error('--repeat must be 1..100')
    if os.geteuid()!=0:raise PermissionError('root required on board')
    assert_no_other_owner()
    bit=args.bit.resolve()
    if bit.name!='camera_hand_skin_v6.bit':raise ValueError('paired v6 bit required')
    from verify_package import verify
    verify(bit.parent)
    rng=np.random.default_rng(20261005)
    cases=[]
    for h,w in ((1,1),(1,2),(1,3),(48,64),(360,640),(720,1280)):
        cases.append((f'synthetic_{w}x{h}',rng.integers(0,256,(h,w,3),dtype=np.uint8)))
    cases.append(('empty',np.zeros((48,64,3),np.uint8)))
    if args.input:
        with np.load(args.input,allow_pickle=False) as data:
            bgr=data['bgr'].copy()
        validate_input(bgr,1,(0,20,20,255,70,255));cases.append(('same_frame_raw',bgr))
    from pynq import Overlay
    overlay=Overlay(str(bit),download=False)
    for name in ('moments_dma','moments_reset','frame_dma','hand_osd'):
        if name not in overlay.ip_dict:raise ValueError(f'missing hardware {name}')
    overlay.download()
    driver=SkinDMA(overlay)
    print(f'SKIN_DMA_DRIVER=compact_BGR_v6 OpenCV={cv2.__version__}',flush=True)
    fid=0
    try:
        for name,bgr in cases:
            gold=cv2.inRange(cv2.cvtColor(bgr,cv2.COLOR_BGR2HSV),(0,20,70),(20,255,255))
            fid+=1;mask,stats=driver.run(bgr,fid)
            if not np.array_equal(mask,gold):raise AssertionError(f'mask mismatch {name}')
            print(f'SKIN_DMA_SAME_FRAME_PASS case={name} result={stats}',flush=True)
            measured=[];reference=[]
            for _ in range(args.repeat):
                t=time.perf_counter()
                gold=cv2.inRange(cv2.cvtColor(bgr,cv2.COLOR_BGR2HSV),(0,20,70),(20,255,255))
                reference.append((time.perf_counter()-t)*1000)
                fid+=1;mask,stats=driver.run(bgr,fid)
                if not np.array_equal(mask,gold):raise AssertionError('repeat same-frame mismatch')
                measured.append(stats['total_ms'])
            print(f'SKIN_DMA_STAGE_PROFILE case={name} trials={len(measured)} total_ms_median={np.median(measured):.3f} '
                  f'PS_color_mask_ms_median={np.median(reference):.3f}; includes packing/cache/transfer/decode; NOT camera FPS',flush=True)
    finally:driver.close()
    print('SKIN_DMA_BOARD_GOLDEN_PASS; synthetic unless same_frame_raw also passed; NOT camera FPS',flush=True)


if __name__=='__main__':main()
