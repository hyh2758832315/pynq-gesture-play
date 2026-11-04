-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 30 22:05:57 2026
-- Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_source_fault_0/c6v_capture_source_fault_0_sim_netlist.vhdl
-- Design      : c6v_capture_source_fault_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_capture_source_fault_0_xpm_cdc_async_rst is
  port (
    src_arst : in STD_LOGIC;
    dest_clk : in STD_LOGIC;
    dest_arst : out STD_LOGIC
  );
  attribute DEF_VAL : string;
  attribute DEF_VAL of c6v_capture_source_fault_0_xpm_cdc_async_rst : entity is "1'b1";
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of c6v_capture_source_fault_0_xpm_cdc_async_rst : entity is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of c6v_capture_source_fault_0_xpm_cdc_async_rst : entity is 0;
  attribute INV_DEF_VAL : string;
  attribute INV_DEF_VAL of c6v_capture_source_fault_0_xpm_cdc_async_rst : entity is "1'b0";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_capture_source_fault_0_xpm_cdc_async_rst : entity is "xpm_cdc_async_rst";
  attribute RST_ACTIVE_HIGH : integer;
  attribute RST_ACTIVE_HIGH of c6v_capture_source_fault_0_xpm_cdc_async_rst : entity is 0;
  attribute VERSION : integer;
  attribute VERSION of c6v_capture_source_fault_0_xpm_cdc_async_rst : entity is 0;
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of c6v_capture_source_fault_0_xpm_cdc_async_rst : entity is "TRUE";
  attribute keep_hierarchy : string;
  attribute keep_hierarchy of c6v_capture_source_fault_0_xpm_cdc_async_rst : entity is "soft";
  attribute xpm_cdc : string;
  attribute xpm_cdc of c6v_capture_source_fault_0_xpm_cdc_async_rst : entity is "ASYNC_RST";
end c6v_capture_source_fault_0_xpm_cdc_async_rst;

architecture STRUCTURE of c6v_capture_source_fault_0_xpm_cdc_async_rst is
  signal arststages_ff : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute RTL_KEEP : string;
  attribute RTL_KEEP of arststages_ff : signal is "true";
  attribute async_reg : string;
  attribute async_reg of arststages_ff : signal is "true";
  attribute xpm_cdc of arststages_ff : signal is "ASYNC_RST";
  signal reset_pol : STD_LOGIC;
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \arststages_ff_reg[0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \arststages_ff_reg[0]\ : label is "true";
  attribute XPM_CDC of \arststages_ff_reg[0]\ : label is "ASYNC_RST";
  attribute ASYNC_REG_boolean of \arststages_ff_reg[1]\ : label is std.standard.true;
  attribute KEEP of \arststages_ff_reg[1]\ : label is "true";
  attribute XPM_CDC of \arststages_ff_reg[1]\ : label is "ASYNC_RST";
  attribute ASYNC_REG_boolean of \arststages_ff_reg[2]\ : label is std.standard.true;
  attribute KEEP of \arststages_ff_reg[2]\ : label is "true";
  attribute XPM_CDC of \arststages_ff_reg[2]\ : label is "ASYNC_RST";
begin
  dest_arst <= arststages_ff(2);
\arststages_ff[2]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => src_arst,
      O => reset_pol
    );
\arststages_ff_reg[0]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '1'
    )
        port map (
      C => dest_clk,
      CE => '1',
      CLR => reset_pol,
      D => '1',
      Q => arststages_ff(0)
    );
\arststages_ff_reg[1]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '1'
    )
        port map (
      C => dest_clk,
      CE => '1',
      CLR => reset_pol,
      D => arststages_ff(0),
      Q => arststages_ff(1)
    );
\arststages_ff_reg[2]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '1'
    )
        port map (
      C => dest_clk,
      CE => '1',
      CLR => reset_pol,
      D => arststages_ff(1),
      Q => arststages_ff(2)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \c6v_capture_source_fault_0_xpm_cdc_async_rst__1\ is
  port (
    src_arst : in STD_LOGIC;
    dest_clk : in STD_LOGIC;
    dest_arst : out STD_LOGIC
  );
  attribute DEF_VAL : string;
  attribute DEF_VAL of \c6v_capture_source_fault_0_xpm_cdc_async_rst__1\ : entity is "1'b1";
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of \c6v_capture_source_fault_0_xpm_cdc_async_rst__1\ : entity is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of \c6v_capture_source_fault_0_xpm_cdc_async_rst__1\ : entity is 0;
  attribute INV_DEF_VAL : string;
  attribute INV_DEF_VAL of \c6v_capture_source_fault_0_xpm_cdc_async_rst__1\ : entity is "1'b0";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \c6v_capture_source_fault_0_xpm_cdc_async_rst__1\ : entity is "xpm_cdc_async_rst";
  attribute RST_ACTIVE_HIGH : integer;
  attribute RST_ACTIVE_HIGH of \c6v_capture_source_fault_0_xpm_cdc_async_rst__1\ : entity is 0;
  attribute VERSION : integer;
  attribute VERSION of \c6v_capture_source_fault_0_xpm_cdc_async_rst__1\ : entity is 0;
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of \c6v_capture_source_fault_0_xpm_cdc_async_rst__1\ : entity is "TRUE";
  attribute keep_hierarchy : string;
  attribute keep_hierarchy of \c6v_capture_source_fault_0_xpm_cdc_async_rst__1\ : entity is "soft";
  attribute xpm_cdc : string;
  attribute xpm_cdc of \c6v_capture_source_fault_0_xpm_cdc_async_rst__1\ : entity is "ASYNC_RST";
end \c6v_capture_source_fault_0_xpm_cdc_async_rst__1\;

architecture STRUCTURE of \c6v_capture_source_fault_0_xpm_cdc_async_rst__1\ is
  signal arststages_ff : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute RTL_KEEP : string;
  attribute RTL_KEEP of arststages_ff : signal is "true";
  attribute async_reg : string;
  attribute async_reg of arststages_ff : signal is "true";
  attribute xpm_cdc of arststages_ff : signal is "ASYNC_RST";
  signal reset_pol : STD_LOGIC;
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \arststages_ff_reg[0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \arststages_ff_reg[0]\ : label is "true";
  attribute XPM_CDC of \arststages_ff_reg[0]\ : label is "ASYNC_RST";
  attribute ASYNC_REG_boolean of \arststages_ff_reg[1]\ : label is std.standard.true;
  attribute KEEP of \arststages_ff_reg[1]\ : label is "true";
  attribute XPM_CDC of \arststages_ff_reg[1]\ : label is "ASYNC_RST";
  attribute ASYNC_REG_boolean of \arststages_ff_reg[2]\ : label is std.standard.true;
  attribute KEEP of \arststages_ff_reg[2]\ : label is "true";
  attribute XPM_CDC of \arststages_ff_reg[2]\ : label is "ASYNC_RST";
begin
  dest_arst <= arststages_ff(2);
\arststages_ff[2]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => src_arst,
      O => reset_pol
    );
\arststages_ff_reg[0]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '1'
    )
        port map (
      C => dest_clk,
      CE => '1',
      CLR => reset_pol,
      D => '1',
      Q => arststages_ff(0)
    );
\arststages_ff_reg[1]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '1'
    )
        port map (
      C => dest_clk,
      CE => '1',
      CLR => reset_pol,
      D => arststages_ff(0),
      Q => arststages_ff(1)
    );
\arststages_ff_reg[2]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '1'
    )
        port map (
      C => dest_clk,
      CE => '1',
      CLR => reset_pol,
      D => arststages_ff(1),
      Q => arststages_ff(2)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_capture_source_fault_0_vision_source_fault_cdc is
  port (
    fault_status : out STD_LOGIC_VECTOR ( 1 downto 0 );
    capture_aresetn : out STD_LOGIC;
    source_fault : out STD_LOGIC;
    common_aresetn : in STD_LOGIC;
    vid_io_in_clk : in STD_LOGIC;
    aclk : in STD_LOGIC;
    aclk_underflow : in STD_LOGIC;
    video_overflow : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_capture_source_fault_0_vision_source_fault_cdc : entity is "vision_source_fault_cdc";
end c6v_capture_source_fault_0_vision_source_fault_cdc;

architecture STRUCTURE of c6v_capture_source_fault_0_vision_source_fault_cdc is
  signal aclk_resetn : STD_LOGIC;
  signal armed_sync : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg : string;
  attribute async_reg of armed_sync : signal is "true";
  attribute shreg_extract : string;
  attribute shreg_extract of armed_sync : signal is "no";
  signal capture_aresetn_i_1_n_0 : STD_LOGIC;
  signal \^fault_status\ : STD_LOGIC_VECTOR ( 1 to 1 );
  signal overflow_latched_i_1_n_0 : STD_LOGIC;
  signal overflow_sync : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg of overflow_sync : signal is "true";
  attribute shreg_extract of overflow_sync : signal is "no";
  signal p_0_in : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \p_0_in__0\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal underflow_latched_i_1_n_0 : STD_LOGIC;
  signal video_armed_i_1_n_0 : STD_LOGIC;
  signal video_resetn : STD_LOGIC;
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \armed_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \armed_sync_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \armed_sync_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \armed_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \armed_sync_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \armed_sync_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \armed_sync_reg[2]\ : label is std.standard.true;
  attribute KEEP of \armed_sync_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \armed_sync_reg[2]\ : label is "NO";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of capture_aresetn_reg : label is "xilinx.com:signal:reset:1.0 capture_aresetn RST";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of capture_aresetn_reg : label is "POLARITY ACTIVE_LOW";
  attribute ASYNC_REG_boolean of \overflow_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP of \overflow_sync_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \overflow_sync_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \overflow_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \overflow_sync_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \overflow_sync_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \overflow_sync_reg[2]\ : label is std.standard.true;
  attribute KEEP of \overflow_sync_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \overflow_sync_reg[2]\ : label is "NO";
  attribute DEF_VAL : string;
  attribute DEF_VAL of processing_reset : label is "1'b1";
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of processing_reset : label is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of processing_reset : label is 0;
  attribute INV_DEF_VAL : string;
  attribute INV_DEF_VAL of processing_reset : label is "1'b0";
  attribute RST_ACTIVE_HIGH : integer;
  attribute RST_ACTIVE_HIGH of processing_reset : label is 0;
  attribute VERSION : integer;
  attribute VERSION of processing_reset : label is 0;
  attribute XPM_CDC : string;
  attribute XPM_CDC of processing_reset : label is "ASYNC_RST";
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of processing_reset : label is "TRUE";
  attribute DEF_VAL of video_reset : label is "1'b1";
  attribute DEST_SYNC_FF of video_reset : label is 3;
  attribute INIT_SYNC_FF of video_reset : label is 0;
  attribute INV_DEF_VAL of video_reset : label is "1'b0";
  attribute RST_ACTIVE_HIGH of video_reset : label is 0;
  attribute VERSION of video_reset : label is 0;
  attribute XPM_CDC of video_reset : label is "ASYNC_RST";
  attribute XPM_MODULE of video_reset : label is "TRUE";
begin
  fault_status(1) <= \^fault_status\(1);
  fault_status(0) <= overflow_sync(2);
\armed_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => capture_aresetn_i_1_n_0,
      D => p_0_in(0),
      Q => armed_sync(0)
    );
\armed_sync_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => capture_aresetn_i_1_n_0,
      D => armed_sync(0),
      Q => armed_sync(1)
    );
\armed_sync_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => capture_aresetn_i_1_n_0,
      D => armed_sync(1),
      Q => armed_sync(2)
    );
capture_aresetn_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => aclk_resetn,
      O => capture_aresetn_i_1_n_0
    );
capture_aresetn_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => capture_aresetn_i_1_n_0,
      D => armed_sync(2),
      Q => capture_aresetn
    );
overflow_latched_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => video_overflow,
      I1 => \p_0_in__0\(0),
      O => overflow_latched_i_1_n_0
    );
overflow_latched_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => video_armed_i_1_n_0,
      D => overflow_latched_i_1_n_0,
      Q => \p_0_in__0\(0)
    );
\overflow_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => capture_aresetn_i_1_n_0,
      D => \p_0_in__0\(0),
      Q => overflow_sync(0)
    );
\overflow_sync_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => capture_aresetn_i_1_n_0,
      D => overflow_sync(0),
      Q => overflow_sync(1)
    );
\overflow_sync_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => capture_aresetn_i_1_n_0,
      D => overflow_sync(1),
      Q => overflow_sync(2)
    );
processing_reset: entity work.c6v_capture_source_fault_0_xpm_cdc_async_rst
     port map (
      dest_arst => aclk_resetn,
      dest_clk => aclk,
      src_arst => common_aresetn
    );
\source_fault__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAA8"
    )
        port map (
      I0 => aclk_resetn,
      I1 => aclk_underflow,
      I2 => overflow_sync(2),
      I3 => \^fault_status\(1),
      O => source_fault
    );
underflow_latched_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => aclk_underflow,
      I1 => \^fault_status\(1),
      O => underflow_latched_i_1_n_0
    );
underflow_latched_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => capture_aresetn_i_1_n_0,
      D => underflow_latched_i_1_n_0,
      Q => \^fault_status\(1)
    );
video_armed_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => video_resetn,
      O => video_armed_i_1_n_0
    );
video_armed_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => video_armed_i_1_n_0,
      D => '1',
      Q => p_0_in(0)
    );
video_reset: entity work.\c6v_capture_source_fault_0_xpm_cdc_async_rst__1\
     port map (
      dest_arst => video_resetn,
      dest_clk => vid_io_in_clk,
      src_arst => common_aresetn
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_capture_source_fault_0 is
  port (
    vid_io_in_clk : in STD_LOGIC;
    aclk : in STD_LOGIC;
    common_aresetn : in STD_LOGIC;
    video_overflow : in STD_LOGIC;
    aclk_underflow : in STD_LOGIC;
    capture_aresetn : out STD_LOGIC;
    source_fault : out STD_LOGIC;
    fault_status : out STD_LOGIC_VECTOR ( 1 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of c6v_capture_source_fault_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_capture_source_fault_0 : entity is "c6v_capture_source_fault_0,vision_source_fault_cdc,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_capture_source_fault_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_capture_source_fault_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of c6v_capture_source_fault_0 : entity is "vision_source_fault_cdc,Vivado 2026.1";
end c6v_capture_source_fault_0;

architecture STRUCTURE of c6v_capture_source_fault_0 is
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of aclk : signal is "xilinx.com:signal:clock:1.0 aclk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of aclk : signal is "XIL_INTERFACENAME aclk, ASSOCIATED_RESET capture_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of capture_aresetn : signal is "xilinx.com:signal:reset:1.0 capture_aresetn RST";
  attribute X_INTERFACE_MODE of capture_aresetn : signal is "master";
  attribute X_INTERFACE_PARAMETER of capture_aresetn : signal is "XIL_INTERFACENAME capture_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of common_aresetn : signal is "xilinx.com:signal:reset:1.0 common_aresetn RST";
  attribute X_INTERFACE_MODE of common_aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of common_aresetn : signal is "XIL_INTERFACENAME common_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of vid_io_in_clk : signal is "xilinx.com:signal:clock:1.0 vid_io_in_clk CLK";
  attribute X_INTERFACE_MODE of vid_io_in_clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER of vid_io_in_clk : signal is "XIL_INTERFACENAME vid_io_in_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0";
begin
inst: entity work.c6v_capture_source_fault_0_vision_source_fault_cdc
     port map (
      aclk => aclk,
      aclk_underflow => aclk_underflow,
      capture_aresetn => capture_aresetn,
      common_aresetn => common_aresetn,
      fault_status(1 downto 0) => fault_status(1 downto 0),
      source_fault => source_fault,
      vid_io_in_clk => vid_io_in_clk,
      video_overflow => video_overflow
    );
end STRUCTURE;
