from pynq_multimodal_game.game_sdk import GameContext, GameInput

from .assets import create_assets
from .input_adapter import player_gesture
from .rules import RpsMatch
from .scene_builder import build_scene
from .snapshot import build_snapshot


class Game:
    def __init__(self) -> None:
        self._assets, self._labels = create_assets()
        self.reset(GameContext(seed=0, tick_hz=60))

    def reset(self, context: GameContext):
        context.random.seed(context.seed)
        self._match = RpsMatch(context.random, context.tick_hz)
        return self.snapshot()

    def step(self, game_input: GameInput):
        self._match.step(game_input.tick_id, player_gesture(game_input))
        return self.snapshot()

    def build_scene(self):
        return build_scene(self._match, self._labels)

    def assets(self):
        return self._assets

    def snapshot(self):
        return build_snapshot(self._match)

    def close(self) -> None:
        pass


def create_game() -> Game:
    return Game()