from __future__ import annotations

import argparse
import gc
import os
from pathlib import Path
import time
from typing import Any
import zlib

import verify_c4m2 as c4m2
import verify_c4m3 as c4m3


EXPECTED_BUILD_ID = 0xC0040400
EXPECTED_WRITE_COUNT = 3
EXPECTED_TRACE_CRC32 = 0x173E26EB
EXPECTED_RENDER_CYCLES = 32
GPIO_DATA_OFFSET = 0x0
GPIO2_DATA_OFFSET = 0x8


def build_blit_payload(submit_seq: int) -> tuple[bytes, bytes, int]:
    from pynq_multimodal_game.gpu_abi import GpuCommand, pack_command_bank
    from pynq_multimodal_game.raster_trace import indexed_blit_writes, raster_trace_crc32
    from pynq_multimodal_game.scene import IndexedImage

    commands = (
        GpuCommand.blit_index4(
            asset_id=0,
            palette_bank=0xA,
            dst_x=-1,
            dst_y=1,
            width=3,
            height=2,
            src_x=0,
            src_y=0,
            flip_x=True,
            flip_y=True,
        ),
        GpuCommand.end_frame(),
    )
    pixels = bytearray(256 * 256)
    pixels[0:3] = bytes((1, 0, 2))
    pixels[256:259] = bytes((3, 4, 0))
    writes = indexed_blit_writes(
        commands,
        (IndexedImage(256, 256, bytes(pixels)),),
    )
    if len(writes) != EXPECTED_WRITE_COUNT:
        raise RuntimeError("C4M4 golden write count changed")
    if raster_trace_crc32(writes) != EXPECTED_TRACE_CRC32:
        raise RuntimeError("C4M4 golden trace CRC changed")

    command_bank = pack_command_bank(commands)
    payload = c4m2.build_payload(
        submit_seq,
        command_bank,
        len(commands),
        EXPECTED_RENDER_CYCLES,
    )
    return payload, command_bank, len(commands)


def verify_iteration(bitstream: Path, iteration: int, timeout_seconds: float) -> None:
    from pynq import MMIO, Overlay, allocate

    hwh = bitstream.with_suffix(".hwh")
    overlay = Overlay(str(bitstream), download=True)

    def mmio(instance: str) -> Any:
        address, size = c4m2.ip_address(overlay, hwh, instance)
        return MMIO(address, size)

    build_mmio = mmio(c4m2.BUILD_ID_IP)
    upload_mmio = mmio(c4m2.UPLOAD_STATUS_IP)
    packet_mmio = mmio(c4m2.PACKET_STATUS_IP)
    command_mmio = mmio(c4m2.COMMAND_STATUS_IP)
    read_address_mmio = mmio(c4m2.READ_ADDRESS_IP)
    read_data_mmio = mmio(c4m2.READ_DATA_IP)
    completion_mmio = mmio(c4m2.RENDER_COMPLETION_IP)
    trace_mmio = mmio(c4m2.RENDER_TRACE_IP)
    cycles_mmio = mmio(c4m2.RENDER_CYCLES_IP)
    render_status_mmio = mmio(c4m2.RENDER_STATUS_IP)
    present_mmio = mmio(c4m3.PRESENT_COMPLETION_IP)
    framebuffer_mmio = mmio(c4m3.FRAMEBUFFER_STATUS_IP)
    dma = getattr(overlay, c4m2.DMA_IP)

    build_id = build_mmio.read(GPIO_DATA_OFFSET)
    if build_id != EXPECTED_BUILD_ID:
        raise RuntimeError(
            f"BUILD_ID mismatch: expected 0x{EXPECTED_BUILD_ID:08X}, got 0x{build_id:08X}"
        )
    pending, write_bank, display_bank = c4m3.decode_framebuffer_status(
        framebuffer_mmio.read(GPIO_DATA_OFFSET)
    )
    if (pending, write_bank, display_bank) != (False, 1, 0):
        raise RuntimeError(
            f"unexpected initial framebuffer ownership: {(pending, write_bank, display_bank)}"
        )

    for accepted_count in range(1, 3):
        submit_seq = 0xC4040000 + iteration + ((accepted_count - 1) << 12)
        payload, command_bank, command_count = build_blit_payload(submit_seq)
        before_present = present_mmio.read(GPIO2_DATA_OFFSET)
        c4m2.transfer_payload(dma, allocate, packet_mmio, payload, timeout_seconds)
        c4m2.wait_for_value(
            completion_mmio,
            GPIO2_DATA_OFFSET,
            accepted_count,
            timeout_seconds,
            "render completed count",
        )
        c4m2.wait_for_value(
            present_mmio,
            GPIO_DATA_OFFSET,
            submit_seq,
            timeout_seconds,
            "present completed sequence",
        )
        c4m3.wait_for_increment(
            present_mmio,
            GPIO2_DATA_OFFSET,
            before_present,
            timeout_seconds,
            "present completed count",
        )

        actual_count, active_bank, bank_valid = c4m2.decode_accepted_status(
            command_mmio.read(GPIO2_DATA_OFFSET)
        )
        if upload_mmio.read(GPIO_DATA_OFFSET) != zlib.crc32(payload) & 0xFFFFFFFF:
            raise RuntimeError("upload CRC mismatch")
        if upload_mmio.read(GPIO2_DATA_OFFSET) != len(payload):
            raise RuntimeError("upload byte count mismatch")
        if packet_mmio.read(GPIO2_DATA_OFFSET) != accepted_count:
            raise RuntimeError("scene was not accepted")
        if command_mmio.read(GPIO_DATA_OFFSET) != submit_seq:
            raise RuntimeError("accepted sequence mismatch")
        if not bank_valid or actual_count != command_count:
            raise RuntimeError("accepted command status mismatch")
        if active_bank != accepted_count & 1:
            raise RuntimeError("accepted scene did not switch command banks")
        if c4m2.read_command_bank(read_address_mmio, read_data_mmio) != command_bank:
            raise RuntimeError("active command bank readback mismatch")
        if completion_mmio.read(GPIO_DATA_OFFSET) != submit_seq:
            raise RuntimeError("render completion sequence mismatch")
        if trace_mmio.read(GPIO_DATA_OFFSET) != EXPECTED_TRACE_CRC32:
            raise RuntimeError("render trace CRC mismatch")
        if trace_mmio.read(GPIO2_DATA_OFFSET) != EXPECTED_WRITE_COUNT:
            raise RuntimeError("render write count mismatch")
        if cycles_mmio.read(GPIO_DATA_OFFSET) != EXPECTED_RENDER_CYCLES:
            raise RuntimeError("render cycle count mismatch")
        render_status = c4m2.decode_render_status(
            render_status_mmio.read(GPIO_DATA_OFFSET)
        )
        if render_status != (False, 0, 0, 0):
            raise RuntimeError(f"render status mismatch: {render_status}")

        pending, new_write_bank, new_display_bank = c4m3.decode_framebuffer_status(
            framebuffer_mmio.read(GPIO_DATA_OFFSET)
        )
        if pending or new_write_bank != display_bank or new_display_bank != write_bank:
            raise RuntimeError("framebuffer ownership did not swap at vblank")
        write_bank, display_bank = new_write_bank, new_display_bank

    print(
        f"C4M4_LOAD_{iteration:02d}=PASS seq=0x{submit_seq:08X} "
        f"renders={completion_mmio.read(GPIO2_DATA_OFFSET)} "
        f"presents={present_mmio.read(GPIO2_DATA_OFFSET)} "
        f"writes={EXPECTED_WRITE_COUNT} crc=0x{EXPECTED_TRACE_CRC32:08X} "
        f"cycles={EXPECTED_RENDER_CYCLES} display_bank={display_bank} "
        f"write_bank={write_bank}"
    )
    del dma
    del overlay
    gc.collect()


def main() -> None:
    parser = argparse.ArgumentParser(description="Verify the PYNQ-Z2 C4M4 BLIT overlay")
    parser.add_argument("bitstream", type=Path, help="Path to c4_blit.bit")
    parser.add_argument("--iterations", type=int, default=10)
    parser.add_argument("--timeout-seconds", type=float, default=5.0)
    args = parser.parse_args()
    if os.geteuid() != 0:
        raise PermissionError("PYNQ Overlay loading requires root; run with sudo -n")
    if args.iterations < 1 or args.timeout_seconds <= 0:
        parser.error("iterations and timeout must be positive")
    bitstream = args.bitstream.resolve()
    if not bitstream.is_file() or not bitstream.with_suffix(".hwh").is_file():
        raise FileNotFoundError("bitstream and matching HWH are required")
    for iteration in range(1, args.iterations + 1):
        verify_iteration(bitstream, iteration, args.timeout_seconds)
    print(f"C4M4_VERIFY_STATUS=PASS ({args.iterations}/{args.iterations})")


if __name__ == "__main__":
    main()
