from pynq_multimodal_game.scene import HudState, Scene, SpriteDescriptor, TileDescriptor, TileLayer

from .level import COINS, GOAL_X, GOAL_GROUND_Y, LIFT_X, NOTE_X, SCALE, WORLD_WIDTH, level_blocks


def build_scene(game, regions):
    camera = 0 if game.status == "SELECT" else game.camera_x
    sprites = []

    def image(name, x, y, palette=2, priority=3, width=None):
        atlas_x, atlas_y, source_width, height = regions[name]
        sprites.append(SpriteDescriptor(x, y, source_width if width is None else width, height, atlas_x, atlas_y, palette, priority))

    def centered(name, y):
        image(name, camera + (320 - regions[name][2]) // 2, y, 3, 5)

    if game.status == "SELECT":
        centered("CHOOSE HERO", 25)
        for female in (False, True):
            center = 218 if female else 102
            sprites.append(SpriteDescriptor(center - 24, 60, 48, 64, 48 * female, 64, int(female), 3))
            name = "ROSE" if female else "LEO"
            image(name, center - regions[name][2] // 2, 135, 3)
            label = "FEMALE" if female else "MALE"
            image(label, center - regions[label][2] // 2, 152, 3)
        image("selection", (218 if game.character == "female" else 102) - 12, 43, 4)
        return Scene(max(0, game.tick), 0, (185, 229, 229), tuple(sprites))
    columns=WORLD_WIDTH//16
    tiles = [TileDescriptor(0, 2)] * (columns * 10)
    for column in range(columns):
        if column % 13 in (3, 4, 5):
            tiles[column] = TileDescriptor(9, 2)
    identifiers = {"ground": 1, "brick": 3, "reward": 4, "platform": 6, "gate": 7}
    for index, block in enumerate(level_blocks()):
        if block.kind == "gate" and game.gate_open:
            continue
        tile_id = 5 if index in game.used_bricks else identifiers[block.kind]
        for row in range(block.y // 16 - 2, (block.y + block.height) // 16 - 2):
            for column in range(block.x // 16, (block.x + block.width) // 16):
                value = (8 if block.y == 48 else 2) if block.kind == "ground" and row == block.y // 16 - 2 else tile_id
                tiles[row * columns + column] = TileDescriptor(value, 2)
    layer = TileLayer(columns, 10, tuple(tiles), origin_y=32)
    pose = 3 if not game.grounded else (game.tick // 7 % 2 + 1) if game.vx else 0
    if not game.invulnerable or game.tick // 5 % 2 == 0:
        sprites.append(SpriteDescriptor(game.x // SCALE - 6, game.y // SCALE - 10, 24, 32, pose * 24, 32 if game.character == "female" else 0, int(game.character == "female"), 4, flip_x=game.facing < 0))
    for enemy in game.enemies:
        if enemy.alive and camera - 16 <= enemy.x // SCALE <= camera + 320:
            image("enemy", enemy.x // SCALE, 32 if 1056*SCALE <= enemy.left < 1536*SCALE else 128)
    for index, (coin_x, coin_y) in enumerate(COINS):
        if index not in game.collected and camera - 12 <= coin_x <= camera + 320:
            image("coin", coin_x, coin_y)
    if camera - 16 <= NOTE_X <= camera + 320:
        image("note", NOTE_X, 128 if game.gate_open else 124)
    if camera - 48 <= LIFT_X <= camera + 320:
        image("lift", LIFT_X, game.lift_y // SCALE)
        image("lift", LIFT_X + 20, game.lift_y // SCALE)
    if camera - 16 <= GOAL_X <= camera + 320:
        image("goal", GOAL_X, GOAL_GROUND_Y - regions["goal"][3])
    if game.status in ("WON", "LOST"):
        centered("LEVEL CLEAR" if game.status == "WON" else "GAME OVER", 72)
    return Scene(max(0, game.tick), camera, (185, 229, 229), tuple(sprites), layer,
        hud=HudState(score=game.score,health=game.health,max_health=5,
            shield_energy=0,max_shield_energy=1,attack_cooldown=0,max_attack_cooldown=1,
            progress=max(0,min(GOAL_X,game.x//SCALE)),progress_max=GOAL_X,
            hand_valid=True,audio_valid=False))
