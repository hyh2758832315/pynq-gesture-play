set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 DRIVE 4 SLEW SLOW} [get_ports camera_xclk]
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33 PULLUP true} [get_ports camera_scl]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 PULLUP true} [get_ports camera_sda]

set_false_path -from [get_ports {camera_scl camera_sda}]
set_false_path -to [get_ports {camera_xclk camera_scl camera_sda}]