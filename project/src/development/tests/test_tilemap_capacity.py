"""Frozen GPU slot limits and oversized-world viewport equivalence."""
from dataclasses import replace
import unittest

from pynq_multimodal_game.gpu_abi import (
    TILEMAP_SLOT_BYTES, TILEMAP_TILE_CAPACITY, pack_tilemap, pack_tilemap_packet,
)
from pynq_multimodal_game.renderer import GoldenRenderer
from pynq_multimodal_game.scene import IndexedImage, PalettePack, Scene, TileDescriptor, TileLayer
from pynq_multimodal_game.scene_compiler import CommandRenderer, SceneCompiler


class TilemapCapacityTests(unittest.TestCase):
    def setUp(self):
        self.assets = dict(sprite_atlas=IndexedImage(16, 16, bytes([1]) * 256),
                           tile_atlas=IndexedImage(32, 16, bytes(
                               1 + (x // 16) * 6 + x % 3 + (y % 2) * 3
                               for y in range(16) for x in range(32))),
                           palettes=PalettePack((tuple((i * 16, i * 8, i * 4) for i in range(16)),)))
        self.compiler = SceneCompiler(**self.assets)

    def layer(self, width=160, height=11, **kwargs):
        return TileLayer(width, height, tuple(TileDescriptor((x + y) % 2, flip_x=bool(x % 3),
                         flip_y=bool(y % 2)) for y in range(height) for x in range(width)), **kwargs)

    def test_exact_slot_limit_and_one_extra_rejected_before_transport(self):
        legal = self.layer(TILEMAP_TILE_CAPACITY, 1)
        self.assertEqual(TILEMAP_SLOT_BYTES, len(pack_tilemap(legal)))
        self.assertEqual(TILEMAP_SLOT_BYTES + 64, len(pack_tilemap_packet(legal, target_id=0, generation=1)))
        with self.assertRaisesRegex(ValueError, "hardware slot capacity"):
            pack_tilemap_packet(self.layer(TILEMAP_TILE_CAPACITY + 1, 1), target_id=0, generation=1)

    def test_long_world_pixels_at_scroll_boundaries_and_world_end(self):
        layer = self.layer(origin_x=-13, origin_y=7)
        golden = GoldenRenderer(**self.assets)
        for camera in (0, 1, 111, 114, 115, 127, 128, 129, 505, 1023, 2021, 2227, 2520):
            with self.subTest(camera=camera):
                scene = Scene(1, camera, (4, 6, 8), tile_layer=layer)
                compiled = self.compiler.compile(scene)
                self.assertLessEqual(len(pack_tilemap(compiled.tilemaps[0])), TILEMAP_SLOT_BYTES)
                self.assertEqual(golden.render(scene), CommandRenderer().render(compiled))

    def test_vertical_clipping_and_new_source_invalidate_single_window(self):
        layer = self.layer(160, 24, origin_y=-197)
        scene = Scene(0, 120, (0, 0, 0), tile_layer=layer)
        first = self.compiler.compile(scene)
        next_frame = self.compiler.compile(replace(scene, camera_x=121))
        self.assertIs(first.tilemaps[0], next_frame.tilemaps[0])
        self.assertEqual(GoldenRenderer(**self.assets).render(scene), CommandRenderer().render(first))
        changed = replace(layer, tiles=(TileDescriptor(1),) * len(layer.tiles))
        updated = self.compiler.compile(replace(scene, tile_layer=changed))
        self.assertNotEqual(first.tilemaps, updated.tilemaps)
        self.assertEqual(GoldenRenderer(**self.assets).render(replace(scene, tile_layer=changed)),
                         CommandRenderer().render(updated))

    def test_small_maps_remain_byte_identical(self):
        layer = self.layer(96, 10)
        self.assertIs(layer, self.compiler.compile(Scene(0, 200, (0, 0, 0), tile_layer=layer)).tilemaps[0])

    def test_visible_window_too_dense_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "visible tilemap window"):
            self.compiler.compile(Scene(0, 0, (0, 0, 0), tile_layer=self.layer(161, 91, tile_size=2)))


if __name__ == '__main__':
    unittest.main()
