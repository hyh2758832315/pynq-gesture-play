set volume_repo [file normalize [file join [file dirname [info script]] .. .. ..]]
set volume_build E:/vvvol/20261019/platform
if {[info exists ::env(VOLUME_BUILD_ROOT)]} {set volume_build [file normalize $::env(VOLUME_BUILD_ROOT)]}
if {[file exists $volume_build]} {error "refusing occupied build root: $volume_build"}
create_project voice_volume $volume_build -part xc7z020clg400-1
add_files -norecurse [glob [file join $volume_repo rtl voice_volume *.sv]]
add_files -fileset constrs_1 -norecurse [file join $volume_repo board pynq_z2 constraints voice_volume.xdc]
create_bd_design volume
if {[info exists ::env(VOLUME_IPCFG_LIBRARY)] && ![llength [info commands ::ipcfg::create_cell_cfg]]} {
    source $::env(VOLUME_IPCFG_LIBRARY)
    set ::ipcfg::native_log_path $::env(VOLUME_NATIVE_LOG)
    puts [ipcfg::python_status]
    puts [ipcfg::python_exec -c {import argparse, base64, hashlib, json, pathlib, re, sys, typing; print("PYTHON_IMPORTS:OK")}]
}
proc volume_ip {vlnv name configuration} {
    if {[llength [info commands ::ipcfg::create_cell_cfg]]} {
        set result [ipcfg::create_cell_cfg $vlnv $name $configuration]
        puts $result
        if {[string match *FAIL* $result]} {error $result}
    } else {
        create_bd_cell -type ip -vlnv $vlnv $name
        if {[llength $configuration]} {set_property -dict $configuration [get_bd_cells $name]}
    }
    dict for {key expected} $configuration {
        set actual [get_property $key [get_bd_cells $name]]
        if {$actual ne $expected && !([string is double -strict $actual] && [string is double -strict $expected] && $actual == $expected)} {
            error "IP_READBACK_FAILED $name $key wanted=$expected got=$actual"
        }
    }
}
source [file join $volume_repo board pynq_z2 generated pynq_z2_ps7_config.tcl]
set volume_ps_configuration [list CONFIG.PCW_USE_M_AXI_GP0 1 CONFIG.PCW_USE_M_AXI_GP1 0 \
    CONFIG.PCW_USE_S_AXI_GP0 0 CONFIG.PCW_USE_S_AXI_GP1 0 CONFIG.PCW_USE_S_AXI_HP0 0 \
    CONFIG.PCW_USE_S_AXI_HP1 0 CONFIG.PCW_USE_S_AXI_HP2 0 CONFIG.PCW_USE_S_AXI_HP3 0 \
    CONFIG.PCW_USE_S_AXI_ACP 0 CONFIG.PCW_EN_CLK0_PORT 1 CONFIG.PCW_EN_RST0_PORT 1 \
    CONFIG.PCW_EN_CLK1_PORT 0 CONFIG.PCW_EN_CLK2_PORT 0 CONFIG.PCW_EN_CLK3_PORT 0 \
    CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ 100 CONFIG.PCW_I2C1_PERIPHERAL_ENABLE 1 CONFIG.PCW_I2C1_I2C1_IO EMIO]
if {[llength [info commands ::ipcfg::apply_dict]]} {
    set result [ipcfg::apply_dict ps7_0 $volume_ps_configuration]
    puts $result
    if {[string match *FAIL* $result]} {error $result}
    set mismatch [ipcfg::verify_stuck ps7_0 $volume_ps_configuration]
    if {[llength $mismatch]} {error "PS7_READBACK_FAILED $mismatch"}
} else {set_property -dict $volume_ps_configuration [get_bd_cells ps7_0]}
make_bd_intf_pins_external [get_bd_intf_pins ps7_0/DDR]
set_property name DDR [get_bd_intf_ports DDR_0]
make_bd_intf_pins_external [get_bd_intf_pins ps7_0/FIXED_IO]
set_property name FIXED_IO [get_bd_intf_ports FIXED_IO_0]
make_bd_intf_pins_external [get_bd_intf_pins ps7_0/IIC_1]
set_property name IIC_1 [get_bd_intf_ports IIC_1_0]
volume_ip xilinx.com:ip:proc_sys_reset:5.0 control_reset [list CONFIG.C_EXT_RESET_HIGH 0 CONFIG.C_AUX_RESET_HIGH 1]
volume_ip xilinx.com:ip:axi_protocol_converter:2.1 control_axi [list CONFIG.SI_PROTOCOL AXI3 CONFIG.MI_PROTOCOL AXI4LITE CONFIG.DATA_WIDTH 32 CONFIG.ID_WIDTH 12]
volume_ip xilinx.com:ip:clk_wiz:6.0 audio_mclk [list CONFIG.PRIM_SOURCE No_buffer CONFIG.PRIM_IN_FREQ 100.000 CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 10.000 CONFIG.USE_RESET false]
volume_ip xilinx.com:ip:xlconstant:1.1 constant_high [list CONFIG.CONST_WIDTH 1 CONFIG.CONST_VAL 1]
volume_ip xilinx.com:ip:xlconstant:1.1 constant_low [list CONFIG.CONST_WIDTH 1 CONFIG.CONST_VAL 0]
create_bd_cell -type module -reference voice_volume_top voice_volume_0
connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] [get_bd_pins ps7_0/M_AXI_GP0_ACLK] \
    [get_bd_pins control_reset/slowest_sync_clk] [get_bd_pins control_axi/aclk] \
    [get_bd_pins audio_mclk/clk_in1] [get_bd_pins voice_volume_0/s_axi_aclk]
connect_bd_net [get_bd_pins ps7_0/FCLK_RESET0_N] [get_bd_pins control_reset/ext_reset_in]
connect_bd_net [get_bd_pins constant_high/dout] [get_bd_pins control_reset/dcm_locked]
connect_bd_net [get_bd_pins constant_low/dout] [get_bd_pins control_reset/aux_reset_in] [get_bd_pins control_reset/mb_debug_sys_rst]
connect_bd_net [get_bd_pins control_reset/peripheral_aresetn] [get_bd_pins control_axi/aresetn] [get_bd_pins voice_volume_0/s_axi_aresetn]
connect_bd_net [get_bd_pins audio_mclk/locked] [get_bd_pins voice_volume_0/codec_mclk_locked]
connect_bd_intf_net [get_bd_intf_pins ps7_0/M_AXI_GP0] [get_bd_intf_pins control_axi/S_AXI]
connect_bd_intf_net [get_bd_intf_pins control_axi/M_AXI] [get_bd_intf_pins voice_volume_0/s_axi]
make_bd_pins_external [get_bd_pins audio_mclk/clk_out1]
set_property name audio_clk_10MHz [get_bd_ports clk_out1_0]
foreach {pin port} {i2s_bclk bclk i2s_lrclk lrclk i2s_sdata sdata_i codec_address codec_address} {
    make_bd_pins_external [get_bd_pins voice_volume_0/$pin]
    set_property name $port [get_bd_ports ${pin}_0]
}
create_bd_port -dir O sdata_o
connect_bd_net [get_bd_pins constant_low/dout] [get_bd_ports sdata_o]
source [file join $volume_repo board pynq_z2 scripts finish_voice_volume_project.tcl]