from orca_core.hardware_hand import OrcaHand
from orca_core.hand_config import OrcaHandConfig

CONFIG = "orca_core/models/v2/orcahand-scs225-right/config.yaml"

JOINTS = [
    "index_abd",
    "middle_abd",
    "ring_abd",
    "pinky_abd",
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
    print("Calibrating all four ABD joints together:")
    for joint in JOINTS:
        print(" ", joint, "-> motor", hand.config.joint_to_motor_map[joint])

    print()
    print("Calibration torque limit = 200")
    print("This preserves the grouped ABD flex/extend steps from config.yaml.")

    hand.calibrate(
        blocking=True,
        joints=JOINTS,
        progress_callback=progress,
        persist=True,
    )

    print()
    print("ABD calibration results:")
    for joint in JOINTS:
        motor_id = hand.config.joint_to_motor_map[joint]
        print(
            joint,
            "motor", motor_id,
            "limits", hand.calibration.motor_limits_dict[motor_id],
            "ratio", hand.calibration.joint_to_motor_ratios_dict[motor_id],
        )

finally:
    hand.disconnect()
    print("disconnected")
