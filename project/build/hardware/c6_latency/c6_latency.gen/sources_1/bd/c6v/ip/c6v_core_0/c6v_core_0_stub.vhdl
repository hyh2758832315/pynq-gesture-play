-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 30 22:07:27 2026
-- Host        : build-host running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_core_0/c6v_core_0_stub.vhdl
-- Design      : c6v_core_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity c6v_core_0 is
  Port ( 
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    clk_pixel : in STD_LOGIC;
    resetn_pixel : in STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axis_tkeep : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axis_tlast : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    debug_command_read_address : in STD_LOGIC_VECTOR ( 8 downto 0 );
    debug_command_read_data_low : out STD_LOGIC_VECTOR ( 31 downto 0 );
    debug_command_read_data_high : out STD_LOGIC_VECTOR ( 31 downto 0 );
    upload_crc32 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    upload_byte_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    upload_packet_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    accepted_packet_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    rejected_packet_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    accepted_seq : out STD_LOGIC_VECTOR ( 31 downto 0 );
    accepted_status : out STD_LOGIC_VECTOR ( 31 downto 0 );
    upload_error_flags : out STD_LOGIC_VECTOR ( 5 downto 0 );
    render_completed_seq : out STD_LOGIC_VECTOR ( 31 downto 0 );
    render_completed_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    render_write_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    render_trace_crc32 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    render_cycles : out STD_LOGIC_VECTOR ( 31 downto 0 );
    render_maximum_cycles : out STD_LOGIC_VECTOR ( 31 downto 0 );
    render_status : out STD_LOGIC_VECTOR ( 31 downto 0 );
    present_completed_seq : out STD_LOGIC_VECTOR ( 31 downto 0 );
    present_completed_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    framebuffer_status : out STD_LOGIC_VECTOR ( 31 downto 0 );
    overlap_release_toggle : in STD_LOGIC;
    overlap_status : out STD_LOGIC_VECTOR ( 31 downto 0 );
    router_dropped_packet_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    unsupported_packet_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    palette_accepted_packet_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    palette_rejected_packet_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    palette_generation : out STD_LOGIC_VECTOR ( 31 downto 0 );
    palette_error_flags : out STD_LOGIC_VECTOR ( 8 downto 0 );
    palette_status : out STD_LOGIC_VECTOR ( 31 downto 0 );
    asset_accepted_packet_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    asset_rejected_packet_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    asset_generation : out STD_LOGIC_VECTOR ( 31 downto 0 );
    asset_error_flags : out STD_LOGIC_VECTOR ( 8 downto 0 );
    asset_status : out STD_LOGIC_VECTOR ( 31 downto 0 );
    tilemap_accepted_packet_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    tilemap_rejected_packet_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    tilemap_generation : out STD_LOGIC_VECTOR ( 31 downto 0 );
    tilemap_error_flags : out STD_LOGIC_VECTOR ( 8 downto 0 );
    tilemap_status : out STD_LOGIC_VECTOR ( 31 downto 0 );
    vid_data : out STD_LOGIC_VECTOR ( 23 downto 0 );
    vid_de : out STD_LOGIC;
    vid_hsync : out STD_LOGIC;
    vid_vsync : out STD_LOGIC
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_core_0 : entity is "c6v_core_0,scene2d_c4m7_core,{}";
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of c6v_core_0 : entity is "c6v_core_0,scene2d_c4m7_core,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=scene2d_c4m7_core,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,H_ACTIVE=1280,H_FRONT=110,H_SYNC=40,H_BACK=220,V_ACTIVE=720,V_FRONT=5,V_SYNC=5,V_BACK=20,OUTPUT_SCALE=4,TILE_DESCRIPTOR_CACHE_ENABLE=0,BLIT_PIXEL_PIPELINE_ENABLE=0,TILE_PIXEL_PIPELINE_ENABLE=0,TILE_PIXEL_PAIR_ENABLE=0,BLIT_PIXEL_PAIR_ENABLE=0,CLEAR_FILL_PIXEL_PAIR_ENABLE=0,UPLOAD_RENDER_OVERLAP_ENABLE=0}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_core_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_core_0 : entity is "module_ref";
end c6v_core_0;

architecture stub of c6v_core_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "aclk,aresetn,clk_pixel,resetn_pixel,s_axis_tdata[63:0],s_axis_tkeep[7:0],s_axis_tlast,s_axis_tvalid,s_axis_tready,debug_command_read_address[8:0],debug_command_read_data_low[31:0],debug_command_read_data_high[31:0],upload_crc32[31:0],upload_byte_count[31:0],upload_packet_count[31:0],accepted_packet_count[31:0],rejected_packet_count[31:0],accepted_seq[31:0],accepted_status[31:0],upload_error_flags[5:0],render_completed_seq[31:0],render_completed_count[31:0],render_write_count[31:0],render_trace_crc32[31:0],render_cycles[31:0],render_maximum_cycles[31:0],render_status[31:0],present_completed_seq[31:0],present_completed_count[31:0],framebuffer_status[31:0],overlap_release_toggle,overlap_status[31:0],router_dropped_packet_count[31:0],unsupported_packet_count[31:0],palette_accepted_packet_count[31:0],palette_rejected_packet_count[31:0],palette_generation[31:0],palette_error_flags[8:0],palette_status[31:0],asset_accepted_packet_count[31:0],asset_rejected_packet_count[31:0],asset_generation[31:0],asset_error_flags[8:0],asset_status[31:0],tilemap_accepted_packet_count[31:0],tilemap_rejected_packet_count[31:0],tilemap_generation[31:0],tilemap_error_flags[8:0],tilemap_status[31:0],vid_data[23:0],vid_de,vid_hsync,vid_vsync";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of aclk : signal is "xilinx.com:signal:clock:1.0 aclk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of aclk : signal is "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF s_axis, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of aresetn : signal is "xilinx.com:signal:reset:1.0 aresetn RST";
  attribute X_INTERFACE_MODE of aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of aresetn : signal is "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axis_tdata : signal is "xilinx.com:interface:axis:1.0 s_axis TDATA";
  attribute X_INTERFACE_MODE of s_axis_tdata : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s_axis_tdata : signal is "XIL_INTERFACENAME s_axis, TDATA_NUM_BYTES 8, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axis_tkeep : signal is "xilinx.com:interface:axis:1.0 s_axis TKEEP";
  attribute X_INTERFACE_INFO of s_axis_tlast : signal is "xilinx.com:interface:axis:1.0 s_axis TLAST";
  attribute X_INTERFACE_INFO of s_axis_tvalid : signal is "xilinx.com:interface:axis:1.0 s_axis TVALID";
  attribute X_INTERFACE_INFO of s_axis_tready : signal is "xilinx.com:interface:axis:1.0 s_axis TREADY";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of stub : architecture is "scene2d_c4m7_core,Vivado 2026.1";
begin
end;
