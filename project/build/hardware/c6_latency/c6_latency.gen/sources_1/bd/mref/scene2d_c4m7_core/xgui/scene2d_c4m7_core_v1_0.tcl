# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BLIT_PIXEL_PAIR_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BLIT_PIXEL_PIPELINE_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CLEAR_FILL_PIXEL_PAIR_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "H_ACTIVE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "H_BACK" -parent ${Page_0}
  ipgui::add_param $IPINST -name "H_FRONT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "H_SYNC" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OUTPUT_SCALE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TILE_DESCRIPTOR_CACHE_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TILE_PIXEL_PAIR_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TILE_PIXEL_PIPELINE_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "UPLOAD_RENDER_OVERLAP_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "V_ACTIVE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "V_BACK" -parent ${Page_0}
  ipgui::add_param $IPINST -name "V_FRONT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "V_SYNC" -parent ${Page_0}


}

proc update_PARAM_VALUE.BLIT_PIXEL_PAIR_ENABLE { PARAM_VALUE.BLIT_PIXEL_PAIR_ENABLE } {
	# Procedure called to update BLIT_PIXEL_PAIR_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BLIT_PIXEL_PAIR_ENABLE { PARAM_VALUE.BLIT_PIXEL_PAIR_ENABLE } {
	# Procedure called to validate BLIT_PIXEL_PAIR_ENABLE
	return true
}

proc update_PARAM_VALUE.BLIT_PIXEL_PIPELINE_ENABLE { PARAM_VALUE.BLIT_PIXEL_PIPELINE_ENABLE } {
	# Procedure called to update BLIT_PIXEL_PIPELINE_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BLIT_PIXEL_PIPELINE_ENABLE { PARAM_VALUE.BLIT_PIXEL_PIPELINE_ENABLE } {
	# Procedure called to validate BLIT_PIXEL_PIPELINE_ENABLE
	return true
}

proc update_PARAM_VALUE.CLEAR_FILL_PIXEL_PAIR_ENABLE { PARAM_VALUE.CLEAR_FILL_PIXEL_PAIR_ENABLE } {
	# Procedure called to update CLEAR_FILL_PIXEL_PAIR_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLEAR_FILL_PIXEL_PAIR_ENABLE { PARAM_VALUE.CLEAR_FILL_PIXEL_PAIR_ENABLE } {
	# Procedure called to validate CLEAR_FILL_PIXEL_PAIR_ENABLE
	return true
}

proc update_PARAM_VALUE.H_ACTIVE { PARAM_VALUE.H_ACTIVE } {
	# Procedure called to update H_ACTIVE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.H_ACTIVE { PARAM_VALUE.H_ACTIVE } {
	# Procedure called to validate H_ACTIVE
	return true
}

proc update_PARAM_VALUE.H_BACK { PARAM_VALUE.H_BACK } {
	# Procedure called to update H_BACK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.H_BACK { PARAM_VALUE.H_BACK } {
	# Procedure called to validate H_BACK
	return true
}

proc update_PARAM_VALUE.H_FRONT { PARAM_VALUE.H_FRONT } {
	# Procedure called to update H_FRONT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.H_FRONT { PARAM_VALUE.H_FRONT } {
	# Procedure called to validate H_FRONT
	return true
}

proc update_PARAM_VALUE.H_SYNC { PARAM_VALUE.H_SYNC } {
	# Procedure called to update H_SYNC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.H_SYNC { PARAM_VALUE.H_SYNC } {
	# Procedure called to validate H_SYNC
	return true
}

proc update_PARAM_VALUE.OUTPUT_SCALE { PARAM_VALUE.OUTPUT_SCALE } {
	# Procedure called to update OUTPUT_SCALE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OUTPUT_SCALE { PARAM_VALUE.OUTPUT_SCALE } {
	# Procedure called to validate OUTPUT_SCALE
	return true
}

proc update_PARAM_VALUE.TILE_DESCRIPTOR_CACHE_ENABLE { PARAM_VALUE.TILE_DESCRIPTOR_CACHE_ENABLE } {
	# Procedure called to update TILE_DESCRIPTOR_CACHE_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TILE_DESCRIPTOR_CACHE_ENABLE { PARAM_VALUE.TILE_DESCRIPTOR_CACHE_ENABLE } {
	# Procedure called to validate TILE_DESCRIPTOR_CACHE_ENABLE
	return true
}

proc update_PARAM_VALUE.TILE_PIXEL_PAIR_ENABLE { PARAM_VALUE.TILE_PIXEL_PAIR_ENABLE } {
	# Procedure called to update TILE_PIXEL_PAIR_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TILE_PIXEL_PAIR_ENABLE { PARAM_VALUE.TILE_PIXEL_PAIR_ENABLE } {
	# Procedure called to validate TILE_PIXEL_PAIR_ENABLE
	return true
}

proc update_PARAM_VALUE.TILE_PIXEL_PIPELINE_ENABLE { PARAM_VALUE.TILE_PIXEL_PIPELINE_ENABLE } {
	# Procedure called to update TILE_PIXEL_PIPELINE_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TILE_PIXEL_PIPELINE_ENABLE { PARAM_VALUE.TILE_PIXEL_PIPELINE_ENABLE } {
	# Procedure called to validate TILE_PIXEL_PIPELINE_ENABLE
	return true
}

proc update_PARAM_VALUE.UPLOAD_RENDER_OVERLAP_ENABLE { PARAM_VALUE.UPLOAD_RENDER_OVERLAP_ENABLE } {
	# Procedure called to update UPLOAD_RENDER_OVERLAP_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UPLOAD_RENDER_OVERLAP_ENABLE { PARAM_VALUE.UPLOAD_RENDER_OVERLAP_ENABLE } {
	# Procedure called to validate UPLOAD_RENDER_OVERLAP_ENABLE
	return true
}

proc update_PARAM_VALUE.V_ACTIVE { PARAM_VALUE.V_ACTIVE } {
	# Procedure called to update V_ACTIVE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.V_ACTIVE { PARAM_VALUE.V_ACTIVE } {
	# Procedure called to validate V_ACTIVE
	return true
}

proc update_PARAM_VALUE.V_BACK { PARAM_VALUE.V_BACK } {
	# Procedure called to update V_BACK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.V_BACK { PARAM_VALUE.V_BACK } {
	# Procedure called to validate V_BACK
	return true
}

proc update_PARAM_VALUE.V_FRONT { PARAM_VALUE.V_FRONT } {
	# Procedure called to update V_FRONT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.V_FRONT { PARAM_VALUE.V_FRONT } {
	# Procedure called to validate V_FRONT
	return true
}

proc update_PARAM_VALUE.V_SYNC { PARAM_VALUE.V_SYNC } {
	# Procedure called to update V_SYNC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.V_SYNC { PARAM_VALUE.V_SYNC } {
	# Procedure called to validate V_SYNC
	return true
}


proc update_MODELPARAM_VALUE.H_ACTIVE { MODELPARAM_VALUE.H_ACTIVE PARAM_VALUE.H_ACTIVE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.H_ACTIVE}] ${MODELPARAM_VALUE.H_ACTIVE}
}

proc update_MODELPARAM_VALUE.H_FRONT { MODELPARAM_VALUE.H_FRONT PARAM_VALUE.H_FRONT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.H_FRONT}] ${MODELPARAM_VALUE.H_FRONT}
}

proc update_MODELPARAM_VALUE.H_SYNC { MODELPARAM_VALUE.H_SYNC PARAM_VALUE.H_SYNC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.H_SYNC}] ${MODELPARAM_VALUE.H_SYNC}
}

proc update_MODELPARAM_VALUE.H_BACK { MODELPARAM_VALUE.H_BACK PARAM_VALUE.H_BACK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.H_BACK}] ${MODELPARAM_VALUE.H_BACK}
}

proc update_MODELPARAM_VALUE.V_ACTIVE { MODELPARAM_VALUE.V_ACTIVE PARAM_VALUE.V_ACTIVE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.V_ACTIVE}] ${MODELPARAM_VALUE.V_ACTIVE}
}

proc update_MODELPARAM_VALUE.V_FRONT { MODELPARAM_VALUE.V_FRONT PARAM_VALUE.V_FRONT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.V_FRONT}] ${MODELPARAM_VALUE.V_FRONT}
}

proc update_MODELPARAM_VALUE.V_SYNC { MODELPARAM_VALUE.V_SYNC PARAM_VALUE.V_SYNC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.V_SYNC}] ${MODELPARAM_VALUE.V_SYNC}
}

proc update_MODELPARAM_VALUE.V_BACK { MODELPARAM_VALUE.V_BACK PARAM_VALUE.V_BACK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.V_BACK}] ${MODELPARAM_VALUE.V_BACK}
}

proc update_MODELPARAM_VALUE.OUTPUT_SCALE { MODELPARAM_VALUE.OUTPUT_SCALE PARAM_VALUE.OUTPUT_SCALE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OUTPUT_SCALE}] ${MODELPARAM_VALUE.OUTPUT_SCALE}
}

proc update_MODELPARAM_VALUE.TILE_DESCRIPTOR_CACHE_ENABLE { MODELPARAM_VALUE.TILE_DESCRIPTOR_CACHE_ENABLE PARAM_VALUE.TILE_DESCRIPTOR_CACHE_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TILE_DESCRIPTOR_CACHE_ENABLE}] ${MODELPARAM_VALUE.TILE_DESCRIPTOR_CACHE_ENABLE}
}

proc update_MODELPARAM_VALUE.BLIT_PIXEL_PIPELINE_ENABLE { MODELPARAM_VALUE.BLIT_PIXEL_PIPELINE_ENABLE PARAM_VALUE.BLIT_PIXEL_PIPELINE_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BLIT_PIXEL_PIPELINE_ENABLE}] ${MODELPARAM_VALUE.BLIT_PIXEL_PIPELINE_ENABLE}
}

proc update_MODELPARAM_VALUE.TILE_PIXEL_PIPELINE_ENABLE { MODELPARAM_VALUE.TILE_PIXEL_PIPELINE_ENABLE PARAM_VALUE.TILE_PIXEL_PIPELINE_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TILE_PIXEL_PIPELINE_ENABLE}] ${MODELPARAM_VALUE.TILE_PIXEL_PIPELINE_ENABLE}
}

proc update_MODELPARAM_VALUE.TILE_PIXEL_PAIR_ENABLE { MODELPARAM_VALUE.TILE_PIXEL_PAIR_ENABLE PARAM_VALUE.TILE_PIXEL_PAIR_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TILE_PIXEL_PAIR_ENABLE}] ${MODELPARAM_VALUE.TILE_PIXEL_PAIR_ENABLE}
}

proc update_MODELPARAM_VALUE.BLIT_PIXEL_PAIR_ENABLE { MODELPARAM_VALUE.BLIT_PIXEL_PAIR_ENABLE PARAM_VALUE.BLIT_PIXEL_PAIR_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BLIT_PIXEL_PAIR_ENABLE}] ${MODELPARAM_VALUE.BLIT_PIXEL_PAIR_ENABLE}
}

proc update_MODELPARAM_VALUE.CLEAR_FILL_PIXEL_PAIR_ENABLE { MODELPARAM_VALUE.CLEAR_FILL_PIXEL_PAIR_ENABLE PARAM_VALUE.CLEAR_FILL_PIXEL_PAIR_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLEAR_FILL_PIXEL_PAIR_ENABLE}] ${MODELPARAM_VALUE.CLEAR_FILL_PIXEL_PAIR_ENABLE}
}

proc update_MODELPARAM_VALUE.UPLOAD_RENDER_OVERLAP_ENABLE { MODELPARAM_VALUE.UPLOAD_RENDER_OVERLAP_ENABLE PARAM_VALUE.UPLOAD_RENDER_OVERLAP_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UPLOAD_RENDER_OVERLAP_ENABLE}] ${MODELPARAM_VALUE.UPLOAD_RENDER_OVERLAP_ENABLE}
}

