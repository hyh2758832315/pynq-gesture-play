import struct

import pytest

from pynq_multimodal_game.protocol import (
    HEADER_FORMAT,
    HEADER_SIZE,
    MAX_PAYLOAD_SIZE,
    FrameDecoder,
    MessageType,
    ProtocolError,
    ProtocolFrame,
)


def test_protocol_frame_round_trip_one_byte_at_a_time() -> None:
    encoded = ProtocolFrame(
        message_type=MessageType.DATA,
        payload=b"opaque payload",
        flags=3,
        sequence=0x1020304050607080,
        timestamp_ns=123456789,
        source_id=7,
        channel_id=11,
    ).to_bytes()
    decoder = FrameDecoder()
    decoded = []

    for value in encoded:
        decoded.extend(decoder.feed(bytes((value,))))

    assert len(decoded) == 1
    assert decoded[0].payload == b"opaque payload"
    assert decoded[0].sequence == 0x1020304050607080
    assert decoded[0].source_id == 7
    assert decoded[0].channel_id == 11
    assert decoder.buffered_bytes == 0


def test_protocol_decoder_returns_multiple_coalesced_frames() -> None:
    first = ProtocolFrame(MessageType.PING, sequence=1).to_bytes()
    second = ProtocolFrame(MessageType.PONG, payload=b"ok", sequence=2).to_bytes()

    frames = FrameDecoder().feed(first + second)

    assert [frame.message_type for frame in frames] == [MessageType.PING, MessageType.PONG]
    assert [frame.sequence for frame in frames] == [1, 2]


@pytest.mark.parametrize(
    ("offset", "replacement", "message"),
    (
        (0, b"BAD!", "magic"),
        (4, b"\x00\x02", "version"),
        (12, b"\x00\x00\x00\x20", "header size"),
    ),
)
def test_protocol_decoder_rejects_invalid_header(
    offset: int,
    replacement: bytes,
    message: str,
) -> None:
    encoded = bytearray(ProtocolFrame(MessageType.PING).to_bytes())
    encoded[offset : offset + len(replacement)] = replacement

    with pytest.raises(ProtocolError, match=message):
        FrameDecoder().feed(encoded)


def test_protocol_decoder_rejects_crc_mismatch() -> None:
    encoded = bytearray(ProtocolFrame(MessageType.DATA, payload=b"data").to_bytes())
    encoded[-1] ^= 0xFF

    with pytest.raises(ProtocolError, match="CRC32"):
        FrameDecoder().feed(encoded)


def test_protocol_decoder_rejects_unknown_message_type_with_valid_crc() -> None:
    encoded = bytearray(ProtocolFrame(MessageType.PING).to_bytes())
    values = list(struct.unpack(HEADER_FORMAT, encoded[:HEADER_SIZE]))
    values[3] = 0xFFFF
    values[-1] = 0
    header = struct.pack(HEADER_FORMAT, *values)
    import zlib

    values[-1] = zlib.crc32(header) & 0xFFFFFFFF
    encoded[:HEADER_SIZE] = struct.pack(HEADER_FORMAT, *values)

    with pytest.raises(ProtocolError, match="unknown message type"):
        FrameDecoder().feed(encoded)


def test_protocol_payload_limits_are_enforced() -> None:
    with pytest.raises(ProtocolError, match="protocol limit"):
        ProtocolFrame(MessageType.DATA, payload=b"x" * (MAX_PAYLOAD_SIZE + 1))

    encoded = ProtocolFrame(MessageType.DATA, payload=b"12345").to_bytes()
    with pytest.raises(ProtocolError, match="decoder limit"):
        FrameDecoder(max_payload_size=4).feed(encoded)