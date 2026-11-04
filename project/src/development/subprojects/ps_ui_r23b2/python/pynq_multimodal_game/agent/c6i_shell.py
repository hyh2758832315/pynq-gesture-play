from __future__ import annotations

from dataclasses import replace
from enum import Enum
from pathlib import Path
import json
import threading
import time
from typing import Any, Callable, Protocol

from ..controls import ControlState
from ..creative_pages import CanvasPage, PixelPageRenderer, robot_frame,album_frame
from ..shell_pages import render_shell_page, content_loading, highlight_frame
from ..game_package import validate_game_package
from ..game_seeds import SEED_GAME_IDS
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
    HAND_STATUS_LABELS,
    HAND_POSE_CAPTION,
    hand_session_label,
    _LABEL_Y,
    placeholder_targets,
    video_page_targets,
)
from ..scene_compiler import SceneCompiler
from ..scene import SpriteDescriptor, TileDescriptor, TileLayer
from ..return_button import (
    ReturnDwell, add_return_to_game_frame, add_return_to_scene_packet, add_return_to_video_palette,
    return_contains,
    add_return_progress_to_compiled,
    return_progress_commands,
)
from ..startup_ui import StartupRenderer, StartupSequence, StartupSnapshot, CheckState
from ..pause_menu import PauseInput, PauseRenderer
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
    CANVAS = "canvas"
    HAND_DEMO = "hand-demo"


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
                 video_palette: bool = False, return_progress=None) -> None:
        self._sink = sink
        self._return_button = return_button
        self._video_palette = video_palette
        self._return_progress = return_progress
        self._last_scene = None
        self._last_decorated_scene = None

    def _decorate(self, packet):
        if not self._return_button:
            return packet
        progress = None if self._return_progress is None else self._return_progress()
        return add_return_to_scene_packet(packet, progress)

    @property
    def upload_render_overlap_enabled(self) -> bool:
        return getattr(self._sink, "upload_render_overlap_enabled", False) is True

    def __getattr__(self, name: str) -> Any:
        if name == "enqueue_scene":
            enqueue = getattr(self._sink, name)
            return (lambda packet: enqueue(self._decorate(packet))) if self._return_button else enqueue
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
        decorated = self._decorate(packet)
        self._sink.submit_scene(decorated)
        self._last_scene, self._last_decorated_scene = packet, decorated

    def refresh_return_indicator(self) -> None:
        """Called by the same paused video worker; no producer or extra thread."""
        if not self._return_button or self._last_scene is None:
            return
        packet = self._decorate(self._last_scene)
        if packet != self._last_decorated_scene:
            self._sink.submit_scene(packet)
            self._last_decorated_scene = packet

    def restore_scene(self):
        if self._last_scene is not None:
            self._last_decorated_scene=self._decorate(self._last_scene)
            self._sink.submit_scene(self._last_decorated_scene)

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
        startup_library: Callable[[], object] | None = None,
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
        self._startup_library = startup_library
        self._startup_snapshot: StartupSnapshot | None = None
        self._startup_renderer = None
        self._startup_frame_id = 0
        self._startup_draw_lock = threading.Lock()
        self._startup_animation_stop = threading.Event()
        self._startup_animation_thread = None
        self._startup_animation_error = None
        self._startup_began = 0.0
        self._sink_factory = sink_factory or self._create_sink
        self._sink: _ShellSink | None = None
        self._menu_assets = create_menu_assets()
        self._menu_compiler = SceneCompiler(
            sprite_atlas=self._menu_assets.sprite_atlas,
            tile_atlas=self._menu_assets.tile_atlas,
            palettes=self._menu_assets.palettes,
        )
        self._canvas = None
        self._album_pixels = None
        self._album_revision = 0
        self._home_dialog = False
        self._home_dialog_dwell = ReturnDwell()
        self._home_dialog_target = None
        self._home_dialog_wait_exit = True
        self._restart_requested = False
        self._preview_active = False
        self._closing = False
        self._preview_ready = False
        self._preview_saved = None
        self._menu_recovery_generation = 0
        self._menu_recovery_pending = False
        self._recovery_retry_at = 0.
        self._recovery_delay = .5
        self._preview_modes = None
        self._restart_callback = None
        self._pixel_renderer = PixelPageRenderer()
        self._feature_pixels = None
        self._feature_last_submit = -1.
        self._demo_leaving = False
        self._demo_status = {}
        self._robot_geometry = None
        self._input = MenuInputController()
        self._page = MenuPage.HOME
        self._targets: tuple[MenuTarget, ...] = HOME_TARGETS
        self._labels: tuple[str, ...] = ("GAME", "VIDEO", "HAND", "CANVAS")
        self._mode = ShellMode.MENU
        self._menu_generation = 0xC6A10001
        self._catalog_generation = 0
        self._menu_frame_id = 0
        self._menu_poll_id = 0
        self._menu_presented_view = None
        self._last_error: str | None = None
        self._menu_stop = threading.Event()
        self._menu_thread: threading.Thread | None = None
        self._menu_active = False
        self._return_dwell = ReturnDwell()
        self._return_armed = True
        self._game_menu_active = False
        self._pause_input = PauseInput()
        self._pause_renderer: PauseRenderer | None = None
        self._return_monitor_stop = threading.Event()
        self._return_monitor_thread: threading.Thread | None = None
        self._lock = threading.RLock()
        self._game_ids: tuple[str, ...] = ()
        self._game_entries: dict[str, LibraryEntry] = {}
        self._video_entries: dict[str, LibraryEntry] = {}
        self._video_page = 0
        self._staged_video: tuple[ArtifactManifest, Path] | None = None
        self._staged_game: tuple[ArtifactManifest, Path] | None = None
        self._game: PackagedGameRuntime | None = None
        self._active_game_id: str | None = None
        self._active_test_case_json: str | None = None
        self._video = C6IVideoRuntimeBackend(
            session,
            timeout_seconds=timeout_seconds,
            sink_factory=lambda _session, _timeout: _BorrowedSink(
                self._require_sink(), return_button=True, video_palette=True,
                return_progress=lambda: self._return_dwell.progress,
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
            if self._preview_active:
                return replace(base,state=AgentState.PAUSED,runtime_mode='preview',
                    last_error=self._last_error or base.last_error)
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
            self._closing=False
            self._session.open()
            self._sink = self._sink_factory(self._session, self._timeout_seconds)
            if self._startup_vision is not None and self._startup_hand is not None:
                self._run_startup_locked()
            else:
                self.refresh_catalog()
            if not getattr(self, 'DEFER_STARTUP_MENU', False):
                self._complete_startup_locked()
            return self

    def _complete_startup_locked(self):
        self._stop_startup_animation()
        if self._startup_settle_seconds:
            self._menu_stop.wait(self._startup_settle_seconds)
        # The hand owner is attached after initial catalog/page preparation.
        # Grant HOME following only after the real startup checks complete.
        self._request_hand_page('live' if self._page in (
            MenuPage.HOME,MenuPage.GAMES,MenuPage.VIDEOS) else 'idle')
        self._start_menu_locked()
        if callable(getattr(self._live_input, "peek_menu_control", None)):
            self._return_monitor_stop.clear()
            self._return_monitor_thread = threading.Thread(
                target=self._return_monitor_loop, name="voice-view-return-monitor", daemon=True)
            self._return_monitor_thread.start()

    def _publish_startup_locked(self, snapshot):
        with self._startup_draw_lock:
            if self._startup_snapshot == snapshot and self._startup_frame_id > 0:
                return
            self._startup_snapshot = snapshot
            self._draw_startup_frame()

    def _draw_startup_frame(self):
        frame = self._startup_renderer.compile(self._startup_snapshot,
            frame_id=self._startup_frame_id,generation=0xC6A20001,
            elapsed_seconds=max(0.,time.monotonic()-self._startup_began))
        self._require_sink().submit_scene(frame.header.to_bytes()+pack_command_bank(frame.commands))
        self._startup_frame_id += 1

    def _animate_startup(self):
        # Cosmetic scenes only, 5 Hz. No status/serial/MMIO probes. This worker
        # never takes the shell lock held by blocking initialization checks.
        try:
            while not self._startup_animation_stop.wait(.2):
                with self._startup_draw_lock:
                    self._draw_startup_frame()
        except BaseException as error:
            self._startup_animation_error = error
            self._startup_animation_stop.set()

    def _stop_startup_animation(self):
        self._startup_animation_stop.set()
        thread = self._startup_animation_thread
        if thread is not None and thread is not threading.current_thread():
            thread.join(self._timeout_seconds+1.)
            if thread.is_alive():
                raise RuntimeError('loading renderer did not stop before menu/cleanup')
        self._startup_animation_thread = None
        if self._startup_animation_error is not None:
            raise RuntimeError('loading renderer failed: '+str(self._startup_animation_error))

    def _set_startup_check(self, index, state, error=None):
        # Only a real loading display is updated; legacy backends retain their lifecycle.
        if getattr(self, '_startup_renderer', None) is None:
            return
        with self._lock:
            states = list(self._startup_snapshot.states)
            states[index] = state
            self._publish_startup_locked(StartupSnapshot(tuple(states), error))

    @property
    def startup_snapshot(self) -> StartupSnapshot | None:
        with self._lock:
            return self._startup_snapshot

    def _prepare_startup_display_locked(self) -> None:
        """Use the identical boot artwork before cleanup and after re-exec."""
        renderer = StartupRenderer()
        self._startup_renderer = renderer
        self._startup_snapshot = None
        self._startup_frame_id = 0
        self._startup_began = time.monotonic()
        generation = 0xC6A20001
        sink = self._require_sink()
        initial = renderer.compile(StartupSnapshot(), frame_id=0, generation=generation)
        self._drain_sink()
        sink.upload_asset(pack_asset_bundle_packet(initial.assets, generation=generation))
        sink.upload_palette(pack_palette_packet(initial.palette_banks, generation=generation))
        sink.upload_tilemap(pack_tilemap_packet(
            _MENU_TILEMAP, target_id=0, generation=generation))
        self._publish_startup_locked(StartupSnapshot())
        self._drain_sink()

    def _run_startup_locked(self) -> None:
        self._prepare_startup_display_locked()
        def check_library() -> bool:
            if self._startup_library is not None:
                self._startup_library()
            self.refresh_catalog()
            return True

        checks = StartupSequence((
            ("GPU", lambda: True),
            ("LIBRARY", check_library),
            ("VISION", self._startup_vision),
            ("HAND", self._startup_hand),
        ))
        def publish(snapshot):
            if getattr(self, 'DEFER_STARTUP_MENU', False) and snapshot.states[3] is CheckState.OK:
                # Read-only probing is complete; actuator startup is still part
                # of HAND. Avoid flashing OK before its real readiness receipt.
                snapshot = replace(snapshot, states=(*snapshot.states[:3], CheckState.CHECK))
            self._publish_startup_locked(snapshot)
        self._publish_startup_locked(StartupSnapshot())
        self._startup_animation_stop.clear()
        self._startup_animation_thread = threading.Thread(target=self._animate_startup,
            name='voice-view-loading',daemon=True)
        self._startup_animation_thread.start()
        try:
            checks.run(publish)
        except BaseException:
            self._stop_startup_animation()
            raise

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
            self._game_ids = tuple(item_id for item_id in SEED_GAME_IDS if item_id in games) + tuple(
                item_id for item_id in games if item_id not in SEED_GAME_IDS)
            from ..video_seeds import seed_video_order
            self._video_entries = {item_id:videos[item_id] for item_id in seed_video_order() if item_id in videos}
            self._video_entries.update((item_id,entry) for item_id,entry in videos.items()
                                       if item_id not in self._video_entries)
            self._catalog_generation += 1
            # A Studio library refresh must not steal the GPU from a game,
            # its pause menu, or a playing video.
            if self._mode not in (ShellMode.GAME, ShellMode.VIDEO, ShellMode.HAND_DEMO, ShellMode.CANVAS):
                self._select_page_locked(self._page)

    def handle_control(self, control: ControlState) -> str | None:
        if self._preview_active or self._closing:
            return None
        if self._restart_requested:
            return None
        if self._game_menu_active:
            action = self._pause_input.update(control)
            if action == 'resume':
                self.resume_game()
            elif action == 'restart':
                self.reset_game()
            elif action == 'main-menu':
                self.return_to_menu()
            return action
        with self._lock:
            if self._home_dialog:
                return self._handle_home_dialog_locked(control)
            if self._mode is ShellMode.GAME:
                game = self._game
                if game is None:
                    raise RuntimeError("GAME mode has no active runtime")
                game.update(control)
                return None
            if self._mode is ShellMode.VIDEO:
                return None
            if self._page is MenuPage.CANVAS:
                peek = getattr(self._live_input,'peek_hand_classification',None)
                action=self._canvas.update(control,peek() if callable(peek) else None)
                if action=='home': self._select_page_locked(MenuPage.HOME)
                elif action=='album':self._select_page_locked(MenuPage.ALBUM)
                elif action=='save':
                    self._show_content_loading('DRAWING','page')
                    self._album_pixels=bytes(self._canvas.pixels)
                    self._album_revision+=1
                elif action in ('dialog','clear','continue'):
                    self._show_content_loading('CANVAS OPTIONS' if action=='dialog' else 'CANVAS','page')
                return action
            peek = getattr(self._live_input, 'peek_hand_classification', None)
            observation = (peek() or {}) if callable(peek) else None
            interaction = (self._input.update(control, self._targets, observation=observation)
                           if callable(peek) else self._input.update(control, self._targets))
            activated = interaction.activated_id
            if activated is None:
                return None
            if activated == "back":
                if self._page is MenuPage.HAND_DEMO:
                    self._leave_demo_locked()
                    return activated
                if self._page is MenuPage.HOME:
                    self._home_dialog=True
                    self._home_dialog_target=None
                    self._home_dialog_wait_exit=True
                    self._home_dialog_dwell.reset()
                    self._show_content_loading('OPTIONS','page')
                else:
                    self._select_page_locked(MenuPage.CANVAS if self._page is MenuPage.ALBUM else MenuPage.HOME)
                return activated
            elif self._page is MenuPage.HOME:
                destinations = {
                    "games": MenuPage.GAMES,
                    "videos": MenuPage.VIDEOS,
                    "hand": MenuPage.HAND_DEMO,
                    "canvas": MenuPage.CANVAS,
                    "reserved": MenuPage.RESERVED,
                }
                if activated == "videos":
                    self._video_page = 0
                self._select_page_locked(destinations[activated])
                return activated
            elif self._page is MenuPage.VIDEOS and activated in (
                    "video-page:prev", "video-page:next"):
                self._video_page += -1 if activated.endswith("prev") else 1
                self._select_page_locked(MenuPage.VIDEOS)
                return activated
            page = self._page
        if page is MenuPage.GAMES and activated.startswith("game:"):
            self.start_game(activated.removeprefix("game:"))
        elif page is MenuPage.VIDEOS and activated.startswith("video:"):
            self.play_library_video(activated.removeprefix("video:"))
        return activated

    def start_game(self, item_id: str, test_case_json: str | None = None) -> None:
        self._require_preview_idle()
        self._guard_demo_exit()
        if item_id not in self._game_ids:
            raise KeyError(f"game {item_id!r} is not installed")
        if self.mode in (ShellMode.GAME, ShellMode.VIDEO) or self._game is not None or self._video_has_owner():
            self.return_to_menu()
        self._stop_menu()
        game = None
        try:
            # Present and finish one loading frame before package work. The
            # framebuffer stays visible while the game owns the resource bank.
            self._show_content_loading(self._game_entries[item_id].manifest.display_name)
            package = validate_game_package(self._game_entries[item_id].asset, require_extension=False)
            volume = package.manifest.volume_inputs
            if volume is not None and volume.schema not in getattr(self, "supported_volume_schemas", ()):
                raise ValueError("backend does not support declared volume input contract")
            game = PackagedGameRuntime(
                self._game_entries[item_id].asset,
                _BorrowedSink(self._require_sink()),
                generation=(0xC6B00000 + self._catalog_generation) & 0xFFFFFFFF,
                live_input=self._live_input if test_case_json is None else None,
                scene_transform=lambda frame: add_return_to_game_frame(frame, self._return_dwell.progress),
            )
            diagnostic = getattr(self, "_diagnostic_startup_stage", None)
            if diagnostic is not None:
                game._diagnostic_startup_stage = diagnostic
            if test_case_json is not None:
                game.load_test_case(GameTestCase.from_json(test_case_json))
            game.start()
        except BaseException as error:
            with self._lock:
                self._last_error = f"{type(error).__name__}: {error}"
            try:
                if game is not None:
                    game.stop()
            except BaseException as cleanup_error:
                with self._lock:
                    self._game = game
                    self._menu_recovery_pending = True
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
            self._request_hand_page("live")
            self._return_armed = True
            self._return_dwell.reset()

    def _show_content_loading(self, title: str, kind: str = 'game', progress=None) -> None:
        frame = self._pixel_renderer.compile(content_loading(title, kind, progress),
                                             self._menu_frame_id, self._menu_generation,
                                             show_return=False)
        sink = self._require_sink()
        self._drain_sink()
        sink.upload_asset(self._pixel_renderer.pack_assets(frame, self._menu_generation))
        sink.upload_palette(pack_palette_packet(frame.palette_banks, generation=self._menu_generation))
        sink.upload_tilemap(pack_tilemap_packet(_MENU_TILEMAP, target_id=0, generation=self._menu_generation))
        sink.submit_scene(frame.header.to_bytes() + pack_command_bank(frame.commands))
        self._menu_frame_id += 1
        self._drain_sink()
        self._feature_pixels=None
        self._menu_presented_view=None
        # A single finished framebuffer gives immediate acknowledgement. The
        # display keeps it while preparation runs, without an animation worker.
        if self._menu_fps>0:time.sleep(.15)

    def _handle_home_dialog_locked(self,control):
        from ..controls import StaleFlag
        if not control.hand_valid or control.stale_flags & (StaleFlag.GESTURE|StaleFlag.ADAPTER_ERROR):
            self._home_dialog_dwell.reset();self._home_dialog_target=None
            return None
        x=round((control.hand_x+1)*319/2);y=round((control.hand_y+1)*179/2)
        target=('continue' if 45<=x<145 and 65<=y<128 else
                'restart' if 175<=x<275 and 65<=y<128 else None)
        if self._home_dialog_wait_exit:
            if return_contains(control):return None
            self._home_dialog_wait_exit=False
        if target!=self._home_dialog_target:
            self._home_dialog_dwell.reset();self._home_dialog_target=target
        if self._home_dialog_dwell.update(target is not None,control.timestamp_ns):
            self._home_dialog=False
            self._home_dialog_dwell.reset()
            if target=='continue':
                self._show_content_loading('MENU','page')
                self._input.reset(require_release=True)
                return 'continue'
            self._request_hand_page('idle')
            # Show boot artwork during normal shutdown. The new interpreter
            # owns all real GPU/library/vision/hand checks; do not run them
            # concurrently with the current hardware owner.
            self._prepare_startup_display_locked()
            self._restart_requested=True
            if callable(self._restart_callback):self._restart_callback()
            return 'restart'
        return None

    def _video_loading_progress(self, value):
        now=time.monotonic()
        if value < 1 and now-getattr(self,'_video_loading_at',0)<.5:return
        self._video_loading_at=now
        # This sole validation worker completes before the video sink opens.
        self._show_content_loading('CHECKING VIDEO' if value<.5 else 'PREPARING VIDEO',
                                   'page',round(value*100)/100)

    def play_library_video(self, item_id: str) -> RuntimeSnapshot:
        self._require_preview_idle()
        self._guard_demo_exit()
        if item_id not in self._video_entries:raise KeyError(f'video {item_id!r} is not installed')
        if self.mode in (ShellMode.GAME,ShellMode.VIDEO) or self._game is not None or self._video_has_owner():
            self.return_to_menu()
        self._request_hand_page("idle")
        self._stop_menu()
        self._show_content_loading('VIDEO','page',0)
        self._video.loading_progress=self._video_loading_progress
        try:
            self._set_video_hand_pause(True)
            self.stage_library_video(item_id)
            self.activate()
            return self.run(show_loading=False)
        except BaseException as error:
            self._last_error=f'{type(error).__name__}: {error}'
            self._resume_menu()
            raise

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
        self._require_preview_idle()
        with self._lock:
            if self._page is MenuPage.HAND_DEMO and not self._leave_demo_locked():
                return self.snapshot
        self._request_hand_page("idle")
        if self._game_menu_active:
            self._stop_menu()
        with self._lock:
            mode = self._mode
            game = self._game
        if mode is ShellMode.VIDEO or self._video_has_owner():
            stopped = self._video.stop()
            video_thread = self._video._thread
            confirmed = getattr(self._video, 'cleanup_complete', lambda: False)
            if (self._video_has_owner()
                    or (video_thread is not None and video_thread.is_alive())
                    or (stopped.state is AgentState.ERROR and confirmed() is not True)):
                self._menu_recovery_pending = True
                raise RuntimeError(stopped.last_error or "video worker has not stopped")
        if game is not None:
            try:
                game.stop()
            except Exception:
                self._menu_recovery_pending = True
                raise
        with self._lock:
            self._game = None
            self._active_game_id = None
            self._active_test_case_json = None
            self._game_menu_active = False
            self._return_dwell.reset()
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
        self._require_preview_idle()
        game = self._require_packaged_game()
        game.pause()
        return self.snapshot

    @property
    def game_menu_active(self) -> bool:
        return self._game_menu_active

    def open_game_menu(self, *, outcome: str | None = None) -> RuntimeSnapshot:
        with self._lock:
            if self._game_menu_active:
                return self.snapshot
            game = self._require_packaged_game()
            game.pause(keep_source_live=True)
            self._show_content_loading('RESULT' if outcome else 'PAUSED','page')
            last_frame = game.last_frame
            score = 0 if last_frame is None else last_frame.snapshot.score
            if (self._pause_renderer is None or self._pause_renderer.outcome != outcome
                    or self._pause_renderer.score != score):
                self._pause_renderer = PauseRenderer(outcome=outcome, score=score)
            self._pause_input = PauseInput(outcome=outcome)
            peek = getattr(self._live_input, 'peek_menu_control', None)
            if callable(peek):
                # Observe entry before publishing the modal. A hand already
                # outside the targets must not depend on the first render poll.
                self._pause_input.update(peek())
            self._game_menu_active = True
            self._request_hand_page("idle")
            self._return_armed = False
            self._return_dwell.reset()
            self._menu_generation = (self._menu_generation + 1) & 0xFFFFFFFF
            self._start_menu_locked()
            return self.snapshot

    def resume_game(self) -> RuntimeSnapshot:
        self._require_preview_idle()
        game = self._require_packaged_game()
        if self._game_menu_active and self._pause_input.outcome is not None:
            raise RuntimeError('finished game requires restart or main menu')
        if self._game_menu_active:
            self._stop_menu()
            self._show_content_loading('GAME','page')
            game.restore_display()
            with self._lock:
                self._game_menu_active = False
                self._return_dwell.reset()
        game.resume()
        self._request_hand_page("live")
        return self.snapshot

    def step_game(self) -> RuntimeSnapshot:
        self._require_preview_idle()
        if self._game_menu_active:
            raise RuntimeError('close the pause menu before stepping the game')
        game = self._require_packaged_game()
        game.step_once()
        return self.snapshot

    def reset_game(self) -> RuntimeSnapshot:
        self._require_preview_idle()
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
        self._require_preview_idle()
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
        self._guard_demo_exit()
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
        self._require_preview_idle()
        return self._video.activate()

    def run(self, *, show_loading=True) -> RuntimeSnapshot:
        self._require_preview_idle()
        self._guard_demo_exit()
        # Resume/idempotent RUN keeps the existing video worker and its GPU
        # resources. A loading scene here overwrites its palette/tilemap while
        # the paused worker still owns them, preventing the next video frame
        # from passing the PL resource-generation gate.
        if self.mode is ShellMode.VIDEO or self._video_has_owner():
            self._video.run()
            return self.snapshot
        self._request_hand_page('idle')
        if self.mode is ShellMode.GAME or self._game is not None:
            self.return_to_menu()
        self._stop_menu()
        if show_loading:self._show_content_loading('VIDEO','page')
        self._set_video_hand_pause(True)
        with self._lock:
            self._mode = ShellMode.VIDEO
            self._return_armed = True
            self._return_dwell.reset()
        try:
            return self.snapshot if self._video.run().state is AgentState.RUNNING else self.snapshot
        except BaseException as error:
            with self._lock:
                self._last_error = f"{type(error).__name__}: {error}"
            try:
                self._resume_menu()
            except BaseException as recovery_error:
                with self._lock:
                    self._last_error += f"; menu recovery failed: {type(recovery_error).__name__}: {recovery_error}"
                raise error from recovery_error
            raise

    def pause(self) -> RuntimeSnapshot:
        self._require_preview_idle()
        self._video.pause()
        return self.snapshot

    def seek(self, frame_index: int) -> RuntimeSnapshot:
        self._require_preview_idle()
        self._video.seek(frame_index)
        return self.snapshot

    def stop(self) -> RuntimeSnapshot:
        return self.return_to_menu()

    def close(self, *, retain_sink: bool = False) -> None:
        self._closing=True
        first_error: BaseException | None = None
        game_cleanup_failed = False
        video_cleanup_failed = False
        try:
            self._stop_startup_animation()
        except BaseException as error:
            first_error = error
        self._return_monitor_stop.set()
        monitor = self._return_monitor_thread
        if monitor is not None and monitor is not threading.current_thread():
            monitor.join(self._timeout_seconds + 1.0)
            if monitor.is_alive():
                if first_error is None:
                    first_error = RuntimeError("return monitor did not stop before timeout")
            else:
                self._return_monitor_thread = None
        try:
            if retain_sink:
                self._stop_menu(drain_sink=False)
            else:
                self._stop_menu()
        except BaseException as error:
            if first_error is None:
                first_error = error
        with self._lock:
            game = self._game
        if game is not None:
            try:
                if retain_sink and isinstance(game, PackagedGameRuntime):
                    game.stop(drain=False)
                else:
                    game.stop()
            except BaseException as error:
                game_cleanup_failed = True
                if first_error is None:
                    first_error = error
        try:
            self._video.close()
        except BaseException as error:
            video_cleanup_failed = True
            if first_error is None:
                first_error = error
        with self._lock:
            threads = (
                self._startup_animation_thread,
                self._return_monitor_thread,
                self._menu_thread,
                getattr(game, "_thread", None),
                self._video._thread,
            )
            workers_alive = any(
                thread is not None and thread.is_alive() for thread in threads
            ) or (game is not None and game.running)
            if retain_sink or workers_alive or game_cleanup_failed or video_cleanup_failed:
                sink = None
                if first_error is None and not retain_sink:
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
            self._require_menu_ownership()
            # Playback progress owns the display only until the worker stops.
            # Later Studio uploads validate content while the menu owns it.
            self._video.loading_progress = None
            self._mode = ShellMode.MENU
            if self._page is MenuPage.HOME:self._show_content_loading('MENU','page')
            self._select_page_locked(MenuPage.HOME)
            self._start_menu_locked()
            self._set_video_hand_pause(False)
            self._menu_recovery_generation += 1
            self._menu_recovery_pending = False

    def _start_menu_locked(self) -> None:
        if self._closing:return
        self._require_menu_ownership(allow_paused_game=True)
        if self._sink is None:
            raise RuntimeError("C6I shell is not open")
        if self._menu_active:
            return
        previous = self._menu_thread
        current = threading.current_thread()
        if previous is not None and previous is not current and previous.is_alive():
            raise RuntimeError("previous menu rendering thread is still stopping")
        self._upload_menu_resources_locked()
        self._submit_menu_frame_locked()
        self._menu_active = True
        self._menu_stop.clear()
        # Pause/restart/home can all be selected by this very worker. Reuse it
        # until its loop returns, keeping ownership visible throughout the call.
        if self._menu_fps > 0 and previous is not current:
            thread = threading.Thread(
                target=self._menu_loop,
                name="voice-view-c6i-menu",
                daemon=True,
            )
            self._menu_thread = thread
            try:
                thread.start()
            except BaseException:
                self._menu_active = False
                self._menu_thread = None
                raise

    def _stop_menu(self, *, drain_sink: bool = True) -> None:
        with self._lock:
            thread = self._menu_thread
            self._menu_active = False
            self._menu_stop.set()
        if thread is not None and thread is not threading.current_thread():
            thread.join(self._timeout_seconds + 1.0)
            if thread.is_alive():
                raise RuntimeError("menu rendering thread did not stop before timeout")
        with self._lock:
            if thread is not threading.current_thread() and self._menu_thread is thread:
                self._menu_thread = None
            if drain_sink and self._sink is not None and self._mode not in (ShellMode.GAME, ShellMode.VIDEO):
                self._drain_sink()

    def _menu_loop(self) -> None:
        period = 1.0 / self._menu_fps
        target = time.perf_counter() + period
        try:
            while not self._menu_stop.wait(max(0.0, target - time.perf_counter())):
                with self._lock:
                    if not self._menu_active or self._menu_thread is not threading.current_thread():
                        break
                sample = getattr(self._live_input, "sample_menu_control", None)
                if self._preview_active:
                    target=time.perf_counter()+period
                    continue
                if callable(sample):
                    restored = self._menu_recovery_generation
                    try:
                        self.handle_control(sample(tick_id=self._menu_poll_id))
                    except Exception as error:
                        with self._lock:
                            recovered = (self._menu_recovery_generation != restored
                                and self._menu_active and not self._closing
                                and not self._restart_requested and self._game is None
                                and not self._video_has_owner()
                                and getattr(self._sink,'_poison',None) is None)
                            if not recovered:
                                raise
                            # The failed action already returned GPU ownership
                            # and redrew HOME. Keep this same input worker alive.
                            self._last_error = f'{type(error).__name__}: {error}'
                            self._input.reset(require_release=True)
                self._menu_poll_id += 1
                with self._lock:
                    if not self._menu_active or self._menu_thread is not threading.current_thread():
                        break
                    self._submit_menu_frame_locked()
                target += period
                now = time.perf_counter()
                if target <= now:
                    # Menu input uses the latest observation; old polls have no
                    # useful work to replay after a slow transition or upload.
                    target = now + period
        except Exception as error:
            self._request_hand_page("idle")
            with self._lock:
                self._last_error = str(error)
                self._menu_recovery_pending = True
            self._menu_stop.set()
        finally:
            with self._lock:
                if self._menu_thread is threading.current_thread():
                    self._menu_thread = None
                    self._menu_active = False

    def _return_monitor_loop(self) -> None:
        while not self._return_monitor_stop.wait(0.05):
            if time.monotonic() < self._recovery_retry_at:
                continue
            try:
                self._service_recovery()
                self._poll_return_control()
                self._recovery_delay = .5
            except Exception as error:
                self._recovery_retry_at = time.monotonic() + self._recovery_delay
                self._recovery_delay = min(10., self._recovery_delay * 2)
                if self._preview_active:
                    self._preview_ready=False
                    self._request_hand_page('idle')
                    if (getattr(self._sink,'_poison',None) is not None
                            and callable(self._restart_callback)):
                        self._restart_requested=True
                        self._recovery_requested=True
                        self._restart_callback()
                with self._lock:
                    self._last_error = f"return monitor: {type(error).__name__}: {error}"
                self._return_dwell.reset()

    def _service_recovery(self):
        """Reuse the return worker; never replace an unconfirmed GPU owner."""
        if self._closing or self._restart_requested:
            return
        if not self._preview_active and self._active_test_case_json is None:
            game_error = (getattr(self._game, 'last_error', None)
                          if self._mode is ShellMode.GAME else None)
            video_error = (self._video.snapshot.last_error
                           if self._mode is ShellMode.VIDEO else None)
            if game_error or video_error:
                self._last_error = game_error or video_error
                self._menu_recovery_pending = True
        if self._menu_recovery_pending and not self._preview_active:
            thread = self._menu_thread
            if thread is not None and thread.is_alive():
                return
            if getattr(self._sink, '_poison', None) is not None:
                if callable(self._restart_callback):
                    self._restart_requested = self._recovery_requested = True
                    self._restart_callback()
                return
            self.return_to_menu()  # Retries retained game/video cleanup first.
        recover_hand = getattr(self, '_recover_hand_session', None)
        if callable(recover_hand):
            recover_hand()

    def _poll_return_control(self):
        self._sync_preview_activity()
        if self._preview_active:
            self._return_dwell.reset()
            return None
        with self._lock:
            mode = self._mode
        if self._game_menu_active or mode not in (ShellMode.GAME, ShellMode.VIDEO):
            self._return_dwell.reset()
            return None
        # Studio owns all input during a deterministic replay. A camera hand
        # over Back must not pause it or change its recorded Scene ring.
        if mode is ShellMode.GAME and self._active_test_case_json is not None:
            self._return_dwell.reset()
            return None
        game = self._game
        if (mode is ShellMode.GAME and isinstance(game, PackagedGameRuntime)
                and self._active_test_case_json is None and game.running
                and game.terminal_status is not None):
            self.open_game_menu(outcome=game.terminal_status)
            return 'game-result'
        control = self._live_input.peek_menu_control()
        inside = return_contains(control)
        if not self._return_armed:
            if not inside and control.hand_valid:
                self._return_armed = True
            self._return_dwell.reset()
            return None
        if self._return_dwell.update(inside, control.timestamp_ns):
            if mode is ShellMode.GAME:
                self.open_game_menu()
                action = 'pause-menu'
            else:
                self.return_to_menu()
                action = 'main-menu'
            self._return_dwell.reset()
            return action
        return None

    def _sync_preview_activity(self):
        """Existing return worker owns this transition; no extra monitor."""
        if self._return_monitor_stop.is_set() or self._closing or self._restart_requested:
            self._preview_ready=False
            return
        requested=bool(self._preview_modes and self._preview_modes())
        if requested:
            if not self._preview_active:
                with self._lock:
                    self._preview_active=True
                    self._preview_saved=dict(menu=(self._menu_active or
                        self._mode not in (ShellMode.GAME,ShellMode.VIDEO)),prepared=False,
                        game=self._game,game_paused=bool(self._game and self._game.paused),
                        game_refresh=bool(getattr(self._game,'_paused_display_live',False)),
                        video=self._mode is ShellMode.VIDEO,
                        video_running=self._mode is ShellMode.VIDEO and self._video.snapshot.state is AgentState.RUNNING,
                        demo=self._page is MenuPage.HAND_DEMO)
            saved=self._preview_saved
            self._recover_failed_preview_video(saved)
            if not saved['prepared']:
                self._stop_menu()
                if saved['game'] is not None:
                    if getattr(saved['game'], 'last_error', None):
                        saved['game'].stop()
                        with self._lock:
                            self._game = None
                            self._active_game_id = self._active_test_case_json = None
                            self._game_menu_active = False
                            self._select_page_locked(MenuPage.HOME)
                        saved['game'] = None
                        saved['menu'] = True
                    else:
                        saved['game'].pause(keep_source_live=True)
                if saved['video']:
                    self._video.set_preview_exclusive(True)
                    if saved['video_running']:self._video.pause()
                if saved['demo']:self._request_hand_page('idle')
                saved['prepared']=True
            if saved['video'] and not self._video.preview_quiesced():return
            if saved['demo'] and not self._preview_ready and not self._read_hand_page().get('off'):
                return  # Existing demo route must return default/OFF first.
            if not saved.get('pause_drawn'):
                self._show_preview_pause()
                saved['pause_drawn']=True
            self._set_video_hand_pause(False)
            self._request_hand_page('live')
            self._preview_ready=True
            return
        if not self._preview_active:return
        self._preview_ready=False
        saved=self._preview_saved
        self._recover_failed_preview_video(saved)
        # Restore permission before playback: video still requires confirmed OFF.
        if saved['video']:
            self._request_hand_page('idle')
            self._set_video_hand_pause(True)
            self._video.restore_display()
            self._video.set_preview_exclusive(False)
            if saved['video_running']:self._video.run()
        elif saved['game'] is not None:
            if not saved['menu']:saved['game'].restore_display()
            if not saved['game_paused']:saved['game'].resume()
            else:saved['game'].pause(keep_source_live=not saved['game_refresh'])
            self._request_hand_page('idle' if self._game_menu_active else 'live')
            if saved['menu']:
                with self._lock:self._start_menu_locked()
        else:
            if saved['demo']:
                self._request_hand_page('idle')
                if not self._read_hand_page().get('off'):return
                with self._lock:self._select_page_locked(MenuPage.HOME)
            else:
                self._request_hand_page('live' if self._page in (
                    MenuPage.HOME,MenuPage.GAMES,MenuPage.VIDEOS) else 'idle')
            if saved['menu']:
                with self._lock:self._start_menu_locked()
        self._input.reset(require_release=True)
        self._return_dwell.reset()
        self._preview_saved=None
        self._preview_active=False

    def _recover_failed_preview_video(self, saved):
        if not saved['video'] or self._video.snapshot.state is not AgentState.ERROR:
            return
        # A failed decoder cannot pause/resume. Retry the same owner's cleanup
        # on both preview entry and exit, then return to an interactive menu.
        self._video.stop()
        if not self._video.cleanup_complete():
            raise RuntimeError('Retrying failed video cleanup for preview')
        self._video.set_preview_exclusive(False)
        self._set_video_hand_pause(False)
        with self._lock:
            self._select_page_locked(MenuPage.HOME)
        saved.update(video=False, video_running=False, menu=True)

    def _show_preview_pause(self):
        from ..shell_pages import preview_pause_commands
        from ..gpu_abi import SceneHeader
        commands=preview_pause_commands()
        palette,asset,tilemap=self._require_sink().resource_generations
        frame=SceneHeader(frame_id=self._menu_frame_id,submit_seq=0xC6A10000+self._menu_frame_id,
            command_count=len(commands),camera_x=0,camera_y=0,background_color=(18,22,28),
            palette_generation=palette,asset_generation=asset,tilemap_generation=tilemap,
            predicted_cycles=SceneCompiler._predict_cycles(commands))
        self._drain_sink()
        self._require_sink().submit_scene(frame.to_bytes()+pack_command_bank(commands))
        self._drain_sink()
        self._menu_frame_id+=1

    def _upload_menu_resources_locked(self) -> None:
        # Games and video share the GPU resource banks. Even an identical menu
        # must be presented again after these resources have been restored.
        self._menu_presented_view = None
        self._feature_pixels = None
        frame = self._compile_menu_frame_locked()
        sink = self._require_sink()
        self._drain_sink()
        sink.upload_asset(
            self._pack_menu_assets(frame)
        )
        self._feature_pixels = frame.assets[0].pixels
        sink.upload_palette(
            pack_palette_packet(frame.palette_banks, generation=self._menu_generation)
        )
        sink.upload_tilemap(
            pack_tilemap_packet(
                _MENU_TILEMAP, target_id=0, generation=self._menu_generation
            )
        )

    def _submit_menu_frame_locked(self) -> None:
        if self._restart_requested:return
        if self._page is MenuPage.HAND_DEMO:
            self._demo_status=self._read_hand_page()
            state=self._demo_status
            if state.get('off') and (self._demo_leaving or state.get('phase') in ('DONE','INTERRUPTED')):
                self._select_page_locked(MenuPage.HOME)
                return
            if self._demo_leaving:return
        now=time.monotonic()
        if self._page in (MenuPage.CANVAS,MenuPage.HAND_DEMO) and now-self._feature_last_submit<1/15:
            return
        view = self._menu_view_locked()
        if view[0] == self._menu_presented_view:
            return
        frame = self._compile_menu_frame_locked(view)
        packet = frame.header.to_bytes() + pack_command_bank(frame.commands)
        pixels=frame.assets[0].pixels
        if self._page is not MenuPage.HAND_PLACEHOLDER and pixels!=self._feature_pixels:
            self._drain_sink()
            self._require_sink().upload_asset(self._pack_menu_assets(frame))
            self._feature_pixels=pixels
        self._feature_last_submit=now
        self._require_sink().submit_scene(packet)
        self._menu_presented_view = view[0]
        self._menu_frame_id += 1

    def _menu_view_locked(self):
        if self._home_dialog:
            return ('home-options',self._menu_generation,self._home_dialog_target,
                    round(24*(self._home_dialog_dwell.progress or 0))),None,None
        if self._page is MenuPage.ALBUM:
            return ('album',self._menu_generation,self._album_revision,
                    return_progress_commands(self._input.return_progress)),None,None
        if self._page is MenuPage.CANVAS:
            return (self._menu_generation,self._canvas.view_key()),None,None
        if self._page is MenuPage.HAND_DEMO:
            return (self._menu_generation,json.dumps(self._demo_status,sort_keys=True),
                    self._demo_leaving,return_progress_commands(self._input.return_progress)),None,None
        if self._game_menu_active:
            hovered, progress = self._pause_input.hovered, self._pause_input.progress
            visible_progress = (return_progress_commands(progress) if hovered == 'back'
                                else round(48 * progress) if hovered is not None else None)
            return ((self._menu_generation, self._pause_renderer, hovered, visible_progress), None, None)
        selected = self._input.hovered_id
        if self._page is MenuPage.HAND_PLACEHOLDER and selected != "back":
            peek = getattr(self._live_input, "peek_hand_classification", None)
            try:
                snapshot = peek() if callable(peek) else None
            except Exception:
                snapshot = None
            selected = hand_display_selection(snapshot)
        label = None
        if self._page is MenuPage.HAND_PLACEHOLDER:
            owner = getattr(self, "_hand_session", None)
            read_status = getattr(owner, "status", None)
            try:
                status = read_status() if callable(read_status) else None
            except Exception:
                status = {"phase": "FAULT"}
            label = hand_session_label(status)
        key = (self._menu_generation, self._page, self._targets, self._labels,
               selected, label, self._input.confirm_armed, return_progress_commands(self._input.return_progress))
        return key, selected, label

    def _compile_menu_frame_locked(self, view=None):  # type: ignore[no-untyped-def]
        if self._home_dialog:
            from ..shell_pages import home_options
            from ..gpu_abi import GpuCommand
            frame=self._pixel_renderer.compile_static(home_options(self._home_dialog_target,0),
                self._menu_frame_id,self._menu_generation)
            width=round(96*round(24*(self._home_dialog_dwell.progress or 0))/24)
            if width and self._home_dialog_target:
                extra=GpuCommand.fill_rect(x=47 if self._home_dialog_target=='continue' else 177,
                    y=124,width=width,height=3,token=10)
                commands=(*frame.commands[:-1],extra,frame.commands[-1])
                frame=replace(frame,commands=commands,header=replace(frame.header,
                    command_count=len(commands),predicted_cycles=frame.header.predicted_cycles+8+width*3))
            return frame
        if self._page is MenuPage.ALBUM:
            return self._pixel_renderer.compile_static(album_frame(self._album_pixels),self._menu_frame_id,
                self._menu_generation,self._input.return_progress)
        if self._page in (MenuPage.CANVAS,MenuPage.HAND_DEMO):
            if self._page is MenuPage.CANVAS:
                return self._pixel_renderer.compile_canvas(
                    self._canvas,self._menu_frame_id,self._menu_generation)
            else:
                status=self._demo_status
                pixels=robot_frame(status.get('pose','default'),
                    'RETURNING' if self._demo_leaving else status.get('phase','WAITING'),
                    status.get('index',0),self._robot_geometry)
                progress=self._input.return_progress
            return self._pixel_renderer.compile(pixels,self._menu_frame_id,self._menu_generation,progress)
        if self._game_menu_active:
            return self._pause_renderer.compile(self._menu_frame_id, self._menu_generation,
                                                self._pause_input.hovered, self._pause_input.progress)
        _, selected, label = self._menu_view_locked() if view is None else view
        if self._page is MenuPage.HAND_PLACEHOLDER:
            scene = build_menu_scene(self._menu_frame_id,self._targets,hovered_id=selected,
                                     label_texts=self._labels,hand_poses=True,animate=False)
            extras=[]
            for text,index,y in ((label,len(self._labels)+1+HAND_STATUS_LABELS.index(label),8),
                                 (HAND_POSE_CAPTION,len(self._labels),20)):
                width=len(text)*4-1
                extras.append(SpriteDescriptor(x=(320-width)//2,y=y,width=width,height=5,
                    atlas_x=0,atlas_y=_LABEL_Y+index*5,palette_bank=0,priority=40+len(extras)))
            frame=self._menu_compiler.compile(replace(scene,sprites=(*scene.sprites,*extras)),
                submit_seq=0xC6A10000+self._menu_frame_id,palette_generation=self._menu_generation,
                asset_generation=self._menu_generation,tilemap_generation=self._menu_generation)
            return add_return_progress_to_compiled(frame,self._input.return_progress)
        pixels = render_shell_page(self._page, self._targets, self._labels,
                                   armed=self._input.confirm_armed, status=label)
        frame = self._pixel_renderer.compile(pixels, self._menu_frame_id,
                                             self._menu_generation, self._input.return_progress)
        return highlight_frame(frame,next((t for t in self._targets if t.item_id==selected),None))

    def _pack_menu_assets(self, frame):
        if (frame.assets[0].width,frame.assets[0].height)==(320,180):
            return self._pixel_renderer.pack_assets(frame,self._menu_generation)
        return pack_asset_bundle_packet(frame.assets,generation=self._menu_generation)

    def _select_page_locked(self, page: MenuPage) -> None:
        self._require_menu_ownership()
        if self._page is MenuPage.HAND_DEMO and page is not MenuPage.HAND_DEMO:
            if not self._read_hand_page().get('off'):
                raise RuntimeError('Demo must return default and confirm OFF before page transfer')
        changed = self._page is not page
        previous_page=self._page
        if changed and self._sink is not None:
            self._show_content_loading({'home':'MENU','hand-demo':'HAND SHOW'}.get(page.value,page.value.upper()),'page')
        self._page = page
        self._input.reset(require_release=changed)
        self._feature_last_submit=-1.
        if page is not MenuPage.HAND_DEMO:
            self._request_hand_page('live' if page in (
                MenuPage.HOME,MenuPage.GAMES,MenuPage.VIDEOS) else 'idle')
        if page not in (MenuPage.CANVAS,MenuPage.ALBUM):
            self._canvas=None
        if page is MenuPage.HOME:
            self._targets = HOME_TARGETS
            self._labels = ("GAME", "VIDEO", "HAND", "CANVAS")
            self._mode = ShellMode.MENU
        elif page is MenuPage.GAMES:
            self._targets = game_targets(self._game_ids)
            names = [self._game_entries[item_id].manifest.display_name
                     for item_id in self._game_ids[:4]]
            self._labels = tuple(names + [f"GAME {index + 1}"
                                          for index in range(len(names), 4)])
            self._mode = ShellMode.MENU
        elif page is MenuPage.VIDEOS:
            entries = tuple(self._video_entries.values())
            if len(entries) <= 4:
                self._video_page = 0
                self._targets = video_page_targets(
                    tuple(entry.manifest.item_id for entry in entries))
                self._labels = tuple(entry.manifest.display_name for entry in entries)
            else:
                self._video_page = max(0, min(self._video_page, (len(entries) - 1) // 2))
                visible = entries[self._video_page * 2 : self._video_page * 2 + 2]
                self._targets = video_page_targets(
                    tuple(entry.manifest.item_id for entry in entries),
                    page=self._video_page)
                self._labels = (
                    *(entry.manifest.display_name for entry in visible),
                    *("",) * (2 - len(visible)),
                    "PREV" if self._video_page else "START",
                    "NEXT" if self._video_page < (len(entries) - 1) // 2 else "END",
                )
            self._mode = ShellMode.MENU
        elif page is MenuPage.CANVAS:
            self._canvas=self._canvas or CanvasPage()
            if previous_page is MenuPage.ALBUM:
                self._canvas.back.reset();self._canvas.album_dwell.reset()
                self._canvas.wait_exit=True
            self._targets=()
            self._labels=()
            self._mode=ShellMode.CANVAS
        elif page is MenuPage.ALBUM:
            from ..menu import BACK_TARGET
            self._targets=(BACK_TARGET,)
            self._labels=()
            self._mode=ShellMode.MENU
        elif page is MenuPage.HAND_DEMO:
            from ..menu import BACK_TARGET
            self._targets=(BACK_TARGET,)
            self._labels=()
            self._mode=ShellMode.HAND_DEMO
            self._demo_leaving=False
            if self._robot_geometry is None:
                path=Path(__file__).parents[1]/'data/demo_geometry.json'
                self._robot_geometry=json.loads(path.read_text(encoding='utf-8'))
            self._request_hand_page('demo',restart=True)
            self._demo_status=self._read_hand_page()
        elif page is MenuPage.HAND_PLACEHOLDER:
            self._targets = hand_display_targets()
            self._labels = ("DEFAULT", "PAPER", "SCISSORS", "ROCK")
            self._mode = ShellMode.HAND_PLACEHOLDER
        elif page is MenuPage.RESERVED:
            self._targets = placeholder_targets(page)
            self._labels = ("RESERVED",)
            self._mode = ShellMode.RESERVED
        self._menu_generation = (self._menu_generation + 1) & 0xFFFFFFFF
        atlas_labels = (*self._labels, HAND_POSE_CAPTION, *HAND_STATUS_LABELS) if page is MenuPage.HAND_PLACEHOLDER else self._labels
        self._menu_assets = create_menu_assets(atlas_labels, hand_poses=page is MenuPage.HAND_PLACEHOLDER, canvas_home=page is MenuPage.HOME)
        self._menu_compiler = SceneCompiler(
            sprite_atlas=self._menu_assets.sprite_atlas,
            tile_atlas=self._menu_assets.tile_atlas,
            palettes=self._menu_assets.palettes,
        )
        if self._menu_active:
            self._upload_menu_resources_locked()
            self._submit_menu_frame_locked()

    def _request_hand_page(self, mode, *, restart=False):
        if getattr(self,'_hand_permissions_closed',False):return
        owner=getattr(self,'_hand_session',None)
        request=getattr(owner,'set_page_mode',None)
        if callable(request): return request(mode,restart=restart)

    def _require_preview_idle(self):
        if self._preview_active:
            raise RuntimeError('回传与灵巧手跟随中，请先关闭 Studio 回传再操作页面或播放')

    def _set_video_hand_pause(self, paused):
        if getattr(self,'_hand_permissions_closed',False):return
        owner = getattr(self, '_hand_session', None)
        request = getattr(owner, 'set_video_paused', None)
        if not callable(request):
            return  # No serial action owner (including hand-disabled board tests).
        request(paused)
        if not paused:
            return  # Existing publisher resumes only from fresh source observations.
        deadline = time.monotonic() + 20
        retry_at = 0.
        while True:
            status = owner.status()
            if (status.get('phase') in ('FAULT','CLOSED')
                    and status.get('release_confirmed') is True):
                # This flag is set only after child exit and validation of its
                # CLOSED/17-OFF receipt. Keep the fault visible, allow video.
                return
            if status.get('phase') in ('FAULT', 'CLOSED', 'CLOSING'):
                recover = getattr(owner, 'recover_release', None)
                if callable(recover) and time.monotonic() >= retry_at:
                    retry_at = time.monotonic() + 1.
                    try:
                        recover()
                    except Exception as error:
                        self._last_error = f'Hand OFF recovery: {error}'
                    status = owner.status()
                    if status.get('release_confirmed') is True:
                        return
            # The serial parent only exposes this pair after validating all 17
            # OFF IDs, no enable epoch and CONNECTED_OFF from the same child.
            if status.get('phase') == 'PAUSED' and status.get('preview_allowed') is True:
                return
            if time.monotonic() >= deadline:
                raise TimeoutError('Hand OFF confirmation timed out before video')
            if self._closing or self._restart_requested:
                raise RuntimeError('Hand OFF wait interrupted by shutdown')
            time.sleep(.05)

    def _read_hand_page(self):
        owner=getattr(self,'_hand_session',None)
        read=getattr(owner,'page_status',None)
        if not callable(read):
            return dict(phase='HAND OFF',pose='default',index=0,off=True)
        lifecycle=owner.status()
        if lifecycle.get('phase')=='PAUSED' and lifecycle.get('preview_allowed') is True:
            return dict(phase='PREVIEW PAUSED',pose='default',index=0,off=True)
        if lifecycle.get('phase') in ('FAULT','CLOSED'):
            return dict(phase='HAND FAULT' if lifecycle.get('error') else 'HAND OFF',
                        pose='default',index=0,
                        off=lifecycle.get('release_confirmed') is True or lifecycle.get('release_not_required') is True)
        return read()

    def _leave_demo_locked(self):
        if not self._demo_leaving:
            self._demo_leaving=True
            self._show_content_loading('MENU','page')
            self._request_hand_page('idle')
        self._demo_status=self._read_hand_page()
        if self._demo_status.get('off'):
            self._select_page_locked(MenuPage.HOME)
            return True
        return False

    def _guard_demo_exit(self):
        with self._lock:
            if self._page is MenuPage.HAND_DEMO and not self._leave_demo_locked():
                raise RuntimeError('Demo returning default; wait for confirmed OFF before starting another task')

    def _video_has_owner(self) -> bool:
        return (self._video._thread is not None
                or getattr(self._video, '_cleanup_sink', None) is not None)

    def _require_menu_ownership(self, *, allow_paused_game: bool = False) -> None:
        # Mode labels are presentation state, not proof of a stopped producer.
        # In particular failed startup can retain a game while still in MENU.
        if self._game is not None and not (allow_paused_game and self._game_menu_active):
            self._menu_recovery_pending = True
            raise RuntimeError('game cleanup must complete before transferring GPU ownership to menu')
        if self._video_has_owner():
            self._menu_recovery_pending = True
            raise RuntimeError('VIDEO cleanup must complete before transferring GPU ownership to menu')

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
