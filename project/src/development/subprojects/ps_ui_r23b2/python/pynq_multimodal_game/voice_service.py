from __future__ import annotations

from copy import deepcopy
import hashlib
import importlib
import json
import multiprocessing as mp
from pathlib import Path
import sys
import threading
import time
import uuid

from .voice_observations import VoiceObservationBus, VoiceResultValidator


_VENDOR_NAME = "voice_rule_cooperative_20261012"
_PROVENANCE_SHA = "d339d9dbb372f23d1579bc68e6e5fcbebe4be4a3ef09106bdc82831e669d9066"
_COMMIT = "9212bf04e12fe6bdf3e006858beb1f5f9b7ce942"
VENDOR_ROOT = Path(__file__).resolve().parent / "_vendor" / _VENDOR_NAME


def verify_frozen_source(root: Path = VENDOR_ROOT) -> dict:
    root = Path(root).resolve(strict=True)
    raw = (root / "provenance.json").read_bytes()
    if hashlib.sha256(raw).hexdigest() != _PROVENANCE_SHA:
        raise RuntimeError("Frozen voice provenance SHA mismatch")
    manifest = json.loads(raw)
    if manifest["source_commit"] != _COMMIT or len(manifest["files"]) != 33:
        raise RuntimeError("Frozen voice source identity mismatch")
    for source in root.rglob("*"):
        if (source.is_file() and source.suffix.lower() in (".py", ".pyd", ".so")
                and source.relative_to(root).as_posix() not in manifest["files"]):
            raise RuntimeError(f"Unlisted frozen voice executable: {source.name}")
    for relative, expected in manifest["files"].items():
        source = (root / relative).resolve(strict=True)
        if root not in source.parents or hashlib.sha256(source.read_bytes()).hexdigest() != expected:
            raise RuntimeError(f"Frozen voice source SHA mismatch: {relative}")
    return manifest


def _frozen_worker():
    verify_frozen_source()
    module = importlib.import_module(f"{__package__}._vendor.{_VENDOR_NAME}.voice_cpu_worker")
    if Path(module.__file__).resolve() != VENDOR_ROOT / "voice_cpu_worker.py":
        raise RuntimeError("Wrong qualified CPU worker origin")
    return module


class _CaptureInput:
    def __init__(self, incoming, capture_gate):
        self._incoming, self._capture_gate = incoming, capture_gate
        self._started = False

    def get(self, *, timeout):
        if not self._started:
            if not self._capture_gate.wait(60):
                raise TimeoutError("CPU first-input preparation deadline")
            self._started = True
        return self._incoming.get(timeout=timeout)


class CpuFeatureLibrary:
    def __init__(self, path, expected_sha256):
        import ctypes
        path = Path(path).resolve(strict=True)
        if hashlib.sha256(path.read_bytes()).hexdigest() != expected_sha256:
            raise RuntimeError("CPU feature library SHA mismatch")
        self.library = ctypes.CDLL(str(path))
        self.library.vvg_cpu_features_abi.argtypes = []
        self.library.vvg_cpu_features_abi.restype = ctypes.c_uint32
        if self.library.vvg_cpu_features_abi() != 0x00010001:
            raise RuntimeError("CPU feature library ABI mismatch")
        pointer = ctypes.POINTER(ctypes.c_double)
        self.library.vvg_cpu_features_prepare.argtypes = [pointer, ctypes.c_int, ctypes.c_int, pointer, pointer, pointer]
        self.library.vvg_cpu_features_prepare.restype = ctypes.c_int
        self.library.vvg_cpu_features_finish.argtypes = [pointer, pointer, pointer, pointer,
            ctypes.POINTER(ctypes.c_int32), *([ctypes.c_int] * 5), *([ctypes.c_double] * 4), pointer]
        self.library.vvg_cpu_features_finish.restype = ctypes.c_int
        self.library.vvg_cpu_preprocess_dc.argtypes = [pointer, ctypes.c_int, pointer,
            ctypes.c_double, ctypes.c_double, ctypes.c_double, pointer, pointer]
        self.library.vvg_cpu_preprocess_dc.restype = ctypes.c_int
        self._pointer = pointer
        self._workspace_feature, self._workspace = None, None
        self._dc_workspace = None

    def preprocess(self, preprocessor, samples):
        return _cpu_preprocess(preprocessor, samples, dc_library=self)

    def dc(self, preprocessor, samples):
        import numpy as np
        values = np.ascontiguousarray(samples, dtype=np.float64)
        if values.ndim != 1 or not 0 < len(values) <= 960:
            raise ValueError("CPU DC preprocessing requires 1..960 mono samples")
        weights = np.ascontiguousarray(preprocessor.weights, dtype=np.float64)
        if weights.shape != (256,):
            raise ValueError("CPU preprocessing requires exact 256-point weights")
        pointer = lambda array: array.ctypes.data_as(self._pointer)
        if self._dc_workspace is None or self._dc_workspace[0].shape != values.shape:
            output, state = np.empty(values.shape, dtype=np.float64), np.empty(2, dtype=np.float64)
            self._dc_workspace = output, state, pointer(output), pointer(state)
        output, state, output_pointer, state_pointer = self._dc_workspace
        if self.library.vvg_cpu_preprocess_dc(pointer(values), len(values), pointer(weights),
            preprocessor.a, preprocessor.previous, preprocessor.carry, output_pointer, state_pointer) != 0:
            raise RuntimeError("CPU DC preprocessing rejected")
        preprocessor.previous, preprocessor.carry = float(state[0]), float(state[1])
        return output

    def __call__(self, feature, samples):
        import ctypes
        import numpy as np
        windows = np.ascontiguousarray(samples, dtype=np.float64)
        if windows.ndim != 2 or windows.shape[1] != 512 or feature.n != 512 or not 0 < len(windows) <= 64:
            raise ValueError("CPU feature library requires 1..64 complete 512-sample windows")
        pointer = lambda array: array.ctypes.data_as(self._pointer)
        if (self._workspace is None or self._workspace_feature is not feature
            or self._workspace[0].shape != windows.shape):
            centered = np.empty(windows.shape, dtype=np.float64)
            energy = np.empty(windows.shape, dtype=np.float64)
            metrics = np.empty((len(windows), 2), dtype=np.float64)
            output = np.empty((len(windows), 8), dtype=np.float64)
            lags = np.ascontiguousarray(feature.lags, dtype=np.int32)
            self._workspace_feature = feature
            self._workspace = (centered, energy, metrics, output, lags,
            pointer(centered), pointer(energy), pointer(metrics), pointer(output),
            lags.ctypes.data_as(ctypes.POINTER(ctypes.c_int32)))
        (centered, energy, metrics, output, lags, centered_pointer, energy_pointer,
            metrics_pointer, output_pointer, lags_pointer) = self._workspace
        if self.library.vvg_cpu_features_prepare(pointer(windows), len(windows), feature.n,
            centered_pointer, energy_pointer, metrics_pointer) != 0:
            raise RuntimeError("CPU feature preparation rejected")
        size = 1 << (2 * feature.n - 2).bit_length()
        autocorrelation = np.fft.rfft(centered, size, axis=1)
        correlation = np.ascontiguousarray(np.fft.irfft(autocorrelation * np.conj(autocorrelation), size,
                                                       axis=1)[:, feature.lags])
        spectrum = np.ascontiguousarray(np.abs(np.fft.rfft(centered * feature.window, axis=1)))
        if self.library.vvg_cpu_features_finish(energy_pointer, metrics_pointer, pointer(correlation), pointer(spectrum),
            lags_pointer, len(windows), len(lags),
                int(feature.cfg['hi_first_bin']), feature.low_first, feature.low_last,
                float(feature.fs), float(feature.cfg['autocorr_eps']), float(feature.cfg['q_min']),
                float(feature.cfg['spectrum_eps']), output_pointer) != 0:
            raise RuntimeError("CPU feature completion rejected")
        return [(float(row[0]), float(row[1]), int(row[2]), float(row[3]), float(row[4]),
                 float(row[5]), float(row[6]), bool(row[7])) for row in output]


def _cpu_preprocess(preprocessor, samples, dc_library=None):
    import numpy as np
    samples = np.asarray(samples, dtype=np.float64)
    if samples.ndim != 1 or not 0 < len(samples) <= 960 or not np.isfinite(samples).all():
        raise ValueError('Require 1..960 finite mono input samples')
    if dc_library is not None:
        dc = dc_library.dc(preprocessor, samples)
    else:
        dc = np.empty(samples.shape, dtype=np.float64)
        for start in range(0, len(samples), 256):
            chunk = samples[start:start + 256]
            differences = np.empty(chunk.shape, dtype=np.float64)
            differences[0] = chunk[0] - preprocessor.previous
            differences[1:] = chunk[1:] - chunk[:-1]
            weights = preprocessor.weights[:len(chunk)]
            values = weights * (preprocessor.a * preprocessor.carry + (differences / weights).cumsum())
            dc[start:start + len(chunk)] = values
            preprocessor.carry, preprocessor.previous = float(values[-1]), float(chunk[-1])
    extended = np.concatenate((preprocessor.history, dc))
    history_size = len(preprocessor.history)
    phase = (-preprocessor.input_count) % 6
    if preprocessor.decimated_fir:
        windows = np.lib.stride_tricks.sliding_window_view(extended, len(preprocessor.coeff))[phase::6]
        output = np.einsum('ij,j->i', windows, preprocessor.coeff[::-1], optimize=False)
    else:
        filtered = np.fft.irfft(np.fft.rfft(extended, preprocessor.fft_size) * preprocessor.coeff_fft,
                               preprocessor.fft_size)
        output = filtered[history_size:history_size + len(dc)][phase::6].copy()
    preprocessor.history = extended[-history_size:].copy()
    preprocessor.input_count += len(samples)
    return output


def _cpu_feature_batch(feature, samples):
    import numpy as np
    windows = np.asarray(samples, dtype=np.float64)
    if windows.ndim != 2 or windows.shape[1] != feature.n or not len(windows):
        raise ValueError('Require nonempty matrix of complete feature windows')
    windows = windows - np.add.reduce(windows, axis=1, keepdims=True) / feature.n
    energy = windows * windows
    power = np.add.reduce(energy, axis=1) / feature.n
    signs = np.sign(windows)
    zcr = np.add.reduce(np.abs(signs[:, 1:] - signs[:, :-1]), axis=1) / (feature.n - 1) / 2
    size = 1 << (2 * feature.n - 2).bit_length()
    autocorrelation = np.fft.rfft(windows, size, axis=1)
    correlation = np.fft.irfft(autocorrelation * np.conj(autocorrelation), size, axis=1)[:, feature.lags]
    prefix = energy.cumsum(axis=1)
    suffix = energy[:, ::-1].cumsum(axis=1)[:, ::-1]
    first_energy, second_energy = suffix[:, feature.lags], prefix[:, feature.n - feature.lags - 1]
    epsilon = float(feature.cfg['autocorr_eps'])
    valid = (correlation > 0) & (first_energy > epsilon) & (second_energy > epsilon)
    quality = np.zeros(correlation.shape, dtype=np.float64)
    quality[valid] = correlation[valid] ** 2 / (first_energy[valid] * second_energy[valid] + epsilon)
    indices = quality.argmax(axis=1)
    quality = np.minimum(1, np.maximum(0, quality[np.arange(len(windows)), indices]))
    pitch_valid = quality >= float(feature.cfg['q_min'])
    lags = np.where(pitch_valid, feature.lags[indices], 0)
    pitch = np.divide(feature.fs, lags, out=np.zeros(len(windows)), where=pitch_valid)
    spectrum = np.abs(np.fft.rfft(windows * feature.window, axis=1))
    total = np.add.reduce(spectrum, axis=1)
    spectral_valid = total > float(feature.cfg['spectrum_eps'])
    hi = np.divide(np.add.reduce(spectrum[:, int(feature.cfg['hi_first_bin']):], axis=1), total,
                   out=np.zeros(len(windows)), where=spectral_valid)
    low = np.divide(np.add.reduce(spectrum[:, feature.low_first:feature.low_last + 1], axis=1), total,
                    out=np.zeros(len(windows)), where=spectral_valid)
    return [(float(power[index]), float(zcr[index]), int(lags[index]), float(pitch[index]),
             float(quality[index]), float(hi[index]), float(low[index]), bool(pitch_valid[index]))
            for index in range(len(windows))]


def _measure_cpu_processing(function, arguments, timing):
    begun = time.perf_counter(), time.thread_time(), time.process_time()
    try:
        return function(*arguments)
    finally:
        elapsed = (time.perf_counter() - begun[0], time.thread_time() - begun[1], time.process_time() - begun[2])
        with timing.get_lock():
            timing[0] += 1
            for index, value in enumerate(elapsed):
                timing[index + 1] += value
                timing[index + 4] = max(timing[index + 4], value)


def _cpu_bootstrap(root, incoming, outgoing, worker_cpu, capture_gate=None, processing_timing=None,
                   optimize_features=False, optimize_preprocessing=False, cpu_feature_library=None):
    if mp.current_process().name == "MainProcess":
        raise RuntimeError("Voice bootstrap requires a spawned CPU child")
    try:
        verify_frozen_source(Path(root))
        sys.path.insert(0, str(Path(root).resolve()))
        worker = _frozen_worker()
        if capture_gate is not None:
            incoming = _CaptureInput(incoming, capture_gate)
        if optimize_features or cpu_feature_library is not None:
            feature = importlib.import_module("fast_voice_features")
            if Path(feature.__file__).resolve().parent != Path(root).resolve():
                raise RuntimeError("CPU feature origin mismatch")
            if cpu_feature_library is not None:
                native_features = CpuFeatureLibrary(*cpu_feature_library)
                feature.FrameFeatures.batch = lambda frame, samples: native_features(frame, samples)
            else:
                feature.FrameFeatures.batch = _cpu_feature_batch
        if optimize_preprocessing:
            core = importlib.import_module("voice_stream_core")
            if Path(core.__file__).resolve().parent != Path(root).resolve():
                raise RuntimeError("CPU preprocessing origin mismatch")
            core.Preprocessor.process = (lambda processor, samples: native_features.preprocess(processor, samples)) if cpu_feature_library is not None else _cpu_preprocess
        if processing_timing is not None:
            if not isinstance(incoming, _CaptureInput):
                raise RuntimeError("CPU timing requires the existing first-input capture gate")
            core = importlib.import_module("voice_stream_core")
            if Path(core.__file__).resolve().parent != Path(root).resolve():
                raise RuntimeError("CPU timing core origin mismatch")
            original_process = core.VoiceStream.process

            def measured_process(stream, samples):
                if not incoming._started:
                    return original_process(stream, samples)
                return _measure_cpu_processing(original_process, (stream, samples), processing_timing)

            core.VoiceStream.process = measured_process
        worker._worker(root, incoming, outgoing, worker_cpu, False, True, False)
    except BaseException as error:
        try:
            outgoing.put(("error", type(error).__name__, str(error)), timeout=0.2)
        except Exception:
            pass


class _CheckedOutput:
    def __init__(self, queue, service):
        self._queue = queue
        self._service = service

    def _checked(self, message):
        if type(message) is not tuple or not message:
            raise RuntimeError("Malformed CPU result envelope")
        if message[0] == "done":
            if (len(message) != 2 or type(message[1]) is not int
                    or message[1] != self._service._stream.submitted
                    or self._service._stream.received != message[1]):
                raise RuntimeError("Incomplete CPU result stream")
        return message

    def get(self, *args, **kwargs):
        return self._checked(self._queue.get(*args, **kwargs))

    def get_nowait(self):
        return self._checked(self._queue.get_nowait())

    def cancel_join_thread(self):
        self._queue.cancel_join_thread()

    def close(self):
        self._queue.close()


class VoiceRecognitionService:
    def __init__(self, *, bus: VoiceObservationBus | None = None,
                 producer_run: str | None = None, audio_epoch: str | None = None,
                 startup_timeout: float = 20, worker_cpu: int | None = None,
                 history_capacity: int = 128, measure_processing: bool = False,
                 optimize_features: bool = False, optimize_preprocessing: bool = False,
                 cpu_feature_library: tuple[str, str] | None = None) -> None:
        if type(history_capacity) is not int or history_capacity <= 0:
            raise ValueError("history_capacity must be positive")
        if type(startup_timeout) not in (int, float) or not 0 < startup_timeout <= 60:
            raise ValueError("startup_timeout must be within 0..60 seconds")
        if worker_cpu is not None and (type(worker_cpu) is not int or worker_cpu < 0):
            raise ValueError("invalid worker_cpu")
        if type(measure_processing) is not bool:
            raise ValueError("measure_processing must be boolean")
        if type(optimize_features) is not bool:
            raise ValueError("optimize_features must be boolean")
        if type(optimize_preprocessing) is not bool:
            raise ValueError("optimize_preprocessing must be boolean")
        if cpu_feature_library is not None and (type(cpu_feature_library) is not tuple or len(cpu_feature_library) != 2
                or any(type(value) is not str or not value for value in cpu_feature_library)
                or len(cpu_feature_library[1]) != 64 or set(cpu_feature_library[1]) - set("0123456789abcdef")):
            raise ValueError("CPU feature library requires a path and lowercase SHA256 pair")
        worker = _frozen_worker()
        self.bus = bus if bus is not None else VoiceObservationBus()
        self.validator = VoiceResultValidator(
            uuid.uuid4().hex if producer_run is None else producer_run,
            uuid.uuid4().hex if audio_epoch is None else audio_epoch,
        )
        self.history_capacity = history_capacity
        self._producer_thread = threading.get_ident()
        self._finished = False
        self._publishing = True
        self._native = worker.CpuVoiceStream
        self.bus.begin_epoch(self.validator.producer_run, self.validator.audio_epoch)
        ctx = mp.get_context("spawn")
        self._capture_gate = ctx.Event()
        self._processing_timing = ctx.Array("d", 7) if measure_processing else None
        stream = worker.CpuVoiceStream.__new__(worker.CpuVoiceStream)
        self._stream = stream
        stream.incoming, stream.outgoing = ctx.Queue(4), ctx.Queue(8)
        stream.process_handle = ctx.Process(target=_cpu_bootstrap,
            args=(str(VENDOR_ROOT), stream.incoming, stream.outgoing, worker_cpu, self._capture_gate,
                self._processing_timing, optimize_features, optimize_preprocessing, cpu_feature_library), daemon=True)
        stream.relative_onset, stream.energy_onset, stream.game_rules = False, True, False
        stream.rule_rows = []
        stream.submitted, stream.received, stream.max_inflight = 0, 0, 0
        stream.processing_seconds = 0.0
        stream.worker_events = []
        stream.closed, stream.process_started = False, False
        stream._accept = self._accept_result
        try:
            worker._start_in_current_main(stream.process_handle)
            stream.process_started = True
            message = stream.outgoing.get(timeout=startup_timeout)
            if (type(message) is not tuple or len(message) != 4 or message[0] != "ready"
                    or type(message[1]) is not int or message[1] != 512
                    or type(message[2]) is not int or message[2] != 8000
                    or message[3] != worker_cpu or type(message[3]) is not type(worker_cpu)):
                raise RuntimeError(f"CPU startup failed: {message!r}")
            _, stream.win, stream.rate, stream.worker_cpu = message
            stream.outgoing = _CheckedOutput(stream.outgoing, self)
        except BaseException as error:
            self._fault(error)
            self._native.close(stream)
            raise

    def _fault(self, error: BaseException) -> None:
        self.validator.invalidate(str(error))
        self.bus.invalidate(str(error))

    def _producer(self) -> None:
        if threading.get_ident() != self._producer_thread:
            raise RuntimeError("Only the creating producer may operate CPU queues")
        if self.validator.fault is not None or self._finished or self._stream.closed:
            raise RuntimeError("Voice service epoch ended")

    def _accept_result(self, message) -> None:
        try:
            if type(message) is not tuple or len(message) != 5:
                raise RuntimeError(f"CPU recognition failed: {message!r}")
            if type(message[1]) is not int or message[1] >= self._stream.submitted:
                raise RuntimeError("Unsubmitted CPU result")
            observation = self.validator.accept(message)
            self._native._accept(self._stream, message)
            if self._publishing:
                self.bus.publish(observation)
            del self._stream.worker_events[:-self.history_capacity]
        except BaseException as error:
            self._fault(error)
            raise

    def process(self, samples):
        self._producer()
        import numpy as np
        try:
            block = np.asarray(samples, dtype="<f8")
            if block.shape != (960,) or not np.all(np.isfinite(block)):
                raise ValueError("Require exactly 960 finite mono PCM samples")
            self._capture_gate.set()
            return self._native.process(self._stream, block)
        except BaseException as error:
            self._fault(error)
            raise

    @property
    def pending_packets(self) -> int:
        self._producer()
        return self._stream.submitted - self._stream.received

    def drain(self) -> None:
        self._producer()
        try:
            self._native._drain(self._stream)
            if not self._stream.process_handle.is_alive():
                raise RuntimeError("CPU worker unavailable")
        except BaseException as error:
            self._fault(error)
            raise

    def end_observations(self) -> None:
        self._producer()
        self._publishing = False
        self.bus.invalidate("voice input epoch ended", status="STOPPED")

    def finish(self, *, source_stopped: bool, timeout: float = 3) -> list[dict]:
        self._producer()
        if source_stopped is not True:
            raise ValueError("Confirm source stopped before waiting for CPU results")
        if type(timeout) not in (int, float) or not 0 < timeout <= 60:
            raise ValueError("finish timeout must be within 0..60 seconds")
        try:
            self._capture_gate.set()
            history = self._native.finish(self._stream, timeout=timeout)
            self._finished = True
            self.bus.invalidate("voice source stopped", status="STOPPED")
            return deepcopy(history)
        except BaseException as error:
            self._fault(error)
            raise

    @property
    def statistics(self) -> dict:
        stream = self._stream
        result = {"submitted": stream.submitted, "received": stream.received,
                "max_inflight": stream.max_inflight, "processing_seconds": stream.processing_seconds,
                "events_total": self.validator.event_sequence,
                "audit_retained": len(stream.worker_events), "finished": self._finished}
        timing = getattr(self, "_processing_timing", None)
        if timing is not None:
            with timing.get_lock():
                values = list(timing)
            result["processing_timing"] = dict(zip(
                ("packets", "wall_seconds", "thread_cpu_seconds", "process_cpu_seconds",
                 "max_wall_seconds", "max_thread_cpu_seconds", "max_process_cpu_seconds"), values))
        return result

    def close(self) -> None:
        if threading.get_ident() != self._producer_thread:
            raise RuntimeError("Only the creating producer may close its CPU child")
        self._native.close(self._stream)
        if self._stream.process_handle.is_alive():
            self.bus.invalidate("voice CPU exit unconfirmed")
            raise RuntimeError("Voice CPU exit unconfirmed; retain service")
        self.bus.invalidate("voice CPU service closed", status="STOPPED")

    def __enter__(self):
        return self

    def __exit__(self, *_exc):
        self.close()