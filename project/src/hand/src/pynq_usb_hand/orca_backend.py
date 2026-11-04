from dataclasses import dataclass
import math
import os
from pathlib import Path
import time

from .assets import import_orca
from .motion import Snapshot


class OrcaModel:
    def __init__(self, root: Path):
        import_orca(root)
        from orca_core.hand_factory import load_hand
        from orca_core.control.manual_motor import load_motor_pose
        from orca_core.gestures import build_gesture_poses
        from orca_core.hardware.scs225_client import SCS225Client

        assets = root / "assets"
        self.hand = load_hand(config_path=str(assets / "config.yaml"),
                              calibration_path=str(assets / "calibration.yaml"),
                              port="offline", engage_feedback=False, engage_sensors=False)
        self.ids = tuple(self.hand.config.motor_ids)
        if len(self.ids) != 17 or len(set(self.ids)) != 17 or any(type(motor_id) is not int or motor_id <= 0 for motor_id in self.ids):
            raise ValueError("Expected all 17 unique motor IDs")
        if self.hand.config.motor_type != "scs225" or not self.hand.is_calibrated():
            raise ValueError("A calibrated SCS225 hand is required")
        self.bounds = {motor_id: tuple(sorted(self.hand.motor_limits_dict[motor_id])) for motor_id in self.ids}
        self.roms = dict(self.hand.config.joint_roms_dict)
        self.hand._motor_client = SCS225Client(self.ids, "offline", self.hand.config.baudrate)
        joint_names = self.hand.config.motor_to_joint_dict
        inversions = self.hand.config.joint_inversion_dict
        limits = self.hand.motor_limits_dict
        ratios = self.hand.calibration.joint_to_motor_ratios_dict
        joint_roms = self.hand.effective_joint_roms_dict
        if {joint_names[motor_id] for motor_id in self.ids} != set(self.roms):
            raise ValueError("Motor mapping must cover every joint")
        if self.hand._wrap_offsets_dict is None:
            self.hand._compute_wrap_offsets_dict()
        mapping = []
        for motor_id in self.ids:
            joint = joint_names[motor_id]
            inverted = inversions.get(joint, False)
            origin = joint_roms[joint][1 if inverted else 0]
            offset = self.hand._wrap_offsets_dict.get(motor_id, 0.0)
            ratio = ratios[motor_id]
            if not all(math.isfinite(value) for value in (limits[motor_id][0], origin, offset, ratio)) or ratio == 0:
                raise ValueError(f"Invalid motor mapping ID {motor_id}")
            mapping.append((motor_id, joint, limits[motor_id][0], origin, ratio, inverted, offset))
        self._motor_mapping = tuple(mapping)
        default = self.to_joint(load_motor_pose(self.hand, assets / "default-captured.txt"))
        paper = self.to_joint(load_motor_pose(self.hand, assets / "paper-captured.txt"))
        old = build_gesture_poses(self.hand, wrist_position=default["wrist"])
        self.poses = {"default": default, "paper": paper, "scissors": old["scissors"].as_dict(), "rock": old["rock"].as_dict()}
        for target in self.poses.values():
            self.to_motor(target)

    def to_joint(self, motor):
        if set(motor) != set(self.ids):
            raise ValueError("Incomplete motor sample")
        result = {}
        for motor_id, joint, motor_lower, origin, ratio, inverted, offset in self._motor_mapping:
            wrapped = motor[motor_id] - offset
            difference = (wrapped - motor_lower) / ratio
            result[joint] = origin - difference if inverted else origin + difference
        return result

    def to_motor(self, joints):
        if set(joints) != set(self.roms):
            raise ValueError("Incomplete joint target")
        for joint, value in joints.items():
            lower, upper = self.roms[joint]
            if not math.isfinite(value) or not lower - 1e-6 <= value <= upper + 1e-6:
                raise ValueError(f"Joint outside ROM: {joint}")
        result = {}
        for motor_id, joint, motor_lower, origin, ratio, inverted, offset in self._motor_mapping:
            difference = origin - joints[joint] if inverted else joints[joint] - origin
            position = motor_lower + difference * ratio
            position += offset
            lower, upper = self.bounds[motor_id]
            if position is None or not math.isfinite(position) or not lower - 1e-8 <= position <= upper + 1e-8:
                raise ValueError(f"Motor target outside calibration: {motor_id}")
            result[motor_id] = float(position)
        return result


@dataclass(frozen=True)
class SafetyPolicy:
    max_temperature: float
    max_scan_age: float

    def __post_init__(self):
        if not math.isfinite(self.max_temperature) or not 0 < self.max_temperature < 100:
            raise ValueError("A reviewed temperature limit is required")
        if not math.isfinite(self.max_scan_age) or self.max_scan_age <= 0:
            raise ValueError("A measured feedback age limit is required")


class OrcaBackend:
    def __init__(self, model: OrcaModel, port: str, policy: SafetyPolicy, *, skip_unchanged=False, speed=500,
                 allow_stage_targets=False, allow_playback=False):
        if type(speed) is not int or not 1 <= speed <= 32767:
            raise ValueError("Servo speed must be an integer from 1 to 32767")
        if type(allow_stage_targets) is not bool or (allow_stage_targets and speed != 500):
            raise ValueError("Authorized native stage targets require speed500")
        if type(allow_playback) is not bool or (allow_playback and not allow_stage_targets):
            raise ValueError("Fixed playback requires explicit native stage authorization")
        from .transport import BoundedPortHandler

        self.stage_targets_authorized = allow_stage_targets
        self.playback_authorized = allow_playback
        self.model = model
        self.poses = model.poses
        self.roms = model.roms
        self.port = port
        self.policy = policy
        self.client = model.hand.motor_client
        self.sequence = 0
        self.expected_torque = 0
        self.lock_fd = None
        self.health = {}
        self.skip_unchanged = skip_unchanged
        self.speed = speed
        self.last_targets = {}
        self.transport = BoundedPortHandler(port)
        self.client.port_handler = self.transport

    def connect(self, cancel):
        self.last_targets.clear()
        if os.name != "posix" or not self.port.startswith("/dev/"):
            raise ValueError("Hardware mode requires an explicit Linux /dev serial device")
        import fcntl
        resolved = str(Path(self.port).resolve(strict=True))
        self.lock_fd = os.open(resolved, os.O_RDWR | os.O_NOCTTY | os.O_NONBLOCK)
        fcntl.flock(self.lock_fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
        cancel.check()
        self.client.port_name = resolved
        self.client.port_handler.port_name = resolved
        self.client.connect()
        from .transport import BoundedSCSCL

        self.client.servo = BoundedSCSCL(self.transport)
        self.check_connected_position(cancel)

    def check_connected_position(self, cancel):
        self.sample(cancel)

    @staticmethod
    def checked(result, motor_id, field):
        value, communication, error = result
        if communication != 0 or error != 0:
            raise OSError(f"ID {motor_id} {field}: communication={communication} error={error}")
        return value

    def read(self, method, motor_id, cancel, field, *arguments):
        cancel.check()
        with self.transport.transaction(cancel):
            value = self.checked(method(motor_id, *arguments), motor_id, field)
        cancel.check()
        return value

    def read_motor_positions(self, cancel, *, bounds=None, torques=None):
        # Only the startup recovery subclass supplies narrower motion corridors
        # or a bounded OFF-only preflight allowance. Normal samples stay strict.
        bounds = self.model.bounds if bounds is None else bounds
        torques = dict.fromkeys(self.model.ids, self.expected_torque) if torques is None else torques
        started = time.monotonic()
        motor = {}
        health = {}
        servo = self.client.servo
        for motor_id in self.model.ids:
            registers = self.read(servo.readTxRx, motor_id, cancel, "feedback", 16, 48)
            if len(registers) != 48 or (type(registers) not in (bytes, bytearray)
                                       and any(type(value) is not int or not 0 <= value <= 255 for value in registers)):
                raise OSError(f"Invalid feedback block ID {motor_id}")
            raw = servo.scs_makeword(registers[40], registers[41])
            if type(raw) is not int or not 0 <= raw <= 4095:
                raise ValueError(f"Invalid position ID {motor_id}")
            position = raw * 2 * math.pi / 4096
            lower, upper = bounds[motor_id]
            if not lower <= position <= upper:
                raise ValueError(f"Feedback outside motor limits ID {motor_id}")
            voltage = registers[46] / 10.0
            temperature = registers[47]
            torque = registers[24]
            limit = servo.scs_makeword(registers[0], registers[1])
            if not 4.0 <= voltage <= 9.0:
                raise OSError(f"Voltage protection ID {motor_id}: {voltage}")
            if not 0 <= temperature < self.policy.max_temperature:
                raise OSError(f"Temperature protection ID {motor_id}: {temperature}")
            if torque != torques[motor_id] or limit != 1000:
                raise OSError(f"Unexpected torque/limit ID {motor_id}: {torque}/{limit}")
            motor[motor_id] = position
            health[motor_id] = {"voltage": voltage, "temperature": temperature, "torque": torque}
        finished = time.monotonic()
        if finished - started > self.policy.max_scan_age:
            raise TimeoutError("Complete safety scan exceeded approved age")
        self.health = health
        return started, finished, motor

    def sample(self, cancel):
        started, finished, motor = self.read_motor_positions(cancel)
        self.sequence += 1
        return Snapshot(self.sequence, started, finished, self.model.to_joint(motor))

    def arm(self, cancel):
        self.last_targets.clear()
        self.expected_torque = 0
        current = self.sample(cancel)
        self.client.write_profile_velocity(list(self.model.ids), [self.speed] * len(self.model.ids))
        self.write(current.joints, cancel)
        for motor_id in self.model.ids:
            cancel.check()
            with self.transport.transaction(cancel):
                communication, error = self.client.servo.write1ByteTxRx(motor_id, 40, 1)
                self.checked((1, communication, error), motor_id, "enable")
            cancel.check()
        self.expected_torque = 1
        self.sample(cancel)

    def compile_target(self, target):
        from orca_core.hardware.scs225_client import POS_SCALE

        if not self.playback_authorized:
            raise ValueError("Fixed playback is not authorized")
        positions = self.model.to_motor(target)
        commands = []
        for motor_id in self.model.ids:
            raw = int(round(positions[motor_id] / POS_SCALE))
            if not 0 <= raw <= 4095:
                raise ValueError(f"Raw playback target outside encoder range ID {motor_id}")
            commands.append((motor_id, raw, self.speed))
        return tuple(commands)

    def write_compiled(self, target, cancel):
        if not self.playback_authorized or self.expected_torque != 1 or not self.client.is_connected:
            raise RuntimeError("Playback requires an authorized enabled connection")
        try:
            for motor_id, raw, speed in target:
                cancel.check()
                command = (raw, speed)
                if self.skip_unchanged and self.last_targets.get(motor_id) == command:
                    continue
                with self.transport.transaction(cancel):
                    communication, error = self.client.servo.WritePos(motor_id, raw, 0, speed)
                    self.checked((raw, communication, error), motor_id, "playback_position")
                cancel.check()
                self.last_targets[motor_id] = command
        except BaseException:
            self.last_targets.clear()
            raise

    def write(self, target, cancel):
        from orca_core.hardware.scs225_client import POS_SCALE

        try:
            cancel.check()
            positions = self.model.to_motor(target)
            reuse = self.skip_unchanged and self.expected_torque == 1 and self.client.is_connected
            if not reuse:
                self.last_targets.clear()
            for motor_id in self.model.ids:
                cancel.check()
                command = None
                if reuse:
                    raw = int(round(float(positions[motor_id]) / POS_SCALE))
                    if not 0 <= raw <= 4095:
                        raise ValueError(f"Raw target outside encoder range ID {motor_id}")
                    command = (raw, self.client._motor_speed[motor_id])
                    if self.last_targets.get(motor_id) == command:
                        continue
                with self.transport.transaction(cancel):
                    if reuse:
                        communication, error = self.client.servo.WritePos(motor_id, raw, 0, int(command[1]))
                        self.checked((raw, communication, error), motor_id, "position")
                    else:
                        self.client.write_desired_pos([motor_id], [positions[motor_id]])
                cancel.check()
                if reuse:
                    self.last_targets[motor_id] = command
        except BaseException:
            self.last_targets.clear()
            raise

    def release(self):
        self.last_targets.clear()
        failed = set()
        if not self.client.is_connected:
            return self.model.ids
        for motor_id in self.model.ids:
            try:
                with self.transport.transaction():
                    communication, error = self.client.servo.write1ByteTxRx(motor_id, 40, 0)
                    self.checked((0, communication, error), motor_id, "release")
            except Exception:
                failed.add(motor_id)
        for motor_id in self.model.ids:
            try:
                with self.transport.transaction():
                    value = self.checked(self.client.servo.read1ByteTxRx(motor_id, 40), motor_id, "release_readback")
                if value != 0:
                    failed.add(motor_id)
            except Exception:
                failed.add(motor_id)
        self.expected_torque = 0
        return tuple(sorted(failed))

    def close(self):
        self.last_targets.clear()
        try:
            self.client.port_handler.closePort()
            self.client._connected = False
            self.client.servo = None
            self.model.hand._motor_client = None
        finally:
            if self.lock_fd is not None:
                os.close(self.lock_fd)
                self.lock_fd = None
