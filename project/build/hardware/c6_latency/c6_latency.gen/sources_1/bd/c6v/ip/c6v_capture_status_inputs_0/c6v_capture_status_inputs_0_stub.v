// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Fri Oct 30 22:06:10 2026
// Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_status_inputs_0/c6v_capture_status_inputs_0_stub.v
// Design      : c6v_capture_status_inputs_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "c6v_capture_status_inputs_0,vision_capture_status_inputs,{}" *) (* CORE_GENERATION_INFO = "c6v_capture_status_inputs_0,vision_capture_status_inputs,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=vision_capture_status_inputs,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* IP_DEFINITION_SOURCE = "module_ref" *) (* X_CORE_INFO = "vision_capture_status_inputs,Vivado 2026.1" *) 
module c6v_capture_status_inputs_0(frame_context, source_fault_status, 
  capture_fault, capture_epoch, fault_causes)
/* synthesis syn_black_box black_box_pad_pin="frame_context[143:0],source_fault_status[1:0],capture_fault,capture_epoch[31:0],fault_causes[2:0]" */;
  input [143:0]frame_context;
  input [1:0]source_fault_status;
  input capture_fault;
  output [31:0]capture_epoch;
  output [2:0]fault_causes;
endmodule
