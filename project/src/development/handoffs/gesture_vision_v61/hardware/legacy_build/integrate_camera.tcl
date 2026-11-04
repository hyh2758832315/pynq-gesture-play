# PYNQ-Z2 xc7z020clg400-1 / Vivado2026.1. Never edit original cacc/cosd.
# Run via run_vivado.ps1 -Script this-file; output b/cskin/cskin.xpr.
# Next: build_camera.tcl, paired release, synthetic/raw frame board tests.
set root [file dirname [file normalize [info script]]]
if {[file exists D:/AMD/b/cskin/cskin.xpr]} {error "cskin exists; refuse to overwrite; use build_camera.tcl"}
open_project D:/AMD/b/cacc/cacc.xpr
save_project_as cskin D:/AMD/b/cskin
open_bd_design [get_files camera.bd]
if {![llength [get_bd_cells -quiet moments_kernel]]} {error "expected original algorithm cell"}
delete_bd_objs [get_bd_cells moments_kernel]
add_files -norecurse [file join $root rtl axis_bgr_hsv_skin.sv] [file join $root rtl axis_mask_pack32.sv] [file join $root rtl bgr_skin_dma.sv] [file join $root rtl hsv_reciprocal.svh]
set_property include_dirs [list [file join $root rtl]] [current_fileset]
set_property file_type {Verilog Header} [get_files hsv_reciprocal.svh]
update_compile_order -fileset sources_1
create_bd_cell -type module -reference bgr_skin_dma skin_kernel
connect_bd_intf_net [get_bd_intf_pins moments_dma/M_AXIS_MM2S] [get_bd_intf_pins skin_kernel/s_axis]
connect_bd_intf_net [get_bd_intf_pins skin_kernel/m_axis] [get_bd_intf_pins moments_dma/S_AXIS_S2MM]
connect_bd_net [get_bd_pins ps7_0/FCLK_CLK0] [get_bd_pins skin_kernel/aclk]
connect_bd_net [get_bd_pins moments_reset_and/Res] [get_bd_pins skin_kernel/aresetn]
validate_bd_design
save_bd_design
generate_target all [get_files camera.bd]
update_compile_order -fileset sources_1
puts "CAMERA_SKIN_BD_PASS independent=cskin dedicated_DMA_reused HDMI_unchanged"
close_project
