import math


STATES = ("default", "paper", "scissors", "rock")


def state_route(state: str) -> tuple[str, ...]:
    if state not in STATES:
        raise ValueError("Unknown hand state")
    return ("default",) if state == "default" else ("default", state)


class DebouncedButtons:
    def __init__(self, debounce: float = 0.03):
        if not math.isfinite(debounce) or debounce <= 0:
            raise ValueError("Debounce must be positive and finite")
        self.debounce = debounce
        self.candidate = None
        self.since = 0.0
        self.last_time = -math.inf
        self.released = False

    def sample(self, mask: int, now: float) -> str | None:
        if type(mask) is not int or not 0 <= mask <= 15:
            raise ValueError("Expected four active-high button bits")
        if not math.isfinite(now) or now < self.last_time:
            raise ValueError("Expected a monotonic timestamp")
        self.last_time = now
        if mask != self.candidate:
            self.candidate = mask
            self.since = now
            if mask and mask & (mask - 1):
                self.released = False
            return None
        if now - self.since < self.debounce:
            return None
        if mask == 0:
            self.released = True
            return None
        if not self.released:
            return None
        self.released = False
        if mask & (mask - 1):
            return None
        return STATES[mask.bit_length() - 1]


class ButtonSession:
    def __init__(self, controller, *, request_timeout=45.0, arm_timeout=10.0, release_on_reached=False, playback=False):
        if any(not math.isfinite(value) or value <= 0 for value in (request_timeout, arm_timeout)):
            raise ValueError("Invalid button session budget")
        if type(release_on_reached) is not bool:
            raise ValueError("Immediate release must be an explicit boolean")
        if type(playback) is not bool or (playback and release_on_reached):
            raise ValueError("Fixed playback requires persistent torque")
        self.controller = controller
        self.playback = playback
        self.release_on_reached = release_on_reached
        self.buttons = DebouncedButtons()
        self.request_timeout = request_timeout
        self.arm_timeout = arm_timeout
        self.phase = "startup" if playback else "idle"
        self.state = None
        self.request_id = 0
        self.started = 0.0
        self.next_renew = 0.0

    def tick(self, mask, now):
        try:
            return self._tick(mask, now)
        except BaseException:
            self.controller.release()
            raise

    def _tick(self, mask, now):
        pressed = self.buttons.sample(mask, now)
        status = self.controller.status()
        lifecycle = status["lifecycle"]
        if status["error"] or lifecycle in ("FAULT", "RELEASE_UNKNOWN", "CLOSED"):
            raise RuntimeError(status)
        if self.playback:
            return self._tick_playback(pressed, status, now)
        events = []
        if self.phase != "idle":
            budget = self.arm_timeout if self.phase == "arming" else self.request_timeout
            if now - self.started >= budget:
                raise TimeoutError("Button operation budget exceeded")
            if lifecycle in ("READY", "MOVING") and now >= self.next_renew:
                self.controller.renew(session_id=status["session_id"], enable_epoch=status["enable_epoch"])
                self.next_renew = now + 0.5
            if self.phase == "arming" and lifecycle == "READY":
                self.request_id += 1
                result = self.controller.submit(self.state, request_id=self.request_id,
                                                session_id=status["session_id"], enable_epoch=status["enable_epoch"])
                if result != "accepted":
                    raise RuntimeError(f"Button request rejected: {result}")
                self.phase = "moving"
                self.started = now
                events.append({"event": "accepted", "state": self.state, "request_id": self.request_id})
            elif self.phase == "moving" and lifecycle == "READY":
                operation = status["operation"]
                if not (operation and operation["request_id"] == self.request_id
                        and operation["state"] == self.state and operation["status"] == "reached"
                        and status["actual_state"] == self.state):
                    raise RuntimeError("Button completion does not match request")
                self.phase = "settled"
                events.append({"event": "reached", "state": self.state, "request_id": self.request_id})
                if self.release_on_reached:
                    self.controller.release()
            elif lifecycle == "CONNECTED_OFF":
                if self.phase != "settled":
                    raise RuntimeError("Unexpected release before button completion")
                events.append({"event": "released", "state": self.state, "request_id": self.request_id})
                self.phase = "idle"
                self.state = None
        if pressed is not None:
            if self.phase == "idle" and lifecycle == "CONNECTED_OFF":
                self.controller.arm()
                self.phase = "arming"
                self.state = pressed
                self.started = now
                self.next_renew = now
                events.append({"event": "arm_requested", "state": pressed})
            else:
                events.append({"event": "ignored_busy", "state": pressed})
        return events

    def _tick_playback(self, pressed, status, now):
        lifecycle = status["lifecycle"]
        events = []
        if self.phase == "startup":
            if lifecycle != "CONNECTED_OFF":
                raise RuntimeError("Playback startup requires a checked OFF connection")
            self.controller.arm()
            self.phase = "arming"
            self.started = now
            self.next_renew = now
            events.append({"event": "startup_arm_requested"})
            if pressed is not None:
                events.append({"event": "ignored_busy", "state": pressed})
            return events
        if lifecycle == "CONNECTED_OFF":
            raise RuntimeError("Playback released; a new checked session is required")
        if lifecycle in ("READY_IDLE", "MOVING") and now >= self.next_renew:
            self.controller.renew(session_id=status["session_id"], enable_epoch=status["enable_epoch"])
            self.next_renew = now + 0.5
        if self.phase in ("arming", "moving"):
            budget = self.arm_timeout if self.phase == "arming" else self.request_timeout
            if now - self.started >= budget:
                raise TimeoutError("Button playback budget exceeded")
        if self.phase == "arming" and lifecycle == "READY_IDLE":
            self.phase = "idle"
            events.append({"event": "ready"})
        elif self.phase == "moving" and lifecycle == "READY_IDLE":
            operation = status["operation"]
            if not (operation and operation["request_id"] == self.request_id
                    and operation["state"] == self.state and operation["status"] == "played"
                    and status["actual_state"] == "unknown" and status.get("estimated_state") == self.state):
                raise RuntimeError("Playback completion does not match request")
            events.append({"event": "played", "state": self.state, "request_id": self.request_id})
            self.phase = "idle"
            self.state = None
        if pressed is not None:
            if self.phase == "idle" and lifecycle == "READY_IDLE":
                self.request_id += 1
                result = self.controller.submit(pressed, request_id=self.request_id,
                                                session_id=status["session_id"], enable_epoch=status["enable_epoch"])
                if result != "accepted":
                    raise RuntimeError(f"Button playback rejected: {result}")
                self.state = pressed
                self.phase = "moving"
                self.started = now
                events.append({"event": "accepted", "state": pressed, "request_id": self.request_id})
            else:
                events.append({"event": "ignored_busy", "state": pressed})
        return events