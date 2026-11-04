"""Real SDK packet replay of every directed gesture transition, no devices.

Run: subprojects/pynq_usb_hand/.venv/Scripts/python.exe -B subprojects/ps_ui_r23b2/test_hand_continuous_sdk.py
Output: unittest report. Next: paired Studio packaging after offline acceptance.
"""
import importlib.util
import itertools
import os
from pathlib import Path
import sys
import time
import unittest
from unittest.mock import patch

ROOT=Path(__file__).resolve().parents[2]
HAND=Path(os.environ.get('HAND_CANDIDATE_ROOT',ROOT/'build/hand-boundary-r15b'))
sys.path[:0]=[str(HAND/'src'),str(HAND/'tests'),str(ROOT/'subprojects/ps_ui_r23b2/python'),str(ROOT/'python')]
from memory_hand import MemoryHand
from pynq_usb_hand.orca_backend import OrcaModel
from pynq_usb_hand.controller import Controller
from pynq_usb_hand.motion import MotionSettings
from pynq_usb_hand.gesture_consumer import GestureConsumer,GestureObservation
from pynq_usb_hand.game_bridge import GameObservation,DatagramPublisher,DatagramReceiver
from pynq_multimodal_game.vision_input import GameVisionInputProvider
from pynq_multimodal_game.hand_shadow_bridge import LatestVisionFeed
spec=importlib.util.spec_from_file_location('direction_source',ROOT/'handoffs/gesture_vision_v61/runtime/gesture_control.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
POSES=(('0','ROCK','rock'),('5','PAPER','paper'),('2','SCISSORS','scissors'))


class ContinuousSDKTests(unittest.TestCase):
    def test_all_six_transitions_central_and_edge_with_real_motion_packets(self):
        with patch('serial.Serial.open',side_effect=AssertionError('REAL_SERIAL_FORBIDDEN')):
            model=OrcaModel(HAND)
            for edge,(start,target) in itertools.product((False,True),itertools.permutations(POSES,2)):
                with self.subTest(start=start[2],target=target[2],edge=edge):
                    backend=MemoryHand(model)
                    c=Controller(lambda:backend,lease_seconds=5,preview_interlock=True,
                        settings=MotionSettings.fixed_playback(stage_waits=(1.,)*3),approval_seconds=.3)
                    try:
                        c.wait_connected();c.arm();self.assertTrue(c.wait_idle())
                        provider=GameVisionInputProvider();direction=module.GestureControl();frame=0
                        feed=LatestVisionFeed(provider,observation_type=GestureObservation,envelope_type=GameObservation)
                        class Wire:
                            def __init__(self):self.data=[]
                            def setblocking(self,_):pass
                            def send(self,data):self.data.append(data);return len(data)
                            def recv(self,_):
                                if not self.data:raise BlockingIOError
                                return self.data.pop(0)
                        wire=Wire();pub=DatagramPublisher(wire,feed,session_id='s')
                        def publish(pose):
                            nonlocal frame
                            frame+=1;now=time.monotonic()
                            control=direction.update(dict(code=pose[0],stable=pose[0],rps=pose[1],
                                centroid=(320.,250.),touches_roi=edge,error=''),frame,now)
                            provider.publish(dict(run_id='r',frame=frame,server_age_ms=0,
                                stable=pose[0],rps=pose[1],control=control),config_epoch='e')
                            self.assertTrue(pub.publish())
                        publish(start);run=feed.read().game_run
                        rx=DatagramReceiver(wire,session_id='s',game_run=run)
                        class Mailbox:
                            def read(self):return rx.poll(time.monotonic())
                        consumer=GestureConsumer(c,Mailbox(),source_identity=('r','e'),max_age=.5,
                            stable_seconds=.1,renew_interval=.05,qualified_gestures=True)
                        backend.packets.clear()
                        self.assertEqual(consumer.tick(time.monotonic),'accepted')
                        time.sleep(.05);publish(target)
                        self.assertEqual(consumer.tick(time.monotonic),'busy_dropped')
                        self.assertTrue(c.wait_idle())
                        self.assertEqual(consumer.tick(time.monotonic),'accepted')
                        self.assertTrue(c.wait_idle())
                        self.assertEqual(c.status()['operation']['state'],target[2])
                        publish(target);self.assertEqual(consumer.tick(time.monotonic),'unchanged')
                        self.assertFalse(any(packet[4]==2 for _,packet in backend.packets))
                    finally:
                        c.close()
                    self.assertTrue(backend.closed)
                    self.assertFalse(any(backend.torque.values()))


if __name__=='__main__':unittest.main()
