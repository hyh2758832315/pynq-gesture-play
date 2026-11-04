from __future__ import annotations

import argparse
from dataclasses import asdict, dataclass, field, replace
import hashlib
import json
import math
from pathlib import Path
import struct
from tempfile import TemporaryDirectory
import threading
from typing import Any
import uuid

from .game_package import GamePackageBuilder, GamePackageInfo, validate_game_package, canonical_manifest
from .game_runner import GameFrame, GamePreviewProcess
from .game_sdk import GAME_SDK_MAJOR, GAME_SDK_MINOR, GameInput, GestureState, HandGesture, ToneSignal, canonical_game_input
from .game_testing import AssertionResult, GameTestCase, InputEvent, InputKind
from .gpu_abi import HEADER_WORDS


def _digest(value: Any) -> str:
    payload = json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
    return hashlib.sha256(payload.encode("utf-8")).hexdigest()


def fixture_run_id(case: GameTestCase) -> str:
    return "fixture-" + _digest(json.loads(case.to_json()))[:24]


def canonical_scene_sha256(packet: bytes) -> str:
    header_bytes = HEADER_WORDS * 4
    words = list(struct.unpack(f"<{HEADER_WORDS}I", packet[:header_bytes]))
    for index in (3, 8, 10, 11):
        words[index] = 0
    canonical = struct.pack(f"<{HEADER_WORDS}I", *words) + packet[header_bytes:]
    return hashlib.sha256(canonical).hexdigest()


class GameTestPlayback:
    def __init__(self, case: GameTestCase, *, tick_hz: int, manifest=None) -> None:
        if tick_hz <= 0:
            raise ValueError("tick_hz must be positive")
        self.case = case
        self.tick_hz = tick_hz
        self._x = 160
        self._y = 90
        self._gesture = GestureState(enabled=case.schema_version >= 2)
        self._tone_frequency = 0.0
        self._tone_ticks = 0
        self._tone_total = 0
        self._tone_sequence = 0
        self._volume = None
        self.game_run = fixture_run_id(case)
        self._voice = None
        if manifest is not None and manifest.inputs is not None:
            if case.schema_version != 3:
                raise ValueError("action candidate playback requires schema 3")
            self._voice = _VoiceFixture(manifest, self.game_run)
        elif any(event.kind is InputKind.VOICE for event in case.events):
            raise ValueError("virtual voice requires a declared game action contract")

    @property
    def audio_receipt(self):
        return None if self._voice is None else self._voice.receipt

    def revoke_actions(self, reason):
        if self._voice is not None:
            self._voice.revoke(reason)

    def close(self):
        if self._voice is not None:
            self._voice.close()

    def apply(self, event: InputEvent) -> None:
        if event.kind in (InputKind.HAND, InputKind.FIST, InputKind.GESTURE):
            assert event.x is not None and event.y is not None
            self._x, self._y = event.x, event.y
            if event.kind is InputKind.GESTURE:
                self._gesture.update(event.gesture)
            elif self.case.schema_version >= 2:
                self._gesture.update(HandGesture.FIST if event.kind is InputKind.FIST else HandGesture.PAPER)
            else:
                self._gesture.apply_legacy(fist=event.kind is InputKind.FIST)
        elif event.kind is InputKind.TONE:
            assert event.frequency_hz is not None and event.duration_ms is not None
            self._tone_frequency = event.frequency_hz
            self._tone_total = max(1, math.ceil(event.duration_ms * self.tick_hz / 1000))
            self._tone_ticks = self._tone_total
            self._tone_sequence += 1
        elif event.kind is InputKind.VOLUME:
            self._volume = event.volume
        elif event.kind is InputKind.CANCEL:
            self._gesture.cancel()
            self._tone_ticks = self._tone_total = 0
            self._volume = None

    def input_at(self, tick: int) -> GameInput:
        for event in self.case.events_at(tick):
            self.apply(event)
        tone = None
        if self._tone_ticks:
            tone = ToneSignal(
                self._tone_sequence, self._tone_frequency, True,
                started=self._tone_ticks == self._tone_total,
            )
            self._tone_ticks -= 1
        elif self._tone_total:
            tone = ToneSignal(self._tone_sequence, self._tone_frequency, False, ended=True)
            self._tone_total = 0
        game_input = GameInput.from_logical_position(
            tick_id=tick, timestamp_ns=(self.case.tick_timestamps_ns[tick] if self.case.tick_timestamps_ns
                                       else tick * 1_000_000_000 // self.tick_hz),
            x=self._x, y=self._y, tone=tone, volume=self._volume, **self._gesture.consume(),
        )
        self._volume = None
        if self._voice is not None:
            game_input = self._voice.sample(game_input, self.case.events_at(tick))
        return game_input


class _VoiceFixture:
    def __init__(self, manifest, game_run):
        from .voice_observations import VoiceObservationBus
        self.manifest, self.game_run = manifest, game_run
        self._bus = VoiceObservationBus()
        self._epoch = -1
        self._terminal = False
        self.receipt = None
        self._begin_epoch()
        self._status = "WAITING"

    def _begin_epoch(self):
        from .game_voice_policy import create_voice_policy
        if hasattr(self, "_subscription"):
            self._subscription.close()
        self._epoch += 1
        self._bus.begin_epoch(self.game_run, f"fixture-audio-{self._epoch}")
        self._subscription = self._bus.subscribe(max_age_ns=2**62)
        self._policy = create_voice_policy(self.manifest.inputs, game_id=self.manifest.game_id,
                                          game_run=self.game_run, action_epoch=f"{self.game_run}-actions-{self._epoch}")
        self._packet = self._sequence = 0
        self._status = "RUNNING"

    def revoke(self, reason):
        self._terminal = True
        self._policy.revoke(reason)

    def close(self):
        self._subscription.close()

    def sample(self, game_input, events):
        from .voice_observations import VoiceEvent, VoiceObservation
        facts = []
        for event in events:
            if event.kind is not InputKind.VOICE or self._terminal:
                continue
            if event.voice_status == "REARM":
                self._begin_epoch()
                facts.clear()
            elif event.voice_status in ("FAULT", "STOPPED"):
                self._status = event.voice_status
                self._bus.invalidate("explicit virtual source health", status=self._status)
                facts.clear()
            elif event.voice_status == "WAITING":
                if self._status != "WAITING":
                    self._bus.invalidate("virtual source returned to waiting without rearm")
                    self._status = "FAULT"
            elif event.voice_status == "RUNNING" or event.voice_status is None:
                if self._status == "WAITING":
                    self._status = "RUNNING"
            facts.extend(event.voice_events)
        if self._status == "RUNNING" and not self._terminal:
            if len(facts) > 64:
                self._bus.invalidate("virtual fact batch capacity exceeded")
                self._status = "FAULT"
            else:
                kinds = {"attack": "HIGH_ONSET", "shield_on": "LOW_SEGMENT_ON", "shield_off": "LOW_SEGMENT_OFF"}
                normalized = tuple(VoiceEvent(self._sequence + index, kinds[name], name, 0)
                                   for index, name in enumerate(facts, 1))
                self._sequence += len(facts)
                self._bus.publish(VoiceObservation(self.game_run, f"fixture-audio-{self._epoch}",
                                                   self._packet, game_input.timestamp_ns, 0., normalized))
                self._packet += 1
        source = self._subscription.poll(game_input.timestamp_ns)
        result = self._policy.sample(game_input, source)
        frame = result.frame
        self.receipt = {"schema": "voice-action-receipt-v1", "action_mapped": True,
                        "sample_tick": game_input.tick_id, "sample_timestamp_ns": game_input.timestamp_ns,
                        "game_id": frame.game_id, "game_run": frame.game_run, "action_epoch": frame.action_epoch,
                        "policy_id": frame.policy_id, "policy_status": frame.status, "action_frame": asdict(frame),
                        "source_status": source.status, "producer_run": source.producer_run,
                        "audio_epoch": source.audio_epoch, "decision_age_ns": source.decision_age_ns,
                        "source_age_ns": None, "source_age_verified": False, "evidence_kind": "fixture-virtual",
                        "decisions": list(result.decisions), "policy_counters": result.counters,
                        "policy_reason": result.reason}
        return replace(game_input, actions=frame)


@dataclass
class GameTestReport:
    package: GamePackageInfo
    case: GameTestCase
    target: str
    run_id: str = field(default_factory=lambda: uuid.uuid4().hex)
    frames: list[dict[str, Any]] = field(default_factory=list)
    assertions: list[dict[str, Any]] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)
    interactive: bool = False
    input_schema_version: int = 1

    @property
    def completed(self) -> bool:
        return len(self.frames) == self.case.max_ticks + 1

    @property
    def passed(self) -> bool:
        return (
            self.completed and not self.errors and not self.interactive
            and len(self.assertions) == len(self.case.assertions)
            and all(result["passed"] for result in self.assertions)
        )

    def record(self, frame: GameFrame, game_input: GameInput) -> tuple[AssertionResult, ...]:
        tick = frame.snapshot.tick_id
        if tick != len(self.frames) or game_input.tick_id != tick or tick > self.case.max_ticks:
            raise ValueError("test frames must cover consecutive ticks starting at zero")
        snapshot = asdict(frame.snapshot)
        input_payload = canonical_game_input(game_input)
        if game_input.volume is not None:
            self.input_schema_version = 4
        elif game_input.has_gesture_input:
            self.input_schema_version = max(self.input_schema_version, 2)
        self.frames.append({
            "tick": tick,
            "input_sha256": _digest(input_payload),
            "state_sha256": _digest(snapshot),
            "scene_sha256": canonical_scene_sha256(frame.scene_packet),
            "raw_scene_sha256": frame.scene_sha256,
            "command_count": frame.command_count,
            "predicted_cycles": frame.predicted_cycles,
            **({"actions_schema": game_input.actions.schema, "policy_id": game_input.actions.policy_id,
                "action_epoch": game_input.actions.action_epoch, "action_status": game_input.actions.status}
               if game_input.actions is not None else {}),
        })
        results = []
        for rule in self.case.assertions_at(tick):
            error_text = ""
            try:
                passed, actual = rule.evaluate(frame.snapshot)
            except (KeyError, TypeError, ValueError) as error:
                passed, actual = False, None
                error_text = f"tick {tick} {rule.field}: {type(error).__name__}: {error}"
                self.errors.append(error_text)
            result = AssertionResult(rule, passed, actual)
            results.append(result)
            self.assertions.append({
                "tick": tick, "field": rule.field, "operator": str(rule.operator),
                "expected": rule.expected, "actual": actual, "passed": passed,
                "error": error_text,
            })
        return tuple(results)

    def to_dict(self) -> dict[str, Any]:
        status = "passed" if self.passed else "failed" if (
            self.completed or self.errors or self.interactive
        ) else "pending"
        return {
            "schema_version": 1, "run_id": self.run_id, "target": self.target,
            "input_schema_version": self.input_schema_version,
            "status": status, "completed": self.completed, "interactive": self.interactive,
            "coverage": "asserted" if self.case.assertions else "smoke",
            "package": {"manifest": canonical_manifest(self.package.manifest),
                        "sha256": self.package.sha256, "length": self.package.length},
            "platform_sdk": {"major": GAME_SDK_MAJOR, "minor": GAME_SDK_MINOR},
            "test_case": json.loads(self.case.to_json()),
            "test_sha256": _digest(json.loads(self.case.to_json())),
            "frames": self.frames, "assertions": self.assertions, "errors": self.errors,
            "peak_command_count": max((frame["command_count"] for frame in self.frames), default=0),
            "peak_predicted_cycles": max((frame["predicted_cycles"] for frame in self.frames), default=0),
            "hardware_acceptance": "pending",
                **({"action_contract": canonical_manifest(self.package.manifest)["inputs"]}
                    if self.package.manifest.inputs is not None else {}),
        }

    def save(self, path: Path) -> Path:
        return save_test_report(self.to_dict(), path)


def save_test_report(payload: dict[str, Any], path: Path) -> Path:
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.tmp")
    try:
        temporary.write_text(
            json.dumps(payload, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
        )
        temporary.replace(path)
    finally:
        temporary.unlink(missing_ok=True)
    return path


def compare_test_reports(pc: dict[str, Any], pynq: dict[str, Any]) -> dict[str, Any]:
    for payload, target in ((pc, "pc"), (pynq, "pynq")):
        frames = payload.get("frames")
        case = payload.get("test_case")
        assertions = payload.get("assertions")
        if (
            payload.get("schema_version") != 1 or payload.get("target") != target
            or payload.get("completed") is not True or payload.get("interactive") is not False
            or not isinstance(frames, list) or not isinstance(case, dict)
            or not isinstance(case.get("max_ticks"), int)
            or len(frames) != case["max_ticks"] + 1
            or any(not isinstance(frame, dict) or frame.get("tick") != index
                     or not {"input_sha256", "state_sha256", "scene_sha256",
                          "command_count", "predicted_cycles"}.issubset(frame)
                   for index, frame in enumerate(frames))
                 or not isinstance(assertions, list)
                 or len(assertions) != len(case.get("assertions", ()))
                 or any(not isinstance(result, dict) or result.get("passed") is not True
                     for result in assertions)
                 or payload.get("errors") != []
                 or not isinstance(payload.get("package"), dict)
                 or not payload["package"].get("sha256")
                 or payload.get("test_sha256") != _digest(case)
        ):
            return {"status": "failed", "reason": f"incomplete {target} evidence"}
    for key in ("test_sha256", "platform_sdk"):
        if pc.get(key) != pynq.get(key):
            return {"status": "failed", "reason": f"different {key}"}
    if pc.get("input_schema_version", 1) != pynq.get("input_schema_version", 1):
        return {"status": "failed", "reason": "different input_schema_version"}
    if pc.get("action_contract") != pynq.get("action_contract"):
        return {"status": "failed", "reason": "different action_contract"}
    if pc.get("package") != pynq.get("package"):
        return {"status": "failed", "reason": "different package"}
    if pc.get("status") != "passed" or pynq.get("status") != "passed":
        return {"status": "failed", "reason": "both test reports must pass"}
    pc_frames, pynq_frames = pc["frames"], pynq["frames"]
    for pc_frame, pynq_frame in zip(pc_frames, pynq_frames):
        fields = {key: {"pc": value, "pynq": pynq_frame.get(key)}
                  for key, value in pc_frame.items()
                  if key != "raw_scene_sha256" and value != pynq_frame.get(key)}
        if fields:
            return {"status": "failed", "first_divergent_tick": pc_frame["tick"],
                    "mismatches": fields}
    if len(pc_frames) != len(pynq_frames):
        return {"status": "failed", "reason": "different frame counts",
                "first_divergent_tick": min(len(pc_frames), len(pynq_frames))}
    return {"status": "passed", "matched_ticks": len(pc_frames),
            "hardware_acceptance": "pending"}


def build_verified_game(project_root: Path, output: Path, *, target_build_id: int | None = None) -> GamePackageInfo:
    output = Path(output)
    if output.suffix.lower() != ".vvg":
        raise ValueError("game package output must use the .vvg extension")
    output.parent.mkdir(parents=True, exist_ok=True)
    with TemporaryDirectory(prefix=".voice-view-build-", dir=output.parent) as directory:
        options = {} if target_build_id is None else {"target_build_id": target_build_id}
        info = GamePackageBuilder().build(project_root, Path(directory) / "candidate.vvg", **options)
        repeated = GamePackageBuilder().build(project_root, Path(directory) / "repeat.vvg", **options)
        if (info.sha256, info.length) != (repeated.sha256, repeated.length):
            raise RuntimeError("game package double-build identity does not match")
        info.path.replace(output)
    return validate_game_package(output)


def run_game_test(
    package_path: Path, case: GameTestCase, *, stop_event: threading.Event | None = None,
) -> GameTestReport:
    package = validate_game_package(package_path)
    report = GameTestReport(package, case, "pc")
    playback = GameTestPlayback(case, tick_hz=package.manifest.tick_hz, manifest=package.manifest)
    preview = GamePreviewProcess(package_path, seed=case.seed, render_rgb=False, game_run=playback.game_run)
    try:
        if stop_event is not None and stop_event.is_set():
            raise RuntimeError("PC validation cancelled")
        preview.start()
        for tick in range(case.max_ticks + 1):
            if stop_event is not None and stop_event.is_set():
                raise RuntimeError("PC validation cancelled")
            game_input = playback.input_at(tick)
            frame = preview.step(game_input)
            report.record(frame, game_input)
            if frame.snapshot.status in ("WON", "LOST"):
                playback.revoke_actions("game terminal")
    except Exception as error:
        report.errors.append(f"{type(error).__name__}: {error}")
    finally:
        preview.stop()
        playback.close()
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate a VVG with a deterministic replay")
    parser.add_argument("package", type=Path)
    parser.add_argument("test_case", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    report = run_game_test(args.package, GameTestCase.load(args.test_case))
    report.save(args.report)
    print(json.dumps({"status": report.to_dict()["status"], "report": str(args.report)}))
    return 0 if report.passed else 1


if __name__ == "__main__":
    raise SystemExit(main())