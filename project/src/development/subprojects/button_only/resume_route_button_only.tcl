# Resume only the isolated button-only implementation after correcting its CDC hook.
# Run: D:/Xilinx/Vivado/2026.1/Vivado/bin/vivado.bat -mode batch -source E:/projects/fpga/voice-view-game/subprojects/button_only/resume_route_button_only.tcl -log D:/vvg_button_only_r22/route_retry.log
# Output: routed checkpoint and route_{timing,drc,cdc,status}.rpt.
# Next: inspect signed timing/DRC before generating a bitstream or accessing the board.
set stage {D:/vvg_button_only_r22}
if {[version -short] ne {2026.1}} {error {wrong Vivado version}}
open_project $stage/c6_latency.xpr
if {[get_property PART [current_project]] ne {xc7z020clg400-1}} {error {wrong part}}
set run [get_runs impl_button_r22]
if {[llength $run] != 1 || [get_property PROGRESS [get_runs synth_button_r22]] ne {100%}} {
    error {isolated full synthesis not ready}
}
set_property STEPS.OPT_DESIGN.TCL.POST {E:/projects/fpga/voice-view-game/subprojects/button_only/constraints/postopt_button_admission.tcl} $run
reset_runs $run
close_project
source -notrace {E:/projects/fpga/voice-view-game/subprojects/button_only/route_button_only.tcl}
