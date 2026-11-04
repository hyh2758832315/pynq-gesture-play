from __future__ import annotations

from dataclasses import replace
from pathlib import Path
import struct

import pytest

from pynq_multimodal_game.controls import ControlSource, ControlState, Direction, StaleFlag
from pynq_multimodal_game.gpu_abi import COMMAND_CAPACITY, GpuCommand, pack_command_bank, unpack_resource_packet
from pynq_multimodal_game.game_package import GamePackageBuilder
from pynq_multimodal_game.game_runner import GameRunner
from pynq_multimodal_game.game_sdk import GameInput
from pynq_multimodal_game.menu import build_menu_scene, create_menu_assets
from pynq_multimodal_game.return_button import (
    RETURN_COMMANDS, RETURN_DWELL_NS, ReturnDwell, add_return_to_scene_packet,
    add_return_to_game_frame, add_return_to_video_palette, return_contains,
)
from pynq_multimodal_game.scene_compiler import CommandRenderer, SYSTEM_COLORS, SceneCompiler
from pynq_multimodal_game.video_codec import build_palette_packet
from pynq_multimodal_game.vision_input import VisionInputProvider


def _control(x: int, y: int, *, timestamp_ns: int = 0, valid: bool = True,
             stale: StaleFlag = StaleFlag.NONE) -> ControlState:
    return ControlState(
        tick_id=0, timestamp_ns=timestamp_ns, gesture_source=ControlSource.REAL,
        gesture_seq=0, hand_valid=valid, hand_x=x * 2 / 319 - 1,
        hand_y=y * 2 / 179 - 1, direction=Direction.IDLE,
        fist_score=0, fist_event=False, voice_source=ControlSource.REAL,
        voice_seq=0, audio_valid=False, low_voice_active=False,
        high_voice_event=False, low_confidence=0, high_confidence=0,
        stale_flags=stale,
    )


def test_return_dwell_requires_fresh_continuous_hand_and_fires_once() -> None:
    dwell = ReturnDwell()
    assert return_contains(_control(12, 12))
    assert not return_contains(_control(12, 12, stale=StaleFlag.GESTURE))
    assert not return_contains(_control(12, 12, valid=False))
    assert not return_contains(_control(50, 50))
    assert not dwell.update(True, 100)
    assert not dwell.update(True, 100 + RETURN_DWELL_NS - 1)
    assert dwell.update(True, 100 + RETURN_DWELL_NS)
    assert not dwell.update(True, 100 + RETURN_DWELL_NS + 1)
    assert not dwell.update(False, 100 + RETURN_DWELL_NS + 2)
    assert not dwell.update(True, 100 + RETURN_DWELL_NS + 3)


def test_scene_button_is_fixed_size_idempotent_and_visible_without_new_assets() -> None:
    assets = create_menu_assets()
    compiler = SceneCompiler(sprite_atlas=assets.sprite_atlas,
                             tile_atlas=assets.tile_atlas, palettes=assets.palettes)
    frame = compiler.compile(build_menu_scene(1, (), animate=False))
    original = frame.header.to_bytes() + pack_command_bank(frame.commands)
    patched = add_return_to_scene_packet(original)
    assert len(patched) == len(original) == 64 + COMMAND_CAPACITY * 32
    assert add_return_to_scene_packet(patched) == patched
    assert struct.unpack_from("<I", patched, 16)[0] == len(frame.commands) + len(RETURN_COMMANDS)
    drawn = replace(frame, commands=frame.commands[:-1] + RETURN_COMMANDS + (GpuCommand.end_frame(),))
    pixels = CommandRenderer().render(drawn)
    def rgb(x: int, y: int) -> bytes:
        return pixels[(y * 320 + x) * 3:(y * 320 + x + 1) * 3]
    assert rgb(12, 0) == bytes(SYSTEM_COLORS[5])
    assert rgb(12, 12) == bytes(SYSTEM_COLORS[10])
    assert rgb(25, 12) != bytes(SYSTEM_COLORS[5])
    with pytest.raises(ValueError, match="no room"):
        full = bytearray(original)
        struct.pack_into("<I", full, 16, COMMAND_CAPACITY)
        add_return_to_scene_packet(bytes(full))


def test_video_palette_reuses_reserved_bank_and_valid_crc() -> None:
    palette = ((0, 0, 0),) * 16
    packet = build_palette_packet((palette,) * 15, generation=11)
    patched = add_return_to_video_palette(packet)
    header, payload = unpack_resource_packet(patched)
    assert header.generation == 11 and len(patched) == len(packet)
    assert struct.unpack_from("<I", payload, (15 * 16 + 5) * 4)[0] == 0x26C4D6
    assert payload[:15 * 16 * 4] == unpack_resource_packet(packet)[1][:15 * 16 * 4]


def test_peek_latest_menu_point_preserves_pending_fist_event() -> None:
    provider = VisionInputProvider(fist_enabled=True, clock=lambda: 1.0)
    for frame, stable, label, action in ((1, "5", "PAPER", False), (2, "0", "ROCK", True)):
        provider.publish({"run_id": "peek", "server_age_ms": 0,
                          "stable": stable, "rps": label,
                          "control": {"schema": "gesture-control-v1", "frame_id": frame,
                                      "action_event_seq": int(action), "valid": True,
                                      "direction": "IDLE", "smooth_uv": [-0.925, -0.866],
                                      "action_event": action,
                                      "action_kind": "HEURISTIC_OPEN_TO_FIST"}})
    assert provider.peek_menu_control().hand_valid
    assert provider.peek_menu_control().fist_event is False
    assert provider.sample_menu_control(tick_id=1).fist_event is True


@pytest.mark.parametrize("game_id", ("game1", "game2", "game3"))
def test_bundled_games_keep_gpu_command_headroom_with_return_button(tmp_path: Path, game_id: str) -> None:
    root = Path(__file__).resolve().parents[1]
    package = GamePackageBuilder().build(root / "games" / game_id, tmp_path / f"{game_id}.vvg")
    runner = GameRunner(package.path, render_rgb=False)
    try:
        for tick in range(61):
            frame = runner.step(GameInput(tick_id=tick, timestamp_ns=tick * 16_666_667,
                                          hand_valid=tick % 3 != 0, hand_x=0, hand_y=0,
                                          fist_sequence=0, fist_event=False))
            decorated = add_return_to_game_frame(frame)
            assert decorated.command_count <= COMMAND_CAPACITY
            assert decorated.command_count == frame.command_count + len(RETURN_COMMANDS)
            assert decorated.predicted_cycles > frame.predicted_cycles
    finally:
        runner.close()
