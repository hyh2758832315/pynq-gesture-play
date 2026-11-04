from orca_core.hardware_hand import OrcaHand
from orca_core.hand_config import OrcaHandConfig

CONFIG = "orca_core/models/v2/orcahand-scs225-right/config.yaml"

JOINTS = [
    "index_mcp",
    "middle_mcp",
    "ring_mcp",
    "pinky_mcp",
    "index_pip",
    "middle_pip",
    "ring_pip",
    "pinky_pip",
]

cfg = OrcaHandConfig.from_config_path(CONFIG)
cfg.validate_config()

hand = OrcaHand(config=cfg)

def progress(event):
    print("CAL:", event)

try:
    ok, msg = hand.connect(interactive=False)
    print("connect:", ok, msg)
    if not ok:
        raise RuntimeError(msg)

    print()
    print("Calibrating four MCP joints together, then four PIP joints together.")
    print("Calibration torque limit = 200")
    print("Normal torque limit restores to 500 at the end.")
    print()

    hand.calibrate(
        blocking=True,
        joints=JOINTS,
        progress_callback=progress,
        persist=True,
    )

    print()
    print("MCP/PIP calibration results:")
    for joint in JOINTS:
        motor_id = hand.config.joint_to_motor_map[joint]
        print(
            f"{joint:12s}",
            "motor", motor_id,
            "limits", hand.calibration.motor_limits_dict[motor_id],
            "ratio", hand.calibration.joint_to_motor_ratios_dict[motor_id],
        )

finally:
    hand.disconnect()
    print("disconnected")
