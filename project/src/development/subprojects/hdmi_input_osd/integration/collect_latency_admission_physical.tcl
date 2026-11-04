# PYNQ-Z2 / Vivado 2026.1 / owned C0E project, completed admission implementation.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/collect_latency_admission_physical.tcl
# Outputs: admission-r01/physical-r01/signoff + extended + source list + original run log.
# Next: inspect setup/hold/CDC/constraints/DRC/resources; do not export if any gate fails.
# Collects evidence even for negative timing, never treats run completion as signoff.
if {[file normalize [get_property DIRECTORY [current_project]]] ne {E:/vvl/c0e}} {error {wrong project}}
set aprun {E:/vvl/c0e/c6_latency.runs/impl_admission_r01}
if {![file exists $aprun/.post_route_phys_opt_design.end.rst]} {error {post-route physical optimization not complete}}
set aproot {E:/projects/fpga/voice-view-game/build/hosd/c0e/admission-r01/physical-r01}
if {[file exists $aproot]} {error {preserve prior physical evidence}}
file mkdir $aproot
file copy [info script] $aproot/collect_latency_admission_physical.tcl
file copy $aprun/runme.log $aproot/implementation-run.log
file copy $aprun/c6v_wrapper.tcl $aproot/implementation-generated.tcl
set apfp [open $aproot/project_synthesis_files.txt {WRONLY CREAT EXCL}]
foreach apfile [get_files -compile_order sources -used_in synthesis] {puts $apfp [file normalize $apfile]}
close $apfp
open_checkpoint $aprun/c6v_wrapper_postroute_physopt.dcp
set apdir {E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration}
set ::osd_report_dir $aproot/signoff
source $apdir/collect_reports.tcl
set ::latency_ext_dir $aproot/extended
source $apdir/collect_latency_extended.tcl
source $apdir/collect_latency_reset_aliases.tcl
# The added reset is independently checked, including both selector spellings.
set apreset c6v_i/capture_lifecycle/inst/release_credit/video_reset
current_instance $apreset
set apa [get_ports -scoped_to_current_instance -no_traverse src_arst]
set apb [get_ports -scoped_to_current_instance src_arst]
current_instance -quiet
if {[llength $apa]!=1 || [llength $apb]!=1 || $apa ne $apb} {error {new reset selector mismatch}}
set apfp [open $aproot/extended/release_cdc.tcldict {WRONLY CREAT EXCL}]
puts $apfp [list candidate_sha256 $pwsha]
puts $apfp [list reset_scope $apreset no_traverse $apa normal $apb equal 1]
for {set api 0} {$api<3} {incr api} {
    set apsrc [get_cells -hier -regexp [format {^c6v_i/capture_lifecycle/inst/release_credit/source_gray_reg\[%d\]$} $api]]
    set apdst [get_cells -hier -regexp [format {^c6v_i/capture_lifecycle/inst/release_credit/gray_meta_reg\[%d\]$} $api]]
    if {[llength $apsrc]!=1 || [llength $apdst]!=1} {error {Gray endpoint missing}}
    set appath [get_timing_paths -from $apsrc -to $apdst -max_paths 1]
    if {[llength $appath]!=1 || [get_property REQUIREMENT $appath]!=10.0} {error {Gray max delay missing}}
    puts $apfp [list bit $api from $apsrc to $apdst requirement [get_property REQUIREMENT $appath] slack [get_property SLACK $appath]]
    foreach apstage {gray_meta gray_sync gray_settled} {
        set apcell [get_cells -hier -regexp [format {^c6v_i/capture_lifecycle/inst/release_credit/%s_reg\[%d\]$} $apstage $api]]
        if {[llength $apcell]!=1 || ![get_property ASYNC_REG $apcell]} {error {release synchronizer missing}}
        set apclock [get_clocks -of_objects [get_pins -of_objects $apcell -filter {REF_PIN_NAME == C}]]
        if {$apclock ne {vid_pclk}} {error {release synchronizer wrong clock}}
        puts $apfp [list sync $apcell async_reg [get_property ASYNC_REG $apcell] clock $apclock]
    }
}
close $apfp
report_qor_suggestions -max_paths 100 -file $aproot/extended/qor_suggestions.rpt
close_design
puts C0E_ADMISSION_PHYSICAL_REPORTS_COLLECTED_NOT_YET_SIGNED_OFF
