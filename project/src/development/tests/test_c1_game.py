from __future__ import annotations

from pynq_multimodal_game.agent.c1_game import C1GameRuntime
from pynq_multimodal_game.controls import (
    ControlSource,
    ControlState,
    Direction,
)


class _Sink:
    def __init__(self) -> None:
        self.palettes = 0
        self.assets = 0
        self.tilemaps = 0
        self.scenes = 0

    def upload_palette(self, _packet: bytes) -> None:
        self.palettes += 1

    def upload_asset(self, _packet: bytes) -> None:
        self.assets += 1

    def upload_tilemap(self, _packet: bytes) -> None:
        self.tilemaps += 1

    def submit_scene(self, _packet: bytes) -> None:
        self.scenes += 1


def _control(tick_id: int, direction: Direction) -> ControlState:
    return ControlState(
        tick_id=tick_id,
        timestamp_ns=tick_id,
        gesture_source=ControlSource.BUTTON,
        gesture_seq=0,
        hand_valid=True,
        hand_x=0.0,
        hand_y=0.0,
        direction=direction,
        fist_score=0.0,
        fist_event=False,
        voice_source=ControlSource.BUTTON,
        voice_seq=0,
        audio_valid=True,
        low_voice_active=False,
        high_voice_event=False,
        low_confidence=0.0,
        high_confidence=0.0,
    )


def test_game_uploads_resources_once_and_normalizes_control_ticks() -> None:
    sink = _Sink()
    runtime = C1GameRuntime(sink)

    assert runtime.start().tick_id == 0
    assert (sink.assets, sink.palettes, sink.tilemaps, sink.scenes) == (1, 1, 1, 1)
    first = runtime.update(_control(41, Direction.RIGHT))
    second = runtime.update(_control(99, Direction.RIGHT))

    assert first.tick_id == 1
    assert second.tick_id == 2
    assert second.world_x > first.world_x
    assert sink.scenes == 3
    runtime.stop()
    assert runtime.running is False