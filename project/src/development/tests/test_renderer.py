import unittest

from pynq_multimodal_game.renderer import GoldenRenderer
from pynq_multimodal_game.scene import (
    LOGICAL_HEIGHT,
    LOGICAL_WIDTH,
    OUTPUT_SCALE,
    HudState,
    IndexedImage,
    PalettePack,
    Scene,
    SpriteDescriptor,
    TileDescriptor,
    TileLayer,
)


def pixel(frame: bytes, x: int, y: int):
    offset = (y * LOGICAL_WIDTH + x) * 3
    return tuple(frame[offset : offset + 3])


class GoldenRendererTests(unittest.TestCase):
    def setUp(self) -> None:
        palette = tuple((index * 10, index * 5, index * 3) for index in range(16))
        self.renderer = GoldenRenderer(
            sprite_atlas=IndexedImage(4, 2, bytes([1, 0, 2, 2, 1, 1, 2, 2])),
            tile_atlas=IndexedImage(2, 2, bytes([3, 3, 3, 3])),
            palettes=PalettePack((palette,)),
        )

    def test_transparency_preserves_background(self) -> None:
        scene = Scene(
            frame_id=0,
            camera_x=0,
            background_color=(7, 8, 9),
            sprites=(SpriteDescriptor(5, 5, 2, 2, 0, 0, 0, 1),),
        )

        frame = self.renderer.render(scene)

        self.assertEqual((10, 5, 3), pixel(frame, 5, 5))
        self.assertEqual((7, 8, 9), pixel(frame, 6, 5))

    def test_higher_priority_sprite_overwrites_lower_priority(self) -> None:
        scene = Scene(
            frame_id=0,
            camera_x=0,
            background_color=(0, 0, 0),
            sprites=(
                SpriteDescriptor(8, 8, 2, 2, 0, 0, 0, 1),
                SpriteDescriptor(8, 8, 2, 2, 2, 0, 0, 2),
            ),
        )

        frame = self.renderer.render(scene)

        self.assertEqual((20, 10, 6), pixel(frame, 8, 8))

    def test_flip_and_partial_offscreen_clipping(self) -> None:
        scene = Scene(
            frame_id=0,
            camera_x=0,
            background_color=(0, 0, 0),
            sprites=(SpriteDescriptor(-1, 3, 2, 2, 0, 0, 0, 1, flip_x=True),),
        )

        frame = self.renderer.render(scene)

        self.assertEqual((10, 5, 3), pixel(frame, 0, 3))

    def test_tile_layer_tracks_camera_x(self) -> None:
        layer = TileLayer(1, 1, (TileDescriptor(0),), origin_x=5, origin_y=12, tile_size=2)
        scene = Scene(
            frame_id=0,
            camera_x=4,
            background_color=(0, 0, 0),
            tile_layer=layer,
        )

        frame = self.renderer.render(scene)

        self.assertEqual((30, 15, 9), pixel(frame, 1, 12))
        self.assertEqual((0, 0, 0), pixel(frame, 0, 12))

    def test_crc_and_four_times_scaling_are_deterministic(self) -> None:
        scene = Scene(frame_id=0, camera_x=0, background_color=(1, 2, 3))
        first = self.renderer.render(scene)
        second = self.renderer.render(scene)
        scaled = self.renderer.scale_to_720p(first)

        self.assertEqual(self.renderer.crc32(first), self.renderer.crc32(second))
        self.assertEqual(
            LOGICAL_WIDTH * OUTPUT_SCALE * LOGICAL_HEIGHT * OUTPUT_SCALE * 3,
            len(scaled),
        )
        self.assertEqual((1, 2, 3), tuple(scaled[:3]))

    def test_hud_renders_numeric_score(self) -> None:
        common = dict(
            health=3,
            max_health=3,
            shield_energy=10,
            max_shield_energy=10,
            attack_cooldown=0,
            max_attack_cooldown=10,
            progress=0,
            progress_max=100,
            hand_valid=True,
            audio_valid=True,
        )
        score_zero = self.renderer.render(
            Scene(
                frame_id=0,
                camera_x=0,
                background_color=(0, 0, 0),
                hud=HudState(score=0, **common),
            )
        )
        score_fifteen = self.renderer.render(
            Scene(
                frame_id=0,
                camera_x=0,
                background_color=(0, 0, 0),
                hud=HudState(score=15, **common),
            )
        )

        self.assertEqual((245, 241, 224), pixel(score_zero, 246, 2))
        self.assertEqual((245, 241, 224), pixel(score_zero, 250, 2))
        self.assertNotEqual(score_zero, score_fifteen)


if __name__ == "__main__":
    unittest.main()