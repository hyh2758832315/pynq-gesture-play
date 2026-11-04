"""Recover the optional CPU-only preview codec without stopping recognition."""
from threading import Event,Lock,Thread
import time
from .vision_preview import PreviewHealth


class RecoverablePreviewEncoder:
    def __init__(self,factory,*,backoff=2.,stall_timeout=8.):
        self._factory=factory;self._backoff=backoff;self._stall_timeout=stall_timeout
        self._lock=Lock();self._stop=Event();self._encoder=None;self._repair_thread=None
        self._repairing=False;self._reason='';self._attempts=0
        self._recovery_delay=backoff
        self._progress=None;self._progress_at=None
        try:self._encoder=factory(False)
        except Exception as error:
            self._reason=str(error);self._encoder=getattr(error,'preview_owner',None)

    def health(self):
        if not self._lock.acquire(False):
            return PreviewHealth('RECOVERING',False,False,None,None,self._reason,'RETAINED')
        try:
            encoder=self._encoder
            if self._stop.is_set():
                return PreviewHealth('CLOSED' if encoder is None else 'STOPPING',False,False,
                    None,None,self._reason,'CLEAN' if encoder is None else 'RETAINED')
            health=encoder.health() if encoder is not None else None
            stalled=False
            if health is not None and health.healthy:
                if getattr(encoder,'_stats',{}).get('encoded',0)>=30:
                    self._recovery_delay=self._backoff
                now=time.monotonic();received=getattr(encoder,'_received_sequence',0)
                if getattr(encoder,'_sequence',0)>received:
                    if self._progress_at is None or received!=self._progress:
                        self._progress,self._progress_at=received,now
                    stalled=now-self._progress_at>self._stall_timeout
                else:self._progress_at=None
                if not stalled and not self._repairing:return health
            if health is not None and not self._repairing:
                self._reason='preview codec stalled' if stalled else health.reason
            if not self._repairing:
                self._repairing=True
                self._repair_thread=Thread(target=self._repair,name='preview-recovery',daemon=True)
                self._repair_thread.start()
            return PreviewHealth('RECOVERING',False,False,None,None,self._reason,'RETAINED')
        finally:self._lock.release()

    def _repair(self):
        delay=self._recovery_delay
        try:
            while not self._stop.wait(delay):
                with self._lock:
                    old,self._encoder=self._encoder,None
                if old is not None:
                    try:old.close()
                    except Exception as error:self._reason=str(error)
                    if getattr(old,'release_confirmed',False) is not True:
                        with self._lock:self._encoder=old
                        delay=min(30.,max(self._backoff,delay*2));continue
                if self._stop.is_set():return
                try:
                    self._attempts+=1
                    new=self._factory(True)
                except Exception as error:
                    self._reason=str(error)
                    with self._lock:self._encoder=getattr(error,'preview_owner',None)
                    delay=min(30.,max(self._backoff,delay*2));continue
                with self._lock:
                    self._encoder=new;self._progress_at=None;self._reason=''
                    self._recovery_delay=min(30.,max(self._backoff,delay*2))
                return
        finally:
            with self._lock:self._repairing=False

    def _call(self,name,*args,default=False,**kwargs):
        if self._stop.is_set() or not self._lock.acquire(False):return default
        try:
            if self._encoder is None or self._repairing:return default
            return getattr(self._encoder,name)(*args,**kwargs)
        finally:self._lock.release()

    def due_modes(self,*args,**kwargs):
        return self._call('due_modes',*args,default=frozenset(),**kwargs) if self.health().healthy else frozenset()

    def submit(self,*args,**kwargs):return self._call('submit',*args,**kwargs)
    def submit_deferred(self,*args,**kwargs):return self._call('submit_deferred',*args,**kwargs)
    def idle(self):return self._call('idle')
    def stats(self):
        health=self.health()
        return dict(self._call('stats',default={}),health=health.__dict__,recovery_attempts=self._attempts)

    @property
    def release_confirmed(self):
        return self._stop.is_set() and self._encoder is None and not self._repairing

    def close(self):
        self._stop.set()
        thread=self._repair_thread
        if thread is not None:
            thread.join(15)
            if thread.is_alive():raise RuntimeError('preview recovery still owns codec; retained')
        with self._lock:
            old,self._encoder=self._encoder,None
        if old is not None:
            try:old.close()
            except Exception as error:self._reason=str(error)
            if getattr(old,'release_confirmed',False) is not True:
                with self._lock:self._encoder=old
                raise RuntimeError('preview codec release unconfirmed; retained')
