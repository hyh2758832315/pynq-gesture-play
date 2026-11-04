# PYNQ-Z2 xc7z020clg400-1 / Vivado 2026.1; read-only AR 64289 clock evidence.
# Run after close_design:
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/collect_latency_admission_clock.tcl
# Outputs: physical-r04/clock-review-r01 raw clock routing/topology, timing, route, utilization, XDC.
# Next: independently review the exact DCP; this script creates no waiver or deployment artifact.
set crrepo E:/projects/fpga/voice-view-game
set crroot $crrepo/build/hosd/c0e/admission-r01/physical-r04
set crinput $crroot/signoff/candidate.dcp
set crout $crroot/clock-review-r01
if {[file exists $crout]} {error {preserve clock review evidence}}
set crsha [exec $crrepo/.venv/Scripts/python.exe -B -c {import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest())} $crinput]
if {$crsha ne {d93553902fbfc2c0295200641fb0185e09716b2d5b10c90e6a44573ad3ec8346}} {error {unrecognized clock review DCP}}
file mkdir $crout
file copy [info script] $crout/collect_latency_admission_clock.tcl
open_checkpoint $crinput
if {[get_property PART [current_design]] ne {xc7z020clg400-1} || [version -short] ne {2026.1}} {error {wrong target/tool}}
set crfp [open $crout/topology.tcldict {WRONLY CREAT EXCL}]
puts $crfp [list candidate_sha256 $crsha tool [version -short] part [get_property PART [current_design]]]
set crbufs [lsort [get_cells -hier -filter {NAME =~ *buffer_fclk_clk_0* && REF_NAME =~ BUFG*}]]
if {[llength $crbufs]!=4} {error {unexpected buffer count}}
foreach crcell $crbufs {
    set crin [get_nets -of_objects [get_pins $crcell/I]]
    set crnet [get_nets -of_objects [get_pins $crcell/O]]
    set crloads [get_pins -leaf -of_objects $crnet -filter {DIRECTION == IN}]
    puts $crfp [list cell $crcell ref [get_property REF_NAME $crcell] loc [get_property LOC $crcell] input_drivers [get_pins -leaf -of_objects $crin -filter {DIRECTION == OUT}] output_clock [get_clocks -of_objects [get_pins $crcell/O]] net $crnet loads [llength $crloads] route_status [get_property ROUTE_STATUS $crnet] clock_dedicated_route [get_property CLOCK_DEDICATED_ROUTE $crnet] route_fixed [get_property IS_ROUTE_FIXED $crnet]]
    puts $crfp [list route_for $crcell route [get_property ROUTE $crnet]]
    if {[llength $crloads]<1000} {
        puts $crfp [list load_pins_for $crcell pins $crloads]
        foreach crseq [lsort [get_cells -of_objects $crloads -filter {IS_SEQUENTIAL == 1}]] {
            puts $crfp [list sequential $crseq ref [get_property REF_NAME $crseq] clocks [get_clocks -of_objects [get_pins -of_objects $crseq -filter {IS_CLOCK == 1}]]]
        }
    }
}
close $crfp
report_timing_summary -delay_type min_max -report_unconstrained -file $crout/timing.rpt
report_route_status -file $crout/route.rpt
report_clock_utilization -file $crout/clock_utilization.rpt
write_xdc -exclude_physical $crout/effective_timing.xdc
puts C0E_ADMISSION_CLOCK_FACTS_COLLECTED_REVIEW_REQUIRED
