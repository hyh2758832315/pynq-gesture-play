from __future__ import annotations

from dataclasses import replace
from enum import Enum
from pathlib import Path
import threading
import time
from typing import Any, Callable, Protocol

from ..controls import ControlState
from ..game_package import validate_game_package
from ..game_testing import GameTestCase
from ..gpu_abi import (
    pack_asset_bundle_packet,
    pack_command_bank,
    pack_palette_packet,
    pack_tilemap_packet,
)
from ..library import AssetLibrary, LibraryEntry, LibraryKind
from ..menu import (
    HOME_TARGETS,
    MenuIcon,
    MenuInputController,
    MenuPage,
    MenuTarget,
    build_menu_scene,
    create_menu_assets,
    game_targets,
    hand_display_selection,
    hand_display_targets,
    library_targets,
    placeholder_targets,
)
from ..scene_compiler import SceneCompiler
from ..scene import TileDescriptor, TileLayer
from ..return_button import (
    ReturnDwell, add_return_to_game_frame, add_return_to_scene_packet, add_return_to_video_palette,
    return_contains,
)
from ..startup_ui import StartupRenderer, StartupSequence, StartupSnapshot
from .c6i_backend import C6IOverlaySession
from .c6i_video import C6IVideoSink
from .core import AgentState, ArtifactManifest, LibraryItemSnapshot, RuntimeSnapshot
from .game_runtime import LiveGameInput, PackagedGameRuntime
from .video_runtime import C6IVideoRuntimeBackend


class ShellMode(str, Enum):
    MENU = "menu"
    GAME = "game"
    VIDEO = "video"
    HAND_PLACEHOLDER = "hand-placeholder"
    RESERVED = "reserved"


class _ShellSink(Protocol):
    def upload_palette(self, packet: bytes) -> None: ...

    def upload_asset(self, packet: bytes) -> None: ...

    def upload_tilemap(self, packet: bytes) -> None: ...

    def submit_scene(self, packet: bytes) -> None: ...

    def close(self) -> None: ...


ShellSinkFactory = Callable[[C6IOverlaySession, float], _ShellSink]
_MENU_TILEMAP = TileLayer(2, 1, (TileDescriptor(0), TileDescriptor(0)))


class _BorrowedSink:
    def __init__(self, sink: _ShellSink, *, return_button: bool = False,
                 video_palette: bool = False) -> None:
        self._sink = sink
        self._return_button = return_button
        self._video_palette = video_palette

    @property
    def upload_render_overlap_enabled(self) -> bool:
        return getattr(self._sink, "upload_render_overlap_enabled", False) is True

    def __getattr__(self, name: str) -> Any:
        if name == "enqueue_scene":
            enqueue = getattr(self._sink, name)
            return (lambda packet: enqueue(add_return_to_scene_packet(packet))) if self._return_button else enqueue
        if name in ("enqueue_scene", "wait_scene", "drain"):
            return getattr(self._sink, name)
        raise AttributeError(name)

    def upload_palette(self, packet: bytes) -> None:
        self._sink.upload_palette(add_return_to_video_palette(packet) if self._video_palette else packet)

    def upload_asset(self, packet: bytes) -> None:
        self._sink.upload_asset(packet)

    def upload_tilemap(self, packet: bytes) -> None:
        self._sink.upload_tilemap(packet)

    def submit_scene(self, packet: bytes) -> None:
        self._sink.submit_scene(add_return_to_scene_packet(packet) if self._return_button else packet)

    def close(self) -> None:
        pass


class C6IShellRuntimeBackend:
    def __init__(
        self,
        session: C6IOverlaySession,
        *,
        timeout_seconds: float = 2.0,
        menu_fps: float = 30.0,
        startup_settle_seconds: float = 0.0,
        library: AssetLibrary | None = None,
        sink_factory: ShellSinkFactory | None = None,
        upload_render_overlap: bool | None = None,
        live_input: LiveGameInput | None = None,
        startup_vision: Callable[[], object] | None = None,
        startup_hand: Callable[[], object] | None = None,
    ) -> None:
        if timeout_seconds <= 0:
            raise ValueError("timeout_seconds must be positive")
        if menu_fps < 0:
            raise ValueError("menu_fps must be non-negative")
        if startup_settle_seconds < 0:
            raise ValueError("startup_settle_seconds must be non-negative")
        if (startup_vision is None) != (startup_hand is None):
            raise ValueError("startup vision and hand checks must be supplied together")
        self._session = session
        self._timeout_seconds = timeout_seconds
        self._menu_fps = menu_fps
        self._startup_settle_seconds = startup_settle_seconds
        self._library = library
        self._upload_render_overlap = upload_render_overlap
        self._live_input = live_input
        self._startup_vision = startup_vision
        self._startup_hand = startup_hand
        self._startup_snapshot: StartupSnapshot | None = None
        self._sink_factory = sink_factory or self._create_sink
        self._sink: _ShellSink | None = None
        self._menu_assets = create_menu_assets()
        self._menu_compiler = SceneCompiler(
            sprite_atlas=self._menu_assets.sprite_atlas,
            tile_atlas=self._menu_assets.tile_atlas,
            palettes=self._menu_assets.palettes,
        )
        self._input = MenuInputController()
        self._page = MenuPage.HOME
        self._targets: tuple[MenuTarget, ...] = HOME_TARGETS
        self._labels: tuple[str, ...] = ("GAME", "VIDEO", "HAND", "MORE")
        self._mode = ShellMode.MENU
        self._menu_generation = 0xC6A10001
        self._catalog_generation = 0
        self._menu_frame_id = 0
        self._last_error: str | None = None
        self._menu_stop = threading.Event()
        self._menu_thread: threading.Thread | None = None
        self._menu_active = False
        self._return_dwell = ReturnDwell()
        self._return_monitor_stop = threading.Event()
        self._return_monitor_thread: threading.Thread | None = None
        self._lock = threading.RLock()
        self._game_ids: tuple[str, ...] = ()
        self._game_entries: dict[str, LibraryEntry] = {}
        self._video_entries: dict[str, LibraryEntry] = {}
        self._staged_video: tuple[ArtifactManifest, Path] | None = None
        self._staged_game: tuple[ArtifactManifest, Path] | None = None
        self._game: PackagedGameRuntime | None = None
        self._active_game_id: str | None = None
        self._active_test_case_json: str | None = None
        self._video = C6IVideoRuntimeBackend(
            session,
            timeout_seconds=timeout_seconds,
            sink_factory=lambda _session, _timeout: _BorrowedSink(
                self._require_sink(), return_button=True, video_palette=True
            ),
        )

    @property
    def mode(self) -> ShellMode:
        with self._lock:
            return self._mode

    @property
    def page(self) -> MenuPage:
        with self._lock:
            return self._page

    @property
    def snapshot(self) -> RuntimeSnapshot:
        base = self._video.snapshot
        with self._lock:
            if self._mode is ShellMode.VIDEO:
                return replace(
                    base,
                    runtime_mode=self._mode.value,
                    catalog_generation=self._catalog_generation,
                    last_error=self._last_error or base.last_error,
                )
            if self._mode is ShellMode.GAME:
                game = self._game
                error = None if game is None else getattr(game, "last_error", None)
                inputs = game.input_consumptions if isinstance(game, PackagedGameRuntime) else None
                frame = None if inputs is None else inputs["frame"]
                return replace(
                    base,
                    state=(
                        AgentState.ERROR
                        if error
                        else AgentState.PAUSED
                        if isinstance(game, PackagedGameRuntime) and game.paused
                        else AgentState.RUNNING
                    ),
                    runtime_mode=self._mode.value,
                    catalog_generation=self._catalog_generation,
                    presented_frames=(
                        inputs["presented_frames"] if inputs is not None
                        else None if game is None else getattr(game, "presented_frames", None)
                    ),
                    last_error=error or self._last_error,
                    game_tick=None if game is None else getattr(game, "tick_id", None),
                    game_status=None if frame is None else frame.snapshot.status,
                    game_score=None if frame is None else frame.snapshot.score,
                    game_values=None if frame is None else frame.snapshot.values,
                    scene_sha256=None if frame is None else frame.scene_sha256,
                    vision_consumption=None if inputs is None else inputs["vision"],
                    audio_consumption=None if inputs is None else inputs["audio"],
                    volume_consumption=None if inputs is None else inputs["volume"],
                    action_permit=None if not isinstance(game, PackagedGameRuntime) else game.action_permit,
                    command_count=None if frame is None else frame.command_count,
                    predicted_cycles=None if frame is None else frame.predicted_cycles,
                    accepted_input_id=(
                        None if not isinstance(game, PackagedGameRuntime) else game.accepted_input_id
                    ),
                    consumed_input_id=(
                        None if not isinstance(game, PackagedGameRuntime) else game.consumed_input_id
                    ),
                    assertions_passed=(
                        None if not isinstance(game, PackagedGameRuntime) else game.assertions_passed
                    ),
                    assertions_failed=(
                        None if not isinstance(game, PackagedGameRuntime) else game.assertions_failed
                    ),
                    test_complete=(
                        None if not isinstance(game, PackagedGameRuntime) else game.test_complete
                    ),
                    game_test_report=(
                        None if not isinstance(game, PackagedGameRuntime) else game.test_report
                    ),
                )
            if self._staged_game is not None:
                return replace(
                    base,
                    state=AgentState.ERROR if self._last_error else AgentState.STAGED,
                    staged_sha256=self._staged_game[0].sha256,
                    runtime_mode=self._mode.value,
                    catalog_generation=self._catalog_generation,
                    last_error=self._last_error,
                )
            return replace(
                base,
                state=AgentState.ERROR if self._last_error else AgentState.IDLE,
                runtime_mode=self._mode.value,
                catalog_generation=self._catalog_generation,
                last_error=self._last_error,
            )

    def open(self) -> C6IShellRuntimeBackend:
        with self._lock:
            if self._sink is not None:
                return self
            self._session.open()
            self._sink = self._sink_factory(self._session, self._timeout_seconds)
            if self._startup_vision is not None and self._startup_hand is not None:
                self._run_startup_locked()
            else:
                self.refresh_catalog()
            if self._startup_settle_seconds:
                self._menu_stop.wait(self._startup_settle_seconds)
            self._start_menu_locked()
            if callable(getattr(self._live_input, "peek_menu_control", None)):
                self._return_monitor_stop.clear()
                self._return_monitor_thread = threading.Thread(
                    target=self._return_monitor_loop, name="voice-view-return-monitor", daemon=True
                )
                self._return_monitor_thread.start()
            return self

    @property
    def startup_snapshot(self) -> StartupSnapshot | None:
        with self._lock:
            return self._startup_snapshot

    def _run_startup_locked(self) -> None:
        renderer = StartupRenderer()
        generation = 0xC6A20001
        sink = self._require_sink()
        initial = renderer.compile(StartupSnapshot(), frame_id=0, generation=generation)
        self._drain_sink()
        sink.upload_asset(pack_asset_bundle_packet(initial.assets, generation=generation))
        sink.upload_palette(pack_palette_packet(initial.palette_banks, generation=generation))
        sink.upload_tilemap(pack_tilemap_packet(
            _MENU_TILEMAP, target_id=0, generation=generation))
        frame_id = 0

        def publish(snapshot: StartupSnapshot) -> None:
            nonlocal frame_id
            frame = renderer.compile(snapshot, frame_id=frame_id, generation=generation)
            sink.submit_scene(frame.header.to_bytes() + pack_command_bank(frame.commands))
            self._startup_snapshot = snapshot
            frame_id += 1

        def check_library() -> bool:
            self.refresh_catalog()
            return True

        checks = StartupSequence((
            ("GPU", lambda: True),
            ("LIBRARY", check_library),
            ("VISION", self._startup_vision),
            ("HAND", self._startup_hand),
        ))
        checks.run(publish)

    def refresh_catalog(self) -> None:
        games: dict[str, LibraryEntry] = {}
        videos: dict[str, LibraryEntry] = {}
        if self._library is not None:
            game_result = self._library.scan(LibraryKind.GAME)
            for entry in game_result.entries:
                try:
                    package = validate_game_package(
                        entry.asset, require_extension=False
                    )
                    if package.manifest.target_build_id != self._session.build_id:
                        continue
                except (OSError, ValueError):
                    continue
                games[entry.manifest.item_id] = entry
            result = self._library.scan(LibraryKind.VIDEO)
            videos = {entry.manifest.item_id: entry for entry in result.entries}
        with self._lock:
            self._game_entries = games
            self._game_ids = tuple(games)
            self._video_entries = videos
            self._catalog_generation += 1
            self._select_page_locked(self._page)

    def handle_control(self, control: ControlState) -> str | None:
        with self._lock:
            if self._mode is ShellMode.GAME:
                game = self._game
                if game is None:
                    raise RuntimeError("GAME mode has no active runtime")
                game.update(control)
                return None
            if self._mode is ShellMode.VIDEO:
                return None
            interaction = self._input.update(control, self._targets)
            activated = interaction.activated_id
            if activated is None:
                return None
            if activated == "back":
                if self._page is not MenuPage.HOME:
                    self._select_page_locked(MenuPage.HOME)
                return activated
            elif self._page is MenuPage.HOME:
                destinations = {
                    "games": MenuPage.GAMES,
                    "videos": MenuPage.VIDEOS,
                    "hand": MenuPage.HAND_PLACEHOLDER,
                    "reserved": MenuPage.RESERVED,
                }
                self._select_page_locked(destinations[activated])
                return activated
            page = self._page
        if page is MenuPage.GAMES and activated.startswith("game:"):
            self.start_game(activated.removeprefix("game:"))
        elif page is MenuPage.VIDEOS and activated.startswith("video:"):
            self.play_library_video(activated.removeprefix("video:"))
        return activated

    def start_game(self, item_id: str, test_case_json: str | None = None) -> None:
        if item_id not in self._game_ids:
            raise KeyError(f"game {item_id!r} is not installed")
        package = validate_game_package(self._game_entries[item_id].asset, require_extension=False)
        volume = package.manifest.volume_inputs
        if volume is not None and volume.schema not in getattr(self, "supported_volume_schemas", ()):
            raise ValueError("backend does not support declared volume input contract")
        if self.mode in (ShellMode.GAME, ShellMode.VIDEO):
            self.return_to_menu()
        self._stop_menu()
        game = PackagedGameRuntime(
            self._game_entries[item_id].asset,
            _BorrowedSink(self._require_sink()),
            generation=(0xC6B00000 + self._catalog_generation) & 0xFFFFFFFF,
            live_input=self._live_input if test_case_json is None else None,
            scene_transform=add_return_to_game_frame,
        )
        diagnostic = getattr(self, "_diagnostic_startup_stage", None)
        if diagnostic is not None:
            game._diagnostic_startup_stage = diagnostic
        if test_case_json is not None:
            game.load_test_case(GameTestCase.from_json(test_case_json))
        try:
            game.start()
        except BaseException as error:
            with self._lock:
                self._last_error = f"{type(error).__name__}: {error}"
            try:
                game.stop()
            except BaseException as cleanup_error:
                with self._lock:
                    self._game = game
                    self._last_error += f"; game cleanup failed: {type(cleanup_error).__name__}: {cleanup_error}"
                raise error from cleanup_error
            try:
                self._resume_menu()
            except BaseException as recovery_error:
                with self._lock:
                    self._last_error += f"; menu recovery failed: {type(recovery_error).__name__}: {recovery_error}"
                raise error from recovery_error
            raise
        with self._lock:
            self._last_error = None
            self._game = game
            self._active_game_id = item_id
            self._active_test_case_json = test_case_json
            self._mode = ShellMode.GAME

    def play_library_video(self, item_id: str) -> RuntimeSnapshot:
        self.stage_library_video(item_id)
        self.activate()
        return self.run()

    def run_library_item(
        self,
        item_id: str | None,
        library_kind: str | None,
        *,
        test_case_json: str | None = None,
    ) -> RuntimeSnapshot:
        if not isinstance(item_id, str) or library_kind is None:
            raise ValueError("library run requires item_id and library_kind")
        kind = LibraryKind(library_kind)
        if kind is LibraryKind.VIDEO:
            return self.play_library_video(item_id)
        if kind is LibraryKind.GAME:
            self.start_game(item_id, test_case_json)
            return self.snapshot
        raise ValueError("image playback is not implemented")

    def return_to_menu(self) -> RuntimeSnapshot:
        with self._lock:
            mode = self._mode
            game = self._game
        if mode is ShellMode.VIDEO:
            self._video.stop()
        elif mode is ShellMode.GAME and game is not None:
            game.stop()
        with self._lock:
            self._game = None
            self._active_game_id = None
            self._active_test_case_json = None
        self._resume_menu()
        return self.snapshot

    def initialize_shell(self) -> RuntimeSnapshot:
        self.return_to_menu()
        self.refresh_catalog()
        return self.snapshot

    @property
    def input_schema_version(self) -> int:
        return 2

    @property
    def supported_action_schemas(self):
        return ("game-actions-v1",)

    @property
    def test_case_schema_versions(self):
        return (1, 2, 3)

    def inject_test_input(
        self,
        *,
        x: int | None,
        y: int | None,
        fist: bool | None,
        frequency_hz: float | None,
        duration_ms: int | None,
        input_id: str | None,
        gesture: str | None = None,
    ) -> RuntimeSnapshot:
        with self._lock:
            game = self._game
        if not isinstance(game, PackagedGameRuntime):
            raise RuntimeError("test input injection requires a packaged game")
        game.inject_test_input(
            x=x,
            y=y,
            fist=bool(fist),
            frequency_hz=frequency_hz,
            duration_ms=duration_ms,
            input_id=input_id,
            gesture=gesture,
        )
        return self.snapshot

    def cancel_test_input(self) -> RuntimeSnapshot:
        with self._lock:
            game = self._game
        if not isinstance(game, PackagedGameRuntime):
            raise RuntimeError("test input cancellation requires a packaged game")
        game.cancel_test_input()
        return self.snapshot

    def pause_game(self) -> RuntimeSnapshot:
        game = self._require_packaged_game()
        game.pause()
        return self.snapshot

    def resume_game(self) -> RuntimeSnapshot:
        game = self._require_packaged_game()
        game.resume()
        return self.snapshot

    def step_game(self) -> RuntimeSnapshot:
        game = self._require_packaged_game()
        game.step_once()
        return self.snapshot

    def reset_game(self) -> RuntimeSnapshot:
        with self._lock:
            item_id = self._active_game_id
            test_case_json = self._active_test_case_json
        if item_id is None:
            raise RuntimeError("no packaged game is active")
        self.return_to_menu()
        self.start_game(item_id, test_case_json)
        return self.snapshot

    def _require_packaged_game(self) -> PackagedGameRuntime:
        with self._lock:
            game = self._game
        if not isinstance(game, PackagedGameRuntime):
            raise RuntimeError("game debug control requires a packaged game")
        return game

    def stage(self, manifest: ArtifactManifest, payload: bytes) -> RuntimeSnapshot:
        if manifest.artifact_kind == "game.vvg":
            raise ValueError("game.vvg staging requires the chunked file upload path")
        return self._video.stage(manifest, payload)

    def stage_file(self, manifest: ArtifactManifest, path: Path) -> RuntimeSnapshot:
        if manifest.artifact_kind == "game.vvg":
            package = validate_game_package(path, require_extension=False)
            volume = package.manifest.volume_inputs
            if volume is not None and volume.schema not in getattr(self, "supported_volume_schemas", ()):
                raise ValueError("backend does not support declared volume input contract")
            if package.manifest.target_build_id != self._session.build_id:
                raise ValueError("game package BUILD_ID mismatch")
            if (package.manifest.abi_major, package.manifest.abi_minor) != (
                manifest.abi_major,
                manifest.abi_minor,
            ):
                raise ValueError("game package ABI mismatch")
            self._staged_game = (manifest, Path(path))
            return self.snapshot
        snapshot = self._video.stage_file(manifest, path)
        self._staged_video = (manifest, Path(path))
        return snapshot

    def install_staged_library_item(
        self,
        item_id: str | None,
        display_name: str | None,
        library_kind: str | None,
    ) -> LibraryItemSnapshot:
        if self._library is None:
            raise RuntimeError("persistent library is not configured")
        if library_kind not in (LibraryKind.VIDEO.value, LibraryKind.GAME.value):
            raise ValueError("library installation supports game or video artifacts")
        if not isinstance(item_id, str) or not isinstance(display_name, str):
            raise ValueError("library install requires item_id and display_name")
        kind = LibraryKind(library_kind)
        staged = self._staged_video if kind is LibraryKind.VIDEO else self._staged_game
        if staged is None:
            raise RuntimeError(f"no staged {kind.value} is available to install")
        manifest, path = staged
        existing = {
            entry.manifest.item_id: entry
            for entry in self._library.scan(kind).entries
        }.get(item_id)
        if existing is not None:
            if existing.manifest.sha256 == manifest.sha256:
                return self._entry_snapshot(existing)
        entry = self._library.install_file(
            path,
            item_id=item_id,
            display_name=display_name,
            kind=kind,
            target_build_id=manifest.target_build_id,
            abi_major=manifest.abi_major,
            abi_minor=manifest.abi_minor,
            replace=existing is not None,
        )
        if kind is LibraryKind.GAME:
            self._staged_game = None
        self.refresh_catalog()
        return self._entry_snapshot(entry)

    def list_library_items(
        self, library_kind: str | None
    ) -> tuple[LibraryItemSnapshot, ...]:
        if self._library is None:
            raise RuntimeError("persistent library is not configured")
        kind = None if library_kind is None else LibraryKind(library_kind)
        result = self._library.scan(kind)
        return tuple(self._entry_snapshot(entry) for entry in result.entries)

    def remove_library_item(
        self, item_id: str | None, library_kind: str | None
    ) -> None:
        if self._library is None:
            raise RuntimeError("persistent library is not configured")
        if not isinstance(item_id, str) or library_kind is None:
            raise ValueError("library remove requires item_id and library_kind")
        self._library.remove(LibraryKind(library_kind), item_id)
        self.refresh_catalog()

    def stage_library_video(self, item_id: str) -> RuntimeSnapshot:
        with self._lock:
            try:
                entry = self._video_entries[item_id]
            except KeyError as error:
                raise KeyError(f"video {item_id!r} is not installed") from error
        manifest = entry.manifest
        artifact = ArtifactManifest(
            artifact_kind="video.s2v",
            sha256=manifest.sha256,
            target_build_id=manifest.target_build_id,
            abi_major=manifest.abi_major,
            abi_minor=manifest.abi_minor,
            length=manifest.length,
        )
        return self._video.stage_file(artifact, entry.asset)

    def activate(self) -> RuntimeSnapshot:
        return self._video.activate()

    def run(self) -> RuntimeSnapshot:
        if self.mode is ShellMode.GAME:
            self.return_to_menu()
        self._stop_menu()
        with self._lock:
            self._mode = ShellMode.VIDEO
        try:
            return self.snapshot if self._video.run().state is AgentState.RUNNING else self.snapshot
        except BaseException:
            self._resume_menu()
            raise

    def pause(self) -> RuntimeSnapshot:
        return self._video.pause()

    def seek(self, frame_index: int) -> RuntimeSnapshot:
        return self._video.seek(frame_index)

    def stop(self) -> RuntimeSnapshot:
        return self.return_to_menu()

    def close(self) -> None:
        first_error: BaseException | None = None
        self._return_monitor_stop.set()
        monitor = self._return_monitor_thread
        if monitor is not None and monitor is not threading.current_thread():
            monitor.join(self._timeout_seconds + 1.0)
            if monitor.is_alive():
                first_error = RuntimeError("return monitor did not stop before timeout")
            else:
                self._return_monitor_thread = None
        try:
            self._stop_menu()
        except BaseException as error:
            first_error = error
        with self._lock:
            game = self._game
        if game is not None:
            try:
                game.stop()
            except BaseException as error:
                if first_error is None:
                    first_error = error
        try:
            self._video.close()
        except BaseException as error:
            if first_error is None:
                first_error = error
        with self._lock:
            threads = (
                self._menu_thread,
                getattr(game, "_thread", None),
                self._video._thread,
            )
            workers_alive = any(
                thread is not None and thread.is_alive() for thread in threads
            ) or (game is not None and game.running)
            if workers_alive:
                sink = None
                if first_error is None:
                    first_error = RuntimeError("shell worker did not stop before timeout")
            else:
                self._game = None
                sink, self._sink = self._sink, None
        if sink is not None:
            try:
                sink.close()
            except BaseException as error:
                with self._lock:
                    if self._sink is None:
                        self._sink = sink
                if first_error is None:
                    first_error = error
        if first_error is not None:
            raise first_error

    def _resume_menu(self) -> None:
        with self._lock:
            self._mode = ShellMode.MENU
            self._select_page_locked(MenuPage.HOME)
            self._start_menu_locked()

    def _start_menu_locked(self) -> None:
        if self._sink is None:
            raise RuntimeError("C6I shell is not open")
        if self._menu_active:
            return
        self._menu_active = True
        self._menu_stop.clear()
        self._upload_menu_resources_locked()
        self._submit_menu_frame_locked()
        if self._menu_fps > 0:
            thread = threading.Thread(
                target=self._menu_loop,
                name="voice-view-c6i-menu",
                daemon=True,
            )
            self._menu_thread = thread
            thread.start()

    def _stop_menu(self) -> None:
        with self._lock:
            thread = self._menu_thread
            self._menu_active = False
            self._menu_stop.set()
        if thread is not None and thread is not threading.current_thread():
            thread.join(self._timeout_seconds + 1.0)
            if thread.is_alive():
                raise RuntimeError("menu rendering thread did not stop before timeout")
        with self._lock:
            self._menu_thread = None
            if self._sink is not None and self._mode not in (ShellMode.GAME, ShellMode.VIDEO):
                self._drain_sink()

    def _menu_loop(self) -> None:
        period = 1.0 / self._menu_fps
        target = time.perf_counter() + period
        try:
            while not self._menu_stop.wait(max(0.0, target - time.perf_counter())):
                sample = getattr(self._live_input, "sample_menu_control", None)
                if callable(sample):
                    self.handle_control(sample(tick_id=self._menu_frame_id))
                with self._lock:
                    if not self._menu_active or self._menu_thread is not threading.current_thread():
                        break
                    self._submit_menu_frame_locked()
                target += period
        except Exception as error:
            with self._lock:
                self._last_error = str(error)
            self._menu_stop.set()

    def _return_monitor_loop(self) -> None:
        while not self._return_monitor_stop.wait(0.05):
            with self._lock:
                mode = self._mode
            if mode not in (ShellMode.GAME, ShellMode.VIDEO):
                self._return_dwell.reset()
                continue
            try:
                peek = getattr(self._live_input, "peek_menu_control")
                control = peek()
                if self._return_dwell.update(return_contains(control), control.timestamp_ns):
                    self.return_to_menu()
                    self._return_dwell.reset()
            except Exception as error:
                with self._lock:
                    self._last_error = f"return monitor: {type(error).__name__}: {error}"
                self._return_dwell.reset()

    def _upload_menu_resources_locked(self) -> None:
        frame = self._compile_menu_frame_locked()
        sink = self._require_sink()
        self._drain_sink()
        sink.upload_asset(
            pack_asset_bundle_packet(frame.assets, generation=self._menu_generation)
        )
        sink.upload_palette(
            pack_palette_packet(frame.palette_banks, generation=self._menu_generation)
        )
        sink.upload_tilemap(
            pack_tilemap_packet(
                _MENU_TILEMAP, target_id=0, generation=self._menu_generation
            )
        )

    def _submit_menu_frame_locked(self) -> None:
        frame = self._compile_menu_frame_locked()
        packet = frame.header.to_bytes() + pack_command_bank(frame.commands)
        self._require_sink().submit_scene(packet)
        self._menu_frame_id += 1

    def _compile_menu_frame_locked(self):  # type: ignore[no-untyped-def]
        selected = self._input.hovered_id
        if self._page is MenuPage.HAND_PLACEHOLDER and selected != "back":
            peek = getattr(self._live_input, "peek_hand_classification", None)
            try:
                snapshot = peek() if callable(peek) else None
            except Exception:
                snapshot = None
            selected = hand_display_selection(snapshot)
        scene = build_menu_scene(
            self._menu_frame_id,
            self._targets,
            hovered_id=selected,
            label_texts=self._labels,
        )
        return self._menu_compiler.compile(
            scene,
            submit_seq=0xC6A10000 + self._menu_frame_id,
            palette_generation=self._menu_generation,
            asset_generation=self._menu_generation,
            tilemap_generation=self._menu_generation,
        )

    def _select_page_locked(self, page: MenuPage) -> None:
        self._page = page
        self._input.reset()
        if page is MenuPage.HOME:
            self._targets = HOME_TARGETS
            self._labels = ("GAME", "VIDEO", "HAND", "MORE")
            self._mode = ShellMode.MENU
        elif page is MenuPage.GAMES:
            self._targets = game_targets(self._game_ids)
            names = [self._game_entries[item_id].manifest.display_name
                     for item_id in self._game_ids[:3]]
            self._labels = tuple(names + [f"GAME {index + 1}"
                                          for index in range(len(names), 3)] + ["COMING SOON"])
            self._mode = ShellMode.MENU
        elif page is MenuPage.VIDEOS:
            entries = tuple(self._video_entries.values())
            self._targets = library_targets(
                MenuIcon.VIDEO,
                tuple(f"video:{entry.manifest.item_id}" for entry in entries),
            )
            self._labels = (
                *(entry.manifest.display_name for entry in entries[:4]),
            )
            self._mode = ShellMode.MENU
        elif page is MenuPage.HAND_PLACEHOLDER:
            self._targets = hand_display_targets()
            self._labels = ("DEFAULT", "PAPER", "SCISSORS", "ROCK")
            self._mode = ShellMode.HAND_PLACEHOLDER
        elif page is MenuPage.RESERVED:
            self._targets = placeholder_targets(page)
            self._labels = ("RESERVED",)
            self._mode = ShellMode.RESERVED
        self._menu_generation = (self._menu_generation + 1) & 0xFFFFFFFF
        self._menu_assets = create_menu_assets(self._labels)
        self._menu_compiler = SceneCompiler(
            sprite_atlas=self._menu_assets.sprite_atlas,
            tile_atlas=self._menu_assets.tile_atlas,
            palettes=self._menu_assets.palettes,
        )
        if self._menu_active:
            self._upload_menu_resources_locked()
            self._submit_menu_frame_locked()

    def _require_sink(self) -> _ShellSink:
        sink = self._sink
        if sink is None:
            raise RuntimeError("C6I shell is not open")
        return sink

    def _drain_sink(self) -> None:
        drain = getattr(self._require_sink(), "drain", None)
        if callable(drain):
            drain()

    @staticmethod
    def _entry_snapshot(entry: LibraryEntry) -> LibraryItemSnapshot:
        manifest = entry.manifest
        return LibraryItemSnapshot(
            item_id=manifest.item_id,
            display_name=manifest.display_name,
            kind=manifest.kind.value,
            length=manifest.length,
            sha256=manifest.sha256,
        )

    def _create_sink(self, session: C6IOverlaySession, timeout: float) -> _ShellSink:
        overlap = self._upload_render_overlap
        if overlap is None:
            capability = getattr(session, "supports_upload_render_overlap", None)
            overlap = callable(capability) and capability() is True
        return C6IVideoSink(
            session=session, timeout_seconds=timeout, upload_render_overlap=overlap
        )
