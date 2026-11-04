import unittest
from types import SimpleNamespace
import numpy as np
from moments_dma import MomentsDMA, MAGIC


class Buffer(np.ndarray):
    def __new__(cls,shape,dtype,address):
        obj=np.zeros(shape,dtype=dtype).view(cls)
        obj.physical_address=address;obj.freed=False;obj.flushed=0;obj.invalidated=0
        return obj
    def flush(self):self.flushed+=1
    def invalidate(self):self.invalidated+=1
    def freebuffer(self):self.freed=True


class FakeDMA:
    def __init__(self,buffers):self.regs={0:0,0x30:0,4:1,0x34:1};self.buffers=buffers;self.writes=[]
    def read(self,o):return self.regs.get(o,0)
    def write(self,o,v):
        self.writes.append((o,v));self.regs[o]=v
        if o in (0,0x30):
            self.regs[o+4]=0 if v&1 else 1
            if v&4:self.regs[o]=0
        if o==0x28:
            tx,rx=self.buffers
            width=int(tx[1])&65535;height=int(tx[1])>>16
            pixels=np.asarray(tx)[5:5+height*width].reshape(height,width)
            mask=((pixels&255)<=20)&(((pixels>>8)&255)>=20)&(((pixels>>16)&255)>=70)&((pixels>>24)&1!=0)
            yy,xx=np.nonzero(mask)
            np.asarray(rx)[:width*height]=mask.ravel().astype(np.uint32)*255
            np.asarray(rx)[width*height:width*height+8]=[MAGIC,int(mask.sum()),int(xx.sum()),0,int(yy.sum()),0,int(tx[2]),0]
            self.regs[4]=self.regs[0x34]=2


class TransferTests(unittest.TestCase):
    def test_receive_first_cache_operations_and_buffer_reuse(self):
        buffers=[]
        def allocate(shape,dtype):
            b=Buffer(shape,dtype,0x100000+len(buffers)*0x800000);buffers.append(b);return b
        dma=FakeDMA(buffers)
        class GPIO:
            def write(self,o,v):pass
        overlay=SimpleNamespace(moments_dma=SimpleNamespace(mmio=dma),moments_reset=SimpleNamespace(mmio=GPIO()))
        driver=MomentsDMA(overlay,allocator=allocate)
        hsv=np.full((2,4,3),(20,20,70),dtype=np.uint8)
        gate=np.ones((2,4),dtype=bool)
        mask,result=driver.run(hsv,gate,56)
        self.assertTrue(np.all(mask==255));self.assertEqual(result['centroid'],(1.5,.5))
        self.assertLess(dma.writes.index((0x58,64)),dma.writes.index((0x28,52)))
        self.assertEqual(buffers[0].flushed,1);self.assertEqual(buffers[1].invalidated,1)
        driver.run(hsv,gate,57)
        self.assertEqual(len(buffers),2)
        driver.close();self.assertTrue(all(b.freed for b in buffers))


if __name__=='__main__':unittest.main()
