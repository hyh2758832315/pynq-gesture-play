from __future__ import annotations

from dataclasses import dataclass
import hashlib
import importlib
import multiprocessing
from multiprocessing.connection import Connection
from pathlib import Path
from queue import Empty
import sys
import time
from tempfile import TemporaryDirectory
from typing import Any
from uuid import uuid4

from .game_actions import valid_identity
from .game_package import GamePackageInfo, extract_game_package
from .game_sdk import GameContext, GameInput, GamePlugin, GameSnapshot
from .gpu_abi import (
    pack_asset_bundle_packet,
    pack_command_bank,
    pack_palette_packet,
    pack_tilemap_packet,
)
from .renderer import GoldenRenderer
from .scene import LOGICAL_HEIGHT, LOGICAL_WIDTH, TileDescriptor, TileLayer
from .scene_compiler import SceneCompiler


@dataclass(frozen=True)
class GameFrame:
    snapshot: GameSnapshot
    rgb: bytes
    frame_crc32: int
    command_count: int
    predicted_cycles: int
    scene_sha256: str
    scene_packet: bytes
    asset_packet: bytes | None = None
    palette_packet: bytes | None = None
    tilemap_packet: bytes | None = None


class GameRunner:
    def __init__(
        self,
        package_path: Path,
        *,
        seed: int = 0,
        generation: int = 0xC6B00001,
        submit_base: int = 0xC6B00000,
        render_rgb: bool = True,
        require_extension: bool = True,
        game_run: str | None = None,
    ) -> None:
        self.game_run = uuid4().hex if game_run is None else game_run
        if not valid_identity(self.game_run):
            raise ValueError("invalid game run identity")
        self._temporary = TemporaryDirectory(prefix="voice-view-game-")
        root = Path(self._temporary.name)
        self.package = extract_game_package(
            package_path, root, require_extension=require_extension
        )
        module_name, factory_name = self.package.manifest.entrypoint.split(":", 1)
        self._entrypoint_module_prefix = module_name.split(".", 1)[0]
        self._shadowed_modules = {
            name: module
            for name, module in sys.modules.items()
            if name == self._entrypoint_module_prefix
            or name.startswith(f"{self._entrypoint_module_prefix}.")
        }
        for name in self._shadowed_modules:
            sys.modules.pop(name, None)
        self._module_names_before = set(sys.modules)
        sys.path.insert(0, str(root))
        try:
            module = importlib.import_module(module_name)
            factory = getattr(module, factory_name)
            plugin = factory()
        except BaseException:
            self.close()
            raise
        if not isinstance(plugin, GamePlugin):
            self.close()
            raise TypeError("game entrypoint did not return a GamePlugin")
        self._plugin = plugin
        assets = plugin.assets()
        self._renderer = (
            GoldenRenderer(
                sprite_atlas=assets.sprite_atlas,
                tile_atlas=assets.tile_atlas,
                palettes=assets.palettes,
            )
            if render_rgb
            else None
        )
        self._compiler = SceneCompiler(
            sprite_atlas=assets.sprite_atlas,
            tile_atlas=assets.tile_atlas,
            palettes=assets.palettes,
        )
        self._context = GameContext(
            seed=seed, tick_hz=self.package.manifest.tick_hz
        )
        self._plugin.reset(self._context)
        self._generation = generation
        self._submit_base = submit_base
        self._resource_packets: tuple[bytes, bytes, bytes] | None = None
        self._asset_packet_key = None
        self._asset_packet = b""
        self._palette_packet_key = None
        self._palette_packet = b""
        self._tilemap_packet_key = None
        self._tilemap_packet = b""
        self._closed = False

    def step(self, game_input: GameInput) -> GameFrame:
        if self._closed:
            raise RuntimeError("game runner is closed")
        contract = self.package.manifest.inputs
        frame = game_input.actions
        if contract is None:
            if frame is not None:
                raise ValueError("legacy game does not declare an action contract")
        elif frame is None or (
            frame.game_id != self.package.manifest.game_id or frame.game_run != self.game_run
            or frame.policy_id != contract.policy_id or frame.schema != contract.actions_schema
            or frame.sample_tick != game_input.tick_id or frame.sample_timestamp_ns != game_input.timestamp_ns
        ):
            raise ValueError("game action contract or run binding mismatch")
        snapshot = self._plugin.step(game_input)
        scene = self._plugin.build_scene()
        if snapshot != self._plugin.snapshot():
            raise RuntimeError("game plugin returned an inconsistent snapshot")
        compiled = self._compiler.compile(
            scene,
            submit_seq=(self._submit_base + game_input.tick_id) & 0xFFFFFFFF,
            palette_generation=self._generation,
            asset_generation=self._generation,
            tilemap_generation=self._generation,
        )
        rgb = b"" if self._renderer is None else self._renderer.render(scene)
        commands = pack_command_bank(compiled.commands)
        scene_packet = compiled.header.to_bytes() + commands
        tilemap = (
            compiled.tilemaps[0]
            if compiled.tilemaps
            else TileLayer(2, 1, (TileDescriptor(0), TileDescriptor(0)))
        )
        asset_packet_key = (compiled.assets, self._generation)
        immutable_assets = all(type(asset.pixels) is bytes for asset in compiled.assets)
        if not immutable_assets or self._asset_packet_key != asset_packet_key:
            self._asset_packet = pack_asset_bundle_packet(
                compiled.assets, generation=self._generation
            )
            self._asset_packet_key = asset_packet_key if immutable_assets else None
        asset_packet = self._asset_packet
        palette_packet_key = (compiled.palette_banks, self._generation)
        immutable_palettes = type(compiled.palette_banks) is tuple and all(
            type(bank) is tuple and all(type(color) is tuple for color in bank)
            for bank in compiled.palette_banks
        )
        if not immutable_palettes or self._palette_packet_key != palette_packet_key:
            self._palette_packet = pack_palette_packet(
                compiled.palette_banks, generation=self._generation
            )
            self._palette_packet_key = palette_packet_key if immutable_palettes else None
        palette_packet = self._palette_packet
        tilemap_packet_key = (tilemap, self._generation)
        immutable_tilemap = type(tilemap.tiles) is tuple
        if not immutable_tilemap or self._tilemap_packet_key != tilemap_packet_key:
            self._tilemap_packet = pack_tilemap_packet(
                tilemap, target_id=0, generation=self._generation
            )
            self._tilemap_packet_key = tilemap_packet_key if immutable_tilemap else None
        tilemap_packet = self._tilemap_packet
        resources = (asset_packet, palette_packet, tilemap_packet)
        changed = tuple(self._resource_packets is None or packet != self._resource_packets[index]
                        for index, packet in enumerate(resources))
        self._resource_packets = resources
        return GameFrame(
            snapshot=snapshot,
            rgb=rgb,
            frame_crc32=0 if self._renderer is None else self._renderer.crc32(rgb),
            command_count=compiled.header.command_count,
            predicted_cycles=compiled.header.predicted_cycles,
            scene_sha256=hashlib.sha256(scene_packet).hexdigest(),
            scene_packet=scene_packet,
            asset_packet=asset_packet if changed[0] else None,
            palette_packet=palette_packet if changed[1] else None,
            tilemap_packet=tilemap_packet if changed[2] else None,
        )

    def close(self) -> None:
        if getattr(self, "_closed", False):
            return
        plugin = getattr(self, "_plugin", None)
        if plugin is not None:
            plugin.close()
        root = getattr(self, "_temporary", None)
        root_path = root.name if root is not None else None
        if root_path in sys.path:
            sys.path.remove(root_path)
        previous = getattr(self, "_module_names_before", set())
        for name in tuple(set(sys.modules) - previous):
            module = sys.modules.get(name)
            module_file = getattr(module, "__file__", None)
            if root_path and module_file and Path(module_file).is_relative_to(root_path):
                sys.modules.pop(name, None)
        prefix = getattr(self, "_entrypoint_module_prefix", None)
        if prefix:
            for name in tuple(sys.modules):
                if name == prefix or name.startswith(f"{prefix}."):
                    sys.modules.pop(name, None)
        sys.modules.update(getattr(self, "_shadowed_modules", {}))
        if root is not None:
            root.cleanup()
        self._closed = True

    def __enter__(self) -> GameRunner:
        return self

    def __exit__(self, *_args: object) -> None:
        self.close()


class GamePreviewProcess:
    def __init__(
        self,
        package_path: Path,
        *,
        seed: int = 0,
        generation: int = 0xC6B00001,
        submit_base: int = 0xC6B00000,
        render_rgb: bool = True,
        require_extension: bool = True,
        game_run: str | None = None,
    ) -> None:
        context = multiprocessing.get_context("spawn")
        self._channel, self._worker_channel = context.Pipe()
        self.last_step_timing = None
        self._request_timing = None
        self._process = context.Process(
            target=_preview_worker,
            args=(
                str(package_path),
                seed,
                generation,
                submit_base,
                render_rgb,
                require_extension,
                game_run,
                self._worker_channel,
            ),
            daemon=True,
        )

    def start(self, *, timeout: float = 10.0) -> GamePackageInfo:
        self._process.start()
        self._worker_channel.close()
        kind, payload = self._receive(timeout)
        if kind == "error":
            self.stop()
            raise RuntimeError(payload)
        if kind != "ready":
            self.stop()
            raise RuntimeError("preview worker returned an unexpected response")
        return payload

    def _receive(self, timeout: float):
        if not self._channel.poll(timeout):
            raise Empty
        return self._channel.recv()

    def step(self, game_input: GameInput, *, timeout: float = 5.0) -> GameFrame:
        self.begin_step(game_input)
        return self.finish_step(timeout=timeout)

    def begin_step(self, game_input: GameInput) -> None:
        if not self._process.is_alive():
            raise RuntimeError("preview worker is not running")
        if self._request_timing is not None:
            raise RuntimeError("preview step is already pending")
        self.last_step_timing = None
        request_started_ns = time.monotonic_ns()
        caller_cpu_started_ns = time.thread_time_ns()
        self._channel.send(("step", game_input))
        self._request_timing = request_started_ns, caller_cpu_started_ns

    def finish_step(self, *, timeout: float = 5.0) -> GameFrame:
        if self._request_timing is None:
            raise RuntimeError("preview step is not pending")
        request_started_ns, caller_cpu_started_ns = self._request_timing
        kind, payload = self._receive(timeout)
        self._request_timing = None
        response_received_ns = time.monotonic_ns()
        if kind == "error":
            raise RuntimeError(payload)
        if kind != "frame":
            raise RuntimeError("preview worker returned an unexpected response")
        frame, timing = payload
        self.last_step_timing = {
            **timing, "request_started_ns": request_started_ns,
            "response_received_ns": response_received_ns,
            "request_wall_ns": response_received_ns - request_started_ns,
            "caller_cpu_ns": time.thread_time_ns() - caller_cpu_started_ns,
        }
        return frame

    def stop(self) -> None:
        if self._request_timing is not None:
            try:
                self.finish_step(timeout=2.0)
            except (Empty, RuntimeError, EOFError, OSError):
                pass
        if self._process.is_alive():
            try:
                self._channel.send(("stop", None))
            except (BrokenPipeError, EOFError, OSError):
                pass
            self._process.join(2.0)
        if self._process.is_alive():
            self._process.terminate()
            self._process.join(2.0)
        self._channel.close()
        self._worker_channel.close()
        self._request_timing = None


def _preview_worker(
    package_path: str,
    seed: int,
    generation: int,
    submit_base: int,
    render_rgb: bool,
    require_extension: bool,
    game_run: str | None,
    channel: Connection,
) -> None:
    try:
        with GameRunner(
            Path(package_path),
            seed=seed,
            generation=generation,
            submit_base=submit_base,
            render_rgb=render_rgb,
            require_extension=require_extension,
            game_run=game_run,
        ) as runner:
            channel.send(("ready", runner.package))
            while True:
                kind, payload = channel.recv()
                if kind == "stop":
                    return
                if kind != "step" or not isinstance(payload, GameInput):
                    raise ValueError("preview worker received an invalid command")
                worker_started_ns = time.monotonic_ns()
                worker_cpu_started_ns = time.thread_time_ns()
                frame = runner.step(payload)
                worker_finished_ns = time.monotonic_ns()
                channel.send(("frame", (frame, {
                    "worker_started_ns": worker_started_ns,
                    "worker_finished_ns": worker_finished_ns,
                    "worker_wall_ns": worker_finished_ns - worker_started_ns,
                    "worker_cpu_ns": time.thread_time_ns() - worker_cpu_started_ns,
                })))
    except BaseException as error:
        try:
            channel.send(("error", f"{type(error).__name__}: {error}"))
        except (BrokenPipeError, EOFError, OSError):
            pass
    finally:
        channel.close()
