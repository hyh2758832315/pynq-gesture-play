"""Visual movement/jump only; button_main owns shield and attack."""

from pynq_multimodal_game.controls import Direction
from pynq_multimodal_game.engine.side_scroller import SideScrollerCommand
from pynq_multimodal_game.game_sdk import GameInput, HandGesture


HAND_DEADZONE = 0.35


class Game1InputAdapter:
    def __init__(self) -> None:
        self.reset()

    def reset(self) -> None:
        self._horizontal = self._vertical = 0
        self._last_timestamp_ns = None

    def adapt(self, game_input: GameInput) -> SideScrollerCommand:
        gesture = game_input.hand_gesture if game_input.hand_valid else None
        return SideScrollerCommand(
            tick_id=game_input.tick_id,
            direction=self._direction(game_input),
            jump=gesture is HandGesture.FIST,
            shield=False,
            attack=False,
        )

    def _direction(self, game_input: GameInput) -> Direction:
        stamp = game_input.timestamp_ns
        if (self._last_timestamp_ns is not None
                and not 0 <= stamp-self._last_timestamp_ns <= 250_000_000):
            self._horizontal = self._vertical = 0
        self._last_timestamp_ns = stamp
        if not game_input.hand_valid:
            self._horizontal = self._vertical = 0
            return Direction.IDLE
        horizontal, vertical = game_input.hand_x, game_input.hand_y
        def axis(value, previous):
            if abs(value) >= HAND_DEADZONE:
                return -1 if value < 0 else 1
            return previous if value * previous > .23 else 0
        self._horizontal = axis(horizontal, self._horizontal)
        self._vertical = axis(vertical, self._vertical)
        if not self._horizontal and not self._vertical:
            return Direction.IDLE
        if self._horizontal and (not self._vertical or abs(horizontal) >= abs(vertical)):
            return Direction.LEFT if self._horizontal < 0 else Direction.RIGHT
        return Direction.UP if self._vertical < 0 else Direction.DOWN
