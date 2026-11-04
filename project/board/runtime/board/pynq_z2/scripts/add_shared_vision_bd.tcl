proc vision_ip {vlnv name configuration} {
    if {[namespace exists ::ipcfg]} {
        set result [ipcfg::create_cell_cfg $vlnv $name $configuration]
        if {![string match {SUCCESS:*} $result]} { error $result }
    } else {
        create_bd_cell -type ip -vlnv $vlnv $name
        if {[llength $configuration]} { set_property -dict $configuration [get_bd_cells $name] }
    }
    foreach {key wanted} $configuration {
        set actual [get_property $key [get_bd_cells $name]]
        if {[string is double -strict $actual] && [string is double -strict $wanted]} {
            if {$actual != $wanted} { error "$name $key readback $actual expected $wanted" }
        } elseif {$actual ne $wanted} {
            error "$name $key readback $actual expected $wanted"
        }
    }
    return [get_bd_cells $name]
}

proc vision_net {source target} {
    set source_pin [get_bd_pins $source]
    set target_pin [get_bd_pins $target]
    set source_net [get_bd_nets -quiet -of_objects $source_pin]
    set target_net [get_bd_nets -quiet -of_objects $target_pin]
    if {[llength $target_net]} {
        if {$source_net eq $target_net} { return }
        error "Shared vision net conflict at $target: $target_net expected $source_net"
    }
    connect_bd_net $source_pin $target_pin
}

proc vision_gp0_pipeline {} {
    if {[llength [get_bd_cells -quiet vision_gp0_slice]] == 0} {
        set source [get_bd_intf_pins ps7_0/M_AXI_GP0]
        set target [get_bd_intf_pins gp0_smc/S00_AXI]
        set net [get_bd_intf_nets -of_objects $source]
        if {[llength $net] != 1 || $net ne [get_bd_intf_nets -of_objects $target]} {
            error "GP0 pipeline requires the original direct PS-to-SmartConnect interface"
        }
        vision_ip xilinx.com:ip:axi_register_slice:2.1 vision_gp0_slice [list \
            CONFIG.REG_AW {1} CONFIG.REG_AR {1} CONFIG.REG_W {1} \
            CONFIG.REG_R {1} CONFIG.REG_B {1}]
        disconnect_bd_intf_net $net $target
        connect_bd_intf_net $source [get_bd_intf_pins vision_gp0_slice/S_AXI]
        connect_bd_intf_net [get_bd_intf_pins vision_gp0_slice/M_AXI] $target
    }
    vision_net ps7_0/FCLK_CLK0 vision_gp0_slice/aclk
    vision_net rst_fclk0/peripheral_aresetn vision_gp0_slice/aresetn
    set configuration [list CONFIG.REG_AW {1} CONFIG.REG_AR {1} CONFIG.REG_W {1} \
        CONFIG.REG_R {1} CONFIG.REG_B {1}]
    if {[namespace exists ::ipcfg]} {
        set evidence [file join [get_property DIRECTORY [current_project]] .ipcfg gp0_full.[clock clicks].tcldict]
        set receipt [ipcfg::capture $evidence \
            [list ipcfg::require vision_gp0_slice $configuration {GP0 timing boundary: all AXI channels Full}] \
            {REQ:pinned+applied}]
        puts $receipt
        if {[dict get $receipt status] ne "OK"} { error "GP0 Full configuration failed: $evidence" }
    } else {
        set_property -dict $configuration [get_bd_cells vision_gp0_slice]
    }
    foreach channel {AW AR W R B} {
        if {[get_property CONFIG.REG_$channel [get_bd_cells vision_gp0_slice]] != 1} {
            error "GP0 $channel channel must remain fully registered"
        }
    }
}

if {[info exists vision_pipeline_only] && $vision_pipeline_only} {
    vision_gp0_pipeline
    validate_bd_design
    if {[namespace exists ::ipcfg]} {
        set audit [ipcfg::audit_requirements vision_gp0_slice]
        if {![regexp {^REQ:OK($| )} $audit]} { error $audit }
    }
    save_bd_design
    unset vision_pipeline_only
    return
}

if {![info exists vision_wiring_resume]} {
if {[llength [get_bd_cells -quiet camera_iic]] == 0} {
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP1 {1} CONFIG.PCW_USE_S_AXI_HP3 {1} \
    CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
    CONFIG.PCW_EN_CLK1_PORT {1} CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
    CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {24.000000}] $ps7_0
vision_gp0_pipeline
set vision_gp_index [get_property CONFIG.NUM_MI $gp0_smc]
set_property CONFIG.NUM_MI [expr {$vision_gp_index + 1}] $gp0_smc
vision_ip xilinx.com:ip:smartconnect:1.0 vision_control_smc [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {5}]
vision_ip xilinx.com:ip:smartconnect:1.0 camera_hp1_smc [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {1}]
vision_ip xilinx.com:ip:smartconnect:1.0 skin_hp3_smc [list CONFIG.NUM_SI {2} CONFIG.NUM_MI {1}]
vision_ip xilinx.com:ip:axi_iic:2.1 camera_iic [list]
vision_ip xilinx.com:ip:v_vid_in_axi4s:5.0 video_in [list CONFIG.C_HAS_ASYNC_CLK {1} CONFIG.C_M_AXIS_VIDEO_FORMAT {12}]
vision_ip xilinx.com:ip:v_demosaic:1.1 demosaic [list]
vision_ip xilinx.com:ip:axi_vdma:6.3 frame_dma [list CONFIG.c_include_mm2s {0} CONFIG.c_include_s2mm {1}]
vision_ip xilinx.com:ip:axi_dma:7.1 moments_dma [list CONFIG.c_include_sg {0} \
    CONFIG.c_include_mm2s {1} CONFIG.c_include_s2mm {1} CONFIG.c_m_axi_mm2s_data_width {64} \
    CONFIG.c_m_axi_s2mm_data_width {64} CONFIG.c_m_axis_mm2s_tdata_width {32} \
    CONFIG.c_s_axis_s2mm_tdata_width {32} CONFIG.c_mm2s_burst_size {16} \
    CONFIG.c_s2mm_burst_size {16} CONFIG.c_sg_length_width {26}]
vision_ip xilinx.com:ip:axi_gpio:2.0 moments_reset [list CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_GPIO_WIDTH {1} CONFIG.C_IS_DUAL {0}]
vision_ip xilinx.com:ip:util_vector_logic:2.0 skin_reset_and [list CONFIG.C_OPERATION {and} CONFIG.C_SIZE {1}]
} else {
    if {[llength [get_bd_cells -quiet skin_kernel]] != 0} {
        error "Shared vision already connected; preserve project and repair the reported boundary"
    }
    set vision_gp_index [expr {[get_property CONFIG.NUM_MI [get_bd_cells gp0_smc]] - 1}]
}
create_bd_cell -type module -reference bgr_skin_dma skin_kernel

connect_bd_intf_net [get_bd_intf_pins gp0_smc/[format M%02d_AXI $vision_gp_index]] [get_bd_intf_pins vision_control_smc/S00_AXI]
foreach index {0 1 2 3 4} endpoint {camera_iic/S_AXI demosaic/s_axi_CTRL frame_dma/S_AXI_LITE moments_dma/S_AXI_LITE moments_reset/S_AXI} {
    connect_bd_intf_net [get_bd_intf_pins vision_control_smc/[format M%02d_AXI $index]] [get_bd_intf_pins $endpoint]
}
connect_bd_intf_net [get_bd_intf_pins frame_dma/M_AXI_S2MM] [get_bd_intf_pins camera_hp1_smc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins camera_hp1_smc/M00_AXI] [get_bd_intf_pins ps7_0/S_AXI_HP1]
connect_bd_intf_net [get_bd_intf_pins moments_dma/M_AXI_MM2S] [get_bd_intf_pins skin_hp3_smc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins moments_dma/M_AXI_S2MM] [get_bd_intf_pins skin_hp3_smc/S01_AXI]
connect_bd_intf_net [get_bd_intf_pins skin_hp3_smc/M00_AXI] [get_bd_intf_pins ps7_0/S_AXI_HP3]
connect_bd_intf_net [get_bd_intf_pins moments_dma/M_AXIS_MM2S] [get_bd_intf_pins skin_kernel/s_axis]
connect_bd_intf_net [get_bd_intf_pins skin_kernel/m_axis] [get_bd_intf_pins moments_dma/S_AXIS_S2MM]
connect_bd_intf_net [get_bd_intf_pins video_in/video_out] [get_bd_intf_pins demosaic/s_axis_video]
connect_bd_intf_net [get_bd_intf_pins demosaic/m_axis_video] [get_bd_intf_pins frame_dma/S_AXIS_S2MM]

foreach name {vid_xclk} { create_bd_port -dir O $name }
foreach name {vid_pclk vid_vsync vid_hsync} { create_bd_port -dir I $name }
create_bd_port -dir I -from 7 -to 0 vid_data
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 vid_iic
connect_bd_net [get_bd_pins ps7_0/FCLK_CLK1] [get_bd_ports vid_xclk]
foreach source {vid_pclk vid_vsync vid_hsync vid_data} target {vid_io_in_clk vid_vsync vid_active_video vid_data} {
    connect_bd_net [get_bd_ports $source] [get_bd_pins video_in/$target]
}
connect_bd_intf_net [get_bd_intf_pins camera_iic/IIC] [get_bd_intf_ports vid_iic]
}

foreach pin {ps7_0/S_AXI_HP1_ACLK ps7_0/S_AXI_HP3_ACLK vision_control_smc/aclk camera_hp1_smc/aclk skin_hp3_smc/aclk camera_iic/s_axi_aclk video_in/aclk demosaic/ap_clk frame_dma/s_axis_s2mm_aclk frame_dma/m_axi_s2mm_aclk frame_dma/s_axi_lite_aclk moments_dma/s_axi_lite_aclk moments_dma/m_axi_mm2s_aclk moments_dma/m_axi_s2mm_aclk moments_reset/s_axi_aclk skin_kernel/aclk} {
    vision_net ps7_0/FCLK_CLK0 $pin
}
foreach pin {vision_control_smc/aresetn camera_hp1_smc/aresetn skin_hp3_smc/aresetn} {
    vision_net rst_fclk0/interconnect_aresetn $pin
}
foreach pin {camera_iic/s_axi_aresetn demosaic/ap_rst_n frame_dma/axi_resetn moments_dma/axi_resetn moments_reset/s_axi_aresetn video_in/aresetn} {
    vision_net rst_fclk0/peripheral_aresetn $pin
}
vision_net rst_fclk0/peripheral_aresetn skin_reset_and/Op1
vision_net moments_reset/gpio_io_o skin_reset_and/Op2
vision_net skin_reset_and/Res skin_kernel/aresetn
set vision_irq_index [get_property CONFIG.NUM_PORTS [get_bd_cells irq_concat]]
set_property CONFIG.NUM_PORTS [expr {$vision_irq_index + 3}] [get_bd_cells irq_concat]
foreach pin {frame_dma/s2mm_introut moments_dma/mm2s_introut moments_dma/s2mm_introut} {
    connect_bd_net [get_bd_pins $pin] [get_bd_pins irq_concat/In$vision_irq_index]
    incr vision_irq_index
}

foreach offset {0x41600000 0x43C00000 0x43000000 0x40420000 0x413D0000} segment {camera_iic/S_AXI/Reg demosaic/s_axi_CTRL/Reg frame_dma/S_AXI_LITE/Reg moments_dma/S_AXI_LITE/Reg moments_reset/S_AXI/Reg} {
    assign_bd_address -offset $offset -range 0x00010000 -target_address_space [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs $segment] -force
}
puts "VISION_BD_CONFIG=CAPTURE_ONLY HP1=CAMERA HP3=SKN6 GPU_HP0_HP2_UNCHANGED"
if {[info exists vision_wiring_resume]} { unset vision_wiring_resume }