from __future__ import annotations

import argparse
from dataclasses import asdict, is_dataclass
import json
from pathlib import Path
from typing import Any, Callable
import zlib

from pynq_multimodal_game.agent import C6IReturnSource

from verify_c6t import deterministic_return_payload


DEFAULT_SIZES = (64, 4 * 1024, 64 * 1024)
DEFAULT_SEED_BASE = 0xC6C00000
EXPECTED_BUILD_ID = 0xC0060700


def _stats_to_dict(stats: Any) -> dict[str, Any]:
    if is_dataclass(stats):
        return asdict(stats)
    if isinstance(stats, dict):
        return dict(stats)
    return dict(vars(stats))


def verify_source(
    bitstream: Path,
    *,
    sizes: tuple[int, ...] = DEFAULT_SIZES,
    timeout: float = 5.0,
    seed_base: int = DEFAULT_SEED_BASE,
    source_factory: Callable[..., Any] = C6IReturnSource,
    payload_factory: Callable[[int, int], bytes] = deterministic_return_payload,
) -> list[dict[str, Any]]:
    if not sizes or any(size < 1 for size in sizes):
        raise ValueError("sizes must contain positive values")
    if timeout <= 0:
        raise ValueError("timeout must be positive")

    results: list[dict[str, Any]] = []
    for index, size in enumerate(sizes):
        seed = (seed_base + index) & 0xFFFFFFFF
        source = source_factory(
            bitstream,
            size=size,
            timeout_seconds=timeout,
            expected_build_id=EXPECTED_BUILD_ID,
        )
        try:
            source.open()
            payload = source.receive(seed)
            expected = payload_factory(size, seed)
            if payload != expected:
                raise RuntimeError(
                    f"payload mismatch at {size} bytes: "
                    f"expected_crc=0x{zlib.crc32(expected) & 0xFFFFFFFF:08X} "
                    f"actual_crc=0x{zlib.crc32(payload) & 0xFFFFFFFF:08X}"
                )
            result = _stats_to_dict(source.stats)
            result.update(
                size=size,
                seed=f"0x{seed:08X}",
                crc32=f"0x{zlib.crc32(payload) & 0xFFFFFFFF:08X}",
            )
            results.append(result)
        finally:
            source.close()
    return results


def main() -> None:
    parser = argparse.ArgumentParser(description="Smoke-test the C6I Return Source")
    parser.add_argument("bitstream", type=Path)
    parser.add_argument("--timeout", type=float, default=5.0)
    parser.add_argument("--seed-base", type=lambda value: int(value, 0), default=DEFAULT_SEED_BASE)
    args = parser.parse_args()
    try:
        results = verify_source(
            args.bitstream.resolve(),
            timeout=args.timeout,
            seed_base=args.seed_base,
        )
    except (FileNotFoundError, PermissionError, RuntimeError, ValueError) as error:
        print(f"S3B_SOURCE_VERIFY_STATUS=FAIL error={type(error).__name__}: {error}")
        raise SystemExit(1) from error
    for result in results:
        print("S3B_SOURCE_CASE=" + json.dumps(result, sort_keys=True))
    print("S3B_SOURCE_VERIFY_STATUS=PASS")


if __name__ == "__main__":
    main()