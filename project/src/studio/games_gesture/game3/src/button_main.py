from dataclasses import replace

from .input_adapter import Game3InputAdapter
from .level import SCALE
from .main import Game as BaselineGame
from .rules import PlatformGame


class ButtonPlatformGame(PlatformGame):
    def __init__(self, tick_hz=60):
        super().__init__(tick_hz)
        self.lift_phase = "IDLE"
        self.button_event_kind = None
        self.button_effect = None
        self.button_sequence = 0

    def step_button(self, tick, command, signal):
        if command.tone is not None:
            raise ValueError("button game rejects tone input")
        self.button_event_kind = None
        self.button_effect = None
        if signal is not None:
            if signal.sequence > self.button_sequence:
                self.button_sequence = signal.sequence
                self.button_event_kind = signal.kind
        self.step(tick, command)



class Game(BaselineGame):
    def reset(self, context):
        self._game = ButtonPlatformGame(context.tick_hz)
        self._input_adapter = Game3InputAdapter()
        return self.snapshot()

    def step(self, game_input):
        if game_input.tone is not None or game_input.actions is not None:
            raise ValueError("button game rejects tone and action inputs")
        self._game.step_button(game_input.tick_id,
                              self._input_adapter.adapt(replace(game_input, button=None)), game_input.button)
        return self.snapshot()


def create_game():
    return Game()
