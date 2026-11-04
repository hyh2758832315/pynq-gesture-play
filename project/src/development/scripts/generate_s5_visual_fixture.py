from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np

from pynq_multimodal_game.video_codec import (
    S2V1_HEIGHT,
    S2V1_WIDTH,
    encode_rgb_frames,
)


FRAME_COUNT = 60
MARKER_SIZE = 16


def visual_frames(frame_count: int = FRAME_COUNT) -> list[np.ndarray]:
    if frame_count <= 0:
        raise ValueError("frame_count must be positive")

    frames: list[np.ndarray] = []
    for frame_index in range(frame_count):
        frame = np.zeros((S2V1_HEIGHT, S2V1_WIDTH, 3), dtype=np.uint8)
        frame[:60] = (28, 54, 92)
        frame[60:120] = (30, 100, 82)
        frame[120:] = (116, 54, 32)
        frame[::16] = (12, 12, 12)
        frame[:, ::16] = (12, 12, 12)

        marker_x = (frame_index * 16) % (S2V1_WIDTH - MARKER_SIZE)
        marker_y = 80
        frame[marker_y : marker_y + MARKER_SIZE, marker_x : marker_x + MARKER_SIZE] = (
            248,
            232,
            64,
        )
        frames.append(frame)
    return frames


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate a stable visual-acceptance S2V1 fixture"
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("results/s5/s5_visual_60f.s2v"),
    )
    args = parser.parse_args()
    result = encode_rgb_frames(visual_frames(), args.output)
    print(
        "S2V1_VISUAL_FIXTURE="
        f"path={result.path} frames={result.frame_count} gops={result.gop_count} "
        f"bytes={result.total_bytes} sha256={result.sha256}"
    )


if __name__ == "__main__":
    main()