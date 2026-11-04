"""Deterministic producer/receiver phases with delayed but fresh vision frames.

The schedule reflects the observed 0.3--0.43 s source age. A newer frame is
available before the old frame expires; a 100 ms handoff can still miss it.
"""
from collections import deque

from pynq_usb_hand.game_bridge import DatagramPublisher,DatagramReceiver,GameObservation
from pynq_usb_hand.gesture_consumer import GestureObservation
from pynq_multimodal_game import hand_serial_session

SERIAL_PUBLISH_SECONDS=getattr(hand_serial_session,'SERIAL_PUBLISH_SECONDS',.1)


class Channel:
    def __init__(self):self.packets=deque()
    def setblocking(self,value):assert value is False
    def send(self,packet):self.packets.append(packet);return len(packet)
    def recv(self,size):
        if not self.packets:raise BlockingIOError()
        return self.packets.popleft()


def replay(publish_seconds, *, freeze=False):
    now=[0.]
    class Feed:
        revoked=None
        def read(self):
            # Camera classifications arrive at 0.30 and 0.48 s with original
            # source timestamps 0 and 0.18 s; never refresh cached timestamps.
            frame=2 if now[0]>=.48 and not freeze else 1
            return GameObservation('game',GestureObservation('run','epoch',frame,
                .48 if frame==2 else .30,.18 if frame==2 else 0.,True,'paper'))
    channel=Channel();feed=Feed();publisher=DatagramPublisher(channel,feed,session_id='session')
    receiver=DatagramReceiver(channel,session_id='session',game_run='game',max_age=.5)
    # Common receiver deadline at .51, with a live newer frame available at .48.
    for millisecond in range(300,512):
        now[0]=millisecond/1000
        period=round(publish_seconds*1000)
        if millisecond%period==50%period:publisher.publish()
        if millisecond in (360,460,510):receiver.poll(now[0])
    return receiver


def test_serial_handoff_observes_fresh_tail_before_old_frame_deadline():
    old=replay(.1)
    assert old.stopped=='stale_source'
    current=replay(SERIAL_PUBLISH_SECONDS)
    assert current.stopped is None
    assert current.latest.frame_id==2
    assert current.latest.source_at==.18


def test_cached_or_absent_camera_frame_still_expires_at_original_budget():
    current=replay(SERIAL_PUBLISH_SECONDS,freeze=True)
    assert current.stopped=='stale_source'
    assert current.latest is None
