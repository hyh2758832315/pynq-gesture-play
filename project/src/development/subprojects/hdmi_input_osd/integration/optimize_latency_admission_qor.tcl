# PYNQ-Z2 / Vivado 2026.1, same admission RTL and timing constraints.
# Run after closing the prior report design:
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/optimize_latency_admission_qor.tcl
# Outputs: physical-r03/optimization-r01 target bindings and force/Explore DCP/timing reports.
# Next: audit unchanged timing constraints, route, and collect complete physical signoff.
# Sixth exported QoR pin (event_sample_comp) did not exist in placed design and is deliberately excluded.
set aqbase E:/projects/fpga/voice-view-game/build/hosd/c0e/admission-r01/physical-r03
set aqout $aqbase/optimization-r01
if {[file exists $aqout]} {error {preserve optimization evidence}}
file mkdir $aqout
file copy [info script] $aqout/optimize_latency_admission_qor.tcl
open_checkpoint $aqbase/placed.dcp
if {[get_property PART [current_design]] ne {xc7z020clg400-1} || [version -short] ne {2026.1}} {error {wrong device/tool}}
set aqnets {}
set aqfp [open $aqout/targets.tcldict {WRONLY CREAT EXCL}]
foreach aqpin {
    c6v_i/capture_write_pair/inst/rgb/frame_completion.completed_frames[31]_i_12__0/O
    c6v_i/dual_mask_capture/inst/capture/drain/frame_fault_INST_0/O
    c6v_i/gp0_smc/inst/s00_entry_pipeline/s00_mmu/inst/aw_reg_stall/gen_wroute_reg.wroute_i[10]_i_2/O
    c6v_i/gp0_smc/inst/s00_entry_pipeline/s00_mmu/inst/aw_reg_stall/gen_wroute_reg.wroute_i[7]_i_1/O
    c6v_i/voice_volume_0/inst/registers/core/event_age[31]_i_7/O
} {
    set aqmatch [get_pins $aqpin]
    if {[llength $aqmatch]!=1 || [get_property DIRECTION $aqmatch] ne {OUT}} {error {QoR output pin binding failed}}
    set aqnet [get_nets -of_objects $aqmatch]
    if {[llength $aqnet]!=1} {error {QoR net ambiguous}}
    lappend aqnets $aqnet
    puts $aqfp [list driver $aqmatch net $aqnet loads [llength [get_pins -leaf -of_objects $aqnet -filter {DIRECTION == IN}]]]
}
close $aqfp
if {[llength [lsort -unique $aqnets]]!=5} {error {QoR net set drift}}
phys_opt_design -force_replication_on_nets $aqnets
write_checkpoint $aqout/after_force.dcp
report_timing_summary -delay_type min_max -file $aqout/after_force_timing.rpt
phys_opt_design -directive Explore
write_checkpoint $aqout/optimized.dcp
report_timing_summary -delay_type min_max -report_unconstrained -file $aqout/optimized_timing.rpt
report_timing -delay_type max -max_paths 40 -nworst 1 -input_pins -file $aqout/optimized_setup.rpt
write_xdc -exclude_physical $aqout/effective_timing.xdc
puts C0E_ADMISSION_QOR_OPTIMIZED_REQUIRES_ROUTE
