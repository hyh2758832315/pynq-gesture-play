from pynq_multimodal_game.engine.side_scroller import (
    Coin,
    EnemySpawn,
    Obstacle,
    SideScrollerConfig,
    SideScrollerEngine,
)


PLAYER_WIDTH = 16
PLAYER_HEIGHT = 16
PLAYER_SCREEN_X = 112
ARENA_ORIGIN_Y = 10
ARENA_CENTER_Y = 90
ARENA_ROWS = 11
ARENA_WIDTH_TILES = 64
TILE_SIZE = 16
ARENA_WIDTH = ARENA_WIDTH_TILES * TILE_SIZE
PLAYER_LANE_MIN = ARENA_ORIGIN_Y + TILE_SIZE - (ARENA_CENTER_Y - PLAYER_HEIGHT // 2)
PLAYER_LANE_MAX = (
    ARENA_ORIGIN_Y
    + (ARENA_ROWS - 1) * TILE_SIZE
    - PLAYER_HEIGHT
    - (ARENA_CENTER_Y - PLAYER_HEIGHT // 2)
)
LANE_COUNT = 5
LANE_STEP = (PLAYER_LANE_MAX - PLAYER_LANE_MIN) // (LANE_COUNT - 1)
LANE_POSITIONS = tuple(
    PLAYER_LANE_MIN + index * LANE_STEP for index in range(LANE_COUNT)
)

OBSTACLES = (
    Obstacle(160, LANE_POSITIONS[1]),
    Obstacle(260, LANE_POSITIONS[3]),
    Obstacle(360, LANE_POSITIONS[0]),
    Obstacle(460, LANE_POSITIONS[4]),
    Obstacle(560, LANE_POSITIONS[2]),
    Obstacle(660, LANE_POSITIONS[0]),
    Obstacle(760, LANE_POSITIONS[3]),
    Obstacle(860, LANE_POSITIONS[1]),
    Obstacle(960, LANE_POSITIONS[4]),
)
ENEMY_SPAWNS = (
    EnemySpawn(0, LANE_POSITIONS[2]),
    EnemySpawn(90, LANE_POSITIONS[4]),
    EnemySpawn(180, LANE_POSITIONS[0]),
    EnemySpawn(270, LANE_POSITIONS[3]),
    EnemySpawn(360, LANE_POSITIONS[1]),
    EnemySpawn(450, LANE_POSITIONS[4]),
    EnemySpawn(540, LANE_POSITIONS[2]),
    EnemySpawn(630, LANE_POSITIONS[0]),
    EnemySpawn(720, LANE_POSITIONS[3]),
    EnemySpawn(810, LANE_POSITIONS[1]),
    EnemySpawn(900, LANE_POSITIONS[4]),
)
COINS = (
    Coin(80, LANE_POSITIONS[0]),
    Coin(140, LANE_POSITIONS[2]),
    Coin(220, LANE_POSITIONS[4]),
    Coin(300, LANE_POSITIONS[1]),
    Coin(380, LANE_POSITIONS[3]),
    Coin(460, LANE_POSITIONS[0]),
    Coin(540, LANE_POSITIONS[4]),
    Coin(620, LANE_POSITIONS[2]),
    Coin(700, LANE_POSITIONS[1]),
    Coin(780, LANE_POSITIONS[3]),
    Coin(860, LANE_POSITIONS[0]),
    Coin(940, LANE_POSITIONS[4]),
)


def create_engine() -> SideScrollerEngine:
    config = SideScrollerConfig(
        level_length=ARENA_WIDTH - PLAYER_WIDTH,
        move_units_per_tick=4,
        min_lane_y=PLAYER_LANE_MIN,
        max_lane_y=PLAYER_LANE_MAX,
        max_player_projectiles=3,
        enemy_shoot_cooldown_ticks=45,
        enemy_initial_shoot_delay_ticks=15,
    )
    return SideScrollerEngine(
        config,
        obstacles=OBSTACLES,
        enemy_spawns=ENEMY_SPAWNS,
        coins=COINS,
    )