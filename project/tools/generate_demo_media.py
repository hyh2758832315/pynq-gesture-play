"""Generate original default videos without downloading third-party media.

Run: python -B tools/generate_demo_media.py (Studio video dependencies required).
Outputs: src/studio/media/default_videos/test_pattern_{1,2}.mp4 and
board/runtime/seed_videos/default-{1,2}.s2v plus catalog.json.
Next: validate containers, update deployment hashes, then install with Studio.
"""
from pathlib import Path
import hashlib
import json
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'src/studio/python'))
import av
import numpy as np
from pynq_multimodal_game.video_codec import encode_rgb_frames, S2V1Reader


def frames(mode):
    for n in range(90):
        image = np.full((180, 320, 3), (20, 24, 32), dtype=np.uint8)
        colors = [(235, 77, 134), (35, 150, 210), (240, 200, 70), (60, 190, 140)]
        for k, color in enumerate(colors):
            image[120:160, k * 80:(k + 1) * 80] = color
        x = (n * (2 + mode)) % 280
        image[25:65, x:x + 40] = colors[mode - 1]
        image[90:96, :int(320 * (n + 1) / 90)] = (230, 230, 230)
        yield image


def main():
    media = ROOT / 'src/studio/media/default_videos'
    seed = ROOT / 'board/runtime/seed_videos'
    media.mkdir(parents=True, exist_ok=True)
    seed.mkdir(parents=True, exist_ok=True)
    catalog = []
    for mode in (1, 2):
        path = media / f'test_pattern_{mode}.mp4'
        with av.open(str(path), 'w') as container:
            stream = container.add_stream('mpeg4', rate=30)
            stream.width, stream.height, stream.pix_fmt = 320, 180, 'yuv420p'
            for rgb in frames(mode):
                for packet in stream.encode(av.VideoFrame.from_ndarray(rgb, format='rgb24')):
                    container.mux(packet)
            for packet in stream.encode():
                container.mux(packet)
        output = seed / f'default-{mode}.s2v'
        result = encode_rgb_frames(frames(mode), output, quality_profile='spatial-shared')
        with S2V1Reader(output) as reader:
            assert reader.frame_count == 90
        catalog.append(dict(item_id=f'test-pattern-{mode}-{result.sha256[:8]}',
                            display_name=f'VIDEO {mode} TEST PATTERN',
                            path=f'seed_videos/default-{mode}.s2v', sha256=result.sha256))
    (seed / 'catalog.json').write_text(json.dumps({'schema': 1, 'videos': catalog}, indent=2)+'\n', encoding='utf-8')
    (media / 'provenance.json').write_text(json.dumps({'source': 'tools/generate_demo_media.py',
        'kind': 'original_procedural_animation', 'fps': 30, 'frames_per_video': 90,
        'files': {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(media.glob('test_pattern_*.mp4'))}}, indent=2)+'\n', encoding='utf-8')
    print(json.dumps({'result': 'PASS', 'videos': len(catalog), 'hardware_access': False}))


if __name__ == '__main__':
    main()
