from dataclasses import replace

from .input_adapter import adapt
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

    def _audio(self, tone):
        target = self._near_target()
        if self.button_event_kind == "BTN1" and target == "note" and not self.gate_open:
            self.gate_open = True
            self.note_hits += 1
            self.button_effect = "gate-open"
        elif self.button_event_kind == "BTN0" and target == "lift" and self.lift_phase == "IDLE":
            self.lift_phase = "RISING"
            self.button_effect = "lift-start"

    def _lift(self):
        self.lift_charge = 18 if self.lift_phase == "RISING" else 0
        super()._lift()
        if self.lift_phase == "RISING" and self.lift_y == 64 * SCALE:
            self.lift_phase = "HOLDING"
        elif self.lift_phase == "HOLDING" and self.lift_grace == 0:
            self.lift_phase = "DESCENDING"
        elif self.lift_phase == "DESCENDING" and self.lift_y == 144 * SCALE:
            self.lift_phase = "IDLE"


class Game(BaselineGame):
    def reset(self, context):
        self._game = ButtonPlatformGame(context.tick_hz)
        return self.snapshot()

    def step(self, game_input):
        if game_input.tone is not None or game_input.actions is not None:
            raise ValueError("button game rejects tone and action inputs")
        self._game.step_button(game_input.tick_id, adapt(replace(game_input, button=None)), game_input.button)
        return self.snapshot()


def create_game():
    return Game()
