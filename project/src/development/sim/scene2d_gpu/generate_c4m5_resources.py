from __future__ import annotations

import json
from pathlib import Path
import struct
import sys
import zlib


REPO_ROOT = Path(__file__).parents[2]
sys.path.insert(0, str(REPO_ROOT / "python"))

from pynq_multimodal_game.demo import create_demo_assets
from pynq_multimodal_game.gpu_abi import (
    GpuCommand,
    SceneHeader,
    pack_assets,
    pack_command_bank,
    pack_tile_descriptor,
)
from pynq_multimodal_game.raster_trace import (
    apply_writes,
    raster_trace_crc32,
    raster_writes,
)


FRAME_ID = 0xC4050001
SCREEN_X = -8
SCREEN_Y = 10


def main() -> None:
    vector_dir = Path(__file__).with_name("vectors")
    vector_dir.mkdir(exist_ok=True)

    demo_assets = create_demo_assets()
    assets = (
        demo_assets.renderer.sprite_atlas,
        demo_assets.renderer.tile_atlas,
    )
    tilemaps = (demo_assets.ground,)
    packed_assets = pack_assets(assets)
    layer = tilemaps[0]
    commands = (
        GpuCommand.clear(0x00),
        GpuCommand.draw_tile_layer(
            asset_id=1,
            tilemap_id=0,
            screen_x=SCREEN_X,
            screen_y=SCREEN_Y,
            width_tiles=layer.width_tiles,
            height_tiles=layer.height_tiles,
            tile_size=layer.tile_size,
        ),
        GpuCommand.blit_index4(
            asset_id=0,
            palette_bank=0,
            dst_x=112,
            dst_y=82,
            width=16,
            height=16,
            src_x=0,
            src_y=0,
        ),
        GpuCommand.fill_rect(x=2, y=2, width=10, height=4, token=0xF5),
        GpuCommand.end_frame(),
    )
    command_bank = pack_command_bank(commands)
    header = SceneHeader(
        frame_id=FRAME_ID,
        submit_seq=FRAME_ID,
        command_count=len(commands),
        camera_x=-SCREEN_X,
        camera_y=0,
        background_color=(37, 58, 94),
    )
    payload = header.to_bytes() + command_bank
    writes = raster_writes(commands, assets=assets, tilemaps=tilemaps)
    tokens = apply_writes(writes)

    (vector_dir / "c4m5_atlas.mem").write_text(
        "".join(f"{value:02x}\n" for value in packed_assets.payload),
        encoding="ascii",
    )
    (vector_dir / "c4m5_tilemap.mem").write_text(
        "".join(f"{pack_tile_descriptor(tile):08x}\n" for tile in layer.tiles),
        encoding="ascii",
    )
    (vector_dir / "c4m5_payload.mem").write_text(
        "".join(f"{word:016x}\n" for word in struct.unpack("<520Q", payload)),
        encoding="ascii",
    )
    (vector_dir / "c4m5_writes.mem").write_text(
        "".join(f"{((write.token << 16) | write.address):06x}\n" for write in writes),
        encoding="ascii",
    )
    (vector_dir / "c4m5_tokens.mem").write_text(
        "".join(f"{token:02x}\n" for token in tokens),
        encoding="ascii",
    )

    trace_crc32 = raster_trace_crc32(writes)
    token_crc32 = zlib.crc32(tokens) & 0xFFFFFFFF
    manifest = {
        "frame_id": FRAME_ID,
        "command_count": len(commands),
        "write_count": len(writes),
        "trace_crc32": trace_crc32,
        "trace_crc32_hex": f"0x{trace_crc32:08X}",
        "token_crc32": token_crc32,
        "token_crc32_hex": f"0x{token_crc32:08X}",
        "payload_crc32": zlib.crc32(payload) & 0xFFFFFFFF,
        "atlas_bytes": len(packed_assets.payload),
        "assets": [
            {
                "asset_id": asset_id,
                "base_byte": descriptor.base_offset,
                "base_pixel": descriptor.base_offset * 2,
                "width": descriptor.width,
                "height": descriptor.height,
                "stride_pixels": descriptor.stride_bytes * 2,
            }
            for asset_id, descriptor in enumerate(packed_assets.descriptors)
        ],
        "tilemap": {
            "tilemap_id": 0,
            "width_tiles": layer.width_tiles,
            "height_tiles": layer.height_tiles,
            "tile_size": layer.tile_size,
            "descriptor_count": len(layer.tiles),
        },
    }
    (vector_dir / "c4m5_manifest.json").write_text(
        json.dumps(manifest, indent=2) + "\n",
        encoding="ascii",
    )
    print(json.dumps(manifest, sort_keys=True))


if __name__ == "__main__":
    main()
