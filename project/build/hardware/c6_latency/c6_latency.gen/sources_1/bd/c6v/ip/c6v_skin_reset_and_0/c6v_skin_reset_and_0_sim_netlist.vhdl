-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Thu Oct 22 03:32:59 2026
-- Host        : build-host running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top c6v_skin_reset_and_0 -prefix
--               c6v_skin_reset_and_0_ c6v_skin_reset_and_0_sim_netlist.vhdl
-- Design      : c6v_skin_reset_and_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_skin_reset_and_0 is
  port (
    Op1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    Op2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    Res : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of c6v_skin_reset_and_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_skin_reset_and_0 : entity is "c6v_skin_reset_and_0,util_vector_logic_v2_0_5_util_vector_logic,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_skin_reset_and_0 : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of c6v_skin_reset_and_0 : entity is "util_vector_logic_v2_0_5_util_vector_logic,Vivado 2026.1";
end c6v_skin_reset_and_0;

architecture STRUCTURE of c6v_skin_reset_and_0 is
begin
\Res[0]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => Op1(0),
      I1 => Op2(0),
      O => Res(0)
    );
end STRUCTURE;
