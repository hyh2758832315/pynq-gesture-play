from dataclasses import dataclass
import math
import threading
import time
from typing import Protocol

from .buttons import STATES, state_route


TIP_JOINTS = ("index_pip", "middle_pip", "ring_pip", "pinky_pip", "thumb_dip")


class Cancelled(Exception):
    pass


class Cancellation:
    def __init__(self, deadline: float, clock=time.monotonic):
        self.event = threading.Event()
        self.deadline = deadline
        self.clock = clock

    def check(self):
        if self.event.is_set():
            raise Cancelled("Release requested")
        if self.clock() >= self.deadline:
            raise TimeoutError("Control lease expired")

    def wait(self, duration):
        if not math.isfinite(duration) or duration < 0:
            raise ValueError("Wait duration must be finite and nonnegative")
        end = self.clock() + duration
        while True:
            self.check()
            remaining = end - self.clock()
            if remaining <= 0:
                return
            # Renewing a lease must not shorten this motion stage. Re-evaluate
            # the live lease after waking at its former deadline.
            self.event.wait(min(remaining, max(0.0, self.deadline - self.clock())))


class FeedbackCancellation(Cancellation):
    def __init__(self, parent, feedback_deadline):
        self.parent = parent
        self.feedback_deadline = feedback_deadline
        self.clock = parent.clock
        self.event = parent.event

    @property
    def deadline(self):
        return min(self.parent.deadline, self.feedback_deadline)

    def check(self):
        self.parent.check()
        if self.clock() >= self.feedback_deadline:
            raise TimeoutError("Health feedback gap exceeded")

    def wait(self, duration):
        self.check()
        self.parent.wait(min(duration, self.feedback_deadline - self.clock()))
        self.check()


@dataclass(frozen=True)
class Snapshot:
    sequence: int
    started: float
    finished: float
    joints: dict[str, float]


class Backend(Protocol):
    poses: dict[str, dict[str, float]]
    roms: dict[str, tuple[float, float]]

    def connect(self, cancel: Cancellation): ...
    def arm(self, cancel: Cancellation): ...
    def sample(self, cancel: Cancellation) -> Snapshot: ...
    def write(self, target: dict[str, float], cancel: Cancellation): ...
    def compile_target(self, target: dict[str, float]): ...
    def write_compiled(self, target, cancel: Cancellation): ...
    def release(self) -> tuple[int, ...]: ...
    def close(self): ...


@dataclass(frozen=True)
class MotionSettings:
    step_size: float = 0.03
    hold: float = 1.0
    timeout: float = 10.0
    tolerance: float = 0.10
    sample_interval: float = 0.02
    max_age: float = 1.0
    waypoint_feedback_interval: float = 0.0
    reuse_settled_feedback: bool = False
    periodic_reached_samples: bool = False
    endpoint_feedback: bool = False
    settle_delay: float = 0.0
    max_reached_samples: int = 0
    max_feedback_gap: float = 1.0
    stage_targets: bool = False
    open_loop: bool = False
    stage_waits: tuple[float, ...] = ()

    @classmethod
    def responsive(cls, *, max_age=1.0):
        return cls(step_size=0.01, hold=0.0, max_age=max_age, waypoint_feedback_interval=0.2,
               reuse_settled_feedback=True, periodic_reached_samples=True)

    @classmethod
    def endpoints(cls, *, settle_delay, max_reached_samples, max_feedback_gap, max_age=1.0, stage_targets=False):
        return cls(step_size=0.01, hold=0.0, max_age=max_age, waypoint_feedback_interval=0.2,
                   reuse_settled_feedback=True, periodic_reached_samples=True, endpoint_feedback=True,
                   settle_delay=settle_delay, max_reached_samples=max_reached_samples,
                   max_feedback_gap=max_feedback_gap, stage_targets=stage_targets)

    @classmethod
    def fixed_playback(cls, *, stage_waits):
        return cls(hold=0.0, stage_targets=True, open_loop=True, stage_waits=tuple(stage_waits))

    def __post_init__(self):
        for value in (self.step_size, self.hold):
            if not math.isfinite(value) or value < 0:
                raise ValueError("Invalid motion duration")
        for value in (self.timeout, self.sample_interval, self.max_age):
            if not math.isfinite(value) or value <= 0:
                raise ValueError("Invalid feedback timing")
        if not math.isfinite(self.tolerance) or not 0 < self.tolerance < 1:
            raise ValueError("Invalid tolerance")
        if not math.isfinite(self.waypoint_feedback_interval) or not 0 <= self.waypoint_feedback_interval < self.max_age:
            raise ValueError("Waypoint feedback interval must be nonnegative and below max age")
        if not math.isfinite(self.settle_delay) or self.settle_delay < 0:
            raise ValueError("Invalid endpoint settling delay")
        if type(self.open_loop) is not bool:
            raise ValueError("Playback mode must be an explicit boolean")
        if type(self.stage_targets) is not bool or (self.stage_targets and not (self.endpoint_feedback or self.open_loop)):
            raise ValueError("Stage targets require endpoint feedback")
        if self.open_loop:
            if not self.stage_targets or self.endpoint_feedback or len(self.stage_waits) != 3:
                raise ValueError("Fixed playback requires native targets and three explicit stage waits")
            if any(type(value) not in (int, float) or not math.isfinite(value) or not 0 < value <= 10 for value in self.stage_waits):
                raise ValueError("Playback stage waits must be positive and at most ten seconds")
        elif self.stage_waits:
            raise ValueError("Stage waits require fixed playback")
        if self.endpoint_feedback:
            if type(self.max_reached_samples) is not int or self.max_reached_samples < 3:
                raise ValueError("Endpoint feedback requires at least three bounded samples")
            if not math.isfinite(self.max_feedback_gap) or not 0 < self.max_feedback_gap <= self.max_age:
                raise ValueError("Health feedback gap must be positive and within max age")


class Motion:
    def __init__(self, backend: Backend, settings=None, clock=time.monotonic):
        self.backend = backend
        self.settings = settings or MotionSettings()
        if (self.settings.stage_targets and not isinstance(backend, MockBackend)
                and getattr(backend, "stage_targets_authorized", False) is not True):
            raise ValueError("Stage targets are offline-only unless native trajectory is explicitly authorized")
        if (self.settings.open_loop and not isinstance(backend, MockBackend)
                and getattr(backend, "playback_authorized", False) is not True):
            raise ValueError("Fixed playback requires explicit startup-only authorization")
        self.clock = clock
        self.last_sequence = -1
        self.last_sample_started = -math.inf
        self.last_stage = None
        self.last_frame = None
        self.settled_frame = None
        for pose in backend.poses.values():
            self.validate(pose)
        self.playback_routes = self.prepare_playback() if self.settings.open_loop else {}

    def prepare_playback(self):
        routes = {}
        compiled = {}
        default = self.backend.poses["default"]
        for state in STATES:
            stages = [("default:target", dict(default), self.settings.stage_waits[0])]
            if state != "default":
                target = dict(self.backend.poses[state])
                if state in ("paper", "rock"):
                    midpoint = dict(default)
                    for joint in TIP_JOINTS:
                        midpoint[joint] = default[joint] + 0.5 * (target[joint] - default[joint])
                    if state == "rock":
                        midpoint["thumb_abd"] = target["thumb_abd"]
                    stages.append((state + ":midpoint", midpoint, self.settings.stage_waits[1]))
                stages.append((state + ":target", target, self.settings.stage_waits[2]))
            route = []
            for label, target, duration in stages:
                key = tuple(sorted(target.items()))
                if key not in compiled:
                    self.validate(target)
                    compiled[key] = self.backend.compile_target(target)
                route.append((label, compiled[key], duration))
            routes[state] = tuple(route)
        return routes

    def validate(self, joints):
        if set(joints) != set(self.backend.roms):
            raise ValueError("Incomplete joint target or feedback")
        for joint, value in joints.items():
            lower, upper = self.backend.roms[joint]
            if not all(math.isfinite(number) for number in (lower, upper, value)) or not lower < upper:
                raise ValueError(f"Invalid joint data: {joint}")
            if not lower - 1e-6 <= value <= upper + 1e-6:
                raise ValueError(f"Joint outside calibrated ROM: {joint}")

    def sample(self, cancel):
        cancel = self.feedback_cancel(cancel)
        cancel.check()
        frame = self.backend.sample(cancel)
        cancel.check()
        now = self.clock()
        if frame.sequence <= self.last_sequence:
            raise OSError("Feedback sequence is stale")
        if not all(math.isfinite(value) for value in (frame.started, frame.finished)):
            raise OSError("Invalid feedback timestamps")
        if not frame.started <= frame.finished <= now or now - frame.started > self.settings.max_age:
            raise OSError("Feedback age exceeded")
        self.validate(frame.joints)
        self.last_sequence = frame.sequence
        self.last_sample_started = frame.started
        self.last_frame = frame
        return frame.joints

    def feedback_cancel(self, cancel):
        if self.settings.endpoint_feedback and math.isfinite(self.last_sample_started):
            return FeedbackCancellation(cancel, self.last_sample_started + self.settings.max_feedback_gap)
        return cancel

    def starting_joints(self, cancel):
        cancel.check()
        frame = self.settled_frame
        self.settled_frame = None
        if self.settings.reuse_settled_feedback and frame is not None:
            now = self.clock()
            if frame.finished <= now and now - frame.started <= self.settings.max_age:
                self.validate(frame.joints)
                return dict(frame.joints)
        return self.sample(cancel)

    def reached(self, target, cancel):
        deadline = self.clock() + self.settings.timeout
        consecutive = 0
        samples = 0
        while True:
            sample_started = self.clock()
            current = self.sample(cancel)
            samples += 1
            if self.clock() >= deadline:
                raise TimeoutError("Stage did not reach target within deadline")
            error = max(abs(current[joint] - goal) / (self.backend.roms[joint][1] - self.backend.roms[joint][0]) for joint, goal in target.items())
            consecutive = consecutive + 1 if error <= self.settings.tolerance else 0
            if consecutive >= 3:
                return
            if self.settings.endpoint_feedback and samples >= self.settings.max_reached_samples:
                raise TimeoutError("Endpoint feedback sample budget exceeded")
            remaining = self.settings.sample_interval
            if self.settings.periodic_reached_samples:
                remaining -= self.clock() - sample_started
            if remaining > 0:
                self.feedback_cancel(cancel).wait(remaining)

    def stage(self, label, target, steps, cancel, *, start=None):
        self.validate(target)
        current = self.starting_joints(cancel) if start is None else start
        self.validate(current)
        self.last_stage = label
        write_cancel = self.feedback_cancel(cancel)
        indices = (steps,) if self.settings.stage_targets else range(steps + 1)
        for index in indices:
            write_cancel.check()
            waypoint_started = self.clock()
            interval = self.settings.waypoint_feedback_interval
            if not self.settings.endpoint_feedback and interval > 0 and self.clock() - self.last_sample_started >= interval:
                self.sample(cancel)
            fraction = index / steps
            waypoint = {joint: current[joint] * (1 - fraction) + value * fraction for joint, value in target.items()}
            self.validate(waypoint)
            self.backend.write(waypoint, write_cancel)
            write_cancel.check()
            if not self.settings.endpoint_feedback and (interval == 0 or self.clock() - self.last_sample_started >= interval):
                self.sample(cancel)
            if index < steps:
                remaining = waypoint_started + self.settings.step_size - self.clock()
                if remaining > 0:
                    write_cancel.wait(remaining)
        if self.settings.endpoint_feedback and self.settings.settle_delay:
            write_cancel.wait(self.settings.settle_delay)
        self.reached(target, cancel)
        if self.settings.reuse_settled_feedback:
            self.settled_frame = self.last_frame

    def run(self, state, cancel):
        if self.settings.open_loop:
            for label, target, duration in self.playback_routes[state]:
                cancel.check()
                self.last_stage = label
                self.backend.write_compiled(target, cancel)
                cancel.wait(duration)
            return
        self.settled_frame = None
        if self.settings.endpoint_feedback:
            self.last_sample_started = -math.inf
        for name in state_route(state):
            target = dict(self.backend.poses[name])
            if name in ("paper", "rock"):
                current = self.starting_joints(cancel)
                midpoint = dict(current)
                for joint in TIP_JOINTS:
                    midpoint[joint] = current[joint] + 0.5 * (target[joint] - current[joint])
                if name == "rock":
                    midpoint["thumb_abd"] = target["thumb_abd"]
                self.stage(name + ":midpoint", midpoint, 10, cancel,
                           start=current if self.settings.reuse_settled_feedback else None)
                self.stage(name + ":target", target, 10, cancel)
            else:
                self.stage(name + ":target", target, 20, cancel)
            cancel.wait(self.settings.hold)


class MockBackend:
    def __init__(self, poses=None, roms=None):
        names = ("wrist", "thumb_abd") + TIP_JOINTS
        self.roms = roms or {name: (0.0, 100.0) for name in names}
        self.poses = poses or {state: {name: (index + 1) * 10.0 for name in names} for index, state in enumerate(("default", "paper", "scissors", "rock"))}
        self.position = dict(self.poses["default"])
        self.writes = []
        self.sequence = 0
        self.torque = False
        self.closed = False

    def connect(self, cancel):
        cancel.check()

    def arm(self, cancel):
        cancel.check()
        self.torque = True

    def sample(self, cancel):
        cancel.check()
        started = time.monotonic()
        self.sequence += 1
        return Snapshot(self.sequence, started, time.monotonic(), dict(self.position))

    def compile_target(self, target):
        return tuple(target.items())

    def write_compiled(self, target, cancel):
        self.write(dict(target), cancel)

    def write(self, target, cancel):
        cancel.check()
        if not self.torque:
            raise RuntimeError("Mock torque is OFF")
        self.position = dict(target)
        self.writes.append(dict(target))

    def release(self):
        self.torque = False
        return ()

    def close(self):
        self.closed = True
