#!/usr/bin/env python3
"""
OrcaHand 5-pose recorder/player with RViz synchronization.

Modes:
  record       - torque OFF; manually pose the hand and press Enter to save poses 1..5
  play         - torque ON; repeatedly play saved poses 1..5
  record-play  - record five poses, then immediately play them

Design:
- Saved poses are RAW Orca Core joint positions captured from the physical hand.
- Playback sends those same raw joint positions back, so the physical pose is reproduced exactly.
- RViz calibration is kept separately in RVIZ_DISPLAY_OFFSET_DEG and affects display only.
"""

import argparse
import json
import math
import threading
import time
from pathlib import Path

import rclpy
from rclpy.node import Node
from sensor_msgs.msg import JointState

from orca_core.hardware_hand import OrcaHand
from orca_core.hand_config import OrcaHandConfig


CONFIG = "orca_core/models/v2/orcahand-scs225-right/config.yaml"
POSE_FILE = Path("orca_video_poses.json")

TORQUE_LIMIT = 500

SEQUENCE = [3, 1, 4 , 2 ]

DEFAULT_CYCLES = 5

POSE_HOLD_SECONDS = {
    1: 5.5,
    2: 5.5,
    3: 5.5,
    4: 5.5
}

TRANSITION_STEPS = 0.0
TRANSITION_STEP_SIZE = 0.0


JOINT_MAP = {
    "wrist": "R-Carpals_8d1f1041_to_TopTower-Model_4a80d30e",

    "pinky_abd": "P-AP_f5e42b61_to_R-Carpals_8d1f1041",
    "pinky_mcp": "P-PP_1d411b9b_to_P-AP_f5e42b61",
    "pinky_pip": "P-FingerTipAssembly_cd219176_to_P-PP_1d411b9b",

    "ring_abd": "M-AP_6ec59111_to_R-Carpals_8d1f1041",
    "ring_mcp": "M-PP_8660a1eb_to_M-AP_6ec59111",
    "ring_pip": "M-FingerTipAssembly_424a8e75_to_M-PP_8660a1eb",

    "middle_abd": "M-AP_e04a96f2_to_R-Carpals_8d1f1041",
    "middle_mcp": "M-PP_08efa608_to_M-AP_e04a96f2",
    "middle_pip": "M-FingerTipAssembly_34afb748_to_M-PP_08efa608",

    "index_abd": "I-AP-R_d95d02d1_to_R-Carpals_8d1f1041",
    "index_mcp": "I-PP_bacbd481_to_I-AP-R_d95d02d1",
    "index_pip": "I-FingerTipAssembly_ec49c16c_to_I-PP_bacbd481",

    "thumb_cmc": "T-TP-R_1c2b802d_to_R-Carpals_8d1f1041",
    "thumb_abd": "R-T-AP_a9723101_to_T-TP-R_1c2b802d",
    "thumb_mcp": "T-PP_68395e98_to_R-T-AP_a9723101",
    "thumb_dip": "T-DP_b7429e50_to_T-PP_68395e98",
}

JOINT_SIGN = {joint: 1.0 for joint in JOINT_MAP}

JOINT_SIGN["index_abd"] = -1.0

RVIZ_DISPLAY_OFFSET_DEG = {
    "wrist": 0.0,

    "thumb_cmc": -10.0,
    "thumb_abd": 0.0,
    "thumb_mcp": 0.0,
    "thumb_dip": -10.0,

    "index_abd": 0.0,
    "index_mcp": 0.0,
    "index_pip": 0.0,

    "middle_abd": 10.0,
    "middle_mcp": 0.0,
    "middle_pip": 0.0,

    "ring_abd": 10.0,
    "ring_mcp": 0.0,
    "ring_pip": 0.0,

    "pinky_abd": -20.0,
    "pinky_mcp": 0.0,
    "pinky_pip": 0.0,
}
JOINT_SIGN = {
    "wrist": 1.0,

    "thumb_cmc": 1.0,
    "thumb_abd": 1.0,
    "thumb_mcp": 1.0,
    "thumb_dip": 1.0,

    "index_abd": -1.0,
    "index_mcp": 1.0,
    "index_pip": 1.0,

    "middle_abd": -1.0,
    "middle_mcp": 1.0,
    "middle_pip": 1.0,

    "ring_abd": 1.0,
    "ring_mcp": 1.0,
    "ring_pip": 1.0,

    "pinky_abd": 1.0,
    "pinky_mcp": 1.0,
    "pinky_pip": 1.0,
}

class JointStatePublisher(Node):
    def __init__(self, hand):
        super().__init__("orca_pose_recorder_player")
        self.hand = hand
        self.pub = self.create_publisher(JointState, "/joint_states", 10)
        self.running = True
        self.thread = threading.Thread(target=self._loop, daemon=True)
        self.thread.start()

    def _loop(self):
        while self.running and rclpy.ok():
            try:
                positions = self.hand.get_joint_position().as_dict()

                msg = JointState()
                msg.header.stamp = self.get_clock().now().to_msg()

                for joint, urdf_joint in JOINT_MAP.items():
                    value = positions.get(joint)
                    if value is None:
                        continue

                    display_deg = (
                        JOINT_SIGN[joint] * float(value)
                        + RVIZ_DISPLAY_OFFSET_DEG.get(joint, 0.0)
                    )

                    msg.name.append(urdf_joint)
                    msg.position.append(math.radians(display_deg))

                self.pub.publish(msg)

            except Exception as exc:
                self.get_logger().warning(f"joint-state read failed: {exc}")

            time.sleep(0.05)

    def stop(self):
        self.running = False
        self.thread.join(timeout=2.0)


def read_pose(hand):
    values = hand.get_joint_position().as_dict()

    pose = {}
    for joint in JOINT_MAP:
        value = values.get(joint)
        if value is None:
            raise RuntimeError(f"joint {joint!r} returned no position")
        pose[joint] = round(float(value), 4)

    return pose


def print_pose(number, pose):
    print(f"\nPOSE {number}")
    for joint in JOINT_MAP:
        print(f"  {joint:12s}: {pose[joint]:8.3f}")


def save_poses(poses):
    data = {
        "format": 1,
        "description": "Raw Orca Core joint positions captured from physical hand",
        "poses": poses,
    }

    POSE_FILE.write_text(json.dumps(data, indent=2))
    print(f"\nSaved: {POSE_FILE.resolve()}")


def load_poses():
    if not POSE_FILE.exists():
        raise FileNotFoundError(
            f"{POSE_FILE} does not exist. Run with 'record' first."
        )

    data = json.loads(POSE_FILE.read_text())
    poses = data["poses"]

    for n in sorted(set(SEQUENCE)):
        if str(n) not in poses:
            raise RuntimeError(f"pose {n} missing from {POSE_FILE}")

    return poses


def record_five_poses(hand):
    print("\n============================================================")
    print("RECORD MODE")
    print("============================================================")
    print("Torque is OFF.")
    print("Manually move the physical hand.")
    print("RViz follows using RVIZ_DISPLAY_OFFSET_DEG.")
    print("For each pose: position the hand, then press Enter.")
    print("============================================================\n")

    hand.disable_torque()
    time.sleep(0.5)

    poses = {}

    for number in range(1, 6):
        input(f"Set physical hand to POSE {number}, then press Enter to capture... ")
        time.sleep(0.15)

        pose = read_pose(hand)
        poses[str(number)] = pose
        print_pose(number, pose)

    save_poses(poses)
    return poses


def play_poses(
    hand,
    poses,
    cycles,
    transition_steps,
    transition_step_size,
):
    print("\n============================================================")
    print("PLAY MODE")
    print("============================================================")
    print(f"Sequence:       {SEQUENCE}")
    print(f"Cycles:         {cycles}")
    print(f"Torque limit:   {TORQUE_LIMIT}")
    print(f"Transition:     {transition_steps} steps x "
          f"{transition_step_size:.4f}s")
    print("Press Ctrl+C at any time to stop.")
    print("============================================================\n")

    hand.enable_torque()
    hand.set_max_current(TORQUE_LIMIT)
    time.sleep(0.3)

    for cycle in range(1, cycles + 1):
        print(f"\n========== CYCLE {cycle}/{cycles} ==========")

        for number in SEQUENCE:
            pose = poses[str(number)]

            print(f">>> POSE {number}")

            hand.set_joint_positions(
                pose,
                num_steps=transition_steps,
                step_size=transition_step_size,
            )

            time.sleep(POSE_HOLD_SECONDS.get(number, 0.35))

    print("\nPlayback complete.")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "mode",
        choices=["record", "play", "record-play"],
    )
    parser.add_argument(
        "--cycles",
        type=int,
        default=DEFAULT_CYCLES,
    )
    parser.add_argument(
        "--steps",
        type=int,
        default=TRANSITION_STEPS,
    )
    parser.add_argument(
        "--step-size",
        type=float,
        default=TRANSITION_STEP_SIZE,
    )
    args = parser.parse_args()

    cfg = OrcaHandConfig.from_config_path(CONFIG)
    cfg.validate_config()

    hand = OrcaHand(config=cfg)
    node = None

    try:
        ok, msg = hand.connect(interactive=False)
        print("connect:", ok, msg)
        if not ok:
            raise RuntimeError(msg)

        rclpy.init()
        node = JointStatePublisher(hand)

        if args.mode == "record":
            record_five_poses(hand)

        elif args.mode == "play":
            poses = load_poses()
            play_poses(
                hand,
                poses,
                cycles=args.cycles,
                transition_steps=args.steps,
                transition_step_size=args.step_size,
            )

        else:
            poses = record_five_poses(hand)
            input("\nPress Enter to enable torque and start playback... ")
            play_poses(
                hand,
                poses,
                cycles=args.cycles,
                transition_steps=args.steps,
                transition_step_size=args.step_size,
            )

    except KeyboardInterrupt:
        print("\nStopped by user.")

    finally:
        if node is not None:
            node.stop()
            node.destroy_node()

        if rclpy.ok():
            rclpy.shutdown()

        try:
            hand.disable_torque()
        except Exception:
            pass

        hand.disconnect()
        print("disconnected")


if __name__ == "__main__":
    main()
