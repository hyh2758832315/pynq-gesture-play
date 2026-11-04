from pynq_multimodal_game.game_sdk import HandGesture
from pynq_multimodal_game.scene import Scene, SpriteDescriptor, TileDescriptor, TileLayer


POSES = {None: 0, HandGesture.FIST: 1, HandGesture.SCISSORS: 2, HandGesture.PAPER: 3}
ARENA = TileLayer(20, 2, tuple(TileDescriptor((column // 5 + row) % 2, 2) for row in range(2) for column in range(20)), origin_y=148)


def build_scene(match, labels) -> Scene:
    sprites = []

    def text(label, x, y, palette=2):
        atlas_x, atlas_y, width, height = labels[label]
        sprites.append(SpriteDescriptor(x, y, width, height, atlas_x, atlas_y, palette, 5))

    def centered(label, y, palette=2):
        text(label, (320 - labels[label][2]) // 2, y, palette)

    def hand(pose, robot, *, offset=0, ghost=False):
        sprites.append(SpriteDescriptor((206 if robot else 34) + offset, 66, 80, 72, pose * 80, 72 if robot else 0, 3 if ghost or pose == 0 else int(robot), 1 if ghost else 2, flip_x=robot))

    centered("ROCK PAPER SCISSORS", 8)
    centered(f"{match.human_wins} : {match.robot_wins}", 28)
    text("HUMAN", 54, 43)
    text("ROBOT", 224, 43)
    if match.phase == "COUNTDOWN":
        cycle = (match.tick_id - match.phase_start) // max(1, match.tick_hz // 20)
        for robot in (False, True):
            hand((cycle + 1 + robot) % 3 + 1, robot, offset=-2, ghost=True)
            hand((cycle + 2 + robot) % 3 + 1, robot, offset=2, ghost=True)
            hand((cycle + robot) % 3 + 1, robot, offset=1 if cycle % 2 else -1)
        digit = min(3, max(1, (match.countdown_remaining + match.tick_hz - 1) // match.tick_hz))
        centered("count_" + str(digit), 85)
    else:
        locked = match.phase in ("REVEAL", "DONE")
        hand(POSES[match.human_locked if locked else match.human_live], False)
        hand(POSES[match.robot_locked] if locked else 0, True)
        if locked:
            centered({"WIN": "YOU WIN", "LOSE": "YOU LOSE", "DRAW": "DRAW"}[match.outcome] if match.phase == "REVEAL" else {"WON": "YOU WIN", "LOST": "YOU LOSE", "DRAW": "DRAW"}[match.status], 146, 4 if match.status == "WON" or match.phase == "REVEAL" and match.outcome == "WIN" else 5 if match.status == "LOST" or match.phase == "REVEAL" and match.outcome == "LOSE" else 2)
            text({HandGesture.FIST: "ROCK", HandGesture.PAPER: "PAPER", HandGesture.SCISSORS: "SCISSORS"}[match.human_locked], 34, 128)
            text({HandGesture.FIST: "ROCK", HandGesture.PAPER: "PAPER", HandGesture.SCISSORS: "SCISSORS"}[match.robot_locked], 206, 128)
        else:
            centered("NEXT ROUND" if match.phase == "INTERMISSION" else "READY", 146)
    for round_index in range(3):
        palette = 3
        if round_index < len(match.history):
            palette = {"WIN": 4, "LOSE": 5, "DRAW": 2}[match.history[round_index]["outcome"]]
        text("bar", 111 + round_index * 34, 166, palette)
    if match.phase in ("READY", "INTERMISSION"):
        centered("ROUND " + str(match.round_index), 60)
        if match.phase == "READY" and match.stable_ticks:
            width = max(1, min(30, 30 * match.stable_ticks // match.stability_ticks))
            atlas_x, atlas_y, _, height = labels["bar"]
            sprites.append(SpriteDescriptor(145, 130, width, height, atlas_x, atlas_y, 4, 5))
    return Scene(max(0, match.tick_id), 0, (229, 237, 225), tuple(sprites), ARENA)