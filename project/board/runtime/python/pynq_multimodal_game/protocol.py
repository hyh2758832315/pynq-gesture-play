from __future__ import annotations

import struct
import zlib
from dataclasses import dataclass
from enum import IntEnum
from typing import Iterable


PROTOCOL_MAGIC = b"VVGP"
PROTOCOL_MAJOR = 1
PROTOCOL_MINOR = 0
HEADER_FORMAT = ">4sHHHHIIQQIII"
HEADER_SIZE = struct.calcsize(HEADER_FORMAT)
MAX_PAYLOAD_SIZE = 8 * 1024 * 1024


class MessageType(IntEnum):
    HELLO = 1
    HELLO_ACK = 2
    COMMAND = 3
    COMMAND_RESULT = 4
    SUBSCRIBE = 5
    DATA = 6
    TELEMETRY = 7
    PING = 8
    PONG = 9
    ERROR = 10


class ProtocolError(ValueError):
    pass


@dataclass(frozen=True)
class ProtocolFrame:
    message_type: MessageType
    payload: bytes = b""
    flags: int = 0
    sequence: int = 0
    timestamp_ns: int = 0
    source_id: int = 0
    channel_id: int = 0
    protocol_major: int = PROTOCOL_MAJOR
    protocol_minor: int = PROTOCOL_MINOR

    def __post_init__(self) -> None:
        object.__setattr__(self, "message_type", MessageType(self.message_type))
        object.__setattr__(self, "payload", bytes(self.payload))
        _require_uint(self.flags, 16, "flags")
        _require_uint(self.sequence, 64, "sequence")
        _require_uint(self.timestamp_ns, 64, "timestamp_ns")
        _require_uint(self.source_id, 32, "source_id")
        _require_uint(self.channel_id, 32, "channel_id")
        _require_uint(self.protocol_major, 16, "protocol_major")
        _require_uint(self.protocol_minor, 16, "protocol_minor")
        if len(self.payload) > MAX_PAYLOAD_SIZE:
            raise ProtocolError("payload exceeds protocol limit")

    def to_bytes(self) -> bytes:
        header = _pack_header(self, checksum=0)
        checksum = zlib.crc32(header + self.payload) & 0xFFFFFFFF
        return _pack_header(self, checksum=checksum) + self.payload


class FrameDecoder:
    def __init__(
        self,
        *,
        accepted_versions: Iterable[tuple[int, int]] = ((PROTOCOL_MAJOR, PROTOCOL_MINOR),),
        max_payload_size: int = MAX_PAYLOAD_SIZE,
    ) -> None:
        versions = frozenset(accepted_versions)
        if not versions:
            raise ValueError("accepted_versions must not be empty")
        if not 0 <= max_payload_size <= MAX_PAYLOAD_SIZE:
            raise ValueError("max_payload_size is outside the protocol limit")
        self._accepted_versions = versions
        self._max_payload_size = max_payload_size
        self._buffer = bytearray()

    @property
    def buffered_bytes(self) -> int:
        return len(self._buffer)

    def feed(self, data: bytes | bytearray | memoryview) -> list[ProtocolFrame]:
        self._buffer.extend(data)
        frames: list[ProtocolFrame] = []
        while len(self._buffer) >= HEADER_SIZE:
            values = struct.unpack_from(HEADER_FORMAT, self._buffer)
            (
                magic,
                major,
                minor,
                raw_message_type,
                flags,
                header_size,
                payload_size,
                sequence,
                timestamp_ns,
                source_id,
                channel_id,
                checksum,
            ) = values
            if magic != PROTOCOL_MAGIC:
                raise ProtocolError("invalid protocol magic")
            if header_size != HEADER_SIZE:
                raise ProtocolError("unsupported header size")
            if (major, minor) not in self._accepted_versions:
                raise ProtocolError(f"unsupported protocol version {major}.{minor}")
            if payload_size > self._max_payload_size:
                raise ProtocolError("payload exceeds decoder limit")
            frame_size = HEADER_SIZE + payload_size
            if len(self._buffer) < frame_size:
                break
            encoded = bytes(self._buffer[:frame_size])
            payload = encoded[HEADER_SIZE:]
            zero_checksum_header = bytearray(encoded[:HEADER_SIZE])
            zero_checksum_header[-4:] = b"\x00\x00\x00\x00"
            actual_checksum = zlib.crc32(zero_checksum_header + payload) & 0xFFFFFFFF
            if checksum != actual_checksum:
                raise ProtocolError("frame CRC32 mismatch")
            try:
                message_type = MessageType(raw_message_type)
            except ValueError as error:
                raise ProtocolError(f"unknown message type {raw_message_type}") from error
            frames.append(
                ProtocolFrame(
                    message_type=message_type,
                    payload=payload,
                    flags=flags,
                    sequence=sequence,
                    timestamp_ns=timestamp_ns,
                    source_id=source_id,
                    channel_id=channel_id,
                    protocol_major=major,
                    protocol_minor=minor,
                )
            )
            del self._buffer[:frame_size]
        return frames


def _pack_header(frame: ProtocolFrame, *, checksum: int) -> bytes:
    return struct.pack(
        HEADER_FORMAT,
        PROTOCOL_MAGIC,
        frame.protocol_major,
        frame.protocol_minor,
        int(frame.message_type),
        frame.flags,
        HEADER_SIZE,
        len(frame.payload),
        frame.sequence,
        frame.timestamp_ns,
        frame.source_id,
        frame.channel_id,
        checksum,
    )


def _require_uint(value: int, bits: int, name: str) -> None:
    if not 0 <= value < 1 << bits:
        raise ProtocolError(f"{name} does not fit in {bits} unsigned bits")