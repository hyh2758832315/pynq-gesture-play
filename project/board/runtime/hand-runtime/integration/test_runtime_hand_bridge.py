"""Actual packaged-game sample hook to independent receiver and memory SDK hand."""
from pathlib import Path
import sys
import threading
import unittest
from unittest.mock import patch

from pynq_usb_hand.controller import Controller
from pynq_usb_hand.game_bridge import GameFeed, DatagramPublisher, DatagramReceiver, install_game_observer
from pynq_usb_hand.gesture_consumer import LatestGesture, GestureConsumer
from pynq_usb_hand.motion import MotionSettings
from pynq_usb_hand.orca_backend import OrcaModel


class RuntimeHandBridgeTests(unittest.TestCase):
    def test_real_runtime_provider_channel_controller_and_pause_release(self):
        root=Path(__file__).resolve().parents[1]
        with patch.object(sys,'path',[str(root/'tests'),*sys.path]):
            from memory_hand import MemoryHand
            from test_game_bridge import MemoryDatagram
        from pynq_multimodal_game.agent.game_runtime import PackagedGameRuntime
        from pynq_multimodal_game.vision_input import GameVisionInputProvider
        class CountedProvider(GameVisionInputProvider):
            calls=0
            def sample_for_game(self,*args,**kwargs):
                self.calls+=1
                self.result=super().sample_for_game(*args,**kwargs)
                return self.result
        now=[10.0]
        provider=CountedProvider(clock=lambda:now[0])
        runtime=object.__new__(PackagedGameRuntime)
        runtime._live_input=provider;runtime._game_id='game2';runtime._game_run='game-a'
        runtime._test_case=None;runtime._paused=threading.Event()
        feed=GameFeed()
        uninstall=install_game_observer(PackagedGameRuntime,feed,clock=lambda:now[0])
        self.addCleanup(uninstall)
        socket=MemoryDatagram()
        publisher=DatagramPublisher(socket,feed,session_id='session-a')
        receiver=DatagramReceiver(socket,session_id='session-a',game_run='game-a')
        backend=MemoryHand(OrcaModel(root))
        controller=Controller(lambda:backend,lease_seconds=5,
                              settings=MotionSettings.fixed_playback(stage_waits=(.001,)*3))
        self.addCleanup(controller.close)
        controller.wait_connected();controller.arm();self.assertTrue(controller.wait_idle())
        mailbox=LatestGesture()
        consumer=GestureConsumer(controller,mailbox,source_identity=('run-a','cfg-a'),
                                 max_age=.5,stable_seconds=.1,renew_interval=.2)
        backend.packets.clear()
        frame=0
        for stable,label,expected in (('5','PAPER','paper'),('0','ROCK','rock'),('2','SCISSORS','scissors')):
            for index in range(2):
                frame+=1;now[0]+=.15
                provider.publish(dict(run_id='run-a',server_age_ms=10,stable=stable,rps=label,
                    control=dict(schema='gesture-control-v1',frame_id=frame,action_event_seq=0,valid=True,direction='LEFT')),
                    config_epoch='cfg-a')
                result=runtime._sample_live_input(frame)
                self.assertIs(result,provider.result)
                self.assertEqual(provider.calls,frame)
                self.assertTrue(publisher.publish())
                observation=receiver.poll(now[0])
                self.assertIsNotNone(observation)
                mailbox.offer(observation)
                self.assertEqual(consumer.tick(now[0]),'accepted' if index else 'stabilizing')
            self.assertTrue(controller.wait_idle())
            self.assertEqual(controller.status()['operation']['state'],expected)
            self.assertEqual(controller.status()['operation']['status'],'played')
        # A fresh but unclassified frame requests default through the same
        # one-slot observation path, without a second vision sample.
        frame+=1;now[0]+=.15
        provider.publish(dict(run_id='run-a',server_age_ms=10,stable='1',rps='UNKNOWN',
            control=dict(schema='gesture-control-v1',frame_id=frame,action_event_seq=0,
                         valid=True,direction='IDLE')),config_epoch='cfg-a')
        result=runtime._sample_live_input(frame)
        self.assertIs(result,provider.result)
        self.assertEqual(provider.calls,frame)
        self.assertTrue(publisher.publish())
        observation=receiver.poll(now[0])
        self.assertIsNotNone(observation)
        mailbox.offer(observation)
        self.assertEqual(consumer.tick(now[0]),'accepted')
        self.assertTrue(controller.wait_idle())
        self.assertEqual(controller.status()['operation']['state'],'default')
        self.assertTrue(backend.packets)
        self.assertTrue(all((packet[4],packet[5])==(3,42) for _,packet in backend.packets))
        # Even a pause that fails the original runtime's state check revokes first.
        runtime._thread=None;runtime._last_error=None
        with self.assertRaises(RuntimeError):runtime.pause()
        publisher.publish()
        self.assertIsNone(receiver.poll(now[0]))
        self.assertEqual(receiver.stopped,'producer_revoked')
        consumer.stop('channel_revoked')
        self.assertTrue(controller.wait_idle())
        self.assertFalse(any(backend.torque.values()))
        controller.close()
        self.assertTrue(backend.closed)
