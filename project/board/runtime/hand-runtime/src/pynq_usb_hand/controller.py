import math
import threading
import time
import uuid

from .buttons import state_route
from .motion import Cancellation, Cancelled, Motion


class Controller:
    def __init__(self, backend_factory, *, lease_seconds, settings=None, idle_scan=0.5, idle_release_after=None,
                 startup_timeout=30.0, approval_seconds=None, preview_interlock=False, demo_states=()):
        if not math.isfinite(lease_seconds) or lease_seconds <= 0:
            raise ValueError("An explicit positive lease is required")
        if not math.isfinite(idle_scan) or idle_scan <= 0:
            raise ValueError("Invalid idle safety scan interval")
        if type(startup_timeout) not in (int, float) or not math.isfinite(startup_timeout) or startup_timeout <= 0:
            raise ValueError("Startup timeout must be finite and positive")
        if idle_release_after is not None and (isinstance(idle_release_after, bool)
                                              or not math.isfinite(idle_release_after) or idle_release_after <= 0):
            raise ValueError("Idle release requires an explicit positive duration")
        self.demo_states = tuple(demo_states)
        if self.demo_states and (settings is None or not settings.open_loop or not preview_interlock):
            raise ValueError("Demo states require checked fixed playback interlock")
        self.playback_stage = None
        self.playback = bool(settings is not None and settings.open_loop)
        if approval_seconds is not None and (not self.playback or type(approval_seconds) not in (int,float)
                or not math.isfinite(approval_seconds) or not 0<approval_seconds<=10):
            raise ValueError('Approval period requires fixed playback within ten seconds')
        self.approval_seconds=approval_seconds
        self.approved_at=None
        if type(preview_interlock) is not bool or (preview_interlock and not self.playback):
            raise ValueError('Preview interlock requires explicit fixed playback')
        self.preview_interlock = preview_interlock
        self._preview_resume_allowed = False
        if self.playback and idle_release_after is not None:
            raise ValueError("Fixed playback requires explicit release rather than idle release")
        self.ready_lifecycle = "READY_IDLE" if self.playback else "READY"
        self.arm_used = False
        self.factory = backend_factory
        self.lease_seconds = lease_seconds
        self.settings = settings
        self.idle_scan = idle_scan
        self.idle_release_after = idle_release_after
        self.idle_deadline = None
        self.session_id = uuid.uuid4().hex
        self.enable_epoch = None
        self.condition = threading.Condition()
        self.lifecycle = "CONNECTING"
        self.error = None
        self.actual_state = "unknown"
        self.estimated_state = "unknown"
        self.operation = None
        self.last_request = 0
        self.last_payload = None
        self.pending = None
        self.release_pending = False
        self.closing = False
        self.cancel = Cancellation(time.monotonic() + startup_timeout)
        self.thread = threading.Thread(target=self._worker, name="usb-hand-owner", daemon=False)
        self.thread.start()

    def wait_connected(self, timeout=10):
        with self.condition:
            if not self.condition.wait_for(lambda: self.lifecycle != "CONNECTING", timeout):
                raise TimeoutError("Connection worker did not finish")
            if self.lifecycle != "CONNECTED_OFF":
                raise RuntimeError(self.error or self.lifecycle)

    def arm(self):
        with self.condition:
            if self.lifecycle != "CONNECTED_OFF" or self.closing or self.release_pending:
                raise RuntimeError("Arm requires CONNECTED_OFF")
            if self.playback and self.arm_used:
                raise RuntimeError("Fixed playback can arm only once; create a new checked session")
            self.arm_used = True
            self.cancel = Cancellation(time.monotonic() + self.lease_seconds)
            self.lifecycle = "ARMING"
            self.pending = ("arm", None)
            self.condition.notify_all()

    def submit(self, state, *, request_id, session_id, enable_epoch):
        if state not in self.demo_states:
            state_route(state)
        if type(request_id) is not int or request_id <= 0:
            raise ValueError("request_id must be a positive integer")
        with self.condition:
            if session_id != self.session_id or enable_epoch != self.enable_epoch or enable_epoch is None:
                return "stale_session"
            if request_id < self.last_request:
                return "expired"
            if request_id == self.last_request:
                return "duplicate" if state == self.last_payload else "conflicting_request"
            if self.lifecycle != self.ready_lifecycle or self.closing or self.release_pending:
                return "busy" if self.lifecycle == "MOVING" else "not_ready"
            if time.monotonic() >= self.cancel.deadline:
                self.cancel.event.set()
                self.condition.notify_all()
                return "lease_expired"
            self.last_request = request_id
            self.approved_at=time.monotonic()
            self.last_payload = state
            self.lifecycle = "MOVING"
            self.idle_deadline = None
            self.actual_state = "unknown"
            self.estimated_state = "unknown"
            self.operation = {"request_id": request_id, "state": state, "status": "running"}
            if self.approval_seconds is not None:
                self.operation.update(approved_at=self.approved_at,
                    ready_at=self.approved_at+(0 if state=='default' else self.approval_seconds))
            self.pending = ("state", state)
            self.condition.notify_all()
            return "accepted"

    def renew(self, *, session_id, enable_epoch):
        with self.condition:
            if session_id != self.session_id or enable_epoch != self.enable_epoch:
                raise RuntimeError("Stale lease owner")
            if self.lifecycle not in (self.ready_lifecycle, "MOVING"):
                raise RuntimeError("Not armed")
            self.cancel.check()
            self.cancel.deadline = time.monotonic() + self.lease_seconds
            # Extension can be observed at the previous deadline; it does not
            # require waking an otherwise idle owner for every heartbeat.

    def release(self):
        with self.condition:
            self._preview_resume_allowed = False
            self.cancel.event.set()
            self.release_pending = True
            self.actual_state = "unknown"
            self.estimated_state = "unknown"
            self.condition.notify_all()

    def pause_for_preview(self):
        with self.condition:
            # Page-idle and video/preview control may request the same OFF
            # transition. Join an already-authorized release instead of
            # treating RELEASING as a fault or scheduling a second release.
            if (self.preview_interlock and not self.error and not self.closing
                    and self._preview_resume_allowed
                    and self.lifecycle in ('READY_IDLE','ARMING','RELEASING','CONNECTED_OFF')
                    and (self.release_pending or self.lifecycle in ('RELEASING','CONNECTED_OFF'))):
                return
            if (not self.preview_interlock or self.error or self.closing
                    or self.lifecycle not in ('READY_IDLE', 'ARMING', 'CONNECTED_OFF')):
                raise RuntimeError('Preview pause requires a checked non-moving playback controller')
            self.release()
            self._preview_resume_allowed = True

    def resume_preview(self):
        with self.condition:
            if (not self.preview_interlock or not self._preview_resume_allowed
                    or self.error or self.lifecycle != 'CONNECTED_OFF'):
                raise RuntimeError('Preview resume requires its confirmed OFF transition')
            self._preview_resume_allowed = False
            self.arm_used = False
            self.arm()

    def status(self):
        with self.condition:
            return {"session_id": self.session_id, "enable_epoch": self.enable_epoch,
                    "lifecycle": self.lifecycle, "actual_state": self.actual_state,
                    "estimated_state": self.estimated_state,
                    "mode": "fixed-playback" if self.playback else "feedback",
                    "operation": dict(self.operation) if self.operation else None,
                    "error": self.error, "source": "experiment"}

    def wait_idle(self, timeout=10):
        with self.condition:
            return self.condition.wait_for(lambda: self.lifecycle not in ("CONNECTING", "ARMING", "MOVING") and not self.release_pending, timeout)

    def close(self, timeout=10):
        with self.condition:
            self.closing = True
            self.cancel.event.set()
            self.condition.notify_all()
        self.thread.join(timeout)
        if self.thread.is_alive():
            raise TimeoutError("Worker still owns serial port; physical release UNKNOWN")

    def _worker(self):
        backend = None
        write_authorized = False
        try:
            backend = self.factory()
            self.cancel.check()
            motion = Motion(backend, self.settings)
            motion.stage_callback = lambda stage: setattr(self, "playback_stage", stage)
            self.cancel.check()
            backend.connect(self.cancel)
            with self.condition:
                self.cancel.check()
                self.lifecycle = "CONNECTED_OFF"
                self.condition.notify_all()
            while True:
                with self.condition:
                    if self.closing:
                        break
                    if self.release_pending:
                        action, state = "release", None
                        self.pending = None
                        self.release_pending = False
                        self.lifecycle = "RELEASING"
                    elif self.pending:
                        action, state = self.pending
                        self.pending = None
                    else:
                        if self.lifecycle == self.ready_lifecycle:
                            delay = max(0.0, self.cancel.deadline - time.monotonic())
                            if not self.playback:
                                delay = min(self.idle_scan, delay)
                            if self.idle_deadline is not None:
                                delay = min(delay, max(0.0, self.idle_deadline - time.monotonic()))
                            if self.condition.wait(delay):
                                continue
                            if (self.idle_deadline is not None
                                    and self.idle_deadline <= time.monotonic() < self.cancel.deadline):
                                self.cancel.event.set()
                                self.lifecycle = "RELEASING"
                                self.actual_state = "unknown"
                                action, state = "release", None
                            else:
                                action, state = "health", None
                        else:
                            self.condition.wait()
                            continue
                try:
                    if action == "arm":
                        write_authorized = True
                        backend.arm(self.cancel)
                        with self.condition:
                            self.cancel.check()
                            self.enable_epoch = uuid.uuid4().hex
                            self.lifecycle = self.ready_lifecycle
                            if self.idle_release_after is not None:
                                self.idle_deadline = time.monotonic() + self.idle_release_after
                    elif action == "state":
                        if self.approval_seconds is None:
                            motion.run(state, self.cancel)
                        else:
                            motion.run(state,self.cancel,approved_at=self.approved_at,
                                approval_seconds=self.approval_seconds)
                        with self.condition:
                            self.cancel.check()
                            self.operation["status"] = "played" if self.playback else "reached"
                            if self.approval_seconds is not None:
                                self.operation['completed_at']=time.monotonic()
                            self.actual_state = "unknown" if self.playback else state
                            self.estimated_state = state if self.playback else "unknown"
                            self.lifecycle = self.ready_lifecycle
                            if self.idle_release_after is not None:
                                self.idle_deadline = time.monotonic() + self.idle_release_after
                    elif action == "health":
                        self.cancel.check()
                        if not self.playback:
                            motion.sample(self.cancel)
                    else:
                        write_authorized = True
                        failed = backend.release()
                        with self.condition:
                            self.enable_epoch = None
                            self.idle_deadline = None
                            self.actual_state = "unknown"
                            self.estimated_state = "unknown"
                            if failed:
                                self.error = f"Unconfirmed release IDs: {failed}"
                                self.lifecycle = "RELEASE_UNKNOWN"
                            else:
                                self.lifecycle = "FAULT" if self.error else "CONNECTED_OFF"
                            if self.operation and self.operation["status"] == "running":
                                self.operation["status"] = "cancelled"
                except Exception as error:
                    cancelled = isinstance(error, Cancelled)
                    with self.condition:
                        self.actual_state = "unknown"
                        self.estimated_state = "unknown"
                        if not cancelled:
                            self.error = f"{type(error).__name__}: {error}"
                        if self.operation and self.operation["status"] == "running":
                            self.operation["status"] = "cancelled" if cancelled else "fault"
                        if action == "release":
                            self.lifecycle = "RELEASE_UNKNOWN"
                            self.enable_epoch = None
                            self.release_pending = False
                        else:
                            self.release_pending = True
                        self.pending = None
                finally:
                    with self.condition:
                        self.condition.notify_all()
        except Exception as error:
            with self.condition:
                self.error = f"{type(error).__name__}: {error}"
                self.lifecycle = "FAULT"
                self.condition.notify_all()
        finally:
            if backend is not None:
                try:
                    if write_authorized:
                        failed = backend.release()
                        with self.condition:
                            if failed:
                                self.error = f"Unconfirmed final release IDs: {failed}"
                                self.lifecycle = "RELEASE_UNKNOWN"
                except Exception as error:
                    with self.condition:
                        self.error = f"Final release: {error}"
                        self.lifecycle = "RELEASE_UNKNOWN"
                try:
                    backend.close()
                except Exception as error:
                    with self.condition:
                        self.error = f"{self.error or ''} Close: {error}".strip()
                        self.lifecycle = "RELEASE_UNKNOWN"
            with self.condition:
                self.enable_epoch = None
                self.actual_state = "unknown"
                self.estimated_state = "unknown"
                if self.operation and self.operation["status"] == "running":
                    self.operation["status"] = "fault" if self.error else "cancelled"
                self.pending = None
                self.release_pending = False
                if self.lifecycle not in ("FAULT", "RELEASE_UNKNOWN"):
                    self.lifecycle = "CLOSED"
                self.condition.notify_all()
