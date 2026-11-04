"""Run: .venv/Scripts/python -m unittest discover -s subprojects/volume_response_offline -p test_gesture_policy.py
Output: unittest verdict. Next: bind any implementation to these behavior cases.
"""
import unittest
from gesture_policy import VolumeGesturePolicy


class TestGesturePolicy(unittest.TestCase):
    def setUp(self):
        self.policy=VolumeGesturePolicy();self.window=0;self.now=1_000_000_000

    def feed(self,*values,epoch=1):
        rows=[]
        for value in values:
            self.window+=1;self.now+=20_009_000
            rows.append(self.policy.sample(epoch=epoch,window=self.window,observed_ns=self.now,now_ns=self.now,mean_abs=value))
        return rows

    def edges(self,*values):return [r.edge for r in self.feed(*values) if r.edge]

    def test_baseline_13_can_rearm_above_legacy_quiet(self):
        self.assertEqual(self.edges(13,13,40,40,13,13,40,40),['LOUD','LOUD'])

    def test_held_does_not_repeat(self):
        self.assertEqual(self.edges(7,7,*([40]*60)),['LOUD'])

    def test_slow_rise_upgrades_soft_to_loud(self):
        self.assertEqual(self.edges(7,7,20,20,22,25,35,35),['SOFT','LOUD'])

    def test_loud_rearm_without_soft_release(self):
        self.assertEqual(self.edges(7,7,40,40,20,20,40,40),['LOUD','LOUD'])

    def test_single_spike_rejected(self):
        self.assertEqual(self.edges(7,7,50,7,7),[])

    def test_boundary_chatter_rejected(self):
        self.assertEqual(self.edges(7,7,17,15,17,15,17,15),[])

    def test_join_while_loud_requires_release(self):
        self.assertEqual(self.edges(40,40,40,13,13,40,40),['LOUD'])

    def test_no_repeat_from_duplicate_window(self):
        self.feed(7,7,40)
        r=self.policy.sample(epoch=1,window=self.window,observed_ns=self.now,now_ns=self.now,mean_abs=40)
        self.assertIsNone(r.edge);self.assertEqual(r.reason,'duplicate')
        self.assertEqual(self.edges(40),['LOUD'])

    def test_missing_window_does_not_bridge_press(self):
        self.feed(7,7,40);self.window+=1
        self.assertEqual(self.edges(40),[])
        self.assertEqual(self.edges(40),['LOUD'])

    def test_stale_resets_and_held_input_does_not_retrigger(self):
        self.feed(7,7,40)
        r=self.policy.sample(epoch=1,window=4,observed_ns=self.now,now_ns=self.now+100_000_001,mean_abs=40)
        self.assertEqual(r.reason,'unavailable');self.assertIsNone(r.edge)
        self.assertEqual(self.edges(40,40,13,13,40,40),['LOUD'])

    def test_new_epoch_cannot_reuse_old_arm(self):
        self.feed(7,7)
        self.assertFalse(any(r.edge for r in self.feed(40,40,epoch=2)))

    def test_unhealthy_source_has_no_edges(self):
        r=self.policy.sample(epoch=1,window=1,observed_ns=1,now_ns=1,mean_abs=40,healthy=False)
        self.assertEqual(r.reason,'unavailable')

    def test_nonfinite_and_regression_rejected(self):
        self.feed(7,7)
        for value in (float('nan'),float('inf'),-1):
            with self.assertRaises(ValueError):self.feed(value)
        with self.assertRaises(ValueError):
            self.policy.sample(epoch=1,window=1,observed_ns=self.now,now_ns=self.now,mean_abs=7)

    def test_invalid_configuration(self):
        for options in ({'soft_off':16},{'press_windows':0},{'release_windows':True},{'loud_off':15}):
            with self.assertRaises(ValueError):VolumeGesturePolicy(**options)


if __name__=='__main__':unittest.main()
