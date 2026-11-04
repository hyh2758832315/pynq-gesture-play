from pynq_multimodal_game.engine.side_scroller import (
    Coin,
    Obstacle,
    SideScrollerConfig,
    SideScrollerEngine,
)


OBSTACLES = (
    Obstacle(96, 32),
    Obstacle(180, -32),
    Obstacle(264, 32),
)
SIGNALS = (
    Coin(80, 0),
    Coin(160, 0),
    Coin(240, 0),
)


def create_engine() -> SideScrollerEngine:
    config = SideScrollerConfig(
        level_length=304,
        move_units_per_tick=4,
        min_lane_y=-48,
        max_lane_y=48,
        player_size=8,
        obstacle_size=8,
        coin_size=8,
        max_player_projectiles=3,
    )
    return SideScrollerEngine(config, obstacles=OBSTACLES, coins=SIGNALS)