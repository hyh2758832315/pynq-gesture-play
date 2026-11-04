from functools import partial
import json
import os
import pathlib
import sys
import tempfile
import time
import unittest
from unittest.mock import Mock, patch

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "board/pynq_z2/scripts"))
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "python/pynq_multimodal_game"))
from voice_volume_control import BUILD_ID, MAGIC, PLL, SCHEMA, DirectTransport, ProcessTransport, VolumeControl, VolumeFault, configure_codec, _serve, _StartupTrace, _register_batch, _acknowledge_event
from volume_monitor import VolumeStatusPublisher


class FakeBackend:
    def __init__(self):
        self.registers = {0: MAGIC, 4: BUILD_ID, 8: SCHEMA, 0x1C: 977, 0x10: 8, 0x14: 0, 0x18: 0, 0x3C: 0}
        self.codec = {}
        self.codec_attempted = False
        self.codec_configured = False
        self.mutate = None

    def read32(self, offset):
        if self.mutate is not None:
            self.mutate(offset)
        return self.registers.get(offset, 0)

    def write32(self, offset, value):
        self.registers[offset] = value
        if offset == 0x30 and value == 1:
            self.registers[0x18] += 1
            self.registers[0x10] = 8 | self.registers[0x2C]
            self.registers.update({0x84: 0, 0x5C: 0, 0x60: self.registers[0x18], 0x64: 0})
        if offset == 0x30 and value == 2:
            self.registers[0x3C] += 1
            self.registers[0x84] = 1
            self.registers[0x40] = self.registers[0x10]
            self.registers[0x48] = self.registers[0x18]
            for target, source in ((0x78, 0x20), (0x7C, 0x24), (0x80, 0x28)):
                self.registers[target] = self.registers.get(source, 0)
        if offset == 0x30 and value == 4:
            if (self.registers[0x34], self.registers[0x38]) == (self.registers[0x60], self.registers[0x5C]):
                self.registers[0x10] &= ~2
                self.registers[0x84] = 0

    def codec_write(self, register, payload):
        self.codec[register] = payload
        return len(payload)

    def codec_read(self, register, length):
        if register == 0x4002:
            return self.codec[register][:-1] + b"\x03"
        return self.codec.get(register, bytes(length))

    def call(self, operation, *arguments, deadline):
        if time.monotonic() >= deadline:
            raise VolumeFault("fake deadline")
        return getattr(self, operation)(*arguments)

    def close(self):
        pass


class PeriodicEventBackend(FakeBackend):
    def __init__(self):
        super().__init__()
        self.started = None
        self.next_event = None
        self.event_started = None
        self.sequence = 0

    def read32(self, offset):
        current = time.monotonic()
        if self.registers[0x10] & 1:
            if self.started is None:
                self.started = current
                self.next_event = current + 0.08
            samples = int((current - self.started) * 48_828.125)
            self.registers.update({0x4C: samples, 0x54: samples // 977, 0x58: 0})
            if self.event_started is not None and current - self.event_started >= 0.1:
                self.registers[0x14] = 0x10
            if self.event_started is None and current >= self.next_event:
                self.sequence += 1
                self.event_started = current
                self.next_event = current + 0.18
                self.registers.update({0x10: 0x30B, 0x5C: self.sequence,
                    0x60: self.registers[0x18], 0x64: 5 if self.sequence % 2 else 6, 0x68: max(977, samples),
                    0x70: max(1, samples // 977)})
        return super().read32(offset)

    def write32(self, offset, value):
        if offset == 0x30 and value == 2 and self.event_started is not None:
            self.registers[0x74] = int((time.monotonic() - self.event_started) * 100_000_000)
        result = super().write32(offset, value)
        if offset == 0x30 and value == 4 and not self.registers[0x10] & 2:
            self.event_started = None
        return result


class SampleHangingBackend(FakeBackend):
    def read32(self, offset):
        if self.registers[0x10] & 1 and offset == 0x4C:
            while True:
                pass
        return super().read32(offset)


class HangingBackend(FakeBackend):
    def read32(self, offset):
        while True:
            pass


class WriteHangingBackend(FakeBackend):
    def __init__(self, fault_offset):
        super().__init__()
        self.fault_offset = fault_offset

    def write32(self, offset, value):
        if offset == self.fault_offset:
            while True:
                pass
        return super().write32(offset, value)


class HangingReply:
    def __reduce__(self):
        while True:
            pass


class ReplyHangingBackend(FakeBackend):
    def write32(self, offset, value):
        return HangingReply()


class ControlTests(unittest.TestCase):
    def test_management_full_output_and_partial_input_never_wait(self):
        from voice_volume_runtime import FRAME, START, VolumeManagementChannel
        endpoint = Mock()
        endpoint.send.side_effect = BlockingIOError
        endpoint.recv.side_effect = BlockingIOError
        channel = VolumeManagementChannel(endpoint)
        channel.send(START, 1)
        for _ in range(100):
            channel.flush()
            self.assertIsNone(channel.receive())
        self.assertEqual(len(channel.outgoing), FRAME.size)
        self.assertEqual(channel.incoming, b"")
        with self.assertRaisesRegex(VolumeFault, "already pending"):
            channel.send(START, 2)

    def test_autonomous_native_hang_retains_worker_and_captures_unfinished_register(self):
        from voice_volume_runtime import AutonomousVolumeProcess
        with tempfile.TemporaryDirectory() as directory:
            worker = AutonomousVolumeProcess(SampleHangingBackend,
                {"quiet_sum": 100, "soft_sum": 1000, "loud_sum": 4000}, diagnostic_root=directory)
            try:
                with self.assertRaisesRegex(VolumeFault, "management deadline"):
                    worker.start()
                with self.assertRaisesRegex(VolumeFault, "management deadline"):
                    worker.close()
                self.assertTrue(worker.process.is_alive())
                self.assertFalse(worker.stopped_confirmed)
                record = json.loads(next(pathlib.Path(directory).glob("volume-autonomous-fault-*.json")).read_text())
                native = record["native_milestones_best_effort"]
                self.assertEqual(native[1], 2)
                self.assertEqual(native[9], 0x4C)
                self.assertGreater(native[8], native[11])
            finally:
                worker.process.terminate()
                worker.process.join(1)
                worker.channel.socket.close()

    def test_autonomous_lifecycle_is_idempotent_and_parent_fault_diagnostic_is_json(self):
        from voice_volume_runtime import AutonomousVolumeProcess
        with tempfile.TemporaryDirectory() as directory:
            worker = AutonomousVolumeProcess(FakeBackend,
                {"quiet_sum": 100, "soft_sum": 1000, "loud_sum": 4000}, diagnostic_root=directory)
            try:
                worker.start()
                worker.start()
                worker._parent_error = "TEST_FIXTURE_NO_HARDWARE: lifecycle evidence"
                worker.read()
                records = list(pathlib.Path(directory).glob("volume-autonomous-fault-*.json"))
                self.assertEqual(len(records), 1)
                record = json.loads(records[0].read_text())
                self.assertEqual(len(record["diagnostics"]), 512)
                self.assertEqual(record["schema"], "volume-autonomous-fault-v1")
                self.assertIsNone(worker.diagnostic_error)
            finally:
                worker.close()
            worker.close()
            self.assertTrue(worker.stopped_confirmed)

    @unittest.skipUnless(os.name == "posix", "requires Linux flock and DupFd")
    def test_linux_orphan_disables_source_but_retains_only_surviving_guard(self):
        import fcntl
        from importlib import import_module
        from threading import Event
        from voice_volume_runtime import AutonomousVolumeProcess, ORPHAN
        with tempfile.TemporaryDirectory() as directory:
            path = pathlib.Path(directory) / "fixture.lock"
            owner = path.open("a+b")
            fcntl.flock(owner.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            worker = AutonomousVolumeProcess(FakeBackend,
                {"quiet_sum": 100, "soft_sum": 1000, "loud_sum": 4000},
                process_guard=import_module("multiprocessing.reduction").DupFd(owner.fileno()))
            try:
                worker.start()
                owner.close()
                worker.channel.socket.close()
                deadline = time.monotonic() + 2
                source = worker.read()
                while time.monotonic() < deadline and source["phase"] != ORPHAN:
                    Event().wait(0.01)
                    source = worker.read()
                self.assertEqual(source["phase"], ORPHAN)
                self.assertEqual(source["disabled"], 1)
                self.assertIn("parent disconnected", source["error"])
                self.assertTrue(worker.process.is_alive())
                with path.open("a+b") as contender:
                    with self.assertRaises(BlockingIOError):
                        fcntl.flock(contender.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            finally:
                owner.close()
                worker.process.terminate()
                worker.process.join(1)
            with path.open("a+b") as contender:
                fcntl.flock(contender.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)

    @unittest.skipUnless(os.name == "posix", "requires Linux flock and DupFd")
    def test_linux_spawn_inherits_guard_and_confirms_clean_journal(self):
        import fcntl
        from pynq_multimodal_game.agent.c6i_backend import C6IOverlaySession
        from voice_volume_runtime import AutonomousVolumeProcess
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            bitstream = root / "fixture.bit"
            bitstream.write_bytes(b"NO_HARDWARE_FIXTURE")
            bitstream.with_suffix(".hwh").write_text("<SYSTEM/>")
            session = C6IOverlaySession(bitstream, lock_path=root / "owner.lock",
                                        expected_build_id=0xC0060C00, require_root=False)
            session._overlay = object()
            session._fcntl = fcntl
            session._lock_file = (root / "owner.lock").open("a+b")
            fcntl.flock(session._lock_file.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            lease = session.borrow("voice-volume", instances=frozenset({"voice_volume_0"}))
            worker = AutonomousVolumeProcess(FakeBackend,
                {"quiet_sum": 100, "soft_sum": 1000, "loud_sum": 4000},
                process_guard=lease.export_process_guard("a" * 32), producer_run="a" * 32)
            try:
                lease.register_process(worker.producer_run, worker.process.pid)
                worker.start()
                record = json.loads(session._volume_journal.read_text())
                self.assertEqual(record["worker_pid"], worker.process.pid)
                with (root / "owner.lock").open("a+b") as contender:
                    with self.assertRaises(BlockingIOError):
                        fcntl.flock(contender.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
                worker.close()
                lease.confirm_process_stopped(worker.producer_run, disabled=True, exited=True)
                lease.close()
                session.close()
                self.assertEqual(json.loads(session._volume_journal.read_text())["state"], "CLEAN")
                with (root / "owner.lock").open("a+b") as contender:
                    fcntl.flock(contender.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            finally:
                if worker.process.is_alive():
                    worker.process.terminate()
                    worker.process.join(1)
                if session._lock_file is not None:
                    session._lock_file.close()

    def test_autonomous_exact_ack_survives_parent_300_and_600ms_with_no_consumption(self):
        from threading import Event
        from voice_volume_runtime import AutonomousVolumeProcess, RUNNING
        for delay, minimum in ((0.3, 1), (0.6, 3)):
            with self.subTest(parent_pause=delay):
                worker = AutonomousVolumeProcess(PeriodicEventBackend,
                    {"quiet_sum": 10747, "soft_sum": 15632, "loud_sum": 27356})
                try:
                    worker.start()
                    with worker.page.lock:
                        Event().wait(delay)
                    Event().wait(0.08)
                    source = worker.read()
                    self.assertEqual(source["phase"], RUNNING)
                    self.assertIsNone(source["error"])
                    self.assertGreaterEqual(source["ack_count"], minimum)
                    self.assertEqual(source["faults"], 0)
                    self.assertGreater(source["min_ack_margin_ns"], 0)
                    self.assertGreater(source["publish_skips"], 0)
                    from voice_volume_runtime import DIAGNOSTIC, DIAGNOSTIC_SLOTS
                    rows = tuple(DIAGNOSTIC.iter_unpack(source["diagnostics"]))
                    self.assertEqual(len(rows), DIAGNOSTIC_SLOTS)
                    self.assertTrue(any(row[4] > 0 for row in rows))
                finally:
                    worker.close()
                self.assertTrue(worker.stopped_confirmed)

    def test_autonomous_process_monitors_without_parent_requests_or_reads(self):
        from voice_volume_runtime import AutonomousVolumeProcess, RUNNING
        worker = AutonomousVolumeProcess(FakeBackend,
            {"quiet_sum": 100, "soft_sum": 1000, "loud_sum": 4000})
        try:
            worker.start()
            before = worker.read()["monitor_count"]
            from threading import Event
            with worker.page.lock:
                Event().wait(0.6)
            Event().wait(0.08)
            after = worker.read()
            self.assertEqual(after["phase"], RUNNING)
            self.assertGreater(after["monitor_count"], before + 10)
            self.assertGreater(after["publish_skips"], 10)
            self.assertIsNone(after["error"])
        finally:
            worker.close()
        self.assertFalse(worker.process.is_alive())
        self.assertTrue(worker.stopped_confirmed)

    def test_management_partial_frame_is_nonblocking(self):
        import socket
        from voice_volume_runtime import FRAME, START, VolumeManagementChannel
        parent, child = socket.socketpair()
        try:
            channel = VolumeManagementChannel(child)
            frame = FRAME.pack(b"VVA1", START, 1)
            parent.sendall(frame[:3])
            self.assertIsNone(channel.receive())
            self.assertIsNone(channel.receive())
            parent.sendall(frame[3:])
            self.assertEqual(channel.receive(), (START, 1))
        finally:
            parent.close()
            child.close()

    def test_direct_transport_preserves_monitor_and_exact_ack(self):
        backend = FakeBackend()
        transport = DirectTransport(backend)
        control = VolumeControl(transport, exclusive_owner=True)
        configure_codec(transport, stopped=True, straps_confirmed=True, mclk_hz=10_000_000)
        control.configure(quiet_sum=100, soft_sum=1000, loud_sum=4000, enable=True)
        backend.registers.update({0x10: 0x30B, 0x5C: 1, 0x60: 1, 0x64: 5,
                                 0x68: 7816, 0x70: 8, 0x74: 100})
        self.assertEqual(control.monitor()["event"]["sequence"], 1)
        event = control.event()
        control.acknowledge(event)
        self.assertFalse(backend.registers[0x10] & 2)
        self.assertFalse(transport.failed)

    def test_direct_transport_rejects_expired_request_without_mmio(self):
        backend = FakeBackend()
        backend.read32 = Mock(wraps=backend.read32)
        transport = DirectTransport(backend)
        with self.assertRaisesRegex(VolumeFault, "expired"):
            transport.call("read32", 0, deadline=time.monotonic() - 0.001)
        backend.read32.assert_not_called()
        self.assertTrue(transport.failed)

    def test_direct_transport_late_native_return_quarantines_followup(self):
        backend = FakeBackend()
        transport = DirectTransport(backend)
        with patch("voice_volume_control.time.monotonic", side_effect=(100.0, 100.0, 100.2)):
            with self.assertRaisesRegex(VolumeFault, "deadline"):
                transport.call("read32", 0, deadline=100.1)
        backend.write32 = Mock(wraps=backend.write32)
        with self.assertRaisesRegex(VolumeFault, "quarantined"):
            transport.call("write32", 0x30, 4, deadline=time.monotonic() + 0.05)
        backend.write32.assert_not_called()

    def test_fault_milestones_distinguish_native_hang(self):
        with tempfile.TemporaryDirectory() as directory:
            transport = ProcessTransport(HangingBackend, timeout=2, diagnostic_root=directory)
            try:
                with self.assertRaisesRegex(VolumeFault, "deadline"):
                    transport.call("read32", 0, deadline=time.monotonic() + 0.1)
                receipt = json.loads(next(pathlib.Path(directory).glob("transport-fault-*.json")).read_text())
                self.assertEqual(receipt["worker"]["request_id"], receipt["parent"]["request_id"])
                self.assertEqual(receipt["worker"]["phase"], 2)
                self.assertGreater(receipt["worker"]["native_begin_ns"], 0)
                self.assertEqual(receipt["worker"]["native_returned_ns"], 0)
                self.assertFalse(receipt["child_alive"])
            finally:
                transport.close()

    def test_fault_milestones_distinguish_parent_delayed_receive(self):
        with tempfile.TemporaryDirectory() as directory:
            stages = [{"stage": "channel_start_begin", "monotonic_ns": time.monotonic_ns()}]
            transport = ProcessTransport(FakeBackend, timeout=2, diagnostic_root=directory,
                                         diagnostic_context=stages)
            original = transport.connection
            wrapped = Mock(wraps=original)

            def delayed_receive():
                result = original.recv()
                time.sleep(0.2)
                return result

            wrapped.recv.side_effect = delayed_receive
            transport.connection = wrapped
            try:
                with self.assertRaisesRegex(VolumeFault, "deadline"):
                    transport.call("read32", 0, deadline=time.monotonic() + 0.1)
                receipt = json.loads(next(pathlib.Path(directory).glob("transport-fault-*.json")).read_text())
                self.assertEqual(receipt["worker"]["phase"], 5)
                self.assertEqual(receipt["vision_stages"], stages)
                self.assertLess(receipt["worker"]["reply_sent_ns"], receipt["parent"]["deadline_ns"])
                self.assertGreater(receipt["parent"]["received_ns"], receipt["parent"]["deadline_ns"])
                self.assertTrue(transport.failed)
                self.assertIsNone(transport.diagnostic_error)
            finally:
                transport.close()

    def ready(self):
        backend = FakeBackend()
        control = VolumeControl(backend, exclusive_owner=True)
        configure_codec(backend, stopped=True, straps_confirmed=True, mclk_hz=10_000_000)
        control.configure(quiet_sum=100, soft_sum=1000, loud_sum=4000, enable=True)
        return backend, control

    def test_profile_and_once_only(self):
        backend, _ = self.ready()
        self.assertEqual(backend.codec[0x4002], PLL)
        for register in (0x4011, 0x4014, 0x4015):
            self.assertEqual(backend.codec[register], b"\x00")
        self.assertTrue(backend.codec_configured)
        with self.assertRaises(VolumeFault):
            configure_codec(backend, stopped=True, straps_confirmed=True, mclk_hz=10_000_000)

    def test_thresholds_identity_and_enable_guard(self):
        for quiet, soft, loud in ((1, 1, 2), (0, 1, 1), (-1, 2, 3), (0, True, 3), (0, 2, 2**32)):
            with self.subTest(values=(quiet, soft, loud)), self.assertRaises(ValueError):
                self.ready()[1].configure(quiet_sum=quiet, soft_sum=soft, loud_sum=loud)
        backend = FakeBackend()
        with self.assertRaises(VolumeFault):
            VolumeControl(backend, exclusive_owner=True).configure(quiet_sum=0, soft_sum=1, loud_sum=2, enable=True)
        backend.registers[4] = 0xB0000001
        with self.assertRaises(VolumeFault):
            VolumeControl(backend, exclusive_owner=True)

    def test_codec_failure_is_once_only(self):
        for mode in ("unlocked", "short", "mismatch"):
            with self.subTest(mode=mode):
                backend = FakeBackend()
                original = backend.codec_read
                if mode == "unlocked":
                    backend.codec_read = lambda register, length: PLL if register == 0x4002 else original(register, length)
                if mode == "short":
                    backend.codec_read = lambda register, length: b""
                if mode == "mismatch":
                    backend.codec_read = lambda register, length: b"\xff" if register == 0x4015 else original(register, length)
                with self.assertRaises(VolumeFault):
                    configure_codec(backend, stopped=True, straps_confirmed=True, mclk_hz=10_000_000)
                self.assertFalse(backend.codec_configured)
                with self.assertRaises(VolumeFault):
                    configure_codec(backend, stopped=True, straps_confirmed=True, mclk_hz=10_000_000)

    def test_codec_preconditions_do_not_touch_transport(self):
        for stopped, straps, mclk in ((False, True, 10_000_000), (True, False, 10_000_000), (True, True, 12_000_000)):
            with self.subTest(values=(stopped, straps, mclk)), self.assertRaises(ValueError):
                configure_codec(FakeBackend(), stopped=stopped, straps_confirmed=straps, mclk_hz=mclk)

    def test_event_ack_and_replay(self):
        backend, control = self.ready()
        self.assertIsNone(control.event())
        backend.registers.update({0x10: 0x30B, 0x5C: 1, 0x60: 1, 0x64: 5, 0x68: 7816, 0x70: 8, 0x74: 100})
        event = control.event()
        self.assertEqual((event.kind, event.source_sample, event.source_window), ("SOFT", 7816, 8))
        control.acknowledge(event)
        with self.assertRaises(VolumeFault):
            control.acknowledge(event)
        control.configure(quiet_sum=100, soft_sum=1000, loud_sum=4000, enable=False)
        self.assertEqual(backend.registers[0x10], 8)

    def test_monitor_silence_level_and_fault(self):
        backend, control = self.ready()
        backend.registers.update({0x4C: 977, 0x54: 1, 0x58: 0, 0x78: 1000, 0x7C: 4000, 0x80: 100})
        snapshot = control.monitor()
        self.assertTrue(snapshot["snapshot_valid"])
        self.assertEqual(snapshot["mean_abs"], 0)
        self.assertEqual(snapshot["sample_count"], 977)
        backend.registers[0x58] = 9770
        self.assertEqual(control.monitor()["mean_abs"], 10)
        backend.registers[0x14] = 2
        snapshot = control.monitor()
        self.assertFalse(snapshot["snapshot_valid"])
        self.assertEqual(snapshot["faults"], 2)
        self.assertIsNone(snapshot["mean_abs"])

    def test_monitor_no_window_and_invalidated_snapshot(self):
        backend, control = self.ready()
        self.assertIsNone(control.monitor()["mean_abs"])
        backend.mutate = lambda offset: backend.registers.update({0x84: 0}) if offset == 0x80 else None
        with self.assertRaises(VolumeFault):
            control.monitor()
        backend, control = self.ready()
        backend.mutate = lambda offset: backend.registers.update({0x10: 1}) if offset == 0x80 else None
        with self.assertRaises(VolumeFault):
            control.monitor()

    def test_monitor_batches_round_trips_without_extending_deadline(self):
        backend, control = self.ready()
        backend.registers.update({0x4C: 977, 0x54: 1, 0x58: 9770})
        now, calls = [100.0], []
        original = backend.call

        def scheduled(operation, *arguments, deadline):
            now[0] += 0.004
            return original(operation, *arguments, deadline=deadline)

        backend.call = scheduled
        with patch("voice_volume_control.time.monotonic", side_effect=lambda: now[0]):
            with self.assertRaisesRegex(VolumeFault, "deadline"):
                control.monitor()

        def register_batch(operations, *, deadline):
            calls.append((operations, deadline))
            now[0] += 0.004
            return tuple(original(operation, *arguments, deadline=deadline)
                         for operation, arguments in operations)

        backend.register_batch = register_batch
        now[0] = 100.0
        with patch("voice_volume_control.time.monotonic", side_effect=lambda: now[0]):
            snapshot = control.monitor()
        self.assertEqual(snapshot["mean_abs"], 10)
        self.assertEqual(len(calls), 2)
        self.assertEqual([deadline for _, deadline in calls], [100.1, 100.1])
        self.assertAlmostEqual(now[0] - 100, 0.008)
        operations = [operation for batch, _ in calls for operation in batch]
        self.assertEqual(len(operations), 28)
        self.assertEqual(operations[3], ("write32", (0x30, 2)))
        self.assertEqual(operations[-2:], [("read32", (0x3C,)), ("read32", (0x84,))])

    def test_monitor_event_age_starts_at_snapshot_request(self):
        backend, control = self.ready()
        backend.registers.update({0x10: 0x30B, 0x5C: 1, 0x60: 1, 0x64: 5,
                                  0x68: 7816, 0x70: 8, 0x74: 4_000_000})
        clock = [100.0]

        def register_batch(operations, *, deadline):
            if len(operations) == 3:
                clock[0] += 0.02
            return _register_batch(backend, operations, deadline)

        backend.register_batch = register_batch
        with patch("voice_volume_control.time.monotonic", side_effect=lambda: clock[0]):
            control.monitor()
        self.assertAlmostEqual(control.offered.expires, 100.08)

    def test_direct_event_age_starts_at_snapshot_request(self):
        backend, control = self.ready()
        backend.registers.update({0x10: 0x30B, 0x5C: 1, 0x60: 1, 0x64: 5,
                                  0x68: 7816, 0x70: 8, 0x74: 4_000_000})
        clock = [100.0]
        original = backend.call

        def scheduled(operation, *arguments, deadline):
            if operation == "read32" and arguments == (0x18,) and clock[0] == 100.0:
                clock[0] += 0.02
            return original(operation, *arguments, deadline=deadline)

        backend.call = scheduled
        with patch("voice_volume_control.time.monotonic", side_effect=lambda: clock[0]):
            event = control.event()
        self.assertAlmostEqual(event.expires, 100.08)

    def test_batch_monitor_preserves_snapshot_invalidation(self):
        for register, value in ((0x84, 0), (0x3C, 99), (0x18, 0), (0x14, 8), (0x10, 1), (0x48, 99)):
            with self.subTest(register=register):
                backend, control = self.ready()
                backend.register_batch = partial(_register_batch, backend)
                trigger = 0x48 if register == 0x48 else 0x80
                backend.mutate = lambda offset: backend.registers.update({register: value}) if offset == trigger else None
                with self.assertRaisesRegex(VolumeFault, "invalidated"):
                    control.monitor()

    def test_batch_event_ack_preserves_time_for_next_game_sample(self):
        from pynq_multimodal_game.volume_input import VolumeEventLatch

        backend, control = self.ready()
        backend.registers.update({0x10: 0x30B, 0x5C: 1, 0x60: 1, 0x64: 6,
                                  0x68: 7816, 0x70: 8, 0x74: 4_000_000})
        clock, calls = [100.0], []
        original = backend.call

        def scheduled(operation, *arguments, deadline):
            calls.append((operation, arguments, deadline))
            clock[0] += 0.004
            return original(operation, *arguments, deadline=deadline)

        def register_batch(operations, *, deadline):
            calls.append(("register_batch", operations, deadline))
            clock[0] += 0.004
            return _register_batch(backend, operations, deadline)

        backend.call = scheduled
        setattr(backend, "register_batch", register_batch)
        latch = VolumeEventLatch(control, now=lambda: clock[0])
        with patch("voice_volume_control.time.monotonic", side_effect=lambda: clock[0]):
            self.assertTrue(latch.poll_once())
            pending = latch.status()["pending"]
            self.assertAlmostEqual(pending["expires"], 100.064)
            self.assertTrue(pending["hardware_acked"])
            clock[0] += 0.033418
            signal = latch.consume(58)
        assert signal is not None
        self.assertEqual(signal.kind, "LOUD")
        self.assertEqual(latch.status()["consumed"], 1)
        self.assertEqual(latch.status()["discarded"], 0)
        self.assertEqual(len(calls), 6)
        self.assertTrue(all(operation == "register_batch" for operation, _, _ in calls))

    def test_batch_ack_preserves_pre_and_post_live_guards(self):
        for phase in ("before", "after", "atomic-before", "atomic-after"):
            for mode in ("epoch", "fault", "ack_error", "clock", "pending"):
                with self.subTest(phase=phase, mode=mode):
                    backend, control = self.ready()
                    backend.registers.update({0x10: 0x30B, 0x5C: 1, 0x60: 1, 0x64: 6})
                    setattr(backend, "register_batch", partial(_register_batch, backend))
                    if phase.startswith("atomic"):
                        backend.acknowledge_event = partial(_acknowledge_event, backend)
                    control.monitor()
                    event = control.event()
                    original, writes = backend.write32, []

                    def invalidate():
                        if mode == "epoch": backend.registers[0x18] += 1
                        if mode == "fault": backend.registers[0x14] = 8
                        if mode == "ack_error": backend.registers[0x10] |= 16
                        if mode == "clock": backend.registers[0x10] &= ~8
                        if mode == "pending": backend.registers[0x10] ^= 2

                    def write32(offset, value):
                        writes.append((offset, value))
                        original(offset, value)
                        if (offset, value) == (0x30, 4):
                            invalidate()

                    backend.write32 = write32
                    if phase.endswith("before"):
                        invalidate()
                    with self.assertRaises(VolumeFault):
                        control.acknowledge(event)
                    self.assertEqual(writes, [] if phase.endswith("before") else
                                     [(0x34, 1), (0x38, 1), (0x30, 4)])
                    self.assertIs(control.offered, event)

    def test_batch_ack_keeps_original_absolute_deadline(self):
        backend, control = self.ready()
        backend.registers.update({0x10: 0x30B, 0x5C: 1, 0x60: 1, 0x64: 6})
        clock, batches = [100.0], []
        with patch("voice_volume_control.time.monotonic", side_effect=lambda: clock[0]):
            control.monitor()
            event = control.event()

            def register_batch(operations, *, deadline):
                batches.append(deadline)
                clock[0] += 0.004
                return _register_batch(backend, operations, deadline)

            setattr(backend, "register_batch", register_batch)
            clock[0] = event.expires - 0.01
            with self.assertRaisesRegex(VolumeFault, "deadline"):
                control.acknowledge(event)
        self.assertEqual(batches, [event.expires] * 3)
        self.assertIs(control.offered, event)

    def test_worker_ack_is_one_round_trip_with_original_deadline(self):
        transport = ProcessTransport(FakeBackend, timeout=2)
        try:
            transport.codec_configured = True
            control = VolumeControl(transport, exclusive_owner=True)
            control.configure(quiet_sum=100, soft_sum=1000, loud_sum=4000, enable=True)
            for offset, value in ((0x10, 0x30B), (0x5C, 1), (0x60, 1), (0x64, 5)):
                transport.call("write32", offset, value, deadline=time.monotonic() + 0.1)
            control.monitor()
            event = control.event()
            requests = transport.request_id
            control.acknowledge(event)
            self.assertEqual(transport.request_id - requests, 1)
            self.assertIsNone(control.offered)
            self.assertFalse(control.monitor()["event"])
            with self.assertRaises(VolumeFault):
                control.acknowledge(event)
        finally:
            transport.close()

    def test_worker_ack_rejects_identity_and_elapsed_deadline_before_writes(self):
        backend, control = self.ready()
        backend.registers.update({0x10: 0x30B, 0x5C: 1, 0x60: 1, 0x64: 5})
        for epoch, sequence in ((True, 1), (1, 0), (1, 2**32)):
            with self.subTest(epoch=epoch, sequence=sequence), self.assertRaises(VolumeFault):
                _acknowledge_event(backend, epoch, sequence, time.monotonic() + 0.1)
        clock = [100.0]
        original = backend.read32

        def read32(offset):
            clock[0] += 0.004
            return original(offset)

        backend.read32 = read32
        with patch("voice_volume_control.time.monotonic", side_effect=lambda: clock[0]):
            with self.assertRaisesRegex(VolumeFault, "deadline"):
                _acknowledge_event(backend, 1, 1, 100.01)
        self.assertNotIn(0x34, backend.registers)

    def test_batch_rejects_invalid_operations_before_any_mmio(self):
        for operation in (("codec_read", (0,)), ("read32", (True,)), ("read32", (1,)),
                          ("read32", (4096,)), ("write32", (0, True)), ("write32", (0, 2**32)),
                          ("read32", ()), ("read32", [0])):
            with self.subTest(operation=operation):
                backend = Mock()
                with self.assertRaises(VolumeFault):
                    _register_batch(backend, (("write32", (0x30, 2)), operation), time.monotonic() + 0.1)
                self.assertEqual(backend.mock_calls, [])
        for operations in ((), [("read32", (0,))], (("read32", (0,)),) * 33):
            with self.subTest(operations=operations), self.assertRaises(VolumeFault):
                _register_batch(Mock(), operations, time.monotonic() + 0.1)
        with self.assertRaisesRegex(VolumeFault, "deadline"):
            _register_batch(Mock(), (("read32", (0,)),), time.monotonic() - 0.1)

    def test_monitor_publisher_actual_control_local_ack(self):
        backend, control = self.ready()
        backend.registers.update({0x10: 0x30B, 0x4C: 7816, 0x54: 8, 0x58: 9770,
                                  0x5C: 1, 0x60: 1, 0x64: 5, 0x68: 7816, 0x70: 8, 0x74: 100})
        publisher = VolumeStatusPublisher.from_control(control)
        publisher.sample_once()
        status = publisher.status()
        self.assertIsNone(status["error"])
        self.assertEqual(status["snapshot"]["mean_abs"], 10)
        self.assertEqual(status["recent_events"][0]["kind"], "SOFT")
        self.assertFalse(backend.registers[0x10] & 2)
        publisher.sample_once()
        self.assertIsNone(publisher.status()["snapshot"]["event"])
        self.assertEqual(len(publisher.status()["recent_events"]), 1)

    def test_late_monitor_event_is_acked_without_second_full_snapshot(self):
        backend, control = self.ready()
        backend.registers.update({0x10: 0x30B, 0x4C: 7816, 0x54: 8, 0x58: 9770,
                                  0x5C: 1, 0x60: 1, 0x64: 5, 0x68: 7816, 0x70: 8})
        clock, captures = [0.057], []
        original = backend.call

        def delayed(operation, *arguments, deadline):
            clock[0] += 0.0009
            if clock[0] >= 0.1 and backend.registers[0x10] & 2:
                backend.registers[0x14] = 8
            if operation == "write32" and arguments == (0x30, 2):
                captures.append(clock[0])
                backend.registers[0x74] = round(clock[0] * 100_000_000)
            return original(operation, *arguments, deadline=deadline)

        backend.call = delayed
        publisher = VolumeStatusPublisher.from_control(control)
        with patch("voice_volume_control.time.monotonic", side_effect=lambda: clock[0]):
            publisher.sample_once()
        self.assertIsNone(publisher.status()["error"])
        self.assertEqual(len(captures), 1)
        self.assertFalse(backend.registers[0x10] & 2)
        self.assertLess(clock[0], 0.1)

    def test_monitored_offer_still_rejects_fault_reset_loss_and_expiry(self):
        for mode in ("fault", "reset", "lost", "expired"):
            with self.subTest(mode=mode):
                backend, control = self.ready()
                backend.registers.update({0x10: 0x30B, 0x5C: 1, 0x60: 1, 0x64: 5, 0x74: 100})
                control.monitor()
                self.assertIsNotNone(control.offered)
                if mode == "fault": backend.registers[0x14] = 8
                if mode == "reset": backend.registers[0x18] = 0
                if mode == "lost": backend.registers[0x10] &= ~2
                if mode == "expired":
                    with patch("voice_volume_control.time.monotonic", return_value=control.offered.expires):
                        with self.assertRaises(VolumeFault):
                            control.event()
                else:
                    with self.assertRaises(VolumeFault):
                        control.event()

    def test_fault_epoch_snapshot_and_expiry(self):
        for mode in ("fault", "reset", "age", "snapshot", "invalid_kind"):
            with self.subTest(mode=mode):
                backend, control = self.ready()
                backend.registers.update({0x10: 0x30B, 0x5C: 1, 0x60: 1, 0x64: 5})
                if mode == "fault": backend.registers[0x14] = 2
                if mode == "reset": backend.registers[0x18] = 0
                if mode == "age": backend.registers[0x74] = 10_000_000
                if mode == "invalid_kind": backend.registers[0x64] = 7
                if mode == "snapshot":
                    backend.mutate = lambda offset: backend.registers.update({0x84: 0}) if offset == 0x80 else None
                with self.assertRaises(VolumeFault):
                    control.event()

    def test_real_spawn_transport(self):
        transport = ProcessTransport(FakeBackend, timeout=2)
        try:
            control = VolumeControl(transport, exclusive_owner=True)
            configure_codec(transport, stopped=True, straps_confirmed=True, mclk_hz=10_000_000)
            control.configure(quiet_sum=0, soft_sum=100, loud_sum=1000, enable=True)
            self.assertIsNone(control.event())
            request_id = transport.request_id
            self.assertTrue(control.monitor()["snapshot_valid"])
            self.assertEqual(transport.request_id - request_id, 2)
            transport.register_batch(tuple(("write32", (offset, value)) for offset, value in
                                 ((0x10, 0x30B), (0x5C, 1), (0x60, 1), (0x64, 6))),
                             deadline=time.monotonic() + 0.5)
            control.monitor()
            request_id = transport.request_id
            event = control.event()
            control.acknowledge(event)
            self.assertEqual(transport.request_id - request_id, 2)
            self.assertIsNone(control.offered)
        finally:
            transport.close()
        self.assertFalse(transport.process.is_alive())

    def test_native_hang_is_bounded(self):
        transport = ProcessTransport(HangingBackend, timeout=2)
        started = time.monotonic()
        try:
            with self.assertRaisesRegex(VolumeFault, "deadline"):
                transport.call("read32", 0, deadline=started + 0.05)
            self.assertLess(time.monotonic() - started, 1.0)
            self.assertTrue(transport.failed)
            self.assertFalse(transport.process.is_alive())
        finally:
            transport.close()

    def test_batch_native_hang_is_bounded_and_quarantined(self):
        for offset in (0x30, 0x34, 0x38):
            with self.subTest(offset=offset):
                transport = ProcessTransport(partial(WriteHangingBackend, offset), timeout=2)
                started = time.monotonic()
                try:
                    with self.assertRaisesRegex(VolumeFault, "deadline"):
                        transport.register_batch((("write32", (offset, 1)), ("read32", (0x84,))),
                                                 deadline=started + 0.05)
                    self.assertLess(time.monotonic() - started, 1.0)
                    self.assertTrue(transport.failed)
                    self.assertFalse(transport.process.is_alive())
                finally:
                    transport.close()

    def test_each_config_write_hang_is_traced_and_quarantined(self):
        offsets = [0x20, 0x24, 0x28, 0x2C, 0x30]
        for fault_index, offset in enumerate(offsets):
            with self.subTest(offset=offset), tempfile.TemporaryDirectory() as directory:
                transport = ProcessTransport(partial(WriteHangingBackend, offset), timeout=2, trace_root=directory)
                try:
                    control = VolumeControl(transport, exclusive_owner=True)
                    started = time.monotonic()
                    with self.assertRaisesRegex(VolumeFault, "deadline"):
                        control.configure(quiet_sum=0, soft_sum=100, loud_sum=1000)
                    self.assertLess(time.monotonic() - started, 1.2)
                    self.assertTrue(transport.failed)
                    self.assertFalse(transport.process.is_alive())
                    with self.assertRaisesRegex(VolumeFault, "quarantined"):
                        transport.call("codec_read", 0x4000, 1, deadline=time.monotonic() + 0.1)
                finally:
                    transport.close()
                worker = [json.loads(line) for line in (pathlib.Path(directory) / "transport-worker.jsonl").read_text().splitlines()]
                writes = [entry for entry in worker if entry["phase"] == "native_begin" and entry["operation"] == "write32"]
                self.assertEqual([entry["offset"] for entry in writes], offsets[:fault_index + 1])
                request_id = writes[-1]["request_id"]
                self.assertFalse(any(entry["phase"] in ("native_returned", "reply_sent") and entry.get("request_id") == request_id for entry in worker))
                self.assertFalse(any(entry.get("operation", "").startswith("codec") for entry in worker))
                parent = [json.loads(line) for line in (pathlib.Path(directory) / "transport-parent.jsonl").read_text().splitlines()]
                self.assertTrue(any(entry["phase"] == "parent_sent" and entry["request_id"] == request_id for entry in parent))
                self.assertEqual(parent[-1]["phase"], "quarantined")

    def test_reply_failure_is_distinct_from_native_hang(self):
        with tempfile.TemporaryDirectory() as directory:
            backend = Mock()
            connection = Mock()
            connection.recv.return_value = ("write32", (0x30, 1))
            connection.send.side_effect = [None, OSError("injected reply failure"), OSError("closed")]
            _serve(connection, lambda: backend, directory)
            backend.write32.assert_called_once_with(0x30, 1)
            entries = [json.loads(line) for line in (pathlib.Path(directory) / "transport-worker.jsonl").read_text().splitlines()]
            phases = [entry["phase"] for entry in entries]
            self.assertIn("native_returned", phases)
            self.assertIn("reply_begin", phases)
            self.assertNotIn("reply_sent", phases)
            self.assertEqual(phases[-1], "worker_error")
            connection.close.assert_called_once_with()

    def test_send_time_is_charged_to_deadline(self):
        transport = ProcessTransport(FakeBackend, timeout=2)
        try:
            with patch.object(transport.connection, "send"), patch.object(transport.connection, "poll") as poll, \
                    patch("voice_volume_control.time") as clock:
                clock.monotonic.side_effect = [100.0, 100.01, 100.6, 100.6, 100.6]
                with self.assertRaisesRegex(VolumeFault, "deadline"):
                    transport.call("write32", 0x30, 1, deadline=100.5)
                poll.assert_not_called()
            self.assertTrue(transport.failed)
            self.assertFalse(transport.process.is_alive())
        finally:
            transport.close()

    def test_trace_is_bounded_optional_and_stops(self):
        with tempfile.TemporaryDirectory() as directory:
            trace = _StartupTrace(directory, "bounded")
            for index in range(600):
                trace.record("probe", request_id=index)
            self.assertEqual(len(trace.path.read_text().splitlines()), 512)
            trace = _StartupTrace(pathlib.Path(directory) / "missing", "failure")
            trace.record("probe")
            self.assertIsNotNone(trace.error)
            transport = ProcessTransport(FakeBackend, timeout=2, trace_root=directory)
            try:
                self.assertEqual(transport.call("read32", 0, deadline=time.monotonic() + 0.5), MAGIC)
                transport.stop_trace()
                paths = [pathlib.Path(directory) / f"transport-{role}.jsonl" for role in ("parent", "worker")]
                before = [path.read_bytes() for path in paths]
                self.assertEqual(transport.call("read32", 4, deadline=time.monotonic() + 0.5), BUILD_ID)
                self.assertEqual([path.read_bytes() for path in paths], before)
            finally:
                transport.close()
        transport = ProcessTransport(FakeBackend, timeout=2)
        try:
            self.assertIsNone(transport.trace)
            transport.stop_trace()
            self.assertEqual(transport.request_id, 0)
        finally:
            transport.close()

    def test_request_not_received_and_reply_hang_are_distinct(self):
        for received in (False, True):
            with self.subTest(received=received), tempfile.TemporaryDirectory() as directory:
                transport = ProcessTransport(ReplyHangingBackend, timeout=2, trace_root=directory)
                try:
                    with patch.object(transport.connection, "send", wraps=transport.connection.send if received else None):
                        with self.assertRaisesRegex(VolumeFault, "deadline"):
                            transport.call("write32", 0x30, 1, deadline=time.monotonic() + 0.1)
                    self.assertTrue(transport.failed)
                    self.assertFalse(transport.process.is_alive())
                finally:
                    transport.close()
                entries = [json.loads(line) for line in (pathlib.Path(directory) / "transport-worker.jsonl").read_text().splitlines()]
                phases = [entry["phase"] for entry in entries]
                self.assertEqual("child_received" in phases, received)
                self.assertEqual("native_returned" in phases, received)
                self.assertEqual("reply_begin" in phases, received)
                self.assertNotIn("reply_sent", phases)

    def test_config_writes_share_one_deadline(self):
        transport = ProcessTransport(FakeBackend, timeout=2)
        backend = FakeBackend()
        control = VolumeControl(transport, exclusive_owner=True)
        now = [100.0]
        reply = [None]
        writes = []
        def dispatch(message):
            operation, arguments = message
            reply[0] = (_register_batch(backend, *arguments) if operation == "register_batch"
                        else getattr(backend, operation)(*arguments))
            if operation == "write32":
                writes.append(arguments[0])
                now[0] += 0.11
        try:
            with patch.object(transport.connection, "send", side_effect=dispatch), \
                    patch.object(transport.connection, "poll", return_value=True), \
                    patch.object(transport.connection, "recv", side_effect=lambda: (True, reply[0])), \
                    patch("voice_volume_control.time") as clock:
                clock.monotonic.side_effect = lambda: now[0]
                with self.assertRaisesRegex(VolumeFault, "deadline"):
                    control.configure(quiet_sum=0, soft_sum=100, loud_sum=1000)
            self.assertEqual(writes, [0x20, 0x24, 0x28, 0x2C, 0x30])
            self.assertTrue(transport.failed)
            self.assertIsNone(control.epoch)
            self.assertFalse(backend.codec)
        finally:
            transport.close()


if __name__ == "__main__":
    unittest.main(verbosity=2)