"""Offline ownership barriers and pacing; no hardware or external processes."""
from dataclasses import replace
import threading
from types import SimpleNamespace

import pytest

from pynq_multimodal_game.agent import c6i_shell
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend, ShellMode
from pynq_multimodal_game.agent.core import AgentState


class Sink:
    def __init__(self):
        self.closed = False
        self.writes = 0
    def close(self): self.closed = True
    def upload_asset(self, packet): self.writes += 1
    def upload_palette(self, packet): self.writes += 1
    def upload_tilemap(self, packet): self.writes += 1
    def submit_scene(self, packet): self.writes += 1


def shell(**kwargs):
    result = C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000),
                                   timeout_seconds=.01, menu_fps=0, **kwargs)
    result._sink = Sink()
    return result


@pytest.mark.parametrize("attribute", ["_startup_animation_thread", "_return_monitor_thread"])
def test_close_retains_sink_until_all_borrowers_exit(attribute):
    value = shell()
    sink = value._sink
    release = threading.Event()
    worker = threading.Thread(target=release.wait)
    setattr(value, attribute, worker)
    worker.start()
    try:
        with pytest.raises(RuntimeError, match="did not stop"):
            value.close()
        assert value._sink is sink and not sink.closed
        assert getattr(value, attribute) is worker
    finally:
        release.set()
        worker.join(2)
        value.close()
    assert sink.closed and value._sink is None


def test_close_preserves_first_error_when_later_cleanup_also_fails(monkeypatch):
    value = shell()
    first = RuntimeError("initial loading cleanup failure")
    def fail_first(): raise first
    def fail_second(): raise RuntimeError("secondary menu cleanup failure")
    monkeypatch.setattr(value, "_stop_startup_animation", fail_first)
    monkeypatch.setattr(value, "_stop_menu", fail_second)
    with pytest.raises(RuntimeError) as raised:
        value.close()
    assert raised.value is first


def test_video_failed_stop_does_not_transfer_gpu_to_menu():
    value = shell()
    sink = value._sink
    value._mode = ShellMode.VIDEO
    failed = replace(value._video.snapshot, state=AgentState.ERROR,
                     last_error="video worker still busy")
    value._video = SimpleNamespace(stop=lambda: failed, snapshot=failed, _thread=None)
    with pytest.raises(RuntimeError, match="video worker still busy"):
        value.return_to_menu()
    assert value.mode is ShellMode.VIDEO
    assert sink.writes == 0 and not sink.closed


def test_game_cleanup_failure_retains_owner_for_explicit_retry():
    value = shell()
    sink = value._sink
    calls = []
    def stop():
        calls.append("stop")
        if len(calls) == 1:
            raise RuntimeError("preview process did not stop")
    game = SimpleNamespace(stop=stop, _thread=None, running=False)
    value._game = game
    with pytest.raises(RuntimeError, match="preview process did not stop"):
        value.close()
    assert value._game is game and value._sink is sink and not sink.closed
    value.close()
    assert calls == ["stop", "stop"]
    assert value._game is None and sink.closed


def test_menu_overrun_does_not_busy_catch_up(monkeypatch):
    value = shell()
    value._menu_fps = 30
    value._menu_active = True
    value._menu_thread = threading.current_thread()
    clock = [0.]
    waits = []
    class ScheduledStop:
        def wait(self, timeout):
            waits.append(timeout)
            clock[0] += timeout
            return len(waits) >= 6
        def set(self): pass
    value._menu_stop = ScheduledStop()
    calls = []
    def draw():
        calls.append(clock[0])
        if len(calls) == 1:
            clock[0] += .5
    monkeypatch.setattr(c6i_shell, "time", SimpleNamespace(perf_counter=lambda: clock[0]))
    monkeypatch.setattr(value, "_submit_menu_frame_locked", draw)
    value._menu_loop()
    assert len(calls) == 5
    assert all(wait >= 1 / 30 - 1e-9 for wait in waits)


def test_menu_self_transition_keeps_owner_and_reuses_thread(monkeypatch):
    value = shell(live_input=SimpleNamespace(sample_menu_control=lambda **_: None))
    value._menu_fps = 30
    handled = threading.Event()
    errors = []
    original_worker = []
    monkeypatch.setattr(value, "_upload_menu_resources_locked", lambda: None)
    monkeypatch.setattr(value, "_submit_menu_frame_locked", lambda: None)
    def transition(_):
        try:
            current = threading.current_thread()
            original_worker.append(current)
            value._stop_menu()
            assert value._menu_thread is current
            with value._lock:
                value._start_menu_locked()
            assert value._menu_thread is current
            value._menu_stop.set()
        except BaseException as error:
            errors.append(error)
            value._menu_stop.set()
        finally:
            handled.set()
    monkeypatch.setattr(value, "handle_control", transition)
    with value._lock:
        value._start_menu_locked()
        worker = value._menu_thread
    try:
        assert handled.wait(2)
        worker.join(2)
        assert not worker.is_alive()
        assert not errors
        assert original_worker == [worker]
        assert value._menu_thread is None
    finally:
        value.close()


def test_external_close_cannot_be_undone_by_inflight_menu_self_transition(monkeypatch):
    value=shell(live_input=SimpleNamespace(sample_menu_control=lambda **_: None))
    value._menu_fps=30
    transition=threading.Event();resume_transition=threading.Event();closing=threading.Event()
    monkeypatch.setattr(value,'_upload_menu_resources_locked',lambda:None)
    monkeypatch.setattr(value,'_submit_menu_frame_locked',lambda:None)
    def handle(_):
        value._stop_menu()
        transition.set()
        assert resume_transition.wait(2)
        with value._lock:value._start_menu_locked()
    monkeypatch.setattr(value,'handle_control',handle)
    original_stop=value._stop_menu
    def stop(**kwargs):
        # Report the external close request before it joins the current worker.
        if threading.current_thread() is not value._menu_thread:closing.set()
        return original_stop(**kwargs)
    monkeypatch.setattr(value,'_stop_menu',stop)
    failures=[]
    def close():
        try:value.close()
        except Exception as error:failures.append(str(error))
    with value._lock:
        value._start_menu_locked();worker=value._menu_thread
    assert transition.wait(2)
    closer=threading.Thread(target=close);closer.start()
    try:
        assert closing.wait(2)
        # External stop publishes cancellation before the transition resumes.
        assert value._menu_stop.wait(2)
        resume_transition.set();closer.join(2)
        assert not closer.is_alive()
        assert not failures
        assert not worker.is_alive()
    finally:
        value._menu_active=False;value._menu_stop.set();resume_transition.set()
        worker.join(2);closer.join(2)
