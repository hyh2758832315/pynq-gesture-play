from pynq_multimodal_game.game_sdk import GameAssets
from pynq_multimodal_game.scene import IndexedImage, PalettePack


FONT = {
    "A": ("010", "101", "111", "101", "101"), "B": ("110", "101", "110", "101", "110"),
    "C": ("011", "100", "100", "100", "011"), "D": ("110", "101", "101", "101", "110"),
    "E": ("111", "100", "110", "100", "111"), "F": ("111", "100", "110", "100", "100"),
    "G": ("011", "100", "101", "101", "011"), "H": ("101", "101", "111", "101", "101"),
    "I": ("111", "010", "010", "010", "111"), "J": ("001", "001", "001", "101", "010"),
    "K": ("101", "101", "110", "101", "101"), "L": ("100", "100", "100", "100", "111"),
    "M": ("101", "111", "111", "101", "101"), "N": ("101", "111", "111", "111", "101"),
    "O": ("010", "101", "101", "101", "010"), "P": ("110", "101", "110", "100", "100"),
    "Q": ("010", "101", "101", "011", "001"), "R": ("110", "101", "110", "101", "101"),
    "S": ("011", "100", "010", "001", "110"), "T": ("111", "010", "010", "010", "010"),
    "U": ("101", "101", "101", "101", "111"), "V": ("101", "101", "101", "101", "010"),
    "W": ("101", "101", "111", "111", "101"), "X": ("101", "101", "010", "101", "101"),
    "Y": ("101", "101", "010", "010", "010"), "Z": ("111", "001", "010", "100", "111"),
    "0": ("111", "101", "101", "101", "111"), "1": ("010", "110", "010", "010", "111"),
    "2": ("110", "001", "010", "100", "111"), "3": ("110", "001", "010", "001", "110"),
    ":": ("000", "010", "000", "010", "000"), " ": ("000",) * 5,
}


def _rect(pixels, stride, x, y, width, height, color) -> None:
    for row in range(y, y + height):
        pixels[row * stride + x:row * stride + x + width] = bytes([color]) * width


def _hand(pose: int, robot: bool) -> bytes:
    pixels = bytearray(80 * 72)
    shapes = [(4, 34, 26, 20), (27, 25, 26, 33)]
    if pose in (0, 1):
        shapes += [(40, 19, 14, 10), (48, 25, 12, 32), (32, 24, 10, 23)]
    elif pose == 2:
        shapes += [(49, 23, 15, 8), (61, 18, 13, 8), (48, 41, 16, 8), (62, 46, 12, 8), (30, 19, 11, 24)]
    else:
        shapes += [(29, 14, 10, 19), (34, 8, 10, 13), (49, 25, 23, 6), (49, 34, 27, 6), (49, 43, 25, 6), (49, 52, 18, 6)]
    for x, y, width, height in shapes:
        _rect(pixels, 80, x, y, width, height, 2)
        _rect(pixels, 80, x, y + height - 2, width, 2, 3)
    silhouette = bytes(pixels)
    for y in range(1, 71):
        for x in range(1, 79):
            offset = y * 80 + x
            if silhouette[offset] == 0 and any(silhouette[offset + delta] for delta in (-81, -80, -79, -1, 1, 79, 80, 81)):
                pixels[offset] = 1
    if pose == 0:
        return bytes(1 if value == 1 else 0 for value in pixels)
    _rect(pixels, 80, 7, 35, 16, 3, 4)
    _rect(pixels, 80, 29, 28, 4, 22, 4)
    if robot:
        _rect(pixels, 80, 35, 31, 12, 18, 1)
        _rect(pixels, 80, 37, 33, 8, 14, 4)
        _rect(pixels, 80, 39, 36, 4, 7, 5)
        for x, y, width, height in shapes[2:]:
            if width > 12:
                _rect(pixels, 80, x + 7, y + 1, 2, max(1, height - 2), 1)
        for x, y in ((29, 27), (48, 28), (29, 53), (48, 53)):
            _rect(pixels, 80, x, y, 2, 2, 5)
    else:
        _rect(pixels, 80, 36, 47, 12, 2, 3)
        _rect(pixels, 80, 43, 43, 2, 4, 3)
        if pose == 1:
            for y in (29, 37, 45):
                _rect(pixels, 80, 50, y, 7, 1, 1)
    return bytes(pixels)


def create_assets():
    pixels = bytearray(320 * 200)
    for robot in (False, True):
        for pose in range(4):
            image = _hand(pose, robot)
            for row in range(72):
                offset = (row + 72 * robot) * 320 + pose * 80
                pixels[offset:offset + 80] = image[row * 80:(row + 1) * 80]
    labels = {}
    x, y = 0, 144
    texts = ("ROCK PAPER SCISSORS", "HUMAN", "ROBOT", "READY", "LOCKED", "NEXT ROUND", "YOU WIN", "YOU LOSE", "DRAW", "ROCK", "PAPER", "SCISSORS", "ROUND 1", "ROUND 2", "ROUND 3", "0 : 0", "0 : 1", "0 : 2", "0 : 3", "1 : 0", "1 : 1", "1 : 2", "2 : 0", "2 : 1", "3 : 0")
    for text in texts:
        scale = 2
        width, height = (len(text) * 4 - 1) * scale, 5 * scale
        if x + width > (248 if y < 174 else 320):
            x, y = 0, y + 10
        for char_index, character in enumerate(text):
            for row, line in enumerate(FONT[character]):
                for column, bit in enumerate(line):
                    if bit == "1":
                        _rect(pixels, 320, x + (char_index * 4 + column) * scale, y + row * scale, scale, scale, 1)
        labels[text] = (x, y, width, height)
        x += width + 4
    for digit in ("1", "2", "3"):
        x = 248 + (int(digit) - 1) * 24
        for row, line in enumerate(FONT[digit]):
            for column, bit in enumerate(line):
                if bit == "1":
                    _rect(pixels, 320, x + column * 6, 144 + row * 6, 6, 6, 1)
        labels["count_" + digit] = (x, 144, 18, 30)
    _rect(pixels, 320, 100, 197, 30, 3, 1)
    labels["bar"] = (100, 197, 30, 3)
    palettes = PalettePack((
        ((0, 0, 0), (69, 49, 53), (242, 193, 179), (207, 139, 133), (255, 226, 213), (228, 147, 151)) + ((0, 0, 0),) * 10,
        ((0, 0, 0), (46, 62, 65), (171, 187, 184), (111, 138, 137), (225, 236, 227), (38, 175, 184)) + ((0, 0, 0),) * 10,
        ((0, 0, 0), (47, 65, 62), (217, 228, 215), (229, 237, 225), (187, 211, 198), (26, 132, 125)) + ((0, 0, 0),) * 10,
        ((0, 0, 0), (140, 159, 148), (191, 205, 193), (176, 195, 184), (203, 217, 206), (162, 187, 176)) + ((0, 0, 0),) * 10,
        ((0, 0, 0), (36, 133, 115)) + ((0, 0, 0),) * 14,
        ((0, 0, 0), (191, 76, 94)) + ((0, 0, 0),) * 14,
    ))
    tiles = bytearray(16 * 16 * 2)
    for row in range(16):
        for column in range(32):
            tiles[row * 32 + column] = 2 if column < 16 else 3
    return GameAssets(IndexedImage(320, 200, bytes(pixels)), IndexedImage(32, 16, bytes(tiles)), palettes), labels