-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 23 06:47:22 2026
-- Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               e:/vvl/c0e/c6_latency.gen/sources_1/bd/c6v/ip/c6v_input_osd_0_0/c6v_input_osd_0_0_sim_netlist.vhdl
-- Design      : c6v_input_osd_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_input_osd_0_0_input_osd_ctrl is
  port (
    SR : out STD_LOGIC_VECTOR ( 0 to 0 );
    bvalid_reg_0 : out STD_LOGIC;
    w_held_reg_0 : out STD_LOGIC;
    aw_held_reg_0 : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    rvalid_reg_0 : out STD_LOGIC;
    hand10 : out STD_LOGIC;
    af : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 52 downto 0 );
    S : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \active_cfg_reg[42]_0\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \active_cfg_reg[55]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \active_cfg_reg[57]_0\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    \active_cfg_reg[57]_1\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    \aw_addr_reg[1]_0\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awready : out STD_LOGIC;
    \aw_addr_reg[5]_0\ : out STD_LOGIC;
    mailbox116_out : out STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    \w_data_reg[0]_0\ : out STD_LOGIC;
    pclk : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    bvalid_reg_1 : in STD_LOGIC;
    \bresp_reg[1]_0\ : in STD_LOGIC;
    rvalid_reg_1 : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    \out\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    rvalid_reg_2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_awvalid : in STD_LOGIC;
    in_vs : in STD_LOGIC;
    vs_prev : in STD_LOGIC;
    \audio_left_reg[5]_0\ : in STD_LOGIC;
    ack_toggle_reg_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    ack_toggle_reg_1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    \dx12_carry__0\ : in STD_LOGIC_VECTOR ( 10 downto 0 );
    \dy1_reg[9]\ : in STD_LOGIC_VECTOR ( 9 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_input_osd_0_0_input_osd_ctrl : entity is "input_osd_ctrl";
end c6v_input_osd_0_0_input_osd_ctrl;

architecture STRUCTURE of c6v_input_osd_0_0_input_osd_ctrl is
  signal \^q\ : STD_LOGIC_VECTOR ( 52 downto 0 );
  signal \^sr\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ack_meta : STD_LOGIC;
  attribute async_reg : string;
  attribute async_reg of ack_meta : signal is "true";
  signal ack_sync : STD_LOGIC;
  attribute async_reg of ack_sync : signal is "true";
  signal ack_toggle_reg_n_0 : STD_LOGIC;
  signal \active_cfg[191]_i_1_n_0\ : STD_LOGIC;
  signal audio_left : STD_LOGIC_VECTOR ( 0 to 0 );
  signal audio_left1 : STD_LOGIC;
  signal \audio_left1_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \audio_left1_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \audio_left1_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \audio_left1_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \audio_left1_carry__0_n_0\ : STD_LOGIC;
  signal \audio_left1_carry__0_n_1\ : STD_LOGIC;
  signal \audio_left1_carry__0_n_2\ : STD_LOGIC;
  signal \audio_left1_carry__0_n_3\ : STD_LOGIC;
  signal \audio_left1_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \audio_left1_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \audio_left1_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \audio_left1_carry__1_n_2\ : STD_LOGIC;
  signal \audio_left1_carry__1_n_3\ : STD_LOGIC;
  signal audio_left1_carry_i_1_n_0 : STD_LOGIC;
  signal audio_left1_carry_i_2_n_0 : STD_LOGIC;
  signal audio_left1_carry_i_3_n_0 : STD_LOGIC;
  signal audio_left1_carry_i_4_n_0 : STD_LOGIC;
  signal audio_left1_carry_n_0 : STD_LOGIC;
  signal audio_left1_carry_n_1 : STD_LOGIC;
  signal audio_left1_carry_n_2 : STD_LOGIC;
  signal audio_left1_carry_n_3 : STD_LOGIC;
  signal \audio_left[0]_i_1_n_0\ : STD_LOGIC;
  signal \audio_left[1]_i_1_n_0\ : STD_LOGIC;
  signal \audio_left[2]_i_1_n_0\ : STD_LOGIC;
  signal \audio_left[2]_i_2_n_0\ : STD_LOGIC;
  signal \audio_left[3]_i_1_n_0\ : STD_LOGIC;
  signal \audio_left[4]_i_1_n_0\ : STD_LOGIC;
  signal \audio_left[4]_i_2_n_0\ : STD_LOGIC;
  signal \audio_left[5]_i_1_n_0\ : STD_LOGIC;
  signal \audio_left[5]_i_2_n_0\ : STD_LOGIC;
  signal \audio_left[6]_i_1_n_0\ : STD_LOGIC;
  signal \audio_left[7]_i_1_n_0\ : STD_LOGIC;
  signal \audio_left[7]_i_3_n_0\ : STD_LOGIC;
  signal \audio_left[7]_i_4_n_0\ : STD_LOGIC;
  signal \audio_left[7]_i_5_n_0\ : STD_LOGIC;
  signal \audio_left[7]_i_6_n_0\ : STD_LOGIC;
  signal \audio_left[7]_i_7_n_0\ : STD_LOGIC;
  signal \audio_left_reg_n_0_[0]\ : STD_LOGIC;
  signal \audio_left_reg_n_0_[1]\ : STD_LOGIC;
  signal \audio_left_reg_n_0_[2]\ : STD_LOGIC;
  signal \audio_left_reg_n_0_[3]\ : STD_LOGIC;
  signal \audio_left_reg_n_0_[4]\ : STD_LOGIC;
  signal \audio_left_reg_n_0_[5]\ : STD_LOGIC;
  signal \audio_left_reg_n_0_[6]\ : STD_LOGIC;
  signal \audio_left_reg_n_0_[7]\ : STD_LOGIC;
  signal aw_addr : STD_LOGIC_VECTOR ( 6 downto 2 );
  signal \^aw_addr_reg[1]_0\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^aw_addr_reg[5]_0\ : STD_LOGIC;
  signal aw_held0 : STD_LOGIC;
  signal aw_held_i_1_n_0 : STD_LOGIC;
  signal \^aw_held_reg_0\ : STD_LOGIC;
  signal \bresp[1]_i_1_n_0\ : STD_LOGIC;
  signal \bresp[1]_i_6_n_0\ : STD_LOGIC;
  signal \^bvalid_reg_0\ : STD_LOGIC;
  signal cfg : STD_LOGIC_VECTOR ( 191 downto 1 );
  signal hand1_i_2_n_0 : STD_LOGIC;
  signal hand1_i_3_n_0 : STD_LOGIC;
  signal hand_left : STD_LOGIC_VECTOR ( 0 to 0 );
  signal hand_left1 : STD_LOGIC;
  signal \hand_left1_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \hand_left1_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \hand_left1_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \hand_left1_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \hand_left1_carry__0_n_0\ : STD_LOGIC;
  signal \hand_left1_carry__0_n_1\ : STD_LOGIC;
  signal \hand_left1_carry__0_n_2\ : STD_LOGIC;
  signal \hand_left1_carry__0_n_3\ : STD_LOGIC;
  signal \hand_left1_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \hand_left1_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \hand_left1_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \hand_left1_carry__1_n_2\ : STD_LOGIC;
  signal \hand_left1_carry__1_n_3\ : STD_LOGIC;
  signal hand_left1_carry_i_1_n_0 : STD_LOGIC;
  signal hand_left1_carry_i_2_n_0 : STD_LOGIC;
  signal hand_left1_carry_i_3_n_0 : STD_LOGIC;
  signal hand_left1_carry_i_4_n_0 : STD_LOGIC;
  signal hand_left1_carry_n_0 : STD_LOGIC;
  signal hand_left1_carry_n_1 : STD_LOGIC;
  signal hand_left1_carry_n_2 : STD_LOGIC;
  signal hand_left1_carry_n_3 : STD_LOGIC;
  signal \hand_left[0]_i_1_n_0\ : STD_LOGIC;
  signal \hand_left[1]_i_1_n_0\ : STD_LOGIC;
  signal \hand_left[2]_i_1_n_0\ : STD_LOGIC;
  signal \hand_left[3]_i_1_n_0\ : STD_LOGIC;
  signal \hand_left[3]_i_2_n_0\ : STD_LOGIC;
  signal \hand_left[3]_i_3_n_0\ : STD_LOGIC;
  signal \hand_left[4]_i_2_n_0\ : STD_LOGIC;
  signal \hand_left[5]_i_2_n_0\ : STD_LOGIC;
  signal \hand_left[7]_i_1_n_0\ : STD_LOGIC;
  signal \hand_left[7]_i_4_n_0\ : STD_LOGIC;
  signal \hand_left[7]_i_5_n_0\ : STD_LOGIC;
  signal \hand_left[7]_i_6_n_0\ : STD_LOGIC;
  signal \hand_left_reg_n_0_[0]\ : STD_LOGIC;
  signal \hand_left_reg_n_0_[1]\ : STD_LOGIC;
  signal \hand_left_reg_n_0_[2]\ : STD_LOGIC;
  signal \hand_left_reg_n_0_[3]\ : STD_LOGIC;
  signal \hand_left_reg_n_0_[4]\ : STD_LOGIC;
  signal \hand_left_reg_n_0_[5]\ : STD_LOGIC;
  signal \hand_left_reg_n_0_[6]\ : STD_LOGIC;
  signal \hand_left_reg_n_0_[7]\ : STD_LOGIC;
  signal \mailbox[191]_i_2_n_0\ : STD_LOGIC;
  signal \mailbox[191]_i_3_n_0\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[0]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[100]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[101]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[102]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[103]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[104]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[105]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[112]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[113]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[114]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[115]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[116]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[117]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[118]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[119]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[120]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[121]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[122]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[123]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[124]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[125]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[126]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[127]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[128]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[129]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[130]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[131]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[132]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[133]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[134]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[135]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[136]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[137]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[138]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[139]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[140]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[141]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[142]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[143]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[144]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[145]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[146]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[147]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[148]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[149]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[150]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[151]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[152]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[153]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[154]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[155]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[156]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[157]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[158]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[159]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[160]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[161]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[162]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[163]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[164]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[165]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[166]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[167]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[168]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[169]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[170]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[171]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[172]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[173]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[174]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[175]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[176]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[177]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[178]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[179]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[180]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[181]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[182]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[183]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[184]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[185]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[186]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[187]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[188]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[189]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[190]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[191]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[1]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[2]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[32]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[33]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[34]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[35]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[36]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[37]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[38]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[39]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[3]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[40]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[41]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[42]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[48]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[49]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[50]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[51]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[52]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[53]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[54]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[55]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[56]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[57]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[64]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[65]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[66]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[67]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[68]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[69]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[70]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[71]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[72]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[73]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[80]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[81]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[82]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[83]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[84]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[85]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[86]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[87]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[88]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[89]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[96]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[97]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[98]\ : STD_LOGIC;
  signal \mailbox_reg_n_0_[99]\ : STD_LOGIC;
  signal p_1_in : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal p_1_in1_in : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal p_2_in : STD_LOGIC_VECTOR ( 7 downto 4 );
  signal pending : STD_LOGIC;
  signal \pending_cfg[191]_i_1_n_0\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[0]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[100]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[101]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[102]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[103]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[104]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[105]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[112]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[113]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[114]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[115]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[116]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[117]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[118]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[119]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[120]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[121]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[122]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[123]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[124]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[125]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[126]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[127]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[1]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[2]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[32]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[33]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[34]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[35]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[36]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[37]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[38]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[39]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[3]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[40]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[41]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[42]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[48]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[49]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[50]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[51]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[52]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[53]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[54]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[55]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[56]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[57]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[64]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[65]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[66]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[67]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[68]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[69]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[70]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[71]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[72]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[73]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[80]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[81]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[82]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[83]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[84]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[85]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[86]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[87]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[88]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[89]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[96]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[97]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[98]\ : STD_LOGIC;
  signal \pending_cfg_reg_n_0_[99]\ : STD_LOGIC;
  signal pending_i_1_n_0 : STD_LOGIC;
  signal \rdata[0]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[0]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[0]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[0]_i_4_n_0\ : STD_LOGIC;
  signal \rdata[0]_i_5_n_0\ : STD_LOGIC;
  signal \rdata[10]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[10]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[10]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[10]_i_4_n_0\ : STD_LOGIC;
  signal \rdata[10]_i_5_n_0\ : STD_LOGIC;
  signal \rdata[11]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[11]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[11]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[12]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[12]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[12]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[13]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[13]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[13]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[14]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[14]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[14]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[14]_i_4_n_0\ : STD_LOGIC;
  signal \rdata[15]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[15]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[15]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[16]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[16]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[16]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[16]_i_4_n_0\ : STD_LOGIC;
  signal \rdata[17]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[17]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[17]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[18]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[18]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[18]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[19]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[19]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[19]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[1]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[1]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[1]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[20]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[20]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[20]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[20]_i_4_n_0\ : STD_LOGIC;
  signal \rdata[21]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[21]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[21]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[22]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[22]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[22]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[22]_i_4_n_0\ : STD_LOGIC;
  signal \rdata[23]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[23]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[23]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[24]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[24]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[24]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[25]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[25]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[25]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[26]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[26]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[26]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[27]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[27]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[27]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[27]_i_4_n_0\ : STD_LOGIC;
  signal \rdata[27]_i_5_n_0\ : STD_LOGIC;
  signal \rdata[28]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[28]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[28]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[29]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[29]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[29]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[2]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[2]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[2]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[30]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[30]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[30]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[30]_i_4_n_0\ : STD_LOGIC;
  signal \rdata[31]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[31]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[31]_i_4_n_0\ : STD_LOGIC;
  signal \rdata[31]_i_5_n_0\ : STD_LOGIC;
  signal \rdata[31]_i_6_n_0\ : STD_LOGIC;
  signal \rdata[3]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[3]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[3]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[4]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[4]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[4]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[5]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[5]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[5]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[6]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[6]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[6]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[7]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[7]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[7]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[8]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[8]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[8]_i_3_n_0\ : STD_LOGIC;
  signal \rdata[9]_i_1_n_0\ : STD_LOGIC;
  signal \rdata[9]_i_2_n_0\ : STD_LOGIC;
  signal \rdata[9]_i_3_n_0\ : STD_LOGIC;
  signal req_meta : STD_LOGIC;
  attribute async_reg of req_meta : signal is "true";
  signal req_sync : STD_LOGIC;
  attribute async_reg of req_sync : signal is "true";
  signal req_toggle6_out : STD_LOGIC;
  signal req_toggle_i_1_n_0 : STD_LOGIC;
  signal req_toggle_reg_n_0 : STD_LOGIC;
  signal \rresp[1]_i_1_n_0\ : STD_LOGIC;
  signal \rresp[1]_i_2_n_0\ : STD_LOGIC;
  signal rvalid010_out : STD_LOGIC;
  signal \^rvalid_reg_0\ : STD_LOGIC;
  signal \^s_axi_rresp\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \shadow[0][15]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[0][15]_i_2_n_0\ : STD_LOGIC;
  signal \shadow[0][23]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[0][23]_i_2_n_0\ : STD_LOGIC;
  signal \shadow[0][31]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[0][31]_i_2_n_0\ : STD_LOGIC;
  signal \shadow[0][31]_i_3_n_0\ : STD_LOGIC;
  signal \shadow[0][7]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[0][7]_i_2_n_0\ : STD_LOGIC;
  signal \shadow[1][15]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[1][23]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[1][31]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[1][7]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[2][15]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[2][23]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[2][31]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[2][7]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[3][15]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[3][23]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[3][31]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[3][7]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[4][15]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[4][23]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[4][31]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[4][7]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[5][15]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[5][23]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[5][31]_i_1_n_0\ : STD_LOGIC;
  signal \shadow[5][7]_i_1_n_0\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][0]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][10]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][11]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][12]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][13]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][14]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][15]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][16]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][17]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][18]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][19]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][1]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][20]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][21]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][22]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][23]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][24]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][25]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][26]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][27]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][28]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][29]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][2]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][30]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][31]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][3]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][4]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][5]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][6]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][7]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][8]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[0][9]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][0]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][10]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][11]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][12]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][13]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][14]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][15]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][16]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][17]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][18]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][19]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][1]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][20]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][21]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][22]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][23]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][24]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][25]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][26]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][27]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][28]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][29]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][2]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][30]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][31]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][3]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][4]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][5]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][6]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][7]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][8]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[1][9]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][0]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][10]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][11]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][12]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][13]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][14]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][15]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][16]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][17]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][18]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][19]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][1]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][20]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][21]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][22]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][23]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][24]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][25]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][26]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][27]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][28]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][29]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][2]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][30]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][31]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][3]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][4]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][5]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][6]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][7]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][8]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[2][9]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][0]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][10]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][11]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][12]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][13]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][14]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][15]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][16]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][17]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][18]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][19]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][1]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][20]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][21]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][22]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][23]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][24]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][25]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][26]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][27]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][28]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][29]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][2]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][30]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][31]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][3]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][4]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][5]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][6]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][7]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][8]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[3][9]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][0]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][10]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][11]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][12]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][13]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][14]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][15]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][16]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][17]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][18]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][19]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][1]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][20]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][21]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][22]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][23]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][24]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][25]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][26]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][27]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][28]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][29]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][2]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][30]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][31]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][3]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][4]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][5]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][6]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][7]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][8]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[4][9]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][0]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][10]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][11]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][12]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][13]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][14]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][15]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][16]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][17]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][18]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][19]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][1]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][20]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][21]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][22]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][23]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][24]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][25]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][26]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][27]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][28]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][29]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][2]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][30]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][31]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][3]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][4]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][5]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][6]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][7]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][8]\ : STD_LOGIC;
  signal \shadow_reg_n_0_[5][9]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[0]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[10]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[11]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[12]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[13]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[14]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[15]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[16]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[17]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[18]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[19]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[1]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[20]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[21]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[22]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[23]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[24]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[25]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[26]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[27]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[28]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[29]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[2]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[30]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[31]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[3]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[4]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[5]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[6]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[7]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[8]\ : STD_LOGIC;
  signal \w_data_reg_n_0_[9]\ : STD_LOGIC;
  signal w_held0 : STD_LOGIC;
  signal w_held_i_1_n_0 : STD_LOGIC;
  signal \^w_held_reg_0\ : STD_LOGIC;
  signal \w_strb_reg_n_0_[0]\ : STD_LOGIC;
  signal \w_strb_reg_n_0_[1]\ : STD_LOGIC;
  signal \w_strb_reg_n_0_[2]\ : STD_LOGIC;
  signal \w_strb_reg_n_0_[3]\ : STD_LOGIC;
  signal NLW_audio_left1_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_audio_left1_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_audio_left1_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_audio_left1_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_hand_left1_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_hand_left1_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_hand_left1_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_hand_left1_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of ack_meta_reg : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of ack_meta_reg : label is "yes";
  attribute ASYNC_REG_boolean of ack_sync_reg : label is std.standard.true;
  attribute KEEP of ack_sync_reg : label is "yes";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \audio_left[0]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \audio_left[2]_i_2\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \audio_left[4]_i_2\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \audio_left[5]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \audio_left[5]_i_2\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \audio_left[7]_i_6\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \bresp[1]_i_5\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \hand_left[4]_i_2\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \hand_left[5]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \hand_left[5]_i_2\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \hand_left[7]_i_6\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \mailbox[191]_i_3\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \rdata[10]_i_4\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \rdata[10]_i_5\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \rdata[16]_i_3\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \rdata[27]_i_3\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \rdata[27]_i_5\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \rdata[30]_i_2\ : label is "soft_lutpair6";
  attribute ASYNC_REG_boolean of req_meta_reg : label is std.standard.true;
  attribute KEEP of req_meta_reg : label is "yes";
  attribute ASYNC_REG_boolean of req_sync_reg : label is std.standard.true;
  attribute KEEP of req_sync_reg : label is "yes";
  attribute SOFT_HLUTNM of \rresp[1]_i_2\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of s_axi_arready_INST_0 : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of s_axi_awready_INST_0 : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of s_axi_wready_INST_0 : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \shadow[0][15]_i_2\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \shadow[0][23]_i_2\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \shadow[0][31]_i_2\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \shadow[0][7]_i_2\ : label is "soft_lutpair11";
begin
  Q(52 downto 0) <= \^q\(52 downto 0);
  SR(0) <= \^sr\(0);
  \aw_addr_reg[1]_0\(1 downto 0) <= \^aw_addr_reg[1]_0\(1 downto 0);
  \aw_addr_reg[5]_0\ <= \^aw_addr_reg[5]_0\;
  aw_held_reg_0 <= \^aw_held_reg_0\;
  bvalid_reg_0 <= \^bvalid_reg_0\;
  rvalid_reg_0 <= \^rvalid_reg_0\;
  s_axi_rresp(0) <= \^s_axi_rresp\(0);
  w_held_reg_0 <= \^w_held_reg_0\;
ack_meta_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ack_toggle_reg_n_0,
      Q => ack_meta,
      R => \bresp[1]_i_1_n_0\
    );
ack_sync_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ack_meta,
      Q => ack_sync,
      R => \bresp[1]_i_1_n_0\
    );
ack_toggle_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => req_sync,
      Q => ack_toggle_reg_n_0,
      R => \^sr\(0)
    );
\active_cfg[191]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"20"
    )
        port map (
      I0 => pending,
      I1 => vs_prev,
      I2 => in_vs,
      O => \active_cfg[191]_i_1_n_0\
    );
\active_cfg_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[0]\,
      Q => \^q\(0),
      R => \^sr\(0)
    );
\active_cfg_reg[100]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[100]\,
      Q => \^q\(47),
      R => \^sr\(0)
    );
\active_cfg_reg[101]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[101]\,
      Q => \^q\(48),
      R => \^sr\(0)
    );
\active_cfg_reg[102]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[102]\,
      Q => \^q\(49),
      R => \^sr\(0)
    );
\active_cfg_reg[103]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[103]\,
      Q => \^q\(50),
      R => \^sr\(0)
    );
\active_cfg_reg[104]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[104]\,
      Q => \^q\(51),
      R => \^sr\(0)
    );
\active_cfg_reg[105]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[105]\,
      Q => \^q\(52),
      R => \^sr\(0)
    );
\active_cfg_reg[128]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(0),
      Q => cfg(128),
      R => \^sr\(0)
    );
\active_cfg_reg[129]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(1),
      Q => cfg(129),
      R => \^sr\(0)
    );
\active_cfg_reg[130]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(2),
      Q => cfg(130),
      R => \^sr\(0)
    );
\active_cfg_reg[131]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(3),
      Q => cfg(131),
      R => \^sr\(0)
    );
\active_cfg_reg[132]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(4),
      Q => cfg(132),
      R => \^sr\(0)
    );
\active_cfg_reg[133]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(5),
      Q => cfg(133),
      R => \^sr\(0)
    );
\active_cfg_reg[134]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(6),
      Q => cfg(134),
      R => \^sr\(0)
    );
\active_cfg_reg[135]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(7),
      Q => cfg(135),
      R => \^sr\(0)
    );
\active_cfg_reg[136]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(8),
      Q => cfg(136),
      R => \^sr\(0)
    );
\active_cfg_reg[137]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(9),
      Q => cfg(137),
      R => \^sr\(0)
    );
\active_cfg_reg[138]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(10),
      Q => cfg(138),
      R => \^sr\(0)
    );
\active_cfg_reg[139]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(11),
      Q => cfg(139),
      R => \^sr\(0)
    );
\active_cfg_reg[140]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(12),
      Q => cfg(140),
      R => \^sr\(0)
    );
\active_cfg_reg[141]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(13),
      Q => cfg(141),
      R => \^sr\(0)
    );
\active_cfg_reg[142]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(14),
      Q => cfg(142),
      R => \^sr\(0)
    );
\active_cfg_reg[143]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(15),
      Q => cfg(143),
      R => \^sr\(0)
    );
\active_cfg_reg[144]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(16),
      Q => cfg(144),
      R => \^sr\(0)
    );
\active_cfg_reg[145]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(17),
      Q => cfg(145),
      R => \^sr\(0)
    );
\active_cfg_reg[146]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(18),
      Q => cfg(146),
      R => \^sr\(0)
    );
\active_cfg_reg[147]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(19),
      Q => cfg(147),
      R => \^sr\(0)
    );
\active_cfg_reg[148]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(20),
      Q => cfg(148),
      R => \^sr\(0)
    );
\active_cfg_reg[149]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(21),
      Q => cfg(149),
      R => \^sr\(0)
    );
\active_cfg_reg[150]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(22),
      Q => cfg(150),
      R => \^sr\(0)
    );
\active_cfg_reg[151]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(23),
      Q => cfg(151),
      R => \^sr\(0)
    );
\active_cfg_reg[152]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(24),
      Q => cfg(152),
      R => \^sr\(0)
    );
\active_cfg_reg[153]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(25),
      Q => cfg(153),
      R => \^sr\(0)
    );
\active_cfg_reg[154]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(26),
      Q => cfg(154),
      R => \^sr\(0)
    );
\active_cfg_reg[155]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(27),
      Q => cfg(155),
      R => \^sr\(0)
    );
\active_cfg_reg[156]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(28),
      Q => cfg(156),
      R => \^sr\(0)
    );
\active_cfg_reg[157]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(29),
      Q => cfg(157),
      R => \^sr\(0)
    );
\active_cfg_reg[158]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(30),
      Q => cfg(158),
      R => \^sr\(0)
    );
\active_cfg_reg[159]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in1_in(31),
      Q => cfg(159),
      R => \^sr\(0)
    );
\active_cfg_reg[160]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(0),
      Q => cfg(160),
      R => \^sr\(0)
    );
\active_cfg_reg[161]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(1),
      Q => cfg(161),
      R => \^sr\(0)
    );
\active_cfg_reg[162]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(2),
      Q => cfg(162),
      R => \^sr\(0)
    );
\active_cfg_reg[163]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(3),
      Q => cfg(163),
      R => \^sr\(0)
    );
\active_cfg_reg[164]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(4),
      Q => cfg(164),
      R => \^sr\(0)
    );
\active_cfg_reg[165]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(5),
      Q => cfg(165),
      R => \^sr\(0)
    );
\active_cfg_reg[166]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(6),
      Q => cfg(166),
      R => \^sr\(0)
    );
\active_cfg_reg[167]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(7),
      Q => cfg(167),
      R => \^sr\(0)
    );
\active_cfg_reg[168]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(8),
      Q => cfg(168),
      R => \^sr\(0)
    );
\active_cfg_reg[169]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(9),
      Q => cfg(169),
      R => \^sr\(0)
    );
\active_cfg_reg[170]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(10),
      Q => cfg(170),
      R => \^sr\(0)
    );
\active_cfg_reg[171]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(11),
      Q => cfg(171),
      R => \^sr\(0)
    );
\active_cfg_reg[172]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(12),
      Q => cfg(172),
      R => \^sr\(0)
    );
\active_cfg_reg[173]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(13),
      Q => cfg(173),
      R => \^sr\(0)
    );
\active_cfg_reg[174]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(14),
      Q => cfg(174),
      R => \^sr\(0)
    );
\active_cfg_reg[175]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(15),
      Q => cfg(175),
      R => \^sr\(0)
    );
\active_cfg_reg[176]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(16),
      Q => cfg(176),
      R => \^sr\(0)
    );
\active_cfg_reg[177]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(17),
      Q => cfg(177),
      R => \^sr\(0)
    );
\active_cfg_reg[178]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(18),
      Q => cfg(178),
      R => \^sr\(0)
    );
\active_cfg_reg[179]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(19),
      Q => cfg(179),
      R => \^sr\(0)
    );
\active_cfg_reg[180]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(20),
      Q => cfg(180),
      R => \^sr\(0)
    );
\active_cfg_reg[181]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(21),
      Q => cfg(181),
      R => \^sr\(0)
    );
\active_cfg_reg[182]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(22),
      Q => cfg(182),
      R => \^sr\(0)
    );
\active_cfg_reg[183]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(23),
      Q => cfg(183),
      R => \^sr\(0)
    );
\active_cfg_reg[184]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(24),
      Q => cfg(184),
      R => \^sr\(0)
    );
\active_cfg_reg[185]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(25),
      Q => cfg(185),
      R => \^sr\(0)
    );
\active_cfg_reg[186]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(26),
      Q => cfg(186),
      R => \^sr\(0)
    );
\active_cfg_reg[187]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(27),
      Q => cfg(187),
      R => \^sr\(0)
    );
\active_cfg_reg[188]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(28),
      Q => cfg(188),
      R => \^sr\(0)
    );
\active_cfg_reg[189]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(29),
      Q => cfg(189),
      R => \^sr\(0)
    );
\active_cfg_reg[190]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(30),
      Q => cfg(190),
      R => \^sr\(0)
    );
\active_cfg_reg[191]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => p_1_in(31),
      Q => cfg(191),
      R => \^sr\(0)
    );
\active_cfg_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[1]\,
      Q => cfg(1),
      R => \^sr\(0)
    );
\active_cfg_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[2]\,
      Q => \^q\(1),
      R => \^sr\(0)
    );
\active_cfg_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[32]\,
      Q => \^q\(2),
      R => \^sr\(0)
    );
\active_cfg_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[33]\,
      Q => \^q\(3),
      R => \^sr\(0)
    );
\active_cfg_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[34]\,
      Q => \^q\(4),
      R => \^sr\(0)
    );
\active_cfg_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[35]\,
      Q => \^q\(5),
      R => \^sr\(0)
    );
\active_cfg_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[36]\,
      Q => \^q\(6),
      R => \^sr\(0)
    );
\active_cfg_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[37]\,
      Q => \^q\(7),
      R => \^sr\(0)
    );
\active_cfg_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[38]\,
      Q => \^q\(8),
      R => \^sr\(0)
    );
\active_cfg_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[39]\,
      Q => \^q\(9),
      R => \^sr\(0)
    );
\active_cfg_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[3]\,
      Q => cfg(3),
      R => \^sr\(0)
    );
\active_cfg_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[40]\,
      Q => \^q\(10),
      R => \^sr\(0)
    );
\active_cfg_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[41]\,
      Q => \^q\(11),
      R => \^sr\(0)
    );
\active_cfg_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[42]\,
      Q => \^q\(12),
      R => \^sr\(0)
    );
\active_cfg_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[48]\,
      Q => \^q\(13),
      R => \^sr\(0)
    );
\active_cfg_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[49]\,
      Q => \^q\(14),
      R => \^sr\(0)
    );
\active_cfg_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[50]\,
      Q => \^q\(15),
      R => \^sr\(0)
    );
\active_cfg_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[51]\,
      Q => \^q\(16),
      R => \^sr\(0)
    );
\active_cfg_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[52]\,
      Q => \^q\(17),
      R => \^sr\(0)
    );
\active_cfg_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[53]\,
      Q => \^q\(18),
      R => \^sr\(0)
    );
\active_cfg_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[54]\,
      Q => \^q\(19),
      R => \^sr\(0)
    );
\active_cfg_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[55]\,
      Q => \^q\(20),
      R => \^sr\(0)
    );
\active_cfg_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[56]\,
      Q => \^q\(21),
      R => \^sr\(0)
    );
\active_cfg_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[57]\,
      Q => \^q\(22),
      R => \^sr\(0)
    );
\active_cfg_reg[64]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[64]\,
      Q => \^q\(23),
      R => \^sr\(0)
    );
\active_cfg_reg[65]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[65]\,
      Q => \^q\(24),
      R => \^sr\(0)
    );
\active_cfg_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[66]\,
      Q => \^q\(25),
      R => \^sr\(0)
    );
\active_cfg_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[67]\,
      Q => \^q\(26),
      R => \^sr\(0)
    );
\active_cfg_reg[68]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[68]\,
      Q => \^q\(27),
      R => \^sr\(0)
    );
\active_cfg_reg[69]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[69]\,
      Q => \^q\(28),
      R => \^sr\(0)
    );
\active_cfg_reg[70]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[70]\,
      Q => \^q\(29),
      R => \^sr\(0)
    );
\active_cfg_reg[71]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[71]\,
      Q => \^q\(30),
      R => \^sr\(0)
    );
\active_cfg_reg[72]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[72]\,
      Q => \^q\(31),
      R => \^sr\(0)
    );
\active_cfg_reg[73]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[73]\,
      Q => \^q\(32),
      R => \^sr\(0)
    );
\active_cfg_reg[80]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[80]\,
      Q => \^q\(33),
      R => \^sr\(0)
    );
\active_cfg_reg[81]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[81]\,
      Q => \^q\(34),
      R => \^sr\(0)
    );
\active_cfg_reg[82]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[82]\,
      Q => \^q\(35),
      R => \^sr\(0)
    );
\active_cfg_reg[83]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[83]\,
      Q => \^q\(36),
      R => \^sr\(0)
    );
\active_cfg_reg[84]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[84]\,
      Q => \^q\(37),
      R => \^sr\(0)
    );
\active_cfg_reg[85]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[85]\,
      Q => \^q\(38),
      R => \^sr\(0)
    );
\active_cfg_reg[86]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[86]\,
      Q => \^q\(39),
      R => \^sr\(0)
    );
\active_cfg_reg[87]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[87]\,
      Q => \^q\(40),
      R => \^sr\(0)
    );
\active_cfg_reg[88]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[88]\,
      Q => \^q\(41),
      R => \^sr\(0)
    );
\active_cfg_reg[89]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[89]\,
      Q => \^q\(42),
      R => \^sr\(0)
    );
\active_cfg_reg[96]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[96]\,
      Q => \^q\(43),
      R => \^sr\(0)
    );
\active_cfg_reg[97]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[97]\,
      Q => \^q\(44),
      R => \^sr\(0)
    );
\active_cfg_reg[98]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[98]\,
      Q => \^q\(45),
      R => \^sr\(0)
    );
\active_cfg_reg[99]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \active_cfg[191]_i_1_n_0\,
      D => \pending_cfg_reg_n_0_[99]\,
      Q => \^q\(46),
      R => \^sr\(0)
    );
audio1_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FD000000"
    )
        port map (
      I0 => \audio_left[7]_i_5_n_0\,
      I1 => \audio_left_reg_n_0_[6]\,
      I2 => \audio_left_reg_n_0_[7]\,
      I3 => cfg(3),
      I4 => \^q\(0),
      O => af
    );
audio_left1_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => audio_left1_carry_n_0,
      CO(2) => audio_left1_carry_n_1,
      CO(1) => audio_left1_carry_n_2,
      CO(0) => audio_left1_carry_n_3,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => NLW_audio_left1_carry_O_UNCONNECTED(3 downto 0),
      S(3) => audio_left1_carry_i_1_n_0,
      S(2) => audio_left1_carry_i_2_n_0,
      S(1) => audio_left1_carry_i_3_n_0,
      S(0) => audio_left1_carry_i_4_n_0
    );
\audio_left1_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => audio_left1_carry_n_0,
      CO(3) => \audio_left1_carry__0_n_0\,
      CO(2) => \audio_left1_carry__0_n_1\,
      CO(1) => \audio_left1_carry__0_n_2\,
      CO(0) => \audio_left1_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_audio_left1_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \audio_left1_carry__0_i_1_n_0\,
      S(2) => \audio_left1_carry__0_i_2_n_0\,
      S(1) => \audio_left1_carry__0_i_3_n_0\,
      S(0) => \audio_left1_carry__0_i_4_n_0\
    );
\audio_left1_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in(21),
      I1 => cfg(181),
      I2 => p_1_in(22),
      I3 => cfg(182),
      I4 => cfg(183),
      I5 => p_1_in(23),
      O => \audio_left1_carry__0_i_1_n_0\
    );
\audio_left1_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in(18),
      I1 => cfg(178),
      I2 => p_1_in(19),
      I3 => cfg(179),
      I4 => cfg(180),
      I5 => p_1_in(20),
      O => \audio_left1_carry__0_i_2_n_0\
    );
\audio_left1_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in(15),
      I1 => cfg(175),
      I2 => p_1_in(16),
      I3 => cfg(176),
      I4 => cfg(177),
      I5 => p_1_in(17),
      O => \audio_left1_carry__0_i_3_n_0\
    );
\audio_left1_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in(14),
      I1 => cfg(174),
      I2 => p_1_in(12),
      I3 => cfg(172),
      I4 => cfg(173),
      I5 => p_1_in(13),
      O => \audio_left1_carry__0_i_4_n_0\
    );
\audio_left1_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \audio_left1_carry__0_n_0\,
      CO(3) => \NLW_audio_left1_carry__1_CO_UNCONNECTED\(3),
      CO(2) => audio_left1,
      CO(1) => \audio_left1_carry__1_n_2\,
      CO(0) => \audio_left1_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0111",
      O(3 downto 0) => \NLW_audio_left1_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \audio_left1_carry__1_i_1_n_0\,
      S(1) => \audio_left1_carry__1_i_2_n_0\,
      S(0) => \audio_left1_carry__1_i_3_n_0\
    );
\audio_left1_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => cfg(191),
      I1 => p_1_in(31),
      I2 => cfg(190),
      I3 => p_1_in(30),
      O => \audio_left1_carry__1_i_1_n_0\
    );
\audio_left1_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in(27),
      I1 => cfg(187),
      I2 => p_1_in(28),
      I3 => cfg(188),
      I4 => cfg(189),
      I5 => p_1_in(29),
      O => \audio_left1_carry__1_i_2_n_0\
    );
\audio_left1_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in(24),
      I1 => cfg(184),
      I2 => p_1_in(25),
      I3 => cfg(185),
      I4 => cfg(186),
      I5 => p_1_in(26),
      O => \audio_left1_carry__1_i_3_n_0\
    );
audio_left1_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in(9),
      I1 => cfg(169),
      I2 => p_1_in(10),
      I3 => cfg(170),
      I4 => cfg(171),
      I5 => p_1_in(11),
      O => audio_left1_carry_i_1_n_0
    );
audio_left1_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in(6),
      I1 => cfg(166),
      I2 => p_1_in(7),
      I3 => cfg(167),
      I4 => cfg(168),
      I5 => p_1_in(8),
      O => audio_left1_carry_i_2_n_0
    );
audio_left1_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in(3),
      I1 => cfg(163),
      I2 => p_1_in(4),
      I3 => cfg(164),
      I4 => cfg(165),
      I5 => p_1_in(5),
      O => audio_left1_carry_i_3_n_0
    );
audio_left1_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in(0),
      I1 => cfg(160),
      I2 => p_1_in(1),
      I3 => cfg(161),
      I4 => cfg(162),
      I5 => p_1_in(2),
      O => audio_left1_carry_i_4_n_0
    );
\audio_left[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"80BF"
    )
        port map (
      I0 => \pending_cfg_reg_n_0_[120]\,
      I1 => pending,
      I2 => audio_left1,
      I3 => \audio_left_reg_n_0_[0]\,
      O => \audio_left[0]_i_1_n_0\
    );
\audio_left[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFE2FFFFFFD100"
    )
        port map (
      I0 => \audio_left_reg_n_0_[0]\,
      I1 => \audio_left[7]_i_6_n_0\,
      I2 => \pending_cfg_reg_n_0_[121]\,
      I3 => audio_left(0),
      I4 => \audio_left[7]_i_4_n_0\,
      I5 => \audio_left_reg_n_0_[1]\,
      O => \audio_left[1]_i_1_n_0\
    );
\audio_left[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFD1FFFFFFE200"
    )
        port map (
      I0 => \audio_left[2]_i_2_n_0\,
      I1 => \audio_left[7]_i_6_n_0\,
      I2 => \pending_cfg_reg_n_0_[122]\,
      I3 => audio_left(0),
      I4 => \audio_left[7]_i_4_n_0\,
      I5 => \audio_left_reg_n_0_[2]\,
      O => \audio_left[2]_i_1_n_0\
    );
\audio_left[2]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \audio_left_reg_n_0_[1]\,
      I1 => \audio_left_reg_n_0_[0]\,
      O => \audio_left[2]_i_2_n_0\
    );
\audio_left[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBBBBBB88888888B"
    )
        port map (
      I0 => \pending_cfg_reg_n_0_[123]\,
      I1 => \audio_left[7]_i_6_n_0\,
      I2 => \audio_left_reg_n_0_[0]\,
      I3 => \audio_left_reg_n_0_[1]\,
      I4 => \audio_left_reg_n_0_[2]\,
      I5 => \audio_left_reg_n_0_[3]\,
      O => \audio_left[3]_i_1_n_0\
    );
\audio_left[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AAC3C3C3"
    )
        port map (
      I0 => \pending_cfg_reg_n_0_[124]\,
      I1 => \audio_left_reg_n_0_[4]\,
      I2 => \audio_left[4]_i_2_n_0\,
      I3 => audio_left1,
      I4 => pending,
      O => \audio_left[4]_i_1_n_0\
    );
\audio_left[4]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \audio_left_reg_n_0_[3]\,
      I1 => \audio_left_reg_n_0_[2]\,
      I2 => \audio_left_reg_n_0_[1]\,
      I3 => \audio_left_reg_n_0_[0]\,
      O => \audio_left[4]_i_2_n_0\
    );
\audio_left[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AA3C3C3C"
    )
        port map (
      I0 => \pending_cfg_reg_n_0_[125]\,
      I1 => \audio_left[5]_i_2_n_0\,
      I2 => \audio_left_reg_n_0_[5]\,
      I3 => audio_left1,
      I4 => pending,
      O => \audio_left[5]_i_1_n_0\
    );
\audio_left[5]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => \audio_left_reg_n_0_[4]\,
      I1 => \audio_left_reg_n_0_[0]\,
      I2 => \audio_left_reg_n_0_[1]\,
      I3 => \audio_left_reg_n_0_[2]\,
      I4 => \audio_left_reg_n_0_[3]\,
      O => \audio_left[5]_i_2_n_0\
    );
\audio_left[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AA3C3C3C"
    )
        port map (
      I0 => \pending_cfg_reg_n_0_[126]\,
      I1 => \audio_left[7]_i_5_n_0\,
      I2 => \audio_left_reg_n_0_[6]\,
      I3 => audio_left1,
      I4 => pending,
      O => \audio_left[6]_i_1_n_0\
    );
\audio_left[7]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \^sr\(0),
      I1 => \audio_left[7]_i_4_n_0\,
      O => \audio_left[7]_i_1_n_0\
    );
\audio_left[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444444404444"
    )
        port map (
      I0 => vs_prev,
      I1 => in_vs,
      I2 => \audio_left_reg_n_0_[7]\,
      I3 => \audio_left_reg_n_0_[6]\,
      I4 => \audio_left[7]_i_5_n_0\,
      I5 => \audio_left[7]_i_6_n_0\,
      O => audio_left(0)
    );
\audio_left[7]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BF8080BFBF80BF80"
    )
        port map (
      I0 => \pending_cfg_reg_n_0_[127]\,
      I1 => pending,
      I2 => audio_left1,
      I3 => \audio_left_reg_n_0_[7]\,
      I4 => \audio_left_reg_n_0_[6]\,
      I5 => \audio_left[7]_i_5_n_0\,
      O => \audio_left[7]_i_3_n_0\
    );
\audio_left[7]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8880808080808080"
    )
        port map (
      I0 => \audio_left[7]_i_6_n_0\,
      I1 => \audio_left_reg[5]_0\,
      I2 => \audio_left[7]_i_7_n_0\,
      I3 => \pending_cfg_reg_n_0_[120]\,
      I4 => \pending_cfg_reg_n_0_[121]\,
      I5 => \pending_cfg_reg_n_0_[122]\,
      O => \audio_left[7]_i_4_n_0\
    );
\audio_left[7]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => \audio_left_reg_n_0_[3]\,
      I1 => \audio_left_reg_n_0_[2]\,
      I2 => \audio_left_reg_n_0_[1]\,
      I3 => \audio_left_reg_n_0_[0]\,
      I4 => \audio_left_reg_n_0_[4]\,
      I5 => \audio_left_reg_n_0_[5]\,
      O => \audio_left[7]_i_5_n_0\
    );
\audio_left[7]_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => pending,
      I1 => audio_left1,
      O => \audio_left[7]_i_6_n_0\
    );
\audio_left[7]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \pending_cfg_reg_n_0_[123]\,
      I1 => \pending_cfg_reg_n_0_[124]\,
      I2 => \pending_cfg_reg_n_0_[126]\,
      I3 => \pending_cfg_reg_n_0_[125]\,
      I4 => \pending_cfg_reg_n_0_[127]\,
      O => \audio_left[7]_i_7_n_0\
    );
\audio_left_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => audio_left(0),
      D => \audio_left[0]_i_1_n_0\,
      Q => \audio_left_reg_n_0_[0]\,
      R => \audio_left[7]_i_1_n_0\
    );
\audio_left_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \audio_left[1]_i_1_n_0\,
      Q => \audio_left_reg_n_0_[1]\,
      R => \^sr\(0)
    );
\audio_left_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \audio_left[2]_i_1_n_0\,
      Q => \audio_left_reg_n_0_[2]\,
      R => \^sr\(0)
    );
\audio_left_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => audio_left(0),
      D => \audio_left[3]_i_1_n_0\,
      Q => \audio_left_reg_n_0_[3]\,
      R => \audio_left[7]_i_1_n_0\
    );
\audio_left_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => audio_left(0),
      D => \audio_left[4]_i_1_n_0\,
      Q => \audio_left_reg_n_0_[4]\,
      R => \audio_left[7]_i_1_n_0\
    );
\audio_left_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => audio_left(0),
      D => \audio_left[5]_i_1_n_0\,
      Q => \audio_left_reg_n_0_[5]\,
      R => \audio_left[7]_i_1_n_0\
    );
\audio_left_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => audio_left(0),
      D => \audio_left[6]_i_1_n_0\,
      Q => \audio_left_reg_n_0_[6]\,
      R => \audio_left[7]_i_1_n_0\
    );
\audio_left_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => audio_left(0),
      D => \audio_left[7]_i_3_n_0\,
      Q => \audio_left_reg_n_0_[7]\,
      R => \audio_left[7]_i_1_n_0\
    );
\aw_addr[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => \^aw_held_reg_0\,
      I2 => \^bvalid_reg_0\,
      O => aw_held0
    );
\aw_addr_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(0),
      Q => \^aw_addr_reg[1]_0\(0),
      R => \bresp[1]_i_1_n_0\
    );
\aw_addr_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(1),
      Q => \^aw_addr_reg[1]_0\(1),
      R => \bresp[1]_i_1_n_0\
    );
\aw_addr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(2),
      Q => aw_addr(2),
      R => \bresp[1]_i_1_n_0\
    );
\aw_addr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(3),
      Q => aw_addr(3),
      R => \bresp[1]_i_1_n_0\
    );
\aw_addr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(4),
      Q => aw_addr(4),
      R => \bresp[1]_i_1_n_0\
    );
\aw_addr_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(5),
      Q => aw_addr(5),
      R => \bresp[1]_i_1_n_0\
    );
\aw_addr_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(6),
      Q => aw_addr(6),
      R => \bresp[1]_i_1_n_0\
    );
aw_held_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8800880000808880"
    )
        port map (
      I0 => \out\(0),
      I1 => rvalid_reg_2(0),
      I2 => s_axi_awvalid,
      I3 => \^aw_held_reg_0\,
      I4 => \^w_held_reg_0\,
      I5 => \^bvalid_reg_0\,
      O => aw_held_i_1_n_0
    );
aw_held_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => aw_held_i_1_n_0,
      Q => \^aw_held_reg_0\,
      R => '0'
    );
\bresp[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => \out\(0),
      I1 => rvalid_reg_2(0),
      O => \bresp[1]_i_1_n_0\
    );
\bresp[1]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AA2A2AAA"
    )
        port map (
      I0 => \mailbox[191]_i_2_n_0\,
      I1 => \w_data_reg_n_0_[0]\,
      I2 => \w_strb_reg_n_0_[0]\,
      I3 => req_toggle_reg_n_0,
      I4 => ack_sync,
      O => \w_data_reg[0]_0\
    );
\bresp[1]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FBFBFBF9FBF9FBF9"
    )
        port map (
      I0 => aw_addr(5),
      I1 => aw_addr(4),
      I2 => aw_addr(6),
      I3 => aw_addr(3),
      I4 => aw_addr(2),
      I5 => \bresp[1]_i_6_n_0\,
      O => \^aw_addr_reg[5]_0\
    );
\bresp[1]_i_5\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => \^aw_held_reg_0\,
      I1 => \^w_held_reg_0\,
      I2 => \^bvalid_reg_0\,
      O => mailbox116_out
    );
\bresp[1]_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \^aw_addr_reg[1]_0\(0),
      I1 => \^aw_addr_reg[1]_0\(1),
      O => \bresp[1]_i_6_n_0\
    );
\bresp_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \bresp_reg[1]_0\,
      Q => s_axi_bresp(0),
      R => \bresp[1]_i_1_n_0\
    );
bvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => bvalid_reg_1,
      Q => \^bvalid_reg_0\,
      R => \bresp[1]_i_1_n_0\
    );
\dx12_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(12),
      I1 => \dx12_carry__0\(10),
      O => \active_cfg_reg[42]_0\(1)
    );
\dx12_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(11),
      I1 => \dx12_carry__0\(9),
      I2 => \^q\(10),
      I3 => \dx12_carry__0\(8),
      O => \active_cfg_reg[42]_0\(0)
    );
dx12_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(9),
      I1 => \dx12_carry__0\(7),
      I2 => \^q\(8),
      I3 => \dx12_carry__0\(6),
      O => S(3)
    );
dx12_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(7),
      I1 => \dx12_carry__0\(5),
      I2 => \^q\(6),
      I3 => \dx12_carry__0\(4),
      O => S(2)
    );
dx12_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(5),
      I1 => \dx12_carry__0\(3),
      I2 => \^q\(4),
      I3 => \dx12_carry__0\(2),
      O => S(1)
    );
dx12_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(3),
      I1 => \dx12_carry__0\(1),
      I2 => \^q\(2),
      I3 => \dx12_carry__0\(0),
      O => S(0)
    );
\dy10_carry__1_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(22),
      I1 => \dy1_reg[9]\(9),
      O => \active_cfg_reg[57]_0\(0)
    );
\dy12_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(22),
      I1 => \dy1_reg[9]\(9),
      I2 => \^q\(21),
      I3 => \dy1_reg[9]\(8),
      O => \active_cfg_reg[57]_1\(0)
    );
dy12_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(20),
      I1 => \dy1_reg[9]\(7),
      I2 => \^q\(19),
      I3 => \dy1_reg[9]\(6),
      O => \active_cfg_reg[55]_0\(3)
    );
dy12_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(18),
      I1 => \dy1_reg[9]\(5),
      I2 => \^q\(17),
      I3 => \dy1_reg[9]\(4),
      O => \active_cfg_reg[55]_0\(2)
    );
dy12_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(16),
      I1 => \dy1_reg[9]\(3),
      I2 => \^q\(15),
      I3 => \dy1_reg[9]\(2),
      O => \active_cfg_reg[55]_0\(1)
    );
dy12_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(14),
      I1 => \dy1_reg[9]\(1),
      I2 => \^q\(13),
      I3 => \dy1_reg[9]\(0),
      O => \active_cfg_reg[55]_0\(0)
    );
hand1_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"000000FD"
    )
        port map (
      I0 => \hand_left[7]_i_5_n_0\,
      I1 => \hand_left_reg_n_0_[6]\,
      I2 => \hand_left_reg_n_0_[7]\,
      I3 => hand1_i_2_n_0,
      I4 => hand1_i_3_n_0,
      O => hand10
    );
hand1_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"E0FFFFFF"
    )
        port map (
      I0 => \^q\(10),
      I1 => \^q\(11),
      I2 => \^q\(12),
      I3 => \^q\(0),
      I4 => cfg(1),
      O => hand1_i_2_n_0
    );
hand1_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A888A888A8888888"
    )
        port map (
      I0 => \^q\(22),
      I1 => \^q\(21),
      I2 => \^q\(20),
      I3 => \^q\(19),
      I4 => \^q\(18),
      I5 => \^q\(17),
      O => hand1_i_3_n_0
    );
hand_left1_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => hand_left1_carry_n_0,
      CO(2) => hand_left1_carry_n_1,
      CO(1) => hand_left1_carry_n_2,
      CO(0) => hand_left1_carry_n_3,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => NLW_hand_left1_carry_O_UNCONNECTED(3 downto 0),
      S(3) => hand_left1_carry_i_1_n_0,
      S(2) => hand_left1_carry_i_2_n_0,
      S(1) => hand_left1_carry_i_3_n_0,
      S(0) => hand_left1_carry_i_4_n_0
    );
\hand_left1_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => hand_left1_carry_n_0,
      CO(3) => \hand_left1_carry__0_n_0\,
      CO(2) => \hand_left1_carry__0_n_1\,
      CO(1) => \hand_left1_carry__0_n_2\,
      CO(0) => \hand_left1_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_hand_left1_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \hand_left1_carry__0_i_1_n_0\,
      S(2) => \hand_left1_carry__0_i_2_n_0\,
      S(1) => \hand_left1_carry__0_i_3_n_0\,
      S(0) => \hand_left1_carry__0_i_4_n_0\
    );
\hand_left1_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in1_in(21),
      I1 => cfg(149),
      I2 => p_1_in1_in(22),
      I3 => cfg(150),
      I4 => cfg(151),
      I5 => p_1_in1_in(23),
      O => \hand_left1_carry__0_i_1_n_0\
    );
\hand_left1_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in1_in(19),
      I1 => cfg(147),
      I2 => p_1_in1_in(18),
      I3 => cfg(146),
      I4 => cfg(148),
      I5 => p_1_in1_in(20),
      O => \hand_left1_carry__0_i_2_n_0\
    );
\hand_left1_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in1_in(15),
      I1 => cfg(143),
      I2 => p_1_in1_in(16),
      I3 => cfg(144),
      I4 => cfg(145),
      I5 => p_1_in1_in(17),
      O => \hand_left1_carry__0_i_3_n_0\
    );
\hand_left1_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in1_in(14),
      I1 => cfg(142),
      I2 => p_1_in1_in(12),
      I3 => cfg(140),
      I4 => cfg(141),
      I5 => p_1_in1_in(13),
      O => \hand_left1_carry__0_i_4_n_0\
    );
\hand_left1_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \hand_left1_carry__0_n_0\,
      CO(3) => \NLW_hand_left1_carry__1_CO_UNCONNECTED\(3),
      CO(2) => hand_left1,
      CO(1) => \hand_left1_carry__1_n_2\,
      CO(0) => \hand_left1_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0111",
      O(3 downto 0) => \NLW_hand_left1_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \hand_left1_carry__1_i_1_n_0\,
      S(1) => \hand_left1_carry__1_i_2_n_0\,
      S(0) => \hand_left1_carry__1_i_3_n_0\
    );
\hand_left1_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => cfg(159),
      I1 => p_1_in1_in(31),
      I2 => cfg(158),
      I3 => p_1_in1_in(30),
      O => \hand_left1_carry__1_i_1_n_0\
    );
\hand_left1_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in1_in(27),
      I1 => cfg(155),
      I2 => p_1_in1_in(28),
      I3 => cfg(156),
      I4 => cfg(157),
      I5 => p_1_in1_in(29),
      O => \hand_left1_carry__1_i_2_n_0\
    );
\hand_left1_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in1_in(24),
      I1 => cfg(152),
      I2 => p_1_in1_in(25),
      I3 => cfg(153),
      I4 => cfg(154),
      I5 => p_1_in1_in(26),
      O => \hand_left1_carry__1_i_3_n_0\
    );
hand_left1_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in1_in(9),
      I1 => cfg(137),
      I2 => p_1_in1_in(10),
      I3 => cfg(138),
      I4 => cfg(139),
      I5 => p_1_in1_in(11),
      O => hand_left1_carry_i_1_n_0
    );
hand_left1_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in1_in(6),
      I1 => cfg(134),
      I2 => p_1_in1_in(7),
      I3 => cfg(135),
      I4 => cfg(136),
      I5 => p_1_in1_in(8),
      O => hand_left1_carry_i_2_n_0
    );
hand_left1_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in1_in(3),
      I1 => cfg(131),
      I2 => p_1_in1_in(4),
      I3 => cfg(132),
      I4 => cfg(133),
      I5 => p_1_in1_in(5),
      O => hand_left1_carry_i_3_n_0
    );
hand_left1_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => p_1_in1_in(0),
      I1 => cfg(128),
      I2 => p_1_in1_in(1),
      I3 => cfg(129),
      I4 => cfg(130),
      I5 => p_1_in1_in(2),
      O => hand_left1_carry_i_4_n_0
    );
\hand_left[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFD515"
    )
        port map (
      I0 => \hand_left_reg_n_0_[0]\,
      I1 => hand_left1,
      I2 => pending,
      I3 => \pending_cfg_reg_n_0_[112]\,
      I4 => \hand_left[7]_i_4_n_0\,
      O => \hand_left[0]_i_1_n_0\
    );
\hand_left[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFF9990999"
    )
        port map (
      I0 => \hand_left_reg_n_0_[0]\,
      I1 => \hand_left_reg_n_0_[1]\,
      I2 => hand_left1,
      I3 => pending,
      I4 => \pending_cfg_reg_n_0_[113]\,
      I5 => \hand_left[7]_i_4_n_0\,
      O => \hand_left[1]_i_1_n_0\
    );
\hand_left[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFE100E1"
    )
        port map (
      I0 => \hand_left_reg_n_0_[1]\,
      I1 => \hand_left_reg_n_0_[0]\,
      I2 => \hand_left_reg_n_0_[2]\,
      I3 => \hand_left[7]_i_6_n_0\,
      I4 => \pending_cfg_reg_n_0_[114]\,
      I5 => \hand_left[7]_i_4_n_0\,
      O => \hand_left[2]_i_1_n_0\
    );
\hand_left[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => hand_left(0),
      I1 => \hand_left[7]_i_4_n_0\,
      O => \hand_left[3]_i_1_n_0\
    );
\hand_left[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFF6660666"
    )
        port map (
      I0 => \hand_left_reg_n_0_[3]\,
      I1 => \hand_left[3]_i_3_n_0\,
      I2 => pending,
      I3 => hand_left1,
      I4 => \pending_cfg_reg_n_0_[115]\,
      I5 => \hand_left[7]_i_4_n_0\,
      O => \hand_left[3]_i_2_n_0\
    );
\hand_left[3]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => \hand_left_reg_n_0_[0]\,
      I1 => \hand_left_reg_n_0_[1]\,
      I2 => \hand_left_reg_n_0_[2]\,
      O => \hand_left[3]_i_3_n_0\
    );
\hand_left[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AAC3C3C3"
    )
        port map (
      I0 => \pending_cfg_reg_n_0_[116]\,
      I1 => \hand_left_reg_n_0_[4]\,
      I2 => \hand_left[4]_i_2_n_0\,
      I3 => hand_left1,
      I4 => pending,
      O => p_2_in(4)
    );
\hand_left[4]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \hand_left_reg_n_0_[3]\,
      I1 => \hand_left_reg_n_0_[2]\,
      I2 => \hand_left_reg_n_0_[1]\,
      I3 => \hand_left_reg_n_0_[0]\,
      O => \hand_left[4]_i_2_n_0\
    );
\hand_left[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AA3C3C3C"
    )
        port map (
      I0 => \pending_cfg_reg_n_0_[117]\,
      I1 => \hand_left[5]_i_2_n_0\,
      I2 => \hand_left_reg_n_0_[5]\,
      I3 => hand_left1,
      I4 => pending,
      O => p_2_in(5)
    );
\hand_left[5]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => \hand_left_reg_n_0_[4]\,
      I1 => \hand_left_reg_n_0_[0]\,
      I2 => \hand_left_reg_n_0_[1]\,
      I3 => \hand_left_reg_n_0_[2]\,
      I4 => \hand_left_reg_n_0_[3]\,
      O => \hand_left[5]_i_2_n_0\
    );
\hand_left[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AA3C3C3C"
    )
        port map (
      I0 => \pending_cfg_reg_n_0_[118]\,
      I1 => \hand_left[7]_i_5_n_0\,
      I2 => \hand_left_reg_n_0_[6]\,
      I3 => hand_left1,
      I4 => pending,
      O => p_2_in(6)
    );
\hand_left[7]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \^sr\(0),
      I1 => \hand_left[7]_i_4_n_0\,
      O => \hand_left[7]_i_1_n_0\
    );
\hand_left[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444444404444"
    )
        port map (
      I0 => vs_prev,
      I1 => in_vs,
      I2 => \hand_left_reg_n_0_[7]\,
      I3 => \hand_left_reg_n_0_[6]\,
      I4 => \hand_left[7]_i_5_n_0\,
      I5 => \hand_left[7]_i_6_n_0\,
      O => hand_left(0)
    );
\hand_left[7]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BF8080BFBF80BF80"
    )
        port map (
      I0 => \pending_cfg_reg_n_0_[119]\,
      I1 => pending,
      I2 => hand_left1,
      I3 => \hand_left_reg_n_0_[7]\,
      I4 => \hand_left_reg_n_0_[6]\,
      I5 => \hand_left[7]_i_5_n_0\,
      O => p_2_in(7)
    );
\hand_left[7]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8888888888888880"
    )
        port map (
      I0 => \hand_left[7]_i_6_n_0\,
      I1 => \audio_left_reg[5]_0\,
      I2 => \pending_cfg_reg_n_0_[119]\,
      I3 => \pending_cfg_reg_n_0_[116]\,
      I4 => \pending_cfg_reg_n_0_[118]\,
      I5 => \pending_cfg_reg_n_0_[117]\,
      O => \hand_left[7]_i_4_n_0\
    );
\hand_left[7]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => \hand_left_reg_n_0_[3]\,
      I1 => \hand_left_reg_n_0_[2]\,
      I2 => \hand_left_reg_n_0_[1]\,
      I3 => \hand_left_reg_n_0_[0]\,
      I4 => \hand_left_reg_n_0_[4]\,
      I5 => \hand_left_reg_n_0_[5]\,
      O => \hand_left[7]_i_5_n_0\
    );
\hand_left[7]_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => pending,
      I1 => hand_left1,
      O => \hand_left[7]_i_6_n_0\
    );
\hand_left_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \hand_left[3]_i_1_n_0\,
      D => \hand_left[0]_i_1_n_0\,
      Q => \hand_left_reg_n_0_[0]\,
      R => \^sr\(0)
    );
\hand_left_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \hand_left[3]_i_1_n_0\,
      D => \hand_left[1]_i_1_n_0\,
      Q => \hand_left_reg_n_0_[1]\,
      R => \^sr\(0)
    );
\hand_left_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \hand_left[3]_i_1_n_0\,
      D => \hand_left[2]_i_1_n_0\,
      Q => \hand_left_reg_n_0_[2]\,
      R => \^sr\(0)
    );
\hand_left_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \hand_left[3]_i_1_n_0\,
      D => \hand_left[3]_i_2_n_0\,
      Q => \hand_left_reg_n_0_[3]\,
      R => \^sr\(0)
    );
\hand_left_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => hand_left(0),
      D => p_2_in(4),
      Q => \hand_left_reg_n_0_[4]\,
      R => \hand_left[7]_i_1_n_0\
    );
\hand_left_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => hand_left(0),
      D => p_2_in(5),
      Q => \hand_left_reg_n_0_[5]\,
      R => \hand_left[7]_i_1_n_0\
    );
\hand_left_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => hand_left(0),
      D => p_2_in(6),
      Q => \hand_left_reg_n_0_[6]\,
      R => \hand_left[7]_i_1_n_0\
    );
\hand_left_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => hand_left(0),
      D => p_2_in(7),
      Q => \hand_left_reg_n_0_[7]\,
      R => \hand_left[7]_i_1_n_0\
    );
\mailbox[191]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000080080000"
    )
        port map (
      I0 => \w_strb_reg_n_0_[0]\,
      I1 => \w_data_reg_n_0_[0]\,
      I2 => ack_sync,
      I3 => req_toggle_reg_n_0,
      I4 => \mailbox[191]_i_2_n_0\,
      I5 => \mailbox[191]_i_3_n_0\,
      O => req_toggle6_out
    );
\mailbox[191]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000002"
    )
        port map (
      I0 => aw_addr(3),
      I1 => aw_addr(6),
      I2 => aw_addr(4),
      I3 => aw_addr(5),
      I4 => aw_addr(2),
      O => \mailbox[191]_i_2_n_0\
    );
\mailbox[191]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEFFFFFF"
    )
        port map (
      I0 => \^aw_addr_reg[1]_0\(1),
      I1 => \^aw_addr_reg[1]_0\(0),
      I2 => \^bvalid_reg_0\,
      I3 => \^w_held_reg_0\,
      I4 => \^aw_held_reg_0\,
      O => \mailbox[191]_i_3_n_0\
    );
\mailbox_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[0][0]\,
      Q => \mailbox_reg_n_0_[0]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[100]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][4]\,
      Q => \mailbox_reg_n_0_[100]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[101]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][5]\,
      Q => \mailbox_reg_n_0_[101]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[102]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][6]\,
      Q => \mailbox_reg_n_0_[102]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[103]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][7]\,
      Q => \mailbox_reg_n_0_[103]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[104]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][8]\,
      Q => \mailbox_reg_n_0_[104]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[105]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][9]\,
      Q => \mailbox_reg_n_0_[105]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[112]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][16]\,
      Q => \mailbox_reg_n_0_[112]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[113]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][17]\,
      Q => \mailbox_reg_n_0_[113]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[114]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][18]\,
      Q => \mailbox_reg_n_0_[114]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[115]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][19]\,
      Q => \mailbox_reg_n_0_[115]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[116]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][20]\,
      Q => \mailbox_reg_n_0_[116]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[117]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][21]\,
      Q => \mailbox_reg_n_0_[117]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[118]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][22]\,
      Q => \mailbox_reg_n_0_[118]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[119]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][23]\,
      Q => \mailbox_reg_n_0_[119]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[120]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][24]\,
      Q => \mailbox_reg_n_0_[120]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[121]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][25]\,
      Q => \mailbox_reg_n_0_[121]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[122]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][26]\,
      Q => \mailbox_reg_n_0_[122]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[123]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][27]\,
      Q => \mailbox_reg_n_0_[123]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[124]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][28]\,
      Q => \mailbox_reg_n_0_[124]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[125]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][29]\,
      Q => \mailbox_reg_n_0_[125]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[126]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][30]\,
      Q => \mailbox_reg_n_0_[126]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[127]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][31]\,
      Q => \mailbox_reg_n_0_[127]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[128]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][0]\,
      Q => \mailbox_reg_n_0_[128]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[129]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][1]\,
      Q => \mailbox_reg_n_0_[129]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[130]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][2]\,
      Q => \mailbox_reg_n_0_[130]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[131]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][3]\,
      Q => \mailbox_reg_n_0_[131]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[132]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][4]\,
      Q => \mailbox_reg_n_0_[132]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[133]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][5]\,
      Q => \mailbox_reg_n_0_[133]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[134]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][6]\,
      Q => \mailbox_reg_n_0_[134]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[135]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][7]\,
      Q => \mailbox_reg_n_0_[135]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[136]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][8]\,
      Q => \mailbox_reg_n_0_[136]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[137]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][9]\,
      Q => \mailbox_reg_n_0_[137]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[138]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][10]\,
      Q => \mailbox_reg_n_0_[138]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[139]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][11]\,
      Q => \mailbox_reg_n_0_[139]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[140]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][12]\,
      Q => \mailbox_reg_n_0_[140]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[141]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][13]\,
      Q => \mailbox_reg_n_0_[141]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[142]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][14]\,
      Q => \mailbox_reg_n_0_[142]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[143]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][15]\,
      Q => \mailbox_reg_n_0_[143]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[144]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][16]\,
      Q => \mailbox_reg_n_0_[144]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[145]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][17]\,
      Q => \mailbox_reg_n_0_[145]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[146]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][18]\,
      Q => \mailbox_reg_n_0_[146]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[147]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][19]\,
      Q => \mailbox_reg_n_0_[147]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[148]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][20]\,
      Q => \mailbox_reg_n_0_[148]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[149]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][21]\,
      Q => \mailbox_reg_n_0_[149]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[150]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][22]\,
      Q => \mailbox_reg_n_0_[150]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[151]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][23]\,
      Q => \mailbox_reg_n_0_[151]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[152]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][24]\,
      Q => \mailbox_reg_n_0_[152]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[153]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][25]\,
      Q => \mailbox_reg_n_0_[153]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[154]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][26]\,
      Q => \mailbox_reg_n_0_[154]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[155]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][27]\,
      Q => \mailbox_reg_n_0_[155]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[156]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][28]\,
      Q => \mailbox_reg_n_0_[156]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[157]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][29]\,
      Q => \mailbox_reg_n_0_[157]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[158]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][30]\,
      Q => \mailbox_reg_n_0_[158]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[159]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[4][31]\,
      Q => \mailbox_reg_n_0_[159]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[160]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][0]\,
      Q => \mailbox_reg_n_0_[160]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[161]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][1]\,
      Q => \mailbox_reg_n_0_[161]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[162]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][2]\,
      Q => \mailbox_reg_n_0_[162]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[163]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][3]\,
      Q => \mailbox_reg_n_0_[163]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[164]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][4]\,
      Q => \mailbox_reg_n_0_[164]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[165]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][5]\,
      Q => \mailbox_reg_n_0_[165]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[166]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][6]\,
      Q => \mailbox_reg_n_0_[166]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[167]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][7]\,
      Q => \mailbox_reg_n_0_[167]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[168]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][8]\,
      Q => \mailbox_reg_n_0_[168]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[169]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][9]\,
      Q => \mailbox_reg_n_0_[169]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[170]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][10]\,
      Q => \mailbox_reg_n_0_[170]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[171]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][11]\,
      Q => \mailbox_reg_n_0_[171]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[172]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][12]\,
      Q => \mailbox_reg_n_0_[172]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[173]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][13]\,
      Q => \mailbox_reg_n_0_[173]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[174]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][14]\,
      Q => \mailbox_reg_n_0_[174]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[175]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][15]\,
      Q => \mailbox_reg_n_0_[175]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[176]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][16]\,
      Q => \mailbox_reg_n_0_[176]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[177]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][17]\,
      Q => \mailbox_reg_n_0_[177]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[178]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][18]\,
      Q => \mailbox_reg_n_0_[178]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[179]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][19]\,
      Q => \mailbox_reg_n_0_[179]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[180]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][20]\,
      Q => \mailbox_reg_n_0_[180]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[181]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][21]\,
      Q => \mailbox_reg_n_0_[181]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[182]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][22]\,
      Q => \mailbox_reg_n_0_[182]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[183]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][23]\,
      Q => \mailbox_reg_n_0_[183]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[184]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][24]\,
      Q => \mailbox_reg_n_0_[184]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[185]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][25]\,
      Q => \mailbox_reg_n_0_[185]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[186]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][26]\,
      Q => \mailbox_reg_n_0_[186]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[187]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][27]\,
      Q => \mailbox_reg_n_0_[187]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[188]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][28]\,
      Q => \mailbox_reg_n_0_[188]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[189]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][29]\,
      Q => \mailbox_reg_n_0_[189]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[190]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][30]\,
      Q => \mailbox_reg_n_0_[190]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[191]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[5][31]\,
      Q => \mailbox_reg_n_0_[191]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[0][1]\,
      Q => \mailbox_reg_n_0_[1]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[0][2]\,
      Q => \mailbox_reg_n_0_[2]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][0]\,
      Q => \mailbox_reg_n_0_[32]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][1]\,
      Q => \mailbox_reg_n_0_[33]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][2]\,
      Q => \mailbox_reg_n_0_[34]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][3]\,
      Q => \mailbox_reg_n_0_[35]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][4]\,
      Q => \mailbox_reg_n_0_[36]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][5]\,
      Q => \mailbox_reg_n_0_[37]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][6]\,
      Q => \mailbox_reg_n_0_[38]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][7]\,
      Q => \mailbox_reg_n_0_[39]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[0][3]\,
      Q => \mailbox_reg_n_0_[3]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][8]\,
      Q => \mailbox_reg_n_0_[40]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][9]\,
      Q => \mailbox_reg_n_0_[41]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][10]\,
      Q => \mailbox_reg_n_0_[42]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][16]\,
      Q => \mailbox_reg_n_0_[48]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][17]\,
      Q => \mailbox_reg_n_0_[49]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][18]\,
      Q => \mailbox_reg_n_0_[50]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][19]\,
      Q => \mailbox_reg_n_0_[51]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][20]\,
      Q => \mailbox_reg_n_0_[52]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][21]\,
      Q => \mailbox_reg_n_0_[53]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][22]\,
      Q => \mailbox_reg_n_0_[54]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][23]\,
      Q => \mailbox_reg_n_0_[55]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][24]\,
      Q => \mailbox_reg_n_0_[56]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[1][25]\,
      Q => \mailbox_reg_n_0_[57]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[64]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][0]\,
      Q => \mailbox_reg_n_0_[64]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[65]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][1]\,
      Q => \mailbox_reg_n_0_[65]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][2]\,
      Q => \mailbox_reg_n_0_[66]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][3]\,
      Q => \mailbox_reg_n_0_[67]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[68]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][4]\,
      Q => \mailbox_reg_n_0_[68]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[69]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][5]\,
      Q => \mailbox_reg_n_0_[69]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[70]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][6]\,
      Q => \mailbox_reg_n_0_[70]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[71]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][7]\,
      Q => \mailbox_reg_n_0_[71]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[72]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][8]\,
      Q => \mailbox_reg_n_0_[72]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[73]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][9]\,
      Q => \mailbox_reg_n_0_[73]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[80]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][16]\,
      Q => \mailbox_reg_n_0_[80]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[81]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][17]\,
      Q => \mailbox_reg_n_0_[81]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[82]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][18]\,
      Q => \mailbox_reg_n_0_[82]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[83]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][19]\,
      Q => \mailbox_reg_n_0_[83]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[84]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][20]\,
      Q => \mailbox_reg_n_0_[84]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[85]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][21]\,
      Q => \mailbox_reg_n_0_[85]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[86]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][22]\,
      Q => \mailbox_reg_n_0_[86]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[87]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][23]\,
      Q => \mailbox_reg_n_0_[87]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[88]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][24]\,
      Q => \mailbox_reg_n_0_[88]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[89]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[2][25]\,
      Q => \mailbox_reg_n_0_[89]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[96]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][0]\,
      Q => \mailbox_reg_n_0_[96]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[97]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][1]\,
      Q => \mailbox_reg_n_0_[97]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[98]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][2]\,
      Q => \mailbox_reg_n_0_[98]\,
      R => \bresp[1]_i_1_n_0\
    );
\mailbox_reg[99]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => req_toggle6_out,
      D => \shadow_reg_n_0_[3][3]\,
      Q => \mailbox_reg_n_0_[99]\,
      R => \bresp[1]_i_1_n_0\
    );
\out_rgb[23]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => ack_toggle_reg_0(0),
      I1 => ack_toggle_reg_1(0),
      O => \^sr\(0)
    );
\pending_cfg[191]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => ack_toggle_reg_n_0,
      I1 => req_sync,
      I2 => pending,
      O => \pending_cfg[191]_i_1_n_0\
    );
\pending_cfg_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[0]\,
      Q => \pending_cfg_reg_n_0_[0]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[100]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[100]\,
      Q => \pending_cfg_reg_n_0_[100]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[101]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[101]\,
      Q => \pending_cfg_reg_n_0_[101]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[102]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[102]\,
      Q => \pending_cfg_reg_n_0_[102]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[103]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[103]\,
      Q => \pending_cfg_reg_n_0_[103]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[104]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[104]\,
      Q => \pending_cfg_reg_n_0_[104]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[105]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[105]\,
      Q => \pending_cfg_reg_n_0_[105]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[112]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[112]\,
      Q => \pending_cfg_reg_n_0_[112]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[113]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[113]\,
      Q => \pending_cfg_reg_n_0_[113]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[114]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[114]\,
      Q => \pending_cfg_reg_n_0_[114]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[115]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[115]\,
      Q => \pending_cfg_reg_n_0_[115]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[116]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[116]\,
      Q => \pending_cfg_reg_n_0_[116]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[117]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[117]\,
      Q => \pending_cfg_reg_n_0_[117]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[118]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[118]\,
      Q => \pending_cfg_reg_n_0_[118]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[119]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[119]\,
      Q => \pending_cfg_reg_n_0_[119]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[120]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[120]\,
      Q => \pending_cfg_reg_n_0_[120]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[121]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[121]\,
      Q => \pending_cfg_reg_n_0_[121]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[122]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[122]\,
      Q => \pending_cfg_reg_n_0_[122]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[123]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[123]\,
      Q => \pending_cfg_reg_n_0_[123]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[124]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[124]\,
      Q => \pending_cfg_reg_n_0_[124]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[125]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[125]\,
      Q => \pending_cfg_reg_n_0_[125]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[126]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[126]\,
      Q => \pending_cfg_reg_n_0_[126]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[127]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[127]\,
      Q => \pending_cfg_reg_n_0_[127]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[128]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[128]\,
      Q => p_1_in1_in(0),
      R => \^sr\(0)
    );
\pending_cfg_reg[129]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[129]\,
      Q => p_1_in1_in(1),
      R => \^sr\(0)
    );
\pending_cfg_reg[130]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[130]\,
      Q => p_1_in1_in(2),
      R => \^sr\(0)
    );
\pending_cfg_reg[131]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[131]\,
      Q => p_1_in1_in(3),
      R => \^sr\(0)
    );
\pending_cfg_reg[132]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[132]\,
      Q => p_1_in1_in(4),
      R => \^sr\(0)
    );
\pending_cfg_reg[133]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[133]\,
      Q => p_1_in1_in(5),
      R => \^sr\(0)
    );
\pending_cfg_reg[134]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[134]\,
      Q => p_1_in1_in(6),
      R => \^sr\(0)
    );
\pending_cfg_reg[135]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[135]\,
      Q => p_1_in1_in(7),
      R => \^sr\(0)
    );
\pending_cfg_reg[136]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[136]\,
      Q => p_1_in1_in(8),
      R => \^sr\(0)
    );
\pending_cfg_reg[137]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[137]\,
      Q => p_1_in1_in(9),
      R => \^sr\(0)
    );
\pending_cfg_reg[138]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[138]\,
      Q => p_1_in1_in(10),
      R => \^sr\(0)
    );
\pending_cfg_reg[139]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[139]\,
      Q => p_1_in1_in(11),
      R => \^sr\(0)
    );
\pending_cfg_reg[140]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[140]\,
      Q => p_1_in1_in(12),
      R => \^sr\(0)
    );
\pending_cfg_reg[141]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[141]\,
      Q => p_1_in1_in(13),
      R => \^sr\(0)
    );
\pending_cfg_reg[142]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[142]\,
      Q => p_1_in1_in(14),
      R => \^sr\(0)
    );
\pending_cfg_reg[143]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[143]\,
      Q => p_1_in1_in(15),
      R => \^sr\(0)
    );
\pending_cfg_reg[144]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[144]\,
      Q => p_1_in1_in(16),
      R => \^sr\(0)
    );
\pending_cfg_reg[145]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[145]\,
      Q => p_1_in1_in(17),
      R => \^sr\(0)
    );
\pending_cfg_reg[146]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[146]\,
      Q => p_1_in1_in(18),
      R => \^sr\(0)
    );
\pending_cfg_reg[147]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[147]\,
      Q => p_1_in1_in(19),
      R => \^sr\(0)
    );
\pending_cfg_reg[148]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[148]\,
      Q => p_1_in1_in(20),
      R => \^sr\(0)
    );
\pending_cfg_reg[149]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[149]\,
      Q => p_1_in1_in(21),
      R => \^sr\(0)
    );
\pending_cfg_reg[150]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[150]\,
      Q => p_1_in1_in(22),
      R => \^sr\(0)
    );
\pending_cfg_reg[151]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[151]\,
      Q => p_1_in1_in(23),
      R => \^sr\(0)
    );
\pending_cfg_reg[152]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[152]\,
      Q => p_1_in1_in(24),
      R => \^sr\(0)
    );
\pending_cfg_reg[153]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[153]\,
      Q => p_1_in1_in(25),
      R => \^sr\(0)
    );
\pending_cfg_reg[154]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[154]\,
      Q => p_1_in1_in(26),
      R => \^sr\(0)
    );
\pending_cfg_reg[155]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[155]\,
      Q => p_1_in1_in(27),
      R => \^sr\(0)
    );
\pending_cfg_reg[156]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[156]\,
      Q => p_1_in1_in(28),
      R => \^sr\(0)
    );
\pending_cfg_reg[157]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[157]\,
      Q => p_1_in1_in(29),
      R => \^sr\(0)
    );
\pending_cfg_reg[158]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[158]\,
      Q => p_1_in1_in(30),
      R => \^sr\(0)
    );
\pending_cfg_reg[159]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[159]\,
      Q => p_1_in1_in(31),
      R => \^sr\(0)
    );
\pending_cfg_reg[160]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[160]\,
      Q => p_1_in(0),
      R => \^sr\(0)
    );
\pending_cfg_reg[161]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[161]\,
      Q => p_1_in(1),
      R => \^sr\(0)
    );
\pending_cfg_reg[162]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[162]\,
      Q => p_1_in(2),
      R => \^sr\(0)
    );
\pending_cfg_reg[163]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[163]\,
      Q => p_1_in(3),
      R => \^sr\(0)
    );
\pending_cfg_reg[164]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[164]\,
      Q => p_1_in(4),
      R => \^sr\(0)
    );
\pending_cfg_reg[165]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[165]\,
      Q => p_1_in(5),
      R => \^sr\(0)
    );
\pending_cfg_reg[166]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[166]\,
      Q => p_1_in(6),
      R => \^sr\(0)
    );
\pending_cfg_reg[167]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[167]\,
      Q => p_1_in(7),
      R => \^sr\(0)
    );
\pending_cfg_reg[168]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[168]\,
      Q => p_1_in(8),
      R => \^sr\(0)
    );
\pending_cfg_reg[169]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[169]\,
      Q => p_1_in(9),
      R => \^sr\(0)
    );
\pending_cfg_reg[170]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[170]\,
      Q => p_1_in(10),
      R => \^sr\(0)
    );
\pending_cfg_reg[171]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[171]\,
      Q => p_1_in(11),
      R => \^sr\(0)
    );
\pending_cfg_reg[172]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[172]\,
      Q => p_1_in(12),
      R => \^sr\(0)
    );
\pending_cfg_reg[173]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[173]\,
      Q => p_1_in(13),
      R => \^sr\(0)
    );
\pending_cfg_reg[174]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[174]\,
      Q => p_1_in(14),
      R => \^sr\(0)
    );
\pending_cfg_reg[175]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[175]\,
      Q => p_1_in(15),
      R => \^sr\(0)
    );
\pending_cfg_reg[176]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[176]\,
      Q => p_1_in(16),
      R => \^sr\(0)
    );
\pending_cfg_reg[177]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[177]\,
      Q => p_1_in(17),
      R => \^sr\(0)
    );
\pending_cfg_reg[178]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[178]\,
      Q => p_1_in(18),
      R => \^sr\(0)
    );
\pending_cfg_reg[179]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[179]\,
      Q => p_1_in(19),
      R => \^sr\(0)
    );
\pending_cfg_reg[180]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[180]\,
      Q => p_1_in(20),
      R => \^sr\(0)
    );
\pending_cfg_reg[181]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[181]\,
      Q => p_1_in(21),
      R => \^sr\(0)
    );
\pending_cfg_reg[182]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[182]\,
      Q => p_1_in(22),
      R => \^sr\(0)
    );
\pending_cfg_reg[183]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[183]\,
      Q => p_1_in(23),
      R => \^sr\(0)
    );
\pending_cfg_reg[184]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[184]\,
      Q => p_1_in(24),
      R => \^sr\(0)
    );
\pending_cfg_reg[185]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[185]\,
      Q => p_1_in(25),
      R => \^sr\(0)
    );
\pending_cfg_reg[186]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[186]\,
      Q => p_1_in(26),
      R => \^sr\(0)
    );
\pending_cfg_reg[187]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[187]\,
      Q => p_1_in(27),
      R => \^sr\(0)
    );
\pending_cfg_reg[188]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[188]\,
      Q => p_1_in(28),
      R => \^sr\(0)
    );
\pending_cfg_reg[189]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[189]\,
      Q => p_1_in(29),
      R => \^sr\(0)
    );
\pending_cfg_reg[190]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[190]\,
      Q => p_1_in(30),
      R => \^sr\(0)
    );
\pending_cfg_reg[191]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[191]\,
      Q => p_1_in(31),
      R => \^sr\(0)
    );
\pending_cfg_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[1]\,
      Q => \pending_cfg_reg_n_0_[1]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[2]\,
      Q => \pending_cfg_reg_n_0_[2]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[32]\,
      Q => \pending_cfg_reg_n_0_[32]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[33]\,
      Q => \pending_cfg_reg_n_0_[33]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[34]\,
      Q => \pending_cfg_reg_n_0_[34]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[35]\,
      Q => \pending_cfg_reg_n_0_[35]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[36]\,
      Q => \pending_cfg_reg_n_0_[36]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[37]\,
      Q => \pending_cfg_reg_n_0_[37]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[38]\,
      Q => \pending_cfg_reg_n_0_[38]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[39]\,
      Q => \pending_cfg_reg_n_0_[39]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[3]\,
      Q => \pending_cfg_reg_n_0_[3]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[40]\,
      Q => \pending_cfg_reg_n_0_[40]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[41]\,
      Q => \pending_cfg_reg_n_0_[41]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[42]\,
      Q => \pending_cfg_reg_n_0_[42]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[48]\,
      Q => \pending_cfg_reg_n_0_[48]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[49]\,
      Q => \pending_cfg_reg_n_0_[49]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[50]\,
      Q => \pending_cfg_reg_n_0_[50]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[51]\,
      Q => \pending_cfg_reg_n_0_[51]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[52]\,
      Q => \pending_cfg_reg_n_0_[52]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[53]\,
      Q => \pending_cfg_reg_n_0_[53]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[54]\,
      Q => \pending_cfg_reg_n_0_[54]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[55]\,
      Q => \pending_cfg_reg_n_0_[55]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[56]\,
      Q => \pending_cfg_reg_n_0_[56]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[57]\,
      Q => \pending_cfg_reg_n_0_[57]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[64]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[64]\,
      Q => \pending_cfg_reg_n_0_[64]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[65]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[65]\,
      Q => \pending_cfg_reg_n_0_[65]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[66]\,
      Q => \pending_cfg_reg_n_0_[66]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[67]\,
      Q => \pending_cfg_reg_n_0_[67]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[68]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[68]\,
      Q => \pending_cfg_reg_n_0_[68]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[69]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[69]\,
      Q => \pending_cfg_reg_n_0_[69]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[70]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[70]\,
      Q => \pending_cfg_reg_n_0_[70]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[71]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[71]\,
      Q => \pending_cfg_reg_n_0_[71]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[72]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[72]\,
      Q => \pending_cfg_reg_n_0_[72]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[73]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[73]\,
      Q => \pending_cfg_reg_n_0_[73]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[80]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[80]\,
      Q => \pending_cfg_reg_n_0_[80]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[81]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[81]\,
      Q => \pending_cfg_reg_n_0_[81]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[82]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[82]\,
      Q => \pending_cfg_reg_n_0_[82]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[83]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[83]\,
      Q => \pending_cfg_reg_n_0_[83]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[84]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[84]\,
      Q => \pending_cfg_reg_n_0_[84]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[85]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[85]\,
      Q => \pending_cfg_reg_n_0_[85]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[86]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[86]\,
      Q => \pending_cfg_reg_n_0_[86]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[87]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[87]\,
      Q => \pending_cfg_reg_n_0_[87]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[88]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[88]\,
      Q => \pending_cfg_reg_n_0_[88]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[89]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[89]\,
      Q => \pending_cfg_reg_n_0_[89]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[96]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[96]\,
      Q => \pending_cfg_reg_n_0_[96]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[97]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[97]\,
      Q => \pending_cfg_reg_n_0_[97]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[98]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[98]\,
      Q => \pending_cfg_reg_n_0_[98]\,
      R => \^sr\(0)
    );
\pending_cfg_reg[99]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \pending_cfg[191]_i_1_n_0\,
      D => \mailbox_reg_n_0_[99]\,
      Q => \pending_cfg_reg_n_0_[99]\,
      R => \^sr\(0)
    );
pending_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F6F606F6"
    )
        port map (
      I0 => ack_toggle_reg_n_0,
      I1 => req_sync,
      I2 => pending,
      I3 => in_vs,
      I4 => vs_prev,
      O => pending_i_1_n_0
    );
pending_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => pending_i_1_n_0,
      Q => pending,
      R => \^sr\(0)
    );
\rdata[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000001010100010"
    )
        port map (
      I0 => \rdata[27]_i_5_n_0\,
      I1 => \rdata[0]_i_2_n_0\,
      I2 => \rdata[0]_i_3_n_0\,
      I3 => \rdata[0]_i_4_n_0\,
      I4 => s_axi_araddr(2),
      I5 => \rdata[0]_i_5_n_0\,
      O => \rdata[0]_i_1_n_0\
    );
\rdata[0]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"10000010"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(2),
      I3 => ack_sync,
      I4 => req_toggle_reg_n_0,
      O => \rdata[0]_i_2_n_0\
    );
\rdata[0]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"D800FFFF"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \shadow_reg_n_0_[3][0]\,
      I2 => \shadow_reg_n_0_[2][0]\,
      I3 => s_axi_araddr(4),
      I4 => s_axi_araddr(3),
      O => \rdata[0]_i_3_n_0\
    );
\rdata[0]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"04FF0404"
    )
        port map (
      I0 => \shadow_reg_n_0_[0][0]\,
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[4][0]\,
      I4 => s_axi_araddr(5),
      O => \rdata[0]_i_4_n_0\
    );
\rdata[0]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"04FF0404"
    )
        port map (
      I0 => \shadow_reg_n_0_[1][0]\,
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[5][0]\,
      I4 => s_axi_araddr(5),
      O => \rdata[0]_i_5_n_0\
    );
\rdata[10]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"000D"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \rdata[10]_i_2_n_0\,
      I2 => \rdata[10]_i_3_n_0\,
      I3 => \rdata[10]_i_4_n_0\,
      O => \rdata[10]_i_1_n_0\
    );
\rdata[10]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF0FA8080000A808"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => \shadow_reg_n_0_[1][10]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[3][10]\,
      I4 => s_axi_araddr(5),
      I5 => \shadow_reg_n_0_[5][10]\,
      O => \rdata[10]_i_2_n_0\
    );
\rdata[10]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFCCCCFF04"
    )
        port map (
      I0 => \shadow_reg_n_0_[4][10]\,
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \rdata[10]_i_5_n_0\,
      O => \rdata[10]_i_3_n_0\
    );
\rdata[10]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"04150404"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(3),
      I2 => \shadow_reg_n_0_[2][10]\,
      I3 => \shadow_reg_n_0_[0][10]\,
      I4 => s_axi_araddr(4),
      O => \rdata[10]_i_4_n_0\
    );
\rdata[10]_i_5\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => s_axi_araddr(6),
      I1 => s_axi_araddr(1),
      I2 => s_axi_araddr(0),
      O => \rdata[10]_i_5_n_0\
    );
\rdata[11]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[11]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[11]_i_3_n_0\,
      O => \rdata[11]_i_1_n_0\
    );
\rdata[11]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][11]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][11]\,
      I5 => s_axi_araddr(4),
      O => \rdata[11]_i_2_n_0\
    );
\rdata[11]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][11]\,
      I1 => \shadow_reg_n_0_[2][11]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][11]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][11]\,
      O => \rdata[11]_i_3_n_0\
    );
\rdata[12]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[12]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[12]_i_3_n_0\,
      O => \rdata[12]_i_1_n_0\
    );
\rdata[12]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][12]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][12]\,
      I5 => s_axi_araddr(4),
      O => \rdata[12]_i_2_n_0\
    );
\rdata[12]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][12]\,
      I1 => \shadow_reg_n_0_[2][12]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][12]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][12]\,
      O => \rdata[12]_i_3_n_0\
    );
\rdata[13]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[13]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[13]_i_3_n_0\,
      O => \rdata[13]_i_1_n_0\
    );
\rdata[13]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][13]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][13]\,
      I5 => s_axi_araddr(4),
      O => \rdata[13]_i_2_n_0\
    );
\rdata[13]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][13]\,
      I1 => \shadow_reg_n_0_[2][13]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][13]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][13]\,
      O => \rdata[13]_i_3_n_0\
    );
\rdata[14]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0002"
    )
        port map (
      I0 => \rdata[14]_i_2_n_0\,
      I1 => \rdata[14]_i_3_n_0\,
      I2 => \rdata[14]_i_4_n_0\,
      I3 => \rdata[27]_i_5_n_0\,
      O => \rdata[14]_i_1_n_0\
    );
\rdata[14]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F000F0F0F8F8FFFF"
    )
        port map (
      I0 => \shadow_reg_n_0_[5][14]\,
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(4),
      I3 => \shadow_reg_n_0_[3][14]\,
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => \rdata[14]_i_2_n_0\
    );
\rdata[14]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00044404"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(4),
      I2 => \shadow_reg_n_0_[0][14]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[1][14]\,
      O => \rdata[14]_i_3_n_0\
    );
\rdata[14]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"04550404"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[4][14]\,
      I3 => \shadow_reg_n_0_[2][14]\,
      I4 => s_axi_araddr(3),
      O => \rdata[14]_i_4_n_0\
    );
\rdata[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[15]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[15]_i_3_n_0\,
      O => \rdata[15]_i_1_n_0\
    );
\rdata[15]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][15]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][15]\,
      I5 => s_axi_araddr(4),
      O => \rdata[15]_i_2_n_0\
    );
\rdata[15]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][15]\,
      I1 => \shadow_reg_n_0_[2][15]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][15]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][15]\,
      O => \rdata[15]_i_3_n_0\
    );
\rdata[16]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000000D000D0D"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \rdata[16]_i_2_n_0\,
      I2 => \rdata[27]_i_5_n_0\,
      I3 => \shadow_reg_n_0_[4][16]\,
      I4 => \rdata[16]_i_3_n_0\,
      I5 => \rdata[16]_i_4_n_0\,
      O => \rdata[16]_i_1_n_0\
    );
\rdata[16]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FA0AF8080000F808"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => \shadow_reg_n_0_[1][16]\,
      I2 => s_axi_araddr(5),
      I3 => \shadow_reg_n_0_[5][16]\,
      I4 => s_axi_araddr(3),
      I5 => \shadow_reg_n_0_[3][16]\,
      O => \rdata[16]_i_2_n_0\
    );
\rdata[16]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8A"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(2),
      O => \rdata[16]_i_3_n_0\
    );
\rdata[16]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0C0C4C7C"
    )
        port map (
      I0 => \shadow_reg_n_0_[2][16]\,
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(4),
      I3 => \shadow_reg_n_0_[0][16]\,
      I4 => s_axi_araddr(2),
      O => \rdata[16]_i_4_n_0\
    );
\rdata[17]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000005111"
    )
        port map (
      I0 => \rdata[17]_i_2_n_0\,
      I1 => \rdata[27]_i_3_n_0\,
      I2 => s_axi_araddr(5),
      I3 => \shadow_reg_n_0_[5][17]\,
      I4 => \rdata[17]_i_3_n_0\,
      I5 => \rdata[27]_i_5_n_0\,
      O => \rdata[17]_i_1_n_0\
    );
\rdata[17]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"04550404"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[4][17]\,
      I3 => \shadow_reg_n_0_[2][17]\,
      I4 => s_axi_araddr(3),
      O => \rdata[17]_i_2_n_0\
    );
\rdata[17]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5050FFFF303F0000"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][17]\,
      I1 => \shadow_reg_n_0_[1][17]\,
      I2 => s_axi_araddr(2),
      I3 => \shadow_reg_n_0_[0][17]\,
      I4 => s_axi_araddr(4),
      I5 => s_axi_araddr(3),
      O => \rdata[17]_i_3_n_0\
    );
\rdata[18]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[18]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[18]_i_3_n_0\,
      O => \rdata[18]_i_1_n_0\
    );
\rdata[18]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][18]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][18]\,
      I5 => s_axi_araddr(4),
      O => \rdata[18]_i_2_n_0\
    );
\rdata[18]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][18]\,
      I1 => \shadow_reg_n_0_[2][18]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][18]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][18]\,
      O => \rdata[18]_i_3_n_0\
    );
\rdata[19]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[19]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[19]_i_3_n_0\,
      O => \rdata[19]_i_1_n_0\
    );
\rdata[19]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][19]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][19]\,
      I5 => s_axi_araddr(4),
      O => \rdata[19]_i_2_n_0\
    );
\rdata[19]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][19]\,
      I1 => \shadow_reg_n_0_[2][19]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][19]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][19]\,
      O => \rdata[19]_i_3_n_0\
    );
\rdata[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[1]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[1]_i_3_n_0\,
      O => \rdata[1]_i_1_n_0\
    );
\rdata[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][1]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][1]\,
      I5 => s_axi_araddr(4),
      O => \rdata[1]_i_2_n_0\
    );
\rdata[1]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][1]\,
      I1 => \shadow_reg_n_0_[2][1]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][1]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][1]\,
      O => \rdata[1]_i_3_n_0\
    );
\rdata[20]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0002"
    )
        port map (
      I0 => \rdata[20]_i_2_n_0\,
      I1 => \rdata[20]_i_3_n_0\,
      I2 => \rdata[20]_i_4_n_0\,
      I3 => \rdata[27]_i_5_n_0\,
      O => \rdata[20]_i_1_n_0\
    );
\rdata[20]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F000F0F0F8F8FFFF"
    )
        port map (
      I0 => \shadow_reg_n_0_[5][20]\,
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(4),
      I3 => \shadow_reg_n_0_[3][20]\,
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => \rdata[20]_i_2_n_0\
    );
\rdata[20]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00044404"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(4),
      I2 => \shadow_reg_n_0_[0][20]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[1][20]\,
      O => \rdata[20]_i_3_n_0\
    );
\rdata[20]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"04550404"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[4][20]\,
      I3 => \shadow_reg_n_0_[2][20]\,
      I4 => s_axi_araddr(3),
      O => \rdata[20]_i_4_n_0\
    );
\rdata[21]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[21]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[21]_i_3_n_0\,
      O => \rdata[21]_i_1_n_0\
    );
\rdata[21]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][21]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][21]\,
      I5 => s_axi_araddr(4),
      O => \rdata[21]_i_2_n_0\
    );
\rdata[21]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][21]\,
      I1 => \shadow_reg_n_0_[2][21]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][21]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][21]\,
      O => \rdata[21]_i_3_n_0\
    );
\rdata[22]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000055454545"
    )
        port map (
      I0 => \rdata[22]_i_2_n_0\,
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(5),
      I4 => \shadow_reg_n_0_[5][22]\,
      I5 => \rdata[22]_i_3_n_0\,
      O => \rdata[22]_i_1_n_0\
    );
\rdata[22]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00044404"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(4),
      I2 => \shadow_reg_n_0_[0][22]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[1][22]\,
      O => \rdata[22]_i_2_n_0\
    );
\rdata[22]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EEEEFEEEFEFEFEFE"
    )
        port map (
      I0 => \rdata[27]_i_5_n_0\,
      I1 => \rdata[22]_i_4_n_0\,
      I2 => s_axi_araddr(3),
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[3][22]\,
      I5 => s_axi_araddr(4),
      O => \rdata[22]_i_3_n_0\
    );
\rdata[22]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"04550404"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[4][22]\,
      I3 => \shadow_reg_n_0_[2][22]\,
      I4 => s_axi_araddr(3),
      O => \rdata[22]_i_4_n_0\
    );
\rdata[23]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[23]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[23]_i_3_n_0\,
      O => \rdata[23]_i_1_n_0\
    );
\rdata[23]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][23]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][23]\,
      I5 => s_axi_araddr(4),
      O => \rdata[23]_i_2_n_0\
    );
\rdata[23]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][23]\,
      I1 => \shadow_reg_n_0_[2][23]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][23]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][23]\,
      O => \rdata[23]_i_3_n_0\
    );
\rdata[24]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000005111"
    )
        port map (
      I0 => \rdata[24]_i_2_n_0\,
      I1 => \rdata[27]_i_3_n_0\,
      I2 => s_axi_araddr(5),
      I3 => \shadow_reg_n_0_[5][24]\,
      I4 => \rdata[24]_i_3_n_0\,
      I5 => \rdata[27]_i_5_n_0\,
      O => \rdata[24]_i_1_n_0\
    );
\rdata[24]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"04550404"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[4][24]\,
      I3 => \shadow_reg_n_0_[2][24]\,
      I4 => s_axi_araddr(3),
      O => \rdata[24]_i_2_n_0\
    );
\rdata[24]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5050FFFF303F0000"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][24]\,
      I1 => \shadow_reg_n_0_[1][24]\,
      I2 => s_axi_araddr(2),
      I3 => \shadow_reg_n_0_[0][24]\,
      I4 => s_axi_araddr(4),
      I5 => s_axi_araddr(3),
      O => \rdata[24]_i_3_n_0\
    );
\rdata[25]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000005111"
    )
        port map (
      I0 => \rdata[25]_i_2_n_0\,
      I1 => \rdata[27]_i_3_n_0\,
      I2 => s_axi_araddr(5),
      I3 => \shadow_reg_n_0_[5][25]\,
      I4 => \rdata[25]_i_3_n_0\,
      I5 => \rdata[27]_i_5_n_0\,
      O => \rdata[25]_i_1_n_0\
    );
\rdata[25]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"04550404"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[4][25]\,
      I3 => \shadow_reg_n_0_[2][25]\,
      I4 => s_axi_araddr(3),
      O => \rdata[25]_i_2_n_0\
    );
\rdata[25]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5050FFFF303F0000"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][25]\,
      I1 => \shadow_reg_n_0_[1][25]\,
      I2 => s_axi_araddr(2),
      I3 => \shadow_reg_n_0_[0][25]\,
      I4 => s_axi_araddr(4),
      I5 => s_axi_araddr(3),
      O => \rdata[25]_i_3_n_0\
    );
\rdata[26]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000005111"
    )
        port map (
      I0 => \rdata[26]_i_2_n_0\,
      I1 => \rdata[27]_i_3_n_0\,
      I2 => s_axi_araddr(5),
      I3 => \shadow_reg_n_0_[5][26]\,
      I4 => \rdata[26]_i_3_n_0\,
      I5 => \rdata[27]_i_5_n_0\,
      O => \rdata[26]_i_1_n_0\
    );
\rdata[26]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"04550404"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[4][26]\,
      I3 => \shadow_reg_n_0_[2][26]\,
      I4 => s_axi_araddr(3),
      O => \rdata[26]_i_2_n_0\
    );
\rdata[26]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5050FFFF303F0000"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][26]\,
      I1 => \shadow_reg_n_0_[1][26]\,
      I2 => s_axi_araddr(2),
      I3 => \shadow_reg_n_0_[0][26]\,
      I4 => s_axi_araddr(4),
      I5 => s_axi_araddr(3),
      O => \rdata[26]_i_3_n_0\
    );
\rdata[27]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000005111"
    )
        port map (
      I0 => \rdata[27]_i_2_n_0\,
      I1 => \rdata[27]_i_3_n_0\,
      I2 => s_axi_araddr(5),
      I3 => \shadow_reg_n_0_[5][27]\,
      I4 => \rdata[27]_i_4_n_0\,
      I5 => \rdata[27]_i_5_n_0\,
      O => \rdata[27]_i_1_n_0\
    );
\rdata[27]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"04550404"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[4][27]\,
      I3 => \shadow_reg_n_0_[2][27]\,
      I4 => s_axi_araddr(3),
      O => \rdata[27]_i_2_n_0\
    );
\rdata[27]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(4),
      O => \rdata[27]_i_3_n_0\
    );
\rdata[27]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5050FFFF303F0000"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][27]\,
      I1 => \shadow_reg_n_0_[1][27]\,
      I2 => s_axi_araddr(2),
      I3 => \shadow_reg_n_0_[0][27]\,
      I4 => s_axi_araddr(4),
      I5 => s_axi_araddr(3),
      O => \rdata[27]_i_4_n_0\
    );
\rdata[27]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFEFEFE"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(1),
      I2 => s_axi_araddr(6),
      I3 => s_axi_araddr(5),
      I4 => s_axi_araddr(4),
      O => \rdata[27]_i_5_n_0\
    );
\rdata[28]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[28]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[28]_i_3_n_0\,
      O => \rdata[28]_i_1_n_0\
    );
\rdata[28]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][28]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][28]\,
      I5 => s_axi_araddr(4),
      O => \rdata[28]_i_2_n_0\
    );
\rdata[28]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][28]\,
      I1 => \shadow_reg_n_0_[2][28]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][28]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][28]\,
      O => \rdata[28]_i_3_n_0\
    );
\rdata[29]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[29]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[29]_i_3_n_0\,
      O => \rdata[29]_i_1_n_0\
    );
\rdata[29]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][29]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][29]\,
      I5 => s_axi_araddr(4),
      O => \rdata[29]_i_2_n_0\
    );
\rdata[29]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][29]\,
      I1 => \shadow_reg_n_0_[2][29]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][29]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][29]\,
      O => \rdata[29]_i_3_n_0\
    );
\rdata[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[2]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[2]_i_3_n_0\,
      O => \rdata[2]_i_1_n_0\
    );
\rdata[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][2]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][2]\,
      I5 => s_axi_araddr(4),
      O => \rdata[2]_i_2_n_0\
    );
\rdata[2]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][2]\,
      I1 => \shadow_reg_n_0_[2][2]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][2]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][2]\,
      O => \rdata[2]_i_3_n_0\
    );
\rdata[30]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000054005555"
    )
        port map (
      I0 => \rdata[30]_i_2_n_0\,
      I1 => s_axi_araddr(2),
      I2 => \shadow_reg_n_0_[2][30]\,
      I3 => s_axi_araddr(4),
      I4 => s_axi_araddr(3),
      I5 => \rdata[30]_i_3_n_0\,
      O => \rdata[30]_i_1_n_0\
    );
\rdata[30]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF0070"
    )
        port map (
      I0 => \shadow_reg_n_0_[5][30]\,
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(4),
      I4 => \rdata[27]_i_5_n_0\,
      O => \rdata[30]_i_2_n_0\
    );
\rdata[30]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5530FFFF55300000"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][30]\,
      I1 => \shadow_reg_n_0_[1][30]\,
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \rdata[30]_i_4_n_0\,
      O => \rdata[30]_i_3_n_0\
    );
\rdata[30]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"44444F44"
    )
        port map (
      I0 => \shadow_reg_n_0_[4][30]\,
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[0][30]\,
      I3 => s_axi_araddr(4),
      I4 => s_axi_araddr(3),
      O => \rdata[30]_i_4_n_0\
    );
\rdata[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"77777777FFF77777"
    )
        port map (
      I0 => \out\(0),
      I1 => rvalid_reg_2(0),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_arvalid,
      I5 => \^rvalid_reg_0\,
      O => \rdata[31]_i_1_n_0\
    );
\rdata[31]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => \^rvalid_reg_0\,
      O => rvalid010_out
    );
\rdata[31]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[31]_i_5_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[31]_i_6_n_0\,
      O => \rdata[31]_i_3_n_0\
    );
\rdata[31]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0001000100010101"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(1),
      I2 => s_axi_araddr(6),
      I3 => s_axi_araddr(5),
      I4 => s_axi_araddr(3),
      I5 => s_axi_araddr(4),
      O => \rdata[31]_i_4_n_0\
    );
\rdata[31]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][31]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][31]\,
      I5 => s_axi_araddr(4),
      O => \rdata[31]_i_5_n_0\
    );
\rdata[31]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][31]\,
      I1 => \shadow_reg_n_0_[2][31]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][31]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][31]\,
      O => \rdata[31]_i_6_n_0\
    );
\rdata[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[3]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[3]_i_3_n_0\,
      O => \rdata[3]_i_1_n_0\
    );
\rdata[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][3]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][3]\,
      I5 => s_axi_araddr(4),
      O => \rdata[3]_i_2_n_0\
    );
\rdata[3]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][3]\,
      I1 => \shadow_reg_n_0_[2][3]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][3]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][3]\,
      O => \rdata[3]_i_3_n_0\
    );
\rdata[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[4]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[4]_i_3_n_0\,
      O => \rdata[4]_i_1_n_0\
    );
\rdata[4]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][4]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][4]\,
      I5 => s_axi_araddr(4),
      O => \rdata[4]_i_2_n_0\
    );
\rdata[4]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][4]\,
      I1 => \shadow_reg_n_0_[2][4]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][4]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][4]\,
      O => \rdata[4]_i_3_n_0\
    );
\rdata[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[5]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[5]_i_3_n_0\,
      O => \rdata[5]_i_1_n_0\
    );
\rdata[5]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][5]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][5]\,
      I5 => s_axi_araddr(4),
      O => \rdata[5]_i_2_n_0\
    );
\rdata[5]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][5]\,
      I1 => \shadow_reg_n_0_[2][5]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][5]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][5]\,
      O => \rdata[5]_i_3_n_0\
    );
\rdata[6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[6]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[6]_i_3_n_0\,
      O => \rdata[6]_i_1_n_0\
    );
\rdata[6]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][6]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][6]\,
      I5 => s_axi_araddr(4),
      O => \rdata[6]_i_2_n_0\
    );
\rdata[6]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][6]\,
      I1 => \shadow_reg_n_0_[2][6]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][6]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][6]\,
      O => \rdata[6]_i_3_n_0\
    );
\rdata[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[7]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[7]_i_3_n_0\,
      O => \rdata[7]_i_1_n_0\
    );
\rdata[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][7]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][7]\,
      I5 => s_axi_araddr(4),
      O => \rdata[7]_i_2_n_0\
    );
\rdata[7]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][7]\,
      I1 => \shadow_reg_n_0_[2][7]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][7]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][7]\,
      O => \rdata[7]_i_3_n_0\
    );
\rdata[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[8]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[8]_i_3_n_0\,
      O => \rdata[8]_i_1_n_0\
    );
\rdata[8]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][8]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][8]\,
      I5 => s_axi_araddr(4),
      O => \rdata[8]_i_2_n_0\
    );
\rdata[8]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][8]\,
      I1 => \shadow_reg_n_0_[2][8]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][8]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][8]\,
      O => \rdata[8]_i_3_n_0\
    );
\rdata[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A888"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[9]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => \rdata[9]_i_3_n_0\,
      O => \rdata[9]_i_1_n_0\
    );
\rdata[9]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(5),
      I2 => \shadow_reg_n_0_[5][9]\,
      I3 => s_axi_araddr(2),
      I4 => \shadow_reg_n_0_[4][9]\,
      I5 => s_axi_araddr(4),
      O => \rdata[9]_i_2_n_0\
    );
\rdata[9]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \shadow_reg_n_0_[3][9]\,
      I1 => \shadow_reg_n_0_[2][9]\,
      I2 => s_axi_araddr(3),
      I3 => \shadow_reg_n_0_[1][9]\,
      I4 => s_axi_araddr(2),
      I5 => \shadow_reg_n_0_[0][9]\,
      O => \rdata[9]_i_3_n_0\
    );
\rdata_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[0]_i_1_n_0\,
      Q => s_axi_rdata(0),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[10]_i_1_n_0\,
      Q => s_axi_rdata(10),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[11]_i_1_n_0\,
      Q => s_axi_rdata(11),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[12]_i_1_n_0\,
      Q => s_axi_rdata(12),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[13]_i_1_n_0\,
      Q => s_axi_rdata(13),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[14]_i_1_n_0\,
      Q => s_axi_rdata(14),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[15]_i_1_n_0\,
      Q => s_axi_rdata(15),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[16]_i_1_n_0\,
      Q => s_axi_rdata(16),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[17]_i_1_n_0\,
      Q => s_axi_rdata(17),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[18]_i_1_n_0\,
      Q => s_axi_rdata(18),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[19]_i_1_n_0\,
      Q => s_axi_rdata(19),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[1]_i_1_n_0\,
      Q => s_axi_rdata(1),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[20]_i_1_n_0\,
      Q => s_axi_rdata(20),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[21]_i_1_n_0\,
      Q => s_axi_rdata(21),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[22]_i_1_n_0\,
      Q => s_axi_rdata(22),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[23]_i_1_n_0\,
      Q => s_axi_rdata(23),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[24]_i_1_n_0\,
      Q => s_axi_rdata(24),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[25]_i_1_n_0\,
      Q => s_axi_rdata(25),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[26]_i_1_n_0\,
      Q => s_axi_rdata(26),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[27]_i_1_n_0\,
      Q => s_axi_rdata(27),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[28]_i_1_n_0\,
      Q => s_axi_rdata(28),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[29]_i_1_n_0\,
      Q => s_axi_rdata(29),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[2]_i_1_n_0\,
      Q => s_axi_rdata(2),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[30]_i_1_n_0\,
      Q => s_axi_rdata(30),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[31]_i_3_n_0\,
      Q => s_axi_rdata(31),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[3]_i_1_n_0\,
      Q => s_axi_rdata(3),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[4]_i_1_n_0\,
      Q => s_axi_rdata(4),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[5]_i_1_n_0\,
      Q => s_axi_rdata(5),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[6]_i_1_n_0\,
      Q => s_axi_rdata(6),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[7]_i_1_n_0\,
      Q => s_axi_rdata(7),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[8]_i_1_n_0\,
      Q => s_axi_rdata(8),
      R => \rdata[31]_i_1_n_0\
    );
\rdata_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => rvalid010_out,
      D => \rdata[9]_i_1_n_0\,
      Q => s_axi_rdata(9),
      R => \rdata[31]_i_1_n_0\
    );
req_meta_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => req_toggle_reg_n_0,
      Q => req_meta,
      R => \^sr\(0)
    );
req_sync_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => req_meta,
      Q => req_sync,
      R => \^sr\(0)
    );
req_toggle_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF00FF007F08FF00"
    )
        port map (
      I0 => \w_strb_reg_n_0_[0]\,
      I1 => \w_data_reg_n_0_[0]\,
      I2 => ack_sync,
      I3 => req_toggle_reg_n_0,
      I4 => \mailbox[191]_i_2_n_0\,
      I5 => \mailbox[191]_i_3_n_0\,
      O => req_toggle_i_1_n_0
    );
req_toggle_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => req_toggle_i_1_n_0,
      Q => req_toggle_reg_n_0,
      R => \bresp[1]_i_1_n_0\
    );
\rresp[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFD5FFFFFFD500"
    )
        port map (
      I0 => \rdata[31]_i_4_n_0\,
      I1 => \rdata[27]_i_3_n_0\,
      I2 => s_axi_araddr(3),
      I3 => rvalid010_out,
      I4 => \rresp[1]_i_2_n_0\,
      I5 => \^s_axi_rresp\(0),
      O => \rresp[1]_i_1_n_0\
    );
\rresp[1]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4440"
    )
        port map (
      I0 => \^rvalid_reg_0\,
      I1 => s_axi_arvalid,
      I2 => s_axi_araddr(1),
      I3 => s_axi_araddr(0),
      O => \rresp[1]_i_2_n_0\
    );
\rresp_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \rresp[1]_i_1_n_0\,
      Q => \^s_axi_rresp\(0),
      R => \bresp[1]_i_1_n_0\
    );
rvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => rvalid_reg_1,
      Q => \^rvalid_reg_0\,
      R => \bresp[1]_i_1_n_0\
    );
s_axi_arready_INST_0: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^rvalid_reg_0\,
      O => s_axi_arready
    );
s_axi_awready_INST_0: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^bvalid_reg_0\,
      I1 => \^aw_held_reg_0\,
      O => s_axi_awready
    );
s_axi_wready_INST_0: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^bvalid_reg_0\,
      I1 => \^w_held_reg_0\,
      O => s_axi_wready
    );
\shadow[0][15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000400000000"
    )
        port map (
      I0 => aw_addr(2),
      I1 => aw_addr(4),
      I2 => aw_addr(5),
      I3 => aw_addr(3),
      I4 => aw_addr(6),
      I5 => \shadow[0][15]_i_2_n_0\,
      O => \shadow[0][15]_i_1_n_0\
    );
\shadow[0][15]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \w_strb_reg_n_0_[1]\,
      I1 => \shadow[0][31]_i_3_n_0\,
      O => \shadow[0][15]_i_2_n_0\
    );
\shadow[0][23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000400000000"
    )
        port map (
      I0 => aw_addr(2),
      I1 => aw_addr(4),
      I2 => aw_addr(5),
      I3 => aw_addr(3),
      I4 => aw_addr(6),
      I5 => \shadow[0][23]_i_2_n_0\,
      O => \shadow[0][23]_i_1_n_0\
    );
\shadow[0][23]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \w_strb_reg_n_0_[2]\,
      I1 => \shadow[0][31]_i_3_n_0\,
      O => \shadow[0][23]_i_2_n_0\
    );
\shadow[0][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000400000000"
    )
        port map (
      I0 => aw_addr(2),
      I1 => aw_addr(4),
      I2 => aw_addr(5),
      I3 => aw_addr(3),
      I4 => aw_addr(6),
      I5 => \shadow[0][31]_i_2_n_0\,
      O => \shadow[0][31]_i_1_n_0\
    );
\shadow[0][31]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \w_strb_reg_n_0_[3]\,
      I1 => \shadow[0][31]_i_3_n_0\,
      O => \shadow[0][31]_i_2_n_0\
    );
\shadow[0][31]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFF7"
    )
        port map (
      I0 => \^aw_held_reg_0\,
      I1 => \^w_held_reg_0\,
      I2 => \^bvalid_reg_0\,
      I3 => \^aw_addr_reg[1]_0\(0),
      I4 => \^aw_addr_reg[1]_0\(1),
      I5 => \^aw_addr_reg[5]_0\,
      O => \shadow[0][31]_i_3_n_0\
    );
\shadow[0][7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000400000000"
    )
        port map (
      I0 => aw_addr(2),
      I1 => aw_addr(4),
      I2 => aw_addr(5),
      I3 => aw_addr(3),
      I4 => aw_addr(6),
      I5 => \shadow[0][7]_i_2_n_0\,
      O => \shadow[0][7]_i_1_n_0\
    );
\shadow[0][7]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \w_strb_reg_n_0_[0]\,
      I1 => \shadow[0][31]_i_3_n_0\,
      O => \shadow[0][7]_i_2_n_0\
    );
\shadow[1][15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000800"
    )
        port map (
      I0 => \shadow[0][15]_i_2_n_0\,
      I1 => aw_addr(4),
      I2 => aw_addr(5),
      I3 => aw_addr(2),
      I4 => aw_addr(3),
      I5 => aw_addr(6),
      O => \shadow[1][15]_i_1_n_0\
    );
\shadow[1][23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000800"
    )
        port map (
      I0 => \shadow[0][23]_i_2_n_0\,
      I1 => aw_addr(4),
      I2 => aw_addr(5),
      I3 => aw_addr(2),
      I4 => aw_addr(3),
      I5 => aw_addr(6),
      O => \shadow[1][23]_i_1_n_0\
    );
\shadow[1][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000800"
    )
        port map (
      I0 => \shadow[0][31]_i_2_n_0\,
      I1 => aw_addr(4),
      I2 => aw_addr(5),
      I3 => aw_addr(2),
      I4 => aw_addr(3),
      I5 => aw_addr(6),
      O => \shadow[1][31]_i_1_n_0\
    );
\shadow[1][7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000800"
    )
        port map (
      I0 => \shadow[0][7]_i_2_n_0\,
      I1 => aw_addr(4),
      I2 => aw_addr(5),
      I3 => aw_addr(2),
      I4 => aw_addr(3),
      I5 => aw_addr(6),
      O => \shadow[1][7]_i_1_n_0\
    );
\shadow[2][15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000002000000000"
    )
        port map (
      I0 => \shadow[0][15]_i_2_n_0\,
      I1 => aw_addr(2),
      I2 => aw_addr(4),
      I3 => aw_addr(5),
      I4 => aw_addr(6),
      I5 => aw_addr(3),
      O => \shadow[2][15]_i_1_n_0\
    );
\shadow[2][23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000002000000000"
    )
        port map (
      I0 => \shadow[0][23]_i_2_n_0\,
      I1 => aw_addr(2),
      I2 => aw_addr(4),
      I3 => aw_addr(5),
      I4 => aw_addr(6),
      I5 => aw_addr(3),
      O => \shadow[2][23]_i_1_n_0\
    );
\shadow[2][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000002000000000"
    )
        port map (
      I0 => \shadow[0][31]_i_2_n_0\,
      I1 => aw_addr(2),
      I2 => aw_addr(4),
      I3 => aw_addr(5),
      I4 => aw_addr(6),
      I5 => aw_addr(3),
      O => \shadow[2][31]_i_1_n_0\
    );
\shadow[2][7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000002000000000"
    )
        port map (
      I0 => \shadow[0][7]_i_2_n_0\,
      I1 => aw_addr(2),
      I2 => aw_addr(4),
      I3 => aw_addr(5),
      I4 => aw_addr(6),
      I5 => aw_addr(3),
      O => \shadow[2][7]_i_1_n_0\
    );
\shadow[3][15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000080000000000"
    )
        port map (
      I0 => \shadow[0][15]_i_2_n_0\,
      I1 => aw_addr(4),
      I2 => aw_addr(5),
      I3 => aw_addr(2),
      I4 => aw_addr(6),
      I5 => aw_addr(3),
      O => \shadow[3][15]_i_1_n_0\
    );
\shadow[3][23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000080000000000"
    )
        port map (
      I0 => \shadow[0][23]_i_2_n_0\,
      I1 => aw_addr(4),
      I2 => aw_addr(5),
      I3 => aw_addr(2),
      I4 => aw_addr(6),
      I5 => aw_addr(3),
      O => \shadow[3][23]_i_1_n_0\
    );
\shadow[3][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000080000000000"
    )
        port map (
      I0 => \shadow[0][31]_i_2_n_0\,
      I1 => aw_addr(4),
      I2 => aw_addr(5),
      I3 => aw_addr(2),
      I4 => aw_addr(6),
      I5 => aw_addr(3),
      O => \shadow[3][31]_i_1_n_0\
    );
\shadow[3][7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000080000000000"
    )
        port map (
      I0 => \shadow[0][7]_i_2_n_0\,
      I1 => aw_addr(4),
      I2 => aw_addr(5),
      I3 => aw_addr(2),
      I4 => aw_addr(6),
      I5 => aw_addr(3),
      O => \shadow[3][7]_i_1_n_0\
    );
\shadow[4][15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \shadow[0][15]_i_2_n_0\,
      I1 => aw_addr(5),
      I2 => aw_addr(4),
      I3 => aw_addr(6),
      I4 => aw_addr(3),
      I5 => aw_addr(2),
      O => \shadow[4][15]_i_1_n_0\
    );
\shadow[4][23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \shadow[0][23]_i_2_n_0\,
      I1 => aw_addr(5),
      I2 => aw_addr(4),
      I3 => aw_addr(6),
      I4 => aw_addr(3),
      I5 => aw_addr(2),
      O => \shadow[4][23]_i_1_n_0\
    );
\shadow[4][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \shadow[0][31]_i_2_n_0\,
      I1 => aw_addr(5),
      I2 => aw_addr(4),
      I3 => aw_addr(6),
      I4 => aw_addr(3),
      I5 => aw_addr(2),
      O => \shadow[4][31]_i_1_n_0\
    );
\shadow[4][7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \shadow[0][7]_i_2_n_0\,
      I1 => aw_addr(5),
      I2 => aw_addr(4),
      I3 => aw_addr(6),
      I4 => aw_addr(3),
      I5 => aw_addr(2),
      O => \shadow[4][7]_i_1_n_0\
    );
\shadow[5][15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000080"
    )
        port map (
      I0 => \shadow[0][15]_i_2_n_0\,
      I1 => aw_addr(2),
      I2 => aw_addr(5),
      I3 => aw_addr(4),
      I4 => aw_addr(6),
      I5 => aw_addr(3),
      O => \shadow[5][15]_i_1_n_0\
    );
\shadow[5][23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000080"
    )
        port map (
      I0 => \shadow[0][23]_i_2_n_0\,
      I1 => aw_addr(2),
      I2 => aw_addr(5),
      I3 => aw_addr(4),
      I4 => aw_addr(6),
      I5 => aw_addr(3),
      O => \shadow[5][23]_i_1_n_0\
    );
\shadow[5][31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000080"
    )
        port map (
      I0 => \shadow[0][31]_i_2_n_0\,
      I1 => aw_addr(2),
      I2 => aw_addr(5),
      I3 => aw_addr(4),
      I4 => aw_addr(6),
      I5 => aw_addr(3),
      O => \shadow[5][31]_i_1_n_0\
    );
\shadow[5][7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000080"
    )
        port map (
      I0 => \shadow[0][7]_i_2_n_0\,
      I1 => aw_addr(2),
      I2 => aw_addr(5),
      I3 => aw_addr(4),
      I4 => aw_addr(6),
      I5 => aw_addr(3),
      O => \shadow[5][7]_i_1_n_0\
    );
\shadow_reg[0][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[0]\,
      Q => \shadow_reg_n_0_[0][0]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[10]\,
      Q => \shadow_reg_n_0_[0][10]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[11]\,
      Q => \shadow_reg_n_0_[0][11]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[12]\,
      Q => \shadow_reg_n_0_[0][12]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[13]\,
      Q => \shadow_reg_n_0_[0][13]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[14]\,
      Q => \shadow_reg_n_0_[0][14]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[15]\,
      Q => \shadow_reg_n_0_[0][15]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[16]\,
      Q => \shadow_reg_n_0_[0][16]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[17]\,
      Q => \shadow_reg_n_0_[0][17]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[18]\,
      Q => \shadow_reg_n_0_[0][18]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[19]\,
      Q => \shadow_reg_n_0_[0][19]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[1]\,
      Q => \shadow_reg_n_0_[0][1]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[20]\,
      Q => \shadow_reg_n_0_[0][20]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[21]\,
      Q => \shadow_reg_n_0_[0][21]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[22]\,
      Q => \shadow_reg_n_0_[0][22]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[23]\,
      Q => \shadow_reg_n_0_[0][23]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[24]\,
      Q => \shadow_reg_n_0_[0][24]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[25]\,
      Q => \shadow_reg_n_0_[0][25]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[26]\,
      Q => \shadow_reg_n_0_[0][26]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[27]\,
      Q => \shadow_reg_n_0_[0][27]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[28]\,
      Q => \shadow_reg_n_0_[0][28]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[29]\,
      Q => \shadow_reg_n_0_[0][29]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[2]\,
      Q => \shadow_reg_n_0_[0][2]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[30]\,
      Q => \shadow_reg_n_0_[0][30]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[31]\,
      Q => \shadow_reg_n_0_[0][31]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[3]\,
      Q => \shadow_reg_n_0_[0][3]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[4]\,
      Q => \shadow_reg_n_0_[0][4]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[5]\,
      Q => \shadow_reg_n_0_[0][5]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[6]\,
      Q => \shadow_reg_n_0_[0][6]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[7]\,
      Q => \shadow_reg_n_0_[0][7]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[8]\,
      Q => \shadow_reg_n_0_[0][8]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[0][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[0][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[9]\,
      Q => \shadow_reg_n_0_[0][9]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[0]\,
      Q => \shadow_reg_n_0_[1][0]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[10]\,
      Q => \shadow_reg_n_0_[1][10]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[11]\,
      Q => \shadow_reg_n_0_[1][11]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[12]\,
      Q => \shadow_reg_n_0_[1][12]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[13]\,
      Q => \shadow_reg_n_0_[1][13]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[14]\,
      Q => \shadow_reg_n_0_[1][14]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[15]\,
      Q => \shadow_reg_n_0_[1][15]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[16]\,
      Q => \shadow_reg_n_0_[1][16]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[17]\,
      Q => \shadow_reg_n_0_[1][17]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[18]\,
      Q => \shadow_reg_n_0_[1][18]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[19]\,
      Q => \shadow_reg_n_0_[1][19]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[1]\,
      Q => \shadow_reg_n_0_[1][1]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[20]\,
      Q => \shadow_reg_n_0_[1][20]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[21]\,
      Q => \shadow_reg_n_0_[1][21]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[22]\,
      Q => \shadow_reg_n_0_[1][22]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[23]\,
      Q => \shadow_reg_n_0_[1][23]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[24]\,
      Q => \shadow_reg_n_0_[1][24]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[25]\,
      Q => \shadow_reg_n_0_[1][25]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[26]\,
      Q => \shadow_reg_n_0_[1][26]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[27]\,
      Q => \shadow_reg_n_0_[1][27]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[28]\,
      Q => \shadow_reg_n_0_[1][28]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[29]\,
      Q => \shadow_reg_n_0_[1][29]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[2]\,
      Q => \shadow_reg_n_0_[1][2]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[30]\,
      Q => \shadow_reg_n_0_[1][30]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[31]\,
      Q => \shadow_reg_n_0_[1][31]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[3]\,
      Q => \shadow_reg_n_0_[1][3]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[4]\,
      Q => \shadow_reg_n_0_[1][4]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[5]\,
      Q => \shadow_reg_n_0_[1][5]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[6]\,
      Q => \shadow_reg_n_0_[1][6]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[7]\,
      Q => \shadow_reg_n_0_[1][7]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[8]\,
      Q => \shadow_reg_n_0_[1][8]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[1][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[1][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[9]\,
      Q => \shadow_reg_n_0_[1][9]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[0]\,
      Q => \shadow_reg_n_0_[2][0]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[10]\,
      Q => \shadow_reg_n_0_[2][10]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[11]\,
      Q => \shadow_reg_n_0_[2][11]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[12]\,
      Q => \shadow_reg_n_0_[2][12]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[13]\,
      Q => \shadow_reg_n_0_[2][13]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[14]\,
      Q => \shadow_reg_n_0_[2][14]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[15]\,
      Q => \shadow_reg_n_0_[2][15]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[16]\,
      Q => \shadow_reg_n_0_[2][16]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[17]\,
      Q => \shadow_reg_n_0_[2][17]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[18]\,
      Q => \shadow_reg_n_0_[2][18]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[19]\,
      Q => \shadow_reg_n_0_[2][19]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[1]\,
      Q => \shadow_reg_n_0_[2][1]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[20]\,
      Q => \shadow_reg_n_0_[2][20]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[21]\,
      Q => \shadow_reg_n_0_[2][21]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[22]\,
      Q => \shadow_reg_n_0_[2][22]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[23]\,
      Q => \shadow_reg_n_0_[2][23]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[24]\,
      Q => \shadow_reg_n_0_[2][24]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[25]\,
      Q => \shadow_reg_n_0_[2][25]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[26]\,
      Q => \shadow_reg_n_0_[2][26]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[27]\,
      Q => \shadow_reg_n_0_[2][27]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[28]\,
      Q => \shadow_reg_n_0_[2][28]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[29]\,
      Q => \shadow_reg_n_0_[2][29]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[2]\,
      Q => \shadow_reg_n_0_[2][2]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[30]\,
      Q => \shadow_reg_n_0_[2][30]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[31]\,
      Q => \shadow_reg_n_0_[2][31]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[3]\,
      Q => \shadow_reg_n_0_[2][3]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[4]\,
      Q => \shadow_reg_n_0_[2][4]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[5]\,
      Q => \shadow_reg_n_0_[2][5]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[6]\,
      Q => \shadow_reg_n_0_[2][6]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[7]\,
      Q => \shadow_reg_n_0_[2][7]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[8]\,
      Q => \shadow_reg_n_0_[2][8]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[2][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[2][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[9]\,
      Q => \shadow_reg_n_0_[2][9]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[0]\,
      Q => \shadow_reg_n_0_[3][0]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[10]\,
      Q => \shadow_reg_n_0_[3][10]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[11]\,
      Q => \shadow_reg_n_0_[3][11]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[12]\,
      Q => \shadow_reg_n_0_[3][12]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[13]\,
      Q => \shadow_reg_n_0_[3][13]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[14]\,
      Q => \shadow_reg_n_0_[3][14]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[15]\,
      Q => \shadow_reg_n_0_[3][15]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[16]\,
      Q => \shadow_reg_n_0_[3][16]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[17]\,
      Q => \shadow_reg_n_0_[3][17]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[18]\,
      Q => \shadow_reg_n_0_[3][18]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[19]\,
      Q => \shadow_reg_n_0_[3][19]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[1]\,
      Q => \shadow_reg_n_0_[3][1]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[20]\,
      Q => \shadow_reg_n_0_[3][20]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[21]\,
      Q => \shadow_reg_n_0_[3][21]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[22]\,
      Q => \shadow_reg_n_0_[3][22]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[23]\,
      Q => \shadow_reg_n_0_[3][23]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[24]\,
      Q => \shadow_reg_n_0_[3][24]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[25]\,
      Q => \shadow_reg_n_0_[3][25]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[26]\,
      Q => \shadow_reg_n_0_[3][26]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[27]\,
      Q => \shadow_reg_n_0_[3][27]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[28]\,
      Q => \shadow_reg_n_0_[3][28]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[29]\,
      Q => \shadow_reg_n_0_[3][29]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[2]\,
      Q => \shadow_reg_n_0_[3][2]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[30]\,
      Q => \shadow_reg_n_0_[3][30]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[31]\,
      Q => \shadow_reg_n_0_[3][31]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[3]\,
      Q => \shadow_reg_n_0_[3][3]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[4]\,
      Q => \shadow_reg_n_0_[3][4]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[5]\,
      Q => \shadow_reg_n_0_[3][5]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[6]\,
      Q => \shadow_reg_n_0_[3][6]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[7]\,
      Q => \shadow_reg_n_0_[3][7]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[8]\,
      Q => \shadow_reg_n_0_[3][8]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[3][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[3][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[9]\,
      Q => \shadow_reg_n_0_[3][9]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[0]\,
      Q => \shadow_reg_n_0_[4][0]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[10]\,
      Q => \shadow_reg_n_0_[4][10]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[11]\,
      Q => \shadow_reg_n_0_[4][11]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[12]\,
      Q => \shadow_reg_n_0_[4][12]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[13]\,
      Q => \shadow_reg_n_0_[4][13]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[14]\,
      Q => \shadow_reg_n_0_[4][14]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[15]\,
      Q => \shadow_reg_n_0_[4][15]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[16]\,
      Q => \shadow_reg_n_0_[4][16]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[17]\,
      Q => \shadow_reg_n_0_[4][17]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[18]\,
      Q => \shadow_reg_n_0_[4][18]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[19]\,
      Q => \shadow_reg_n_0_[4][19]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[1]\,
      Q => \shadow_reg_n_0_[4][1]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[20]\,
      Q => \shadow_reg_n_0_[4][20]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[21]\,
      Q => \shadow_reg_n_0_[4][21]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[22]\,
      Q => \shadow_reg_n_0_[4][22]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[23]\,
      Q => \shadow_reg_n_0_[4][23]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[24]\,
      Q => \shadow_reg_n_0_[4][24]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[25]\,
      Q => \shadow_reg_n_0_[4][25]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[26]\,
      Q => \shadow_reg_n_0_[4][26]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[27]\,
      Q => \shadow_reg_n_0_[4][27]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[28]\,
      Q => \shadow_reg_n_0_[4][28]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[29]\,
      Q => \shadow_reg_n_0_[4][29]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[2]\,
      Q => \shadow_reg_n_0_[4][2]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[30]\,
      Q => \shadow_reg_n_0_[4][30]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[31]\,
      Q => \shadow_reg_n_0_[4][31]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[3]\,
      Q => \shadow_reg_n_0_[4][3]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[4]\,
      Q => \shadow_reg_n_0_[4][4]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[5]\,
      Q => \shadow_reg_n_0_[4][5]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[6]\,
      Q => \shadow_reg_n_0_[4][6]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[7]\,
      Q => \shadow_reg_n_0_[4][7]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[8]\,
      Q => \shadow_reg_n_0_[4][8]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[4][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[4][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[9]\,
      Q => \shadow_reg_n_0_[4][9]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[0]\,
      Q => \shadow_reg_n_0_[5][0]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[10]\,
      Q => \shadow_reg_n_0_[5][10]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[11]\,
      Q => \shadow_reg_n_0_[5][11]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[12]\,
      Q => \shadow_reg_n_0_[5][12]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[13]\,
      Q => \shadow_reg_n_0_[5][13]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[14]\,
      Q => \shadow_reg_n_0_[5][14]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[15]\,
      Q => \shadow_reg_n_0_[5][15]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[16]\,
      Q => \shadow_reg_n_0_[5][16]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[17]\,
      Q => \shadow_reg_n_0_[5][17]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[18]\,
      Q => \shadow_reg_n_0_[5][18]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[19]\,
      Q => \shadow_reg_n_0_[5][19]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[1]\,
      Q => \shadow_reg_n_0_[5][1]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[20]\,
      Q => \shadow_reg_n_0_[5][20]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[21]\,
      Q => \shadow_reg_n_0_[5][21]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[22]\,
      Q => \shadow_reg_n_0_[5][22]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][23]_i_1_n_0\,
      D => \w_data_reg_n_0_[23]\,
      Q => \shadow_reg_n_0_[5][23]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[24]\,
      Q => \shadow_reg_n_0_[5][24]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[25]\,
      Q => \shadow_reg_n_0_[5][25]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[26]\,
      Q => \shadow_reg_n_0_[5][26]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[27]\,
      Q => \shadow_reg_n_0_[5][27]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[28]\,
      Q => \shadow_reg_n_0_[5][28]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[29]\,
      Q => \shadow_reg_n_0_[5][29]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[2]\,
      Q => \shadow_reg_n_0_[5][2]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[30]\,
      Q => \shadow_reg_n_0_[5][30]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][31]_i_1_n_0\,
      D => \w_data_reg_n_0_[31]\,
      Q => \shadow_reg_n_0_[5][31]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[3]\,
      Q => \shadow_reg_n_0_[5][3]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[4]\,
      Q => \shadow_reg_n_0_[5][4]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[5]\,
      Q => \shadow_reg_n_0_[5][5]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[6]\,
      Q => \shadow_reg_n_0_[5][6]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][7]_i_1_n_0\,
      D => \w_data_reg_n_0_[7]\,
      Q => \shadow_reg_n_0_[5][7]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[8]\,
      Q => \shadow_reg_n_0_[5][8]\,
      R => \bresp[1]_i_1_n_0\
    );
\shadow_reg[5][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow[5][15]_i_1_n_0\,
      D => \w_data_reg_n_0_[9]\,
      Q => \shadow_reg_n_0_[5][9]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => s_axi_wvalid,
      I1 => \^w_held_reg_0\,
      I2 => \^bvalid_reg_0\,
      O => w_held0
    );
\w_data_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(0),
      Q => \w_data_reg_n_0_[0]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(10),
      Q => \w_data_reg_n_0_[10]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(11),
      Q => \w_data_reg_n_0_[11]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(12),
      Q => \w_data_reg_n_0_[12]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(13),
      Q => \w_data_reg_n_0_[13]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(14),
      Q => \w_data_reg_n_0_[14]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(15),
      Q => \w_data_reg_n_0_[15]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(16),
      Q => \w_data_reg_n_0_[16]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(17),
      Q => \w_data_reg_n_0_[17]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(18),
      Q => \w_data_reg_n_0_[18]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(19),
      Q => \w_data_reg_n_0_[19]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(1),
      Q => \w_data_reg_n_0_[1]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(20),
      Q => \w_data_reg_n_0_[20]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(21),
      Q => \w_data_reg_n_0_[21]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(22),
      Q => \w_data_reg_n_0_[22]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(23),
      Q => \w_data_reg_n_0_[23]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(24),
      Q => \w_data_reg_n_0_[24]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(25),
      Q => \w_data_reg_n_0_[25]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(26),
      Q => \w_data_reg_n_0_[26]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(27),
      Q => \w_data_reg_n_0_[27]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(28),
      Q => \w_data_reg_n_0_[28]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(29),
      Q => \w_data_reg_n_0_[29]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(2),
      Q => \w_data_reg_n_0_[2]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(30),
      Q => \w_data_reg_n_0_[30]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(31),
      Q => \w_data_reg_n_0_[31]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(3),
      Q => \w_data_reg_n_0_[3]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(4),
      Q => \w_data_reg_n_0_[4]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(5),
      Q => \w_data_reg_n_0_[5]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(6),
      Q => \w_data_reg_n_0_[6]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(7),
      Q => \w_data_reg_n_0_[7]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(8),
      Q => \w_data_reg_n_0_[8]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_data_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(9),
      Q => \w_data_reg_n_0_[9]\,
      R => \bresp[1]_i_1_n_0\
    );
w_held_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8888000000888080"
    )
        port map (
      I0 => \out\(0),
      I1 => rvalid_reg_2(0),
      I2 => s_axi_wvalid,
      I3 => \^aw_held_reg_0\,
      I4 => \^w_held_reg_0\,
      I5 => \^bvalid_reg_0\,
      O => w_held_i_1_n_0
    );
w_held_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => w_held_i_1_n_0,
      Q => \^w_held_reg_0\,
      R => '0'
    );
\w_strb_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wstrb(0),
      Q => \w_strb_reg_n_0_[0]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_strb_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wstrb(1),
      Q => \w_strb_reg_n_0_[1]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_strb_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wstrb(2),
      Q => \w_strb_reg_n_0_[2]\,
      R => \bresp[1]_i_1_n_0\
    );
\w_strb_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wstrb(3),
      Q => \w_strb_reg_n_0_[3]\,
      R => \bresp[1]_i_1_n_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_input_osd_0_0_input_osd_pixels is
  port (
    vs_prev : out STD_LOGIC;
    audio1_reg_0 : out STD_LOGIC;
    out_de : out STD_LOGIC;
    out_hs : out STD_LOGIC;
    out_vs : out STD_LOGIC;
    \x_reg[10]_0\ : out STD_LOGIC_VECTOR ( 10 downto 0 );
    \y_reg[9]_0\ : out STD_LOGIC_VECTOR ( 9 downto 0 );
    in_vs_0 : out STD_LOGIC;
    de_prev_reg_0 : out STD_LOGIC;
    fist1_reg_0 : out STD_LOGIC;
    \y1_reg[9]_0\ : out STD_LOGIC;
    audio1_reg_1 : out STD_LOGIC;
    \paint2[23]_i_3_0\ : out STD_LOGIC;
    enable1_reg_0 : out STD_LOGIC;
    audio1_reg_2 : out STD_LOGIC;
    \x1_reg[3]_0\ : out STD_LOGIC;
    audio1_reg_3 : out STD_LOGIC;
    \x1_reg[3]_1\ : out STD_LOGIC;
    audio1_reg_4 : out STD_LOGIC;
    fist1_reg_1 : out STD_LOGIC;
    audio1_reg_5 : out STD_LOGIC;
    out_rgb : out STD_LOGIC_VECTOR ( 23 downto 0 );
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    in_de : in STD_LOGIC;
    pclk : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 52 downto 0 );
    in_vs : in STD_LOGIC;
    hand10 : in STD_LOGIC;
    af : in STD_LOGIC;
    in_hs : in STD_LOGIC;
    \paint2_reg[20]_0\ : in STD_LOGIC;
    \paint2_reg[19]_0\ : in STD_LOGIC;
    \paint2_reg[12]_0\ : in STD_LOGIC;
    \paint2_reg[11]_0\ : in STD_LOGIC;
    \paint2_reg[4]_0\ : in STD_LOGIC;
    S : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \dx10_carry__1_i_1_0\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \dy12_carry__0_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \dy10_carry__1_i_1_0\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \dy1_reg[9]_0\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    in_rgb : in STD_LOGIC_VECTOR ( 23 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_input_osd_0_0_input_osd_pixels : entity is "input_osd_pixels";
end c6v_input_osd_0_0_input_osd_pixels;

architecture STRUCTURE of c6v_input_osd_0_0_input_osd_pixels is
  signal \^audio1_reg_0\ : STD_LOGIC;
  signal \^audio1_reg_1\ : STD_LOGIC;
  signal \^audio1_reg_3\ : STD_LOGIC;
  signal ay : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal de2 : STD_LOGIC;
  signal de_prev : STD_LOGIC;
  signal \^de_prev_reg_0\ : STD_LOGIC;
  signal dx10 : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal \dx10_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \dx10_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \dx10_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \dx10_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \dx10_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \dx10_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \dx10_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \dx10_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \dx10_carry__0_n_0\ : STD_LOGIC;
  signal \dx10_carry__0_n_1\ : STD_LOGIC;
  signal \dx10_carry__0_n_2\ : STD_LOGIC;
  signal \dx10_carry__0_n_3\ : STD_LOGIC;
  signal \dx10_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \dx10_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \dx10_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \dx10_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \dx10_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \dx10_carry__1_n_2\ : STD_LOGIC;
  signal \dx10_carry__1_n_3\ : STD_LOGIC;
  signal dx10_carry_i_1_n_0 : STD_LOGIC;
  signal dx10_carry_i_2_n_0 : STD_LOGIC;
  signal dx10_carry_i_3_n_0 : STD_LOGIC;
  signal dx10_carry_i_4_n_0 : STD_LOGIC;
  signal dx10_carry_i_5_n_0 : STD_LOGIC;
  signal dx10_carry_i_6_n_0 : STD_LOGIC;
  signal dx10_carry_i_7_n_0 : STD_LOGIC;
  signal dx10_carry_i_8_n_0 : STD_LOGIC;
  signal dx10_carry_n_0 : STD_LOGIC;
  signal dx10_carry_n_1 : STD_LOGIC;
  signal dx10_carry_n_2 : STD_LOGIC;
  signal dx10_carry_n_3 : STD_LOGIC;
  signal dx12 : STD_LOGIC;
  signal \dx12_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \dx12_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \dx12_carry__0_n_3\ : STD_LOGIC;
  signal dx12_carry_i_1_n_0 : STD_LOGIC;
  signal dx12_carry_i_2_n_0 : STD_LOGIC;
  signal dx12_carry_i_3_n_0 : STD_LOGIC;
  signal dx12_carry_i_4_n_0 : STD_LOGIC;
  signal dx12_carry_n_0 : STD_LOGIC;
  signal dx12_carry_n_1 : STD_LOGIC;
  signal dx12_carry_n_2 : STD_LOGIC;
  signal dx12_carry_n_3 : STD_LOGIC;
  signal dy10 : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \dy10_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \dy10_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \dy10_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \dy10_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \dy10_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \dy10_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \dy10_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \dy10_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \dy10_carry__0_n_0\ : STD_LOGIC;
  signal \dy10_carry__0_n_1\ : STD_LOGIC;
  signal \dy10_carry__0_n_2\ : STD_LOGIC;
  signal \dy10_carry__0_n_3\ : STD_LOGIC;
  signal \dy10_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \dy10_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \dy10_carry__1_n_3\ : STD_LOGIC;
  signal dy10_carry_i_1_n_0 : STD_LOGIC;
  signal dy10_carry_i_2_n_0 : STD_LOGIC;
  signal dy10_carry_i_3_n_0 : STD_LOGIC;
  signal dy10_carry_i_4_n_0 : STD_LOGIC;
  signal dy10_carry_i_5_n_0 : STD_LOGIC;
  signal dy10_carry_i_6_n_0 : STD_LOGIC;
  signal dy10_carry_i_7_n_0 : STD_LOGIC;
  signal dy10_carry_i_8_n_0 : STD_LOGIC;
  signal dy10_carry_n_0 : STD_LOGIC;
  signal dy10_carry_n_1 : STD_LOGIC;
  signal dy10_carry_n_2 : STD_LOGIC;
  signal dy10_carry_n_3 : STD_LOGIC;
  signal dy12 : STD_LOGIC;
  signal \dy12_carry__0_i_1_n_0\ : STD_LOGIC;
  signal dy12_carry_i_1_n_0 : STD_LOGIC;
  signal dy12_carry_i_2_n_0 : STD_LOGIC;
  signal dy12_carry_i_3_n_0 : STD_LOGIC;
  signal dy12_carry_i_4_n_0 : STD_LOGIC;
  signal dy12_carry_n_0 : STD_LOGIC;
  signal dy12_carry_n_1 : STD_LOGIC;
  signal dy12_carry_n_2 : STD_LOGIC;
  signal dy12_carry_n_3 : STD_LOGIC;
  signal enable1 : STD_LOGIC;
  signal \^enable1_reg_0\ : STD_LOGIC;
  signal fist1 : STD_LOGIC;
  signal \^fist1_reg_0\ : STD_LOGIC;
  signal hand1 : STD_LOGIC;
  signal hit21_out : STD_LOGIC;
  signal hit23 : STD_LOGIC;
  signal hit230_out : STD_LOGIC;
  signal \hit23_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \hit23_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \hit23_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \hit23_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \hit23_carry__0_n_2\ : STD_LOGIC;
  signal \hit23_carry__0_n_3\ : STD_LOGIC;
  signal hit23_carry_i_10_n_0 : STD_LOGIC;
  signal hit23_carry_i_11_n_0 : STD_LOGIC;
  signal hit23_carry_i_12_n_0 : STD_LOGIC;
  signal hit23_carry_i_13_n_0 : STD_LOGIC;
  signal hit23_carry_i_14_n_0 : STD_LOGIC;
  signal hit23_carry_i_15_n_0 : STD_LOGIC;
  signal hit23_carry_i_16_n_0 : STD_LOGIC;
  signal hit23_carry_i_17_n_0 : STD_LOGIC;
  signal hit23_carry_i_18_n_0 : STD_LOGIC;
  signal hit23_carry_i_1_n_0 : STD_LOGIC;
  signal hit23_carry_i_2_n_0 : STD_LOGIC;
  signal hit23_carry_i_3_n_0 : STD_LOGIC;
  signal hit23_carry_i_4_n_0 : STD_LOGIC;
  signal hit23_carry_i_5_n_0 : STD_LOGIC;
  signal hit23_carry_i_6_n_0 : STD_LOGIC;
  signal hit23_carry_i_7_n_0 : STD_LOGIC;
  signal hit23_carry_i_8_n_0 : STD_LOGIC;
  signal hit23_carry_i_9_n_0 : STD_LOGIC;
  signal hit23_carry_n_0 : STD_LOGIC;
  signal hit23_carry_n_1 : STD_LOGIC;
  signal hit23_carry_n_2 : STD_LOGIC;
  signal hit23_carry_n_3 : STD_LOGIC;
  signal \hit23_inferred__0/i__carry__0_n_0\ : STD_LOGIC;
  signal \hit23_inferred__0/i__carry__0_n_1\ : STD_LOGIC;
  signal \hit23_inferred__0/i__carry__0_n_2\ : STD_LOGIC;
  signal \hit23_inferred__0/i__carry__0_n_3\ : STD_LOGIC;
  signal \hit23_inferred__0/i__carry__1_n_2\ : STD_LOGIC;
  signal \hit23_inferred__0/i__carry__1_n_3\ : STD_LOGIC;
  signal \hit23_inferred__0/i__carry_n_0\ : STD_LOGIC;
  signal \hit23_inferred__0/i__carry_n_1\ : STD_LOGIC;
  signal \hit23_inferred__0/i__carry_n_2\ : STD_LOGIC;
  signal \hit23_inferred__0/i__carry_n_3\ : STD_LOGIC;
  signal \hit23_inferred__1/i__carry__0_n_0\ : STD_LOGIC;
  signal \hit23_inferred__1/i__carry__0_n_1\ : STD_LOGIC;
  signal \hit23_inferred__1/i__carry__0_n_2\ : STD_LOGIC;
  signal \hit23_inferred__1/i__carry__0_n_3\ : STD_LOGIC;
  signal \hit23_inferred__1/i__carry__1_n_2\ : STD_LOGIC;
  signal \hit23_inferred__1/i__carry__1_n_3\ : STD_LOGIC;
  signal \hit23_inferred__1/i__carry_n_0\ : STD_LOGIC;
  signal \hit23_inferred__1/i__carry_n_1\ : STD_LOGIC;
  signal \hit23_inferred__1/i__carry_n_2\ : STD_LOGIC;
  signal \hit23_inferred__1/i__carry_n_3\ : STD_LOGIC;
  signal \hit24_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \hit24_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \hit24_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \hit24_carry__0_n_2\ : STD_LOGIC;
  signal \hit24_carry__0_n_3\ : STD_LOGIC;
  signal hit24_carry_i_10_n_0 : STD_LOGIC;
  signal hit24_carry_i_11_n_0 : STD_LOGIC;
  signal hit24_carry_i_12_n_0 : STD_LOGIC;
  signal hit24_carry_i_13_n_0 : STD_LOGIC;
  signal hit24_carry_i_14_n_0 : STD_LOGIC;
  signal hit24_carry_i_15_n_0 : STD_LOGIC;
  signal hit24_carry_i_16_n_0 : STD_LOGIC;
  signal hit24_carry_i_17_n_0 : STD_LOGIC;
  signal hit24_carry_i_18_n_0 : STD_LOGIC;
  signal hit24_carry_i_1_n_0 : STD_LOGIC;
  signal hit24_carry_i_2_n_0 : STD_LOGIC;
  signal hit24_carry_i_3_n_0 : STD_LOGIC;
  signal hit24_carry_i_4_n_0 : STD_LOGIC;
  signal hit24_carry_i_5_n_0 : STD_LOGIC;
  signal hit24_carry_i_6_n_0 : STD_LOGIC;
  signal hit24_carry_i_7_n_0 : STD_LOGIC;
  signal hit24_carry_i_8_n_0 : STD_LOGIC;
  signal hit24_carry_i_9_n_0 : STD_LOGIC;
  signal hit24_carry_n_0 : STD_LOGIC;
  signal hit24_carry_n_1 : STD_LOGIC;
  signal hit24_carry_n_2 : STD_LOGIC;
  signal hit24_carry_n_3 : STD_LOGIC;
  signal \hit2__0\ : STD_LOGIC;
  signal hit2_i_3_n_0 : STD_LOGIC;
  signal hit2_i_4_n_0 : STD_LOGIC;
  signal hit2_i_5_n_0 : STD_LOGIC;
  signal hit2_i_6_n_0 : STD_LOGIC;
  signal hs1 : STD_LOGIC;
  signal hs2 : STD_LOGIC;
  signal \i__carry__0_i_1__0_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_1__1_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_1_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_2__0_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_2__1_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_2_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_3__0_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_3_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_4__0_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_4_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_5_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_1__0_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_1_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_2__0_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_2_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_3__0_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_3_n_0\ : STD_LOGIC;
  signal \i__carry_i_10_n_0\ : STD_LOGIC;
  signal \i__carry_i_11_n_0\ : STD_LOGIC;
  signal \i__carry_i_1__0_n_0\ : STD_LOGIC;
  signal \i__carry_i_1__1_n_0\ : STD_LOGIC;
  signal \i__carry_i_1_n_0\ : STD_LOGIC;
  signal \i__carry_i_2__0_n_0\ : STD_LOGIC;
  signal \i__carry_i_2__1_n_0\ : STD_LOGIC;
  signal \i__carry_i_2_n_0\ : STD_LOGIC;
  signal \i__carry_i_3__0_n_0\ : STD_LOGIC;
  signal \i__carry_i_3__1_n_0\ : STD_LOGIC;
  signal \i__carry_i_3_n_0\ : STD_LOGIC;
  signal \i__carry_i_4__0_n_0\ : STD_LOGIC;
  signal \i__carry_i_4__1_n_0\ : STD_LOGIC;
  signal \i__carry_i_4_n_0\ : STD_LOGIC;
  signal \i__carry_i_5__0_n_0\ : STD_LOGIC;
  signal \i__carry_i_5_n_0\ : STD_LOGIC;
  signal \i__carry_i_6__0_n_0\ : STD_LOGIC;
  signal \i__carry_i_6_n_0\ : STD_LOGIC;
  signal \i__carry_i_7__0_n_0\ : STD_LOGIC;
  signal \i__carry_i_7_n_0\ : STD_LOGIC;
  signal \i__carry_i_8__0_n_0\ : STD_LOGIC;
  signal \i__carry_i_8_n_0\ : STD_LOGIC;
  signal \i__carry_i_9_n_0\ : STD_LOGIC;
  signal level1 : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal loud1 : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \out_rgb[0]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[10]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[11]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[12]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[13]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[14]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[15]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[16]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[17]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[18]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[19]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[1]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[20]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[21]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[22]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[23]_i_2_n_0\ : STD_LOGIC;
  signal \out_rgb[2]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[3]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[4]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[5]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[6]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[7]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[8]_i_1_n_0\ : STD_LOGIC;
  signal \out_rgb[9]_i_1_n_0\ : STD_LOGIC;
  signal p_0_in : STD_LOGIC_VECTOR ( 10 downto 1 );
  signal p_0_in_0 : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal \p_0_in__0\ : STD_LOGIC_VECTOR ( 9 downto 1 );
  signal paint22 : STD_LOGIC;
  signal \paint22_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \paint22_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \paint22_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \paint22_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \paint22_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \paint22_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \paint22_carry__0_n_0\ : STD_LOGIC;
  signal \paint22_carry__0_n_1\ : STD_LOGIC;
  signal \paint22_carry__0_n_2\ : STD_LOGIC;
  signal \paint22_carry__0_n_3\ : STD_LOGIC;
  signal \paint22_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \paint22_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \paint22_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \paint22_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \paint22_carry__1_n_0\ : STD_LOGIC;
  signal \paint22_carry__1_n_1\ : STD_LOGIC;
  signal \paint22_carry__1_n_2\ : STD_LOGIC;
  signal \paint22_carry__1_n_3\ : STD_LOGIC;
  signal \paint22_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \paint22_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \paint22_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \paint22_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \paint22_carry__2_n_1\ : STD_LOGIC;
  signal \paint22_carry__2_n_2\ : STD_LOGIC;
  signal \paint22_carry__2_n_3\ : STD_LOGIC;
  signal paint22_carry_i_1_n_0 : STD_LOGIC;
  signal paint22_carry_i_2_n_0 : STD_LOGIC;
  signal paint22_carry_i_3_n_0 : STD_LOGIC;
  signal paint22_carry_i_4_n_0 : STD_LOGIC;
  signal paint22_carry_i_5_n_0 : STD_LOGIC;
  signal paint22_carry_i_6_n_0 : STD_LOGIC;
  signal paint22_carry_i_7_n_0 : STD_LOGIC;
  signal paint22_carry_i_8_n_0 : STD_LOGIC;
  signal paint22_carry_i_9_n_0 : STD_LOGIC;
  signal paint22_carry_n_0 : STD_LOGIC;
  signal paint22_carry_n_1 : STD_LOGIC;
  signal paint22_carry_n_2 : STD_LOGIC;
  signal paint22_carry_n_3 : STD_LOGIC;
  signal \paint22_inferred__0/i__carry__0_n_3\ : STD_LOGIC;
  signal \paint22_inferred__0/i__carry_n_0\ : STD_LOGIC;
  signal \paint22_inferred__0/i__carry_n_1\ : STD_LOGIC;
  signal \paint22_inferred__0/i__carry_n_2\ : STD_LOGIC;
  signal \paint22_inferred__0/i__carry_n_3\ : STD_LOGIC;
  signal paint23 : STD_LOGIC;
  signal \paint23_carry_i_1__0_n_0\ : STD_LOGIC;
  signal paint23_carry_i_1_n_0 : STD_LOGIC;
  signal \paint23_carry_i_2__0_n_0\ : STD_LOGIC;
  signal paint23_carry_i_2_n_0 : STD_LOGIC;
  signal paint23_carry_i_3_n_0 : STD_LOGIC;
  signal paint23_carry_i_4_n_0 : STD_LOGIC;
  signal paint23_carry_i_5_n_0 : STD_LOGIC;
  signal paint23_carry_i_6_n_0 : STD_LOGIC;
  signal paint23_carry_i_7_n_0 : STD_LOGIC;
  signal paint23_carry_i_8_n_0 : STD_LOGIC;
  signal paint23_carry_n_0 : STD_LOGIC;
  signal paint23_carry_n_1 : STD_LOGIC;
  signal paint23_carry_n_2 : STD_LOGIC;
  signal paint23_carry_n_3 : STD_LOGIC;
  signal \paint2[13]_i_1_n_0\ : STD_LOGIC;
  signal \paint2[15]_i_1_n_0\ : STD_LOGIC;
  signal \paint2[21]_i_1_n_0\ : STD_LOGIC;
  signal \paint2[21]_i_2_n_0\ : STD_LOGIC;
  signal \paint2[21]_i_3_n_0\ : STD_LOGIC;
  signal \paint2[21]_i_4_n_0\ : STD_LOGIC;
  signal \paint2[22]_i_1_n_0\ : STD_LOGIC;
  signal \paint2[23]_i_10_n_0\ : STD_LOGIC;
  signal \paint2[23]_i_11_n_0\ : STD_LOGIC;
  signal \paint2[23]_i_12_n_0\ : STD_LOGIC;
  signal \paint2[23]_i_13_n_0\ : STD_LOGIC;
  signal \paint2[23]_i_14_n_0\ : STD_LOGIC;
  signal \paint2[23]_i_15_n_0\ : STD_LOGIC;
  signal \paint2[23]_i_16_n_0\ : STD_LOGIC;
  signal \paint2[23]_i_1_n_0\ : STD_LOGIC;
  signal \^paint2[23]_i_3_0\ : STD_LOGIC;
  signal \paint2[23]_i_4_n_0\ : STD_LOGIC;
  signal \paint2[23]_i_5_n_0\ : STD_LOGIC;
  signal \paint2[23]_i_6_n_0\ : STD_LOGIC;
  signal \paint2[23]_i_7_n_0\ : STD_LOGIC;
  signal \paint2[23]_i_8_n_0\ : STD_LOGIC;
  signal \paint2[23]_i_9_n_0\ : STD_LOGIC;
  signal \paint2[2]_i_1_n_0\ : STD_LOGIC;
  signal \paint2[2]_i_2_n_0\ : STD_LOGIC;
  signal \paint2[7]_i_1_n_0\ : STD_LOGIC;
  signal \paint2_reg_n_0_[11]\ : STD_LOGIC;
  signal \paint2_reg_n_0_[12]\ : STD_LOGIC;
  signal \paint2_reg_n_0_[13]\ : STD_LOGIC;
  signal \paint2_reg_n_0_[15]\ : STD_LOGIC;
  signal \paint2_reg_n_0_[19]\ : STD_LOGIC;
  signal \paint2_reg_n_0_[20]\ : STD_LOGIC;
  signal \paint2_reg_n_0_[21]\ : STD_LOGIC;
  signal \paint2_reg_n_0_[22]\ : STD_LOGIC;
  signal \paint2_reg_n_0_[23]\ : STD_LOGIC;
  signal \paint2_reg_n_0_[2]\ : STD_LOGIC;
  signal \paint2_reg_n_0_[4]\ : STD_LOGIC;
  signal \paint2_reg_n_0_[7]\ : STD_LOGIC;
  signal rgb1 : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal rgb2 : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal soft1 : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal vs2 : STD_LOGIC;
  signal \^vs_prev\ : STD_LOGIC;
  signal x1 : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal \^x1_reg[3]_0\ : STD_LOGIC;
  signal \x[0]_i_1_n_0\ : STD_LOGIC;
  signal \x[10]_i_1_n_0\ : STD_LOGIC;
  signal \x[10]_i_2_n_0\ : STD_LOGIC;
  signal \x[10]_i_4_n_0\ : STD_LOGIC;
  signal \^x_reg[10]_0\ : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal y : STD_LOGIC;
  signal y1 : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \^y1_reg[9]_0\ : STD_LOGIC;
  signal \y[0]_i_1_n_0\ : STD_LOGIC;
  signal \y[9]_i_1_n_0\ : STD_LOGIC;
  signal \y[9]_i_4_n_0\ : STD_LOGIC;
  signal \y[9]_i_5_n_0\ : STD_LOGIC;
  signal \^y_reg[9]_0\ : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \NLW_dx10_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_dx10_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal NLW_dx12_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_dx12_carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_dx12_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_dy10_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_dy10_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal NLW_dy12_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_dy12_carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_dy12_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_hit23_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_hit23_carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_hit23_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_hit23_inferred__0/i__carry_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_hit23_inferred__0/i__carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_hit23_inferred__0/i__carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_hit23_inferred__0/i__carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_hit23_inferred__1/i__carry_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_hit23_inferred__1/i__carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_hit23_inferred__1/i__carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_hit23_inferred__1/i__carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_hit24_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_hit24_carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_hit24_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_paint22_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_paint22_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_paint22_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_paint22_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_paint22_inferred__0/i__carry_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_paint22_inferred__0/i__carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_paint22_inferred__0/i__carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_paint23_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_paint23_carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_paint23_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of dx10_carry : label is 35;
  attribute METHODOLOGY_DRC_VIOS : string;
  attribute METHODOLOGY_DRC_VIOS of dx10_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute ADDER_THRESHOLD of \dx10_carry__0\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \dx10_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute ADDER_THRESHOLD of \dx10_carry__1\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \dx10_carry__1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute COMPARATOR_THRESHOLD : integer;
  attribute COMPARATOR_THRESHOLD of dx12_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \dx12_carry__0\ : label is 11;
  attribute ADDER_THRESHOLD of dy10_carry : label is 35;
  attribute METHODOLOGY_DRC_VIOS of dy10_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute ADDER_THRESHOLD of \dy10_carry__0\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \dy10_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute ADDER_THRESHOLD of \dy10_carry__1\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \dy10_carry__1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute COMPARATOR_THRESHOLD of dy12_carry : label is 11;
  attribute METHODOLOGY_DRC_VIOS of dy12_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute COMPARATOR_THRESHOLD of \dy12_carry__0\ : label is 11;
  attribute METHODOLOGY_DRC_VIOS of \dy12_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute COMPARATOR_THRESHOLD of hit23_carry : label is 11;
  attribute METHODOLOGY_DRC_VIOS of hit23_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute COMPARATOR_THRESHOLD of \hit23_carry__0\ : label is 11;
  attribute METHODOLOGY_DRC_VIOS of \hit23_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of hit23_carry_i_11 : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of hit23_carry_i_14 : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of hit23_carry_i_15 : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of hit23_carry_i_16 : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of hit23_carry_i_17 : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of hit23_carry_i_18 : label is "soft_lutpair18";
  attribute METHODOLOGY_DRC_VIOS of \hit23_inferred__0/i__carry\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \hit23_inferred__0/i__carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \hit23_inferred__0/i__carry__1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \hit23_inferred__1/i__carry\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \hit23_inferred__1/i__carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \hit23_inferred__1/i__carry__1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute COMPARATOR_THRESHOLD of hit24_carry : label is 11;
  attribute METHODOLOGY_DRC_VIOS of hit24_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute COMPARATOR_THRESHOLD of \hit24_carry__0\ : label is 11;
  attribute METHODOLOGY_DRC_VIOS of \hit24_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute SOFT_HLUTNM of hit24_carry_i_14 : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of hit24_carry_i_15 : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of hit2_i_1 : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \i__carry_i_10\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \i__carry_i_6__0\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \i__carry_i_7\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \i__carry_i_8\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \i__carry_i_9\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \out_rgb[0]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \out_rgb[10]_i_1\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \out_rgb[11]_i_1\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \out_rgb[12]_i_1\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \out_rgb[13]_i_1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \out_rgb[14]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \out_rgb[16]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \out_rgb[17]_i_1\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \out_rgb[18]_i_1\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \out_rgb[1]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \out_rgb[2]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \out_rgb[3]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \out_rgb[4]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \out_rgb[5]_i_1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \out_rgb[6]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \out_rgb[7]_i_1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \out_rgb[8]_i_1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \out_rgb[9]_i_1\ : label is "soft_lutpair37";
  attribute COMPARATOR_THRESHOLD of paint22_carry : label is 11;
  attribute METHODOLOGY_DRC_VIOS of paint22_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute COMPARATOR_THRESHOLD of \paint22_carry__0\ : label is 11;
  attribute METHODOLOGY_DRC_VIOS of \paint22_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute SOFT_HLUTNM of \paint22_carry__0_i_6\ : label is "soft_lutpair17";
  attribute COMPARATOR_THRESHOLD of \paint22_carry__1\ : label is 11;
  attribute METHODOLOGY_DRC_VIOS of \paint22_carry__1\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute COMPARATOR_THRESHOLD of \paint22_carry__2\ : label is 11;
  attribute METHODOLOGY_DRC_VIOS of \paint22_carry__2\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute COMPARATOR_THRESHOLD of \paint22_inferred__0/i__carry\ : label is 11;
  attribute METHODOLOGY_DRC_VIOS of \paint22_inferred__0/i__carry\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute COMPARATOR_THRESHOLD of \paint22_inferred__0/i__carry__0\ : label is 11;
  attribute METHODOLOGY_DRC_VIOS of \paint22_inferred__0/i__carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute COMPARATOR_THRESHOLD of paint23_carry : label is 11;
  attribute METHODOLOGY_DRC_VIOS of paint23_carry : label is "{SYNTH-8 {cell *THIS*}}";
  attribute COMPARATOR_THRESHOLD of \paint23_carry__0\ : label is 11;
  attribute METHODOLOGY_DRC_VIOS of \paint23_carry__0\ : label is "{SYNTH-8 {cell *THIS*}}";
  attribute SOFT_HLUTNM of \paint2[12]_i_2\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \paint2[13]_i_2\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \paint2[15]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \paint2[20]_i_3\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \paint2[20]_i_4\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \paint2[22]_i_2\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \paint2[22]_i_3\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of \paint2[23]_i_11\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \paint2[23]_i_12\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \paint2[23]_i_14\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \paint2[23]_i_2\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \paint2[23]_i_7\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \paint2[4]_i_2\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of \paint2[7]_i_2\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \paint2[7]_i_3\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \x[1]_i_1\ : label is "soft_lutpair41";
  attribute SOFT_HLUTNM of \x[2]_i_1\ : label is "soft_lutpair41";
  attribute SOFT_HLUTNM of \x[3]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \x[4]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \x[6]_i_1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \x[7]_i_1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \x[8]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \x[9]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \y[1]_i_1\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of \y[2]_i_1\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of \y[3]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \y[4]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \y[6]_i_1\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of \y[7]_i_1\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of \y[8]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \y[9]_i_3\ : label is "soft_lutpair21";
begin
  audio1_reg_0 <= \^audio1_reg_0\;
  audio1_reg_1 <= \^audio1_reg_1\;
  audio1_reg_3 <= \^audio1_reg_3\;
  de_prev_reg_0 <= \^de_prev_reg_0\;
  enable1_reg_0 <= \^enable1_reg_0\;
  fist1_reg_0 <= \^fist1_reg_0\;
  \paint2[23]_i_3_0\ <= \^paint2[23]_i_3_0\;
  vs_prev <= \^vs_prev\;
  \x1_reg[3]_0\ <= \^x1_reg[3]_0\;
  \x_reg[10]_0\(10 downto 0) <= \^x_reg[10]_0\(10 downto 0);
  \y1_reg[9]_0\ <= \^y1_reg[9]_0\;
  \y_reg[9]_0\(9 downto 0) <= \^y_reg[9]_0\(9 downto 0);
audio1_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => af,
      Q => \^audio1_reg_0\,
      R => SR(0)
    );
de2_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => de_prev,
      Q => de2,
      R => SR(0)
    );
de_prev_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_de,
      Q => de_prev,
      R => SR(0)
    );
dx10_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => dx10_carry_n_0,
      CO(2) => dx10_carry_n_1,
      CO(1) => dx10_carry_n_2,
      CO(0) => dx10_carry_n_3,
      CYINIT => '1',
      DI(3) => dx10_carry_i_1_n_0,
      DI(2) => dx10_carry_i_2_n_0,
      DI(1) => dx10_carry_i_3_n_0,
      DI(0) => dx10_carry_i_4_n_0,
      O(3 downto 0) => dx10(3 downto 0),
      S(3) => dx10_carry_i_5_n_0,
      S(2) => dx10_carry_i_6_n_0,
      S(1) => dx10_carry_i_7_n_0,
      S(0) => dx10_carry_i_8_n_0
    );
\dx10_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => dx10_carry_n_0,
      CO(3) => \dx10_carry__0_n_0\,
      CO(2) => \dx10_carry__0_n_1\,
      CO(1) => \dx10_carry__0_n_2\,
      CO(0) => \dx10_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \dx10_carry__0_i_1_n_0\,
      DI(2) => \dx10_carry__0_i_2_n_0\,
      DI(1) => \dx10_carry__0_i_3_n_0\,
      DI(0) => \dx10_carry__0_i_4_n_0\,
      O(3 downto 0) => dx10(7 downto 4),
      S(3) => \dx10_carry__0_i_5_n_0\,
      S(2) => \dx10_carry__0_i_6_n_0\,
      S(1) => \dx10_carry__0_i_7_n_0\,
      S(0) => \dx10_carry__0_i_8_n_0\
    );
\dx10_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dx12,
      I1 => \^x_reg[10]_0\(7),
      O => \dx10_carry__0_i_1_n_0\
    );
\dx10_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dx12,
      I1 => \^x_reg[10]_0\(6),
      O => \dx10_carry__0_i_2_n_0\
    );
\dx10_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dx12,
      I1 => \^x_reg[10]_0\(5),
      O => \dx10_carry__0_i_3_n_0\
    );
\dx10_carry__0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dx12,
      I1 => \^x_reg[10]_0\(4),
      O => \dx10_carry__0_i_4_n_0\
    );
\dx10_carry__0_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^x_reg[10]_0\(7),
      I1 => Q(9),
      O => \dx10_carry__0_i_5_n_0\
    );
\dx10_carry__0_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^x_reg[10]_0\(6),
      I1 => Q(8),
      O => \dx10_carry__0_i_6_n_0\
    );
\dx10_carry__0_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^x_reg[10]_0\(5),
      I1 => Q(7),
      O => \dx10_carry__0_i_7_n_0\
    );
\dx10_carry__0_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^x_reg[10]_0\(4),
      I1 => Q(6),
      O => \dx10_carry__0_i_8_n_0\
    );
\dx10_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \dx10_carry__0_n_0\,
      CO(3 downto 2) => \NLW_dx10_carry__1_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \dx10_carry__1_n_2\,
      CO(0) => \dx10_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1) => \dx10_carry__1_i_1_n_0\,
      DI(0) => \dx10_carry__1_i_2_n_0\,
      O(3) => \NLW_dx10_carry__1_O_UNCONNECTED\(3),
      O(2 downto 0) => dx10(10 downto 8),
      S(3) => '0',
      S(2) => \dx10_carry__1_i_3_n_0\,
      S(1) => \dx10_carry__1_i_4_n_0\,
      S(0) => \dx10_carry__1_i_5_n_0\
    );
\dx10_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dx12,
      I1 => \^x_reg[10]_0\(9),
      O => \dx10_carry__1_i_1_n_0\
    );
\dx10_carry__1_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dx12,
      I1 => \^x_reg[10]_0\(8),
      O => \dx10_carry__1_i_2_n_0\
    );
\dx10_carry__1_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^x_reg[10]_0\(10),
      I1 => Q(12),
      O => \dx10_carry__1_i_3_n_0\
    );
\dx10_carry__1_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^x_reg[10]_0\(9),
      I1 => Q(11),
      O => \dx10_carry__1_i_4_n_0\
    );
\dx10_carry__1_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^x_reg[10]_0\(8),
      I1 => Q(10),
      O => \dx10_carry__1_i_5_n_0\
    );
dx10_carry_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dx12,
      I1 => \^x_reg[10]_0\(3),
      O => dx10_carry_i_1_n_0
    );
dx10_carry_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dx12,
      I1 => \^x_reg[10]_0\(2),
      O => dx10_carry_i_2_n_0
    );
dx10_carry_i_3: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dx12,
      I1 => \^x_reg[10]_0\(1),
      O => dx10_carry_i_3_n_0
    );
dx10_carry_i_4: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dx12,
      I1 => \^x_reg[10]_0\(0),
      O => dx10_carry_i_4_n_0
    );
dx10_carry_i_5: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^x_reg[10]_0\(3),
      I1 => Q(5),
      O => dx10_carry_i_5_n_0
    );
dx10_carry_i_6: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^x_reg[10]_0\(2),
      I1 => Q(4),
      O => dx10_carry_i_6_n_0
    );
dx10_carry_i_7: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^x_reg[10]_0\(1),
      I1 => Q(3),
      O => dx10_carry_i_7_n_0
    );
dx10_carry_i_8: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^x_reg[10]_0\(0),
      I1 => Q(2),
      O => dx10_carry_i_8_n_0
    );
dx12_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => dx12_carry_n_0,
      CO(2) => dx12_carry_n_1,
      CO(1) => dx12_carry_n_2,
      CO(0) => dx12_carry_n_3,
      CYINIT => '1',
      DI(3) => dx12_carry_i_1_n_0,
      DI(2) => dx12_carry_i_2_n_0,
      DI(1) => dx12_carry_i_3_n_0,
      DI(0) => dx12_carry_i_4_n_0,
      O(3 downto 0) => NLW_dx12_carry_O_UNCONNECTED(3 downto 0),
      S(3 downto 0) => S(3 downto 0)
    );
\dx12_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => dx12_carry_n_0,
      CO(3 downto 2) => \NLW_dx12_carry__0_CO_UNCONNECTED\(3 downto 2),
      CO(1) => dx12,
      CO(0) => \dx12_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1) => \dx12_carry__0_i_1_n_0\,
      DI(0) => \dx12_carry__0_i_2_n_0\,
      O(3 downto 0) => \NLW_dx12_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3 downto 2) => B"00",
      S(1 downto 0) => \dx10_carry__1_i_1_0\(1 downto 0)
    );
\dx12_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \^x_reg[10]_0\(10),
      I1 => Q(12),
      O => \dx12_carry__0_i_1_n_0\
    );
\dx12_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \^x_reg[10]_0\(9),
      I1 => Q(11),
      I2 => \^x_reg[10]_0\(8),
      I3 => Q(10),
      O => \dx12_carry__0_i_2_n_0\
    );
dx12_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \^x_reg[10]_0\(7),
      I1 => Q(9),
      I2 => \^x_reg[10]_0\(6),
      I3 => Q(8),
      O => dx12_carry_i_1_n_0
    );
dx12_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \^x_reg[10]_0\(5),
      I1 => Q(7),
      I2 => \^x_reg[10]_0\(4),
      I3 => Q(6),
      O => dx12_carry_i_2_n_0
    );
dx12_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \^x_reg[10]_0\(3),
      I1 => Q(5),
      I2 => \^x_reg[10]_0\(2),
      I3 => Q(4),
      O => dx12_carry_i_3_n_0
    );
dx12_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \^x_reg[10]_0\(1),
      I1 => Q(3),
      I2 => \^x_reg[10]_0\(0),
      I3 => Q(2),
      O => dx12_carry_i_4_n_0
    );
\dx1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dx10(0),
      Q => p_0_in_0(0),
      R => SR(0)
    );
\dx1_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dx10(10),
      Q => p_0_in_0(10),
      R => SR(0)
    );
\dx1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dx10(1),
      Q => p_0_in_0(1),
      R => SR(0)
    );
\dx1_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dx10(2),
      Q => p_0_in_0(2),
      R => SR(0)
    );
\dx1_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dx10(3),
      Q => p_0_in_0(3),
      R => SR(0)
    );
\dx1_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dx10(4),
      Q => p_0_in_0(4),
      R => SR(0)
    );
\dx1_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dx10(5),
      Q => p_0_in_0(5),
      R => SR(0)
    );
\dx1_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dx10(6),
      Q => p_0_in_0(6),
      R => SR(0)
    );
\dx1_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dx10(7),
      Q => p_0_in_0(7),
      R => SR(0)
    );
\dx1_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dx10(8),
      Q => p_0_in_0(8),
      R => SR(0)
    );
\dx1_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dx10(9),
      Q => p_0_in_0(9),
      R => SR(0)
    );
dy10_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => dy10_carry_n_0,
      CO(2) => dy10_carry_n_1,
      CO(1) => dy10_carry_n_2,
      CO(0) => dy10_carry_n_3,
      CYINIT => '1',
      DI(3) => dy10_carry_i_1_n_0,
      DI(2) => dy10_carry_i_2_n_0,
      DI(1) => dy10_carry_i_3_n_0,
      DI(0) => dy10_carry_i_4_n_0,
      O(3 downto 0) => dy10(3 downto 0),
      S(3) => dy10_carry_i_5_n_0,
      S(2) => dy10_carry_i_6_n_0,
      S(1) => dy10_carry_i_7_n_0,
      S(0) => dy10_carry_i_8_n_0
    );
\dy10_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => dy10_carry_n_0,
      CO(3) => \dy10_carry__0_n_0\,
      CO(2) => \dy10_carry__0_n_1\,
      CO(1) => \dy10_carry__0_n_2\,
      CO(0) => \dy10_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \dy10_carry__0_i_1_n_0\,
      DI(2) => \dy10_carry__0_i_2_n_0\,
      DI(1) => \dy10_carry__0_i_3_n_0\,
      DI(0) => \dy10_carry__0_i_4_n_0\,
      O(3 downto 0) => dy10(7 downto 4),
      S(3) => \dy10_carry__0_i_5_n_0\,
      S(2) => \dy10_carry__0_i_6_n_0\,
      S(1) => \dy10_carry__0_i_7_n_0\,
      S(0) => \dy10_carry__0_i_8_n_0\
    );
\dy10_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dy12,
      I1 => \^y_reg[9]_0\(7),
      O => \dy10_carry__0_i_1_n_0\
    );
\dy10_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dy12,
      I1 => \^y_reg[9]_0\(6),
      O => \dy10_carry__0_i_2_n_0\
    );
\dy10_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dy12,
      I1 => \^y_reg[9]_0\(5),
      O => \dy10_carry__0_i_3_n_0\
    );
\dy10_carry__0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dy12,
      I1 => \^y_reg[9]_0\(4),
      O => \dy10_carry__0_i_4_n_0\
    );
\dy10_carry__0_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^y_reg[9]_0\(7),
      I1 => Q(20),
      O => \dy10_carry__0_i_5_n_0\
    );
\dy10_carry__0_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^y_reg[9]_0\(6),
      I1 => Q(19),
      O => \dy10_carry__0_i_6_n_0\
    );
\dy10_carry__0_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^y_reg[9]_0\(5),
      I1 => Q(18),
      O => \dy10_carry__0_i_7_n_0\
    );
\dy10_carry__0_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^y_reg[9]_0\(4),
      I1 => Q(17),
      O => \dy10_carry__0_i_8_n_0\
    );
\dy10_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \dy10_carry__0_n_0\,
      CO(3 downto 1) => \NLW_dy10_carry__1_CO_UNCONNECTED\(3 downto 1),
      CO(0) => \dy10_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => \dy10_carry__1_i_1_n_0\,
      O(3 downto 2) => \NLW_dy10_carry__1_O_UNCONNECTED\(3 downto 2),
      O(1 downto 0) => dy10(9 downto 8),
      S(3 downto 2) => B"00",
      S(1) => \dy1_reg[9]_0\(0),
      S(0) => \dy10_carry__1_i_3_n_0\
    );
\dy10_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dy12,
      I1 => \^y_reg[9]_0\(8),
      O => \dy10_carry__1_i_1_n_0\
    );
\dy10_carry__1_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^y_reg[9]_0\(8),
      I1 => Q(21),
      O => \dy10_carry__1_i_3_n_0\
    );
dy10_carry_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dy12,
      I1 => \^y_reg[9]_0\(3),
      O => dy10_carry_i_1_n_0
    );
dy10_carry_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dy12,
      I1 => \^y_reg[9]_0\(2),
      O => dy10_carry_i_2_n_0
    );
dy10_carry_i_3: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dy12,
      I1 => \^y_reg[9]_0\(1),
      O => dy10_carry_i_3_n_0
    );
dy10_carry_i_4: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dy12,
      I1 => \^y_reg[9]_0\(0),
      O => dy10_carry_i_4_n_0
    );
dy10_carry_i_5: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^y_reg[9]_0\(3),
      I1 => Q(16),
      O => dy10_carry_i_5_n_0
    );
dy10_carry_i_6: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^y_reg[9]_0\(2),
      I1 => Q(15),
      O => dy10_carry_i_6_n_0
    );
dy10_carry_i_7: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^y_reg[9]_0\(1),
      I1 => Q(14),
      O => dy10_carry_i_7_n_0
    );
dy10_carry_i_8: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^y_reg[9]_0\(0),
      I1 => Q(13),
      O => dy10_carry_i_8_n_0
    );
dy12_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => dy12_carry_n_0,
      CO(2) => dy12_carry_n_1,
      CO(1) => dy12_carry_n_2,
      CO(0) => dy12_carry_n_3,
      CYINIT => '1',
      DI(3) => dy12_carry_i_1_n_0,
      DI(2) => dy12_carry_i_2_n_0,
      DI(1) => dy12_carry_i_3_n_0,
      DI(0) => dy12_carry_i_4_n_0,
      O(3 downto 0) => NLW_dy12_carry_O_UNCONNECTED(3 downto 0),
      S(3 downto 0) => \dy12_carry__0_0\(3 downto 0)
    );
\dy12_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => dy12_carry_n_0,
      CO(3 downto 1) => \NLW_dy12_carry__0_CO_UNCONNECTED\(3 downto 1),
      CO(0) => dy12,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => \dy12_carry__0_i_1_n_0\,
      O(3 downto 0) => \NLW_dy12_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3 downto 1) => B"000",
      S(0) => \dy10_carry__1_i_1_0\(0)
    );
\dy12_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2B22"
    )
        port map (
      I0 => \^y_reg[9]_0\(9),
      I1 => Q(22),
      I2 => Q(21),
      I3 => \^y_reg[9]_0\(8),
      O => \dy12_carry__0_i_1_n_0\
    );
dy12_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \^y_reg[9]_0\(7),
      I1 => Q(20),
      I2 => \^y_reg[9]_0\(6),
      I3 => Q(19),
      O => dy12_carry_i_1_n_0
    );
dy12_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \^y_reg[9]_0\(5),
      I1 => Q(18),
      I2 => \^y_reg[9]_0\(4),
      I3 => Q(17),
      O => dy12_carry_i_2_n_0
    );
dy12_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \^y_reg[9]_0\(3),
      I1 => Q(16),
      I2 => \^y_reg[9]_0\(2),
      I3 => Q(15),
      O => dy12_carry_i_3_n_0
    );
dy12_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \^y_reg[9]_0\(1),
      I1 => Q(14),
      I2 => \^y_reg[9]_0\(0),
      I3 => Q(13),
      O => dy12_carry_i_4_n_0
    );
\dy1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dy10(0),
      Q => ay(0),
      R => SR(0)
    );
\dy1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dy10(1),
      Q => ay(1),
      R => SR(0)
    );
\dy1_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dy10(2),
      Q => ay(2),
      R => SR(0)
    );
\dy1_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dy10(3),
      Q => ay(3),
      R => SR(0)
    );
\dy1_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dy10(4),
      Q => ay(4),
      R => SR(0)
    );
\dy1_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dy10(5),
      Q => ay(5),
      R => SR(0)
    );
\dy1_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dy10(6),
      Q => ay(6),
      R => SR(0)
    );
\dy1_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dy10(7),
      Q => ay(7),
      R => SR(0)
    );
\dy1_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dy10(8),
      Q => ay(8),
      R => SR(0)
    );
\dy1_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => dy10(9),
      Q => ay(9),
      R => SR(0)
    );
enable1_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(0),
      Q => enable1,
      R => SR(0)
    );
fist1_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(1),
      Q => fist1,
      R => SR(0)
    );
hand1_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => hand10,
      Q => hand1,
      R => SR(0)
    );
\hand_left[7]_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => in_vs,
      I1 => \^vs_prev\,
      O => in_vs_0
    );
hit23_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => hit23_carry_n_0,
      CO(2) => hit23_carry_n_1,
      CO(1) => hit23_carry_n_2,
      CO(0) => hit23_carry_n_3,
      CYINIT => '0',
      DI(3) => hit23_carry_i_1_n_0,
      DI(2) => hit23_carry_i_2_n_0,
      DI(1) => hit23_carry_i_3_n_0,
      DI(0) => hit23_carry_i_4_n_0,
      O(3 downto 0) => NLW_hit23_carry_O_UNCONNECTED(3 downto 0),
      S(3) => hit23_carry_i_5_n_0,
      S(2) => hit23_carry_i_6_n_0,
      S(1) => hit23_carry_i_7_n_0,
      S(0) => hit23_carry_i_8_n_0
    );
\hit23_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => hit23_carry_n_0,
      CO(3 downto 2) => \NLW_hit23_carry__0_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \hit23_carry__0_n_2\,
      CO(0) => \hit23_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1) => \hit23_carry__0_i_1_n_0\,
      DI(0) => \hit23_carry__0_i_2_n_0\,
      O(3 downto 0) => \NLW_hit23_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3 downto 2) => B"00",
      S(1) => \hit23_carry__0_i_3_n_0\,
      S(0) => \hit23_carry__0_i_4_n_0\
    );
\hit23_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => hit23_carry_i_9_n_0,
      I1 => p_0_in_0(10),
      O => \hit23_carry__0_i_1_n_0\
    );
\hit23_carry__0_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"0E"
    )
        port map (
      I0 => p_0_in_0(9),
      I1 => p_0_in_0(8),
      I2 => hit23_carry_i_9_n_0,
      O => \hit23_carry__0_i_2_n_0\
    );
\hit23_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => p_0_in_0(10),
      I1 => hit23_carry_i_9_n_0,
      O => \hit23_carry__0_i_3_n_0\
    );
\hit23_carry__0_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"81"
    )
        port map (
      I0 => hit23_carry_i_9_n_0,
      I1 => p_0_in_0(8),
      I2 => p_0_in_0(9),
      O => \hit23_carry__0_i_4_n_0\
    );
hit23_carry_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"0E"
    )
        port map (
      I0 => p_0_in_0(7),
      I1 => p_0_in_0(6),
      I2 => hit23_carry_i_9_n_0,
      O => hit23_carry_i_1_n_0
    );
hit23_carry_i_10: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9FFFFFFF9FFF0000"
    )
        port map (
      I0 => ay(1),
      I1 => ay(0),
      I2 => hit23_carry_i_16_n_0,
      I3 => ay(2),
      I4 => fist1,
      I5 => hit23_carry_i_17_n_0,
      O => hit23_carry_i_10_n_0
    );
hit23_carry_i_11: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01111111"
    )
        port map (
      I0 => fist1,
      I1 => ay(3),
      I2 => ay(2),
      I3 => ay(1),
      I4 => ay(0),
      O => hit23_carry_i_11_n_0
    );
hit23_carry_i_12: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2F2FFCFC2A2A28A8"
    )
        port map (
      I0 => hit23_carry_i_15_n_0,
      I1 => ay(1),
      I2 => ay(0),
      I3 => ay(3),
      I4 => ay(2),
      I5 => hit23_carry_i_14_n_0,
      O => hit23_carry_i_12_n_0
    );
hit23_carry_i_13: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBFBFFFFBBFB0000"
    )
        port map (
      I0 => ay(0),
      I1 => hit23_carry_i_16_n_0,
      I2 => ay(1),
      I3 => ay(2),
      I4 => fist1,
      I5 => hit23_carry_i_18_n_0,
      O => hit23_carry_i_13_n_0
    );
hit23_carry_i_14: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => hit23_carry_i_16_n_0,
      I1 => fist1,
      O => hit23_carry_i_14_n_0
    );
hit23_carry_i_15: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0015"
    )
        port map (
      I0 => hit24_carry_i_17_n_0,
      I1 => ay(3),
      I2 => ay(2),
      I3 => fist1,
      O => hit23_carry_i_15_n_0
    );
hit23_carry_i_16: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0002"
    )
        port map (
      I0 => hit24_carry_i_16_n_0,
      I1 => ay(8),
      I2 => ay(7),
      I3 => ay(9),
      O => hit23_carry_i_16_n_0
    );
hit23_carry_i_17: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFE8CC"
    )
        port map (
      I0 => ay(2),
      I1 => ay(3),
      I2 => ay(0),
      I3 => ay(1),
      I4 => hit24_carry_i_17_n_0,
      O => hit23_carry_i_17_n_0
    );
hit23_carry_i_18: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFF99A"
    )
        port map (
      I0 => ay(2),
      I1 => ay(3),
      I2 => ay(1),
      I3 => ay(0),
      I4 => hit24_carry_i_17_n_0,
      O => hit23_carry_i_18_n_0
    );
hit23_carry_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"0E"
    )
        port map (
      I0 => p_0_in_0(5),
      I1 => p_0_in_0(4),
      I2 => hit23_carry_i_9_n_0,
      O => hit23_carry_i_2_n_0
    );
hit23_carry_i_3: unisim.vcomponents.LUT5
    generic map(
      INIT => X"202020F2"
    )
        port map (
      I0 => p_0_in_0(2),
      I1 => hit23_carry_i_10_n_0,
      I2 => p_0_in_0(3),
      I3 => hit23_carry_i_11_n_0,
      I4 => hit23_carry_i_9_n_0,
      O => hit23_carry_i_3_n_0
    );
hit23_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"88E8"
    )
        port map (
      I0 => p_0_in_0(1),
      I1 => hit23_carry_i_12_n_0,
      I2 => p_0_in_0(0),
      I3 => hit23_carry_i_13_n_0,
      O => hit23_carry_i_4_n_0
    );
hit23_carry_i_5: unisim.vcomponents.LUT3
    generic map(
      INIT => X"81"
    )
        port map (
      I0 => hit23_carry_i_9_n_0,
      I1 => p_0_in_0(7),
      I2 => p_0_in_0(6),
      O => hit23_carry_i_5_n_0
    );
hit23_carry_i_6: unisim.vcomponents.LUT3
    generic map(
      INIT => X"81"
    )
        port map (
      I0 => hit23_carry_i_9_n_0,
      I1 => p_0_in_0(4),
      I2 => p_0_in_0(5),
      O => hit23_carry_i_6_n_0
    );
hit23_carry_i_7: unisim.vcomponents.LUT5
    generic map(
      INIT => X"E10000E1"
    )
        port map (
      I0 => hit23_carry_i_9_n_0,
      I1 => hit23_carry_i_11_n_0,
      I2 => p_0_in_0(3),
      I3 => hit23_carry_i_10_n_0,
      I4 => p_0_in_0(2),
      O => hit23_carry_i_7_n_0
    );
hit23_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6006"
    )
        port map (
      I0 => hit23_carry_i_12_n_0,
      I1 => p_0_in_0(1),
      I2 => hit23_carry_i_13_n_0,
      I3 => p_0_in_0(0),
      O => hit23_carry_i_8_n_0
    );
hit23_carry_i_9: unisim.vcomponents.LUT6
    generic map(
      INIT => X"D0000000D555D555"
    )
        port map (
      I0 => hit23_carry_i_14_n_0,
      I1 => ay(2),
      I2 => ay(0),
      I3 => ay(1),
      I4 => ay(3),
      I5 => hit23_carry_i_15_n_0,
      O => hit23_carry_i_9_n_0
    );
\hit23_inferred__0/i__carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \hit23_inferred__0/i__carry_n_0\,
      CO(2) => \hit23_inferred__0/i__carry_n_1\,
      CO(1) => \hit23_inferred__0/i__carry_n_2\,
      CO(0) => \hit23_inferred__0/i__carry_n_3\,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_hit23_inferred__0/i__carry_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry_i_1__0_n_0\,
      S(2) => \i__carry_i_2__0_n_0\,
      S(1) => \i__carry_i_3__0_n_0\,
      S(0) => \i__carry_i_4__0_n_0\
    );
\hit23_inferred__0/i__carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \hit23_inferred__0/i__carry_n_0\,
      CO(3) => \hit23_inferred__0/i__carry__0_n_0\,
      CO(2) => \hit23_inferred__0/i__carry__0_n_1\,
      CO(1) => \hit23_inferred__0/i__carry__0_n_2\,
      CO(0) => \hit23_inferred__0/i__carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_hit23_inferred__0/i__carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry__0_i_1__0_n_0\,
      S(2) => \i__carry__0_i_2__0_n_0\,
      S(1) => \i__carry__0_i_3_n_0\,
      S(0) => \i__carry__0_i_4_n_0\
    );
\hit23_inferred__0/i__carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \hit23_inferred__0/i__carry__0_n_0\,
      CO(3) => \NLW_hit23_inferred__0/i__carry__1_CO_UNCONNECTED\(3),
      CO(2) => hit23,
      CO(1) => \hit23_inferred__0/i__carry__1_n_2\,
      CO(0) => \hit23_inferred__0/i__carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_hit23_inferred__0/i__carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \i__carry__1_i_1_n_0\,
      S(1) => \i__carry__1_i_2_n_0\,
      S(0) => \i__carry__1_i_3_n_0\
    );
\hit23_inferred__1/i__carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \hit23_inferred__1/i__carry_n_0\,
      CO(2) => \hit23_inferred__1/i__carry_n_1\,
      CO(1) => \hit23_inferred__1/i__carry_n_2\,
      CO(0) => \hit23_inferred__1/i__carry_n_3\,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_hit23_inferred__1/i__carry_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry_i_1_n_0\,
      S(2) => \i__carry_i_2_n_0\,
      S(1) => \i__carry_i_3_n_0\,
      S(0) => \i__carry_i_4_n_0\
    );
\hit23_inferred__1/i__carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \hit23_inferred__1/i__carry_n_0\,
      CO(3) => \hit23_inferred__1/i__carry__0_n_0\,
      CO(2) => \hit23_inferred__1/i__carry__0_n_1\,
      CO(1) => \hit23_inferred__1/i__carry__0_n_2\,
      CO(0) => \hit23_inferred__1/i__carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_hit23_inferred__1/i__carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry__0_i_1__1_n_0\,
      S(2) => \i__carry__0_i_2__1_n_0\,
      S(1) => \i__carry__0_i_3__0_n_0\,
      S(0) => \i__carry__0_i_4__0_n_0\
    );
\hit23_inferred__1/i__carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \hit23_inferred__1/i__carry__0_n_0\,
      CO(3) => \NLW_hit23_inferred__1/i__carry__1_CO_UNCONNECTED\(3),
      CO(2) => hit230_out,
      CO(1) => \hit23_inferred__1/i__carry__1_n_2\,
      CO(0) => \hit23_inferred__1/i__carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_hit23_inferred__1/i__carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \i__carry__1_i_1__0_n_0\,
      S(1) => \i__carry__1_i_2__0_n_0\,
      S(0) => \i__carry__1_i_3__0_n_0\
    );
hit24_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => hit24_carry_n_0,
      CO(2) => hit24_carry_n_1,
      CO(1) => hit24_carry_n_2,
      CO(0) => hit24_carry_n_3,
      CYINIT => '1',
      DI(3) => hit24_carry_i_1_n_0,
      DI(2) => hit24_carry_i_2_n_0,
      DI(1) => hit24_carry_i_3_n_0,
      DI(0) => hit24_carry_i_4_n_0,
      O(3 downto 0) => NLW_hit24_carry_O_UNCONNECTED(3 downto 0),
      S(3) => hit24_carry_i_5_n_0,
      S(2) => hit24_carry_i_6_n_0,
      S(1) => hit24_carry_i_7_n_0,
      S(0) => hit24_carry_i_8_n_0
    );
\hit24_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => hit24_carry_n_0,
      CO(3 downto 2) => \NLW_hit24_carry__0_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \hit24_carry__0_n_2\,
      CO(0) => \hit24_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => \hit24_carry__0_i_1_n_0\,
      O(3 downto 0) => \NLW_hit24_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3 downto 2) => B"00",
      S(1) => \hit24_carry__0_i_2_n_0\,
      S(0) => \hit24_carry__0_i_3_n_0\
    );
\hit24_carry__0_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"15"
    )
        port map (
      I0 => hit24_carry_i_9_n_0,
      I1 => p_0_in_0(9),
      I2 => p_0_in_0(8),
      O => \hit24_carry__0_i_1_n_0\
    );
\hit24_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => hit24_carry_i_9_n_0,
      I1 => p_0_in_0(10),
      O => \hit24_carry__0_i_2_n_0\
    );
\hit24_carry__0_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"42"
    )
        port map (
      I0 => hit24_carry_i_9_n_0,
      I1 => p_0_in_0(8),
      I2 => p_0_in_0(9),
      O => \hit24_carry__0_i_3_n_0\
    );
hit24_carry_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"15"
    )
        port map (
      I0 => hit24_carry_i_9_n_0,
      I1 => p_0_in_0(7),
      I2 => p_0_in_0(6),
      O => hit24_carry_i_1_n_0
    );
hit24_carry_i_10: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFEEE9FFFF5557"
    )
        port map (
      I0 => fist1,
      I1 => ay(2),
      I2 => ay(0),
      I3 => ay(1),
      I4 => hit24_carry_i_17_n_0,
      I5 => ay(3),
      O => hit24_carry_i_10_n_0
    );
hit24_carry_i_11: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFECEEEFFFCEEED"
    )
        port map (
      I0 => fist1,
      I1 => hit24_carry_i_17_n_0,
      I2 => ay(0),
      I3 => ay(1),
      I4 => ay(3),
      I5 => ay(2),
      O => hit24_carry_i_11_n_0
    );
hit24_carry_i_12: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000014000873"
    )
        port map (
      I0 => fist1,
      I1 => ay(2),
      I2 => ay(3),
      I3 => ay(1),
      I4 => ay(0),
      I5 => hit24_carry_i_17_n_0,
      O => hit24_carry_i_12_n_0
    );
hit24_carry_i_13: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000001531E03"
    )
        port map (
      I0 => fist1,
      I1 => ay(0),
      I2 => ay(1),
      I3 => ay(2),
      I4 => ay(3),
      I5 => hit24_carry_i_17_n_0,
      O => hit24_carry_i_13_n_0
    );
hit24_carry_i_14: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E000"
    )
        port map (
      I0 => ay(0),
      I1 => ay(1),
      I2 => ay(2),
      I3 => ay(3),
      O => hit24_carry_i_14_n_0
    );
hit24_carry_i_15: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => ay(9),
      I1 => ay(7),
      I2 => ay(8),
      O => hit24_carry_i_15_n_0
    );
hit24_carry_i_16: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => ay(4),
      I1 => ay(3),
      I2 => ay(5),
      I3 => ay(6),
      O => hit24_carry_i_16_n_0
    );
hit24_carry_i_17: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => ay(7),
      I1 => ay(6),
      I2 => ay(9),
      I3 => ay(8),
      I4 => ay(4),
      I5 => ay(5),
      O => hit24_carry_i_17_n_0
    );
hit24_carry_i_18: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => ay(2),
      I1 => ay(0),
      I2 => ay(1),
      O => hit24_carry_i_18_n_0
    );
hit24_carry_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"15"
    )
        port map (
      I0 => hit24_carry_i_9_n_0,
      I1 => p_0_in_0(5),
      I2 => p_0_in_0(4),
      O => hit24_carry_i_2_n_0
    );
hit24_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => p_0_in_0(3),
      I1 => hit24_carry_i_10_n_0,
      I2 => hit24_carry_i_11_n_0,
      I3 => p_0_in_0(2),
      O => hit24_carry_i_3_n_0
    );
hit24_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1117"
    )
        port map (
      I0 => p_0_in_0(1),
      I1 => hit24_carry_i_12_n_0,
      I2 => p_0_in_0(0),
      I3 => hit24_carry_i_13_n_0,
      O => hit24_carry_i_4_n_0
    );
hit24_carry_i_5: unisim.vcomponents.LUT3
    generic map(
      INIT => X"42"
    )
        port map (
      I0 => hit24_carry_i_9_n_0,
      I1 => p_0_in_0(6),
      I2 => p_0_in_0(7),
      O => hit24_carry_i_5_n_0
    );
hit24_carry_i_6: unisim.vcomponents.LUT3
    generic map(
      INIT => X"42"
    )
        port map (
      I0 => hit24_carry_i_9_n_0,
      I1 => p_0_in_0(4),
      I2 => p_0_in_0(5),
      O => hit24_carry_i_6_n_0
    );
hit24_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => hit24_carry_i_10_n_0,
      I1 => p_0_in_0(3),
      I2 => hit24_carry_i_11_n_0,
      I3 => p_0_in_0(2),
      O => hit24_carry_i_7_n_0
    );
hit24_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0660"
    )
        port map (
      I0 => hit24_carry_i_12_n_0,
      I1 => p_0_in_0(1),
      I2 => hit24_carry_i_13_n_0,
      I3 => p_0_in_0(0),
      O => hit24_carry_i_8_n_0
    );
hit24_carry_i_9: unisim.vcomponents.LUT6
    generic map(
      INIT => X"300030553000FF55"
    )
        port map (
      I0 => hit24_carry_i_14_n_0,
      I1 => hit24_carry_i_15_n_0,
      I2 => hit24_carry_i_16_n_0,
      I3 => fist1,
      I4 => hit24_carry_i_17_n_0,
      I5 => hit24_carry_i_18_n_0,
      O => hit24_carry_i_9_n_0
    );
hit2_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8088"
    )
        port map (
      I0 => enable1,
      I1 => de_prev,
      I2 => \^x1_reg[3]_0\,
      I3 => hit2_i_3_n_0,
      O => hit21_out
    );
hit2_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \paint2[21]_i_3_n_0\,
      I1 => \^y1_reg[9]_0\,
      O => \^x1_reg[3]_0\
    );
hit2_i_3: unisim.vcomponents.LUT5
    generic map(
      INIT => X"5DDDDDDD"
    )
        port map (
      I0 => hand1,
      I1 => hit2_i_4_n_0,
      I2 => hit24_carry_i_9_n_0,
      I3 => \hit23_carry__0_n_2\,
      I4 => \hit24_carry__0_n_2\,
      O => hit2_i_3_n_0
    );
hit2_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => hit24_carry_i_17_n_0,
      I1 => p_0_in_0(2),
      I2 => p_0_in_0(9),
      I3 => p_0_in_0(4),
      I4 => hit2_i_5_n_0,
      I5 => hit2_i_6_n_0,
      O => hit2_i_4_n_0
    );
hit2_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => p_0_in_0(5),
      I1 => p_0_in_0(1),
      I2 => ay(1),
      I3 => p_0_in_0(3),
      O => hit2_i_5_n_0
    );
hit2_i_6: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => ay(2),
      I1 => ay(3),
      I2 => p_0_in_0(8),
      I3 => p_0_in_0(10),
      I4 => p_0_in_0(6),
      I5 => p_0_in_0(7),
      O => hit2_i_6_n_0
    );
hit2_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => hit21_out,
      Q => \hit2__0\,
      R => SR(0)
    );
hs1_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_hs,
      Q => hs1,
      R => SR(0)
    );
hs2_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => hs1,
      Q => hs2,
      R => SR(0)
    );
\i__carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => level1(9),
      I1 => loud1(9),
      I2 => level1(8),
      I3 => loud1(8),
      O => \i__carry__0_i_1_n_0\
    );
\i__carry__0_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry__0_i_1__0_n_0\
    );
\i__carry__0_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry__0_i_1__1_n_0\
    );
\i__carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => loud1(9),
      I1 => level1(9),
      I2 => loud1(8),
      I3 => level1(8),
      O => \i__carry__0_i_2_n_0\
    );
\i__carry__0_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry__0_i_2__0_n_0\
    );
\i__carry__0_i_2__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry__0_i_2__1_n_0\
    );
\i__carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry__0_i_3_n_0\
    );
\i__carry__0_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry__0_i_3__0_n_0\
    );
\i__carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry__0_i_4_n_0\
    );
\i__carry__0_i_4__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry__0_i_4__0_n_0\
    );
\i__carry__0_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => y1(4),
      I1 => y1(2),
      I2 => y1(1),
      I3 => y1(0),
      I4 => y1(3),
      O => \i__carry__0_i_5_n_0\
    );
\i__carry__1_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry__1_i_1_n_0\
    );
\i__carry__1_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry__1_i_1__0_n_0\
    );
\i__carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry__1_i_2_n_0\
    );
\i__carry__1_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry__1_i_2__0_n_0\
    );
\i__carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry__1_i_3_n_0\
    );
\i__carry__1_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry__1_i_3__0_n_0\
    );
\i__carry_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \i__carry_i_5_n_0\,
      I1 => soft1(9),
      O => \i__carry_i_1_n_0\
    );
\i__carry_i_10\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5556"
    )
        port map (
      I0 => y1(3),
      I1 => y1(0),
      I2 => y1(1),
      I3 => y1(2),
      O => \i__carry_i_10_n_0\
    );
\i__carry_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAAAAA9"
    )
        port map (
      I0 => y1(5),
      I1 => y1(3),
      I2 => y1(0),
      I3 => y1(1),
      I4 => y1(2),
      I5 => y1(4),
      O => \i__carry_i_11_n_0\
    );
\i__carry_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \i__carry_i_5_n_0\,
      I1 => loud1(9),
      O => \i__carry_i_1__0_n_0\
    );
\i__carry_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => level1(7),
      I1 => loud1(7),
      I2 => level1(6),
      I3 => loud1(6),
      O => \i__carry_i_1__1_n_0\
    );
\i__carry_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0660000000000660"
    )
        port map (
      I0 => soft1(7),
      I1 => \i__carry_i_6__0_n_0\,
      I2 => soft1(6),
      I3 => \i__carry_i_7_n_0\,
      I4 => \i__carry_i_8_n_0\,
      I5 => soft1(8),
      O => \i__carry_i_2_n_0\
    );
\i__carry_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0660000000000660"
    )
        port map (
      I0 => loud1(7),
      I1 => \i__carry_i_6__0_n_0\,
      I2 => loud1(6),
      I3 => \i__carry_i_7_n_0\,
      I4 => \i__carry_i_8_n_0\,
      I5 => loud1(8),
      O => \i__carry_i_2__0_n_0\
    );
\i__carry_i_2__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => level1(5),
      I1 => loud1(5),
      I2 => level1(4),
      I3 => loud1(4),
      O => \i__carry_i_2__1_n_0\
    );
\i__carry_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => soft1(4),
      I1 => \i__carry_i_9_n_0\,
      I2 => soft1(3),
      I3 => \i__carry_i_10_n_0\,
      I4 => \i__carry_i_11_n_0\,
      I5 => soft1(5),
      O => \i__carry_i_3_n_0\
    );
\i__carry_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => loud1(4),
      I1 => \i__carry_i_9_n_0\,
      I2 => loud1(3),
      I3 => \i__carry_i_10_n_0\,
      I4 => \i__carry_i_11_n_0\,
      I5 => loud1(5),
      O => \i__carry_i_3__0_n_0\
    );
\i__carry_i_3__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => level1(3),
      I1 => loud1(3),
      I2 => level1(2),
      I3 => loud1(2),
      O => \i__carry_i_3__1_n_0\
    );
\i__carry_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0408021040802001"
    )
        port map (
      I0 => soft1(1),
      I1 => soft1(0),
      I2 => y1(2),
      I3 => y1(1),
      I4 => y1(0),
      I5 => soft1(2),
      O => \i__carry_i_4_n_0\
    );
\i__carry_i_4__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0408021040802001"
    )
        port map (
      I0 => loud1(1),
      I1 => loud1(0),
      I2 => y1(2),
      I3 => y1(1),
      I4 => y1(0),
      I5 => loud1(2),
      O => \i__carry_i_4__0_n_0\
    );
\i__carry_i_4__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => level1(1),
      I1 => loud1(1),
      I2 => level1(0),
      I3 => loud1(0),
      O => \i__carry_i_4__1_n_0\
    );
\i__carry_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \i__carry_i_5_n_0\
    );
\i__carry_i_5__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => loud1(7),
      I1 => level1(7),
      I2 => loud1(6),
      I3 => level1(6),
      O => \i__carry_i_5__0_n_0\
    );
\i__carry_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => loud1(5),
      I1 => level1(5),
      I2 => loud1(4),
      I3 => level1(4),
      O => \i__carry_i_6_n_0\
    );
\i__carry_i_6__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9AAA"
    )
        port map (
      I0 => y1(7),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      O => \i__carry_i_6__0_n_0\
    );
\i__carry_i_7\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"9A"
    )
        port map (
      I0 => y1(6),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(5),
      O => \i__carry_i_7_n_0\
    );
\i__carry_i_7__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => loud1(3),
      I1 => level1(3),
      I2 => loud1(2),
      I3 => level1(2),
      O => \i__carry_i_7__0_n_0\
    );
\i__carry_i_8\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"55559555"
    )
        port map (
      I0 => y1(8),
      I1 => y1(7),
      I2 => y1(5),
      I3 => y1(6),
      I4 => \i__carry__0_i_5_n_0\,
      O => \i__carry_i_8_n_0\
    );
\i__carry_i_8__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => loud1(1),
      I1 => level1(1),
      I2 => loud1(0),
      I3 => level1(0),
      O => \i__carry_i_8__0_n_0\
    );
\i__carry_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"55555556"
    )
        port map (
      I0 => y1(4),
      I1 => y1(2),
      I2 => y1(1),
      I3 => y1(0),
      I4 => y1(3),
      O => \i__carry_i_9_n_0\
    );
\level1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(23),
      Q => level1(0),
      R => SR(0)
    );
\level1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(24),
      Q => level1(1),
      R => SR(0)
    );
\level1_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(25),
      Q => level1(2),
      R => SR(0)
    );
\level1_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(26),
      Q => level1(3),
      R => SR(0)
    );
\level1_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(27),
      Q => level1(4),
      R => SR(0)
    );
\level1_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(28),
      Q => level1(5),
      R => SR(0)
    );
\level1_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(29),
      Q => level1(6),
      R => SR(0)
    );
\level1_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(30),
      Q => level1(7),
      R => SR(0)
    );
\level1_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(31),
      Q => level1(8),
      R => SR(0)
    );
\level1_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(32),
      Q => level1(9),
      R => SR(0)
    );
\loud1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(43),
      Q => loud1(0),
      R => SR(0)
    );
\loud1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(44),
      Q => loud1(1),
      R => SR(0)
    );
\loud1_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(45),
      Q => loud1(2),
      R => SR(0)
    );
\loud1_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(46),
      Q => loud1(3),
      R => SR(0)
    );
\loud1_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(47),
      Q => loud1(4),
      R => SR(0)
    );
\loud1_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(48),
      Q => loud1(5),
      R => SR(0)
    );
\loud1_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(49),
      Q => loud1(6),
      R => SR(0)
    );
\loud1_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(50),
      Q => loud1(7),
      R => SR(0)
    );
\loud1_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(51),
      Q => loud1(8),
      R => SR(0)
    );
\loud1_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(52),
      Q => loud1(9),
      R => SR(0)
    );
out_de_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => de2,
      Q => out_de,
      R => SR(0)
    );
out_hs_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => hs2,
      Q => out_hs,
      R => SR(0)
    );
\out_rgb[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"70"
    )
        port map (
      I0 => \hit2__0\,
      I1 => de2,
      I2 => rgb2(0),
      O => \out_rgb[0]_i_1_n_0\
    );
\out_rgb[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"70"
    )
        port map (
      I0 => \hit2__0\,
      I1 => de2,
      I2 => rgb2(10),
      O => \out_rgb[10]_i_1_n_0\
    );
\out_rgb[11]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[11]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(11),
      O => \out_rgb[11]_i_1_n_0\
    );
\out_rgb[12]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[12]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(12),
      O => \out_rgb[12]_i_1_n_0\
    );
\out_rgb[13]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[13]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(13),
      O => \out_rgb[13]_i_1_n_0\
    );
\out_rgb[14]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[22]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(14),
      O => \out_rgb[14]_i_1_n_0\
    );
\out_rgb[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[15]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(15),
      O => \out_rgb[15]_i_1_n_0\
    );
\out_rgb[16]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[19]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(16),
      O => \out_rgb[16]_i_1_n_0\
    );
\out_rgb[17]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[19]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(17),
      O => \out_rgb[17]_i_1_n_0\
    );
\out_rgb[18]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[19]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(18),
      O => \out_rgb[18]_i_1_n_0\
    );
\out_rgb[19]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[19]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(19),
      O => \out_rgb[19]_i_1_n_0\
    );
\out_rgb[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"70"
    )
        port map (
      I0 => \hit2__0\,
      I1 => de2,
      I2 => rgb2(1),
      O => \out_rgb[1]_i_1_n_0\
    );
\out_rgb[20]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[20]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(20),
      O => \out_rgb[20]_i_1_n_0\
    );
\out_rgb[21]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[21]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(21),
      O => \out_rgb[21]_i_1_n_0\
    );
\out_rgb[22]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[22]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(22),
      O => \out_rgb[22]_i_1_n_0\
    );
\out_rgb[23]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[23]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(23),
      O => \out_rgb[23]_i_2_n_0\
    );
\out_rgb[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[2]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(2),
      O => \out_rgb[2]_i_1_n_0\
    );
\out_rgb[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[19]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(3),
      O => \out_rgb[3]_i_1_n_0\
    );
\out_rgb[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[4]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(4),
      O => \out_rgb[4]_i_1_n_0\
    );
\out_rgb[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[13]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(5),
      O => \out_rgb[5]_i_1_n_0\
    );
\out_rgb[6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[22]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(6),
      O => \out_rgb[6]_i_1_n_0\
    );
\out_rgb[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \paint2_reg_n_0_[7]\,
      I1 => \hit2__0\,
      I2 => de2,
      I3 => rgb2(7),
      O => \out_rgb[7]_i_1_n_0\
    );
\out_rgb[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"70"
    )
        port map (
      I0 => \hit2__0\,
      I1 => de2,
      I2 => rgb2(8),
      O => \out_rgb[8]_i_1_n_0\
    );
\out_rgb[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"70"
    )
        port map (
      I0 => \hit2__0\,
      I1 => de2,
      I2 => rgb2(9),
      O => \out_rgb[9]_i_1_n_0\
    );
\out_rgb_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[0]_i_1_n_0\,
      Q => out_rgb(0),
      R => SR(0)
    );
\out_rgb_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[10]_i_1_n_0\,
      Q => out_rgb(10),
      R => SR(0)
    );
\out_rgb_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[11]_i_1_n_0\,
      Q => out_rgb(11),
      R => SR(0)
    );
\out_rgb_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[12]_i_1_n_0\,
      Q => out_rgb(12),
      R => SR(0)
    );
\out_rgb_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[13]_i_1_n_0\,
      Q => out_rgb(13),
      R => SR(0)
    );
\out_rgb_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[14]_i_1_n_0\,
      Q => out_rgb(14),
      R => SR(0)
    );
\out_rgb_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[15]_i_1_n_0\,
      Q => out_rgb(15),
      R => SR(0)
    );
\out_rgb_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[16]_i_1_n_0\,
      Q => out_rgb(16),
      R => SR(0)
    );
\out_rgb_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[17]_i_1_n_0\,
      Q => out_rgb(17),
      R => SR(0)
    );
\out_rgb_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[18]_i_1_n_0\,
      Q => out_rgb(18),
      R => SR(0)
    );
\out_rgb_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[19]_i_1_n_0\,
      Q => out_rgb(19),
      R => SR(0)
    );
\out_rgb_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[1]_i_1_n_0\,
      Q => out_rgb(1),
      R => SR(0)
    );
\out_rgb_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[20]_i_1_n_0\,
      Q => out_rgb(20),
      R => SR(0)
    );
\out_rgb_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[21]_i_1_n_0\,
      Q => out_rgb(21),
      R => SR(0)
    );
\out_rgb_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[22]_i_1_n_0\,
      Q => out_rgb(22),
      R => SR(0)
    );
\out_rgb_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[23]_i_2_n_0\,
      Q => out_rgb(23),
      R => SR(0)
    );
\out_rgb_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[2]_i_1_n_0\,
      Q => out_rgb(2),
      R => SR(0)
    );
\out_rgb_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[3]_i_1_n_0\,
      Q => out_rgb(3),
      R => SR(0)
    );
\out_rgb_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[4]_i_1_n_0\,
      Q => out_rgb(4),
      R => SR(0)
    );
\out_rgb_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[5]_i_1_n_0\,
      Q => out_rgb(5),
      R => SR(0)
    );
\out_rgb_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[6]_i_1_n_0\,
      Q => out_rgb(6),
      R => SR(0)
    );
\out_rgb_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[7]_i_1_n_0\,
      Q => out_rgb(7),
      R => SR(0)
    );
\out_rgb_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[8]_i_1_n_0\,
      Q => out_rgb(8),
      R => SR(0)
    );
\out_rgb_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \out_rgb[9]_i_1_n_0\,
      Q => out_rgb(9),
      R => SR(0)
    );
out_vs_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => vs2,
      Q => out_vs,
      R => SR(0)
    );
paint22_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => paint22_carry_n_0,
      CO(2) => paint22_carry_n_1,
      CO(1) => paint22_carry_n_2,
      CO(0) => paint22_carry_n_3,
      CYINIT => '1',
      DI(3) => paint22_carry_i_1_n_0,
      DI(2) => paint22_carry_i_2_n_0,
      DI(1) => paint22_carry_i_3_n_0,
      DI(0) => paint22_carry_i_4_n_0,
      O(3 downto 0) => NLW_paint22_carry_O_UNCONNECTED(3 downto 0),
      S(3) => paint22_carry_i_5_n_0,
      S(2) => paint22_carry_i_6_n_0,
      S(1) => paint22_carry_i_7_n_0,
      S(0) => paint22_carry_i_8_n_0
    );
\paint22_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => paint22_carry_n_0,
      CO(3) => \paint22_carry__0_n_0\,
      CO(2) => \paint22_carry__0_n_1\,
      CO(1) => \paint22_carry__0_n_2\,
      CO(0) => \paint22_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => \paint22_carry__0_i_1_n_0\,
      O(3 downto 0) => \NLW_paint22_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \paint22_carry__0_i_2_n_0\,
      S(2) => \paint22_carry__0_i_3_n_0\,
      S(1) => \paint22_carry__0_i_4_n_0\,
      S(0) => \paint22_carry__0_i_5_n_0\
    );
\paint22_carry__0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"8AE308A2"
    )
        port map (
      I0 => level1(9),
      I1 => y1(8),
      I2 => \paint22_carry__0_i_6_n_0\,
      I3 => y1(9),
      I4 => level1(8),
      O => \paint22_carry__0_i_1_n_0\
    );
\paint22_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \paint22_carry__0_i_2_n_0\
    );
\paint22_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \paint22_carry__0_i_3_n_0\
    );
\paint22_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \paint22_carry__0_i_4_n_0\
    );
\paint22_carry__0_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"09609009"
    )
        port map (
      I0 => y1(9),
      I1 => level1(9),
      I2 => y1(8),
      I3 => \paint22_carry__0_i_6_n_0\,
      I4 => level1(8),
      O => \paint22_carry__0_i_5_n_0\
    );
\paint22_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BFFF"
    )
        port map (
      I0 => \i__carry__0_i_5_n_0\,
      I1 => y1(6),
      I2 => y1(5),
      I3 => y1(7),
      O => \paint22_carry__0_i_6_n_0\
    );
\paint22_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \paint22_carry__0_n_0\,
      CO(3) => \paint22_carry__1_n_0\,
      CO(2) => \paint22_carry__1_n_1\,
      CO(1) => \paint22_carry__1_n_2\,
      CO(0) => \paint22_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_paint22_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \paint22_carry__1_i_1_n_0\,
      S(2) => \paint22_carry__1_i_2_n_0\,
      S(1) => \paint22_carry__1_i_3_n_0\,
      S(0) => \paint22_carry__1_i_4_n_0\
    );
\paint22_carry__1_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \paint22_carry__1_i_1_n_0\
    );
\paint22_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \paint22_carry__1_i_2_n_0\
    );
\paint22_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \paint22_carry__1_i_3_n_0\
    );
\paint22_carry__1_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \paint22_carry__1_i_4_n_0\
    );
\paint22_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \paint22_carry__1_n_0\,
      CO(3) => paint22,
      CO(2) => \paint22_carry__2_n_1\,
      CO(1) => \paint22_carry__2_n_2\,
      CO(0) => \paint22_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_paint22_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \paint22_carry__2_i_1_n_0\,
      S(2) => \paint22_carry__2_i_2_n_0\,
      S(1) => \paint22_carry__2_i_3_n_0\,
      S(0) => \paint22_carry__2_i_4_n_0\
    );
\paint22_carry__2_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \paint22_carry__2_i_1_n_0\
    );
\paint22_carry__2_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \paint22_carry__2_i_2_n_0\
    );
\paint22_carry__2_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \paint22_carry__2_i_3_n_0\
    );
\paint22_carry__2_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4555555555555555"
    )
        port map (
      I0 => y1(9),
      I1 => \i__carry__0_i_5_n_0\,
      I2 => y1(6),
      I3 => y1(5),
      I4 => y1(7),
      I5 => y1(8),
      O => \paint22_carry__2_i_4_n_0\
    );
paint22_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FA3EA0A8AA2A0080"
    )
        port map (
      I0 => level1(7),
      I1 => y1(5),
      I2 => y1(6),
      I3 => \i__carry__0_i_5_n_0\,
      I4 => y1(7),
      I5 => level1(6),
      O => paint22_carry_i_1_n_0
    );
paint22_carry_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"83EA02A8"
    )
        port map (
      I0 => level1(5),
      I1 => y1(4),
      I2 => paint22_carry_i_9_n_0,
      I3 => y1(5),
      I4 => level1(4),
      O => paint22_carry_i_2_n_0
    );
paint22_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EEEA8883AAA80002"
    )
        port map (
      I0 => level1(3),
      I1 => y1(2),
      I2 => y1(1),
      I3 => y1(0),
      I4 => y1(3),
      I5 => level1(2),
      O => paint22_carry_i_3_n_0
    );
paint22_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A382"
    )
        port map (
      I0 => level1(1),
      I1 => y1(0),
      I2 => y1(1),
      I3 => level1(0),
      O => paint22_carry_i_4_n_0
    );
paint22_carry_i_5: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0690060660066060"
    )
        port map (
      I0 => y1(7),
      I1 => level1(7),
      I2 => y1(6),
      I3 => \i__carry__0_i_5_n_0\,
      I4 => y1(5),
      I5 => level1(6),
      O => paint22_carry_i_5_n_0
    );
paint22_carry_i_6: unisim.vcomponents.LUT5
    generic map(
      INIT => X"09909006"
    )
        port map (
      I0 => y1(5),
      I1 => level1(5),
      I2 => y1(4),
      I3 => paint22_carry_i_9_n_0,
      I4 => level1(4),
      O => paint22_carry_i_6_n_0
    );
paint22_carry_i_7: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0606066060606009"
    )
        port map (
      I0 => y1(3),
      I1 => level1(3),
      I2 => y1(2),
      I3 => y1(1),
      I4 => y1(0),
      I5 => level1(2),
      O => paint22_carry_i_7_n_0
    );
paint22_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6009"
    )
        port map (
      I0 => y1(1),
      I1 => level1(1),
      I2 => level1(0),
      I3 => y1(0),
      O => paint22_carry_i_8_n_0
    );
paint22_carry_i_9: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => y1(3),
      I1 => y1(0),
      I2 => y1(1),
      I3 => y1(2),
      O => paint22_carry_i_9_n_0
    );
\paint22_inferred__0/i__carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \paint22_inferred__0/i__carry_n_0\,
      CO(2) => \paint22_inferred__0/i__carry_n_1\,
      CO(1) => \paint22_inferred__0/i__carry_n_2\,
      CO(0) => \paint22_inferred__0/i__carry_n_3\,
      CYINIT => '1',
      DI(3) => \i__carry_i_1__1_n_0\,
      DI(2) => \i__carry_i_2__1_n_0\,
      DI(1) => \i__carry_i_3__1_n_0\,
      DI(0) => \i__carry_i_4__1_n_0\,
      O(3 downto 0) => \NLW_paint22_inferred__0/i__carry_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry_i_5__0_n_0\,
      S(2) => \i__carry_i_6_n_0\,
      S(1) => \i__carry_i_7__0_n_0\,
      S(0) => \i__carry_i_8__0_n_0\
    );
\paint22_inferred__0/i__carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \paint22_inferred__0/i__carry_n_0\,
      CO(3 downto 1) => \NLW_paint22_inferred__0/i__carry__0_CO_UNCONNECTED\(3 downto 1),
      CO(0) => \paint22_inferred__0/i__carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => \i__carry__0_i_1_n_0\,
      O(3 downto 0) => \NLW_paint22_inferred__0/i__carry__0_O_UNCONNECTED\(3 downto 0),
      S(3 downto 1) => B"000",
      S(0) => \i__carry__0_i_2_n_0\
    );
paint23_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => paint23_carry_n_0,
      CO(2) => paint23_carry_n_1,
      CO(1) => paint23_carry_n_2,
      CO(0) => paint23_carry_n_3,
      CYINIT => '1',
      DI(3) => paint23_carry_i_1_n_0,
      DI(2) => paint23_carry_i_2_n_0,
      DI(1) => paint23_carry_i_3_n_0,
      DI(0) => paint23_carry_i_4_n_0,
      O(3 downto 0) => NLW_paint23_carry_O_UNCONNECTED(3 downto 0),
      S(3) => paint23_carry_i_5_n_0,
      S(2) => paint23_carry_i_6_n_0,
      S(1) => paint23_carry_i_7_n_0,
      S(0) => paint23_carry_i_8_n_0
    );
\paint23_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => paint23_carry_n_0,
      CO(3 downto 1) => \NLW_paint23_carry__0_CO_UNCONNECTED\(3 downto 1),
      CO(0) => paint23,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => \paint23_carry_i_1__0_n_0\,
      O(3 downto 0) => \NLW_paint23_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3 downto 1) => B"000",
      S(0) => \paint23_carry_i_2__0_n_0\
    );
paint23_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => level1(7),
      I1 => soft1(7),
      I2 => level1(6),
      I3 => soft1(6),
      O => paint23_carry_i_1_n_0
    );
\paint23_carry_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => level1(9),
      I1 => soft1(9),
      I2 => level1(8),
      I3 => soft1(8),
      O => \paint23_carry_i_1__0_n_0\
    );
paint23_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => level1(5),
      I1 => soft1(5),
      I2 => level1(4),
      I3 => soft1(4),
      O => paint23_carry_i_2_n_0
    );
\paint23_carry_i_2__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => soft1(9),
      I1 => level1(9),
      I2 => soft1(8),
      I3 => level1(8),
      O => \paint23_carry_i_2__0_n_0\
    );
paint23_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => level1(3),
      I1 => soft1(3),
      I2 => level1(2),
      I3 => soft1(2),
      O => paint23_carry_i_3_n_0
    );
paint23_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => level1(1),
      I1 => soft1(1),
      I2 => level1(0),
      I3 => soft1(0),
      O => paint23_carry_i_4_n_0
    );
paint23_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => soft1(7),
      I1 => level1(7),
      I2 => soft1(6),
      I3 => level1(6),
      O => paint23_carry_i_5_n_0
    );
paint23_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => soft1(5),
      I1 => level1(5),
      I2 => soft1(4),
      I3 => level1(4),
      O => paint23_carry_i_6_n_0
    );
paint23_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => soft1(3),
      I1 => level1(3),
      I2 => soft1(2),
      I3 => level1(2),
      O => paint23_carry_i_7_n_0
    );
paint23_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => soft1(1),
      I1 => level1(1),
      I2 => soft1(0),
      I3 => level1(0),
      O => paint23_carry_i_8_n_0
    );
\paint2[12]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0008"
    )
        port map (
      I0 => paint22,
      I1 => \^audio1_reg_0\,
      I2 => paint23,
      I3 => \paint22_inferred__0/i__carry__0_n_3\,
      O => audio1_reg_5
    );
\paint2[13]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8080008888888888"
    )
        port map (
      I0 => enable1,
      I1 => de_prev,
      I2 => \^audio1_reg_0\,
      I3 => \^fist1_reg_0\,
      I4 => \^y1_reg[9]_0\,
      I5 => \paint2[23]_i_4_n_0\,
      O => \paint2[13]_i_1_n_0\
    );
\paint2[13]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => hit2_i_3_n_0,
      I1 => \paint2[21]_i_3_n_0\,
      I2 => fist1,
      O => \^fist1_reg_0\
    );
\paint2[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => enable1,
      I1 => de_prev,
      I2 => \^y1_reg[9]_0\,
      I3 => \^audio1_reg_0\,
      O => \paint2[15]_i_1_n_0\
    );
\paint2[20]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => fist1,
      I1 => hit2_i_3_n_0,
      O => fist1_reg_1
    );
\paint2[20]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"777F0000"
    )
        port map (
      I0 => \^audio1_reg_0\,
      I1 => paint22,
      I2 => \paint22_inferred__0/i__carry__0_n_3\,
      I3 => paint23,
      I4 => \paint2[21]_i_3_n_0\,
      O => audio1_reg_4
    );
\paint2[20]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EAAAAAAA"
    )
        port map (
      I0 => SR(0),
      I1 => \^audio1_reg_0\,
      I2 => \^y1_reg[9]_0\,
      I3 => de_prev,
      I4 => enable1,
      O => audio1_reg_2
    );
\paint2[21]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAA2AAAAA"
    )
        port map (
      I0 => \paint2[21]_i_2_n_0\,
      I1 => \paint2[21]_i_3_n_0\,
      I2 => \paint2[21]_i_4_n_0\,
      I3 => \paint22_inferred__0/i__carry__0_n_3\,
      I4 => \^paint2[23]_i_3_0\,
      I5 => paint23,
      O => \paint2[21]_i_1_n_0\
    );
\paint2[21]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B0B0B0B08080B080"
    )
        port map (
      I0 => \^audio1_reg_0\,
      I1 => \^y1_reg[9]_0\,
      I2 => \^de_prev_reg_0\,
      I3 => fist1,
      I4 => hit2_i_3_n_0,
      I5 => \paint2[21]_i_3_n_0\,
      O => \paint2[21]_i_2_n_0\
    );
\paint2[21]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00002228"
    )
        port map (
      I0 => \paint2[23]_i_5_n_0\,
      I1 => x1(3),
      I2 => x1(2),
      I3 => x1(1),
      I4 => \paint2[23]_i_7_n_0\,
      O => \paint2[21]_i_3_n_0\
    );
\paint2[21]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^audio1_reg_0\,
      I1 => paint22,
      O => \paint2[21]_i_4_n_0\
    );
\paint2[22]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000D000D000D000"
    )
        port map (
      I0 => hit2_i_3_n_0,
      I1 => \^x1_reg[3]_0\,
      I2 => de_prev,
      I3 => enable1,
      I4 => \^audio1_reg_3\,
      I5 => \^paint2[23]_i_3_0\,
      O => \paint2[22]_i_1_n_0\
    );
\paint2[22]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"2A"
    )
        port map (
      I0 => \paint2[21]_i_3_n_0\,
      I1 => paint22,
      I2 => \^audio1_reg_0\,
      O => \^audio1_reg_3\
    );
\paint2[22]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \paint2[23]_i_9_n_0\,
      I1 => \^y1_reg[9]_0\,
      O => \^paint2[23]_i_3_0\
    );
\paint2[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"E222222200000000"
    )
        port map (
      I0 => \^enable1_reg_0\,
      I1 => \^y1_reg[9]_0\,
      I2 => enable1,
      I3 => de_prev,
      I4 => \^audio1_reg_0\,
      I5 => \paint2[23]_i_4_n_0\,
      O => \paint2[23]_i_1_n_0\
    );
\paint2[23]_i_10\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => x1(10),
      I1 => x1(8),
      I2 => x1(9),
      O => \paint2[23]_i_10_n_0\
    );
\paint2[23]_i_11\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => y1(6),
      I1 => y1(5),
      O => \paint2[23]_i_11_n_0\
    );
\paint2[23]_i_12\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => x1(7),
      I1 => x1(5),
      I2 => x1(6),
      O => \paint2[23]_i_12_n_0\
    );
\paint2[23]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFEEFFFFFFFFFFF"
    )
        port map (
      I0 => \paint2[23]_i_7_n_0\,
      I1 => x1(2),
      I2 => x1(0),
      I3 => x1(3),
      I4 => x1(1),
      I5 => \paint2[23]_i_10_n_0\,
      O => \paint2[23]_i_13_n_0\
    );
\paint2[23]_i_14\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00004000"
    )
        port map (
      I0 => y1(5),
      I1 => y1(6),
      I2 => y1(2),
      I3 => y1(3),
      I4 => \paint2[23]_i_16_n_0\,
      O => \paint2[23]_i_14_n_0\
    );
\paint2[23]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0008000000000000"
    )
        port map (
      I0 => y1(5),
      I1 => y1(6),
      I2 => y1(9),
      I3 => y1(8),
      I4 => y1(4),
      I5 => y1(7),
      O => \paint2[23]_i_15_n_0\
    );
\paint2[23]_i_16\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"DFFFFFFFFFFFFFFF"
    )
        port map (
      I0 => y1(8),
      I1 => y1(9),
      I2 => y1(0),
      I3 => y1(1),
      I4 => y1(4),
      I5 => y1(7),
      O => \paint2[23]_i_16_n_0\
    );
\paint2[23]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"88880080"
    )
        port map (
      I0 => enable1,
      I1 => de_prev,
      I2 => fist1,
      I3 => hit2_i_3_n_0,
      I4 => \paint2[21]_i_3_n_0\,
      O => \^enable1_reg_0\
    );
\paint2[23]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A80008080800"
    )
        port map (
      I0 => \paint2[23]_i_5_n_0\,
      I1 => \paint2[23]_i_6_n_0\,
      I2 => \paint2[23]_i_7_n_0\,
      I3 => hit230_out,
      I4 => hit23,
      I5 => \paint2[23]_i_8_n_0\,
      O => \^y1_reg[9]_0\
    );
\paint2[23]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EEEAFFFFAAAAFFFF"
    )
        port map (
      I0 => \^y1_reg[9]_0\,
      I1 => \paint2[21]_i_4_n_0\,
      I2 => \paint22_inferred__0/i__carry__0_n_3\,
      I3 => paint23,
      I4 => \paint2[21]_i_3_n_0\,
      I5 => \paint2[23]_i_9_n_0\,
      O => \paint2[23]_i_4_n_0\
    );
\paint2[23]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"080208000A000A00"
    )
        port map (
      I0 => \paint2[23]_i_10_n_0\,
      I1 => \paint2[23]_i_11_n_0\,
      I2 => y1(9),
      I3 => y1(8),
      I4 => y1(4),
      I5 => y1(7),
      O => \paint2[23]_i_5_n_0\
    );
\paint2[23]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"777F"
    )
        port map (
      I0 => x1(2),
      I1 => x1(3),
      I2 => x1(0),
      I3 => x1(1),
      O => \paint2[23]_i_6_n_0\
    );
\paint2[23]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => x1(4),
      I1 => x1(6),
      I2 => x1(5),
      I3 => x1(7),
      O => \paint2[23]_i_7_n_0\
    );
\paint2[23]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FEEEEEEEEEEEEEEE"
    )
        port map (
      I0 => x1(8),
      I1 => x1(9),
      I2 => x1(2),
      I3 => x1(3),
      I4 => x1(1),
      I5 => \paint2[23]_i_12_n_0\,
      O => \paint2[23]_i_8_n_0\
    );
\paint2[23]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2202"
    )
        port map (
      I0 => \paint2[23]_i_13_n_0\,
      I1 => \paint2[23]_i_14_n_0\,
      I2 => \paint2[23]_i_15_n_0\,
      I3 => paint22_carry_i_9_n_0,
      O => \paint2[23]_i_9_n_0\
    );
\paint2[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000007F00FFFF"
    )
        port map (
      I0 => \^audio1_reg_0\,
      I1 => paint22,
      I2 => \paint22_inferred__0/i__carry__0_n_3\,
      I3 => \^paint2[23]_i_3_0\,
      I4 => \^x1_reg[3]_0\,
      I5 => \paint2[2]_i_2_n_0\,
      O => \paint2[2]_i_1_n_0\
    );
\paint2[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF7FFFFFFFFFFF"
    )
        port map (
      I0 => \^audio1_reg_0\,
      I1 => paint22,
      I2 => \paint2[21]_i_3_n_0\,
      I3 => paint23,
      I4 => SR(0),
      I5 => \^de_prev_reg_0\,
      O => \paint2[2]_i_2_n_0\
    );
\paint2[4]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => \paint2[23]_i_9_n_0\,
      I1 => \paint2[21]_i_3_n_0\,
      O => \x1_reg[3]_1\
    );
\paint2[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"880AAAAA880A880A"
    )
        port map (
      I0 => \^de_prev_reg_0\,
      I1 => \^audio1_reg_0\,
      I2 => \^fist1_reg_0\,
      I3 => \^y1_reg[9]_0\,
      I4 => \^audio1_reg_1\,
      I5 => \^paint2[23]_i_3_0\,
      O => \paint2[7]_i_1_n_0\
    );
\paint2[7]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => de_prev,
      I1 => enable1,
      O => \^de_prev_reg_0\
    );
\paint2[7]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BFFF"
    )
        port map (
      I0 => \paint22_inferred__0/i__carry__0_n_3\,
      I1 => \^audio1_reg_0\,
      I2 => paint22,
      I3 => \paint2[21]_i_3_n_0\,
      O => \^audio1_reg_1\
    );
\paint2_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \paint2_reg[11]_0\,
      Q => \paint2_reg_n_0_[11]\,
      R => '0'
    );
\paint2_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \paint2_reg[12]_0\,
      Q => \paint2_reg_n_0_[12]\,
      R => '0'
    );
\paint2_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \paint2[13]_i_1_n_0\,
      Q => \paint2_reg_n_0_[13]\,
      R => SR(0)
    );
\paint2_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \paint2[15]_i_1_n_0\,
      Q => \paint2_reg_n_0_[15]\,
      R => SR(0)
    );
\paint2_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \paint2_reg[19]_0\,
      Q => \paint2_reg_n_0_[19]\,
      R => '0'
    );
\paint2_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \paint2_reg[20]_0\,
      Q => \paint2_reg_n_0_[20]\,
      R => '0'
    );
\paint2_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \paint2[21]_i_1_n_0\,
      Q => \paint2_reg_n_0_[21]\,
      R => SR(0)
    );
\paint2_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \paint2[22]_i_1_n_0\,
      Q => \paint2_reg_n_0_[22]\,
      R => SR(0)
    );
\paint2_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \paint2[23]_i_1_n_0\,
      Q => \paint2_reg_n_0_[23]\,
      R => SR(0)
    );
\paint2_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \paint2[2]_i_1_n_0\,
      Q => \paint2_reg_n_0_[2]\,
      R => '0'
    );
\paint2_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \paint2_reg[4]_0\,
      Q => \paint2_reg_n_0_[4]\,
      R => '0'
    );
\paint2_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \paint2[7]_i_1_n_0\,
      Q => \paint2_reg_n_0_[7]\,
      R => SR(0)
    );
\rgb1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(0),
      Q => rgb1(0),
      R => SR(0)
    );
\rgb1_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(10),
      Q => rgb1(10),
      R => SR(0)
    );
\rgb1_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(11),
      Q => rgb1(11),
      R => SR(0)
    );
\rgb1_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(12),
      Q => rgb1(12),
      R => SR(0)
    );
\rgb1_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(13),
      Q => rgb1(13),
      R => SR(0)
    );
\rgb1_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(14),
      Q => rgb1(14),
      R => SR(0)
    );
\rgb1_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(15),
      Q => rgb1(15),
      R => SR(0)
    );
\rgb1_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(16),
      Q => rgb1(16),
      R => SR(0)
    );
\rgb1_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(17),
      Q => rgb1(17),
      R => SR(0)
    );
\rgb1_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(18),
      Q => rgb1(18),
      R => SR(0)
    );
\rgb1_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(19),
      Q => rgb1(19),
      R => SR(0)
    );
\rgb1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(1),
      Q => rgb1(1),
      R => SR(0)
    );
\rgb1_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(20),
      Q => rgb1(20),
      R => SR(0)
    );
\rgb1_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(21),
      Q => rgb1(21),
      R => SR(0)
    );
\rgb1_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(22),
      Q => rgb1(22),
      R => SR(0)
    );
\rgb1_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(23),
      Q => rgb1(23),
      R => SR(0)
    );
\rgb1_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(2),
      Q => rgb1(2),
      R => SR(0)
    );
\rgb1_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(3),
      Q => rgb1(3),
      R => SR(0)
    );
\rgb1_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(4),
      Q => rgb1(4),
      R => SR(0)
    );
\rgb1_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(5),
      Q => rgb1(5),
      R => SR(0)
    );
\rgb1_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(6),
      Q => rgb1(6),
      R => SR(0)
    );
\rgb1_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(7),
      Q => rgb1(7),
      R => SR(0)
    );
\rgb1_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(8),
      Q => rgb1(8),
      R => SR(0)
    );
\rgb1_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_rgb(9),
      Q => rgb1(9),
      R => SR(0)
    );
\rgb2_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(0),
      Q => rgb2(0),
      R => SR(0)
    );
\rgb2_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(10),
      Q => rgb2(10),
      R => SR(0)
    );
\rgb2_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(11),
      Q => rgb2(11),
      R => SR(0)
    );
\rgb2_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(12),
      Q => rgb2(12),
      R => SR(0)
    );
\rgb2_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(13),
      Q => rgb2(13),
      R => SR(0)
    );
\rgb2_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(14),
      Q => rgb2(14),
      R => SR(0)
    );
\rgb2_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(15),
      Q => rgb2(15),
      R => SR(0)
    );
\rgb2_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(16),
      Q => rgb2(16),
      R => SR(0)
    );
\rgb2_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(17),
      Q => rgb2(17),
      R => SR(0)
    );
\rgb2_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(18),
      Q => rgb2(18),
      R => SR(0)
    );
\rgb2_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(19),
      Q => rgb2(19),
      R => SR(0)
    );
\rgb2_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(1),
      Q => rgb2(1),
      R => SR(0)
    );
\rgb2_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(20),
      Q => rgb2(20),
      R => SR(0)
    );
\rgb2_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(21),
      Q => rgb2(21),
      R => SR(0)
    );
\rgb2_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(22),
      Q => rgb2(22),
      R => SR(0)
    );
\rgb2_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(23),
      Q => rgb2(23),
      R => SR(0)
    );
\rgb2_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(2),
      Q => rgb2(2),
      R => SR(0)
    );
\rgb2_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(3),
      Q => rgb2(3),
      R => SR(0)
    );
\rgb2_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(4),
      Q => rgb2(4),
      R => SR(0)
    );
\rgb2_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(5),
      Q => rgb2(5),
      R => SR(0)
    );
\rgb2_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(6),
      Q => rgb2(6),
      R => SR(0)
    );
\rgb2_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(7),
      Q => rgb2(7),
      R => SR(0)
    );
\rgb2_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(8),
      Q => rgb2(8),
      R => SR(0)
    );
\rgb2_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => rgb1(9),
      Q => rgb2(9),
      R => SR(0)
    );
\soft1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(33),
      Q => soft1(0),
      R => SR(0)
    );
\soft1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(34),
      Q => soft1(1),
      R => SR(0)
    );
\soft1_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(35),
      Q => soft1(2),
      R => SR(0)
    );
\soft1_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(36),
      Q => soft1(3),
      R => SR(0)
    );
\soft1_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(37),
      Q => soft1(4),
      R => SR(0)
    );
\soft1_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(38),
      Q => soft1(5),
      R => SR(0)
    );
\soft1_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(39),
      Q => soft1(6),
      R => SR(0)
    );
\soft1_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(40),
      Q => soft1(7),
      R => SR(0)
    );
\soft1_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(41),
      Q => soft1(8),
      R => SR(0)
    );
\soft1_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => Q(42),
      Q => soft1(9),
      R => SR(0)
    );
vs2_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^vs_prev\,
      Q => vs2,
      R => SR(0)
    );
vs_prev_reg: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => in_vs,
      Q => \^vs_prev\,
      R => SR(0)
    );
\x1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^x_reg[10]_0\(0),
      Q => x1(0),
      R => SR(0)
    );
\x1_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^x_reg[10]_0\(10),
      Q => x1(10),
      R => SR(0)
    );
\x1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^x_reg[10]_0\(1),
      Q => x1(1),
      R => SR(0)
    );
\x1_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^x_reg[10]_0\(2),
      Q => x1(2),
      R => SR(0)
    );
\x1_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^x_reg[10]_0\(3),
      Q => x1(3),
      R => SR(0)
    );
\x1_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^x_reg[10]_0\(4),
      Q => x1(4),
      R => SR(0)
    );
\x1_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^x_reg[10]_0\(5),
      Q => x1(5),
      R => SR(0)
    );
\x1_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^x_reg[10]_0\(6),
      Q => x1(6),
      R => SR(0)
    );
\x1_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^x_reg[10]_0\(7),
      Q => x1(7),
      R => SR(0)
    );
\x1_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^x_reg[10]_0\(8),
      Q => x1(8),
      R => SR(0)
    );
\x1_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^x_reg[10]_0\(9),
      Q => x1(9),
      R => SR(0)
    );
\x[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^x_reg[10]_0\(0),
      O => \x[0]_i_1_n_0\
    );
\x[10]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AEFF"
    )
        port map (
      I0 => SR(0),
      I1 => in_vs,
      I2 => \^vs_prev\,
      I3 => in_de,
      O => \x[10]_i_1_n_0\
    );
\x[10]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"1F"
    )
        port map (
      I0 => \^x_reg[10]_0\(9),
      I1 => \^x_reg[10]_0\(8),
      I2 => \^x_reg[10]_0\(10),
      O => \x[10]_i_2_n_0\
    );
\x[10]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => \^x_reg[10]_0\(10),
      I1 => \^x_reg[10]_0\(9),
      I2 => \^x_reg[10]_0\(7),
      I3 => \x[10]_i_4_n_0\,
      I4 => \^x_reg[10]_0\(6),
      I5 => \^x_reg[10]_0\(8),
      O => p_0_in(10)
    );
\x[10]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => \^x_reg[10]_0\(4),
      I1 => \^x_reg[10]_0\(2),
      I2 => \^x_reg[10]_0\(1),
      I3 => \^x_reg[10]_0\(0),
      I4 => \^x_reg[10]_0\(3),
      I5 => \^x_reg[10]_0\(5),
      O => \x[10]_i_4_n_0\
    );
\x[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \^x_reg[10]_0\(1),
      I1 => \^x_reg[10]_0\(0),
      O => p_0_in(1)
    );
\x[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \^x_reg[10]_0\(2),
      I1 => \^x_reg[10]_0\(0),
      I2 => \^x_reg[10]_0\(1),
      O => p_0_in(2)
    );
\x[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \^x_reg[10]_0\(3),
      I1 => \^x_reg[10]_0\(2),
      I2 => \^x_reg[10]_0\(1),
      I3 => \^x_reg[10]_0\(0),
      O => p_0_in(3)
    );
\x[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \^x_reg[10]_0\(4),
      I1 => \^x_reg[10]_0\(3),
      I2 => \^x_reg[10]_0\(0),
      I3 => \^x_reg[10]_0\(1),
      I4 => \^x_reg[10]_0\(2),
      O => p_0_in(4)
    );
\x[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => \^x_reg[10]_0\(5),
      I1 => \^x_reg[10]_0\(4),
      I2 => \^x_reg[10]_0\(2),
      I3 => \^x_reg[10]_0\(1),
      I4 => \^x_reg[10]_0\(0),
      I5 => \^x_reg[10]_0\(3),
      O => p_0_in(5)
    );
\x[6]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \^x_reg[10]_0\(6),
      I1 => \x[10]_i_4_n_0\,
      O => p_0_in(6)
    );
\x[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \^x_reg[10]_0\(7),
      I1 => \^x_reg[10]_0\(6),
      I2 => \x[10]_i_4_n_0\,
      O => p_0_in(7)
    );
\x[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \^x_reg[10]_0\(8),
      I1 => \^x_reg[10]_0\(7),
      I2 => \x[10]_i_4_n_0\,
      I3 => \^x_reg[10]_0\(6),
      O => p_0_in(8)
    );
\x[9]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \^x_reg[10]_0\(9),
      I1 => \^x_reg[10]_0\(8),
      I2 => \^x_reg[10]_0\(6),
      I3 => \x[10]_i_4_n_0\,
      I4 => \^x_reg[10]_0\(7),
      O => p_0_in(9)
    );
\x_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \x[10]_i_2_n_0\,
      D => \x[0]_i_1_n_0\,
      Q => \^x_reg[10]_0\(0),
      R => \x[10]_i_1_n_0\
    );
\x_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \x[10]_i_2_n_0\,
      D => p_0_in(10),
      Q => \^x_reg[10]_0\(10),
      R => \x[10]_i_1_n_0\
    );
\x_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \x[10]_i_2_n_0\,
      D => p_0_in(1),
      Q => \^x_reg[10]_0\(1),
      R => \x[10]_i_1_n_0\
    );
\x_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \x[10]_i_2_n_0\,
      D => p_0_in(2),
      Q => \^x_reg[10]_0\(2),
      R => \x[10]_i_1_n_0\
    );
\x_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \x[10]_i_2_n_0\,
      D => p_0_in(3),
      Q => \^x_reg[10]_0\(3),
      R => \x[10]_i_1_n_0\
    );
\x_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \x[10]_i_2_n_0\,
      D => p_0_in(4),
      Q => \^x_reg[10]_0\(4),
      R => \x[10]_i_1_n_0\
    );
\x_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \x[10]_i_2_n_0\,
      D => p_0_in(5),
      Q => \^x_reg[10]_0\(5),
      R => \x[10]_i_1_n_0\
    );
\x_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \x[10]_i_2_n_0\,
      D => p_0_in(6),
      Q => \^x_reg[10]_0\(6),
      R => \x[10]_i_1_n_0\
    );
\x_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \x[10]_i_2_n_0\,
      D => p_0_in(7),
      Q => \^x_reg[10]_0\(7),
      R => \x[10]_i_1_n_0\
    );
\x_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \x[10]_i_2_n_0\,
      D => p_0_in(8),
      Q => \^x_reg[10]_0\(8),
      R => \x[10]_i_1_n_0\
    );
\x_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => \x[10]_i_2_n_0\,
      D => p_0_in(9),
      Q => \^x_reg[10]_0\(9),
      R => \x[10]_i_1_n_0\
    );
\y1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^y_reg[9]_0\(0),
      Q => y1(0),
      R => SR(0)
    );
\y1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^y_reg[9]_0\(1),
      Q => y1(1),
      R => SR(0)
    );
\y1_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^y_reg[9]_0\(2),
      Q => y1(2),
      R => SR(0)
    );
\y1_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^y_reg[9]_0\(3),
      Q => y1(3),
      R => SR(0)
    );
\y1_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^y_reg[9]_0\(4),
      Q => y1(4),
      R => SR(0)
    );
\y1_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^y_reg[9]_0\(5),
      Q => y1(5),
      R => SR(0)
    );
\y1_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^y_reg[9]_0\(6),
      Q => y1(6),
      R => SR(0)
    );
\y1_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^y_reg[9]_0\(7),
      Q => y1(7),
      R => SR(0)
    );
\y1_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^y_reg[9]_0\(8),
      Q => y1(8),
      R => SR(0)
    );
\y1_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => '1',
      D => \^y_reg[9]_0\(9),
      Q => y1(9),
      R => SR(0)
    );
\y[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^y_reg[9]_0\(0),
      O => \y[0]_i_1_n_0\
    );
\y[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \^y_reg[9]_0\(1),
      I1 => \^y_reg[9]_0\(0),
      O => \p_0_in__0\(1)
    );
\y[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \^y_reg[9]_0\(2),
      I1 => \^y_reg[9]_0\(0),
      I2 => \^y_reg[9]_0\(1),
      O => \p_0_in__0\(2)
    );
\y[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \^y_reg[9]_0\(3),
      I1 => \^y_reg[9]_0\(2),
      I2 => \^y_reg[9]_0\(1),
      I3 => \^y_reg[9]_0\(0),
      O => \p_0_in__0\(3)
    );
\y[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \^y_reg[9]_0\(4),
      I1 => \^y_reg[9]_0\(3),
      I2 => \^y_reg[9]_0\(0),
      I3 => \^y_reg[9]_0\(1),
      I4 => \^y_reg[9]_0\(2),
      O => \p_0_in__0\(4)
    );
\y[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => \^y_reg[9]_0\(5),
      I1 => \^y_reg[9]_0\(4),
      I2 => \^y_reg[9]_0\(2),
      I3 => \^y_reg[9]_0\(1),
      I4 => \^y_reg[9]_0\(0),
      I5 => \^y_reg[9]_0\(3),
      O => \p_0_in__0\(5)
    );
\y[6]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \^y_reg[9]_0\(6),
      I1 => \y[9]_i_5_n_0\,
      O => \p_0_in__0\(6)
    );
\y[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \^y_reg[9]_0\(7),
      I1 => \^y_reg[9]_0\(6),
      I2 => \y[9]_i_5_n_0\,
      O => \p_0_in__0\(7)
    );
\y[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \^y_reg[9]_0\(8),
      I1 => \^y_reg[9]_0\(6),
      I2 => \^y_reg[9]_0\(7),
      I3 => \y[9]_i_5_n_0\,
      O => \p_0_in__0\(8)
    );
\y[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F4"
    )
        port map (
      I0 => \^vs_prev\,
      I1 => in_vs,
      I2 => SR(0),
      O => \y[9]_i_1_n_0\
    );
\y[9]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => \y[9]_i_4_n_0\,
      I1 => de_prev,
      I2 => in_de,
      O => y
    );
\y[9]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \^y_reg[9]_0\(9),
      I1 => \^y_reg[9]_0\(8),
      I2 => \y[9]_i_5_n_0\,
      I3 => \^y_reg[9]_0\(7),
      I4 => \^y_reg[9]_0\(6),
      O => \p_0_in__0\(9)
    );
\y[9]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"555555557F7F7FFF"
    )
        port map (
      I0 => \^y_reg[9]_0\(9),
      I1 => \^y_reg[9]_0\(7),
      I2 => \^y_reg[9]_0\(6),
      I3 => \^y_reg[9]_0\(5),
      I4 => \^y_reg[9]_0\(4),
      I5 => \^y_reg[9]_0\(8),
      O => \y[9]_i_4_n_0\
    );
\y[9]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => \^y_reg[9]_0\(4),
      I1 => \^y_reg[9]_0\(2),
      I2 => \^y_reg[9]_0\(1),
      I3 => \^y_reg[9]_0\(0),
      I4 => \^y_reg[9]_0\(3),
      I5 => \^y_reg[9]_0\(5),
      O => \y[9]_i_5_n_0\
    );
\y_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => y,
      D => \y[0]_i_1_n_0\,
      Q => \^y_reg[9]_0\(0),
      R => \y[9]_i_1_n_0\
    );
\y_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => y,
      D => \p_0_in__0\(1),
      Q => \^y_reg[9]_0\(1),
      R => \y[9]_i_1_n_0\
    );
\y_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => y,
      D => \p_0_in__0\(2),
      Q => \^y_reg[9]_0\(2),
      R => \y[9]_i_1_n_0\
    );
\y_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => y,
      D => \p_0_in__0\(3),
      Q => \^y_reg[9]_0\(3),
      R => \y[9]_i_1_n_0\
    );
\y_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => y,
      D => \p_0_in__0\(4),
      Q => \^y_reg[9]_0\(4),
      R => \y[9]_i_1_n_0\
    );
\y_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => y,
      D => \p_0_in__0\(5),
      Q => \^y_reg[9]_0\(5),
      R => \y[9]_i_1_n_0\
    );
\y_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => y,
      D => \p_0_in__0\(6),
      Q => \^y_reg[9]_0\(6),
      R => \y[9]_i_1_n_0\
    );
\y_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => y,
      D => \p_0_in__0\(7),
      Q => \^y_reg[9]_0\(7),
      R => \y[9]_i_1_n_0\
    );
\y_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => y,
      D => \p_0_in__0\(8),
      Q => \^y_reg[9]_0\(8),
      R => \y[9]_i_1_n_0\
    );
\y_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => pclk,
      CE => y,
      D => \p_0_in__0\(9),
      Q => \^y_reg[9]_0\(9),
      R => \y[9]_i_1_n_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_input_osd_0_0_input_osd_top is
  port (
    \pp_release_reg[1]_0\ : out STD_LOGIC;
    audio1 : out STD_LOGIC;
    out_de : out STD_LOGIC;
    out_hs : out STD_LOGIC;
    out_vs : out STD_LOGIC;
    bvalid_reg : out STD_LOGIC;
    w_held_reg : out STD_LOGIC;
    aw_held : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    rvalid_reg : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    out_rgb : out STD_LOGIC_VECTOR ( 23 downto 0 );
    s_axi_awready : out STD_LOGIC;
    \aw_addr_reg[5]\ : out STD_LOGIC;
    mailbox116_out : out STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    \w_data_reg[0]\ : out STD_LOGIC;
    de_prev_reg : out STD_LOGIC;
    fist1_reg : out STD_LOGIC;
    \y1_reg[9]\ : out STD_LOGIC;
    audio1_reg : out STD_LOGIC;
    \paint2[23]_i_3\ : out STD_LOGIC;
    enable1_reg : out STD_LOGIC;
    audio1_reg_0 : out STD_LOGIC;
    \x1_reg[3]\ : out STD_LOGIC;
    audio1_reg_1 : out STD_LOGIC;
    \x1_reg[3]_0\ : out STD_LOGIC;
    audio1_reg_2 : out STD_LOGIC;
    fist1_reg_0 : out STD_LOGIC;
    audio1_reg_3 : out STD_LOGIC;
    pclk : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    in_de : in STD_LOGIC;
    in_vs : in STD_LOGIC;
    in_hs : in STD_LOGIC;
    bvalid_reg_0 : in STD_LOGIC;
    \bresp_reg[1]\ : in STD_LOGIC;
    rvalid_reg_0 : in STD_LOGIC;
    \paint2_reg[20]\ : in STD_LOGIC;
    \paint2_reg[19]\ : in STD_LOGIC;
    \paint2_reg[12]\ : in STD_LOGIC;
    \paint2_reg[11]\ : in STD_LOGIC;
    \paint2_reg[4]\ : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    in_rgb : in STD_LOGIC_VECTOR ( 23 downto 0 );
    presetn : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_input_osd_0_0_input_osd_top : entity is "input_osd_top";
end c6v_input_osd_0_0_input_osd_top;

architecture STRUCTURE of c6v_input_osd_0_0_input_osd_top is
  signal af : STD_LOGIC;
  signal ca_release : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute async_reg : string;
  attribute async_reg of ca_release : signal is "true";
  signal \ca_release[1]_i_1_n_0\ : STD_LOGIC;
  signal cfg : STD_LOGIC_VECTOR ( 105 downto 0 );
  signal cp_release : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute async_reg of cp_release : signal is "true";
  signal \cp_release[1]_i_1_n_0\ : STD_LOGIC;
  signal ctrl_n_61 : STD_LOGIC;
  signal ctrl_n_62 : STD_LOGIC;
  signal ctrl_n_63 : STD_LOGIC;
  signal ctrl_n_64 : STD_LOGIC;
  signal ctrl_n_65 : STD_LOGIC;
  signal ctrl_n_66 : STD_LOGIC;
  signal ctrl_n_67 : STD_LOGIC;
  signal ctrl_n_68 : STD_LOGIC;
  signal ctrl_n_69 : STD_LOGIC;
  signal ctrl_n_70 : STD_LOGIC;
  signal ctrl_n_71 : STD_LOGIC;
  signal ctrl_n_72 : STD_LOGIC;
  signal hand10 : STD_LOGIC;
  signal pa_release : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute async_reg of pa_release : signal is "true";
  signal pixels_n_26 : STD_LOGIC;
  signal pp_release : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute async_reg of pp_release : signal is "true";
  signal \^pp_release_reg[1]_0\ : STD_LOGIC;
  signal vs_prev : STD_LOGIC;
  signal x_reg : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal y_reg : STD_LOGIC_VECTOR ( 9 downto 0 );
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \ca_release_reg[0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \ca_release_reg[0]\ : label is "yes";
  attribute ASYNC_REG_boolean of \ca_release_reg[1]\ : label is std.standard.true;
  attribute KEEP of \ca_release_reg[1]\ : label is "yes";
  attribute ASYNC_REG_boolean of \cp_release_reg[0]\ : label is std.standard.true;
  attribute KEEP of \cp_release_reg[0]\ : label is "yes";
  attribute ASYNC_REG_boolean of \cp_release_reg[1]\ : label is std.standard.true;
  attribute KEEP of \cp_release_reg[1]\ : label is "yes";
  attribute ASYNC_REG_boolean of \pa_release_reg[0]\ : label is std.standard.true;
  attribute KEEP of \pa_release_reg[0]\ : label is "yes";
  attribute ASYNC_REG_boolean of \pa_release_reg[1]\ : label is std.standard.true;
  attribute KEEP of \pa_release_reg[1]\ : label is "yes";
  attribute ASYNC_REG_boolean of \pp_release_reg[0]\ : label is std.standard.true;
  attribute KEEP of \pp_release_reg[0]\ : label is "yes";
  attribute ASYNC_REG_boolean of \pp_release_reg[1]\ : label is std.standard.true;
  attribute KEEP of \pp_release_reg[1]\ : label is "yes";
begin
  \pp_release_reg[1]_0\ <= \^pp_release_reg[1]_0\;
\ca_release[1]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s_axi_aresetn,
      O => \ca_release[1]_i_1_n_0\
    );
\ca_release_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => '1',
      CLR => \ca_release[1]_i_1_n_0\,
      D => '1',
      Q => ca_release(0)
    );
\ca_release_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => '1',
      CLR => \ca_release[1]_i_1_n_0\,
      D => ca_release(0),
      Q => ca_release(1)
    );
\cp_release[1]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => presetn,
      O => \cp_release[1]_i_1_n_0\
    );
\cp_release_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => '1',
      CLR => \cp_release[1]_i_1_n_0\,
      D => '1',
      Q => cp_release(0)
    );
\cp_release_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => '1',
      CLR => \cp_release[1]_i_1_n_0\,
      D => cp_release(0),
      Q => cp_release(1)
    );
ctrl: entity work.c6v_input_osd_0_0_input_osd_ctrl
     port map (
      Q(52 downto 43) => cfg(105 downto 96),
      Q(42 downto 33) => cfg(89 downto 80),
      Q(32 downto 23) => cfg(73 downto 64),
      Q(22 downto 13) => cfg(57 downto 48),
      Q(12 downto 2) => cfg(42 downto 32),
      Q(1) => cfg(2),
      Q(0) => cfg(0),
      S(3) => ctrl_n_61,
      S(2) => ctrl_n_62,
      S(1) => ctrl_n_63,
      S(0) => ctrl_n_64,
      SR(0) => \^pp_release_reg[1]_0\,
      ack_toggle_reg_0(0) => pp_release(1),
      ack_toggle_reg_1(0) => pa_release(1),
      \active_cfg_reg[42]_0\(1) => ctrl_n_65,
      \active_cfg_reg[42]_0\(0) => ctrl_n_66,
      \active_cfg_reg[55]_0\(3) => ctrl_n_67,
      \active_cfg_reg[55]_0\(2) => ctrl_n_68,
      \active_cfg_reg[55]_0\(1) => ctrl_n_69,
      \active_cfg_reg[55]_0\(0) => ctrl_n_70,
      \active_cfg_reg[57]_0\(0) => ctrl_n_71,
      \active_cfg_reg[57]_1\(0) => ctrl_n_72,
      af => af,
      \audio_left_reg[5]_0\ => pixels_n_26,
      \aw_addr_reg[1]_0\(1 downto 0) => Q(1 downto 0),
      \aw_addr_reg[5]_0\ => \aw_addr_reg[5]\,
      aw_held_reg_0 => aw_held,
      \bresp_reg[1]_0\ => \bresp_reg[1]\,
      bvalid_reg_0 => bvalid_reg,
      bvalid_reg_1 => bvalid_reg_0,
      \dx12_carry__0\(10 downto 0) => x_reg(10 downto 0),
      \dy1_reg[9]\(9 downto 0) => y_reg(9 downto 0),
      hand10 => hand10,
      in_vs => in_vs,
      mailbox116_out => mailbox116_out,
      \out\(0) => cp_release(1),
      pclk => pclk,
      rvalid_reg_0 => rvalid_reg,
      rvalid_reg_1 => rvalid_reg_0,
      rvalid_reg_2(0) => ca_release(1),
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(6 downto 0) => s_axi_araddr(6 downto 0),
      s_axi_arready => s_axi_arready,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(6 downto 0) => s_axi_awaddr(6 downto 0),
      s_axi_awready => s_axi_awready,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bresp(0) => s_axi_bresp(0),
      s_axi_rdata(31 downto 0) => s_axi_rdata(31 downto 0),
      s_axi_rresp(0) => s_axi_rresp(0),
      s_axi_wdata(31 downto 0) => s_axi_wdata(31 downto 0),
      s_axi_wready => s_axi_wready,
      s_axi_wstrb(3 downto 0) => s_axi_wstrb(3 downto 0),
      s_axi_wvalid => s_axi_wvalid,
      vs_prev => vs_prev,
      \w_data_reg[0]_0\ => \w_data_reg[0]\,
      w_held_reg_0 => w_held_reg
    );
\pa_release_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \ca_release[1]_i_1_n_0\,
      D => '1',
      Q => pa_release(0)
    );
\pa_release_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \ca_release[1]_i_1_n_0\,
      D => pa_release(0),
      Q => pa_release(1)
    );
pixels: entity work.c6v_input_osd_0_0_input_osd_pixels
     port map (
      Q(52 downto 43) => cfg(105 downto 96),
      Q(42 downto 33) => cfg(89 downto 80),
      Q(32 downto 23) => cfg(73 downto 64),
      Q(22 downto 13) => cfg(57 downto 48),
      Q(12 downto 2) => cfg(42 downto 32),
      Q(1) => cfg(2),
      Q(0) => cfg(0),
      S(3) => ctrl_n_61,
      S(2) => ctrl_n_62,
      S(1) => ctrl_n_63,
      S(0) => ctrl_n_64,
      SR(0) => \^pp_release_reg[1]_0\,
      af => af,
      audio1_reg_0 => audio1,
      audio1_reg_1 => audio1_reg,
      audio1_reg_2 => audio1_reg_0,
      audio1_reg_3 => audio1_reg_1,
      audio1_reg_4 => audio1_reg_2,
      audio1_reg_5 => audio1_reg_3,
      de_prev_reg_0 => de_prev_reg,
      \dx10_carry__1_i_1_0\(1) => ctrl_n_65,
      \dx10_carry__1_i_1_0\(0) => ctrl_n_66,
      \dy10_carry__1_i_1_0\(0) => ctrl_n_72,
      \dy12_carry__0_0\(3) => ctrl_n_67,
      \dy12_carry__0_0\(2) => ctrl_n_68,
      \dy12_carry__0_0\(1) => ctrl_n_69,
      \dy12_carry__0_0\(0) => ctrl_n_70,
      \dy1_reg[9]_0\(0) => ctrl_n_71,
      enable1_reg_0 => enable1_reg,
      fist1_reg_0 => fist1_reg,
      fist1_reg_1 => fist1_reg_0,
      hand10 => hand10,
      in_de => in_de,
      in_hs => in_hs,
      in_rgb(23 downto 0) => in_rgb(23 downto 0),
      in_vs => in_vs,
      in_vs_0 => pixels_n_26,
      out_de => out_de,
      out_hs => out_hs,
      out_rgb(23 downto 0) => out_rgb(23 downto 0),
      out_vs => out_vs,
      \paint2[23]_i_3_0\ => \paint2[23]_i_3\,
      \paint2_reg[11]_0\ => \paint2_reg[11]\,
      \paint2_reg[12]_0\ => \paint2_reg[12]\,
      \paint2_reg[19]_0\ => \paint2_reg[19]\,
      \paint2_reg[20]_0\ => \paint2_reg[20]\,
      \paint2_reg[4]_0\ => \paint2_reg[4]\,
      pclk => pclk,
      vs_prev => vs_prev,
      \x1_reg[3]_0\ => \x1_reg[3]\,
      \x1_reg[3]_1\ => \x1_reg[3]_0\,
      \x_reg[10]_0\(10 downto 0) => x_reg(10 downto 0),
      \y1_reg[9]_0\ => \y1_reg[9]\,
      \y_reg[9]_0\(9 downto 0) => y_reg(9 downto 0)
    );
\pp_release_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \cp_release[1]_i_1_n_0\,
      D => '1',
      Q => pp_release(0)
    );
\pp_release_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \cp_release[1]_i_1_n_0\,
      D => pp_release(0),
      Q => pp_release(1)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_input_osd_0_0_input_osd_axi is
  port (
    rvalid_reg : out STD_LOGIC;
    bvalid_reg : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    out_rgb : out STD_LOGIC_VECTOR ( 23 downto 0 );
    out_de : out STD_LOGIC;
    out_hs : out STD_LOGIC;
    out_vs : out STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_araddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_awvalid : in STD_LOGIC;
    in_vs : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_aclk : in STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    pclk : in STD_LOGIC;
    in_de : in STD_LOGIC;
    in_rgb : in STD_LOGIC_VECTOR ( 23 downto 0 );
    in_hs : in STD_LOGIC;
    presetn : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_input_osd_0_0_input_osd_axi : entity is "input_osd_axi";
end c6v_input_osd_0_0_input_osd_axi;

architecture STRUCTURE of c6v_input_osd_0_0_input_osd_axi is
  signal \bresp[1]_i_2_n_0\ : STD_LOGIC;
  signal bvalid_i_1_n_0 : STD_LOGIC;
  signal \^bvalid_reg\ : STD_LOGIC;
  signal \ctrl/aw_addr\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \ctrl/aw_held\ : STD_LOGIC;
  signal \ctrl/mailbox116_out\ : STD_LOGIC;
  signal impl_n_0 : STD_LOGIC;
  signal impl_n_6 : STD_LOGIC;
  signal impl_n_70 : STD_LOGIC;
  signal impl_n_74 : STD_LOGIC;
  signal impl_n_75 : STD_LOGIC;
  signal impl_n_76 : STD_LOGIC;
  signal impl_n_77 : STD_LOGIC;
  signal impl_n_78 : STD_LOGIC;
  signal impl_n_79 : STD_LOGIC;
  signal impl_n_80 : STD_LOGIC;
  signal impl_n_81 : STD_LOGIC;
  signal impl_n_82 : STD_LOGIC;
  signal impl_n_83 : STD_LOGIC;
  signal impl_n_84 : STD_LOGIC;
  signal impl_n_85 : STD_LOGIC;
  signal impl_n_86 : STD_LOGIC;
  signal impl_n_87 : STD_LOGIC;
  signal \paint2[11]_i_1_n_0\ : STD_LOGIC;
  signal \paint2[12]_i_1_n_0\ : STD_LOGIC;
  signal \paint2[19]_i_1_n_0\ : STD_LOGIC;
  signal \paint2[20]_i_1_n_0\ : STD_LOGIC;
  signal \paint2[4]_i_1_n_0\ : STD_LOGIC;
  signal \pixels/audio1\ : STD_LOGIC;
  signal rvalid_i_1_n_0 : STD_LOGIC;
  signal \^rvalid_reg\ : STD_LOGIC;
  signal \^s_axi_bresp\ : STD_LOGIC_VECTOR ( 0 to 0 );
begin
  bvalid_reg <= \^bvalid_reg\;
  rvalid_reg <= \^rvalid_reg\;
  s_axi_bresp(0) <= \^s_axi_bresp\(0);
\bresp[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EFEEFFFFEFEE0000"
    )
        port map (
      I0 => \ctrl/aw_addr\(1),
      I1 => \ctrl/aw_addr\(0),
      I2 => impl_n_74,
      I3 => impl_n_70,
      I4 => \ctrl/mailbox116_out\,
      I5 => \^s_axi_bresp\(0),
      O => \bresp[1]_i_2_n_0\
    );
bvalid_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7444"
    )
        port map (
      I0 => s_axi_bready,
      I1 => \^bvalid_reg\,
      I2 => impl_n_6,
      I3 => \ctrl/aw_held\,
      O => bvalid_i_1_n_0
    );
impl: entity work.c6v_input_osd_0_0_input_osd_top
     port map (
      Q(1 downto 0) => \ctrl/aw_addr\(1 downto 0),
      audio1 => \pixels/audio1\,
      audio1_reg => impl_n_78,
      audio1_reg_0 => impl_n_81,
      audio1_reg_1 => impl_n_83,
      audio1_reg_2 => impl_n_85,
      audio1_reg_3 => impl_n_87,
      \aw_addr_reg[5]\ => impl_n_70,
      aw_held => \ctrl/aw_held\,
      \bresp_reg[1]\ => \bresp[1]_i_2_n_0\,
      bvalid_reg => \^bvalid_reg\,
      bvalid_reg_0 => bvalid_i_1_n_0,
      de_prev_reg => impl_n_75,
      enable1_reg => impl_n_80,
      fist1_reg => impl_n_76,
      fist1_reg_0 => impl_n_86,
      in_de => in_de,
      in_hs => in_hs,
      in_rgb(23 downto 0) => in_rgb(23 downto 0),
      in_vs => in_vs,
      mailbox116_out => \ctrl/mailbox116_out\,
      out_de => out_de,
      out_hs => out_hs,
      out_rgb(23 downto 0) => out_rgb(23 downto 0),
      out_vs => out_vs,
      \paint2[23]_i_3\ => impl_n_79,
      \paint2_reg[11]\ => \paint2[11]_i_1_n_0\,
      \paint2_reg[12]\ => \paint2[12]_i_1_n_0\,
      \paint2_reg[19]\ => \paint2[19]_i_1_n_0\,
      \paint2_reg[20]\ => \paint2[20]_i_1_n_0\,
      \paint2_reg[4]\ => \paint2[4]_i_1_n_0\,
      pclk => pclk,
      \pp_release_reg[1]_0\ => impl_n_0,
      presetn => presetn,
      rvalid_reg => \^rvalid_reg\,
      rvalid_reg_0 => rvalid_i_1_n_0,
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(6 downto 0) => s_axi_araddr(6 downto 0),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arready => s_axi_arready,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(6 downto 0) => s_axi_awaddr(6 downto 0),
      s_axi_awready => s_axi_awready,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bresp(0) => \^s_axi_bresp\(0),
      s_axi_rdata(31 downto 0) => s_axi_rdata(31 downto 0),
      s_axi_rresp(0) => s_axi_rresp(0),
      s_axi_wdata(31 downto 0) => s_axi_wdata(31 downto 0),
      s_axi_wready => s_axi_wready,
      s_axi_wstrb(3 downto 0) => s_axi_wstrb(3 downto 0),
      s_axi_wvalid => s_axi_wvalid,
      \w_data_reg[0]\ => impl_n_74,
      w_held_reg => impl_n_6,
      \x1_reg[3]\ => impl_n_82,
      \x1_reg[3]_0\ => impl_n_84,
      \y1_reg[9]\ => impl_n_77
    );
\paint2[11]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000088088888"
    )
        port map (
      I0 => impl_n_78,
      I1 => impl_n_80,
      I2 => impl_n_82,
      I3 => impl_n_79,
      I4 => impl_n_75,
      I5 => impl_n_0,
      O => \paint2[11]_i_1_n_0\
    );
\paint2[12]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000F7550000"
    )
        port map (
      I0 => impl_n_76,
      I1 => impl_n_79,
      I2 => impl_n_87,
      I3 => impl_n_82,
      I4 => impl_n_75,
      I5 => impl_n_81,
      O => \paint2[12]_i_1_n_0\
    );
\paint2[19]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000044044444"
    )
        port map (
      I0 => impl_n_85,
      I1 => impl_n_80,
      I2 => impl_n_82,
      I3 => impl_n_79,
      I4 => impl_n_75,
      I5 => impl_n_0,
      O => \paint2[19]_i_1_n_0\
    );
\paint2[20]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000000EEE0000"
    )
        port map (
      I0 => impl_n_82,
      I1 => impl_n_86,
      I2 => impl_n_79,
      I3 => impl_n_85,
      I4 => impl_n_75,
      I5 => impl_n_81,
      O => \paint2[20]_i_1_n_0\
    );
\paint2[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000B0F0B0"
    )
        port map (
      I0 => impl_n_83,
      I1 => impl_n_84,
      I2 => impl_n_75,
      I3 => impl_n_77,
      I4 => \pixels/audio1\,
      I5 => impl_n_0,
      O => \paint2[4]_i_1_n_0\
    );
rvalid_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"74"
    )
        port map (
      I0 => s_axi_rready,
      I1 => \^rvalid_reg\,
      I2 => s_axi_arvalid,
      O => rvalid_i_1_n_0
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_input_osd_0_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    pclk : in STD_LOGIC;
    presetn : in STD_LOGIC;
    in_rgb : in STD_LOGIC_VECTOR ( 23 downto 0 );
    in_de : in STD_LOGIC;
    in_hs : in STD_LOGIC;
    in_vs : in STD_LOGIC;
    out_rgb : out STD_LOGIC_VECTOR ( 23 downto 0 );
    out_de : out STD_LOGIC;
    out_hs : out STD_LOGIC;
    out_vs : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of c6v_input_osd_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_input_osd_0_0 : entity is "c6v_input_osd_0_0,input_osd_axi,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_input_osd_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_input_osd_0_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of c6v_input_osd_0_0 : entity is "input_osd_axi,Vivado 2026.1";
end c6v_input_osd_0_0;

architecture STRUCTURE of c6v_input_osd_0_0 is
  signal \<const0>\ : STD_LOGIC;
  signal \^s_axi_bresp\ : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \^s_axi_rresp\ : STD_LOGIC_VECTOR ( 1 to 1 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of pclk : signal is "xilinx.com:signal:clock:1.0 pclk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of pclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of pclk : signal is "XIL_INTERFACENAME pclk, ASSOCIATED_RESET presetn, FREQ_HZ 74250000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /pixel_clock_clk_out1, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of presetn : signal is "xilinx.com:signal:reset:1.0 presetn RST";
  attribute X_INTERFACE_MODE of presetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of presetn : signal is "XIL_INTERFACENAME presetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_aclk : signal is "xilinx.com:signal:clock:1.0 s_axi_aclk CLK";
  attribute X_INTERFACE_MODE of s_axi_aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s_axi_aclk : signal is "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_aresetn : signal is "xilinx.com:signal:reset:1.0 s_axi_aresetn RST";
  attribute X_INTERFACE_MODE of s_axi_aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s_axi_aresetn : signal is "XIL_INTERFACENAME s_axi_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_arready : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARREADY";
  attribute X_INTERFACE_INFO of s_axi_arvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARVALID";
  attribute X_INTERFACE_INFO of s_axi_awready : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWREADY";
  attribute X_INTERFACE_INFO of s_axi_awvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWVALID";
  attribute X_INTERFACE_INFO of s_axi_bready : signal is "xilinx.com:interface:aximm:1.0 S_AXI BREADY";
  attribute X_INTERFACE_INFO of s_axi_bvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI BVALID";
  attribute X_INTERFACE_INFO of s_axi_rready : signal is "xilinx.com:interface:aximm:1.0 S_AXI RREADY";
  attribute X_INTERFACE_INFO of s_axi_rvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI RVALID";
  attribute X_INTERFACE_INFO of s_axi_wready : signal is "xilinx.com:interface:aximm:1.0 S_AXI WREADY";
  attribute X_INTERFACE_INFO of s_axi_wvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI WVALID";
  attribute X_INTERFACE_INFO of s_axi_araddr : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARADDR";
  attribute X_INTERFACE_INFO of s_axi_arprot : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARPROT";
  attribute X_INTERFACE_INFO of s_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWADDR";
  attribute X_INTERFACE_MODE of s_axi_awaddr : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s_axi_awaddr : signal is "XIL_INTERFACENAME S_AXI, PROTOCOL AXI4LITE, DATA_WIDTH 32, ADDR_WIDTH 7, HAS_BURST 0, HAS_LOCK 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, FREQ_HZ 100000000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_PROT 1, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_awprot : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWPROT";
  attribute X_INTERFACE_INFO of s_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 S_AXI BRESP";
  attribute X_INTERFACE_INFO of s_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 S_AXI RDATA";
  attribute X_INTERFACE_INFO of s_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 S_AXI RRESP";
  attribute X_INTERFACE_INFO of s_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 S_AXI WDATA";
  attribute X_INTERFACE_INFO of s_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 S_AXI WSTRB";
begin
  s_axi_bresp(1) <= \^s_axi_bresp\(1);
  s_axi_bresp(0) <= \<const0>\;
  s_axi_rresp(1) <= \^s_axi_rresp\(1);
  s_axi_rresp(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
inst: entity work.c6v_input_osd_0_0_input_osd_axi
     port map (
      bvalid_reg => s_axi_bvalid,
      in_de => in_de,
      in_hs => in_hs,
      in_rgb(23 downto 0) => in_rgb(23 downto 0),
      in_vs => in_vs,
      out_de => out_de,
      out_hs => out_hs,
      out_rgb(23 downto 0) => out_rgb(23 downto 0),
      out_vs => out_vs,
      pclk => pclk,
      presetn => presetn,
      rvalid_reg => s_axi_rvalid,
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(6 downto 0) => s_axi_araddr(6 downto 0),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arready => s_axi_arready,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(6 downto 0) => s_axi_awaddr(6 downto 0),
      s_axi_awready => s_axi_awready,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bready => s_axi_bready,
      s_axi_bresp(0) => \^s_axi_bresp\(1),
      s_axi_rdata(31 downto 0) => s_axi_rdata(31 downto 0),
      s_axi_rready => s_axi_rready,
      s_axi_rresp(0) => \^s_axi_rresp\(1),
      s_axi_wdata(31 downto 0) => s_axi_wdata(31 downto 0),
      s_axi_wready => s_axi_wready,
      s_axi_wstrb(3 downto 0) => s_axi_wstrb(3 downto 0),
      s_axi_wvalid => s_axi_wvalid
    );
end STRUCTURE;
