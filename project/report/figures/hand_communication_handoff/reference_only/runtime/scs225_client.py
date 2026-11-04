import logging
import time
from typing import Sequence

import numpy as np

from ..constants import POSITION, CURRENT_BASED_POSITION
from .motor_client import MotorClient, MotorRead
from scservo_sdk import PortHandler, scscl, COMM_SUCCESS


COUNTS_PER_REV = 4096.0
POS_SCALE = 2.0 * np.pi / COUNTS_PER_REV
VEL_SCALE = 0.732 * 2.0 * np.pi / 60.0
CURRENT_SCALE_MA = 6.5

ADDR_TORQUE_ENABLE = 0x28
ADDR_PRESENT_TEMPERATURE = 0x3F
ADDR_MOVING = 0x42
ADDR_PRESENT_CURRENT = 0x45
ADDR_TORQUE_LIMIT = 0x10

DEFAULT_MOVE_SPEED = 50
DEFAULT_NORMAL_TORQUE_LIMIT = 500
DEFAULT_CALIBRATION_TORQUE_LIMIT = 200
MAX_TORQUE_LIMIT = 1000


class SCS225Client(MotorClient):
    motor_type = "scs225"
    waits_for_motion = True
    supports_multi_turn = False
    supported_modes = frozenset({POSITION, CURRENT_BASED_POSITION})
    hardware_error_bits = (
        (0x01, "input_voltage"),
        (0x02, "angle_sensor"),
        (0x04, "overheating"),
        (0x08, "over_electrical"),
        (0x20, "overload"),
    )

    position_range_rad = (0.0, 2.0 * np.pi)
    current_scale_ma = CURRENT_SCALE_MA
    # Compatibility shim for Orca Core:
    # these three attributes are named in mA by the base API, but for SCS225
    # we intentionally interpret them as the servo's native torque-limit units.
    max_current_ma = float(MAX_TORQUE_LIMIT)
    default_max_current_ma = float(DEFAULT_NORMAL_TORQUE_LIMIT)
    default_calibration_current_ma = float(DEFAULT_CALIBRATION_TORQUE_LIMIT)

    def __init__(
        self,
        motor_ids: Sequence[int],
        port: str,
        baudrate: int = 1_000_000,
    ):
        self.motor_ids = list(motor_ids)
        self.port_name = port
        self.baudrate = baudrate
        self.port_handler = PortHandler(port)
        self.servo = None
        self._connected = False
        self._last_read_ok = False
        self._warned_current_noop = False
        self._motor_speed = {
            motor_id: DEFAULT_MOVE_SPEED for motor_id in self.motor_ids
        }

    @property
    def is_connected(self) -> bool:
        return self._connected

    @property
    def last_read_ok(self) -> bool:
        return self._last_read_ok

    def check_connected(self) -> None:
        if not self._connected or self.servo is None:
            raise OSError("Must call connect() first.")

    @staticmethod
    def probe(port: str, baudrate: int, motor_ids: Sequence[int]) -> bool:
        if port == "dual":
            from .dual_scs225_client import DualSCS225Client

            return DualSCS225Client.probe(port, baudrate, motor_ids)
        handler = PortHandler(port)
        opened = False
        try:
            opened = handler.openPort()
            if not opened or not handler.setBaudRate(baudrate):
                return False
            servo = scscl(handler)
            for motor_id in motor_ids:
                _, result, _ = servo.ReadPos(motor_id)
                if result == COMM_SUCCESS:
                    return True
            return False
        finally:
            if opened:
                handler.closePort()

    def connect(self) -> None:
        if self._connected:
            raise RuntimeError("SCS225Client is already connected")

        if not self.port_handler.openPort():
            raise OSError(f"Could not open port {self.port_name}")

        if not self.port_handler.setBaudRate(self.baudrate):
            self.port_handler.closePort()
            raise OSError(f"Could not set baudrate {self.baudrate}")

        self.servo = scscl(self.port_handler)
        self._connected = True

    def disconnect(self) -> None:
        if not self._connected:
            return

        try:
            self.set_torque_enabled(self.motor_ids, False, retries=0)
        except Exception:
            logging.exception("Failed to disable SCS225 torque during disconnect")
        finally:
            self.port_handler.closePort()
            self._connected = False
            self.servo = None

    def set_torque_enabled(
        self,
        motor_ids: Sequence[int],
        enabled: bool,
        retries: int = 3,
        retry_interval: float = 0.25,
    ) -> list[int]:
        self.check_connected()

        value = 1 if enabled else 0
        remaining = list(motor_ids)
        attempts = 0

        while remaining and (retries < 0 or attempts <= retries):
            failed = []

            for motor_id in remaining:
                if motor_id not in self.motor_ids:
                    failed.append(motor_id)
                    continue

                result, error = self.servo.write1ByteTxRx(
                    motor_id,
                    ADDR_TORQUE_ENABLE,
                    value,
                )

                if result != COMM_SUCCESS or error != 0:
                    failed.append(motor_id)

            remaining = failed

            if remaining:
                attempts += 1
                if retries < 0 or attempts <= retries:
                    time.sleep(retry_interval)

        return remaining

    def set_operating_mode(
        self,
        motor_ids: Sequence[int],
        mode: int,
    ) -> None:
        self.check_connected()

        unknown = [mid for mid in motor_ids if mid not in self.motor_ids]
        if unknown:
            raise ValueError(f"Unknown SCS225 motor IDs: {unknown}")

        logging.debug(
            "SCS225Client: ignoring Orca operating mode request %s; "
            "using native SCS position control",
            mode,
        )

    def read_position_velocity_current(self) -> MotorRead:
        self.check_connected()

        positions = []
        velocities = []
        currents = []
        all_ok = True

        for motor_id in self.motor_ids:
            pos, result, error = self.servo.ReadPos(motor_id)
            if result != COMM_SUCCESS:
                all_ok = False
                positions.append(np.nan)
            else:
                positions.append(float(pos) * POS_SCALE)

            speed, result, error = self.servo.ReadSpeed(motor_id)
            if result != COMM_SUCCESS:
                all_ok = False
                velocities.append(np.nan)
            else:
                velocities.append(float(speed) * VEL_SCALE)

            raw_current, result, error = self.servo.read2ByteTxRx(
                motor_id,
                ADDR_PRESENT_CURRENT,
            )
            if result != COMM_SUCCESS:
                all_ok = False
                currents.append(np.nan)
            else:
                currents.append(float(raw_current) * CURRENT_SCALE_MA)

        self._last_read_ok = all_ok

        return MotorRead(
            position=np.asarray(positions, dtype=float),
            velocity=np.asarray(velocities, dtype=float),
            current=np.asarray(currents, dtype=float),
        )

    def read_hardware_error(self, motor_id: int) -> int | None:
        self.check_connected()
        if motor_id not in self.motor_ids:
            raise ValueError(f"Unknown SCS225 motor ID {motor_id}")
        _, result, error = self.servo.ReadPos(motor_id)
        return int(error) if result == COMM_SUCCESS else None

    def read_temperature(self) -> np.ndarray:
        self.check_connected()

        temperatures = []

        for motor_id in self.motor_ids:
            temp, result, error = self.servo.read1ByteTxRx(
                motor_id,
                ADDR_PRESENT_TEMPERATURE,
            )
            temperatures.append(
                float(temp) if result == COMM_SUCCESS else np.nan
            )

        return np.asarray(temperatures, dtype=float)

    def write_desired_pos(
        self,
        motor_ids: Sequence[int],
        positions: np.ndarray,
    ) -> None:
        self.check_connected()

        if len(motor_ids) != len(positions):
            raise ValueError("motor_ids and positions must have the same length")

        for motor_id, position_rad in zip(motor_ids, positions):
            if motor_id not in self.motor_ids:
                raise ValueError(f"Unknown SCS225 motor ID {motor_id}")

            raw = int(round(float(position_rad) / POS_SCALE))
            raw = int(np.clip(raw, 0, 4095))

            result, error = self.servo.WritePos(
                motor_id,
                raw,
                0,
                int(self._motor_speed[motor_id]),
            )

            if result != COMM_SUCCESS or error != 0:
                raise OSError(
                    f"WritePos failed for ID {motor_id}: "
                    f"result={result} error={error}"
                )

    def write_desired_current(
        self,
        motor_ids: Sequence[int],
        currents: np.ndarray,
    ) -> None:
        """Accept limits already satisfied by the EEPROM torque ceiling."""
        self.check_connected()

        if len(motor_ids) != len(currents):
            raise ValueError("motor_ids and currents must have the same length")

        for motor_id, value in zip(motor_ids, currents):
            if motor_id not in self.motor_ids:
                raise ValueError(f"Unknown SCS225 motor ID {motor_id}")

            value = float(value)
            if not np.isfinite(value) or value < 0:
                raise ValueError("SCS225 torque limit must be finite and non-negative")

        limits = self.read_current_limits() if len(motor_ids) else {}
        for motor_id, requested in zip(motor_ids, currents):
            actual = limits[motor_id]
            if actual is None or actual > min(float(requested), MAX_TORQUE_LIMIT):
                raise NotImplementedError(
                    f"SCS225 ID {motor_id} EEPROM torque limit={actual}, requested={requested}. "
                    "Use explicit torque-disabled EEPROM setup and readback first; "
                    "runtime commands do not change persistent limits."
                )

    def configure_torque_limit(self, motor_id: int, value: int) -> None:
        """Explicitly persist a native torque ceiling while the motor is disabled."""
        self.check_connected()
        if motor_id not in self.motor_ids:
            raise ValueError(f"Unknown SCS225 motor ID {motor_id}")
        if not np.isfinite(value) or not 0 <= value <= MAX_TORQUE_LIMIT or int(value) != value:
            raise ValueError("SCS225 torque limit must be an integer from 0 to 1000")
        torque, result, error = self.servo.read1ByteTxRx(motor_id, ADDR_TORQUE_ENABLE)
        if result != COMM_SUCCESS or error != 0 or torque != 0:
            raise OSError("Disable SCS225 torque and verify status before EEPROM setup")
        lock, result, error = self.servo.read1ByteTxRx(motor_id, 48)
        if result != COMM_SUCCESS or error != 0 or lock not in (0, 1):
            raise OSError("Cannot read SCS225 EEPROM lock state")
        existing = self.read_current_limits()[motor_id]
        if existing is None:
            raise OSError("Cannot read SCS225 EEPROM torque limit")
        if existing == value:
            return
        try:
            result, error = self.servo.write1ByteTxRx(motor_id, 48, 0)
            if result != COMM_SUCCESS or error != 0:
                raise OSError("Cannot unlock SCS225 EEPROM")
            result, error = self.servo.write2ByteTxRx(motor_id, ADDR_TORQUE_LIMIT, int(value))
            if result != COMM_SUCCESS or error != 0:
                raise OSError("SCS225 EEPROM torque-limit write failed")
            if self.read_current_limits()[motor_id] != value:
                raise OSError("SCS225 EEPROM torque-limit readback mismatch")
        finally:
            result, error = self.servo.write1ByteTxRx(motor_id, 48, lock)
            if result != COMM_SUCCESS or error != 0:
                raise OSError("Cannot restore SCS225 EEPROM lock state")
        restored, result, error = self.servo.read1ByteTxRx(motor_id, 48)
        if result != COMM_SUCCESS or error != 0 or restored != lock:
            raise OSError("SCS225 EEPROM lock readback mismatch")

    def read_current_limits(self) -> dict[int, float | None]:
        """Read the EEPROM torque ceiling in native units, not milliamps."""
        self.check_connected()
        limits = {}
        for motor_id in self.motor_ids:
            value, result, error = self.servo.read2ByteTxRx(motor_id, ADDR_TORQUE_LIMIT)
            limits[motor_id] = (
                float(value)
                if result == COMM_SUCCESS and error == 0 and 0 <= value <= MAX_TORQUE_LIMIT
                else None
            )
        return limits

    def write_profile_velocity(
        self,
        motor_ids: Sequence[int],
        profile_velocity: np.ndarray,
    ) -> None:
        self.check_connected()

        if len(motor_ids) != len(profile_velocity):
            raise ValueError(
                "motor_ids and profile_velocity must have the same length"
            )

        for motor_id, speed in zip(motor_ids, profile_velocity):
            if motor_id not in self.motor_ids:
                raise ValueError(f"Unknown SCS225 motor ID {motor_id}")

            self._motor_speed[motor_id] = int(
                np.clip(round(float(speed)), 0, 32767)
            )

    def read_status_is_done_moving(self) -> bool:
        self.check_connected()

        for motor_id in self.motor_ids:
            moving, result, error = self.servo.read1ByteTxRx(
                motor_id,
                ADDR_MOVING,
            )

            if result != COMM_SUCCESS or moving != 0:
                return False

        return True

    def wait_for_motion_complete(self, timeout: float = 5.0) -> None:
        self.check_connected()

        deadline = time.monotonic() + timeout

        while time.monotonic() < deadline:
            if self.read_status_is_done_moving():
                return
            time.sleep(0.02)

        raise TimeoutError(
            f"SCS225 motion did not complete within {timeout:.2f}s"
        )
