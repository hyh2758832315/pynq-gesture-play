"""Run: python -m unittest discover -s examples -p 'test_*.py'. Output: test results.
Next: connect the tested receiver to a game adapter; no board required.
"""
import unittest
from control_receiver import Receiver


def packet(frame=1, seq=0, run='demo', valid=True, age=0):
    return {'run_id': run, 'server_age_ms': age, 'control': {
        'schema': 'gesture-control-v1', 'frame_id': frame,
        'action_event_seq': seq, 'valid': valid, 'direction': 'LEFT'}}


class Tests(unittest.TestCase):
    def test_initial_event_not_replayed(self):
        self.assertFalse(Receiver().consume(packet(seq=10), 0)['action_event'])

    def test_event_once(self):
        r = Receiver()
        r.consume(packet(), 0)
        self.assertTrue(r.consume(packet(2, 1), .1)['action_event'])
        self.assertFalse(r.consume(packet(2, 1), .2)['action_event'])

    def test_duplicates_expire(self):
        r = Receiver()
        r.consume(packet(), 0)
        self.assertEqual(r.consume(packet(), 1.3)['direction'], 'IDLE')

    def test_invalid_releases(self):
        r = Receiver()
        r.consume(packet(), 0)
        self.assertEqual(r.consume(packet(2, valid=False), .1)['direction'], 'IDLE')

    def test_stale_and_reconnect(self):
        r = Receiver()
        r.consume(packet(), 0)
        self.assertEqual(r.consume(packet(2, age=1201), .1)['direction'], 'IDLE')
        self.assertFalse(r.consume(packet(3, 3), .2)['action_event'])

    def test_new_run_baseline(self):
        r = Receiver()
        r.consume(packet(seq=3), 0)
        self.assertFalse(r.consume(packet(seq=5, run='new'), .1)['action_event'])


if __name__ == '__main__':
    unittest.main()
