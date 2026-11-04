# Owned C0E project / PYNQ-Z2 / Vivado 2026.1.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/collect_latency_admission_opt.tcl
# Output: admission-r01/opt-review-r02 source-bound optimized DCP, CDC, effective XDC and exact 3-bit path checks.
# Next: review CDC and constraint delta; then resume impl_admission_r01 through post-route phys_opt_design.
# This is not post-route timing signoff and performs no board operation.
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong project}}
if {[get_property STATUS [get_runs impl_admission_r01]] ni {{opt_design Complete!} {Not started place_design}}} {error {optimization not complete}}
if {![file exists E:/vvl/c0e/c6_latency.runs/impl_admission_r01/.opt_design.end.rst]} {error {opt_design completion marker missing}}
set aorepo {E:/projects/fpga/voice-view-game}
set aoout $aorepo/build/hosd/c0e/admission-r01/opt-review-r02
if {[file exists $aoout]} {error {preserve earlier opt review}}
file mkdir $aoout
file copy [info script] $aoout/collect_latency_admission_opt.tcl
open_checkpoint E:/vvl/c0e/c6_latency.runs/impl_admission_r01/c6v_wrapper_opt.dcp
set aogray [dict create]
for {set aoi 0} {$aoi<3} {incr aoi} {
    set aosrc [get_cells -hier -regexp [format {^c6v_i/capture_lifecycle/inst/release_credit/source_gray_reg\[%d\]$} $aoi]]
    set aodst [get_cells -hier -regexp [format {^c6v_i/capture_lifecycle/inst/release_credit/gray_meta_reg\[%d\]$} $aoi]]
    if {[llength $aosrc]!=1 || [llength $aodst]!=1} {error {Gray bit endpoint not unique}}
    set aopath [get_timing_paths -from $aosrc -to $aodst -max_paths 1]
    if {[llength $aopath]!=1 || [get_property REQUIREMENT $aopath]!=10.0} {error {Gray max-delay constraint missing}}
    dict set aogray $aoi [list source $aosrc destination $aodst requirement [get_property REQUIREMENT $aopath] async_reg [get_property ASYNC_REG $aodst]]
}
report_cdc -details -file $aoout/cdc.rpt
report_bus_skew -warn_on_violation -file $aoout/bus_skew.rpt
report_utilization -hierarchical -file $aoout/utilization_hier.rpt
write_xdc -exclude_physical $aoout/effective_timing.xdc
file copy E:/vvl/c0e/c6_latency.runs/impl_admission_r01/c6v_wrapper_opt.dcp $aoout/candidate.dcp
file copy E:/vvl/c0e/c6_latency.runs/impl_admission_r01/runme.log $aoout/implementation-opt.log
file copy E:/vvl/c0e/c6_latency.runs/impl_admission_r01/c6v_wrapper.tcl $aoout/implementation-generated.tcl
set aofp [open $aoout/gray-paths.tcldict {WRONLY CREAT EXCL}]
puts $aofp [dict create status ADMISSION_OPT_GRAY_PATHS_BOUND bits $aogray board_access false postroute_signoff false]
close $aofp
close_design
puts C0E_ADMISSION_OPT_REVIEW_COLLECTED
