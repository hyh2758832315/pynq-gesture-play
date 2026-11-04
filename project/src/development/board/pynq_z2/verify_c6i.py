from __future__ import annotations

import argparse
import os
from pathlib import Path
import time
from typing import Any, Callable
import zlib

import verify_c4m2 as c4m2
import verify_c4m7 as c4m7
import verify_c6t as c6t


EXPECTED_BUILD_ID = 0xC0060700
RETURN_BYTES_PER_FRAME = 1024 * 1024
SEED_BASE = 0xC6A00000


def verify_return_state(state_mmio: Any) -> None:
    busy = state_mmio.read(c6t.GPIO_DATA_OFFSET)
    rejected = state_mmio.read(c6t.GPIO2_DATA_OFFSET)
    if busy != 0 or rejected != 0:
        raise RuntimeError(
            f"C6I return state mismatch: busy={busy} rejected={rejected}"
        )


class ReturnFrameVerifier:
    def __init__(
        self,
        dma: Any,
        control_mmio: Any,
        start_mmio: Any,
        status_mmio: Any,
        allocate: Callable[..., Any],
        iteration: int,
        timeout_seconds: float,
        size: int = RETURN_BYTES_PER_FRAME,
    ) -> None:
        self.dma = dma
        self.control_mmio = control_mmio
        self.start_mmio = start_mmio
        self.status_mmio = status_mmio
        self.iteration = iteration
        self.timeout_seconds = timeout_seconds
        self.size = size
        self.buffer = allocate(shape=(size,), dtype="u1")
        self.pending_tick: int | None = None
        self.expected_count = 0
        self.started = 0.0
        self.throughputs: list[float] = []

    def before_submit(self, tick_index: int) -> None:
        if self.pending_tick is not None:
            raise RuntimeError("previous return transfer is still pending")
        self.buffer[:] = 0
        self.buffer.flush()
        self.expected_count = (
            self.status_mmio.read(c6t.GPIO2_DATA_OFFSET) + 1
        ) & 0xFFFFFFFF
        self.dma.recvchannel.transfer(self.buffer)
        seed = self.seed(tick_index)
        self.control_mmio.write(c6t.GPIO_DATA_OFFSET, self.size)
        self.control_mmio.write(c6t.GPIO2_DATA_OFFSET, seed)
        self.started = time.perf_counter()
        self.start_mmio.write(c6t.GPIO_DATA_OFFSET, 1)
        self.start_mmio.write(c6t.GPIO_DATA_OFFSET, 0)
        self.pending_tick = tick_index

    def after_present(self, tick_index: int) -> None:
        if self.pending_tick != tick_index:
            raise RuntimeError(
                f"return completion order mismatch: {tick_index}/{self.pending_tick}"
            )
        c6t.wait_for_s2mm(self.dma.mmio, self.timeout_seconds)
        c6t.wait_for_packet(
            self.status_mmio,
            self.expected_count,
            self.timeout_seconds,
        )
        elapsed = time.perf_counter() - self.started
        self.buffer.invalidate()
        actual = bytes(self.buffer)
        expected = c6t.deterministic_return_payload(self.size, self.seed(tick_index))
        if actual != expected:
            raise RuntimeError(
                f"C6I frame {tick_index} return mismatch: "
                f"crc expected 0x{zlib.crc32(expected) & 0xFFFFFFFF:08X}, "
                f"got 0x{zlib.crc32(actual) & 0xFFFFFFFF:08X}"
            )
        returned_bytes = self.status_mmio.read(c6t.GPIO_DATA_OFFSET)
        if returned_bytes != self.size:
            raise RuntimeError(
                f"C6I frame {tick_index} byte count mismatch: "
                f"{returned_bytes}/{self.size}"
            )
        self.throughputs.append(self.size / elapsed / 1_000_000)
        self.pending_tick = None

    def seed(self, tick_index: int) -> int:
        return SEED_BASE | ((self.iteration & 0xFF) << 12) | tick_index

    def close(self) -> None:
        self.buffer.freebuffer()


def verify_overlay(
    bitstream: Path,
    replay_path: Path,
    golden_path: Path,
    iterations: int,
    timeout_seconds: float,
) -> None:
    if os.geteuid() != 0:
        raise PermissionError("PYNQ Overlay loading requires root; run with sudo -n")
    if not bitstream.is_file() or not bitstream.with_suffix(".hwh").is_file():
        raise FileNotFoundError("bitstream and matching HWH are required")

    from pynq import MMIO, Overlay, allocate

    hwh = bitstream.with_suffix(".hwh")
    frame_references = c4m7.load_golden(golden_path, replay_path)
    for iteration in range(1, iterations + 1):
        overlay = Overlay(str(bitstream), download=True)

        def mmio(instance: str) -> Any:
            return MMIO(*c4m2.ip_address(overlay, hwh, instance))

        return_verifier = ReturnFrameVerifier(
            getattr(overlay, c6t.DMA_IP),
            mmio(c6t.CONTROL_IP),
            mmio(c6t.START_IP),
            mmio(c6t.STATUS_IP),
            allocate,
            iteration,
            timeout_seconds,
        )
        state_mmio = mmio(c6t.STATE_IP)
        try:
            c4m7.verify_iteration(
                bitstream,
                replay_path,
                iteration,
                timeout_seconds,
                False,
                frame_references,
                overlay=overlay,
                expected_build_id=EXPECTED_BUILD_ID,
                before_submit=return_verifier.before_submit,
                after_present=return_verifier.after_present,
            )
            verify_return_state(state_mmio)
            print(
                f"C6I_LOAD_{iteration:02d}=PASS returns={len(return_verifier.throughputs)} "
                f"p50_mbps={c6t.percentile(return_verifier.throughputs, 0.50):.3f} "
                f"p99_mbps={c6t.percentile(return_verifier.throughputs, 0.99):.3f}",
                flush=True,
            )
        finally:
            return_verifier.close()
    print(f"C6I_VERIFY_STATUS=PASS ({iterations}/{iterations})")


def main() -> None:
    parser = argparse.ArgumentParser(description="Verify the PYNQ-Z2 C6I concurrent overlay")
    parser.add_argument("bitstream", type=Path)
    parser.add_argument(
        "--replay",
        type=Path,
        default=Path("data/replays/c1_demo_controls.jsonl"),
    )
    parser.add_argument("--golden", type=Path)
    parser.add_argument("--iterations", type=int, default=1)
    parser.add_argument("--timeout-seconds", type=float, default=10.0)
    args = parser.parse_args()
    if args.iterations < 1 or args.timeout_seconds <= 0:
        parser.error("iterations and timeout must be positive")
    replay_path = args.replay.resolve()
    golden_path = (
        args.golden.resolve()
        if args.golden is not None
        else replay_path.with_name("c1_demo_c4m7_golden.json")
    )
    if not replay_path.is_file() or not golden_path.is_file():
        raise FileNotFoundError("C1 replay and C4M7 golden files are required")
    verify_overlay(
        args.bitstream.resolve(),
        replay_path,
        golden_path,
        args.iterations,
        args.timeout_seconds,
    )


if __name__ == "__main__":
    main()