from __future__ import annotations

import argparse
from dataclasses import asdict, dataclass
import importlib.util
import json
from pathlib import Path
import time
from typing import Any, Callable
import zlib

from pynq_multimodal_game.agent import AgentClient
from pynq_multimodal_game.protocol import MessageType
from pynq_multimodal_game.streaming import C6I_OPAQUE_RETURN_SOURCE_ID

try:
    from verify_c6t import deterministic_return_payload
except ModuleNotFoundError:
    _verify_c6t_path = Path(__file__).with_name("verify_c6t.py")
    _spec = importlib.util.spec_from_file_location("verify_c6t", _verify_c6t_path)
    if _spec is None or _spec.loader is None:
        raise
    _module = importlib.util.module_from_spec(_spec)
    _spec.loader.exec_module(_module)
    deterministic_return_payload = _module.deterministic_return_payload


EXPECTED_BUILD_ID = 0xC0060700
DEFAULT_SEED_BASE = 0xC6D00000


@dataclass(frozen=True)
class S3BAgentSummary:
    frames: int
    bytes_received: int
    first_sequence: int
    last_sequence: int
    skipped_sequences: int
    elapsed_seconds: float
    last_crc32: str


def verify_agent(
    host: str,
    port: int,
    *,
    frames: int,
    size: int,
    timeout: float,
    source_id: int = C6I_OPAQUE_RETURN_SOURCE_ID,
    seed_base: int = DEFAULT_SEED_BASE,
    expected_build_id: int = EXPECTED_BUILD_ID,
    client_factory: Callable[..., Any] = AgentClient,
    payload_factory: Callable[[int, int], bytes] = deterministic_return_payload,
) -> S3BAgentSummary:
    if frames < 1:
        raise ValueError("frames must be at least 1")
    if size < 1:
        raise ValueError("size must be positive")
    if timeout <= 0:
        raise ValueError("timeout must be positive")

    client = client_factory(host, port, timeout=timeout)
    started = time.perf_counter()
    first_sequence = 0
    last_sequence = 0
    skipped_sequences = 0
    bytes_received = 0
    last_crc32 = 0
    try:
        hello = client.connect()
        actual_build_id = int(hello["build_id"])
        if actual_build_id != expected_build_id:
            raise RuntimeError(
                f"BUILD_ID mismatch: expected 0x{expected_build_id:08X}, "
                f"got 0x{actual_build_id:08X}"
            )
        subscription = client.subscribe([source_id])
        if subscription != {"ok": True, "source_ids": [source_id]}:
            raise RuntimeError(f"unexpected subscription response: {subscription!r}")

        for index in range(frames):
            frame = client.receive()
            if frame.message_type is not MessageType.DATA:
                raise RuntimeError(f"expected DATA, got {frame.message_type.name}")
            if frame.source_id != source_id or frame.channel_id != 0:
                raise RuntimeError(
                    "unexpected DATA route: "
                    f"source={frame.source_id} channel={frame.channel_id}"
                )
            if frame.sequence < 1:
                raise RuntimeError(f"invalid DATA sequence {frame.sequence}")
            if last_sequence and frame.sequence <= last_sequence:
                raise RuntimeError(
                    f"non-increasing DATA sequence: {last_sequence} -> {frame.sequence}"
                )
            if len(frame.payload) != size:
                raise RuntimeError(
                    f"payload size mismatch: expected {size}, got {len(frame.payload)}"
                )
            seed = (seed_base + frame.sequence - 1) & 0xFFFFFFFF
            expected = payload_factory(size, seed)
            if frame.payload != expected:
                raise RuntimeError(
                    f"payload mismatch at sequence {frame.sequence}: "
                    f"seed=0x{seed:08X} "
                    f"expected_crc=0x{zlib.crc32(expected) & 0xFFFFFFFF:08X} "
                    f"actual_crc=0x{zlib.crc32(frame.payload) & 0xFFFFFFFF:08X}"
                )
            if index == 0:
                first_sequence = frame.sequence
            elif frame.sequence > last_sequence + 1:
                skipped_sequences += frame.sequence - last_sequence - 1
            last_sequence = frame.sequence
            bytes_received += len(frame.payload)
            last_crc32 = zlib.crc32(frame.payload) & 0xFFFFFFFF
    finally:
        client.close()

    return S3BAgentSummary(
        frames=frames,
        bytes_received=bytes_received,
        first_sequence=first_sequence,
        last_sequence=last_sequence,
        skipped_sequences=skipped_sequences,
        elapsed_seconds=time.perf_counter() - started,
        last_crc32=f"0x{last_crc32:08X}",
    )


def main() -> None:
    parser = argparse.ArgumentParser(description="Verify C6I source 3 from Voice View Agent")
    parser.add_argument("--host", default="192.168.2.99")
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--frames", type=int, default=20)
    parser.add_argument("--size", type=int, default=65536)
    parser.add_argument("--timeout", type=float, default=5.0)
    parser.add_argument("--source-id", type=lambda value: int(value, 0), default=C6I_OPAQUE_RETURN_SOURCE_ID)
    parser.add_argument("--seed-base", type=lambda value: int(value, 0), default=DEFAULT_SEED_BASE)
    parser.add_argument("--build-id", type=lambda value: int(value, 0), default=EXPECTED_BUILD_ID)
    args = parser.parse_args()
    try:
        summary = verify_agent(
            args.host,
            args.port,
            frames=args.frames,
            size=args.size,
            timeout=args.timeout,
            source_id=args.source_id,
            seed_base=args.seed_base,
            expected_build_id=args.build_id,
        )
    except (ConnectionError, KeyError, OSError, RuntimeError, ValueError) as error:
        print(f"S3B_AGENT_VERIFY_STATUS=FAIL error={type(error).__name__}: {error}")
        raise SystemExit(1) from error
    print("S3B_AGENT_SUMMARY=" + json.dumps(asdict(summary), sort_keys=True))
    print("S3B_AGENT_VERIFY_STATUS=PASS")


if __name__ == "__main__":
    main()