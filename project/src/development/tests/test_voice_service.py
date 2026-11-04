import math
import importlib
import multiprocessing as mp
from pathlib import Path
import shutil
import subprocess
import sys
import types
import zipfile

import pytest

from pynq_multimodal_game.voice_observations import VoiceObservationBus, VoiceResultValidator
from pynq_multimodal_game.voice_service import (
    CpuFeatureLibrary, VENDOR_ROOT, VoiceRecognitionService, _CaptureInput, _cpu_bootstrap, _measure_cpu_processing, verify_frozen_source,
)


@pytest.mark.parametrize("failure", ("sha", "abi"))
def test_cpu_feature_library_rejects_identity_before_processing(tmp_path, monkeypatch, failure):
    import ctypes
    import hashlib
    source = tmp_path / "cpu_features.so"
    source.write_bytes(b"CPU-only identity fixture")
    calls = []

    def load(path):
        calls.append(path)
        return types.SimpleNamespace(vvg_cpu_features_abi=lambda: 0)

    monkeypatch.setattr(ctypes, "CDLL", load)
    digest = "0" * 64 if failure == "sha" else hashlib.sha256(source.read_bytes()).hexdigest()
    with pytest.raises(RuntimeError, match="SHA mismatch" if failure == "sha" else "ABI mismatch"):
        CpuFeatureLibrary(source, digest)
    assert len(calls) == (0 if failure == "sha" else 1)


@pytest.mark.parametrize("shape", ((0, 512), (65, 512), (1, 513), (1, 512, 1)))
def test_cpu_feature_library_rejects_shape_before_native_access(shape):
    import numpy as np
    library = CpuFeatureLibrary.__new__(CpuFeatureLibrary)
    with pytest.raises(ValueError, match="complete 512-sample windows"):
        library(types.SimpleNamespace(n=512), np.zeros(shape))


@pytest.mark.parametrize("shape", ((0,), (961,), (1, 0), (1, 960)))
def test_cpu_dc_library_rejects_shape_before_native_access(shape):
    import numpy as np
    library = CpuFeatureLibrary.__new__(CpuFeatureLibrary)
    with pytest.raises(ValueError, match="1..960 mono samples"):
        library.dc(None, np.zeros(shape))


@pytest.mark.parametrize("fail", (False, True))
def test_cpu_timing_keeps_return_or_original_failure_and_splits_clocks(monkeypatch, fail):
    from pynq_multimodal_game import voice_service
    timing = mp.get_context("spawn").Array("d", 7)
    for name, values in (("perf_counter", (1., 1.020)), ("thread_time", (.1, .104)), ("process_time", (.2, .205))):
        iterator = iter(values)
        monkeypatch.setattr(voice_service.time, name, lambda iterator=iterator: next(iterator))
    marker = RuntimeError("original DSP failure")

    def process(samples):
        assert samples == [1, 2]
        if fail:
            raise marker
        return ("original", [1, 2])

    if fail:
        with pytest.raises(RuntimeError) as caught:
            _measure_cpu_processing(process, ([1, 2],), timing)
        assert caught.value is marker
    else:
        assert _measure_cpu_processing(process, ([1, 2],), timing) == ("original", [1, 2])
    assert list(timing) == pytest.approx([1., .020, .004, .005, .020, .004, .005])


@pytest.mark.parametrize("armed", (False, True))
def test_cpu_first_input_gate_preserves_frozen_live_queue_timeout(armed):
    calls = []
    incoming = types.SimpleNamespace(get=lambda timeout: calls.append(("get", timeout)) or (0, b"real_pcm"))
    gate = types.SimpleNamespace(wait=lambda timeout: calls.append(("wait", timeout)) or armed)
    adapter = _CaptureInput(incoming, gate)
    if not armed:
        with pytest.raises(TimeoutError, match="first-input preparation deadline"):
            adapter.get(timeout=10)
        assert calls == [("wait", 60)]
    else:
        assert adapter.get(timeout=10) == adapter.get(timeout=10) == (0, b"real_pcm")
        assert calls == [("wait", 60), ("get", 10), ("get", 10)]


@pytest.mark.parametrize("scale", (0., 1e-15, 1e-3, .1, 1.))
def test_cpu_feature_candidate_exactly_matches_frozen_batch(scale):
    import numpy as np
    from pynq_multimodal_game.voice_service import _cpu_feature_batch
    verify_frozen_source()
    prefix = "pynq_multimodal_game._vendor.voice_rule_cooperative_20261012."
    reference = importlib.import_module(prefix + "audio_reference")
    feature_module = importlib.import_module(prefix + "fast_voice_features")
    cfg = reference.load_config(str(VENDOR_ROOT / "audio_config.json"))
    feature = feature_module.FrameFeatures(cfg, fft_autocorrelation=True)
    windows = np.random.default_rng(105).normal(size=(37, feature.n)) * scale
    windows[0] = scale
    windows[1] = 0
    windows[2] = np.sin(np.arange(feature.n) * (2 * np.pi * 200 / 8000)) * scale
    windows[3] = 0
    windows[3, feature.n // 2] = scale
    before = windows.copy()
    assert _cpu_feature_batch(feature, windows) == feature.batch(windows)
    np.testing.assert_array_equal(windows, before)


@pytest.mark.parametrize("scale", (0., 1e-15, 1e-3, 1., 32768.))
def test_cpu_preprocess_candidate_exactly_matches_frozen_history_and_phase(scale):
    import numpy as np
    from pynq_multimodal_game.voice_service import _cpu_preprocess
    verify_frozen_source()
    prefix = "pynq_multimodal_game._vendor.voice_rule_cooperative_20261012."
    reference = importlib.import_module(prefix + "audio_reference")
    core = importlib.import_module(prefix + "voice_stream_core")
    cfg = reference.load_config(str(VENDOR_ROOT / "audio_config.json"))
    original, candidate = core.Preprocessor(cfg, reference), core.Preprocessor(cfg, reference)
    rng = np.random.default_rng(114)
    for length in (1, 17, 960, 383, 959, 960):
        samples = rng.normal(size=length) * scale
        before = samples.copy()
        np.testing.assert_array_equal(original.process(samples), _cpu_preprocess(candidate, samples))
        np.testing.assert_array_equal(original.history, candidate.history)
        assert (original.carry, original.previous, original.input_count) == (candidate.carry, candidate.previous, candidate.input_count)
        np.testing.assert_array_equal(samples, before)


def test_pending_packets_never_acquires_processing_timing_lock():
    service = VoiceRecognitionService.__new__(VoiceRecognitionService)
    service._producer = lambda: None
    service._stream = types.SimpleNamespace(submitted=4, received=0)
    service._processing_timing = types.SimpleNamespace(get_lock=lambda: pytest.fail("timing lock in backpressure"))
    assert service.pending_packets == 4
    service._stream.received = 3
    assert service.pending_packets == 1


def result(index=0, events=None, decided=1.0):
    return ("result", index, [] if events is None else events, 0.001, decided)


def test_result_contains_recognition_facts_not_game_actions():
    validator = VoiceResultValidator("run", "epoch")
    for index in range(3):
        validator.accept(result(index))
    observation = validator.accept(result(3, events=[["attack", 0], ("shield_on", 32)]))
    assert [event.kind for event in observation.events] == ["HIGH_ONSET", "LOW_SEGMENT_ON"]
    assert [event.sequence for event in observation.events] == [1, 2]
    assert observation.packet_index == 3 and observation.decision_ns == 1_000_000_000
    assert observation.source_age_ns is None and not observation.source_age_verified
    assert not hasattr(observation, "attack_request")


def test_heartbeat_advances_packet_but_not_event_sequence():
    validator = VoiceResultValidator("run", "epoch")
    assert validator.accept(result()).events == ()
    assert validator.accept(result(1, decided=1.01)).events == ()
    assert validator.received == 2 and validator.event_sequence == 0


@pytest.mark.parametrize("message", [
    ("result", 0, [], 0.001, 1.0, []),
    result(True), result(1), result(events=[("unknown", 0)]),
    result(events=[("attack", True)]), result(events=[("attack", -1)]),
    result(events=[("attack", 160)]), result(events=[{"attack": 0}]),
    result(decided=math.nan), result(decided=math.inf), result(decided=True),
    ("result", 0, [], -0.001, 1.0), ("result", 0, {}, 0.001, 1.0),
])
def test_result_invalid_rejects_and_permanently_revokes_epoch(message):
    validator = VoiceResultValidator("run", "epoch")
    with pytest.raises(ValueError):
        validator.accept(message)
    assert validator.received == 0 and validator.fault is not None
    with pytest.raises(ValueError, match="revoked"):
        validator.accept(result())


def test_result_time_regression_and_duplicate_packet_revoke():
    for message in (result(1, decided=0.9), result(0, decided=1.1)):
        validator = VoiceResultValidator("run", "epoch")
        validator.accept(result())
        with pytest.raises(ValueError):
            validator.accept(message)
        assert validator.received == 1


def test_result_event_capacity_is_explicit():
    validator = VoiceResultValidator("run", "epoch", max_events=1)
    with pytest.raises(ValueError, match="capacity"):
        validator.accept(result(events=[("attack", 0), ("shield_off", 32)]))


def test_bus_independent_subscribers_do_not_replay_history():
    bus = VoiceObservationBus()
    bus.begin_epoch("run", "epoch")
    validator = VoiceResultValidator("run", "epoch")
    for index in range(3):
        bus.publish(validator.accept(result(index)))
    first = bus.subscribe(max_age_ns=100_000_000)
    second = bus.subscribe(max_age_ns=100_000_000)
    bus.publish(validator.accept(result(3, events=[["attack", 0]])))
    assert first.poll(1_010_000_000).observations == second.poll(1_010_000_000).observations
    assert first.poll(1_020_000_000).observations == ()
    newcomer = bus.subscribe(max_age_ns=100_000_000)
    assert newcomer.poll(1_020_000_000).observations == ()
    bus.publish(validator.accept(result(4, decided=1.03)))
    assert newcomer.poll(1_040_000_000).observations[0].packet_index == 4


@pytest.mark.parametrize("sample", [1, 160])
def test_result_requires_complete_feature_window_on_frozen_sample_grid(sample):
    validator = VoiceResultValidator("run", "epoch")
    for index in range(3):
        validator.accept(result(index))
    with pytest.raises(ValueError, match="window"):
        validator.accept(result(3, events=[["attack", sample]]))


def test_bus_overrun_is_local_and_fault_is_permanent():
    bus = VoiceObservationBus(capacity=1)
    bus.begin_epoch("run", "epoch")
    validator = VoiceResultValidator("run", "epoch")
    slow = bus.subscribe(max_age_ns=100_000_000)
    fast = bus.subscribe(max_age_ns=100_000_000)
    bus.publish(validator.accept(result()))
    assert fast.poll(1_000_000_000).status == "RUNNING"
    bus.publish(validator.accept(result(1, decided=1.01)))
    assert slow.poll(1_010_000_000).status == "FAULT"
    assert fast.poll(1_010_000_000).status == "RUNNING"
    assert bus.status.status == "RUNNING"
    bus.begin_epoch("run", "next")
    assert fast.poll(1_020_000_000).status == "FAULT"


def test_bus_expiry_source_fault_and_capacity():
    bus = VoiceObservationBus(max_subscribers=1)
    bus.begin_epoch("run", "epoch")
    subscription = bus.subscribe(max_age_ns=1)
    with pytest.raises(ValueError, match="capacity"):
        bus.subscribe(max_age_ns=1)
    bus.publish(VoiceResultValidator("run", "epoch").accept(result()))
    assert subscription.poll(1_000_000_002).status == "FAULT"
    subscription.close()
    replacement = bus.subscribe(max_age_ns=100)
    bus.invalidate("worker exited")
    read = replacement.poll(1_000_000_003)
    assert read.status == "FAULT" and read.latest is None and not read.observations


@pytest.mark.parametrize("age", (-1, 100_000_001))
def test_bus_fault_preserves_first_decision_age_without_replaying(age):
    bus = VoiceObservationBus()
    bus.begin_epoch("run", "epoch")
    subscriber = bus.subscribe(max_age_ns=100_000_000)
    validator = VoiceResultValidator("run", "epoch")
    original = validator.accept(result())
    bus.publish(original)
    first = subscriber.poll(original.decision_ns + age)
    expected = "voice decision age outside consumer budget" if age < 0 else "voice pending observation expired"
    assert first.status == "FAULT" and first.reason == expected
    assert first.decision_age_ns == age and first.latest is original
    assert first.observations == () and bus.status.status == "RUNNING"
    bus.publish(validator.accept(result(1, decided=2.)))
    later = subscriber.poll(2_000_000_000)
    assert later.status == "FAULT" and later.decision_age_ns == age
    assert later.latest is original and later.observations == ()


def test_frozen_source_hashes_and_tamper_rejection(tmp_path):
    manifest = verify_frozen_source()
    assert len(manifest["files"]) == 33
    copied = tmp_path / "frozen"
    shutil.copytree(VENDOR_ROOT, copied)
    (copied / "audio_config.json").unlink()
    with pytest.raises(FileNotFoundError):
        verify_frozen_source(copied)
    shutil.copy2(VENDOR_ROOT / "audio_config.json", copied / "audio_config.json")
    (copied / "voice_stream_core.py").write_bytes(b"tampered")
    with pytest.raises(RuntimeError, match="SHA"):
        verify_frozen_source(copied)
    shutil.copy2(VENDOR_ROOT / "voice_stream_core.py", copied / "voice_stream_core.py")
    (copied / "numpy.py").write_text("raise RuntimeError('unlisted executable')", encoding="utf-8")
    with pytest.raises(RuntimeError, match="Unlisted"):
        verify_frozen_source(copied)


@pytest.mark.parametrize("identity", [{"producer_run": ""}, {"audio_epoch": False}])
def test_service_rejects_invalid_identity_without_defaulting(identity):
    with pytest.raises(ValueError, match="invalid"):
        VoiceRecognitionService(**identity)


def _wrong_origin_child(incoming, outgoing):
    module = types.ModuleType("audio_reference")
    module.__file__ = str(Path.cwd() / "wrong_audio_reference.py")
    sys.modules["audio_reference"] = module
    _cpu_bootstrap(str(VENDOR_ROOT), incoming, outgoing, None)


def _baseline_child(blocks, outgoing):
    sys.path.insert(0, str(VENDOR_ROOT))
    ref = importlib.import_module("audio_reference")
    core = importlib.import_module("voice_stream_core")
    feat = importlib.import_module("fast_voice_features")
    candidate = importlib.import_module("voice_energy_onset_candidate")
    cfg = ref.load_config(str(VENDOR_ROOT / "audio_config.json"))
    stream = core.VoiceStream(cfg, ref, feat.FrameFeatures, batched=True)
    stream.detector = candidate.EnergyOnsetDetector(
        dict(cfg, high_pre_silence_windows=3, shield_on_windows=32, shield_on_ms=500), ref)
    events = []
    for index, block in enumerate(blocks):
        current, _ = stream.process(block)
        events.extend((kind, start, index) for kind, start in current)
    outgoing.put(events, timeout=3)


def test_spawn_origin_mismatch_rejected_before_ready():
    ctx = mp.get_context("spawn")
    incoming, outgoing = ctx.Queue(4), ctx.Queue(8)
    child = ctx.Process(target=_wrong_origin_child, args=(incoming, outgoing))
    try:
        child.start()
        message = outgoing.get(timeout=20)
        assert message[0] == "error" and "origin" in message[2]
        child.join(timeout=3)
        assert child.exitcode == 0
    finally:
        if child.is_alive():
            child.terminate()
            child.join(timeout=3)
        for queue in (incoming, outgoing):
            queue.cancel_join_thread()
            queue.close()


@pytest.mark.parametrize("optimize_features,optimize_preprocessing", ((False, False), (True, False), (False, True), (True, True)))
def test_real_cpu_spawn_matches_frozen_energy_stream_during_capture(optimize_features, optimize_preprocessing):
    import numpy as np
    blocks = [np.zeros(960) for _ in range(15)]
    blocks += [0.05 * np.sin(2 * np.pi * 220 * (np.arange(960) + index * 960) / 48000)
               for index in range(50)]
    blocks += [np.zeros(960) for _ in range(15)]
    assert_cpu_matches_frozen(blocks, optimize_features=optimize_features, optimize_preprocessing=optimize_preprocessing)


def assert_cpu_matches_frozen(blocks, *, optimize_features=False, optimize_preprocessing=False, cpu_feature_library=None):
    ctx = mp.get_context("spawn")
    output = ctx.Queue(1)
    baseline = ctx.Process(target=_baseline_child, args=(blocks, output))
    parent_path = list(sys.path)
    plain_names = ("audio_reference", "voice_stream_core", "fast_voice_features",
                   "voice_energy_onset_candidate")
    parent_modules = {name: sys.modules.get(name) for name in plain_names}
    baseline.start()
    try:
        expected = output.get(timeout=30)
        baseline.join(timeout=3)
        assert baseline.exitcode == 0 and expected
        with VoiceRecognitionService(history_capacity=1, optimize_features=optimize_features,
                         optimize_preprocessing=optimize_preprocessing, cpu_feature_library=cpu_feature_library) as service:
            subscription = service.bus.subscribe(max_age_ns=60_000_000_000)
            observed = []
            for index, block in enumerate(blocks):
                service.process(block)
                service._accept_result(service._stream.outgoing.get(timeout=5))
                observation = service.bus._latest
                observed.extend((event.source_event, event.feature_start_sample_8k, index)
                                for event in observation.events)
                assert observation.packet_index == index
                assert service.statistics["audit_retained"] <= 1
            assert observed == expected
            assert subscription.poll(__import__("time").monotonic_ns()).status == "FAULT"
            assert service.statistics["received"] == len(blocks)
            service.finish(source_stopped=True)
            assert service.statistics["finished"] and service.bus.status.status == "STOPPED"
        assert sys.path == parent_path
        assert all(sys.modules.get(name) is module for name, module in parent_modules.items())
    finally:
        if baseline.is_alive():
            baseline.terminate()
            baseline.join(timeout=3)
        output.cancel_join_thread()
        output.close()
    return expected


@pytest.mark.parametrize("invalid", [[0.0] * 959, [math.nan] * 960])
def test_service_invalid_pcm_fault_does_not_advance_cpu(invalid):
    with VoiceRecognitionService() as service:
        with pytest.raises(ValueError, match="960 finite"):
            service.process(invalid)
        assert service.statistics["submitted"] == 0
        assert service.bus.status.status == "FAULT"
        with pytest.raises(RuntimeError, match="ended"):
            service.process([0.0] * 960)


def test_service_queue_full_revokes_without_advancing_and_finish_requires_stop(monkeypatch):
    import queue
    with VoiceRecognitionService() as service:
        with pytest.raises(ValueError, match="source stopped"):
            service.finish(source_stopped=False)
        assert service.bus.status.status == "WAITING"

        def full(_message):
            raise queue.Full

        monkeypatch.setattr(service._stream.incoming, "put_nowait", full)
        with pytest.raises(RuntimeError, match="queue full"):
            service.process([0.0] * 960)
        assert service.statistics["submitted"] == 0
        assert service.bus.status.status == "FAULT"


@pytest.mark.parametrize("bad", [
    ("result", 0, [], .001, 1., []),
    ("result", True, [], .001, 1.),
    ("result", 0, [["unknown", 0]], .001, 1.),
    ("result", 0, [], .001, math.nan),
    ("error", "Empty", "idle source timeout"),
])
def test_service_rejects_before_original_accept_or_publication(bad):
    service = VoiceRecognitionService.__new__(VoiceRecognitionService)
    service.bus = VoiceObservationBus()
    service.bus.begin_epoch("run", "epoch")
    service.validator = VoiceResultValidator("run", "epoch")
    service._stream = types.SimpleNamespace(submitted=1, received=0)
    calls = []
    service._native = types.SimpleNamespace(_accept=lambda *_args: calls.append(True))
    with pytest.raises((ValueError, RuntimeError)):
        service._accept_result(bad)
    assert calls == [] and service._stream.received == 0
    assert service.bus.status.status == "FAULT"


def test_wheel_is_self_contained_and_cpu_starts_from_isolated_install(tmp_path, record_property):
    import ast
    import json
    import os
    root = Path(__file__).resolve().parents[1]
    snapshot = tmp_path / "snapshot"
    snapshot.mkdir()
    shutil.copy2(root / "pyproject.toml", snapshot / "pyproject.toml")
    shutil.copytree(root / "python", snapshot / "python",
                    ignore=shutil.ignore_patterns("__pycache__", "*.egg-info"))
    wheels = tmp_path / "wheels"
    completed = subprocess.run(
        [sys.executable, "-B", "-m", "pip", "wheel", "--no-deps", "--no-build-isolation",
         "--wheel-dir", str(wheels), str(snapshot)],
        cwd=tmp_path, capture_output=True, text=True, timeout=120,
        env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"},
    )
    assert completed.returncode == 0, completed.stdout + completed.stderr
    wheel, = wheels.glob("*.whl")
    installed = tmp_path / "installed"
    with zipfile.ZipFile(wheel) as archive:
        archive.extractall(installed)
        metadata, = (name for name in archive.namelist() if name.endswith(".dist-info/METADATA"))
        assert 'Provides-Extra: audio' in archive.read(metadata).decode()
    vendor = installed / "pynq_multimodal_game/_vendor" / VENDOR_ROOT.name
    assert len(verify_frozen_source(vendor)["files"]) == 33
    sources = [vendor / relative for relative in verify_frozen_source(vendor)["files"]
               if relative.endswith(".py")]
    sources += [installed / "pynq_multimodal_game" / name
                for name in ("voice_observations.py", "voice_service.py", "multimodal_input.py",
                             "game_actions.py", "game_voice_policy.py", "game_sdk.py", "game_package.py",
                             "game_testing.py", "game_validation.py", "game_runner.py", "agent/game_runtime.py",
                             "agent/core.py", "agent/transport.py", "agent/c6i_shell.py", "engine/side_scroller.py")]
    sources += list((root / "candidates/game1-voice-s2/src").rglob("*.py"))
    for source in sources:
        ast.parse(source.read_text(encoding="utf-8-sig"), filename=str(source), feature_version=(3, 10))
    entry = tmp_path / "probe.py"
    entry.write_text(
        "import json, sys\nfrom pathlib import Path\n"
        f"sys.path.insert(0, {str(installed)!r})\n"
        "from pynq_multimodal_game.voice_service import VoiceRecognitionService, VENDOR_ROOT\n"
        "from pynq_multimodal_game.game_voice_policy import TimedGameVoicePolicy\n"
        "from pynq_multimodal_game.game_runner import GameRunner\n"
        "if __name__ == '__main__':\n"
        "    policy = TimedGameVoicePolicy(game_id='wheel-test', game_run='probe', action_epoch='epoch')\n"
        "    assert policy.policy_id == 'game1-timed-v1'\n"
        "    with VoiceRecognitionService() as service:\n"
        "        service.process([0.0] * 960)\n"
        "        service.finish(source_stopped=True)\n"
        "        assert service.statistics['received'] == 1\n"
        "        print(json.dumps({'vendor': str(VENDOR_ROOT), 'statistics': service.statistics}))\n",
        encoding="utf-8",
    )
    probe = subprocess.run([sys.executable, "-I", "-B", str(entry)], cwd=tmp_path,
                           capture_output=True, text=True, timeout=30,
                           env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"})
    assert probe.returncode == 0, probe.stdout + probe.stderr
    record_property("wheel_path", str(wheel))
    record_property("python310_ast_sources", len(sources))
    evidence = json.loads(probe.stdout)
    assert Path(evidence["vendor"]).is_relative_to(installed)
    assert evidence["statistics"]["finished"]