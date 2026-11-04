from pynq_multimodal_game.controls import Direction
from pynq_multimodal_game.engine.side_scroller import SideScrollerCommand
from pynq_multimodal_game.game_sdk import GameInput


class SignalSprintInputAdapter:
    def __init__(self) -> None:
        self._shield_active = False

    def reset(self) -> None:
        self._shield_active = False

    def adapt(self, game_input: GameInput) -> SideScrollerCommand:
        tone = game_input.tone
        attack = bool(
            tone
            and tone.active
            and tone.started
            and tone.frequency_hz >= 1000.0
        )
        if tone is None:
            self._shield_active = False
        elif tone.active and tone.frequency_hz <= 500.0:
            self._shield_active = True
        elif not attack:
            self._shield_active = False
        return SideScrollerCommand(
            tick_id=game_input.tick_id,
            direction=self._direction(game_input),
            jump=game_input.fist_event,
            shield=self._shield_active,
            attack=attack,
        )

    @staticmethod
    def _direction(game_input: GameInput) -> Direction:
        if not game_input.hand_valid:
            return Direction.IDLE
        horizontal = game_input.hand_x
        vertical = game_input.hand_y
        if max(abs(horizontal), abs(vertical)) < 0.25:
            return Direction.IDLE
        if abs(horizontal) >= abs(vertical):
            return Direction.LEFT if horizontal < 0 else Direction.RIGHT
        return Direction.UP if vertical < 0 else Direction.DOWN