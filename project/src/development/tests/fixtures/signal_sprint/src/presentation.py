from dataclasses import dataclass

from pynq_multimodal_game.engine.side_scroller import (
    SideScrollerConfig,
    SideScrollerState,
)
from pynq_multimodal_game.renderer import GoldenRenderer
from pynq_multimodal_game.scene import (
    HudState,
    IndexedImage,
    PalettePack,
    Scene,
    SpriteDescriptor,
)


@dataclass(frozen=True)
class SignalSprintAssets:
    renderer: GoldenRenderer


def create_assets() -> SignalSprintAssets:
    pixels = bytearray(24 * 8)
    for y in range(8):
        for x in range(8):
            if 1 <= x <= 6 and 1 <= y <= 6:
                pixels[y * 24 + x] = 1
            if (x - 3) * (x - 3) + (y - 3) * (y - 3) <= 9:
                pixels[y * 24 + 8 + x] = 2
            if x in (0, 7) or y in (0, 7) or (x + y) % 4 == 0:
                pixels[y * 24 + 16 + x] = 3
    palette = (
        (0, 0, 0),
        (72, 214, 166),
        (255, 215, 92),
        (225, 84, 84),
        *((0, 0, 0),) * 12,
    )
    renderer = GoldenRenderer(
        sprite_atlas=IndexedImage(24, 8, bytes(pixels)),
        tile_atlas=IndexedImage(1, 1, b"\x00"),
        palettes=PalettePack((palette,)),
    )
    return SignalSprintAssets(renderer)


def build_scene(
    state: SideScrollerState,
    config: SideScrollerConfig,
    assets: SignalSprintAssets,
) -> Scene:
    sprites = [
        SpriteDescriptor(
            x=state.world_x,
            y=86 + state.lane_y - min(16, state.z // 8),
            width=8,
            height=8,
            atlas_x=0,
            atlas_y=0,
            palette_bank=0,
            priority=3,
        )
    ]
    sprites.extend(
        SpriteDescriptor(
            x=coin.world_x,
            y=86 + coin.lane_y,
            width=8,
            height=8,
            atlas_x=8,
            atlas_y=0,
            palette_bank=0,
            priority=2,
        )
        for coin in state.coins
    )
    sprites.extend(
        SpriteDescriptor(
            x=obstacle.world_x,
            y=86 + obstacle.lane_y,
            width=8,
            height=8,
            atlas_x=16,
            atlas_y=0,
            palette_bank=0,
            priority=1,
        )
        for obstacle in state.obstacles
    )
    return Scene(
        frame_id=max(0, state.tick_id),
        camera_x=0,
        background_color=(13, 31, 45),
        sprites=tuple(sprites),
        hud=HudState(
            score=state.score,
            health=state.health,
            max_health=config.max_health,
            shield_energy=state.shield_energy,
            max_shield_energy=config.max_shield_energy,
            attack_cooldown=state.attack_cooldown,
            max_attack_cooldown=config.attack_cooldown_ticks,
            progress=state.world_x,
            progress_max=config.level_length,
            hand_valid=True,
            audio_valid=True,
        ),
    )