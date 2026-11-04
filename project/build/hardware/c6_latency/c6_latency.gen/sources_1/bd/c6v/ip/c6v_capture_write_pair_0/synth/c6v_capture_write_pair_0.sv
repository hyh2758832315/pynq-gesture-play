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


// IP VLNV: xilinx.com:module_ref:vision_dma_write_pair:1.0
// IP Revision: 1

(* X_CORE_INFO = "vision_dma_write_pair,Vivado 2026.1" *)
(* CHECK_LICENSE_TYPE = "c6v_capture_write_pair_0,vision_dma_write_pair,{}" *)
(* CORE_GENERATION_INFO = "c6v_capture_write_pair_0,vision_dma_write_pair,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=vision_dma_write_pair,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,DATA_BYTES=8,RGB_BYTES=0x00000000002A3000,PACKET_BYTES=0x0000000000070840,CONTINUOUS=1,TRACK_FRAME_COMPLETIONS=1,SG_STATUS=1}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module c6v_capture_write_pair_0 (
  aclk,
  aresetn,
  capture_fault,
  source_closed,
  closed_frame_count,
  rgb_address_valid,
  rgb_address_ready,
  rgb_address,
  rgb_address_length,
  rgb_write_data,
  rgb_data_valid,
  rgb_data_ready,
  rgb_data_last,
  rgb_data_strobes,
  rgb_response_valid,
  rgb_response_ready,
  rgb_response_status,
  packet_address_valid,
  packet_address_ready,
  packet_address,
  packet_address_length,
  packet_write_data,
  packet_data_valid,
  packet_data_ready,
  packet_data_last,
  packet_data_strobes,
  packet_response_valid,
  packet_response_ready,
  packet_response_status,
  status_address_valid,
  status_address_ready,
  status_address,
  status_address_length,
  status_address_size,
  status_address_burst,
  status_address_protection,
  status_address_cache,
  status_write_data,
  status_data_valid,
  status_data_ready,
  status_data_last,
  status_data_strobes,
  status_response_valid,
  status_response_ready,
  status_response_status,
  status_read_address,
  status_read_address_length,
  status_read_address_size,
  status_read_address_burst,
  status_read_address_protection,
  status_read_address_cache,
  status_read_address_valid,
  status_read_address_ready,
  status_read_data,
  status_read_response,
  status_read_last,
  status_read_valid,
  status_read_ready,
  rgb_writes_drained,
  packet_writes_drained,
  status_writes_drained,
  writes_drained,
  status_fault,
  rgb_completed_frames,
  packet_completed_frames,
  status_completed_frames
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF MON_RGB:MON_PACKET:MON_STATUS, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
input wire aclk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
input wire aresetn;
input wire capture_fault;
input wire source_closed;
input wire [31 : 0] closed_frame_count;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB AWVALID" *)
(* X_INTERFACE_MODE = "monitor slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME MON_RGB, PROTOCOL AXI4, DATA_WIDTH 64, ADDR_WIDTH 32, ID_WIDTH 0, READ_WRITE_MODE WRITE_ONLY, FREQ_HZ 100000000, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 0, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS\
 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
input wire rgb_address_valid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB AWREADY" *)
input wire rgb_address_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB AWADDR" *)
input wire [31 : 0] rgb_address;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB AWLEN" *)
input wire [7 : 0] rgb_address_length;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WDATA" *)
input wire [63 : 0] rgb_write_data;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WVALID" *)
input wire rgb_data_valid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WREADY" *)
input wire rgb_data_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WLAST" *)
input wire rgb_data_last;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WSTRB" *)
input wire [7 : 0] rgb_data_strobes;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB BVALID" *)
input wire rgb_response_valid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB BREADY" *)
input wire rgb_response_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB BRESP" *)
input wire [1 : 0] rgb_response_status;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET AWVALID" *)
(* X_INTERFACE_MODE = "monitor slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME MON_PACKET, PROTOCOL AXI4, DATA_WIDTH 64, ADDR_WIDTH 32, ID_WIDTH 0, READ_WRITE_MODE WRITE_ONLY, FREQ_HZ 100000000, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 0, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THRE\
ADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
input wire packet_address_valid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET AWREADY" *)
input wire packet_address_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET AWADDR" *)
input wire [31 : 0] packet_address;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET AWLEN" *)
input wire [7 : 0] packet_address_length;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WDATA" *)
input wire [63 : 0] packet_write_data;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WVALID" *)
input wire packet_data_valid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WREADY" *)
input wire packet_data_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WLAST" *)
input wire packet_data_last;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WSTRB" *)
input wire [7 : 0] packet_data_strobes;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET BVALID" *)
input wire packet_response_valid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET BREADY" *)
input wire packet_response_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET BRESP" *)
input wire [1 : 0] packet_response_status;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWVALID" *)
(* X_INTERFACE_MODE = "monitor slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME MON_STATUS, PROTOCOL AXI4, DATA_WIDTH 32, ADDR_WIDTH 32, ID_WIDTH 0, READ_WRITE_MODE READ_WRITE, FREQ_HZ 100000000, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 1, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THRE\
ADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
input wire status_address_valid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWREADY" *)
input wire status_address_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWADDR" *)
input wire [31 : 0] status_address;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWLEN" *)
input wire [7 : 0] status_address_length;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWSIZE" *)
input wire [2 : 0] status_address_size;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWBURST" *)
input wire [1 : 0] status_address_burst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWPROT" *)
input wire [2 : 0] status_address_protection;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWCACHE" *)
input wire [3 : 0] status_address_cache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WDATA" *)
input wire [31 : 0] status_write_data;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WVALID" *)
input wire status_data_valid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WREADY" *)
input wire status_data_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WLAST" *)
input wire status_data_last;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WSTRB" *)
input wire [3 : 0] status_data_strobes;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS BVALID" *)
input wire status_response_valid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS BREADY" *)
input wire status_response_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS BRESP" *)
input wire [1 : 0] status_response_status;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARADDR" *)
input wire [31 : 0] status_read_address;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARLEN" *)
input wire [7 : 0] status_read_address_length;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARSIZE" *)
input wire [2 : 0] status_read_address_size;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARBURST" *)
input wire [1 : 0] status_read_address_burst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARPROT" *)
input wire [2 : 0] status_read_address_protection;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARCACHE" *)
input wire [3 : 0] status_read_address_cache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARVALID" *)
input wire status_read_address_valid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARREADY" *)
input wire status_read_address_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RDATA" *)
input wire [31 : 0] status_read_data;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RRESP" *)
input wire [1 : 0] status_read_response;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RLAST" *)
input wire status_read_last;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RVALID" *)
input wire status_read_valid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RREADY" *)
input wire status_read_ready;
output wire rgb_writes_drained;
output wire packet_writes_drained;
output wire status_writes_drained;
output wire writes_drained;
output wire status_fault;
output wire [31 : 0] rgb_completed_frames;
output wire [31 : 0] packet_completed_frames;
output wire [31 : 0] status_completed_frames;

  vision_dma_write_pair #(
    .DATA_BYTES(8),
    .RGB_BYTES(64'H00000000002A3000),
    .PACKET_BYTES(64'H0000000000070840),
    .CONTINUOUS(1),
    .TRACK_FRAME_COMPLETIONS(1),
    .SG_STATUS(1)
  ) inst (
    .aclk(aclk),
    .aresetn(aresetn),
    .capture_fault(capture_fault),
    .source_closed(source_closed),
    .closed_frame_count(closed_frame_count),
    .rgb_address_valid(rgb_address_valid),
    .rgb_address_ready(rgb_address_ready),
    .rgb_address(rgb_address),
    .rgb_address_length(rgb_address_length),
    .rgb_write_data(rgb_write_data),
    .rgb_data_valid(rgb_data_valid),
    .rgb_data_ready(rgb_data_ready),
    .rgb_data_last(rgb_data_last),
    .rgb_data_strobes(rgb_data_strobes),
    .rgb_response_valid(rgb_response_valid),
    .rgb_response_ready(rgb_response_ready),
    .rgb_response_status(rgb_response_status),
    .packet_address_valid(packet_address_valid),
    .packet_address_ready(packet_address_ready),
    .packet_address(packet_address),
    .packet_address_length(packet_address_length),
    .packet_write_data(packet_write_data),
    .packet_data_valid(packet_data_valid),
    .packet_data_ready(packet_data_ready),
    .packet_data_last(packet_data_last),
    .packet_data_strobes(packet_data_strobes),
    .packet_response_valid(packet_response_valid),
    .packet_response_ready(packet_response_ready),
    .packet_response_status(packet_response_status),
    .status_address_valid(status_address_valid),
    .status_address_ready(status_address_ready),
    .status_address(status_address),
    .status_address_length(status_address_length),
    .status_address_size(status_address_size),
    .status_address_burst(status_address_burst),
    .status_address_protection(status_address_protection),
    .status_address_cache(status_address_cache),
    .status_write_data(status_write_data),
    .status_data_valid(status_data_valid),
    .status_data_ready(status_data_ready),
    .status_data_last(status_data_last),
    .status_data_strobes(status_data_strobes),
    .status_response_valid(status_response_valid),
    .status_response_ready(status_response_ready),
    .status_response_status(status_response_status),
    .status_read_address(status_read_address),
    .status_read_address_length(status_read_address_length),
    .status_read_address_size(status_read_address_size),
    .status_read_address_burst(status_read_address_burst),
    .status_read_address_protection(status_read_address_protection),
    .status_read_address_cache(status_read_address_cache),
    .status_read_address_valid(status_read_address_valid),
    .status_read_address_ready(status_read_address_ready),
    .status_read_data(status_read_data),
    .status_read_response(status_read_response),
    .status_read_last(status_read_last),
    .status_read_valid(status_read_valid),
    .status_read_ready(status_read_ready),
    .rgb_writes_drained(rgb_writes_drained),
    .packet_writes_drained(packet_writes_drained),
    .status_writes_drained(status_writes_drained),
    .writes_drained(writes_drained),
    .status_fault(status_fault),
    .rgb_completed_frames(rgb_completed_frames),
    .packet_completed_frames(packet_completed_frames),
    .status_completed_frames(status_completed_frames)
  );
endmodule
