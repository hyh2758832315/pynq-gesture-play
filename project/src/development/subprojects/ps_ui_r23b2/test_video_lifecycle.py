"""Offline video ownership, cleanup and event-wait regression checks."""
from pathlib import Path
import threading
import time
import struct
from types import SimpleNamespace

import pytest

from pynq_multimodal_game.agent.core import AgentState, ArtifactManifest
from pynq_multimodal_game.agent.video_runtime import C6IVideoRuntimeBackend
from pynq_multimodal_game.video_codec import encode_rgb_frames


@pytest.fixture
def video(tmp_path):
    path = tmp_path / "lifecycle.s2v"
    encode_rgb_frames([bytes((8, 16, 24)) * (320 * 180)] * 3, path)
    return path, ArtifactManifest.for_path(path, artifact_kind="video.s2v",
        target_build_id=0xC0061000, abi_major=1, abi_minor=0)


class Sink:
    def __init__(self):
        self.presented = threading.Event()
        self.close_count = 0
        self.close_error = None
        self.render_error = None
    def upload_tilemap(self, packet): pass
    def upload_palette(self, packet): pass
    def upload_asset(self, packet): pass
    def submit_scene(self, packet):
        self.presented.set()
        if self.render_error:
            raise self.render_error
    def close(self):
        self.close_count += 1
        if self.close_error:
            raise self.close_error


def make_runtime(video, sink, **kwargs):
    path, manifest = video
    runtime = C6IVideoRuntimeBackend(SimpleNamespace(build_id=0xC0061000),
        sink_factory=lambda *_: sink, timeout_seconds=.02, **kwargs)
    runtime.stage_file(manifest, path)
    runtime.activate()
    return runtime


def test_paused_worker_cannot_be_replaced_by_staging_another_video(video):
    sink = Sink()
    runtime = make_runtime(video, sink)
    try:
        runtime.run()
        assert sink.presented.wait(1)
        runtime.pause()
        original = runtime._thread
        with pytest.raises(RuntimeError, match="worker|running"):
            runtime.stage_file(video[1], video[0])
        assert runtime._thread is original
        assert runtime.snapshot.state is AgentState.PAUSED
    finally:
        runtime.stop()


def test_cleanup_error_is_reported_retained_and_only_explicitly_retried(video):
    sink = Sink()
    sink.close_error = RuntimeError("DMA still active")
    runtime = make_runtime(video, sink)
    runtime.run()
    assert sink.presented.wait(1)
    stopped = runtime.stop()
    assert stopped.state is AgentState.ERROR
    assert "DMA still active" in stopped.last_error
    assert sink.close_count == 1
    with pytest.raises(RuntimeError, match="cleanup|DMA still active"):
        runtime.close()
    with pytest.raises(RuntimeError, match="cleanup|worker"):
        runtime.stage_file(video[1], video[0])
    sink.close_error = None
    runtime.close()
    assert runtime._thread is None
    assert runtime.snapshot.state is AgentState.ERROR  # failure history is preserved
    runtime.stage_file(video[1], video[0])
    runtime.activate()
    runtime.run()
    assert runtime.stop().state is AgentState.IDLE


def test_primary_playback_error_survives_stop_and_cleanup_error(video):
    sink = Sink()
    sink.render_error = RuntimeError("first render failure")
    sink.close_error = RuntimeError("second cleanup failure")
    runtime = make_runtime(video, sink)
    runtime.run()
    worker = runtime._thread
    worker.join(1)
    assert not worker.is_alive()
    stopped = runtime.stop()
    assert stopped.state is AgentState.ERROR
    assert stopped.last_error.startswith("first render failure")
    assert "second cleanup failure" in stopped.last_error
    sink.close_error = None
    runtime.close()


def test_stop_timeout_cannot_be_erased_to_spawn_a_second_worker(video):
    release = threading.Event()
    sink = Sink()
    def blocked(packet):
        sink.presented.set()
        release.wait(4)
    sink.submit_scene = blocked
    runtime = make_runtime(video, sink)
    runtime.run()
    assert sink.presented.wait(1)
    worker = runtime._thread
    try:
        stopped = runtime.stop()
        assert stopped.state is AgentState.ERROR and worker.is_alive()
        with pytest.raises(RuntimeError):
            runtime.stage_file(video[1], video[0])
        with pytest.raises(RuntimeError):
            runtime.run()
        assert runtime._thread is worker
    finally:
        release.set()
        stopped = runtime.stop()
    assert runtime._thread is None
    assert stopped.state is AgentState.ERROR
    assert "did not stop" in stopped.last_error


def test_paused_without_return_indicator_sleeps_until_resume(video):
    sink = Sink()
    runtime = make_runtime(video, sink)
    # Observe waits, not CPU percentages: no scheduled 10 ms polls without UI work.
    waiter = getattr(runtime, "_control_changed", runtime._stopped)
    original_wait = waiter.wait
    waits = []
    paused_wait = threading.Event()
    def recording_wait(timeout=None):
        waits.append(timeout)
        if not runtime._resume.is_set():
            paused_wait.set()
        return original_wait(timeout)
    waiter.wait = recording_wait
    try:
        runtime.run()
        assert sink.presented.wait(1)
        runtime.pause()
        assert paused_wait.wait(1)
        count = len(waits)
        time.sleep(.12)
        assert len(waits) == count
        sink.presented.clear()
        runtime.run()
        assert sink.presented.wait(1)
    finally:
        runtime.stop()


def test_seek_uses_staged_frame_count_without_reopening_the_whole_clip(video, monkeypatch):
    from pynq_multimodal_game.agent import video_runtime
    runtime = make_runtime(video, Sink())
    def unexpected_read(*_args, **_kwargs):
        raise AssertionError("seek must not reopen and hash the full clip")
    monkeypatch.setattr(video_runtime, "S2V1Reader", unexpected_read)
    assert runtime.seek(2).state is AgentState.ACTIVE
    with pytest.raises(ValueError, match="outside"):
        runtime.seek(3)
    runtime.stop()


def test_worker_start_failure_has_no_phantom_thread_and_can_be_cleaned(video, monkeypatch):
    runtime = make_runtime(video, Sink())
    def failed_start(_thread):
        raise RuntimeError("no thread available")
    with monkeypatch.context() as patch:
        patch.setattr(threading.Thread, "start", failed_start)
        with pytest.raises(RuntimeError, match="no thread available"):
            runtime.run()
    assert runtime._thread is None
    assert runtime.snapshot.state is AgentState.ERROR
    assert "no thread available" in runtime.snapshot.last_error
    runtime.close()


def test_slow_frame_does_not_create_a_catchup_burst_or_drop_video_frames(video, monkeypatch):
    from pynq_multimodal_game.agent import video_runtime
    clock = [0.]
    sink = Sink()
    starts = []
    indices = []
    def submit(packet):
        starts.append(clock[0])
        indices.append(struct.unpack_from("<I", packet, 8)[0])
        clock[0] += .5 if len(starts) == 1 else .001
    sink.submit_scene = submit
    runtime = make_runtime(video, sink)
    def wait_slot(target, **_kwargs):
        if len(starts) == 5:
            return "stopped"
        clock[0] = max(clock[0], target)
        return "play"
    monkeypatch.setattr(video_runtime.time, "perf_counter", lambda: clock[0])
    monkeypatch.setattr(runtime, "_wait_for_playback_slot", wait_slot)
    runtime._play(video[0])
    assert indices == [0, 1, 2, 0, 1]  # preserve every frame and normal loop order
    assert starts[1] == .5  # one frame can be ready immediately after the stall
    assert all(b - a >= 1 / 30 - 1e-9 for a, b in zip(starts[1:], starts[2:]))
    assert runtime.stats.presented_frames == 5
    assert sink.close_count == 1


def test_paused_return_indicator_keeps_twenty_hz_and_stop_wakes_immediately(video):
    sink = Sink()
    refreshes = []
    refreshed = threading.Event()
    def refresh():
        refreshes.append(time.monotonic())
        if len(refreshes) >= 4:
            refreshed.set()
    sink.refresh_return_indicator = refresh
    runtime = make_runtime(video, sink)
    try:
        runtime.run()
        assert sink.presented.wait(1)
        runtime.pause()
        assert refreshed.wait(1)
        intervals = [b-a for a,b in zip(refreshes, refreshes[1:])]
        assert min(intervals) >= .04
        assert max(intervals) < .15
        started = time.monotonic()
        assert runtime.stop().state is AgentState.IDLE
        assert time.monotonic() - started < .3
    finally:
        runtime.stop()
