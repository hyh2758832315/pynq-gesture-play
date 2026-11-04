"""Scoped startup/stop budget only; no recognition or live health changes."""
import math


def build_types(binding_module, driver_base, *, status_reader_type=None, control_ceiling=.020):
    if type(control_ceiling) not in (float,int) or not math.isfinite(control_ceiling) or not 0<control_ceiling<=.05:
        raise ValueError('Capture control ceiling must be <=50ms')
    original = binding_module.CaptureBinding
    Fault = binding_module.DmaFault

    class ControlBinding(original):
        control_budget_seconds=control_ceiling
        def set_capture(self, enabled):
            if type(enabled) is not bool:
                raise ValueError('literal bool required')
            if not self.lock.acquire(blocking=False):
                raise Fault('concurrent capture operation')
            begun = self.clock()
            try:
                provider = getattr(self, 'control_outer_deadline', None)
                if not callable(provider):
                    raise Fault('control budget requires enclosing driver deadline')
                outer = provider()
                if not isinstance(outer,(int,float)) or not math.isfinite(outer) or outer<=begun:
                    raise Fault('enclosing driver deadline expired')
                deadline = min(begun+self.control_budget_seconds,outer)
                self.control_deadline = deadline
                self.identity()
                if enabled:
                    if self.failed or self.ever_enabled or not self.stopped():
                        raise Fault('new stopped capture session required')
                    old_epoch = self.read(0x30)
                self.write(0x28,int(enabled))
                for _ in range(1024):
                    if self.clock()>=deadline:
                        raise Fault('capture acknowledgement deadline')
                    request,live=self.read(0x28),self.read(0x2c)
                    if enabled and live&4:
                        raise Fault('capture fault while starting')
                    if request==int(enabled) and live==(3 if enabled else 0):
                        if self.clock()>=deadline:
                            raise Fault('capture readback exceeded deadline')
                        if enabled:
                            self.hardware_epoch=self.read(0x30)
                            self._time_check()
                            if self.hardware_epoch != (old_epoch+1)&0xffffffff:
                                raise Fault('unexpected capture hardware epoch')
                            self.ever_enabled=True
                            # Health retains original5ms timeout and all checks.
                            reader_type=status_reader_type or binding_module.VoiceStatusReader
                            self.reader=reader_type(self._snapshot_read,self.write,
                                epoch=binding_module.uuid.uuid4().hex,clock=self.clock,sleep=self.sleep,
                                timeout=self.timeout,poll_interval=min(.0001,self.timeout))
                            if status_reader_type is not None:
                                self.reader.enclosing_deadline=self.control_outer_deadline
                                self.reader.enclosing_execution_check=getattr(self,'control_execution_check',None)
                        else:
                            self.reader=None
                        self._time_check()
                        return
                    self.sleep(.00001)
                raise Fault('capture acknowledgement poll ceiling')
            except Exception:
                self.failed=True
                raise
            finally:
                self.control_elapsed_ms=(self.clock()-begun)*1000
                self.control_deadline=None
                self.lock.release()

    class ControlDriver(driver_base):
        def __init__(self,*args,**kwargs):
            super().__init__(*args,**kwargs)
            binding=getattr(self.set_capture,'__self__',None)
            if type(binding) is not ControlBinding:
                raise Fault('control binding identity mismatch')
            binding.control_outer_deadline=lambda:self.deadline
            binding.control_execution_check=getattr(self,'_check_execution',None)

    return ControlBinding,ControlDriver
