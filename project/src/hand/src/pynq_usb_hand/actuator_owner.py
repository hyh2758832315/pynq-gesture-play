"""Checked vision lifecycle for an explicit backend owner.

No port is opened and no controller is created at import or construction time.
The isolated serial entry supplies the reviewed backend factory; offline tests
supply an in-memory backend through the same lifecycle.
"""

from __future__ import annotations

import math
import re
import threading
import time

from .controller import Controller
from .gesture_consumer import GestureConsumer
from .motion import MockBackend, MotionSettings


class PreviewPause(Exception):
    def __init__(self, generation):
        self.generation = generation


class OwnerFinished(Exception):
    def __init__(self, reason):
        self.reason = reason


class SourceWait(Exception):
    """Aged data is unavailable input, not a transport/controller fault."""


def preview_pause_generation(reason):
    match = re.fullmatch(r'preview_pause:([1-9][0-9]{0,8})', reason or '')
    return None if match is None else int(match[1])


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
    """Finish each motion, then consume only the newest frame.

The caller owns the local receiver and stop event. Source validity is checked
while CONNECTING/ARMING as well as during normal playback. Revocation, stale
frames, shutdown or any controller fault cancel and close the serial worker
by default. The opt-in recovery path treats aged input as waiting: finish only
the approved route, confirm OFF on persistent loss, and resume the same checked
controller only from fresh stable input. Hard faults never use this recovery.
No process termination is part of this protocol.
"""

    def __init__(self, receiver, backend_factory, *, motor_ids, stage_waits,
                 max_seconds, stop=None, on_active=None, poll_seconds=.1,
                 max_age=.5, stable_seconds=.1, startup_seconds=10, approval_seconds=None,
                 receiver_factory=None, on_preview_state=None,
                 source_recovery=False, source_off_seconds=1.0, page_playback=None):
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
        self.page_playback = page_playback
        if page_playback is not None and receiver_factory is None:
            raise ValueError("Page playback requires checked ownership interlock")
        self.settings = MotionSettings.fixed_playback(stage_waits=stage_waits)
        self.approval_seconds=approval_seconds
        if (receiver_factory is None) != (on_preview_state is None):
            raise ValueError('preview interlock requires receiver and state callbacks together')
        self.receiver_factory, self.on_preview_state = receiver_factory, on_preview_state
        if type(source_recovery) is not bool or (source_recovery and receiver_factory is None):
            raise ValueError('source recovery requires the checked pause/resume interlock')
        if (type(source_off_seconds) not in (int, float)
                or not math.isfinite(source_off_seconds) or source_off_seconds <= 0):
            raise ValueError('finite positive source OFF grace required')
        self.source_recovery, self.source_off_seconds = source_recovery, source_off_seconds
        self.source_waits = self.source_resumes = self.source_offs = 0
        self.preview_pauses = self.preview_resumes = 0
        self.preview_control_waits = 0
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
        state_generation = 0

        def observe(required=True):
            if self.stop.is_set():
                if self.receiver_factory is not None:
                    raise OwnerFinished('owner_stop')
                raise RuntimeError("owner_stop")
            observation = self.receiver.poll(time.monotonic())
            if self.receiver.stopped is not None:
                generation = preview_pause_generation(self.receiver.stopped)
                if self.receiver_factory is not None and generation is not None:
                    raise PreviewPause(generation)
                if self.receiver_factory is not None and self.receiver.stopped == 'producer_revoked':
                    raise OwnerFinished('producer_revoked')
                raise RuntimeError("input_channel:" + str(self.receiver.stopped))
            now = time.monotonic()
            if observation is None:
                if required:
                    if active and self.source_recovery and getattr(self.receiver, 'waiting_for_fresh', False):
                        raise SourceWait()
                    raise RuntimeError("missing_source")
                return None
            if source is not None and (observation.run_id, observation.config_epoch) != source:
                raise RuntimeError('source_changed')
            if (not observation.valid or not observation.observed_at <= now
                    or not 0 <= now - observation.source_at < self.max_age):
                if (active and self.source_recovery
                        and observation.observed_at <= now
                        and observation.source_at <= now
                        and (not observation.valid or now - observation.source_at >= self.max_age)):
                    if required:
                        raise SourceWait()
                    return None
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

        def make_consumer():
            class Mailbox:
                def read(inner_self):
                    # Intercept the explicit preview pause before GestureConsumer
                    # can turn it into a source-failure cancellation.
                    return observe() if self.receiver_factory is not None else self.receiver.poll(time.monotonic())
            return GestureConsumer(controller, Mailbox(), source_identity=source,
                max_age=self.max_age, stable_seconds=self.stable_seconds, renew_interval=.2,
                qualified_gestures=True)

        def state_receipt(phase, generation):
            nonlocal state_generation
            state_generation = generation
            if self.on_preview_state is not None:
                self.on_preview_state(dict(phase=phase, pause_generation=generation,
                    controller=controller.status(),
                    release_confirmed_ids=list(self.motor_ids) if phase in ('PAUSED', 'WAITING_SOURCE_OFF') else []))

        def follow_receipt(reason):
            if self.page_playback is not None:
                self.page_playback.record_follow(controller,reason,self.receiver.latest,time.monotonic(),
                    source_waits=self.source_waits,source_resumes=self.source_resumes,
                    overload_waits=getattr(self.receiver,'overload_waits',0))

        def wait_for_source():
            nonlocal consumer
            self.source_waits += 1
            began = time.monotonic()
            latest = self.receiver.latest
            floor = -1 if latest is None else latest.frame_id
            stable = last_at = last_frame = gesture = None
            last_renew = -math.inf
            last_phase = None
            arm_deadline = began + self.startup_seconds if controller.status()['lifecycle'] == 'ARMING' else None
            release_deadline = None
            was_off = controller.status()['lifecycle'] == 'CONNECTED_OFF'
            previous_sent = None if consumer is None else consumer.last_sent
            while True:
                if deadline is not None and time.monotonic() >= deadline:
                    raise OwnerFinished('duration_complete')
                observation = observe(required=False)
                now = time.monotonic()
                status = controller.status()
                if status['error']:
                    raise RuntimeError(status['error'])
                life = status['lifecycle']
                if life not in ('READY_IDLE', 'MOVING', 'ARMING', 'RELEASING', 'CONNECTED_OFF'):
                    raise RuntimeError('unexpected_source_wait_state:' + life)
                transition_requested = False
                fresh = observation is not None and observation.frame_id > floor
                if not fresh:
                    stable = last_at = last_frame = gesture = None
                elif last_frame is None or observation.frame_id > last_frame:
                    if (last_at is None or observation.source_at <= last_at
                            or observation.source_at - last_at >= self.max_age
                            or observation.gesture != gesture):
                        stable = observation.source_at
                    last_at, last_frame, gesture = observation.source_at, observation.frame_id, observation.gesture
                # The PS feed already accepted stable/RPS agreement. Do not
                # require another pair after every .5s gap: slower vision would
                # otherwise remain in recovery indefinitely. UNKNOWN still needs
                # advancing frames for default; stale/identity checks stay above.
                qualified = fresh and observation.gesture in ('paper', 'fist', 'scissors', 'default')
                ready = fresh and (qualified or stable is not None and last_at - stable >= self.stable_seconds)
                if life == 'ARMING' and not fresh and not controller.release_pending:
                    controller.pause_for_preview()
                    transition_requested = True
                    release_deadline = now + self.startup_seconds
                    arm_deadline = None
                elif life == 'ARMING' and arm_deadline is not None and now >= arm_deadline:
                    raise TimeoutError('source recovery arm deadline')
                elif life == 'READY_IDLE' and ready and not controller.release_pending:
                    consumer = make_consumer()
                    if not was_off:
                        consumer.last_sent = previous_sent
                    self.source_resumes += 1
                    state_receipt('ACTIVE', state_generation)
                    return
                elif life == 'CONNECTED_OFF' and ready and not controller.release_pending:
                    controller.resume_preview()
                    transition_requested = True
                    release_deadline = None
                    arm_deadline = now + self.startup_seconds
                elif (life == 'READY_IDLE' and not fresh and now - began >= self.source_off_seconds
                      and not controller.release_pending):
                    controller.pause_for_preview()
                    transition_requested = True
                    release_deadline = now + self.startup_seconds
                    was_off = True
                # A gap cannot approve/queue poses. Complete only the already
                # approved bounded route; lease renew is cache-only, no READ.
                if life in ('READY_IDLE', 'MOVING') and now - last_renew >= .2:
                    if not transition_requested and not controller.release_pending:
                        controller.renew(session_id=status['session_id'], enable_epoch=status['enable_epoch'])
                    last_renew = now
                off = life == 'CONNECTED_OFF' and not transition_requested and not controller.release_pending
                if release_deadline is not None and not off and now >= release_deadline:
                    raise TimeoutError('source OFF confirmation incomplete')
                if off:
                    release_deadline = None
                    if (not self.audit.releases or
                            self.audit.releases[-1] != {'failed_ids': [], 'error': None}):
                        raise RuntimeError('source wait lacks confirmed motor OFF')
                    was_off = True
                phase = 'WAITING_SOURCE_OFF' if off else 'WAITING_SOURCE'
                if phase != last_phase:
                    if off:
                        self.source_offs += 1
                    state_receipt(phase, state_generation)
                    last_phase = phase
                follow_receipt('waiting_source')
                self.stop.wait(self.poll_seconds)

        def control_packet():
            receiver = self.receiver_factory()
            self.receiver = receiver
            observation = receiver.poll(time.monotonic())
            generation = preview_pause_generation(receiver.stopped)
            if receiver.stopped == 'producer_revoked':
                raise OwnerFinished('producer_revoked')
            if receiver.stopped is not None and generation is None and receiver.stopped != 'stale_source':
                raise RuntimeError('input_channel:' + str(receiver.stopped))
            return receiver, observation, generation

        def pause_for_preview(generation):
            nonlocal consumer
            while True:
                # Finish only the already approved route. Preview pixels remain
                # gated until the OFF receipt; no next gesture can be submitted.
                while controller.status()['lifecycle'] == 'MOVING':
                    if self.stop.is_set():
                        raise OwnerFinished('owner_stop')
                    if deadline is not None and time.monotonic() >= deadline:
                        raise OwnerFinished('duration_complete')
                    _, _, newer = control_packet()
                    generation = max(generation, newer or generation)
                    status = controller.status()
                    if status['error']:
                        raise RuntimeError(status['error'])
                    controller.renew(session_id=status['session_id'],enable_epoch=status['enable_epoch'])
                    self.stop.wait(.05)
                controller.pause_for_preview()
                off_deadline = time.monotonic() + self.startup_seconds
                while True:
                    status = controller.status()
                    if status['error']:
                        raise RuntimeError(status['error'])
                    if status['lifecycle'] == 'CONNECTED_OFF':
                        break
                    if self.stop.is_set() or time.monotonic() >= off_deadline:
                        if self.stop.is_set():
                            raise OwnerFinished('owner_stop')
                        raise RuntimeError('preview OFF confirmation incomplete')
                    control_packet()  # Drain control traffic; never queue poses.
                    self.stop.wait(.05)
                if not self.audit.releases or self.audit.releases[-1] != {'failed_ids': [], 'error': None}:
                    raise RuntimeError('preview pause lacks confirmed motor OFF')
                self.preview_pauses += 1
                state_receipt('PAUSED', generation)
                heartbeat = time.monotonic()
                control_waiting = False
                while True:
                    if self.stop.is_set():
                        raise OwnerFinished('owner_stop')
                    now = time.monotonic()
                    if deadline is not None and now >= deadline:
                        raise OwnerFinished('duration_complete')
                    receiver, observation, newer = control_packet()
                    now = time.monotonic()
                    resume_generation = receiver.preview_resume_generation
                    if newer is not None:
                        heartbeat = now
                        control_waiting = False
                        if newer > generation:
                            generation = newer
                            state_receipt('PAUSED', generation)
                    elif resume_generation is not None:
                        heartbeat = now
                        control_waiting = False
                        if resume_generation > generation:
                            generation = resume_generation
                            state_receipt('PAUSED', generation)
                        if observation is None or resume_generation != generation:
                            self.stop.wait(.1)
                            continue
                        if (observation.run_id, observation.config_epoch) != source:
                            raise RuntimeError('source_changed')
                        if (observation.valid and observation.observed_at <= now
                                and 0 <= now-observation.source_at < self.max_age):
                            self.receiver = receiver
                            break
                    if now-heartbeat >= 3. and not control_waiting:
                        # All motors are already confirmed OFF. A quiet parent
                        # cannot authorize motion, and need not destroy this
                        # safe owner during CPU-heavy video validation. Retain
                        # the OFF port owner until explicit fresh resume/stop.
                        # Invalid identity, source changes and controller faults
                        # still fail through control_packet/observe as before.
                        self.preview_control_waits += 1
                        control_waiting = True
                        state_receipt('PAUSED', generation)
                    self.stop.wait(.1)
                # Reuse the loaded model, backend and serial controller. Arm
                # uses the existing arm safety checks; no repeated connect or
                # model loading, and no continuous playback feedback polling.
                try:
                    observe()
                    controller.resume_preview()
                    arm_deadline = time.monotonic() + self.startup_seconds
                    while True:
                        observe()
                        status = controller.status()
                        if status['error']:
                            raise RuntimeError(status['error'])
                        if status['lifecycle'] == 'READY_IDLE':
                            break
                        if time.monotonic() >= arm_deadline:
                            raise TimeoutError('preview resume arm deadline')
                        self.stop.wait(.05)
                except PreviewPause as request:
                    generation = request.generation
                    continue
                consumer = make_consumer()
                self.preview_resumes += 1
                state_receipt('ACTIVE', generation)
                return

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
                                    startup_timeout=self.startup_seconds,
                                    approval_seconds=self.approval_seconds,
                                    preview_interlock=self.receiver_factory is not None,
                                    demo_states=() if self.page_playback is None else __import__("pynq_usb_hand.page_playback",fromlist=["DEMO_STATES"]).DEMO_STATES)
            await_state("CONNECTED_OFF", "CONNECTING")
            # Check the source again immediately before the only arm request.
            observe()
            controller.arm()
            await_state("READY_IDLE", "ARMING")

            consumer = make_consumer()
            active = True
            if self.on_active is not None:
                self.on_active(source)
            state_receipt('ACTIVE', 0)
            page_owned = False
            while not self.stop.is_set() and (deadline is None or time.monotonic() < deadline):
                try:
                    if self.page_playback is not None:
                        observe(required=False)  # transport identity/revocation still has priority
                        handled = self.page_playback.tick(controller,time.monotonic())
                        if handled:
                            operation = controller.status()["operation"]
                            if operation is not None and operation["request_id"] > last_request:
                                last_request = operation["request_id"]
                                operations.append(dict(operation))
                                del operations[:-32]
                            page_owned = True
                            self.stop.wait(self.poll_seconds)
                            continue
                        if page_owned:
                            consumer = make_consumer()
                            # The page that just released ownership may have
                            # supplied the current slot. Require a newer frame
                            # before authorizing a live-page gesture.
                            latest = self.receiver.latest
                            if latest is not None:
                                consumer.last_frame = latest.frame_id
                                consumer.last_source_at = latest.source_at
                            page_owned = False
                    reason = consumer.tick(time.monotonic)
                    follow_receipt(reason)
                except (PreviewPause, SourceWait) as request:
                    if self.page_playback is not None and isinstance(request, PreviewPause):
                        self.page_playback.interrupt()
                    while True:
                        try:
                            if isinstance(request, SourceWait):
                                wait_for_source()
                            else:
                                pause_for_preview(request.generation)
                            break
                        except (PreviewPause, SourceWait) as newer:
                            request = newer
                    continue
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
        except OwnerFinished as finished:
            reason = finished.reason
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
                "preview_pauses": self.preview_pauses, "preview_resumes": self.preview_resumes,
                "preview_control_waits": self.preview_control_waits,
                "source_waits": self.source_waits, "source_resumes": self.source_resumes,
                "source_offs": self.source_offs,
                "overload_waits": getattr(self.receiver,'overload_waits',0),
                "source": source, "stop_reason": reason, "error": error,
                "controller": status, "operations": operations,
                "arm_attempted": bool(audit is not None and audit.arm_attempted),
                "backend_closed": bool(audit is not None and audit.closed),
                "release_confirmed": released,
                "release_confirmed_ids": list(self.motor_ids) if released else [],
                "release_attempts": [] if audit is None else audit.releases,
                "elapsed": time.monotonic() - started}
