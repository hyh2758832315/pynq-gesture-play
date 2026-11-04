set script_dir [file dirname [file normalize [info script]]]
set board_dir [file normalize [file join $script_dir ..]]
set project_name camera_overlay
set design_name camera
set project_dir [file join $board_dir build $project_name]
set output_dir [file join $board_dir output]
set report_dir [file join $output_dir reports camera]
set ps7_config [file join $board_dir generated pynq_z2_ps7_config.tcl]
set rtl [file join $board_dir rtl ov5640_bringup_io.v]
set frame_rtl [file join $board_dir rtl ov5640_frame_capture.v]
set constraints [file join $board_dir constraints camera_bringup.xdc]
set build_id 0xC00A0004

foreach required_file [list $ps7_config $rtl $frame_rtl $constraints] {
    if {![file exists $required_file]} {
        error "Missing required file: $required_file"
    }
}

file delete -force $project_dir
file mkdir $project_dir
file mkdir $output_dir
file mkdir $report_dir

create_project $project_name $project_dir -part xc7z020clg400-1 -force
set_property target_language Verilog [current_project]
set_property platform.name $project_name [current_project]
set_property platform.board_id pynq_z2 [current_project]
set_property platform.default_output_type sd_card [current_project]
set_property platform.design_intent.embedded true [current_project]
set_property platform.design_intent.server_managed false [current_project]
set_property platform.design_intent.external_host false [current_project]
set_property platform.design_intent.datacenter false [current_project]
add_files -norecurse $rtl
add_files -norecurse $frame_rtl
update_compile_order -fileset sources_1
create_bd_design $design_name

source $ps7_config
set_property -dict [list \
    CONFIG.PCW_EN_CLK1_PORT {0} \
    CONFIG.PCW_EN_CLK2_PORT {0} \
    CONFIG.PCW_EN_CLK3_PORT {0} \
    CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
    CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
    CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
    CONFIG.PCW_EN_EMIO_GPIO {0} \
    CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
    CONFIG.PCW_EN_I2C1 {0} \
    CONFIG.PCW_EN_EMIO_I2C1 {0} \
    CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_USE_FABRIC_INTERRUPT {0} \
    CONFIG.PCW_IRQ_F2P_INTR {0} \
    CONFIG.PCW_USE_M_AXI_GP0 {1} \
    CONFIG.PCW_USE_M_AXI_GP1 {0} \
    CONFIG.PCW_USE_S_AXI_GP0 {0} \
    CONFIG.PCW_USE_S_AXI_HP0 {0} \
    CONFIG.PCW_USE_S_AXI_HP2 {0} \
] $ps7_0

set ddr [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR]
set fixed_io [create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO]
connect_bd_intf_net [get_bd_intf_pins ps7_0/DDR] $ddr
connect_bd_intf_net [get_bd_intf_pins ps7_0/FIXED_IO] $fixed_io

set axi_smc [create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc]
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {3}] $axi_smc

set build_id_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 build_id_gpio]
set_property -dict [list CONFIG.C_ALL_INPUTS {1} CONFIG.C_GPIO_WIDTH {32} CONFIG.C_IS_DUAL {0}] $build_id_gpio
set build_id_constant [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 build_id_constant]
set_property -dict [list CONFIG.CONST_VAL $build_id CONFIG.CONST_WIDTH {32}] $build_id_constant

set camera_control_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 camera_control_gpio]
set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {3} \
    CONFIG.C_DOUT_DEFAULT {0x00000000} \
    CONFIG.C_IS_DUAL {1} \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {32} \
] $camera_control_gpio

set camera_frame_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 camera_frame_gpio]
set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {16} \
    CONFIG.C_DOUT_DEFAULT {0x00000000} \
    CONFIG.C_IS_DUAL {1} \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {32} \
] $camera_frame_gpio

set camera_io [create_bd_cell -type module -reference ov5640_bringup_io camera_io]
set camera_frame [create_bd_cell -type module -reference ov5640_frame_buffer camera_frame]
set camera_xclk [create_bd_port -dir O camera_xclk]
set camera_scl [create_bd_port -dir IO camera_scl]
set camera_sda [create_bd_port -dir IO camera_sda]
set camera_pclk [create_bd_port -dir I camera_pclk]
set camera_vsync [create_bd_port -dir I camera_vsync]
set camera_href [create_bd_port -dir I camera_href]
set camera_data [create_bd_port -dir I -from 7 -to 0 camera_data]
connect_bd_net [get_bd_pins camera_control_gpio/gpio_io_o] [get_bd_pins camera_io/control]
connect_bd_net [get_bd_pins camera_io/camera_status] [get_bd_pins camera_control_gpio/gpio2_io_i]
connect_bd_net [get_bd_pins camera_io/camera_xclk] $camera_xclk
connect_bd_net [get_bd_pins camera_io/camera_scl] $camera_scl
connect_bd_net [get_bd_pins camera_io/camera_sda] $camera_sda
connect_bd_net [get_bd_pins camera_io/camera_pclk] $camera_pclk
connect_bd_net [get_bd_pins camera_io/camera_vsync] $camera_vsync
connect_bd_net [get_bd_pins camera_io/camera_href] $camera_href
connect_bd_net [get_bd_pins camera_io/camera_data] $camera_data
connect_bd_net [get_bd_pins camera_frame/camera_pclk] $camera_pclk
connect_bd_net [get_bd_pins camera_frame/camera_vsync] $camera_vsync
connect_bd_net [get_bd_pins camera_frame/camera_href] $camera_href
connect_bd_net [get_bd_pins camera_frame/camera_data] $camera_data
connect_bd_net [get_bd_pins camera_frame_gpio/gpio_io_o] [get_bd_pins camera_frame/frame_control]
connect_bd_net [get_bd_pins camera_frame/read_status] [get_bd_pins camera_frame_gpio/gpio2_io_i]

set rst_fclk0 [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_fclk0]
connect_bd_intf_net [get_bd_intf_pins ps7_0/M_AXI_GP0] [get_bd_intf_pins axi_smc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins build_id_gpio/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_smc/M01_AXI] [get_bd_intf_pins camera_control_gpio/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_smc/M02_AXI] [get_bd_intf_pins camera_frame_gpio/S_AXI]
connect_bd_net [get_bd_pins build_id_constant/dout] [get_bd_pins build_id_gpio/gpio_io_i]
connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] \
    [get_bd_pins ps7_0/M_AXI_GP0_ACLK] \
    [get_bd_pins axi_smc/aclk] \
    [get_bd_pins build_id_gpio/s_axi_aclk] \
    [get_bd_pins camera_control_gpio/s_axi_aclk] \
    [get_bd_pins camera_frame_gpio/s_axi_aclk] \
    [get_bd_pins camera_io/clk] \
    [get_bd_pins camera_frame/clk] \
    [get_bd_pins rst_fclk0/slowest_sync_clk]
connect_bd_net [get_bd_pins ps7_0/FCLK_RESET0_N] [get_bd_pins rst_fclk0/ext_reset_in]
connect_bd_net [get_bd_pins rst_fclk0/interconnect_aresetn] [get_bd_pins axi_smc/aresetn]
connect_bd_net [get_bd_pins rst_fclk0/peripheral_aresetn] \
    [get_bd_pins build_id_gpio/s_axi_aresetn] \
    [get_bd_pins camera_control_gpio/s_axi_aresetn] \
    [get_bd_pins camera_io/resetn] \
    [get_bd_pins camera_frame_gpio/s_axi_aresetn] \
    [get_bd_pins camera_frame/resetn]

assign_bd_address -offset 0x41200000 -range 0x00010000 \
    -target_address_space [get_bd_addr_spaces ps7_0/Data] \
    [get_bd_addr_segs build_id_gpio/S_AXI/Reg] -force
assign_bd_address -offset 0x41210000 -range 0x00010000 \
    -target_address_space [get_bd_addr_spaces ps7_0/Data] \
    [get_bd_addr_segs camera_control_gpio/S_AXI/Reg] -force
assign_bd_address -offset 0x41220000 -range 0x00010000 \
    -target_address_space [get_bd_addr_spaces ps7_0/Data] \
    [get_bd_addr_segs camera_frame_gpio/S_AXI/Reg] -force

set_property PFM_NAME {xilinx.com:pynq:camera_overlay:1.0} [get_files ${design_name}.bd]
set_property PFM.CLOCK {FCLK_CLK0 {id "0" is_default "true" proc_sys_reset "rst_fclk0" status "fixed"}} $ps7_0

validate_bd_design
save_bd_design
set bd_file [get_files ${design_name}.bd]
generate_target all $bd_file
make_wrapper -files $bd_file -top
set wrapper [file join $project_dir ${project_name}.gen sources_1 bd $design_name hdl ${design_name}_wrapper.v]
add_files -norecurse $wrapper
add_files -fileset constrs_1 -norecurse $constraints
set_property top ${design_name}_wrapper [current_fileset]
update_compile_order -fileset sources_1

launch_runs synth_1 -jobs 1
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {
    error "Camera synthesis failed: [get_property STATUS [get_runs synth_1]]"
}

launch_runs impl_1 -to_step write_bitstream -jobs 1
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {
    error "Camera implementation failed: [get_property STATUS [get_runs impl_1]]"
}

open_run impl_1
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $report_dir timing_summary.rpt]
report_utilization -file [file join $report_dir utilization.rpt]
report_drc -file [file join $report_dir drc.rpt]
report_clock_interaction -file [file join $report_dir clock_interaction.rpt]
report_cdc -details -file [file join $report_dir cdc.rpt]
report_methodology -file [file join $report_dir methodology.rpt]

set setup_paths [get_timing_paths -delay_type max -max_paths 1 -nworst 1]
if {[llength $setup_paths] > 0 && [get_property SLACK [lindex $setup_paths 0]] < 0} {
    error "Camera setup timing failed: [get_property SLACK [lindex $setup_paths 0]] ns"
}
set hold_paths [get_timing_paths -delay_type min -max_paths 1 -nworst 1]
if {[llength $hold_paths] > 0 && [get_property SLACK [lindex $hold_paths 0]] < 0} {
    error "Camera hold timing failed: [get_property SLACK [lindex $hold_paths 0]] ns"
}

set bit_source [file join $project_dir ${project_name}.runs impl_1 ${design_name}_wrapper.bit]
set hwh_source [file join $project_dir ${project_name}.gen sources_1 bd $design_name hw_handoff ${design_name}.hwh]
if {![file exists $bit_source]} {
    error "Bitstream was not generated at $bit_source"
}
if {![file exists $hwh_source]} {
    error "Hardware handoff was not generated at $hwh_source"
}
file copy -force $bit_source [file join $output_dir ${project_name}.bit]
file copy -force $hwh_source [file join $output_dir ${project_name}.hwh]
write_hw_platform -fixed -include_bit -force [file join $output_dir ${project_name}.xsa]

set manifest [open [file join $output_dir camera_overlay_manifest.txt] w]
puts $manifest "PROJECT=$project_name"
puts $manifest "PART=xc7z020clg400-1"
puts $manifest "VIVADO=[version -short]"
puts $manifest "BUILD_ID=$build_id"
puts $manifest "BUILD_ID_ADDRESS=0x41200000"
puts $manifest "CAMERA_CONTROL_ADDRESS=0x41210000"
puts $manifest "CAMERA_CONTROL_BITS=SCL_LOW,SDA_LOW,XCLK_ENABLE"
puts $manifest "CAMERA_STATUS_ADDRESS=0x41210008"
puts $manifest "CAMERA_STATUS_BITS=SCL[0],SDA[1],DATA[9:2],PCLK[10],VSYNC[11],HREF[12],PCLK_EDGES[18:13],VSYNC_EDGES[24:19],HREF_EDGES[30:25]"
puts $manifest "FRAME_CONTROL_ADDRESS=0x41220000"
puts $manifest "FRAME_CONTROL_BITS=ADDRESS[14:0],CAPTURE_ENABLE[15]"
puts $manifest "FRAME_STATUS_ADDRESS=0x41220008"
puts $manifest "FRAME_STATUS_BITS=PIXEL[7:0],DONE[8],ERROR[9]"
puts $manifest "FRAME_FORMAT=PGM_160X120_YUV422_Y_BYTE_PHASE_0"
puts $manifest "XCLK_HZ=12500000"
puts $manifest "PS7_SOURCE=PYNQ v3.1 commit 19ed17d4fd4ea71f95a97d30f8ccd0d62b8dbaaa"
close $manifest

puts "CAMERA_BUILD_STATUS=PASS"
puts "CAMERA_BUILD_ID=$build_id"
puts "CAMERA_OUTPUT_DIR=$output_dir"
close_project
