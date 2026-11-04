from __future__ import annotations

import struct
import zlib
from dataclasses import dataclass
from typing import Iterable

from .gpu_abi import GpuCommand, Opcode
from .scene import LOGICAL_HEIGHT, LOGICAL_WIDTH, IndexedImage, TileLayer


TRACE_RECORD = struct.Struct("<HBB")


@dataclass(frozen=True)
class PixelWrite:
    address: int
    token: int

    def to_bytes(self) -> bytes:
        return TRACE_RECORD.pack(self.address, self.token, 0)


@dataclass(frozen=True)
class PixelDifference:
    address: int
    x: int
    y: int
    expected: int
    actual: int


def raster_writes(
    commands: Iterable[GpuCommand],
    *,
    assets: tuple[IndexedImage, ...] = (),
    tilemaps: tuple[TileLayer, ...] = (),
) -> tuple[PixelWrite, ...]:
    writes: list[PixelWrite] = []
    for command in commands:
        if command.opcode == Opcode.END_FRAME:
            break
        if command.opcode == Opcode.CLEAR:
            token = command.words[1] & 0xFF
            writes.extend(
                PixelWrite(address, token)
                for address in range(LOGICAL_WIDTH * LOGICAL_HEIGHT)
            )
        elif command.opcode == Opcode.FILL_RECT:
            writes.extend(_fill_rect_writes(command))
        elif command.opcode == Opcode.BLIT_INDEX4:
            writes.extend(_indexed_blit_command_writes(command, assets))
        elif command.opcode == Opcode.DRAW_TILE_LAYER:
            writes.extend(_tile_layer_command_writes(command, assets, tilemaps))
        else:
            raise ValueError(f"unsupported raster opcode {int(command.opcode)}")
    return tuple(writes)


def clear_fill_writes(commands: Iterable[GpuCommand]) -> tuple[PixelWrite, ...]:
    writes: list[PixelWrite] = []
    for command in commands:
        if command.opcode == Opcode.END_FRAME:
            break
        if command.opcode == Opcode.CLEAR:
            token = command.words[1] & 0xFF
            writes.extend(
                PixelWrite(address, token)
                for address in range(LOGICAL_WIDTH * LOGICAL_HEIGHT)
            )
            continue
        if command.opcode != Opcode.FILL_RECT:
            raise ValueError(f"unsupported raster opcode {int(command.opcode)}")

        x = _signed16(command.words[2] & 0xFFFF)
        y = _signed16((command.words[2] >> 16) & 0xFFFF)
        width = command.words[3] & 0xFFFF
        height = (command.words[3] >> 16) & 0xFFFF
        token = command.words[1] & 0xFF
        left = max(0, x)
        top = max(0, y)
        right = min(LOGICAL_WIDTH, x + width)
        bottom = min(LOGICAL_HEIGHT, y + height)
        for output_y in range(top, bottom):
            row_address = output_y * LOGICAL_WIDTH + left
            writes.extend(
                PixelWrite(row_address + offset, token)
                for offset in range(max(0, right - left))
            )
    return tuple(writes)


def indexed_blit_writes(
    commands: Iterable[GpuCommand], assets: tuple[IndexedImage, ...]
) -> tuple[PixelWrite, ...]:
    writes: list[PixelWrite] = []
    for command in commands:
        if command.opcode == Opcode.END_FRAME:
            break
        if command.opcode != Opcode.BLIT_INDEX4:
            raise ValueError(f"unsupported blit opcode {int(command.opcode)}")
        writes.extend(_indexed_blit_command_writes(command, assets))
    return tuple(writes)


def first_pixel_difference(expected: bytes, actual: bytes) -> PixelDifference | None:
    if len(expected) != LOGICAL_WIDTH * LOGICAL_HEIGHT:
        raise ValueError("expected framebuffer has an invalid size")
    if len(actual) != len(expected):
        raise ValueError("actual framebuffer has an invalid size")
    for address, (expected_token, actual_token) in enumerate(zip(expected, actual)):
        if expected_token != actual_token:
            return PixelDifference(
                address=address,
                x=address % LOGICAL_WIDTH,
                y=address // LOGICAL_WIDTH,
                expected=expected_token,
                actual=actual_token,
            )
    return None


def raster_trace_bytes(writes: Iterable[PixelWrite]) -> bytes:
    return b"".join(write.to_bytes() for write in writes)


def raster_trace_crc32(writes: Iterable[PixelWrite]) -> int:
    crc32 = 0
    for write in writes:
        crc32 = zlib.crc32(write.to_bytes(), crc32)
    return crc32 & 0xFFFFFFFF


def apply_writes(
    writes: Iterable[PixelWrite], *, initial_token: int = 0
) -> bytes:
    if not 0 <= initial_token <= 0xFF:
        raise ValueError("initial token must fit in 8 bits")
    tokens = bytearray((initial_token,)) * (LOGICAL_WIDTH * LOGICAL_HEIGHT)
    for write in writes:
        tokens[write.address] = write.token
    return bytes(tokens)


def _signed16(value: int) -> int:
    return value - 0x10000 if value & 0x8000 else value


def _signed32(value: int) -> int:
    return value - 0x100000000 if value & 0x80000000 else value


def _fill_rect_writes(command: GpuCommand) -> tuple[PixelWrite, ...]:
    x = _signed16(command.words[2] & 0xFFFF)
    y = _signed16((command.words[2] >> 16) & 0xFFFF)
    width = command.words[3] & 0xFFFF
    height = (command.words[3] >> 16) & 0xFFFF
    token = command.words[1] & 0xFF
    writes: list[PixelWrite] = []
    for output_y in range(max(0, y), min(LOGICAL_HEIGHT, y + height)):
        row_address = output_y * LOGICAL_WIDTH + max(0, x)
        writes.extend(
            PixelWrite(row_address + offset, token)
            for offset in range(max(0, min(LOGICAL_WIDTH, x + width) - max(0, x)))
        )
    return tuple(writes)


def _indexed_blit_command_writes(
    command: GpuCommand, assets: tuple[IndexedImage, ...]
) -> tuple[PixelWrite, ...]:
    asset_id = command.words[1] & 0xFFFF
    palette_bank = (command.words[1] >> 16) & 0xF
    if asset_id >= len(assets):
        raise ValueError("blit references an unknown asset")
    asset = assets[asset_id]
    dst_x = _signed16(command.words[2] & 0xFFFF)
    dst_y = _signed16((command.words[2] >> 16) & 0xFFFF)
    width = command.words[3] & 0xFFFF
    height = (command.words[3] >> 16) & 0xFFFF
    src_x = command.words[4] & 0xFFFF
    src_y = (command.words[4] >> 16) & 0xFFFF
    if src_x + width > asset.width or src_y + height > asset.height:
        raise ValueError("blit source rectangle exceeds its asset")
    writes: list[PixelWrite] = []
    for output_y in range(max(0, dst_y), min(LOGICAL_HEIGHT, dst_y + height)):
        local_y = output_y - dst_y
        if command.flags & 0x2:
            local_y = height - 1 - local_y
        for output_x in range(max(0, dst_x), min(LOGICAL_WIDTH, dst_x + width)):
            local_x = output_x - dst_x
            if command.flags & 0x1:
                local_x = width - 1 - local_x
            color_index = asset.pixels[
                (src_y + local_y) * asset.width + src_x + local_x
            ]
            if color_index:
                writes.append(
                    PixelWrite(
                        output_y * LOGICAL_WIDTH + output_x,
                        (palette_bank << 4) | color_index,
                    )
                )
    return tuple(writes)


def _tile_layer_command_writes(
    command: GpuCommand,
    assets: tuple[IndexedImage, ...],
    tilemaps: tuple[TileLayer, ...],
) -> tuple[PixelWrite, ...]:
    asset_id = command.words[1] & 0xFFFF
    tilemap_id = (command.words[1] >> 16) & 0xFFFF
    if asset_id >= len(assets):
        raise ValueError("tile layer references an unknown asset")
    if tilemap_id >= len(tilemaps):
        raise ValueError("tile layer references an unknown tilemap")
    asset = assets[asset_id]
    tilemap = tilemaps[tilemap_id]
    screen_x = _signed32(command.words[2])
    screen_y = _signed32(command.words[3])
    width_tiles = command.words[4] & 0xFFFF
    height_tiles = (command.words[4] >> 16) & 0xFFFF
    tile_size = command.words[5] & 0xFFFF
    if (
        width_tiles != tilemap.width_tiles
        or height_tiles != tilemap.height_tiles
        or tile_size != tilemap.tile_size
    ):
        raise ValueError("tile layer command does not match its tilemap")
    tiles_per_row = asset.width // tile_size
    if tiles_per_row == 0:
        raise ValueError("tile atlas is narrower than one tile")

    map_width = width_tiles * tile_size
    map_height = height_tiles * tile_size
    writes: list[PixelWrite] = []
    for output_y in range(max(0, screen_y), min(LOGICAL_HEIGHT, screen_y + map_height)):
        local_y = output_y - screen_y
        tile_y, pixel_y = divmod(local_y, tile_size)
        for output_x in range(max(0, screen_x), min(LOGICAL_WIDTH, screen_x + map_width)):
            local_x = output_x - screen_x
            tile_x, pixel_x = divmod(local_x, tile_size)
            tile = tilemap.tiles[tile_y * width_tiles + tile_x]
            source_pixel_x = tile_size - 1 - pixel_x if tile.flip_x else pixel_x
            source_pixel_y = tile_size - 1 - pixel_y if tile.flip_y else pixel_y
            source_x = (tile.tile_id % tiles_per_row) * tile_size + source_pixel_x
            source_y = (tile.tile_id // tiles_per_row) * tile_size + source_pixel_y
            if source_x >= asset.width or source_y >= asset.height:
                raise ValueError("tile descriptor extends outside its atlas")
            color_index = asset.pixels[source_y * asset.width + source_x]
            if color_index:
                writes.append(
                    PixelWrite(
                        output_y * LOGICAL_WIDTH + output_x,
                        (tile.palette_bank << 4) | color_index,
                    )
                )
    return tuple(writes)