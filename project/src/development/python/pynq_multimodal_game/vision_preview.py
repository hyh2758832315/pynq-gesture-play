from __future__ import annotations

from collections.abc import Callable
import copy
from dataclasses import asdict, dataclass
import faulthandler
import importlib
import json
import math
import os
import multiprocessing
from multiprocessing.shared_memory import SharedMemory
import pickle
from threading import Event, Lock, Thread, Timer
import time
from types import FunctionType
from typing import Any


@dataclass(frozen=True)
class PreviewSnapshot:
    frame: int
    modes: frozenset[str]
    rgb: Any
    result: dict[str, Any] | None
    control: dict[str, Any] | None


@dataclass(frozen=True)
class PreviewHealth:
    status: str
    codec_alive: bool
    relay_alive: bool
    codec_pid: int | None
    exitcode: int | None
    reason: str
    cleanup: str

    @property
    def healthy(self) -> bool:
        return self.status == "RUNNING"


def copy_preview_snapshot(rgb: Any, result: dict[str, Any], control: dict[str, Any],
                          frame: int, modes: frozenset[str]) -> PreviewSnapshot:
    return PreviewSnapshot(
        frame, modes, rgb.copy() if "video" in modes else None,
        copy.deepcopy(result) if modes else None,
        copy.deepcopy(control) if "debug" in modes else None,
    )


class AsyncPreviewEncoder:
    def __init__(self, demand: Callable[[], frozenset[str]],
                 encode: Callable[[PreviewSnapshot, str], bytes],
                 publish: Callable[[str, bytes], None], *,
                 video_fps: float = 10.0, debug_fps: float = 5.0) -> None:
        for rate in (video_fps, debug_fps):
            if not math.isfinite(rate) or not 0 <= rate <= 30:
                raise ValueError("Preview rates must be finite and within 0..30 Hz")
        self._demand, self._encode, self._publish = demand, encode, publish
        self._rates = {"video": video_fps, "debug": debug_fps}
        self._due = {"video": 0.0, "debug": 0.0}
        self._lock, self._wake, self._stop = Lock(), Event(), Event()
        self._pending: PreviewSnapshot | None = None
        self._stats: dict[str, Any] = dict(submitted=0, replaced=0, encoded=0,
                                          errors=0, last_error="", submit_ms=0.0,
                                          encode_ms=0.0, last_frame=0)
        self._thread = Thread(target=self._run, name="vision-preview", daemon=True)
        self._thread.start()

    def due_modes(self, now: float | None = None) -> frozenset[str]:
        current = time.monotonic() if now is None else now
        if self._stop.is_set():
            return frozenset()
        return frozenset(mode for mode in self._demand()
                         if self._rates.get(mode, 0) > 0 and current >= self._due[mode])

    def submit(self, factory: Callable[[frozenset[str]], PreviewSnapshot],
               *, now: float | None = None) -> bool:
        started = time.monotonic()
        current = started if now is None else now
        if self._stop.is_set():
            return False
        modes = self.due_modes(current)
        if not modes or not self._lock.acquire(blocking=False):
            return False
        try:
            snapshot = factory(modes)
            if not snapshot.modes:
                return False
            if self._pending is not None:
                self._stats["replaced"] += 1
            self._pending = snapshot
            for mode in snapshot.modes:
                self._due[mode] = current + 1.0 / self._rates[mode]
            self._stats["submitted"] += 1
            self._stats["submit_ms"] = (time.monotonic() - started) * 1000
        except Exception as error:
            self._stats["errors"] += 1
            self._stats["last_error"] = str(error)
            return False
        finally:
            self._lock.release()
        self._wake.set()
        return True

    def stats(self) -> dict[str, Any]:
        with self._lock:
            return dict(self._stats, pending=int(self._pending is not None),
                        running=self._thread.is_alive())

    def close(self, timeout: float = 3.0) -> None:
        self._stop.set()
        self._wake.set()
        self._thread.join(timeout)
        if self._thread.is_alive():
            raise RuntimeError("Preview encoder did not stop within timeout")
        with self._lock:
            self._pending = None

    def _run(self) -> None:
        if hasattr(os, "nice"):
            try:
                os.nice(5)
            except OSError:
                pass
        while not self._stop.is_set():
            self._wake.wait(0.1)
            self._wake.clear()
            with self._lock:
                snapshot, self._pending = self._pending, None
            if snapshot is None:
                continue
            for mode in sorted(snapshot.modes):
                if self._stop.is_set() or mode not in self._demand():
                    continue
                started = time.monotonic()
                try:
                    payload = self._encode(snapshot, mode)
                    if not self._stop.is_set() and mode in self._demand():
                        self._publish(mode, payload)
                    with self._lock:
                        self._stats["encoded"] += 1
                        self._stats["last_frame"] = snapshot.frame
                        self._stats["encode_ms"] = (time.monotonic() - started) * 1000
                except Exception as error:
                    with self._lock:
                        self._stats["errors"] += 1
                        self._stats["last_error"] = str(error)


def _preview_startup_stage(path, stage, **details):
    if path is None:
        return
    with open(path, "a", encoding="utf-8") as stream:
        stream.write(json.dumps(dict(stage=stage, pid=os.getpid(),
                                     monotonic_ns=time.monotonic_ns(), **details)) + "\n")
        stream.flush()
        os.fsync(stream.fileno())


def _process_preview_loop(name, slot_bytes, headers, locks, wake, stop, ready, output, encode,
                          startup_log=None, startup_stack_traces=False):
    memory = None
    stack_stream = None
    stack_deadline = None
    last_sequence = 0
    try:
        if startup_log is not None and startup_stack_traces:
            stack_stream = open(startup_log + ".stacks.log", "xb")
            faulthandler.dump_traceback_later(2, repeat=True, file=stack_stream)
            stack_deadline = Timer(180, faulthandler.cancel_dump_traceback_later)
            stack_deadline.daemon = True
            stack_deadline.start()
        _preview_startup_stage(startup_log, "process_enter")
        memory = SharedMemory(name=name)
        _preview_startup_stage(startup_log, "shared_memory_complete")
        if hasattr(os, "nice"):
            try:
                os.nice(5)
            except OSError:
                pass
        _preview_startup_stage(startup_log, "opencv_import_begin")
        import cv2
        _preview_startup_stage(startup_log, "opencv_import_complete")
        cv2.setNumThreads(1)
        _preview_startup_stage(startup_log, "opencv_threads_complete")
        _preview_startup_stage(startup_log, "encode_import_begin")
        if isinstance(encode, tuple):
            module_name, qualified_name = encode
            encode = importlib.import_module(module_name)
            for component in qualified_name.split("."):
                encode = getattr(encode, component)
        _preview_startup_stage(startup_log, "encode_import_complete")
        _preview_startup_stage(startup_log, "ready")
        ready.release()
        if stack_stream is not None:
            stack_deadline.cancel()
            faulthandler.cancel_dump_traceback_later()
            stack_stream.close()
            stack_stream = None
        while not stop.value:
            wake.acquire(timeout=0.1)
            if stop.value:
                break
            best_slot, best_sequence = -1, last_sequence
            for index, lock in enumerate(locks):
                if not lock.acquire(False):
                    continue
                try:
                    if headers[index * 2] > best_sequence:
                        best_slot, best_sequence = index, headers[index * 2]
                finally:
                    lock.release()
            if best_slot < 0 or not locks[best_slot].acquire(False):
                continue
            try:
                sequence, length = headers[best_slot * 2], headers[best_slot * 2 + 1]
                if sequence <= last_sequence:
                    continue
                offset = best_slot * slot_bytes
                payload = bytes(memory.buf[offset:offset + length])
            finally:
                locks[best_slot].release()
            last_sequence = sequence
            snapshot = pickle.loads(payload)
            for mode in sorted(snapshot.modes):
                if stop.value:
                    break
                started = time.monotonic()
                try:
                    encoded = encode(snapshot, mode)
                    output.send((mode, encoded, sequence, snapshot.frame,
                                 (time.monotonic() - started) * 1000, ""))
                except Exception as error:
                    output.send((mode, b"", sequence, snapshot.frame, 0.0, str(error)))
    except BaseException as error:
        _preview_startup_stage(startup_log, "first_error", error=repr(error))
        raise
    finally:
        if stack_deadline is not None:
            stack_deadline.cancel()
        if stack_stream is not None:
            faulthandler.cancel_dump_traceback_later()
            stack_stream.close()
        output.close()
        if memory is not None:
            memory.close()


class ProcessPreviewEncoder(AsyncPreviewEncoder):
    def __init__(self, demand: Callable[[], frozenset[str]],
                 encode: Callable[[PreviewSnapshot, str], bytes],
                 publish: Callable[[str, bytes], None], *,
                 video_fps: float = 10.0, debug_fps: float = 5.0,
                 slot_bytes: int = 4_000_000, startup_timeout: float = 5.0,
                 startup_log: str | os.PathLike[str] | None = None,
                 startup_stack_traces: bool = False) -> None:
        for rate in (video_fps, debug_fps):
            if not math.isfinite(rate) or not 0 <= rate <= 30:
                raise ValueError("Preview rates must be finite and within 0..30 Hz")
        if not math.isfinite(startup_timeout) or startup_timeout <= 0:
            raise ValueError("Preview startup timeout must be positive and finite")
        if slot_bytes < 1024:
            raise ValueError("Preview shared-memory slot is too small")
        encode_payload = ((encode.__module__, encode.__qualname__)
                  if isinstance(encode, FunctionType) and "<locals>" not in encode.__qualname__
                  else encode)
        startup_log = None if startup_log is None else os.fspath(startup_log)
        self._demand, self._publish = demand, publish
        self._rates = {"video": video_fps, "debug": debug_fps}
        self._due = {"video": 0.0, "debug": 0.0}
        self._lock = Lock()
        self._stats = dict(submitted=0, replaced=0, encoded=0, errors=0,
                           last_error="", submit_ms=0.0, encode_ms=0.0, last_frame=0)
        context = multiprocessing.get_context("spawn")
        self._stop = Event()
        self._codec_stop = context.RawValue("b", False)
        self._wake = context.Semaphore(0)
        ready = context.Semaphore(0)
        self._slot_bytes = slot_bytes
        self._memory = SharedMemory(create=True, size=2 * slot_bytes)
        self._headers = context.RawArray("Q", 4)
        self._slots = [context.Lock(), context.Lock()]
        self._sequence = self._received_sequence = 0
        self._closed = False
        self._fatal_reason = ""
        self._fault_lock = Lock()
        self._cleanup = "NOT_STARTED"
        self._receive, output = context.Pipe(duplex=False)
        self._process = context.Process(
            target=_process_preview_loop,
            args=(self._memory.name, slot_bytes, self._headers, self._slots,
                self._wake, self._codec_stop, ready, output, encode_payload, startup_log,
                startup_stack_traces),
            name="vision-preview-codec", daemon=True,
        )
        try:
            _preview_startup_stage(startup_log, "spawn_begin")
            self._process.start()
        except Exception:
            output.close()
            self._receive.close()
            self._memory.close()
            self._memory.unlink()
            raise
        output.close()
        self._pid = self._process.pid
        self._thread = Thread(target=self._relay, name="vision-preview-publisher", daemon=True)
        try:
            self._thread.start()
            if not ready.acquire(timeout=startup_timeout) or not self._process.is_alive():
                raise RuntimeError(
                    f"Preview codec process failed to initialize within {startup_timeout:g}s "
                    f"(pid={self._pid}, exitcode={self._process.exitcode})"
                )
        except Exception:
            try:
                self.close()
            except RuntimeError:
                pass
            raise

    def _fault(self, reason: str) -> None:
        if not self._fault_lock.acquire(blocking=False):
            return
        try:
            if not self._fatal_reason:
                self._fatal_reason = reason
                self._stats["last_error"] = reason
                self._stats["errors"] += 1
        finally:
            self._fault_lock.release()

    def health(self) -> PreviewHealth:
        codec_alive = self._process.is_alive()
        relay_alive = self._thread.is_alive()
        exitcode = self._process.exitcode
        if not self._closed and not self._stop.is_set():
            if not codec_alive:
                self._fault(f"Preview codec exited with code {exitcode}")
            elif not relay_alive:
                self._fault("Preview relay exited unexpectedly")
        status = (
            "CLOSED" if self._closed else "DEGRADED" if self._fatal_reason or (
                not self._stop.is_set() and (not codec_alive or not relay_alive)) else
            "STOPPING" if self._stop.is_set() else "RUNNING"
        )
        return PreviewHealth(status, codec_alive, relay_alive, self._pid, exitcode,
                             self._fatal_reason, self._cleanup)

    def due_modes(self, now: float | None = None) -> frozenset[str]:
        if not self.health().healthy:
            return frozenset()
        return super().due_modes(now)

    def submit(self, factory: Callable[[frozenset[str]], PreviewSnapshot],
               *, now: float | None = None) -> bool:
        started = time.monotonic()
        current = started if now is None else now
        modes = self.due_modes(current)
        if not modes or self._closed:
            return False
        try:
            snapshot = factory(modes)
            if not snapshot.modes:
                return False
            payload = pickle.dumps(snapshot, protocol=pickle.HIGHEST_PROTOCOL)
            if len(payload) > self._slot_bytes:
                raise ValueError("Preview snapshot exceeds shared-memory slot")
            for index in (self._sequence % 2, (self._sequence + 1) % 2):
                if not self._slots[index].acquire(False):
                    continue
                try:
                    if self._headers[index * 2] > self._received_sequence:
                        self._stats["replaced"] += 1
                    offset = index * self._slot_bytes
                    self._memory.buf[offset:offset + len(payload)] = payload
                    self._sequence += 1
                    self._headers[index * 2 + 1] = len(payload)
                    self._headers[index * 2] = self._sequence
                finally:
                    self._slots[index].release()
                for mode in snapshot.modes:
                    self._due[mode] = current + 1.0 / self._rates[mode]
                self._stats["submitted"] += 1
                self._stats["submit_ms"] = (time.monotonic() - started) * 1000
                self._wake.release()
                return True
        except Exception as error:
            self._stats["errors"] += 1
            self._stats["last_error"] = str(error)
        return False

    def stats(self) -> dict[str, Any]:
        health = self.health()
        return dict(self._stats, pending=min(2, self._sequence - self._received_sequence),
                    running=not self._closed and health.codec_alive, codec_pid=self._pid,
                    healthy=health.healthy, health=asdict(health))

    def _relay(self) -> None:
        try:
            while not self._stop.is_set():
                if not self._receive.poll(0.1):
                    continue
                mode, payload, sequence, frame, elapsed, error = self._receive.recv()
                self._received_sequence = sequence
                if error:
                    self._stats["errors"] += 1
                    self._stats["last_error"] = error
                    continue
                try:
                    if mode in self._demand():
                        self._publish(mode, payload)
                    self._stats.update(encoded=self._stats["encoded"] + 1,
                                       last_frame=frame, encode_ms=elapsed)
                except Exception as error:
                    self._fault(f"Preview publication failed: {error}")
                    break
        except (EOFError, OSError, ValueError) as error:
            if not self._stop.is_set():
                self._fault(f"Preview relay transport failed: {type(error).__name__}: {error}")

    @property
    def release_confirmed(self) -> bool:
        """CPU resources released, even when a non-clean codec exit is reported."""
        return (self._closed and not self._process.is_alive()
                and not self._thread.is_alive()
                and self._cleanup in ('CLEAN','FORCED','EXITED_NONZERO'))

    def close(self, timeout: float = 3.0) -> None:
        if self._closed:
            return
        self.health()
        self._cleanup = "STOPPING"
        self._stop.set()
        self._codec_stop.value = True
        self._wake.release()
        self._process.join(timeout)
        forced = self._process.is_alive()
        if forced:
            self._process.terminate()
            self._process.join(1)
        if self._thread.ident is not None:
            self._thread.join(1)
        if self._process.is_alive() or self._thread.is_alive():
            self._cleanup = "TIMEOUT"
            self._fault("Preview cleanup timed out; resources retained")
            raise RuntimeError(self._fatal_reason)
        exitcode = self._process.exitcode
        self._receive.close()
        self._memory.close()
        self._memory.unlink()
        self._closed = True
        # A retained worker/diagnostic closure must not keep named semaphores
        # alive until interpreter exit (execv skips Python finalizers).
        self._wake = None
        self._slots = []
        self._cleanup = "FORCED" if forced else "EXITED_NONZERO" if exitcode != 0 else "CLEAN"
        if forced or exitcode != 0:
            raise RuntimeError(f"Preview cleanup {self._cleanup}: codec exit code {exitcode}")
