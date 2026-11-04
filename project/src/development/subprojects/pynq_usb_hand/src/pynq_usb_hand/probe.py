import argparse
import json
import os
from pathlib import Path
import stat
import time

from scservo_sdk import scscl

from .transport import BoundedPortHandler


class ReadOnlyPortHandler(BoundedPortHandler):
    def __init__(self, port, motor_ids):
        super().__init__(port)
        self.motor_ids = frozenset(motor_ids)
        self.read_requests = 0

    def writePort(self, packet):
        packet = bytes(packet)
        allowed = {16: 2, 40: 1, 56: 2, 62: 1, 63: 1}
        if not (len(packet) == 8 and packet[:2] == b"\xff\xff"
                and packet[2] in self.motor_ids and packet[3] == 4
                and packet[4] == 2 and allowed.get(packet[5]) == packet[6]
                and packet[7] == (~sum(packet[2:7]) & 255)):
            raise PermissionError("Only configured motor register READ packets are permitted")
        self.read_requests += 1
        return super().writePort(packet)


def read_snapshot(transport, motor_ids, report):
    servo = scscl(transport)
    for motor_id in motor_ids:
        motor = {"id": motor_id, "reads": {}}
        report["motors"].append(motor)
        fields = (("torque", servo.read1ByteTxRx, (motor_id, 40)),
                  ("position_raw", servo.ReadPos, (motor_id,)),
                  ("voltage_raw", servo.read1ByteTxRx, (motor_id, 62)),
                  ("temperature_c", servo.read1ByteTxRx, (motor_id, 63)),
                  ("native_limit", servo.read2ByteTxRx, (motor_id, 16)))
        for name, method, arguments in fields:
            with transport.transaction():
                value, result, error = method(*arguments)
            motor["reads"][name] = {"value": value, "result": result, "device_error": error}
            if result != 0 or error != 0:
                raise OSError(f"Motor {motor_id} {name}: communication={result}, device_error={error}")
            if name == "torque" and value != 0:
                raise ValueError(f"Motor {motor_id} is not OFF; no release command was sent")
            if name == "position_raw" and not 0 <= value <= 4095:
                raise ValueError(f"Motor {motor_id} invalid position")
            if name == "voltage_raw" and not 40 <= value <= 90:
                raise ValueError(f"Motor {motor_id} voltage outside existing protection bounds")
            if name == "native_limit" and value != 1000:
                raise ValueError(f"Motor {motor_id} native limit differs from frozen contract")


def probe(root, port, output):
    import fcntl

    from .orca_backend import OrcaModel

    report = {"schema": "pynq-usb-hand-readonly-v1", "result": "READ_ONLY_PENDING",
              "motors": [], "port": port, "motion_authorized": False,
              "safety_policy_verified": False, "release_ready": False}
    transport = None
    lock_fd = None
    started = time.monotonic()
    with output.open("x", encoding="utf-8") as stream:
        try:
            model = OrcaModel(root)
            selected = Path(port)
            candidates = sorted(Path("/dev/serial/by-id").glob("usb-1a86_USB_Single_Serial_*-if00"))
            if candidates != [selected] or selected.name != "usb-1a86_USB_Single_Serial_5B79030971-if00":
                raise ValueError("Expected the unique explicitly identified hand USB serial device")
            device = selected.resolve(strict=True)
            if not stat.S_ISCHR(device.stat().st_mode):
                raise ValueError("USB serial target is not a character device")
            owners = []
            for descriptor in Path("/proc").glob("[0-9]*/fd/*"):
                try:
                    if descriptor.resolve(strict=True) == device:
                        owners.append(str(descriptor))
                except (FileNotFoundError, ProcessLookupError):
                    pass
            if owners:
                raise RuntimeError(f"Serial device already open: {owners}")
            lock_fd = os.open(device, os.O_RDWR | os.O_NOCTTY | os.O_NONBLOCK)
            fcntl.flock(lock_fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
            transport = ReadOnlyPortHandler(str(device), model.ids)
            if not transport.openPort() or not transport.setBaudRate(1_000_000):
                raise OSError("Could not open hand serial port at 1000000 baud")
            report["resolved_port"] = str(device)
            read_snapshot(transport, model.ids, report)
            if len(report["motors"]) != 17 or transport.read_requests != 85:
                raise RuntimeError("Incomplete 17-motor read-only scan")
            report["result"] = "READ_ONLY_COMPLETE"
        except BaseException as error:
            report["result"] = "READ_ONLY_STOPPED"
            report["error"] = f"{type(error).__name__}: {error}"
        finally:
            if transport is not None:
                report["read_requests"] = transport.read_requests
                try:
                    transport.closePort()
                    report["port_closed"] = True
                except Exception as error:
                    report["close_error"] = f"{type(error).__name__}: {error}"
                    report["result"] = "READ_ONLY_STOPPED"
            if lock_fd is not None:
                os.close(lock_fd)
            report["elapsed_seconds"] = time.monotonic() - started
            json.dump(report, stream, indent=2)
            stream.write("\n")
    print(json.dumps(report, sort_keys=True), flush=True)
    return 0 if report["result"] == "READ_ONLY_COMPLETE" else 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Single-hand raw register probe with a READ-only packet guard")
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[2])
    parser.add_argument("--port", required=True)
    parser.add_argument("--output", type=Path, required=True)
    arguments = parser.parse_args()
    raise SystemExit(probe(arguments.root.resolve(), arguments.port, arguments.output))