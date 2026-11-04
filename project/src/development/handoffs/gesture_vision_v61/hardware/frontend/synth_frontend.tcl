# PYNQ-Z2 xc7z020clg400-1 / Vivado2026.1; no changes to camera/HDMI project.
# Run via D:/AMD/vivado_recovery_20261004/run_vivado.ps1 -Script this-file.
# Output synth/*.rpt, frontend.dcp; next full camera routing and board golden.
set root [file dirname [file normalize [info script]]]
set out [file join $root synth]
file mkdir $out
cd [file join $root rtl]
read_verilog -sv [file join $root rtl axis_bgr_hsv_skin.sv]
synth_design -top axis_bgr_hsv_skin -part xc7z020clg400-1 -mode out_of_context
create_clock -name aclk -period 10 [get_ports aclk]
report_utilization -file [file join $out utilization.rpt]
report_timing_summary -file [file join $out timing.rpt]
write_checkpoint -force [file join $out frontend.dcp]
puts "BGR_HSV_FRONTEND_SYNTH_COMPLETE OOC_ONLY not_board_validated"
