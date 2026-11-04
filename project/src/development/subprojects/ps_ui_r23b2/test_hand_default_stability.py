"""Offline replay, no hardware. Select source with HAND_CANDIDATE_ROOT.
Run: .venv/Scripts/python.exe -m pytest -q subprojects/ps_ui_r23b2/test_hand_default_stability.py
Output: replay assertions. Next: paired integration before observed board testing.
"""
import os
from pathlib import Path
import sys
import pytest
ROOT = Path(__file__).resolve().parents[2]
HAND = Path(os.environ.get('HAND_CANDIDATE_ROOT', ROOT / 'build/hand-r35-default-stability-20261026-r05'))
sys.path.insert(0, str(HAND / 'src'))
from pynq_usb_hand.gesture_consumer import GestureConsumer, GestureObservation, LatestGesture

class CheckedController:
    lease_seconds = 5
    approval_seconds = 3
    last_request = 0
    def __init__(self):
        self.now = 0
        self.ready_at = 0
        self.operations = []
        self.released = False
    def status(self):
        return dict(mode='fixed-playback', lifecycle='MOVING' if self.now < self.ready_at else 'READY_IDLE',
                    error=None, session_id='session', enable_epoch='epoch')
    def renew(self, **keys): pass
    def release(self): self.released = True
    def submit(self, state, **keys):
        assert self.now >= self.ready_at, 'busy requests must never be queued'
        self.operations.append((state, self.now))
        self.ready_at = self.now + self.approval_seconds
        return 'accepted'

class Replay:
    def __init__(self):
        self.controller = CheckedController()
        self.slot = LatestGesture()
        self.consumer = GestureConsumer(self.controller, self.slot, source_identity=('run', 'cfg'),
                                        max_age=.5, stable_seconds=.1, renew_interval=.2)
        self.frame = 0
    def tick(self, at, gesture, *, source_at=None, valid=True):
        self.frame += 1
        self.controller.now = at
        self.slot.offer(GestureObservation('run', 'cfg', self.frame, at,
                                          at if source_at is None else source_at, valid, gesture))
        return self.consumer.tick(at)
    def paper(self):
        self.tick(1., 'paper')
        assert self.tick(1.2, 'paper') == 'accepted'

def test_one_unknown_at_ready_does_not_block_next_pose_for_three_seconds():
    replay = Replay(); replay.paper()
    replay.tick(4.21, None)
    replay.tick(4.26, 'scissors')
    replay.tick(4.38, 'scissors')
    assert replay.controller.operations == [('paper', 1.2), ('scissors', 4.38)]

def test_short_unknown_between_same_pose_does_not_replay_default_or_pose():
    replay = Replay(); replay.paper()
    replay.tick(4.21, None)
    replay.tick(4.26, 'paper')
    replay.tick(4.38, 'paper')
    assert replay.controller.operations == [('paper', 1.2)]

def test_sustained_unknown_returns_default_once_after_fresh_qualification():
    replay = Replay(); replay.paper()
    assert replay.tick(4.21, None) == 'stabilizing'
    assert replay.tick(4.34, None) == 'accepted'
    replay.tick(7.4, None); replay.tick(7.55, None)
    assert replay.controller.operations == [('paper', 1.2), ('default', 4.34)]

def test_latest_unknown_qualified_while_busy_is_usable_when_ready():
    replay = Replay(); replay.paper()
    replay.tick(3.95, None); replay.tick(4.08, None)
    assert replay.controller.operations == [('paper', 1.2)]
    assert replay.tick(4.21, None) == 'accepted'

def test_busy_unknown_does_not_queue_behind_newer_gesture():
    replay = Replay(); replay.paper()
    replay.tick(3.7, None); replay.tick(3.85, None)
    replay.tick(3.95, 'fist'); replay.tick(4.08, 'fist')
    assert replay.tick(4.21, 'fist') == 'accepted'
    assert replay.controller.operations == [('paper', 1.2), ('rock', 4.21)]

def test_cached_unknown_cannot_qualify_or_refresh_freshness():
    replay = Replay(); replay.paper()
    replay.tick(4.21, None)
    assert replay.consumer.tick(4.35) == 'duplicate_frame'
    assert replay.tick(4.4, None, source_at=4.21) == 'nonadvancing_source_time'
    assert replay.consumer.tick(4.72) == 'invalid_or_stale_source'
    assert replay.controller.released
    assert replay.controller.operations == [('paper', 1.2)]

@pytest.mark.parametrize('valid,source_at', [(False, 4.21), (True, 3.5)])
def test_invalid_or_stale_unknown_releases_instead_of_smoothing(valid, source_at):
    replay = Replay(); replay.paper()
    assert replay.tick(4.21, None, valid=valid, source_at=source_at) == 'invalid_or_stale_source'
    assert replay.controller.released
    assert replay.controller.operations == [('paper', 1.2)]
