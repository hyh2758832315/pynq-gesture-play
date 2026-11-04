set fusion_script_dir [file dirname [file normalize [info script]]]
set fusion_repo [file normalize [file join $fusion_script_dir .. .. ..]]
if {![namespace exists ::ipcfg] || ![info exists ::ipcfg::native_log_path]} {
    error "fusion build requires initialized ipcfg with the exact native session log"
}
set fusion_root E:/vvfv/20261022/r1
if {[info exists ::env(VVG_VOLUME_BUILD_ROOT)]} {
    set fusion_root [file normalize $::env(VVG_VOLUME_BUILD_ROOT)]
}
if {[file exists [file join $fusion_root c6v]]} {
    error "refusing occupied fusion project: $fusion_root"
}
set ::env(VVG_VISION_BUILD_ROOT) $fusion_root
if {[info exists ::env(VVG_VISION_STAGE)]} {
    error "fusion creation requires an explicit fresh baseline, not a resume stage"
}
source -notrace [file join $fusion_script_dir build_c6i_vision.tcl]
proc add_c6v_volume {fusion_repo fusion_root} {
set fusion_previous_addresses [dict create]
foreach segment [get_bd_addr_segs -of_objects [get_bd_addr_spaces ps7_0/Data]] {
    dict set fusion_previous_addresses $segment [list [get_property OFFSET $segment] [get_property RANGE $segment]]
}
add_files -norecurse [glob [file join $fusion_repo rtl voice_volume *.sv]]
update_compile_order -fileset sources_1
set fusion_ps_config [list CONFIG.PCW_I2C1_PERIPHERAL_ENABLE 1 CONFIG.PCW_I2C1_I2C1_IO EMIO]
if {[namespace exists ::ipcfg]} {
    set result [ipcfg::apply_dict ps7_0 $fusion_ps_config]
    if {![string match {SUCCESS:*} $result]} {error $result}
} else {
    set_property -dict $fusion_ps_config [get_bd_cells ps7_0]
}
foreach {key wanted} $fusion_ps_config {
    if {[get_property $key [get_bd_cells ps7_0]] ne $wanted} {error "fusion PS readback failed: $key"}
}
if {[get_property CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ [get_bd_cells ps7_0]] != 100} {
    error "VOL1 requires the preserved 100 MHz control clock"
}
make_bd_intf_pins_external [get_bd_intf_pins ps7_0/IIC_1]
set_property name IIC_1 [get_bd_intf_ports IIC_1_0]
vision_ip xilinx.com:ip:clk_wiz:6.0 audio_mclk [list CONFIG.PRIM_SOURCE No_buffer \
    CONFIG.PRIM_IN_FREQ 100.000 CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 10.000 CONFIG.USE_RESET false]
vision_ip xilinx.com:ip:xlconstant:1.1 volume_zero [list CONFIG.CONST_WIDTH 1 CONFIG.CONST_VAL 0]
create_bd_cell -type module -reference voice_volume_top voice_volume_0
set fusion_master_index [get_property CONFIG.NUM_MI [get_bd_cells gp0_smc]]
set_property CONFIG.NUM_MI [expr {$fusion_master_index + 1}] [get_bd_cells gp0_smc]
if {[get_property CONFIG.NUM_MI [get_bd_cells gp0_smc]] != $fusion_master_index + 1} {
    error "fusion GP0 master count readback failed"
}
connect_bd_intf_net [get_bd_intf_pins gp0_smc/M[format %02d $fusion_master_index]_AXI] [get_bd_intf_pins voice_volume_0/s_axi]
vision_net ps7_0/FCLK_CLK0 audio_mclk/clk_in1
vision_net ps7_0/FCLK_CLK0 voice_volume_0/s_axi_aclk
vision_net rst_fclk0/peripheral_aresetn voice_volume_0/s_axi_aresetn
vision_net audio_mclk/locked voice_volume_0/codec_mclk_locked
make_bd_pins_external [get_bd_pins audio_mclk/clk_out1]
set_property name audio_clk_10MHz [get_bd_ports clk_out1_0]
foreach {pin port} {i2s_bclk bclk i2s_lrclk lrclk i2s_sdata sdata_i codec_address codec_address} {
    make_bd_pins_external [get_bd_pins voice_volume_0/$pin]
    set_property name $port [get_bd_ports ${pin}_0]
}
create_bd_port -dir O sdata_o
connect_bd_net [get_bd_pins volume_zero/dout] [get_bd_ports sdata_o]
set fusion_segments [get_bd_addr_segs -of_objects [get_bd_intf_pins voice_volume_0/s_axi]]
if {[llength $fusion_segments] != 1} {error "expected one fusion VOL1 control segment"}
assign_bd_address -offset 0x43C10000 -range 4K -target_address_space [get_bd_addr_spaces ps7_0/Data] $fusion_segments
set_property CONFIG.CONST_VAL 0xC0060C00 [get_bd_cells build_id_constant]
if {[get_property CONFIG.CONST_VAL [get_bd_cells build_id_constant]] != 0xC0060C00} {error "fusion BUILD readback failed"}
dict for {segment expected} $fusion_previous_addresses {
    if {[list [get_property OFFSET $segment] [get_property RANGE $segment]] ne $expected} {
        error "fusion changed baseline address: $segment"
    }
}
return "SUCCESS:applied C6V_VOLUME_CONFIGURED BUILD_ID=0xC0060C00 BASE=0x43C10000 PROFILE=C6I_VISION_VOLUME_V1 BOARD_PENDING=1"
}
set fusion_evidence [file join $fusion_root fusion-config.[clock clicks].tcldict]
set fusion_receipt [ipcfg::capture $fusion_evidence [list add_c6v_volume $fusion_repo $fusion_root] {SUCCESS:applied}]
puts $fusion_receipt
if {[dict get $fusion_receipt status] ne "OK"} {error "fusion configuration failed: $fusion_evidence"}
vision_gp0_pipeline
validate_bd_design
source -notrace [file join $fusion_script_dir check_c6i_volume.tcl]
save_bd_design
set fusion_bd [get_files c6v.bd]
generate_target all $fusion_bd
export_ip_user_files -of_objects $fusion_bd -no_script -sync -force -quiet
make_wrapper -files $fusion_bd -top
add_files -fileset constrs_1 -norecurse [file join $fusion_repo board pynq_z2 constraints c6v_volume.xdc]
add_files -fileset constrs_1 -norecurse [file join $fusion_repo board pynq_z2 constraints c6v_volume_baseline.xdc]
set_property USED_IN_SYNTHESIS false [get_files c6v_volume_baseline.xdc]
add_files -fileset utils_1 -norecurse [file join $fusion_script_dir check_c6i_volume_postopt.tcl]
set_property STEPS.OPT_DESIGN.TCL.POST [file join $fusion_script_dir check_c6i_volume_postopt.tcl] [get_runs impl_1]
set fusion_old_cdc [get_files -quiet *c4m3_cdc.xdc]
if {[llength $fusion_old_cdc]} {remove_files $fusion_old_cdc}
add_files -fileset constrs_1 -norecurse [file join $fusion_repo board pynq_z2 constraints c6v_sync_cdc.xdc]
set_property USED_IN_SYNTHESIS false [get_files c6v_sync_cdc.xdc]
set_property PROCESSING_ORDER LATE [get_files c6v_sync_cdc.xdc]
update_compile_order -fileset sources_1
write_bd_tcl [file join $fusion_root recreate_c6v_volume_bd.tcl]
source -notrace [file join $fusion_script_dir check_c6i_volume.tcl]
set fusion_final_requirements [ipcfg::audit_requirements vision_gp0_slice]
if {![regexp {^REQ:OK($| )} $fusion_final_requirements]} {error $fusion_final_requirements}
puts C6V_VOLUME_PREPARED