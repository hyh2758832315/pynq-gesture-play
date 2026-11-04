"""Status snapshot budget capped by the EXISTING enclosing poll deadline.

No status fields/checks removed, no cached ownership/snapshot, no retry/reset.
The10ms stage ceiling cannot enlarge a15ms poll, or the50ms service gap.
"""
import math
import time

def build_reader(binding_module):
    base=binding_module.VoiceStatusReader

    class CoordinatedStatusReader(base):
        stage_ceiling_seconds=.010
        def snapshot(self):
            provider=getattr(self,'enclosing_deadline',None)
            if not callable(provider):
                self.failed=True
                raise binding_module.DmaFault('Snapshot missing enclosing deadline')
            remaining=provider()-self.clock()
            if not math.isfinite(remaining) or remaining<=0:
                self.failed=True
                raise binding_module.DmaFault('Enclosing snapshot deadline expired')
            old_timeout=self.timeout
            old_poll_interval=self.poll_interval
            self.timeout=min(self.stage_ceiling_seconds,remaining)
            self.poll_interval=min(old_poll_interval,self.timeout)
            begun=self.clock()
            cpu=time.thread_time()
            try:
                return super().snapshot()
            finally:
                self.last_wall_ms=(self.clock()-begun)*1000
                self.last_thread_cpu_ms=(time.thread_time()-cpu)*1000
                self.calls=getattr(self,'calls',0)+1
                self.max_wall_ms=max(getattr(self,'max_wall_ms',0),self.last_wall_ms)
                self.timeout=old_timeout
                self.poll_interval=old_poll_interval

    return CoordinatedStatusReader
