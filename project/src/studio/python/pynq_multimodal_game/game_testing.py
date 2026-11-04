from __future__ import annotations

from dataclasses import asdict, dataclass, field
from enum import Enum
import json
from pathlib import Path
import time
from typing import Any, Mapping
import uuid

from .game_sdk import GameSnapshot, HandGesture, VolumeSignal


TEST_CASE_SCHEMA_VERSION = 1
MAX_TEST_TICKS = 4095


class _StrEnum(str, Enum):
    def __str__(self) -> str:
        return self.value


class RunTarget(_StrEnum):
    PC = "pc"
    PYNQ = "pynq"
    COMPARE = "compare"


class InputKind(_StrEnum):
    HAND = "hand"
    FIST = "fist"
    GESTURE = "gesture"
    TONE = "tone"
    CANCEL = "cancel"
    VOICE = "voice"
    VOLUME = "volume"


class AssertionOperator(_StrEnum):
    EQUAL = "eq"
    NOT_EQUAL = "ne"
    LESS_THAN = "lt"
    LESS_EQUAL = "le"
    GREATER_THAN = "gt"
    GREATER_EQUAL = "ge"


@dataclass(frozen=True)
class InputEvent:
    tick: int
    kind: InputKind
    event_id: str = field(default_factory=lambda: uuid.uuid4().hex)
    x: int | None = None
    y: int | None = None
    frequency_hz: float | None = None
    duration_ms: int | None = None
    gesture: HandGesture | None = None
    voice_events: tuple[str, ...] = ()
    voice_status: str | None = None
    volume: VolumeSignal | None = None

    def __post_init__(self) -> None:
        if self.tick < 0:
            raise ValueError("input event tick must be non-negative")
        if not self.event_id:
            raise ValueError("input event ID must not be empty")
        if self.kind in (InputKind.HAND, InputKind.FIST, InputKind.GESTURE):
            if self.x is None or self.y is None or not 0 <= self.x < 320 or not 0 <= self.y < 180:
                raise ValueError("hand input requires x/y inside 320x180")
        elif self.kind is InputKind.TONE:
            if self.frequency_hz is None or not 20.0 <= self.frequency_hz <= 20_000.0:
                raise ValueError("tone frequency must be within [20, 20000] Hz")
            if self.duration_ms is None or self.duration_ms <= 0:
                raise ValueError("tone duration must be positive")
        if self.gesture is not None and (
            self.kind is not InputKind.GESTURE or not isinstance(self.gesture, HandGesture)
        ):
            raise ValueError("gesture classification requires a gesture input event")
        if self.kind is InputKind.VOICE:
            if (type(self.tick) is not int or type(self.voice_events) is not tuple
                    or len(self.voice_events) > 64
                    or any(value not in ("attack", "shield_on", "shield_off") for value in self.voice_events)
                    or self.voice_status not in (None, "RUNNING", "WAITING", "FAULT", "STOPPED", "REARM")
                    or (self.voice_events and self.voice_status in ("WAITING", "FAULT", "STOPPED"))):
                raise ValueError("invalid virtual voice facts or health")
        elif self.voice_events or self.voice_status is not None:
            raise ValueError("voice facts require a voice event")
        if self.kind is InputKind.VOLUME:
            if type(self.tick) is not int or type(self.volume) is not VolumeSignal:
                raise ValueError("volume event requires an explicit VolumeSignal and integer tick")
        elif self.volume is not None:
            raise ValueError("VolumeSignal requires a volume event")


@dataclass(frozen=True)
class AssertionRule:
    tick: int
    field: str
    operator: AssertionOperator
    expected: Any
    message: str = ""

    def __post_init__(self) -> None:
        if self.tick < 0:
            raise ValueError("assertion tick must be non-negative")
        if not self.field:
            raise ValueError("assertion field must not be empty")

    def evaluate(self, snapshot: GameSnapshot) -> tuple[bool, Any]:
        actual = _snapshot_value(snapshot, self.field)
        operations = {
            AssertionOperator.EQUAL: lambda: actual == self.expected,
            AssertionOperator.NOT_EQUAL: lambda: actual != self.expected,
            AssertionOperator.LESS_THAN: lambda: actual < self.expected,
            AssertionOperator.LESS_EQUAL: lambda: actual <= self.expected,
            AssertionOperator.GREATER_THAN: lambda: actual > self.expected,
            AssertionOperator.GREATER_EQUAL: lambda: actual >= self.expected,
        }
        return bool(operations[self.operator]()), actual


@dataclass(frozen=True)
class GameTestCase:
    test_id: str
    name: str
    seed: int = 0
    max_ticks: int = 600
    events: tuple[InputEvent, ...] = ()
    assertions: tuple[AssertionRule, ...] = ()
    schema_version: int | None = None
    tick_timestamps_ns: tuple[int, ...] = ()

    def __post_init__(self) -> None:
        if self.schema_version is None:
            object.__setattr__(self, "schema_version", 4 if any(
                event.kind is InputKind.VOLUME for event in self.events
            ) else 3 if self.tick_timestamps_ns or any(
                event.kind is InputKind.VOICE for event in self.events
            ) else 2 if any(
                event.kind is InputKind.GESTURE for event in self.events
            ) else TEST_CASE_SCHEMA_VERSION)
        if self.schema_version not in (1, 2, 3, 4):
            raise ValueError("unsupported game test case schema")
        if self.schema_version != 4 and any(event.kind is InputKind.VOLUME for event in self.events):
            raise ValueError("volume events require game test case schema 4")
        if self.schema_version not in (3, 4) and (self.tick_timestamps_ns or any(
            event.kind is InputKind.VOICE for event in self.events
        )):
            raise ValueError("virtual voice and explicit timestamps require schema 3")
        if self.schema_version in (3, 4) and (type(self.max_ticks) is not int or type(self.seed) is not int):
            raise ValueError("schema 3 tick range and seed require integers")
        if type(self.tick_timestamps_ns) is not tuple or self.tick_timestamps_ns and (
            len(self.tick_timestamps_ns) != self.max_ticks + 1
            or any(type(value) is not int or not 0 <= value < 2**63 for value in self.tick_timestamps_ns)
            or any(right <= left for left, right in zip(self.tick_timestamps_ns, self.tick_timestamps_ns[1:]))
        ):
            raise ValueError("invalid complete monotonic tick timestamp timeline")
        if self.schema_version == 1 and any(event.kind is InputKind.GESTURE for event in self.events):
            raise ValueError("gesture events require game test case schema 2")
        if not self.test_id or not self.name:
            raise ValueError("test ID and name must not be empty")
        if self.seed < 0 or self.max_ticks <= 0:
            raise ValueError("seed must be non-negative and max_ticks must be positive")
        if self.max_ticks > MAX_TEST_TICKS:
            raise ValueError(f"test tick range exceeds {MAX_TEST_TICKS}")
        if any(event.tick > self.max_ticks for event in self.events):
            raise ValueError("input events must be inside the test tick range")
        if any(rule.tick > self.max_ticks for rule in self.assertions):
            raise ValueError("assertions must be inside the test tick range")
        if len({event.event_id for event in self.events}) != len(self.events):
            raise ValueError("input event IDs must be unique")
        volume_ticks = [event.tick for event in self.events if event.kind is InputKind.VOLUME]
        if len(set(volume_ticks)) != len(volume_ticks):
            raise ValueError("a tick accepts at most one volume event")
        if any(left.tick > right.tick for left, right in zip(self.events, self.events[1:])):
            raise ValueError("input events must be sorted by tick")
        if any(
            left.tick > right.tick
            for left, right in zip(self.assertions, self.assertions[1:])
        ):
            raise ValueError("assertions must be sorted by tick")

    def events_at(self, tick: int) -> tuple[InputEvent, ...]:
        return tuple(event for event in self.events if event.tick == tick)

    def assertions_at(self, tick: int) -> tuple[AssertionRule, ...]:
        return tuple(rule for rule in self.assertions if rule.tick == tick)

    def to_json(self) -> str:
        payload = asdict(self)
        if not self.tick_timestamps_ns:
            payload.pop("tick_timestamps_ns")
        for event in payload["events"]:
            event["kind"] = str(event["kind"])
            if event["kind"] != InputKind.GESTURE.value:
                event.pop("gesture")
            if event["kind"] != InputKind.VOICE.value:
                event.pop("voice_events")
                event.pop("voice_status")
            if event["kind"] != InputKind.VOLUME.value:
                event.pop("volume")
        for rule in payload["assertions"]:
            rule["operator"] = str(rule["operator"])
        return json.dumps(payload, ensure_ascii=False, indent=2, sort_keys=True) + "\n"

    @classmethod
    def from_json(cls, payload: str | bytes) -> GameTestCase:
        raw = json.loads(payload)
        if raw.get("schema_version") in (3, 4):
            if (type(raw["schema_version"]) is not int
                    or type(raw.get("seed", 0)) is not int or type(raw.get("max_ticks", 600)) is not int
                    or any(type(event.get("tick")) is not int for event in raw.get("events", ()))
                    or any(type(rule.get("tick")) is not int for rule in raw.get("assertions", ()))):
                raise ValueError("schema 3 JSON ticks and seed require integers")
        return cls(
            schema_version=int(raw.get("schema_version", 0)),
            test_id=str(raw["test_id"]),
            name=str(raw["name"]),
            seed=int(raw.get("seed", 0)),
            max_ticks=int(raw.get("max_ticks", 600)),
            tick_timestamps_ns=tuple(raw.get("tick_timestamps_ns", ())),
            events=tuple(
                InputEvent(
                    tick=int(event["tick"]),
                    kind=InputKind(event["kind"]),
                    event_id=str(event["event_id"]),
                    x=event.get("x"),
                    y=event.get("y"),
                    frequency_hz=event.get("frequency_hz"),
                    duration_ms=event.get("duration_ms"),
                    gesture=HandGesture(event["gesture"]) if event.get("gesture") is not None else None,
                    voice_events=tuple(event.get("voice_events", ())),
                    voice_status=event.get("voice_status"),
                    volume=_volume_from_json(event.get("volume")),
                )
                for event in raw.get("events", ())
            ),
            assertions=tuple(
                AssertionRule(
                    tick=int(rule["tick"]),
                    field=str(rule["field"]),
                    operator=AssertionOperator(rule["operator"]),
                    expected=rule.get("expected"),
                    message=str(rule.get("message", "")),
                )
                for rule in raw.get("assertions", ())
            ),
        )

    @classmethod
    def load(cls, path: Path) -> GameTestCase:
        return cls.from_json(Path(path).read_text(encoding="utf-8"))

    def save(self, path: Path) -> None:
        path = Path(path)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(self.to_json(), encoding="utf-8")


@dataclass(frozen=True)
class AuditEvent:
    category: str
    action: str
    target: str
    result: str
    details: Mapping[str, Any] = field(default_factory=dict)
    run_id: str = ""
    tick: int | None = None
    timestamp_ns: int = field(default_factory=time.time_ns)

    def __post_init__(self) -> None:
        if not self.category or not self.action or not self.target or not self.result:
            raise ValueError("audit event text fields must not be empty")
        if self.tick is not None and self.tick < 0:
            raise ValueError("audit event tick must be non-negative")


@dataclass(frozen=True)
class AssertionResult:
    rule: AssertionRule
    passed: bool
    actual: Any


def evaluate_assertions(
    snapshot: GameSnapshot, rules: tuple[AssertionRule, ...]
) -> tuple[AssertionResult, ...]:
    results = []
    for rule in rules:
        passed, actual = rule.evaluate(snapshot)
        results.append(AssertionResult(rule, passed, actual))
    return tuple(results)


def _snapshot_value(snapshot: GameSnapshot, field_name: str) -> Any:
    if field_name in ("tick_id", "status", "score"):
        return getattr(snapshot, field_name)
    if not field_name.startswith("values."):
        raise ValueError(f"unsupported snapshot field {field_name!r}")
    value: Any = snapshot.values or {}
    for part in field_name.removeprefix("values.").split("."):
        if not isinstance(value, Mapping) or part not in value:
            raise KeyError(field_name)
        value = value[part]
    return value


def _volume_from_json(value):
    if value is None:
        return None
    if type(value) is not dict or set(value) != {
        "producer_run", "epoch", "sequence", "kind", "source_sample", "source_window"
    }:
        raise ValueError("invalid explicit VolumeSignal JSON")
    return VolumeSignal(**value)