from __future__ import annotations

import binascii

from .scene import (
    LOGICAL_HEIGHT,
    LOGICAL_WIDTH,
    OUTPUT_SCALE,
    TRANSPARENT_INDEX,
    IndexedImage,
    PalettePack,
    RgbColor,
    Scene,
    SpriteDescriptor,
    TileDescriptor,
)

HUD_GLYPHS = {
    "U": ("101", "101", "101", "101", "111"),
    "T": ("111", "010", "010", "010", "010"),
    "H": ("101", "101", "111", "101", "101"),
    "P": ("110", "101", "110", "100", "100"),
    "0": ("111", "101", "101", "101", "111"),
    "1": ("010", "110", "010", "010", "111"),
    "2": ("111", "001", "111", "100", "111"),
    "3": ("111", "001", "111", "001", "111"),
    "4": ("101", "101", "111", "001", "001"),
    "5": ("111", "100", "111", "001", "111"),
    "6": ("111", "100", "111", "101", "111"),
    "7": ("111", "001", "010", "010", "010"),
    "8": ("111", "101", "111", "101", "111"),
    "9": ("111", "101", "111", "001", "111"),
    "S": ("111", "100", "111", "001", "111"),
    "C": ("111", "100", "100", "100", "111"),
    "O": ("111", "101", "101", "101", "111"),
    "R": ("110", "101", "110", "101", "101"),
    "E": ("111", "100", "110", "100", "111"),
}


class GoldenRenderer:
    def __init__(
        self,
        *,
        sprite_atlas: IndexedImage,
        tile_atlas: IndexedImage,
        palettes: PalettePack,
    ) -> None:
        self.sprite_atlas = sprite_atlas
        self.tile_atlas = tile_atlas
        self.palettes = palettes

    def render(self, scene: Scene) -> bytes:
        frame = bytearray(scene.background_color * (LOGICAL_WIDTH * LOGICAL_HEIGHT))
        if scene.tile_layer is not None:
            self._draw_tiles(frame, scene)
        for sprite in sorted(scene.sprites, key=lambda item: item.priority):
            if sprite.visible:
                self._draw_sprite(frame, sprite, scene.camera_x)
        if scene.hud is not None:
            self._draw_hud(frame, scene)
        return bytes(frame)

    @staticmethod
    def scale_to_720p(frame: bytes) -> bytes:
        expected = LOGICAL_WIDTH * LOGICAL_HEIGHT * 3
        if len(frame) != expected:
            raise ValueError("logical frame has an unexpected size")
        output = bytearray()
        row_size = LOGICAL_WIDTH * 3
        for row_start in range(0, len(frame), row_size):
            row = frame[row_start : row_start + row_size]
            expanded = bytearray()
            for pixel_start in range(0, row_size, 3):
                expanded.extend(row[pixel_start : pixel_start + 3] * OUTPUT_SCALE)
            output.extend(expanded * OUTPUT_SCALE)
        return bytes(output)

    @staticmethod
    def crc32(frame: bytes) -> int:
        return binascii.crc32(frame) & 0xFFFFFFFF

    def _draw_tiles(self, frame: bytearray, scene: Scene) -> None:
        layer = scene.tile_layer
        if layer is None:
            return
        tiles_per_atlas_row = self.tile_atlas.width // layer.tile_size
        if tiles_per_atlas_row == 0:
            raise ValueError("tile atlas is narrower than the configured tile size")
        for index, tile in enumerate(layer.tiles):
            tile_x = index % layer.width_tiles
            tile_y = index // layer.width_tiles
            screen_x = layer.origin_x + tile_x * layer.tile_size - scene.camera_x
            screen_y = layer.origin_y + tile_y * layer.tile_size
            source_x = (tile.tile_id % tiles_per_atlas_row) * layer.tile_size
            source_y = (tile.tile_id // tiles_per_atlas_row) * layer.tile_size
            self._draw_indexed_region(
                frame,
                self.tile_atlas,
                tile,
                screen_x=screen_x,
                screen_y=screen_y,
                source_x=source_x,
                source_y=source_y,
                width=layer.tile_size,
                height=layer.tile_size,
            )

    def _draw_sprite(
        self, frame: bytearray, sprite: SpriteDescriptor, camera_x: int
    ) -> None:
        self._draw_indexed_region(
            frame,
            self.sprite_atlas,
            sprite,
            screen_x=sprite.x - camera_x,
            screen_y=sprite.y,
            source_x=sprite.atlas_x,
            source_y=sprite.atlas_y,
            width=sprite.width,
            height=sprite.height,
        )

    def _draw_indexed_region(
        self,
        frame: bytearray,
        atlas: IndexedImage,
        descriptor: SpriteDescriptor | TileDescriptor,
        *,
        screen_x: int,
        screen_y: int,
        source_x: int,
        source_y: int,
        width: int,
        height: int,
    ) -> None:
        if source_x + width > atlas.width or source_y + height > atlas.height:
            raise ValueError("descriptor extends outside its atlas")
        if descriptor.palette_bank >= len(self.palettes.banks):
            raise ValueError("descriptor references an unknown palette bank")
        palette = self.palettes.banks[descriptor.palette_bank]
        for output_y in range(max(0, screen_y), min(LOGICAL_HEIGHT, screen_y + height)):
            local_y = output_y - screen_y
            if descriptor.flip_y:
                local_y = height - 1 - local_y
            for output_x in range(max(0, screen_x), min(LOGICAL_WIDTH, screen_x + width)):
                local_x = output_x - screen_x
                if descriptor.flip_x:
                    local_x = width - 1 - local_x
                color_index = atlas.pixels[(source_y + local_y) * atlas.width + source_x + local_x]
                if color_index == TRANSPARENT_INDEX:
                    continue
                self._set_pixel(frame, output_x, output_y, palette[color_index])

    def _draw_hud(self, frame: bytearray, scene: Scene) -> None:
        hud = scene.hud
        if hud is None:
            return
        if hud.max_health == 5:
            self._fill_rect(frame,0,0,LOGICAL_WIDTH,10,(18,22,28))
            self._draw_text(frame,30,2,'ROUTE',(245,241,224))
            self._draw_bar(frame,54,3,92,hud.progress,hud.progress_max,(111,205,102))
            self._draw_text(frame,158,2,'HP',(245,241,224))
            for index in range(hud.max_health):
                self._fill_rect(frame,170+index*7,3,5,4,
                    (224,67,67) if index<hud.health else (70,45,48))
            self._draw_text(frame,218,2,f'SCORE {min(hud.score,999999)}',(245,241,224))
            return
        self._fill_rect(frame, 0, 0, LOGICAL_WIDTH, 10, (18, 22, 28))
        for index in range(hud.max_health):
            color = (224, 67, 67) if index < hud.health else (70, 45, 48)
            self._fill_rect(frame, (278 if hud.max_health == 5 else 4) + index * 7, 3, 5, 4, color)
        self._draw_bar(frame, 40, 3, 48, hud.shield_energy, hud.max_shield_energy, (38, 196, 214))
        cooldown_ready = hud.max_attack_cooldown - hud.attack_cooldown
        self._draw_bar(frame, 94, 3, 32, cooldown_ready, hud.max_attack_cooldown, (246, 185, 59))
        self._draw_bar(frame, 140, 3, 80, hud.progress, hud.progress_max, (111, 205, 102))
        self._fill_rect(frame, 226, 3, 5, 4, (86, 211, 100) if hud.hand_valid else (86, 90, 96))
        self._fill_rect(frame, 234, 3, 5, 4, (86, 211, 100) if hud.audio_valid else (86, 90, 96))
        self._draw_text(frame, 246, 13 if hud.max_health == 5 else 2, f"SCORE {hud.score}", (245, 241, 224))

    def _draw_text(
        self,
        frame: bytearray,
        x: int,
        y: int,
        text: str,
        color: RgbColor,
    ) -> None:
        for character_index, character in enumerate(text):
            glyph = HUD_GLYPHS.get(character)
            if glyph is None:
                continue
            glyph_x = x + character_index * 4
            for row, pixels in enumerate(glyph):
                for column, enabled in enumerate(pixels):
                    if enabled == "1":
                        self._fill_rect(frame, glyph_x + column, y + row, 1, 1, color)

    def _draw_bar(
        self,
        frame: bytearray,
        x: int,
        y: int,
        width: int,
        value: int,
        maximum: int,
        color: RgbColor,
    ) -> None:
        self._fill_rect(frame, x, y, width, 4, (56, 61, 68))
        filled = width * value // maximum
        self._fill_rect(frame, x, y, filled, 4, color)

    def _fill_rect(
        self,
        frame: bytearray,
        x: int,
        y: int,
        width: int,
        height: int,
        color: RgbColor,
    ) -> None:
        for output_y in range(max(0, y), min(LOGICAL_HEIGHT, y + height)):
            for output_x in range(max(0, x), min(LOGICAL_WIDTH, x + width)):
                self._set_pixel(frame, output_x, output_y, color)

    @staticmethod
    def _set_pixel(frame: bytearray, x: int, y: int, color: RgbColor) -> None:
        offset = (y * LOGICAL_WIDTH + x) * 3
        frame[offset : offset + 3] = bytes(color)