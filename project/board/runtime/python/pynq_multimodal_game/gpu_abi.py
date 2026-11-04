from __future__ import annotations

import struct
import zlib
from dataclasses import dataclass
from enum import IntEnum

from .scene import (
    LOGICAL_HEIGHT,
    LOGICAL_WIDTH,
    IndexedImage,
    RgbColor,
    TileDescriptor,
    TileLayer,
)


SCENE_MAGIC = int.from_bytes(b"S2DG", "little")
ABI_MAJOR = 1
ABI_MINOR = 0
HEADER_WORDS = 16
COMMAND_WORDS = 8
COMMAND_CAPACITY = 128
ASSET_ALIGNMENT = 64
ASSET_BUNDLE_SLOT_COUNT = 3
ASSET_BUNDLE_CAPACITY_BYTES = 32768
PACKET_HEADER_WORDS = 16
PACKET_HEADER_BYTES = PACKET_HEADER_WORDS * 4
ASSET_SLOT_COUNT = 16
TILEMAP_SLOT_COUNT = 4
TILEMAP_SLOT_BYTES = 4096
TILEMAP_DESCRIPTOR_BYTES = 16
TILEMAP_TILE_CAPACITY = (TILEMAP_SLOT_BYTES - TILEMAP_DESCRIPTOR_BYTES) // 4
FRAME8_PAYLOAD_SIZE = LOGICAL_WIDTH * LOGICAL_HEIGHT


class PacketType(IntEnum):
    ASSET = 1
    TILEMAP = 2
    PALETTE = 3
    FRAME8 = 4


PACKET_MAGIC = {
    PacketType.ASSET: int.from_bytes(b"S2DA", "little"),
    PacketType.TILEMAP: int.from_bytes(b"S2DT", "little"),
    PacketType.PALETTE: int.from_bytes(b"S2DP", "little"),
    PacketType.FRAME8: int.from_bytes(b"S2DF", "little"),
}


class Opcode(IntEnum):
    CLEAR = 1
    DRAW_TILE_LAYER = 2
    BLIT_INDEX4 = 3
    FILL_RECT = 4
    END_FRAME = 255


class AssetFormat(IntEnum):
    INDEX4 = 1


def _u32(value: int) -> int:
    if not -(1 << 31) <= value < (1 << 32):
        raise ValueError("value does not fit in 32 bits")
    return value & 0xFFFFFFFF


def _strict_u32(value: int, name: str) -> int:
    if not 0 <= value <= 0xFFFFFFFF:
        raise ValueError(f"{name} does not fit in unsigned 32 bits")
    return value


def _u16(value: int, name: str) -> int:
    if not 0 <= value <= 0xFFFF:
        raise ValueError(f"{name} does not fit in 16 bits")
    return value


def _i16(value: int, name: str) -> int:
    if not -0x8000 <= value <= 0x7FFF:
        raise ValueError(f"{name} does not fit in signed 16 bits")
    return value & 0xFFFF


def pack_u16_pair(low: int, high: int, *, low_name: str, high_name: str) -> int:
    return _u16(low, low_name) | (_u16(high, high_name) << 16)


def pack_i16_pair(low: int, high: int, *, low_name: str, high_name: str) -> int:
    return _i16(low, low_name) | (_i16(high, high_name) << 16)


@dataclass(frozen=True)
class SceneHeader:
    frame_id: int
    submit_seq: int
    command_count: int
    camera_x: int
    camera_y: int
    background_color: tuple[int, int, int]
    palette_generation: int = 0
    asset_generation: int = 0
    tilemap_generation: int = 0
    predicted_cycles: int = 0
    flags: int = 0

    def __post_init__(self) -> None:
        if not 0 <= self.command_count <= COMMAND_CAPACITY:
            raise ValueError("command_count exceeds the command bank capacity")
        if not all(0 <= channel <= 255 for channel in self.background_color):
            raise ValueError("background channels must fit in 8 bits")
        if self.flags != 0:
            raise ValueError("SceneHeader flags are reserved")

    def to_words(self) -> tuple[int, ...]:
        red, green, blue = self.background_color
        version = (ABI_MAJOR << 16) | ABI_MINOR
        background = (red << 16) | (green << 8) | blue
        return (
            SCENE_MAGIC,
            version,
            _u32(self.frame_id),
            _u32(self.submit_seq),
            _u32(self.command_count),
            _u32(self.camera_x),
            _u32(self.camera_y),
            background,
            _u32(self.palette_generation),
            _u32(self.predicted_cycles),
            _u32(self.asset_generation),
            _u32(self.tilemap_generation),
            0,
            0,
            0,
            0,
        )

    def to_bytes(self) -> bytes:
        return struct.pack(f"<{HEADER_WORDS}I", *self.to_words())


@dataclass(frozen=True)
class PacketHeader:
    packet_type: PacketType
    target_id: int
    generation: int
    payload_size: int
    payload_crc32: int
    flags: int = 0

    def __post_init__(self) -> None:
        object.__setattr__(self, "packet_type", PacketType(self.packet_type))
        _strict_u32(self.target_id, "target_id")
        _strict_u32(self.generation, "generation")
        _strict_u32(self.payload_size, "payload_size")
        _strict_u32(self.payload_crc32, "payload_crc32")
        _strict_u32(self.flags, "flags")

    @classmethod
    def for_payload(
        cls,
        packet_type: PacketType,
        *,
        target_id: int,
        generation: int,
        payload: bytes,
        flags: int = 0,
    ) -> PacketHeader:
        return cls(
            packet_type=packet_type,
            target_id=target_id,
            generation=generation,
            payload_size=len(payload),
            payload_crc32=zlib.crc32(payload) & 0xFFFFFFFF,
            flags=flags,
        )

    def to_words(self) -> tuple[int, ...]:
        return (
            PACKET_MAGIC[self.packet_type],
            (ABI_MAJOR << 16) | ABI_MINOR,
            int(self.packet_type),
            self.target_id,
            self.generation,
            self.payload_size,
            self.payload_crc32,
            self.flags,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
        )

    def to_bytes(self) -> bytes:
        return struct.pack(f"<{PACKET_HEADER_WORDS}I", *self.to_words())

    @classmethod
    def from_bytes(cls, data: bytes) -> PacketHeader:
        if len(data) != PACKET_HEADER_BYTES:
            raise ValueError(f"packet header must contain {PACKET_HEADER_BYTES} bytes")
        words = struct.unpack(f"<{PACKET_HEADER_WORDS}I", data)
        try:
            packet_type = PacketType(words[2])
        except ValueError as error:
            raise ValueError("unknown resource packet type") from error
        if words[0] != PACKET_MAGIC[packet_type]:
            raise ValueError("resource packet magic does not match its type")
        if words[1] != (ABI_MAJOR << 16) | ABI_MINOR:
            raise ValueError("unsupported resource packet ABI version")
        if any(words[8:]):
            raise ValueError("resource packet reserved words must be zero")
        return cls(
            packet_type=packet_type,
            target_id=words[3],
            generation=words[4],
            payload_size=words[5],
            payload_crc32=words[6],
            flags=words[7],
        )


@dataclass(frozen=True)
class AssetDescriptor:
    base_offset: int
    width: int
    height: int
    stride_bytes: int
    payload_size: int
    generation: int = 0
    format: AssetFormat = AssetFormat.INDEX4

    def to_words(self) -> tuple[int, ...]:
        if not 0 <= self.generation <= 0xFF:
            raise ValueError("asset generation must fit in 8 bits")
        dimensions = pack_u16_pair(
            self.width, self.height, low_name="width", high_name="height"
        )
        format_stride = (
            _u16(self.stride_bytes, "stride_bytes")
            | (int(self.format) << 16)
            | (self.generation << 24)
        )
        return (
            _u32(self.base_offset),
            dimensions,
            format_stride,
            _u32(self.payload_size),
        )

    def to_bytes(self) -> bytes:
        return struct.pack("<4I", *self.to_words())


@dataclass(frozen=True)
class PackedAssets:
    descriptors: tuple[AssetDescriptor, ...]
    payload: bytes

    @property
    def descriptor_table(self) -> bytes:
        return b"".join(descriptor.to_bytes() for descriptor in self.descriptors)


@dataclass(frozen=True)
class GpuCommand:
    words: tuple[int, ...]

    def __post_init__(self) -> None:
        if len(self.words) != COMMAND_WORDS:
            raise ValueError(f"a GPU command contains {COMMAND_WORDS} words")
        if any(not 0 <= word <= 0xFFFFFFFF for word in self.words):
            raise ValueError("GPU command words must fit in 32 bits")
        try:
            Opcode(self.words[0] & 0xFF)
        except ValueError as error:
            raise ValueError("unknown GPU opcode") from error

    @property
    def opcode(self) -> Opcode:
        return Opcode(self.words[0] & 0xFF)

    @property
    def flags(self) -> int:
        return (self.words[0] >> 8) & 0xFF

    def to_bytes(self) -> bytes:
        return struct.pack(f"<{COMMAND_WORDS}I", *self.words)

    @classmethod
    def clear(cls, token: int = 0) -> GpuCommand:
        if not 0 <= token <= 0xFF:
            raise ValueError("clear token must fit in 8 bits")
        return cls((Opcode.CLEAR, token, 0, 0, 0, 0, 0, 0))

    @classmethod
    def fill_rect(
        cls, *, x: int, y: int, width: int, height: int, token: int
    ) -> GpuCommand:
        if not 0 <= token <= 0xFF:
            raise ValueError("fill token must fit in 8 bits")
        return cls(
            (
                Opcode.FILL_RECT,
                token,
                pack_i16_pair(x, y, low_name="x", high_name="y"),
                pack_u16_pair(
                    width, height, low_name="width", high_name="height"
                ),
                0,
                0,
                0,
                0,
            )
        )

    @classmethod
    def blit_index4(
        cls,
        *,
        asset_id: int,
        palette_bank: int,
        dst_x: int,
        dst_y: int,
        width: int,
        height: int,
        src_x: int,
        src_y: int,
        flip_x: bool = False,
        flip_y: bool = False,
    ) -> GpuCommand:
        if not 0 <= palette_bank <= 15:
            raise ValueError("palette_bank must fit in 4 bits")
        flags = int(flip_x) | (int(flip_y) << 1)
        return cls(
            (
                int(Opcode.BLIT_INDEX4) | (flags << 8),
                _u16(asset_id, "asset_id") | (palette_bank << 16),
                pack_i16_pair(
                    dst_x, dst_y, low_name="dst_x", high_name="dst_y"
                ),
                pack_u16_pair(
                    width, height, low_name="width", high_name="height"
                ),
                pack_u16_pair(
                    src_x, src_y, low_name="src_x", high_name="src_y"
                ),
                0,
                0,
                0,
            )
        )

    @classmethod
    def draw_tile_layer(
        cls,
        *,
        asset_id: int,
        tilemap_id: int,
        screen_x: int,
        screen_y: int,
        width_tiles: int,
        height_tiles: int,
        tile_size: int,
    ) -> GpuCommand:
        if tile_size <= 0 or tile_size & (tile_size - 1):
            raise ValueError("tile_size must be a positive power of two")
        return cls(
            (
                Opcode.DRAW_TILE_LAYER,
                _u16(asset_id, "asset_id")
                | (_u16(tilemap_id, "tilemap_id") << 16),
                _u32(screen_x),
                _u32(screen_y),
                pack_u16_pair(
                    width_tiles,
                    height_tiles,
                    low_name="width_tiles",
                    high_name="height_tiles",
                ),
                _u16(tile_size, "tile_size"),
                0,
                0,
            )
        )

    @classmethod
    def end_frame(cls) -> GpuCommand:
        return cls((Opcode.END_FRAME, 0, 0, 0, 0, 0, 0, 0))


def pack_command_bank(commands: tuple[GpuCommand, ...]) -> bytes:
    if len(commands) > COMMAND_CAPACITY:
        raise ValueError("command bank capacity exceeded")
    payload = b"".join(command.to_bytes() for command in commands)
    return payload.ljust(COMMAND_CAPACITY * COMMAND_WORDS * 4, b"\0")


def pack_index4(image: IndexedImage) -> bytes:
    stride = (image.width + 1) // 2
    packed = bytearray(stride * image.height)
    for y in range(image.height):
        for x in range(image.width):
            color_index = image.pixels[y * image.width + x]
            offset = y * stride + x // 2
            if x & 1:
                packed[offset] |= color_index << 4
            else:
                packed[offset] = color_index
    return bytes(packed)


def pack_assets(
    assets: tuple[IndexedImage, ...], *, generation: int = 0
) -> PackedAssets:
    payload = bytearray()
    descriptors = []
    for asset in assets:
        padding = (-len(payload)) % ASSET_ALIGNMENT
        payload.extend(b"\0" * padding)
        packed = pack_index4(asset)
        descriptors.append(
            AssetDescriptor(
                base_offset=len(payload),
                width=asset.width,
                height=asset.height,
                stride_bytes=(asset.width + 1) // 2,
                payload_size=len(packed),
                generation=generation,
            )
        )
        payload.extend(packed)
    return PackedAssets(tuple(descriptors), bytes(payload))


def pack_palette_banks(
    banks: tuple[tuple[RgbColor, ...], ...],
) -> bytes:
    if len(banks) != 16 or any(len(bank) != 16 for bank in banks):
        raise ValueError("hardware palette payload must contain 16 banks of 16 colors")
    words = []
    for bank in banks:
        for red, green, blue in bank:
            if not all(0 <= channel <= 255 for channel in (red, green, blue)):
                raise ValueError("palette channels must fit in 8 bits")
            words.append((red << 16) | (green << 8) | blue)
    return struct.pack("<256I", *words)


def pack_tile_descriptor(tile: TileDescriptor) -> int:
    if not 0 <= tile.tile_id <= 0xFFFF:
        raise ValueError("tile_id must fit in 16 bits")
    if not 0 <= tile.palette_bank <= 15:
        raise ValueError("tile palette_bank must fit in 4 bits")
    return (
        tile.tile_id
        | (tile.palette_bank << 16)
        | (int(tile.flip_x) << 20)
        | (int(tile.flip_y) << 21)
    )


def pack_tilemap(layer: TileLayer) -> bytes:
    if len(layer.tiles) > TILEMAP_TILE_CAPACITY:
        raise ValueError(
            f"tilemap requires {TILEMAP_DESCRIPTOR_BYTES + len(layer.tiles) * 4} bytes; "
            f"hardware slot capacity is {TILEMAP_SLOT_BYTES} bytes"
        )
    dimensions = pack_u16_pair(
        layer.width_tiles,
        layer.height_tiles,
        low_name="width_tiles",
        high_name="height_tiles",
    )
    header = struct.pack(
        "<4I",
        dimensions,
        _u32(layer.origin_x),
        _u32(layer.origin_y),
        _u16(layer.tile_size, "tile_size"),
    )
    descriptors = struct.pack(
        f"<{len(layer.tiles)}I",
        *(pack_tile_descriptor(tile) for tile in layer.tiles),
    )
    return header + descriptors


def pack_resource_packet(
    packet_type: PacketType,
    payload: bytes,
    *,
    target_id: int,
    generation: int,
    flags: int = 0,
) -> bytes:
    header = PacketHeader.for_payload(
        packet_type,
        target_id=target_id,
        generation=generation,
        payload=payload,
        flags=flags,
    )
    return header.to_bytes() + payload


def unpack_resource_packet(packet: bytes) -> tuple[PacketHeader, bytes]:
    if len(packet) < PACKET_HEADER_BYTES:
        raise ValueError("resource packet is shorter than its header")
    header = PacketHeader.from_bytes(packet[:PACKET_HEADER_BYTES])
    payload = packet[PACKET_HEADER_BYTES:]
    if len(payload) != header.payload_size:
        raise ValueError("resource packet payload length mismatch")
    if zlib.crc32(payload) & 0xFFFFFFFF != header.payload_crc32:
        raise ValueError("resource packet payload CRC mismatch")
    return header, payload


def pack_asset_packet(
    asset: IndexedImage, *, target_id: int, generation: int
) -> bytes:
    if not 0 <= target_id < ASSET_SLOT_COUNT:
        raise ValueError("asset target_id exceeds the hardware slot count")
    packed = pack_assets((asset,), generation=generation & 0xFF)
    payload = packed.descriptor_table + packed.payload
    return pack_resource_packet(
        PacketType.ASSET,
        payload,
        target_id=target_id,
        generation=generation,
    )


def pack_asset_bundle_packet(
    assets: tuple[IndexedImage, ...], *, generation: int
) -> bytes:
    if len(assets) != ASSET_BUNDLE_SLOT_COUNT:
        raise ValueError(
            f"asset bundle must contain exactly {ASSET_BUNDLE_SLOT_COUNT} assets"
        )
    packed = pack_assets(assets, generation=generation & 0xFF)
    if len(packed.payload) > ASSET_BUNDLE_CAPACITY_BYTES:
        raise ValueError(
            f"asset bundle requires {len(packed.payload)} bytes; "
            f"hardware capacity is {ASSET_BUNDLE_CAPACITY_BYTES} bytes"
        )
    payload = packed.descriptor_table + packed.payload
    return pack_resource_packet(
        PacketType.ASSET,
        payload,
        target_id=0,
        generation=generation,
    )


def pack_tilemap_packet(
    layer: TileLayer, *, target_id: int, generation: int
) -> bytes:
    if not 0 <= target_id < TILEMAP_SLOT_COUNT:
        raise ValueError("tilemap target_id exceeds the hardware slot count")
    return pack_resource_packet(
        PacketType.TILEMAP,
        pack_tilemap(layer),
        target_id=target_id,
        generation=generation,
    )


def pack_palette_packet(
    banks: tuple[tuple[RgbColor, ...], ...], *, generation: int
) -> bytes:
    return pack_resource_packet(
        PacketType.PALETTE,
        pack_palette_banks(banks),
        target_id=0,
        generation=generation,
    )


def pack_frame8_packet(tokens: bytes, *, generation: int) -> bytes:
    if len(tokens) != FRAME8_PAYLOAD_SIZE:
        raise ValueError(
            f"FRAME8 payload must contain {FRAME8_PAYLOAD_SIZE} tokens"
        )
    return pack_resource_packet(
        PacketType.FRAME8,
        tokens,
        target_id=0,
        generation=generation,
    )
