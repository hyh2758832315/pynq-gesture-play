from collections.abc import Iterable

from .controls import ControlState
from .engine.side_scroller import (
    Coin,
    Enemy,
    EnemyProjectile,
    EnemySpawn,
    GameConfig,
    GameState,
    GameStatus,
    Obstacle,
    PlayerProjectile,
    SideScrollerCommand,
    SideScrollerEngine,
    game_state_hash,
)


class GameEngine(SideScrollerEngine):
    def step(self, state: GameState, control: ControlState) -> GameState:
        return super().step(state, _command(control))

    def run(self, controls: Iterable[ControlState]) -> GameState:
        state = self.initial_state()
        for control in controls:
            state = SideScrollerEngine.step(self, state, _command(control))
        return state


def _command(control: ControlState) -> SideScrollerCommand:
    return SideScrollerCommand(
        tick_id=control.tick_id,
        direction=control.direction,
        jump=control.fist_event,
        shield=control.low_voice_active,
        attack=control.high_voice_event,
    )


__all__ = [
    "Coin",
    "Enemy",
    "EnemyProjectile",
    "EnemySpawn",
    "GameConfig",
    "GameEngine",
    "GameState",
    "GameStatus",
    "Obstacle",
    "PlayerProjectile",
    "game_state_hash",
]