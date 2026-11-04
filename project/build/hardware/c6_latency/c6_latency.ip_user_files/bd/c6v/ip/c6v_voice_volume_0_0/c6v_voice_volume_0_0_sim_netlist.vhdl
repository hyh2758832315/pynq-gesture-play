-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 23 06:47:30 2026
-- Host        : build-host running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               e:/vvl/c0e/c6_latency.gen/sources_1/bd/c6v/ip/c6v_voice_volume_0_0/c6v_voice_volume_0_0_sim_netlist.vhdl
-- Design      : c6v_voice_volume_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_voice_volume_0_0_voice_volume_core is
  port (
    \out\ : out STD_LOGIC_VECTOR ( 63 downto 0 );
    Q : out STD_LOGIC_VECTOR ( 31 downto 0 );
    \dc_level_reg[22]_0\ : out STD_LOGIC_VECTOR ( 14 downto 0 );
    status : out STD_LOGIC_VECTOR ( 4 downto 0 );
    \event_kind_reg[1]_0\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \faults_reg[7]_0\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \snapshot_sequence_reg[10]\ : out STD_LOGIC_VECTOR ( 10 downto 0 );
    \faults_reg[0]_0\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    \window_count_reg[31]_0\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    \event_epoch_reg[31]_0\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    \event_sequence_reg[31]_0\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_aresetn_0 : out STD_LOGIC;
    snapshot_valid_reg : out STD_LOGIC;
    \last_sum_reg[31]_0\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    \event_sample_reg[63]_0\ : out STD_LOGIC_VECTOR ( 63 downto 0 );
    \event_window_reg[31]_0\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    dc_clipped0 : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 15 downto 0 );
    \difference_latched_reg[12]_0\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \difference_latched_reg[12]_1\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \difference_latched_reg[20]_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \difference_latched_reg[24]_0\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    configure : in STD_LOGIC;
    \faults_reg[0]_1\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    input_fault : in STD_LOGIC;
    \faults_reg[1]_0\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    pcm_valid : in STD_LOGIC;
    ack_error_reg_0 : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    \s_axi_rdata_reg[2]\ : in STD_LOGIC;
    \s_axi_rdata_reg[2]_0\ : in STD_LOGIC;
    \s_axi_rdata_reg[2]_1\ : in STD_LOGIC;
    \s_axi_rdata_reg[2]_2\ : in STD_LOGIC;
    \s_axi_rdata_reg[2]_3\ : in STD_LOGIC;
    \s_axi_rdata_reg[9]\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \s_axi_rdata_reg[2]_4\ : in STD_LOGIC;
    \above_loud_carry__2_0\ : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \faults[7]_i_10_0\ : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \quiet_carry__2_0\ : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \matching_ack1_carry__1_0\ : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \matching_ack0_carry__1_0\ : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \s_axi_rdata_reg[0]\ : in STD_LOGIC;
    \s_axi_rdata_reg[0]_0\ : in STD_LOGIC;
    \s_axi_rdata_reg[1]\ : in STD_LOGIC;
    \s_axi_rdata_reg[1]_0\ : in STD_LOGIC;
    \s_axi_rdata_reg[3]\ : in STD_LOGIC;
    \s_axi_rdata_reg[3]_0\ : in STD_LOGIC;
    \s_axi_rdata_reg[4]\ : in STD_LOGIC;
    \s_axi_rdata_reg[4]_0\ : in STD_LOGIC;
    \s_axi_rdata_reg[5]\ : in STD_LOGIC;
    \s_axi_rdata_reg[5]_0\ : in STD_LOGIC;
    \s_axi_rdata_reg[6]\ : in STD_LOGIC;
    \s_axi_rdata_reg[6]_0\ : in STD_LOGIC;
    \s_axi_rdata_reg[7]\ : in STD_LOGIC;
    \s_axi_rdata_reg[7]_0\ : in STD_LOGIC;
    \s_axi_rdata_reg[8]\ : in STD_LOGIC;
    \s_axi_rdata_reg[8]_0\ : in STD_LOGIC;
    \s_axi_rdata_reg[8]_1\ : in STD_LOGIC;
    \s_axi_rdata_reg[9]_0\ : in STD_LOGIC;
    \s_axi_rdata_reg[9]_1\ : in STD_LOGIC;
    \s_axi_rdata_reg[10]\ : in STD_LOGIC;
    \s_axi_rdata_reg[10]_0\ : in STD_LOGIC;
    \s_axi_rdata_reg[4]_1\ : in STD_LOGIC;
    \s_axi_rdata_reg[4]_2\ : in STD_LOGIC;
    \s_axi_rdata_reg[10]_1\ : in STD_LOGIC;
    config_epoch_reg : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \s_axi_rdata_reg[1]_1\ : in STD_LOGIC;
    \s_axi_rdata_reg[3]_1\ : in STD_LOGIC;
    snapshot_valid : in STD_LOGIC;
    snapshot_valid_reg_0 : in STD_LOGIC;
    snapshot_valid_reg_1 : in STD_LOGIC;
    snapshot_valid_reg_2 : in STD_LOGIC;
    snapshot_valid_reg_3 : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_voice_volume_0_0_voice_volume_core : entity is "voice_volume_core";
end c6v_voice_volume_0_0_voice_volume_core;

architecture STRUCTURE of c6v_voice_volume_0_0_voice_volume_core is
  signal \^q\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal above_loud : STD_LOGIC;
  signal \above_loud_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \above_loud_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \above_loud_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \above_loud_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \above_loud_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \above_loud_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \above_loud_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \above_loud_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \above_loud_carry__0_n_0\ : STD_LOGIC;
  signal \above_loud_carry__0_n_1\ : STD_LOGIC;
  signal \above_loud_carry__0_n_2\ : STD_LOGIC;
  signal \above_loud_carry__0_n_3\ : STD_LOGIC;
  signal \above_loud_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \above_loud_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \above_loud_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \above_loud_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \above_loud_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \above_loud_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \above_loud_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \above_loud_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \above_loud_carry__1_n_0\ : STD_LOGIC;
  signal \above_loud_carry__1_n_1\ : STD_LOGIC;
  signal \above_loud_carry__1_n_2\ : STD_LOGIC;
  signal \above_loud_carry__1_n_3\ : STD_LOGIC;
  signal \above_loud_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \above_loud_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \above_loud_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \above_loud_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \above_loud_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \above_loud_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \above_loud_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \above_loud_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \above_loud_carry__2_n_0\ : STD_LOGIC;
  signal \above_loud_carry__2_n_1\ : STD_LOGIC;
  signal \above_loud_carry__2_n_2\ : STD_LOGIC;
  signal \above_loud_carry__2_n_3\ : STD_LOGIC;
  signal \above_loud_carry__3_i_1_n_0\ : STD_LOGIC;
  signal above_loud_carry_i_1_n_0 : STD_LOGIC;
  signal above_loud_carry_i_2_n_0 : STD_LOGIC;
  signal above_loud_carry_i_3_n_0 : STD_LOGIC;
  signal above_loud_carry_i_4_n_0 : STD_LOGIC;
  signal above_loud_carry_i_5_n_0 : STD_LOGIC;
  signal above_loud_carry_i_6_n_0 : STD_LOGIC;
  signal above_loud_carry_i_7_n_0 : STD_LOGIC;
  signal above_loud_carry_i_8_n_0 : STD_LOGIC;
  signal above_loud_carry_n_0 : STD_LOGIC;
  signal above_loud_carry_n_1 : STD_LOGIC;
  signal above_loud_carry_n_2 : STD_LOGIC;
  signal above_loud_carry_n_3 : STD_LOGIC;
  signal \above_soft_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \above_soft_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \above_soft_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \above_soft_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \above_soft_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \above_soft_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \above_soft_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \above_soft_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \above_soft_carry__0_n_0\ : STD_LOGIC;
  signal \above_soft_carry__0_n_1\ : STD_LOGIC;
  signal \above_soft_carry__0_n_2\ : STD_LOGIC;
  signal \above_soft_carry__0_n_3\ : STD_LOGIC;
  signal \above_soft_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \above_soft_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \above_soft_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \above_soft_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \above_soft_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \above_soft_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \above_soft_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \above_soft_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \above_soft_carry__1_n_0\ : STD_LOGIC;
  signal \above_soft_carry__1_n_1\ : STD_LOGIC;
  signal \above_soft_carry__1_n_2\ : STD_LOGIC;
  signal \above_soft_carry__1_n_3\ : STD_LOGIC;
  signal \above_soft_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \above_soft_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \above_soft_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \above_soft_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \above_soft_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \above_soft_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \above_soft_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \above_soft_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \above_soft_carry__2_n_0\ : STD_LOGIC;
  signal \above_soft_carry__2_n_1\ : STD_LOGIC;
  signal \above_soft_carry__2_n_2\ : STD_LOGIC;
  signal \above_soft_carry__2_n_3\ : STD_LOGIC;
  signal \above_soft_carry__3_i_2_n_0\ : STD_LOGIC;
  signal above_soft_carry_i_1_n_0 : STD_LOGIC;
  signal above_soft_carry_i_2_n_0 : STD_LOGIC;
  signal above_soft_carry_i_3_n_0 : STD_LOGIC;
  signal above_soft_carry_i_4_n_0 : STD_LOGIC;
  signal above_soft_carry_i_5_n_0 : STD_LOGIC;
  signal above_soft_carry_i_6_n_0 : STD_LOGIC;
  signal above_soft_carry_i_7_n_0 : STD_LOGIC;
  signal above_soft_carry_i_8_n_0 : STD_LOGIC;
  signal above_soft_carry_n_0 : STD_LOGIC;
  signal above_soft_carry_n_1 : STD_LOGIC;
  signal above_soft_carry_n_2 : STD_LOGIC;
  signal above_soft_carry_n_3 : STD_LOGIC;
  signal accumulation : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \accumulation[11]_i_10_n_0\ : STD_LOGIC;
  signal \accumulation[11]_i_2_n_0\ : STD_LOGIC;
  signal \accumulation[11]_i_3_n_0\ : STD_LOGIC;
  signal \accumulation[11]_i_4_n_0\ : STD_LOGIC;
  signal \accumulation[11]_i_5_n_0\ : STD_LOGIC;
  signal \accumulation[11]_i_7_n_0\ : STD_LOGIC;
  signal \accumulation[11]_i_8_n_0\ : STD_LOGIC;
  signal \accumulation[11]_i_9_n_0\ : STD_LOGIC;
  signal \accumulation[15]_i_10_n_0\ : STD_LOGIC;
  signal \accumulation[15]_i_2_n_0\ : STD_LOGIC;
  signal \accumulation[15]_i_3_n_0\ : STD_LOGIC;
  signal \accumulation[15]_i_4_n_0\ : STD_LOGIC;
  signal \accumulation[15]_i_5_n_0\ : STD_LOGIC;
  signal \accumulation[15]_i_7_n_0\ : STD_LOGIC;
  signal \accumulation[15]_i_8_n_0\ : STD_LOGIC;
  signal \accumulation[15]_i_9_n_0\ : STD_LOGIC;
  signal \accumulation[19]_i_10_n_0\ : STD_LOGIC;
  signal \accumulation[19]_i_2_n_0\ : STD_LOGIC;
  signal \accumulation[19]_i_3_n_0\ : STD_LOGIC;
  signal \accumulation[19]_i_6_n_0\ : STD_LOGIC;
  signal \accumulation[19]_i_7_n_0\ : STD_LOGIC;
  signal \accumulation[19]_i_8_n_0\ : STD_LOGIC;
  signal \accumulation[19]_i_9_n_0\ : STD_LOGIC;
  signal \accumulation[3]_i_2_n_0\ : STD_LOGIC;
  signal \accumulation[3]_i_3_n_0\ : STD_LOGIC;
  signal \accumulation[3]_i_4_n_0\ : STD_LOGIC;
  signal \accumulation[3]_i_5_n_0\ : STD_LOGIC;
  signal \accumulation[7]_i_10_n_0\ : STD_LOGIC;
  signal \accumulation[7]_i_11_n_0\ : STD_LOGIC;
  signal \accumulation[7]_i_2_n_0\ : STD_LOGIC;
  signal \accumulation[7]_i_3_n_0\ : STD_LOGIC;
  signal \accumulation[7]_i_4_n_0\ : STD_LOGIC;
  signal \accumulation[7]_i_5_n_0\ : STD_LOGIC;
  signal \accumulation[7]_i_7_n_0\ : STD_LOGIC;
  signal \accumulation[7]_i_8_n_0\ : STD_LOGIC;
  signal \accumulation[7]_i_9_n_0\ : STD_LOGIC;
  signal \accumulation_reg[11]_i_1_n_0\ : STD_LOGIC;
  signal \accumulation_reg[11]_i_1_n_1\ : STD_LOGIC;
  signal \accumulation_reg[11]_i_1_n_2\ : STD_LOGIC;
  signal \accumulation_reg[11]_i_1_n_3\ : STD_LOGIC;
  signal \accumulation_reg[11]_i_1_n_4\ : STD_LOGIC;
  signal \accumulation_reg[11]_i_1_n_5\ : STD_LOGIC;
  signal \accumulation_reg[11]_i_1_n_6\ : STD_LOGIC;
  signal \accumulation_reg[11]_i_1_n_7\ : STD_LOGIC;
  signal \accumulation_reg[11]_i_6_n_0\ : STD_LOGIC;
  signal \accumulation_reg[11]_i_6_n_1\ : STD_LOGIC;
  signal \accumulation_reg[11]_i_6_n_2\ : STD_LOGIC;
  signal \accumulation_reg[11]_i_6_n_3\ : STD_LOGIC;
  signal \accumulation_reg[15]_i_1_n_0\ : STD_LOGIC;
  signal \accumulation_reg[15]_i_1_n_1\ : STD_LOGIC;
  signal \accumulation_reg[15]_i_1_n_2\ : STD_LOGIC;
  signal \accumulation_reg[15]_i_1_n_3\ : STD_LOGIC;
  signal \accumulation_reg[15]_i_1_n_4\ : STD_LOGIC;
  signal \accumulation_reg[15]_i_1_n_5\ : STD_LOGIC;
  signal \accumulation_reg[15]_i_1_n_6\ : STD_LOGIC;
  signal \accumulation_reg[15]_i_1_n_7\ : STD_LOGIC;
  signal \accumulation_reg[15]_i_6_n_0\ : STD_LOGIC;
  signal \accumulation_reg[15]_i_6_n_1\ : STD_LOGIC;
  signal \accumulation_reg[15]_i_6_n_2\ : STD_LOGIC;
  signal \accumulation_reg[15]_i_6_n_3\ : STD_LOGIC;
  signal \accumulation_reg[19]_i_1_n_0\ : STD_LOGIC;
  signal \accumulation_reg[19]_i_1_n_1\ : STD_LOGIC;
  signal \accumulation_reg[19]_i_1_n_2\ : STD_LOGIC;
  signal \accumulation_reg[19]_i_1_n_3\ : STD_LOGIC;
  signal \accumulation_reg[19]_i_1_n_4\ : STD_LOGIC;
  signal \accumulation_reg[19]_i_1_n_5\ : STD_LOGIC;
  signal \accumulation_reg[19]_i_1_n_6\ : STD_LOGIC;
  signal \accumulation_reg[19]_i_1_n_7\ : STD_LOGIC;
  signal \accumulation_reg[19]_i_5_n_0\ : STD_LOGIC;
  signal \accumulation_reg[19]_i_5_n_1\ : STD_LOGIC;
  signal \accumulation_reg[19]_i_5_n_2\ : STD_LOGIC;
  signal \accumulation_reg[19]_i_5_n_3\ : STD_LOGIC;
  signal \accumulation_reg[23]_i_1_n_0\ : STD_LOGIC;
  signal \accumulation_reg[23]_i_1_n_1\ : STD_LOGIC;
  signal \accumulation_reg[23]_i_1_n_2\ : STD_LOGIC;
  signal \accumulation_reg[23]_i_1_n_3\ : STD_LOGIC;
  signal \accumulation_reg[23]_i_1_n_4\ : STD_LOGIC;
  signal \accumulation_reg[23]_i_1_n_5\ : STD_LOGIC;
  signal \accumulation_reg[23]_i_1_n_6\ : STD_LOGIC;
  signal \accumulation_reg[23]_i_1_n_7\ : STD_LOGIC;
  signal \accumulation_reg[27]_i_1_n_0\ : STD_LOGIC;
  signal \accumulation_reg[27]_i_1_n_1\ : STD_LOGIC;
  signal \accumulation_reg[27]_i_1_n_2\ : STD_LOGIC;
  signal \accumulation_reg[27]_i_1_n_3\ : STD_LOGIC;
  signal \accumulation_reg[27]_i_1_n_4\ : STD_LOGIC;
  signal \accumulation_reg[27]_i_1_n_5\ : STD_LOGIC;
  signal \accumulation_reg[27]_i_1_n_6\ : STD_LOGIC;
  signal \accumulation_reg[27]_i_1_n_7\ : STD_LOGIC;
  signal \accumulation_reg[31]_i_1_n_0\ : STD_LOGIC;
  signal \accumulation_reg[31]_i_1_n_1\ : STD_LOGIC;
  signal \accumulation_reg[31]_i_1_n_2\ : STD_LOGIC;
  signal \accumulation_reg[31]_i_1_n_3\ : STD_LOGIC;
  signal \accumulation_reg[31]_i_1_n_4\ : STD_LOGIC;
  signal \accumulation_reg[31]_i_1_n_5\ : STD_LOGIC;
  signal \accumulation_reg[31]_i_1_n_6\ : STD_LOGIC;
  signal \accumulation_reg[31]_i_1_n_7\ : STD_LOGIC;
  signal \accumulation_reg[3]_i_1_n_0\ : STD_LOGIC;
  signal \accumulation_reg[3]_i_1_n_1\ : STD_LOGIC;
  signal \accumulation_reg[3]_i_1_n_2\ : STD_LOGIC;
  signal \accumulation_reg[3]_i_1_n_3\ : STD_LOGIC;
  signal \accumulation_reg[3]_i_1_n_4\ : STD_LOGIC;
  signal \accumulation_reg[3]_i_1_n_5\ : STD_LOGIC;
  signal \accumulation_reg[3]_i_1_n_6\ : STD_LOGIC;
  signal \accumulation_reg[3]_i_1_n_7\ : STD_LOGIC;
  signal \accumulation_reg[7]_i_1_n_0\ : STD_LOGIC;
  signal \accumulation_reg[7]_i_1_n_1\ : STD_LOGIC;
  signal \accumulation_reg[7]_i_1_n_2\ : STD_LOGIC;
  signal \accumulation_reg[7]_i_1_n_3\ : STD_LOGIC;
  signal \accumulation_reg[7]_i_1_n_4\ : STD_LOGIC;
  signal \accumulation_reg[7]_i_1_n_5\ : STD_LOGIC;
  signal \accumulation_reg[7]_i_1_n_6\ : STD_LOGIC;
  signal \accumulation_reg[7]_i_1_n_7\ : STD_LOGIC;
  signal \accumulation_reg[7]_i_6_n_0\ : STD_LOGIC;
  signal \accumulation_reg[7]_i_6_n_1\ : STD_LOGIC;
  signal \accumulation_reg[7]_i_6_n_2\ : STD_LOGIC;
  signal \accumulation_reg[7]_i_6_n_3\ : STD_LOGIC;
  signal ack_error_i_1_n_0 : STD_LOGIC;
  signal ack_error_i_2_n_0 : STD_LOGIC;
  signal ack_error_i_3_n_0 : STD_LOGIC;
  signal candidate_count : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \candidate_count[0]_i_1_n_0\ : STD_LOGIC;
  signal \candidate_count[1]_i_1_n_0\ : STD_LOGIC;
  signal \candidate_count[2]_i_2_n_0\ : STD_LOGIC;
  signal \candidate_count[2]_i_3_n_0\ : STD_LOGIC;
  signal \candidate_count[2]_i_4_n_0\ : STD_LOGIC;
  signal \candidate_count[2]_i_5_n_0\ : STD_LOGIC;
  signal centered : STD_LOGIC_VECTOR ( 25 downto 8 );
  signal \centered_carry__0_n_0\ : STD_LOGIC;
  signal \centered_carry__0_n_1\ : STD_LOGIC;
  signal \centered_carry__0_n_2\ : STD_LOGIC;
  signal \centered_carry__0_n_3\ : STD_LOGIC;
  signal \centered_carry__1_n_0\ : STD_LOGIC;
  signal \centered_carry__1_n_1\ : STD_LOGIC;
  signal \centered_carry__1_n_2\ : STD_LOGIC;
  signal \centered_carry__1_n_3\ : STD_LOGIC;
  signal \centered_carry__2_n_0\ : STD_LOGIC;
  signal \centered_carry__2_n_1\ : STD_LOGIC;
  signal \centered_carry__2_n_2\ : STD_LOGIC;
  signal \centered_carry__2_n_3\ : STD_LOGIC;
  signal \centered_carry__3_n_0\ : STD_LOGIC;
  signal \centered_carry__3_n_1\ : STD_LOGIC;
  signal \centered_carry__3_n_2\ : STD_LOGIC;
  signal \centered_carry__3_n_3\ : STD_LOGIC;
  signal \centered_carry__4_n_0\ : STD_LOGIC;
  signal \centered_carry__4_n_1\ : STD_LOGIC;
  signal \centered_carry__4_n_2\ : STD_LOGIC;
  signal \centered_carry__4_n_3\ : STD_LOGIC;
  signal \centered_carry_i_1__0_n_0\ : STD_LOGIC;
  signal \centered_carry_i_1__1_n_0\ : STD_LOGIC;
  signal \centered_carry_i_1__2_n_0\ : STD_LOGIC;
  signal \centered_carry_i_1__3_n_0\ : STD_LOGIC;
  signal \centered_carry_i_1__4_n_0\ : STD_LOGIC;
  signal \centered_carry_i_1__5_n_0\ : STD_LOGIC;
  signal centered_carry_i_1_n_0 : STD_LOGIC;
  signal \centered_carry_i_2__0_n_0\ : STD_LOGIC;
  signal \centered_carry_i_2__1_n_0\ : STD_LOGIC;
  signal \centered_carry_i_2__2_n_0\ : STD_LOGIC;
  signal \centered_carry_i_2__3_n_0\ : STD_LOGIC;
  signal \centered_carry_i_2__4_n_0\ : STD_LOGIC;
  signal centered_carry_i_2_n_0 : STD_LOGIC;
  signal \centered_carry_i_3__0_n_0\ : STD_LOGIC;
  signal \centered_carry_i_3__1_n_0\ : STD_LOGIC;
  signal \centered_carry_i_3__2_n_0\ : STD_LOGIC;
  signal \centered_carry_i_3__3_n_0\ : STD_LOGIC;
  signal \centered_carry_i_3__4_n_0\ : STD_LOGIC;
  signal centered_carry_i_3_n_0 : STD_LOGIC;
  signal \centered_carry_i_4__0_n_0\ : STD_LOGIC;
  signal \centered_carry_i_4__1_n_0\ : STD_LOGIC;
  signal \centered_carry_i_4__2_n_0\ : STD_LOGIC;
  signal \centered_carry_i_4__3_n_0\ : STD_LOGIC;
  signal \centered_carry_i_4__4_n_0\ : STD_LOGIC;
  signal centered_carry_i_4_n_0 : STD_LOGIC;
  signal centered_carry_i_5_n_0 : STD_LOGIC;
  signal centered_carry_n_0 : STD_LOGIC;
  signal centered_carry_n_1 : STD_LOGIC;
  signal centered_carry_n_2 : STD_LOGIC;
  signal centered_carry_n_3 : STD_LOGIC;
  signal clipped_count : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \clipped_count[15]_i_2_n_0\ : STD_LOGIC;
  signal \clipped_count[15]_i_4_n_0\ : STD_LOGIC;
  signal \clipped_count[3]_i_2_n_0\ : STD_LOGIC;
  signal \clipped_count_reg[11]_i_1_n_0\ : STD_LOGIC;
  signal \clipped_count_reg[11]_i_1_n_1\ : STD_LOGIC;
  signal \clipped_count_reg[11]_i_1_n_2\ : STD_LOGIC;
  signal \clipped_count_reg[11]_i_1_n_3\ : STD_LOGIC;
  signal \clipped_count_reg[15]_i_3_n_0\ : STD_LOGIC;
  signal \clipped_count_reg[15]_i_3_n_1\ : STD_LOGIC;
  signal \clipped_count_reg[15]_i_3_n_2\ : STD_LOGIC;
  signal \clipped_count_reg[15]_i_3_n_3\ : STD_LOGIC;
  signal \clipped_count_reg[3]_i_1_n_0\ : STD_LOGIC;
  signal \clipped_count_reg[3]_i_1_n_1\ : STD_LOGIC;
  signal \clipped_count_reg[3]_i_1_n_2\ : STD_LOGIC;
  signal \clipped_count_reg[3]_i_1_n_3\ : STD_LOGIC;
  signal \clipped_count_reg[7]_i_1_n_0\ : STD_LOGIC;
  signal \clipped_count_reg[7]_i_1_n_1\ : STD_LOGIC;
  signal \clipped_count_reg[7]_i_1_n_2\ : STD_LOGIC;
  signal \clipped_count_reg[7]_i_1_n_3\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[0]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[10]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[11]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[12]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[13]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[14]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[15]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[1]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[2]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[3]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[4]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[5]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[6]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[7]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[8]\ : STD_LOGIC;
  signal \clipped_count_reg_n_0_[9]\ : STD_LOGIC;
  signal dc_clipped : STD_LOGIC;
  signal dc_difference : STD_LOGIC_VECTOR ( 25 downto 10 );
  signal \dc_difference_carry__0_n_0\ : STD_LOGIC;
  signal \dc_difference_carry__0_n_1\ : STD_LOGIC;
  signal \dc_difference_carry__0_n_2\ : STD_LOGIC;
  signal \dc_difference_carry__0_n_3\ : STD_LOGIC;
  signal \dc_difference_carry__1_n_0\ : STD_LOGIC;
  signal \dc_difference_carry__1_n_1\ : STD_LOGIC;
  signal \dc_difference_carry__1_n_2\ : STD_LOGIC;
  signal \dc_difference_carry__1_n_3\ : STD_LOGIC;
  signal \dc_difference_carry__2_n_0\ : STD_LOGIC;
  signal \dc_difference_carry__2_n_1\ : STD_LOGIC;
  signal \dc_difference_carry__2_n_2\ : STD_LOGIC;
  signal \dc_difference_carry__2_n_3\ : STD_LOGIC;
  signal \dc_difference_carry__3_n_0\ : STD_LOGIC;
  signal \dc_difference_carry__3_n_1\ : STD_LOGIC;
  signal \dc_difference_carry__3_n_2\ : STD_LOGIC;
  signal \dc_difference_carry__3_n_3\ : STD_LOGIC;
  signal \dc_difference_carry__4_i_1_n_0\ : STD_LOGIC;
  signal \dc_difference_carry__4_i_2_n_0\ : STD_LOGIC;
  signal \dc_difference_carry__4_n_0\ : STD_LOGIC;
  signal \dc_difference_carry__4_n_1\ : STD_LOGIC;
  signal \dc_difference_carry__4_n_2\ : STD_LOGIC;
  signal \dc_difference_carry__4_n_3\ : STD_LOGIC;
  signal dc_difference_carry_n_0 : STD_LOGIC;
  signal dc_difference_carry_n_1 : STD_LOGIC;
  signal dc_difference_carry_n_2 : STD_LOGIC;
  signal dc_difference_carry_n_3 : STD_LOGIC;
  signal dc_level : STD_LOGIC_VECTOR ( 24 downto 0 );
  signal dc_level0 : STD_LOGIC;
  signal \^dc_level_reg[22]_0\ : STD_LOGIC_VECTOR ( 14 downto 0 );
  signal dc_valid : STD_LOGIC;
  signal dc_valid_i_1_n_0 : STD_LOGIC;
  signal \difference_latched_reg_n_0_[10]\ : STD_LOGIC;
  signal \difference_latched_reg_n_0_[11]\ : STD_LOGIC;
  signal \difference_latched_reg_n_0_[12]\ : STD_LOGIC;
  signal \difference_latched_reg_n_0_[13]\ : STD_LOGIC;
  signal \difference_latched_reg_n_0_[14]\ : STD_LOGIC;
  signal \difference_latched_reg_n_0_[15]\ : STD_LOGIC;
  signal \difference_latched_reg_n_0_[16]\ : STD_LOGIC;
  signal \difference_latched_reg_n_0_[17]\ : STD_LOGIC;
  signal \difference_latched_reg_n_0_[18]\ : STD_LOGIC;
  signal \difference_latched_reg_n_0_[19]\ : STD_LOGIC;
  signal \difference_latched_reg_n_0_[20]\ : STD_LOGIC;
  signal \difference_latched_reg_n_0_[21]\ : STD_LOGIC;
  signal \difference_latched_reg_n_0_[22]\ : STD_LOGIC;
  signal \difference_latched_reg_n_0_[23]\ : STD_LOGIC;
  signal \difference_latched_reg_n_0_[24]\ : STD_LOGIC;
  signal \event_age0_carry__0_n_0\ : STD_LOGIC;
  signal \event_age0_carry__0_n_1\ : STD_LOGIC;
  signal \event_age0_carry__0_n_2\ : STD_LOGIC;
  signal \event_age0_carry__0_n_3\ : STD_LOGIC;
  signal \event_age0_carry__0_n_4\ : STD_LOGIC;
  signal \event_age0_carry__0_n_5\ : STD_LOGIC;
  signal \event_age0_carry__0_n_6\ : STD_LOGIC;
  signal \event_age0_carry__0_n_7\ : STD_LOGIC;
  signal \event_age0_carry__1_n_0\ : STD_LOGIC;
  signal \event_age0_carry__1_n_1\ : STD_LOGIC;
  signal \event_age0_carry__1_n_2\ : STD_LOGIC;
  signal \event_age0_carry__1_n_3\ : STD_LOGIC;
  signal \event_age0_carry__1_n_4\ : STD_LOGIC;
  signal \event_age0_carry__1_n_5\ : STD_LOGIC;
  signal \event_age0_carry__1_n_6\ : STD_LOGIC;
  signal \event_age0_carry__1_n_7\ : STD_LOGIC;
  signal \event_age0_carry__2_n_0\ : STD_LOGIC;
  signal \event_age0_carry__2_n_1\ : STD_LOGIC;
  signal \event_age0_carry__2_n_2\ : STD_LOGIC;
  signal \event_age0_carry__2_n_3\ : STD_LOGIC;
  signal \event_age0_carry__2_n_4\ : STD_LOGIC;
  signal \event_age0_carry__2_n_5\ : STD_LOGIC;
  signal \event_age0_carry__2_n_6\ : STD_LOGIC;
  signal \event_age0_carry__2_n_7\ : STD_LOGIC;
  signal \event_age0_carry__3_n_0\ : STD_LOGIC;
  signal \event_age0_carry__3_n_1\ : STD_LOGIC;
  signal \event_age0_carry__3_n_2\ : STD_LOGIC;
  signal \event_age0_carry__3_n_3\ : STD_LOGIC;
  signal \event_age0_carry__3_n_4\ : STD_LOGIC;
  signal \event_age0_carry__3_n_5\ : STD_LOGIC;
  signal \event_age0_carry__3_n_6\ : STD_LOGIC;
  signal \event_age0_carry__3_n_7\ : STD_LOGIC;
  signal \event_age0_carry__4_n_0\ : STD_LOGIC;
  signal \event_age0_carry__4_n_1\ : STD_LOGIC;
  signal \event_age0_carry__4_n_2\ : STD_LOGIC;
  signal \event_age0_carry__4_n_3\ : STD_LOGIC;
  signal \event_age0_carry__4_n_4\ : STD_LOGIC;
  signal \event_age0_carry__4_n_5\ : STD_LOGIC;
  signal \event_age0_carry__4_n_6\ : STD_LOGIC;
  signal \event_age0_carry__4_n_7\ : STD_LOGIC;
  signal \event_age0_carry__5_n_0\ : STD_LOGIC;
  signal \event_age0_carry__5_n_1\ : STD_LOGIC;
  signal \event_age0_carry__5_n_2\ : STD_LOGIC;
  signal \event_age0_carry__5_n_3\ : STD_LOGIC;
  signal \event_age0_carry__5_n_4\ : STD_LOGIC;
  signal \event_age0_carry__5_n_5\ : STD_LOGIC;
  signal \event_age0_carry__5_n_6\ : STD_LOGIC;
  signal \event_age0_carry__5_n_7\ : STD_LOGIC;
  signal \event_age0_carry__6_n_2\ : STD_LOGIC;
  signal \event_age0_carry__6_n_3\ : STD_LOGIC;
  signal \event_age0_carry__6_n_5\ : STD_LOGIC;
  signal \event_age0_carry__6_n_6\ : STD_LOGIC;
  signal \event_age0_carry__6_n_7\ : STD_LOGIC;
  signal event_age0_carry_n_0 : STD_LOGIC;
  signal event_age0_carry_n_1 : STD_LOGIC;
  signal event_age0_carry_n_2 : STD_LOGIC;
  signal event_age0_carry_n_3 : STD_LOGIC;
  signal event_age0_carry_n_4 : STD_LOGIC;
  signal event_age0_carry_n_5 : STD_LOGIC;
  signal event_age0_carry_n_6 : STD_LOGIC;
  signal event_age0_carry_n_7 : STD_LOGIC;
  signal \event_age[0]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[10]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[11]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[12]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[13]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[14]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[15]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[16]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[17]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[18]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[19]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[1]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[20]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[21]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[22]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[23]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[24]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[25]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[26]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[27]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[28]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[29]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[2]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[30]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[31]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[31]_i_2_n_0\ : STD_LOGIC;
  signal \event_age[31]_i_3_n_0\ : STD_LOGIC;
  signal \event_age[31]_i_4_n_0\ : STD_LOGIC;
  signal \event_age[31]_i_5_n_0\ : STD_LOGIC;
  signal \event_age[31]_i_6_n_0\ : STD_LOGIC;
  signal \event_age[31]_i_7_n_0\ : STD_LOGIC;
  signal \event_age[31]_i_8_n_0\ : STD_LOGIC;
  signal \event_age[3]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[4]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[5]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[6]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[7]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[8]_i_1_n_0\ : STD_LOGIC;
  signal \event_age[9]_i_1_n_0\ : STD_LOGIC;
  signal \event_epoch[31]_i_1_n_0\ : STD_LOGIC;
  signal \^event_epoch_reg[31]_0\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \event_kind[0]_i_1_n_0\ : STD_LOGIC;
  signal \event_kind[1]_i_1_n_0\ : STD_LOGIC;
  signal \event_kind[1]_i_2_n_0\ : STD_LOGIC;
  signal \event_kind[1]_i_3_n_0\ : STD_LOGIC;
  signal \^event_kind_reg[1]_0\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal event_pending4_out : STD_LOGIC;
  signal event_pending_i_1_n_0 : STD_LOGIC;
  signal event_pending_i_2_n_0 : STD_LOGIC;
  signal \event_sample[0]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample[63]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[12]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[12]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[12]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[12]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[12]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[12]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[12]_i_1_n_7\ : STD_LOGIC;
  signal \event_sample_reg[16]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[16]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \event_sample_reg[20]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[20]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[20]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[20]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[20]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[20]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[20]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[20]_i_1_n_7\ : STD_LOGIC;
  signal \event_sample_reg[24]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[24]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \event_sample_reg[28]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[28]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[28]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[28]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[28]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[28]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[28]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[28]_i_1_n_7\ : STD_LOGIC;
  signal \event_sample_reg[32]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[32]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[32]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[32]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[32]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[32]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[32]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[32]_i_1_n_7\ : STD_LOGIC;
  signal \event_sample_reg[36]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[36]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[36]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[36]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[36]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[36]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[36]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[36]_i_1_n_7\ : STD_LOGIC;
  signal \event_sample_reg[40]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[40]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[40]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[40]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[40]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[40]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[40]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[40]_i_1_n_7\ : STD_LOGIC;
  signal \event_sample_reg[44]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[44]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[44]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[44]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[44]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[44]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[44]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[44]_i_1_n_7\ : STD_LOGIC;
  signal \event_sample_reg[48]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[48]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[48]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[48]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[48]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[48]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[48]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[48]_i_1_n_7\ : STD_LOGIC;
  signal \event_sample_reg[4]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[4]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \event_sample_reg[52]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[52]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[52]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[52]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[52]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[52]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[52]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[52]_i_1_n_7\ : STD_LOGIC;
  signal \event_sample_reg[56]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[56]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[56]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[56]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[56]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[56]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[56]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[56]_i_1_n_7\ : STD_LOGIC;
  signal \event_sample_reg[60]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[60]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[60]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[60]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[60]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[60]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[60]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[60]_i_1_n_7\ : STD_LOGIC;
  signal \event_sample_reg[63]_i_2_n_2\ : STD_LOGIC;
  signal \event_sample_reg[63]_i_2_n_3\ : STD_LOGIC;
  signal \event_sample_reg[63]_i_2_n_5\ : STD_LOGIC;
  signal \event_sample_reg[63]_i_2_n_6\ : STD_LOGIC;
  signal \event_sample_reg[63]_i_2_n_7\ : STD_LOGIC;
  signal \event_sample_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \event_sample_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \event_sample_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \event_sample_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \event_sample_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \event_sample_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \event_sample_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \event_sample_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal \event_sequence[0]_i_2_n_0\ : STD_LOGIC;
  signal \event_sequence_reg[0]_i_1_n_0\ : STD_LOGIC;
  signal \event_sequence_reg[0]_i_1_n_1\ : STD_LOGIC;
  signal \event_sequence_reg[0]_i_1_n_2\ : STD_LOGIC;
  signal \event_sequence_reg[0]_i_1_n_3\ : STD_LOGIC;
  signal \event_sequence_reg[0]_i_1_n_4\ : STD_LOGIC;
  signal \event_sequence_reg[0]_i_1_n_5\ : STD_LOGIC;
  signal \event_sequence_reg[0]_i_1_n_6\ : STD_LOGIC;
  signal \event_sequence_reg[0]_i_1_n_7\ : STD_LOGIC;
  signal \event_sequence_reg[12]_i_1_n_0\ : STD_LOGIC;
  signal \event_sequence_reg[12]_i_1_n_1\ : STD_LOGIC;
  signal \event_sequence_reg[12]_i_1_n_2\ : STD_LOGIC;
  signal \event_sequence_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \event_sequence_reg[12]_i_1_n_4\ : STD_LOGIC;
  signal \event_sequence_reg[12]_i_1_n_5\ : STD_LOGIC;
  signal \event_sequence_reg[12]_i_1_n_6\ : STD_LOGIC;
  signal \event_sequence_reg[12]_i_1_n_7\ : STD_LOGIC;
  signal \event_sequence_reg[16]_i_1_n_0\ : STD_LOGIC;
  signal \event_sequence_reg[16]_i_1_n_1\ : STD_LOGIC;
  signal \event_sequence_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \event_sequence_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \event_sequence_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \event_sequence_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \event_sequence_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \event_sequence_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \event_sequence_reg[20]_i_1_n_0\ : STD_LOGIC;
  signal \event_sequence_reg[20]_i_1_n_1\ : STD_LOGIC;
  signal \event_sequence_reg[20]_i_1_n_2\ : STD_LOGIC;
  signal \event_sequence_reg[20]_i_1_n_3\ : STD_LOGIC;
  signal \event_sequence_reg[20]_i_1_n_4\ : STD_LOGIC;
  signal \event_sequence_reg[20]_i_1_n_5\ : STD_LOGIC;
  signal \event_sequence_reg[20]_i_1_n_6\ : STD_LOGIC;
  signal \event_sequence_reg[20]_i_1_n_7\ : STD_LOGIC;
  signal \event_sequence_reg[24]_i_1_n_0\ : STD_LOGIC;
  signal \event_sequence_reg[24]_i_1_n_1\ : STD_LOGIC;
  signal \event_sequence_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \event_sequence_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \event_sequence_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \event_sequence_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \event_sequence_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \event_sequence_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \event_sequence_reg[28]_i_1_n_1\ : STD_LOGIC;
  signal \event_sequence_reg[28]_i_1_n_2\ : STD_LOGIC;
  signal \event_sequence_reg[28]_i_1_n_3\ : STD_LOGIC;
  signal \event_sequence_reg[28]_i_1_n_4\ : STD_LOGIC;
  signal \event_sequence_reg[28]_i_1_n_5\ : STD_LOGIC;
  signal \event_sequence_reg[28]_i_1_n_6\ : STD_LOGIC;
  signal \event_sequence_reg[28]_i_1_n_7\ : STD_LOGIC;
  signal \^event_sequence_reg[31]_0\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \event_sequence_reg[4]_i_1_n_0\ : STD_LOGIC;
  signal \event_sequence_reg[4]_i_1_n_1\ : STD_LOGIC;
  signal \event_sequence_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \event_sequence_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \event_sequence_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \event_sequence_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \event_sequence_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \event_sequence_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \event_sequence_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \event_sequence_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \event_sequence_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \event_sequence_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \event_sequence_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \event_sequence_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \event_sequence_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \event_sequence_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal \event_window[0]_i_1_n_0\ : STD_LOGIC;
  signal \event_window_reg[12]_i_1_n_0\ : STD_LOGIC;
  signal \event_window_reg[12]_i_1_n_1\ : STD_LOGIC;
  signal \event_window_reg[12]_i_1_n_2\ : STD_LOGIC;
  signal \event_window_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \event_window_reg[12]_i_1_n_4\ : STD_LOGIC;
  signal \event_window_reg[12]_i_1_n_5\ : STD_LOGIC;
  signal \event_window_reg[12]_i_1_n_6\ : STD_LOGIC;
  signal \event_window_reg[12]_i_1_n_7\ : STD_LOGIC;
  signal \event_window_reg[16]_i_1_n_0\ : STD_LOGIC;
  signal \event_window_reg[16]_i_1_n_1\ : STD_LOGIC;
  signal \event_window_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \event_window_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \event_window_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \event_window_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \event_window_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \event_window_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \event_window_reg[20]_i_1_n_0\ : STD_LOGIC;
  signal \event_window_reg[20]_i_1_n_1\ : STD_LOGIC;
  signal \event_window_reg[20]_i_1_n_2\ : STD_LOGIC;
  signal \event_window_reg[20]_i_1_n_3\ : STD_LOGIC;
  signal \event_window_reg[20]_i_1_n_4\ : STD_LOGIC;
  signal \event_window_reg[20]_i_1_n_5\ : STD_LOGIC;
  signal \event_window_reg[20]_i_1_n_6\ : STD_LOGIC;
  signal \event_window_reg[20]_i_1_n_7\ : STD_LOGIC;
  signal \event_window_reg[24]_i_1_n_0\ : STD_LOGIC;
  signal \event_window_reg[24]_i_1_n_1\ : STD_LOGIC;
  signal \event_window_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \event_window_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \event_window_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \event_window_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \event_window_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \event_window_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \event_window_reg[28]_i_1_n_0\ : STD_LOGIC;
  signal \event_window_reg[28]_i_1_n_1\ : STD_LOGIC;
  signal \event_window_reg[28]_i_1_n_2\ : STD_LOGIC;
  signal \event_window_reg[28]_i_1_n_3\ : STD_LOGIC;
  signal \event_window_reg[28]_i_1_n_4\ : STD_LOGIC;
  signal \event_window_reg[28]_i_1_n_5\ : STD_LOGIC;
  signal \event_window_reg[28]_i_1_n_6\ : STD_LOGIC;
  signal \event_window_reg[28]_i_1_n_7\ : STD_LOGIC;
  signal \event_window_reg[31]_i_1_n_2\ : STD_LOGIC;
  signal \event_window_reg[31]_i_1_n_3\ : STD_LOGIC;
  signal \event_window_reg[31]_i_1_n_5\ : STD_LOGIC;
  signal \event_window_reg[31]_i_1_n_6\ : STD_LOGIC;
  signal \event_window_reg[31]_i_1_n_7\ : STD_LOGIC;
  signal \event_window_reg[4]_i_1_n_0\ : STD_LOGIC;
  signal \event_window_reg[4]_i_1_n_1\ : STD_LOGIC;
  signal \event_window_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \event_window_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \event_window_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \event_window_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \event_window_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \event_window_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \event_window_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \event_window_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \event_window_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \event_window_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \event_window_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \event_window_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \event_window_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \event_window_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal \faults[0]_i_1_n_0\ : STD_LOGIC;
  signal \faults[1]_i_1_n_0\ : STD_LOGIC;
  signal \faults[1]_i_2_n_0\ : STD_LOGIC;
  signal \faults[1]_i_3_n_0\ : STD_LOGIC;
  signal \faults[1]_i_4_n_0\ : STD_LOGIC;
  signal \faults[2]_i_1_n_0\ : STD_LOGIC;
  signal \faults[2]_i_2_n_0\ : STD_LOGIC;
  signal \faults[3]_i_1_n_0\ : STD_LOGIC;
  signal \faults[4]_i_1_n_0\ : STD_LOGIC;
  signal \faults[4]_i_2_n_0\ : STD_LOGIC;
  signal \faults[4]_i_3_n_0\ : STD_LOGIC;
  signal \faults[4]_i_4_n_0\ : STD_LOGIC;
  signal \faults[4]_i_5_n_0\ : STD_LOGIC;
  signal \faults[5]_i_10_n_0\ : STD_LOGIC;
  signal \faults[5]_i_11_n_0\ : STD_LOGIC;
  signal \faults[5]_i_12_n_0\ : STD_LOGIC;
  signal \faults[5]_i_13_n_0\ : STD_LOGIC;
  signal \faults[5]_i_14_n_0\ : STD_LOGIC;
  signal \faults[5]_i_15_n_0\ : STD_LOGIC;
  signal \faults[5]_i_16_n_0\ : STD_LOGIC;
  signal \faults[5]_i_17_n_0\ : STD_LOGIC;
  signal \faults[5]_i_18_n_0\ : STD_LOGIC;
  signal \faults[5]_i_19_n_0\ : STD_LOGIC;
  signal \faults[5]_i_1_n_0\ : STD_LOGIC;
  signal \faults[5]_i_20_n_0\ : STD_LOGIC;
  signal \faults[5]_i_21_n_0\ : STD_LOGIC;
  signal \faults[5]_i_22_n_0\ : STD_LOGIC;
  signal \faults[5]_i_2_n_0\ : STD_LOGIC;
  signal \faults[5]_i_3_n_0\ : STD_LOGIC;
  signal \faults[5]_i_4_n_0\ : STD_LOGIC;
  signal \faults[5]_i_5_n_0\ : STD_LOGIC;
  signal \faults[5]_i_6_n_0\ : STD_LOGIC;
  signal \faults[5]_i_7_n_0\ : STD_LOGIC;
  signal \faults[5]_i_8_n_0\ : STD_LOGIC;
  signal \faults[5]_i_9_n_0\ : STD_LOGIC;
  signal \faults[6]_i_10_n_0\ : STD_LOGIC;
  signal \faults[6]_i_1_n_0\ : STD_LOGIC;
  signal \faults[6]_i_2_n_0\ : STD_LOGIC;
  signal \faults[6]_i_3_n_0\ : STD_LOGIC;
  signal \faults[6]_i_4_n_0\ : STD_LOGIC;
  signal \faults[6]_i_5_n_0\ : STD_LOGIC;
  signal \faults[6]_i_6_n_0\ : STD_LOGIC;
  signal \faults[6]_i_7_n_0\ : STD_LOGIC;
  signal \faults[6]_i_8_n_0\ : STD_LOGIC;
  signal \faults[6]_i_9_n_0\ : STD_LOGIC;
  signal \faults[7]_i_10_n_0\ : STD_LOGIC;
  signal \faults[7]_i_11_n_0\ : STD_LOGIC;
  signal \faults[7]_i_12_n_0\ : STD_LOGIC;
  signal \faults[7]_i_13_n_0\ : STD_LOGIC;
  signal \faults[7]_i_14_n_0\ : STD_LOGIC;
  signal \faults[7]_i_15_n_0\ : STD_LOGIC;
  signal \faults[7]_i_16_n_0\ : STD_LOGIC;
  signal \faults[7]_i_17_n_0\ : STD_LOGIC;
  signal \faults[7]_i_1_n_0\ : STD_LOGIC;
  signal \faults[7]_i_2_n_0\ : STD_LOGIC;
  signal \faults[7]_i_3_n_0\ : STD_LOGIC;
  signal \faults[7]_i_4_n_0\ : STD_LOGIC;
  signal \faults[7]_i_5_n_0\ : STD_LOGIC;
  signal \faults[7]_i_6_n_0\ : STD_LOGIC;
  signal \faults[7]_i_7_n_0\ : STD_LOGIC;
  signal \faults[7]_i_8_n_0\ : STD_LOGIC;
  signal \faults[7]_i_9_n_0\ : STD_LOGIC;
  signal \^faults_reg[7]_0\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal filtered_clipped : STD_LOGIC;
  signal filtered_latched : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal filtered_valid : STD_LOGIC;
  signal filtered_valid_i_1_n_0 : STD_LOGIC;
  signal high_seen_i_1_n_0 : STD_LOGIC;
  signal high_seen_reg_n_0 : STD_LOGIC;
  signal \i_/i_/i__carry__0_n_0\ : STD_LOGIC;
  signal \i_/i_/i__carry__0_n_1\ : STD_LOGIC;
  signal \i_/i_/i__carry__0_n_2\ : STD_LOGIC;
  signal \i_/i_/i__carry__0_n_3\ : STD_LOGIC;
  signal \i_/i_/i__carry__0_n_4\ : STD_LOGIC;
  signal \i_/i_/i__carry__0_n_5\ : STD_LOGIC;
  signal \i_/i_/i__carry__0_n_6\ : STD_LOGIC;
  signal \i_/i_/i__carry__0_n_7\ : STD_LOGIC;
  signal \i_/i_/i__carry__1_n_0\ : STD_LOGIC;
  signal \i_/i_/i__carry__1_n_1\ : STD_LOGIC;
  signal \i_/i_/i__carry__1_n_2\ : STD_LOGIC;
  signal \i_/i_/i__carry__1_n_3\ : STD_LOGIC;
  signal \i_/i_/i__carry__1_n_4\ : STD_LOGIC;
  signal \i_/i_/i__carry__1_n_5\ : STD_LOGIC;
  signal \i_/i_/i__carry__1_n_6\ : STD_LOGIC;
  signal \i_/i_/i__carry__1_n_7\ : STD_LOGIC;
  signal \i_/i_/i__carry__2_n_0\ : STD_LOGIC;
  signal \i_/i_/i__carry__2_n_1\ : STD_LOGIC;
  signal \i_/i_/i__carry__2_n_2\ : STD_LOGIC;
  signal \i_/i_/i__carry__2_n_3\ : STD_LOGIC;
  signal \i_/i_/i__carry__2_n_4\ : STD_LOGIC;
  signal \i_/i_/i__carry__2_n_5\ : STD_LOGIC;
  signal \i_/i_/i__carry__2_n_6\ : STD_LOGIC;
  signal \i_/i_/i__carry__2_n_7\ : STD_LOGIC;
  signal \i_/i_/i__carry__3_n_1\ : STD_LOGIC;
  signal \i_/i_/i__carry__3_n_2\ : STD_LOGIC;
  signal \i_/i_/i__carry__3_n_3\ : STD_LOGIC;
  signal \i_/i_/i__carry__3_n_4\ : STD_LOGIC;
  signal \i_/i_/i__carry__3_n_5\ : STD_LOGIC;
  signal \i_/i_/i__carry__3_n_6\ : STD_LOGIC;
  signal \i_/i_/i__carry__3_n_7\ : STD_LOGIC;
  signal \i_/i_/i__carry_n_0\ : STD_LOGIC;
  signal \i_/i_/i__carry_n_1\ : STD_LOGIC;
  signal \i_/i_/i__carry_n_2\ : STD_LOGIC;
  signal \i_/i_/i__carry_n_3\ : STD_LOGIC;
  signal \i_/i_/i__carry_n_4\ : STD_LOGIC;
  signal \i_/i_/i__carry_n_5\ : STD_LOGIC;
  signal \i_/i_/i__carry_n_6\ : STD_LOGIC;
  signal \i_/i_/i__carry_n_7\ : STD_LOGIC;
  signal \i__carry__0_i_1_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_2_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_3_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_4_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_1_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_2_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_3_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_4_n_0\ : STD_LOGIC;
  signal \i__carry__2_i_1_n_0\ : STD_LOGIC;
  signal \i__carry__2_i_2_n_0\ : STD_LOGIC;
  signal \i__carry__2_i_3_n_0\ : STD_LOGIC;
  signal \i__carry__2_i_4_n_0\ : STD_LOGIC;
  signal \i__carry__3_i_1_n_0\ : STD_LOGIC;
  signal \i__carry__3_i_2_n_0\ : STD_LOGIC;
  signal \i__carry__3_i_3_n_0\ : STD_LOGIC;
  signal \i__carry__3_i_4_n_0\ : STD_LOGIC;
  signal \i__carry__4_i_1_n_0\ : STD_LOGIC;
  signal \i__carry_i_1__0_n_0\ : STD_LOGIC;
  signal \i__carry_i_1_n_0\ : STD_LOGIC;
  signal \i__carry_i_2_n_0\ : STD_LOGIC;
  signal \i__carry_i_3_n_0\ : STD_LOGIC;
  signal \i__carry_i_4_n_0\ : STD_LOGIC;
  signal \last_sum[31]_i_1_n_0\ : STD_LOGIC;
  signal \last_sum[31]_i_2_n_0\ : STD_LOGIC;
  signal loud_count : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \loud_count[0]_i_1_n_0\ : STD_LOGIC;
  signal \loud_count[1]_i_1_n_0\ : STD_LOGIC;
  signal \loud_count[2]_i_1_n_0\ : STD_LOGIC;
  signal magnitude0 : STD_LOGIC_VECTOR ( 17 downto 1 );
  signal matching_ack0 : STD_LOGIC;
  signal \matching_ack0_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \matching_ack0_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \matching_ack0_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \matching_ack0_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \matching_ack0_carry__0_n_0\ : STD_LOGIC;
  signal \matching_ack0_carry__0_n_1\ : STD_LOGIC;
  signal \matching_ack0_carry__0_n_2\ : STD_LOGIC;
  signal \matching_ack0_carry__0_n_3\ : STD_LOGIC;
  signal \matching_ack0_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \matching_ack0_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \matching_ack0_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \matching_ack0_carry__1_n_2\ : STD_LOGIC;
  signal \matching_ack0_carry__1_n_3\ : STD_LOGIC;
  signal matching_ack0_carry_i_1_n_0 : STD_LOGIC;
  signal matching_ack0_carry_i_2_n_0 : STD_LOGIC;
  signal matching_ack0_carry_i_3_n_0 : STD_LOGIC;
  signal matching_ack0_carry_i_4_n_0 : STD_LOGIC;
  signal matching_ack0_carry_n_0 : STD_LOGIC;
  signal matching_ack0_carry_n_1 : STD_LOGIC;
  signal matching_ack0_carry_n_2 : STD_LOGIC;
  signal matching_ack0_carry_n_3 : STD_LOGIC;
  signal matching_ack1 : STD_LOGIC;
  signal \matching_ack1_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \matching_ack1_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \matching_ack1_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \matching_ack1_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \matching_ack1_carry__0_n_0\ : STD_LOGIC;
  signal \matching_ack1_carry__0_n_1\ : STD_LOGIC;
  signal \matching_ack1_carry__0_n_2\ : STD_LOGIC;
  signal \matching_ack1_carry__0_n_3\ : STD_LOGIC;
  signal \matching_ack1_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \matching_ack1_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \matching_ack1_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \matching_ack1_carry__1_n_2\ : STD_LOGIC;
  signal \matching_ack1_carry__1_n_3\ : STD_LOGIC;
  signal matching_ack1_carry_i_1_n_0 : STD_LOGIC;
  signal matching_ack1_carry_i_2_n_0 : STD_LOGIC;
  signal matching_ack1_carry_i_3_n_0 : STD_LOGIC;
  signal matching_ack1_carry_i_4_n_0 : STD_LOGIC;
  signal matching_ack1_carry_n_0 : STD_LOGIC;
  signal matching_ack1_carry_n_1 : STD_LOGIC;
  signal matching_ack1_carry_n_2 : STD_LOGIC;
  signal matching_ack1_carry_n_3 : STD_LOGIC;
  signal next_clipped : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal \next_clipped__0\ : STD_LOGIC_VECTOR ( 16 to 16 );
  signal next_dc00 : STD_LOGIC;
  signal \next_dc_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \next_dc_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \next_dc_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \next_dc_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \next_dc_carry__0_n_0\ : STD_LOGIC;
  signal \next_dc_carry__0_n_1\ : STD_LOGIC;
  signal \next_dc_carry__0_n_2\ : STD_LOGIC;
  signal \next_dc_carry__0_n_3\ : STD_LOGIC;
  signal \next_dc_carry__0_n_4\ : STD_LOGIC;
  signal \next_dc_carry__0_n_5\ : STD_LOGIC;
  signal \next_dc_carry__0_n_6\ : STD_LOGIC;
  signal \next_dc_carry__0_n_7\ : STD_LOGIC;
  signal \next_dc_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \next_dc_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \next_dc_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \next_dc_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \next_dc_carry__1_n_0\ : STD_LOGIC;
  signal \next_dc_carry__1_n_1\ : STD_LOGIC;
  signal \next_dc_carry__1_n_2\ : STD_LOGIC;
  signal \next_dc_carry__1_n_3\ : STD_LOGIC;
  signal \next_dc_carry__1_n_4\ : STD_LOGIC;
  signal \next_dc_carry__1_n_5\ : STD_LOGIC;
  signal \next_dc_carry__1_n_6\ : STD_LOGIC;
  signal \next_dc_carry__1_n_7\ : STD_LOGIC;
  signal \next_dc_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \next_dc_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \next_dc_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \next_dc_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \next_dc_carry__2_n_0\ : STD_LOGIC;
  signal \next_dc_carry__2_n_1\ : STD_LOGIC;
  signal \next_dc_carry__2_n_2\ : STD_LOGIC;
  signal \next_dc_carry__2_n_3\ : STD_LOGIC;
  signal \next_dc_carry__2_n_4\ : STD_LOGIC;
  signal \next_dc_carry__2_n_5\ : STD_LOGIC;
  signal \next_dc_carry__2_n_6\ : STD_LOGIC;
  signal \next_dc_carry__2_n_7\ : STD_LOGIC;
  signal \next_dc_carry__3_i_1_n_0\ : STD_LOGIC;
  signal \next_dc_carry__3_i_2_n_0\ : STD_LOGIC;
  signal \next_dc_carry__3_i_3_n_0\ : STD_LOGIC;
  signal \next_dc_carry__3_i_4_n_0\ : STD_LOGIC;
  signal \next_dc_carry__3_i_5_n_0\ : STD_LOGIC;
  signal \next_dc_carry__3_n_0\ : STD_LOGIC;
  signal \next_dc_carry__3_n_1\ : STD_LOGIC;
  signal \next_dc_carry__3_n_2\ : STD_LOGIC;
  signal \next_dc_carry__3_n_3\ : STD_LOGIC;
  signal \next_dc_carry__3_n_4\ : STD_LOGIC;
  signal \next_dc_carry__3_n_5\ : STD_LOGIC;
  signal \next_dc_carry__3_n_6\ : STD_LOGIC;
  signal \next_dc_carry__3_n_7\ : STD_LOGIC;
  signal \next_dc_carry__4_i_1_n_0\ : STD_LOGIC;
  signal \next_dc_carry__4_i_2_n_0\ : STD_LOGIC;
  signal \next_dc_carry__4_i_3_n_0\ : STD_LOGIC;
  signal \next_dc_carry__4_i_4_n_0\ : STD_LOGIC;
  signal \next_dc_carry__4_n_0\ : STD_LOGIC;
  signal \next_dc_carry__4_n_1\ : STD_LOGIC;
  signal \next_dc_carry__4_n_2\ : STD_LOGIC;
  signal \next_dc_carry__4_n_3\ : STD_LOGIC;
  signal \next_dc_carry__4_n_4\ : STD_LOGIC;
  signal \next_dc_carry__4_n_5\ : STD_LOGIC;
  signal \next_dc_carry__4_n_6\ : STD_LOGIC;
  signal \next_dc_carry__4_n_7\ : STD_LOGIC;
  signal \next_dc_carry__5_i_1_n_0\ : STD_LOGIC;
  signal \next_dc_carry__5_n_2\ : STD_LOGIC;
  signal \next_dc_carry__5_n_7\ : STD_LOGIC;
  signal next_dc_carry_i_1_n_0 : STD_LOGIC;
  signal next_dc_carry_i_2_n_0 : STD_LOGIC;
  signal next_dc_carry_i_3_n_0 : STD_LOGIC;
  signal next_dc_carry_i_4_n_0 : STD_LOGIC;
  signal next_dc_carry_n_0 : STD_LOGIC;
  signal next_dc_carry_n_1 : STD_LOGIC;
  signal next_dc_carry_n_2 : STD_LOGIC;
  signal next_dc_carry_n_3 : STD_LOGIC;
  signal next_dc_carry_n_4 : STD_LOGIC;
  signal next_dc_carry_n_5 : STD_LOGIC;
  signal next_dc_carry_n_6 : STD_LOGIC;
  signal next_dc_carry_n_7 : STD_LOGIC;
  signal \^out\ : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal p_0_in : STD_LOGIC;
  signal p_0_out : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \p_0_out_inferred__3/i__carry__0_n_0\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__0_n_1\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__0_n_2\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__0_n_3\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__1_n_0\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__1_n_1\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__1_n_2\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__1_n_3\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__2_n_0\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__2_n_1\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__2_n_2\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__2_n_3\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__3_n_0\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__3_n_1\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__3_n_2\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__3_n_3\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__4_n_2\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry__4_n_3\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry_n_0\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry_n_1\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry_n_2\ : STD_LOGIC;
  signal \p_0_out_inferred__3/i__carry_n_3\ : STD_LOGIC;
  signal p_1_in : STD_LOGIC;
  signal quiet : STD_LOGIC;
  signal \quiet_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \quiet_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \quiet_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \quiet_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \quiet_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \quiet_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \quiet_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \quiet_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \quiet_carry__0_n_0\ : STD_LOGIC;
  signal \quiet_carry__0_n_1\ : STD_LOGIC;
  signal \quiet_carry__0_n_2\ : STD_LOGIC;
  signal \quiet_carry__0_n_3\ : STD_LOGIC;
  signal \quiet_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \quiet_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \quiet_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \quiet_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \quiet_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \quiet_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \quiet_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \quiet_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \quiet_carry__1_n_0\ : STD_LOGIC;
  signal \quiet_carry__1_n_1\ : STD_LOGIC;
  signal \quiet_carry__1_n_2\ : STD_LOGIC;
  signal \quiet_carry__1_n_3\ : STD_LOGIC;
  signal \quiet_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \quiet_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \quiet_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \quiet_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \quiet_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \quiet_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \quiet_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \quiet_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \quiet_carry__2_n_0\ : STD_LOGIC;
  signal \quiet_carry__2_n_1\ : STD_LOGIC;
  signal \quiet_carry__2_n_2\ : STD_LOGIC;
  signal \quiet_carry__2_n_3\ : STD_LOGIC;
  signal \quiet_carry__3_i_1_n_0\ : STD_LOGIC;
  signal quiet_carry_i_1_n_0 : STD_LOGIC;
  signal quiet_carry_i_2_n_0 : STD_LOGIC;
  signal quiet_carry_i_3_n_0 : STD_LOGIC;
  signal quiet_carry_i_4_n_0 : STD_LOGIC;
  signal quiet_carry_i_5_n_0 : STD_LOGIC;
  signal quiet_carry_i_6_n_0 : STD_LOGIC;
  signal quiet_carry_i_7_n_0 : STD_LOGIC;
  signal quiet_carry_i_8_n_0 : STD_LOGIC;
  signal quiet_carry_n_0 : STD_LOGIC;
  signal quiet_carry_n_1 : STD_LOGIC;
  signal quiet_carry_n_2 : STD_LOGIC;
  signal quiet_carry_n_3 : STD_LOGIC;
  signal \quiet_count[0]_i_1_n_0\ : STD_LOGIC;
  signal \quiet_count[1]_i_1_n_0\ : STD_LOGIC;
  signal \quiet_count[2]_i_1_n_0\ : STD_LOGIC;
  signal \quiet_count_reg_n_0_[0]\ : STD_LOGIC;
  signal \quiet_count_reg_n_0_[1]\ : STD_LOGIC;
  signal \quiet_count_reg_n_0_[2]\ : STD_LOGIC;
  signal \^s_axi_aresetn_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[7]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[9]_i_4_n_0\ : STD_LOGIC;
  signal sample_age : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \sample_age[0]_i_1_n_0\ : STD_LOGIC;
  signal \sample_age[0]_i_3_n_0\ : STD_LOGIC;
  signal \sample_age[0]_i_4_n_0\ : STD_LOGIC;
  signal \sample_age[0]_i_5_n_0\ : STD_LOGIC;
  signal \sample_age[0]_i_6_n_0\ : STD_LOGIC;
  signal sample_age_reg : STD_LOGIC_VECTOR ( 19 downto 0 );
  signal \sample_count[0]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count[0]_i_3_n_0\ : STD_LOGIC;
  signal \sample_count_reg[0]_i_2_n_0\ : STD_LOGIC;
  signal \sample_count_reg[0]_i_2_n_1\ : STD_LOGIC;
  signal \sample_count_reg[0]_i_2_n_2\ : STD_LOGIC;
  signal \sample_count_reg[0]_i_2_n_3\ : STD_LOGIC;
  signal \sample_count_reg[0]_i_2_n_4\ : STD_LOGIC;
  signal \sample_count_reg[0]_i_2_n_5\ : STD_LOGIC;
  signal \sample_count_reg[0]_i_2_n_6\ : STD_LOGIC;
  signal \sample_count_reg[0]_i_2_n_7\ : STD_LOGIC;
  signal \sample_count_reg[12]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count_reg[12]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[12]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[12]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[12]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[12]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[12]_i_1_n_7\ : STD_LOGIC;
  signal \sample_count_reg[16]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count_reg[16]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \sample_count_reg[20]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count_reg[20]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[20]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[20]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[20]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[20]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[20]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[20]_i_1_n_7\ : STD_LOGIC;
  signal \sample_count_reg[24]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count_reg[24]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \sample_count_reg[28]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count_reg[28]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[28]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[28]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[28]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[28]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[28]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[28]_i_1_n_7\ : STD_LOGIC;
  signal \sample_count_reg[32]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count_reg[32]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[32]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[32]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[32]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[32]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[32]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[32]_i_1_n_7\ : STD_LOGIC;
  signal \sample_count_reg[36]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count_reg[36]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[36]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[36]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[36]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[36]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[36]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[36]_i_1_n_7\ : STD_LOGIC;
  signal \sample_count_reg[40]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count_reg[40]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[40]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[40]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[40]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[40]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[40]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[40]_i_1_n_7\ : STD_LOGIC;
  signal \sample_count_reg[44]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count_reg[44]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[44]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[44]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[44]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[44]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[44]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[44]_i_1_n_7\ : STD_LOGIC;
  signal \sample_count_reg[48]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count_reg[48]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[48]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[48]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[48]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[48]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[48]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[48]_i_1_n_7\ : STD_LOGIC;
  signal \sample_count_reg[4]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count_reg[4]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \sample_count_reg[52]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count_reg[52]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[52]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[52]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[52]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[52]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[52]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[52]_i_1_n_7\ : STD_LOGIC;
  signal \sample_count_reg[56]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count_reg[56]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[56]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[56]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[56]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[56]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[56]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[56]_i_1_n_7\ : STD_LOGIC;
  signal \sample_count_reg[60]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[60]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[60]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[60]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[60]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[60]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[60]_i_1_n_7\ : STD_LOGIC;
  signal \sample_count_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \sample_count_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \sample_count_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \sample_count_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \sample_count_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \sample_count_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \sample_count_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \sample_count_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal sample_in_window : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \sample_in_window[0]_i_2_n_0\ : STD_LOGIC;
  signal \sample_in_window[6]_i_2_n_0\ : STD_LOGIC;
  signal \sample_in_window[9]_i_1_n_0\ : STD_LOGIC;
  signal \sample_in_window[9]_i_3_n_0\ : STD_LOGIC;
  signal \sample_in_window[9]_i_4_n_0\ : STD_LOGIC;
  signal \sample_in_window_reg_n_0_[0]\ : STD_LOGIC;
  signal \sample_in_window_reg_n_0_[1]\ : STD_LOGIC;
  signal \sample_in_window_reg_n_0_[2]\ : STD_LOGIC;
  signal \sample_in_window_reg_n_0_[3]\ : STD_LOGIC;
  signal \sample_in_window_reg_n_0_[4]\ : STD_LOGIC;
  signal \sample_in_window_reg_n_0_[5]\ : STD_LOGIC;
  signal \sample_in_window_reg_n_0_[6]\ : STD_LOGIC;
  signal \sample_in_window_reg_n_0_[7]\ : STD_LOGIC;
  signal \sample_in_window_reg_n_0_[8]\ : STD_LOGIC;
  signal \sample_in_window_reg_n_0_[9]\ : STD_LOGIC;
  signal scaled_latched : STD_LOGIC_VECTOR ( 24 downto 8 );
  signal scaled_latched0 : STD_LOGIC;
  signal soft_count : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \soft_count[0]_i_1_n_0\ : STD_LOGIC;
  signal \soft_count[1]_i_1_n_0\ : STD_LOGIC;
  signal \soft_count[2]_i_1_n_0\ : STD_LOGIC;
  signal \soft_count_reg_n_0_[0]\ : STD_LOGIC;
  signal \soft_count_reg_n_0_[1]\ : STD_LOGIC;
  signal \soft_count_reg_n_0_[2]\ : STD_LOGIC;
  signal state20_in : STD_LOGIC;
  signal \state2_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \state2_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \state2_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \state2_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \state2_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \state2_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \state2_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \state2_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \state2_carry__0_n_0\ : STD_LOGIC;
  signal \state2_carry__0_n_1\ : STD_LOGIC;
  signal \state2_carry__0_n_2\ : STD_LOGIC;
  signal \state2_carry__0_n_3\ : STD_LOGIC;
  signal \state2_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \state2_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \state2_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \state2_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \state2_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \state2_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \state2_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \state2_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \state2_carry__1_n_0\ : STD_LOGIC;
  signal \state2_carry__1_n_1\ : STD_LOGIC;
  signal \state2_carry__1_n_2\ : STD_LOGIC;
  signal \state2_carry__1_n_3\ : STD_LOGIC;
  signal \state2_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \state2_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \state2_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \state2_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \state2_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \state2_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \state2_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \state2_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \state2_carry__2_n_1\ : STD_LOGIC;
  signal \state2_carry__2_n_2\ : STD_LOGIC;
  signal \state2_carry__2_n_3\ : STD_LOGIC;
  signal state2_carry_i_1_n_0 : STD_LOGIC;
  signal state2_carry_i_2_n_0 : STD_LOGIC;
  signal state2_carry_i_3_n_0 : STD_LOGIC;
  signal state2_carry_i_4_n_0 : STD_LOGIC;
  signal state2_carry_i_5_n_0 : STD_LOGIC;
  signal state2_carry_i_6_n_0 : STD_LOGIC;
  signal state2_carry_i_7_n_0 : STD_LOGIC;
  signal state2_carry_i_8_n_0 : STD_LOGIC;
  signal state2_carry_n_0 : STD_LOGIC;
  signal state2_carry_n_1 : STD_LOGIC;
  signal state2_carry_n_2 : STD_LOGIC;
  signal state2_carry_n_3 : STD_LOGIC;
  signal state3 : STD_LOGIC;
  signal \state3_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \state3_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \state3_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \state3_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \state3_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \state3_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \state3_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \state3_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \state3_carry__0_n_0\ : STD_LOGIC;
  signal \state3_carry__0_n_1\ : STD_LOGIC;
  signal \state3_carry__0_n_2\ : STD_LOGIC;
  signal \state3_carry__0_n_3\ : STD_LOGIC;
  signal \state3_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \state3_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \state3_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \state3_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \state3_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \state3_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \state3_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \state3_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \state3_carry__1_n_0\ : STD_LOGIC;
  signal \state3_carry__1_n_1\ : STD_LOGIC;
  signal \state3_carry__1_n_2\ : STD_LOGIC;
  signal \state3_carry__1_n_3\ : STD_LOGIC;
  signal \state3_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \state3_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \state3_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \state3_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \state3_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \state3_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \state3_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \state3_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \state3_carry__2_n_1\ : STD_LOGIC;
  signal \state3_carry__2_n_2\ : STD_LOGIC;
  signal \state3_carry__2_n_3\ : STD_LOGIC;
  signal state3_carry_i_1_n_0 : STD_LOGIC;
  signal state3_carry_i_2_n_0 : STD_LOGIC;
  signal state3_carry_i_3_n_0 : STD_LOGIC;
  signal state3_carry_i_4_n_0 : STD_LOGIC;
  signal state3_carry_i_5_n_0 : STD_LOGIC;
  signal state3_carry_i_6_n_0 : STD_LOGIC;
  signal state3_carry_i_7_n_0 : STD_LOGIC;
  signal state3_carry_i_8_n_0 : STD_LOGIC;
  signal state3_carry_n_0 : STD_LOGIC;
  signal state3_carry_n_1 : STD_LOGIC;
  signal state3_carry_n_2 : STD_LOGIC;
  signal state3_carry_n_3 : STD_LOGIC;
  signal \state[0]_i_1_n_0\ : STD_LOGIC;
  signal \state[1]_i_1_n_0\ : STD_LOGIC;
  signal \state[1]_i_2_n_0\ : STD_LOGIC;
  signal \state[2]_i_1_n_0\ : STD_LOGIC;
  signal \state[2]_i_2_n_0\ : STD_LOGIC;
  signal \state[2]_i_3_n_0\ : STD_LOGIC;
  signal \state[2]_i_4_n_0\ : STD_LOGIC;
  signal \state[2]_i_5_n_0\ : STD_LOGIC;
  signal \state[2]_i_6_n_0\ : STD_LOGIC;
  signal \state[2]_i_7_n_0\ : STD_LOGIC;
  signal \state[2]_i_8_n_0\ : STD_LOGIC;
  signal \state[2]_i_9_n_0\ : STD_LOGIC;
  signal \^status\ : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal \window_count[0]_i_2_n_0\ : STD_LOGIC;
  signal \window_count_reg[0]_i_1_n_0\ : STD_LOGIC;
  signal \window_count_reg[0]_i_1_n_1\ : STD_LOGIC;
  signal \window_count_reg[0]_i_1_n_2\ : STD_LOGIC;
  signal \window_count_reg[0]_i_1_n_3\ : STD_LOGIC;
  signal \window_count_reg[0]_i_1_n_4\ : STD_LOGIC;
  signal \window_count_reg[0]_i_1_n_5\ : STD_LOGIC;
  signal \window_count_reg[0]_i_1_n_6\ : STD_LOGIC;
  signal \window_count_reg[0]_i_1_n_7\ : STD_LOGIC;
  signal \window_count_reg[12]_i_1_n_0\ : STD_LOGIC;
  signal \window_count_reg[12]_i_1_n_1\ : STD_LOGIC;
  signal \window_count_reg[12]_i_1_n_2\ : STD_LOGIC;
  signal \window_count_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \window_count_reg[12]_i_1_n_4\ : STD_LOGIC;
  signal \window_count_reg[12]_i_1_n_5\ : STD_LOGIC;
  signal \window_count_reg[12]_i_1_n_6\ : STD_LOGIC;
  signal \window_count_reg[12]_i_1_n_7\ : STD_LOGIC;
  signal \window_count_reg[16]_i_1_n_0\ : STD_LOGIC;
  signal \window_count_reg[16]_i_1_n_1\ : STD_LOGIC;
  signal \window_count_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \window_count_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \window_count_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \window_count_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \window_count_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \window_count_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \window_count_reg[20]_i_1_n_0\ : STD_LOGIC;
  signal \window_count_reg[20]_i_1_n_1\ : STD_LOGIC;
  signal \window_count_reg[20]_i_1_n_2\ : STD_LOGIC;
  signal \window_count_reg[20]_i_1_n_3\ : STD_LOGIC;
  signal \window_count_reg[20]_i_1_n_4\ : STD_LOGIC;
  signal \window_count_reg[20]_i_1_n_5\ : STD_LOGIC;
  signal \window_count_reg[20]_i_1_n_6\ : STD_LOGIC;
  signal \window_count_reg[20]_i_1_n_7\ : STD_LOGIC;
  signal \window_count_reg[24]_i_1_n_0\ : STD_LOGIC;
  signal \window_count_reg[24]_i_1_n_1\ : STD_LOGIC;
  signal \window_count_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \window_count_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \window_count_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \window_count_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \window_count_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \window_count_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \window_count_reg[28]_i_1_n_1\ : STD_LOGIC;
  signal \window_count_reg[28]_i_1_n_2\ : STD_LOGIC;
  signal \window_count_reg[28]_i_1_n_3\ : STD_LOGIC;
  signal \window_count_reg[28]_i_1_n_4\ : STD_LOGIC;
  signal \window_count_reg[28]_i_1_n_5\ : STD_LOGIC;
  signal \window_count_reg[28]_i_1_n_6\ : STD_LOGIC;
  signal \window_count_reg[28]_i_1_n_7\ : STD_LOGIC;
  signal \^window_count_reg[31]_0\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \window_count_reg[4]_i_1_n_0\ : STD_LOGIC;
  signal \window_count_reg[4]_i_1_n_1\ : STD_LOGIC;
  signal \window_count_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \window_count_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \window_count_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \window_count_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \window_count_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \window_count_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \window_count_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \window_count_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \window_count_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \window_count_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \window_count_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \window_count_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \window_count_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \window_count_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal NLW_above_loud_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_above_loud_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_above_loud_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_above_loud_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_above_loud_carry__3_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_above_loud_carry__3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_above_soft_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_above_soft_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_above_soft_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_above_soft_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_above_soft_carry__3_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_above_soft_carry__3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_above_soft_carry__3_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_above_soft_carry__3_i_1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_accumulation_reg[19]_i_4_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_accumulation_reg[19]_i_4_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal NLW_centered_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_centered_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_centered_carry__5_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_centered_carry__5_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal NLW_dc_difference_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_dc_difference_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_dc_difference_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \NLW_dc_difference_carry__5_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_dc_difference_carry__5_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_event_age0_carry__6_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_event_age0_carry__6_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_event_sample_reg[63]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_event_sample_reg[63]_i_2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_event_sequence_reg[28]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_event_window_reg[31]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_event_window_reg[31]_i_1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_faults_reg[6]_i_11_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_faults_reg[6]_i_11_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_i_/i_/i__carry__3_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal NLW_matching_ack0_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_matching_ack0_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_matching_ack0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_matching_ack0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_matching_ack1_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_matching_ack1_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_matching_ack1_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_matching_ack1_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_next_dc_carry__5_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_next_dc_carry__5_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_p_0_out_inferred__3/i__carry_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_p_0_out_inferred__3/i__carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_p_0_out_inferred__3/i__carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_p_0_out_inferred__3/i__carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_p_0_out_inferred__3/i__carry__3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_p_0_out_inferred__3/i__carry__4_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_p_0_out_inferred__3/i__carry__4_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_quiet_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_quiet_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_quiet_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_quiet_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_quiet_carry__3_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_quiet_carry__3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_sample_count_reg[60]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal NLW_state2_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_state2_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_state2_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_state2_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_state3_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_state3_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_state3_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_state3_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_window_count_reg[28]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  attribute COMPARATOR_THRESHOLD : integer;
  attribute COMPARATOR_THRESHOLD of above_loud_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \above_loud_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \above_loud_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \above_loud_carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \above_loud_carry__3\ : label is 11;
  attribute COMPARATOR_THRESHOLD of above_soft_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \above_soft_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \above_soft_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \above_soft_carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \above_soft_carry__3\ : label is 11;
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of \accumulation_reg[11]_i_6\ : label is 35;
  attribute ADDER_THRESHOLD of \accumulation_reg[15]_i_6\ : label is 35;
  attribute ADDER_THRESHOLD of \accumulation_reg[19]_i_4\ : label is 35;
  attribute ADDER_THRESHOLD of \accumulation_reg[19]_i_5\ : label is 35;
  attribute ADDER_THRESHOLD of \accumulation_reg[7]_i_6\ : label is 35;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of ack_error_i_2 : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of ack_error_i_3 : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \candidate_count[0]_i_1\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of \candidate_count[1]_i_1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \candidate_count[2]_i_2\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \candidate_count[2]_i_5\ : label is "soft_lutpair34";
  attribute ADDER_THRESHOLD of centered_carry : label is 35;
  attribute ADDER_THRESHOLD of \centered_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \centered_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \centered_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of \centered_carry__3\ : label is 35;
  attribute ADDER_THRESHOLD of \centered_carry__4\ : label is 35;
  attribute ADDER_THRESHOLD of \centered_carry__5\ : label is 35;
  attribute SOFT_HLUTNM of \clipped_count[15]_i_4\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of dc_valid_i_1 : label is "soft_lutpair38";
  attribute ADDER_THRESHOLD of event_age0_carry : label is 35;
  attribute ADDER_THRESHOLD of \event_age0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \event_age0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_age0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of \event_age0_carry__3\ : label is 35;
  attribute ADDER_THRESHOLD of \event_age0_carry__4\ : label is 35;
  attribute ADDER_THRESHOLD of \event_age0_carry__5\ : label is 35;
  attribute ADDER_THRESHOLD of \event_age0_carry__6\ : label is 35;
  attribute SOFT_HLUTNM of \event_age[0]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \event_age[10]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \event_age[11]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \event_age[12]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \event_age[13]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \event_age[14]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \event_age[15]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \event_age[16]_i_1\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \event_age[17]_i_1\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \event_age[18]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \event_age[19]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \event_age[1]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \event_age[20]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \event_age[21]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \event_age[22]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \event_age[23]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \event_age[24]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \event_age[25]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \event_age[26]_i_1\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \event_age[27]_i_1\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \event_age[28]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \event_age[29]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \event_age[2]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \event_age[30]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \event_age[31]_i_2\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \event_age[31]_i_8\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \event_age[3]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \event_age[4]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \event_age[5]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \event_age[6]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \event_age[7]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \event_age[8]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \event_age[9]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \event_kind[1]_i_3\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of event_pending_i_2 : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of event_pending_i_3 : label is "soft_lutpair41";
  attribute ADDER_THRESHOLD of \event_sample_reg[12]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[16]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[20]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[24]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[28]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[32]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[36]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[40]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[44]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[48]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[4]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[52]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[56]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[60]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[63]_i_2\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sample_reg[8]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sequence_reg[0]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sequence_reg[12]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sequence_reg[16]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sequence_reg[20]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sequence_reg[24]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sequence_reg[28]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sequence_reg[4]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_sequence_reg[8]_i_1\ : label is 35;
  attribute SOFT_HLUTNM of \event_window[0]_i_1\ : label is "soft_lutpair11";
  attribute ADDER_THRESHOLD of \event_window_reg[12]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_window_reg[16]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_window_reg[20]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_window_reg[24]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_window_reg[28]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_window_reg[31]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_window_reg[4]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \event_window_reg[8]_i_1\ : label is 35;
  attribute SOFT_HLUTNM of \faults[0]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \faults[3]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \faults[4]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \faults[5]_i_11\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \faults[5]_i_2\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \faults[5]_i_7\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \faults[6]_i_2\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \faults[6]_i_3\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \faults[7]_i_11\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \faults[7]_i_17\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \faults[7]_i_6\ : label is "soft_lutpair41";
  attribute SOFT_HLUTNM of filtered_valid_i_1 : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of high_seen_i_1 : label is "soft_lutpair42";
  attribute ADDER_THRESHOLD of \i_/i_/i__carry\ : label is 35;
  attribute ADDER_THRESHOLD of \i_/i_/i__carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \i_/i_/i__carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \i_/i_/i__carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of \i_/i_/i__carry__3\ : label is 35;
  attribute SOFT_HLUTNM of \loud_count[0]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \loud_count[1]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \loud_count[2]_i_1\ : label is "soft_lutpair12";
  attribute COMPARATOR_THRESHOLD of quiet_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \quiet_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \quiet_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \quiet_carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \quiet_carry__3\ : label is 11;
  attribute SOFT_HLUTNM of \s_axi_rdata[2]_i_5\ : label is "soft_lutpair34";
  attribute ADDER_THRESHOLD of \sample_count_reg[0]_i_2\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[12]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[16]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[20]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[24]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[28]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[32]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[36]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[40]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[44]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[48]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[4]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[52]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[56]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[60]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \sample_count_reg[8]_i_1\ : label is 35;
  attribute SOFT_HLUTNM of \sample_in_window[1]_i_1\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of \sample_in_window[2]_i_1\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \sample_in_window[3]_i_1\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \sample_in_window[6]_i_2\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of \sample_in_window[7]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \sample_in_window[8]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \sample_in_window[9]_i_2\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \snapshot[0][2]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \soft_count[0]_i_1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \soft_count[1]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \soft_count[2]_i_1\ : label is "soft_lutpair13";
  attribute COMPARATOR_THRESHOLD of state2_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \state2_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \state2_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \state2_carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of state3_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \state3_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \state3_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \state3_carry__2\ : label is 11;
  attribute SOFT_HLUTNM of \state[0]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \state[1]_i_2\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \state[2]_i_2\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \state[2]_i_7\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \state[2]_i_8\ : label is "soft_lutpair40";
  attribute ADDER_THRESHOLD of \window_count_reg[0]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \window_count_reg[12]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \window_count_reg[16]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \window_count_reg[20]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \window_count_reg[24]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \window_count_reg[28]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \window_count_reg[4]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \window_count_reg[8]_i_1\ : label is 35;
begin
  Q(31 downto 0) <= \^q\(31 downto 0);
  \dc_level_reg[22]_0\(14 downto 0) <= \^dc_level_reg[22]_0\(14 downto 0);
  \event_epoch_reg[31]_0\(31 downto 0) <= \^event_epoch_reg[31]_0\(31 downto 0);
  \event_kind_reg[1]_0\(1 downto 0) <= \^event_kind_reg[1]_0\(1 downto 0);
  \event_sequence_reg[31]_0\(31 downto 0) <= \^event_sequence_reg[31]_0\(31 downto 0);
  \faults_reg[7]_0\(7 downto 0) <= \^faults_reg[7]_0\(7 downto 0);
  \out\(63 downto 0) <= \^out\(63 downto 0);
  s_axi_aresetn_0 <= \^s_axi_aresetn_0\;
  status(4 downto 0) <= \^status\(4 downto 0);
  \window_count_reg[31]_0\(31 downto 0) <= \^window_count_reg[31]_0\(31 downto 0);
above_loud_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => above_loud_carry_n_0,
      CO(2) => above_loud_carry_n_1,
      CO(1) => above_loud_carry_n_2,
      CO(0) => above_loud_carry_n_3,
      CYINIT => '1',
      DI(3) => above_loud_carry_i_1_n_0,
      DI(2) => above_loud_carry_i_2_n_0,
      DI(1) => above_loud_carry_i_3_n_0,
      DI(0) => above_loud_carry_i_4_n_0,
      O(3 downto 0) => NLW_above_loud_carry_O_UNCONNECTED(3 downto 0),
      S(3) => above_loud_carry_i_5_n_0,
      S(2) => above_loud_carry_i_6_n_0,
      S(1) => above_loud_carry_i_7_n_0,
      S(0) => above_loud_carry_i_8_n_0
    );
\above_loud_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => above_loud_carry_n_0,
      CO(3) => \above_loud_carry__0_n_0\,
      CO(2) => \above_loud_carry__0_n_1\,
      CO(1) => \above_loud_carry__0_n_2\,
      CO(0) => \above_loud_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \above_loud_carry__0_i_1_n_0\,
      DI(2) => \above_loud_carry__0_i_2_n_0\,
      DI(1) => \above_loud_carry__0_i_3_n_0\,
      DI(0) => \above_loud_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_above_loud_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \above_loud_carry__0_i_5_n_0\,
      S(2) => \above_loud_carry__0_i_6_n_0\,
      S(1) => \above_loud_carry__0_i_7_n_0\,
      S(0) => \above_loud_carry__0_i_8_n_0\
    );
\above_loud_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(15),
      I1 => \accumulation_reg[15]_i_1_n_4\,
      I2 => \accumulation_reg[15]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(14),
      O => \above_loud_carry__0_i_1_n_0\
    );
\above_loud_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(13),
      I1 => \accumulation_reg[15]_i_1_n_6\,
      I2 => \accumulation_reg[15]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(12),
      O => \above_loud_carry__0_i_2_n_0\
    );
\above_loud_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(11),
      I1 => \accumulation_reg[11]_i_1_n_4\,
      I2 => \accumulation_reg[11]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(10),
      O => \above_loud_carry__0_i_3_n_0\
    );
\above_loud_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(9),
      I1 => \accumulation_reg[11]_i_1_n_6\,
      I2 => \accumulation_reg[11]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(8),
      O => \above_loud_carry__0_i_4_n_0\
    );
\above_loud_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[15]_i_1_n_4\,
      I1 => \above_loud_carry__2_0\(15),
      I2 => \accumulation_reg[15]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(14),
      O => \above_loud_carry__0_i_5_n_0\
    );
\above_loud_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[15]_i_1_n_6\,
      I1 => \above_loud_carry__2_0\(13),
      I2 => \accumulation_reg[15]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(12),
      O => \above_loud_carry__0_i_6_n_0\
    );
\above_loud_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[11]_i_1_n_4\,
      I1 => \above_loud_carry__2_0\(11),
      I2 => \accumulation_reg[11]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(10),
      O => \above_loud_carry__0_i_7_n_0\
    );
\above_loud_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[11]_i_1_n_6\,
      I1 => \above_loud_carry__2_0\(9),
      I2 => \accumulation_reg[11]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(8),
      O => \above_loud_carry__0_i_8_n_0\
    );
\above_loud_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \above_loud_carry__0_n_0\,
      CO(3) => \above_loud_carry__1_n_0\,
      CO(2) => \above_loud_carry__1_n_1\,
      CO(1) => \above_loud_carry__1_n_2\,
      CO(0) => \above_loud_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \above_loud_carry__1_i_1_n_0\,
      DI(2) => \above_loud_carry__1_i_2_n_0\,
      DI(1) => \above_loud_carry__1_i_3_n_0\,
      DI(0) => \above_loud_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_above_loud_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \above_loud_carry__1_i_5_n_0\,
      S(2) => \above_loud_carry__1_i_6_n_0\,
      S(1) => \above_loud_carry__1_i_7_n_0\,
      S(0) => \above_loud_carry__1_i_8_n_0\
    );
\above_loud_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(23),
      I1 => \accumulation_reg[23]_i_1_n_4\,
      I2 => \accumulation_reg[23]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(22),
      O => \above_loud_carry__1_i_1_n_0\
    );
\above_loud_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(21),
      I1 => \accumulation_reg[23]_i_1_n_6\,
      I2 => \accumulation_reg[23]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(20),
      O => \above_loud_carry__1_i_2_n_0\
    );
\above_loud_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(19),
      I1 => \accumulation_reg[19]_i_1_n_4\,
      I2 => \accumulation_reg[19]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(18),
      O => \above_loud_carry__1_i_3_n_0\
    );
\above_loud_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(17),
      I1 => \accumulation_reg[19]_i_1_n_6\,
      I2 => \accumulation_reg[19]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(16),
      O => \above_loud_carry__1_i_4_n_0\
    );
\above_loud_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[23]_i_1_n_4\,
      I1 => \above_loud_carry__2_0\(23),
      I2 => \accumulation_reg[23]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(22),
      O => \above_loud_carry__1_i_5_n_0\
    );
\above_loud_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[23]_i_1_n_6\,
      I1 => \above_loud_carry__2_0\(21),
      I2 => \accumulation_reg[23]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(20),
      O => \above_loud_carry__1_i_6_n_0\
    );
\above_loud_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[19]_i_1_n_4\,
      I1 => \above_loud_carry__2_0\(19),
      I2 => \accumulation_reg[19]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(18),
      O => \above_loud_carry__1_i_7_n_0\
    );
\above_loud_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[19]_i_1_n_6\,
      I1 => \above_loud_carry__2_0\(17),
      I2 => \accumulation_reg[19]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(16),
      O => \above_loud_carry__1_i_8_n_0\
    );
\above_loud_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \above_loud_carry__1_n_0\,
      CO(3) => \above_loud_carry__2_n_0\,
      CO(2) => \above_loud_carry__2_n_1\,
      CO(1) => \above_loud_carry__2_n_2\,
      CO(0) => \above_loud_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \above_loud_carry__2_i_1_n_0\,
      DI(2) => \above_loud_carry__2_i_2_n_0\,
      DI(1) => \above_loud_carry__2_i_3_n_0\,
      DI(0) => \above_loud_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_above_loud_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \above_loud_carry__2_i_5_n_0\,
      S(2) => \above_loud_carry__2_i_6_n_0\,
      S(1) => \above_loud_carry__2_i_7_n_0\,
      S(0) => \above_loud_carry__2_i_8_n_0\
    );
\above_loud_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(31),
      I1 => \accumulation_reg[31]_i_1_n_4\,
      I2 => \accumulation_reg[31]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(30),
      O => \above_loud_carry__2_i_1_n_0\
    );
\above_loud_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(29),
      I1 => \accumulation_reg[31]_i_1_n_6\,
      I2 => \accumulation_reg[31]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(28),
      O => \above_loud_carry__2_i_2_n_0\
    );
\above_loud_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(27),
      I1 => \accumulation_reg[27]_i_1_n_4\,
      I2 => \accumulation_reg[27]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(26),
      O => \above_loud_carry__2_i_3_n_0\
    );
\above_loud_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(25),
      I1 => \accumulation_reg[27]_i_1_n_6\,
      I2 => \accumulation_reg[27]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(24),
      O => \above_loud_carry__2_i_4_n_0\
    );
\above_loud_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[31]_i_1_n_4\,
      I1 => \above_loud_carry__2_0\(31),
      I2 => \accumulation_reg[31]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(30),
      O => \above_loud_carry__2_i_5_n_0\
    );
\above_loud_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[31]_i_1_n_6\,
      I1 => \above_loud_carry__2_0\(29),
      I2 => \accumulation_reg[31]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(28),
      O => \above_loud_carry__2_i_6_n_0\
    );
\above_loud_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[27]_i_1_n_4\,
      I1 => \above_loud_carry__2_0\(27),
      I2 => \accumulation_reg[27]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(26),
      O => \above_loud_carry__2_i_7_n_0\
    );
\above_loud_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[27]_i_1_n_6\,
      I1 => \above_loud_carry__2_0\(25),
      I2 => \accumulation_reg[27]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(24),
      O => \above_loud_carry__2_i_8_n_0\
    );
\above_loud_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \above_loud_carry__2_n_0\,
      CO(3 downto 1) => \NLW_above_loud_carry__3_CO_UNCONNECTED\(3 downto 1),
      CO(0) => above_loud,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => p_0_in,
      O(3 downto 0) => \NLW_above_loud_carry__3_O_UNCONNECTED\(3 downto 0),
      S(3 downto 1) => B"000",
      S(0) => \above_loud_carry__3_i_1_n_0\
    );
\above_loud_carry__3_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => p_0_in,
      O => \above_loud_carry__3_i_1_n_0\
    );
above_loud_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(7),
      I1 => \accumulation_reg[7]_i_1_n_4\,
      I2 => \accumulation_reg[7]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(6),
      O => above_loud_carry_i_1_n_0
    );
above_loud_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(5),
      I1 => \accumulation_reg[7]_i_1_n_6\,
      I2 => \accumulation_reg[7]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(4),
      O => above_loud_carry_i_2_n_0
    );
above_loud_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(3),
      I1 => \accumulation_reg[3]_i_1_n_4\,
      I2 => \accumulation_reg[3]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(2),
      O => above_loud_carry_i_3_n_0
    );
above_loud_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \above_loud_carry__2_0\(1),
      I1 => \accumulation_reg[3]_i_1_n_6\,
      I2 => \accumulation_reg[3]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(0),
      O => above_loud_carry_i_4_n_0
    );
above_loud_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[7]_i_1_n_4\,
      I1 => \above_loud_carry__2_0\(7),
      I2 => \accumulation_reg[7]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(6),
      O => above_loud_carry_i_5_n_0
    );
above_loud_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[7]_i_1_n_6\,
      I1 => \above_loud_carry__2_0\(5),
      I2 => \accumulation_reg[7]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(4),
      O => above_loud_carry_i_6_n_0
    );
above_loud_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[3]_i_1_n_4\,
      I1 => \above_loud_carry__2_0\(3),
      I2 => \accumulation_reg[3]_i_1_n_5\,
      I3 => \above_loud_carry__2_0\(2),
      O => above_loud_carry_i_7_n_0
    );
above_loud_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[3]_i_1_n_6\,
      I1 => \above_loud_carry__2_0\(1),
      I2 => \accumulation_reg[3]_i_1_n_7\,
      I3 => \above_loud_carry__2_0\(0),
      O => above_loud_carry_i_8_n_0
    );
above_soft_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => above_soft_carry_n_0,
      CO(2) => above_soft_carry_n_1,
      CO(1) => above_soft_carry_n_2,
      CO(0) => above_soft_carry_n_3,
      CYINIT => '1',
      DI(3) => above_soft_carry_i_1_n_0,
      DI(2) => above_soft_carry_i_2_n_0,
      DI(1) => above_soft_carry_i_3_n_0,
      DI(0) => above_soft_carry_i_4_n_0,
      O(3 downto 0) => NLW_above_soft_carry_O_UNCONNECTED(3 downto 0),
      S(3) => above_soft_carry_i_5_n_0,
      S(2) => above_soft_carry_i_6_n_0,
      S(1) => above_soft_carry_i_7_n_0,
      S(0) => above_soft_carry_i_8_n_0
    );
\above_soft_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => above_soft_carry_n_0,
      CO(3) => \above_soft_carry__0_n_0\,
      CO(2) => \above_soft_carry__0_n_1\,
      CO(1) => \above_soft_carry__0_n_2\,
      CO(0) => \above_soft_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \above_soft_carry__0_i_1_n_0\,
      DI(2) => \above_soft_carry__0_i_2_n_0\,
      DI(1) => \above_soft_carry__0_i_3_n_0\,
      DI(0) => \above_soft_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_above_soft_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \above_soft_carry__0_i_5_n_0\,
      S(2) => \above_soft_carry__0_i_6_n_0\,
      S(1) => \above_soft_carry__0_i_7_n_0\,
      S(0) => \above_soft_carry__0_i_8_n_0\
    );
\above_soft_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(15),
      I1 => \accumulation_reg[15]_i_1_n_4\,
      I2 => \accumulation_reg[15]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(14),
      O => \above_soft_carry__0_i_1_n_0\
    );
\above_soft_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(13),
      I1 => \accumulation_reg[15]_i_1_n_6\,
      I2 => \accumulation_reg[15]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(12),
      O => \above_soft_carry__0_i_2_n_0\
    );
\above_soft_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(11),
      I1 => \accumulation_reg[11]_i_1_n_4\,
      I2 => \accumulation_reg[11]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(10),
      O => \above_soft_carry__0_i_3_n_0\
    );
\above_soft_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(9),
      I1 => \accumulation_reg[11]_i_1_n_6\,
      I2 => \accumulation_reg[11]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(8),
      O => \above_soft_carry__0_i_4_n_0\
    );
\above_soft_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[15]_i_1_n_4\,
      I1 => \faults[7]_i_10_0\(15),
      I2 => \accumulation_reg[15]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(14),
      O => \above_soft_carry__0_i_5_n_0\
    );
\above_soft_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[15]_i_1_n_6\,
      I1 => \faults[7]_i_10_0\(13),
      I2 => \accumulation_reg[15]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(12),
      O => \above_soft_carry__0_i_6_n_0\
    );
\above_soft_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[11]_i_1_n_4\,
      I1 => \faults[7]_i_10_0\(11),
      I2 => \accumulation_reg[11]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(10),
      O => \above_soft_carry__0_i_7_n_0\
    );
\above_soft_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[11]_i_1_n_6\,
      I1 => \faults[7]_i_10_0\(9),
      I2 => \accumulation_reg[11]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(8),
      O => \above_soft_carry__0_i_8_n_0\
    );
\above_soft_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \above_soft_carry__0_n_0\,
      CO(3) => \above_soft_carry__1_n_0\,
      CO(2) => \above_soft_carry__1_n_1\,
      CO(1) => \above_soft_carry__1_n_2\,
      CO(0) => \above_soft_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \above_soft_carry__1_i_1_n_0\,
      DI(2) => \above_soft_carry__1_i_2_n_0\,
      DI(1) => \above_soft_carry__1_i_3_n_0\,
      DI(0) => \above_soft_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_above_soft_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \above_soft_carry__1_i_5_n_0\,
      S(2) => \above_soft_carry__1_i_6_n_0\,
      S(1) => \above_soft_carry__1_i_7_n_0\,
      S(0) => \above_soft_carry__1_i_8_n_0\
    );
\above_soft_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(23),
      I1 => \accumulation_reg[23]_i_1_n_4\,
      I2 => \accumulation_reg[23]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(22),
      O => \above_soft_carry__1_i_1_n_0\
    );
\above_soft_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(21),
      I1 => \accumulation_reg[23]_i_1_n_6\,
      I2 => \accumulation_reg[23]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(20),
      O => \above_soft_carry__1_i_2_n_0\
    );
\above_soft_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(19),
      I1 => \accumulation_reg[19]_i_1_n_4\,
      I2 => \accumulation_reg[19]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(18),
      O => \above_soft_carry__1_i_3_n_0\
    );
\above_soft_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(17),
      I1 => \accumulation_reg[19]_i_1_n_6\,
      I2 => \accumulation_reg[19]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(16),
      O => \above_soft_carry__1_i_4_n_0\
    );
\above_soft_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[23]_i_1_n_4\,
      I1 => \faults[7]_i_10_0\(23),
      I2 => \accumulation_reg[23]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(22),
      O => \above_soft_carry__1_i_5_n_0\
    );
\above_soft_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[23]_i_1_n_6\,
      I1 => \faults[7]_i_10_0\(21),
      I2 => \accumulation_reg[23]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(20),
      O => \above_soft_carry__1_i_6_n_0\
    );
\above_soft_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[19]_i_1_n_4\,
      I1 => \faults[7]_i_10_0\(19),
      I2 => \accumulation_reg[19]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(18),
      O => \above_soft_carry__1_i_7_n_0\
    );
\above_soft_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[19]_i_1_n_6\,
      I1 => \faults[7]_i_10_0\(17),
      I2 => \accumulation_reg[19]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(16),
      O => \above_soft_carry__1_i_8_n_0\
    );
\above_soft_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \above_soft_carry__1_n_0\,
      CO(3) => \above_soft_carry__2_n_0\,
      CO(2) => \above_soft_carry__2_n_1\,
      CO(1) => \above_soft_carry__2_n_2\,
      CO(0) => \above_soft_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \above_soft_carry__2_i_1_n_0\,
      DI(2) => \above_soft_carry__2_i_2_n_0\,
      DI(1) => \above_soft_carry__2_i_3_n_0\,
      DI(0) => \above_soft_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_above_soft_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \above_soft_carry__2_i_5_n_0\,
      S(2) => \above_soft_carry__2_i_6_n_0\,
      S(1) => \above_soft_carry__2_i_7_n_0\,
      S(0) => \above_soft_carry__2_i_8_n_0\
    );
\above_soft_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(31),
      I1 => \accumulation_reg[31]_i_1_n_4\,
      I2 => \accumulation_reg[31]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(30),
      O => \above_soft_carry__2_i_1_n_0\
    );
\above_soft_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(29),
      I1 => \accumulation_reg[31]_i_1_n_6\,
      I2 => \accumulation_reg[31]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(28),
      O => \above_soft_carry__2_i_2_n_0\
    );
\above_soft_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(27),
      I1 => \accumulation_reg[27]_i_1_n_4\,
      I2 => \accumulation_reg[27]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(26),
      O => \above_soft_carry__2_i_3_n_0\
    );
\above_soft_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(25),
      I1 => \accumulation_reg[27]_i_1_n_6\,
      I2 => \accumulation_reg[27]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(24),
      O => \above_soft_carry__2_i_4_n_0\
    );
\above_soft_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[31]_i_1_n_4\,
      I1 => \faults[7]_i_10_0\(31),
      I2 => \accumulation_reg[31]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(30),
      O => \above_soft_carry__2_i_5_n_0\
    );
\above_soft_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[31]_i_1_n_6\,
      I1 => \faults[7]_i_10_0\(29),
      I2 => \accumulation_reg[31]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(28),
      O => \above_soft_carry__2_i_6_n_0\
    );
\above_soft_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[27]_i_1_n_4\,
      I1 => \faults[7]_i_10_0\(27),
      I2 => \accumulation_reg[27]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(26),
      O => \above_soft_carry__2_i_7_n_0\
    );
\above_soft_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[27]_i_1_n_6\,
      I1 => \faults[7]_i_10_0\(25),
      I2 => \accumulation_reg[27]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(24),
      O => \above_soft_carry__2_i_8_n_0\
    );
\above_soft_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \above_soft_carry__2_n_0\,
      CO(3 downto 1) => \NLW_above_soft_carry__3_CO_UNCONNECTED\(3 downto 1),
      CO(0) => p_1_in,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => p_0_in,
      O(3 downto 0) => \NLW_above_soft_carry__3_O_UNCONNECTED\(3 downto 0),
      S(3 downto 1) => B"000",
      S(0) => \above_soft_carry__3_i_2_n_0\
    );
\above_soft_carry__3_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \accumulation_reg[31]_i_1_n_0\,
      CO(3 downto 1) => \NLW_above_soft_carry__3_i_1_CO_UNCONNECTED\(3 downto 1),
      CO(0) => p_0_in,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_above_soft_carry__3_i_1_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => B"0001"
    );
\above_soft_carry__3_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => p_0_in,
      O => \above_soft_carry__3_i_2_n_0\
    );
above_soft_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(7),
      I1 => \accumulation_reg[7]_i_1_n_4\,
      I2 => \accumulation_reg[7]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(6),
      O => above_soft_carry_i_1_n_0
    );
above_soft_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(5),
      I1 => \accumulation_reg[7]_i_1_n_6\,
      I2 => \accumulation_reg[7]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(4),
      O => above_soft_carry_i_2_n_0
    );
above_soft_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(3),
      I1 => \accumulation_reg[3]_i_1_n_4\,
      I2 => \accumulation_reg[3]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(2),
      O => above_soft_carry_i_3_n_0
    );
above_soft_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(1),
      I1 => \accumulation_reg[3]_i_1_n_6\,
      I2 => \accumulation_reg[3]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(0),
      O => above_soft_carry_i_4_n_0
    );
above_soft_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[7]_i_1_n_4\,
      I1 => \faults[7]_i_10_0\(7),
      I2 => \accumulation_reg[7]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(6),
      O => above_soft_carry_i_5_n_0
    );
above_soft_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[7]_i_1_n_6\,
      I1 => \faults[7]_i_10_0\(5),
      I2 => \accumulation_reg[7]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(4),
      O => above_soft_carry_i_6_n_0
    );
above_soft_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[3]_i_1_n_4\,
      I1 => \faults[7]_i_10_0\(3),
      I2 => \accumulation_reg[3]_i_1_n_5\,
      I3 => \faults[7]_i_10_0\(2),
      O => above_soft_carry_i_7_n_0
    );
above_soft_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[3]_i_1_n_6\,
      I1 => \faults[7]_i_10_0\(1),
      I2 => \accumulation_reg[3]_i_1_n_7\,
      I3 => \faults[7]_i_10_0\(0),
      O => above_soft_carry_i_8_n_0
    );
\accumulation[11]_i_10\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(5),
      O => \accumulation[11]_i_10_n_0\
    );
\accumulation[11]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(11),
      I1 => filtered_latched(11),
      I2 => filtered_latched(17),
      I3 => magnitude0(11),
      O => \accumulation[11]_i_2_n_0\
    );
\accumulation[11]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(10),
      I1 => filtered_latched(10),
      I2 => filtered_latched(17),
      I3 => magnitude0(10),
      O => \accumulation[11]_i_3_n_0\
    );
\accumulation[11]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(9),
      I1 => filtered_latched(9),
      I2 => filtered_latched(17),
      I3 => magnitude0(9),
      O => \accumulation[11]_i_4_n_0\
    );
\accumulation[11]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(8),
      I1 => filtered_latched(8),
      I2 => filtered_latched(17),
      I3 => magnitude0(8),
      O => \accumulation[11]_i_5_n_0\
    );
\accumulation[11]_i_7\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(8),
      O => \accumulation[11]_i_7_n_0\
    );
\accumulation[11]_i_8\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(7),
      O => \accumulation[11]_i_8_n_0\
    );
\accumulation[11]_i_9\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(6),
      O => \accumulation[11]_i_9_n_0\
    );
\accumulation[15]_i_10\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(9),
      O => \accumulation[15]_i_10_n_0\
    );
\accumulation[15]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(15),
      I1 => filtered_latched(15),
      I2 => filtered_latched(17),
      I3 => magnitude0(15),
      O => \accumulation[15]_i_2_n_0\
    );
\accumulation[15]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(14),
      I1 => filtered_latched(14),
      I2 => filtered_latched(17),
      I3 => magnitude0(14),
      O => \accumulation[15]_i_3_n_0\
    );
\accumulation[15]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(13),
      I1 => filtered_latched(13),
      I2 => filtered_latched(17),
      I3 => magnitude0(13),
      O => \accumulation[15]_i_4_n_0\
    );
\accumulation[15]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(12),
      I1 => filtered_latched(12),
      I2 => filtered_latched(17),
      I3 => magnitude0(12),
      O => \accumulation[15]_i_5_n_0\
    );
\accumulation[15]_i_7\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(12),
      O => \accumulation[15]_i_7_n_0\
    );
\accumulation[15]_i_8\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(11),
      O => \accumulation[15]_i_8_n_0\
    );
\accumulation[15]_i_9\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(10),
      O => \accumulation[15]_i_9_n_0\
    );
\accumulation[19]_i_10\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(13),
      O => \accumulation[19]_i_10_n_0\
    );
\accumulation[19]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => accumulation(17),
      I1 => magnitude0(17),
      I2 => filtered_latched(17),
      O => \accumulation[19]_i_2_n_0\
    );
\accumulation[19]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(16),
      I1 => filtered_latched(16),
      I2 => filtered_latched(17),
      I3 => magnitude0(16),
      O => \accumulation[19]_i_3_n_0\
    );
\accumulation[19]_i_6\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(17),
      O => \accumulation[19]_i_6_n_0\
    );
\accumulation[19]_i_7\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(16),
      O => \accumulation[19]_i_7_n_0\
    );
\accumulation[19]_i_8\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(15),
      O => \accumulation[19]_i_8_n_0\
    );
\accumulation[19]_i_9\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(14),
      O => \accumulation[19]_i_9_n_0\
    );
\accumulation[3]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(3),
      I1 => filtered_latched(3),
      I2 => filtered_latched(17),
      I3 => magnitude0(3),
      O => \accumulation[3]_i_2_n_0\
    );
\accumulation[3]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(2),
      I1 => filtered_latched(2),
      I2 => filtered_latched(17),
      I3 => magnitude0(2),
      O => \accumulation[3]_i_3_n_0\
    );
\accumulation[3]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(1),
      I1 => filtered_latched(1),
      I2 => filtered_latched(17),
      I3 => magnitude0(1),
      O => \accumulation[3]_i_4_n_0\
    );
\accumulation[3]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => accumulation(0),
      I1 => filtered_latched(0),
      O => \accumulation[3]_i_5_n_0\
    );
\accumulation[7]_i_10\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(2),
      O => \accumulation[7]_i_10_n_0\
    );
\accumulation[7]_i_11\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(1),
      O => \accumulation[7]_i_11_n_0\
    );
\accumulation[7]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(7),
      I1 => filtered_latched(7),
      I2 => filtered_latched(17),
      I3 => magnitude0(7),
      O => \accumulation[7]_i_2_n_0\
    );
\accumulation[7]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(6),
      I1 => filtered_latched(6),
      I2 => filtered_latched(17),
      I3 => magnitude0(6),
      O => \accumulation[7]_i_3_n_0\
    );
\accumulation[7]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(5),
      I1 => filtered_latched(5),
      I2 => filtered_latched(17),
      I3 => magnitude0(5),
      O => \accumulation[7]_i_4_n_0\
    );
\accumulation[7]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"56A6"
    )
        port map (
      I0 => accumulation(4),
      I1 => filtered_latched(4),
      I2 => filtered_latched(17),
      I3 => magnitude0(4),
      O => \accumulation[7]_i_5_n_0\
    );
\accumulation[7]_i_7\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(0),
      O => \accumulation[7]_i_7_n_0\
    );
\accumulation[7]_i_8\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(4),
      O => \accumulation[7]_i_8_n_0\
    );
\accumulation[7]_i_9\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => filtered_latched(3),
      O => \accumulation[7]_i_9_n_0\
    );
\accumulation_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[3]_i_1_n_7\,
      Q => accumulation(0),
      R => clipped_count(0)
    );
\accumulation_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[11]_i_1_n_5\,
      Q => accumulation(10),
      R => clipped_count(0)
    );
\accumulation_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[11]_i_1_n_4\,
      Q => accumulation(11),
      R => clipped_count(0)
    );
\accumulation_reg[11]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \accumulation_reg[7]_i_1_n_0\,
      CO(3) => \accumulation_reg[11]_i_1_n_0\,
      CO(2) => \accumulation_reg[11]_i_1_n_1\,
      CO(1) => \accumulation_reg[11]_i_1_n_2\,
      CO(0) => \accumulation_reg[11]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => accumulation(11 downto 8),
      O(3) => \accumulation_reg[11]_i_1_n_4\,
      O(2) => \accumulation_reg[11]_i_1_n_5\,
      O(1) => \accumulation_reg[11]_i_1_n_6\,
      O(0) => \accumulation_reg[11]_i_1_n_7\,
      S(3) => \accumulation[11]_i_2_n_0\,
      S(2) => \accumulation[11]_i_3_n_0\,
      S(1) => \accumulation[11]_i_4_n_0\,
      S(0) => \accumulation[11]_i_5_n_0\
    );
\accumulation_reg[11]_i_6\: unisim.vcomponents.CARRY4
     port map (
      CI => \accumulation_reg[7]_i_6_n_0\,
      CO(3) => \accumulation_reg[11]_i_6_n_0\,
      CO(2) => \accumulation_reg[11]_i_6_n_1\,
      CO(1) => \accumulation_reg[11]_i_6_n_2\,
      CO(0) => \accumulation_reg[11]_i_6_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => magnitude0(8 downto 5),
      S(3) => \accumulation[11]_i_7_n_0\,
      S(2) => \accumulation[11]_i_8_n_0\,
      S(1) => \accumulation[11]_i_9_n_0\,
      S(0) => \accumulation[11]_i_10_n_0\
    );
\accumulation_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[15]_i_1_n_7\,
      Q => accumulation(12),
      R => clipped_count(0)
    );
\accumulation_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[15]_i_1_n_6\,
      Q => accumulation(13),
      R => clipped_count(0)
    );
\accumulation_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[15]_i_1_n_5\,
      Q => accumulation(14),
      R => clipped_count(0)
    );
\accumulation_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[15]_i_1_n_4\,
      Q => accumulation(15),
      R => clipped_count(0)
    );
\accumulation_reg[15]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \accumulation_reg[11]_i_1_n_0\,
      CO(3) => \accumulation_reg[15]_i_1_n_0\,
      CO(2) => \accumulation_reg[15]_i_1_n_1\,
      CO(1) => \accumulation_reg[15]_i_1_n_2\,
      CO(0) => \accumulation_reg[15]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => accumulation(15 downto 12),
      O(3) => \accumulation_reg[15]_i_1_n_4\,
      O(2) => \accumulation_reg[15]_i_1_n_5\,
      O(1) => \accumulation_reg[15]_i_1_n_6\,
      O(0) => \accumulation_reg[15]_i_1_n_7\,
      S(3) => \accumulation[15]_i_2_n_0\,
      S(2) => \accumulation[15]_i_3_n_0\,
      S(1) => \accumulation[15]_i_4_n_0\,
      S(0) => \accumulation[15]_i_5_n_0\
    );
\accumulation_reg[15]_i_6\: unisim.vcomponents.CARRY4
     port map (
      CI => \accumulation_reg[11]_i_6_n_0\,
      CO(3) => \accumulation_reg[15]_i_6_n_0\,
      CO(2) => \accumulation_reg[15]_i_6_n_1\,
      CO(1) => \accumulation_reg[15]_i_6_n_2\,
      CO(0) => \accumulation_reg[15]_i_6_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => magnitude0(12 downto 9),
      S(3) => \accumulation[15]_i_7_n_0\,
      S(2) => \accumulation[15]_i_8_n_0\,
      S(1) => \accumulation[15]_i_9_n_0\,
      S(0) => \accumulation[15]_i_10_n_0\
    );
\accumulation_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[19]_i_1_n_7\,
      Q => accumulation(16),
      R => clipped_count(0)
    );
\accumulation_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[19]_i_1_n_6\,
      Q => accumulation(17),
      R => clipped_count(0)
    );
\accumulation_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[19]_i_1_n_5\,
      Q => accumulation(18),
      R => clipped_count(0)
    );
\accumulation_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[19]_i_1_n_4\,
      Q => accumulation(19),
      R => clipped_count(0)
    );
\accumulation_reg[19]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \accumulation_reg[15]_i_1_n_0\,
      CO(3) => \accumulation_reg[19]_i_1_n_0\,
      CO(2) => \accumulation_reg[19]_i_1_n_1\,
      CO(1) => \accumulation_reg[19]_i_1_n_2\,
      CO(0) => \accumulation_reg[19]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1 downto 0) => accumulation(17 downto 16),
      O(3) => \accumulation_reg[19]_i_1_n_4\,
      O(2) => \accumulation_reg[19]_i_1_n_5\,
      O(1) => \accumulation_reg[19]_i_1_n_6\,
      O(0) => \accumulation_reg[19]_i_1_n_7\,
      S(3 downto 2) => accumulation(19 downto 18),
      S(1) => \accumulation[19]_i_2_n_0\,
      S(0) => \accumulation[19]_i_3_n_0\
    );
\accumulation_reg[19]_i_4\: unisim.vcomponents.CARRY4
     port map (
      CI => \accumulation_reg[19]_i_5_n_0\,
      CO(3 downto 0) => \NLW_accumulation_reg[19]_i_4_CO_UNCONNECTED\(3 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 1) => \NLW_accumulation_reg[19]_i_4_O_UNCONNECTED\(3 downto 1),
      O(0) => magnitude0(17),
      S(3 downto 1) => B"000",
      S(0) => \accumulation[19]_i_6_n_0\
    );
\accumulation_reg[19]_i_5\: unisim.vcomponents.CARRY4
     port map (
      CI => \accumulation_reg[15]_i_6_n_0\,
      CO(3) => \accumulation_reg[19]_i_5_n_0\,
      CO(2) => \accumulation_reg[19]_i_5_n_1\,
      CO(1) => \accumulation_reg[19]_i_5_n_2\,
      CO(0) => \accumulation_reg[19]_i_5_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => magnitude0(16 downto 13),
      S(3) => \accumulation[19]_i_7_n_0\,
      S(2) => \accumulation[19]_i_8_n_0\,
      S(1) => \accumulation[19]_i_9_n_0\,
      S(0) => \accumulation[19]_i_10_n_0\
    );
\accumulation_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[3]_i_1_n_6\,
      Q => accumulation(1),
      R => clipped_count(0)
    );
\accumulation_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[23]_i_1_n_7\,
      Q => accumulation(20),
      R => clipped_count(0)
    );
\accumulation_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[23]_i_1_n_6\,
      Q => accumulation(21),
      R => clipped_count(0)
    );
\accumulation_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[23]_i_1_n_5\,
      Q => accumulation(22),
      R => clipped_count(0)
    );
\accumulation_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[23]_i_1_n_4\,
      Q => accumulation(23),
      R => clipped_count(0)
    );
\accumulation_reg[23]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \accumulation_reg[19]_i_1_n_0\,
      CO(3) => \accumulation_reg[23]_i_1_n_0\,
      CO(2) => \accumulation_reg[23]_i_1_n_1\,
      CO(1) => \accumulation_reg[23]_i_1_n_2\,
      CO(0) => \accumulation_reg[23]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \accumulation_reg[23]_i_1_n_4\,
      O(2) => \accumulation_reg[23]_i_1_n_5\,
      O(1) => \accumulation_reg[23]_i_1_n_6\,
      O(0) => \accumulation_reg[23]_i_1_n_7\,
      S(3 downto 0) => accumulation(23 downto 20)
    );
\accumulation_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[27]_i_1_n_7\,
      Q => accumulation(24),
      R => clipped_count(0)
    );
\accumulation_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[27]_i_1_n_6\,
      Q => accumulation(25),
      R => clipped_count(0)
    );
\accumulation_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[27]_i_1_n_5\,
      Q => accumulation(26),
      R => clipped_count(0)
    );
\accumulation_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[27]_i_1_n_4\,
      Q => accumulation(27),
      R => clipped_count(0)
    );
\accumulation_reg[27]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \accumulation_reg[23]_i_1_n_0\,
      CO(3) => \accumulation_reg[27]_i_1_n_0\,
      CO(2) => \accumulation_reg[27]_i_1_n_1\,
      CO(1) => \accumulation_reg[27]_i_1_n_2\,
      CO(0) => \accumulation_reg[27]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \accumulation_reg[27]_i_1_n_4\,
      O(2) => \accumulation_reg[27]_i_1_n_5\,
      O(1) => \accumulation_reg[27]_i_1_n_6\,
      O(0) => \accumulation_reg[27]_i_1_n_7\,
      S(3 downto 0) => accumulation(27 downto 24)
    );
\accumulation_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[31]_i_1_n_7\,
      Q => accumulation(28),
      R => clipped_count(0)
    );
\accumulation_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[31]_i_1_n_6\,
      Q => accumulation(29),
      R => clipped_count(0)
    );
\accumulation_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[3]_i_1_n_5\,
      Q => accumulation(2),
      R => clipped_count(0)
    );
\accumulation_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[31]_i_1_n_5\,
      Q => accumulation(30),
      R => clipped_count(0)
    );
\accumulation_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[31]_i_1_n_4\,
      Q => accumulation(31),
      R => clipped_count(0)
    );
\accumulation_reg[31]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \accumulation_reg[27]_i_1_n_0\,
      CO(3) => \accumulation_reg[31]_i_1_n_0\,
      CO(2) => \accumulation_reg[31]_i_1_n_1\,
      CO(1) => \accumulation_reg[31]_i_1_n_2\,
      CO(0) => \accumulation_reg[31]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \accumulation_reg[31]_i_1_n_4\,
      O(2) => \accumulation_reg[31]_i_1_n_5\,
      O(1) => \accumulation_reg[31]_i_1_n_6\,
      O(0) => \accumulation_reg[31]_i_1_n_7\,
      S(3 downto 0) => accumulation(31 downto 28)
    );
\accumulation_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[3]_i_1_n_4\,
      Q => accumulation(3),
      R => clipped_count(0)
    );
\accumulation_reg[3]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \accumulation_reg[3]_i_1_n_0\,
      CO(2) => \accumulation_reg[3]_i_1_n_1\,
      CO(1) => \accumulation_reg[3]_i_1_n_2\,
      CO(0) => \accumulation_reg[3]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => accumulation(3 downto 0),
      O(3) => \accumulation_reg[3]_i_1_n_4\,
      O(2) => \accumulation_reg[3]_i_1_n_5\,
      O(1) => \accumulation_reg[3]_i_1_n_6\,
      O(0) => \accumulation_reg[3]_i_1_n_7\,
      S(3) => \accumulation[3]_i_2_n_0\,
      S(2) => \accumulation[3]_i_3_n_0\,
      S(1) => \accumulation[3]_i_4_n_0\,
      S(0) => \accumulation[3]_i_5_n_0\
    );
\accumulation_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[7]_i_1_n_7\,
      Q => accumulation(4),
      R => clipped_count(0)
    );
\accumulation_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[7]_i_1_n_6\,
      Q => accumulation(5),
      R => clipped_count(0)
    );
\accumulation_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[7]_i_1_n_5\,
      Q => accumulation(6),
      R => clipped_count(0)
    );
\accumulation_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[7]_i_1_n_4\,
      Q => accumulation(7),
      R => clipped_count(0)
    );
\accumulation_reg[7]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \accumulation_reg[3]_i_1_n_0\,
      CO(3) => \accumulation_reg[7]_i_1_n_0\,
      CO(2) => \accumulation_reg[7]_i_1_n_1\,
      CO(1) => \accumulation_reg[7]_i_1_n_2\,
      CO(0) => \accumulation_reg[7]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => accumulation(7 downto 4),
      O(3) => \accumulation_reg[7]_i_1_n_4\,
      O(2) => \accumulation_reg[7]_i_1_n_5\,
      O(1) => \accumulation_reg[7]_i_1_n_6\,
      O(0) => \accumulation_reg[7]_i_1_n_7\,
      S(3) => \accumulation[7]_i_2_n_0\,
      S(2) => \accumulation[7]_i_3_n_0\,
      S(1) => \accumulation[7]_i_4_n_0\,
      S(0) => \accumulation[7]_i_5_n_0\
    );
\accumulation_reg[7]_i_6\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \accumulation_reg[7]_i_6_n_0\,
      CO(2) => \accumulation_reg[7]_i_6_n_1\,
      CO(1) => \accumulation_reg[7]_i_6_n_2\,
      CO(0) => \accumulation_reg[7]_i_6_n_3\,
      CYINIT => \accumulation[7]_i_7_n_0\,
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => magnitude0(4 downto 1),
      S(3) => \accumulation[7]_i_8_n_0\,
      S(2) => \accumulation[7]_i_9_n_0\,
      S(1) => \accumulation[7]_i_10_n_0\,
      S(0) => \accumulation[7]_i_11_n_0\
    );
\accumulation_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[11]_i_1_n_7\,
      Q => accumulation(8),
      R => clipped_count(0)
    );
\accumulation_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => \accumulation_reg[11]_i_1_n_6\,
      Q => accumulation(9),
      R => clipped_count(0)
    );
ack_error_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4040404040444040"
    )
        port map (
      I0 => configure,
      I1 => s_axi_aresetn,
      I2 => \^status\(1),
      I3 => ack_error_i_2_n_0,
      I4 => ack_error_reg_0,
      I5 => ack_error_i_3_n_0,
      O => ack_error_i_1_n_0
    );
ack_error_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BF"
    )
        port map (
      I0 => configure,
      I1 => \faults_reg[0]_1\(0),
      I2 => \event_age[31]_i_1_n_0\,
      O => ack_error_i_2_n_0
    );
ack_error_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => ack_error_reg_0,
      I1 => \^status\(0),
      I2 => matching_ack0,
      I3 => matching_ack1,
      O => ack_error_i_3_n_0
    );
ack_error_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ack_error_i_1_n_0,
      Q => \^status\(1),
      R => '0'
    );
\candidate_count[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => \^status\(3),
      I1 => candidate_count(0),
      O => \candidate_count[0]_i_1_n_0\
    );
\candidate_count[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"60"
    )
        port map (
      I0 => candidate_count(0),
      I1 => candidate_count(1),
      I2 => \^status\(3),
      O => \candidate_count[1]_i_1_n_0\
    );
\candidate_count[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00002808"
    )
        port map (
      I0 => \candidate_count[2]_i_3_n_0\,
      I1 => \^status\(3),
      I2 => \^status\(2),
      I3 => p_1_in,
      I4 => \^status\(4),
      O => soft_count(0)
    );
\candidate_count[2]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2A80"
    )
        port map (
      I0 => \^status\(3),
      I1 => candidate_count(1),
      I2 => candidate_count(0),
      I3 => candidate_count(2),
      O => \candidate_count[2]_i_2_n_0\
    );
\candidate_count[2]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000002"
    )
        port map (
      I0 => \clipped_count[15]_i_4_n_0\,
      I1 => \candidate_count[2]_i_4_n_0\,
      I2 => \^faults_reg[7]_0\(4),
      I3 => \^faults_reg[7]_0\(5),
      I4 => \^faults_reg[7]_0\(6),
      I5 => \^faults_reg[7]_0\(7),
      O => \candidate_count[2]_i_3_n_0\
    );
\candidate_count[2]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FEFFFEFFFFFFFEFF"
    )
        port map (
      I0 => \candidate_count[2]_i_5_n_0\,
      I1 => \^faults_reg[7]_0\(0),
      I2 => \^faults_reg[7]_0\(5),
      I3 => filtered_valid,
      I4 => \^faults_reg[7]_0\(3),
      I5 => \^faults_reg[7]_0\(4),
      O => \candidate_count[2]_i_4_n_0\
    );
\candidate_count[2]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \^faults_reg[7]_0\(1),
      I1 => \^faults_reg[7]_0\(2),
      O => \candidate_count[2]_i_5_n_0\
    );
\candidate_count_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => soft_count(0),
      D => \candidate_count[0]_i_1_n_0\,
      Q => candidate_count(0),
      R => \sample_in_window[9]_i_1_n_0\
    );
\candidate_count_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => soft_count(0),
      D => \candidate_count[1]_i_1_n_0\,
      Q => candidate_count(1),
      R => \sample_in_window[9]_i_1_n_0\
    );
\candidate_count_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => soft_count(0),
      D => \candidate_count[2]_i_2_n_0\,
      Q => candidate_count(2),
      R => \sample_in_window[9]_i_1_n_0\
    );
centered_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => centered_carry_n_0,
      CO(2) => centered_carry_n_1,
      CO(1) => centered_carry_n_2,
      CO(0) => centered_carry_n_3,
      CYINIT => centered_carry_i_1_n_0,
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_centered_carry_O_UNCONNECTED(3 downto 0),
      S(3) => \centered_carry_i_2__0_n_0\,
      S(2) => \centered_carry_i_3__0_n_0\,
      S(1) => \centered_carry_i_4__0_n_0\,
      S(0) => centered_carry_i_5_n_0
    );
\centered_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => centered_carry_n_0,
      CO(3) => \centered_carry__0_n_0\,
      CO(2) => \centered_carry__0_n_1\,
      CO(1) => \centered_carry__0_n_2\,
      CO(0) => \centered_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => scaled_latched(8),
      DI(2 downto 0) => B"000",
      O(3) => centered(8),
      O(2 downto 0) => \NLW_centered_carry__0_O_UNCONNECTED\(2 downto 0),
      S(3) => \centered_carry_i_1__5_n_0\,
      S(2) => centered_carry_i_2_n_0,
      S(1) => centered_carry_i_3_n_0,
      S(0) => centered_carry_i_4_n_0
    );
\centered_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \centered_carry__0_n_0\,
      CO(3) => \centered_carry__1_n_0\,
      CO(2) => \centered_carry__1_n_1\,
      CO(1) => \centered_carry__1_n_2\,
      CO(0) => \centered_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => scaled_latched(12 downto 9),
      O(3 downto 0) => centered(12 downto 9),
      S(3) => \centered_carry_i_1__4_n_0\,
      S(2) => \centered_carry_i_2__4_n_0\,
      S(1) => \centered_carry_i_3__4_n_0\,
      S(0) => \centered_carry_i_4__4_n_0\
    );
\centered_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \centered_carry__1_n_0\,
      CO(3) => \centered_carry__2_n_0\,
      CO(2) => \centered_carry__2_n_1\,
      CO(1) => \centered_carry__2_n_2\,
      CO(0) => \centered_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => scaled_latched(16 downto 13),
      O(3 downto 0) => centered(16 downto 13),
      S(3) => \centered_carry_i_1__3_n_0\,
      S(2) => \centered_carry_i_2__3_n_0\,
      S(1) => \centered_carry_i_3__3_n_0\,
      S(0) => \centered_carry_i_4__3_n_0\
    );
\centered_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \centered_carry__2_n_0\,
      CO(3) => \centered_carry__3_n_0\,
      CO(2) => \centered_carry__3_n_1\,
      CO(1) => \centered_carry__3_n_2\,
      CO(0) => \centered_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => scaled_latched(20 downto 17),
      O(3 downto 0) => centered(20 downto 17),
      S(3) => \centered_carry_i_1__2_n_0\,
      S(2) => \centered_carry_i_2__2_n_0\,
      S(1) => \centered_carry_i_3__2_n_0\,
      S(0) => \centered_carry_i_4__2_n_0\
    );
\centered_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \centered_carry__3_n_0\,
      CO(3) => \centered_carry__4_n_0\,
      CO(2) => \centered_carry__4_n_1\,
      CO(1) => \centered_carry__4_n_2\,
      CO(0) => \centered_carry__4_n_3\,
      CYINIT => '0',
      DI(3) => \next_dc_carry__5_n_7\,
      DI(2) => scaled_latched(24),
      DI(1 downto 0) => scaled_latched(22 downto 21),
      O(3 downto 0) => centered(24 downto 21),
      S(3) => \centered_carry_i_1__0_n_0\,
      S(2) => \centered_carry_i_2__1_n_0\,
      S(1) => \centered_carry_i_3__1_n_0\,
      S(0) => \centered_carry_i_4__1_n_0\
    );
\centered_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \centered_carry__4_n_0\,
      CO(3 downto 0) => \NLW_centered_carry__5_CO_UNCONNECTED\(3 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 1) => \NLW_centered_carry__5_O_UNCONNECTED\(3 downto 1),
      O(0) => centered(25),
      S(3 downto 1) => B"000",
      S(0) => \centered_carry_i_1__1_n_0\
    );
centered_carry_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => next_dc_carry_n_7,
      O => centered_carry_i_1_n_0
    );
\centered_carry_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \next_dc_carry__5_n_7\,
      I1 => scaled_latched(24),
      O => \centered_carry_i_1__0_n_0\
    );
\centered_carry_i_1__1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \next_dc_carry__5_n_7\,
      I1 => \next_dc_carry__5_n_2\,
      O => \centered_carry_i_1__1_n_0\
    );
\centered_carry_i_1__2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(20),
      I1 => \next_dc_carry__4_n_7\,
      O => \centered_carry_i_1__2_n_0\
    );
\centered_carry_i_1__3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(16),
      I1 => \next_dc_carry__3_n_7\,
      O => \centered_carry_i_1__3_n_0\
    );
\centered_carry_i_1__4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(12),
      I1 => \next_dc_carry__2_n_7\,
      O => \centered_carry_i_1__4_n_0\
    );
\centered_carry_i_1__5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(8),
      I1 => \next_dc_carry__1_n_7\,
      O => \centered_carry_i_1__5_n_0\
    );
centered_carry_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \next_dc_carry__0_n_4\,
      O => centered_carry_i_2_n_0
    );
\centered_carry_i_2__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \next_dc_carry__0_n_7\,
      O => \centered_carry_i_2__0_n_0\
    );
\centered_carry_i_2__1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(24),
      I1 => \next_dc_carry__4_n_4\,
      O => \centered_carry_i_2__1_n_0\
    );
\centered_carry_i_2__2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(19),
      I1 => \next_dc_carry__3_n_4\,
      O => \centered_carry_i_2__2_n_0\
    );
\centered_carry_i_2__3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(15),
      I1 => \next_dc_carry__2_n_4\,
      O => \centered_carry_i_2__3_n_0\
    );
\centered_carry_i_2__4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(11),
      I1 => \next_dc_carry__1_n_4\,
      O => \centered_carry_i_2__4_n_0\
    );
centered_carry_i_3: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \next_dc_carry__0_n_5\,
      O => centered_carry_i_3_n_0
    );
\centered_carry_i_3__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => next_dc_carry_n_4,
      O => \centered_carry_i_3__0_n_0\
    );
\centered_carry_i_3__1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(22),
      I1 => \next_dc_carry__4_n_5\,
      O => \centered_carry_i_3__1_n_0\
    );
\centered_carry_i_3__2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(18),
      I1 => \next_dc_carry__3_n_5\,
      O => \centered_carry_i_3__2_n_0\
    );
\centered_carry_i_3__3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(14),
      I1 => \next_dc_carry__2_n_5\,
      O => \centered_carry_i_3__3_n_0\
    );
\centered_carry_i_3__4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(10),
      I1 => \next_dc_carry__1_n_5\,
      O => \centered_carry_i_3__4_n_0\
    );
centered_carry_i_4: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \next_dc_carry__0_n_6\,
      O => centered_carry_i_4_n_0
    );
\centered_carry_i_4__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => next_dc_carry_n_5,
      O => \centered_carry_i_4__0_n_0\
    );
\centered_carry_i_4__1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(21),
      I1 => \next_dc_carry__4_n_6\,
      O => \centered_carry_i_4__1_n_0\
    );
\centered_carry_i_4__2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(17),
      I1 => \next_dc_carry__3_n_6\,
      O => \centered_carry_i_4__2_n_0\
    );
\centered_carry_i_4__3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(13),
      I1 => \next_dc_carry__2_n_6\,
      O => \centered_carry_i_4__3_n_0\
    );
\centered_carry_i_4__4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => scaled_latched(9),
      I1 => \next_dc_carry__1_n_6\,
      O => \centered_carry_i_4__4_n_0\
    );
centered_carry_i_5: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => next_dc_carry_n_6,
      O => centered_carry_i_5_n_0
    );
\clipped_count[15]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFBFBFBF"
    )
        port map (
      I0 => configure,
      I1 => s_axi_aresetn,
      I2 => \faults_reg[0]_1\(0),
      I3 => \clipped_count[15]_i_2_n_0\,
      I4 => \clipped_count[15]_i_4_n_0\,
      O => clipped_count(0)
    );
\clipped_count[15]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \event_age[31]_i_1_n_0\,
      I1 => filtered_valid,
      O => \clipped_count[15]_i_2_n_0\
    );
\clipped_count[15]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \sample_in_window_reg_n_0_[9]\,
      I1 => \sample_in_window[9]_i_3_n_0\,
      O => \clipped_count[15]_i_4_n_0\
    );
\clipped_count[3]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \clipped_count_reg_n_0_[0]\,
      I1 => filtered_clipped,
      O => \clipped_count[3]_i_2_n_0\
    );
\clipped_count_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(0),
      Q => \clipped_count_reg_n_0_[0]\,
      R => clipped_count(0)
    );
\clipped_count_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(10),
      Q => \clipped_count_reg_n_0_[10]\,
      R => clipped_count(0)
    );
\clipped_count_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(11),
      Q => \clipped_count_reg_n_0_[11]\,
      R => clipped_count(0)
    );
\clipped_count_reg[11]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \clipped_count_reg[7]_i_1_n_0\,
      CO(3) => \clipped_count_reg[11]_i_1_n_0\,
      CO(2) => \clipped_count_reg[11]_i_1_n_1\,
      CO(1) => \clipped_count_reg[11]_i_1_n_2\,
      CO(0) => \clipped_count_reg[11]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => next_clipped(11 downto 8),
      S(3) => \clipped_count_reg_n_0_[11]\,
      S(2) => \clipped_count_reg_n_0_[10]\,
      S(1) => \clipped_count_reg_n_0_[9]\,
      S(0) => \clipped_count_reg_n_0_[8]\
    );
\clipped_count_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(12),
      Q => \clipped_count_reg_n_0_[12]\,
      R => clipped_count(0)
    );
\clipped_count_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(13),
      Q => \clipped_count_reg_n_0_[13]\,
      R => clipped_count(0)
    );
\clipped_count_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(14),
      Q => \clipped_count_reg_n_0_[14]\,
      R => clipped_count(0)
    );
\clipped_count_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(15),
      Q => \clipped_count_reg_n_0_[15]\,
      R => clipped_count(0)
    );
\clipped_count_reg[15]_i_3\: unisim.vcomponents.CARRY4
     port map (
      CI => \clipped_count_reg[11]_i_1_n_0\,
      CO(3) => \clipped_count_reg[15]_i_3_n_0\,
      CO(2) => \clipped_count_reg[15]_i_3_n_1\,
      CO(1) => \clipped_count_reg[15]_i_3_n_2\,
      CO(0) => \clipped_count_reg[15]_i_3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => next_clipped(15 downto 12),
      S(3) => \clipped_count_reg_n_0_[15]\,
      S(2) => \clipped_count_reg_n_0_[14]\,
      S(1) => \clipped_count_reg_n_0_[13]\,
      S(0) => \clipped_count_reg_n_0_[12]\
    );
\clipped_count_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(1),
      Q => \clipped_count_reg_n_0_[1]\,
      R => clipped_count(0)
    );
\clipped_count_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(2),
      Q => \clipped_count_reg_n_0_[2]\,
      R => clipped_count(0)
    );
\clipped_count_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(3),
      Q => \clipped_count_reg_n_0_[3]\,
      R => clipped_count(0)
    );
\clipped_count_reg[3]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \clipped_count_reg[3]_i_1_n_0\,
      CO(2) => \clipped_count_reg[3]_i_1_n_1\,
      CO(1) => \clipped_count_reg[3]_i_1_n_2\,
      CO(0) => \clipped_count_reg[3]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => \clipped_count_reg_n_0_[0]\,
      O(3 downto 0) => next_clipped(3 downto 0),
      S(3) => \clipped_count_reg_n_0_[3]\,
      S(2) => \clipped_count_reg_n_0_[2]\,
      S(1) => \clipped_count_reg_n_0_[1]\,
      S(0) => \clipped_count[3]_i_2_n_0\
    );
\clipped_count_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(4),
      Q => \clipped_count_reg_n_0_[4]\,
      R => clipped_count(0)
    );
\clipped_count_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(5),
      Q => \clipped_count_reg_n_0_[5]\,
      R => clipped_count(0)
    );
\clipped_count_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(6),
      Q => \clipped_count_reg_n_0_[6]\,
      R => clipped_count(0)
    );
\clipped_count_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(7),
      Q => \clipped_count_reg_n_0_[7]\,
      R => clipped_count(0)
    );
\clipped_count_reg[7]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \clipped_count_reg[3]_i_1_n_0\,
      CO(3) => \clipped_count_reg[7]_i_1_n_0\,
      CO(2) => \clipped_count_reg[7]_i_1_n_1\,
      CO(1) => \clipped_count_reg[7]_i_1_n_2\,
      CO(0) => \clipped_count_reg[7]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => next_clipped(7 downto 4),
      S(3) => \clipped_count_reg_n_0_[7]\,
      S(2) => \clipped_count_reg_n_0_[6]\,
      S(1) => \clipped_count_reg_n_0_[5]\,
      S(0) => \clipped_count_reg_n_0_[4]\
    );
\clipped_count_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(8),
      Q => \clipped_count_reg_n_0_[8]\,
      R => clipped_count(0)
    );
\clipped_count_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => next_clipped(9),
      Q => \clipped_count_reg_n_0_[9]\,
      R => clipped_count(0)
    );
dc_clipped_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BFFF"
    )
        port map (
      I0 => configure,
      I1 => s_axi_aresetn,
      I2 => \faults_reg[0]_1\(0),
      I3 => \event_age[31]_i_1_n_0\,
      O => dc_level0
    );
dc_clipped_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => pcm_valid,
      I1 => dc_valid,
      I2 => filtered_valid,
      O => scaled_latched0
    );
dc_clipped_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_clipped0,
      Q => dc_clipped,
      R => dc_level0
    );
dc_difference_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => dc_difference_carry_n_0,
      CO(2) => dc_difference_carry_n_1,
      CO(1) => dc_difference_carry_n_2,
      CO(0) => dc_difference_carry_n_3,
      CYINIT => p_0_out(0),
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_dc_difference_carry_O_UNCONNECTED(3 downto 0),
      S(3 downto 0) => p_0_out(4 downto 1)
    );
\dc_difference_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => dc_difference_carry_n_0,
      CO(3) => \dc_difference_carry__0_n_0\,
      CO(2) => \dc_difference_carry__0_n_1\,
      CO(1) => \dc_difference_carry__0_n_2\,
      CO(0) => \dc_difference_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => D(0),
      DI(2 downto 0) => B"000",
      O(3 downto 0) => \NLW_dc_difference_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \difference_latched_reg[12]_0\(0),
      S(2 downto 0) => p_0_out(7 downto 5)
    );
\dc_difference_carry__0_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => dc_level(7),
      O => p_0_out(7)
    );
\dc_difference_carry__0_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => dc_level(6),
      O => p_0_out(6)
    );
\dc_difference_carry__0_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => dc_level(5),
      O => p_0_out(5)
    );
\dc_difference_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \dc_difference_carry__0_n_0\,
      CO(3) => \dc_difference_carry__1_n_0\,
      CO(2) => \dc_difference_carry__1_n_1\,
      CO(1) => \dc_difference_carry__1_n_2\,
      CO(0) => \dc_difference_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => D(4 downto 1),
      O(3 downto 1) => dc_difference(12 downto 10),
      O(0) => \NLW_dc_difference_carry__1_O_UNCONNECTED\(0),
      S(3 downto 0) => \difference_latched_reg[12]_1\(3 downto 0)
    );
\dc_difference_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \dc_difference_carry__1_n_0\,
      CO(3) => \dc_difference_carry__2_n_0\,
      CO(2) => \dc_difference_carry__2_n_1\,
      CO(1) => \dc_difference_carry__2_n_2\,
      CO(0) => \dc_difference_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => D(8 downto 5),
      O(3 downto 0) => dc_difference(16 downto 13),
      S(3 downto 0) => S(3 downto 0)
    );
\dc_difference_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \dc_difference_carry__2_n_0\,
      CO(3) => \dc_difference_carry__3_n_0\,
      CO(2) => \dc_difference_carry__3_n_1\,
      CO(1) => \dc_difference_carry__3_n_2\,
      CO(0) => \dc_difference_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => D(12 downto 9),
      O(3 downto 0) => dc_difference(20 downto 17),
      S(3 downto 0) => \difference_latched_reg[20]_0\(3 downto 0)
    );
\dc_difference_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \dc_difference_carry__3_n_0\,
      CO(3) => \dc_difference_carry__4_n_0\,
      CO(2) => \dc_difference_carry__4_n_1\,
      CO(1) => \dc_difference_carry__4_n_2\,
      CO(0) => \dc_difference_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => dc_level(24 downto 23),
      DI(1 downto 0) => D(14 downto 13),
      O(3 downto 0) => dc_difference(24 downto 21),
      S(3) => \dc_difference_carry__4_i_1_n_0\,
      S(2) => \dc_difference_carry__4_i_2_n_0\,
      S(1 downto 0) => \difference_latched_reg[24]_0\(1 downto 0)
    );
\dc_difference_carry__4_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dc_level(23),
      I1 => dc_level(24),
      O => \dc_difference_carry__4_i_1_n_0\
    );
\dc_difference_carry__4_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dc_level(23),
      I1 => D(15),
      O => \dc_difference_carry__4_i_2_n_0\
    );
\dc_difference_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \dc_difference_carry__4_n_0\,
      CO(3 downto 0) => \NLW_dc_difference_carry__5_CO_UNCONNECTED\(3 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 1) => \NLW_dc_difference_carry__5_O_UNCONNECTED\(3 downto 1),
      O(0) => dc_difference(25),
      S(3 downto 0) => B"0001"
    );
dc_difference_carry_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => dc_level(0),
      O => p_0_out(0)
    );
dc_difference_carry_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => dc_level(4),
      O => p_0_out(4)
    );
dc_difference_carry_i_3: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => dc_level(3),
      O => p_0_out(3)
    );
dc_difference_carry_i_4: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => dc_level(2),
      O => p_0_out(2)
    );
dc_difference_carry_i_5: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => dc_level(1),
      O => p_0_out(1)
    );
\dc_level_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => next_dc_carry_n_7,
      Q => dc_level(0),
      R => dc_level0
    );
\dc_level_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__1_n_5\,
      Q => \^dc_level_reg[22]_0\(2),
      R => dc_level0
    );
\dc_level_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__1_n_4\,
      Q => \^dc_level_reg[22]_0\(3),
      R => dc_level0
    );
\dc_level_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__2_n_7\,
      Q => \^dc_level_reg[22]_0\(4),
      R => dc_level0
    );
\dc_level_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__2_n_6\,
      Q => \^dc_level_reg[22]_0\(5),
      R => dc_level0
    );
\dc_level_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__2_n_5\,
      Q => \^dc_level_reg[22]_0\(6),
      R => dc_level0
    );
\dc_level_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__2_n_4\,
      Q => \^dc_level_reg[22]_0\(7),
      R => dc_level0
    );
\dc_level_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__3_n_7\,
      Q => \^dc_level_reg[22]_0\(8),
      R => dc_level0
    );
\dc_level_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__3_n_6\,
      Q => \^dc_level_reg[22]_0\(9),
      R => dc_level0
    );
\dc_level_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__3_n_5\,
      Q => \^dc_level_reg[22]_0\(10),
      R => dc_level0
    );
\dc_level_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__3_n_4\,
      Q => \^dc_level_reg[22]_0\(11),
      R => dc_level0
    );
\dc_level_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => next_dc_carry_n_6,
      Q => dc_level(1),
      R => dc_level0
    );
\dc_level_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__4_n_7\,
      Q => \^dc_level_reg[22]_0\(12),
      R => dc_level0
    );
\dc_level_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__4_n_6\,
      Q => \^dc_level_reg[22]_0\(13),
      R => dc_level0
    );
\dc_level_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__4_n_5\,
      Q => \^dc_level_reg[22]_0\(14),
      R => dc_level0
    );
\dc_level_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__4_n_4\,
      Q => dc_level(23),
      R => dc_level0
    );
\dc_level_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__5_n_7\,
      Q => dc_level(24),
      R => dc_level0
    );
\dc_level_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => next_dc_carry_n_5,
      Q => dc_level(2),
      R => dc_level0
    );
\dc_level_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => next_dc_carry_n_4,
      Q => dc_level(3),
      R => dc_level0
    );
\dc_level_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__0_n_7\,
      Q => dc_level(4),
      R => dc_level0
    );
\dc_level_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__0_n_6\,
      Q => dc_level(5),
      R => dc_level0
    );
\dc_level_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__0_n_5\,
      Q => dc_level(6),
      R => dc_level0
    );
\dc_level_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__0_n_4\,
      Q => dc_level(7),
      R => dc_level0
    );
\dc_level_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__1_n_7\,
      Q => \^dc_level_reg[22]_0\(0),
      R => dc_level0
    );
\dc_level_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => \next_dc_carry__1_n_6\,
      Q => \^dc_level_reg[22]_0\(1),
      R => dc_level0
    );
dc_valid_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0010"
    )
        port map (
      I0 => filtered_valid,
      I1 => dc_valid,
      I2 => pcm_valid,
      I3 => dc_level0,
      O => dc_valid_i_1_n_0
    );
dc_valid_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => dc_valid_i_1_n_0,
      Q => dc_valid,
      R => '0'
    );
\difference_latched_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(10),
      Q => \difference_latched_reg_n_0_[10]\,
      R => dc_level0
    );
\difference_latched_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(11),
      Q => \difference_latched_reg_n_0_[11]\,
      R => dc_level0
    );
\difference_latched_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(12),
      Q => \difference_latched_reg_n_0_[12]\,
      R => dc_level0
    );
\difference_latched_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(13),
      Q => \difference_latched_reg_n_0_[13]\,
      R => dc_level0
    );
\difference_latched_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(14),
      Q => \difference_latched_reg_n_0_[14]\,
      R => dc_level0
    );
\difference_latched_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(15),
      Q => \difference_latched_reg_n_0_[15]\,
      R => dc_level0
    );
\difference_latched_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(16),
      Q => \difference_latched_reg_n_0_[16]\,
      R => dc_level0
    );
\difference_latched_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(17),
      Q => \difference_latched_reg_n_0_[17]\,
      R => dc_level0
    );
\difference_latched_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(18),
      Q => \difference_latched_reg_n_0_[18]\,
      R => dc_level0
    );
\difference_latched_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(19),
      Q => \difference_latched_reg_n_0_[19]\,
      R => dc_level0
    );
\difference_latched_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(20),
      Q => \difference_latched_reg_n_0_[20]\,
      R => dc_level0
    );
\difference_latched_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(21),
      Q => \difference_latched_reg_n_0_[21]\,
      R => dc_level0
    );
\difference_latched_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(22),
      Q => \difference_latched_reg_n_0_[22]\,
      R => dc_level0
    );
\difference_latched_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(23),
      Q => \difference_latched_reg_n_0_[23]\,
      R => dc_level0
    );
\difference_latched_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(24),
      Q => \difference_latched_reg_n_0_[24]\,
      R => dc_level0
    );
\difference_latched_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => dc_difference(25),
      Q => next_dc00,
      R => dc_level0
    );
event_age0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => event_age0_carry_n_0,
      CO(2) => event_age0_carry_n_1,
      CO(1) => event_age0_carry_n_2,
      CO(0) => event_age0_carry_n_3,
      CYINIT => \^q\(0),
      DI(3 downto 0) => B"0000",
      O(3) => event_age0_carry_n_4,
      O(2) => event_age0_carry_n_5,
      O(1) => event_age0_carry_n_6,
      O(0) => event_age0_carry_n_7,
      S(3 downto 0) => \^q\(4 downto 1)
    );
\event_age0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => event_age0_carry_n_0,
      CO(3) => \event_age0_carry__0_n_0\,
      CO(2) => \event_age0_carry__0_n_1\,
      CO(1) => \event_age0_carry__0_n_2\,
      CO(0) => \event_age0_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_age0_carry__0_n_4\,
      O(2) => \event_age0_carry__0_n_5\,
      O(1) => \event_age0_carry__0_n_6\,
      O(0) => \event_age0_carry__0_n_7\,
      S(3 downto 0) => \^q\(8 downto 5)
    );
\event_age0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_age0_carry__0_n_0\,
      CO(3) => \event_age0_carry__1_n_0\,
      CO(2) => \event_age0_carry__1_n_1\,
      CO(1) => \event_age0_carry__1_n_2\,
      CO(0) => \event_age0_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_age0_carry__1_n_4\,
      O(2) => \event_age0_carry__1_n_5\,
      O(1) => \event_age0_carry__1_n_6\,
      O(0) => \event_age0_carry__1_n_7\,
      S(3 downto 0) => \^q\(12 downto 9)
    );
\event_age0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_age0_carry__1_n_0\,
      CO(3) => \event_age0_carry__2_n_0\,
      CO(2) => \event_age0_carry__2_n_1\,
      CO(1) => \event_age0_carry__2_n_2\,
      CO(0) => \event_age0_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_age0_carry__2_n_4\,
      O(2) => \event_age0_carry__2_n_5\,
      O(1) => \event_age0_carry__2_n_6\,
      O(0) => \event_age0_carry__2_n_7\,
      S(3 downto 0) => \^q\(16 downto 13)
    );
\event_age0_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_age0_carry__2_n_0\,
      CO(3) => \event_age0_carry__3_n_0\,
      CO(2) => \event_age0_carry__3_n_1\,
      CO(1) => \event_age0_carry__3_n_2\,
      CO(0) => \event_age0_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_age0_carry__3_n_4\,
      O(2) => \event_age0_carry__3_n_5\,
      O(1) => \event_age0_carry__3_n_6\,
      O(0) => \event_age0_carry__3_n_7\,
      S(3 downto 0) => \^q\(20 downto 17)
    );
\event_age0_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_age0_carry__3_n_0\,
      CO(3) => \event_age0_carry__4_n_0\,
      CO(2) => \event_age0_carry__4_n_1\,
      CO(1) => \event_age0_carry__4_n_2\,
      CO(0) => \event_age0_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_age0_carry__4_n_4\,
      O(2) => \event_age0_carry__4_n_5\,
      O(1) => \event_age0_carry__4_n_6\,
      O(0) => \event_age0_carry__4_n_7\,
      S(3 downto 0) => \^q\(24 downto 21)
    );
\event_age0_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_age0_carry__4_n_0\,
      CO(3) => \event_age0_carry__5_n_0\,
      CO(2) => \event_age0_carry__5_n_1\,
      CO(1) => \event_age0_carry__5_n_2\,
      CO(0) => \event_age0_carry__5_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_age0_carry__5_n_4\,
      O(2) => \event_age0_carry__5_n_5\,
      O(1) => \event_age0_carry__5_n_6\,
      O(0) => \event_age0_carry__5_n_7\,
      S(3 downto 0) => \^q\(28 downto 25)
    );
\event_age0_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_age0_carry__5_n_0\,
      CO(3 downto 2) => \NLW_event_age0_carry__6_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \event_age0_carry__6_n_2\,
      CO(0) => \event_age0_carry__6_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \NLW_event_age0_carry__6_O_UNCONNECTED\(3),
      O(2) => \event_age0_carry__6_n_5\,
      O(1) => \event_age0_carry__6_n_6\,
      O(0) => \event_age0_carry__6_n_7\,
      S(3) => '0',
      S(2 downto 0) => \^q\(31 downto 29)
    );
\event_age[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0070"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \^q\(0),
      O => \event_age[0]_i_1_n_0\
    );
\event_age[10]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__1_n_6\,
      O => \event_age[10]_i_1_n_0\
    );
\event_age[11]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__1_n_5\,
      O => \event_age[11]_i_1_n_0\
    );
\event_age[12]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__1_n_4\,
      O => \event_age[12]_i_1_n_0\
    );
\event_age[13]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__2_n_7\,
      O => \event_age[13]_i_1_n_0\
    );
\event_age[14]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__2_n_6\,
      O => \event_age[14]_i_1_n_0\
    );
\event_age[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__2_n_5\,
      O => \event_age[15]_i_1_n_0\
    );
\event_age[16]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__2_n_4\,
      O => \event_age[16]_i_1_n_0\
    );
\event_age[17]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__3_n_7\,
      O => \event_age[17]_i_1_n_0\
    );
\event_age[18]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__3_n_6\,
      O => \event_age[18]_i_1_n_0\
    );
\event_age[19]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__3_n_5\,
      O => \event_age[19]_i_1_n_0\
    );
\event_age[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => event_age0_carry_n_7,
      O => \event_age[1]_i_1_n_0\
    );
\event_age[20]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__3_n_4\,
      O => \event_age[20]_i_1_n_0\
    );
\event_age[21]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__4_n_7\,
      O => \event_age[21]_i_1_n_0\
    );
\event_age[22]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__4_n_6\,
      O => \event_age[22]_i_1_n_0\
    );
\event_age[23]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__4_n_5\,
      O => \event_age[23]_i_1_n_0\
    );
\event_age[24]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__4_n_4\,
      O => \event_age[24]_i_1_n_0\
    );
\event_age[25]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__5_n_7\,
      O => \event_age[25]_i_1_n_0\
    );
\event_age[26]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__5_n_6\,
      O => \event_age[26]_i_1_n_0\
    );
\event_age[27]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__5_n_5\,
      O => \event_age[27]_i_1_n_0\
    );
\event_age[28]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__5_n_4\,
      O => \event_age[28]_i_1_n_0\
    );
\event_age[29]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__6_n_7\,
      O => \event_age[29]_i_1_n_0\
    );
\event_age[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => event_age0_carry_n_6,
      O => \event_age[2]_i_1_n_0\
    );
\event_age[30]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__6_n_6\,
      O => \event_age[30]_i_1_n_0\
    );
\event_age[31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => \event_age[31]_i_3_n_0\,
      I1 => \^faults_reg[7]_0\(0),
      I2 => \^faults_reg[7]_0\(3),
      I3 => \^faults_reg[7]_0\(1),
      I4 => \^faults_reg[7]_0\(2),
      O => \event_age[31]_i_1_n_0\
    );
\event_age[31]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__6_n_5\,
      O => \event_age[31]_i_2_n_0\
    );
\event_age[31]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^faults_reg[7]_0\(4),
      I1 => \^faults_reg[7]_0\(5),
      I2 => \^faults_reg[7]_0\(6),
      I3 => \^faults_reg[7]_0\(7),
      O => \event_age[31]_i_3_n_0\
    );
\event_age[31]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000004"
    )
        port map (
      I0 => \event_age[31]_i_6_n_0\,
      I1 => filtered_valid,
      I2 => \sample_in_window_reg_n_0_[2]\,
      I3 => \sample_in_window_reg_n_0_[0]\,
      I4 => \sample_in_window_reg_n_0_[1]\,
      O => \event_age[31]_i_4_n_0\
    );
\event_age[31]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5400540054004400"
    )
        port map (
      I0 => \^status\(4),
      I1 => \event_kind[1]_i_3_n_0\,
      I2 => \event_age[31]_i_7_n_0\,
      I3 => \event_age[31]_i_8_n_0\,
      I4 => candidate_count(1),
      I5 => candidate_count(2),
      O => \event_age[31]_i_5_n_0\
    );
\event_age[31]_i_6\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FB"
    )
        port map (
      I0 => \sample_in_window[0]_i_2_n_0\,
      I1 => \sample_in_window_reg_n_0_[9]\,
      I2 => \sample_in_window_reg_n_0_[3]\,
      O => \event_age[31]_i_6_n_0\
    );
\event_age[31]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000E00"
    )
        port map (
      I0 => \soft_count_reg_n_0_[2]\,
      I1 => \soft_count_reg_n_0_[1]\,
      I2 => above_loud,
      I3 => p_1_in,
      I4 => high_seen_reg_n_0,
      O => \event_age[31]_i_7_n_0\
    );
\event_age[31]_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \^status\(3),
      I1 => \^status\(2),
      O => \event_age[31]_i_8_n_0\
    );
\event_age[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => event_age0_carry_n_5,
      O => \event_age[3]_i_1_n_0\
    );
\event_age[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => event_age0_carry_n_4,
      O => \event_age[4]_i_1_n_0\
    );
\event_age[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__0_n_7\,
      O => \event_age[5]_i_1_n_0\
    );
\event_age[6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__0_n_6\,
      O => \event_age[6]_i_1_n_0\
    );
\event_age[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__0_n_5\,
      O => \event_age[7]_i_1_n_0\
    );
\event_age[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__0_n_4\,
      O => \event_age[8]_i_1_n_0\
    );
\event_age[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7000"
    )
        port map (
      I0 => \event_age[31]_i_4_n_0\,
      I1 => \event_age[31]_i_5_n_0\,
      I2 => \^status\(0),
      I3 => \event_age0_carry__1_n_7\,
      O => \event_age[9]_i_1_n_0\
    );
\event_age_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[0]_i_1_n_0\,
      Q => \^q\(0),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[10]_i_1_n_0\,
      Q => \^q\(10),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[11]_i_1_n_0\,
      Q => \^q\(11),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[12]_i_1_n_0\,
      Q => \^q\(12),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[13]_i_1_n_0\,
      Q => \^q\(13),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[14]_i_1_n_0\,
      Q => \^q\(14),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[15]_i_1_n_0\,
      Q => \^q\(15),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[16]_i_1_n_0\,
      Q => \^q\(16),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[17]_i_1_n_0\,
      Q => \^q\(17),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[18]_i_1_n_0\,
      Q => \^q\(18),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[19]_i_1_n_0\,
      Q => \^q\(19),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[1]_i_1_n_0\,
      Q => \^q\(1),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[20]_i_1_n_0\,
      Q => \^q\(20),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[21]_i_1_n_0\,
      Q => \^q\(21),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[22]_i_1_n_0\,
      Q => \^q\(22),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[23]_i_1_n_0\,
      Q => \^q\(23),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[24]_i_1_n_0\,
      Q => \^q\(24),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[25]_i_1_n_0\,
      Q => \^q\(25),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[26]_i_1_n_0\,
      Q => \^q\(26),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[27]_i_1_n_0\,
      Q => \^q\(27),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[28]_i_1_n_0\,
      Q => \^q\(28),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[29]_i_1_n_0\,
      Q => \^q\(29),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[2]_i_1_n_0\,
      Q => \^q\(2),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[30]_i_1_n_0\,
      Q => \^q\(30),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[31]_i_2_n_0\,
      Q => \^q\(31),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[3]_i_1_n_0\,
      Q => \^q\(3),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[4]_i_1_n_0\,
      Q => \^q\(4),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[5]_i_1_n_0\,
      Q => \^q\(5),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[6]_i_1_n_0\,
      Q => \^q\(6),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[7]_i_1_n_0\,
      Q => \^q\(7),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[8]_i_1_n_0\,
      Q => \^q\(8),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_age_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_age[31]_i_1_n_0\,
      D => \event_age[9]_i_1_n_0\,
      Q => \^q\(9),
      R => \sample_in_window[9]_i_1_n_0\
    );
\event_epoch[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF80FF00FF00FF00"
    )
        port map (
      I0 => filtered_valid,
      I1 => \event_age[31]_i_1_n_0\,
      I2 => \faults_reg[0]_1\(0),
      I3 => configure,
      I4 => \clipped_count[15]_i_4_n_0\,
      I5 => \event_age[31]_i_5_n_0\,
      O => \event_epoch[31]_i_1_n_0\
    );
\event_epoch_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(0),
      Q => \^event_epoch_reg[31]_0\(0),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(10),
      Q => \^event_epoch_reg[31]_0\(10),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(11),
      Q => \^event_epoch_reg[31]_0\(11),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(12),
      Q => \^event_epoch_reg[31]_0\(12),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(13),
      Q => \^event_epoch_reg[31]_0\(13),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(14),
      Q => \^event_epoch_reg[31]_0\(14),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(15),
      Q => \^event_epoch_reg[31]_0\(15),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(16),
      Q => \^event_epoch_reg[31]_0\(16),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(17),
      Q => \^event_epoch_reg[31]_0\(17),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(18),
      Q => \^event_epoch_reg[31]_0\(18),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(19),
      Q => \^event_epoch_reg[31]_0\(19),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(1),
      Q => \^event_epoch_reg[31]_0\(1),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(20),
      Q => \^event_epoch_reg[31]_0\(20),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(21),
      Q => \^event_epoch_reg[31]_0\(21),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(22),
      Q => \^event_epoch_reg[31]_0\(22),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(23),
      Q => \^event_epoch_reg[31]_0\(23),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(24),
      Q => \^event_epoch_reg[31]_0\(24),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(25),
      Q => \^event_epoch_reg[31]_0\(25),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(26),
      Q => \^event_epoch_reg[31]_0\(26),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(27),
      Q => \^event_epoch_reg[31]_0\(27),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(28),
      Q => \^event_epoch_reg[31]_0\(28),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(29),
      Q => \^event_epoch_reg[31]_0\(29),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(2),
      Q => \^event_epoch_reg[31]_0\(2),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(30),
      Q => \^event_epoch_reg[31]_0\(30),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(31),
      Q => \^event_epoch_reg[31]_0\(31),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(3),
      Q => \^event_epoch_reg[31]_0\(3),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(4),
      Q => \^event_epoch_reg[31]_0\(4),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(5),
      Q => \^event_epoch_reg[31]_0\(5),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(6),
      Q => \^event_epoch_reg[31]_0\(6),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(7),
      Q => \^event_epoch_reg[31]_0\(7),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(8),
      Q => \^event_epoch_reg[31]_0\(8),
      R => \^s_axi_aresetn_0\
    );
\event_epoch_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_epoch[31]_i_1_n_0\,
      D => config_epoch_reg(9),
      Q => \^event_epoch_reg[31]_0\(9),
      R => \^s_axi_aresetn_0\
    );
\event_kind[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7F777F7F00000008"
    )
        port map (
      I0 => \clipped_count[15]_i_2_n_0\,
      I1 => \clipped_count[15]_i_4_n_0\,
      I2 => \^status\(4),
      I3 => \event_kind[1]_i_2_n_0\,
      I4 => \event_kind[1]_i_3_n_0\,
      I5 => \^event_kind_reg[1]_0\(0),
      O => \event_kind[0]_i_1_n_0\
    );
\event_kind[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7F7F7F7700080000"
    )
        port map (
      I0 => \clipped_count[15]_i_2_n_0\,
      I1 => \clipped_count[15]_i_4_n_0\,
      I2 => \^status\(4),
      I3 => \event_kind[1]_i_2_n_0\,
      I4 => \event_kind[1]_i_3_n_0\,
      I5 => \^event_kind_reg[1]_0\(1),
      O => \event_kind[1]_i_1_n_0\
    );
\event_kind[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF0FFF0FFF1FFFFF"
    )
        port map (
      I0 => candidate_count(2),
      I1 => candidate_count(1),
      I2 => \^status\(3),
      I3 => \^status\(2),
      I4 => \event_age[31]_i_7_n_0\,
      I5 => \event_kind[1]_i_3_n_0\,
      O => \event_kind[1]_i_2_n_0\
    );
\event_kind[1]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAA8"
    )
        port map (
      I0 => above_loud,
      I1 => loud_count(2),
      I2 => loud_count(0),
      I3 => loud_count(1),
      O => \event_kind[1]_i_3_n_0\
    );
\event_kind_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \event_kind[0]_i_1_n_0\,
      Q => \^event_kind_reg[1]_0\(0),
      R => \state[1]_i_1_n_0\
    );
\event_kind_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \event_kind[1]_i_1_n_0\,
      Q => \^event_kind_reg[1]_0\(1),
      R => \state[1]_i_1_n_0\
    );
event_pending_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000E2E200E2"
    )
        port map (
      I0 => \^status\(0),
      I1 => event_pending_i_2_n_0,
      I2 => event_pending4_out,
      I3 => \event_age[31]_i_1_n_0\,
      I4 => \faults[7]_i_5_n_0\,
      I5 => \sample_in_window[9]_i_1_n_0\,
      O => event_pending_i_1_n_0
    );
event_pending_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A8AA8888"
    )
        port map (
      I0 => \event_age[31]_i_1_n_0\,
      I1 => ack_error_i_3_n_0,
      I2 => \^status\(4),
      I3 => \event_kind[1]_i_2_n_0\,
      I4 => \event_age[31]_i_4_n_0\,
      O => event_pending_i_2_n_0
    );
event_pending_i_3: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \event_age[31]_i_5_n_0\,
      I1 => \clipped_count[15]_i_4_n_0\,
      I2 => filtered_valid,
      O => event_pending4_out
    );
event_pending_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => event_pending_i_1_n_0,
      Q => \^status\(0),
      R => '0'
    );
\event_sample[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^out\(0),
      O => \event_sample[0]_i_1_n_0\
    );
\event_sample[63]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0080000000000000"
    )
        port map (
      I0 => filtered_valid,
      I1 => \event_age[31]_i_1_n_0\,
      I2 => \faults_reg[0]_1\(0),
      I3 => configure,
      I4 => \clipped_count[15]_i_4_n_0\,
      I5 => \event_age[31]_i_5_n_0\,
      O => \event_sample[63]_i_1_n_0\
    );
\event_sample_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample[0]_i_1_n_0\,
      Q => \event_sample_reg[63]_0\(0),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[12]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(10),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[12]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(11),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[12]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(12),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[8]_i_1_n_0\,
      CO(3) => \event_sample_reg[12]_i_1_n_0\,
      CO(2) => \event_sample_reg[12]_i_1_n_1\,
      CO(1) => \event_sample_reg[12]_i_1_n_2\,
      CO(0) => \event_sample_reg[12]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[12]_i_1_n_4\,
      O(2) => \event_sample_reg[12]_i_1_n_5\,
      O(1) => \event_sample_reg[12]_i_1_n_6\,
      O(0) => \event_sample_reg[12]_i_1_n_7\,
      S(3 downto 0) => \^out\(12 downto 9)
    );
\event_sample_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[16]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(13),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[16]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(14),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[16]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(15),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[16]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(16),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[16]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[12]_i_1_n_0\,
      CO(3) => \event_sample_reg[16]_i_1_n_0\,
      CO(2) => \event_sample_reg[16]_i_1_n_1\,
      CO(1) => \event_sample_reg[16]_i_1_n_2\,
      CO(0) => \event_sample_reg[16]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[16]_i_1_n_4\,
      O(2) => \event_sample_reg[16]_i_1_n_5\,
      O(1) => \event_sample_reg[16]_i_1_n_6\,
      O(0) => \event_sample_reg[16]_i_1_n_7\,
      S(3 downto 0) => \^out\(16 downto 13)
    );
\event_sample_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[20]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(17),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[20]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(18),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[20]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(19),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[4]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(1),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[20]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(20),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[20]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[16]_i_1_n_0\,
      CO(3) => \event_sample_reg[20]_i_1_n_0\,
      CO(2) => \event_sample_reg[20]_i_1_n_1\,
      CO(1) => \event_sample_reg[20]_i_1_n_2\,
      CO(0) => \event_sample_reg[20]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[20]_i_1_n_4\,
      O(2) => \event_sample_reg[20]_i_1_n_5\,
      O(1) => \event_sample_reg[20]_i_1_n_6\,
      O(0) => \event_sample_reg[20]_i_1_n_7\,
      S(3 downto 0) => \^out\(20 downto 17)
    );
\event_sample_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[24]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(21),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[24]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(22),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[24]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(23),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[24]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(24),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[24]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[20]_i_1_n_0\,
      CO(3) => \event_sample_reg[24]_i_1_n_0\,
      CO(2) => \event_sample_reg[24]_i_1_n_1\,
      CO(1) => \event_sample_reg[24]_i_1_n_2\,
      CO(0) => \event_sample_reg[24]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[24]_i_1_n_4\,
      O(2) => \event_sample_reg[24]_i_1_n_5\,
      O(1) => \event_sample_reg[24]_i_1_n_6\,
      O(0) => \event_sample_reg[24]_i_1_n_7\,
      S(3 downto 0) => \^out\(24 downto 21)
    );
\event_sample_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[28]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(25),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[28]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(26),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[28]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(27),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[28]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(28),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[28]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[24]_i_1_n_0\,
      CO(3) => \event_sample_reg[28]_i_1_n_0\,
      CO(2) => \event_sample_reg[28]_i_1_n_1\,
      CO(1) => \event_sample_reg[28]_i_1_n_2\,
      CO(0) => \event_sample_reg[28]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[28]_i_1_n_4\,
      O(2) => \event_sample_reg[28]_i_1_n_5\,
      O(1) => \event_sample_reg[28]_i_1_n_6\,
      O(0) => \event_sample_reg[28]_i_1_n_7\,
      S(3 downto 0) => \^out\(28 downto 25)
    );
\event_sample_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[32]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(29),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[4]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(2),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[32]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(30),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[32]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(31),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[32]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(32),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[32]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[28]_i_1_n_0\,
      CO(3) => \event_sample_reg[32]_i_1_n_0\,
      CO(2) => \event_sample_reg[32]_i_1_n_1\,
      CO(1) => \event_sample_reg[32]_i_1_n_2\,
      CO(0) => \event_sample_reg[32]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[32]_i_1_n_4\,
      O(2) => \event_sample_reg[32]_i_1_n_5\,
      O(1) => \event_sample_reg[32]_i_1_n_6\,
      O(0) => \event_sample_reg[32]_i_1_n_7\,
      S(3 downto 0) => \^out\(32 downto 29)
    );
\event_sample_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[36]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(33),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[36]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(34),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[36]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(35),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[36]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(36),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[36]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[32]_i_1_n_0\,
      CO(3) => \event_sample_reg[36]_i_1_n_0\,
      CO(2) => \event_sample_reg[36]_i_1_n_1\,
      CO(1) => \event_sample_reg[36]_i_1_n_2\,
      CO(0) => \event_sample_reg[36]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[36]_i_1_n_4\,
      O(2) => \event_sample_reg[36]_i_1_n_5\,
      O(1) => \event_sample_reg[36]_i_1_n_6\,
      O(0) => \event_sample_reg[36]_i_1_n_7\,
      S(3 downto 0) => \^out\(36 downto 33)
    );
\event_sample_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[40]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(37),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[40]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(38),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[40]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(39),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[4]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(3),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[40]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(40),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[40]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[36]_i_1_n_0\,
      CO(3) => \event_sample_reg[40]_i_1_n_0\,
      CO(2) => \event_sample_reg[40]_i_1_n_1\,
      CO(1) => \event_sample_reg[40]_i_1_n_2\,
      CO(0) => \event_sample_reg[40]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[40]_i_1_n_4\,
      O(2) => \event_sample_reg[40]_i_1_n_5\,
      O(1) => \event_sample_reg[40]_i_1_n_6\,
      O(0) => \event_sample_reg[40]_i_1_n_7\,
      S(3 downto 0) => \^out\(40 downto 37)
    );
\event_sample_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[44]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(41),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[44]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(42),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[44]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(43),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[44]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(44),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[44]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[40]_i_1_n_0\,
      CO(3) => \event_sample_reg[44]_i_1_n_0\,
      CO(2) => \event_sample_reg[44]_i_1_n_1\,
      CO(1) => \event_sample_reg[44]_i_1_n_2\,
      CO(0) => \event_sample_reg[44]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[44]_i_1_n_4\,
      O(2) => \event_sample_reg[44]_i_1_n_5\,
      O(1) => \event_sample_reg[44]_i_1_n_6\,
      O(0) => \event_sample_reg[44]_i_1_n_7\,
      S(3 downto 0) => \^out\(44 downto 41)
    );
\event_sample_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[48]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(45),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[48]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(46),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[48]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(47),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[48]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(48),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[48]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[44]_i_1_n_0\,
      CO(3) => \event_sample_reg[48]_i_1_n_0\,
      CO(2) => \event_sample_reg[48]_i_1_n_1\,
      CO(1) => \event_sample_reg[48]_i_1_n_2\,
      CO(0) => \event_sample_reg[48]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[48]_i_1_n_4\,
      O(2) => \event_sample_reg[48]_i_1_n_5\,
      O(1) => \event_sample_reg[48]_i_1_n_6\,
      O(0) => \event_sample_reg[48]_i_1_n_7\,
      S(3 downto 0) => \^out\(48 downto 45)
    );
\event_sample_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[52]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(49),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[4]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(4),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \event_sample_reg[4]_i_1_n_0\,
      CO(2) => \event_sample_reg[4]_i_1_n_1\,
      CO(1) => \event_sample_reg[4]_i_1_n_2\,
      CO(0) => \event_sample_reg[4]_i_1_n_3\,
      CYINIT => \^out\(0),
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[4]_i_1_n_4\,
      O(2) => \event_sample_reg[4]_i_1_n_5\,
      O(1) => \event_sample_reg[4]_i_1_n_6\,
      O(0) => \event_sample_reg[4]_i_1_n_7\,
      S(3 downto 0) => \^out\(4 downto 1)
    );
\event_sample_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[52]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(50),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[52]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(51),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[52]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(52),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[52]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[48]_i_1_n_0\,
      CO(3) => \event_sample_reg[52]_i_1_n_0\,
      CO(2) => \event_sample_reg[52]_i_1_n_1\,
      CO(1) => \event_sample_reg[52]_i_1_n_2\,
      CO(0) => \event_sample_reg[52]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[52]_i_1_n_4\,
      O(2) => \event_sample_reg[52]_i_1_n_5\,
      O(1) => \event_sample_reg[52]_i_1_n_6\,
      O(0) => \event_sample_reg[52]_i_1_n_7\,
      S(3 downto 0) => \^out\(52 downto 49)
    );
\event_sample_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[56]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(53),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[56]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(54),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[56]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(55),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[56]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(56),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[56]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[52]_i_1_n_0\,
      CO(3) => \event_sample_reg[56]_i_1_n_0\,
      CO(2) => \event_sample_reg[56]_i_1_n_1\,
      CO(1) => \event_sample_reg[56]_i_1_n_2\,
      CO(0) => \event_sample_reg[56]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[56]_i_1_n_4\,
      O(2) => \event_sample_reg[56]_i_1_n_5\,
      O(1) => \event_sample_reg[56]_i_1_n_6\,
      O(0) => \event_sample_reg[56]_i_1_n_7\,
      S(3 downto 0) => \^out\(56 downto 53)
    );
\event_sample_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[60]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(57),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[60]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(58),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[60]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(59),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[8]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(5),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[60]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(60),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[60]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[56]_i_1_n_0\,
      CO(3) => \event_sample_reg[60]_i_1_n_0\,
      CO(2) => \event_sample_reg[60]_i_1_n_1\,
      CO(1) => \event_sample_reg[60]_i_1_n_2\,
      CO(0) => \event_sample_reg[60]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[60]_i_1_n_4\,
      O(2) => \event_sample_reg[60]_i_1_n_5\,
      O(1) => \event_sample_reg[60]_i_1_n_6\,
      O(0) => \event_sample_reg[60]_i_1_n_7\,
      S(3 downto 0) => \^out\(60 downto 57)
    );
\event_sample_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[63]_i_2_n_7\,
      Q => \event_sample_reg[63]_0\(61),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[63]_i_2_n_6\,
      Q => \event_sample_reg[63]_0\(62),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[63]_i_2_n_5\,
      Q => \event_sample_reg[63]_0\(63),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[63]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[60]_i_1_n_0\,
      CO(3 downto 2) => \NLW_event_sample_reg[63]_i_2_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \event_sample_reg[63]_i_2_n_2\,
      CO(0) => \event_sample_reg[63]_i_2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \NLW_event_sample_reg[63]_i_2_O_UNCONNECTED\(3),
      O(2) => \event_sample_reg[63]_i_2_n_5\,
      O(1) => \event_sample_reg[63]_i_2_n_6\,
      O(0) => \event_sample_reg[63]_i_2_n_7\,
      S(3) => '0',
      S(2 downto 0) => \^out\(63 downto 61)
    );
\event_sample_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[8]_i_1_n_6\,
      Q => \event_sample_reg[63]_0\(6),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[8]_i_1_n_5\,
      Q => \event_sample_reg[63]_0\(7),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[8]_i_1_n_4\,
      Q => \event_sample_reg[63]_0\(8),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sample_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sample_reg[4]_i_1_n_0\,
      CO(3) => \event_sample_reg[8]_i_1_n_0\,
      CO(2) => \event_sample_reg[8]_i_1_n_1\,
      CO(1) => \event_sample_reg[8]_i_1_n_2\,
      CO(0) => \event_sample_reg[8]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sample_reg[8]_i_1_n_4\,
      O(2) => \event_sample_reg[8]_i_1_n_5\,
      O(1) => \event_sample_reg[8]_i_1_n_6\,
      O(0) => \event_sample_reg[8]_i_1_n_7\,
      S(3 downto 0) => \^out\(8 downto 5)
    );
\event_sample_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sample_reg[12]_i_1_n_7\,
      Q => \event_sample_reg[63]_0\(9),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence[0]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^event_sequence_reg[31]_0\(0),
      O => \event_sequence[0]_i_2_n_0\
    );
\event_sequence_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[0]_i_1_n_7\,
      Q => \^event_sequence_reg[31]_0\(0),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[0]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \event_sequence_reg[0]_i_1_n_0\,
      CO(2) => \event_sequence_reg[0]_i_1_n_1\,
      CO(1) => \event_sequence_reg[0]_i_1_n_2\,
      CO(0) => \event_sequence_reg[0]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \event_sequence_reg[0]_i_1_n_4\,
      O(2) => \event_sequence_reg[0]_i_1_n_5\,
      O(1) => \event_sequence_reg[0]_i_1_n_6\,
      O(0) => \event_sequence_reg[0]_i_1_n_7\,
      S(3 downto 1) => \^event_sequence_reg[31]_0\(3 downto 1),
      S(0) => \event_sequence[0]_i_2_n_0\
    );
\event_sequence_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[8]_i_1_n_5\,
      Q => \^event_sequence_reg[31]_0\(10),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[8]_i_1_n_4\,
      Q => \^event_sequence_reg[31]_0\(11),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[12]_i_1_n_7\,
      Q => \^event_sequence_reg[31]_0\(12),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sequence_reg[8]_i_1_n_0\,
      CO(3) => \event_sequence_reg[12]_i_1_n_0\,
      CO(2) => \event_sequence_reg[12]_i_1_n_1\,
      CO(1) => \event_sequence_reg[12]_i_1_n_2\,
      CO(0) => \event_sequence_reg[12]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sequence_reg[12]_i_1_n_4\,
      O(2) => \event_sequence_reg[12]_i_1_n_5\,
      O(1) => \event_sequence_reg[12]_i_1_n_6\,
      O(0) => \event_sequence_reg[12]_i_1_n_7\,
      S(3 downto 0) => \^event_sequence_reg[31]_0\(15 downto 12)
    );
\event_sequence_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[12]_i_1_n_6\,
      Q => \^event_sequence_reg[31]_0\(13),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[12]_i_1_n_5\,
      Q => \^event_sequence_reg[31]_0\(14),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[12]_i_1_n_4\,
      Q => \^event_sequence_reg[31]_0\(15),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[16]_i_1_n_7\,
      Q => \^event_sequence_reg[31]_0\(16),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[16]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sequence_reg[12]_i_1_n_0\,
      CO(3) => \event_sequence_reg[16]_i_1_n_0\,
      CO(2) => \event_sequence_reg[16]_i_1_n_1\,
      CO(1) => \event_sequence_reg[16]_i_1_n_2\,
      CO(0) => \event_sequence_reg[16]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sequence_reg[16]_i_1_n_4\,
      O(2) => \event_sequence_reg[16]_i_1_n_5\,
      O(1) => \event_sequence_reg[16]_i_1_n_6\,
      O(0) => \event_sequence_reg[16]_i_1_n_7\,
      S(3 downto 0) => \^event_sequence_reg[31]_0\(19 downto 16)
    );
\event_sequence_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[16]_i_1_n_6\,
      Q => \^event_sequence_reg[31]_0\(17),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[16]_i_1_n_5\,
      Q => \^event_sequence_reg[31]_0\(18),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[16]_i_1_n_4\,
      Q => \^event_sequence_reg[31]_0\(19),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[0]_i_1_n_6\,
      Q => \^event_sequence_reg[31]_0\(1),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[20]_i_1_n_7\,
      Q => \^event_sequence_reg[31]_0\(20),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[20]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sequence_reg[16]_i_1_n_0\,
      CO(3) => \event_sequence_reg[20]_i_1_n_0\,
      CO(2) => \event_sequence_reg[20]_i_1_n_1\,
      CO(1) => \event_sequence_reg[20]_i_1_n_2\,
      CO(0) => \event_sequence_reg[20]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sequence_reg[20]_i_1_n_4\,
      O(2) => \event_sequence_reg[20]_i_1_n_5\,
      O(1) => \event_sequence_reg[20]_i_1_n_6\,
      O(0) => \event_sequence_reg[20]_i_1_n_7\,
      S(3 downto 0) => \^event_sequence_reg[31]_0\(23 downto 20)
    );
\event_sequence_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[20]_i_1_n_6\,
      Q => \^event_sequence_reg[31]_0\(21),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[20]_i_1_n_5\,
      Q => \^event_sequence_reg[31]_0\(22),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[20]_i_1_n_4\,
      Q => \^event_sequence_reg[31]_0\(23),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[24]_i_1_n_7\,
      Q => \^event_sequence_reg[31]_0\(24),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[24]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sequence_reg[20]_i_1_n_0\,
      CO(3) => \event_sequence_reg[24]_i_1_n_0\,
      CO(2) => \event_sequence_reg[24]_i_1_n_1\,
      CO(1) => \event_sequence_reg[24]_i_1_n_2\,
      CO(0) => \event_sequence_reg[24]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sequence_reg[24]_i_1_n_4\,
      O(2) => \event_sequence_reg[24]_i_1_n_5\,
      O(1) => \event_sequence_reg[24]_i_1_n_6\,
      O(0) => \event_sequence_reg[24]_i_1_n_7\,
      S(3 downto 0) => \^event_sequence_reg[31]_0\(27 downto 24)
    );
\event_sequence_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[24]_i_1_n_6\,
      Q => \^event_sequence_reg[31]_0\(25),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[24]_i_1_n_5\,
      Q => \^event_sequence_reg[31]_0\(26),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[24]_i_1_n_4\,
      Q => \^event_sequence_reg[31]_0\(27),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[28]_i_1_n_7\,
      Q => \^event_sequence_reg[31]_0\(28),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[28]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sequence_reg[24]_i_1_n_0\,
      CO(3) => \NLW_event_sequence_reg[28]_i_1_CO_UNCONNECTED\(3),
      CO(2) => \event_sequence_reg[28]_i_1_n_1\,
      CO(1) => \event_sequence_reg[28]_i_1_n_2\,
      CO(0) => \event_sequence_reg[28]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sequence_reg[28]_i_1_n_4\,
      O(2) => \event_sequence_reg[28]_i_1_n_5\,
      O(1) => \event_sequence_reg[28]_i_1_n_6\,
      O(0) => \event_sequence_reg[28]_i_1_n_7\,
      S(3 downto 0) => \^event_sequence_reg[31]_0\(31 downto 28)
    );
\event_sequence_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[28]_i_1_n_6\,
      Q => \^event_sequence_reg[31]_0\(29),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[0]_i_1_n_5\,
      Q => \^event_sequence_reg[31]_0\(2),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[28]_i_1_n_5\,
      Q => \^event_sequence_reg[31]_0\(30),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[28]_i_1_n_4\,
      Q => \^event_sequence_reg[31]_0\(31),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[0]_i_1_n_4\,
      Q => \^event_sequence_reg[31]_0\(3),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[4]_i_1_n_7\,
      Q => \^event_sequence_reg[31]_0\(4),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sequence_reg[0]_i_1_n_0\,
      CO(3) => \event_sequence_reg[4]_i_1_n_0\,
      CO(2) => \event_sequence_reg[4]_i_1_n_1\,
      CO(1) => \event_sequence_reg[4]_i_1_n_2\,
      CO(0) => \event_sequence_reg[4]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sequence_reg[4]_i_1_n_4\,
      O(2) => \event_sequence_reg[4]_i_1_n_5\,
      O(1) => \event_sequence_reg[4]_i_1_n_6\,
      O(0) => \event_sequence_reg[4]_i_1_n_7\,
      S(3 downto 0) => \^event_sequence_reg[31]_0\(7 downto 4)
    );
\event_sequence_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[4]_i_1_n_6\,
      Q => \^event_sequence_reg[31]_0\(5),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[4]_i_1_n_5\,
      Q => \^event_sequence_reg[31]_0\(6),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[4]_i_1_n_4\,
      Q => \^event_sequence_reg[31]_0\(7),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[8]_i_1_n_7\,
      Q => \^event_sequence_reg[31]_0\(8),
      R => \last_sum[31]_i_1_n_0\
    );
\event_sequence_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_sequence_reg[4]_i_1_n_0\,
      CO(3) => \event_sequence_reg[8]_i_1_n_0\,
      CO(2) => \event_sequence_reg[8]_i_1_n_1\,
      CO(1) => \event_sequence_reg[8]_i_1_n_2\,
      CO(0) => \event_sequence_reg[8]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_sequence_reg[8]_i_1_n_4\,
      O(2) => \event_sequence_reg[8]_i_1_n_5\,
      O(1) => \event_sequence_reg[8]_i_1_n_6\,
      O(0) => \event_sequence_reg[8]_i_1_n_7\,
      S(3 downto 0) => \^event_sequence_reg[31]_0\(11 downto 8)
    );
\event_sequence_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_sequence_reg[8]_i_1_n_6\,
      Q => \^event_sequence_reg[31]_0\(9),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^window_count_reg[31]_0\(0),
      O => \event_window[0]_i_1_n_0\
    );
\event_window_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window[0]_i_1_n_0\,
      Q => \event_window_reg[31]_0\(0),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[12]_i_1_n_6\,
      Q => \event_window_reg[31]_0\(10),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[12]_i_1_n_5\,
      Q => \event_window_reg[31]_0\(11),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[12]_i_1_n_4\,
      Q => \event_window_reg[31]_0\(12),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_window_reg[8]_i_1_n_0\,
      CO(3) => \event_window_reg[12]_i_1_n_0\,
      CO(2) => \event_window_reg[12]_i_1_n_1\,
      CO(1) => \event_window_reg[12]_i_1_n_2\,
      CO(0) => \event_window_reg[12]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_window_reg[12]_i_1_n_4\,
      O(2) => \event_window_reg[12]_i_1_n_5\,
      O(1) => \event_window_reg[12]_i_1_n_6\,
      O(0) => \event_window_reg[12]_i_1_n_7\,
      S(3 downto 0) => \^window_count_reg[31]_0\(12 downto 9)
    );
\event_window_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[16]_i_1_n_7\,
      Q => \event_window_reg[31]_0\(13),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[16]_i_1_n_6\,
      Q => \event_window_reg[31]_0\(14),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[16]_i_1_n_5\,
      Q => \event_window_reg[31]_0\(15),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[16]_i_1_n_4\,
      Q => \event_window_reg[31]_0\(16),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[16]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_window_reg[12]_i_1_n_0\,
      CO(3) => \event_window_reg[16]_i_1_n_0\,
      CO(2) => \event_window_reg[16]_i_1_n_1\,
      CO(1) => \event_window_reg[16]_i_1_n_2\,
      CO(0) => \event_window_reg[16]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_window_reg[16]_i_1_n_4\,
      O(2) => \event_window_reg[16]_i_1_n_5\,
      O(1) => \event_window_reg[16]_i_1_n_6\,
      O(0) => \event_window_reg[16]_i_1_n_7\,
      S(3 downto 0) => \^window_count_reg[31]_0\(16 downto 13)
    );
\event_window_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[20]_i_1_n_7\,
      Q => \event_window_reg[31]_0\(17),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[20]_i_1_n_6\,
      Q => \event_window_reg[31]_0\(18),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[20]_i_1_n_5\,
      Q => \event_window_reg[31]_0\(19),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[4]_i_1_n_7\,
      Q => \event_window_reg[31]_0\(1),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[20]_i_1_n_4\,
      Q => \event_window_reg[31]_0\(20),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[20]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_window_reg[16]_i_1_n_0\,
      CO(3) => \event_window_reg[20]_i_1_n_0\,
      CO(2) => \event_window_reg[20]_i_1_n_1\,
      CO(1) => \event_window_reg[20]_i_1_n_2\,
      CO(0) => \event_window_reg[20]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_window_reg[20]_i_1_n_4\,
      O(2) => \event_window_reg[20]_i_1_n_5\,
      O(1) => \event_window_reg[20]_i_1_n_6\,
      O(0) => \event_window_reg[20]_i_1_n_7\,
      S(3 downto 0) => \^window_count_reg[31]_0\(20 downto 17)
    );
\event_window_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[24]_i_1_n_7\,
      Q => \event_window_reg[31]_0\(21),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[24]_i_1_n_6\,
      Q => \event_window_reg[31]_0\(22),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[24]_i_1_n_5\,
      Q => \event_window_reg[31]_0\(23),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[24]_i_1_n_4\,
      Q => \event_window_reg[31]_0\(24),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[24]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_window_reg[20]_i_1_n_0\,
      CO(3) => \event_window_reg[24]_i_1_n_0\,
      CO(2) => \event_window_reg[24]_i_1_n_1\,
      CO(1) => \event_window_reg[24]_i_1_n_2\,
      CO(0) => \event_window_reg[24]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_window_reg[24]_i_1_n_4\,
      O(2) => \event_window_reg[24]_i_1_n_5\,
      O(1) => \event_window_reg[24]_i_1_n_6\,
      O(0) => \event_window_reg[24]_i_1_n_7\,
      S(3 downto 0) => \^window_count_reg[31]_0\(24 downto 21)
    );
\event_window_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[28]_i_1_n_7\,
      Q => \event_window_reg[31]_0\(25),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[28]_i_1_n_6\,
      Q => \event_window_reg[31]_0\(26),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[28]_i_1_n_5\,
      Q => \event_window_reg[31]_0\(27),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[28]_i_1_n_4\,
      Q => \event_window_reg[31]_0\(28),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[28]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_window_reg[24]_i_1_n_0\,
      CO(3) => \event_window_reg[28]_i_1_n_0\,
      CO(2) => \event_window_reg[28]_i_1_n_1\,
      CO(1) => \event_window_reg[28]_i_1_n_2\,
      CO(0) => \event_window_reg[28]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_window_reg[28]_i_1_n_4\,
      O(2) => \event_window_reg[28]_i_1_n_5\,
      O(1) => \event_window_reg[28]_i_1_n_6\,
      O(0) => \event_window_reg[28]_i_1_n_7\,
      S(3 downto 0) => \^window_count_reg[31]_0\(28 downto 25)
    );
\event_window_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[31]_i_1_n_7\,
      Q => \event_window_reg[31]_0\(29),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[4]_i_1_n_6\,
      Q => \event_window_reg[31]_0\(2),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[31]_i_1_n_6\,
      Q => \event_window_reg[31]_0\(30),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[31]_i_1_n_5\,
      Q => \event_window_reg[31]_0\(31),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[31]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_window_reg[28]_i_1_n_0\,
      CO(3 downto 2) => \NLW_event_window_reg[31]_i_1_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \event_window_reg[31]_i_1_n_2\,
      CO(0) => \event_window_reg[31]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \NLW_event_window_reg[31]_i_1_O_UNCONNECTED\(3),
      O(2) => \event_window_reg[31]_i_1_n_5\,
      O(1) => \event_window_reg[31]_i_1_n_6\,
      O(0) => \event_window_reg[31]_i_1_n_7\,
      S(3) => '0',
      S(2 downto 0) => \^window_count_reg[31]_0\(31 downto 29)
    );
\event_window_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[4]_i_1_n_5\,
      Q => \event_window_reg[31]_0\(3),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[4]_i_1_n_4\,
      Q => \event_window_reg[31]_0\(4),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \event_window_reg[4]_i_1_n_0\,
      CO(2) => \event_window_reg[4]_i_1_n_1\,
      CO(1) => \event_window_reg[4]_i_1_n_2\,
      CO(0) => \event_window_reg[4]_i_1_n_3\,
      CYINIT => \^window_count_reg[31]_0\(0),
      DI(3 downto 0) => B"0000",
      O(3) => \event_window_reg[4]_i_1_n_4\,
      O(2) => \event_window_reg[4]_i_1_n_5\,
      O(1) => \event_window_reg[4]_i_1_n_6\,
      O(0) => \event_window_reg[4]_i_1_n_7\,
      S(3 downto 0) => \^window_count_reg[31]_0\(4 downto 1)
    );
\event_window_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[8]_i_1_n_7\,
      Q => \event_window_reg[31]_0\(5),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[8]_i_1_n_6\,
      Q => \event_window_reg[31]_0\(6),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[8]_i_1_n_5\,
      Q => \event_window_reg[31]_0\(7),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[8]_i_1_n_4\,
      Q => \event_window_reg[31]_0\(8),
      R => \last_sum[31]_i_1_n_0\
    );
\event_window_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \event_window_reg[4]_i_1_n_0\,
      CO(3) => \event_window_reg[8]_i_1_n_0\,
      CO(2) => \event_window_reg[8]_i_1_n_1\,
      CO(1) => \event_window_reg[8]_i_1_n_2\,
      CO(0) => \event_window_reg[8]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \event_window_reg[8]_i_1_n_4\,
      O(2) => \event_window_reg[8]_i_1_n_5\,
      O(1) => \event_window_reg[8]_i_1_n_6\,
      O(0) => \event_window_reg[8]_i_1_n_7\,
      S(3 downto 0) => \^window_count_reg[31]_0\(8 downto 5)
    );
\event_window_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \event_sample[63]_i_1_n_0\,
      D => \event_window_reg[12]_i_1_n_7\,
      Q => \event_window_reg[31]_0\(9),
      R => \last_sum[31]_i_1_n_0\
    );
\faults[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => configure,
      I1 => \faults_reg[0]_1\(0),
      O => \faults[0]_i_1_n_0\
    );
\faults[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"D0FFD0D0D0D0D0D0"
    )
        port map (
      I0 => \faults_reg[0]_1\(0),
      I1 => configure,
      I2 => \^faults_reg[7]_0\(1),
      I3 => \faults[6]_i_4_n_0\,
      I4 => \faults[1]_i_2_n_0\,
      I5 => \faults[4]_i_2_n_0\,
      O => \faults[1]_i_1_n_0\
    );
\faults[1]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"45"
    )
        port map (
      I0 => pcm_valid,
      I1 => \sample_age[0]_i_3_n_0\,
      I2 => \faults[1]_i_3_n_0\,
      O => \faults[1]_i_2_n_0\
    );
\faults[1]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BFFFFFFFFFFFFFFF"
    )
        port map (
      I0 => \faults[1]_i_4_n_0\,
      I1 => sample_age_reg(9),
      I2 => sample_age_reg(0),
      I3 => sample_age_reg(14),
      I4 => sample_age_reg(2),
      I5 => \sample_age[0]_i_4_n_0\,
      O => \faults[1]_i_3_n_0\
    );
\faults[1]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => sample_age_reg(3),
      I1 => sample_age_reg(4),
      I2 => sample_age_reg(1),
      I3 => sample_age_reg(5),
      O => \faults[1]_i_4_n_0\
    );
\faults[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"D0D0D0D0D0FFD0D0"
    )
        port map (
      I0 => \faults_reg[0]_1\(0),
      I1 => configure,
      I2 => \^faults_reg[7]_0\(2),
      I3 => p_0_in,
      I4 => \faults[2]_i_2_n_0\,
      I5 => \faults[6]_i_5_n_0\,
      O => \faults[2]_i_1_n_0\
    );
\faults[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \faults[6]_i_10_n_0\,
      I1 => \faults[6]_i_9_n_0\,
      I2 => \faults[6]_i_8_n_0\,
      I3 => next_clipped(12),
      I4 => next_clipped(10),
      I5 => next_clipped(11),
      O => \faults[2]_i_2_n_0\
    );
\faults[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"D0FFD0D0"
    )
        port map (
      I0 => \faults_reg[0]_1\(0),
      I1 => configure,
      I2 => \^faults_reg[7]_0\(3),
      I3 => \faults[6]_i_5_n_0\,
      I4 => p_0_in,
      O => \faults[3]_i_1_n_0\
    );
\faults[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"D0D0D0FF"
    )
        port map (
      I0 => \faults_reg[0]_1\(0),
      I1 => configure,
      I2 => \^faults_reg[7]_0\(4),
      I3 => \faults[6]_i_4_n_0\,
      I4 => \faults[4]_i_2_n_0\,
      O => \faults[4]_i_1_n_0\
    );
\faults[4]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAABBBAFFFF"
    )
        port map (
      I0 => \faults[5]_i_11_n_0\,
      I1 => \faults[5]_i_10_n_0\,
      I2 => \faults[4]_i_3_n_0\,
      I3 => \faults[4]_i_4_n_0\,
      I4 => \^q\(23),
      I5 => \faults[5]_i_8_n_0\,
      O => \faults[4]_i_2_n_0\
    );
\faults[4]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000000111FFFF"
    )
        port map (
      I0 => \^q\(13),
      I1 => \^q\(14),
      I2 => \faults[4]_i_5_n_0\,
      I3 => \^q\(12),
      I4 => \^q\(15),
      I5 => \faults[5]_i_17_n_0\,
      O => \faults[4]_i_3_n_0\
    );
\faults[4]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => \^q\(20),
      I1 => \^q\(19),
      O => \faults[4]_i_4_n_0\
    );
\faults[4]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBBBBBBBBBBBABAA"
    )
        port map (
      I0 => \^q\(11),
      I1 => \faults[5]_i_22_n_0\,
      I2 => \faults[5]_i_21_n_0\,
      I3 => \faults[5]_i_20_n_0\,
      I4 => \^q\(7),
      I5 => \^q\(8),
      O => \faults[4]_i_5_n_0\
    );
\faults[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"D0D0D0FFD0D0D0D0"
    )
        port map (
      I0 => \faults_reg[0]_1\(0),
      I1 => configure,
      I2 => \^faults_reg[7]_0\(5),
      I3 => \faults[6]_i_4_n_0\,
      I4 => \faults[5]_i_2_n_0\,
      I5 => \faults[5]_i_3_n_0\,
      O => \faults[5]_i_1_n_0\
    );
\faults[5]_i_10\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \^q\(22),
      I1 => \^q\(21),
      O => \faults[5]_i_10_n_0\
    );
\faults[5]_i_11\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"80FF"
    )
        port map (
      I0 => matching_ack1,
      I1 => matching_ack0,
      I2 => ack_error_reg_0,
      I3 => \^status\(0),
      O => \faults[5]_i_11_n_0\
    );
\faults[5]_i_12\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^window_count_reg[31]_0\(18),
      I1 => \^window_count_reg[31]_0\(19),
      I2 => \^window_count_reg[31]_0\(16),
      I3 => \^window_count_reg[31]_0\(17),
      O => \faults[5]_i_12_n_0\
    );
\faults[5]_i_13\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^window_count_reg[31]_0\(31),
      I1 => \^window_count_reg[31]_0\(30),
      I2 => \^window_count_reg[31]_0\(28),
      I3 => \^window_count_reg[31]_0\(29),
      O => \faults[5]_i_13_n_0\
    );
\faults[5]_i_14\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^window_count_reg[31]_0\(14),
      I1 => \^window_count_reg[31]_0\(15),
      I2 => \^window_count_reg[31]_0\(12),
      I3 => \^window_count_reg[31]_0\(13),
      O => \faults[5]_i_14_n_0\
    );
\faults[5]_i_15\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^window_count_reg[31]_0\(6),
      I1 => \^window_count_reg[31]_0\(7),
      I2 => \^window_count_reg[31]_0\(4),
      I3 => \^window_count_reg[31]_0\(5),
      O => \faults[5]_i_15_n_0\
    );
\faults[5]_i_16\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^q\(29),
      I1 => \^q\(30),
      I2 => \^q\(25),
      I3 => \^q\(26),
      O => \faults[5]_i_16_n_0\
    );
\faults[5]_i_17\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => \^q\(18),
      I1 => \^q\(16),
      I2 => \^q\(17),
      O => \faults[5]_i_17_n_0\
    );
\faults[5]_i_18\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55555555FFFF7757"
    )
        port map (
      I0 => \^q\(12),
      I1 => \faults[5]_i_19_n_0\,
      I2 => \faults[5]_i_20_n_0\,
      I3 => \faults[5]_i_21_n_0\,
      I4 => \faults[5]_i_22_n_0\,
      I5 => \^q\(11),
      O => \faults[5]_i_18_n_0\
    );
\faults[5]_i_19\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \^q\(8),
      I1 => \^q\(7),
      O => \faults[5]_i_19_n_0\
    );
\faults[5]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"55555455"
    )
        port map (
      I0 => \p_0_out_inferred__3/i__carry__4_n_2\,
      I1 => \faults[5]_i_4_n_0\,
      I2 => \faults[5]_i_5_n_0\,
      I3 => \faults[5]_i_6_n_0\,
      I4 => \faults[5]_i_7_n_0\,
      O => \faults[5]_i_2_n_0\
    );
\faults[5]_i_20\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^q\(5),
      I1 => \^q\(1),
      I2 => \^q\(3),
      O => \faults[5]_i_20_n_0\
    );
\faults[5]_i_21\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^q\(6),
      I1 => \^q\(0),
      I2 => \^q\(2),
      I3 => \^q\(4),
      O => \faults[5]_i_21_n_0\
    );
\faults[5]_i_22\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => \^q\(10),
      I1 => \^q\(9),
      O => \faults[5]_i_22_n_0\
    );
\faults[5]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFFF1151"
    )
        port map (
      I0 => \faults[5]_i_8_n_0\,
      I1 => \^q\(23),
      I2 => \faults[5]_i_9_n_0\,
      I3 => \faults[5]_i_10_n_0\,
      I4 => \faults[5]_i_11_n_0\,
      I5 => \faults[1]_i_2_n_0\,
      O => \faults[5]_i_3_n_0\
    );
\faults[5]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => \^window_count_reg[31]_0\(21),
      I1 => \^window_count_reg[31]_0\(20),
      I2 => \^window_count_reg[31]_0\(23),
      I3 => \^window_count_reg[31]_0\(22),
      I4 => \faults[5]_i_12_n_0\,
      O => \faults[5]_i_4_n_0\
    );
\faults[5]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => \^window_count_reg[31]_0\(25),
      I1 => \^window_count_reg[31]_0\(24),
      I2 => \^window_count_reg[31]_0\(27),
      I3 => \^window_count_reg[31]_0\(26),
      I4 => \faults[5]_i_13_n_0\,
      O => \faults[5]_i_5_n_0\
    );
\faults[5]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00008000"
    )
        port map (
      I0 => \^window_count_reg[31]_0\(9),
      I1 => \^window_count_reg[31]_0\(8),
      I2 => \^window_count_reg[31]_0\(11),
      I3 => \^window_count_reg[31]_0\(10),
      I4 => \faults[5]_i_14_n_0\,
      O => \faults[5]_i_6_n_0\
    );
\faults[5]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => \^window_count_reg[31]_0\(0),
      I1 => \^window_count_reg[31]_0\(1),
      I2 => \^window_count_reg[31]_0\(3),
      I3 => \^window_count_reg[31]_0\(2),
      I4 => \faults[5]_i_15_n_0\,
      O => \faults[5]_i_7_n_0\
    );
\faults[5]_i_8\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \^q\(31),
      I1 => \^q\(24),
      I2 => \^q\(28),
      I3 => \^q\(27),
      I4 => \faults[5]_i_16_n_0\,
      O => \faults[5]_i_8_n_0\
    );
\faults[5]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF11111151"
    )
        port map (
      I0 => \faults[5]_i_17_n_0\,
      I1 => \^q\(15),
      I2 => \faults[5]_i_18_n_0\,
      I3 => \^q\(14),
      I4 => \^q\(13),
      I5 => \faults[4]_i_4_n_0\,
      O => \faults[5]_i_9_n_0\
    );
\faults[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7400FFFF74007400"
    )
        port map (
      I0 => \faults[6]_i_2_n_0\,
      I1 => \faults[6]_i_3_n_0\,
      I2 => \^faults_reg[7]_0\(6),
      I3 => \faults[6]_i_4_n_0\,
      I4 => \faults[6]_i_5_n_0\,
      I5 => \faults[6]_i_6_n_0\,
      O => \faults[6]_i_1_n_0\
    );
\faults[6]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAAAAA8"
    )
        port map (
      I0 => next_clipped(5),
      I1 => next_clipped(3),
      I2 => next_clipped(2),
      I3 => next_clipped(4),
      I4 => next_clipped(0),
      I5 => next_clipped(1),
      O => \faults[6]_i_10_n_0\
    );
\faults[6]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => pcm_valid,
      I1 => dc_valid,
      I2 => filtered_valid,
      O => \faults[6]_i_2_n_0\
    );
\faults[6]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \faults_reg[0]_1\(0),
      I1 => configure,
      O => \faults[6]_i_3_n_0\
    );
\faults[6]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FBFBFBBBFFFFFFFF"
    )
        port map (
      I0 => input_fault,
      I1 => \faults_reg[1]_0\(0),
      I2 => pcm_valid,
      I3 => dc_valid,
      I4 => filtered_valid,
      I5 => \faults[6]_i_3_n_0\,
      O => \faults[6]_i_4_n_0\
    );
\faults[6]_i_5\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BF"
    )
        port map (
      I0 => \faults[6]_i_4_n_0\,
      I1 => \faults[5]_i_2_n_0\,
      I2 => \faults[5]_i_3_n_0\,
      O => \faults[6]_i_5_n_0\
    );
\faults[6]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => p_0_in,
      I1 => \faults[6]_i_7_n_0\,
      I2 => \faults[6]_i_8_n_0\,
      I3 => \faults[6]_i_9_n_0\,
      I4 => \faults[6]_i_10_n_0\,
      O => \faults[6]_i_6_n_0\
    );
\faults[6]_i_7\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => next_clipped(12),
      I1 => next_clipped(10),
      I2 => next_clipped(11),
      O => \faults[6]_i_7_n_0\
    );
\faults[6]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => next_clipped(14),
      I1 => next_clipped(15),
      I2 => next_clipped(6),
      I3 => next_clipped(13),
      O => \faults[6]_i_8_n_0\
    );
\faults[6]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => next_clipped(8),
      I1 => next_clipped(9),
      I2 => next_clipped(7),
      I3 => \next_clipped__0\(16),
      O => \faults[6]_i_9_n_0\
    );
\faults[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"4F"
    )
        port map (
      I0 => \faults[7]_i_4_n_0\,
      I1 => configure,
      I2 => s_axi_aresetn,
      O => \faults[7]_i_1_n_0\
    );
\faults[7]_i_10\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \faults[7]_i_10_0\(25),
      I1 => \faults[7]_i_10_0\(26),
      I2 => \faults[7]_i_10_0\(24),
      I3 => \faults[7]_i_10_0\(27),
      I4 => \faults[7]_i_16_n_0\,
      O => \faults[7]_i_10_n_0\
    );
\faults[7]_i_11\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFE0FF"
    )
        port map (
      I0 => filtered_valid,
      I1 => dc_valid,
      I2 => pcm_valid,
      I3 => \faults_reg[1]_0\(0),
      I4 => input_fault,
      O => \faults[7]_i_11_n_0\
    );
\faults[7]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => \faults[6]_i_10_n_0\,
      I1 => \faults[6]_i_9_n_0\,
      I2 => \faults[6]_i_8_n_0\,
      I3 => \faults[6]_i_7_n_0\,
      I4 => p_0_in,
      I5 => \faults[7]_i_17_n_0\,
      O => \faults[7]_i_12_n_0\
    );
\faults[7]_i_13\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \faults[7]_i_10_0\(5),
      I1 => \faults[7]_i_10_0\(4),
      I2 => \faults[7]_i_10_0\(7),
      I3 => \faults[7]_i_10_0\(6),
      O => \faults[7]_i_13_n_0\
    );
\faults[7]_i_14\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \faults[7]_i_10_0\(13),
      I1 => \faults[7]_i_10_0\(12),
      I2 => \faults[7]_i_10_0\(15),
      I3 => \faults[7]_i_10_0\(14),
      O => \faults[7]_i_14_n_0\
    );
\faults[7]_i_15\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \faults[7]_i_10_0\(21),
      I1 => \faults[7]_i_10_0\(20),
      I2 => \faults[7]_i_10_0\(23),
      I3 => \faults[7]_i_10_0\(22),
      O => \faults[7]_i_15_n_0\
    );
\faults[7]_i_16\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \faults[7]_i_10_0\(30),
      I1 => \faults[7]_i_10_0\(29),
      I2 => \faults[7]_i_10_0\(31),
      I3 => \faults[7]_i_10_0\(28),
      O => \faults[7]_i_16_n_0\
    );
\faults[7]_i_17\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0004"
    )
        port map (
      I0 => \faults[5]_i_7_n_0\,
      I1 => \faults[5]_i_6_n_0\,
      I2 => \faults[5]_i_5_n_0\,
      I3 => \faults[5]_i_4_n_0\,
      O => \faults[7]_i_17_n_0\
    );
\faults[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BFBBAAAAAAAAAAAA"
    )
        port map (
      I0 => configure,
      I1 => \faults[7]_i_5_n_0\,
      I2 => \faults[7]_i_6_n_0\,
      I3 => \^status\(4),
      I4 => \event_age[31]_i_1_n_0\,
      I5 => \faults_reg[0]_1\(0),
      O => \faults[7]_i_2_n_0\
    );
\faults[7]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFA8FF0000A800"
    )
        port map (
      I0 => pcm_valid,
      I1 => dc_valid,
      I2 => filtered_valid,
      I3 => \faults_reg[0]_1\(0),
      I4 => configure,
      I5 => \^faults_reg[7]_0\(7),
      O => \faults[7]_i_3_n_0\
    );
\faults[7]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFF0010"
    )
        port map (
      I0 => \faults[7]_i_7_n_0\,
      I1 => \faults[7]_i_8_n_0\,
      I2 => \faults[7]_i_9_n_0\,
      I3 => \faults[7]_i_10_n_0\,
      I4 => state20_in,
      I5 => state3,
      O => \faults[7]_i_4_n_0\
    );
\faults[7]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0222020202220222"
    )
        port map (
      I0 => \faults[5]_i_3_n_0\,
      I1 => \faults[7]_i_11_n_0\,
      I2 => filtered_valid,
      I3 => \p_0_out_inferred__3/i__carry__4_n_2\,
      I4 => \faults[7]_i_12_n_0\,
      I5 => \clipped_count[15]_i_4_n_0\,
      O => \faults[7]_i_5_n_0\
    );
\faults[7]_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => filtered_valid,
      I1 => \clipped_count[15]_i_4_n_0\,
      O => \faults[7]_i_6_n_0\
    );
\faults[7]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \faults[7]_i_10_0\(0),
      I1 => \faults[7]_i_10_0\(3),
      I2 => \faults[7]_i_10_0\(1),
      I3 => \faults[7]_i_10_0\(2),
      I4 => \faults[7]_i_13_n_0\,
      O => \faults[7]_i_7_n_0\
    );
\faults[7]_i_8\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \faults[7]_i_10_0\(8),
      I1 => \faults[7]_i_10_0\(11),
      I2 => \faults[7]_i_10_0\(9),
      I3 => \faults[7]_i_10_0\(10),
      I4 => \faults[7]_i_14_n_0\,
      O => \faults[7]_i_8_n_0\
    );
\faults[7]_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => \faults[7]_i_10_0\(18),
      I1 => \faults[7]_i_10_0\(19),
      I2 => \faults[7]_i_10_0\(16),
      I3 => \faults[7]_i_10_0\(17),
      I4 => \faults[7]_i_15_n_0\,
      O => \faults[7]_i_9_n_0\
    );
\faults_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \faults[7]_i_2_n_0\,
      D => \faults[0]_i_1_n_0\,
      Q => \^faults_reg[7]_0\(0),
      R => \faults[7]_i_1_n_0\
    );
\faults_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \faults[7]_i_2_n_0\,
      D => \faults[1]_i_1_n_0\,
      Q => \^faults_reg[7]_0\(1),
      R => \faults[7]_i_1_n_0\
    );
\faults_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \faults[7]_i_2_n_0\,
      D => \faults[2]_i_1_n_0\,
      Q => \^faults_reg[7]_0\(2),
      R => \faults[7]_i_1_n_0\
    );
\faults_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \faults[7]_i_2_n_0\,
      D => \faults[3]_i_1_n_0\,
      Q => \^faults_reg[7]_0\(3),
      R => \faults[7]_i_1_n_0\
    );
\faults_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \faults[7]_i_2_n_0\,
      D => \faults[4]_i_1_n_0\,
      Q => \^faults_reg[7]_0\(4),
      R => \faults[7]_i_1_n_0\
    );
\faults_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \faults[7]_i_2_n_0\,
      D => \faults[5]_i_1_n_0\,
      Q => \^faults_reg[7]_0\(5),
      R => \faults[7]_i_1_n_0\
    );
\faults_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \faults[7]_i_2_n_0\,
      D => \faults[6]_i_1_n_0\,
      Q => \^faults_reg[7]_0\(6),
      R => \faults[7]_i_1_n_0\
    );
\faults_reg[6]_i_11\: unisim.vcomponents.CARRY4
     port map (
      CI => \clipped_count_reg[15]_i_3_n_0\,
      CO(3 downto 1) => \NLW_faults_reg[6]_i_11_CO_UNCONNECTED\(3 downto 1),
      CO(0) => \next_clipped__0\(16),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_faults_reg[6]_i_11_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => B"0001"
    );
\faults_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \faults[7]_i_2_n_0\,
      D => \faults[7]_i_3_n_0\,
      Q => \^faults_reg[7]_0\(7),
      R => \faults[7]_i_1_n_0\
    );
filtered_clipped_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => dc_clipped,
      Q => filtered_clipped,
      R => dc_level0
    );
\filtered_latched_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(8),
      Q => filtered_latched(0),
      R => dc_level0
    );
\filtered_latched_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(18),
      Q => filtered_latched(10),
      R => dc_level0
    );
\filtered_latched_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(19),
      Q => filtered_latched(11),
      R => dc_level0
    );
\filtered_latched_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(20),
      Q => filtered_latched(12),
      R => dc_level0
    );
\filtered_latched_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(21),
      Q => filtered_latched(13),
      R => dc_level0
    );
\filtered_latched_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(22),
      Q => filtered_latched(14),
      R => dc_level0
    );
\filtered_latched_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(23),
      Q => filtered_latched(15),
      R => dc_level0
    );
\filtered_latched_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(24),
      Q => filtered_latched(16),
      R => dc_level0
    );
\filtered_latched_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(25),
      Q => filtered_latched(17),
      R => dc_level0
    );
\filtered_latched_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(9),
      Q => filtered_latched(1),
      R => dc_level0
    );
\filtered_latched_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(10),
      Q => filtered_latched(2),
      R => dc_level0
    );
\filtered_latched_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(11),
      Q => filtered_latched(3),
      R => dc_level0
    );
\filtered_latched_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(12),
      Q => filtered_latched(4),
      R => dc_level0
    );
\filtered_latched_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(13),
      Q => filtered_latched(5),
      R => dc_level0
    );
\filtered_latched_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(14),
      Q => filtered_latched(6),
      R => dc_level0
    );
\filtered_latched_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(15),
      Q => filtered_latched(7),
      R => dc_level0
    );
\filtered_latched_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(16),
      Q => filtered_latched(8),
      R => dc_level0
    );
\filtered_latched_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => dc_valid,
      D => centered(17),
      Q => filtered_latched(9),
      R => dc_level0
    );
filtered_valid_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => dc_valid,
      I1 => dc_level0,
      O => filtered_valid_i_1_n_0
    );
filtered_valid_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => filtered_valid_i_1_n_0,
      Q => filtered_valid,
      R => '0'
    );
high_seen_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"EA"
    )
        port map (
      I0 => above_loud,
      I1 => high_seen_reg_n_0,
      I2 => \^status\(3),
      O => high_seen_i_1_n_0
    );
high_seen_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => soft_count(0),
      D => high_seen_i_1_n_0,
      Q => high_seen_reg_n_0,
      R => \sample_in_window[9]_i_1_n_0\
    );
\i_/i_/i__carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \i_/i_/i__carry_n_0\,
      CO(2) => \i_/i_/i__carry_n_1\,
      CO(1) => \i_/i_/i__carry_n_2\,
      CO(0) => \i_/i_/i__carry_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \i_/i_/i__carry_n_4\,
      O(2) => \i_/i_/i__carry_n_5\,
      O(1) => \i_/i_/i__carry_n_6\,
      O(0) => \i_/i_/i__carry_n_7\,
      S(3 downto 1) => sample_age_reg(3 downto 1),
      S(0) => \i__carry_i_1__0_n_0\
    );
\i_/i_/i__carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_/i_/i__carry_n_0\,
      CO(3) => \i_/i_/i__carry__0_n_0\,
      CO(2) => \i_/i_/i__carry__0_n_1\,
      CO(1) => \i_/i_/i__carry__0_n_2\,
      CO(0) => \i_/i_/i__carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_/i_/i__carry__0_n_4\,
      O(2) => \i_/i_/i__carry__0_n_5\,
      O(1) => \i_/i_/i__carry__0_n_6\,
      O(0) => \i_/i_/i__carry__0_n_7\,
      S(3 downto 0) => sample_age_reg(7 downto 4)
    );
\i_/i_/i__carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_/i_/i__carry__0_n_0\,
      CO(3) => \i_/i_/i__carry__1_n_0\,
      CO(2) => \i_/i_/i__carry__1_n_1\,
      CO(1) => \i_/i_/i__carry__1_n_2\,
      CO(0) => \i_/i_/i__carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_/i_/i__carry__1_n_4\,
      O(2) => \i_/i_/i__carry__1_n_5\,
      O(1) => \i_/i_/i__carry__1_n_6\,
      O(0) => \i_/i_/i__carry__1_n_7\,
      S(3 downto 0) => sample_age_reg(11 downto 8)
    );
\i_/i_/i__carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_/i_/i__carry__1_n_0\,
      CO(3) => \i_/i_/i__carry__2_n_0\,
      CO(2) => \i_/i_/i__carry__2_n_1\,
      CO(1) => \i_/i_/i__carry__2_n_2\,
      CO(0) => \i_/i_/i__carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_/i_/i__carry__2_n_4\,
      O(2) => \i_/i_/i__carry__2_n_5\,
      O(1) => \i_/i_/i__carry__2_n_6\,
      O(0) => \i_/i_/i__carry__2_n_7\,
      S(3 downto 0) => sample_age_reg(15 downto 12)
    );
\i_/i_/i__carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \i_/i_/i__carry__2_n_0\,
      CO(3) => \NLW_i_/i_/i__carry__3_CO_UNCONNECTED\(3),
      CO(2) => \i_/i_/i__carry__3_n_1\,
      CO(1) => \i_/i_/i__carry__3_n_2\,
      CO(0) => \i_/i_/i__carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i_/i_/i__carry__3_n_4\,
      O(2) => \i_/i_/i__carry__3_n_5\,
      O(1) => \i_/i_/i__carry__3_n_6\,
      O(0) => \i_/i_/i__carry__3_n_7\,
      S(3 downto 0) => sample_age_reg(19 downto 16)
    );
\i__carry__0_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(21),
      I1 => \^out\(22),
      I2 => \^out\(23),
      O => \i__carry__0_i_1_n_0\
    );
\i__carry__0_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(18),
      I1 => \^out\(19),
      I2 => \^out\(20),
      O => \i__carry__0_i_2_n_0\
    );
\i__carry__0_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(15),
      I1 => \^out\(16),
      I2 => \^out\(17),
      O => \i__carry__0_i_3_n_0\
    );
\i__carry__0_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(12),
      I1 => \^out\(13),
      I2 => \^out\(14),
      O => \i__carry__0_i_4_n_0\
    );
\i__carry__1_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(33),
      I1 => \^out\(34),
      I2 => \^out\(35),
      O => \i__carry__1_i_1_n_0\
    );
\i__carry__1_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(30),
      I1 => \^out\(31),
      I2 => \^out\(32),
      O => \i__carry__1_i_2_n_0\
    );
\i__carry__1_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(27),
      I1 => \^out\(28),
      I2 => \^out\(29),
      O => \i__carry__1_i_3_n_0\
    );
\i__carry__1_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(24),
      I1 => \^out\(25),
      I2 => \^out\(26),
      O => \i__carry__1_i_4_n_0\
    );
\i__carry__2_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(45),
      I1 => \^out\(46),
      I2 => \^out\(47),
      O => \i__carry__2_i_1_n_0\
    );
\i__carry__2_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(42),
      I1 => \^out\(43),
      I2 => \^out\(44),
      O => \i__carry__2_i_2_n_0\
    );
\i__carry__2_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(39),
      I1 => \^out\(40),
      I2 => \^out\(41),
      O => \i__carry__2_i_3_n_0\
    );
\i__carry__2_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(36),
      I1 => \^out\(37),
      I2 => \^out\(38),
      O => \i__carry__2_i_4_n_0\
    );
\i__carry__3_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(57),
      I1 => \^out\(58),
      I2 => \^out\(59),
      O => \i__carry__3_i_1_n_0\
    );
\i__carry__3_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(54),
      I1 => \^out\(55),
      I2 => \^out\(56),
      O => \i__carry__3_i_2_n_0\
    );
\i__carry__3_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(51),
      I1 => \^out\(52),
      I2 => \^out\(53),
      O => \i__carry__3_i_3_n_0\
    );
\i__carry__3_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(48),
      I1 => \^out\(49),
      I2 => \^out\(50),
      O => \i__carry__3_i_4_n_0\
    );
\i__carry__4_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(60),
      I1 => \^out\(61),
      I2 => \^out\(62),
      O => \i__carry__4_i_1_n_0\
    );
\i__carry_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(9),
      I1 => \^out\(10),
      I2 => \^out\(11),
      O => \i__carry_i_1_n_0\
    );
\i__carry_i_1__0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => sample_age_reg(0),
      O => \i__carry_i_1__0_n_0\
    );
\i__carry_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(6),
      I1 => \^out\(7),
      I2 => \^out\(8),
      O => \i__carry_i_2_n_0\
    );
\i__carry_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(3),
      I1 => \^out\(4),
      I2 => \^out\(5),
      O => \i__carry_i_3_n_0\
    );
\i__carry_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^out\(0),
      I1 => \^out\(1),
      I2 => \^out\(2),
      O => \i__carry_i_4_n_0\
    );
\last_sum[31]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => configure,
      I1 => s_axi_aresetn,
      O => \last_sum[31]_i_1_n_0\
    );
\last_sum[31]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00800000"
    )
        port map (
      I0 => filtered_valid,
      I1 => \event_age[31]_i_1_n_0\,
      I2 => \faults_reg[0]_1\(0),
      I3 => configure,
      I4 => \clipped_count[15]_i_4_n_0\,
      O => \last_sum[31]_i_2_n_0\
    );
\last_sum_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[3]_i_1_n_7\,
      Q => \last_sum_reg[31]_0\(0),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[11]_i_1_n_5\,
      Q => \last_sum_reg[31]_0\(10),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[11]_i_1_n_4\,
      Q => \last_sum_reg[31]_0\(11),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[15]_i_1_n_7\,
      Q => \last_sum_reg[31]_0\(12),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[15]_i_1_n_6\,
      Q => \last_sum_reg[31]_0\(13),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[15]_i_1_n_5\,
      Q => \last_sum_reg[31]_0\(14),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[15]_i_1_n_4\,
      Q => \last_sum_reg[31]_0\(15),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[19]_i_1_n_7\,
      Q => \last_sum_reg[31]_0\(16),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[19]_i_1_n_6\,
      Q => \last_sum_reg[31]_0\(17),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[19]_i_1_n_5\,
      Q => \last_sum_reg[31]_0\(18),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[19]_i_1_n_4\,
      Q => \last_sum_reg[31]_0\(19),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[3]_i_1_n_6\,
      Q => \last_sum_reg[31]_0\(1),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[23]_i_1_n_7\,
      Q => \last_sum_reg[31]_0\(20),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[23]_i_1_n_6\,
      Q => \last_sum_reg[31]_0\(21),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[23]_i_1_n_5\,
      Q => \last_sum_reg[31]_0\(22),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[23]_i_1_n_4\,
      Q => \last_sum_reg[31]_0\(23),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[27]_i_1_n_7\,
      Q => \last_sum_reg[31]_0\(24),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[27]_i_1_n_6\,
      Q => \last_sum_reg[31]_0\(25),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[27]_i_1_n_5\,
      Q => \last_sum_reg[31]_0\(26),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[27]_i_1_n_4\,
      Q => \last_sum_reg[31]_0\(27),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[31]_i_1_n_7\,
      Q => \last_sum_reg[31]_0\(28),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[31]_i_1_n_6\,
      Q => \last_sum_reg[31]_0\(29),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[3]_i_1_n_5\,
      Q => \last_sum_reg[31]_0\(2),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[31]_i_1_n_5\,
      Q => \last_sum_reg[31]_0\(30),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[31]_i_1_n_4\,
      Q => \last_sum_reg[31]_0\(31),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[3]_i_1_n_4\,
      Q => \last_sum_reg[31]_0\(3),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[7]_i_1_n_7\,
      Q => \last_sum_reg[31]_0\(4),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[7]_i_1_n_6\,
      Q => \last_sum_reg[31]_0\(5),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[7]_i_1_n_5\,
      Q => \last_sum_reg[31]_0\(6),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[7]_i_1_n_4\,
      Q => \last_sum_reg[31]_0\(7),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[11]_i_1_n_7\,
      Q => \last_sum_reg[31]_0\(8),
      R => \last_sum[31]_i_1_n_0\
    );
\last_sum_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \accumulation_reg[11]_i_1_n_6\,
      Q => \last_sum_reg[31]_0\(9),
      R => \last_sum[31]_i_1_n_0\
    );
\loud_count[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"2A"
    )
        port map (
      I0 => above_loud,
      I1 => loud_count(0),
      I2 => \^status\(3),
      O => \loud_count[0]_i_1_n_0\
    );
\loud_count[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2800"
    )
        port map (
      I0 => \^status\(3),
      I1 => loud_count(0),
      I2 => loud_count(1),
      I3 => above_loud,
      O => \loud_count[1]_i_1_n_0\
    );
\loud_count[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"28880000"
    )
        port map (
      I0 => \^status\(3),
      I1 => loud_count(2),
      I2 => loud_count(1),
      I3 => loud_count(0),
      I4 => above_loud,
      O => \loud_count[2]_i_1_n_0\
    );
\loud_count_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => soft_count(0),
      D => \loud_count[0]_i_1_n_0\,
      Q => loud_count(0),
      R => \sample_in_window[9]_i_1_n_0\
    );
\loud_count_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => soft_count(0),
      D => \loud_count[1]_i_1_n_0\,
      Q => loud_count(1),
      R => \sample_in_window[9]_i_1_n_0\
    );
\loud_count_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => soft_count(0),
      D => \loud_count[2]_i_1_n_0\,
      Q => loud_count(2),
      R => \sample_in_window[9]_i_1_n_0\
    );
matching_ack0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => matching_ack0_carry_n_0,
      CO(2) => matching_ack0_carry_n_1,
      CO(1) => matching_ack0_carry_n_2,
      CO(0) => matching_ack0_carry_n_3,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_matching_ack0_carry_O_UNCONNECTED(3 downto 0),
      S(3) => matching_ack0_carry_i_1_n_0,
      S(2) => matching_ack0_carry_i_2_n_0,
      S(1) => matching_ack0_carry_i_3_n_0,
      S(0) => matching_ack0_carry_i_4_n_0
    );
\matching_ack0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => matching_ack0_carry_n_0,
      CO(3) => \matching_ack0_carry__0_n_0\,
      CO(2) => \matching_ack0_carry__0_n_1\,
      CO(1) => \matching_ack0_carry__0_n_2\,
      CO(0) => \matching_ack0_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_matching_ack0_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \matching_ack0_carry__0_i_1_n_0\,
      S(2) => \matching_ack0_carry__0_i_2_n_0\,
      S(1) => \matching_ack0_carry__0_i_3_n_0\,
      S(0) => \matching_ack0_carry__0_i_4_n_0\
    );
\matching_ack0_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack0_carry__1_0\(22),
      I1 => \^event_sequence_reg[31]_0\(22),
      I2 => \matching_ack0_carry__1_0\(21),
      I3 => \^event_sequence_reg[31]_0\(21),
      I4 => \^event_sequence_reg[31]_0\(23),
      I5 => \matching_ack0_carry__1_0\(23),
      O => \matching_ack0_carry__0_i_1_n_0\
    );
\matching_ack0_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack0_carry__1_0\(19),
      I1 => \^event_sequence_reg[31]_0\(19),
      I2 => \matching_ack0_carry__1_0\(18),
      I3 => \^event_sequence_reg[31]_0\(18),
      I4 => \^event_sequence_reg[31]_0\(20),
      I5 => \matching_ack0_carry__1_0\(20),
      O => \matching_ack0_carry__0_i_2_n_0\
    );
\matching_ack0_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack0_carry__1_0\(15),
      I1 => \^event_sequence_reg[31]_0\(15),
      I2 => \matching_ack0_carry__1_0\(16),
      I3 => \^event_sequence_reg[31]_0\(16),
      I4 => \^event_sequence_reg[31]_0\(17),
      I5 => \matching_ack0_carry__1_0\(17),
      O => \matching_ack0_carry__0_i_3_n_0\
    );
\matching_ack0_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack0_carry__1_0\(12),
      I1 => \^event_sequence_reg[31]_0\(12),
      I2 => \matching_ack0_carry__1_0\(13),
      I3 => \^event_sequence_reg[31]_0\(13),
      I4 => \^event_sequence_reg[31]_0\(14),
      I5 => \matching_ack0_carry__1_0\(14),
      O => \matching_ack0_carry__0_i_4_n_0\
    );
\matching_ack0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \matching_ack0_carry__0_n_0\,
      CO(3) => \NLW_matching_ack0_carry__1_CO_UNCONNECTED\(3),
      CO(2) => matching_ack0,
      CO(1) => \matching_ack0_carry__1_n_2\,
      CO(0) => \matching_ack0_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_matching_ack0_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \matching_ack0_carry__1_i_1_n_0\,
      S(1) => \matching_ack0_carry__1_i_2_n_0\,
      S(0) => \matching_ack0_carry__1_i_3_n_0\
    );
\matching_ack0_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^event_sequence_reg[31]_0\(31),
      I1 => \matching_ack0_carry__1_0\(31),
      I2 => \^event_sequence_reg[31]_0\(30),
      I3 => \matching_ack0_carry__1_0\(30),
      O => \matching_ack0_carry__1_i_1_n_0\
    );
\matching_ack0_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack0_carry__1_0\(27),
      I1 => \^event_sequence_reg[31]_0\(27),
      I2 => \matching_ack0_carry__1_0\(28),
      I3 => \^event_sequence_reg[31]_0\(28),
      I4 => \^event_sequence_reg[31]_0\(29),
      I5 => \matching_ack0_carry__1_0\(29),
      O => \matching_ack0_carry__1_i_2_n_0\
    );
\matching_ack0_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack0_carry__1_0\(24),
      I1 => \^event_sequence_reg[31]_0\(24),
      I2 => \matching_ack0_carry__1_0\(25),
      I3 => \^event_sequence_reg[31]_0\(25),
      I4 => \^event_sequence_reg[31]_0\(26),
      I5 => \matching_ack0_carry__1_0\(26),
      O => \matching_ack0_carry__1_i_3_n_0\
    );
matching_ack0_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack0_carry__1_0\(9),
      I1 => \^event_sequence_reg[31]_0\(9),
      I2 => \matching_ack0_carry__1_0\(10),
      I3 => \^event_sequence_reg[31]_0\(10),
      I4 => \^event_sequence_reg[31]_0\(11),
      I5 => \matching_ack0_carry__1_0\(11),
      O => matching_ack0_carry_i_1_n_0
    );
matching_ack0_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack0_carry__1_0\(7),
      I1 => \^event_sequence_reg[31]_0\(7),
      I2 => \matching_ack0_carry__1_0\(6),
      I3 => \^event_sequence_reg[31]_0\(6),
      I4 => \^event_sequence_reg[31]_0\(8),
      I5 => \matching_ack0_carry__1_0\(8),
      O => matching_ack0_carry_i_2_n_0
    );
matching_ack0_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack0_carry__1_0\(3),
      I1 => \^event_sequence_reg[31]_0\(3),
      I2 => \matching_ack0_carry__1_0\(4),
      I3 => \^event_sequence_reg[31]_0\(4),
      I4 => \^event_sequence_reg[31]_0\(5),
      I5 => \matching_ack0_carry__1_0\(5),
      O => matching_ack0_carry_i_3_n_0
    );
matching_ack0_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^event_sequence_reg[31]_0\(0),
      I1 => \matching_ack0_carry__1_0\(0),
      I2 => \matching_ack0_carry__1_0\(2),
      I3 => \^event_sequence_reg[31]_0\(2),
      I4 => \matching_ack0_carry__1_0\(1),
      I5 => \^event_sequence_reg[31]_0\(1),
      O => matching_ack0_carry_i_4_n_0
    );
matching_ack1_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => matching_ack1_carry_n_0,
      CO(2) => matching_ack1_carry_n_1,
      CO(1) => matching_ack1_carry_n_2,
      CO(0) => matching_ack1_carry_n_3,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_matching_ack1_carry_O_UNCONNECTED(3 downto 0),
      S(3) => matching_ack1_carry_i_1_n_0,
      S(2) => matching_ack1_carry_i_2_n_0,
      S(1) => matching_ack1_carry_i_3_n_0,
      S(0) => matching_ack1_carry_i_4_n_0
    );
\matching_ack1_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => matching_ack1_carry_n_0,
      CO(3) => \matching_ack1_carry__0_n_0\,
      CO(2) => \matching_ack1_carry__0_n_1\,
      CO(1) => \matching_ack1_carry__0_n_2\,
      CO(0) => \matching_ack1_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_matching_ack1_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \matching_ack1_carry__0_i_1_n_0\,
      S(2) => \matching_ack1_carry__0_i_2_n_0\,
      S(1) => \matching_ack1_carry__0_i_3_n_0\,
      S(0) => \matching_ack1_carry__0_i_4_n_0\
    );
\matching_ack1_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack1_carry__1_0\(22),
      I1 => \^event_epoch_reg[31]_0\(22),
      I2 => \matching_ack1_carry__1_0\(21),
      I3 => \^event_epoch_reg[31]_0\(21),
      I4 => \^event_epoch_reg[31]_0\(23),
      I5 => \matching_ack1_carry__1_0\(23),
      O => \matching_ack1_carry__0_i_1_n_0\
    );
\matching_ack1_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack1_carry__1_0\(18),
      I1 => \^event_epoch_reg[31]_0\(18),
      I2 => \matching_ack1_carry__1_0\(19),
      I3 => \^event_epoch_reg[31]_0\(19),
      I4 => \^event_epoch_reg[31]_0\(20),
      I5 => \matching_ack1_carry__1_0\(20),
      O => \matching_ack1_carry__0_i_2_n_0\
    );
\matching_ack1_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack1_carry__1_0\(15),
      I1 => \^event_epoch_reg[31]_0\(15),
      I2 => \matching_ack1_carry__1_0\(16),
      I3 => \^event_epoch_reg[31]_0\(16),
      I4 => \^event_epoch_reg[31]_0\(17),
      I5 => \matching_ack1_carry__1_0\(17),
      O => \matching_ack1_carry__0_i_3_n_0\
    );
\matching_ack1_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack1_carry__1_0\(12),
      I1 => \^event_epoch_reg[31]_0\(12),
      I2 => \matching_ack1_carry__1_0\(13),
      I3 => \^event_epoch_reg[31]_0\(13),
      I4 => \^event_epoch_reg[31]_0\(14),
      I5 => \matching_ack1_carry__1_0\(14),
      O => \matching_ack1_carry__0_i_4_n_0\
    );
\matching_ack1_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \matching_ack1_carry__0_n_0\,
      CO(3) => \NLW_matching_ack1_carry__1_CO_UNCONNECTED\(3),
      CO(2) => matching_ack1,
      CO(1) => \matching_ack1_carry__1_n_2\,
      CO(0) => \matching_ack1_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_matching_ack1_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \matching_ack1_carry__1_i_1_n_0\,
      S(1) => \matching_ack1_carry__1_i_2_n_0\,
      S(0) => \matching_ack1_carry__1_i_3_n_0\
    );
\matching_ack1_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^event_epoch_reg[31]_0\(31),
      I1 => \matching_ack1_carry__1_0\(31),
      I2 => \^event_epoch_reg[31]_0\(30),
      I3 => \matching_ack1_carry__1_0\(30),
      O => \matching_ack1_carry__1_i_1_n_0\
    );
\matching_ack1_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack1_carry__1_0\(27),
      I1 => \^event_epoch_reg[31]_0\(27),
      I2 => \matching_ack1_carry__1_0\(28),
      I3 => \^event_epoch_reg[31]_0\(28),
      I4 => \^event_epoch_reg[31]_0\(29),
      I5 => \matching_ack1_carry__1_0\(29),
      O => \matching_ack1_carry__1_i_2_n_0\
    );
\matching_ack1_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack1_carry__1_0\(25),
      I1 => \^event_epoch_reg[31]_0\(25),
      I2 => \matching_ack1_carry__1_0\(24),
      I3 => \^event_epoch_reg[31]_0\(24),
      I4 => \^event_epoch_reg[31]_0\(26),
      I5 => \matching_ack1_carry__1_0\(26),
      O => \matching_ack1_carry__1_i_3_n_0\
    );
matching_ack1_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack1_carry__1_0\(9),
      I1 => \^event_epoch_reg[31]_0\(9),
      I2 => \matching_ack1_carry__1_0\(10),
      I3 => \^event_epoch_reg[31]_0\(10),
      I4 => \^event_epoch_reg[31]_0\(11),
      I5 => \matching_ack1_carry__1_0\(11),
      O => matching_ack1_carry_i_1_n_0
    );
matching_ack1_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack1_carry__1_0\(7),
      I1 => \^event_epoch_reg[31]_0\(7),
      I2 => \matching_ack1_carry__1_0\(6),
      I3 => \^event_epoch_reg[31]_0\(6),
      I4 => \^event_epoch_reg[31]_0\(8),
      I5 => \matching_ack1_carry__1_0\(8),
      O => matching_ack1_carry_i_2_n_0
    );
matching_ack1_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^event_epoch_reg[31]_0\(5),
      I1 => \matching_ack1_carry__1_0\(5),
      I2 => \matching_ack1_carry__1_0\(3),
      I3 => \^event_epoch_reg[31]_0\(3),
      I4 => \matching_ack1_carry__1_0\(4),
      I5 => \^event_epoch_reg[31]_0\(4),
      O => matching_ack1_carry_i_3_n_0
    );
matching_ack1_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \matching_ack1_carry__1_0\(0),
      I1 => \^event_epoch_reg[31]_0\(0),
      I2 => \matching_ack1_carry__1_0\(1),
      I3 => \^event_epoch_reg[31]_0\(1),
      I4 => \^event_epoch_reg[31]_0\(2),
      I5 => \matching_ack1_carry__1_0\(2),
      O => matching_ack1_carry_i_4_n_0
    );
next_dc_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => next_dc_carry_n_0,
      CO(2) => next_dc_carry_n_1,
      CO(1) => next_dc_carry_n_2,
      CO(0) => next_dc_carry_n_3,
      CYINIT => '0',
      DI(3 downto 0) => dc_level(3 downto 0),
      O(3) => next_dc_carry_n_4,
      O(2) => next_dc_carry_n_5,
      O(1) => next_dc_carry_n_6,
      O(0) => next_dc_carry_n_7,
      S(3) => next_dc_carry_i_1_n_0,
      S(2) => next_dc_carry_i_2_n_0,
      S(1) => next_dc_carry_i_3_n_0,
      S(0) => next_dc_carry_i_4_n_0
    );
\next_dc_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => next_dc_carry_n_0,
      CO(3) => \next_dc_carry__0_n_0\,
      CO(2) => \next_dc_carry__0_n_1\,
      CO(1) => \next_dc_carry__0_n_2\,
      CO(0) => \next_dc_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => dc_level(7 downto 4),
      O(3) => \next_dc_carry__0_n_4\,
      O(2) => \next_dc_carry__0_n_5\,
      O(1) => \next_dc_carry__0_n_6\,
      O(0) => \next_dc_carry__0_n_7\,
      S(3) => \next_dc_carry__0_i_1_n_0\,
      S(2) => \next_dc_carry__0_i_2_n_0\,
      S(1) => \next_dc_carry__0_i_3_n_0\,
      S(0) => \next_dc_carry__0_i_4_n_0\
    );
\next_dc_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => dc_level(7),
      I1 => \difference_latched_reg_n_0_[17]\,
      O => \next_dc_carry__0_i_1_n_0\
    );
\next_dc_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => dc_level(6),
      I1 => \difference_latched_reg_n_0_[16]\,
      O => \next_dc_carry__0_i_2_n_0\
    );
\next_dc_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => dc_level(5),
      I1 => \difference_latched_reg_n_0_[15]\,
      O => \next_dc_carry__0_i_3_n_0\
    );
\next_dc_carry__0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => dc_level(4),
      I1 => \difference_latched_reg_n_0_[14]\,
      O => \next_dc_carry__0_i_4_n_0\
    );
\next_dc_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \next_dc_carry__0_n_0\,
      CO(3) => \next_dc_carry__1_n_0\,
      CO(2) => \next_dc_carry__1_n_1\,
      CO(1) => \next_dc_carry__1_n_2\,
      CO(0) => \next_dc_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => \^dc_level_reg[22]_0\(3 downto 0),
      O(3) => \next_dc_carry__1_n_4\,
      O(2) => \next_dc_carry__1_n_5\,
      O(1) => \next_dc_carry__1_n_6\,
      O(0) => \next_dc_carry__1_n_7\,
      S(3) => \next_dc_carry__1_i_1_n_0\,
      S(2) => \next_dc_carry__1_i_2_n_0\,
      S(1) => \next_dc_carry__1_i_3_n_0\,
      S(0) => \next_dc_carry__1_i_4_n_0\
    );
\next_dc_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \^dc_level_reg[22]_0\(3),
      I1 => \difference_latched_reg_n_0_[21]\,
      O => \next_dc_carry__1_i_1_n_0\
    );
\next_dc_carry__1_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \^dc_level_reg[22]_0\(2),
      I1 => \difference_latched_reg_n_0_[20]\,
      O => \next_dc_carry__1_i_2_n_0\
    );
\next_dc_carry__1_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \^dc_level_reg[22]_0\(1),
      I1 => \difference_latched_reg_n_0_[19]\,
      O => \next_dc_carry__1_i_3_n_0\
    );
\next_dc_carry__1_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \^dc_level_reg[22]_0\(0),
      I1 => \difference_latched_reg_n_0_[18]\,
      O => \next_dc_carry__1_i_4_n_0\
    );
\next_dc_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \next_dc_carry__1_n_0\,
      CO(3) => \next_dc_carry__2_n_0\,
      CO(2) => \next_dc_carry__2_n_1\,
      CO(1) => \next_dc_carry__2_n_2\,
      CO(0) => \next_dc_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => next_dc00,
      DI(2 downto 0) => \^dc_level_reg[22]_0\(6 downto 4),
      O(3) => \next_dc_carry__2_n_4\,
      O(2) => \next_dc_carry__2_n_5\,
      O(1) => \next_dc_carry__2_n_6\,
      O(0) => \next_dc_carry__2_n_7\,
      S(3) => \next_dc_carry__2_i_1_n_0\,
      S(2) => \next_dc_carry__2_i_2_n_0\,
      S(1) => \next_dc_carry__2_i_3_n_0\,
      S(0) => \next_dc_carry__2_i_4_n_0\
    );
\next_dc_carry__2_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => next_dc00,
      I1 => \^dc_level_reg[22]_0\(7),
      O => \next_dc_carry__2_i_1_n_0\
    );
\next_dc_carry__2_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \^dc_level_reg[22]_0\(6),
      I1 => \difference_latched_reg_n_0_[24]\,
      O => \next_dc_carry__2_i_2_n_0\
    );
\next_dc_carry__2_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \^dc_level_reg[22]_0\(5),
      I1 => \difference_latched_reg_n_0_[23]\,
      O => \next_dc_carry__2_i_3_n_0\
    );
\next_dc_carry__2_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \^dc_level_reg[22]_0\(4),
      I1 => \difference_latched_reg_n_0_[22]\,
      O => \next_dc_carry__2_i_4_n_0\
    );
\next_dc_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \next_dc_carry__2_n_0\,
      CO(3) => \next_dc_carry__3_n_0\,
      CO(2) => \next_dc_carry__3_n_1\,
      CO(1) => \next_dc_carry__3_n_2\,
      CO(0) => \next_dc_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => \^dc_level_reg[22]_0\(10 downto 8),
      DI(0) => \next_dc_carry__3_i_1_n_0\,
      O(3) => \next_dc_carry__3_n_4\,
      O(2) => \next_dc_carry__3_n_5\,
      O(1) => \next_dc_carry__3_n_6\,
      O(0) => \next_dc_carry__3_n_7\,
      S(3) => \next_dc_carry__3_i_2_n_0\,
      S(2) => \next_dc_carry__3_i_3_n_0\,
      S(1) => \next_dc_carry__3_i_4_n_0\,
      S(0) => \next_dc_carry__3_i_5_n_0\
    );
\next_dc_carry__3_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => next_dc00,
      O => \next_dc_carry__3_i_1_n_0\
    );
\next_dc_carry__3_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^dc_level_reg[22]_0\(10),
      I1 => \^dc_level_reg[22]_0\(11),
      O => \next_dc_carry__3_i_2_n_0\
    );
\next_dc_carry__3_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^dc_level_reg[22]_0\(9),
      I1 => \^dc_level_reg[22]_0\(10),
      O => \next_dc_carry__3_i_3_n_0\
    );
\next_dc_carry__3_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^dc_level_reg[22]_0\(8),
      I1 => \^dc_level_reg[22]_0\(9),
      O => \next_dc_carry__3_i_4_n_0\
    );
\next_dc_carry__3_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => next_dc00,
      I1 => \^dc_level_reg[22]_0\(8),
      O => \next_dc_carry__3_i_5_n_0\
    );
\next_dc_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \next_dc_carry__3_n_0\,
      CO(3) => \next_dc_carry__4_n_0\,
      CO(2) => \next_dc_carry__4_n_1\,
      CO(1) => \next_dc_carry__4_n_2\,
      CO(0) => \next_dc_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => \^dc_level_reg[22]_0\(14 downto 11),
      O(3) => \next_dc_carry__4_n_4\,
      O(2) => \next_dc_carry__4_n_5\,
      O(1) => \next_dc_carry__4_n_6\,
      O(0) => \next_dc_carry__4_n_7\,
      S(3) => \next_dc_carry__4_i_1_n_0\,
      S(2) => \next_dc_carry__4_i_2_n_0\,
      S(1) => \next_dc_carry__4_i_3_n_0\,
      S(0) => \next_dc_carry__4_i_4_n_0\
    );
\next_dc_carry__4_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^dc_level_reg[22]_0\(14),
      I1 => dc_level(23),
      O => \next_dc_carry__4_i_1_n_0\
    );
\next_dc_carry__4_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^dc_level_reg[22]_0\(13),
      I1 => \^dc_level_reg[22]_0\(14),
      O => \next_dc_carry__4_i_2_n_0\
    );
\next_dc_carry__4_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^dc_level_reg[22]_0\(12),
      I1 => \^dc_level_reg[22]_0\(13),
      O => \next_dc_carry__4_i_3_n_0\
    );
\next_dc_carry__4_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^dc_level_reg[22]_0\(11),
      I1 => \^dc_level_reg[22]_0\(12),
      O => \next_dc_carry__4_i_4_n_0\
    );
\next_dc_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \next_dc_carry__4_n_0\,
      CO(3 downto 2) => \NLW_next_dc_carry__5_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \next_dc_carry__5_n_2\,
      CO(0) => \NLW_next_dc_carry__5_CO_UNCONNECTED\(0),
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => dc_level(23),
      O(3 downto 1) => \NLW_next_dc_carry__5_O_UNCONNECTED\(3 downto 1),
      O(0) => \next_dc_carry__5_n_7\,
      S(3 downto 1) => B"001",
      S(0) => \next_dc_carry__5_i_1_n_0\
    );
\next_dc_carry__5_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => dc_level(23),
      I1 => dc_level(24),
      O => \next_dc_carry__5_i_1_n_0\
    );
next_dc_carry_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => dc_level(3),
      I1 => \difference_latched_reg_n_0_[13]\,
      O => next_dc_carry_i_1_n_0
    );
next_dc_carry_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => dc_level(2),
      I1 => \difference_latched_reg_n_0_[12]\,
      O => next_dc_carry_i_2_n_0
    );
next_dc_carry_i_3: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => dc_level(1),
      I1 => \difference_latched_reg_n_0_[11]\,
      O => next_dc_carry_i_3_n_0
    );
next_dc_carry_i_4: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => dc_level(0),
      I1 => \difference_latched_reg_n_0_[10]\,
      O => next_dc_carry_i_4_n_0
    );
\p_0_out_inferred__3/i__carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \p_0_out_inferred__3/i__carry_n_0\,
      CO(2) => \p_0_out_inferred__3/i__carry_n_1\,
      CO(1) => \p_0_out_inferred__3/i__carry_n_2\,
      CO(0) => \p_0_out_inferred__3/i__carry_n_3\,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_p_0_out_inferred__3/i__carry_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry_i_1_n_0\,
      S(2) => \i__carry_i_2_n_0\,
      S(1) => \i__carry_i_3_n_0\,
      S(0) => \i__carry_i_4_n_0\
    );
\p_0_out_inferred__3/i__carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \p_0_out_inferred__3/i__carry_n_0\,
      CO(3) => \p_0_out_inferred__3/i__carry__0_n_0\,
      CO(2) => \p_0_out_inferred__3/i__carry__0_n_1\,
      CO(1) => \p_0_out_inferred__3/i__carry__0_n_2\,
      CO(0) => \p_0_out_inferred__3/i__carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_p_0_out_inferred__3/i__carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry__0_i_1_n_0\,
      S(2) => \i__carry__0_i_2_n_0\,
      S(1) => \i__carry__0_i_3_n_0\,
      S(0) => \i__carry__0_i_4_n_0\
    );
\p_0_out_inferred__3/i__carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \p_0_out_inferred__3/i__carry__0_n_0\,
      CO(3) => \p_0_out_inferred__3/i__carry__1_n_0\,
      CO(2) => \p_0_out_inferred__3/i__carry__1_n_1\,
      CO(1) => \p_0_out_inferred__3/i__carry__1_n_2\,
      CO(0) => \p_0_out_inferred__3/i__carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_p_0_out_inferred__3/i__carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry__1_i_1_n_0\,
      S(2) => \i__carry__1_i_2_n_0\,
      S(1) => \i__carry__1_i_3_n_0\,
      S(0) => \i__carry__1_i_4_n_0\
    );
\p_0_out_inferred__3/i__carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \p_0_out_inferred__3/i__carry__1_n_0\,
      CO(3) => \p_0_out_inferred__3/i__carry__2_n_0\,
      CO(2) => \p_0_out_inferred__3/i__carry__2_n_1\,
      CO(1) => \p_0_out_inferred__3/i__carry__2_n_2\,
      CO(0) => \p_0_out_inferred__3/i__carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_p_0_out_inferred__3/i__carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry__2_i_1_n_0\,
      S(2) => \i__carry__2_i_2_n_0\,
      S(1) => \i__carry__2_i_3_n_0\,
      S(0) => \i__carry__2_i_4_n_0\
    );
\p_0_out_inferred__3/i__carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \p_0_out_inferred__3/i__carry__2_n_0\,
      CO(3) => \p_0_out_inferred__3/i__carry__3_n_0\,
      CO(2) => \p_0_out_inferred__3/i__carry__3_n_1\,
      CO(1) => \p_0_out_inferred__3/i__carry__3_n_2\,
      CO(0) => \p_0_out_inferred__3/i__carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_p_0_out_inferred__3/i__carry__3_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry__3_i_1_n_0\,
      S(2) => \i__carry__3_i_2_n_0\,
      S(1) => \i__carry__3_i_3_n_0\,
      S(0) => \i__carry__3_i_4_n_0\
    );
\p_0_out_inferred__3/i__carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \p_0_out_inferred__3/i__carry__3_n_0\,
      CO(3 downto 2) => \NLW_p_0_out_inferred__3/i__carry__4_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \p_0_out_inferred__3/i__carry__4_n_2\,
      CO(0) => \p_0_out_inferred__3/i__carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_p_0_out_inferred__3/i__carry__4_O_UNCONNECTED\(3 downto 0),
      S(3 downto 2) => B"00",
      S(1) => \^out\(63),
      S(0) => \i__carry__4_i_1_n_0\
    );
quiet_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => quiet_carry_n_0,
      CO(2) => quiet_carry_n_1,
      CO(1) => quiet_carry_n_2,
      CO(0) => quiet_carry_n_3,
      CYINIT => '1',
      DI(3) => quiet_carry_i_1_n_0,
      DI(2) => quiet_carry_i_2_n_0,
      DI(1) => quiet_carry_i_3_n_0,
      DI(0) => quiet_carry_i_4_n_0,
      O(3 downto 0) => NLW_quiet_carry_O_UNCONNECTED(3 downto 0),
      S(3) => quiet_carry_i_5_n_0,
      S(2) => quiet_carry_i_6_n_0,
      S(1) => quiet_carry_i_7_n_0,
      S(0) => quiet_carry_i_8_n_0
    );
\quiet_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => quiet_carry_n_0,
      CO(3) => \quiet_carry__0_n_0\,
      CO(2) => \quiet_carry__0_n_1\,
      CO(1) => \quiet_carry__0_n_2\,
      CO(0) => \quiet_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \quiet_carry__0_i_1_n_0\,
      DI(2) => \quiet_carry__0_i_2_n_0\,
      DI(1) => \quiet_carry__0_i_3_n_0\,
      DI(0) => \quiet_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_quiet_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \quiet_carry__0_i_5_n_0\,
      S(2) => \quiet_carry__0_i_6_n_0\,
      S(1) => \quiet_carry__0_i_7_n_0\,
      S(0) => \quiet_carry__0_i_8_n_0\
    );
\quiet_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(15),
      I1 => \accumulation_reg[15]_i_1_n_4\,
      I2 => \quiet_carry__2_0\(14),
      I3 => \accumulation_reg[15]_i_1_n_5\,
      O => \quiet_carry__0_i_1_n_0\
    );
\quiet_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(13),
      I1 => \accumulation_reg[15]_i_1_n_6\,
      I2 => \quiet_carry__2_0\(12),
      I3 => \accumulation_reg[15]_i_1_n_7\,
      O => \quiet_carry__0_i_2_n_0\
    );
\quiet_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(11),
      I1 => \accumulation_reg[11]_i_1_n_4\,
      I2 => \quiet_carry__2_0\(10),
      I3 => \accumulation_reg[11]_i_1_n_5\,
      O => \quiet_carry__0_i_3_n_0\
    );
\quiet_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(9),
      I1 => \accumulation_reg[11]_i_1_n_6\,
      I2 => \quiet_carry__2_0\(8),
      I3 => \accumulation_reg[11]_i_1_n_7\,
      O => \quiet_carry__0_i_4_n_0\
    );
\quiet_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[15]_i_1_n_4\,
      I1 => \quiet_carry__2_0\(15),
      I2 => \accumulation_reg[15]_i_1_n_5\,
      I3 => \quiet_carry__2_0\(14),
      O => \quiet_carry__0_i_5_n_0\
    );
\quiet_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[15]_i_1_n_6\,
      I1 => \quiet_carry__2_0\(13),
      I2 => \accumulation_reg[15]_i_1_n_7\,
      I3 => \quiet_carry__2_0\(12),
      O => \quiet_carry__0_i_6_n_0\
    );
\quiet_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[11]_i_1_n_4\,
      I1 => \quiet_carry__2_0\(11),
      I2 => \accumulation_reg[11]_i_1_n_5\,
      I3 => \quiet_carry__2_0\(10),
      O => \quiet_carry__0_i_7_n_0\
    );
\quiet_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[11]_i_1_n_6\,
      I1 => \quiet_carry__2_0\(9),
      I2 => \accumulation_reg[11]_i_1_n_7\,
      I3 => \quiet_carry__2_0\(8),
      O => \quiet_carry__0_i_8_n_0\
    );
\quiet_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \quiet_carry__0_n_0\,
      CO(3) => \quiet_carry__1_n_0\,
      CO(2) => \quiet_carry__1_n_1\,
      CO(1) => \quiet_carry__1_n_2\,
      CO(0) => \quiet_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \quiet_carry__1_i_1_n_0\,
      DI(2) => \quiet_carry__1_i_2_n_0\,
      DI(1) => \quiet_carry__1_i_3_n_0\,
      DI(0) => \quiet_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_quiet_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \quiet_carry__1_i_5_n_0\,
      S(2) => \quiet_carry__1_i_6_n_0\,
      S(1) => \quiet_carry__1_i_7_n_0\,
      S(0) => \quiet_carry__1_i_8_n_0\
    );
\quiet_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(23),
      I1 => \accumulation_reg[23]_i_1_n_4\,
      I2 => \quiet_carry__2_0\(22),
      I3 => \accumulation_reg[23]_i_1_n_5\,
      O => \quiet_carry__1_i_1_n_0\
    );
\quiet_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(21),
      I1 => \accumulation_reg[23]_i_1_n_6\,
      I2 => \quiet_carry__2_0\(20),
      I3 => \accumulation_reg[23]_i_1_n_7\,
      O => \quiet_carry__1_i_2_n_0\
    );
\quiet_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(19),
      I1 => \accumulation_reg[19]_i_1_n_4\,
      I2 => \quiet_carry__2_0\(18),
      I3 => \accumulation_reg[19]_i_1_n_5\,
      O => \quiet_carry__1_i_3_n_0\
    );
\quiet_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(17),
      I1 => \accumulation_reg[19]_i_1_n_6\,
      I2 => \quiet_carry__2_0\(16),
      I3 => \accumulation_reg[19]_i_1_n_7\,
      O => \quiet_carry__1_i_4_n_0\
    );
\quiet_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[23]_i_1_n_4\,
      I1 => \quiet_carry__2_0\(23),
      I2 => \accumulation_reg[23]_i_1_n_5\,
      I3 => \quiet_carry__2_0\(22),
      O => \quiet_carry__1_i_5_n_0\
    );
\quiet_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[23]_i_1_n_6\,
      I1 => \quiet_carry__2_0\(21),
      I2 => \accumulation_reg[23]_i_1_n_7\,
      I3 => \quiet_carry__2_0\(20),
      O => \quiet_carry__1_i_6_n_0\
    );
\quiet_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[19]_i_1_n_4\,
      I1 => \quiet_carry__2_0\(19),
      I2 => \accumulation_reg[19]_i_1_n_5\,
      I3 => \quiet_carry__2_0\(18),
      O => \quiet_carry__1_i_7_n_0\
    );
\quiet_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[19]_i_1_n_6\,
      I1 => \quiet_carry__2_0\(17),
      I2 => \accumulation_reg[19]_i_1_n_7\,
      I3 => \quiet_carry__2_0\(16),
      O => \quiet_carry__1_i_8_n_0\
    );
\quiet_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \quiet_carry__1_n_0\,
      CO(3) => \quiet_carry__2_n_0\,
      CO(2) => \quiet_carry__2_n_1\,
      CO(1) => \quiet_carry__2_n_2\,
      CO(0) => \quiet_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \quiet_carry__2_i_1_n_0\,
      DI(2) => \quiet_carry__2_i_2_n_0\,
      DI(1) => \quiet_carry__2_i_3_n_0\,
      DI(0) => \quiet_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_quiet_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \quiet_carry__2_i_5_n_0\,
      S(2) => \quiet_carry__2_i_6_n_0\,
      S(1) => \quiet_carry__2_i_7_n_0\,
      S(0) => \quiet_carry__2_i_8_n_0\
    );
\quiet_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(31),
      I1 => \accumulation_reg[31]_i_1_n_4\,
      I2 => \quiet_carry__2_0\(30),
      I3 => \accumulation_reg[31]_i_1_n_5\,
      O => \quiet_carry__2_i_1_n_0\
    );
\quiet_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(29),
      I1 => \accumulation_reg[31]_i_1_n_6\,
      I2 => \quiet_carry__2_0\(28),
      I3 => \accumulation_reg[31]_i_1_n_7\,
      O => \quiet_carry__2_i_2_n_0\
    );
\quiet_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(27),
      I1 => \accumulation_reg[27]_i_1_n_4\,
      I2 => \quiet_carry__2_0\(26),
      I3 => \accumulation_reg[27]_i_1_n_5\,
      O => \quiet_carry__2_i_3_n_0\
    );
\quiet_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(25),
      I1 => \accumulation_reg[27]_i_1_n_6\,
      I2 => \quiet_carry__2_0\(24),
      I3 => \accumulation_reg[27]_i_1_n_7\,
      O => \quiet_carry__2_i_4_n_0\
    );
\quiet_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[31]_i_1_n_4\,
      I1 => \quiet_carry__2_0\(31),
      I2 => \accumulation_reg[31]_i_1_n_5\,
      I3 => \quiet_carry__2_0\(30),
      O => \quiet_carry__2_i_5_n_0\
    );
\quiet_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[31]_i_1_n_6\,
      I1 => \quiet_carry__2_0\(29),
      I2 => \accumulation_reg[31]_i_1_n_7\,
      I3 => \quiet_carry__2_0\(28),
      O => \quiet_carry__2_i_6_n_0\
    );
\quiet_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[27]_i_1_n_4\,
      I1 => \quiet_carry__2_0\(27),
      I2 => \accumulation_reg[27]_i_1_n_5\,
      I3 => \quiet_carry__2_0\(26),
      O => \quiet_carry__2_i_7_n_0\
    );
\quiet_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[27]_i_1_n_6\,
      I1 => \quiet_carry__2_0\(25),
      I2 => \accumulation_reg[27]_i_1_n_7\,
      I3 => \quiet_carry__2_0\(24),
      O => \quiet_carry__2_i_8_n_0\
    );
\quiet_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \quiet_carry__2_n_0\,
      CO(3 downto 1) => \NLW_quiet_carry__3_CO_UNCONNECTED\(3 downto 1),
      CO(0) => quiet,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_quiet_carry__3_O_UNCONNECTED\(3 downto 0),
      S(3 downto 1) => B"000",
      S(0) => \quiet_carry__3_i_1_n_0\
    );
\quiet_carry__3_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => p_0_in,
      O => \quiet_carry__3_i_1_n_0\
    );
quiet_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(7),
      I1 => \accumulation_reg[7]_i_1_n_4\,
      I2 => \quiet_carry__2_0\(6),
      I3 => \accumulation_reg[7]_i_1_n_5\,
      O => quiet_carry_i_1_n_0
    );
quiet_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(5),
      I1 => \accumulation_reg[7]_i_1_n_6\,
      I2 => \quiet_carry__2_0\(4),
      I3 => \accumulation_reg[7]_i_1_n_7\,
      O => quiet_carry_i_2_n_0
    );
quiet_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(3),
      I1 => \accumulation_reg[3]_i_1_n_4\,
      I2 => \quiet_carry__2_0\(2),
      I3 => \accumulation_reg[3]_i_1_n_5\,
      O => quiet_carry_i_3_n_0
    );
quiet_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \quiet_carry__2_0\(1),
      I1 => \accumulation_reg[3]_i_1_n_6\,
      I2 => \quiet_carry__2_0\(0),
      I3 => \accumulation_reg[3]_i_1_n_7\,
      O => quiet_carry_i_4_n_0
    );
quiet_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[7]_i_1_n_4\,
      I1 => \quiet_carry__2_0\(7),
      I2 => \accumulation_reg[7]_i_1_n_5\,
      I3 => \quiet_carry__2_0\(6),
      O => quiet_carry_i_5_n_0
    );
quiet_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[7]_i_1_n_6\,
      I1 => \quiet_carry__2_0\(5),
      I2 => \accumulation_reg[7]_i_1_n_7\,
      I3 => \quiet_carry__2_0\(4),
      O => quiet_carry_i_6_n_0
    );
quiet_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[3]_i_1_n_4\,
      I1 => \quiet_carry__2_0\(3),
      I2 => \accumulation_reg[3]_i_1_n_5\,
      I3 => \quiet_carry__2_0\(2),
      O => quiet_carry_i_7_n_0
    );
quiet_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \accumulation_reg[3]_i_1_n_6\,
      I1 => \quiet_carry__2_0\(1),
      I2 => \accumulation_reg[3]_i_1_n_7\,
      I3 => \quiet_carry__2_0\(0),
      O => quiet_carry_i_8_n_0
    );
\quiet_count[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5D5D000855550808"
    )
        port map (
      I0 => \candidate_count[2]_i_3_n_0\,
      I1 => quiet,
      I2 => \^status\(4),
      I3 => \quiet_count_reg_n_0_[1]\,
      I4 => \quiet_count_reg_n_0_[0]\,
      I5 => \quiet_count_reg_n_0_[2]\,
      O => \quiet_count[0]_i_1_n_0\
    );
\quiet_count[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5D005D0055085D00"
    )
        port map (
      I0 => \candidate_count[2]_i_3_n_0\,
      I1 => quiet,
      I2 => \^status\(4),
      I3 => \quiet_count_reg_n_0_[1]\,
      I4 => \quiet_count_reg_n_0_[0]\,
      I5 => \quiet_count_reg_n_0_[2]\,
      O => \quiet_count[1]_i_1_n_0\
    );
\quiet_count[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5D5D5D5D08000000"
    )
        port map (
      I0 => \candidate_count[2]_i_3_n_0\,
      I1 => quiet,
      I2 => \^status\(4),
      I3 => \quiet_count_reg_n_0_[1]\,
      I4 => \quiet_count_reg_n_0_[0]\,
      I5 => \quiet_count_reg_n_0_[2]\,
      O => \quiet_count[2]_i_1_n_0\
    );
\quiet_count_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \quiet_count[0]_i_1_n_0\,
      Q => \quiet_count_reg_n_0_[0]\,
      R => \state[1]_i_1_n_0\
    );
\quiet_count_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \quiet_count[1]_i_1_n_0\,
      Q => \quiet_count_reg_n_0_[1]\,
      R => \state[1]_i_1_n_0\
    );
\quiet_count_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \quiet_count[2]_i_1_n_0\,
      Q => \quiet_count_reg_n_0_[2]\,
      R => \state[1]_i_1_n_0\
    );
\s_axi_bresp[1]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s_axi_aresetn,
      O => \^s_axi_aresetn_0\
    );
\s_axi_rdata[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF00B8000000B800"
    )
        port map (
      I0 => \s_axi_rdata_reg[0]\,
      I1 => \s_axi_rdata_reg[2]_2\,
      I2 => \s_axi_rdata_reg[0]_0\,
      I3 => \s_axi_rdata_reg[2]\,
      I4 => \s_axi_rdata_reg[2]_0\,
      I5 => \s_axi_rdata[0]_i_4_n_0\,
      O => \snapshot_sequence_reg[10]\(0)
    );
\s_axi_rdata[0]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FC33FC33FCBBFC88"
    )
        port map (
      I0 => \faults_reg[0]_1\(0),
      I1 => \s_axi_rdata_reg[2]_2\,
      I2 => \s_axi_rdata[0]_i_6_n_0\,
      I3 => \s_axi_rdata_reg[4]_2\,
      I4 => \s_axi_rdata_reg[9]\(0),
      I5 => \s_axi_rdata_reg[4]_1\,
      O => \s_axi_rdata[0]_i_4_n_0\
    );
\s_axi_rdata[0]_i_6\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \^faults_reg[7]_0\(0),
      I1 => \s_axi_rdata_reg[4]_1\,
      I2 => config_epoch_reg(0),
      O => \s_axi_rdata[0]_i_6_n_0\
    );
\s_axi_rdata[10]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FF2A0000"
    )
        port map (
      I0 => \s_axi_rdata_reg[10]\,
      I1 => \s_axi_rdata_reg[2]_2\,
      I2 => \s_axi_rdata_reg[10]_0\,
      I3 => \s_axi_rdata_reg[2]_0\,
      I4 => \s_axi_rdata_reg[2]\,
      I5 => \s_axi_rdata[10]_i_4_n_0\,
      O => \snapshot_sequence_reg[10]\(10)
    );
\s_axi_rdata[10]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3ACA00003AFA0000"
    )
        port map (
      I0 => \s_axi_rdata_reg[10]_1\,
      I1 => \s_axi_rdata_reg[4]_1\,
      I2 => \s_axi_rdata_reg[2]_2\,
      I3 => \s_axi_rdata_reg[4]_2\,
      I4 => \s_axi_rdata_reg[2]_0\,
      I5 => \^status\(4),
      O => \s_axi_rdata[10]_i_4_n_0\
    );
\s_axi_rdata[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8A8A8A8888888A88"
    )
        port map (
      I0 => \s_axi_rdata_reg[2]\,
      I1 => \s_axi_rdata[1]_i_2_n_0\,
      I2 => \s_axi_rdata_reg[2]_0\,
      I3 => \s_axi_rdata_reg[1]\,
      I4 => \s_axi_rdata_reg[2]_2\,
      I5 => \s_axi_rdata_reg[1]_0\,
      O => \snapshot_sequence_reg[10]\(1)
    );
\s_axi_rdata[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFA8080000"
    )
        port map (
      I0 => \s_axi_rdata_reg[4]_2\,
      I1 => config_epoch_reg(1),
      I2 => \s_axi_rdata_reg[4]_1\,
      I3 => \^faults_reg[7]_0\(1),
      I4 => \s_axi_rdata_reg[1]_1\,
      I5 => \s_axi_rdata[1]_i_5_n_0\,
      O => \s_axi_rdata[1]_i_2_n_0\
    );
\s_axi_rdata[1]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => \s_axi_rdata_reg[4]_2\,
      I1 => \s_axi_rdata_reg[2]_0\,
      I2 => \^status\(0),
      I3 => \s_axi_rdata_reg[2]_2\,
      I4 => \s_axi_rdata_reg[9]\(1),
      I5 => \s_axi_rdata_reg[4]_1\,
      O => \s_axi_rdata[1]_i_5_n_0\
    );
\s_axi_rdata[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8A8A8A8888888A88"
    )
        port map (
      I0 => \s_axi_rdata_reg[2]\,
      I1 => \s_axi_rdata[2]_i_2_n_0\,
      I2 => \s_axi_rdata_reg[2]_0\,
      I3 => \s_axi_rdata_reg[2]_1\,
      I4 => \s_axi_rdata_reg[2]_2\,
      I5 => \s_axi_rdata_reg[2]_3\,
      O => \snapshot_sequence_reg[10]\(2)
    );
\s_axi_rdata[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00D0F0D000500050"
    )
        port map (
      I0 => \s_axi_rdata[2]_i_5_n_0\,
      I1 => \s_axi_rdata_reg[9]\(2),
      I2 => \s_axi_rdata_reg[2]_0\,
      I3 => \s_axi_rdata_reg[2]_2\,
      I4 => \event_age[31]_i_1_n_0\,
      I5 => \s_axi_rdata_reg[2]_4\,
      O => \s_axi_rdata[2]_i_2_n_0\
    );
\s_axi_rdata[2]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"57F7"
    )
        port map (
      I0 => \s_axi_rdata_reg[4]_2\,
      I1 => config_epoch_reg(2),
      I2 => \s_axi_rdata_reg[4]_1\,
      I3 => \^faults_reg[7]_0\(2),
      O => \s_axi_rdata[2]_i_5_n_0\
    );
\s_axi_rdata[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8A8A8A8888888A88"
    )
        port map (
      I0 => \s_axi_rdata_reg[2]\,
      I1 => \s_axi_rdata[3]_i_2_n_0\,
      I2 => \s_axi_rdata_reg[2]_0\,
      I3 => \s_axi_rdata_reg[3]\,
      I4 => \s_axi_rdata_reg[2]_2\,
      I5 => \s_axi_rdata_reg[3]_0\,
      O => \snapshot_sequence_reg[10]\(3)
    );
\s_axi_rdata[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFA8080000"
    )
        port map (
      I0 => \s_axi_rdata_reg[4]_2\,
      I1 => config_epoch_reg(3),
      I2 => \s_axi_rdata_reg[4]_1\,
      I3 => \^faults_reg[7]_0\(3),
      I4 => \s_axi_rdata_reg[1]_1\,
      I5 => \s_axi_rdata_reg[3]_1\,
      O => \s_axi_rdata[3]_i_2_n_0\
    );
\s_axi_rdata[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFB80000"
    )
        port map (
      I0 => \s_axi_rdata_reg[4]\,
      I1 => \s_axi_rdata_reg[2]_2\,
      I2 => \s_axi_rdata_reg[4]_0\,
      I3 => \s_axi_rdata_reg[2]_0\,
      I4 => \s_axi_rdata_reg[2]\,
      I5 => \s_axi_rdata[4]_i_4_n_0\,
      O => \snapshot_sequence_reg[10]\(4)
    );
\s_axi_rdata[4]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0AFAFA3A00000000"
    )
        port map (
      I0 => \s_axi_rdata[4]_i_6_n_0\,
      I1 => \^status\(1),
      I2 => \s_axi_rdata_reg[2]_2\,
      I3 => \s_axi_rdata_reg[4]_1\,
      I4 => \s_axi_rdata_reg[4]_2\,
      I5 => \s_axi_rdata_reg[2]_0\,
      O => \s_axi_rdata[4]_i_4_n_0\
    );
\s_axi_rdata[4]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"5050303F"
    )
        port map (
      I0 => \^faults_reg[7]_0\(4),
      I1 => config_epoch_reg(4),
      I2 => \s_axi_rdata_reg[4]_2\,
      I3 => \s_axi_rdata_reg[9]\(3),
      I4 => \s_axi_rdata_reg[4]_1\,
      O => \s_axi_rdata[4]_i_6_n_0\
    );
\s_axi_rdata[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000002A2AAAA02A2"
    )
        port map (
      I0 => \s_axi_rdata_reg[2]\,
      I1 => \s_axi_rdata_reg[5]\,
      I2 => \s_axi_rdata_reg[2]_2\,
      I3 => \s_axi_rdata_reg[5]_0\,
      I4 => \s_axi_rdata_reg[2]_0\,
      I5 => \s_axi_rdata[5]_i_4_n_0\,
      O => \snapshot_sequence_reg[10]\(5)
    );
\s_axi_rdata[5]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"05FFBBAA05FFBBFF"
    )
        port map (
      I0 => \s_axi_rdata_reg[2]_2\,
      I1 => config_epoch_reg(5),
      I2 => \^faults_reg[7]_0\(5),
      I3 => \s_axi_rdata_reg[4]_2\,
      I4 => \s_axi_rdata_reg[4]_1\,
      I5 => \s_axi_rdata_reg[9]\(4),
      O => \s_axi_rdata[5]_i_4_n_0\
    );
\s_axi_rdata[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000088080A0A8808"
    )
        port map (
      I0 => \s_axi_rdata_reg[2]\,
      I1 => \s_axi_rdata_reg[6]\,
      I2 => \s_axi_rdata_reg[2]_2\,
      I3 => \s_axi_rdata_reg[6]_0\,
      I4 => \s_axi_rdata_reg[2]_0\,
      I5 => \s_axi_rdata[6]_i_4_n_0\,
      O => \snapshot_sequence_reg[10]\(6)
    );
\s_axi_rdata[6]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"5050303F"
    )
        port map (
      I0 => \^faults_reg[7]_0\(6),
      I1 => config_epoch_reg(6),
      I2 => \s_axi_rdata_reg[4]_2\,
      I3 => \s_axi_rdata_reg[9]\(5),
      I4 => \s_axi_rdata_reg[4]_1\,
      O => \s_axi_rdata[6]_i_4_n_0\
    );
\s_axi_rdata[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00200A2A00200222"
    )
        port map (
      I0 => \s_axi_rdata_reg[2]\,
      I1 => \s_axi_rdata_reg[2]_2\,
      I2 => \s_axi_rdata_reg[2]_0\,
      I3 => \s_axi_rdata[7]_i_2_n_0\,
      I4 => \s_axi_rdata_reg[7]\,
      I5 => \s_axi_rdata_reg[7]_0\,
      O => \snapshot_sequence_reg[10]\(7)
    );
\s_axi_rdata[7]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"5050303F"
    )
        port map (
      I0 => \^faults_reg[7]_0\(7),
      I1 => config_epoch_reg(7),
      I2 => \s_axi_rdata_reg[4]_2\,
      I3 => \s_axi_rdata_reg[9]\(6),
      I4 => \s_axi_rdata_reg[4]_1\,
      O => \s_axi_rdata[7]_i_2_n_0\
    );
\s_axi_rdata[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8AA88AAA8888888"
    )
        port map (
      I0 => \s_axi_rdata_reg[2]\,
      I1 => \s_axi_rdata_reg[8]\,
      I2 => \^status\(2),
      I3 => \s_axi_rdata_reg[2]_0\,
      I4 => \s_axi_rdata_reg[8]_0\,
      I5 => \s_axi_rdata_reg[8]_1\,
      O => \snapshot_sequence_reg[10]\(8)
    );
\s_axi_rdata[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAA8080000A808"
    )
        port map (
      I0 => \s_axi_rdata_reg[2]\,
      I1 => \s_axi_rdata_reg[9]_0\,
      I2 => \s_axi_rdata_reg[2]_2\,
      I3 => \s_axi_rdata_reg[9]_1\,
      I4 => \s_axi_rdata_reg[2]_0\,
      I5 => \s_axi_rdata[9]_i_4_n_0\,
      O => \snapshot_sequence_reg[10]\(9)
    );
\s_axi_rdata[9]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000F000FFAACC"
    )
        port map (
      I0 => config_epoch_reg(9),
      I1 => \s_axi_rdata_reg[9]\(7),
      I2 => \^status\(3),
      I3 => \s_axi_rdata_reg[4]_2\,
      I4 => \s_axi_rdata_reg[4]_1\,
      I5 => \s_axi_rdata_reg[2]_2\,
      O => \s_axi_rdata[9]_i_4_n_0\
    );
\sample_age[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFBFBFBF"
    )
        port map (
      I0 => configure,
      I1 => s_axi_aresetn,
      I2 => \faults_reg[0]_1\(0),
      I3 => \event_age[31]_i_1_n_0\,
      I4 => pcm_valid,
      O => \sample_age[0]_i_1_n_0\
    );
\sample_age[0]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \event_age[31]_i_1_n_0\,
      I1 => \sample_age[0]_i_3_n_0\,
      O => sample_age(0)
    );
\sample_age[0]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A8AA8888"
    )
        port map (
      I0 => \sample_age[0]_i_4_n_0\,
      I1 => sample_age_reg(15),
      I2 => \sample_age[0]_i_5_n_0\,
      I3 => \sample_age[0]_i_6_n_0\,
      I4 => sample_age_reg(14),
      O => \sample_age[0]_i_3_n_0\
    );
\sample_age[0]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => sample_age_reg(16),
      I1 => sample_age_reg(19),
      I2 => sample_age_reg(17),
      I3 => sample_age_reg(18),
      O => \sample_age[0]_i_4_n_0\
    );
\sample_age[0]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => sample_age_reg(11),
      I1 => sample_age_reg(12),
      I2 => sample_age_reg(10),
      I3 => sample_age_reg(13),
      O => \sample_age[0]_i_5_n_0\
    );
\sample_age[0]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5557"
    )
        port map (
      I0 => sample_age_reg(9),
      I1 => sample_age_reg(7),
      I2 => sample_age_reg(6),
      I3 => sample_age_reg(8),
      O => \sample_age[0]_i_6_n_0\
    );
\sample_age_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry_n_7\,
      Q => sample_age_reg(0),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__1_n_5\,
      Q => sample_age_reg(10),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__1_n_4\,
      Q => sample_age_reg(11),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__2_n_7\,
      Q => sample_age_reg(12),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__2_n_6\,
      Q => sample_age_reg(13),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__2_n_5\,
      Q => sample_age_reg(14),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__2_n_4\,
      Q => sample_age_reg(15),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__3_n_7\,
      Q => sample_age_reg(16),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__3_n_6\,
      Q => sample_age_reg(17),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__3_n_5\,
      Q => sample_age_reg(18),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__3_n_4\,
      Q => sample_age_reg(19),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry_n_6\,
      Q => sample_age_reg(1),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry_n_5\,
      Q => sample_age_reg(2),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry_n_4\,
      Q => sample_age_reg(3),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__0_n_7\,
      Q => sample_age_reg(4),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__0_n_6\,
      Q => sample_age_reg(5),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__0_n_5\,
      Q => sample_age_reg(6),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__0_n_4\,
      Q => sample_age_reg(7),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__1_n_7\,
      Q => sample_age_reg(8),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_age_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => sample_age(0),
      D => \i_/i_/i__carry__1_n_6\,
      Q => sample_age_reg(9),
      R => \sample_age[0]_i_1_n_0\
    );
\sample_count[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0080"
    )
        port map (
      I0 => filtered_valid,
      I1 => \event_age[31]_i_1_n_0\,
      I2 => \faults_reg[0]_1\(0),
      I3 => configure,
      O => \sample_count[0]_i_1_n_0\
    );
\sample_count[0]_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^out\(0),
      O => \sample_count[0]_i_3_n_0\
    );
\sample_count_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[0]_i_2_n_7\,
      Q => \^out\(0),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[0]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \sample_count_reg[0]_i_2_n_0\,
      CO(2) => \sample_count_reg[0]_i_2_n_1\,
      CO(1) => \sample_count_reg[0]_i_2_n_2\,
      CO(0) => \sample_count_reg[0]_i_2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \sample_count_reg[0]_i_2_n_4\,
      O(2) => \sample_count_reg[0]_i_2_n_5\,
      O(1) => \sample_count_reg[0]_i_2_n_6\,
      O(0) => \sample_count_reg[0]_i_2_n_7\,
      S(3 downto 1) => \^out\(3 downto 1),
      S(0) => \sample_count[0]_i_3_n_0\
    );
\sample_count_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[8]_i_1_n_5\,
      Q => \^out\(10),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[8]_i_1_n_4\,
      Q => \^out\(11),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[12]_i_1_n_7\,
      Q => \^out\(12),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[8]_i_1_n_0\,
      CO(3) => \sample_count_reg[12]_i_1_n_0\,
      CO(2) => \sample_count_reg[12]_i_1_n_1\,
      CO(1) => \sample_count_reg[12]_i_1_n_2\,
      CO(0) => \sample_count_reg[12]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[12]_i_1_n_4\,
      O(2) => \sample_count_reg[12]_i_1_n_5\,
      O(1) => \sample_count_reg[12]_i_1_n_6\,
      O(0) => \sample_count_reg[12]_i_1_n_7\,
      S(3 downto 0) => \^out\(15 downto 12)
    );
\sample_count_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[12]_i_1_n_6\,
      Q => \^out\(13),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[12]_i_1_n_5\,
      Q => \^out\(14),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[12]_i_1_n_4\,
      Q => \^out\(15),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[16]_i_1_n_7\,
      Q => \^out\(16),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[16]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[12]_i_1_n_0\,
      CO(3) => \sample_count_reg[16]_i_1_n_0\,
      CO(2) => \sample_count_reg[16]_i_1_n_1\,
      CO(1) => \sample_count_reg[16]_i_1_n_2\,
      CO(0) => \sample_count_reg[16]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[16]_i_1_n_4\,
      O(2) => \sample_count_reg[16]_i_1_n_5\,
      O(1) => \sample_count_reg[16]_i_1_n_6\,
      O(0) => \sample_count_reg[16]_i_1_n_7\,
      S(3 downto 0) => \^out\(19 downto 16)
    );
\sample_count_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[16]_i_1_n_6\,
      Q => \^out\(17),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[16]_i_1_n_5\,
      Q => \^out\(18),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[16]_i_1_n_4\,
      Q => \^out\(19),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[0]_i_2_n_6\,
      Q => \^out\(1),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[20]_i_1_n_7\,
      Q => \^out\(20),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[20]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[16]_i_1_n_0\,
      CO(3) => \sample_count_reg[20]_i_1_n_0\,
      CO(2) => \sample_count_reg[20]_i_1_n_1\,
      CO(1) => \sample_count_reg[20]_i_1_n_2\,
      CO(0) => \sample_count_reg[20]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[20]_i_1_n_4\,
      O(2) => \sample_count_reg[20]_i_1_n_5\,
      O(1) => \sample_count_reg[20]_i_1_n_6\,
      O(0) => \sample_count_reg[20]_i_1_n_7\,
      S(3 downto 0) => \^out\(23 downto 20)
    );
\sample_count_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[20]_i_1_n_6\,
      Q => \^out\(21),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[20]_i_1_n_5\,
      Q => \^out\(22),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[20]_i_1_n_4\,
      Q => \^out\(23),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[24]_i_1_n_7\,
      Q => \^out\(24),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[24]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[20]_i_1_n_0\,
      CO(3) => \sample_count_reg[24]_i_1_n_0\,
      CO(2) => \sample_count_reg[24]_i_1_n_1\,
      CO(1) => \sample_count_reg[24]_i_1_n_2\,
      CO(0) => \sample_count_reg[24]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[24]_i_1_n_4\,
      O(2) => \sample_count_reg[24]_i_1_n_5\,
      O(1) => \sample_count_reg[24]_i_1_n_6\,
      O(0) => \sample_count_reg[24]_i_1_n_7\,
      S(3 downto 0) => \^out\(27 downto 24)
    );
\sample_count_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[24]_i_1_n_6\,
      Q => \^out\(25),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[24]_i_1_n_5\,
      Q => \^out\(26),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[24]_i_1_n_4\,
      Q => \^out\(27),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[28]_i_1_n_7\,
      Q => \^out\(28),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[28]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[24]_i_1_n_0\,
      CO(3) => \sample_count_reg[28]_i_1_n_0\,
      CO(2) => \sample_count_reg[28]_i_1_n_1\,
      CO(1) => \sample_count_reg[28]_i_1_n_2\,
      CO(0) => \sample_count_reg[28]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[28]_i_1_n_4\,
      O(2) => \sample_count_reg[28]_i_1_n_5\,
      O(1) => \sample_count_reg[28]_i_1_n_6\,
      O(0) => \sample_count_reg[28]_i_1_n_7\,
      S(3 downto 0) => \^out\(31 downto 28)
    );
\sample_count_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[28]_i_1_n_6\,
      Q => \^out\(29),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[0]_i_2_n_5\,
      Q => \^out\(2),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[28]_i_1_n_5\,
      Q => \^out\(30),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[28]_i_1_n_4\,
      Q => \^out\(31),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[32]_i_1_n_7\,
      Q => \^out\(32),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[32]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[28]_i_1_n_0\,
      CO(3) => \sample_count_reg[32]_i_1_n_0\,
      CO(2) => \sample_count_reg[32]_i_1_n_1\,
      CO(1) => \sample_count_reg[32]_i_1_n_2\,
      CO(0) => \sample_count_reg[32]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[32]_i_1_n_4\,
      O(2) => \sample_count_reg[32]_i_1_n_5\,
      O(1) => \sample_count_reg[32]_i_1_n_6\,
      O(0) => \sample_count_reg[32]_i_1_n_7\,
      S(3 downto 0) => \^out\(35 downto 32)
    );
\sample_count_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[32]_i_1_n_6\,
      Q => \^out\(33),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[32]_i_1_n_5\,
      Q => \^out\(34),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[32]_i_1_n_4\,
      Q => \^out\(35),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[36]_i_1_n_7\,
      Q => \^out\(36),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[36]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[32]_i_1_n_0\,
      CO(3) => \sample_count_reg[36]_i_1_n_0\,
      CO(2) => \sample_count_reg[36]_i_1_n_1\,
      CO(1) => \sample_count_reg[36]_i_1_n_2\,
      CO(0) => \sample_count_reg[36]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[36]_i_1_n_4\,
      O(2) => \sample_count_reg[36]_i_1_n_5\,
      O(1) => \sample_count_reg[36]_i_1_n_6\,
      O(0) => \sample_count_reg[36]_i_1_n_7\,
      S(3 downto 0) => \^out\(39 downto 36)
    );
\sample_count_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[36]_i_1_n_6\,
      Q => \^out\(37),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[36]_i_1_n_5\,
      Q => \^out\(38),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[36]_i_1_n_4\,
      Q => \^out\(39),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[0]_i_2_n_4\,
      Q => \^out\(3),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[40]_i_1_n_7\,
      Q => \^out\(40),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[40]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[36]_i_1_n_0\,
      CO(3) => \sample_count_reg[40]_i_1_n_0\,
      CO(2) => \sample_count_reg[40]_i_1_n_1\,
      CO(1) => \sample_count_reg[40]_i_1_n_2\,
      CO(0) => \sample_count_reg[40]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[40]_i_1_n_4\,
      O(2) => \sample_count_reg[40]_i_1_n_5\,
      O(1) => \sample_count_reg[40]_i_1_n_6\,
      O(0) => \sample_count_reg[40]_i_1_n_7\,
      S(3 downto 0) => \^out\(43 downto 40)
    );
\sample_count_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[40]_i_1_n_6\,
      Q => \^out\(41),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[40]_i_1_n_5\,
      Q => \^out\(42),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[40]_i_1_n_4\,
      Q => \^out\(43),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[44]_i_1_n_7\,
      Q => \^out\(44),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[44]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[40]_i_1_n_0\,
      CO(3) => \sample_count_reg[44]_i_1_n_0\,
      CO(2) => \sample_count_reg[44]_i_1_n_1\,
      CO(1) => \sample_count_reg[44]_i_1_n_2\,
      CO(0) => \sample_count_reg[44]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[44]_i_1_n_4\,
      O(2) => \sample_count_reg[44]_i_1_n_5\,
      O(1) => \sample_count_reg[44]_i_1_n_6\,
      O(0) => \sample_count_reg[44]_i_1_n_7\,
      S(3 downto 0) => \^out\(47 downto 44)
    );
\sample_count_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[44]_i_1_n_6\,
      Q => \^out\(45),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[44]_i_1_n_5\,
      Q => \^out\(46),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[44]_i_1_n_4\,
      Q => \^out\(47),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[48]_i_1_n_7\,
      Q => \^out\(48),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[48]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[44]_i_1_n_0\,
      CO(3) => \sample_count_reg[48]_i_1_n_0\,
      CO(2) => \sample_count_reg[48]_i_1_n_1\,
      CO(1) => \sample_count_reg[48]_i_1_n_2\,
      CO(0) => \sample_count_reg[48]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[48]_i_1_n_4\,
      O(2) => \sample_count_reg[48]_i_1_n_5\,
      O(1) => \sample_count_reg[48]_i_1_n_6\,
      O(0) => \sample_count_reg[48]_i_1_n_7\,
      S(3 downto 0) => \^out\(51 downto 48)
    );
\sample_count_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[48]_i_1_n_6\,
      Q => \^out\(49),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[4]_i_1_n_7\,
      Q => \^out\(4),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[0]_i_2_n_0\,
      CO(3) => \sample_count_reg[4]_i_1_n_0\,
      CO(2) => \sample_count_reg[4]_i_1_n_1\,
      CO(1) => \sample_count_reg[4]_i_1_n_2\,
      CO(0) => \sample_count_reg[4]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[4]_i_1_n_4\,
      O(2) => \sample_count_reg[4]_i_1_n_5\,
      O(1) => \sample_count_reg[4]_i_1_n_6\,
      O(0) => \sample_count_reg[4]_i_1_n_7\,
      S(3 downto 0) => \^out\(7 downto 4)
    );
\sample_count_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[48]_i_1_n_5\,
      Q => \^out\(50),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[48]_i_1_n_4\,
      Q => \^out\(51),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[52]_i_1_n_7\,
      Q => \^out\(52),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[52]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[48]_i_1_n_0\,
      CO(3) => \sample_count_reg[52]_i_1_n_0\,
      CO(2) => \sample_count_reg[52]_i_1_n_1\,
      CO(1) => \sample_count_reg[52]_i_1_n_2\,
      CO(0) => \sample_count_reg[52]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[52]_i_1_n_4\,
      O(2) => \sample_count_reg[52]_i_1_n_5\,
      O(1) => \sample_count_reg[52]_i_1_n_6\,
      O(0) => \sample_count_reg[52]_i_1_n_7\,
      S(3 downto 0) => \^out\(55 downto 52)
    );
\sample_count_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[52]_i_1_n_6\,
      Q => \^out\(53),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[52]_i_1_n_5\,
      Q => \^out\(54),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[52]_i_1_n_4\,
      Q => \^out\(55),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[56]_i_1_n_7\,
      Q => \^out\(56),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[56]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[52]_i_1_n_0\,
      CO(3) => \sample_count_reg[56]_i_1_n_0\,
      CO(2) => \sample_count_reg[56]_i_1_n_1\,
      CO(1) => \sample_count_reg[56]_i_1_n_2\,
      CO(0) => \sample_count_reg[56]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[56]_i_1_n_4\,
      O(2) => \sample_count_reg[56]_i_1_n_5\,
      O(1) => \sample_count_reg[56]_i_1_n_6\,
      O(0) => \sample_count_reg[56]_i_1_n_7\,
      S(3 downto 0) => \^out\(59 downto 56)
    );
\sample_count_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[56]_i_1_n_6\,
      Q => \^out\(57),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[56]_i_1_n_5\,
      Q => \^out\(58),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[56]_i_1_n_4\,
      Q => \^out\(59),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[4]_i_1_n_6\,
      Q => \^out\(5),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[60]_i_1_n_7\,
      Q => \^out\(60),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[60]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[56]_i_1_n_0\,
      CO(3) => \NLW_sample_count_reg[60]_i_1_CO_UNCONNECTED\(3),
      CO(2) => \sample_count_reg[60]_i_1_n_1\,
      CO(1) => \sample_count_reg[60]_i_1_n_2\,
      CO(0) => \sample_count_reg[60]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[60]_i_1_n_4\,
      O(2) => \sample_count_reg[60]_i_1_n_5\,
      O(1) => \sample_count_reg[60]_i_1_n_6\,
      O(0) => \sample_count_reg[60]_i_1_n_7\,
      S(3 downto 0) => \^out\(63 downto 60)
    );
\sample_count_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[60]_i_1_n_6\,
      Q => \^out\(61),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[60]_i_1_n_5\,
      Q => \^out\(62),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[60]_i_1_n_4\,
      Q => \^out\(63),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[4]_i_1_n_5\,
      Q => \^out\(6),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[4]_i_1_n_4\,
      Q => \^out\(7),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[8]_i_1_n_7\,
      Q => \^out\(8),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_count_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \sample_count_reg[4]_i_1_n_0\,
      CO(3) => \sample_count_reg[8]_i_1_n_0\,
      CO(2) => \sample_count_reg[8]_i_1_n_1\,
      CO(1) => \sample_count_reg[8]_i_1_n_2\,
      CO(0) => \sample_count_reg[8]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \sample_count_reg[8]_i_1_n_4\,
      O(2) => \sample_count_reg[8]_i_1_n_5\,
      O(1) => \sample_count_reg[8]_i_1_n_6\,
      O(0) => \sample_count_reg[8]_i_1_n_7\,
      S(3 downto 0) => \^out\(11 downto 8)
    );
\sample_count_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \sample_count[0]_i_1_n_0\,
      D => \sample_count_reg[8]_i_1_n_6\,
      Q => \^out\(9),
      R => \last_sum[31]_i_1_n_0\
    );
\sample_in_window[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFFFFEFF"
    )
        port map (
      I0 => \sample_in_window_reg_n_0_[1]\,
      I1 => \sample_in_window_reg_n_0_[2]\,
      I2 => \sample_in_window[0]_i_2_n_0\,
      I3 => \sample_in_window_reg_n_0_[9]\,
      I4 => \sample_in_window_reg_n_0_[3]\,
      I5 => \sample_in_window_reg_n_0_[0]\,
      O => sample_in_window(0)
    );
\sample_in_window[0]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => \sample_in_window_reg_n_0_[8]\,
      I1 => \sample_in_window_reg_n_0_[7]\,
      I2 => \sample_in_window_reg_n_0_[4]\,
      I3 => \sample_in_window_reg_n_0_[6]\,
      I4 => \sample_in_window_reg_n_0_[5]\,
      O => \sample_in_window[0]_i_2_n_0\
    );
\sample_in_window[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \sample_in_window_reg_n_0_[1]\,
      I1 => \sample_in_window_reg_n_0_[0]\,
      O => sample_in_window(1)
    );
\sample_in_window[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \sample_in_window_reg_n_0_[2]\,
      I1 => \sample_in_window_reg_n_0_[0]\,
      I2 => \sample_in_window_reg_n_0_[1]\,
      O => sample_in_window(2)
    );
\sample_in_window[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \sample_in_window_reg_n_0_[3]\,
      I1 => \sample_in_window_reg_n_0_[1]\,
      I2 => \sample_in_window_reg_n_0_[0]\,
      I3 => \sample_in_window_reg_n_0_[2]\,
      O => sample_in_window(3)
    );
\sample_in_window[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000007FFF8000"
    )
        port map (
      I0 => \sample_in_window_reg_n_0_[3]\,
      I1 => \sample_in_window_reg_n_0_[1]\,
      I2 => \sample_in_window_reg_n_0_[0]\,
      I3 => \sample_in_window_reg_n_0_[2]\,
      I4 => \sample_in_window_reg_n_0_[4]\,
      I5 => \clipped_count[15]_i_4_n_0\,
      O => sample_in_window(4)
    );
\sample_in_window[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => \sample_in_window_reg_n_0_[5]\,
      I1 => \sample_in_window_reg_n_0_[2]\,
      I2 => \sample_in_window_reg_n_0_[0]\,
      I3 => \sample_in_window_reg_n_0_[1]\,
      I4 => \sample_in_window_reg_n_0_[4]\,
      I5 => \sample_in_window_reg_n_0_[3]\,
      O => sample_in_window(5)
    );
\sample_in_window[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"1444444444444444"
    )
        port map (
      I0 => \clipped_count[15]_i_4_n_0\,
      I1 => \sample_in_window_reg_n_0_[6]\,
      I2 => \sample_in_window[6]_i_2_n_0\,
      I3 => \sample_in_window_reg_n_0_[4]\,
      I4 => \sample_in_window_reg_n_0_[3]\,
      I5 => \sample_in_window_reg_n_0_[5]\,
      O => sample_in_window(6)
    );
\sample_in_window[6]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \sample_in_window_reg_n_0_[2]\,
      I1 => \sample_in_window_reg_n_0_[0]\,
      I2 => \sample_in_window_reg_n_0_[1]\,
      O => \sample_in_window[6]_i_2_n_0\
    );
\sample_in_window[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"14"
    )
        port map (
      I0 => \clipped_count[15]_i_4_n_0\,
      I1 => \sample_in_window_reg_n_0_[7]\,
      I2 => \sample_in_window[9]_i_4_n_0\,
      O => sample_in_window(7)
    );
\sample_in_window[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0078"
    )
        port map (
      I0 => \sample_in_window[9]_i_4_n_0\,
      I1 => \sample_in_window_reg_n_0_[7]\,
      I2 => \sample_in_window_reg_n_0_[8]\,
      I3 => \clipped_count[15]_i_4_n_0\,
      O => sample_in_window(8)
    );
\sample_in_window[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BF"
    )
        port map (
      I0 => configure,
      I1 => s_axi_aresetn,
      I2 => \faults_reg[0]_1\(0),
      O => \sample_in_window[9]_i_1_n_0\
    );
\sample_in_window[9]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"58888888"
    )
        port map (
      I0 => \sample_in_window_reg_n_0_[9]\,
      I1 => \sample_in_window[9]_i_3_n_0\,
      I2 => \sample_in_window_reg_n_0_[8]\,
      I3 => \sample_in_window_reg_n_0_[7]\,
      I4 => \sample_in_window[9]_i_4_n_0\,
      O => sample_in_window(9)
    );
\sample_in_window[9]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFEA"
    )
        port map (
      I0 => \sample_in_window[0]_i_2_n_0\,
      I1 => \sample_in_window_reg_n_0_[4]\,
      I2 => \sample_in_window_reg_n_0_[3]\,
      I3 => \sample_in_window_reg_n_0_[2]\,
      I4 => \sample_in_window_reg_n_0_[0]\,
      I5 => \sample_in_window_reg_n_0_[1]\,
      O => \sample_in_window[9]_i_3_n_0\
    );
\sample_in_window[9]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"80000000"
    )
        port map (
      I0 => \sample_in_window_reg_n_0_[5]\,
      I1 => \sample_in_window_reg_n_0_[3]\,
      I2 => \sample_in_window_reg_n_0_[4]\,
      I3 => \sample_in_window[6]_i_2_n_0\,
      I4 => \sample_in_window_reg_n_0_[6]\,
      O => \sample_in_window[9]_i_4_n_0\
    );
\sample_in_window_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => sample_in_window(0),
      Q => \sample_in_window_reg_n_0_[0]\,
      R => \sample_in_window[9]_i_1_n_0\
    );
\sample_in_window_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => sample_in_window(1),
      Q => \sample_in_window_reg_n_0_[1]\,
      R => \sample_in_window[9]_i_1_n_0\
    );
\sample_in_window_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => sample_in_window(2),
      Q => \sample_in_window_reg_n_0_[2]\,
      R => \sample_in_window[9]_i_1_n_0\
    );
\sample_in_window_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => sample_in_window(3),
      Q => \sample_in_window_reg_n_0_[3]\,
      R => \sample_in_window[9]_i_1_n_0\
    );
\sample_in_window_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => sample_in_window(4),
      Q => \sample_in_window_reg_n_0_[4]\,
      R => \sample_in_window[9]_i_1_n_0\
    );
\sample_in_window_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => sample_in_window(5),
      Q => \sample_in_window_reg_n_0_[5]\,
      R => \sample_in_window[9]_i_1_n_0\
    );
\sample_in_window_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => sample_in_window(6),
      Q => \sample_in_window_reg_n_0_[6]\,
      R => \sample_in_window[9]_i_1_n_0\
    );
\sample_in_window_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => sample_in_window(7),
      Q => \sample_in_window_reg_n_0_[7]\,
      R => \sample_in_window[9]_i_1_n_0\
    );
\sample_in_window_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => sample_in_window(8),
      Q => \sample_in_window_reg_n_0_[8]\,
      R => \sample_in_window[9]_i_1_n_0\
    );
\sample_in_window_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \clipped_count[15]_i_2_n_0\,
      D => sample_in_window(9),
      Q => \sample_in_window_reg_n_0_[9]\,
      R => \sample_in_window[9]_i_1_n_0\
    );
\scaled_latched_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(2),
      Q => scaled_latched(10),
      R => dc_level0
    );
\scaled_latched_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(3),
      Q => scaled_latched(11),
      R => dc_level0
    );
\scaled_latched_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(4),
      Q => scaled_latched(12),
      R => dc_level0
    );
\scaled_latched_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(5),
      Q => scaled_latched(13),
      R => dc_level0
    );
\scaled_latched_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(6),
      Q => scaled_latched(14),
      R => dc_level0
    );
\scaled_latched_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(7),
      Q => scaled_latched(15),
      R => dc_level0
    );
\scaled_latched_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(8),
      Q => scaled_latched(16),
      R => dc_level0
    );
\scaled_latched_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(9),
      Q => scaled_latched(17),
      R => dc_level0
    );
\scaled_latched_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(10),
      Q => scaled_latched(18),
      R => dc_level0
    );
\scaled_latched_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(11),
      Q => scaled_latched(19),
      R => dc_level0
    );
\scaled_latched_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(12),
      Q => scaled_latched(20),
      R => dc_level0
    );
\scaled_latched_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(13),
      Q => scaled_latched(21),
      R => dc_level0
    );
\scaled_latched_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(14),
      Q => scaled_latched(22),
      R => dc_level0
    );
\scaled_latched_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(15),
      Q => scaled_latched(24),
      R => dc_level0
    );
\scaled_latched_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(0),
      Q => scaled_latched(8),
      R => dc_level0
    );
\scaled_latched_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => scaled_latched0,
      D => D(1),
      Q => scaled_latched(9),
      R => dc_level0
    );
\snapshot[0][2]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \event_age[31]_i_1_n_0\,
      O => \faults_reg[0]_0\(0)
    );
snapshot_valid_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AABAAA8A"
    )
        port map (
      I0 => snapshot_valid,
      I1 => snapshot_valid_reg_0,
      I2 => snapshot_valid_reg_1,
      I3 => snapshot_valid_reg_2,
      I4 => snapshot_valid_reg_3(0),
      I5 => dc_level0,
      O => snapshot_valid_reg
    );
\soft_count[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"4F"
    )
        port map (
      I0 => \soft_count_reg_n_0_[0]\,
      I1 => p_1_in,
      I2 => \^status\(3),
      O => \soft_count[0]_i_1_n_0\
    );
\soft_count[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2800"
    )
        port map (
      I0 => \^status\(3),
      I1 => \soft_count_reg_n_0_[1]\,
      I2 => \soft_count_reg_n_0_[0]\,
      I3 => p_1_in,
      O => \soft_count[1]_i_1_n_0\
    );
\soft_count[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"28880000"
    )
        port map (
      I0 => \^status\(3),
      I1 => \soft_count_reg_n_0_[2]\,
      I2 => \soft_count_reg_n_0_[0]\,
      I3 => \soft_count_reg_n_0_[1]\,
      I4 => p_1_in,
      O => \soft_count[2]_i_1_n_0\
    );
\soft_count_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => soft_count(0),
      D => \soft_count[0]_i_1_n_0\,
      Q => \soft_count_reg_n_0_[0]\,
      R => \sample_in_window[9]_i_1_n_0\
    );
\soft_count_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => soft_count(0),
      D => \soft_count[1]_i_1_n_0\,
      Q => \soft_count_reg_n_0_[1]\,
      R => \sample_in_window[9]_i_1_n_0\
    );
\soft_count_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => soft_count(0),
      D => \soft_count[2]_i_1_n_0\,
      Q => \soft_count_reg_n_0_[2]\,
      R => \sample_in_window[9]_i_1_n_0\
    );
state2_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => state2_carry_n_0,
      CO(2) => state2_carry_n_1,
      CO(1) => state2_carry_n_2,
      CO(0) => state2_carry_n_3,
      CYINIT => '1',
      DI(3) => state2_carry_i_1_n_0,
      DI(2) => state2_carry_i_2_n_0,
      DI(1) => state2_carry_i_3_n_0,
      DI(0) => state2_carry_i_4_n_0,
      O(3 downto 0) => NLW_state2_carry_O_UNCONNECTED(3 downto 0),
      S(3) => state2_carry_i_5_n_0,
      S(2) => state2_carry_i_6_n_0,
      S(1) => state2_carry_i_7_n_0,
      S(0) => state2_carry_i_8_n_0
    );
\state2_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => state2_carry_n_0,
      CO(3) => \state2_carry__0_n_0\,
      CO(2) => \state2_carry__0_n_1\,
      CO(1) => \state2_carry__0_n_2\,
      CO(0) => \state2_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \state2_carry__0_i_1_n_0\,
      DI(2) => \state2_carry__0_i_2_n_0\,
      DI(1) => \state2_carry__0_i_3_n_0\,
      DI(0) => \state2_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_state2_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \state2_carry__0_i_5_n_0\,
      S(2) => \state2_carry__0_i_6_n_0\,
      S(1) => \state2_carry__0_i_7_n_0\,
      S(0) => \state2_carry__0_i_8_n_0\
    );
\state2_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(15),
      I1 => \quiet_carry__2_0\(15),
      I2 => \quiet_carry__2_0\(14),
      I3 => \faults[7]_i_10_0\(14),
      O => \state2_carry__0_i_1_n_0\
    );
\state2_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(13),
      I1 => \quiet_carry__2_0\(13),
      I2 => \quiet_carry__2_0\(12),
      I3 => \faults[7]_i_10_0\(12),
      O => \state2_carry__0_i_2_n_0\
    );
\state2_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(11),
      I1 => \quiet_carry__2_0\(11),
      I2 => \quiet_carry__2_0\(10),
      I3 => \faults[7]_i_10_0\(10),
      O => \state2_carry__0_i_3_n_0\
    );
\state2_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(9),
      I1 => \quiet_carry__2_0\(9),
      I2 => \quiet_carry__2_0\(8),
      I3 => \faults[7]_i_10_0\(8),
      O => \state2_carry__0_i_4_n_0\
    );
\state2_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(15),
      I1 => \faults[7]_i_10_0\(15),
      I2 => \quiet_carry__2_0\(14),
      I3 => \faults[7]_i_10_0\(14),
      O => \state2_carry__0_i_5_n_0\
    );
\state2_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(13),
      I1 => \faults[7]_i_10_0\(13),
      I2 => \quiet_carry__2_0\(12),
      I3 => \faults[7]_i_10_0\(12),
      O => \state2_carry__0_i_6_n_0\
    );
\state2_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(11),
      I1 => \faults[7]_i_10_0\(11),
      I2 => \quiet_carry__2_0\(10),
      I3 => \faults[7]_i_10_0\(10),
      O => \state2_carry__0_i_7_n_0\
    );
\state2_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(9),
      I1 => \faults[7]_i_10_0\(9),
      I2 => \quiet_carry__2_0\(8),
      I3 => \faults[7]_i_10_0\(8),
      O => \state2_carry__0_i_8_n_0\
    );
\state2_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \state2_carry__0_n_0\,
      CO(3) => \state2_carry__1_n_0\,
      CO(2) => \state2_carry__1_n_1\,
      CO(1) => \state2_carry__1_n_2\,
      CO(0) => \state2_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \state2_carry__1_i_1_n_0\,
      DI(2) => \state2_carry__1_i_2_n_0\,
      DI(1) => \state2_carry__1_i_3_n_0\,
      DI(0) => \state2_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_state2_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \state2_carry__1_i_5_n_0\,
      S(2) => \state2_carry__1_i_6_n_0\,
      S(1) => \state2_carry__1_i_7_n_0\,
      S(0) => \state2_carry__1_i_8_n_0\
    );
\state2_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(23),
      I1 => \quiet_carry__2_0\(23),
      I2 => \quiet_carry__2_0\(22),
      I3 => \faults[7]_i_10_0\(22),
      O => \state2_carry__1_i_1_n_0\
    );
\state2_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(21),
      I1 => \quiet_carry__2_0\(21),
      I2 => \quiet_carry__2_0\(20),
      I3 => \faults[7]_i_10_0\(20),
      O => \state2_carry__1_i_2_n_0\
    );
\state2_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(19),
      I1 => \quiet_carry__2_0\(19),
      I2 => \quiet_carry__2_0\(18),
      I3 => \faults[7]_i_10_0\(18),
      O => \state2_carry__1_i_3_n_0\
    );
\state2_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(17),
      I1 => \quiet_carry__2_0\(17),
      I2 => \quiet_carry__2_0\(16),
      I3 => \faults[7]_i_10_0\(16),
      O => \state2_carry__1_i_4_n_0\
    );
\state2_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(23),
      I1 => \faults[7]_i_10_0\(23),
      I2 => \quiet_carry__2_0\(22),
      I3 => \faults[7]_i_10_0\(22),
      O => \state2_carry__1_i_5_n_0\
    );
\state2_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(21),
      I1 => \faults[7]_i_10_0\(21),
      I2 => \quiet_carry__2_0\(20),
      I3 => \faults[7]_i_10_0\(20),
      O => \state2_carry__1_i_6_n_0\
    );
\state2_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(19),
      I1 => \faults[7]_i_10_0\(19),
      I2 => \quiet_carry__2_0\(18),
      I3 => \faults[7]_i_10_0\(18),
      O => \state2_carry__1_i_7_n_0\
    );
\state2_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(17),
      I1 => \faults[7]_i_10_0\(17),
      I2 => \quiet_carry__2_0\(16),
      I3 => \faults[7]_i_10_0\(16),
      O => \state2_carry__1_i_8_n_0\
    );
\state2_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \state2_carry__1_n_0\,
      CO(3) => state20_in,
      CO(2) => \state2_carry__2_n_1\,
      CO(1) => \state2_carry__2_n_2\,
      CO(0) => \state2_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \state2_carry__2_i_1_n_0\,
      DI(2) => \state2_carry__2_i_2_n_0\,
      DI(1) => \state2_carry__2_i_3_n_0\,
      DI(0) => \state2_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_state2_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \state2_carry__2_i_5_n_0\,
      S(2) => \state2_carry__2_i_6_n_0\,
      S(1) => \state2_carry__2_i_7_n_0\,
      S(0) => \state2_carry__2_i_8_n_0\
    );
\state2_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(31),
      I1 => \quiet_carry__2_0\(31),
      I2 => \quiet_carry__2_0\(30),
      I3 => \faults[7]_i_10_0\(30),
      O => \state2_carry__2_i_1_n_0\
    );
\state2_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(29),
      I1 => \quiet_carry__2_0\(29),
      I2 => \quiet_carry__2_0\(28),
      I3 => \faults[7]_i_10_0\(28),
      O => \state2_carry__2_i_2_n_0\
    );
\state2_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(27),
      I1 => \quiet_carry__2_0\(27),
      I2 => \quiet_carry__2_0\(26),
      I3 => \faults[7]_i_10_0\(26),
      O => \state2_carry__2_i_3_n_0\
    );
\state2_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(25),
      I1 => \quiet_carry__2_0\(25),
      I2 => \quiet_carry__2_0\(24),
      I3 => \faults[7]_i_10_0\(24),
      O => \state2_carry__2_i_4_n_0\
    );
\state2_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(31),
      I1 => \faults[7]_i_10_0\(31),
      I2 => \quiet_carry__2_0\(30),
      I3 => \faults[7]_i_10_0\(30),
      O => \state2_carry__2_i_5_n_0\
    );
\state2_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(29),
      I1 => \faults[7]_i_10_0\(29),
      I2 => \quiet_carry__2_0\(28),
      I3 => \faults[7]_i_10_0\(28),
      O => \state2_carry__2_i_6_n_0\
    );
\state2_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(27),
      I1 => \faults[7]_i_10_0\(27),
      I2 => \quiet_carry__2_0\(26),
      I3 => \faults[7]_i_10_0\(26),
      O => \state2_carry__2_i_7_n_0\
    );
\state2_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(25),
      I1 => \faults[7]_i_10_0\(25),
      I2 => \quiet_carry__2_0\(24),
      I3 => \faults[7]_i_10_0\(24),
      O => \state2_carry__2_i_8_n_0\
    );
state2_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(7),
      I1 => \quiet_carry__2_0\(7),
      I2 => \quiet_carry__2_0\(6),
      I3 => \faults[7]_i_10_0\(6),
      O => state2_carry_i_1_n_0
    );
state2_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(5),
      I1 => \quiet_carry__2_0\(5),
      I2 => \quiet_carry__2_0\(4),
      I3 => \faults[7]_i_10_0\(4),
      O => state2_carry_i_2_n_0
    );
state2_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(3),
      I1 => \quiet_carry__2_0\(3),
      I2 => \quiet_carry__2_0\(2),
      I3 => \faults[7]_i_10_0\(2),
      O => state2_carry_i_3_n_0
    );
state2_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \faults[7]_i_10_0\(1),
      I1 => \quiet_carry__2_0\(1),
      I2 => \quiet_carry__2_0\(0),
      I3 => \faults[7]_i_10_0\(0),
      O => state2_carry_i_4_n_0
    );
state2_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(7),
      I1 => \faults[7]_i_10_0\(7),
      I2 => \quiet_carry__2_0\(6),
      I3 => \faults[7]_i_10_0\(6),
      O => state2_carry_i_5_n_0
    );
state2_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(5),
      I1 => \faults[7]_i_10_0\(5),
      I2 => \quiet_carry__2_0\(4),
      I3 => \faults[7]_i_10_0\(4),
      O => state2_carry_i_6_n_0
    );
state2_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(3),
      I1 => \faults[7]_i_10_0\(3),
      I2 => \quiet_carry__2_0\(2),
      I3 => \faults[7]_i_10_0\(2),
      O => state2_carry_i_7_n_0
    );
state2_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \quiet_carry__2_0\(1),
      I1 => \faults[7]_i_10_0\(1),
      I2 => \quiet_carry__2_0\(0),
      I3 => \faults[7]_i_10_0\(0),
      O => state2_carry_i_8_n_0
    );
state3_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => state3_carry_n_0,
      CO(2) => state3_carry_n_1,
      CO(1) => state3_carry_n_2,
      CO(0) => state3_carry_n_3,
      CYINIT => '1',
      DI(3) => state3_carry_i_1_n_0,
      DI(2) => state3_carry_i_2_n_0,
      DI(1) => state3_carry_i_3_n_0,
      DI(0) => state3_carry_i_4_n_0,
      O(3 downto 0) => NLW_state3_carry_O_UNCONNECTED(3 downto 0),
      S(3) => state3_carry_i_5_n_0,
      S(2) => state3_carry_i_6_n_0,
      S(1) => state3_carry_i_7_n_0,
      S(0) => state3_carry_i_8_n_0
    );
\state3_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => state3_carry_n_0,
      CO(3) => \state3_carry__0_n_0\,
      CO(2) => \state3_carry__0_n_1\,
      CO(1) => \state3_carry__0_n_2\,
      CO(0) => \state3_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \state3_carry__0_i_1_n_0\,
      DI(2) => \state3_carry__0_i_2_n_0\,
      DI(1) => \state3_carry__0_i_3_n_0\,
      DI(0) => \state3_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_state3_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \state3_carry__0_i_5_n_0\,
      S(2) => \state3_carry__0_i_6_n_0\,
      S(1) => \state3_carry__0_i_7_n_0\,
      S(0) => \state3_carry__0_i_8_n_0\
    );
\state3_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(15),
      I1 => \above_loud_carry__2_0\(15),
      I2 => \faults[7]_i_10_0\(14),
      I3 => \above_loud_carry__2_0\(14),
      O => \state3_carry__0_i_1_n_0\
    );
\state3_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(13),
      I1 => \above_loud_carry__2_0\(13),
      I2 => \faults[7]_i_10_0\(12),
      I3 => \above_loud_carry__2_0\(12),
      O => \state3_carry__0_i_2_n_0\
    );
\state3_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(11),
      I1 => \above_loud_carry__2_0\(11),
      I2 => \faults[7]_i_10_0\(10),
      I3 => \above_loud_carry__2_0\(10),
      O => \state3_carry__0_i_3_n_0\
    );
\state3_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(9),
      I1 => \above_loud_carry__2_0\(9),
      I2 => \faults[7]_i_10_0\(8),
      I3 => \above_loud_carry__2_0\(8),
      O => \state3_carry__0_i_4_n_0\
    );
\state3_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(15),
      I1 => \faults[7]_i_10_0\(15),
      I2 => \above_loud_carry__2_0\(14),
      I3 => \faults[7]_i_10_0\(14),
      O => \state3_carry__0_i_5_n_0\
    );
\state3_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(13),
      I1 => \faults[7]_i_10_0\(13),
      I2 => \above_loud_carry__2_0\(12),
      I3 => \faults[7]_i_10_0\(12),
      O => \state3_carry__0_i_6_n_0\
    );
\state3_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(11),
      I1 => \faults[7]_i_10_0\(11),
      I2 => \above_loud_carry__2_0\(10),
      I3 => \faults[7]_i_10_0\(10),
      O => \state3_carry__0_i_7_n_0\
    );
\state3_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(9),
      I1 => \faults[7]_i_10_0\(9),
      I2 => \above_loud_carry__2_0\(8),
      I3 => \faults[7]_i_10_0\(8),
      O => \state3_carry__0_i_8_n_0\
    );
\state3_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \state3_carry__0_n_0\,
      CO(3) => \state3_carry__1_n_0\,
      CO(2) => \state3_carry__1_n_1\,
      CO(1) => \state3_carry__1_n_2\,
      CO(0) => \state3_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \state3_carry__1_i_1_n_0\,
      DI(2) => \state3_carry__1_i_2_n_0\,
      DI(1) => \state3_carry__1_i_3_n_0\,
      DI(0) => \state3_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_state3_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \state3_carry__1_i_5_n_0\,
      S(2) => \state3_carry__1_i_6_n_0\,
      S(1) => \state3_carry__1_i_7_n_0\,
      S(0) => \state3_carry__1_i_8_n_0\
    );
\state3_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(23),
      I1 => \above_loud_carry__2_0\(23),
      I2 => \faults[7]_i_10_0\(22),
      I3 => \above_loud_carry__2_0\(22),
      O => \state3_carry__1_i_1_n_0\
    );
\state3_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(21),
      I1 => \above_loud_carry__2_0\(21),
      I2 => \faults[7]_i_10_0\(20),
      I3 => \above_loud_carry__2_0\(20),
      O => \state3_carry__1_i_2_n_0\
    );
\state3_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(19),
      I1 => \above_loud_carry__2_0\(19),
      I2 => \faults[7]_i_10_0\(18),
      I3 => \above_loud_carry__2_0\(18),
      O => \state3_carry__1_i_3_n_0\
    );
\state3_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(17),
      I1 => \above_loud_carry__2_0\(17),
      I2 => \faults[7]_i_10_0\(16),
      I3 => \above_loud_carry__2_0\(16),
      O => \state3_carry__1_i_4_n_0\
    );
\state3_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(23),
      I1 => \faults[7]_i_10_0\(23),
      I2 => \above_loud_carry__2_0\(22),
      I3 => \faults[7]_i_10_0\(22),
      O => \state3_carry__1_i_5_n_0\
    );
\state3_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(21),
      I1 => \faults[7]_i_10_0\(21),
      I2 => \above_loud_carry__2_0\(20),
      I3 => \faults[7]_i_10_0\(20),
      O => \state3_carry__1_i_6_n_0\
    );
\state3_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(19),
      I1 => \faults[7]_i_10_0\(19),
      I2 => \above_loud_carry__2_0\(18),
      I3 => \faults[7]_i_10_0\(18),
      O => \state3_carry__1_i_7_n_0\
    );
\state3_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(17),
      I1 => \faults[7]_i_10_0\(17),
      I2 => \above_loud_carry__2_0\(16),
      I3 => \faults[7]_i_10_0\(16),
      O => \state3_carry__1_i_8_n_0\
    );
\state3_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \state3_carry__1_n_0\,
      CO(3) => state3,
      CO(2) => \state3_carry__2_n_1\,
      CO(1) => \state3_carry__2_n_2\,
      CO(0) => \state3_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \state3_carry__2_i_1_n_0\,
      DI(2) => \state3_carry__2_i_2_n_0\,
      DI(1) => \state3_carry__2_i_3_n_0\,
      DI(0) => \state3_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_state3_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \state3_carry__2_i_5_n_0\,
      S(2) => \state3_carry__2_i_6_n_0\,
      S(1) => \state3_carry__2_i_7_n_0\,
      S(0) => \state3_carry__2_i_8_n_0\
    );
\state3_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(31),
      I1 => \above_loud_carry__2_0\(31),
      I2 => \faults[7]_i_10_0\(30),
      I3 => \above_loud_carry__2_0\(30),
      O => \state3_carry__2_i_1_n_0\
    );
\state3_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(29),
      I1 => \above_loud_carry__2_0\(29),
      I2 => \faults[7]_i_10_0\(28),
      I3 => \above_loud_carry__2_0\(28),
      O => \state3_carry__2_i_2_n_0\
    );
\state3_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(27),
      I1 => \above_loud_carry__2_0\(27),
      I2 => \faults[7]_i_10_0\(26),
      I3 => \above_loud_carry__2_0\(26),
      O => \state3_carry__2_i_3_n_0\
    );
\state3_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(25),
      I1 => \above_loud_carry__2_0\(25),
      I2 => \faults[7]_i_10_0\(24),
      I3 => \above_loud_carry__2_0\(24),
      O => \state3_carry__2_i_4_n_0\
    );
\state3_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(31),
      I1 => \faults[7]_i_10_0\(31),
      I2 => \above_loud_carry__2_0\(30),
      I3 => \faults[7]_i_10_0\(30),
      O => \state3_carry__2_i_5_n_0\
    );
\state3_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(29),
      I1 => \faults[7]_i_10_0\(29),
      I2 => \above_loud_carry__2_0\(28),
      I3 => \faults[7]_i_10_0\(28),
      O => \state3_carry__2_i_6_n_0\
    );
\state3_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(27),
      I1 => \faults[7]_i_10_0\(27),
      I2 => \above_loud_carry__2_0\(26),
      I3 => \faults[7]_i_10_0\(26),
      O => \state3_carry__2_i_7_n_0\
    );
\state3_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(25),
      I1 => \faults[7]_i_10_0\(25),
      I2 => \above_loud_carry__2_0\(24),
      I3 => \faults[7]_i_10_0\(24),
      O => \state3_carry__2_i_8_n_0\
    );
state3_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(7),
      I1 => \above_loud_carry__2_0\(7),
      I2 => \faults[7]_i_10_0\(6),
      I3 => \above_loud_carry__2_0\(6),
      O => state3_carry_i_1_n_0
    );
state3_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(5),
      I1 => \above_loud_carry__2_0\(5),
      I2 => \faults[7]_i_10_0\(4),
      I3 => \above_loud_carry__2_0\(4),
      O => state3_carry_i_2_n_0
    );
state3_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(3),
      I1 => \above_loud_carry__2_0\(3),
      I2 => \faults[7]_i_10_0\(2),
      I3 => \above_loud_carry__2_0\(2),
      O => state3_carry_i_3_n_0
    );
state3_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \faults[7]_i_10_0\(1),
      I1 => \above_loud_carry__2_0\(1),
      I2 => \faults[7]_i_10_0\(0),
      I3 => \above_loud_carry__2_0\(0),
      O => state3_carry_i_4_n_0
    );
state3_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(7),
      I1 => \faults[7]_i_10_0\(7),
      I2 => \above_loud_carry__2_0\(6),
      I3 => \faults[7]_i_10_0\(6),
      O => state3_carry_i_5_n_0
    );
state3_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(5),
      I1 => \faults[7]_i_10_0\(5),
      I2 => \above_loud_carry__2_0\(4),
      I3 => \faults[7]_i_10_0\(4),
      O => state3_carry_i_6_n_0
    );
state3_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(3),
      I1 => \faults[7]_i_10_0\(3),
      I2 => \above_loud_carry__2_0\(2),
      I3 => \faults[7]_i_10_0\(2),
      O => state3_carry_i_7_n_0
    );
state3_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \above_loud_carry__2_0\(1),
      I1 => \faults[7]_i_10_0\(1),
      I2 => \above_loud_carry__2_0\(0),
      I3 => \faults[7]_i_10_0\(0),
      O => state3_carry_i_8_n_0
    );
\state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"02FF0300"
    )
        port map (
      I0 => \^status\(3),
      I1 => configure,
      I2 => \^status\(4),
      I3 => \state[2]_i_4_n_0\,
      I4 => \^status\(2),
      O => \state[0]_i_1_n_0\
    );
\state[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"BFFFBFBF"
    )
        port map (
      I0 => configure,
      I1 => s_axi_aresetn,
      I2 => \faults_reg[0]_1\(0),
      I3 => \faults[7]_i_5_n_0\,
      I4 => \event_age[31]_i_1_n_0\,
      O => \state[1]_i_1_n_0\
    );
\state[1]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01FF0200"
    )
        port map (
      I0 => \^status\(2),
      I1 => configure,
      I2 => \^status\(4),
      I3 => \state[2]_i_4_n_0\,
      I4 => \^status\(3),
      O => \state[1]_i_2_n_0\
    );
\state[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2222F2FF22220200"
    )
        port map (
      I0 => \state[2]_i_2_n_0\,
      I1 => \state[2]_i_3_n_0\,
      I2 => \faults[7]_i_5_n_0\,
      I3 => \event_age[31]_i_1_n_0\,
      I4 => \state[2]_i_4_n_0\,
      I5 => \^status\(4),
      O => \state[2]_i_1_n_0\
    );
\state[2]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \faults[7]_i_4_n_0\,
      I1 => configure,
      I2 => \faults_reg[0]_1\(0),
      O => \state[2]_i_2_n_0\
    );
\state[2]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000080000000000"
    )
        port map (
      I0 => \faults[5]_i_2_n_0\,
      I1 => \faults[5]_i_3_n_0\,
      I2 => \faults[7]_i_11_n_0\,
      I3 => \faults[6]_i_3_n_0\,
      I4 => \^status\(4),
      I5 => \faults[6]_i_6_n_0\,
      O => \state[2]_i_3_n_0\
    );
\state[2]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAFFFFAAA8FFFF"
    )
        port map (
      I0 => \state[2]_i_5_n_0\,
      I1 => \state[2]_i_6_n_0\,
      I2 => \state[2]_i_7_n_0\,
      I3 => \^status\(4),
      I4 => \faults[6]_i_3_n_0\,
      I5 => \state[2]_i_8_n_0\,
      O => \state[2]_i_4_n_0\
    );
\state[2]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \clipped_count[15]_i_4_n_0\,
      I1 => \clipped_count[15]_i_2_n_0\,
      O => \state[2]_i_5_n_0\
    );
\state[2]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444444444440040"
    )
        port map (
      I0 => \^status\(2),
      I1 => \^status\(3),
      I2 => above_loud,
      I3 => \state[2]_i_9_n_0\,
      I4 => candidate_count(1),
      I5 => candidate_count(2),
      O => \state[2]_i_6_n_0\
    );
\state[2]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"25000000"
    )
        port map (
      I0 => \^status\(3),
      I1 => \^status\(0),
      I2 => \^status\(2),
      I3 => \quiet_count_reg_n_0_[2]\,
      I4 => quiet,
      O => \state[2]_i_7_n_0\
    );
\state[2]_i_8\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => p_1_in,
      I1 => \^status\(2),
      I2 => \^status\(3),
      O => \state[2]_i_8_n_0\
    );
\state[2]_i_9\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => loud_count(1),
      I1 => loud_count(0),
      I2 => loud_count(2),
      O => \state[2]_i_9_n_0\
    );
\state_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \state[0]_i_1_n_0\,
      Q => \^status\(2),
      R => \state[1]_i_1_n_0\
    );
\state_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \state[1]_i_2_n_0\,
      Q => \^status\(3),
      R => \state[1]_i_1_n_0\
    );
\state_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \state[2]_i_1_n_0\,
      Q => \^status\(4),
      R => \^s_axi_aresetn_0\
    );
\window_count[0]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^window_count_reg[31]_0\(0),
      O => \window_count[0]_i_2_n_0\
    );
\window_count_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[0]_i_1_n_7\,
      Q => \^window_count_reg[31]_0\(0),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[0]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \window_count_reg[0]_i_1_n_0\,
      CO(2) => \window_count_reg[0]_i_1_n_1\,
      CO(1) => \window_count_reg[0]_i_1_n_2\,
      CO(0) => \window_count_reg[0]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \window_count_reg[0]_i_1_n_4\,
      O(2) => \window_count_reg[0]_i_1_n_5\,
      O(1) => \window_count_reg[0]_i_1_n_6\,
      O(0) => \window_count_reg[0]_i_1_n_7\,
      S(3 downto 1) => \^window_count_reg[31]_0\(3 downto 1),
      S(0) => \window_count[0]_i_2_n_0\
    );
\window_count_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[8]_i_1_n_5\,
      Q => \^window_count_reg[31]_0\(10),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[8]_i_1_n_4\,
      Q => \^window_count_reg[31]_0\(11),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[12]_i_1_n_7\,
      Q => \^window_count_reg[31]_0\(12),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \window_count_reg[8]_i_1_n_0\,
      CO(3) => \window_count_reg[12]_i_1_n_0\,
      CO(2) => \window_count_reg[12]_i_1_n_1\,
      CO(1) => \window_count_reg[12]_i_1_n_2\,
      CO(0) => \window_count_reg[12]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \window_count_reg[12]_i_1_n_4\,
      O(2) => \window_count_reg[12]_i_1_n_5\,
      O(1) => \window_count_reg[12]_i_1_n_6\,
      O(0) => \window_count_reg[12]_i_1_n_7\,
      S(3 downto 0) => \^window_count_reg[31]_0\(15 downto 12)
    );
\window_count_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[12]_i_1_n_6\,
      Q => \^window_count_reg[31]_0\(13),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[12]_i_1_n_5\,
      Q => \^window_count_reg[31]_0\(14),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[12]_i_1_n_4\,
      Q => \^window_count_reg[31]_0\(15),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[16]_i_1_n_7\,
      Q => \^window_count_reg[31]_0\(16),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[16]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \window_count_reg[12]_i_1_n_0\,
      CO(3) => \window_count_reg[16]_i_1_n_0\,
      CO(2) => \window_count_reg[16]_i_1_n_1\,
      CO(1) => \window_count_reg[16]_i_1_n_2\,
      CO(0) => \window_count_reg[16]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \window_count_reg[16]_i_1_n_4\,
      O(2) => \window_count_reg[16]_i_1_n_5\,
      O(1) => \window_count_reg[16]_i_1_n_6\,
      O(0) => \window_count_reg[16]_i_1_n_7\,
      S(3 downto 0) => \^window_count_reg[31]_0\(19 downto 16)
    );
\window_count_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[16]_i_1_n_6\,
      Q => \^window_count_reg[31]_0\(17),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[16]_i_1_n_5\,
      Q => \^window_count_reg[31]_0\(18),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[16]_i_1_n_4\,
      Q => \^window_count_reg[31]_0\(19),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[0]_i_1_n_6\,
      Q => \^window_count_reg[31]_0\(1),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[20]_i_1_n_7\,
      Q => \^window_count_reg[31]_0\(20),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[20]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \window_count_reg[16]_i_1_n_0\,
      CO(3) => \window_count_reg[20]_i_1_n_0\,
      CO(2) => \window_count_reg[20]_i_1_n_1\,
      CO(1) => \window_count_reg[20]_i_1_n_2\,
      CO(0) => \window_count_reg[20]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \window_count_reg[20]_i_1_n_4\,
      O(2) => \window_count_reg[20]_i_1_n_5\,
      O(1) => \window_count_reg[20]_i_1_n_6\,
      O(0) => \window_count_reg[20]_i_1_n_7\,
      S(3 downto 0) => \^window_count_reg[31]_0\(23 downto 20)
    );
\window_count_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[20]_i_1_n_6\,
      Q => \^window_count_reg[31]_0\(21),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[20]_i_1_n_5\,
      Q => \^window_count_reg[31]_0\(22),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[20]_i_1_n_4\,
      Q => \^window_count_reg[31]_0\(23),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[24]_i_1_n_7\,
      Q => \^window_count_reg[31]_0\(24),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[24]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \window_count_reg[20]_i_1_n_0\,
      CO(3) => \window_count_reg[24]_i_1_n_0\,
      CO(2) => \window_count_reg[24]_i_1_n_1\,
      CO(1) => \window_count_reg[24]_i_1_n_2\,
      CO(0) => \window_count_reg[24]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \window_count_reg[24]_i_1_n_4\,
      O(2) => \window_count_reg[24]_i_1_n_5\,
      O(1) => \window_count_reg[24]_i_1_n_6\,
      O(0) => \window_count_reg[24]_i_1_n_7\,
      S(3 downto 0) => \^window_count_reg[31]_0\(27 downto 24)
    );
\window_count_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[24]_i_1_n_6\,
      Q => \^window_count_reg[31]_0\(25),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[24]_i_1_n_5\,
      Q => \^window_count_reg[31]_0\(26),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[24]_i_1_n_4\,
      Q => \^window_count_reg[31]_0\(27),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[28]_i_1_n_7\,
      Q => \^window_count_reg[31]_0\(28),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[28]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \window_count_reg[24]_i_1_n_0\,
      CO(3) => \NLW_window_count_reg[28]_i_1_CO_UNCONNECTED\(3),
      CO(2) => \window_count_reg[28]_i_1_n_1\,
      CO(1) => \window_count_reg[28]_i_1_n_2\,
      CO(0) => \window_count_reg[28]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \window_count_reg[28]_i_1_n_4\,
      O(2) => \window_count_reg[28]_i_1_n_5\,
      O(1) => \window_count_reg[28]_i_1_n_6\,
      O(0) => \window_count_reg[28]_i_1_n_7\,
      S(3 downto 0) => \^window_count_reg[31]_0\(31 downto 28)
    );
\window_count_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[28]_i_1_n_6\,
      Q => \^window_count_reg[31]_0\(29),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[0]_i_1_n_5\,
      Q => \^window_count_reg[31]_0\(2),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[28]_i_1_n_5\,
      Q => \^window_count_reg[31]_0\(30),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[28]_i_1_n_4\,
      Q => \^window_count_reg[31]_0\(31),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[0]_i_1_n_4\,
      Q => \^window_count_reg[31]_0\(3),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[4]_i_1_n_7\,
      Q => \^window_count_reg[31]_0\(4),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \window_count_reg[0]_i_1_n_0\,
      CO(3) => \window_count_reg[4]_i_1_n_0\,
      CO(2) => \window_count_reg[4]_i_1_n_1\,
      CO(1) => \window_count_reg[4]_i_1_n_2\,
      CO(0) => \window_count_reg[4]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \window_count_reg[4]_i_1_n_4\,
      O(2) => \window_count_reg[4]_i_1_n_5\,
      O(1) => \window_count_reg[4]_i_1_n_6\,
      O(0) => \window_count_reg[4]_i_1_n_7\,
      S(3 downto 0) => \^window_count_reg[31]_0\(7 downto 4)
    );
\window_count_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[4]_i_1_n_6\,
      Q => \^window_count_reg[31]_0\(5),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[4]_i_1_n_5\,
      Q => \^window_count_reg[31]_0\(6),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[4]_i_1_n_4\,
      Q => \^window_count_reg[31]_0\(7),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[8]_i_1_n_7\,
      Q => \^window_count_reg[31]_0\(8),
      R => \last_sum[31]_i_1_n_0\
    );
\window_count_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \window_count_reg[4]_i_1_n_0\,
      CO(3) => \window_count_reg[8]_i_1_n_0\,
      CO(2) => \window_count_reg[8]_i_1_n_1\,
      CO(1) => \window_count_reg[8]_i_1_n_2\,
      CO(0) => \window_count_reg[8]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \window_count_reg[8]_i_1_n_4\,
      O(2) => \window_count_reg[8]_i_1_n_5\,
      O(1) => \window_count_reg[8]_i_1_n_6\,
      O(0) => \window_count_reg[8]_i_1_n_7\,
      S(3 downto 0) => \^window_count_reg[31]_0\(11 downto 8)
    );
\window_count_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \last_sum[31]_i_2_n_0\,
      D => \window_count_reg[8]_i_1_n_6\,
      Q => \^window_count_reg[31]_0\(9),
      R => \last_sum[31]_i_1_n_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_voice_volume_0_0_voice_volume_i2s_rx is
  port (
    input_fault : out STD_LOGIC;
    pcm_valid : out STD_LOGIC;
    S : out STD_LOGIC_VECTOR ( 3 downto 0 );
    Q : out STD_LOGIC_VECTOR ( 15 downto 0 );
    \pcm_s16_reg[12]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \pcm_s16_reg[14]_0\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \pcm_s16_reg[4]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \pcm_s16_reg[0]_0\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    dc_clipped0 : out STD_LOGIC;
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_aclk : in STD_LOGIC;
    \difference_latched_reg[24]\ : in STD_LOGIC_VECTOR ( 14 downto 0 );
    s_axi_aresetn : in STD_LOGIC;
    O115 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    i2s_sdata : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_voice_volume_0_0_voice_volume_i2s_rx : entity is "voice_volume_i2s_rx";
end c6v_voice_volume_0_0_voice_volume_i2s_rx;

architecture STRUCTURE of c6v_voice_volume_0_0_voice_volume_i2s_rx is
  signal \^q\ : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal bclk_previous : STD_LOGIC;
  signal bclk_sync : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute async_reg : string;
  attribute async_reg of bclk_sync : signal is "true";
  signal channel_i_1_n_0 : STD_LOGIC;
  signal channel_reg_n_0 : STD_LOGIC;
  signal dc_clipped_i_4_n_0 : STD_LOGIC;
  signal dc_clipped_i_5_n_0 : STD_LOGIC;
  signal dc_clipped_i_6_n_0 : STD_LOGIC;
  signal dc_clipped_i_7_n_0 : STD_LOGIC;
  signal dc_clipped_i_8_n_0 : STD_LOGIC;
  signal dc_clipped_i_9_n_0 : STD_LOGIC;
  signal frame_fault1_out : STD_LOGIC;
  signal frame_fault_i_2_n_0 : STD_LOGIC;
  signal frame_fault_i_3_n_0 : STD_LOGIC;
  signal lrclk_sync : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute async_reg of lrclk_sync : signal is "true";
  signal \p_0_in__0\ : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal \pcm_s16[15]_i_1_n_0\ : STD_LOGIC;
  signal pcm_valid_i_1_n_0 : STD_LOGIC;
  signal pcm_valid_i_2_n_0 : STD_LOGIC;
  signal sdata_sync : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute async_reg of sdata_sync : signal is "true";
  signal shift_data : STD_LOGIC_VECTOR ( 14 downto 0 );
  signal \shift_data[14]_i_1_n_0\ : STD_LOGIC;
  signal shift_data_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \slot_index[5]_i_1_n_0\ : STD_LOGIC;
  signal slot_index_reg : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal started : STD_LOGIC;
  signal started_i_1_n_0 : STD_LOGIC;
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \bclk_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \bclk_sync_reg[0]\ : label is "yes";
  attribute ASYNC_REG_boolean of \bclk_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \bclk_sync_reg[1]\ : label is "yes";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of dc_clipped_i_5 : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of dc_clipped_i_8 : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of frame_fault_i_3 : label is "soft_lutpair2";
  attribute ASYNC_REG_boolean of \lrclk_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP of \lrclk_sync_reg[0]\ : label is "yes";
  attribute ASYNC_REG_boolean of \lrclk_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \lrclk_sync_reg[1]\ : label is "yes";
  attribute SOFT_HLUTNM of pcm_valid_i_2 : label is "soft_lutpair0";
  attribute ASYNC_REG_boolean of \sdata_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP of \sdata_sync_reg[0]\ : label is "yes";
  attribute ASYNC_REG_boolean of \sdata_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \sdata_sync_reg[1]\ : label is "yes";
  attribute SOFT_HLUTNM of \slot_index[0]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \slot_index[1]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \slot_index[2]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \slot_index[3]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \slot_index[4]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \slot_index[5]_i_2\ : label is "soft_lutpair1";
begin
  Q(15 downto 0) <= \^q\(15 downto 0);
bclk_previous_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => bclk_sync(1),
      Q => bclk_previous,
      R => SR(0)
    );
\bclk_sync_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => O115(0),
      Q => bclk_sync(0),
      R => SR(0)
    );
\bclk_sync_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => bclk_sync(0),
      Q => bclk_sync(1),
      R => SR(0)
    );
channel_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AACA"
    )
        port map (
      I0 => channel_reg_n_0,
      I1 => lrclk_sync(1),
      I2 => bclk_sync(1),
      I3 => bclk_previous,
      O => channel_i_1_n_0
    );
channel_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => channel_i_1_n_0,
      Q => channel_reg_n_0,
      R => SR(0)
    );
dc_clipped_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF80808080808080"
    )
        port map (
      I0 => dc_clipped_i_4_n_0,
      I1 => dc_clipped_i_5_n_0,
      I2 => dc_clipped_i_6_n_0,
      I3 => dc_clipped_i_7_n_0,
      I4 => dc_clipped_i_8_n_0,
      I5 => dc_clipped_i_9_n_0,
      O => dc_clipped0
    );
dc_clipped_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => \^q\(6),
      I1 => \^q\(7),
      I2 => \^q\(4),
      I3 => \^q\(5),
      I4 => \^q\(9),
      I5 => \^q\(8),
      O => dc_clipped_i_4_n_0
    );
dc_clipped_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => \^q\(1),
      I1 => \^q\(0),
      I2 => \^q\(3),
      I3 => \^q\(2),
      O => dc_clipped_i_5_n_0
    );
dc_clipped_i_6: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => \^q\(12),
      I1 => \^q\(13),
      I2 => \^q\(10),
      I3 => \^q\(11),
      I4 => \^q\(14),
      I5 => \^q\(15),
      O => dc_clipped_i_6_n_0
    );
dc_clipped_i_7: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => \^q\(6),
      I1 => \^q\(7),
      I2 => \^q\(4),
      I3 => \^q\(5),
      I4 => \^q\(9),
      I5 => \^q\(8),
      O => dc_clipped_i_7_n_0
    );
dc_clipped_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => \^q\(1),
      I1 => \^q\(0),
      I2 => \^q\(3),
      I3 => \^q\(2),
      O => dc_clipped_i_8_n_0
    );
dc_clipped_i_9: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000800000000000"
    )
        port map (
      I0 => \^q\(12),
      I1 => \^q\(13),
      I2 => \^q\(10),
      I3 => \^q\(11),
      I4 => \^q\(15),
      I5 => \^q\(14),
      O => dc_clipped_i_9_n_0
    );
\dc_difference_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(0),
      I1 => \difference_latched_reg[24]\(0),
      O => \pcm_s16_reg[0]_0\(0)
    );
\dc_difference_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(4),
      I1 => \difference_latched_reg[24]\(4),
      O => \pcm_s16_reg[4]_0\(3)
    );
\dc_difference_carry__1_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(3),
      I1 => \difference_latched_reg[24]\(3),
      O => \pcm_s16_reg[4]_0\(2)
    );
\dc_difference_carry__1_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(2),
      I1 => \difference_latched_reg[24]\(2),
      O => \pcm_s16_reg[4]_0\(1)
    );
\dc_difference_carry__1_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(1),
      I1 => \difference_latched_reg[24]\(1),
      O => \pcm_s16_reg[4]_0\(0)
    );
\dc_difference_carry__2_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(8),
      I1 => \difference_latched_reg[24]\(8),
      O => S(3)
    );
\dc_difference_carry__2_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(7),
      I1 => \difference_latched_reg[24]\(7),
      O => S(2)
    );
\dc_difference_carry__2_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(6),
      I1 => \difference_latched_reg[24]\(6),
      O => S(1)
    );
\dc_difference_carry__2_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(5),
      I1 => \difference_latched_reg[24]\(5),
      O => S(0)
    );
\dc_difference_carry__3_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(12),
      I1 => \difference_latched_reg[24]\(12),
      O => \pcm_s16_reg[12]_0\(3)
    );
\dc_difference_carry__3_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(11),
      I1 => \difference_latched_reg[24]\(11),
      O => \pcm_s16_reg[12]_0\(2)
    );
\dc_difference_carry__3_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(10),
      I1 => \difference_latched_reg[24]\(10),
      O => \pcm_s16_reg[12]_0\(1)
    );
\dc_difference_carry__3_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(9),
      I1 => \difference_latched_reg[24]\(9),
      O => \pcm_s16_reg[12]_0\(0)
    );
\dc_difference_carry__4_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(14),
      I1 => \difference_latched_reg[24]\(14),
      O => \pcm_s16_reg[14]_0\(1)
    );
\dc_difference_carry__4_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^q\(13),
      I1 => \difference_latched_reg[24]\(13),
      O => \pcm_s16_reg[14]_0\(0)
    );
frame_fault_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"20008AAA8AAA2000"
    )
        port map (
      I0 => frame_fault_i_2_n_0,
      I1 => slot_index_reg(5),
      I2 => frame_fault_i_3_n_0,
      I3 => slot_index_reg(4),
      I4 => lrclk_sync(1),
      I5 => channel_reg_n_0,
      O => frame_fault1_out
    );
frame_fault_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => started,
      I1 => bclk_sync(1),
      I2 => bclk_previous,
      O => frame_fault_i_2_n_0
    );
frame_fault_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => slot_index_reg(3),
      I1 => slot_index_reg(0),
      I2 => slot_index_reg(1),
      I3 => slot_index_reg(2),
      O => frame_fault_i_3_n_0
    );
frame_fault_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => frame_fault1_out,
      Q => input_fault,
      R => SR(0)
    );
\lrclk_sync_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => O115(1),
      Q => lrclk_sync(0),
      R => SR(0)
    );
\lrclk_sync_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => lrclk_sync(0),
      Q => lrclk_sync(1),
      R => SR(0)
    );
\pcm_s16[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4000000000000000"
    )
        port map (
      I0 => lrclk_sync(1),
      I1 => shift_data_0(0),
      I2 => slot_index_reg(3),
      I3 => slot_index_reg(0),
      I4 => slot_index_reg(1),
      I5 => slot_index_reg(2),
      O => \pcm_s16[15]_i_1_n_0\
    );
\pcm_s16_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => sdata_sync(1),
      Q => \^q\(0),
      R => SR(0)
    );
\pcm_s16_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(9),
      Q => \^q\(10),
      R => SR(0)
    );
\pcm_s16_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(10),
      Q => \^q\(11),
      R => SR(0)
    );
\pcm_s16_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(11),
      Q => \^q\(12),
      R => SR(0)
    );
\pcm_s16_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(12),
      Q => \^q\(13),
      R => SR(0)
    );
\pcm_s16_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(13),
      Q => \^q\(14),
      R => SR(0)
    );
\pcm_s16_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(14),
      Q => \^q\(15),
      R => SR(0)
    );
\pcm_s16_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(0),
      Q => \^q\(1),
      R => SR(0)
    );
\pcm_s16_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(1),
      Q => \^q\(2),
      R => SR(0)
    );
\pcm_s16_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(2),
      Q => \^q\(3),
      R => SR(0)
    );
\pcm_s16_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(3),
      Q => \^q\(4),
      R => SR(0)
    );
\pcm_s16_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(4),
      Q => \^q\(5),
      R => SR(0)
    );
\pcm_s16_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(5),
      Q => \^q\(6),
      R => SR(0)
    );
\pcm_s16_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(6),
      Q => \^q\(7),
      R => SR(0)
    );
\pcm_s16_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(7),
      Q => \^q\(8),
      R => SR(0)
    );
\pcm_s16_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \pcm_s16[15]_i_1_n_0\,
      D => shift_data(8),
      Q => \^q\(9),
      R => SR(0)
    );
pcm_valid_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FF9F0000"
    )
        port map (
      I0 => channel_reg_n_0,
      I1 => lrclk_sync(1),
      I2 => bclk_sync(1),
      I3 => bclk_previous,
      I4 => s_axi_aresetn,
      I5 => pcm_valid_i_2_n_0,
      O => pcm_valid_i_1_n_0
    );
pcm_valid_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFFFFFF"
    )
        port map (
      I0 => slot_index_reg(2),
      I1 => slot_index_reg(1),
      I2 => slot_index_reg(0),
      I3 => slot_index_reg(3),
      I4 => shift_data_0(0),
      O => pcm_valid_i_2_n_0
    );
pcm_valid_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => pcm_valid_i_1_n_0,
      Q => pcm_valid,
      R => '0'
    );
\sdata_sync_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => i2s_sdata,
      Q => sdata_sync(0),
      R => SR(0)
    );
\sdata_sync_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => sdata_sync(0),
      Q => sdata_sync(1),
      R => SR(0)
    );
\shift_data[14]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0060FFFF"
    )
        port map (
      I0 => channel_reg_n_0,
      I1 => lrclk_sync(1),
      I2 => bclk_sync(1),
      I3 => bclk_previous,
      I4 => s_axi_aresetn,
      O => \shift_data[14]_i_1_n_0\
    );
\shift_data[14]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000040"
    )
        port map (
      I0 => slot_index_reg(5),
      I1 => started,
      I2 => bclk_sync(1),
      I3 => bclk_previous,
      I4 => slot_index_reg(4),
      I5 => channel_reg_n_0,
      O => shift_data_0(0)
    );
\shift_data_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => sdata_sync(1),
      Q => shift_data(0),
      R => \shift_data[14]_i_1_n_0\
    );
\shift_data_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => shift_data(9),
      Q => shift_data(10),
      R => \shift_data[14]_i_1_n_0\
    );
\shift_data_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => shift_data(10),
      Q => shift_data(11),
      R => \shift_data[14]_i_1_n_0\
    );
\shift_data_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => shift_data(11),
      Q => shift_data(12),
      R => \shift_data[14]_i_1_n_0\
    );
\shift_data_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => shift_data(12),
      Q => shift_data(13),
      R => \shift_data[14]_i_1_n_0\
    );
\shift_data_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => shift_data(13),
      Q => shift_data(14),
      R => \shift_data[14]_i_1_n_0\
    );
\shift_data_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => shift_data(0),
      Q => shift_data(1),
      R => \shift_data[14]_i_1_n_0\
    );
\shift_data_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => shift_data(1),
      Q => shift_data(2),
      R => \shift_data[14]_i_1_n_0\
    );
\shift_data_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => shift_data(2),
      Q => shift_data(3),
      R => \shift_data[14]_i_1_n_0\
    );
\shift_data_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => shift_data(3),
      Q => shift_data(4),
      R => \shift_data[14]_i_1_n_0\
    );
\shift_data_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => shift_data(4),
      Q => shift_data(5),
      R => \shift_data[14]_i_1_n_0\
    );
\shift_data_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => shift_data(5),
      Q => shift_data(6),
      R => \shift_data[14]_i_1_n_0\
    );
\shift_data_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => shift_data(6),
      Q => shift_data(7),
      R => \shift_data[14]_i_1_n_0\
    );
\shift_data_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => shift_data(7),
      Q => shift_data(8),
      R => \shift_data[14]_i_1_n_0\
    );
\shift_data_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shift_data_0(0),
      D => shift_data(8),
      Q => shift_data(9),
      R => \shift_data[14]_i_1_n_0\
    );
\slot_index[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => slot_index_reg(0),
      O => \p_0_in__0\(0)
    );
\slot_index[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => slot_index_reg(0),
      I1 => slot_index_reg(1),
      O => \p_0_in__0\(1)
    );
\slot_index[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => slot_index_reg(2),
      I1 => slot_index_reg(1),
      I2 => slot_index_reg(0),
      O => \p_0_in__0\(2)
    );
\slot_index[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => slot_index_reg(3),
      I1 => slot_index_reg(0),
      I2 => slot_index_reg(1),
      I3 => slot_index_reg(2),
      O => \p_0_in__0\(3)
    );
\slot_index[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => slot_index_reg(4),
      I1 => slot_index_reg(2),
      I2 => slot_index_reg(1),
      I3 => slot_index_reg(0),
      I4 => slot_index_reg(3),
      O => \p_0_in__0\(4)
    );
\slot_index[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0040"
    )
        port map (
      I0 => bclk_previous,
      I1 => bclk_sync(1),
      I2 => started,
      I3 => slot_index_reg(5),
      O => \slot_index[5]_i_1_n_0\
    );
\slot_index[5]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"80000000"
    )
        port map (
      I0 => slot_index_reg(3),
      I1 => slot_index_reg(0),
      I2 => slot_index_reg(1),
      I3 => slot_index_reg(2),
      I4 => slot_index_reg(4),
      O => \p_0_in__0\(5)
    );
\slot_index_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \slot_index[5]_i_1_n_0\,
      D => \p_0_in__0\(0),
      Q => slot_index_reg(0),
      R => \shift_data[14]_i_1_n_0\
    );
\slot_index_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \slot_index[5]_i_1_n_0\,
      D => \p_0_in__0\(1),
      Q => slot_index_reg(1),
      R => \shift_data[14]_i_1_n_0\
    );
\slot_index_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \slot_index[5]_i_1_n_0\,
      D => \p_0_in__0\(2),
      Q => slot_index_reg(2),
      R => \shift_data[14]_i_1_n_0\
    );
\slot_index_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \slot_index[5]_i_1_n_0\,
      D => \p_0_in__0\(3),
      Q => slot_index_reg(3),
      R => \shift_data[14]_i_1_n_0\
    );
\slot_index_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \slot_index[5]_i_1_n_0\,
      D => \p_0_in__0\(4),
      Q => slot_index_reg(4),
      R => \shift_data[14]_i_1_n_0\
    );
\slot_index_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \slot_index[5]_i_1_n_0\,
      D => \p_0_in__0\(5),
      Q => slot_index_reg(5),
      R => \shift_data[14]_i_1_n_0\
    );
started_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF0440"
    )
        port map (
      I0 => bclk_previous,
      I1 => bclk_sync(1),
      I2 => lrclk_sync(1),
      I3 => channel_reg_n_0,
      I4 => started,
      O => started_i_1_n_0
    );
started_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => started_i_1_n_0,
      Q => started,
      R => SR(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_voice_volume_0_0_axi_voice_volume is
  port (
    s_axi_rresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    SR : out STD_LOGIC_VECTOR ( 0 to 0 );
    Q : out STD_LOGIC_VECTOR ( 14 downto 0 );
    s_axi_bvalid_reg_0 : out STD_LOGIC;
    s_axi_rvalid_reg_0 : out STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    dc_clipped0 : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 15 downto 0 );
    \difference_latched_reg[12]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \difference_latched_reg[12]_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \difference_latched_reg[20]\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \difference_latched_reg[24]\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    input_fault : in STD_LOGIC;
    \out\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    pcm_valid : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_aresetn : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_awvalid : in STD_LOGIC;
    s_axi_arvalid : in STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_voice_volume_0_0_axi_voice_volume : entity is "axi_voice_volume";
end c6v_voice_volume_0_0_axi_voice_volume;

architecture STRUCTURE of c6v_voice_volume_0_0_axi_voice_volume is
  signal \^sr\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ack_epoch : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \ack_epoch_reg_n_0_[0]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[10]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[11]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[12]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[13]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[14]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[15]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[16]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[17]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[18]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[19]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[1]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[20]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[21]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[22]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[23]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[24]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[25]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[26]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[27]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[28]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[29]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[2]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[30]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[31]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[3]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[4]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[5]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[6]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[7]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[8]\ : STD_LOGIC;
  signal \ack_epoch_reg_n_0_[9]\ : STD_LOGIC;
  signal ack_sequence : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \ack_sequence_reg_n_0_[0]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[10]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[11]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[12]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[13]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[14]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[15]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[16]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[17]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[18]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[19]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[1]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[20]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[21]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[22]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[23]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[24]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[25]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[26]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[27]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[28]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[29]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[2]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[30]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[31]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[3]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[4]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[5]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[6]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[7]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[8]\ : STD_LOGIC;
  signal \ack_sequence_reg_n_0_[9]\ : STD_LOGIC;
  signal ack_valid_i_1_n_0 : STD_LOGIC;
  signal ack_valid_reg_n_0 : STD_LOGIC;
  signal aw_held : STD_LOGIC;
  signal aw_held0 : STD_LOGIC;
  signal aw_held09_out : STD_LOGIC;
  signal aw_held_i_1_n_0 : STD_LOGIC;
  signal \config_epoch[0]_i_2_n_0\ : STD_LOGIC;
  signal config_epoch_reg : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \config_epoch_reg[0]_i_1_n_0\ : STD_LOGIC;
  signal \config_epoch_reg[0]_i_1_n_1\ : STD_LOGIC;
  signal \config_epoch_reg[0]_i_1_n_2\ : STD_LOGIC;
  signal \config_epoch_reg[0]_i_1_n_3\ : STD_LOGIC;
  signal \config_epoch_reg[0]_i_1_n_4\ : STD_LOGIC;
  signal \config_epoch_reg[0]_i_1_n_5\ : STD_LOGIC;
  signal \config_epoch_reg[0]_i_1_n_6\ : STD_LOGIC;
  signal \config_epoch_reg[0]_i_1_n_7\ : STD_LOGIC;
  signal \config_epoch_reg[12]_i_1_n_0\ : STD_LOGIC;
  signal \config_epoch_reg[12]_i_1_n_1\ : STD_LOGIC;
  signal \config_epoch_reg[12]_i_1_n_2\ : STD_LOGIC;
  signal \config_epoch_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \config_epoch_reg[12]_i_1_n_4\ : STD_LOGIC;
  signal \config_epoch_reg[12]_i_1_n_5\ : STD_LOGIC;
  signal \config_epoch_reg[12]_i_1_n_6\ : STD_LOGIC;
  signal \config_epoch_reg[12]_i_1_n_7\ : STD_LOGIC;
  signal \config_epoch_reg[16]_i_1_n_0\ : STD_LOGIC;
  signal \config_epoch_reg[16]_i_1_n_1\ : STD_LOGIC;
  signal \config_epoch_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \config_epoch_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \config_epoch_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \config_epoch_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \config_epoch_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \config_epoch_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \config_epoch_reg[20]_i_1_n_0\ : STD_LOGIC;
  signal \config_epoch_reg[20]_i_1_n_1\ : STD_LOGIC;
  signal \config_epoch_reg[20]_i_1_n_2\ : STD_LOGIC;
  signal \config_epoch_reg[20]_i_1_n_3\ : STD_LOGIC;
  signal \config_epoch_reg[20]_i_1_n_4\ : STD_LOGIC;
  signal \config_epoch_reg[20]_i_1_n_5\ : STD_LOGIC;
  signal \config_epoch_reg[20]_i_1_n_6\ : STD_LOGIC;
  signal \config_epoch_reg[20]_i_1_n_7\ : STD_LOGIC;
  signal \config_epoch_reg[24]_i_1_n_0\ : STD_LOGIC;
  signal \config_epoch_reg[24]_i_1_n_1\ : STD_LOGIC;
  signal \config_epoch_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \config_epoch_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \config_epoch_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \config_epoch_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \config_epoch_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \config_epoch_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \config_epoch_reg[28]_i_1_n_1\ : STD_LOGIC;
  signal \config_epoch_reg[28]_i_1_n_2\ : STD_LOGIC;
  signal \config_epoch_reg[28]_i_1_n_3\ : STD_LOGIC;
  signal \config_epoch_reg[28]_i_1_n_4\ : STD_LOGIC;
  signal \config_epoch_reg[28]_i_1_n_5\ : STD_LOGIC;
  signal \config_epoch_reg[28]_i_1_n_6\ : STD_LOGIC;
  signal \config_epoch_reg[28]_i_1_n_7\ : STD_LOGIC;
  signal \config_epoch_reg[4]_i_1_n_0\ : STD_LOGIC;
  signal \config_epoch_reg[4]_i_1_n_1\ : STD_LOGIC;
  signal \config_epoch_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \config_epoch_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \config_epoch_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \config_epoch_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \config_epoch_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \config_epoch_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \config_epoch_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \config_epoch_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \config_epoch_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \config_epoch_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \config_epoch_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \config_epoch_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \config_epoch_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \config_epoch_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal configure : STD_LOGIC;
  signal configure_i_1_n_0 : STD_LOGIC;
  signal core_n_126 : STD_LOGIC;
  signal core_n_127 : STD_LOGIC;
  signal core_n_128 : STD_LOGIC;
  signal core_n_129 : STD_LOGIC;
  signal core_n_130 : STD_LOGIC;
  signal core_n_131 : STD_LOGIC;
  signal core_n_132 : STD_LOGIC;
  signal core_n_133 : STD_LOGIC;
  signal core_n_134 : STD_LOGIC;
  signal core_n_135 : STD_LOGIC;
  signal core_n_136 : STD_LOGIC;
  signal core_n_235 : STD_LOGIC;
  signal core_n_300 : STD_LOGIC;
  signal core_n_301 : STD_LOGIC;
  signal core_n_302 : STD_LOGIC;
  signal core_n_303 : STD_LOGIC;
  signal core_n_304 : STD_LOGIC;
  signal core_n_305 : STD_LOGIC;
  signal core_n_306 : STD_LOGIC;
  signal core_n_307 : STD_LOGIC;
  signal core_n_308 : STD_LOGIC;
  signal core_n_309 : STD_LOGIC;
  signal core_n_310 : STD_LOGIC;
  signal core_n_311 : STD_LOGIC;
  signal core_n_312 : STD_LOGIC;
  signal core_n_313 : STD_LOGIC;
  signal core_n_314 : STD_LOGIC;
  signal core_n_315 : STD_LOGIC;
  signal core_n_316 : STD_LOGIC;
  signal core_n_317 : STD_LOGIC;
  signal core_n_318 : STD_LOGIC;
  signal core_n_319 : STD_LOGIC;
  signal core_n_32 : STD_LOGIC;
  signal core_n_320 : STD_LOGIC;
  signal core_n_321 : STD_LOGIC;
  signal core_n_322 : STD_LOGIC;
  signal core_n_323 : STD_LOGIC;
  signal core_n_324 : STD_LOGIC;
  signal core_n_325 : STD_LOGIC;
  signal core_n_326 : STD_LOGIC;
  signal core_n_327 : STD_LOGIC;
  signal core_n_328 : STD_LOGIC;
  signal core_n_329 : STD_LOGIC;
  signal core_n_33 : STD_LOGIC;
  signal core_n_330 : STD_LOGIC;
  signal core_n_331 : STD_LOGIC;
  signal core_n_34 : STD_LOGIC;
  signal core_n_35 : STD_LOGIC;
  signal core_n_36 : STD_LOGIC;
  signal core_n_37 : STD_LOGIC;
  signal core_n_38 : STD_LOGIC;
  signal core_n_39 : STD_LOGIC;
  signal core_n_40 : STD_LOGIC;
  signal core_n_41 : STD_LOGIC;
  signal core_n_42 : STD_LOGIC;
  signal core_n_43 : STD_LOGIC;
  signal core_n_44 : STD_LOGIC;
  signal core_n_45 : STD_LOGIC;
  signal core_n_46 : STD_LOGIC;
  signal core_n_47 : STD_LOGIC;
  signal core_n_48 : STD_LOGIC;
  signal core_n_49 : STD_LOGIC;
  signal core_n_50 : STD_LOGIC;
  signal core_n_51 : STD_LOGIC;
  signal core_n_52 : STD_LOGIC;
  signal core_n_53 : STD_LOGIC;
  signal core_n_54 : STD_LOGIC;
  signal core_n_55 : STD_LOGIC;
  signal core_n_56 : STD_LOGIC;
  signal core_n_57 : STD_LOGIC;
  signal core_n_58 : STD_LOGIC;
  signal core_n_59 : STD_LOGIC;
  signal core_n_60 : STD_LOGIC;
  signal core_n_61 : STD_LOGIC;
  signal core_n_62 : STD_LOGIC;
  signal core_n_63 : STD_LOGIC;
  signal enable : STD_LOGIC;
  signal event_age : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal event_epoch : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal event_kind : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal event_sequence : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal event_window : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal faults : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal last_sum : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal loud_sum : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal p_15_in : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal p_5_in : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal quiet_sum : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^s_axi_bresp\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s_axi_bresp3 : STD_LOGIC;
  signal \s_axi_bresp3_carry__0_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry__0_n_1\ : STD_LOGIC;
  signal \s_axi_bresp3_carry__0_n_2\ : STD_LOGIC;
  signal \s_axi_bresp3_carry__0_n_3\ : STD_LOGIC;
  signal \s_axi_bresp3_carry__1_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry__1_n_1\ : STD_LOGIC;
  signal \s_axi_bresp3_carry__1_n_2\ : STD_LOGIC;
  signal \s_axi_bresp3_carry__1_n_3\ : STD_LOGIC;
  signal \s_axi_bresp3_carry__2_n_1\ : STD_LOGIC;
  signal \s_axi_bresp3_carry__2_n_2\ : STD_LOGIC;
  signal \s_axi_bresp3_carry__2_n_3\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_1__0_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_1__1_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_1__2_n_0\ : STD_LOGIC;
  signal s_axi_bresp3_carry_i_1_n_0 : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_2__0_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_2__1_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_2__2_n_0\ : STD_LOGIC;
  signal s_axi_bresp3_carry_i_2_n_0 : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_3__0_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_3__1_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_3__2_n_0\ : STD_LOGIC;
  signal s_axi_bresp3_carry_i_3_n_0 : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_4__0_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_4__1_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_4__2_n_0\ : STD_LOGIC;
  signal s_axi_bresp3_carry_i_4_n_0 : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_5__0_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_5__1_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_5__2_n_0\ : STD_LOGIC;
  signal s_axi_bresp3_carry_i_5_n_0 : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_6__0_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_6__1_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_6__2_n_0\ : STD_LOGIC;
  signal s_axi_bresp3_carry_i_6_n_0 : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_7__0_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_7__1_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_7__2_n_0\ : STD_LOGIC;
  signal s_axi_bresp3_carry_i_7_n_0 : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_8__0_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_8__1_n_0\ : STD_LOGIC;
  signal \s_axi_bresp3_carry_i_8__2_n_0\ : STD_LOGIC;
  signal s_axi_bresp3_carry_i_8_n_0 : STD_LOGIC;
  signal s_axi_bresp3_carry_n_0 : STD_LOGIC;
  signal s_axi_bresp3_carry_n_1 : STD_LOGIC;
  signal s_axi_bresp3_carry_n_2 : STD_LOGIC;
  signal s_axi_bresp3_carry_n_3 : STD_LOGIC;
  signal s_axi_bresp4 : STD_LOGIC;
  signal \s_axi_bresp4_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__0_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__0_n_1\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__0_n_2\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__0_n_3\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__1_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__1_n_1\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__1_n_2\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__1_n_3\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__2_n_1\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__2_n_2\ : STD_LOGIC;
  signal \s_axi_bresp4_carry__2_n_3\ : STD_LOGIC;
  signal s_axi_bresp4_carry_i_1_n_0 : STD_LOGIC;
  signal s_axi_bresp4_carry_i_2_n_0 : STD_LOGIC;
  signal s_axi_bresp4_carry_i_3_n_0 : STD_LOGIC;
  signal s_axi_bresp4_carry_i_4_n_0 : STD_LOGIC;
  signal s_axi_bresp4_carry_i_5_n_0 : STD_LOGIC;
  signal s_axi_bresp4_carry_i_6_n_0 : STD_LOGIC;
  signal s_axi_bresp4_carry_i_7_n_0 : STD_LOGIC;
  signal s_axi_bresp4_carry_i_8_n_0 : STD_LOGIC;
  signal s_axi_bresp4_carry_n_0 : STD_LOGIC;
  signal s_axi_bresp4_carry_n_1 : STD_LOGIC;
  signal s_axi_bresp4_carry_n_2 : STD_LOGIC;
  signal s_axi_bresp4_carry_n_3 : STD_LOGIC;
  signal \s_axi_bresp[1]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_11_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_12_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_13_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_14_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_15_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_16_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_9_n_0\ : STD_LOGIC;
  signal s_axi_bvalid_i_1_n_0 : STD_LOGIC;
  signal \^s_axi_bvalid_reg_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_11_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_12_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_11_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_12_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_11_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_12_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_11_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_12_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_13_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_11_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_12_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_13_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_15_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_16_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_17_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_11_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_12_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_13_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_11_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_12_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_11_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[7]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[7]_i_11_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[7]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[7]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[7]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[7]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[7]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_11_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_12_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_13_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[9]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[9]_i_11_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[9]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[9]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[9]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[9]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[9]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[0]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[0]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[10]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[10]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[12]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[15]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[17]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[1]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[1]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[22]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[26]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[28]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[2]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[2]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[31]_i_14_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[3]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[3]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[4]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[4]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[6]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[6]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[7]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[7]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[8]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[8]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[8]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[9]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata_reg[9]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rresp[1]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rresp[1]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rresp[1]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rresp[1]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rresp[1]_i_5_n_0\ : STD_LOGIC;
  signal s_axi_rvalid06_out : STD_LOGIC;
  signal s_axi_rvalid_i_1_n_0 : STD_LOGIC;
  signal \^s_axi_rvalid_reg_0\ : STD_LOGIC;
  signal shadow_enable : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \shadow_enable[31]_i_2_n_0\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[0]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[10]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[11]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[12]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[13]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[14]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[15]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[16]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[17]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[18]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[19]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[1]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[20]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[21]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[22]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[23]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[24]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[25]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[26]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[27]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[28]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[29]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[2]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[30]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[31]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[3]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[4]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[5]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[6]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[7]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[8]\ : STD_LOGIC;
  signal \shadow_enable_reg_n_0_[9]\ : STD_LOGIC;
  signal shadow_loud : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal shadow_loud_1 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal shadow_quiet : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal shadow_quiet_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \shadow_soft[31]_i_1_n_0\ : STD_LOGIC;
  signal \shadow_soft[31]_i_2_n_0\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[0]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[10]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[11]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[12]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[13]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[14]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[15]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[16]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[17]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[18]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[19]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[1]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[20]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[21]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[22]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[23]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[24]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[25]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[26]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[27]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[28]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[29]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[2]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[30]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[31]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[3]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[4]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[5]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[6]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[7]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[8]\ : STD_LOGIC;
  signal \shadow_soft_reg_n_0_[9]\ : STD_LOGIC;
  signal \snapshot[0][10]_i_1_n_0\ : STD_LOGIC;
  signal \snapshot[0][10]_i_2_n_0\ : STD_LOGIC;
  signal \snapshot[0][10]_i_3_n_0\ : STD_LOGIC;
  signal \snapshot_reg[0]\ : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal \snapshot_reg[10]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_reg[11]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_reg[12]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_reg[13]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_reg[14]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_reg[15]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_reg[16]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_reg[1]\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \snapshot_reg[2]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_reg[3]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_reg[4]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_reg[5]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_reg[6]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_reg[7]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_reg[8]\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_reg[9]\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \snapshot_sequence[0]_i_2_n_0\ : STD_LOGIC;
  signal snapshot_sequence_reg : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \snapshot_sequence_reg[0]_i_1_n_0\ : STD_LOGIC;
  signal \snapshot_sequence_reg[0]_i_1_n_1\ : STD_LOGIC;
  signal \snapshot_sequence_reg[0]_i_1_n_2\ : STD_LOGIC;
  signal \snapshot_sequence_reg[0]_i_1_n_3\ : STD_LOGIC;
  signal \snapshot_sequence_reg[0]_i_1_n_4\ : STD_LOGIC;
  signal \snapshot_sequence_reg[0]_i_1_n_5\ : STD_LOGIC;
  signal \snapshot_sequence_reg[0]_i_1_n_6\ : STD_LOGIC;
  signal \snapshot_sequence_reg[0]_i_1_n_7\ : STD_LOGIC;
  signal \snapshot_sequence_reg[12]_i_1_n_0\ : STD_LOGIC;
  signal \snapshot_sequence_reg[12]_i_1_n_1\ : STD_LOGIC;
  signal \snapshot_sequence_reg[12]_i_1_n_2\ : STD_LOGIC;
  signal \snapshot_sequence_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \snapshot_sequence_reg[12]_i_1_n_4\ : STD_LOGIC;
  signal \snapshot_sequence_reg[12]_i_1_n_5\ : STD_LOGIC;
  signal \snapshot_sequence_reg[12]_i_1_n_6\ : STD_LOGIC;
  signal \snapshot_sequence_reg[12]_i_1_n_7\ : STD_LOGIC;
  signal \snapshot_sequence_reg[16]_i_1_n_0\ : STD_LOGIC;
  signal \snapshot_sequence_reg[16]_i_1_n_1\ : STD_LOGIC;
  signal \snapshot_sequence_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \snapshot_sequence_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \snapshot_sequence_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \snapshot_sequence_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \snapshot_sequence_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \snapshot_sequence_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \snapshot_sequence_reg[20]_i_1_n_0\ : STD_LOGIC;
  signal \snapshot_sequence_reg[20]_i_1_n_1\ : STD_LOGIC;
  signal \snapshot_sequence_reg[20]_i_1_n_2\ : STD_LOGIC;
  signal \snapshot_sequence_reg[20]_i_1_n_3\ : STD_LOGIC;
  signal \snapshot_sequence_reg[20]_i_1_n_4\ : STD_LOGIC;
  signal \snapshot_sequence_reg[20]_i_1_n_5\ : STD_LOGIC;
  signal \snapshot_sequence_reg[20]_i_1_n_6\ : STD_LOGIC;
  signal \snapshot_sequence_reg[20]_i_1_n_7\ : STD_LOGIC;
  signal \snapshot_sequence_reg[24]_i_1_n_0\ : STD_LOGIC;
  signal \snapshot_sequence_reg[24]_i_1_n_1\ : STD_LOGIC;
  signal \snapshot_sequence_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \snapshot_sequence_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \snapshot_sequence_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \snapshot_sequence_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \snapshot_sequence_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \snapshot_sequence_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \snapshot_sequence_reg[28]_i_1_n_1\ : STD_LOGIC;
  signal \snapshot_sequence_reg[28]_i_1_n_2\ : STD_LOGIC;
  signal \snapshot_sequence_reg[28]_i_1_n_3\ : STD_LOGIC;
  signal \snapshot_sequence_reg[28]_i_1_n_4\ : STD_LOGIC;
  signal \snapshot_sequence_reg[28]_i_1_n_5\ : STD_LOGIC;
  signal \snapshot_sequence_reg[28]_i_1_n_6\ : STD_LOGIC;
  signal \snapshot_sequence_reg[28]_i_1_n_7\ : STD_LOGIC;
  signal \snapshot_sequence_reg[4]_i_1_n_0\ : STD_LOGIC;
  signal \snapshot_sequence_reg[4]_i_1_n_1\ : STD_LOGIC;
  signal \snapshot_sequence_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \snapshot_sequence_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \snapshot_sequence_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \snapshot_sequence_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \snapshot_sequence_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \snapshot_sequence_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \snapshot_sequence_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \snapshot_sequence_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \snapshot_sequence_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \snapshot_sequence_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \snapshot_sequence_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \snapshot_sequence_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \snapshot_sequence_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \snapshot_sequence_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal snapshot_valid : STD_LOGIC;
  signal snapshot_valid_i_2_n_0 : STD_LOGIC;
  signal \soft_sum[31]_i_10_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_11_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_12_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_13_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_14_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_15_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_16_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_17_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_18_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_19_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_20_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_21_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_2_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_3_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_4_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_5_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_6_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_7_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_8_n_0\ : STD_LOGIC;
  signal \soft_sum[31]_i_9_n_0\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[0]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[10]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[11]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[12]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[13]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[14]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[15]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[16]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[17]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[18]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[19]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[1]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[20]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[21]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[22]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[23]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[24]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[25]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[26]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[27]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[28]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[29]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[2]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[30]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[31]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[3]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[4]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[5]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[6]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[7]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[8]\ : STD_LOGIC;
  signal \soft_sum_reg_n_0_[9]\ : STD_LOGIC;
  signal status : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal status0 : STD_LOGIC;
  signal w_held0 : STD_LOGIC;
  signal w_held_i_1_n_0 : STD_LOGIC;
  signal w_held_reg_n_0 : STD_LOGIC;
  signal window_count : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal write_address : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal write_data : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal write_strobe : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_config_epoch_reg[28]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal NLW_s_axi_bresp3_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_s_axi_bresp3_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_s_axi_bresp3_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_s_axi_bresp3_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_s_axi_bresp4_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_s_axi_bresp4_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_s_axi_bresp4_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_s_axi_bresp4_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_snapshot_sequence_reg[28]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of aw_held_i_1 : label is "soft_lutpair48";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of \config_epoch_reg[0]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \config_epoch_reg[12]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \config_epoch_reg[16]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \config_epoch_reg[20]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \config_epoch_reg[24]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \config_epoch_reg[28]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \config_epoch_reg[4]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \config_epoch_reg[8]_i_1\ : label is 35;
  attribute SOFT_HLUTNM of configure_i_1 : label is "soft_lutpair52";
  attribute SOFT_HLUTNM of s_axi_arready_INST_0 : label is "soft_lutpair52";
  attribute SOFT_HLUTNM of s_axi_awready_INST_0 : label is "soft_lutpair48";
  attribute COMPARATOR_THRESHOLD : integer;
  attribute COMPARATOR_THRESHOLD of s_axi_bresp3_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \s_axi_bresp3_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \s_axi_bresp3_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \s_axi_bresp3_carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of s_axi_bresp4_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \s_axi_bresp4_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \s_axi_bresp4_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \s_axi_bresp4_carry__2\ : label is 11;
  attribute SOFT_HLUTNM of \s_axi_bresp[1]_i_10\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of \s_axi_bresp[1]_i_5\ : label is "soft_lutpair51";
  attribute SOFT_HLUTNM of \s_axi_bresp[1]_i_7\ : label is "soft_lutpair49";
  attribute SOFT_HLUTNM of \s_axi_rdata[11]_i_6\ : label is "soft_lutpair46";
  attribute SOFT_HLUTNM of \s_axi_rdata[17]_i_3\ : label is "soft_lutpair45";
  attribute SOFT_HLUTNM of \s_axi_rdata[2]_i_6\ : label is "soft_lutpair45";
  attribute SOFT_HLUTNM of \s_axi_rdata[8]_i_3\ : label is "soft_lutpair46";
  attribute SOFT_HLUTNM of s_axi_wready_INST_0 : label is "soft_lutpair47";
  attribute SOFT_HLUTNM of \shadow_enable[31]_i_2\ : label is "soft_lutpair50";
  attribute SOFT_HLUTNM of \shadow_soft[31]_i_2\ : label is "soft_lutpair53";
  attribute SOFT_HLUTNM of \snapshot[0][10]_i_2\ : label is "soft_lutpair51";
  attribute ADDER_THRESHOLD of \snapshot_sequence_reg[0]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \snapshot_sequence_reg[12]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \snapshot_sequence_reg[16]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \snapshot_sequence_reg[20]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \snapshot_sequence_reg[24]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \snapshot_sequence_reg[28]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \snapshot_sequence_reg[4]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \snapshot_sequence_reg[8]_i_1\ : label is 35;
  attribute SOFT_HLUTNM of snapshot_valid_i_2 : label is "soft_lutpair50";
  attribute SOFT_HLUTNM of \soft_sum[31]_i_2\ : label is "soft_lutpair53";
  attribute SOFT_HLUTNM of \soft_sum[31]_i_4\ : label is "soft_lutpair49";
  attribute SOFT_HLUTNM of \soft_sum[31]_i_9\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of w_held_i_1 : label is "soft_lutpair47";
begin
  SR(0) <= \^sr\(0);
  s_axi_bresp(0) <= \^s_axi_bresp\(0);
  s_axi_bvalid_reg_0 <= \^s_axi_bvalid_reg_0\;
  s_axi_rvalid_reg_0 <= \^s_axi_rvalid_reg_0\;
\ack_epoch[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0800"
    )
        port map (
      I0 => \shadow_soft[31]_i_2_n_0\,
      I1 => write_address(4),
      I2 => write_address(3),
      I3 => write_address(2),
      O => ack_epoch(0)
    );
\ack_epoch_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(0),
      Q => \ack_epoch_reg_n_0_[0]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(10),
      Q => \ack_epoch_reg_n_0_[10]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(11),
      Q => \ack_epoch_reg_n_0_[11]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(12),
      Q => \ack_epoch_reg_n_0_[12]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(13),
      Q => \ack_epoch_reg_n_0_[13]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(14),
      Q => \ack_epoch_reg_n_0_[14]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(15),
      Q => \ack_epoch_reg_n_0_[15]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(16),
      Q => \ack_epoch_reg_n_0_[16]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(17),
      Q => \ack_epoch_reg_n_0_[17]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(18),
      Q => \ack_epoch_reg_n_0_[18]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(19),
      Q => \ack_epoch_reg_n_0_[19]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(1),
      Q => \ack_epoch_reg_n_0_[1]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(20),
      Q => \ack_epoch_reg_n_0_[20]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(21),
      Q => \ack_epoch_reg_n_0_[21]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(22),
      Q => \ack_epoch_reg_n_0_[22]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(23),
      Q => \ack_epoch_reg_n_0_[23]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(24),
      Q => \ack_epoch_reg_n_0_[24]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(25),
      Q => \ack_epoch_reg_n_0_[25]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(26),
      Q => \ack_epoch_reg_n_0_[26]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(27),
      Q => \ack_epoch_reg_n_0_[27]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(28),
      Q => \ack_epoch_reg_n_0_[28]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(29),
      Q => \ack_epoch_reg_n_0_[29]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(2),
      Q => \ack_epoch_reg_n_0_[2]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(30),
      Q => \ack_epoch_reg_n_0_[30]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(31),
      Q => \ack_epoch_reg_n_0_[31]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(3),
      Q => \ack_epoch_reg_n_0_[3]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(4),
      Q => \ack_epoch_reg_n_0_[4]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(5),
      Q => \ack_epoch_reg_n_0_[5]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(6),
      Q => \ack_epoch_reg_n_0_[6]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(7),
      Q => \ack_epoch_reg_n_0_[7]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(8),
      Q => \ack_epoch_reg_n_0_[8]\,
      R => \^sr\(0)
    );
\ack_epoch_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_epoch(0),
      D => write_data(9),
      Q => \ack_epoch_reg_n_0_[9]\,
      R => \^sr\(0)
    );
\ack_sequence[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0800"
    )
        port map (
      I0 => \shadow_soft[31]_i_2_n_0\,
      I1 => write_address(3),
      I2 => write_address(2),
      I3 => write_address(4),
      O => ack_sequence(0)
    );
\ack_sequence_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(0),
      Q => \ack_sequence_reg_n_0_[0]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(10),
      Q => \ack_sequence_reg_n_0_[10]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(11),
      Q => \ack_sequence_reg_n_0_[11]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(12),
      Q => \ack_sequence_reg_n_0_[12]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(13),
      Q => \ack_sequence_reg_n_0_[13]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(14),
      Q => \ack_sequence_reg_n_0_[14]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(15),
      Q => \ack_sequence_reg_n_0_[15]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(16),
      Q => \ack_sequence_reg_n_0_[16]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(17),
      Q => \ack_sequence_reg_n_0_[17]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(18),
      Q => \ack_sequence_reg_n_0_[18]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(19),
      Q => \ack_sequence_reg_n_0_[19]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(1),
      Q => \ack_sequence_reg_n_0_[1]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(20),
      Q => \ack_sequence_reg_n_0_[20]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(21),
      Q => \ack_sequence_reg_n_0_[21]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(22),
      Q => \ack_sequence_reg_n_0_[22]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(23),
      Q => \ack_sequence_reg_n_0_[23]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(24),
      Q => \ack_sequence_reg_n_0_[24]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(25),
      Q => \ack_sequence_reg_n_0_[25]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(26),
      Q => \ack_sequence_reg_n_0_[26]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(27),
      Q => \ack_sequence_reg_n_0_[27]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(28),
      Q => \ack_sequence_reg_n_0_[28]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(29),
      Q => \ack_sequence_reg_n_0_[29]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(2),
      Q => \ack_sequence_reg_n_0_[2]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(30),
      Q => \ack_sequence_reg_n_0_[30]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(31),
      Q => \ack_sequence_reg_n_0_[31]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(3),
      Q => \ack_sequence_reg_n_0_[3]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(4),
      Q => \ack_sequence_reg_n_0_[4]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(5),
      Q => \ack_sequence_reg_n_0_[5]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(6),
      Q => \ack_sequence_reg_n_0_[6]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(7),
      Q => \ack_sequence_reg_n_0_[7]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(8),
      Q => \ack_sequence_reg_n_0_[8]\,
      R => \^sr\(0)
    );
\ack_sequence_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => ack_sequence(0),
      D => write_data(9),
      Q => \ack_sequence_reg_n_0_[9]\,
      R => \^sr\(0)
    );
ack_valid_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000002000000"
    )
        port map (
      I0 => write_data(2),
      I1 => write_data(0),
      I2 => write_data(1),
      I3 => \soft_sum[31]_i_2_n_0\,
      I4 => s_axi_aresetn,
      I5 => \soft_sum[31]_i_4_n_0\,
      O => ack_valid_i_1_n_0
    );
ack_valid_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => ack_valid_i_1_n_0,
      Q => ack_valid_reg_n_0,
      R => '0'
    );
aw_held_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"C0C008C8"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => s_axi_aresetn,
      I2 => aw_held,
      I3 => w_held_reg_n_0,
      I4 => \^s_axi_bvalid_reg_0\,
      O => aw_held_i_1_n_0
    );
aw_held_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => aw_held_i_1_n_0,
      Q => aw_held,
      R => '0'
    );
\config_epoch[0]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => config_epoch_reg(0),
      O => \config_epoch[0]_i_2_n_0\
    );
\config_epoch_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[0]_i_1_n_7\,
      Q => config_epoch_reg(0),
      R => \^sr\(0)
    );
\config_epoch_reg[0]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \config_epoch_reg[0]_i_1_n_0\,
      CO(2) => \config_epoch_reg[0]_i_1_n_1\,
      CO(1) => \config_epoch_reg[0]_i_1_n_2\,
      CO(0) => \config_epoch_reg[0]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \config_epoch_reg[0]_i_1_n_4\,
      O(2) => \config_epoch_reg[0]_i_1_n_5\,
      O(1) => \config_epoch_reg[0]_i_1_n_6\,
      O(0) => \config_epoch_reg[0]_i_1_n_7\,
      S(3 downto 1) => config_epoch_reg(3 downto 1),
      S(0) => \config_epoch[0]_i_2_n_0\
    );
\config_epoch_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[8]_i_1_n_5\,
      Q => config_epoch_reg(10),
      R => \^sr\(0)
    );
\config_epoch_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[8]_i_1_n_4\,
      Q => config_epoch_reg(11),
      R => \^sr\(0)
    );
\config_epoch_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[12]_i_1_n_7\,
      Q => config_epoch_reg(12),
      R => \^sr\(0)
    );
\config_epoch_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \config_epoch_reg[8]_i_1_n_0\,
      CO(3) => \config_epoch_reg[12]_i_1_n_0\,
      CO(2) => \config_epoch_reg[12]_i_1_n_1\,
      CO(1) => \config_epoch_reg[12]_i_1_n_2\,
      CO(0) => \config_epoch_reg[12]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \config_epoch_reg[12]_i_1_n_4\,
      O(2) => \config_epoch_reg[12]_i_1_n_5\,
      O(1) => \config_epoch_reg[12]_i_1_n_6\,
      O(0) => \config_epoch_reg[12]_i_1_n_7\,
      S(3 downto 0) => config_epoch_reg(15 downto 12)
    );
\config_epoch_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[12]_i_1_n_6\,
      Q => config_epoch_reg(13),
      R => \^sr\(0)
    );
\config_epoch_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[12]_i_1_n_5\,
      Q => config_epoch_reg(14),
      R => \^sr\(0)
    );
\config_epoch_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[12]_i_1_n_4\,
      Q => config_epoch_reg(15),
      R => \^sr\(0)
    );
\config_epoch_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[16]_i_1_n_7\,
      Q => config_epoch_reg(16),
      R => \^sr\(0)
    );
\config_epoch_reg[16]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \config_epoch_reg[12]_i_1_n_0\,
      CO(3) => \config_epoch_reg[16]_i_1_n_0\,
      CO(2) => \config_epoch_reg[16]_i_1_n_1\,
      CO(1) => \config_epoch_reg[16]_i_1_n_2\,
      CO(0) => \config_epoch_reg[16]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \config_epoch_reg[16]_i_1_n_4\,
      O(2) => \config_epoch_reg[16]_i_1_n_5\,
      O(1) => \config_epoch_reg[16]_i_1_n_6\,
      O(0) => \config_epoch_reg[16]_i_1_n_7\,
      S(3 downto 0) => config_epoch_reg(19 downto 16)
    );
\config_epoch_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[16]_i_1_n_6\,
      Q => config_epoch_reg(17),
      R => \^sr\(0)
    );
\config_epoch_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[16]_i_1_n_5\,
      Q => config_epoch_reg(18),
      R => \^sr\(0)
    );
\config_epoch_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[16]_i_1_n_4\,
      Q => config_epoch_reg(19),
      R => \^sr\(0)
    );
\config_epoch_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[0]_i_1_n_6\,
      Q => config_epoch_reg(1),
      R => \^sr\(0)
    );
\config_epoch_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[20]_i_1_n_7\,
      Q => config_epoch_reg(20),
      R => \^sr\(0)
    );
\config_epoch_reg[20]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \config_epoch_reg[16]_i_1_n_0\,
      CO(3) => \config_epoch_reg[20]_i_1_n_0\,
      CO(2) => \config_epoch_reg[20]_i_1_n_1\,
      CO(1) => \config_epoch_reg[20]_i_1_n_2\,
      CO(0) => \config_epoch_reg[20]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \config_epoch_reg[20]_i_1_n_4\,
      O(2) => \config_epoch_reg[20]_i_1_n_5\,
      O(1) => \config_epoch_reg[20]_i_1_n_6\,
      O(0) => \config_epoch_reg[20]_i_1_n_7\,
      S(3 downto 0) => config_epoch_reg(23 downto 20)
    );
\config_epoch_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[20]_i_1_n_6\,
      Q => config_epoch_reg(21),
      R => \^sr\(0)
    );
\config_epoch_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[20]_i_1_n_5\,
      Q => config_epoch_reg(22),
      R => \^sr\(0)
    );
\config_epoch_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[20]_i_1_n_4\,
      Q => config_epoch_reg(23),
      R => \^sr\(0)
    );
\config_epoch_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[24]_i_1_n_7\,
      Q => config_epoch_reg(24),
      R => \^sr\(0)
    );
\config_epoch_reg[24]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \config_epoch_reg[20]_i_1_n_0\,
      CO(3) => \config_epoch_reg[24]_i_1_n_0\,
      CO(2) => \config_epoch_reg[24]_i_1_n_1\,
      CO(1) => \config_epoch_reg[24]_i_1_n_2\,
      CO(0) => \config_epoch_reg[24]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \config_epoch_reg[24]_i_1_n_4\,
      O(2) => \config_epoch_reg[24]_i_1_n_5\,
      O(1) => \config_epoch_reg[24]_i_1_n_6\,
      O(0) => \config_epoch_reg[24]_i_1_n_7\,
      S(3 downto 0) => config_epoch_reg(27 downto 24)
    );
\config_epoch_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[24]_i_1_n_6\,
      Q => config_epoch_reg(25),
      R => \^sr\(0)
    );
\config_epoch_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[24]_i_1_n_5\,
      Q => config_epoch_reg(26),
      R => \^sr\(0)
    );
\config_epoch_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[24]_i_1_n_4\,
      Q => config_epoch_reg(27),
      R => \^sr\(0)
    );
\config_epoch_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[28]_i_1_n_7\,
      Q => config_epoch_reg(28),
      R => \^sr\(0)
    );
\config_epoch_reg[28]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \config_epoch_reg[24]_i_1_n_0\,
      CO(3) => \NLW_config_epoch_reg[28]_i_1_CO_UNCONNECTED\(3),
      CO(2) => \config_epoch_reg[28]_i_1_n_1\,
      CO(1) => \config_epoch_reg[28]_i_1_n_2\,
      CO(0) => \config_epoch_reg[28]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \config_epoch_reg[28]_i_1_n_4\,
      O(2) => \config_epoch_reg[28]_i_1_n_5\,
      O(1) => \config_epoch_reg[28]_i_1_n_6\,
      O(0) => \config_epoch_reg[28]_i_1_n_7\,
      S(3 downto 0) => config_epoch_reg(31 downto 28)
    );
\config_epoch_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[28]_i_1_n_6\,
      Q => config_epoch_reg(29),
      R => \^sr\(0)
    );
\config_epoch_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[0]_i_1_n_5\,
      Q => config_epoch_reg(2),
      R => \^sr\(0)
    );
\config_epoch_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[28]_i_1_n_5\,
      Q => config_epoch_reg(30),
      R => \^sr\(0)
    );
\config_epoch_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[28]_i_1_n_4\,
      Q => config_epoch_reg(31),
      R => \^sr\(0)
    );
\config_epoch_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[0]_i_1_n_4\,
      Q => config_epoch_reg(3),
      R => \^sr\(0)
    );
\config_epoch_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[4]_i_1_n_7\,
      Q => config_epoch_reg(4),
      R => \^sr\(0)
    );
\config_epoch_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \config_epoch_reg[0]_i_1_n_0\,
      CO(3) => \config_epoch_reg[4]_i_1_n_0\,
      CO(2) => \config_epoch_reg[4]_i_1_n_1\,
      CO(1) => \config_epoch_reg[4]_i_1_n_2\,
      CO(0) => \config_epoch_reg[4]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \config_epoch_reg[4]_i_1_n_4\,
      O(2) => \config_epoch_reg[4]_i_1_n_5\,
      O(1) => \config_epoch_reg[4]_i_1_n_6\,
      O(0) => \config_epoch_reg[4]_i_1_n_7\,
      S(3 downto 0) => config_epoch_reg(7 downto 4)
    );
\config_epoch_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[4]_i_1_n_6\,
      Q => config_epoch_reg(5),
      R => \^sr\(0)
    );
\config_epoch_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[4]_i_1_n_5\,
      Q => config_epoch_reg(6),
      R => \^sr\(0)
    );
\config_epoch_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[4]_i_1_n_4\,
      Q => config_epoch_reg(7),
      R => \^sr\(0)
    );
\config_epoch_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[8]_i_1_n_7\,
      Q => config_epoch_reg(8),
      R => \^sr\(0)
    );
\config_epoch_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \config_epoch_reg[4]_i_1_n_0\,
      CO(3) => \config_epoch_reg[8]_i_1_n_0\,
      CO(2) => \config_epoch_reg[8]_i_1_n_1\,
      CO(1) => \config_epoch_reg[8]_i_1_n_2\,
      CO(0) => \config_epoch_reg[8]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \config_epoch_reg[8]_i_1_n_4\,
      O(2) => \config_epoch_reg[8]_i_1_n_5\,
      O(1) => \config_epoch_reg[8]_i_1_n_6\,
      O(0) => \config_epoch_reg[8]_i_1_n_7\,
      S(3 downto 0) => config_epoch_reg(11 downto 8)
    );
\config_epoch_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \config_epoch_reg[8]_i_1_n_6\,
      Q => config_epoch_reg(9),
      R => \^sr\(0)
    );
configure_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0080"
    )
        port map (
      I0 => \soft_sum[31]_i_2_n_0\,
      I1 => \soft_sum[31]_i_3_n_0\,
      I2 => s_axi_aresetn,
      I3 => \soft_sum[31]_i_4_n_0\,
      O => configure_i_1_n_0
    );
configure_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => configure_i_1_n_0,
      Q => configure,
      R => '0'
    );
core: entity work.c6v_voice_volume_0_0_voice_volume_core
     port map (
      D(15 downto 0) => D(15 downto 0),
      Q(31 downto 0) => event_age(31 downto 0),
      S(3 downto 0) => S(3 downto 0),
      \above_loud_carry__2_0\(31 downto 0) => loud_sum(31 downto 0),
      ack_error_reg_0 => ack_valid_reg_n_0,
      config_epoch_reg(31 downto 0) => config_epoch_reg(31 downto 0),
      configure => configure,
      dc_clipped0 => dc_clipped0,
      \dc_level_reg[22]_0\(14 downto 0) => Q(14 downto 0),
      \difference_latched_reg[12]_0\(0) => \difference_latched_reg[12]\(0),
      \difference_latched_reg[12]_1\(3 downto 0) => \difference_latched_reg[12]_0\(3 downto 0),
      \difference_latched_reg[20]_0\(3 downto 0) => \difference_latched_reg[20]\(3 downto 0),
      \difference_latched_reg[24]_0\(1 downto 0) => \difference_latched_reg[24]\(1 downto 0),
      \event_epoch_reg[31]_0\(31 downto 0) => event_epoch(31 downto 0),
      \event_kind_reg[1]_0\(1 downto 0) => event_kind(1 downto 0),
      \event_sample_reg[63]_0\(63 downto 32) => p_5_in(31 downto 0),
      \event_sample_reg[63]_0\(31) => core_n_300,
      \event_sample_reg[63]_0\(30) => core_n_301,
      \event_sample_reg[63]_0\(29) => core_n_302,
      \event_sample_reg[63]_0\(28) => core_n_303,
      \event_sample_reg[63]_0\(27) => core_n_304,
      \event_sample_reg[63]_0\(26) => core_n_305,
      \event_sample_reg[63]_0\(25) => core_n_306,
      \event_sample_reg[63]_0\(24) => core_n_307,
      \event_sample_reg[63]_0\(23) => core_n_308,
      \event_sample_reg[63]_0\(22) => core_n_309,
      \event_sample_reg[63]_0\(21) => core_n_310,
      \event_sample_reg[63]_0\(20) => core_n_311,
      \event_sample_reg[63]_0\(19) => core_n_312,
      \event_sample_reg[63]_0\(18) => core_n_313,
      \event_sample_reg[63]_0\(17) => core_n_314,
      \event_sample_reg[63]_0\(16) => core_n_315,
      \event_sample_reg[63]_0\(15) => core_n_316,
      \event_sample_reg[63]_0\(14) => core_n_317,
      \event_sample_reg[63]_0\(13) => core_n_318,
      \event_sample_reg[63]_0\(12) => core_n_319,
      \event_sample_reg[63]_0\(11) => core_n_320,
      \event_sample_reg[63]_0\(10) => core_n_321,
      \event_sample_reg[63]_0\(9) => core_n_322,
      \event_sample_reg[63]_0\(8) => core_n_323,
      \event_sample_reg[63]_0\(7) => core_n_324,
      \event_sample_reg[63]_0\(6) => core_n_325,
      \event_sample_reg[63]_0\(5) => core_n_326,
      \event_sample_reg[63]_0\(4) => core_n_327,
      \event_sample_reg[63]_0\(3) => core_n_328,
      \event_sample_reg[63]_0\(2) => core_n_329,
      \event_sample_reg[63]_0\(1) => core_n_330,
      \event_sample_reg[63]_0\(0) => core_n_331,
      \event_sequence_reg[31]_0\(31 downto 0) => event_sequence(31 downto 0),
      \event_window_reg[31]_0\(31 downto 0) => event_window(31 downto 0),
      \faults[7]_i_10_0\(31) => \soft_sum_reg_n_0_[31]\,
      \faults[7]_i_10_0\(30) => \soft_sum_reg_n_0_[30]\,
      \faults[7]_i_10_0\(29) => \soft_sum_reg_n_0_[29]\,
      \faults[7]_i_10_0\(28) => \soft_sum_reg_n_0_[28]\,
      \faults[7]_i_10_0\(27) => \soft_sum_reg_n_0_[27]\,
      \faults[7]_i_10_0\(26) => \soft_sum_reg_n_0_[26]\,
      \faults[7]_i_10_0\(25) => \soft_sum_reg_n_0_[25]\,
      \faults[7]_i_10_0\(24) => \soft_sum_reg_n_0_[24]\,
      \faults[7]_i_10_0\(23) => \soft_sum_reg_n_0_[23]\,
      \faults[7]_i_10_0\(22) => \soft_sum_reg_n_0_[22]\,
      \faults[7]_i_10_0\(21) => \soft_sum_reg_n_0_[21]\,
      \faults[7]_i_10_0\(20) => \soft_sum_reg_n_0_[20]\,
      \faults[7]_i_10_0\(19) => \soft_sum_reg_n_0_[19]\,
      \faults[7]_i_10_0\(18) => \soft_sum_reg_n_0_[18]\,
      \faults[7]_i_10_0\(17) => \soft_sum_reg_n_0_[17]\,
      \faults[7]_i_10_0\(16) => \soft_sum_reg_n_0_[16]\,
      \faults[7]_i_10_0\(15) => \soft_sum_reg_n_0_[15]\,
      \faults[7]_i_10_0\(14) => \soft_sum_reg_n_0_[14]\,
      \faults[7]_i_10_0\(13) => \soft_sum_reg_n_0_[13]\,
      \faults[7]_i_10_0\(12) => \soft_sum_reg_n_0_[12]\,
      \faults[7]_i_10_0\(11) => \soft_sum_reg_n_0_[11]\,
      \faults[7]_i_10_0\(10) => \soft_sum_reg_n_0_[10]\,
      \faults[7]_i_10_0\(9) => \soft_sum_reg_n_0_[9]\,
      \faults[7]_i_10_0\(8) => \soft_sum_reg_n_0_[8]\,
      \faults[7]_i_10_0\(7) => \soft_sum_reg_n_0_[7]\,
      \faults[7]_i_10_0\(6) => \soft_sum_reg_n_0_[6]\,
      \faults[7]_i_10_0\(5) => \soft_sum_reg_n_0_[5]\,
      \faults[7]_i_10_0\(4) => \soft_sum_reg_n_0_[4]\,
      \faults[7]_i_10_0\(3) => \soft_sum_reg_n_0_[3]\,
      \faults[7]_i_10_0\(2) => \soft_sum_reg_n_0_[2]\,
      \faults[7]_i_10_0\(1) => \soft_sum_reg_n_0_[1]\,
      \faults[7]_i_10_0\(0) => \soft_sum_reg_n_0_[0]\,
      \faults_reg[0]_0\(0) => status0,
      \faults_reg[0]_1\(0) => status(0),
      \faults_reg[1]_0\(0) => \out\(0),
      \faults_reg[7]_0\(7 downto 0) => faults(7 downto 0),
      input_fault => input_fault,
      \last_sum_reg[31]_0\(31 downto 0) => last_sum(31 downto 0),
      \matching_ack0_carry__1_0\(31) => \ack_sequence_reg_n_0_[31]\,
      \matching_ack0_carry__1_0\(30) => \ack_sequence_reg_n_0_[30]\,
      \matching_ack0_carry__1_0\(29) => \ack_sequence_reg_n_0_[29]\,
      \matching_ack0_carry__1_0\(28) => \ack_sequence_reg_n_0_[28]\,
      \matching_ack0_carry__1_0\(27) => \ack_sequence_reg_n_0_[27]\,
      \matching_ack0_carry__1_0\(26) => \ack_sequence_reg_n_0_[26]\,
      \matching_ack0_carry__1_0\(25) => \ack_sequence_reg_n_0_[25]\,
      \matching_ack0_carry__1_0\(24) => \ack_sequence_reg_n_0_[24]\,
      \matching_ack0_carry__1_0\(23) => \ack_sequence_reg_n_0_[23]\,
      \matching_ack0_carry__1_0\(22) => \ack_sequence_reg_n_0_[22]\,
      \matching_ack0_carry__1_0\(21) => \ack_sequence_reg_n_0_[21]\,
      \matching_ack0_carry__1_0\(20) => \ack_sequence_reg_n_0_[20]\,
      \matching_ack0_carry__1_0\(19) => \ack_sequence_reg_n_0_[19]\,
      \matching_ack0_carry__1_0\(18) => \ack_sequence_reg_n_0_[18]\,
      \matching_ack0_carry__1_0\(17) => \ack_sequence_reg_n_0_[17]\,
      \matching_ack0_carry__1_0\(16) => \ack_sequence_reg_n_0_[16]\,
      \matching_ack0_carry__1_0\(15) => \ack_sequence_reg_n_0_[15]\,
      \matching_ack0_carry__1_0\(14) => \ack_sequence_reg_n_0_[14]\,
      \matching_ack0_carry__1_0\(13) => \ack_sequence_reg_n_0_[13]\,
      \matching_ack0_carry__1_0\(12) => \ack_sequence_reg_n_0_[12]\,
      \matching_ack0_carry__1_0\(11) => \ack_sequence_reg_n_0_[11]\,
      \matching_ack0_carry__1_0\(10) => \ack_sequence_reg_n_0_[10]\,
      \matching_ack0_carry__1_0\(9) => \ack_sequence_reg_n_0_[9]\,
      \matching_ack0_carry__1_0\(8) => \ack_sequence_reg_n_0_[8]\,
      \matching_ack0_carry__1_0\(7) => \ack_sequence_reg_n_0_[7]\,
      \matching_ack0_carry__1_0\(6) => \ack_sequence_reg_n_0_[6]\,
      \matching_ack0_carry__1_0\(5) => \ack_sequence_reg_n_0_[5]\,
      \matching_ack0_carry__1_0\(4) => \ack_sequence_reg_n_0_[4]\,
      \matching_ack0_carry__1_0\(3) => \ack_sequence_reg_n_0_[3]\,
      \matching_ack0_carry__1_0\(2) => \ack_sequence_reg_n_0_[2]\,
      \matching_ack0_carry__1_0\(1) => \ack_sequence_reg_n_0_[1]\,
      \matching_ack0_carry__1_0\(0) => \ack_sequence_reg_n_0_[0]\,
      \matching_ack1_carry__1_0\(31) => \ack_epoch_reg_n_0_[31]\,
      \matching_ack1_carry__1_0\(30) => \ack_epoch_reg_n_0_[30]\,
      \matching_ack1_carry__1_0\(29) => \ack_epoch_reg_n_0_[29]\,
      \matching_ack1_carry__1_0\(28) => \ack_epoch_reg_n_0_[28]\,
      \matching_ack1_carry__1_0\(27) => \ack_epoch_reg_n_0_[27]\,
      \matching_ack1_carry__1_0\(26) => \ack_epoch_reg_n_0_[26]\,
      \matching_ack1_carry__1_0\(25) => \ack_epoch_reg_n_0_[25]\,
      \matching_ack1_carry__1_0\(24) => \ack_epoch_reg_n_0_[24]\,
      \matching_ack1_carry__1_0\(23) => \ack_epoch_reg_n_0_[23]\,
      \matching_ack1_carry__1_0\(22) => \ack_epoch_reg_n_0_[22]\,
      \matching_ack1_carry__1_0\(21) => \ack_epoch_reg_n_0_[21]\,
      \matching_ack1_carry__1_0\(20) => \ack_epoch_reg_n_0_[20]\,
      \matching_ack1_carry__1_0\(19) => \ack_epoch_reg_n_0_[19]\,
      \matching_ack1_carry__1_0\(18) => \ack_epoch_reg_n_0_[18]\,
      \matching_ack1_carry__1_0\(17) => \ack_epoch_reg_n_0_[17]\,
      \matching_ack1_carry__1_0\(16) => \ack_epoch_reg_n_0_[16]\,
      \matching_ack1_carry__1_0\(15) => \ack_epoch_reg_n_0_[15]\,
      \matching_ack1_carry__1_0\(14) => \ack_epoch_reg_n_0_[14]\,
      \matching_ack1_carry__1_0\(13) => \ack_epoch_reg_n_0_[13]\,
      \matching_ack1_carry__1_0\(12) => \ack_epoch_reg_n_0_[12]\,
      \matching_ack1_carry__1_0\(11) => \ack_epoch_reg_n_0_[11]\,
      \matching_ack1_carry__1_0\(10) => \ack_epoch_reg_n_0_[10]\,
      \matching_ack1_carry__1_0\(9) => \ack_epoch_reg_n_0_[9]\,
      \matching_ack1_carry__1_0\(8) => \ack_epoch_reg_n_0_[8]\,
      \matching_ack1_carry__1_0\(7) => \ack_epoch_reg_n_0_[7]\,
      \matching_ack1_carry__1_0\(6) => \ack_epoch_reg_n_0_[6]\,
      \matching_ack1_carry__1_0\(5) => \ack_epoch_reg_n_0_[5]\,
      \matching_ack1_carry__1_0\(4) => \ack_epoch_reg_n_0_[4]\,
      \matching_ack1_carry__1_0\(3) => \ack_epoch_reg_n_0_[3]\,
      \matching_ack1_carry__1_0\(2) => \ack_epoch_reg_n_0_[2]\,
      \matching_ack1_carry__1_0\(1) => \ack_epoch_reg_n_0_[1]\,
      \matching_ack1_carry__1_0\(0) => \ack_epoch_reg_n_0_[0]\,
      \out\(63 downto 32) => p_15_in(31 downto 0),
      \out\(31) => core_n_32,
      \out\(30) => core_n_33,
      \out\(29) => core_n_34,
      \out\(28) => core_n_35,
      \out\(27) => core_n_36,
      \out\(26) => core_n_37,
      \out\(25) => core_n_38,
      \out\(24) => core_n_39,
      \out\(23) => core_n_40,
      \out\(22) => core_n_41,
      \out\(21) => core_n_42,
      \out\(20) => core_n_43,
      \out\(19) => core_n_44,
      \out\(18) => core_n_45,
      \out\(17) => core_n_46,
      \out\(16) => core_n_47,
      \out\(15) => core_n_48,
      \out\(14) => core_n_49,
      \out\(13) => core_n_50,
      \out\(12) => core_n_51,
      \out\(11) => core_n_52,
      \out\(10) => core_n_53,
      \out\(9) => core_n_54,
      \out\(8) => core_n_55,
      \out\(7) => core_n_56,
      \out\(6) => core_n_57,
      \out\(5) => core_n_58,
      \out\(4) => core_n_59,
      \out\(3) => core_n_60,
      \out\(2) => core_n_61,
      \out\(1) => core_n_62,
      \out\(0) => core_n_63,
      pcm_valid => pcm_valid,
      \quiet_carry__2_0\(31 downto 0) => quiet_sum(31 downto 0),
      s_axi_aclk => s_axi_aclk,
      s_axi_aresetn => s_axi_aresetn,
      s_axi_aresetn_0 => \^sr\(0),
      \s_axi_rdata_reg[0]\ => \s_axi_rdata[0]_i_2_n_0\,
      \s_axi_rdata_reg[0]_0\ => \s_axi_rdata[0]_i_3_n_0\,
      \s_axi_rdata_reg[10]\ => \s_axi_rdata[10]_i_2_n_0\,
      \s_axi_rdata_reg[10]_0\ => \s_axi_rdata[10]_i_3_n_0\,
      \s_axi_rdata_reg[10]_1\ => \s_axi_rdata[10]_i_6_n_0\,
      \s_axi_rdata_reg[1]\ => \s_axi_rdata[1]_i_3_n_0\,
      \s_axi_rdata_reg[1]_0\ => \s_axi_rdata[1]_i_4_n_0\,
      \s_axi_rdata_reg[1]_1\ => \s_axi_rdata[3]_i_5_n_0\,
      \s_axi_rdata_reg[2]\ => \s_axi_rdata[31]_i_3_n_0\,
      \s_axi_rdata_reg[2]_0\ => \s_axi_rdata[31]_i_7_n_0\,
      \s_axi_rdata_reg[2]_1\ => \s_axi_rdata[2]_i_3_n_0\,
      \s_axi_rdata_reg[2]_2\ => \s_axi_rdata[31]_i_4_n_0\,
      \s_axi_rdata_reg[2]_3\ => \s_axi_rdata[2]_i_4_n_0\,
      \s_axi_rdata_reg[2]_4\ => \s_axi_rdata[2]_i_6_n_0\,
      \s_axi_rdata_reg[3]\ => \s_axi_rdata[3]_i_3_n_0\,
      \s_axi_rdata_reg[3]_0\ => \s_axi_rdata[3]_i_4_n_0\,
      \s_axi_rdata_reg[3]_1\ => \s_axi_rdata[3]_i_6_n_0\,
      \s_axi_rdata_reg[4]\ => \s_axi_rdata[4]_i_2_n_0\,
      \s_axi_rdata_reg[4]_0\ => \s_axi_rdata[4]_i_3_n_0\,
      \s_axi_rdata_reg[4]_1\ => \s_axi_rdata[31]_i_11_n_0\,
      \s_axi_rdata_reg[4]_2\ => \s_axi_rdata[31]_i_10_n_0\,
      \s_axi_rdata_reg[5]\ => \s_axi_rdata[5]_i_2_n_0\,
      \s_axi_rdata_reg[5]_0\ => \s_axi_rdata[5]_i_3_n_0\,
      \s_axi_rdata_reg[6]\ => \s_axi_rdata[6]_i_2_n_0\,
      \s_axi_rdata_reg[6]_0\ => \s_axi_rdata[6]_i_3_n_0\,
      \s_axi_rdata_reg[7]\ => \s_axi_rdata[7]_i_3_n_0\,
      \s_axi_rdata_reg[7]_0\ => \s_axi_rdata[7]_i_4_n_0\,
      \s_axi_rdata_reg[8]\ => \s_axi_rdata[8]_i_2_n_0\,
      \s_axi_rdata_reg[8]_0\ => \s_axi_rdata[8]_i_3_n_0\,
      \s_axi_rdata_reg[8]_1\ => \s_axi_rdata_reg[8]_i_4_n_0\,
      \s_axi_rdata_reg[9]\(7) => \shadow_soft_reg_n_0_[9]\,
      \s_axi_rdata_reg[9]\(6) => \shadow_soft_reg_n_0_[7]\,
      \s_axi_rdata_reg[9]\(5) => \shadow_soft_reg_n_0_[6]\,
      \s_axi_rdata_reg[9]\(4) => \shadow_soft_reg_n_0_[5]\,
      \s_axi_rdata_reg[9]\(3) => \shadow_soft_reg_n_0_[4]\,
      \s_axi_rdata_reg[9]\(2) => \shadow_soft_reg_n_0_[2]\,
      \s_axi_rdata_reg[9]\(1) => \shadow_soft_reg_n_0_[1]\,
      \s_axi_rdata_reg[9]\(0) => \shadow_soft_reg_n_0_[0]\,
      \s_axi_rdata_reg[9]_0\ => \s_axi_rdata[9]_i_2_n_0\,
      \s_axi_rdata_reg[9]_1\ => \s_axi_rdata[9]_i_3_n_0\,
      \snapshot_sequence_reg[10]\(10) => core_n_126,
      \snapshot_sequence_reg[10]\(9) => core_n_127,
      \snapshot_sequence_reg[10]\(8) => core_n_128,
      \snapshot_sequence_reg[10]\(7) => core_n_129,
      \snapshot_sequence_reg[10]\(6) => core_n_130,
      \snapshot_sequence_reg[10]\(5) => core_n_131,
      \snapshot_sequence_reg[10]\(4) => core_n_132,
      \snapshot_sequence_reg[10]\(3) => core_n_133,
      \snapshot_sequence_reg[10]\(2) => core_n_134,
      \snapshot_sequence_reg[10]\(1) => core_n_135,
      \snapshot_sequence_reg[10]\(0) => core_n_136,
      snapshot_valid => snapshot_valid,
      snapshot_valid_reg => core_n_235,
      snapshot_valid_reg_0 => snapshot_valid_i_2_n_0,
      snapshot_valid_reg_1 => \shadow_soft[31]_i_2_n_0\,
      snapshot_valid_reg_2 => \snapshot[0][10]_i_2_n_0\,
      snapshot_valid_reg_3(0) => write_data(1),
      status(4 downto 2) => status(10 downto 8),
      status(1) => status(4),
      status(0) => status(1),
      \window_count_reg[31]_0\(31 downto 0) => window_count(31 downto 0)
    );
enable_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_enable_reg_n_0_[0]\,
      Q => status(0),
      R => \^sr\(0)
    );
\loud_sum_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(0),
      Q => loud_sum(0),
      R => \^sr\(0)
    );
\loud_sum_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(10),
      Q => loud_sum(10),
      R => \^sr\(0)
    );
\loud_sum_reg[11]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(11),
      Q => loud_sum(11),
      S => \^sr\(0)
    );
\loud_sum_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(12),
      Q => loud_sum(12),
      R => \^sr\(0)
    );
\loud_sum_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(13),
      Q => loud_sum(13),
      R => \^sr\(0)
    );
\loud_sum_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(14),
      Q => loud_sum(14),
      R => \^sr\(0)
    );
\loud_sum_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(15),
      Q => loud_sum(15),
      R => \^sr\(0)
    );
\loud_sum_reg[16]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(16),
      Q => loud_sum(16),
      S => \^sr\(0)
    );
\loud_sum_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(17),
      Q => loud_sum(17),
      R => \^sr\(0)
    );
\loud_sum_reg[18]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(18),
      Q => loud_sum(18),
      S => \^sr\(0)
    );
\loud_sum_reg[19]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(19),
      Q => loud_sum(19),
      S => \^sr\(0)
    );
\loud_sum_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(1),
      Q => loud_sum(1),
      R => \^sr\(0)
    );
\loud_sum_reg[20]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(20),
      Q => loud_sum(20),
      S => \^sr\(0)
    );
\loud_sum_reg[21]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(21),
      Q => loud_sum(21),
      S => \^sr\(0)
    );
\loud_sum_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(22),
      Q => loud_sum(22),
      R => \^sr\(0)
    );
\loud_sum_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(23),
      Q => loud_sum(23),
      R => \^sr\(0)
    );
\loud_sum_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(24),
      Q => loud_sum(24),
      R => \^sr\(0)
    );
\loud_sum_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(25),
      Q => loud_sum(25),
      R => \^sr\(0)
    );
\loud_sum_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(26),
      Q => loud_sum(26),
      R => \^sr\(0)
    );
\loud_sum_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(27),
      Q => loud_sum(27),
      R => \^sr\(0)
    );
\loud_sum_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(28),
      Q => loud_sum(28),
      R => \^sr\(0)
    );
\loud_sum_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(29),
      Q => loud_sum(29),
      R => \^sr\(0)
    );
\loud_sum_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(2),
      Q => loud_sum(2),
      R => \^sr\(0)
    );
\loud_sum_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(30),
      Q => loud_sum(30),
      R => \^sr\(0)
    );
\loud_sum_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(31),
      Q => loud_sum(31),
      R => \^sr\(0)
    );
\loud_sum_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(3),
      Q => loud_sum(3),
      R => \^sr\(0)
    );
\loud_sum_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(4),
      Q => loud_sum(4),
      R => \^sr\(0)
    );
\loud_sum_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(5),
      Q => loud_sum(5),
      R => \^sr\(0)
    );
\loud_sum_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(6),
      Q => loud_sum(6),
      R => \^sr\(0)
    );
\loud_sum_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(7),
      Q => loud_sum(7),
      R => \^sr\(0)
    );
\loud_sum_reg[8]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(8),
      Q => loud_sum(8),
      S => \^sr\(0)
    );
\loud_sum_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_loud(9),
      Q => loud_sum(9),
      R => \^sr\(0)
    );
\quiet_sum_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(0),
      Q => quiet_sum(0),
      R => \^sr\(0)
    );
\quiet_sum_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(10),
      Q => quiet_sum(10),
      R => \^sr\(0)
    );
\quiet_sum_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(11),
      Q => quiet_sum(11),
      R => \^sr\(0)
    );
\quiet_sum_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(12),
      Q => quiet_sum(12),
      R => \^sr\(0)
    );
\quiet_sum_reg[13]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(13),
      Q => quiet_sum(13),
      S => \^sr\(0)
    );
\quiet_sum_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(14),
      Q => quiet_sum(14),
      R => \^sr\(0)
    );
\quiet_sum_reg[15]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(15),
      Q => quiet_sum(15),
      S => \^sr\(0)
    );
\quiet_sum_reg[16]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(16),
      Q => quiet_sum(16),
      S => \^sr\(0)
    );
\quiet_sum_reg[17]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(17),
      Q => quiet_sum(17),
      S => \^sr\(0)
    );
\quiet_sum_reg[18]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(18),
      Q => quiet_sum(18),
      S => \^sr\(0)
    );
\quiet_sum_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(19),
      Q => quiet_sum(19),
      R => \^sr\(0)
    );
\quiet_sum_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(1),
      Q => quiet_sum(1),
      R => \^sr\(0)
    );
\quiet_sum_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(20),
      Q => quiet_sum(20),
      R => \^sr\(0)
    );
\quiet_sum_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(21),
      Q => quiet_sum(21),
      R => \^sr\(0)
    );
\quiet_sum_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(22),
      Q => quiet_sum(22),
      R => \^sr\(0)
    );
\quiet_sum_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(23),
      Q => quiet_sum(23),
      R => \^sr\(0)
    );
\quiet_sum_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(24),
      Q => quiet_sum(24),
      R => \^sr\(0)
    );
\quiet_sum_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(25),
      Q => quiet_sum(25),
      R => \^sr\(0)
    );
\quiet_sum_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(26),
      Q => quiet_sum(26),
      R => \^sr\(0)
    );
\quiet_sum_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(27),
      Q => quiet_sum(27),
      R => \^sr\(0)
    );
\quiet_sum_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(28),
      Q => quiet_sum(28),
      R => \^sr\(0)
    );
\quiet_sum_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(29),
      Q => quiet_sum(29),
      R => \^sr\(0)
    );
\quiet_sum_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(2),
      Q => quiet_sum(2),
      R => \^sr\(0)
    );
\quiet_sum_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(30),
      Q => quiet_sum(30),
      R => \^sr\(0)
    );
\quiet_sum_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(31),
      Q => quiet_sum(31),
      R => \^sr\(0)
    );
\quiet_sum_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(3),
      Q => quiet_sum(3),
      R => \^sr\(0)
    );
\quiet_sum_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(4),
      Q => quiet_sum(4),
      R => \^sr\(0)
    );
\quiet_sum_reg[5]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(5),
      Q => quiet_sum(5),
      S => \^sr\(0)
    );
\quiet_sum_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(6),
      Q => quiet_sum(6),
      R => \^sr\(0)
    );
\quiet_sum_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(7),
      Q => quiet_sum(7),
      R => \^sr\(0)
    );
\quiet_sum_reg[8]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(8),
      Q => quiet_sum(8),
      S => \^sr\(0)
    );
\quiet_sum_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => shadow_quiet(9),
      Q => quiet_sum(9),
      R => \^sr\(0)
    );
s_axi_arready_INST_0: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => s_axi_aresetn,
      I1 => \^s_axi_rvalid_reg_0\,
      O => s_axi_arready
    );
s_axi_awready_INST_0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"04"
    )
        port map (
      I0 => aw_held,
      I1 => s_axi_aresetn,
      I2 => \^s_axi_bvalid_reg_0\,
      O => s_axi_awready
    );
s_axi_bresp3_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => s_axi_bresp3_carry_n_0,
      CO(2) => s_axi_bresp3_carry_n_1,
      CO(1) => s_axi_bresp3_carry_n_2,
      CO(0) => s_axi_bresp3_carry_n_3,
      CYINIT => '1',
      DI(3) => s_axi_bresp3_carry_i_1_n_0,
      DI(2) => s_axi_bresp3_carry_i_2_n_0,
      DI(1) => s_axi_bresp3_carry_i_3_n_0,
      DI(0) => s_axi_bresp3_carry_i_4_n_0,
      O(3 downto 0) => NLW_s_axi_bresp3_carry_O_UNCONNECTED(3 downto 0),
      S(3) => s_axi_bresp3_carry_i_5_n_0,
      S(2) => s_axi_bresp3_carry_i_6_n_0,
      S(1) => s_axi_bresp3_carry_i_7_n_0,
      S(0) => s_axi_bresp3_carry_i_8_n_0
    );
\s_axi_bresp3_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => s_axi_bresp3_carry_n_0,
      CO(3) => \s_axi_bresp3_carry__0_n_0\,
      CO(2) => \s_axi_bresp3_carry__0_n_1\,
      CO(1) => \s_axi_bresp3_carry__0_n_2\,
      CO(0) => \s_axi_bresp3_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \s_axi_bresp3_carry_i_1__0_n_0\,
      DI(2) => \s_axi_bresp3_carry_i_2__0_n_0\,
      DI(1) => \s_axi_bresp3_carry_i_3__0_n_0\,
      DI(0) => \s_axi_bresp3_carry_i_4__0_n_0\,
      O(3 downto 0) => \NLW_s_axi_bresp3_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \s_axi_bresp3_carry_i_5__0_n_0\,
      S(2) => \s_axi_bresp3_carry_i_6__0_n_0\,
      S(1) => \s_axi_bresp3_carry_i_7__0_n_0\,
      S(0) => \s_axi_bresp3_carry_i_8__0_n_0\
    );
\s_axi_bresp3_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \s_axi_bresp3_carry__0_n_0\,
      CO(3) => \s_axi_bresp3_carry__1_n_0\,
      CO(2) => \s_axi_bresp3_carry__1_n_1\,
      CO(1) => \s_axi_bresp3_carry__1_n_2\,
      CO(0) => \s_axi_bresp3_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \s_axi_bresp3_carry_i_1__1_n_0\,
      DI(2) => \s_axi_bresp3_carry_i_2__1_n_0\,
      DI(1) => \s_axi_bresp3_carry_i_3__1_n_0\,
      DI(0) => \s_axi_bresp3_carry_i_4__1_n_0\,
      O(3 downto 0) => \NLW_s_axi_bresp3_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \s_axi_bresp3_carry_i_5__1_n_0\,
      S(2) => \s_axi_bresp3_carry_i_6__1_n_0\,
      S(1) => \s_axi_bresp3_carry_i_7__1_n_0\,
      S(0) => \s_axi_bresp3_carry_i_8__1_n_0\
    );
\s_axi_bresp3_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \s_axi_bresp3_carry__1_n_0\,
      CO(3) => s_axi_bresp3,
      CO(2) => \s_axi_bresp3_carry__2_n_1\,
      CO(1) => \s_axi_bresp3_carry__2_n_2\,
      CO(0) => \s_axi_bresp3_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \s_axi_bresp3_carry_i_1__2_n_0\,
      DI(2) => \s_axi_bresp3_carry_i_2__2_n_0\,
      DI(1) => \s_axi_bresp3_carry_i_3__2_n_0\,
      DI(0) => \s_axi_bresp3_carry_i_4__2_n_0\,
      O(3 downto 0) => \NLW_s_axi_bresp3_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \s_axi_bresp3_carry_i_5__2_n_0\,
      S(2) => \s_axi_bresp3_carry_i_6__2_n_0\,
      S(1) => \s_axi_bresp3_carry_i_7__2_n_0\,
      S(0) => \s_axi_bresp3_carry_i_8__2_n_0\
    );
s_axi_bresp3_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[7]\,
      I1 => shadow_quiet(7),
      I2 => shadow_quiet(6),
      I3 => \shadow_soft_reg_n_0_[6]\,
      O => s_axi_bresp3_carry_i_1_n_0
    );
\s_axi_bresp3_carry_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[15]\,
      I1 => shadow_quiet(15),
      I2 => shadow_quiet(14),
      I3 => \shadow_soft_reg_n_0_[14]\,
      O => \s_axi_bresp3_carry_i_1__0_n_0\
    );
\s_axi_bresp3_carry_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[23]\,
      I1 => shadow_quiet(23),
      I2 => shadow_quiet(22),
      I3 => \shadow_soft_reg_n_0_[22]\,
      O => \s_axi_bresp3_carry_i_1__1_n_0\
    );
\s_axi_bresp3_carry_i_1__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[31]\,
      I1 => shadow_quiet(31),
      I2 => shadow_quiet(30),
      I3 => \shadow_soft_reg_n_0_[30]\,
      O => \s_axi_bresp3_carry_i_1__2_n_0\
    );
s_axi_bresp3_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[5]\,
      I1 => shadow_quiet(5),
      I2 => shadow_quiet(4),
      I3 => \shadow_soft_reg_n_0_[4]\,
      O => s_axi_bresp3_carry_i_2_n_0
    );
\s_axi_bresp3_carry_i_2__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[13]\,
      I1 => shadow_quiet(13),
      I2 => shadow_quiet(12),
      I3 => \shadow_soft_reg_n_0_[12]\,
      O => \s_axi_bresp3_carry_i_2__0_n_0\
    );
\s_axi_bresp3_carry_i_2__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[21]\,
      I1 => shadow_quiet(21),
      I2 => shadow_quiet(20),
      I3 => \shadow_soft_reg_n_0_[20]\,
      O => \s_axi_bresp3_carry_i_2__1_n_0\
    );
\s_axi_bresp3_carry_i_2__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[29]\,
      I1 => shadow_quiet(29),
      I2 => shadow_quiet(28),
      I3 => \shadow_soft_reg_n_0_[28]\,
      O => \s_axi_bresp3_carry_i_2__2_n_0\
    );
s_axi_bresp3_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[3]\,
      I1 => shadow_quiet(3),
      I2 => shadow_quiet(2),
      I3 => \shadow_soft_reg_n_0_[2]\,
      O => s_axi_bresp3_carry_i_3_n_0
    );
\s_axi_bresp3_carry_i_3__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[11]\,
      I1 => shadow_quiet(11),
      I2 => shadow_quiet(10),
      I3 => \shadow_soft_reg_n_0_[10]\,
      O => \s_axi_bresp3_carry_i_3__0_n_0\
    );
\s_axi_bresp3_carry_i_3__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[19]\,
      I1 => shadow_quiet(19),
      I2 => shadow_quiet(18),
      I3 => \shadow_soft_reg_n_0_[18]\,
      O => \s_axi_bresp3_carry_i_3__1_n_0\
    );
\s_axi_bresp3_carry_i_3__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[27]\,
      I1 => shadow_quiet(27),
      I2 => shadow_quiet(26),
      I3 => \shadow_soft_reg_n_0_[26]\,
      O => \s_axi_bresp3_carry_i_3__2_n_0\
    );
s_axi_bresp3_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[1]\,
      I1 => shadow_quiet(1),
      I2 => shadow_quiet(0),
      I3 => \shadow_soft_reg_n_0_[0]\,
      O => s_axi_bresp3_carry_i_4_n_0
    );
\s_axi_bresp3_carry_i_4__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[9]\,
      I1 => shadow_quiet(9),
      I2 => shadow_quiet(8),
      I3 => \shadow_soft_reg_n_0_[8]\,
      O => \s_axi_bresp3_carry_i_4__0_n_0\
    );
\s_axi_bresp3_carry_i_4__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[17]\,
      I1 => shadow_quiet(17),
      I2 => shadow_quiet(16),
      I3 => \shadow_soft_reg_n_0_[16]\,
      O => \s_axi_bresp3_carry_i_4__1_n_0\
    );
\s_axi_bresp3_carry_i_4__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[25]\,
      I1 => shadow_quiet(25),
      I2 => shadow_quiet(24),
      I3 => \shadow_soft_reg_n_0_[24]\,
      O => \s_axi_bresp3_carry_i_4__2_n_0\
    );
s_axi_bresp3_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(7),
      I1 => \shadow_soft_reg_n_0_[7]\,
      I2 => shadow_quiet(6),
      I3 => \shadow_soft_reg_n_0_[6]\,
      O => s_axi_bresp3_carry_i_5_n_0
    );
\s_axi_bresp3_carry_i_5__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(15),
      I1 => \shadow_soft_reg_n_0_[15]\,
      I2 => shadow_quiet(14),
      I3 => \shadow_soft_reg_n_0_[14]\,
      O => \s_axi_bresp3_carry_i_5__0_n_0\
    );
\s_axi_bresp3_carry_i_5__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(23),
      I1 => \shadow_soft_reg_n_0_[23]\,
      I2 => shadow_quiet(22),
      I3 => \shadow_soft_reg_n_0_[22]\,
      O => \s_axi_bresp3_carry_i_5__1_n_0\
    );
\s_axi_bresp3_carry_i_5__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(31),
      I1 => \shadow_soft_reg_n_0_[31]\,
      I2 => shadow_quiet(30),
      I3 => \shadow_soft_reg_n_0_[30]\,
      O => \s_axi_bresp3_carry_i_5__2_n_0\
    );
s_axi_bresp3_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(5),
      I1 => \shadow_soft_reg_n_0_[5]\,
      I2 => shadow_quiet(4),
      I3 => \shadow_soft_reg_n_0_[4]\,
      O => s_axi_bresp3_carry_i_6_n_0
    );
\s_axi_bresp3_carry_i_6__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(13),
      I1 => \shadow_soft_reg_n_0_[13]\,
      I2 => shadow_quiet(12),
      I3 => \shadow_soft_reg_n_0_[12]\,
      O => \s_axi_bresp3_carry_i_6__0_n_0\
    );
\s_axi_bresp3_carry_i_6__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(21),
      I1 => \shadow_soft_reg_n_0_[21]\,
      I2 => shadow_quiet(20),
      I3 => \shadow_soft_reg_n_0_[20]\,
      O => \s_axi_bresp3_carry_i_6__1_n_0\
    );
\s_axi_bresp3_carry_i_6__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(29),
      I1 => \shadow_soft_reg_n_0_[29]\,
      I2 => shadow_quiet(28),
      I3 => \shadow_soft_reg_n_0_[28]\,
      O => \s_axi_bresp3_carry_i_6__2_n_0\
    );
s_axi_bresp3_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(3),
      I1 => \shadow_soft_reg_n_0_[3]\,
      I2 => shadow_quiet(2),
      I3 => \shadow_soft_reg_n_0_[2]\,
      O => s_axi_bresp3_carry_i_7_n_0
    );
\s_axi_bresp3_carry_i_7__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(11),
      I1 => \shadow_soft_reg_n_0_[11]\,
      I2 => shadow_quiet(10),
      I3 => \shadow_soft_reg_n_0_[10]\,
      O => \s_axi_bresp3_carry_i_7__0_n_0\
    );
\s_axi_bresp3_carry_i_7__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(19),
      I1 => \shadow_soft_reg_n_0_[19]\,
      I2 => shadow_quiet(18),
      I3 => \shadow_soft_reg_n_0_[18]\,
      O => \s_axi_bresp3_carry_i_7__1_n_0\
    );
\s_axi_bresp3_carry_i_7__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(27),
      I1 => \shadow_soft_reg_n_0_[27]\,
      I2 => shadow_quiet(26),
      I3 => \shadow_soft_reg_n_0_[26]\,
      O => \s_axi_bresp3_carry_i_7__2_n_0\
    );
s_axi_bresp3_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(1),
      I1 => \shadow_soft_reg_n_0_[1]\,
      I2 => shadow_quiet(0),
      I3 => \shadow_soft_reg_n_0_[0]\,
      O => s_axi_bresp3_carry_i_8_n_0
    );
\s_axi_bresp3_carry_i_8__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(9),
      I1 => \shadow_soft_reg_n_0_[9]\,
      I2 => shadow_quiet(8),
      I3 => \shadow_soft_reg_n_0_[8]\,
      O => \s_axi_bresp3_carry_i_8__0_n_0\
    );
\s_axi_bresp3_carry_i_8__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(17),
      I1 => \shadow_soft_reg_n_0_[17]\,
      I2 => shadow_quiet(16),
      I3 => \shadow_soft_reg_n_0_[16]\,
      O => \s_axi_bresp3_carry_i_8__1_n_0\
    );
\s_axi_bresp3_carry_i_8__2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_quiet(25),
      I1 => \shadow_soft_reg_n_0_[25]\,
      I2 => shadow_quiet(24),
      I3 => \shadow_soft_reg_n_0_[24]\,
      O => \s_axi_bresp3_carry_i_8__2_n_0\
    );
s_axi_bresp4_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => s_axi_bresp4_carry_n_0,
      CO(2) => s_axi_bresp4_carry_n_1,
      CO(1) => s_axi_bresp4_carry_n_2,
      CO(0) => s_axi_bresp4_carry_n_3,
      CYINIT => '1',
      DI(3) => s_axi_bresp4_carry_i_1_n_0,
      DI(2) => s_axi_bresp4_carry_i_2_n_0,
      DI(1) => s_axi_bresp4_carry_i_3_n_0,
      DI(0) => s_axi_bresp4_carry_i_4_n_0,
      O(3 downto 0) => NLW_s_axi_bresp4_carry_O_UNCONNECTED(3 downto 0),
      S(3) => s_axi_bresp4_carry_i_5_n_0,
      S(2) => s_axi_bresp4_carry_i_6_n_0,
      S(1) => s_axi_bresp4_carry_i_7_n_0,
      S(0) => s_axi_bresp4_carry_i_8_n_0
    );
\s_axi_bresp4_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => s_axi_bresp4_carry_n_0,
      CO(3) => \s_axi_bresp4_carry__0_n_0\,
      CO(2) => \s_axi_bresp4_carry__0_n_1\,
      CO(1) => \s_axi_bresp4_carry__0_n_2\,
      CO(0) => \s_axi_bresp4_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \s_axi_bresp4_carry__0_i_1_n_0\,
      DI(2) => \s_axi_bresp4_carry__0_i_2_n_0\,
      DI(1) => \s_axi_bresp4_carry__0_i_3_n_0\,
      DI(0) => \s_axi_bresp4_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_s_axi_bresp4_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \s_axi_bresp4_carry__0_i_5_n_0\,
      S(2) => \s_axi_bresp4_carry__0_i_6_n_0\,
      S(1) => \s_axi_bresp4_carry__0_i_7_n_0\,
      S(0) => \s_axi_bresp4_carry__0_i_8_n_0\
    );
\s_axi_bresp4_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[15]\,
      I1 => shadow_loud(15),
      I2 => \shadow_soft_reg_n_0_[14]\,
      I3 => shadow_loud(14),
      O => \s_axi_bresp4_carry__0_i_1_n_0\
    );
\s_axi_bresp4_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[13]\,
      I1 => shadow_loud(13),
      I2 => \shadow_soft_reg_n_0_[12]\,
      I3 => shadow_loud(12),
      O => \s_axi_bresp4_carry__0_i_2_n_0\
    );
\s_axi_bresp4_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[11]\,
      I1 => shadow_loud(11),
      I2 => \shadow_soft_reg_n_0_[10]\,
      I3 => shadow_loud(10),
      O => \s_axi_bresp4_carry__0_i_3_n_0\
    );
\s_axi_bresp4_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[9]\,
      I1 => shadow_loud(9),
      I2 => \shadow_soft_reg_n_0_[8]\,
      I3 => shadow_loud(8),
      O => \s_axi_bresp4_carry__0_i_4_n_0\
    );
\s_axi_bresp4_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(15),
      I1 => \shadow_soft_reg_n_0_[15]\,
      I2 => shadow_loud(14),
      I3 => \shadow_soft_reg_n_0_[14]\,
      O => \s_axi_bresp4_carry__0_i_5_n_0\
    );
\s_axi_bresp4_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(13),
      I1 => \shadow_soft_reg_n_0_[13]\,
      I2 => shadow_loud(12),
      I3 => \shadow_soft_reg_n_0_[12]\,
      O => \s_axi_bresp4_carry__0_i_6_n_0\
    );
\s_axi_bresp4_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(11),
      I1 => \shadow_soft_reg_n_0_[11]\,
      I2 => shadow_loud(10),
      I3 => \shadow_soft_reg_n_0_[10]\,
      O => \s_axi_bresp4_carry__0_i_7_n_0\
    );
\s_axi_bresp4_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(9),
      I1 => \shadow_soft_reg_n_0_[9]\,
      I2 => shadow_loud(8),
      I3 => \shadow_soft_reg_n_0_[8]\,
      O => \s_axi_bresp4_carry__0_i_8_n_0\
    );
\s_axi_bresp4_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \s_axi_bresp4_carry__0_n_0\,
      CO(3) => \s_axi_bresp4_carry__1_n_0\,
      CO(2) => \s_axi_bresp4_carry__1_n_1\,
      CO(1) => \s_axi_bresp4_carry__1_n_2\,
      CO(0) => \s_axi_bresp4_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \s_axi_bresp4_carry__1_i_1_n_0\,
      DI(2) => \s_axi_bresp4_carry__1_i_2_n_0\,
      DI(1) => \s_axi_bresp4_carry__1_i_3_n_0\,
      DI(0) => \s_axi_bresp4_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_s_axi_bresp4_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \s_axi_bresp4_carry__1_i_5_n_0\,
      S(2) => \s_axi_bresp4_carry__1_i_6_n_0\,
      S(1) => \s_axi_bresp4_carry__1_i_7_n_0\,
      S(0) => \s_axi_bresp4_carry__1_i_8_n_0\
    );
\s_axi_bresp4_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[23]\,
      I1 => shadow_loud(23),
      I2 => \shadow_soft_reg_n_0_[22]\,
      I3 => shadow_loud(22),
      O => \s_axi_bresp4_carry__1_i_1_n_0\
    );
\s_axi_bresp4_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[21]\,
      I1 => shadow_loud(21),
      I2 => \shadow_soft_reg_n_0_[20]\,
      I3 => shadow_loud(20),
      O => \s_axi_bresp4_carry__1_i_2_n_0\
    );
\s_axi_bresp4_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[19]\,
      I1 => shadow_loud(19),
      I2 => \shadow_soft_reg_n_0_[18]\,
      I3 => shadow_loud(18),
      O => \s_axi_bresp4_carry__1_i_3_n_0\
    );
\s_axi_bresp4_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[17]\,
      I1 => shadow_loud(17),
      I2 => \shadow_soft_reg_n_0_[16]\,
      I3 => shadow_loud(16),
      O => \s_axi_bresp4_carry__1_i_4_n_0\
    );
\s_axi_bresp4_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(23),
      I1 => \shadow_soft_reg_n_0_[23]\,
      I2 => shadow_loud(22),
      I3 => \shadow_soft_reg_n_0_[22]\,
      O => \s_axi_bresp4_carry__1_i_5_n_0\
    );
\s_axi_bresp4_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(21),
      I1 => \shadow_soft_reg_n_0_[21]\,
      I2 => shadow_loud(20),
      I3 => \shadow_soft_reg_n_0_[20]\,
      O => \s_axi_bresp4_carry__1_i_6_n_0\
    );
\s_axi_bresp4_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(19),
      I1 => \shadow_soft_reg_n_0_[19]\,
      I2 => shadow_loud(18),
      I3 => \shadow_soft_reg_n_0_[18]\,
      O => \s_axi_bresp4_carry__1_i_7_n_0\
    );
\s_axi_bresp4_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(17),
      I1 => \shadow_soft_reg_n_0_[17]\,
      I2 => shadow_loud(16),
      I3 => \shadow_soft_reg_n_0_[16]\,
      O => \s_axi_bresp4_carry__1_i_8_n_0\
    );
\s_axi_bresp4_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \s_axi_bresp4_carry__1_n_0\,
      CO(3) => s_axi_bresp4,
      CO(2) => \s_axi_bresp4_carry__2_n_1\,
      CO(1) => \s_axi_bresp4_carry__2_n_2\,
      CO(0) => \s_axi_bresp4_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \s_axi_bresp4_carry__2_i_1_n_0\,
      DI(2) => \s_axi_bresp4_carry__2_i_2_n_0\,
      DI(1) => \s_axi_bresp4_carry__2_i_3_n_0\,
      DI(0) => \s_axi_bresp4_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_s_axi_bresp4_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \s_axi_bresp4_carry__2_i_5_n_0\,
      S(2) => \s_axi_bresp4_carry__2_i_6_n_0\,
      S(1) => \s_axi_bresp4_carry__2_i_7_n_0\,
      S(0) => \s_axi_bresp4_carry__2_i_8_n_0\
    );
\s_axi_bresp4_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[31]\,
      I1 => shadow_loud(31),
      I2 => \shadow_soft_reg_n_0_[30]\,
      I3 => shadow_loud(30),
      O => \s_axi_bresp4_carry__2_i_1_n_0\
    );
\s_axi_bresp4_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[29]\,
      I1 => shadow_loud(29),
      I2 => \shadow_soft_reg_n_0_[28]\,
      I3 => shadow_loud(28),
      O => \s_axi_bresp4_carry__2_i_2_n_0\
    );
\s_axi_bresp4_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[27]\,
      I1 => shadow_loud(27),
      I2 => \shadow_soft_reg_n_0_[26]\,
      I3 => shadow_loud(26),
      O => \s_axi_bresp4_carry__2_i_3_n_0\
    );
\s_axi_bresp4_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[25]\,
      I1 => shadow_loud(25),
      I2 => \shadow_soft_reg_n_0_[24]\,
      I3 => shadow_loud(24),
      O => \s_axi_bresp4_carry__2_i_4_n_0\
    );
\s_axi_bresp4_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(31),
      I1 => \shadow_soft_reg_n_0_[31]\,
      I2 => shadow_loud(30),
      I3 => \shadow_soft_reg_n_0_[30]\,
      O => \s_axi_bresp4_carry__2_i_5_n_0\
    );
\s_axi_bresp4_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(29),
      I1 => \shadow_soft_reg_n_0_[29]\,
      I2 => shadow_loud(28),
      I3 => \shadow_soft_reg_n_0_[28]\,
      O => \s_axi_bresp4_carry__2_i_6_n_0\
    );
\s_axi_bresp4_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(27),
      I1 => \shadow_soft_reg_n_0_[27]\,
      I2 => shadow_loud(26),
      I3 => \shadow_soft_reg_n_0_[26]\,
      O => \s_axi_bresp4_carry__2_i_7_n_0\
    );
\s_axi_bresp4_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(25),
      I1 => \shadow_soft_reg_n_0_[25]\,
      I2 => shadow_loud(24),
      I3 => \shadow_soft_reg_n_0_[24]\,
      O => \s_axi_bresp4_carry__2_i_8_n_0\
    );
s_axi_bresp4_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[7]\,
      I1 => shadow_loud(7),
      I2 => \shadow_soft_reg_n_0_[6]\,
      I3 => shadow_loud(6),
      O => s_axi_bresp4_carry_i_1_n_0
    );
s_axi_bresp4_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[5]\,
      I1 => shadow_loud(5),
      I2 => \shadow_soft_reg_n_0_[4]\,
      I3 => shadow_loud(4),
      O => s_axi_bresp4_carry_i_2_n_0
    );
s_axi_bresp4_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[3]\,
      I1 => shadow_loud(3),
      I2 => \shadow_soft_reg_n_0_[2]\,
      I3 => shadow_loud(2),
      O => s_axi_bresp4_carry_i_3_n_0
    );
s_axi_bresp4_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[1]\,
      I1 => shadow_loud(1),
      I2 => \shadow_soft_reg_n_0_[0]\,
      I3 => shadow_loud(0),
      O => s_axi_bresp4_carry_i_4_n_0
    );
s_axi_bresp4_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(7),
      I1 => \shadow_soft_reg_n_0_[7]\,
      I2 => shadow_loud(6),
      I3 => \shadow_soft_reg_n_0_[6]\,
      O => s_axi_bresp4_carry_i_5_n_0
    );
s_axi_bresp4_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(5),
      I1 => \shadow_soft_reg_n_0_[5]\,
      I2 => shadow_loud(4),
      I3 => \shadow_soft_reg_n_0_[4]\,
      O => s_axi_bresp4_carry_i_6_n_0
    );
s_axi_bresp4_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(3),
      I1 => \shadow_soft_reg_n_0_[3]\,
      I2 => shadow_loud(2),
      I3 => \shadow_soft_reg_n_0_[2]\,
      O => s_axi_bresp4_carry_i_7_n_0
    );
s_axi_bresp4_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => shadow_loud(1),
      I1 => \shadow_soft_reg_n_0_[1]\,
      I2 => shadow_loud(0),
      I3 => \shadow_soft_reg_n_0_[0]\,
      O => s_axi_bresp4_carry_i_8_n_0
    );
\s_axi_bresp[1]_i_10\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => write_data(1),
      I1 => write_data(2),
      I2 => write_data(0),
      O => \s_axi_bresp[1]_i_10_n_0\
    );
\s_axi_bresp[1]_i_11\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => write_data(16),
      I1 => write_data(23),
      I2 => write_data(21),
      I3 => write_data(28),
      O => \s_axi_bresp[1]_i_11_n_0\
    );
\s_axi_bresp[1]_i_12\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => write_data(12),
      I1 => write_data(5),
      I2 => write_data(31),
      I3 => write_data(29),
      I4 => \s_axi_bresp[1]_i_14_n_0\,
      O => \s_axi_bresp[1]_i_12_n_0\
    );
\s_axi_bresp[1]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_15_n_0\,
      I1 => \s_axi_bresp[1]_i_16_n_0\,
      I2 => write_data(18),
      I3 => write_data(27),
      I4 => write_data(6),
      I5 => write_data(7),
      O => \s_axi_bresp[1]_i_13_n_0\
    );
\s_axi_bresp[1]_i_14\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => write_data(14),
      I1 => write_data(22),
      I2 => write_data(19),
      I3 => write_data(26),
      O => \s_axi_bresp[1]_i_14_n_0\
    );
\s_axi_bresp[1]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => write_data(3),
      I1 => write_data(30),
      I2 => write_data(20),
      I3 => write_data(13),
      I4 => write_data(24),
      I5 => write_data(10),
      O => \s_axi_bresp[1]_i_15_n_0\
    );
\s_axi_bresp[1]_i_16\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => write_data(9),
      I1 => write_data(25),
      I2 => write_data(8),
      I3 => write_data(11),
      O => \s_axi_bresp[1]_i_16_n_0\
    );
\s_axi_bresp[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AEFFFFFFAEFF0000"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_3_n_0\,
      I1 => \s_axi_bresp[1]_i_4_n_0\,
      I2 => \s_axi_bresp[1]_i_5_n_0\,
      I3 => \s_axi_bresp[1]_i_6_n_0\,
      I4 => aw_held09_out,
      I5 => \^s_axi_bresp\(0),
      O => \s_axi_bresp[1]_i_2_n_0\
    );
\s_axi_bresp[1]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_8_n_0\,
      I1 => write_address(9),
      I2 => write_address(10),
      I3 => write_address(8),
      I4 => write_address(0),
      I5 => write_address(1),
      O => \s_axi_bresp[1]_i_3_n_0\
    );
\s_axi_bresp[1]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF00000000888A"
    )
        port map (
      I0 => write_address(4),
      I1 => \s_axi_bresp[1]_i_9_n_0\,
      I2 => \soft_sum[31]_i_3_n_0\,
      I3 => \s_axi_bresp[1]_i_10_n_0\,
      I4 => write_address(3),
      I5 => write_address(2),
      O => \s_axi_bresp[1]_i_4_n_0\
    );
\s_axi_bresp[1]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \shadow_enable[31]_i_2_n_0\,
      I1 => write_address(4),
      O => \s_axi_bresp[1]_i_5_n_0\
    );
\s_axi_bresp[1]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"1000000000000000"
    )
        port map (
      I0 => write_address(0),
      I1 => write_address(1),
      I2 => write_strobe(0),
      I3 => write_strobe(1),
      I4 => write_strobe(3),
      I5 => write_strobe(2),
      O => \s_axi_bresp[1]_i_6_n_0\
    );
\s_axi_bresp[1]_i_7\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => aw_held,
      I1 => w_held_reg_n_0,
      I2 => \^s_axi_bvalid_reg_0\,
      O => aw_held09_out
    );
\s_axi_bresp[1]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFD"
    )
        port map (
      I0 => write_address(5),
      I1 => write_address(7),
      I2 => write_address(11),
      I3 => write_address(6),
      O => \s_axi_bresp[1]_i_8_n_0\
    );
\s_axi_bresp[1]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => write_data(17),
      I1 => write_data(15),
      I2 => write_data(4),
      I3 => \s_axi_bresp[1]_i_11_n_0\,
      I4 => \s_axi_bresp[1]_i_12_n_0\,
      I5 => \s_axi_bresp[1]_i_13_n_0\,
      O => \s_axi_bresp[1]_i_9_n_0\
    );
\s_axi_bresp_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \s_axi_bresp[1]_i_2_n_0\,
      Q => \^s_axi_bresp\(0),
      R => \^sr\(0)
    );
s_axi_bvalid_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7444"
    )
        port map (
      I0 => s_axi_bready,
      I1 => \^s_axi_bvalid_reg_0\,
      I2 => w_held_reg_n_0,
      I3 => aw_held,
      O => s_axi_bvalid_i_1_n_0
    );
s_axi_bvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => s_axi_bvalid_i_1_n_0,
      Q => \^s_axi_bvalid_reg_0\,
      R => \^sr\(0)
    );
\s_axi_rdata[0]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(0),
      I1 => \snapshot_reg[6]\(0),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(0),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(0),
      O => \s_axi_rdata[0]_i_10_n_0\
    );
\s_axi_rdata[0]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[11]\(0),
      I1 => \snapshot_reg[10]\(0),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[9]\(0),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[8]\(0),
      O => \s_axi_rdata[0]_i_11_n_0\
    );
\s_axi_rdata[0]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(0),
      I1 => \snapshot_reg[14]\(0),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(0),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(0),
      O => \s_axi_rdata[0]_i_12_n_0\
    );
\s_axi_rdata[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(0),
      I1 => shadow_quiet(0),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[0]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[0]\,
      O => \s_axi_rdata[0]_i_2_n_0\
    );
\s_axi_rdata[0]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFAFCFC0AFA0CFC0"
    )
        port map (
      I0 => \ack_sequence_reg_n_0_[0]\,
      I1 => snapshot_sequence_reg(0),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \s_axi_rdata[0]_i_5_n_0\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => snapshot_valid,
      O => \s_axi_rdata[0]_i_3_n_0\
    );
\s_axi_rdata[0]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8080808A808"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \snapshot_reg[16]\(0),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rdata_reg[0]_i_7_n_0\,
      I4 => s_axi_araddr(5),
      I5 => \s_axi_rdata_reg[0]_i_8_n_0\,
      O => \s_axi_rdata[0]_i_5_n_0\
    );
\s_axi_rdata[0]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[3]\(0),
      I1 => \snapshot_reg[2]\(0),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[1]\(0),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[0]\(0),
      O => \s_axi_rdata[0]_i_9_n_0\
    );
\s_axi_rdata[10]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(10),
      I1 => \snapshot_reg[6]\(10),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(10),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(10),
      O => \s_axi_rdata[10]_i_10_n_0\
    );
\s_axi_rdata[10]_i_11\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[11]\(10),
      I1 => \snapshot_reg[10]\(10),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[8]\(10),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[10]_i_11_n_0\
    );
\s_axi_rdata[10]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(10),
      I1 => \snapshot_reg[14]\(10),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(10),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(10),
      O => \s_axi_rdata[10]_i_12_n_0\
    );
\s_axi_rdata[10]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFD5D5555"
    )
        port map (
      I0 => \s_axi_rdata[10]_i_5_n_0\,
      I1 => snapshot_sequence_reg(10),
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => \ack_sequence_reg_n_0_[10]\,
      I4 => \s_axi_rdata[31]_i_10_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[10]_i_2_n_0\
    );
\s_axi_rdata[10]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"505F3030505F3F3F"
    )
        port map (
      I0 => shadow_loud(10),
      I1 => shadow_quiet(10),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[10]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[10]\,
      O => \s_axi_rdata[10]_i_3_n_0\
    );
\s_axi_rdata[10]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"575757F7F7F757F7"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \snapshot_reg[16]\(10),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rdata_reg[10]_i_7_n_0\,
      I4 => s_axi_araddr(5),
      I5 => \s_axi_rdata_reg[10]_i_8_n_0\,
      O => \s_axi_rdata[10]_i_5_n_0\
    );
\s_axi_rdata[10]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F1FD"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[10]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(10),
      O => \s_axi_rdata[10]_i_6_n_0\
    );
\s_axi_rdata[10]_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[3]\(10),
      I1 => \snapshot_reg[2]\(10),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[0]\(10),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[10]_i_9_n_0\
    );
\s_axi_rdata[11]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"888888888A8A888A"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[11]_i_2_n_0\,
      I2 => \s_axi_rdata[11]_i_3_n_0\,
      I3 => \s_axi_rdata[31]_i_4_n_0\,
      I4 => \s_axi_rdata[11]_i_4_n_0\,
      I5 => \s_axi_rdata[31]_i_7_n_0\,
      O => \s_axi_rdata[11]_i_1_n_0\
    );
\s_axi_rdata[11]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(11),
      I1 => \snapshot_reg[6]\(11),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(11),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(11),
      O => \s_axi_rdata[11]_i_10_n_0\
    );
\s_axi_rdata[11]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"C0C000000E020000"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[11]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(11),
      I4 => \s_axi_rdata[31]_i_7_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[11]_i_2_n_0\
    );
\s_axi_rdata[11]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000DDDF"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \s_axi_rdata[11]_i_5_n_0\,
      I2 => \snapshot_reg[16]\(11),
      I3 => s_axi_araddr(6),
      I4 => \s_axi_rdata[11]_i_6_n_0\,
      O => \s_axi_rdata[11]_i_3_n_0\
    );
\s_axi_rdata[11]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(11),
      I1 => shadow_quiet(11),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[11]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[11]\,
      O => \s_axi_rdata[11]_i_4_n_0\
    );
\s_axi_rdata[11]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2EEE222200000000"
    )
        port map (
      I0 => \s_axi_rdata[11]_i_7_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[11]_i_8_n_0\,
      I3 => s_axi_araddr(4),
      I4 => \s_axi_rdata[11]_i_9_n_0\,
      I5 => s_axi_araddr(6),
      O => \s_axi_rdata[11]_i_5_n_0\
    );
\s_axi_rdata[11]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EAEEEAAA"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \ack_sequence_reg_n_0_[11]\,
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => snapshot_sequence_reg(11),
      O => \s_axi_rdata[11]_i_6_n_0\
    );
\s_axi_rdata[11]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4747477777774777"
    )
        port map (
      I0 => \s_axi_rdata[11]_i_10_n_0\,
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[2]\(11),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[3]\(11),
      O => \s_axi_rdata[11]_i_7_n_0\
    );
\s_axi_rdata[11]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(11),
      I1 => \snapshot_reg[14]\(11),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(11),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(11),
      O => \s_axi_rdata[11]_i_8_n_0\
    );
\s_axi_rdata[11]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEFBBEFEEEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[8]\(11),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[10]\(11),
      I5 => \snapshot_reg[11]\(11),
      O => \s_axi_rdata[11]_i_9_n_0\
    );
\s_axi_rdata[12]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00200A2A00200222"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_7_n_0\,
      I3 => \s_axi_rdata[12]_i_2_n_0\,
      I4 => \s_axi_rdata[12]_i_3_n_0\,
      I5 => \s_axi_rdata[12]_i_4_n_0\,
      O => \s_axi_rdata[12]_i_1_n_0\
    );
\s_axi_rdata[12]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(12),
      I1 => \snapshot_reg[14]\(12),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(12),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(12),
      O => \s_axi_rdata[12]_i_10_n_0\
    );
\s_axi_rdata[12]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F1FD"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[12]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(12),
      O => \s_axi_rdata[12]_i_2_n_0\
    );
\s_axi_rdata[12]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000002A2AAAA"
    )
        port map (
      I0 => \s_axi_rdata[12]_i_5_n_0\,
      I1 => snapshot_sequence_reg(12),
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => \ack_sequence_reg_n_0_[12]\,
      I4 => \s_axi_rdata[31]_i_10_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[12]_i_3_n_0\
    );
\s_axi_rdata[12]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(12),
      I1 => shadow_quiet(12),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[12]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[12]\,
      O => \s_axi_rdata[12]_i_4_n_0\
    );
\s_axi_rdata[12]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"575757F7F7F757F7"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \snapshot_reg[16]\(12),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rdata[12]_i_6_n_0\,
      I4 => s_axi_araddr(5),
      I5 => \s_axi_rdata_reg[12]_i_7_n_0\,
      O => \s_axi_rdata[12]_i_5_n_0\
    );
\s_axi_rdata[12]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBB888B888888888"
    )
        port map (
      I0 => \s_axi_rdata[12]_i_8_n_0\,
      I1 => s_axi_araddr(4),
      I2 => \snapshot_reg[2]\(12),
      I3 => s_axi_araddr(2),
      I4 => \snapshot_reg[3]\(12),
      I5 => s_axi_araddr(3),
      O => \s_axi_rdata[12]_i_6_n_0\
    );
\s_axi_rdata[12]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(12),
      I1 => \snapshot_reg[6]\(12),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(12),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(12),
      O => \s_axi_rdata[12]_i_8_n_0\
    );
\s_axi_rdata[12]_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[11]\(12),
      I1 => \snapshot_reg[10]\(12),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[8]\(12),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[12]_i_9_n_0\
    );
\s_axi_rdata[13]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000A2222200A2"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[13]_i_2_n_0\,
      I3 => \s_axi_rdata[13]_i_3_n_0\,
      I4 => \s_axi_rdata[31]_i_7_n_0\,
      I5 => \s_axi_rdata[13]_i_4_n_0\,
      O => \s_axi_rdata[13]_i_1_n_0\
    );
\s_axi_rdata[13]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(13),
      I1 => \snapshot_reg[6]\(13),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(13),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(13),
      O => \s_axi_rdata[13]_i_10_n_0\
    );
\s_axi_rdata[13]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(13),
      I1 => shadow_quiet(13),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[13]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[13]\,
      O => \s_axi_rdata[13]_i_2_n_0\
    );
\s_axi_rdata[13]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000DDDF"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \s_axi_rdata[13]_i_5_n_0\,
      I2 => \snapshot_reg[16]\(13),
      I3 => s_axi_araddr(6),
      I4 => \s_axi_rdata[13]_i_6_n_0\,
      O => \s_axi_rdata[13]_i_3_n_0\
    );
\s_axi_rdata[13]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F1FD"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[13]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(13),
      O => \s_axi_rdata[13]_i_4_n_0\
    );
\s_axi_rdata[13]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2EEE222200000000"
    )
        port map (
      I0 => \s_axi_rdata[13]_i_7_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[13]_i_8_n_0\,
      I3 => s_axi_araddr(4),
      I4 => \s_axi_rdata[13]_i_9_n_0\,
      I5 => s_axi_araddr(6),
      O => \s_axi_rdata[13]_i_5_n_0\
    );
\s_axi_rdata[13]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EAEEEAAA"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \ack_sequence_reg_n_0_[13]\,
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => snapshot_sequence_reg(13),
      O => \s_axi_rdata[13]_i_6_n_0\
    );
\s_axi_rdata[13]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000057F7FFFF57F7"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => \snapshot_reg[2]\(13),
      I2 => s_axi_araddr(2),
      I3 => \snapshot_reg[3]\(13),
      I4 => s_axi_araddr(4),
      I5 => \s_axi_rdata[13]_i_10_n_0\,
      O => \s_axi_rdata[13]_i_7_n_0\
    );
\s_axi_rdata[13]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(13),
      I1 => \snapshot_reg[14]\(13),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(13),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(13),
      O => \s_axi_rdata[13]_i_8_n_0\
    );
\s_axi_rdata[13]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEFBBEFEEEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[8]\(13),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[10]\(13),
      I5 => \snapshot_reg[11]\(13),
      O => \s_axi_rdata[13]_i_9_n_0\
    );
\s_axi_rdata[14]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"888888888A8A888A"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[14]_i_2_n_0\,
      I2 => \s_axi_rdata[14]_i_3_n_0\,
      I3 => \s_axi_rdata[31]_i_4_n_0\,
      I4 => \s_axi_rdata[14]_i_4_n_0\,
      I5 => \s_axi_rdata[31]_i_7_n_0\,
      O => \s_axi_rdata[14]_i_1_n_0\
    );
\s_axi_rdata[14]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(14),
      I1 => \snapshot_reg[6]\(14),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(14),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(14),
      O => \s_axi_rdata[14]_i_10_n_0\
    );
\s_axi_rdata[14]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"C0C000000E020000"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[14]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(14),
      I4 => \s_axi_rdata[31]_i_7_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[14]_i_2_n_0\
    );
\s_axi_rdata[14]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000DDDF"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \s_axi_rdata[14]_i_5_n_0\,
      I2 => \snapshot_reg[16]\(14),
      I3 => s_axi_araddr(6),
      I4 => \s_axi_rdata[14]_i_6_n_0\,
      O => \s_axi_rdata[14]_i_3_n_0\
    );
\s_axi_rdata[14]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(14),
      I1 => shadow_quiet(14),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[14]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[14]\,
      O => \s_axi_rdata[14]_i_4_n_0\
    );
\s_axi_rdata[14]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2EEE222200000000"
    )
        port map (
      I0 => \s_axi_rdata[14]_i_7_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[14]_i_8_n_0\,
      I3 => s_axi_araddr(4),
      I4 => \s_axi_rdata[14]_i_9_n_0\,
      I5 => s_axi_araddr(6),
      O => \s_axi_rdata[14]_i_5_n_0\
    );
\s_axi_rdata[14]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EAEEEAAA"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \ack_sequence_reg_n_0_[14]\,
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => snapshot_sequence_reg(14),
      O => \s_axi_rdata[14]_i_6_n_0\
    );
\s_axi_rdata[14]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000057F7FFFF57F7"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => \snapshot_reg[2]\(14),
      I2 => s_axi_araddr(2),
      I3 => \snapshot_reg[3]\(14),
      I4 => s_axi_araddr(4),
      I5 => \s_axi_rdata[14]_i_10_n_0\,
      O => \s_axi_rdata[14]_i_7_n_0\
    );
\s_axi_rdata[14]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(14),
      I1 => \snapshot_reg[14]\(14),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(14),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(14),
      O => \s_axi_rdata[14]_i_8_n_0\
    );
\s_axi_rdata[14]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEFBBEFEEEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[8]\(14),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[10]\(14),
      I5 => \snapshot_reg[11]\(14),
      O => \s_axi_rdata[14]_i_9_n_0\
    );
\s_axi_rdata[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00200A2A00200222"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_7_n_0\,
      I3 => \s_axi_rdata[15]_i_2_n_0\,
      I4 => \s_axi_rdata[15]_i_3_n_0\,
      I5 => \s_axi_rdata[15]_i_4_n_0\,
      O => \s_axi_rdata[15]_i_1_n_0\
    );
\s_axi_rdata[15]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(15),
      I1 => \snapshot_reg[14]\(15),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(15),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(15),
      O => \s_axi_rdata[15]_i_10_n_0\
    );
\s_axi_rdata[15]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F1FD"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[15]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(15),
      O => \s_axi_rdata[15]_i_2_n_0\
    );
\s_axi_rdata[15]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000002A2AAAA"
    )
        port map (
      I0 => \s_axi_rdata[15]_i_5_n_0\,
      I1 => snapshot_sequence_reg(15),
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => \ack_sequence_reg_n_0_[15]\,
      I4 => \s_axi_rdata[31]_i_10_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[15]_i_3_n_0\
    );
\s_axi_rdata[15]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(15),
      I1 => shadow_quiet(15),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[15]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[15]\,
      O => \s_axi_rdata[15]_i_4_n_0\
    );
\s_axi_rdata[15]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"575757F7F7F757F7"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \snapshot_reg[16]\(15),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rdata[15]_i_6_n_0\,
      I4 => s_axi_araddr(5),
      I5 => \s_axi_rdata_reg[15]_i_7_n_0\,
      O => \s_axi_rdata[15]_i_5_n_0\
    );
\s_axi_rdata[15]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBB888B888888888"
    )
        port map (
      I0 => \s_axi_rdata[15]_i_8_n_0\,
      I1 => s_axi_araddr(4),
      I2 => \snapshot_reg[2]\(15),
      I3 => s_axi_araddr(2),
      I4 => \snapshot_reg[3]\(15),
      I5 => s_axi_araddr(3),
      O => \s_axi_rdata[15]_i_6_n_0\
    );
\s_axi_rdata[15]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(15),
      I1 => \snapshot_reg[6]\(15),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(15),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(15),
      O => \s_axi_rdata[15]_i_8_n_0\
    );
\s_axi_rdata[15]_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[11]\(15),
      I1 => \snapshot_reg[10]\(15),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[8]\(15),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[15]_i_9_n_0\
    );
\s_axi_rdata[16]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFB80000"
    )
        port map (
      I0 => \s_axi_rdata[16]_i_2_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[16]_i_3_n_0\,
      I3 => \s_axi_rdata[31]_i_7_n_0\,
      I4 => \s_axi_rdata[31]_i_3_n_0\,
      I5 => \s_axi_rdata[16]_i_4_n_0\,
      O => \s_axi_rdata[16]_i_1_n_0\
    );
\s_axi_rdata[16]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(16),
      I1 => \snapshot_reg[6]\(16),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(16),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(16),
      O => \s_axi_rdata[16]_i_10_n_0\
    );
\s_axi_rdata[16]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(16),
      I1 => shadow_quiet(16),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[16]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[16]\,
      O => \s_axi_rdata[16]_i_2_n_0\
    );
\s_axi_rdata[16]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF5400"
    )
        port map (
      I0 => \s_axi_rdata[16]_i_5_n_0\,
      I1 => \snapshot_reg[16]\(16),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rresp[1]_i_3_n_0\,
      I4 => \s_axi_rdata[16]_i_6_n_0\,
      O => \s_axi_rdata[16]_i_3_n_0\
    );
\s_axi_rdata[16]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000FF00FF001D00"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[16]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => config_epoch_reg(16),
      I3 => \s_axi_rdata[31]_i_7_n_0\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[16]_i_4_n_0\
    );
\s_axi_rdata[16]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2EEE222200000000"
    )
        port map (
      I0 => \s_axi_rdata[16]_i_7_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[16]_i_8_n_0\,
      I3 => s_axi_araddr(4),
      I4 => \s_axi_rdata[16]_i_9_n_0\,
      I5 => s_axi_araddr(6),
      O => \s_axi_rdata[16]_i_5_n_0\
    );
\s_axi_rdata[16]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => snapshot_sequence_reg(16),
      I1 => \s_axi_rdata[31]_i_11_n_0\,
      I2 => \ack_sequence_reg_n_0_[16]\,
      I3 => \s_axi_rdata[31]_i_10_n_0\,
      O => \s_axi_rdata[16]_i_6_n_0\
    );
\s_axi_rdata[16]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4747477777774777"
    )
        port map (
      I0 => \s_axi_rdata[16]_i_10_n_0\,
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[2]\(16),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[3]\(16),
      O => \s_axi_rdata[16]_i_7_n_0\
    );
\s_axi_rdata[16]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(16),
      I1 => \snapshot_reg[14]\(16),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(16),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(16),
      O => \s_axi_rdata[16]_i_8_n_0\
    );
\s_axi_rdata[16]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEFBBEFEEEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[8]\(16),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[10]\(16),
      I5 => \snapshot_reg[11]\(16),
      O => \s_axi_rdata[16]_i_9_n_0\
    );
\s_axi_rdata[17]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8A8A8A8888888A88"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[17]_i_2_n_0\,
      I2 => \s_axi_rdata[31]_i_7_n_0\,
      I3 => \s_axi_rdata[17]_i_3_n_0\,
      I4 => \s_axi_rdata[31]_i_4_n_0\,
      I5 => \s_axi_rdata[17]_i_4_n_0\,
      O => \s_axi_rdata[17]_i_1_n_0\
    );
\s_axi_rdata[17]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(17),
      I1 => \snapshot_reg[14]\(17),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(17),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(17),
      O => \s_axi_rdata[17]_i_10_n_0\
    );
\s_axi_rdata[17]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"C0C000000E020000"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[17]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(17),
      I4 => \s_axi_rdata[31]_i_7_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[17]_i_2_n_0\
    );
\s_axi_rdata[17]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"8A80FFFF"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_10_n_0\,
      I1 => \ack_sequence_reg_n_0_[17]\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => snapshot_sequence_reg(17),
      I4 => \s_axi_rdata[17]_i_5_n_0\,
      O => \s_axi_rdata[17]_i_3_n_0\
    );
\s_axi_rdata[17]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(17),
      I1 => shadow_quiet(17),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[17]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[17]\,
      O => \s_axi_rdata[17]_i_4_n_0\
    );
\s_axi_rdata[17]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"575757F7F7F757F7"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \snapshot_reg[16]\(17),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rdata[17]_i_6_n_0\,
      I4 => s_axi_araddr(5),
      I5 => \s_axi_rdata_reg[17]_i_7_n_0\,
      O => \s_axi_rdata[17]_i_5_n_0\
    );
\s_axi_rdata[17]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBB888B888888888"
    )
        port map (
      I0 => \s_axi_rdata[17]_i_8_n_0\,
      I1 => s_axi_araddr(4),
      I2 => \snapshot_reg[2]\(17),
      I3 => s_axi_araddr(2),
      I4 => \snapshot_reg[3]\(17),
      I5 => s_axi_araddr(3),
      O => \s_axi_rdata[17]_i_6_n_0\
    );
\s_axi_rdata[17]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(17),
      I1 => \snapshot_reg[6]\(17),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(17),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(17),
      O => \s_axi_rdata[17]_i_8_n_0\
    );
\s_axi_rdata[17]_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[11]\(17),
      I1 => \snapshot_reg[10]\(17),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[8]\(17),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[17]_i_9_n_0\
    );
\s_axi_rdata[18]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFB80000"
    )
        port map (
      I0 => \s_axi_rdata[18]_i_2_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[18]_i_3_n_0\,
      I3 => \s_axi_rdata[31]_i_7_n_0\,
      I4 => \s_axi_rdata[31]_i_3_n_0\,
      I5 => \s_axi_rdata[18]_i_4_n_0\,
      O => \s_axi_rdata[18]_i_1_n_0\
    );
\s_axi_rdata[18]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(18),
      I1 => \snapshot_reg[6]\(18),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(18),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(18),
      O => \s_axi_rdata[18]_i_10_n_0\
    );
\s_axi_rdata[18]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(18),
      I1 => shadow_quiet(18),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[18]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[18]\,
      O => \s_axi_rdata[18]_i_2_n_0\
    );
\s_axi_rdata[18]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF5400"
    )
        port map (
      I0 => \s_axi_rdata[18]_i_5_n_0\,
      I1 => \snapshot_reg[16]\(18),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rresp[1]_i_3_n_0\,
      I4 => \s_axi_rdata[18]_i_6_n_0\,
      O => \s_axi_rdata[18]_i_3_n_0\
    );
\s_axi_rdata[18]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0A0A0A0AAA02AAA2"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_7_n_0\,
      I1 => \shadow_soft_reg_n_0_[18]\,
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => config_epoch_reg(18),
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[18]_i_4_n_0\
    );
\s_axi_rdata[18]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2EEE222200000000"
    )
        port map (
      I0 => \s_axi_rdata[18]_i_7_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[18]_i_8_n_0\,
      I3 => s_axi_araddr(4),
      I4 => \s_axi_rdata[18]_i_9_n_0\,
      I5 => s_axi_araddr(6),
      O => \s_axi_rdata[18]_i_5_n_0\
    );
\s_axi_rdata[18]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => snapshot_sequence_reg(18),
      I1 => \s_axi_rdata[31]_i_11_n_0\,
      I2 => \ack_sequence_reg_n_0_[18]\,
      I3 => \s_axi_rdata[31]_i_10_n_0\,
      O => \s_axi_rdata[18]_i_6_n_0\
    );
\s_axi_rdata[18]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000057F7FFFF57F7"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => \snapshot_reg[2]\(18),
      I2 => s_axi_araddr(2),
      I3 => \snapshot_reg[3]\(18),
      I4 => s_axi_araddr(4),
      I5 => \s_axi_rdata[18]_i_10_n_0\,
      O => \s_axi_rdata[18]_i_7_n_0\
    );
\s_axi_rdata[18]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(18),
      I1 => \snapshot_reg[14]\(18),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(18),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(18),
      O => \s_axi_rdata[18]_i_8_n_0\
    );
\s_axi_rdata[18]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEFBBEFEEEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[8]\(18),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[10]\(18),
      I5 => \snapshot_reg[11]\(18),
      O => \s_axi_rdata[18]_i_9_n_0\
    );
\s_axi_rdata[19]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFB80000"
    )
        port map (
      I0 => \s_axi_rdata[19]_i_2_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[19]_i_3_n_0\,
      I3 => \s_axi_rdata[31]_i_7_n_0\,
      I4 => \s_axi_rdata[31]_i_3_n_0\,
      I5 => \s_axi_rdata[19]_i_4_n_0\,
      O => \s_axi_rdata[19]_i_1_n_0\
    );
\s_axi_rdata[19]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(19),
      I1 => \snapshot_reg[6]\(19),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(19),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(19),
      O => \s_axi_rdata[19]_i_10_n_0\
    );
\s_axi_rdata[19]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(19),
      I1 => shadow_quiet(19),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[19]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[19]\,
      O => \s_axi_rdata[19]_i_2_n_0\
    );
\s_axi_rdata[19]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF5400"
    )
        port map (
      I0 => \s_axi_rdata[19]_i_5_n_0\,
      I1 => \snapshot_reg[16]\(19),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rresp[1]_i_3_n_0\,
      I4 => \s_axi_rdata[19]_i_6_n_0\,
      O => \s_axi_rdata[19]_i_3_n_0\
    );
\s_axi_rdata[19]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0A0A0A0AAA02AAA2"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_7_n_0\,
      I1 => \shadow_soft_reg_n_0_[19]\,
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => config_epoch_reg(19),
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[19]_i_4_n_0\
    );
\s_axi_rdata[19]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2EEE222200000000"
    )
        port map (
      I0 => \s_axi_rdata[19]_i_7_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[19]_i_8_n_0\,
      I3 => s_axi_araddr(4),
      I4 => \s_axi_rdata[19]_i_9_n_0\,
      I5 => s_axi_araddr(6),
      O => \s_axi_rdata[19]_i_5_n_0\
    );
\s_axi_rdata[19]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => snapshot_sequence_reg(19),
      I1 => \s_axi_rdata[31]_i_11_n_0\,
      I2 => \ack_sequence_reg_n_0_[19]\,
      I3 => \s_axi_rdata[31]_i_10_n_0\,
      O => \s_axi_rdata[19]_i_6_n_0\
    );
\s_axi_rdata[19]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000057F7FFFF57F7"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => \snapshot_reg[2]\(19),
      I2 => s_axi_araddr(2),
      I3 => \snapshot_reg[3]\(19),
      I4 => s_axi_araddr(4),
      I5 => \s_axi_rdata[19]_i_10_n_0\,
      O => \s_axi_rdata[19]_i_7_n_0\
    );
\s_axi_rdata[19]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(19),
      I1 => \snapshot_reg[14]\(19),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(19),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(19),
      O => \s_axi_rdata[19]_i_8_n_0\
    );
\s_axi_rdata[19]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEFBBEFEEEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[8]\(19),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[10]\(19),
      I5 => \snapshot_reg[11]\(19),
      O => \s_axi_rdata[19]_i_9_n_0\
    );
\s_axi_rdata[1]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(1),
      I1 => \snapshot_reg[14]\(1),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(1),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(1),
      O => \s_axi_rdata[1]_i_10_n_0\
    );
\s_axi_rdata[1]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[3]\(1),
      I1 => \snapshot_reg[2]\(1),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[1]\(1),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[0]\(1),
      O => \s_axi_rdata[1]_i_11_n_0\
    );
\s_axi_rdata[1]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(1),
      I1 => \snapshot_reg[6]\(1),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(1),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(1),
      O => \s_axi_rdata[1]_i_12_n_0\
    );
\s_axi_rdata[1]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF8A808A808A80"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_10_n_0\,
      I1 => \ack_sequence_reg_n_0_[1]\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => snapshot_sequence_reg(1),
      I4 => \s_axi_rdata[1]_i_6_n_0\,
      I5 => \s_axi_rresp[1]_i_3_n_0\,
      O => \s_axi_rdata[1]_i_3_n_0\
    );
\s_axi_rdata[1]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(1),
      I1 => shadow_quiet(1),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[1]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[1]\,
      O => \s_axi_rdata[1]_i_4_n_0\
    );
\s_axi_rdata[1]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8FFB800"
    )
        port map (
      I0 => \s_axi_rdata_reg[1]_i_7_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata_reg[1]_i_8_n_0\,
      I3 => s_axi_araddr(6),
      I4 => \snapshot_reg[16]\(1),
      O => \s_axi_rdata[1]_i_6_n_0\
    );
\s_axi_rdata[1]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[11]\(1),
      I1 => \snapshot_reg[10]\(1),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[9]\(1),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[8]\(1),
      O => \s_axi_rdata[1]_i_9_n_0\
    );
\s_axi_rdata[20]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00200A2A00200222"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_7_n_0\,
      I3 => \s_axi_rdata[20]_i_2_n_0\,
      I4 => \s_axi_rdata[20]_i_3_n_0\,
      I5 => \s_axi_rdata[20]_i_4_n_0\,
      O => \s_axi_rdata[20]_i_1_n_0\
    );
\s_axi_rdata[20]_i_10\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF35FF"
    )
        port map (
      I0 => \snapshot_reg[2]\(20),
      I1 => \snapshot_reg[3]\(20),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      O => \s_axi_rdata[20]_i_10_n_0\
    );
\s_axi_rdata[20]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F1FD"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[20]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(20),
      O => \s_axi_rdata[20]_i_2_n_0\
    );
\s_axi_rdata[20]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"000047FF"
    )
        port map (
      I0 => \s_axi_rdata[20]_i_5_n_0\,
      I1 => s_axi_araddr(6),
      I2 => \snapshot_reg[16]\(20),
      I3 => \s_axi_rresp[1]_i_3_n_0\,
      I4 => \s_axi_rdata[20]_i_6_n_0\,
      O => \s_axi_rdata[20]_i_3_n_0\
    );
\s_axi_rdata[20]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(20),
      I1 => shadow_quiet(20),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[20]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[20]\,
      O => \s_axi_rdata[20]_i_4_n_0\
    );
\s_axi_rdata[20]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BF30B030BF3FBF3F"
    )
        port map (
      I0 => \s_axi_rdata[20]_i_7_n_0\,
      I1 => \s_axi_rdata[20]_i_8_n_0\,
      I2 => s_axi_araddr(5),
      I3 => s_axi_araddr(4),
      I4 => \s_axi_rdata[20]_i_9_n_0\,
      I5 => \s_axi_rdata[20]_i_10_n_0\,
      O => \s_axi_rdata[20]_i_5_n_0\
    );
\s_axi_rdata[20]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EAEEEAAA"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \ack_sequence_reg_n_0_[20]\,
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => snapshot_sequence_reg(20),
      O => \s_axi_rdata[20]_i_6_n_0\
    );
\s_axi_rdata[20]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(20),
      I1 => \snapshot_reg[14]\(20),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(20),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(20),
      O => \s_axi_rdata[20]_i_7_n_0\
    );
\s_axi_rdata[20]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEFBBEFEEEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[8]\(20),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[10]\(20),
      I5 => \snapshot_reg[11]\(20),
      O => \s_axi_rdata[20]_i_8_n_0\
    );
\s_axi_rdata[20]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(20),
      I1 => \snapshot_reg[6]\(20),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(20),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(20),
      O => \s_axi_rdata[20]_i_9_n_0\
    );
\s_axi_rdata[21]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00200A2A00200222"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_7_n_0\,
      I3 => \s_axi_rdata[21]_i_2_n_0\,
      I4 => \s_axi_rdata[21]_i_3_n_0\,
      I5 => \s_axi_rdata[21]_i_4_n_0\,
      O => \s_axi_rdata[21]_i_1_n_0\
    );
\s_axi_rdata[21]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(21),
      I1 => \snapshot_reg[6]\(21),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(21),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(21),
      O => \s_axi_rdata[21]_i_10_n_0\
    );
\s_axi_rdata[21]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F1FD"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[21]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(21),
      O => \s_axi_rdata[21]_i_2_n_0\
    );
\s_axi_rdata[21]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000DDDF"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \s_axi_rdata[21]_i_5_n_0\,
      I2 => \snapshot_reg[16]\(21),
      I3 => s_axi_araddr(6),
      I4 => \s_axi_rdata[21]_i_6_n_0\,
      O => \s_axi_rdata[21]_i_3_n_0\
    );
\s_axi_rdata[21]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(21),
      I1 => shadow_quiet(21),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[21]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[21]\,
      O => \s_axi_rdata[21]_i_4_n_0\
    );
\s_axi_rdata[21]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2EEE222200000000"
    )
        port map (
      I0 => \s_axi_rdata[21]_i_7_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[21]_i_8_n_0\,
      I3 => s_axi_araddr(4),
      I4 => \s_axi_rdata[21]_i_9_n_0\,
      I5 => s_axi_araddr(6),
      O => \s_axi_rdata[21]_i_5_n_0\
    );
\s_axi_rdata[21]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EAEEEAAA"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \ack_sequence_reg_n_0_[21]\,
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => snapshot_sequence_reg(21),
      O => \s_axi_rdata[21]_i_6_n_0\
    );
\s_axi_rdata[21]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000057F7FFFF57F7"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => \snapshot_reg[2]\(21),
      I2 => s_axi_araddr(2),
      I3 => \snapshot_reg[3]\(21),
      I4 => s_axi_araddr(4),
      I5 => \s_axi_rdata[21]_i_10_n_0\,
      O => \s_axi_rdata[21]_i_7_n_0\
    );
\s_axi_rdata[21]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(21),
      I1 => \snapshot_reg[14]\(21),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(21),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(21),
      O => \s_axi_rdata[21]_i_8_n_0\
    );
\s_axi_rdata[21]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEFBBEFEEEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[8]\(21),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[10]\(21),
      I5 => \snapshot_reg[11]\(21),
      O => \s_axi_rdata[21]_i_9_n_0\
    );
\s_axi_rdata[22]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"888888888A8A888A"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[22]_i_2_n_0\,
      I2 => \s_axi_rdata[22]_i_3_n_0\,
      I3 => \s_axi_rdata[31]_i_4_n_0\,
      I4 => \s_axi_rdata[22]_i_4_n_0\,
      I5 => \s_axi_rdata[31]_i_7_n_0\,
      O => \s_axi_rdata[22]_i_1_n_0\
    );
\s_axi_rdata[22]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(22),
      I1 => \snapshot_reg[14]\(22),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(22),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(22),
      O => \s_axi_rdata[22]_i_10_n_0\
    );
\s_axi_rdata[22]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"C0C000000E020000"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[22]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(22),
      I4 => \s_axi_rdata[31]_i_7_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[22]_i_2_n_0\
    );
\s_axi_rdata[22]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000002A2AAAA"
    )
        port map (
      I0 => \s_axi_rdata[22]_i_5_n_0\,
      I1 => snapshot_sequence_reg(22),
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => \ack_sequence_reg_n_0_[22]\,
      I4 => \s_axi_rdata[31]_i_10_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[22]_i_3_n_0\
    );
\s_axi_rdata[22]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(22),
      I1 => shadow_quiet(22),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[22]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[22]\,
      O => \s_axi_rdata[22]_i_4_n_0\
    );
\s_axi_rdata[22]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"575757F7F7F757F7"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \snapshot_reg[16]\(22),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rdata[22]_i_6_n_0\,
      I4 => s_axi_araddr(5),
      I5 => \s_axi_rdata_reg[22]_i_7_n_0\,
      O => \s_axi_rdata[22]_i_5_n_0\
    );
\s_axi_rdata[22]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBB888B888888888"
    )
        port map (
      I0 => \s_axi_rdata[22]_i_8_n_0\,
      I1 => s_axi_araddr(4),
      I2 => \snapshot_reg[2]\(22),
      I3 => s_axi_araddr(2),
      I4 => \snapshot_reg[3]\(22),
      I5 => s_axi_araddr(3),
      O => \s_axi_rdata[22]_i_6_n_0\
    );
\s_axi_rdata[22]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(22),
      I1 => \snapshot_reg[6]\(22),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(22),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(22),
      O => \s_axi_rdata[22]_i_8_n_0\
    );
\s_axi_rdata[22]_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[11]\(22),
      I1 => \snapshot_reg[10]\(22),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[8]\(22),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[22]_i_9_n_0\
    );
\s_axi_rdata[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000A2222200A2"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[23]_i_2_n_0\,
      I3 => \s_axi_rdata[23]_i_3_n_0\,
      I4 => \s_axi_rdata[31]_i_7_n_0\,
      I5 => \s_axi_rdata[23]_i_4_n_0\,
      O => \s_axi_rdata[23]_i_1_n_0\
    );
\s_axi_rdata[23]_i_10\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF35FF"
    )
        port map (
      I0 => \snapshot_reg[2]\(23),
      I1 => \snapshot_reg[3]\(23),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      O => \s_axi_rdata[23]_i_10_n_0\
    );
\s_axi_rdata[23]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(23),
      I1 => shadow_quiet(23),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[23]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[23]\,
      O => \s_axi_rdata[23]_i_2_n_0\
    );
\s_axi_rdata[23]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"000047FF"
    )
        port map (
      I0 => \s_axi_rdata[23]_i_5_n_0\,
      I1 => s_axi_araddr(6),
      I2 => \snapshot_reg[16]\(23),
      I3 => \s_axi_rresp[1]_i_3_n_0\,
      I4 => \s_axi_rdata[23]_i_6_n_0\,
      O => \s_axi_rdata[23]_i_3_n_0\
    );
\s_axi_rdata[23]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F1FD"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[23]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(23),
      O => \s_axi_rdata[23]_i_4_n_0\
    );
\s_axi_rdata[23]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BF30B030BF3FBF3F"
    )
        port map (
      I0 => \s_axi_rdata[23]_i_7_n_0\,
      I1 => \s_axi_rdata[23]_i_8_n_0\,
      I2 => s_axi_araddr(5),
      I3 => s_axi_araddr(4),
      I4 => \s_axi_rdata[23]_i_9_n_0\,
      I5 => \s_axi_rdata[23]_i_10_n_0\,
      O => \s_axi_rdata[23]_i_5_n_0\
    );
\s_axi_rdata[23]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EAEEEAAA"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \ack_sequence_reg_n_0_[23]\,
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => snapshot_sequence_reg(23),
      O => \s_axi_rdata[23]_i_6_n_0\
    );
\s_axi_rdata[23]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(23),
      I1 => \snapshot_reg[14]\(23),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(23),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(23),
      O => \s_axi_rdata[23]_i_7_n_0\
    );
\s_axi_rdata[23]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEFBBEFEEEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[8]\(23),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[10]\(23),
      I5 => \snapshot_reg[11]\(23),
      O => \s_axi_rdata[23]_i_8_n_0\
    );
\s_axi_rdata[23]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(23),
      I1 => \snapshot_reg[6]\(23),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(23),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(23),
      O => \s_axi_rdata[23]_i_9_n_0\
    );
\s_axi_rdata[24]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00200A2A00200222"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_7_n_0\,
      I3 => \s_axi_rdata[24]_i_2_n_0\,
      I4 => \s_axi_rdata[24]_i_3_n_0\,
      I5 => \s_axi_rdata[24]_i_4_n_0\,
      O => \s_axi_rdata[24]_i_1_n_0\
    );
\s_axi_rdata[24]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(24),
      I1 => \snapshot_reg[6]\(24),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(24),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(24),
      O => \s_axi_rdata[24]_i_10_n_0\
    );
\s_axi_rdata[24]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F1FD"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[24]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(24),
      O => \s_axi_rdata[24]_i_2_n_0\
    );
\s_axi_rdata[24]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000DDDF"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \s_axi_rdata[24]_i_5_n_0\,
      I2 => \snapshot_reg[16]\(24),
      I3 => s_axi_araddr(6),
      I4 => \s_axi_rdata[24]_i_6_n_0\,
      O => \s_axi_rdata[24]_i_3_n_0\
    );
\s_axi_rdata[24]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(24),
      I1 => shadow_quiet(24),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[24]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[24]\,
      O => \s_axi_rdata[24]_i_4_n_0\
    );
\s_axi_rdata[24]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2EEE222200000000"
    )
        port map (
      I0 => \s_axi_rdata[24]_i_7_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[24]_i_8_n_0\,
      I3 => s_axi_araddr(4),
      I4 => \s_axi_rdata[24]_i_9_n_0\,
      I5 => s_axi_araddr(6),
      O => \s_axi_rdata[24]_i_5_n_0\
    );
\s_axi_rdata[24]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EAEEEAAA"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \ack_sequence_reg_n_0_[24]\,
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => snapshot_sequence_reg(24),
      O => \s_axi_rdata[24]_i_6_n_0\
    );
\s_axi_rdata[24]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4747477777774777"
    )
        port map (
      I0 => \s_axi_rdata[24]_i_10_n_0\,
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[2]\(24),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[3]\(24),
      O => \s_axi_rdata[24]_i_7_n_0\
    );
\s_axi_rdata[24]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(24),
      I1 => \snapshot_reg[14]\(24),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(24),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(24),
      O => \s_axi_rdata[24]_i_8_n_0\
    );
\s_axi_rdata[24]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEFBBEFEEEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[8]\(24),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[10]\(24),
      I5 => \snapshot_reg[11]\(24),
      O => \s_axi_rdata[24]_i_9_n_0\
    );
\s_axi_rdata[25]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8A8A8A8888888A88"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[25]_i_2_n_0\,
      I2 => \s_axi_rdata[31]_i_7_n_0\,
      I3 => \s_axi_rdata[25]_i_3_n_0\,
      I4 => \s_axi_rdata[31]_i_4_n_0\,
      I5 => \s_axi_rdata[25]_i_4_n_0\,
      O => \s_axi_rdata[25]_i_1_n_0\
    );
\s_axi_rdata[25]_i_10\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000B800"
    )
        port map (
      I0 => \snapshot_reg[3]\(25),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[2]\(25),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      O => \s_axi_rdata[25]_i_10_n_0\
    );
\s_axi_rdata[25]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"C0C000000E020000"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[25]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(25),
      I4 => \s_axi_rdata[31]_i_7_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[25]_i_2_n_0\
    );
\s_axi_rdata[25]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"8A80FFFF"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_10_n_0\,
      I1 => \ack_sequence_reg_n_0_[25]\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => snapshot_sequence_reg(25),
      I4 => \s_axi_rdata[25]_i_5_n_0\,
      O => \s_axi_rdata[25]_i_3_n_0\
    );
\s_axi_rdata[25]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(25),
      I1 => shadow_quiet(25),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[25]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[25]\,
      O => \s_axi_rdata[25]_i_4_n_0\
    );
\s_axi_rdata[25]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B1FF"
    )
        port map (
      I0 => s_axi_araddr(6),
      I1 => \snapshot_reg[16]\(25),
      I2 => \s_axi_rdata[25]_i_6_n_0\,
      I3 => \s_axi_rresp[1]_i_3_n_0\,
      O => \s_axi_rdata[25]_i_5_n_0\
    );
\s_axi_rdata[25]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2020A0A0202FAFAF"
    )
        port map (
      I0 => \s_axi_rdata[25]_i_7_n_0\,
      I1 => \s_axi_rdata[25]_i_8_n_0\,
      I2 => s_axi_araddr(5),
      I3 => \s_axi_rdata[25]_i_9_n_0\,
      I4 => s_axi_araddr(4),
      I5 => \s_axi_rdata[25]_i_10_n_0\,
      O => \s_axi_rdata[25]_i_6_n_0\
    );
\s_axi_rdata[25]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEFBBEFEEEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[8]\(25),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[10]\(25),
      I5 => \snapshot_reg[11]\(25),
      O => \s_axi_rdata[25]_i_7_n_0\
    );
\s_axi_rdata[25]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(25),
      I1 => \snapshot_reg[14]\(25),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(25),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(25),
      O => \s_axi_rdata[25]_i_8_n_0\
    );
\s_axi_rdata[25]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(25),
      I1 => \snapshot_reg[6]\(25),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(25),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(25),
      O => \s_axi_rdata[25]_i_9_n_0\
    );
\s_axi_rdata[26]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"888888888A8A888A"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[26]_i_2_n_0\,
      I2 => \s_axi_rdata[26]_i_3_n_0\,
      I3 => \s_axi_rdata[31]_i_4_n_0\,
      I4 => \s_axi_rdata[26]_i_4_n_0\,
      I5 => \s_axi_rdata[31]_i_7_n_0\,
      O => \s_axi_rdata[26]_i_1_n_0\
    );
\s_axi_rdata[26]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(26),
      I1 => \snapshot_reg[14]\(26),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(26),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(26),
      O => \s_axi_rdata[26]_i_10_n_0\
    );
\s_axi_rdata[26]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"C0C000000E020000"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[26]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(26),
      I4 => \s_axi_rdata[31]_i_7_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[26]_i_2_n_0\
    );
\s_axi_rdata[26]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000002A2AAAA"
    )
        port map (
      I0 => \s_axi_rdata[26]_i_5_n_0\,
      I1 => snapshot_sequence_reg(26),
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => \ack_sequence_reg_n_0_[26]\,
      I4 => \s_axi_rdata[31]_i_10_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[26]_i_3_n_0\
    );
\s_axi_rdata[26]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(26),
      I1 => shadow_quiet(26),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[26]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[26]\,
      O => \s_axi_rdata[26]_i_4_n_0\
    );
\s_axi_rdata[26]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"575757F7F7F757F7"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \snapshot_reg[16]\(26),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rdata[26]_i_6_n_0\,
      I4 => s_axi_araddr(5),
      I5 => \s_axi_rdata_reg[26]_i_7_n_0\,
      O => \s_axi_rdata[26]_i_5_n_0\
    );
\s_axi_rdata[26]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBB888B888888888"
    )
        port map (
      I0 => \s_axi_rdata[26]_i_8_n_0\,
      I1 => s_axi_araddr(4),
      I2 => \snapshot_reg[2]\(26),
      I3 => s_axi_araddr(2),
      I4 => \snapshot_reg[3]\(26),
      I5 => s_axi_araddr(3),
      O => \s_axi_rdata[26]_i_6_n_0\
    );
\s_axi_rdata[26]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(26),
      I1 => \snapshot_reg[6]\(26),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(26),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(26),
      O => \s_axi_rdata[26]_i_8_n_0\
    );
\s_axi_rdata[26]_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[11]\(26),
      I1 => \snapshot_reg[10]\(26),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[8]\(26),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[26]_i_9_n_0\
    );
\s_axi_rdata[27]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00200A2A00200222"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_7_n_0\,
      I3 => \s_axi_rdata[27]_i_2_n_0\,
      I4 => \s_axi_rdata[27]_i_3_n_0\,
      I5 => \s_axi_rdata[27]_i_4_n_0\,
      O => \s_axi_rdata[27]_i_1_n_0\
    );
\s_axi_rdata[27]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(27),
      I1 => \snapshot_reg[6]\(27),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(27),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(27),
      O => \s_axi_rdata[27]_i_10_n_0\
    );
\s_axi_rdata[27]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F1FD"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[27]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(27),
      O => \s_axi_rdata[27]_i_2_n_0\
    );
\s_axi_rdata[27]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000DDDF"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \s_axi_rdata[27]_i_5_n_0\,
      I2 => \snapshot_reg[16]\(27),
      I3 => s_axi_araddr(6),
      I4 => \s_axi_rdata[27]_i_6_n_0\,
      O => \s_axi_rdata[27]_i_3_n_0\
    );
\s_axi_rdata[27]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(27),
      I1 => shadow_quiet(27),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[27]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[27]\,
      O => \s_axi_rdata[27]_i_4_n_0\
    );
\s_axi_rdata[27]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2EEE222200000000"
    )
        port map (
      I0 => \s_axi_rdata[27]_i_7_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[27]_i_8_n_0\,
      I3 => s_axi_araddr(4),
      I4 => \s_axi_rdata[27]_i_9_n_0\,
      I5 => s_axi_araddr(6),
      O => \s_axi_rdata[27]_i_5_n_0\
    );
\s_axi_rdata[27]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FECCCECC"
    )
        port map (
      I0 => snapshot_sequence_reg(27),
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => \s_axi_rdata[31]_i_10_n_0\,
      I4 => \ack_sequence_reg_n_0_[27]\,
      O => \s_axi_rdata[27]_i_6_n_0\
    );
\s_axi_rdata[27]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000057F7FFFF57F7"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => \snapshot_reg[2]\(27),
      I2 => s_axi_araddr(2),
      I3 => \snapshot_reg[3]\(27),
      I4 => s_axi_araddr(4),
      I5 => \s_axi_rdata[27]_i_10_n_0\,
      O => \s_axi_rdata[27]_i_7_n_0\
    );
\s_axi_rdata[27]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(27),
      I1 => \snapshot_reg[14]\(27),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(27),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(27),
      O => \s_axi_rdata[27]_i_8_n_0\
    );
\s_axi_rdata[27]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEFBBEFEEEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[8]\(27),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[10]\(27),
      I5 => \snapshot_reg[11]\(27),
      O => \s_axi_rdata[27]_i_9_n_0\
    );
\s_axi_rdata[28]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00008808AAAAAAAA"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[28]_i_2_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \s_axi_rdata[28]_i_3_n_0\,
      I4 => \s_axi_rdata[31]_i_7_n_0\,
      I5 => \s_axi_rdata[28]_i_4_n_0\,
      O => \s_axi_rdata[28]_i_1_n_0\
    );
\s_axi_rdata[28]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(28),
      I1 => \snapshot_reg[14]\(28),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(28),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(28),
      O => \s_axi_rdata[28]_i_10_n_0\
    );
\s_axi_rdata[28]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFEAEAAAA"
    )
        port map (
      I0 => \s_axi_rdata[28]_i_5_n_0\,
      I1 => snapshot_sequence_reg(28),
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => \ack_sequence_reg_n_0_[28]\,
      I4 => \s_axi_rdata[31]_i_10_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[28]_i_2_n_0\
    );
\s_axi_rdata[28]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(28),
      I1 => shadow_quiet(28),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[28]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[28]\,
      O => \s_axi_rdata[28]_i_3_n_0\
    );
\s_axi_rdata[28]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0FFFFFFFFFFF3F5F"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[28]\,
      I1 => config_epoch_reg(28),
      I2 => \s_axi_rdata[31]_i_7_n_0\,
      I3 => \s_axi_rdata[31]_i_10_n_0\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[28]_i_4_n_0\
    );
\s_axi_rdata[28]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8080808A808"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \snapshot_reg[16]\(28),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rdata[28]_i_6_n_0\,
      I4 => s_axi_araddr(5),
      I5 => \s_axi_rdata_reg[28]_i_7_n_0\,
      O => \s_axi_rdata[28]_i_5_n_0\
    );
\s_axi_rdata[28]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBB888B888888888"
    )
        port map (
      I0 => \s_axi_rdata[28]_i_8_n_0\,
      I1 => s_axi_araddr(4),
      I2 => \snapshot_reg[2]\(28),
      I3 => s_axi_araddr(2),
      I4 => \snapshot_reg[3]\(28),
      I5 => s_axi_araddr(3),
      O => \s_axi_rdata[28]_i_6_n_0\
    );
\s_axi_rdata[28]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(28),
      I1 => \snapshot_reg[6]\(28),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(28),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(28),
      O => \s_axi_rdata[28]_i_8_n_0\
    );
\s_axi_rdata[28]_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[11]\(28),
      I1 => \snapshot_reg[10]\(28),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[8]\(28),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[28]_i_9_n_0\
    );
\s_axi_rdata[29]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00200A2A00200222"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_7_n_0\,
      I3 => \s_axi_rdata[29]_i_2_n_0\,
      I4 => \s_axi_rdata[29]_i_3_n_0\,
      I5 => \s_axi_rdata[29]_i_4_n_0\,
      O => \s_axi_rdata[29]_i_1_n_0\
    );
\s_axi_rdata[29]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(29),
      I1 => \snapshot_reg[6]\(29),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(29),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(29),
      O => \s_axi_rdata[29]_i_10_n_0\
    );
\s_axi_rdata[29]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F1FD"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[29]\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => config_epoch_reg(29),
      O => \s_axi_rdata[29]_i_2_n_0\
    );
\s_axi_rdata[29]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000DDDF"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \s_axi_rdata[29]_i_5_n_0\,
      I2 => \snapshot_reg[16]\(29),
      I3 => s_axi_araddr(6),
      I4 => \s_axi_rdata[29]_i_6_n_0\,
      O => \s_axi_rdata[29]_i_3_n_0\
    );
\s_axi_rdata[29]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(29),
      I1 => shadow_quiet(29),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[29]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[29]\,
      O => \s_axi_rdata[29]_i_4_n_0\
    );
\s_axi_rdata[29]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2EEE222200000000"
    )
        port map (
      I0 => \s_axi_rdata[29]_i_7_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[29]_i_8_n_0\,
      I3 => s_axi_araddr(4),
      I4 => \s_axi_rdata[29]_i_9_n_0\,
      I5 => s_axi_araddr(6),
      O => \s_axi_rdata[29]_i_5_n_0\
    );
\s_axi_rdata[29]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EAEEEAAA"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      I2 => \ack_sequence_reg_n_0_[29]\,
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => snapshot_sequence_reg(29),
      O => \s_axi_rdata[29]_i_6_n_0\
    );
\s_axi_rdata[29]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00005D7FFFFF5D7F"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[3]\(29),
      I3 => \snapshot_reg[2]\(29),
      I4 => s_axi_araddr(4),
      I5 => \s_axi_rdata[29]_i_10_n_0\,
      O => \s_axi_rdata[29]_i_7_n_0\
    );
\s_axi_rdata[29]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(29),
      I1 => \snapshot_reg[14]\(29),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(29),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(29),
      O => \s_axi_rdata[29]_i_8_n_0\
    );
\s_axi_rdata[29]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEFBBEFEEEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[8]\(29),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[10]\(29),
      I5 => \snapshot_reg[11]\(29),
      O => \s_axi_rdata[29]_i_9_n_0\
    );
\s_axi_rdata[2]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[11]\(2),
      I1 => \snapshot_reg[10]\(2),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[0]\(1),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[8]\(2),
      O => \s_axi_rdata[2]_i_10_n_0\
    );
\s_axi_rdata[2]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(2),
      I1 => \snapshot_reg[14]\(2),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(2),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(2),
      O => \s_axi_rdata[2]_i_11_n_0\
    );
\s_axi_rdata[2]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[3]\(2),
      I1 => \snapshot_reg[2]\(2),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[1]\(2),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[0]\(2),
      O => \s_axi_rdata[2]_i_12_n_0\
    );
\s_axi_rdata[2]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(2),
      I1 => \snapshot_reg[6]\(2),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(2),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(2),
      O => \s_axi_rdata[2]_i_13_n_0\
    );
\s_axi_rdata[2]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF8A808A808A80"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_10_n_0\,
      I1 => \ack_sequence_reg_n_0_[2]\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => snapshot_sequence_reg(2),
      I4 => \s_axi_rdata[2]_i_7_n_0\,
      I5 => \s_axi_rresp[1]_i_3_n_0\,
      O => \s_axi_rdata[2]_i_3_n_0\
    );
\s_axi_rdata[2]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(2),
      I1 => shadow_quiet(2),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[2]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[2]\,
      O => \s_axi_rdata[2]_i_4_n_0\
    );
\s_axi_rdata[2]_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_11_n_0\,
      I1 => \s_axi_rdata[31]_i_10_n_0\,
      O => \s_axi_rdata[2]_i_6_n_0\
    );
\s_axi_rdata[2]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8FFB800"
    )
        port map (
      I0 => \s_axi_rdata_reg[2]_i_8_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata_reg[2]_i_9_n_0\,
      I3 => s_axi_araddr(6),
      I4 => \snapshot_reg[16]\(2),
      O => \s_axi_rdata[2]_i_7_n_0\
    );
\s_axi_rdata[30]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFB80000"
    )
        port map (
      I0 => \s_axi_rdata[30]_i_2_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[30]_i_3_n_0\,
      I3 => \s_axi_rdata[31]_i_7_n_0\,
      I4 => \s_axi_rdata[31]_i_3_n_0\,
      I5 => \s_axi_rdata[30]_i_4_n_0\,
      O => \s_axi_rdata[30]_i_1_n_0\
    );
\s_axi_rdata[30]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(30),
      I1 => \snapshot_reg[6]\(30),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(30),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(30),
      O => \s_axi_rdata[30]_i_10_n_0\
    );
\s_axi_rdata[30]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(30),
      I1 => shadow_quiet(30),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[30]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[30]\,
      O => \s_axi_rdata[30]_i_2_n_0\
    );
\s_axi_rdata[30]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF5400"
    )
        port map (
      I0 => \s_axi_rdata[30]_i_5_n_0\,
      I1 => \snapshot_reg[16]\(30),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rresp[1]_i_3_n_0\,
      I4 => \s_axi_rdata[30]_i_6_n_0\,
      O => \s_axi_rdata[30]_i_3_n_0\
    );
\s_axi_rdata[30]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000FF00CF00DD00"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[30]\,
      I1 => \s_axi_rdata[31]_i_11_n_0\,
      I2 => config_epoch_reg(30),
      I3 => \s_axi_rdata[31]_i_7_n_0\,
      I4 => \s_axi_rdata[31]_i_10_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[30]_i_4_n_0\
    );
\s_axi_rdata[30]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2EEE222200000000"
    )
        port map (
      I0 => \s_axi_rdata[30]_i_7_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[30]_i_8_n_0\,
      I3 => s_axi_araddr(4),
      I4 => \s_axi_rdata[30]_i_9_n_0\,
      I5 => s_axi_araddr(6),
      O => \s_axi_rdata[30]_i_5_n_0\
    );
\s_axi_rdata[30]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => snapshot_sequence_reg(30),
      I1 => \s_axi_rdata[31]_i_11_n_0\,
      I2 => \ack_sequence_reg_n_0_[30]\,
      I3 => \s_axi_rdata[31]_i_10_n_0\,
      O => \s_axi_rdata[30]_i_6_n_0\
    );
\s_axi_rdata[30]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4747477777774777"
    )
        port map (
      I0 => \s_axi_rdata[30]_i_10_n_0\,
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[2]\(30),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[3]\(30),
      O => \s_axi_rdata[30]_i_7_n_0\
    );
\s_axi_rdata[30]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(30),
      I1 => \snapshot_reg[14]\(30),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(30),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(30),
      O => \s_axi_rdata[30]_i_8_n_0\
    );
\s_axi_rdata[30]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEFBBEFEEEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => \snapshot_reg[8]\(30),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[10]\(30),
      I5 => \snapshot_reg[11]\(30),
      O => \s_axi_rdata[30]_i_9_n_0\
    );
\s_axi_rdata[31]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => \^s_axi_rvalid_reg_0\,
      O => s_axi_rvalid06_out
    );
\s_axi_rdata[31]_i_10\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"8A0820A2"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_9_n_0\,
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(4),
      I4 => s_axi_araddr(3),
      O => \s_axi_rdata[31]_i_10_n_0\
    );
\s_axi_rdata[31]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0A0A0080A2A0000A"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_4_n_0\,
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(5),
      I3 => s_axi_araddr(7),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[31]_i_11_n_0\
    );
\s_axi_rdata[31]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"575757F7F7F757F7"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \snapshot_reg[16]\(31),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rdata[31]_i_13_n_0\,
      I4 => s_axi_araddr(5),
      I5 => \s_axi_rdata_reg[31]_i_14_n_0\,
      O => \s_axi_rdata[31]_i_12_n_0\
    );
\s_axi_rdata[31]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBB888B888888888"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_15_n_0\,
      I1 => s_axi_araddr(4),
      I2 => \snapshot_reg[2]\(31),
      I3 => s_axi_araddr(2),
      I4 => \snapshot_reg[3]\(31),
      I5 => s_axi_araddr(3),
      O => \s_axi_rdata[31]_i_13_n_0\
    );
\s_axi_rdata[31]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(31),
      I1 => \snapshot_reg[6]\(31),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(31),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(31),
      O => \s_axi_rdata[31]_i_15_n_0\
    );
\s_axi_rdata[31]_i_16\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[11]\(31),
      I1 => \snapshot_reg[10]\(31),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[8]\(31),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[31]_i_16_n_0\
    );
\s_axi_rdata[31]_i_17\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(31),
      I1 => \snapshot_reg[14]\(31),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(31),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(31),
      O => \s_axi_rdata[31]_i_17_n_0\
    );
\s_axi_rdata[31]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000A2AAAA00A2"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_5_n_0\,
      I3 => \s_axi_rdata[31]_i_6_n_0\,
      I4 => \s_axi_rdata[31]_i_7_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[31]_i_2_n_0\
    );
\s_axi_rdata[31]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => s_axi_araddr(8),
      I1 => s_axi_araddr(11),
      I2 => s_axi_araddr(9),
      I3 => s_axi_araddr(10),
      O => \s_axi_rdata[31]_i_3_n_0\
    );
\s_axi_rdata[31]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"74170000"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(5),
      I4 => \s_axi_rdata[31]_i_9_n_0\,
      O => \s_axi_rdata[31]_i_4_n_0\
    );
\s_axi_rdata[31]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(31),
      I1 => shadow_quiet(31),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[31]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[31]\,
      O => \s_axi_rdata[31]_i_5_n_0\
    );
\s_axi_rdata[31]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000002A2AAAA"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_12_n_0\,
      I1 => snapshot_sequence_reg(31),
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => \ack_sequence_reg_n_0_[31]\,
      I4 => \s_axi_rdata[31]_i_10_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[31]_i_6_n_0\
    );
\s_axi_rdata[31]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"51570000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(2),
      I4 => \s_axi_rdata[31]_i_9_n_0\,
      O => \s_axi_rdata[31]_i_7_n_0\
    );
\s_axi_rdata[31]_i_8\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF03F5"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[31]\,
      I1 => config_epoch_reg(31),
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \s_axi_rdata[31]_i_10_n_0\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      O => \s_axi_rdata[31]_i_8_n_0\
    );
\s_axi_rdata[31]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => s_axi_araddr(1),
      I1 => s_axi_araddr(0),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(6),
      O => \s_axi_rdata[31]_i_9_n_0\
    );
\s_axi_rdata[3]_i_10\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[11]\(3),
      I1 => \snapshot_reg[10]\(3),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[8]\(3),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[3]_i_10_n_0\
    );
\s_axi_rdata[3]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(3),
      I1 => \snapshot_reg[14]\(3),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(3),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(3),
      O => \s_axi_rdata[3]_i_11_n_0\
    );
\s_axi_rdata[3]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[3]\(3),
      I1 => \snapshot_reg[2]\(3),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[1]\(3),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[0]\(3),
      O => \s_axi_rdata[3]_i_12_n_0\
    );
\s_axi_rdata[3]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(3),
      I1 => \snapshot_reg[6]\(3),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(3),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(3),
      O => \s_axi_rdata[3]_i_13_n_0\
    );
\s_axi_rdata[3]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF8A808A808A80"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_10_n_0\,
      I1 => \ack_sequence_reg_n_0_[3]\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => snapshot_sequence_reg(3),
      I4 => \s_axi_rdata[3]_i_7_n_0\,
      I5 => \s_axi_rresp[1]_i_3_n_0\,
      O => \s_axi_rdata[3]_i_3_n_0\
    );
\s_axi_rdata[3]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(3),
      I1 => shadow_quiet(3),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[3]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[3]\,
      O => \s_axi_rdata[3]_i_4_n_0\
    );
\s_axi_rdata[3]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_7_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[3]_i_5_n_0\
    );
\s_axi_rdata[3]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040444000"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_10_n_0\,
      I1 => \s_axi_rdata[31]_i_7_n_0\,
      I2 => \out\(0),
      I3 => \s_axi_rdata[31]_i_4_n_0\,
      I4 => \shadow_soft_reg_n_0_[3]\,
      I5 => \s_axi_rdata[31]_i_11_n_0\,
      O => \s_axi_rdata[3]_i_6_n_0\
    );
\s_axi_rdata[3]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8FFB800"
    )
        port map (
      I0 => \s_axi_rdata_reg[3]_i_8_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata_reg[3]_i_9_n_0\,
      I3 => s_axi_araddr(6),
      I4 => \snapshot_reg[16]\(3),
      O => \s_axi_rdata[3]_i_7_n_0\
    );
\s_axi_rdata[4]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(4),
      I1 => \snapshot_reg[14]\(4),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(4),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(4),
      O => \s_axi_rdata[4]_i_10_n_0\
    );
\s_axi_rdata[4]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[3]\(4),
      I1 => \snapshot_reg[2]\(4),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[1]\(4),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[0]\(4),
      O => \s_axi_rdata[4]_i_11_n_0\
    );
\s_axi_rdata[4]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(4),
      I1 => \snapshot_reg[6]\(4),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(4),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(4),
      O => \s_axi_rdata[4]_i_12_n_0\
    );
\s_axi_rdata[4]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFAFCFC0A0A0CFC0"
    )
        port map (
      I0 => shadow_loud(4),
      I1 => shadow_quiet(4),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \ack_epoch_reg_n_0_[4]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \shadow_enable_reg_n_0_[4]\,
      O => \s_axi_rdata[4]_i_2_n_0\
    );
\s_axi_rdata[4]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF8A808A808A80"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_10_n_0\,
      I1 => \ack_sequence_reg_n_0_[4]\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => snapshot_sequence_reg(4),
      I4 => \s_axi_rdata[4]_i_5_n_0\,
      I5 => \s_axi_rresp[1]_i_3_n_0\,
      O => \s_axi_rdata[4]_i_3_n_0\
    );
\s_axi_rdata[4]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8FFB800"
    )
        port map (
      I0 => \s_axi_rdata_reg[4]_i_7_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata_reg[4]_i_8_n_0\,
      I3 => s_axi_araddr(6),
      I4 => \snapshot_reg[16]\(4),
      O => \s_axi_rdata[4]_i_5_n_0\
    );
\s_axi_rdata[4]_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[11]\(4),
      I1 => \snapshot_reg[10]\(4),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[8]\(4),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[4]_i_9_n_0\
    );
\s_axi_rdata[5]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(5),
      I1 => \snapshot_reg[6]\(5),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(5),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(5),
      O => \s_axi_rdata[5]_i_10_n_0\
    );
\s_axi_rdata[5]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000DF1F"
    )
        port map (
      I0 => \snapshot_reg[16]\(5),
      I1 => s_axi_araddr(6),
      I2 => \s_axi_rresp[1]_i_3_n_0\,
      I3 => \s_axi_rdata[5]_i_5_n_0\,
      I4 => \s_axi_rdata[5]_i_6_n_0\,
      O => \s_axi_rdata[5]_i_2_n_0\
    );
\s_axi_rdata[5]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"50505F5F303F303F"
    )
        port map (
      I0 => shadow_loud(5),
      I1 => shadow_quiet(5),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \ack_epoch_reg_n_0_[5]\,
      I4 => \shadow_enable_reg_n_0_[5]\,
      I5 => \s_axi_rdata[31]_i_11_n_0\,
      O => \s_axi_rdata[5]_i_3_n_0\
    );
\s_axi_rdata[5]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"10103F301F103F30"
    )
        port map (
      I0 => \s_axi_rdata[5]_i_7_n_0\,
      I1 => \s_axi_rdata[5]_i_8_n_0\,
      I2 => s_axi_araddr(5),
      I3 => \s_axi_rdata[5]_i_9_n_0\,
      I4 => s_axi_araddr(4),
      I5 => \s_axi_rdata[5]_i_10_n_0\,
      O => \s_axi_rdata[5]_i_5_n_0\
    );
\s_axi_rdata[5]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E200"
    )
        port map (
      I0 => snapshot_sequence_reg(5),
      I1 => \s_axi_rdata[31]_i_11_n_0\,
      I2 => \ack_sequence_reg_n_0_[5]\,
      I3 => \s_axi_rdata[31]_i_10_n_0\,
      O => \s_axi_rdata[5]_i_6_n_0\
    );
\s_axi_rdata[5]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(5),
      I1 => \snapshot_reg[14]\(5),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(5),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(5),
      O => \s_axi_rdata[5]_i_7_n_0\
    );
\s_axi_rdata[5]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000F4A45404"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \snapshot_reg[8]\(5),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[10]\(5),
      I4 => \snapshot_reg[11]\(5),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[5]_i_8_n_0\
    );
\s_axi_rdata[5]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AABFAFBFFABFFFBF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => \snapshot_reg[1]\(5),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => \snapshot_reg[2]\(5),
      I5 => \snapshot_reg[3]\(5),
      O => \s_axi_rdata[5]_i_9_n_0\
    );
\s_axi_rdata[6]_i_10\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[11]\(6),
      I1 => \snapshot_reg[10]\(6),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[8]\(6),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[6]_i_10_n_0\
    );
\s_axi_rdata[6]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(6),
      I1 => \snapshot_reg[14]\(6),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(6),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(6),
      O => \s_axi_rdata[6]_i_11_n_0\
    );
\s_axi_rdata[6]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFEEEFEEFEEEEEEE"
    )
        port map (
      I0 => \s_axi_rdata[6]_i_5_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => \s_axi_rdata[31]_i_10_n_0\,
      I4 => \ack_sequence_reg_n_0_[6]\,
      I5 => snapshot_sequence_reg(6),
      O => \s_axi_rdata[6]_i_2_n_0\
    );
\s_axi_rdata[6]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(6),
      I1 => shadow_quiet(6),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[6]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[6]\,
      O => \s_axi_rdata[6]_i_3_n_0\
    );
\s_axi_rdata[6]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8080808A808"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \snapshot_reg[16]\(6),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rdata_reg[6]_i_6_n_0\,
      I4 => s_axi_araddr(5),
      I5 => \s_axi_rdata_reg[6]_i_7_n_0\,
      O => \s_axi_rdata[6]_i_5_n_0\
    );
\s_axi_rdata[6]_i_8\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AFC0A0C0"
    )
        port map (
      I0 => \snapshot_reg[3]\(6),
      I1 => \snapshot_reg[2]\(6),
      I2 => s_axi_araddr(3),
      I3 => s_axi_araddr(2),
      I4 => \snapshot_reg[1]\(6),
      O => \s_axi_rdata[6]_i_8_n_0\
    );
\s_axi_rdata[6]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(6),
      I1 => \snapshot_reg[6]\(6),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(6),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(6),
      O => \s_axi_rdata[6]_i_9_n_0\
    );
\s_axi_rdata[7]_i_10\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[11]\(7),
      I1 => \snapshot_reg[10]\(7),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[8]\(7),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[7]_i_10_n_0\
    );
\s_axi_rdata[7]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(7),
      I1 => \snapshot_reg[14]\(7),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(7),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(7),
      O => \s_axi_rdata[7]_i_11_n_0\
    );
\s_axi_rdata[7]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000002A2AAAA"
    )
        port map (
      I0 => \s_axi_rdata[7]_i_5_n_0\,
      I1 => snapshot_sequence_reg(7),
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => \ack_sequence_reg_n_0_[7]\,
      I4 => \s_axi_rdata[31]_i_10_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[7]_i_3_n_0\
    );
\s_axi_rdata[7]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(7),
      I1 => shadow_quiet(7),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[7]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[7]\,
      O => \s_axi_rdata[7]_i_4_n_0\
    );
\s_axi_rdata[7]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"575757F7F7F757F7"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_3_n_0\,
      I1 => \snapshot_reg[16]\(7),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rdata_reg[7]_i_6_n_0\,
      I4 => s_axi_araddr(5),
      I5 => \s_axi_rdata_reg[7]_i_7_n_0\,
      O => \s_axi_rdata[7]_i_5_n_0\
    );
\s_axi_rdata[7]_i_8\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AFC0A0C0"
    )
        port map (
      I0 => \snapshot_reg[3]\(7),
      I1 => \snapshot_reg[2]\(7),
      I2 => s_axi_araddr(3),
      I3 => s_axi_araddr(2),
      I4 => \snapshot_reg[1]\(7),
      O => \s_axi_rdata[7]_i_8_n_0\
    );
\s_axi_rdata[7]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(7),
      I1 => \snapshot_reg[6]\(7),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(7),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(7),
      O => \s_axi_rdata[7]_i_9_n_0\
    );
\s_axi_rdata[8]_i_10\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[11]\(8),
      I1 => \snapshot_reg[10]\(8),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[8]\(8),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[8]_i_10_n_0\
    );
\s_axi_rdata[8]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(8),
      I1 => \snapshot_reg[14]\(8),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(8),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(8),
      O => \s_axi_rdata[8]_i_11_n_0\
    );
\s_axi_rdata[8]_i_12\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[3]\(8),
      I1 => \snapshot_reg[2]\(8),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[0]\(8),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[8]_i_12_n_0\
    );
\s_axi_rdata[8]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(8),
      I1 => \snapshot_reg[6]\(8),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(8),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(8),
      O => \s_axi_rdata[8]_i_13_n_0\
    );
\s_axi_rdata[8]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0404444000004440"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_7_n_0\,
      I2 => \s_axi_rdata[31]_i_11_n_0\,
      I3 => \shadow_soft_reg_n_0_[8]\,
      I4 => \s_axi_rdata[31]_i_10_n_0\,
      I5 => config_epoch_reg(8),
      O => \s_axi_rdata[8]_i_2_n_0\
    );
\s_axi_rdata[8]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"10"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_10_n_0\,
      I1 => \s_axi_rdata[31]_i_11_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[8]_i_3_n_0\
    );
\s_axi_rdata[8]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F8FFF88888888888"
    )
        port map (
      I0 => \s_axi_rdata[8]_i_7_n_0\,
      I1 => \s_axi_rresp[1]_i_3_n_0\,
      I2 => \ack_sequence_reg_n_0_[8]\,
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => snapshot_sequence_reg(8),
      I5 => \s_axi_rdata[31]_i_10_n_0\,
      O => \s_axi_rdata[8]_i_5_n_0\
    );
\s_axi_rdata[8]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(8),
      I1 => shadow_quiet(8),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[8]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[8]\,
      O => \s_axi_rdata[8]_i_6_n_0\
    );
\s_axi_rdata[8]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8FFB800"
    )
        port map (
      I0 => \s_axi_rdata_reg[8]_i_8_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata_reg[8]_i_9_n_0\,
      I3 => s_axi_araddr(6),
      I4 => \snapshot_reg[16]\(8),
      O => \s_axi_rdata[8]_i_7_n_0\
    );
\s_axi_rdata[9]_i_10\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[3]\(9),
      I1 => \snapshot_reg[2]\(9),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[0]\(9),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[9]_i_10_n_0\
    );
\s_axi_rdata[9]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[7]\(9),
      I1 => \snapshot_reg[6]\(9),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[5]\(9),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[4]\(9),
      O => \s_axi_rdata[9]_i_11_n_0\
    );
\s_axi_rdata[9]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F888F8F8F8888888"
    )
        port map (
      I0 => \s_axi_rdata[9]_i_5_n_0\,
      I1 => \s_axi_rresp[1]_i_3_n_0\,
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \ack_sequence_reg_n_0_[9]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => snapshot_sequence_reg(9),
      O => \s_axi_rdata[9]_i_2_n_0\
    );
\s_axi_rdata[9]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => shadow_loud(9),
      I1 => shadow_quiet(9),
      I2 => \s_axi_rdata[31]_i_10_n_0\,
      I3 => \shadow_enable_reg_n_0_[9]\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \ack_epoch_reg_n_0_[9]\,
      O => \s_axi_rdata[9]_i_3_n_0\
    );
\s_axi_rdata[9]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8FFB800"
    )
        port map (
      I0 => \s_axi_rdata_reg[9]_i_6_n_0\,
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata_reg[9]_i_7_n_0\,
      I3 => s_axi_araddr(6),
      I4 => \snapshot_reg[16]\(9),
      O => \s_axi_rdata[9]_i_5_n_0\
    );
\s_axi_rdata[9]_i_8\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A0A0CFC0"
    )
        port map (
      I0 => \snapshot_reg[11]\(9),
      I1 => \snapshot_reg[10]\(9),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[8]\(9),
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[9]_i_8_n_0\
    );
\s_axi_rdata[9]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => \snapshot_reg[15]\(9),
      I1 => \snapshot_reg[14]\(9),
      I2 => s_axi_araddr(3),
      I3 => \snapshot_reg[13]\(9),
      I4 => s_axi_araddr(2),
      I5 => \snapshot_reg[12]\(9),
      O => \s_axi_rdata[9]_i_9_n_0\
    );
\s_axi_rdata_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => core_n_136,
      Q => s_axi_rdata(0),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[0]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[0]_i_9_n_0\,
      I1 => \s_axi_rdata[0]_i_10_n_0\,
      O => \s_axi_rdata_reg[0]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[0]_i_8\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[0]_i_11_n_0\,
      I1 => \s_axi_rdata[0]_i_12_n_0\,
      O => \s_axi_rdata_reg[0]_i_8_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => core_n_126,
      Q => s_axi_rdata(10),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[10]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[10]_i_9_n_0\,
      I1 => \s_axi_rdata[10]_i_10_n_0\,
      O => \s_axi_rdata_reg[10]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[10]_i_8\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[10]_i_11_n_0\,
      I1 => \s_axi_rdata[10]_i_12_n_0\,
      O => \s_axi_rdata_reg[10]_i_8_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[11]_i_1_n_0\,
      Q => s_axi_rdata(11),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[12]_i_1_n_0\,
      Q => s_axi_rdata(12),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[12]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[12]_i_9_n_0\,
      I1 => \s_axi_rdata[12]_i_10_n_0\,
      O => \s_axi_rdata_reg[12]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[13]_i_1_n_0\,
      Q => s_axi_rdata(13),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[14]_i_1_n_0\,
      Q => s_axi_rdata(14),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[15]_i_1_n_0\,
      Q => s_axi_rdata(15),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[15]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[15]_i_9_n_0\,
      I1 => \s_axi_rdata[15]_i_10_n_0\,
      O => \s_axi_rdata_reg[15]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[16]_i_1_n_0\,
      Q => s_axi_rdata(16),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[17]_i_1_n_0\,
      Q => s_axi_rdata(17),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[17]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[17]_i_9_n_0\,
      I1 => \s_axi_rdata[17]_i_10_n_0\,
      O => \s_axi_rdata_reg[17]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[18]_i_1_n_0\,
      Q => s_axi_rdata(18),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[19]_i_1_n_0\,
      Q => s_axi_rdata(19),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => core_n_135,
      Q => s_axi_rdata(1),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[1]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[1]_i_9_n_0\,
      I1 => \s_axi_rdata[1]_i_10_n_0\,
      O => \s_axi_rdata_reg[1]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[1]_i_8\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[1]_i_11_n_0\,
      I1 => \s_axi_rdata[1]_i_12_n_0\,
      O => \s_axi_rdata_reg[1]_i_8_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[20]_i_1_n_0\,
      Q => s_axi_rdata(20),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[21]_i_1_n_0\,
      Q => s_axi_rdata(21),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[22]_i_1_n_0\,
      Q => s_axi_rdata(22),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[22]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[22]_i_9_n_0\,
      I1 => \s_axi_rdata[22]_i_10_n_0\,
      O => \s_axi_rdata_reg[22]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[23]_i_1_n_0\,
      Q => s_axi_rdata(23),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[24]_i_1_n_0\,
      Q => s_axi_rdata(24),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[25]_i_1_n_0\,
      Q => s_axi_rdata(25),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[26]_i_1_n_0\,
      Q => s_axi_rdata(26),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[26]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[26]_i_9_n_0\,
      I1 => \s_axi_rdata[26]_i_10_n_0\,
      O => \s_axi_rdata_reg[26]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[27]_i_1_n_0\,
      Q => s_axi_rdata(27),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[28]_i_1_n_0\,
      Q => s_axi_rdata(28),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[28]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[28]_i_9_n_0\,
      I1 => \s_axi_rdata[28]_i_10_n_0\,
      O => \s_axi_rdata_reg[28]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[29]_i_1_n_0\,
      Q => s_axi_rdata(29),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => core_n_134,
      Q => s_axi_rdata(2),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[2]_i_8\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[2]_i_10_n_0\,
      I1 => \s_axi_rdata[2]_i_11_n_0\,
      O => \s_axi_rdata_reg[2]_i_8_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[2]_i_9\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[2]_i_12_n_0\,
      I1 => \s_axi_rdata[2]_i_13_n_0\,
      O => \s_axi_rdata_reg[2]_i_9_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[30]_i_1_n_0\,
      Q => s_axi_rdata(30),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rdata[31]_i_2_n_0\,
      Q => s_axi_rdata(31),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[31]_i_14\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[31]_i_16_n_0\,
      I1 => \s_axi_rdata[31]_i_17_n_0\,
      O => \s_axi_rdata_reg[31]_i_14_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => core_n_133,
      Q => s_axi_rdata(3),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[3]_i_8\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[3]_i_10_n_0\,
      I1 => \s_axi_rdata[3]_i_11_n_0\,
      O => \s_axi_rdata_reg[3]_i_8_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[3]_i_9\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[3]_i_12_n_0\,
      I1 => \s_axi_rdata[3]_i_13_n_0\,
      O => \s_axi_rdata_reg[3]_i_9_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => core_n_132,
      Q => s_axi_rdata(4),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[4]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[4]_i_9_n_0\,
      I1 => \s_axi_rdata[4]_i_10_n_0\,
      O => \s_axi_rdata_reg[4]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[4]_i_8\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[4]_i_11_n_0\,
      I1 => \s_axi_rdata[4]_i_12_n_0\,
      O => \s_axi_rdata_reg[4]_i_8_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => core_n_131,
      Q => s_axi_rdata(5),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => core_n_130,
      Q => s_axi_rdata(6),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[6]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[6]_i_8_n_0\,
      I1 => \s_axi_rdata[6]_i_9_n_0\,
      O => \s_axi_rdata_reg[6]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[6]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[6]_i_10_n_0\,
      I1 => \s_axi_rdata[6]_i_11_n_0\,
      O => \s_axi_rdata_reg[6]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => core_n_129,
      Q => s_axi_rdata(7),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[7]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[7]_i_8_n_0\,
      I1 => \s_axi_rdata[7]_i_9_n_0\,
      O => \s_axi_rdata_reg[7]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[7]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[7]_i_10_n_0\,
      I1 => \s_axi_rdata[7]_i_11_n_0\,
      O => \s_axi_rdata_reg[7]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => core_n_128,
      Q => s_axi_rdata(8),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[8]_i_4\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[8]_i_5_n_0\,
      I1 => \s_axi_rdata[8]_i_6_n_0\,
      O => \s_axi_rdata_reg[8]_i_4_n_0\,
      S => \s_axi_rdata[31]_i_4_n_0\
    );
\s_axi_rdata_reg[8]_i_8\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[8]_i_10_n_0\,
      I1 => \s_axi_rdata[8]_i_11_n_0\,
      O => \s_axi_rdata_reg[8]_i_8_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[8]_i_9\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[8]_i_12_n_0\,
      I1 => \s_axi_rdata[8]_i_13_n_0\,
      O => \s_axi_rdata_reg[8]_i_9_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => core_n_127,
      Q => s_axi_rdata(9),
      R => \^sr\(0)
    );
\s_axi_rdata_reg[9]_i_6\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[9]_i_8_n_0\,
      I1 => \s_axi_rdata[9]_i_9_n_0\,
      O => \s_axi_rdata_reg[9]_i_6_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rdata_reg[9]_i_7\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s_axi_rdata[9]_i_10_n_0\,
      I1 => \s_axi_rdata[9]_i_11_n_0\,
      O => \s_axi_rdata_reg[9]_i_7_n_0\,
      S => s_axi_araddr(4)
    );
\s_axi_rresp[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFF1"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_2_n_0\,
      I1 => \s_axi_rresp[1]_i_3_n_0\,
      I2 => s_axi_araddr(10),
      I3 => s_axi_araddr(9),
      I4 => s_axi_araddr(11),
      I5 => s_axi_araddr(8),
      O => \s_axi_rresp[1]_i_1_n_0\
    );
\s_axi_rresp[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A82088A8A8A8"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_4_n_0\,
      I1 => s_axi_araddr(2),
      I2 => \s_axi_rdata[31]_i_9_n_0\,
      I3 => s_axi_araddr(5),
      I4 => s_axi_araddr(4),
      I5 => s_axi_araddr(3),
      O => \s_axi_rresp[1]_i_2_n_0\
    );
\s_axi_rresp[1]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0202020000000000"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_5_n_0\,
      I1 => s_axi_araddr(1),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(7),
      I4 => s_axi_araddr(6),
      I5 => \s_axi_rdata[31]_i_3_n_0\,
      O => \s_axi_rresp[1]_i_3_n_0\
    );
\s_axi_rresp[1]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000000000010F"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(6),
      I3 => s_axi_araddr(7),
      I4 => s_axi_araddr(0),
      I5 => s_axi_araddr(1),
      O => \s_axi_rresp[1]_i_4_n_0\
    );
\s_axi_rresp[1]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000001FFFFFFFF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(5),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(7),
      O => \s_axi_rresp[1]_i_5_n_0\
    );
\s_axi_rresp_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid06_out,
      D => \s_axi_rresp[1]_i_1_n_0\,
      Q => s_axi_rresp(0),
      R => \^sr\(0)
    );
s_axi_rvalid_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"3A"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => s_axi_rready,
      I2 => \^s_axi_rvalid_reg_0\,
      O => s_axi_rvalid_i_1_n_0
    );
s_axi_rvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => s_axi_rvalid_i_1_n_0,
      Q => \^s_axi_rvalid_reg_0\,
      R => \^sr\(0)
    );
s_axi_wready_INST_0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"04"
    )
        port map (
      I0 => w_held_reg_n_0,
      I1 => s_axi_aresetn,
      I2 => \^s_axi_bvalid_reg_0\,
      O => s_axi_wready
    );
\shadow_enable[31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"20000000"
    )
        port map (
      I0 => \shadow_soft[31]_i_2_n_0\,
      I1 => write_address(4),
      I2 => \shadow_enable[31]_i_2_n_0\,
      I3 => write_address(2),
      I4 => write_address(3),
      O => shadow_enable(0)
    );
\shadow_enable[31]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_9_n_0\,
      I1 => write_data(1),
      I2 => write_data(2),
      O => \shadow_enable[31]_i_2_n_0\
    );
\shadow_enable_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(0),
      Q => \shadow_enable_reg_n_0_[0]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(10),
      Q => \shadow_enable_reg_n_0_[10]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(11),
      Q => \shadow_enable_reg_n_0_[11]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(12),
      Q => \shadow_enable_reg_n_0_[12]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(13),
      Q => \shadow_enable_reg_n_0_[13]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(14),
      Q => \shadow_enable_reg_n_0_[14]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(15),
      Q => \shadow_enable_reg_n_0_[15]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(16),
      Q => \shadow_enable_reg_n_0_[16]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(17),
      Q => \shadow_enable_reg_n_0_[17]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(18),
      Q => \shadow_enable_reg_n_0_[18]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(19),
      Q => \shadow_enable_reg_n_0_[19]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(1),
      Q => \shadow_enable_reg_n_0_[1]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(20),
      Q => \shadow_enable_reg_n_0_[20]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(21),
      Q => \shadow_enable_reg_n_0_[21]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(22),
      Q => \shadow_enable_reg_n_0_[22]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(23),
      Q => \shadow_enable_reg_n_0_[23]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(24),
      Q => \shadow_enable_reg_n_0_[24]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(25),
      Q => \shadow_enable_reg_n_0_[25]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(26),
      Q => \shadow_enable_reg_n_0_[26]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(27),
      Q => \shadow_enable_reg_n_0_[27]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(28),
      Q => \shadow_enable_reg_n_0_[28]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(29),
      Q => \shadow_enable_reg_n_0_[29]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(2),
      Q => \shadow_enable_reg_n_0_[2]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(30),
      Q => \shadow_enable_reg_n_0_[30]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(31),
      Q => \shadow_enable_reg_n_0_[31]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(3),
      Q => \shadow_enable_reg_n_0_[3]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(4),
      Q => \shadow_enable_reg_n_0_[4]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(5),
      Q => \shadow_enable_reg_n_0_[5]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(6),
      Q => \shadow_enable_reg_n_0_[6]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(7),
      Q => \shadow_enable_reg_n_0_[7]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(8),
      Q => \shadow_enable_reg_n_0_[8]\,
      R => \^sr\(0)
    );
\shadow_enable_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_enable(0),
      D => write_data(9),
      Q => \shadow_enable_reg_n_0_[9]\,
      R => \^sr\(0)
    );
\shadow_loud[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0020"
    )
        port map (
      I0 => \shadow_soft[31]_i_2_n_0\,
      I1 => write_address(4),
      I2 => write_address(2),
      I3 => write_address(3),
      O => shadow_loud_1(0)
    );
\shadow_loud_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(0),
      Q => shadow_loud(0),
      R => \^sr\(0)
    );
\shadow_loud_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(10),
      Q => shadow_loud(10),
      R => \^sr\(0)
    );
\shadow_loud_reg[11]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(11),
      Q => shadow_loud(11),
      S => \^sr\(0)
    );
\shadow_loud_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(12),
      Q => shadow_loud(12),
      R => \^sr\(0)
    );
\shadow_loud_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(13),
      Q => shadow_loud(13),
      R => \^sr\(0)
    );
\shadow_loud_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(14),
      Q => shadow_loud(14),
      R => \^sr\(0)
    );
\shadow_loud_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(15),
      Q => shadow_loud(15),
      R => \^sr\(0)
    );
\shadow_loud_reg[16]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(16),
      Q => shadow_loud(16),
      S => \^sr\(0)
    );
\shadow_loud_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(17),
      Q => shadow_loud(17),
      R => \^sr\(0)
    );
\shadow_loud_reg[18]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(18),
      Q => shadow_loud(18),
      S => \^sr\(0)
    );
\shadow_loud_reg[19]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(19),
      Q => shadow_loud(19),
      S => \^sr\(0)
    );
\shadow_loud_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(1),
      Q => shadow_loud(1),
      R => \^sr\(0)
    );
\shadow_loud_reg[20]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(20),
      Q => shadow_loud(20),
      S => \^sr\(0)
    );
\shadow_loud_reg[21]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(21),
      Q => shadow_loud(21),
      S => \^sr\(0)
    );
\shadow_loud_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(22),
      Q => shadow_loud(22),
      R => \^sr\(0)
    );
\shadow_loud_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(23),
      Q => shadow_loud(23),
      R => \^sr\(0)
    );
\shadow_loud_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(24),
      Q => shadow_loud(24),
      R => \^sr\(0)
    );
\shadow_loud_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(25),
      Q => shadow_loud(25),
      R => \^sr\(0)
    );
\shadow_loud_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(26),
      Q => shadow_loud(26),
      R => \^sr\(0)
    );
\shadow_loud_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(27),
      Q => shadow_loud(27),
      R => \^sr\(0)
    );
\shadow_loud_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(28),
      Q => shadow_loud(28),
      R => \^sr\(0)
    );
\shadow_loud_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(29),
      Q => shadow_loud(29),
      R => \^sr\(0)
    );
\shadow_loud_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(2),
      Q => shadow_loud(2),
      R => \^sr\(0)
    );
\shadow_loud_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(30),
      Q => shadow_loud(30),
      R => \^sr\(0)
    );
\shadow_loud_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(31),
      Q => shadow_loud(31),
      R => \^sr\(0)
    );
\shadow_loud_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(3),
      Q => shadow_loud(3),
      R => \^sr\(0)
    );
\shadow_loud_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(4),
      Q => shadow_loud(4),
      R => \^sr\(0)
    );
\shadow_loud_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(5),
      Q => shadow_loud(5),
      R => \^sr\(0)
    );
\shadow_loud_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(6),
      Q => shadow_loud(6),
      R => \^sr\(0)
    );
\shadow_loud_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(7),
      Q => shadow_loud(7),
      R => \^sr\(0)
    );
\shadow_loud_reg[8]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(8),
      Q => shadow_loud(8),
      S => \^sr\(0)
    );
\shadow_loud_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_loud_1(0),
      D => write_data(9),
      Q => shadow_loud(9),
      R => \^sr\(0)
    );
\shadow_quiet[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0020"
    )
        port map (
      I0 => \shadow_soft[31]_i_2_n_0\,
      I1 => write_address(4),
      I2 => write_address(3),
      I3 => write_address(2),
      O => shadow_quiet_0(0)
    );
\shadow_quiet_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(0),
      Q => shadow_quiet(0),
      R => \^sr\(0)
    );
\shadow_quiet_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(10),
      Q => shadow_quiet(10),
      R => \^sr\(0)
    );
\shadow_quiet_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(11),
      Q => shadow_quiet(11),
      R => \^sr\(0)
    );
\shadow_quiet_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(12),
      Q => shadow_quiet(12),
      R => \^sr\(0)
    );
\shadow_quiet_reg[13]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(13),
      Q => shadow_quiet(13),
      S => \^sr\(0)
    );
\shadow_quiet_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(14),
      Q => shadow_quiet(14),
      R => \^sr\(0)
    );
\shadow_quiet_reg[15]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(15),
      Q => shadow_quiet(15),
      S => \^sr\(0)
    );
\shadow_quiet_reg[16]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(16),
      Q => shadow_quiet(16),
      S => \^sr\(0)
    );
\shadow_quiet_reg[17]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(17),
      Q => shadow_quiet(17),
      S => \^sr\(0)
    );
\shadow_quiet_reg[18]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(18),
      Q => shadow_quiet(18),
      S => \^sr\(0)
    );
\shadow_quiet_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(19),
      Q => shadow_quiet(19),
      R => \^sr\(0)
    );
\shadow_quiet_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(1),
      Q => shadow_quiet(1),
      R => \^sr\(0)
    );
\shadow_quiet_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(20),
      Q => shadow_quiet(20),
      R => \^sr\(0)
    );
\shadow_quiet_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(21),
      Q => shadow_quiet(21),
      R => \^sr\(0)
    );
\shadow_quiet_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(22),
      Q => shadow_quiet(22),
      R => \^sr\(0)
    );
\shadow_quiet_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(23),
      Q => shadow_quiet(23),
      R => \^sr\(0)
    );
\shadow_quiet_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(24),
      Q => shadow_quiet(24),
      R => \^sr\(0)
    );
\shadow_quiet_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(25),
      Q => shadow_quiet(25),
      R => \^sr\(0)
    );
\shadow_quiet_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(26),
      Q => shadow_quiet(26),
      R => \^sr\(0)
    );
\shadow_quiet_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(27),
      Q => shadow_quiet(27),
      R => \^sr\(0)
    );
\shadow_quiet_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(28),
      Q => shadow_quiet(28),
      R => \^sr\(0)
    );
\shadow_quiet_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(29),
      Q => shadow_quiet(29),
      R => \^sr\(0)
    );
\shadow_quiet_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(2),
      Q => shadow_quiet(2),
      R => \^sr\(0)
    );
\shadow_quiet_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(30),
      Q => shadow_quiet(30),
      R => \^sr\(0)
    );
\shadow_quiet_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(31),
      Q => shadow_quiet(31),
      R => \^sr\(0)
    );
\shadow_quiet_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(3),
      Q => shadow_quiet(3),
      R => \^sr\(0)
    );
\shadow_quiet_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(4),
      Q => shadow_quiet(4),
      R => \^sr\(0)
    );
\shadow_quiet_reg[5]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(5),
      Q => shadow_quiet(5),
      S => \^sr\(0)
    );
\shadow_quiet_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(6),
      Q => shadow_quiet(6),
      R => \^sr\(0)
    );
\shadow_quiet_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(7),
      Q => shadow_quiet(7),
      R => \^sr\(0)
    );
\shadow_quiet_reg[8]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(8),
      Q => shadow_quiet(8),
      S => \^sr\(0)
    );
\shadow_quiet_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => shadow_quiet_0(0),
      D => write_data(9),
      Q => shadow_quiet(9),
      R => \^sr\(0)
    );
\shadow_soft[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0002"
    )
        port map (
      I0 => \shadow_soft[31]_i_2_n_0\,
      I1 => write_address(4),
      I2 => write_address(3),
      I3 => write_address(2),
      O => \shadow_soft[31]_i_1_n_0\
    );
\shadow_soft[31]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_3_n_0\,
      I1 => \soft_sum[31]_i_4_n_0\,
      O => \shadow_soft[31]_i_2_n_0\
    );
\shadow_soft_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(0),
      Q => \shadow_soft_reg_n_0_[0]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(10),
      Q => \shadow_soft_reg_n_0_[10]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(11),
      Q => \shadow_soft_reg_n_0_[11]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(12),
      Q => \shadow_soft_reg_n_0_[12]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(13),
      Q => \shadow_soft_reg_n_0_[13]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[14]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(14),
      Q => \shadow_soft_reg_n_0_[14]\,
      S => \^sr\(0)
    );
\shadow_soft_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(15),
      Q => \shadow_soft_reg_n_0_[15]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[16]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(16),
      Q => \shadow_soft_reg_n_0_[16]\,
      S => \^sr\(0)
    );
\shadow_soft_reg[17]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(17),
      Q => \shadow_soft_reg_n_0_[17]\,
      S => \^sr\(0)
    );
\shadow_soft_reg[18]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(18),
      Q => \shadow_soft_reg_n_0_[18]\,
      S => \^sr\(0)
    );
\shadow_soft_reg[19]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(19),
      Q => \shadow_soft_reg_n_0_[19]\,
      S => \^sr\(0)
    );
\shadow_soft_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(1),
      Q => \shadow_soft_reg_n_0_[1]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(20),
      Q => \shadow_soft_reg_n_0_[20]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(21),
      Q => \shadow_soft_reg_n_0_[21]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(22),
      Q => \shadow_soft_reg_n_0_[22]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(23),
      Q => \shadow_soft_reg_n_0_[23]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(24),
      Q => \shadow_soft_reg_n_0_[24]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(25),
      Q => \shadow_soft_reg_n_0_[25]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(26),
      Q => \shadow_soft_reg_n_0_[26]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(27),
      Q => \shadow_soft_reg_n_0_[27]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(28),
      Q => \shadow_soft_reg_n_0_[28]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(29),
      Q => \shadow_soft_reg_n_0_[29]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(2),
      Q => \shadow_soft_reg_n_0_[2]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(30),
      Q => \shadow_soft_reg_n_0_[30]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(31),
      Q => \shadow_soft_reg_n_0_[31]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(3),
      Q => \shadow_soft_reg_n_0_[3]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(4),
      Q => \shadow_soft_reg_n_0_[4]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(5),
      Q => \shadow_soft_reg_n_0_[5]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[6]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(6),
      Q => \shadow_soft_reg_n_0_[6]\,
      S => \^sr\(0)
    );
\shadow_soft_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(7),
      Q => \shadow_soft_reg_n_0_[7]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(8),
      Q => \shadow_soft_reg_n_0_[8]\,
      R => \^sr\(0)
    );
\shadow_soft_reg[9]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => \shadow_soft[31]_i_1_n_0\,
      D => write_data(9),
      Q => \shadow_soft_reg_n_0_[9]\,
      S => \^sr\(0)
    );
\snapshot[0][10]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000010000"
    )
        port map (
      I0 => \snapshot[0][10]_i_2_n_0\,
      I1 => \snapshot[0][10]_i_3_n_0\,
      I2 => write_data(2),
      I3 => write_data(0),
      I4 => write_data(1),
      I5 => \soft_sum[31]_i_4_n_0\,
      O => \snapshot[0][10]_i_1_n_0\
    );
\snapshot[0][10]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFEF"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_9_n_0\,
      I1 => write_address(2),
      I2 => write_address(4),
      I3 => write_address(3),
      O => \snapshot[0][10]_i_2_n_0\
    );
\snapshot[0][10]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => write_address(8),
      I1 => write_address(10),
      I2 => write_address(9),
      I3 => \s_axi_bresp[1]_i_8_n_0\,
      O => \snapshot[0][10]_i_3_n_0\
    );
\snapshot_reg[0][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => status(0),
      Q => \snapshot_reg[0]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[0][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => status(10),
      Q => \snapshot_reg[0]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[0][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => status(1),
      Q => \snapshot_reg[0]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[0][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => status0,
      Q => \snapshot_reg[0]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[0][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \out\(0),
      Q => \snapshot_reg[0]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[0][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => status(4),
      Q => \snapshot_reg[0]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[0][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => status(8),
      Q => \snapshot_reg[0]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[0][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => status(9),
      Q => \snapshot_reg[0]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[10][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_331,
      Q => \snapshot_reg[10]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[10][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_321,
      Q => \snapshot_reg[10]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[10][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_320,
      Q => \snapshot_reg[10]\(11),
      R => \^sr\(0)
    );
\snapshot_reg[10][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_319,
      Q => \snapshot_reg[10]\(12),
      R => \^sr\(0)
    );
\snapshot_reg[10][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_318,
      Q => \snapshot_reg[10]\(13),
      R => \^sr\(0)
    );
\snapshot_reg[10][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_317,
      Q => \snapshot_reg[10]\(14),
      R => \^sr\(0)
    );
\snapshot_reg[10][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_316,
      Q => \snapshot_reg[10]\(15),
      R => \^sr\(0)
    );
\snapshot_reg[10][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_315,
      Q => \snapshot_reg[10]\(16),
      R => \^sr\(0)
    );
\snapshot_reg[10][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_314,
      Q => \snapshot_reg[10]\(17),
      R => \^sr\(0)
    );
\snapshot_reg[10][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_313,
      Q => \snapshot_reg[10]\(18),
      R => \^sr\(0)
    );
\snapshot_reg[10][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_312,
      Q => \snapshot_reg[10]\(19),
      R => \^sr\(0)
    );
\snapshot_reg[10][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_330,
      Q => \snapshot_reg[10]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[10][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_311,
      Q => \snapshot_reg[10]\(20),
      R => \^sr\(0)
    );
\snapshot_reg[10][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_310,
      Q => \snapshot_reg[10]\(21),
      R => \^sr\(0)
    );
\snapshot_reg[10][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_309,
      Q => \snapshot_reg[10]\(22),
      R => \^sr\(0)
    );
\snapshot_reg[10][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_308,
      Q => \snapshot_reg[10]\(23),
      R => \^sr\(0)
    );
\snapshot_reg[10][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_307,
      Q => \snapshot_reg[10]\(24),
      R => \^sr\(0)
    );
\snapshot_reg[10][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_306,
      Q => \snapshot_reg[10]\(25),
      R => \^sr\(0)
    );
\snapshot_reg[10][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_305,
      Q => \snapshot_reg[10]\(26),
      R => \^sr\(0)
    );
\snapshot_reg[10][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_304,
      Q => \snapshot_reg[10]\(27),
      R => \^sr\(0)
    );
\snapshot_reg[10][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_303,
      Q => \snapshot_reg[10]\(28),
      R => \^sr\(0)
    );
\snapshot_reg[10][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_302,
      Q => \snapshot_reg[10]\(29),
      R => \^sr\(0)
    );
\snapshot_reg[10][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_329,
      Q => \snapshot_reg[10]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[10][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_301,
      Q => \snapshot_reg[10]\(30),
      R => \^sr\(0)
    );
\snapshot_reg[10][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_300,
      Q => \snapshot_reg[10]\(31),
      R => \^sr\(0)
    );
\snapshot_reg[10][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_328,
      Q => \snapshot_reg[10]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[10][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_327,
      Q => \snapshot_reg[10]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[10][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_326,
      Q => \snapshot_reg[10]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[10][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_325,
      Q => \snapshot_reg[10]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[10][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_324,
      Q => \snapshot_reg[10]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[10][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_323,
      Q => \snapshot_reg[10]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[10][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_322,
      Q => \snapshot_reg[10]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[11][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(0),
      Q => \snapshot_reg[11]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[11][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(10),
      Q => \snapshot_reg[11]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[11][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(11),
      Q => \snapshot_reg[11]\(11),
      R => \^sr\(0)
    );
\snapshot_reg[11][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(12),
      Q => \snapshot_reg[11]\(12),
      R => \^sr\(0)
    );
\snapshot_reg[11][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(13),
      Q => \snapshot_reg[11]\(13),
      R => \^sr\(0)
    );
\snapshot_reg[11][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(14),
      Q => \snapshot_reg[11]\(14),
      R => \^sr\(0)
    );
\snapshot_reg[11][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(15),
      Q => \snapshot_reg[11]\(15),
      R => \^sr\(0)
    );
\snapshot_reg[11][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(16),
      Q => \snapshot_reg[11]\(16),
      R => \^sr\(0)
    );
\snapshot_reg[11][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(17),
      Q => \snapshot_reg[11]\(17),
      R => \^sr\(0)
    );
\snapshot_reg[11][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(18),
      Q => \snapshot_reg[11]\(18),
      R => \^sr\(0)
    );
\snapshot_reg[11][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(19),
      Q => \snapshot_reg[11]\(19),
      R => \^sr\(0)
    );
\snapshot_reg[11][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(1),
      Q => \snapshot_reg[11]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[11][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(20),
      Q => \snapshot_reg[11]\(20),
      R => \^sr\(0)
    );
\snapshot_reg[11][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(21),
      Q => \snapshot_reg[11]\(21),
      R => \^sr\(0)
    );
\snapshot_reg[11][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(22),
      Q => \snapshot_reg[11]\(22),
      R => \^sr\(0)
    );
\snapshot_reg[11][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(23),
      Q => \snapshot_reg[11]\(23),
      R => \^sr\(0)
    );
\snapshot_reg[11][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(24),
      Q => \snapshot_reg[11]\(24),
      R => \^sr\(0)
    );
\snapshot_reg[11][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(25),
      Q => \snapshot_reg[11]\(25),
      R => \^sr\(0)
    );
\snapshot_reg[11][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(26),
      Q => \snapshot_reg[11]\(26),
      R => \^sr\(0)
    );
\snapshot_reg[11][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(27),
      Q => \snapshot_reg[11]\(27),
      R => \^sr\(0)
    );
\snapshot_reg[11][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(28),
      Q => \snapshot_reg[11]\(28),
      R => \^sr\(0)
    );
\snapshot_reg[11][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(29),
      Q => \snapshot_reg[11]\(29),
      R => \^sr\(0)
    );
\snapshot_reg[11][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(2),
      Q => \snapshot_reg[11]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[11][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(30),
      Q => \snapshot_reg[11]\(30),
      R => \^sr\(0)
    );
\snapshot_reg[11][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(31),
      Q => \snapshot_reg[11]\(31),
      R => \^sr\(0)
    );
\snapshot_reg[11][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(3),
      Q => \snapshot_reg[11]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[11][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(4),
      Q => \snapshot_reg[11]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[11][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(5),
      Q => \snapshot_reg[11]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[11][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(6),
      Q => \snapshot_reg[11]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[11][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(7),
      Q => \snapshot_reg[11]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[11][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(8),
      Q => \snapshot_reg[11]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[11][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_5_in(9),
      Q => \snapshot_reg[11]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[12][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(0),
      Q => \snapshot_reg[12]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[12][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(10),
      Q => \snapshot_reg[12]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[12][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(11),
      Q => \snapshot_reg[12]\(11),
      R => \^sr\(0)
    );
\snapshot_reg[12][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(12),
      Q => \snapshot_reg[12]\(12),
      R => \^sr\(0)
    );
\snapshot_reg[12][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(13),
      Q => \snapshot_reg[12]\(13),
      R => \^sr\(0)
    );
\snapshot_reg[12][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(14),
      Q => \snapshot_reg[12]\(14),
      R => \^sr\(0)
    );
\snapshot_reg[12][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(15),
      Q => \snapshot_reg[12]\(15),
      R => \^sr\(0)
    );
\snapshot_reg[12][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(16),
      Q => \snapshot_reg[12]\(16),
      R => \^sr\(0)
    );
\snapshot_reg[12][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(17),
      Q => \snapshot_reg[12]\(17),
      R => \^sr\(0)
    );
\snapshot_reg[12][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(18),
      Q => \snapshot_reg[12]\(18),
      R => \^sr\(0)
    );
\snapshot_reg[12][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(19),
      Q => \snapshot_reg[12]\(19),
      R => \^sr\(0)
    );
\snapshot_reg[12][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(1),
      Q => \snapshot_reg[12]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[12][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(20),
      Q => \snapshot_reg[12]\(20),
      R => \^sr\(0)
    );
\snapshot_reg[12][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(21),
      Q => \snapshot_reg[12]\(21),
      R => \^sr\(0)
    );
\snapshot_reg[12][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(22),
      Q => \snapshot_reg[12]\(22),
      R => \^sr\(0)
    );
\snapshot_reg[12][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(23),
      Q => \snapshot_reg[12]\(23),
      R => \^sr\(0)
    );
\snapshot_reg[12][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(24),
      Q => \snapshot_reg[12]\(24),
      R => \^sr\(0)
    );
\snapshot_reg[12][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(25),
      Q => \snapshot_reg[12]\(25),
      R => \^sr\(0)
    );
\snapshot_reg[12][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(26),
      Q => \snapshot_reg[12]\(26),
      R => \^sr\(0)
    );
\snapshot_reg[12][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(27),
      Q => \snapshot_reg[12]\(27),
      R => \^sr\(0)
    );
\snapshot_reg[12][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(28),
      Q => \snapshot_reg[12]\(28),
      R => \^sr\(0)
    );
\snapshot_reg[12][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(29),
      Q => \snapshot_reg[12]\(29),
      R => \^sr\(0)
    );
\snapshot_reg[12][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(2),
      Q => \snapshot_reg[12]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[12][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(30),
      Q => \snapshot_reg[12]\(30),
      R => \^sr\(0)
    );
\snapshot_reg[12][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(31),
      Q => \snapshot_reg[12]\(31),
      R => \^sr\(0)
    );
\snapshot_reg[12][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(3),
      Q => \snapshot_reg[12]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[12][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(4),
      Q => \snapshot_reg[12]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[12][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(5),
      Q => \snapshot_reg[12]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[12][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(6),
      Q => \snapshot_reg[12]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[12][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(7),
      Q => \snapshot_reg[12]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[12][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(8),
      Q => \snapshot_reg[12]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[12][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_window(9),
      Q => \snapshot_reg[12]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[13][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(0),
      Q => \snapshot_reg[13]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[13][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(10),
      Q => \snapshot_reg[13]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[13][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(11),
      Q => \snapshot_reg[13]\(11),
      R => \^sr\(0)
    );
\snapshot_reg[13][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(12),
      Q => \snapshot_reg[13]\(12),
      R => \^sr\(0)
    );
\snapshot_reg[13][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(13),
      Q => \snapshot_reg[13]\(13),
      R => \^sr\(0)
    );
\snapshot_reg[13][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(14),
      Q => \snapshot_reg[13]\(14),
      R => \^sr\(0)
    );
\snapshot_reg[13][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(15),
      Q => \snapshot_reg[13]\(15),
      R => \^sr\(0)
    );
\snapshot_reg[13][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(16),
      Q => \snapshot_reg[13]\(16),
      R => \^sr\(0)
    );
\snapshot_reg[13][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(17),
      Q => \snapshot_reg[13]\(17),
      R => \^sr\(0)
    );
\snapshot_reg[13][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(18),
      Q => \snapshot_reg[13]\(18),
      R => \^sr\(0)
    );
\snapshot_reg[13][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(19),
      Q => \snapshot_reg[13]\(19),
      R => \^sr\(0)
    );
\snapshot_reg[13][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(1),
      Q => \snapshot_reg[13]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[13][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(20),
      Q => \snapshot_reg[13]\(20),
      R => \^sr\(0)
    );
\snapshot_reg[13][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(21),
      Q => \snapshot_reg[13]\(21),
      R => \^sr\(0)
    );
\snapshot_reg[13][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(22),
      Q => \snapshot_reg[13]\(22),
      R => \^sr\(0)
    );
\snapshot_reg[13][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(23),
      Q => \snapshot_reg[13]\(23),
      R => \^sr\(0)
    );
\snapshot_reg[13][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(24),
      Q => \snapshot_reg[13]\(24),
      R => \^sr\(0)
    );
\snapshot_reg[13][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(25),
      Q => \snapshot_reg[13]\(25),
      R => \^sr\(0)
    );
\snapshot_reg[13][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(26),
      Q => \snapshot_reg[13]\(26),
      R => \^sr\(0)
    );
\snapshot_reg[13][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(27),
      Q => \snapshot_reg[13]\(27),
      R => \^sr\(0)
    );
\snapshot_reg[13][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(28),
      Q => \snapshot_reg[13]\(28),
      R => \^sr\(0)
    );
\snapshot_reg[13][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(29),
      Q => \snapshot_reg[13]\(29),
      R => \^sr\(0)
    );
\snapshot_reg[13][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(2),
      Q => \snapshot_reg[13]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[13][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(30),
      Q => \snapshot_reg[13]\(30),
      R => \^sr\(0)
    );
\snapshot_reg[13][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(31),
      Q => \snapshot_reg[13]\(31),
      R => \^sr\(0)
    );
\snapshot_reg[13][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(3),
      Q => \snapshot_reg[13]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[13][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(4),
      Q => \snapshot_reg[13]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[13][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(5),
      Q => \snapshot_reg[13]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[13][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(6),
      Q => \snapshot_reg[13]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[13][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(7),
      Q => \snapshot_reg[13]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[13][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(8),
      Q => \snapshot_reg[13]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[13][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_age(9),
      Q => \snapshot_reg[13]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[14][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[0]\,
      Q => \snapshot_reg[14]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[14][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[10]\,
      Q => \snapshot_reg[14]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[14][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[11]\,
      Q => \snapshot_reg[14]\(11),
      R => \^sr\(0)
    );
\snapshot_reg[14][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[12]\,
      Q => \snapshot_reg[14]\(12),
      R => \^sr\(0)
    );
\snapshot_reg[14][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[13]\,
      Q => \snapshot_reg[14]\(13),
      R => \^sr\(0)
    );
\snapshot_reg[14][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[14]\,
      Q => \snapshot_reg[14]\(14),
      R => \^sr\(0)
    );
\snapshot_reg[14][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[15]\,
      Q => \snapshot_reg[14]\(15),
      R => \^sr\(0)
    );
\snapshot_reg[14][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[16]\,
      Q => \snapshot_reg[14]\(16),
      R => \^sr\(0)
    );
\snapshot_reg[14][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[17]\,
      Q => \snapshot_reg[14]\(17),
      R => \^sr\(0)
    );
\snapshot_reg[14][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[18]\,
      Q => \snapshot_reg[14]\(18),
      R => \^sr\(0)
    );
\snapshot_reg[14][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[19]\,
      Q => \snapshot_reg[14]\(19),
      R => \^sr\(0)
    );
\snapshot_reg[14][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[1]\,
      Q => \snapshot_reg[14]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[14][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[20]\,
      Q => \snapshot_reg[14]\(20),
      R => \^sr\(0)
    );
\snapshot_reg[14][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[21]\,
      Q => \snapshot_reg[14]\(21),
      R => \^sr\(0)
    );
\snapshot_reg[14][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[22]\,
      Q => \snapshot_reg[14]\(22),
      R => \^sr\(0)
    );
\snapshot_reg[14][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[23]\,
      Q => \snapshot_reg[14]\(23),
      R => \^sr\(0)
    );
\snapshot_reg[14][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[24]\,
      Q => \snapshot_reg[14]\(24),
      R => \^sr\(0)
    );
\snapshot_reg[14][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[25]\,
      Q => \snapshot_reg[14]\(25),
      R => \^sr\(0)
    );
\snapshot_reg[14][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[26]\,
      Q => \snapshot_reg[14]\(26),
      R => \^sr\(0)
    );
\snapshot_reg[14][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[27]\,
      Q => \snapshot_reg[14]\(27),
      R => \^sr\(0)
    );
\snapshot_reg[14][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[28]\,
      Q => \snapshot_reg[14]\(28),
      R => \^sr\(0)
    );
\snapshot_reg[14][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[29]\,
      Q => \snapshot_reg[14]\(29),
      R => \^sr\(0)
    );
\snapshot_reg[14][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[2]\,
      Q => \snapshot_reg[14]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[14][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[30]\,
      Q => \snapshot_reg[14]\(30),
      R => \^sr\(0)
    );
\snapshot_reg[14][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[31]\,
      Q => \snapshot_reg[14]\(31),
      R => \^sr\(0)
    );
\snapshot_reg[14][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[3]\,
      Q => \snapshot_reg[14]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[14][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[4]\,
      Q => \snapshot_reg[14]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[14][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[5]\,
      Q => \snapshot_reg[14]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[14][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[6]\,
      Q => \snapshot_reg[14]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[14][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[7]\,
      Q => \snapshot_reg[14]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[14][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[8]\,
      Q => \snapshot_reg[14]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[14][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \soft_sum_reg_n_0_[9]\,
      Q => \snapshot_reg[14]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[15][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(0),
      Q => \snapshot_reg[15]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[15][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(10),
      Q => \snapshot_reg[15]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[15][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(11),
      Q => \snapshot_reg[15]\(11),
      R => \^sr\(0)
    );
\snapshot_reg[15][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(12),
      Q => \snapshot_reg[15]\(12),
      R => \^sr\(0)
    );
\snapshot_reg[15][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(13),
      Q => \snapshot_reg[15]\(13),
      R => \^sr\(0)
    );
\snapshot_reg[15][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(14),
      Q => \snapshot_reg[15]\(14),
      R => \^sr\(0)
    );
\snapshot_reg[15][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(15),
      Q => \snapshot_reg[15]\(15),
      R => \^sr\(0)
    );
\snapshot_reg[15][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(16),
      Q => \snapshot_reg[15]\(16),
      R => \^sr\(0)
    );
\snapshot_reg[15][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(17),
      Q => \snapshot_reg[15]\(17),
      R => \^sr\(0)
    );
\snapshot_reg[15][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(18),
      Q => \snapshot_reg[15]\(18),
      R => \^sr\(0)
    );
\snapshot_reg[15][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(19),
      Q => \snapshot_reg[15]\(19),
      R => \^sr\(0)
    );
\snapshot_reg[15][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(1),
      Q => \snapshot_reg[15]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[15][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(20),
      Q => \snapshot_reg[15]\(20),
      R => \^sr\(0)
    );
\snapshot_reg[15][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(21),
      Q => \snapshot_reg[15]\(21),
      R => \^sr\(0)
    );
\snapshot_reg[15][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(22),
      Q => \snapshot_reg[15]\(22),
      R => \^sr\(0)
    );
\snapshot_reg[15][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(23),
      Q => \snapshot_reg[15]\(23),
      R => \^sr\(0)
    );
\snapshot_reg[15][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(24),
      Q => \snapshot_reg[15]\(24),
      R => \^sr\(0)
    );
\snapshot_reg[15][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(25),
      Q => \snapshot_reg[15]\(25),
      R => \^sr\(0)
    );
\snapshot_reg[15][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(26),
      Q => \snapshot_reg[15]\(26),
      R => \^sr\(0)
    );
\snapshot_reg[15][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(27),
      Q => \snapshot_reg[15]\(27),
      R => \^sr\(0)
    );
\snapshot_reg[15][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(28),
      Q => \snapshot_reg[15]\(28),
      R => \^sr\(0)
    );
\snapshot_reg[15][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(29),
      Q => \snapshot_reg[15]\(29),
      R => \^sr\(0)
    );
\snapshot_reg[15][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(2),
      Q => \snapshot_reg[15]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[15][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(30),
      Q => \snapshot_reg[15]\(30),
      R => \^sr\(0)
    );
\snapshot_reg[15][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(31),
      Q => \snapshot_reg[15]\(31),
      R => \^sr\(0)
    );
\snapshot_reg[15][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(3),
      Q => \snapshot_reg[15]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[15][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(4),
      Q => \snapshot_reg[15]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[15][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(5),
      Q => \snapshot_reg[15]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[15][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(6),
      Q => \snapshot_reg[15]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[15][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(7),
      Q => \snapshot_reg[15]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[15][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(8),
      Q => \snapshot_reg[15]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[15][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => loud_sum(9),
      Q => \snapshot_reg[15]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[16][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(0),
      Q => \snapshot_reg[16]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[16][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(10),
      Q => \snapshot_reg[16]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[16][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(11),
      Q => \snapshot_reg[16]\(11),
      R => \^sr\(0)
    );
\snapshot_reg[16][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(12),
      Q => \snapshot_reg[16]\(12),
      R => \^sr\(0)
    );
\snapshot_reg[16][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(13),
      Q => \snapshot_reg[16]\(13),
      R => \^sr\(0)
    );
\snapshot_reg[16][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(14),
      Q => \snapshot_reg[16]\(14),
      R => \^sr\(0)
    );
\snapshot_reg[16][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(15),
      Q => \snapshot_reg[16]\(15),
      R => \^sr\(0)
    );
\snapshot_reg[16][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(16),
      Q => \snapshot_reg[16]\(16),
      R => \^sr\(0)
    );
\snapshot_reg[16][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(17),
      Q => \snapshot_reg[16]\(17),
      R => \^sr\(0)
    );
\snapshot_reg[16][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(18),
      Q => \snapshot_reg[16]\(18),
      R => \^sr\(0)
    );
\snapshot_reg[16][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(19),
      Q => \snapshot_reg[16]\(19),
      R => \^sr\(0)
    );
\snapshot_reg[16][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(1),
      Q => \snapshot_reg[16]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[16][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(20),
      Q => \snapshot_reg[16]\(20),
      R => \^sr\(0)
    );
\snapshot_reg[16][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(21),
      Q => \snapshot_reg[16]\(21),
      R => \^sr\(0)
    );
\snapshot_reg[16][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(22),
      Q => \snapshot_reg[16]\(22),
      R => \^sr\(0)
    );
\snapshot_reg[16][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(23),
      Q => \snapshot_reg[16]\(23),
      R => \^sr\(0)
    );
\snapshot_reg[16][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(24),
      Q => \snapshot_reg[16]\(24),
      R => \^sr\(0)
    );
\snapshot_reg[16][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(25),
      Q => \snapshot_reg[16]\(25),
      R => \^sr\(0)
    );
\snapshot_reg[16][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(26),
      Q => \snapshot_reg[16]\(26),
      R => \^sr\(0)
    );
\snapshot_reg[16][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(27),
      Q => \snapshot_reg[16]\(27),
      R => \^sr\(0)
    );
\snapshot_reg[16][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(28),
      Q => \snapshot_reg[16]\(28),
      R => \^sr\(0)
    );
\snapshot_reg[16][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(29),
      Q => \snapshot_reg[16]\(29),
      R => \^sr\(0)
    );
\snapshot_reg[16][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(2),
      Q => \snapshot_reg[16]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[16][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(30),
      Q => \snapshot_reg[16]\(30),
      R => \^sr\(0)
    );
\snapshot_reg[16][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(31),
      Q => \snapshot_reg[16]\(31),
      R => \^sr\(0)
    );
\snapshot_reg[16][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(3),
      Q => \snapshot_reg[16]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[16][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(4),
      Q => \snapshot_reg[16]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[16][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(5),
      Q => \snapshot_reg[16]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[16][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(6),
      Q => \snapshot_reg[16]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[16][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(7),
      Q => \snapshot_reg[16]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[16][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(8),
      Q => \snapshot_reg[16]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[16][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => quiet_sum(9),
      Q => \snapshot_reg[16]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[1][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => faults(0),
      Q => \snapshot_reg[1]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[1][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => faults(1),
      Q => \snapshot_reg[1]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[1][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => faults(2),
      Q => \snapshot_reg[1]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[1][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => faults(3),
      Q => \snapshot_reg[1]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[1][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => faults(4),
      Q => \snapshot_reg[1]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[1][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => faults(5),
      Q => \snapshot_reg[1]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[1][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => faults(6),
      Q => \snapshot_reg[1]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[1][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => faults(7),
      Q => \snapshot_reg[1]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[2][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(0),
      Q => \snapshot_reg[2]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[2][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(10),
      Q => \snapshot_reg[2]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[2][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(11),
      Q => \snapshot_reg[2]\(11),
      R => \^sr\(0)
    );
\snapshot_reg[2][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(12),
      Q => \snapshot_reg[2]\(12),
      R => \^sr\(0)
    );
\snapshot_reg[2][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(13),
      Q => \snapshot_reg[2]\(13),
      R => \^sr\(0)
    );
\snapshot_reg[2][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(14),
      Q => \snapshot_reg[2]\(14),
      R => \^sr\(0)
    );
\snapshot_reg[2][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(15),
      Q => \snapshot_reg[2]\(15),
      R => \^sr\(0)
    );
\snapshot_reg[2][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(16),
      Q => \snapshot_reg[2]\(16),
      R => \^sr\(0)
    );
\snapshot_reg[2][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(17),
      Q => \snapshot_reg[2]\(17),
      R => \^sr\(0)
    );
\snapshot_reg[2][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(18),
      Q => \snapshot_reg[2]\(18),
      R => \^sr\(0)
    );
\snapshot_reg[2][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(19),
      Q => \snapshot_reg[2]\(19),
      R => \^sr\(0)
    );
\snapshot_reg[2][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(1),
      Q => \snapshot_reg[2]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[2][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(20),
      Q => \snapshot_reg[2]\(20),
      R => \^sr\(0)
    );
\snapshot_reg[2][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(21),
      Q => \snapshot_reg[2]\(21),
      R => \^sr\(0)
    );
\snapshot_reg[2][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(22),
      Q => \snapshot_reg[2]\(22),
      R => \^sr\(0)
    );
\snapshot_reg[2][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(23),
      Q => \snapshot_reg[2]\(23),
      R => \^sr\(0)
    );
\snapshot_reg[2][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(24),
      Q => \snapshot_reg[2]\(24),
      R => \^sr\(0)
    );
\snapshot_reg[2][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(25),
      Q => \snapshot_reg[2]\(25),
      R => \^sr\(0)
    );
\snapshot_reg[2][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(26),
      Q => \snapshot_reg[2]\(26),
      R => \^sr\(0)
    );
\snapshot_reg[2][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(27),
      Q => \snapshot_reg[2]\(27),
      R => \^sr\(0)
    );
\snapshot_reg[2][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(28),
      Q => \snapshot_reg[2]\(28),
      R => \^sr\(0)
    );
\snapshot_reg[2][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(29),
      Q => \snapshot_reg[2]\(29),
      R => \^sr\(0)
    );
\snapshot_reg[2][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(2),
      Q => \snapshot_reg[2]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[2][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(30),
      Q => \snapshot_reg[2]\(30),
      R => \^sr\(0)
    );
\snapshot_reg[2][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(31),
      Q => \snapshot_reg[2]\(31),
      R => \^sr\(0)
    );
\snapshot_reg[2][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(3),
      Q => \snapshot_reg[2]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[2][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(4),
      Q => \snapshot_reg[2]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[2][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(5),
      Q => \snapshot_reg[2]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[2][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(6),
      Q => \snapshot_reg[2]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[2][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(7),
      Q => \snapshot_reg[2]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[2][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(8),
      Q => \snapshot_reg[2]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[2][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => config_epoch_reg(9),
      Q => \snapshot_reg[2]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[3][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_63,
      Q => \snapshot_reg[3]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[3][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_53,
      Q => \snapshot_reg[3]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[3][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_52,
      Q => \snapshot_reg[3]\(11),
      R => \^sr\(0)
    );
\snapshot_reg[3][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_51,
      Q => \snapshot_reg[3]\(12),
      R => \^sr\(0)
    );
\snapshot_reg[3][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_50,
      Q => \snapshot_reg[3]\(13),
      R => \^sr\(0)
    );
\snapshot_reg[3][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_49,
      Q => \snapshot_reg[3]\(14),
      R => \^sr\(0)
    );
\snapshot_reg[3][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_48,
      Q => \snapshot_reg[3]\(15),
      R => \^sr\(0)
    );
\snapshot_reg[3][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_47,
      Q => \snapshot_reg[3]\(16),
      R => \^sr\(0)
    );
\snapshot_reg[3][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_46,
      Q => \snapshot_reg[3]\(17),
      R => \^sr\(0)
    );
\snapshot_reg[3][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_45,
      Q => \snapshot_reg[3]\(18),
      R => \^sr\(0)
    );
\snapshot_reg[3][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_44,
      Q => \snapshot_reg[3]\(19),
      R => \^sr\(0)
    );
\snapshot_reg[3][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_62,
      Q => \snapshot_reg[3]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[3][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_43,
      Q => \snapshot_reg[3]\(20),
      R => \^sr\(0)
    );
\snapshot_reg[3][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_42,
      Q => \snapshot_reg[3]\(21),
      R => \^sr\(0)
    );
\snapshot_reg[3][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_41,
      Q => \snapshot_reg[3]\(22),
      R => \^sr\(0)
    );
\snapshot_reg[3][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_40,
      Q => \snapshot_reg[3]\(23),
      R => \^sr\(0)
    );
\snapshot_reg[3][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_39,
      Q => \snapshot_reg[3]\(24),
      R => \^sr\(0)
    );
\snapshot_reg[3][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_38,
      Q => \snapshot_reg[3]\(25),
      R => \^sr\(0)
    );
\snapshot_reg[3][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_37,
      Q => \snapshot_reg[3]\(26),
      R => \^sr\(0)
    );
\snapshot_reg[3][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_36,
      Q => \snapshot_reg[3]\(27),
      R => \^sr\(0)
    );
\snapshot_reg[3][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_35,
      Q => \snapshot_reg[3]\(28),
      R => \^sr\(0)
    );
\snapshot_reg[3][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_34,
      Q => \snapshot_reg[3]\(29),
      R => \^sr\(0)
    );
\snapshot_reg[3][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_61,
      Q => \snapshot_reg[3]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[3][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_33,
      Q => \snapshot_reg[3]\(30),
      R => \^sr\(0)
    );
\snapshot_reg[3][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_32,
      Q => \snapshot_reg[3]\(31),
      R => \^sr\(0)
    );
\snapshot_reg[3][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_60,
      Q => \snapshot_reg[3]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[3][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_59,
      Q => \snapshot_reg[3]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[3][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_58,
      Q => \snapshot_reg[3]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[3][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_57,
      Q => \snapshot_reg[3]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[3][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_56,
      Q => \snapshot_reg[3]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[3][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_55,
      Q => \snapshot_reg[3]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[3][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => core_n_54,
      Q => \snapshot_reg[3]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[4][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(0),
      Q => \snapshot_reg[4]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[4][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(10),
      Q => \snapshot_reg[4]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[4][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(11),
      Q => \snapshot_reg[4]\(11),
      R => \^sr\(0)
    );
\snapshot_reg[4][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(12),
      Q => \snapshot_reg[4]\(12),
      R => \^sr\(0)
    );
\snapshot_reg[4][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(13),
      Q => \snapshot_reg[4]\(13),
      R => \^sr\(0)
    );
\snapshot_reg[4][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(14),
      Q => \snapshot_reg[4]\(14),
      R => \^sr\(0)
    );
\snapshot_reg[4][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(15),
      Q => \snapshot_reg[4]\(15),
      R => \^sr\(0)
    );
\snapshot_reg[4][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(16),
      Q => \snapshot_reg[4]\(16),
      R => \^sr\(0)
    );
\snapshot_reg[4][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(17),
      Q => \snapshot_reg[4]\(17),
      R => \^sr\(0)
    );
\snapshot_reg[4][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(18),
      Q => \snapshot_reg[4]\(18),
      R => \^sr\(0)
    );
\snapshot_reg[4][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(19),
      Q => \snapshot_reg[4]\(19),
      R => \^sr\(0)
    );
\snapshot_reg[4][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(1),
      Q => \snapshot_reg[4]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[4][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(20),
      Q => \snapshot_reg[4]\(20),
      R => \^sr\(0)
    );
\snapshot_reg[4][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(21),
      Q => \snapshot_reg[4]\(21),
      R => \^sr\(0)
    );
\snapshot_reg[4][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(22),
      Q => \snapshot_reg[4]\(22),
      R => \^sr\(0)
    );
\snapshot_reg[4][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(23),
      Q => \snapshot_reg[4]\(23),
      R => \^sr\(0)
    );
\snapshot_reg[4][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(24),
      Q => \snapshot_reg[4]\(24),
      R => \^sr\(0)
    );
\snapshot_reg[4][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(25),
      Q => \snapshot_reg[4]\(25),
      R => \^sr\(0)
    );
\snapshot_reg[4][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(26),
      Q => \snapshot_reg[4]\(26),
      R => \^sr\(0)
    );
\snapshot_reg[4][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(27),
      Q => \snapshot_reg[4]\(27),
      R => \^sr\(0)
    );
\snapshot_reg[4][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(28),
      Q => \snapshot_reg[4]\(28),
      R => \^sr\(0)
    );
\snapshot_reg[4][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(29),
      Q => \snapshot_reg[4]\(29),
      R => \^sr\(0)
    );
\snapshot_reg[4][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(2),
      Q => \snapshot_reg[4]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[4][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(30),
      Q => \snapshot_reg[4]\(30),
      R => \^sr\(0)
    );
\snapshot_reg[4][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(31),
      Q => \snapshot_reg[4]\(31),
      R => \^sr\(0)
    );
\snapshot_reg[4][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(3),
      Q => \snapshot_reg[4]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[4][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(4),
      Q => \snapshot_reg[4]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[4][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(5),
      Q => \snapshot_reg[4]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[4][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(6),
      Q => \snapshot_reg[4]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[4][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(7),
      Q => \snapshot_reg[4]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[4][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(8),
      Q => \snapshot_reg[4]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[4][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => p_15_in(9),
      Q => \snapshot_reg[4]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[5][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(0),
      Q => \snapshot_reg[5]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[5][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(10),
      Q => \snapshot_reg[5]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[5][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(11),
      Q => \snapshot_reg[5]\(11),
      R => \^sr\(0)
    );
\snapshot_reg[5][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(12),
      Q => \snapshot_reg[5]\(12),
      R => \^sr\(0)
    );
\snapshot_reg[5][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(13),
      Q => \snapshot_reg[5]\(13),
      R => \^sr\(0)
    );
\snapshot_reg[5][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(14),
      Q => \snapshot_reg[5]\(14),
      R => \^sr\(0)
    );
\snapshot_reg[5][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(15),
      Q => \snapshot_reg[5]\(15),
      R => \^sr\(0)
    );
\snapshot_reg[5][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(16),
      Q => \snapshot_reg[5]\(16),
      R => \^sr\(0)
    );
\snapshot_reg[5][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(17),
      Q => \snapshot_reg[5]\(17),
      R => \^sr\(0)
    );
\snapshot_reg[5][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(18),
      Q => \snapshot_reg[5]\(18),
      R => \^sr\(0)
    );
\snapshot_reg[5][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(19),
      Q => \snapshot_reg[5]\(19),
      R => \^sr\(0)
    );
\snapshot_reg[5][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(1),
      Q => \snapshot_reg[5]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[5][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(20),
      Q => \snapshot_reg[5]\(20),
      R => \^sr\(0)
    );
\snapshot_reg[5][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(21),
      Q => \snapshot_reg[5]\(21),
      R => \^sr\(0)
    );
\snapshot_reg[5][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(22),
      Q => \snapshot_reg[5]\(22),
      R => \^sr\(0)
    );
\snapshot_reg[5][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(23),
      Q => \snapshot_reg[5]\(23),
      R => \^sr\(0)
    );
\snapshot_reg[5][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(24),
      Q => \snapshot_reg[5]\(24),
      R => \^sr\(0)
    );
\snapshot_reg[5][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(25),
      Q => \snapshot_reg[5]\(25),
      R => \^sr\(0)
    );
\snapshot_reg[5][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(26),
      Q => \snapshot_reg[5]\(26),
      R => \^sr\(0)
    );
\snapshot_reg[5][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(27),
      Q => \snapshot_reg[5]\(27),
      R => \^sr\(0)
    );
\snapshot_reg[5][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(28),
      Q => \snapshot_reg[5]\(28),
      R => \^sr\(0)
    );
\snapshot_reg[5][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(29),
      Q => \snapshot_reg[5]\(29),
      R => \^sr\(0)
    );
\snapshot_reg[5][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(2),
      Q => \snapshot_reg[5]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[5][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(30),
      Q => \snapshot_reg[5]\(30),
      R => \^sr\(0)
    );
\snapshot_reg[5][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(31),
      Q => \snapshot_reg[5]\(31),
      R => \^sr\(0)
    );
\snapshot_reg[5][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(3),
      Q => \snapshot_reg[5]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[5][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(4),
      Q => \snapshot_reg[5]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[5][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(5),
      Q => \snapshot_reg[5]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[5][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(6),
      Q => \snapshot_reg[5]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[5][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(7),
      Q => \snapshot_reg[5]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[5][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(8),
      Q => \snapshot_reg[5]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[5][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => window_count(9),
      Q => \snapshot_reg[5]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[6][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(0),
      Q => \snapshot_reg[6]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[6][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(10),
      Q => \snapshot_reg[6]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[6][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(11),
      Q => \snapshot_reg[6]\(11),
      R => \^sr\(0)
    );
\snapshot_reg[6][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(12),
      Q => \snapshot_reg[6]\(12),
      R => \^sr\(0)
    );
\snapshot_reg[6][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(13),
      Q => \snapshot_reg[6]\(13),
      R => \^sr\(0)
    );
\snapshot_reg[6][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(14),
      Q => \snapshot_reg[6]\(14),
      R => \^sr\(0)
    );
\snapshot_reg[6][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(15),
      Q => \snapshot_reg[6]\(15),
      R => \^sr\(0)
    );
\snapshot_reg[6][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(16),
      Q => \snapshot_reg[6]\(16),
      R => \^sr\(0)
    );
\snapshot_reg[6][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(17),
      Q => \snapshot_reg[6]\(17),
      R => \^sr\(0)
    );
\snapshot_reg[6][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(18),
      Q => \snapshot_reg[6]\(18),
      R => \^sr\(0)
    );
\snapshot_reg[6][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(19),
      Q => \snapshot_reg[6]\(19),
      R => \^sr\(0)
    );
\snapshot_reg[6][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(1),
      Q => \snapshot_reg[6]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[6][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(20),
      Q => \snapshot_reg[6]\(20),
      R => \^sr\(0)
    );
\snapshot_reg[6][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(21),
      Q => \snapshot_reg[6]\(21),
      R => \^sr\(0)
    );
\snapshot_reg[6][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(22),
      Q => \snapshot_reg[6]\(22),
      R => \^sr\(0)
    );
\snapshot_reg[6][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(23),
      Q => \snapshot_reg[6]\(23),
      R => \^sr\(0)
    );
\snapshot_reg[6][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(24),
      Q => \snapshot_reg[6]\(24),
      R => \^sr\(0)
    );
\snapshot_reg[6][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(25),
      Q => \snapshot_reg[6]\(25),
      R => \^sr\(0)
    );
\snapshot_reg[6][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(26),
      Q => \snapshot_reg[6]\(26),
      R => \^sr\(0)
    );
\snapshot_reg[6][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(27),
      Q => \snapshot_reg[6]\(27),
      R => \^sr\(0)
    );
\snapshot_reg[6][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(28),
      Q => \snapshot_reg[6]\(28),
      R => \^sr\(0)
    );
\snapshot_reg[6][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(29),
      Q => \snapshot_reg[6]\(29),
      R => \^sr\(0)
    );
\snapshot_reg[6][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(2),
      Q => \snapshot_reg[6]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[6][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(30),
      Q => \snapshot_reg[6]\(30),
      R => \^sr\(0)
    );
\snapshot_reg[6][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(31),
      Q => \snapshot_reg[6]\(31),
      R => \^sr\(0)
    );
\snapshot_reg[6][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(3),
      Q => \snapshot_reg[6]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[6][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(4),
      Q => \snapshot_reg[6]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[6][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(5),
      Q => \snapshot_reg[6]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[6][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(6),
      Q => \snapshot_reg[6]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[6][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(7),
      Q => \snapshot_reg[6]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[6][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(8),
      Q => \snapshot_reg[6]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[6][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => last_sum(9),
      Q => \snapshot_reg[6]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[7][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(0),
      Q => \snapshot_reg[7]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[7][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(10),
      Q => \snapshot_reg[7]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[7][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(11),
      Q => \snapshot_reg[7]\(11),
      R => \^sr\(0)
    );
\snapshot_reg[7][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(12),
      Q => \snapshot_reg[7]\(12),
      R => \^sr\(0)
    );
\snapshot_reg[7][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(13),
      Q => \snapshot_reg[7]\(13),
      R => \^sr\(0)
    );
\snapshot_reg[7][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(14),
      Q => \snapshot_reg[7]\(14),
      R => \^sr\(0)
    );
\snapshot_reg[7][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(15),
      Q => \snapshot_reg[7]\(15),
      R => \^sr\(0)
    );
\snapshot_reg[7][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(16),
      Q => \snapshot_reg[7]\(16),
      R => \^sr\(0)
    );
\snapshot_reg[7][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(17),
      Q => \snapshot_reg[7]\(17),
      R => \^sr\(0)
    );
\snapshot_reg[7][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(18),
      Q => \snapshot_reg[7]\(18),
      R => \^sr\(0)
    );
\snapshot_reg[7][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(19),
      Q => \snapshot_reg[7]\(19),
      R => \^sr\(0)
    );
\snapshot_reg[7][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(1),
      Q => \snapshot_reg[7]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[7][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(20),
      Q => \snapshot_reg[7]\(20),
      R => \^sr\(0)
    );
\snapshot_reg[7][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(21),
      Q => \snapshot_reg[7]\(21),
      R => \^sr\(0)
    );
\snapshot_reg[7][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(22),
      Q => \snapshot_reg[7]\(22),
      R => \^sr\(0)
    );
\snapshot_reg[7][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(23),
      Q => \snapshot_reg[7]\(23),
      R => \^sr\(0)
    );
\snapshot_reg[7][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(24),
      Q => \snapshot_reg[7]\(24),
      R => \^sr\(0)
    );
\snapshot_reg[7][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(25),
      Q => \snapshot_reg[7]\(25),
      R => \^sr\(0)
    );
\snapshot_reg[7][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(26),
      Q => \snapshot_reg[7]\(26),
      R => \^sr\(0)
    );
\snapshot_reg[7][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(27),
      Q => \snapshot_reg[7]\(27),
      R => \^sr\(0)
    );
\snapshot_reg[7][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(28),
      Q => \snapshot_reg[7]\(28),
      R => \^sr\(0)
    );
\snapshot_reg[7][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(29),
      Q => \snapshot_reg[7]\(29),
      R => \^sr\(0)
    );
\snapshot_reg[7][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(2),
      Q => \snapshot_reg[7]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[7][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(30),
      Q => \snapshot_reg[7]\(30),
      R => \^sr\(0)
    );
\snapshot_reg[7][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(31),
      Q => \snapshot_reg[7]\(31),
      R => \^sr\(0)
    );
\snapshot_reg[7][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(3),
      Q => \snapshot_reg[7]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[7][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(4),
      Q => \snapshot_reg[7]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[7][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(5),
      Q => \snapshot_reg[7]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[7][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(6),
      Q => \snapshot_reg[7]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[7][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(7),
      Q => \snapshot_reg[7]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[7][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(8),
      Q => \snapshot_reg[7]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[7][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_sequence(9),
      Q => \snapshot_reg[7]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[8][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(0),
      Q => \snapshot_reg[8]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[8][10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(10),
      Q => \snapshot_reg[8]\(10),
      R => \^sr\(0)
    );
\snapshot_reg[8][11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(11),
      Q => \snapshot_reg[8]\(11),
      R => \^sr\(0)
    );
\snapshot_reg[8][12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(12),
      Q => \snapshot_reg[8]\(12),
      R => \^sr\(0)
    );
\snapshot_reg[8][13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(13),
      Q => \snapshot_reg[8]\(13),
      R => \^sr\(0)
    );
\snapshot_reg[8][14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(14),
      Q => \snapshot_reg[8]\(14),
      R => \^sr\(0)
    );
\snapshot_reg[8][15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(15),
      Q => \snapshot_reg[8]\(15),
      R => \^sr\(0)
    );
\snapshot_reg[8][16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(16),
      Q => \snapshot_reg[8]\(16),
      R => \^sr\(0)
    );
\snapshot_reg[8][17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(17),
      Q => \snapshot_reg[8]\(17),
      R => \^sr\(0)
    );
\snapshot_reg[8][18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(18),
      Q => \snapshot_reg[8]\(18),
      R => \^sr\(0)
    );
\snapshot_reg[8][19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(19),
      Q => \snapshot_reg[8]\(19),
      R => \^sr\(0)
    );
\snapshot_reg[8][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(1),
      Q => \snapshot_reg[8]\(1),
      R => \^sr\(0)
    );
\snapshot_reg[8][20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(20),
      Q => \snapshot_reg[8]\(20),
      R => \^sr\(0)
    );
\snapshot_reg[8][21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(21),
      Q => \snapshot_reg[8]\(21),
      R => \^sr\(0)
    );
\snapshot_reg[8][22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(22),
      Q => \snapshot_reg[8]\(22),
      R => \^sr\(0)
    );
\snapshot_reg[8][23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(23),
      Q => \snapshot_reg[8]\(23),
      R => \^sr\(0)
    );
\snapshot_reg[8][24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(24),
      Q => \snapshot_reg[8]\(24),
      R => \^sr\(0)
    );
\snapshot_reg[8][25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(25),
      Q => \snapshot_reg[8]\(25),
      R => \^sr\(0)
    );
\snapshot_reg[8][26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(26),
      Q => \snapshot_reg[8]\(26),
      R => \^sr\(0)
    );
\snapshot_reg[8][27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(27),
      Q => \snapshot_reg[8]\(27),
      R => \^sr\(0)
    );
\snapshot_reg[8][28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(28),
      Q => \snapshot_reg[8]\(28),
      R => \^sr\(0)
    );
\snapshot_reg[8][29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(29),
      Q => \snapshot_reg[8]\(29),
      R => \^sr\(0)
    );
\snapshot_reg[8][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(2),
      Q => \snapshot_reg[8]\(2),
      R => \^sr\(0)
    );
\snapshot_reg[8][30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(30),
      Q => \snapshot_reg[8]\(30),
      R => \^sr\(0)
    );
\snapshot_reg[8][31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(31),
      Q => \snapshot_reg[8]\(31),
      R => \^sr\(0)
    );
\snapshot_reg[8][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(3),
      Q => \snapshot_reg[8]\(3),
      R => \^sr\(0)
    );
\snapshot_reg[8][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(4),
      Q => \snapshot_reg[8]\(4),
      R => \^sr\(0)
    );
\snapshot_reg[8][5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(5),
      Q => \snapshot_reg[8]\(5),
      R => \^sr\(0)
    );
\snapshot_reg[8][6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(6),
      Q => \snapshot_reg[8]\(6),
      R => \^sr\(0)
    );
\snapshot_reg[8][7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(7),
      Q => \snapshot_reg[8]\(7),
      R => \^sr\(0)
    );
\snapshot_reg[8][8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(8),
      Q => \snapshot_reg[8]\(8),
      R => \^sr\(0)
    );
\snapshot_reg[8][9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_epoch(9),
      Q => \snapshot_reg[8]\(9),
      R => \^sr\(0)
    );
\snapshot_reg[9][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_kind(0),
      Q => \snapshot_reg[9]\(0),
      R => \^sr\(0)
    );
\snapshot_reg[9][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => event_kind(1),
      Q => \snapshot_reg[9]\(1),
      R => \^sr\(0)
    );
\snapshot_sequence[0]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => snapshot_sequence_reg(0),
      O => \snapshot_sequence[0]_i_2_n_0\
    );
\snapshot_sequence_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[0]_i_1_n_7\,
      Q => snapshot_sequence_reg(0),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[0]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \snapshot_sequence_reg[0]_i_1_n_0\,
      CO(2) => \snapshot_sequence_reg[0]_i_1_n_1\,
      CO(1) => \snapshot_sequence_reg[0]_i_1_n_2\,
      CO(0) => \snapshot_sequence_reg[0]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \snapshot_sequence_reg[0]_i_1_n_4\,
      O(2) => \snapshot_sequence_reg[0]_i_1_n_5\,
      O(1) => \snapshot_sequence_reg[0]_i_1_n_6\,
      O(0) => \snapshot_sequence_reg[0]_i_1_n_7\,
      S(3 downto 1) => snapshot_sequence_reg(3 downto 1),
      S(0) => \snapshot_sequence[0]_i_2_n_0\
    );
\snapshot_sequence_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[8]_i_1_n_5\,
      Q => snapshot_sequence_reg(10),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[8]_i_1_n_4\,
      Q => snapshot_sequence_reg(11),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[12]_i_1_n_7\,
      Q => snapshot_sequence_reg(12),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \snapshot_sequence_reg[8]_i_1_n_0\,
      CO(3) => \snapshot_sequence_reg[12]_i_1_n_0\,
      CO(2) => \snapshot_sequence_reg[12]_i_1_n_1\,
      CO(1) => \snapshot_sequence_reg[12]_i_1_n_2\,
      CO(0) => \snapshot_sequence_reg[12]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \snapshot_sequence_reg[12]_i_1_n_4\,
      O(2) => \snapshot_sequence_reg[12]_i_1_n_5\,
      O(1) => \snapshot_sequence_reg[12]_i_1_n_6\,
      O(0) => \snapshot_sequence_reg[12]_i_1_n_7\,
      S(3 downto 0) => snapshot_sequence_reg(15 downto 12)
    );
\snapshot_sequence_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[12]_i_1_n_6\,
      Q => snapshot_sequence_reg(13),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[12]_i_1_n_5\,
      Q => snapshot_sequence_reg(14),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[12]_i_1_n_4\,
      Q => snapshot_sequence_reg(15),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[16]_i_1_n_7\,
      Q => snapshot_sequence_reg(16),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[16]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \snapshot_sequence_reg[12]_i_1_n_0\,
      CO(3) => \snapshot_sequence_reg[16]_i_1_n_0\,
      CO(2) => \snapshot_sequence_reg[16]_i_1_n_1\,
      CO(1) => \snapshot_sequence_reg[16]_i_1_n_2\,
      CO(0) => \snapshot_sequence_reg[16]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \snapshot_sequence_reg[16]_i_1_n_4\,
      O(2) => \snapshot_sequence_reg[16]_i_1_n_5\,
      O(1) => \snapshot_sequence_reg[16]_i_1_n_6\,
      O(0) => \snapshot_sequence_reg[16]_i_1_n_7\,
      S(3 downto 0) => snapshot_sequence_reg(19 downto 16)
    );
\snapshot_sequence_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[16]_i_1_n_6\,
      Q => snapshot_sequence_reg(17),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[16]_i_1_n_5\,
      Q => snapshot_sequence_reg(18),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[16]_i_1_n_4\,
      Q => snapshot_sequence_reg(19),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[0]_i_1_n_6\,
      Q => snapshot_sequence_reg(1),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[20]_i_1_n_7\,
      Q => snapshot_sequence_reg(20),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[20]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \snapshot_sequence_reg[16]_i_1_n_0\,
      CO(3) => \snapshot_sequence_reg[20]_i_1_n_0\,
      CO(2) => \snapshot_sequence_reg[20]_i_1_n_1\,
      CO(1) => \snapshot_sequence_reg[20]_i_1_n_2\,
      CO(0) => \snapshot_sequence_reg[20]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \snapshot_sequence_reg[20]_i_1_n_4\,
      O(2) => \snapshot_sequence_reg[20]_i_1_n_5\,
      O(1) => \snapshot_sequence_reg[20]_i_1_n_6\,
      O(0) => \snapshot_sequence_reg[20]_i_1_n_7\,
      S(3 downto 0) => snapshot_sequence_reg(23 downto 20)
    );
\snapshot_sequence_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[20]_i_1_n_6\,
      Q => snapshot_sequence_reg(21),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[20]_i_1_n_5\,
      Q => snapshot_sequence_reg(22),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[20]_i_1_n_4\,
      Q => snapshot_sequence_reg(23),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[24]_i_1_n_7\,
      Q => snapshot_sequence_reg(24),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[24]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \snapshot_sequence_reg[20]_i_1_n_0\,
      CO(3) => \snapshot_sequence_reg[24]_i_1_n_0\,
      CO(2) => \snapshot_sequence_reg[24]_i_1_n_1\,
      CO(1) => \snapshot_sequence_reg[24]_i_1_n_2\,
      CO(0) => \snapshot_sequence_reg[24]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \snapshot_sequence_reg[24]_i_1_n_4\,
      O(2) => \snapshot_sequence_reg[24]_i_1_n_5\,
      O(1) => \snapshot_sequence_reg[24]_i_1_n_6\,
      O(0) => \snapshot_sequence_reg[24]_i_1_n_7\,
      S(3 downto 0) => snapshot_sequence_reg(27 downto 24)
    );
\snapshot_sequence_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[24]_i_1_n_6\,
      Q => snapshot_sequence_reg(25),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[24]_i_1_n_5\,
      Q => snapshot_sequence_reg(26),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[24]_i_1_n_4\,
      Q => snapshot_sequence_reg(27),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[28]_i_1_n_7\,
      Q => snapshot_sequence_reg(28),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[28]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \snapshot_sequence_reg[24]_i_1_n_0\,
      CO(3) => \NLW_snapshot_sequence_reg[28]_i_1_CO_UNCONNECTED\(3),
      CO(2) => \snapshot_sequence_reg[28]_i_1_n_1\,
      CO(1) => \snapshot_sequence_reg[28]_i_1_n_2\,
      CO(0) => \snapshot_sequence_reg[28]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \snapshot_sequence_reg[28]_i_1_n_4\,
      O(2) => \snapshot_sequence_reg[28]_i_1_n_5\,
      O(1) => \snapshot_sequence_reg[28]_i_1_n_6\,
      O(0) => \snapshot_sequence_reg[28]_i_1_n_7\,
      S(3 downto 0) => snapshot_sequence_reg(31 downto 28)
    );
\snapshot_sequence_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[28]_i_1_n_6\,
      Q => snapshot_sequence_reg(29),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[0]_i_1_n_5\,
      Q => snapshot_sequence_reg(2),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[28]_i_1_n_5\,
      Q => snapshot_sequence_reg(30),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[28]_i_1_n_4\,
      Q => snapshot_sequence_reg(31),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[0]_i_1_n_4\,
      Q => snapshot_sequence_reg(3),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[4]_i_1_n_7\,
      Q => snapshot_sequence_reg(4),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \snapshot_sequence_reg[0]_i_1_n_0\,
      CO(3) => \snapshot_sequence_reg[4]_i_1_n_0\,
      CO(2) => \snapshot_sequence_reg[4]_i_1_n_1\,
      CO(1) => \snapshot_sequence_reg[4]_i_1_n_2\,
      CO(0) => \snapshot_sequence_reg[4]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \snapshot_sequence_reg[4]_i_1_n_4\,
      O(2) => \snapshot_sequence_reg[4]_i_1_n_5\,
      O(1) => \snapshot_sequence_reg[4]_i_1_n_6\,
      O(0) => \snapshot_sequence_reg[4]_i_1_n_7\,
      S(3 downto 0) => snapshot_sequence_reg(7 downto 4)
    );
\snapshot_sequence_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[4]_i_1_n_6\,
      Q => snapshot_sequence_reg(5),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[4]_i_1_n_5\,
      Q => snapshot_sequence_reg(6),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[4]_i_1_n_4\,
      Q => snapshot_sequence_reg(7),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[8]_i_1_n_7\,
      Q => snapshot_sequence_reg(8),
      R => \^sr\(0)
    );
\snapshot_sequence_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \snapshot_sequence_reg[4]_i_1_n_0\,
      CO(3) => \snapshot_sequence_reg[8]_i_1_n_0\,
      CO(2) => \snapshot_sequence_reg[8]_i_1_n_1\,
      CO(1) => \snapshot_sequence_reg[8]_i_1_n_2\,
      CO(0) => \snapshot_sequence_reg[8]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \snapshot_sequence_reg[8]_i_1_n_4\,
      O(2) => \snapshot_sequence_reg[8]_i_1_n_5\,
      O(1) => \snapshot_sequence_reg[8]_i_1_n_6\,
      O(0) => \snapshot_sequence_reg[8]_i_1_n_7\,
      S(3 downto 0) => snapshot_sequence_reg(11 downto 8)
    );
\snapshot_sequence_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \snapshot[0][10]_i_1_n_0\,
      D => \snapshot_sequence_reg[8]_i_1_n_6\,
      Q => snapshot_sequence_reg(9),
      R => \^sr\(0)
    );
snapshot_valid_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"00EB"
    )
        port map (
      I0 => write_data(0),
      I1 => write_data(2),
      I2 => write_data(1),
      I3 => \soft_sum[31]_i_3_n_0\,
      O => snapshot_valid_i_2_n_0
    );
snapshot_valid_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => core_n_235,
      Q => snapshot_valid,
      R => '0'
    );
\soft_sum[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => \soft_sum[31]_i_2_n_0\,
      I1 => \soft_sum[31]_i_3_n_0\,
      I2 => \soft_sum[31]_i_4_n_0\,
      O => enable
    );
\soft_sum[31]_i_10\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[5]\,
      I1 => \shadow_soft_reg_n_0_[4]\,
      I2 => \shadow_soft_reg_n_0_[7]\,
      I3 => \shadow_soft_reg_n_0_[6]\,
      O => \soft_sum[31]_i_10_n_0\
    );
\soft_sum[31]_i_11\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[8]\,
      I1 => \shadow_soft_reg_n_0_[9]\,
      I2 => \shadow_soft_reg_n_0_[10]\,
      I3 => \shadow_soft_reg_n_0_[11]\,
      I4 => \soft_sum[31]_i_18_n_0\,
      O => \soft_sum[31]_i_11_n_0\
    );
\soft_sum[31]_i_12\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[23]\,
      I1 => \shadow_soft_reg_n_0_[22]\,
      I2 => \shadow_soft_reg_n_0_[21]\,
      I3 => \shadow_soft_reg_n_0_[20]\,
      O => \soft_sum[31]_i_12_n_0\
    );
\soft_sum[31]_i_13\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[24]\,
      I1 => \shadow_soft_reg_n_0_[27]\,
      I2 => \shadow_soft_reg_n_0_[25]\,
      I3 => \shadow_soft_reg_n_0_[26]\,
      I4 => \soft_sum[31]_i_19_n_0\,
      O => \soft_sum[31]_i_13_n_0\
    );
\soft_sum[31]_i_14\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => config_epoch_reg(25),
      I1 => config_epoch_reg(14),
      I2 => config_epoch_reg(17),
      I3 => config_epoch_reg(6),
      O => \soft_sum[31]_i_14_n_0\
    );
\soft_sum[31]_i_15\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => config_epoch_reg(16),
      I1 => config_epoch_reg(19),
      I2 => config_epoch_reg(8),
      I3 => config_epoch_reg(9),
      I4 => \soft_sum[31]_i_20_n_0\,
      O => \soft_sum[31]_i_15_n_0\
    );
\soft_sum[31]_i_16\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => config_epoch_reg(3),
      I1 => config_epoch_reg(0),
      I2 => config_epoch_reg(24),
      I3 => config_epoch_reg(23),
      O => \soft_sum[31]_i_16_n_0\
    );
\soft_sum[31]_i_17\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => config_epoch_reg(28),
      I1 => config_epoch_reg(29),
      I2 => config_epoch_reg(31),
      I3 => config_epoch_reg(30),
      I4 => \soft_sum[31]_i_21_n_0\,
      O => \soft_sum[31]_i_17_n_0\
    );
\soft_sum[31]_i_18\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[13]\,
      I1 => \shadow_soft_reg_n_0_[12]\,
      I2 => \shadow_soft_reg_n_0_[15]\,
      I3 => \shadow_soft_reg_n_0_[14]\,
      O => \soft_sum[31]_i_18_n_0\
    );
\soft_sum[31]_i_19\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \shadow_soft_reg_n_0_[29]\,
      I1 => \shadow_soft_reg_n_0_[28]\,
      I2 => \shadow_soft_reg_n_0_[31]\,
      I3 => \shadow_soft_reg_n_0_[30]\,
      O => \soft_sum[31]_i_19_n_0\
    );
\soft_sum[31]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_3_n_0\,
      I1 => \snapshot[0][10]_i_2_n_0\,
      O => \soft_sum[31]_i_2_n_0\
    );
\soft_sum[31]_i_20\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => config_epoch_reg(22),
      I1 => config_epoch_reg(21),
      I2 => config_epoch_reg(20),
      I3 => config_epoch_reg(18),
      O => \soft_sum[31]_i_20_n_0\
    );
\soft_sum[31]_i_21\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => config_epoch_reg(27),
      I1 => config_epoch_reg(26),
      I2 => config_epoch_reg(15),
      I3 => config_epoch_reg(13),
      O => \soft_sum[31]_i_21_n_0\
    );
\soft_sum[31]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000DD0D"
    )
        port map (
      I0 => \soft_sum[31]_i_5_n_0\,
      I1 => \soft_sum[31]_i_6_n_0\,
      I2 => \soft_sum[31]_i_7_n_0\,
      I3 => \soft_sum[31]_i_8_n_0\,
      I4 => \soft_sum[31]_i_9_n_0\,
      O => \soft_sum[31]_i_3_n_0\
    );
\soft_sum[31]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BFFF"
    )
        port map (
      I0 => \^s_axi_bvalid_reg_0\,
      I1 => w_held_reg_n_0,
      I2 => aw_held,
      I3 => \s_axi_bresp[1]_i_6_n_0\,
      O => \soft_sum[31]_i_4_n_0\
    );
\soft_sum[31]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => \soft_sum[31]_i_10_n_0\,
      I1 => \shadow_soft_reg_n_0_[2]\,
      I2 => \shadow_soft_reg_n_0_[1]\,
      I3 => \shadow_soft_reg_n_0_[3]\,
      I4 => \shadow_soft_reg_n_0_[0]\,
      I5 => \soft_sum[31]_i_11_n_0\,
      O => \soft_sum[31]_i_5_n_0\
    );
\soft_sum[31]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \soft_sum[31]_i_12_n_0\,
      I1 => \shadow_soft_reg_n_0_[18]\,
      I2 => \shadow_soft_reg_n_0_[17]\,
      I3 => \shadow_soft_reg_n_0_[19]\,
      I4 => \shadow_soft_reg_n_0_[16]\,
      I5 => \soft_sum[31]_i_13_n_0\,
      O => \soft_sum[31]_i_6_n_0\
    );
\soft_sum[31]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040000000"
    )
        port map (
      I0 => \soft_sum[31]_i_14_n_0\,
      I1 => config_epoch_reg(11),
      I2 => config_epoch_reg(10),
      I3 => config_epoch_reg(12),
      I4 => config_epoch_reg(1),
      I5 => \soft_sum[31]_i_15_n_0\,
      O => \soft_sum[31]_i_7_n_0\
    );
\soft_sum[31]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFBFFFFFFF"
    )
        port map (
      I0 => \soft_sum[31]_i_16_n_0\,
      I1 => config_epoch_reg(7),
      I2 => config_epoch_reg(4),
      I3 => config_epoch_reg(5),
      I4 => config_epoch_reg(2),
      I5 => \soft_sum[31]_i_17_n_0\,
      O => \soft_sum[31]_i_8_n_0\
    );
\soft_sum[31]_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFEFF"
    )
        port map (
      I0 => write_data(1),
      I1 => write_data(2),
      I2 => s_axi_bresp3,
      I3 => write_data(0),
      I4 => s_axi_bresp4,
      O => \soft_sum[31]_i_9_n_0\
    );
\soft_sum_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[0]\,
      Q => \soft_sum_reg_n_0_[0]\,
      R => \^sr\(0)
    );
\soft_sum_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[10]\,
      Q => \soft_sum_reg_n_0_[10]\,
      R => \^sr\(0)
    );
\soft_sum_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[11]\,
      Q => \soft_sum_reg_n_0_[11]\,
      R => \^sr\(0)
    );
\soft_sum_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[12]\,
      Q => \soft_sum_reg_n_0_[12]\,
      R => \^sr\(0)
    );
\soft_sum_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[13]\,
      Q => \soft_sum_reg_n_0_[13]\,
      R => \^sr\(0)
    );
\soft_sum_reg[14]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[14]\,
      Q => \soft_sum_reg_n_0_[14]\,
      S => \^sr\(0)
    );
\soft_sum_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[15]\,
      Q => \soft_sum_reg_n_0_[15]\,
      R => \^sr\(0)
    );
\soft_sum_reg[16]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[16]\,
      Q => \soft_sum_reg_n_0_[16]\,
      S => \^sr\(0)
    );
\soft_sum_reg[17]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[17]\,
      Q => \soft_sum_reg_n_0_[17]\,
      S => \^sr\(0)
    );
\soft_sum_reg[18]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[18]\,
      Q => \soft_sum_reg_n_0_[18]\,
      S => \^sr\(0)
    );
\soft_sum_reg[19]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[19]\,
      Q => \soft_sum_reg_n_0_[19]\,
      S => \^sr\(0)
    );
\soft_sum_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[1]\,
      Q => \soft_sum_reg_n_0_[1]\,
      R => \^sr\(0)
    );
\soft_sum_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[20]\,
      Q => \soft_sum_reg_n_0_[20]\,
      R => \^sr\(0)
    );
\soft_sum_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[21]\,
      Q => \soft_sum_reg_n_0_[21]\,
      R => \^sr\(0)
    );
\soft_sum_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[22]\,
      Q => \soft_sum_reg_n_0_[22]\,
      R => \^sr\(0)
    );
\soft_sum_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[23]\,
      Q => \soft_sum_reg_n_0_[23]\,
      R => \^sr\(0)
    );
\soft_sum_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[24]\,
      Q => \soft_sum_reg_n_0_[24]\,
      R => \^sr\(0)
    );
\soft_sum_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[25]\,
      Q => \soft_sum_reg_n_0_[25]\,
      R => \^sr\(0)
    );
\soft_sum_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[26]\,
      Q => \soft_sum_reg_n_0_[26]\,
      R => \^sr\(0)
    );
\soft_sum_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[27]\,
      Q => \soft_sum_reg_n_0_[27]\,
      R => \^sr\(0)
    );
\soft_sum_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[28]\,
      Q => \soft_sum_reg_n_0_[28]\,
      R => \^sr\(0)
    );
\soft_sum_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[29]\,
      Q => \soft_sum_reg_n_0_[29]\,
      R => \^sr\(0)
    );
\soft_sum_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[2]\,
      Q => \soft_sum_reg_n_0_[2]\,
      R => \^sr\(0)
    );
\soft_sum_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[30]\,
      Q => \soft_sum_reg_n_0_[30]\,
      R => \^sr\(0)
    );
\soft_sum_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[31]\,
      Q => \soft_sum_reg_n_0_[31]\,
      R => \^sr\(0)
    );
\soft_sum_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[3]\,
      Q => \soft_sum_reg_n_0_[3]\,
      R => \^sr\(0)
    );
\soft_sum_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[4]\,
      Q => \soft_sum_reg_n_0_[4]\,
      R => \^sr\(0)
    );
\soft_sum_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[5]\,
      Q => \soft_sum_reg_n_0_[5]\,
      R => \^sr\(0)
    );
\soft_sum_reg[6]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[6]\,
      Q => \soft_sum_reg_n_0_[6]\,
      S => \^sr\(0)
    );
\soft_sum_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[7]\,
      Q => \soft_sum_reg_n_0_[7]\,
      R => \^sr\(0)
    );
\soft_sum_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[8]\,
      Q => \soft_sum_reg_n_0_[8]\,
      R => \^sr\(0)
    );
\soft_sum_reg[9]\: unisim.vcomponents.FDSE
     port map (
      C => s_axi_aclk,
      CE => enable,
      D => \shadow_soft_reg_n_0_[9]\,
      Q => \soft_sum_reg_n_0_[9]\,
      S => \^sr\(0)
    );
w_held_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CC000C88"
    )
        port map (
      I0 => s_axi_wvalid,
      I1 => s_axi_aresetn,
      I2 => aw_held,
      I3 => w_held_reg_n_0,
      I4 => \^s_axi_bvalid_reg_0\,
      O => w_held_i_1_n_0
    );
w_held_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => w_held_i_1_n_0,
      Q => w_held_reg_n_0,
      R => '0'
    );
\write_address[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => \^s_axi_bvalid_reg_0\,
      I2 => aw_held,
      O => aw_held0
    );
\write_address_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(0),
      Q => write_address(0),
      R => \^sr\(0)
    );
\write_address_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(10),
      Q => write_address(10),
      R => \^sr\(0)
    );
\write_address_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(11),
      Q => write_address(11),
      R => \^sr\(0)
    );
\write_address_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(1),
      Q => write_address(1),
      R => \^sr\(0)
    );
\write_address_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(2),
      Q => write_address(2),
      R => \^sr\(0)
    );
\write_address_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(3),
      Q => write_address(3),
      R => \^sr\(0)
    );
\write_address_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(4),
      Q => write_address(4),
      R => \^sr\(0)
    );
\write_address_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(5),
      Q => write_address(5),
      R => \^sr\(0)
    );
\write_address_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(6),
      Q => write_address(6),
      R => \^sr\(0)
    );
\write_address_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(7),
      Q => write_address(7),
      R => \^sr\(0)
    );
\write_address_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(8),
      Q => write_address(8),
      R => \^sr\(0)
    );
\write_address_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(9),
      Q => write_address(9),
      R => \^sr\(0)
    );
\write_data[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => s_axi_wvalid,
      I1 => \^s_axi_bvalid_reg_0\,
      I2 => w_held_reg_n_0,
      O => w_held0
    );
\write_data_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(0),
      Q => write_data(0),
      R => \^sr\(0)
    );
\write_data_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(10),
      Q => write_data(10),
      R => \^sr\(0)
    );
\write_data_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(11),
      Q => write_data(11),
      R => \^sr\(0)
    );
\write_data_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(12),
      Q => write_data(12),
      R => \^sr\(0)
    );
\write_data_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(13),
      Q => write_data(13),
      R => \^sr\(0)
    );
\write_data_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(14),
      Q => write_data(14),
      R => \^sr\(0)
    );
\write_data_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(15),
      Q => write_data(15),
      R => \^sr\(0)
    );
\write_data_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(16),
      Q => write_data(16),
      R => \^sr\(0)
    );
\write_data_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(17),
      Q => write_data(17),
      R => \^sr\(0)
    );
\write_data_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(18),
      Q => write_data(18),
      R => \^sr\(0)
    );
\write_data_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(19),
      Q => write_data(19),
      R => \^sr\(0)
    );
\write_data_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(1),
      Q => write_data(1),
      R => \^sr\(0)
    );
\write_data_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(20),
      Q => write_data(20),
      R => \^sr\(0)
    );
\write_data_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(21),
      Q => write_data(21),
      R => \^sr\(0)
    );
\write_data_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(22),
      Q => write_data(22),
      R => \^sr\(0)
    );
\write_data_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(23),
      Q => write_data(23),
      R => \^sr\(0)
    );
\write_data_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(24),
      Q => write_data(24),
      R => \^sr\(0)
    );
\write_data_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(25),
      Q => write_data(25),
      R => \^sr\(0)
    );
\write_data_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(26),
      Q => write_data(26),
      R => \^sr\(0)
    );
\write_data_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(27),
      Q => write_data(27),
      R => \^sr\(0)
    );
\write_data_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(28),
      Q => write_data(28),
      R => \^sr\(0)
    );
\write_data_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(29),
      Q => write_data(29),
      R => \^sr\(0)
    );
\write_data_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(2),
      Q => write_data(2),
      R => \^sr\(0)
    );
\write_data_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(30),
      Q => write_data(30),
      R => \^sr\(0)
    );
\write_data_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(31),
      Q => write_data(31),
      R => \^sr\(0)
    );
\write_data_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(3),
      Q => write_data(3),
      R => \^sr\(0)
    );
\write_data_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(4),
      Q => write_data(4),
      R => \^sr\(0)
    );
\write_data_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(5),
      Q => write_data(5),
      R => \^sr\(0)
    );
\write_data_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(6),
      Q => write_data(6),
      R => \^sr\(0)
    );
\write_data_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(7),
      Q => write_data(7),
      R => \^sr\(0)
    );
\write_data_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(8),
      Q => write_data(8),
      R => \^sr\(0)
    );
\write_data_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(9),
      Q => write_data(9),
      R => \^sr\(0)
    );
\write_strobe_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wstrb(0),
      Q => write_strobe(0),
      R => \^sr\(0)
    );
\write_strobe_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wstrb(1),
      Q => write_strobe(1),
      R => \^sr\(0)
    );
\write_strobe_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wstrb(2),
      Q => write_strobe(2),
      R => \^sr\(0)
    );
\write_strobe_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wstrb(3),
      Q => write_strobe(3),
      R => \^sr\(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_voice_volume_0_0_voice_volume_top is
  port (
    O115 : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wready : out STD_LOGIC;
    s_axi_bvalid_reg : out STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rvalid_reg : out STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_aresetn : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    i2s_sdata : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    codec_mclk_locked : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_awvalid : in STD_LOGIC;
    s_axi_arvalid : in STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_voice_volume_0_0_voice_volume_top : entity is "voice_volume_top";
end c6v_voice_volume_0_0_voice_volume_top;

architecture STRUCTURE of c6v_voice_volume_0_0_voice_volume_top is
  signal \^o115\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \audio_counter[10]_i_2_n_0\ : STD_LOGIC;
  signal \audio_counter_reg_n_0_[0]\ : STD_LOGIC;
  signal \audio_counter_reg_n_0_[1]\ : STD_LOGIC;
  signal \audio_counter_reg_n_0_[2]\ : STD_LOGIC;
  signal \audio_counter_reg_n_0_[3]\ : STD_LOGIC;
  signal \audio_counter_reg_n_0_[5]\ : STD_LOGIC;
  signal \audio_counter_reg_n_0_[6]\ : STD_LOGIC;
  signal \audio_counter_reg_n_0_[7]\ : STD_LOGIC;
  signal \audio_counter_reg_n_0_[8]\ : STD_LOGIC;
  signal \audio_counter_reg_n_0_[9]\ : STD_LOGIC;
  signal \core/dc_clipped0\ : STD_LOGIC;
  signal \core/dc_level\ : STD_LOGIC_VECTOR ( 22 downto 8 );
  signal input_fault : STD_LOGIC;
  signal locked_sync : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute async_reg : string;
  attribute async_reg of locked_sync : signal is "true";
  signal p_0_in : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal pcm_s16 : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal pcm_valid : STD_LOGIC;
  signal receiver_n_2 : STD_LOGIC;
  signal receiver_n_22 : STD_LOGIC;
  signal receiver_n_23 : STD_LOGIC;
  signal receiver_n_24 : STD_LOGIC;
  signal receiver_n_25 : STD_LOGIC;
  signal receiver_n_26 : STD_LOGIC;
  signal receiver_n_27 : STD_LOGIC;
  signal receiver_n_28 : STD_LOGIC;
  signal receiver_n_29 : STD_LOGIC;
  signal receiver_n_3 : STD_LOGIC;
  signal receiver_n_30 : STD_LOGIC;
  signal receiver_n_31 : STD_LOGIC;
  signal receiver_n_32 : STD_LOGIC;
  signal receiver_n_4 : STD_LOGIC;
  signal receiver_n_5 : STD_LOGIC;
  signal registers_n_1 : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \audio_counter[1]_i_1\ : label is "soft_lutpair56";
  attribute SOFT_HLUTNM of \audio_counter[2]_i_1\ : label is "soft_lutpair56";
  attribute SOFT_HLUTNM of \audio_counter[3]_i_1\ : label is "soft_lutpair54";
  attribute SOFT_HLUTNM of \audio_counter[4]_i_1\ : label is "soft_lutpair54";
  attribute SOFT_HLUTNM of \audio_counter[6]_i_1\ : label is "soft_lutpair57";
  attribute SOFT_HLUTNM of \audio_counter[7]_i_1\ : label is "soft_lutpair57";
  attribute SOFT_HLUTNM of \audio_counter[8]_i_1\ : label is "soft_lutpair55";
  attribute SOFT_HLUTNM of \audio_counter[9]_i_1\ : label is "soft_lutpair55";
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \locked_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \locked_sync_reg[0]\ : label is "yes";
  attribute ASYNC_REG_boolean of \locked_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \locked_sync_reg[1]\ : label is "yes";
begin
  O115(1 downto 0) <= \^o115\(1 downto 0);
\audio_counter[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \audio_counter_reg_n_0_[0]\,
      O => p_0_in(0)
    );
\audio_counter[10]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => \^o115\(1),
      I1 => \audio_counter_reg_n_0_[8]\,
      I2 => \audio_counter_reg_n_0_[6]\,
      I3 => \audio_counter[10]_i_2_n_0\,
      I4 => \audio_counter_reg_n_0_[7]\,
      I5 => \audio_counter_reg_n_0_[9]\,
      O => p_0_in(10)
    );
\audio_counter[10]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => \audio_counter_reg_n_0_[5]\,
      I1 => \audio_counter_reg_n_0_[3]\,
      I2 => \audio_counter_reg_n_0_[0]\,
      I3 => \audio_counter_reg_n_0_[1]\,
      I4 => \audio_counter_reg_n_0_[2]\,
      I5 => \^o115\(0),
      O => \audio_counter[10]_i_2_n_0\
    );
\audio_counter[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \audio_counter_reg_n_0_[0]\,
      I1 => \audio_counter_reg_n_0_[1]\,
      O => p_0_in(1)
    );
\audio_counter[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \audio_counter_reg_n_0_[2]\,
      I1 => \audio_counter_reg_n_0_[1]\,
      I2 => \audio_counter_reg_n_0_[0]\,
      O => p_0_in(2)
    );
\audio_counter[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \audio_counter_reg_n_0_[3]\,
      I1 => \audio_counter_reg_n_0_[0]\,
      I2 => \audio_counter_reg_n_0_[1]\,
      I3 => \audio_counter_reg_n_0_[2]\,
      O => p_0_in(3)
    );
\audio_counter[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \^o115\(0),
      I1 => \audio_counter_reg_n_0_[2]\,
      I2 => \audio_counter_reg_n_0_[1]\,
      I3 => \audio_counter_reg_n_0_[0]\,
      I4 => \audio_counter_reg_n_0_[3]\,
      O => p_0_in(4)
    );
\audio_counter[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAAAAAAAAAAAAA"
    )
        port map (
      I0 => \audio_counter_reg_n_0_[5]\,
      I1 => \audio_counter_reg_n_0_[3]\,
      I2 => \audio_counter_reg_n_0_[0]\,
      I3 => \audio_counter_reg_n_0_[1]\,
      I4 => \audio_counter_reg_n_0_[2]\,
      I5 => \^o115\(0),
      O => p_0_in(5)
    );
\audio_counter[6]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \audio_counter_reg_n_0_[6]\,
      I1 => \audio_counter[10]_i_2_n_0\,
      O => p_0_in(6)
    );
\audio_counter[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \audio_counter_reg_n_0_[7]\,
      I1 => \audio_counter[10]_i_2_n_0\,
      I2 => \audio_counter_reg_n_0_[6]\,
      O => p_0_in(7)
    );
\audio_counter[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \audio_counter_reg_n_0_[8]\,
      I1 => \audio_counter_reg_n_0_[6]\,
      I2 => \audio_counter[10]_i_2_n_0\,
      I3 => \audio_counter_reg_n_0_[7]\,
      O => p_0_in(8)
    );
\audio_counter[9]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \audio_counter_reg_n_0_[9]\,
      I1 => \audio_counter_reg_n_0_[7]\,
      I2 => \audio_counter[10]_i_2_n_0\,
      I3 => \audio_counter_reg_n_0_[6]\,
      I4 => \audio_counter_reg_n_0_[8]\,
      O => p_0_in(9)
    );
\audio_counter_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in(0),
      Q => \audio_counter_reg_n_0_[0]\,
      R => '0'
    );
\audio_counter_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in(10),
      Q => \^o115\(1),
      R => '0'
    );
\audio_counter_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in(1),
      Q => \audio_counter_reg_n_0_[1]\,
      R => '0'
    );
\audio_counter_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in(2),
      Q => \audio_counter_reg_n_0_[2]\,
      R => '0'
    );
\audio_counter_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in(3),
      Q => \audio_counter_reg_n_0_[3]\,
      R => '0'
    );
\audio_counter_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in(4),
      Q => \^o115\(0),
      R => '0'
    );
\audio_counter_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in(5),
      Q => \audio_counter_reg_n_0_[5]\,
      R => '0'
    );
\audio_counter_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in(6),
      Q => \audio_counter_reg_n_0_[6]\,
      R => '0'
    );
\audio_counter_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in(7),
      Q => \audio_counter_reg_n_0_[7]\,
      R => '0'
    );
\audio_counter_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in(8),
      Q => \audio_counter_reg_n_0_[8]\,
      R => '0'
    );
\audio_counter_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in(9),
      Q => \audio_counter_reg_n_0_[9]\,
      R => '0'
    );
\locked_sync_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => codec_mclk_locked,
      Q => locked_sync(0),
      R => registers_n_1
    );
\locked_sync_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => locked_sync(0),
      Q => locked_sync(1),
      R => registers_n_1
    );
receiver: entity work.c6v_voice_volume_0_0_voice_volume_i2s_rx
     port map (
      O115(1 downto 0) => \^o115\(1 downto 0),
      Q(15 downto 0) => pcm_s16(15 downto 0),
      S(3) => receiver_n_2,
      S(2) => receiver_n_3,
      S(1) => receiver_n_4,
      S(0) => receiver_n_5,
      SR(0) => registers_n_1,
      dc_clipped0 => \core/dc_clipped0\,
      \difference_latched_reg[24]\(14 downto 0) => \core/dc_level\(22 downto 8),
      i2s_sdata => i2s_sdata,
      input_fault => input_fault,
      \pcm_s16_reg[0]_0\(0) => receiver_n_32,
      \pcm_s16_reg[12]_0\(3) => receiver_n_22,
      \pcm_s16_reg[12]_0\(2) => receiver_n_23,
      \pcm_s16_reg[12]_0\(1) => receiver_n_24,
      \pcm_s16_reg[12]_0\(0) => receiver_n_25,
      \pcm_s16_reg[14]_0\(1) => receiver_n_26,
      \pcm_s16_reg[14]_0\(0) => receiver_n_27,
      \pcm_s16_reg[4]_0\(3) => receiver_n_28,
      \pcm_s16_reg[4]_0\(2) => receiver_n_29,
      \pcm_s16_reg[4]_0\(1) => receiver_n_30,
      \pcm_s16_reg[4]_0\(0) => receiver_n_31,
      pcm_valid => pcm_valid,
      s_axi_aclk => s_axi_aclk,
      s_axi_aresetn => s_axi_aresetn
    );
registers: entity work.c6v_voice_volume_0_0_axi_voice_volume
     port map (
      D(15 downto 0) => pcm_s16(15 downto 0),
      Q(14 downto 0) => \core/dc_level\(22 downto 8),
      S(3) => receiver_n_2,
      S(2) => receiver_n_3,
      S(1) => receiver_n_4,
      S(0) => receiver_n_5,
      SR(0) => registers_n_1,
      dc_clipped0 => \core/dc_clipped0\,
      \difference_latched_reg[12]\(0) => receiver_n_32,
      \difference_latched_reg[12]_0\(3) => receiver_n_28,
      \difference_latched_reg[12]_0\(2) => receiver_n_29,
      \difference_latched_reg[12]_0\(1) => receiver_n_30,
      \difference_latched_reg[12]_0\(0) => receiver_n_31,
      \difference_latched_reg[20]\(3) => receiver_n_22,
      \difference_latched_reg[20]\(2) => receiver_n_23,
      \difference_latched_reg[20]\(1) => receiver_n_24,
      \difference_latched_reg[20]\(0) => receiver_n_25,
      \difference_latched_reg[24]\(1) => receiver_n_26,
      \difference_latched_reg[24]\(0) => receiver_n_27,
      input_fault => input_fault,
      \out\(0) => locked_sync(1),
      pcm_valid => pcm_valid,
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(11 downto 0) => s_axi_araddr(11 downto 0),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arready => s_axi_arready,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(11 downto 0) => s_axi_awaddr(11 downto 0),
      s_axi_awready => s_axi_awready,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bready => s_axi_bready,
      s_axi_bresp(0) => s_axi_bresp(0),
      s_axi_bvalid_reg_0 => s_axi_bvalid_reg,
      s_axi_rdata(31 downto 0) => s_axi_rdata(31 downto 0),
      s_axi_rready => s_axi_rready,
      s_axi_rresp(0) => s_axi_rresp(0),
      s_axi_rvalid_reg_0 => s_axi_rvalid_reg,
      s_axi_wdata(31 downto 0) => s_axi_wdata(31 downto 0),
      s_axi_wready => s_axi_wready,
      s_axi_wstrb(3 downto 0) => s_axi_wstrb(3 downto 0),
      s_axi_wvalid => s_axi_wvalid
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_voice_volume_0_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
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
    s_axi_araddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    i2s_bclk : out STD_LOGIC;
    i2s_lrclk : out STD_LOGIC;
    i2s_sdata : in STD_LOGIC;
    codec_address : out STD_LOGIC_VECTOR ( 1 downto 0 );
    codec_mclk_locked : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of c6v_voice_volume_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_voice_volume_0_0 : entity is "c6v_voice_volume_0_0,voice_volume_top,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_voice_volume_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_voice_volume_0_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of c6v_voice_volume_0_0 : entity is "voice_volume_top,Vivado 2026.1";
end c6v_voice_volume_0_0;

architecture STRUCTURE of c6v_voice_volume_0_0 is
  signal \<const0>\ : STD_LOGIC;
  signal \<const1>\ : STD_LOGIC;
  signal \^s_axi_bresp\ : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \^s_axi_rresp\ : STD_LOGIC_VECTOR ( 1 to 1 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of s_axi_aclk : signal is "xilinx.com:signal:clock:1.0 s_axi_aclk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of s_axi_aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of s_axi_aclk : signal is "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF s_axi, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_aresetn : signal is "xilinx.com:signal:reset:1.0 s_axi_aresetn RST";
  attribute X_INTERFACE_MODE of s_axi_aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s_axi_aresetn : signal is "XIL_INTERFACENAME s_axi_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_arready : signal is "xilinx.com:interface:aximm:1.0 s_axi ARREADY";
  attribute X_INTERFACE_INFO of s_axi_arvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi ARVALID";
  attribute X_INTERFACE_INFO of s_axi_awready : signal is "xilinx.com:interface:aximm:1.0 s_axi AWREADY";
  attribute X_INTERFACE_INFO of s_axi_awvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi AWVALID";
  attribute X_INTERFACE_INFO of s_axi_bready : signal is "xilinx.com:interface:aximm:1.0 s_axi BREADY";
  attribute X_INTERFACE_INFO of s_axi_bvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi BVALID";
  attribute X_INTERFACE_INFO of s_axi_rready : signal is "xilinx.com:interface:aximm:1.0 s_axi RREADY";
  attribute X_INTERFACE_INFO of s_axi_rvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi RVALID";
  attribute X_INTERFACE_INFO of s_axi_wready : signal is "xilinx.com:interface:aximm:1.0 s_axi WREADY";
  attribute X_INTERFACE_INFO of s_axi_wvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi WVALID";
  attribute X_INTERFACE_INFO of s_axi_araddr : signal is "xilinx.com:interface:aximm:1.0 s_axi ARADDR";
  attribute X_INTERFACE_INFO of s_axi_arprot : signal is "xilinx.com:interface:aximm:1.0 s_axi ARPROT";
  attribute X_INTERFACE_INFO of s_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 s_axi AWADDR";
  attribute X_INTERFACE_MODE of s_axi_awaddr : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s_axi_awaddr : signal is "XIL_INTERFACENAME s_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 12, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_awprot : signal is "xilinx.com:interface:aximm:1.0 s_axi AWPROT";
  attribute X_INTERFACE_INFO of s_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 s_axi BRESP";
  attribute X_INTERFACE_INFO of s_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 s_axi RDATA";
  attribute X_INTERFACE_INFO of s_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 s_axi RRESP";
  attribute X_INTERFACE_INFO of s_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 s_axi WDATA";
  attribute X_INTERFACE_INFO of s_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 s_axi WSTRB";
begin
  codec_address(1) <= \<const1>\;
  codec_address(0) <= \<const1>\;
  s_axi_bresp(1) <= \^s_axi_bresp\(1);
  s_axi_bresp(0) <= \<const0>\;
  s_axi_rresp(1) <= \^s_axi_rresp\(1);
  s_axi_rresp(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
inst: entity work.c6v_voice_volume_0_0_voice_volume_top
     port map (
      O115(1) => i2s_lrclk,
      O115(0) => i2s_bclk,
      codec_mclk_locked => codec_mclk_locked,
      i2s_sdata => i2s_sdata,
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(11 downto 0) => s_axi_araddr(11 downto 0),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arready => s_axi_arready,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(11 downto 0) => s_axi_awaddr(11 downto 0),
      s_axi_awready => s_axi_awready,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bready => s_axi_bready,
      s_axi_bresp(0) => \^s_axi_bresp\(1),
      s_axi_bvalid_reg => s_axi_bvalid,
      s_axi_rdata(31 downto 0) => s_axi_rdata(31 downto 0),
      s_axi_rready => s_axi_rready,
      s_axi_rresp(0) => \^s_axi_rresp\(1),
      s_axi_rvalid_reg => s_axi_rvalid,
      s_axi_wdata(31 downto 0) => s_axi_wdata(31 downto 0),
      s_axi_wready => s_axi_wready,
      s_axi_wstrb(3 downto 0) => s_axi_wstrb(3 downto 0),
      s_axi_wvalid => s_axi_wvalid
    );
end STRUCTURE;
