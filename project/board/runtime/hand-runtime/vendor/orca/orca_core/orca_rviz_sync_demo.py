#!/usr/bin/env python3
"""
Live OrcaHand SCS225 demo + ROS2 /joint_states publisher.

Purpose:
- Control the physical OrcaHand.
- Read actual calibrated joint positions from Orca Core.
- Publish those measured positions to /joint_states.
- Let robot_state_publisher drive RViz from the physical hand state.

Use this to visually check movement direction and calibration against the URDF.
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

JOINT_OFFSET_DEG = {
    "thumb_abd": -30,
}
# Orca Core joint name -> URDF revolute joint name
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

# Start with direct signs. If any RViz joint moves opposite to the physical joint,
# flip only that joint to -1.0 after the first test.
JOINT_SIGN = {joint: 1.0 for joint in JOINT_MAP}


class JointStateNode(Node):
    def __init__(self, hand):
        super().__init__("orca_scs225_live_demo")
        self.hand = hand
        self.pub = self.create_publisher(JointState, "/joint_states", 10)
        self.running = True
        self.thread = threading.Thread(target=self._publisher_loop, daemon=True)
        self.thread.start()

    def _publisher_loop(self):
        while self.running and rclpy.ok():
            try:
                positions = self.hand.get_joint_position().as_dict()

                msg = JointState()
                msg.header.stamp = self.get_clock().now().to_msg()

                for orca_name, urdf_name in JOINT_MAP.items():
                    if orca_name not in positions:
                        continue
                    msg.name.append(urdf_name)
                    offset = JOINT_OFFSET_DEG.get(orca_name, 0.0)

                    msg.position.append(
                        math.radians(
                            JOINT_SIGN[orca_name] * float(positions[orca_name]) + offset
                        )
                    )

                self.pub.publish(msg)

            except Exception as exc:
                self.get_logger().warning(f"joint-state read failed: {exc}")

            time.sleep(0.05)  # 20 Hz

    def stop(self):
        self.running = False
        self.thread.join(timeout=2.0)


def move(hand, label, target, hold=1.0):
    print(f"\n=== {label} ===")
    print(target)

    # Gentle interpolation handled by Orca Core.
    hand.set_joint_positions(
        target,
        num_steps=30,
        step_size=0.02,
    )
    time.sleep(hold)


def main():
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
        node = JointStateNode(hand)

        # Let RViz receive the first real state.
        time.sleep(1.0)

        # 1) Neutral / straight hand
        move(
            hand,
            "1. NEUTRAL",
            {
                "wrist": 0,
                "thumb_cmc": 0, "thumb_abd": 0, "thumb_mcp": 0, "thumb_dip": 0,
                "index_abd": 0, "index_mcp": 0, "index_pip": 0,
                "middle_abd": 0, "middle_mcp": 0, "middle_pip": 0,
                "ring_abd": 0, "ring_mcp": 0, "ring_pip": 0,
                "pinky_abd": 0, "pinky_mcp": 0, "pinky_pip": 0,
            },
            1.5,
        )

        # 2) Gentle fist
        move(
            hand,
            "2. GENTLE FIST",
            {
                "thumb_cmc": 8, "thumb_abd": 8, "thumb_mcp": 25, "thumb_dip": 20,
                "index_mcp": 30, "index_pip": 25,
                "middle_mcp": 30, "middle_pip": 25,
                "ring_mcp": 30, "ring_pip": 25,
                "pinky_mcp": 30, "pinky_pip": 25,
            },
            1.5,
        )

        move(hand, "3. OPEN", {
            "thumb_cmc": 0, "thumb_abd": 0, "thumb_mcp": 0, "thumb_dip": 0,
            "index_mcp": 0, "index_pip": 0,
            "middle_mcp": 0, "middle_pip": 0,
            "ring_mcp": 0, "ring_pip": 0,
            "pinky_mcp": 0, "pinky_pip": 0,
        }, 1.0)

        # 4-7) One finger at a time, useful for matching directions in RViz.
        move(hand, "4. INDEX FLEX", {"index_mcp": 35, "index_pip": 30}, 1.0)
        move(hand, "5. INDEX OPEN", {"index_mcp": 0, "index_pip": 0}, 0.6)

        move(hand, "6. MIDDLE FLEX", {"middle_mcp": 35, "middle_pip": 30}, 1.0)
        move(hand, "7. MIDDLE OPEN", {"middle_mcp": 0, "middle_pip": 0}, 0.6)

        move(hand, "8. RING FLEX", {"ring_mcp": 35, "ring_pip": 30}, 1.0)
        move(hand, "9. RING OPEN", {"ring_mcp": 0, "ring_pip": 0}, 0.6)

        move(hand, "10. PINKY FLEX", {"pinky_mcp": 35, "pinky_pip": 30}, 1.0)
        move(hand, "11. PINKY OPEN", {"pinky_mcp": 0, "pinky_pip": 0}, 0.6)

        # Wrist sign/direction check using the newly defined manual calibration.
        move(hand, "12. WRIST -25 DEG", {"wrist": -25}, 1.2)
        move(hand, "13. WRIST +25 DEG", {"wrist": 25}, 1.2)
        move(hand, "14. WRIST CENTER", {"wrist": 0}, 1.0)

        # Thumb
        move(
            hand,
            "15. THUMB FLEX",
            {"thumb_cmc": 10, "thumb_abd": 10, "thumb_mcp": 30, "thumb_dip": 25},
            1.2,
        )
        move(
            hand,
            "16. THUMB OPEN",
            {"thumb_cmc": 0, "thumb_abd": 0, "thumb_mcp": 0, "thumb_dip": 0},
            1.0,
        )

        print("\nDemo finished.")
        print("Keep watching RViz for 3 seconds...")
        time.sleep(3.0)

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
