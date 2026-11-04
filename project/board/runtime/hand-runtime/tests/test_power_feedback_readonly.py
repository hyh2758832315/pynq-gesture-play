import importlib.util
import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("power_readonly_under_test", ROOT / "tools/power_feedback_readonly.py")
diagnostic = importlib.util.module_from_spec(spec)
spec.loader.exec_module(diagnostic)


class DiagnosticMemory:
    def __init__(self, torque=0):
        self.buffer = bytearray()
        self.requests = []
        self.torque = torque
        self.out_waiting = 0
        self.timeout = .01
        self.write_timeout = .1

    def write(self, packet):
        packet = bytes(packet)
        self.requests.append(packet)
        motor, address = packet[2], packet[5]
        value = {62: 37, 63: 25, 40: self.torque}[address]
        response = [motor, 3, 1, value]
        self.buffer.extend([255, 255, *response, (~sum(response)) & 255])
        return len(packet)

    def read(self, length):
        value = bytes(self.buffer[:length])
        del self.buffer[:length]
        return value


class PowerDiagnosticTests(unittest.TestCase):
    def port(self, torque=0):
        port = diagnostic.PowerReadOnlyPort("memory-only")
        port.ser = DiagnosticMemory(torque)
        return port

    def test_device_error_bits_preserved_but_feedback_still_read_without_write(self):
        port = self.port()
        rows = diagnostic.collect_feedback(port)
        self.assertEqual(len(rows), 9)
        self.assertEqual(port.read_requests, 9)
        self.assertTrue(all(row["device_error"] == 1 and row["communication"] == 0 for row in rows))
        self.assertTrue(all(row["response_checksum_ok"] for row in rows))
        self.assertEqual([row["value"] for row in rows if row["field"] == "voltage_raw"], [37] * 3)
        self.assertTrue(all(packet[4] == 2 for packet in port.ser.requests))

    def test_recorded_board_responses_decode_identically(self):
        captured = json.loads((ROOT / "tests/fixtures/power_feedback_20261025.json").read_text(encoding="utf-8"))

        class RecordedMemory(DiagnosticMemory):
            def write(self, packet):
                expected = captured["rows"][len(self.requests)]
                packet = bytes(packet)
                self.requests.append(packet)
                if packet.hex() != expected["request_hex"]:
                    raise AssertionError("Unexpected request against recorded board responses")
                self.buffer.extend(bytes.fromhex(expected["response_hex"]))
                return len(packet)

        port = self.port()
        port.ser = RecordedMemory()
        rows = diagnostic.collect_feedback(port)
        self.assertEqual(rows, captured["rows"])
        self.assertEqual([row["value"] for row in rows if row["field"] == "voltage_raw"], [36, 51, 36])

    def test_original_startup_probe_still_rejects_recorded_device_error(self):
        from pynq_usb_hand.probe import read_snapshot
        captured = json.loads((ROOT / "tests/fixtures/power_feedback_20261025.json").read_text(encoding="utf-8"))
        torque = next(row for row in captured["rows"] if row["id"] == 1 and row["field"] == "torque")

        class RecordedTorque(DiagnosticMemory):
            def write(self, packet):
                packet = bytes(packet)
                self.requests.append(packet)
                if packet.hex() != torque["request_hex"]:
                    raise AssertionError("Startup must stop at the captured first error")
                self.buffer.extend(bytes.fromhex(torque["response_hex"]))
                return len(packet)

        port = self.port()
        port.ser = RecordedTorque()
        report = {"motors": []}
        with self.assertRaisesRegex(OSError, "device_error=1"):
            read_snapshot(port, (1, 9, 17), report)
        self.assertEqual(port.read_requests, 1)
        self.assertEqual(report["motors"][0]["reads"]["torque"]["device_error"], 1)
        self.assertTrue(all(packet[2] in (1, 9, 17) for packet in port.ser.requests))

    def test_write_other_register_other_id_and_duplicate_are_rejected(self):
        def packet(motor, instruction, address, value):
            body = [motor, 4, instruction, address, value]
            return bytes([255, 255, *body, (~sum(body)) & 255])
        for request in (packet(1, 3, 40, 1), packet(1, 2, 14, 1), packet(2, 2, 62, 1),
                        packet(1, 2, 62, 2), packet(1, 6, 62, 1)):
            port = self.port()
            with self.subTest(request=request.hex()), self.assertRaises(PermissionError):
                with port.transaction():
                    port.writePort(request)
            self.assertFalse(port.ser.requests)
        port = self.port()
        diagnostic.collect_feedback(port)
        with self.assertRaises(PermissionError):
            with port.transaction():
                port.writePort(packet(1, 2, 62, 1))
        self.assertEqual(port.read_requests, 9)

    def test_existing_torque_aborts_and_preserves_partial_feedback(self):
        port = self.port(torque=1)
        rows = []
        with self.assertRaisesRegex(RuntimeError, "not OFF"):
            diagnostic.collect_feedback(port, rows)
        self.assertEqual(len(rows), 3)
        self.assertEqual(len(port.ser.requests), 3)
        self.assertTrue(all(packet[4] == 2 for packet in port.ser.requests))


if __name__ == "__main__":
    unittest.main()
