// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Fri Oct 30 22:05:41 2026
// Host        : build-host running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_write_pair_0/c6v_capture_write_pair_0_stub.v
// Design      : c6v_capture_write_pair_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "c6v_capture_write_pair_0,vision_dma_write_pair,{}" *) (* CORE_GENERATION_INFO = "c6v_capture_write_pair_0,vision_dma_write_pair,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=vision_dma_write_pair,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,DATA_BYTES=8,RGB_BYTES=0x00000000002A3000,PACKET_BYTES=0x0000000000070840,CONTINUOUS=1,TRACK_FRAME_COMPLETIONS=1,SG_STATUS=1}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* IP_DEFINITION_SOURCE = "module_ref" *) (* X_CORE_INFO = "vision_dma_write_pair,Vivado 2026.1" *) 
module c6v_capture_write_pair_0(aclk, aresetn, capture_fault, source_closed, 
  closed_frame_count, rgb_address_valid, rgb_address_ready, rgb_address, 
  rgb_address_length, rgb_write_data, rgb_data_valid, rgb_data_ready, rgb_data_last, 
  rgb_data_strobes, rgb_response_valid, rgb_response_ready, rgb_response_status, 
  packet_address_valid, packet_address_ready, packet_address, packet_address_length, 
  packet_write_data, packet_data_valid, packet_data_ready, packet_data_last, 
  packet_data_strobes, packet_response_valid, packet_response_ready, 
  packet_response_status, status_address_valid, status_address_ready, status_address, 
  status_address_length, status_address_size, status_address_burst, 
  status_address_protection, status_address_cache, status_write_data, status_data_valid, 
  status_data_ready, status_data_last, status_data_strobes, status_response_valid, 
  status_response_ready, status_response_status, status_read_address, 
  status_read_address_length, status_read_address_size, status_read_address_burst, 
  status_read_address_protection, status_read_address_cache, status_read_address_valid, 
  status_read_address_ready, status_read_data, status_read_response, status_read_last, 
  status_read_valid, status_read_ready, rgb_writes_drained, packet_writes_drained, 
  status_writes_drained, writes_drained, status_fault, rgb_completed_frames, 
  packet_completed_frames, status_completed_frames)
/* synthesis syn_black_box black_box_pad_pin="aresetn,capture_fault,source_closed,closed_frame_count[31:0],rgb_address_valid,rgb_address_ready,rgb_address[31:0],rgb_address_length[7:0],rgb_write_data[63:0],rgb_data_valid,rgb_data_ready,rgb_data_last,rgb_data_strobes[7:0],rgb_response_valid,rgb_response_ready,rgb_response_status[1:0],packet_address_valid,packet_address_ready,packet_address[31:0],packet_address_length[7:0],packet_write_data[63:0],packet_data_valid,packet_data_ready,packet_data_last,packet_data_strobes[7:0],packet_response_valid,packet_response_ready,packet_response_status[1:0],status_address_valid,status_address_ready,status_address[31:0],status_address_length[7:0],status_address_size[2:0],status_address_burst[1:0],status_address_protection[2:0],status_address_cache[3:0],status_write_data[31:0],status_data_valid,status_data_ready,status_data_last,status_data_strobes[3:0],status_response_valid,status_response_ready,status_response_status[1:0],status_read_address[31:0],status_read_address_length[7:0],status_read_address_size[2:0],status_read_address_burst[1:0],status_read_address_protection[2:0],status_read_address_cache[3:0],status_read_address_valid,status_read_address_ready,status_read_data[31:0],status_read_response[1:0],status_read_last,status_read_valid,status_read_ready,rgb_writes_drained,packet_writes_drained,status_writes_drained,writes_drained,status_fault,rgb_completed_frames[31:0],packet_completed_frames[31:0],status_completed_frames[31:0]" */
/* synthesis syn_force_seq_prim="aclk" */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF MON_RGB:MON_PACKET:MON_STATUS, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input aclk /* synthesis syn_isclock = 1 */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input aresetn;
  input capture_fault;
  input source_closed;
  input [31:0]closed_frame_count;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB AWVALID" *) (* X_INTERFACE_MODE = "monitor slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME MON_RGB, PROTOCOL AXI4, DATA_WIDTH 64, ADDR_WIDTH 32, ID_WIDTH 0, READ_WRITE_MODE WRITE_ONLY, FREQ_HZ 100000000, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 0, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input rgb_address_valid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB AWREADY" *) input rgb_address_ready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB AWADDR" *) input [31:0]rgb_address;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB AWLEN" *) input [7:0]rgb_address_length;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WDATA" *) input [63:0]rgb_write_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WVALID" *) input rgb_data_valid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WREADY" *) input rgb_data_ready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WLAST" *) input rgb_data_last;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WSTRB" *) input [7:0]rgb_data_strobes;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB BVALID" *) input rgb_response_valid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB BREADY" *) input rgb_response_ready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB BRESP" *) input [1:0]rgb_response_status;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET AWVALID" *) (* X_INTERFACE_MODE = "monitor slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME MON_PACKET, PROTOCOL AXI4, DATA_WIDTH 64, ADDR_WIDTH 32, ID_WIDTH 0, READ_WRITE_MODE WRITE_ONLY, FREQ_HZ 100000000, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 0, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input packet_address_valid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET AWREADY" *) input packet_address_ready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET AWADDR" *) input [31:0]packet_address;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET AWLEN" *) input [7:0]packet_address_length;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WDATA" *) input [63:0]packet_write_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WVALID" *) input packet_data_valid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WREADY" *) input packet_data_ready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WLAST" *) input packet_data_last;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WSTRB" *) input [7:0]packet_data_strobes;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET BVALID" *) input packet_response_valid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET BREADY" *) input packet_response_ready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET BRESP" *) input [1:0]packet_response_status;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWVALID" *) (* X_INTERFACE_MODE = "monitor slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME MON_STATUS, PROTOCOL AXI4, DATA_WIDTH 32, ADDR_WIDTH 32, ID_WIDTH 0, READ_WRITE_MODE READ_WRITE, FREQ_HZ 100000000, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 1, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input status_address_valid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWREADY" *) input status_address_ready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWADDR" *) input [31:0]status_address;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWLEN" *) input [7:0]status_address_length;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWSIZE" *) input [2:0]status_address_size;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWBURST" *) input [1:0]status_address_burst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWPROT" *) input [2:0]status_address_protection;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWCACHE" *) input [3:0]status_address_cache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WDATA" *) input [31:0]status_write_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WVALID" *) input status_data_valid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WREADY" *) input status_data_ready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WLAST" *) input status_data_last;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WSTRB" *) input [3:0]status_data_strobes;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS BVALID" *) input status_response_valid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS BREADY" *) input status_response_ready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS BRESP" *) input [1:0]status_response_status;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARADDR" *) input [31:0]status_read_address;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARLEN" *) input [7:0]status_read_address_length;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARSIZE" *) input [2:0]status_read_address_size;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARBURST" *) input [1:0]status_read_address_burst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARPROT" *) input [2:0]status_read_address_protection;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARCACHE" *) input [3:0]status_read_address_cache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARVALID" *) input status_read_address_valid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARREADY" *) input status_read_address_ready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RDATA" *) input [31:0]status_read_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RRESP" *) input [1:0]status_read_response;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RLAST" *) input status_read_last;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RVALID" *) input status_read_valid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RREADY" *) input status_read_ready;
  output rgb_writes_drained;
  output packet_writes_drained;
  output status_writes_drained;
  output writes_drained;
  output status_fault;
  output [31:0]rgb_completed_frames;
  output [31:0]packet_completed_frames;
  output [31:0]status_completed_frames;
endmodule
