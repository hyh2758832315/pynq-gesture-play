from __future__ import annotations

import base64
import json
import time
from collections import OrderedDict
from dataclasses import dataclass, replace
from typing import Any

from .protocol import MessageType, ProtocolFrame


FIXTURE_VISION_SOURCE_ID = 1
FIXTURE_AUDIO_SOURCE_ID = 2
C6I_OPAQUE_RETURN_SOURCE_ID = 3


@dataclass(frozen=True)
class StreamCounters:
    accepted: int = 0
    dropped: int = 0
    stale: int = 0
    out_of_order: int = 0
    malformed: int = 0


@dataclass(frozen=True)
class StreamSample:
    frame: ProtocolFrame
    topic: str
    body: dict[str, Any] | None


class BoundedStreamBuffer:
    def __init__(self, *, capacity: int = 32, stale_after_ns: int = 2_000_000_000) -> None:
        if capacity <= 0:
            raise ValueError("capacity must be positive")
        if stale_after_ns < 0:
            raise ValueError("stale_after_ns must not be negative")
        self._capacity = capacity
        self._stale_after_ns = stale_after_ns
        self._samples: OrderedDict[tuple[int, int], StreamSample] = OrderedDict()
        self._last_sequence: dict[tuple[int, int], int] = {}
        self._counters = StreamCounters()

    @property
    def counters(self) -> StreamCounters:
        return self._counters

    def push(self, frame: ProtocolFrame, *, now_ns: int | None = None) -> bool:
        if frame.message_type is not MessageType.DATA:
            raise ValueError("stream buffer only accepts DATA frames")
        key = (frame.source_id, frame.channel_id)
        previous_sequence = self._last_sequence.get(key)
        if previous_sequence is not None and frame.sequence <= previous_sequence:
            self._counters = replace(
                self._counters,
                out_of_order=self._counters.out_of_order + 1,
            )
            return False
        self._last_sequence[key] = frame.sequence
        current_ns = time.time_ns() if now_ns is None else now_ns
        if (
            frame.timestamp_ns > 0
            and current_ns > frame.timestamp_ns
            and current_ns - frame.timestamp_ns > self._stale_after_ns
        ):
            self._counters = replace(self._counters, stale=self._counters.stale + 1)
            return False
        try:
            topic, body = decode_fixture_payload(frame.payload)
        except (UnicodeDecodeError, ValueError, json.JSONDecodeError):
            topic, body = "opaque", None
            self._counters = replace(self._counters, malformed=self._counters.malformed + 1)
        if key in self._samples:
            del self._samples[key]
            self._counters = replace(self._counters, dropped=self._counters.dropped + 1)
        elif len(self._samples) >= self._capacity:
            self._samples.popitem(last=False)
            self._counters = replace(self._counters, dropped=self._counters.dropped + 1)
        self._samples[key] = StreamSample(frame=frame, topic=topic, body=body)
        self._counters = replace(self._counters, accepted=self._counters.accepted + 1)
        return True

    def drain(self) -> list[StreamSample]:
        samples = list(self._samples.values())
        self._samples.clear()
        return samples


def encode_fixture_payload(topic: str, **fields: Any) -> bytes:
    if not topic.startswith("fixture."):
        raise ValueError("fixture topic must use the fixture.* namespace")
    body = {"topic": topic, **fields}
    return json.dumps(body, sort_keys=True, separators=(",", ":")).encode("utf-8")


def encode_fixture_frame(width: int, height: int, rgb: bytes) -> bytes:
    if width <= 0 or height <= 0 or len(rgb) != width * height * 3:
        raise ValueError("fixture RGB dimensions do not match payload")
    return encode_fixture_payload(
        "fixture.frame2d",
        width=width,
        height=height,
        format="rgb24",
        data_base64=base64.b64encode(rgb).decode("ascii"),
    )


def encode_fixture_series(values: list[float], *, spectrum: bool = False) -> bytes:
    if not values or not all(isinstance(value, (int, float)) for value in values):
        raise ValueError("fixture series requires numeric values")
    topic = "fixture.spectrum" if spectrum else "fixture.series"
    return encode_fixture_payload(topic, values=[float(value) for value in values])


def decode_fixture_payload(payload: bytes) -> tuple[str, dict[str, Any]]:
    body = json.loads(payload.decode("utf-8"))
    if not isinstance(body, dict):
        raise ValueError("stream JSON must be an object")
    topic = body.get("topic")
    if not isinstance(topic, str) or not topic:
        raise ValueError("stream JSON requires a topic")
    return topic, body