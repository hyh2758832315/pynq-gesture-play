from __future__ import annotations

import argparse
import gc
import os
from pathlib import Path
import time
from typing import Any
import zlib

import verify_c4m2 as c4m2


EXPECTED_BUILD_ID = 0xC0040300
PRESENT_COMPLETION_IP = "present_completion_gpio"
FRAMEBUFFER_STATUS_IP = "framebuffer_status_gpio"
GPIO_DATA_OFFSET = 0x0
GPIO2_DATA_OFFSET = 0x8


def wait_for_increment(mmio: Any, offset: int, before: int, timeout_seconds: float, label: str) -> int:
    deadline = time.perf_counter() + timeout_seconds
    while True:
        value = mmio.read(offset)
        if value == (before + 1) & 0xFFFFFFFF:
            return value
        if time.perf_counter() >= deadline:
            raise TimeoutError(f"{label} timeout: expected {(before + 1) & 0xFFFFFFFF}, got {value}")


def decode_framebuffer_status(value: int) -> tuple[bool, int, int]:
    return bool((value >> 2) & 1), (value >> 1) & 1, value & 1


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
    completion_mmio = mmio(c4m2.RENDER_COMPLETION_IP)
    trace_mmio = mmio(c4m2.RENDER_TRACE_IP)
    cycles_mmio = mmio(c4m2.RENDER_CYCLES_IP)
    render_status_mmio = mmio(c4m2.RENDER_STATUS_IP)
    present_mmio = mmio(PRESENT_COMPLETION_IP)
    framebuffer_mmio = mmio(FRAMEBUFFER_STATUS_IP)
    dma = getattr(overlay, c4m2.DMA_IP)

    if build_mmio.read(GPIO_DATA_OFFSET) != EXPECTED_BUILD_ID:
        raise RuntimeError("C4M3 BUILD_ID mismatch")
    pending, write_bank, display_bank = decode_framebuffer_status(framebuffer_mmio.read(GPIO_DATA_OFFSET))
    if (pending, write_bank, display_bank) != (False, 1, 0):
        raise RuntimeError(f"unexpected initial framebuffer ownership: {(pending, write_bank, display_bank)}")

    for accepted_count in range(1, 3):
        submit_seq = 0xC4030000 + iteration + ((accepted_count - 1) << 12)
        payload, _, command_count = c4m2.build_canonical_payload(submit_seq)
        before_present = present_mmio.read(GPIO2_DATA_OFFSET)
        c4m2.transfer_payload(dma, allocate, packet_mmio, payload, timeout_seconds)
        c4m2.wait_for_value(completion_mmio, GPIO2_DATA_OFFSET, accepted_count, timeout_seconds, "render completed count")
        c4m2.wait_for_value(present_mmio, GPIO_DATA_OFFSET, submit_seq, timeout_seconds, "present completed sequence")
        wait_for_increment(present_mmio, GPIO2_DATA_OFFSET, before_present, timeout_seconds, "present completed count")

        if upload_mmio.read(GPIO_DATA_OFFSET) != zlib.crc32(payload) & 0xFFFFFFFF:
            raise RuntimeError("upload CRC mismatch")
        if command_mmio.read(GPIO_DATA_OFFSET) != submit_seq:
            raise RuntimeError("accepted sequence mismatch")
        actual_count, _, bank_valid = c4m2.decode_accepted_status(command_mmio.read(GPIO2_DATA_OFFSET))
        if not bank_valid or actual_count != command_count:
            raise RuntimeError("accepted command status mismatch")
        if trace_mmio.read(GPIO_DATA_OFFSET) != c4m2.EXPECTED_TRACE_CRC32:
            raise RuntimeError("render trace CRC mismatch")
        if trace_mmio.read(GPIO2_DATA_OFFSET) != c4m2.EXPECTED_WRITE_COUNT:
            raise RuntimeError("render write count mismatch")
        if cycles_mmio.read(GPIO_DATA_OFFSET) != c4m2.EXPECTED_RENDER_CYCLES:
            raise RuntimeError("render cycle count mismatch")
        if c4m2.decode_render_status(render_status_mmio.read(GPIO_DATA_OFFSET)) != (False, 0, 0, 0):
            raise RuntimeError("render status mismatch")
        pending, new_write_bank, new_display_bank = decode_framebuffer_status(framebuffer_mmio.read(GPIO_DATA_OFFSET))
        if pending or new_write_bank != display_bank or new_display_bank != write_bank:
            raise RuntimeError("framebuffer ownership did not swap at vblank")
        write_bank, display_bank = new_write_bank, new_display_bank

    print(
        f"C4M3_LOAD_{iteration:02d}=PASS seq=0x{submit_seq:08X} "
        f"renders={completion_mmio.read(GPIO2_DATA_OFFSET)} "
        f"presents={present_mmio.read(GPIO2_DATA_OFFSET)} "
        f"display_bank={display_bank} write_bank={write_bank}"
    )
    del dma
    del overlay
    gc.collect()


def main() -> None:
    parser = argparse.ArgumentParser(description="Verify the PYNQ-Z2 C4M3 framebuffer overlay")
    parser.add_argument("bitstream", type=Path, help="Path to c4_framebuffer.bit")
    parser.add_argument("--iterations", type=int, default=10)
    parser.add_argument("--timeout-seconds", type=float, default=5.0)
    args = parser.parse_args()
    if os.geteuid() != 0:
        raise PermissionError("PYNQ Overlay loading requires root; run with sudo -n")
    if args.iterations < 1 or args.timeout_seconds <= 0:
        parser.error("iterations and timeout must be positive")
    bitstream = args.bitstream.resolve()
    for iteration in range(1, args.iterations + 1):
        verify_iteration(bitstream, iteration, args.timeout_seconds)
    print(f"C4M3_VERIFY_STATUS=PASS ({args.iterations}/{args.iterations})")


if __name__ == "__main__":
    main()