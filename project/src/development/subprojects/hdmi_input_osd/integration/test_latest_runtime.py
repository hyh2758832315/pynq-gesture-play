"""Use the actual R19 worker, processing path, provider and HTTP age semantics."""
import importlib.util
import json
from pathlib import Path
import sys
import threading
import time
from types import SimpleNamespace
import unittest
from unittest.mock import patch
import urllib.request

import numpy as np

ROOT = Path(__file__).resolve().parents[3] / 'deliveries/c6i-pl-vision-volume-osd-r19-latest-20261023'
sys.path.insert(0, str(ROOT / 'board/pynq_z2/scripts'))
sys.path.insert(0, str(ROOT / 'python'))
sys.path.insert(0, str(ROOT))
import vision_async_runtime as runtime
from board.pynq_z2.vision_latest_capture import LatestCaptureHardware
from pynq_multimodal_game.vision_input import VisionInputProvider
from test_latest_capture import Frame, ThreeSlotHardware, wait_for

assert runtime.PROJECT_ROOT == ROOT


class Provider:
    def __init__(self):
        self.packets = []
    def publish(self, packet, **_):
        self.packets.append(packet)
    def release(self, _):
        pass
    def suspend(self):
        pass


def controller():
    return SimpleNamespace(update=lambda result, number, now: dict(
        schema='gesture-control-v1', frame_id=number, action_event_seq=0,
        valid=False, direction='NONE'))


class LatestRuntimeTests(unittest.TestCase):
    def test_real_worker_slow_recognition_and_pause_do_not_pause_capture(self):
        hardware = ThreeSlotHardware()
        adapter = LatestCaptureHardware(hardware)
        provider = Provider()
        worker = runtime.SharedDualMaskWorker(adapter, SimpleNamespace(), controller(), provider, run_id='latest')
        worker.capture_validator = adapter.accept_delivery
        entered, finish = threading.Event(), threading.Event()
        def processor(frame, recognizer, *args, on_result, **kwargs):
            if frame.frame_id == 1:
                entered.set()
                self.assertTrue(finish.wait(2.))
            result = dict(stable='NO_HAND', rps='UNKNOWN', timing_ms={})
            on_result(result)
            return None, result
        worker.frame_processor = processor
        worker.start()
        wait_for(lambda: adapter.state == 'RUNNING')
        hardware.produce()
        self.assertTrue(entered.wait(1.))
        for number in range(2, 41):
            hardware.produce()
            wait_for(lambda: adapter.snapshot()['captured'] == number)
        self.assertEqual(worker.frame_id, 1)
        worker._processing_pause.set()
        worker._processing_resume.clear()
        finish.set()
        self.assertTrue(worker._processing_paused.wait(1.))
        for number in range(41, 81):
            hardware.produce()
            wait_for(lambda: adapter.snapshot()['captured'] == number)
        self.assertEqual(len(provider.packets), 1)
        worker.resume_processing()
        wait_for(lambda: len(provider.packets) == 2)
        self.assertEqual(provider.packets[1]['frame'], 2)
        self.assertEqual(provider.packets[1]['control']['frame_id'], 2)
        self.assertEqual(provider.packets[1]['capture']['source_frame_id'], 80)
        self.assertGreaterEqual(provider.packets[0]['server_age_ms'], 10.)
        errors = []
        def stop():
            try:
                worker.stop()
            except BaseException as error:
                errors.append(error)
        stopper = threading.Thread(target=stop)
        stopper.start()
        deadline = time.monotonic() + 2.
        while stopper.is_alive() and time.monotonic() < deadline:
            hardware.produce()
            time.sleep(.01)
        stopper.join(.5)
        self.assertFalse(stopper.is_alive())
        self.assertEqual(errors, [])
        self.assertIsNone(worker.error)
        self.assertEqual(worker.state, 'STOPPED')

    def test_real_dual_mask_processor_accepts_readonly_latest_snapshot(self):
        hardware = ThreeSlotHardware()
        adapter = LatestCaptureHardware(hardware)
        adapter.start()
        raw = np.zeros((360, 640), np.uint8)
        hardware.frames.put(Frame(1, raw=raw, filtered=raw.copy()))
        provider = VisionInputProvider()
        from gesture_control import GestureControl
        worker = runtime.SharedDualMaskWorker(adapter, runtime.DualMaskFullFrameTracker(dilate_iterations=4),
                                               GestureControl(), provider, run_id='numeric')
        worker.capture_validator = adapter.accept_delivery
        observations = []
        worker.osd_observer = lambda *args, **kwargs: observations.append(kwargs)
        worker.step()
        adapter._stop_requested.set()
        hardware.next_id = 2
        hardware.produce()
        wait_for(lambda: adapter.state == 'STOPPED')
        adapter.stop()
        self.assertEqual(worker.frame_id, 1)
        self.assertEqual(provider.receipt.result.frame_id, 1)
        self.assertLess(observations[0]['observed_ns'], time.monotonic_ns())
        self.assertFalse(raw.flags.writeable)

    def test_legacy_direct_worker_keeps_consecutive_frame_guard(self):
        worker = runtime.SharedDualMaskWorker(SimpleNamespace(), SimpleNamespace(), controller(), Provider(), run_id='legacy')
        self.assertIsNone(worker.capture_validator)
        with self.assertRaisesRegex(RuntimeError, 'not consecutive'):
            worker._process_frame(Frame(7))

    def test_http_age_keeps_capture_to_recognition_age(self):
        preview = runtime.BytesPreview('127.0.0.1', 0)
        try:
            preview.publish_result(json.dumps(dict(frame=1, server_age_ms=125.)).encode())
            port = preview.server.server_address[1]
            with urllib.request.urlopen(f'http://127.0.0.1:{port}/result.json', timeout=2.) as response:
                packet = json.load(response)
            self.assertGreaterEqual(packet['server_age_ms'], 125.)
            self.assertLess(packet['server_age_ms'], 500.)
        finally:
            preview.close()

    def test_factory_installs_adapter_and_exact_delivery_validator(self):
        from pynq_multimodal_game.agent import pl_volume_factory
        underlying = ThreeSlotHardware()
        tracker = SimpleNamespace(lower=(0, 20, 70), upper=(20, 255, 255))
        fake_runtime = SimpleNamespace(SharedDualMaskHardware=lambda *args, **kwargs: underlying,
            DualMaskFullFrameTracker=lambda **kwargs: tracker,
            SharedDualMaskWorker=runtime.SharedDualMaskWorker, BytesPreview=runtime.BytesPreview)
        args = SimpleNamespace(vision_bind='127.0.0.1', vision_port=0, vision_preview_fps=10.,
                               vision_debug_fps=5., vision_output_dir=Path('/uncreated'))
        hub = SimpleNamespace(publish=lambda *args, **kwargs: None)
        with patch.dict(sys.modules, gesture_control=SimpleNamespace(GestureControl=controller)):
            worker = pl_volume_factory.create_worker(SimpleNamespace(build_id=0xC0060E00, is_open=True),
                Provider(), hub, args, 'factory', fake_runtime, None, None)
        self.assertIsInstance(worker.hardware, LatestCaptureHardware)
        self.assertIs(worker.hardware._hardware, underlying)
        self.assertEqual(worker.capture_validator, worker.hardware.accept_delivery)
        self.assertEqual(worker.osd_observer, hub.publish)
        self.assertIsNone(worker.hardware._thread)


if __name__ == '__main__':
    unittest.main()
