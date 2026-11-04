from __future__ import annotations

from collections import deque
from dataclasses import dataclass
import math
import threading
import time
from contextlib import contextmanager
import weakref


_KINDS = {"attack": "HIGH_ONSET", "shield_on": "LOW_SEGMENT_ON",
          "shield_off": "LOW_SEGMENT_OFF"}


def _integer(value: object, name: str) -> int:
    if type(value) is not int or value < 0:
        raise ValueError(f"{name} must be a non-negative integer")
    return value


def _identity(value: str, name: str) -> str:
    if not isinstance(value, str) or not value.strip() or len(value) > 256:
        raise ValueError(f"invalid {name}")
    return value


def _seconds(value: object, name: str) -> float:
    if type(value) not in (int, float) or not math.isfinite(value) or value < 0:
        raise ValueError(f"{name} must be finite and non-negative")
    return float(value)


@dataclass(frozen=True)
class VoiceEvent:
    sequence: int
    kind: str
    source_event: str
    feature_start_sample_8k: int


@dataclass(frozen=True)
class VoiceObservation:
    producer_run: str
    audio_epoch: str
    packet_index: int
    decision_ns: int
    processing_seconds: float
    events: tuple[VoiceEvent, ...]
    schema: str = "voice-observation-v1"
    source_age_ns: int | None = None
    source_age_verified: bool = False


class VoiceResultValidator:
    def __init__(self, producer_run: str, audio_epoch: str, *, max_events: int = 64,
                 feature_window_samples: int = 512, feature_stride: int = 32) -> None:
        self.producer_run = _identity(producer_run, "producer_run")
        self.audio_epoch = _identity(audio_epoch, "audio_epoch")
        if _integer(max_events, "max_events") == 0:
            raise ValueError("max_events must be positive")
        self.max_events = max_events
        if (_integer(feature_window_samples, "feature_window_samples") == 0
                or _integer(feature_stride, "feature_stride") == 0):
            raise ValueError("feature window and stride must be positive")
        self.feature_window_samples = feature_window_samples
        self.feature_stride = feature_stride
        self.received = 0
        self.event_sequence = 0
        self.decision_ns: int | None = None
        self.fault: str | None = None

    def invalidate(self, reason: str) -> None:
        if self.fault is None:
            self.fault = str(reason)

    def accept(self, message: object) -> VoiceObservation:
        if self.fault is not None:
            raise ValueError(f"voice epoch revoked: {self.fault}")
        try:
            observation = self._validate(message)
        except (ValueError, TypeError, OverflowError) as error:
            self.invalidate(str(error))
            raise ValueError(str(error)) from error
        self.received += 1
        self.event_sequence += len(observation.events)
        self.decision_ns = observation.decision_ns
        return observation

    def _validate(self, message: object) -> VoiceObservation:
        if type(message) is not tuple or len(message) != 5 or message[0] != "result":
            raise ValueError("require a five-field recognition result")
        _, index, events, elapsed, decided = message
        if _integer(index, "packet_index") != self.received:
            raise ValueError("voice packet sequence discontinuity")
        processing = _seconds(elapsed, "processing_seconds")
        decision_seconds = _seconds(decided, "decision time")
        if decision_seconds > (2**63 - 1) / 1e9:
            raise ValueError("decision time exceeds nanosecond range")
        decision_ns = round(decision_seconds * 1e9)
        if self.decision_ns is not None and decision_ns < self.decision_ns:
            raise ValueError("voice decision time regressed")
        if type(events) is not list or len(events) > self.max_events:
            raise ValueError("invalid voice event list or capacity")
        normalized = []
        for offset, event in enumerate(events, start=1):
            if type(event) not in (list, tuple) or len(event) != 2:
                raise ValueError("invalid recognition event shape")
            source, sample = event
            if type(source) is not str or source not in _KINDS:
                raise ValueError("unknown recognition event")
            sample = _integer(sample, "feature sample")
            if (sample + self.feature_window_samples > (index + 1) * 160
                    or sample % self.feature_stride):
                raise ValueError("feature window outside received PCM or sample grid")
            normalized.append(VoiceEvent(self.event_sequence + offset, _KINDS[source], source, sample))
        return VoiceObservation(self.producer_run, self.audio_epoch, index, decision_ns,
                                processing, tuple(normalized))


@dataclass(frozen=True)
class VoiceRead:
    status: str
    producer_run: str | None
    audio_epoch: str | None
    observations: tuple[VoiceObservation, ...] = ()
    latest: VoiceObservation | None = None
    decision_age_ns: int | None = None
    reason: str | None = None


class VoiceObservationBus:
    def __init__(self, *, capacity: int = 64, max_subscribers: int = 8) -> None:
        for name, value in (("capacity", capacity), ("max_subscribers", max_subscribers)):
            if _integer(value, name) == 0:
                raise ValueError(f"{name} must be positive")
        self._lock = threading.RLock()
        self._history: deque[tuple[int, VoiceObservation]] = deque(maxlen=capacity)
        self._subscribers: weakref.WeakSet[VoiceSubscription] = weakref.WeakSet()
        self._max_subscribers = max_subscribers
        self.generation = 0
        self._serial = 0
        self._status = "WAITING"
        self._reason: str | None = None
        self._identity: tuple[str | None, str | None] = (None, None)
        self._latest: VoiceObservation | None = None

    def begin_epoch(self, producer_run: str, audio_epoch: str) -> None:
        identity = (_identity(producer_run, "producer_run"), _identity(audio_epoch, "audio_epoch"))
        with self._lock:
            if identity == self._identity:
                raise ValueError("a new voice epoch is required")
            self.generation += 1
            self._identity = identity
            self._history.clear()
            self._latest = None
            self._status, self._reason = "WAITING", None

    def publish(self, observation: VoiceObservation) -> None:
        with self._lock:
            if self._status not in ("WAITING", "RUNNING"):
                raise ValueError("voice bus epoch revoked")
            if type(observation) is not VoiceObservation or (
                observation.producer_run, observation.audio_epoch
            ) != self._identity:
                self.invalidate("voice observation identity mismatch")
                raise ValueError("voice observation identity mismatch")
            expected = 0 if self._latest is None else self._latest.packet_index + 1
            if observation.packet_index != expected:
                self.invalidate("voice bus packet discontinuity")
                raise ValueError("voice bus packet discontinuity")
            self._serial += 1
            self._history.append((self._serial, observation))
            self._latest = observation
            self._status = "RUNNING"

    def invalidate(self, reason: str, *, status: str = "FAULT") -> None:
        if status not in ("FAULT", "STOPPED"):
            raise ValueError("invalid voice terminal status")
        with self._lock:
            if self._status not in ("FAULT", "STOPPED"):
                self._status, self._reason = status, str(reason)
            self._history.clear()
            self._latest = None

    def subscribe(self, *, max_age_ns: int) -> VoiceSubscription:
        if _integer(max_age_ns, "max_age_ns") == 0:
            raise ValueError("max_age_ns must be positive")
        with self._lock:
            if len(self._subscribers) >= self._max_subscribers:
                raise ValueError("voice subscription capacity exceeded")
            subscription = VoiceSubscription(self, max_age_ns)
            self._subscribers.add(subscription)
            return subscription

    @property
    def status(self) -> VoiceRead:
        with self._lock:
            return VoiceRead(self._status, *self._identity, reason=self._reason)

    @contextmanager
    def sampling_clock(self):
        with self._lock:
            yield time.monotonic_ns()

    def observe(self, now_ns: int) -> VoiceRead:
        _integer(now_ns, "observer time")
        with self._lock:
            latest = self._latest
            age = None if latest is None else max(0, now_ns - latest.decision_ns)
            return VoiceRead(self._status, *self._identity, latest=latest, decision_age_ns=age, reason=self._reason)


class VoiceSubscription:
    def __init__(self, bus: VoiceObservationBus, max_age_ns: int) -> None:
        self._bus = bus
        self._generation = bus.generation
        self._cursor = bus._serial
        self._max_age_ns = max_age_ns
        self._last_now: int | None = None
        self._fault: str | None = None
        self._fault_latest: VoiceObservation | None = None
        self._fault_age_ns: int | None = None

    @property
    def generation(self) -> int:
        return self._generation

    def close(self) -> None:
        with self._bus._lock:
            self._fault = self._fault or "voice subscription closed"
            self._bus._subscribers.discard(self)

    def poll(self, now_ns: int) -> VoiceRead:
        _integer(now_ns, "consumer time")
        with self._bus._lock:
            bus = self._bus
            if self._last_now is not None and now_ns < self._last_now:
                self._fault = "voice consumer time regressed"
            self._last_now = now_ns
            if self._generation != bus.generation:
                self._fault = "voice subscription epoch ended"
            if self._fault is not None:
                return VoiceRead("FAULT", *bus._identity, latest=self._fault_latest,
                                 decision_age_ns=self._fault_age_ns, reason=self._fault)
            if bus._status != "RUNNING":
                return VoiceRead(bus._status, *bus._identity, reason=bus._reason)
            latest = bus._latest
            assert latest is not None
            age = now_ns - latest.decision_ns
            if age < 0 or age > self._max_age_ns:
                self._fault = "voice decision age outside consumer budget"
            elif bus._history and self._cursor < bus._history[0][0] - 1:
                self._fault = "voice subscription overrun"
            pending = tuple(observation for serial, observation in bus._history if serial > self._cursor)
            if any(now_ns - observation.decision_ns > self._max_age_ns for observation in pending):
                self._fault = "voice pending observation expired"
            if self._fault is not None:
                self._fault_latest, self._fault_age_ns = latest, age
                return VoiceRead("FAULT", *bus._identity, latest=latest,
                                 decision_age_ns=age, reason=self._fault)
            self._cursor = bus._serial
            return VoiceRead("RUNNING", *bus._identity, pending, latest, age)