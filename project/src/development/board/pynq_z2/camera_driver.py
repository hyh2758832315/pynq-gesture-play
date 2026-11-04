from __future__ import annotations

import time
from typing import Protocol


class MmioLike(Protocol):
    def read(self, offset: int = 0, length: int = 4) -> int: ...

    def write(self, offset: int, data: int) -> None: ...


class SccbError(RuntimeError):
    pass


def decode_camera_status(value: int) -> dict[str, int]:
    return {
        "scl": value & 0x1,
        "sda": (value >> 1) & 0x1,
        "data": (value >> 2) & 0xFF,
        "pclk": (value >> 10) & 0x1,
        "vsync": (value >> 11) & 0x1,
        "href": (value >> 12) & 0x1,
        "pclk_edges": (value >> 13) & 0x3F,
        "vsync_edges": (value >> 19) & 0x3F,
        "href_edges": (value >> 25) & 0x3F,
    }


class SccbBus:
    DATA_OFFSET = 0x0
    SAMPLE_OFFSET = 0x8

    SCL_LOW = 1 << 0
    SDA_LOW = 1 << 1
    XCLK_ENABLE = 1 << 2

    SCL_SAMPLE = 1 << 0
    SDA_SAMPLE = 1 << 1

    def __init__(
        self,
        mmio: MmioLike,
        *,
        half_period_s: float = 50e-6,
        clock_stretch_timeout_s: float = 0.05,
    ) -> None:
        if half_period_s <= 0:
            raise ValueError("half_period_s must be positive")
        self._mmio = mmio
        self._half_period_s = half_period_s
        self._clock_stretch_timeout_s = clock_stretch_timeout_s
        self._control = 0
        self._write_control()

    def _write_control(self) -> None:
        self._mmio.write(self.DATA_OFFSET, self._control)

    def _delay(self) -> None:
        time.sleep(self._half_period_s)

    def _set_low(self, mask: int, enabled: bool) -> None:
        if enabled:
            self._control |= mask
        else:
            self._control &= ~mask
        self._write_control()

    def _sample(self) -> int:
        return self._mmio.read(self.SAMPLE_OFFSET)

    def _release_scl(self) -> None:
        self._set_low(self.SCL_LOW, False)
        deadline = time.monotonic() + self._clock_stretch_timeout_s
        while not (self._sample() & self.SCL_SAMPLE):
            if time.monotonic() >= deadline:
                raise SccbError("SCL stayed low after release")

    def set_xclk_enabled(self, enabled: bool) -> None:
        if enabled:
            self._control |= self.XCLK_ENABLE
        else:
            self._control &= ~self.XCLK_ENABLE
        self._write_control()

    def release_bus(self) -> None:
        self._control &= ~(self.SCL_LOW | self.SDA_LOW)
        self._write_control()

    def recover(self) -> None:
        self.release_bus()
        for _ in range(9):
            self._set_low(self.SCL_LOW, True)
            self._delay()
            self._release_scl()
            self._delay()
        self.stop()

    def start(self) -> None:
        self.release_bus()
        self._release_scl()
        self._delay()
        self._set_low(self.SDA_LOW, True)
        self._delay()
        self._set_low(self.SCL_LOW, True)
        self._delay()

    def stop(self) -> None:
        self._set_low(self.SCL_LOW, True)
        self._set_low(self.SDA_LOW, True)
        self._delay()
        self._release_scl()
        self._delay()
        self._set_low(self.SDA_LOW, False)
        self._delay()

    def write_bit(self, value: int) -> None:
        self._set_low(self.SCL_LOW, True)
        self._set_low(self.SDA_LOW, not bool(value))
        self._delay()
        self._release_scl()
        self._delay()
        self._set_low(self.SCL_LOW, True)
        self._delay()

    def read_bit(self) -> int:
        self._set_low(self.SCL_LOW, True)
        self._set_low(self.SDA_LOW, False)
        self._delay()
        self._release_scl()
        self._delay()
        value = 1 if self._sample() & self.SDA_SAMPLE else 0
        self._set_low(self.SCL_LOW, True)
        self._delay()
        return value

    def write_byte(self, value: int) -> None:
        if not 0 <= value <= 0xFF:
            raise ValueError("SCCB byte must be in range 0..255")
        for shift in range(7, -1, -1):
            self.write_bit((value >> shift) & 1)
        if self.read_bit() != 0:
            raise SccbError(f"SCCB NACK after byte 0x{value:02X}")

    def read_byte(self, *, acknowledge: bool = False) -> int:
        value = 0
        for _ in range(8):
            value = (value << 1) | self.read_bit()
        self.write_bit(0 if acknowledge else 1)
        return value

    def read_register(self, device_address: int, register: int) -> int:
        if not 0 <= device_address <= 0x7F:
            raise ValueError("device_address must be a 7-bit address")
        if not 0 <= register <= 0xFFFF:
            raise ValueError("register must be a 16-bit address")

        self.start()
        try:
            self.write_byte(device_address << 1)
            self.write_byte(register >> 8)
            self.write_byte(register & 0xFF)
        finally:
            self.stop()

        self.start()
        try:
            self.write_byte((device_address << 1) | 1)
            return self.read_byte(acknowledge=False)
        finally:
            self.stop()

    def write_register(self, device_address: int, register: int, value: int) -> None:
        if not 0 <= device_address <= 0x7F:
            raise ValueError("device_address must be a 7-bit address")
        if not 0 <= register <= 0xFFFF:
            raise ValueError("register must be a 16-bit address")
        if not 0 <= value <= 0xFF:
            raise ValueError("value must be an 8-bit value")

        self.start()
        try:
            self.write_byte(device_address << 1)
            self.write_byte(register >> 8)
            self.write_byte(register & 0xFF)
            self.write_byte(value)
        finally:
            self.stop()

    def read_ov5640_chip_id(self) -> int:
        high = self.read_register(0x3C, 0x300A)
        low = self.read_register(0x3C, 0x300B)
        return (high << 8) | low
