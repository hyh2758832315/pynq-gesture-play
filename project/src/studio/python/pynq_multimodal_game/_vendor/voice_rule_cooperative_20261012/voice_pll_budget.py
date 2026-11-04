"""Scoped PLL readiness read budget, no retry/reset or Codec profile writes."""
import math
import time

def build_types(iic_module,driver_base, *, stage_ceiling=.025):
    if type(stage_ceiling) not in (float,int) or not math.isfinite(stage_ceiling) or not 0<stage_ceiling<=.05:
        raise ValueError('PLL stage ceiling must be <=50ms')
    original=iic_module.VoiceAxiIIC

    class StartupIIC(original):
        def read(self,register,length,timeout):
            # Only the original six-byte PLL readiness query using10ms.
            if (register,length,timeout)!=(0x4002,6,.01):
                return super().read(register,length,timeout)
            budget=stage_ceiling
            provider=getattr(self,'pll_outer_deadline',None)
            if provider is not None:
                remaining=provider()-self.clock()
                if not math.isfinite(remaining) or remaining<=0:
                    self.failed=True
                    raise iic_module.IICFault('PLL enclosing startup deadline expired')
                budget=min(budget,remaining)
            begun=self.clock()
            cpu=time.thread_time()
            try:
                return super().read(register,length,budget)
            finally:
                # Evidence only; no extra hardware reads or bus retries.
                self.pll_last_wall_ms=(self.clock()-begun)*1000
                self.pll_last_thread_cpu_ms=(time.thread_time()-cpu)*1000

    class StartupDriver(driver_base):
        def __init__(self,*args,**kwargs):
            super().__init__(*args,**kwargs)
            closure=getattr(self.codec_ready,'__closure__',None) or ()
            matches=[c.cell_contents for c in closure if type(c.cell_contents) is StartupIIC]
            if len(matches)!=1:
                raise iic_module.IICFault('PLL transport identity mismatch')
            self.pll_transport=matches[0]
            matches[0].pll_outer_deadline=lambda:self.deadline

    return StartupIIC,StartupDriver
