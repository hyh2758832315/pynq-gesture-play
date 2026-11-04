#!/usr/bin/env python3
import math

import rclpy
from rclpy.node import Node
from sensor_msgs.msg import JointState

from orca_core.hardware_hand import OrcaHand
from orca_core.hand_config import OrcaHandConfig


CONFIG = "orca_core/models/v2/orcahand-scs225-right/config.yaml"

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

# Start with direct sign mapping. If a joint moves opposite in RViz,
# we will flip only that entry after the first live test.
JOINT_SIGN = {name: 1.0 for name in JOINT_MAP}


class OrcaJointStatePublisher(Node):
    def __init__(self):
        super().__init__("orca_scs225_joint_state_publisher")

        cfg = OrcaHandConfig.from_config_path(CONFIG)
        cfg.validate_config()
        self.hand = OrcaHand(config=cfg)

        ok, msg = self.hand.connect(interactive=False)
        if not ok:
            raise RuntimeError(msg)

        self.get_logger().info(f"OrcaHand connected: {msg}")
        self.pub = self.create_publisher(JointState, "/joint_states", 10)

        # 20 Hz is more than enough for RViz and avoids unnecessary serial-bus load.
        self.timer = self.create_timer(0.05, self.publish_joint_states)

    def publish_joint_states(self):
        try:
            positions_deg = self.hand.get_joint_position().as_dict()

            msg = JointState()
            msg.header.stamp = self.get_clock().now().to_msg()

            for orca_name, urdf_name in JOINT_MAP.items():
                value_deg = positions_deg.get(orca_name)
                if value_deg is None:
                    continue

                msg.name.append(urdf_name)
                msg.position.append(
                    JOINT_SIGN[orca_name] * math.radians(float(value_deg))
                )

            self.pub.publish(msg)

        except Exception as exc:
            self.get_logger().error(f"Failed to read/publish joint state: {exc}")

    def destroy_node(self):
        try:
            self.hand.disconnect()
        except Exception:
            pass
        super().destroy_node()


def main():
    rclpy.init()
    node = None
    try:
        node = OrcaJointStatePublisher()
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        if node is not None:
            node.destroy_node()
        if rclpy.ok():
            rclpy.shutdown()


if __name__ == "__main__":
    main()
