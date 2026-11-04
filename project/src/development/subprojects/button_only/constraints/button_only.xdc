# PYNQ-Z2 BTN0/BTN1, plus existing camera IIC and video clock route exception.
# Run: source this file through the staged Vivado project's constrs_1 fileset.
# Output: BTN0/BTN1 package pin and camera IIC constraints in the routed design.
# Next: inspect report_drc and report_timing_summary before programming hardware.
set_property PACKAGE_PIN U9 [get_ports IIC_1_scl_io]
set_property PACKAGE_PIN T9 [get_ports IIC_1_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports {IIC_1_scl_io IIC_1_sda_io}]
set_property PULLUP true [get_ports {IIC_1_scl_io IIC_1_sda_io}]
set_property PACKAGE_PIN D19 [get_ports {btn[0]}]
set_property PACKAGE_PIN D20 [get_ports {btn[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[*]}]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets vid_pclk_IBUF]
