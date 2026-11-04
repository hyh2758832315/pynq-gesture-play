#!/usr/bin/env python3
"""
Video-oriented OrcaHand + RViz synchronized demo.

Physical hand is controlled through Orca Core.
Actual measured/calibrated joint positions are published to /joint_states
so RViz follows the real hand.

Zero-offset correction is applied BOTH:
1) before commanding the physical hand
2) inversely when publishing measured joint positions to RViz

This keeps physical motion and RViz in the same logical joint frame.
"""

import math
import threading
import time

import rclpy
from rclpy.node import Node
from sensor_msgs.msg import JointState

from orca_core.hardware_hand import OrcaHand
from orca_core.hand_config import OrcaHandConfig

CONFIG = "orca_core/models/v2/orcahand-scs225-right/config.yaml"

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

JOINT_SIGN = {
    joint: 1.0
    for joint in JOINT_MAP
}

# Logical joint zero -> Orca joint-frame correction.
# These values make physical motion line up with the URDF/RViz zero frame.
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


class JointStatePublisher(Node):
    def __init__(self, hand):
        super().__init__("orca_video_demo")
        self.hand = hand
        self.pub = self.create_publisher(JointState, "/joint_states", 10)
        self.running = True
        self.thread = threading.Thread(target=self.loop, daemon=True)
        self.thread.start()

    def loop(self):
        while self.running and rclpy.ok():
            try:
                p = self.hand.get_joint_position().as_dict()

                msg = JointState()
                msg.header.stamp = self.get_clock().now().to_msg()

                for joint, urdf_joint in JOINT_MAP.items():
                    if joint not in p:
                        continue

                    # Convert Orca joint frame back into logical / URDF frame.
                    zero_offset = JOINT_ZERO_OFFSET_DEG.get(joint, 0.0)
                    logical_joint_deg = float(p[joint]) - zero_offset

                    msg.name.append(urdf_joint)
                    msg.position.append(
                        math.radians(
                            JOINT_SIGN[joint] * logical_joint_deg
                        )
                    )

                self.pub.publish(msg)

            except Exception as exc:
                self.get_logger().warning(f"joint-state read failed: {exc}")

            time.sleep(0.05)  # ~20 Hz

    def stop(self):
        self.running = False
        self.thread.join(timeout=2.0)


NEUTRAL = {
    "wrist": 0.0,

    "thumb_cmc": 0.0,
    "thumb_abd": 0.0,
    "thumb_mcp": 0.0,
    "thumb_dip": 0.0,

    "index_abd": 0.0,
    "index_mcp": 0.0,
    "index_pip": 0.0,

    "middle_abd": 0.0,
    "middle_mcp": 0.0,
    "middle_pip": 0.0,

    "ring_abd": 0.0,
    "ring_mcp": 0.0,
    "ring_pip": 0.0,

    "pinky_abd": 0.0,
    "pinky_mcp": 0.0,
    "pinky_pip": 0.0,
}


def move(hand, name, pose, hold=0.8, steps=35, step_size=0.018):
    print(f"\n>>> {name}")

    # Convert logical / URDF-frame pose into Orca joint-frame command.
    corrected_pose = {
        joint: angle + JOINT_ZERO_OFFSET_DEG.get(joint, 0.0)
        for joint, angle in pose.items()
    }

    hand.set_joint_positions(
        corrected_pose,
        num_steps=steps,
        step_size=step_size,
    )

    time.sleep(hold)


def finger_wave(hand):
    fingers = [
        ("INDEX", "index_mcp", "index_pip"),
        ("MIDDLE", "middle_mcp", "middle_pip"),
        ("RING", "ring_mcp", "ring_pip"),
        ("PINKY", "pinky_mcp", "pinky_pip"),
    ]

    for label, mcp, pip in fingers:
        move(
            hand,
            f"{label} DOWN",
            {mcp: 38.0, pip: 30.0},
            hold=0.20,
            steps=22,
        )
        move(
            hand,
            f"{label} UP",
            {mcp: 0.0, pip: 0.0},
            hold=0.12,
            steps=18,
        )


cfg = OrcaHandConfig.from_config_path(CONFIG)
cfg.validate_config()

hand = OrcaHand(config=cfg)
node = None

try:
    ok, msg = hand.connect(interactive=False)
    print("connect:", ok, msg)

    if not ok:
        raise RuntimeError(msg)

    hand.enable_torque()
    hand.set_max_current(500)

    rclpy.init()
    node = JointStatePublisher(hand)

    print("\nStarting cinematic demo in 3 seconds...")
    time.sleep(3.0)

    # 1. Neutral
    move(
        hand,
        "NEUTRAL",
        NEUTRAL,
        hold=1.2,
        steps=45,
    )

    # 2. Wrist greeting wave
    for angle in (-18.0, 18.0, -18.0, 18.0, 0.0):
        move(
            hand,
            f"WRIST WAVE {angle:+.0f}",
            {"wrist": angle},
            hold=0.25,
            steps=22,
        )

    # 3. Finger ripple
    finger_wave(hand)

    # 4. Smooth fist
    move(
        hand,
        "POWER FIST",
        {
            "thumb_cmc": 10.0,
            "thumb_abd": 8.0,
            "thumb_mcp": 30.0,
            "thumb_dip": 25.0,

            "index_mcp": 55.0,
            "index_pip": 45.0,

            "middle_mcp": 55.0,
            "middle_pip": 45.0,

            "ring_mcp": 55.0,
            "ring_pip": 45.0,

            "pinky_mcp": 55.0,
            "pinky_pip": 45.0,
        },
        hold=1.2,
        steps=45,
    )

    # 5. Open
    move(
        hand,
        "OPEN HAND",
        NEUTRAL,
        hold=0.8,
        steps=45,
    )

    # 6. Point
    move(
        hand,
        "POINT",
        {
            "index_mcp": 0.0,
            "index_pip": 0.0,

            "middle_mcp": 55.0,
            "middle_pip": 45.0,

            "ring_mcp": 55.0,
            "ring_pip": 45.0,

            "pinky_mcp": 55.0,
            "pinky_pip": 45.0,

            "thumb_cmc": 8.0,
            "thumb_abd": 8.0,
            "thumb_mcp": 20.0,
            "thumb_dip": 15.0,
        },
        hold=1.2,
        steps=40,
    )

    # 7. Open again
    move(
        hand,
        "OPEN AGAIN",
        NEUTRAL,
        hold=0.7,
        steps=40,
    )

    # 8. Pinch
    move(
        hand,
        "PINCH",
        {
            "thumb_cmc": 12.0,
            "thumb_abd": 15.0,
            "thumb_mcp": 42.0,
            "thumb_dip": 32.0,

            "index_mcp": 35.0,
            "index_pip": 30.0,

            "middle_mcp": 5.0,
            "middle_pip": 5.0,

            "ring_mcp": 5.0,
            "ring_pip": 5.0,

            "pinky_mcp": 5.0,
            "pinky_pip": 5.0,
        },
        hold=1.3,
        steps=45,
    )

    # 9. Open
    move(
        hand,
        "OPEN",
        NEUTRAL,
        hold=0.7,
        steps=40,
    )

    # 10. Final wrist showcase
    move(
        hand,
        "WRIST LEFT",
        {"wrist": -25.0},
        hold=0.6,
        steps=35,
    )

    move(
        hand,
        "WRIST RIGHT",
        {"wrist": 25.0},
        hold=0.6,
        steps=35,
    )

    move(
        hand,
        "FINAL CENTER",
        NEUTRAL,
        hold=2.0,
        steps=45,
    )

    print("\nVIDEO DEMO COMPLETE")
    time.sleep(2.0)

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
