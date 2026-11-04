import unittest
from types import SimpleNamespace
import numpy as np
import cv2
import tempfile
from pathlib import Path
from unittest.mock import patch
from skin_dma import SkinDMA,pack_bgr_into,decode_mask,verify_skin_hwh,MAGIC
from test_dma_transfer import Buffer


class FakeSkinDMA:
    def __init__(self,buffers):
        self.buffers=buffers;self.regs={0:0,0x30:0,4:1,0x34:1};self.writes=[]
        self.corrupt=False;self.short=False
    def read(self,o): return self.regs.get(o,0)
    def write(self,o,v):
        self.writes.append((o,v));self.regs[o]=v
        if o in (0,0x30):
            self.regs[o+4]=0 if v&1 else 1
            if v&4:self.regs[o]=0
        if o==0x28:
            tx,rx=map(np.asarray,self.buffers)
            w=int(tx[1])&65535;h=int(tx[1])>>16;n=h*w
            bgr=tx[5:].view(np.uint8)[:n*3].reshape(h,w,3)
            hs=int(tx[3]);vb=int(tx[4])
            lo=(hs&255,(hs>>16)&255,vb&255);hi=((hs>>8)&255,(hs>>24)&255,(vb>>8)&255)
            mask=cv2.inRange(cv2.cvtColor(bgr,cv2.COLOR_BGR2HSV),lo,hi)
            p=(n+3)//4;rx[:p]=0
            rx[:p].view(np.uint8)[:n]=mask.reshape(-1)
            rx[p:p+8]=[MAGIC,int(tx[2])+int(self.corrupt),int(tx[1]),n,0,0,0,0]
            if self.short:self.regs[0x58]-=4
            self.regs[4]=self.regs[0x34]=2


class Tests(unittest.TestCase):
    def make(self):
        allocated=[]
        def allocate(shape,dtype):
            b=Buffer(shape,dtype,0x100000+len(allocated)*0x800000);allocated.append(b);return b
        dma=FakeSkinDMA(allocated)
        overlay=SimpleNamespace(ip_dict={'skin_kernel':{}},moments_dma=SimpleNamespace(mmio=dma),
            moments_reset=SimpleNamespace(mmio=SimpleNamespace(write=lambda o,v:None)))
        with patch('skin_dma.verify_skin_hwh',return_value=None):
            driver=SkinDMA(overlay,allocator=allocate)
        return driver,allocated,dma
    def test_packed_raw_bytes_roi_and_padding(self):
        source=np.arange(90,dtype=np.uint8).reshape(5,6,3)
        for bgr in (source,source[:,1:4],source[::-1,::2]):
            h,w=bgr.shape[:2];words=np.empty(5+(h*w*3+3)//4,dtype='<u4')
            pack_bgr_into(words,bgr,123)
            self.assertEqual(words[5:].view(np.uint8)[:h*w*3].tobytes(),bgr.tobytes())
            self.assertTrue(np.all(words[5:].view(np.uint8)[h*w*3:]==0))
    def test_shape_transitions_cache_rx_first_and_owned_outputs(self):
        driver,buffers,dma=self.make();rng=np.random.default_rng(6);outputs=[]
        for fid,(h,w) in enumerate([(1,1),(1,2),(1,3),(48,64),(360,640),(720,1280),(1,1)]):
            bgr=rng.integers(0,256,(h,w,3),dtype=np.uint8)
            mask,stats=driver.run(bgr,fid)
            gold=cv2.inRange(cv2.cvtColor(bgr,cv2.COLOR_BGR2HSV),(0,20,70),(20,255,255))
            self.assertTrue(np.array_equal(mask,gold));outputs.append((mask,gold))
            self.assertEqual(len(buffers),2);self.assertFalse(any(b.freed for b in buffers))
            self.assertEqual(stats['tx_bytes'],(5+(3*h*w+3)//4)*4)
            self.assertEqual(stats['rx_bytes'],(8+(h*w+3)//4)*4)
            self.assertIs(type(mask),np.ndarray)
        self.assertLess(next(i for i,p in enumerate(dma.writes) if p[0]==0x58),next(i for i,p in enumerate(dma.writes) if p[0]==0x28))
        self.assertEqual(buffers[1].invalidated,7)
        driver.close();self.assertTrue(all(b.freed for b in buffers))
        self.assertTrue(all(np.array_equal(m,g) for m,g in outputs))
    def test_stale_frame_and_short_reply_recover(self):
        for attr in ('corrupt','short'):
            driver,buffers,dma=self.make();setattr(dma,attr,True)
            with self.assertRaises(ValueError):driver.run(np.zeros((2,2,3),np.uint8),8)
            self.assertTrue(all(dma.read(o)&1 for o in (4,0x34)))
            self.assertFalse(any(b.freed for b in buffers));driver.close()
    def test_old_overlay_rejected_before_dma_access(self):
        with self.assertRaisesRegex(ValueError,'v6'):SkinDMA(SimpleNamespace(ip_dict={}))
    def test_real_hwh_module_type_checked_not_nonaddressable_ip_dict(self):
        with tempfile.TemporaryDirectory() as directory:
            bit=Path(directory)/'camera_hand_skin_v6.bit';hwh=bit.with_suffix('.hwh')
            overlay=SimpleNamespace(bitfile_name=str(bit),ip_dict={})
            hwh.write_text('<ROOT><MODULE INSTANCE="skin_kernel" MODTYPE="bgr_skin_dma"/></ROOT>')
            verify_skin_hwh(overlay)
            hwh.write_text('<ROOT><MODULE INSTANCE="skin_kernel" MODTYPE="hsv_moments_dma"/></ROOT>')
            with self.assertRaisesRegex(ValueError,'v6'):verify_skin_hwh(overlay)
    def test_reply_fields_binary_and_padding_rejected(self):
        good=np.array([255,MAGIC,3,0x10001,1,0,0,0,0],dtype='<u4')
        for index in range(1,9):
            bad=good.copy();bad[index]^=1
            with self.assertRaises(ValueError):decode_mask(bad,1,1,3)
        for pixel in [128,0xff00]:
            bad=good.copy();bad[0]=pixel
            with self.assertRaises(ValueError):decode_mask(bad,1,1,3)
    def test_bad_input_rejected_without_allocating(self):
        driver,buffers,dma=self.make()
        for frame_id in (-1,0x100000000,1.5):
            with self.assertRaises(ValueError):driver.run(np.zeros((1,1,3),np.uint8),frame_id)
        with self.assertRaises(ValueError):driver.run(np.zeros((1,1,3),np.uint8),1,(0,180,20,255,70,255))
        self.assertEqual(buffers,[]);driver.close()


if __name__=='__main__':unittest.main()
