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


// IP VLNV: xilinx.com:module_ref:scene2d_c4m7_core:1.0
// IP Revision: 1

(* X_CORE_INFO = "scene2d_c4m7_core,Vivado 2026.1" *)
(* CHECK_LICENSE_TYPE = "c6v_core_0,scene2d_c4m7_core,{}" *)
(* CORE_GENERATION_INFO = "c6v_core_0,scene2d_c4m7_core,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=scene2d_c4m7_core,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,H_ACTIVE=1280,H_FRONT=110,H_SYNC=40,H_BACK=220,V_ACTIVE=720,V_FRONT=5,V_SYNC=5,V_BACK=20,OUTPUT_SCALE=4,TILE_DESCRIPTOR_CACHE_ENABLE=0,BLIT_PIXEL_PIPELINE_ENABLE=0,TILE_PIXEL_PIPELINE_ENABLE=0,TILE_PIXEL_PAIR_ENABLE=0,BLIT_PIXEL_PAIR_ENABLE=0,CLEAR_FILL_PIXEL_PAIR_ENABLE=0,UPLOAD_RENDER_OVERLA\
P_ENABLE=0}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module c6v_core_0 (
  aclk,
  aresetn,
  clk_pixel,
  resetn_pixel,
  s_axis_tdata,
  s_axis_tkeep,
  s_axis_tlast,
  s_axis_tvalid,
  s_axis_tready,
  debug_command_read_address,
  debug_command_read_data_low,
  debug_command_read_data_high,
  upload_crc32,
  upload_byte_count,
  upload_packet_count,
  accepted_packet_count,
  rejected_packet_count,
  accepted_seq,
  accepted_status,
  upload_error_flags,
  render_completed_seq,
  render_completed_count,
  render_write_count,
  render_trace_crc32,
  render_cycles,
  render_maximum_cycles,
  render_status,
  present_completed_seq,
  present_completed_count,
  framebuffer_status,
  overlap_release_toggle,
  overlap_status,
  router_dropped_packet_count,
  unsupported_packet_count,
  palette_accepted_packet_count,
  palette_rejected_packet_count,
  palette_generation,
  palette_error_flags,
  palette_status,
  asset_accepted_packet_count,
  asset_rejected_packet_count,
  asset_generation,
  asset_error_flags,
  asset_status,
  tilemap_accepted_packet_count,
  tilemap_rejected_packet_count,
  tilemap_generation,
  tilemap_error_flags,
  tilemap_status,
  vid_data,
  vid_de,
  vid_hsync,
  vid_vsync
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF s_axis, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
input wire aclk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
input wire aresetn;
input wire clk_pixel;
input wire resetn_pixel;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TDATA" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axis, TDATA_NUM_BYTES 8, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *)
input wire [63 : 0] s_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TKEEP" *)
input wire [7 : 0] s_axis_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TLAST" *)
input wire s_axis_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TVALID" *)
input wire s_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TREADY" *)
output wire s_axis_tready;
input wire [8 : 0] debug_command_read_address;
output wire [31 : 0] debug_command_read_data_low;
output wire [31 : 0] debug_command_read_data_high;
output wire [31 : 0] upload_crc32;
output wire [31 : 0] upload_byte_count;
output wire [31 : 0] upload_packet_count;
output wire [31 : 0] accepted_packet_count;
output wire [31 : 0] rejected_packet_count;
output wire [31 : 0] accepted_seq;
output wire [31 : 0] accepted_status;
output wire [5 : 0] upload_error_flags;
output wire [31 : 0] render_completed_seq;
output wire [31 : 0] render_completed_count;
output wire [31 : 0] render_write_count;
output wire [31 : 0] render_trace_crc32;
output wire [31 : 0] render_cycles;
output wire [31 : 0] render_maximum_cycles;
output wire [31 : 0] render_status;
output wire [31 : 0] present_completed_seq;
output wire [31 : 0] present_completed_count;
output wire [31 : 0] framebuffer_status;
input wire overlap_release_toggle;
output wire [31 : 0] overlap_status;
output wire [31 : 0] router_dropped_packet_count;
output wire [31 : 0] unsupported_packet_count;
output wire [31 : 0] palette_accepted_packet_count;
output wire [31 : 0] palette_rejected_packet_count;
output wire [31 : 0] palette_generation;
output wire [8 : 0] palette_error_flags;
output wire [31 : 0] palette_status;
output wire [31 : 0] asset_accepted_packet_count;
output wire [31 : 0] asset_rejected_packet_count;
output wire [31 : 0] asset_generation;
output wire [8 : 0] asset_error_flags;
output wire [31 : 0] asset_status;
output wire [31 : 0] tilemap_accepted_packet_count;
output wire [31 : 0] tilemap_rejected_packet_count;
output wire [31 : 0] tilemap_generation;
output wire [8 : 0] tilemap_error_flags;
output wire [31 : 0] tilemap_status;
output wire [23 : 0] vid_data;
output wire vid_de;
output wire vid_hsync;
output wire vid_vsync;

  scene2d_c4m7_core #(
    .H_ACTIVE(1280),
    .H_FRONT(110),
    .H_SYNC(40),
    .H_BACK(220),
    .V_ACTIVE(720),
    .V_FRONT(5),
    .V_SYNC(5),
    .V_BACK(20),
    .OUTPUT_SCALE(4),
    .TILE_DESCRIPTOR_CACHE_ENABLE(1'B0),
    .BLIT_PIXEL_PIPELINE_ENABLE(1'B0),
    .TILE_PIXEL_PIPELINE_ENABLE(1'B0),
    .TILE_PIXEL_PAIR_ENABLE(1'B0),
    .BLIT_PIXEL_PAIR_ENABLE(1'B0),
    .CLEAR_FILL_PIXEL_PAIR_ENABLE(1'B0),
    .UPLOAD_RENDER_OVERLAP_ENABLE(1'B0)
  ) inst (
    .aclk(aclk),
    .aresetn(aresetn),
    .clk_pixel(clk_pixel),
    .resetn_pixel(resetn_pixel),
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tkeep(s_axis_tkeep),
    .s_axis_tlast(s_axis_tlast),
    .s_axis_tvalid(s_axis_tvalid),
    .s_axis_tready(s_axis_tready),
    .debug_command_read_address(debug_command_read_address),
    .debug_command_read_data_low(debug_command_read_data_low),
    .debug_command_read_data_high(debug_command_read_data_high),
    .upload_crc32(upload_crc32),
    .upload_byte_count(upload_byte_count),
    .upload_packet_count(upload_packet_count),
    .accepted_packet_count(accepted_packet_count),
    .rejected_packet_count(rejected_packet_count),
    .accepted_seq(accepted_seq),
    .accepted_status(accepted_status),
    .upload_error_flags(upload_error_flags),
    .render_completed_seq(render_completed_seq),
    .render_completed_count(render_completed_count),
    .render_write_count(render_write_count),
    .render_trace_crc32(render_trace_crc32),
    .render_cycles(render_cycles),
    .render_maximum_cycles(render_maximum_cycles),
    .render_status(render_status),
    .present_completed_seq(present_completed_seq),
    .present_completed_count(present_completed_count),
    .framebuffer_status(framebuffer_status),
    .overlap_release_toggle(overlap_release_toggle),
    .overlap_status(overlap_status),
    .router_dropped_packet_count(router_dropped_packet_count),
    .unsupported_packet_count(unsupported_packet_count),
    .palette_accepted_packet_count(palette_accepted_packet_count),
    .palette_rejected_packet_count(palette_rejected_packet_count),
    .palette_generation(palette_generation),
    .palette_error_flags(palette_error_flags),
    .palette_status(palette_status),
    .asset_accepted_packet_count(asset_accepted_packet_count),
    .asset_rejected_packet_count(asset_rejected_packet_count),
    .asset_generation(asset_generation),
    .asset_error_flags(asset_error_flags),
    .asset_status(asset_status),
    .tilemap_accepted_packet_count(tilemap_accepted_packet_count),
    .tilemap_rejected_packet_count(tilemap_rejected_packet_count),
    .tilemap_generation(tilemap_generation),
    .tilemap_error_flags(tilemap_error_flags),
    .tilemap_status(tilemap_status),
    .vid_data(vid_data),
    .vid_de(vid_de),
    .vid_hsync(vid_hsync),
    .vid_vsync(vid_vsync)
  );
endmodule
