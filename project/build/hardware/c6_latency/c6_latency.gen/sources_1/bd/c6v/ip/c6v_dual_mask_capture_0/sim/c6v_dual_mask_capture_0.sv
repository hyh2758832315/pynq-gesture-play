// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:axis_rgb_capture_bd:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module c6v_dual_mask_capture_0 (
  aclk,
  aresetn,
  s_axis_tdata,
  s_axis_tkeep,
  s_axis_tvalid,
  s_axis_tready,
  s_axis_tuser,
  s_axis_tlast,
  cfg_frame_context,
  source_fault,
  abort_requested,
  source_closed,
  closed_frame_count,
  frame_credit_ready,
  frame_credit_request,
  m_rgb_tdata,
  m_rgb_tkeep,
  m_rgb_tvalid,
  m_rgb_tready,
  m_rgb_tuser,
  m_rgb_tlast,
  m_packet_tdata,
  m_packet_tkeep,
  m_packet_tvalid,
  m_packet_tready,
  m_packet_tlast,
  frame_fault,
  pipeline_drained
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF S_AXIS:M_RGB:M_PACKET, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
input wire aclk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
input wire aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TDATA" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS, TDATA_NUM_BYTES 3, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *)
input wire [23 : 0] s_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TKEEP" *)
input wire [2 : 0] s_axis_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TVALID" *)
input wire s_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TREADY" *)
output wire s_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TUSER" *)
input wire s_axis_tuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TLAST" *)
input wire s_axis_tlast;
input wire [143 : 0] cfg_frame_context;
input wire source_fault;
input wire abort_requested;
input wire source_closed;
input wire [31 : 0] closed_frame_count;
input wire frame_credit_ready;
output wire frame_credit_request;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TDATA" *)
(* X_INTERFACE_MODE = "master" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_RGB, TDATA_NUM_BYTES 3, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *)
output wire [23 : 0] m_rgb_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TKEEP" *)
output wire [2 : 0] m_rgb_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TVALID" *)
output wire m_rgb_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TREADY" *)
input wire m_rgb_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TUSER" *)
output wire m_rgb_tuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TLAST" *)
output wire m_rgb_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TDATA" *)
(* X_INTERFACE_MODE = "master" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_PACKET, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *)
output wire [31 : 0] m_packet_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TKEEP" *)
output wire [3 : 0] m_packet_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TVALID" *)
output wire m_packet_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TREADY" *)
input wire m_packet_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TLAST" *)
output wire m_packet_tlast;
output wire frame_fault;
output wire pipeline_drained;

  axis_rgb_capture_bd #(
    .INPUT_WIDTH(1280),
    .INPUT_HEIGHT(720),
    .EPOCH_FRAMES(1),
    .CONTINUOUS(1),
    .SEQUENCE_FRAME_IDS(1),
    .USE_FRAME_CREDITS(1)
  ) inst (
    .aclk(aclk),
    .aresetn(aresetn),
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tkeep(s_axis_tkeep),
    .s_axis_tvalid(s_axis_tvalid),
    .s_axis_tready(s_axis_tready),
    .s_axis_tuser(s_axis_tuser),
    .s_axis_tlast(s_axis_tlast),
    .cfg_frame_context(cfg_frame_context),
    .source_fault(source_fault),
    .abort_requested(abort_requested),
    .source_closed(source_closed),
    .closed_frame_count(closed_frame_count),
    .frame_credit_ready(frame_credit_ready),
    .frame_credit_request(frame_credit_request),
    .m_rgb_tdata(m_rgb_tdata),
    .m_rgb_tkeep(m_rgb_tkeep),
    .m_rgb_tvalid(m_rgb_tvalid),
    .m_rgb_tready(m_rgb_tready),
    .m_rgb_tuser(m_rgb_tuser),
    .m_rgb_tlast(m_rgb_tlast),
    .m_packet_tdata(m_packet_tdata),
    .m_packet_tkeep(m_packet_tkeep),
    .m_packet_tvalid(m_packet_tvalid),
    .m_packet_tready(m_packet_tready),
    .m_packet_tlast(m_packet_tlast),
    .frame_fault(frame_fault),
    .pipeline_drained(pipeline_drained)
  );
endmodule
