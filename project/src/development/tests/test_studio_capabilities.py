from pynq_multimodal_game.gpu_abi import Opcode
from pynq_multimodal_game.studio.capabilities import (
    C4M7_CAPABILITIES,
    CAPABILITY_MATRIX,
    CapabilityStatus,
)


def test_c4m7_capabilities_match_frozen_abi() -> None:
    assert C4M7_CAPABILITIES.build_id == 0xC0040700
    assert C4M7_CAPABILITIES.abi_version == (1, 0)
    assert C4M7_CAPABILITIES.logical_size == (320, 180)
    assert C4M7_CAPABILITIES.output_size == (1280, 720)
    assert C4M7_CAPABILITIES.command_capacity == 128
    assert C4M7_CAPABILITIES.max_sprites == 16
    assert C4M7_CAPABILITIES.asset_bundle_slots == 3
    assert C4M7_CAPABILITIES.tilemap_slots == 4
    assert C4M7_CAPABILITIES.supported_opcodes == (
        Opcode.CLEAR,
        Opcode.DRAW_TILE_LAYER,
        Opcode.BLIT_INDEX4,
        Opcode.FILL_RECT,
        Opcode.END_FRAME,
    )
    assert C4M7_CAPABILITIES.frame8_supported is False


def test_capability_matrix_does_not_claim_frame8_support() -> None:
    rows = {capability.key: capability for capability in CAPABILITY_MATRIX}

    assert rows["scene2d"].status is CapabilityStatus.VERIFIED
    assert rows["game_runtime"].status is CapabilityStatus.PS_SOFTWARE
    assert rows["frame8"].status is CapabilityStatus.UNSUPPORTED
    assert rows["generic_video"].status is CapabilityStatus.FUTURE_RTL