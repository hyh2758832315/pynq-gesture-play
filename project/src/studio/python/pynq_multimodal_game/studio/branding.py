"""Native rendering of the existing HDMI AMD/PYNQ wordmark mask."""
import json
from importlib.resources import files

from PySide6.QtGui import QColor, QIcon, QImage, QPixmap

from .theme import ACCENT, TEXT


def pynq_wordmark() -> QPixmap:
    mask = json.loads(files(__package__).joinpath("assets/pynq_wordmark.json").read_text(encoding="utf-8"))
    width, height = mask["width"], mask["height"]
    pixels = bytes.fromhex(mask["indices_hex"])
    if len(pixels) != width * height or max(pixels) > 15:
        raise ValueError("Invalid PYNQ wordmark mask")
    image = QImage(width, height, QImage.Format.Format_Indexed8)
    palette = [QColor("transparent").rgba()] * 16
    for index, color in ((7, ACCENT), (9, TEXT), (11, "#f5c7da"), (12, "#bd91a5")):
        palette[index] = QColor(color).rgba()
    image.setColorTable(palette)
    for y in range(height):
        for x in range(width):
            image.setPixel(x, y, pixels[y * width + x])
    return QPixmap.fromImage(image)


def studio_icon() -> QIcon:
    # The compact PYNQ letterform remains recognizable in the taskbar.
    return QIcon(pynq_wordmark())
