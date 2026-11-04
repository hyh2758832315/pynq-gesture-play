from __future__ import annotations

import argparse
from functools import lru_cache
import os
from pathlib import Path
import time
from typing import Any
import xml.etree.ElementTree as ET
import zlib


EXPECTED_BUILD_ID = 0xC0060000
BUILD_ID_IP = "build_id_gpio"
DMA_IP = "return_dma"
CONTROL_IP = "return_control_gpio"
START_IP = "return_start_gpio"
STATUS_IP = "return_status_gpio"
STATE_IP = "return_state_gpio"
GPIO_DATA_OFFSET = 0x0
GPIO2_DATA_OFFSET = 0x8
S2MM_STATUS_OFFSET = 0x34
DMA_IDLE_MASK = 0x2
DMA_ERROR_MASK = 0x770
DEFAULT_SIZES = (64, 4 * 1024, 64 * 1024, 1024 * 1024)


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


def pattern_byte(seed: int, index: int) -> int:
    mixed = (seed ^ index) & 0xFFFFFFFF
    return (
        mixed
        ^ (mixed >> 8)
        ^ (mixed >> 16)
        ^ (mixed >> 24)
    ) & 0xFF


@lru_cache(maxsize=8)
def _zero_seed_payload(size: int) -> bytes:
    return bytes(pattern_byte(0, index) for index in range(size))


def deterministic_return_payload(size: int, seed: int) -> bytes:
    if size < 1:
        raise ValueError("payload size must be positive")
    if not 0 <= seed <= 0xFFFFFFFF:
        raise ValueError("seed must fit in 32 bits")
    seed_byte = pattern_byte(seed, 0)
    translation = bytes(value ^ seed_byte for value in range(256))
    return _zero_seed_payload(size).translate(translation)


def percentile(values: list[float], fraction: float) -> float:
    if not values:
        raise ValueError("percentile requires at least one value")
    ordered = sorted(values)
    index = round((len(ordered) - 1) * fraction)
    return ordered[index]


def wait_for_s2mm(dma_mmio: Any, timeout_seconds: float) -> int:
    deadline = time.perf_counter() + timeout_seconds
    while True:
        status = int(dma_mmio.read(S2MM_STATUS_OFFSET))
        if status & DMA_ERROR_MASK:
            raise RuntimeError(f"S2MM DMA error status 0x{status:08X}")
        if status & DMA_IDLE_MASK:
            return status
        if time.perf_counter() >= deadline:
            raise TimeoutError(f"S2MM DMA timeout with status 0x{status:08X}")


def wait_for_packet(
    status_mmio: Any,
    expected_count: int,
    timeout_seconds: float,
) -> None:
    deadline = time.perf_counter() + timeout_seconds
    while status_mmio.read(GPIO2_DATA_OFFSET) != expected_count:
        if time.perf_counter() >= deadline:
            actual = status_mmio.read(GPIO2_DATA_OFFSET)
            raise TimeoutError(
                f"return packet count timeout: expected {expected_count}, got {actual}"
            )


def run_transfer(
    dma: Any,
    control_mmio: Any,
    start_mmio: Any,
    status_mmio: Any,
    allocate: Any,
    size: int,
    seed: int,
    timeout_seconds: float,
) -> tuple[bytes, float]:
    import numpy as np

    buffer = allocate(shape=(size,), dtype=np.uint8)
    try:
        buffer[:] = 0
        buffer.flush()
        before_count = status_mmio.read(GPIO2_DATA_OFFSET)
        expected_count = (before_count + 1) & 0xFFFFFFFF
        dma.recvchannel.transfer(buffer)
        control_mmio.write(GPIO_DATA_OFFSET, size)
        control_mmio.write(GPIO2_DATA_OFFSET, seed)
        started = time.perf_counter()
        start_mmio.write(GPIO_DATA_OFFSET, 1)
        start_mmio.write(GPIO_DATA_OFFSET, 0)
        wait_for_s2mm(dma.mmio, timeout_seconds)
        wait_for_packet(status_mmio, expected_count, timeout_seconds)
        elapsed = time.perf_counter() - started
        buffer.invalidate()
        return bytes(buffer), elapsed
    finally:
        buffer.freebuffer()


def verify_overlay(
    bitstream: Path,
    benchmark_repeats: int,
    timeout_seconds: float,
) -> None:
    if os.geteuid() != 0:
        raise PermissionError("PYNQ Overlay loading requires root; run with sudo -n")
    if not bitstream.is_file():
        raise FileNotFoundError(bitstream)
    hwh = bitstream.with_suffix(".hwh")
    if not hwh.is_file():
        raise FileNotFoundError(hwh)

    from pynq import MMIO, Overlay, allocate

    overlay = Overlay(str(bitstream), download=True)
    build_mmio = MMIO(*ip_address(overlay, hwh, BUILD_ID_IP))
    control_mmio = MMIO(*ip_address(overlay, hwh, CONTROL_IP))
    start_mmio = MMIO(*ip_address(overlay, hwh, START_IP))
    status_mmio = MMIO(*ip_address(overlay, hwh, STATUS_IP))
    state_mmio = MMIO(*ip_address(overlay, hwh, STATE_IP))

    actual_build_id = build_mmio.read(GPIO_DATA_OFFSET)
    print(f"C6T_BUILD_ID=0x{actual_build_id:08X}")
    if actual_build_id != EXPECTED_BUILD_ID:
        raise RuntimeError(
            f"BUILD_ID mismatch: expected 0x{EXPECTED_BUILD_ID:08X}, "
            f"got 0x{actual_build_id:08X}"
        )

    dma = getattr(overlay, DMA_IP)
    for case_index, size in enumerate(DEFAULT_SIZES, start=1):
        seed = 0xC6000000 + case_index
        expected = deterministic_return_payload(size, seed)
        actual, elapsed = run_transfer(
            dma,
            control_mmio,
            start_mmio,
            status_mmio,
            allocate,
            size,
            seed,
            timeout_seconds,
        )
        if actual != expected:
            raise RuntimeError(
                f"return mismatch at {size} bytes: "
                f"crc expected 0x{zlib.crc32(expected) & 0xFFFFFFFF:08X}, "
                f"got 0x{zlib.crc32(actual) & 0xFFFFFFFF:08X}"
            )
        returned_bytes = status_mmio.read(GPIO_DATA_OFFSET)
        if returned_bytes != size:
            raise RuntimeError(
                f"return byte count mismatch: expected {size}, got {returned_bytes}"
            )
        throughput = size / elapsed / 1_000_000
        print(
            f"C6T_CASE_{size}=PASS crc=0x{zlib.crc32(actual) & 0xFFFFFFFF:08X} "
            f"bytes={returned_bytes} mbps={throughput:.3f}"
        )

    benchmark_size = 1024 * 1024
    throughputs: list[float] = []
    for repeat in range(benchmark_repeats):
        seed = 0xC6B00000 + repeat
        expected = deterministic_return_payload(benchmark_size, seed)
        actual, elapsed = run_transfer(
            dma,
            control_mmio,
            start_mmio,
            status_mmio,
            allocate,
            benchmark_size,
            seed,
            timeout_seconds,
        )
        if actual != expected:
            raise RuntimeError(f"benchmark return {repeat + 1} failed integrity check")
        throughputs.append(benchmark_size / elapsed / 1_000_000)
        completed = repeat + 1
        if completed % 10 == 0 or completed == benchmark_repeats:
            print(
                f"C6T_BENCHMARK_PROGRESS={completed}/{benchmark_repeats}",
                flush=True,
            )

    print(
        f"C6T_BENCHMARK=PASS repeats={benchmark_repeats} "
        f"p50_mbps={percentile(throughputs, 0.50):.3f} "
        f"p99_mbps={percentile(throughputs, 0.99):.3f}"
    )
    print(
        f"C6T_STATE busy={state_mmio.read(GPIO_DATA_OFFSET)} "
        f"rejected={state_mmio.read(GPIO2_DATA_OFFSET)}"
    )
    print("C6T_VERIFY_STATUS=PASS")


def main() -> None:
    parser = argparse.ArgumentParser(description="Verify the PYNQ-Z2 C6T return DMA overlay")
    parser.add_argument("bitstream", type=Path, help="Path to c6_return_transport.bit")
    parser.add_argument("--benchmark-repeats", type=int, default=20)
    parser.add_argument("--timeout-seconds", type=float, default=5.0)
    args = parser.parse_args()
    if args.benchmark_repeats < 1:
        parser.error("--benchmark-repeats must be at least 1")
    if args.timeout_seconds <= 0:
        parser.error("--timeout-seconds must be positive")
    verify_overlay(
        args.bitstream.resolve(),
        args.benchmark_repeats,
        args.timeout_seconds,
    )


if __name__ == "__main__":
    main()