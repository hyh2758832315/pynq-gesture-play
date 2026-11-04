from dataclasses import dataclass


SCALE = 64
WORLD_WIDTH = 1536


@dataclass(frozen=True)
class Block:
    x: int
    y: int
    width: int
    height: int
    kind: str = "ground"


def level_blocks():
    return (
        Block(0, 144, 384, 48), Block(448, 144, 608, 48),
        Block(1056, 48, 480, 144),
        Block(128, 96, 16, 16, "brick"),
        Block(144, 96, 16, 16, "reward"),
        Block(160, 96, 16, 16, "brick"),
        Block(560, 112, 64, 16, "platform"),
        Block(816, 48, 16, 96, "gate"),
    )


COINS = ((240, 124), (392, 92), (416, 92), (580, 92), (608, 92), (1136, 28), (1200, 28), (1264, 28))
NOTE_X = 736
LIFT_X = 992
GOAL_X = 1456