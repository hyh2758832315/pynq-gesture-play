"""Fraction-based scissors, rock and paper poses using the hand calibration."""

import math
import time
from collections.abc import Callable

from .base_hand import BaseHand
from .demo_poses import load_demo_poses
from .joint_position import OrcaJointPositions


GESTURE_SEQUENCE = ('scissors', 'rock', 'paper')


def build_gesture_poses(
    hand: BaseHand, *, wrist_position: float | None = None
) -> dict[str, OrcaJointPositions]:
    """Build joint-space poses; omitted wrists remain outside the targets."""
    if wrist_position is not None and not math.isfinite(wrist_position):
        raise ValueError('wrist_position must be finite.')
    demo = load_demo_poses()['main']
    opened = dict(demo.pose_fractions['open_hand'])
    closed = {**opened, **demo.pose_fractions['power_grasp']}
    closed['thumb_abd'] = 0.10
    closed['thumb_mcp'] = 0.80
    for joint in ('thumb_abd', 'thumb_mcp', 'thumb_dip'):
        if joint in hand.config.joint_roms_dict:
            lower, upper = hand.config.joint_roms_dict[joint]
            opened[joint] = min(1.0, max(0.0, -lower / (upper - lower)))
    fingers = ('index', 'middle', 'ring', 'pinky')
    for finger in fingers:
        for joint_type in ('mcp', 'pip'):
            joint = f'{finger}_{joint_type}'
            if joint in hand.config.joint_roms_dict:
                lower, upper = hand.config.joint_roms_dict[joint]
                opened[joint] = min(1.0, max(0.0, -lower / (upper - lower)))
    scissors = dict(closed)
    scissors['thumb_abd'] = opened['thumb_abd']
    for finger in ('index', 'middle'):
        for joint_type in ('mcp', 'pip'):
            joint = f'{finger}_{joint_type}'
            if joint in opened:
                scissors[joint] = opened[joint]
    for fractions in (scissors, closed):
        for finger in fingers:
            joint = f'{finger}_abd'
            if joint in hand.config.joint_roms_dict:
                lower, upper = hand.config.joint_roms_dict[joint]
                fractions[joint] = min(1.0, max(0.0, -lower / (upper - lower)))
    poses = {}
    for name, fractions in zip(GESTURE_SEQUENCE, (scissors, closed, opened)):
        fractions.pop('wrist', None)
        values = hand.pose_from_fractions(fractions).as_dict()
        values.pop('wrist', None)
        if wrist_position is not None and 'wrist' in hand.config.joint_ids:
            values['wrist'] = wrist_position
        poses[name] = hand.config.clamp_joint_positions(OrcaJointPositions.from_dict(values))
    return poses


def validate_gesture_options(
    *, cycles: int, num_steps: int, step_size: float, hold: float,
    timeout: float, tolerance: float,
) -> None:
    """Validate playback settings before a front-end connects or enables torque."""
    if isinstance(cycles, bool) or not isinstance(cycles, int) or cycles < 0:
        raise ValueError('cycles must be a non-negative integer.')
    if isinstance(num_steps, bool) or not isinstance(num_steps, int) or num_steps < 1:
        raise ValueError('num_steps must be a positive integer.')
    if any(not math.isfinite(value) or value < 0 for value in (step_size, hold)):
        raise ValueError('step_size and hold must be finite and non-negative.')
    if not math.isfinite(timeout) or timeout <= 0:
        raise ValueError('timeout must be finite and positive.')
    if not math.isfinite(tolerance) or not 0 < tolerance < 1:
        raise ValueError('tolerance must be between zero and one.')


def run_gesture_cycle(
    hand: BaseHand,
    *,
    cycles: int = 3,
    num_steps: int = 20,
    step_size: float = 0.03,
    hold: float = 1.0,
    timeout: float = 5.0,
    tolerance: float = 0.10,
    sequence: tuple[str, ...] = GESTURE_SEQUENCE,
    pose_overrides: dict[str, OrcaJointPositions] | None = None,
    tip_first_joints: tuple[str, ...] | None = None,
    tip_first_poses: tuple[str, ...] = ('rock',),
    progress_callback: Callable[[dict], None] | None = None,
) -> tuple[str, ...]:
    """Play calibrated gestures, holding only after fresh position convergence."""
    validate_gesture_options(
        cycles=cycles, num_steps=num_steps, step_size=step_size, hold=hold,
        timeout=timeout, tolerance=tolerance,
    )
    pose_overrides = {} if pose_overrides is None else dict(pose_overrides)
    known = set(GESTURE_SEQUENCE) | set(pose_overrides)
    if not sequence or any(name not in known for name in sequence):
        raise ValueError('sequence must contain known gesture names.')
    if any(name not in known for name in tip_first_poses):
        raise ValueError('tip_first_poses must contain known gesture names.')
    if tip_first_joints is not None:
        if not tip_first_joints or len(set(tip_first_joints)) != len(tip_first_joints):
            raise ValueError('tip_first_joints must contain distinct configured joints.')
        if set(tip_first_joints) - set(hand.config.joint_ids):
            raise ValueError('tip_first_joints must contain configured joints.')
    for name, pose in pose_overrides.items():
        values = pose.as_dict()
        if not name or set(values) != set(hand.config.joint_ids):
            raise ValueError('Pose overrides must contain every configured joint.')
        for joint, value in values.items():
            lower, upper = hand.config.joint_roms_dict[joint]
            if not math.isfinite(value) or not lower <= value <= upper:
                raise ValueError(f'Pose override {name} has an invalid {joint} target.')
    if cycles == 0:
        return ()

    def read_position():
        current = hand.get_joint_position().as_dict()
        if not getattr(hand, 'last_read_ok', True):
            raise RuntimeError('Gesture position read failed; stopping playback.')
        if set(hand.config.joint_ids) - current.keys():
            raise RuntimeError('Gesture position is missing configured joints.')
        if any(value is None or not math.isfinite(value) for value in current.values()):
            raise RuntimeError('Gesture position contains uncalibrated or invalid joints.')
        return current

    initial = read_position()
    poses = build_gesture_poses(hand, wrist_position=initial.get('wrist'))
    poses.update(pose_overrides)
    for name, pose in poses.items():
        hand.register_position(f'gesture_{name}', pose)

    def wait_for_target(label, target):
        deadline = time.monotonic() + timeout
        settled = 0
        max_error = math.inf
        while True:
            current = read_position()
            errors = []
            for joint, goal in target.items():
                if joint not in current:
                    raise RuntimeError(f'Gesture position is missing {joint}.')
                lower, upper = hand.config.joint_roms_dict[joint]
                errors.append(abs(current[joint] - goal) / (upper - lower))
            max_error = max(errors, default=0.0)
            settled = settled + 1 if max_error <= tolerance else 0
            if settled >= 3:
                return max_error
            if time.monotonic() >= deadline:
                raise TimeoutError(
                    f'{label} failed to reach target: maximum travel error '
                    f'{max_error:.1%}, tolerance {tolerance:.1%}.'
                )
            time.sleep(0.02)

    played = []
    for cycle in range(cycles):
        for name in sequence:
            current = read_position()
            target = poses[name].as_dict()
            closing_steps = num_steps
            tip_joints = ('index_pip',) if tip_first_joints is None else tip_first_joints
            legacy_supported = tip_first_joints is not None or 'index_mcp' in target
            if name in tip_first_poses and legacy_supported and set(tip_joints) <= target.keys():
                tip_target = dict(current)
                for joint in tip_joints:
                    tip_target[joint] = current[joint] + 0.5 * (target[joint] - current[joint])
                if name == 'rock' and 'thumb_abd' in target:
                    tip_target['thumb_abd'] = target['thumb_abd']
                tip_pose = hand.config.clamp_joint_positions(OrcaJointPositions.from_dict(tip_target))
                tip_name = f'gesture_{name}_tip_first'
                hand.register_position(tip_name, tip_pose)
                tip_steps = max(1, num_steps // 2)
                closing_steps = max(1, num_steps - tip_steps)
                hand.set_named_position(tip_name, num_steps=tip_steps, step_size=step_size)
                wait_for_target(f'{name} fingertip midpoint', tip_pose.as_dict())
            hand.set_named_position(f'gesture_{name}', num_steps=closing_steps, step_size=step_size)
            max_error = wait_for_target(name, target)
            if progress_callback is not None:
                progress_callback({
                    'event': 'pose_reached', 'pose': name, 'cycle': cycle + 1,
                    'max_travel_error': max_error,
                })
            time.sleep(hold)
            played.append(name)
    return tuple(played)