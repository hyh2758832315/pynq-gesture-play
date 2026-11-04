-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 30 22:06:10 2026
-- Host        : build-host running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_status_inputs_0/c6v_capture_status_inputs_0_sim_netlist.vhdl
-- Design      : c6v_capture_status_inputs_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_capture_status_inputs_0 is
  port (
    frame_context : in STD_LOGIC_VECTOR ( 143 downto 0 );
    source_fault_status : in STD_LOGIC_VECTOR ( 1 downto 0 );
    capture_fault : in STD_LOGIC;
    capture_epoch : out STD_LOGIC_VECTOR ( 31 downto 0 );
    fault_causes : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of c6v_capture_status_inputs_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_capture_status_inputs_0 : entity is "c6v_capture_status_inputs_0,vision_capture_status_inputs,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_capture_status_inputs_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_capture_status_inputs_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of c6v_capture_status_inputs_0 : entity is "vision_capture_status_inputs,Vivado 2026.1";
end c6v_capture_status_inputs_0;

architecture STRUCTURE of c6v_capture_status_inputs_0 is
  signal \^capture_fault\ : STD_LOGIC;
  signal \^frame_context\ : STD_LOGIC_VECTOR ( 143 downto 0 );
  signal \^source_fault_status\ : STD_LOGIC_VECTOR ( 1 downto 0 );
begin
  \^capture_fault\ <= capture_fault;
  \^frame_context\(143 downto 112) <= frame_context(143 downto 112);
  \^source_fault_status\(1 downto 0) <= source_fault_status(1 downto 0);
  capture_epoch(31 downto 0) <= \^frame_context\(143 downto 112);
  fault_causes(2) <= \^capture_fault\;
  fault_causes(1 downto 0) <= \^source_fault_status\(1 downto 0);
end STRUCTURE;
