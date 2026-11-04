-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 30 22:07:11 2026
-- Host        : build-host running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_dual_mask_capture_0/c6v_dual_mask_capture_0_stub.vhdl
-- Design      : c6v_dual_mask_capture_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity c6v_dual_mask_capture_0 is
  Port ( 
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 23 downto 0 );
    s_axis_tkeep : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tuser : in STD_LOGIC;
    s_axis_tlast : in STD_LOGIC;
    cfg_frame_context : in STD_LOGIC_VECTOR ( 143 downto 0 );
    source_fault : in STD_LOGIC;
    abort_requested : in STD_LOGIC;
    source_closed : in STD_LOGIC;
    closed_frame_count : in STD_LOGIC_VECTOR ( 31 downto 0 );
    frame_credit_ready : in STD_LOGIC;
    frame_credit_request : out STD_LOGIC;
    m_rgb_tdata : out STD_LOGIC_VECTOR ( 23 downto 0 );
    m_rgb_tkeep : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_rgb_tvalid : out STD_LOGIC;
    m_rgb_tready : in STD_LOGIC;
    m_rgb_tuser : out STD_LOGIC;
    m_rgb_tlast : out STD_LOGIC;
    m_packet_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_packet_tkeep : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_packet_tvalid : out STD_LOGIC;
    m_packet_tready : in STD_LOGIC;
    m_packet_tlast : out STD_LOGIC;
    frame_fault : out STD_LOGIC;
    pipeline_drained : out STD_LOGIC
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_dual_mask_capture_0 : entity is "c6v_dual_mask_capture_0,axis_rgb_capture_bd,{}";
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of c6v_dual_mask_capture_0 : entity is "c6v_dual_mask_capture_0,axis_rgb_capture_bd,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=axis_rgb_capture_bd,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,INPUT_WIDTH=1280,INPUT_HEIGHT=720,EPOCH_FRAMES=1,CONTINUOUS=1,SEQUENCE_FRAME_IDS=1,USE_FRAME_CREDITS=1}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_dual_mask_capture_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_dual_mask_capture_0 : entity is "module_ref";
end c6v_dual_mask_capture_0;

architecture stub of c6v_dual_mask_capture_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "aclk,aresetn,s_axis_tdata[23:0],s_axis_tkeep[2:0],s_axis_tvalid,s_axis_tready,s_axis_tuser,s_axis_tlast,cfg_frame_context[143:0],source_fault,abort_requested,source_closed,closed_frame_count[31:0],frame_credit_ready,frame_credit_request,m_rgb_tdata[23:0],m_rgb_tkeep[2:0],m_rgb_tvalid,m_rgb_tready,m_rgb_tuser,m_rgb_tlast,m_packet_tdata[31:0],m_packet_tkeep[3:0],m_packet_tvalid,m_packet_tready,m_packet_tlast,frame_fault,pipeline_drained";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of aclk : signal is "xilinx.com:signal:clock:1.0 aclk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of aclk : signal is "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF S_AXIS:M_RGB:M_PACKET, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of aresetn : signal is "xilinx.com:signal:reset:1.0 aresetn RST";
  attribute X_INTERFACE_MODE of aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of aresetn : signal is "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axis_tdata : signal is "xilinx.com:interface:axis:1.0 S_AXIS TDATA";
  attribute X_INTERFACE_MODE of s_axis_tdata : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s_axis_tdata : signal is "XIL_INTERFACENAME S_AXIS, TDATA_NUM_BYTES 3, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axis_tkeep : signal is "xilinx.com:interface:axis:1.0 S_AXIS TKEEP";
  attribute X_INTERFACE_INFO of s_axis_tvalid : signal is "xilinx.com:interface:axis:1.0 S_AXIS TVALID";
  attribute X_INTERFACE_INFO of s_axis_tready : signal is "xilinx.com:interface:axis:1.0 S_AXIS TREADY";
  attribute X_INTERFACE_INFO of s_axis_tuser : signal is "xilinx.com:interface:axis:1.0 S_AXIS TUSER";
  attribute X_INTERFACE_INFO of s_axis_tlast : signal is "xilinx.com:interface:axis:1.0 S_AXIS TLAST";
  attribute X_INTERFACE_INFO of m_rgb_tdata : signal is "xilinx.com:interface:axis:1.0 M_RGB TDATA";
  attribute X_INTERFACE_MODE of m_rgb_tdata : signal is "master";
  attribute X_INTERFACE_PARAMETER of m_rgb_tdata : signal is "XIL_INTERFACENAME M_RGB, TDATA_NUM_BYTES 3, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_rgb_tkeep : signal is "xilinx.com:interface:axis:1.0 M_RGB TKEEP";
  attribute X_INTERFACE_INFO of m_rgb_tvalid : signal is "xilinx.com:interface:axis:1.0 M_RGB TVALID";
  attribute X_INTERFACE_INFO of m_rgb_tready : signal is "xilinx.com:interface:axis:1.0 M_RGB TREADY";
  attribute X_INTERFACE_INFO of m_rgb_tuser : signal is "xilinx.com:interface:axis:1.0 M_RGB TUSER";
  attribute X_INTERFACE_INFO of m_rgb_tlast : signal is "xilinx.com:interface:axis:1.0 M_RGB TLAST";
  attribute X_INTERFACE_INFO of m_packet_tdata : signal is "xilinx.com:interface:axis:1.0 M_PACKET TDATA";
  attribute X_INTERFACE_MODE of m_packet_tdata : signal is "master";
  attribute X_INTERFACE_PARAMETER of m_packet_tdata : signal is "XIL_INTERFACENAME M_PACKET, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_packet_tkeep : signal is "xilinx.com:interface:axis:1.0 M_PACKET TKEEP";
  attribute X_INTERFACE_INFO of m_packet_tvalid : signal is "xilinx.com:interface:axis:1.0 M_PACKET TVALID";
  attribute X_INTERFACE_INFO of m_packet_tready : signal is "xilinx.com:interface:axis:1.0 M_PACKET TREADY";
  attribute X_INTERFACE_INFO of m_packet_tlast : signal is "xilinx.com:interface:axis:1.0 M_PACKET TLAST";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of stub : architecture is "axis_rgb_capture_bd,Vivado 2026.1";
begin
end;
