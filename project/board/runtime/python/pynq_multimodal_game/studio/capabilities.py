from __future__ import annotations

from dataclasses import dataclass
from enum import Enum

from ..gpu_abi import (
    ABI_MAJOR,
    ABI_MINOR,
    ASSET_BUNDLE_SLOT_COUNT,
    COMMAND_CAPACITY,
    TILEMAP_SLOT_COUNT,
    Opcode,
)
from ..scene import LOGICAL_HEIGHT, LOGICAL_WIDTH, MAX_SPRITES, OUTPUT_SCALE


class CapabilityStatus(str, Enum):
    VERIFIED = "verified"
    PS_SOFTWARE = "ps_software"
    FUTURE_RTL = "future_rtl"
    UNSUPPORTED = "unsupported"


@dataclass(frozen=True)
class StudioCapability:
    key: str
    label: str
    status: CapabilityStatus
    detail: str


@dataclass(frozen=True)
class FrozenGpuCapabilities:
    build_id: int
    abi_version: tuple[int, int]
    logical_size: tuple[int, int]
    output_size: tuple[int, int]
    command_capacity: int
    max_sprites: int
    asset_bundle_slots: int
    tilemap_slots: int
    supported_opcodes: tuple[Opcode, ...]
    frame8_supported: bool


C4M7_CAPABILITIES = FrozenGpuCapabilities(
    build_id=0xC0040700,
    abi_version=(ABI_MAJOR, ABI_MINOR),
    logical_size=(LOGICAL_WIDTH, LOGICAL_HEIGHT),
    output_size=(LOGICAL_WIDTH * OUTPUT_SCALE, LOGICAL_HEIGHT * OUTPUT_SCALE),
    command_capacity=COMMAND_CAPACITY,
    max_sprites=MAX_SPRITES,
    asset_bundle_slots=ASSET_BUNDLE_SLOT_COUNT,
    tilemap_slots=TILEMAP_SLOT_COUNT,
    supported_opcodes=(
        Opcode.CLEAR,
        Opcode.DRAW_TILE_LAYER,
        Opcode.BLIT_INDEX4,
        Opcode.FILL_RECT,
        Opcode.END_FRAME,
    ),
    frame8_supported=False,
)


CAPABILITY_MATRIX = (
    StudioCapability(
        "scene2d",
        "Scene2D command renderer",
        CapabilityStatus.VERIFIED,
        "Frozen C4M7 Tile, Sprite, Palette and HUD rendering",
    ),
    StudioCapability(
        "game_runtime",
        "PS game runtime",
        CapabilityStatus.PS_SOFTWARE,
        "Deterministic game logic and Scene submission on the PYNQ PS",
    ),
    StudioCapability(
        "frame8",
        "FRAME8 packet execution",
        CapabilityStatus.UNSUPPORTED,
        "The packet packer exists, but C4M7 PL does not consume FRAME8 packets",
    ),
    StudioCapability(
        "generic_video",
        "Generic RGB video pipeline",
        CapabilityStatus.FUTURE_RTL,
        "Requires a future PL data path or a frozen-GPU-specific tile codec",
    ),
)