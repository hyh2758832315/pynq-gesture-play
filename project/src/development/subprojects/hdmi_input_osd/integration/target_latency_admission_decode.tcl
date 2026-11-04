# PYNQ-Z2 / Vivado 2026.1. Offline driver replication for measured residual decode paths.
# Run after close_design:
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/target_latency_admission_decode.tcl
# Outputs: physical-r04/targeted-r03 driver bindings, after_force.dcp, STA/route/XDC reports.
# Next: inspect actual replication and routing before further route/optimization or signoff.
# Targets AR bit23, AR range0 LUT and AW bit27 from measured routed paths, applied pre-route.
set atrepo E:/projects/fpga/voice-view-game
set atbase $atrepo/build/hosd/c0e/admission-r01/physical-r04
set atout $atbase/targeted-r03
if {[file exists $atout]} {error {preserve targeted experiment}}
file mkdir $atout
file copy [info script] $atout/target_latency_admission_decode.tcl
set atsha [exec $atrepo/.venv/Scripts/python.exe -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $atbase/placed.dcp]
if {$atsha ne {965577553cbb505ff4a5fc727268e2df65bd52164ee4907bf88c96bc0317c0d6}} {error {wrong placement checkpoint identity}}
open_checkpoint $atbase/placed.dcp
if {[get_property PART [current_design]] ne {xc7z020clg400-1} || [version -short] ne {2026.1}} {error {wrong target/tool}}
report_route_status -file $atout/before_unroute.rpt
# Incremental placement retains reference routes. Explicitly return to the supported pre-route stage.
route_design -unroute
report_route_status -file $atout/after_unroute.rpt
set atnets {}
set atfp [open $atout/targets.tcldict {WRONLY CREAT EXCL}]
foreach {atpin atloads atref} {
    {c6v_i/vision_gp0_slice/inst/ar.ar_pipe/m_payload_i_reg[23]/Q} 8 FDRE
    {c6v_i/gp0_smc/inst/s00_entry_pipeline/s00_mmu/inst/ar_reg_stall/skid_buffer[79]_i_7__0/O} 11 LUT6
    {c6v_i/vision_gp0_slice/inst/aw.aw_pipe/m_payload_i_reg[27]/Q} 2 FDRE
} {
    set atmatch [get_pins $atpin]
    if {[llength $atmatch]!=1 || [get_property DIRECTION $atmatch] ne {OUT}} {error {driver binding failed}}
    set atcell [get_cells -of_objects $atmatch]
    if {[get_property REF_NAME $atcell] ne $atref} {error {driver primitive mismatch}}
    set atnet [get_nets -of_objects $atmatch]
    if {[llength $atnet]!=1} {error {driver net ambiguous}}
    set atpins [get_pins -leaf -of_objects $atnet -filter {DIRECTION == IN}]
    if {[llength $atpins]!=$atloads} {error {recorded fanout changed}}
    lappend atnets $atnet
    puts $atfp [list driver $atmatch ref $atref net $atnet loads $atpins]
}
close $atfp
phys_opt_design -force_replication_on_nets $atnets
write_checkpoint $atout/after_force.dcp
report_timing_summary -delay_type min_max -report_unconstrained -file $atout/timing.rpt
report_timing -delay_type max -max_paths 40 -nworst 1 -input_pins -file $atout/setup.rpt
report_route_status -file $atout/route.rpt
write_xdc -exclude_physical $atout/effective_timing.xdc
puts C0E_ADMISSION_DECODE_REPLICATION_COMPLETE_REVIEW_REQUIRED
