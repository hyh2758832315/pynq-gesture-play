from types import SimpleNamespace
import pytest
import preview_schedule as policy


class Base:
    """Deterministic equivalent of base admission/success rate bookkeeping."""
    def __init__(self):
        self._due = {'debug':0.,'video':0.}
        self._rates = {'debug':5.,'video':10.}
        self.demand = {'debug'}
        self.healthy = True
        self.fail = False
        self.frames = []
    def due_modes(self, now=None):
        return frozenset(m for m in self.demand if self.healthy and now>=self._due[m])
    def submit(self, factory, *, now=None):
        modes = self.due_modes(now=now)
        if not modes or self.fail:
            return False
        snap = factory(modes)
        if not snap.modes:
            return False
        self.frames.append(snap.frame)
        for mode in snap.modes:
            self._due[mode] = now+1/self._rates[mode]
        return True


def test_220ms_inference_does_not_force_every_other_frame(monkeypatch):
    clock = [0.]
    monkeypatch.setattr(policy.time,'monotonic',lambda:clock[0])
    obj = policy.scheduled_encoder(Base)()
    for frame in range(10):
        clock[0] = frame*.22
        modes = obj.due_modes()
        clock[0] += .22
        assert obj.submit(lambda requested:SimpleNamespace(frame=frame,modes=modes & requested))
    assert obj.frames==list(range(10))


def test_fast_inference_keeps_rate_ceiling_and_no_catchup(monkeypatch):
    clock = [0.]
    monkeypatch.setattr(policy.time,'monotonic',lambda:clock[0])
    obj = policy.scheduled_encoder(Base)()
    accepted = []
    for index in range(101):
        clock[0] = index*.01
        modes = obj.due_modes()
        clock[0] += .005
        if obj.submit(lambda requested:SimpleNamespace(frame=index,modes=modes & requested)):
            accepted.append(index*.01)
    assert len(accepted)<=6
    assert all(b-a>=.2-1e-9 for a,b in zip(accepted,accepted[1:]))
    clock[0]=100
    obj.due_modes()
    assert obj.submit(lambda modes:SimpleNamespace(frame=999,modes=modes))
    assert not obj.submit(lambda modes:pytest.fail('No stale reservation'))


@pytest.mark.parametrize('failure',('health','unsubscribed','slot','empty'))
def test_failure_does_not_advance_deadline_or_reuse_reservation(monkeypatch,failure):
    monkeypatch.setattr(policy.time,'monotonic',lambda:1.)
    obj = policy.scheduled_encoder(Base)()
    obj.due_modes()
    if failure=='health': obj.healthy=False
    if failure=='unsubscribed': obj.demand.clear()
    if failure=='slot': obj.fail=True
    assert not obj.submit(lambda modes:SimpleNamespace(frame=1,modes=frozenset() if failure=='empty' else modes))
    assert obj._due=={'debug':0.,'video':0.}
    assert not obj.submit(lambda _:pytest.fail('Reservation consumed'))


def test_modes_are_independent_and_late_subscriber_not_backdated(monkeypatch):
    clock = [1.]
    monkeypatch.setattr(policy.time,'monotonic',lambda:clock[0])
    obj = policy.scheduled_encoder(Base)()
    captured = obj.due_modes()
    obj.demand.add('video')
    clock[0]=1.3
    assert obj.submit(lambda modes:SimpleNamespace(frame=1,modes=captured & modes))
    assert obj._due['debug']==1.2 and obj._due['video']==0
    obj.due_modes()
    assert obj.submit(lambda modes:SimpleNamespace(frame=2,modes=modes))
    assert obj._due['debug']==1.5 and obj._due['video']==pytest.approx(1.4)


def encode_probe(snapshot, mode):
    return b'probe'


def test_real_spawn_encoder_uses_capture_clock_and_cleans_up():
    from threading import Event
    import time
    from pynq_multimodal_game.vision_preview import ProcessPreviewEncoder, PreviewSnapshot
    received = Event()
    encoder = policy.scheduled_encoder(ProcessPreviewEncoder)(
        lambda:frozenset({'debug'}),encode_probe,lambda *args:received.set(),startup_timeout=30)
    try:
        modes = encoder.due_modes()
        anchor = encoder._capture_at
        time.sleep(.22)  # representative inference time, control would publish first
        assert encoder.submit(lambda requested:PreviewSnapshot(1,modes & requested,None,None,None))
        assert encoder._due['debug']==pytest.approx(anchor+.2)
        assert received.wait(5)
        assert encoder.due_modes()==frozenset({'debug'})
        assert encoder.stats()['errors']==0
    finally:
        encoder.close()
    assert encoder.health().status=='CLOSED'
