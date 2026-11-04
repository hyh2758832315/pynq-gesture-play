from __future__ import annotations

import hashlib
import itertools
import json
import os
import struct
import tempfile
import zipfile
import zlib
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable, Iterator

from .gpu_abi import (
    ABI_MAJOR,
    ABI_MINOR,
    GpuCommand,
    Opcode,
    PacketType,
    SCENE_MAGIC,
    SceneHeader,
    pack_asset_bundle_packet,
    pack_command_bank,
    pack_palette_packet,
    pack_tilemap_packet,
    unpack_resource_packet,
)
from .scene import IndexedImage, RgbColor, TileDescriptor, TileLayer


S2V1_WIDTH = 320
S2V1_HEIGHT = 180
S2V1_PADDED_HEIGHT = 192
S2V1_FPS = 30
S2V1_TILE_SIZE = 16
S2V1_TILE_COLUMNS = 20
S2V1_TILE_ROWS = 12
S2V1_TILE_COUNT = S2V1_TILE_COLUMNS * S2V1_TILE_ROWS
S2V1_ATLAS_COLUMNS = 16
S2V1_ATLAS_ROWS = 15
S2V1_ATLAS_WIDTH = S2V1_ATLAS_COLUMNS * S2V1_TILE_SIZE
S2V1_ATLAS_HEIGHT = S2V1_ATLAS_ROWS * S2V1_TILE_SIZE
S2V1_VIDEO_PALETTE_BANKS = 15
S2V1_GOP_SIZE = 30
S2V1_FORMAT = "S2V1"
S2V1_VERSION = (1, 0)
S2V1_RESIZE_FILTERS = ("legacy", "area", "lanczos")
S2V1_QUALITY_PROFILES = (
    "legacy",
    "stable",
    "spatial",
    "spatial-resident",
    "spatial-shared",
)


@dataclass(frozen=True)
class S2V1FramePackets:
    frame_index: int
    generation: int
    asset_packet: bytes
    scene_packet: bytes


@dataclass(frozen=True)
class S2V1EncodeSummary:
    path: Path
    frame_count: int
    gop_count: int
    total_bytes: int
    sha256: str
    average_bitrate_bps: int


@dataclass(frozen=True)
class S2V1DecodedFrame:
    frame_index: int
    pts_numerator: int
    pts_denominator: int
    rgb: bytes


@dataclass(frozen=True)
class S2V1PlaybackFrame:
    frame_index: int
    pts_numerator: int
    pts_denominator: int
    generation: int
    gop_index: int
    palette_packet: bytes | None
    asset_packet: bytes
    scene_packet: bytes


def _tile_bank_assignment(
    tile_banks: tuple[int, ...] | None = None,
) -> tuple[int, ...]:
    assignment = tile_banks or tuple(
        tile_id % S2V1_VIDEO_PALETTE_BANKS for tile_id in range(S2V1_TILE_COUNT)
    )
    if len(assignment) != S2V1_TILE_COUNT or any(
        not 0 <= bank < S2V1_VIDEO_PALETTE_BANKS for bank in assignment
    ):
        raise ValueError("S2V1 tile-bank assignment must contain 240 banks in range 0..14")
    return assignment


def _spatial_tile_banks() -> tuple[int, ...]:
    return tuple(
        (tile_id // S2V1_TILE_COLUMNS // 4) * 5
        + (tile_id % S2V1_TILE_COLUMNS // 4)
        for tile_id in range(S2V1_TILE_COUNT)
    )


def build_static_tilemap(
    *, generation: int = 1, tile_banks: tuple[int, ...] | None = None
) -> bytes:
    assignment = _tile_bank_assignment(tile_banks)
    tiles = tuple(
        TileDescriptor(
            tile_id=tile_id,
            palette_bank=assignment[tile_id],
        )
        for tile_id in range(S2V1_TILE_COUNT)
    )
    return pack_tilemap_packet(
        TileLayer(
            width_tiles=S2V1_TILE_COLUMNS,
            height_tiles=S2V1_TILE_ROWS,
            tiles=tiles,
            tile_size=S2V1_TILE_SIZE,
        ),
        target_id=0,
        generation=generation,
    )


def build_palette_packet(
    banks: tuple[tuple[RgbColor, ...], ...], *, generation: int
) -> bytes:
    if len(banks) != S2V1_VIDEO_PALETTE_BANKS:
        raise ValueError("S2V1 requires exactly 15 video palette banks")
    if any(len(bank) != 16 for bank in banks):
        raise ValueError("each S2V1 palette bank must contain 16 colors")
    system_bank = ((0, 0, 0),) * 16
    return pack_palette_packet(banks + (system_bank,), generation=generation)


def frame_indices_to_atlas(indices: bytes) -> IndexedImage:
    expected = S2V1_WIDTH * S2V1_PADDED_HEIGHT
    if len(indices) != expected:
        raise ValueError(f"S2V1 indexed frame must contain {expected} pixels")
    if any(index > 15 for index in indices):
        raise ValueError("S2V1 indexed pixels must fit in 4 bits")

    atlas = bytearray(S2V1_ATLAS_WIDTH * S2V1_ATLAS_HEIGHT)
    for tile_id in range(S2V1_TILE_COUNT):
        source_tile_x = tile_id % S2V1_TILE_COLUMNS
        source_tile_y = tile_id // S2V1_TILE_COLUMNS
        atlas_tile_x = tile_id % S2V1_ATLAS_COLUMNS
        atlas_tile_y = tile_id // S2V1_ATLAS_COLUMNS
        for pixel_y in range(S2V1_TILE_SIZE):
            source = (
                (source_tile_y * S2V1_TILE_SIZE + pixel_y) * S2V1_WIDTH
                + source_tile_x * S2V1_TILE_SIZE
            )
            target = (
                (atlas_tile_y * S2V1_TILE_SIZE + pixel_y) * S2V1_ATLAS_WIDTH
                + atlas_tile_x * S2V1_TILE_SIZE
            )
            atlas[target : target + S2V1_TILE_SIZE] = indices[
                source : source + S2V1_TILE_SIZE
            ]
    return IndexedImage(S2V1_ATLAS_WIDTH, S2V1_ATLAS_HEIGHT, bytes(atlas))


def build_frame_packets(
    indices: bytes,
    *,
    frame_index: int,
    generation: int,
    palette_generation: int,
    tilemap_generation: int = 1,
) -> S2V1FramePackets:
    atlas = frame_indices_to_atlas(indices)
    placeholder = IndexedImage(1, 1, b"\0")
    asset_packet = pack_asset_bundle_packet(
        (placeholder, atlas, placeholder), generation=generation
    )
    commands = (
        GpuCommand.clear(0),
        GpuCommand.draw_tile_layer(
            asset_id=1,
            tilemap_id=0,
            screen_x=0,
            screen_y=0,
            width_tiles=S2V1_TILE_COLUMNS,
            height_tiles=S2V1_TILE_ROWS,
            tile_size=S2V1_TILE_SIZE,
        ),
        GpuCommand.end_frame(),
    )
    header = SceneHeader(
        frame_id=frame_index,
        submit_seq=frame_index,
        command_count=len(commands),
        camera_x=0,
        camera_y=0,
        background_color=(0, 0, 0),
        palette_generation=palette_generation,
        asset_generation=generation,
        tilemap_generation=tilemap_generation,
    )
    return S2V1FramePackets(
        frame_index=frame_index,
        generation=generation,
        asset_packet=asset_packet,
        scene_packet=header.to_bytes() + pack_command_bank(commands),
    )


def _require_numpy() -> Any:
    try:
        import numpy
    except ModuleNotFoundError as error:
        raise RuntimeError(
            "S2V1 encoding requires the project video extra: pip install .[video]"
        ) from error
    return numpy


def _rgb_array(frame: object) -> Any:
    numpy = _require_numpy()
    if isinstance(frame, (bytes, bytearray, memoryview)):
        data = bytes(frame)
        expected = S2V1_WIDTH * S2V1_HEIGHT * 3
        if len(data) != expected:
            raise ValueError(f"S2V1 RGB frame must contain {expected} bytes")
        return numpy.frombuffer(data, dtype=numpy.uint8).reshape(
            S2V1_HEIGHT, S2V1_WIDTH, 3
        ).copy()
    array = numpy.asarray(frame)
    if array.shape != (S2V1_HEIGHT, S2V1_WIDTH, 3):
        raise ValueError("S2V1 RGB array must have shape (180, 320, 3)")
    if array.dtype != numpy.uint8:
        raise ValueError("S2V1 RGB array must use uint8 channels")
    return array.copy()


def _padded_tiles(frame: object) -> Any:
    numpy = _require_numpy()
    source = _rgb_array(frame)
    padded = numpy.zeros((S2V1_PADDED_HEIGHT, S2V1_WIDTH, 3), dtype=numpy.uint8)
    padded[:S2V1_HEIGHT] = source
    return padded.reshape(
        S2V1_TILE_ROWS,
        S2V1_TILE_SIZE,
        S2V1_TILE_COLUMNS,
        S2V1_TILE_SIZE,
        3,
    ).transpose(0, 2, 1, 3, 4).reshape(S2V1_TILE_COUNT, 256, 3)


def _weighted_median_cut_colors(histogram: Any, color_count: int) -> list[RgbColor]:
    numpy = _require_numpy()
    populated = numpy.flatnonzero(histogram)
    if populated.size <= color_count:
        ordered = sorted(
            (int(value) for value in populated),
            key=lambda value: (-int(histogram[value]), value),
        )
        return [
            (
                (((value >> 10) & 0x1F) << 3) | 4,
                (((value >> 5) & 0x1F) << 3) | 4,
                ((value & 0x1F) << 3) | 4,
            )
            for value in ordered
        ]

    points = numpy.stack(
        (
            (populated >> 10) & 0x1F,
            (populated >> 5) & 0x1F,
            populated & 0x1F,
        ),
        axis=1,
    ).astype(numpy.int64)
    weights = histogram[populated].astype(numpy.int64)
    boxes = [numpy.arange(populated.size)]
    while len(boxes) < color_count:
        choice = None
        for box_index, members in enumerate(boxes):
            if members.size < 2:
                continue
            member_weights = weights[members]
            total = int(member_weights.sum())
            member_points = points[members]
            means = numpy.average(member_points, axis=0, weights=member_weights)
            variances = numpy.average(
                (member_points - means) ** 2,
                axis=0,
                weights=member_weights,
            )
            channel = int(variances.argmax())
            score = float(variances.sum()) * total
            candidate = (score, -box_index, channel)
            if choice is None or candidate > choice:
                choice = candidate
        if choice is None:
            break
        _, negative_index, channel = choice
        box_index = -negative_index
        members = boxes[box_index]
        order = numpy.lexsort((populated[members], points[members, channel]))
        ordered_members = members[order]
        cumulative = numpy.cumsum(weights[ordered_members])
        split = int(numpy.searchsorted(cumulative, cumulative[-1] / 2, side="left")) + 1
        split = min(max(split, 1), ordered_members.size - 1)
        boxes[box_index] = ordered_members[:split]
        boxes.append(ordered_members[split:])

    colors = []
    for members in boxes:
        member_weights = weights[members]
        total = int(member_weights.sum())
        mean = (points[members] * member_weights[:, None]).sum(axis=0)
        rgb555 = (mean + total // 2) // total
        colors.append(tuple(int(channel) * 8 + 4 for channel in rgb555))
    return colors


def build_gop_palette_banks(
    frames: Iterable[object],
    *,
    tile_banks: tuple[int, ...] | None = None,
    quantizer: str = "frequency",
    shared_color_count: int = 0,
) -> tuple[tuple[RgbColor, ...], ...]:
    numpy = _require_numpy()
    if quantizer not in ("frequency", "median-cut"):
        raise ValueError(f"unsupported S2V1 palette quantizer: {quantizer}")
    if not 0 <= shared_color_count < 15:
        raise ValueError("S2V1 shared color count must be in range 0..14")
    if shared_color_count and quantizer != "median-cut":
        raise ValueError("S2V1 shared colors require the median-cut quantizer")
    frame_list = tuple(frames)
    if not frame_list:
        raise ValueError("an S2V1 GOP must contain at least one frame")
    histograms = numpy.zeros((S2V1_VIDEO_PALETTE_BANKS, 32768), dtype=numpy.int64)
    tile_bank_array = numpy.asarray(_tile_bank_assignment(tile_banks))
    for frame in frame_list:
        tiles = _padded_tiles(frame)
        bins = (
            (tiles[:, :, 0].astype(numpy.uint16) >> 3) << 10
            | (tiles[:, :, 1].astype(numpy.uint16) >> 3) << 5
            | (tiles[:, :, 2].astype(numpy.uint16) >> 3)
        )
        for bank in range(S2V1_VIDEO_PALETTE_BANKS):
            histograms[bank] += numpy.bincount(
                bins[tile_bank_array == bank].reshape(-1), minlength=32768
            )

    shared_colors = (
        _weighted_median_cut_colors(histograms.sum(axis=0), shared_color_count)
        if shared_color_count
        else []
    )
    banks = []
    bin_ids = numpy.arange(32768)
    for bank in range(S2V1_VIDEO_PALETTE_BANKS):
        if quantizer == "median-cut":
            colors = shared_colors + [
                color
                for color in _weighted_median_cut_colors(
                    histograms[bank],
                    15 - shared_color_count,
                )
                if color not in shared_colors
            ]
        else:
            populated = bin_ids[histograms[bank] > 0]
            ordered = sorted(
                (int(value) for value in populated),
                key=lambda value: (-int(histograms[bank, value]), value),
            )[:15]
            colors = [
                (
                    (((value >> 10) & 0x1F) << 3) | 4,
                    (((value >> 5) & 0x1F) << 3) | 4,
                    ((value & 0x1F) << 3) | 4,
                )
                for value in ordered
            ]
        colors = colors[:15]
        while len(colors) < 15:
            colors.append(colors[-1] if colors else (0, 0, 0))
        banks.append(((0, 0, 0), *colors))
    return tuple(banks)


def _minimum_cost_assignment(costs: list[list[int]]) -> tuple[int, ...]:
    size = len(costs)
    if size == 0 or any(len(row) != size for row in costs):
        raise ValueError("assignment costs must form a non-empty square matrix")
    row_potential = [0] * (size + 1)
    column_potential = [0] * (size + 1)
    matching = [0] * (size + 1)
    predecessor = [0] * (size + 1)
    for row in range(1, size + 1):
        matching[0] = row
        minimum = [2**63 - 1] * (size + 1)
        used = [False] * (size + 1)
        column = 0
        while True:
            used[column] = True
            matched_row = matching[column]
            delta = 2**63 - 1
            next_column = 0
            for candidate in range(1, size + 1):
                if used[candidate]:
                    continue
                reduced = (
                    costs[matched_row - 1][candidate - 1]
                    - row_potential[matched_row]
                    - column_potential[candidate]
                )
                if reduced < minimum[candidate]:
                    minimum[candidate] = reduced
                    predecessor[candidate] = column
                if minimum[candidate] < delta:
                    delta = minimum[candidate]
                    next_column = candidate
            for candidate in range(size + 1):
                if used[candidate]:
                    row_potential[matching[candidate]] += delta
                    column_potential[candidate] -= delta
                else:
                    minimum[candidate] -= delta
            column = next_column
            if matching[column] == 0:
                break
        while True:
            previous = predecessor[column]
            matching[column] = matching[previous]
            column = previous
            if column == 0:
                break
    assignment = [0] * size
    for column in range(1, size + 1):
        assignment[matching[column] - 1] = column - 1
    return tuple(assignment)


def _stabilize_palette_banks(
    banks: tuple[tuple[RgbColor, ...], ...],
    previous_banks: tuple[tuple[RgbColor, ...], ...],
    slot_weights: tuple[tuple[int, ...], ...] | None = None,
) -> tuple[tuple[tuple[RgbColor, ...], ...], tuple[tuple[int, ...], ...]]:
    if len(banks) != S2V1_VIDEO_PALETTE_BANKS or len(previous_banks) != len(banks):
        raise ValueError("S2V1 requires exactly 15 video palette banks")
    if slot_weights is not None and (
        len(slot_weights) != len(banks) or any(len(weights) != 15 for weights in slot_weights)
    ):
        raise ValueError("S2V1 slot weights must contain 15 banks of 15 values")
    stabilized = []
    remappings = []
    for bank_index, (current, previous) in enumerate(zip(banks, previous_banks, strict=True)):
        if len(current) != 16 or len(previous) != 16:
            raise ValueError("each S2V1 palette bank must contain 16 colors")
        costs = [
            [
                sum(
                    (old_channel - new_channel) ** 2
                    for old_channel, new_channel in zip(old, new, strict=True)
                )
                * (
                    1
                    if slot_weights is None
                    else max(1, slot_weights[bank_index][old_index])
                )
                for new in current[1:]
            ]
            for old_index, old in enumerate(previous[1:])
        ]
        assignment = _minimum_cost_assignment(costs)
        stabilized.append((current[0], *(current[index + 1] for index in assignment)))
        remapping = [0] * 16
        for stabilized_index, current_index in enumerate(assignment, start=1):
            remapping[current_index + 1] = stabilized_index
        remappings.append(tuple(remapping))
    return tuple(stabilized), tuple(remappings)


def stabilize_palette_banks(
    banks: tuple[tuple[RgbColor, ...], ...],
    previous_banks: tuple[tuple[RgbColor, ...], ...],
) -> tuple[tuple[RgbColor, ...], ...]:
    stabilized, _ = _stabilize_palette_banks(banks, previous_banks)
    return stabilized


def _resident_palette_banks(
    banks: tuple[tuple[RgbColor, ...], ...],
    previous_banks: tuple[tuple[RgbColor, ...], ...],
    slot_weights: tuple[tuple[int, ...], ...],
    *,
    resident_count: int = 8,
) -> tuple[tuple[RgbColor, ...], ...]:
    resident_banks = []
    for current, previous, weights in zip(
        banks,
        previous_banks,
        slot_weights,
        strict=True,
    ):
        resident_slots = sorted(
            sorted(range(15), key=lambda index: (-weights[index], index))[:resident_count]
        )
        candidates = list(current[1:])
        for slot in resident_slots:
            old = previous[slot + 1]
            nearest = min(
                range(len(candidates)),
                key=lambda index: (
                    sum(
                        (old_channel - new_channel) ** 2
                        for old_channel, new_channel in zip(
                            old,
                            candidates[index],
                            strict=True,
                        )
                    ),
                    index,
                ),
            )
            candidates.pop(nearest)

        available_slots = [slot for slot in range(15) if slot not in resident_slots]
        costs = [
            [
                sum(
                    (old_channel - new_channel) ** 2
                    for old_channel, new_channel in zip(
                        previous[slot + 1],
                        candidate,
                        strict=True,
                    )
                )
                * max(1, weights[slot])
                for candidate in candidates
            ]
            for slot in available_slots
        ]
        assignment = _minimum_cost_assignment(costs)
        colors: list[RgbColor | None] = [None] * 15
        for slot in resident_slots:
            colors[slot] = previous[slot + 1]
        for row, slot in enumerate(available_slots):
            colors[slot] = candidates[assignment[row]]
        if any(color is None for color in colors):
            raise AssertionError("resident palette assignment is incomplete")
        resident_banks.append(((0, 0, 0), *(color for color in colors if color is not None)))
    return tuple(resident_banks)


def encode_frame_indices(
    frame: object,
    banks: tuple[tuple[RgbColor, ...], ...],
    *,
    tile_banks: tuple[int, ...] | None = None,
    index_remappings: tuple[tuple[int, ...], ...] | None = None,
) -> bytes:
    numpy = _require_numpy()
    if len(banks) != S2V1_VIDEO_PALETTE_BANKS:
        raise ValueError("S2V1 requires exactly 15 video palette banks")
    if index_remappings is not None and (
        len(index_remappings) != len(banks)
        or any(len(remapping) != 16 for remapping in index_remappings)
    ):
        raise ValueError("S2V1 index remapping must contain 15 banks of 16 values")
    tiles = _padded_tiles(frame)
    indexed_tiles = numpy.empty((S2V1_TILE_COUNT, 256), dtype=numpy.uint8)
    tile_bank_array = numpy.asarray(_tile_bank_assignment(tile_banks))
    for bank in range(S2V1_VIDEO_PALETTE_BANKS):
        source = tiles[tile_bank_array == bank].astype(numpy.int32)
        palette = numpy.asarray(banks[bank][1:16], dtype=numpy.int32)
        distances = ((source[:, :, None, :] - palette[None, None, :, :]) ** 2).sum(
            axis=3
        )
        encoded = distances.argmin(axis=2).astype(numpy.uint8) + 1
        if index_remappings is not None:
            remapping = numpy.asarray(index_remappings[bank], dtype=numpy.uint8)
            encoded = remapping[encoded]
        indexed_tiles[tile_bank_array == bank] = encoded
    indexed = indexed_tiles.reshape(
        S2V1_TILE_ROWS,
        S2V1_TILE_COLUMNS,
        S2V1_TILE_SIZE,
        S2V1_TILE_SIZE,
    ).transpose(0, 2, 1, 3).reshape(S2V1_PADDED_HEIGHT, S2V1_WIDTH)
    return indexed.tobytes()


def _palette_slot_weights(
    indices: bytes,
    *,
    tile_banks: tuple[int, ...] | None = None,
) -> tuple[tuple[int, ...], ...]:
    numpy = _require_numpy()
    indexed = numpy.frombuffer(indices, dtype=numpy.uint8)
    expected = S2V1_WIDTH * S2V1_PADDED_HEIGHT
    if indexed.size != expected:
        raise ValueError(f"S2V1 indexed frame must contain {expected} pixels")
    tiles = indexed.reshape(
        S2V1_TILE_ROWS,
        S2V1_TILE_SIZE,
        S2V1_TILE_COLUMNS,
        S2V1_TILE_SIZE,
    ).transpose(0, 2, 1, 3).reshape(S2V1_TILE_COUNT, 256)
    tile_bank_array = numpy.asarray(_tile_bank_assignment(tile_banks))
    return tuple(
        tuple(
            int(value)
            for value in numpy.bincount(
                tiles[tile_bank_array == bank].reshape(-1), minlength=16
            )[1:16]
        )
        for bank in range(S2V1_VIDEO_PALETTE_BANKS)
    )


def _entry_record(path: str, payload: bytes) -> dict[str, object]:
    return {
        "path": path,
        "length": len(payload),
        "crc32": f"{zlib.crc32(payload) & 0xFFFFFFFF:08x}",
        "sha256": hashlib.sha256(payload).hexdigest(),
    }


def _write_entry(archive: zipfile.ZipFile, path: str, payload: bytes) -> dict[str, object]:
    info = zipfile.ZipInfo(path, date_time=(1980, 1, 1, 0, 0, 0))
    info.compress_type = zipfile.ZIP_STORED
    info.create_system = 3
    info.external_attr = 0o100644 << 16
    archive.writestr(info, payload)
    return _entry_record(path, payload)


def encode_rgb_frames(
    frames: Iterable[object],
    output_path: str | os.PathLike[str],
    *,
    gop_size: int = S2V1_GOP_SIZE,
    quality_profile: str = "legacy",
) -> S2V1EncodeSummary:
    if gop_size <= 0:
        raise ValueError("S2V1 GOP size must be positive")
    if quality_profile not in S2V1_QUALITY_PROFILES:
        raise ValueError(f"unsupported S2V1 quality profile: {quality_profile}")
    destination = Path(output_path)
    destination.parent.mkdir(parents=True, exist_ok=True)
    descriptor, temporary_name = tempfile.mkstemp(
        prefix=f".{destination.name}.", suffix=".tmp", dir=destination.parent
    )
    os.close(descriptor)
    temporary = Path(temporary_name)
    spatial_profile = quality_profile in (
        "spatial",
        "spatial-resident",
        "spatial-shared",
    )
    tile_banks = _spatial_tile_banks() if spatial_profile else None
    quantizer = "median-cut" if spatial_profile else "frequency"
    shared_color_count = 3 if quality_profile == "spatial-shared" else 0
    frame_count = 0
    gops = []
    previous_banks = None
    previous_slot_weights = None
    try:
        with zipfile.ZipFile(temporary, "w", allowZip64=True) as archive:
            tilemap = build_static_tilemap(generation=1, tile_banks=tile_banks)
            tilemap_record = _write_entry(archive, "tilemap.bin", tilemap)
            iterator = iter(frames)
            for gop_index, chunk in enumerate(
                iter(lambda: tuple(itertools.islice(iterator, gop_size)), ())
            ):
                quantization_banks = build_gop_palette_banks(
                    chunk,
                    tile_banks=tile_banks,
                    quantizer=quantizer,
                    shared_color_count=shared_color_count,
                )
                banks = quantization_banks
                encoding_banks = quantization_banks
                index_remappings = None
                if quality_profile == "spatial-resident" and previous_banks is not None:
                    assert previous_slot_weights is not None
                    banks = _resident_palette_banks(
                        banks,
                        previous_banks,
                        previous_slot_weights,
                    )
                    encoding_banks = banks
                elif quality_profile in ("stable", "spatial", "spatial-shared") and previous_banks is not None:
                    banks, index_remappings = _stabilize_palette_banks(
                        banks,
                        previous_banks,
                        previous_slot_weights,
                    )
                palette_generation = gop_index + 1
                palette_path = f"gops/{gop_index:06d}/palette.bin"
                palette_record = _write_entry(
                    archive,
                    palette_path,
                    build_palette_packet(banks, generation=palette_generation),
                )
                frame_records = []
                last_indices = None
                for frame in chunk:
                    generation = frame_count + 1
                    indices = encode_frame_indices(
                        frame,
                        encoding_banks,
                        tile_banks=tile_banks,
                        index_remappings=index_remappings,
                    )
                    packets = build_frame_packets(
                        indices,
                        frame_index=frame_count,
                        generation=generation,
                        palette_generation=palette_generation,
                    )
                    prefix = f"gops/{gop_index:06d}/frames/{frame_count:08d}"
                    asset_record = _write_entry(
                        archive, f"{prefix}.asset.bin", packets.asset_packet
                    )
                    scene_record = _write_entry(
                        archive, f"{prefix}.scene.bin", packets.scene_packet
                    )
                    frame_records.append(
                        {
                            "index": frame_count,
                            "pts": [frame_count, S2V1_FPS],
                            "generation": generation,
                            "asset": asset_record,
                            "scene": scene_record,
                        }
                    )
                    frame_count += 1
                    last_indices = indices
                previous_banks = banks
                assert last_indices is not None
                previous_slot_weights = _palette_slot_weights(
                    last_indices,
                    tile_banks=tile_banks,
                )
                gops.append(
                    {
                        "index": gop_index,
                        "start_frame": frame_records[0]["index"],
                        "frame_count": len(frame_records),
                        "palette_generation": palette_generation,
                        "palette": palette_record,
                        "frames": frame_records,
                    }
                )
            if frame_count == 0:
                raise ValueError("S2V1 input contains no frames")
            manifest = {
                "format": S2V1_FORMAT,
                "version": list(S2V1_VERSION),
                "video": {
                    "width": S2V1_WIDTH,
                    "height": S2V1_HEIGHT,
                    "padded_height": S2V1_PADDED_HEIGHT,
                    "tile_size": S2V1_TILE_SIZE,
                    "fps": [S2V1_FPS, 1],
                    "frame_count": frame_count,
                    "gop_size": gop_size,
                    "duration": [frame_count, S2V1_FPS],
                },
                "tilemap_generation": 1,
                "tilemap": tilemap_record,
                "gops": gops,
            }
            if quality_profile != "legacy":
                manifest["encoding"] = {"quality_profile": quality_profile}
            encoded_manifest = (
                json.dumps(manifest, sort_keys=True, separators=(",", ":")) + "\n"
            ).encode("utf-8")
            _write_entry(archive, "manifest.json", encoded_manifest)
        with temporary.open("r+b") as stream:
            os.fsync(stream.fileno())
        os.replace(temporary, destination)
    except BaseException:
        temporary.unlink(missing_ok=True)
        raise

    total_bytes = destination.stat().st_size
    digest = hashlib.sha256(destination.read_bytes()).hexdigest()
    bitrate = round(total_bytes * 8 * S2V1_FPS / frame_count)
    return S2V1EncodeSummary(
        path=destination,
        frame_count=frame_count,
        gop_count=len(gops),
        total_bytes=total_bytes,
        sha256=digest,
        average_bitrate_bps=bitrate,
    )


def _metadata_path(metadata: object) -> str:
    if not isinstance(metadata, dict) or not isinstance(metadata.get("path"), str):
        raise ValueError("S2V1 entry metadata is invalid")
    return metadata["path"]


class S2V1Reader:
    def __init__(self, path: str | os.PathLike[str], *, progress=None) -> None:
        self._progress = progress
        self.path = Path(path)
        try:
            self._archive = zipfile.ZipFile(self.path, "r")
            self.manifest = self._load_manifest()
            self._validate()
        except BaseException:
            archive = getattr(self, "_archive", None)
            if archive is not None:
                archive.close()
            raise

    def __enter__(self) -> S2V1Reader:
        return self

    def __exit__(self, *_: object) -> None:
        self.close()

    def close(self) -> None:
        self._archive.close()

    @property
    def frame_count(self) -> int:
        video = self.manifest["video"]
        assert isinstance(video, dict)
        return int(video["frame_count"])

    def read_tilemap_packet(self) -> bytes:
        return self._read_verified(self.manifest["tilemap"])

    def iter_packet_frames(
        self, *, start_frame: int = 0
    ) -> Iterator[S2V1PlaybackFrame]:
        if not 0 <= start_frame < self.frame_count:
            raise ValueError("S2V1 start frame is outside the video")
        gops = self.manifest["gops"]
        assert isinstance(gops, list)
        for gop in gops:
            assert isinstance(gop, dict)
            frames = gop["frames"]
            assert isinstance(frames, list)
            eligible = [
                frame
                for frame in frames
                if isinstance(frame, dict) and int(frame["index"]) >= start_frame
            ]
            if not eligible:
                continue
            palette = self._read_verified(gop["palette"])
            for index, frame in enumerate(eligible):
                pts = frame["pts"]
                assert isinstance(pts, list)
                yield S2V1PlaybackFrame(
                    frame_index=int(frame["index"]),
                    pts_numerator=int(pts[0]),
                    pts_denominator=int(pts[1]),
                    generation=int(frame["generation"]),
                    gop_index=int(gop["index"]),
                    palette_packet=palette if index == 0 else None,
                    asset_packet=self._read_verified(frame["asset"]),
                    scene_packet=self._read_verified(frame["scene"]),
                )

    def _load_manifest(self) -> dict[str, object]:
        try:
            payload = self._archive.read("manifest.json")
            manifest = json.loads(payload)
        except (KeyError, json.JSONDecodeError, UnicodeDecodeError, zipfile.BadZipFile) as error:
            raise ValueError("invalid S2V1 manifest") from error
        if not isinstance(manifest, dict):
            raise ValueError("S2V1 manifest root must be an object")
        return manifest

    def _validate(self) -> None:
        names = self._archive.namelist()
        if len(names) != len(set(names)):
            raise ValueError("S2V1 container contains duplicate entries")
        for name in names:
            path = Path(name)
            if path.is_absolute() or ".." in path.parts or "\\" in name:
                raise ValueError("S2V1 container contains an unsafe entry path")
        if self.manifest.get("format") != S2V1_FORMAT:
            raise ValueError("unsupported S2V1 format")
        if self.manifest.get("version") != list(S2V1_VERSION):
            raise ValueError("unsupported S2V1 version")
        video = self.manifest.get("video")
        expected_video = {
            "width": S2V1_WIDTH,
            "height": S2V1_HEIGHT,
            "padded_height": S2V1_PADDED_HEIGHT,
            "tile_size": S2V1_TILE_SIZE,
            "fps": [S2V1_FPS, 1],
        }
        if not isinstance(video, dict) or any(
            video.get(key) != value for key, value in expected_video.items()
        ):
            raise ValueError("unsupported S2V1 video parameters")
        gops = self.manifest.get("gops")
        if not isinstance(gops, list) or not gops:
            raise ValueError("S2V1 manifest contains no GOPs")

        metadata = [self.manifest.get("tilemap")]
        frames = []
        for expected_gop, gop in enumerate(gops):
            if not isinstance(gop, dict) or gop.get("index") != expected_gop:
                raise ValueError("S2V1 GOP sequence is invalid")
            metadata.append(gop.get("palette"))
            gop_frames = gop.get("frames")
            if not isinstance(gop_frames, list) or not gop_frames:
                raise ValueError("S2V1 GOP contains no frames")
            for frame in gop_frames:
                if not isinstance(frame, dict):
                    raise ValueError("S2V1 frame record is invalid")
                frames.append((gop, frame))
                metadata.extend((frame.get("asset"), frame.get("scene")))
        if len(frames) != video.get("frame_count"):
            raise ValueError("S2V1 frame count mismatch")
        for expected_frame, (_, frame) in enumerate(frames):
            if frame.get("index") != expected_frame:
                raise ValueError("S2V1 frame sequence is invalid")
            if frame.get("pts") != [expected_frame, S2V1_FPS]:
                raise ValueError("S2V1 frame PTS is invalid")
            if frame.get("generation") != expected_frame + 1:
                raise ValueError("S2V1 frame generation is invalid")

        declared_paths = {_metadata_path(item) for item in metadata}
        if declared_paths | {"manifest.json"} != set(names):
            raise ValueError("S2V1 entry set does not match the manifest")
        for index,item in enumerate(metadata):
            self._read_verified(item)
            if self._progress is not None:self._progress((index+1)/len(metadata))

    def _read_verified(self, metadata: object) -> bytes:
        if not isinstance(metadata, dict):
            raise ValueError("S2V1 entry metadata is invalid")
        path = _metadata_path(metadata)
        try:
            payload = self._archive.read(path)
        except (KeyError, zipfile.BadZipFile) as error:
            raise ValueError(f"invalid S2V1 entry: {path}") from error
        if metadata.get("length") != len(payload):
            raise ValueError(f"S2V1 entry length mismatch: {path}")
        if metadata.get("crc32") != f"{zlib.crc32(payload) & 0xFFFFFFFF:08x}":
            raise ValueError(f"S2V1 entry CRC mismatch: {path}")
        if metadata.get("sha256") != hashlib.sha256(payload).hexdigest():
            raise ValueError(f"S2V1 entry SHA-256 mismatch: {path}")
        return payload

    def iter_frames(self) -> Iterator[S2V1DecodedFrame]:
        tilemap = self._read_verified(self.manifest["tilemap"])
        gops = self.manifest["gops"]
        assert isinstance(gops, list)
        for gop in gops:
            assert isinstance(gop, dict)
            palette = self._read_verified(gop["palette"])
            frames = gop["frames"]
            assert isinstance(frames, list)
            for frame in frames:
                assert isinstance(frame, dict)
                asset = self._read_verified(frame["asset"])
                scene = self._read_verified(frame["scene"])
                pts = frame["pts"]
                assert isinstance(pts, list)
                yield S2V1DecodedFrame(
                    frame_index=int(frame["index"]),
                    pts_numerator=int(pts[0]),
                    pts_denominator=int(pts[1]),
                    rgb=decode_frame_rgb(asset, palette, tilemap, scene),
                )


def decode_frame_rgb(
    asset_packet: bytes,
    palette_packet: bytes,
    tilemap_packet: bytes,
    scene_packet: bytes,
) -> bytes:
    numpy = _require_numpy()
    asset_header, asset_payload = unpack_resource_packet(asset_packet)
    palette_header, palette_payload = unpack_resource_packet(palette_packet)
    tilemap_header, tilemap_payload = unpack_resource_packet(tilemap_packet)
    if (
        asset_header.packet_type is not PacketType.ASSET
        or palette_header.packet_type is not PacketType.PALETTE
        or tilemap_header.packet_type is not PacketType.TILEMAP
    ):
        raise ValueError("S2V1 resource packet type mismatch")
    if len(scene_packet) != 64 + 4096:
        raise ValueError("S2V1 scene packet length mismatch")
    scene = struct.unpack_from("<16I", scene_packet)
    if scene[0] != SCENE_MAGIC or scene[1] != (ABI_MAJOR << 16) | ABI_MINOR:
        raise ValueError("S2V1 scene ABI mismatch")
    if scene[4] != 3 or scene[8] != palette_header.generation:
        raise ValueError("S2V1 scene palette generation mismatch")
    if scene[10] != asset_header.generation or scene[11] != tilemap_header.generation:
        raise ValueError("S2V1 scene resource generation mismatch")
    opcodes = tuple(
        struct.unpack_from("<I", scene_packet, 64 + index * 32)[0] & 0xFF
        for index in range(3)
    )
    if opcodes != (Opcode.CLEAR, Opcode.DRAW_TILE_LAYER, Opcode.END_FRAME):
        raise ValueError("S2V1 scene command sequence mismatch")

    if len(asset_payload) < 48 or len(palette_payload) != 1024:
        raise ValueError("S2V1 resource payload length mismatch")
    base_offset, dimensions, format_stride, payload_size = struct.unpack_from(
        "<4I", asset_payload, 16
    )
    width = dimensions & 0xFFFF
    height = dimensions >> 16
    stride = format_stride & 0xFFFF
    asset_format = (format_stride >> 16) & 0xFF
    asset_generation = format_stride >> 24
    if (
        (width, height, stride, asset_format)
        != (S2V1_ATLAS_WIDTH, S2V1_ATLAS_HEIGHT, S2V1_ATLAS_WIDTH // 2, 1)
        or asset_generation != (asset_header.generation & 0xFF)
        or payload_size != stride * height
    ):
        raise ValueError("S2V1 tile atlas descriptor mismatch")
    packed_atlas = asset_payload[48 + base_offset : 48 + base_offset + payload_size]
    if len(packed_atlas) != payload_size:
        raise ValueError("S2V1 tile atlas is truncated")
    packed_rows = numpy.frombuffer(packed_atlas, dtype=numpy.uint8).reshape(height, stride)
    atlas = numpy.empty((height, width), dtype=numpy.uint8)
    atlas[:, 0::2] = packed_rows & 0xF
    atlas[:, 1::2] = packed_rows >> 4

    dimensions, origin_x, origin_y, tile_size = struct.unpack_from(
        "<4I", tilemap_payload
    )
    if (
        (dimensions & 0xFFFF, dimensions >> 16, origin_x, origin_y, tile_size)
        != (S2V1_TILE_COLUMNS, S2V1_TILE_ROWS, 0, 0, S2V1_TILE_SIZE)
        or len(tilemap_payload) != 16 + S2V1_TILE_COUNT * 4
    ):
        raise ValueError("S2V1 tilemap layout mismatch")
    descriptors = struct.unpack_from(f"<{S2V1_TILE_COUNT}I", tilemap_payload, 16)
    palette_words = numpy.frombuffer(palette_payload, dtype="<u4").reshape(16, 16)
    palette_rgb = numpy.stack(
        (
            (palette_words >> 16) & 0xFF,
            (palette_words >> 8) & 0xFF,
            palette_words & 0xFF,
        ),
        axis=2,
    ).astype(numpy.uint8)
    background = numpy.asarray(
        ((scene[7] >> 16) & 0xFF, (scene[7] >> 8) & 0xFF, scene[7] & 0xFF),
        dtype=numpy.uint8,
    )
    output = numpy.empty((S2V1_PADDED_HEIGHT, S2V1_WIDTH, 3), dtype=numpy.uint8)
    for screen_tile, descriptor in enumerate(descriptors):
        tile_id = descriptor & 0xFFFF
        palette_bank = (descriptor >> 16) & 0xF
        if tile_id >= S2V1_TILE_COUNT or descriptor >> 22:
            raise ValueError("S2V1 tile descriptor is invalid")
        source_x = (tile_id % S2V1_ATLAS_COLUMNS) * S2V1_TILE_SIZE
        source_y = (tile_id // S2V1_ATLAS_COLUMNS) * S2V1_TILE_SIZE
        indices = atlas[
            source_y : source_y + S2V1_TILE_SIZE,
            source_x : source_x + S2V1_TILE_SIZE,
        ]
        pixels = palette_rgb[palette_bank][indices].copy()
        pixels[indices == 0] = background
        target_x = (screen_tile % S2V1_TILE_COLUMNS) * S2V1_TILE_SIZE
        target_y = (screen_tile // S2V1_TILE_COLUMNS) * S2V1_TILE_SIZE
        output[
            target_y : target_y + S2V1_TILE_SIZE,
            target_x : target_x + S2V1_TILE_SIZE,
        ] = pixels
    return output[:S2V1_HEIGHT].tobytes()


def decode_video_frames(
    path: str | os.PathLike[str], *, max_frames: int | None = None,
    resize_filter: str = "legacy",
) -> Iterator[bytes]:
    if resize_filter not in S2V1_RESIZE_FILTERS:
        raise ValueError(f"Unknown S2V1 resize filter: {resize_filter}")
    try:
        import av
    except ModuleNotFoundError as error:
        raise RuntimeError(
            "S2V1 video input requires the project video extra: pip install .[video]"
        ) from error
    numpy = _require_numpy()
    with av.open(str(path)) as container:
        if not container.streams.video:
            raise ValueError("input contains no video stream")
        stream = container.streams.video[0]
        decoded = iter(container.decode(stream))
        try:
            previous = next(decoded)
        except StopIteration as error:
            raise ValueError("input video contains no decoded frames") from error
        start_time = (
            float(previous.pts * previous.time_base)
            if previous.pts is not None and previous.time_base is not None
            else 0.0
        )
        previous_time = 0.0
        emitted = 0
        target_time = 0.0

        def normalize(frame: Any) -> bytes:
            scale = min(S2V1_WIDTH / frame.width, S2V1_HEIGHT / frame.height)
            width = max(1, min(S2V1_WIDTH, round(frame.width * scale)))
            height = max(1, min(S2V1_HEIGHT, round(frame.height * scale)))
            if resize_filter == "legacy":
                resized = frame.reformat(width=width, height=height, format="rgb24")
            else:
                resized = frame.reformat(
                    width=width, height=height, format="rgb24",
                    interpolation=resize_filter.upper(),
                )
            canvas = numpy.zeros((S2V1_HEIGHT, S2V1_WIDTH, 3), dtype=numpy.uint8)
            left = (S2V1_WIDTH - width) // 2
            top = (S2V1_HEIGHT - height) // 2
            canvas[top : top + height, left : left + width] = resized.to_ndarray()
            return canvas.tobytes()

        previous_rgb = normalize(previous)
        for current in decoded:
            current_time = (
                float(current.pts * current.time_base) - start_time
                if current.pts is not None and current.time_base is not None
                else previous_time + 1.0 / S2V1_FPS
            )
            midpoint = (previous_time + current_time) / 2
            while target_time <= midpoint + 1e-12:
                yield previous_rgb
                emitted += 1
                if max_frames is not None and emitted >= max_frames:
                    return
                target_time = emitted / S2V1_FPS
            previous = current
            previous_time = current_time
            previous_rgb = normalize(current)
        if max_frames is None or emitted < max_frames:
            yield previous_rgb