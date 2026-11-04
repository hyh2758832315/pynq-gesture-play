from __future__ import annotations

from collections.abc import Callable
from dataclasses import dataclass
from typing import Protocol

from .controls import ControlSource, ControlState, MockControlAdapter, MockInput


GPIO_INPUT_MASK = 0x3F
BTN0_MASK = 1 << 0
BTN1_MASK = 1 << 1
BTN2_MASK = 1 << 2
BTN3_MASK = 1 << 3
SW0_MASK = 1 << 4
SW1_MASK = 1 << 5


class RawGpioReader(Protocol):
    def __call__(self) -> int: ...


@dataclass(frozen=True)
class GpioSample:
    raw_value: int
    stable_value: int | None


class PynqButtonAdapter:
    def __init__(
        self,
        read_raw: RawGpioReader,
        *,
        debounce_samples: int = 2,
    ) -> None:
        if debounce_samples < 2:
            raise ValueError("debounce_samples must be at least 2")
        self._read_raw = read_raw
        self._debounce_samples = debounce_samples
        self._candidate_value: int | None = None
        self._candidate_count = 0
        self._stable_value: int | None = None
        self._controls = MockControlAdapter(ControlSource.BUTTON)

    @property
    def source(self) -> ControlSource:
        return ControlSource.BUTTON

    @property
    def stable_value(self) -> int | None:
        return self._stable_value

    def sample(self) -> GpioSample:
        raw_value = self._read_value()
        if raw_value == self._candidate_value:
            self._candidate_count += 1
        else:
            self._candidate_value = raw_value
            self._candidate_count = 1
        if self._candidate_count >= self._debounce_samples:
            self._stable_value = raw_value
        return GpioSample(raw_value=raw_value, stable_value=self._stable_value)

    def read(self, *, tick_id: int, timestamp_ns: int) -> ControlState:
        stable_value = 0 if self._stable_value is None else self._stable_value
        return self._controls.sample(
            self._to_mock_input(stable_value),
            tick_id=tick_id,
            timestamp_ns=timestamp_ns,
        )

    @classmethod
    def from_overlay(cls, overlay: object, *, ip_name: str = "input_gpio") -> PynqButtonAdapter:
        try:
            description = overlay.ip_dict[ip_name]  # type: ignore[attr-defined]
        except (AttributeError, KeyError) as error:
            raise RuntimeError(f"overlay has no {ip_name!r} MMIO description") from error
        from pynq import MMIO

        mmio = MMIO(int(description["phys_addr"]), int(description["addr_range"]))
        return cls(lambda: mmio.read(0))

    def _read_value(self) -> int:
        value = self._read_raw()
        if not isinstance(value, int) or value < 0 or value & ~GPIO_INPUT_MASK:
            raise ValueError("GPIO reader must return a 6-bit non-negative integer")
        return value

    @staticmethod
    def _to_mock_input(value: int) -> MockInput:
        vertical_mode = bool(value & SW1_MASK)
        return MockInput(
            left=bool(value & BTN0_MASK) and not vertical_mode,
            right=bool(value & BTN1_MASK) and not vertical_mode,
            up=bool(value & BTN0_MASK) and vertical_mode,
            down=bool(value & BTN1_MASK) and vertical_mode,
            jump=bool(value & BTN2_MASK),
            shield=bool(value & SW0_MASK),
            attack=bool(value & BTN3_MASK),
        )