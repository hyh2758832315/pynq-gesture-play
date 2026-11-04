from __future__ import annotations

from copy import deepcopy

import pytest

from pynq_multimodal_game.startup_checks import (
    hand_readonly_check, start_vision_until_ready, verify_hand_readonly_report,
)


def _vision(state: str, frame_id: int) -> dict:
    return {"state": state, "frame_id": frame_id, "owner_held": True,
            "last_error": None, "input_capabilities": {
                "schema": "local-game-vision-v1", "mode": "games",
                "games": ["game1", "game2", "game3"],
            }}


def test_startup_waits_for_real_vision_frame_and_cleans_failed_owner():
    class Supervisor:
        def __init__(self, statuses):
            self.statuses = iter(statuses)
            self.calls = []

        def start(self):
            self.calls.append("start")
            self.latest = next(self.statuses)
            return self.latest

        def status(self):
            self.calls.append("status")
            self.latest = next(self.statuses, self.latest)
            return self.latest

        def stop(self):
            self.calls.append("stop")
            return {"cleanup_confirmed": True}

    healthy = Supervisor([_vision("STARTING", 0), _vision("RUNNING", 0),
                          _vision("RUNNING", 1)])
    assert start_vision_until_ready(healthy, timeout_seconds=1)
    assert healthy.calls == ["start", "status", "status"]

    fault = Supervisor([_vision("STARTING", 0), {**_vision("FAULT", 0),
                                                "last_error": "camera failed"}])
    with pytest.raises(RuntimeError, match="camera failed"):
        start_vision_until_ready(fault, timeout_seconds=1)
    assert fault.calls == ["start", "status", "stop"]

    for old_frame in (0, 7):
        no_frame = Supervisor([_vision("RUNNING", old_frame)])
        with pytest.raises(TimeoutError, match="first frame"):
            start_vision_until_ready(no_frame, timeout_seconds=0.001)
        assert no_frame.calls[-1] == "stop"


def _hand_report():
    return {"schema": "pynq-usb-hand-readonly-v1", "result": "READ_ONLY_COMPLETE",
            "port": "/dev/serial/by-id/hand", "port_closed": True,
            "motion_authorized": False, "release_ready": False,
            "read_requests": 85,
            "motors": [{"id": motor_id, "reads": {
                "torque": {"value": 0, "result": 0, "device_error": 0},
                "position_raw": {"value": 666, "result": 0, "device_error": 0},
                "voltage_raw": {"value": 78, "result": 0, "device_error": 0},
                "temperature_c": {"value": 30, "result": 0, "device_error": 0},
                "native_limit": {"value": 1000, "result": 0, "device_error": 0},
            }} for motor_id in range(1, 18)]}


def test_hand_startup_gate_requires_complete_torque_off_probe():
    report = _hand_report()
    assert hand_readonly_check(lambda: report, port=report["port"],
                               motor_ids=range(1, 18))
    for field, value in (("torque", 1), ("temperature_c", 40),
                         ("voltage_raw", 39), ("native_limit", 999)):
        changed = deepcopy(report)
        changed["motors"][0]["reads"][field]["value"] = value
        with pytest.raises(RuntimeError, match="safe contract"):
            verify_hand_readonly_report(changed, port=report["port"],
                                        motor_ids=range(1, 18))
    changed = deepcopy(report)
    changed["port_closed"] = False
    with pytest.raises(RuntimeError, match="completeness"):
        verify_hand_readonly_report(changed, port=report["port"],
                                    motor_ids=range(1, 18))
