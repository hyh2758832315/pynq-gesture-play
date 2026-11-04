from __future__ import annotations

import json
from dataclasses import asdict, dataclass, replace
from enum import Enum, IntEnum, IntFlag
from pathlib import Path
from typing import Any, Iterable, Protocol, cast


class Direction(IntEnum):
    IDLE = 0
    LEFT = 1
    RIGHT = 2
    UP = 3
    DOWN = 4


class ControlSource(str, Enum):
    KEYBOARD = "KEYBOARD"
    BUTTON = "BUTTON"
    REPLAY = "REPLAY"
    REAL = "REAL"


class StaleFlag(IntFlag):
    NONE = 0
    GESTURE = 1 << 0
    VOICE = 1 << 1
    ADAPTER_ERROR = 1 << 2


@dataclass(frozen=True)
class ControlState:
    tick_id: int
    timestamp_ns: int
    gesture_source: ControlSource
    gesture_seq: int
    hand_valid: bool
    hand_x: float
    hand_y: float
    direction: Direction
    fist_score: float
    fist_event: bool
    voice_source: ControlSource
    voice_seq: int
    audio_valid: bool
    low_voice_active: bool
    high_voice_event: bool
    low_confidence: float
    high_confidence: float
    stale_flags: StaleFlag = StaleFlag.NONE

    def __post_init__(self) -> None:
        if self.tick_id < 0 or self.timestamp_ns < 0:
            raise ValueError("tick_id and timestamp_ns must be non-negative")
        if self.gesture_seq < 0 or self.voice_seq < 0:
            raise ValueError("event sequences must be non-negative")
        for name in ("hand_x", "hand_y"):
            value = getattr(self, name)
            if not -1.0 <= value <= 1.0:
                raise ValueError(f"{name} must be within [-1, 1]")
        for name in ("fist_score", "low_confidence", "high_confidence"):
            value = getattr(self, name)
            if not 0.0 <= value <= 1.0:
                raise ValueError(f"{name} must be within [0, 1]")


@dataclass(frozen=True)
class MockInput:
    left: bool = False
    right: bool = False
    up: bool = False
    down: bool = False
    jump: bool = False
    shield: bool = False
    attack: bool = False


class MockControlAdapter:
    _POSITIONS = {
        Direction.IDLE: (0.0, 0.0),
        Direction.LEFT: (-1.0, 0.0),
        Direction.RIGHT: (1.0, 0.0),
        Direction.UP: (0.0, -1.0),
        Direction.DOWN: (0.0, 1.0),
    }

    def __init__(self, source: ControlSource) -> None:
        if source not in (ControlSource.KEYBOARD, ControlSource.BUTTON):
            raise ValueError("MockControlAdapter requires a keyboard or button source")
        self._source = source
        self._previous = MockInput()
        self._gesture_seq = 0
        self._voice_seq = 0
        self._press_order = 0
        self._horizontal_order = 0
        self._vertical_order = 0
        self._inputs = MockInput()

    @property
    def source(self) -> ControlSource:
        return self._source

    def set_input(self, inputs: MockInput) -> None:
        self._inputs = inputs

    def read(self, *, tick_id: int, timestamp_ns: int) -> ControlState:
        return self.sample(self._inputs, tick_id=tick_id, timestamp_ns=timestamp_ns)

    def sample(
        self,
        inputs: MockInput,
        *,
        tick_id: int,
        timestamp_ns: int,
    ) -> ControlState:
        direction = self._resolve_direction(inputs)
        fist_event = inputs.jump and not self._previous.jump
        high_voice_event = inputs.attack and not self._previous.attack

        if fist_event:
            self._gesture_seq += 1
        if high_voice_event:
            self._voice_seq += 1

        hand_x, hand_y = self._POSITIONS[direction]
        state = ControlState(
            tick_id=tick_id,
            timestamp_ns=timestamp_ns,
            gesture_source=self._source,
            gesture_seq=self._gesture_seq,
            hand_valid=True,
            hand_x=hand_x,
            hand_y=hand_y,
            direction=direction,
            fist_score=1.0 if inputs.jump else 0.0,
            fist_event=fist_event,
            voice_source=self._source,
            voice_seq=self._voice_seq,
            audio_valid=True,
            low_voice_active=inputs.shield,
            high_voice_event=high_voice_event,
            low_confidence=1.0 if inputs.shield else 0.0,
            high_confidence=1.0 if high_voice_event else 0.0,
        )
        self._previous = inputs
        return state

    def _resolve_direction(self, inputs: MockInput) -> Direction:
        horizontal = 0 if inputs.left == inputs.right else (-1 if inputs.left else 1)
        vertical = 0 if inputs.up == inputs.down else (-1 if inputs.up else 1)
        previous_horizontal = (
            0
            if self._previous.left == self._previous.right
            else (-1 if self._previous.left else 1)
        )
        previous_vertical = (
            0
            if self._previous.up == self._previous.down
            else (-1 if self._previous.up else 1)
        )

        horizontal_changed = horizontal and horizontal != previous_horizontal
        vertical_changed = vertical and vertical != previous_vertical
        if horizontal_changed or vertical_changed:
            self._press_order += 1
        if horizontal_changed:
            self._horizontal_order = self._press_order
        if vertical_changed:
            self._vertical_order = self._press_order

        if horizontal and (
            not vertical or self._horizontal_order >= self._vertical_order
        ):
            return Direction.LEFT if horizontal < 0 else Direction.RIGHT
        if vertical:
            return Direction.UP if vertical < 0 else Direction.DOWN
        return Direction.IDLE


class ControlAdapter(Protocol):
    @property
    def source(self) -> ControlSource: ...

    def read(self, *, tick_id: int, timestamp_ns: int) -> ControlState: ...


class ReplayControlAdapter:
    def __init__(self, records: Iterable[ControlState]) -> None:
        self._records = {record.tick_id: record for record in records}
        if not self._records:
            raise ValueError("replay requires at least one control state")

    @property
    def source(self) -> ControlSource:
        return ControlSource.REPLAY

    def read(self, *, tick_id: int, timestamp_ns: int) -> ControlState:
        try:
            record = self._records[tick_id]
        except KeyError as error:
            raise EOFError(f"replay has no record for tick {tick_id}") from error
        return replace(
            record,
            timestamp_ns=timestamp_ns,
            gesture_source=ControlSource.REPLAY,
            voice_source=ControlSource.REPLAY,
        )

    @classmethod
    def from_jsonl(cls, path: str | Path) -> ReplayControlAdapter:
        records = []
        with Path(path).open("r", encoding="utf-8") as stream:
            for line_number, line in enumerate(stream, start=1):
                if not line.strip():
                    continue
                try:
                    records.append(control_state_from_dict(json.loads(line)))
                except (TypeError, ValueError, KeyError) as error:
                    raise ValueError(f"invalid replay record at line {line_number}") from error
        return cls(records)


class ControlSourceMux:
    def __init__(
        self,
        adapters: Iterable[ControlAdapter],
        *,
        gesture_source: ControlSource,
        voice_source: ControlSource,
    ) -> None:
        self._adapters = {adapter.source: adapter for adapter in adapters}
        self._require_source(gesture_source)
        self._require_source(voice_source)
        self.gesture_source = gesture_source
        self.voice_source = voice_source
        self._gesture_armed = True
        self._voice_armed = True

    def select_gesture(self, source: ControlSource) -> None:
        self._require_source(source)
        if source != self.gesture_source:
            self.gesture_source = source
            self._gesture_armed = False

    def select_voice(self, source: ControlSource) -> None:
        self._require_source(source)
        if source != self.voice_source:
            self.voice_source = source
            self._voice_armed = False

    def poll(self, *, tick_id: int, timestamp_ns: int) -> ControlState:
        gesture_adapter = self._adapters[self.gesture_source]
        voice_adapter = self._adapters[self.voice_source]
        gesture = gesture_adapter.read(tick_id=tick_id, timestamp_ns=timestamp_ns)
        voice = (
            gesture
            if voice_adapter is gesture_adapter
            else voice_adapter.read(tick_id=tick_id, timestamp_ns=timestamp_ns)
        )
        self._validate_tick(gesture, tick_id)
        self._validate_tick(voice, tick_id)

        fist_event = gesture.fist_event and self._gesture_armed
        high_voice_event = voice.high_voice_event and self._voice_armed
        if gesture.hand_valid:
            self._gesture_armed = True
        if voice.audio_valid:
            self._voice_armed = True

        stale_flags = (
            gesture.stale_flags & (StaleFlag.GESTURE | StaleFlag.ADAPTER_ERROR)
        ) | (voice.stale_flags & (StaleFlag.VOICE | StaleFlag.ADAPTER_ERROR))
        return ControlState(
            tick_id=tick_id,
            timestamp_ns=timestamp_ns,
            gesture_source=self.gesture_source,
            gesture_seq=gesture.gesture_seq,
            hand_valid=gesture.hand_valid,
            hand_x=gesture.hand_x,
            hand_y=gesture.hand_y,
            direction=gesture.direction,
            fist_score=gesture.fist_score,
            fist_event=fist_event,
            voice_source=self.voice_source,
            voice_seq=voice.voice_seq,
            audio_valid=voice.audio_valid,
            low_voice_active=voice.low_voice_active,
            high_voice_event=high_voice_event,
            low_confidence=voice.low_confidence,
            high_confidence=voice.high_confidence,
            stale_flags=stale_flags,
        )

    def _require_source(self, source: ControlSource) -> None:
        if source not in self._adapters:
            raise KeyError(f"no adapter registered for {source.value}")

    @staticmethod
    def _validate_tick(state: ControlState, tick_id: int) -> None:
        if state.tick_id != tick_id:
            raise ValueError("adapter returned a state for the wrong tick")


def control_state_to_dict(state: ControlState) -> dict[str, object]:
    payload = asdict(state)
    payload["gesture_source"] = state.gesture_source.value
    payload["voice_source"] = state.voice_source.value
    payload["direction"] = int(state.direction)
    payload["stale_flags"] = int(state.stale_flags)
    return payload


def control_state_from_dict(payload: dict[str, object]) -> ControlState:
    values: dict[str, Any] = dict(payload)
    values["gesture_source"] = ControlSource(values["gesture_source"])
    values["voice_source"] = ControlSource(values["voice_source"])
    values["direction"] = Direction(values["direction"])
    values["stale_flags"] = StaleFlag(values.get("stale_flags", 0))
    return ControlState(**cast(Any, values))


def write_control_jsonl(path: str | Path, records: Iterable[ControlState]) -> None:
    with Path(path).open("w", encoding="utf-8", newline="\n") as stream:
        for record in records:
            json.dump(control_state_to_dict(record), stream, separators=(",", ":"))
            stream.write("\n")