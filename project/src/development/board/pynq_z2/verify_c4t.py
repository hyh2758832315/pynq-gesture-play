from __future__ import annotations

import argparse
import os
from pathlib import Path
import time
from typing import Any
import xml.etree.ElementTree as ET
import zlib


EXPECTED_BUILD_ID = 0xC0040000
BUILD_ID_IP = "build_id_gpio"
DMA_IP = "axi_dma"
STATUS_IP = "upload_status_gpio"
COUNT_IP = "upload_count_gpio"
GPIO_DATA_OFFSET = 0x0
GPIO2_DATA_OFFSET = 0x8
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


def ip_address(
    overlay: Any,
    hwh: Path,
    instance: str,
) -> tuple[int, int]:
    description = overlay.ip_dict.get(instance)
    if description is not None:
        return int(description["phys_addr"]), int(description["addr_range"])
    return hwh_address(hwh, instance)


def deterministic_payload(size: int, seed: int) -> bytes:
    if size < 1:
        raise ValueError("payload size must be positive")
    state = seed & 0xFFFFFFFF
    payload = bytearray(size)
    for index in range(size):
        state = (1664525 * state + 1013904223) & 0xFFFFFFFF
        payload[index] = state >> 24
    return bytes(payload)


def percentile(values: list[float], fraction: float) -> float:
    if not values:
        raise ValueError("percentile requires at least one value")
    ordered = sorted(values)
    index = round((len(ordered) - 1) * fraction)
    return ordered[index]


def wait_for_packet(
    count_mmio: Any,
    expected_count: int,
    timeout_seconds: float,
) -> None:
    deadline = time.perf_counter() + timeout_seconds
    while count_mmio.read(GPIO_DATA_OFFSET) != expected_count:
        if time.perf_counter() >= deadline:
            actual = count_mmio.read(GPIO_DATA_OFFSET)
            raise TimeoutError(
                f"upload packet count timeout: expected {expected_count}, got {actual}"
            )


def run_transfer(
    dma: Any,
    status_mmio: Any,
    count_mmio: Any,
    allocate: Any,
    payload: bytes,
    timeout_seconds: float,
) -> tuple[int, int, float]:
    import numpy as np

    buffer = allocate(shape=(len(payload),), dtype=np.uint8)
    try:
        buffer[:] = np.frombuffer(payload, dtype=np.uint8)
        buffer.flush()
        before_count = count_mmio.read(GPIO_DATA_OFFSET)
        expected_count = (before_count + 1) & 0xFFFFFFFF
        started = time.perf_counter()
        dma.sendchannel.transfer(buffer)
        dma.sendchannel.wait()
        wait_for_packet(count_mmio, expected_count, timeout_seconds)
        elapsed = time.perf_counter() - started
        crc32 = status_mmio.read(GPIO_DATA_OFFSET)
        byte_count = status_mmio.read(GPIO2_DATA_OFFSET)
        return crc32, byte_count, elapsed
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
    build_address, build_range = ip_address(overlay, hwh, BUILD_ID_IP)
    status_address, status_range = ip_address(overlay, hwh, STATUS_IP)
    count_address, count_range = ip_address(overlay, hwh, COUNT_IP)
    build_mmio = MMIO(build_address, build_range)
    status_mmio = MMIO(status_address, status_range)
    count_mmio = MMIO(count_address, count_range)

    actual_build_id = build_mmio.read(GPIO_DATA_OFFSET)
    print(f"C4T_BUILD_ID=0x{actual_build_id:08X}")
    if actual_build_id != EXPECTED_BUILD_ID:
        raise RuntimeError(
            f"BUILD_ID mismatch: expected 0x{EXPECTED_BUILD_ID:08X}, "
            f"got 0x{actual_build_id:08X}"
        )

    dma = getattr(overlay, DMA_IP)
    for case_index, size in enumerate(DEFAULT_SIZES, start=1):
        payload = deterministic_payload(size, 0xC4000000 + case_index)
        expected_crc32 = zlib.crc32(payload) & 0xFFFFFFFF
        actual_crc32, actual_bytes, elapsed = run_transfer(
            dma,
            status_mmio,
            count_mmio,
            allocate,
            payload,
            timeout_seconds,
        )
        if actual_crc32 != expected_crc32 or actual_bytes != size:
            raise RuntimeError(
                f"transfer mismatch at {size} bytes: "
                f"crc expected 0x{expected_crc32:08X}, got 0x{actual_crc32:08X}; "
                f"byte count expected {size}, got {actual_bytes}"
            )
        throughput = size / elapsed / 1_000_000
        print(
            f"C4T_CASE_{size}=PASS crc=0x{actual_crc32:08X} "
            f"bytes={actual_bytes} mbps={throughput:.3f}"
        )

    benchmark_payload = deterministic_payload(1024 * 1024, 0xC4B00001)
    throughputs: list[float] = []
    for repeat in range(1, benchmark_repeats + 1):
        expected_crc32 = zlib.crc32(benchmark_payload) & 0xFFFFFFFF
        actual_crc32, actual_bytes, elapsed = run_transfer(
            dma,
            status_mmio,
            count_mmio,
            allocate,
            benchmark_payload,
            timeout_seconds,
        )
        if actual_crc32 != expected_crc32 or actual_bytes != len(benchmark_payload):
            raise RuntimeError(f"benchmark transfer {repeat} failed integrity check")
        throughputs.append(len(benchmark_payload) / elapsed / 1_000_000)

    p50 = percentile(throughputs, 0.50)
    p99 = percentile(throughputs, 0.99)
    print(
        f"C4T_BENCHMARK=PASS repeats={benchmark_repeats} "
        f"p50_mbps={p50:.3f} p99_mbps={p99:.3f}"
    )
    print("C4T_VERIFY_STATUS=PASS")


def main() -> None:
    parser = argparse.ArgumentParser(description="Verify the PYNQ-Z2 C4T DMA overlay")
    parser.add_argument("bitstream", type=Path, help="Path to c4_transport.bit")
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