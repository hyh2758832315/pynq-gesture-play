# PYNQ-Z2 xc7z020clg400-1; Vivado/XSim 2026.1; archived R20 RTL only.
# Run: vivado -mode batch -source run_kernel_timing.tcl
# Outputs: work/kernel_timing.sim/sim_1/behav/xsim/{simulate.log,xsim.log}.
# Next: require TEST_PASS and derive milliseconds as elapsed_cycles * 0.00001.
set here [file dirname [file normalize [info script]]]
create_project kernel_timing [file join $here work] -part xc7z020clg400-1 -force
set_property target_language Verilog [current_project]
set_property target_simulator XSim [current_project]
set_property XPM_LIBRARIES {XPM_FIFO} [current_project]
set rtl_dir [file join $here frozen_r20]
add_files [list [file join $rtl_dir axis_bgr_hsv_skin.sv] [file join $rtl_dir axis_binary_dilate9.sv] [file join $rtl_dir axis_binary_gaussian5.sv] [file join $rtl_dir axis_binary_mask_pair.sv]]
set_property include_dirs [list $rtl_dir] [get_filesets sources_1]
add_files -fileset sim_1 [file join $here tb_kernel_timing.sv]
set_property top tb_kernel_timing [get_filesets sim_1]
set_property xsim.simulate.runtime 10ms [get_filesets sim_1]
update_compile_order -fileset sim_1
launch_simulation -simset sim_1 -mode behavioral
close_sim
close_project
