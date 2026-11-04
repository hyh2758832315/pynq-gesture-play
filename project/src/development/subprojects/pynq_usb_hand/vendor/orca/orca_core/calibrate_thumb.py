from orca_core.hardware_hand import OrcaHand
from orca_core.hand_config import OrcaHandConfig

CONFIG = "orca_core/models/v2/orcahand-scs225-right/config.yaml"

JOINTS = [
    "thumb_cmc",
    "thumb_abd",
    "thumb_mcp",
    "thumb_dip",
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
    print("Calibrating thumb only:")
    for joint in JOINTS:
        motor_id = hand.config.joint_to_motor_map[joint]
        print(f"  {joint:10s} -> motor {motor_id}")

    print()
    print("Calibration torque limit = 200")
    print("Slow SCS225 calibration timing from config.yaml is used.")
    print("Normal torque limit restores to 500 at the end.")
    print()

    hand.calibrate(
        blocking=True,
        joints=JOINTS,
        progress_callback=progress,
        persist=True,
    )

    print()
    print("THUMB calibration results:")
    for joint in JOINTS:
        motor_id = hand.config.joint_to_motor_map[joint]
        print(
            f"{joint:10s}",
            "motor", motor_id,
            "limits", hand.calibration.motor_limits_dict[motor_id],
            "ratio", hand.calibration.joint_to_motor_ratios_dict[motor_id],
        )

finally:
    hand.disconnect()
    print("disconnected")
