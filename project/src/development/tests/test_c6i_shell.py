from __future__ import annotations

from pathlib import Path
from dataclasses import replace
import threading
import time

import pytest

from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend, ShellMode
from pynq_multimodal_game.agent.core import (
    AgentCommand,
    AgentController,
    AgentState,
    ArtifactManifest,
)
from pynq_multimodal_game.controls import ControlSource, ControlState, Direction
from pynq_multimodal_game.game_package import GamePackageBuilder
from pynq_multimodal_game.game_project import GameProject
from pynq_multimodal_game.game_testing import (
    AssertionOperator,
    AssertionRule,
    GameTestCase,
    InputEvent,
    InputKind,
)
from pynq_multimodal_game.library import AssetLibrary, LibraryKind
from pynq_multimodal_game.menu import MenuPage
from pynq_multimodal_game.video_codec import S2V1_HEIGHT, S2V1_WIDTH, encode_rgb_frames
from pynq_multimodal_game.vision_input import VisionInputProvider


BUILD_ID = 0xC0060700


def test_volume_backend_starts_after_gpu_and_retains_on_close_failure():
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.vision_backend import C6IVolumeRuntimeBackend, SharedVisionSupervisor
    from pynq_multimodal_game.vision_input import GameVisionInputProvider
    operations = []
    class Session(_Session):
        build_id = 0xC0060C00
        opened = False
        def open(self):
            if not self.opened:
                operations.append("overlay_open")
                self.opened = True
            return self
    class Volume:
        latch = SimpleNamespace()
        fail = True
        def open(self):
            assert session.opened
            operations.append("volume_open")
        def close(self):
            operations.append("volume_close")
            if self.fail:
                raise RuntimeError("sampling disable unconfirmed; retain lease")
        def status(self):
            return {"error": None, "lease_retained": True}
    session, volume, sink = Session(), Volume(), _Sink()
    def create_sink(*_args):
        operations.append("sink_open")
        return sink
    backend = C6IVolumeRuntimeBackend(session,
        SharedVisionSupervisor(lambda _run: None, GameVisionInputProvider()), volume_factory=lambda owner: volume,
        menu_fps=0, sink_factory=create_sink)
    assert backend.open() is backend and backend.open() is backend
    assert operations == ["overlay_open", "sink_open", "volume_open"]
    assert backend.snapshot.profile == "C6I_VISION_VOLUME_V1"
    assert backend.snapshot.volume["lease_retained"]
    assert backend.input_schema_version == 4 and backend.supported_volume_schemas == ("volume-signal-v1",)
    with pytest.raises(RuntimeError, match="retain lease"):
        backend.close()
    assert not sink.closed and backend._volume is volume
    volume.fail = False
    backend.close()
    assert sink.closed and backend._volume is None
    with pytest.raises(ValueError, match="0xC0060C00"):
        C6IVolumeRuntimeBackend(_Session(), backend._vision_supervisor, volume_factory=lambda _owner: volume)


def test_old_shell_rejects_explicit_volume_before_staging_or_game_worker(tmp_path):
    from pynq_multimodal_game.game_package import GameManifest
    project = GameProject.create(tmp_path / "volume", game_id="volume", display_name="Volume")
    text = project.manifest_path.read_text(encoding="utf-8").replace("sdk_minor = 1", "sdk_minor = 3")
    project.manifest_path.write_text(text + '\n[volume]\nschema = "volume-signal-v1"\nvision_mapping = "game1"\n', encoding="utf-8")
    package = GamePackageBuilder().build(project.root, tmp_path / "volume.vvg")
    library = AssetLibrary(tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0)
    library.install_file(package.path, item_id="volume", display_name="Volume", kind=LibraryKind.GAME, target_build_id=BUILD_ID)
    sink = _Sink()
    backend = C6IShellRuntimeBackend(_Session(), menu_fps=0, library=library, sink_factory=lambda *_args: sink)
    backend.open()
    try:
        artifact = ArtifactManifest.for_path(package.path, artifact_kind="game.vvg", target_build_id=BUILD_ID, abi_major=1, abi_minor=0)
        with pytest.raises(ValueError, match="volume input contract"):
            backend.stage_file(artifact, package.path)
        with pytest.raises(ValueError, match="volume input contract"):
            backend.start_game("volume")
        assert backend._game is None and backend._staged_game is None
    finally:
        backend.close()


def test_voice_fusion_starts_after_scene_and_uses_new_epoch_after_pause(tmp_path):
    import uuid
    from pynq_multimodal_game.agent.voice_backend import C6IVoiceFusionRuntimeBackend
    from pynq_multimodal_game.agent.vision_backend import SharedVisionSupervisor
    from pynq_multimodal_game.game_validation import build_verified_game
    from pynq_multimodal_game.vision_input import GameVisionInputProvider

    root = Path(__file__).resolve().parents[1]
    package = build_verified_game(root / "candidates/game1-voice-s2", tmp_path / "candidate.vvg",
                                  target_build_id=0xC0060900)
    library = AssetLibrary(tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0)
    library.install_file(package.path, item_id="voice-game", display_name="Voice", kind=LibraryKind.GAME,
                         target_build_id=0xC0060900)
    session, sink = _Session(), _Sink()
    session.build_id = 0xC0060900
    voices = []

    class Voice:
        def __init__(self, *, bus, stop_requested):
            self.bus, self.stop_requested = bus, stop_requested
            self.state = "IDLE"
            self.epoch = uuid.uuid4().hex
            voices.append(self)

        def prepare(self):
            self.bus.begin_epoch("producer", self.epoch)
            self.state = "READY"

        def start(self):
            assert backend._game.input_consumptions["presented_frames"] >= 1
            self.state = "RUNNING"

        def stop(self):
            self.bus.invalidate("source stopped", status="STOPPED")
            self.state = "STOPPED"

        def status(self):
            return {"state": self.state, "owner_released": self.state == "STOPPED", "first_error": None}

        def observation(self):
            from pynq_multimodal_game.agent.voice_backend import VoiceSupervisor
            observed = VoiceSupervisor(lambda: None, bus=self.bus).observation()
            observed["state"] = self.state
            return observed

    backend = C6IVoiceFusionRuntimeBackend(
        session, SharedVisionSupervisor(lambda _run: None, GameVisionInputProvider()), voice_factory=Voice,
        menu_fps=0, library=library, sink_factory=lambda *_args: sink)
    stages = []
    backend._diagnostic_startup_stage = stages.append
    backend.open()
    try:
        backend.start_game("voice-game")
        assert stages == ["game_worker_start_begin", "game_worker_ready", "game_first_input_begin",
                          "game_first_input_complete", "game_first_step_begin", "game_first_step_complete",
                          "game_first_scene_submit_begin", "game_first_scene_submit_complete",
                          "game_pause_begin", "game_pause_complete", "voice_capture_start_begin",
                          "voice_capture_start_complete", "game_audio_resume_begin", "game_audio_resume_complete"]
        assert len(voices) == 1 and voices[0].state == "RUNNING"
        assert backend.snapshot.profile == "C6I_VISION_VOICE_S3"
        backend.pause_game()
        assert voices[0].state == "STOPPED"
        backend.resume_game()
        assert len(voices) == 2 and voices[1].epoch != voices[0].epoch and voices[1].state == "RUNNING"
        backend.return_to_menu()
        assert voices[1].state == "STOPPED" and backend.mode is ShellMode.MENU
    finally:
        backend.close()


def test_schema3_action_candidate_runs_through_tcp_without_hardware(tmp_path):
    from pynq_multimodal_game.agent.transport import AgentClient, AgentServer
    from pynq_multimodal_game.game_validation import build_verified_game
    root = Path(__file__).resolve().parents[1]
    package = build_verified_game(root / "candidates/game1-voice-s2", tmp_path / "candidate.vvg")
    case = GameTestCase.load(root / "candidates/game1-voice-s2/tests/replays/s2-boundaries.json")
    session = _Session()
    session.build_id = 0xC0060800
    sink = _Sink()
    library = AssetLibrary(tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0)
    backend = C6IShellRuntimeBackend(session, menu_fps=0, library=library, sink_factory=lambda *_args: sink)
    backend.open()
    controller = AgentController(backend, upload_directory=tmp_path / "uploads")
    server = AgentServer(controller)
    server.start()
    client = AgentClient(*server.address)
    try:
        hello = client.connect()
        assert hello["supported_action_schemas"] == ["game-actions-v1"]
        assert hello["test_case_schema_versions"] == [1, 2, 3] and hello["input_schema_version"] == 2
        manifest = ArtifactManifest.for_path(package.path, artifact_kind="game.vvg",
                                             target_build_id=0xC0060800, abi_major=1, abi_minor=0)
        assert client.upload_file(package.path, manifest, upload_id="candidate")["ok"]
        installed = client.command("install", AgentCommand.LIBRARY_INSTALL, item_id="game1-voice-s2",
                       display_name="Voice Timed Guard S2", library_kind="game")
        assert installed["ok"], installed
        result = client.command("run", AgentCommand.LIBRARY_RUN, item_id="game1-voice-s2",
                                library_kind="game", test_case_json=case.to_json())
        assert result["ok"], result
        assert backend._game._thread is not None
        deadline = time.monotonic() + 5
        while not backend._game.test_complete and backend._game.last_error is None and time.monotonic() < deadline:
            threading.Event().wait(0.01)
        assert backend._game.last_error is None and backend._game.test_complete
        report = backend._game.test_report
        assert report["hardware_acceptance"] == "pending" and len(report["frames"]) == case.max_ticks + 1
        backend.stop()
    finally:
        client.close()
        server.close()
        controller.close()
        backend.close()


class _Session:
    build_id = BUILD_ID

    def open(self):  # type: ignore[no-untyped-def]
        return self


class _Sink:
    def __init__(self) -> None:
        self.palette_count = 0
        self.asset_count = 0
        self.tilemap_count = 0
        self.scene_count = 0
        self.closed = False
        self.close_count = 0
        self.presented = threading.Event()

    def upload_palette(self, _packet: bytes) -> None:
        self.palette_count += 1

    def upload_asset(self, _packet: bytes) -> None:
        self.asset_count += 1

    def upload_tilemap(self, _packet: bytes) -> None:
        self.tilemap_count += 1

    def submit_scene(self, _packet: bytes) -> None:
        self.scene_count += 1
        self.presented.set()

    def close(self) -> None:
        self.close_count += 1
        self.closed = True


def _control(*, x: float, y: float, seq: int = 0, fist: bool = False) -> ControlState:
    return ControlState(
        tick_id=seq,
        timestamp_ns=seq,
        gesture_source=ControlSource.REAL,
        gesture_seq=seq,
        hand_valid=True,
        hand_x=x,
        hand_y=y,
        direction=Direction.IDLE,
        fist_score=1.0 if fist else 0.0,
        fist_event=fist,
        voice_source=ControlSource.REAL,
        voice_seq=0,
        audio_valid=False,
        low_voice_active=False,
        high_voice_event=False,
        low_confidence=0.0,
        high_confidence=0.0,
    )


def _video(path: Path) -> ArtifactManifest:
    rgb = bytes((8, 16, 24)) * (S2V1_WIDTH * S2V1_HEIGHT)
    encode_rgb_frames([rgb], path)
    return ArtifactManifest.for_path(
        path,
        artifact_kind="video.s2v",
        target_build_id=BUILD_ID,
        abi_major=1,
        abi_minor=0,
    )


def test_shell_menu_polls_live_control() -> None:
    from pynq_multimodal_game.menu import HOME_TARGETS

    target = HOME_TARGETS[1]

    class Input:
        calls = 0

        def sample_menu_control(self, *, tick_id):
            self.calls += 1
            return _control(x=target.center_x * 2 / 319 - 1,
                            y=target.center_y * 2 / 179 - 1,
                            seq=1, fist=self.calls == 4)

    source = Input()
    sink = _Sink()
    shell = C6IShellRuntimeBackend(_Session(), menu_fps=60, live_input=source,
                                   sink_factory=lambda *_args: sink)
    shell.open()
    try:
        deadline = time.monotonic() + 2
        while shell.page is MenuPage.HOME and time.monotonic() < deadline:
            threading.Event().wait(.005)
        assert shell.page is MenuPage.GAMES
        assert source.calls >= 4
        assert shell.snapshot.last_error is None
    finally:
        shell.close()


@pytest.mark.parametrize("mode", [ShellMode.VIDEO, ShellMode.GAME])
def test_active_return_monitor_peeks_latest_hand_without_consuming_menu_action(mode) -> None:
    class Input:
        peeks = 0
        menu_samples = 0

        def peek_menu_control(self, *, tick_id=0):
            self.peeks += 1
            return replace(_control(x=12 * 2 / 319 - 1, y=12 * 2 / 179 - 1),
                           timestamp_ns=self.peeks * 1_000_000_000)

        def sample_menu_control(self, *, tick_id):
            self.menu_samples += 1
            raise AssertionError("return monitor must not consume menu actions")

    source = Input()
    shell = C6IShellRuntimeBackend(_Session(), menu_fps=0, live_input=source,
                                   sink_factory=lambda *_args: _Sink())
    shell.open()
    try:
        shell._mode = mode
        if mode is ShellMode.VIDEO:
            shell._video.stop = lambda: None
        deadline = time.monotonic() + 1
        while shell.mode is mode and time.monotonic() < deadline:
            threading.Event().wait(.01)
        assert shell.mode is ShellMode.MENU and shell.page is MenuPage.HOME
        assert source.peeks >= 3 and source.menu_samples == 0
    finally:
        shell.close()


def test_return_monitor_follows_input_provider_replaced_during_open() -> None:
    class Input:
        def __init__(self, inside: bool):
            self.inside = inside
            self.peeks = 0

        def peek_menu_control(self, *, tick_id=0):
            self.peeks += 1
            x = 12 if self.inside else 160
            return replace(_control(x=x * 2 / 319 - 1, y=12 * 2 / 179 - 1),
                           timestamp_ns=self.peeks * 1_000_000_000)

    first, replacement = Input(False), Input(True)
    shell = C6IShellRuntimeBackend(_Session(), menu_fps=0, live_input=first,
                                   sink_factory=lambda *_args: _Sink())
    shell.open()
    try:
        shell._live_input = replacement
        shell._mode = ShellMode.VIDEO
        shell._video.stop = lambda: None
        deadline = time.monotonic() + 1
        while shell.mode is ShellMode.VIDEO and time.monotonic() < deadline:
            threading.Event().wait(.01)
        assert shell.mode is ShellMode.MENU
        assert replacement.peeks >= 3
    finally:
        shell.close()


def test_shell_video_packets_draw_return_with_reserved_palette_bank(tmp_path: Path) -> None:
    import struct
    from pynq_multimodal_game.gpu_abi import unpack_resource_packet
    from pynq_multimodal_game.return_button import RETURN_COMMANDS

    class Sink(_Sink):
        def __init__(self):
            super().__init__()
            self.scenes = []
            self.palettes = []

        def upload_palette(self, packet):
            self.palettes.append(packet)
            super().upload_palette(packet)

        def submit_scene(self, packet):
            self.scenes.append(packet)
            super().submit_scene(packet)

    path = tmp_path / "video.s2v"
    manifest = _video(path)
    sink = Sink()
    shell = C6IShellRuntimeBackend(_Session(), menu_fps=0,
                                   sink_factory=lambda *_args: sink)
    shell.open()
    try:
        shell.stage_file(manifest, path)
        shell.activate()
        sink.presented.clear()
        shell.run()
        assert sink.presented.wait(2)
        assert struct.unpack_from("<I", sink.scenes[-1], 16)[0] == 3 + len(RETURN_COMMANDS)
        _, payload = unpack_resource_packet(sink.palettes[-1])
        assert struct.unpack_from("<I", payload, (15 * 16 + 5) * 4)[0] == 0x26C4D6
    finally:
        shell.close()


@pytest.mark.parametrize("kind", [LibraryKind.GAME, LibraryKind.VIDEO])
def test_visual_menu_launches_library_item_and_returns_without_replaying_confirmation(tmp_path, kind):
    library = AssetLibrary(tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0)
    if kind is LibraryKind.GAME:
        project = GameProject.create(tmp_path / "project", game_id="game1", display_name="Game1")
        asset = GamePackageBuilder().build(project.root, tmp_path / "game1.vvg").path
        item_id = "game1"
    else:
        asset = tmp_path / "video.s2v"
        _video(asset)
        item_id = "video"
    library.install_file(asset, item_id=item_id, display_name=item_id, kind=kind, target_build_id=BUILD_ID)
    source = VisionInputProvider(fist_enabled=True)
    shell = C6IShellRuntimeBackend(_Session(), menu_fps=60, live_input=source, library=library,
                                   sink_factory=lambda *_args: _Sink())
    frame_id = 0
    action_seq = 0

    def wait_until(predicate):
        deadline = time.monotonic() + 10
        while not predicate() and time.monotonic() < deadline:
            assert shell.snapshot.last_error is None
            threading.Event().wait(.005)
        assert predicate(), shell.snapshot

    def select(target):
        nonlocal frame_id, action_seq
        for stable, label in (("5", "PAPER"), ("0", "ROCK")):
            frame_id += 1
            action_seq += int(stable == "0")
            source.publish({"run_id": "menu", "server_age_ms": 0, "stable": stable, "rps": label,
                            "control": {"schema": "gesture-control-v1", "frame_id": frame_id,
                                        "action_event_seq": action_seq, "valid": True, "direction": "IDLE",
                                        "smooth_uv": [target.center_x * 2 / 319 - 1,
                                                      target.center_y * 2 / 179 - 1],
                                        "action_event": stable == "0",
                                        "action_kind": "HEURISTIC_OPEN_TO_FIST"}})
            if stable == "5":
                wait_until(lambda: shell._input.hovered_id == target.item_id)

    shell.open()
    try:
        category = "games" if kind is LibraryKind.GAME else "videos"
        select(next(target for target in shell._targets if target.item_id == category))
        page = MenuPage.GAMES if kind is LibraryKind.GAME else MenuPage.VIDEOS
        wait_until(lambda: shell.page is page)
        select(next(target for target in shell._targets if target.item_id == f"{kind.value}:{item_id}"))
        mode = ShellMode.GAME if kind is LibraryKind.GAME else ShellMode.VIDEO
        wait_until(lambda: shell.mode is mode)
        assert source.receipt.consumed_action_seq is None
        assert shell.snapshot.last_error is None
        shell.return_to_menu()
        assert shell.page is MenuPage.HOME and shell.mode is ShellMode.MENU
        select(next(target for target in shell._targets if target.item_id == "hand"))
        wait_until(lambda: shell.page is MenuPage.HAND_PLACEHOLDER)
        back = next(target for target in shell._targets if target.item_id == "back")
        point = _control(x=back.center_x * 2 / 319 - 1,
                         y=back.center_y * 2 / 179 - 1, seq=action_seq)
        frame_id += 1
        source.publish({"run_id": "menu", "server_age_ms": 0,
                        "control": {"schema": "gesture-control-v1", "frame_id": frame_id,
                                    "action_event_seq": action_seq, "valid": True,
                                    "direction": "IDLE", "smooth_uv": [point.hand_x, point.hand_y]}})
        wait_until(lambda: shell._input.hovered_id == "back")
        entered = shell._input._return_dwell.entered_ns
        assert entered is not None
        shell.handle_control(replace(point, timestamp_ns=entered + 2_000_000_000))
        wait_until(lambda: shell.page is MenuPage.HOME)
    finally:
        shell.close()


@pytest.mark.parametrize("supported", [False, True])
@pytest.mark.parametrize("requested", [None, False, True])
def test_shell_default_sink_overlap_option(monkeypatch, supported, requested):
    session = _Session()
    session.supports_upload_render_overlap = lambda: supported
    sink = _Sink()
    calls = []

    def create_sink(**kwargs):
        calls.append(kwargs)
        return sink

    monkeypatch.setattr("pynq_multimodal_game.agent.c6i_shell.C6IVideoSink", create_sink)
    shell = C6IShellRuntimeBackend(
        session, menu_fps=0, upload_render_overlap=requested,
    )
    shell.open()
    shell.close()
    assert calls == [{
        "session": session,
        "timeout_seconds": 2.0,
        "upload_render_overlap": supported if requested is None else requested,
    }]


@pytest.mark.parametrize("capability", [None, True, lambda: 1])
def test_shell_default_sink_requires_callable_confirmed_capability(monkeypatch, capability):
    session = _Session()
    if capability is not None:
        session.supports_upload_render_overlap = capability
    sink = _Sink()
    calls = []

    def create_sink(**kwargs):
        calls.append(kwargs)
        return sink

    monkeypatch.setattr("pynq_multimodal_game.agent.c6i_shell.C6IVideoSink", create_sink)
    shell = C6IShellRuntimeBackend(session, menu_fps=0)
    shell.open()
    shell.close()
    assert calls[0]["upload_render_overlap"] is False


@pytest.mark.parametrize("mode", [ShellMode.MENU, ShellMode.GAME])
def test_shell_close_drains_failure_still_closes_sink(tmp_path, monkeypatch, mode):
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from pynq_multimodal_game.agent.c6i_shell import _BorrowedSink

    sink = _Sink()
    shell = C6IShellRuntimeBackend(
        _Session(), menu_fps=0, sink_factory=lambda _session, _timeout: sink,
    )
    shell.open()
    first_error = RuntimeError("drain failed")

    def fail_drain():
        raise first_error

    monkeypatch.setattr(sink, "drain", fail_drain, raising=False)
    if mode is ShellMode.GAME:
        project = GameProject.create(
            tmp_path / "project", game_id="close-game", display_name="Close Game",
        )
        package = GamePackageBuilder().build(project.root, tmp_path / "close-game.vvg")
        shell._game = PackagedGameRuntime(package.path, _BorrowedSink(sink))
        shell._mode = mode
    video_close = shell._video.close
    video_calls = []

    def close_video():
        video_calls.append(True)
        video_close()
        raise RuntimeError("secondary video cleanup failure")

    monkeypatch.setattr(shell._video, "close", close_video)
    with pytest.raises(RuntimeError) as caught:
        shell.close()
    assert caught.value is first_error
    assert video_calls == [True]
    assert shell._menu_thread is None
    assert shell._game is None
    assert shell._sink is None
    assert sink.close_count == 1
    monkeypatch.setattr(shell._video, "close", video_close)
    shell.close()
    assert sink.close_count == 1


@pytest.mark.parametrize("secondary_failure", [None, "cleanup", "menu"])
def test_game_start_failure_preserves_first_error_and_reports_error(monkeypatch, tmp_path, secondary_failure):
    from types import SimpleNamespace

    original = RuntimeError("asset accepted count timeout: expected 2, got 1")
    games = []

    class Game:
        running = False
        _thread = None
        cleanup_fails = secondary_failure == "cleanup"

        def __init__(self, *_args, **_kwargs):
            self.stops = 0
            games.append(self)

        def start(self):
            raise original

        def stop(self):
            self.stops += 1
            if self.cleanup_fails:
                raise RuntimeError("game cleanup failed")

    sink = _Sink()
    shell = C6IShellRuntimeBackend(_Session(), menu_fps=0, sink_factory=lambda *_args: sink)
    shell.open()
    shell._game_ids = ("game2",)
    package = GamePackageBuilder().build(Path(__file__).resolve().parents[1] / "games/game2", tmp_path / "game2.vvg")
    shell._game_entries = {"game2": SimpleNamespace(asset=package.path)}
    monkeypatch.setattr("pynq_multimodal_game.agent.c6i_shell.PackagedGameRuntime", Game)
    resumed = []

    def resume():
        resumed.append(True)
        if secondary_failure == "menu":
            raise RuntimeError("menu recovery failed")

    monkeypatch.setattr(shell, "_resume_menu", resume)
    try:
        with pytest.raises(RuntimeError) as caught:
            shell.start_game("game2")
        assert caught.value is original
        assert games[0].stops == 1
        assert shell.snapshot.state is AgentState.ERROR
        assert "asset accepted count timeout: expected 2, got 1" in shell.snapshot.last_error
        assert (shell._game is games[0]) is (secondary_failure == "cleanup")
        assert resumed == ([] if secondary_failure == "cleanup" else [True])
        if secondary_failure is not None:
            assert secondary_failure in shell.snapshot.last_error
    finally:
        if games:
            games[0].cleanup_fails = False
        shell.close()


def test_shell_close_retains_sink_when_dma_cannot_halt(monkeypatch):
    sink = _Sink()
    shell = C6IShellRuntimeBackend(
        _Session(), menu_fps=0, sink_factory=lambda _session, _timeout: sink,
    )
    shell.open()
    close_sink = sink.close

    def fail_close():
        raise RuntimeError("DMA did not halt")

    monkeypatch.setattr(sink, "close", fail_close)
    with pytest.raises(RuntimeError, match="DMA did not halt"):
        shell.close()
    assert shell._sink is sink
    assert sink.closed is False
    monkeypatch.setattr(sink, "close", close_sink)
    shell.close()
    assert shell._sink is None
    assert sink.close_count == 1


@pytest.mark.parametrize("worker", ["menu", "game", "video"])
def test_shell_close_retains_sink_until_worker_stops(worker):
    class WorkerThread:
        alive = True

        def join(self, timeout):
            pass

        def is_alive(self):
            return self.alive

    thread = WorkerThread()

    class Game:
        _thread = thread
        running = False
        last_error = "worker failed"

        def stop(self):
            if thread.is_alive():
                raise RuntimeError("packaged game thread did not stop before timeout")
            self._thread = None

    sink = _Sink()
    shell = C6IShellRuntimeBackend(
        _Session(), menu_fps=0, sink_factory=lambda _session, _timeout: sink,
    )
    shell.open()
    if worker == "menu":
        shell._menu_thread = thread
    elif worker == "game":
        shell._game = Game()
        shell._mode = ShellMode.GAME
    else:
        shell._video._thread = thread
        shell._mode = ShellMode.VIDEO
    with pytest.raises(RuntimeError, match="did not stop before timeout"):
        shell.close()
    assert shell._sink is sink
    assert sink.close_count == 0
    if worker == "menu":
        assert shell._menu_thread is thread
    elif worker == "game":
        assert shell._game._thread is thread
    else:
        assert shell._video._thread is thread
    thread.alive = False
    shell.close()
    assert shell._sink is None
    assert sink.close_count == 1


def test_shell_starts_in_menu_and_navigates_placeholder_pages(tmp_path: Path) -> None:
    sink = _Sink()
    shell = C6IShellRuntimeBackend(
        _Session(),  # type: ignore[arg-type]
        menu_fps=0,
        library=AssetLibrary(
            tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0
        ),
        sink_factory=lambda _session, _timeout: sink,
    )
    try:
        shell.open()
        assert shell.mode is ShellMode.MENU
        assert shell.page is MenuPage.HOME
        assert shell.snapshot.state is AgentState.IDLE
        assert shell.snapshot.runtime_mode == "menu"
        assert sink.asset_count == 1
        assert sink.palette_count == 1
        assert sink.tilemap_count == 1
        assert sink.scene_count == 1

        for seq in range(3):
            shell.handle_control(_control(x=-0.42, y=0.47, seq=seq))
        assert shell.handle_control(
            _control(x=-0.42, y=0.47, seq=3, fist=True)
        ) == "hand"
        assert shell.page is MenuPage.HAND_PLACEHOLDER
        assert shell.mode is ShellMode.HAND_PLACEHOLDER
        assert sink.asset_count == 2
        assert sink.palette_count == 2
        assert sink.tilemap_count == 2
        assert sink.scene_count == 2
    finally:
        shell.close()
    assert sink.closed is True


def test_opt_in_startup_screen_runs_ordered_checks_before_menu(tmp_path: Path) -> None:
    from pynq_multimodal_game.startup_ui import CheckState

    operations = []
    sink = _Sink()

    def check(name):
        operations.append(name)
        return True

    shell = C6IShellRuntimeBackend(
        _Session(), menu_fps=0,
        library=AssetLibrary(tmp_path / "library", minimum_free_bytes=0,
                             minimum_free_fraction=0),
        sink_factory=lambda *_args: sink,
        startup_vision=lambda: check("vision"),
        startup_hand=lambda: check("hand"),
    )
    try:
        shell.open()
        assert operations == ["vision", "hand"]
        assert shell.startup_snapshot.states == (CheckState.OK,) * 4
        assert shell.page is MenuPage.HOME and shell.mode is ShellMode.MENU
        assert (sink.asset_count, sink.palette_count, sink.tilemap_count) == (2, 2, 2)
        assert sink.scene_count == 10  # initial + two transitions per check + home
    finally:
        shell.close()


def test_opt_in_startup_failure_keeps_failure_screen_and_skips_hand() -> None:
    from pynq_multimodal_game.startup_ui import CheckState

    sink = _Sink()
    hand_called = []

    def fail_vision():
        raise RuntimeError("camera unavailable")

    shell = C6IShellRuntimeBackend(
        _Session(), menu_fps=0, sink_factory=lambda *_args: sink,
        startup_vision=fail_vision,
        startup_hand=lambda: hand_called.append(True),
    )
    try:
        with pytest.raises(RuntimeError, match="camera unavailable"):
            shell.open()
        assert shell.startup_snapshot.states == (CheckState.OK, CheckState.OK,
                                                 CheckState.FAIL, CheckState.WAIT)
        assert not hand_called and not shell._menu_active
        assert sink.scene_count == 7
    finally:
        shell.close()


def test_borrowed_sink_forwards_optional_tickets_without_owning_sink():
    from pynq_multimodal_game.agent.c6i_shell import _BorrowedSink
    from test_game_testing import _TicketSink

    sink = _TicketSink()
    borrowed = _BorrowedSink(sink)
    assert borrowed.upload_render_overlap_enabled is True
    ticket = borrowed.enqueue_scene(b"scene")
    borrowed.wait_scene(ticket)
    borrowed.drain()
    borrowed.close()
    assert sink.operations == [
        ("enqueue", b"scene"), ("wait", b"scene"), ("drain", None),
    ]
    synchronous = _BorrowedSink(_Sink())
    assert synchronous.upload_render_overlap_enabled is False
    assert getattr(synchronous, "enqueue_scene", None) is None


def test_shell_drains_shared_sink_before_mode_resource_uploads():
    from test_game_testing import _TicketSink

    class SharedSink(_TicketSink):
        def drain(self):
            while self.pending:
                self.wait_scene(self.pending[0])
            super().drain()

        def close(self):
            self.operations.append(("close", None))

    sink = SharedSink()
    shell = C6IShellRuntimeBackend(
        _Session(), menu_fps=0, sink_factory=lambda _session, _timeout: sink,
    )
    try:
        shell.open()
        sink.enqueue_scene(b"pending")
        shell._stop_menu()
        assert not sink.pending
        sink.enqueue_scene(b"pending-again")
        shell._resume_menu()
        assert not sink.pending
        operations = sink.operations
        index = operations.index(("wait", b"pending-again"))
        assert operations[index + 1][0] == "drain"
        assert operations[index + 2][0] == "asset"
    finally:
        shell.close()


def test_shell_runs_installed_video_then_restores_menu(tmp_path: Path) -> None:
    source = tmp_path / "fixture.s2v"
    _video(source)
    library = AssetLibrary(
        tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0
    )
    library.install_file(
        source,
        item_id="fixture",
        display_name="Fixture",
        kind=LibraryKind.VIDEO,
        target_build_id=BUILD_ID,
    )
    sink = _Sink()
    shell = C6IShellRuntimeBackend(
        _Session(),  # type: ignore[arg-type]
        menu_fps=0,
        library=library,
        sink_factory=lambda _session, _timeout: sink,
    )
    try:
        shell.open()
        assert shell.stage_library_video("fixture").state is AgentState.STAGED
        assert shell.activate().state is AgentState.ACTIVE
        sink.presented.clear()
        assert shell.run().state is AgentState.RUNNING
        assert sink.presented.wait(1.0)
        assert shell.mode is ShellMode.VIDEO

        stopped = shell.stop()
        assert stopped.state is AgentState.IDLE
        assert stopped.runtime_mode == "menu"
        assert shell.mode is ShellMode.MENU
        assert sink.asset_count >= 3
        assert sink.palette_count >= 3
    finally:
        shell.close()


def test_shell_does_not_expose_uninstalled_c1_demo(tmp_path: Path) -> None:
    sink = _Sink()
    shell = C6IShellRuntimeBackend(
        _Session(),  # type: ignore[arg-type]
        menu_fps=0,
        sink_factory=lambda _session, _timeout: sink,
    )
    try:
        shell.open()
        with pytest.raises(KeyError, match="not installed"):
            shell.start_game("c1-demo")
        assert shell.mode is ShellMode.MENU
        assert shell.page is MenuPage.HOME
    finally:
        shell.close()


def test_agent_installs_lists_replays_and_removes_staged_video(tmp_path: Path) -> None:
    source = tmp_path / "fixture.s2v"
    manifest = _video(source)
    library = AssetLibrary(
        tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0
    )
    shell = C6IShellRuntimeBackend(
        _Session(),  # type: ignore[arg-type]
        menu_fps=0,
        library=library,
        sink_factory=lambda _session, _timeout: _Sink(),
    )
    controller = AgentController(shell, upload_directory=tmp_path / "uploads")
    try:
        shell.open()
        shell.stage_file(manifest, source)
        before_generation = shell.snapshot.catalog_generation
        installed = controller.execute(
            "install",
            AgentCommand.LIBRARY_INSTALL,
            item_id="fixture",
            display_name="Fixture Video",
            library_kind="video",
        )
        replayed = controller.execute(
            "install",
            AgentCommand.LIBRARY_INSTALL,
            item_id="fixture",
            display_name="Fixture Video",
            library_kind="video",
        )
        listed = controller.execute(
            "list",
            AgentCommand.LIBRARY_LIST,
            library_kind="video",
        )

        assert installed.ok is True
        assert installed.library_items is not None
        assert installed.library_items[0].display_name == "Fixture Video"
        assert replayed.replayed is True
        assert replayed.library_items == installed.library_items
        assert listed.library_items == installed.library_items
        assert shell.snapshot.catalog_generation == before_generation + 1

        running = controller.execute(
            "run-library",
            AgentCommand.LIBRARY_RUN,
            item_id="fixture",
            library_kind="video",
        )
        assert running.ok is True
        assert running.state is AgentState.RUNNING
        assert controller.execute(
            "stop-library", AgentCommand.STOP
        ).snapshot.runtime_mode == "menu"

        removed = controller.execute(
            "remove",
            AgentCommand.LIBRARY_REMOVE,
            item_id="fixture",
            library_kind="video",
        )
        assert removed.ok is True
        assert removed.library_items == ()
        assert shell.snapshot.catalog_generation == before_generation + 2
    finally:
        controller.close()
        shell.close()


def test_agent_installs_runs_and_controls_packaged_game(tmp_path: Path) -> None:
    project = GameProject.create(
        tmp_path / "project", game_id="agent-game", display_name="Agent Game"
    )
    package = GamePackageBuilder().build(project.root, tmp_path / "agent-game.vvg")
    manifest = ArtifactManifest.for_path(
        package.path,
        artifact_kind="game.vvg",
        target_build_id=BUILD_ID,
        abi_major=1,
        abi_minor=0,
    )
    library = AssetLibrary(
        tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0
    )
    sink = _Sink()
    shell = C6IShellRuntimeBackend(
        _Session(),  # type: ignore[arg-type]
        menu_fps=0,
        library=library,
        sink_factory=lambda _session, _timeout: sink,
    )
    controller = AgentController(shell, upload_directory=tmp_path / "uploads")
    try:
        shell.open()
        assert shell.stage_file(manifest, package.path).state is AgentState.STAGED
        installed = controller.execute(
            "game-install",
            AgentCommand.LIBRARY_INSTALL,
            item_id="agent-game",
            display_name="Agent Game",
            library_kind="game",
        )
        assert installed.ok is True
        assert installed.library_items is not None
        assert installed.library_items[0].kind == "game"
        shell._select_page_locked(MenuPage.GAMES)
        assert shell._labels == ("Agent Game", "GAME 2", "GAME 3", "COMING SOON")

        running = controller.execute(
            "game-run",
            AgentCommand.LIBRARY_RUN,
            item_id="agent-game",
            library_kind="game",
        )
        assert running.ok is True
        assert running.snapshot.runtime_mode == "game"
        injected = controller.execute(
            "game-input",
            AgentCommand.INPUT_INJECT,
            x=80,
            y=60,
            fist=True,
            frequency_hz=440.0,
            duration_ms=250,
            input_id="manual-input-1",
        )
        assert injected.ok is True
        assert injected.snapshot.accepted_input_id == "manual-input-1"
        paused = controller.execute("game-pause", AgentCommand.GAME_PAUSE)
        assert paused.ok is True
        assert paused.state is AgentState.PAUSED
        tick_before_step = paused.snapshot.game_tick
        stepped = controller.execute("game-step", AgentCommand.GAME_STEP)
        assert stepped.ok is True
        assert stepped.state is AgentState.PAUSED
        assert sink.presented.wait(2.0)
        resumed = controller.execute("game-resume", AgentCommand.GAME_RESUME)
        assert resumed.ok is True
        assert resumed.state is AgentState.RUNNING
        assert tick_before_step is not None
        assert controller.execute(
            "game-input-cancel", AgentCommand.INPUT_CANCEL
        ).ok is True
        reset = controller.execute("game-reset", AgentCommand.GAME_RESET)
        assert reset.ok is True
        assert reset.snapshot.runtime_mode == "game"
        assert reset.snapshot.game_tick is not None
        assert controller.execute("game-stop", AgentCommand.STOP).snapshot.runtime_mode == "menu"
        initialized = controller.execute(
            "shell-init", AgentCommand.SHELL_INITIALIZE
        )
        assert initialized.ok is True
        assert initialized.snapshot.runtime_mode == "menu"

        removed = controller.execute(
            "game-remove",
            AgentCommand.LIBRARY_REMOVE,
            item_id="agent-game",
            library_kind="game",
        )
        assert removed.library_items == ()
    finally:
        controller.close()
        shell.close()


def test_packaged_game_runs_uploaded_test_case(tmp_path: Path) -> None:
    project = GameProject.create(
        tmp_path / "project", game_id="timeline-game", display_name="Timeline Game"
    )
    package = GamePackageBuilder().build(project.root, tmp_path / "timeline-game.vvg")
    library = AssetLibrary(
        tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0
    )
    shell = C6IShellRuntimeBackend(
        _Session(),  # type: ignore[arg-type]
        menu_fps=0,
        library=library,
        sink_factory=lambda _session, _timeout: _Sink(),
        live_input=VisionInputProvider(),
    )
    controller = AgentController(shell, upload_directory=tmp_path / "uploads")
    test_case = GameTestCase(
        test_id="pynq-timeline",
        name="PYNQ timeline",
        max_ticks=1,
        events=(
            InputEvent(
                tick=0,
                kind=InputKind.FIST,
                event_id="fist-0",
                x=80,
                y=60,
            ),
        ),
        assertions=(
            AssertionRule(
                tick=0,
                field="values.x",
                operator=AssertionOperator.EQUAL,
                expected=80,
            ),
            AssertionRule(
                tick=1,
                field="tick_id",
                operator=AssertionOperator.EQUAL,
                expected=1,
            ),
        ),
    )
    try:
        shell.open()
        manifest = ArtifactManifest.for_path(
            package.path,
            artifact_kind="game.vvg",
            target_build_id=BUILD_ID,
            abi_major=1,
            abi_minor=0,
        )
        shell.stage_file(manifest, package.path)
        controller.execute(
            "timeline-install",
            AgentCommand.LIBRARY_INSTALL,
            item_id="timeline-game",
            display_name="Timeline Game",
            library_kind="game",
        )
        controller.execute(
            "timeline-run",
            AgentCommand.LIBRARY_RUN,
            item_id="timeline-game",
            library_kind="game",
            test_case_json=test_case.to_json(),
        )
        assert shell._game is not None
        assert shell._game._live_input is None

        deadline = time.monotonic() + 2.0
        while not shell.snapshot.test_complete and time.monotonic() < deadline:
            threading.Event().wait(0.01)
        snapshot = shell.snapshot

        assert snapshot.state is AgentState.PAUSED
        assert snapshot.game_tick == 1
        assert snapshot.accepted_input_id == "fist-0"
        assert snapshot.consumed_input_id == "fist-0"
        assert snapshot.assertions_passed == 2
        assert snapshot.assertions_failed == 0
        from pynq_multimodal_game.game_validation import compare_test_reports, run_game_test

        pc_report = run_game_test(package.path, test_case)
        assert snapshot.game_test_report is not None
        comparison = compare_test_reports(pc_report.to_dict(), dict(snapshot.game_test_report))
        assert comparison["status"] == "passed", comparison
        assert comparison["matched_ticks"] == 2
        assert snapshot.game_test_report["hardware_acceptance"] == "pending"
    finally:
        controller.close()
        shell.close()


@pytest.mark.parametrize("with_live_input", [False, True, "games"])
def test_shell_discovers_and_runs_installed_vvg_game(tmp_path: Path, monkeypatch, with_live_input) -> None:
    project = GameProject.create(
        tmp_path / "project", game_id="packaged", display_name="Packaged"
    )
    package = GamePackageBuilder().build(project.root, tmp_path / "packaged.vvg")
    staged_package = tmp_path / "upload-staging"
    staged_package.write_bytes(package.path.read_bytes())
    library = AssetLibrary(
        tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0
    )
    library.install_file(
        staged_package,
        item_id="packaged",
        display_name="Packaged",
        kind=LibraryKind.GAME,
        target_build_id=BUILD_ID,
    )
    sink = _Sink()
    provider = VisionInputProvider(clock=lambda: 1.0) if with_live_input else None
    if with_live_input == "games":
        from pynq_multimodal_game.vision_input import GameVisionInputProvider
        provider = GameVisionInputProvider(clock=lambda: 1.0)
    samples = []
    if provider is not None:
        sampler = "sample_for_game" if with_live_input == "games" else "sample_with_receipt"
        sample = getattr(provider, sampler)

        def record_sample(*args, **kwargs):
            value = sample(*args, **kwargs)
            samples.append(value[0])
            return value

        monkeypatch.setattr(provider, sampler, record_sample)
        provider.publish({"run_id": "local-vision", "server_age_ms": 0, "control": {
            "schema": "gesture-control-v1", "frame_id": 1, "action_event_seq": 0,
            "valid": True, "direction": "LEFT",
        }})
    shell = C6IShellRuntimeBackend(
        _Session(),  # type: ignore[arg-type]
        menu_fps=0,
        library=library,
        sink_factory=lambda _session, _timeout: sink,
        live_input=provider,
    )
    try:
        shell.open()
        shell.start_game("packaged")
        assert shell.mode is ShellMode.GAME
        assert shell.snapshot.state is AgentState.RUNNING
        assert sink.presented.wait(2.0)
        assert shell._game is not None
        assert shell._game._live_input is provider
        if provider is not None:
            assert samples[0].tick_id == 0
            assert samples[0].hand_valid and samples[0].hand_x == -1.0
            receipt = shell.snapshot.vision_consumption
            assert receipt["run_id"] == "local-vision" and receipt["source_frame_id"] == 1
            assert receipt["sample_tick"] == receipt["scene_tick"]
            assert receipt["sink_completion"] == "confirmed"
            if with_live_input == "games":
                assert receipt["game_id"] == "packaged"
            with pytest.raises(RuntimeError, match="does not accept test injection"):
                shell._game.inject_test_input(x=80, y=60)
        shell.handle_control(_control(x=0.25, y=-0.5, seq=7, fist=True))

        restored = shell.return_to_menu()
        assert restored.runtime_mode == "menu"
        assert restored.state is AgentState.IDLE
        assert sink.asset_count >= 3
        assert sink.palette_count >= 3
        assert sink.tilemap_count >= 3
    finally:
        shell.close()


@pytest.mark.parametrize("game_id", ["game1", "game2", "game3"])
@pytest.mark.parametrize("with_audio", [False, True])
def test_native_spawn_routes_validated_game_and_confirms_local_receipt(tmp_path, game_id, with_audio):
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from pynq_multimodal_game.vision_input import GameVisionInputProvider

    project = Path(__file__).resolve().parents[1] / "games" / game_id
    package = GamePackageBuilder().build(project, tmp_path / (game_id + ".vvg"),
                                        target_build_id=0xC0060800)
    provider = GameVisionInputProvider(clock=lambda: 1.0)
    provider.publish({"run_id": "native", "frame": 1, "server_age_ms": 0,
                      "stable": "5", "rps": "PAPER", "control": {
                          "schema": "gesture-control-v1", "frame_id": 1,
                          "action_event_seq": 0, "valid": True,
                          "direction": "UP" if game_id == "game1" else "RIGHT"}})
    if with_audio:
        import time
        from pynq_multimodal_game.multimodal_input import MultimodalGameInputProvider
        from pynq_multimodal_game.voice_observations import VoiceObservationBus, VoiceResultValidator
        bus = VoiceObservationBus()
        bus.begin_epoch("audio-native", "epoch")
        bus.publish(VoiceResultValidator("audio-native", "epoch").accept(
            ("result", 0, [], .001, time.monotonic())))
        provider = MultimodalGameInputProvider(provider, bus, max_audio_age_ns=60_000_000_000)
    sink = _Sink()
    runtime = PackagedGameRuntime(package.path, sink, generation=1, live_input=provider)
    try:
        runtime.start()
        assert sink.presented.wait(2.0)
        inputs = runtime.input_consumptions
        receipt = inputs["vision"]
        assert receipt["game_id"] == game_id and receipt["run_id"] == "native"
        assert receipt["source_frame_id"] == 1 and receipt["sink_completion"] == "confirmed"
        assert receipt["sample_tick"] == receipt["scene_tick"]
        if game_id == "game2":
            assert receipt["hand_gesture"] == "paper" and receipt["hand_x"] == receipt["hand_y"] == 0
        else:
            assert receipt["hand_y"] == (-1.0 if game_id == "game1" else 0.0)
        if with_audio:
            audio = inputs["audio"]
            assert audio["source_status"] == "RUNNING" and audio["producer_run"] == "audio-native"
            assert audio["scene_tick"] == receipt["scene_tick"] and not audio["action_mapped"]
            assert audio["scene_sha256"] == receipt["scene_sha256"]
        else:
            assert inputs["audio"] is None
    finally:
        runtime.stop()


@pytest.mark.parametrize("fail_submission", [False, True])
@pytest.mark.parametrize("pipeline", [False, True])
def test_volume_receipt_is_published_only_after_matching_scene_completion(fail_submission, pipeline):
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from test_game_testing import _TicketSink

    class VolumeSink(_Sink):
        def submit_scene(self, packet):
            if fail_submission:
                raise RuntimeError("volume scene submission failed")
            super().submit_scene(packet)

    class VolumeTicketSink(_TicketSink):
        def wait_scene(self, ticket):
            if fail_submission:
                raise RuntimeError("volume scene submission failed")
            super().wait_scene(ticket)

    receipt = {"schema": "volume-input-receipt-v1", "game_run": "volume-run",
               "sample_tick": 7, "sample_timestamp_ns": 100,
               "signal": None, "hardware_acked": False, "logic_consumed": False,
               "source_receipt": None}
    runtime = PackagedGameRuntime(Path("unused-volume.vvg"), VolumeTicketSink() if pipeline else VolumeSink())
    runtime._game_run = "volume-run"
    runtime._manifest = SimpleNamespace(inputs=None, volume_inputs=object())
    runtime._live_input = SimpleNamespace(volume_receipt_for_tick=lambda _tick: receipt)
    frame = SimpleNamespace(snapshot=SimpleNamespace(tick_id=7, status="RUNNING", score=0,
                                                     values={"volume_effect": "none"}),
                            scene_sha256="volume-scene", scene_packet=b"scene",
                            asset_packet=None, palette_packet=None, tilemap_packet=None)
    try:
        assert runtime._sample_audio_receipt(7) == receipt
        assert runtime.input_consumptions.get("volume") is None
        if pipeline:
            runtime._submit(frame, audio_receipt=receipt)
            assert runtime.input_consumptions.get("volume") is None
            assert runtime.presented_frames == 0
        if fail_submission:
            with pytest.raises(RuntimeError, match="volume scene submission failed"):
                runtime._drain() if pipeline else runtime._submit(frame, audio_receipt=receipt)
            assert runtime.input_consumptions.get("volume") is None
            assert runtime.presented_frames == 0
        else:
            runtime._drain() if pipeline else runtime._submit(frame, audio_receipt=receipt)
            completed = runtime.input_consumptions["volume"]
            assert completed["sample_tick"] == completed["scene_tick"] == 7
            assert completed["scene_sha256"] == "volume-scene"
            assert completed["sink_completion"] == "confirmed"
            assert completed["hardware_acked"] is False and completed["logic_consumed"] is False
            assert completed["logic_executed"] is True
            assert completed["game_effects"] == {"volume_effect": "none"}
            assert runtime.input_consumptions["audio"] is None
    finally:
        runtime._preview.stop()


@pytest.mark.parametrize("corrupt", ["game_run", "sample_tick", "sample_timestamp_ns", "signal", "expires"])
def test_volume_runtime_rejects_receipt_that_does_not_bind_actual_input(corrupt):
    from dataclasses import asdict
    from types import SimpleNamespace
    import time
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from pynq_multimodal_game.game_sdk import GameInput, VolumeSignal

    signal = VolumeSignal("a" * 32, 1, 1, "SOFT", 977, 1)
    value = GameInput(7, 100, False, 0.0, 0.0, 0, False, volume=signal)
    source = {"signal": asdict(signal), "sample_tick": 7, "hardware_acked": True,
              "disposition": "consumed", "expires": time.monotonic() + 0.1}
    receipt = {"schema": "volume-input-receipt-v1", "game_run": "volume-run",
               "sample_tick": 7, "sample_timestamp_ns": 100, "signal": asdict(signal),
               "hardware_acked": True, "logic_consumed": True, "source_receipt": source}
    runtime = PackagedGameRuntime(Path("unused-volume.vvg"), _Sink())
    runtime._manifest = SimpleNamespace(inputs=None, volume_inputs=object())
    runtime._game_run = "volume-run"
    runtime._live_input = object()
    try:
        assert runtime._validate_actions(value, receipt) == (value, receipt)
        if corrupt == "expires":
            source["expires"] = time.monotonic() - 1
        else:
            receipt[corrupt] = None
        with pytest.raises(ValueError, match="volume"):
            runtime._validate_actions(value, receipt)
        assert runtime.presented_frames == 0
    finally:
        runtime._preview.stop()


@pytest.mark.parametrize("input_mode", ["visual", "audio", "volume-soft", "volume-loud"])
def test_fused_vision_game_scene_receipt_over_real_tcp(tmp_path: Path, monkeypatch, input_mode) -> None:
    import hashlib
    import importlib.util
    import time
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.transport import AgentClient, AgentServer
    from pynq_multimodal_game.agent.vision_backend import C6IVisionRuntimeBackend, C6IVolumeRuntimeBackend, SharedVisionSupervisor
    from pynq_multimodal_game.volume_input import VolumeEventLatch
    from pynq_multimodal_game.vision_input import GameVisionInputProvider
    from test_volume_monitor import volume_fixture

    with_audio, with_volume = input_mode == "audio", input_mode.startswith("volume-")
    fusion_id = 0xC0060C00 if with_volume else 0xC0060800
    root = Path(__file__).resolve().parents[1]
    project = root / "games/game1"
    if with_volume:
        spec = importlib.util.spec_from_file_location("tcp_volume_builder", root / "candidates/volume-v1/build.py")
        builder = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(builder)
        project = builder.stage_project("game1", tmp_path / "volume-project")
    package = GamePackageBuilder().build(project, tmp_path / "game1.vvg", target_build_id=fusion_id)
    library = AssetLibrary(tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0)
    library.install_file(package.path, item_id="game1", display_name="Game 1", kind=LibraryKind.GAME,
                         target_build_id=fusion_id)
    provider = (GameVisionInputProvider if with_volume else VisionInputProvider)(clock=lambda: 1.0)

    class Volume:
        offered = None

        def __init__(self):
            self.acks = []
            control = SimpleNamespace(monitor=self.monitor, event=lambda: self.offered, acknowledge=self.acknowledge)
            self.latch = VolumeEventLatch(control, producer_run="a" * 32)

        def monitor(self):
            event = None if self.offered is None else {
                name: getattr(self.offered, name) for name in ("kind", "epoch", "sequence", "source_sample", "source_window")}
            return volume_fixture(event=None if event is None else {**event, "age_ms": 0})

        def acknowledge(self, event):
            assert event is self.offered
            self.acks.append(event)
            self.offered = None

        def open(self):
            self.latch.release()

        def close(self):
            self.latch.release()

        def status(self):
            return {"error": self.latch.status()["error"], "sampling_enabled": True}

        def offer(self, kind):
            self.offered = SimpleNamespace(kind=kind, epoch=1, sequence=1, source_sample=7816,
                                           source_window=8, expires=time.monotonic() + 0.1)
            assert self.latch.poll_once(), self.latch.status()

    class Worker:
        state = "IDLE"
        error = diagnostic_error = None
        frame_id = 7

        def __init__(self, run_id):
            self.run_id = run_id

        def start(self):
            self.state = "RUNNING"
            provider.publish({"run_id": self.run_id, "server_age_ms": 0, "control": {
                "schema": "gesture-control-v1", "frame_id": self.frame_id, "action_event_seq": 0,
                "valid": True, "direction": "RIGHT"}})

        def stop(self):
            self.state = "STOPPED"

    class CapturingSink(_Sink):
        def __init__(self):
            super().__init__()
            self.packets = []

        def submit_scene(self, packet):
            self.packets.append(bytes(packet))
            super().submit_scene(packet)

    session = _Session()
    session.build_id = fusion_id
    sink = CapturingSink()
    supervisor = SharedVisionSupervisor(Worker, provider)
    volume = Volume() if with_volume else None
    options = {"volume_factory": lambda _owner: volume} if with_volume else {}
    backend = (C6IVolumeRuntimeBackend if with_volume else C6IVisionRuntimeBackend)(
        session, supervisor, menu_fps=0, library=library, sink_factory=lambda _session, _timeout: sink, **options)
    if with_audio:
        from pynq_multimodal_game.multimodal_input import MultimodalGameInputProvider
        from pynq_multimodal_game.voice_observations import VoiceObservationBus, VoiceResultValidator
        bus = VoiceObservationBus()
        bus.begin_epoch("audio-tcp", "epoch")
        bus.publish(VoiceResultValidator("audio-tcp", "epoch").accept(
            ("result", 0, [], .001, time.monotonic())))
        backend._live_input = MultimodalGameInputProvider(provider, bus, max_audio_age_ns=60_000_000_000)
    backend.open()
    controller = AgentController(backend)
    server = AgentServer(controller)
    server.start()
    client = AgentClient(*server.address)
    try:
        hello = client.connect()
        profile = "C6I_VISION_VOLUME_V1" if with_volume else "C6I_VISION"
        assert hello["profile"] == profile and hello["build_id"] == fusion_id
        started = client.command("vision-start", AgentCommand.VISION_START)
        assert started["ok"] and started["snapshot"]["vision"]["state"] == "RUNNING"
        listed = client.command("library-list", AgentCommand.LIBRARY_LIST)
        assert listed["ok"]
        sink.presented.clear()
        running = client.command("live-run", AgentCommand.LIBRARY_RUN, item_id="game1", library_kind=LibraryKind.GAME.value)
        assert running["ok"], running
        assert sink.presented.wait(2.0)
        if with_volume:
            game = backend._game
            complete_scene = game._complete_scene
            def hold_event_scene(frame, visual, audio):
                complete_scene(frame, visual, audio)
                if audio is not None and audio.get("signal") is not None:
                    game.pause()
            monkeypatch.setattr(game, "_complete_scene", hold_event_scene)
            volume.offer("SOFT" if input_mode == "volume-soft" else "LOUD")
            deadline = time.monotonic() + 2
            while time.monotonic() < deadline:
                status = client.command("volume-status-" + str(time.monotonic_ns()), AgentCommand.STATUS)["snapshot"]
                consumed = status["volume_consumption"]
                if consumed is not None and consumed["signal"] is not None:
                    break
                threading.Event().wait(0.001)
            assert consumed is not None and consumed["signal"] is not None, status
            paused = client.command("hold-volume-frame", AgentCommand.GAME_PAUSE)
            assert paused["ok"], paused
            assert consumed["hardware_acked"] and consumed["logic_consumed"] and consumed["logic_executed"]
            assert consumed["sink_completion"] == "confirmed"
            assert consumed["game_effects"]["shield_active"] is (input_mode == "volume-soft")
            assert consumed["game_effects"]["attacks_fired"] == int(input_mode == "volume-loud")
            assert len(volume.acks) == 1
            assert consumed["scene_sha256"] == status["scene_sha256"]
        else:
            status = client.command("game-status", AgentCommand.STATUS)["snapshot"]
        receipt = status["vision_consumption"]
        assert status["profile"] == profile and status["runtime_mode"] == "game"
        assert status["game_values"]
        assert receipt["source_frame_id"] == 7 and receipt["run_id"] == supervisor.status()["run_id"]
        assert receipt["sample_tick"] == receipt["scene_tick"]
        assert receipt["sink_completion"] == "confirmed"
        if with_audio:
            audio = status["audio_consumption"]
            assert audio["source_status"] == "RUNNING" and audio["producer_run"] == "audio-tcp"
            assert audio["sample_tick"] == audio["scene_tick"] == receipt["scene_tick"]
            assert audio["scene_sha256"] == receipt["scene_sha256"] == status["scene_sha256"]
            assert audio["sink_completion"] == "confirmed" and audio["action_mapped"] is False
        else:
            assert status["audio_consumption"] is None
        assert status["scene_sha256"].upper() in {hashlib.sha256(packet).hexdigest().upper() for packet in sink.packets}
        client.close()
        assert client.connect()["build_id"] == fusion_id
        assert client.command("reconnect-status", AgentCommand.STATUS)["snapshot"]["vision"]["state"] == "RUNNING"
        assert client.command("game-stop", AgentCommand.STOP)["ok"]
        stopped = client.command("vision-stop", AgentCommand.VISION_STOP)
        assert stopped["ok"] and stopped["snapshot"]["vision"]["cleanup_confirmed"]
    finally:
        client.close()
        server.close()
        controller.close()
        backend.close()


def test_three_games_reuse_local_vision_and_gpu_sink_across_pause_stop_and_reconnect(
    tmp_path: Path, record_property,
) -> None:
    import hashlib
    import json
    from pynq_multimodal_game.agent.transport import AgentClient, AgentServer
    from pynq_multimodal_game.agent.vision_backend import C6IVisionRuntimeBackend, SharedVisionSupervisor
    from pynq_multimodal_game.vision_input import GameVisionInputProvider

    fusion_id = 0xC0060800
    root = Path(__file__).resolve().parents[1]
    library = AssetLibrary(tmp_path / "library", minimum_free_bytes=0, minimum_free_fraction=0)
    identities = {}
    for game_id in ("game1", "game2", "game3"):
        package = GamePackageBuilder().build(root / "games" / game_id, tmp_path / f"{game_id}.vvg",
                                             target_build_id=fusion_id)
        identities[game_id] = hashlib.sha256(package.path.read_bytes()).hexdigest()
        library.install_file(package.path, item_id=game_id, display_name=game_id, kind=LibraryKind.GAME,
                             target_build_id=fusion_id)
    provider = GameVisionInputProvider(clock=lambda: 1.0)
    workers = []

    class Worker:
        state = "IDLE"
        error = diagnostic_error = None
        frame_id = action_seq = 0

        def __init__(self, run_id):
            self.run_id = run_id
            workers.append(self)

        def feed(self, direction="RIGHT", stable="5", *, action=False):
            self.frame_id += 1
            self.action_seq += int(action)
            provider.publish({"run_id": self.run_id, "frame": self.frame_id, "server_age_ms": 0,
                              "stable": stable, "rps": {"0": "ROCK", "2": "SCISSORS", "5": "PAPER"}[stable],
                              "control": {"schema": "gesture-control-v1", "frame_id": self.frame_id,
                                          "action_event_seq": self.action_seq, "valid": True,
                                          "direction": direction, "action_event": action,
                                          "action_kind": "HEURISTIC_OPEN_TO_FIST"}})

        def start(self):
            self.state = "RUNNING"
            self.feed()

        def stop(self):
            self.state = "STOPPED"

    class Session(_Session):
        build_id = fusion_id
        open_count = 0

        def open(self):
            self.open_count += 1
            return super().open()

    class CapturingSink(_Sink):
        def __init__(self):
            super().__init__()
            self.packets = {}
            self.condition = threading.Condition()

        def submit_scene(self, packet):
            with self.condition:
                self.packets[hashlib.sha256(packet).hexdigest().upper()] = bytes(packet)
                super().submit_scene(packet)
                self.condition.notify_all()

    session = Session()
    sink = CapturingSink()
    supervisor = SharedVisionSupervisor(Worker, provider)
    backend = C6IVisionRuntimeBackend(session, supervisor, menu_fps=0, library=library,
                                      sink_factory=lambda _session, _timeout: sink)
    backend.open()
    controller = AgentController(backend)
    server = AgentServer(controller)
    server.start()
    client = AgentClient(*server.address)
    receipts = []

    def confirmed_receipt(game_id, frame_id):
        def matches():
            receipt = backend.snapshot.vision_consumption
            return (receipt is not None and receipt["game_id"] == game_id
                    and receipt["source_frame_id"] == frame_id and receipt["hand_valid"])

        with sink.condition:
            assert sink.condition.wait_for(matches, timeout=3.0), backend.snapshot
            receipt = dict(backend.snapshot.vision_consumption)
            assert receipt["sample_tick"] == receipt["scene_tick"]
            assert receipt["sink_completion"] == "confirmed"
            assert receipt["scene_sha256"].upper() in sink.packets
        receipts.append(receipt)
        return receipt

    try:
        assert client.connect()["build_id"] == fusion_id
        assert client.command("shared-vision-start", AgentCommand.VISION_START)["ok"]
        worker = workers[0]
        for game_id in ("game1", "game2", "game3"):
            direction, stable = ("UP", "2") if game_id == "game1" else ("RIGHT", "2" if game_id == "game2" else "5")
            worker.feed(direction, stable)
            started = client.command(f"{game_id}-run", AgentCommand.LIBRARY_RUN,
                                     item_id=game_id, library_kind=LibraryKind.GAME.value)
            assert started["ok"], started
            receipt = confirmed_receipt(game_id, worker.frame_id)
            assert receipt["run_id"] == worker.run_id
            assert receipt["hand_y"] == (-1.0 if game_id == "game1" else 0.0)
            assert receipt["hand_x"] == (1.0 if game_id == "game3" else 0.0)
            assert receipt["hand_gesture"] == ("scissors" if game_id == "game2" else None)
            assert receipt["game_values"]
            assert client.command(f"{game_id}-pause", AgentCommand.GAME_PAUSE)["ok"]
            worker.feed(direction, "0", action=True)
            assert not provider.sample(tick_id=0).hand_valid
            assert client.command(f"{game_id}-resume", AgentCommand.GAME_RESUME)["ok"]
            assert not provider.receipt.result.valid
            worker.feed(direction, stable)
            assert not confirmed_receipt(game_id, worker.frame_id)["action_consumed"]
            client.close()
            worker.feed(direction, stable)
            confirmed_receipt(game_id, worker.frame_id)
            assert client.connect()["build_id"] == fusion_id
            snapshot = client.command(f"{game_id}-reconnect", AgentCommand.STATUS)["snapshot"]
            assert snapshot["runtime_mode"] == "game"
            assert snapshot["vision"]["run_id"] == worker.run_id
            assert client.command(f"{game_id}-exit-paused", AgentCommand.GAME_PAUSE)["ok"]
            assert client.command(f"{game_id}-stop", AgentCommand.STOP)["ok"]
            assert not provider.receipt.result.valid
            assert not sink.closed
        assert len(workers) == 1 and session.open_count == 1
        assert client.command("shared-vision-stop", AgentCommand.VISION_STOP)["snapshot"]["vision"]["cleanup_confirmed"]
        worker.feed()
        assert not provider.sample(tick_id=0).hand_valid
        record_property("shared_chain", json.dumps({"build_id": f"0x{fusion_id:08X}",
                        "scope": "PC synthetic vision, real TCP/VVG/SceneCompiler, fake GPU sink",
                        "hardware_acceptance": "pending", "packages_sha256": identities,
                        "vision_workers": len(workers), "session_open_count": session.open_count,
                        "receipts": receipts}, sort_keys=True))
    finally:
        client.close()
        server.close()
        controller.close()
        backend.close()


@pytest.mark.parametrize("game_id,case_name", [
    ("game1", "c1-golden"),
    ("game2", "rps-01-win"),
    ("game3", "kingdom-01-princess-win"),
])
def test_fusion_three_game_goldens_match_native_runtime(tmp_path, game_id, case_name, record_property):
    import json
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from pynq_multimodal_game.game_validation import build_verified_game, compare_test_reports, run_game_test

    project = Path(__file__).resolve().parents[1] / "games" / game_id
    package = build_verified_game(project, tmp_path / f"{game_id}.vvg", target_build_id=0xC0060800)
    case = GameTestCase.load(project / "tests" / "replays" / f"{case_name}.json")
    pc_report = run_game_test(package.path, case)
    assert pc_report.passed
    runtime = PackagedGameRuntime(package.path, _Sink())
    runtime.load_test_case(case)
    try:
        runtime.start()
        deadline = time.monotonic() + (case.max_ticks + 1) / 60 + 10
        while not runtime.test_complete and runtime.last_error is None and time.monotonic() < deadline:
            threading.Event().wait(0.01)
        assert runtime.last_error is None and runtime.test_complete
        native_report = runtime.test_report
        comparison = compare_test_reports(pc_report.to_dict(), native_report)
        assert comparison["status"] == "passed", comparison
        assert comparison["matched_ticks"] == case.max_ticks + 1
        assert native_report["hardware_acceptance"] == "pending"
        record_property("golden_comparison", json.dumps({"comparison": comparison,
                        "pc_report": pc_report.to_dict(), "native_report": native_report}, sort_keys=True))
    finally:
        runtime.stop()
