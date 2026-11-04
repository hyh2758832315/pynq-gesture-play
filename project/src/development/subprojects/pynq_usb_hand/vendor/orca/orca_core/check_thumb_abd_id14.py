import time
import numpy as np

from orca_core.hardware_hand import OrcaHand
from orca_core.hand_config import OrcaHandConfig

CONFIG = "orca_core/models/v2/orcahand-scs225-right/config.yaml"

IDS = [17, 14, 15, 16]   # CMC, ABD, MCP, DIP
TEST_ID = 14             # second thumb joint from wrist = thumb_abd

ADDR_MIN_ANGLE = 0x09
ADDR_MAX_ANGLE = 0x0B
ADDR_PRESENT_POSITION = 0x38

RAD_PER_COUNT = 2.0 * np.pi / 4096.0
DEG_PER_COUNT = 360.0 / 4096.0

cfg = OrcaHandConfig.from_config_path(CONFIG)
cfg.validate_config()
hand = OrcaHand(config=cfg)

def bus_for(mid):
    for bus in (hand.motor_client.bus_a, hand.motor_client.bus_b):
        if mid in bus.motor_ids:
            return bus
    raise RuntimeError(f"motor {mid} not found")

def read_raw(mid):
    bus = bus_for(mid)
    mn, r1, e1 = bus.servo.read2ByteTxRx(mid, ADDR_MIN_ANGLE)
    mx, r2, e2 = bus.servo.read2ByteTxRx(mid, ADDR_MAX_ANGLE)
    pos, r3, e3 = bus.servo.read2ByteTxRx(mid, ADDR_PRESENT_POSITION)
    if any(v != 0 for v in (r1, e1, r2, e2, r3, e3)):
        raise RuntimeError(
            f"communication error ID{mid}: "
            f"min=({r1},{e1}) max=({r2},{e2}) pos=({r3},{e3})"
        )
    return mn, pos, mx

def move_to_count(mid, target_count, label):
    target_rad = target_count * RAD_PER_COUNT
    print(f"\n{label}: command ID{mid} -> count {target_count} "
          f"({target_count * DEG_PER_COUNT:.2f} deg)")
    hand.write_motor_pos([mid], np.array([target_rad], dtype=float))

    for i in range(20):  # 5 seconds max
        time.sleep(0.25)
        _, pos, _ = read_raw(mid)
        err = target_count - pos
        print(
            f"  t={(i+1)*0.25:4.2f}s  pos={pos:4d} "
            f"({pos*DEG_PER_COUNT:6.2f} deg)  error={err:+4d}"
        )
        if abs(err) <= 8:
            break

try:
    ok, msg = hand.connect(interactive=False)
    print("connect:", ok, msg)
    if not ok:
        raise RuntimeError(msg)

    hand.enable_torque(IDS)
    hand.set_control_mode("position", IDS)
    hand.set_max_current(200)

    print("\nThumb EEPROM limits:")
    for mid in IDS:
        mn, pos, mx = read_raw(mid)
        joint = hand.config.motor_to_joint_dict[mid]
        print(
            f"ID{mid:2d} {joint:10s}: "
            f"min={mn:4d}, current={pos:4d}, max={mx:4d}, "
            f"span={mx-mn:4d} counts = {(mx-mn)*DEG_PER_COUNT:6.2f} deg"
        )

    mn, pos, mx = read_raw(TEST_ID)
    print("\nTesting thumb_abd / ID14 at torque 200.")
    print("We stay 5 counts inside EEPROM limits.")

    move_to_count(TEST_ID, mx - 5, "toward MAX")
    move_to_count(TEST_ID, mn + 5, "toward MIN")

    # Return to EEPROM midpoint.
    mid = (mn + mx) // 2
    move_to_count(TEST_ID, mid, "return midpoint")

    hand.set_max_current(500)

finally:
    try:
        hand.disable_torque(IDS)
    except Exception:
        pass
    hand.disconnect()
    print("\ndisconnected")
