from orca_core.hardware_hand import OrcaHand
from orca_core.hand_config import OrcaHandConfig

CONFIG = "orca_core/models/v2/orcahand-scs225-right/config.yaml"
MOTOR_ID = 1

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

    for bus in (hand.motor_client.bus_a, hand.motor_client.bus_b):
        if MOTOR_ID not in bus.motor_ids:
            continue
        mn, r1, e1 = bus.servo.read2ByteTxRx(MOTOR_ID, ADDR_MIN_ANGLE)
        mx, r2, e2 = bus.servo.read2ByteTxRx(MOTOR_ID, ADDR_MAX_ANGLE)
        pos, r3, e3 = bus.servo.read2ByteTxRx(MOTOR_ID, ADDR_PRESENT_POSITION)
        if any(v != 0 for v in (r1,e1,r2,e2,r3,e3)):
            raise RuntimeError(
                f"comm error: min=({r1},{e1}) max=({r2},{e2}) pos=({r3},{e3})"
            )

        print(
            f"ID1 wrist: min={mn}, current={pos}, max={mx}, "
            f"span={mx-mn} counts = {(mx-mn)*DEG_PER_COUNT:.2f} deg"
        )
finally:
    hand.disconnect()
    print("disconnected")
