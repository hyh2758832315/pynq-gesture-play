"""Separate execution budget from source-safety wall time on non-RT Linux.

15ms is CPU work ceiling, not a guarantee the OS never pauses the thread.
The ORIGINAL50ms source service/stall limit is still a hard wall deadline.
No packet on owner/epoch/sequence/PCM/drop/DMA faults, no cached health/retry.
"""
import math
import time
import threading

def build_driver(driver_base, *, thread_clock=time.thread_time):
    class CooperativeDriver(driver_base):
        cooperative_timing=True
        def __init__(self,*args,**kwargs):
            self._scope_lock=threading.Lock()
            super().__init__(*args,**kwargs)

        def _in_receive_thread(self):
            return (getattr(self,'_receive_scope',False)
                    and getattr(self,'_receive_thread',None)==threading.get_ident())

        def _check_execution(self):
            if (self._in_receive_thread()
                    and thread_clock()>=self.execution_deadline):
                raise RuntimeError('Receive CPU execution budget exceeded')

        def _begin(self,timeout):
            if self._in_receive_thread():
                # Fixed existing service safety limit; never extend per call.
                cpu=thread_clock()
                super()._begin(.05)
                self._poll_started=True
                self.execution_deadline=cpu+timeout
            else:
                super()._begin(timeout)

        def _call(self,callback,*args):
            self._check_execution()
            result=super()._call(callback,*args)
            self._check_execution()
            return result

        def poll_packet(self,timeout=.015):
            if timeout!=.015:
                raise ValueError('Cooperative receive requires15ms CPU budget')
            if not hasattr(self,'_scope_lock'):
                self._scope_lock=threading.Lock() # Offline model class replacement.
            if not self._scope_lock.acquire(blocking=False):
                raise RuntimeError('Concurrent cooperative receive')
            self._receive_scope=True
            self._receive_thread=threading.get_ident()
            self._poll_started=False
            begun=self.clock(); cpu=thread_clock()
            try:
                result=super().poll_packet(timeout=timeout)
                self._check_execution()
                if self.clock()-begun>=.05:
                    raise RuntimeError('Receive hard wall deadline exceeded')
                return result
            except Exception as exc:
                if self._poll_started:
                    self._fail(exc)
                raise
            finally:
                self.last_poll_cpu_ms=(thread_clock()-cpu)*1000
                self.last_poll_wall_ms=(self.clock()-begun)*1000
                self.max_poll_cpu_ms=max(getattr(self,'max_poll_cpu_ms',0),self.last_poll_cpu_ms)
                self.max_poll_wall_ms=max(getattr(self,'max_poll_wall_ms',0),self.last_poll_wall_ms)
                self._receive_scope=False
                self._receive_thread=None
                self._scope_lock.release()

    return CooperativeDriver

def build_reader(binding_module):
    base=binding_module.VoiceStatusReader
    class CooperativeReader(base):
        stage_ceiling_seconds=.05
        def _execution_check(self):
            guard=getattr(self,'enclosing_execution_check',None)
            if not callable(guard):
                raise binding_module.DmaFault('Missing receive execution guard')
            guard()

        def _read(self,offset):
            self._execution_check()
            result=super()._read(offset)
            self._execution_check()
            return result

        def snapshot(self):
            provider=getattr(self,'enclosing_deadline',None)
            if not callable(provider):
                self.failed=True
                raise binding_module.DmaFault('Missing enclosing snapshot deadline')
            remaining=provider()-self.clock()
            if not math.isfinite(remaining) or remaining<=0:
                self.failed=True
                raise binding_module.DmaFault('Snapshot enclosing deadline expired')
            old_timeout,old_sleep,old_write=self.timeout,self.sleep,self.write32
            self.timeout=min(.05,remaining)
            begun=self.clock(); cpu=time.thread_time()
            def write(offset,value):
                self._execution_check()
                result=old_write(offset,value)
                self._execution_check()
                return result
            def no_sleep(_):
                # Already bounded by original1024 polls and both deadlines.
                self._execution_check()
            self.write32,self.sleep=write,no_sleep
            try:
                return super().snapshot()
            finally:
                self.last_wall_ms=(self.clock()-begun)*1000
                self.last_thread_cpu_ms=(time.thread_time()-cpu)*1000
                self.calls=getattr(self,'calls',0)+1
                self.max_wall_ms=max(getattr(self,'max_wall_ms',0),self.last_wall_ms)
                self.timeout,self.sleep,self.write32=old_timeout,old_sleep,old_write
    return CooperativeReader
