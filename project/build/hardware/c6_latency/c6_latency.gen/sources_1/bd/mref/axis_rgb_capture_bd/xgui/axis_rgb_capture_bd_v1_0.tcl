# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CONTINUOUS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "EPOCH_FRAMES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INPUT_HEIGHT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INPUT_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SEQUENCE_FRAME_IDS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "USE_FRAME_CREDITS" -parent ${Page_0}


}

proc update_PARAM_VALUE.CONTINUOUS { PARAM_VALUE.CONTINUOUS } {
	# Procedure called to update CONTINUOUS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CONTINUOUS { PARAM_VALUE.CONTINUOUS } {
	# Procedure called to validate CONTINUOUS
	return true
}

proc update_PARAM_VALUE.EPOCH_FRAMES { PARAM_VALUE.EPOCH_FRAMES } {
	# Procedure called to update EPOCH_FRAMES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EPOCH_FRAMES { PARAM_VALUE.EPOCH_FRAMES } {
	# Procedure called to validate EPOCH_FRAMES
	return true
}

proc update_PARAM_VALUE.INPUT_HEIGHT { PARAM_VALUE.INPUT_HEIGHT } {
	# Procedure called to update INPUT_HEIGHT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INPUT_HEIGHT { PARAM_VALUE.INPUT_HEIGHT } {
	# Procedure called to validate INPUT_HEIGHT
	return true
}

proc update_PARAM_VALUE.INPUT_WIDTH { PARAM_VALUE.INPUT_WIDTH } {
	# Procedure called to update INPUT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INPUT_WIDTH { PARAM_VALUE.INPUT_WIDTH } {
	# Procedure called to validate INPUT_WIDTH
	return true
}

proc update_PARAM_VALUE.SEQUENCE_FRAME_IDS { PARAM_VALUE.SEQUENCE_FRAME_IDS } {
	# Procedure called to update SEQUENCE_FRAME_IDS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SEQUENCE_FRAME_IDS { PARAM_VALUE.SEQUENCE_FRAME_IDS } {
	# Procedure called to validate SEQUENCE_FRAME_IDS
	return true
}

proc update_PARAM_VALUE.USE_FRAME_CREDITS { PARAM_VALUE.USE_FRAME_CREDITS } {
	# Procedure called to update USE_FRAME_CREDITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.USE_FRAME_CREDITS { PARAM_VALUE.USE_FRAME_CREDITS } {
	# Procedure called to validate USE_FRAME_CREDITS
	return true
}


proc update_MODELPARAM_VALUE.INPUT_WIDTH { MODELPARAM_VALUE.INPUT_WIDTH PARAM_VALUE.INPUT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INPUT_WIDTH}] ${MODELPARAM_VALUE.INPUT_WIDTH}
}

proc update_MODELPARAM_VALUE.INPUT_HEIGHT { MODELPARAM_VALUE.INPUT_HEIGHT PARAM_VALUE.INPUT_HEIGHT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INPUT_HEIGHT}] ${MODELPARAM_VALUE.INPUT_HEIGHT}
}

proc update_MODELPARAM_VALUE.EPOCH_FRAMES { MODELPARAM_VALUE.EPOCH_FRAMES PARAM_VALUE.EPOCH_FRAMES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EPOCH_FRAMES}] ${MODELPARAM_VALUE.EPOCH_FRAMES}
}

proc update_MODELPARAM_VALUE.CONTINUOUS { MODELPARAM_VALUE.CONTINUOUS PARAM_VALUE.CONTINUOUS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CONTINUOUS}] ${MODELPARAM_VALUE.CONTINUOUS}
}

proc update_MODELPARAM_VALUE.SEQUENCE_FRAME_IDS { MODELPARAM_VALUE.SEQUENCE_FRAME_IDS PARAM_VALUE.SEQUENCE_FRAME_IDS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SEQUENCE_FRAME_IDS}] ${MODELPARAM_VALUE.SEQUENCE_FRAME_IDS}
}

proc update_MODELPARAM_VALUE.USE_FRAME_CREDITS { MODELPARAM_VALUE.USE_FRAME_CREDITS PARAM_VALUE.USE_FRAME_CREDITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.USE_FRAME_CREDITS}] ${MODELPARAM_VALUE.USE_FRAME_CREDITS}
}

