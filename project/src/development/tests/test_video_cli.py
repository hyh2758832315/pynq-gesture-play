import json

import av
import numpy as np
import pytest

from pynq_multimodal_game import video_cli
from pynq_multimodal_game.video_codec import (
    S2V1_HEIGHT,
    S2V1_RESIZE_FILTERS,
    S2V1Reader,
    S2V1_WIDTH,
    decode_video_frames,
    encode_rgb_frames,
)


def _solid_rgb(red: int, green: int, blue: int) -> bytes:
    return bytes((red, green, blue)) * (S2V1_WIDTH * S2V1_HEIGHT)


def _summary(output: str, marker: str) -> dict[str, object]:
    line = next(item for item in output.splitlines() if item.startswith(f"{marker}="))
    return json.loads(line.split("=", 1)[1])


def test_cli_encode_inspect_and_verify(tmp_path, monkeypatch, capsys) -> None:
    frames = (_solid_rgb(252, 4, 4), _solid_rgb(4, 252, 4))
    output = tmp_path / "fixture.s2v"
    monkeypatch.setattr(video_cli, "decode_video_frames", lambda *_args, **_kwargs: iter(frames))

    assert video_cli.main(["encode", "input.mp4", str(output), "--gop-size", "2"]) == 0
    encode_output = capsys.readouterr().out
    assert _summary(encode_output, "S2V1_ENCODE_SUMMARY")["frames"] == 2

    assert video_cli.main(["inspect", str(output)]) == 0
    inspect_output = capsys.readouterr().out
    assert _summary(inspect_output, "S2V1_INSPECT_SUMMARY")["gops"] == 1

    assert video_cli.main(["verify", str(output)]) == 0
    verify_output = capsys.readouterr().out
    assert _summary(verify_output, "S2V1_VERIFY_SUMMARY")["frames"] == 2


def test_cli_encode_accepts_stable_quality_profile(tmp_path, monkeypatch, capsys) -> None:
    frames = (_solid_rgb(252, 4, 4), _solid_rgb(4, 252, 4))
    output = tmp_path / "stable.s2v"
    monkeypatch.setattr(video_cli, "decode_video_frames", lambda *_args, **_kwargs: iter(frames))

    assert video_cli.main(
        [
            "encode",
            "input.mp4",
            str(output),
            "--gop-size",
            "1",
            "--quality-profile",
            "stable",
        ]
    ) == 0

    summary = _summary(capsys.readouterr().out, "S2V1_ENCODE_SUMMARY")
    assert summary["quality_profile"] == "stable"
    with S2V1Reader(output) as reader:
        assert reader.manifest["encoding"] == {"quality_profile": "stable"}


@pytest.mark.parametrize("resize_filter", S2V1_RESIZE_FILTERS)
def test_decode_video_frames_normalizes_real_pyav_input(tmp_path, resize_filter) -> None:
    source = tmp_path / "source.avi"
    with av.open(str(source), "w") as container:
        stream = container.add_stream("mpeg4", rate=10)
        stream.width = 64
        stream.height = 48
        stream.pix_fmt = "yuv420p"
        for color in ((255, 0, 0), (0, 255, 0), (0, 0, 255)):
            pixels = np.empty((48, 64, 3), dtype=np.uint8)
            pixels[:] = color
            frame = av.VideoFrame.from_ndarray(pixels, format="rgb24")
            for packet in stream.encode(frame):
                container.mux(packet)
        for packet in stream.encode():
            container.mux(packet)

    decoded = list(decode_video_frames(source, max_frames=2, resize_filter=resize_filter))

    assert len(decoded) == 2
    assert all(len(frame) == S2V1_WIDTH * S2V1_HEIGHT * 3 for frame in decoded)


@pytest.mark.parametrize("resize_filter", S2V1_RESIZE_FILTERS)
def test_cli_passes_resize_filter_to_decoder(tmp_path, monkeypatch, capsys, resize_filter) -> None:
    requests = []

    def decode(source, **options):
        requests.append((source, options))
        return iter((_solid_rgb(252, 4, 4),))

    monkeypatch.setattr(video_cli, "decode_video_frames", decode)
    output = tmp_path / "resize.s2v"
    assert video_cli.main([
        "encode", "source.mp4", str(output), "--max-frames", "1",
        "--resize-filter", resize_filter, "--quality-profile", "spatial-resident",
    ]) == 0
    assert requests[0][1] == {"max_frames": 1, "resize_filter": resize_filter}
    summary = _summary(capsys.readouterr().out, "S2V1_ENCODE_SUMMARY")
    assert summary["resize_filter"] == resize_filter
    with S2V1Reader(output) as reader:
        assert len(list(reader.iter_frames())) == 1
        assert reader.manifest["encoding"]["quality_profile"] == "spatial-resident"


def test_decode_rejects_unknown_resize_filter(tmp_path) -> None:
    with pytest.raises(ValueError, match="Unknown S2V1 resize filter"):
        list(decode_video_frames(tmp_path / "missing.mp4", resize_filter="unknown"))


@pytest.mark.parametrize("resize_filter", S2V1_RESIZE_FILTERS)
def test_downscale_matches_pyav_filter_and_is_repeatable(tmp_path, resize_filter) -> None:
    source = tmp_path / "detail.mkv"
    pixels = np.random.default_rng(7).integers(0, 256, (360, 640, 3), dtype=np.uint8)
    with av.open(str(source), "w") as container:
        stream = container.add_stream("ffv1", rate=30)
        stream.width = 640
        stream.height = 360
        stream.pix_fmt = "bgr0"
        frame = av.VideoFrame.from_ndarray(pixels, format="rgb24")
        for packet in stream.encode(frame):
            container.mux(packet)
        for packet in stream.encode():
            container.mux(packet)

    with av.open(str(source)) as container:
        frame = next(container.decode(video=0))
        options = {} if resize_filter == "legacy" else {"interpolation": resize_filter.upper()}
        expected = frame.reformat(
            width=S2V1_WIDTH, height=S2V1_HEIGHT, format="rgb24", **options,
        ).to_ndarray().tobytes()
    decoded = list(decode_video_frames(source, resize_filter=resize_filter))
    assert decoded == [expected]
    assert decoded == list(decode_video_frames(source, resize_filter=resize_filter))
    if resize_filter == "legacy":
        assert decoded == list(decode_video_frames(source))


def test_cli_reports_invalid_container(tmp_path, capsys) -> None:
    invalid = tmp_path / "invalid.s2v"
    invalid.write_bytes(b"not a zip")

    assert video_cli.main(["verify", str(invalid)]) == 1
    assert "S2V1_STATUS=FAIL" in capsys.readouterr().err


def test_cli_inspect_matches_direct_encoder(tmp_path, capsys) -> None:
    output = tmp_path / "direct.s2v"
    result = encode_rgb_frames((_solid_rgb(252, 4, 4),), output)

    assert video_cli.main(["inspect", str(output)]) == 0
    summary = _summary(capsys.readouterr().out, "S2V1_INSPECT_SUMMARY")
    assert summary["sha256"] == result.sha256