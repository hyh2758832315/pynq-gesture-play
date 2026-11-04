# Full-design OSD mailbox constraints, implementation only (not IP OOC).
# Payload is frozen until ack; request/ack each cross 2FF. Do not false-path
# whole clock groups: that would override this bundled-data delay bound.
set osd_mailbox [get_cells -hier -filter {NAME =~ *hand_osd*/ctrl/mailbox_reg*}]
set osd_video_cfg [get_cells -hier -filter {NAME =~ *hand_osd*/ctrl/video_cfg_reg*}]
set osd_toggle_d [get_pins -hier -filter {NAME =~ *hand_osd*/ctrl/req_meta_reg/D || NAME =~ *hand_osd*/ctrl/ack_meta_reg/D}]
set_max_delay -datapath_only 13.468 -from $osd_mailbox -to $osd_video_cfg
set_false_path -to $osd_toggle_d
# Only asynchronous assertion pins of the four independent reset synchronizers.
set osd_reset_clr [get_pins -hier -filter {NAME =~ *hand_osd*/control_*_release_reg*/CLR || NAME =~ *hand_osd*/video_*_release_reg*/CLR}]
set_false_path -to $osd_reset_clr
