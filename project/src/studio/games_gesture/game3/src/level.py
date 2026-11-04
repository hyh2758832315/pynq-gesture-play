from dataclasses import dataclass


SCALE = 64
WORLD_WIDTH = 2560


@dataclass(frozen=True)
class Block:
    x: int
    y: int
    width: int
    height: int
    kind: str = "ground"


def level_blocks():
    return (
        Block(0, 144, 400, 48), Block(432, 144, 624, 48),
        Block(1056, 48, 480, 144),
        Block(1536, 144, 352, 48), Block(1920, 144, 640, 48),
        Block(1648, 112, 64, 16, "platform"),
        Block(1760, 80, 64, 16, "platform"),
        Block(2080, 112, 64, 16, "platform"),
        Block(2240, 96, 64, 16, "reward"),
        Block(128, 96, 16, 16, "brick"),
        Block(144, 96, 16, 16, "reward"),
        Block(160, 96, 16, 16, "brick"),
        Block(560, 112, 64, 16, "platform"),
        Block(816, 48, 16, 96, "gate"),
    )


COINS = ((240, 124), (392, 92), (416, 92), (580, 92), (608, 92), (1136, 28), (1200, 28), (1264, 28))
COINS += ((1580,124),(1672,92),(1784,60),(1896,92),(2104,92),(2264,76),(2384,124))
NOTE_X = 736
PITS = ((400, 432), (1888, 1920))
LIFT_X = 992
GOAL_X = 2480
GOAL_GROUND_Y = next(block.y for block in level_blocks()
                     if block.kind == 'ground' and block.x <= GOAL_X < block.x + block.width)
