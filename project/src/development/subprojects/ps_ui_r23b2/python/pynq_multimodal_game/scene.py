from __future__ import annotations

from dataclasses import dataclass


LOGICAL_WIDTH = 320
LOGICAL_HEIGHT = 180
OUTPUT_SCALE = 4
MAX_SPRITES = 16
TRANSPARENT_INDEX = 0

RgbColor = tuple[int, int, int]


@dataclass(frozen=True)
class IndexedImage:
    width: int
    height: int
    pixels: bytes

    def __post_init__(self) -> None:
        if self.width <= 0 or self.height <= 0:
            raise ValueError("image dimensions must be positive")
        if len(self.pixels) != self.width * self.height:
            raise ValueError("indexed image size does not match its dimensions")
        if max(self.pixels) > 15:
            raise ValueError("indexed image pixels must fit in 4 bits")


@dataclass(frozen=True)
class PalettePack:
    banks: tuple[tuple[RgbColor, ...], ...]

    def __post_init__(self) -> None:
        if not self.banks:
            raise ValueError("at least one palette bank is required")
        for bank in self.banks:
            if len(bank) != 16:
                raise ValueError("each palette bank must contain 16 colors")
            if any(not all(0 <= channel <= 255 for channel in color) for color in bank):
                raise ValueError("palette channels must be within [0, 255]")


@dataclass(frozen=True)
class TileDescriptor:
    tile_id: int
    palette_bank: int = 0
    flip_x: bool = False
    flip_y: bool = False

    def __post_init__(self) -> None:
        if self.tile_id < 0 or self.palette_bank < 0:
            raise ValueError("tile identifiers must be non-negative")


@dataclass(frozen=True)
class TileLayer:
    width_tiles: int
    height_tiles: int
    tiles: tuple[TileDescriptor, ...]
    origin_x: int = 0
    origin_y: int = 0
    tile_size: int = 16

    def __post_init__(self) -> None:
        if self.width_tiles <= 0 or self.height_tiles <= 0 or self.tile_size <= 0:
            raise ValueError("tile layer dimensions must be positive")
        if len(self.tiles) != self.width_tiles * self.height_tiles:
            raise ValueError("tile count does not match layer dimensions")


@dataclass(frozen=True)
class SpriteDescriptor:
    x: int
    y: int
    width: int
    height: int
    atlas_x: int
    atlas_y: int
    palette_bank: int
    priority: int
    flip_x: bool = False
    flip_y: bool = False
    visible: bool = True

    def __post_init__(self) -> None:
        if self.width <= 0 or self.height <= 0:
            raise ValueError("sprite dimensions must be positive")
        if self.atlas_x < 0 or self.atlas_y < 0 or self.palette_bank < 0:
            raise ValueError("sprite atlas and palette values must be non-negative")


@dataclass(frozen=True)
class HudState:
    score: int
    health: int
    max_health: int
    shield_energy: int
    max_shield_energy: int
    attack_cooldown: int
    max_attack_cooldown: int
    progress: int
    progress_max: int
    hand_valid: bool
    audio_valid: bool

    def __post_init__(self) -> None:
        pairs = (
            (self.health, self.max_health, "health"),
            (self.shield_energy, self.max_shield_energy, "shield_energy"),
            (self.attack_cooldown, self.max_attack_cooldown, "attack_cooldown"),
            (self.progress, self.progress_max, "progress"),
        )
        if self.score < 0:
            raise ValueError("score must be non-negative")
        for value, maximum, name in pairs:
            if maximum <= 0 or not 0 <= value <= maximum:
                raise ValueError(f"{name} must be within its configured range")


@dataclass(frozen=True)
class Scene:
    frame_id: int
    camera_x: int
    background_color: RgbColor
    sprites: tuple[SpriteDescriptor, ...] = ()
    tile_layer: TileLayer | None = None
    hud: HudState | None = None

    def __post_init__(self) -> None:
        if self.frame_id < 0 or self.camera_x < 0:
            raise ValueError("frame_id and camera_x must be non-negative")
        if len(self.sprites) > MAX_SPRITES:
            raise ValueError(f"a scene supports at most {MAX_SPRITES} sprites")
        if not all(0 <= channel <= 255 for channel in self.background_color):
            raise ValueError("background channels must be within [0, 255]")
