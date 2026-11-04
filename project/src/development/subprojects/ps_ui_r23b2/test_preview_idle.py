"""Real idle waits and wake/close paths, never a board or camera."""
import threading
import time
from types import SimpleNamespace
from unittest.mock import Mock

from pynq_multimodal_game import vision_preview as module


def encode(snapshot, mode):
    return str(snapshot.frame).encode()


def test_idle_relay_has_no_ten_millisecond_pipe_polling():
    worker = module.ProcessPreviewEncoder(lambda: frozenset(), encode, lambda *_: None)
    original = worker._receive.poll
    calls = []
    def poll(timeout=0):
        calls.append(timeout)
        return original(timeout)
    worker._receive.poll = poll
    try:
        time.sleep(.25)
        assert not calls, 'idle relay must wait on notifications, not poll the result pipe'
    finally:
        worker.close()
    assert worker.health().cleanup == 'CLEAN'
    assert worker._relay_receive.closed and worker._relay_notify.closed


def test_codec_idle_wait_is_indefinite_and_explicit_stop_wakes_it(monkeypatch):
    wait_entered = threading.Event()
    signal = threading.Event()
    calls = []
    class Wake:
        def acquire(self, timeout=None):  # legacy path, retained to show RED
            calls.append(timeout)
            wait_entered.set()
            return signal.wait(timeout)
        def wait(self, timeout=None):
            return self.acquire(timeout)
        def clear(self): signal.clear()
    ready = threading.Event()
    stop = SimpleNamespace(value=False)
    memory = SimpleNamespace(close=Mock())
    output = SimpleNamespace(close=Mock())
    monkeypatch.setattr(module, 'SharedMemory', lambda **_: memory)
    monkeypatch.setattr(module.os, 'nice', lambda *_: None, raising=False)
    failures = []
    def run():
        try:
            module._process_preview_loop('unused', 1024, [0, 0, 0, 0],
                [threading.Lock(), threading.Lock()], Wake(), stop,
                SimpleNamespace(release=ready.set), output, encode)
        except BaseException as error:
            failures.append(error)
    thread = threading.Thread(target=run)
    thread.start()
    try:
        assert ready.wait(2) and wait_entered.wait(2)
        time.sleep(.25)
        assert calls == [None], 'no periodic shared-memory scans without a new snapshot'
    finally:
        stop.value = True
        signal.set()
        thread.join(2)
    assert not thread.is_alive() and not failures
    output.close.assert_called_once()
    memory.close.assert_called_once()


def test_deferred_first_frame_wakes_idle_relay_and_reconnect_keeps_same_codec():
    requested = [frozenset()]
    received = []
    delivered = threading.Event()
    def publish(mode, payload):
        received.append(payload)
        delivered.set()
    worker = module.ProcessPreviewEncoder(lambda: requested[0], encode, publish)
    original_pid = worker._pid
    try:
        for frame in (1, 2, 3):
            requested[0] = frozenset()
            assert not worker.submit_deferred(lambda _: (_ for _ in ()).throw(
                AssertionError('no demand must not copy')), now=frame * 2.)
            requested[0] = frozenset({'video'})
            delivered.clear()
            assert worker.submit_deferred(lambda modes: module.PreviewSnapshot(frame, modes, None,
                {'_preview_capture': {'rgb': b'owned'}}, {}), now=frame * 2. + 1.)
            assert delivered.wait(2)
            assert received[-1] == str(frame).encode()
            assert worker._pid == original_pid
            assert worker.health().healthy
    finally:
        worker.close()
    assert worker.health().cleanup == 'CLEAN'


def test_async_encoder_also_sleeps_until_explicit_work_or_close(monkeypatch):
    original_event = threading.Event
    signal = original_event()
    entered = original_event()
    calls = []
    class Wake:
        def wait(self, timeout=None):
            calls.append(timeout)
            entered.set()
            return signal.wait(timeout)
        def set(self): signal.set()
        def clear(self): signal.clear()
    events = iter((Wake(), original_event()))
    monkeypatch.setattr(module, 'Event', lambda: next(events))
    worker = module.AsyncPreviewEncoder(lambda: frozenset(), encode, lambda *_: None)
    try:
        assert entered.wait(2)
        time.sleep(.25)
        assert calls == [None]
    finally:
        worker.close()
    assert not worker._thread.is_alive()


def test_notified_codec_delivers_without_another_frame_after_slot_contention():
    delivered = threading.Event()
    received = []
    def publish(mode, payload):
        received.append(payload)
        delivered.set()
    worker = module.ProcessPreviewEncoder(lambda: frozenset({'video'}), encode, publish)
    held = []
    try:
        # A completed publication can be followed by a producer taking the
        # slots again before the notified codec scans them. No further frame
        # or periodic scan may be needed to recover the already-published one.
        payload = b''.join(module.snapshot_chunks(module.PreviewSnapshot(
            73, frozenset({'video'}), None, None, None)))
        for lock in worker._slots:
            assert lock.acquire(timeout=1)
            held.append(lock)
        worker._memory.buf[:len(payload)] = payload
        worker._headers[0], worker._headers[1] = 1, len(payload)
        worker._sequence = 1
        worker._wake.set()
        time.sleep(.05)
        assert not delivered.is_set()
        for lock in held:
            lock.release()
        held.clear()
        assert delivered.wait(2)
        assert received == [b'73']
    finally:
        for lock in held:
            lock.release()
        worker.close()
