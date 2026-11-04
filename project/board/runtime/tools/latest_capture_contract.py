"""PC-only bounded capture/recognition lifecycle tests; no hardware imports."""
import asyncio
from dataclasses import dataclass, replace
import importlib.util
from pathlib import Path
import queue
import threading
import time
import unittest

import numpy as np

SOURCE = Path(__file__).resolve().parents[1] / 'board/pynq_z2/vision_latest_capture.py'
SPEC = importlib.util.spec_from_file_location('latest_capture_test_source', SOURCE)
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)
LatestCaptureHardware = MODULE.LatestCaptureHardware


@dataclass(frozen=True)
class Frame:
    frame_id: int
    epoch: int = 7
    config_id: int = 1
    thresholds: tuple = (0, 20, 20, 255, 70, 255)
    raw: object = None
    filtered: object = None
    rgb: bytes | None = None


class ThreeSlotHardware:
    epoch, config_id, thresholds = 7, 1, (0, 20, 20, 255, 70, 255)
    timeout = 1.
    skin = None

    def __init__(self):
        self.frames = queue.Queue(3)
        self.state = 'IDLE'
        self.calls = []
        self.next_id = 1
        self.drain_consumer = self.preview_demand = None
        self.stop_frames = []
        self.released = 0
        self.rgb_copies = 0
        self.read_entered = threading.Event()
        self.hold_read = threading.Event()
        self.hold_read.set()
        self.stop_error = None
        self.start_error = None

    def produce(self, **changes):
        frame = Frame(self.next_id, raw=np.zeros((2, 2), np.uint8),
                      filtered=np.ones((2, 2), np.uint8))
        self.next_id += 1
        self.frames.put_nowait(replace(frame, **changes))

    def start(self):
        self.calls.append(('start', threading.get_ident()))
        asyncio.get_event_loop()  # The real PYNQ borrower requires a thread loop.
        if self.start_error:
            raise self.start_error
        self.state = 'RUNNING'

    def read(self):
        self.calls.append(('read', threading.get_ident()))
        self.read_entered.set()
        if not self.hold_read.wait(2.):
            raise TimeoutError('test harness read hold')
        frame = self.frames.get(timeout=self.timeout)
        if isinstance(frame, BaseException):
            self.state = 'RETAINED'
            raise frame
        if self.preview_demand and self.preview_demand():
            self.rgb_copies += 1
            frame = replace(frame, rgb=b'owned RGB bytes')
        self.released += 1
        return frame

    def stop(self):
        self.calls.append(('stop', threading.get_ident()))
        if self.stop_error:
            raise self.stop_error
        for frame in self.stop_frames:
            self.drain_consumer(frame)
        self.state = 'STOPPED'


def wait_for(predicate, timeout=2.):
    deadline = time.monotonic() + timeout
    while not predicate():
        if time.monotonic() >= deadline:
            raise AssertionError('test condition did not become true')
        time.sleep(.001)


class LatestCaptureTests(unittest.TestCase):
    def make(self):
        hardware = ThreeSlotHardware()
        adapter = LatestCaptureHardware(hardware)
        adapter.start()
        return hardware, adapter

    def clean_stop(self, hardware, adapter):
        # Wake the currently blocking hardware.read after requesting normal STOP.
        # No reset/free is simulated: the capture thread must call borrower.stop.
        thread = threading.Thread(target=adapter.stop)
        thread.start()
        wait_for(adapter._stop_requested.is_set)
        hardware.produce()
        thread.join(2.)
        self.assertFalse(thread.is_alive())
        self.assertEqual(adapter.state, 'STOPPED')

    def test_serial_consumer_reproduces_three_slot_overflow(self):
        hardware = ThreeSlotHardware()
        # Baseline: release frame 1, then block in recognition. Three arrivals
        # fill the ring and the fourth has no slot regardless of GPU activity.
        hardware.produce()
        hardware.read()
        for _ in range(3):
            hardware.produce()
        with self.assertRaises(queue.Full):
            hardware.produce()
        self.assertEqual(hardware.released, 1)

    def test_paused_consumer_drains_all_frames_and_keeps_latest_only(self):
        hardware, adapter = self.make()
        for number in range(1, 41):
            hardware.produce()
            wait_for(lambda: adapter.snapshot()['captured'] == number)
        self.assertEqual(hardware.released, 40)
        self.assertEqual(adapter.snapshot()['pending'], 1)
        frame = adapter.read()
        metadata = adapter.accept_delivery(frame)
        self.assertEqual(frame.frame_id, 40)
        self.assertEqual(metadata['replaced'], 39)
        self.assertEqual(metadata['delivered'], 1)
        self.assertFalse(frame.raw.flags.writeable)
        self.assertFalse(frame.filtered.flags.writeable)
        self.assertEqual(hardware.rgb_copies, 0)
        self.clean_stop(hardware, adapter)
        adapter.stop()  # idempotent, no second hardware stop
        self.assertEqual(sum(name == 'stop' for name, _ in hardware.calls), 1)
        self.assertEqual(len({ident for _, ident in hardware.calls}), 1)
        self.assertNotEqual(hardware.calls[0][1], threading.get_ident())

    def test_every_overwritten_frame_still_checks_sequence_and_context(self):
        for changes in ({'frame_id': 3}, {'epoch': 8}, {'config_id': 2},
                        {'thresholds': (0, 21, 20, 255, 70, 255)}):
            with self.subTest(changes=changes):
                hardware, adapter = self.make()
                hardware.produce()
                wait_for(lambda: adapter.snapshot()['captured'] == 1)
                hardware.produce(**changes)
                wait_for(lambda: adapter.state == 'RETAINED')
                with self.assertRaises(RuntimeError):
                    adapter.read()
                with self.assertRaises(RuntimeError):
                    adapter.stop()
                self.assertFalse(any(name == 'stop' for name, _ in hardware.calls))

    def test_delivery_rejects_reuse_forgery_and_unvalidated_next_read(self):
        hardware, adapter = self.make()
        hardware.produce()
        frame = adapter.read()
        with self.assertRaises(RuntimeError):
            adapter.read()
        with self.assertRaises(RuntimeError):
            adapter.accept_delivery(replace(frame))
        adapter.accept_delivery(frame)
        with self.assertRaises(RuntimeError):
            adapter.accept_delivery(frame)
        self.clean_stop(hardware, adapter)

    def test_rgb_requested_only_while_consumer_waits_for_rgb_snapshot(self):
        hardware, adapter = self.make()
        hardware.produce()
        wait_for(lambda: adapter.snapshot()['captured'] == 1)
        adapter.preview_demand = lambda: True
        delivered = []
        def consume():
            frame = adapter.read()
            delivered.append((frame, adapter.accept_delivery(frame)))
        consumer = threading.Thread(target=consume)
        consumer.start()
        wait_for(adapter._rgb_requested.is_set)
        hardware.produce()
        consumer.join(2.)
        self.assertFalse(consumer.is_alive())
        self.assertIsNotNone(delivered[0][0].rgb)
        self.assertFalse(adapter._rgb_requested.is_set())
        for number in range(3, 8):
            hardware.produce()
            wait_for(lambda: adapter.snapshot()['captured'] == number)
        self.assertEqual(hardware.rgb_copies, 1)
        self.clean_stop(hardware, adapter)

    def test_stop_drain_checks_identity_without_recognition(self):
        hardware, adapter = self.make()
        adapter.drain_consumer = lambda frame: self.fail('recognition must not run during drain')
        hardware.stop_frames = [Frame(2), Frame(3)]
        self.clean_stop(hardware, adapter)
        self.assertEqual(adapter.snapshot()['drained'], 2)
        self.assertEqual(adapter.snapshot()['last_capture_id'], 3)

    def test_stop_drain_bad_identity_retains(self):
        hardware, adapter = self.make()
        hardware.stop_frames = [Frame(3)]
        adapter._stop_requested.set()
        hardware.produce()
        wait_for(lambda: adapter.state == 'RETAINED')
        with self.assertRaisesRegex(RuntimeError, 'not consecutive'):
            adapter.stop()

    def test_read_and_stop_failures_never_report_clean(self):
        hardware, adapter = self.make()
        hardware.frames.put(RuntimeError('DMA fault'))
        wait_for(lambda: adapter.state == 'RETAINED')
        with self.assertRaisesRegex(RuntimeError, 'DMA fault'):
            adapter.stop()
        self.assertFalse(any(name == 'stop' for name, _ in hardware.calls))
        hardware, adapter = self.make()
        hardware.stop_error = RuntimeError('seal not confirmed')
        adapter._stop_requested.set()
        hardware.produce()
        wait_for(lambda: adapter.state == 'RETAINED')
        with self.assertRaisesRegex(RuntimeError, 'seal not confirmed'):
            adapter.stop()

    def test_start_failure_and_restart_are_rejected(self):
        hardware = ThreeSlotHardware()
        hardware.start_error = RuntimeError('ARM rejected')
        adapter = LatestCaptureHardware(hardware)
        with self.assertRaisesRegex(RuntimeError, 'ARM rejected'):
            adapter.start()
        with self.assertRaises(RuntimeError):
            adapter.start()
        with self.assertRaises(RuntimeError):
            adapter.stop()
        self.assertEqual(adapter.state, 'RETAINED')

    def test_join_timeout_preserves_live_owner_until_normal_stop_finishes(self):
        hardware = ThreeSlotHardware()
        hardware.hold_read.clear()
        adapter = LatestCaptureHardware(hardware, stop_timeout=.01)
        adapter.start()
        self.assertTrue(hardware.read_entered.wait(1.))
        with self.assertRaises(TimeoutError):
            adapter.stop()
        self.assertTrue(adapter._thread.is_alive())
        self.assertNotEqual(adapter.state, 'STOPPED')
        hardware.produce()
        hardware.hold_read.set()
        wait_for(lambda: adapter.state == 'STOPPED')
        adapter.stop()


if __name__ == '__main__':
    unittest.main()
