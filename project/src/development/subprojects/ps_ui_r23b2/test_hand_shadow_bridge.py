"""Two-process, observation-only PS to hand bridge test; no serial device."""

from __future__ import annotations

import json
import os
from pathlib import Path
import socket
import subprocess
import sys
import time


ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "subprojects/ps_ui_r23b2/python"))
sys.path.insert(0, str(ROOT / "build/hand-r28-source-wait-20261026-r04/src"))

from pynq_multimodal_game.hand_shadow_bridge import (LatestVisionFeed,
    create_mock_action_session, create_shadow_session, verify_mock_child,
    verify_shadow_sources)
from pynq_multimodal_game.hand_mock_session import MockHandActionSession
from pynq_multimodal_game.vision_input import GameVisionInputProvider
from pynq_usb_hand.controller import Controller
from pynq_usb_hand.game_bridge import DatagramPublisher, DatagramReceiver, GameObservation
from pynq_usb_hand.gesture_consumer import GestureConsumer, GestureObservation
from pynq_usb_hand.motion import MockBackend, MotionSettings


def test_shadow_feed_keeps_only_latest_and_revokes_on_source_change():
    snapshots = [None]

    class Provider:
        def peek_hand_classification(self):
            return snapshots[0]

    feed = LatestVisionFeed(Provider(), observation_type=GestureObservation,
                            envelope_type=GameObservation)
    assert feed.read() is None
    base = dict(run_id="run-a", config_epoch="epoch-a", observed_at=10.0,
                source_at=9.9, valid=True, gesture="paper")
    snapshots[0] = dict(base, frame_id=1)
    first = feed.read()
    assert first.observation.frame_id == 1
    assert feed.read() is first
    snapshots[0] = dict(base, frame_id=100, observed_at=10.1, source_at=10.0)
    assert feed.read().observation.frame_id == 100
    snapshots[0] = dict(base, run_id="run-b", frame_id=101)
    assert feed.read().observation.frame_id == 100
    assert feed.revoked == "vision_source_changed"


def test_mock_status_does_not_poll_vision_or_spawn_child(tmp_path):
    reads = []

    class Provider:
        def peek_hand_classification(self):
            reads.append(True)
            return None

    feed = LatestVisionFeed(Provider(), observation_type=GestureObservation,
                            envelope_type=GameObservation)
    hand_root = ROOT / "build/hand-r28-source-wait-20261026-r04"
    session = MockHandActionSession(
        feed, python=ROOT / "subprojects/pynq_usb_hand/.venv/Scripts/python.exe", hand_root=hand_root,
        entry=verify_mock_child(ROOT / "subprojects/ps_ui_r23b2"),
        output_dir=tmp_path / "hand-status", seconds=3)
    for _ in range(20):
        status = session.status()
        assert status["phase"] == "NEW"
        assert status["mode"] == "memory-only"
        assert status["child_pid"] is None
        assert status["release_confirmed"] is None
    assert not reads and not session.output_dir.exists()


def test_fresh_no_hand_frame_means_default_but_old_or_malformed_frames_do_not():
    now = [10.0]
    provider = GameVisionInputProvider(clock=lambda: now[0])

    def offer(frame, *, hand, age=0):
        provider.publish({
            "run_id": "vision-run", "server_age_ms": age,
            "stable": "5", "rps": "PAPER",
            "control": {"schema": "gesture-control-v1", "frame_id": frame,
                        "action_event_seq": 0, "valid": hand,
                        "direction": "IDLE", "smooth_uv": [0.0, 0.0]},
        }, config_epoch="vision-config")

    offer(1, hand=True)
    assert provider.peek_hand_classification()["gesture"] == "paper"
    now[0] = 10.1
    offer(2, hand=False)
    absent = provider.peek_hand_classification()
    assert absent["valid"] is True and absent["gesture"] is None
    assert absent["frame_id"] == 2 and absent["source_at"] == 10.1
    now[0] = 10.2
    offer(2, hand=False)
    assert provider.peek_hand_classification()["source_at"] == 10.1
    now[0] = 10.7
    assert now[0] - provider.peek_hand_classification()["source_at"] > .5
    provider.publish({"bad": "packet"}, config_epoch="vision-config")
    assert provider.peek_hand_classification()["valid"] is False


def test_vision_datagram_drives_three_mock_poses_then_default_and_release():
    provider = GameVisionInputProvider()
    feed = LatestVisionFeed(provider, observation_type=GestureObservation,
                            envelope_type=GameObservation)
    receiver_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    publisher_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    receiver_socket.bind(("127.0.0.1", 0))
    publisher_socket.connect(receiver_socket.getsockname())
    publisher = DatagramPublisher(publisher_socket, feed, session_id="visual-session")
    backend = MockBackend()
    controller = Controller(lambda: backend, lease_seconds=5,
                            settings=MotionSettings.fixed_playback(stage_waits=(.001,) * 3))
    controller.wait_connected()
    controller.arm()
    assert controller.wait_idle()
    receiver = None
    consumer = None
    frame = 0

    def offer(stable, label, *, publish=True, hand=True):
        nonlocal frame
        frame += 1
        provider.publish({
            "run_id": "vision-run", "server_age_ms": 0,
            "stable": stable, "rps": label,
            "control": {"schema": "gesture-control-v1", "frame_id": frame,
                        "action_event_seq": 0, "valid": hand,
                        "direction": "IDLE", "smooth_uv": [0.0, 0.0]},
        }, config_epoch="vision-config")
        if publish:
            assert publisher.publish()

    try:
        offer("5", "PAPER")
        first = feed.read()
        receiver = DatagramReceiver(receiver_socket, session_id="visual-session",
                                    game_run=first.game_run, max_age=.5)

        class Mailbox:
            def read(self):
                return receiver.poll(time.monotonic())

        consumer = GestureConsumer(
            controller, Mailbox(), source_identity=("vision-run", "vision-config"),
            max_age=.5, stable_seconds=.04, renew_interval=.1)

        def wait_for(state):
            deadline = time.monotonic() + 1
            while time.monotonic() < deadline:
                consumer.tick(time.monotonic)
                operation = controller.status()["operation"]
                if operation is not None and operation["state"] == state:
                    assert controller.wait_idle()
                    return
                time.sleep(.01)
            raise AssertionError(f"missing mock hand state: {state}")

        for stable, label, state, hand in (
            ("5", "PAPER", "paper", True),
            ("0", "ROCK", "rock", True),
            ("2", "SCISSORS", "scissors", True),
            ("1", "UNKNOWN", "default", False),
        ):
            time.sleep(.06)
            offer(stable, label, hand=hand)
            consumer.tick(time.monotonic)
            if state != "default":
                time.sleep(.06)
                offer(stable, label)
            wait_for(state)
        writes = len(backend.writes)
        for _ in range(50):
            offer("1", "UNKNOWN", publish=False)
        assert publisher.publish()
        consumer.tick(time.monotonic)
        assert consumer.last_frame == frame
        assert len(backend.writes) == writes
        time.sleep(.55)
        assert consumer.tick(time.monotonic) == "missing_source"
        assert receiver.stopped == "stale_source"
        assert consumer.stopped
    finally:
        if consumer is not None:
            consumer.stop("test_closed")
        controller.close()
        publisher_socket.close()
        receiver_socket.close()
    assert not backend.torque and backend.closed


def test_menu_video_game_vision_reaches_isolated_shadow(tmp_path):
    hand_root = ROOT / "build/hand-r28-source-wait-20261026-r04"
    hand_python = ROOT / "subprojects/pynq_usb_hand/.venv/Scripts/python.exe"
    verify_shadow_sources(hand_root)

    class VerifiedGate:
        passed = True
        root = hand_root
        python = hand_python

    provider = GameVisionInputProvider()
    session = create_shadow_session(
        provider, gate=VerifiedGate(), output_dir=tmp_path, seconds=3)

    def offer(frame, stable, label):
        provider.publish({
            "run_id": "bridge-run", "server_age_ms": 0,
            "stable": stable, "rps": label,
            "control": {"schema": "gesture-control-v1", "frame_id": frame,
                        "action_event_seq": 0, "valid": True,
                        "direction": "IDLE", "smooth_uv": [0.0, 0.0]},
        }, config_epoch="bridge-config")
        provider.sample_menu_control(tick_id=frame)
        provider.sample_with_receipt(tick_id=frame)

    offer(1, "5", "PAPER")
    session.start()
    try:
        ready = session.output_dir / "ready.json"
        deadline = time.monotonic() + 3
        while not ready.exists() and time.monotonic() < deadline:
            time.sleep(.02)
        assert ready.exists(), f"shadow did not start: {session.error}"
        for frame, stable, label in (
            (2, "5", "PAPER"), (3, "0", "ROCK"),
            (4, "2", "SCISSORS"), (5, "1", "UNKNOWN"),
        ):
            offer(frame, stable, label)
            time.sleep(.15)
        assert session.finished.wait(3), "shadow did not finish on source expiry"
        assert session.error is None
    finally:
        session.close()
    child = json.loads((session.output_dir / "shadow.json").read_text())
    publisher = json.loads((session.output_dir / "publisher.json").read_text())
    assert child["status"] == "SHADOW_OBSERVED"
    assert {"paper", "fist", "scissors", "None"}.issubset(child["gestures"])
    assert child["forbidden_modules"] == []
    assert child["serial_opened"] is False and child["hardware_motion"] is False
    assert publisher["feed_revoked"] == "shadow_finished"


def test_isolated_hand_python_consumes_vision_as_mock_actions(tmp_path):
    hand_root = ROOT / "build/hand-r28-source-wait-20261026-r04"
    hand_python = ROOT / "subprojects/pynq_usb_hand/.venv/Scripts/python.exe"
    child_script = ROOT / "subprojects/ps_ui_r23b2/hand_child/mock_motion_receiver.py"
    provider = GameVisionInputProvider()
    feed = LatestVisionFeed(provider, observation_type=GestureObservation,
                            envelope_type=GameObservation)
    sender_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sender_socket.bind(("127.0.0.1", 0))
    output_dir = tmp_path / "child"
    output_dir.mkdir()
    frame = 0

    def offer(stable, label):
        nonlocal frame
        frame += 1
        provider.publish({
            "run_id": "action-run", "server_age_ms": 0,
            "stable": stable, "rps": label,
            "control": {"schema": "gesture-control-v1", "frame_id": frame,
                        "action_event_seq": 0, "valid": True,
                        "direction": "IDLE", "smooth_uv": [0.0, 0.0]},
        }, config_epoch="action-config")

    offer("5", "PAPER")
    first = feed.read()
    session_id = "isolated-action-test"
    command = [str(hand_python), "-I", "-B", str(child_script),
               "--hand-root", str(hand_root), "--session", session_id,
               "--game-run", first.game_run,
               "--peer-port", str(sender_socket.getsockname()[1]),
               "--output-dir", str(output_dir), "--seconds", "4"]
    child = subprocess.Popen(command, stdin=subprocess.DEVNULL,
                             stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                             creationflags=subprocess.CREATE_NO_WINDOW if os.name == "nt" else 0)
    try:
        ready_path = output_dir / "ready.json"
        deadline = time.monotonic() + 3
        while not ready_path.exists() and child.poll() is None and time.monotonic() < deadline:
            time.sleep(.02)
        assert ready_path.exists(), child.communicate(timeout=2)
        ready = json.loads(ready_path.read_text())
        assert ready["session"] == session_id and ready["game_run"] == first.game_run
        assert ready["address"][0] == "127.0.0.1" and ready["actuator"] == "memory-only"
        sender_socket.connect(tuple(ready["address"]))
        publisher = DatagramPublisher(sender_socket, feed, session_id=session_id)
        assert publisher.publish()
        for stable, label in (("5", "PAPER"), ("0", "ROCK"),
                              ("2", "SCISSORS")):
            time.sleep(.15)
            offer(stable, label)
            assert publisher.publish()
            time.sleep(.15)
            offer(stable, label)
            assert publisher.publish()
            time.sleep(.2)
        offer("1", "UNKNOWN")
        assert publisher.publish()
        stdout, stderr = child.communicate(timeout=3)
        assert child.returncode == 0, (stdout, stderr)
        report = json.loads((output_dir / "mock-motion.json").read_text())
        assert report["result"] == "MOCK_ACTION_PASS"
        assert [entry["state"] for entry in report["operations"]] == [
            "paper", "rock", "scissors", "default"]
        assert report["receiver_stop"] == "stale_source"
        assert report["backend_closed"] and not report["torque_on_after_close"]
        assert not report["serial_opened"] and not report["hardware_motion"]
        assert report["forbidden_modules"] == []
    finally:
        sender_socket.close()
        if child.poll() is None:
            child.terminate()  # This entry only owns an in-memory backend.
            child.communicate(timeout=3)


def test_agent_owned_mock_child_uses_latest_vision_and_confirms_release(tmp_path):
    hand_root = ROOT / "build/hand-r28-source-wait-20261026-r04"
    package_root = ROOT / "subprojects/ps_ui_r23b2"
    assert verify_mock_child(package_root).name == "mock_motion_receiver.py"

    class VerifiedGate:
        passed = True
        root = hand_root
        python = ROOT / "subprojects/pynq_usb_hand/.venv/Scripts/python.exe"

    provider = GameVisionInputProvider()
    session = create_mock_action_session(
        provider, gate=VerifiedGate(), package_root=package_root,
        output_dir=tmp_path, seconds=4)

    def offer(frame, stable, label):
        provider.publish({
            "run_id": "owned-run", "server_age_ms": 0,
            "stable": stable, "rps": label,
            "control": {"schema": "gesture-control-v1", "frame_id": frame,
                        "action_event_seq": 0, "valid": True,
                        "direction": "IDLE", "smooth_uv": [0.0, 0.0]},
        }, config_epoch="owned-config")
        provider.sample_menu_control(tick_id=frame)
        provider.sample_with_receipt(tick_id=frame)

    offer(1, "5", "PAPER")
    session.start()
    try:
        deadline = time.monotonic() + 3
        while not (session.output_dir / "ready.json").exists() and time.monotonic() < deadline:
            time.sleep(.02)
        assert (session.output_dir / "ready.json").exists(), session.error
        while session.status()["phase"] != "ACTIVE" and time.monotonic() < deadline:
            time.sleep(.02)
        assert session.status()["phase"] == "ACTIVE"
        assert session.status()["release_confirmed"] is False
        frame = 1
        for stable, label in (("5", "PAPER"), ("0", "ROCK"),
                              ("2", "SCISSORS"), ("1", "UNKNOWN")):
            for _ in range(2):
                frame += 1
                offer(frame, stable, label)
                time.sleep(.15)
        assert session.finished.wait(3), session.error
    finally:
        session.close()
    parent = json.loads((session.output_dir / "parent.json").read_text())
    child = json.loads((session.output_dir / "mock-motion.json").read_text())
    assert parent["child_started"] and parent["child_exit"] == 0
    assert parent["child_result"] == "MOCK_ACTION_PASS"
    assert session.status()["phase"] == "CLOSED"
    assert session.status()["release_confirmed"] is True
    assert [entry["state"] for entry in child["operations"]] == [
        "paper", "rock", "scissors", "default"]
    assert not child["serial_opened"] and not child["hardware_motion"]
    assert child["backend_closed"] and not child["torque_on_after_close"]


def test_mock_child_can_be_closed_before_first_vision_frame(tmp_path):
    hand_root = ROOT / "build/hand-r28-source-wait-20261026-r04"

    class VerifiedGate:
        passed = True
        root = hand_root
        python = ROOT / "subprojects/pynq_usb_hand/.venv/Scripts/python.exe"

    session = create_mock_action_session(
        GameVisionInputProvider(), gate=VerifiedGate(),
        package_root=ROOT / "subprojects/ps_ui_r23b2",
        output_dir=tmp_path, seconds=3)
    session.start()
    session.close()
    parent = json.loads((session.output_dir / "parent.json").read_text())
    assert parent["child_started"] is False
    assert parent["error"] is None


def test_mock_child_immediate_close_after_ready_has_release_receipt(tmp_path):
    hand_root = ROOT / "build/hand-r28-source-wait-20261026-r04"

    class VerifiedGate:
        passed = True
        root = hand_root
        python = ROOT / "subprojects/pynq_usb_hand/.venv/Scripts/python.exe"

    provider = GameVisionInputProvider()
    provider.publish({
        "run_id": "close-run", "server_age_ms": 0, "stable": "5", "rps": "PAPER",
        "control": {"schema": "gesture-control-v1", "frame_id": 1,
                    "action_event_seq": 0, "valid": True,
                    "direction": "IDLE", "smooth_uv": [0.0, 0.0]},
    }, config_epoch="close-config")
    session = create_mock_action_session(
        provider, gate=VerifiedGate(), package_root=ROOT / "subprojects/ps_ui_r23b2",
        output_dir=tmp_path, seconds=3)
    session.start()
    ready = session.output_dir / "ready.json"
    deadline = time.monotonic() + 3
    while not ready.exists() and time.monotonic() < deadline:
        time.sleep(.01)
    assert ready.exists(), session.error
    session.close()
    parent = json.loads((session.output_dir / "parent.json").read_text())
    child = json.loads((session.output_dir / "mock-motion.json").read_text())
    assert parent["child_active"] and parent["child_exit"] == 0
    assert child["backend_closed"] and not child["torque_on_after_close"]


def test_mock_child_burst_then_source_change_stops_without_replay(tmp_path):
    hand_root = ROOT / "build/hand-r28-source-wait-20261026-r04"

    class VerifiedGate:
        passed = True
        root = hand_root
        python = ROOT / "subprojects/pynq_usb_hand/.venv/Scripts/python.exe"

    provider = GameVisionInputProvider()

    def offer(frame, *, run="source-a", stable="5", label="PAPER"):
        provider.publish({
            "run_id": run, "server_age_ms": 0, "stable": stable, "rps": label,
            "control": {"schema": "gesture-control-v1", "frame_id": frame,
                        "action_event_seq": 0, "valid": True,
                        "direction": "IDLE", "smooth_uv": [0.0, 0.0]},
        }, config_epoch="source-config")

    offer(1)
    session = create_mock_action_session(
        provider, gate=VerifiedGate(), package_root=ROOT / "subprojects/ps_ui_r23b2",
        output_dir=tmp_path, seconds=4)
    session.start()
    try:
        active = session.output_dir / "active.json"
        deadline = time.monotonic() + 3
        while not active.exists() and time.monotonic() < deadline:
            time.sleep(.02)
        assert active.exists(), session.error
        offer(2)
        time.sleep(.25)
        offer(3)
        time.sleep(.3)
        for frame in range(4, 204):
            offer(frame, stable="1", label="UNKNOWN")
        time.sleep(.2)
        offer(204, run="source-b", stable="0", label="ROCK")
        assert session.finished.wait(3), session.error
    finally:
        session.close()
    parent = json.loads((session.output_dir / "parent.json").read_text())
    child = json.loads((session.output_dir / "mock-motion.json").read_text())
    assert parent["feed_revoked"] == "vision_source_changed"
    assert parent["child_exit"] == 0 and parent["error"] is None
    assert child["receiver_stop"] == "producer_revoked"
    assert child["backend_closed"] and not child["torque_on_after_close"]
    assert [entry["state"] for entry in child["operations"]] == ["paper", "default"]
