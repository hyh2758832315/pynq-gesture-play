"""A preview request must never hold already-ready recognition masks."""
import importlib.util
from pathlib import Path
import threading
import time
import pytest

def load(path,name):
    import sys
    spec=importlib.util.spec_from_file_location(name,path)
    module=importlib.util.module_from_spec(spec);sys.modules[name]=module;spec.loader.exec_module(module)
    return module

ROOT=Path(__file__).resolve().parents[2]
helper=load(ROOT/'subprojects/hdmi_input_osd/integration/test_latest_capture.py','r27_capture_test_helper')
candidate=load(Path(__file__).parent/'board/pynq_z2/vision_latest_capture.py','r27_capture_preview')

def test_preview_demand_returns_ready_masks_before_any_rgb_arrival():
    hardware=helper.ThreeSlotHardware();adapter=candidate.LatestCaptureHardware(hardware)
    adapter.start();delivered=[]
    try:
        hardware.produce();helper.wait_for(lambda:adapter.snapshot()['captured']==1)
        adapter.preview_demand=lambda:True
        def consume():
            frame=adapter.read();delivered.append(frame);adapter.accept_delivery(frame)
        reader=threading.Thread(target=consume);reader.start();reader.join(.1)
        blocked=reader.is_alive()
        # Wake the old implementation too, preserving cleanup on the failure.
        if blocked:hardware.produce();reader.join(2)
        assert not blocked,'recognition waited for preview RGB despite ready mask frame'
        assert delivered[0].frame_id==1 and delivered[0].rgb is None
    finally:
        stop=threading.Thread(target=adapter.stop);stop.start()
        helper.wait_for(adapter._stop_requested.is_set);hardware.produce();stop.join(2)
        assert not stop.is_alive()


def test_rgb_is_requested_asynchronously_and_consumed_at_most_once():
    hardware=helper.ThreeSlotHardware();adapter=candidate.LatestCaptureHardware(hardware)
    adapter.start()
    try:
        hardware.produce();helper.wait_for(lambda:adapter.snapshot()['captured']==1)
        adapter.preview_demand=lambda:True
        frame=adapter.read();adapter.accept_delivery(frame)
        assert frame.frame_id==1 and frame.rgb is None
        assert adapter._rgb_requested.is_set()
        hardware.produce();helper.wait_for(lambda:adapter.snapshot()['captured']==2)
        assert not adapter._rgb_requested.is_set()
        adapter.preview_demand=lambda:False
        frame=adapter.read();adapter.accept_delivery(frame)
        assert frame.frame_id==2 and frame.rgb is not None
        hardware.produce();helper.wait_for(lambda:adapter.snapshot()['captured']==3)
        frame=adapter.read();adapter.accept_delivery(frame)
        assert frame.rgb is None and hardware.rgb_copies==1
    finally:
        stop=threading.Thread(target=adapter.stop);stop.start()
        helper.wait_for(adapter._stop_requested.is_set);hardware.produce();stop.join(2)
        assert not stop.is_alive()


class TestCandidateCaptureLifecycle(helper.LatestCaptureTests):
    """Run the original ownership/STOP/fault suite against the changed adapter."""
    def make(self):
        hardware=helper.ThreeSlotHardware();adapter=candidate.LatestCaptureHardware(hardware)
        adapter.start();return hardware,adapter

    def test_rgb_requested_only_while_consumer_waits_for_rgb_snapshot(self):
        # The old mandatory-RGB wait is deliberately replaced by optional RGB.
        test_rgb_is_requested_asynchronously_and_consumed_at_most_once()
