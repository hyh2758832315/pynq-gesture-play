from __future__ import annotations

import argparse
import os
import time
from pathlib import Path

if __package__:
    from .camera_driver import MmioLike, SccbBus
    from .verify_camera import get_mmio, sha256
else:
    from camera_driver import MmioLike, SccbBus
    from verify_camera import get_mmio, sha256


EXPECTED_BUILD_ID = 0xC00A00D1
PIN_LAYOUT_BUILD_IDS = {"direct": EXPECTED_BUILD_ID, "remap": 0xC00A00D2, "corrected": 0xC00A00D3}


def probe_gpio_chip_id(mmio: MmioLike) -> int:
    bus = SccbBus(mmio)
    try:
        print("CAMERA_ID_GPIO_PHASE=xclk_enable", flush=True)
        bus.set_xclk_enabled(True)
        time.sleep(0.05)
        print("CAMERA_ID_GPIO_PHASE=bus_recover", flush=True)
        bus.recover()
        values = []
        for register in (0x300A, 0x300B):
            print(f"CAMERA_ID_GPIO_PHASE=read_0x{register:04X}", flush=True)
            value = bus.read_register(0x3C, register)
            values.append(value)
            print(f"CAMERA_ID_GPIO_REGISTER=0x{register:04X}:0x{value:02X}", flush=True)
        chip_id = (values[0] << 8) | values[1]
        print(f"CAMERA_ID_GPIO_CHIP_ID=0x{chip_id:04X}", flush=True)
        if chip_id != 0x5640:
            raise RuntimeError(f"Unexpected OV5640 chip ID: 0x{chip_id:04X}")
        print("CAMERA_ID_GPIO_CHIP_ID_STATUS=PASS", flush=True)
        return chip_id
    finally:
        try:
            bus.release_bus()
        finally:
            bus.set_xclk_enabled(False)
        control = mmio.read(SccbBus.DATA_OFFSET)
        print(f"CAMERA_ID_GPIO_CLEANUP_CONTROL=0x{control:08X}", flush=True)
        if control & 0x7:
            raise RuntimeError("GPIO camera cleanup did not release SCCB and disable XCLK")


def probe_gpio_lines(mmio: MmioLike) -> None:
    try:
        for control, expected in ((0, 3), (1, 2), (0, 3), (2, 1), (0, 3)):
            mmio.write(SccbBus.DATA_OFFSET, control)
            time.sleep(0.001)
            sample = mmio.read(SccbBus.SAMPLE_OFFSET) & 0x3
            print(f"CAMERA_ID_GPIO_LINES=control:0x{control:X} sample:0x{sample:X}", flush=True)
            if sample != expected:
                raise RuntimeError(f"GPIO line sample 0x{sample:X} differs from expected 0x{expected:X}")
        print("CAMERA_ID_GPIO_LINES_STATUS=PASS", flush=True)
    finally:
        mmio.write(SccbBus.DATA_OFFSET, 0)
        control = mmio.read(SccbBus.DATA_OFFSET)
        print(f"CAMERA_ID_GPIO_CLEANUP_CONTROL=0x{control:08X}", flush=True)
        if control & 0x7:
            raise RuntimeError("GPIO line-check cleanup failed")


def main() -> None:
    parser = argparse.ArgumentParser(description="Verify OV5640 chip ID with the historical GPIO SCCB on current pins")
    parser.add_argument("bitstream", type=Path)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--load-only", action="store_true")
    mode.add_argument("--line-check-only", action="store_true")
    parser.add_argument("--no-download", action="store_true")
    parser.add_argument("--pin-layout", choices=tuple(PIN_LAYOUT_BUILD_IDS), default="direct")
    args = parser.parse_args()
    if not args.load_only and not args.no_download:
        parser.error("GPIO probes require --no-download after load-only")
    if os.geteuid() != 0:
        raise PermissionError("PYNQ Overlay access requires root")
    bitstream = args.bitstream.resolve()
    hwh = bitstream.with_suffix(".hwh")
    if not bitstream.is_file() or not hwh.is_file():
        raise FileNotFoundError("Camera ID GPIO bitstream and HWH are required")

    from pynq import Overlay, PL

    if args.no_download and str(bitstream) != PL.bitfile_name:
        raise RuntimeError(f"Active PL bit does not match {bitstream}: {PL.bitfile_name}")
    overlay = Overlay(str(bitstream), download=not args.no_download)
    build_id = get_mmio(overlay, "build_id_gpio").read(0)
    if build_id != PIN_LAYOUT_BUILD_IDS[args.pin_layout]:
        raise RuntimeError(f"Unexpected camera ID GPIO BUILD_ID=0x{build_id:08X}")
    print(f"CAMERA_ID_GPIO_BIT_SHA256={sha256(bitstream)}", flush=True)
    print(f"CAMERA_ID_GPIO_HWH_SHA256={sha256(hwh)}", flush=True)
    print(f"CAMERA_ID_GPIO_BUILD_ID=0x{build_id:08X}", flush=True)
    print(f"CAMERA_ID_GPIO_PIN_LAYOUT={args.pin_layout}", flush=True)
    if args.load_only:
        print("CAMERA_ID_GPIO_LOAD_STATUS=PASS", flush=True)
        return

    mmio = get_mmio(overlay, "camera_control_gpio")
    if args.line_check_only:
        probe_gpio_lines(mmio)
    else:
        probe_gpio_chip_id(mmio)


if __name__ == "__main__":
    main()