# PYNQ-Z2 xc7z020clg400-1, Vivado 2026.1: replace voice/audio with BTN0/BTN1.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -source E:/projects/fpga/voice-view-game/subprojects/button_only/configure_button_only.tcl -log D:/vvg_button_only_r22/configure.log -journal D:/vvg_button_only_r22/configure.jou
# Output: D:/vvg_button_only_r22/c6_latency.srcs/sources_1/bd/c6v/c6v.bd, configured_receipt.txt.
# Next: synthesize and route the whole design, then inspect timing/DRC before board load.

set stage {D:/vvg_button_only_r22}
set repo {E:/projects/fpga/voice-view-game}
if {[version -short] ne {2026.1}} {error {Vivado 2026.1 required}}
if {![file exists $stage/stage_receipt.json]} {error {isolated stage missing}}
open_project $stage/c6_latency.xpr
if {[get_property PART [current_project]] ne {xc7z020clg400-1}} {error {unexpected part}}
set bd_file [get_files -quiet $stage/c6_latency.srcs/sources_1/bd/c6v/c6v.bd]
if {[llength $bd_file] != 1} {error {expected one c6v block design}}
open_bd_design $bd_file
if {[llength [get_bd_cells -quiet voice_volume_0]] != 1 ||
    [llength [get_bd_cells -quiet audio_mclk]] != 1 ||
    [llength [get_bd_intf_pins -quiet gp0_smc/M30_AXI]] != 1} {
    error {unexpected baseline block design}
}
if {[llength [get_bd_cells -quiet button_gpio]] != 0} {error {button GPIO already present}}

delete_bd_objs [get_bd_cells {voice_volume_0 audio_mclk}]
foreach port {audio_clk_10MHz bclk lrclk sdata_i codec_address sdata_o} {
    set item [get_bd_ports -quiet $port]
    if {[llength $item] != 1} {error "missing baseline audio port $port"}
    delete_bd_objs $item
}

add_files -norecurse $repo/subprojects/button_only/rtl/button_sync.sv
set_property file_type SystemVerilog [get_files $repo/subprojects/button_only/rtl/button_sync.sv]
update_compile_order -fileset sources_1
set sync [create_bd_cell -type module -reference button_sync button_sync_0]
set gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 button_gpio]
set_property -dict [list CONFIG.C_GPIO_WIDTH {2} CONFIG.C_ALL_INPUTS {1} CONFIG.C_IS_DUAL {0}] $gpio
if {[get_property CONFIG.C_GPIO_WIDTH $gpio] ne {2} ||
    [get_property CONFIG.C_ALL_INPUTS $gpio] ne {1} ||
    [get_property CONFIG.C_IS_DUAL $gpio] ne {0}} {
    error {AXI GPIO parameter readback failed}
}
set_property CONFIG.CONST_VAL {0xC0060F00} [get_bd_cells build_id_constant]
if {[get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]] ne {0xC0060F00}} {
    error {build identity readback failed}
}
set btn [create_bd_port -dir I -from 1 -to 0 btn]
connect_bd_net $btn [get_bd_pins button_sync_0/btn]
connect_bd_net [get_bd_pins button_sync_0/btn_sync] [get_bd_pins button_gpio/gpio_io_i]
connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] [get_bd_pins button_sync_0/aclk] [get_bd_pins button_gpio/s_axi_aclk]
connect_bd_net [get_bd_pins rst_fclk0/peripheral_aresetn] [get_bd_pins button_sync_0/aresetn] [get_bd_pins button_gpio/s_axi_aresetn]
connect_bd_intf_net [get_bd_intf_pins gp0_smc/M30_AXI] [get_bd_intf_pins button_gpio/S_AXI]
assign_bd_address -target_address_space [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs button_gpio/S_AXI/Reg]
set button_seg [get_bd_addr_segs -quiet ps7_0/Data/SEG_button_gpio_Reg]
if {[llength $button_seg] != 1} {error {button address segment missing}}
set_property offset 0x43C10000 $button_seg
set_property range 4K $button_seg
if {[get_property OFFSET $button_seg] ne {0x43C10000}} {error {button address readback failed}}

set old_xdc [get_files -quiet -of_objects [get_filesets constrs_1] *c6v_volume*.xdc]
if {[llength $old_xdc] != 2} {error "expected two old audio constraints, got: $old_xdc"}
remove_files $old_xdc
add_files -fileset constrs_1 -norecurse $repo/subprojects/button_only/constraints/button_only.xdc
set legacy_voice [get_files -quiet *voice_volume*.sv]
if {[llength $legacy_voice] != 4} {error "expected four legacy voice sources, got: $legacy_voice"}
remove_files $legacy_voice
validate_bd_design
save_bd_design
update_compile_order -fileset sources_1
generate_target all $bd_file
report_ip_status -file $stage/button_ip_status.rpt
set out [open $stage/configured_receipt.txt w]
puts $out "board=PYNQ-Z2 xc7z020clg400-1"
puts $out "vivado=[version -short]"
puts $out "button_gpio_width=[get_property CONFIG.C_GPIO_WIDTH $gpio]"
puts $out "button_gpio_all_inputs=[get_property CONFIG.C_ALL_INPUTS $gpio]"
puts $out "button_gpio_offset=[get_property OFFSET $button_seg]"
puts $out "build_id=[get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]]"
puts $out "removed_audio_constraints=$old_xdc"
puts $out "board_access=false"
close $out
close_project
puts BUTTON_ONLY_BD_CONFIGURED
