# Finish a stage whose BD generation completed before an unnecessary save_project_as error.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -source E:/projects/fpga/voice-view-game/subprojects/button_only/finalize_stage.tcl -log D:/vvg_button_only_r22/finalize.log
# Output: D:/vvg_button_only_r22/configured_receipt.txt, updated c6v.hwh.
# Next: run synthesis and inspect generated HWH, constraints, DRC, and timing.
set stage {D:/vvg_button_only_r22}
if {[version -short] ne {2026.1}} {error {wrong Vivado version}}
open_project $stage/c6_latency.xpr
if {[get_property PART [current_project]] ne {xc7z020clg400-1}} {error {wrong part}}
set bd_file [get_files -quiet $stage/c6_latency.srcs/sources_1/bd/c6v/c6v.bd]
open_bd_design $bd_file
if {[llength [get_bd_cells -quiet button_gpio]] != 1 ||
    [llength [get_bd_cells -quiet voice_volume_0]] != 0 ||
    [llength [get_bd_cells -quiet audio_mclk]] != 0} {error {BD topology wrong}}
set gpio [get_bd_cells button_gpio]
set_property CONFIG.CONST_VAL {0xC0060F00} [get_bd_cells build_id_constant]
set legacy_voice [get_files -quiet *voice_volume*.sv]
if {[llength $legacy_voice] != 4} {error "expected four legacy voice sources: $legacy_voice"}
remove_files $legacy_voice
validate_bd_design
save_bd_design
update_compile_order -fileset sources_1
generate_target all $bd_file
set address [get_bd_addr_segs ps7_0/Data/SEG_button_gpio_Reg]
if {[get_property OFFSET $address] ne {0x43C10000}} {error {button address changed}}
if {[get_property CONFIG.C_GPIO_WIDTH $gpio] ne {2} ||
    [get_property CONFIG.C_ALL_INPUTS $gpio] ne {1}} {error {button IP settings changed}}
if {[llength [get_files -quiet *c6v_volume*.xdc]] != 0 ||
    [llength [get_files -quiet *button_only.xdc]] != 1} {error {constraints wrong}}
set out [open $stage/configured_receipt.txt w]
puts $out "board=PYNQ-Z2 xc7z020clg400-1"
puts $out "vivado=[version -short]"
puts $out "button_gpio_width=[get_property CONFIG.C_GPIO_WIDTH $gpio]"
puts $out "button_gpio_all_inputs=[get_property CONFIG.C_ALL_INPUTS $gpio]"
puts $out "button_gpio_offset=[get_property OFFSET $address]"
puts $out "build_id=[get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]]"
puts $out "board_access=false"
close $out
close_project
puts BUTTON_ONLY_STAGE_READY
