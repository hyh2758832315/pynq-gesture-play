from pynq_multimodal_game.engine.side_scroller import (
    SideScrollerState,
    game_state_hash,
)
from pynq_multimodal_game.game_sdk import GameSnapshot


def build_snapshot(state: SideScrollerState) -> GameSnapshot:
    return GameSnapshot(
        tick_id=max(0, state.tick_id),
        status=state.status.value,
        score=state.score,
        values={
            "world_x": state.world_x,
            "lane_y": state.lane_y,
            "z": state.z,
            "health": state.health,
            "shield_energy": state.shield_energy,
            "shield_active": state.shield_active,
            "attacks_fired": state.attacks_fired,
            "facing": state.facing.name,
            "state_sha256": game_state_hash(state),
        },
    )