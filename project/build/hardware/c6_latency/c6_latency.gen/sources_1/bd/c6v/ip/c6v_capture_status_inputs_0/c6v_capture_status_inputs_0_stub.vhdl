-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 30 22:06:10 2026
-- Host        : build-host running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_status_inputs_0/c6v_capture_status_inputs_0_stub.vhdl
-- Design      : c6v_capture_status_inputs_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity c6v_capture_status_inputs_0 is
  Port ( 
    frame_context : in STD_LOGIC_VECTOR ( 143 downto 0 );
    source_fault_status : in STD_LOGIC_VECTOR ( 1 downto 0 );
    capture_fault : in STD_LOGIC;
    capture_epoch : out STD_LOGIC_VECTOR ( 31 downto 0 );
    fault_causes : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_capture_status_inputs_0 : entity is "c6v_capture_status_inputs_0,vision_capture_status_inputs,{}";
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of c6v_capture_status_inputs_0 : entity is "c6v_capture_status_inputs_0,vision_capture_status_inputs,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=vision_capture_status_inputs,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_capture_status_inputs_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_capture_status_inputs_0 : entity is "module_ref";
end c6v_capture_status_inputs_0;

architecture stub of c6v_capture_status_inputs_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "frame_context[143:0],source_fault_status[1:0],capture_fault,capture_epoch[31:0],fault_causes[2:0]";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of stub : architecture is "vision_capture_status_inputs,Vivado 2026.1";
begin
end;
