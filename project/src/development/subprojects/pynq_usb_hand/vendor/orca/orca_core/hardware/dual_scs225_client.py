import time
from typing import Sequence

import numpy as np

from ..constants import POSITION, CURRENT_BASED_POSITION, FEETECH, KNOWN_VIDS
from .motor_client import MotorClient, MotorRead
from .scs225_client import SCS225Client


DEFAULT_BUS_A_PORT = None
DEFAULT_BUS_B_PORT = None

DEFAULT_BUS_A_IDS = (2, 3, 4, 5, 6, 7, 8, 9)
DEFAULT_BUS_B_IDS = (1, 10, 11, 12, 13, 14, 15, 16, 17)


class DualSCS225Client(MotorClient):
    motor_type = "scs225"
    waits_for_motion = True
    supports_multi_turn = False
    supported_modes = frozenset({POSITION, CURRENT_BASED_POSITION})
    hardware_error_bits = SCS225Client.hardware_error_bits

    position_range_rad = SCS225Client.position_range_rad
    current_scale_ma = SCS225Client.current_scale_ma
    max_current_ma = SCS225Client.max_current_ma
    default_max_current_ma = SCS225Client.default_max_current_ma
    default_calibration_current_ma = SCS225Client.default_calibration_current_ma

    def __init__(
        self,
        motor_ids: Sequence[int],
        port: str = "dual",
        baudrate: int = 1_000_000,
        *,
        bus_a_port: str | None = DEFAULT_BUS_A_PORT,
        bus_b_port: str | None = DEFAULT_BUS_B_PORT,
        bus_a_ids: Sequence[int] = DEFAULT_BUS_A_IDS,
        bus_b_ids: Sequence[int] = DEFAULT_BUS_B_IDS,
    ):
        self.motor_ids = list(motor_ids)
        self.port_name = port
        self.baudrate = baudrate

        self.bus_a_ids = list(bus_a_ids)
        self.bus_b_ids = list(bus_b_ids)

        set_a = set(self.bus_a_ids)
        set_b = set(self.bus_b_ids)
        requested = set(self.motor_ids)

        overlap = set_a & set_b
        if overlap:
            raise ValueError(f"Motor IDs assigned to both buses: {sorted(overlap)}")

        missing = requested - (set_a | set_b)
        if missing:
            raise ValueError(f"Motor IDs have no bus assignment: {sorted(missing)}")

        self._id_to_bus = {mid: "a" for mid in self.bus_a_ids}
        self._id_to_bus.update({mid: "b" for mid in self.bus_b_ids})

        active_a = [mid for mid in self.motor_ids if mid in set_a]
        active_b = [mid for mid in self.motor_ids if mid in set_b]

        self._auto_bus_a = bus_a_port is None
        self._auto_bus_b = bus_b_port is None
        self.bus_a = SCS225Client(active_a, bus_a_port or "auto", baudrate)
        self.bus_b = SCS225Client(active_b, bus_b_port or "auto", baudrate)
        self._connected = False

    @staticmethod
    def _discover_ports(motor_ids, baudrate, bus_a_ids, bus_b_ids):
        from serial.tools import list_ports
        from scservo_sdk import COMM_SUCCESS, PortHandler, scscl

        groups = (set(motor_ids) & set(bus_a_ids), set(motor_ids) & set(bus_b_ids))
        if not all(groups):
            raise ValueError("Dual SCS225 transport requires motors on both buses")
        ports = sorted({
            info.device for info in list_ports.comports()
            if info.vid in KNOWN_VIDS.get(FEETECH, [])
        })
        locations = {motor_id: [] for motor_id in motor_ids}
        failures = []
        for port in ports:
            handler = PortHandler(port)
            opened = False
            try:
                opened = handler.openPort()
                if not opened or not handler.setBaudRate(baudrate):
                    failures.append(f"{port}: could not open or set baudrate")
                    continue
                servo = scscl(handler)
                for motor_id in locations:
                    _, result, _ = servo.ReadPos(motor_id)
                    if result == COMM_SUCCESS:
                        locations[motor_id].append(port)
            except OSError as exc:
                failures.append(f"{port}: {exc}")
            finally:
                if opened:
                    handler.closePort()

        missing = sorted(mid for mid, found in locations.items() if not found)
        duplicates = sorted(mid for mid, found in locations.items() if len(found) > 1)
        if missing or duplicates:
            raise OSError(
                f"Dual SCS225 discovery failed: missing IDs={missing}; "
                f"IDs on multiple ports={duplicates}; port errors={failures}"
            )
        resolved = [{locations[mid][0] for mid in group} for group in groups]
        if any(len(ports_for_bus) != 1 for ports_for_bus in resolved):
            raise OSError("Configured SCS225 bus groups span multiple ports")
        port_a, port_b = (next(iter(ports_for_bus)) for ports_for_bus in resolved)
        if port_a == port_b:
            raise OSError("Dual SCS225 transport requires two distinct serial ports")
        return port_a, port_b

    @classmethod
    def probe(cls, port: str, baudrate: int, motor_ids: Sequence[int]) -> bool:
        if port != "dual":
            return False
        cls._discover_ports(motor_ids, baudrate, DEFAULT_BUS_A_IDS, DEFAULT_BUS_B_IDS)
        return True

    def _resolve_ports(self):
        if not (self._auto_bus_a or self._auto_bus_b):
            return
        port_a, port_b = self._discover_ports(
            self.motor_ids, self.baudrate, self.bus_a_ids, self.bus_b_ids
        )
        for bus, found_port, automatic in (
            (self.bus_a, port_a, self._auto_bus_a),
            (self.bus_b, port_b, self._auto_bus_b),
        ):
            if not automatic and bus.port_name != found_port:
                raise OSError(
                    f"Pinned SCS225 port {bus.port_name} conflicts with detected {found_port}"
                )
        if self._auto_bus_a:
            self.bus_a = SCS225Client(self.bus_a.motor_ids, port_a, self.baudrate)
        if self._auto_bus_b:
            self.bus_b = SCS225Client(self.bus_b.motor_ids, port_b, self.baudrate)

    @property
    def is_connected(self) -> bool:
        return (
            self._connected
            and self.bus_a.is_connected
            and self.bus_b.is_connected
        )

    @property
    def last_read_ok(self) -> bool:
        return self.bus_a.last_read_ok and self.bus_b.last_read_ok

    def check_connected(self) -> None:
        if not self.is_connected:
            raise OSError("DualSCS225Client is not fully connected")

    def connect(self) -> None:
        if self._connected:
            raise RuntimeError("DualSCS225Client is already connected")

        self._resolve_ports()
        try:
            self.bus_a.connect()
            self.bus_b.connect()
            self._connected = True
        except Exception:
            for bus in (self.bus_a, self.bus_b):
                try:
                    if bus.is_connected:
                        bus.port_handler.closePort()
                except Exception:
                    pass
                finally:
                    bus._connected = False
                    bus.servo = None
            self._connected = False
            raise

    def disconnect(self) -> None:
        if not self._connected:
            return

        errors = []
        for bus in (self.bus_a, self.bus_b):
            try:
                bus.disconnect()
            except Exception as exc:
                errors.append(exc)

        self._connected = False

        if errors:
            raise RuntimeError(
                "One or more SCS225 buses failed to disconnect cleanly: "
                + "; ".join(str(e) for e in errors)
            )

    def _split_ids(self, motor_ids):
        ids_a, ids_b = [], []
        for motor_id in motor_ids:
            bus = self._id_to_bus.get(motor_id)
            if bus == "a":
                ids_a.append(motor_id)
            elif bus == "b":
                ids_b.append(motor_id)
            else:
                raise ValueError(f"Unknown SCS225 motor ID {motor_id}")
        return ids_a, ids_b

    def _split_ids_values(self, motor_ids, values):
        if len(motor_ids) != len(values):
            raise ValueError("motor_ids and values must have the same length")

        ids_a, vals_a, ids_b, vals_b = [], [], [], []

        for motor_id, value in zip(motor_ids, values):
            bus = self._id_to_bus.get(motor_id)
            if bus == "a":
                ids_a.append(motor_id)
                vals_a.append(value)
            elif bus == "b":
                ids_b.append(motor_id)
                vals_b.append(value)
            else:
                raise ValueError(f"Unknown SCS225 motor ID {motor_id}")

        return ids_a, vals_a, ids_b, vals_b

    def set_torque_enabled(self, motor_ids, enabled, retries=3, retry_interval=0.25):
        self.check_connected()
        ids_a, ids_b = self._split_ids(motor_ids)
        failed = []

        if ids_a:
            failed.extend(self.bus_a.set_torque_enabled(
                ids_a, enabled, retries=retries, retry_interval=retry_interval
            ))
        if ids_b:
            failed.extend(self.bus_b.set_torque_enabled(
                ids_b, enabled, retries=retries, retry_interval=retry_interval
            ))
        return failed

    def set_operating_mode(self, motor_ids, mode):
        self.check_connected()
        ids_a, ids_b = self._split_ids(motor_ids)
        if ids_a:
            self.bus_a.set_operating_mode(ids_a, mode)
        if ids_b:
            self.bus_b.set_operating_mode(ids_b, mode)

    def read_position_velocity_current(self) -> MotorRead:
        self.check_connected()
        state_a = self.bus_a.read_position_velocity_current()
        state_b = self.bus_b.read_position_velocity_current()

        by_id = {}
        for i, mid in enumerate(self.bus_a.motor_ids):
            by_id[mid] = (
                state_a.position[i], state_a.velocity[i], state_a.current[i]
            )
        for i, mid in enumerate(self.bus_b.motor_ids):
            by_id[mid] = (
                state_b.position[i], state_b.velocity[i], state_b.current[i]
            )

        return MotorRead(
            position=np.asarray([by_id[mid][0] for mid in self.motor_ids], dtype=float),
            velocity=np.asarray([by_id[mid][1] for mid in self.motor_ids], dtype=float),
            current=np.asarray([by_id[mid][2] for mid in self.motor_ids], dtype=float),
        )

    def read_hardware_error(self, motor_id: int) -> int | None:
        self.check_connected()
        ids_a, ids_b = self._split_ids([motor_id])
        bus = self.bus_a if ids_a else self.bus_b
        return bus.read_hardware_error(motor_id)

    def read_temperature(self) -> np.ndarray:
        self.check_connected()
        temp_a = self.bus_a.read_temperature()
        temp_b = self.bus_b.read_temperature()

        by_id = {}
        for i, mid in enumerate(self.bus_a.motor_ids):
            by_id[mid] = temp_a[i]
        for i, mid in enumerate(self.bus_b.motor_ids):
            by_id[mid] = temp_b[i]

        return np.asarray([by_id[mid] for mid in self.motor_ids], dtype=float)

    def write_desired_pos(self, motor_ids, positions):
        self.check_connected()
        ids_a, vals_a, ids_b, vals_b = self._split_ids_values(motor_ids, positions)
        if ids_a:
            self.bus_a.write_desired_pos(ids_a, np.asarray(vals_a, dtype=float))
        if ids_b:
            self.bus_b.write_desired_pos(ids_b, np.asarray(vals_b, dtype=float))

    def write_desired_current(self, motor_ids, currents):
        self.check_connected()
        ids_a, vals_a, ids_b, vals_b = self._split_ids_values(motor_ids, currents)
        if ids_a:
            self.bus_a.write_desired_current(ids_a, np.asarray(vals_a, dtype=float))
        if ids_b:
            self.bus_b.write_desired_current(ids_b, np.asarray(vals_b, dtype=float))

    def write_profile_velocity(self, motor_ids, profile_velocity):
        self.check_connected()
        ids_a, vals_a, ids_b, vals_b = self._split_ids_values(
            motor_ids, profile_velocity
        )
        if ids_a:
            self.bus_a.write_profile_velocity(ids_a, np.asarray(vals_a, dtype=float))
        if ids_b:
            self.bus_b.write_profile_velocity(ids_b, np.asarray(vals_b, dtype=float))

    def read_status_is_done_moving(self) -> bool:
        self.check_connected()
        return (
            self.bus_a.read_status_is_done_moving()
            and self.bus_b.read_status_is_done_moving()
        )

    def wait_for_motion_complete(self, timeout: float = 5.0) -> None:
        self.check_connected()
        deadline = time.monotonic() + timeout

        while time.monotonic() < deadline:
            if self.read_status_is_done_moving():
                return
            time.sleep(0.02)

        raise TimeoutError(
            f"Dual SCS225 motion did not complete within {timeout:.2f}s"
        )
