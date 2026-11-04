from __future__ import annotations

import argparse
import gc
import json
import os
from pathlib import Path
from typing import Callable


EXPECTED_BUILD_ID = 0xC0020001
BUILD_ID_IP = "build_id_gpio"
INPUT_IP = "input_gpio"
INPUT_MASK = 0x3F
INPUT_BITS = (
    ("BTN0", 1 << 0),
    ("BTN1", 1 << 1),
    ("BTN2", 1 << 2),
    ("BTN3", 1 << 3),
    ("SW0", 1 << 4),
    ("SW1", 1 << 5),
)


def verify_overlay(bitstream: Path, iterations: int) -> None:
    if os.geteuid() != 0:
        raise PermissionError("PYNQ Overlay loading requires root; run this script with sudo")
    from pynq import MMIO, Overlay

    if not bitstream.is_file() or not bitstream.with_suffix(".hwh").is_file():
        raise FileNotFoundError("paired C2 bitstream and HWH files are required")
    for iteration in range(1, iterations + 1):
        overlay = Overlay(str(bitstream), download=True)
        build_id_mmio = _mmio(overlay, BUILD_ID_IP, MMIO)
        input_mmio = _mmio(overlay, INPUT_IP, MMIO)
        build_id = build_id_mmio.read(0)
        inputs = input_mmio.read(0) & INPUT_MASK
        if build_id != EXPECTED_BUILD_ID:
            raise RuntimeError(f"BUILD_ID mismatch: expected 0x{EXPECTED_BUILD_ID:08X}, got 0x{build_id:08X}")
        print(f"C2_LOAD_{iteration:02d}=0x{build_id:08X} INPUTS=0b{inputs:06b}")
        del input_mmio
        del build_id_mmio
        del overlay
        gc.collect()
    print(f"C2_VERIFY_STATUS=PASS ({iterations}/{iterations})")


def _mmio(overlay: object, ip_name: str, mmio_type: type) -> object:
    try:
        description = overlay.ip_dict[ip_name]  # type: ignore[attr-defined]
    except (AttributeError, KeyError) as error:
        raise RuntimeError(f"{ip_name!r} is absent from HWH") from error
    return mmio_type(int(description["phys_addr"]), int(description["addr_range"]))


def input_observation(name: str, mask: int, baseline: int, asserted: int, released: int) -> dict[str, int | str]:
    return {
        "name": name,
        "mask": mask,
        "baseline": baseline,
        "asserted": asserted,
        "released": released,
        "asserted_change_mask": baseline ^ asserted,
        "released_change_mask": baseline ^ released,
    }


def exercise_inputs(
    read_inputs: Callable[[], int],
    prompt: Callable[[str], str] = input,
) -> list[dict[str, int | str]]:
    observations: list[dict[str, int | str]] = []
    for name, mask in INPUT_BITS:
        baseline = read_inputs()
        prompt(f"Hold {name}, then press Enter: ")
        asserted = read_inputs()
        prompt(f"Release {name}, then press Enter: ")
        released = read_inputs()
        observation = input_observation(name, mask, baseline, asserted, released)
        observations.append(observation)
        print(
            f"C2_INPUT_{name} baseline=0b{baseline:06b} "
            f"asserted=0b{asserted:06b} released=0b{released:06b}"
        )
    return observations


def main() -> None:
    parser = argparse.ArgumentParser(description="Verify the PYNQ-Z2 C2 overlay")
    parser.add_argument("bitstream", type=Path)
    parser.add_argument("--iterations", type=int, default=10)
    parser.add_argument("--exercise-inputs", action="store_true")
    parser.add_argument("--inputs-only", action="store_true")
    parser.add_argument("--evidence", type=Path, default=Path("c2_input_evidence.json"))
    args = parser.parse_args()
    if args.iterations < 1:
        parser.error("--iterations must be at least 1")
    if args.inputs_only and not args.exercise_inputs:
        parser.error("--inputs-only requires --exercise-inputs")
    if not args.inputs_only:
        verify_overlay(args.bitstream.resolve(), args.iterations)
    if args.exercise_inputs:
        from pynq import MMIO, Overlay

        overlay = Overlay(str(args.bitstream.resolve()), download=True)
        mmio = _mmio(overlay, INPUT_IP, MMIO)
        observations = exercise_inputs(lambda: mmio.read(0) & INPUT_MASK)
        args.evidence.resolve().write_text(
            json.dumps(observations, sort_keys=True, separators=(",", ":")) + "\n",
            encoding="ascii",
        )
        print(f"C2_INPUT_EVIDENCE={args.evidence.resolve()}")


if __name__ == "__main__":
    main()