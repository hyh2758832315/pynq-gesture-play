set script_dir [file dirname [file normalize [info script]]]
set board_dir [file normalize [file join $script_dir ..]]
set repo_dir [file normalize [file join $board_dir .. ..]]
set project_name c3_overlay
set design_name c3
set project_dir [file join $board_dir build $project_name]
set output_dir [file join $board_dir output]
set report_dir [file join $output_dir reports c3]
set ps7_config [file join $board_dir generated pynq_z2_ps7_config.tcl]
set rgb2dvi_repo [file join $board_dir generated rgb2dvi_v1_2]
set tmds_interface_repo [file join $rgb2dvi_repo tmds_v1_0]
set constraints [file join $board_dir constraints c3_hdmi_out.xdc]
set timing_rtl [file join $repo_dir rtl scene2d_gpu scene2d_video_timing.sv]
set pattern_rtl [file join $repo_dir rtl scene2d_gpu scene2d_test_pattern.sv]
set build_id 0xC0030001

foreach required [list $ps7_config $rgb2dvi_repo $tmds_interface_repo $constraints $timing_rtl $pattern_rtl] {
    if {![file exists $required]} {
        error "Missing C3 dependency: $required"
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
set_property ip_repo_paths [list $rgb2dvi_repo] [current_project]
update_ip_catalog
add_files -norecurse [list $timing_rtl $pattern_rtl]
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
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {1}] $axi_smc
set build_id_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 build_id_gpio]
set_property -dict [list CONFIG.C_ALL_INPUTS {1} CONFIG.C_GPIO_WIDTH {32} CONFIG.C_IS_DUAL {0}] $build_id_gpio
set build_id_constant [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 build_id_constant]
set_property -dict [list CONFIG.CONST_VAL $build_id CONFIG.CONST_WIDTH {32}] $build_id_constant

set rst_fclk0 [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_fclk0]
set pixel_clock [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 pixel_clock]
set_property -dict [list \
    CONFIG.PRIM_IN_FREQ {100.000} \
    CONFIG.PRIM_SOURCE {Global_buffer} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {74.250} \
    CONFIG.USE_LOCKED {true} \
    CONFIG.USE_RESET {true} \
    CONFIG.RESET_TYPE {ACTIVE_HIGH} \
] $pixel_clock
set rst_pixel [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_pixel]

set test_pattern [create_bd_cell -type module -reference scene2d_test_pattern test_pattern]
set rgb2dvi [create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi:1.2 rgb2dvi]
set_property -dict [list \
    CONFIG.kGenerateSerialClk {true} \
    CONFIG.kClkPrimitive {MMCM} \
    CONFIG.kClkRange {2} \
    CONFIG.kRstActiveHigh {true} \
] $rgb2dvi

set hdmi_out_clk_p [create_bd_port -dir O hdmi_out_clk_p]
set hdmi_out_clk_n [create_bd_port -dir O hdmi_out_clk_n]
set hdmi_out_data_p [create_bd_port -dir O -from 2 -to 0 hdmi_out_data_p]
set hdmi_out_data_n [create_bd_port -dir O -from 2 -to 0 hdmi_out_data_n]

connect_bd_intf_net [get_bd_intf_pins ps7_0/M_AXI_GP0] [get_bd_intf_pins axi_smc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins build_id_gpio/S_AXI]
connect_bd_net [get_bd_pins build_id_constant/dout] [get_bd_pins build_id_gpio/gpio_io_i]

connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] \
    [get_bd_pins ps7_0/M_AXI_GP0_ACLK] \
    [get_bd_pins axi_smc/aclk] \
    [get_bd_pins build_id_gpio/s_axi_aclk] \
    [get_bd_pins rst_fclk0/slowest_sync_clk] \
    [get_bd_pins pixel_clock/clk_in1]
connect_bd_net [get_bd_pins ps7_0/FCLK_RESET0_N] \
    [get_bd_pins rst_fclk0/ext_reset_in] \
    [get_bd_pins rst_pixel/ext_reset_in]
connect_bd_net [get_bd_pins rst_fclk0/peripheral_reset] [get_bd_pins pixel_clock/reset]
connect_bd_net [get_bd_pins rst_fclk0/interconnect_aresetn] [get_bd_pins axi_smc/aresetn]
connect_bd_net [get_bd_pins rst_fclk0/peripheral_aresetn] [get_bd_pins build_id_gpio/s_axi_aresetn]

connect_bd_net [get_bd_pins pixel_clock/clk_out1] \
    [get_bd_pins rst_pixel/slowest_sync_clk] \
    [get_bd_pins test_pattern/clk_pixel] \
    [get_bd_pins rgb2dvi/PixelClk]
connect_bd_net [get_bd_pins pixel_clock/locked] [get_bd_pins rst_pixel/dcm_locked]
connect_bd_net [get_bd_pins rst_pixel/peripheral_aresetn] [get_bd_pins test_pattern/resetn_pixel]
connect_bd_net [get_bd_pins rst_pixel/peripheral_reset] [get_bd_pins rgb2dvi/aRst]

connect_bd_net [get_bd_pins test_pattern/vid_data] [get_bd_pins rgb2dvi/vid_pData]
connect_bd_net [get_bd_pins test_pattern/vid_de] [get_bd_pins rgb2dvi/vid_pVDE]
connect_bd_net [get_bd_pins test_pattern/vid_hsync] [get_bd_pins rgb2dvi/vid_pHSync]
connect_bd_net [get_bd_pins test_pattern/vid_vsync] [get_bd_pins rgb2dvi/vid_pVSync]
connect_bd_net [get_bd_pins rgb2dvi/TMDS_Clk_p] $hdmi_out_clk_p
connect_bd_net [get_bd_pins rgb2dvi/TMDS_Clk_n] $hdmi_out_clk_n
connect_bd_net [get_bd_pins rgb2dvi/TMDS_Data_p] $hdmi_out_data_p
connect_bd_net [get_bd_pins rgb2dvi/TMDS_Data_n] $hdmi_out_data_n

assign_bd_address -offset 0x41200000 -range 0x00010000 \
    -target_address_space [get_bd_addr_spaces ps7_0/Data] \
    [get_bd_addr_segs build_id_gpio/S_AXI/Reg] -force

set_property PFM_NAME {xilinx.com:pynq:c3_overlay:1.0} [get_files ${design_name}.bd]
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
    error "C3 synthesis failed: [get_property STATUS [get_runs synth_1]]"
}
launch_runs impl_1 -to_step write_bitstream -jobs 1
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {
    error "C3 implementation failed: [get_property STATUS [get_runs impl_1]]"
}

open_run impl_1
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $report_dir timing_summary.rpt]
set setup_paths [get_timing_paths -delay_type max -max_paths 1 -nworst 1]
set hold_paths [get_timing_paths -delay_type min -max_paths 1 -nworst 1]
if {[llength $setup_paths] == 0 || [llength $hold_paths] == 0} {
    error "C3 timing gate could not find setup and hold paths"
}
set setup_wns [get_property SLACK $setup_paths]
set hold_whs [get_property SLACK $hold_paths]
if {$setup_wns < 0.0 || $hold_whs < 0.0} {
    error "C3 timing failed: WNS=$setup_wns ns, WHS=$hold_whs ns"
}
report_utilization -file [file join $report_dir utilization.rpt]
report_drc -file [file join $report_dir drc.rpt]
set methodology_path [file join $report_dir methodology.rpt]
report_methodology -file $methodology_path
set methodology_file [open $methodology_path r]
set methodology_text [read $methodology_file]
close $methodology_file
if {[string first "Critical Warning" $methodology_text] >= 0} {
    error "C3 methodology report contains Critical Warnings: $methodology_path"
}
report_clock_utilization -file [file join $report_dir clock_utilization.rpt]
report_clock_interaction -file [file join $report_dir clock_interaction.rpt]

set bit_source [file join $project_dir ${project_name}.runs impl_1 ${design_name}_wrapper.bit]
set hwh_source [file join $project_dir ${project_name}.gen sources_1 bd $design_name hw_handoff ${design_name}.hwh]
file copy -force $bit_source [file join $output_dir ${project_name}.bit]
file copy -force $hwh_source [file join $output_dir ${project_name}.hwh]
write_hw_platform -fixed -include_bit -force [file join $output_dir ${project_name}.xsa]

set manifest [open [file join $output_dir ${project_name}_manifest.txt] w]
puts $manifest "PROJECT=$project_name"
puts $manifest "PART=xc7z020clg400-1"
puts $manifest "VIVADO=[version -short]"
puts $manifest "BUILD_ID=$build_id"
puts $manifest "BUILD_ID_ADDRESS=0x41200000"
puts $manifest "PIXEL_CLOCK_MHZ=74.25"
puts $manifest "VIDEO_MODE=1280x720p60"
puts $manifest "LOGICAL_MODE=320x180_4X"
puts $manifest "RGB2DVI=digilentinc.com:ip:rgb2dvi:1.2"
puts $manifest "RGB2DVI_SOURCE=PYNQ commit 19ed17d4fd4ea71f95a97d30f8ccd0d62b8dbaaa"
close $manifest

puts "C3_BUILD_STATUS=PASS"
close_project