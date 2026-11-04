-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Thu Oct 22 03:24:04 2026
-- Host        : build-host running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top c6v_return_state_gpio_0 -prefix
--               c6v_return_state_gpio_0_ c6v_return_state_gpio_0_sim_netlist.vhdl
-- Design      : c6v_return_state_gpio_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_return_state_gpio_0_address_decoder is
  port (
    \MEM_DECODE_GEN[0].cs_out_i_reg[0]_0\ : out STD_LOGIC;
    \Dual.gpio_Data_In_reg[0]\ : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 31 downto 0 );
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wdata_0_sp_1 : out STD_LOGIC;
    ip2bus_rdack_i_D1_reg : out STD_LOGIC;
    ip2bus_wrack_i_D1_reg : out STD_LOGIC;
    \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    Q : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    \Dual.gpio2_OE_reg[0]\ : in STD_LOGIC_VECTOR ( 2 downto 0 );
    Bus_RNW_reg_reg_0 : in STD_LOGIC;
    gpio_Data_In : in STD_LOGIC_VECTOR ( 0 to 0 );
    \Dual.gpio_OE_reg[0]\ : in STD_LOGIC;
    gpio_xferAck_Reg : in STD_LOGIC;
    GPIO_xferAck_i : in STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_aresetn : in STD_LOGIC;
    ip2bus_rdack_i_D1 : in STD_LOGIC;
    s_axi_arready : in STD_LOGIC;
    s_axi_arready_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    ip2bus_wrack_i_D1 : in STD_LOGIC;
    s_axi_awready : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\ : in STD_LOGIC
  );
end c6v_return_state_gpio_0_address_decoder;

architecture STRUCTURE of c6v_return_state_gpio_0_address_decoder is
  signal Bus_RNW_reg : STD_LOGIC;
  signal Bus_RNW_reg_i_1_n_0 : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1[31]_i_2_n_0\ : STD_LOGIC;
  signal \Dual.gpio_OE[0]_i_2_n_0\ : STD_LOGIC;
  signal \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\ : STD_LOGIC;
  signal \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\ : STD_LOGIC;
  signal \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\ : STD_LOGIC;
  signal \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\ : STD_LOGIC;
  signal \MEM_DECODE_GEN[0].cs_out_i[0]_i_1_n_0\ : STD_LOGIC;
  signal \^mem_decode_gen[0].cs_out_i_reg[0]_0\ : STD_LOGIC;
  signal ce_expnd_i_0 : STD_LOGIC;
  signal ce_expnd_i_1 : STD_LOGIC;
  signal ce_expnd_i_2 : STD_LOGIC;
  signal ce_expnd_i_3 : STD_LOGIC;
  signal cs_ce_clr : STD_LOGIC;
  signal \ip2bus_data_i_D1[31]_i_2_n_0\ : STD_LOGIC;
  signal \ip2bus_data_i_D1[31]_i_3_n_0\ : STD_LOGIC;
  signal \^ip2bus_rdack_i_d1_reg\ : STD_LOGIC;
  signal \^ip2bus_wrack_i_d1_reg\ : STD_LOGIC;
  signal s_axi_wdata_0_sn_1 : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1[31]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[0]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[0]_i_2\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[10]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[11]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[12]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[13]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[14]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[15]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[16]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[17]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[18]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[19]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[1]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[20]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[21]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[22]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[23]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[24]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[25]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[26]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[27]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[28]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[29]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[2]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[30]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[31]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[3]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[4]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[5]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[6]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[7]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[8]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \Dual.gpio2_OE[9]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \Dual.gpio_OE[0]_i_2\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[1].ce_out_i[1]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[2].ce_out_i[2]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \GEN_BKEND_CE_REGISTERS[3].ce_out_i[3]_i_2\ : label is "soft_lutpair1";
begin
  \MEM_DECODE_GEN[0].cs_out_i_reg[0]_0\ <= \^mem_decode_gen[0].cs_out_i_reg[0]_0\;
  ip2bus_rdack_i_D1_reg <= \^ip2bus_rdack_i_d1_reg\;
  ip2bus_wrack_i_D1_reg <= \^ip2bus_wrack_i_d1_reg\;
  s_axi_wdata_0_sp_1 <= s_axi_wdata_0_sn_1;
Bus_RNW_reg_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Bus_RNW_reg_reg_0,
      I1 => Q,
      I2 => Bus_RNW_reg,
      O => Bus_RNW_reg_i_1_n_0
    );
Bus_RNW_reg_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => Bus_RNW_reg_i_1_n_0,
      Q => Bus_RNW_reg,
      R => '0'
    );
\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1[31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000C808"
    )
        port map (
      I0 => gpio_Data_In(0),
      I1 => \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1[31]_i_2_n_0\,
      I2 => \Dual.gpio2_OE_reg[0]\(0),
      I3 => \Dual.gpio_OE_reg[0]\,
      I4 => \Dual.gpio2_OE_reg[0]\(1),
      O => \Dual.gpio_Data_In_reg[0]\
    );
\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1[31]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000020"
    )
        port map (
      I0 => Bus_RNW_reg_reg_0,
      I1 => gpio_xferAck_Reg,
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      I3 => GPIO_xferAck_i,
      I4 => \Dual.gpio2_OE_reg[0]\(2),
      O => \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1[31]_i_2_n_0\
    );
\Dual.gpio2_OE[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00200000"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(0),
      I1 => Bus_RNW_reg_reg_0,
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      I3 => \Dual.gpio2_OE_reg[0]\(2),
      I4 => \Dual.gpio2_OE_reg[0]\(1),
      O => E(0)
    );
\Dual.gpio2_OE[0]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"EF40"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(0),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      I3 => s_axi_wdata(31),
      O => D(31)
    );
\Dual.gpio2_OE[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(21),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(21)
    );
\Dual.gpio2_OE[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(20),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(20)
    );
\Dual.gpio2_OE[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(19),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(19)
    );
\Dual.gpio2_OE[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(18),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(18)
    );
\Dual.gpio2_OE[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(17),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(17)
    );
\Dual.gpio2_OE[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(16),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(16)
    );
\Dual.gpio2_OE[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(15),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(15)
    );
\Dual.gpio2_OE[17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(14),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(14)
    );
\Dual.gpio2_OE[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(13),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(13)
    );
\Dual.gpio2_OE[19]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(12),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(12)
    );
\Dual.gpio2_OE[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(30),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(30)
    );
\Dual.gpio2_OE[20]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(11),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(11)
    );
\Dual.gpio2_OE[21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(10),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(10)
    );
\Dual.gpio2_OE[22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(9),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(9)
    );
\Dual.gpio2_OE[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(8),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(8)
    );
\Dual.gpio2_OE[24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(7),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(7)
    );
\Dual.gpio2_OE[25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(6),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(6)
    );
\Dual.gpio2_OE[26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(5),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(5)
    );
\Dual.gpio2_OE[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(4),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(4)
    );
\Dual.gpio2_OE[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(3),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(3)
    );
\Dual.gpio2_OE[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(2),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(2)
    );
\Dual.gpio2_OE[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(29),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(29)
    );
\Dual.gpio2_OE[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(1),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(1)
    );
\Dual.gpio2_OE[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(0),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(0)
    );
\Dual.gpio2_OE[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(28),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(28)
    );
\Dual.gpio2_OE[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(27),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(27)
    );
\Dual.gpio2_OE[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(26),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(26)
    );
\Dual.gpio2_OE[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(25),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(25)
    );
\Dual.gpio2_OE[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(24),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(24)
    );
\Dual.gpio2_OE[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(23),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(23)
    );
\Dual.gpio2_OE[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8C"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(1),
      I1 => s_axi_wdata(22),
      I2 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      O => D(22)
    );
\Dual.gpio_OE[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFB8FF0000B800"
    )
        port map (
      I0 => s_axi_wdata(0),
      I1 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      I2 => s_axi_wdata(31),
      I3 => \Dual.gpio_OE[0]_i_2_n_0\,
      I4 => \Dual.gpio2_OE_reg[0]\(1),
      I5 => \Dual.gpio_OE_reg[0]\,
      O => s_axi_wdata_0_sn_1
    );
\Dual.gpio_OE[0]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0400"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(2),
      I1 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      I2 => Bus_RNW_reg_reg_0,
      I3 => \Dual.gpio2_OE_reg[0]\(0),
      O => \Dual.gpio_OE[0]_i_2_n_0\
    );
\GEN_BKEND_CE_REGISTERS[0].ce_out_i[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(0),
      I1 => \Dual.gpio2_OE_reg[0]\(1),
      O => ce_expnd_i_3
    );
\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => Q,
      D => ce_expnd_i_3,
      Q => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[1].ce_out_i[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(0),
      I1 => \Dual.gpio2_OE_reg[0]\(1),
      O => ce_expnd_i_2
    );
\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => Q,
      D => ce_expnd_i_2,
      Q => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[2].ce_out_i[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"4"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(0),
      I1 => \Dual.gpio2_OE_reg[0]\(1),
      O => ce_expnd_i_1
    );
\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => Q,
      D => ce_expnd_i_1,
      Q => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      R => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[3].ce_out_i[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"EF"
    )
        port map (
      I0 => \^ip2bus_wrack_i_d1_reg\,
      I1 => \^ip2bus_rdack_i_d1_reg\,
      I2 => s_axi_aresetn,
      O => cs_ce_clr
    );
\GEN_BKEND_CE_REGISTERS[3].ce_out_i[3]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \Dual.gpio2_OE_reg[0]\(0),
      I1 => \Dual.gpio2_OE_reg[0]\(1),
      O => ce_expnd_i_0
    );
\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => Q,
      D => ce_expnd_i_0,
      Q => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      R => cs_ce_clr
    );
\MEM_DECODE_GEN[0].cs_out_i[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"000000E0"
    )
        port map (
      I0 => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      I1 => Q,
      I2 => s_axi_aresetn,
      I3 => \^ip2bus_rdack_i_d1_reg\,
      I4 => \^ip2bus_wrack_i_d1_reg\,
      O => \MEM_DECODE_GEN[0].cs_out_i[0]_i_1_n_0\
    );
\MEM_DECODE_GEN[0].cs_out_i_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \MEM_DECODE_GEN[0].cs_out_i[0]_i_1_n_0\,
      Q => \^mem_decode_gen[0].cs_out_i_reg[0]_0\,
      R => '0'
    );
\ip2bus_data_i_D1[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(31)
    );
\ip2bus_data_i_D1[10]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(21)
    );
\ip2bus_data_i_D1[11]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(20)
    );
\ip2bus_data_i_D1[12]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(19)
    );
\ip2bus_data_i_D1[13]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(18)
    );
\ip2bus_data_i_D1[14]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(17)
    );
\ip2bus_data_i_D1[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(16)
    );
\ip2bus_data_i_D1[16]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(15)
    );
\ip2bus_data_i_D1[17]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(14)
    );
\ip2bus_data_i_D1[18]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(13)
    );
\ip2bus_data_i_D1[19]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(12)
    );
\ip2bus_data_i_D1[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(30)
    );
\ip2bus_data_i_D1[20]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(11)
    );
\ip2bus_data_i_D1[21]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(10)
    );
\ip2bus_data_i_D1[22]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(9)
    );
\ip2bus_data_i_D1[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(8)
    );
\ip2bus_data_i_D1[24]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(7)
    );
\ip2bus_data_i_D1[25]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(6)
    );
\ip2bus_data_i_D1[26]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(5)
    );
\ip2bus_data_i_D1[27]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(4)
    );
\ip2bus_data_i_D1[28]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(3)
    );
\ip2bus_data_i_D1[29]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(2)
    );
\ip2bus_data_i_D1[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(29)
    );
\ip2bus_data_i_D1[30]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(1)
    );
\ip2bus_data_i_D1[31]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"05004A00"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I1 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => Bus_RNW_reg,
      I4 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      O => \ip2bus_data_i_D1[31]_i_2_n_0\
    );
\ip2bus_data_i_D1[31]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00001000"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I2 => Bus_RNW_reg,
      I3 => \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      O => \ip2bus_data_i_D1[31]_i_3_n_0\
    );
\ip2bus_data_i_D1[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(28)
    );
\ip2bus_data_i_D1[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(27)
    );
\ip2bus_data_i_D1[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(26)
    );
\ip2bus_data_i_D1[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(25)
    );
\ip2bus_data_i_D1[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(24)
    );
\ip2bus_data_i_D1[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(23)
    );
\ip2bus_data_i_D1[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000004044808"
    )
        port map (
      I0 => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg\,
      I1 => Bus_RNW_reg,
      I2 => \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg\,
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\,
      I4 => \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg\,
      I5 => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(22)
    );
\ip2bus_data_i_D1_reg[31]_i_1\: unisim.vcomponents.MUXF7
     port map (
      I0 => \ip2bus_data_i_D1[31]_i_2_n_0\,
      I1 => \ip2bus_data_i_D1[31]_i_3_n_0\,
      O => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(0),
      S => \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg\
    );
s_axi_arready_INST_0: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAEAAAA"
    )
        port map (
      I0 => ip2bus_rdack_i_D1,
      I1 => s_axi_arready,
      I2 => s_axi_arready_0(2),
      I3 => s_axi_arready_0(1),
      I4 => s_axi_arready_0(3),
      I5 => s_axi_arready_0(0),
      O => \^ip2bus_rdack_i_d1_reg\
    );
s_axi_wready_INST_0: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAEAAAA"
    )
        port map (
      I0 => ip2bus_wrack_i_D1,
      I1 => s_axi_awready,
      I2 => s_axi_arready_0(2),
      I3 => s_axi_arready_0(1),
      I4 => s_axi_arready_0(3),
      I5 => s_axi_arready_0(0),
      O => \^ip2bus_wrack_i_d1_reg\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_return_state_gpio_0_xpm_cdc_array_single is
  port (
    src_clk : in STD_LOGIC;
    src_in : in STD_LOGIC_VECTOR ( 0 to 0 );
    dest_clk : in STD_LOGIC;
    dest_out : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of c6v_return_state_gpio_0_xpm_cdc_array_single : entity is 4;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of c6v_return_state_gpio_0_xpm_cdc_array_single : entity is 0;
  attribute SIM_ASSERT_CHK : integer;
  attribute SIM_ASSERT_CHK of c6v_return_state_gpio_0_xpm_cdc_array_single : entity is 0;
  attribute SRC_INPUT_REG : integer;
  attribute SRC_INPUT_REG of c6v_return_state_gpio_0_xpm_cdc_array_single : entity is 0;
  attribute VERSION : integer;
  attribute VERSION of c6v_return_state_gpio_0_xpm_cdc_array_single : entity is 0;
  attribute WIDTH : integer;
  attribute WIDTH of c6v_return_state_gpio_0_xpm_cdc_array_single : entity is 1;
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of c6v_return_state_gpio_0_xpm_cdc_array_single : entity is "TRUE";
  attribute keep_hierarchy : string;
  attribute keep_hierarchy of c6v_return_state_gpio_0_xpm_cdc_array_single : entity is "soft";
  attribute xpm_cdc : string;
  attribute xpm_cdc of c6v_return_state_gpio_0_xpm_cdc_array_single : entity is "ARRAY_SINGLE";
end c6v_return_state_gpio_0_xpm_cdc_array_single;

architecture STRUCTURE of c6v_return_state_gpio_0_xpm_cdc_array_single is
  signal async_path_bit : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \syncstages_ff[0]\ : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute RTL_KEEP : string;
  attribute RTL_KEEP of \syncstages_ff[0]\ : signal is "true";
  attribute async_reg : string;
  attribute async_reg of \syncstages_ff[0]\ : signal is "true";
  attribute xpm_cdc of \syncstages_ff[0]\ : signal is "ARRAY_SINGLE";
  signal \syncstages_ff[1]\ : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute RTL_KEEP of \syncstages_ff[1]\ : signal is "true";
  attribute async_reg of \syncstages_ff[1]\ : signal is "true";
  attribute xpm_cdc of \syncstages_ff[1]\ : signal is "ARRAY_SINGLE";
  signal \syncstages_ff[2]\ : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute RTL_KEEP of \syncstages_ff[2]\ : signal is "true";
  attribute async_reg of \syncstages_ff[2]\ : signal is "true";
  attribute xpm_cdc of \syncstages_ff[2]\ : signal is "ARRAY_SINGLE";
  signal \syncstages_ff[3]\ : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute RTL_KEEP of \syncstages_ff[3]\ : signal is "true";
  attribute async_reg of \syncstages_ff[3]\ : signal is "true";
  attribute xpm_cdc of \syncstages_ff[3]\ : signal is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \syncstages_ff_reg[0][0]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][0]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][0]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][0]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][0]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][0]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][0]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][0]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][0]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][0]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][0]\ : label is "ARRAY_SINGLE";
begin
  async_path_bit(0) <= src_in(0);
  dest_out(0) <= \syncstages_ff[3]\(0);
\syncstages_ff_reg[0][0]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(0),
      Q => \syncstages_ff[0]\(0),
      R => '0'
    );
\syncstages_ff_reg[1][0]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(0),
      Q => \syncstages_ff[1]\(0),
      R => '0'
    );
\syncstages_ff_reg[2][0]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(0),
      Q => \syncstages_ff[2]\(0),
      R => '0'
    );
\syncstages_ff_reg[3][0]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(0),
      Q => \syncstages_ff[3]\(0),
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1\ is
  port (
    src_clk : in STD_LOGIC;
    src_in : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dest_clk : in STD_LOGIC;
    dest_out : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of \c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1\ : entity is 4;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of \c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1\ : entity is 0;
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1\ : entity is "xpm_cdc_array_single";
  attribute SIM_ASSERT_CHK : integer;
  attribute SIM_ASSERT_CHK of \c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1\ : entity is 0;
  attribute SRC_INPUT_REG : integer;
  attribute SRC_INPUT_REG of \c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1\ : entity is 0;
  attribute VERSION : integer;
  attribute VERSION of \c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1\ : entity is 0;
  attribute WIDTH : integer;
  attribute WIDTH of \c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1\ : entity is 32;
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of \c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1\ : entity is "TRUE";
  attribute keep_hierarchy : string;
  attribute keep_hierarchy of \c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1\ : entity is "soft";
  attribute xpm_cdc : string;
  attribute xpm_cdc of \c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1\ : entity is "ARRAY_SINGLE";
end \c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1\;

architecture STRUCTURE of \c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1\ is
  signal async_path_bit : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \syncstages_ff[0]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  attribute RTL_KEEP : string;
  attribute RTL_KEEP of \syncstages_ff[0]\ : signal is "true";
  attribute async_reg : string;
  attribute async_reg of \syncstages_ff[0]\ : signal is "true";
  attribute xpm_cdc of \syncstages_ff[0]\ : signal is "ARRAY_SINGLE";
  signal \syncstages_ff[1]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  attribute RTL_KEEP of \syncstages_ff[1]\ : signal is "true";
  attribute async_reg of \syncstages_ff[1]\ : signal is "true";
  attribute xpm_cdc of \syncstages_ff[1]\ : signal is "ARRAY_SINGLE";
  signal \syncstages_ff[2]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  attribute RTL_KEEP of \syncstages_ff[2]\ : signal is "true";
  attribute async_reg of \syncstages_ff[2]\ : signal is "true";
  attribute xpm_cdc of \syncstages_ff[2]\ : signal is "ARRAY_SINGLE";
  signal \syncstages_ff[3]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  attribute RTL_KEEP of \syncstages_ff[3]\ : signal is "true";
  attribute async_reg of \syncstages_ff[3]\ : signal is "true";
  attribute xpm_cdc of \syncstages_ff[3]\ : signal is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \syncstages_ff_reg[0][0]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][0]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][10]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][10]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][10]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][11]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][11]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][11]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][12]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][12]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][12]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][13]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][13]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][13]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][14]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][14]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][14]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][15]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][15]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][15]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][16]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][16]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][16]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][17]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][17]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][17]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][18]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][18]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][18]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][19]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][19]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][19]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][1]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][1]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][1]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][20]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][20]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][20]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][21]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][21]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][21]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][22]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][22]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][22]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][23]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][23]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][23]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][24]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][24]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][24]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][25]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][25]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][25]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][26]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][26]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][26]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][27]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][27]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][27]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][28]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][28]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][28]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][29]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][29]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][29]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][2]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][2]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][2]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][30]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][30]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][30]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][31]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][31]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][31]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][3]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][3]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][3]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][4]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][4]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][4]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][5]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][5]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][5]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][6]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][6]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][6]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][7]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][7]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][7]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][8]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][8]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][8]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0][9]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[0][9]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0][9]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][0]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][0]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][0]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][10]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][10]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][10]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][11]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][11]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][11]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][12]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][12]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][12]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][13]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][13]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][13]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][14]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][14]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][14]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][15]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][15]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][15]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][16]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][16]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][16]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][17]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][17]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][17]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][18]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][18]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][18]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][19]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][19]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][19]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][1]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][1]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][1]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][20]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][20]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][20]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][21]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][21]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][21]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][22]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][22]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][22]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][23]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][23]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][23]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][24]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][24]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][24]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][25]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][25]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][25]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][26]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][26]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][26]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][27]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][27]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][27]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][28]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][28]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][28]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][29]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][29]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][29]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][2]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][2]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][2]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][30]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][30]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][30]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][31]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][31]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][31]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][3]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][3]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][3]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][4]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][4]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][4]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][5]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][5]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][5]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][6]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][6]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][6]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][7]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][7]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][7]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][8]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][8]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][8]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1][9]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1][9]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1][9]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][0]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][0]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][0]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][10]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][10]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][10]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][11]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][11]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][11]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][12]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][12]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][12]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][13]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][13]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][13]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][14]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][14]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][14]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][15]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][15]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][15]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][16]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][16]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][16]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][17]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][17]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][17]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][18]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][18]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][18]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][19]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][19]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][19]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][1]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][1]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][1]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][20]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][20]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][20]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][21]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][21]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][21]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][22]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][22]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][22]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][23]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][23]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][23]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][24]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][24]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][24]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][25]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][25]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][25]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][26]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][26]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][26]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][27]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][27]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][27]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][28]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][28]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][28]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][29]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][29]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][29]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][2]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][2]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][2]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][30]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][30]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][30]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][31]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][31]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][31]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][3]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][3]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][3]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][4]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][4]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][4]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][5]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][5]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][5]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][6]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][6]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][6]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][7]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][7]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][7]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][8]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][8]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][8]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2][9]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2][9]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2][9]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][0]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][0]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][0]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][10]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][10]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][10]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][11]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][11]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][11]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][12]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][12]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][12]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][13]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][13]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][13]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][14]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][14]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][14]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][15]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][15]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][15]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][16]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][16]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][16]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][17]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][17]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][17]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][18]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][18]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][18]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][19]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][19]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][19]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][1]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][1]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][1]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][20]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][20]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][20]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][21]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][21]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][21]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][22]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][22]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][22]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][23]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][23]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][23]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][24]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][24]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][24]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][25]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][25]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][25]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][26]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][26]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][26]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][27]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][27]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][27]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][28]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][28]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][28]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][29]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][29]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][29]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][2]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][2]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][2]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][30]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][30]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][30]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][31]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][31]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][31]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][3]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][3]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][3]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][4]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][4]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][4]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][5]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][5]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][5]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][6]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][6]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][6]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][7]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][7]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][7]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][8]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][8]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][8]\ : label is "ARRAY_SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[3][9]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[3][9]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[3][9]\ : label is "ARRAY_SINGLE";
begin
  async_path_bit(31 downto 0) <= src_in(31 downto 0);
  dest_out(31 downto 0) <= \syncstages_ff[3]\(31 downto 0);
\syncstages_ff_reg[0][0]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(0),
      Q => \syncstages_ff[0]\(0),
      R => '0'
    );
\syncstages_ff_reg[0][10]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(10),
      Q => \syncstages_ff[0]\(10),
      R => '0'
    );
\syncstages_ff_reg[0][11]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(11),
      Q => \syncstages_ff[0]\(11),
      R => '0'
    );
\syncstages_ff_reg[0][12]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(12),
      Q => \syncstages_ff[0]\(12),
      R => '0'
    );
\syncstages_ff_reg[0][13]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(13),
      Q => \syncstages_ff[0]\(13),
      R => '0'
    );
\syncstages_ff_reg[0][14]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(14),
      Q => \syncstages_ff[0]\(14),
      R => '0'
    );
\syncstages_ff_reg[0][15]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(15),
      Q => \syncstages_ff[0]\(15),
      R => '0'
    );
\syncstages_ff_reg[0][16]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(16),
      Q => \syncstages_ff[0]\(16),
      R => '0'
    );
\syncstages_ff_reg[0][17]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(17),
      Q => \syncstages_ff[0]\(17),
      R => '0'
    );
\syncstages_ff_reg[0][18]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(18),
      Q => \syncstages_ff[0]\(18),
      R => '0'
    );
\syncstages_ff_reg[0][19]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(19),
      Q => \syncstages_ff[0]\(19),
      R => '0'
    );
\syncstages_ff_reg[0][1]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(1),
      Q => \syncstages_ff[0]\(1),
      R => '0'
    );
\syncstages_ff_reg[0][20]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(20),
      Q => \syncstages_ff[0]\(20),
      R => '0'
    );
\syncstages_ff_reg[0][21]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(21),
      Q => \syncstages_ff[0]\(21),
      R => '0'
    );
\syncstages_ff_reg[0][22]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(22),
      Q => \syncstages_ff[0]\(22),
      R => '0'
    );
\syncstages_ff_reg[0][23]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(23),
      Q => \syncstages_ff[0]\(23),
      R => '0'
    );
\syncstages_ff_reg[0][24]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(24),
      Q => \syncstages_ff[0]\(24),
      R => '0'
    );
\syncstages_ff_reg[0][25]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(25),
      Q => \syncstages_ff[0]\(25),
      R => '0'
    );
\syncstages_ff_reg[0][26]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(26),
      Q => \syncstages_ff[0]\(26),
      R => '0'
    );
\syncstages_ff_reg[0][27]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(27),
      Q => \syncstages_ff[0]\(27),
      R => '0'
    );
\syncstages_ff_reg[0][28]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(28),
      Q => \syncstages_ff[0]\(28),
      R => '0'
    );
\syncstages_ff_reg[0][29]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(29),
      Q => \syncstages_ff[0]\(29),
      R => '0'
    );
\syncstages_ff_reg[0][2]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(2),
      Q => \syncstages_ff[0]\(2),
      R => '0'
    );
\syncstages_ff_reg[0][30]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(30),
      Q => \syncstages_ff[0]\(30),
      R => '0'
    );
\syncstages_ff_reg[0][31]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(31),
      Q => \syncstages_ff[0]\(31),
      R => '0'
    );
\syncstages_ff_reg[0][3]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(3),
      Q => \syncstages_ff[0]\(3),
      R => '0'
    );
\syncstages_ff_reg[0][4]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(4),
      Q => \syncstages_ff[0]\(4),
      R => '0'
    );
\syncstages_ff_reg[0][5]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(5),
      Q => \syncstages_ff[0]\(5),
      R => '0'
    );
\syncstages_ff_reg[0][6]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(6),
      Q => \syncstages_ff[0]\(6),
      R => '0'
    );
\syncstages_ff_reg[0][7]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(7),
      Q => \syncstages_ff[0]\(7),
      R => '0'
    );
\syncstages_ff_reg[0][8]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(8),
      Q => \syncstages_ff[0]\(8),
      R => '0'
    );
\syncstages_ff_reg[0][9]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => async_path_bit(9),
      Q => \syncstages_ff[0]\(9),
      R => '0'
    );
\syncstages_ff_reg[1][0]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(0),
      Q => \syncstages_ff[1]\(0),
      R => '0'
    );
\syncstages_ff_reg[1][10]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(10),
      Q => \syncstages_ff[1]\(10),
      R => '0'
    );
\syncstages_ff_reg[1][11]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(11),
      Q => \syncstages_ff[1]\(11),
      R => '0'
    );
\syncstages_ff_reg[1][12]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(12),
      Q => \syncstages_ff[1]\(12),
      R => '0'
    );
\syncstages_ff_reg[1][13]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(13),
      Q => \syncstages_ff[1]\(13),
      R => '0'
    );
\syncstages_ff_reg[1][14]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(14),
      Q => \syncstages_ff[1]\(14),
      R => '0'
    );
\syncstages_ff_reg[1][15]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(15),
      Q => \syncstages_ff[1]\(15),
      R => '0'
    );
\syncstages_ff_reg[1][16]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(16),
      Q => \syncstages_ff[1]\(16),
      R => '0'
    );
\syncstages_ff_reg[1][17]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(17),
      Q => \syncstages_ff[1]\(17),
      R => '0'
    );
\syncstages_ff_reg[1][18]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(18),
      Q => \syncstages_ff[1]\(18),
      R => '0'
    );
\syncstages_ff_reg[1][19]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(19),
      Q => \syncstages_ff[1]\(19),
      R => '0'
    );
\syncstages_ff_reg[1][1]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(1),
      Q => \syncstages_ff[1]\(1),
      R => '0'
    );
\syncstages_ff_reg[1][20]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(20),
      Q => \syncstages_ff[1]\(20),
      R => '0'
    );
\syncstages_ff_reg[1][21]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(21),
      Q => \syncstages_ff[1]\(21),
      R => '0'
    );
\syncstages_ff_reg[1][22]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(22),
      Q => \syncstages_ff[1]\(22),
      R => '0'
    );
\syncstages_ff_reg[1][23]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(23),
      Q => \syncstages_ff[1]\(23),
      R => '0'
    );
\syncstages_ff_reg[1][24]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(24),
      Q => \syncstages_ff[1]\(24),
      R => '0'
    );
\syncstages_ff_reg[1][25]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(25),
      Q => \syncstages_ff[1]\(25),
      R => '0'
    );
\syncstages_ff_reg[1][26]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(26),
      Q => \syncstages_ff[1]\(26),
      R => '0'
    );
\syncstages_ff_reg[1][27]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(27),
      Q => \syncstages_ff[1]\(27),
      R => '0'
    );
\syncstages_ff_reg[1][28]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(28),
      Q => \syncstages_ff[1]\(28),
      R => '0'
    );
\syncstages_ff_reg[1][29]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(29),
      Q => \syncstages_ff[1]\(29),
      R => '0'
    );
\syncstages_ff_reg[1][2]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(2),
      Q => \syncstages_ff[1]\(2),
      R => '0'
    );
\syncstages_ff_reg[1][30]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(30),
      Q => \syncstages_ff[1]\(30),
      R => '0'
    );
\syncstages_ff_reg[1][31]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(31),
      Q => \syncstages_ff[1]\(31),
      R => '0'
    );
\syncstages_ff_reg[1][3]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(3),
      Q => \syncstages_ff[1]\(3),
      R => '0'
    );
\syncstages_ff_reg[1][4]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(4),
      Q => \syncstages_ff[1]\(4),
      R => '0'
    );
\syncstages_ff_reg[1][5]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(5),
      Q => \syncstages_ff[1]\(5),
      R => '0'
    );
\syncstages_ff_reg[1][6]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(6),
      Q => \syncstages_ff[1]\(6),
      R => '0'
    );
\syncstages_ff_reg[1][7]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(7),
      Q => \syncstages_ff[1]\(7),
      R => '0'
    );
\syncstages_ff_reg[1][8]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(8),
      Q => \syncstages_ff[1]\(8),
      R => '0'
    );
\syncstages_ff_reg[1][9]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[0]\(9),
      Q => \syncstages_ff[1]\(9),
      R => '0'
    );
\syncstages_ff_reg[2][0]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(0),
      Q => \syncstages_ff[2]\(0),
      R => '0'
    );
\syncstages_ff_reg[2][10]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(10),
      Q => \syncstages_ff[2]\(10),
      R => '0'
    );
\syncstages_ff_reg[2][11]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(11),
      Q => \syncstages_ff[2]\(11),
      R => '0'
    );
\syncstages_ff_reg[2][12]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(12),
      Q => \syncstages_ff[2]\(12),
      R => '0'
    );
\syncstages_ff_reg[2][13]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(13),
      Q => \syncstages_ff[2]\(13),
      R => '0'
    );
\syncstages_ff_reg[2][14]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(14),
      Q => \syncstages_ff[2]\(14),
      R => '0'
    );
\syncstages_ff_reg[2][15]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(15),
      Q => \syncstages_ff[2]\(15),
      R => '0'
    );
\syncstages_ff_reg[2][16]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(16),
      Q => \syncstages_ff[2]\(16),
      R => '0'
    );
\syncstages_ff_reg[2][17]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(17),
      Q => \syncstages_ff[2]\(17),
      R => '0'
    );
\syncstages_ff_reg[2][18]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(18),
      Q => \syncstages_ff[2]\(18),
      R => '0'
    );
\syncstages_ff_reg[2][19]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(19),
      Q => \syncstages_ff[2]\(19),
      R => '0'
    );
\syncstages_ff_reg[2][1]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(1),
      Q => \syncstages_ff[2]\(1),
      R => '0'
    );
\syncstages_ff_reg[2][20]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(20),
      Q => \syncstages_ff[2]\(20),
      R => '0'
    );
\syncstages_ff_reg[2][21]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(21),
      Q => \syncstages_ff[2]\(21),
      R => '0'
    );
\syncstages_ff_reg[2][22]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(22),
      Q => \syncstages_ff[2]\(22),
      R => '0'
    );
\syncstages_ff_reg[2][23]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(23),
      Q => \syncstages_ff[2]\(23),
      R => '0'
    );
\syncstages_ff_reg[2][24]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(24),
      Q => \syncstages_ff[2]\(24),
      R => '0'
    );
\syncstages_ff_reg[2][25]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(25),
      Q => \syncstages_ff[2]\(25),
      R => '0'
    );
\syncstages_ff_reg[2][26]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(26),
      Q => \syncstages_ff[2]\(26),
      R => '0'
    );
\syncstages_ff_reg[2][27]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(27),
      Q => \syncstages_ff[2]\(27),
      R => '0'
    );
\syncstages_ff_reg[2][28]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(28),
      Q => \syncstages_ff[2]\(28),
      R => '0'
    );
\syncstages_ff_reg[2][29]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(29),
      Q => \syncstages_ff[2]\(29),
      R => '0'
    );
\syncstages_ff_reg[2][2]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(2),
      Q => \syncstages_ff[2]\(2),
      R => '0'
    );
\syncstages_ff_reg[2][30]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(30),
      Q => \syncstages_ff[2]\(30),
      R => '0'
    );
\syncstages_ff_reg[2][31]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(31),
      Q => \syncstages_ff[2]\(31),
      R => '0'
    );
\syncstages_ff_reg[2][3]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(3),
      Q => \syncstages_ff[2]\(3),
      R => '0'
    );
\syncstages_ff_reg[2][4]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(4),
      Q => \syncstages_ff[2]\(4),
      R => '0'
    );
\syncstages_ff_reg[2][5]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(5),
      Q => \syncstages_ff[2]\(5),
      R => '0'
    );
\syncstages_ff_reg[2][6]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(6),
      Q => \syncstages_ff[2]\(6),
      R => '0'
    );
\syncstages_ff_reg[2][7]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(7),
      Q => \syncstages_ff[2]\(7),
      R => '0'
    );
\syncstages_ff_reg[2][8]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(8),
      Q => \syncstages_ff[2]\(8),
      R => '0'
    );
\syncstages_ff_reg[2][9]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[1]\(9),
      Q => \syncstages_ff[2]\(9),
      R => '0'
    );
\syncstages_ff_reg[3][0]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(0),
      Q => \syncstages_ff[3]\(0),
      R => '0'
    );
\syncstages_ff_reg[3][10]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(10),
      Q => \syncstages_ff[3]\(10),
      R => '0'
    );
\syncstages_ff_reg[3][11]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(11),
      Q => \syncstages_ff[3]\(11),
      R => '0'
    );
\syncstages_ff_reg[3][12]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(12),
      Q => \syncstages_ff[3]\(12),
      R => '0'
    );
\syncstages_ff_reg[3][13]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(13),
      Q => \syncstages_ff[3]\(13),
      R => '0'
    );
\syncstages_ff_reg[3][14]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(14),
      Q => \syncstages_ff[3]\(14),
      R => '0'
    );
\syncstages_ff_reg[3][15]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(15),
      Q => \syncstages_ff[3]\(15),
      R => '0'
    );
\syncstages_ff_reg[3][16]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(16),
      Q => \syncstages_ff[3]\(16),
      R => '0'
    );
\syncstages_ff_reg[3][17]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(17),
      Q => \syncstages_ff[3]\(17),
      R => '0'
    );
\syncstages_ff_reg[3][18]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(18),
      Q => \syncstages_ff[3]\(18),
      R => '0'
    );
\syncstages_ff_reg[3][19]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(19),
      Q => \syncstages_ff[3]\(19),
      R => '0'
    );
\syncstages_ff_reg[3][1]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(1),
      Q => \syncstages_ff[3]\(1),
      R => '0'
    );
\syncstages_ff_reg[3][20]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(20),
      Q => \syncstages_ff[3]\(20),
      R => '0'
    );
\syncstages_ff_reg[3][21]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(21),
      Q => \syncstages_ff[3]\(21),
      R => '0'
    );
\syncstages_ff_reg[3][22]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(22),
      Q => \syncstages_ff[3]\(22),
      R => '0'
    );
\syncstages_ff_reg[3][23]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(23),
      Q => \syncstages_ff[3]\(23),
      R => '0'
    );
\syncstages_ff_reg[3][24]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(24),
      Q => \syncstages_ff[3]\(24),
      R => '0'
    );
\syncstages_ff_reg[3][25]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(25),
      Q => \syncstages_ff[3]\(25),
      R => '0'
    );
\syncstages_ff_reg[3][26]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(26),
      Q => \syncstages_ff[3]\(26),
      R => '0'
    );
\syncstages_ff_reg[3][27]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(27),
      Q => \syncstages_ff[3]\(27),
      R => '0'
    );
\syncstages_ff_reg[3][28]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(28),
      Q => \syncstages_ff[3]\(28),
      R => '0'
    );
\syncstages_ff_reg[3][29]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(29),
      Q => \syncstages_ff[3]\(29),
      R => '0'
    );
\syncstages_ff_reg[3][2]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(2),
      Q => \syncstages_ff[3]\(2),
      R => '0'
    );
\syncstages_ff_reg[3][30]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(30),
      Q => \syncstages_ff[3]\(30),
      R => '0'
    );
\syncstages_ff_reg[3][31]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(31),
      Q => \syncstages_ff[3]\(31),
      R => '0'
    );
\syncstages_ff_reg[3][3]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(3),
      Q => \syncstages_ff[3]\(3),
      R => '0'
    );
\syncstages_ff_reg[3][4]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(4),
      Q => \syncstages_ff[3]\(4),
      R => '0'
    );
\syncstages_ff_reg[3][5]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(5),
      Q => \syncstages_ff[3]\(5),
      R => '0'
    );
\syncstages_ff_reg[3][6]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(6),
      Q => \syncstages_ff[3]\(6),
      R => '0'
    );
\syncstages_ff_reg[3][7]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(7),
      Q => \syncstages_ff[3]\(7),
      R => '0'
    );
\syncstages_ff_reg[3][8]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(8),
      Q => \syncstages_ff[3]\(8),
      R => '0'
    );
\syncstages_ff_reg[3][9]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => \syncstages_ff[2]\(9),
      Q => \syncstages_ff[3]\(9),
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_return_state_gpio_0_GPIO_Core is
  port (
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\ : out STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\ : out STD_LOGIC;
    GPIO_xferAck_i : out STD_LOGIC;
    gpio_xferAck_Reg : out STD_LOGIC;
    gpio_Data_In : out STD_LOGIC_VECTOR ( 0 to 0 );
    \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\ : out STD_LOGIC;
    \Dual.gpio_OE_reg[0]_0\ : out STD_LOGIC;
    ip2bus_wrack_i : out STD_LOGIC;
    ip2bus_rdack_i : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 31 downto 0 );
    \Dual.gpio2_Data_In_reg[0]_0\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    gpio_io_i : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_aclk : in STD_LOGIC;
    gpio2_io_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \Dual.Read_Reg2_In\ : in STD_LOGIC_VECTOR ( 0 to 31 );
    bus2ip_reset : in STD_LOGIC;
    \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg[31]_0\ : in STD_LOGIC;
    \Dual.gpio_OE_reg[0]_1\ : in STD_LOGIC;
    bus2ip_cs : in STD_LOGIC_VECTOR ( 0 to 0 );
    bus2ip_rnw : in STD_LOGIC;
    E : in STD_LOGIC_VECTOR ( 0 to 0 );
    D : in STD_LOGIC_VECTOR ( 31 downto 0 )
  );
end c6v_return_state_gpio_0_GPIO_Core;

architecture STRUCTURE of c6v_return_state_gpio_0_GPIO_Core is
  signal \Dual.gpio2_io_i_d2\ : STD_LOGIC_VECTOR ( 0 to 31 );
  signal \^gpio_xferack_i\ : STD_LOGIC;
  signal Read_Reg_Rst : STD_LOGIC;
  signal gpio_io_i_d2 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^gpio_xferack_reg\ : STD_LOGIC;
  signal iGPIO_xferAck : STD_LOGIC;
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of \Dual.INPUT_DOUBLE_REGS4\ : label is 4;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of \Dual.INPUT_DOUBLE_REGS4\ : label is 0;
  attribute SIM_ASSERT_CHK : integer;
  attribute SIM_ASSERT_CHK of \Dual.INPUT_DOUBLE_REGS4\ : label is 0;
  attribute SRC_INPUT_REG : integer;
  attribute SRC_INPUT_REG of \Dual.INPUT_DOUBLE_REGS4\ : label is 0;
  attribute VERSION : integer;
  attribute VERSION of \Dual.INPUT_DOUBLE_REGS4\ : label is 0;
  attribute WIDTH : integer;
  attribute WIDTH of \Dual.INPUT_DOUBLE_REGS4\ : label is 1;
  attribute XPM_CDC : string;
  attribute XPM_CDC of \Dual.INPUT_DOUBLE_REGS4\ : label is "ARRAY_SINGLE";
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of \Dual.INPUT_DOUBLE_REGS4\ : label is "TRUE";
  attribute DEST_SYNC_FF of \Dual.INPUT_DOUBLE_REGS5\ : label is 4;
  attribute INIT_SYNC_FF of \Dual.INPUT_DOUBLE_REGS5\ : label is 0;
  attribute SIM_ASSERT_CHK of \Dual.INPUT_DOUBLE_REGS5\ : label is 0;
  attribute SRC_INPUT_REG of \Dual.INPUT_DOUBLE_REGS5\ : label is 0;
  attribute VERSION of \Dual.INPUT_DOUBLE_REGS5\ : label is 0;
  attribute WIDTH of \Dual.INPUT_DOUBLE_REGS5\ : label is 32;
  attribute XPM_CDC of \Dual.INPUT_DOUBLE_REGS5\ : label is "ARRAY_SINGLE";
  attribute XPM_MODULE of \Dual.INPUT_DOUBLE_REGS5\ : label is "TRUE";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of iGPIO_xferAck_i_1 : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of ip2bus_wrack_i_D1_i_1 : label is "soft_lutpair23";
begin
  GPIO_xferAck_i <= \^gpio_xferack_i\;
  gpio_xferAck_Reg <= \^gpio_xferack_reg\;
\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg[31]_0\,
      Q => \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\,
      R => '0'
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(0),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(10),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(11),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(12),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(13),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(14),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(15),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(16),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(17),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(18),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(19),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(1),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(20),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(21),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(22),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(23),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(24),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(25),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(26),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(27),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(28),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(29),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(2),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(30),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"EFFF"
    )
        port map (
      I0 => \^gpio_xferack_i\,
      I1 => \^gpio_xferack_reg\,
      I2 => bus2ip_cs(0),
      I3 => bus2ip_rnw,
      O => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(31),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(3),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(4),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(5),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(6),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(7),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(8),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.Read_Reg2_In\(9),
      Q => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\,
      R => Read_Reg_Rst
    );
\Dual.INPUT_DOUBLE_REGS4\: entity work.c6v_return_state_gpio_0_xpm_cdc_array_single
     port map (
      dest_clk => s_axi_aclk,
      dest_out(0) => gpio_io_i_d2(0),
      src_clk => '0',
      src_in(0) => gpio_io_i(0)
    );
\Dual.INPUT_DOUBLE_REGS5\: entity work.\c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1\
     port map (
      dest_clk => s_axi_aclk,
      dest_out(31) => \Dual.gpio2_io_i_d2\(0),
      dest_out(30) => \Dual.gpio2_io_i_d2\(1),
      dest_out(29) => \Dual.gpio2_io_i_d2\(2),
      dest_out(28) => \Dual.gpio2_io_i_d2\(3),
      dest_out(27) => \Dual.gpio2_io_i_d2\(4),
      dest_out(26) => \Dual.gpio2_io_i_d2\(5),
      dest_out(25) => \Dual.gpio2_io_i_d2\(6),
      dest_out(24) => \Dual.gpio2_io_i_d2\(7),
      dest_out(23) => \Dual.gpio2_io_i_d2\(8),
      dest_out(22) => \Dual.gpio2_io_i_d2\(9),
      dest_out(21) => \Dual.gpio2_io_i_d2\(10),
      dest_out(20) => \Dual.gpio2_io_i_d2\(11),
      dest_out(19) => \Dual.gpio2_io_i_d2\(12),
      dest_out(18) => \Dual.gpio2_io_i_d2\(13),
      dest_out(17) => \Dual.gpio2_io_i_d2\(14),
      dest_out(16) => \Dual.gpio2_io_i_d2\(15),
      dest_out(15) => \Dual.gpio2_io_i_d2\(16),
      dest_out(14) => \Dual.gpio2_io_i_d2\(17),
      dest_out(13) => \Dual.gpio2_io_i_d2\(18),
      dest_out(12) => \Dual.gpio2_io_i_d2\(19),
      dest_out(11) => \Dual.gpio2_io_i_d2\(20),
      dest_out(10) => \Dual.gpio2_io_i_d2\(21),
      dest_out(9) => \Dual.gpio2_io_i_d2\(22),
      dest_out(8) => \Dual.gpio2_io_i_d2\(23),
      dest_out(7) => \Dual.gpio2_io_i_d2\(24),
      dest_out(6) => \Dual.gpio2_io_i_d2\(25),
      dest_out(5) => \Dual.gpio2_io_i_d2\(26),
      dest_out(4) => \Dual.gpio2_io_i_d2\(27),
      dest_out(3) => \Dual.gpio2_io_i_d2\(28),
      dest_out(2) => \Dual.gpio2_io_i_d2\(29),
      dest_out(1) => \Dual.gpio2_io_i_d2\(30),
      dest_out(0) => \Dual.gpio2_io_i_d2\(31),
      src_clk => '0',
      src_in(31 downto 0) => gpio2_io_i(31 downto 0)
    );
\Dual.gpio2_Data_In_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(0),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(31),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(10),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(21),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(11),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(20),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(12),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(19),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(13),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(18),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(14),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(17),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(15),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(16),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(16),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(15),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(17),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(14),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(18),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(13),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(19),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(12),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(1),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(30),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(20),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(11),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(21),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(10),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(22),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(9),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(23),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(8),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(24),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(7),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(25),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(6),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(26),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(5),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(27),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(4),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(28),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(3),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(29),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(2),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(2),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(29),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(30),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(1),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(31),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(0),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(3),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(28),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(4),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(27),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(5),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(26),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(6),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(25),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(7),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(24),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(8),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(23),
      R => '0'
    );
\Dual.gpio2_Data_In_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio2_io_i_d2\(9),
      Q => \Dual.gpio2_Data_In_reg[0]_0\(22),
      R => '0'
    );
\Dual.gpio2_OE_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(31),
      Q => Q(31),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[10]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(21),
      Q => Q(21),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[11]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(20),
      Q => Q(20),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[12]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(19),
      Q => Q(19),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[13]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(18),
      Q => Q(18),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[14]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(17),
      Q => Q(17),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[15]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(16),
      Q => Q(16),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[16]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(15),
      Q => Q(15),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[17]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(14),
      Q => Q(14),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[18]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(13),
      Q => Q(13),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[19]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(12),
      Q => Q(12),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[1]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(30),
      Q => Q(30),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[20]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(11),
      Q => Q(11),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[21]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(10),
      Q => Q(10),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[22]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(9),
      Q => Q(9),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[23]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(8),
      Q => Q(8),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[24]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(7),
      Q => Q(7),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[25]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(6),
      Q => Q(6),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[26]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(5),
      Q => Q(5),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[27]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(4),
      Q => Q(4),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[28]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(3),
      Q => Q(3),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[29]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(2),
      Q => Q(2),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[2]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(29),
      Q => Q(29),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[30]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(1),
      Q => Q(1),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[31]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(0),
      Q => Q(0),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[3]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(28),
      Q => Q(28),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[4]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(27),
      Q => Q(27),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[5]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(26),
      Q => Q(26),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[6]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(25),
      Q => Q(25),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[7]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(24),
      Q => Q(24),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[8]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(23),
      Q => Q(23),
      S => bus2ip_reset
    );
\Dual.gpio2_OE_reg[9]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => E(0),
      D => D(22),
      Q => Q(22),
      S => bus2ip_reset
    );
\Dual.gpio_Data_In_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => gpio_io_i_d2(0),
      Q => gpio_Data_In(0),
      R => '0'
    );
\Dual.gpio_OE_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \Dual.gpio_OE_reg[0]_1\,
      Q => \Dual.gpio_OE_reg[0]_0\,
      S => bus2ip_reset
    );
gpio_xferAck_Reg_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \^gpio_xferack_i\,
      Q => \^gpio_xferack_reg\,
      R => bus2ip_reset
    );
iGPIO_xferAck_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"04"
    )
        port map (
      I0 => \^gpio_xferack_reg\,
      I1 => bus2ip_cs(0),
      I2 => \^gpio_xferack_i\,
      O => iGPIO_xferAck
    );
iGPIO_xferAck_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => iGPIO_xferAck,
      Q => \^gpio_xferack_i\,
      R => bus2ip_reset
    );
ip2bus_rdack_i_D1_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^gpio_xferack_i\,
      I1 => bus2ip_rnw,
      O => ip2bus_rdack_i
    );
ip2bus_wrack_i_D1_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \^gpio_xferack_i\,
      I1 => bus2ip_rnw,
      O => ip2bus_wrack_i
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_return_state_gpio_0_slave_attachment is
  port (
    SR : out STD_LOGIC_VECTOR ( 0 to 0 );
    bus2ip_rnw_i_reg_0 : out STD_LOGIC;
    s_axi_rvalid_i_reg_0 : out STD_LOGIC;
    s_axi_bvalid_i_reg_0 : out STD_LOGIC;
    \MEM_DECODE_GEN[0].cs_out_i_reg[0]\ : out STD_LOGIC;
    \Dual.gpio_Data_In_reg[0]\ : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 31 downto 0 );
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    \Dual.Read_Reg2_In\ : out STD_LOGIC_VECTOR ( 0 to 31 );
    ip2bus_rdack_i_D1_reg : out STD_LOGIC;
    ip2bus_wrack_i_D1_reg : out STD_LOGIC;
    s_axi_wdata_0_sp_1 : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_aclk : in STD_LOGIC;
    s_axi_arvalid : in STD_LOGIC;
    gpio_Data_In : in STD_LOGIC_VECTOR ( 0 to 0 );
    \Dual.gpio_OE_reg[0]\ : in STD_LOGIC;
    gpio_xferAck_Reg : in STD_LOGIC;
    GPIO_xferAck_i : in STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    Q : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\ : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rready : in STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awvalid : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    \s_axi_rdata_i_reg[31]_0\ : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\ : in STD_LOGIC;
    ip2bus_rdack_i_D1 : in STD_LOGIC;
    ip2bus_wrack_i_D1 : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 2 downto 0 )
  );
end c6v_return_state_gpio_0_slave_attachment;

architecture STRUCTURE of c6v_return_state_gpio_0_slave_attachment is
  signal \FSM_onehot_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state[2]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state[3]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state_reg_n_0_[0]\ : STD_LOGIC;
  signal \FSM_onehot_state_reg_n_0_[3]\ : STD_LOGIC;
  signal \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^sr\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal bus2ip_addr : STD_LOGIC_VECTOR ( 0 to 6 );
  signal \bus2ip_addr_i[8]_i_1_n_0\ : STD_LOGIC;
  signal \^bus2ip_rnw_i_reg_0\ : STD_LOGIC;
  signal clear : STD_LOGIC;
  signal \^ip2bus_rdack_i_d1_reg\ : STD_LOGIC;
  signal \^ip2bus_wrack_i_d1_reg\ : STD_LOGIC;
  signal is_read_i_1_n_0 : STD_LOGIC;
  signal is_read_reg_n_0 : STD_LOGIC;
  signal is_write_i_1_n_0 : STD_LOGIC;
  signal is_write_i_2_n_0 : STD_LOGIC;
  signal is_write_reg_n_0 : STD_LOGIC;
  signal p_1_in : STD_LOGIC_VECTOR ( 8 downto 2 );
  signal p_5_in : STD_LOGIC;
  signal plusOp : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal rst_i_1_n_0 : STD_LOGIC;
  signal s_axi_bresp_i : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s_axi_bvalid_i_i_1_n_0 : STD_LOGIC;
  signal \^s_axi_bvalid_i_reg_0\ : STD_LOGIC;
  signal s_axi_rresp_i : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s_axi_rvalid_i_i_1_n_0 : STD_LOGIC;
  signal \^s_axi_rvalid_i_reg_0\ : STD_LOGIC;
  signal s_axi_wdata_0_sn_1 : STD_LOGIC;
  signal start2 : STD_LOGIC;
  signal start2_i_1_n_0 : STD_LOGIC;
  signal \state1__2\ : STD_LOGIC;
  signal \state[0]_i_1_n_0\ : STD_LOGIC;
  signal \state[1]_i_1_n_0\ : STD_LOGIC;
  signal \state_reg_n_0_[0]\ : STD_LOGIC;
  signal \state_reg_n_0_[1]\ : STD_LOGIC;
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[0]\ : label is "iSTATE:0010,iSTATE0:0100,iSTATE1:1000,iSTATE2:0001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[1]\ : label is "iSTATE:0010,iSTATE0:0100,iSTATE1:1000,iSTATE2:0001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[2]\ : label is "iSTATE:0010,iSTATE0:0100,iSTATE1:1000,iSTATE2:0001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[3]\ : label is "iSTATE:0010,iSTATE0:0100,iSTATE1:1000,iSTATE2:0001";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \INCLUDE_DPHASE_TIMER.dpto_cnt[0]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \INCLUDE_DPHASE_TIMER.dpto_cnt[1]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \INCLUDE_DPHASE_TIMER.dpto_cnt[2]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \INCLUDE_DPHASE_TIMER.dpto_cnt[3]_i_2\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \bus2ip_addr_i[3]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \bus2ip_addr_i[8]_i_2\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of start2_i_1 : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \state[1]_i_2\ : label is "soft_lutpair19";
begin
  SR(0) <= \^sr\(0);
  bus2ip_rnw_i_reg_0 <= \^bus2ip_rnw_i_reg_0\;
  ip2bus_rdack_i_D1_reg <= \^ip2bus_rdack_i_d1_reg\;
  ip2bus_wrack_i_D1_reg <= \^ip2bus_wrack_i_d1_reg\;
  s_axi_bvalid_i_reg_0 <= \^s_axi_bvalid_i_reg_0\;
  s_axi_rvalid_i_reg_0 <= \^s_axi_rvalid_i_reg_0\;
  s_axi_wdata_0_sp_1 <= s_axi_wdata_0_sn_1;
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(31),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(31),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(0)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3[10]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(21),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(21),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(10)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3[11]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(20),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(20),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(11)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3[12]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(19),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(19),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(12)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3[13]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(18),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(18),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(13)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3[14]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(17),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(17),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(14)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3[15]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(16),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(16),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(15)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3[16]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(15),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(15),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(16)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3[17]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(14),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(14),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(17)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3[18]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(13),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(13),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(18)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3[19]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(12),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(12),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(19)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(30),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(30),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(1)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3[20]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(11),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(11),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(20)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3[21]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(10),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(10),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(21)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3[22]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(9),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(9),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(22)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3[23]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(8),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(8),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(23)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3[24]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(7),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(7),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(24)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3[25]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(6),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(6),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(25)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3[26]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(5),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(5),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(26)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3[27]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(4),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(4),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(27)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3[28]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(3),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(3),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(28)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3[29]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(2),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(2),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(29)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(29),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(29),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(2)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3[30]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(1),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(1),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(30)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3[31]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(0),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(0),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(31)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(28),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(28),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(3)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(27),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(27),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(4)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(26),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(26),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(5)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(25),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(25),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(6)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(24),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(24),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(7)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3[8]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(23),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(23),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(8)
    );
\Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3[9]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0E020000"
    )
        port map (
      I0 => Q(22),
      I1 => bus2ip_addr(6),
      I2 => bus2ip_addr(0),
      I3 => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(22),
      I4 => bus2ip_addr(5),
      O => \Dual.Read_Reg2_In\(9)
    );
\FSM_onehot_state[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF150015001500"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => s_axi_wvalid,
      I2 => s_axi_awvalid,
      I3 => \FSM_onehot_state_reg_n_0_[0]\,
      I4 => \state1__2\,
      I5 => \FSM_onehot_state_reg_n_0_[3]\,
      O => \FSM_onehot_state[0]_i_1_n_0\
    );
\FSM_onehot_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8F88"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => \FSM_onehot_state_reg_n_0_[0]\,
      I2 => \^ip2bus_rdack_i_d1_reg\,
      I3 => s_axi_rresp_i(0),
      O => \FSM_onehot_state[1]_i_1_n_0\
    );
\FSM_onehot_state[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0800FFFF08000800"
    )
        port map (
      I0 => s_axi_wvalid,
      I1 => s_axi_awvalid,
      I2 => s_axi_arvalid,
      I3 => \FSM_onehot_state_reg_n_0_[0]\,
      I4 => \^ip2bus_wrack_i_d1_reg\,
      I5 => s_axi_bresp_i(0),
      O => \FSM_onehot_state[2]_i_1_n_0\
    );
\FSM_onehot_state[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F888F888FFFFF888"
    )
        port map (
      I0 => \^ip2bus_wrack_i_d1_reg\,
      I1 => s_axi_bresp_i(0),
      I2 => s_axi_rresp_i(0),
      I3 => \^ip2bus_rdack_i_d1_reg\,
      I4 => \FSM_onehot_state_reg_n_0_[3]\,
      I5 => \state1__2\,
      O => \FSM_onehot_state[3]_i_1_n_0\
    );
\FSM_onehot_state[3]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => s_axi_bready,
      I1 => \^s_axi_bvalid_i_reg_0\,
      I2 => s_axi_rready,
      I3 => \^s_axi_rvalid_i_reg_0\,
      O => \state1__2\
    );
\FSM_onehot_state_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_onehot_state[0]_i_1_n_0\,
      Q => \FSM_onehot_state_reg_n_0_[0]\,
      S => \^sr\(0)
    );
\FSM_onehot_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_onehot_state[1]_i_1_n_0\,
      Q => s_axi_rresp_i(0),
      R => \^sr\(0)
    );
\FSM_onehot_state_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_onehot_state[2]_i_1_n_0\,
      Q => s_axi_bresp_i(0),
      R => \^sr\(0)
    );
\FSM_onehot_state_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_onehot_state[3]_i_1_n_0\,
      Q => \FSM_onehot_state_reg_n_0_[3]\,
      R => \^sr\(0)
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(0),
      O => plusOp(0)
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(0),
      I1 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(1),
      O => plusOp(1)
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(0),
      I1 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(1),
      I2 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(2),
      O => plusOp(2)
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \state_reg_n_0_[0]\,
      I1 => \state_reg_n_0_[1]\,
      O => clear
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt[3]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(1),
      I1 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(0),
      I2 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(2),
      I3 => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(3),
      O => plusOp(3)
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => plusOp(0),
      Q => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(0),
      R => clear
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => plusOp(1),
      Q => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(1),
      R => clear
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => plusOp(2),
      Q => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(2),
      R => clear
    );
\INCLUDE_DPHASE_TIMER.dpto_cnt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => plusOp(3),
      Q => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(3),
      R => clear
    );
I_DECODER: entity work.c6v_return_state_gpio_0_address_decoder
     port map (
      Bus_RNW_reg_reg_0 => \^bus2ip_rnw_i_reg_0\,
      D(31 downto 0) => D(31 downto 0),
      \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\ => \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\,
      \Dual.gpio2_OE_reg[0]\(2) => bus2ip_addr(0),
      \Dual.gpio2_OE_reg[0]\(1) => bus2ip_addr(5),
      \Dual.gpio2_OE_reg[0]\(0) => bus2ip_addr(6),
      \Dual.gpio_Data_In_reg[0]\ => \Dual.gpio_Data_In_reg[0]\,
      \Dual.gpio_OE_reg[0]\ => \Dual.gpio_OE_reg[0]\,
      E(0) => E(0),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0\(31 downto 0) => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(31 downto 0),
      GPIO_xferAck_i => GPIO_xferAck_i,
      \MEM_DECODE_GEN[0].cs_out_i_reg[0]_0\ => \MEM_DECODE_GEN[0].cs_out_i_reg[0]\,
      Q => start2,
      gpio_Data_In(0) => gpio_Data_In(0),
      gpio_xferAck_Reg => gpio_xferAck_Reg,
      ip2bus_rdack_i_D1 => ip2bus_rdack_i_D1,
      ip2bus_rdack_i_D1_reg => \^ip2bus_rdack_i_d1_reg\,
      ip2bus_wrack_i_D1 => ip2bus_wrack_i_D1,
      ip2bus_wrack_i_D1_reg => \^ip2bus_wrack_i_d1_reg\,
      s_axi_aclk => s_axi_aclk,
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arready => is_read_reg_n_0,
      s_axi_arready_0(3 downto 0) => \INCLUDE_DPHASE_TIMER.dpto_cnt_reg\(3 downto 0),
      s_axi_awready => is_write_reg_n_0,
      s_axi_wdata(31 downto 0) => s_axi_wdata(31 downto 0),
      s_axi_wdata_0_sp_1 => s_axi_wdata_0_sn_1
    );
\bus2ip_addr_i[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_awaddr(0),
      I2 => s_axi_arvalid,
      O => p_1_in(2)
    );
\bus2ip_addr_i[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axi_araddr(1),
      I1 => s_axi_awaddr(1),
      I2 => s_axi_arvalid,
      O => p_1_in(3)
    );
\bus2ip_addr_i[8]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"000000EA"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => s_axi_awvalid,
      I2 => s_axi_wvalid,
      I3 => \state_reg_n_0_[1]\,
      I4 => \state_reg_n_0_[0]\,
      O => \bus2ip_addr_i[8]_i_1_n_0\
    );
\bus2ip_addr_i[8]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"AC"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_awaddr(2),
      I2 => s_axi_arvalid,
      O => p_1_in(8)
    );
\bus2ip_addr_i_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \bus2ip_addr_i[8]_i_1_n_0\,
      D => p_1_in(2),
      Q => bus2ip_addr(6),
      R => \^sr\(0)
    );
\bus2ip_addr_i_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \bus2ip_addr_i[8]_i_1_n_0\,
      D => p_1_in(3),
      Q => bus2ip_addr(5),
      R => \^sr\(0)
    );
\bus2ip_addr_i_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \bus2ip_addr_i[8]_i_1_n_0\,
      D => p_1_in(8),
      Q => bus2ip_addr(0),
      R => \^sr\(0)
    );
bus2ip_rnw_i_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \bus2ip_addr_i[8]_i_1_n_0\,
      D => s_axi_arvalid,
      Q => \^bus2ip_rnw_i_reg_0\,
      R => \^sr\(0)
    );
is_read_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"8BBB8888"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => \FSM_onehot_state_reg_n_0_[0]\,
      I2 => \state1__2\,
      I3 => \FSM_onehot_state_reg_n_0_[3]\,
      I4 => is_read_reg_n_0,
      O => is_read_i_1_n_0
    );
is_read_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => is_read_i_1_n_0,
      Q => is_read_reg_n_0,
      R => \^sr\(0)
    );
is_write_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2000FFFF20000000"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => s_axi_arvalid,
      I2 => s_axi_awvalid,
      I3 => s_axi_wvalid,
      I4 => is_write_i_2_n_0,
      I5 => is_write_reg_n_0,
      O => is_write_i_1_n_0
    );
is_write_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFEAEAEAAAAAAAAA"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => s_axi_bready,
      I2 => \^s_axi_bvalid_i_reg_0\,
      I3 => s_axi_rready,
      I4 => \^s_axi_rvalid_i_reg_0\,
      I5 => \FSM_onehot_state_reg_n_0_[3]\,
      O => is_write_i_2_n_0
    );
is_write_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => is_write_i_1_n_0,
      Q => is_write_reg_n_0,
      R => \^sr\(0)
    );
rst_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s_axi_aresetn,
      O => rst_i_1_n_0
    );
rst_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => rst_i_1_n_0,
      Q => \^sr\(0),
      R => '0'
    );
s_axi_bvalid_i_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"08FF0808"
    )
        port map (
      I0 => \^ip2bus_wrack_i_d1_reg\,
      I1 => \state_reg_n_0_[1]\,
      I2 => \state_reg_n_0_[0]\,
      I3 => s_axi_bready,
      I4 => \^s_axi_bvalid_i_reg_0\,
      O => s_axi_bvalid_i_i_1_n_0
    );
s_axi_bvalid_i_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => s_axi_bvalid_i_i_1_n_0,
      Q => \^s_axi_bvalid_i_reg_0\,
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(0),
      Q => s_axi_rdata(0),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(10),
      Q => s_axi_rdata(10),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(11),
      Q => s_axi_rdata(11),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(12),
      Q => s_axi_rdata(12),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(13),
      Q => s_axi_rdata(13),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(14),
      Q => s_axi_rdata(14),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(15),
      Q => s_axi_rdata(15),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(16),
      Q => s_axi_rdata(16),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(17),
      Q => s_axi_rdata(17),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(18),
      Q => s_axi_rdata(18),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(19),
      Q => s_axi_rdata(19),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(1),
      Q => s_axi_rdata(1),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(20),
      Q => s_axi_rdata(20),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(21),
      Q => s_axi_rdata(21),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(22),
      Q => s_axi_rdata(22),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(23),
      Q => s_axi_rdata(23),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(24),
      Q => s_axi_rdata(24),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(25),
      Q => s_axi_rdata(25),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(26),
      Q => s_axi_rdata(26),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(27),
      Q => s_axi_rdata(27),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(28),
      Q => s_axi_rdata(28),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(29),
      Q => s_axi_rdata(29),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(2),
      Q => s_axi_rdata(2),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(30),
      Q => s_axi_rdata(30),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(31),
      Q => s_axi_rdata(31),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(3),
      Q => s_axi_rdata(3),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(4),
      Q => s_axi_rdata(4),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(5),
      Q => s_axi_rdata(5),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(6),
      Q => s_axi_rdata(6),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(7),
      Q => s_axi_rdata(7),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(8),
      Q => s_axi_rdata(8),
      R => \^sr\(0)
    );
\s_axi_rdata_i_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => s_axi_rresp_i(0),
      D => \s_axi_rdata_i_reg[31]_0\(9),
      Q => s_axi_rdata(9),
      R => \^sr\(0)
    );
s_axi_rvalid_i_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"08FF0808"
    )
        port map (
      I0 => \^ip2bus_rdack_i_d1_reg\,
      I1 => \state_reg_n_0_[0]\,
      I2 => \state_reg_n_0_[1]\,
      I3 => s_axi_rready,
      I4 => \^s_axi_rvalid_i_reg_0\,
      O => s_axi_rvalid_i_i_1_n_0
    );
s_axi_rvalid_i_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => s_axi_rvalid_i_i_1_n_0,
      Q => \^s_axi_rvalid_i_reg_0\,
      R => \^sr\(0)
    );
start2_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"000000F8"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => s_axi_wvalid,
      I2 => s_axi_arvalid,
      I3 => \state_reg_n_0_[1]\,
      I4 => \state_reg_n_0_[0]\,
      O => start2_i_1_n_0
    );
start2_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => start2_i_1_n_0,
      Q => start2,
      R => \^sr\(0)
    );
\state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0FCAFFCA"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => \^ip2bus_wrack_i_d1_reg\,
      I2 => \state_reg_n_0_[1]\,
      I3 => \state_reg_n_0_[0]\,
      I4 => \state1__2\,
      O => \state[0]_i_1_n_0\
    );
\state[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55FFFF0C5500FF0C"
    )
        port map (
      I0 => \state1__2\,
      I1 => p_5_in,
      I2 => s_axi_arvalid,
      I3 => \state_reg_n_0_[1]\,
      I4 => \state_reg_n_0_[0]\,
      I5 => \^ip2bus_rdack_i_d1_reg\,
      O => \state[1]_i_1_n_0\
    );
\state[1]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => s_axi_wvalid,
      O => p_5_in
    );
\state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \state[0]_i_1_n_0\,
      Q => \state_reg_n_0_[0]\,
      R => \^sr\(0)
    );
\state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \state[1]_i_1_n_0\,
      Q => \state_reg_n_0_[1]\,
      R => \^sr\(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_return_state_gpio_0_axi_lite_ipif is
  port (
    bus2ip_reset : out STD_LOGIC;
    bus2ip_rnw : out STD_LOGIC;
    s_axi_rvalid_i_reg : out STD_LOGIC;
    s_axi_bvalid_i_reg : out STD_LOGIC;
    bus2ip_cs : out STD_LOGIC_VECTOR ( 0 to 0 );
    \Dual.gpio_Data_In_reg[0]\ : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 31 downto 0 );
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    \Dual.Read_Reg2_In\ : out STD_LOGIC_VECTOR ( 0 to 31 );
    ip2bus_rdack_i_D1_reg : out STD_LOGIC;
    ip2bus_wrack_i_D1_reg : out STD_LOGIC;
    s_axi_wdata_0_sp_1 : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_aclk : in STD_LOGIC;
    s_axi_arvalid : in STD_LOGIC;
    gpio_Data_In : in STD_LOGIC_VECTOR ( 0 to 0 );
    \Dual.gpio_OE_reg[0]\ : in STD_LOGIC;
    gpio_xferAck_Reg : in STD_LOGIC;
    GPIO_xferAck_i : in STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    Q : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\ : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rready : in STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awvalid : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    \s_axi_rdata_i_reg[31]\ : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\ : in STD_LOGIC;
    \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\ : in STD_LOGIC;
    ip2bus_rdack_i_D1 : in STD_LOGIC;
    ip2bus_wrack_i_D1 : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 2 downto 0 )
  );
end c6v_return_state_gpio_0_axi_lite_ipif;

architecture STRUCTURE of c6v_return_state_gpio_0_axi_lite_ipif is
  signal s_axi_wdata_0_sn_1 : STD_LOGIC;
begin
  s_axi_wdata_0_sp_1 <= s_axi_wdata_0_sn_1;
I_SLAVE_ATTACHMENT: entity work.c6v_return_state_gpio_0_slave_attachment
     port map (
      D(31 downto 0) => D(31 downto 0),
      \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\ => \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(31 downto 0) => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(31 downto 0),
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\,
      \Dual.Read_Reg2_In\(0 to 31) => \Dual.Read_Reg2_In\(0 to 31),
      \Dual.gpio_Data_In_reg[0]\ => \Dual.gpio_Data_In_reg[0]\,
      \Dual.gpio_OE_reg[0]\ => \Dual.gpio_OE_reg[0]\,
      E(0) => E(0),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(31 downto 0) => \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(31 downto 0),
      GPIO_xferAck_i => GPIO_xferAck_i,
      \MEM_DECODE_GEN[0].cs_out_i_reg[0]\ => bus2ip_cs(0),
      Q(31 downto 0) => Q(31 downto 0),
      SR(0) => bus2ip_reset,
      bus2ip_rnw_i_reg_0 => bus2ip_rnw,
      gpio_Data_In(0) => gpio_Data_In(0),
      gpio_xferAck_Reg => gpio_xferAck_Reg,
      ip2bus_rdack_i_D1 => ip2bus_rdack_i_D1,
      ip2bus_rdack_i_D1_reg => ip2bus_rdack_i_D1_reg,
      ip2bus_wrack_i_D1 => ip2bus_wrack_i_D1,
      ip2bus_wrack_i_D1_reg => ip2bus_wrack_i_D1_reg,
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(2 downto 0) => s_axi_araddr(2 downto 0),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(2 downto 0) => s_axi_awaddr(2 downto 0),
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bready => s_axi_bready,
      s_axi_bvalid_i_reg_0 => s_axi_bvalid_i_reg,
      s_axi_rdata(31 downto 0) => s_axi_rdata(31 downto 0),
      \s_axi_rdata_i_reg[31]_0\(31 downto 0) => \s_axi_rdata_i_reg[31]\(31 downto 0),
      s_axi_rready => s_axi_rready,
      s_axi_rvalid_i_reg_0 => s_axi_rvalid_i_reg,
      s_axi_wdata(31 downto 0) => s_axi_wdata(31 downto 0),
      s_axi_wdata_0_sp_1 => s_axi_wdata_0_sn_1,
      s_axi_wvalid => s_axi_wvalid
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_return_state_gpio_0_axi_gpio is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    ip2intc_irpt : out STD_LOGIC;
    gpio_io_i : in STD_LOGIC_VECTOR ( 0 to 0 );
    gpio_io_o : out STD_LOGIC_VECTOR ( 0 to 0 );
    gpio_io_t : out STD_LOGIC_VECTOR ( 0 to 0 );
    gpio2_io_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    gpio2_io_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    gpio2_io_t : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  attribute C_ALL_INPUTS : integer;
  attribute C_ALL_INPUTS of c6v_return_state_gpio_0_axi_gpio : entity is 1;
  attribute C_ALL_INPUTS_2 : integer;
  attribute C_ALL_INPUTS_2 of c6v_return_state_gpio_0_axi_gpio : entity is 1;
  attribute C_ALL_OUTPUTS : integer;
  attribute C_ALL_OUTPUTS of c6v_return_state_gpio_0_axi_gpio : entity is 0;
  attribute C_ALL_OUTPUTS_2 : integer;
  attribute C_ALL_OUTPUTS_2 of c6v_return_state_gpio_0_axi_gpio : entity is 0;
  attribute C_DOUT_DEFAULT : string;
  attribute C_DOUT_DEFAULT of c6v_return_state_gpio_0_axi_gpio : entity is "32'b00000000000000000000000000000000";
  attribute C_DOUT_DEFAULT_2 : string;
  attribute C_DOUT_DEFAULT_2 of c6v_return_state_gpio_0_axi_gpio : entity is "32'b00000000000000000000000000000000";
  attribute C_FAMILY : string;
  attribute C_FAMILY of c6v_return_state_gpio_0_axi_gpio : entity is "zynq";
  attribute C_GPIO2_WIDTH : integer;
  attribute C_GPIO2_WIDTH of c6v_return_state_gpio_0_axi_gpio : entity is 32;
  attribute C_GPIO_WIDTH : integer;
  attribute C_GPIO_WIDTH of c6v_return_state_gpio_0_axi_gpio : entity is 1;
  attribute C_INTERRUPT_PRESENT : integer;
  attribute C_INTERRUPT_PRESENT of c6v_return_state_gpio_0_axi_gpio : entity is 0;
  attribute C_IS_DUAL : integer;
  attribute C_IS_DUAL of c6v_return_state_gpio_0_axi_gpio : entity is 1;
  attribute C_S_AXI_ADDR_WIDTH : integer;
  attribute C_S_AXI_ADDR_WIDTH of c6v_return_state_gpio_0_axi_gpio : entity is 9;
  attribute C_S_AXI_DATA_WIDTH : integer;
  attribute C_S_AXI_DATA_WIDTH of c6v_return_state_gpio_0_axi_gpio : entity is 32;
  attribute C_TRI_DEFAULT : string;
  attribute C_TRI_DEFAULT of c6v_return_state_gpio_0_axi_gpio : entity is "32'b11111111111111111111111111111111";
  attribute C_TRI_DEFAULT_2 : string;
  attribute C_TRI_DEFAULT_2 of c6v_return_state_gpio_0_axi_gpio : entity is "32'b11111111111111111111111111111111";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of c6v_return_state_gpio_0_axi_gpio : entity is "yes";
  attribute ip_group : string;
  attribute ip_group of c6v_return_state_gpio_0_axi_gpio : entity is "LOGICORE";
end c6v_return_state_gpio_0_axi_gpio;

architecture STRUCTURE of c6v_return_state_gpio_0_axi_gpio is
  signal \<const0>\ : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_10 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_11 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_12 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_13 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_14 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_15 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_16 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_17 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_18 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_19 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_20 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_21 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_22 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_23 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_24 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_25 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_26 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_27 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_28 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_29 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_30 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_31 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_32 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_33 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_34 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_35 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_36 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_37 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_38 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_5 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_7 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_73 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_8 : STD_LOGIC;
  signal AXI_LITE_IPIF_I_n_9 : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\ : STD_LOGIC;
  signal \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\ : STD_LOGIC;
  signal \Dual.Read_Reg2_In\ : STD_LOGIC_VECTOR ( 0 to 31 );
  signal \Dual.gpio2_Data_In\ : STD_LOGIC_VECTOR ( 0 to 31 );
  signal GPIO_xferAck_i : STD_LOGIC;
  signal bus2ip_cs : STD_LOGIC_VECTOR ( 0 to 0 );
  signal bus2ip_reset : STD_LOGIC;
  signal bus2ip_rnw : STD_LOGIC;
  signal gpio_Data_In : STD_LOGIC_VECTOR ( 0 to 0 );
  signal gpio_core_1_n_36 : STD_LOGIC;
  signal gpio_core_1_n_39 : STD_LOGIC;
  signal gpio_core_1_n_40 : STD_LOGIC;
  signal gpio_core_1_n_41 : STD_LOGIC;
  signal gpio_core_1_n_42 : STD_LOGIC;
  signal gpio_core_1_n_43 : STD_LOGIC;
  signal gpio_core_1_n_44 : STD_LOGIC;
  signal gpio_core_1_n_45 : STD_LOGIC;
  signal gpio_core_1_n_46 : STD_LOGIC;
  signal gpio_core_1_n_47 : STD_LOGIC;
  signal gpio_core_1_n_48 : STD_LOGIC;
  signal gpio_core_1_n_49 : STD_LOGIC;
  signal gpio_core_1_n_50 : STD_LOGIC;
  signal gpio_core_1_n_51 : STD_LOGIC;
  signal gpio_core_1_n_52 : STD_LOGIC;
  signal gpio_core_1_n_53 : STD_LOGIC;
  signal gpio_core_1_n_54 : STD_LOGIC;
  signal gpio_core_1_n_55 : STD_LOGIC;
  signal gpio_core_1_n_56 : STD_LOGIC;
  signal gpio_core_1_n_57 : STD_LOGIC;
  signal gpio_core_1_n_58 : STD_LOGIC;
  signal gpio_core_1_n_59 : STD_LOGIC;
  signal gpio_core_1_n_60 : STD_LOGIC;
  signal gpio_core_1_n_61 : STD_LOGIC;
  signal gpio_core_1_n_62 : STD_LOGIC;
  signal gpio_core_1_n_63 : STD_LOGIC;
  signal gpio_core_1_n_64 : STD_LOGIC;
  signal gpio_core_1_n_65 : STD_LOGIC;
  signal gpio_core_1_n_66 : STD_LOGIC;
  signal gpio_core_1_n_67 : STD_LOGIC;
  signal gpio_core_1_n_68 : STD_LOGIC;
  signal gpio_core_1_n_69 : STD_LOGIC;
  signal gpio_core_1_n_70 : STD_LOGIC;
  signal gpio_xferAck_Reg : STD_LOGIC;
  signal ip2bus_data : STD_LOGIC_VECTOR ( 0 to 31 );
  signal ip2bus_data_i_D1 : STD_LOGIC_VECTOR ( 0 to 31 );
  signal ip2bus_rdack_i : STD_LOGIC;
  signal ip2bus_rdack_i_D1 : STD_LOGIC;
  signal ip2bus_wrack_i : STD_LOGIC;
  signal ip2bus_wrack_i_D1 : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
  signal \^s_axi_awready\ : STD_LOGIC;
  attribute sigis : string;
  attribute sigis of ip2intc_irpt : signal is "INTR_LEVEL_HIGH";
  attribute sigis of s_axi_aclk : signal is "Clk";
  attribute sigis of s_axi_aresetn : signal is "Rst";
begin
  gpio2_io_o(31) <= \<const0>\;
  gpio2_io_o(30) <= \<const0>\;
  gpio2_io_o(29) <= \<const0>\;
  gpio2_io_o(28) <= \<const0>\;
  gpio2_io_o(27) <= \<const0>\;
  gpio2_io_o(26) <= \<const0>\;
  gpio2_io_o(25) <= \<const0>\;
  gpio2_io_o(24) <= \<const0>\;
  gpio2_io_o(23) <= \<const0>\;
  gpio2_io_o(22) <= \<const0>\;
  gpio2_io_o(21) <= \<const0>\;
  gpio2_io_o(20) <= \<const0>\;
  gpio2_io_o(19) <= \<const0>\;
  gpio2_io_o(18) <= \<const0>\;
  gpio2_io_o(17) <= \<const0>\;
  gpio2_io_o(16) <= \<const0>\;
  gpio2_io_o(15) <= \<const0>\;
  gpio2_io_o(14) <= \<const0>\;
  gpio2_io_o(13) <= \<const0>\;
  gpio2_io_o(12) <= \<const0>\;
  gpio2_io_o(11) <= \<const0>\;
  gpio2_io_o(10) <= \<const0>\;
  gpio2_io_o(9) <= \<const0>\;
  gpio2_io_o(8) <= \<const0>\;
  gpio2_io_o(7) <= \<const0>\;
  gpio2_io_o(6) <= \<const0>\;
  gpio2_io_o(5) <= \<const0>\;
  gpio2_io_o(4) <= \<const0>\;
  gpio2_io_o(3) <= \<const0>\;
  gpio2_io_o(2) <= \<const0>\;
  gpio2_io_o(1) <= \<const0>\;
  gpio2_io_o(0) <= \<const0>\;
  gpio2_io_t(31) <= \<const0>\;
  gpio2_io_t(30) <= \<const0>\;
  gpio2_io_t(29) <= \<const0>\;
  gpio2_io_t(28) <= \<const0>\;
  gpio2_io_t(27) <= \<const0>\;
  gpio2_io_t(26) <= \<const0>\;
  gpio2_io_t(25) <= \<const0>\;
  gpio2_io_t(24) <= \<const0>\;
  gpio2_io_t(23) <= \<const0>\;
  gpio2_io_t(22) <= \<const0>\;
  gpio2_io_t(21) <= \<const0>\;
  gpio2_io_t(20) <= \<const0>\;
  gpio2_io_t(19) <= \<const0>\;
  gpio2_io_t(18) <= \<const0>\;
  gpio2_io_t(17) <= \<const0>\;
  gpio2_io_t(16) <= \<const0>\;
  gpio2_io_t(15) <= \<const0>\;
  gpio2_io_t(14) <= \<const0>\;
  gpio2_io_t(13) <= \<const0>\;
  gpio2_io_t(12) <= \<const0>\;
  gpio2_io_t(11) <= \<const0>\;
  gpio2_io_t(10) <= \<const0>\;
  gpio2_io_t(9) <= \<const0>\;
  gpio2_io_t(8) <= \<const0>\;
  gpio2_io_t(7) <= \<const0>\;
  gpio2_io_t(6) <= \<const0>\;
  gpio2_io_t(5) <= \<const0>\;
  gpio2_io_t(4) <= \<const0>\;
  gpio2_io_t(3) <= \<const0>\;
  gpio2_io_t(2) <= \<const0>\;
  gpio2_io_t(1) <= \<const0>\;
  gpio2_io_t(0) <= \<const0>\;
  gpio_io_o(0) <= \<const0>\;
  gpio_io_t(0) <= \<const0>\;
  ip2intc_irpt <= \<const0>\;
  s_axi_awready <= \^s_axi_awready\;
  s_axi_bresp(1) <= \<const0>\;
  s_axi_bresp(0) <= \<const0>\;
  s_axi_rresp(1) <= \<const0>\;
  s_axi_rresp(0) <= \<const0>\;
  s_axi_wready <= \^s_axi_awready\;
AXI_LITE_IPIF_I: entity work.c6v_return_state_gpio_0_axi_lite_ipif
     port map (
      D(31) => p_0_in,
      D(30) => AXI_LITE_IPIF_I_n_7,
      D(29) => AXI_LITE_IPIF_I_n_8,
      D(28) => AXI_LITE_IPIF_I_n_9,
      D(27) => AXI_LITE_IPIF_I_n_10,
      D(26) => AXI_LITE_IPIF_I_n_11,
      D(25) => AXI_LITE_IPIF_I_n_12,
      D(24) => AXI_LITE_IPIF_I_n_13,
      D(23) => AXI_LITE_IPIF_I_n_14,
      D(22) => AXI_LITE_IPIF_I_n_15,
      D(21) => AXI_LITE_IPIF_I_n_16,
      D(20) => AXI_LITE_IPIF_I_n_17,
      D(19) => AXI_LITE_IPIF_I_n_18,
      D(18) => AXI_LITE_IPIF_I_n_19,
      D(17) => AXI_LITE_IPIF_I_n_20,
      D(16) => AXI_LITE_IPIF_I_n_21,
      D(15) => AXI_LITE_IPIF_I_n_22,
      D(14) => AXI_LITE_IPIF_I_n_23,
      D(13) => AXI_LITE_IPIF_I_n_24,
      D(12) => AXI_LITE_IPIF_I_n_25,
      D(11) => AXI_LITE_IPIF_I_n_26,
      D(10) => AXI_LITE_IPIF_I_n_27,
      D(9) => AXI_LITE_IPIF_I_n_28,
      D(8) => AXI_LITE_IPIF_I_n_29,
      D(7) => AXI_LITE_IPIF_I_n_30,
      D(6) => AXI_LITE_IPIF_I_n_31,
      D(5) => AXI_LITE_IPIF_I_n_32,
      D(4) => AXI_LITE_IPIF_I_n_33,
      D(3) => AXI_LITE_IPIF_I_n_34,
      D(2) => AXI_LITE_IPIF_I_n_35,
      D(1) => AXI_LITE_IPIF_I_n_36,
      D(0) => AXI_LITE_IPIF_I_n_37,
      \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\ => \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(31) => gpio_core_1_n_39,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(30) => gpio_core_1_n_40,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(29) => gpio_core_1_n_41,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(28) => gpio_core_1_n_42,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(27) => gpio_core_1_n_43,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(26) => gpio_core_1_n_44,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(25) => gpio_core_1_n_45,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(24) => gpio_core_1_n_46,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(23) => gpio_core_1_n_47,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(22) => gpio_core_1_n_48,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(21) => gpio_core_1_n_49,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(20) => gpio_core_1_n_50,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(19) => gpio_core_1_n_51,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(18) => gpio_core_1_n_52,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(17) => gpio_core_1_n_53,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(16) => gpio_core_1_n_54,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(15) => gpio_core_1_n_55,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(14) => gpio_core_1_n_56,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(13) => gpio_core_1_n_57,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(12) => gpio_core_1_n_58,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(11) => gpio_core_1_n_59,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(10) => gpio_core_1_n_60,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(9) => gpio_core_1_n_61,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(8) => gpio_core_1_n_62,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(7) => gpio_core_1_n_63,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(6) => gpio_core_1_n_64,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(5) => gpio_core_1_n_65,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(4) => gpio_core_1_n_66,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(3) => gpio_core_1_n_67,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(2) => gpio_core_1_n_68,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(1) => gpio_core_1_n_69,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0]\(0) => gpio_core_1_n_70,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\,
      \Dual.Read_Reg2_In\(0 to 31) => \Dual.Read_Reg2_In\(0 to 31),
      \Dual.gpio_Data_In_reg[0]\ => AXI_LITE_IPIF_I_n_5,
      \Dual.gpio_OE_reg[0]\ => gpio_core_1_n_36,
      E(0) => AXI_LITE_IPIF_I_n_38,
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(31) => ip2bus_data(0),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(30) => ip2bus_data(1),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(29) => ip2bus_data(2),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(28) => ip2bus_data(3),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(27) => ip2bus_data(4),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(26) => ip2bus_data(5),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(25) => ip2bus_data(6),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(24) => ip2bus_data(7),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(23) => ip2bus_data(8),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(22) => ip2bus_data(9),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(21) => ip2bus_data(10),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(20) => ip2bus_data(11),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(19) => ip2bus_data(12),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(18) => ip2bus_data(13),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(17) => ip2bus_data(14),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(16) => ip2bus_data(15),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(15) => ip2bus_data(16),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(14) => ip2bus_data(17),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(13) => ip2bus_data(18),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(12) => ip2bus_data(19),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(11) => ip2bus_data(20),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(10) => ip2bus_data(21),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(9) => ip2bus_data(22),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(8) => ip2bus_data(23),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(7) => ip2bus_data(24),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(6) => ip2bus_data(25),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(5) => ip2bus_data(26),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(4) => ip2bus_data(27),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(3) => ip2bus_data(28),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(2) => ip2bus_data(29),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(1) => ip2bus_data(30),
      \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]\(0) => ip2bus_data(31),
      GPIO_xferAck_i => GPIO_xferAck_i,
      Q(31) => \Dual.gpio2_Data_In\(0),
      Q(30) => \Dual.gpio2_Data_In\(1),
      Q(29) => \Dual.gpio2_Data_In\(2),
      Q(28) => \Dual.gpio2_Data_In\(3),
      Q(27) => \Dual.gpio2_Data_In\(4),
      Q(26) => \Dual.gpio2_Data_In\(5),
      Q(25) => \Dual.gpio2_Data_In\(6),
      Q(24) => \Dual.gpio2_Data_In\(7),
      Q(23) => \Dual.gpio2_Data_In\(8),
      Q(22) => \Dual.gpio2_Data_In\(9),
      Q(21) => \Dual.gpio2_Data_In\(10),
      Q(20) => \Dual.gpio2_Data_In\(11),
      Q(19) => \Dual.gpio2_Data_In\(12),
      Q(18) => \Dual.gpio2_Data_In\(13),
      Q(17) => \Dual.gpio2_Data_In\(14),
      Q(16) => \Dual.gpio2_Data_In\(15),
      Q(15) => \Dual.gpio2_Data_In\(16),
      Q(14) => \Dual.gpio2_Data_In\(17),
      Q(13) => \Dual.gpio2_Data_In\(18),
      Q(12) => \Dual.gpio2_Data_In\(19),
      Q(11) => \Dual.gpio2_Data_In\(20),
      Q(10) => \Dual.gpio2_Data_In\(21),
      Q(9) => \Dual.gpio2_Data_In\(22),
      Q(8) => \Dual.gpio2_Data_In\(23),
      Q(7) => \Dual.gpio2_Data_In\(24),
      Q(6) => \Dual.gpio2_Data_In\(25),
      Q(5) => \Dual.gpio2_Data_In\(26),
      Q(4) => \Dual.gpio2_Data_In\(27),
      Q(3) => \Dual.gpio2_Data_In\(28),
      Q(2) => \Dual.gpio2_Data_In\(29),
      Q(1) => \Dual.gpio2_Data_In\(30),
      Q(0) => \Dual.gpio2_Data_In\(31),
      bus2ip_cs(0) => bus2ip_cs(0),
      bus2ip_reset => bus2ip_reset,
      bus2ip_rnw => bus2ip_rnw,
      gpio_Data_In(0) => gpio_Data_In(0),
      gpio_xferAck_Reg => gpio_xferAck_Reg,
      ip2bus_rdack_i_D1 => ip2bus_rdack_i_D1,
      ip2bus_rdack_i_D1_reg => s_axi_arready,
      ip2bus_wrack_i_D1 => ip2bus_wrack_i_D1,
      ip2bus_wrack_i_D1_reg => \^s_axi_awready\,
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(2) => s_axi_araddr(8),
      s_axi_araddr(1 downto 0) => s_axi_araddr(3 downto 2),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(2) => s_axi_awaddr(8),
      s_axi_awaddr(1 downto 0) => s_axi_awaddr(3 downto 2),
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bready => s_axi_bready,
      s_axi_bvalid_i_reg => s_axi_bvalid,
      s_axi_rdata(31 downto 0) => s_axi_rdata(31 downto 0),
      \s_axi_rdata_i_reg[31]\(31) => ip2bus_data_i_D1(0),
      \s_axi_rdata_i_reg[31]\(30) => ip2bus_data_i_D1(1),
      \s_axi_rdata_i_reg[31]\(29) => ip2bus_data_i_D1(2),
      \s_axi_rdata_i_reg[31]\(28) => ip2bus_data_i_D1(3),
      \s_axi_rdata_i_reg[31]\(27) => ip2bus_data_i_D1(4),
      \s_axi_rdata_i_reg[31]\(26) => ip2bus_data_i_D1(5),
      \s_axi_rdata_i_reg[31]\(25) => ip2bus_data_i_D1(6),
      \s_axi_rdata_i_reg[31]\(24) => ip2bus_data_i_D1(7),
      \s_axi_rdata_i_reg[31]\(23) => ip2bus_data_i_D1(8),
      \s_axi_rdata_i_reg[31]\(22) => ip2bus_data_i_D1(9),
      \s_axi_rdata_i_reg[31]\(21) => ip2bus_data_i_D1(10),
      \s_axi_rdata_i_reg[31]\(20) => ip2bus_data_i_D1(11),
      \s_axi_rdata_i_reg[31]\(19) => ip2bus_data_i_D1(12),
      \s_axi_rdata_i_reg[31]\(18) => ip2bus_data_i_D1(13),
      \s_axi_rdata_i_reg[31]\(17) => ip2bus_data_i_D1(14),
      \s_axi_rdata_i_reg[31]\(16) => ip2bus_data_i_D1(15),
      \s_axi_rdata_i_reg[31]\(15) => ip2bus_data_i_D1(16),
      \s_axi_rdata_i_reg[31]\(14) => ip2bus_data_i_D1(17),
      \s_axi_rdata_i_reg[31]\(13) => ip2bus_data_i_D1(18),
      \s_axi_rdata_i_reg[31]\(12) => ip2bus_data_i_D1(19),
      \s_axi_rdata_i_reg[31]\(11) => ip2bus_data_i_D1(20),
      \s_axi_rdata_i_reg[31]\(10) => ip2bus_data_i_D1(21),
      \s_axi_rdata_i_reg[31]\(9) => ip2bus_data_i_D1(22),
      \s_axi_rdata_i_reg[31]\(8) => ip2bus_data_i_D1(23),
      \s_axi_rdata_i_reg[31]\(7) => ip2bus_data_i_D1(24),
      \s_axi_rdata_i_reg[31]\(6) => ip2bus_data_i_D1(25),
      \s_axi_rdata_i_reg[31]\(5) => ip2bus_data_i_D1(26),
      \s_axi_rdata_i_reg[31]\(4) => ip2bus_data_i_D1(27),
      \s_axi_rdata_i_reg[31]\(3) => ip2bus_data_i_D1(28),
      \s_axi_rdata_i_reg[31]\(2) => ip2bus_data_i_D1(29),
      \s_axi_rdata_i_reg[31]\(1) => ip2bus_data_i_D1(30),
      \s_axi_rdata_i_reg[31]\(0) => ip2bus_data_i_D1(31),
      s_axi_rready => s_axi_rready,
      s_axi_rvalid_i_reg => s_axi_rvalid,
      s_axi_wdata(31 downto 0) => s_axi_wdata(31 downto 0),
      s_axi_wdata_0_sp_1 => AXI_LITE_IPIF_I_n_73,
      s_axi_wvalid => s_axi_wvalid
    );
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
gpio_core_1: entity work.c6v_return_state_gpio_0_GPIO_Core
     port map (
      D(31) => p_0_in,
      D(30) => AXI_LITE_IPIF_I_n_7,
      D(29) => AXI_LITE_IPIF_I_n_8,
      D(28) => AXI_LITE_IPIF_I_n_9,
      D(27) => AXI_LITE_IPIF_I_n_10,
      D(26) => AXI_LITE_IPIF_I_n_11,
      D(25) => AXI_LITE_IPIF_I_n_12,
      D(24) => AXI_LITE_IPIF_I_n_13,
      D(23) => AXI_LITE_IPIF_I_n_14,
      D(22) => AXI_LITE_IPIF_I_n_15,
      D(21) => AXI_LITE_IPIF_I_n_16,
      D(20) => AXI_LITE_IPIF_I_n_17,
      D(19) => AXI_LITE_IPIF_I_n_18,
      D(18) => AXI_LITE_IPIF_I_n_19,
      D(17) => AXI_LITE_IPIF_I_n_20,
      D(16) => AXI_LITE_IPIF_I_n_21,
      D(15) => AXI_LITE_IPIF_I_n_22,
      D(14) => AXI_LITE_IPIF_I_n_23,
      D(13) => AXI_LITE_IPIF_I_n_24,
      D(12) => AXI_LITE_IPIF_I_n_25,
      D(11) => AXI_LITE_IPIF_I_n_26,
      D(10) => AXI_LITE_IPIF_I_n_27,
      D(9) => AXI_LITE_IPIF_I_n_28,
      D(8) => AXI_LITE_IPIF_I_n_29,
      D(7) => AXI_LITE_IPIF_I_n_30,
      D(6) => AXI_LITE_IPIF_I_n_31,
      D(5) => AXI_LITE_IPIF_I_n_32,
      D(4) => AXI_LITE_IPIF_I_n_33,
      D(3) => AXI_LITE_IPIF_I_n_34,
      D(2) => AXI_LITE_IPIF_I_n_35,
      D(1) => AXI_LITE_IPIF_I_n_36,
      D(0) => AXI_LITE_IPIF_I_n_37,
      \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\ => \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg\,
      \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg[31]_0\ => AXI_LITE_IPIF_I_n_5,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg\,
      \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\ => \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg\,
      \Dual.Read_Reg2_In\(0 to 31) => \Dual.Read_Reg2_In\(0 to 31),
      \Dual.gpio2_Data_In_reg[0]_0\(31) => \Dual.gpio2_Data_In\(0),
      \Dual.gpio2_Data_In_reg[0]_0\(30) => \Dual.gpio2_Data_In\(1),
      \Dual.gpio2_Data_In_reg[0]_0\(29) => \Dual.gpio2_Data_In\(2),
      \Dual.gpio2_Data_In_reg[0]_0\(28) => \Dual.gpio2_Data_In\(3),
      \Dual.gpio2_Data_In_reg[0]_0\(27) => \Dual.gpio2_Data_In\(4),
      \Dual.gpio2_Data_In_reg[0]_0\(26) => \Dual.gpio2_Data_In\(5),
      \Dual.gpio2_Data_In_reg[0]_0\(25) => \Dual.gpio2_Data_In\(6),
      \Dual.gpio2_Data_In_reg[0]_0\(24) => \Dual.gpio2_Data_In\(7),
      \Dual.gpio2_Data_In_reg[0]_0\(23) => \Dual.gpio2_Data_In\(8),
      \Dual.gpio2_Data_In_reg[0]_0\(22) => \Dual.gpio2_Data_In\(9),
      \Dual.gpio2_Data_In_reg[0]_0\(21) => \Dual.gpio2_Data_In\(10),
      \Dual.gpio2_Data_In_reg[0]_0\(20) => \Dual.gpio2_Data_In\(11),
      \Dual.gpio2_Data_In_reg[0]_0\(19) => \Dual.gpio2_Data_In\(12),
      \Dual.gpio2_Data_In_reg[0]_0\(18) => \Dual.gpio2_Data_In\(13),
      \Dual.gpio2_Data_In_reg[0]_0\(17) => \Dual.gpio2_Data_In\(14),
      \Dual.gpio2_Data_In_reg[0]_0\(16) => \Dual.gpio2_Data_In\(15),
      \Dual.gpio2_Data_In_reg[0]_0\(15) => \Dual.gpio2_Data_In\(16),
      \Dual.gpio2_Data_In_reg[0]_0\(14) => \Dual.gpio2_Data_In\(17),
      \Dual.gpio2_Data_In_reg[0]_0\(13) => \Dual.gpio2_Data_In\(18),
      \Dual.gpio2_Data_In_reg[0]_0\(12) => \Dual.gpio2_Data_In\(19),
      \Dual.gpio2_Data_In_reg[0]_0\(11) => \Dual.gpio2_Data_In\(20),
      \Dual.gpio2_Data_In_reg[0]_0\(10) => \Dual.gpio2_Data_In\(21),
      \Dual.gpio2_Data_In_reg[0]_0\(9) => \Dual.gpio2_Data_In\(22),
      \Dual.gpio2_Data_In_reg[0]_0\(8) => \Dual.gpio2_Data_In\(23),
      \Dual.gpio2_Data_In_reg[0]_0\(7) => \Dual.gpio2_Data_In\(24),
      \Dual.gpio2_Data_In_reg[0]_0\(6) => \Dual.gpio2_Data_In\(25),
      \Dual.gpio2_Data_In_reg[0]_0\(5) => \Dual.gpio2_Data_In\(26),
      \Dual.gpio2_Data_In_reg[0]_0\(4) => \Dual.gpio2_Data_In\(27),
      \Dual.gpio2_Data_In_reg[0]_0\(3) => \Dual.gpio2_Data_In\(28),
      \Dual.gpio2_Data_In_reg[0]_0\(2) => \Dual.gpio2_Data_In\(29),
      \Dual.gpio2_Data_In_reg[0]_0\(1) => \Dual.gpio2_Data_In\(30),
      \Dual.gpio2_Data_In_reg[0]_0\(0) => \Dual.gpio2_Data_In\(31),
      \Dual.gpio_OE_reg[0]_0\ => gpio_core_1_n_36,
      \Dual.gpio_OE_reg[0]_1\ => AXI_LITE_IPIF_I_n_73,
      E(0) => AXI_LITE_IPIF_I_n_38,
      GPIO_xferAck_i => GPIO_xferAck_i,
      Q(31) => gpio_core_1_n_39,
      Q(30) => gpio_core_1_n_40,
      Q(29) => gpio_core_1_n_41,
      Q(28) => gpio_core_1_n_42,
      Q(27) => gpio_core_1_n_43,
      Q(26) => gpio_core_1_n_44,
      Q(25) => gpio_core_1_n_45,
      Q(24) => gpio_core_1_n_46,
      Q(23) => gpio_core_1_n_47,
      Q(22) => gpio_core_1_n_48,
      Q(21) => gpio_core_1_n_49,
      Q(20) => gpio_core_1_n_50,
      Q(19) => gpio_core_1_n_51,
      Q(18) => gpio_core_1_n_52,
      Q(17) => gpio_core_1_n_53,
      Q(16) => gpio_core_1_n_54,
      Q(15) => gpio_core_1_n_55,
      Q(14) => gpio_core_1_n_56,
      Q(13) => gpio_core_1_n_57,
      Q(12) => gpio_core_1_n_58,
      Q(11) => gpio_core_1_n_59,
      Q(10) => gpio_core_1_n_60,
      Q(9) => gpio_core_1_n_61,
      Q(8) => gpio_core_1_n_62,
      Q(7) => gpio_core_1_n_63,
      Q(6) => gpio_core_1_n_64,
      Q(5) => gpio_core_1_n_65,
      Q(4) => gpio_core_1_n_66,
      Q(3) => gpio_core_1_n_67,
      Q(2) => gpio_core_1_n_68,
      Q(1) => gpio_core_1_n_69,
      Q(0) => gpio_core_1_n_70,
      bus2ip_cs(0) => bus2ip_cs(0),
      bus2ip_reset => bus2ip_reset,
      bus2ip_rnw => bus2ip_rnw,
      gpio2_io_i(31 downto 0) => gpio2_io_i(31 downto 0),
      gpio_Data_In(0) => gpio_Data_In(0),
      gpio_io_i(0) => gpio_io_i(0),
      gpio_xferAck_Reg => gpio_xferAck_Reg,
      ip2bus_rdack_i => ip2bus_rdack_i,
      ip2bus_wrack_i => ip2bus_wrack_i,
      s_axi_aclk => s_axi_aclk
    );
\ip2bus_data_i_D1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(0),
      Q => ip2bus_data_i_D1(0),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(10),
      Q => ip2bus_data_i_D1(10),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(11),
      Q => ip2bus_data_i_D1(11),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(12),
      Q => ip2bus_data_i_D1(12),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(13),
      Q => ip2bus_data_i_D1(13),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(14),
      Q => ip2bus_data_i_D1(14),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(15),
      Q => ip2bus_data_i_D1(15),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(16),
      Q => ip2bus_data_i_D1(16),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(17),
      Q => ip2bus_data_i_D1(17),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(18),
      Q => ip2bus_data_i_D1(18),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(19),
      Q => ip2bus_data_i_D1(19),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(1),
      Q => ip2bus_data_i_D1(1),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(20),
      Q => ip2bus_data_i_D1(20),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(21),
      Q => ip2bus_data_i_D1(21),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(22),
      Q => ip2bus_data_i_D1(22),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(23),
      Q => ip2bus_data_i_D1(23),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(24),
      Q => ip2bus_data_i_D1(24),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(25),
      Q => ip2bus_data_i_D1(25),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(26),
      Q => ip2bus_data_i_D1(26),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(27),
      Q => ip2bus_data_i_D1(27),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(28),
      Q => ip2bus_data_i_D1(28),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(29),
      Q => ip2bus_data_i_D1(29),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(2),
      Q => ip2bus_data_i_D1(2),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(30),
      Q => ip2bus_data_i_D1(30),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(31),
      Q => ip2bus_data_i_D1(31),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(3),
      Q => ip2bus_data_i_D1(3),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(4),
      Q => ip2bus_data_i_D1(4),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(5),
      Q => ip2bus_data_i_D1(5),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(6),
      Q => ip2bus_data_i_D1(6),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(7),
      Q => ip2bus_data_i_D1(7),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(8),
      Q => ip2bus_data_i_D1(8),
      R => bus2ip_reset
    );
\ip2bus_data_i_D1_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_data(9),
      Q => ip2bus_data_i_D1(9),
      R => bus2ip_reset
    );
ip2bus_rdack_i_D1_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_rdack_i,
      Q => ip2bus_rdack_i_D1,
      R => bus2ip_reset
    );
ip2bus_wrack_i_D1_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ip2bus_wrack_i,
      Q => ip2bus_wrack_i_D1,
      R => bus2ip_reset
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_return_state_gpio_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    gpio_io_i : in STD_LOGIC_VECTOR ( 0 to 0 );
    gpio2_io_i : in STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of c6v_return_state_gpio_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_return_state_gpio_0 : entity is "c6v_return_state_gpio_0,axi_gpio,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of c6v_return_state_gpio_0 : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of c6v_return_state_gpio_0 : entity is "axi_gpio,Vivado 2026.1";
end c6v_return_state_gpio_0;

architecture STRUCTURE of c6v_return_state_gpio_0 is
  signal \<const0>\ : STD_LOGIC;
  signal NLW_U0_ip2intc_irpt_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_gpio2_io_o_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_U0_gpio2_io_t_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_U0_gpio_io_o_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_U0_gpio_io_t_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_U0_s_axi_bresp_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_U0_s_axi_rresp_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute C_ALL_INPUTS : integer;
  attribute C_ALL_INPUTS of U0 : label is 1;
  attribute C_ALL_INPUTS_2 : integer;
  attribute C_ALL_INPUTS_2 of U0 : label is 1;
  attribute C_ALL_OUTPUTS : integer;
  attribute C_ALL_OUTPUTS of U0 : label is 0;
  attribute C_ALL_OUTPUTS_2 : integer;
  attribute C_ALL_OUTPUTS_2 of U0 : label is 0;
  attribute C_DOUT_DEFAULT : string;
  attribute C_DOUT_DEFAULT of U0 : label is "32'b00000000000000000000000000000000";
  attribute C_DOUT_DEFAULT_2 : string;
  attribute C_DOUT_DEFAULT_2 of U0 : label is "32'b00000000000000000000000000000000";
  attribute C_FAMILY : string;
  attribute C_FAMILY of U0 : label is "zynq";
  attribute C_GPIO2_WIDTH : integer;
  attribute C_GPIO2_WIDTH of U0 : label is 32;
  attribute C_GPIO_WIDTH : integer;
  attribute C_GPIO_WIDTH of U0 : label is 1;
  attribute C_INTERRUPT_PRESENT : integer;
  attribute C_INTERRUPT_PRESENT of U0 : label is 0;
  attribute C_IS_DUAL : integer;
  attribute C_IS_DUAL of U0 : label is 1;
  attribute C_S_AXI_ADDR_WIDTH : integer;
  attribute C_S_AXI_ADDR_WIDTH of U0 : label is 9;
  attribute C_S_AXI_DATA_WIDTH : integer;
  attribute C_S_AXI_DATA_WIDTH of U0 : label is 32;
  attribute C_TRI_DEFAULT : string;
  attribute C_TRI_DEFAULT of U0 : label is "32'b11111111111111111111111111111111";
  attribute C_TRI_DEFAULT_2 : string;
  attribute C_TRI_DEFAULT_2 of U0 : label is "32'b11111111111111111111111111111111";
  attribute downgradeipidentifiedwarnings of U0 : label is "yes";
  attribute ip_group : string;
  attribute ip_group of U0 : label is "LOGICORE";
  attribute x_interface_info : string;
  attribute x_interface_info of s_axi_aclk : signal is "xilinx.com:signal:clock:1.0 S_AXI_ACLK CLK";
  attribute x_interface_mode : string;
  attribute x_interface_mode of s_axi_aclk : signal is "slave S_AXI_ACLK";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of s_axi_aclk : signal is "XIL_INTERFACENAME S_AXI_ACLK, ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute x_interface_info of s_axi_aresetn : signal is "xilinx.com:signal:reset:1.0 S_AXI_ARESETN RST";
  attribute x_interface_mode of s_axi_aresetn : signal is "slave S_AXI_ARESETN";
  attribute x_interface_parameter of s_axi_aresetn : signal is "XIL_INTERFACENAME S_AXI_ARESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute x_interface_info of s_axi_arready : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARREADY";
  attribute x_interface_info of s_axi_arvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARVALID";
  attribute x_interface_info of s_axi_awready : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWREADY";
  attribute x_interface_info of s_axi_awvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWVALID";
  attribute x_interface_info of s_axi_bready : signal is "xilinx.com:interface:aximm:1.0 S_AXI BREADY";
  attribute x_interface_info of s_axi_bvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI BVALID";
  attribute x_interface_info of s_axi_rready : signal is "xilinx.com:interface:aximm:1.0 S_AXI RREADY";
  attribute x_interface_info of s_axi_rvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI RVALID";
  attribute x_interface_info of s_axi_wready : signal is "xilinx.com:interface:aximm:1.0 S_AXI WREADY";
  attribute x_interface_info of s_axi_wvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI WVALID";
  attribute x_interface_info of gpio2_io_i : signal is "xilinx.com:interface:gpio:1.0 GPIO2 TRI_I";
  attribute x_interface_mode of gpio2_io_i : signal is "master GPIO2";
  attribute x_interface_parameter of gpio2_io_i : signal is "XIL_INTERFACENAME GPIO2, BOARD.ASSOCIATED_PARAM GPIO2_BOARD_INTERFACE";
  attribute x_interface_info of gpio_io_i : signal is "xilinx.com:interface:gpio:1.0 GPIO TRI_I";
  attribute x_interface_mode of gpio_io_i : signal is "master GPIO";
  attribute x_interface_parameter of gpio_io_i : signal is "XIL_INTERFACENAME GPIO, BOARD.ASSOCIATED_PARAM GPIO_BOARD_INTERFACE";
  attribute x_interface_info of s_axi_araddr : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARADDR";
  attribute x_interface_info of s_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWADDR";
  attribute x_interface_mode of s_axi_awaddr : signal is "slave S_AXI";
  attribute x_interface_parameter of s_axi_awaddr : signal is "XIL_INTERFACENAME S_AXI, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 9, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 8, NUM_WRITE_OUTSTANDING 8, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute x_interface_info of s_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 S_AXI BRESP";
  attribute x_interface_info of s_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 S_AXI RDATA";
  attribute x_interface_info of s_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 S_AXI RRESP";
  attribute x_interface_info of s_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 S_AXI WDATA";
  attribute x_interface_info of s_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 S_AXI WSTRB";
begin
  s_axi_bresp(1) <= \<const0>\;
  s_axi_bresp(0) <= \<const0>\;
  s_axi_rresp(1) <= \<const0>\;
  s_axi_rresp(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
U0: entity work.c6v_return_state_gpio_0_axi_gpio
     port map (
      gpio2_io_i(31 downto 0) => gpio2_io_i(31 downto 0),
      gpio2_io_o(31 downto 0) => NLW_U0_gpio2_io_o_UNCONNECTED(31 downto 0),
      gpio2_io_t(31 downto 0) => NLW_U0_gpio2_io_t_UNCONNECTED(31 downto 0),
      gpio_io_i(0) => gpio_io_i(0),
      gpio_io_o(0) => NLW_U0_gpio_io_o_UNCONNECTED(0),
      gpio_io_t(0) => NLW_U0_gpio_io_t_UNCONNECTED(0),
      ip2intc_irpt => NLW_U0_ip2intc_irpt_UNCONNECTED,
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(8) => s_axi_araddr(8),
      s_axi_araddr(7 downto 4) => B"0000",
      s_axi_araddr(3 downto 2) => s_axi_araddr(3 downto 2),
      s_axi_araddr(1 downto 0) => B"00",
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arready => s_axi_arready,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(8) => s_axi_awaddr(8),
      s_axi_awaddr(7 downto 4) => B"0000",
      s_axi_awaddr(3 downto 2) => s_axi_awaddr(3 downto 2),
      s_axi_awaddr(1 downto 0) => B"00",
      s_axi_awready => s_axi_awready,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bready => s_axi_bready,
      s_axi_bresp(1 downto 0) => NLW_U0_s_axi_bresp_UNCONNECTED(1 downto 0),
      s_axi_bvalid => s_axi_bvalid,
      s_axi_rdata(31 downto 0) => s_axi_rdata(31 downto 0),
      s_axi_rready => s_axi_rready,
      s_axi_rresp(1 downto 0) => NLW_U0_s_axi_rresp_UNCONNECTED(1 downto 0),
      s_axi_rvalid => s_axi_rvalid,
      s_axi_wdata(31 downto 0) => s_axi_wdata(31 downto 0),
      s_axi_wready => s_axi_wready,
      s_axi_wstrb(3 downto 0) => B"0000",
      s_axi_wvalid => s_axi_wvalid
    );
end STRUCTURE;
