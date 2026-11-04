# Vivado 2026.1 / PYNQ-Z2. Run from workspace root:
# D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -nojournal -source subprojects/hdmi_input_osd/osd_reset_repair_r01/tools/assemble_full.tcl -tclargs build/hosd/osd-reset-r01/full-r01
# Outputs assembly, optimized, placed and routed checkpoints/reports.
# Next: audit full timing, route, DRC, CDC and static cells before bit export.
if {$argc != 1} {error {expected one fresh output directory}}
set root E:/projects/fpga/voice-view-game
set base $root/build/hosd/marker-visibility-r02/signoff-r01/candidate.dcp
set ooc $root/build/hosd/osd-reset-r01/wrapper-ooc-r01
set src $root/subprojects/hdmi_input_osd/osd_reset_repair_r01
set out [file normalize [lindex $argv 0]]
if {[file exists $out]} {error {output exists; preserve previous evidence}}
if {[version -short] ne {2026.1} || ![file isfile $base] || ![file isfile $ooc/osd.dcp]} {error {tool or source checkpoint missing}}
set hash [exec $root/.venv/Scripts/python.exe -I -B -c {import hashlib,sys;print(hashlib.sha256(open(sys.argv[1],"rb").read()).hexdigest())} $base]
if {$hash ne {0d2e035785da9a93e03990ffdf3a6cb61868ce4af4cf488222516161f44ce3d5}} {error {R21 parent checkpoint drift}}
open_checkpoint $base
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong part}}
set before_setup [get_property SLACK [get_timing_paths -delay_type max -max_paths 1]]
set before_hold [get_property SLACK [get_timing_paths -delay_type min -max_paths 1]]
if {$before_setup < 0 || $before_hold < 0} {error {R21 parent timing failed}}
set fp [open $ooc/ports.tcldict r]
set expected [lsort [read $fp]]
close $fp
set rows {}
foreach p [get_pins c6v_i/input_osd_0/*] {lappend rows [list [get_property REF_PIN_NAME $p] [get_property DIRECTION $p]]}
if {[lsort $rows] ne $expected} {error {OSD parent interface differs}}
file mkdir $out
set fp [open $out/identity.tcldict {WRONLY CREAT EXCL}]
puts $fp [list parent_sha256 $hash parent_setup $before_setup parent_hold $before_hold parent_osd_pins [llength $rows]]
close $fp
write_xdc -exclude_physical $out/parent_timing.xdc
set fp [open $out/parent_static_cells.tcldict {WRONLY CREAT EXCL}]
foreach c [get_cells -hier -filter {IS_PRIMITIVE && NAME !~ c6v_i/input_osd_0/*}] {
    puts $fp [list [get_property NAME $c] [get_property REF_NAME $c] [get_property LOC $c] [get_property BEL $c]]
}
close $fp
update_design -cell c6v_i/input_osd_0 -black_box
lock_design -level routing
read_checkpoint -cell c6v_i/input_osd_0 -strict $ooc/osd.dcp
set ::osd_scope {c6v_i/input_osd_0/inst/impl/}
source $src/constraints/osd_cdc.tcl
write_xdc -exclude_physical $out/assembled_timing.xdc
write_checkpoint $out/assembled.dcp
puts OSD_RESET_FULL_ASSEMBLED
opt_design
write_checkpoint $out/optimized.dcp
puts OSD_RESET_FULL_OPTIMIZED
place_design -directive Quick
write_checkpoint $out/placed.dcp
puts OSD_RESET_FULL_PLACED
route_design -directive Explore
write_checkpoint $out/routed.dcp
report_route_status -file $out/route.rpt
report_timing_summary -delay_type min_max -report_unconstrained -max_paths 20 -file $out/timing.rpt
puts OSD_RESET_FULL_ROUTE_REVIEW_PENDING
