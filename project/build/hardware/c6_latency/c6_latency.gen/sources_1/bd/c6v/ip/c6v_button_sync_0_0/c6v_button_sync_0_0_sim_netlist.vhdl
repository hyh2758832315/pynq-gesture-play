-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 30 22:07:48 2026
-- Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_button_sync_0_0/c6v_button_sync_0_0_sim_netlist.vhdl
-- Design      : c6v_button_sync_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_button_sync_0_0_button_sync is
  port (
    btn_sync : out STD_LOGIC_VECTOR ( 1 downto 0 );
    btn : in STD_LOGIC_VECTOR ( 1 downto 0 );
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_button_sync_0_0_button_sync : entity is "button_sync";
end c6v_button_sync_0_0_button_sync;

architecture STRUCTURE of c6v_button_sync_0_0_button_sync is
  signal meta : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute async_reg : string;
  attribute async_reg of meta : signal is "true";
  signal \meta[1]_i_1_n_0\ : STD_LOGIC;
  signal stable : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute async_reg of stable : signal is "true";
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \meta_reg[0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \meta_reg[0]\ : label is "yes";
  attribute ASYNC_REG_boolean of \meta_reg[1]\ : label is std.standard.true;
  attribute KEEP of \meta_reg[1]\ : label is "yes";
  attribute ASYNC_REG_boolean of \stable_reg[0]\ : label is std.standard.true;
  attribute KEEP of \stable_reg[0]\ : label is "yes";
  attribute ASYNC_REG_boolean of \stable_reg[1]\ : label is std.standard.true;
  attribute KEEP of \stable_reg[1]\ : label is "yes";
begin
  btn_sync(1 downto 0) <= stable(1 downto 0);
\meta[1]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => aresetn,
      O => \meta[1]_i_1_n_0\
    );
\meta_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \meta[1]_i_1_n_0\,
      D => btn(0),
      Q => meta(0)
    );
\meta_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \meta[1]_i_1_n_0\,
      D => btn(1),
      Q => meta(1)
    );
\stable_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \meta[1]_i_1_n_0\,
      D => meta(0),
      Q => stable(0)
    );
\stable_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \meta[1]_i_1_n_0\,
      D => meta(1),
      Q => stable(1)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_button_sync_0_0 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    btn : in STD_LOGIC_VECTOR ( 1 downto 0 );
    btn_sync : out STD_LOGIC_VECTOR ( 1 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of c6v_button_sync_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_button_sync_0_0 : entity is "c6v_button_sync_0_0,button_sync,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_button_sync_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_button_sync_0_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of c6v_button_sync_0_0 : entity is "button_sync,Vivado 2026.1";
end c6v_button_sync_0_0;

architecture STRUCTURE of c6v_button_sync_0_0 is
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of aclk : signal is "xilinx.com:signal:clock:1.0 aclk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of aclk : signal is "XIL_INTERFACENAME aclk, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of aresetn : signal is "xilinx.com:signal:reset:1.0 aresetn RST";
  attribute X_INTERFACE_MODE of aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of aresetn : signal is "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
begin
inst: entity work.c6v_button_sync_0_0_button_sync
     port map (
      aclk => aclk,
      aresetn => aresetn,
      btn(1 downto 0) => btn(1 downto 0),
      btn_sync(1 downto 0) => btn_sync(1 downto 0)
    );
end STRUCTURE;
