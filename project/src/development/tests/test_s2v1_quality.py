import zipfile

import numpy as np

from pynq_multimodal_game.gpu_abi import (
    PacketType,
    pack_resource_packet,
    unpack_resource_packet,
)
from pynq_multimodal_game.video_codec import (
    S2V1_HEIGHT,
    S2V1_WIDTH,
    S2V1Reader,
    decode_frame_rgb,
    encode_rgb_frames,
)


def _tile_pattern(
    primary: tuple[int, int, int],
    secondary: tuple[int, int, int],
    tertiary: tuple[int, int, int],
) -> bytes:
    frame = np.empty((S2V1_HEIGHT, S2V1_WIDTH, 3), dtype=np.uint8)
    phase = np.arange(S2V1_WIDTH) % 16
    frame[:, phase < 10] = primary
    frame[:, (phase >= 10) & (phase < 14)] = secondary
    frame[:, phase >= 14] = tertiary
    return frame.tobytes()


def _boundary_flash_mae(path) -> tuple[float, list[bytes], list[tuple[int, int, int]]]:
    with S2V1Reader(path) as reader, zipfile.ZipFile(path) as archive:
        playback = list(reader.iter_packet_frames())
        decoded = [frame.rgb for frame in reader.iter_frames()]
        gops = reader.manifest["gops"]
        first_palette = archive.read(gops[0]["palette"]["path"])
        second_palette = archive.read(gops[1]["palette"]["path"])
        first_header, _ = unpack_resource_packet(first_palette)
        _, second_payload = unpack_resource_packet(second_palette)
        simulated_palette = pack_resource_packet(
            PacketType.PALETTE,
            second_payload,
            target_id=0,
            generation=first_header.generation,
        )
        flashed = decode_frame_rgb(
            playback[0].asset_packet,
            simulated_palette,
            reader.read_tilemap_packet(),
            playback[0].scene_packet,
        )
        expected = np.frombuffer(decoded[0], dtype=np.uint8).astype(np.int16)
        actual = np.frombuffer(flashed, dtype=np.uint8).astype(np.int16)
        packet_sizes = [
            (
                len(frame.palette_packet or b""),
                len(frame.asset_packet),
                len(frame.scene_packet),
            )
            for frame in playback
        ]
        return float(np.abs(actual - expected).mean()), decoded, packet_sizes


def test_stable_profile_reduces_palette_boundary_flash_without_rgb_change(tmp_path) -> None:
    red = (252, 4, 4)
    green = (4, 252, 4)
    blue = (4, 4, 252)
    frames = (
        _tile_pattern(red, green, blue),
        _tile_pattern(green, red, blue),
    )
    legacy_path = tmp_path / "legacy.s2v"
    stable_path = tmp_path / "stable.s2v"
    encode_rgb_frames(frames, legacy_path, gop_size=1)
    encode_rgb_frames(frames, stable_path, gop_size=1, quality_profile="stable")

    legacy_flash, legacy_rgb, legacy_packets = _boundary_flash_mae(legacy_path)
    stable_flash, stable_rgb, stable_packets = _boundary_flash_mae(stable_path)

    assert stable_rgb == legacy_rgb
    assert stable_packets == legacy_packets
    assert legacy_flash > 1.0
    assert stable_flash <= legacy_flash * 0.1
