"""Single-writer PYNQ MMIO publisher. Does not load an overlay.

Hardware register bank: ID=0x00, busy=0x04, commit=0x08;
shadow flags/x0y0/x1y1/cxcy/result_id=0x10..0x20.
Commit acknowledgement means applied at video SOF (requires flowing video).
"""
import time


class HandOSDControl:
    def __init__(self, mmio):
        self.mmio = mmio
        if mmio.read(0) != 0x484f5301:
            raise ValueError("Not a compatible hand OSD register bank")

    @property
    def busy(self):
        return bool(self.mmio.read(4) & 1)

    def wait_idle(self, timeout=0.2):
        end = time.monotonic() + timeout
        while self.busy:
            if time.monotonic() >= end:
                raise TimeoutError("OSD commit pending: check video SOF and both resets")
            time.sleep(0.001)

    def publish(self, metadata, timeout=0.2, wait_applied=False):
        # Validate everything BEFORE any register write.
        widths = dict(enable=1,bbox_valid=1,centroid_valid=1,state=2,
                      x0=16,y0=16,x1=16,y1=16,cx=16,cy=16,result_frame_id=32)
        vals = {}
        for key, width in widths.items():
            value = metadata[key]
            if not isinstance(value, int) or isinstance(value,bool) or not 0<=value<1<<width:
                raise ValueError("Invalid metadata field: " + key)
            vals[key]=value
        flags=vals['enable'] | vals['bbox_valid']<<1 | vals['centroid_valid']<<2 | vals['state']<<3
        words=[flags, vals['x0'] | vals['y0']<<16,
               vals['x1'] | vals['y1']<<16, vals['cx'] | vals['cy']<<16,
               vals['result_frame_id']]
        self.wait_idle(timeout)
        for index, word in enumerate(words):
            self.mmio.write(0x10+4*index, word)
        self.mmio.write(8,1)
        if wait_applied:
            self.wait_idle(timeout)

    def disable(self, timeout=0.2, wait_applied=False):
        self.publish(dict(enable=0,bbox_valid=0,centroid_valid=0,state=0,
                          x0=0,y0=0,x1=0,y1=0,cx=0,cy=0,result_frame_id=0),
                     timeout, wait_applied)
