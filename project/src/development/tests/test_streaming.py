from pynq_multimodal_game.protocol import MessageType, ProtocolFrame
from pynq_multimodal_game.streaming import (
    BoundedStreamBuffer,
    decode_fixture_payload,
    encode_fixture_frame,
    encode_fixture_series,
)


def _frame(sequence: int, *, source_id: int = 1, timestamp_ns: int = 100) -> ProtocolFrame:
    return ProtocolFrame(
        MessageType.DATA,
        encode_fixture_series([1.0, 2.0]),
        sequence=sequence,
        timestamp_ns=timestamp_ns,
        source_id=source_id,
    )


def test_stream_buffer_tracks_latest_stale_and_out_of_order() -> None:
    buffer = BoundedStreamBuffer(capacity=2, stale_after_ns=10)

    assert buffer.push(_frame(1), now_ns=105) is True
    assert buffer.push(_frame(2), now_ns=105) is True
    assert buffer.push(_frame(1), now_ns=105) is False
    assert buffer.push(_frame(3, source_id=2, timestamp_ns=80), now_ns=105) is False

    samples = buffer.drain()
    assert len(samples) == 1
    assert samples[0].frame.sequence == 2
    assert buffer.counters.accepted == 2
    assert buffer.counters.dropped == 1
    assert buffer.counters.out_of_order == 1
    assert buffer.counters.stale == 1


def test_stream_buffer_preserves_unknown_payload_as_opaque() -> None:
    buffer = BoundedStreamBuffer()
    frame = ProtocolFrame(MessageType.DATA, b"not json", sequence=1, source_id=7)

    assert buffer.push(frame) is True
    sample = buffer.drain()[0]
    assert sample.topic == "opaque"
    assert sample.body is None
    assert buffer.counters.malformed == 1


def test_fixture_codecs_are_explicit_and_deterministic() -> None:
    frame_payload = encode_fixture_frame(2, 1, bytes((255, 0, 0, 0, 255, 0)))
    topic, body = decode_fixture_payload(frame_payload)
    assert topic == "fixture.frame2d"
    assert body["format"] == "rgb24"
    assert body["width"] == 2
    assert body["height"] == 1

    assert encode_fixture_series([0, 1], spectrum=True) == (
        b'{"topic":"fixture.spectrum","values":[0.0,1.0]}'
    )