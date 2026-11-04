"""Prepare bounded content fixtures and verify Studio/accepted-board game parity.

Run: .venv/Scripts/python.exe -B tools/studio_r44_prepare.py
Outputs: build/studio-r44/{videos,parity.json,game*.vvg}.
Next: load these four videos and the three projects through Studio's loader.
"""
from pathlib import Path
import json
import os
import sys
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))
os.environ["TEMP"] = str(ROOT / "build")
os.environ["TMP"] = str(ROOT / "build")
from pynq_multimodal_game.game_validation import build_verified_game
import av
import numpy as np

output = ROOT / "build/studio-r44"
output.mkdir(exist_ok=True)
videos = output / "videos"
videos.mkdir(exist_ok=True)
report = {"games": [], "videos": []}
for name in ("game1", "game2", "game3"):
    info = build_verified_game(ROOT / "games_gesture" / name, output / f"{name}.vvg", target_build_id=0xC0061000)
    with ZipFile(info.path) as studio, ZipFile(ROOT / "build/ps-ui-r43-creative-board-candidate-r31/seed_games" / f"{name}.vvg") as board:
        names = lambda z: {n for n in z.namelist() if n != "package.json" and not n.startswith("tests/")}
        assert names(studio) == names(board), name
        different = [n for n in names(studio) if studio.read(n) != board.read(n)]
        assert not different, (name, different)
        report["games"].append(dict(id=name, source_files=len(names(studio)), matches_r43_r31=True, sha256=info.sha256))

digits = ("010110010010111", "111001111100111", "111001111001111", "101101111001001")
for index, (name, color) in enumerate((("Red", (220, 55, 65)), ("Blue", (45, 100, 230)),
                                      ("Green", (40, 190, 100)), ("Gold", (220, 165, 35))), 1):
    path = videos / f"Clip-{index}-{name}.mp4"
    seconds = index + 2
    with av.open(str(path), "w") as container:
        stream = container.add_stream("mpeg4", rate=30)
        stream.width, stream.height, stream.pix_fmt = 320, 180, "yuv420p"
        for tick in range(seconds * 30):
            pixels = np.empty((180, 320, 3), dtype=np.uint8)
            pixels[:] = color
            for cell, enabled in enumerate(digits[index - 1]):
                if enabled == "1":
                    x, y = 130 + cell % 3 * 20, 30 + cell // 3 * 20
                    pixels[y:y+18, x:x+18] = (255, 255, 255)
            pixels[155:165, :int(320 * (tick+1)/(seconds*30))] = (20, 25, 30)
            frame = av.VideoFrame.from_ndarray(pixels, format="rgb24")
            for packet in stream.encode(frame): container.mux(packet)
        for packet in stream.encode(): container.mux(packet)
    report["videos"].append(dict(path=str(path), seconds=seconds, frames=seconds*30))
(output / "parity.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
print(json.dumps(report), flush=True)
