from __future__ import annotations

import threading
import time
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
            errors = []
            for operation in (self.input_provider.suspend,
                              lambda: self.input_provider.release("Vision producer stopped")):
                try:
                    operation()
                except BaseException as error:
                    errors.append(error)
            if self._worker is not None:
                try:
                    self._worker.stop()
                except BaseException as error:
                    errors.append(error)
            if errors:
                self._error = "; ".join(f"{type(error).__name__}: {error}" for error in errors)
                # Keep even a stopped worker until source and hardware cleanup
                # are both confirmed. No second owner may start in this state.
                if len(errors) == 1:
                    raise errors[0]
                raise RuntimeError('vision input/worker cleanup failed: '+self._error) from errors[0]
            if self._worker is not None:
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

    def close(self, *, retain_sink: bool = False) -> None:
        previous_error = self._last_error
        errors = []
        try:
            self._vision_supervisor.stop()
        except BaseException as error:
            errors.append(error)
        try:
            if retain_sink or errors:
                super().close(retain_sink=True)
            else:
                super().close()
        except BaseException as error:
            errors.append(error)
        if errors:
            detail = "; ".join(f"{type(error).__name__}: {error}" for error in errors)
            self._last_error = previous_error or detail
            self._cleanup_errors = detail
            if len(errors) == 1:
                raise errors[0]
            raise RuntimeError('vision/shell cleanup failed: '+detail) from errors[0]


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
    def recovery_cleanup_confirmed(self):
        """A poisoned scene may restart only after independent release receipts."""
        if not getattr(self,'_recovery_requested',False):return False
        if any(getattr(self,name,None) is not None for name in
               ('_hand_session','_button_sampler','_osd','_game')):return False
        threads=(self._menu_thread,self._return_monitor_thread,
                 self._startup_animation_thread,getattr(self._video,'_thread',None))
        if any(t is not None and t.is_alive() for t in threads):return False
        if not self._vision_supervisor.status().get('cleanup_confirmed'):return False
        sink=self._sink
        return sink is None or (getattr(sink,'_closed',False) is True
            and getattr(sink,'_buffer',None) is None and not getattr(sink,'_dma_inflight',True))

    profile = "C6I_VISION_BUTTON_V1"
    BUILD_ID = 0xC0061000

    def __init__(self, session, supervisor, *, startup_hand=None,
                 hand_session_factory=None, **shell_options):
        self._button_sampler = None
        self._hand_session = None
        self._hand_session_factory = hand_session_factory
        self._hand_retry_at = 0.
        self._hand_retry_delay = 1.
        self._hand_recovery_error = None
        if hand_session_factory is not None and startup_hand is None:
            raise ValueError("hand session requires a verified startup hand check")
        from ..startup_checks import start_vision_with_recovery
        from ..startup_ui import CheckState

        if "startup_vision" in shell_options or "startup_hand" in shell_options:
            raise ValueError("button startup checks must have one owner")
        shell_options["startup_vision"] = lambda: start_vision_with_recovery(supervisor)
        shell_options["startup_hand"] = (
            startup_hand if startup_hand is not None else lambda: CheckState.SKIP)
        super().__init__(session, supervisor, **shell_options)

    @property
    def snapshot(self):
        base = super().snapshot
        hand = self._hand_session
        status = None
        if hand is not None:
            read_status = getattr(hand, "status", None)
            if callable(read_status):
                status = read_status()
            else:
                finished_event = getattr(hand, "finished", None)
                finished = bool(finished_event is not None and finished_event.is_set())
                error = getattr(hand, "error", None)
                status = {"schema": "hand-session-status-v1",
                          "mode": "observation-only", "phase":
                          "FAULT" if finished and error else
                          "CLOSED" if finished else "RUNNING",
                          "error": error}
        # The hand is an optional actuator. A runtime serial fault must remain
        # visible in hand_session, but it cannot turn a healthy HDMI/vision
        # backend into a global ERROR state. The video hand-off still requires
        # a separate confirmed-OFF receipt before acquiring its resources.
        return replace(base, vision={**(base.vision or {}),
                                     "hand_session": status,
                                     "hand_recovery_error": getattr(self, '_hand_recovery_error', None)})

    def _recover_hand_session(self):
        """Retry an ended production owner, with fresh input and no parallel serial use."""
        if (self._closing or self._restart_requested or self._hand_permissions_closed
                or self._hand_session_factory is None or time.monotonic() < self._hand_retry_at):
            return
        hand = self._hand_session
        if hand is None or getattr(hand, 'seconds', None) is not None:
            return  # Explicitly bounded acceptance runs must remain bounded.
        finished = getattr(hand, 'finished', None)
        if finished is not None and not finished.is_set():
            return  # Healthy playback: no status-file reads or motor probes.
        status = hand.status()
        if status.get('phase') != 'FAULT':
            return
        self._hand_retry_at = time.monotonic() + self._hand_retry_delay
        self._hand_retry_delay = min(30., self._hand_retry_delay * 2)
        recover = getattr(hand, 'recover_release', None)
        if not callable(recover):
            return
        try:
            if not recover():
                return
            # Video and idle pages need no actuator. Recreate only on a live
            # page or preview; the factory creates a new feed/session identity.
            from .c6i_shell import MenuPage, ShellMode
            with self._lock:
                if (self._hand_session is not hand or self._closing or self._restart_requested
                        or self._hand_permissions_closed or self._demo_leaving
                        or (self._preview_active and not self._preview_ready)
                        or getattr(hand, '_video_paused', False)):
                    return
                live = self._preview_ready or (not self._game_menu_active and
                    (self._mode is ShellMode.GAME or self._page in (
                        MenuPage.HOME, MenuPage.GAMES, MenuPage.VIDEOS, MenuPage.HAND_DEMO))
                    and self._mode is not ShellMode.VIDEO)
                if not live:
                    return
                # Startup gates are single-use. Use a fresh read-only gate;
                # preserve the original receipt and never reuse its result.
            from ..hand_startup import HandStartupGate
            gate = HandStartupGate(root=hand.gate.root, python=hand.gate.python,
                port=hand.gate.port, report_dir=hand.output_dir/'recovery-startup')
            if gate() is not True:
                raise RuntimeError('hand recovery startup check pending')
            with self._lock:
                if (self._hand_session is not hand or self._closing or self._restart_requested
                        or self._hand_permissions_closed or self._demo_leaving
                        or (self._preview_active and not self._preview_ready)
                        or getattr(hand, '_video_paused', False)):
                    return
                replacement = self._hand_session_factory(self._vision_supervisor.input_provider)
                replacement.gate = gate
                self._hand_session = replacement  # Retain even if start fails.
                worker = self._vision_supervisor._worker
                replacement.attach_preview(worker.preview, worker.preview_encoder)
                replacement.set_preview_activity(lambda: self._preview_ready)
                replacement.set_page_mode('demo' if self._page is MenuPage.HAND_DEMO
                                          and not self._preview_ready else 'live')
                try:
                    replacement.start()
                except Exception:
                    # Restore the previous closed identity only after this new
                    # owner also confirms cleanup; otherwise retain it for retry.
                    replacement.close()
                    self._hand_session = hand
                    raise
                self._hand_recovery_error = None
        except Exception as error:
            self._hand_recovery_error = f'{type(error).__name__}: {error}'

    def open(self):
        from ..button_input import ButtonGameInputProvider, ButtonSampler

        if self._sink is not None:
            return self
        self._hand_permissions_closed=False
        try:
            super().open()
            sampler = ButtonSampler(self._session.mmio("build_id_gpio"), data_offset=8)
            sampler.start()
            self._button_sampler = sampler
            self._live_input = ButtonGameInputProvider(
                self._vision_supervisor.input_provider, sampler)
            if self._hand_session_factory is not None:
                hand = self._hand_session_factory(self._vision_supervisor.input_provider)
                self._hand_session = hand
                attach = getattr(hand, 'attach_preview', None)
                if callable(attach):
                    attach(self._vision_supervisor._worker.preview,self._vision_supervisor._worker.preview_encoder)
                coexist=getattr(hand,'set_preview_activity',None)
                if callable(coexist):coexist(lambda:self._preview_ready)
                if not getattr(self, 'START_HAND_AFTER_OSD', False):
                    hand.start()
            preview=getattr(getattr(self._vision_supervisor,'_worker',None),'preview',None)
            if callable(getattr(preview,'requested_modes',None)):
                self._preview_modes=lambda:preview.requested_modes(blocking=True)
                if self._hand_session is None:
                    preview.allow_preview=lambda:self._preview_ready
            return self
        except BaseException as error:
            try:
                self.close()
            except BaseException as cleanup_error:
                raise RuntimeError(f"{error}; button/hand cleanup failed: {cleanup_error}") from error
            raise

    def close(self, *, retain_sink=False):
        previous_error = self._last_error
        errors = []
        # Stop page/preview permission producers before closing their hand owner.
        self._closing=True
        self._hand_permissions_closed=True
        self._preview_ready=False
        self._return_monitor_stop.set()
        monitor=self._return_monitor_thread
        if monitor is not None and monitor is not threading.current_thread():
            monitor.join(self._timeout_seconds+1.)
            if monitor.is_alive():
                errors.append(RuntimeError('return monitor did not stop before hand cleanup'))
            else:self._return_monitor_thread=None
        self._preview_ready=False
        try:self._stop_menu(drain_sink=not retain_sink)
        except BaseException as error:errors.append(error)
        if self._hand_session is not None:
            try:
                self._hand_session.close()
            except BaseException as error:
                errors.append(error)
            else:
                self._hand_session = None
        if self._button_sampler is not None:
            try:
                self._button_sampler.close()
            except BaseException as error:
                errors.append(error)
            else:
                self._button_sampler = None
        try:
            if retain_sink or errors:
                super().close(retain_sink=True)
            else:
                super().close()
        except BaseException as error:
            errors.append(error)
        if errors:
            detail = "; ".join(f"{type(error).__name__}: {error}" for error in errors)
            self._last_error = previous_error or detail
            self._cleanup_errors = detail
            raise RuntimeError("button/hand backend cleanup failed: " +
                               "; ".join(str(error) for error in errors)) from errors[0]

    def stop_vision(self):
        hand_error = None
        if self._hand_session is not None:
            try:
                self._hand_session.close()
            except BaseException as error:
                hand_error = error
            else:
                self._hand_session = None
        try:
            result = super().stop_vision()
        except BaseException as vision_error:
            if hand_error is not None:
                raise RuntimeError(f"hand cleanup failed: {hand_error}; "
                                   f"vision cleanup failed: {vision_error}") from hand_error
            raise
        if hand_error is not None:
            raise RuntimeError(f"hand cleanup failed: {hand_error}") from hand_error
        return result
