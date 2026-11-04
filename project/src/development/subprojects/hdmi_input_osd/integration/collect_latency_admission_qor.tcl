# PYNQ-Z2/Vivado 2026.1, complete offline reports for physical-r03 or physical-r04.
# Run after close_design; set ::admission_qor_checkpoint to the reviewed final DCP path, then:
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/collect_latency_admission_qor.tcl
# Optional: set ::admission_qor_root to the exclusive physical-r04 directory.
# Outputs: selected root/signoff and extended, including DCP-bound reset/Gray/clock evidence.
# Next: independent audit_latency_admission_physical.py --root .../physical-r03 --receipt <new receipt>.
# No bit export or board IO; negative timing is collected and remains a failure.
set acbase E:/projects/fpga/voice-view-game/build/hosd/c0e/admission-r01
if {[info exists ::admission_qor_root]} {
    set acroot [file normalize $::admission_qor_root]
} else {
    set acroot $acbase/physical-r03
}
if {$acroot ni [list $acbase/physical-r03 $acbase/physical-r04]} {error {unrecognized report root}}
set acdir E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration
if {![info exists ::admission_qor_checkpoint]} {error {select actual final checkpoint}}
set acinput [file normalize $::admission_qor_checkpoint]
if {$acinput ni [list $acroot/route-r01/routed.dcp $acroot/route-r02/routed.dcp $acroot/postroute-r01/optimized.dcp]} {error {unrecognized final checkpoint}}
if {[file exists $acroot/signoff] || [file exists $acroot/extended]} {error {preserve previous full reports}}
file copy [info script] $acroot/collect_latency_admission_qor.tcl
open_checkpoint $acinput
set ::osd_report_dir $acroot/signoff
source $acdir/collect_reports.tcl
set ::latency_ext_dir $acroot/extended
source $acdir/collect_latency_extended.tcl
source $acdir/collect_latency_reset_aliases.tcl
set acreset c6v_i/capture_lifecycle/inst/release_credit/video_reset
current_instance $acreset
set aca [get_ports -scoped_to_current_instance -no_traverse src_arst]
set acb [get_ports -scoped_to_current_instance src_arst]
current_instance -quiet
if {[llength $aca]!=1 || [llength $acb]!=1 || $aca ne $acb} {error {release reset selector mismatch}}
set acfp [open $acroot/extended/release_cdc.tcldict {WRONLY CREAT EXCL}]
puts $acfp [list candidate_sha256 $pwsha]
puts $acfp [list reset_scope $acreset no_traverse $aca normal $acb equal 1]
for {set aci 0} {$aci<3} {incr aci} {
    set acsrc [get_cells -hier -regexp [format {^c6v_i/capture_lifecycle/inst/release_credit/source_gray_reg\[%d\]$} $aci]]
    set acdst [get_cells -hier -regexp [format {^c6v_i/capture_lifecycle/inst/release_credit/gray_meta_reg\[%d\]$} $aci]]
    if {[llength $acsrc]!=1 || [llength $acdst]!=1} {error {Gray endpoint missing}}
    set acpath [get_timing_paths -from $acsrc -to $acdst -max_paths 1]
    if {[llength $acpath]!=1 || [get_property REQUIREMENT $acpath]!=10.0} {error {Gray max delay missing}}
    puts $acfp [list bit $aci from $acsrc to $acdst requirement [get_property REQUIREMENT $acpath] slack [get_property SLACK $acpath]]
    foreach acstage {gray_meta gray_sync gray_settled} {
        set accell [get_cells -hier -regexp [format {^c6v_i/capture_lifecycle/inst/release_credit/%s_reg\[%d\]$} $acstage $aci]]
        if {[llength $accell]!=1 || ![get_property ASYNC_REG $accell]} {error {release synchronizer missing}}
        set acclock [get_clocks -of_objects [get_pins -of_objects $accell -filter {REF_PIN_NAME == C}]]
        if {$acclock ne {vid_pclk}} {error {release synchronizer wrong clock}}
        puts $acfp [list sync $accell async_reg [get_property ASYNC_REG $accell] clock $acclock]
    }
}
close $acfp
set acfp [open $acroot/extended/fclk_topology.tcldict {WRONLY CREAT EXCL}]
puts $acfp [list candidate_sha256 $pwsha clock clk_fpga_0 period [get_property PERIOD [get_clocks clk_fpga_0]] waveform [get_property WAVEFORM [get_clocks clk_fpga_0]]]
set acbranch 0
foreach accell [lsort [get_cells -hier -filter {NAME =~ *buffer_fclk_clk_0* && REF_NAME =~ BUFG*}]] {
    set acin [get_nets -segments -of_objects [get_pins $accell/I]]
    set acon [get_nets -segments -of_objects [get_pins $accell/O]]
    puts $acfp [list cell $accell ref [get_property REF_NAME $accell] loc [get_property LOC $accell] input_drivers [get_pins -leaf -of_objects $acin -filter {DIRECTION == OUT}] output_clocks [get_clocks -of_objects [get_pins $accell/O]] output_loads [llength [get_pins -leaf -of_objects $acon -filter {DIRECTION == IN}]]]
    # AMD AR 64289: inspect paths from/to the small branches served by inserted BUFGs.
    # Keep all constraints and DRC messages; this is evidence collection, not a waiver.
    set acloads [get_pins -leaf -of_objects $acon -filter {DIRECTION == IN}]
    if {[llength $acloads]<1000} {
        puts $acfp [list branch $acbranch clock_load_pins $acloads]
        set acseq [get_cells -of_objects $acloads -filter {IS_SEQUENTIAL == 1}]
        if {[llength $acseq]>0} {
            report_timing -from $acseq -delay_type min_max -max_paths 20 -nworst 1 -input_pins -file $acroot/extended/fclk_branch${acbranch}_from.rpt
            report_timing -to $acseq -delay_type min_max -max_paths 20 -nworst 1 -input_pins -file $acroot/extended/fclk_branch${acbranch}_to.rpt
        }
    }
    incr acbranch
}
close $acfp
if {[get_property SLACK [get_timing_paths -delay_type max -max_paths 1]]<0} {
    report_qor_suggestions -max_paths 100 -file $acroot/extended/qor_suggestions.rpt
}
close_design
puts C0E_ADMISSION_QOR_COMPLETE_REPORTS_READY_FOR_INDEPENDENT_AUDIT
