"""python3 -m unittest test_dma_lifetime: allocation lifetime/size transitions."""
import unittest
from types import SimpleNamespace
import numpy as np
from moments_dma import MomentsDMA, MAX_PIXELS
from test_dma_transfer import Buffer, FakeDMA


class LifetimeTests(unittest.TestCase):
    def make_driver(self):
        allocated=[]
        def allocate(shape,dtype):
            buf=Buffer(shape,dtype,0x100000+len(allocated)*0x800000)
            allocated.append(buf)
            return buf
        dma=FakeDMA(allocated)
        gpio=SimpleNamespace(write=lambda o,v:None)
        overlay=SimpleNamespace(moments_dma=SimpleNamespace(mmio=dma),moments_reset=SimpleNamespace(mmio=gpio))
        return MomentsDMA(overlay,allocator=allocate),allocated,dma

    def test_small_large_small_no_unmap_and_exact_lengths(self):
        driver,buffers,dma=self.make_driver()
        outputs=[]
        for fid,(h,w) in enumerate(((48,64),(360,640),(720,1280),(48,64),(1,1)),1):
            hsv=np.full((h,w,3),(20,20,70),dtype=np.uint8)
            mask,result=driver.run(hsv,np.ones((h,w),np.uint8),fid)
            self.assertEqual(len(buffers),2)
            self.assertFalse(any(b.freed for b in buffers))
            self.assertEqual(buffers[0].size,MAX_PIXELS+5)
            self.assertEqual(dma.regs[0x28],(h*w+5)*4)
            self.assertEqual(dma.regs[0x58],(h*w+8)*4)
            self.assertEqual(result['area'],h*w)
            self.assertEqual(result['sum_x'],h*w*(w-1)//2)
            self.assertEqual(result['sum_y'],h*w*(h-1)//2)
            self.assertIs(type(mask),np.ndarray)
            self.assertFalse(np.shares_memory(mask,np.asarray(buffers[1])))
            outputs.append(mask)
        driver.close()
        self.assertTrue(all(b.freed for b in buffers))
        self.assertIsNone(driver._tx_view)
        self.assertIsNone(driver._rx_view)
        self.assertTrue(all(np.all(m==255) for m in outputs))
        with self.assertRaises(RuntimeError):driver.run(hsv,np.ones((1,1)),99)

    def test_mapping_subclass_never_participates_in_vector_ops(self):
        class StrictBuffer(Buffer):
            def __array_ufunc__(self,*args,**kwargs):
                raise AssertionError('DMA subclass vector operation')
        allocated=[]
        def allocate(shape,dtype):
            buf=StrictBuffer(shape,dtype,0x100000+len(allocated)*0x800000)
            allocated.append(buf);return buf
        dma=FakeDMA(allocated)
        overlay=SimpleNamespace(moments_dma=SimpleNamespace(mmio=dma),moments_reset=SimpleNamespace(mmio=SimpleNamespace(write=lambda o,v:None)))
        driver=MomentsDMA(overlay,allocator=allocate)
        for fid in range(3):
            mask,result=driver.run(np.full((2,4,3),(20,20,70),np.uint8),np.ones((2,4)),fid)
            self.assertEqual(result['area'],8)
        driver.close()

    def test_baseline_cannot_be_started(self):
        from moments_dma_baseline import MomentsDMA as Unsafe
        with self.assertRaisesRegex(RuntimeError,'retired'):Unsafe(None)


if __name__=='__main__':unittest.main()
