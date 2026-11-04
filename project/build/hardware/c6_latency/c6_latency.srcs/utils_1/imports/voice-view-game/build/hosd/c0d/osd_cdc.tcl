# Source AFTER synthesis; default top is this isolated OOC design. For integration
# set ::osd_scope to the exact instance hierarchy ending in '/' before sourcing.
# Do not mark whole clock groups asynchronous: that overrides the payload bound.
if {![info exists ::osd_scope]} {set ::osd_scope {}}
set osd_src [get_cells -hier -regexp "${::osd_scope}ctrl/mailbox_reg\\\[.*\\\]"]
set osd_dst [get_cells -hier -regexp "${::osd_scope}ctrl/pending_cfg_reg\\\[.*\\\]"]
set osd_sync_d [get_pins -hier -regexp "${::osd_scope}ctrl/(req_meta_reg|ack_meta_reg)/D"]
# Reserved/unused payload bits are removed by synthesis; every surviving source
# bit must retain its corresponding destination. Refuse an empty/wrong scope.
if {[llength $osd_src] < 128 || [llength $osd_dst] != [llength $osd_src] || [llength $osd_sync_d] != 2} {
    error "OSD CDC endpoint identity/count mismatch: [llength $osd_src]/[llength $osd_dst]/[llength $osd_sync_d]"
}
set_max_delay -datapath_only 10.000 -from $osd_src -to $osd_dst
set_bus_skew 10.000 -from $osd_src -to $osd_dst
set_false_path -to $osd_sync_d
# Reset assertion endpoints only; synchronized release remains timed.
set osd_clr [get_pins -hier -regexp "${::osd_scope}(ca|cp|pa|pp)_release_reg\\\[.*\\\]/CLR"]
if {[llength $osd_clr] != 8} {error "OSD reset endpoints missing: [llength $osd_clr]"}
set_false_path -to $osd_clr
