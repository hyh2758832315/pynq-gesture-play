"""C0E STOP reset ordering; no hardware, buffers or DMA transfers."""
from types import SimpleNamespace

import pytest


@pytest.mark.parametrize('fault',(None,'pool','rgb-running','packet-error','reset-readback'))
def test_common_reset_is_asserted_only_after_drain_and_halted_dma(fault):
    import vision_async_runtime as runtime
    log=[]
    reset_value=1

    class Registers:
        def __init__(self,name):self.name=name
        def read(self,offset):
            log.append(('read',self.name,offset))
            if self.name=='moments_reset':return 1 if fault=='reset-readback' else reset_value
            if offset==0x30:return int(fault=='rgb-running' and self.name=='frame_dma')
            assert offset==0x34
            return (1 if self.name=='frame_dma' else 9) | (0x10 if fault=='packet-error' and self.name=='moments_dma' else 0)
        def write(self,offset,value):
            nonlocal reset_value
            log.append(('write',self.name,offset,value))
            assert self.name=='moments_reset' and offset==0 and value==0
            reset_value=value

    def drain(_):
        log.append('drained')
        if fault=='pool':raise RuntimeError('drain not proven')
    hardware=runtime.SharedDualMaskHardware.__new__(runtime.SharedDualMaskHardware)
    hardware.state,hardware.error='RUNNING',None
    hardware.drain_consumer=lambda _:None
    hardware.pool=SimpleNamespace(stop=drain)
    hardware.demosaic=SimpleNamespace(write=lambda *args:log.append(('demosaic-stop',*args)))
    hardware.lease=SimpleNamespace(mmio=lambda name:Registers(name),close=lambda:log.append('closed'))
    if fault:
        with pytest.raises(RuntimeError):hardware.stop()
        assert hardware.state=='RETAINED'
        assert 'closed' not in log
        if fault!='reset-readback':assert not any(isinstance(item,tuple) and item[:2]==('write','moments_reset') for item in log)
    else:
        hardware.stop()
        assert hardware.state=='STOPPED' and reset_value==0
        reset=log.index(('write','moments_reset',0,0))
        assert log.index('drained')<log.index(('read','frame_dma',0x34))<reset
        assert log.index(('read','moments_dma',0x34))<reset<log.index('closed')
