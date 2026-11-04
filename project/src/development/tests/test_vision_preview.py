from threading import Event
import ast
import importlib.util
import importlib
from functools import partial
import multiprocessing
import os
import json
import sys
import traceback
import types
from unittest.mock import MagicMock
from pathlib import Path
from urllib.error import HTTPError
from urllib.request import urlopen
from http.client import HTTPConnection
import time

import numpy as np
import pytest

from pynq_multimodal_game.vision_preview import (
    AsyncPreviewEncoder, ProcessPreviewEncoder, PreviewSnapshot, copy_preview_snapshot,
)


def _codec_startup_exit(*_):
    os._exit(23)


def _encode_process_empty(snapshot, mode):
    return b""


def test_process_startup_records_controlled_callback_import(tmp_path):
    log = tmp_path / "preview-startup.jsonl"
    worker = ProcessPreviewEncoder(lambda: frozenset(), _encode_process_empty,
                                   lambda *_: None, startup_log=log)
    try:
        assert worker.health().healthy
        stages = [json.loads(line) for line in log.read_text().splitlines()]
        assert [item["stage"] for item in stages] == [
            "spawn_begin", "process_enter", "shared_memory_complete", "opencv_import_begin",
            "opencv_import_complete", "opencv_threads_complete", "encode_import_begin",
            "encode_import_complete", "ready"]
        assert all(item["pid"] == worker._pid for item in stages[1:])
        assert not (tmp_path / "preview-startup.jsonl.stacks.log").exists()
    finally:
        worker.close()
    assert worker.health().cleanup == "CLEAN"


@pytest.mark.parametrize('case', ('ready', 'error', 'deadline'))
def test_process_startup_stack_capture_has_independent_deadline(tmp_path, monkeypatch, case):
    from types import SimpleNamespace
    from pynq_multimodal_game import vision_preview as module
    streams, timers = [], []
    cancel = MagicMock()

    def arm(interval, *, repeat, file):
        assert interval == 2 and repeat and not file.closed
        streams.append(file)

    def timer(interval, callback):
        assert interval == 180
        deadline = MagicMock()
        if case == 'deadline':
            deadline.start.side_effect = callback
        timers.append(deadline)
        return deadline

    memory, output, ready = MagicMock(), MagicMock(), MagicMock()
    codec = SimpleNamespace(setNumThreads=MagicMock())
    if case == 'error':
        codec.setNumThreads.side_effect = RuntimeError('injected codec initialization failure')
    monkeypatch.setattr(module, 'Timer', timer)
    monkeypatch.setattr(module.faulthandler, 'dump_traceback_later', arm)
    monkeypatch.setattr(module.faulthandler, 'cancel_dump_traceback_later', cancel)
    monkeypatch.setattr(module, 'SharedMemory', lambda **kwargs: memory)
    monkeypatch.setattr(module.os, 'nice', lambda *_: None, raising=False)
    monkeypatch.setitem(sys.modules, 'cv2', codec)
    arguments = ('unused', 1, [], [], None, SimpleNamespace(value=True), ready, output,
                 _encode_process_empty, str(tmp_path / 'startup.jsonl'), True)
    if case == 'error':
        with pytest.raises(RuntimeError, match='injected codec'):
            module._process_preview_loop(*arguments)
        ready.release.assert_not_called()
    else:
        module._process_preview_loop(*arguments)
        ready.release.assert_called_once()
    assert timers[0].daemon and timers[0].cancel.called
    timers[0].start.assert_called_once()
    assert cancel.call_count == (2 if case == 'deadline' else 1)
    assert streams[0].closed
    output.close.assert_called_once()
    memory.close.assert_called_once()


def _encode_process_probe(entered, release, snapshot, mode):
    if snapshot.frame == 1:
        entered.set()
        if not release.wait(5):
            raise RuntimeError("Probe release timed out")
    return f"{snapshot.frame}:{snapshot.rgb[0, 0, 0]}:{os.getpid()}".encode()


def _encode_process_exit(entered, release, snapshot, mode):
    entered.set()
    if not release.wait(5):
        raise RuntimeError("Exit probe release timed out")
    os._exit(23)


def _encode_process_frame_failure(entered, snapshot, mode):
    if snapshot.frame == 1:
        entered.set()
        raise ValueError("Bad diagnostic frame")
    return b"jpeg"


def test_process_health_unsubscribed_exit_reports_reason_and_no_copy() -> None:
    context = multiprocessing.get_context("spawn")
    entered, release = context.Event(), context.Event()
    subscribed = Event()
    subscribed.set()
    worker = ProcessPreviewEncoder(lambda: frozenset({"video"}) if subscribed.is_set() else frozenset(),
                                   partial(_encode_process_exit, entered, release), lambda *_: None)
    name = worker._memory.name
    try:
        assert worker.submit(lambda modes: PreviewSnapshot(1, modes, None, None, None))
        assert entered.wait(5)
        subscribed.clear()
        release.set()
        worker._process.join(5)
        health = worker.health()
        assert health.status == "DEGRADED" and not health.codec_alive
        assert health.exitcode == 23
        assert worker.stats()["last_error"]
        assert not worker.stats()["running"]
        assert not worker.submit(lambda _: pytest.fail("Degraded preview must not copy"))
    finally:
        release.set()
        with pytest.raises(RuntimeError, match="EXITED_NONZERO"):
            worker.close()
    worker.close()
    assert worker.health().status == "CLOSED"
    from multiprocessing.shared_memory import SharedMemory
    with pytest.raises(FileNotFoundError):
        SharedMemory(name=name)


def test_process_health_relay_failure_does_not_hide_behind_live_codec() -> None:
    worker = ProcessPreviewEncoder(lambda: frozenset(), _encode_process_empty, lambda *_: None)
    try:
        worker._receive.close()
        worker._thread.join(2)
        health = worker.health()
        assert health.status == "DEGRADED" and health.codec_alive and not health.relay_alive
        assert "relay" in health.reason.lower()
        assert not worker.stats()["healthy"]
        assert worker.stats()["running"]
    finally:
        worker.close()
    assert worker.health().cleanup == "CLEAN"


def test_process_health_normal_close_is_not_a_fault() -> None:
    import weakref
    worker = ProcessPreviewEncoder(lambda: frozenset(), _encode_process_empty, lambda *_: None)
    locks = [weakref.ref(lock) for lock in (worker._wake,*worker._slots)]
    assert worker.health().healthy
    worker.close()
    worker.close()
    assert worker.health().status == "CLOSED"
    assert worker.health().reason == ""
    assert worker.health().cleanup == "CLEAN"
    assert worker.stats()["errors"] == 0
    assert json.loads(json.dumps(worker.stats()))["health"]["status"] == "CLOSED"
    assert all(lock() is None for lock in locks)


def test_process_startup_failure_releases_shared_memory(monkeypatch) -> None:
    from multiprocessing.shared_memory import SharedMemory
    import pynq_multimodal_game.vision_preview as module

    names = []
    def allocation(*args, **kwargs):
        memory = SharedMemory(*args, **kwargs)
        names.append(memory.name)
        return memory

    monkeypatch.setattr(module, "SharedMemory", allocation)
    monkeypatch.setattr(module, "_process_preview_loop", _codec_startup_exit)
    with pytest.raises(RuntimeError, match="failed to initialize"):
        ProcessPreviewEncoder(lambda: frozenset(), _encode_process_empty, lambda *_: None)
    assert len(names) == 1
    with pytest.raises(FileNotFoundError):
        SharedMemory(name=names[0])


def test_process_health_bad_frame_recovers_and_publication_fault_degrades() -> None:
    context = multiprocessing.get_context("spawn")
    entered = context.Event()
    published = Event()

    def broken_publish(*_):
        published.set()
        raise OSError("Publisher unavailable")

    worker = ProcessPreviewEncoder(lambda: frozenset({"video"}),
                                   partial(_encode_process_frame_failure, entered), broken_publish)
    try:
        assert worker.submit(lambda modes: PreviewSnapshot(1, modes, None, None, None), now=1)
        assert entered.wait(5)
        assert worker.health().healthy
        assert worker.submit(lambda modes: PreviewSnapshot(2, modes, None, None, None), now=2)
        assert published.wait(5)
        worker._thread.join(2)
        assert worker.health().status == "DEGRADED"
        assert "Publisher unavailable" in worker.health().reason
        assert worker.stats()["errors"] == 2
        assert not worker.submit(lambda _: pytest.fail("Fatal publisher must not copy"), now=3)
    finally:
        worker.close()


def test_process_health_forced_cleanup_releases_shared_memory() -> None:
    context = multiprocessing.get_context("spawn")
    entered, release = context.Event(), context.Event()
    worker = ProcessPreviewEncoder(lambda: frozenset({"video"}),
                                   partial(_encode_process_probe, entered, release), lambda *_: None)
    name = worker._memory.name
    try:
        assert worker.submit(lambda modes: PreviewSnapshot(1, modes, np.zeros((1, 1, 3)), None, None))
        assert entered.wait(5)
        with pytest.raises(RuntimeError, match="FORCED"):
            worker.close(timeout=0.01)
        assert worker.health().cleanup == "FORCED"
        assert not worker.health().codec_alive and not worker.health().relay_alive
        worker.close()
        from multiprocessing.shared_memory import SharedMemory
        with pytest.raises(FileNotFoundError):
            SharedMemory(name=name)
    finally:
        if worker._process.is_alive():
            release.set()
            worker.close()


def test_process_health_relay_cleanup_timeout_retains_resources_until_retry() -> None:
    context = multiprocessing.get_context("spawn")
    entered = context.Event()
    publishing, release = Event(), Event()

    def blocked_publish(*_):
        publishing.set()
        release.wait(5)

    worker = ProcessPreviewEncoder(lambda: frozenset({"video"}),
                                   partial(_encode_process_frame_failure, entered), blocked_publish)
    try:
        assert worker.submit(lambda modes: PreviewSnapshot(2, modes, None, None, None))
        assert publishing.wait(5)
        with pytest.raises(RuntimeError, match="resources retained"):
            worker.close()
        assert worker.health().cleanup == "TIMEOUT"
        assert not worker._closed
        assert worker._memory.buf is not None
        release.set()
        worker.close()
        assert worker.health().status == "CLOSED"
    finally:
        release.set()
        worker.close()


def test_preview_no_subscription_does_not_copy() -> None:
    worker = AsyncPreviewEncoder(lambda: frozenset(), lambda *_: b"", lambda *_: None)
    try:
        def forbidden(_):
            pytest.fail("Unsubscribed preview must not copy inference data")
        assert not worker.submit(forbidden)
        assert worker.stats()["submitted"] == 0
    finally:
        worker.close()


def test_preview_busy_encoder_keeps_latest_independent_snapshot() -> None:
    entered, release, latest = Event(), Event(), Event()
    frames = []
    pixels = np.zeros((2, 2, 3), dtype=np.uint8)
    result = {"mask": np.zeros((2, 2), dtype=np.uint8)}
    control = {"trajectory": [[1, 2]]}

    def encode(snapshot, mode):
        if snapshot.frame == 1:
            entered.set()
            assert release.wait(2)
        frames.append(snapshot.frame)
        assert snapshot.result["mask"][0, 0] == 0
        assert snapshot.control["trajectory"][0][0] == 1
        return b"jpeg"

    def publish(mode, payload):
        if frames[-1] == 4:
            latest.set()

    worker = AsyncPreviewEncoder(lambda: frozenset({"debug"}), encode, publish, debug_fps=10)
    try:
        factory = lambda frame: lambda modes: copy_preview_snapshot(pixels, result, control, frame, modes)
        assert worker.submit(factory(1), now=1.0)
        assert entered.wait(1)
        assert worker.submit(factory(2), now=1.2)
        assert worker.submit(factory(3), now=1.4)
        assert worker.submit(factory(4), now=1.6)
        result["mask"][:] = 255
        control["trajectory"][0][0] = 99
        assert worker.stats()["pending"] == 1
        assert worker.stats()["replaced"] == 2
        release.set()
        assert latest.wait(1)
        assert frames == [1, 4]
    finally:
        release.set()
        worker.close()
    assert not worker.stats()["running"]


def test_preview_rates_are_independent_and_errors_do_not_escape() -> None:
    failed = Event()

    def encode(snapshot, mode):
        failed.set()
        raise ValueError("bad diagnostic frame")

    worker = AsyncPreviewEncoder(lambda: frozenset({"debug", "video"}), encode, lambda *_: None,
                                 debug_fps=5, video_fps=10)
    try:
        pixels = np.zeros((1, 1, 3), dtype=np.uint8)
        factory = lambda modes: copy_preview_snapshot(pixels, {}, {}, 1, modes)
        assert worker.submit(factory, now=1.0)
        assert not worker.submit(factory, now=1.05)
        assert worker.submit(factory, now=1.11)
        assert failed.wait(1)
    finally:
        worker.close()
    assert worker.stats()["errors"] > 0
    assert worker.stats()["last_error"] == "bad diagnostic frame"


@pytest.mark.parametrize("rate", [-1, 31, float("nan"), float("inf")])
def test_preview_rejects_invalid_rates(rate: float) -> None:
    with pytest.raises(ValueError, match="finite"):
        AsyncPreviewEncoder(lambda: frozenset(), lambda *_: b"", lambda *_: None, debug_fps=rate)


def shared_hardware_fixture():
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.c6i_backend import C6IOverlaySession
    path = Path(__file__).resolve().parents[1] / "board/pynq_z2/scripts/vision_async_runtime.py"
    spec = importlib.util.spec_from_file_location("shared_vision_candidate", path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    log = []

    class Skin:
        fail = False
        closed = False

        def halt(self):
            log.append("skin-halt")
            if self.fail:
                raise TimeoutError("injected halt failure")

        def close(self):
            self.halt()
            log.append("skin-free")
            self.closed = True

    class MMIO:
        haltable = True

        def read(self, offset):
            return int(self.haltable) if offset == 0x34 else 1

        def write(self, offset, value):
            log.append((offset, value))

    class Channel:
        mode = None
        pixels = np.zeros((2, 3, 3), dtype=np.uint8)

        def start(self):
            log.append("capture-start")

        def readframe(self):
            return self.pixels

        def stop(self):
            log.append("capture-free")

    class DMA:
        mmio = MMIO()
        readchannel = Channel()

        @property
        def writechannel(self):
            raise AssertionError("vision must not access GPU HDMI or camera MM2S")

    skin, dma = Skin(), DMA()
    camera = SimpleNamespace(WIDTH=1280, HEIGHT=720,
                             probe_chip_id=lambda iic: log.append("probe"),
                             configure_sensor=lambda iic: log.append("sensor"),
                             open_frame_dma=lambda overlay, hwh: dma)
    session = C6IOverlaySession(Path("mock-fusion.bit"), require_root=False, allocate=lambda **kwargs: kwargs)
    session._overlay = SimpleNamespace(ip_dict={"frame_dma": {
        "parameters": {"C_INCLUDE_MM2S": "0"}, "interrupts": {"s2mm_introut": {}},
    }, "camera_iic": {}}, demosaic=MMIO())
    gpu = session.borrow("GPU", instances=frozenset({"axi_dma"}))
    hardware = module.SharedVisionHardware(session, camera, lambda *args, **kwargs: skin,
                                           lambda description: object(), lambda *args: args, timeout=.001)
    return module, hardware, session, gpu, skin, dma, log


@pytest.mark.parametrize('fault', (None, 'build', 'sg', 'stores', 'rgb-running',
                                 'packet-error', 'reset-in-use', 'reset-readback'))
def test_dual_mask_borrower_capability_gate_and_retained_lease(monkeypatch, fault):
    module, original, session, gpu, _, _, log = shared_hardware_fixture()
    overlay = session._overlay
    for name, parameters in module.SharedDualMaskHardware.DMA_PARAMETERS.items():
        overlay.ip_dict[name] = {'parameters': {key: str(value) for key, value in parameters.items()}}
    for name in module.SharedDualMaskHardware.INSTANCES:
        overlay.ip_dict.setdefault(name, {})
    addresses = {}
    for index, (name, description) in enumerate(overlay.ip_dict.items()):
        description.update(phys_addr=0x10000 + index*0x1000, addr_range=0x1000)
        addresses[description['phys_addr']] = name
    if fault == 'sg':
        overlay.ip_dict['moments_dma']['parameters']['C_INCLUDE_SG'] = '0'
    elif fault == 'stores':
        overlay.ip_dict['frame_dma']['parameters']['C_NUM_FSTORES'] = '2'

    reset_released = fault == 'reset-in-use'
    accesses = []

    class RegisterIO:
        def __init__(self, name):
            self.name = name

        def read(self, offset):
            accesses.append(('read', self.name, offset))
            if self.name == module.BUILD_ID_IP:
                return 0xC0060900 if fault == 'build' else 0xC0060B00
            if self.name in ('frame_dma', 'moments_dma'):
                if offset == 0x30:
                    return int(fault == 'rgb-running' and self.name == 'frame_dma')
                assert offset == 0x34
                return (1 if self.name == 'frame_dma' else 9) | (
                    0x10 if fault == 'packet-error' and self.name == 'moments_dma' else 0)
            if self.name == 'moments_reset':
                assert offset == 0
                return 0 if fault == 'reset-readback' else int(reset_released)
            assert self.name == 'capture_status' and reset_released
            return {0: 0x31545356, 4: 0x00010000, 8: 0, 12: 0, 16: 0}[offset]

        def write(self, offset, value):
            nonlocal reset_released
            accesses.append(('write', self.name, offset, value))
            if self.name == 'moments_reset' and offset == 0:
                assert value == 1
                reset_released = True
            log.append((self.name, offset, value))

    class Pool:
        def __init__(self, *args, **kwargs):
            self.read_status = args[-1]
            log.append('pool-create')

        def start(self, **context):
            assert context == dict(epoch=3, config_id=2, thresholds=(1, 2, 3, 4, 5, 6))
            status = self.read_status()
            assert status.epoch == 0 and not status.ready and not status.sealed and not status.faults
            log.append('pool-start')

        def stop(self, consumer):
            consumer('remaining-frame')
            log.append('pool-stop')

    session._mmio_factory = lambda address, length: RegisterIO(addresses[address])
    monkeypatch.setattr(module, 'VisionCapturePool', Pool)
    hardware = module.SharedDualMaskHardware(session, original.camera, original.iic_factory,
                                             epoch=3, config_id=2, thresholds=(1, 2, 3, 4, 5, 6))
    try:
        if fault:
            with pytest.raises((ValueError, RuntimeError)):
                hardware.start()
            assert hardware.state == 'RETAINED'
            assert not log if fault != 'reset-readback' else log == [
                ('moments_reset', 4, 0), ('moments_reset', 0, 1)]
            assert not any(entry[1] in ('capture_status', 'capture_control') for entry in accesses)
            assert hardware in hardware.lease._resources
            with pytest.raises(RuntimeError):
                hardware.stop()
            with pytest.raises(RuntimeError, match='borrowed'):
                session.close()
        else:
            hardware.start()
            assert hardware.state == 'RUNNING' and session.is_open
            release = accesses.index(('write', 'moments_reset', 0, 1))
            identity = accesses.index(('read', 'capture_status', 0))
            assert release < identity
            assert ('read', 'moments_reset', 0) in accesses[release + 1:identity]
            assert not any(entry[0] == 'write' and entry[1] in ('frame_dma', 'moments_dma')
                           for entry in accesses)
            hardware.drain_consumer = lambda frame: log.append(frame)
            hardware.stop()
            assert log.index('remaining-frame') < log.index('pool-stop')
            assert hardware.state == 'STOPPED' and session.is_open
    finally:
        if hardware.lease is not None:
            hardware.lease.close()
        gpu.close()
        session.close()


def test_dual_mask_worker_processes_live_and_stop_drain_without_rgb_frontend(monkeypatch):
    from types import SimpleNamespace
    from pynq_multimodal_game.vision_input import VisionInputProvider
    module, _, session, gpu, _, _, _ = shared_hardware_fixture()
    masks = np.zeros((360, 640), dtype=np.uint8)

    def frame(frame_id):
        return SimpleNamespace(frame_id=frame_id, raw=masks, filtered=masks)

    hardware = SimpleNamespace(read=lambda: frame(1), state='RUNNING')
    controller = SimpleNamespace(update=lambda result, frame_id, now: {
        'schema': 'gesture-control-v1', 'frame_id': frame_id, 'action_event_seq': 0,
        'valid': False, 'direction': 'NONE',
    })
    worker = module.SharedDualMaskWorker(hardware, module.DualMaskFullFrameTracker(dilate_iterations=4),
                                         controller, VisionInputProvider(), run_id='dual-mask')
    try:
        for name in ('cvtColor', 'inRange', 'dilate', 'GaussianBlur', 'resize'):
            monkeypatch.setattr(module.cv2, name, lambda *args, **kwargs: pytest.fail('CPU frontend called'))
        worker.step()
        assert worker.frame_id == 1
        worker._stop.set()
        hardware.drain_consumer(frame(2))
        hardware.drain_consumer(frame(3))
        assert worker.frame_id == 3 and worker.error is None
        with pytest.raises(RuntimeError, match='consecutive'):
            hardware.drain_consumer(frame(3))
    finally:
        gpu.close()
        session.close()


def test_dual_mask_worker_preview_uses_same_capture_and_keeps_early_publish():
    from types import SimpleNamespace
    from pynq_multimodal_game.vision_input import VisionInputProvider
    module, _, session, gpu, _, _, _ = shared_hardware_fixture()
    masks = np.zeros((360, 640), dtype=np.uint8)
    pixels = np.full((720, 1280, 3), (7, 19, 31), dtype=np.uint8)
    captured = SimpleNamespace(frame_id=1, raw=masks, filtered=masks, rgb=pixels.tobytes())
    hardware = SimpleNamespace(read=lambda: captured, state='RUNNING')
    provider = VisionInputProvider()
    snapshots = []

    class Encoder:
        def due_modes(self):
            return frozenset({'video', 'debug'})

        def submit(self, factory):
            assert provider.receipt.result.frame_id == 1
            snapshots.append(factory(frozenset({'video', 'debug'})))

    controller = SimpleNamespace(update=lambda result, frame_id, now: {
        'schema': 'gesture-control-v1', 'frame_id': frame_id, 'action_event_seq': 0,
        'valid': True, 'direction': 'LEFT',
    })
    try:
        worker = module.SharedDualMaskWorker(hardware, module.DualMaskFullFrameTracker(dilate_iterations=4),
                                             controller, provider, run_id='dual-mask', capture_order='bgr',
                                             preview_encoder=Encoder())
        assert hardware.preview_demand()
        worker.step()
        assert worker.frame_id == 1 and len(snapshots) == 1, worker.diagnostic_error
        assert snapshots[0].rgb[0, 0].tolist() == [31, 19, 7]
        assert snapshots[0].result['debug_images']['input'][0, 0].tolist() == [7, 19, 31]
        assert worker.diagnostic_error is None
    finally:
        gpu.close()
        session.close()


@pytest.mark.parametrize("validate", (None, True, False))
@pytest.mark.parametrize("fault", (None, "mask", "backend"))
def test_shared_skin_validation_modes_preserve_backend_errors(monkeypatch, validate, fault):
    module, hardware, session, gpu, skin, dma, log = shared_hardware_fixture()
    recognizer = module.FullFrameTracker(dilate_iterations=4)
    image = np.zeros((360, 640, 3), dtype=np.uint8)
    image[100:220, 200:350] = (80, 120, 180)
    mask = module.cv2.inRange(module.cv2.cvtColor(image, module.cv2.COLOR_BGR2HSV),
                              recognizer.lower, recognizer.upper)
    if fault == "mask":
        mask[0, 0] ^= 255
    calls = []

    def run(actual, frame_id, bounds):
        calls.append((actual.shape, frame_id, bounds))
        if fault == "backend":
            raise RuntimeError("injected PL skin backend error")
        return mask.copy(), {}

    recognizer.skin_backend = types.SimpleNamespace(run=run)
    recognizer.result_frame_id = 17
    if validate is not None:
        recognizer.skin_validate = validate
    convert = MagicMock(wraps=module.cv2.cvtColor)
    monkeypatch.setattr(module.cv2, "cvtColor", convert)
    try:
        if fault == "backend":
            with pytest.raises(RuntimeError, match="injected PL skin backend error"):
                recognizer.infer(image)
            assert convert.call_count == 0
        elif fault == "mask" and validate is not False:
            with pytest.raises(RuntimeError, match="PL skin same-frame mask mismatch"):
                recognizer.infer(image)
            assert convert.call_count == 1
        else:
            result = recognizer.infer(image)
            assert result["pl_skin"]["same_frame_exact"] is (None if validate is False else True)
            assert convert.call_count == int(validate is not False)
        assert len(calls) == 1 and calls[0][:2] == ((360, 640, 3), 17)
    finally:
        gpu.close()
        session.close()


@pytest.mark.parametrize("validate", (True, False))
def test_pl_skin_modes_match_cpu_reference_over_tracking_frames(validate):
    module, hardware, session, gpu, skin, dma, log = shared_hardware_fixture()
    reference = module.FullFrameTracker(dilate_iterations=4)
    candidate = module.FullFrameTracker(dilate_iterations=4)
    candidate.skin_validate = validate
    frames = [np.zeros((360, 640, 3), dtype=np.uint8)]
    for shift in (0, 10, 20, 30, 40):
        image = frames[0].copy()
        image[100:230, 200 + shift:340 + shift] = (80, 120, 180)
        frames.append(image)
    frames.append(frames[0])
    try:
        for frame_id, image in enumerate(frames, 1):
            mask = module.cv2.inRange(module.cv2.cvtColor(image, module.cv2.COLOR_BGR2HSV),
                                      candidate.lower, candidate.upper)
            candidate.skin_backend = types.SimpleNamespace(run=lambda *args: (mask.copy(), {}))
            candidate.result_frame_id = reference.result_frame_id = frame_id
            actual, expected = candidate.infer(image), reference.infer(image)
            for field in ("code", "stable", "bbox", "fingers", "area", "ratio", "centroid", "pixel_stats",
                          "touches_roi", "rps", "hand_state", "candidates"):
                assert actual[field] == expected[field], (frame_id, field)
            for field in ("mask", "contour", "hull"):
                assert np.array_equal(actual[field], expected[field]), (frame_id, field)
    finally:
        gpu.close()
        session.close()


def test_preprocessed_dual_masks_match_cpu_tracking_without_frontend_calls(monkeypatch):
    module, hardware, session, gpu, skin, dma, log = shared_hardware_fixture()
    reference = module.FullFrameTracker(dilate_iterations=4)
    candidate = module.DualMaskFullFrameTracker(dilate_iterations=4)
    frames = [np.zeros((360, 640, 3), dtype=np.uint8)]
    for shift in (0, 10, 20, 30, 40):
        image = frames[0].copy()
        image[100:230, 200 + shift:340 + shift] = (80, 120, 180)
        frames.append(image)
    frames.append(frames[0])
    try:
        for frame_id, image in enumerate(frames, 1):
            expected = reference.infer(image)
            raw = module.cv2.inRange(module.cv2.cvtColor(image, module.cv2.COLOR_BGR2HSV),
                                     candidate.lower, candidate.upper)
            filtered = module.cv2.GaussianBlur(
                module.cv2.dilate(raw, np.ones((3, 3), np.uint8), iterations=4), (5, 5), 100)
            with monkeypatch.context() as patch:
                for name in ('cvtColor', 'inRange', 'dilate', 'GaussianBlur', 'resize'):
                    patch.setattr(module.cv2, name, lambda *args, **kwargs: pytest.fail('CPU frontend called'))
                actual = candidate.infer((raw, filtered))
            for field in ('code', 'stable', 'bbox', 'fingers', 'area', 'ratio', 'centroid', 'pixel_stats',
                          'touches_roi', 'rps', 'hand_state', 'candidates'):
                assert actual[field] == expected[field], (frame_id, field)
            for field in ('mask', 'contour', 'hull'):
                assert np.array_equal(actual[field], expected[field]), (frame_id, field)
            assert actual['pl_skin'] == dict(backend='DMS1_DUAL_MASK', same_frame_exact=None)
    finally:
        gpu.close()
        session.close()


@pytest.mark.parametrize('rotate,mirror', ((0, False), (180, False), (0, True), (180, True)))
def test_dual_mask_processing_preserves_orientation_tracking_and_early_publish(monkeypatch, rotate, mirror):
    module, _, session, gpu, _, _, _ = shared_hardware_fixture()
    reference = module.FullFrameTracker(dilate_iterations=4)
    candidate = module.DualMaskFullFrameTracker(dilate_iterations=4)
    try:
        for frame_id in range(1, 8):
            image = np.zeros((360, 640, 3), dtype=np.uint8)
            if frame_id < 7:
                image[70:230, 100+frame_id*8:250+frame_id*8] = (80, 120, 180)
            raw = module.cv2.inRange(module.cv2.cvtColor(image, module.cv2.COLOR_BGR2HSV), candidate.lower, candidate.upper)
            filtered = module.cv2.GaussianBlur(module.cv2.dilate(raw, np.ones((3, 3), np.uint8), iterations=4), (5, 5), 100)
            oriented = module.cv2.rotate(image, module.cv2.ROTATE_180) if rotate == 180 else image
            if mirror:
                oriented = module.cv2.flip(oriented, 1)
            expected = reference.infer(oriented)
            published = []
            with monkeypatch.context() as patch:
                for name in ('cvtColor', 'inRange', 'dilate', 'GaussianBlur', 'resize'):
                    patch.setattr(module.cv2, name, lambda *args, **kwargs: pytest.fail('CPU frontend called'))
                actual = module.process_dual_masks((raw, filtered), candidate, rotate, mirror, on_result=published.append)
            assert published == [actual]
            for field in ('code', 'stable', 'bbox', 'centroid', 'pixel_stats', 'hand_state', 'candidates'):
                assert actual[field] == expected[field], (frame_id, field)
            for field in ('mask', 'contour', 'hull'):
                assert np.array_equal(actual[field], expected[field]), (frame_id, field)
    finally:
        gpu.close()
        session.close()


@pytest.mark.parametrize('fault', ('pair', 'shape', 'dtype', 'binary', 'dilation', 'roi', 'skin', 'moments', 'debug'))
def test_preprocessed_dual_masks_reject_incompatible_inputs(fault):
    module, hardware, session, gpu, skin, dma, log = shared_hardware_fixture()
    recognizer = module.DualMaskFullFrameTracker(dilate_iterations=4)
    raw = np.zeros((360, 640), dtype=np.uint8)
    filtered = raw.copy()
    masks = (raw, filtered)
    if fault == 'pair':
        masks = [raw, filtered]
    elif fault == 'shape':
        masks = (raw[:-1], filtered)
    elif fault == 'dtype':
        masks = (raw, filtered.astype(np.uint16))
    elif fault == 'binary':
        raw[0, 0] = 1
    elif fault == 'dilation':
        recognizer.dilate_iterations = 3
    elif fault == 'roi':
        recognizer.roi = (1, 1, 640, 360)
    elif fault == 'skin':
        recognizer.skin_backend = object()
    elif fault == 'moments':
        recognizer.moments_backend = object()
    elif fault == 'debug':
        recognizer.debug_enabled = True
    try:
        with pytest.raises(ValueError):
            recognizer.infer(masks)
        assert recognizer.previous is None and not recognizer.votes
    finally:
        gpu.close()
        session.close()


def test_preprocessed_postprocessing_ast_matches_frozen_contour():
    root = Path(__file__).resolve().parents[1]
    candidate = ast.parse((root / 'board/pynq_z2/scripts/vision_async_runtime.py').read_text(encoding='utf-8'))
    frozen = ast.parse((root / 'handoffs/gesture_vision_v61/runtime/project1_live_ov5640.py').read_text(encoding='utf-8'))

    def tail(tree, name):
        owner = next(node for node in tree.body if isinstance(node, ast.ClassDef) and node.name == name)
        infer = next(node for node in owner.body if isinstance(node, ast.FunctionDef) and node.name == 'infer')
        start = next(index for index, node in enumerate(infer.body)
                     if isinstance(node, ast.Assign) and any(getattr(target, 'id', None) == 't2' for target in node.targets))
        return [ast.dump(node) for node in infer.body[start:]]

    assert tail(candidate, '_DualMaskContour') == tail(frozen, 'OriginalContour')


def test_shared_capture_construction_does_not_acquire_overlay_borrower():
    _, hardware, session, gpu, _, _, log = shared_hardware_fixture()
    assert hardware.lease is None
    gpu.close()
    session.close()
    hardware.stop()
    assert hardware.state == "STOPPED" and not log


def test_shared_capture_diagnostic_stages_are_bounded_and_monotonic():
    _, hardware, session, gpu, _, dma, _ = shared_hardware_fixture()
    hardware.stage_trace = []
    hardware.start()
    for _index in range(20):
        assert np.array_equal(hardware.read(), dma.readchannel.pixels)
    stages = hardware.stage_trace
    names = [item['stage'] for item in stages]
    assert names[:3] == ['borrow_begin', 'skin_begin', 'skin_returned']
    assert names.index('dma_open_returned') < names.index('channel_start_begin')
    assert names.index('channel_start_returned') < names.index('readframe_begin')
    assert names.index('readframe_returned') < names.index('copy_returned')
    assert len(stages) == 64
    stamps = [item['monotonic_ns'] for item in stages]
    assert stamps == sorted(stamps)
    assert all(item['native_id'] > 0 for item in stages)
    hardware.stop()
    gpu.close()
    session.close()


@pytest.mark.parametrize("shape", ((360, 1281), (721, 640), (360, True), [360, 640]))
def test_shared_skin_frame_shape_rejected_before_borrow(shape):
    module, hardware, session, gpu, _, _, log = shared_hardware_fixture()
    with pytest.raises(ValueError, match="bounded skin frame shape"):
        module.SharedVisionHardware(session, hardware.camera, hardware.skin_factory,
            hardware.iic_factory, hardware.mode_factory, skin_frame_shape=shape)
    assert hardware.lease is None and not log
    gpu.close()
    session.close()


@pytest.mark.parametrize("second_allocation_fails", (False, True))
def test_shared_skin_fixed_buffers_use_root_allocations_and_keep_stop_contract(second_allocation_fails):
    _, hardware, session, gpu, skin, _, log = shared_hardware_fixture()
    allocations = []

    def allocate(*, shape, dtype):
        assert dtype is np.uint32
        if second_allocation_fails and allocations:
            raise MemoryError("second root allocation failed")
        root = np.zeros(shape, dtype=dtype)
        allocations.append(root)
        return root

    session._allocate = allocate
    skin._buffers = []
    hardware.skin_frame_shape = (360, 640)
    if second_allocation_fails:
        with pytest.raises(MemoryError, match="second root"):
            hardware.start()
        assert hardware.state == "FAULT" and hardware.lease is not None
        assert len(skin._buffers) == 1 and not skin.closed
    else:
        hardware.start()
        assert [root.shape for root in allocations] == [(172805,), (57608,)]
        assert skin._buffers == allocations
        assert all(root.base is None for root in allocations)
        assert np.shares_memory(skin._tx_view, allocations[0])
        assert np.shares_memory(skin._rx_view, allocations[1])
    hardware.stop()
    assert skin.closed and hardware.state == "STOPPED"
    assert log.index("skin-halt") < log.index("skin-free")
    assert session.is_open
    gpu.close()
    session.close()


@pytest.mark.parametrize("return_fails", (False, True))
def test_shared_capture_recycles_only_detached_frame_after_copy(return_fails):
    _, hardware, session, gpu, _, dma, log = shared_hardware_fixture()

    class Frame(np.ndarray):
        def freebuffer(self):
            log.append("captured-return")
            if return_fails:
                raise RuntimeError("frame return failed")
            self[:] = 5

    dma.readchannel.pixels = np.zeros((2, 3, 3), dtype=np.uint8).view(Frame)
    hardware.recycle_frames = True
    hardware.start()
    if return_fails:
        with pytest.raises(RuntimeError, match="frame return failed"):
            hardware.read()
        assert hardware.retained[-1] is dma.readchannel.pixels
    else:
        copied = hardware.read()
        assert not copied.any() and dma.readchannel.pixels.all()
        assert not np.shares_memory(copied, dma.readchannel.pixels)
        assert not hardware.retained
        assert set(hardware.last_read_timing) == {"readframe_seconds", "copy_seconds", "return_seconds"}
    assert log.count("captured-return") == 1 and "capture-free" not in log
    hardware.stop()
    gpu.close()
    session.close()


def test_shared_capture_cooperative_copy_preserves_pixels_and_yields_between_blocks(monkeypatch):
    module, hardware, session, gpu, _, dma, _ = shared_hardware_fixture()
    source = np.arange(35*3*3, dtype=np.uint8).reshape((35, 3, 3))
    dma.readchannel.pixels = source
    yielded = []
    monkeypatch.setattr(module.time, "sleep", lambda seconds: yielded.append(seconds))
    hardware.cooperative_copy = True
    hardware.start()
    copied = hardware.read()
    assert np.array_equal(copied, source) and not np.shares_memory(copied, source)
    assert yielded == [.0001, .0001]
    assert hardware.retained[-1] is source
    hardware.stop()
    gpu.close()
    session.close()


def test_shared_capture_stop_preserves_gpu_and_halts_before_free():
    _, hardware, session, gpu, skin, dma, log = shared_hardware_fixture()
    hardware.start()
    pixels = hardware.read()
    dma.readchannel.pixels[:] = 1
    assert not pixels.any()
    hardware.stop()
    assert log.index("skin-halt") < log.index("skin-free") < log.index("capture-free")
    assert skin.closed and hardware.state == "STOPPED" and session.is_open
    with pytest.raises(RuntimeError, match="GPU"):
        session.close()
    gpu.close()
    session.close()


@pytest.mark.parametrize("failure", ["skin", "capture"])
def test_shared_capture_halt_failure_retains_buffers_borrower_and_retry(failure):
    _, hardware, session, gpu, skin, dma, log = shared_hardware_fixture()
    hardware.start()
    hardware.read()
    skin.fail = failure == "skin"
    dma.mmio.haltable = failure != "capture"
    with pytest.raises(RuntimeError, match="retained"):
        hardware.stop()
    assert hardware.state == "FAULT" and not skin.closed and hardware.retained
    assert "capture-free" not in log
    assert hardware in hardware.lease._resources
    with pytest.raises(RuntimeError, match="vision"):
        session.close()
    skin.fail, dma.mmio.haltable = False, True
    hardware.stop()
    assert hardware.state == "STOPPED" and not hardware.retained
    gpu.close()
    session.close()


def test_shared_capture_rejects_old_dual_channel_overlay_before_start():
    _, hardware, session, gpu, skin, _, log = shared_hardware_fixture()
    session._overlay.ip_dict["frame_dma"]["parameters"]["C_INCLUDE_MM2S"] = "1"
    with pytest.raises(ValueError, match="capture-only"):
        hardware.start()
    assert "capture-start" not in log and not skin.closed
    hardware.stop()
    gpu.close()
    session.close()


@pytest.mark.parametrize("game_controls", [False, True])
def test_shared_worker_publishes_locally_before_diagnostics_and_stops_safely(monkeypatch, game_controls):
    from types import SimpleNamespace
    from pynq_multimodal_game.vision_input import GameVisionInputProvider, VisionInputProvider
    module, hardware, session, gpu, _, _, log = shared_hardware_fixture()
    provider = GameVisionInputProvider() if game_controls else VisionInputProvider()
    observed = {"code": "5", "stable": "5", "rps": "PAPER"}

    def process(raw, recognizer, *args, **kwargs):
        kwargs["on_result"](observed)
        log.append("processed")
        return raw, {}

    class Encoder:
        def due_modes(self):
            raise ValueError("codec unavailable")

        def submit(self, factory):
            assert provider.sample(tick_id=1).hand_x == -1
            if game_controls:
                sample, receipt = provider.sample_for_game("game2", tick_id=1)
                assert sample.hand_gesture.value == "paper"
                assert receipt["source_frame_id"] == 1
            log.append("diagnostic")
            raise ValueError("codec unavailable")

    controller = SimpleNamespace(update=lambda result, frame, now: {
        "schema": "gesture-control-v1", "frame_id": frame, "action_event_seq": 0,
        "valid": True, "direction": "LEFT",
    })
    monkeypatch.setattr(module, "process_rgb", process)
    hardware.start()
    worker = module.SharedVisionWorker(hardware, SimpleNamespace(), controller, provider,
                                       run_id="local", preview_encoder=Encoder())
    worker.step()
    assert provider.receipt.result.frame_id == 1 and worker.error is None
    assert "codec unavailable" in worker.diagnostic_error
    assert log.index("processed") < log.index("diagnostic")
    worker.stop()
    provider.publish({"run_id": "local", "server_age_ms": 0, "control": controller.update({}, 2, 0)})
    assert not provider.sample(tick_id=2).hand_valid
    assert session.is_open
    gpu.close()
    session.close()


@pytest.mark.parametrize("previous,confirmed", [(0, 5), (10, 10), (0, 4)])
def test_shared_vision_priority_only_lowers_current_thread_and_confirms(monkeypatch, previous, confirmed):
    module, hardware, session, gpu, skin, dma, log = shared_hardware_fixture()
    calls, values = [], iter((previous, confirmed))
    monkeypatch.setattr(module, 'get_native_id', lambda: 12345)
    monkeypatch.setattr(module.os, 'PRIO_PROCESS', 0, raising=False)
    monkeypatch.setattr(module.os, 'getpriority', lambda kind, identity: next(values), raising=False)
    monkeypatch.setattr(module.os, 'setpriority',
                        lambda kind, identity, value: calls.append((kind, identity, value)), raising=False)
    try:
        if confirmed != max(previous, 5):
            with pytest.raises(RuntimeError, match='unconfirmed'):
                module.lower_vision_worker_cpu_priority()
        else:
            assert module.lower_vision_worker_cpu_priority() == dict(
                native_id=12345, previous_nice=previous, confirmed_nice=confirmed)
        assert calls == [(0, 12345, max(previous, 5))]
    finally:
        gpu.close()
        session.close()


@pytest.mark.parametrize('enabled', (False, True))
def test_shared_vision_cooperative_priority_runs_only_on_worker(monkeypatch, enabled):
    from threading import get_native_id
    from types import SimpleNamespace
    from pynq_multimodal_game.vision_input import VisionInputProvider
    module, hardware, session, gpu, skin, dma, log = shared_hardware_fixture()
    calls = []
    def configure():
        calls.append(get_native_id())
        return dict(confirmed_nice=5)
    monkeypatch.setattr(module, 'lower_vision_worker_cpu_priority', configure)
    worker = module.SharedVisionWorker(hardware, SimpleNamespace(), SimpleNamespace(),
                                      VisionInputProvider(), run_id='cpu-run')
    worker.cooperative_cpu = enabled
    worker.step = lambda: worker._stop.set()
    try:
        worker.start()
        worker._thread.join(2.)
        assert not worker._thread.is_alive() and worker.error is None
        assert calls == ([worker._thread.native_id] if enabled else [])
        assert get_native_id() not in calls
        assert worker.cpu_scheduling == (dict(confirmed_nice=5) if enabled else {})
    finally:
        worker.stop()
        gpu.close()
        session.close()


@pytest.mark.parametrize('enabled', (False, True))
def test_shared_vision_timing_records_read_and_existing_recognition_phases(monkeypatch, enabled):
    from types import SimpleNamespace
    module, hardware, session, gpu, skin, dma, log = shared_hardware_fixture()
    raw, processed = object(), object()
    wall_values, cpu_values = iter((100, 160)), iter((10, 30))
    clock_calls, packets = [], []
    def wall_clock():
        clock_calls.append('wall')
        return next(wall_values)
    monkeypatch.setattr(module, 'time', SimpleNamespace(**{
        **vars(module.time), 'monotonic_ns': wall_clock,
        'thread_time_ns': lambda: next(cpu_values)}))
    monkeypatch.setattr(hardware, 'read', lambda: raw)
    phases = dict(input_prepare=2., color_mask=180., overlay_resize=0.)
    def process(value, recognizer, *arguments, on_result, **options):
        assert value is raw and options['annotate'] is False
        result = dict(timing_ms=dict(phases))
        on_result(result)
        return processed, result
    monkeypatch.setattr(module, 'process_rgb', process)
    worker = module.SharedVisionWorker(hardware, SimpleNamespace(),
        SimpleNamespace(update=lambda *arguments: {}),
        SimpleNamespace(publish=lambda packet, **options: packets.append(packet)), run_id='phase-run')
    worker.measure_processing = enabled
    try:
        worker.step()
        assert len(packets) == 1 and worker.frame_id == 1
        if enabled:
            assert worker.processing_timing == dict(last_read=dict(wall_ns=60, cpu_ns=20),
                                                   last_recognition_ms=phases)
            assert clock_calls == ['wall', 'wall']
        else:
            assert worker.processing_timing == {} and clock_calls == []
    finally:
        gpu.close()
        session.close()


@pytest.mark.parametrize('capture_order', ('rgb', 'bgr'))
@pytest.mark.parametrize('rotate', (0, 180))
@pytest.mark.parametrize('mirror', (False, True))
@pytest.mark.parametrize('preview_rgb', (False, True))
def test_recognition_resize_before_channel_conversion_is_pixel_exact(monkeypatch, capture_order, rotate, mirror,
                                                                    preview_rgb):
    from types import SimpleNamespace
    import numpy as np
    module, hardware, session, gpu, skin, dma, log = shared_hardware_fixture()
    raw = np.random.default_rng(179).integers(0, 256, (720, 1280, 3), dtype=np.uint8)
    original = raw.copy()
    expected = module.cv2.resize(module.capture_to_rgb(raw, capture_order), (640, 360),
                                 interpolation=module.cv2.INTER_AREA)
    if rotate == 180:
        expected = module.cv2.rotate(expected, module.cv2.ROTATE_180)
    if mirror:
        expected = module.cv2.flip(expected, 1)
    expected_bgr = module.cv2.cvtColor(expected, module.cv2.COLOR_RGB2BGR)
    observed = []
    recognizer = SimpleNamespace(infer=lambda bgr: observed.append(bgr.copy()) or dict(timing_ms={}))
    convert = MagicMock(wraps=module.cv2.cvtColor)
    monkeypatch.setattr(module.cv2, 'cvtColor', convert)
    try:
        actual, result = module.process_rgb(raw, recognizer, rotate, mirror, capture_order, annotate=False,
                                            preview_rgb=preview_rgb)
        if preview_rgb:
            assert np.array_equal(actual, expected) and not np.shares_memory(actual, raw)
        else:
            assert actual is None
        assert np.array_equal(observed[0], expected_bgr) and np.array_equal(raw, original)
        assert convert.call_count == int(capture_order == 'rgb') + int(preview_rgb and capture_order == 'bgr')
        assert result['timing_ms']['overlay_resize'] == 0.
    finally:
        gpu.close()
        session.close()


@pytest.mark.parametrize('prepared,requested', (((), ('video',)), (('debug',), ('video', 'debug')),
                                               (('video',), ('video',)), (('video', 'debug'), ('debug',))))
def test_shared_worker_prepares_rgb_only_for_due_video(monkeypatch, prepared, requested):
    from types import SimpleNamespace
    module, hardware, session, gpu, skin, dma, log = shared_hardware_fixture()
    raw = np.random.default_rng(216).integers(0, 256, (720, 1280, 3), dtype=np.uint8)
    monkeypatch.setattr(hardware, 'read', lambda: raw)
    snapshots = []
    encoder = SimpleNamespace(due_modes=lambda: frozenset(prepared),
                              submit=lambda factory: snapshots.append(factory(frozenset(requested))))
    recognizer = SimpleNamespace(infer=lambda bgr: dict(timing_ms={}, code='NO_HAND', stable='NO_HAND'))
    provider = SimpleNamespace(publish=MagicMock())
    worker = module.SharedVisionWorker(hardware, recognizer, SimpleNamespace(update=lambda *args: {}),
        provider, run_id='due-rgb', capture_order='bgr', preview_encoder=encoder)
    convert = MagicMock(wraps=module.cv2.cvtColor)
    monkeypatch.setattr(module.cv2, 'cvtColor', convert)
    try:
        worker.step()
        provider.publish.assert_called_once()
        assert convert.call_count == int('video' in prepared)
        assert len(snapshots) == 1
        snapshot = snapshots[0]
        assert snapshot.modes == frozenset(prepared) & frozenset(requested)
        if 'video' in snapshot.modes:
            expected = module.cv2.rotate(module.cv2.resize(raw, (640, 360)), module.cv2.ROTATE_180)[:, :, ::-1]
            assert np.array_equal(snapshot.rgb, expected)
        else:
            assert snapshot.rgb is None
    finally:
        gpu.close()
        session.close()


@pytest.mark.parametrize('enabled,fails', ((False, False), (True, False), (True, True)))
@pytest.mark.parametrize('step_count', (2, 18))
def test_shared_vision_processing_timing_is_thread_local_and_opt_in(monkeypatch, enabled, fails, step_count):
    from types import SimpleNamespace
    from pynq_multimodal_game.vision_input import VisionInputProvider
    module, hardware, session, gpu, skin, dma, log = shared_hardware_fixture()
    samples = [dict(started_ns=100 + index * 100,
                    finished_ns=160 + index * 100 + (index % 2) * 20,
                    cpu_ns=20 + (index % 2) * 10) for index in range(step_count)]
    wall_values = iter(value for sample in samples for value in (sample['started_ns'], sample['finished_ns']))
    cpu_values = iter(value for sample in samples for value in (0, sample['cpu_ns']))
    clock_calls, steps = [], []
    def wall_clock():
        clock_calls.append('wall')
        return next(wall_values)
    monkeypatch.setattr(module, 'time', SimpleNamespace(**{
        **vars(module.time), 'monotonic_ns': wall_clock,
        'thread_time_ns': lambda: next(cpu_values)}))
    worker = module.SharedVisionWorker(hardware, SimpleNamespace(), SimpleNamespace(),
                                      VisionInputProvider(), run_id='timed-run')
    worker.measure_processing = enabled
    timing = worker.processing_timing
    def step():
        steps.append(len(steps))
        if len(steps) == step_count:
            worker._stop.set()
            if fails:
                raise RuntimeError('injected vision failure')
    worker.step = step
    try:
        worker.start()
        worker._thread.join(2.)
        assert not worker._thread.is_alive() and len(steps) == step_count
        assert worker.processing_timing is timing and not worker.cpu_scheduling
        assert ('injected vision failure' in (worker.error or '')) is fails
        if enabled:
            assert timing == dict(native_id=worker._thread.native_id, steps=step_count,
                                  first_started_ns=100, last_finished_ns=samples[-1]['finished_ns'],
                                  wall_ns=sum(sample['finished_ns'] - sample['started_ns'] for sample in samples),
                                  cpu_ns=sum(sample['cpu_ns'] for sample in samples),
                                  max_wall_ns=80, max_cpu_ns=30, recent_steps=samples[-16:])
            assert clock_calls == ['wall'] * (2 * step_count)
        else:
            assert timing == {} and clock_calls == []
    finally:
        worker.stop()
        gpu.close()
        session.close()


@pytest.mark.parametrize("case", ("resume", "repeat", "stop", "timeout"))
def test_shared_worker_processing_pause_keeps_hardware_and_run(case):
    from threading import Thread
    from types import SimpleNamespace
    from pynq_multimodal_game.vision_input import VisionInputProvider
    module, hardware, session, gpu, skin, dma, log = shared_hardware_fixture()
    worker = module.SharedVisionWorker(hardware, SimpleNamespace(), SimpleNamespace(),
                                      VisionInputProvider(), run_id="same-run")
    entered, unblock, resumed = Event(), Event(), Event()
    calls, errors = [], []

    def step():
        calls.append(len(calls))
        if len(calls) == 1:
            entered.set()
            unblock.wait()
        else:
            resumed.set()
            if case == "repeat" and len(calls) == 2:
                worker._processing_pause.wait(2)
            else:
                worker._stop.wait()

    def pause():
        try:
            worker.pause_processing(timeout=2.)
        except BaseException as error:
            errors.append(error)

    worker.step = step
    worker.start()
    pauser = None
    try:
        assert entered.wait(2)
        if case == "timeout":
            with pytest.raises(RuntimeError, match="not acknowledged"):
                worker.pause_processing(timeout=.001)
            assert not worker._processing_pause.is_set()
        else:
            pauser = Thread(target=pause)
            pauser.start()
            assert not worker._processing_paused.wait(.01)
            unblock.set()
            pauser.join(2)
            assert not pauser.is_alive() and not errors
            assert worker._processing_paused.is_set() and calls == [0]
            assert worker.run_id == "same-run" and hardware.state == "RUNNING"
            assert "capture-free" not in log and not skin.closed
            if case in ("resume", "repeat"):
                worker.resume_processing()
                assert resumed.wait(2)
                if case == "repeat":
                    worker.pause_processing(timeout=2)
                    assert worker._processing_paused.is_set() and calls == [0, 1]
    finally:
        unblock.set()
        worker.stop(timeout=2.)
        if pauser is not None:
            pauser.join(2)
        gpu.close()
        session.close()
    if case == "stop":
        assert calls == [0]


def test_shared_supervisor_processing_pause_keeps_same_worker():
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.vision_backend import SharedVisionSupervisor
    from pynq_multimodal_game.vision_input import VisionInputProvider
    calls = []
    worker = SimpleNamespace(pause_processing=lambda: calls.append("pause"),
                             resume_processing=lambda: calls.append("resume"))
    supervisor = SharedVisionSupervisor(lambda run: worker, VisionInputProvider())
    with pytest.raises(RuntimeError, match="running vision worker"):
        supervisor.pause_processing()
    supervisor._worker, supervisor._run_id = worker, "same-run"
    supervisor.pause_processing()
    supervisor.resume_processing()
    assert calls == ["pause", "resume"]
    assert supervisor._worker is worker and supervisor._run_id == "same-run"


def test_shared_worker_join_failure_retains_hardware_until_explicit_retry():
    from types import SimpleNamespace
    from pynq_multimodal_game.vision_input import VisionInputProvider
    module, hardware, session, gpu, skin, dma, log = shared_hardware_fixture()
    entered, unblock = Event(), Event()

    def blocked_capture():
        entered.set()
        unblock.wait()
        return dma.readchannel.pixels

    dma.readchannel.readframe = blocked_capture
    provider = VisionInputProvider()
    worker = module.SharedVisionWorker(hardware, SimpleNamespace(), SimpleNamespace(), provider, run_id="blocked")
    worker.start()
    try:
        assert entered.wait(2)
        with pytest.raises(RuntimeError, match="borrower retained"):
            worker.stop(timeout=.001)
        assert worker.state == "FAULT" and not skin.closed
        assert "capture-free" not in log
        with pytest.raises(RuntimeError, match="vision"):
            session.close()
    finally:
        unblock.set()
        worker.stop(timeout=2)
        gpu.close()
        session.close()
    assert not provider.sample(tick_id=0).hand_valid


def test_shared_worker_http_result_failure_preserves_local_input(monkeypatch):
    from types import SimpleNamespace
    from pynq_multimodal_game.vision_input import VisionInputProvider

    module, hardware, session, gpu, _, _, _ = shared_hardware_fixture()
    provider = VisionInputProvider()
    controller = SimpleNamespace(update=lambda *_args: {
        "schema": "gesture-control-v1", "frame_id": 1, "action_event_seq": 0,
        "valid": True, "direction": "RIGHT",
    })
    def process(raw, _recognizer, *_args, **kwargs):
        kwargs["on_result"]({})
        return raw, {}
    def broken_http(_payload):
        assert provider.sample(tick_id=1).hand_x == 1
        raise OSError("HTTP result relay failed")
    monkeypatch.setattr(module, "process_rgb", process)
    hardware.start()
    worker = module.SharedVisionWorker(hardware, SimpleNamespace(), controller, provider, run_id="http-fault")
    worker.preview = SimpleNamespace(publish_result=broken_http)
    worker.step()
    assert worker.error is None and "HTTP result relay failed" in worker.diagnostic_error
    assert provider.sample(tick_id=2).hand_valid
    worker.stop()
    gpu.close()
    session.close()


def test_shared_worker_records_run_and_explicit_cleanup(tmp_path, monkeypatch):
    import json
    from types import SimpleNamespace
    from pynq_multimodal_game.vision_input import VisionInputProvider

    module, hardware, session, gpu, _, _, _ = shared_hardware_fixture()
    run_dir = tmp_path / 'run-identity'
    worker = module.SharedVisionWorker(hardware, SimpleNamespace(), SimpleNamespace(), VisionInputProvider(),
                                      run_id='run-identity', run_dir=run_dir)
    assert not run_dir.exists()
    monkeypatch.setattr(worker, 'step', worker._stop.set)
    worker.start()
    worker._thread.join(2.)
    assert not worker._thread.is_alive() and worker.error is None
    assert json.loads((run_dir / 'run_config.json').read_text())['board_pending'] is True
    assert not (run_dir / 'stop_receipt.json').exists()
    worker.stop()
    assert json.loads((run_dir / 'stop_receipt.json').read_text())['cleanup_confirmed'] is True
    gpu.close()
    session.close()


def test_shared_worker_encoder_start_failure_retains_preview_for_stop(monkeypatch):
    from types import SimpleNamespace
    from unittest.mock import MagicMock
    from pynq_multimodal_game.vision_input import VisionInputProvider

    module, hardware, session, gpu, _, _, _ = shared_hardware_fixture()
    preview = SimpleNamespace(demand=lambda: None, close=MagicMock())
    monkeypatch.setattr(module, 'ProcessPreviewEncoder', MagicMock(side_effect=OSError('encoder start failed')))
    worker = module.SharedVisionWorker(hardware, SimpleNamespace(), SimpleNamespace(), VisionInputProvider(),
                                      run_id='preview-start-fault', preview_factory=lambda: preview)
    worker.start()
    worker._thread.join(2.)
    assert not worker._thread.is_alive() and 'encoder start failed' in worker.error
    assert hardware.lease is None and worker.preview is preview
    preview.close.assert_not_called()
    worker.stop()
    preview.close.assert_called_once()
    gpu.close()
    session.close()


def test_shared_worker_preview_prewarm_precedes_capture_and_is_reused(tmp_path, monkeypatch):
    from types import SimpleNamespace
    from pynq_multimodal_game.vision_input import VisionInputProvider
    from pynq_multimodal_game.vision_preview import PreviewHealth

    module, hardware, session, gpu, _, _, _ = shared_hardware_fixture()
    encoder = MagicMock()
    encoder.health.return_value = PreviewHealth('RUNNING', True, True, 123, None, '', 'NOT_STARTED')
    factory = MagicMock(return_value=encoder)
    monkeypatch.setattr(module, 'ProcessPreviewEncoder', factory)
    worker = module.SharedVisionWorker(hardware, SimpleNamespace(), SimpleNamespace(), VisionInputProvider(),
        run_id='prewarmed', run_dir=tmp_path / 'prewarmed', preview_factory=MagicMock())
    monkeypatch.setattr(worker, 'step', worker._stop.set)
    worker.prepare_preview()
    worker.prepare_preview()
    assert hardware.lease is None and worker._thread is None
    factory.assert_called_once()
    assert factory.call_args.kwargs['startup_log'] == tmp_path / 'prewarmed/preview-startup.jsonl'
    worker.start()
    worker._thread.join(2)
    assert worker.error is None and worker.preview_encoder is encoder
    factory.assert_called_once()
    worker.stop()
    gpu.close()
    session.close()


def test_cached_skin_factory_preserves_xml_checks_and_restores_module(tmp_path):
    from types import SimpleNamespace
    from unittest.mock import patch
    from xml.etree import ElementTree
    import pytest
    import sys

    module, hardware, session, gpu, _, _, _ = shared_hardware_fixture()
    hwh = tmp_path / 'paired.hwh'
    hwh.write_text('<ROOT><MODULE INSTANCE="skin_kernel" MODTYPE="bgr_skin_dma"/></ROOT>')
    original = SimpleNamespace(parse=ElementTree.parse)
    driver = SimpleNamespace(ElementTree=original)
    def frozen_factory(*, fail=False):
        tree = driver.ElementTree.parse(hwh)
        assert tree.getroot().find('MODULE').get('MODTYPE') == 'bgr_skin_dma'
        if fail:
            raise RuntimeError('driver failed')
        return tree
    with patch.dict(sys.modules, {'cached_skin_test_driver': driver}):
        frozen_factory.__module__ = 'cached_skin_test_driver'
        factory = module.prepare_skin_factory(frozen_factory, hwh)
        first = factory()
        assert factory() is first and driver.ElementTree is original
        with pytest.raises(RuntimeError, match='driver failed'):
            factory(fail=True)
        assert driver.ElementTree is original
        hwh.write_text('<ROOT/>')
        with pytest.raises(ValueError, match='paired identity changed'):
            factory()
        assert driver.ElementTree is original
    assert hardware.lease is None
    gpu.close()
    session.close()


def test_shared_supervisor_prepares_same_worker_before_start():
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.vision_backend import SharedVisionSupervisor
    from pynq_multimodal_game.vision_input import VisionInputProvider

    calls = []
    worker = SimpleNamespace(state='IDLE', error=None, frame_id=0, diagnostic_error=None,
        prepare_preview=lambda: calls.append('prepare'), start=lambda: calls.append('start'),
        stop=lambda: calls.append('stop'))
    factory = MagicMock(return_value=worker)
    supervisor = SharedVisionSupervisor(factory, VisionInputProvider())
    prepared = supervisor.prepare()
    assert prepared['state'] == 'IDLE' and not prepared['owner_held']
    assert not prepared['cleanup_confirmed']
    run_id = supervisor.status()['run_id']
    assert calls == ['prepare']
    supervisor.start()
    supervisor.start()
    assert calls == ['prepare', 'start'] and supervisor.status()['run_id'] == run_id
    factory.assert_called_once()
    assert supervisor.stop()['cleanup_confirmed']


def test_async_candidate_http_only_subscribes_requested_views() -> None:
    path = Path(__file__).resolve().parents[1] / "board/pynq_z2/scripts/vision_async_runtime.py"
    spec = importlib.util.spec_from_file_location("vision_async_candidate", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    preview = module.BytesPreview("127.0.0.1", 0)
    url = f"http://127.0.0.1:{preview.server.server_port}"
    try:
        assert preview.demand() == frozenset()
        with urlopen(url + "/result.json", timeout=1) as response:
            packet = json.loads(response.read())
            assert packet["server_age_ms"] is None
            assert packet["preview_health"]["status"] == "STARTING"
        assert preview.demand() == frozenset()
        with pytest.raises(HTTPError) as error:
            urlopen(url + "/debug.jpg", timeout=1)
        assert error.value.code == 503
        error.value.close()
        assert preview.demand() == frozenset({"debug"})
        preview.publish_debug(b"cached-jpeg")
        with urlopen(url + "/debug.jpg", timeout=1) as response:
            assert response.read() == b"cached-jpeg"
        with preview.lock:
            preview.debug_requested_at = float("-inf")
        assert preview.demand() == frozenset()
        preview.publish_result(json.dumps({"frame": 7, "run_id": "offline", "control": {
            "schema": "gesture-control-v1", "frame_id": 7, "valid": False}}).encode())
        stream = urlopen(url + "/camera.mjpg", timeout=2)
        try:
            assert stream.status == 200
            preview.update_health({"status": "DEGRADED", "reason": "codec exited", "exitcode": 23})
            assert stream.read() == b""
        finally:
            stream.close()
        preview.publish(b"late-jpeg")
        preview.publish_debug(b"late-debug")
        assert preview.jpeg == preview.debug_jpeg == b""
        assert not preview.demand()
        for endpoint in ("/debug.jpg", "/camera.mjpg"):
            with pytest.raises(HTTPError) as error:
                urlopen(url + endpoint, timeout=1)
            assert error.value.code == 503
            error.value.close()
        with urlopen(url + "/result.json", timeout=1) as response:
            packet = json.loads(response.read())
            assert packet["frame"] == packet["control"]["frame_id"] == 7
            assert packet["run_id"] == "offline"
            assert packet["preview_health"]["exitcode"] == 23
            assert packet["server_age_ms"] >= 0
        with preview.lock:
            assert preview.video_clients == 0
    finally:
        preview.close()
    assert not preview.thread.is_alive()


def test_video_encoding_demand_follows_preview_connection() -> None:
    path = Path(__file__).resolve().parents[1] / "board/pynq_z2/scripts/vision_async_runtime.py"
    spec = importlib.util.spec_from_file_location("vision_async_candidate_demand", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    preview = module.BytesPreview("127.0.0.1", 0)
    connection = HTTPConnection("127.0.0.1", preview.server.server_port, timeout=1)
    try:
        assert preview.demand() == frozenset()
        connection.request("GET", "/camera.mjpg")
        response = connection.getresponse()
        assert response.status == 200
        deadline = time.monotonic() + 1
        while "video" not in preview.demand() and time.monotonic() < deadline:
            time.sleep(0.01)
        assert preview.demand() == frozenset({"video"})
        response.close()
        connection.close()
        deadline = time.monotonic() + 0.8
        while preview.demand() and time.monotonic() < deadline:
            time.sleep(0.025)
        assert preview.demand() == frozenset()
        assert preview.video_clients == 0
    finally:
        connection.close()
        preview.close()


def test_candidate_unannotated_inference_matches_original_and_text_free_background(monkeypatch) -> None:
    import cv2

    scripts = Path(__file__).resolve().parents[1] / "board/pynq_z2/scripts"
    monkeypatch.syspath_prepend(str(scripts))
    module = importlib.import_module("vision_async_runtime")
    raw = np.zeros((720, 1280, 3), dtype=np.uint8)
    recognizer = module.OriginalContour(5)
    recognizer.debug_enabled = True
    plain, result = module.process_rgb(raw, recognizer, output_size=(640, 360), annotate=False)
    expected, baseline = module.process_rgb(raw, module.OriginalContour(5), output_size=(640, 360))
    assert result["code"] == baseline["code"]
    assert result["centroid"] == baseline["centroid"]
    assert result["stable"] == baseline["stable"]
    assert np.array_equal(result["mask"], baseline["mask"])
    assert result["timing_ms"]["overlay_resize"] == 0
    result["preview_needs_annotation"] = True
    snapshot = PreviewSnapshot(1, frozenset({"video"}), plain, result, {})
    jpeg = module.encode_preview_snapshot(snapshot, "video")
    # Empty black capture retains the original ROI geometry, with no text/mask
    # inset. Inference above remains byte-equivalent to the annotated baseline.
    clean = cv2.cvtColor(plain, cv2.COLOR_RGB2BGR)
    x0, y0, x1, y1 = result['roi']
    cv2.rectangle(clean, (x0, y0), (x1 - 1, y1 - 1), (255, 255, 0), 1)
    ok, gold = cv2.imencode(".jpg", clean, [cv2.IMWRITE_JPEG_QUALITY, 75])
    assert ok and jpeg == gold.tobytes()
    assert not np.array_equal(cv2.cvtColor(expected, cv2.COLOR_RGB2BGR), clean)


def test_formal_candidate_codec_starts_under_spawn(monkeypatch) -> None:
    import cv2

    scripts = Path(__file__).resolve().parents[1] / "board/pynq_z2/scripts"
    monkeypatch.syspath_prepend(str(scripts))
    module = importlib.import_module("vision_async_runtime")
    raw = np.zeros((720, 1280, 3), dtype=np.uint8)
    plain, result = module.process_rgb(raw, module.OriginalContour(5), annotate=False)
    result["preview_needs_annotation"] = True
    delivered = Event()
    images = []

    def publish(mode, payload):
        images.append(cv2.imdecode(np.frombuffer(payload, dtype=np.uint8), cv2.IMREAD_COLOR))
        delivered.set()

    worker = ProcessPreviewEncoder(lambda: frozenset({"video"}),
                                   module.encode_preview_snapshot, publish)
    try:
        assert worker.submit(lambda modes: PreviewSnapshot(1, modes, plain, result, {}))
        assert delivered.wait(5)
        assert images[0].shape == (360, 640, 3)
        assert worker.stats()["errors"] == 0
    finally:
        worker.close()


@pytest.mark.parametrize("fault", [None, "codec_exit", "startup", "inference", "hardware_cleanup", "guarded_cleanup"])
def test_candidate_main_no_subscription_preserves_control_and_cleanup(monkeypatch, tmp_path, capsys, fault) -> None:
    scripts = Path(__file__).resolve().parents[1] / "board/pynq_z2/scripts"
    monkeypatch.syspath_prepend(str(scripts))
    module = importlib.import_module("vision_async_runtime")
    stopped = Event()
    read = MagicMock()
    raw = np.zeros((720, 1280, 3), dtype=np.uint8)
    calls = []
    workers = []

    def make_encoder(*args, **kwargs):
        if fault == "startup":
            raise RuntimeError("Preview initialization failed")
        worker = ProcessPreviewEncoder(*args, **kwargs)
        worker.submit = MagicMock(wraps=worker.submit)
        if fault == "inference":
            original_close = worker.close
            def diagnostic_cleanup_failure(timeout=3.0):
                original_close(timeout)
                raise RuntimeError("Diagnostic cleanup failure")
            worker.close = diagnostic_cleanup_failure
        workers.append(worker)
        return worker

    def capture():
        calls.append(1)
        if fault == "codec_exit" and len(calls) == 2:
            read.stop.assert_not_called()
            workers[0]._process.terminate()
            workers[0]._process.join(5)
            assert not workers[0]._process.is_alive()
        if len(calls) > (3 if fault in ("codec_exit", "inference") else 1):
            stopped.set()
        return raw

    read.readframe.side_effect = capture
    camera = MagicMock(WIDTH=1280, HEIGHT=720,
                       REQUIRED_IP={"frame_dma", "camera_iic", "demosaic"})
    camera.open_frame_dma.return_value = types.SimpleNamespace(readchannel=read)
    pynq = types.ModuleType("pynq")
    pynq.Overlay = MagicMock()
    iic = types.ModuleType("pynq.lib.iic")
    iic.AxiIIC = MagicMock()
    video = types.ModuleType("pynq.lib.video")
    video.VideoMode = MagicMock(return_value="mode")
    for name, value in {"pynq": pynq, "pynq.lib.iic": iic, "pynq.lib.video": video}.items():
        monkeypatch.setitem(sys.modules, name, value)
    (tmp_path / "capture_camera_direct_plug.py").touch()
    bit = module.RUNTIME_DIR / "camera_hand_skin_v6.bit"
    monkeypatch.setattr(sys, "argv", ["candidate", str(bit), str(tmp_path / "first.ppm"),
                        "--live", "--host-only", "--tracking", "--debug-view", "--duration", "1",
                        "--camera-dir", str(tmp_path), "--results-dir", str(tmp_path / "results")])
    monkeypatch.setattr(module.os, "geteuid", lambda: 0, raising=False)
    original_import = importlib.import_module
    monkeypatch.setattr(module.importlib, "import_module",
                        lambda name: camera if name == "capture_camera_direct_plug" else original_import(name))
    monkeypatch.setattr(module, "Event", lambda: stopped)
    monkeypatch.setattr(module.signal, "signal", lambda *_: None)
    preview = MagicMock()
    preview.demand.return_value = frozenset()
    monkeypatch.setattr(module, "BytesPreview", lambda *_: preview)
    monkeypatch.setattr(module, "ProcessPreviewEncoder", make_encoder)
    receipt_path = tmp_path / "worker_lifecycle.json"
    if fault == "guarded_cleanup":
        monkeypatch.setattr(sys, "argv", [*sys.argv, "--guard-receipt", str(receipt_path)])
        def retained_by_guard():
            packet = json.loads(receipt_path.read_text())
            assert packet["state"] == "FAULT" and packet["retaining_buffers"]
            assert packet["cleanup"]["hardware"]
            assert packet["frame_id"] == 1
            assert len(sys._getframe(1).f_locals["retained"]) > 0
            raise SystemExit(77)
        monkeypatch.setattr(module, "retain_for_guard", retained_by_guard)
    if fault in ("hardware_cleanup", "inference", "guarded_cleanup"):
        read.stop.side_effect = RuntimeError("Capture DMA stop failure")
    if fault == "inference":
        original_process = module.process_rgb
        def broken_inference(*args, **kwargs):
            if len(calls) == 2:
                raise ValueError("Original inference failure")
            return original_process(*args, **kwargs)
        monkeypatch.setattr(module, "process_rgb", broken_inference)
    if fault == "startup":
        with pytest.raises(RuntimeError, match="Preview initialization failed"):
            module.main()
        pynq.Overlay.assert_not_called()
        read.start.assert_not_called()
        read.stop.assert_not_called()
        preview.close.assert_called_once()
        return
    failure = None
    if fault == "guarded_cleanup":
        with pytest.raises(SystemExit) as retained:
            module.main()
        assert retained.value.code == 77
    elif fault == "inference":
        with pytest.raises(ValueError, match="Original inference failure") as failure:
            module.main()
    elif fault == "hardware_cleanup":
        with pytest.raises(RuntimeError, match="hardware cleanup failed; outer guard must halt DMA") as failure:
            module.main()
    else:
        module.main()
    if fault in ("inference", "hardware_cleanup"):
        assert failure is not None
        main_frame = next(frame for frame, _ in traceback.walk_tb(failure.value.__traceback__)
                          if frame.f_code.co_name == "main")
        assert len(main_frame.f_locals["retained"]) > 0
    pynq.Overlay.assert_called_once()
    read.start.assert_called_once()
    read.stop.assert_called_once()
    preview.publish.assert_not_called()
    preview.publish_debug.assert_not_called()
    preview.close.assert_called_once()
    packet = json.loads(preview.publish_result.call_args.args[0])
    assert packet["control"]["schema"] == "gesture-control-v1"
    assert not packet["hdmi_enabled"]
    run = next((tmp_path / "results").iterdir())
    summary = json.loads((run / "performance_summary.json").read_text())
    assert summary["preview_worker"]["submitted"] == 0
    assert not summary["preview_worker"]["running"]
    assert summary["metrics"]["inference_ms"]["count"] == (3 if fault == "codec_exit" else 1)
    assert workers[0].health().status == "CLOSED"
    if fault == "codec_exit":
        assert [json.loads(call.args[0])["control"]["frame_id"]
                for call in preview.publish_result.call_args_list] == [1, 2, 3]
        assert workers[0].submit.call_count == 1
        assert preview.update_health.call_args.args[0]["status"] == "DEGRADED"
        assert summary["preview_worker"]["health"]["exitcode"] != 0
        assert summary["cleanup"]["diagnostic"]
        assert not summary["cleanup"]["hardware"]
        assert "outer guard must halt DMA" not in capsys.readouterr().out
    if fault == "inference":
        assert summary["primary_error"] == "Original inference failure"
        assert summary["cleanup"]["diagnostic"] and summary["cleanup"]["hardware"]
    if fault == "hardware_cleanup":
        assert summary["cleanup"]["hardware"]


def test_candidate_recognizer_ast_matches_frozen_source() -> None:
    root = Path(__file__).resolve().parents[1]
    candidate = ast.parse((root / "board/pynq_z2/scripts/vision_async_runtime.py").read_text(encoding="utf-8"))
    frozen = ast.parse((root / "handoffs/gesture_vision_v61/runtime/project1_live_ov5640.py").read_text(encoding="utf-8"))
    for name in ("OriginalContour", "FullFrameTracker"):
        actual = next(node for node in candidate.body if isinstance(node, ast.ClassDef) and node.name == name)
        baseline = next(node for node in frozen.body if isinstance(node, ast.ClassDef) and node.name == name)
        assert ast.dump(actual) == ast.dump(baseline)


def test_process_encoder_isolated_pid_and_latest_shared_snapshot() -> None:
    context = multiprocessing.get_context("spawn")
    entered, release = context.Event(), context.Event()
    latest = Event()
    received = []
    pixels = np.zeros((2, 2, 3), dtype=np.uint8)

    def publish(mode, payload):
        received.append(payload.decode().split(":"))
        if received[-1][0] == "4":
            latest.set()

    worker = ProcessPreviewEncoder(lambda: frozenset({"video"}),
                                   partial(_encode_process_probe, entered, release), publish,
                                   video_fps=10)
    try:
        factory = lambda frame: lambda modes: PreviewSnapshot(frame, modes, pixels, None, None)
        assert worker.submit(factory(1), now=1.0)
        assert entered.wait(5)
        for frame in (2, 3, 4):
            assert worker.submit(factory(frame), now=1.0 + frame * 0.2)
        pixels[:] = 255
        assert worker.stats()["pending"] <= 2
        release.set()
        assert latest.wait(5)
        assert [packet[0] for packet in received] == ["1", "4"]
        assert all(packet[1] == "0" for packet in received)
        assert all(int(packet[2]) != os.getpid() for packet in received)
        assert all(int(packet[2]) == worker.stats()["codec_pid"] for packet in received)
    finally:
        release.set()
        worker.close()
    assert not worker.stats()["running"]
