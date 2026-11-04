# After complete report collection on the exact final design; no constraint mutation.
# Run: source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/collect_latency_reset_aliases.tcl
# Inputs: ::osd_report_dir/candidate.dcp and ::latency_ext_dir. Output: DCP-bound reset_scope_aliases.tcldict.
# Next: auditor may accept only these exact six textual selector differences when both resolve to one identical port.
if {![info exists ::osd_report_dir] || ![info exists ::latency_ext_dir]} {error {report directories missing}}
set pwfile $::latency_ext_dir/reset_scope_aliases.tcldict
if {[file exists $pwfile]} {error {preserve alias evidence}}
set pwaliases {}
foreach pwscope {
    c6v_i/capture_lifecycle/inst/fence/source_reset
    c6v_i/capture_lifecycle/inst/admission/source_reset
    c6v_i/capture_lifecycle/inst/budget/video_reset
    c6v_i/capture_lifecycle/inst/budget/processing_reset
    c6v_i/capture_lifecycle/inst/fence/monitor/video_reset
    c6v_i/capture_lifecycle/inst/fence/monitor/processing_reset
} {
    current_instance $pwscope
    set pwa [get_ports -scoped_to_current_instance -no_traverse src_arst]
    set pwb [get_ports -scoped_to_current_instance src_arst]
    current_instance -quiet
    if {[llength $pwa]!=1 || [llength $pwb]!=1 || [lsort $pwa] ne [lsort $pwb]} {error "reset selector semantics changed: $pwscope"}
    lappend pwaliases [list scope $pwscope no_traverse $pwa normal $pwb equal 1]
}
set pwsha [exec E:/projects/fpga/voice-view-game/.venv/Scripts/python.exe -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $::osd_report_dir/candidate.dcp]
set pwfp [open $pwfile {WRONLY CREAT EXCL}]
puts $pwfp [dict create candidate_sha256 $pwsha aliases $pwaliases]
close $pwfp
puts C0E_SIX_RESET_SELECTORS_IDENTICAL_BOUND_TO_FINAL_DCP
