import struct
import unittest
import zlib

from pynq_multimodal_game.demo import (
    build_demo_scene,
    create_demo_assets,
    create_demo_engine,
)
from pynq_multimodal_game.gpu_abi import (
    COMMAND_CAPACITY,
    GpuCommand,
    SCENE_MAGIC,
    pack_assets,
    pack_command_bank,
    pack_index4,
    pack_palette_banks,
    pack_tile_descriptor,
    pack_tilemap,
)
from pynq_multimodal_game.renderer import GoldenRenderer
from pynq_multimodal_game.raster_trace import raster_trace_crc32, raster_writes
from pynq_multimodal_game.replay import build_demo_controls
from pynq_multimodal_game.scene import (
    HudState,
    IndexedImage,
    PalettePack,
    Scene,
    SpriteDescriptor,
    TileDescriptor,
    TileLayer,
)
from pynq_multimodal_game.scene_compiler import (
    CommandRenderer,
    CompiledFrame,
    SceneCompiler,
)


class SceneCompilerTests(unittest.TestCase):
    def test_compact_hud_stays_in_bar_and_matches_gpu_for_extreme_values(self):
        from dataclasses import replace
        for health,progress,score in ((5,0,0),(4,50,42),(0,100,999999999)):
            hud=HudState(score=score,health=health,max_health=5,shield_energy=0,
                max_shield_energy=1,attack_cooldown=0,max_attack_cooldown=1,
                progress=progress,progress_max=100,hand_valid=True,audio_valid=False)
            scene=Scene(0,0,(12,34,56),hud=hud)
            self.assert_matches_golden(scene)
            pixels=self.golden.render(scene)
            self.assertEqual(pixels[10*320*3:],bytes((12,34,56))*((180-10)*320))
            # Hidden skill/input indicators cannot affect the compact header.
            other=replace(scene,hud=replace(hud,shield_energy=1,attack_cooldown=1,
                                           hand_valid=False,audio_valid=True))
            self.assertEqual(self.golden.render(other),pixels)

    def setUp(self) -> None:
        palette = tuple((index * 10, index * 5, index * 3) for index in range(16))
        self.sprite_atlas = IndexedImage(
            4, 2, bytes([1, 0, 2, 2, 1, 1, 2, 2])
        )
        self.tile_atlas = IndexedImage(2, 2, bytes([3, 3, 3, 3]))
        self.palettes = PalettePack((palette,))
        self.golden = GoldenRenderer(
            sprite_atlas=self.sprite_atlas,
            tile_atlas=self.tile_atlas,
            palettes=self.palettes,
        )
        self.compiler = SceneCompiler(
            sprite_atlas=self.sprite_atlas,
            tile_atlas=self.tile_atlas,
            palettes=self.palettes,
        )
        self.command_renderer = CommandRenderer()

    def assert_matches_golden(self, scene: Scene) -> None:
        compiled = self.compiler.compile(scene)
        tokens = self.command_renderer.render_tokens(compiled)
        expanded = bytearray()
        for token in tokens:
            expanded.extend(compiled.palette_banks[token >> 4][token & 0x0F])

        self.assertEqual(320 * 180, len(tokens))
        self.assertEqual(bytes(expanded), self.command_renderer.render(compiled))
        self.assertEqual(
            self.golden.render(scene), self.command_renderer.render(compiled)
        )

    def test_token_nibbles_and_transparency_are_preserved(self) -> None:
        compiled = self.compiler.compile(
            Scene(frame_id=9, camera_x=0, background_color=(1, 2, 3))
        )
        frame = CompiledFrame(
            header=compiled.header,
            commands=(
                GpuCommand.clear(0x42),
                GpuCommand.blit_index4(
                    asset_id=0,
                    palette_bank=0xA,
                    dst_x=0,
                    dst_y=0,
                    width=4,
                    height=2,
                    src_x=0,
                    src_y=0,
                ),
                GpuCommand.end_frame(),
            ),
            assets=compiled.assets,
            tilemaps=compiled.tilemaps,
            palette_banks=compiled.palette_banks,
        )

        tokens = self.command_renderer.render_tokens(frame)

        self.assertEqual(320 * 180, len(tokens))
        self.assertEqual(0xA1, tokens[0])
        self.assertEqual(0x42, tokens[1])
        self.assertEqual(0xA2, tokens[2])
        self.assertEqual(0x42, tokens[4])

    def test_layered_scene_matches_golden(self) -> None:
        scene = Scene(
            frame_id=7,
            camera_x=1,
            background_color=(7, 8, 9),
            sprites=(
                SpriteDescriptor(2, 3, 2, 2, 0, 0, 0, 1, flip_x=True),
                SpriteDescriptor(2, 3, 2, 2, 2, 0, 0, 2),
            ),
            tile_layer=TileLayer(
                1,
                1,
                (TileDescriptor(0, flip_y=True),),
                origin_x=1,
                origin_y=12,
                tile_size=2,
            ),
        )

        self.assert_matches_golden(scene)

    def test_hud_scene_matches_golden(self) -> None:
        scene = Scene(
            frame_id=8,
            camera_x=0,
            background_color=(3, 4, 5),
            hud=HudState(
                score=15,
                health=2,
                max_health=3,
                shield_energy=5,
                max_shield_energy=10,
                attack_cooldown=2,
                max_attack_cooldown=10,
                progress=4,
                progress_max=10,
                hand_valid=True,
                audio_valid=False,
            ),
        )

        self.assert_matches_golden(scene)

    def test_hud_commands_reuse_keeps_full_frame_and_invalidates_every_value(self):
        from dataclasses import replace
        from unittest.mock import patch

        hud = HudState(15, 2, 3, 5, 10, 2, 10, 4, 10, True, False)
        scene = Scene(frame_id=0, camera_x=0, background_color=(3, 4, 5), hud=hud)
        changes = dict(score=16, health=1, max_health=4, shield_energy=6, max_shield_energy=11,
                       attack_cooldown=3, max_attack_cooldown=11, progress=5, progress_max=11,
                       hand_valid=False, audio_valid=True)
        with patch.object(self.compiler, "_compile_hud", wraps=self.compiler._compile_hud) as build:
            first = self.compiler.compile(scene)
            second = self.compiler.compile(replace(scene, frame_id=1, camera_x=2), submit_seq=7,
                                           palette_generation=3, asset_generation=4, tilemap_generation=5)
            self.assertEqual(first.commands, second.commands)
            self.assertEqual(1, build.call_count)
            for index, (name, value) in enumerate(changes.items(), 2):
                current = replace(scene, frame_id=index, hud=replace(hud, **{name: value}))
                actual = self.compiler.compile(current)
                fresh = SceneCompiler(sprite_atlas=self.sprite_atlas, tile_atlas=self.tile_atlas,
                                      palettes=self.palettes).compile(current)
                self.assertEqual(fresh, actual)
                self.assertEqual(pack_command_bank(fresh.commands), pack_command_bank(actual.commands))
            self.assertEqual(12, build.call_count)

    def test_hud_commands_invalidate_on_font_offset_change(self):
        from unittest.mock import patch

        hud = HudState(15, 2, 3, 5, 10, 2, 10, 4, 10, True, False)
        scene = Scene(frame_id=0, camera_x=0, background_color=(3, 4, 5), hud=hud)
        with patch.object(self.compiler, "_compile_hud", wraps=self.compiler._compile_hud) as build:
            first = self.compiler.compile(scene)
            self.compiler.font_offsets["S"] += 3
            changed = self.compiler.compile(scene)
            self.assertNotEqual(first.commands, changed.commands)
            self.assertEqual(2, build.call_count)
            fresh = SceneCompiler(sprite_atlas=self.sprite_atlas, tile_atlas=self.tile_atlas, palettes=self.palettes)
            fresh.font_offsets.update(self.compiler.font_offsets)
            self.assertEqual(fresh.compile(scene), changed)

    def test_hud_subclasses_keep_uncached_build_behavior(self):
        from unittest.mock import patch

        class CustomHud(HudState):
            pass

        scene = Scene(frame_id=0, camera_x=0, background_color=(3, 4, 5),
                      hud=CustomHud(15, 2, 3, 5, 10, 2, 10, 4, 10, True, False))
        with patch.object(self.compiler, "_compile_hud", wraps=self.compiler._compile_hud) as build:
            self.assertEqual(self.compiler.compile(scene), self.compiler.compile(scene))
            self.assertEqual(2, build.call_count)

    def test_binary_layout_has_fixed_sizes(self) -> None:
        compiled = self.compiler.compile(
            Scene(frame_id=11, camera_x=0, background_color=(1, 2, 3)),
            palette_generation=1,
            asset_generation=2,
            tilemap_generation=3,
        )

        self.assertEqual(64, len(compiled.header.to_bytes()))
        self.assertEqual(SCENE_MAGIC, compiled.header.to_words()[0])
        self.assertEqual(1, compiled.header.to_words()[8])
        self.assertEqual(2, compiled.header.to_words()[10])
        self.assertEqual(3, compiled.header.to_words()[11])
        self.assertTrue(all(len(command.to_bytes()) == 32 for command in compiled.commands))
        self.assertEqual(4096, len(pack_command_bank(compiled.commands)))

    def test_command_bank_rejects_overflow(self) -> None:
        commands = tuple(GpuCommand.clear() for _ in range(COMMAND_CAPACITY + 1))

        with self.assertRaisesRegex(ValueError, "capacity"):
            pack_command_bank(commands)

    def test_index4_assets_have_fixed_nibble_order_and_alignment(self) -> None:
        odd_width = IndexedImage(3, 2, bytes([1, 2, 3, 4, 5, 6]))

        self.assertEqual(bytes((0x21, 0x03, 0x54, 0x06)), pack_index4(odd_width))
        packed = pack_assets((odd_width, self.sprite_atlas), generation=9)
        self.assertEqual(0, packed.descriptors[0].base_offset)
        self.assertEqual(64, packed.descriptors[1].base_offset)
        self.assertEqual(2, packed.descriptors[0].stride_bytes)
        self.assertEqual(9, packed.descriptors[0].generation)
        self.assertEqual(32, len(packed.descriptor_table))

    def test_palette_and_tilemap_payload_layout(self) -> None:
        scene = Scene(frame_id=0, camera_x=0, background_color=(1, 2, 3))
        compiled = self.compiler.compile(scene)
        palette_payload = pack_palette_banks(compiled.palette_banks)
        tile = TileDescriptor(0x1234, palette_bank=5, flip_x=True, flip_y=True)
        layer = TileLayer(1, 1, (tile,), origin_x=-2, origin_y=3, tile_size=2)
        tilemap_payload = pack_tilemap(layer)

        self.assertEqual(1024, len(palette_payload))
        self.assertEqual(0x00010203, struct.unpack_from("<I", palette_payload)[0])
        self.assertEqual(0x00351234, pack_tile_descriptor(tile))
        self.assertEqual(20, len(tilemap_payload))
        self.assertEqual((0x00010001, 0xFFFFFFFE, 3, 2), struct.unpack_from("<4I", tilemap_payload))

    def test_tile_command_supports_32_bit_screen_origin(self) -> None:
        command = GpuCommand.draw_tile_layer(
            asset_id=1,
            tilemap_id=0,
            screen_x=-40000,
            screen_y=50000,
            width_tiles=64,
            height_tiles=11,
            tile_size=16,
        )

        self.assertEqual(0xFFFF63C0, command.words[2])
        self.assertEqual(50000, command.words[3])

    def test_complete_demo_replay_fits_hardware_budgets(self) -> None:
        assets = create_demo_assets()
        engine = create_demo_engine()
        compiler = SceneCompiler(
            sprite_atlas=assets.renderer.sprite_atlas,
            tile_atlas=assets.renderer.tile_atlas,
            palettes=assets.renderer.palettes,
        )
        state = engine.initial_state()
        maximum_commands = 0
        maximum_cycles = 0
        first_token_crc32 = None
        last_token_crc32 = 0
        rolling_token_crc32 = 0
        first_trace = None
        last_trace = None
        maximum_writes = 0
        rolling_trace_summary = 0
        command_renderer = CommandRenderer()

        for control in build_demo_controls(330):
            state = engine.step(state, control)
            compiled = compiler.compile(
                build_demo_scene(state, engine.config, assets)
            )
            tokens = command_renderer.render_tokens(compiled)
            token_crc32 = zlib.crc32(tokens) & 0xFFFFFFFF
            if first_token_crc32 is None:
                first_token_crc32 = token_crc32
            last_token_crc32 = token_crc32
            rolling_token_crc32 = zlib.crc32(tokens, rolling_token_crc32) & 0xFFFFFFFF
            writes = raster_writes(
                compiled.commands, assets=compiled.assets, tilemaps=compiled.tilemaps
            )
            trace = (len(writes), raster_trace_crc32(writes))
            if first_trace is None:
                first_trace = trace
            last_trace = trace
            maximum_writes = max(maximum_writes, trace[0])
            rolling_trace_summary = zlib.crc32(
                struct.pack("<2I", *trace), rolling_trace_summary
            ) & 0xFFFFFFFF
            maximum_commands = max(maximum_commands, len(compiled.commands))
            maximum_cycles = max(maximum_cycles, compiled.header.predicted_cycles)

        self.assertLessEqual(maximum_commands, COMMAND_CAPACITY)
        self.assertLessEqual(maximum_cycles, 1_200_000)
        self.assertEqual(35, maximum_commands)
        self.assertEqual(122_305, maximum_cycles)
        self.assertEqual(0xB0A6A719, first_token_crc32)
        self.assertEqual(0x5EC8A618, last_token_crc32)
        self.assertEqual(0xB3B171EA, rolling_token_crc32)
        self.assertEqual((117078, 820242535), first_trace)
        self.assertEqual((117907, 1820056918), last_trace)
        self.assertEqual(118116, maximum_writes)
        self.assertEqual(0x0072B2EC, rolling_trace_summary)


if __name__ == "__main__":
    unittest.main()
