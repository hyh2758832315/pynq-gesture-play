"""Production controller/SDK packets with a held release; never open real serial."""
import importlib.util
import os
from pathlib import Path
import threading
import time
from unittest.mock import patch
import pytest
from memory_hand import MemoryHand
from pynq_usb_hand.orca_backend import OrcaModel
from pynq_usb_hand.motion import MotionSettings

ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('pynq_usb_hand.pause_controller',
    ROOT/'subprojects/ps_ui_r23b2/hand_overrides/controller.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)


def test_page_off_followed_by_video_pause_during_release_preserves_owner():
    with patch('serial.Serial.open',side_effect=AssertionError('REAL_SERIAL_FORBIDDEN')):
        backend=MemoryHand(OrcaModel(Path(os.environ.get('HAND_CANDIDATE_ROOT',ROOT/'build/hand-boundary-r15b'))))
        releasing=threading.Event();finish=threading.Event();calls=[]
        original=backend.release
        def release():
            calls.append(1);releasing.set()
            assert finish.wait(2)
            return original()
        backend.release=release
        c=module.Controller(lambda:backend,lease_seconds=5,preview_interlock=True,
            settings=MotionSettings.fixed_playback(stage_waits=(.1,)*3),approval_seconds=.3)
        try:
            c.wait_connected();c.arm();assert c.wait_idle()
            c.pause_for_preview()  # page idle has requested OFF
            assert releasing.wait(1) and c.status()['lifecycle']=='RELEASING'
            c.pause_for_preview()  # video's pause control arrives during OFF
            c.pause_for_preview()  # repeated control must be idempotent
            finish.set()
            until=time.monotonic()+1
            while c.status()['lifecycle']!='CONNECTED_OFF' and time.monotonic()<until:time.sleep(.005)
            assert c.status()['lifecycle']=='CONNECTED_OFF' and not c.status()['error']
            assert set(backend.torque.values())=={0} and len(calls)==1
            c.pause_for_preview()
            assert len(calls)==1 and not c.release_pending
            c.resume_preview();assert c.wait_idle()
            assert c.status()['lifecycle']=='READY_IDLE'
        finally:
            finish.set();c.close()
