from __future__ import annotations

import argparse
import time
import tkinter as tk
from dataclasses import dataclass
from typing import Protocol, TypeVar

from .controls import ControlSource, Direction, MockControlAdapter, MockInput
from .game import (
    Coin,
    EnemySpawn,
    GameConfig,
    GameEngine,
    GameState,
    GameStatus,
    Obstacle,
)
from .renderer import GoldenRenderer
from .scene import (
    LOGICAL_HEIGHT,
    LOGICAL_WIDTH,
    HudState,
    IndexedImage,
    PalettePack,
    Scene,
    SpriteDescriptor,
    TileDescriptor,
    TileLayer,
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
PLAYER_ATLAS_X = {
    Direction.LEFT: 0,
    Direction.RIGHT: 16,
    Direction.UP: 32,
    Direction.DOWN: 48,
}
PROJECTILE_ATLAS_X = {
    Direction.LEFT: 64,
    Direction.RIGHT: 72,
    Direction.UP: 80,
    Direction.DOWN: 88,
}
SHIELD_ATLAS_X = 96
SHADOW_ATLAS_X = 112
OBSTACLE_ATLAS_X = 128
ENEMY_ATLAS_X = 144
ENEMY_PROJECTILE_ATLAS_X = 160
COIN_ATLAS_X = 168
SPRITE_ATLAS_WIDTH = 176
MAX_VISIBLE_PLAYER_PROJECTILES = 3
MAX_VISIBLE_OBSTACLES = 3
MAX_VISIBLE_ENEMIES = 3
MAX_VISIBLE_ENEMY_PROJECTILES = 2
MAX_VISIBLE_COINS = 2

DEMO_OBSTACLES = (
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
DEMO_ENEMY_SPAWNS = (
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
DEMO_COINS = (
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


class WorldEntity(Protocol):
    @property
    def world_x(self) -> int: ...

    @property
    def lane_y(self) -> int: ...


EntityT = TypeVar("EntityT", bound=WorldEntity)


@dataclass(frozen=True)
class DemoAssets:
    renderer: GoldenRenderer
    ground: TileLayer


def create_demo_assets() -> DemoAssets:
    palette = (
        (0, 0, 0),
        (29, 41, 81),
        (67, 97, 157),
        (94, 160, 112),
        (226, 198, 111),
        (231, 111, 81),
        (117, 207, 219),
        (245, 241, 224),
        (34, 34, 54),
        (75, 55, 80),
        (141, 86, 117),
        (126, 200, 227),
        (108, 74, 54),
        (157, 110, 72),
        (193, 146, 88),
        (255, 255, 255),
    )
    sprite_pixels = bytearray(SPRITE_ATLAS_WIDTH * 16)
    for direction, atlas_x in PLAYER_ATLAS_X.items():
        _draw_player(sprite_pixels, atlas_x, direction)
    for direction, atlas_x in PROJECTILE_ATLAS_X.items():
        _draw_projectile(sprite_pixels, atlas_x, direction)
    _draw_shield(sprite_pixels)
    _draw_shadow(sprite_pixels)
    _draw_obstacle(sprite_pixels)
    _draw_enemy(sprite_pixels)
    _draw_enemy_projectile(sprite_pixels)
    _draw_coin(sprite_pixels)

    tile_pixels = bytearray(32 * 16)
    for y in range(TILE_SIZE):
        for x in range(TILE_SIZE):
            tile_pixels[y * 32 + x] = 2 if (x // 4 + y // 4) % 2 else 1
            wall_index = y * 32 + TILE_SIZE + x
            tile_pixels[wall_index] = 12 if y < 4 else 13
            if y >= 4 and (x + y) % 6 == 0:
                tile_pixels[wall_index] = 14

    arena_tiles = []
    for row in range(ARENA_ROWS):
        tile_id = 1 if row in (0, ARENA_ROWS - 1) else 0
        arena_tiles.extend(TileDescriptor(tile_id) for _ in range(ARENA_WIDTH_TILES))
    ground = TileLayer(
        width_tiles=ARENA_WIDTH_TILES,
        height_tiles=ARENA_ROWS,
        tiles=tuple(arena_tiles),
        origin_y=ARENA_ORIGIN_Y,
    )
    renderer = GoldenRenderer(
        sprite_atlas=IndexedImage(SPRITE_ATLAS_WIDTH, 16, bytes(sprite_pixels)),
        tile_atlas=IndexedImage(32, 16, bytes(tile_pixels)),
        palettes=PalettePack((palette,)),
    )
    return DemoAssets(renderer=renderer, ground=ground)


def create_demo_engine() -> GameEngine:
    config = GameConfig(
        level_length=ARENA_WIDTH - PLAYER_WIDTH,
        move_units_per_tick=4,
        min_lane_y=PLAYER_LANE_MIN,
        max_lane_y=PLAYER_LANE_MAX,
        max_player_projectiles=3,
        enemy_shoot_cooldown_ticks=45,
        enemy_initial_shoot_delay_ticks=15,
    )
    return GameEngine(
        config,
        obstacles=DEMO_OBSTACLES,
        enemy_spawns=DEMO_ENEMY_SPAWNS,
        coins=DEMO_COINS,
    )


def build_demo_scene(state: GameState, config: GameConfig, assets: DemoAssets) -> Scene:
    camera_max = max(0, config.level_length + PLAYER_WIDTH - LOGICAL_WIDTH)
    camera_x = min(camera_max, max(0, state.world_x - PLAYER_SCREEN_X))
    player_x = state.world_x
    ground_y = ARENA_CENTER_Y + state.lane_y - PLAYER_HEIGHT // 2
    jump_offset = min(12, state.z // 12)
    player_y = ground_y - jump_offset
    player_visible = (
        state.invulnerability_ticks == 0 or (state.tick_id // 4) % 2 == 0
    )
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
        )
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


def _draw_player(pixels: bytearray, atlas_x: int, direction: Direction) -> None:
    for y in range(2, 14):
        for x in range(3, 13):
            color = 5 if 5 <= x <= 10 and 5 <= y <= 12 else 4
            pixels[y * SPRITE_ATLAS_WIDTH + atlas_x + x] = color
    marker = {
        Direction.LEFT: ((2, 7), (2, 8), (3, 7), (3, 8)),
        Direction.RIGHT: ((12, 7), (12, 8), (13, 7), (13, 8)),
        Direction.UP: ((7, 1), (8, 1), (7, 2), (8, 2)),
        Direction.DOWN: ((7, 13), (8, 13), (7, 14), (8, 14)),
    }[direction]
    for x, y in marker:
        pixels[y * SPRITE_ATLAS_WIDTH + atlas_x + x] = 15


def _draw_projectile(pixels: bytearray, atlas_x: int, direction: Direction) -> None:
    if direction in (Direction.LEFT, Direction.RIGHT):
        points = ((1, 3), (2, 3), (3, 3), (4, 3), (5, 3), (6, 3), (2, 4), (5, 4))
    else:
        points = ((3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6), (4, 2), (4, 5))
    for x, y in points:
        pixels[y * SPRITE_ATLAS_WIDTH + atlas_x + x] = 6


def _draw_shield(pixels: bytearray) -> None:
    for y in range(16):
        for x in range(16):
            if x in (0, 15) or y in (0, 15):
                pixels[y * SPRITE_ATLAS_WIDTH + SHIELD_ATLAS_X + x] = 6


def _draw_shadow(pixels: bytearray) -> None:
    for y in range(2, 7):
        for x in range(3, 13):
            if (x - 8) * (x - 8) + (y - 4) * (y - 4) <= 28:
                pixels[y * SPRITE_ATLAS_WIDTH + SHADOW_ATLAS_X + x] = 8


def _draw_obstacle(pixels: bytearray) -> None:
    for y in range(16):
        for x in range(16):
            color = 12 if y < 4 or x in (0, 15) else 13
            if 3 < y < 13 and (x + y) % 5 == 0:
                color = 14
            pixels[y * SPRITE_ATLAS_WIDTH + OBSTACLE_ATLAS_X + x] = color


def _draw_enemy(pixels: bytearray) -> None:
    for y in range(2, 14):
        for x in range(2, 14):
            color = 10 if 4 <= x <= 11 and 4 <= y <= 11 else 9
            pixels[y * SPRITE_ATLAS_WIDTH + ENEMY_ATLAS_X + x] = color
    pixels[6 * SPRITE_ATLAS_WIDTH + ENEMY_ATLAS_X + 3] = 15
    pixels[9 * SPRITE_ATLAS_WIDTH + ENEMY_ATLAS_X + 3] = 15


def _draw_enemy_projectile(pixels: bytearray) -> None:
    for y in range(2, 6):
        for x in range(1, 7):
            pixels[
                y * SPRITE_ATLAS_WIDTH + ENEMY_PROJECTILE_ATLAS_X + x
            ] = 5


def _draw_coin(pixels: bytearray) -> None:
    for y in range(1, 7):
        for x in range(1, 7):
            color = 4 if x in (1, 6) or y in (1, 6) else 15
            pixels[y * SPRITE_ATLAS_WIDTH + COIN_ATLAS_X + x] = color


class PcDemo:
    def __init__(self) -> None:
        self.engine = create_demo_engine()
        self.config = self.engine.config
        self.state = self.engine.initial_state()
        self.assets = create_demo_assets()
        self.adapter = MockControlAdapter(ControlSource.KEYBOARD)
        self.pressed: set[str] = set()
        self.root = tk.Tk()
        self.root.title("PYNQ Multimodal Game C1 Demo")
        self.canvas = tk.Label(self.root, borderwidth=0)
        self.canvas.pack()
        self.status = tk.StringVar(value="Top-down: WASD/Arrows move | Space jump | Q shield | E fire")
        tk.Label(self.root, textvariable=self.status, anchor="w").pack(fill="x", padx=8, pady=6)
        self.root.bind("<KeyPress>", self._key_down)
        self.root.bind("<KeyRelease>", self._key_up)
        self.root.bind("<Escape>", lambda _: self.root.destroy())
        self.image: tk.PhotoImage | None = None

    def run(self) -> None:
        self._tick()
        self.root.mainloop()

    def _key_down(self, event: tk.Event) -> None:
        self.pressed.add(event.keysym.lower())

    def _key_up(self, event: tk.Event) -> None:
        self.pressed.discard(event.keysym.lower())

    def _tick(self) -> None:
        if self.state.status is GameStatus.RUNNING:
            tick_id = self.state.tick_id + 1
            self.adapter.set_input(self._input_state())
            control = self.adapter.read(tick_id=tick_id, timestamp_ns=time.monotonic_ns())
            self.state = self.engine.step(self.state, control)
        self._draw()
        self.root.after(1000 // self.config.ticks_per_second, self._tick)

    def _input_state(self) -> MockInput:
        return MockInput(
            left="a" in self.pressed or "left" in self.pressed,
            right="d" in self.pressed or "right" in self.pressed,
            up="w" in self.pressed or "up" in self.pressed,
            down="s" in self.pressed or "down" in self.pressed,
            jump="space" in self.pressed,
            shield="q" in self.pressed,
            attack="e" in self.pressed,
        )

    def _draw(self) -> None:
        scene = build_demo_scene(self.state, self.config, self.assets)
        frame = self.assets.renderer.render(scene)
        ppm = b"P6\n%d %d\n255\n" % (LOGICAL_WIDTH, LOGICAL_HEIGHT) + frame
        image = tk.PhotoImage(data=ppm, format="PPM").zoom(4, 4)
        self.canvas.configure(image=image)
        self.image = image
        if self.state.status is GameStatus.WON:
            self.status.set(
                f"Goal reached | Score {self.state.score} | "
                f"HP {self.state.health}/{self.config.max_health} | Press Esc to close"
            )
        elif self.state.status is GameStatus.LOST:
            self.status.set(
                f"Defeated | Score {self.state.score} | Press Esc to close"
            )
        else:
            self.status.set(
                f"Score {self.state.score} | "
                f"HP {self.state.health}/{self.config.max_health} | "
                f"Enemies {len(self.state.enemies)} | Coins {len(self.state.coins)} | "
                "Space jump | Q shield | E fire"
            )


def main() -> None:
    parser = argparse.ArgumentParser(description="Run the C1 keyboard and renderer demo.")
    parser.parse_args()
    PcDemo().run()


if __name__ == "__main__":
    main()