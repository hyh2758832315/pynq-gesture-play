from __future__ import annotations

from dataclasses import dataclass
import importlib.util
from pathlib import Path
import sys
from types import SimpleNamespace
from typing import Any

import pytest


BOARD_DIR = Path(__file__).parents[1] / "board" / "pynq_z2"
MODULE_PATH = BOARD_DIR / "verify_s3b_source.py"
sys.path.insert(0, str(BOARD_DIR))
SPEC = importlib.util.spec_from_file_location("verify_s3b_source", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
verify_s3b_source = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = verify_s3b_source
SPEC.loader.exec_module(verify_s3b_source)


@dataclass
class SourceRecord:
    size: int
    opened: bool = False
    closed: bool = False


def make_source_factory(records: list[SourceRecord], *, corrupt_size: int | None = None):
    class FakeSource:
        def __init__(self, _bitstream: Path, *, size: int, **kwargs: Any) -> None:
            assert kwargs["timeout_seconds"] == 2.0
            assert kwargs["expected_build_id"] == verify_s3b_source.EXPECTED_BUILD_ID
            self.record = SourceRecord(size)
            records.append(self.record)
            self.stats = SimpleNamespace(
                transfers=1,
                total_bytes=size,
                last_seed=None,
                last_elapsed_seconds=0.001,
                dma_status=2,
                packet_count=1,
                rejected_count=0,
            )

        def open(self) -> None:
            self.record.opened = True

        def receive(self, seed: int) -> bytes:
            self.stats.last_seed = seed
            if self.record.size == corrupt_size:
                return bytes(self.record.size)
            return verify_s3b_source.deterministic_return_payload(self.record.size, seed)

        def close(self) -> None:
            self.record.closed = True

    return FakeSource


def test_verify_source_checks_all_sizes_and_closes_each_source() -> None:
    records: list[SourceRecord] = []

    results = verify_s3b_source.verify_source(
        Path("c6i.bit"),
        sizes=(64, 4096, 65536),
        timeout=2.0,
        source_factory=make_source_factory(records),
    )

    assert [result["size"] for result in results] == [64, 4096, 65536]
    assert [result["seed"] for result in results] == [
        "0xC6C00000",
        "0xC6C00001",
        "0xC6C00002",
    ]
    assert all(record.opened and record.closed for record in records)


def test_verify_source_closes_after_payload_mismatch() -> None:
    records: list[SourceRecord] = []

    with pytest.raises(RuntimeError, match="payload mismatch"):
        verify_s3b_source.verify_source(
            Path("c6i.bit"),
            sizes=(64,),
            timeout=2.0,
            source_factory=make_source_factory(records, corrupt_size=64),
        )

    assert records[0].closed is True