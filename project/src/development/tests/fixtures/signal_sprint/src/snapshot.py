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
            "signals_remaining": len(state.coins),
            "state_sha256": game_state_hash(state),
        },
    )