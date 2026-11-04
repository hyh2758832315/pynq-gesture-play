#!/usr/bin/env python3
"""
Interactive OrcaHand pose editor.

Examples:
    1 +30
    1 +5
    14 -10
    thumb_abd +5
    save
    save 3
    reset
    show
    help
    quit

Meaning:
- First token = motor ID (1..17) OR joint name
- Second token = relative joint-angle change in degrees
- "save" stores the current raw Orca joint pose into orca_video_poses.json
- "reset" moves to the physically-correct neutral pose using the current zero offsets
"""

import json
import time
from pathlib import Path

from orca_core.hardware_hand import OrcaHand
from orca_core.hand_config import OrcaHandConfig


CONFIG = "orca_core/models/v2/orcahand-scs225-right/config.yaml"
POSE_FILE = Path("orca_video_poses.json")

TORQUE_LIMIT = 500

# Fast but still slightly smoothed motion.
MOVE_STEPS = 4
MOVE_STEP_SIZE = 0.008

# Motor ID -> logical joint
ID_TO_JOINT = {
    1: "wrist",
    2: "index_pip",
    3: "index_mcp",
    4: "index_abd",
    5: "middle_abd",
    6: "ring_abd",
    7: "ring_mcp",
    8: "ring_pip",
    9: "middle_pip",
    10: "middle_mcp",
    11: "pinky_pip",
    12: "pinky_mcp",
    13: "pinky_abd",
    14: "thumb_abd",
    15: "thumb_mcp",
    16: "thumb_dip",
    17: "thumb_cmc",
}

# Physical neutral correction discovered from your hand.
# "reset" commands these Orca-frame joint values so the real hand is visually neutral.
JOINT_ZERO_OFFSET_DEG = {
    "wrist": 0.0,

    "thumb_cmc": 0.0,
    "thumb_abd": -25.0,
    "thumb_mcp": 0.0,
    "thumb_dip": -10.0,

    "index_abd": 0.0,
    "index_mcp": 0.0,
    "index_pip": 0.0,

    "middle_abd": 0.0,
    "middle_mcp": 0.0,
    "middle_pip": 10.0,

    "ring_abd": -10.0,
    "ring_mcp": 0.0,
    "ring_pip": 0.0,

    "pinky_abd": 5.0,
    "pinky_mcp": 0.0,
    "pinky_pip": 0.0,
}


def load_pose_file():
    if not POSE_FILE.exists():
        return {
            "format": 1,
            "description": "Raw Orca Core joint positions captured from physical hand",
            "poses": {},
        }

    try:
        data = json.loads(POSE_FILE.read_text())
        if "poses" not in data:
            data["poses"] = {}
        return data
    except Exception:
        return {
            "format": 1,
            "description": "Raw Orca Core joint positions captured from physical hand",
            "poses": {},
        }


def get_current_pose(hand):
    p = hand.get_joint_position().as_dict()
    return {
        joint: round(float(value), 4)
        for joint, value in p.items()
        if value is not None
    }


def show_pose(hand):
    p = get_current_pose(hand)

    print("\nCurrent pose:")
    print(" ID   joint          deg")
    print("----  -------------  --------")

    for motor_id in range(1, 18):
        joint = ID_TO_JOINT[motor_id]
        value = p.get(joint)

        if value is None:
            txt = "None"
        else:
            txt = f"{value:+8.2f}"

        print(f"{motor_id:>2}    {joint:<13}  {txt}")
    print()


def resolve_joint(token):
    try:
        motor_id = int(token)
        if motor_id not in ID_TO_JOINT:
            raise ValueError
        return ID_TO_JOINT[motor_id], motor_id
    except ValueError:
        if token in ID_TO_JOINT.values():
            motor_id = next(k for k, v in ID_TO_JOINT.items() if v == token)
            return token, motor_id

    raise ValueError(f"Unknown motor ID/joint: {token}")


def move_relative(hand, joint, delta_deg):
    current = hand.get_joint_position().as_dict()
    current_deg = float(current[joint])
    target_deg = current_deg + delta_deg

    print(
        f"{joint}: {current_deg:+.2f}° "
        f"{delta_deg:+.2f}° -> {target_deg:+.2f}°"
    )

    hand.set_joint_positions(
        {joint: target_deg},
        num_steps=MOVE_STEPS,
        step_size=MOVE_STEP_SIZE,
    )

    time.sleep(0.08)

    actual = hand.get_joint_position().as_dict()[joint]
    print(f"actual: {float(actual):+.2f}°")


def reset_neutral(hand):
    print("\nMoving to physical neutral...")

    hand.set_joint_positions(
        JOINT_ZERO_OFFSET_DEG,
        num_steps=8,
        step_size=0.008,
    )

    time.sleep(0.2)
    print("Neutral reached.\n")


def save_pose(hand, requested_number=None):
    data = load_pose_file()
    poses = data["poses"]

    if requested_number is None:
        existing = [int(k) for k in poses.keys() if str(k).isdigit()]
        number = (max(existing) + 1) if existing else 1
    else:
        number = requested_number

    pose = get_current_pose(hand)
    poses[str(number)] = pose

    POSE_FILE.write_text(json.dumps(data, indent=2))

    print(f"\nSaved POSE {number}")
    print(f"File: {POSE_FILE.resolve()}\n")


def print_saved_poses():
    data = load_pose_file()
    poses = data["poses"]

    if not poses:
        print("\nNo saved poses.\n")
        return

    print("\nSaved poses:")
    for key in sorted(poses.keys(), key=lambda x: int(x) if x.isdigit() else 999):
        print(f"  POSE {key}")
    print()


def print_help():
    print(r"""
Commands:

  1 +30
      Move motor ID 1 joint +30 degrees RELATIVE to current position.

  14 -10
      Move motor ID 14 (thumb_abd) -10 degrees.

  thumb_abd +5
      Joint names also work.

  save
      Save current 17-joint pose as next pose number.

  save 3
      Save/overwrite POSE 3.

  reset
      Move back to your physically-correct neutral pose.

  show
      Print all current joint positions.

  list
      List saved poses.

  help
      Show this help.

  quit
      Disable torque and exit.
""")


def main():
    cfg = OrcaHandConfig.from_config_path(CONFIG)
    cfg.validate_config()

    hand = OrcaHand(config=cfg)

    try:
        ok, msg = hand.connect(interactive=False)
        print("connect:", ok, msg)
        if not ok:
            raise RuntimeError(msg)

        hand.enable_torque()
        hand.set_max_current(TORQUE_LIMIT)

        print("\nInteractive OrcaHand pose editor")
        print("Torque limit:", TORQUE_LIMIT)
        print("Type 'help' for commands.\n")

        show_pose(hand)

        while True:
            try:
                line = input("orca> ").strip()
            except EOFError:
                break

            if not line:
                continue

            parts = line.split()
            cmd = parts[0].lower()

            if cmd in {"quit", "exit", "q"}:
                break

            if cmd == "help":
                print_help()
                continue

            if cmd == "show":
                show_pose(hand)
                continue

            if cmd == "list":
                print_saved_poses()
                continue

            if cmd == "reset":
                reset_neutral(hand)
                continue

            if cmd == "save":
                if len(parts) == 1:
                    save_pose(hand)
                elif len(parts) == 2:
                    try:
                        save_pose(hand, int(parts[1]))
                    except ValueError:
                        print("Usage: save   OR   save 3")
                else:
                    print("Usage: save   OR   save 3")
                continue

            if len(parts) == 2:
                try:
                    joint, motor_id = resolve_joint(parts[0])
                    delta = float(parts[1])

                    print(f"ID {motor_id} -> {joint}")
                    move_relative(hand, joint, delta)

                except Exception as exc:
                    print("ERROR:", exc)

                continue

            print("Unknown command. Type 'help'.")

    except KeyboardInterrupt:
        print("\nStopped by user.")

    finally:
        try:
            hand.disable_torque()
        except Exception:
            pass

        hand.disconnect()
        print("disconnected")


if __name__ == "__main__":
    main()
