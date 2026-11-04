"""Build the original six-second SUNSET loop on the PC (never on the board).

Run: .venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/tools/build_default_video.py
Outputs: subprojects/ps_ui_r23b2/seed_videos/default-sunset.s2v
Next: build_deployment_candidate.py bundles it; normal startup installs it once.
Optional --preview PATH writes an MP4 reference using the PC's video extra.
"""
from __future__ import annotations

import argparse
import json
import math
from pathlib import Path
import sys

import numpy as np

SOURCE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SOURCE / "python"))
from pynq_multimodal_game.video_codec import encode_rgb_frames

FRAME_COUNT = 180
COLORS = np.array([
    (28, 36, 68), (60, 52, 92), (108, 68, 108), (180, 100, 116),
    (236, 156, 124), (252, 212, 148), (252, 236, 180), (44, 76, 100),
    (28, 52, 76), (60, 108, 124), (20, 36, 52), (108, 148, 148),
], dtype=np.uint8)
Y, X = np.indices((180, 320))


def frame_at(index: int) -> np.ndarray:
    """Few flat colors, fixed composition and periodic motion avoid tile noise."""
    phase = 2 * math.pi * (index % FRAME_COUNT) / FRAME_COUNT
    canvas = np.zeros((180, 320), dtype=np.uint8)
    for start, color in ((22, 1), (43, 2), (64, 3), (82, 4), (102, 7), (130, 8)):
        canvas[start:] = color
    canvas[(X - 205) ** 2 + (Y - 84) ** 2 <= 22 ** 2] = 5
    canvas[(X - 205) ** 2 + (Y - 84) ** 2 <= 17 ** 2] = 6
    # Low clouds drift gently and return to their original positions at the loop.
    for cx, cy, width in ((64, 52, 38), (132, 34, 24), (264, 61, 30)):
        cx += round(3 * math.sin(phase))
        canvas[cy:cy + 2, cx:cx + width] = 3
        canvas[cy - 2:cy, cx + 8:cx + width - 4] = 2
    # Two quiet headlands, followed by an uninterrupted sea horizon.
    left = 101 - np.maximum(0, 1 - abs(X - 34) / 92) * 28
    right = 102 - np.maximum(0, 1 - abs(X - 296) / 65) * 20
    canvas[(Y >= np.minimum(left, right)) & (Y < 104)] = 1
    canvas[104:130] = 7
    canvas[130:] = 8
    # The reflection and wavelets use cyclic offsets, with no full-frame flashes.
    for row in range(108, 172, 6):
        cx = 205 + round(4 * math.sin(phase + row * .15))
        half = 10 + (row - 108) // 3
        canvas[row:row + 2, cx - half:cx + half] = 4 if row < 140 else 9
    for row, col, width in ((117, 32, 23), (129, 84, 16), (147, 20, 38),
                            (157, 105, 28), (137, 274, 30), (173, 249, 42)):
        col += round(5 * math.sin(phase + row * .1))
        canvas[row:row + 1, col:col + width] = 9
    # A small sailboat rocks on the water; all motion is smooth and loopable.
    bx = 105 + round(18 * math.sin(phase))
    by = 132 + round(2 * math.sin(phase * 2))
    canvas[by - 35:by, bx:bx + 1] = 10
    for dy in range(28):
        width = dy * 18 // 28
        canvas[by - 33 + dy, bx - width:bx] = 6
        if dy > 5:
            canvas[by - 29 + dy, bx + 2:bx + 3 + dy * 12 // 28] = 4
    for dy in range(5):
        canvas[by + dy:by + dy + 1, bx - 22 + dy:bx + 19 - dy] = 10
    canvas[by + 7:by + 8, bx - 17:bx + 16] = 9
    canvas[(Y >= 168 + X // 10) & (X < 93)] = 10
    canvas[(Y >= 170 + (319 - X) // 14) & (X > 240)] = 10
    return COLORS[canvas]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=SOURCE / "seed_videos/default-sunset.s2v")
    parser.add_argument("--preview", type=Path)
    args = parser.parse_args()
    # A single palette for the whole loop also keeps the loop boundary stable.
    result = encode_rgb_frames((frame_at(i) for i in range(FRAME_COUNT)), args.output,
                               gop_size=FRAME_COUNT, quality_profile="stable")
    if args.preview:
        import av
        args.preview.parent.mkdir(parents=True, exist_ok=True)
        with av.open(str(args.preview), "w") as output:
            stream = output.add_stream("libx264", rate=30)
            stream.width, stream.height, stream.pix_fmt = 320, 180, "yuv420p"
            for i in range(FRAME_COUNT):
                frame = av.VideoFrame.from_ndarray(frame_at(i), format="rgb24")
                for packet in stream.encode(frame):
                    output.mux(packet)
            for packet in stream.encode():
                output.mux(packet)
    print(json.dumps(dict(path=str(result.path), frames=result.frame_count,
                         seconds=6, bytes=result.total_bytes, sha256=result.sha256)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
