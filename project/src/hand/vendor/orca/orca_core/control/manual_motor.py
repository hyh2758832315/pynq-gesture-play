"""Calibrated motor-space control and measured gesture snapshots."""

import csv
import hashlib
import io
import math
import os
import tempfile
from datetime import datetime, timezone
from pathlib import Path

import numpy as np


def load_motor_pose(hand, source):
    """Read a measured motor pose bound to the hand's active calibration."""
    lines = Path(source).read_text(encoding='utf-8-sig').splitlines()
    if not lines or lines[0] != 'ORCA_GESTURE_V1' or '' not in lines:
        raise ValueError('Unsupported or incomplete motor pose file.')
    separator = lines.index('')
    metadata = {}
    for line in lines[1:separator]:
        key, marker, value = line.partition('=')
        if not marker or key in metadata:
            raise ValueError('Invalid motor pose metadata.')
        metadata[key] = value
    expected_sha = hashlib.sha256(Path(hand.config.calibration_path).read_bytes()).hexdigest()
    if metadata.get('calibration_sha256') != expected_sha:
        raise ValueError('Motor pose calibration does not match the active hand.')
    if metadata.get('position_source') != 'motor_feedback':
        raise ValueError('Motor pose must contain measured motor feedback.')
    reader = csv.DictReader(io.StringIO('\n'.join(lines[separator + 1:])), delimiter='\t')
    columns = ['motor_id', 'joint', 'position_rad', 'position_deg', 'target_rad', 'lower_rad', 'upper_rad']
    if reader.fieldnames != columns:
        raise ValueError('Unexpected motor pose columns or units.')
    control = CalibratedMotorControl(hand)
    positions = {}
    for row in reader:
        if None in row or any(value is None for value in row.values()):
            raise ValueError('Incomplete motor pose row.')
        motor_id = int(row['motor_id'])
        if motor_id not in control.bounds or motor_id in positions:
            raise ValueError(f'Duplicate or unknown motor ID: {motor_id}.')
        if row['joint'] != hand.config.motor_to_joint_dict[motor_id]:
            raise ValueError(f'Motor {motor_id} joint mapping does not match.')
        values = {key: float(row[key]) for key in columns[2:]}
        if any(not math.isfinite(value) for value in values.values()):
            raise ValueError(f'Motor {motor_id} contains non-finite values.')
        lower, upper = control.bounds[motor_id]
        if not (math.isclose(values['lower_rad'], lower, abs_tol=1e-9, rel_tol=0)
                and math.isclose(values['upper_rad'], upper, abs_tol=1e-9, rel_tol=0)):
            raise ValueError(f'Motor {motor_id} limits do not match calibration.')
        position = values['position_rad']
        if not lower - 1e-9 <= position <= upper + 1e-9:
            raise ValueError(f'Motor {motor_id} measured position is outside calibration.')
        if not math.isclose(values['position_deg'], math.degrees(position), abs_tol=1e-6, rel_tol=0):
            raise ValueError(f'Motor {motor_id} position units disagree.')
        positions[motor_id] = min(upper, max(lower, position))
    if set(positions) != set(control.motor_ids):
        raise ValueError('Motor pose must contain every configured motor exactly once.')
    return {motor_id: positions[motor_id] for motor_id in control.motor_ids}


class CalibratedMotorControl:
    def __init__(self, hand, *, speed=500):
        if isinstance(speed, bool) or not isinstance(speed, int) or not 1 <= speed <= 500:
            raise ValueError('Manual speed must be an integer from 1 to 500.')
        self.hand = hand
        self.speed = speed
        self.motor_ids = tuple(hand.config.motor_ids)
        self.bounds = {}
        for motor_id in self.motor_ids:
            limits = hand.motor_limits_dict.get(motor_id)
            if limits is None or len(limits) != 2:
                raise ValueError(f'Motor {motor_id} has no complete calibration.')
            if any(value is None or not math.isfinite(value) for value in limits):
                raise ValueError(f'Motor {motor_id} has invalid calibration.')
            lower, upper = sorted(float(value) for value in limits)
            if lower == upper:
                raise ValueError(f'Motor {motor_id} has zero calibrated travel.')
            self.bounds[motor_id] = (lower, upper)
        self.targets = {}
        self.enabled = False

    def read_positions(self):
        positions = self.hand.get_motor_pos(as_dict=True)
        if not self.hand.last_read_ok or set(positions) != set(self.motor_ids):
            raise OSError('Incomplete motor feedback; control stopped.')
        if any(not math.isfinite(value) for value in positions.values()):
            raise OSError('Invalid motor feedback; control stopped.')
        for motor_id in self.motor_ids:
            error = self.hand.motor_client.read_hardware_error(motor_id)
            if error is None or error != 0:
                raise OSError(f'Motor {motor_id} hardware status: {error}.')
        return {motor_id: float(positions[motor_id]) for motor_id in self.motor_ids}

    def release(self):
        self.enabled = False
        failed = self.hand.disable_torque()
        if failed:
            raise OSError(f'Torque release not acknowledged: {failed}.')

    def enable(self):
        self.release()
        try:
            positions = self.read_positions()
            for motor_id, position in positions.items():
                lower, upper = self.bounds[motor_id]
                if not lower <= position <= upper:
                    raise ValueError(f'Motor {motor_id} is outside its calibrated range.')
            self.hand.set_control_mode(self.hand.config.control_mode)
            self.hand.set_max_current(self.hand.config.max_current)
            self.hand.motor_client.write_profile_velocity(
                list(self.motor_ids), np.full(len(self.motor_ids), self.speed, dtype=float),
            )
            self.hand.write_motor_pos(list(self.motor_ids), np.array(list(positions.values())))
            failed = self.hand.enable_torque()
            if failed:
                raise OSError(f'Torque enable not acknowledged: {failed}.')
            self.targets = dict(positions)
            self.enabled = True
            return positions
        except Exception:
            self.release()
            raise

    def move(self, motor_id, percent):
        if not self.enabled:
            raise RuntimeError('Enable motor control before moving a slider.')
        if motor_id not in self.bounds or not math.isfinite(percent) or not 0 <= percent <= 100:
            raise ValueError('Motor target must be inside its calibrated range.')
        lower, upper = self.bounds[motor_id]
        target = min(upper, max(lower, lower + percent / 100 * (upper - lower)))
        try:
            self.read_positions()
            self.hand.write_motor_pos([motor_id], np.array([target]))
        except Exception:
            self.release()
            raise
        self.targets[motor_id] = target

    def export(self, destination, *, name=''):
        if any(character in name for character in '\r\n\t'):
            raise ValueError('Gesture name must occupy a single line.')
        positions = self.read_positions()
        calibration = Path(self.hand.config.calibration_path)
        lines = [
            'ORCA_GESTURE_V1', f'name={name}',
            'captured_utc=' + datetime.now(timezone.utc).isoformat(),
            'position_source=motor_feedback',
            'calibration_sha256=' + hashlib.sha256(calibration.read_bytes()).hexdigest(),
            '', 'motor_id\tjoint\tposition_rad\tposition_deg\ttarget_rad\tlower_rad\tupper_rad',
        ]
        for motor_id, position in positions.items():
            lower, upper = self.bounds[motor_id]
            joint = self.hand.config.motor_to_joint_dict[motor_id]
            target = self.targets.get(motor_id, position)
            lines.append(f'{motor_id}\t{joint}\t{position:.9f}\t{math.degrees(position):.6f}'
                         f'\t{target:.9f}\t{lower:.9f}\t{upper:.9f}')
        destination = Path(destination)
        temporary = None
        try:
            with tempfile.NamedTemporaryFile(
                mode='w', encoding='utf-8', newline='\n', dir=destination.parent,
                prefix='.' + destination.name, suffix='.tmp', delete=False,
            ) as stream:
                temporary = Path(stream.name)
                stream.write('\n'.join(lines) + '\n')
                stream.flush()
                os.fsync(stream.fileno())
            temporary.replace(destination)
        finally:
            if temporary is not None:
                temporary.unlink(missing_ok=True)
        return positions

    def close(self):
        try:
            self.release()
        finally:
            success, message = self.hand.disconnect()
            if not success:
                raise OSError(message)