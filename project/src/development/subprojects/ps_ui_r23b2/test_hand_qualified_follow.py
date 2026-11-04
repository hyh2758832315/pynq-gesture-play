"""Offline classified-frame follow checks. No serial port or board access.

Run with HAND_CANDIDATE_ROOT and PYTHONPATH=<hand>/src;python;.
Outputs: pytest report. Next: SDK memory-owner and standard Studio package checks.
"""
from pynq_usb_hand.gesture_consumer import GestureConsumer, GestureObservation, LatestGesture


class Controller:
    lease_seconds = 5
    approval_seconds = 3
    last_request = 0

    def __init__(self):
        self.operations = []
        self.released = False
        self.lifecycle = 'READY_IDLE'

    def status(self):
        return dict(mode='fixed-playback', lifecycle=self.lifecycle, error=None,
                    session_id='s', enable_epoch='e')

    def renew(self, **kw): pass
    def release(self): self.released = True
    def submit(self, state, request_id, **kw):
        assert self.lifecycle == 'READY_IDLE'
        self.last_request = request_id
        self.operations.append(state)
        return 'accepted'


def test_upstream_stable_gesture_does_not_require_another_consecutive_pair():
    c = Controller(); slot = LatestGesture()
    consumer = GestureConsumer(c, slot, source_identity=('r', 'e'), max_age=.5,
        stable_seconds=.1, renew_interval=.2, qualified_gestures=True)
    # Already classified source at 1.7Hz, or valid classifications interspersed
    # with UNKNOWN: an additional consecutive-frame gate can starve forever.
    for frame, (now, gesture) in enumerate(((1., 'paper'), (1.2, None),
            (1.3, 'fist'), (1.5, None), (1.6, 'scissors')), 1):
        slot.offer(GestureObservation('r', 'e', frame, now, now, True, gesture))
        outcome = consumer.tick(now)
        if gesture is not None: assert outcome == 'accepted'
    assert c.operations == ['paper', 'rock', 'scissors']
    assert consumer.tick(1.7) == 'duplicate_frame'
    assert consumer.tick(2.2) == 'invalid_or_stale_source'
    assert c.released


def test_qualified_busy_is_latest_only_and_unknown_holds_until_explicit_default():
    c = Controller(); slot = LatestGesture()
    consumer = GestureConsumer(c, slot, source_identity=('r', 'e'), max_age=.5,
        stable_seconds=.1, renew_interval=.2, qualified_gestures=True)
    def tick(frame, at, gesture):
        slot.offer(GestureObservation('r', 'e', frame, at, at, True, gesture))
        return consumer.tick(at)
    assert tick(1, 1., 'paper') == 'accepted'
    c.lifecycle = 'MOVING'
    assert tick(2, 1.1, 'fist') == 'busy_dropped'
    assert tick(3, 1.2, 'scissors') == 'busy_dropped'
    c.lifecycle = 'READY_IDLE'
    assert tick(4, 4., 'scissors') == 'accepted'
    assert c.operations == ['paper', 'scissors']
    assert tick(5, 4.1, None) == 'unclassified_hold'
    assert tick(6, 4.15, None) == 'unclassified_hold'
    assert tick(7, 4.25, 'default') == 'accepted'
    assert c.operations == ['paper', 'scissors', 'default']


def test_real_owner_recovers_from_low_cadence_without_another_stable_pair():
    import time
    from pynq_usb_hand.actuator_owner import VisionActuatorOwner
    from pynq_usb_hand.motion import MockBackend

    began = time.monotonic()
    gestures = ('paper', 'fist', 'scissors', 'paper', 'fist')
    class Receiver:
        stopped = None
        latest = None
        waiting_for_fresh = False
        def poll(self, now):
            index = min(int((now - began) / .65), len(gestures) - 1)
            self.latest = GestureObservation('r', 'e', index + 1, now,
                began + index * .65, True, gestures[index])
            self.waiting_for_fresh = now - self.latest.source_at > .5
            return None if self.waiting_for_fresh else self.latest
    receiver = Receiver()
    backend = MockBackend()
    backend.stage_targets_authorized = True
    backend.playback_authorized = True
    owner = VisionActuatorOwner(receiver, lambda: backend, motor_ids=tuple(range(1,18)),
        stage_waits=(.001,)*3, max_seconds=3.05, poll_seconds=.02, max_age=.5,
        stable_seconds=.1, approval_seconds=.08, receiver_factory=lambda: receiver,
        on_preview_state=lambda _: None, source_recovery=True)
    report = owner.run()
    assert report['error'] is None
    assert report['release_confirmed'] and report['backend_closed']
    assert report['source_resumes'] >= 3
    assert [op['state'] for op in report['operations']] == ['paper','rock','scissors','paper','rock']
