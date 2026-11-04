"""Read diagnostic power feedback despite device status bits; never arm/move.
Run: hand-venv/bin/python -B tools/power_feedback_readonly.py --port /dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00 --output NEW_REPORT.json
Output: new JSON with at most nine READs (IDs1/9/17, voltage/temp/torque), raw packets.
Next: compare measured feedback to the original error; this report never grants startup readiness.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import stat
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
PINS = {
    "src/pynq_usb_hand/__init__.py": "3c6f4a858fe730ce1185288680ae07a2679d25a1e5a672b75189c7f3a0256c90",
    "src/pynq_usb_hand/probe.py": "c7a349070d83001fde1c6c60859a38c93a2b5515ab634eeed8c8c89bdda3882c",
    "src/pynq_usb_hand/transport.py": "81460ff83a05ba31f2d5657b05b0810992b3fd6dc2c772305ea7c114b781bf16",
    "src/pynq_usb_hand/assets.py": "6f9242f7354746e51ff2ffe019b0c51189cdf2b4111113f9ecc0199041fec9a7",
    "frozen_manifest.json": "5bbe20b6f9ce099eda45026db7e9965defa700d466a83d21e34403bbbd136128",
}
for relative, expected in PINS.items():
    if hashlib.sha256((ROOT / relative).read_bytes()).hexdigest() != expected:
        raise ValueError("diagnostic source identity mismatch: " + relative)
sys.path.insert(0, str(ROOT / "src"))
from pynq_usb_hand.assets import verify_frozen
from pynq_usb_hand.probe import ReadOnlyPortHandler
from pynq_usb_hand.transport import BoundedSCSCL

PORT = "/dev/serial/by-id/usb-1a86_USB_Single_Serial_5B79030971-if00"
IDS = (1, 9, 17)
FIELDS = (("voltage_raw", 62), ("temperature_c", 63), ("torque", 40))


class PowerReadOnlyPort(ReadOnlyPortHandler):
    def __init__(self, port):
        super().__init__(port, IDS)
        self.seen = set()
        self.tx = b""
        self.rx = bytearray()

    def writePort(self, packet):
        packet = bytes(packet)
        if (len(packet) != 8 or packet[2] not in IDS or packet[5] not in (40, 62, 63)
                or packet[6] != 1 or (packet[2], packet[5]) in self.seen):
            raise PermissionError("Only one diagnostic byte READ per selected motor/register")
        self.seen.add((packet[2], packet[5]))
        self.tx = packet
        return super().writePort(packet)

    def readPort(self, length):
        packet = super().readPort(length)
        self.rx.extend(packet)
        return packet


def collect_feedback(transport, rows=None):
    servo = BoundedSCSCL(transport)
    rows = [] if rows is None else rows
    for motor_id in IDS:
        for name, address in FIELDS:
            transport.rx.clear()
            with transport.transaction():
                value, communication, device_error = servo.read1ByteTxRx(motor_id, address)
            rows.append(dict(id=motor_id, field=name, address=address,
                             value=value, communication=communication, device_error=device_error,
                             request_hex=transport.tx.hex(), response_hex=transport.rx.hex(),
                             response_checksum_ok=(len(transport.rx) == 7
                                                   and sum(transport.rx[2:]) & 255 == 255)))
            if name == "torque" and communication == 0 and value != 0:
                raise RuntimeError("Existing torque is not OFF; no command was sent to change it")
    return rows


def diagnose(output):
    import fcntl

    report = dict(schema="hand-power-diagnostic-readonly-v1", result="STOPPED",
                  motion_authorized=False, startup_ready=False, release_ready=False,
                  rows=[], port=PORT, read_requests=0, port_closed=False)
    transport = None
    lock_fd = None
    started = time.monotonic()
    with output.open("x", encoding="utf-8") as stream:
        try:
            if sys.platform != "linux" or os.geteuid() != 0:
                raise ValueError("explicit Linux root diagnostic required")
            verify_frozen(ROOT)
            selected = Path(PORT)
            if sorted(selected.parent.glob("usb-1a86_USB_Single_Serial_*-if00")) != [selected]:
                raise ValueError("unique identified serial device required")
            device = selected.resolve(strict=True)
            if not stat.S_ISCHR(device.stat().st_mode):
                raise ValueError("serial port must be a character device")
            for descriptor in Path("/proc").glob("[0-9]*/fd/*"):
                try:
                    if descriptor.resolve(strict=True) == device:
                        raise RuntimeError("serial port already open: " + str(descriptor))
                except (FileNotFoundError, ProcessLookupError):
                    pass
            lock_fd = os.open(device, os.O_RDWR | os.O_NOCTTY | os.O_NONBLOCK)
            fcntl.flock(lock_fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
            transport = PowerReadOnlyPort(str(device))
            if not transport.openPort() or not transport.setBaudRate(1_000_000):
                raise OSError("could not open diagnostic port")
            collect_feedback(transport, report["rows"])
            report["result"] = "DIAGNOSTIC_COMPLETE"
        except BaseException as error:
            report["error"] = f"{type(error).__name__}: {error}"
        finally:
            if transport is not None:
                report["read_requests"] = transport.read_requests
                try:
                    transport.closePort()
                    report["port_closed"] = True
                except Exception as error:
                    report["close_error"] = str(error)
                    report["result"] = "STOPPED"
            if lock_fd is not None:
                os.close(lock_fd)
            report["elapsed_seconds"] = time.monotonic() - started
            json.dump(report, stream, indent=2)
            stream.write("\n")
    print(json.dumps(report, sort_keys=True), flush=True)
    return report


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", required=True, choices=(PORT,))
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    report = diagnose(args.output)
    healthy = (report["result"] == "DIAGNOSTIC_COMPLETE" and
               all(row["communication"] == row["device_error"] == 0 for row in report["rows"]))
    raise SystemExit(0 if healthy else 2)
