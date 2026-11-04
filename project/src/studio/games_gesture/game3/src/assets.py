from pynq_multimodal_game.game_sdk import GameAssets
from pynq_multimodal_game.scene import IndexedImage, PalettePack


FONT = {
    "A": ("010", "101", "111", "101", "101"), "C": ("011", "100", "100", "100", "011"),
    "E": ("111", "100", "110", "100", "111"), "F": ("111", "100", "110", "100", "100"),
    "G": ("011", "100", "101", "101", "011"), "H": ("101", "101", "111", "101", "101"),
    "L": ("100", "100", "100", "100", "111"), "M": ("101", "111", "111", "101", "101"),
    "O": ("010", "101", "101", "101", "010"), "R": ("110", "101", "110", "101", "101"),
    "S": ("011", "100", "010", "001", "110"), "U": ("101", "101", "101", "101", "111"),
    "V": ("101", "101", "101", "101", "010"), " ": ("000",) * 5,
    "0": ("111", "101", "101", "101", "111"), "1": ("010", "110", "010", "010", "111"),
    "2": ("110", "001", "010", "100", "111"), "3": ("110", "001", "010", "001", "110"),
    "4": ("101", "101", "111", "001", "001"), "5": ("111", "100", "110", "001", "110"),
    "6": ("011", "100", "111", "101", "111"), "7": ("111", "001", "010", "010", "010"),
    "8": ("111", "101", "111", "101", "111"), "9": ("111", "101", "111", "001", "110"),
}


def rect(pixels, stride, x, y, width, height, color):
    for row in range(y, y + height):
        pixels[row * stride + x:row * stride + x + width] = bytes([color]) * width


def hero(female: bool, pose: int) -> bytes:
    pixels = bytearray(24 * 32)

    def fill(x, y, width, height, color):
        rect(pixels, 24, x, y, width, height, color)

    stride = 2 if pose == 1 else -2 if pose == 2 else 0
    if female:
        fill(7, 10, 11, 15, 4)
        fill(5, 17, 4, 9, 4)
        fill(17, 17, 3, 9, 5)
        fill(8, 8, 10, 3, 4)
        for column in (8, 12, 17):
            fill(column, 7, 1, 2, 4)
        fill(12, 9, 2, 2, 7)
        fill(9, 12, 8, 7, 2)
        fill(8, 11, 8, 2, 5)
        fill(16, 14, 1, 2, 1)
        fill(15, 17, 2, 1, 6)
        fill(9, 19, 8, 4, 6)
        fill(7, 23, 12, 3, 6)
        fill(6, 26, 14, 2, 3)
        fill(7, 19, 3, 3, 3)
        fill(16, 19, 3, 3, 3)
        fill(6, 22 - (2 if pose == 3 else 0), 2, 3, 2)
        fill(18, 22 - (4 if pose == 3 else 0), 2, 3, 2)
        fill(12, 20, 2, 2, 7)
        fill(8 + stride, 28, 4, 2, 1)
        fill(15 - stride, 28 - int(pose == 3), 4, 2, 1)
    else:
        fill(7, 10, 11, 3, 6)
        fill(6, 12, 14, 2, 6)
        fill(8, 14, 9, 6, 2)
        fill(8, 14, 3, 3, 5)
        fill(16, 15, 1, 2, 1)
        fill(9, 19, 8, 5, 7)
        fill(6, 19, 3, 5, 6)
        fill(16, 20, 3, 3, 7)
        fill(18, 22 - (4 if pose == 3 else 0), 2, 3, 2)
        fill(9, 24, 8, 3, 3)
        fill(8 + stride, 27, 4, 3, 1)
        fill(15 - stride, 27 - int(pose == 3), 4, 3, 1)
    silhouette = bytes(pixels)
    for row in range(1, 31):
        for column in range(1, 23):
            offset = row * 24 + column
            if not silhouette[offset] and any(silhouette[offset + delta] for delta in (-24, -1, 1, 24)):
                pixels[offset] = 1
    return bytes(pixels)


def create_assets():
    pixels = bytearray(128 * 256)
    regions = {}

    def fill(x, y, width, height, color):
        rect(pixels, 128, x, y, width, height, color)

    for female in (False, True):
        for pose in range(4):
            image = hero(female, pose)
            for row in range(32):
                start = (row + 32 * female) * 128 + 24 * pose
                pixels[start:start + 24] = image[row * 24:(row + 1) * 24]
            if pose == 0:
                for row in range(32):
                    for column in range(24):
                        fill(48 * female + column * 2, 64 + row * 2, 2, 2, image[row * 24 + column])
    for index, text in enumerate(("CHOOSE HERO", "LEO", "ROSE", "MALE", "FEMALE", "LEVEL CLEAR", "GAME OVER")):
        width, atlas_y = (len(text) * 4 - 1) * 2, 132 + index * 12
        for char_index, character in enumerate(text):
            for row, bits in enumerate(FONT[character]):
                for column, bit in enumerate(bits):
                    if bit == "1":
                        fill((char_index * 4 + column) * 2, atlas_y + row * 2, 2, 2, 1)
        regions[text] = (0, atlas_y, width, 10)
    for digit in range(10):
        for row, bits in enumerate(FONT[str(digit)]):
            for column, bit in enumerate(bits):
                if bit == "1":
                    fill(8 * digit + column * 2, 220 + row * 2, 2, 2, 1)
        regions[str(digit)] = (8 * digit, 220, 6, 10)
    fill(98, 67, 28, 6, 1)
    fill(99, 68, 26, 2, 7)
    for column in range(99, 125, 4):
        fill(column, 71, 2, 1, 4)
    regions["lift"] = (98, 66, 28, 8)
    fill(98, 78, 30, 3, 1)
    regions["meter"] = (98, 78, 30, 3)
    fill(100, 86, 24, 3, 1)
    fill(100, 86, 3, 22, 1)
    fill(121, 86, 3, 22, 1)
    fill(100, 105, 24, 3, 1)
    regions["selection"] = (100, 86, 24, 22)
    for health in range(4):
        for heart_index in range(health):
            fill(heart_index * 10, 234 + health * 5, 7, 3, 1)
            fill(heart_index * 10 + 1, 237 + health * 5, 5, 1, 1)
        regions["health" + str(health)] = (0, 234 + health * 5, 30, 4)
    fill(99, 2, 10, 10, 1)
    fill(100, 3, 8, 8, 4)
    fill(102, 4, 2, 6, 3)
    regions["coin"] = (98, 0, 12, 16)
    fill(112, 8, 16, 8, 1)
    fill(114, 5, 12, 5, 4)
    fill(115, 4, 10, 2, 7)
    regions["note"] = (112, 0, 16, 16)
    fill(98, 22, 13, 9, 6)
    fill(99, 19, 11, 5, 6)
    fill(100, 23, 3, 4, 3)
    fill(106, 23, 3, 4, 3)
    fill(101, 24, 1, 2, 1)
    fill(107, 24, 1, 2, 1)
    fill(98, 30, 4, 2, 1)
    fill(108, 30, 4, 2, 1)
    regions["enemy"] = (96, 16, 16, 16)
    fill(114, 18, 2, 46, 1)
    fill(116, 19, 11, 10, 6)
    fill(116, 19, 11, 2, 3)
    fill(111, 62, 7, 2, 4)
    regions["goal"] = (112, 16, 16, 48)
    tiles = bytearray(128 * 32)

    def tile_fill(tile_id, x, y, width, height, color):
        rect(tiles, 128, (tile_id % 8) * 16 + x, (tile_id // 8) * 16 + y, width, height, color)

    for tile_id in range(1, 9):
        tile_fill(tile_id, 0, 0, 16, 16, 8 if tile_id in (1, 2, 8) else 10)
        for row in (2, 10):
            tile_fill(tile_id, 0, row, 16, 1, 9)
            tile_fill(tile_id, 4 if row == 2 else 12, row, 1, 8 if row == 2 else 6, 9)
        if tile_id in (2, 8):
            tile_fill(tile_id, 0, 0, 16, 3, 7)
            tile_fill(tile_id, 1, 3, 14, 1, 11)
        elif tile_id == 4:
            tile_fill(tile_id, 1, 1, 14, 14, 4)
            tile_fill(tile_id, 7, 3, 3, 6, 1)
            tile_fill(tile_id, 5, 4, 4, 2, 1)
            tile_fill(tile_id, 7, 11, 2, 2, 1)
        elif tile_id == 5:
            tile_fill(tile_id, 2, 2, 12, 12, 9)
        elif tile_id == 6:
            tile_fill(tile_id, 0, 0, 16, 3, 7)
            tile_fill(tile_id, 0, 3, 16, 2, 3)
        elif tile_id == 7:
            tile_fill(tile_id, 0, 0, 16, 16, 12)
            for column in (2, 7, 12):
                tile_fill(tile_id, column, 0, 2, 16, 3)
    tile_fill(9, 0, 6, 16, 7, 3)
    tile_fill(9, 3, 3, 10, 10, 3)
    tile_fill(9, 1, 12, 14, 2, 13)
    banks = (
        ((0, 0, 0), (39, 45, 47), (248, 202, 161), (155, 72, 63), (247, 203, 76), (107, 63, 50), (226, 94, 55), (31, 139, 126)),
        ((0, 0, 0), (66, 44, 62), (255, 215, 183), (255, 241, 238), (255, 209, 83), (222, 160, 50), (231, 83, 143), (47, 166, 182)),
        ((0, 0, 0), (44, 67, 73), (248, 202, 161), (250, 251, 244), (252, 207, 69), (222, 160, 50), (205, 93, 107), (42, 156, 118), (153, 177, 180), (109, 140, 152), (225, 158, 133), (81, 194, 122), (53, 141, 156), (208, 234, 235)),
        ((0, 0, 0), (43, 67, 74)),
        ((0, 0, 0), (213, 68, 104)),
    )
    palettes = PalettePack(tuple(bank + ((0, 0, 0),) * (16 - len(bank)) for bank in banks))
    return GameAssets(IndexedImage(128, 256, bytes(pixels)), IndexedImage(128, 32, bytes(tiles)), palettes), regions