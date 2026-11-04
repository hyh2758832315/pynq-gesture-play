# Vivado2026.1 PYNQ-Z2; run via run_vivado.ps1. Output reports + matched bit/HWH.
# Refuse export on failed routed timing/CDC/DRC/skew. Next board golden tests.
set root [file dirname [file normalize [info script]]]
set reports [file join $root camera_reports]
set release [file join $root camera_release]
file mkdir $reports
open_project D:/AMD/b/cskin/cskin.xpr
open_bd_design [get_files camera.bd]
update_module_reference -verbose [get_ips *skin_kernel*]
validate_bd_design
save_bd_design
generate_target all [get_files camera.bd]
add_files -norecurse [make_wrapper -files [get_files camera.bd] -top]
set_property top camera_wrapper [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
set kernel_runs [get_runs -quiet *skin_kernel*synth*]
if {[llength $kernel_runs]} {reset_run $kernel_runs}
launch_runs synth_1 -jobs 2
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {error "Synthesis failed"}
reset_run impl_1
launch_runs impl_1 -to_step route_design -jobs 2
wait_on_run impl_1
if {![string match {*route_design Complete*} [get_property STATUS [get_runs impl_1]]]} {error "Routing failed"}
open_run impl_1
report_timing_summary -delay_type min_max -report_unconstrained -file [file join $reports timing.rpt]
report_utilization -hierarchical -file [file join $reports utilization.rpt]
set cdc [report_cdc -details -return_string]
set f [open [file join $reports cdc_unwaived.rpt] w];puts $f $cdc;close $f
report_drc -file [file join $reports drc.rpt]
set skew [report_bus_skew -return_string]
set f [open [file join $reports bus_skew.rpt] w];puts $f $skew;close $f
if {[regexp {VIOLATED} $skew]} {error "Bus skew violation; no bitstream"}
foreach type {max min} {
    set p [get_timing_paths -delay_type $type -max_paths 1]
    if {![llength $p] || [get_property SLACK $p]<0} {error "Routed $type timing fails; no bitstream"}
}
if {[regexp {CDC-[0-9]+\s+Critical} $cdc]} {error "Critical CDC; no bitstream"}
foreach violation [get_drc_violations] {
    if {[get_property SEVERITY $violation] eq "Error"} {error "DRC Error; no bitstream"}
}
write_bitstream -force [file join $release camera_hand_skin_v6.bit]
file copy -force D:/AMD/b/cskin/cskin.gen/sources_1/bd/camera/hw_handoff/camera.hwh [file join $release camera_hand_skin_v6.hwh]
puts "CAMERA_SKIN_ROUTE_PASS matched_bit_HWH not_board_validated HDMI_enabled"
close_project
