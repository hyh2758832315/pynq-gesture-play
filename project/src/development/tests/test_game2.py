from pathlib import Path
import threading
import time
from zipfile import ZipFile
import pytest

from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
from pynq_multimodal_game.agent.core import AgentCommand, AgentController, AgentState, ArtifactManifest
from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
from pynq_multimodal_game.game_package import GamePackageBuilder
from pynq_multimodal_game.game_runner import GameRunner
from pynq_multimodal_game.game_sdk import GameInput
from pynq_multimodal_game.game_testing import GameTestCase, evaluate_assertions
from pynq_multimodal_game.library import AssetLibrary


ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "tests/fixtures/signal_sprint"
GOLDEN = PROJECT / "tests/replays/signal-sprint-golden.json"
FINAL_STATE_SHA256 = "5896e5681f5a38b5dfd426bf35284e18286a0b2b1c287c16cbb2e4de9d54dab0"
FINAL_FRAME_CRC32 = 565955719
BUILD_ID = 0xC0060700


@pytest.fixture
def rps_rules(monkeypatch):
    import importlib.util
    import sys

    path = ROOT / "games/game2/src/rules.py"
    spec = importlib.util.spec_from_file_location("rps_rules", path)
    module = importlib.util.module_from_spec(spec)
    monkeypatch.setattr(sys, "dont_write_bytecode", True)
    monkeypatch.setitem(sys.modules, spec.name, module)
    spec.loader.exec_module(module)
    return module


def test_rps_asset_bundle_fits_frozen_gpu_without_changing_pixels(tmp_path):
    import hashlib
    import runpy

    assets, labels = runpy.run_path(str(ROOT / "games/game2/src/assets.py"))["create_assets"]()
    image = assets.sprite_atlas
    parts = []
    for robot in (False, True):
        for pose in range(4):
            parts.extend(image.pixels[(row + 72 * robot) * image.width + 80 * pose:
                                      (row + 72 * robot) * image.width + 80 * (pose + 1)]
                         for row in range(72))
    for column, row, width, height in labels.values():
        assert column + width <= image.width and row + height <= image.height
        parts.extend(image.pixels[(row + offset) * image.width + column:
                                  (row + offset) * image.width + column + width]
                     for offset in range(height))
    assert hashlib.sha256(b"".join(parts)).hexdigest() == "465778275af592b1ff14dd0da73a014752526f43c9bba659298c1691163f568c"
    package = GamePackageBuilder().build(ROOT / "games/game2", tmp_path / "rps.vvg",
                                        target_build_id=0xC0060800)
    with GameRunner(package.path, render_rgb=False) as runner:
        frame = runner.step(GameInput(0, 0, False, 0., 0., 0, False))
        assert len(frame.asset_packet) <= 64 + 48 + 32768


def test_rps_real_package_consumes_native_local_classifier(tmp_path):
    from handoffs.gesture_vision_v61.runtime.gesture_control import GestureControl
    from pynq_multimodal_game.vision_input import GameVisionInputProvider

    package = GamePackageBuilder().build(ROOT / "games/game2", tmp_path / "native-rps.vvg",
                                        target_build_id=0xC0060800)
    now = [1.0]
    provider = GameVisionInputProvider(clock=lambda: now[0])
    controller = GestureControl()
    with GameRunner(package.path, render_rgb=False) as runner:
        for tick in range(210):
            now[0] += 1 / 60
            if tick % 12 == 0:
                stable, label = ("5", "PAPER") if tick < 190 else ("2", "SCISSORS")
                observed = {"centroid": [319, 179], "code": stable, "stable": stable, "rps": label}
                control = controller.update(observed, tick // 12 + 1, now[0])
                provider.publish({"run_id": "native", "server_age_ms": 0, "control": control,
                                  "frame": control["frame_id"], "stable": stable, "rps": label})
            sample, receipt = provider.sample_for_game("game2", tick_id=tick)
            assert sample.hand_x == sample.hand_y == 0 and not sample.fist_event
            frame = runner.step(sample)
        assert frame.snapshot.values["phase"] == "REVEAL"
        assert frame.snapshot.values["human_locked"] == "scissors"
        assert receipt["game_id"] == "game2"


def test_rps_nine_matchups(rps_rules) -> None:
    from pynq_multimodal_game.game_sdk import HandGesture

    choices = (HandGesture.FIST, HandGesture.SCISSORS, HandGesture.PAPER)
    expected = (("DRAW", "WIN", "LOSE"), ("LOSE", "DRAW", "WIN"), ("WIN", "LOSE", "DRAW"))
    for human_index, human in enumerate(choices):
        for robot_index, robot in enumerate(choices):
            assert rps_rules.judge(human, robot) == expected[human_index][robot_index]


@pytest.mark.parametrize("result, status", [("WIN", "WON"), ("LOSE", "LOST"), ("DRAW", "DRAW")])
def test_rps_always_completes_three_rounds(rps_rules, result, status) -> None:
    import random

    match = rps_rules.RpsMatch(random.Random(17), 2)
    for tick in range(30):
        robot = match._robot_commit or rps_rules.CHOICES[0]
        human = robot if result == "DRAW" else rps_rules.BEATS[robot] if result == "LOSE" else next(hand for hand, beaten in rps_rules.BEATS.items() if beaten is robot)
        match.step(tick, human)
        if tick == 19:
            assert match.status == "RUNNING" and len(match.history) == 2
    assert match.status == status
    assert len(match.history) == 3
    previous = [dict(record) for record in match.history]
    match.step(30, rps_rules.CHOICES[0])
    assert match.history == previous


def test_rps_deadline_locks_current_input_and_retries_unknown(rps_rules) -> None:
    import random

    match = rps_rules.RpsMatch(random.Random(3), 2)
    for tick in range(6):
        match.step(tick, rps_rules.CHOICES[0])
    commitment = match._robot_commit
    match.step(6, None)
    assert match.phase == "READY" and not match.history
    match.step(7, rps_rules.CHOICES[1])
    assert match._robot_commit is commitment
    for tick in range(8, 13):
        match.step(tick, rps_rules.CHOICES[0])
    match.step(13, rps_rules.CHOICES[2])
    assert match.human_locked is rps_rules.CHOICES[2]
    match.step(14, rps_rules.CHOICES[0])
    assert match.human_locked is rps_rules.CHOICES[2] and len(match.history) == 1


def test_rps_stability_required_each_round_and_after_retry(rps_rules) -> None:
    import random

    match = rps_rules.RpsMatch(random.Random(3), 2, stability_ticks=3)
    for tick, gesture in enumerate((None, rps_rules.CHOICES[0], rps_rules.CHOICES[1], rps_rules.CHOICES[1], None, rps_rules.CHOICES[2], rps_rules.CHOICES[2])):
        match.step(tick, gesture)
        assert match.phase == "READY"
    assert match._robot_commit is None
    match.step(7, rps_rules.CHOICES[2])
    assert match.phase == "COUNTDOWN" and match.phase_start == 7
    for tick in range(8, 13):
        match.step(tick, rps_rules.CHOICES[0])
    match.step(13, None)
    commitment = match._robot_commit
    for tick in (14, 15):
        match.step(tick, rps_rules.CHOICES[0])
        assert match.phase == "READY"
    match.step(16, rps_rules.CHOICES[0])
    assert match.phase == "COUNTDOWN" and match._robot_commit is commitment
    for tick in range(17, 26):
        match.step(tick, rps_rules.CHOICES[1])
    assert match.human_locked is rps_rules.CHOICES[1]
    match.step(26, rps_rules.CHOICES[0])
    assert match.phase == "READY" and match.round_index == 2 and match.stable_ticks == 1
    match.step(27, rps_rules.CHOICES[0])
    assert match.phase == "READY"
    match.step(28, rps_rules.CHOICES[0])
    assert match.phase == "COUNTDOWN" and match.phase_start == 28


def test_rps_package_scene_and_hidden_choice(tmp_path: Path) -> None:
    from pynq_multimodal_game.game_sdk import HandGesture

    project = ROOT / "games/game2"
    first = GamePackageBuilder().build(project, tmp_path / "rps.vvg")
    second = GamePackageBuilder().build(project, tmp_path / "rps-again.vvg")
    assert first.path.read_bytes() == second.path.read_bytes()
    assert first.manifest.game_id == "game2"
    assert first.manifest.version == "2.0.0"
    first_frames = []
    with GameRunner(first.path, seed=0) as runner:
        for tick in range(211):
            frame = runner.step(GameInput.from_logical_position(tick_id=tick, timestamp_ns=tick * 16_666_667, x=160, y=90, hand_gesture=HandGesture.PAPER, gesture_sequence=1))
            assert frame.command_count <= 19
            assert len(frame.rgb) == 320 * 180 * 3
            if tick:
                assert frame.asset_packet is None and frame.palette_packet is None and frame.tilemap_packet is None
            first_frames.append(frame)
        assert first_frames[28].snapshot.values["phase"] == "READY"
        assert first_frames[29].snapshot.values["phase"] == "COUNTDOWN"
        assert first_frames[208].snapshot.values["robot_locked"] is None
        assert first_frames[209].snapshot.values["phase"] == "REVEAL"
        assert first_frames[210].rgb == first_frames[209].rgb
    with GameRunner(first.path, seed=1) as runner:
        for tick in range(210):
            frame = runner.step(GameInput.from_logical_position(tick_id=tick, timestamp_ns=tick * 16_666_667, x=160, y=90, hand_gesture=HandGesture.PAPER, gesture_sequence=1))
            if tick < 209:
                assert frame.rgb == first_frames[tick].rgb
                assert frame.snapshot.values == first_frames[tick].snapshot.values
            else:
                assert frame.snapshot.values["robot_locked"] != first_frames[tick].snapshot.values["robot_locked"]


@pytest.mark.parametrize("replay", sorted((ROOT / "games/game2/tests/replays").glob("*.json")), ids=lambda path: path.stem)
def test_rps_asserted_replays_are_deterministic(tmp_path: Path, replay: Path) -> None:
    from pynq_multimodal_game.game_validation import run_game_test

    package = GamePackageBuilder().build(ROOT / "games/game2", tmp_path / "rps.vvg")
    case = GameTestCase.load(replay)
    first = run_game_test(package.path, case)
    second = run_game_test(package.path, case)
    assert first.passed, first.to_dict()
    assert second.passed, second.to_dict()
    assert first.frames == second.frames
    assert first.to_dict()["test_sha256"] == second.to_dict()["test_sha256"]


def test_rps_software_runtime_matches_pc_report(tmp_path: Path) -> None:
    from pynq_multimodal_game.game_validation import compare_test_reports, run_game_test

    package = GamePackageBuilder().build(ROOT / "games/game2", tmp_path / "rps.vvg")
    case = GameTestCase.load(ROOT / "games/game2/tests/replays/rps-01-win.json")
    pc_report = run_game_test(package.path, case)
    sink = _Sink()
    runtime = PackagedGameRuntime(package.path, sink)
    runtime.load_test_case(case)
    try:
        runtime.start()
        deadline = time.monotonic() + case.max_ticks / 60 + 10
        while not runtime.test_complete and runtime.last_error is None and time.monotonic() < deadline:
            threading.Event().wait(0.01)
        assert runtime.last_error is None and runtime.test_complete
        result = compare_test_reports(pc_report.to_dict(), runtime.test_report)
        assert result["status"] == "passed", result
        assert result["matched_ticks"] == 959
        assert result["hardware_acceptance"] == "pending"
        assert sink.asset_count == sink.palette_count == sink.tilemap_count == 1
        assert sink.scene_count >= 959
    finally:
        runtime.stop()


def test_rps_invalid_tracking_and_legacy_input_never_arm(tmp_path: Path) -> None:
    from pynq_multimodal_game.game_sdk import HandGesture

    package = GamePackageBuilder().build(ROOT / "games/game2", tmp_path / "rps.vvg")
    with GameRunner(package.path, render_rgb=False) as runner:
        for tick in range(100):
            frame = runner.step(GameInput(tick, tick * 16_666_667, False, 0, 0, 0, False, hand_gesture=HandGesture.FIST, gesture_sequence=1))
            assert frame.snapshot.values["phase"] == "READY"
        for tick in range(100, 140):
            frame = runner.step(GameInput.from_logical_position(tick_id=tick, timestamp_ns=tick * 16_666_667, x=160, y=90))
            assert frame.snapshot.values["phase"] == "READY"


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

    def upload_palette(self, _packet: bytes) -> None:
        self.palette_count += 1

    def upload_asset(self, _packet: bytes) -> None:
        self.asset_count += 1

    def upload_tilemap(self, _packet: bytes) -> None:
        self.tilemap_count += 1

    def submit_scene(self, _packet: bytes) -> None:
        self.scene_count += 1

    def close(self) -> None:
        pass


def test_signal_sprint_package_is_deterministic_and_self_contained(tmp_path: Path) -> None:
    builder = GamePackageBuilder()
    first = builder.build(PROJECT, tmp_path / "first.vvg")
    second = builder.build(PROJECT, tmp_path / "second.vvg")

    assert first.path.read_bytes() == second.path.read_bytes()
    assert first.sha256 == second.sha256
    assert first.manifest.game_id == "game2"
    with ZipFile(first.path) as archive:
        source = b"\n".join(
            archive.read(name) for name in first.files if name.startswith("src/")
        )
    assert b"pynq_multimodal_game.engine.side_scroller" in source
    assert b"games.game1" not in source
    assert b"pynq_multimodal_game.demo" not in source


def test_signal_sprint_pc_runner_matches_golden(tmp_path: Path) -> None:
    package = GamePackageBuilder().build(PROJECT, tmp_path / "game2.vvg")
    test_case = GameTestCase.load(GOLDEN)

    with GameRunner(package.path) as runner:
        final = None
        for tick in range(test_case.max_ticks + 1):
            final = runner.step(
                GameInput.from_logical_position(
                    tick_id=tick,
                    timestamp_ns=tick * 16_666_667,
                    x=319,
                    y=90,
                )
            )

    assert final is not None
    assert all(
        result.passed
        for result in evaluate_assertions(
            final.snapshot, test_case.assertions_at(test_case.max_ticks)
        )
    )
    assert final.snapshot.values is not None
    assert final.snapshot.values["state_sha256"] == FINAL_STATE_SHA256
    assert final.frame_crc32 == FINAL_FRAME_CRC32


def test_signal_sprint_packaged_runtime_matches_pc_snapshot(tmp_path: Path) -> None:
    package = GamePackageBuilder().build(PROJECT, tmp_path / "game2.vvg")
    sink = _Sink()
    runtime = PackagedGameRuntime(package.path, sink)
    runtime.load_test_case(GameTestCase.load(GOLDEN))
    try:
        runtime.start()
        deadline = time.monotonic() + 4.0
        while not runtime.test_complete and runtime.last_error is None:
            if time.monotonic() >= deadline:
                raise TimeoutError("game2 packaged runtime did not complete")
            time.sleep(0.01)

        assert runtime.last_error is None
        assert runtime.assertions_failed == 0
        assert runtime.assertions_passed == 4
        assert runtime.last_frame is not None
        assert runtime.last_frame.snapshot.status == "WON"
        assert runtime.last_frame.snapshot.score == 30
        assert runtime.last_frame.snapshot.values is not None
        assert runtime.last_frame.snapshot.values["state_sha256"] == FINAL_STATE_SHA256
        assert sink.palette_count == 1
        assert sink.asset_count == 1
        assert sink.scene_count >= 76
    finally:
        runtime.stop()


def test_signal_sprint_installs_lists_runs_and_stops_through_shell(tmp_path: Path) -> None:
    package = GamePackageBuilder().build(PROJECT, tmp_path / "game2.vvg")
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
        manifest = ArtifactManifest.for_path(
            package.path,
            artifact_kind="game.vvg",
            target_build_id=BUILD_ID,
            abi_major=1,
            abi_minor=0,
        )
        shell.stage_file(manifest, package.path)
        installed = controller.execute(
            "game2-install",
            AgentCommand.LIBRARY_INSTALL,
            item_id="game2",
            display_name="Game 2 - Signal Sprint",
            library_kind="game",
        )
        assert installed.ok is True
        listed = controller.execute(
            "game2-list", AgentCommand.LIBRARY_LIST, library_kind="game"
        )
        assert listed.library_items is not None
        assert [(item.item_id, item.sha256) for item in listed.library_items] == [
            ("game2", package.sha256)
        ]
        controller.execute(
            "game2-run",
            AgentCommand.LIBRARY_RUN,
            item_id="game2",
            library_kind="game",
            test_case_json=GameTestCase.load(GOLDEN).to_json(),
        )
        deadline = time.monotonic() + 4.0
        while not shell.snapshot.test_complete and time.monotonic() < deadline:
            threading.Event().wait(0.01)
        snapshot = shell.snapshot
        assert snapshot.state is AgentState.PAUSED
        assert snapshot.game_tick == 75
        assert snapshot.assertions_passed == 4
        assert snapshot.assertions_failed == 0
        stopped = controller.execute("game2-stop", AgentCommand.STOP)
        assert stopped.snapshot.runtime_mode == "menu"
    finally:
        controller.close()
        shell.close()