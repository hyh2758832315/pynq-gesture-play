from dataclasses import replace

from .input_adapter import Game1InputAdapter
from .main import Game as BaselineGame


class ButtonInputAdapter(Game1InputAdapter):
    def __init__(self):
        super().__init__()
        self.reset()

    def reset(self):
        super().reset()
        self.shield_until = -1
        self.sample_tick = -1
        self.button_kind = None
        self.sequence = 0

    def adapt(self, game_input):
        if game_input.tone is not None or game_input.actions is not None:
            raise ValueError("button game rejects tone and action inputs")
        self.sample_tick = game_input.tick_id
        self.button_kind = None
        signal = game_input.button
        if signal is not None:
            if signal.sequence > self.sequence:
                self.sequence = signal.sequence
                self.button_kind = signal.kind
                if signal.kind == "BTN0":
                    self.shield_until = game_input.tick_id + 36
        neutral = replace(game_input, button=None)
        return replace(super().adapt(neutral),
                       shield=game_input.tick_id < self.shield_until,
                       attack=self.button_kind == "BTN1")


class Game(BaselineGame):
    def __init__(self):
        super().__init__()
        self._adapter = ButtonInputAdapter()

    def snapshot(self):
        snapshot = super().snapshot()
        return replace(snapshot, values={**snapshot.values,
            "button_event_kind": self._adapter.button_kind,
            "button_shield_ticks_remaining": max(0, self._adapter.shield_until - self._adapter.sample_tick)})


def create_game():
    return Game()
