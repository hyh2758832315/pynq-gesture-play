from __future__ import annotations

import threading
import uuid
from dataclasses import replace
from typing import Any, Callable, Mapping, Protocol

from ..vision_input import VisionInputProvider
from .c6i_shell import C6IShellRuntimeBackend
from .core import AgentState, RuntimeSnapshot


class VisionSupervisor(Protocol):
    def status(self) -> Mapping[str, Any]: ...

    def start(self) -> Mapping[str, Any]: ...

    def stop(self) -> Mapping[str, Any]: ...


class VisionRuntimeBackend:
    profile = "VISION_ONLY"

    def __init__(self, supervisor: VisionSupervisor) -> None:
        self._supervisor = supervisor
        self._lock = threading.RLock()
        self._generation = 0
        self._cleanup_attempt: str | None = None
        self._monitor_error: str | None = None

    @property
    def snapshot(self) -> RuntimeSnapshot:
        with self._lock:
            status = dict(self._supervisor.status())
            state = {
                "IDLE": AgentState.IDLE,
                "STARTING": AgentState.STARTING,
                "RUNNING": AgentState.RUNNING,
                "STOPPING": AgentState.STOPPING,
                "FAULT": AgentState.ERROR,
            }[status["state"]]
            return RuntimeSnapshot(
                state=state, build_id=0, abi_major=0, abi_minor=0,
                staged_sha256=None, active_sha256=None, generation=self._generation,
                last_error=status.get("last_error") or self._monitor_error,
                runtime_mode="vision-only", profile=self.profile, vision=status,
            )

    def start_vision(self) -> RuntimeSnapshot:
        with self._lock:
            self._supervisor.start()
            self._cleanup_attempt = None
            self._monitor_error = None
            self._generation += 1
            return self.snapshot

    def stop_vision(self) -> RuntimeSnapshot:
        with self._lock:
            self._supervisor.stop()
            self._generation += 1
            return self.snapshot

    def close(self) -> None:
        self.stop_vision()

    def poll_cleanup(self) -> None:
        with self._lock:
            status = self._supervisor.status()
            session_id = status.get("session_id")
            if (status["state"] in ("STOPPING", "FAULT") and status.get("owner_held")
                    and session_id != self._cleanup_attempt):
                self._cleanup_attempt = session_id
                try:
                    self.stop_vision()
                except (OSError, RuntimeError, ValueError) as error:
                    self._monitor_error = str(error)

    def _unsupported(self, *args: Any, **kwargs: Any) -> RuntimeSnapshot:
        raise RuntimeError("VISION_ONLY does not support GPU or game operations")

    stage = stage_file = activate = run = pause = seek = stop = _unsupported


class SharedVisionSupervisor:
    def __init__(self, worker_factory: Callable[[str], Any],
                 input_provider: VisionInputProvider) -> None:
        self.input_provider = input_provider
        self._worker_factory = worker_factory
        self._worker: Any | None = None
        self._run_id: str | None = None
        self._error: str | None = None
        self._started = False
        self._lock = threading.RLock()

    def status(self) -> Mapping[str, Any]:
        with self._lock:
            worker = self._worker
            error = self._error or (None if worker is None else worker.error)
            state = "IDLE" if worker is None else worker.state
            if worker is not None and self._started and state == "IDLE":
                state = "STARTING"
            if error is not None:
                state = "FAULT"
            return {
                "state": state, "session_id": self._run_id, "run_id": self._run_id,
                "frame_id": 0 if worker is None else worker.frame_id,
                "owner_held": worker is not None and (self._started or state != "IDLE"),
                "cleanup_confirmed": worker is None,
                "board_validated": False, "last_error": error,
                "diagnostic_error": None if worker is None else worker.diagnostic_error,
                "input_capabilities": self.input_provider.capabilities,
                "capture": (worker.capture_snapshot() if worker is not None
                            and callable(getattr(worker, "capture_snapshot", None)) else None),
            }

    def prepare(self) -> Mapping[str, Any]:
        with self._lock:
            if self._error is not None:
                raise RuntimeError("vision cleanup must complete before preparing")
            if self._worker is None:
                self._run_id = uuid.uuid4().hex
                try:
                    self._worker = self._worker_factory(self._run_id)
                except BaseException as error:
                    self._error = f"{type(error).__name__}: {error}"
                    raise
            try:
                prepare = getattr(self._worker, "prepare_preview", None)
                if callable(prepare):
                    prepare()
            except BaseException as error:
                self._error = f"{type(error).__name__}: {error}"
                self.input_provider.release(self._error)
                raise
            return self.status()

    def start(self) -> Mapping[str, Any]:
        with self._lock:
            if self._worker is not None and self._started:
                if self.status()["state"] == "FAULT":
                    raise RuntimeError("vision cleanup must complete before restarting")
                return self.status()
            if self._error is not None:
                raise RuntimeError("vision cleanup must complete before starting")
            if self._worker is None:
                self._run_id = uuid.uuid4().hex
            self._error = None
            self.input_provider.resume()
            try:
                if self._worker is None:
                    self._worker = self._worker_factory(self._run_id)
                self._worker.start()
                self._started = True
            except BaseException as error:
                self._error = f"{type(error).__name__}: {error}"
                self.input_provider.release(self._error)
                raise
            return self.status()

    def pause_processing(self) -> None:
        with self._lock:
            if self._worker is None:
                raise RuntimeError("running vision worker required for processing pause")
            self._worker.pause_processing()

    def resume_processing(self) -> None:
        with self._lock:
            if self._worker is not None:
                self._worker.resume_processing()

    def stop(self) -> Mapping[str, Any]:
        with self._lock:
            self.input_provider.suspend()
            self.input_provider.release("Vision producer stopped")
            if self._worker is not None:
                try:
                    self._worker.stop()
                except BaseException as error:
                    self._error = f"{type(error).__name__}: {error}"
                    raise
                self._worker = None
            self._started = False
            self._error = None
            return self.status()


class C6IVisionRuntimeBackend(C6IShellRuntimeBackend):
    profile = "C6I_VISION"
    BUILD_ID = 0xC0060800

    def __init__(self, session: Any, supervisor: SharedVisionSupervisor,
                 **shell_options: Any) -> None:
        if session.build_id != self.BUILD_ID:
            raise ValueError(f"{self.profile} requires BUILD_ID 0x{self.BUILD_ID:08X}")
        self._vision_supervisor = supervisor
        super().__init__(session, live_input=supervisor.input_provider, **shell_options)

    @property
    def snapshot(self) -> RuntimeSnapshot:
        base = super().snapshot
        status = dict(self._vision_supervisor.status())
        return replace(base, profile=self.profile, vision=status,
                       state=AgentState.ERROR if status["state"] == "FAULT" else base.state,
                       last_error=status.get("last_error") or base.last_error)

    def start_vision(self) -> RuntimeSnapshot:
        self._vision_supervisor.start()
        return self.snapshot

    def stop_vision(self) -> RuntimeSnapshot:
        self._vision_supervisor.stop()
        return self.snapshot

    def close(self) -> None:
        self._vision_supervisor.stop()
        super().close()


class C6IVolumeRuntimeBackend(C6IVisionRuntimeBackend):
    profile = "C6I_PL_VISION_VOLUME_OSD_V1"
    BUILD_ID = 0xC0060E00

    def __init__(self, session, supervisor, *, volume_factory, volume_sampling_enabled=True, **shell_options):
        if type(volume_sampling_enabled) is not bool:
            raise ValueError("volume_sampling_enabled must be boolean")
        self._volume_factory = volume_factory
        self._volume_sampling_enabled = volume_sampling_enabled
        self._volume = None
        super().__init__(session, supervisor, **shell_options)

    @property
    def input_schema_version(self):
        return 4

    @property
    def supported_volume_schemas(self):
        return ("volume-signal-v1",) if self._volume_sampling_enabled else ()

    @property
    def supported_action_schemas(self):
        return ()

    @property
    def test_case_schema_versions(self):
        return (1, 2, 3, 4)

    @property
    def snapshot(self):
        base = super().snapshot
        status = None if self._volume is None else self._volume.status()
        error = None if status is None else status.get("error")
        return replace(base, volume=status, state=AgentState.ERROR if error else base.state,
                       last_error=base.last_error or error)

    def open(self):
        from ..volume_input import VolumeGameInputProvider
        if self._sink is not None:
            return self
        if self._volume is not None:
            raise RuntimeError("prior volume owner cleanup must complete before opening")
        self._session.open()
        self._volume = self._volume_factory(self._session)
        try:
            super().open()
            if self._volume_sampling_enabled:
                self._vision_supervisor.prepare()
            self._volume.open()
            self._live_input = VolumeGameInputProvider(self._vision_supervisor.input_provider, self._volume.latch)
            return self
        except BaseException as error:
            try:
                self.close()
            except BaseException as cleanup:
                raise RuntimeError(f"{error}; volume backend cleanup failed: {cleanup}") from error
            raise

    def close(self):
        self._stop_menu()
        self._vision_supervisor.stop()
        with self._lock:
            game = self._game
        if game is not None:
            game.stop()
        if self._volume is not None:
            self._volume.close()
            self._volume = None
        C6IShellRuntimeBackend.close(self)


class C6IButtonRuntimeBackend(C6IVisionRuntimeBackend):
    profile = "C6I_VISION_BUTTON_V1"
    BUILD_ID = 0xC0060F00

    def __init__(self, session, supervisor, **shell_options):
        self._button_sampler = None
        super().__init__(session, supervisor, **shell_options)

    def open(self):
        from ..button_input import ButtonGameInputProvider, ButtonSampler

        if self._sink is not None:
            return self
        try:
            super().open()
            sampler = ButtonSampler(self._session.mmio("button_gpio"))
            sampler.start()
            self._button_sampler = sampler
            self._live_input = ButtonGameInputProvider(
                self._vision_supervisor.input_provider, sampler)
            return self
        except BaseException:
            self.close()
            raise

    def close(self):
        if self._button_sampler is not None:
            self._button_sampler.close()
            self._button_sampler = None
        super().close()
