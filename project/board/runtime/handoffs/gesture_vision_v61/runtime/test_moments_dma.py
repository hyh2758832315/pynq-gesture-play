import unittest
import numpy as np
from moments_dma import pack_frame, decode_reply, MAGIC, MomentsDMA


class CodecTests(unittest.TestCase):
    def test_pack(self):
        hsv=np.array([[[20,20,70],[21,255,255]]],dtype=np.uint8)
        words=pack_frame(hsv,np.array([[1,0]]),27)
        self.assertEqual(words.tolist(),[MAGIC,65538,27,0xff141400,0xff46,0x01461414,0x00ffff15])

    def test_decode(self):
        words=np.array([255,255,MAGIC,2,1,0,0,0,27,0],dtype=np.uint32)
        mask,result=decode_reply(words,2,1,27)
        self.assertEqual(mask.tolist(),[[255,255]])
        self.assertEqual(result['centroid'],(0.5,0.0))
        for index,value in [(2,0),(8,28),(9,1),(0,128)]:
            bad=words.copy();bad[index]=value
            with self.assertRaises(ValueError):decode_reply(bad,2,1,27)

    def test_invalid_inputs(self):
        hsv=np.zeros((2,3,3),dtype=np.uint8)
        with self.assertRaises(ValueError):pack_frame(hsv,np.ones((3,2)),1)
        with self.assertRaises(ValueError):pack_frame(hsv,np.ones((2,3)),1,(0,180,0,255,0,255))

    def test_halt_retains_buffers_on_failure(self):
        class MMIO:
            def read(self,o):return 0
            def write(self,o,v):pass
        driver=MomentsDMA.__new__(MomentsDMA)
        driver.dma=MMIO();driver.timeout=.001;driver._buffers=[object()]
        with self.assertRaises(TimeoutError):driver.close()
        self.assertEqual(len(driver._buffers),1)

    def test_halt_precedes_wrapper_reset(self):
        events=[]
        class MMIO:
            def read(self,o):return 1 if o in (4,0x34) else 0
            def write(self,o,v):events.append(('dma',o,v))
        class Reset:
            def write(self,o,v):events.append(('gpio',o,v))
        driver=MomentsDMA.__new__(MomentsDMA)
        driver.dma=MMIO();driver.reset=Reset();driver.timeout=.01
        driver.recover()
        self.assertEqual(events[:3],[('dma',0,0),('dma',0x30,0),('gpio',0,0)])


if __name__=='__main__':unittest.main()
