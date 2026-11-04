from __future__ import annotations

import argparse
import gc
import os
from pathlib import Path
import struct
import time
from typing import Any

import verify_c4m2 as c4m2
import verify_c4m3 as c4m3
import verify_c4m4 as c4m4


EXPECTED_BUILD_ID = 0xC0040500
ROUTER_STATUS_IP = "router_status_gpio"
PALETTE_PACKET_STATUS_IP = "palette_packet_status_gpio"
PALETTE_GENERATION_STATUS_IP = "palette_generation_status_gpio"
PALETTE_STATE_STATUS_IP = "palette_state_status_gpio"
GPIO_DATA_OFFSET = 0x0
GPIO2_DATA_OFFSET = 0x8


def palette_banks(seed: int) -> tuple[tuple[tuple[int, int, int], ...], ...]:
    return tuple(
        tuple(
            (
                (seed + bank * 17 + color) & 0xFF,
                (seed ^ bank ^ color) & 0xFF,
                (seed * 3 + bank * 7 + color * 5) & 0xFF,
            )
            for color in range(16)
        )
        for bank in range(16)
    )


def build_blit_payload(
    submit_seq: int, palette_generation: int
) -> tuple[bytes, bytes, int]:
    payload, command_bank, command_count = c4m4.build_blit_payload(submit_seq)
    mutable_payload = bytearray(payload)
    struct.pack_into("<I", mutable_payload, 8 * 4, palette_generation)
    return bytes(mutable_payload), command_bank, command_count


def transfer_dma(dma: Any, allocate: Any, payload: bytes) -> None:
    import numpy as np

    buffer = allocate(shape=(len(payload),), dtype=np.uint8)
    try:
        buffer[:] = np.frombuffer(payload, dtype=np.uint8)
        buffer.flush()
        dma.sendchannel.transfer(buffer)
        dma.sendchannel.wait()
    finally:
        buffer.freebuffer()


def verify_iteration(bitstream: Path, iteration: int, timeout_seconds: float) -> None:
    from pynq import MMIO, Overlay, allocate
    from pynq_multimodal_game.gpu_abi import pack_palette_packet

    hwh = bitstream.with_suffix(".hwh")
    overlay = Overlay(str(bitstream), download=True)

    def mmio(instance: str) -> Any:
        address, size = c4m2.ip_address(overlay, hwh, instance)
        return MMIO(address, size)

    build_mmio = mmio(c4m2.BUILD_ID_IP)
    packet_mmio = mmio(c4m2.PACKET_STATUS_IP)
    command_mmio = mmio(c4m2.COMMAND_STATUS_IP)
    completion_mmio = mmio(c4m2.RENDER_COMPLETION_IP)
    trace_mmio = mmio(c4m2.RENDER_TRACE_IP)
    cycles_mmio = mmio(c4m2.RENDER_CYCLES_IP)
    render_status_mmio = mmio(c4m2.RENDER_STATUS_IP)
    present_mmio = mmio(c4m3.PRESENT_COMPLETION_IP)
    framebuffer_mmio = mmio(c4m3.FRAMEBUFFER_STATUS_IP)
    router_mmio = mmio(ROUTER_STATUS_IP)
    palette_packet_mmio = mmio(PALETTE_PACKET_STATUS_IP)
    palette_generation_mmio = mmio(PALETTE_GENERATION_STATUS_IP)
    palette_state_mmio = mmio(PALETTE_STATE_STATUS_IP)
    dma = getattr(overlay, c4m2.DMA_IP)

    build_id = build_mmio.read(GPIO_DATA_OFFSET)
    if build_id != EXPECTED_BUILD_ID:
        raise RuntimeError(
            f"BUILD_ID mismatch: expected 0x{EXPECTED_BUILD_ID:08X}, "
            f"got 0x{build_id:08X}"
        )
    if palette_state_mmio.read(GPIO_DATA_OFFSET) & 0xF != 0x4:
        raise RuntimeError("unexpected initial palette ownership")

    for update_index, seed in enumerate((3, 12), start=1):
        generation = (iteration << 16) | update_index
        palette_packet = pack_palette_packet(
            palette_banks(seed), generation=generation
        )
        transfer_dma(dma, allocate, palette_packet)
        c4m2.wait_for_value(
            palette_packet_mmio,
            GPIO_DATA_OFFSET,
            update_index,
            timeout_seconds,
            "palette accepted count",
        )
        c4m2.wait_for_value(
            palette_generation_mmio,
            GPIO_DATA_OFFSET,
            generation,
            timeout_seconds,
            "palette generation",
        )
        expected_palette_state = 0x3 if update_index == 1 else 0x5
        if palette_state_mmio.read(GPIO_DATA_OFFSET) & 0xF != expected_palette_state:
            raise RuntimeError("palette bank ownership mismatch")

        submit_seq = 0xC4050000 + iteration + ((update_index - 1) << 12)
        payload, _, _ = build_blit_payload(submit_seq, generation)
        before_present = present_mmio.read(GPIO2_DATA_OFFSET)
        c4m2.transfer_payload(dma, allocate, packet_mmio, payload, timeout_seconds)
        c4m2.wait_for_value(
            completion_mmio,
            GPIO2_DATA_OFFSET,
            update_index,
            timeout_seconds,
            "render completed count",
        )
        c4m2.wait_for_value(
            completion_mmio,
            GPIO_DATA_OFFSET,
            submit_seq,
            timeout_seconds,
            "render completed sequence",
        )
        c4m3.wait_for_increment(
            present_mmio,
            GPIO2_DATA_OFFSET,
            before_present,
            timeout_seconds,
            "present completed count",
        )

        if command_mmio.read(GPIO_DATA_OFFSET) != submit_seq:
            raise RuntimeError("accepted sequence mismatch")
        if trace_mmio.read(GPIO_DATA_OFFSET) != c4m4.EXPECTED_TRACE_CRC32:
            raise RuntimeError("render trace CRC mismatch")
        if trace_mmio.read(GPIO2_DATA_OFFSET) != c4m4.EXPECTED_WRITE_COUNT:
            raise RuntimeError("render write count mismatch")
        if cycles_mmio.read(GPIO_DATA_OFFSET) != c4m4.EXPECTED_RENDER_CYCLES:
            raise RuntimeError("render cycle count mismatch")
        if c4m2.decode_render_status(
            render_status_mmio.read(GPIO_DATA_OFFSET)
        ) != (False, 0, 0, 0):
            raise RuntimeError("render status mismatch")

    if palette_packet_mmio.read(GPIO2_DATA_OFFSET) != 0:
        raise RuntimeError("palette packet rejection count is nonzero")
    if palette_generation_mmio.read(GPIO2_DATA_OFFSET) != 0:
        raise RuntimeError("palette sticky error flags are nonzero")
    if router_mmio.read(GPIO_DATA_OFFSET) != 0:
        raise RuntimeError("router dropped packet count is nonzero")
    if router_mmio.read(GPIO2_DATA_OFFSET) != 0:
        raise RuntimeError("unsupported packet count is nonzero")

    pending, write_bank, display_bank = c4m3.decode_framebuffer_status(
        framebuffer_mmio.read(GPIO_DATA_OFFSET)
    )
    if pending:
        raise RuntimeError("framebuffer present remains pending")
    print(
        f"C4M5_LOAD_{iteration:02d}=PASS generation=0x{generation:08X} "
        f"renders={completion_mmio.read(GPIO2_DATA_OFFSET)} "
        f"presents={present_mmio.read(GPIO2_DATA_OFFSET)} "
        f"palette_state=0x{expected_palette_state:X} "
        f"display_bank={display_bank} write_bank={write_bank}"
    )
    del dma
    del overlay
    gc.collect()


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Verify the PYNQ-Z2 C4M5 runtime palette overlay"
    )
    parser.add_argument("bitstream", type=Path, help="Path to c4_runtime_palette.bit")
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
    print(f"C4M5_VERIFY_STATUS=PASS ({args.iterations}/{args.iterations})")


if __name__ == "__main__":
    main()