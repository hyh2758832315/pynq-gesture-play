# Source: Xilinx/PYNQ commit 19ed17d4fd4ea71f95a97d30f8ccd0d62b8dbaaa
# Source file: boards/Pynq-Z2/base/vivado/constraints/base.xdc
# Source Git blob: fb77db7aee82cc9ad8614c8b77ba953d7c28a8f4
# Source SHA-256: 05D99C9032CEB21B2F6850955DD897A14A30D77EBDA21D57867DAA65CAEF2D3B

set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports {btn[0]}]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {btn[1]}]
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports {btn[2]}]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports {btn[3]}]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports {sw[0]}]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports {sw[1]}]