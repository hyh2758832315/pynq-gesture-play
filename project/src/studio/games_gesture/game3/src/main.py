from dataclasses import asdict
import hashlib
import json

from pynq_multimodal_game.game_sdk import GameContext, GameInput, GameSnapshot

from .assets import create_assets
from .input_adapter import adapt
from .rules import PlatformGame
from .scene_builder import build_scene


class Game:
    def __init__(self):
        self._assets, self._regions = create_assets()
        self.reset(GameContext(seed=0, tick_hz=60))

    def reset(self, context: GameContext):
        self._game = PlatformGame(context.tick_hz)
        return self.snapshot()

    def step(self, game_input: GameInput):
        self._game.step(game_input.tick_id, adapt(game_input))
        return self.snapshot()

    def build_scene(self):
        return build_scene(self._game, self._regions)

    def assets(self):
        return self._assets

    def snapshot(self):
        game = self._game
        values = dict(vars(game))
        values["collected"] = sorted(game.collected)
        values["used_bricks"] = sorted(game.used_bricks)
        values["enemies"] = [asdict(enemy) for enemy in game.enemies]
        values["world_x"], values["world_y"] = game.x // 64, game.y // 64
        values["state_sha256"] = hashlib.sha256(json.dumps(values, sort_keys=True, separators=(",", ":")).encode("ascii")).hexdigest()
        return GameSnapshot(max(0, game.tick), game.status, game.score, values)

    def close(self):
        pass


def create_game():
    return Game()