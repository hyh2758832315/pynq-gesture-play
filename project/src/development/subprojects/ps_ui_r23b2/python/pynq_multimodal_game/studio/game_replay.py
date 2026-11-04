from __future__ import annotations

from collections.abc import Sequence
from dataclasses import dataclass
from pathlib import Path

from ..controls import ControlState
from ..demo import build_demo_scene, create_demo_assets, create_demo_engine
from ..game import GameState, GameStatus
from ..replay import build_demo_controls, load_control_jsonl
from ..scene_compiler import SceneCompiler


@dataclass(frozen=True)
class ReplayFrame:
    position: int
    total: int
    tick_id: int
    status: GameStatus
    score: int
    health: int
    command_count: int
    predicted_cycles: int
    frame_crc32: int
    rgb: bytes


class DemoReplaySession:
    def __init__(self, controls: Sequence[ControlState] | None = None) -> None:
        self._controls = tuple(controls) if controls is not None else build_demo_controls()
        if not self._controls:
            raise ValueError("replay requires at least one control state")
        self._assets = create_demo_assets()
        self._engine = create_demo_engine()
        self._compiler = SceneCompiler(
            sprite_atlas=self._assets.renderer.sprite_atlas,
            tile_atlas=self._assets.renderer.tile_atlas,
            palettes=self._assets.renderer.palettes,
        )
        self._state = self._engine.initial_state()
        self._position = 0
        self._current_frame: ReplayFrame | None = None

    @classmethod
    def from_control_file(cls, path: str | Path) -> DemoReplaySession:
        return cls(load_control_jsonl(path))

    @property
    def position(self) -> int:
        return self._position

    @property
    def total(self) -> int:
        return len(self._controls)

    @property
    def state(self) -> GameState:
        return self._state

    @property
    def current_frame(self) -> ReplayFrame | None:
        return self._current_frame

    @property
    def finished(self) -> bool:
        return self._position >= len(self._controls)

    def reset(self) -> None:
        self._state = self._engine.initial_state()
        self._position = 0
        self._current_frame = None

    def step(self) -> ReplayFrame | None:
        if self.finished:
            return None
        self._state = self._engine.step(
            self._state,
            self._controls[self._position],
        )
        scene = build_demo_scene(self._state, self._engine.config, self._assets)
        compiled = self._compiler.compile(scene)
        rgb = self._assets.renderer.render(scene)
        self._position += 1
        self._current_frame = ReplayFrame(
            position=self._position,
            total=len(self._controls),
            tick_id=self._state.tick_id,
            status=self._state.status,
            score=self._state.score,
            health=self._state.health,
            command_count=compiled.header.command_count,
            predicted_cycles=compiled.header.predicted_cycles,
            frame_crc32=self._assets.renderer.crc32(rgb),
            rgb=rgb,
        )
        return self._current_frame

    def run_to_end(self) -> ReplayFrame:
        while not self.finished:
            self.step()
        if self._current_frame is None:
            raise RuntimeError("replay did not produce a frame")
        return self._current_frame