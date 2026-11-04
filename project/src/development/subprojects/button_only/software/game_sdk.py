from __future__ import annotations

from dataclasses import asdict, dataclass
from enum import Enum
import random
from typing import Any, Mapping, Protocol, runtime_checkable

from .controls import ControlState
from .game_actions import GameActionFrame
from .scene import IndexedImage, LOGICAL_HEIGHT, LOGICAL_WIDTH, PalettePack, Scene


GAME_SDK_MAJOR = 1
GAME_SDK_MINOR = 3


class HandGesture(str, Enum):
    FIST = "fist"
    SCISSORS = "scissors"
    PAPER = "paper"


@dataclass
class GestureState:
    gesture: HandGesture | None = None
    sequence: int = 0
    changed: bool = False
    fist_sequence: int = 0
    fist_event: bool = False
    enabled: bool = False

    def apply_legacy(self, *, fist: bool) -> None:
        self.enabled = False
        self.gesture = None
        self.changed = False
        if fist:
            self.fist_sequence += 1
            self.fist_event = True

    def cancel(self) -> None:
        if self.enabled:
            self.update(None)
        self.fist_event = False

    def update(self, gesture: HandGesture | None) -> None:
        if gesture is not None and not isinstance(gesture, HandGesture):
            raise ValueError("unsupported hand gesture")
        self.enabled = True
        if gesture is not HandGesture.FIST:
            self.fist_event = False
        if gesture != self.gesture:
            self.gesture = gesture
            self.sequence += 1
            self.changed = True
            if gesture is HandGesture.FIST:
                self.fist_sequence += 1
                self.fist_event = True
            else:
                self.fist_event = False

    def consume(self) -> dict[str, Any]:
        fields = {
            "hand_gesture": self.gesture,
            "gesture_sequence": self.sequence if self.enabled else None,
            "gesture_changed": self.changed,
            "fist_sequence": self.fist_sequence,
            "fist_event": self.fist_event,
        }
        self.changed = False
        self.fist_event = False
        return fields


@dataclass(frozen=True)
class ToneSignal:
    sequence: int
    frequency_hz: float
    active: bool
    started: bool = False
    ended: bool = False

    def __post_init__(self) -> None:
        if self.sequence < 0:
            raise ValueError("tone sequence must be non-negative")
        if not 20.0 <= self.frequency_hz <= 20_000.0:
            raise ValueError("tone frequency must be within [20, 20000] Hz")
        if self.started and self.ended:
            raise ValueError("tone cannot start and end in the same tick")
        if self.started and not self.active:
            raise ValueError("a starting tone must be active")
        if self.ended and self.active:
            raise ValueError("an ending tone must be inactive")


@dataclass(frozen=True)
class ButtonSignal:
    kind: str
    sequence: int

    def __post_init__(self) -> None:
        if self.kind not in ("BTN0", "BTN1"):
            raise ValueError("button kind must be BTN0 or BTN1")
        if type(self.sequence) is not int or not 1 <= self.sequence <= 0xFFFFFFFF:
            raise ValueError("invalid button sequence")


@dataclass(frozen=True)
class VolumeSignal:
    producer_run: str
    epoch: int
    sequence: int
    kind: str
    source_sample: int
    source_window: int

    def __post_init__(self) -> None:
        if (type(self.producer_run) is not str or len(self.producer_run) != 32
                or any(character not in "0123456789abcdef" for character in self.producer_run)):
            raise ValueError("volume producer must be a 32-character hexadecimal run identity")
        if type(self.kind) is not str or self.kind not in ("SOFT", "LOUD"):
            raise ValueError("volume kind must be SOFT or LOUD")
        for name, maximum in (("epoch", 0xFFFFFFFF), ("sequence", 0xFFFFFFFF),
                              ("source_sample", 0xFFFFFFFFFFFFFFFF), ("source_window", 0xFFFFFFFF)):
            value = getattr(self, name)
            if type(value) is not int or not 1 <= value <= maximum:
                raise ValueError("invalid volume " + name)


@dataclass(frozen=True)
class GameInput:
    tick_id: int
    timestamp_ns: int
    hand_valid: bool
    hand_x: float
    hand_y: float
    fist_sequence: int
    fist_event: bool
    tone: ToneSignal | None = None
    hand_gesture: HandGesture | None = None
    gesture_sequence: int | None = None
    gesture_changed: bool = False
    actions: GameActionFrame | None = None
    volume: VolumeSignal | None = None
    button: ButtonSignal | None = None

    def __post_init__(self) -> None:
        if self.button is not None and type(self.button) is not ButtonSignal:
            raise ValueError("button input must be a ButtonSignal")
        if self.volume is not None and type(self.volume) is not VolumeSignal:
            raise ValueError("volume input must be a VolumeSignal")
        if self.tick_id < 0 or self.timestamp_ns < 0:
            raise ValueError("tick and timestamp must be non-negative")
        if self.actions is not None and (
            type(self.actions) is not GameActionFrame
            or type(self.tick_id) is not int or type(self.timestamp_ns) is not int
            or self.actions.sample_tick != self.tick_id
            or self.actions.sample_timestamp_ns != self.timestamp_ns
        ):
            raise ValueError("actions must match input tick and timestamp")
        if self.fist_sequence < 0:
            raise ValueError("fist sequence must be non-negative")
        if not -1.0 <= self.hand_x <= 1.0 or not -1.0 <= self.hand_y <= 1.0:
            raise ValueError("hand coordinates must be within [-1, 1]")
        if self.hand_gesture is not None and not isinstance(self.hand_gesture, HandGesture):
            raise ValueError("unsupported hand gesture")
        if self.gesture_sequence is not None and self.gesture_sequence < 0:
            raise ValueError("gesture sequence must be non-negative")
        if self.gesture_changed and not self.has_gesture_input:
            raise ValueError("gesture change requires classified input metadata")
        if self.has_gesture_input and self.fist_event and self.hand_gesture is not HandGesture.FIST:
            raise ValueError("fist event requires the fist gesture")

    @property
    def has_gesture_input(self) -> bool:
        return self.hand_gesture is not None or self.gesture_sequence is not None

    @classmethod
    def from_control_state(
        cls, control: ControlState, *, tone: ToneSignal | None = None,
        volume: VolumeSignal | None = None,
    ) -> GameInput:
        return cls(
            tick_id=control.tick_id,
            timestamp_ns=control.timestamp_ns,
            hand_valid=control.hand_valid,
            hand_x=control.hand_x,
            hand_y=control.hand_y,
            fist_sequence=control.gesture_seq,
            fist_event=control.fist_event,
            tone=tone,
            volume=volume,
        )

    @classmethod
    def from_logical_position(
        cls,
        *,
        tick_id: int,
        timestamp_ns: int,
        x: int,
        y: int,
        fist_sequence: int = 0,
        fist_event: bool = False,
        tone: ToneSignal | None = None,
        hand_gesture: HandGesture | None = None,
        gesture_sequence: int | None = None,
        gesture_changed: bool = False,
        actions: GameActionFrame | None = None,
        volume: VolumeSignal | None = None,
    ) -> GameInput:
        if not 0 <= x < LOGICAL_WIDTH or not 0 <= y < LOGICAL_HEIGHT:
            raise ValueError("logical hand position is outside the viewport")
        hand_x = x * 2.0 / (LOGICAL_WIDTH - 1) - 1.0
        hand_y = y * 2.0 / (LOGICAL_HEIGHT - 1) - 1.0
        return cls(
            tick_id=tick_id,
            timestamp_ns=timestamp_ns,
            hand_valid=True,
            hand_x=hand_x,
            hand_y=hand_y,
            fist_sequence=fist_sequence,
            fist_event=fist_event,
            tone=tone,
            hand_gesture=hand_gesture,
            gesture_sequence=gesture_sequence,
            gesture_changed=gesture_changed,
            actions=actions,
            volume=volume,
        )


def canonical_game_input(game_input: GameInput) -> dict[str, Any]:
    payload = asdict(game_input)
    if game_input.button is None:
        payload.pop("button")
    if game_input.volume is None:
        payload.pop("volume")
    if game_input.actions is None:
        payload.pop("actions")
    if not game_input.has_gesture_input:
        for key in ("hand_gesture", "gesture_sequence", "gesture_changed"):
            payload.pop(key)
    return payload


@dataclass(frozen=True)
class GameSnapshot:
    tick_id: int
    status: str
    score: int = 0
    values: Mapping[str, Any] | None = None

    def __post_init__(self) -> None:
        if self.tick_id < 0 or self.score < 0:
            raise ValueError("snapshot tick and score must be non-negative")
        if not self.status:
            raise ValueError("snapshot status must not be empty")


@dataclass(frozen=True)
class GameAssets:
    sprite_atlas: IndexedImage
    tile_atlas: IndexedImage
    palettes: PalettePack


class GameContext:
    def __init__(self, *, seed: int, tick_hz: int) -> None:
        if tick_hz <= 0:
            raise ValueError("tick_hz must be positive")
        self.seed = seed
        self.tick_hz = tick_hz
        self.logical_width = LOGICAL_WIDTH
        self.logical_height = LOGICAL_HEIGHT
        self.random = random.Random(seed)


@runtime_checkable
class GamePlugin(Protocol):
    def reset(self, context: GameContext) -> GameSnapshot: ...

    def step(self, game_input: GameInput) -> GameSnapshot: ...

    def build_scene(self) -> Scene: ...

    def assets(self) -> GameAssets: ...

    def snapshot(self) -> GameSnapshot: ...

    def close(self) -> None: ...
