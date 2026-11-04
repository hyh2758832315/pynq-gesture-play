from pynq_multimodal_game.game_sdk import GameAssets, GameContext, GameInput, GameSnapshot
from pynq_multimodal_game.scene import Scene

from .input_adapter import SignalSprintInputAdapter
from .level import create_engine
from .presentation import SignalSprintAssets, build_scene, create_assets
from .snapshot import build_snapshot


class Game:
    def __init__(self) -> None:
        self._engine = create_engine()
        self._assets: SignalSprintAssets = create_assets()
        self._adapter = SignalSprintInputAdapter()
        self._state = self._engine.initial_state()

    def reset(self, context: GameContext) -> GameSnapshot:
        self._state = self._engine.initial_state()
        self._adapter.reset()
        return self.snapshot()

    def step(self, game_input: GameInput) -> GameSnapshot:
        self._state = self._engine.step(self._state, self._adapter.adapt(game_input))
        return self.snapshot()

    def build_scene(self) -> Scene:
        return build_scene(self._state, self._engine.config, self._assets)

    def assets(self) -> GameAssets:
        renderer = self._assets.renderer
        return GameAssets(renderer.sprite_atlas, renderer.tile_atlas, renderer.palettes)

    def snapshot(self) -> GameSnapshot:
        return build_snapshot(self._state)

    def close(self) -> None:
        pass


def create_game() -> Game:
    return Game()