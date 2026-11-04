set script_dir [file dirname [file normalize [info script]]]
set board_dir [file normalize [file join $script_dir ..]]
set repo_dir [file normalize [file join $board_dir .. ..]]
if {![info exists project_name]} { set project_name c4_framebuffer }
if {![info exists design_name]} { set design_name c4m3 }
if {![info exists report_stage]} { set report_stage c4m3 }
if {![info exists core_reference]} { set core_reference scene2d_c4m3_core }
if {![info exists build_id]} { set build_id 0xC0040300 }
if {![info exists atlas_init_file]} { set atlas_init_file none }
if {![info exists extra_rtl_files]} { set extra_rtl_files [list] }
if {![info exists enable_runtime_palette_status]} { set enable_runtime_palette_status 0 }
if {![info exists enable_runtime_asset_status]} { set enable_runtime_asset_status 0 }
if {![info exists enable_runtime_tilemap_status]} { set enable_runtime_tilemap_status 0 }
if {![info exists enable_board_inputs]} { set enable_board_inputs 0 }
if {![info exists enable_return_path]} { set enable_return_path 0 }
if {![info exists tile_descriptor_cache_enable]} { set tile_descriptor_cache_enable 0 }
set cache_enabled $tile_descriptor_cache_enable
unset tile_descriptor_cache_enable
if {![info exists blit_pixel_pipeline_enable]} { set blit_pixel_pipeline_enable 0 }
set blit_pipeline_enabled $blit_pixel_pipeline_enable
unset blit_pixel_pipeline_enable
if {![info exists tile_pixel_pipeline_enable]} { set tile_pixel_pipeline_enable 0 }
set tile_pipeline_enabled $tile_pixel_pipeline_enable
unset tile_pixel_pipeline_enable
if {![info exists tile_pixel_pair_enable]} { set tile_pixel_pair_enable 0 }
set tile_pair_enabled $tile_pixel_pair_enable
unset tile_pixel_pair_enable
if {![info exists blit_pixel_pair_enable]} { set blit_pixel_pair_enable 0 }
set blit_pair_enabled $blit_pixel_pair_enable
unset blit_pixel_pair_enable
if {![info exists clear_fill_pixel_pair_enable]} { set clear_fill_pixel_pair_enable 0 }
set clear_fill_pair_enabled $clear_fill_pixel_pair_enable
unset clear_fill_pixel_pair_enable
if {![info exists upload_render_overlap_enable]} { set upload_render_overlap_enable 0 }
set overlap_enabled $upload_render_overlap_enable
unset upload_render_overlap_enable
if {![info exists gpu_resource_limits]} { set gpu_resource_limits [dict create] }
set resource_limits $gpu_resource_limits
unset gpu_resource_limits
if {![info exists post_route_phys_opt_directive]} { set post_route_phys_opt_directive none }
set project_dir [file join $board_dir build $project_name]
if {[info exists experimental_project_dir]} {
    set project_dir $experimental_project_dir
    unset experimental_project_dir
}
set output_dir [file join $board_dir output]
if {[info exists experimental_output_dir]} {
    set output_dir $experimental_output_dir
    unset experimental_output_dir
}
set report_dir [file join $output_dir reports $report_stage]
set ps7_config [file join $board_dir generated pynq_z2_ps7_config.tcl]
set rgb2dvi_repo [file join $board_dir generated rgb2dvi_v1_2]
if {[info exists experimental_rgb2dvi_repo]} {
    set rgb2dvi_repo $experimental_rgb2dvi_repo
    unset experimental_rgb2dvi_repo
}
set constraints [file join $board_dir constraints c3_hdmi_out.xdc]
set cdc_constraints [file join $board_dir constraints c4m3_cdc.xdc]
set input_constraints [file join $board_dir constraints c2_buttons_switches.xdc]
set rtl_dir [file join $repo_dir rtl scene2d_gpu]
set rtl_files [concat [list \
    [file join $rtl_dir scene2d_upload_sink.sv] \
    [file join $rtl_dir scene2d_command_upload.sv] \
    [file join $rtl_dir scene2d_index4_blit.sv] \
    [file join $rtl_dir scene2d_index4_atlas.sv] \
    [file join $rtl_dir scene2d_clear_fill_renderer.sv] \
    [file join $rtl_dir scene2d_video_timing.sv] \
    [file join $rtl_dir scene2d_framebuffer.sv] \
    [file join $rtl_dir scene2d_frame_swap.sv] \
    [file join $rtl_dir scene2d_palette_scanout.sv] \
    [file join $rtl_dir scene2d_c4m3_core.sv] \
    [file join $rtl_dir scene2d_c4m4_core.sv]] $extra_rtl_files]

set required_files [concat [list $ps7_config $rgb2dvi_repo $constraints $cdc_constraints] $rtl_files]
if {$enable_board_inputs} {
    lappend required_files $input_constraints
}
foreach required $required_files {
    if {![file exists $required]} {
        error "Missing $report_stage dependency: $required"
    }
}

file delete -force $project_dir
file mkdir $project_dir
file mkdir $output_dir
file mkdir $report_dir
foreach stale_output [list \
    [file join $output_dir ${project_name}.bit] \
    [file join $output_dir ${project_name}.hwh] \
    [file join $output_dir ${project_name}.xsa] \
    [file join $output_dir ${project_name}_manifest.txt]] {
    file delete -force $stale_output
}

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
add_files -norecurse $rtl_files
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
    CONFIG.PCW_USE_S_AXI_HP2 $enable_return_path \
    CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
    CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
    CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
    CONFIG.PCW_IRQ_F2P_INTR {1} \
] $ps7_0

set ddr [create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR]
set fixed_io [create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO]
connect_bd_intf_net [get_bd_intf_pins ps7_0/DDR] $ddr
connect_bd_intf_net [get_bd_intf_pins ps7_0/FIXED_IO] $fixed_io

set gp0_smc [create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 gp0_smc]
set gp0_master_count [expr {14 + ($enable_runtime_palette_status ? 4 : 0) + ($enable_runtime_asset_status ? 3 : 0) + ($enable_runtime_tilemap_status ? 3 : 0) + ($enable_board_inputs ? 1 : 0) + ($enable_return_path ? 5 : 0) + ($overlap_enabled ? 1 : 0)}]
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI $gp0_master_count] $gp0_smc
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
if {$enable_return_path} {
    set hp2_smc [create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 hp2_smc]
    set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {1}] $hp2_smc
    set return_dma [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 return_dma]
    set_property -dict [list \
        CONFIG.c_include_sg {0} \
        CONFIG.c_include_mm2s {0} \
        CONFIG.c_include_s2mm {1} \
        CONFIG.c_m_axi_s2mm_data_width {64} \
        CONFIG.c_s_axis_s2mm_tdata_width {64} \
        CONFIG.c_s2mm_burst_size {16} \
        CONFIG.c_sg_length_width {26} \
    ] $return_dma
}

proc create_input_gpio {name dual width2} {
    set cell [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 $name]
    set properties [list CONFIG.C_ALL_INPUTS {1} CONFIG.C_GPIO_WIDTH {32} CONFIG.C_IS_DUAL $dual]
    if {$dual} {
        lappend properties CONFIG.C_ALL_INPUTS_2 {1} CONFIG.C_GPIO2_WIDTH $width2
    }
    set_property -dict $properties $cell
    return $cell
}

set build_id_gpio [create_input_gpio build_id_gpio 0 0]
set build_id_constant [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 build_id_constant]
set_property -dict [list CONFIG.CONST_VAL $build_id CONFIG.CONST_WIDTH {32}] $build_id_constant
set upload_status_gpio [create_input_gpio upload_status_gpio 1 32]
set packet_status_gpio [create_input_gpio packet_status_gpio 1 32]
set command_status_gpio [create_input_gpio command_status_gpio 1 32]
set error_status_gpio [create_input_gpio error_status_gpio 1 6]
set command_read_address_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 command_read_address_gpio]
set_property -dict [list CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_GPIO_WIDTH {9} CONFIG.C_IS_DUAL {0}] $command_read_address_gpio
set command_read_data_gpio [create_input_gpio command_read_data_gpio 1 32]
set render_completion_gpio [create_input_gpio render_completion_gpio 1 32]
set render_trace_gpio [create_input_gpio render_trace_gpio 1 32]
set render_cycles_gpio [create_input_gpio render_cycles_gpio 1 32]
set render_status_gpio [create_input_gpio render_status_gpio 0 0]
set present_completion_gpio [create_input_gpio present_completion_gpio 1 32]
set framebuffer_status_gpio [create_input_gpio framebuffer_status_gpio 0 0]
set palette_status_gpios [list]
if {$enable_runtime_palette_status} {
    set router_status_gpio [create_input_gpio router_status_gpio 1 32]
    set palette_packet_status_gpio [create_input_gpio palette_packet_status_gpio 1 32]
    set palette_generation_status_gpio [create_input_gpio palette_generation_status_gpio 1 9]
    set palette_state_status_gpio [create_input_gpio palette_state_status_gpio 0 0]
    set palette_status_gpios [list \
        $router_status_gpio $palette_packet_status_gpio \
        $palette_generation_status_gpio $palette_state_status_gpio]
}
set asset_status_gpios [list]
if {$enable_runtime_asset_status} {
    set asset_packet_status_gpio [create_input_gpio asset_packet_status_gpio 1 32]
    set asset_generation_status_gpio [create_input_gpio asset_generation_status_gpio 1 9]
    set asset_state_status_gpio [create_input_gpio asset_state_status_gpio 0 0]
    set asset_status_gpios [list \
        $asset_packet_status_gpio $asset_generation_status_gpio $asset_state_status_gpio]
}
set tilemap_status_gpios [list]
if {$enable_runtime_tilemap_status} {
    set tilemap_packet_status_gpio [create_input_gpio tilemap_packet_status_gpio 1 32]
    set tilemap_generation_status_gpio [create_input_gpio tilemap_generation_status_gpio 1 9]
    set tilemap_state_status_gpio [create_input_gpio tilemap_state_status_gpio 0 0]
    set tilemap_status_gpios [list \
        $tilemap_packet_status_gpio $tilemap_generation_status_gpio $tilemap_state_status_gpio]
}
set runtime_status_gpios [concat $palette_status_gpios $asset_status_gpios $tilemap_status_gpios]
set board_input_gpios [list]
if {$enable_board_inputs} {
    set input_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 input_gpio]
    set_property -dict [list CONFIG.C_ALL_INPUTS {1} CONFIG.C_GPIO_WIDTH {6} CONFIG.C_IS_DUAL {0}] $input_gpio
    set input_concat [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 input_concat]
    set_property -dict [list CONFIG.NUM_PORTS {2} CONFIG.IN0_WIDTH {4} CONFIG.IN1_WIDTH {2}] $input_concat
    set btn [create_bd_port -dir I -from 3 -to 0 btn]
    set sw [create_bd_port -dir I -from 1 -to 0 sw]
    connect_bd_net $btn [get_bd_pins input_concat/In0]
    connect_bd_net $sw [get_bd_pins input_concat/In1]
    connect_bd_net [get_bd_pins input_concat/dout] [get_bd_pins input_gpio/gpio_io_i]
    set board_input_gpios [list $input_gpio]
}
set return_gpios [list]
if {$enable_return_path} {
    set return_control_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 return_control_gpio]
    set_property -dict [list \
        CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_GPIO_WIDTH {32} \
        CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_OUTPUTS_2 {1} CONFIG.C_GPIO2_WIDTH {32} \
    ] $return_control_gpio
    set return_start_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 return_start_gpio]
    set_property -dict [list CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_GPIO_WIDTH {1} CONFIG.C_IS_DUAL {0}] $return_start_gpio
    set return_status_gpio [create_input_gpio return_status_gpio 1 32]
    set return_state_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 return_state_gpio]
    set_property -dict [list \
        CONFIG.C_ALL_INPUTS {1} CONFIG.C_GPIO_WIDTH {1} \
        CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_INPUTS_2 {1} CONFIG.C_GPIO2_WIDTH {32} \
    ] $return_state_gpio
    set return_gpios [list \
        $return_control_gpio $return_start_gpio $return_status_gpio $return_state_gpio]
}

if {$overlap_enabled} {
    set overlap_control_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 overlap_control_gpio]
    set_property -dict [list \
        CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_GPIO_WIDTH {1} CONFIG.C_DOUT_DEFAULT {0x00000000} \
        CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_INPUTS_2 {1} CONFIG.C_GPIO2_WIDTH {32} \
    ] $overlap_control_gpio
}

set core [create_bd_cell -type module -reference $core_reference core]
if {$overlap_enabled} {
    set_property CONFIG.UPLOAD_RENDER_OVERLAP_ENABLE 0x1 $core
    set configured_overlap [get_property CONFIG.UPLOAD_RENDER_OVERLAP_ENABLE $core]
    if {$configured_overlap != 1} {
        error "Upload/render overlap configuration did not take effect: $configured_overlap"
    }
    connect_bd_net [get_bd_pins overlap_control_gpio/gpio_io_o] [get_bd_pins core/overlap_release_toggle]
    connect_bd_net [get_bd_pins core/overlap_status] [get_bd_pins overlap_control_gpio/gpio2_io_i]
} elseif {[llength [get_bd_pins -quiet core/overlap_release_toggle]] != 0} {
    set overlap_release_constant [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 overlap_release_constant]
    set_property -dict [list CONFIG.CONST_VAL {0} CONFIG.CONST_WIDTH {1}] $overlap_release_constant
    connect_bd_net [get_bd_pins overlap_release_constant/dout] [get_bd_pins core/overlap_release_toggle]
}
if {$cache_enabled} {
    set_property CONFIG.TILE_DESCRIPTOR_CACHE_ENABLE 0x1 $core
    set configured_cache [get_property CONFIG.TILE_DESCRIPTOR_CACHE_ENABLE $core]
    if {$configured_cache != 1} {
        error "Tile descriptor cache configuration did not take effect: $configured_cache"
    }
}
if {$blit_pipeline_enabled} {
    set_property CONFIG.BLIT_PIXEL_PIPELINE_ENABLE 0x1 $core
    set configured_pipeline [get_property CONFIG.BLIT_PIXEL_PIPELINE_ENABLE $core]
    if {$configured_pipeline != 1} {
        error "Blit pixel pipeline configuration did not take effect: $configured_pipeline"
    }
}
if {$tile_pipeline_enabled} {
    set_property CONFIG.TILE_PIXEL_PIPELINE_ENABLE 0x1 $core
    set configured_tile_pipeline [get_property CONFIG.TILE_PIXEL_PIPELINE_ENABLE $core]
    if {$configured_tile_pipeline != 1} {
        error "Tile pixel pipeline configuration did not take effect: $configured_tile_pipeline"
    }
}
if {$tile_pair_enabled} {
    set_property CONFIG.TILE_PIXEL_PAIR_ENABLE 0x1 $core
    set configured_tile_pair [get_property CONFIG.TILE_PIXEL_PAIR_ENABLE $core]
    if {$configured_tile_pair != 1} {
        error "Tile pixel pair configuration did not take effect: $configured_tile_pair"
    }
}
if {$atlas_init_file ne "none"} {
    set_property CONFIG.ATLAS_INIT_FILE $atlas_init_file $core
}
if {$blit_pair_enabled} {
    set_property CONFIG.BLIT_PIXEL_PAIR_ENABLE 0x1 $core
    set configured_blit_pair [get_property CONFIG.BLIT_PIXEL_PAIR_ENABLE $core]
    if {$configured_blit_pair != 1} { error "Blit pixel pair configuration did not take effect: $configured_blit_pair" }
}
if {$clear_fill_pair_enabled} {
    set_property CONFIG.CLEAR_FILL_PIXEL_PAIR_ENABLE 0x1 $core
    set configured_clear_fill_pair [get_property CONFIG.CLEAR_FILL_PIXEL_PAIR_ENABLE $core]
    if {$configured_clear_fill_pair != 1} { error "Clear/fill pixel pair configuration did not take effect: $configured_clear_fill_pair" }
}
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
set rgb2dvi [create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi:1.2 rgb2dvi]
set_property -dict [list \
    CONFIG.kGenerateSerialClk {true} \
    CONFIG.kClkPrimitive {MMCM} \
    CONFIG.kClkRange {2} \
    CONFIG.kRstActiveHigh {true} \
] $rgb2dvi
set irq_concat [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 irq_concat]
set_property CONFIG.NUM_PORTS [expr {$enable_return_path ? 2 : 1}] $irq_concat
if {$enable_return_path} {
    set return_source [create_bd_cell -type module -reference scene2d_return_source return_source]
}
set hdmi_out_clk_p [create_bd_port -dir O hdmi_out_clk_p]
set hdmi_out_clk_n [create_bd_port -dir O hdmi_out_clk_n]
set hdmi_out_data_p [create_bd_port -dir O -from 2 -to 0 hdmi_out_data_p]
set hdmi_out_data_n [create_bd_port -dir O -from 2 -to 0 hdmi_out_data_n]

connect_bd_intf_net [get_bd_intf_pins ps7_0/M_AXI_GP0] [get_bd_intf_pins gp0_smc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_dma/M_AXI_MM2S] [get_bd_intf_pins hp0_smc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins hp0_smc/M00_AXI] [get_bd_intf_pins ps7_0/S_AXI_HP0]
connect_bd_intf_net [get_bd_intf_pins gp0_smc/M00_AXI] [get_bd_intf_pins axi_dma/S_AXI_LITE]
foreach index {1 2 3 4 5 6 7 8 9 10 11 12 13} gpio [list \
    $build_id_gpio $upload_status_gpio $packet_status_gpio $command_status_gpio \
    $error_status_gpio $command_read_address_gpio $command_read_data_gpio \
    $render_completion_gpio $render_trace_gpio $render_cycles_gpio $render_status_gpio \
    $present_completion_gpio $framebuffer_status_gpio] {
    connect_bd_intf_net [get_bd_intf_pins gp0_smc/M[format %02d $index]_AXI] [get_bd_intf_pins $gpio/S_AXI]
}
if {$enable_runtime_palette_status} {
    foreach index {14 15 16 17} gpio $palette_status_gpios {
        connect_bd_intf_net [get_bd_intf_pins gp0_smc/M[format %02d $index]_AXI] [get_bd_intf_pins $gpio/S_AXI]
    }
}
if {$enable_runtime_asset_status} {
    foreach index {18 19 20} gpio $asset_status_gpios {
        connect_bd_intf_net [get_bd_intf_pins gp0_smc/M[format %02d $index]_AXI] [get_bd_intf_pins $gpio/S_AXI]
    }
}
if {$enable_runtime_tilemap_status} {
    foreach index {21 22 23} gpio $tilemap_status_gpios {
        connect_bd_intf_net [get_bd_intf_pins gp0_smc/M[format %02d $index]_AXI] [get_bd_intf_pins $gpio/S_AXI]
    }
}
if {$enable_board_inputs} {
    set input_master_index [expr {$gp0_master_count - 1 - ($enable_return_path ? 5 : 0) - ($overlap_enabled ? 1 : 0)}]
    connect_bd_intf_net \
        [get_bd_intf_pins gp0_smc/M[format %02d $input_master_index]_AXI] \
        [get_bd_intf_pins input_gpio/S_AXI]
}
if {$enable_return_path} {
    set return_master_base [expr {$gp0_master_count - 5 - ($overlap_enabled ? 1 : 0)}]
    foreach delta {0 1 2 3 4} interface [list \
        return_dma/S_AXI_LITE return_control_gpio/S_AXI return_start_gpio/S_AXI \
        return_status_gpio/S_AXI return_state_gpio/S_AXI] {
        set master_index [expr {$return_master_base + $delta}]
        connect_bd_intf_net \
            [get_bd_intf_pins gp0_smc/M[format %02d $master_index]_AXI] \
            [get_bd_intf_pins $interface]
    }
    connect_bd_intf_net [get_bd_intf_pins return_dma/M_AXI_S2MM] [get_bd_intf_pins hp2_smc/S00_AXI]
    connect_bd_intf_net [get_bd_intf_pins hp2_smc/M00_AXI] [get_bd_intf_pins ps7_0/S_AXI_HP2]
    connect_bd_intf_net [get_bd_intf_pins return_source/M_AXIS] [get_bd_intf_pins return_dma/S_AXIS_S2MM]
}

if {$overlap_enabled} {
    set overlap_master_index [expr {$gp0_master_count - 1}]
    connect_bd_intf_net [get_bd_intf_pins gp0_smc/M[format %02d $overlap_master_index]_AXI] \
        [get_bd_intf_pins overlap_control_gpio/S_AXI]
    connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] [get_bd_pins overlap_control_gpio/s_axi_aclk]
    connect_bd_net [get_bd_pins rst_fclk0/peripheral_aresetn] [get_bd_pins overlap_control_gpio/s_axi_aresetn]
}

connect_bd_net [get_bd_pins axi_dma/m_axis_mm2s_tdata] [get_bd_pins core/s_axis_tdata]
connect_bd_net [get_bd_pins axi_dma/m_axis_mm2s_tkeep] [get_bd_pins core/s_axis_tkeep]
connect_bd_net [get_bd_pins axi_dma/m_axis_mm2s_tlast] [get_bd_pins core/s_axis_tlast]
connect_bd_net [get_bd_pins axi_dma/m_axis_mm2s_tvalid] [get_bd_pins core/s_axis_tvalid]
connect_bd_net [get_bd_pins core/s_axis_tready] [get_bd_pins axi_dma/m_axis_mm2s_tready]
connect_bd_net [get_bd_pins command_read_address_gpio/gpio_io_o] [get_bd_pins core/debug_command_read_address]
connect_bd_net [get_bd_pins core/debug_command_read_data_low] [get_bd_pins command_read_data_gpio/gpio_io_i]
connect_bd_net [get_bd_pins core/debug_command_read_data_high] [get_bd_pins command_read_data_gpio/gpio2_io_i]
connect_bd_net [get_bd_pins core/upload_crc32] [get_bd_pins upload_status_gpio/gpio_io_i]
connect_bd_net [get_bd_pins core/upload_byte_count] [get_bd_pins upload_status_gpio/gpio2_io_i]
connect_bd_net [get_bd_pins core/upload_packet_count] [get_bd_pins packet_status_gpio/gpio_io_i]
connect_bd_net [get_bd_pins core/accepted_packet_count] [get_bd_pins packet_status_gpio/gpio2_io_i]
connect_bd_net [get_bd_pins core/accepted_seq] [get_bd_pins command_status_gpio/gpio_io_i]
connect_bd_net [get_bd_pins core/accepted_status] [get_bd_pins command_status_gpio/gpio2_io_i]
connect_bd_net [get_bd_pins core/rejected_packet_count] [get_bd_pins error_status_gpio/gpio_io_i]
connect_bd_net [get_bd_pins core/upload_error_flags] [get_bd_pins error_status_gpio/gpio2_io_i]
connect_bd_net [get_bd_pins core/render_completed_seq] [get_bd_pins render_completion_gpio/gpio_io_i]
connect_bd_net [get_bd_pins core/render_completed_count] [get_bd_pins render_completion_gpio/gpio2_io_i]
connect_bd_net [get_bd_pins core/render_trace_crc32] [get_bd_pins render_trace_gpio/gpio_io_i]
connect_bd_net [get_bd_pins core/render_write_count] [get_bd_pins render_trace_gpio/gpio2_io_i]
connect_bd_net [get_bd_pins core/render_cycles] [get_bd_pins render_cycles_gpio/gpio_io_i]
connect_bd_net [get_bd_pins core/render_maximum_cycles] [get_bd_pins render_cycles_gpio/gpio2_io_i]
connect_bd_net [get_bd_pins core/render_status] [get_bd_pins render_status_gpio/gpio_io_i]
connect_bd_net [get_bd_pins core/present_completed_seq] [get_bd_pins present_completion_gpio/gpio_io_i]
connect_bd_net [get_bd_pins core/present_completed_count] [get_bd_pins present_completion_gpio/gpio2_io_i]
connect_bd_net [get_bd_pins core/framebuffer_status] [get_bd_pins framebuffer_status_gpio/gpio_io_i]
if {$enable_runtime_palette_status} {
    connect_bd_net [get_bd_pins core/router_dropped_packet_count] [get_bd_pins router_status_gpio/gpio_io_i]
    connect_bd_net [get_bd_pins core/unsupported_packet_count] [get_bd_pins router_status_gpio/gpio2_io_i]
    connect_bd_net [get_bd_pins core/palette_accepted_packet_count] [get_bd_pins palette_packet_status_gpio/gpio_io_i]
    connect_bd_net [get_bd_pins core/palette_rejected_packet_count] [get_bd_pins palette_packet_status_gpio/gpio2_io_i]
    connect_bd_net [get_bd_pins core/palette_generation] [get_bd_pins palette_generation_status_gpio/gpio_io_i]
    connect_bd_net [get_bd_pins core/palette_error_flags] [get_bd_pins palette_generation_status_gpio/gpio2_io_i]
    connect_bd_net [get_bd_pins core/palette_status] [get_bd_pins palette_state_status_gpio/gpio_io_i]
}
if {$enable_runtime_asset_status} {
    connect_bd_net [get_bd_pins core/asset_accepted_packet_count] [get_bd_pins asset_packet_status_gpio/gpio_io_i]
    connect_bd_net [get_bd_pins core/asset_rejected_packet_count] [get_bd_pins asset_packet_status_gpio/gpio2_io_i]
    connect_bd_net [get_bd_pins core/asset_generation] [get_bd_pins asset_generation_status_gpio/gpio_io_i]
    connect_bd_net [get_bd_pins core/asset_error_flags] [get_bd_pins asset_generation_status_gpio/gpio2_io_i]
    connect_bd_net [get_bd_pins core/asset_status] [get_bd_pins asset_state_status_gpio/gpio_io_i]
}
if {$enable_runtime_tilemap_status} {
    connect_bd_net [get_bd_pins core/tilemap_accepted_packet_count] [get_bd_pins tilemap_packet_status_gpio/gpio_io_i]
    connect_bd_net [get_bd_pins core/tilemap_rejected_packet_count] [get_bd_pins tilemap_packet_status_gpio/gpio2_io_i]
    connect_bd_net [get_bd_pins core/tilemap_generation] [get_bd_pins tilemap_generation_status_gpio/gpio_io_i]
    connect_bd_net [get_bd_pins core/tilemap_error_flags] [get_bd_pins tilemap_generation_status_gpio/gpio2_io_i]
    connect_bd_net [get_bd_pins core/tilemap_status] [get_bd_pins tilemap_state_status_gpio/gpio_io_i]
}
if {$enable_return_path} {
    connect_bd_net [get_bd_pins return_control_gpio/gpio_io_o] [get_bd_pins return_source/requested_byte_count]
    connect_bd_net [get_bd_pins return_control_gpio/gpio2_io_o] [get_bd_pins return_source/seed]
    connect_bd_net [get_bd_pins return_start_gpio/gpio_io_o] [get_bd_pins return_source/start]
    connect_bd_net [get_bd_pins return_source/completed_byte_count] [get_bd_pins return_status_gpio/gpio_io_i]
    connect_bd_net [get_bd_pins return_source/completed_packet_count] [get_bd_pins return_status_gpio/gpio2_io_i]
    connect_bd_net [get_bd_pins return_source/busy] [get_bd_pins return_state_gpio/gpio_io_i]
    connect_bd_net [get_bd_pins return_source/rejected_start_count] [get_bd_pins return_state_gpio/gpio2_io_i]
}
connect_bd_net [get_bd_pins build_id_constant/dout] [get_bd_pins build_id_gpio/gpio_io_i]
connect_bd_net [get_bd_pins core/vid_data] [get_bd_pins rgb2dvi/vid_pData]
connect_bd_net [get_bd_pins core/vid_de] [get_bd_pins rgb2dvi/vid_pVDE]
connect_bd_net [get_bd_pins core/vid_hsync] [get_bd_pins rgb2dvi/vid_pHSync]
connect_bd_net [get_bd_pins core/vid_vsync] [get_bd_pins rgb2dvi/vid_pVSync]
connect_bd_net [get_bd_pins rgb2dvi/TMDS_Clk_p] $hdmi_out_clk_p
connect_bd_net [get_bd_pins rgb2dvi/TMDS_Clk_n] $hdmi_out_clk_n
connect_bd_net [get_bd_pins rgb2dvi/TMDS_Data_p] $hdmi_out_data_p
connect_bd_net [get_bd_pins rgb2dvi/TMDS_Data_n] $hdmi_out_data_n
connect_bd_net [get_bd_pins axi_dma/mm2s_introut] [get_bd_pins irq_concat/In0]
if {$enable_return_path} {
    connect_bd_net [get_bd_pins return_dma/s2mm_introut] [get_bd_pins irq_concat/In1]
}
connect_bd_net [get_bd_pins irq_concat/dout] [get_bd_pins ps7_0/IRQ_F2P]

connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] \
    [get_bd_pins ps7_0/M_AXI_GP0_ACLK] \
    [get_bd_pins ps7_0/S_AXI_HP0_ACLK] \
    [get_bd_pins gp0_smc/aclk] \
    [get_bd_pins hp0_smc/aclk] \
    [get_bd_pins axi_dma/s_axi_lite_aclk] \
    [get_bd_pins axi_dma/m_axi_mm2s_aclk] \
    [get_bd_pins axi_dma/m_axis_mm2s_aclk] \
    [get_bd_pins core/aclk] \
    [get_bd_pins rst_fclk0/slowest_sync_clk] \
    [get_bd_pins pixel_clock/clk_in1]
foreach gpio [list \
    $build_id_gpio $upload_status_gpio $packet_status_gpio $command_status_gpio \
    $error_status_gpio $command_read_address_gpio $command_read_data_gpio \
    $render_completion_gpio $render_trace_gpio $render_cycles_gpio $render_status_gpio \
    $present_completion_gpio $framebuffer_status_gpio] {
    connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] [get_bd_pins $gpio/s_axi_aclk]
}
foreach gpio $runtime_status_gpios {
    connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] [get_bd_pins $gpio/s_axi_aclk]
}
foreach gpio $board_input_gpios {
    connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] [get_bd_pins $gpio/s_axi_aclk]
}
if {$enable_return_path} {
    connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] \
        [get_bd_pins ps7_0/S_AXI_HP2_ACLK] \
        [get_bd_pins hp2_smc/aclk] \
        [get_bd_pins return_dma/s_axi_lite_aclk] \
        [get_bd_pins return_dma/m_axi_s2mm_aclk] \
        [get_bd_pins return_dma/s_axis_s2mm_aclk] \
        [get_bd_pins return_source/aclk]
    foreach gpio $return_gpios {
        connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] [get_bd_pins $gpio/s_axi_aclk]
    }
}
connect_bd_net [get_bd_pins ps7_0/FCLK_RESET0_N] [get_bd_pins rst_fclk0/ext_reset_in] [get_bd_pins rst_pixel/ext_reset_in]
connect_bd_net [get_bd_pins rst_fclk0/interconnect_aresetn] [get_bd_pins gp0_smc/aresetn] [get_bd_pins hp0_smc/aresetn]
if {$enable_return_path} {
    connect_bd_net [get_bd_pins rst_fclk0/interconnect_aresetn] [get_bd_pins hp2_smc/aresetn]
}
connect_bd_net [get_bd_pins rst_fclk0/peripheral_aresetn] [get_bd_pins axi_dma/axi_resetn] [get_bd_pins core/aresetn]
foreach gpio [list \
    $build_id_gpio $upload_status_gpio $packet_status_gpio $command_status_gpio \
    $error_status_gpio $command_read_address_gpio $command_read_data_gpio \
    $render_completion_gpio $render_trace_gpio $render_cycles_gpio $render_status_gpio \
    $present_completion_gpio $framebuffer_status_gpio] {
    connect_bd_net [get_bd_pins rst_fclk0/peripheral_aresetn] [get_bd_pins $gpio/s_axi_aresetn]
}
foreach gpio $runtime_status_gpios {
    connect_bd_net [get_bd_pins rst_fclk0/peripheral_aresetn] [get_bd_pins $gpio/s_axi_aresetn]
}
foreach gpio $board_input_gpios {
    connect_bd_net [get_bd_pins rst_fclk0/peripheral_aresetn] [get_bd_pins $gpio/s_axi_aresetn]
}
if {$enable_return_path} {
    connect_bd_net [get_bd_pins rst_fclk0/peripheral_aresetn] \
        [get_bd_pins return_dma/axi_resetn] [get_bd_pins return_source/aresetn]
    foreach gpio $return_gpios {
        connect_bd_net [get_bd_pins rst_fclk0/peripheral_aresetn] [get_bd_pins $gpio/s_axi_aresetn]
    }
}
connect_bd_net [get_bd_pins rst_fclk0/peripheral_reset] [get_bd_pins pixel_clock/reset]
connect_bd_net [get_bd_pins pixel_clock/clk_out1] [get_bd_pins rst_pixel/slowest_sync_clk] [get_bd_pins core/clk_pixel] [get_bd_pins rgb2dvi/PixelClk]
connect_bd_net [get_bd_pins pixel_clock/locked] [get_bd_pins rst_pixel/dcm_locked]
connect_bd_net [get_bd_pins rst_pixel/peripheral_aresetn] [get_bd_pins core/resetn_pixel]
connect_bd_net [get_bd_pins rst_pixel/peripheral_reset] [get_bd_pins rgb2dvi/aRst]

if {[info exists extra_bd_script]} {
    source $extra_bd_script
    unset extra_bd_script
}

assign_bd_address
foreach offset {0x40400000 0x41200000 0x41210000 0x41220000 0x41230000 0x41240000 0x41250000 0x41260000 0x41270000 0x41280000 0x41290000 0x412A0000 0x412B0000 0x412C0000} segment [list \
    axi_dma/S_AXI_LITE/Reg build_id_gpio/S_AXI/Reg upload_status_gpio/S_AXI/Reg \
    packet_status_gpio/S_AXI/Reg command_status_gpio/S_AXI/Reg error_status_gpio/S_AXI/Reg \
    command_read_address_gpio/S_AXI/Reg command_read_data_gpio/S_AXI/Reg \
    render_completion_gpio/S_AXI/Reg render_trace_gpio/S_AXI/Reg \
    render_cycles_gpio/S_AXI/Reg render_status_gpio/S_AXI/Reg \
    present_completion_gpio/S_AXI/Reg framebuffer_status_gpio/S_AXI/Reg] {
    assign_bd_address -offset $offset -range 0x00010000 -target_address_space \
        [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs $segment] -force
}
if {$enable_runtime_palette_status} {
    foreach offset {0x412D0000 0x412E0000 0x412F0000 0x41300000} gpio $palette_status_gpios {
        assign_bd_address -offset $offset -range 0x00010000 -target_address_space \
            [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs $gpio/S_AXI/Reg] -force
    }
}
if {$enable_runtime_asset_status} {
    foreach offset {0x41310000 0x41320000 0x41330000} gpio $asset_status_gpios {
        assign_bd_address -offset $offset -range 0x00010000 -target_address_space \
            [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs $gpio/S_AXI/Reg] -force
    }
}
if {$enable_runtime_tilemap_status} {
    foreach offset {0x41340000 0x41350000 0x41360000} gpio $tilemap_status_gpios {
        assign_bd_address -offset $offset -range 0x00010000 -target_address_space \
            [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs $gpio/S_AXI/Reg] -force
    }
}
if {$enable_board_inputs} {
    assign_bd_address -offset 0x41370000 -range 0x00010000 -target_address_space \
        [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs input_gpio/S_AXI/Reg] -force
}
if {$enable_return_path} {
    foreach offset {0x40410000 0x41380000 0x41390000 0x413A0000 0x413B0000} segment [list \
        return_dma/S_AXI_LITE/Reg return_control_gpio/S_AXI/Reg return_start_gpio/S_AXI/Reg \
        return_status_gpio/S_AXI/Reg return_state_gpio/S_AXI/Reg] {
        assign_bd_address -offset $offset -range 0x00010000 -target_address_space \
            [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs $segment] -force
    }
}

if {$overlap_enabled} {
    assign_bd_address -offset 0x413C0000 -range 0x00010000 -target_address_space \
        [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs overlap_control_gpio/S_AXI/Reg] -force
}

set_property PFM_NAME "xilinx.com:pynq:${project_name}:1.0" [get_files ${design_name}.bd]
set_property PFM.CLOCK {FCLK_CLK0 {id "0" is_default "true" proc_sys_reset "rst_fclk0" status "fixed"}} $ps7_0
validate_bd_design
save_bd_design
set bd_file [get_files ${design_name}.bd]
generate_target all $bd_file
export_ip_user_files -of_objects $bd_file -no_script -sync -force -quiet
make_wrapper -files $bd_file -top
set wrapper [file join $project_dir ${project_name}.gen sources_1 bd $design_name hdl ${design_name}_wrapper.v]
add_files -norecurse $wrapper
add_files -fileset constrs_1 -norecurse $constraints
add_files -fileset constrs_1 -norecurse $cdc_constraints
set_property USED_IN_SYNTHESIS false [get_files $cdc_constraints]
if {$enable_board_inputs} {
    add_files -fileset constrs_1 -norecurse $input_constraints
}
set_property top ${design_name}_wrapper [current_fileset]
update_compile_order -fileset sources_1

if {[info exists prepare_only] && $prepare_only} {
    puts "GPU_PREPARE_ONLY=PASS project=$project_dir"
    return
}

launch_runs synth_1 -jobs 1
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {
    error "$report_stage synthesis failed: [get_property STATUS [get_runs synth_1]]"
}
if {[info exists impl_strategy]} {
    set_property STRATEGY $impl_strategy [get_runs impl_1]
}
launch_runs impl_1 -to_step route_design -jobs 1
wait_on_run impl_1

set routed_checkpoint [file join $project_dir ${project_name}.runs impl_1 ${design_name}_wrapper_routed.dcp]
if {![file exists $routed_checkpoint]} {
    error "$report_stage route_design did not generate $routed_checkpoint"
}
open_checkpoint $routed_checkpoint
if {$post_route_phys_opt_directive ne "none"} {
    phys_opt_design -directive $post_route_phys_opt_directive
}
set pixel_clocks [get_clocks -quiet clk_out1_${design_name}_pixel_clock_0]
if {[llength $pixel_clocks] != 1} {
    error "Expected exactly one $report_stage pixel clock, found [llength $pixel_clocks]"
}
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $report_dir timing_summary.rpt]
set setup_paths [get_timing_paths -delay_type max -max_paths 1 -nworst 1]
set hold_paths [get_timing_paths -delay_type min -max_paths 1 -nworst 1]
if {[llength $setup_paths] == 0 || [llength $hold_paths] == 0} {
    error "$report_stage timing gate could not find setup and hold paths"
}
set setup_wns [get_property SLACK $setup_paths]
set hold_whs [get_property SLACK $hold_paths]
report_utilization -file [file join $report_dir utilization.rpt]
report_drc -file [file join $report_dir drc.rpt]
set drc_failures [get_drc_violations -quiet -filter {SEVERITY == "Error" || SEVERITY == "Critical Warning"}]
set methodology_path [file join $report_dir methodology.rpt]
report_methodology -file $methodology_path
set methodology_file [open $methodology_path r]
set methodology_text [read $methodology_file]
close $methodology_file
report_clock_interaction -file [file join $report_dir clock_interaction.rpt]
report_cdc -details -file [file join $report_dir cdc.rpt]

set bit_source [file join $project_dir ${project_name}.runs impl_1 ${design_name}_wrapper.bit]
if {$setup_wns < 0.0 || $hold_whs < 0.0} {
    error "$report_stage timing failed: WNS=$setup_wns ns, WHS=$hold_whs ns"
}
if {[llength $drc_failures] != 0} {
    error "$report_stage DRC contains [llength $drc_failures] Error/Critical Warning violations"
}
if {[string first "Critical Warning" $methodology_text] >= 0} {
    error "$report_stage methodology report contains Critical Warnings: $methodology_path"
}
if {[dict size $resource_limits] != 0} {
    set utilization_file [open [file join $report_dir utilization.rpt] r]
    set utilization_text [read $utilization_file]
    close $utilization_file
    dict for {resource limit} $resource_limits {
        set resource_found 0
        foreach row [split $utilization_text "\n"] {
            set columns [split $row |]
            if {[string trim [lindex $columns 1]] eq $resource} {
                set used [string trim [lindex $columns 2]]
                if {![string is double -strict $used] || $used > $limit} {
                    error "$report_stage resource gate failed: $resource used=$used limit=$limit"
                }
                set resource_found 1
                break
            }
        }
        if {!$resource_found} { error "$report_stage resource gate missing: $resource" }
    }
}
write_bitstream -force $bit_source

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
puts $manifest "PRESENT_COMPLETION_ADDRESS=0x412B0000"
puts $manifest "FRAMEBUFFER_STATUS_ADDRESS=0x412C0000"
puts $manifest "PIXEL_CLOCK_MHZ=74.25"
puts $manifest "VIDEO_MODE=1280x720p60"
puts $manifest "LOGICAL_MODE=320x180_4X"
puts $manifest "FRAMEBUFFER_BANKS=2"
puts $manifest "FRAMEBUFFER_BYTES_PER_BANK=57600"
puts $manifest "ATLAS_INIT_FILE=$atlas_init_file"
if {$cache_enabled} {
    puts $manifest "TILE_DESCRIPTOR_CACHE_ENABLE=1"
}
if {$blit_pipeline_enabled} {
    puts $manifest "BLIT_PIXEL_PIPELINE_ENABLE=1"
}
if {$tile_pipeline_enabled} {
    puts $manifest "TILE_PIXEL_PIPELINE_ENABLE=1"
}
if {$tile_pair_enabled} {
    puts $manifest "TILE_PIXEL_PAIR_ENABLE=1"
}
if {$blit_pair_enabled} { puts $manifest "BLIT_PIXEL_PAIR_ENABLE=1" }
if {$clear_fill_pair_enabled} { puts $manifest "CLEAR_FILL_PIXEL_PAIR_ENABLE=1" }
puts $manifest "UPLOAD_RENDER_OVERLAP_ENABLE=$overlap_enabled"
if {$overlap_enabled} {
    puts $manifest "OVERLAP_CONTROL_IP=overlap_control_gpio"
    puts $manifest "OVERLAP_CONTROL_ADDRESS=0x413C0000"
    puts $manifest "OVERLAP_CONTROL_RANGE=0x00010000"
    puts $manifest "OVERLAP_RELEASE_OFFSET=0x0"
    puts $manifest "OVERLAP_RELEASE_BIT=0"
    puts $manifest "OVERLAP_RELEASE_RESERVED_BITS=31:1=0"
    puts $manifest "OVERLAP_STATUS_OFFSET=0x8"
    puts $manifest "OVERLAP_STATUS_BITS=0:credit,1:READY,2:FILLING,3:hold,4:presented,5:consumed_toggle,6:resource_idle,7:generation_reject,31:8=0"
}
if {$enable_runtime_palette_status} {
    puts $manifest "ROUTER_STATUS_ADDRESS=0x412D0000"
    puts $manifest "PALETTE_PACKET_STATUS_ADDRESS=0x412E0000"
    puts $manifest "PALETTE_GENERATION_STATUS_ADDRESS=0x412F0000"
    puts $manifest "PALETTE_STATE_STATUS_ADDRESS=0x41300000"
}
if {$enable_runtime_asset_status} {
    puts $manifest "ASSET_PACKET_STATUS_ADDRESS=0x41310000"
    puts $manifest "ASSET_GENERATION_STATUS_ADDRESS=0x41320000"
    puts $manifest "ASSET_STATE_STATUS_ADDRESS=0x41330000"
}
if {$enable_runtime_tilemap_status} {
    puts $manifest "TILEMAP_PACKET_STATUS_ADDRESS=0x41340000"
    puts $manifest "TILEMAP_GENERATION_STATUS_ADDRESS=0x41350000"
    puts $manifest "TILEMAP_STATE_STATUS_ADDRESS=0x41360000"
}
if {$enable_board_inputs} {
    puts $manifest "INPUT_GPIO_ADDRESS=0x41370000"
}
if {$enable_return_path} {
    puts $manifest "RETURN_DMA_CONTROL_ADDRESS=0x40410000"
    puts $manifest "RETURN_CONTROL_ADDRESS=0x41380000"
    puts $manifest "RETURN_START_ADDRESS=0x41390000"
    puts $manifest "RETURN_STATUS_ADDRESS=0x413A0000"
    puts $manifest "RETURN_STATE_ADDRESS=0x413B0000"
    puts $manifest "HP2_DATA_WIDTH=64"
    puts $manifest "RETURN_AXIS_DATA_WIDTH=64"
}
puts $manifest "WNS_NS=$setup_wns"
puts $manifest "WHS_NS=$hold_whs"
close $manifest
puts "[string toupper $report_stage]_BUILD_STATUS=PASS"
close_project