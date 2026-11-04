def test_packaged_live_input_consumes_tick_zero_and_following_ticks(monkeypatch, tmp_path):
    import threading
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from pynq_multimodal_game.vision_input import VisionInputProvider

    inputs = []
    delivered = threading.Event()
    provider = VisionInputProvider()
    provider.publish({"run_id": "ps-local", "server_age_ms": 0, "control": {
        "schema": "gesture-control-v1", "frame_id": 1, "action_event_seq": 0,
        "valid": True, "direction": "RIGHT",
    }})

    class Preview:
        def start(self):
            return SimpleNamespace(manifest=SimpleNamespace(tick_hz=60, game_id="mock"))

        def step(self, value):
            inputs.append(value)
            if value.tick_id >= 2:
                delivered.set()
            return SimpleNamespace(asset_packet=b"a" if value.tick_id == 0 else None,
                                   palette_packet=b"p" if value.tick_id == 0 else None,
                                   tilemap_packet=b"t" if value.tick_id == 0 else None,
                                   scene_packet=b"s", scene_sha256=f"scene-{value.tick_id}",
                                   snapshot=SimpleNamespace(tick_id=value.tick_id, status="RUNNING",
                                                            score=0, values={"x": value.hand_x}))

        def stop(self):
            pass

    class Sink:
        def upload_asset(self, packet):
            pass

        def upload_palette(self, packet):
            pass

        def upload_tilemap(self, packet):
            pass

        def submit_scene(self, packet):
            pass

    monkeypatch.setattr(PackagedGameRuntime, "_create_preview", lambda self, **kwargs: Preview())
    runtime = PackagedGameRuntime(tmp_path / "mock.vvg", Sink(), live_input=provider)
    with pytest.raises(RuntimeError, match="separate runtimes"):
        runtime.load_test_case(GameTestCase("test", "Test"))
    with pytest.raises(RuntimeError, match="test injection"):
        runtime.inject_test_input(x=0, y=0)
    runtime.start()
    try:
        assert delivered.wait(2)
        runtime.pause()
        assert not provider.sample(tick_id=999).hand_valid
        runtime.resume()
        assert not provider.sample(tick_id=1000).hand_valid
    finally:
        runtime.stop()
    assert runtime.last_error is None
    assert inputs[0].tick_id == 0
    assert [value.tick_id for value in inputs] == list(range(len(inputs)))
    assert all(value.hand_x == 1 and value.tone is None for value in inputs[:3])
    assert provider.receipt.result.status == "ERROR"
    receipt = runtime.vision_consumption
    assert receipt["run_id"] == "ps-local" and receipt["source_frame_id"] == 1
    assert receipt["sample_tick"] == receipt["scene_tick"]
    assert receipt["scene_sha256"] == f"scene-{receipt['scene_tick']}"
    assert receipt["runtime_presented_frames"] == runtime.presented_frames

from pathlib import Path

import pytest

from pynq_multimodal_game.game_sdk import GameSnapshot
from pynq_multimodal_game.game_testing import (
    AssertionOperator,
    AssertionRule,
    GameTestCase,
    InputEvent,
    InputKind,
    evaluate_assertions,
)


def test_volume_timeline_schema4_roundtrip_and_legacy_json_unchanged():
    from pynq_multimodal_game.game_sdk import VolumeSignal
    signal = VolumeSignal("a" * 32, 2, 1, "LOUD", 1954, 2)
    event = InputEvent(0, InputKind.VOLUME, event_id="v1", volume=signal)
    case = GameTestCase("volume", "Volume", max_ticks=3, events=(event,))
    assert case.schema_version == 4
    assert GameTestCase.from_json(case.to_json()) == case
    legacy = GameTestCase("legacy", "Legacy", max_ticks=3,
                          events=(InputEvent(0, InputKind.HAND, event_id="h1", x=1, y=2),))
    assert legacy.schema_version == 1 and '"volume"' not in legacy.to_json()
    for schema in (1, 2, 3):
        with pytest.raises(ValueError, match="schema 4"):
            GameTestCase("v", "V", max_ticks=3, events=(event,), schema_version=schema)
    with pytest.raises(ValueError, match="at most one"):
        GameTestCase("v", "V", max_ticks=3, events=(event, InputEvent(0, InputKind.VOLUME, event_id="v2", volume=signal)))


@pytest.mark.parametrize("invalid", [None, {}, {"kind": "LOUD"}, "LOUD", {"producer_run": "a" * 32,
    "epoch": True, "sequence": 1, "kind": "LOUD", "source_sample": 1954, "source_window": 2}])
def test_volume_timeline_rejects_missing_or_untrusted_signal(invalid):
    import json
    payload = {"schema_version": 4, "test_id": "v", "name": "V", "max_ticks": 3,
               "events": [{"tick": 0, "kind": "volume", "event_id": "v1", "volume": invalid}]}
    with pytest.raises(ValueError):
        GameTestCase.from_json(json.dumps(payload))


def test_volume_playback_consumes_tick_zero_once_without_fake_tone():
    from pynq_multimodal_game.game_sdk import VolumeSignal
    from pynq_multimodal_game.game_validation import GameTestPlayback
    signal = VolumeSignal("a" * 32, 1, 1, "SOFT", 977, 1)
    case = GameTestCase("v", "V", max_ticks=3, events=(InputEvent(0, InputKind.VOLUME, event_id="v1", volume=signal),))
    playback = GameTestPlayback(case, tick_hz=60)
    assert playback.input_at(0).volume == signal
    assert playback.input_at(1).volume is None
    assert playback.input_at(2).tone is None


def test_volume_report_preserves_input_schema4_after_gesture_only_ticks(tmp_path):
    from pynq_multimodal_game.game_sdk import VolumeSignal
    from pynq_multimodal_game.game_project import GameProject
    from pynq_multimodal_game.game_validation import build_verified_game, run_game_test
    project = GameProject.create(tmp_path / "volume", game_id="volume", display_name="Volume")
    package = build_verified_game(project.root, tmp_path / "volume.vvg")
    signal = VolumeSignal("a" * 32, 1, 1, "LOUD", 977, 1)
    case = GameTestCase("v", "V", max_ticks=2, events=(InputEvent(0, InputKind.VOLUME, event_id="v1", volume=signal),))
    first, second = run_game_test(package.path, case), run_game_test(package.path, case)
    assert first.passed and second.passed
    assert first.frames == second.frames and first.input_schema_version == 4
    assert first.to_dict()["test_case"]["schema_version"] == 4


@pytest.mark.parametrize("fault", ["none", "worker", "input", "step", "submit", "stage"])
def test_game_startup_stages_stop_at_first_failed_operation(monkeypatch, tmp_path, fault):
    from types import SimpleNamespace
    from pynq_multimodal_game.agent import game_runtime
    from pynq_multimodal_game.vision_input import VisionInputProvider
    stages, operations = [], []

    class Preview:
        def start(self):
            operations.append("worker")
            if fault == "worker":
                raise RuntimeError("injected worker failure")
            return SimpleNamespace(manifest=SimpleNamespace(tick_hz=60, game_id="mock"))

        def step(self, value):
            operations.append("step")
            if fault == "step":
                raise RuntimeError("injected step failure")
            return SimpleNamespace(snapshot=SimpleNamespace(status="RUNNING"))

    def record(stage):
        stages.append(stage)
        if fault == "stage" and stage == "game_first_scene_submit_begin":
            raise RuntimeError("injected stage failure")

    def submit(*args, **kwargs):
        operations.append("submit")
        assert kwargs["require_resources"] is True
        if fault == "submit":
            raise RuntimeError("injected submit failure")

    monkeypatch.setattr(game_runtime.PackagedGameRuntime, "_create_preview", lambda *args, **kwargs: Preview())
    runtime = game_runtime.PackagedGameRuntime(tmp_path / "mock.vvg", object(), live_input=VisionInputProvider())
    runtime._diagnostic_startup_stage = record
    runtime._submit = submit
    if fault == "input":
        def bad_input(tick):
            raise RuntimeError("injected input failure")
        runtime._sample_live_input = bad_input
    monkeypatch.setattr(game_runtime, "threading", SimpleNamespace(
        Thread=lambda **kwargs: SimpleNamespace(start=lambda: None)))
    expected = ["game_worker_start_begin", "game_worker_ready", "game_first_input_begin",
                "game_first_input_complete", "game_first_step_begin", "game_first_step_complete",
                "game_first_scene_submit_begin", "game_first_scene_submit_complete"]
    if fault == "none":
        runtime.start()
        assert stages == expected and operations == ["worker", "step", "submit"]
    else:
        with pytest.raises(RuntimeError, match="injected " + fault + " failure"):
            runtime.start()
        count = {"worker": 1, "input": 3, "step": 5, "submit": 7, "stage": 7}[fault]
        assert stages == expected[:count]
        assert operations == {"worker": ["worker"], "input": ["worker"], "step": ["worker", "step"],
                              "submit": ["worker", "step", "submit"], "stage": ["worker", "step"]}[fault]


@pytest.mark.parametrize("with_audio", [False, True])
def test_live_vision_receipt_waits_for_own_scene_completion(monkeypatch, tmp_path, with_audio):
    import threading
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from pynq_multimodal_game.vision_input import VisionInputProvider
    from pynq_multimodal_game.multimodal_input import MultimodalGameInputProvider
    from pynq_multimodal_game.voice_observations import VoiceObservationBus, VoiceResultValidator

    class Sink:
        upload_render_overlap_enabled = True
        fail = False
        block = False
        entered = threading.Event()
        release = threading.Event()

        def enqueue_scene(self, packet):
            return packet

        def wait_scene(self, ticket):
            if self.fail:
                raise RuntimeError("sink completion failed")
            if self.block:
                self.entered.set()
                assert self.release.wait(2)

        def drain(self):
            pass

    monkeypatch.setattr(PackagedGameRuntime, "_create_preview", lambda self, **kwargs: object())
    sink = Sink()
    visual = VisionInputProvider(clock=lambda: 1.)
    bus = VoiceObservationBus()
    bus.begin_epoch("voice", "epoch")
    validator = VoiceResultValidator("voice", "epoch")
    provider = (MultimodalGameInputProvider(visual, bus, max_audio_age_ns=100_000_000)
                if with_audio else visual)
    runtime = PackagedGameRuntime(tmp_path / "mock.vvg", sink, live_input=provider)
    for tick, direction in ((0, "LEFT"), (1, "RIGHT")):
        visual.publish({"run_id": "queue", "server_age_ms": 0, "control": {
            "schema": "gesture-control-v1", "frame_id": tick + 1, "action_event_seq": 0,
            "valid": True, "direction": direction,
        }})
        bus.publish(validator.accept(("result", tick, [], .001, 1. + tick / 100)))
        value, receipt = provider.sample_with_receipt(tick_id=tick, timestamp_ns=1_000_000_000 + tick * 10_000_000)
        audio = provider.audio_receipt_for_tick(tick) if with_audio else None
        frame = SimpleNamespace(asset_packet=None, palette_packet=None, tilemap_packet=None,
                                scene_packet=f"packet-{tick}".encode(), scene_sha256=f"scene-{tick}",
                                snapshot=SimpleNamespace(tick_id=tick, status="RUNNING", score=0,
                                                         values={"x": value.hand_x}))
        runtime._submit(frame, vision_receipt=receipt, audio_receipt=audio)
        if audio is not None:
            audio["events"].append({"mutated": True})
    assert runtime.vision_consumption is None and runtime.presented_frames == 0
    assert runtime.audio_consumption is None
    runtime._retire_oldest()
    first = runtime.vision_consumption
    first_audio = runtime.audio_consumption
    if with_audio:
        assert first_audio["packet_index"] == 0 and first_audio["scene_tick"] == 0
        assert first_audio["scene_sha256"] == "scene-0" and first_audio["events"] == []
        assert first_audio["sink_completion"] == "confirmed" and not first_audio["action_mapped"]
        altered = runtime.audio_consumption
        altered["scene_sha256"] = "wrong"
        assert runtime.audio_consumption == first_audio
    assert first["source_frame_id"] == 1 and first["scene_tick"] == 0
    assert first["scene_sha256"] == "scene-0" and first["game_values"]["x"] == -1
    copied = runtime.vision_consumption
    copied["game_values"]["x"] = 999
    assert runtime.vision_consumption == first
    sink.fail = True
    with pytest.raises(RuntimeError, match="completion failed"):
        runtime._retire_oldest()
    assert runtime.vision_consumption == first and runtime.presented_frames == 1
    assert runtime.audio_consumption == first_audio
    sink.fail = False
    sink.block = True
    worker = threading.Thread(target=runtime._drain)
    reader_done = threading.Event()
    readbacks = []

    def read_receipt():
        readbacks.append(runtime.vision_consumption)
        reader_done.set()

    reader = threading.Thread(target=read_receipt)
    worker.start()
    try:
        assert sink.entered.wait(1)
        reader.start()
        assert reader_done.wait(.5)
        assert readbacks == [first]
    finally:
        sink.release.set()
        worker.join(2)
        if reader.ident is not None:
            reader.join(2)
    assert not worker.is_alive() and not reader.is_alive()
    second = runtime.vision_consumption
    bundle = runtime.input_consumptions
    assert bundle["vision"] == second and bundle["frame"].scene_sha256 == "scene-1"
    if with_audio:
        assert bundle["audio"]["packet_index"] == 1 and bundle["audio"]["scene_tick"] == 1
        assert bundle["audio"]["scene_sha256"] == "scene-1"
    assert second["source_frame_id"] == 2 and second["scene_tick"] == 1
    assert second["scene_sha256"] == "scene-1" and second["game_values"]["x"] == 1


def test_gesture_state_separates_classification_and_fist_edges() -> None:
    from pynq_multimodal_game.game_sdk import GameInput, GestureState, HandGesture

    state = GestureState()
    for gesture, sequence, fist_sequence, fist_event in (
        (HandGesture.PAPER, 1, 0, False),
        (HandGesture.SCISSORS, 2, 0, False),
        (HandGesture.FIST, 3, 1, True),
        (HandGesture.FIST, 3, 1, False),
        (None, 4, 1, False),
    ):
        state.update(gesture)
        game_input = GameInput.from_logical_position(
            tick_id=0, timestamp_ns=0, x=160, y=90, **state.consume(),
        )
        assert game_input.hand_gesture is gesture
        assert game_input.gesture_sequence == sequence
        assert game_input.fist_sequence == fist_sequence
        assert game_input.fist_event is fist_event
        assert game_input.has_gesture_input
    assert not GameInput(0, 0, True, 0, 0, 0, False).has_gesture_input
    state.apply_legacy(fist=True)
    state.update(None)
    assert not state.consume()["fist_event"]
    with pytest.raises(ValueError, match="requires the fist"):
        GameInput(0, 0, True, 0, 0, 1, True, hand_gesture=HandGesture.SCISSORS)


def test_game_test_case_round_trips_and_selects_tick_events(tmp_path: Path) -> None:
    case = GameTestCase(
        test_id="manual-smoke",
        name="Manual smoke",
        max_ticks=120,
        events=(
            InputEvent(tick=2, kind=InputKind.HAND, event_id="hand-1", x=80, y=60),
            InputEvent(tick=2, kind=InputKind.FIST, event_id="fist-1", x=80, y=60),
            InputEvent(
                tick=5,
                kind=InputKind.TONE,
                event_id="tone-1",
                frequency_hz=440.0,
                duration_ms=250,
            ),
        ),
        assertions=(
            AssertionRule(5, "score", AssertionOperator.GREATER_EQUAL, 10),
        ),
    )
    path = tmp_path / "case.json"

    case.save(path)
    loaded = GameTestCase.load(path)

    assert loaded == case
    assert [event.event_id for event in loaded.events_at(2)] == ["hand-1", "fist-1"]
    assert loaded.events_at(3) == ()


def test_assertions_read_snapshot_and_nested_values() -> None:
    snapshot = GameSnapshot(7, "RUNNING", score=12, values={"player": {"x": 80}})
    rules = (
        AssertionRule(7, "score", AssertionOperator.GREATER_THAN, 10),
        AssertionRule(7, "values.player.x", AssertionOperator.EQUAL, 80),
    )

    results = evaluate_assertions(snapshot, rules)

    assert [result.passed for result in results] == [True, True]
    assert [result.actual for result in results] == [12, 80]


def test_game_test_case_rejects_unsorted_events() -> None:
    with pytest.raises(ValueError, match="sorted"):
        GameTestCase(
            test_id="bad",
            name="Bad",
            events=(
                InputEvent(tick=2, kind=InputKind.CANCEL, event_id="b"),
                InputEvent(tick=1, kind=InputKind.CANCEL, event_id="a"),
            ),
        )


@pytest.mark.parametrize("kind", ["event", "assertion"])
def test_game_test_case_rejects_unreachable_ticks(kind: str) -> None:
    with pytest.raises(ValueError, match="tick range"):
        GameTestCase(
            test_id="outside",
            name="Outside",
            max_ticks=2,
            events=(InputEvent(3, InputKind.CANCEL, event_id="cancel"),)
            if kind == "event" else (),
            assertions=(AssertionRule(3, "score", AssertionOperator.EQUAL, 0),)
            if kind == "assertion" else (),
        )


def test_game_test_case_rejects_duplicate_input_ids() -> None:
    with pytest.raises(ValueError, match="IDs must be unique"):
        GameTestCase(
            test_id="duplicate",
            name="Duplicate",
            events=(
                InputEvent(0, InputKind.CANCEL, event_id="same"),
                InputEvent(1, InputKind.CANCEL, event_id="same"),
            ),
        )


def test_game_test_case_bounds_report_memory() -> None:
    from pynq_multimodal_game.game_testing import MAX_TEST_TICKS

    with pytest.raises(ValueError, match="exceeds"):
        GameTestCase("large", "Large", max_ticks=MAX_TEST_TICKS + 1)


def test_shared_playback_preserves_order_and_uses_logical_time() -> None:
    from pynq_multimodal_game.game_validation import GameTestPlayback

    case = GameTestCase("ordered", "Ordered", max_ticks=2, events=(
        InputEvent(0, InputKind.FIST, event_id="fist", x=20, y=30),
        InputEvent(0, InputKind.HAND, event_id="hand", x=40, y=50),
        InputEvent(1, InputKind.FIST, event_id="fist2", x=40, y=50),
        InputEvent(1, InputKind.CANCEL, event_id="cancel"),
    ))
    playback = GameTestPlayback(case, tick_hz=60)
    first = playback.input_at(0)
    second = playback.input_at(1)
    assert first.fist_event is True
    assert first.hand_x == 40 * 2 / 319 - 1
    assert first.timestamp_ns == 0
    assert second.fist_event is False
    assert second.timestamp_ns == 1_000_000_000 // 60


def test_shared_playback_ends_tone_after_duration() -> None:
    from pynq_multimodal_game.game_validation import GameTestPlayback

    case = GameTestCase("tone", "Tone", max_ticks=2, events=(
        InputEvent(0, InputKind.TONE, event_id="tone", frequency_hz=440, duration_ms=16),
    ))
    playback = GameTestPlayback(case, tick_hz=60)
    first = playback.input_at(0).tone
    ended = playback.input_at(1).tone
    assert first is not None and first.started and first.active
    assert ended is not None and ended.ended and not ended.active
    assert playback.input_at(2).tone is None


def test_three_gesture_replay_round_trip_hold_and_cancel() -> None:
    from pynq_multimodal_game.game_sdk import HandGesture
    from pynq_multimodal_game.game_validation import GameTestPlayback

    case = GameTestCase("gestures", "Gestures", max_ticks=5, events=tuple(
        InputEvent(tick, InputKind.GESTURE, event_id=f"gesture-{tick}", x=280, y=90, gesture=gesture)
        for tick, gesture in enumerate((HandGesture.PAPER, HandGesture.SCISSORS, HandGesture.FIST, HandGesture.FIST))
    ) + (InputEvent(4, InputKind.CANCEL, event_id="cancel"),))
    assert case.schema_version == 2
    assert GameTestCase.from_json(case.to_json()) == case
    playback = GameTestPlayback(case, tick_hz=60)
    frames = [playback.input_at(tick) for tick in range(6)]
    assert [frame.fist_event for frame in frames] == [False, False, True, False, False, False]
    assert [frame.fist_sequence for frame in frames] == [0, 0, 1, 1, 1, 1]
    assert frames[3].hand_gesture is HandGesture.FIST
    assert frames[4].hand_gesture is None and frames[4].has_gesture_input
    with pytest.raises(ValueError, match="schema 2"):
        GameTestCase("bad", "Bad", events=case.events, schema_version=1)


def test_headless_report_is_reproducible_and_tracks_first_divergence(tmp_path: Path) -> None:
    import copy
    import json
    from dataclasses import asdict
    from pynq_multimodal_game.game_sdk import GameInput
    from pynq_multimodal_game.game_project import GameProject
    from pynq_multimodal_game.game_validation import (
        build_verified_game, compare_test_reports, run_game_test,
    )

    project = GameProject.create(tmp_path / "game", game_id="report", display_name="Report")
    package = build_verified_game(project.root, tmp_path / "report.vvg")
    case = GameTestCase("report", "Report", seed=17, max_ticks=2, assertions=(
        AssertionRule(2, "score", AssertionOperator.EQUAL, 0),
    ))
    report = run_game_test(package.path, case)
    repeated = run_game_test(package.path, case)
    assert report.passed and repeated.passed
    assert report.frames == repeated.frames
    legacy_input = asdict(GameInput.from_logical_position(tick_id=0, timestamp_ns=0, x=160, y=90))
    for key in ("hand_gesture", "gesture_sequence", "gesture_changed", "actions", "volume", "button"):
        legacy_input.pop(key)
    import hashlib
    expected_hash = hashlib.sha256(json.dumps(legacy_input, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode()).hexdigest()
    assert report.frames[0]["input_sha256"] == expected_hash
    assert report.to_dict()["hardware_acceptance"] == "pending"
    saved = report.save(tmp_path / "report.json")
    assert json.loads(saved.read_text(encoding="utf-8"))["package"]["sha256"] == package.sha256
    other = copy.deepcopy(repeated.to_dict())
    other["target"] = "pynq"
    assert compare_test_reports(report.to_dict(), other)["status"] == "passed"
    other["input_schema_version"] = 2
    assert compare_test_reports(report.to_dict(), other)["reason"] == "different input_schema_version"
    other["input_schema_version"] = 1
    other["frames"][1]["state_sha256"] = "different"
    assert compare_test_reports(report.to_dict(), other)["first_divergent_tick"] == 1


def test_report_retains_assertion_errors_and_incomplete_evidence(tmp_path: Path) -> None:
    from pynq_multimodal_game.game_project import GameProject
    from pynq_multimodal_game.game_validation import build_verified_game, run_game_test

    project = GameProject.create(tmp_path / "game", game_id="failure", display_name="Failure")
    package = build_verified_game(project.root, tmp_path / "failure.vvg")
    case = GameTestCase("failure", "Failure", max_ticks=1, assertions=(
        AssertionRule(0, "values.missing", AssertionOperator.EQUAL, 0),
        AssertionRule(1, "score", AssertionOperator.EQUAL, 10),
    ))
    report = run_game_test(package.path, case)
    assert report.completed and not report.passed
    assert len(report.assertions) == 2
    assert "values.missing" in report.errors[0]
    report.frames.pop()
    assert not report.completed and not report.passed


def test_headless_validation_can_be_cancelled(tmp_path: Path) -> None:
    import threading
    from pynq_multimodal_game.game_project import GameProject
    from pynq_multimodal_game.game_validation import build_verified_game, run_game_test

    project = GameProject.create(tmp_path / "game", game_id="cancelled", display_name="Cancelled")
    package = build_verified_game(project.root, tmp_path / "cancelled.vvg")
    stop = threading.Event()
    stop.set()
    report = run_game_test(package.path, GameTestCase("cancel", "Cancel"), stop_event=stop)
    assert not report.passed and not report.completed
    assert report.frames == []
    assert "cancelled" in report.errors[0]


def test_report_comparison_rejects_fabricated_empty_pass() -> None:
    from pynq_multimodal_game.game_validation import compare_test_reports

    fake = {"status": "passed", "frames": []}
    assert compare_test_reports(fake, fake)["status"] == "failed"


def test_double_build_failure_preserves_previous_package(tmp_path: Path, monkeypatch) -> None:
    from dataclasses import replace
    from pynq_multimodal_game.game_package import GamePackageBuilder
    from pynq_multimodal_game.game_project import GameProject
    from pynq_multimodal_game.game_validation import build_verified_game

    project = GameProject.create(tmp_path / "game", game_id="atomic", display_name="Atomic")
    output = tmp_path / "atomic.vvg"
    build_verified_game(project.root, output)
    previous = output.read_bytes()
    original = GamePackageBuilder.build
    calls = []

    def unstable_build(self, root, path):
        info = original(self, root, path)
        calls.append(path)
        return replace(info, sha256="different") if len(calls) == 2 else info

    monkeypatch.setattr(GamePackageBuilder, "build", unstable_build)
    with pytest.raises(RuntimeError, match="double-build"):
        build_verified_game(project.root, output)
    assert output.read_bytes() == previous


class _TicketSink:
    upload_render_overlap_enabled = True

    def __init__(self):
        self.pending = []
        self.operations = []

    def enqueue_scene(self, packet):
        assert len(self.pending) < 2
        self.pending.append(packet)
        self.operations.append(("enqueue", packet))
        return packet

    def wait_scene(self, ticket):
        assert self.pending.pop(0) == ticket
        self.operations.append(("wait", ticket))

    def drain(self):
        assert not self.pending
        self.operations.append(("drain", None))

    def upload_asset(self, packet):
        assert not self.pending
        self.operations.append(("asset", packet))

    upload_palette = upload_asset
    upload_tilemap = upload_asset

    def submit_scene(self, packet):
        self.operations.append(("submit", packet))


def _runtime_frame(sequence, **resources):
    from types import SimpleNamespace

    return SimpleNamespace(
        scene_packet=bytes([sequence]),
        asset_packet=resources.get("asset"),
        palette_packet=resources.get("palette"),
        tilemap_packet=resources.get("tilemap"),
    )


def test_runtime_overlap_bounds_tickets_and_counts_only_retirement():
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime

    sink = _TicketSink()
    runtime = PackagedGameRuntime(Path("unused.vvg"), sink)
    frames = [_runtime_frame(sequence) for sequence in range(3)]
    runtime._submit(frames[0])
    runtime._submit(frames[1])
    assert runtime.presented_frames == 0
    assert runtime.last_frame is None
    runtime._submit(frames[2])
    assert runtime.presented_frames == 1
    assert runtime.last_frame is frames[0]
    assert len(sink.pending) == 2
    runtime._drain()
    assert runtime.presented_frames == 3
    assert runtime.last_frame is frames[2]
    assert not sink.pending


@pytest.mark.parametrize("enabled", [False, None])
def test_runtime_overlap_requires_public_opt_in(enabled):
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime

    sink = _TicketSink()
    sink.upload_render_overlap_enabled = enabled
    sink._overlap_enabled = True
    runtime = PackagedGameRuntime(Path("unused.vvg"), sink)
    frame = _runtime_frame(0)
    runtime._submit(frame)
    assert sink.operations == [("submit", frame.scene_packet)]
    assert runtime.presented_frames == 1
    assert runtime.last_frame is frame


@pytest.mark.parametrize("resource", ["asset", "palette", "tilemap"])
def test_runtime_overlap_drains_before_resource_updates(resource):
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime

    sink = _TicketSink()
    runtime = PackagedGameRuntime(Path("unused.vvg"), sink)
    runtime._submit(_runtime_frame(0))
    runtime._submit(_runtime_frame(1))
    runtime._submit(_runtime_frame(2, **{resource: b"resource"}))
    assert [operation for operation, _ in sink.operations[:6]] == [
        "enqueue", "enqueue", "wait", "wait", "drain", "asset",
    ]
    assert runtime.presented_frames == 2


@pytest.mark.parametrize("requested,capable", [(False, False), (False, True), (True, False), (True, True)])
def test_video_sink_public_overlap_capability_requires_request_and_verification(requested, capable):
    from pynq_multimodal_game.agent.c6i_video import C6IVideoSink

    sink = C6IVideoSink.__new__(C6IVideoSink)
    sink._overlap_enabled = requested
    sink._overlap_mmio = object() if capable else None
    assert sink.upload_render_overlap_enabled is (requested and capable)


@pytest.mark.parametrize("missing", ["enqueue_scene", "wait_scene", "drain"])
def test_runtime_overlap_requires_complete_optional_interface(missing):
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime

    sink = _TicketSink()
    setattr(sink, missing, None)
    runtime = PackagedGameRuntime(Path("unused.vvg"), sink)
    runtime._submit(_runtime_frame(0))
    assert sink.operations == [("submit", b"\0")]
    assert runtime.presented_frames == 1


def test_runtime_initial_frame_remains_synchronous():
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime

    sink = _TicketSink()
    runtime = PackagedGameRuntime(Path("unused.vvg"), sink)
    first = _runtime_frame(0, asset=b"a", palette=b"p", tilemap=b"t")
    runtime._submit(first, require_resources=True)
    assert not sink.pending
    assert runtime.presented_frames == 1
    assert runtime.last_frame is first


def test_runtime_failed_retirement_does_not_count_frame_and_stop_cleans_preview():
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime

    class FailedSink(_TicketSink):
        def wait_scene(self, ticket):
            raise RuntimeError("retirement rejected")

    sink = FailedSink()
    runtime = PackagedGameRuntime(Path("unused.vvg"), sink)
    runtime._submit(_runtime_frame(0))
    stopped = []
    runtime._preview = SimpleNamespace(stop=lambda: stopped.append(True))
    with pytest.raises(RuntimeError, match="retirement rejected"):
        runtime.stop()
    assert runtime.presented_frames == 0
    assert runtime.last_frame is None
    assert len(runtime._pending_scenes) == 1
    assert stopped == [True]


@pytest.mark.parametrize("three_state", [False, True])
@pytest.mark.parametrize("max_ticks", [1, 4])
def test_runtime_overlap_report_matches_pc_after_final_drain(tmp_path, max_ticks, three_state):
    import threading
    import time
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from pynq_multimodal_game.game_package import GamePackageBuilder
    from pynq_multimodal_game.game_project import GameProject
    from pynq_multimodal_game.game_validation import compare_test_reports, run_game_test
    from pynq_multimodal_game.game_sdk import HandGesture

    project = GameProject.create(tmp_path / "game", game_id="pipeline", display_name="Pipeline")
    package = GamePackageBuilder().build(project.root, tmp_path / "pipeline.vvg")
    case = GameTestCase("pipeline", "Pipeline", seed=23, max_ticks=max_ticks, events=(
        InputEvent(0, InputKind.GESTURE if three_state else InputKind.FIST, event_id="fist0", x=80, y=60,
               gesture=HandGesture.FIST if three_state else None),
        InputEvent(max_ticks, InputKind.TONE, event_id="tone", frequency_hz=440, duration_ms=16),
    ), assertions=(AssertionRule(max_ticks, "tick_id", AssertionOperator.EQUAL, max_ticks),))
    sink = _TicketSink()
    runtime = PackagedGameRuntime(package.path, sink)
    runtime.load_test_case(case)
    try:
        runtime.start()
        deadline = time.monotonic() + 3
        while not runtime.test_complete and runtime.last_error is None and time.monotonic() < deadline:
            threading.Event().wait(0.01)
        assert runtime.last_error is None
        assert runtime.test_complete
        assert runtime.paused
        assert runtime.tick_id == max_ticks
        assert runtime.presented_frames == max_ticks + 1
        assert not sink.pending
        assert not runtime._pending_scenes
        report = runtime.test_report
        assert report is not None
        assert report["input_schema_version"] == (2 if three_state else 1)
        comparison = compare_test_reports(run_game_test(package.path, case).to_dict(), report)
        assert comparison["status"] == "passed", comparison
        assert comparison["matched_ticks"] == max_ticks + 1
        with pytest.raises(RuntimeError, match="completed"):
            runtime.step_once()
    finally:
        runtime.stop()


def test_runtime_manual_gestures_cancel_without_stale_fist() -> None:
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from pynq_multimodal_game.game_sdk import HandGesture

    runtime = PackagedGameRuntime(Path("unused.vvg"), _TicketSink())
    for gesture, sequence in (("scissors", 0), ("paper", 0), ("fist", 1), ("fist", 1)):
        runtime.inject_test_input(x=319, y=90, gesture=gesture)
        fields = runtime._gesture.consume()
        assert fields["hand_gesture"] is HandGesture(gesture)
        assert fields["fist_sequence"] == sequence
        assert runtime._latest_control.hand_x == 1.0
    runtime.cancel_test_input()
    fields = runtime._gesture.consume()
    assert fields["hand_gesture"] is None and not fields["fist_event"]
    with pytest.raises(ValueError):
        runtime.inject_test_input(x=400, y=90, gesture="paper")
    assert runtime._gesture.gesture is None


def test_runtime_error_drains_before_publishing_failure_report():
    from types import SimpleNamespace
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime

    class BrokenPreview:
        def step(self, game_input):
            raise RuntimeError("preview failed")

    sink = _TicketSink()
    runtime = PackagedGameRuntime(Path("unused.vvg"), sink)
    runtime._submit(_runtime_frame(0))
    runtime._submit(_runtime_frame(1))
    runtime._preview = BrokenPreview()
    runtime._report = SimpleNamespace(errors=[])
    runtime._run(10_000)
    assert runtime.last_error == "RuntimeError: preview failed"
    assert runtime._report.errors == [runtime.last_error]
    assert not sink.pending
    assert runtime.presented_frames == 2
    assert not runtime.test_complete


def test_runtime_overlap_pause_step_and_stop_drain(tmp_path):
    import threading
    import time
    from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
    from pynq_multimodal_game.game_package import GamePackageBuilder
    from pynq_multimodal_game.game_project import GameProject

    ready = threading.Event()

    class ControlledSink(_TicketSink):
        def enqueue_scene(self, packet):
            ticket = super().enqueue_scene(packet)
            if len(self.pending) == 2:
                ready.set()
            return ticket

    project = GameProject.create(tmp_path / "game", game_id="controls", display_name="Controls")
    package = GamePackageBuilder().build(project.root, tmp_path / "controls.vvg")
    sink = ControlledSink()
    runtime = PackagedGameRuntime(package.path, sink)
    try:
        runtime.start()
        assert ready.wait(3)
        runtime.pause()
        tick = runtime.tick_id
        count = runtime.presented_frames
        assert count == tick + 1
        assert not sink.pending
        runtime.step_once()
        deadline = time.monotonic() + 3
        while runtime.presented_frames == count and runtime.last_error is None and time.monotonic() < deadline:
            threading.Event().wait(0.01)
        assert runtime.last_error is None
        assert runtime.tick_id == tick + 1
        assert runtime.presented_frames == count + 1
        assert not sink.pending
        ready.clear()
        runtime.resume()
        assert ready.wait(3)
        runtime.stop()
        assert runtime.presented_frames == runtime.tick_id + 1
        assert not sink.pending
        assert not runtime._pending_scenes
    finally:
        runtime.stop()
