// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Fri Oct 30 22:07:26 2026
// Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_core_0/c6v_core_0_stub.v
// Design      : c6v_core_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "c6v_core_0,scene2d_c4m7_core,{}" *) (* CORE_GENERATION_INFO = "c6v_core_0,scene2d_c4m7_core,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=scene2d_c4m7_core,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,H_ACTIVE=1280,H_FRONT=110,H_SYNC=40,H_BACK=220,V_ACTIVE=720,V_FRONT=5,V_SYNC=5,V_BACK=20,OUTPUT_SCALE=4,TILE_DESCRIPTOR_CACHE_ENABLE=0,BLIT_PIXEL_PIPELINE_ENABLE=0,TILE_PIXEL_PIPELINE_ENABLE=0,TILE_PIXEL_PAIR_ENABLE=0,BLIT_PIXEL_PAIR_ENABLE=0,CLEAR_FILL_PIXEL_PAIR_ENABLE=0,UPLOAD_RENDER_OVERLAP_ENABLE=0}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* IP_DEFINITION_SOURCE = "module_ref" *) (* X_CORE_INFO = "scene2d_c4m7_core,Vivado 2026.1" *) 
module c6v_core_0(aclk, aresetn, clk_pixel, resetn_pixel, 
  s_axis_tdata, s_axis_tkeep, s_axis_tlast, s_axis_tvalid, s_axis_tready, 
  debug_command_read_address, debug_command_read_data_low, 
  debug_command_read_data_high, upload_crc32, upload_byte_count, upload_packet_count, 
  accepted_packet_count, rejected_packet_count, accepted_seq, accepted_status, 
  upload_error_flags, render_completed_seq, render_completed_count, render_write_count, 
  render_trace_crc32, render_cycles, render_maximum_cycles, render_status, 
  present_completed_seq, present_completed_count, framebuffer_status, 
  overlap_release_toggle, overlap_status, router_dropped_packet_count, 
  unsupported_packet_count, palette_accepted_packet_count, 
  palette_rejected_packet_count, palette_generation, palette_error_flags, palette_status, 
  asset_accepted_packet_count, asset_rejected_packet_count, asset_generation, 
  asset_error_flags, asset_status, tilemap_accepted_packet_count, 
  tilemap_rejected_packet_count, tilemap_generation, tilemap_error_flags, tilemap_status, 
  vid_data, vid_de, vid_hsync, vid_vsync)
/* synthesis syn_black_box black_box_pad_pin="aresetn,resetn_pixel,s_axis_tdata[63:0],s_axis_tkeep[7:0],s_axis_tlast,s_axis_tvalid,s_axis_tready,debug_command_read_address[8:0],debug_command_read_data_low[31:0],debug_command_read_data_high[31:0],upload_crc32[31:0],upload_byte_count[31:0],upload_packet_count[31:0],accepted_packet_count[31:0],rejected_packet_count[31:0],accepted_seq[31:0],accepted_status[31:0],upload_error_flags[5:0],render_completed_seq[31:0],render_completed_count[31:0],render_write_count[31:0],render_trace_crc32[31:0],render_cycles[31:0],render_maximum_cycles[31:0],render_status[31:0],present_completed_seq[31:0],present_completed_count[31:0],framebuffer_status[31:0],overlap_release_toggle,overlap_status[31:0],router_dropped_packet_count[31:0],unsupported_packet_count[31:0],palette_accepted_packet_count[31:0],palette_rejected_packet_count[31:0],palette_generation[31:0],palette_error_flags[8:0],palette_status[31:0],asset_accepted_packet_count[31:0],asset_rejected_packet_count[31:0],asset_generation[31:0],asset_error_flags[8:0],asset_status[31:0],tilemap_accepted_packet_count[31:0],tilemap_rejected_packet_count[31:0],tilemap_generation[31:0],tilemap_error_flags[8:0],tilemap_status[31:0],vid_data[23:0],vid_de,vid_hsync,vid_vsync" */
/* synthesis syn_force_seq_prim="aclk" */
/* synthesis syn_force_seq_prim="clk_pixel" */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF s_axis, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input aclk /* synthesis syn_isclock = 1 */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input aresetn;
  input clk_pixel /* synthesis syn_isclock = 1 */;
  input resetn_pixel;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TDATA" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axis, TDATA_NUM_BYTES 8, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *) input [63:0]s_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TKEEP" *) input [7:0]s_axis_tkeep;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TLAST" *) input s_axis_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TVALID" *) input s_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TREADY" *) output s_axis_tready;
  input [8:0]debug_command_read_address;
  output [31:0]debug_command_read_data_low;
  output [31:0]debug_command_read_data_high;
  output [31:0]upload_crc32;
  output [31:0]upload_byte_count;
  output [31:0]upload_packet_count;
  output [31:0]accepted_packet_count;
  output [31:0]rejected_packet_count;
  output [31:0]accepted_seq;
  output [31:0]accepted_status;
  output [5:0]upload_error_flags;
  output [31:0]render_completed_seq;
  output [31:0]render_completed_count;
  output [31:0]render_write_count;
  output [31:0]render_trace_crc32;
  output [31:0]render_cycles;
  output [31:0]render_maximum_cycles;
  output [31:0]render_status;
  output [31:0]present_completed_seq;
  output [31:0]present_completed_count;
  output [31:0]framebuffer_status;
  input overlap_release_toggle;
  output [31:0]overlap_status;
  output [31:0]router_dropped_packet_count;
  output [31:0]unsupported_packet_count;
  output [31:0]palette_accepted_packet_count;
  output [31:0]palette_rejected_packet_count;
  output [31:0]palette_generation;
  output [8:0]palette_error_flags;
  output [31:0]palette_status;
  output [31:0]asset_accepted_packet_count;
  output [31:0]asset_rejected_packet_count;
  output [31:0]asset_generation;
  output [8:0]asset_error_flags;
  output [31:0]asset_status;
  output [31:0]tilemap_accepted_packet_count;
  output [31:0]tilemap_rejected_packet_count;
  output [31:0]tilemap_generation;
  output [8:0]tilemap_error_flags;
  output [31:0]tilemap_status;
  output [23:0]vid_data;
  output vid_de;
  output vid_hsync;
  output vid_vsync;
endmodule
