"""python3 -m unittest test_dma_optimized: wire equivalence and snapshot safety."""
import unittest
from types import SimpleNamespace
import numpy as np
import moments_dma_baseline as baseline
from moments_dma import pack_frame, pack_frame_into, decode_reply, MomentsDMA
from test_dma_transfer import Buffer, FakeDMA


class OptimizedTests(unittest.TestCase):
    def test_wire_equivalence_sizes_strides_bounds(self):
        rng = np.random.default_rng(2106)
        for h,w in ((1,1),(48,64),(360,640),(720,1280)):
            hsv = rng.integers(0,256,(h,w*2,3),dtype=np.uint8)[:,::2]
            gate = rng.integers(-2,3,(h,w*2),dtype=np.int16)[:,::2]
            bounds = (3,77,12,200,44,219)
            expected = baseline.pack_frame(hsv,gate,0xffffffff,bounds)
            scratch = np.zeros(expected.shape,dtype='<u4')
            self.assertIs(pack_frame_into(scratch,hsv,gate,0xffffffff,bounds),scratch)
            np.testing.assert_array_equal(scratch,expected)
            np.testing.assert_array_equal(pack_frame(hsv,gate,0xffffffff,bounds),expected)
            pack_frame_into(scratch,np.zeros_like(hsv),np.zeros_like(gate),1)
            self.assertTrue(np.all(scratch[5:]==0))

    def test_no_subclass_vector_ops_and_mask_owns_snapshot(self):
        class Mapped(np.ndarray):
            def __array_ufunc__(self,*args,**kwargs):
                raise AssertionError('vector operation on mapped buffer')
        words=np.array([255,255,baseline.MAGIC,2,1,0,0,0,27,0],dtype=np.uint32).view(Mapped)
        mask,result=decode_reply(words,2,1,27)
        self.assertEqual(result['centroid'],(.5,0))
        np.asarray(words)[:2]=0
        self.assertEqual(mask.tolist(),[[255,255]])

    def test_transfer_reuse_and_masks_independent(self):
        buffers=[]
        def allocate(shape,dtype):
            b=Buffer(shape,dtype,0x100000+len(buffers)*0x800000)
            buffers.append(b)
            return b
        dma=FakeDMA(buffers)
        gpio=SimpleNamespace(write=lambda o,v:None)
        overlay=SimpleNamespace(moments_dma=SimpleNamespace(mmio=dma),moments_reset=SimpleNamespace(mmio=gpio))
        driver=MomentsDMA(overlay,allocator=allocate)
        hsv=np.full((2,4,3),(20,20,70),dtype=np.uint8)
        mask,first=driver.run(hsv,np.ones((2,4)),10)
        scratch_ids=(id(driver._tx_scratch),id(driver._rx_scratch))
        empty,second=driver.run(hsv,np.zeros((2,4)),11)
        self.assertEqual(len(buffers),2)
        self.assertEqual(scratch_ids,(id(driver._tx_scratch),id(driver._rx_scratch)))
        self.assertTrue(np.all(mask==255))
        self.assertTrue(np.all(empty==0))
        self.assertEqual(second['frame_id'],11)
        for key in ('pack_ms','tx_copy_cache_ms','rx_snapshot_ms','decode_ms'):
            self.assertGreaterEqual(first[key],0)
        driver.close()

    def test_invalid_scratch_and_inputs(self):
        hsv=np.zeros((2,3,3),dtype=np.uint8);gate=np.zeros((2,3),dtype=np.uint8)
        with self.assertRaises(ValueError):pack_frame_into(np.zeros(12,dtype=np.uint32),hsv,gate,1)
        with self.assertRaises(ValueError):pack_frame(np.zeros((2,3),dtype=np.uint8),gate,1)
        with self.assertRaises(ValueError):pack_frame(hsv,gate,-1)


if __name__=='__main__':unittest.main()
