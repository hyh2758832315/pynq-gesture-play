-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 30 22:05:41 2026
-- Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_write_pair_0/c6v_capture_write_pair_0_stub.vhdl
-- Design      : c6v_capture_write_pair_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity c6v_capture_write_pair_0 is
  Port ( 
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    capture_fault : in STD_LOGIC;
    source_closed : in STD_LOGIC;
    closed_frame_count : in STD_LOGIC_VECTOR ( 31 downto 0 );
    rgb_address_valid : in STD_LOGIC;
    rgb_address_ready : in STD_LOGIC;
    rgb_address : in STD_LOGIC_VECTOR ( 31 downto 0 );
    rgb_address_length : in STD_LOGIC_VECTOR ( 7 downto 0 );
    rgb_write_data : in STD_LOGIC_VECTOR ( 63 downto 0 );
    rgb_data_valid : in STD_LOGIC;
    rgb_data_ready : in STD_LOGIC;
    rgb_data_last : in STD_LOGIC;
    rgb_data_strobes : in STD_LOGIC_VECTOR ( 7 downto 0 );
    rgb_response_valid : in STD_LOGIC;
    rgb_response_ready : in STD_LOGIC;
    rgb_response_status : in STD_LOGIC_VECTOR ( 1 downto 0 );
    packet_address_valid : in STD_LOGIC;
    packet_address_ready : in STD_LOGIC;
    packet_address : in STD_LOGIC_VECTOR ( 31 downto 0 );
    packet_address_length : in STD_LOGIC_VECTOR ( 7 downto 0 );
    packet_write_data : in STD_LOGIC_VECTOR ( 63 downto 0 );
    packet_data_valid : in STD_LOGIC;
    packet_data_ready : in STD_LOGIC;
    packet_data_last : in STD_LOGIC;
    packet_data_strobes : in STD_LOGIC_VECTOR ( 7 downto 0 );
    packet_response_valid : in STD_LOGIC;
    packet_response_ready : in STD_LOGIC;
    packet_response_status : in STD_LOGIC_VECTOR ( 1 downto 0 );
    status_address_valid : in STD_LOGIC;
    status_address_ready : in STD_LOGIC;
    status_address : in STD_LOGIC_VECTOR ( 31 downto 0 );
    status_address_length : in STD_LOGIC_VECTOR ( 7 downto 0 );
    status_address_size : in STD_LOGIC_VECTOR ( 2 downto 0 );
    status_address_burst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    status_address_protection : in STD_LOGIC_VECTOR ( 2 downto 0 );
    status_address_cache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    status_write_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    status_data_valid : in STD_LOGIC;
    status_data_ready : in STD_LOGIC;
    status_data_last : in STD_LOGIC;
    status_data_strobes : in STD_LOGIC_VECTOR ( 3 downto 0 );
    status_response_valid : in STD_LOGIC;
    status_response_ready : in STD_LOGIC;
    status_response_status : in STD_LOGIC_VECTOR ( 1 downto 0 );
    status_read_address : in STD_LOGIC_VECTOR ( 31 downto 0 );
    status_read_address_length : in STD_LOGIC_VECTOR ( 7 downto 0 );
    status_read_address_size : in STD_LOGIC_VECTOR ( 2 downto 0 );
    status_read_address_burst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    status_read_address_protection : in STD_LOGIC_VECTOR ( 2 downto 0 );
    status_read_address_cache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    status_read_address_valid : in STD_LOGIC;
    status_read_address_ready : in STD_LOGIC;
    status_read_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    status_read_response : in STD_LOGIC_VECTOR ( 1 downto 0 );
    status_read_last : in STD_LOGIC;
    status_read_valid : in STD_LOGIC;
    status_read_ready : in STD_LOGIC;
    rgb_writes_drained : out STD_LOGIC;
    packet_writes_drained : out STD_LOGIC;
    status_writes_drained : out STD_LOGIC;
    writes_drained : out STD_LOGIC;
    status_fault : out STD_LOGIC;
    rgb_completed_frames : out STD_LOGIC_VECTOR ( 31 downto 0 );
    packet_completed_frames : out STD_LOGIC_VECTOR ( 31 downto 0 );
    status_completed_frames : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_capture_write_pair_0 : entity is "c6v_capture_write_pair_0,vision_dma_write_pair,{}";
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of c6v_capture_write_pair_0 : entity is "c6v_capture_write_pair_0,vision_dma_write_pair,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=vision_dma_write_pair,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,DATA_BYTES=8,RGB_BYTES=0x00000000002A3000,PACKET_BYTES=0x0000000000070840,CONTINUOUS=1,TRACK_FRAME_COMPLETIONS=1,SG_STATUS=1}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_capture_write_pair_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_capture_write_pair_0 : entity is "module_ref";
end c6v_capture_write_pair_0;

architecture stub of c6v_capture_write_pair_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "aclk,aresetn,capture_fault,source_closed,closed_frame_count[31:0],rgb_address_valid,rgb_address_ready,rgb_address[31:0],rgb_address_length[7:0],rgb_write_data[63:0],rgb_data_valid,rgb_data_ready,rgb_data_last,rgb_data_strobes[7:0],rgb_response_valid,rgb_response_ready,rgb_response_status[1:0],packet_address_valid,packet_address_ready,packet_address[31:0],packet_address_length[7:0],packet_write_data[63:0],packet_data_valid,packet_data_ready,packet_data_last,packet_data_strobes[7:0],packet_response_valid,packet_response_ready,packet_response_status[1:0],status_address_valid,status_address_ready,status_address[31:0],status_address_length[7:0],status_address_size[2:0],status_address_burst[1:0],status_address_protection[2:0],status_address_cache[3:0],status_write_data[31:0],status_data_valid,status_data_ready,status_data_last,status_data_strobes[3:0],status_response_valid,status_response_ready,status_response_status[1:0],status_read_address[31:0],status_read_address_length[7:0],status_read_address_size[2:0],status_read_address_burst[1:0],status_read_address_protection[2:0],status_read_address_cache[3:0],status_read_address_valid,status_read_address_ready,status_read_data[31:0],status_read_response[1:0],status_read_last,status_read_valid,status_read_ready,rgb_writes_drained,packet_writes_drained,status_writes_drained,writes_drained,status_fault,rgb_completed_frames[31:0],packet_completed_frames[31:0],status_completed_frames[31:0]";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of aclk : signal is "xilinx.com:signal:clock:1.0 aclk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of aclk : signal is "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF MON_RGB:MON_PACKET:MON_STATUS, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of aresetn : signal is "xilinx.com:signal:reset:1.0 aresetn RST";
  attribute X_INTERFACE_MODE of aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of aresetn : signal is "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of rgb_address_valid : signal is "xilinx.com:interface:aximm:1.0 MON_RGB AWVALID";
  attribute X_INTERFACE_MODE of rgb_address_valid : signal is "monitor slave";
  attribute X_INTERFACE_PARAMETER of rgb_address_valid : signal is "XIL_INTERFACENAME MON_RGB, PROTOCOL AXI4, DATA_WIDTH 64, ADDR_WIDTH 32, ID_WIDTH 0, READ_WRITE_MODE WRITE_ONLY, FREQ_HZ 100000000, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 0, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of rgb_address_ready : signal is "xilinx.com:interface:aximm:1.0 MON_RGB AWREADY";
  attribute X_INTERFACE_INFO of rgb_address : signal is "xilinx.com:interface:aximm:1.0 MON_RGB AWADDR";
  attribute X_INTERFACE_INFO of rgb_address_length : signal is "xilinx.com:interface:aximm:1.0 MON_RGB AWLEN";
  attribute X_INTERFACE_INFO of rgb_write_data : signal is "xilinx.com:interface:aximm:1.0 MON_RGB WDATA";
  attribute X_INTERFACE_INFO of rgb_data_valid : signal is "xilinx.com:interface:aximm:1.0 MON_RGB WVALID";
  attribute X_INTERFACE_INFO of rgb_data_ready : signal is "xilinx.com:interface:aximm:1.0 MON_RGB WREADY";
  attribute X_INTERFACE_INFO of rgb_data_last : signal is "xilinx.com:interface:aximm:1.0 MON_RGB WLAST";
  attribute X_INTERFACE_INFO of rgb_data_strobes : signal is "xilinx.com:interface:aximm:1.0 MON_RGB WSTRB";
  attribute X_INTERFACE_INFO of rgb_response_valid : signal is "xilinx.com:interface:aximm:1.0 MON_RGB BVALID";
  attribute X_INTERFACE_INFO of rgb_response_ready : signal is "xilinx.com:interface:aximm:1.0 MON_RGB BREADY";
  attribute X_INTERFACE_INFO of rgb_response_status : signal is "xilinx.com:interface:aximm:1.0 MON_RGB BRESP";
  attribute X_INTERFACE_INFO of packet_address_valid : signal is "xilinx.com:interface:aximm:1.0 MON_PACKET AWVALID";
  attribute X_INTERFACE_MODE of packet_address_valid : signal is "monitor slave";
  attribute X_INTERFACE_PARAMETER of packet_address_valid : signal is "XIL_INTERFACENAME MON_PACKET, PROTOCOL AXI4, DATA_WIDTH 64, ADDR_WIDTH 32, ID_WIDTH 0, READ_WRITE_MODE WRITE_ONLY, FREQ_HZ 100000000, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 0, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of packet_address_ready : signal is "xilinx.com:interface:aximm:1.0 MON_PACKET AWREADY";
  attribute X_INTERFACE_INFO of packet_address : signal is "xilinx.com:interface:aximm:1.0 MON_PACKET AWADDR";
  attribute X_INTERFACE_INFO of packet_address_length : signal is "xilinx.com:interface:aximm:1.0 MON_PACKET AWLEN";
  attribute X_INTERFACE_INFO of packet_write_data : signal is "xilinx.com:interface:aximm:1.0 MON_PACKET WDATA";
  attribute X_INTERFACE_INFO of packet_data_valid : signal is "xilinx.com:interface:aximm:1.0 MON_PACKET WVALID";
  attribute X_INTERFACE_INFO of packet_data_ready : signal is "xilinx.com:interface:aximm:1.0 MON_PACKET WREADY";
  attribute X_INTERFACE_INFO of packet_data_last : signal is "xilinx.com:interface:aximm:1.0 MON_PACKET WLAST";
  attribute X_INTERFACE_INFO of packet_data_strobes : signal is "xilinx.com:interface:aximm:1.0 MON_PACKET WSTRB";
  attribute X_INTERFACE_INFO of packet_response_valid : signal is "xilinx.com:interface:aximm:1.0 MON_PACKET BVALID";
  attribute X_INTERFACE_INFO of packet_response_ready : signal is "xilinx.com:interface:aximm:1.0 MON_PACKET BREADY";
  attribute X_INTERFACE_INFO of packet_response_status : signal is "xilinx.com:interface:aximm:1.0 MON_PACKET BRESP";
  attribute X_INTERFACE_INFO of status_address_valid : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS AWVALID";
  attribute X_INTERFACE_MODE of status_address_valid : signal is "monitor slave";
  attribute X_INTERFACE_PARAMETER of status_address_valid : signal is "XIL_INTERFACENAME MON_STATUS, PROTOCOL AXI4, DATA_WIDTH 32, ADDR_WIDTH 32, ID_WIDTH 0, READ_WRITE_MODE READ_WRITE, FREQ_HZ 100000000, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, HAS_BURST 1, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of status_address_ready : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS AWREADY";
  attribute X_INTERFACE_INFO of status_address : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS AWADDR";
  attribute X_INTERFACE_INFO of status_address_length : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS AWLEN";
  attribute X_INTERFACE_INFO of status_address_size : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS AWSIZE";
  attribute X_INTERFACE_INFO of status_address_burst : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS AWBURST";
  attribute X_INTERFACE_INFO of status_address_protection : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS AWPROT";
  attribute X_INTERFACE_INFO of status_address_cache : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS AWCACHE";
  attribute X_INTERFACE_INFO of status_write_data : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS WDATA";
  attribute X_INTERFACE_INFO of status_data_valid : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS WVALID";
  attribute X_INTERFACE_INFO of status_data_ready : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS WREADY";
  attribute X_INTERFACE_INFO of status_data_last : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS WLAST";
  attribute X_INTERFACE_INFO of status_data_strobes : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS WSTRB";
  attribute X_INTERFACE_INFO of status_response_valid : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS BVALID";
  attribute X_INTERFACE_INFO of status_response_ready : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS BREADY";
  attribute X_INTERFACE_INFO of status_response_status : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS BRESP";
  attribute X_INTERFACE_INFO of status_read_address : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS ARADDR";
  attribute X_INTERFACE_INFO of status_read_address_length : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS ARLEN";
  attribute X_INTERFACE_INFO of status_read_address_size : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS ARSIZE";
  attribute X_INTERFACE_INFO of status_read_address_burst : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS ARBURST";
  attribute X_INTERFACE_INFO of status_read_address_protection : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS ARPROT";
  attribute X_INTERFACE_INFO of status_read_address_cache : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS ARCACHE";
  attribute X_INTERFACE_INFO of status_read_address_valid : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS ARVALID";
  attribute X_INTERFACE_INFO of status_read_address_ready : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS ARREADY";
  attribute X_INTERFACE_INFO of status_read_data : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS RDATA";
  attribute X_INTERFACE_INFO of status_read_response : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS RRESP";
  attribute X_INTERFACE_INFO of status_read_last : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS RLAST";
  attribute X_INTERFACE_INFO of status_read_valid : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS RVALID";
  attribute X_INTERFACE_INFO of status_read_ready : signal is "xilinx.com:interface:aximm:1.0 MON_STATUS RREADY";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of stub : architecture is "vision_dma_write_pair,Vivado 2026.1";
begin
end;
