"""Deterministic scheduler debt and cleanup faults; no board or sleeps."""
from pathlib import Path
from types import SimpleNamespace

import pytest

from pynq_multimodal_game.agent import game_runtime


@pytest.mark.parametrize("interruption", ["slow-frame", "pause", "none"])
def test_elapsed_wall_time_does_not_create_a_burst_of_game_ticks(monkeypatch, interruption):
    clock = [100.]
    starts = []
    game = None

    class Preview:
        def step(self, inputs):
            starts.append((inputs.tick_id, clock[0]))
            if inputs.tick_id == 1:
                if interruption == "slow-frame":
                    clock[0] += 2.
                elif interruption == "pause":
                    game._paused.set()
            if inputs.tick_id == 5:
                game._stop.set()
            return SimpleNamespace(snapshot=SimpleNamespace(status="RUNNING"))

    class Wake:
        def wait(self, timeout):
            if timeout is None:
                assert interruption == "pause" and game.paused
                clock[0] += 10.
                game._paused.clear()
                return True
            clock[0] += timeout
            return False
        def clear(self): pass

    monkeypatch.setattr(game_runtime.PackagedGameRuntime, "_create_preview", lambda *_a, **_k: Preview())
    monkeypatch.setattr(game_runtime, "time", SimpleNamespace(
        perf_counter=lambda: clock[0], monotonic=lambda: clock[0],
        monotonic_ns=lambda: int(clock[0] * 1e9)))
    game = game_runtime.PackagedGameRuntime(Path("unused.vvg"), object())
    game._wake = Wake()
    game._submit = lambda *_a, **_k: None
    game._run(60)
    assert game.last_error is None
    assert [tick for tick, _ in starts] == [1, 2, 3, 4, 5]
    if interruption != "none":
        assert starts[1][1] - starts[0][1] >= (2. if interruption == "slow-frame" else 10.)
    # One immediately ready frame is fine; accumulating seconds of backlogged
    # deadlines and executing all remaining ticks without yielding is not.
    for (_, previous), (_, current) in zip(starts[1:], starts[2:]):
        assert current - previous >= 1 / 60 - 1e-9
    if interruption == "none":
        assert starts[-1][1] - starts[0][1] == pytest.approx(4 / 60)


def test_game_source_release_fault_does_not_leave_preview_process_unstopped(monkeypatch):
    calls = []
    fault = RuntimeError("source release failed")
    def release(_message):
        calls.append("release")
        raise fault
    preview = SimpleNamespace(stop=lambda: calls.append("preview-stop"))
    monkeypatch.setattr(game_runtime.PackagedGameRuntime, "_create_preview", lambda *_a, **_k: preview)
    source = SimpleNamespace(resume=lambda: calls.append("resume"), release=release)
    game = game_runtime.PackagedGameRuntime(Path("unused.vvg"), object(), live_input=source)
    with pytest.raises(RuntimeError) as error:
        game.stop()
    assert error.value is fault
    assert calls == ["resume", "release", "preview-stop"]
    assert not game._input_released  # release failure remains available for retry


def test_game_cleanup_retries_failed_source_and_preserves_first_error(monkeypatch):
    calls = []
    source_fault = RuntimeError("source failure")
    preview_fault = RuntimeError("preview failure")
    fail = [True]
    def release(_message):
        calls.append("release")
        if fail[0]:
            raise source_fault
    def stop():
        calls.append("preview-stop")
        if fail[0]:
            raise preview_fault
    monkeypatch.setattr(game_runtime.PackagedGameRuntime, "_create_preview",
                        lambda *_a, **_k: SimpleNamespace(stop=stop))
    source = SimpleNamespace(resume=lambda: None, release=release)
    game = game_runtime.PackagedGameRuntime(Path("unused.vvg"), object(), live_input=source)
    with pytest.raises(RuntimeError) as error:
        game.stop()
    assert error.value is source_fault
    assert "source failure" in game.last_error and "preview failure" in game.last_error
    assert not game._input_released
    fail[0] = False
    game.stop()
    assert game._input_released
    game.stop()
    assert calls == ["release", "preview-stop", "release", "preview-stop", "preview-stop"]
