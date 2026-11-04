from __future__ import annotations

import argparse
import gc
import os
from pathlib import Path
import struct
import time
from typing import Any
import xml.etree.ElementTree as ET
import zlib


EXPECTED_BUILD_ID = 0xC0040100
BUILD_ID_IP = "build_id_gpio"
DMA_IP = "axi_dma"
UPLOAD_STATUS_IP = "upload_status_gpio"
PACKET_STATUS_IP = "packet_status_gpio"
COMMAND_STATUS_IP = "command_status_gpio"
ERROR_STATUS_IP = "error_status_gpio"
READ_ADDRESS_IP = "command_read_address_gpio"
READ_DATA_IP = "command_read_data_gpio"
GPIO_DATA_OFFSET = 0x0
GPIO2_DATA_OFFSET = 0x8
COMMAND_BANK_BYTES = 4096
PAYLOAD_BYTES = 64 + COMMAND_BANK_BYTES


def hwh_address(hwh: Path, instance: str) -> tuple[int, int]:
    root = ET.parse(hwh).getroot()
    for memory_range in root.iter("MEMRANGE"):
        if memory_range.get("INSTANCE") != instance:
            continue
        base = int(memory_range.attrib["BASEVALUE"], 0)
        high = int(memory_range.attrib["HIGHVALUE"], 0)
        return base, high - base + 1
    raise KeyError(f"{instance!r} has no MEMRANGE in {hwh}")


def ip_address(overlay: Any, hwh: Path, instance: str) -> tuple[int, int]:
    description = overlay.ip_dict.get(instance)
    if description is not None:
        return int(description["phys_addr"]), int(description["addr_range"])
    return hwh_address(hwh, instance)


def decode_accepted_status(value: int) -> tuple[int, int, bool]:
    return value & 0x1FF, (value >> 9) & 1, bool((value >> 10) & 1)


def wait_for_value(
    mmio: Any,
    offset: int,
    expected: int,
    timeout_seconds: float,
    label: str,
) -> None:
    deadline = time.perf_counter() + timeout_seconds
    while mmio.read(offset) != expected:
        if time.perf_counter() >= deadline:
            actual = mmio.read(offset)
            raise TimeoutError(f"{label} timeout: expected {expected}, got {actual}")


def transfer_payload(
    dma: Any,
    allocate: Any,
    packet_mmio: Any,
    payload: bytes,
    timeout_seconds: float,
) -> None:
    import numpy as np

    buffer = allocate(shape=(len(payload),), dtype=np.uint8)
    try:
        buffer[:] = np.frombuffer(payload, dtype=np.uint8)
        buffer.flush()
        expected_packet = (packet_mmio.read(GPIO_DATA_OFFSET) + 1) & 0xFFFFFFFF
        dma.sendchannel.transfer(buffer)
        dma.sendchannel.wait()
        wait_for_value(
            packet_mmio,
            GPIO_DATA_OFFSET,
            expected_packet,
            timeout_seconds,
            "completed packet count",
        )
    finally:
        buffer.freebuffer()


def read_command_bank(address_mmio: Any, data_mmio: Any) -> bytes:
    output = bytearray()
    for address in range(COMMAND_BANK_BYTES // 8):
        address_mmio.write(GPIO_DATA_OFFSET, address)
        low = data_mmio.read(GPIO_DATA_OFFSET)
        high = data_mmio.read(GPIO2_DATA_OFFSET)
        output.extend(struct.pack("<II", low, high))
    return bytes(output)


def build_scene_payload(submit_seq: int) -> tuple[bytes, bytes, int]:
    from pynq_multimodal_game.demo import (
        build_demo_scene,
        create_demo_assets,
        create_demo_engine,
    )
    from pynq_multimodal_game.gpu_abi import pack_command_bank
    from pynq_multimodal_game.replay import build_demo_controls
    from pynq_multimodal_game.scene_compiler import SceneCompiler

    assets = create_demo_assets()
    engine = create_demo_engine()
    compiler = SceneCompiler(
        sprite_atlas=assets.renderer.sprite_atlas,
        tile_atlas=assets.renderer.tile_atlas,
        palettes=assets.renderer.palettes,
    )
    state = engine.step(engine.initial_state(), build_demo_controls(1)[0])
    frame = compiler.compile(
        build_demo_scene(state, engine.config, assets),
        submit_seq=submit_seq,
    )
    command_bank = pack_command_bank(frame.commands)
    payload = frame.header.to_bytes() + command_bank
    if len(payload) != PAYLOAD_BYTES:
        raise RuntimeError(f"scene payload has {len(payload)} bytes, expected {PAYLOAD_BYTES}")
    return payload, command_bank, len(frame.commands)


def verify_iteration(
    bitstream: Path,
    iteration: int,
    timeout_seconds: float,
    exercise_all_errors: bool,
) -> None:
    from pynq import MMIO, Overlay, allocate

    hwh = bitstream.with_suffix(".hwh")
    overlay = Overlay(str(bitstream), download=True)

    def mmio(instance: str) -> Any:
        address, size = ip_address(overlay, hwh, instance)
        return MMIO(address, size)

    build_mmio = mmio(BUILD_ID_IP)
    upload_mmio = mmio(UPLOAD_STATUS_IP)
    packet_mmio = mmio(PACKET_STATUS_IP)
    command_mmio = mmio(COMMAND_STATUS_IP)
    error_mmio = mmio(ERROR_STATUS_IP)
    read_address_mmio = mmio(READ_ADDRESS_IP)
    read_data_mmio = mmio(READ_DATA_IP)
    dma = getattr(overlay, DMA_IP)

    build_id = build_mmio.read(GPIO_DATA_OFFSET)
    if build_id != EXPECTED_BUILD_ID:
        raise RuntimeError(
            f"BUILD_ID mismatch: expected 0x{EXPECTED_BUILD_ID:08X}, got 0x{build_id:08X}"
        )

    for accepted_count in range(1, 3):
        submit_seq = 0xC4010000 + iteration + ((accepted_count - 1) << 16)
        payload, command_bank, command_count = build_scene_payload(submit_seq)
        transfer_payload(dma, allocate, packet_mmio, payload, timeout_seconds)
        expected_crc32 = zlib.crc32(payload) & 0xFFFFFFFF
        actual_crc32 = upload_mmio.read(GPIO_DATA_OFFSET)
        actual_bytes = upload_mmio.read(GPIO2_DATA_OFFSET)
        actual_accepted_count = packet_mmio.read(GPIO2_DATA_OFFSET)
        actual_seq = command_mmio.read(GPIO_DATA_OFFSET)
        actual_command_count, active_bank, bank_valid = decode_accepted_status(
            command_mmio.read(GPIO2_DATA_OFFSET)
        )
        if actual_crc32 != expected_crc32 or actual_bytes != len(payload):
            raise RuntimeError("valid scene upload CRC or byte count mismatch")
        if actual_accepted_count != accepted_count or actual_seq != submit_seq:
            rejected_count = error_mmio.read(GPIO_DATA_OFFSET)
            error_flags = error_mmio.read(GPIO2_DATA_OFFSET)
            raise RuntimeError(
                "valid scene was not accepted: "
                f"accepted={actual_accepted_count} rejected={rejected_count} "
                f"seq=0x{actual_seq:08X} errors=0x{error_flags:08X}"
            )
        if not bank_valid or actual_command_count != command_count:
            raise RuntimeError("accepted scene status mismatch")
        if active_bank != accepted_count & 1:
            raise RuntimeError("accepted scene did not switch command banks")
        if read_command_bank(read_address_mmio, read_data_mmio) != command_bank:
            raise RuntimeError("active command bank readback mismatch")

    invalid_payloads = [("magic", b"BAD!" + payload[4:], 0x01)]
    if exercise_all_errors:
        invalid_payloads.extend(
            (
                ("abi", payload[:4] + struct.pack("<I", 0x00020000) + payload[8:], 0x02),
                ("count", payload[:16] + struct.pack("<I", 129) + payload[20:], 0x04),
                ("reserved", payload[:44] + struct.pack("<I", 1) + payload[48:], 0x08),
                ("length", payload[:-8], 0x10),
                ("tkeep", payload[:-4], 0x20),
            )
        )

    expected_errors = 0
    for name, invalid_payload, error_mask in invalid_payloads:
        before_rejected = error_mmio.read(GPIO_DATA_OFFSET)
        transfer_payload(dma, allocate, packet_mmio, invalid_payload, timeout_seconds)
        expected_errors |= error_mask
        if error_mmio.read(GPIO_DATA_OFFSET) != before_rejected + 1:
            raise RuntimeError(f"{name} payload was not rejected")
        actual_errors = error_mmio.read(GPIO2_DATA_OFFSET) & 0x3F
        if actual_errors != expected_errors:
            raise RuntimeError(
                f"{name} error flags expected 0x{expected_errors:02X}, got 0x{actual_errors:02X}"
            )
        if command_mmio.read(GPIO_DATA_OFFSET) != submit_seq:
            raise RuntimeError(f"{name} payload changed accepted sequence")
        _, current_bank, _ = decode_accepted_status(command_mmio.read(GPIO2_DATA_OFFSET))
        if current_bank != active_bank:
            raise RuntimeError(f"{name} payload changed active bank")
        if read_command_bank(read_address_mmio, read_data_mmio) != command_bank:
            raise RuntimeError(f"{name} payload changed active command bank")

    print(
        f"C4M1_LOAD_{iteration:02d}=PASS seq=0x{submit_seq:08X} "
        f"accepted=2 commands={command_count} bank={active_bank} "
        f"crc=0x{actual_crc32:08X} "
        f"errors=0x{expected_errors:02X}"
    )
    del dma
    del overlay
    gc.collect()


def verify_overlay(bitstream: Path, iterations: int, timeout_seconds: float) -> None:
    if os.geteuid() != 0:
        raise PermissionError("PYNQ Overlay loading requires root; run with sudo -n")
    if not bitstream.is_file():
        raise FileNotFoundError(bitstream)
    if not bitstream.with_suffix(".hwh").is_file():
        raise FileNotFoundError(bitstream.with_suffix(".hwh"))

    for iteration in range(1, iterations + 1):
        verify_iteration(bitstream, iteration, timeout_seconds, iteration == 1)
    print(f"C4M1_VERIFY_STATUS=PASS ({iterations}/{iterations})")


def main() -> None:
    parser = argparse.ArgumentParser(description="Verify the PYNQ-Z2 C4M1 overlay")
    parser.add_argument("bitstream", type=Path, help="Path to c4_command.bit")
    parser.add_argument("--iterations", type=int, default=10)
    parser.add_argument("--timeout-seconds", type=float, default=5.0)
    args = parser.parse_args()
    if args.iterations < 1:
        parser.error("--iterations must be at least 1")
    if args.timeout_seconds <= 0:
        parser.error("--timeout-seconds must be positive")
    verify_overlay(args.bitstream.resolve(), args.iterations, args.timeout_seconds)


if __name__ == "__main__":
    main()