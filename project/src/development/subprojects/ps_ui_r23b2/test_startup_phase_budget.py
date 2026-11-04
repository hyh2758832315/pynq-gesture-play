"""Separate slow optional codec preparation from real camera first-frame time."""
from threading import Event
import pytest
from pynq_multimodal_game import startup_checks as module


def test_codec_warmup_cannot_spend_camera_first_frame_budget(monkeypatch):
    clock=[0.];events=[]
    class ClockEvent:
        def is_set(self):return False
        def wait(self,seconds):clock[0]+=seconds;return False
    class Supervisor:
        prepared=False;stopped=False;polls=0
        def prepare(self):
            events.append('codec');clock[0]+=20.21;self.prepared=True
        def start(self):
            # Reproduce the original worker doing synchronous codec warmup
            # before sensor startup when the owner did not prepare it first.
            if not self.prepared:self.prepare()
            events.append('camera');return self.status()
        def status(self):
            self.polls+=1
            return dict(state='RUNNING',frame_id=int(self.polls>1),owner_held=True,last_error=None,
                input_capabilities=dict(schema='local-game-vision-v1',mode='games',games=['game1','game2','game3']))
        def stop(self):self.stopped=True;return dict(cleanup_confirmed=True)
    monkeypatch.setattr(module,'monotonic',lambda:clock[0])
    supervisor=Supervisor()
    assert module.start_vision_until_ready(supervisor,timeout_seconds=20,stop_event=ClockEvent()) is True
    assert events==['codec','camera'] and not supervisor.stopped


@pytest.mark.parametrize('failure',['prepare','cancel'])
def test_prepare_failure_or_cancellation_never_starts_camera(failure):
    cancelled=Event();events=[]
    class Supervisor:
        def prepare(self):
            events.append('prepare')
            if failure=='prepare':raise RuntimeError('codec init failed')
            cancelled.set()
        def start(self):raise AssertionError('must not start hardware')
        def stop(self):events.append('stop');return dict(cleanup_confirmed=True)
    with pytest.raises(RuntimeError,match='codec init failed|cancelled'):
        module.start_vision_until_ready(Supervisor(),stop_event=cancelled)
    assert events==['prepare','stop']
