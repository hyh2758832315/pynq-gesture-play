# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CONTINUOUS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_BYTES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PACKET_BYTES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RGB_BYTES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SG_STATUS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TRACK_FRAME_COMPLETIONS" -parent ${Page_0}


}

proc update_PARAM_VALUE.CONTINUOUS { PARAM_VALUE.CONTINUOUS } {
	# Procedure called to update CONTINUOUS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CONTINUOUS { PARAM_VALUE.CONTINUOUS } {
	# Procedure called to validate CONTINUOUS
	return true
}

proc update_PARAM_VALUE.DATA_BYTES { PARAM_VALUE.DATA_BYTES } {
	# Procedure called to update DATA_BYTES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_BYTES { PARAM_VALUE.DATA_BYTES } {
	# Procedure called to validate DATA_BYTES
	return true
}

proc update_PARAM_VALUE.PACKET_BYTES { PARAM_VALUE.PACKET_BYTES } {
	# Procedure called to update PACKET_BYTES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PACKET_BYTES { PARAM_VALUE.PACKET_BYTES } {
	# Procedure called to validate PACKET_BYTES
	return true
}

proc update_PARAM_VALUE.RGB_BYTES { PARAM_VALUE.RGB_BYTES } {
	# Procedure called to update RGB_BYTES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RGB_BYTES { PARAM_VALUE.RGB_BYTES } {
	# Procedure called to validate RGB_BYTES
	return true
}

proc update_PARAM_VALUE.SG_STATUS { PARAM_VALUE.SG_STATUS } {
	# Procedure called to update SG_STATUS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SG_STATUS { PARAM_VALUE.SG_STATUS } {
	# Procedure called to validate SG_STATUS
	return true
}

proc update_PARAM_VALUE.TRACK_FRAME_COMPLETIONS { PARAM_VALUE.TRACK_FRAME_COMPLETIONS } {
	# Procedure called to update TRACK_FRAME_COMPLETIONS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRACK_FRAME_COMPLETIONS { PARAM_VALUE.TRACK_FRAME_COMPLETIONS } {
	# Procedure called to validate TRACK_FRAME_COMPLETIONS
	return true
}


proc update_MODELPARAM_VALUE.DATA_BYTES { MODELPARAM_VALUE.DATA_BYTES PARAM_VALUE.DATA_BYTES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_BYTES}] ${MODELPARAM_VALUE.DATA_BYTES}
}

proc update_MODELPARAM_VALUE.RGB_BYTES { MODELPARAM_VALUE.RGB_BYTES PARAM_VALUE.RGB_BYTES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RGB_BYTES}] ${MODELPARAM_VALUE.RGB_BYTES}
}

proc update_MODELPARAM_VALUE.PACKET_BYTES { MODELPARAM_VALUE.PACKET_BYTES PARAM_VALUE.PACKET_BYTES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PACKET_BYTES}] ${MODELPARAM_VALUE.PACKET_BYTES}
}

proc update_MODELPARAM_VALUE.CONTINUOUS { MODELPARAM_VALUE.CONTINUOUS PARAM_VALUE.CONTINUOUS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CONTINUOUS}] ${MODELPARAM_VALUE.CONTINUOUS}
}

proc update_MODELPARAM_VALUE.TRACK_FRAME_COMPLETIONS { MODELPARAM_VALUE.TRACK_FRAME_COMPLETIONS PARAM_VALUE.TRACK_FRAME_COMPLETIONS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRACK_FRAME_COMPLETIONS}] ${MODELPARAM_VALUE.TRACK_FRAME_COMPLETIONS}
}

proc update_MODELPARAM_VALUE.SG_STATUS { MODELPARAM_VALUE.SG_STATUS PARAM_VALUE.SG_STATUS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SG_STATUS}] ${MODELPARAM_VALUE.SG_STATUS}
}

