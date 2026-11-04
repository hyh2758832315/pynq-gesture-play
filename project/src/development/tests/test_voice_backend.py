from __future__ import annotations

import struct
import threading
from types import SimpleNamespace

import pytest

from pynq_multimodal_game.agent.voice_backend import (
    BorrowedVoiceCapture, NativePcmBufferPool, NativeVoiceLibrary, NativeVoiceSupervisor, VoiceSupervisor, verify_driver_sources,
)


class FakeCapture:
    def __init__(self, *, fail_stop=False, bad_index=False, fail_start=False):
        self.fail_stop, self.bad_index = fail_stop, bad_index
        self.fail_start = fail_start
        self.index, self.started = 0, False
        self.thread_ids = []

    def open(self):
        self.thread_ids.append(threading.get_ident())

    def start(self):
        if self.fail_start:
            raise RuntimeError("Capture startup rejected")
        self.started = True

    def poll(self):
        self.thread_ids.append(threading.get_ident())
        packet = SimpleNamespace(index=self.index + int(self.bad_index), data=struct.pack("<960i", *([123] * 960)))
        self.index += 1
        return packet

    def stop(self):
        self.thread_ids.append(threading.get_ident())
        if self.fail_stop:
            raise RuntimeError("DMA halt unconfirmed")
        return {"stopped_confirmed": True, "buffers_released": True, "owner_released": True}


def test_native_library_hash_rejection_precedes_loading(tmp_path):
    library = tmp_path / "untrusted.so"
    library.write_bytes(b"not a native library")
    with pytest.raises(ValueError, match="SHA mismatch"):
        NativeVoiceLibrary(library, sha256="0" * 64)


@pytest.mark.parametrize("failure", ("source", "models", "library"))
def test_native_runner_gates_exact_source_and_cpu_models_before_loading(tmp_path, failure):
    import json
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner

    (tmp_path / "var").mkdir()
    (tmp_path / "var/voice_native_transport.so").write_bytes(b"not an ELF library")
    report = {"source_sha256": "a" * 64, "hardware_operations": False, "compile_returncode": 0,
              "models": {name: [0] * 10 for name in ("model", "owner_model", "health_model", "loop_model")},
              "library_sha256": "0" * 64}
    if failure == "source": report["source_sha256"] = "b" * 64
    if failure == "models": report["models"]["loop_model"][0] = 1
    (tmp_path / "var/native_transport.json").write_text(json.dumps(report))
    manifest = {"sha256": {"board/pynq_z2/scripts/voice_native_transport.cpp": "a" * 64}}
    with pytest.raises((RuntimeError, ValueError), match={"source": "exact compiled source", "models": "model gate", "library": "SHA mismatch"}[failure]):
        runner.load_diagnostic_native_voice(tmp_path, manifest)


def test_native_root_pool_bytes_identity_and_release_guards():
    import ctypes
    from pynq_multimodal_game.agent.voice_backend import _RETAINED

    class Transport:
        def __init__(self):
            self.arrays = [ctypes.create_string_buffer(64 if index % 2 == 0 else 3840) for index in range(8)]
            self.calls, self.invalid_identity = [], False

        def allocate(self, owner):
            self.calls.append("allocate")
            return 123

        def info(self, context, index):
            assert context == 123
            return 0x100000 + index * 4096 + int(self.invalid_identity), ctypes.addressof(self.arrays[index]), ctypes.sizeof(self.arrays[index])

        def sync(self, context, index, to_device):
            self.calls.append((context, index, to_device))

        def release(self, context):
            assert context == 123
            self.calls.append("release")

    transport = Transport()
    owner_valid = [True]
    pool = NativePcmBufferPool(transport, object(), owner_confirmed=lambda: owner_valid[0])
    assert len(pool.slots) == 4 and id(pool) in _RETAINED
    memory = pool.slots[0][1]
    payload = struct.pack("<960i", *([123] * 960))
    memory.write_bytes(payload)
    assert memory.read_bytes() == payload
    memory.flush()
    memory.invalidate()
    assert transport.calls[-2:] == [(123, 1, True), (123, 1, False)]
    with pytest.raises(ValueError, match="Whole native"):
        memory.write_bytes(b"short")
    transport.invalid_identity = True
    with pytest.raises(RuntimeError, match="identity changed"):
        memory.read_bytes()
    transport.invalid_identity = False
    driver = SimpleNamespace(state="NEW", slots=pool.slots, owner=pool.owner,
                             stop=lambda: {"release_safe": False})
    pool.attach(driver)
    with pytest.raises(RuntimeError, match="fresh DMA/source stop"):
        pool.release()
    assert pool.quarantined and id(pool) in _RETAINED and "release" not in transport.calls
    owner_valid[0] = False
    with pytest.raises(RuntimeError, match="original active producer"):
        memory.read_bytes()
    owner_valid[0] = True
    driver.stop = lambda: {"release_safe": True}
    pool.release()
    assert pool.released and id(pool) not in _RETAINED and transport.calls[-1] == "release"
    with pytest.raises(RuntimeError, match="original active producer"):
        memory.read_bytes()


@pytest.mark.parametrize("cpu_features", (None, ("/cpu-only/features.so", "0" * 64)))
def test_native_runner_enables_cpu_timing_without_changing_child_options(cpu_features):
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner
    captured = []
    original = VoiceSupervisor(lambda: None,
        service_factory=lambda **options: captured.append(options) or object())
    backend = SimpleNamespace(_voice_factory=lambda **options: original)
    runner.configure_diagnostic_native_voice(backend, SimpleNamespace(cpu_feature_library=cpu_features))
    supervisor = backend._voice_factory()
    assert type(supervisor) is NativeVoiceSupervisor
    supervisor._service_factory(bus=original.bus, worker_cpu=1)
    assert captured == [{"bus": original.bus, "worker_cpu": 1, "measure_processing": True,
                         "optimize_features": True, "optimize_preprocessing": cpu_features is not None,
                         "cpu_feature_library": cpu_features}]


@pytest.mark.parametrize("started", (False, True))
def test_native_vision_cpu_diagnostic_only_wraps_future_worker(started):
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner
    worker = SimpleNamespace(cooperative_cpu=False, cpu_scheduling={}, _thread=None, run_id="vision-run")
    factory = lambda run_id: worker
    supervisor = SimpleNamespace(_worker=object() if started else None, _worker_factory=factory)
    result = {}
    if started:
        with pytest.raises(RuntimeError, match="unstarted"):
            runner.configure_diagnostic_vision_cpu(SimpleNamespace(_vision_supervisor=supervisor), result)
        assert supervisor._worker_factory is factory and result == {}
    else:
        runner.configure_diagnostic_vision_cpu(SimpleNamespace(_vision_supervisor=supervisor), result)
        assert not worker.cooperative_cpu
        assert supervisor._worker_factory("vision-run") is worker and worker.cooperative_cpu
        worker.cpu_scheduling.update(native_id=12345, confirmed_nice=5)
        assert result["diagnostic_vision_cpu"]["workers"][0]["scheduling"]["confirmed_nice"] == 5


@pytest.mark.parametrize("started", (False, True))
def test_native_vision_timing_diagnostic_wraps_future_worker_without_scheduling(started):
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner
    worker = SimpleNamespace(measure_processing=False, processing_timing={}, cooperative_cpu=False,
                             _thread=None, run_id="timed-run")
    factory = lambda run_id: worker
    supervisor = SimpleNamespace(_worker=object() if started else None, _worker_factory=factory)
    result = {}
    if started:
        with pytest.raises(RuntimeError, match="unstarted"):
            runner.configure_diagnostic_vision_timing(SimpleNamespace(_vision_supervisor=supervisor), result)
        assert supervisor._worker_factory is factory and result == {}
    else:
        runner.configure_diagnostic_vision_timing(SimpleNamespace(_vision_supervisor=supervisor), result)
        assert not worker.measure_processing
        assert supervisor._worker_factory("timed-run") is worker and worker.measure_processing
        assert not worker.cooperative_cpu
        worker.processing_timing.update(steps=3, cpu_ns=10)
        assert result["diagnostic_vision_timing"]["workers"][0]["timing"] == dict(steps=3, cpu_ns=10)


@pytest.mark.parametrize("previous,confirmed", ((2, 1), (1, 1), (2, 2)))
def test_native_vision_cv_thread_diagnostic_is_confirmed_before_hardware(monkeypatch, previous, confirmed):
    import sys
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner
    values, calls = iter((previous, confirmed)), []
    monkeypatch.setitem(sys.modules, "cv2", SimpleNamespace(__version__="test", getNumThreads=lambda: next(values),
                                                          setNumThreads=lambda count: calls.append(count)))
    result = {}
    if confirmed == 1:
        runner.configure_diagnostic_vision_cv(result)
    else:
        with pytest.raises(RuntimeError, match="unconfirmed"):
            runner.configure_diagnostic_vision_cv(result)
    assert calls == [1]
    assert result["diagnostic_vision_cv"] == dict(classification="process-local diagnostic-only", opencv="test",
        previous_threads=previous, requested_threads=1, confirmed_threads=confirmed)


@pytest.mark.parametrize("started", (False, True))
def test_preview_upload_diagnostic_requires_future_game(started):
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner
    backend = SimpleNamespace(_game=object() if started else None)
    result = {}
    if started:
        with pytest.raises(RuntimeError, match="unstarted"):
            runner.configure_diagnostic_preview_upload(backend, result)
        assert not hasattr(backend, '_diagnostic_preview_upload_overlap') and not result
    else:
        runner.configure_diagnostic_preview_upload(backend, result)
        assert backend._diagnostic_preview_upload_overlap
        assert result['diagnostic_preview_upload_overlap']['additional_threads'] == 0
        assert result['diagnostic_preview_upload_overlap']['max_game_requests'] == 1


@pytest.mark.parametrize("failure", (False, True))
def test_cache_sync_diagnostic_preserves_bo_direction_errors_and_restoration(failure):
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner

    class Device:
        def flush(self, buffer, offset, pointer, size):
            raise AssertionError("original flush called")

        def invalidate(self, buffer, offset, pointer, size):
            raise AssertionError("original invalidate called")

    device, buffer, result, calls = Device(), object(), {}, []
    original_flush, original_invalidate = device.flush, device.invalidate

    def synchronize(actual_buffer, direction):
        assert actual_buffer is buffer
        calls.append(direction)
        if failure:
            raise ValueError("cache failure")

    restore = runner.install_diagnostic_cache_sync(device, Device, SimpleNamespace(sync=synchronize), result)
    for name, direction in (("flush", 0), ("invalidate", 1)):
        if failure:
            with pytest.raises(RuntimeError, match="Buffer .* Failed: cache failure") as caught:
                getattr(device, name)(buffer, 17, 12345, 64)
            assert type(caught.value.__cause__) is ValueError
        else:
            getattr(device, name)(buffer, 17, 12345, 64)
        assert calls[-1] == direction
    restore()
    assert device.flush == original_flush and device.invalidate == original_invalidate and not vars(device)
    assert result["diagnostic_cache_sync"]["restored"]
    assert result["diagnostic_cache_sync"]["flush_calls"] == 1
    assert result["diagnostic_cache_sync"]["invalidate_calls"] == 1


@pytest.mark.parametrize("override", ("instance", "subclass"))
def test_cache_sync_diagnostic_rejects_changed_device_methods(override):
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner

    class Device:
        def flush(self, *arguments):
            pass

        def invalidate(self, *arguments):
            pass

    class ChangedDevice(Device):
        def flush(self, *arguments):
            pass

    device = ChangedDevice() if override == "subclass" else Device()
    if override == "instance":
        device.flush = lambda *arguments: None
    original, result = device.flush, {}
    with pytest.raises(RuntimeError, match="original XrtDevice"):
        runner.install_diagnostic_cache_sync(device, Device, object(), result)
    assert device.flush == original and not result


@pytest.mark.parametrize("failure", ("source", "model", "library"))
def test_cache_sync_diagnostic_rejects_bad_receipt_before_loading(tmp_path, failure):
    import hashlib
    import json
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner

    directory = tmp_path / "var/cache-sync"
    directory.mkdir(parents=True)
    library = directory / ("voice_xrt_sync" + runner.sysconfig.get_config_var("EXT_SUFFIX"))
    library.write_bytes(b"not an extension")
    report = dict(status="S4_CACHE_SYNC_BUILD_MODEL_PASS", source_sha256="a" * 64,
        hardware_operations=False, model_returncode=0, model=dict(status="CACHE_SYNC_CPU_MODEL_PASS"),
        compile_returncodes=[0, 0], library_sha256=hashlib.sha256(library.read_bytes()).hexdigest())
    if failure == "source":
        report["source_sha256"] = "b" * 64
    if failure == "model":
        report["model_returncode"] = 1
    if failure == "library":
        report["library_sha256"] = "0" * 64
    (tmp_path / "var/cache_sync.json").write_text(json.dumps(report))
    with pytest.raises(RuntimeError, match="exact source/library"):
        runner.load_diagnostic_cache_sync(tmp_path,
            dict(sha256={"board/pynq_z2/scripts/voice_xrt_sync.cpp": "a" * 64}))


@pytest.mark.parametrize("mode,native", (("fusion", False), ("audio", True), ("audio-vision", True)))
def test_cache_sync_cli_rejects_invalid_mode_before_deployment(monkeypatch, mode, native):
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner

    monkeypatch.setattr(runner, "check_deployment", lambda root: pytest.fail("deployment reached"))
    arguments = ["--check-only", "--mode", mode, "--diagnostic-cache-sync"]
    if native:
        arguments.append("--diagnostic-native-voice")
    with pytest.raises(SystemExit) as caught:
        runner.main(arguments)
    assert caught.value.code == 2


def assert_cache_sync_model(module):
    import threading

    assert module.abi == 10000 and module.model is True
    buffer = module.ModelBuffer()
    ready, stop = threading.Event(), threading.Event()
    progress, increments = [0], []

    def tick():
        ready.set()
        while not stop.is_set():
            progress[0] += 1

    worker = threading.Thread(target=tick)
    worker.start()
    try:
        assert ready.wait(1)
        for direction in (0, 1):
            before = progress[0]
            module.sync(buffer, direction)
            increments.append(progress[0] - before)
            assert increments[-1] > 0
        buffer.fail = True
        try:
            module.sync(buffer, 0)
        except RuntimeError as error:
            assert str(error) == "model sync failure"
        else:
            raise AssertionError("sync error lost")
        for direction in (-1, 2, 3):
            try:
                module.sync(buffer, direction)
            except ValueError:
                pass
            else:
                raise AssertionError("invalid direction accepted")
        try:
            module.sync(object(), 0)
        except TypeError:
            pass
        else:
            raise AssertionError("invalid buffer accepted")
        assert buffer.calls == 3
    finally:
        stop.set()
        worker.join(2)
    assert not worker.is_alive()
    return dict(status="CACHE_SYNC_CPU_MODEL_PASS", gil_progress=increments,
                invalid_directions=3, exception_preserved=True, hardware_operations=False)


class FakeService:
    def __init__(self, *, bus):
        self.bus, self.count = bus, 0
        self.thread_id = threading.get_ident()
        self.closed = False

    def process(self, samples):
        assert threading.get_ident() == self.thread_id and len(samples) == 960 and samples[0] == 123
        self.count += 1

    @property
    def statistics(self):
        return {"submitted": self.count, "received": self.count}

    @property
    def pending_packets(self):
        return self.statistics["submitted"] - self.statistics["received"]

    def finish(self, *, source_stopped):
        assert source_stopped is True and threading.get_ident() == self.thread_id

    def drain(self):
        assert threading.get_ident() == self.thread_id

    def end_observations(self):
        assert threading.get_ident() == self.thread_id

    def close(self):
        assert threading.get_ident() == self.thread_id
        self.closed = True


def test_finite_voice_producer_waits_for_first_scene_and_cleans_up():
    capture = FakeCapture()
    supervisor = VoiceSupervisor(lambda: capture, service_factory=FakeService, packet_limit=3)
    supervisor.prepare()
    assert not capture.started
    supervisor.start()
    supervisor._thread_handle.join(3)
    status = supervisor.stop()
    assert status["state"] == "STOPPED" and status["packets"] == 3 and status["samples"] == 2880
    assert status["cpu"] == {"submitted": 3, "received": 3}
    assert status["owner_released"] and len(set(capture.thread_ids)) == 1
    with pytest.raises(RuntimeError, match="one-shot"):
        supervisor.prepare()


def test_native_start_fault_preserves_original_trace_without_new_hardware_reads():
    marker = RuntimeError("operation deadline")

    class StartFault(FakeCapture):
        def start(self):
            self.thread_ids.append(threading.get_ident())
            self.driver = SimpleNamespace(state="FAULT", fault_elapsed=.051,
                fault_callback_trace=(("original_health", .009),))
            self.initialization = {"capture_snapshot": {"sequence": 12}}
            raise marker

        def native_source_stopped(self):
            return True

        def close_native_loop(self):
            pass

    capture = StartFault()
    supervisor = NativeVoiceSupervisor(lambda: capture, service_factory=FakeService)
    supervisor.prepare()
    with pytest.raises(RuntimeError, match="operation deadline"):
        supervisor.start()
    status = supervisor.stop()
    assert status["state"] == "FAULT" and status["packets"] == 0
    assert status["fault_diagnostic"] == {"phase": "capture_start", "native_loop": {},
        "driver_state": "FAULT", "fault_elapsed": .051,
        "callback_trace": (("original_health", .009),), "capture_snapshot": {"sequence": 12},
        "start_timing": {}}
    assert status["owner_released"] is True and len(set(capture.thread_ids)) == 1


def test_native_start_timing_preserves_owner_calls_and_original_failure():
    capture = object.__new__(BorrowedVoiceCapture)
    capture._thread = lambda: None
    capture.state, capture.initialization = "READY", {}
    capture.pool = SimpleNamespace(context=object())
    capture.native_transport = SimpleNamespace(
        require=lambda result: None,
        library=SimpleNamespace(vvg_voice_native_roots_mark_armed=lambda context: 0))
    owners = []

    def owner():
        owners.append(threading.get_ident())
        return True

    failure = RuntimeError("original start deadline")

    def start():
        assert capture.driver.owner() is True
        assert capture.driver.owner() is True
        raise failure

    capture.driver = SimpleNamespace(owner=owner, start=start)
    with pytest.raises(RuntimeError) as caught:
        capture.start()
    assert caught.value is failure and capture.driver.owner is owner
    assert owners == [threading.get_ident()] * 2
    timing = capture.initialization["start_timing"]
    assert timing["owner_calls"] == 2
    assert timing["wall_seconds"] >= timing["owner_wall_seconds"] >= 0
    assert timing["cpu_seconds"] >= timing["owner_cpu_seconds"] >= 0
    assert "capture_started_at" not in capture.initialization


@pytest.mark.parametrize("failure", ("none", "stop", "backpressure", "boundaries", "badpositive", "badnegative"))
def test_native_supervisor_keeps_cpu_lifecycle_on_consumer_and_hardware_on_producer(failure):
    import queue

    class NativeCapture(FakeCapture):
        def __init__(self):
            super().__init__(fail_stop=failure == "stop")
            self.packets, self.finished = queue.Queue(), threading.Event()

        def run_native(self, limit):
            for _ in range(limit):
                packet = self.poll()
                if failure in ("boundaries", "badpositive", "badnegative"):
                    values = ([123, -32768, -1, 0, 32767] * 192)
                    if failure.startswith("bad"):
                        values[-1] = 32768 if failure == "badpositive" else -32769
                    packet.data = struct.pack("<960i", *values)
                self.packets.put(packet)
            self.finished.set()

        def pop_native(self):
            try:
                return self.packets.get_nowait()
            except queue.Empty:
                return None

        def native_finished(self):
            return self.finished.is_set()

        def request_native_stop(self):
            pass

        def close_native_loop(self):
            assert self.packets.empty()

        def native_source_stopped(self):
            return self.finished.is_set()

    class BackpressureService(FakeService):
        def __init__(self, **options):
            super().__init__(**options)
            self.received, self.max_pending = 0, 0

        def process(self, samples):
            super().process(samples)
            pending = self.count - self.received
            assert pending <= 4
            self.max_pending = max(self.max_pending, pending)

        def drain(self):
            super().drain()
            if self.count - self.received >= 4:
                self.received += 1

        @property
        def statistics(self):
            return {"submitted": self.count, "received": self.received}

        def finish(self, *, source_stopped):
            super().finish(source_stopped=source_stopped)
            self.received = self.count

    class BoundaryService(FakeService):
        def process(self, samples):
            super().process(samples)
            assert samples.tolist() == [123, -32768, -1, 0, 32767] * 192
            assert not samples.flags.writeable

    capture, services = NativeCapture(), []
    limit = 20 if failure == "backpressure" else 1 if failure.startswith("bad") else 3

    def service_factory(**options):
        service_type = BackpressureService if failure == "backpressure" else BoundaryService if failure == "boundaries" else FakeService
        service = service_type(**options)
        services.append(service)
        return service

    supervisor = NativeVoiceSupervisor(lambda: capture, service_factory=service_factory, packet_limit=limit, record_pcm=True)
    supervisor.prepare()
    assert not capture.started
    supervisor.start()
    supervisor._thread_handle.join(3)
    assert not supervisor._thread_handle.is_alive() and not supervisor._cpu_thread.is_alive()
    assert len(set(capture.thread_ids)) == 1 and services[0].thread_id != capture.thread_ids[0]
    assert services[0].closed
    assert len(supervisor.recorded_pcm) == (0 if failure.startswith("bad") else limit * 3840)
    if failure.startswith("bad"):
        status = supervisor.stop()
        assert status["state"] == "FAULT" and status["packets"] == 0
        assert "sign-extended signed16" in status["first_error"]
        assert status["owner_released"] is True and services[0].count == 0
    elif failure == "stop":
        with pytest.raises(RuntimeError, match="DMA halt unconfirmed"):
            supervisor.stop()
        assert supervisor.status()["state"] == "RETAINED"
        from pynq_multimodal_game.agent.voice_backend import _RETAINED
        _RETAINED.pop(id(supervisor))
    else:
        status = supervisor.stop()
        assert status["state"] == "STOPPED" and status["packets"] == limit
        assert status["cpu"] == {"submitted": limit, "received": limit}
        assert status["owner_released"] is True
        if failure == "backpressure":
            assert services[0].max_pending == 4


@pytest.mark.parametrize("failure", ("halt", "sequence", "start"))
def test_voice_fault_retains_first_error_and_requires_confirmed_stop(failure):
    capture = FakeCapture(fail_stop=failure == "halt", bad_index=failure == "sequence", fail_start=failure == "start")
    supervisor = VoiceSupervisor(lambda: capture, service_factory=FakeService, packet_limit=1)
    supervisor.prepare()
    if failure == "start":
        with pytest.raises(RuntimeError, match="Capture startup rejected"):
            supervisor.start()
    else:
        supervisor.start()
    supervisor._thread_handle.join(3)
    if failure == "halt":
        with pytest.raises(RuntimeError, match="halt unconfirmed"):
            supervisor.stop()
        assert supervisor.status()["state"] == "RETAINED"
    else:
        assert supervisor.stop()["state"] == "FAULT"
        status = supervisor.status()
        assert ("startup rejected" if failure == "start" else "sequence") in status["first_error"]
        assert status["fault_diagnostic"]["phase"] == ("capture_start" if failure == "start" else "receive")


@pytest.mark.parametrize("inspection_error", (False, True))
def test_borrowed_capture_fault_snapshot_precedes_stop_and_preserves_original_error(tmp_path, inspection_error):
    capture = BorrowedVoiceCapture(SimpleNamespace(), tmp_path)
    events = []
    capture.state = "RUNNING"
    capture._owned = lambda: True

    def read(offset):
        events.append(("read", offset))
        if inspection_error:
            raise RuntimeError("diagnostic read rejected")
        return {0x30: 0x10001, 0x34: 0x1008, 0x38: 0x1000, 0x40: 0x1000}[offset]

    capture._dma_mmio = SimpleNamespace(read=read)
    capture.pool = SimpleNamespace(slots=((SimpleNamespace(physical_address=0x1000,
        invalidate=lambda: events.append("invalidate"), read_bytes=lambda: struct.pack("<16I", *([0]*16))), None),))

    def fail_poll(timeout):
        assert timeout == .015
        events.append("poll_fault")
        raise RuntimeError("original capture fault")

    capture.driver = SimpleNamespace(poll_packet=fail_poll)
    with pytest.raises(RuntimeError, match="original capture fault"):
        capture.poll()
    snapshot = capture.initialization["fault_transport"]
    assert snapshot["phase"] == "after_poll_fault_before_stop" and snapshot["packet_index"] == 0
    assert events[0] == "poll_fault" and snapshot["finished_at"] >= snapshot["started_at"]
    assert capture.initialization["max_service_gap_seconds"] == 0
    if inspection_error:
        assert snapshot["diagnostic_error"] == "RuntimeError: diagnostic read rejected"
    else:
        assert snapshot["dma"]["current"] == snapshot["dma"]["tail"] == "0x1000"
        assert snapshot["descriptors"][0]["address"] == "0x1000"
        assert snapshot["descriptors"][0]["words"] == [0]*16


def test_unstarted_capture_has_no_hardware_effect_and_requires_explicit_authorization(tmp_path):
    session = SimpleNamespace(is_open=True)
    capture = BorrowedVoiceCapture(session, tmp_path)
    with pytest.raises(RuntimeError, match="Explicit"):
        capture.open()
    assert capture.lease is None and capture.driver is None


def test_real_cpu_tail_is_drained_without_publishing_into_closed_epoch():
    supervisor = VoiceSupervisor(FakeCapture, packet_limit=5)
    supervisor.prepare()
    supervisor.start()
    supervisor._thread_handle.join(10)
    result = supervisor.stop()
    assert result["first_error"] is None and result["state"] == "STOPPED"
    assert result["cpu"]["submitted"] == result["cpu"]["received"] == result["packets"] == 5
    assert supervisor.bus.status.status == "STOPPED"


def test_voice_observer_is_bounded_and_never_consumes_game_subscription():
    from pynq_multimodal_game.voice_observations import VoiceObservation, VoiceObservationBus
    bus = VoiceObservationBus()
    bus.begin_epoch("run", "epoch")
    subscription = bus.subscribe(max_age_ns=100)
    observation = VoiceObservation("run", "epoch", 0, 20, 0, ())
    bus.publish(observation)
    for _ in range(100):
        assert bus.observe(25).latest == observation
    assert subscription.poll(25).observations == (observation,)
    supervisor = VoiceSupervisor(FakeCapture, service_factory=FakeService, packet_limit=3)
    supervisor.prepare()
    supervisor.start()
    supervisor._thread_handle.join(3)
    supervisor.stop()
    monitor = supervisor.observation()
    assert monitor["schema"] == "voice-monitor-v1" and monitor["packets"] == 3
    assert monitor["pcm"]["packet_index"] == 2 and len(monitor["pcm"]["samples"]) == 240
    assert monitor["pcm"]["historical"] is True and supervisor._pcm == []
    assert monitor["source_age_verified"] is False and monitor["board_validated"] is False


def test_unlisted_driver_bytecode_is_rejected_before_loading(tmp_path):
    (tmp_path / "injected.pyc").write_bytes(b"untrusted executable")
    with pytest.raises(ValueError, match="six-file"):
        verify_driver_sources(tmp_path)


def test_borrowed_capture_composes_frozen_cooperative_types_and_keeps_hard_deadline():
    import time
    from pathlib import Path
    from pynq_multimodal_game.agent.voice_backend import cooperative_capture_types, load_driver_sources, _diagnostic_capture_mmio

    root = Path(__file__).resolve().parents[1]
    driver_root = root / "audio_driver"
    if not driver_root.is_dir():
        driver_root = root / "deliveries/voice-s5-studio-offline-r21-20261014/audio_driver"
    modules = load_driver_sources(driver_root)
    pool_type = modules["voice_pynq_binding"].PcmBufferPool
    with pytest.raises(ValueError, match="4..64"):
        pool_type(None, owner_confirmed=lambda: False, count=3)
    with pytest.raises(modules["voice_pynq_binding"].DmaFault, match="exclusive owner"):
        pool_type(None, owner_confirmed=lambda: False, count=4)
    original = modules["voice_pcm_sg"].VoicePcmSG
    binding_type, iic_type, driver_type = cooperative_capture_types(modules)
    assert [kind.__name__ for kind in driver_type.__mro__[:5]] == [
        "CooperativeDriver", "StartupDriver", "ControlDriver", "OptimizedVoicePcmSG", "VoicePcmSG"]
    assert modules["voice_pcm_sg"].VoicePcmSG is original
    assert binding_type.__name__ == "ControlBinding" and iic_type.__name__ == "StartupIIC"
    calls, capture_diagnostics = [], {}
    mmio = _diagnostic_capture_mmio(SimpleNamespace(read=lambda offset: calls.append(offset) or 7,
                                                   write=lambda *_: None), capture_diagnostics)
    owner = lambda: True
    binding = binding_type(mmio, {"type": "xilinx.com:module_ref:voice_i2s_dma_capture_axi:1.0",
                                 "phys_addr": 0x413E0000, "addr_range": 0x1000}, owner_confirmed=owner)
    slots = [(SimpleNamespace(physical_address=0x100000 + index * 8192, nbytes=64),
              SimpleNamespace(physical_address=0x100040 + index * 8192, nbytes=3840)) for index in range(4)]
    transport = iic_type(lambda _: 0, lambda *_: None,
        description={"type": "xilinx.com:ip:axi_iic:2.1", "phys_addr": 0x43C10000, "addr_range": 0x1000},
        owner_confirmed=owner, stopped_confirmed=lambda: True)

    def pll_ready():
        return transport is not None

    constructed = driver_type(lambda _: 0, lambda *_: None,
        {"type": "xilinx.com:ip:axi_dma:7.1", "phys_addr": 0x40430000, "addr_range": 0x1000,
         "parameters": modules["voice_pcm_sg"].EXPECTED}, slots,
        owner_confirmed=owner, capture_stopped=binding.stopped, set_capture=binding.set_capture,
        health=binding.health, codec_ready=pll_ready)
    assert type(binding) is binding_type and constructed.state == "NEW" and calls == []
    assert mmio.read(0x2C) == 7 and calls == [0x2C] and capture_diagnostics == {"capture_snapshot": {"live": 7}}
    diagnostics = {"iic_operations": [], "iic_operations_dropped": 0}
    _, observed_iic_type, observed_driver_type = cooperative_capture_types(modules, diagnostics=diagnostics)
    assert [kind.__name__ for kind in observed_iic_type.__mro__[:3]] == [
        "StartupIIC", "DiagnosticIIC", "VoiceAxiIIC"]
    assert observed_driver_type.__name__ == "CooperativeDriver"
    assert modules["voice_pcm_sg"].VoicePcmSG is original
    assert modules["voice_axi_iic"].VoiceAxiIIC is iic_type.__mro__[1]
    with pytest.raises(ValueError, match="15ms CPU"):
        driver_type.poll_packet(SimpleNamespace(), timeout=.01)
    wall = [100.0]
    driver = driver_type.__new__(driver_type)
    driver.lock = threading.Lock()
    driver.clock = lambda: wall[0]
    driver.owner = lambda: True
    driver._receive_scope, driver._receive_thread = True, threading.get_ident()
    cpu_before = time.thread_time()
    driver._begin(.015)
    try:
        assert driver.deadline == 100.05
        assert cpu_before + .015 <= driver.execution_deadline <= time.thread_time() + .015
        driver.execution_deadline = time.thread_time() - 1
        with pytest.raises(RuntimeError, match="CPU execution budget"):
            driver._call(lambda: None)
        driver.execution_deadline = time.thread_time() + 1
        wall[0] = 100.051
        with pytest.raises(RuntimeError, match="operation deadline"):
            driver._call(lambda: None)
    finally:
        driver.lock.release()


def test_borrowed_capture_uses_frozen_cooperative_receive_budget(tmp_path):
    received = []
    capture = BorrowedVoiceCapture(SimpleNamespace(), tmp_path)
    capture.state = "RUNNING"
    capture.driver = SimpleNamespace(poll_packet=lambda **options: received.append(options))
    assert capture.poll() is None
    assert received == [{"timeout": .015}]


@pytest.mark.parametrize("advancing_clock", (True, False))
def test_iic_diagnostic_distinguishes_wall_deadline_from_poll_limit(advancing_clock):
    from pathlib import Path
    from pynq_multimodal_game.agent.voice_backend import _diagnostic_iic_module, load_driver_sources

    root = Path(__file__).resolve().parents[1]
    driver_root = root / "audio_driver"
    if not driver_root.is_dir():
        driver_root = root / "deliveries/voice-s5-studio-offline-r21-20261014/audio_driver"
    module = load_driver_sources(driver_root)["voice_axi_iic"]
    diagnostics = {"iic_operations": [], "iic_operations_dropped": 0}
    traced = _diagnostic_iic_module(module, diagnostics)
    now = [0.0]

    def clock():
        now[0] += .0001 if advancing_clock else 0
        return now[0]

    transport = traced.VoiceAxiIIC(
        lambda offset: {0x104: 0xC0, 0x100: 1}.get(offset, 0), lambda *_: None,
        description={"type": "xilinx.com:ip:axi_iic:2.1", "phys_addr": 0x43C10000, "addr_range": 0x1000},
        owner_confirmed=lambda: True, stopped_confirmed=lambda: True, clock=clock, sleep=lambda _: None)
    transport.initialized = True
    with pytest.raises(RuntimeError, match="deadline/poll limit"):
        transport.read(0x4002, 6, .01)
    assert len(diagnostics["iic_operations"]) == 1
    record = diagnostics["iic_operations"][0]
    assert record["register"] == "0x4002" and record["timeout_seconds"] == .01
    assert record["deadline_expired"] is advancing_clock
    assert record["poll_limit_exceeded"] is not advancing_clock
    assert "AXI-IIC operation deadline/poll limit" in record["error"]
    assert transport.failed is True


@pytest.mark.parametrize("stopped,allocation_started", ((True, False), (False, False), (True, True)))
def test_incomplete_capture_releases_only_with_idle_proof_and_no_allocation(tmp_path, stopped, allocation_started):
    from pynq_multimodal_game.agent import voice_backend

    capture = BorrowedVoiceCapture(SimpleNamespace(), tmp_path)
    capture.state, capture.first_error = "RETAINED", "original IIC deadline"
    capture._pool_allocation_started = allocation_started
    released = []

    def release(proof, buffers_safe):
        assert proof is capture._startup_stopped
        if proof(lambda: True) is not True or buffers_safe() is not True:
            raise RuntimeError("Startup source/DMA/IIC stop unconfirmed")
        released.append("owner")

    capture.owner = SimpleNamespace(confirmed=lambda: True, release=release)
    capture.lease = SimpleNamespace(close=lambda: released.append("lease"))
    capture._startup_stopped = lambda locked: stopped and locked()
    voice_backend._RETAINED[id(capture)] = capture
    try:
        if stopped and not allocation_started:
            assert all(capture.stop().values())
            assert released == ["owner", "lease"] and capture.state == "CLOSED"
            assert id(capture) not in voice_backend._RETAINED
        else:
            with pytest.raises(RuntimeError, match="unconfirmed|operator recovery"):
                capture.stop()
            assert released == [] and capture.state == "RETAINED"
            assert capture.first_error == "original IIC deadline"
            assert voice_backend._RETAINED[id(capture)] is capture
    finally:
        voice_backend._RETAINED.pop(id(capture), None)


def test_iic_diagnostic_preserves_success_and_bounds_records():
    from pynq_multimodal_game.agent.voice_backend import _diagnostic_iic_module

    calls = []

    class Transport:
        clock = staticmethod(lambda: 10.0)

        def _budget(self, timeout):
            return [self.clock() + timeout, 10000]

        def read(self, register, length, timeout):
            self._budget(timeout)
            calls.append(("read", register, length, timeout))
            return bytes([7]) * length

        def write(self, register, payload, timeout):
            self._budget(timeout)
            calls.append(("write", register, payload, timeout))
            return len(payload)

    diagnostics = {"iic_operations": [], "iic_operations_dropped": 0}
    module = _diagnostic_iic_module(SimpleNamespace(VoiceAxiIIC=Transport, IICFault=RuntimeError), diagnostics)
    transport = module.VoiceAxiIIC()
    for _ in range(260):
        assert transport.read(0x4002, 6, .4) == bytes([7]) * 6
    assert transport.write(0x4000, b"\x0f", .3) == 1
    assert len(calls) == 261
    assert len(diagnostics["iic_operations"]) == 256 and diagnostics["iic_operations_dropped"] == 5
    assert diagnostics["iic_operations"][-1]["operation"] == "write"
    assert all("error" not in record for record in diagnostics["iic_operations"])


def test_cpu_close_failure_retains_service_and_fault(monkeypatch):
    from pynq_multimodal_game.agent import voice_backend
    retained = {}
    monkeypatch.setattr(voice_backend, "_RETAINED", retained)

    class Service(FakeService):
        def close(self):
            raise RuntimeError("CPU exit unconfirmed")

    supervisor = VoiceSupervisor(FakeCapture, service_factory=Service, packet_limit=1)
    supervisor.prepare()
    supervisor.start()
    supervisor._thread_handle.join(3)
    with pytest.raises(RuntimeError, match="CPU exit unconfirmed"):
        supervisor.stop()
    assert supervisor.status()["state"] == "RETAINED" and retained


@pytest.mark.parametrize("command", ("python unrelated.py", "python capture_camera_direct_plug.py", "python pcm_capture_test.py"))
def test_runner_requires_legacy_owners_stopped(monkeypatch, command):
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner
    monkeypatch.setattr(runner.subprocess, "run", lambda *args, **kwargs: SimpleNamespace(stdout="999999 " + command))
    if command.endswith("unrelated.py"):
        runner.require_no_existing_owner()
    else:
        with pytest.raises(RuntimeError, match="confirmed DMA cleanup"):
            runner.require_no_existing_owner()


@pytest.mark.parametrize("failure", (None, "audio", "vision", "game_receipts"))
def test_runner_runtime_snapshot_preserves_start_fault_and_independent_evidence(failure):
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner

    audio = {"state": "RETAINED", "packets": 1,
             "fault_diagnostic": {"capture_snapshot": {"live": 7, "accepted_low": 3840}}}
    receipts = {"presented_frames": 3, "vision": {"frames": 2}, "audio": {"events": 0}}

    def read(name, value):
        if failure == name:
            raise RuntimeError(name + " diagnostic unavailable")
        return value

    class Game:
        @property
        def input_consumptions(self):
            return read("game_receipts", receipts)

    backend = SimpleNamespace(
        _voice=SimpleNamespace(status=lambda: read("audio", audio)),
        voice_status={"state": "RETAINED"},
        _vision_supervisor=SimpleNamespace(status=lambda: read("vision", {"state": "RUNNING"})),
        _game=Game())
    result = {"first_error": "original capture fault"}
    runner.record_runtime_snapshot(result, backend, None, "before_cleanup")
    snapshot = result["runtime_snapshots"]["before_cleanup"]
    assert result["first_error"] == "original capture fault"
    for name in ("audio", "vision", "game_receipts", "voice"):
        if name == failure:
            assert name not in snapshot
            assert snapshot["diagnostic_errors"][name] == f"RuntimeError: {name} diagnostic unavailable"
        else:
            assert name in snapshot
    audio["fault_diagnostic"]["capture_snapshot"]["live"] = 0
    receipts["vision"]["frames"] = 4
    runner.record_runtime_snapshot(result, backend, None, "after_cleanup")
    if failure != "audio":
        assert snapshot["audio"]["fault_diagnostic"]["capture_snapshot"]["live"] == 7
        assert result["audio"]["fault_diagnostic"]["capture_snapshot"]["live"] == 7
        assert result["runtime_snapshots"]["after_cleanup"]["audio"]["fault_diagnostic"]["capture_snapshot"]["live"] == 0
    if failure != "game_receipts":
        assert snapshot["game_receipts"]["vision"]["frames"] == 2


@pytest.mark.parametrize("case", ("normal", "scheduler", "start_failure", "stop_failure", "start_retained", "cleanup_failure",
                                  "camera_only", "camera_failure", "camera_retained", "camera_copy", "camera_recycle", "camera_yield"))
@pytest.mark.parametrize("skin_mode", (None, "validate", "performance"))
def test_runner_main_writes_fault_snapshot_before_retaining(case, skin_mode, monkeypatch, tmp_path):
    import json
    import sys
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner
    from board.pynq_z2.scripts import verify_vision_integration_sources
    from pynq_multimodal_game.agent import cli

    events = []

    class RecoveryRequired(BaseException):
        pass

    class Voice:
        recorded_pcm = b""

        def start(self):
            events.append("voice_start")

        def status(self):
            if case == "camera_copy" and "camera_read" not in events:
                return {"state": "RUNNING"}
            if case in ("camera_recycle", "camera_yield") and events.count("camera_read") < 2:
                return {"state": "RUNNING"}
            return {"state": "STOPPED", "first_error": None, "packets": 900, "samples": 864000,
                    "cpu": {"submitted": 900, "received": 900},
                    "fault_diagnostic": {"capture_snapshot": {"live": 7}}}

        def stop(self):
            events.append("voice_stop")
            if case == "stop_failure":
                raise RuntimeError("voice stop failed")
            return self.status()

    class Camera:
        state = "NEW"
        last_read_timing = {"readframe_seconds": .001, "copy_seconds": .002, "return_seconds": .0001}
        dma = SimpleNamespace(mmio=SimpleNamespace(read=lambda offset: 0x11000 if "voice_stop" in events else 0))

        def read(self):
            assert self.state == "RUNNING" and ("voice_start" in events or case in ("camera_recycle", "camera_yield"))
            if case in ("camera_recycle", "camera_yield"):
                assert self.recycle_frames is True
                assert self.cooperative_copy is (case == "camera_yield")
            events.append("camera_read")
            return SimpleNamespace(shape=(720, 1280, 3))

        def start(self):
            events.append("camera_start")
            self.state = "RUNNING"
            if case == "camera_failure":
                self.state = "FAULT"
                raise RuntimeError("camera start failed")

        def stop(self):
            events.append("camera_stop")
            if case == "camera_retained":
                raise RuntimeError("camera halt unconfirmed")
            self.state = "STOPPED"

    class Backend:
        _voice = Voice()
        _library = SimpleNamespace(install_file=lambda *args, **kwargs: None)
        _game = SimpleNamespace(input_consumptions={"presented_frames": 3, "vision": {}, "audio": {}})
        _vision_supervisor = SimpleNamespace(status=lambda: {"state": "RUNNING"},
            _worker_factory=lambda run_id: SimpleNamespace(hardware=Camera()))

        def _stop_menu(self):
            events.append("menu_drain")

        def _prepare_voice(self):
            events.append("voice_prepare")

        @property
        def voice_status(self):
            return self._voice.status()

        def open(self):
            events.append("backend_open")

        def start_vision(self):
            events.append("vision_start")

        def start_game(self, game_id):
            if case in ("start_failure", "start_retained"):
                raise RuntimeError("capture start failed")

        def close(self):
            events.append("backend_close")
            if case in ("start_retained", "cleanup_failure"):
                raise RuntimeError("DMA halt unconfirmed")

    def retain(timeout=None):
        if timeout is not None:
            return
        receipts = list(tmp_path.glob("var/acceptance-*/receipt.json"))
        assert len(receipts) == 1
        events.append("receipt_before_wait")
        raise RecoveryRequired()

    session = SimpleNamespace(open=lambda: events.append("session_open"),
                              close=lambda: events.append("session_close"))
    monkeypatch.setattr(runner, "__file__", str(tmp_path / "start_board_test.py"))
    monkeypatch.setattr(runner, "sys", SimpleNamespace(platform="linux", version_info=(3, 10), path=[],
                        getswitchinterval=lambda: .005, setswitchinterval=lambda value: events.append(("switch_interval", value))))
    monkeypatch.setitem(sys.modules, "verify_vision_integration_sources", verify_vision_integration_sources)
    monkeypatch.setattr(runner.os, "geteuid", lambda: 0, raising=False)
    monkeypatch.setenv("XILINX_XRT", "/usr")
    monkeypatch.setenv("VVG_VISION_RUNTIME_DIR", str(tmp_path))
    original_import = runner.importlib.import_module
    monkeypatch.setattr(runner.importlib, "import_module", lambda name: SimpleNamespace(__file__="fixture")
                        if name in ("pynq", "numpy", "cv2", "collision", "tomli") else original_import(name))
    monkeypatch.setattr(runner, "require_no_existing_owner", lambda: None)
    monkeypatch.setattr(runner, "check_deployment", lambda root: {"games": {"game1-voice-s2": {"file": "game.vvg"}}})
    monkeypatch.setattr(runner, "threading", SimpleNamespace(Event=lambda: SimpleNamespace(wait=retain)))
    def create_backend(options):
        assert options.vision_pl_skin_mode == (skin_mode or "validate")
        return session, Backend()

    monkeypatch.setattr(cli, "_create_shared_vision_backend", create_backend)
    (tmp_path / "deployment_manifest.json").write_text("{}", encoding="utf-8")
    arguments = ["--live-board-test", "--mode", "fusion", "--allow-audio-dma-reset", "--physical-audio-confirmed"]
    if skin_mode is not None:
        arguments.extend(("--vision-pl-skin-mode", skin_mode))
    if case == "scheduler":
        arguments.append("--diagnostic-thread-switch")
    if case.startswith("camera_"):
        arguments[2] = "audio-vision"
        arguments.append("--diagnostic-camera-only")
    if case in ("camera_copy", "camera_recycle", "camera_yield"):
        arguments.append("--diagnostic-camera-copy")
    if case in ("camera_recycle", "camera_yield"):
        arguments.append("--diagnostic-camera-recycle")
    if case == "camera_yield":
        arguments.append("--diagnostic-camera-yield")
    if case in ("normal", "scheduler", "camera_only", "camera_copy", "camera_recycle", "camera_yield"):
        assert runner.main(arguments) == 0
    elif case in ("start_retained", "cleanup_failure", "camera_retained"):
        with pytest.raises(RecoveryRequired):
            runner.main(arguments)
    else:
        with pytest.raises(RuntimeError, match="capture start failed|voice stop failed|camera start failed"):
            runner.main(arguments)
    receipt = json.loads(next(tmp_path.glob("var/acceptance-*/receipt.json")).read_text(encoding="utf-8"))
    assert receipt["vision_pl_skin_mode"] == (skin_mode or "validate")
    assert receipt["audio"]["fault_diagnostic"]["capture_snapshot"]["live"] == 7
    assert receipt["vision"]["state"] == "RUNNING"
    assert receipt["game_receipts"]["presented_frames"] == 3
    assert "before_cleanup" in receipt["runtime_snapshots"] and "after_cleanup" in receipt["runtime_snapshots"]
    if case.startswith("start_"):
        assert receipt["first_error"] == "RuntimeError: capture start failed"
    if case == "stop_failure":
        assert receipt["first_error"] == "RuntimeError: voice stop failed"
    if case in ("start_retained", "cleanup_failure", "camera_retained"):
        assert receipt["cleanup_confirmed"] is False
        assert receipt["cleanup_error"] == ("RuntimeError: camera halt unconfirmed" if case == "camera_retained"
                                            else "RuntimeError: DMA halt unconfirmed")
        assert "session_close" not in events and events[-1] == "receipt_before_wait"
    else:
        assert receipt["cleanup_confirmed"] is True and events[-1] == "session_close"
    if case in ("normal", "scheduler", "camera_only", "camera_copy", "camera_recycle", "camera_yield"):
        assert receipt["capture_pass"] is True and "first_error" not in receipt
    if case.startswith("camera_"):
        assert "vision_start" not in events
        assert events.index("voice_prepare") < events.index("camera_start") < events.index("camera_stop")
        assert receipt["diagnostic_load"]["ps_vision_processing_enabled"] is False
        if case in ("camera_only", "camera_copy", "camera_recycle", "camera_yield"):
            assert events.index("camera_start") < events.index("voice_start") < events.index("voice_stop")
            assert events.index("camera_stop") < events.index("backend_close")
            assert receipt["diagnostic_load"]["frame_completion_observed"] is True
            assert receipt["diagnostic_load"]["camera_hardware_state_after_cleanup"] == "STOPPED"
        if case in ("camera_copy", "camera_recycle", "camera_yield"):
            assert receipt["diagnostic_load"]["camera_frames_copied"] == 1
            assert receipt["diagnostic_load"]["camera_frame_shape"] == [720, 1280, 3]
            assert receipt["diagnostic_load"]["camera_copy_max_seconds"] >= 0
            assert events.index("camera_read") < events.index("voice_stop")
        if case in ("camera_recycle", "camera_yield"):
            assert events.index("camera_read") < events.index("voice_start")
            assert events.count("camera_read") == 2
            assert receipt["diagnostic_load"]["camera_warmup_read_timing"] == Camera.last_read_timing
            assert receipt["diagnostic_load"]["camera_last_read_timing"] == Camera.last_read_timing
        if case == "camera_failure":
            assert receipt["first_error"] == "RuntimeError: camera start failed"
    if case == "scheduler":
        assert receipt["diagnostic_scheduler"]["original_thread_switch_seconds"] == .005
        assert receipt["diagnostic_scheduler"]["requested_thread_switch_seconds"] == .001
        assert receipt["diagnostic_scheduler"]["capture_deadlines_unchanged"] is True
        assert events[0] == ("switch_interval", .001)
    else:
        assert "diagnostic_scheduler" not in receipt
        assert not any(isinstance(event, tuple) for event in events)


def test_runner_rejects_unknown_skin_mode_before_deployment_check(monkeypatch):
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner
    monkeypatch.setattr(runner, "check_deployment", lambda root: pytest.fail("invalid mode reached deployment"))
    with pytest.raises(SystemExit) as error:
        runner.main(["--check-only", "--vision-pl-skin-mode", "unknown"])
    assert error.value.code == 2


@pytest.mark.parametrize("mode", ("audio-vision", "audio-gpu"))
def test_runner_diagnostic_audio_quiesces_gpu_before_preparation(mode):
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner

    events = []
    voice = SimpleNamespace(start=lambda: events.append("voice_start"))
    backend = SimpleNamespace(_voice=None, _stop_menu=lambda: events.append("menu_drain"),
                              start_vision=lambda: events.append("vision_start"))

    def prepare():
        events.append("voice_prepare")
        backend._voice = voice

    backend._prepare_voice = prepare
    assert runner.start_diagnostic_audio(backend, mode) is voice
    assert events == (["menu_drain", "vision_start", "voice_prepare", "voice_start"]
                      if mode == "audio-vision" else ["menu_drain", "voice_prepare", "voice_start"])


@pytest.mark.parametrize("condition", ("success", "unavailable", "worker_mismatch", "producer_mismatch"))
def test_runner_cpu_split_confirms_cpus_before_capture(monkeypatch, condition):
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner

    events = []
    affinity = {0} if condition == "unavailable" else {0, 1}
    monkeypatch.setattr(runner.os, "sched_getaffinity", lambda identifier: set(affinity), raising=False)

    def set_affinity(identifier, cpus):
        assert identifier == 0 and cpus == {0}
        events.append("producer_affinity")
        if condition != "producer_mismatch":
            affinity.clear()
            affinity.update(cpus)

    monkeypatch.setattr(runner.os, "sched_setaffinity", set_affinity, raising=False)

    def service_factory(*, bus, worker_cpu):
        assert bus == "fixture_bus" and worker_cpu == 1
        events.append("cpu_ready")
        return SimpleNamespace(_stream=SimpleNamespace(worker_cpu=0 if condition == "worker_mismatch" else 1),
                               close=lambda: events.append("cpu_close"))

    supervisor = SimpleNamespace(_service_factory=service_factory,
        _capture_factory=lambda: events.append("capture_created"))
    backend = SimpleNamespace(_voice_factory=lambda **options: supervisor)
    result = {}
    if condition == "unavailable":
        with pytest.raises(RuntimeError, match="available CPUs"):
            runner.configure_diagnostic_cpu_split(backend, result)
        assert events == [] and result == {}
        return
    runner.configure_diagnostic_cpu_split(backend, result)
    assert events == []
    assert backend._voice_factory(bus="fixture_bus") is supervisor
    if condition == "worker_mismatch":
        with pytest.raises(RuntimeError, match="worker did not confirm"):
            supervisor._service_factory(bus="fixture_bus")
        assert events == ["cpu_ready", "cpu_close"]
        return
    supervisor._service_factory(bus="fixture_bus")
    if condition == "producer_mismatch":
        with pytest.raises(RuntimeError, match="Producer did not confirm"):
            supervisor._capture_factory()
        assert "capture_created" not in events
        return
    supervisor._capture_factory()
    assert events == ["cpu_ready", "producer_affinity", "capture_created"]
    assert result["diagnostic_cpu_split"]["producer_original_cpus"] == [0, 1]
    assert result["diagnostic_cpu_split"]["producer_confirmed_cpus"] == [0]
    assert result["diagnostic_cpu_split"]["worker_confirmed_cpu"] == 1
    assert result["diagnostic_cpu_split"]["capture_deadlines_unchanged"] is True


def test_runner_runtime_snapshot_without_runtime():
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as runner

    result = {}
    runner.record_runtime_snapshot(result, None, None, "before_cleanup")
    assert result == {"runtime_snapshots": {"before_cleanup": {}}}


@pytest.mark.parametrize("case", ("running", "idle", "fault", "stop_error", "stop_unconfirmed",
                                 "prepare_error", "restart_error", "prior_voice",
                                 "starting_ready", "starting_timeout", "starting_fault",
                                 "restart_starting_ready", "restart_starting_timeout"))
def test_voice_preparation_quiesces_vision_without_starting_audio(case, monkeypatch):
    from pynq_multimodal_game.agent import voice_backend
    from pynq_multimodal_game.agent.voice_backend import C6IVoiceFusionRuntimeBackend
    events = []
    states = iter(("STARTING", "FAULT" if case == "starting_fault" else "RUNNING"))
    restarted = [False]
    clock = iter((0., 0., 31.) if case == "restart_starting_timeout" else (0., 31.))
    if "starting_" in case:
        monkeypatch.setattr(voice_backend, "threading", SimpleNamespace(
            Event=lambda: SimpleNamespace(wait=lambda timeout: events.append("vision_wait"))))
    if case in ("starting_timeout", "restart_starting_timeout"):
        monkeypatch.setattr(voice_backend.time, "monotonic", lambda: next(clock))

    def vision_status():
        state = "FAULT" if case == "fault" else "RUNNING"
        if case == "starting_timeout" or (case == "restart_starting_timeout" and restarted[0]):
            state = "STARTING"
        elif case in ("starting_ready", "starting_fault"):
            state = next(states, "RUNNING")
        elif case == "restart_starting_ready" and restarted[0]:
            state = next(states, "RUNNING")
        return {"state": state, "owner_held": case != "idle"}

    class Voice:
        def prepare(self):
            events.append("voice_prepare")
            if case == "prepare_error":
                raise RuntimeError("Codec deadline")

        def start(self):
            events.append("voice_start")

        def stop(self):
            events.append("voice_stop")

        def status(self):
            return {"state": "READY", "owner_released": False, "first_error": None}

    def stop():
        events.append("vision_stop")
        if case == "stop_error":
            raise RuntimeError("Vision DMA halt unconfirmed")
        return {"cleanup_confirmed": case != "stop_unconfirmed", "owner_held": False}

    def start():
        events.append("vision_start")
        restarted[0] = True
        if case == "restart_error":
            raise RuntimeError("Vision restart failed")

    backend = object.__new__(C6IVoiceFusionRuntimeBackend)
    backend._game = None
    backend._voice = Voice() if case == "prior_voice" else None
    backend._voice_bus = object()
    backend._voice_factory = lambda **kwargs: Voice()
    backend._vision_supervisor = SimpleNamespace(
        status=vision_status, stop=stop, start=start)
    failures = {
        "fault": ("Prior vision cleanup", []),
        "stop_error": ("Vision DMA halt unconfirmed", ["vision_stop"]),
        "stop_unconfirmed": ("Vision stop unconfirmed", ["vision_stop"]),
        "prepare_error": ("Codec deadline", ["vision_stop", "voice_prepare"]),
        "restart_error": ("Vision restart failed", ["vision_stop", "voice_prepare", "vision_start", "voice_stop"]),
        "prior_voice": ("Prior voice cleanup", []),
        "starting_timeout": ("Vision startup not ready", []),
        "starting_fault": ("Prior vision cleanup", ["vision_wait"]),
        "restart_starting_timeout": ("Vision startup not ready", ["vision_stop", "voice_prepare", "vision_start", "voice_stop"]),
    }
    if case in failures:
        error, expected = failures[case]
        with pytest.raises(RuntimeError, match=error):
            backend._prepare_voice()
    else:
        backend._prepare_voice()
        expected = ["voice_prepare"] if case == "idle" else ["vision_stop", "voice_prepare", "vision_start"]
        if case == "starting_ready":
            expected.insert(0, "vision_wait")
        if case == "restart_starting_ready":
            expected.append("vision_wait")
    assert events == expected and "voice_start" not in events


@pytest.mark.parametrize('prepare_error', (False, True))
def test_pl_voice_preparation_never_stops_or_restarts_vision(prepare_error):
    from pynq_multimodal_game.agent.vision_pl_fusion import C6IPlVoiceFusionRuntimeBackend
    events = []

    class Voice:
        def prepare(self):
            events.append('voice_prepare')
            if prepare_error:
                raise RuntimeError('injected Codec deadline')

        def status(self):
            return {'state': 'RETAINED' if prepare_error else 'READY', 'first_error': None}

    backend = object.__new__(C6IPlVoiceFusionRuntimeBackend)
    backend._game, backend._voice, backend._voice_bus = None, None, object()
    backend._voice_factory = lambda **options: Voice()
    backend._vision_supervisor = SimpleNamespace(
        status=lambda: {'state': 'IDLE', 'owner_held': False},
        stop=lambda: pytest.fail('PL vision stop during audio preparation'),
        start=lambda: pytest.fail('PL vision restart during audio preparation'))
    if prepare_error:
        with pytest.raises(RuntimeError, match='Codec deadline'):
            backend._prepare_voice()
    else:
        backend._prepare_voice()
    assert events == ['voice_prepare']
    if prepare_error:
        with pytest.raises(RuntimeError, match='audio epoch is one-shot'):
            backend._prepare_voice()
    else:
        backend._prepare_voice()
    assert events == ['voice_prepare']


def test_pl_audio_preallocation_precedes_single_vision_arm(monkeypatch):
    from pynq_multimodal_game.agent.vision_backend import C6IVisionRuntimeBackend
    from pynq_multimodal_game.agent.vision_pl_fusion import C6IPlVoiceFusionRuntimeBackend
    events = []
    backend = object.__new__(C6IPlVoiceFusionRuntimeBackend)
    backend._vision_epoch_started = False
    backend._prepare_voice = lambda: events.append('audio_preallocated')
    backend._vision_supervisor = SimpleNamespace(status=lambda: {'state': 'IDLE', 'owner_held': False})

    def start_vision(self):
        events.append('vision_arm')
        raise RuntimeError('injected vision failure')

    monkeypatch.setattr(C6IVisionRuntimeBackend, 'start_vision', start_vision)
    with pytest.raises(RuntimeError, match='injected vision failure'):
        backend.start_vision()
    with pytest.raises(RuntimeError, match='vision epoch is one-shot'):
        backend.start_vision()
    assert events == ['audio_preallocated', 'vision_arm']


def test_pl_audio_cannot_allocate_after_vision_arm():
    from pynq_multimodal_game.agent.vision_pl_fusion import C6IPlVoiceFusionRuntimeBackend
    backend = object.__new__(C6IPlVoiceFusionRuntimeBackend)
    backend._voice = None
    backend._vision_supervisor = SimpleNamespace(status=lambda: {'state': 'RUNNING', 'owner_held': True})
    backend._voice_factory = lambda **options: pytest.fail('late audio allocation')
    with pytest.raises(RuntimeError, match='must precede vision ARM'):
        backend._prepare_voice()


@pytest.mark.parametrize('prior', ('new', 'unproven', 'released'))
def test_pl_native_ready_without_cleanup_field_requires_own_prepared_identity(prior):
    from pynq_multimodal_game.agent.voice_backend import NativeVoiceSupervisor
    from pynq_multimodal_game.agent.vision_pl_fusion import C6IPlVoiceFusionRuntimeBackend
    events = []
    voice = NativeVoiceSupervisor(lambda: pytest.fail('no hardware allocation in model'))
    voice._state = 'READY'
    assert 'owner_released' not in voice.status()
    voice.prepare = lambda: events.append('prepare')
    backend = object.__new__(C6IPlVoiceFusionRuntimeBackend)
    backend._voice = None if prior == 'new' else voice
    backend._prepared_voice = voice if prior == 'released' else None
    backend._voice_factory = lambda **options: voice
    backend._voice_bus, backend._game = object(), None
    backend._vision_supervisor = SimpleNamespace(status=lambda: {'state': 'IDLE', 'owner_held': False})
    if prior == 'released':
        voice._cleanup = {'owner_released': True}
    if prior == 'new':
        backend._prepare_voice()
        backend._prepare_voice()
        assert events == ['prepare'] and backend._prepared_voice is voice
    else:
        with pytest.raises(RuntimeError, match='audio epoch is one-shot'):
            backend._prepare_voice()
        assert events == []


def test_pl_native_voice_start_does_not_pause_continuous_vision():
    from pynq_multimodal_game.agent.voice_backend import NativeVoiceSupervisor
    from pynq_multimodal_game.agent.vision_pl_fusion import C6IPlVoiceFusionRuntimeBackend
    events = []
    voice = object.__new__(NativeVoiceSupervisor)
    voice.start = lambda: events.append('voice_start')
    backend = object.__new__(C6IPlVoiceFusionRuntimeBackend)
    backend._voice = voice
    backend._game = SimpleNamespace(
        pause=lambda: events.append('game_pause'),
        resume_audio=lambda: events.append('game_audio_resume'),
        _live_input=SimpleNamespace(prepare_audio_rearm=lambda: events.append('audio_rearm')))
    backend._vision_supervisor = SimpleNamespace(
        pause_processing=lambda: pytest.fail('PL vision processing paused'),
        resume_processing=lambda: pytest.fail('PL vision processing resumed'))
    backend._start_voice()
    assert events == ['game_pause', 'audio_rearm', 'voice_start', 'game_audio_resume']
    assert backend._voice_starting is False


def test_pl_hwh_gate_is_separate_from_legacy_audio_gate(tmp_path):
    from xml.etree import ElementTree as ET
    from pynq_multimodal_game.agent.voice_fusion import DMA_PARAMETERS, verify_audio_hwh
    from pynq_multimodal_game.agent.vision_pl_fusion import verify_pl_hwh
    root = ET.Element('SYSTEMINFO')
    modules = ET.SubElement(root, 'MODULES')

    def module(name, parameters, modtype=''):
        result = ET.SubElement(modules, 'MODULE', INSTANCE=name, MODTYPE=modtype)
        parent = ET.SubElement(result, 'PARAMETERS')
        for key, value in parameters.items():
            ET.SubElement(parent, 'PARAMETER', NAME=key, VALUE=str(value))
        return result

    module('build_id_constant', {'CONST_VAL': '0xC0060B00'})
    module('voice_pcm_dma', DMA_PARAMETERS, 'axi_dma')
    module('voice_capture', {}, 'voice_i2s_dma_capture_axi')
    module('voice_codec_iic', {}, 'axi_iic')
    for name, base in (('voice_pcm_dma', 0x40430000), ('voice_capture', 0x413E0000), ('voice_codec_iic', 0x43C10000)):
        ET.SubElement(root, 'MEMRANGE', INSTANCE=name, MEMTYPE='REGISTER', BASEVALUE=hex(base), HIGHVALUE=hex(base+0xFFFF))
    module('frame_dma', dict(C_INCLUDE_MM2S=0, C_INCLUDE_S2MM=1, C_INCLUDE_SG=0,
                            C_NUM_FSTORES=3, C_M_AXI_S2MM_DATA_WIDTH=64, C_S_AXIS_S2MM_TDATA_WIDTH=24,
                            C_INCLUDE_S2MM_DRE=0, C_INCLUDE_S2MM_SF=1, C_USE_FSYNC=1))
    packet = module('moments_dma', dict(C_INCLUDE_MM2S=0, C_INCLUDE_S2MM=1, C_INCLUDE_SG=1,
                                       C_M_AXI_S2MM_DATA_WIDTH=64, C_S_AXIS_S2MM_TDATA_WIDTH=64,
                                       C_M_AXI_SG_DATA_WIDTH=32, C_INCLUDE_S2MM_DRE=0, C_INCLUDE_S2MM_SF=1))
    status = module('capture_status', {})
    ports = ET.SubElement(status, 'PORTS')
    arm = ET.SubElement(ports, 'PORT', NAME='capture_armed', DIR='I')
    connections = ET.SubElement(arm, 'CONNECTIONS')
    connection = ET.SubElement(connections, 'CONNECTION', INSTANCE='capture_control', PORT='armed')
    while len(modules) < 62:
        module('unused_' + str(len(modules)), {})
    path = tmp_path / 'candidate.hwh'
    ET.ElementTree(root).write(path, encoding='utf-8')
    verify_pl_hwh(path)
    with pytest.raises(ValueError, match='BUILD_ID'):
        verify_audio_hwh(path)
    connection.set('PORT', 'abort_requested')
    ET.ElementTree(root).write(path, encoding='utf-8')
    with pytest.raises(ValueError, match='ARM connection'):
        verify_pl_hwh(path)
    connection.set('PORT', 'armed')
    packet.find("PARAMETERS/PARAMETER[@NAME='C_INCLUDE_SG']").set('VALUE', '0')
    ET.ElementTree(root).write(path, encoding='utf-8')
    with pytest.raises(ValueError, match='DMA capability'):
        verify_pl_hwh(path)


def test_pl_cpu_accounting_includes_children_and_excludes_guest_double_count(tmp_path):
    from board.pynq_z2.scripts.run_pl_voice_fusion_acceptance import cpu_snapshot, cpu_usage

    def process(pid, parent, user, system, waited):
        directory = tmp_path / str(pid)
        directory.mkdir(exist_ok=True)
        fields = ['S', str(parent)] + ['0'] * 50
        fields[11:15] = [str(user), str(system), str(waited), '0']
        fields[19] = str(pid * 10)
        (directory / 'stat').write_text(f'{pid} (worker with ) name) ' + ' '.join(fields))

    process(100, 1, 20, 10, 5)
    process(101, 100, 30, 5, 0)
    process(102, 101, 10, 5, 0)
    process(900, 1, 99999, 99999, 0)
    (tmp_path / 'stat').write_text('cpu 100 0 100 300 100 0 0 0 99 99\n')
    before = cpu_snapshot(tmp_path, pid=100, ticks_per_second=100)
    assert set(before['processes']) == {'100', '101', '102'}
    assert before['family_ticks'] == 85 and before['system_total'] == 600
    process(100, 1, 45, 20, 5)
    process(101, 100, 80, 20, 0)
    (tmp_path / 'stat').write_text('cpu 160 0 140 400 100 0 0 0 199 199\n')
    after = cpu_snapshot(tmp_path, pid=100, ticks_per_second=100)
    usage = cpu_usage(before, after, 1., cores=2)
    assert usage['family_percent_one_core_100'] == 100
    assert usage['family_percent_capacity'] == 50
    assert usage['system_busy_percent'] == 50
    with pytest.raises(ValueError, match='Stable CPU owner'):
        cpu_usage(before, {**after, 'owner_start': 9999}, 1., cores=2)


def test_pl_live_gate_is_closed_without_current_owner_receipt(tmp_path, monkeypatch):
    from board.pynq_z2.scripts import run_pl_voice_fusion_acceptance as runner
    monkeypatch.setattr(runner, 'check_deployment', lambda root: {})
    monkeypatch.setattr(runner.sys, 'platform', 'linux')
    monkeypatch.setattr(runner.sys, 'version_info', (3, 10))
    monkeypatch.setattr(runner.os, 'geteuid', lambda: 0, raising=False)
    with pytest.raises(FileNotFoundError, match='not-authorized.json'):
        runner.main(['--live-board-test', '--allow-audio-dma-reset', '--physical-audio-confirmed',
                     '--owner-preflight', str(tmp_path / 'not-authorized.json')])


@pytest.mark.parametrize('fault', ('none', 'stale', 'boot', 'dma', 'download'))
def test_pl_owner_guard_locks_download_and_retains_unconfirmed_load(tmp_path, monkeypatch, fault):
    import json
    from contextlib import contextmanager
    from board.pynq_z2 import vision_owner_gate as gate
    events = []
    current = {'monotonic_ns': 100_000_000_000, 'owner_identity_gate_passed': True,
               'hardware_operations': False, 'boot_id': 'boot', 'active_pair': ['bit', 'hwh'],
               'build_id': '0xc0060900', 'audio_journal_sha256': 'clean', 'dma': [1, 2, 3, 4, 5, 6]}
    expected = dict(current)
    if fault == 'stale':
        expected['monotonic_ns'] = 1
    if fault == 'boot':
        expected['boot_id'] = 'other'
    if fault == 'dma':
        expected['dma'] = [1]
    receipt = tmp_path / 'owner.json'
    receipt.write_text(json.dumps(expected))

    @contextmanager
    def locked(c6i_lock):
        assert c6i_lock is session._lock_file
        events.append('both_locks_held')
        yield current
        events.append('audio_lock_released')

    def loader(path, *, download):
        assert events == ['both_locks_held'] and download is True
        events.append('download')
        if fault == 'download':
            raise RuntimeError('injected partial download')
        return 'overlay'

    session = gate.PlGuardedOverlaySession(tmp_path / 'candidate.bit', owner_preflight=receipt,
                                           overlay_factory=loader, require_root=False)
    session._lock_file = object()
    monkeypatch.setattr(gate, 'locked_idle_board', locked)
    if fault in ('stale', 'boot', 'dma'):
        with pytest.raises(RuntimeError, match='matching owner preflight'):
            session._guarded_load('candidate.bit', download=True)
        assert 'download' not in events and session._download_gate_pending is False
    else:
        if fault == 'download':
            with pytest.raises(RuntimeError, match='injected partial download'):
                session._guarded_load('candidate.bit', download=True)
        else:
            assert session._guarded_load('candidate.bit', download=True) == 'overlay'
            assert events == ['both_locks_held', 'download']
        with pytest.raises(RuntimeError, match='retain exclusive owner'):
            session.close()
        with pytest.raises(RuntimeError, match='download cannot be retried'):
            session.open()
        assert session._lock_file is not None
        session._download_context.__exit__(None, None, None)


@pytest.mark.parametrize('build_id,expected_count', ((0xC0060900, 6), (0xC0060B00, 4), (0xC0060800, None)))
def test_pl_owner_dma_inventory_is_exact_for_each_hardware_build(build_id, expected_count):
    from board.pynq_z2.vision_owner_gate import _dma_inventory
    if expected_count is None:
        with pytest.raises(ValueError, match='Audited BUILD'):
            _dma_inventory(build_id)
        return
    inventory = _dma_inventory(build_id)
    assert len(inventory) == expected_count
    assert (('moments_dma', 'MM2S') in inventory) is (build_id == 0xC0060900)
    assert (('return_dma', 'S2MM') in inventory) is (build_id == 0xC0060900)
    assert {('axi_dma', 'MM2S'), ('moments_dma', 'S2MM'),
            ('voice_pcm_dma', 'S2MM'), ('frame_dma', 'S2MM')} <= inventory


@pytest.mark.parametrize('wrong_address', (False, True))
def test_pl_owner_b00_audit_uses_canonical_capture_map(tmp_path, monkeypatch, wrong_address):
    import hashlib
    import json
    import struct
    from types import SimpleNamespace
    from xml.etree import ElementTree as ET
    from board.pynq_z2 import vision_owner_gate as gate
    from pynq_multimodal_game.agent import vision_pl_fusion as fusion

    active = tmp_path / 'candidate.bit'
    active.write_bytes(b'synthetic canonical bit identity')
    addresses = {'axi_dma': 0x40400000, 'moments_dma': 0x40420000, 'voice_pcm_dma': 0x40430000,
                 'frame_dma': 0x43000000, 'build_id_gpio': 0x41200000, 'voice_capture': 0x413E0000,
                 'capture_control': 0x41400000 if wrong_address else 0x413F0000, 'capture_status': 0x41410000}
    tree = ET.Element('SYSTEM')
    for name, address in addresses.items():
        ET.SubElement(tree, 'MEMRANGE', INSTANCE=name, BASEVALUE=hex(address))
        module = ET.SubElement(tree, 'MODULE', INSTANCE=name)
        parameters = ET.SubElement(module, 'PARAMETERS')
        for direction in ('MM2S', 'S2MM'):
            ET.SubElement(parameters, 'PARAMETER', NAME='C_INCLUDE_' + direction,
                          VALUE=str(int((name, direction) in gate._dma_inventory(0xC0060B00))))
    active.with_suffix('.hwh').write_bytes(ET.tostring(tree))
    monkeypatch.setattr(fusion, 'BIT_SHA256', hashlib.sha256(active.read_bytes()).hexdigest())
    monkeypatch.setattr(fusion, 'HWH_SHA256', hashlib.sha256(active.with_suffix('.hwh').read_bytes()).hexdigest())
    baseline = tmp_path / 'baseline'
    baseline.mkdir()
    baseline_manifest = baseline / 'deployment_manifest.json'
    baseline_manifest.write_text(json.dumps({'sha256': {'overlay/c6v_candidate.bit': 'old-bit',
                                                       'overlay/c6v_candidate.hwh': 'old-hwh'}}))
    monkeypatch.setattr(gate, 'BASELINE', baseline)
    monkeypatch.setattr(gate, 'BASELINE_MANIFEST_SHA256', hashlib.sha256(baseline_manifest.read_bytes()).hexdigest())
    pynq_root = tmp_path / 'pynq'
    state = pynq_root / 'pl_server/global_pl_state_.json'
    state.parent.mkdir(parents=True)
    state.write_text(json.dumps({'bitfile_name': str(active)}))
    monkeypatch.setattr(gate, 'distribution', lambda name: SimpleNamespace(locate_file=lambda _: pynq_root))
    monkeypatch.setattr(gate, '_verify_no_business_owner', lambda: None)
    original_read = gate.Path.read_text

    def read_text(path, *args, **kwargs):
        if path.as_posix() == '/sys/class/fpga_manager/fpga0/state':
            return 'operating'
        if path.as_posix() == '/proc/sys/kernel/random/boot_id':
            return 'synthetic-boot'
        return original_read(path, *args, **kwargs)

    monkeypatch.setattr(gate.Path, 'read_text', read_text)
    opened = []
    original_open, original_close = gate.os.open, gate.os.close

    def open_memory(path, flags, *args, **kwargs):
        if path == '/dev/mem':
            opened.append(path)
            return 987654
        return original_open(path, flags, *args, **kwargs)

    monkeypatch.setattr(gate.os, 'open', open_memory)
    monkeypatch.setattr(gate.os, 'close', lambda descriptor: None if descriptor == 987654 else original_close(descriptor))
    for name in ('O_SYNC', 'O_CLOEXEC'):
        monkeypatch.setattr(gate.os, name, getattr(gate.os, name, 0), raising=False)
    registers = {addresses['build_id_gpio']: {0: 0xC0060B00},
                 addresses['voice_capture']: {0: 0x56535431, 0x24: 0x10001},
                 addresses['capture_status']: {0: 0x31545356, 4: 0x10000, 8: 3, 16: 7},
                 addresses['capture_control']: {0: 0x31435456, 4: 0x20000, 8: 5, 0x4C: 4, 0x5C: 1, 0x60: 1}}
    for name, direction in gate._dma_inventory(0xC0060B00):
        registers[addresses[name]] = {4 if direction == 'MM2S' else 0x34: 1}

    class Window(bytearray):
        def __enter__(self):
            return self

        def __exit__(self, *args):
            return False

    def memory(descriptor, length, *, access, offset):
        assert descriptor == 987654 and access == gate.mmap.ACCESS_READ
        window = Window(length)
        for register, value in registers[offset].items():
            struct.pack_into('<I', window, register, value)
        return window

    monkeypatch.setattr(gate.mmap, 'mmap', memory)
    if wrong_address:
        with pytest.raises(RuntimeError, match='Active HWH address identity changed'):
            gate._audit_idle_hardware()
        assert not opened
    else:
        report = gate._audit_idle_hardware()
        assert report['source_quiescent'] and report['prior_epoch'] == 7
        assert len(report['dma']) == 4 and report['owner_identity_gate_passed']
        assert opened == ['/dev/mem']


@pytest.mark.parametrize('fault', ('none', 'parent', 'owner_argument', 'ready_owner', 'ready_monitor',
                                 'missing_ready', 'invalid_ready', 'script', 'executable', 'directory',
                                 'nested_directory', 'extra_argument', 'business', 'missing_stat',
                                 'invalid_stat', 'other_business'))
def test_pl_owner_only_accepts_verified_read_only_startup_monitor(tmp_path, monkeypatch, fault):
    import json
    from pathlib import Path
    from board.pynq_z2 import vision_owner_gate as gate
    root = tmp_path / 'runtime'
    runner = root / 'board/pynq_z2/scripts/run_pl_voice_fusion_acceptance.py'
    directory = root / ('other/fusion-test' if fault == 'directory' else
                        'var/nested/fusion-test' if fault == 'nested_directory' else 'var/fusion-test')
    directory.mkdir(parents=True)
    ready = {'owner_pid': gate.os.getpid(), 'monitor_pid': 201}
    if fault == 'ready_owner':
        ready['owner_pid'] += 1
    if fault == 'ready_monitor':
        ready['monitor_pid'] += 1
    if fault != 'missing_ready':
        (directory / 'startup-monitor-ready.json').write_text('broken' if fault == 'invalid_ready' else json.dumps(ready))
    process = tmp_path / 'proc/201'
    process.mkdir(parents=True)
    parent = gate.os.getpid() + 1 if fault == 'parent' else gate.os.getpid()
    if fault != 'missing_stat':
        (process / 'stat').write_text('broken' if fault == 'invalid_stat' else f'201 (python) S {parent} 0')
    arguments = [gate.sys.executable, '-B', str(runner), '--startup-monitor', '--monitor-pid',
                 str(gate.os.getpid()), '--monitor-directory', str(directory)]
    if fault == 'owner_argument':
        arguments[5] = str(gate.os.getpid() + 1)
    if fault == 'script':
        arguments[2] = str(root / 'other/run_pl_voice_fusion_acceptance.py')
    if fault == 'executable':
        arguments[0] += '-other'
    if fault == 'extra_argument':
        arguments.append('--live-board-test')
    if fault == 'business':
        arguments = arguments[:3] + ['--live-board-test']
    (process / 'cmdline').write_bytes(('\0'.join(arguments) + '\0').encode())
    if fault == 'other_business':
        other = process.parent / '202'
        other.mkdir()
        (other / 'cmdline').write_bytes(b'python\0run_voice_fusion_acceptance.py\0')

    def mapped_path(*parts):
        value = str(parts[0])
        if value == '/proc' or value.startswith('/proc/'):
            return tmp_path / 'proc' / value[6:]
        return Path(*parts)

    monkeypatch.setattr(gate, '__file__', str(root / 'board/pynq_z2/vision_owner_gate.py'))
    monkeypatch.setattr(gate, 'Path', mapped_path)
    monkeypatch.setattr(gate.os, 'getppid', lambda: 1)
    if fault == 'none':
        gate._verify_no_business_owner()
    else:
        with pytest.raises(RuntimeError, match='Existing hardware business owner PID'):
            gate._verify_no_business_owner()


@pytest.mark.parametrize('fault', ('none', 'download', 'consumed'))
def test_pl_owner_cold_boot_download_is_one_shot(tmp_path, monkeypatch, fault):
    import json
    from contextlib import contextmanager
    from pathlib import Path
    from board.pynq_z2 import vision_owner_gate as gate
    events = []
    current = {'monotonic_ns': 1, 'owner_identity_gate_passed': True,
               'hardware_operations': False, 'boot_id': 'new-boot', 'cold_boot': True,
               'active_pair': ['base-bit', 'base-hwh'], 'build_id': 'official-base',
               'audio_journal_sha256': 'empty', 'dma': [1], 'services': {'bootpy': 'done'}}
    receipt = tmp_path / 'owner.json'
    receipt.write_text(json.dumps(current))
    marker = tmp_path / 'voice-view-cold-new-boot.attempt'
    if fault == 'consumed':
        marker.write_text('prior attempt')

    @contextmanager
    def locked(c6i_lock, *, cold_boot_id):
        assert cold_boot_id == 'new-boot'
        events.append('both_locks')
        yield current
        events.append('released')

    def loader(path, *, download):
        assert marker.exists() and download is True
        assert json.loads(marker.read_text()) == current
        events.append('download')
        if fault == 'download':
            raise RuntimeError('injected cold download failure')
        return 'overlay'

    def mapped_path(*parts):
        return tmp_path if parts == ('/run/lock',) else Path(*parts)

    monkeypatch.setattr(gate, 'Path', mapped_path)
    monkeypatch.setattr(gate, 'locked_idle_board', locked)
    session = gate.PlGuardedOverlaySession(tmp_path / 'candidate.bit', owner_preflight=receipt,
                                           overlay_factory=loader, require_root=False)
    session._lock_file = object()
    if fault == 'none':
        assert session._guarded_load('candidate.bit', download=True) == 'overlay'
    elif fault == 'download':
        with pytest.raises(RuntimeError, match='injected cold download failure'):
            session._guarded_load('candidate.bit', download=True)
    else:
        with pytest.raises(FileExistsError):
            session._guarded_load('candidate.bit', download=True)
        assert 'download' not in events and marker.read_text() == 'prior attempt'
    with pytest.raises(RuntimeError, match='retain exclusive owner'):
        session.close()
    with pytest.raises(RuntimeError, match='cannot be retried'):
        session.open()
    assert marker.exists()
    session._download_context.__exit__(None, None, None)


@pytest.mark.parametrize('changed', ('boot_id', 'cold_boot', 'services', 'dma', 'active_pair', 'audio_journal_sha256'))
def test_pl_owner_cold_preflight_rejects_changed_evidence(changed):
    from board.pynq_z2.vision_owner_gate import validate_preflight
    current = {'monotonic_ns': 1, 'owner_identity_gate_passed': True,
               'hardware_operations': False, 'boot_id': 'boot', 'cold_boot': True,
               'services': {'bootpy': 'done'}, 'dma': [1], 'active_pair': ['bit', 'hwh'],
               'audio_journal_sha256': 'empty'}
    expected = dict(current)
    expected[changed] = 'changed'
    with pytest.raises(RuntimeError, match='matching owner preflight'):
        validate_preflight(expected, current)


@pytest.mark.parametrize('journal', (b'', b'{"state":"ACTIVE"}', b'corrupt'))
def test_pl_owner_cold_boot_reads_journal_from_start(tmp_path, monkeypatch, journal):
    import sys
    from board.pynq_z2 import vision_owner_gate as gate
    audio = tmp_path / 'audio.lock'
    audio.write_bytes(journal)
    monkeypatch.setattr(gate, 'OWNER_LOCK', tmp_path / 'owner.lock')
    monkeypatch.setattr(gate, 'AUDIO_LOCK', audio)
    monkeypatch.setitem(sys.modules, 'fcntl', SimpleNamespace(LOCK_EX=2, LOCK_NB=4, flock=lambda *args: None))
    audited = []

    def audit(boot_id):
        audited.append(boot_id)
        return {'cold_boot': True}

    monkeypatch.setattr(gate, '_audit_cold_boot', audit)
    if journal:
        with pytest.raises(RuntimeError, match='empty initial audio journal'):
            with gate.locked_idle_board(cold_boot_id='boot'):
                pytest.fail('Dirty journal accepted')
        assert audited == []
    else:
        with gate.locked_idle_board(cold_boot_id='boot') as report:
            assert report['cold_boot'] is True
        assert audited == ['boot']
    assert audio.read_bytes() == journal


def test_pl_owner_audio_lock_spans_build_readback(tmp_path, monkeypatch):
    import json
    from contextlib import contextmanager
    from board.pynq_z2 import vision_owner_gate as gate
    events = []
    current = {'monotonic_ns': 1, 'owner_identity_gate_passed': True, 'hardware_operations': False}
    receipt = tmp_path / 'owner.json'
    receipt.write_text(json.dumps(current))

    @contextmanager
    def locked(c6i_lock):
        events.append('both_locks_held')
        yield current
        events.append('audio_lock_released')

    def load(path, *, download):
        events.append('download')
        return 'overlay'

    def verified_open(self):
        self._guarded_load('candidate.bit', download=True)
        assert events == ['both_locks_held', 'download']
        events.append('build_verified')
        return self

    monkeypatch.setattr(gate, 'locked_idle_board', locked)
    monkeypatch.setattr(gate.C6IOverlaySession, 'open', verified_open)
    session = gate.PlGuardedOverlaySession(tmp_path / 'candidate.bit', owner_preflight=receipt,
                                           overlay_factory=load, require_root=False)
    session._lock_file = object()
    assert session.open() is session
    assert events == ['both_locks_held', 'download', 'build_verified', 'audio_lock_released']
    assert not session._download_gate_pending and session._download_context is None


def test_pl_voice_preparation_accepts_prewarmed_unarmed_vision():
    from unittest.mock import MagicMock
    from pynq_multimodal_game.agent.vision_backend import SharedVisionSupervisor
    from pynq_multimodal_game.agent.vision_pl_fusion import C6IPlVoiceFusionRuntimeBackend
    from pynq_multimodal_game.vision_input import VisionInputProvider
    worker = SimpleNamespace(state='IDLE', error=None, frame_id=0, diagnostic_error=None,
                             prepare_preview=MagicMock())
    supervisor = SharedVisionSupervisor(lambda _: worker, VisionInputProvider())
    supervisor.prepare()
    backend = object.__new__(C6IPlVoiceFusionRuntimeBackend)
    backend._vision_supervisor, backend._voice, backend._voice_bus = supervisor, None, object()
    voice = SimpleNamespace(prepare=MagicMock())
    backend._voice_factory = MagicMock(return_value=voice)
    backend._prepare_voice()
    assert backend._voice is voice and backend._prepared_voice is voice
    voice.prepare.assert_called_once()
    worker.prepare_preview.assert_called_once()
    assert supervisor.status()['state'] == 'IDLE' and not supervisor.status()['owner_held']


@pytest.mark.parametrize('vision_only', (False, True))
@pytest.mark.parametrize('vision_fault,stage_failure', ((False, False), (True, False), (True, True)))
def test_pl_full_runner_normal_stop_or_retain_without_cleanup(tmp_path, monkeypatch, vision_fault, stage_failure,
                                                             vision_only):
    import json
    from contextlib import contextmanager
    from board.pynq_z2.scripts import run_pl_voice_fusion_acceptance as runner
    from board.pynq_z2.scripts import run_voice_fusion_acceptance as legacy
    from board.pynq_z2 import vision_owner_gate
    from pynq_multimodal_game.agent import vision_pl_fusion
    events = []
    directory = tmp_path / ('fusion-' + '11223344' * 4)
    directory.mkdir()
    (tmp_path / 'deployment_manifest.json').write_text('{}')
    audio = {'state': 'STOPPED', 'first_error': None, 'packets': 900, 'samples': 864000,
             'owner_released': True, 'cpu': {'submitted': 900, 'received': 900}}
    vision = {'state': 'FAULT' if vision_fault else 'RUNNING', 'frame_id': 7,
              'last_error': 'injected vision fault' if vision_fault else None}
    voice = SimpleNamespace(status=lambda: audio, recorded_pcm=bytes(864000 * 4))
    session = SimpleNamespace(is_open=True, _download_gate_pending=False, _lock_file=object(),
                               download_receipt={'hardware_operations': False},
                               open=lambda: events.append('download'))

    def close_owner():
        events.append('owner_close')
        session.is_open = False

    session.close = close_owner
    backend = SimpleNamespace(_voice=voice, voice_status=audio,
        _library=SimpleNamespace(install_file=lambda *args, **kwargs: events.append('install_game')),
        _vision_supervisor=SimpleNamespace(status=lambda: vision),
        _game=SimpleNamespace(last_error=None, input_consumptions={'presented_frames': 20, 'vision': {}, 'audio': {}}),
        open=lambda: events.append('gpu_open'), start_vision=lambda: events.append('audio_prepare_then_vision'),
        start_game=lambda game: events.append('game_then_audio_start'), close=lambda: events.append('backend_stop'))
    backend.prepare_vision = lambda: events.append('preview_prepare')
    if vision_only:
        del backend._voice

    def start_game(game):
        backend._diagnostic_startup_stage('game_worker_start_begin')
        backend._diagnostic_startup_stage('game_first_scene_submit_complete')
        if not vision_only:
            backend._diagnostic_startup_stage('voice_capture_start_begin')
        events.append('game_then_audio_start')

    backend.start_game = start_game
    def load_native(*args):
        assert not vision_only
        return object()

    def create_backend(*args, **kwargs):
        assert kwargs.get('vision_only', False) is vision_only
        assert (kwargs['native_transport'] is None) is vision_only
        return session, backend

    def observe(target, duration):
        assert target is backend and duration == 20 and not hasattr(target, '_voice')
        events.append('observe_vision_gpu')
        return dict(diagnostic_only=True, vision_gpu_pass=True, capture_pass=False, three_way_observed=False)

    monkeypatch.setattr(legacy, 'load_diagnostic_native_voice', load_native)
    monkeypatch.setattr(vision_pl_fusion, 'create_pl_backend', create_backend)
    monkeypatch.setattr(runner, 'observe_vision_gpu', observe)
    clock = iter((1., 2., 3.))
    monkeypatch.setattr(runner, 'time', SimpleNamespace(monotonic=lambda: next(clock), monotonic_ns=lambda: 123))
    snapshots = iter({'owner_pid': 100, 'owner_start': 1, 'ticks_per_second': 100,
                      'family_ticks': step * 10, 'system_total': 100 + step * 100,
                      'system_idle': step * 50} for step in range(3))
    monkeypatch.setattr(runner, 'cpu_snapshot', lambda: next(snapshots))
    monkeypatch.setattr(runner.os, 'sched_getaffinity', lambda pid: {0, 1}, raising=False)
    monkeypatch.setattr(runner, '_RETAINED', [])
    if stage_failure:
        write_stage = runner.startup_stage

        def unavailable_stage(directory, stage):
            if stage == 'first_error':
                raise OSError('injected stage journal unavailable')
            write_stage(directory, stage)

        monkeypatch.setattr(runner, 'startup_stage', unavailable_stage)

    @contextmanager
    def stopped(c6i_lock, **kwargs):
        assert c6i_lock is session._lock_file and events[-1] == 'backend_stop'
        assert kwargs == (dict(vision_only_epoch=0x11223344) if vision_only else {})
        events.append('verify_hardware_stop')
        yield {'prior_epoch': 0x11223344, 'dma': ['five halted B00 directions']}

    monkeypatch.setattr(vision_owner_gate, 'locked_idle_board', stopped)
    options = SimpleNamespace(game='game1-voice-s2', owner_preflight=tmp_path / 'owner.json',
                              vision_gpu_only=vision_only, vision_gpu_seconds=20)
    manifest = {'games': {'game1-voice-s2': {'file': 'games/game.vvg'}}}
    if vision_fault:
        monkeypatch.setattr(runner.signal, 'signal', lambda *args: None)
        monkeypatch.setattr(runner.signal, 'pause', lambda: (_ for _ in ()).throw(
            InterruptedError('retention proven')), raising=False)
        with pytest.raises(InterruptedError, match='retention proven'):
            runner.run_fusion(tmp_path, manifest, options, directory)
        receipt = json.loads((directory / 'result.json').read_text())
        assert receipt['hardware_owner_retained'] and receipt['status'] == 'B00_RETAINED_NOT_PASSED'
        if stage_failure:
            assert receipt['startup_stage_error'] == 'injected stage journal unavailable'
            assert 'Dual-mask vision fault' in receipt['first_error']
        assert runner._RETAINED == [(session, backend)]
        assert 'backend_stop' not in events and 'owner_close' not in events
    else:
        result = runner.run_fusion(tmp_path, manifest, options, directory)
        assert result['cleanup_confirmed']
        if vision_only:
            assert result['status'] == 'B00_VISION_GPU_ONLY_DIAGNOSTIC_PASS'
            assert not result['capture_pass'] and not result['three_way_observed'] and 'pcm' not in result
        else:
            assert result['status'] == 'B00_BOUNDED_THREE_WAY_PASS'
            assert result['pcm']['bytes'] == 864000 * 4
        expected = ['download', 'install_game', 'preview_prepare', 'gpu_open', 'audio_prepare_then_vision',
                    'game_then_audio_start']
        if vision_only:
            expected.append('observe_vision_gpu')
        assert events == expected + ['backend_stop', 'verify_hardware_stop', 'owner_close']

    stages = [json.loads(line)['stage'] for line in (directory / 'startup-stages.jsonl').read_text().splitlines()]
    assert stages[:4] == ['vision_gpu_only_begin' if vision_only else 'native_load_begin',
                          'backend_factory_begin', 'overlay_open_begin', 'overlay_open_complete']
    assert stages.index('vision_preview_prepare_complete') < stages.index('gpu_open_begin')
    assert stages.index('gpu_open_begin') < stages.index('vision_start_begin') < stages.index('vision_thread_started')
    if not vision_fault:
        game_stage = 'game_start_begin' if vision_only else 'game_audio_start_begin'
        assert stages.index('vision_start_complete') < stages.index(game_stage)
        assert stages.index(game_stage) < stages.index('game_worker_start_begin')
        if not vision_only:
            assert stages.index('game_first_scene_submit_complete') < stages.index('voice_capture_start_begin')
    else:
        assert 'vision_start_complete' not in stages and 'game_audio_start_begin' not in stages
    expected_last = 'live_ready' if not vision_fault else (
        'vision_thread_started' if stage_failure else 'first_error')
    assert stages[-1] == expected_last


@pytest.mark.parametrize('fault', ('none', 'journal', 'build', 'epoch', 'unsealed', 'changed'))
def test_pl_vision_only_stop_requires_unused_journal_and_same_sealed_epoch(tmp_path, monkeypatch, fault):
    import sys
    from board.pynq_z2 import vision_owner_gate as gate
    audio, owner = tmp_path / 'audio.lock', tmp_path / 'owner.lock'
    initial = b'{"state":"CLEAN"}' if fault == 'journal' else b''
    audio.write_bytes(initial)
    owner.touch()
    monkeypatch.setattr(gate, 'OWNER_LOCK', owner)
    monkeypatch.setattr(gate, 'AUDIO_LOCK', audio)
    monkeypatch.setitem(sys.modules, 'fcntl', SimpleNamespace(LOCK_EX=2, LOCK_NB=4, flock=lambda *args: None))
    report = dict(build_id='0xc0060900' if fault == 'build' else '0xc0060b00',
                  prior_epoch=8 if fault == 'epoch' else 7, source_quiescent=fault != 'unsealed')
    monkeypatch.setattr(gate, '_audit_idle_hardware', lambda: report)

    def check():
        with gate.locked_idle_board(vision_only_epoch=7) as stopped:
            assert stopped['audio_journal_unused']
            if fault == 'changed':
                audio.write_bytes(b'{"state":"ACTIVE"}')

    if fault == 'none':
        check()
    else:
        with pytest.raises(RuntimeError, match='journal|sealed canonical B00 epoch'):
            check()
    if fault != 'changed':
        assert audio.read_bytes() == initial


@pytest.mark.parametrize('case', ('none', 'vision_stall', 'gpu_stall', 'fault'))
def test_pl_vision_gpu_observation_requires_both_real_progress(monkeypatch, case):
    from board.pynq_z2.scripts import run_pl_voice_fusion_acceptance as runner
    game = SimpleNamespace(last_error=None, input_consumptions={'presented_frames': 10})
    count = 0

    def status():
        nonlocal count
        count += 1
        if case != 'gpu_stall':
            game.input_consumptions['presented_frames'] += 1
        return dict(state='FAULT' if case == 'fault' and count > 1 else 'RUNNING',
                    frame_id=1 if case == 'vision_stall' else count, last_error=None)

    backend = SimpleNamespace(_vision_supervisor=SimpleNamespace(status=status), _game=game)
    clock = iter((0., .5, 1.))
    monkeypatch.setattr(runner.time, 'monotonic', lambda: next(clock))
    snapshots = iter(dict(owner_pid=1, owner_start=1, ticks_per_second=100, family_ticks=step * 10,
                          system_total=100 + step * 100, system_idle=step * 50) for step in range(4))
    monkeypatch.setattr(runner, 'cpu_snapshot', lambda: next(snapshots))
    monkeypatch.setattr(runner.os, 'sched_getaffinity', lambda _: {0, 1}, raising=False)
    monkeypatch.setattr(runner.threading, 'Event', lambda: SimpleNamespace(wait=lambda _: None))
    if case == 'none':
        result = runner.observe_vision_gpu(backend, 1.)
        assert result['vision_gpu_pass'] and not result['audio_service_created']
        assert not result['pcm_worker_created'] and not result['three_way_observed']
        assert len(result['cpu_samples']) == 2 and result['cpu']['wall_seconds'] == 1
    else:
        with pytest.raises(RuntimeError, match='fault|Continuous real vision'):
            runner.observe_vision_gpu(backend, 1.)


@pytest.mark.parametrize('fault', (False, True))
def test_pl_startup_python_trace_timer_is_cancelled_on_exit(tmp_path, monkeypatch, fault):
    from board.pynq_z2.scripts import run_pl_voice_fusion_acceptance as runner
    events, streams = [], []

    def arm(timeout, *, repeat, file):
        assert timeout == 2 and repeat is True and not file.closed
        streams.append(file)
        events.append('armed')

    def cancel():
        assert not streams[0].closed
        events.append('cancelled')

    monkeypatch.setattr(runner.faulthandler, 'dump_traceback_later', arm)
    monkeypatch.setattr(runner.faulthandler, 'cancel_dump_traceback_later', cancel)

    def deadline(interval, callback):
        assert interval == 180 and callback is cancel
        return SimpleNamespace(start=lambda: events.append('deadline_started'),
                               cancel=lambda: events.append('deadline_cancelled'))

    monkeypatch.setattr(runner.threading, 'Timer', deadline)
    if fault:
        with pytest.raises(RuntimeError, match='injected startup error'):
            with runner.startup_python_traces(tmp_path):
                raise RuntimeError('injected startup error')
    else:
        with runner.startup_python_traces(tmp_path):
            assert events == ['armed', 'deadline_started']
    assert events == ['armed', 'deadline_started', 'deadline_cancelled', 'cancelled'] and streams[0].closed


def test_pl_startup_python_trace_records_real_wait_stack(tmp_path):
    from board.pynq_z2.scripts import run_pl_voice_fusion_acceptance as runner
    with runner.startup_python_traces(tmp_path):
        threading.Event().wait(2.2)
    trace = (tmp_path / 'startup-python-stacks.log').read_bytes()
    assert b'Timeout' in trace and b'test_pl_startup_python_trace_records_real_wait_stack' in trace


def test_pl_startup_monitor_persists_before_ready_and_observes_cpu_memory(tmp_path, monkeypatch):
    import json
    from board.pynq_z2.scripts import run_pl_voice_fusion_acceptance as runner
    proc = tmp_path / 'proc'
    proc.mkdir()
    (proc / 'meminfo').write_text('MemTotal: 512000 kB\nMemAvailable: 128000 kB\nSwapFree: 0 kB\n')
    (proc / 'loadavg').write_text('1.0 0.5 0.2 1/10 123\n')
    runner.startup_stage(tmp_path, 'overlay_open_begin')
    with (tmp_path / 'startup-stages.jsonl').open('a') as stages:
        stages.write('{"stage":')
    trace = tmp_path / 'startup-python-stacks.log'
    trace.write_bytes(b'Timeout\ninitial stack\n')
    preview = tmp_path / 'vision/run/preview-startup.jsonl'
    preview.parent.mkdir(parents=True)
    preview.write_bytes(b'process_enter\n')
    snapshots = iter({'owner_pid': 100, 'owner_start': 1, 'ticks_per_second': 100,
                      'family_ticks': 10 + step * 20, 'system_total': 100 + step * 100,
                      'system_idle': 20 + step * 50} for step in range(3))
    monkeypatch.setattr(runner, 'cpu_snapshot', lambda *args, **kwargs: next(snapshots))
    monkeypatch.setattr(runner.os, 'sched_getaffinity', lambda pid: {0, 1}, raising=False)
    dump = runner.json.dump

    def unpublished_ready(payload, stream):
        assert not (tmp_path / 'startup-monitor-ready.json').exists()
        assert stream.name.endswith('startup-monitor-ready.pending')
        dump(payload, stream)

    monkeypatch.setattr(runner.json, 'dump', unpublished_ready)

    def wait(interval):
        assert interval == .5
        lines = (tmp_path / 'startup-resources.jsonl').read_text().splitlines()
        assert len(lines) in (1, 2)
        assert json.loads((tmp_path / 'startup-monitor-ready.json').read_text())['owner_pid'] == 100
        assert not (tmp_path / 'startup-monitor-ready.pending').exists()
        if len(lines) == 1:
            with trace.open('ab') as stream:
                stream.write(b'next stack\n')
            with preview.open('ab') as stream:
                stream.write(b'ready\n')
        else:
            (tmp_path / 'startup-monitor.stop').touch()

    monkeypatch.setattr(runner.threading, 'Event', lambda: SimpleNamespace(wait=wait))
    runner.monitor_startup(tmp_path, 100, proc=proc)
    records = [json.loads(line) for line in (tmp_path / 'startup-resources.jsonl').read_text().splitlines()]
    assert len(records) == 3 and records[0]['stage']['stage'] == 'overlay_open_begin'
    assert records[0]['memory_kib']['MemAvailable'] == 128000
    assert records[0]['cpu_pressure'] is None and records[0]['hardware_operations'] is False
    assert records[1]['cpu']['system_busy_percent'] == 50
    assert records[0]['python_stack_fragment'] == {
        'byte_offset': 0, 'byte_count': 22, 'text': 'Timeout\ninitial stack\n'}
    assert records[1]['python_stack_fragment'] == {
        'byte_offset': 22, 'byte_count': 11, 'text': 'next stack\n'}
    assert 'python_stack_fragment' not in records[2]
    assert records[0]['preview_startup_fragments'] == [dict(
        path='vision/run/preview-startup.jsonl', byte_offset=0, byte_count=14, text='process_enter\n')]
    assert records[1]['preview_startup_fragments'] == [dict(
        path='vision/run/preview-startup.jsonl', byte_offset=14, byte_count=6, text='ready\n')]
    assert 'preview_startup_fragments' not in records[2]


@pytest.mark.parametrize('fault', ('none', 'identity', 'exit', 'missing'))
def test_pl_startup_monitor_is_independent_and_ready_before_load(tmp_path, monkeypatch, fault):
    import json
    import os
    from board.pynq_z2.scripts import run_pl_voice_fusion_acceptance as runner

    def spawn(command, **options):
        assert '--startup-monitor' in command and '--live-board-test' not in command
        assert command[command.index('--monitor-pid') + 1] == str(os.getpid())
        receipt = {'owner_pid': os.getpid(), 'monitor_pid': 202 if fault == 'identity' else 201}
        if fault != 'missing':
            (tmp_path / 'startup-monitor-ready.json').write_text(json.dumps(receipt))
        return SimpleNamespace(pid=201, poll=lambda: 1 if fault in ('exit', 'missing') else None)

    monkeypatch.setattr(runner.subprocess, 'Popen', spawn)
    if fault == 'none':
        assert runner.start_startup_monitor(tmp_path).pid == 201
    else:
        with pytest.raises(RuntimeError, match='no hardware load permitted'):
            runner.start_startup_monitor(tmp_path)


def test_pl_startup_monitor_failure_is_persisted_without_ready(tmp_path, monkeypatch):
    import json
    from board.pynq_z2.scripts import run_pl_voice_fusion_acceptance as runner

    def missing_owner(*args, **kwargs):
        raise RuntimeError('CPU owner PID disappeared')

    monkeypatch.setattr(runner, 'cpu_snapshot', missing_owner)
    monkeypatch.setattr(runner.os, 'sched_getaffinity', lambda pid: {0, 1}, raising=False)
    with pytest.raises(RuntimeError, match='CPU owner PID disappeared'):
        runner.monitor_startup(tmp_path, 100, proc=tmp_path)
    record = json.loads((tmp_path / 'startup-resources.jsonl').read_text())
    assert 'CPU owner PID disappeared' in record['first_error']
    assert not (tmp_path / 'startup-monitor-ready.json').exists()


@pytest.mark.parametrize("case", ("running", "idle", "prepare_error", "pause_error", "voice_error", "resume_error", "vision_fault", "vision_timeout"))
def test_native_voice_start_quiesces_vision_until_audio_running(case):
    from pynq_multimodal_game.agent.voice_backend import C6IVoiceFusionRuntimeBackend
    events = []

    class Voice(NativeVoiceSupervisor):
        def start(self):
            events.append("voice_start")
            if case == "voice_error":
                raise RuntimeError("Voice start rejected")

    def pause():
        events.append("vision_pause")
        if case == "pause_error":
            raise RuntimeError("Vision pause unconfirmed")

    def resume():
        events.append("vision_resume")
        if case == "resume_error":
            raise RuntimeError("Vision resume failed")

    def ready():
        events.append("vision_ready")
        if case == "vision_fault":
            raise RuntimeError("Vision startup fault")
        if case == "vision_timeout":
            raise RuntimeError("Vision startup timeout")
        return {"owner_held": case != "idle"}

    def prepare_rearm():
        assert "voice_start" not in events and "game_resume" not in events
        events.append("audio_prepare")
        if case == "prepare_error":
            raise RuntimeError("Policy preparation failed")

    backend = object.__new__(C6IVoiceFusionRuntimeBackend)
    backend._voice = object.__new__(Voice)
    backend._vision_ready_for_voice = ready
    backend._vision_supervisor = SimpleNamespace(pause_processing=pause, resume_processing=resume)
    backend._game = SimpleNamespace(
        pause=lambda: events.append("game_pause"),
        resume=lambda: events.append("game_resume"),
        _live_input=SimpleNamespace(prepare_audio_rearm=prepare_rearm,
                                    rearm_audio=lambda: events.append("audio_rearm")))
    expected = ["game_pause", "audio_prepare"]
    if case != "prepare_error":
        expected.append("vision_ready")
    if case == "idle":
        expected += ["voice_start", "game_resume", "audio_rearm"]
    elif case not in ("prepare_error", "vision_fault", "vision_timeout"):
        expected.append("vision_pause")
        if case != "pause_error":
            expected += ["voice_start", "vision_resume"]
            if case == "running":
                expected += ["game_resume", "audio_rearm"]
    if case in ("running", "idle"):
        backend._start_voice()
    else:
        with pytest.raises(RuntimeError):
            backend._start_voice()
    assert events == expected and backend._voice_starting is False


@pytest.mark.parametrize('case', ('default', 'enabled', 'enable_error'))
def test_fusion_enables_preview_upload_only_while_paused_before_audio(case):
    from pynq_multimodal_game.agent.voice_backend import C6IVoiceFusionRuntimeBackend
    events = []
    backend = object.__new__(C6IVoiceFusionRuntimeBackend)
    backend._diagnostic_preview_upload_overlap = case != 'default'
    backend._voice = SimpleNamespace(start=lambda: events.append('voice_start'))
    def enable():
        assert events == ['pause']
        events.append('enable')
        if case == 'enable_error':
            raise RuntimeError('overlap rejected')
    backend._game = SimpleNamespace(pause=lambda: events.append('pause'), enable_preview_upload_overlap=enable,
                                    resume_audio=lambda: events.append('resume_audio'))
    if case == 'enable_error':
        with pytest.raises(RuntimeError, match='overlap rejected'):
            backend._start_voice()
        assert events == ['pause', 'enable']
    else:
        backend._start_voice()
        assert events == (['pause'] + (['enable'] if case == 'enabled' else []) + ['voice_start', 'resume_audio'])
    assert backend._voice_starting is False


def test_fusion_prefers_atomic_audio_resume():
    from pynq_multimodal_game.agent.voice_backend import C6IVoiceFusionRuntimeBackend
    events = []
    backend = object.__new__(C6IVoiceFusionRuntimeBackend)
    backend._voice = SimpleNamespace(start=lambda: events.append("voice_start"))
    backend._game = SimpleNamespace(pause=lambda: events.append("pause"),
        resume_audio=lambda: events.append("resume_audio"),
        resume=lambda: pytest.fail("non-atomic resume"),
        _live_input=SimpleNamespace(rearm_audio=lambda: pytest.fail("separate rearm")))
    backend._start_voice()
    assert events == ["pause", "voice_start", "resume_audio"] and not backend._voice_starting


@pytest.mark.parametrize("case", ("live", "test_case", "menu_stop_error", "first_scene_missing", "pause_error", "start_error", "resume_error", "rearm_error", "stage_error"))
def test_fusion_stops_menu_before_preparing_voice_and_waits_for_first_scene(case, monkeypatch):
    from pynq_multimodal_game.agent.c6i_shell import ShellMode
    from pynq_multimodal_game.agent.vision_backend import C6IVisionRuntimeBackend
    from pynq_multimodal_game.agent.voice_backend import C6IVoiceFusionRuntimeBackend
    events = []
    stages = []

    def record(stage):
        stages.append(stage)
        if case == "stage_error" and stage == "voice_capture_start_begin":
            raise RuntimeError("Stage journal unavailable")

    backend = object.__new__(C6IVoiceFusionRuntimeBackend)
    backend._diagnostic_startup_stage = record
    backend._voice_lock = backend._lock = threading.RLock()
    backend._mode = ShellMode.MENU
    def voice_start():
        events.append("voice_start")
        assert backend._game.action_permit == {"armed": False}
        assert backend._game_voice_ended() is False
        if case == "start_error":
            raise RuntimeError("Voice start rejected")

    backend._voice = SimpleNamespace(start=voice_start)
    backend._prepare_voice = lambda: events.append("voice_prepare")
    backend._stop_voice = lambda: events.append("voice_stop")

    def stop_menu():
        events.append("menu_stop")
        if case == "menu_stop_error":
            raise RuntimeError("Menu stop unconfirmed")

    def start_game(instance, item_id, test_case_json=None):
        events.append("game_start")
        def pause():
            events.append("game_pause")
            if case == "pause_error":
                raise RuntimeError("Pause unconfirmed")

        def resume():
            events.append("game_resume")
            if case == "resume_error":
                raise RuntimeError("Resume unconfirmed")

        def rearm():
            events.append("audio_rearm")
            assert backend._game_voice_ended() is False
            if case == "rearm_error":
                raise RuntimeError("Rearm unconfirmed")
            instance._game.action_permit = {"armed": True}

        instance._game = SimpleNamespace(input_consumptions={"presented_frames": int(case != "first_scene_missing")},
                                         pause=pause, resume=resume, action_permit={"armed": False},
                                         _live_input=SimpleNamespace(rearm_audio=rearm))

    backend._stop_menu = stop_menu
    monkeypatch.setattr(C6IVisionRuntimeBackend, "start_game", start_game)
    if case == "menu_stop_error":
        with pytest.raises(RuntimeError, match="Menu stop unconfirmed"):
            backend.start_game("game1")
        expected = ["menu_stop"]
    elif case == "first_scene_missing":
        with pytest.raises(RuntimeError, match="First completed game Scene"):
            backend.start_game("game1")
        expected = ["menu_stop", "voice_prepare", "game_start", "voice_stop"]
    elif case in ("pause_error", "start_error", "resume_error", "rearm_error", "stage_error"):
        with pytest.raises(RuntimeError, match={"pause_error": "Pause unconfirmed", "start_error": "Voice start rejected",
                                               "resume_error": "Resume unconfirmed", "rearm_error": "Rearm unconfirmed",
                                               "stage_error": "Stage journal unavailable"}[case]):
            backend.start_game("game1")
        expected = ["menu_stop", "voice_prepare", "game_start", "game_pause"]
        if case not in ("pause_error", "stage_error"):
            expected.append("voice_start")
        if case in ("resume_error", "rearm_error"):
            expected.append("game_resume")
        if case == "rearm_error":
            expected.append("audio_rearm")
        expected.append("voice_stop")
    else:
        backend.start_game("game1", "{}" if case == "test_case" else None)
        expected = ["game_start"] if case == "test_case" else ["menu_stop", "voice_prepare", "game_start", "game_pause", "voice_start", "game_resume", "audio_rearm"]
    assert events == expected
    count = {"live": 6, "pause_error": 1, "start_error": 3, "resume_error": 5, "rearm_error": 5, "stage_error": 3}.get(case, 0)
    assert stages == ["game_pause_begin", "game_pause_complete", "voice_capture_start_begin",
                      "voice_capture_start_complete", "game_audio_resume_begin", "game_audio_resume_complete"][:count]
    if case in ("live", "pause_error", "start_error", "resume_error", "rearm_error", "stage_error"):
        assert backend._voice_starting is False
        assert backend._game_voice_ended() is (case != "live")


def test_capture_diagnostic_preserves_original_reads_and_bounded_register_values():
    from pynq_multimodal_game.agent.voice_backend import _diagnostic_capture_mmio
    calls, diagnostics = [], {}
    mmio = SimpleNamespace(read=lambda offset: calls.append(offset) or (7 if offset == 0x2C else offset),
                           write=lambda *_: None)
    observed = _diagnostic_capture_mmio(mmio, diagnostics)
    for _ in range(2):
        for offset in (0, 0x2C, 0x30, 0x18, 0x1C, 0x10, 0x14, 0x34, 0x38):
            assert observed.read(offset) == (7 if offset == 0x2C else offset)
    assert calls == [0, 0x2C, 0x30, 0x18, 0x1C, 0x10, 0x14, 0x34, 0x38] * 2
    assert diagnostics == {"capture_snapshot": {"live": 7, "hardware_epoch": 0x30,
                                               "dropped_low": 0x18, "dropped_high": 0x1C,
                                               "observed_low": 0x10, "observed_high": 0x14,
                                               "accepted_low": 0x34, "accepted_high": 0x38}}


def test_voice_start_acknowledgement_timeout_requests_stop_and_keeps_cleanup():
    capture = FakeCapture()
    supervisor = VoiceSupervisor(lambda: capture, service_factory=FakeService, packet_limit=2)
    supervisor.prepare()
    waits = []
    supervisor._started = SimpleNamespace(wait=lambda timeout: waits.append(timeout) or False, set=lambda: None)
    with pytest.raises(RuntimeError, match="startup acknowledgement timed out"):
        supervisor.start()
    assert waits == [1] and supervisor._stop.is_set()
    assert supervisor.stop()["owner_released"] is True