from contextlib import contextmanager
import math
import threading
import time

from scservo_sdk import (BROADCAST_ID, COMM_NOT_AVAILABLE, COMM_RX_CORRUPT,
                        COMM_RX_TIMEOUT, COMM_SUCCESS, INST_READ, PortHandler, scscl)


class BoundedSCSCL(scscl):
    def rxPacket(self):
        packet = bytearray()
        required = 6
        try:
            while True:
                packet.extend(self.portHandler.readPort(required - len(packet)))
                if len(packet) >= 6:
                    header = packet.find(b"\xff\xff")
                    if header != 0:
                        if header > 0:
                            del packet[:header]
                        else:
                            packet[:] = packet[-1:] if packet[-1] == 255 else b""
                        required = 6
                    elif packet[2] > 253 or not 2 <= packet[3] <= 250 or packet[4] > 127:
                        del packet[0]
                        required = 6
                    else:
                        required = packet[3] + 4
                        if len(packet) >= required:
                            packet = packet[:required]
                            result = COMM_SUCCESS if sum(packet[2:]) & 255 == 255 else COMM_RX_CORRUPT
                            return packet, result
                if self.portHandler.isPacketTimeout():
                    return list(packet), COMM_RX_CORRUPT if packet else COMM_RX_TIMEOUT
        finally:
            self.portHandler.is_using = False

    def readTxRx(self, scs_id, address, length):
        if scs_id >= BROADCAST_ID:
            return b"", COMM_NOT_AVAILABLE, 0
        packet = [0, 0, scs_id, 4, INST_READ, address, length, 0]
        received, result, error = self.txRxPacket(packet)
        if result != COMM_SUCCESS:
            return b"", result, error
        if len(received) != length + 6:
            return b"", COMM_RX_CORRUPT, error
        return received[5:-1], result, error


class BoundedPortHandler(PortHandler):
    def __init__(self, port, *, wait_slice=0.01, transaction_timeout=0.1, clock=time.monotonic):
        super().__init__(port)
        if not all(math.isfinite(value) and value > 0 for value in (wait_slice, transaction_timeout)):
            raise ValueError("Serial wait limits must be finite and positive")
        if wait_slice > transaction_timeout:
            raise ValueError("Serial wait slice exceeds transaction timeout")
        self.wait_slice = wait_slice
        self.transaction_timeout = transaction_timeout
        self.clock = clock
        self._drain_wait = threading.Event().wait
        self._deadline = None
        self._cancel = None

    def getCurrentTime(self):
        return self.clock() * 1000.0

    def isPacketTimeout(self):
        if self.getTimeSinceStart() >= self.packet_timeout:
            self.packet_timeout = 0
            return True
        return False

    def setupPort(self, cflag_baud):
        opened = super().setupPort(cflag_baud)
        if opened:
            self.ser.timeout = self.wait_slice
            self.ser.write_timeout = self.transaction_timeout
        return opened

    def closePort(self):
        if self.ser is not None:
            super().closePort()
        self.is_open = False

    @contextmanager
    def transaction(self, cancel=None):
        if self._deadline is not None:
            raise RuntimeError("Serial transaction already active")
        if cancel is not None:
            cancel.check()
        self._deadline = self.clock() + self.transaction_timeout
        self._cancel = cancel
        try:
            yield
            self._remaining()
        finally:
            self.is_using = False
            self._deadline = None
            self._cancel = None

    def _remaining(self):
        if self._deadline is None:
            raise RuntimeError("Serial I/O requires a transaction")
        if self._cancel is not None:
            self._cancel.check()
        remaining = self._deadline - self.clock()
        if remaining <= 0:
            raise TimeoutError("Serial transaction deadline exceeded")
        if self._cancel is not None:
            remaining = min(remaining, self._cancel.deadline - self._cancel.clock())
            if remaining <= 0:
                self._cancel.check()
                raise TimeoutError("Control lease expired")
        return remaining

    def clearPort(self):
        self._remaining()
        while self.ser.out_waiting:
            duration = min(self.wait_slice, self._remaining())
            if self._cancel is None:
                self._drain_wait(duration)
            else:
                self._cancel.wait(duration)
        self._remaining()

    def writePort(self, packet):
        remaining = self._remaining()
        configured = getattr(self.ser, "write_timeout", None)
        if configured is None or not min(self.wait_slice, remaining) <= configured <= remaining:
            self.ser.write_timeout = remaining
        written = super().writePort(packet)
        self._remaining()
        return written

    def readPort(self, length):
        remaining = self._remaining()
        packet_remaining = (self.packet_start_time + self.packet_timeout - self.getCurrentTime()) / 1000.0
        if packet_remaining <= 0:
            return b""
        timeout = min(self.wait_slice, remaining, packet_remaining)
        if getattr(self.ser, "timeout", None) != timeout:
            self.ser.timeout = timeout
        received = super().readPort(length)
        self._remaining()
        if self.getTimeSinceStart() >= self.packet_timeout:
            return b""
        return received