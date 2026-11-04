from typing import Protocol, TypeVar

from pynq_multimodal_game.engine.side_scroller import (
    SideScrollerConfig,
    SideScrollerState,
)
from pynq_multimodal_game.scene import (
    LOGICAL_WIDTH,
    HudState,
    Scene,
    SpriteDescriptor,
)

from .assets import (
    COIN_ATLAS_X,
    ENEMY_ATLAS_X,
    ENEMY_PROJECTILE_ATLAS_X,
    OBSTACLE_ATLAS_X,
    PLAYER_ATLAS_X,
    PROJECTILE_ATLAS_X,
    SHADOW_ATLAS_X,
    SHIELD_ATLAS_X,
    Game1Assets,
)
from .level import ARENA_CENTER_Y, PLAYER_HEIGHT, PLAYER_SCREEN_X, PLAYER_WIDTH


MAX_VISIBLE_PLAYER_PROJECTILES = 3
MAX_VISIBLE_OBSTACLES = 3
MAX_VISIBLE_ENEMIES = 3
MAX_VISIBLE_ENEMY_PROJECTILES = 2
MAX_VISIBLE_COINS = 2


class WorldEntity(Protocol):
    @property
    def world_x(self) -> int: ...

    @property
    def lane_y(self) -> int: ...


EntityT = TypeVar("EntityT", bound=WorldEntity)


def build_scene(
    state: SideScrollerState,
    config: SideScrollerConfig,
    assets: Game1Assets,
) -> Scene:
    camera_max = max(0, config.level_length + PLAYER_WIDTH - LOGICAL_WIDTH)
    camera_x = min(camera_max, max(0, state.world_x - PLAYER_SCREEN_X))
    player_x = state.world_x
    ground_y = ARENA_CENTER_Y + state.lane_y - PLAYER_HEIGHT // 2
    jump_offset = min(12, state.z // 12)
    player_y = ground_y - jump_offset
    player_visible = state.invulnerability_ticks == 0 or (state.tick_id // 4) % 2 == 0
    sprites = [
        SpriteDescriptor(
            x=player_x,
            y=ground_y + 8,
            width=PLAYER_WIDTH,
            height=8,
            atlas_x=SHADOW_ATLAS_X,
            atlas_y=0,
            palette_bank=0,
            priority=2,
        ),
        SpriteDescriptor(
            x=player_x,
            y=player_y,
            width=PLAYER_WIDTH,
            height=PLAYER_HEIGHT,
            atlas_x=PLAYER_ATLAS_X[state.facing],
            atlas_y=0,
            palette_bank=0,
            priority=5,
            visible=player_visible,
        ),
    ]
    if state.shield_active:
        sprites.append(
            SpriteDescriptor(
                x=player_x,
                y=player_y,
                width=PLAYER_WIDTH,
                height=PLAYER_HEIGHT,
                atlas_x=SHIELD_ATLAS_X,
                atlas_y=0,
                palette_bank=0,
                priority=6,
            )
        )
    for obstacle in _visible_entities(
        state.obstacles, camera_x, config.obstacle_size, MAX_VISIBLE_OBSTACLES
    ):
        sprites.append(
            SpriteDescriptor(
                x=obstacle.world_x,
                y=ARENA_CENTER_Y + obstacle.lane_y - config.obstacle_size // 2,
                width=config.obstacle_size,
                height=config.obstacle_size,
                atlas_x=OBSTACLE_ATLAS_X,
                atlas_y=0,
                palette_bank=0,
                priority=3,
            )
        )
    for coin in _visible_entities(
        state.coins, camera_x, config.coin_size, MAX_VISIBLE_COINS
    ):
        sprites.append(
            SpriteDescriptor(
                x=coin.world_x,
                y=ARENA_CENTER_Y + coin.lane_y - config.coin_size // 2,
                width=config.coin_size,
                height=config.coin_size,
                atlas_x=COIN_ATLAS_X,
                atlas_y=0,
                palette_bank=0,
                priority=4,
            )
        )
    for enemy in _visible_entities(
        state.enemies, camera_x, config.enemy_size, MAX_VISIBLE_ENEMIES
    ):
        sprites.append(
            SpriteDescriptor(
                x=enemy.world_x,
                y=ARENA_CENTER_Y + enemy.lane_y - config.enemy_size // 2,
                width=config.enemy_size,
                height=config.enemy_size,
                atlas_x=ENEMY_ATLAS_X,
                atlas_y=0,
                palette_bank=0,
                priority=5,
            )
        )
    for projectile in _visible_entities(
        state.enemy_projectiles,
        camera_x,
        config.projectile_size,
        MAX_VISIBLE_ENEMY_PROJECTILES,
    ):
        sprites.append(
            SpriteDescriptor(
                x=projectile.world_x + 4,
                y=ARENA_CENTER_Y + projectile.lane_y - 4,
                width=8,
                height=8,
                atlas_x=ENEMY_PROJECTILE_ATLAS_X,
                atlas_y=0,
                palette_bank=0,
                priority=7,
            )
        )
    for projectile in _visible_entities(
        state.player_projectiles,
        camera_x,
        config.projectile_size,
        MAX_VISIBLE_PLAYER_PROJECTILES,
    ):
        sprites.append(
            SpriteDescriptor(
                x=projectile.world_x + 4,
                y=ARENA_CENTER_Y + projectile.lane_y - 4,
                width=8,
                height=8,
                atlas_x=PROJECTILE_ATLAS_X[projectile.direction],
                atlas_y=0,
                palette_bank=0,
                priority=7,
            )
        )
    return Scene(
        frame_id=state.tick_id,
        camera_x=camera_x,
        background_color=(37, 58, 94),
        sprites=tuple(sprites),
        tile_layer=assets.ground,
        hud=HudState(
            score=state.score,
            health=state.health,
            max_health=config.max_health,
            shield_energy=state.shield_energy,
            max_shield_energy=config.max_shield_energy,
            attack_cooldown=state.attack_cooldown,
            max_attack_cooldown=config.attack_cooldown_ticks,
            progress=state.world_x,
            progress_max=config.level_length,
            hand_valid=True,
            audio_valid=True,
        ),
    )


def _visible_entities(
    entities: tuple[EntityT, ...], camera_x: int, width: int, limit: int
) -> tuple[EntityT, ...]:
    viewport_right = camera_x + LOGICAL_WIDTH
    return tuple(
        entity
        for entity in entities
        if entity.world_x + width > camera_x and entity.world_x < viewport_right
    )[:limit]