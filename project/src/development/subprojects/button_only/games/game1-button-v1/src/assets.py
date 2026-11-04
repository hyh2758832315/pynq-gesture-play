from dataclasses import dataclass

from pynq_multimodal_game.controls import Direction
from pynq_multimodal_game.renderer import GoldenRenderer
from pynq_multimodal_game.scene import (
    IndexedImage,
    PalettePack,
    TileDescriptor,
    TileLayer,
)

from .level import ARENA_ORIGIN_Y, ARENA_ROWS, ARENA_WIDTH_TILES, TILE_SIZE


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


@dataclass(frozen=True)
class Game1Assets:
    renderer: GoldenRenderer
    ground: TileLayer


def create_assets() -> Game1Assets:
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
    return Game1Assets(renderer=renderer, ground=ground)


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
            pixels[y * SPRITE_ATLAS_WIDTH + ENEMY_PROJECTILE_ATLAS_X + x] = 5


def _draw_coin(pixels: bytearray) -> None:
    for y in range(1, 7):
        for x in range(1, 7):
            color = 4 if x in (1, 6) or y in (1, 6) else 15
            pixels[y * SPRITE_ATLAS_WIDTH + COIN_ATLAS_X + x] = color