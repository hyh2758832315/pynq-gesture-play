from __future__ import annotations

import math
from pathlib import Path
import threading
import time
import uuid

from PySide6.QtCore import QObject, Signal

from ..game_runner import GameFrame, GamePreviewProcess
from ..game_sdk import GameInput, GestureState, HandGesture, ToneSignal
from ..game_testing import (
    AssertionResult,
    AuditEvent,
    GameTestCase,
    InputEvent,
    InputKind,
)
from ..game_validation import GameTestPlayback, GameTestReport


class GamePreviewWorker(QObject):
    ready = Signal(object)
    frame_ready = Signal(object)
    input_consumed = Signal(object, str)
    failed = Signal(str)
    audit_event = Signal(object)
    assertion_result = Signal(object)
    state_changed = Signal(str)
    test_report_ready = Signal(object)
    finished = Signal()

    def __init__(self, package_path: Path, *, tick_hz: int = 60, seed: int = 0) -> None:
        super().__init__()
        self.package_path = Path(package_path)
        self.tick_hz = tick_hz
        self.seed = seed
        self._stop = threading.Event()
        self._paused = threading.Event()
        self._reset_requested = threading.Event()
        self._lock = threading.Lock()
        self._step_requests = 0
        self._x = 160
        self._y = 90
        self._gesture = GestureState(enabled=True)
        self._tone_frequency = 0.0
        self._tone_ticks = 0
        self._tone_total = 0
        self._tone_sequence = 0
        self._pending_input_ids: list[str] = []
        self._last_consumed_input_ids: tuple[str, ...] = ()
        self._test_case: GameTestCase | None = None
        self._playback: GameTestPlayback | None = None
        self._report: GameTestReport | None = None

    def run(self) -> None:
        seed = self.seed if self._test_case is None else self._test_case.seed
        preview = GamePreviewProcess(self.package_path, seed=seed)
        try:
            info = preview.start()
            self.tick_hz = info.manifest.tick_hz
            if self._test_case is not None:
                with self._lock:
                    self._playback = GameTestPlayback(self._test_case, tick_hz=self.tick_hz)
                    self._report = GameTestReport(info, self._test_case, "pc")
            self.ready.emit(info)
            self.state_changed.emit("running")
            interval = 1.0 / self.tick_hz
            deadline = time.monotonic()
            tick_id = -1
            while not self._stop.is_set():
                if self._reset_requested.is_set():
                    preview.stop()
                    if self._report is not None:
                        self._report.errors.append("test interrupted by reset")
                        self.test_report_ready.emit(self._report)
                    preview = GamePreviewProcess(self.package_path, seed=seed)
                    info = preview.start()
                    with self._lock:
                        if self._test_case is not None:
                            self._playback = GameTestPlayback(self._test_case, tick_hz=self.tick_hz)
                            self._report = GameTestReport(info, self._test_case, "pc")
                        self._pending_input_ids.clear()
                    self.ready.emit(info)
                    self._reset_requested.clear()
                    tick_id = -1
                    deadline = time.monotonic()
                    self.state_changed.emit("paused" if self._paused.is_set() else "running")
                single_step = self._take_step_request()
                if self._paused.is_set() and not single_step:
                    self._stop.wait(0.01)
                    deadline = time.monotonic()
                    continue
                tick_id += 1
                self._apply_test_events(tick_id)
                game_input = self._next_input(tick_id)
                frame: GameFrame = preview.step(game_input)
                self.input_consumed.emit(game_input, "PC 手动" if self._report is None or self._report.interactive else "PC 时间线")
                self.frame_ready.emit(frame)
                self._emit_consumed_inputs(tick_id)
                self._evaluate_frame_assertions(frame, game_input)
                if (self._test_case is None and info.manifest.game_id == "game1"
                        and frame.snapshot.status in ("LOST", "WON")):
                    self.state_changed.emit(frame.snapshot.status.lower())
                    return
                if single_step:
                    self.state_changed.emit("paused")
                test_case = self._test_case
                if test_case is not None and tick_id >= test_case.max_ticks:
                    self.state_changed.emit("completed")
                    return
                deadline += interval
                if not self._paused.is_set():
                    self._stop.wait(max(0.0, deadline - time.monotonic()))
        except BaseException as error:
            if self._report is not None:
                self._report.errors.append(f"{type(error).__name__}: {error}")
            self.failed.emit(f"{type(error).__name__}: {error}")
        finally:
            preview.stop()
            if self._report is not None:
                if not self._report.completed and not self._report.errors:
                    self._report.errors.append("test interrupted before completion")
                self.test_report_ready.emit(self._report)
            self.finished.emit()

    @property
    def paused(self) -> bool:
        return self._paused.is_set()

    @property
    def last_consumed_input_ids(self) -> tuple[str, ...]:
        with self._lock:
            return self._last_consumed_input_ids

    def inject_hand(
        self, *, x: int, y: int, fist: bool, input_id: str | None = None
    ) -> str:
        event_id = input_id or uuid.uuid4().hex
        event = InputEvent(0, InputKind.FIST if fist else InputKind.HAND, event_id=event_id, x=x, y=y)
        with self._lock:
            self._x = x
            self._y = y
            self._pending_input_ids.append(event_id)
            self._gesture.apply_legacy(fist=fist)
            if self._playback is not None:
                self._playback.apply(event)
                if self._report is not None:
                    self._report.interactive = True
        self._emit_input_audit(
            event_id,
            "fist" if fist else "hand",
            {"x": x, "y": y, "fist": fist},
        )
        return event_id

    def inject_gesture(
        self, *, x: int, y: int, gesture: HandGesture | None, input_id: str | None = None,
    ) -> str:
        event_id = input_id or uuid.uuid4().hex
        event = InputEvent(0, InputKind.GESTURE, event_id=event_id, x=x, y=y, gesture=gesture)
        with self._lock:
            self._x, self._y = x, y
            self._gesture.update(gesture)
            self._pending_input_ids.append(event_id)
            if self._playback is not None:
                self._playback.apply(event)
                if self._report is not None:
                    self._report.interactive = True
        self._emit_input_audit(event_id, "gesture", {
            "x": x, "y": y, "gesture": None if gesture is None else gesture.value,
        })
        return event_id

    def inject_tone(
        self,
        *,
        frequency_hz: float,
        duration_ms: int,
        input_id: str | None = None,
    ) -> str:
        ticks = max(1, math.ceil(duration_ms * self.tick_hz / 1000.0))
        event_id = input_id or uuid.uuid4().hex
        with self._lock:
            self._tone_frequency = frequency_hz
            self._tone_ticks = ticks
            self._tone_total = ticks
            self._tone_sequence += 1
            self._pending_input_ids.append(event_id)
            if self._playback is not None:
                self._playback.apply(InputEvent(
                    0, InputKind.TONE, event_id=event_id,
                    frequency_hz=frequency_hz, duration_ms=duration_ms,
                ))
                if self._report is not None:
                    self._report.interactive = True
        self._emit_input_audit(
            event_id,
            "tone",
            {
                "frequency_hz": frequency_hz,
                "duration_ms": duration_ms,
                "scheduled_ticks": ticks,
            },
        )
        return event_id

    def cancel_inputs(self) -> str:
        event_id = uuid.uuid4().hex
        with self._lock:
            self._gesture.cancel()
            self._tone_ticks = 0
            self._tone_total = 0
            self._pending_input_ids.append(event_id)
            if self._playback is not None:
                self._playback.apply(InputEvent(0, InputKind.CANCEL, event_id=event_id))
                if self._report is not None:
                    self._report.interactive = True
        self._emit_input_audit(event_id, "cancel", {})
        return event_id

    def pause(self) -> None:
        self._paused.set()
        self.state_changed.emit("paused")

    def resume(self) -> None:
        self._paused.clear()
        self.state_changed.emit("running")

    def step_once(self) -> None:
        with self._lock:
            self._step_requests += 1
        self._paused.set()
        self.state_changed.emit("stepping")

    def reset(self) -> None:
        with self._lock:
            self._gesture = GestureState(enabled=True)
            self._x, self._y = 160, 90
            self._tone_ticks = self._tone_total = 0
            self._pending_input_ids.clear()
        self._reset_requested.set()
        self.state_changed.emit("resetting")

    def load_test_case(self, test_case: GameTestCase | None) -> None:
        with self._lock:
            self._test_case = test_case
            self._playback = None if test_case is None else GameTestPlayback(
                test_case, tick_hz=self.tick_hz,
            )

    def stop(self) -> None:
        with self._lock:
            self._gesture.cancel()
            self._tone_ticks = self._tone_total = 0
        self._stop.set()

    def _next_input(self, tick_id: int) -> GameInput:
        with self._lock:
            if self._playback is not None:
                return self._playback.input_at(tick_id)
            tone = None
            if self._tone_ticks > 0:
                tone = ToneSignal(
                    sequence=self._tone_sequence,
                    frequency_hz=self._tone_frequency,
                    active=True,
                    started=self._tone_ticks == self._tone_total,
                )
                self._tone_ticks -= 1
            elif self._tone_total > 0:
                tone = ToneSignal(
                    sequence=self._tone_sequence,
                    frequency_hz=self._tone_frequency,
                    active=False,
                    ended=True,
                )
                self._tone_total = 0
            return GameInput.from_logical_position(
                tick_id=tick_id,
                timestamp_ns=time.monotonic_ns(),
                x=self._x,
                y=self._y,
                tone=tone,
                **self._gesture.consume(),
            )

    def _take_step_request(self) -> bool:
        with self._lock:
            if self._step_requests <= 0:
                return False
            self._step_requests -= 1
            return True

    def _apply_test_events(self, tick_id: int) -> None:
        with self._lock:
            test_case = self._test_case
            events = () if test_case is None else test_case.events_at(tick_id)
            for event in events:
                self._pending_input_ids.append(event.event_id)
        for event in events:
            self.audit_event.emit(
                AuditEvent(
                    category="input",
                    action=event.kind.value,
                    target="pc",
                    result="scheduled",
                    details={"input_id": event.event_id},
                    tick=tick_id,
                )
            )

    def _evaluate_frame_assertions(self, frame: GameFrame, game_input: GameInput) -> None:
        if self._report is None:
            return
        results: tuple[AssertionResult, ...] = self._report.record(frame, game_input)
        for result in results:
            self.assertion_result.emit(result)
            self.audit_event.emit(
                AuditEvent(
                    category="assertion",
                    action=result.rule.field,
                    target="pc",
                    result="passed" if result.passed else "failed",
                    details={
                        "operator": result.rule.operator.value,
                        "expected": result.rule.expected,
                        "actual": result.actual,
                    },
                    tick=frame.snapshot.tick_id,
                )
            )

    def _emit_input_audit(
        self, event_id: str, action: str, details: dict[str, object]
    ) -> None:
        self.audit_event.emit(
            AuditEvent(
                category="input",
                action=action,
                target="pc",
                result="submitted",
                details={"input_id": event_id, **details},
            )
        )

    def _emit_consumed_inputs(self, tick_id: int) -> None:
        with self._lock:
            consumed = tuple(self._pending_input_ids)
            self._pending_input_ids.clear()
            self._last_consumed_input_ids = consumed
        for event_id in consumed:
            self.audit_event.emit(
                AuditEvent(
                    category="input",
                    action="consume",
                    target="pc",
                    result="consumed",
                    details={"input_id": event_id},
                    tick=tick_id,
                )
            )
