"""Packet-level simulator; only replaces the serial device and OS port lock.

Uses frozen SCS225Client and the production bounded codec/transport/backend.
Mechanical response is ideal and is explicitly not a physical timing model.
"""
from types import SimpleNamespace

from pynq_usb_hand.orca_backend import OrcaBackend, SafetyPolicy
from pynq_usb_hand.transport import BoundedSCSCL


class MemoryHand(OrcaBackend):
    def __init__(self, model, *, fault=None, temperature=25, voltage=50, residual_on=None):
        from orca_core.hardware.scs225_client import SCS225Client, POS_SCALE

        model.hand._motor_client = SCS225Client(model.ids, "memory-only")
        super().__init__(model, "/dev/memory-only", SafetyPolicy(40, 2), skip_unchanged=True,
                         allow_stage_targets=True, allow_playback=True)
        self.phase = "connect"
        self.fault = fault
        self.voltage = voltage
        self.temperature = temperature
        self.positions = {i: round(p / POS_SCALE) for i, p in model.to_motor(model.poses["default"]).items()}
        self.torque = {i: int(i == residual_on) for i in model.ids}
        self.packets = []
        self.responses = bytearray()
        self.closed = False
        self.client.servo = BoundedSCSCL(self.transport)
        self.transport.ser = SimpleNamespace(timeout=0.01, write_timeout=0.1, out_waiting=0,
                                             write=self.transmit, read=self.receive,
                                             reset_input_buffer=self.responses.clear, close=self.close_memory)

    def connect(self, cancel):
        self.client._connected = True
        self.sample(cancel)

    def arm(self, cancel):
        self.phase = "arm"
        super().arm(cancel)
        self.phase = "playback"

    def release(self):
        self.phase = "release"
        return super().release()

    def close_memory(self):
        self.closed = True

    def receive(self, length):
        result = bytes(self.responses[:length])
        del self.responses[:length]
        return result

    def transmit(self, packet):
        packet = bytes(packet)
        if packet[:2] != b"\xff\xff" or packet[-1] != (~sum(packet[2:-1]) & 255):
            raise AssertionError("Invalid SDK request checksum")
        motor, instruction, address = packet[2], packet[4], packet[5]
        if motor not in self.model.ids or packet[3] + 4 != len(packet):
            raise AssertionError("Unexpected ID, broadcast or length")
        self.packets.append((self.phase, packet))
        error = 4 if self.fault and self.fault(self, packet) else 0
        codec = self.client.servo
        data = []
        if instruction == 2:
            if address == 16 and packet[6] == 48:
                data = [0] * 48
                data[0:2] = [codec.scs_lobyte(1000), codec.scs_hibyte(1000)]
                data[24] = self.torque[motor]
                data[40:42] = [codec.scs_lobyte(self.positions[motor]), codec.scs_hibyte(self.positions[motor])]
                data[46:48] = [self.voltage, self.temperature]
            elif address == 40 and packet[6] == 1:
                data = [self.torque[motor]]
            else:
                raise AssertionError("Unexpected READ")
        elif instruction == 3:
            if address == 42 and len(packet) == 13:
                if codec.scs_makeword(packet[8], packet[9]) != 0 or codec.scs_makeword(packet[10], packet[11]) != 500:
                    raise AssertionError("Unexpected speed or duration")
                if not error:
                    self.positions[motor] = codec.scs_makeword(packet[6], packet[7])
            elif address == 40 and len(packet) == 8 and packet[6] in (0, 1):
                if not error:
                    self.torque[motor] = packet[6]
            else:
                raise AssertionError("Unexpected write / EEPROM modification")
        else:
            raise AssertionError("Unexpected instruction")
        response = [motor, len(data) + 2, error] + data
        self.responses.extend([255, 255] + response + [(~sum(response)) & 255])
        return len(packet)
