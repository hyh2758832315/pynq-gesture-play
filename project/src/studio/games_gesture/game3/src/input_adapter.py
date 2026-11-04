"""Visual movement/jump only; button_main owns mechanism activation."""

from dataclasses import dataclass, replace

from pynq_multimodal_game.game_sdk import GameInput, HandGesture, ToneSignal


@dataclass(frozen=True)
class Command:
    direction: int = 0
    jump: bool = False
    tone: ToneSignal | None = None
    jump_held: bool = False
    vertical: int = 0


def adapt(game_input: GameInput) -> Command:
    gesture = game_input.hand_gesture if game_input.hand_valid else None
    direction = -1 if game_input.hand_x < -0.35 else 1 if game_input.hand_x > 0.35 else 0
    if not game_input.hand_valid:
        direction = 0
    fist = gesture is HandGesture.FIST
    return Command(direction, fist and game_input.fist_event, None, fist,
                   (-1 if game_input.hand_y < -.35 else 1 if game_input.hand_y > .35 else 0) if game_input.hand_valid else 0)


class Game3InputAdapter:
    """Per-game direction latch; no global state shared across game instances."""
    def __init__(self):
        self.reset()

    def reset(self):
        self.direction = 0
        self._last_timestamp_ns = None

    def adapt(self, game_input):
        stamp = game_input.timestamp_ns
        if (self._last_timestamp_ns is not None
                and not 0 <= stamp-self._last_timestamp_ns <= 250_000_000):
            self.direction = 0
        self._last_timestamp_ns = stamp
        value = game_input.hand_x
        if not game_input.hand_valid:
            self.direction = 0
        elif abs(value) >= .35:
            self.direction = -1 if value < 0 else 1
        elif value * self.direction <= .23:
            self.direction = 0
        return replace(adapt(game_input), direction=self.direction)
