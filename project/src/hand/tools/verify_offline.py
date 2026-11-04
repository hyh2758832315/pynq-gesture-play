import argparse
import ast
from contextlib import nullcontext, redirect_stdout
from dataclasses import replace
import hashlib
from importlib import metadata
import io
import json
from pathlib import Path
import platform
import socket
import sys
import time
import unittest
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from pynq_usb_hand.assets import verify_frozen
from pynq_usb_hand.cli import main


def verify_serial_wait():
    import serial
    from scservo_sdk import COMM_RX_TIMEOUT, PortHandler, scscl
    from pynq_usb_hand.transport import BoundedPortHandler

    results = {}
    for label, handler in (("nonblocking", PortHandler("memory-only")),
                           ("bounded_wait", BoundedPortHandler("memory-only"))):
        bounded = isinstance(handler, BoundedPortHandler)
        handler.ser = serial.serial_for_url("loop://", baudrate=1000000,
                                           timeout=handler.wait_slice if bounded else 0)
        handler.tx_time_per_byte = 0.01
        counters = {"reads": 0}
        original_read = handler.readPort

        def counted_read(length):
            counters["reads"] += 1
            return original_read(length)

        handler.readPort = counted_read
        started_wall, started_cpu = time.perf_counter(), time.process_time()
        try:
            for trial in range(5):
                with handler.transaction() if bounded else nullcontext():
                    handler.setPacketTimeout(6)
                    packet, result = scscl(handler).rxPacket()
                if result != COMM_RX_TIMEOUT or packet:
                    raise AssertionError("Empty memory port did not report receive timeout")
            results[label] = {
                "trials": 5, "read_calls": counters["reads"],
                "wall_seconds": round(time.perf_counter() - started_wall, 6),
                "cpu_seconds": round(time.process_time() - started_cpu, 6),
            }
        finally:
            handler.ser.close()
    if results["bounded_wait"]["read_calls"] > 50:
        raise AssertionError("Bounded memory receive unexpectedly busy-polled")
    return {"implementation": "BoundedPortHandler", "hardware_tested": False,
            "wait_slice_seconds": handler.wait_slice, "transaction_timeout_seconds": handler.transaction_timeout,
            "clock": "monotonic", "cpu_is_pc_memory_probe_only": True, "comparison": results}


def verify_responsive_budget(*, endpoint_feedback=False, stage_targets=False, fixed_playback=False):
    from types import SimpleNamespace
    from scservo_sdk import scscl
    from pynq_usb_hand.transport import BoundedSCSCL
    from pynq_usb_hand.orca_backend import OrcaBackend, OrcaModel, SafetyPolicy
    from pynq_usb_hand.motion import Cancellation, Motion, MotionSettings

    model = OrcaModel(ROOT)
    from orca_core.hardware.scs225_client import SCS225Client, POS_SCALE

    results = []
    codec = scscl(None)
    for start_state in model.poses:
        for state in model.poses:
            for skip_unchanged in (False, True):
                now = [0.0]
                registers = {motor_id: int(round(position / POS_SCALE)) for motor_id, position in model.to_motor(model.poses[start_state]).items()}
                packets = []
                responses = bytearray()
                settings = (MotionSettings.endpoints(settle_delay=0.05, max_reached_samples=6,
                                                     max_feedback_gap=2, max_age=2)
                            if endpoint_feedback else MotionSettings.responsive(max_age=2))
                if fixed_playback:
                    settings = MotionSettings.fixed_playback(stage_waits=(0.1, 0.2, 0.3))
                if stage_targets:
                    if not endpoint_feedback:
                        raise ValueError("Native stage verification requires endpoint feedback")
                    settings = replace(settings, stage_targets=True, settle_delay=0.4,
                                       sample_interval=0.15, max_reached_samples=10)
                backend = OrcaBackend(model, "/dev/memory-only", SafetyPolicy(40, 2), skip_unchanged=skip_unchanged,
                                      allow_stage_targets=stage_targets or fixed_playback, allow_playback=fixed_playback)
                client = SCS225Client(model.ids, "memory-only")
                client.port_handler = backend.transport
                client.servo = BoundedSCSCL(backend.transport)
                client._connected = True
                client.write_profile_velocity(list(model.ids), [500] * 17)
                backend.client = client
                backend.expected_torque = 1
                backend.transport.clock = lambda: now[0]
                backend.transport.tx_time_per_byte = 0.01

                def write(packet):
                    packet = bytes(packet)
                    if packet[:2] != b"\xff\xff" or packet[2] not in model.ids or packet[-1] != (~sum(packet[2:-1]) & 255):
                        raise AssertionError("Invalid SDK packet or broadcast")
                    motor_id = packet[2]
                    if packet[4] == 3:
                        if len(packet) != 13 or packet[5] != 42:
                            raise AssertionError("Unexpected position packet")
                        raw = codec.scs_makeword(packet[6], packet[7])
                        duration = codec.scs_makeword(packet[8], packet[9])
                        speed = codec.scs_makeword(packet[10], packet[11])
                        if duration != 0 or speed != 500:
                            raise AssertionError("Motion profile changed servo speed/time")
                        registers[motor_id] = raw
                        data = []
                        now[0] += 0.002
                    elif packet[4] == 2 and packet[5:7] == bytes([16, 48]):
                        if fixed_playback:
                            raise AssertionError("PLAYBACK_REGISTER_READ_FORBIDDEN")
                        data = [0] * 48
                        data[0:2] = [codec.scs_lobyte(1000), codec.scs_hibyte(1000)]
                        data[24] = 1
                        data[40:42] = [codec.scs_lobyte(registers[motor_id]), codec.scs_hibyte(registers[motor_id])]
                        data[46:48] = [50, 25]
                        now[0] += 0.003
                    else:
                        raise AssertionError("Unexpected SDK instruction")
                    packets.append(packet)
                    content = [motor_id, len(data) + 2, 0] + data
                    responses.extend([255, 255] + content + [(~sum(content)) & 255])
                    return len(packet)

                def read(length):
                    data = bytes(responses[:length])
                    del responses[:length]
                    return data

                backend.transport.ser = SimpleNamespace(timeout=0.01, write_timeout=0.1, out_waiting=0,
                                                         write=write, read=read, reset_input_buffer=responses.clear)
                cancel = Cancellation(60, clock=lambda: now[0])
                motion = Motion(backend, settings, clock=lambda: now[0])

                def wait(duration):
                    now[0] += duration
                    cancel.check()

                repetitions = 2 if fixed_playback else 1
                with patch("pynq_usb_hand.orca_backend.time.monotonic", side_effect=lambda: now[0]), patch.object(cancel, "wait", side_effect=wait):
                    with patch.object(model, "to_motor", side_effect=AssertionError("RUNTIME_TARGET_CONVERSION_FORBIDDEN")) if fixed_playback else nullcontext():
                        for repetition in range(repetitions):
                            motion.run(state, cancel)
                expected = {motor_id: int(round(position / POS_SCALE)) for motor_id, position in model.to_motor(model.poses[state]).items()}
                if registers != expected or responses:
                    raise AssertionError("Final raw target mismatch or unconsumed ACK")
                if endpoint_feedback:
                    expected_reads = {"default": 68, "paper": 170, "scissors": 119, "rock": 170}[state]
                    if sum(packet[4] == 2 for packet in packets) != expected_reads:
                        raise AssertionError("Endpoint profile performed intermediate or missing feedback")
                if fixed_playback and any(packet[4] != 3 for packet in packets):
                    raise AssertionError("Playback sent a non-position instruction")
                if stage_targets or fixed_playback:
                    maximum_writes = {"default": 17, "paper": 51, "scissors": 34, "rock": 51}[state] * repetitions
                    actual_writes = sum(packet[4] == 3 for packet in packets)
                    if actual_writes > maximum_writes or (not skip_unchanged and actual_writes != maximum_writes):
                        raise AssertionError("Native stages performed intermediate or missing target writes")
                results.append({"start": start_state, "state": state, "skip_unchanged": skip_unchanged,
                                "repetitions": repetitions,
                                "simulated_seconds": round(now[0], 6), "headroom_to_2s": round(2 - now[0], 6),
                                "write_packets": sum(packet[4] == 3 for packet in packets),
                                "read_packets": sum(packet[4] == 2 for packet in packets),
                                "final_raw": registers})
    expected_cases = {(start, state, skip) for start in model.poses for state in model.poses for skip in (False, True)}
    actual_cases = {(row["start"], row["state"], row["skip_unchanged"]) for row in results}
    if actual_cases != expected_cases or len(results) != len(expected_cases):
        raise AssertionError("Incomplete SDK start/target/deduplication coverage")
    return {"source": "REAL_SDK_MEMORY_SERIAL_SIMULATED_CLOCK", "hardware_tested": False,
            "profile": "fixed-playback" if fixed_playback else "native-stages" if stage_targets else "endpoints" if endpoint_feedback else "responsive",
            "timing_source": "synthetic test waits, not hardware calibration" if fixed_playback else "simulated feedback",
            "write_transaction_seconds": 0.002, "read_transaction_seconds": 0.003,
            "mechanical_lag_modeled": False, "python_cpu_and_os_jitter_modeled": False,
            "target_seconds": None if fixed_playback else 2.0, "hardware_target_verified": False,
            "all_deduplicated_cases_under_target": None if fixed_playback else all(row["simulated_seconds"] < 2 for row in results if row["skip_unchanged"]),
            "scope": "Two Motion.run plays, zero register READ; startup/arm/release excluded" if fixed_playback else "Motion.run entry to final reached; default route included; controller dispatch/connect/arm/release excluded",
            "results": results}


def verify_stage_target_budget():
    from pynq_usb_hand.orca_backend import OrcaModel
    from pynq_usb_hand.motion import Cancellation, MockBackend, Motion, MotionSettings, Snapshot

    model = OrcaModel(ROOT)
    results = []
    for start_state in model.poses:
        for state in model.poses:
            now = [0.0]
            backend = MockBackend(model.poses, model.roms)
            backend.position = dict(model.poses[start_state])
            backend.torque = True
            settings = MotionSettings.endpoints(settle_delay=0.05, max_reached_samples=6,
                                               max_feedback_gap=2, max_age=2, stage_targets=True)
            motion = Motion(backend, settings, clock=lambda: now[0])
            cancel = Cancellation(45, clock=lambda: now[0])
            original_write = backend.write

            def sample(token):
                token.check()
                started = now[0]
                now[0] += 17 * 0.003
                backend.sequence += 1
                return Snapshot(backend.sequence, started, now[0], dict(backend.position))

            def write(target, token):
                original_write(target, token)
                now[0] += 17 * 0.002

            def wait(duration):
                now[0] += duration
                cancel.check()

            try:
                with patch.object(backend, "sample", side_effect=sample), patch.object(backend, "write", side_effect=write), patch.object(cancel, "wait", side_effect=wait):
                    motion.run(state, cancel)
                batches = {"default": 1, "paper": 3, "scissors": 2, "rock": 3}[state]
                if len(backend.writes) != batches or backend.sequence != 1 + 3 * batches:
                    raise AssertionError("Mock stage target accounting mismatch")
                if backend.position != model.poses[state] or backend.writes[0] != model.poses["default"]:
                    raise AssertionError("Mock stage target route mismatch")
                results.append({"start": start_state, "state": state, "target_batches": batches,
                                "position_target_equivalent": batches * 17, "full_hand_scans": backend.sequence,
                                "read_equivalent": backend.sequence * 17, "simulated_seconds": round(now[0], 6)})
            finally:
                backend.release()
                backend.close()
            if backend.torque or not backend.closed:
                raise AssertionError("Mock stage target release/close failed")
    return {"source": "MOCK_REAL_POSES_SIMULATED_CLOCK", "hardware_tested": False,
            "hardware_backend_allowed": False, "mechanical_lag_modeled": False,
            "cpu_savings_measured": False, "results": results}


def verify(output, write_lock=False):
    manifest = verify_frozen(ROOT)
    for directory in ("src", "tests", "tools"):
        for path in (ROOT / directory).rglob("*.py"):
            ast.parse(path.read_text(encoding="utf-8"), filename=str(path), feature_version=(3, 10))
    log = io.StringIO()
    with patch("serial.Serial.open", side_effect=AssertionError("OFFLINE_SERIAL_OPEN_FORBIDDEN")), \
            patch.object(socket.socket, "connect", side_effect=AssertionError("OFFLINE_NETWORK_FORBIDDEN")):
        suite = unittest.defaultTestLoader.discover(str(ROOT / "tests"))
        result = unittest.TextTestRunner(stream=log, verbosity=2).run(suite)
        if not result.wasSuccessful():
            output.parent.mkdir(parents=True, exist_ok=True)
            output.with_suffix(".log").write_text(log.getvalue(), encoding="utf-8")
            print(log.getvalue())
            raise RuntimeError("Offline regression failed; raw unittest log preserved")
        captured = io.StringIO()
        with redirect_stdout(captured):
            code = main(["--root", str(ROOT), "demo", "--real-poses", "--fast"])
        if code != 0:
            raise RuntimeError(captured.getvalue())
        serial_wait = verify_serial_wait()
        responsive_budget = verify_responsive_budget()
        endpoint_budget = verify_responsive_budget(endpoint_feedback=True)
        native_stage_budget = verify_responsive_budget(endpoint_feedback=True, stage_targets=True)
        fixed_playback_budget = verify_responsive_budget(fixed_playback=True)
        stage_target_budget = verify_stage_target_budget()
    event = json.loads(captured.getvalue().strip())
    if event["waypoints"] != 384 or event["joint_count"] != 17 or not event["torque_off"] or not event["closed"]:
        raise AssertionError("Three-cycle mock accounting mismatch")
    packages = {distribution.metadata["Name"]: distribution.version for distribution in metadata.distributions()}
    if write_lock:
        locked = sorted(f"{name}=={version}" for name, version in packages.items()
                        if name.lower().replace("_", "-") not in ("orca-core", "pynq-usb-hand"))
        (ROOT / "requirements-host.txt").write_text("\n".join(locked) + "\n", encoding="utf-8")
    report = {
        "schema": "pynq-usb-hand-offline-verification-v1",
        "result": "OFFLINE_VERIFIED", "board_pending": True, "release_ready": False,
        "python": sys.version, "platform": platform.platform(), "architecture": platform.machine(),
        "tests_run": result.testsRun, "failures": len(result.failures), "errors": len(result.errors),
        "frozen_files": len(manifest["sha256"]), "frozen_manifest_sha256": hashlib.sha256((ROOT / "frozen_manifest.json").read_bytes()).hexdigest(),
        "packages": packages, "mock_three_cycles": event, "position_write_equivalent": 384 * 17,
        "orca_origin": str(Path(sys.modules["orca_core"].__file__).resolve().relative_to(ROOT)),
        "serial_open_forbidden": True, "hardware_tested": False,
        "mode": "experiment", "control_mode": "FIXED_PLAYBACK_OFFLINE_VERIFIED",
        "board_button_binding": "not_evaluated_by_offline_test",
        "network_connect_forbidden": True,
        "serial_wait": serial_wait,
        "responsive_budget": responsive_budget,
        "endpoint_budget": endpoint_budget,
        "native_stage_budget": native_stage_budget,
        "fixed_playback_budget": fixed_playback_budget,
        "stage_target_budget": stage_target_budget,
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    output.with_suffix(".log").write_text(log.getvalue(), encoding="utf-8")
    print(log.getvalue())
    print(f"HAND_OFFLINE_PASS tests={result.testsRun} frozen={len(manifest['sha256'])} waypoints=384 position_write_equivalent=6528 serial_open=0 board_pending=true")


if __name__ == "__main__":
    arguments = argparse.ArgumentParser()
    arguments.add_argument("--output", type=Path, default=ROOT / "build" / "offline-verification.json")
    arguments.add_argument("--write-lock", action="store_true")
    options = arguments.parse_args()
    verify(options.output, options.write_lock)
