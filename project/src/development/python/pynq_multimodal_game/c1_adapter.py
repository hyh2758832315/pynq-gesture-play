from __future__ import annotations

import json
from pathlib import Path

from .controls import ControlSource, ControlState, Direction, control_state_from_dict
from .game_sdk import GameInput
from .game_testing import (
    AssertionOperator,
    AssertionRule,
    GameTestCase,
    InputEvent,
    InputKind,
)


C1_HAND_DEADZONE = 0.35
C1_LOW_TONE_MAX_HZ = 500.0
C1_HIGH_TONE_MIN_HZ = 1000.0
C1_LOW_TONE_HZ = 220.0
C1_HIGH_TONE_HZ = 1200.0
C1_FINAL_STATE_SHA256 = (
    "af10ca2b7564ad16fb59b0ed8bc730335975e618dfc47b3c950de553ac2abd86"
)

_DIRECTION_POSITIONS = {
    Direction.IDLE: (160, 90),
    Direction.LEFT: (0, 90),
    Direction.RIGHT: (319, 90),
    Direction.UP: (160, 0),
    Direction.DOWN: (160, 179),
}


class C1GameInputAdapter:
    def __init__(self) -> None:
        self._shield_active = False

    def reset(self) -> None:
        self._shield_active = False

    def adapt(self, game_input: GameInput) -> ControlState:
        direction = self._direction(game_input)
        tone = game_input.tone
        high_voice_event = bool(
            tone is not None
            and tone.active
            and tone.started
            and tone.frequency_hz >= C1_HIGH_TONE_MIN_HZ
        )
        if tone is None:
            self._shield_active = False
        elif tone.active and tone.frequency_hz <= C1_LOW_TONE_MAX_HZ:
            self._shield_active = True
        elif not high_voice_event:
            self._shield_active = False

        return ControlState(
            tick_id=game_input.tick_id,
            timestamp_ns=game_input.timestamp_ns,
            gesture_source=ControlSource.REAL,
            gesture_seq=game_input.fist_sequence,
            hand_valid=game_input.hand_valid,
            hand_x=game_input.hand_x,
            hand_y=game_input.hand_y,
            direction=direction,
            fist_score=1.0 if game_input.fist_event else 0.0,
            fist_event=game_input.fist_event,
            voice_source=ControlSource.REAL,
            voice_seq=0 if tone is None else tone.sequence,
            audio_valid=tone is not None,
            low_voice_active=self._shield_active,
            high_voice_event=high_voice_event,
            low_confidence=1.0 if self._shield_active else 0.0,
            high_confidence=1.0 if high_voice_event else 0.0,
        )

    @staticmethod
    def _direction(game_input: GameInput) -> Direction:
        if not game_input.hand_valid:
            return Direction.IDLE
        horizontal = game_input.hand_x
        vertical = game_input.hand_y
        if max(abs(horizontal), abs(vertical)) < C1_HAND_DEADZONE:
            return Direction.IDLE
        if abs(horizontal) >= abs(vertical):
            return Direction.LEFT if horizontal < 0 else Direction.RIGHT
        return Direction.UP if vertical < 0 else Direction.DOWN


def c1_replay_to_test_case(path: str | Path) -> GameTestCase:
    records = _load_replay(path)
    events: list[InputEvent] = []
    previous_direction: Direction | None = None
    for index, record in enumerate(records):
        x, y = _DIRECTION_POSITIONS[record.direction]
        if record.direction is not previous_direction:
            events.append(
                InputEvent(
                    tick=record.tick_id,
                    kind=InputKind.HAND,
                    event_id=f"c1-hand-{record.tick_id:03d}",
                    x=x,
                    y=y,
                )
            )
            previous_direction = record.direction
        if record.fist_event:
            events.append(
                InputEvent(
                    tick=record.tick_id,
                    kind=InputKind.FIST,
                    event_id=f"c1-fist-{record.tick_id:03d}",
                    x=x,
                    y=y,
                )
            )
        if record.high_voice_event:
            events.append(
                InputEvent(
                    tick=record.tick_id,
                    kind=InputKind.TONE,
                    event_id=f"c1-attack-{record.tick_id:03d}",
                    frequency_hz=C1_HIGH_TONE_HZ,
                    duration_ms=16,
                )
            )
        elif record.low_voice_active and (
            index == 0
            or not records[index - 1].low_voice_active
            or records[index - 1].high_voice_event
        ):
            run_length = 1
            while index + run_length < len(records):
                following = records[index + run_length]
                if not following.low_voice_active or following.high_voice_event:
                    break
                run_length += 1
            events.append(
                InputEvent(
                    tick=record.tick_id,
                    kind=InputKind.TONE,
                    event_id=f"c1-shield-{record.tick_id:03d}",
                    frequency_hz=C1_LOW_TONE_HZ,
                    duration_ms=max(1, run_length * 1000 // 60),
                )
            )

    final_tick = records[-1].tick_id
    return GameTestCase(
        test_id="c1-golden",
        name="C1 Golden Replay",
        max_ticks=final_tick,
        events=tuple(events),
        assertions=(
            AssertionRule(final_tick, "status", AssertionOperator.EQUAL, "WON"),
            AssertionRule(final_tick, "score", AssertionOperator.EQUAL, 40),
            AssertionRule(
                final_tick,
                "values.state_sha256",
                AssertionOperator.EQUAL,
                C1_FINAL_STATE_SHA256,
            ),
        ),
    )


def _load_replay(path: str | Path) -> tuple[ControlState, ...]:
    records: list[ControlState] = []
    with Path(path).open("r", encoding="utf-8") as stream:
        for line_number, line in enumerate(stream, start=1):
            if not line.strip():
                continue
            try:
                records.append(control_state_from_dict(json.loads(line)))
            except (TypeError, ValueError, KeyError) as error:
                raise ValueError(f"invalid C1 replay record at line {line_number}") from error
    if not records:
        raise ValueError("C1 replay is empty")
    if any(record.tick_id != index for index, record in enumerate(records)):
        raise ValueError("C1 replay ticks must be contiguous from zero")
    return tuple(records)