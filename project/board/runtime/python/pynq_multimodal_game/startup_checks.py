"""Verifiable startup gates. Hardware owners are supplied by the caller."""

from __future__ import annotations

from collections.abc import Callable, Mapping, Sequence
from threading import Event
from time import monotonic
from typing import Any, Protocol


class VisionSupervisor(Protocol):
    def start(self) -> Mapping[str, Any]: ...
    def status(self) -> Mapping[str, Any]: ...
    def stop(self) -> Mapping[str, Any]: ...


def start_vision_until_ready(
    supervisor: VisionSupervisor, *, timeout_seconds: float = 20.0,
    stop_event: Event | None = None,
) -> bool:
    """Require a real first frame and game-vision capability before reporting OK."""
    if timeout_seconds <= 0:
        raise ValueError("vision startup timeout must be positive")
    cancelled = stop_event or Event()
    try:
        if cancelled.is_set():
            raise RuntimeError("vision startup cancelled")
        # Optional codec spawn/import has its own bounded readiness wait. It
        # must finish before the camera budget starts, with no capture owner
        # running yet. Otherwise a ~20 s cold import spends the entire 20 s
        # first-frame deadline before sensor configuration has even begun.
        prepare = getattr(supervisor, "prepare", None)
        if callable(prepare):
            prepare()
        if cancelled.is_set():
            raise RuntimeError("vision startup cancelled")
        deadline = monotonic() + timeout_seconds
        status = supervisor.start()
        baseline_frame = status.get("frame_id") if type(status.get("frame_id")) is int else 0
        while True:
            state = status.get("state")
            if status.get("last_error") or state not in ("STARTING", "RUNNING"):
                raise RuntimeError(f"vision startup failed: {status}")
            capabilities = status.get("input_capabilities")
            games = capabilities.get("games") if isinstance(capabilities, Mapping) else None
            capable = (isinstance(capabilities, Mapping)
                       and capabilities.get("schema") == "local-game-vision-v1"
                       and capabilities.get("mode") == "games"
                       and isinstance(games, (list, tuple))
                       and {"game1", "game2", "game3"}.issubset(games))
            if (state == "RUNNING" and type(status.get("frame_id")) is int
                    and status["frame_id"] > baseline_frame):
                if not capable or status.get("owner_held") is not True:
                    raise RuntimeError("vision first frame lacks the game input contract")
                return True
            remaining = deadline - monotonic()
            if remaining <= 0:
                raise TimeoutError("vision did not publish a first frame before startup deadline")
            if cancelled.wait(min(0.05, remaining)):
                raise RuntimeError("vision startup cancelled")
            status = supervisor.status()
    except BaseException as error:
        try:
            cleanup = supervisor.stop()
            if cleanup.get("cleanup_confirmed") is not True:
                raise RuntimeError(f"vision cleanup unconfirmed: {cleanup}")
        except BaseException as cleanup_error:
            raise RuntimeError(f"{error}; vision cleanup failed: {cleanup_error}") from error
        raise


def start_vision_with_recovery(supervisor: VisionSupervisor, *, attempts: int = 2,
                               timeout_seconds: float = 20.0,
                               stop_event: Event | None = None) -> bool:
    """Retry transient first-frame timeouts only after proven owner release."""
    if type(attempts) is not int or not 1 <= attempts <= 3:
        raise ValueError("vision startup attempts must be an integer in [1, 3]")
    cancelled = stop_event or Event()
    for attempt in range(1, attempts + 1):
        try:
            return start_vision_until_ready(supervisor, timeout_seconds=timeout_seconds,
                                            stop_event=cancelled)
        except TimeoutError as error:
            released = supervisor.status()
            if (released.get("cleanup_confirmed") is not True
                    or released.get("owner_held") is not False):
                raise RuntimeError("vision retry refused: previous owner release unconfirmed") from error
            if cancelled.is_set():
                raise RuntimeError("vision startup cancelled") from error
            if attempt == attempts:
                raise TimeoutError(f"vision first frame unavailable after {attempts} verified attempts: {error}") from error
            print(f"VISION_STARTUP_RETRY attempt={attempt + 1}/{attempts}: {error}", flush=True)
            if cancelled.wait(.25):
                raise RuntimeError("vision startup cancelled") from error
    raise AssertionError("unreachable vision startup state")


def verify_hand_readonly_report(
    report: Mapping[str, Any], *, port: str, motor_ids: Sequence[int],
) -> bool:
    """Accept only the complete 17-motor, torque-off R08 probe receipt."""
    expected = tuple(motor_ids)
    motors = report.get("motors")
    if (len(expected) != 17 or len(set(expected)) != 17
            or report.get("schema") != "pynq-usb-hand-readonly-v1"
            or report.get("result") != "READ_ONLY_COMPLETE"
            or report.get("port") != port
            or report.get("motion_authorized") is not False
            or report.get("release_ready") is not False
            or report.get("port_closed") is not True
            or report.get("read_requests") != 85
            or not isinstance(motors, list)
            or tuple(motor.get("id") for motor in motors if isinstance(motor, dict)) != expected):
        raise RuntimeError("hand read-only probe identity or completeness mismatch")
    required = {"torque", "position_raw", "voltage_raw", "temperature_c", "native_limit"}
    for motor in motors:
        reads = motor.get("reads")
        if (not isinstance(reads, dict) or set(reads) != required
                or not all(isinstance(reading, dict) for reading in reads.values())):
            raise RuntimeError("hand read-only probe omitted a register")
        if any(type(reading.get("result")) is not int or reading["result"] != 0
               or type(reading.get("device_error")) is not int or reading["device_error"] != 0
               for reading in reads.values()):
            raise RuntimeError("hand read-only probe contains a device error")
        if (reads["torque"].get("value") != 0
                or type(reads["position_raw"].get("value")) is not int
                or not 0 <= reads["position_raw"]["value"] <= 4095
                or type(reads["voltage_raw"].get("value")) is not int
                or not 40 <= reads["voltage_raw"]["value"] <= 90
                or type(reads["temperature_c"].get("value")) is not int
                or not 0 <= reads["temperature_c"]["value"] < 40
                or reads["native_limit"].get("value") != 1000):
            raise RuntimeError("hand read-only probe value is outside the safe contract")
    return True


def hand_readonly_check(
    probe: Callable[[], Mapping[str, Any]], *, port: str, motor_ids: Sequence[int],
) -> bool:
    return verify_hand_readonly_report(probe(), port=port, motor_ids=motor_ids)
