import struct
import zipfile

import numpy as np
import pytest

from pynq_multimodal_game.gpu_abi import (
    Opcode,
    PacketType,
    unpack_resource_packet,
)
from pynq_multimodal_game.video_codec import (
    S2V1_ATLAS_WIDTH,
    S2V1_HEIGHT,
    S2V1_PADDED_HEIGHT,
    S2V1_TILE_COUNT,
    S2V1_WIDTH,
    S2V1Reader,
    build_gop_palette_banks,
    build_frame_packets,
    build_palette_packet,
    build_static_tilemap,
    encode_frame_indices,
    encode_rgb_frames,
    frame_indices_to_atlas,
    stabilize_palette_banks,
)


def test_static_tilemap_matches_screen_grid() -> None:
    header, payload = unpack_resource_packet(build_static_tilemap(generation=7))

    assert header.packet_type is PacketType.TILEMAP
    assert header.generation == 7
    assert len(payload) == 16 + S2V1_TILE_COUNT * 4
    dimensions, origin_x, origin_y, tile_size = struct.unpack_from("<4I", payload)
    assert dimensions == (12 << 16) | 20
    assert (origin_x, origin_y, tile_size) == (0, 0, 16)
    descriptors = struct.unpack_from(f"<{S2V1_TILE_COUNT}I", payload, 16)
    assert descriptors[0] == 0
    assert descriptors[16] == 16 | (1 << 16)
    assert descriptors[-1] == 239 | (14 << 16)


def test_frame_indices_are_reordered_into_atlas_tiles() -> None:
    indices = bytearray(S2V1_WIDTH * S2V1_PADDED_HEIGHT)
    for tile_id in range(S2V1_TILE_COUNT):
        value = tile_id & 0xF
        tile_x = tile_id % 20
        tile_y = tile_id // 20
        for y in range(16):
            start = (tile_y * 16 + y) * S2V1_WIDTH + tile_x * 16
            indices[start : start + 16] = bytes((value,)) * 16

    atlas = frame_indices_to_atlas(bytes(indices))

    assert (atlas.width, atlas.height) == (256, 240)
    for tile_id in (0, 15, 16, 239):
        x = (tile_id % 16) * 16
        y = (tile_id // 16) * 16
        assert atlas.pixels[y * S2V1_ATLAS_WIDTH + x] == tile_id & 0xF


def test_frame_packets_use_existing_c4m7_abi() -> None:
    indices = bytes((1,)) * (S2V1_WIDTH * S2V1_PADDED_HEIGHT)
    packets = build_frame_packets(
        indices,
        frame_index=9,
        generation=11,
        palette_generation=5,
        tilemap_generation=7,
    )

    asset_header, asset_payload = unpack_resource_packet(packets.asset_packet)
    assert asset_header.packet_type is PacketType.ASSET
    assert asset_header.generation == 11
    assert len(packets.asset_packet) == 30_897
    assert len(asset_payload) == 30_833
    scene_words = struct.unpack_from("<16I", packets.scene_packet)
    assert len(packets.scene_packet) == 4_160
    assert scene_words[2:5] == (9, 9, 3)
    assert scene_words[8] == 5
    assert scene_words[10:12] == (11, 7)
    command_words = struct.unpack_from("<24I", packets.scene_packet, 64)
    assert tuple(command_words[index] & 0xFF for index in (0, 8, 16)) == (
        Opcode.CLEAR,
        Opcode.DRAW_TILE_LAYER,
        Opcode.END_FRAME,
    )


def test_palette_and_input_validation() -> None:
    banks = tuple(
        tuple((bank, color, 255 - color) for color in range(16))
        for bank in range(15)
    )
    header, payload = unpack_resource_packet(
        build_palette_packet(banks, generation=3)
    )
    assert header.packet_type is PacketType.PALETTE
    assert len(payload) == 1_024

    with pytest.raises(ValueError, match="exactly 15"):
        build_palette_packet(banks[:-1], generation=3)
    with pytest.raises(ValueError, match="61440"):
        frame_indices_to_atlas(bytes(S2V1_WIDTH * S2V1_HEIGHT))
    malformed = bytearray(S2V1_WIDTH * S2V1_PADDED_HEIGHT)
    malformed[0] = 16
    with pytest.raises(ValueError, match="4 bits"):
        frame_indices_to_atlas(bytes(malformed))


def _solid_rgb(red: int, green: int, blue: int) -> bytes:
    return bytes((red, green, blue)) * (S2V1_WIDTH * S2V1_HEIGHT)


def _spatial_palette_frame() -> bytes:
    frame = np.empty((S2V1_HEIGHT, S2V1_WIDTH, 3), dtype=np.uint8)
    pattern = np.add.outer(np.arange(64), np.arange(64)) % 14
    for region_y in range(3):
        for region_x in range(5):
            bank = region_y * 5 + region_x
            colors = []
            for color_index in range(14):
                value = ((bank * 14 + color_index + 1) * 1451) % 32768
                colors.append(
                    (
                        (((value >> 10) & 0x1F) << 3) | 4,
                        (((value >> 5) & 0x1F) << 3) | 4,
                        ((value & 0x1F) << 3) | 4,
                    )
                )
            y0 = region_y * 64
            y1 = min(y0 + 64, S2V1_HEIGHT)
            x0 = region_x * 64
            frame[y0:y1, x0 : x0 + 64] = np.asarray(colors, dtype=np.uint8)[
                pattern[: y1 - y0]
            ]
    return frame.tobytes()


def test_gop_quantization_is_deterministic_and_opaque() -> None:
    frames = (
        _solid_rgb(252, 4, 4),
        _solid_rgb(4, 252, 4),
    )

    first = build_gop_palette_banks(frames)
    second = build_gop_palette_banks(frames)

    assert first == second
    indices = encode_frame_indices(frames[0], first)
    assert len(indices) == S2V1_WIDTH * S2V1_PADDED_HEIGHT
    assert min(indices) >= 1
    assert max(indices) <= 15


def test_palette_stabilization_restores_previous_slot_order() -> None:
    colors = tuple((index * 8 + 4, 252 - index * 8, index * 4 + 4) for index in range(15))
    previous_bank = ((0, 0, 0), *colors)
    current_bank = ((0, 0, 0), *colors[5:], *colors[:5])

    stabilized = stabilize_palette_banks(
        (current_bank,) * 15,
        (previous_bank,) * 15,
    )

    assert stabilized == (previous_bank,) * 15


def test_stable_profile_is_deterministic_and_keeps_packet_budget(tmp_path) -> None:
    frames = (
        _solid_rgb(252, 4, 4),
        _solid_rgb(4, 252, 4),
    )
    legacy_path = tmp_path / "legacy.s2v"
    first_path = tmp_path / "stable-first.s2v"
    second_path = tmp_path / "stable-second.s2v"

    legacy = encode_rgb_frames(frames, legacy_path, gop_size=1)
    first = encode_rgb_frames(frames, first_path, gop_size=1, quality_profile="stable")
    second = encode_rgb_frames(frames, second_path, gop_size=1, quality_profile="stable")

    assert first.sha256 == second.sha256
    assert first_path.read_bytes() == second_path.read_bytes()
    with S2V1Reader(legacy_path) as legacy_reader, S2V1Reader(first_path) as stable_reader:
        assert stable_reader.manifest["encoding"] == {"quality_profile": "stable"}
        legacy_packets = list(legacy_reader.iter_packet_frames())
        stable_packets = list(stable_reader.iter_packet_frames())
        assert [len(frame.asset_packet) for frame in stable_packets] == [
            len(frame.asset_packet) for frame in legacy_packets
        ]
        assert [len(frame.scene_packet) for frame in stable_packets] == [
            len(frame.scene_packet) for frame in legacy_packets
        ]
        assert [len(frame.palette_packet or b"") for frame in stable_packets] == [
            len(frame.palette_packet or b"") for frame in legacy_packets
        ]
    assert first.total_bytes > legacy.total_bytes


def test_spatial_profile_uses_contiguous_banks_and_reduces_error(tmp_path) -> None:
    source = _spatial_palette_frame()
    legacy_path = tmp_path / "legacy.s2v"
    spatial_path = tmp_path / "spatial.s2v"

    encode_rgb_frames((source,), legacy_path)
    encode_rgb_frames((source,), spatial_path, quality_profile="spatial")

    with S2V1Reader(legacy_path) as legacy_reader, S2V1Reader(spatial_path) as spatial_reader:
        legacy_rgb = next(legacy_reader.iter_frames()).rgb
        spatial_rgb = next(spatial_reader.iter_frames()).rgb
        _, tilemap_payload = unpack_resource_packet(spatial_reader.read_tilemap_packet())
        descriptors = struct.unpack_from(f"<{S2V1_TILE_COUNT}I", tilemap_payload, 16)
        assert [(descriptors[index] >> 16) & 0xF for index in (0, 3, 4, 79, 80, 239)] == [
            0,
            0,
            1,
            4,
            5,
            14,
        ]
        legacy_packets = list(legacy_reader.iter_packet_frames())
        spatial_packets = list(spatial_reader.iter_packet_frames())

    source_array = np.frombuffer(source, dtype=np.uint8).astype(np.int16)
    legacy_error = np.abs(np.frombuffer(legacy_rgb, dtype=np.uint8).astype(np.int16) - source_array)
    spatial_error = np.abs(np.frombuffer(spatial_rgb, dtype=np.uint8).astype(np.int16) - source_array)
    assert spatial_error.max() == 0
    assert legacy_error.mean() > 10.0
    assert [len(frame.asset_packet) for frame in spatial_packets] == [
        len(frame.asset_packet) for frame in legacy_packets
    ]
    assert [len(frame.scene_packet) for frame in spatial_packets] == [
        len(frame.scene_packet) for frame in legacy_packets
    ]


@pytest.mark.parametrize("profile", ("spatial", "spatial-resident", "spatial-shared"))
def test_spatial_profiles_are_deterministic_across_gops(tmp_path, profile) -> None:
    frames = (
        _spatial_palette_frame(),
        _solid_rgb(20, 132, 236),
    )
    first_path = tmp_path / f"{profile}-first.s2v"
    second_path = tmp_path / f"{profile}-second.s2v"

    first = encode_rgb_frames(frames, first_path, gop_size=1, quality_profile=profile)
    second = encode_rgb_frames(frames, second_path, gop_size=1, quality_profile=profile)

    assert first.sha256 == second.sha256
    with S2V1Reader(first_path) as reader:
        assert reader.manifest["encoding"] == {"quality_profile": profile}
        packets = list(reader.iter_packet_frames())
    assert [len(frame.palette_packet or b"") for frame in packets] == [1088, 1088]
    assert [len(frame.asset_packet) for frame in packets] == [30897, 30897]
    assert [len(frame.scene_packet) for frame in packets] == [4160, 4160]


def test_unknown_quality_profile_is_rejected(tmp_path) -> None:
    with pytest.raises(ValueError, match="unsupported S2V1 quality profile"):
        encode_rgb_frames(
            (_solid_rgb(0, 0, 0),),
            tmp_path / "invalid.s2v",
            quality_profile="unknown",
        )


def test_container_is_deterministic_and_round_trips_hardware_rgb(tmp_path) -> None:
    frames = (
        _solid_rgb(252, 4, 4),
        _solid_rgb(4, 252, 4),
    )
    first_path = tmp_path / "first.s2v"
    second_path = tmp_path / "second.s2v"
    explicit_legacy_path = tmp_path / "explicit-legacy.s2v"

    first = encode_rgb_frames(frames, first_path, gop_size=2)
    second = encode_rgb_frames(frames, second_path, gop_size=2)
    explicit_legacy = encode_rgb_frames(
        frames,
        explicit_legacy_path,
        gop_size=2,
        quality_profile="legacy",
    )

    assert first.frame_count == 2
    assert first.gop_count == 1
    assert first.sha256 == second.sha256
    assert first.sha256 == explicit_legacy.sha256
    assert first_path.read_bytes() == second_path.read_bytes()
    assert first_path.read_bytes() == explicit_legacy_path.read_bytes()
    with zipfile.ZipFile(first_path) as archive:
        assert archive.namelist()[0] == "tilemap.bin"
        assert archive.namelist()[-1] == "manifest.json"
        assert all(info.compress_type == zipfile.ZIP_STORED for info in archive.infolist())
        assert all(info.date_time == (1980, 1, 1, 0, 0, 0) for info in archive.infolist())

    with S2V1Reader(first_path) as reader:
        decoded = list(reader.iter_frames())
    assert reader.frame_count == 2
    assert [frame.frame_index for frame in decoded] == [0, 1]
    assert [frame.rgb for frame in decoded] == list(frames)


def test_reader_exposes_verified_playback_packets_and_seek_palette(tmp_path) -> None:
    source = tmp_path / "packets.s2v"
    encode_rgb_frames(
        (
            _solid_rgb(252, 4, 4),
            _solid_rgb(4, 252, 4),
            _solid_rgb(4, 4, 252),
        ),
        source,
        gop_size=2,
    )

    with S2V1Reader(source) as reader, zipfile.ZipFile(source) as archive:
        assert reader.read_tilemap_packet() == archive.read("tilemap.bin")
        playback = list(reader.iter_packet_frames())
        assert [frame.frame_index for frame in playback] == [0, 1, 2]
        assert [frame.gop_index for frame in playback] == [0, 0, 1]
        assert [frame.generation for frame in playback] == [1, 2, 3]
        assert [frame.palette_packet is not None for frame in playback] == [
            True,
            False,
            True,
        ]
        gops = reader.manifest["gops"]
        assert isinstance(gops, list)
        first_gop = gops[0]
        assert isinstance(first_gop, dict)
        first_frames = first_gop["frames"]
        assert isinstance(first_frames, list)
        first_frame = first_frames[0]
        assert isinstance(first_frame, dict)
        assert playback[0].palette_packet == archive.read(first_gop["palette"]["path"])
        assert playback[0].asset_packet == archive.read(first_frame["asset"]["path"])
        assert playback[0].scene_packet == archive.read(first_frame["scene"]["path"])

        sought = list(reader.iter_packet_frames(start_frame=1))
        assert [frame.frame_index for frame in sought] == [1, 2]
        assert [frame.palette_packet is not None for frame in sought] == [True, True]
        with pytest.raises(ValueError, match="outside"):
            list(reader.iter_packet_frames(start_frame=-1))
        with pytest.raises(ValueError, match="outside"):
            list(reader.iter_packet_frames(start_frame=reader.frame_count))


def test_reader_rejects_corrupted_resource_before_playback(tmp_path) -> None:
    source = tmp_path / "source.s2v"
    corrupted = tmp_path / "corrupted.s2v"
    encode_rgb_frames((_solid_rgb(252, 4, 4),), source)
    with zipfile.ZipFile(source) as input_archive, zipfile.ZipFile(
        corrupted, "w", compression=zipfile.ZIP_STORED
    ) as output_archive:
        for name in input_archive.namelist():
            payload = bytearray(input_archive.read(name))
            if name == "tilemap.bin":
                payload[-1] ^= 0xFF
            output_archive.writestr(name, payload)

    with pytest.raises(ValueError, match="CRC mismatch"):
        S2V1Reader(corrupted)


def test_empty_input_does_not_replace_existing_output(tmp_path) -> None:
    output = tmp_path / "existing.s2v"
    output.write_bytes(b"existing")

    with pytest.raises(ValueError, match="no frames"):
        encode_rgb_frames((), output)

    assert output.read_bytes() == b"existing"

def test_reader_reports_real_validation_progress_and_only_completes_after_checks(tmp_path):
    path=tmp_path/'progress.s2v'
    encode_rgb_frames([np.zeros((180,320,3),dtype=np.uint8)]*3,path)
    progress=[]
    with S2V1Reader(path,progress=progress.append):pass
    assert len(progress)>3 and progress==sorted(progress) and progress[-1]==1
    assert 0<progress[0]<1
