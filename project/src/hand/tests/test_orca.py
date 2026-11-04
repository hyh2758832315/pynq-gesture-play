import json
import math
from pathlib import Path
import time
from types import SimpleNamespace
import unittest
from unittest.mock import patch

import serial
from scservo_sdk import COMM_RX_CORRUPT, COMM_RX_TIMEOUT, COMM_SUCCESS, scscl

from pynq_usb_hand.assets import verify_frozen
from pynq_usb_hand.motion import Cancellation, Cancelled, MockBackend, Motion, MotionSettings
from pynq_usb_hand.orca_backend import OrcaBackend, OrcaModel, SafetyPolicy
from pynq_usb_hand.probe import ReadOnlyPortHandler, read_snapshot
from pynq_usb_hand.transport import BoundedPortHandler, BoundedSCSCL


ROOT = Path(__file__).resolve().parents[1]


class FakeServo:
    def __init__(self, positions):
        self.positions = positions
        self.torque = {motor_id: 0 for motor_id in positions}
        self.transactions = []
        self.error = None
        self.voltage = 50
        self.temperature = 25
        self.limit = 1000

    def reply(self, motor_id, field, value):
        self.transactions.append((motor_id, field))
        return (value, 0, 4) if self.error == (motor_id, field) else (value, 0, 0)

    def ReadPos(self, motor_id):
        return self.reply(motor_id, "position", self.positions[motor_id])

    @staticmethod
    def scs_makeword(first, second):
        return scscl(None).scs_makeword(first, second)

    def readTxRx(self, motor_id, address, length):
        if (address, length) != (16, 48):
            raise AssertionError("Unexpected feedback block")
        codec = scscl(None)
        data = [0] * 48
        data[0:2] = [codec.scs_lobyte(self.limit), codec.scs_hibyte(self.limit)]
        data[24] = self.torque[motor_id]
        data[40:42] = [codec.scs_lobyte(self.positions[motor_id]), codec.scs_hibyte(self.positions[motor_id])]
        data[46:48] = [self.voltage, self.temperature]
        return self.reply(motor_id, "feedback", data)

    def read1ByteTxRx(self, motor_id, address):
        values = {62: self.voltage, 63: self.temperature, 40: self.torque[motor_id]}
        return self.reply(motor_id, address, values[address])

    def read2ByteTxRx(self, motor_id, address):
        return self.reply(motor_id, address, self.limit)

    def write1ByteTxRx(self, motor_id, address, value):
        self.transactions.append((motor_id, address, value))
        if self.error == (motor_id, "write"):
            return 0, 4
        self.torque[motor_id] = value
        return 0, 0


class OrcaTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        with patch("serial.Serial.open", side_effect=AssertionError("NO_SERIAL_OPEN")):
            cls.model = OrcaModel(ROOT)

    def test_68_terminal_targets_match_original_receipt(self):
        receipt = json.loads((ROOT / "assets/receipt.json").read_text(encoding="utf-8"))
        count = 0
        for name, pose in self.model.poses.items():
            stage = next(stage for stage in receipt["stages"] if stage["name"] == "gesture_" + name)
            original = self.model.to_motor(stage["target_joint_positions_deg"])
            actual = self.model.to_motor(pose)
            for motor_id in self.model.ids:
                self.assertEqual(round(actual[motor_id] * 4096 / (2 * math.pi)), round(original[motor_id] * 4096 / (2 * math.pi)))
                count += 1
        self.assertEqual(count, 68)
        self.assertEqual([round(self.model.to_motor(self.model.poses[name])[1] * 4096 / (2 * math.pi)) for name in ("default", "paper", "scissors", "rock")], [666, 667, 666, 666])
        verify_frozen(ROOT)

    def test_real_poses_motion_without_serial_or_gui(self):
        backend = MockBackend(self.model.poses, self.model.roms)
        backend.torque = True
        motion = Motion(backend, MotionSettings(step_size=0, hold=0, sample_interval=0.001))
        cancel = Cancellation(time.monotonic() + 10)
        for name in ("paper", "scissors", "rock"):
            motion.run(name, cancel)
        self.assertEqual(len(backend.writes), 128)
        self.assertEqual(backend.writes[-1], self.model.poses["rock"])

    def test_invalid_target_never_clips_silently(self):
        bad = dict(self.model.poses["rock"])
        bad["wrist"] = 10000
        with self.assertRaises(ValueError):
            self.model.to_motor(bad)
        with self.assertRaises(ValueError):
            self.model.to_motor({})

    def test_cached_conversion_matches_frozen_waypoints_exactly(self):
        with patch("serial.Serial.open", side_effect=AssertionError("NO_SERIAL_OPEN")):
            for start in self.model.poses.values():
                for target in self.model.poses.values():
                    for index in range(21):
                        fraction = index / 20
                        joints = {joint: start[joint] * (1 - fraction) + value * fraction
                                  for joint, value in target.items()}
                        expected = dict(zip(self.model.ids, self.model.hand._joint_to_motor_pos(joints)))
                        self.assertEqual(self.model.to_motor(joints), expected)

    def test_cached_conversion_does_not_rebuild_original_lookup_maps(self):
        with patch.object(self.model.hand, "_joint_to_motor_pos", side_effect=AssertionError("LOOKUP_REBUILT")):
            for target in self.model.poses.values():
                self.assertEqual(set(self.model.to_motor(target)), set(self.model.ids))

    def test_cached_feedback_conversion_matches_frozen_formula_exactly(self):
        with patch("serial.Serial.open", side_effect=AssertionError("NO_SERIAL_OPEN")):
            for index in range(101):
                motor = {motor_id: lower + (upper - lower) * index / 100
                         for motor_id, (lower, upper) in self.model.bounds.items()}
                expected = self.model.hand._motor_to_joint_pos([motor[motor_id] for motor_id in self.model.ids])
                self.assertEqual(self.model.to_joint(motor), expected)
            with patch.object(self.model.hand, "_motor_to_joint_pos", side_effect=AssertionError("LOOKUP_REBUILT")):
                self.assertEqual(set(self.model.to_joint(motor)), set(self.model.roms))

    def backend(self, *, speed=500, playback=False):
        positions = {motor_id: round(value * 4096 / (2 * math.pi)) for motor_id, value in self.model.to_motor(self.model.poses["default"]).items()}
        servo = FakeServo(positions)
        writes = []

        def write(ids, targets):
            for motor_id, target in zip(ids, targets):
                writes.append((motor_id, target))
                servo.positions[motor_id] = round(target * 4096 / (2 * math.pi))

        def write_raw(motor_id, raw, duration, speed):
            self.assertEqual(duration, 0)
            self.assertEqual(speed, backend.client._motor_speed[motor_id])
            write([motor_id], [raw * 2 * math.pi / 4096])
            return 0, 0

        servo.WritePos = write_raw
        backend = OrcaBackend(self.model, "/dev/test-hand", SafetyPolicy(60, 2), speed=speed,
                      allow_stage_targets=playback, allow_playback=playback)
        backend.client = SimpleNamespace(servo=servo, is_connected=True,
                                         _motor_speed={motor_id: 500 for motor_id in self.model.ids},
                                         write_desired_pos=write,
                                         write_profile_velocity=lambda ids, values: backend.client._motor_speed.update(zip(ids, values)))
        return backend, servo, writes

    def test_explicit_speed_is_validated_without_serial_io(self):
        self.assertEqual(self.backend()[0].speed, 500)
        for speed in (0, -1, 32768, 600.0, True, None):
            with self.subTest(speed=speed), self.assertRaises(ValueError):
                OrcaBackend(self.model, "/dev/test-hand", SafetyPolicy(60, 2), speed=speed)

    def test_compiled_playback_matches_sdk_raw_without_runtime_conversion(self):
        from orca_core.hardware.scs225_client import POS_SCALE

        backend, servo, writes = self.backend(playback=True)
        backend.expected_torque = 1
        backend.skip_unchanged = True
        target = self.model.poses["rock"]
        expected = [(motor_id, int(round(position / POS_SCALE)), 0, 500)
                    for motor_id, position in self.model.to_motor(target).items()]
        commands = backend.compile_target(target)
        cancel = Cancellation(time.monotonic() + 10)
        with patch.object(self.model, "to_motor", side_effect=AssertionError("RUNTIME_CONVERSION_FORBIDDEN")), patch.object(servo, "readTxRx", side_effect=AssertionError("RUNTIME_READ_FORBIDDEN")), patch.object(servo, "WritePos", wraps=servo.WritePos) as native:
            backend.write_compiled(commands, cancel)
            backend.write_compiled(commands, cancel)
        self.assertEqual([call.args for call in native.call_args_list], expected)
        self.assertEqual(len(writes), 17)
        backend.release()
        self.assertEqual(backend.last_targets, {})
        with self.assertRaisesRegex(RuntimeError, "enabled"):
            backend.write_compiled(commands, cancel)

    def test_compiled_playback_ack_errors_stop_and_invalidate_cache(self):
        for communication, error in ((COMM_RX_TIMEOUT, 0), (COMM_RX_CORRUPT, 0), (0, 4)):
            backend, servo, writes = self.backend(playback=True)
            backend.expected_torque = 1
            commands = backend.compile_target(self.model.poses["paper"])
            backend.last_targets[99] = (0, 500)
            with self.subTest(communication=communication, error=error), patch.object(servo, "WritePos", return_value=(communication, error)) as native:
                with self.assertRaises(OSError):
                    backend.write_compiled(commands, Cancellation(time.monotonic() + 10))
            self.assertEqual(native.call_count, 1)
            self.assertEqual(backend.last_targets, {})
            self.assertEqual(writes, [])

    def test_compiled_playback_cancellation_stops_between_motors(self):
        backend, servo, writes = self.backend(playback=True)
        backend.expected_torque = 1
        commands = backend.compile_target(self.model.poses["rock"])
        cancel = Cancellation(time.monotonic() + 10)
        original = servo.WritePos
        def stop(motor_id, raw, duration, speed):
            result = original(motor_id, raw, duration, speed)
            cancel.event.set()
            return result
        with patch.object(servo, "WritePos", side_effect=stop), self.assertRaises(Cancelled):
            backend.write_compiled(commands, cancel)
        self.assertEqual(len(writes), 1)
        self.assertEqual(backend.last_targets, {})

    def test_compiled_playback_requires_explicit_backend_authorization(self):
        backend, servo, writes = self.backend()
        with self.assertRaises(ValueError):
            backend.compile_target(self.model.poses["default"])
        for options in ({"allow_playback": True}, {"allow_stage_targets": True, "allow_playback": 1},
                         {"allow_stage_targets": True, "allow_playback": True, "speed": 600}):
            with self.subTest(options=options), self.assertRaises(ValueError):
                OrcaBackend(self.model, "/dev/forbidden", SafetyPolicy(40, 2), **options)

    def test_native_stage_authorization_is_explicit_and_speed500_only(self):
        settings = MotionSettings.endpoints(settle_delay=0.4, max_reached_samples=10,
                                           max_feedback_gap=2, max_age=2, stage_targets=True)
        backend = OrcaBackend(self.model, "/dev/test-hand", SafetyPolicy(40, 2))
        with self.assertRaisesRegex(ValueError, "offline-only"):
            Motion(backend, settings)
        allowed = OrcaBackend(self.model, "/dev/test-hand", SafetyPolicy(40, 2), allow_stage_targets=True)
        self.assertIs(Motion(allowed, settings).backend, allowed)
        for changes in ({"allow_stage_targets": 1}, {"allow_stage_targets": True, "speed": 600}):
            with self.assertRaises(ValueError):
                OrcaBackend(self.model, "/dev/test-hand", SafetyPolicy(40, 2), **changes)

    def test_arm_uses_selected_speed_before_alignment_and_motion(self):
        for speed in (600, 700, 800, 900, 1000):
            backend, servo, writes = self.backend(speed=speed)
            backend.skip_unchanged = True
            cancel = Cancellation(time.monotonic() + 10)
            with self.subTest(speed=speed):
                original = backend.client.write_desired_pos

                def checked_alignment(ids, targets):
                    self.assertEqual(set(backend.client._motor_speed.values()), {speed})
                    original(ids, targets)

                backend.client.write_desired_pos = checked_alignment
                backend.arm(cancel)
                self.assertEqual(len(writes), 17)
                with patch.object(servo, "WritePos", wraps=servo.WritePos) as native:
                    backend.write(self.model.poses["rock"], cancel)
                self.assertEqual(len(native.call_args_list), 17)
                self.assertTrue(all(call.args[2:] == (0, speed) for call in native.call_args_list))
                self.assertEqual(backend.release(), ())

    def test_preflight_is_complete_read_only_and_fresh(self):
        backend, servo, writes = self.backend()
        cancel = Cancellation(time.monotonic() + 10)
        first = backend.sample(cancel)
        second = backend.sample(cancel)
        self.assertGreater(second.sequence, first.sequence)
        self.assertEqual(set(backend.health), set(self.model.ids))
        self.assertEqual(len(servo.transactions), 17 * 2)
        self.assertTrue(all(len(transaction) == 2 for transaction in servo.transactions))
        self.assertEqual(writes, [])

    def test_sdk_device_error_and_safety_failures_are_rejected(self):
        for failure in ("device", "low_voltage", "temperature", "limit", "torque", "range"):
            backend, servo, writes = self.backend()
            if failure == "device":
                servo.error = (17, "feedback")
            elif failure == "low_voltage":
                servo.voltage = 39
            elif failure == "temperature":
                servo.temperature = 60
            elif failure == "limit":
                servo.limit = 999
            elif failure == "torque":
                servo.torque[17] = 1
            else:
                servo.positions[17] = 4095
            with self.subTest(failure=failure), self.assertRaises((OSError, ValueError)):
                backend.sample(Cancellation(time.monotonic() + 10))
            self.assertEqual(writes, [])

    def test_arm_aligns_current_targets_before_enabling(self):
        backend, servo, writes = self.backend()
        backend.arm(Cancellation(time.monotonic() + 10))
        self.assertEqual(len(writes), 17)
        self.assertTrue(all(value == 1 for value in servo.torque.values()))
        self.assertEqual(backend.expected_torque, 1)
        self.assertEqual(backend.release(), ())
        self.assertTrue(all(value == 0 for value in servo.torque.values()))

    def test_backend_binds_transport_and_scopes_each_sdk_transaction(self):
        backend, servo, writes = self.backend()
        self.assertIs(self.model.hand.motor_client.port_handler, backend.transport)
        original = servo.reply

        def checked_reply(motor_id, field, value):
            self.assertIsNotNone(backend.transport._deadline)
            return original(motor_id, field, value)

        servo.reply = checked_reply
        backend.sample(Cancellation(time.monotonic() + 10))
        self.assertEqual(len(servo.transactions), 17)
        self.assertIsNone(backend.transport._deadline)

    def test_feedback_block_rejects_bad_length_bytes_and_communication(self):
        for payload, communication in (([0] * 47, 0), ([0] * 49, 0), ([256] * 48, 0), ([True] * 48, 0), ([], COMM_RX_TIMEOUT)):
            backend, servo, writes = self.backend()
            servo.readTxRx = lambda *args: (payload, communication, 0)
            with self.subTest(communication=communication, length=len(payload)), self.assertRaises(OSError):
                backend.sample(Cancellation(time.monotonic() + 10))
            self.assertEqual(backend.sequence, 0)
            self.assertEqual(backend.health, {})
            self.assertEqual(writes, [])

    def test_byte_feedback_uses_intrinsic_range_without_python_byte_walk(self):
        for container in (bytes, bytearray):
            backend, servo, writes = self.backend()
            original = servo.readTxRx

            def read_bytes(*arguments):
                payload, communication, error = original(*arguments)
                return container(payload), communication, error

            servo.readTxRx = read_bytes
            with self.subTest(container=container), patch("pynq_usb_hand.orca_backend.any", create=True,
                    side_effect=AssertionError("REDUNDANT_BYTE_WALK")):
                frame = backend.sample(Cancellation(time.monotonic() + 10))
            self.assertEqual(frame.sequence, 1)
            self.assertEqual(len(backend.health), 17)
            self.assertEqual(len(servo.transactions), 17)
            self.assertEqual(writes, [])

    def test_real_sdk_block_scan_uses_17_read_packets(self):
        backend, servo, writes = self.backend()
        packets = []
        replies = bytearray()

        def write(packet):
            packet = bytes(packet)
            self.assertEqual((packet[4], packet[5], packet[6]), (2, 16, 48))
            self.assertEqual(packet[-1], (~sum(packet[2:-1])) & 255)
            packets.append(packet)
            data, result, error = servo.readTxRx(packet[2], 16, 48)
            self.assertEqual(result, 0)
            content = [packet[2], len(data) + 2, error] + data
            replies.extend([255, 255] + content + [(~sum(content)) & 255])
            return len(packet)

        def read(length):
            data = bytes(replies[:length])
            del replies[:length]
            return data

        def serial_factory(**settings):
            return SimpleNamespace(**settings, write_timeout=None, out_waiting=0,
                                   read=read, write=write, close=lambda: None,
                                   reset_input_buffer=replies.clear)

        with patch("scservo_sdk.port_handler.serial.Serial", side_effect=serial_factory):
            self.assertTrue(backend.transport.openPort())
        self.addCleanup(backend.transport.closePort)
        backend.client.servo = BoundedSCSCL(backend.transport)
        frame = backend.sample(Cancellation(time.monotonic() + 10))
        self.assertEqual(len(packets), 17)
        self.assertEqual(frame.joints, self.model.to_joint({motor_id: raw * 2 * math.pi / 4096 for motor_id, raw in servo.positions.items()}))
        self.assertTrue(all(item == {"voltage": 5.0, "temperature": 25, "torque": 0} for item in backend.health.values()))
        self.assertEqual(writes, [])

    def test_cancellation_between_motor_writes(self):
        backend, servo, writes = self.backend()
        cancel = Cancellation(time.monotonic() + 10)
        original = backend.client.write_desired_pos

        def cancel_after_one(ids, targets):
            original(ids, targets)
            cancel.event.set()

        backend.client.write_desired_pos = cancel_after_one
        with self.assertRaises(Cancelled):
            backend.write(self.model.poses["rock"], cancel)
        self.assertEqual(len(writes), 1)
        self.assertEqual(backend.release(), ())

    def test_unchanged_targets_skip_only_acknowledged_raw_and_speed(self):
        backend, servo, writes = self.backend()
        backend.skip_unchanged = True
        backend.expected_torque = 1
        cancel = Cancellation(time.monotonic() + 10)
        target = self.model.poses["default"]
        backend.write(target, cancel)
        self.assertEqual(len(writes), 17)
        backend.write(target, cancel)
        self.assertEqual(len(writes), 17)
        motor_id = self.model.ids[0]
        backend.client._motor_speed[motor_id] = 501
        backend.write(target, cancel)
        self.assertEqual(len(writes), 18)
        self.assertEqual(writes[-1][0], motor_id)
        backend.release()
        self.assertEqual(backend.last_targets, {})
        backend.write(target, cancel)
        backend.write(target, cancel)
        self.assertEqual(len(writes), 52)

    def test_failed_or_cancelled_write_invalidates_all_cached_targets(self):
        backend, servo, writes = self.backend()
        backend.skip_unchanged = True
        backend.expected_torque = 1
        cancel = Cancellation(time.monotonic() + 10)
        target = self.model.poses["default"]
        backend.write(target, cancel)
        with patch.object(servo, "WritePos", side_effect=OSError("ACK failed")):
            with self.assertRaises(OSError):
                backend.write(self.model.poses["rock"], cancel)
        self.assertEqual(backend.last_targets, {})
        backend.write(target, cancel)
        self.assertEqual(len(writes), 34)
        cancel.event.set()
        with self.assertRaises(Cancelled):
            backend.write(target, cancel)
        self.assertEqual(backend.last_targets, {})

    def test_fast_write_uses_same_raw_speed_and_sdk_ack(self):
        from orca_core.hardware.scs225_client import POS_SCALE

        backend, servo, writes = self.backend()
        backend.skip_unchanged = True
        backend.expected_torque = 1
        target = self.model.poses["rock"]
        expected = [(motor_id, int(round(float(position) / POS_SCALE)), 0, 500)
                    for motor_id, position in self.model.to_motor(target).items()]
        with patch.object(servo, "WritePos", wraps=servo.WritePos) as native:
            with patch.object(backend.client, "write_desired_pos", side_effect=AssertionError("Repeated encoding")):
                backend.write(target, Cancellation(time.monotonic() + 10))
        self.assertEqual([call.args for call in native.call_args_list], expected)
        self.assertEqual(len(writes), 17)

    def test_fast_write_rejects_device_and_communication_errors(self):
        for communication, device_error in ((COMM_RX_TIMEOUT, 0), (0, 4)):
            backend, servo, writes = self.backend()
            backend.skip_unchanged = True
            backend.expected_torque = 1
            with self.subTest(communication=communication, device_error=device_error):
                with patch.object(servo, "WritePos", return_value=(communication, device_error)) as native:
                    with self.assertRaises(OSError):
                        backend.write(self.model.poses["rock"], Cancellation(time.monotonic() + 10))
                self.assertEqual(native.call_count, 1)
                self.assertEqual(backend.last_targets, {})
                self.assertEqual(writes, [])

    def test_cached_targets_do_not_bypass_target_validation_or_arm_alignment(self):
        backend, servo, writes = self.backend()
        backend.skip_unchanged = True
        backend.arm(Cancellation(time.monotonic() + 10))
        self.assertEqual(len(writes), 17)
        self.assertEqual(backend.last_targets, {})
        with self.assertRaises(ValueError):
            backend.write({}, Cancellation(time.monotonic() + 10))
        self.assertEqual(len(writes), 17)

    def test_partial_release_reports_exact_ids_and_attempts_all(self):
        backend, servo, writes = self.backend()
        servo.torque = {motor_id: 1 for motor_id in self.model.ids}
        servo.error = (3, "write")
        self.assertEqual(backend.release(), (3,))
        self.assertEqual(sum(len(transaction) == 3 for transaction in servo.transactions), 17)


class ReadOnlyProbeTests(unittest.TestCase):
    def test_real_sdk_scan_passes_guard_and_blocks_torque_write(self):
        transport = ReadOnlyPortHandler("memory-only", range(1, 18))
        replies = bytearray()
        packets = []
        codec = scscl(transport)

        def write(packet):
            packet = bytes(packet)
            packets.append(packet)
            value = {16: 1000, 40: 0, 56: 666, 62: 50, 63: 25}[packet[5]]
            data = [value] if packet[6] == 1 else [codec.scs_lobyte(value), codec.scs_hibyte(value)]
            content = [packet[2], len(data) + 2, 0] + data
            replies.extend([255, 255] + content + [(~sum(content)) & 255])
            return len(packet)

        def read(length):
            result = bytes(replies[:length])
            del replies[:length]
            return result

        def serial_factory(**settings):
            return SimpleNamespace(**settings, write_timeout=None, out_waiting=0,
                                   read=read, write=write, close=lambda: None,
                                   reset_input_buffer=replies.clear)

        with patch("scservo_sdk.port_handler.serial.Serial", side_effect=serial_factory):
            self.assertTrue(transport.openPort())
        self.addCleanup(transport.closePort)
        report = {"motors": []}
        read_snapshot(transport, range(1, 18), report)
        self.assertEqual(transport.read_requests, 85)
        self.assertEqual(len(packets), 85)
        self.assertTrue(all(packet[4] == 2 for packet in packets))
        self.assertTrue(all(motor["reads"]["position_raw"]["value"] == 666 for motor in report["motors"]))
        with self.assertRaises(PermissionError), transport.transaction():
            codec.write1ByteTxRx(1, 40, 1)
        self.assertEqual(len(packets), 85)

    def test_packet_guard_accepts_only_exact_read_requests(self):
        transport = ReadOnlyPortHandler("memory-only", range(1, 18))
        packet = bytes([255, 255, 3, 4, 2, 40, 1, 205])
        with patch.object(BoundedPortHandler, "writePort", return_value=8) as write:
            self.assertEqual(transport.writePort(packet), 8)
            for index, value in ((0, 0), (2, 18), (3, 5), (4, 3), (5, 41), (6, 2), (7, 0)):
                bad = bytearray(packet)
                bad[index] = value
                with self.subTest(index=index), self.assertRaises(PermissionError):
                    transport.writePort(bad)
            with self.assertRaises(PermissionError):
                transport.writePort(packet[:-1])
        self.assertEqual(write.call_count, 1)
        self.assertEqual(transport.read_requests, 1)

    def test_complete_snapshot_has_85_reads_and_zero_register_writes(self):
        servo = FakeServo(dict.fromkeys(range(1, 18), 666))
        report = {"motors": []}
        transport = BoundedPortHandler("memory-only")
        with patch("pynq_usb_hand.probe.scscl", return_value=servo):
            read_snapshot(transport, range(1, 18), report)
        self.assertEqual(len(report["motors"]), 17)
        self.assertEqual(len(servo.transactions), 85)
        self.assertTrue(all(len(transaction) == 2 for transaction in servo.transactions))

    def test_non_off_stops_without_implicit_release(self):
        servo = FakeServo({1: 666, 2: 666})
        servo.torque[1] = 1
        report = {"motors": []}
        with patch("pynq_usb_hand.probe.scscl", return_value=servo), self.assertRaisesRegex(ValueError, "not OFF"):
            read_snapshot(BoundedPortHandler("memory-only"), [1, 2], report)
        self.assertEqual(servo.transactions, [(1, 40)])
        self.assertEqual(servo.torque[1], 1)

    def test_failed_ack_preserves_evidence_and_stops_next_motor(self):
        servo = FakeServo({1: 666, 2: 666})
        servo.error = (1, "position")
        report = {"motors": []}
        with patch("pynq_usb_hand.probe.scscl", return_value=servo), self.assertRaises(OSError):
            read_snapshot(BoundedPortHandler("memory-only"), [1, 2], report)
        self.assertEqual(servo.transactions, [(1, 40), (1, "position")])
        self.assertEqual(report["motors"][0]["reads"]["position_raw"]["device_error"], 4)


class TransportTests(unittest.TestCase):
    servo_type = scscl

    def port(self):
        port = BoundedPortHandler("memory-only")
        port.ser = serial.serial_for_url("loop://", baudrate=1000000, timeout=port.wait_slice)
        port.tx_time_per_byte = 0.01
        self.addCleanup(port.ser.close)
        return port

    def test_setup_and_sdk_write_read_use_bounded_ack_transactions(self):
        opened = []
        writes = []
        replies = bytearray()

        def write(packet):
            writes.append(bytes(packet))
            parameters = [0] if packet[4] == 2 else []
            content = [packet[2], len(parameters) + 2, 0] + parameters
            replies.extend([255, 255] + content + [(~sum(content)) & 255])
            return len(packet)

        def read(length):
            result = bytes(replies[:length])
            del replies[:length]
            return result

        def serial_factory(**settings):
            port = SimpleNamespace(**settings, write_timeout=None, out_waiting=0,
                                   read=read, write=write, close=lambda: None,
                                   reset_input_buffer=replies.clear)
            opened.append(port)
            return port

        port = BoundedPortHandler("fake-only")
        with patch("scservo_sdk.port_handler.serial.Serial", side_effect=serial_factory):
            self.assertTrue(port.openPort())
        self.addCleanup(port.closePort)
        self.assertEqual(port.ser.timeout, port.wait_slice)
        self.assertEqual(port.ser.write_timeout, port.transaction_timeout)
        with port.transaction():
            self.assertEqual(self.servo_type(port).write1ByteTxRx(3, 40, 0), (COMM_SUCCESS, 0))
        with port.transaction():
            self.assertEqual(self.servo_type(port).read1ByteTxRx(3, 40), (0, COMM_SUCCESS, 0))
        self.assertEqual(len(opened), 1)
        self.assertEqual([packet[2] for packet in writes], [3, 3])
        self.assertFalse(port.is_using)

    def test_missing_ack_waits_instead_of_spinning(self):
        port = self.port()
        with port.transaction(), patch.object(port, "readPort", wraps=port.readPort) as read:
            port.setPacketTimeout(6)
            packet, result = self.servo_type(port).rxPacket()
        self.assertEqual(result, COMM_RX_TIMEOUT)
        self.assertEqual(packet, [])
        self.assertLessEqual(read.call_count, 10)
        self.assertFalse(port.is_using)

    def test_ack_checksum_and_device_error_are_preserved(self):
        for payload, expected in ((bytes([255, 255, 1, 2, 0, 252]), COMM_SUCCESS),
                                  (bytes([255, 255, 1, 2, 4, 248]), COMM_SUCCESS),
                                  (bytes([255, 255, 1, 2, 0, 0]), COMM_RX_CORRUPT)):
            port = self.port()
            port.ser.write(payload)
            with port.transaction():
                port.setPacketTimeout(6)
                packet, result = self.servo_type(port).rxPacket()
            self.assertEqual(result, expected)
            self.assertEqual(bytes(packet), payload)

    def test_cancel_during_read_releases_sdk_busy_flag(self):
        port = self.port()
        cancel = Cancellation(time.monotonic() + 1)
        original = port.ser.read

        def cancelled_read(length):
            cancel.event.set()
            return original(length)

        with self.assertRaises(Cancelled), port.transaction(cancel):
            port.is_using = True
            port.setPacketTimeout(6)
            with patch.object(port.ser, "read", side_effect=cancelled_read):
                self.servo_type(port).rxPacket()
        self.assertFalse(port.is_using)
        with port.transaction():
            port.setPacketTimeout(6)
            self.assertEqual(self.servo_type(port).rxPacket()[1], COMM_RX_TIMEOUT)

    def test_io_outside_transaction_is_rejected(self):
        port = self.port()
        with self.assertRaises(RuntimeError):
            port.readPort(1)

    def test_wait_is_clipped_to_packet_and_lease_deadlines(self):
        now = [1.0]
        port = BoundedPortHandler("fake-only", clock=lambda: now[0])
        cancel = Cancellation(1.003, clock=lambda: now[0])

        def read(length):
            self.assertLessEqual(port.ser.timeout, 0.003001)
            now[0] = 1.003
            return b""

        port.ser = SimpleNamespace(read=read)
        with self.assertRaisesRegex(TimeoutError, "lease"), port.transaction(cancel):
            port.setPacketTimeoutMillis(5)
            port.readPort(6)
        self.assertFalse(port.is_using)

    def test_late_complete_packet_cannot_escape_packet_deadline(self):
        now = [1.0]
        port = BoundedPortHandler("fake-only", clock=lambda: now[0])

        def read(length):
            self.assertLessEqual(port.ser.timeout, 0.002001)
            now[0] = 1.003
            return bytes([255, 255, 1, 2, 0, 252])

        port.ser = SimpleNamespace(read=read)
        with port.transaction():
            port.setPacketTimeoutMillis(2)
            packet, result = self.servo_type(port).rxPacket()
        self.assertEqual(result, COMM_RX_TIMEOUT)
        self.assertEqual(packet, [])

    def test_fragmented_reply_keeps_original_packet_deadline(self):
        now = [1.0]
        port = BoundedPortHandler("fake-only", clock=lambda: now[0])
        fragments = iter((b"\xff\xff\x01", b"\x04\x00\x34", b"\x12\xb4"))

        def read(length):
            now[0] += 0.001
            return next(fragments)

        port.ser = SimpleNamespace(read=read)
        with port.transaction():
            port.setPacketTimeoutMillis(5)
            packet, result = self.servo_type(port).rxPacket()
            self.assertEqual(port.packet_start_time, 1000)
        self.assertEqual(result, COMM_SUCCESS)
        self.assertEqual(bytes(packet[5:7]), b"\x34\x12")

    def test_truncated_packet_is_corrupt(self):
        port = self.port()
        port.ser.write(b"\xff\xff\x01")
        with port.transaction():
            port.setPacketTimeout(6)
            self.assertEqual(self.servo_type(port).rxPacket()[1], COMM_RX_CORRUPT)

    def test_output_drain_is_bounded_without_flush(self):
        now = [1.0]
        port = BoundedPortHandler("fake-only", clock=lambda: now[0])
        port.ser = SimpleNamespace(out_waiting=1)

        def wait(duration):
            now[0] += duration

        port._drain_wait = wait
        with self.assertRaisesRegex(TimeoutError, "transaction"), port.transaction():
            port.is_using = True
            port.clearPort()
        self.assertFalse(port.is_using)

    def test_cancel_interrupts_output_drain_wait(self):
        port = self.port()
        cancel = Cancellation(time.monotonic() + 1)
        port.ser = SimpleNamespace(out_waiting=1)

        def cancelled_wait(duration):
            cancel.event.set()
            cancel.check()

        with self.assertRaises(Cancelled), port.transaction(cancel):
            with patch.object(cancel, "wait", side_effect=cancelled_wait):
                port.clearPort()

    def test_write_sets_remaining_budget_and_checks_late_completion(self):
        now = [1.0]
        port = BoundedPortHandler("fake-only", clock=lambda: now[0])

        def write(packet):
            self.assertLessEqual(port.ser.write_timeout, 0.100001)
            now[0] = 1.2
            return len(packet)

        port.ser = SimpleNamespace(write=write)
        with self.assertRaisesRegex(TimeoutError, "transaction"), port.transaction():
            port.writePort(b"command")

    def test_write_exception_clears_sdk_busy_flag(self):
        port = self.port()
        with self.assertRaises(serial.SerialTimeoutException), port.transaction():
            with patch.object(port.ser, "write", side_effect=serial.SerialTimeoutException("blocked output")):
                self.servo_type(port).write1ByteTxRx(1, 40, 0)
        self.assertFalse(port.is_using)
        self.assertIsNone(port._deadline)

    def test_unchanged_read_timeout_does_not_reconfigure_port(self):
        port = self.port()
        port.ser.write(bytes([255, 255, 1, 2, 0, 252]))
        with patch.object(port.ser, "_reconfigure_port", wraps=port.ser._reconfigure_port) as configure:
            with port.transaction():
                port.setPacketTimeout(6)
                self.assertEqual(self.servo_type(port).rxPacket()[1], COMM_SUCCESS)
        configure.assert_not_called()

    def test_write_reuses_bounded_timeout_and_recovers_after_short_lease(self):
        now = [1.0]
        port = self.port()
        port.clock = lambda: now[0]
        port.ser.write_timeout = 0.09
        with patch.object(port.ser, "_reconfigure_port", wraps=port.ser._reconfigure_port) as configure:
            for _ in range(10):
                with port.transaction():
                    self.assertEqual(port.writePort(b"command"), 7)
                now[0] += 0.002
            configure.assert_not_called()
            cancel = Cancellation(now[0] + 0.003, clock=lambda: now[0])
            with port.transaction(cancel):
                port.writePort(b"short")
                self.assertLessEqual(port.ser.write_timeout, 0.003001)
            self.assertEqual(configure.call_count, 1)
            with port.transaction():
                port.writePort(b"next")
                self.assertGreaterEqual(port.ser.write_timeout, port.wait_slice)
                self.assertLessEqual(port.ser.write_timeout, port.transaction_timeout + 1e-9)
            self.assertEqual(configure.call_count, 2)

    def test_wrong_id_replies_share_transaction_deadline(self):
        now = [1.0]
        port = BoundedPortHandler("fake-only", clock=lambda: now[0])

        def read(length):
            now[0] += 0.02
            return bytes([255, 255, 2, 2, 0, 251])

        port.ser = SimpleNamespace(out_waiting=0, write=lambda packet: len(packet), read=read)
        with port.transaction():
            result, error = self.servo_type(port).write1ByteTxRx(1, 40, 0)
        self.assertEqual(result, COMM_RX_TIMEOUT)
        self.assertEqual(error, 0)
        self.assertLess(now[0], 1.1)
        self.assertFalse(port.is_using)


class BoundedCodecTests(TransportTests):
    servo_type = BoundedSCSCL

    def test_noise_and_overlapping_headers_resynchronize_without_new_deadline(self):
        for prefix in (b"noise", b"\xff", b"\xff\xff\xfe\x02\x00", b"\xff\xff\x01\x01\x00"):
            port = self.port()
            port.ser.write(prefix + bytes([255, 255, 1, 2, 4, 248]))
            with self.subTest(prefix=prefix), port.transaction():
                port.setPacketTimeout(6)
                start = port.packet_start_time
                packet, result = self.servo_type(port).rxPacket()
            self.assertEqual(result, COMM_SUCCESS)
            self.assertEqual(bytes(packet), bytes([255, 255, 1, 2, 4, 248]))
            self.assertEqual(port.packet_start_time, start)

    def test_read_rejects_checksum_valid_wrong_payload_length(self):
        for data in (b"", b"\x00\x00"):
            port = self.port()
            content = bytes([1, len(data) + 2, 0]) + data
            port.ser.write(b"\xff\xff" + content + bytes([~sum(content) & 255]))
            with patch.object(port, "clearPort"), patch.object(port, "writePort", return_value=8):
                with port.transaction():
                    payload, result, error = self.servo_type(port).readTxRx(1, 40, 1)
            self.assertEqual((payload, result, error), (b"", COMM_RX_CORRUPT, 0))

    def test_unopened_close_and_invalid_limits(self):
        port = BoundedPortHandler("unopened")
        port.closePort()
        port.closePort()
        for wait_slice, timeout in ((0, 1), (0.1, 0), (math.inf, 1), (0.2, 0.1)):
            with self.assertRaises(ValueError):
                BoundedPortHandler("unused", wait_slice=wait_slice, transaction_timeout=timeout)


if __name__ == "__main__":
    unittest.main()