from __future__ import annotations

from .capture_camera_direct_plug import SENSOR_ADDRESS


def request_sensor_standby(iic: object) -> dict[str, int | str | bool]:
    def read_power_control() -> int:
        address = bytes((0x30, 0x08))
        sent = iic.send(SENSOR_ADDRESS, address, len(address))
        if type(sent) is not int or sent != len(address):
            raise RuntimeError(f"OV5640 standby address: sent {sent}/2 bytes")
        ffi = getattr(iic, "_ffi", None)
        data = ffi.new("unsigned char[1]") if ffi is not None else bytearray(1)
        received = iic.receive(SENSOR_ADDRESS, data, len(data))
        if type(received) is not int or received != len(data):
            raise RuntimeError(f"OV5640 standby read: received {received}/1 byte")
        return int(data[0])

    before = read_power_control()
    if before & 0x80:
        raise RuntimeError(f"OV5640 standby refused during software reset: 0x{before:02X}")
    requested = before | 0x40
    packet = bytes((0x30, 0x08, requested))
    sent = iic.send(SENSOR_ADDRESS, packet, len(packet))
    if type(sent) is not int or sent != len(packet):
        raise RuntimeError(f"OV5640 standby write: sent {sent}/3 bytes")
    readback = read_power_control()
    if readback != requested:
        raise RuntimeError(f"OV5640 standby readback: 0x{readback:02X}, expected 0x{requested:02X}")
    return {"status": "STANDBY_REGISTER_VERIFIED", "register": 0x3008,
            "before": before, "requested": requested, "readback": readback,
            "source_quiescent": False, "epoch_release_ready": False}