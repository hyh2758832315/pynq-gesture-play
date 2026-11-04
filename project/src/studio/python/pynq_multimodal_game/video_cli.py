from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path
from typing import Sequence

from .video_codec import (
    S2V1_GOP_SIZE,
    S2V1_QUALITY_PROFILES,
    S2V1_RESIZE_FILTERS,
    S2V1Reader,
    decode_video_frames,
    encode_rgb_frames,
)


def create_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="voice-view-video")
    subparsers = parser.add_subparsers(dest="command", required=True)

    probe = subparsers.add_parser("probe", help="inspect an input video stream")
    probe.add_argument("input", type=Path)

    encode = subparsers.add_parser("encode", help="encode an input video as S2V1")
    encode.add_argument("input", type=Path)
    encode.add_argument("output", type=Path)
    encode.add_argument("--gop-size", type=int, default=S2V1_GOP_SIZE)
    encode.add_argument("--max-frames", type=int)
    encode.add_argument("--resize-filter", choices=S2V1_RESIZE_FILTERS, default="legacy")
    encode.add_argument(
        "--quality-profile",
        choices=S2V1_QUALITY_PROFILES,
        default="legacy",
    )

    inspect = subparsers.add_parser("inspect", help="inspect an S2V1 container")
    inspect.add_argument("input", type=Path)

    verify = subparsers.add_parser("verify", help="fully validate and decode S2V1")
    verify.add_argument("input", type=Path)
    return parser


def _probe(path: Path) -> dict[str, object]:
    try:
        import av
    except ModuleNotFoundError as error:
        raise RuntimeError("probe requires the project video extra") from error
    with av.open(str(path)) as container:
        if not container.streams.video:
            raise ValueError("input contains no video stream")
        stream = container.streams.video[0]
        rate = stream.average_rate
        return {
            "path": str(path),
            "codec": stream.codec_context.name,
            "width": stream.width,
            "height": stream.height,
            "frames": stream.frames,
            "average_rate": None if rate is None else [rate.numerator, rate.denominator],
            "time_base": [stream.time_base.numerator, stream.time_base.denominator],
        }


def _inspect(path: Path) -> dict[str, object]:
    with S2V1Reader(path) as reader:
        video = reader.manifest["video"]
        gops = reader.manifest["gops"]
        assert isinstance(video, dict)
        assert isinstance(gops, list)
        return {
            "path": str(path),
            "bytes": path.stat().st_size,
            "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            "frames": reader.frame_count,
            "gops": len(gops),
            "fps": video["fps"],
            "duration": video["duration"],
        }


def main(arguments: Sequence[str] | None = None) -> int:
    parser = create_parser()
    args = parser.parse_args(arguments)
    try:
        if args.command == "probe":
            summary = _probe(args.input)
            marker = "S2V1_PROBE_SUMMARY"
        elif args.command == "encode":
            if args.max_frames is not None and args.max_frames <= 0:
                parser.error("--max-frames must be positive")
            result = encode_rgb_frames(
                decode_video_frames(
                    args.input, max_frames=args.max_frames, resize_filter=args.resize_filter,
                ),
                args.output,
                gop_size=args.gop_size,
                quality_profile=args.quality_profile,
            )
            summary = {
                "path": str(result.path),
                "frames": result.frame_count,
                "gops": result.gop_count,
                "bytes": result.total_bytes,
                "sha256": result.sha256,
                "average_bitrate_bps": result.average_bitrate_bps,
                "quality_profile": args.quality_profile,
                "resize_filter": args.resize_filter,
            }
            marker = "S2V1_ENCODE_SUMMARY"
        elif args.command == "inspect":
            summary = _inspect(args.input)
            marker = "S2V1_INSPECT_SUMMARY"
        else:
            digest = hashlib.sha256()
            with S2V1Reader(args.input) as reader:
                frames = 0
                for frame in reader.iter_frames():
                    digest.update(frame.rgb)
                    frames += 1
            summary = {
                "path": str(args.input),
                "frames": frames,
                "decoded_rgb_sha256": digest.hexdigest(),
            }
            marker = "S2V1_VERIFY_SUMMARY"
        print(f"{marker}={json.dumps(summary, sort_keys=True)}")
        print("S2V1_STATUS=PASS")
        return 0
    except Exception as error:
        print(f"S2V1_STATUS=FAIL error={type(error).__name__}: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())