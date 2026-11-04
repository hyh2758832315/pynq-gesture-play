import unittest
import zlib

from pynq_multimodal_game.gpu_abi import GpuCommand
from pynq_multimodal_game.raster_trace import (
    PixelWrite,
    apply_writes,
    clear_fill_writes,
    first_pixel_difference,
    indexed_blit_writes,
    raster_writes,
    raster_trace_bytes,
    raster_trace_crc32,
)
from pynq_multimodal_game.scene import IndexedImage, TileDescriptor, TileLayer
from pynq_multimodal_game.scene_compiler import CommandRenderer, CompiledFrame


class RasterTraceTests(unittest.TestCase):
    def test_clear_fill_trace_matches_command_renderer(self) -> None:
        commands = (
            GpuCommand.clear(0x42),
            GpuCommand.fill_rect(x=-2, y=-1, width=4, height=3, token=0xA5),
            GpuCommand.fill_rect(x=319, y=179, width=3, height=3, token=0x7E),
            GpuCommand.fill_rect(x=400, y=200, width=4, height=4, token=0x11),
            GpuCommand.fill_rect(x=10, y=10, width=0, height=7, token=0x22),
            GpuCommand.end_frame(),
            GpuCommand.clear(0xFF),
        )
        writes = clear_fill_writes(commands)
        frame = CompiledFrame(
            header=None,  # type: ignore[arg-type]
            commands=commands,
            assets=(),
            tilemaps=(),
            palette_banks=(),
        )

        self.assertEqual(320 * 180 + 5, len(writes))
        self.assertEqual(0xA5, apply_writes(writes)[0])
        self.assertEqual(0x7E, apply_writes(writes)[-1])
        self.assertEqual(
            CommandRenderer().render_tokens(frame),
            apply_writes(writes),
        )

    def test_trace_record_is_little_endian_and_crc_compatible(self) -> None:
        writes = (PixelWrite(0x1234, 0xAB), PixelWrite(0x00FF, 0x42))
        packed = raster_trace_bytes(writes)

        self.assertEqual(bytes.fromhex("3412ab00ff004200"), packed)
        self.assertEqual(zlib.crc32(packed) & 0xFFFFFFFF, raster_trace_crc32(writes))

    def test_unsupported_opcode_is_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "unsupported raster opcode 3"):
            clear_fill_writes(
                (
                    GpuCommand.blit_index4(
                        asset_id=0,
                        palette_bank=0,
                        dst_x=0,
                        dst_y=0,
                        width=1,
                        height=1,
                        src_x=0,
                        src_y=0,
                    ),
                )
            )

    def test_indexed_blit_clips_flips_and_skips_transparent_indices(self) -> None:
        asset = IndexedImage(3, 2, bytes((1, 0, 2, 3, 4, 0)))
        writes = indexed_blit_writes(
            (
                GpuCommand.blit_index4(
                    asset_id=0,
                    palette_bank=0xA,
                    dst_x=-1,
                    dst_y=1,
                    width=3,
                    height=2,
                    src_x=0,
                    src_y=0,
                    flip_x=True,
                    flip_y=True,
                ),
                GpuCommand.end_frame(),
            ),
            (asset,),
        )
        self.assertEqual(
            (
                PixelWrite(320, 0xA4),
                PixelWrite(321, 0xA3),
                PixelWrite(641, 0xA1),
            ),
            writes,
        )

    def test_tile_layer_writes_match_command_renderer(self) -> None:
        sprite_asset = IndexedImage(1, 1, bytes((5,)))
        tile_asset = IndexedImage(4, 2, bytes((1, 0, 2, 3, 4, 5, 6, 0)))
        tilemap = TileLayer(
            2,
            1,
            (
                TileDescriptor(0, palette_bank=2, flip_x=True),
                TileDescriptor(1, palette_bank=3, flip_y=True),
            ),
            tile_size=2,
        )
        commands = (
            GpuCommand.clear(0x11),
            GpuCommand.draw_tile_layer(
                asset_id=1,
                tilemap_id=0,
                screen_x=-1,
                screen_y=1,
                width_tiles=2,
                height_tiles=1,
                tile_size=2,
            ),
            GpuCommand.blit_index4(
                asset_id=0,
                palette_bank=4,
                dst_x=1,
                dst_y=1,
                width=1,
                height=1,
                src_x=0,
                src_y=0,
            ),
            GpuCommand.fill_rect(x=2, y=2, width=1, height=1, token=0x67),
            GpuCommand.end_frame(),
        )
        frame = CompiledFrame(
            header=None,  # type: ignore[arg-type]
            commands=commands,
            assets=(sprite_asset, tile_asset),
            tilemaps=(tilemap,),
            palette_banks=(),
        )

        writes = raster_writes(
            commands,
            assets=frame.assets,
            tilemaps=frame.tilemaps,
        )

        self.assertEqual(
            CommandRenderer().render_tokens(frame),
            apply_writes(writes),
        )
        self.assertEqual(
            (
                PixelWrite(320, 0x21),
                PixelWrite(321, 0x36),
                PixelWrite(640, 0x24),
                PixelWrite(641, 0x32),
                PixelWrite(642, 0x33),
                PixelWrite(321, 0x45),
                PixelWrite(642, 0x67),
            ),
            writes[320 * 180 :],
        )

    def test_first_pixel_difference_reports_coordinates(self) -> None:
        expected = bytes(320 * 180)
        actual = bytearray(expected)
        actual[2 * 320 + 7] = 0xA5

        difference = first_pixel_difference(expected, bytes(actual))

        self.assertEqual(
            PixelWrite(2 * 320 + 7, 0xA5).address,
            difference.address if difference is not None else None,
        )
        self.assertEqual((7, 2, 0, 0xA5), (
            difference.x,
            difference.y,
            difference.expected,
            difference.actual,
        ) if difference is not None else None)
        self.assertIsNone(first_pixel_difference(expected, expected))


if __name__ == "__main__":
    unittest.main()