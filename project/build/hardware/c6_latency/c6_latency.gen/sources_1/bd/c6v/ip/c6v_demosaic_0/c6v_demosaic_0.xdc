
#set_false_path -from [get_cells v_demosaic_CTRL_s_axi_U/int_HwReg_width_reg[*]]
#set_false_path -from [get_cells v_demosaic_CTRL_s_axi_U/int_HwReg_height_reg[*]]
#set_false_path -from [get_cells v_demosaic_CTRL_s_axi_U/int_HwReg_bayer_phase_reg[*]]

set_false_path -from [get_cells CTRL_s_axi_U/int_width_reg[*]]
set_false_path -from [get_cells CTRL_s_axi_U/int_height_reg[*]]
set_false_path -from [get_cells CTRL_s_axi_U/int_bayer_phase_reg[*]]



create_waiver -type CDC -id {CDC-11} -user "proc_sys_reset" -desc "Timing uncritical paths" -tags "201680" -scope -internal \
    -to [get_pins -quiet -filter REF_PIN_NAME=~*D -of_objects [get_cells -hierarchical -filter {NAME =~ */M_AXI[*].mi_async.m_cdc_inst/gen_read.rdata_async_cdc/syncstages_ff_reg[0][1]/D}]]


