# PYNQ-Z2 xc7z020clg400-1 / Vivado 2026.1 button-only post-opt hook.
# Run: bound to STEPS.OPT_DESIGN.TCL.POST of impl_button_r22.
# Output: 64-bit hand-only OSD CDC and three-bit release Gray CDC constraints.
# Next: report_cdc, report_bus_skew, full setup/hold and DRC.
# AMD UG903 set_bus_skew Example Two / UG949 Constraints on Individual CDC Paths.
if {[get_property PART [current_design]] ne {xc7z020clg400-1}} {error {wrong admission target}}
if {[version -short] ne {2026.1}} {error {unverified Vivado version}}
source -notrace {E:/projects/fpga/voice-view-game/build/hosd/c0e/admission-r01/inherited_postopt_parent.tcl}
set ::osd_scope {c6v_i/input_osd_0/inst/impl/}
source -notrace {E:/projects/fpga/voice-view-game/subprojects/button_only/constraints/button_osd_cdc.tcl}
puts BUTTON_OSD_POSTOPT_CDC_BOUND_PASS
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
