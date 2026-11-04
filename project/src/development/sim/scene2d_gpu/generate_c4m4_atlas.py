from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "python"))

from pynq_multimodal_game.gpu_abi import pack_index4
from pynq_multimodal_game.scene import IndexedImage


pixels = bytearray(256 * 256)
pixels[0:3] = bytes((1, 0, 2))
pixels[256:259] = bytes((3, 4, 0))
packed = pack_index4(IndexedImage(256, 256, bytes(pixels)))
output = Path(__file__).parent / "vectors" / "c4m4_atlas.mem"
output.write_text("".join(f"{value:02x}\n" for value in packed), encoding="ascii")
print(f"C4M4_ATLAS={output} bytes={len(packed)}")