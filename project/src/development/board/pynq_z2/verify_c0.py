from __future__ import annotations

import argparse
import gc
import os
from pathlib import Path


EXPECTED_BUILD_ID = 0xC0010001
IP_NAME = "build_id_gpio"


def verify_overlay(bitstream: Path, iterations: int) -> None:
    if os.geteuid() != 0:
        raise PermissionError("PYNQ Overlay loading requires root; run this script with sudo")

    from pynq import MMIO, Overlay

    if not bitstream.is_file():
        raise FileNotFoundError(bitstream)
    hwh = bitstream.with_suffix(".hwh")
    if not hwh.is_file():
        raise FileNotFoundError(hwh)

    for iteration in range(1, iterations + 1):
        overlay = Overlay(str(bitstream), download=True)
        description = overlay.ip_dict.get(IP_NAME)
        if description is None:
            names = ", ".join(sorted(overlay.ip_dict))
            raise RuntimeError(f"{IP_NAME!r} is absent from HWH; available IP: {names}")

        mmio = MMIO(int(description["phys_addr"]), int(description["addr_range"]))
        actual = mmio.read(0)
        print(f"C0_LOAD_{iteration:02d}=0x{actual:08X}")
        if actual != EXPECTED_BUILD_ID:
            raise RuntimeError(
                f"BUILD_ID mismatch on load {iteration}: "
                f"expected 0x{EXPECTED_BUILD_ID:08X}, got 0x{actual:08X}"
            )

        del mmio
        del overlay
        gc.collect()

    print(f"C0_VERIFY_STATUS=PASS ({iterations}/{iterations})")


def main() -> None:
    parser = argparse.ArgumentParser(description="Verify the PYNQ-Z2 C0 overlay")
    parser.add_argument("bitstream", type=Path, help="Path to c0_overlay.bit")
    parser.add_argument("--iterations", type=int, default=10)
    args = parser.parse_args()
    if args.iterations < 1:
        parser.error("--iterations must be at least 1")
    verify_overlay(args.bitstream.resolve(), args.iterations)


if __name__ == "__main__":
    main()