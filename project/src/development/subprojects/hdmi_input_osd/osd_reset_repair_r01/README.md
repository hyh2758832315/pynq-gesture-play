# R21 OSD AXI / pixel reset repair candidate (offline)

Target: PYNQ-Z2 (`xc7z020clg400-1`), Vivado/XSim 2026.1. The frozen production input is `deliveries/c6i-pl-vision-volume-osd-r21-marker-r02-20261023/overlay/osd-source`. Only `rtl/input_osd_top.sv` and `rtl/input_osd_ctrl.sv` differ from that input. This directory is an isolated source candidate; it does not contain a bitstream and has not been loaded on the board.

The R21 top-level reset combined AXI reset and pixel reset for the AXI-Lite control state. When the pixel clock/reset stayed low, the first OSD ID read could accept its address but never assert `RVALID`. The repair lets AXI response registers follow only AXI reset. Publication/shadow/mailbox registers still reset on either AXI or pixel reset; a commit while the pixel domain is reset is acknowledged and discarded. The pixel output remains reset until both domains are released. No register address, ID value, pixel geometry, or frame-boundary publication ABI changes.

Reproduce the frozen behavior and check the repaired candidate from the workspace root:

```powershell
.venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/run_xsim.py --bin D:/Xilinx/Vivado/2026.1/Vivado/bin --rtl deliveries/c6i-pl-vision-volume-osd-r21-marker-r02-20261023/overlay/osd-source --output build/hosd/osd-reset-r01/baseline-r02 --expect-blocked
.venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/run_xsim.py --bin D:/Xilinx/Vivado/2026.1/Vivado/bin --rtl subprojects/hdmi_input_osd/osd_reset_repair_r01/rtl --output build/hosd/osd-reset-r01/repaired-r04
.venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/run_xsim.py --bin D:/Xilinx/Vivado/2026.1/Vivado/bin --rtl subprojects/hdmi_input_osd/osd_reset_repair_r01/rtl --output build/hosd/osd-reset-r01/regression-full-r03 --regression --full-hdmi
```

The first two commands produce `step-0.log` through `step-2.log` and `receipt.json` under the named output directory. The expected terminal markers are `TEST_PASS OSD_AXI_PIXEL_RESET expected_blocked=1` for frozen R21 and `expected_blocked=0` plus `OSD_PIXEL_RESET_FLUSH_PASS` for the repair. The third command runs the original 1280×720 OSD pixel/AXI regression and writes the same output format; it reports `TEST_PASS input_osd`.

Compare out-of-context synthesis under the same part, Tcl script, and constraints:

```powershell
.venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/baseline/tools/run_synth.py --vivado D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat --output build/hosd/osd-reset-r01/ooc-baseline
.venv/Scripts/python.exe -I -B subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/run_synth.py --vivado D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat --output build/hosd/osd-reset-r01/ooc-synth-r03
```

Each synthesis command writes a source-hash receipt next to the output (`.json`), a Vivado log (`.log`), stdout (`.stdout.log`), and utilization/timing/CDC/DRC reports inside the output directory. Use a fresh output name to rerun; these scripts refuse to overwrite evidence. Both complete runs reported 457 LUT, 889 FF, zero BRAM/DSP, +5.570 ns setup slack, +0.164 ns hold slack in OOC synthesis. This is not full-design implementation timing signoff.

Next: integrate these two RTL changes into a **new** Overlay build, verify BD reset/clock wiring and full implementation timing, then run a board test with a bounded OSD ID read and pixel-reset/clock status probe before starting the full Agent. The board root cause remains a hypothesis until that probe or an equivalent hardware trace is captured. Do not overwrite the frozen R21 delivery.
