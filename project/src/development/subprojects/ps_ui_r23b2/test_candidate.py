from __future__ import annotations

from types import SimpleNamespace
from http.client import HTTPConnection
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import time
import pytest

from pynq_multimodal_game.button_input import ButtonGameInputProvider
from pynq_multimodal_game.hand_startup import HandStartupGate
from pynq_multimodal_game.menu import (
    MenuIcon, MenuInteraction, MenuPage, game_targets,
    hand_display_targets, video_page_targets,
)
from pynq_multimodal_game.return_button import RETURN_SIZE
from pynq_multimodal_game.startup_ui import CheckState


def test_four_studio_games_seed_library_without_replacing_existing_items(tmp_path) -> None:
    from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
    from pynq_multimodal_game.game_seeds import ensure_seed_games
    from pynq_multimodal_game.library import AssetLibrary, LibraryKind
    from subprojects.ps_ui_r23b2.test_seed_helpers import build_bundled_games

    build_bundled_games(tmp_path)
    library = AssetLibrary(tmp_path / "library", minimum_free_bytes=0,
                           minimum_free_fraction=0)
    assert ensure_seed_games(tmp_path, library, install=False) == ("game1", "game2", "game3", "game4")
    assert not library.root.exists()
    assert ensure_seed_games(tmp_path, library, install=True) == ("game1", "game2", "game3", "game4")
    assert ensure_seed_games(tmp_path, library, install=True) == ()
    assert {entry.manifest.item_id for entry in library.scan(LibraryKind.GAME).entries} == {
        "game1", "game2", "game3", "game4"}
    shell = C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000), library=library)
    shell.refresh_catalog()
    assert shell._game_ids == ("game1", "game2", "game3", "game4")
    assert [target.enabled for target in game_targets(shell._game_ids)[1:]] == [True]*4
    from pynq_multimodal_game.game_validation import build_verified_game
    repository = Path(__file__).resolve().parents[2]
    replacement = build_verified_game(repository / "games/game1", tmp_path / "different.vvg",
                                      target_build_id=0xC0061000)
    library.install_file(replacement.path, item_id="game1", display_name="Custom",
                         kind=LibraryKind.GAME, target_build_id=0xC0061000, replace=True)
    assert ensure_seed_games(tmp_path, library, install=True) == ()
    assert next(entry for entry in library.scan(LibraryKind.GAME).entries
                if entry.manifest.item_id == "game1").manifest.sha256 == replacement.sha256


def test_seeded_r23_games_render_and_return_to_menu(tmp_path) -> None:
    import threading
    from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend, ShellMode
    from pynq_multimodal_game.game_seeds import ensure_seed_games
    from pynq_multimodal_game.library import AssetLibrary
    from subprojects.ps_ui_r23b2.test_seed_helpers import build_bundled_games

    build_bundled_games(tmp_path)
    library = AssetLibrary(tmp_path / "library", minimum_free_bytes=0,
                           minimum_free_fraction=0)
    ensure_seed_games(tmp_path, library, install=True)

    class Session:
        build_id = 0xC0061000

        def open(self):
            return self

    class Sink:
        def __init__(self):
            self.presented = threading.Event()

        def upload_palette(self, packet):
            pass

        def upload_asset(self, packet):
            pass

        def upload_tilemap(self, packet):
            pass

        def submit_scene(self, packet):
            self.presented.set()

        def close(self):
            pass

    sink = Sink()
    shell = C6IShellRuntimeBackend(Session(), menu_fps=0, library=library,
                                  sink_factory=lambda *_args: sink)
    try:
        shell.open()
        for item_id in ("game1", "game2", "game3", "game4"):
            sink.presented.clear()
            shell.start_game(item_id)
            assert shell.mode is ShellMode.GAME
            assert sink.presented.wait(2)
            shell.return_to_menu()
            assert shell.mode is ShellMode.MENU
    finally:
        shell.close()


def test_game3_pc_example_moves_and_jumps_without_gesture_mechanisms(tmp_path) -> None:
    from pynq_multimodal_game.game_testing import GameTestCase
    from pynq_multimodal_game.game_validation import run_game_test
    from subprojects.ps_ui_r23b2.test_seed_helpers import build_bundled_games

    build_bundled_games(tmp_path)
    repository = Path(__file__).resolve().parents[2]
    from subprojects.ps_ui_r23b2.tools.pc_examples import example
    case=example('game3',repository)
    report = run_game_test(tmp_path / "seed_games/game3.vvg",
                           GameTestCase.from_json(json.dumps(case)))
    assert report.passed, report.to_dict()


def test_game1_gestures_do_not_trigger_button_attack_or_shield(tmp_path) -> None:
    from pynq_multimodal_game.game_runner import GameRunner
    from pynq_multimodal_game.game_sdk import GameInput, HandGesture
    from subprojects.ps_ui_r23b2.test_seed_helpers import build_bundled_games

    build_bundled_games(tmp_path)
    runner = GameRunner(tmp_path / "seed_games/game1.vvg", render_rgb=False)
    try:
        scissors = runner.step(GameInput.from_logical_position(
            tick_id=0, timestamp_ns=0, x=160, y=90,
            hand_gesture=HandGesture.SCISSORS, gesture_sequence=1,
            gesture_changed=True))
        assert scissors.snapshot.values["attacks_fired"] == 0
        paper = runner.step(GameInput.from_logical_position(
            tick_id=1, timestamp_ns=1, x=160, y=90,
            hand_gesture=HandGesture.PAPER, gesture_sequence=2,
            gesture_changed=True))
        assert paper.snapshot.values["shield_active"] is False
        moving = runner.step(GameInput.from_logical_position(
            tick_id=2, timestamp_ns=2, x=319, y=90,
            hand_gesture=HandGesture.PAPER, gesture_sequence=2))
        assert moving.snapshot.values["shield_active"] is False
    finally:
        runner.close()


def test_button_wrapper_peeks_latest_without_consuming_gesture_or_button() -> None:
    calls: list[tuple[str, int]] = []
    newest = SimpleNamespace(frame_id=91, gesture="rock")

    class Visual:
        def peek_hand_classification(self):
            return {"valid": True, "gesture": "paper"}

        def peek_menu_control(self, *, tick_id: int = 0):
            calls.append(("peek", tick_id))
            return newest

        def sample_menu_control(self, *, tick_id: int):
            raise AssertionError("peek must not consume a menu gesture")

    class Sampler:
        def consume(self):
            raise AssertionError("peek must not consume a button")

    provider = ButtonGameInputProvider(Visual(), Sampler())
    assert provider.peek_menu_control() is newest
    assert provider.peek_menu_control(tick_id=2) is newest
    assert calls == [("peek", 0), ("peek", 2)]
    assert provider.peek_hand_classification()["gesture"] == "paper"


def test_candidate_menu_has_small_return_and_four_rectangular_game_cards() -> None:
    targets = game_targets(("game1", "game2", "game3", "future"))
    assert RETURN_SIZE == 24
    assert len(targets) == 5
    assert [target.icon for target in targets[1:]] == [MenuIcon.GAME] * 4
    assert all((target.hit_width,target.hit_height)==(140,52) for target in targets[1:])
    assert len(hand_display_targets()) == 5


def test_hand_page_owner_status_changes_without_asset_upload_or_input_consumption() -> None:
    from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
    from pynq_multimodal_game.menu import HAND_STATUS_LABELS, hand_session_label
    from pynq_multimodal_game.gpu_abi import pack_asset_bundle_packet
    from pynq_multimodal_game.scene_compiler import CommandRenderer

    shell = C6IShellRuntimeBackend(object(), menu_fps=0)
    shell._select_page_locked(MenuPage.HAND_PLACEHOLDER)
    def forbidden_sample(*args, **kwargs):
        raise AssertionError("hand display must not consume input")
    shell._live_input = SimpleNamespace(
        sample=forbidden_sample,
        peek_hand_classification=lambda: {"valid": True, "gesture": "paper"},
    )
    cases = (
        (None, "VISION ONLY"),
        ({"mode": "memory-only", "phase": "ACTIVE"}, "MOCK ACTIVE"),
        ({"mode": "serial-fixed-playback", "phase": "STARTING"}, "HAND CHECK"),
        ({"mode": "serial-fixed-playback", "phase": "ACTIVE"}, "HAND ACTIVE"),
        ({"mode": "serial-fixed-playback", "phase": "CLOSING"}, "HAND STOP"),
        ({"mode": "serial-fixed-playback", "phase": "CLOSED", "release_confirmed": True}, "HAND OFF"),
        ({"mode": "serial-fixed-playback", "phase": "CLOSED", "release_confirmed": False}, "HAND FAULT"),
        ({"mode": "serial-fixed-playback", "phase": "FAULT", "error": "off readback"}, "HAND FAULT"),
    )
    identities, images = [], []
    for status, label in cases:
        assert hand_session_label(status) == label and label in HAND_STATUS_LABELS
        shell._hand_session = None if status is None else SimpleNamespace(status=lambda: status)
        frame = shell._compile_menu_frame_locked()
        identities.append(pack_asset_bundle_packet(frame.assets, generation=1))
        images.append(CommandRenderer().render(frame))
        assert len(frame.commands) <= 16
        assert len(identities[-1]) < 32 * 1024
    assert len(set(identities)) == 1
    assert len(set(images)) == len(cases) - 1  # Both unconfirmed close/fault share the fault label.


def test_hand_pose_atlas_keeps_size_and_return_icon() -> None:
    from pynq_multimodal_game.menu import create_menu_assets, ICON_SIZE, _ICON_INDEX

    labels = ("DEFAULT", "PAPER", "SCISSORS", "ROCK")
    original = create_menu_assets(labels).sprite_atlas
    poses = create_menu_assets(labels, hand_poses=True).sprite_atlas
    assert (original.width, original.height) == (poses.width, poses.height)
    assert len(original.pixels) == len(poses.pixels)
    def cell(atlas, index, row):
        return b"".join(atlas.pixels[y * atlas.width + index * ICON_SIZE:
                                    y * atlas.width + (index + 1) * ICON_SIZE]
                        for y in range(row * ICON_SIZE, (row + 1) * ICON_SIZE))
    for row in (0, 1):
        assert cell(original, _ICON_INDEX[MenuIcon.BACK], row) == cell(poses, _ICON_INDEX[MenuIcon.BACK], row)
        assert len({cell(poses, index, row) for index in range(4)}) == 4


def test_hand_pose_scene_renders_distinct_tiles_with_same_command_budget() -> None:
    from pynq_multimodal_game.menu import build_menu_scene, create_menu_assets
    from pynq_multimodal_game.scene_compiler import CommandRenderer, SceneCompiler

    assets = create_menu_assets(hand_poses=True)
    compiler = SceneCompiler(sprite_atlas=assets.sprite_atlas,
                             tile_atlas=assets.tile_atlas, palettes=assets.palettes)
    targets = hand_display_targets()
    old = compiler.compile(build_menu_scene(0, targets, animate=False))
    frame = compiler.compile(build_menu_scene(0, targets, animate=False, hand_poses=True))
    assert len(old.commands) == len(frame.commands)
    assert old.header.predicted_cycles == frame.header.predicted_cycles
    rgb = CommandRenderer().render(frame)
    icons = []
    for target in targets[1:]:
        x0, y0 = target.center_x - 24, target.center_y - 24
        icons.append(b"".join(rgb[(y * 320 + x0) * 3:(y * 320 + x0 + 48) * 3]
                              for y in range(y0, y0 + 48)))
    assert len(set(icons)) == 4


def test_all_studio_installed_videos_are_reachable_from_ps_menu(monkeypatch) -> None:
    from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend

    ids = tuple(f"studio-{index}" for index in range(7))
    assert [target.item_id for target in video_page_targets(ids[:4])] == [
        "back", *(f"video:{item_id}" for item_id in ids[:4])]
    shell = C6IShellRuntimeBackend(object(), menu_fps=0)
    shell._video_entries = {
        item_id: SimpleNamespace(manifest=SimpleNamespace(
            item_id=item_id, display_name=f"STUDIO {index + 1}"))
        for index, item_id in enumerate(ids)
    }
    shell._select_page_locked(MenuPage.VIDEOS)
    assert shell._video_page == 0
    assert [target.item_id for target in shell._targets] == [
        "back", "video:studio-0", "video:studio-1",
        "video-page:prev", "video-page:next"]
    assert not shell._targets[3].enabled and shell._targets[4].enabled

    activated = ["video-page:next"]
    monkeypatch.setattr(shell._input, "update", lambda *_: MenuInteraction(
        None, activated[0], None, None))
    assert shell.handle_control(object()) == "video-page:next"
    assert shell._video_page == 1
    assert shell._labels[:2] == ("STUDIO 3", "STUDIO 4")
    assert shell.handle_control(object()) == "video-page:next"
    assert shell._video_page == 2
    assert shell.handle_control(object()) == "video-page:next"
    assert shell._video_page == 3
    assert [target.item_id for target in shell._targets] == [
        "back", "video:studio-6", "video-slot:empty",
        "video-page:prev", "video-page:next"]
    assert shell._targets[3].enabled and not shell._targets[4].enabled
    played = []
    monkeypatch.setattr(shell, "play_library_video", lambda item_id: played.append(item_id))
    activated[0] = "video:studio-6"
    assert shell.handle_control(object()) == "video:studio-6"
    assert played == ["studio-6"]
    activated[0] = "video-page:prev"
    assert shell.handle_control(object()) == "video-page:prev"
    assert shell._video_page == 2
    shell._select_page_locked(MenuPage.HOME)
    activated[0] = "videos"
    assert shell.handle_control(object()) == "videos"
    assert shell._video_page == 0


def test_ps_video_menu_uses_every_installed_library_item(tmp_path) -> None:
    from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
    from pynq_multimodal_game.library import AssetLibrary, LibraryKind

    library = AssetLibrary(tmp_path / "library", minimum_free_bytes=0,
                           minimum_free_fraction=0)
    for index in range(7):
        source = tmp_path / f"studio-{index}.s2v"
        source.write_bytes(f"studio-video-{index}".encode())
        library.install_file(source, item_id=f"studio-{index}",
                             display_name=f"STUDIO {index + 1}",
                             kind=LibraryKind.VIDEO, target_build_id=0xC0061000)
    shell = C6IShellRuntimeBackend(object(), menu_fps=0, library=library)
    shell.refresh_catalog()
    assert len(shell._video_entries) == 7
    shell._video_page = 3
    shell._select_page_locked(MenuPage.VIDEOS)
    assert shell._targets[1].item_id == "video:studio-6"
    assert shell._labels[0] == "STUDIO 7"


def test_studio_video_install_reaches_hdmi_playback_over_agent(tmp_path, monkeypatch) -> None:
    from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
    from pynq_multimodal_game.agent.core import AgentController
    from pynq_multimodal_game.agent.transport import AgentServer
    from pynq_multimodal_game.library import AssetLibrary
    from pynq_multimodal_game.studio.device import DeviceState, RemoteDeviceSession
    from pynq_multimodal_game.video_codec import (
        S2V1_HEIGHT, S2V1_WIDTH, encode_rgb_frames,
    )

    class BoardSession:
        build_id = 0xC0061000

        def open(self):
            return self

    class Sink:
        def __init__(self):
            self.scenes = 0

        def upload_asset(self, _packet):
            pass

        def upload_palette(self, _packet):
            pass

        def upload_tilemap(self, _packet):
            pass

        def submit_scene(self, _packet):
            self.scenes += 1

        def close(self):
            pass

    sink = Sink()
    shell = C6IShellRuntimeBackend(
        BoardSession(), menu_fps=0,
        library=AssetLibrary(tmp_path / "library", minimum_free_bytes=0,
                             minimum_free_fraction=0),
        sink_factory=lambda *_: sink,
    )
    controller = AgentController(shell, upload_directory=tmp_path / "uploads")
    server = AgentServer(controller)
    server.start()
    studio = RemoteDeviceSession(*server.address, expected_build_id=0xC0061000,
                                 source_ids=())
    try:
        assert studio.connect().state is DeviceState.READY
        for index in range(5):
            video = tmp_path / f"studio-{index}.s2v"
            color = bytes((8 + index, 16, 24))
            encode_rgb_frames([color * (S2V1_WIDTH * S2V1_HEIGHT)], video)
            result = studio.install_s2v(video)
            assert result["library_items"] is not None
        listed = studio.list_library("video")
        installed_ids = [item["item_id"] for item in listed["library_items"]]
        assert len(installed_ids) == 5
        assert len(shell._video_entries) == 5
        shell._video_page = 2
        shell._select_page_locked(MenuPage.VIDEOS)
        assert shell._targets[1].item_id == f"video:{installed_ids[-1]}"
        shell.open()
        shell._select_page_locked(MenuPage.VIDEOS)
        selected = shell._targets[1].item_id
        assert selected == f"video:{installed_ids[-1]}"
        monkeypatch.setattr(shell._input, "update", lambda *_: SimpleNamespace(activated_id=selected))
        before = sink.scenes
        assert shell.handle_control(object()) == selected
        assert shell._video.snapshot.active_sha256 == shell._video_entries[installed_ids[-1]].manifest.sha256
        deadline = time.monotonic() + 2
        while sink.scenes == before and time.monotonic() < deadline:
            time.sleep(.01)
        assert sink.scenes > before
        assert shell.mode.value == "video"
        shell.return_to_menu()
        assert shell.mode.value == "menu" and shell.page is MenuPage.HOME
    finally:
        studio.disconnect()
        server.close()
        controller.close()


def test_explicit_hand_startup_uses_readonly_probe_and_requires_torque_off(tmp_path, monkeypatch) -> None:
    from pynq_multimodal_game import hand_startup

    root = tmp_path / "hand"
    (root / "src/pynq_usb_hand").mkdir(parents=True)
    (root / "src/pynq_usb_hand/probe.py").write_text("# fake source\n", encoding="utf-8")
    asset = root / "assets/config.yaml"
    asset.parent.mkdir()
    asset.write_text("frozen\n", encoding="utf-8")
    (root / "frozen_manifest.json").write_text(json.dumps({
        "schema": "pynq-usb-hand-frozen-v1",
        "sha256": {"assets/config.yaml": hashlib.sha256(asset.read_bytes()).hexdigest()},
    }), encoding="utf-8")
    monkeypatch.setattr(hand_startup, "FROZEN_MANIFEST_SHA256",
                        hashlib.sha256((root / "frozen_manifest.json").read_bytes()).hexdigest())
    monkeypatch.setattr(hand_startup, "READONLY_SOURCE_SHA256", {
        "src/pynq_usb_hand/probe.py": hashlib.sha256(
            (root / "src/pynq_usb_hand/probe.py").read_bytes()).hexdigest()})
    python = tmp_path / "hand-python"
    python.write_text("", encoding="utf-8")
    report_dir = tmp_path / "reports"
    report_dir.mkdir()
    port = "/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00"
    calls = []
    torque = [0]

    def run(command, *, cwd, env, capture_output, text, timeout, check):
        calls.append(command)
        assert cwd == root and env["PYTHONPATH"].startswith(str(root / "src"))
        assert command[3:7] == ("pynq_usb_hand.probe", "--root", str(root), "--port")
        report = {"schema": "pynq-usb-hand-readonly-v1", "result": "READ_ONLY_COMPLETE",
                  "port": port, "port_closed": True, "motion_authorized": False,
                  "release_ready": False, "read_requests": 85,
                  "motors": [{"id": motor_id, "reads": {
                      name: {"value": value, "result": 0, "device_error": 0}
                      for name, value in (("torque", torque[0]), ("position_raw", 666),
                                          ("voltage_raw", 78), ("temperature_c", 30),
                                          ("native_limit", 1000))}}
                      for motor_id in range(1, 18)]}
        Path(command[-1]).write_text(json.dumps(report), encoding="utf-8")
        return SimpleNamespace(returncode=0)

    monkeypatch.setattr("pynq_multimodal_game.hand_startup.subprocess.run", run)
    gate = HandStartupGate(root=root, python=python, port=port, report_dir=report_dir)
    assert not calls and not gate.passed
    assert gate.python == python.absolute()
    assert gate() is True and gate.passed and gate.report_path.is_file()
    assert calls[0][0] == str(python.absolute())
    if os.name == "posix":
        linked_python = tmp_path / "hand-venv-python"
        linked_python.symlink_to(python)
        linked = HandStartupGate(root=root, python=linked_python, port=port,
                                 report_dir=report_dir)
        assert linked.python == linked_python.absolute()
    with pytest.raises(RuntimeError, match="only once"):
        gate()
    torque[0] = 1
    with pytest.raises(RuntimeError, match="safe contract"):
        HandStartupGate(root=root, python=python, port=port, report_dir=report_dir)()
    assert len(calls) == 2


def test_hand_startup_cli_rejects_partial_or_unrelated_configuration() -> None:
    from pynq_multimodal_game.agent.cli import main

    for arguments in (
        ("--backend", "c6i-vision-button", "--hand-shadow"),
        ("--backend", "c6i-vision-button", "--hand-serial-actions"),
        ("--backend", "c6i-vision-button", "--hand-serial-seconds", "30"),
        ("--backend", "c6i-vision-button", "--hand-stage-waits", "1", "1", "1"),
        ("--backend", "c6i-vision-button", "--hand-serial-actions", "--hand-mock-actions"),
        ("--backend", "c6i-vision-button", "--hand-readonly-root", "/tmp/hand"),
        ("--backend", "mock", "--hand-readonly-root", "/tmp/hand",
         "--hand-readonly-python", "/tmp/python", "--hand-readonly-port", "/dev/serial/by-id/hand"),
    ):
        with pytest.raises(SystemExit) as error:
            main(arguments)
        assert error.value.code == 2


@pytest.mark.parametrize("waits", (("0", "1", "1"), ("nan", "1", "1"), ("1", "11", "1")))
def test_serial_hand_cli_rejects_invalid_stage_waits(waits) -> None:
    from pynq_multimodal_game.agent.cli import main

    with pytest.raises(SystemExit) as error:
        main(("--backend", "c6i-vision-button", "--hand-readonly-root", "/tmp/hand",
              "--hand-readonly-python", "/tmp/python", "--hand-readonly-port", "/dev/hand",
              "--hand-serial-actions", "--hand-stage-waits", *waits))
    assert error.value.code == 2


@pytest.mark.parametrize("seconds", ("0", "-1", "nan", "inf"))
def test_serial_hand_cli_rejects_invalid_optional_duration(seconds) -> None:
    from pynq_multimodal_game.agent.cli import main

    with pytest.raises(SystemExit) as error:
        main(("--backend", "c6i-vision-button", "--hand-readonly-root", "/tmp/hand",
              "--hand-readonly-python", "/tmp/python", "--hand-readonly-port", "/dev/hand",
              "--hand-serial-actions", "--hand-stage-waits", "1", "1", "1",
              "--hand-serial-seconds", seconds))
    assert error.value.code == 2


def test_button_default_boot_checks_vision_and_marks_absent_hand_skipped(monkeypatch) -> None:
    from pynq_multimodal_game import button_input, startup_checks
    from pynq_multimodal_game.agent.vision_backend import C6IButtonRuntimeBackend

    events = []

    class Session:
        build_id = 0xC0061000

        def open(self):
            events.append("gpu")
            return self

        def mmio(self, name):
            assert name == "build_id_gpio"
            return object()

        def close(self):
            events.append("gpu_close")

    class Sink:
        def upload_asset(self, _packet):
            pass

        def upload_palette(self, _packet):
            pass

        def upload_tilemap(self, _packet):
            pass

        def submit_scene(self, _packet):
            pass

        def close(self):
            events.append("sink_close")

    class Supervisor:
        input_provider = object()

        def start(self):
            events.append("vision_start")
            return self.status(frame_id=0)

        def status(self, frame_id=1):
            return {"state": "RUNNING", "frame_id": frame_id,
                    "owner_held": True, "last_error": None,
                    "input_capabilities": {"schema": "local-game-vision-v1",
                                           "mode": "games",
                                           "games": ["game1", "game2", "game3"]}}

        def stop(self):
            events.append("vision_stop")
            return {"cleanup_confirmed": True}

    class Sampler:
        def __init__(self, mmio, *, data_offset):
            assert data_offset == 8

        def start(self):
            events.append("button_start")

        def close(self):
            events.append("button_close")

    monkeypatch.setattr(button_input, "ButtonSampler", Sampler)
    backend = C6IButtonRuntimeBackend(
        Session(), Supervisor(), menu_fps=0,
        sink_factory=lambda *_: Sink())
    try:
        backend.open()
        assert backend.startup_snapshot.states == (
            CheckState.OK, CheckState.OK, CheckState.OK, CheckState.SKIP)
        assert events.index("gpu") < events.index("vision_start") < events.index("button_start")
    finally:
        backend.close()
    assert events.index("button_close") < events.index("vision_stop")

    events.clear()
    def fail_vision(_supervisor, **_options):
        raise RuntimeError("injected first-frame failure")

    monkeypatch.setattr(startup_checks, "start_vision_until_ready", fail_vision)
    failing = C6IButtonRuntimeBackend(
        Session(), Supervisor(), menu_fps=0,
        sink_factory=lambda *_: Sink())
    with pytest.raises(RuntimeError, match="first-frame failure"):
        failing.open()
    assert failing.startup_snapshot.states == (
        CheckState.OK, CheckState.OK, CheckState.FAIL, CheckState.WAIT)
    assert "button_start" not in events
    assert "vision_stop" in events


def test_button_backend_can_show_verified_startup_before_menu(monkeypatch) -> None:
    from pynq_multimodal_game.agent.vision_backend import C6IButtonRuntimeBackend
    from pynq_multimodal_game import button_input

    events = []

    class Session:
        build_id = 0xC0061000

        def open(self):
            events.append("gpu")

        def mmio(self, name):
            assert name == "build_id_gpio"
            return object()

    class Sink:
        scenes = 0

        def upload_asset(self, packet):
            pass

        def upload_palette(self, packet):
            pass

        def upload_tilemap(self, packet):
            pass

        def submit_scene(self, packet):
            self.scenes += 1

        def close(self):
            events.append("sink_closed")

    class Supervisor:
        input_provider = object()

        def __init__(self):
            self.frame = 1

        def start(self):
            events.append("vision")
            return {"state": "RUNNING", "frame_id": self.frame, "owner_held": True,
                    "last_error": None, "input_capabilities": {
                        "schema": "local-game-vision-v1", "mode": "games",
                        "games": ["game1", "game2", "game3"]}}

        def status(self):
            self.frame += 1
            return {"state": "RUNNING", "frame_id": self.frame, "owner_held": True,
                    "last_error": None, "input_capabilities": {
                        "schema": "local-game-vision-v1", "mode": "games",
                        "games": ["game1", "game2", "game3"]}}

        def stop(self):
            events.append("vision_stop")
            return {"cleanup_confirmed": True}

    class Sampler:
        def __init__(self, mmio, *, data_offset):
            assert data_offset == 8

        def start(self):
            events.append("button_start")

        def close(self):
            events.append("button_close")

    monkeypatch.setattr(button_input, "ButtonSampler", Sampler)
    class HandSession:
        def start(self):
            events.append("hand_start")

        def close(self):
            events.append("hand_close")

    def hand_factory(provider):
        assert provider is Supervisor.input_provider
        events.append("hand_factory")
        return HandSession()

    sink = Sink()
    backend = C6IButtonRuntimeBackend(
        Session(), Supervisor(), menu_fps=0,
        sink_factory=lambda *_: sink,
        startup_hand=lambda: events.append("hand_readonly") or True,
        hand_session_factory=hand_factory,
    )
    try:
        backend.open()
        assert events.index("gpu") < events.index("vision") < events.index("hand_readonly")
        assert events.index("hand_readonly") < events.index("button_start")
        assert events.index("button_start") < events.index("hand_factory") < events.index("hand_start")
        assert backend.startup_snapshot.states == (CheckState.OK,) * 4
        assert backend.snapshot.vision["hand_session"]["mode"] == "observation-only"
        backend._hand_session.status = lambda: {
            "schema": "hand-session-status-v1", "mode": "memory-only",
            "phase": "FAULT", "error": "mock child release unknown"}
        from pynq_multimodal_game.agent.core import AgentState
        fault = backend.snapshot
        assert fault.state is AgentState.IDLE
        assert fault.last_error is None
        assert fault.vision['hand_session']['error'] == "mock child release unknown"
        del backend._hand_session.status
        assert sink.scenes == 10
        backend.stop_vision()
        assert events.index("hand_close") < events.index("vision_stop")
        assert backend.snapshot.vision["hand_session"] is None
    finally:
        backend.close()
    assert "button_close" in events and "vision_stop" in events

    events.clear()
    failing = C6IButtonRuntimeBackend(
        Session(), Supervisor(), menu_fps=0,
        sink_factory=lambda *_: Sink(), startup_hand=lambda: False,
    )
    with pytest.raises(RuntimeError, match="HAND check did not return verified readiness"):
        failing.open()
    assert "vision" in events and "vision_stop" in events
    assert "button_start" not in events
    assert failing.startup_snapshot.states[-1] is CheckState.FAIL

    with pytest.raises(ValueError, match="verified startup hand check"):
        C6IButtonRuntimeBackend(Session(), Supervisor(), hand_session_factory=hand_factory)

    events.clear()
    class FailedHandSession(HandSession):
        def start(self):
            events.append("hand_start_failed")
            raise RuntimeError("injected hand startup fault")

    failed_hand = C6IButtonRuntimeBackend(
        Session(), Supervisor(), menu_fps=0,
        sink_factory=lambda *_: Sink(), startup_hand=lambda: True,
        hand_session_factory=lambda _provider: FailedHandSession(),
    )
    with pytest.raises(RuntimeError, match="injected hand startup fault"):
        failed_hand.open()
    assert events.index("hand_start_failed") < events.index("hand_close")
    assert events.index("hand_close") < events.index("button_close") < events.index("vision_stop")

    events.clear()
    class FlakyHandSession(HandSession):
        closes = 0

        def close(self):
            self.closes += 1
            events.append("hand_close")
            if self.closes == 1:
                raise RuntimeError("injected hand close fault")

    flaky = C6IButtonRuntimeBackend(
        Session(), Supervisor(), menu_fps=0,
        sink_factory=lambda *_: Sink(), startup_hand=lambda: True,
        hand_session_factory=lambda _provider: FlakyHandSession(),
    )
    try:
        flaky.open()
        with pytest.raises(RuntimeError, match="hand cleanup failed"):
            flaky.stop_vision()
        assert events.index("hand_close") < events.index("vision_stop")
    finally:
        flaky.close()


def test_frozen_vision_preview_stops_demand_without_another_frame(monkeypatch) -> None:
    root = Path(__file__).resolve().parents[2]
    script = Path(__file__).parent / "board/pynq_z2/scripts/vision_async_runtime.py"
    monkeypatch.setenv("VVG_VISION_RUNTIME_DIR", str(root / "handoffs/gesture_vision_v61/runtime"))
    spec = importlib.util.spec_from_file_location("r23b2_preview_candidate", script)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    preview = module.BytesPreview("127.0.0.1", 0)
    connection = HTTPConnection("127.0.0.1", preview.server.server_port, timeout=1)
    try:
        assert not preview.demand()
        assert not preview.wants_result()
        result_connection = HTTPConnection("127.0.0.1", preview.server.server_port, timeout=1)
        try:
            result_connection.request("GET", "/result.json")
            assert result_connection.getresponse().status == 200
            assert preview.wants_result()
        finally:
            result_connection.close()
        connection.request("GET", "/camera.mjpg")
        response = connection.getresponse()
        assert response.status == 200
        assert preview.demand() == frozenset({"video"})
        response.close()
        connection.close()
        deadline = time.monotonic() + 0.8
        while preview.demand() and time.monotonic() < deadline:
            time.sleep(0.025)
        assert preview.demand() == frozenset()
        assert preview.video_clients == 0
        with preview.lock:
            preview.result_requested_at = float("-inf")
        assert not preview.wants_result()
    finally:
        connection.close()
        preview.close()


def test_unsubscribed_result_does_not_serialize_each_vision_frame(monkeypatch) -> None:
    from threading import Event

    root = Path(__file__).resolve().parents[2]
    script = Path(__file__).parent / "board/pynq_z2/scripts/vision_async_runtime.py"
    monkeypatch.setenv("VVG_VISION_RUNTIME_DIR", str(root / "handoffs/gesture_vision_v61/runtime"))
    spec = importlib.util.spec_from_file_location("r23b2_result_on_demand", script)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    published = []
    returned = []
    requested = [False]

    def process(raw, _recognizer, *_args, **kwargs):
        kwargs["on_result"]({"stable": "5", "rps": "PAPER"})
        return raw, {}

    monkeypatch.setattr(module, "process_rgb", process)
    worker = SimpleNamespace(
        _stop=Event(), frame_processor=None, frame_id=0,
        recognizer=SimpleNamespace(result_frame_id=0, debug_enabled=False),
        preview_encoder=None, preview=SimpleNamespace(
            wants_result=lambda: requested[0],
            publish_result=lambda packet: returned.append(json.loads(packet))),
        controller=SimpleNamespace(update=lambda *_: {"schema": "gesture-control-v1"}),
        run_id="result-run", config_epoch="result-config",
        input_provider=SimpleNamespace(publish=lambda packet, **_: published.append(packet)),
        rotate=False, mirror=False, capture_order="bgr", measure_processing=False,
    )
    module.SharedVisionWorker._process_frame(worker, object())
    assert len(published) == 1 and not returned
    requested[0] = True
    module.SharedVisionWorker._process_frame(worker, object())
    assert len(published) == 2 and len(returned) == 1
    assert returned[0]["frame"] == 2 and returned[0]["control"]["schema"] == "gesture-control-v1"
