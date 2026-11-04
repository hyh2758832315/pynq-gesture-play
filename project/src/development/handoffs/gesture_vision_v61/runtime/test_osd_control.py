import unittest
from osd_control import HandOSDControl


class FakeMMIO:
    def __init__(self): self.regs={0:0x484f5301,4:0};self.writes=[]
    def read(self, addr): return self.regs.get(addr,0)
    def write(self, addr, value):
        self.writes.append((addr,value));self.regs[addr]=value
        if addr==8: self.regs[4]=1


class ControlTests(unittest.TestCase):
    def test_publish(self):
        mmio=FakeMMIO();ctrl=HandOSDControl(mmio)
        ctrl.publish(dict(enable=1,bbox_valid=1,centroid_valid=1,state=3,
                          x0=10,y0=20,x1=100,y1=200,cx=50,cy=60,result_frame_id=7))
        self.assertEqual(mmio.writes,[(16,31),(20,20<<16|10),
                                     (24,200<<16|100),(28,60<<16|50),(32,7),(8,1)])
    def test_busy_timeout_does_not_write(self):
        mmio=FakeMMIO();ctrl=HandOSDControl(mmio);mmio.regs[4]=1
        with self.assertRaises(TimeoutError): ctrl.disable(timeout=0)
        self.assertEqual(mmio.writes,[])
    def test_bad_id(self):
        mmio=FakeMMIO();mmio.regs[0]=0
        with self.assertRaises(ValueError): HandOSDControl(mmio)
    def test_disable(self):
        mmio=FakeMMIO();HandOSDControl(mmio).disable()
        self.assertEqual(mmio.writes,[(16,0),(20,0),(24,0),(28,0),(32,0),(8,1)])
    def test_reject_invalid_before_write(self):
        mmio=FakeMMIO();ctrl=HandOSDControl(mmio)
        with self.assertRaises(ValueError):
            ctrl.publish(dict(enable=1,bbox_valid=1,centroid_valid=1,state=4,
                              x0=0,y0=0,x1=100,y1=100,cx=50,cy=50,result_frame_id=7))
        self.assertEqual(mmio.writes,[])
