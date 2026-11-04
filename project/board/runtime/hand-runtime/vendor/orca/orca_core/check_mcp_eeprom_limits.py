from orca_core.hardware_hand import OrcaHand
from orca_core.hand_config import OrcaHandConfig

CONFIG = "orca_core/models/v2/orcahand-scs225-right/config.yaml"

IDS = [3, 10, 7, 12]  # index/middle/ring/pinky MCP

ADDR_MIN_ANGLE = 0x09
ADDR_MAX_ANGLE = 0x0B
ADDR_PRESENT_POSITION = 0x38

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
        "ID  joint        eeprom_min  current  eeprom_max  "
        "span_counts  span_deg"
    )
    print(
        "------------------------------------------------------------------------"
    )

    for bus in (hand.motor_client.bus_a, hand.motor_client.bus_b):
        for motor_id in IDS:
            if motor_id not in bus.motor_ids:
                continue

            mn, r1, e1 = bus.servo.read2ByteTxRx(motor_id, ADDR_MIN_ANGLE)
            mx, r2, e2 = bus.servo.read2ByteTxRx(motor_id, ADDR_MAX_ANGLE)
            pos, r3, e3 = bus.servo.read2ByteTxRx(motor_id, ADDR_PRESENT_POSITION)

            joint = hand.config.motor_to_joint_dict[motor_id]
            span_counts = mx - mn
            span_deg = span_counts * DEG_PER_COUNT

            print(
                f"{motor_id:2d}  {joint:11s}  "
                f"{mn:10d}  {pos:7d}  {mx:10d}  "
                f"{span_counts:11d}  {span_deg:8.2f}"
            )

            if any(v != 0 for v in (r1, e1, r2, e2, r3, e3)):
                print(
                    f"    comm: min=({r1},{e1}) "
                    f"max=({r2},{e2}) pos=({r3},{e3})"
                )

finally:
    hand.disconnect()
    print()
    print("disconnected")
