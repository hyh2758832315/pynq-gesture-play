from pynq_multimodal_game.controls import Direction
from pynq_multimodal_game.engine.side_scroller import SideScrollerCommand
from pynq_multimodal_game.game_sdk import GameInput, HandGesture


HAND_DEADZONE = 0.35
LOW_TONE_MAX_HZ = 500.0
HIGH_TONE_MIN_HZ = 1000.0


class Game1InputAdapter:
    def __init__(self) -> None:
        self._shield_active = False

    def reset(self) -> None:
        self._shield_active = False

    def adapt(self, game_input: GameInput) -> SideScrollerCommand:
        tone = game_input.tone
        attack = bool(
            tone is not None
            and tone.active
            and tone.started
            and tone.frequency_hz >= HIGH_TONE_MIN_HZ
        )
        if tone is None:
            self._shield_active = False
        elif tone.active and tone.frequency_hz <= LOW_TONE_MAX_HZ:
            self._shield_active = True
        elif not attack:
            self._shield_active = False

        return SideScrollerCommand(
            tick_id=game_input.tick_id,
            direction=self._direction(game_input),
            jump=game_input.hand_valid and (game_input.fist_event or game_input.hand_gesture is HandGesture.FIST),
            shield=self._shield_active,
            attack=attack,
        )

    @staticmethod
    def _direction(game_input: GameInput) -> Direction:
        if not game_input.hand_valid:
            return Direction.IDLE
        horizontal = game_input.hand_x
        vertical = game_input.hand_y
        if max(abs(horizontal), abs(vertical)) < HAND_DEADZONE:
            return Direction.IDLE
        if abs(horizontal) >= abs(vertical):
            return Direction.LEFT if horizontal < 0 else Direction.RIGHT
        return Direction.UP if vertical < 0 else Direction.DOWN