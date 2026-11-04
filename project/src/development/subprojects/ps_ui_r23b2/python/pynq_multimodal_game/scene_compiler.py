from __future__ import annotations

from dataclasses import dataclass

from .gpu_abi import COMMAND_CAPACITY, TILEMAP_TILE_CAPACITY, GpuCommand, Opcode, SceneHeader
from .renderer import HUD_GLYPHS
from .scene import (
    LOGICAL_HEIGHT,
    LOGICAL_WIDTH,
    HudState,
    IndexedImage,
    PalettePack,
    RgbColor,
    Scene,
    TileLayer,
)


SPRITE_ASSET_ID = 0
TILE_ASSET_ID = 1
FONT_ASSET_ID = 2
SYSTEM_PALETTE_BANK = 15

SYSTEM_COLORS: tuple[RgbColor, ...] = (
    (0, 0, 0),
    (18, 22, 28),
    (224, 67, 67),
    (70, 45, 48),
    (56, 61, 68),
    (38, 196, 214),
    (246, 185, 59),
    (111, 205, 102),
    (86, 211, 100),
    (86, 90, 96),
    (245, 241, 224),
    (0, 0, 0),
    (0, 0, 0),
    (0, 0, 0),
    (0, 0, 0),
    (0, 0, 0),
)

HUD_BACKGROUND = 1
HEALTH_ACTIVE = 2
HEALTH_INACTIVE = 3
BAR_BACKGROUND = 4
SHIELD_ACTIVE = 5
COOLDOWN_ACTIVE = 6
PROGRESS_ACTIVE = 7
INPUT_ACTIVE = 8
INPUT_INACTIVE = 9
TEXT_ACTIVE = 10


def _system_token(color_index: int) -> int:
    return (SYSTEM_PALETTE_BANK << 4) | color_index


def _signed16(value: int) -> int:
    return value - 0x10000 if value & 0x8000 else value


def _signed32(value: int) -> int:
    return value - 0x100000000 if value & 0x80000000 else value


def _pair(word: int) -> tuple[int, int]:
    return word & 0xFFFF, (word >> 16) & 0xFFFF


def _font_asset() -> tuple[IndexedImage, dict[str, int]]:
    characters = tuple(HUD_GLYPHS)
    offsets = {character: index * 3 for index, character in enumerate(characters)}
    width = len(characters) * 3
    pixels = bytearray(width * 5)
    for character, glyph_x in offsets.items():
        for y, row in enumerate(HUD_GLYPHS[character]):
            for x, enabled in enumerate(row):
                if enabled == "1":
                    pixels[y * width + glyph_x + x] = TEXT_ACTIVE
    return IndexedImage(width, 5, bytes(pixels)), offsets


@dataclass(frozen=True)
class CompiledFrame:
    header: SceneHeader
    commands: tuple[GpuCommand, ...]
    assets: tuple[IndexedImage, ...]
    tilemaps: tuple[TileLayer, ...]
    palette_banks: tuple[tuple[RgbColor, ...], ...]


class SceneCompiler:
    def __init__(
        self,
        *,
        sprite_atlas: IndexedImage,
        tile_atlas: IndexedImage,
        palettes: PalettePack,
    ) -> None:
        if len(palettes.banks) >= SYSTEM_PALETTE_BANK:
            raise ValueError("at most 15 game palette banks are supported")
        font_asset, font_offsets = _font_asset()
        self.assets = (sprite_atlas, tile_atlas, font_asset)
        self.palettes = palettes
        self.font_offsets = font_offsets
        self._hud_key = None
        self._hud_commands = ()
        self._tile_window_source = None
        self._tile_window_bounds = None
        self._tile_window = None

    def compile(
        self,
        scene: Scene,
        *,
        submit_seq: int | None = None,
        palette_generation: int = 0,
        asset_generation: int = 0,
        tilemap_generation: int = 0,
    ) -> CompiledFrame:
        commands = [GpuCommand.clear()]
        tilemaps: tuple[TileLayer, ...] = ()
        if scene.tile_layer is not None:
            layer = scene.tile_layer
            screen_x = layer.origin_x - scene.camera_x
            if self._visible(
                screen_x,
                layer.origin_y,
                layer.width_tiles * layer.tile_size,
                layer.height_tiles * layer.tile_size,
            ):
                layer = self._bounded_tile_window(layer, scene.camera_x)
                screen_x = layer.origin_x - scene.camera_x
                tilemaps = (layer,)
                commands.append(
                    GpuCommand.draw_tile_layer(
                        asset_id=TILE_ASSET_ID,
                        tilemap_id=0,
                        screen_x=screen_x,
                        screen_y=layer.origin_y,
                        width_tiles=layer.width_tiles,
                        height_tiles=layer.height_tiles,
                        tile_size=layer.tile_size,
                    )
                )
        for sprite in sorted(scene.sprites, key=lambda item: item.priority):
            screen_x = sprite.x - scene.camera_x
            if not sprite.visible or not self._visible(
                screen_x, sprite.y, sprite.width, sprite.height
            ):
                continue
            commands.append(
                GpuCommand.blit_index4(
                    asset_id=SPRITE_ASSET_ID,
                    palette_bank=sprite.palette_bank,
                    dst_x=screen_x,
                    dst_y=sprite.y,
                    width=sprite.width,
                    height=sprite.height,
                    src_x=sprite.atlas_x,
                    src_y=sprite.atlas_y,
                    flip_x=sprite.flip_x,
                    flip_y=sprite.flip_y,
                )
            )
        if scene.hud is not None:
            font_offsets = tuple(self.font_offsets.items())
            hud_key = (scene.hud, font_offsets)
            immutable_hud = type(scene.hud) is HudState and all(
                type(value) in (int, bool) for value in vars(scene.hud).values()
            ) and all(type(character) is str and type(offset) is int for character, offset in font_offsets)
            if not immutable_hud or self._hud_key != hud_key:
                hud_commands = []
                self._compile_hud(hud_commands, scene.hud)
                self._hud_commands = tuple(hud_commands)
                self._hud_key = hud_key if immutable_hud else None
            commands.extend(self._hud_commands)
        commands.append(GpuCommand.end_frame())
        if len(commands) > COMMAND_CAPACITY:
            raise ValueError("compiled scene exceeds the command bank capacity")
        command_tuple = tuple(commands)
        header = SceneHeader(
            frame_id=scene.frame_id,
            submit_seq=scene.frame_id if submit_seq is None else submit_seq,
            command_count=len(command_tuple),
            camera_x=scene.camera_x,
            camera_y=0,
            background_color=scene.background_color,
            palette_generation=palette_generation,
            asset_generation=asset_generation,
            tilemap_generation=tilemap_generation,
            predicted_cycles=self._predict_cycles(command_tuple),
        )
        return CompiledFrame(
            header=header,
            commands=command_tuple,
            assets=self.assets,
            tilemaps=tilemaps,
            palette_banks=self._frame_palettes(scene.background_color),
        )

    def _bounded_tile_window(self, layer: TileLayer, camera_x: int) -> TileLayer:
        if len(layer.tiles) <= TILEMAP_TILE_CAPACITY:
            return layer
        # Keep full world geometry in the game. Only the visible map and an
        # eight-tile scroll margin occupy the fixed 4096-byte hardware slot.
        # Bucketed origins reuse one immutable window across camera movement.
        size = layer.tile_size
        left = max(0, (camera_x - layer.origin_x) // size) // 8 * 8
        top = max(0, -layer.origin_y // size) // 8 * 8
        right = min(layer.width_tiles, left + (LOGICAL_WIDTH + size - 1) // size + 8)
        bottom = min(layer.height_tiles, top + (LOGICAL_HEIGHT + size - 1) // size + 8)
        width, height = right - left, bottom - top
        if width * height > TILEMAP_TILE_CAPACITY:
            raise ValueError("visible tilemap window exceeds the hardware slot capacity")
        bounds = (left, top, right, bottom)
        immutable = type(layer.tiles) is tuple
        if immutable and self._tile_window_source is layer and self._tile_window_bounds == bounds:
            return self._tile_window
        window = TileLayer(width, height, tuple(
            tile for row in range(top, bottom)
            for tile in layer.tiles[row * layer.width_tiles + left:row * layer.width_tiles + right]
        ), origin_x=layer.origin_x + left * size, origin_y=layer.origin_y + top * size,
            tile_size=size)
        self._tile_window_source = layer if immutable else None
        self._tile_window_bounds = bounds
        self._tile_window = window
        return window

    @staticmethod
    def _visible(x: int, y: int, width: int, height: int) -> bool:
        return x < LOGICAL_WIDTH and y < LOGICAL_HEIGHT and x + width > 0 and y + height > 0

    def _frame_palettes(
        self, background_color: RgbColor
    ) -> tuple[tuple[RgbColor, ...], ...]:
        banks = [list(bank) for bank in self.palettes.banks]
        banks[0][0] = background_color
        while len(banks) < SYSTEM_PALETTE_BANK:
            banks.append([(0, 0, 0)] * 16)
        banks.append(list(SYSTEM_COLORS))
        return tuple(tuple(bank) for bank in banks)

    def _compile_hud(self, commands: list[GpuCommand], hud: HudState) -> None:
        if hud.max_health == 5:
            self._fill(commands,0,0,LOGICAL_WIDTH,10,HUD_BACKGROUND)
            self._bar(commands,x=54,width=92,value=hud.progress,
                      maximum=hud.progress_max,color=PROGRESS_ACTIVE)
            for index in range(hud.max_health):
                self._fill(commands,170+index*7,3,5,4,
                           HEALTH_ACTIVE if index<hud.health else HEALTH_INACTIVE)
            for x,label in ((30,'ROUTE'),(158,'HP'),(218,f'SCORE {min(hud.score,999999)}')):
                for index,character in enumerate(label):
                    if character in self.font_offsets:
                        commands.append(GpuCommand.blit_index4(asset_id=FONT_ASSET_ID,
                            palette_bank=SYSTEM_PALETTE_BANK,dst_x=x+index*4,dst_y=2,
                            width=3,height=5,src_x=self.font_offsets[character],src_y=0))
            return
        self._fill(commands, 0, 0, LOGICAL_WIDTH, 10, HUD_BACKGROUND)
        for index in range(hud.max_health):
            color = HEALTH_ACTIVE if index < hud.health else HEALTH_INACTIVE
            self._fill(commands, (278 if hud.max_health == 5 else 4) + index * 7, 3, 5, 4, color)
        self._bar(
            commands,
            x=40,
            width=48,
            value=hud.shield_energy,
            maximum=hud.max_shield_energy,
            color=SHIELD_ACTIVE,
        )
        self._bar(
            commands,
            x=94,
            width=32,
            value=hud.max_attack_cooldown - hud.attack_cooldown,
            maximum=hud.max_attack_cooldown,
            color=COOLDOWN_ACTIVE,
        )
        self._bar(
            commands,
            x=140,
            width=80,
            value=hud.progress,
            maximum=hud.progress_max,
            color=PROGRESS_ACTIVE,
        )
        self._fill(
            commands, 226, 3, 5, 4, INPUT_ACTIVE if hud.hand_valid else INPUT_INACTIVE
        )
        self._fill(
            commands, 234, 3, 5, 4, INPUT_ACTIVE if hud.audio_valid else INPUT_INACTIVE
        )
        for index, character in enumerate(f"SCORE {hud.score}"):
            if character not in self.font_offsets:
                continue
            commands.append(
                GpuCommand.blit_index4(
                    asset_id=FONT_ASSET_ID,
                    palette_bank=SYSTEM_PALETTE_BANK,
                    dst_x=246 + index * 4,
                    dst_y=13 if hud.max_health == 5 else 2,
                    width=3,
                    height=5,
                    src_x=self.font_offsets[character],
                    src_y=0,
                )
            )

    @staticmethod
    def _fill(
        commands: list[GpuCommand],
        x: int,
        y: int,
        width: int,
        height: int,
        color_index: int,
    ) -> None:
        if width <= 0 or height <= 0:
            return
        commands.append(
            GpuCommand.fill_rect(
                x=x,
                y=y,
                width=width,
                height=height,
                token=_system_token(color_index),
            )
        )

    def _bar(
        self,
        commands: list[GpuCommand],
        *,
        x: int,
        width: int,
        value: int,
        maximum: int,
        color: int,
    ) -> None:
        self._fill(commands, x, 3, width, 4, BAR_BACKGROUND)
        self._fill(commands, x, 3, width * value // maximum, 4, color)

    @staticmethod
    def _predict_cycles(commands: tuple[GpuCommand, ...]) -> int:
        cycles = len(commands) * 8
        for command in commands:
            if command.opcode in (Opcode.CLEAR, Opcode.DRAW_TILE_LAYER):
                cycles += LOGICAL_WIDTH * LOGICAL_HEIGHT
            elif command.opcode in (Opcode.BLIT_INDEX4, Opcode.FILL_RECT):
                width, height = _pair(command.words[3])
                cycles += width * height
        return cycles


class CommandRenderer:
    def render(self, frame: CompiledFrame) -> bytes:
        tokens = self.render_tokens(frame)
        output = bytearray()
        for token in tokens:
            output.extend(frame.palette_banks[token >> 4][token & 0x0F])
        return bytes(output)

    def render_tokens(self, frame: CompiledFrame) -> bytes:
        tokens = bytearray(LOGICAL_WIDTH * LOGICAL_HEIGHT)
        for command in frame.commands:
            if command.opcode == Opcode.CLEAR:
                tokens[:] = bytes((command.words[1] & 0xFF,)) * len(tokens)
            elif command.opcode == Opcode.FILL_RECT:
                self._fill(tokens, command)
            elif command.opcode == Opcode.BLIT_INDEX4:
                self._blit(tokens, frame, command)
            elif command.opcode == Opcode.DRAW_TILE_LAYER:
                self._draw_tile_layer(tokens, frame, command)
            elif command.opcode == Opcode.END_FRAME:
                break
        return bytes(tokens)

    @staticmethod
    def _fill(tokens: bytearray, command: GpuCommand) -> None:
        x_raw, y_raw = _pair(command.words[2])
        width, height = _pair(command.words[3])
        x = _signed16(x_raw)
        y = _signed16(y_raw)
        token = command.words[1] & 0xFF
        for output_y in range(max(0, y), min(LOGICAL_HEIGHT, y + height)):
            start = output_y * LOGICAL_WIDTH + max(0, x)
            end = output_y * LOGICAL_WIDTH + min(LOGICAL_WIDTH, x + width)
            tokens[start:end] = bytes((token,)) * (end - start)

    @staticmethod
    def _blit(
        tokens: bytearray, frame: CompiledFrame, command: GpuCommand
    ) -> None:
        asset_id = command.words[1] & 0xFFFF
        palette_bank = (command.words[1] >> 16) & 0x0F
        asset = frame.assets[asset_id]
        dst_x_raw, dst_y_raw = _pair(command.words[2])
        dst_x = _signed16(dst_x_raw)
        dst_y = _signed16(dst_y_raw)
        width, height = _pair(command.words[3])
        src_x, src_y = _pair(command.words[4])
        if src_x + width > asset.width or src_y + height > asset.height:
            raise ValueError("blit command extends outside its asset")
        flip_x = bool(command.flags & 1)
        flip_y = bool(command.flags & 2)
        for output_y in range(max(0, dst_y), min(LOGICAL_HEIGHT, dst_y + height)):
            local_y = output_y - dst_y
            if flip_y:
                local_y = height - 1 - local_y
            for output_x in range(max(0, dst_x), min(LOGICAL_WIDTH, dst_x + width)):
                local_x = output_x - dst_x
                if flip_x:
                    local_x = width - 1 - local_x
                color_index = asset.pixels[(src_y + local_y) * asset.width + src_x + local_x]
                if color_index:
                    tokens[output_y * LOGICAL_WIDTH + output_x] = (
                        palette_bank << 4
                    ) | color_index

    @staticmethod
    def _draw_tile_layer(
        tokens: bytearray, frame: CompiledFrame, command: GpuCommand
    ) -> None:
        asset_id = command.words[1] & 0xFFFF
        tilemap_id = (command.words[1] >> 16) & 0xFFFF
        asset = frame.assets[asset_id]
        layer = frame.tilemaps[tilemap_id]
        screen_x = _signed32(command.words[2])
        screen_y = _signed32(command.words[3])
        width_tiles, height_tiles = _pair(command.words[4])
        tile_size = command.words[5] & 0xFFFF
        if (
            width_tiles != layer.width_tiles
            or height_tiles != layer.height_tiles
            or tile_size != layer.tile_size
        ):
            raise ValueError("tile layer command does not match its tilemap")
        tiles_per_row = asset.width // tile_size
        if tiles_per_row == 0:
            raise ValueError("tile atlas is narrower than one tile")
        map_width = width_tiles * tile_size
        map_height = height_tiles * tile_size
        for output_y in range(max(0, screen_y), min(LOGICAL_HEIGHT, screen_y + map_height)):
            local_y = output_y - screen_y
            tile_y, pixel_y = divmod(local_y, tile_size)
            for output_x in range(max(0, screen_x), min(LOGICAL_WIDTH, screen_x + map_width)):
                local_x = output_x - screen_x
                tile_x, pixel_x = divmod(local_x, tile_size)
                tile = layer.tiles[tile_y * width_tiles + tile_x]
                source_pixel_x = tile_size - 1 - pixel_x if tile.flip_x else pixel_x
                source_pixel_y = tile_size - 1 - pixel_y if tile.flip_y else pixel_y
                source_x = (tile.tile_id % tiles_per_row) * tile_size + source_pixel_x
                source_y = (tile.tile_id // tiles_per_row) * tile_size + source_pixel_y
                if source_x >= asset.width or source_y >= asset.height:
                    raise ValueError("tile descriptor extends outside its atlas")
                color_index = asset.pixels[source_y * asset.width + source_x]
                if color_index:
                    tokens[output_y * LOGICAL_WIDTH + output_x] = (
                        tile.palette_bank << 4
                    ) | color_index
