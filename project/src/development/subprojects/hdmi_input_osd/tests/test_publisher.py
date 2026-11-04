from dataclasses import replace
import unittest

from osd_publisher import AudioObservation, HandObservation, OsdPublisher


class FakeRegisters:
    def __init__(self):
        self.values = {0: OsdPublisher.ID, 4: 0}
        self.writes = []

    def read(self, offset):
        return self.values.get(offset, 0)

    def write(self, offset, value):
        self.writes.append((offset, value))
        self.values[offset] = value


class PublisherTests(unittest.TestCase):
    def setUp(self):
        self.io = FakeRegisters()
        self.osd = OsdPublisher(self.io)
        self.hand = HandObservation("vision-1", 1, 1_000_000_000, 0, 0, True, False)
        self.audio = AudioObservation("audio-1", 1, 977, 1_000_000_000, 16, 16, 28, True)

    def send(self, t=1_000_000_000, hand=None, audio=None):
        return self.osd.tick(hand or self.hand, audio or self.audio, now_ns=t)

    def test_unknown_gesture_keeps_position_green_and_constant_geometry(self):
        self.assertTrue(self.send())
        self.assertEqual(self.io.values[0x10], 11)
        self.assertEqual(self.io.values[0x14], 640 | (360 << 16))
        self.assertEqual(self.io.values[0x18] >> 16, 69)
        self.assertEqual(self.io.values[0x1c] & 0xFFFF, 120)
        self.assertEqual(len(self.io.writes), 7)

    def test_fist_is_current_state_without_consuming_an_event(self):
        self.send(hand=replace(self.hand, fist=True))
        self.assertEqual(self.io.values[0x10], 15)

    def test_no_hand_does_not_appear_at_origin(self):
        self.send(hand=replace(self.hand, position_valid=False))
        self.assertFalse(self.io.values[0x10] & 2)

    def test_audio_unhealthy_is_gray_even_if_sample_number_unchanged(self):
        self.send()
        self.send(1_040_000_000, audio=replace(self.audio, healthy=False))
        self.assertFalse(self.io.values[0x10] & 8)

    def test_duplicate_with_new_timestamp_cannot_renew_age(self):
        self.send()
        self.send(1_280_000_000, hand=replace(self.hand, observed_ns=1_280_000_000),
                  audio=replace(self.audio, observed_ns=1_280_000_000))
        self.assertEqual(self.io.values[0x10], 1)
        self.assertEqual(self.osd.hand.observed_ns, 1_000_000_000)
        self.assertEqual(self.osd.audio.observed_ns, 1_000_000_000)

    def test_busy_is_nonblocking_and_newest_snapshot_replaces_old(self):
        self.io.values[4] = 1
        self.assertFalse(self.send())
        self.assertEqual(self.io.writes, [])
        self.io.values[4] = 0
        newest = replace(self.hand, frame_id=3, observed_ns=1_040_000_000, x=1)
        self.assertTrue(self.send(1_040_000_000, hand=newest))
        self.assertEqual(self.io.values[0x14] & 0xFFFF, 1279)
        self.assertEqual(self.osd.busy_skips, 1)

    def test_throttle_does_not_write_or_poll_again(self):
        self.send()
        self.assertFalse(self.send(1_000_000_001))
        self.assertEqual(len(self.io.writes), 7)

    def test_endpoints_map_to_screen_corners(self):
        self.send(hand=replace(self.hand, x=-1, y=1))
        self.assertEqual(self.io.values[0x14], 719 << 16)

    def test_audio_only_updates_do_not_renew_hand_identity(self):
        self.send()
        self.send(1_300_000_000, audio=replace(self.audio, sample_count=1954, observed_ns=1_300_000_000))
        self.assertEqual(self.io.values[0x10], 9)
        self.assertEqual(self.io.values[0x20], 1)
        self.assertEqual(self.io.values[0x24], 2)

    def test_new_producer_can_restart_its_counter(self):
        self.send(hand=replace(self.hand, frame_id=100))
        self.send(1_040_000_000, hand=replace(self.hand, producer_run="vision-2", observed_ns=1_040_000_000))
        self.assertEqual(self.io.values[0x20], 2)

    def test_future_timestamp_and_out_of_order_are_neutral(self):
        self.send(hand=replace(self.hand, observed_ns=1_040_000_000))
        self.assertFalse(self.io.values[0x10] & 2)
        self.assertIsNone(self.osd.hand)
        self.send(1_040_000_000)
        self.send(1_100_000_000, hand=replace(self.hand, frame_id=2, observed_ns=999_000_000))
        self.assertEqual(self.osd.hand.frame_id, 1)

    def test_producer_stop_can_hide_an_existing_hand_without_a_new_frame(self):
        self.send()
        self.send(1_040_000_000, hand=replace(self.hand, position_valid=False))
        self.assertFalse(self.io.values[0x10] & 2)

    def test_display_scale_saturates_without_moving_thresholds(self):
        self.send(audio=replace(self.audio, mean_abs=1e9))
        self.assertEqual(self.io.values[0x18] & 0xFFFF, 240)
        self.assertEqual(self.io.values[0x1c] & 0xFFFF, 120)

    def test_near_expiry_cannot_gain_a_whole_frame(self):
        self.send(1_090_000_000)
        self.assertFalse(self.io.values[0x10] & 8)

    def test_identity_and_parameter_rejections(self):
        for kwargs in ({"rate_hz": 61}, {"hand_age_ns": 251_000_000}, {"width": 0}):
            with self.subTest(kwargs=kwargs), self.assertRaises(ValueError):
                OsdPublisher(self.io, **kwargs)
        self.io.values[0] = 0
        with self.assertRaises(ValueError):
            OsdPublisher(self.io)

    def test_invalid_observations_rejected_before_mmio(self):
        for kwargs in ({"x": float("nan")}, {"x": 2}, {"frame_id": True}, {"fist": 1}):
            with self.subTest(kwargs=kwargs), self.assertRaises(ValueError):
                replace(self.hand, **kwargs)
        for kwargs in ({"soft": 30}, {"mean_abs": -1}, {"loud": float("inf")}):
            with self.subTest(kwargs=kwargs), self.assertRaises(ValueError):
                replace(self.audio, **kwargs)
        self.assertEqual(self.io.writes, [])

    def test_disable_is_a_single_snapshot_not_a_device_reset(self):
        self.osd.tick(self.hand, self.audio, now_ns=1_000_000_000, enabled=False)
        self.assertFalse(self.io.values[0x10] & 1)
        self.assertEqual([offset for offset, _ in self.io.writes], [16, 20, 24, 28, 32, 36, 8])


if __name__ == "__main__":
    unittest.main()
