# Orca Core Fork for SCS225 / ST3215

This repository is a personal fork of the original [Orca Core](https://github.com/orcahand/orca_core) project, customized for **Feetech SCS225 / ST3215-family servo hardware**, dual serial-bus operation, calibration, ROS 2 visualization, and custom OrcaHand control experiments.

PYNQ USB four-state integration: [Engineering handoff (Chinese)](docs/pynq_usb_hand_handoff.md). Covers the current single-adapter 17-motor baseline, calibrated default/paper/scissors/rock targets, deployment assets, interfaces, and a proposed minimal safety monitor. PYNQ deployment remains to be validated; the dual-bus material below also includes historical configurations.

- Maintainer: **N-B-Studio**
- Hardware focus: **SCS225 / ST3215-family servos**
- Current validated hardware: **17 × SCS225**
- Main development branch: **`scs225-dual-bus`**
- Purpose: custom control, calibration, dual-bus integration, ROS 2 / RViz synchronization, and pose playback
- Status: **experimental fork for custom hardware development**

> This fork is not an official OrcaHand release. The upstream project remains the reference implementation: https://github.com/orcahand/orca_core

---

## Dual-Bus Serial Connection

With `motor_type: scs225` and `port: dual`, the client discovers the two
USB serial adapters at the configured baud rate using read-only motor-position
requests. BUS-A and BUS-B are identified by their configured motor-ID groups,
not by COM numbers or another machine's USB device paths. Construction does not
open ports; probing and connection do not enable torque or change servo settings.

Close FTDebug and other serial tools before connecting. All configured motor IDs
must respond, each ID must belong to exactly one port, and the two bus groups
must resolve to distinct ports. Discovery reports missing IDs, duplicate IDs,
and port-access errors rather than opening a serial device named `dual`.

Run Python on the host that owns the USB adapters. Windows COM ports are not
automatically available inside WSL; using ROS inside WSL does not itself attach
the adapters to that distribution. Discovery fixes serial transport only; hand
calibration and servo-specific force-limit validation remain separate steps.

## Project Demo

### Hardware Preview

![SCS225 hardware preview](SCS-225/Image/post1.png)

### Video Demo

- YouTube: https://www.youtube.com/todo
- Bilibili: [https://www.bilibili.com/todo](https://www.bilibili.com/video/BV128at6MEQk/?share_source=copy_web&vd_source=1cfa98805e173fadcb45b4f55d7a4d81)

Replace the placeholder links above when the final demo videos are published.

---

## What This Fork Adds

The main additions are:

- SCS225 servo support through `ftservo-python-sdk`
- Dual serial-bus support for a 17-servo OrcaHand
- Orca Core motor-factory integration for SCS225
- Position read/write support
- Torque enable / disable
- Native SCS225 torque-limit support
- Temperature, current, speed, and moving-state reads
- Joint calibration support
- Selective recalibration of individual joints or joint groups
- Custom right-hand SCS225 model configuration
- ROS 2 `/joint_states` publishing
- RViz live synchronization
- Interactive pose editing
- Pose recording and repeated pose playback

Current core files added or modified by this fork include:

```text
orca_core/constants.py
orca_core/hardware/motor_factory.py
orca_core/hardware_hand.py
orca_core/hardware/scs225_client.py
orca_core/hardware/dual_scs225_client.py
orca_core/models/v2/orcahand-scs225-right/config.yaml
pyproject.toml
uv.lock


Current Hardware Setup
The validated development hand uses:
- 17 × Feetech SCS225 servos
- 2 × USB serial adapters
- 1,000,000 baud
- Right-hand OrcaHand mechanical platform
- Ubuntu host
- ROS 2 Jazzy for visualization
Dual-Bus Layout
BUS-A:
IDs: 2, 3, 4, 5, 6, 7, 8, 9

BUS-B:
IDs: 1, 10, 11, 12, 13, 14, 15, 16, 17

The dual-bus implementation routes motors using configured ID groups rather than assuming that IDs are split numerically across buses.
Conceptually:
Orca Core
   |
   +-- DualSCS225Client
         |
         +-- BUS-A -> IDs 2..9
         |
         +-- BUS-B -> IDs 1, 10..17

Servo ID / Joint Mapping
Servo ID	Joint
1	wrist
2	index_pip
3	index_mcp
4	index_abd
5	middle_abd
6	ring_abd
7	ring_mcp
8	ring_pip
9	middle_pip
10	middle_mcp
11	pinky_pip
12	pinky_mcp
13	pinky_abd
14	thumb_abd
15	thumb_mcp
16	thumb_dip
17	thumb_cmc


The current signed joint-to-motor mapping is stored in the SCS225 model configuration rather than hard-coded into application scripts.
Installation
Clone this fork:
git clone https://github.com/N-B-Studio/orca_core.git
cd orca_core

Switch to the development branch:
git checkout scs225-dual-bus

Install dependencies with uv:
uv sync --group dev

Activate the environment if desired:
source .venv/bin/activate

Verify the Feetech SDK:
python -c "import scservo_sdk; print('scservo_sdk OK')"

The SCS225 implementation uses:
ftservo-python-sdk==2.0.0

with:
import scservo_sdk


SCS225 Hand Configuration
The custom model configuration is located at:
orca_core/models/v2/orcahand-scs225-right/config.yaml

The current configuration uses:
port: dual
baudrate: 1000000
motor_type: scs225
control_mode: position

The configuration also contains the signed joint-to-motor mapping and calibration parameters used by this physical hand.
Basic Python Usage
from orca_core.hardware_hand import OrcaHandfrom orca_core.hand_config import OrcaHandConfigCONFIG = "orca_core/models/v2/orcahand-scs225-right/config.yaml"cfg = OrcaHandConfig.from_config_path(CONFIG)cfg.validate_config()hand = OrcaHand(config=cfg)ok, msg = hand.connect(interactive=False)print(ok, msg)if not ok:    raise RuntimeError(msg)hand.enable_torque()hand.set_max_current(500)hand.set_joint_positions(    {        "index_mcp": 30,        "index_pip": 25,    },    num_steps=1,    step_size=0,)print(hand.get_joint_position())hand.disable_torque()hand.disconnect()


Torque Limit
For the SCS225 adapter in this fork, Orca Core's current-limit API is mapped to the SCS225 native torque-limit mechanism.
Important:
Torque limit != speed limit
Torque limit != milliamps

Values used during development:
200   low-force / calibration operation
500   normal operation
1000  native maximum

Example:
hand.set_max_current(500)


For SCS225 in this fork, that should be interpreted as:
native torque limit = 500

It does not mean 500 mA.
Increasing the torque limit may help a loaded joint reach its target, but it does not directly mean that the servo will move twice as fast.
Motion Speed and Interpolation
Orca Core can interpolate a movement in software.
For example:
hand.set_joint_positions(    pose,    num_steps=40,    step_size=0.018,)


creates many intermediate joint targets and deliberately slows the transition.
For the fastest software-side command transition:
hand.set_joint_positions(    pose,    num_steps=1,    step_size=0,)


This sends the final target immediately. The actual physical movement time is then primarily determined by the servo's internal controller, configured hardware speed behavior, load, supply voltage, and torque limit.
Calibration
This fork supports the normal Orca calibration flow plus SCS225-specific compatibility work.
Calibration records include:
- Motor limits
- Joint-to-motor ratios
- Wrist calibration
- Per-joint travel data
The current hardware has been calibrated across all 17 joints.
Selective recalibration is also supported, for example recalibrating only:
thumb_cmc
thumb_abd
thumb_mcp
thumb_dip

Calibration values are physical-hand specific and should not be assumed to transfer directly to another build.
Wrist Calibration
The wrist uses a manually verified single-turn mapping in the current build.
The current development hardware uses approximately:
joint -65 deg -> motor raw ~221
joint   0 deg -> motor raw ~500
joint +35 deg -> motor raw ~650

This was tuned for the current physical hand and should be recalibrated on another build.
ROS 2 / RViz Integration
The hand can publish measured joint positions into ROS 2:
SCS225 feedback
      |
      v
Orca Core
      |
      v
/joint_states
      |
      v
robot_state_publisher
      |
      v
RViz

The current setup uses ROS 2 Jazzy.
Recommended RViz fixed frame:
ForeArmStructure-Model_e18f2368

The generic joint_state_publisher should not run at the same time as the custom live hardware publisher, otherwise both nodes will publish /joint_states.
RViz Display Calibration
The physical hand and the URDF do not currently share a perfectly identical visual zero for every joint.
For video and visualization, a separate RViz-only correction table can be used:
RVIZ_DISPLAY_OFFSET_DEG = {    "wrist": 0.0,    "thumb_cmc": 0.0,    "thumb_abd": -25.0,    "thumb_mcp": 0.0,    "thumb_dip": -10.0,    "index_abd": 0.0,    "index_mcp": 0.0,    "index_pip": 0.0,    "middle_abd": 0.0,    "middle_mcp": 0.0,    "middle_pip": 10.0,    "ring_abd": -10.0,    "ring_mcp": 0.0,    "ring_pip": 0.0,    "pinky_abd": 5.0,    "pinky_mcp": 0.0,    "pinky_pip": 0.0,}


Display direction can be corrected independently, for example:
JOINT_SIGN["index_abd"] = -1.0


These values are intended for visualization only and should not automatically be treated as physical motor calibration values.
Pose Recording and Playback
The custom demo workflow can store manually tuned hand poses and replay them repeatedly.
Example playback sequence:
SEQUENCE = [1, 4, 2, 3]


Repeated playback then becomes:
1 -> 4 -> 2 -> 3
1 -> 4 -> 2 -> 3
1 -> 4 -> 2 -> 3
...

Per-pose hold time can be configured independently:
POSE_HOLD_SECONDS = {    1: 2.5,    2: 2.5,    3: 2.5,    4: 2.5,}


For fast transitions, use:
num_steps = 1
step_size = 0

Interactive Pose Editor
A development utility can be used to move joints incrementally and build poses interactively.
Example commands:
1 +30
1 +5
14 -10
16 +8

Joint names can also be used:
thumb_abd +5
wrist -10

Typical commands include:
show
save
save 3
reset
list
quit

This workflow is useful when the hand cannot be positioned manually with torque enabled.
Development Tools
During bring-up, this fork used several diagnostic scripts for:
- Dual-bus scanning
- Servo ID verification
- EEPROM limit inspection
- Torque-limit verification
- Calibration tuning
- Thumb calibration
- Wrist calibration
- Full-hand motion tests
- RViz synchronization
- Pose editing
- Pose playback
Many of these scripts are currently development utilities and are not yet polished public APIs.
A cleaner future structure is planned:
examples/scs225/
├── pose_editor.py
├── pose_player.py
├── rviz_sync_demo.py
└── README.md

Git Workflow
This fork is intended to keep the original project as upstream and N-B-Studio as origin.
Expected remotes:
origin    https://github.com/N-B-Studio/orca_core.git
upstream  https://github.com/orcahand/orca_core.git

Fetch upstream updates:
git fetch upstream

Update the custom branch:
git checkout scs225-dual-bus
git rebase upstream/main

Push custom changes:
git push origin scs225-dual-bus

Current Known Limitations
- This is an experimental fork, not an official OrcaHand release.
- SCS225 is the currently validated servo hardware.
- ST3215-family support is a development target and should not be assumed fully validated yet.
- The current dual-bus routing is specific to this hardware setup.
- Calibration values are specific to the physical hand used during development.
- RViz visual offsets may need adjustment for another build.
- Native SCS225 torque-limit units are servo-specific.
- Hardware speed control is not yet exposed as a polished high-level Orca Core API in this fork.
- Some diagnostic and demo scripts still need cleanup before being treated as reusable examples.
Roadmap
Planned work includes:
- Clean up and publish SCS225 example scripts
- Add automated tests for dual-bus routing
- Make bus routing configurable from model configuration
- Expose configurable servo speed control
- Improve joint-zero calibration
- Separate physical calibration from URDF visualization calibration cleanly
- Add reusable pose recording and playback utilities
- Improve ROS 2 integration
- Validate ST3215 compatibility
- Add CI coverage for SCS225-specific code paths
Upstream Project
Original project:
https://github.com/orcahand/orca_core
This fork keeps the upstream Orca Core architecture and extends it for custom SCS225 / ST3215-family hardware experiments.
For the original Orca Core documentation, installation instructions, architecture, and official supported hardware, refer to the upstream repository.
Maintainer
N-B-Studio
Repository:
https://github.com/N-B-Studio/orca_core
Development focus:
- Robotics
- Robot hands
- Servo control
- ROS 2
- Custom hardware integration
- SCS225 / ST3215-family servos
License
This fork retains the original Orca Core license.
See:
LICENSE

for the applicable license terms.
Safety
This software controls physical robotic hardware.
During testing:
- Keep hands, cables, and fragile objects clear of moving joints.
- Start with conservative torque limits.
- Verify servo IDs and directions before full-hand motion.
- Confirm calibration before running repeated pose sequences.
- Keep a fast way to remove actuator power during unexpected motion.
Use experimental hardware configurations at your own risk.
