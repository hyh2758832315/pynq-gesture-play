-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 30 22:05:57 2026
-- Host        : build-host running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_source_fault_0/c6v_capture_source_fault_0_stub.vhdl
-- Design      : c6v_capture_source_fault_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity c6v_capture_source_fault_0 is
  Port ( 
    vid_io_in_clk : in STD_LOGIC;
    aclk : in STD_LOGIC;
    common_aresetn : in STD_LOGIC;
    video_overflow : in STD_LOGIC;
    aclk_underflow : in STD_LOGIC;
    capture_aresetn : out STD_LOGIC;
    source_fault : out STD_LOGIC;
    fault_status : out STD_LOGIC_VECTOR ( 1 downto 0 )
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_capture_source_fault_0 : entity is "c6v_capture_source_fault_0,vision_source_fault_cdc,{}";
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of c6v_capture_source_fault_0 : entity is "c6v_capture_source_fault_0,vision_source_fault_cdc,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=vision_source_fault_cdc,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_capture_source_fault_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_capture_source_fault_0 : entity is "module_ref";
end c6v_capture_source_fault_0;

architecture stub of c6v_capture_source_fault_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "vid_io_in_clk,aclk,common_aresetn,video_overflow,aclk_underflow,capture_aresetn,source_fault,fault_status[1:0]";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of vid_io_in_clk : signal is "xilinx.com:signal:clock:1.0 vid_io_in_clk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of vid_io_in_clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of vid_io_in_clk : signal is "XIL_INTERFACENAME vid_io_in_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of aclk : signal is "xilinx.com:signal:clock:1.0 aclk CLK";
  attribute X_INTERFACE_MODE of aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER of aclk : signal is "XIL_INTERFACENAME aclk, ASSOCIATED_RESET capture_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of common_aresetn : signal is "xilinx.com:signal:reset:1.0 common_aresetn RST";
  attribute X_INTERFACE_MODE of common_aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of common_aresetn : signal is "XIL_INTERFACENAME common_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of capture_aresetn : signal is "xilinx.com:signal:reset:1.0 capture_aresetn RST";
  attribute X_INTERFACE_MODE of capture_aresetn : signal is "master";
  attribute X_INTERFACE_PARAMETER of capture_aresetn : signal is "XIL_INTERFACENAME capture_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of stub : architecture is "vision_source_fault_cdc,Vivado 2026.1";
begin
end;
