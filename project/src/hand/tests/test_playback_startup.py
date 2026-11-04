from pathlib import Path
import unittest
from unittest.mock import patch

from pynq_usb_hand.controller import Controller
from pynq_usb_hand.motion import MotionSettings
from pynq_usb_hand.orca_backend import OrcaModel
from memory_hand import MemoryHand


ROOT = Path(__file__).resolve().parents[1]


class StartupPacketTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        with patch("serial.Serial.open", side_effect=AssertionError("REAL_SERIAL_FORBIDDEN")):
            cls.model = OrcaModel(ROOT)

    def session(self, **options):
        backend = MemoryHand(self.model, **options)
        controller = Controller(lambda: backend, lease_seconds=5,
                                settings=MotionSettings.fixed_playback(stage_waits=(0.001,) * 3))
        self.addCleanup(controller.close)
        return controller, backend

    def test_startup_order_and_continuous_zero_read_playback(self):
        c, b = self.session()
        c.wait_connected()
        self.assertEqual(len(b.packets), 17)
        self.assertTrue(all(p[4] == 2 for _, p in b.packets))
        c.arm()
        self.assertTrue(c.wait_idle())
        self.assertEqual(c.status()["lifecycle"], "READY_IDLE")
        phases = [(p[4], p[5]) for _, p in b.packets]
        self.assertEqual(phases, [(2, 16)] * 34 + [(3, 42)] * 17 + [(3, 40)] * 17 + [(2, 16)] * 17)
        boundary = len(b.packets)
        epoch = c.enable_epoch
        for index, state in enumerate(("paper", "scissors", "rock", "rock"), 1):
            self.assertEqual(c.submit(state, request_id=index, session_id=c.session_id, enable_epoch=epoch), "accepted")
            self.assertTrue(c.wait_idle())
            self.assertEqual(c.status()["operation"]["status"], "played")
            self.assertEqual(c.status()["actual_state"], "unknown")
        self.assertTrue(all((p[4], p[5]) == (3, 42) for _, p in b.packets[boundary:]))
        self.assertTrue(all(b.torque.values()))
        c.close()
        self.assertEqual([(p[4], p[5]) for _, p in b.packets[-34:]], [(3, 40)] * 17 + [(2, 40)] * 17)
        self.assertFalse(any(b.torque.values()))
        self.assertTrue(b.closed)
        self.assertFalse(b.responses)

    def test_readonly_startup_failures_never_write_or_release(self):
        cases = [{"temperature": 40}, {"voltage": 39}]
        cases += [{"residual_on": motor} for motor in self.model.ids]
        cases += [{"fault": lambda bus, p, motor=motor: p[2] == motor} for motor in self.model.ids]
        for options in cases:
            with self.subTest(options=options):
                c, b = self.session(**options)
                with self.assertRaises(RuntimeError):
                    c.wait_connected()
                c.close()
                self.assertTrue(all(p[4] == 2 for _, p in b.packets))
                self.assertTrue(b.closed)

    def test_each_alignment_enable_and_confirmation_failure_cleans_all_ids(self):
        for phase in ("alignment", "enable", "confirmation"):
            for motor in self.model.ids:
                def fault(bus, packet):
                    if bus.phase != "arm" or packet[2] != motor:
                        return False
                    if phase == "alignment":
                        return packet[4:6] == bytes([3, 42])
                    if phase == "enable":
                        return packet[4:7] == bytes([3, 40, 1])
                    return packet[4] == 2 and all(bus.torque.values())
                with self.subTest(phase=phase, motor=motor):
                    c, b = self.session(fault=fault)
                    c.wait_connected()
                    c.arm()
                    self.assertTrue(c.wait_idle())
                    self.assertEqual(c.status()["lifecycle"], "FAULT")
                    self.assertIsNone(c.enable_epoch)
                    self.assertFalse(any(b.torque.values()))
                    release = [p for context, p in b.packets if context == "release"]
                    self.assertEqual(len(release), 34)
                    self.assertEqual({p[2] for p in release if p[4] == 3}, set(self.model.ids))
                    if phase == "alignment":
                        self.assertFalse(any(p[4:7] == bytes([3, 40, 1]) for _, p in b.packets))
                    if phase == "enable":
                        enabled = [p[2] for _, p in b.packets if p[4:7] == bytes([3, 40, 1])]
                        self.assertEqual(enabled, list(self.model.ids[:self.model.ids.index(motor) + 1]))
                    c.close()

    def test_unconfirmed_shutdown_reports_unknown_and_does_not_rearm(self):
        c, b = self.session(fault=lambda bus, p: bus.phase == "release" and p[2] == 9)
        c.wait_connected()
        c.arm()
        self.assertTrue(c.wait_idle())
        c.close()
        self.assertEqual(c.status()["lifecycle"], "RELEASE_UNKNOWN")
        self.assertIn("9", c.status()["error"])
        self.assertIsNone(c.enable_epoch)
        self.assertTrue(b.closed)
        with self.assertRaises(RuntimeError):
            c.arm()


if __name__ == "__main__":
    unittest.main()
