"""Fault injection for the optional codec, no serial/camera/GPU access."""
from types import SimpleNamespace
from threading import Event,Thread
import time
from pynq_multimodal_game.preview_recovery import RecoverablePreviewEncoder
from pynq_multimodal_game.vision_preview import PreviewHealth


class Codec:
    def __init__(self,healthy=True):
        self.healthy=healthy;self.release_confirmed=False;self.close_calls=0;self.can_close=True
        self._sequence=0;self._received_sequence=0
    def health(self):return PreviewHealth('RUNNING' if self.healthy else 'DEGRADED',
        self.healthy,self.healthy,1,None,'test fault','RETAINED')
    def close(self):
        self.close_calls+=1
        if not self.can_close:raise RuntimeError('old codec still alive')
        self.release_confirmed=True
    def due_modes(self):return frozenset({'video'})
    def submit(self,*args,**kwargs):return True
    submit_deferred=submit
    def idle(self):return True
    def stats(self):return {}


def until(predicate,timeout=2):
    deadline=time.monotonic()+timeout
    while time.monotonic()<deadline:
        if predicate():return
        time.sleep(.005)
    assert predicate()


def test_codec_death_rebuilds_one_owner_and_keeps_submissions_nonblocking():
    old=Codec(False);new=Codec();made=[]
    def factory(recovering):
        made.append(recovering);return new if recovering else old
    encoder=RecoverablePreviewEncoder(factory,backoff=.01)
    try:
        assert not encoder.health().healthy
        assert not encoder.submit(lambda _:None)
        until(lambda:encoder.health().healthy)
        assert encoder.due_modes()==frozenset({'video'})
        assert made==[False,True] and old.release_confirmed and old.close_calls==1
    finally:encoder.close()
    assert new.release_confirmed and encoder.release_confirmed


def test_unknown_old_cleanup_never_creates_parallel_codec():
    old=Codec(False);old.can_close=False;made=[]
    def factory(recovering):made.append(recovering);return Codec() if recovering else old
    encoder=RecoverablePreviewEncoder(factory,backoff=.01)
    try:
        encoder.health();until(lambda:old.close_calls>=2)
        assert made==[False] and not encoder.health().healthy
        old.can_close=True;until(lambda:encoder.health().healthy)
        assert made==[False,True]
    finally:encoder.close()


def test_startup_failure_retains_unknown_owner_until_release():
    old=Codec(False);old.can_close=False;made=[]
    def factory(recovering):
        made.append(recovering)
        if not recovering:
            error=RuntimeError('startup failed with unknown release');error.preview_owner=old;raise error
        return Codec()
    encoder=RecoverablePreviewEncoder(factory,backoff=.01)
    try:
        encoder.health();until(lambda:old.close_calls>=1)
        assert made==[False]
        old.can_close=True;until(lambda:encoder.health().healthy)
    finally:encoder.close()


def test_shutdown_during_rebuild_closes_the_late_new_codec():
    old=Codec(False);new=Codec();building=Event();release=Event()
    def factory(recovering):
        if not recovering:return old
        building.set();assert release.wait(2);return new
    encoder=RecoverablePreviewEncoder(factory,backoff=.01);encoder.health()
    assert building.wait(2)
    errors=[]
    def close():
        try:encoder.close()
        except Exception as error:errors.append(str(error))
    closer=Thread(target=close);closer.start();release.set();closer.join(2)
    assert not closer.is_alive() and not errors
    assert old.release_confirmed and new.release_confirmed and encoder.release_confirmed


def test_live_but_stalled_codec_is_rebuilt_without_resetting_camera(monkeypatch):
    old=Codec();old._sequence=1;new=Codec();clock=[0.]
    monkeypatch.setattr('pynq_multimodal_game.preview_recovery.time.monotonic',lambda:clock[0])
    encoder=RecoverablePreviewEncoder(lambda recovering:new if recovering else old,backoff=.01,stall_timeout=8)
    try:
        assert encoder.health().healthy
        clock[0]=9
        assert not encoder.health().healthy
        # Event-based wait; fake monotonic is only the codec-stall clock.
        deadline=time.perf_counter()+2
        while not new.release_confirmed and time.perf_counter()<deadline:
            if encoder.health().healthy:break
            Event().wait(.005)
        assert encoder.health().healthy and old.release_confirmed
    finally:encoder.close()


def broken_encode(_snapshot,_mode):raise RuntimeError('injected JPEG failure')
def good_encode(_snapshot,_mode):return b'fresh-jpeg'


def test_repeated_real_codec_failures_recover_without_restarting_producer():
    from pynq_multimodal_game.vision_preview import ProcessPreviewEncoder,PreviewSnapshot
    published=[];owners=[]
    def factory(recovering):
        if recovering:assert all(p.release_confirmed for p in owners)
        codec=ProcessPreviewEncoder(lambda:frozenset({'video'}),
            good_encode if recovering else broken_encode,
            lambda mode,payload:published.append(payload),startup_timeout=10)
        codec.unlimited=True;owners.append(codec);return codec
    encoder=RecoverablePreviewEncoder(factory,backoff=.02)
    frame=0;deadline=time.monotonic()+10
    try:
        while not published and time.monotonic()<deadline:
            frame+=1
            if encoder.health().healthy:
                encoder.submit(lambda modes:PreviewSnapshot(frame,modes,None,{},{}))
            time.sleep(.01)
        assert published and published[0]==b'fresh-jpeg'
        assert len(owners)==2 and owners[0].release_confirmed
        assert frame>3 and encoder.health().healthy
    finally:encoder.close()
    assert encoder.release_confirmed and all(o.release_confirmed for o in owners)
