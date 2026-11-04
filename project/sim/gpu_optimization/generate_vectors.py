"""Run: python sim/gpu_optimization/generate_vectors.py.
Output: local vectors/*.mem; next: run_compare.tcl. No hardware access.
"""
from __future__ import annotations

import json
from pathlib import Path
import struct
import sys
import zlib


REPO_ROOT = Path(__file__).resolve().parents[2] / "src/development"
sys.path.insert(0, str(REPO_ROOT / "python"))

from pynq_multimodal_game.gpu_abi import GpuCommand, SceneHeader, pack_command_bank
from pynq_multimodal_game.raster_trace import (
    apply_writes,
    clear_fill_writes,
    raster_trace_crc32,
)


COMMANDS = (
    GpuCommand.clear(0x12),
    GpuCommand.fill_rect(x=-2, y=-1, width=4, height=3, token=0xA5),
    GpuCommand.fill_rect(x=318, y=178, width=5, height=4, token=0x7E),
    GpuCommand.fill_rect(x=10, y=10, width=0, height=7, token=0x22),
    GpuCommand.fill_rect(x=400, y=200, width=4, height=4, token=0x11),
    GpuCommand.end_frame(),
)


def main() -> None:
    vector_dir = Path(__file__).with_name("vectors")
    vector_dir.mkdir(exist_ok=True)
    command_bank = pack_command_bank(COMMANDS)
    header = SceneHeader(
        frame_id=0xC4020001,
        submit_seq=0xC4020001,
        command_count=len(COMMANDS),
        camera_x=0,
        camera_y=0,
        background_color=(0, 0, 0),
        predicted_cycles=57644,
    )
    payload = header.to_bytes() + command_bank
    writes = clear_fill_writes(COMMANDS)
    tokens = apply_writes(writes)

    command_lines = (
        f"{word:016x}" for word in struct.unpack("<512Q", command_bank)
    )
    write_lines = (
        f"{((write.token << 16) | write.address):06x}" for write in writes
    )
    (vector_dir / "c4m2_commands.mem").write_text(
        "\n".join(command_lines) + "\n", encoding="ascii"
    )
    (vector_dir / "c4m2_payload.mem").write_text(
        "\n".join(f"{word:016x}" for word in struct.unpack("<520Q", payload))
        + "\n",
        encoding="ascii",
    )
    (vector_dir / "c4m2_writes.mem").write_text(
        "\n".join(write_lines) + "\n", encoding="ascii"
    )
    (vector_dir / "c4m2_tokens.mem").write_text(
        "\n".join(f"{token:02x}" for token in tokens) + "\n",
        encoding="ascii",
    )
    trace_crc32 = raster_trace_crc32(writes)
    token_crc32 = zlib.crc32(tokens) & 0xFFFFFFFF
    payload_crc32 = zlib.crc32(payload) & 0xFFFFFFFF
    manifest = {
        "command_count": len(COMMANDS),
        "write_count": len(writes),
        "trace_crc32": trace_crc32,
        "trace_crc32_hex": f"0x{trace_crc32:08X}",
        "token_crc32": token_crc32,
        "token_crc32_hex": f"0x{token_crc32:08X}",
        "payload_crc32": payload_crc32,
        "payload_crc32_hex": f"0x{payload_crc32:08X}",
    }
    (vector_dir / "c4m2_manifest.json").write_text(
        json.dumps(manifest, indent=2) + "\n", encoding="ascii"
    )
    print(json.dumps(manifest, sort_keys=True))


if __name__ == "__main__":
    main()