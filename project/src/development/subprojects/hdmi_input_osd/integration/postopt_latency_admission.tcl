# PYNQ-Z2 xc7z020clg400-1 / Vivado 2026.1, prospective admission implementation hook.
# Run only on the admission candidate after opt_design:
# source -notrace E:/projects/fpga/voice-view-game/subprojects/hdmi_input_osd/integration/postopt_latency_admission.tcl
# Output: inherited constraints plus exactly the three-bit release Gray CDC paths.
# Next: report_cdc, report_bus_skew, full setup/hold and effective-XDC delta audit.
# Not yet bound to a production run; execution is gated on full video simulation.
# AMD UG903 set_bus_skew Example Two / UG949 Constraints on Individual CDC Paths.
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong admission target}}
if {[version -short] ne {2026.1}} {error {unverified Vivado version}}
source -notrace {E:/projects/fpga/voice-view-game/build/hosd/c0d/postopt_osd.tcl}
set admission_gray_src [get_cells -hier -regexp {^c6v_i/capture_lifecycle/inst/release_credit/source_gray_reg\[[0-2]\]$}]
set admission_gray_dst [get_cells -hier -regexp {^c6v_i/capture_lifecycle/inst/release_credit/gray_meta_reg\[[0-2]\]$}]
if {[llength $admission_gray_src]!=3 || [llength $admission_gray_dst]!=3} {error {release Gray endpoints must be exactly three bits}}
set admission_gray_src_clocks [get_clocks -of_objects [get_pins -of_objects $admission_gray_src -filter {REF_PIN_NAME == C}]]
set admission_gray_dst_clocks [get_clocks -of_objects [get_pins -of_objects $admission_gray_dst -filter {REF_PIN_NAME == C}]]
if {[llength $admission_gray_src_clocks]!=1 || [llength $admission_gray_dst_clocks]!=1 ||
    [get_property NAME $admission_gray_src_clocks] ne {clk_fpga_0} ||
    [get_property NAME $admission_gray_dst_clocks] ne {vid_pclk}} {error {unexpected release CDC clocks}}
# Keep the inherited conservative 10ns PCLK timing constraint, although stimulus is 74.25MHz.
if {[get_property PERIOD $admission_gray_src_clocks]!=10.0 || [get_property PERIOD $admission_gray_dst_clocks]!=10.0} {
    error {inherited clock periods changed}
}
foreach admission_gray_cell $admission_gray_dst {
    if {![get_property ASYNC_REG $admission_gray_cell]} {error {release CDC first stage lost ASYNC_REG}}
}
set_max_delay -datapath_only -from $admission_gray_src -to $admission_gray_dst 10.000
set_bus_skew -from $admission_gray_src -to $admission_gray_dst 10.000
puts C0E_ADMISSION_RELEASE_GRAY_CDC_BOUND_3_BITS
