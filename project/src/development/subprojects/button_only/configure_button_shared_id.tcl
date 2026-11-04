# PYNQ-Z2 xc7z020clg400-1, Vivado 2026.1: remove voice/audio and place BTN0/1 on the unused second channel of BUILD_ID GPIO.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -source E:/projects/fpga/voice-view-game/subprojects/button_only/configure_button_shared_id.tcl -log D:/vvg_button_only_r23b/configure.log
# Output: D:/vvg_button_only_r23b/c6_latency.srcs/sources_1/bd/c6v/c6v.bd and configured_receipt.txt.
# Next: synthesize and route the isolated project; verify HWH and timing before any board access.
set stage {D:/vvg_button_only_r23b}
set repo {E:/projects/fpga/voice-view-game}
if {[version -short] ne {2026.1} || ![file exists $stage/stage_receipt.json]} {
    error {isolated PYNQ-Z2 stage or Vivado 2026.1 missing}
}
open_project $stage/c6_latency.xpr
if {[get_property PART [current_project]] ne {xc7z020clg400-1}} {error {unexpected part}}
set bd_file [get_files -quiet $stage/c6_latency.srcs/sources_1/bd/c6v/c6v.bd]
if {[llength $bd_file] != 1} {error {expected one c6v block design}}
open_bd_design $bd_file
if {[llength [get_bd_cells -quiet voice_volume_0]] != 1 ||
    [llength [get_bd_cells -quiet audio_mclk]] != 1 ||
    [llength [get_bd_cells -quiet build_id_gpio]] != 1 ||
    [llength [get_bd_cells -quiet button_gpio]] != 0} {
    error {unexpected baseline block design}
}
set id_gpio [get_bd_cells build_id_gpio]
if {[get_property CONFIG.C_IS_DUAL $id_gpio] ne {0} ||
    [get_property CONFIG.C_GPIO_WIDTH $id_gpio] ne {32} ||
    [get_property CONFIG.C_ALL_INPUTS $id_gpio] ne {1}} {
    error {BUILD_ID GPIO channel 1 differs from frozen baseline}
}
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
set_property -dict [list CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_INPUTS_2 {1} CONFIG.C_GPIO2_WIDTH {2}] $id_gpio
if {[get_property CONFIG.C_IS_DUAL $id_gpio] ne {1} ||
    [get_property CONFIG.C_ALL_INPUTS_2 $id_gpio] ne {1} ||
    [get_property CONFIG.C_GPIO2_WIDTH $id_gpio] ne {2} ||
    [get_property CONFIG.C_GPIO_WIDTH $id_gpio] ne {32}} {
    error {BUILD_ID GPIO dual-channel readback failed}
}
set_property CONFIG.CONST_VAL {0xC0061000} [get_bd_cells build_id_constant]
if {[get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]] ne {0xC0061000}} {
    error {build identity readback failed}
}
set btn [create_bd_port -dir I -from 1 -to 0 btn]
connect_bd_net $btn [get_bd_pins button_sync_0/btn]
connect_bd_net [get_bd_pins button_sync_0/btn_sync] [get_bd_pins build_id_gpio/gpio2_io_i]
connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] [get_bd_pins button_sync_0/aclk]
connect_bd_net [get_bd_pins rst_fclk0/peripheral_aresetn] [get_bd_pins button_sync_0/aresetn]
set old_xdc [get_files -quiet -of_objects [get_filesets constrs_1] *c6v_volume*.xdc]
if {[llength $old_xdc] != 2} {error "expected two old audio constraints, got: $old_xdc"}
remove_files $old_xdc
add_files -fileset constrs_1 -norecurse $repo/subprojects/button_only/constraints/button_only.xdc
set legacy_voice [get_files -quiet $stage/c6_latency.srcs/sources_1/imports/*voice_volume*.sv]
if {[llength $legacy_voice] != 4} {error "expected four legacy voice sources, got: $legacy_voice"}
remove_files $legacy_voice
validate_bd_design
save_bd_design
update_compile_order -fileset sources_1
generate_target all $bd_file
report_ip_status -file $stage/button_ip_status.rpt
set out [open $stage/configured_receipt.txt w]
puts $out {board=PYNQ-Z2 xc7z020clg400-1}
puts $out "vivado=[version -short]"
puts $out {buttons=build_id_gpio/channel_2}
puts $out "button_width=[get_property CONFIG.C_GPIO2_WIDTH $id_gpio]"
puts $out "button_all_inputs=[get_property CONFIG.C_ALL_INPUTS_2 $id_gpio]"
puts $out "build_id=[get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]]"
puts $out "removed_audio_constraints=$old_xdc"
puts $out {board_access=false}
close $out
close_project
puts BUTTON_SHARED_ID_BD_CONFIGURED
