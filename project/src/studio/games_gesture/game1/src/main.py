from pynq_multimodal_game.game_sdk import GameAssets, GameContext, GameInput, GameSnapshot
from pynq_multimodal_game.scene import Scene

from .assets import create_assets
from .input_adapter import Game1InputAdapter
from .level import create_engine
from .scene_builder import build_scene
from .snapshot import build_snapshot


class Game:
    def __init__(self) -> None:
        self._engine = create_engine()
        self._game_assets = create_assets()
        self._adapter = Game1InputAdapter()
        self._state = self._engine.initial_state()

    def reset(self, context: GameContext) -> GameSnapshot:
        self._state = self._engine.initial_state()
        self._adapter.reset()
        return self.snapshot()

    def step(self, game_input: GameInput) -> GameSnapshot:
        self._state = self._engine.step(self._state, self._adapter.adapt(game_input))
        return self.snapshot()

    def build_scene(self) -> Scene:
        return build_scene(self._state, self._engine.config, self._game_assets)

    def assets(self) -> GameAssets:
        renderer = self._game_assets.renderer
        return GameAssets(renderer.sprite_atlas, renderer.tile_atlas, renderer.palettes)

    def snapshot(self) -> GameSnapshot:
        return build_snapshot(self._state)

    def close(self) -> None:
        pass

def create_game() -> Game:
    return Game()