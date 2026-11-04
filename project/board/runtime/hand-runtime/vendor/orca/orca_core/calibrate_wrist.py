from orca_core.hardware_hand import OrcaHand
from orca_core.hand_config import OrcaHandConfig

CONFIG = "orca_core/models/v2/orcahand-scs225-right/config.yaml"

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
    print("Calibrating WRIST only -> motor ID1")
    print("Calibration torque limit = 200")
    print("Using slow SCS225 calibration timing.")
    print()

    hand.calibrate(
        blocking=True,
        joints=["wrist"],
        progress_callback=progress,
        persist=True,
    )

    print()
    print("WRIST calibration result:")
    print(
        "limits:",
        hand.calibration.motor_limits_dict[1],
        "ratio:",
        hand.calibration.joint_to_motor_ratios_dict[1],
    )

finally:
    hand.disconnect()
    print("disconnected")
