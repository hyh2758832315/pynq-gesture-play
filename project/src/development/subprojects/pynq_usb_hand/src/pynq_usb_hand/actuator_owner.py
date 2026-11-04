"""Checked vision lifecycle for an explicit backend owner.

No port is opened and no controller is created at import or construction time.
The isolated serial entry supplies the reviewed backend factory; offline tests
supply an in-memory backend through the same lifecycle.
"""

from __future__ import annotations

import math
import threading
import time

from .controller import Controller
from .gesture_consumer import GestureConsumer
from .motion import MockBackend, MotionSettings


class _AuditedBackend:
    def __init__(self, backend, motor_ids):
        if not isinstance(backend, MockBackend) and tuple(backend.model.ids) != motor_ids:
            raise ValueError("backend motor IDs do not match the release receipt")
        self.backend = backend
        self.arm_attempted = False
        self.closed = False
        self.releases = []

    def __getattr__(self, name):
        return getattr(self.backend, name)

    def arm(self, cancel):
        self.arm_attempted = True
        return self.backend.arm(cancel)

    def release(self):
        attempt = {"failed_ids": None, "error": None}
        self.releases.append(attempt)
        try:
            failed = tuple(self.backend.release())
            attempt["failed_ids"] = list(failed)
            return failed
        except Exception as error:
            attempt["error"] = f"{type(error).__name__}: {error}"
            raise

    def close(self):
        self.backend.close()
        self.closed = True


class VisionActuatorOwner:
    """One enable epoch; finish each motion, then consume only the newest frame.

The caller owns the local receiver and stop event. Source validity is checked
while CONNECTING/ARMING as well as during normal playback. Revocation, stale
frames, shutdown or any controller fault cancel and close the serial worker.
No process termination or automatic re-arm is part of this protocol.
"""

    def __init__(self, receiver, backend_factory, *, motor_ids, stage_waits,
                 max_seconds, stop=None, on_active=None, poll_seconds=.1,
                 max_age=.5, stable_seconds=.1, startup_seconds=10):
        if (not motor_ids or len(set(motor_ids)) != len(motor_ids)
                or any(type(value) is not int or value <= 0 for value in motor_ids)):
            raise ValueError("explicit unique motor IDs required")
        if max_seconds is not None and (type(max_seconds) not in (int, float)
                                       or not math.isfinite(max_seconds) or max_seconds <= 0):
            raise ValueError("optional session limit must be finite and positive")
        for value in (startup_seconds, max_age, stable_seconds, poll_seconds):
            if type(value) not in (int, float) or not math.isfinite(value) or value <= 0:
                raise ValueError("finite positive lifecycle budgets required")
        if not .02 <= poll_seconds <= .5 or not stable_seconds < max_age:
            raise ValueError("poll/stability budget outside source freshness")
        self.settings = MotionSettings.fixed_playback(stage_waits=stage_waits)
        self.receiver, self.factory = receiver, backend_factory
        self.motor_ids = tuple(motor_ids)
        self.max_seconds, self.startup_seconds = max_seconds, startup_seconds
        self.poll_seconds, self.max_age = poll_seconds, max_age
        self.stable_seconds = stable_seconds
        self.stop = stop if stop is not None else threading.Event()
        self.on_active = on_active
        self.used = False
        self.audit = None

    def run(self):
        if self.used:
            raise RuntimeError("vision actuator owner cannot restart")
        self.used = True
        started = time.monotonic()
        deadline = None if self.max_seconds is None else started + self.max_seconds
        startup_deadline = started + self.startup_seconds
        if deadline is not None:
            startup_deadline = min(deadline, startup_deadline)
        controller = consumer = None
        source = None
        active = False
        error = None
        reason = "duration_complete"
        operations = []
        last_request = 0

        def observe(required=True):
            if self.stop.is_set():
                raise RuntimeError("owner_stop")
            observation = self.receiver.poll(time.monotonic())
            if self.receiver.stopped is not None:
                raise RuntimeError("input_channel:" + str(self.receiver.stopped))
            now = time.monotonic()
            if observation is None:
                if required:
                    raise RuntimeError("missing_source")
                return None
            if (not observation.valid or not observation.observed_at <= now
                    or not 0 <= now - observation.source_at < self.max_age):
                raise RuntimeError("invalid_or_stale_source")
            if source is not None and (observation.run_id, observation.config_epoch) != source:
                raise RuntimeError("source_changed")
            return observation

        def await_state(expected, pending):
            while True:
                observe()
                if time.monotonic() >= startup_deadline:
                    raise TimeoutError("actuator startup deadline")
                status = controller.status()
                if status["error"]:
                    raise RuntimeError(status["error"])
                if status["lifecycle"] == expected:
                    return
                if status["lifecycle"] != pending:
                    raise RuntimeError("unexpected_controller_state:" + status["lifecycle"])
                self.stop.wait(self.poll_seconds)

        try:
            first = None
            while first is None:
                first = observe(required=False)
                if first is not None:
                    break
                if time.monotonic() >= startup_deadline:
                    raise TimeoutError("fresh source startup deadline")
                self.stop.wait(self.poll_seconds)
            source = (first.run_id, first.config_epoch)

            def factory():
                self.audit = _AuditedBackend(self.factory(), self.motor_ids)
                return self.audit

            controller = Controller(factory, lease_seconds=5, settings=self.settings,
                                    startup_timeout=self.startup_seconds)
            await_state("CONNECTED_OFF", "CONNECTING")
            # Check the source again immediately before the only arm request.
            observe()
            controller.arm()
            await_state("READY_IDLE", "ARMING")

            class Mailbox:
                def read(inner_self):
                    return self.receiver.poll(time.monotonic())

            consumer = GestureConsumer(
                controller, Mailbox(), source_identity=source, max_age=self.max_age,
                stable_seconds=self.stable_seconds, renew_interval=.2,
            )
            active = True
            if self.on_active is not None:
                self.on_active(source)
            while not self.stop.is_set() and (deadline is None or time.monotonic() < deadline):
                reason = consumer.tick(time.monotonic)
                operation = controller.status()["operation"]
                if operation is not None and operation["request_id"] > last_request:
                    last_request = operation["request_id"]
                    # Keep bounded diagnostics even in a long-running session.
                    operations.append(dict(operation))
                    del operations[:-32]
                if consumer.stopped:
                    break
                self.stop.wait(self.poll_seconds)
            if self.stop.is_set():
                reason = "owner_stop"
            elif deadline is not None and time.monotonic() >= deadline:
                reason = "duration_complete"
        except Exception as failure:
            error = f"{type(failure).__name__}: {failure}"
            reason = "startup_failed" if not active else "owner_failed"
        finally:
            if controller is not None:
                try:
                    if consumer is not None:
                        consumer.stop("actuator_owner_closed")
                    controller.close(timeout=10)
                except Exception as failure:
                    error = error or f"{type(failure).__name__}: {failure}"
        status = None if controller is None else controller.status()
        audit = self.audit
        released = bool(
            audit is not None and audit.arm_attempted and audit.closed and audit.releases
            and audit.releases[-1] == {"failed_ids": [], "error": None}
            and status["lifecycle"] == "CLOSED" and status["error"] is None
        )
        return {"schema": "vision-hand-actuator-owner-v1", "active": active,
                "max_seconds": self.max_seconds,
                "source": source, "stop_reason": reason, "error": error,
                "controller": status, "operations": operations,
                "arm_attempted": bool(audit is not None and audit.arm_attempted),
                "backend_closed": bool(audit is not None and audit.closed),
                "release_confirmed": released,
                "release_confirmed_ids": list(self.motor_ids) if released else [],
                "release_attempts": [] if audit is None else audit.releases,
                "elapsed": time.monotonic() - started}
