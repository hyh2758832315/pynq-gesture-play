import struct
import unittest
import zlib

from pynq_multimodal_game.gpu_abi import (
    ABI_MAJOR,
    ABI_MINOR,
    FRAME8_PAYLOAD_SIZE,
    PACKET_HEADER_BYTES,
    PACKET_MAGIC,
    PacketHeader,
    PacketType,
    SceneHeader,
    pack_asset_bundle_packet,
    pack_asset_packet,
    pack_assets,
    pack_frame8_packet,
    pack_palette_banks,
    pack_palette_packet,
    pack_resource_packet,
    pack_tilemap,
    pack_tilemap_packet,
    unpack_resource_packet,
)
from pynq_multimodal_game.scene import IndexedImage, TileDescriptor, TileLayer


class ResourcePacketTests(unittest.TestCase):
    def test_bundle_enforces_shared_32k_store_capacity(self) -> None:
        assets = (IndexedImage(510, 128, bytes(510 * 128)),
                  IndexedImage(2, 64, bytes(2 * 64)),
                  IndexedImage(2, 64, bytes(2 * 64)))
        self.assertEqual(64 + 48 + 32768, len(pack_asset_bundle_packet(assets, generation=1)))
        with self.assertRaisesRegex(ValueError, "asset bundle.*32768"):
            pack_asset_bundle_packet(assets[:2] + (IndexedImage(2, 65, bytes(2 * 65)),), generation=1)

    def test_scene_header_encodes_asset_generation(self) -> None:
        header = SceneHeader(
            frame_id=1,
            submit_seq=2,
            command_count=3,
            camera_x=4,
            camera_y=5,
            background_color=(6, 7, 8),
            palette_generation=0x10203040,
            asset_generation=0x50607080,
            tilemap_generation=0x90A0B0C0,
        )
        words = struct.unpack("<16I", header.to_bytes())
        self.assertEqual(0x10203040, words[8])
        self.assertEqual(0x50607080, words[10])
        self.assertEqual(0x90A0B0C0, words[11])
        with self.assertRaisesRegex(ValueError, "flags are reserved"):
            SceneHeader(
                frame_id=1,
                submit_seq=2,
                command_count=3,
                camera_x=4,
                camera_y=5,
                background_color=(6, 7, 8),
                flags=1,
            )

    def test_all_packet_types_round_trip(self) -> None:
        for packet_type in PacketType:
            with self.subTest(packet_type=packet_type):
                payload = bytes((int(packet_type), 0xA5, 0x5A))
                packet = pack_resource_packet(
                    packet_type,
                    payload,
                    target_id=2,
                    generation=0x12345678,
                )

                header, unpacked_payload = unpack_resource_packet(packet)

                self.assertEqual(PACKET_HEADER_BYTES + len(payload), len(packet))
                self.assertEqual(packet_type, header.packet_type)
                self.assertEqual(2, header.target_id)
                self.assertEqual(0x12345678, header.generation)
                self.assertEqual(zlib.crc32(payload) & 0xFFFFFFFF, header.payload_crc32)
                self.assertEqual(payload, unpacked_payload)

    def test_header_layout_keeps_routing_magic_in_first_word(self) -> None:
        header = PacketHeader.for_payload(
            PacketType.TILEMAP,
            target_id=3,
            generation=9,
            payload=b"tilemap",
        )
        words = struct.unpack("<16I", header.to_bytes())

        self.assertEqual(PACKET_MAGIC[PacketType.TILEMAP], words[0])
        self.assertEqual((ABI_MAJOR << 16) | ABI_MINOR, words[1])
        self.assertEqual(PacketType.TILEMAP, words[2])
        self.assertEqual((3, 9, 7), words[3:6])
        self.assertEqual((0,) * 8, words[8:])

    def test_unpack_rejects_corruption_and_layout_mismatches(self) -> None:
        packet = bytearray(
            pack_resource_packet(
                PacketType.ASSET,
                b"asset-data",
                target_id=0,
                generation=1,
            )
        )

        corrupted_payload = bytearray(packet)
        corrupted_payload[-1] ^= 0xFF
        with self.assertRaisesRegex(ValueError, "CRC mismatch"):
            unpack_resource_packet(bytes(corrupted_payload))

        wrong_magic = bytearray(packet)
        wrong_magic[0:4] = PACKET_MAGIC[PacketType.FRAME8].to_bytes(4, "little")
        with self.assertRaisesRegex(ValueError, "magic does not match"):
            unpack_resource_packet(bytes(wrong_magic))

        with self.assertRaisesRegex(ValueError, "payload length mismatch"):
            unpack_resource_packet(bytes(packet[:-1]))

    def test_frame8_requires_exact_logical_frame(self) -> None:
        tokens = bytes((index & 0xFF for index in range(FRAME8_PAYLOAD_SIZE)))
        header, payload = unpack_resource_packet(
            pack_frame8_packet(tokens, generation=4)
        )

        self.assertEqual(PacketType.FRAME8, header.packet_type)
        self.assertEqual(FRAME8_PAYLOAD_SIZE, header.payload_size)
        self.assertEqual(tokens, payload)
        with self.assertRaisesRegex(ValueError, "57600 tokens"):
            pack_frame8_packet(tokens[:-1], generation=4)

    def test_typed_resource_packers_preserve_existing_payloads(self) -> None:
        image = IndexedImage(3, 2, bytes((1, 2, 3, 4, 5, 6)))
        asset_header, asset_payload = unpack_resource_packet(
            pack_asset_packet(image, target_id=15, generation=0x123)
        )
        self.assertEqual(PacketType.ASSET, asset_header.packet_type)
        self.assertEqual((15, 0x123), (asset_header.target_id, asset_header.generation))
        self.assertEqual(16 + 4, len(asset_payload))
        self.assertEqual(0x23, struct.unpack_from("<I", asset_payload, 8)[0] >> 24)

        bundle_assets = (
            image,
            IndexedImage(2, 1, bytes((7, 8))),
            IndexedImage(1, 1, bytes((9,))),
        )
        bundle_header, bundle_payload = unpack_resource_packet(
            pack_asset_bundle_packet(bundle_assets, generation=0x123)
        )
        packed_bundle = pack_assets(bundle_assets, generation=0x23)
        self.assertEqual(PacketType.ASSET, bundle_header.packet_type)
        self.assertEqual((0, 0x123), (bundle_header.target_id, bundle_header.generation))
        self.assertEqual(
            packed_bundle.descriptor_table + packed_bundle.payload,
            bundle_payload,
        )
        with self.assertRaisesRegex(ValueError, "exactly 3 assets"):
            pack_asset_bundle_packet((), generation=0)
        with self.assertRaisesRegex(ValueError, "exactly 3 assets"):
            pack_asset_bundle_packet(bundle_assets + (image,), generation=0)

        layer = TileLayer(1, 1, (TileDescriptor(7, palette_bank=2),))
        tilemap_header, tilemap_payload = unpack_resource_packet(
            pack_tilemap_packet(layer, target_id=3, generation=8)
        )
        self.assertEqual(PacketType.TILEMAP, tilemap_header.packet_type)
        self.assertEqual(pack_tilemap(layer), tilemap_payload)

        banks = tuple(
            tuple((bank, color, 255 - color) for color in range(16))
            for bank in range(16)
        )
        palette_header, palette_payload = unpack_resource_packet(
            pack_palette_packet(banks, generation=11)
        )
        self.assertEqual(PacketType.PALETTE, palette_header.packet_type)
        self.assertEqual(pack_palette_banks(banks), palette_payload)

        with self.assertRaisesRegex(ValueError, "asset target_id"):
            pack_asset_packet(image, target_id=16, generation=0)
        with self.assertRaisesRegex(ValueError, "tilemap target_id"):
            pack_tilemap_packet(layer, target_id=4, generation=0)


if __name__ == "__main__":
    unittest.main()