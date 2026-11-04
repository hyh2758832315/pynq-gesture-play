from collections import deque
import json
import threading
from types import SimpleNamespace
import unittest

from pynq_usb_hand.game_bridge import (DatagramPublisher, DatagramReceiver,
                                      GameFeed, install_game_observer)


class MemoryDatagram:
    def __init__(self):
        self.packets = deque()
        self.full = False
    def setblocking(self, value):
        assert value is False
    def send(self, packet):
        if self.full:
            raise BlockingIOError()
        self.packets.append(packet)
        return len(packet)
    def recv(self, size):
        if not self.packets:
            raise BlockingIOError()
        return self.packets.popleft()[:size]


def sample(frame=1, gesture='paper'):
    value=SimpleNamespace(tick_id=frame,hand_valid=True,hand_gesture=gesture)
    receipt=dict(sample_tick=frame,hand_valid=True,hand_gesture=gesture,
                 source_hand_gesture=gesture,server_age_ms=10,local_age_ms=0,
                 run_id='vision-a',config_epoch='config-a',source_frame_id=frame)
    return value,receipt


class GameBridgeTests(unittest.TestCase):
    def channel(self):
        feed=GameFeed(); sock=MemoryDatagram()
        sender=DatagramPublisher(sock,feed,session_id='session-a')
        receiver=DatagramReceiver(sock,session_id='session-a',game_run='game-a')
        return feed,sock,sender,receiver

    def test_latest_and_duplicate_cannot_refresh_age(self):
        feed,sock,sender,receiver=self.channel()
        feed.offer('game-a',*sample(),now=1)
        sender.publish()
        first=receiver.poll(1.1)
        self.assertEqual(first.frame_id,1)
        self.assertFalse(feed.offer('game-a',*sample(),now=1.2))
        sender.publish()
        self.assertIs(receiver.poll(1.2),first)
        self.assertIsNone(receiver.poll(1.6))
        self.assertEqual(receiver.stopped,'stale_source')

    def test_superseded_stale_datagram_does_not_hide_fresh_tail(self):
        feed,sock,sender,receiver=self.channel()
        feed.offer('game-a',*sample(1),now=1);sender.publish()
        feed.offer('game-a',*sample(2),now=1.7);sender.publish()
        latest=receiver.poll(1.8)
        self.assertIsNotNone(latest)
        self.assertEqual(latest.frame_id,2)
        self.assertIsNone(receiver.stopped)

    def test_live_clock_is_checked_after_receive_not_before_scheduling(self):
        feed,sock,sender,_=self.channel()
        clock=[1.0]
        receiver=DatagramReceiver(sock,session_id='session-a',game_run='game-a')
        receiver.clock=lambda:clock[0]
        original=sock.recv
        def receive(size):
            if not sock.packets and clock[0] == 1.0:
                clock[0]=1.2
                feed.offer('game-a',*sample(1),now=1.2)
                sender.publish()
            return original(size)
        sock.recv=receive
        latest=receiver.poll(1.0)
        self.assertIsNotNone(latest)
        self.assertEqual(latest.frame_id,1)
        self.assertIsNone(receiver.stopped)

    def test_stale_tail_still_stops_even_if_previous_frame_was_fresh(self):
        feed,sock,sender,receiver=self.channel()
        feed.offer('game-a',*sample(1),now=1);sender.publish()
        self.assertIsNotNone(receiver.poll(1.1))
        sender.publish()
        self.assertIsNone(receiver.poll(1.8))
        self.assertEqual(receiver.stopped,'stale_source')

    def test_revoke_survives_slot_lock_and_dropped_send(self):
        feed,sock,sender,receiver=self.channel()
        with feed._lock:
            self.assertFalse(feed.offer('game-a',*sample(),now=1))
            feed.revoke('pause')
        sock.full=True
        self.assertFalse(sender.publish())
        sock.full=False
        self.assertTrue(sender.publish())
        self.assertIsNone(receiver.poll(1))
        self.assertEqual(receiver.stopped,'producer_revoked')
        self.assertFalse(feed.offer('game-a',*sample(2),now=1.1))

    def test_new_game_and_source_latch(self):
        for changed in ('game','source'):
            with self.subTest(changed=changed):
                feed=GameFeed();feed.offer('game-a',*sample(),now=1)
                value,receipt=sample(2)
                if changed=='source':receipt['run_id']='vision-b'
                self.assertFalse(feed.offer('game-b' if changed=='game' else 'game-a',value,receipt,now=1.1))
                self.assertIsNotNone(feed.revoked)
                self.assertFalse(feed.offer('game-a',*sample(3),now=1.2))

    def test_invalid_receipt_does_not_replace_good_value(self):
        feed=GameFeed();feed.offer('game-a',*sample(),now=1)
        old=feed.read()
        value,receipt=sample(2);receipt['sample_tick']=99
        self.assertFalse(feed.offer('game-a',value,receipt,now=1.1))
        self.assertIs(feed.read(),old)
        self.assertEqual(feed.revoked,'invalid_game_receipt')

    def test_corrupt_wrong_session_future_and_overflow_fail_closed(self):
        for kind in ('corrupt','session','game','future','budget','oversize','nan'):
            with self.subTest(kind=kind):
                feed,sock,sender,receiver=self.channel()
                feed.offer('game-a',*sample(),now=1);sender.publish()
                raw=sock.packets[0];data=json.loads(raw)
                if kind=='corrupt':sock.packets[0]=b'no json'
                elif kind=='oversize':sock.packets[0]=b'x'*2049
                elif kind=='budget':sock.packets.extend([raw]*31)
                else:
                    if kind=='session':data['session']='other'
                    if kind=='game':data['value']['game_run']='other'
                    if kind=='future':data['value']['observation']['observed_at']=2
                    if kind=='nan':data['value']['observation']['source_at']=float('nan')
                    sock.packets[0]=json.dumps(data).encode()
                self.assertIsNone(receiver.poll(1.1))
                self.assertIsNotNone(receiver.stopped)
                sock.packets.clear();sender.publish()
                self.assertIsNone(receiver.poll(1.2))

    def test_hooks_call_provider_once_return_identical_result_and_latch_pause(self):
        class Runtime:
            def __init__(self):
                self._test_case=None;self._paused=threading.Event();self._game_run='game-a'
                self.calls=0;self.result=sample()
            def _sample_live_input(self,tick):
                self.calls+=1;return self.result
            def start(self):return 'started'
            def pause(self):self._paused.set();return 'paused'
            def stop(self):return 'stopped'
        original=Runtime._sample_live_input
        feed=GameFeed();uninstall=install_game_observer(Runtime,feed,clock=lambda:1)
        try:
            with self.assertRaises(RuntimeError):install_game_observer(Runtime,GameFeed())
            runtime=Runtime()
            self.assertIs(runtime._sample_live_input(0),runtime.result)
            self.assertEqual(runtime.calls,1)
            self.assertEqual(feed.read().observation.frame_id,1)
            self.assertEqual(runtime.pause(),'paused')
            runtime._paused.clear();runtime.result=sample(2)
            runtime._sample_live_input(1)
            self.assertEqual(feed.revoked,'pause')
            self.assertEqual(feed.read().observation.frame_id,1)
        finally:uninstall()
        self.assertIs(Runtime._sample_live_input,original)

    def test_replay_revokes_before_start_and_receipt_fault_preserves_game(self):
        class Runtime:
            _test_case=object();_paused=threading.Event();_game_run='game-a'
            def _sample_live_input(self,tick):return 'original-result'
            def start(self):return 'started'
            def pause(self):pass
            def stop(self):pass
        feed=GameFeed();uninstall=install_game_observer(Runtime,feed)
        try:
            runtime=Runtime();self.assertEqual(runtime.start(),'started')
            self.assertEqual(feed.revoked,'test_playback')
            self.assertEqual(runtime._sample_live_input(0),'original-result')
        finally:uninstall()

    def test_normal_source_change_received_is_not_auto_rebound(self):
        feed,sock,sender,receiver=self.channel()
        feed.offer('game-a',*sample(),now=1);sender.publish();receiver.poll(1.1)
        sender.publish();data=json.loads(sock.packets.pop())
        data['value']['observation']['run_id']='new'
        sock.packets.append(json.dumps(data).encode())
        self.assertIsNone(receiver.poll(1.2))
        self.assertEqual(receiver.stopped,'source_identity')
