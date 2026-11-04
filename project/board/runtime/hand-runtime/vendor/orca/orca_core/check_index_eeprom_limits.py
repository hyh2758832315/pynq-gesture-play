from orca_core.hardware_hand import OrcaHand
from orca_core.hand_config import OrcaHandConfig

CONFIG = "orca_core/models/v2/orcahand-scs225-right/config.yaml"
IDS = [2, 3, 4]

# SCS225 registers
ADDR_MIN_ANGLE = 0x09
ADDR_MAX_ANGLE = 0x0B
ADDR_PRESENT_POSITION = 0x38

# 4096 counts / 360 deg
DEG_PER_COUNT = 360.0 / 4096.0

cfg = OrcaHandConfig.from_config_path(CONFIG)
cfg.validate_config()

hand = OrcaHand(config=cfg)

try:
    ok, msg = hand.connect(interactive=False)
    print("connect:", ok, msg)

    if not ok:
        raise RuntimeError(msg)

    print()
    print(
        "ID  joint       eeprom_min  current  eeprom_max  "
        "span_counts  span_deg"
    )
    print(
        "-----------------------------------------------------------------------"
    )

    for bus in (hand.motor_client.bus_a, hand.motor_client.bus_b):
        for motor_id in IDS:
            if motor_id not in bus.motor_ids:
                continue

            min_pos, min_result, min_error = bus.servo.read2ByteTxRx(
                motor_id,
                ADDR_MIN_ANGLE,
            )
            max_pos, max_result, max_error = bus.servo.read2ByteTxRx(
                motor_id,
                ADDR_MAX_ANGLE,
            )
            current_pos, pos_result, pos_error = bus.servo.read2ByteTxRx(
                motor_id,
                ADDR_PRESENT_POSITION,
            )

            joint = hand.config.motor_to_joint_dict[motor_id]

            span_counts = max_pos - min_pos
            span_deg = span_counts * DEG_PER_COUNT

            print(
                f"{motor_id:2d}  "
                f"{joint:10s}  "
                f"{min_pos:10d}  "
                f"{current_pos:7d}  "
                f"{max_pos:10d}  "
                f"{span_counts:11d}  "
                f"{span_deg:8.2f}"
            )

            if any(
                value != 0
                for value in (
                    min_result,
                    min_error,
                    max_result,
                    max_error,
                    pos_result,
                    pos_error,
                )
            ):
                print(
                    "    comm status:",
                    f"min=({min_result},{min_error})",
                    f"max=({max_result},{max_error})",
                    f"pos=({pos_result},{pos_error})",
                )

finally:
    hand.disconnect()
    print()
    print("disconnected")
