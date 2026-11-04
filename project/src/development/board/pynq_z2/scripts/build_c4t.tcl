set script_dir [file dirname [file normalize [info script]]]
set board_dir [file normalize [file join $script_dir ..]]
set repo_dir [file normalize [file join $board_dir .. ..]]
set project_name c4_transport
set design_name c4t
set project_dir [file join $board_dir build $project_name]
set output_dir [file join $board_dir output]
set report_dir [file join $output_dir reports c4t]
set ps7_config [file join $board_dir generated pynq_z2_ps7_config.tcl]
set upload_rtl [file join $repo_dir rtl scene2d_gpu scene2d_upload_sink.sv]
set build_id 0xC0040000

foreach required [list $ps7_config $upload_rtl] {
    if {![file exists $required]} {
        error "Missing C4T dependency: $required"
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
add_files -norecurse $upload_rtl
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
    CONFIG.PCW_USE_M_AXI_GP0 {1} \
    CONFIG.PCW_USE_M_AXI_GP1 {0} \
    CONFIG.PCW_USE_S_AXI_GP0 {0} \
    CONFIG.PCW_USE_S_AXI_HP0 {1} \
    CONFIG.PCW_USE_S_AXI_HP2 {0} \
    CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
    CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
    CONFIG.PCW_IRQ_F2P_INTR {1} \
] $ps7_0

set ddr [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR]
set fixed_io [create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO]
connect_bd_intf_net [get_bd_intf_pins ps7_0/DDR] $ddr
connect_bd_intf_net [get_bd_intf_pins ps7_0/FIXED_IO] $fixed_io

set gp0_smc [create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 gp0_smc]
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {4}] $gp0_smc
set hp0_smc [create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 hp0_smc]
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {1}] $hp0_smc

set axi_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma]
set_property -dict [list \
    CONFIG.c_include_sg {0} \
    CONFIG.c_include_mm2s {1} \
    CONFIG.c_include_s2mm {0} \
    CONFIG.c_m_axi_mm2s_data_width {64} \
    CONFIG.c_m_axis_mm2s_tdata_width {64} \
    CONFIG.c_mm2s_burst_size {16} \
    CONFIG.c_sg_length_width {26} \
] $axi_dma

set build_id_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 build_id_gpio]
set_property -dict [list CONFIG.C_ALL_INPUTS {1} CONFIG.C_GPIO_WIDTH {32} CONFIG.C_IS_DUAL {0}] $build_id_gpio
set build_id_constant [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 build_id_constant]
set_property -dict [list CONFIG.CONST_VAL $build_id CONFIG.CONST_WIDTH {32}] $build_id_constant

set upload_status_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 upload_status_gpio]
set_property -dict [list \
    CONFIG.C_ALL_INPUTS {1} \
    CONFIG.C_GPIO_WIDTH {32} \
    CONFIG.C_IS_DUAL {1} \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {32} \
] $upload_status_gpio
set upload_count_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 upload_count_gpio]
set_property -dict [list CONFIG.C_ALL_INPUTS {1} CONFIG.C_GPIO_WIDTH {32} CONFIG.C_IS_DUAL {0}] $upload_count_gpio

set upload_sink [create_bd_cell -type module -reference scene2d_upload_sink upload_sink]
set rst_fclk0 [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_fclk0]
set irq_concat [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 irq_concat]
set_property CONFIG.NUM_PORTS {1} $irq_concat

connect_bd_intf_net [get_bd_intf_pins ps7_0/M_AXI_GP0] [get_bd_intf_pins gp0_smc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins gp0_smc/M00_AXI] [get_bd_intf_pins axi_dma/S_AXI_LITE]
connect_bd_intf_net [get_bd_intf_pins gp0_smc/M01_AXI] [get_bd_intf_pins build_id_gpio/S_AXI]
connect_bd_intf_net [get_bd_intf_pins gp0_smc/M02_AXI] [get_bd_intf_pins upload_status_gpio/S_AXI]
connect_bd_intf_net [get_bd_intf_pins gp0_smc/M03_AXI] [get_bd_intf_pins upload_count_gpio/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_dma/M_AXI_MM2S] [get_bd_intf_pins hp0_smc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins hp0_smc/M00_AXI] [get_bd_intf_pins ps7_0/S_AXI_HP0]

connect_bd_net [get_bd_pins axi_dma/m_axis_mm2s_tdata] [get_bd_pins upload_sink/s_axis_tdata]
connect_bd_net [get_bd_pins axi_dma/m_axis_mm2s_tkeep] [get_bd_pins upload_sink/s_axis_tkeep]
connect_bd_net [get_bd_pins axi_dma/m_axis_mm2s_tlast] [get_bd_pins upload_sink/s_axis_tlast]
connect_bd_net [get_bd_pins axi_dma/m_axis_mm2s_tvalid] [get_bd_pins upload_sink/s_axis_tvalid]
connect_bd_net [get_bd_pins upload_sink/s_axis_tready] [get_bd_pins axi_dma/m_axis_mm2s_tready]
connect_bd_net [get_bd_pins upload_sink/completed_crc32] [get_bd_pins upload_status_gpio/gpio_io_i]
connect_bd_net [get_bd_pins upload_sink/completed_byte_count] [get_bd_pins upload_status_gpio/gpio2_io_i]
connect_bd_net [get_bd_pins upload_sink/completed_packet_count] [get_bd_pins upload_count_gpio/gpio_io_i]
connect_bd_net [get_bd_pins build_id_constant/dout] [get_bd_pins build_id_gpio/gpio_io_i]
connect_bd_net [get_bd_pins axi_dma/mm2s_introut] [get_bd_pins irq_concat/In0]
connect_bd_net [get_bd_pins irq_concat/dout] [get_bd_pins ps7_0/IRQ_F2P]

connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] \
    [get_bd_pins ps7_0/M_AXI_GP0_ACLK] \
    [get_bd_pins ps7_0/S_AXI_HP0_ACLK] \
    [get_bd_pins gp0_smc/aclk] \
    [get_bd_pins hp0_smc/aclk] \
    [get_bd_pins axi_dma/s_axi_lite_aclk] \
    [get_bd_pins axi_dma/m_axi_mm2s_aclk] \
    [get_bd_pins axi_dma/m_axis_mm2s_aclk] \
    [get_bd_pins build_id_gpio/s_axi_aclk] \
    [get_bd_pins upload_status_gpio/s_axi_aclk] \
    [get_bd_pins upload_count_gpio/s_axi_aclk] \
    [get_bd_pins upload_sink/aclk] \
    [get_bd_pins rst_fclk0/slowest_sync_clk]
connect_bd_net [get_bd_pins ps7_0/FCLK_RESET0_N] [get_bd_pins rst_fclk0/ext_reset_in]
connect_bd_net [get_bd_pins rst_fclk0/interconnect_aresetn] \
    [get_bd_pins gp0_smc/aresetn] \
    [get_bd_pins hp0_smc/aresetn]
connect_bd_net [get_bd_pins rst_fclk0/peripheral_aresetn] \
    [get_bd_pins axi_dma/axi_resetn] \
    [get_bd_pins build_id_gpio/s_axi_aresetn] \
    [get_bd_pins upload_status_gpio/s_axi_aresetn] \
    [get_bd_pins upload_count_gpio/s_axi_aresetn] \
    [get_bd_pins upload_sink/aresetn]

assign_bd_address
assign_bd_address -offset 0x40400000 -range 0x00010000 \
    -target_address_space [get_bd_addr_spaces ps7_0/Data] \
    [get_bd_addr_segs axi_dma/S_AXI_LITE/Reg] -force
assign_bd_address -offset 0x41200000 -range 0x00010000 \
    -target_address_space [get_bd_addr_spaces ps7_0/Data] \
    [get_bd_addr_segs build_id_gpio/S_AXI/Reg] -force
assign_bd_address -offset 0x41210000 -range 0x00010000 \
    -target_address_space [get_bd_addr_spaces ps7_0/Data] \
    [get_bd_addr_segs upload_status_gpio/S_AXI/Reg] -force
assign_bd_address -offset 0x41220000 -range 0x00010000 \
    -target_address_space [get_bd_addr_spaces ps7_0/Data] \
    [get_bd_addr_segs upload_count_gpio/S_AXI/Reg] -force

set_property PFM_NAME {xilinx.com:pynq:c4_transport:1.0} [get_files ${design_name}.bd]
set_property PFM.CLOCK {FCLK_CLK0 {id "0" is_default "true" proc_sys_reset "rst_fclk0" status "fixed"}} $ps7_0

validate_bd_design
save_bd_design
set bd_file [get_files ${design_name}.bd]
generate_target all $bd_file
make_wrapper -files $bd_file -top
set wrapper [file join $project_dir ${project_name}.gen sources_1 bd $design_name hdl ${design_name}_wrapper.v]
add_files -norecurse $wrapper
set_property top ${design_name}_wrapper [current_fileset]
update_compile_order -fileset sources_1

launch_runs synth_1 -jobs 1
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {
    error "C4T synthesis failed: [get_property STATUS [get_runs synth_1]]"
}
launch_runs impl_1 -to_step write_bitstream -jobs 1
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {
    error "C4T implementation failed: [get_property STATUS [get_runs impl_1]]"
}

open_run impl_1
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $report_dir timing_summary.rpt]
set setup_paths [get_timing_paths -delay_type max -max_paths 1 -nworst 1]
set hold_paths [get_timing_paths -delay_type min -max_paths 1 -nworst 1]
if {[llength $setup_paths] == 0 || [llength $hold_paths] == 0} {
    error "C4T timing gate could not find setup and hold paths"
}
set setup_wns [get_property SLACK $setup_paths]
set hold_whs [get_property SLACK $hold_paths]
if {$setup_wns < 0.0 || $hold_whs < 0.0} {
    error "C4T timing failed: WNS=$setup_wns ns, WHS=$hold_whs ns"
}
report_utilization -file [file join $report_dir utilization.rpt]
report_drc -file [file join $report_dir drc.rpt]
set drc_failures [get_drc_violations -quiet -filter {SEVERITY == "Error" || SEVERITY == "Critical Warning"}]
if {[llength $drc_failures] != 0} {
    error "C4T DRC contains [llength $drc_failures] Error/Critical Warning violations"
}
set methodology_path [file join $report_dir methodology.rpt]
report_methodology -file $methodology_path
set methodology_file [open $methodology_path r]
set methodology_text [read $methodology_file]
close $methodology_file
if {[string first "Critical Warning" $methodology_text] >= 0} {
    error "C4T methodology report contains Critical Warnings: $methodology_path"
}
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
puts $manifest "DMA_CONTROL_ADDRESS=0x40400000"
puts $manifest "BUILD_ID_ADDRESS=0x41200000"
puts $manifest "UPLOAD_STATUS_ADDRESS=0x41210000"
puts $manifest "UPLOAD_COUNT_ADDRESS=0x41220000"
puts $manifest "HP0_DATA_WIDTH=64"
puts $manifest "AXIS_DATA_WIDTH=64"
puts $manifest "DMA_LENGTH_WIDTH=26"
puts $manifest "WNS_NS=$setup_wns"
puts $manifest "WHS_NS=$hold_whs"
close $manifest

puts "C4T_BUILD_STATUS=PASS"
close_project