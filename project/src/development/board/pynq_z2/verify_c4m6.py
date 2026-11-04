from __future__ import annotations

import argparse
import gc
import os
from pathlib import Path
from typing import Any

import verify_c4m2 as c4m2
import verify_c4m3 as c4m3
import verify_c4m4 as c4m4
import verify_c4m5 as c4m5


EXPECTED_BUILD_ID = 0xC0040600
ROUTER_STATUS_IP = "router_status_gpio"
PALETTE_PACKET_STATUS_IP = "palette_packet_status_gpio"
PALETTE_GENERATION_STATUS_IP = "palette_generation_status_gpio"
PALETTE_STATE_STATUS_IP = "palette_state_status_gpio"
ASSET_PACKET_STATUS_IP = "asset_packet_status_gpio"
ASSET_GENERATION_STATUS_IP = "asset_generation_status_gpio"
ASSET_STATE_STATUS_IP = "asset_state_status_gpio"
GPIO_DATA_OFFSET = 0x0
GPIO2_DATA_OFFSET = 0x8


def asset_bundle() -> tuple[Any, ...]:
    from pynq_multimodal_game.scene import IndexedImage

    return (
        IndexedImage(3, 2, bytes((1, 0, 2, 3, 4, 0))),
        IndexedImage(2, 1, bytes((7, 8))),
        IndexedImage(1, 1, bytes((9,))),
    )


def build_scene_payload(
    submit_seq: int,
    palette_generation: int,
    asset_generation: int,
    asset_id: int,
) -> tuple[bytes, int]:
    from pynq_multimodal_game.gpu_abi import GpuCommand, SceneHeader, pack_command_bank

    if asset_id == 0:
        command = GpuCommand.blit_index4(
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
        )
    elif asset_id == 2:
        command = GpuCommand.blit_index4(
            asset_id=2,
            palette_bank=0xA,
            dst_x=10,
            dst_y=5,
            width=1,
            height=1,
            src_x=0,
            src_y=0,
        )
    else:
        raise ValueError(f"unsupported verifier asset ID {asset_id}")
    commands = (command, GpuCommand.end_frame())
    header = SceneHeader(
        frame_id=submit_seq,
        submit_seq=submit_seq,
        command_count=len(commands),
        camera_x=0,
        camera_y=0,
        background_color=(0, 0, 0),
        palette_generation=palette_generation,
        asset_generation=asset_generation,
    )
    return header.to_bytes() + pack_command_bank(commands), len(commands)


def verify_iteration(bitstream: Path, iteration: int, timeout_seconds: float) -> None:
    from pynq import MMIO, Overlay, allocate
    from pynq_multimodal_game.gpu_abi import pack_asset_bundle_packet, pack_palette_packet

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
    render_status_mmio = mmio(c4m2.RENDER_STATUS_IP)
    present_mmio = mmio(c4m3.PRESENT_COMPLETION_IP)
    router_mmio = mmio(ROUTER_STATUS_IP)
    palette_packet_mmio = mmio(PALETTE_PACKET_STATUS_IP)
    palette_generation_mmio = mmio(PALETTE_GENERATION_STATUS_IP)
    palette_state_mmio = mmio(PALETTE_STATE_STATUS_IP)
    asset_packet_mmio = mmio(ASSET_PACKET_STATUS_IP)
    asset_generation_mmio = mmio(ASSET_GENERATION_STATUS_IP)
    asset_state_mmio = mmio(ASSET_STATE_STATUS_IP)
    dma = getattr(overlay, c4m2.DMA_IP)

    if build_mmio.read(GPIO_DATA_OFFSET) != EXPECTED_BUILD_ID:
        raise RuntimeError("BUILD_ID mismatch")
    if palette_state_mmio.read(GPIO_DATA_OFFSET) & 0xF != 0x4:
        raise RuntimeError("unexpected initial palette ownership")
    if asset_state_mmio.read(GPIO_DATA_OFFSET) & 0xF != 0x4:
        raise RuntimeError("unexpected initial asset ownership")

    generation = (iteration << 16) | 1
    c4m5.transfer_dma(
        dma,
        allocate,
        pack_asset_bundle_packet(asset_bundle(), generation=generation),
    )
    c4m2.wait_for_value(
        asset_packet_mmio,
        GPIO_DATA_OFFSET,
        1,
        timeout_seconds,
        "asset accepted count",
    )
    c4m2.wait_for_value(
        asset_generation_mmio,
        GPIO_DATA_OFFSET,
        generation,
        timeout_seconds,
        "asset generation",
    )
    if asset_packet_mmio.read(GPIO2_DATA_OFFSET) != 0:
        raise RuntimeError("asset packet rejection count is nonzero")
    if asset_generation_mmio.read(GPIO2_DATA_OFFSET) != 0:
        raise RuntimeError("asset sticky error flags are nonzero")
    if asset_state_mmio.read(GPIO_DATA_OFFSET) & 0xF != 0x3:
        raise RuntimeError("asset bank ownership mismatch")

    c4m5.transfer_dma(
        dma,
        allocate,
        pack_palette_packet(c4m5.palette_banks(3), generation=generation),
    )
    c4m2.wait_for_value(
        palette_packet_mmio,
        GPIO_DATA_OFFSET,
        1,
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

    for render_index, (asset_id, expected_writes) in enumerate(
        ((0, c4m4.EXPECTED_WRITE_COUNT), (2, 1)), start=1
    ):
        submit_seq = 0xC4060000 + iteration + (asset_id << 12)
        payload, command_count = build_scene_payload(
            submit_seq, generation, generation, asset_id
        )
        before_present = present_mmio.read(GPIO2_DATA_OFFSET)
        c4m2.transfer_payload(dma, allocate, packet_mmio, payload, timeout_seconds)
        c4m2.wait_for_value(
            completion_mmio,
            GPIO2_DATA_OFFSET,
            render_index,
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
        accepted_count, _, bank_valid = c4m2.decode_accepted_status(
            command_mmio.read(GPIO2_DATA_OFFSET)
        )
        if command_mmio.read(GPIO_DATA_OFFSET) != submit_seq:
            raise RuntimeError("accepted scene sequence mismatch")
        if accepted_count != command_count or not bank_valid:
            raise RuntimeError("accepted command status mismatch")
        if trace_mmio.read(GPIO2_DATA_OFFSET) != expected_writes:
            raise RuntimeError("render write count mismatch")
        if asset_id == 0 and trace_mmio.read(GPIO_DATA_OFFSET) != c4m4.EXPECTED_TRACE_CRC32:
            raise RuntimeError("slot 0 render trace CRC mismatch")
        if c4m2.decode_render_status(render_status_mmio.read(GPIO_DATA_OFFSET)) != (False, 0, 0, 0):
            raise RuntimeError("render status mismatch")

    if router_mmio.read(GPIO_DATA_OFFSET) != 0 or router_mmio.read(GPIO2_DATA_OFFSET) != 0:
        raise RuntimeError("router counters are nonzero")
    print(
        f"C4M6_LOAD_{iteration:02d}=PASS generation=0x{generation:08X} "
        f"renders={completion_mmio.read(GPIO2_DATA_OFFSET)} "
        f"presents={present_mmio.read(GPIO2_DATA_OFFSET)}"
    )
    del dma
    del overlay
    gc.collect()


def main() -> None:
    parser = argparse.ArgumentParser(description="Verify the PYNQ-Z2 C4M6 runtime Asset overlay")
    parser.add_argument("bitstream", type=Path, help="Path to c4_runtime_assets.bit")
    parser.add_argument("--iterations", type=int, default=10)
    parser.add_argument("--timeout-seconds", type=float, default=10.0)
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
    print(f"C4M6_VERIFY_STATUS=PASS ({args.iterations}/{args.iterations})")


if __name__ == "__main__":
    main()