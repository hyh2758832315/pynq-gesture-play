from __future__ import annotations

from dataclasses import replace
from typing import Protocol

from ..controls import ControlState
from ..demo import build_demo_scene, create_demo_assets, create_demo_engine
from ..game import GameState
from ..gpu_abi import (
    pack_asset_bundle_packet,
    pack_command_bank,
    pack_palette_packet,
    pack_tilemap_packet,
)
from ..scene_compiler import SceneCompiler


class GameSink(Protocol):
    def upload_palette(self, packet: bytes) -> None: ...

    def upload_asset(self, packet: bytes) -> None: ...

    def upload_tilemap(self, packet: bytes) -> None: ...

    def submit_scene(self, packet: bytes) -> None: ...


class C1GameRuntime:
    def __init__(self, sink: GameSink, *, generation: int = 0xC6A20001) -> None:
        self._sink = sink
        self._generation = generation
        self._assets = create_demo_assets()
        self._engine = create_demo_engine()
        self._compiler = SceneCompiler(
            sprite_atlas=self._assets.renderer.sprite_atlas,
            tile_atlas=self._assets.renderer.tile_atlas,
            palettes=self._assets.renderer.palettes,
        )
        self._state = self._engine.initial_state()
        self._running = False

    @property
    def running(self) -> bool:
        return self._running

    @property
    def state(self) -> GameState:
        return self._state

    def start(self) -> GameState:
        self._state = replace(self._engine.initial_state(), tick_id=0)
        frame = self._compile_frame(submit_seq=0xC6A20000)
        if len(frame.tilemaps) != 1:
            raise RuntimeError("C1 scene must compile one tilemap")
        self._sink.upload_asset(
            pack_asset_bundle_packet(frame.assets, generation=self._generation)
        )
        self._sink.upload_palette(
            pack_palette_packet(frame.palette_banks, generation=self._generation)
        )
        self._sink.upload_tilemap(
            pack_tilemap_packet(
                frame.tilemaps[0], target_id=0, generation=self._generation
            )
        )
        self._submit(frame)
        self._running = True
        return self._state

    def update(self, control: ControlState) -> GameState:
        if not self._running:
            raise RuntimeError("C1 game is not running")
        local_control = replace(control, tick_id=self._state.tick_id + 1)
        self._state = self._engine.step(self._state, local_control)
        self._submit(self._compile_frame(submit_seq=0xC6A20001 + self._state.tick_id))
        return self._state

    def stop(self) -> None:
        self._running = False

    def _compile_frame(self, *, submit_seq: int):  # type: ignore[no-untyped-def]
        scene = build_demo_scene(self._state, self._engine.config, self._assets)
        return self._compiler.compile(
            scene,
            submit_seq=submit_seq,
            palette_generation=self._generation,
            asset_generation=self._generation,
            tilemap_generation=self._generation,
        )

    def _submit(self, frame) -> None:  # type: ignore[no-untyped-def]
        self._sink.submit_scene(
            frame.header.to_bytes() + pack_command_bank(frame.commands)
        )