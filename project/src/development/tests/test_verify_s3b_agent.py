from __future__ import annotations

import importlib.util
from pathlib import Path
import sys
from typing import Any

import pytest

from pynq_multimodal_game.protocol import MessageType, ProtocolFrame


BOARD_DIR = Path(__file__).parents[1] / "board" / "pynq_z2"
MODULE_PATH = BOARD_DIR / "verify_s3b_agent.py"
SPEC = importlib.util.spec_from_file_location("verify_s3b_agent", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
verify_s3b_agent = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = verify_s3b_agent
SPEC.loader.exec_module(verify_s3b_agent)


class FakeClient:
    def __init__(self, frames: list[ProtocolFrame], build_id: int) -> None:
        self.frames = iter(frames)
        self.build_id = build_id
        self.closed = False

    def connect(self) -> dict[str, Any]:
        return {"build_id": self.build_id}

    def subscribe(self, source_ids: list[int]) -> dict[str, Any]:
        return {"ok": True, "source_ids": source_ids}

    def receive(self) -> ProtocolFrame:
        return next(self.frames)

    def close(self) -> None:
        self.closed = True


def make_factory(client: FakeClient):
    def factory(host: str, port: int, *, timeout: float) -> FakeClient:
        assert host == "board"
        assert port == 8765
        assert timeout == 2.0
        return client

    return factory


def make_frame(sequence: int, *, source_id: int = 3, payload: bytes | None = None) -> ProtocolFrame:
    seed = (verify_s3b_agent.DEFAULT_SEED_BASE + sequence - 1) & 0xFFFFFFFF
    return ProtocolFrame(
        MessageType.DATA,
        verify_s3b_agent.deterministic_return_payload(64, seed) if payload is None else payload,
        sequence=sequence,
        source_id=source_id,
    )


def test_verify_agent_accepts_fresh_source_three_and_reports_skips() -> None:
    client = FakeClient([make_frame(7), make_frame(9)], verify_s3b_agent.EXPECTED_BUILD_ID)

    summary = verify_s3b_agent.verify_agent(
        "board",
        8765,
        frames=2,
        size=64,
        timeout=2.0,
        client_factory=make_factory(client),
    )

    assert summary.frames == 2
    assert summary.bytes_received == 128
    assert summary.first_sequence == 7
    assert summary.last_sequence == 9
    assert summary.skipped_sequences == 1
    assert summary.last_crc32.startswith("0x")
    assert client.closed is True


@pytest.mark.parametrize(
    "frame, message",
    [
        (make_frame(1, source_id=2), "unexpected DATA route"),
        (make_frame(1, payload=bytes(64)), "payload mismatch"),
        (make_frame(1, payload=bytes(63)), "payload size mismatch"),
    ],
)
def test_verify_agent_rejects_invalid_data(frame: ProtocolFrame, message: str) -> None:
    client = FakeClient([frame], verify_s3b_agent.EXPECTED_BUILD_ID)

    with pytest.raises(RuntimeError, match=message):
        verify_s3b_agent.verify_agent(
            "board",
            8765,
            frames=1,
            size=64,
            timeout=2.0,
            client_factory=make_factory(client),
        )

    assert client.closed is True


def test_verify_agent_rejects_build_id_before_subscribing() -> None:
    client = FakeClient([], 0xDEADBEEF)

    with pytest.raises(RuntimeError, match="BUILD_ID mismatch"):
        verify_s3b_agent.verify_agent(
            "board",
            8765,
            frames=1,
            size=64,
            timeout=2.0,
            client_factory=make_factory(client),
        )

    assert client.closed is True