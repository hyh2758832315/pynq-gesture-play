from __future__ import annotations

from dataclasses import asdict, replace
from copy import deepcopy
from pathlib import Path
import math
import threading
import time
from typing import Callable, Protocol
import uuid

from ..controls import ControlSource, ControlState, Direction
from ..game_actions import GameActionFrame
from ..game_runner import GameFrame, GamePreviewProcess
from ..game_sdk import GameInput, GestureState, HandGesture, ToneSignal
from ..game_testing import GameTestCase, InputEvent, InputKind
from ..game_validation import GameTestPlayback, GameTestReport, fixture_run_id


class GameSink(Protocol):
    def upload_palette(self, packet: bytes) -> None: ...

    def upload_asset(self, packet: bytes) -> None: ...

    def upload_tilemap(self, packet: bytes) -> None: ...

    def submit_scene(self, packet: bytes) -> None: ...


class LiveGameInput(Protocol):
    def sample(self, *, tick_id: int, timestamp_ns: int | None = None) -> GameInput: ...
    def suspend(self) -> None: ...
    def resume(self) -> None: ...
    def release(self, message: str = "Vision producer stopped") -> None: ...


class PackagedGameRuntime:
    def __init__(
        self,
        package_path: Path,
        sink: GameSink,
        *,
        generation: int = 0xC6B00001,
        live_input: LiveGameInput | None = None,
        scene_transform: Callable[[GameFrame], GameFrame] | None = None,
    ) -> None:
        self.package_path = Path(package_path)
        self._sink = sink
        self._generation = generation
        self._live_input = live_input
        self._scene_transform = scene_transform or (lambda frame: frame)
        self._input_released = False
        self._game_id = ""
        self._manifest = None
        self._game_run = uuid.uuid4().hex
        self._revoked_epoch = "revoked-" + uuid.uuid4().hex
        self._preview = self._create_preview(seed=0)
        self._lock = threading.Lock()
        self._submission_lock = threading.RLock()
        self._preview_upload_overlap = False
        self._deferred_scene = None
        self._failed_deferred_scene = None
        self._pending_scenes: list[tuple[object, GameFrame, dict | None, dict | None]] = []
        self._completed_scene: tuple[GameFrame, int, dict | None, dict | None] | None = None
        self._enqueue_scene = getattr(sink, "enqueue_scene", None)
        self._wait_scene = getattr(sink, "wait_scene", None)
        self._sink_drain = getattr(sink, "drain", None)
        self._pipeline_enabled = (
            getattr(sink, "upload_render_overlap_enabled", False) is True
            and callable(self._enqueue_scene)
            and callable(self._wait_scene)
            and callable(self._sink_drain)
        )
        self._stop = threading.Event()
        self._wake = threading.Event()
        self._paused = threading.Event()
        self._thread: threading.Thread | None = None
        self._latest_control = _idle_control()
        self._gesture = GestureState()
        self._tick_id = 0
        self._presented_frames = 0
        self._last_error: str | None = None
        self._tone_frequency = 0.0
        self._tone_ticks = 0
        self._tone_total = 0
        self._tone_sequence = 0
        self._tick_hz = 60
        self._step_requests = 0
        self._last_frame: GameFrame | None = None
        self._pending_input_ids: list[str] = []
        self._accepted_input_id: str | None = None
        self._consumed_input_id: str | None = None
        self._test_case: GameTestCase | None = None
        self._assertions_passed = 0
        self._assertions_failed = 0
        self._test_complete = False
        self._playback: GameTestPlayback | None = None
        self._report: GameTestReport | None = None

    @property
    def running(self) -> bool:
        thread = self._thread
        return thread is not None and thread.is_alive() and self._last_error is None

    @property
    def presented_frames(self) -> int:
        completed = self._completed_scene
        return 0 if completed is None else completed[1]

    @property
    def last_error(self) -> str | None:
        return self._last_error

    @property
    def test_report(self) -> dict[str, object] | None:
        with self._lock:
            if self._report is None or not (self._test_complete or self._report.errors):
                return None
            return self._report.to_dict()

    @property
    def paused(self) -> bool:
        return self._paused.is_set()

    @property
    def tick_id(self) -> int:
        return self._tick_id

    @property
    def last_frame(self) -> GameFrame | None:
        completed = self._completed_scene
        return None if completed is None else completed[0]

    @property
    def vision_consumption(self) -> dict[str, object] | None:
        completed = self._completed_scene
        return None if completed is None else deepcopy(completed[2])

    @property
    def audio_consumption(self) -> dict[str, object] | None:
        completed = self._completed_scene
        receipt = None if completed is None else completed[3]
        return None if receipt is None or receipt.get("schema") == "volume-input-receipt-v1" else deepcopy(receipt)

    @property
    def volume_consumption(self) -> dict[str, object] | None:
        completed = self._completed_scene
        receipt = None if completed is None else completed[3]
        return deepcopy(receipt) if receipt is not None and receipt.get("schema") == "volume-input-receipt-v1" else None

    @property
    def action_permit(self):
        return deepcopy(getattr(self._live_input, "action_permit", None))

    @property
    def input_consumptions(self) -> dict:
        completed = self._completed_scene
        if completed is None:
            return {"frame": None, "presented_frames": 0, "vision": None, "audio": None, "volume": None}
        frame, count, visual, audio = completed
        is_volume = audio is not None and audio.get("schema") == "volume-input-receipt-v1"
        return {"frame": frame, "presented_frames": count,
                "vision": deepcopy(visual), "audio": None if is_volume else deepcopy(audio),
                "volume": deepcopy(audio) if is_volume else None}

    @property
    def accepted_input_id(self) -> str | None:
        return self._accepted_input_id

    @property
    def consumed_input_id(self) -> str | None:
        return self._consumed_input_id

    @property
    def assertions_passed(self) -> int:
        return self._assertions_passed

    @property
    def assertions_failed(self) -> int:
        return self._assertions_failed

    @property
    def test_complete(self) -> bool:
        return self._test_complete

    def load_test_case(self, test_case: GameTestCase) -> None:
        if self._thread is not None:
            raise RuntimeError("test case must be loaded before the game starts")
        if self._live_input is not None:
            raise RuntimeError("live vision and test playback require separate runtimes")
        self._test_case = test_case
        self._game_run = fixture_run_id(test_case)
        if isinstance(self._preview, GamePreviewProcess):
            self._preview.stop()
        self._preview = self._create_preview(seed=test_case.seed)

    def start(self) -> None:
        if self._thread is not None:
            raise RuntimeError("packaged game is already started")
        stage = getattr(self, "_diagnostic_startup_stage", None) or (lambda _stage: None)
        stage("game_worker_start_begin")
        info = self._preview.start()
        stage("game_worker_ready")
        self._tick_hz = info.manifest.tick_hz
        self._game_id = info.manifest.game_id
        self._manifest = info.manifest
        if self._live_input is not None:
            factory = getattr(self._live_input, "new_game_session", None)
            if callable(factory):
                self._live_input = factory(info.manifest, self._game_run)
                self._input_released = False
            elif getattr(info.manifest, "inputs", None) is not None:
                self._preview.stop()
                raise RuntimeError("action candidate requires a per-game input session factory")
        elif self._test_case is None and getattr(info.manifest, "inputs", None) is not None:
            self._preview.stop()
            raise RuntimeError("action candidate requires a declared live session or schema 3 playback")
        with self._lock:
            if self._test_case is not None:
                self._playback = GameTestPlayback(self._test_case, tick_hz=self._tick_hz, manifest=info.manifest)
                self._report = GameTestReport(info, self._test_case, "pynq")
            self._apply_test_events_locked(0)
            test_input = None if self._playback is None else self._playback.input_at(0)
            control = self._latest_control
            tone = self._next_tone_locked()
            gesture_fields = self._gesture.consume() if self._gesture.enabled else {}
            consumed = tuple(self._pending_input_ids)
            self._pending_input_ids.clear()
            if consumed:
                self._consumed_input_id = consumed[-1]
            if control.fist_event:
                self._latest_control = replace(
                    control, fist_score=0.0, fist_event=False
                )
        game_input = test_input if test_input is not None else replace(
                GameInput.from_control_state(control, tone=tone),
                tick_id=0,
                timestamp_ns=time.monotonic_ns(),
                **gesture_fields,
            )
        vision_receipt = None
        audio_receipt = None
        stage("game_first_input_begin")
        if self._live_input is not None:
            game_input, vision_receipt = self._sample_live_input(0)
            audio_receipt = self._sample_audio_receipt(0)
        elif self._playback is not None:
            audio_receipt = deepcopy(self._playback.audio_receipt)
        game_input, audio_receipt = self._validate_actions(game_input, audio_receipt)
        stage("game_first_input_complete")
        stage("game_first_step_begin")
        first = self._preview.step(game_input)
        stage("game_first_step_complete")
        stage("game_first_scene_submit_begin")
        self._submit(self._scene_transform(first), require_resources=True,
                     vision_receipt=vision_receipt, audio_receipt=audio_receipt)
        stage("game_first_scene_submit_complete")
        self._revoke_terminal(first)
        self._evaluate_assertions(first, game_input)
        self._tick_id = 0
        self._stop.clear()
        self._paused.clear()
        self._wake.clear()
        thread = threading.Thread(
            target=self._run,
            args=(info.manifest.tick_hz,),
            name=f"voice-view-game-{info.manifest.game_id}",
            daemon=True,
        )
        self._thread = thread
        thread.start()

    def update(self, control: ControlState) -> None:
        with self._lock:
            if self._test_case is None and self._live_input is None:
                self._latest_control = control
                self._gesture = GestureState(fist_sequence=control.gesture_seq)

    def inject_test_input(
        self,
        *,
        x: int | None = None,
        y: int | None = None,
        fist: bool = False,
        frequency_hz: float | None = None,
        duration_ms: int | None = None,
        input_id: str | None = None,
        gesture: str | None = None,
    ) -> str:
        if self._live_input is not None:
            raise RuntimeError("live vision runtime does not accept test injection")
        injection_id = input_id or uuid.uuid4().hex
        if not injection_id:
            raise ValueError("input_id must not be empty")
        classification = None if gesture is None else HandGesture(gesture)
        hand_event = None
        if x is not None or y is not None or fist or gesture is not None:
            hand_event = InputEvent(
                0, InputKind.GESTURE if gesture is not None else InputKind.FIST if fist else InputKind.HAND,
                event_id=injection_id, x=x, y=y, gesture=classification,
            )
        if fist and gesture is not None and classification is not HandGesture.FIST:
            raise ValueError("fist event requires the fist gesture")
        if frequency_hz is not None or duration_ms is not None:
            InputEvent(0, InputKind.TONE, event_id=injection_id, frequency_hz=frequency_hz, duration_ms=duration_ms)
        with self._lock:
            control = self._latest_control
            if hand_event is not None:
                if x is None or y is None or not 0 <= x < 320 or not 0 <= y < 180:
                    raise ValueError("hand injection requires x/y inside 320x180")
                if not self._gesture.enabled:
                    self._gesture.fist_sequence = control.gesture_seq
                if gesture is not None:
                    self._gesture.update(classification)
                    fist = self._gesture.fist_event
                else:
                    self._gesture.apply_legacy(fist=fist)
                self._latest_control = replace(
                    control,
                    gesture_source=ControlSource.BUTTON,
                    gesture_seq=self._gesture.fist_sequence,
                    hand_valid=True,
                    hand_x=x * 2.0 / 319.0 - 1.0,
                    hand_y=y * 2.0 / 179.0 - 1.0,
                    fist_score=1.0 if fist else 0.0,
                    fist_event=fist,
                )
            if frequency_hz is not None or duration_ms is not None:
                if frequency_hz is None or not 20.0 <= frequency_hz <= 20_000.0:
                    raise ValueError("tone frequency must be within [20, 20000] Hz")
                if duration_ms is None or duration_ms <= 0:
                    raise ValueError("tone duration must be positive")
                tick_hz = self._tick_hz
                ticks = max(1, math.ceil(duration_ms * tick_hz / 1000.0))
                self._tone_frequency = frequency_hz
                self._tone_ticks = ticks
                self._tone_total = ticks
                self._tone_sequence += 1
            self._pending_input_ids.append(injection_id)
            self._accepted_input_id = injection_id
            if self._playback is not None:
                if hand_event is not None:
                    self._playback.apply(hand_event)
                if frequency_hz is not None and duration_ms is not None:
                    self._playback.apply(InputEvent(
                        0, InputKind.TONE, event_id=injection_id,
                        frequency_hz=frequency_hz, duration_ms=duration_ms,
                    ))
                if self._report is not None:
                    self._report.interactive = True
        self._wake.set()
        return injection_id

    def cancel_test_input(self) -> None:
        with self._lock:
            self._tone_ticks = 0
            self._tone_total = 0
            self._gesture.cancel()
            self._latest_control = replace(
                self._latest_control,
                fist_score=0.0,
                fist_event=False,
            )
            if self._playback is not None:
                self._playback.apply(InputEvent(0, InputKind.CANCEL))
                if self._report is not None:
                    self._report.interactive = True

    def pause(self) -> None:
        if not self.running:
            raise RuntimeError("packaged game is not running")
        with self._submission_lock:
            self._paused.set()
            if self._live_input is not None:
                self._live_input.suspend()
            self._wake.set()
            self._drain()

    def resume(self) -> None:
        self._resume_input(rearm_audio=False)

    def enable_preview_upload_overlap(self) -> None:
        with self._submission_lock:
            if not self.running or not self._paused.is_set():
                raise RuntimeError("preview/upload overlap requires a running paused game")
            if not all(callable(getattr(self._preview, name, None)) for name in ("begin_step", "finish_step")):
                raise RuntimeError("preview/upload overlap requires split preview calls")
            self._preview_upload_overlap = True

    def resume_audio(self) -> None:
        self._resume_input(rearm_audio=True)

    def _resume_input(self, *, rearm_audio: bool) -> None:
        if not self.running:
            raise RuntimeError("packaged game is not running")
        with self._submission_lock:
            if self._live_input is not None:
                self._live_input.resume()
                if rearm_audio:
                    self._live_input.rearm_audio()
            self._paused.clear()
            self._wake.set()

    def step_once(self) -> None:
        if not self.running or not self._paused.is_set():
            raise RuntimeError("packaged game must be paused before stepping")
        if self._test_complete:
            raise RuntimeError("completed game test must be restarted before stepping")
        self._drain()
        with self._lock:
            self._step_requests += 1
        self._wake.set()

    def stop(self) -> None:
        self._stop.set()
        self._wake.set()
        thread = self._thread
        if thread is not None:
            thread.join(3.0)
            if thread.is_alive():
                raise RuntimeError("packaged game thread did not stop before timeout")
        self._thread = None
        if self._live_input is not None and not self._input_released:
            self._live_input.resume()
            self._live_input.release("Game runtime stopped")
            self._input_released = True
        try:
            self._drain()
        finally:
            if self._playback is not None:
                self._playback.close()
            self._preview.stop()

    def _run(self, tick_hz: int) -> None:
        period = 1.0 / tick_hz
        deadline = time.perf_counter() + period
        previous_sample_ns = None
        previous_timing = None
        first_fault_timing = None
        try:
            while not self._stop.is_set():
                stepping = False
                if self._paused.is_set():
                    self._drain()
                    with self._lock:
                        pending_step = self._step_requests > 0 and not self._test_complete
                    if not pending_step:
                        self._wake.wait()
                    self._wake.clear()
                    if self._stop.is_set():
                        break
                    with self._lock:
                        if self._step_requests <= 0 or self._test_complete:
                            continue
                        self._step_requests -= 1
                        stepping = True
                else:
                    self._wake.wait(max(0.0, deadline - time.perf_counter()))
                    self._wake.clear()
                    if self._stop.is_set():
                        break
                    if self._paused.is_set():
                        continue
                with self._submission_lock:
                    if self._stop.is_set() or (self._paused.is_set() and not stepping):
                        continue
                    self._tick_id += 1
                    with self._lock:
                        self._apply_test_events_locked(self._tick_id)
                        test_input = None if self._playback is None else self._playback.input_at(self._tick_id)
                        control = self._latest_control
                        tone = self._next_tone_locked()
                        gesture_fields = self._gesture.consume() if self._gesture.enabled else {}
                        consumed = tuple(self._pending_input_ids)
                        self._pending_input_ids.clear()
                        if consumed:
                            self._consumed_input_id = consumed[-1]
                        if control.fist_event:
                            self._latest_control = replace(
                                control, fist_score=0.0, fist_event=False
                            )
                    game_input = test_input if test_input is not None else replace(
                        GameInput.from_control_state(control, tone=tone),
                        tick_id=self._tick_id,
                        timestamp_ns=time.monotonic_ns(),
                        **gesture_fields,
                    )
                    vision_receipt = None
                    audio_receipt = None
                    sampling_started_ns = time.monotonic_ns()
                    if self._live_input is not None:
                        game_input, vision_receipt = self._sample_live_input(self._tick_id)
                        audio_receipt = self._sample_audio_receipt(self._tick_id)
                    elif self._playback is not None:
                        audio_receipt = deepcopy(self._playback.audio_receipt)
                    sampling_finished_ns = time.monotonic_ns()
                    if self._live_input is not None and audio_receipt is not None:
                        timing = {
                            "sample_interval_ns": None if previous_sample_ns is None else
                                game_input.timestamp_ns - previous_sample_ns,
                            "sampling_wall_ns": sampling_finished_ns - sampling_started_ns,
                            "previous_tick": previous_timing,
                        }
                        previous_sample_ns = game_input.timestamp_ns
                        if first_fault_timing is None and audio_receipt.get("source_status") == "FAULT":
                            first_fault_timing = timing
                        audio_receipt["runtime_timing"] = first_fault_timing or timing
                    game_input, audio_receipt = self._validate_actions(game_input, audio_receipt)
                    preview_started_ns = time.monotonic_ns()
                    if self._preview_upload_overlap:
                        self._preview.begin_step(game_input)
                        upload_started_ns = time.monotonic_ns()
                        self._flush_deferred_scene()
                        upload_finished_ns = time.monotonic_ns()
                        frame = self._preview.finish_step()
                        preview_finished_ns = time.monotonic_ns()
                        self._deferred_scene = self._scene_transform(frame), vision_receipt, audio_receipt
                        submission_finished_ns = preview_finished_ns
                    else:
                        frame = self._preview.step(game_input)
                        preview_finished_ns = time.monotonic_ns()
                        self._submit(self._scene_transform(frame), vision_receipt=vision_receipt,
                                     audio_receipt=audio_receipt)
                        submission_finished_ns = time.monotonic_ns()
                    previous_timing = {
                        "tick": self._tick_id,
                        "sampling_wall_ns": sampling_finished_ns - sampling_started_ns,
                        "validation_wall_ns": preview_started_ns - sampling_finished_ns,
                        "preview_wall_ns": preview_finished_ns - preview_started_ns,
                        "submission_wall_ns": submission_finished_ns - preview_finished_ns,
                        "preview_worker": getattr(self._preview, "last_step_timing", None),
                    }
                    if self._preview_upload_overlap:
                        previous_timing["overlapped_submission_wall_ns"] = upload_finished_ns - upload_started_ns
                    self._revoke_terminal(frame)
                    if self._test_case is not None and self._tick_id >= self._test_case.max_ticks:
                        self._drain()
                    self._evaluate_assertions(frame, game_input)
                    if self._test_case is not None and self._tick_id >= self._test_case.max_ticks:
                        self._test_complete = True
                        self._paused.set()
                deadline = time.perf_counter() + period if self._paused.is_set() else deadline + period
            self._drain()
        except BaseException as error:
            self._last_error = f"{type(error).__name__}: {error}"
            self._revoke_actions(self._last_error)
            try:
                self._drain()
            except BaseException as drain_error:
                self._last_error += f"; drain failed: {type(drain_error).__name__}: {drain_error}"
            with self._lock:
                if self._report is not None:
                    self._report.errors.append(self._last_error)
            self._stop.set()

    def _sample_live_input(self, tick_id: int) -> tuple[GameInput, dict[str, object] | None]:
        assert self._live_input is not None
        sample_current = getattr(self._live_input, "sample_current_for_game", None)
        if callable(sample_current):
            return sample_current(self._game_id, tick_id=tick_id)
        sample_for_game = getattr(self._live_input, "sample_for_game", None)
        sample_with_receipt = getattr(self._live_input, "sample_with_receipt", None)
        timestamp_ns = time.monotonic_ns()
        if callable(sample_for_game):
            return sample_for_game(self._game_id, tick_id=tick_id, timestamp_ns=timestamp_ns)
        if callable(sample_with_receipt):
            return sample_with_receipt(tick_id=tick_id, timestamp_ns=timestamp_ns)
        return self._live_input.sample(tick_id=tick_id, timestamp_ns=timestamp_ns), None

    def _sample_audio_receipt(self, tick_id: int) -> dict | None:
        if getattr(self._manifest, "volume_inputs", None) is not None:
            capability = getattr(self._live_input, "volume_receipt_for_tick", None)
            if not callable(capability):
                raise ValueError("volume contract requires a local volume receipt")
            receipt = deepcopy(capability(tick_id))
            if (type(receipt) is not dict or receipt.get("schema") != "volume-input-receipt-v1"
                    or receipt.get("game_run") != self._game_run
                    or type(receipt.get("sample_tick")) is not int or receipt["sample_tick"] != tick_id
                    or type(receipt.get("sample_timestamp_ns")) is not int
                    or type(receipt.get("hardware_acked")) is not bool
                    or type(receipt.get("logic_consumed")) is not bool
                    or receipt["hardware_acked"] != (receipt.get("signal") is not None)
                    or receipt["logic_consumed"] != (receipt.get("signal") is not None)):
                raise ValueError("invalid volume receipt or game run binding")
            return receipt
        capability = getattr(self._live_input, "audio_receipt_for_tick", None)
        if not callable(capability):
            return None
        try:
            receipt = deepcopy(capability(tick_id))
            if receipt is None:
                return None
            schemas = {"voice-input-receipt-v1": False}
            if getattr(self._manifest, "inputs", None) is not None:
                schemas["voice-action-receipt-v1"] = True
            if (type(receipt) is not dict or receipt.get("schema") not in schemas
                    or receipt.get("action_mapped") is not schemas[receipt["schema"]]
                    or type(receipt.get("sample_tick")) is not int or receipt["sample_tick"] != tick_id):
                raise ValueError("invalid informational audio receipt or tick")
            return receipt
        except Exception as error:
            return {"schema": "voice-input-receipt-v1", "sample_tick": tick_id,
                    "source_status": "FAULT", "observation_sampled": False,
                    "action_mapped": False, "reason": f"{type(error).__name__}: {error}"[:512]}

    def _validate_volume_input(self, game_input, receipt):
        contract = getattr(self._manifest, "volume_inputs", None)
        if contract is None:
            if game_input.volume is not None:
                raise ValueError("volume signal requires an explicit package contract")
            return receipt
        signal = None if game_input.volume is None else asdict(game_input.volume)
        if game_input.tone is not None or game_input.actions is not None:
            raise ValueError("volume contract requires independent raw inputs")
        if self._live_input is None and self._test_case is not None:
            return {"schema": "volume-input-receipt-v1", "input_source": "test-playback",
                    "game_run": self._game_run, "game_id": self._game_id, "sample_tick": game_input.tick_id,
                    "sample_timestamp_ns": game_input.timestamp_ns, "signal": signal,
                    "hardware_acked": False, "logic_consumed": signal is not None,
                    "source_receipt": None}
        if (type(receipt) is not dict or receipt.get("schema") != "volume-input-receipt-v1"
                or receipt.get("game_run") != self._game_run
                or receipt.get("sample_tick") != game_input.tick_id
                or receipt.get("sample_timestamp_ns") != game_input.timestamp_ns
                or receipt.get("signal") != signal):
            raise ValueError("volume receipt does not match the actual game input")
        if signal is not None:
            source = receipt.get("source_receipt")
            if (type(source) is not dict or source.get("signal") != signal
                    or source.get("sample_tick") != game_input.tick_id
                    or source.get("hardware_acked") is not True or source.get("disposition") != "consumed"
                    or type(source.get("expires")) not in (int, float)
                    or not math.isfinite(source["expires"]) or time.monotonic() >= source["expires"]):
                raise ValueError("volume source reservation is invalid or expired")
        return receipt

    def _validate_actions(self, game_input, receipt):
        receipt = self._validate_volume_input(game_input, receipt)
        contract = getattr(self._manifest, "inputs", None)
        if contract is None:
            return replace(game_input, actions=None) if game_input.actions is not None else game_input, receipt
        frame = game_input.actions
        valid = (type(frame) is GameActionFrame and type(receipt) is dict
                 and frame.game_id == self._game_id and frame.game_run == self._game_run
                 and frame.policy_id == contract.policy_id and frame.schema == contract.actions_schema
                 and receipt.get("schema") == "voice-action-receipt-v1" and receipt.get("action_mapped") is True
                 and type(receipt.get("sample_tick")) is int and receipt["sample_tick"] == game_input.tick_id
                 and type(receipt.get("sample_timestamp_ns")) is int and receipt["sample_timestamp_ns"] == game_input.timestamp_ns
                 and receipt.get("game_id") == frame.game_id and receipt.get("game_run") == frame.game_run
                 and receipt.get("action_epoch") == frame.action_epoch and receipt.get("policy_id") == frame.policy_id
                 and receipt.get("policy_status") == frame.status and receipt.get("action_frame") == asdict(frame)
                 and (frame.status != "RUNNING" or (receipt.get("source_status") == "RUNNING" and game_input.tone is None)))
        expected_epoch = getattr(self._live_input, "action_epoch", None)
        if expected_epoch is not None and frame is not None and frame.action_epoch != expected_epoch:
            valid = False
        if valid:
            return game_input, receipt
        reason = "runtime action receipt or contract mismatch; grants revoked"
        self._revoke_actions(reason)
        neutral = GameActionFrame(self._game_id, self._game_run, self._revoked_epoch, contract.policy_id,
                                  game_input.tick_id, game_input.timestamp_ns, "FAULT")
        fault = {"schema": "voice-action-receipt-v1", "action_mapped": True,
                 "sample_tick": game_input.tick_id, "sample_timestamp_ns": game_input.timestamp_ns,
                 "game_id": self._game_id, "game_run": self._game_run, "action_epoch": neutral.action_epoch,
                 "policy_id": contract.policy_id, "policy_status": "FAULT", "source_status": "FAULT",
                 "source_status_verified": False, "action_frame": asdict(neutral), "reason": reason}
        return replace(game_input, actions=neutral), fault

    def _revoke_actions(self, reason):
        revoke = getattr(self._live_input, "revoke_actions", None)
        if callable(revoke):
            revoke(reason)
        if self._playback is not None:
            self._playback.revoke_actions(reason)

    def _revoke_terminal(self, frame):
        if frame.snapshot.status in ("WON", "LOST"):
            self._revoke_actions("game terminal")

    def _submit(self, frame: GameFrame, *, require_resources: bool = False,
                vision_receipt: dict[str, object] | None = None,
                audio_receipt: dict[str, object] | None = None) -> None:
        vision_receipt, audio_receipt = deepcopy(vision_receipt), deepcopy(audio_receipt)
        if audio_receipt is not None and (
            type(audio_receipt.get("sample_tick")) is not int
            or audio_receipt["sample_tick"] != frame.snapshot.tick_id
            or not (
                audio_receipt.get("schema") == "voice-input-receipt-v1" and audio_receipt.get("action_mapped") is False
                or getattr(self._manifest, "inputs", None) is not None
                and audio_receipt.get("schema") == "voice-action-receipt-v1" and audio_receipt.get("action_mapped") is True
                and audio_receipt.get("game_id") == self._game_id and audio_receipt.get("game_run") == self._game_run
                or getattr(self._manifest, "volume_inputs", None) is not None
                and audio_receipt.get("schema") == "volume-input-receipt-v1"
                and audio_receipt.get("game_run") == self._game_run
            )
        ):
            raise ValueError("audio receipt must belong to its Scene tick and remain informational")
        if audio_receipt is not None and audio_receipt.get("schema") == "voice-action-receipt-v1":
            values = dict(frame.snapshot.values or {})
            audio_receipt.update(game_effects=deepcopy(values.get("effects")),
                                 effect_totals=deepcopy(values.get("effects_total")),
                                 fire_consumed=values.get("fire_consumed"))
        packets = (frame.asset_packet, frame.palette_packet, frame.tilemap_packet)
        if require_resources and any(packet is None for packet in packets):
            raise RuntimeError("game did not provide its initial GPU resources")
        with self._submission_lock:
            if any(packet is not None for packet in packets):
                self._drain()
            if frame.asset_packet is not None:
                self._sink.upload_asset(frame.asset_packet)
            if frame.palette_packet is not None:
                self._sink.upload_palette(frame.palette_packet)
            if frame.tilemap_packet is not None:
                self._sink.upload_tilemap(frame.tilemap_packet)
            if self._pipeline_enabled:
                if len(self._pending_scenes) >= 2:
                    self._retire_oldest()
                ticket = self._enqueue_scene(frame.scene_packet)
                self._pending_scenes.append((ticket, frame, vision_receipt, audio_receipt))
                if require_resources or self._paused.is_set():
                    self._drain()
            else:
                self._sink.submit_scene(frame.scene_packet)
                self._complete_scene(frame, vision_receipt, audio_receipt)

    def _complete_scene(self, frame: GameFrame, vision_receipt: dict[str, object] | None,
                        audio_receipt: dict[str, object] | None = None) -> None:
        self._last_frame = frame
        self._presented_frames += 1
        confirmation = {} if vision_receipt is None and audio_receipt is None else {"scene_tick": frame.snapshot.tick_id,
            "scene_sha256": frame.scene_sha256, "sink_completion": "confirmed",
            "game_status": frame.snapshot.status, "game_score": frame.snapshot.score,
            "game_values": deepcopy(dict(frame.snapshot.values or {})),
            "runtime_presented_frames": self._presented_frames,
        }
        visual = None if vision_receipt is None else {**vision_receipt, **confirmation}
        audio = None if audio_receipt is None else {**audio_receipt, **confirmation}
        if audio is not None and audio.get("schema") == "volume-input-receipt-v1":
            audio.update(logic_executed=True, game_effects=deepcopy(dict(frame.snapshot.values or {})))
        self._completed_scene = (frame, self._presented_frames, visual, audio)

    def _retire_oldest(self) -> None:
        ticket, frame, vision_receipt, audio_receipt = self._pending_scenes[0]
        self._wait_scene(ticket)
        self._pending_scenes.pop(0)
        self._complete_scene(frame, vision_receipt, audio_receipt)

    def _flush_deferred_scene(self) -> None:
        if self._failed_deferred_scene is not None:
            raise RuntimeError("deferred Scene submission failed; no replay allowed")
        pending = self._deferred_scene
        if pending is None:
            return
        self._deferred_scene = None
        frame, vision_receipt, audio_receipt = pending
        try:
            self._submit(frame, vision_receipt=vision_receipt, audio_receipt=audio_receipt)
        except BaseException:
            self._failed_deferred_scene = pending
            raise

    def _drain(self) -> None:
        with self._submission_lock:
            self._flush_deferred_scene()
            while self._pending_scenes:
                self._retire_oldest()
            if callable(self._sink_drain):
                self._sink_drain()

    def _next_tone_locked(self) -> ToneSignal | None:
        if self._tone_ticks > 0:
            tone = ToneSignal(
                sequence=self._tone_sequence,
                frequency_hz=self._tone_frequency,
                active=True,
                started=self._tone_ticks == self._tone_total,
            )
            self._tone_ticks -= 1
            return tone
        if self._tone_total > 0:
            self._tone_total = 0
            return ToneSignal(
                sequence=self._tone_sequence,
                frequency_hz=self._tone_frequency,
                active=False,
                ended=True,
            )
        return None

    def _create_preview(self, *, seed: int) -> GamePreviewProcess:
        return GamePreviewProcess(
            self.package_path,
            seed=seed,
            generation=self._generation,
            submit_base=(self._generation - 1) & 0xFFFFFFFF,
            render_rgb=False,
            require_extension=False,
            game_run=self._game_run,
        )

    def _apply_test_events_locked(self, tick_id: int) -> None:
        test_case = self._test_case
        if test_case is None:
            return
        for event in test_case.events_at(tick_id):
            self._pending_input_ids.append(event.event_id)
            self._accepted_input_id = event.event_id

    def _evaluate_assertions(self, frame: GameFrame, game_input: GameInput) -> None:
        if self._report is None:
            return
        with self._lock:
            for result in self._report.record(frame, game_input):
                if result.passed:
                    self._assertions_passed += 1
                else:
                    self._assertions_failed += 1


def _idle_control() -> ControlState:
    return ControlState(
        tick_id=0,
        timestamp_ns=0,
        gesture_source=ControlSource.REPLAY,
        gesture_seq=0,
        hand_valid=True,
        hand_x=0.0,
        hand_y=0.0,
        direction=Direction.IDLE,
        fist_score=0.0,
        fist_event=False,
        voice_source=ControlSource.REPLAY,
        voice_seq=0,
        audio_valid=False,
        low_voice_active=False,
        high_voice_event=False,
        low_confidence=0.0,
        high_confidence=0.0,
    )
