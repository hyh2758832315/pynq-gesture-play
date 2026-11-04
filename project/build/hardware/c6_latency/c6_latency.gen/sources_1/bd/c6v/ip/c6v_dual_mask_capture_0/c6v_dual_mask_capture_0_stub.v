// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Fri Oct 30 22:07:10 2026
// Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_dual_mask_capture_0/c6v_dual_mask_capture_0_stub.v
// Design      : c6v_dual_mask_capture_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "c6v_dual_mask_capture_0,axis_rgb_capture_bd,{}" *) (* CORE_GENERATION_INFO = "c6v_dual_mask_capture_0,axis_rgb_capture_bd,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=axis_rgb_capture_bd,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,INPUT_WIDTH=1280,INPUT_HEIGHT=720,EPOCH_FRAMES=1,CONTINUOUS=1,SEQUENCE_FRAME_IDS=1,USE_FRAME_CREDITS=1}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* IP_DEFINITION_SOURCE = "module_ref" *) (* X_CORE_INFO = "axis_rgb_capture_bd,Vivado 2026.1" *) 
module c6v_dual_mask_capture_0(aclk, aresetn, s_axis_tdata, s_axis_tkeep, 
  s_axis_tvalid, s_axis_tready, s_axis_tuser, s_axis_tlast, cfg_frame_context, source_fault, 
  abort_requested, source_closed, closed_frame_count, frame_credit_ready, 
  frame_credit_request, m_rgb_tdata, m_rgb_tkeep, m_rgb_tvalid, m_rgb_tready, m_rgb_tuser, 
  m_rgb_tlast, m_packet_tdata, m_packet_tkeep, m_packet_tvalid, m_packet_tready, 
  m_packet_tlast, frame_fault, pipeline_drained)
/* synthesis syn_black_box black_box_pad_pin="aresetn,s_axis_tdata[23:0],s_axis_tkeep[2:0],s_axis_tvalid,s_axis_tready,s_axis_tuser,s_axis_tlast,cfg_frame_context[143:0],source_fault,abort_requested,source_closed,closed_frame_count[31:0],frame_credit_ready,frame_credit_request,m_rgb_tdata[23:0],m_rgb_tkeep[2:0],m_rgb_tvalid,m_rgb_tready,m_rgb_tuser,m_rgb_tlast,m_packet_tdata[31:0],m_packet_tkeep[3:0],m_packet_tvalid,m_packet_tready,m_packet_tlast,frame_fault,pipeline_drained" */
/* synthesis syn_force_seq_prim="aclk" */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF S_AXIS:M_RGB:M_PACKET, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input aclk /* synthesis syn_isclock = 1 */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TDATA" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS, TDATA_NUM_BYTES 3, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *) input [23:0]s_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TKEEP" *) input [2:0]s_axis_tkeep;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TVALID" *) input s_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TREADY" *) output s_axis_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TUSER" *) input s_axis_tuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TLAST" *) input s_axis_tlast;
  input [143:0]cfg_frame_context;
  input source_fault;
  input abort_requested;
  input source_closed;
  input [31:0]closed_frame_count;
  input frame_credit_ready;
  output frame_credit_request;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TDATA" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_RGB, TDATA_NUM_BYTES 3, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *) output [23:0]m_rgb_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TKEEP" *) output [2:0]m_rgb_tkeep;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TVALID" *) output m_rgb_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TREADY" *) input m_rgb_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TUSER" *) output m_rgb_tuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TLAST" *) output m_rgb_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TDATA" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_PACKET, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *) output [31:0]m_packet_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TKEEP" *) output [3:0]m_packet_tkeep;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TVALID" *) output m_packet_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TREADY" *) input m_packet_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TLAST" *) output m_packet_tlast;
  output frame_fault;
  output pipeline_drained;
endmodule
