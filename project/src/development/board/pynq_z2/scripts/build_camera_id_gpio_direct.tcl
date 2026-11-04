set script_dir [file dirname [file normalize [info script]]]
set board_dir [file normalize [file join $script_dir ..]]
set pin_layout direct
if {[info exists ::env(CAMERA_ID_GPIO_LAYOUT)]} {
    set pin_layout $::env(CAMERA_ID_GPIO_LAYOUT)
}
switch -- $pin_layout {
    direct {
        set build_id 0xC00A00D1
        set expected_pins {camera_xclk Y19 camera_scl W19 camera_sda Y17}
    }
    remap {
        set build_id 0xC00A00D2
        set expected_pins {camera_xclk Y18 camera_scl Y17 camera_sda Y16}
    }
    corrected {
        set build_id 0xC00A00D3
        set expected_pins {camera_xclk U19 camera_scl Y17 camera_sda W19}
    }
    default { error "Unsupported CAMERA_ID_GPIO_LAYOUT: $pin_layout" }
}
set project_name camera_id_gpio_${pin_layout}
set project_dir [file join $board_dir build $project_name]
set output_dir [file join $board_dir output $project_name]
set report_dir [file join $board_dir output reports $project_name]
set ps7_config [file join $board_dir generated pynq_z2_ps7_config.tcl]
set rtl [file join $board_dir rtl ov5640_bringup_io.v]
set constraints [file join $board_dir constraints ${project_name}.xdc]

foreach required_file [list $ps7_config $rtl $constraints] {
    if {![file exists $required_file]} {
        error "Missing required file: $required_file"
    }
}

create_project $project_name $project_dir -part xc7z020clg400-1 -force
set_property target_language Verilog [current_project]
add_files -norecurse $rtl
update_compile_order -fileset sources_1
create_bd_design camera

source $ps7_config
set_property -dict [list \
    CONFIG.PCW_EN_CLK1_PORT {0} \
    CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
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
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {2}] $axi_smc
set build_id_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 build_id_gpio]
set_property -dict [list CONFIG.C_ALL_INPUTS {1} CONFIG.C_GPIO_WIDTH {32} CONFIG.C_IS_DUAL {0}] $build_id_gpio
set build_id_constant [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 build_id_constant]
set_property -dict [list CONFIG.CONST_VAL $build_id CONFIG.CONST_WIDTH {32}] $build_id_constant
set camera_control_gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 camera_control_gpio]
set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_GPIO_WIDTH {3} \
    CONFIG.C_DOUT_DEFAULT {0x00000000} CONFIG.C_IS_DUAL {1} \
    CONFIG.C_ALL_INPUTS_2 {1} CONFIG.C_GPIO2_WIDTH {32} \
] $camera_control_gpio
set camera_io [create_bd_cell -type module -reference ov5640_bringup_io camera_io]
set zero [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 zero]
set_property CONFIG.CONST_VAL {0} $zero
set zero_data [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 zero_data]
set_property -dict [list CONFIG.CONST_VAL {0} CONFIG.CONST_WIDTH {8}] $zero_data

set camera_xclk [create_bd_port -dir O camera_xclk]
set camera_scl [create_bd_port -dir IO camera_scl]
set camera_sda [create_bd_port -dir IO camera_sda]
connect_bd_net [get_bd_pins camera_control_gpio/gpio_io_o] [get_bd_pins camera_io/control]
connect_bd_net [get_bd_pins camera_io/camera_status] [get_bd_pins camera_control_gpio/gpio2_io_i]
connect_bd_net [get_bd_pins camera_io/camera_xclk] $camera_xclk
connect_bd_net [get_bd_pins camera_io/camera_scl] $camera_scl
connect_bd_net [get_bd_pins camera_io/camera_sda] $camera_sda
connect_bd_net [get_bd_pins zero/dout] \
    [get_bd_pins camera_io/camera_pclk] \
    [get_bd_pins camera_io/camera_vsync] \
    [get_bd_pins camera_io/camera_href]
connect_bd_net [get_bd_pins zero_data/dout] [get_bd_pins camera_io/camera_data]

set reset [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset]
connect_bd_intf_net [get_bd_intf_pins ps7_0/M_AXI_GP0] [get_bd_intf_pins axi_smc/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins build_id_gpio/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_smc/M01_AXI] [get_bd_intf_pins camera_control_gpio/S_AXI]
connect_bd_net [get_bd_pins build_id_constant/dout] [get_bd_pins build_id_gpio/gpio_io_i]
connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] \
    [get_bd_pins ps7_0/M_AXI_GP0_ACLK] \
    [get_bd_pins axi_smc/aclk] \
    [get_bd_pins build_id_gpio/s_axi_aclk] \
    [get_bd_pins camera_control_gpio/s_axi_aclk] \
    [get_bd_pins camera_io/clk] \
    [get_bd_pins reset/slowest_sync_clk]
connect_bd_net [get_bd_pins ps7_0/FCLK_RESET0_N] [get_bd_pins reset/ext_reset_in]
connect_bd_net [get_bd_pins reset/interconnect_aresetn] [get_bd_pins axi_smc/aresetn]
connect_bd_net [get_bd_pins reset/peripheral_aresetn] \
    [get_bd_pins build_id_gpio/s_axi_aresetn] \
    [get_bd_pins camera_control_gpio/s_axi_aresetn] \
    [get_bd_pins camera_io/resetn]

assign_bd_address -offset 0x41200000 -range 0x00010000 \
    -target_address_space [get_bd_addr_spaces ps7_0/Data] \
    [get_bd_addr_segs build_id_gpio/S_AXI/Reg] -force
assign_bd_address -offset 0x41210000 -range 0x00010000 \
    -target_address_space [get_bd_addr_spaces ps7_0/Data] \
    [get_bd_addr_segs camera_control_gpio/S_AXI/Reg] -force
validate_bd_design
save_bd_design
puts "CAMERA_ID_GPIO_BD_STATUS=PASS"
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
set_property top camera_wrapper [current_fileset]
update_compile_order -fileset sources_1

launch_runs synth_1 -jobs 1
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {
    error "Camera ID GPIO synthesis failed: [get_property STATUS [get_runs synth_1]]"
}
launch_runs impl_1 -to_step write_bitstream -jobs 1
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {
    error "Camera ID GPIO implementation failed: [get_property STATUS [get_runs impl_1]]"
}

file mkdir $output_dir
file mkdir $report_dir
open_run impl_1
foreach {port_name expected_pin} $expected_pins {
    set port [get_ports $port_name]
    if {[get_property PACKAGE_PIN $port] ne $expected_pin || [get_property IOSTANDARD $port] ne "LVCMOS33"} {
        error "Camera ID GPIO IO contract failed: $port_name"
    }
    puts "CAMERA_ID_GPIO_PIN=$port_name:$expected_pin"
}
foreach port_name {camera_scl camera_sda} {
    if {![get_property PULLUP [get_ports $port_name]]} {
        error "Camera ID GPIO pullup contract failed: $port_name"
    }
}
report_drc -file [file join $report_dir drc.rpt]
if {[llength [get_drc_violations -filter {SEVERITY == Error}]] > 0} {
    error "Camera ID GPIO DRC failed"
}
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $report_dir timing_summary.rpt]
foreach delay_type {max min} {
    set paths [get_timing_paths -delay_type $delay_type -max_paths 1 -nworst 1]
    if {[llength $paths] == 0} {
        error "Camera ID GPIO $delay_type timing path is missing"
    }
    set slack [get_property SLACK [lindex $paths 0]]
    puts "CAMERA_ID_GPIO_SLACK_${delay_type}=$slack"
    if {$slack < 0} {
        error "Camera ID GPIO $delay_type timing failed"
    }
}

set bit_source [file join $project_dir ${project_name}.runs impl_1 camera_wrapper.bit]
set hwh_source [file join $project_dir ${project_name}.gen sources_1 bd camera hw_handoff camera.hwh]
foreach artifact [list $bit_source $hwh_source] {
    if {![file exists $artifact]} {
        error "Missing camera ID GPIO artifact: $artifact"
    }
}
file copy -force $bit_source [file join $output_dir ${project_name}.bit]
file copy -force $hwh_source [file join $output_dir ${project_name}.hwh]
puts "CAMERA_ID_GPIO_BUILD_STATUS=PASS"
puts "CAMERA_ID_GPIO_OUTPUT_DIR=$output_dir"
close_project