from pathlib import Path
import pytest

from pynq_multimodal_game.game_package import GamePackageBuilder
from pynq_multimodal_game.game_project import GameProject
from pynq_multimodal_game.game_testing import GameTestCase, InputEvent, InputKind
from pynq_multimodal_game.studio.game_worker import GamePreviewWorker


def test_preview_worker_three_gestures_match_replay_and_reset() -> None:
    from pynq_multimodal_game.game_sdk import HandGesture
    from pynq_multimodal_game.game_validation import GameTestPlayback

    gestures = (HandGesture.PAPER, HandGesture.SCISSORS, HandGesture.FIST, HandGesture.FIST)
    case = GameTestCase("three", "Three", max_ticks=4, events=tuple(
        InputEvent(tick, InputKind.GESTURE, event_id=f"gesture-{tick}", x=280, y=90, gesture=gesture)
        for tick, gesture in enumerate(gestures)
    ))
    replay = GameTestPlayback(case, tick_hz=60)
    worker = GamePreviewWorker(Path("unused.vvg"))
    for tick, gesture in enumerate(gestures):
        worker.inject_gesture(x=280, y=90, gesture=gesture)
        actual, expected = worker._next_input(tick), replay.input_at(tick)
        assert (actual.hand_gesture, actual.gesture_sequence, actual.fist_sequence, actual.fist_event) == (
            expected.hand_gesture, expected.gesture_sequence, expected.fist_sequence, expected.fist_event,
        )
    worker.cancel_inputs()
    assert worker._next_input(4).hand_gesture is None
    worker.inject_gesture(x=280, y=90, gesture=HandGesture.FIST)
    worker.reset()
    reset = worker._next_input(0)
    assert reset.hand_gesture is None and reset.fist_sequence == 0 and not reset.fist_event


def test_preview_worker_schedules_tone_for_requested_duration() -> None:
    worker = GamePreviewWorker(Path("unused.vvg"), tick_hz=10)
    worker.inject_tone(frequency_hz=440.0, duration_ms=250)

    frames = [worker._next_input(index) for index in range(1, 5)]

    assert [frame.tone.active if frame.tone else None for frame in frames] == [
        True,
        True,
        True,
        False,
    ]
    assert frames[0].tone is not None and frames[0].tone.started is True
    assert frames[3].tone is not None and frames[3].tone.ended is True


def test_preview_worker_tracks_input_ids_until_frame_consumption() -> None:
    worker = GamePreviewWorker(Path("unused.vvg"), tick_hz=60)

    hand_id = worker.inject_hand(x=80, y=60, fist=True)
    tone_id = worker.inject_tone(frequency_hz=440.0, duration_ms=250)
    game_input = worker._next_input(7)
    worker._emit_consumed_inputs(7)

    assert hand_id != tone_id
    assert game_input.fist_event is True
    assert game_input.tone is not None and game_input.tone.started is True
    assert worker.last_consumed_input_ids == (hand_id, tone_id)


def test_preview_worker_exposes_pause_step_resume_and_reset_requests() -> None:
    worker = GamePreviewWorker(Path("unused.vvg"))

    worker.pause()
    assert worker.paused is True
    worker.step_once()
    assert worker._take_step_request() is True
    assert worker._take_step_request() is False
    worker.resume()
    assert worker.paused is False
    worker.reset()
    assert worker._reset_requested.is_set()


def test_preview_worker_applies_test_case_events_at_requested_tick() -> None:
    worker = GamePreviewWorker(Path("unused.vvg"), tick_hz=10)
    worker.load_test_case(
        GameTestCase(
            test_id="timeline",
            name="Timeline",
            events=(
                InputEvent(tick=3, kind=InputKind.FIST, event_id="fist-3", x=40, y=50),
                InputEvent(
                    tick=3,
                    kind=InputKind.TONE,
                    event_id="tone-3",
                    frequency_hz=880.0,
                    duration_ms=200,
                ),
            ),
        )
    )

    worker._apply_test_events(2)
    idle = worker._next_input(2)
    worker._apply_test_events(3)
    active = worker._next_input(3)
    worker._emit_consumed_inputs(3)

    assert idle.fist_event is False and idle.tone is None
    assert active.fist_event is True
    assert active.tone is not None and active.tone.frequency_hz == 880.0
    assert worker.last_consumed_input_ids == ("fist-3", "tone-3")


def test_preview_worker_submits_tick_zero_events_on_first_frame(tmp_path: Path) -> None:
    project = GameProject.create(
        tmp_path / "project", game_id="tick-zero", display_name="Tick Zero"
    )
    package = GamePackageBuilder().build(project.root, tmp_path / "tick-zero.vvg")
    worker = GamePreviewWorker(package.path)
    worker.load_test_case(
        GameTestCase(
            test_id="tick-zero",
            name="Tick zero",
            max_ticks=1,
            events=(
                InputEvent(
                    tick=0,
                    kind=InputKind.HAND,
                    event_id="hand-0",
                    x=80,
                    y=60,
                ),
            ),
        )
    )
    frames = []
    worker.frame_ready.connect(frames.append)

    worker.run()

    assert [frame.snapshot.tick_id for frame in frames] == [0, 1]
    assert frames[0].snapshot.values == {"x": 80, "y": 60}
    assert worker.last_consumed_input_ids == ()


@pytest.mark.parametrize("three_state", [False, True])
def test_preview_worker_report_matches_headless_seeded_replay(tmp_path: Path, three_state: bool) -> None:
    from pynq_multimodal_game.game_validation import run_game_test
    from pynq_multimodal_game.game_sdk import HandGesture

    project = GameProject.create(tmp_path / "project", game_id="seeded", display_name="Seeded")
    source = project.root / "src/main.py"
    source.write_text(source.read_text(encoding="utf-8").replace(
        "self._x = context.logical_width // 2",
        "self._seed_value = context.random.randrange(1000)",
    ).replace(
        'values={"x": self._x, "y": self._y}',
        'values={"x": self._x, "y": self._y, "seed_value": self._seed_value}',
    ), encoding="utf-8")
    package = GamePackageBuilder().build(project.root, tmp_path / "seeded.vvg")
    events = tuple(InputEvent(tick, InputKind.GESTURE, event_id=f"gesture-{tick}", x=80, y=60, gesture=gesture)
                   for tick, gesture in enumerate((HandGesture.PAPER, HandGesture.SCISSORS, HandGesture.FIST))) if three_state else ()
    case = GameTestCase("seeded", "Seeded", seed=31, max_ticks=2, events=events)
    worker = GamePreviewWorker(package.path)
    worker.load_test_case(case)
    reports = []
    worker.test_report_ready.connect(reports.append)

    worker.run()

    headless = run_game_test(package.path, case)
    assert len(reports) == 1 and reports[0].passed
    assert reports[0].frames == headless.frames
    assert reports[0].frames != run_game_test(
        package.path, GameTestCase("seeded", "Seeded", seed=32, max_ticks=2),
    ).frames


def test_preview_worker_marks_live_input_as_interactive(tmp_path: Path) -> None:
    project = GameProject.create(tmp_path / "project", game_id="live", display_name="Live")
    package = GamePackageBuilder().build(project.root, tmp_path / "live.vvg")
    worker = GamePreviewWorker(package.path)
    worker.load_test_case(GameTestCase("live", "Live", max_ticks=1))
    worker.ready.connect(lambda _info: worker.inject_hand(x=20, y=30, fist=True))
    reports = []
    worker.test_report_ready.connect(reports.append)

    worker.run()

    assert len(reports) == 1 and reports[0].completed
    assert reports[0].interactive and not reports[0].passed


def test_preview_worker_manual_seed_reset_and_no_report(tmp_path: Path) -> None:
    from pynq_multimodal_game.game_sdk import HandGesture

    root = Path(__file__).resolve().parents[1]
    package = GamePackageBuilder().build(root / "games/game2", tmp_path / "rps.vvg")
    worker = GamePreviewWorker(package.path, seed=19)
    worker.pause()
    reports, inputs, first_countdowns = [], [], []
    worker.test_report_ready.connect(reports.append)
    worker.input_consumed.connect(lambda game_input, source: inputs.append((game_input, source)))
    worker.ready.connect(lambda _info: (worker.inject_gesture(x=160, y=90, gesture=HandGesture.FIST), worker.step_once()))

    def frame_ready(frame):
        if frame.snapshot.values["phase"] == "COUNTDOWN":
            first_countdowns.append(frame.snapshot)
            if len(first_countdowns) == 1:
                worker.reset()
            else:
                worker.stop()
        else:
            worker.step_once()

    worker.frame_ready.connect(frame_ready)
    worker.run()
    assert reports == [] and worker._test_case is None and worker._report is None
    assert first_countdowns[0] == first_countdowns[1]
    assert all(source == "PC 手动" for _, source in inputs)
    assert inputs[0][0].tick_id == 0 and inputs[-1][0].tick_id == 29


@pytest.mark.parametrize("status", ["LOST", "WON"])
def test_game1_manual_preview_finishes_on_terminal_frame(monkeypatch, status):
    from types import SimpleNamespace
    from pynq_multimodal_game.studio import game_worker as module

    stopped = []

    class Preview:
        def __init__(self, *args, **kwargs):
            pass

        def start(self):
            return SimpleNamespace(manifest=SimpleNamespace(tick_hz=60, game_id="game1"))

        def step(self, game_input):
            return SimpleNamespace(snapshot=SimpleNamespace(tick_id=game_input.tick_id, status=status))

        def stop(self):
            stopped.append(True)

    monkeypatch.setattr(module, "GamePreviewProcess", Preview)
    worker = GamePreviewWorker(Path("unused.vvg"))
    frames, states, finished = [], [], []

    def frame_ready(frame):
        frames.append(frame)
        if len(frames) >= 3:
            worker.stop()

    worker.frame_ready.connect(frame_ready)
    worker.state_changed.connect(states.append)
    worker.finished.connect(lambda: finished.append(True))
    worker.run()
    assert len(frames) == 1
    assert states[-1] == status.lower()
    assert stopped == [True] and finished == [True]