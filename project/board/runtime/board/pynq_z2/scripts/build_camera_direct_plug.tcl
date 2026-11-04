set script_dir [file dirname [file normalize [info script]]]
set board_dir [file normalize [file join $script_dir ..]]
set iic_probe [expr {[info exists ::env(CAMERA_IIC_PROBE)] && $::env(CAMERA_IIC_PROBE) eq "1"}]
set corrected_pins [expr {[info exists ::env(CAMERA_CORRECTED_PINS)] && $::env(CAMERA_CORRECTED_PINS) eq "1"}]
set hdmi [expr {[info exists ::env(CAMERA_HDMI)] && $::env(CAMERA_HDMI) eq "1"}]
if {$hdmi && (!$corrected_pins || $iic_probe)} {
    error "CAMERA_HDMI requires CAMERA_CORRECTED_PINS=1 without CAMERA_IIC_PROBE"
}
set project_name [expr {$iic_probe ? "camera_direct_plug_ila" : "camera_direct_plug"}]
if {$corrected_pins} {
    append project_name _corrected
}
if {$hdmi} {
    append project_name _hdmi
}
set project_dir [file join $board_dir build $project_name]
if {$corrected_pins && [info exists ::env(CAMERA_BUILD_ROOT)]} {
    set project_dir [file normalize [file join $::env(CAMERA_BUILD_ROOT) $project_name]]
}
set report_dir [file join $board_dir output reports $project_name]
set ps7_config [file join $board_dir generated pynq_z2_ps7_config.tcl]
set constraints [file join $board_dir constraints camera_direct_plug.xdc]
if {$corrected_pins} {
    set constraints [file join $board_dir constraints camera_direct_plug_corrected.xdc]
}
set clock_probe [file join $board_dir constraints camera_direct_plug_clock_probe.xdc]
set rgb2dvi_repo [file join $board_dir generated rgb2dvi_v1_2]
set hdmi_constraints [file join $board_dir constraints c3_hdmi_out.xdc]

set required_files [list $ps7_config $constraints]
if {$hdmi} {
    lappend required_files $rgb2dvi_repo $hdmi_constraints
}
foreach required_file $required_files {
    if {![file exists $required_file]} {
        error "Missing required file: $required_file"
    }
}

create_project $project_name $project_dir -part xc7z020clg400-1 -force
set_property target_language Verilog [current_project]
if {$hdmi} {
    set_property ip_repo_paths [list $rgb2dvi_repo] [current_project]
    update_ip_catalog
}
if {$iic_probe} {
    add_files -norecurse [file join $board_dir rtl camera_iic_probe_tap.v]
    update_compile_order -fileset sources_1
}
create_bd_design camera

source $ps7_config
set_property -dict [list \
    CONFIG.PCW_EN_CLK1_PORT {1} \
    CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
    CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {24.000000} \
    CONFIG.PCW_USE_M_AXI_GP0 {1} \
    CONFIG.PCW_USE_M_AXI_GP1 {0} \
    CONFIG.PCW_USE_S_AXI_GP0 {0} \
    CONFIG.PCW_USE_S_AXI_HP0 {1} \
    CONFIG.PCW_USE_S_AXI_HP2 {0} \
] $ps7_0
if {$hdmi} {
    set_property CONFIG.PCW_USE_FABRIC_INTERRUPT {1} $ps7_0
}

set ddr [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR]
set fixed_io [create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO]
connect_bd_intf_net [get_bd_intf_pins ps7_0/DDR] $ddr
connect_bd_intf_net [get_bd_intf_pins ps7_0/FIXED_IO] $fixed_io

set control_smc [create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 control_smc]
set_property CONFIG.NUM_MI {3} $control_smc
set memory_smc [create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 memory_smc]
set_property CONFIG.NUM_SI [expr {$hdmi ? 2 : 1}] $memory_smc

set camera_iic [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 camera_iic]
set video_in [create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:5.0 video_in]
set_property -dict [list CONFIG.C_HAS_ASYNC_CLK {1} CONFIG.C_M_AXIS_VIDEO_FORMAT {12}] $video_in
set demosaic [create_bd_cell -type ip -vlnv xilinx.com:ip:v_demosaic:1.1 demosaic]
set frame_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 frame_dma]
set_property -dict [list CONFIG.c_include_mm2s [expr {$hdmi ? 1 : 0}] CONFIG.c_include_s2mm {1}] $frame_dma
if {$hdmi} {
    set_property CONFIG.c_m_axis_mm2s_tdata_width {24} $frame_dma
}
set reset [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset]
if {$hdmi} {
    set irq_concat [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 irq_concat]
    set_property CONFIG.NUM_PORTS {2} $irq_concat
    set pixel_clock [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 pixel_clock]
    set_property -dict [list CONFIG.PRIM_IN_FREQ {100.000} CONFIG.PRIM_SOURCE {Global_buffer} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {74.250} CONFIG.USE_LOCKED {true} CONFIG.USE_RESET {true} CONFIG.RESET_TYPE {ACTIVE_HIGH}] $pixel_clock
    set pixel_reset [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 pixel_reset]
    set video_timing [create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.2 video_timing]
    set_property -dict [list CONFIG.VIDEO_MODE {720p} CONFIG.HAS_AXI4_LITE {false} CONFIG.enable_detection {false}] $video_timing
    set video_out [create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 video_out]
    set rgb2dvi [create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi:1.2 rgb2dvi]
    set_property -dict [list CONFIG.kGenerateSerialClk {true} CONFIG.kClkPrimitive {MMCM} CONFIG.kClkRange {2} CONFIG.kRstActiveHigh {true}] $rgb2dvi
    set always_on [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 always_on]
    set_property CONFIG.CONST_VAL {1} $always_on
    foreach hdmi_port {hdmi_out_clk_p hdmi_out_clk_n} {
        create_bd_port -dir O $hdmi_port
    }
    foreach hdmi_port {hdmi_out_data_p hdmi_out_data_n} {
        create_bd_port -dir O -from 2 -to 0 $hdmi_port
    }
}
if {$iic_probe} {
    set iic_ila [create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 iic_ila]
    set_property -dict [list CONFIG.C_MONITOR_TYPE {Native} CONFIG.C_NUM_OF_PROBES {2} CONFIG.C_PROBE0_WIDTH {6} CONFIG.C_DATA_DEPTH {16384}] $iic_ila
    set iic_tap [create_bd_cell -type module -reference camera_iic_probe_tap iic_tap]
}

set vid_xclk [create_bd_port -dir O vid_xclk]
set vid_pclk [create_bd_port -dir I vid_pclk]
set vid_vsync [create_bd_port -dir I vid_vsync]
set vid_hsync [create_bd_port -dir I vid_hsync]
set vid_data [create_bd_port -dir I -from 7 -to 0 vid_data]
set vid_iic [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 vid_iic]

connect_bd_net [get_bd_pins ps7_0/FCLK_CLK1] $vid_xclk
connect_bd_net $vid_pclk [get_bd_pins video_in/vid_io_in_clk]
connect_bd_net $vid_vsync [get_bd_pins video_in/vid_vsync]
connect_bd_net $vid_hsync [get_bd_pins video_in/vid_active_video]
connect_bd_net $vid_data [get_bd_pins video_in/vid_data]
if {$iic_probe} {
    connect_bd_intf_net [get_bd_intf_pins camera_iic/IIC] [get_bd_intf_pins iic_tap/core_iic]
    connect_bd_intf_net [get_bd_intf_pins iic_tap/port_iic] $vid_iic
    connect_bd_net [get_bd_pins iic_tap/probe] [get_bd_pins iic_ila/probe0]
    connect_bd_net [get_bd_pins camera_iic/iic2intc_irpt] [get_bd_pins iic_ila/probe1]
} else {
    connect_bd_intf_net [get_bd_intf_pins camera_iic/IIC] $vid_iic
}
connect_bd_intf_net [get_bd_intf_pins video_in/video_out] [get_bd_intf_pins demosaic/s_axis_video]
connect_bd_intf_net [get_bd_intf_pins demosaic/m_axis_video] [get_bd_intf_pins frame_dma/S_AXIS_S2MM]

connect_bd_intf_net [get_bd_intf_pins ps7_0/M_AXI_GP0] [get_bd_intf_pins control_smc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins control_smc/M00_AXI] [get_bd_intf_pins camera_iic/S_AXI]
connect_bd_intf_net [get_bd_intf_pins control_smc/M01_AXI] [get_bd_intf_pins demosaic/s_axi_CTRL]
connect_bd_intf_net [get_bd_intf_pins control_smc/M02_AXI] [get_bd_intf_pins frame_dma/S_AXI_LITE]
connect_bd_intf_net [get_bd_intf_pins frame_dma/M_AXI_S2MM] [get_bd_intf_pins memory_smc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins memory_smc/M00_AXI] [get_bd_intf_pins ps7_0/S_AXI_HP0]
if {$hdmi} {
    connect_bd_intf_net [get_bd_intf_pins frame_dma/M_AXI_MM2S] [get_bd_intf_pins memory_smc/S01_AXI]
    connect_bd_intf_net [get_bd_intf_pins frame_dma/M_AXIS_MM2S] [get_bd_intf_pins video_out/video_in]
    connect_bd_intf_net [get_bd_intf_pins video_timing/vtiming_out] [get_bd_intf_pins video_out/vtiming_in]
    connect_bd_intf_net [get_bd_intf_pins video_out/vid_io_out] [get_bd_intf_pins rgb2dvi/RGB]
    connect_bd_net [get_bd_pins rgb2dvi/TMDS_Clk_p] [get_bd_ports hdmi_out_clk_p]
    connect_bd_net [get_bd_pins rgb2dvi/TMDS_Clk_n] [get_bd_ports hdmi_out_clk_n]
    connect_bd_net [get_bd_pins rgb2dvi/TMDS_Data_p] [get_bd_ports hdmi_out_data_p]
    connect_bd_net [get_bd_pins rgb2dvi/TMDS_Data_n] [get_bd_ports hdmi_out_data_n]
    connect_bd_net [get_bd_pins frame_dma/mm2s_introut] [get_bd_pins irq_concat/In0]
    connect_bd_net [get_bd_pins frame_dma/s2mm_introut] [get_bd_pins irq_concat/In1]
    connect_bd_net [get_bd_pins irq_concat/dout] [get_bd_pins ps7_0/IRQ_F2P]
}

connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] \
    [get_bd_pins ps7_0/M_AXI_GP0_ACLK] \
    [get_bd_pins ps7_0/S_AXI_HP0_ACLK] \
    [get_bd_pins control_smc/aclk] \
    [get_bd_pins memory_smc/aclk] \
    [get_bd_pins camera_iic/s_axi_aclk] \
    [get_bd_pins video_in/aclk] \
    [get_bd_pins demosaic/ap_clk] \
    [get_bd_pins frame_dma/s_axis_s2mm_aclk] \
    [get_bd_pins frame_dma/m_axi_s2mm_aclk] \
    [get_bd_pins frame_dma/s_axi_lite_aclk] \
    [get_bd_pins reset/slowest_sync_clk]
if {$hdmi} {
    connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] [get_bd_pins frame_dma/m_axi_mm2s_aclk] [get_bd_pins pixel_clock/clk_in1]
    connect_bd_net [get_bd_pins reset/peripheral_reset] [get_bd_pins pixel_clock/reset]
    connect_bd_net [get_bd_pins ps7_0/FCLK_RESET0_N] [get_bd_pins pixel_reset/ext_reset_in]
    connect_bd_net [get_bd_pins pixel_clock/locked] [get_bd_pins pixel_reset/dcm_locked]
    connect_bd_net [get_bd_pins pixel_clock/clk_out1] [get_bd_pins pixel_reset/slowest_sync_clk] [get_bd_pins frame_dma/m_axis_mm2s_aclk] [get_bd_pins video_out/aclk] [get_bd_pins video_timing/clk] [get_bd_pins rgb2dvi/PixelClk]
    connect_bd_net [get_bd_pins pixel_reset/peripheral_aresetn] [get_bd_pins video_out/aresetn] [get_bd_pins video_timing/resetn]
    connect_bd_net [get_bd_pins pixel_reset/peripheral_reset] [get_bd_pins rgb2dvi/aRst]
    connect_bd_net [get_bd_pins always_on/dout] [get_bd_pins video_out/aclken] [get_bd_pins video_out/vid_io_out_ce] [get_bd_pins video_timing/clken]
    connect_bd_net [get_bd_pins video_out/vtg_ce] [get_bd_pins video_timing/gen_clken]
}
if {$iic_probe} {
    connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] [get_bd_pins iic_ila/clk]
}
connect_bd_net [get_bd_pins ps7_0/FCLK_RESET0_N] [get_bd_pins reset/ext_reset_in]
connect_bd_net [get_bd_pins reset/interconnect_aresetn] \
    [get_bd_pins control_smc/aresetn] \
    [get_bd_pins memory_smc/aresetn]
connect_bd_net [get_bd_pins reset/peripheral_aresetn] \
    [get_bd_pins camera_iic/s_axi_aresetn] \
    [get_bd_pins demosaic/ap_rst_n] \
    [get_bd_pins frame_dma/axi_resetn]

if {$iic_probe} {
    create_bd_addr_seg -range 0x00010000 -offset 0x41600000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs camera_iic/S_AXI/Reg] SEG_camera_iic_Reg
    create_bd_addr_seg -range 0x00010000 -offset 0x43000000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs frame_dma/S_AXI_LITE/Reg] SEG_frame_dma_Reg
    create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs demosaic/s_axi_CTRL/Reg] SEG_demosaic_Reg
}
assign_bd_address
validate_bd_design
save_bd_design
puts "CAMERA_DIRECT_PLUG_BD_STATUS=PASS"
if {[info exists ::env(CAMERA_BD_ONLY)] && $::env(CAMERA_BD_ONLY) eq "1"} {
    close_project
    exit 0
}

set bd_file [get_files camera.bd]
generate_target all $bd_file
make_wrapper -files $bd_file -top
set wrapper [file join $project_dir ${project_name}.gen sources_1 bd camera hdl camera_wrapper.v]
add_files -norecurse $wrapper
add_files -fileset constrs_1 -norecurse $constraints
if {$hdmi} {
    add_files -fileset constrs_1 -norecurse $hdmi_constraints
}
if {[info exists ::env(CAMERA_CLOCK_PROBE)] && $::env(CAMERA_CLOCK_PROBE) eq "1"} {
    add_files -fileset constrs_1 -norecurse $clock_probe
    puts "CAMERA_CLOCK_PROBE=NONDEDICATED_OFFLINE_ONLY"
}
set_property top camera_wrapper [current_fileset]
update_compile_order -fileset sources_1

launch_runs synth_1 -jobs 1
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {
    error "Camera direct-plug synthesis failed: [get_property STATUS [get_runs synth_1]]"
}

launch_runs impl_1 -to_step place_design -jobs 1
wait_on_run impl_1
if {![get_property STEPS.PLACE_DESIGN.IS_COMPLETE [get_runs impl_1]]} {
    error "Camera direct-plug placement failed: [get_property STATUS [get_runs impl_1]]"
}

file mkdir $report_dir
open_run impl_1
report_drc -file [file join $report_dir drc_placed.rpt]
report_timing_summary -delay_type min_max -report_unconstrained \
    -file [file join $report_dir timing_placed.rpt]
report_clock_interaction -file [file join $report_dir clocks_placed.rpt]
puts "CAMERA_DIRECT_PLUG_PLACE_STATUS=PASS"
close_project