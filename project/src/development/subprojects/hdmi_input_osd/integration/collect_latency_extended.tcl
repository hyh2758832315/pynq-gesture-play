# Owned C0E optimized session only. No design/constraint changes or board IO.
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/collect_latency_extended.tcl
# Outputs: expanded DRC, all-endpoint CDC, methodology JSON and physical DMA clock evidence.
# Next: independent scoped review before any bit export.
if {[info exists ::latency_ext_dir]} {
    set ext [file normalize $::latency_ext_dir]
} else {
    set ext {E:/projects/fpga/voice-view-game/build/hosd/c0e/postroute-r05/extended}
}
if {[file exists $ext]} {error {preserve extended evidence}}
file mkdir $ext
set oldlimit [get_param drc.maxLimitREQP1839and1840]
set_param drc.maxLimitREQP1839and1840 -1
report_drc -file $ext/drc_unlimited.rpt
set_param drc.maxLimitREQP1839and1840 $oldlimit
report_cdc -details -all_checks_per_endpoint -file $ext/cdc_all.rpt
report_methodology -json $ext/methodology.json
report_control_sets -verbose -file $ext/control_sets.rpt
set fp [open $ext/design_identity.tcldict {WRONLY CREAT EXCL}]
puts $fp [dict create design [current_design] part [get_property PART [current_design]] wns [get_property SLACK [get_timing_paths -delay_type max -max_paths 1]] whs [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]]
foreach pattern {*moments_dma*lite_rdata_cdc_from_reg* *moments_dma*syncstages_ff_reg*} {
    foreach cell [get_cells -hier -filter "NAME =~ $pattern"] {
        puts $fp [list cell $cell clocks [get_clocks -of_objects [get_pins -of_objects $cell -filter {IS_CLOCK == 1}]]]
    }
}
close $fp
puts C0E_EXTENDED_REVIEW_COLLECTED
