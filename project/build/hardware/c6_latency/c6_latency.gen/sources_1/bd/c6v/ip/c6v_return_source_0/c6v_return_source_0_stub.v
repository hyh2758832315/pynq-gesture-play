// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Fri Oct 30 22:03:43 2026
// Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_return_source_0/c6v_return_source_0_stub.v
// Design      : c6v_return_source_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "c6v_return_source_0,scene2d_return_source,{}" *) (* CORE_GENERATION_INFO = "c6v_return_source_0,scene2d_return_source,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=scene2d_return_source,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* IP_DEFINITION_SOURCE = "module_ref" *) (* X_CORE_INFO = "scene2d_return_source,Vivado 2026.1" *) 
module c6v_return_source_0(aclk, aresetn, start, requested_byte_count, seed, 
  m_axis_tdata, m_axis_tkeep, m_axis_tlast, m_axis_tvalid, m_axis_tready, busy, 
  completed_byte_count, completed_packet_count, rejected_start_count)
/* synthesis syn_black_box black_box_pad_pin="aresetn,start,requested_byte_count[31:0],seed[31:0],m_axis_tdata[63:0],m_axis_tkeep[7:0],m_axis_tlast,m_axis_tvalid,m_axis_tready,busy,completed_byte_count[31:0],completed_packet_count[31:0],rejected_start_count[31:0]" */
/* synthesis syn_force_seq_prim="aclk" */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF M_AXIS, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input aclk /* synthesis syn_isclock = 1 */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input aresetn;
  input start;
  input [31:0]requested_byte_count;
  input [31:0]seed;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TDATA" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS, TDATA_NUM_BYTES 8, HAS_TKEEP 1, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 0, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *) output [63:0]m_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TKEEP" *) output [7:0]m_axis_tkeep;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TLAST" *) output m_axis_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TVALID" *) output m_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TREADY" *) input m_axis_tready;
  output busy;
  output [31:0]completed_byte_count;
  output [31:0]completed_packet_count;
  output [31:0]rejected_start_count;
endmodule
