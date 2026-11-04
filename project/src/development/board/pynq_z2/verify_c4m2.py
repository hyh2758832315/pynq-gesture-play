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


EXPECTED_BUILD_ID = 0xC0040200
BUILD_ID_IP = "build_id_gpio"
DMA_IP = "axi_dma"
UPLOAD_STATUS_IP = "upload_status_gpio"
PACKET_STATUS_IP = "packet_status_gpio"
COMMAND_STATUS_IP = "command_status_gpio"
ERROR_STATUS_IP = "error_status_gpio"
READ_ADDRESS_IP = "command_read_address_gpio"
READ_DATA_IP = "command_read_data_gpio"
RENDER_COMPLETION_IP = "render_completion_gpio"
RENDER_TRACE_IP = "render_trace_gpio"
RENDER_CYCLES_IP = "render_cycles_gpio"
RENDER_STATUS_IP = "render_status_gpio"
GPIO_DATA_OFFSET = 0x0
GPIO2_DATA_OFFSET = 0x8
COMMAND_BANK_BYTES = 4096
PAYLOAD_BYTES = 64 + COMMAND_BANK_BYTES
EXPECTED_WRITE_COUNT = 57608
EXPECTED_TRACE_CRC32 = 0xB62CC96A
EXPECTED_RENDER_CYCLES = 57644


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


def decode_render_status(value: int) -> tuple[bool, int, int, int]:
    return bool(value & 1), (value >> 4) & 0xF, (value >> 8) & 0xF, (value >> 16) & 0xFF


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


def canonical_commands() -> tuple[Any, ...]:
    from pynq_multimodal_game.gpu_abi import GpuCommand

    return (
        GpuCommand.clear(0x12),
        GpuCommand.fill_rect(x=-2, y=-1, width=4, height=3, token=0xA5),
        GpuCommand.fill_rect(x=318, y=178, width=5, height=4, token=0x7E),
        GpuCommand.fill_rect(x=10, y=10, width=0, height=7, token=0x22),
        GpuCommand.fill_rect(x=400, y=200, width=4, height=4, token=0x11),
        GpuCommand.end_frame(),
    )


def build_payload(
    submit_seq: int,
    command_bank: bytes,
    command_count: int,
    predicted_cycles: int,
) -> bytes:
    from pynq_multimodal_game.gpu_abi import SceneHeader

    header = SceneHeader(
        frame_id=submit_seq,
        submit_seq=submit_seq,
        command_count=command_count,
        camera_x=0,
        camera_y=0,
        background_color=(0, 0, 0),
        predicted_cycles=predicted_cycles,
    )
    payload = header.to_bytes() + command_bank
    if len(payload) != PAYLOAD_BYTES:
        raise RuntimeError(f"scene payload has {len(payload)} bytes, expected {PAYLOAD_BYTES}")
    return payload


def build_canonical_payload(submit_seq: int) -> tuple[bytes, bytes, int]:
    from pynq_multimodal_game.gpu_abi import pack_command_bank
    from pynq_multimodal_game.raster_trace import clear_fill_writes, raster_trace_crc32

    commands = canonical_commands()
    command_bank = pack_command_bank(commands)
    writes = clear_fill_writes(commands)
    if len(writes) != EXPECTED_WRITE_COUNT:
        raise RuntimeError("canonical write count changed")
    if raster_trace_crc32(writes) != EXPECTED_TRACE_CRC32:
        raise RuntimeError("canonical trace CRC changed")
    payload = build_payload(
        submit_seq,
        command_bank,
        len(commands),
        EXPECTED_RENDER_CYCLES,
    )
    return payload, command_bank, len(commands)


def build_error_payload(submit_seq: int, kind: str) -> tuple[bytes, bytes]:
    from pynq_multimodal_game.gpu_abi import GpuCommand, pack_command_bank

    command_bank = bytearray(pack_command_bank((GpuCommand.clear(0x12),)))
    if kind == "unsupported":
        struct.pack_into("<I", command_bank, 0, 0x7F)
    elif kind == "malformed":
        struct.pack_into("<I", command_bank, 8, 1)
    else:
        raise ValueError(f"unknown renderer error case {kind!r}")
    packed_bank = bytes(command_bank)
    return build_payload(submit_seq, packed_bank, 1, 0), packed_bank


def verify_iteration(
    bitstream: Path,
    iteration: int,
    timeout_seconds: float,
    exercise_errors: bool,
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
    completion_mmio = mmio(RENDER_COMPLETION_IP)
    trace_mmio = mmio(RENDER_TRACE_IP)
    cycles_mmio = mmio(RENDER_CYCLES_IP)
    render_status_mmio = mmio(RENDER_STATUS_IP)
    dma = getattr(overlay, DMA_IP)

    build_id = build_mmio.read(GPIO_DATA_OFFSET)
    if build_id != EXPECTED_BUILD_ID:
        raise RuntimeError(
            f"BUILD_ID mismatch: expected 0x{EXPECTED_BUILD_ID:08X}, got 0x{build_id:08X}"
        )

    for accepted_count in range(1, 3):
        submit_seq = 0xC4020000 + iteration + ((accepted_count - 1) << 12)
        payload, command_bank, command_count = build_canonical_payload(submit_seq)
        transfer_payload(dma, allocate, packet_mmio, payload, timeout_seconds)
        wait_for_value(
            completion_mmio,
            GPIO2_DATA_OFFSET,
            accepted_count,
            timeout_seconds,
            "render completed count",
        )
        actual_command_count, active_bank, bank_valid = decode_accepted_status(
            command_mmio.read(GPIO2_DATA_OFFSET)
        )
        render_status = decode_render_status(render_status_mmio.read(GPIO_DATA_OFFSET))
        if upload_mmio.read(GPIO_DATA_OFFSET) != zlib.crc32(payload) & 0xFFFFFFFF:
            raise RuntimeError("valid scene upload CRC mismatch")
        if upload_mmio.read(GPIO2_DATA_OFFSET) != len(payload):
            raise RuntimeError("valid scene upload byte count mismatch")
        if packet_mmio.read(GPIO2_DATA_OFFSET) != accepted_count:
            raise RuntimeError("valid scene was not accepted")
        if command_mmio.read(GPIO_DATA_OFFSET) != submit_seq:
            raise RuntimeError("accepted sequence mismatch")
        if not bank_valid or actual_command_count != command_count:
            raise RuntimeError("accepted scene status mismatch")
        if active_bank != accepted_count & 1:
            raise RuntimeError("accepted scene did not switch command banks")
        if read_command_bank(read_address_mmio, read_data_mmio) != command_bank:
            raise RuntimeError("active command bank readback mismatch")
        if completion_mmio.read(GPIO_DATA_OFFSET) != submit_seq:
            raise RuntimeError("render completion sequence mismatch")
        if trace_mmio.read(GPIO_DATA_OFFSET) != EXPECTED_TRACE_CRC32:
            raise RuntimeError("render trace CRC mismatch")
        if trace_mmio.read(GPIO2_DATA_OFFSET) != EXPECTED_WRITE_COUNT:
            raise RuntimeError("render write count mismatch")
        if cycles_mmio.read(GPIO_DATA_OFFSET) != EXPECTED_RENDER_CYCLES:
            raise RuntimeError("render cycle count mismatch")
        if render_status != (False, 0, 0, 0):
            raise RuntimeError(f"valid render status mismatch: {render_status}")

    canonical_seq = submit_seq
    expected_sticky = 0
    if exercise_errors:
        for case_index, (name, error_flag) in enumerate(
            (("unsupported", 0x1), ("malformed", 0x2)),
            start=1,
        ):
            submit_seq = 0xC402E000 + case_index
            payload, command_bank = build_error_payload(submit_seq, name)
            before_render_count = completion_mmio.read(GPIO2_DATA_OFFSET)
            transfer_payload(dma, allocate, packet_mmio, payload, timeout_seconds)
            wait_for_value(
                completion_mmio,
                GPIO2_DATA_OFFSET,
                before_render_count + 1,
                timeout_seconds,
                f"{name} render completion",
            )
            expected_sticky |= error_flag
            render_status = decode_render_status(
                render_status_mmio.read(GPIO_DATA_OFFSET)
            )
            if render_status != (False, error_flag, expected_sticky, 0):
                raise RuntimeError(f"{name} render status mismatch: {render_status}")
            if completion_mmio.read(GPIO_DATA_OFFSET) != submit_seq:
                raise RuntimeError(f"{name} completion sequence mismatch")
            if trace_mmio.read(GPIO2_DATA_OFFSET) != 0:
                raise RuntimeError(f"{name} command produced framebuffer writes")
            if error_mmio.read(GPIO2_DATA_OFFSET) != 0:
                raise RuntimeError(f"{name} command was rejected by the uploader")
            if read_command_bank(read_address_mmio, read_data_mmio) != command_bank:
                raise RuntimeError(f"{name} command bank readback mismatch")

    print(
        f"C4M2_LOAD_{iteration:02d}=PASS seq=0x{canonical_seq:08X} "
        f"renders={completion_mmio.read(GPIO2_DATA_OFFSET)} "
        f"writes={EXPECTED_WRITE_COUNT} "
        f"crc=0x{EXPECTED_TRACE_CRC32:08X} "
        f"errors=0x{expected_sticky:X}"
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
    print(f"C4M2_VERIFY_STATUS=PASS ({iterations}/{iterations})")


def main() -> None:
    parser = argparse.ArgumentParser(description="Verify the PYNQ-Z2 C4M2 overlay")
    parser.add_argument("bitstream", type=Path, help="Path to c4_clear_fill.bit")
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