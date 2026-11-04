-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 30 22:04:33 2026
-- Host        : build-host running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_status_0/c6v_capture_status_0_sim_netlist.vhdl
-- Design      : c6v_capture_status_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_capture_status_0_axi_vision_capture_status is
  port (
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wready : out STD_LOGIC;
    s_axi_bvalid_reg_0 : out STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rvalid_reg_0 : out STD_LOGIC;
    capture_armed : in STD_LOGIC;
    monitor_ready : in STD_LOGIC;
    epoch_sealed : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_aclk : in STD_LOGIC;
    capture_epoch : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_aresetn : in STD_LOGIC;
    s_axi_arvalid : in STD_LOGIC;
    fault_causes : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_bready : in STD_LOGIC;
    s_axi_awvalid : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_capture_status_0_axi_vision_capture_status : entity is "axi_vision_capture_status";
end c6v_capture_status_0_axi_vision_capture_status;

architecture STRUCTURE of c6v_capture_status_0_axi_vision_capture_status is
  signal aw_held : STD_LOGIC;
  signal aw_held_i_1_n_0 : STD_LOGIC;
  signal epoch_held : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal epoch_seen : STD_LOGIC;
  signal epoch_seen_i_1_n_0 : STD_LOGIC;
  signal faults_held : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal p_0_in : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal p_1_in : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal \protocol_fault1_carry__0_n_0\ : STD_LOGIC;
  signal \protocol_fault1_carry__0_n_1\ : STD_LOGIC;
  signal \protocol_fault1_carry__0_n_2\ : STD_LOGIC;
  signal \protocol_fault1_carry__0_n_3\ : STD_LOGIC;
  signal \protocol_fault1_carry__1_n_1\ : STD_LOGIC;
  signal \protocol_fault1_carry__1_n_2\ : STD_LOGIC;
  signal \protocol_fault1_carry__1_n_3\ : STD_LOGIC;
  signal \protocol_fault1_carry_i_1__0_n_0\ : STD_LOGIC;
  signal \protocol_fault1_carry_i_1__1_n_0\ : STD_LOGIC;
  signal protocol_fault1_carry_i_1_n_0 : STD_LOGIC;
  signal \protocol_fault1_carry_i_2__0_n_0\ : STD_LOGIC;
  signal \protocol_fault1_carry_i_2__1_n_0\ : STD_LOGIC;
  signal protocol_fault1_carry_i_2_n_0 : STD_LOGIC;
  signal \protocol_fault1_carry_i_3__0_n_0\ : STD_LOGIC;
  signal \protocol_fault1_carry_i_3__1_n_0\ : STD_LOGIC;
  signal protocol_fault1_carry_i_3_n_0 : STD_LOGIC;
  signal \protocol_fault1_carry_i_4__0_n_0\ : STD_LOGIC;
  signal protocol_fault1_carry_i_4_n_0 : STD_LOGIC;
  signal protocol_fault1_carry_n_0 : STD_LOGIC;
  signal protocol_fault1_carry_n_1 : STD_LOGIC;
  signal protocol_fault1_carry_n_2 : STD_LOGIC;
  signal protocol_fault1_carry_n_3 : STD_LOGIC;
  signal s_axi_bvalid_i_1_n_0 : STD_LOGIC;
  signal s_axi_bvalid_i_2_n_0 : STD_LOGIC;
  signal \^s_axi_bvalid_reg_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rresp[1]_i_1_n_0\ : STD_LOGIC;
  signal s_axi_rvalid02_out : STD_LOGIC;
  signal s_axi_rvalid_i_1_n_0 : STD_LOGIC;
  signal \^s_axi_rvalid_reg_0\ : STD_LOGIC;
  signal w_held_i_1_n_0 : STD_LOGIC;
  signal w_held_reg_n_0 : STD_LOGIC;
  signal NLW_protocol_fault1_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_protocol_fault1_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_protocol_fault1_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_protocol_fault1_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of aw_held_i_1 : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \faults_held[0]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of s_axi_arready_INST_0 : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of s_axi_awready_INST_0 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \s_axi_rdata[0]_i_3\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \s_axi_rdata[4]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \s_axi_rresp[1]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of s_axi_rvalid_i_1 : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of s_axi_wready_INST_0 : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of w_held_i_1 : label is "soft_lutpair2";
begin
  s_axi_bvalid_reg_0 <= \^s_axi_bvalid_reg_0\;
  s_axi_rvalid_reg_0 <= \^s_axi_rvalid_reg_0\;
aw_held_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CC0C0088"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => s_axi_aresetn,
      I2 => w_held_reg_n_0,
      I3 => \^s_axi_bvalid_reg_0\,
      I4 => aw_held,
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
\epoch_held_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(0),
      Q => epoch_held(0),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(10),
      Q => epoch_held(10),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(11),
      Q => epoch_held(11),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(12),
      Q => epoch_held(12),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(13),
      Q => epoch_held(13),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(14),
      Q => epoch_held(14),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(15),
      Q => epoch_held(15),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(16),
      Q => epoch_held(16),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(17),
      Q => epoch_held(17),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(18),
      Q => epoch_held(18),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(19),
      Q => epoch_held(19),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(1),
      Q => epoch_held(1),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(20),
      Q => epoch_held(20),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(21),
      Q => epoch_held(21),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(22),
      Q => epoch_held(22),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(23),
      Q => epoch_held(23),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(24),
      Q => epoch_held(24),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(25),
      Q => epoch_held(25),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(26),
      Q => epoch_held(26),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(27),
      Q => epoch_held(27),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(28),
      Q => epoch_held(28),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(29),
      Q => epoch_held(29),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(2),
      Q => epoch_held(2),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(30),
      Q => epoch_held(30),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(31),
      Q => epoch_held(31),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(3),
      Q => epoch_held(3),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(4),
      Q => epoch_held(4),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(5),
      Q => epoch_held(5),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(6),
      Q => epoch_held(6),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(7),
      Q => epoch_held(7),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(8),
      Q => epoch_held(8),
      R => s_axi_bvalid_i_1_n_0
    );
\epoch_held_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => capture_epoch(9),
      Q => epoch_held(9),
      R => s_axi_bvalid_i_1_n_0
    );
epoch_seen_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => epoch_seen,
      I1 => capture_armed,
      I2 => monitor_ready,
      O => epoch_seen_i_1_n_0
    );
epoch_seen_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => epoch_seen_i_1_n_0,
      D => '1',
      Q => epoch_seen,
      R => s_axi_bvalid_i_1_n_0
    );
\faults_held[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => faults_held(0),
      I1 => fault_causes(0),
      O => p_0_in(0)
    );
\faults_held[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => fault_causes(1),
      I1 => faults_held(1),
      O => p_0_in(1)
    );
\faults_held[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FEEEFEFEFEFEFEFE"
    )
        port map (
      I0 => faults_held(2),
      I1 => fault_causes(2),
      I2 => epoch_seen,
      I3 => \protocol_fault1_carry__1_n_1\,
      I4 => capture_armed,
      I5 => monitor_ready,
      O => p_0_in(2)
    );
\faults_held_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in(0),
      Q => faults_held(0),
      R => s_axi_bvalid_i_1_n_0
    );
\faults_held_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in(1),
      Q => faults_held(1),
      R => s_axi_bvalid_i_1_n_0
    );
\faults_held_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => p_0_in(2),
      Q => faults_held(2),
      R => s_axi_bvalid_i_1_n_0
    );
protocol_fault1_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => protocol_fault1_carry_n_0,
      CO(2) => protocol_fault1_carry_n_1,
      CO(1) => protocol_fault1_carry_n_2,
      CO(0) => protocol_fault1_carry_n_3,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => NLW_protocol_fault1_carry_O_UNCONNECTED(3 downto 0),
      S(3) => protocol_fault1_carry_i_1_n_0,
      S(2) => protocol_fault1_carry_i_2_n_0,
      S(1) => protocol_fault1_carry_i_3_n_0,
      S(0) => protocol_fault1_carry_i_4_n_0
    );
\protocol_fault1_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => protocol_fault1_carry_n_0,
      CO(3) => \protocol_fault1_carry__0_n_0\,
      CO(2) => \protocol_fault1_carry__0_n_1\,
      CO(1) => \protocol_fault1_carry__0_n_2\,
      CO(0) => \protocol_fault1_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_protocol_fault1_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \protocol_fault1_carry_i_1__0_n_0\,
      S(2) => \protocol_fault1_carry_i_2__0_n_0\,
      S(1) => \protocol_fault1_carry_i_3__0_n_0\,
      S(0) => \protocol_fault1_carry_i_4__0_n_0\
    );
\protocol_fault1_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \protocol_fault1_carry__0_n_0\,
      CO(3) => \NLW_protocol_fault1_carry__1_CO_UNCONNECTED\(3),
      CO(2) => \protocol_fault1_carry__1_n_1\,
      CO(1) => \protocol_fault1_carry__1_n_2\,
      CO(0) => \protocol_fault1_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0111",
      O(3 downto 0) => \NLW_protocol_fault1_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \protocol_fault1_carry_i_1__1_n_0\,
      S(1) => \protocol_fault1_carry_i_2__1_n_0\,
      S(0) => \protocol_fault1_carry_i_3__1_n_0\
    );
protocol_fault1_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => epoch_held(10),
      I1 => capture_epoch(10),
      I2 => capture_epoch(11),
      I3 => epoch_held(11),
      I4 => capture_epoch(9),
      I5 => epoch_held(9),
      O => protocol_fault1_carry_i_1_n_0
    );
\protocol_fault1_carry_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => epoch_held(21),
      I1 => capture_epoch(21),
      I2 => capture_epoch(23),
      I3 => epoch_held(23),
      I4 => capture_epoch(22),
      I5 => epoch_held(22),
      O => \protocol_fault1_carry_i_1__0_n_0\
    );
\protocol_fault1_carry_i_1__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => epoch_held(30),
      I1 => capture_epoch(30),
      I2 => epoch_held(31),
      I3 => capture_epoch(31),
      O => \protocol_fault1_carry_i_1__1_n_0\
    );
protocol_fault1_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => epoch_held(7),
      I1 => capture_epoch(7),
      I2 => capture_epoch(8),
      I3 => epoch_held(8),
      I4 => capture_epoch(6),
      I5 => epoch_held(6),
      O => protocol_fault1_carry_i_2_n_0
    );
\protocol_fault1_carry_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => epoch_held(19),
      I1 => capture_epoch(19),
      I2 => capture_epoch(20),
      I3 => epoch_held(20),
      I4 => capture_epoch(18),
      I5 => epoch_held(18),
      O => \protocol_fault1_carry_i_2__0_n_0\
    );
\protocol_fault1_carry_i_2__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => epoch_held(27),
      I1 => capture_epoch(27),
      I2 => capture_epoch(29),
      I3 => epoch_held(29),
      I4 => capture_epoch(28),
      I5 => epoch_held(28),
      O => \protocol_fault1_carry_i_2__1_n_0\
    );
protocol_fault1_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => epoch_held(5),
      I1 => capture_epoch(5),
      I2 => capture_epoch(3),
      I3 => epoch_held(3),
      I4 => capture_epoch(4),
      I5 => epoch_held(4),
      O => protocol_fault1_carry_i_3_n_0
    );
\protocol_fault1_carry_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => epoch_held(15),
      I1 => capture_epoch(15),
      I2 => capture_epoch(17),
      I3 => epoch_held(17),
      I4 => capture_epoch(16),
      I5 => epoch_held(16),
      O => \protocol_fault1_carry_i_3__0_n_0\
    );
\protocol_fault1_carry_i_3__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => epoch_held(26),
      I1 => capture_epoch(26),
      I2 => capture_epoch(25),
      I3 => epoch_held(25),
      I4 => capture_epoch(24),
      I5 => epoch_held(24),
      O => \protocol_fault1_carry_i_3__1_n_0\
    );
protocol_fault1_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => capture_epoch(0),
      I1 => epoch_held(0),
      I2 => capture_epoch(1),
      I3 => epoch_held(1),
      I4 => epoch_held(2),
      I5 => capture_epoch(2),
      O => protocol_fault1_carry_i_4_n_0
    );
\protocol_fault1_carry_i_4__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => epoch_held(13),
      I1 => capture_epoch(13),
      I2 => capture_epoch(14),
      I3 => epoch_held(14),
      I4 => capture_epoch(12),
      I5 => epoch_held(12),
      O => \protocol_fault1_carry_i_4__0_n_0\
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
      I0 => \^s_axi_bvalid_reg_0\,
      I1 => s_axi_aresetn,
      I2 => aw_held,
      O => s_axi_awready
    );
s_axi_bvalid_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s_axi_aresetn,
      O => s_axi_bvalid_i_1_n_0
    );
s_axi_bvalid_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"08F8"
    )
        port map (
      I0 => aw_held,
      I1 => w_held_reg_n_0,
      I2 => \^s_axi_bvalid_reg_0\,
      I3 => s_axi_bready,
      O => s_axi_bvalid_i_2_n_0
    );
s_axi_bvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => s_axi_bvalid_i_2_n_0,
      Q => \^s_axi_bvalid_reg_0\,
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4444454444444444"
    )
        port map (
      I0 => \s_axi_rdata[29]_i_2_n_0\,
      I1 => \s_axi_rdata[0]_i_2_n_0\,
      I2 => \s_axi_rdata[0]_i_3_n_0\,
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => s_axi_araddr(2),
      O => \s_axi_rdata[0]_i_1_n_0\
    );
\s_axi_rdata[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"1140004000400040"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(4),
      I2 => epoch_held(0),
      I3 => s_axi_araddr(3),
      I4 => monitor_ready,
      I5 => epoch_seen,
      O => \s_axi_rdata[0]_i_2_n_0\
    );
\s_axi_rdata[0]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => fault_causes(0),
      I1 => faults_held(0),
      O => \s_axi_rdata[0]_i_3_n_0\
    );
\s_axi_rdata[10]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(10),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(10)
    );
\s_axi_rdata[11]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(11),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(11)
    );
\s_axi_rdata[12]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01000101"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \s_axi_rdata[29]_i_2_n_0\,
      I2 => s_axi_araddr(3),
      I3 => epoch_held(12),
      I4 => s_axi_araddr(4),
      O => p_1_in(12)
    );
\s_axi_rdata[13]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(13),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(13)
    );
\s_axi_rdata[14]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01000101"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \s_axi_rdata[29]_i_2_n_0\,
      I2 => s_axi_araddr(3),
      I3 => epoch_held(14),
      I4 => s_axi_araddr(4),
      O => p_1_in(14)
    );
\s_axi_rdata[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(15),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(15)
    );
\s_axi_rdata[16]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000064"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => s_axi_araddr(2),
      I2 => epoch_held(16),
      I3 => \s_axi_rdata[29]_i_2_n_0\,
      I4 => s_axi_araddr(3),
      O => p_1_in(16)
    );
\s_axi_rdata[17]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(17),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(17)
    );
\s_axi_rdata[18]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01000101"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \s_axi_rdata[29]_i_2_n_0\,
      I2 => s_axi_araddr(3),
      I3 => epoch_held(18),
      I4 => s_axi_araddr(4),
      O => p_1_in(18)
    );
\s_axi_rdata[19]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(19),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(19)
    );
\s_axi_rdata[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"44444544"
    )
        port map (
      I0 => \s_axi_rdata[29]_i_2_n_0\,
      I1 => \s_axi_rdata[1]_i_2_n_0\,
      I2 => \s_axi_rdata[1]_i_3_n_0\,
      I3 => epoch_sealed,
      I4 => s_axi_araddr(2),
      O => \s_axi_rdata[1]_i_1_n_0\
    );
\s_axi_rdata[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0C230C230C230023"
    )
        port map (
      I0 => epoch_held(1),
      I1 => s_axi_araddr(2),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => fault_causes(1),
      I5 => faults_held(1),
      O => \s_axi_rdata[1]_i_2_n_0\
    );
\s_axi_rdata[1]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BF"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => epoch_seen,
      I2 => monitor_ready,
      O => \s_axi_rdata[1]_i_3_n_0\
    );
\s_axi_rdata[20]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01000101"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \s_axi_rdata[29]_i_2_n_0\,
      I2 => s_axi_araddr(3),
      I3 => epoch_held(20),
      I4 => s_axi_araddr(4),
      O => p_1_in(20)
    );
\s_axi_rdata[21]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(21),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(21)
    );
\s_axi_rdata[22]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01000101"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \s_axi_rdata[29]_i_2_n_0\,
      I2 => s_axi_araddr(3),
      I3 => epoch_held(22),
      I4 => s_axi_araddr(4),
      O => p_1_in(22)
    );
\s_axi_rdata[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(23),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(23)
    );
\s_axi_rdata[24]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01000101"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \s_axi_rdata[29]_i_2_n_0\,
      I2 => s_axi_araddr(3),
      I3 => epoch_held(24),
      I4 => s_axi_araddr(4),
      O => p_1_in(24)
    );
\s_axi_rdata[25]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(25),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(25)
    );
\s_axi_rdata[26]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(26),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(26)
    );
\s_axi_rdata[27]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(27),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(27)
    );
\s_axi_rdata[28]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01000101"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \s_axi_rdata[29]_i_2_n_0\,
      I2 => s_axi_araddr(3),
      I3 => epoch_held(28),
      I4 => s_axi_araddr(4),
      O => p_1_in(28)
    );
\s_axi_rdata[29]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01000101"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \s_axi_rdata[29]_i_2_n_0\,
      I2 => s_axi_araddr(3),
      I3 => epoch_held(29),
      I4 => s_axi_araddr(4),
      O => p_1_in(29)
    );
\s_axi_rdata[29]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(1),
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => s_axi_araddr(10),
      I4 => s_axi_araddr(8),
      I5 => s_axi_araddr(9),
      O => \s_axi_rdata[29]_i_2_n_0\
    );
\s_axi_rdata[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000000EAA0E0A"
    )
        port map (
      I0 => \s_axi_rdata[2]_i_2_n_0\,
      I1 => p_0_in(2),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(3),
      I4 => epoch_held(2),
      I5 => \s_axi_rdata[29]_i_2_n_0\,
      O => p_1_in(2)
    );
\s_axi_rdata[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFFFFFFD"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => faults_held(0),
      I2 => fault_causes(0),
      I3 => faults_held(1),
      I4 => fault_causes(1),
      I5 => s_axi_araddr(2),
      O => \s_axi_rdata[2]_i_2_n_0\
    );
\s_axi_rdata[30]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(30),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(30)
    );
\s_axi_rdata[31]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"4"
    )
        port map (
      I0 => \^s_axi_rvalid_reg_0\,
      I1 => s_axi_arvalid,
      O => s_axi_rvalid02_out
    );
\s_axi_rdata[31]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(31),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(31)
    );
\s_axi_rdata[31]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000002"
    )
        port map (
      I0 => s_axi_araddr(4),
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => s_axi_araddr(10),
      I3 => s_axi_araddr(8),
      I4 => s_axi_araddr(9),
      O => \s_axi_rdata[31]_i_3_n_0\
    );
\s_axi_rdata[31]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => s_axi_araddr(7),
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(11),
      I3 => s_axi_araddr(6),
      O => \s_axi_rdata[31]_i_4_n_0\
    );
\s_axi_rdata[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(3),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(3)
    );
\s_axi_rdata[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01000101"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \s_axi_rdata[29]_i_2_n_0\,
      I2 => s_axi_araddr(3),
      I3 => epoch_held(4),
      I4 => s_axi_araddr(4),
      O => p_1_in(4)
    );
\s_axi_rdata[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(5),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(5)
    );
\s_axi_rdata[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01000101"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \s_axi_rdata[29]_i_2_n_0\,
      I2 => s_axi_araddr(3),
      I3 => epoch_held(6),
      I4 => s_axi_araddr(4),
      O => p_1_in(6)
    );
\s_axi_rdata[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_3_n_0\,
      I1 => epoch_held(7),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => p_1_in(7)
    );
\s_axi_rdata[8]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01000101"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \s_axi_rdata[29]_i_2_n_0\,
      I2 => s_axi_araddr(3),
      I3 => epoch_held(8),
      I4 => s_axi_araddr(4),
      O => p_1_in(8)
    );
\s_axi_rdata[9]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01000101"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => \s_axi_rdata[29]_i_2_n_0\,
      I2 => s_axi_araddr(3),
      I3 => epoch_held(9),
      I4 => s_axi_araddr(4),
      O => p_1_in(9)
    );
\s_axi_rdata_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => \s_axi_rdata[0]_i_1_n_0\,
      Q => s_axi_rdata(0),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(10),
      Q => s_axi_rdata(10),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(11),
      Q => s_axi_rdata(11),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(12),
      Q => s_axi_rdata(12),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(13),
      Q => s_axi_rdata(13),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(14),
      Q => s_axi_rdata(14),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(15),
      Q => s_axi_rdata(15),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(16),
      Q => s_axi_rdata(16),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(17),
      Q => s_axi_rdata(17),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(18),
      Q => s_axi_rdata(18),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(19),
      Q => s_axi_rdata(19),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => \s_axi_rdata[1]_i_1_n_0\,
      Q => s_axi_rdata(1),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(20),
      Q => s_axi_rdata(20),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(21),
      Q => s_axi_rdata(21),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(22),
      Q => s_axi_rdata(22),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(23),
      Q => s_axi_rdata(23),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(24),
      Q => s_axi_rdata(24),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(25),
      Q => s_axi_rdata(25),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(26),
      Q => s_axi_rdata(26),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(27),
      Q => s_axi_rdata(27),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(28),
      Q => s_axi_rdata(28),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(29),
      Q => s_axi_rdata(29),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(2),
      Q => s_axi_rdata(2),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(30),
      Q => s_axi_rdata(30),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(31),
      Q => s_axi_rdata(31),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(3),
      Q => s_axi_rdata(3),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(4),
      Q => s_axi_rdata(4),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(5),
      Q => s_axi_rdata(5),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(6),
      Q => s_axi_rdata(6),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(7),
      Q => s_axi_rdata(7),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(8),
      Q => s_axi_rdata(8),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rdata_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => p_1_in(9),
      Q => s_axi_rdata(9),
      R => s_axi_bvalid_i_1_n_0
    );
\s_axi_rresp[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFE0"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(2),
      I2 => s_axi_araddr(4),
      I3 => \s_axi_rdata[29]_i_2_n_0\,
      O => \s_axi_rresp[1]_i_1_n_0\
    );
\s_axi_rresp_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => s_axi_rvalid02_out,
      D => \s_axi_rresp[1]_i_1_n_0\,
      Q => s_axi_rresp(0),
      R => s_axi_bvalid_i_1_n_0
    );
s_axi_rvalid_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"2E"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => \^s_axi_rvalid_reg_0\,
      I2 => s_axi_rready,
      O => s_axi_rvalid_i_1_n_0
    );
s_axi_rvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => s_axi_rvalid_i_1_n_0,
      Q => \^s_axi_rvalid_reg_0\,
      R => s_axi_bvalid_i_1_n_0
    );
s_axi_wready_INST_0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"04"
    )
        port map (
      I0 => \^s_axi_bvalid_reg_0\,
      I1 => s_axi_aresetn,
      I2 => w_held_reg_n_0,
      O => s_axi_wready
    );
w_held_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"C008C0C8"
    )
        port map (
      I0 => s_axi_wvalid,
      I1 => s_axi_aresetn,
      I2 => w_held_reg_n_0,
      I3 => \^s_axi_bvalid_reg_0\,
      I4 => aw_held,
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
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_capture_status_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
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
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    monitor_ready : in STD_LOGIC;
    capture_armed : in STD_LOGIC;
    epoch_sealed : in STD_LOGIC;
    capture_epoch : in STD_LOGIC_VECTOR ( 31 downto 0 );
    fault_causes : in STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of c6v_capture_status_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_capture_status_0 : entity is "c6v_capture_status_0,axi_vision_capture_status,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_capture_status_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_capture_status_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of c6v_capture_status_0 : entity is "axi_vision_capture_status,Vivado 2026.1";
end c6v_capture_status_0;

architecture STRUCTURE of c6v_capture_status_0 is
  signal \<const0>\ : STD_LOGIC;
  signal \<const1>\ : STD_LOGIC;
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
  attribute X_INTERFACE_INFO of s_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 s_axi AWADDR";
  attribute X_INTERFACE_MODE of s_axi_awaddr : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s_axi_awaddr : signal is "XIL_INTERFACENAME s_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 12, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 s_axi BRESP";
  attribute X_INTERFACE_INFO of s_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 s_axi RDATA";
  attribute X_INTERFACE_INFO of s_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 s_axi RRESP";
  attribute X_INTERFACE_INFO of s_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 s_axi WDATA";
  attribute X_INTERFACE_INFO of s_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 s_axi WSTRB";
begin
  s_axi_bresp(1) <= \<const1>\;
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
inst: entity work.c6v_capture_status_0_axi_vision_capture_status
     port map (
      capture_armed => capture_armed,
      capture_epoch(31 downto 0) => capture_epoch(31 downto 0),
      epoch_sealed => epoch_sealed,
      fault_causes(2 downto 0) => fault_causes(2 downto 0),
      monitor_ready => monitor_ready,
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(11 downto 0) => s_axi_araddr(11 downto 0),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arready => s_axi_arready,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awready => s_axi_awready,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bready => s_axi_bready,
      s_axi_bvalid_reg_0 => s_axi_bvalid,
      s_axi_rdata(31 downto 0) => s_axi_rdata(31 downto 0),
      s_axi_rready => s_axi_rready,
      s_axi_rresp(0) => \^s_axi_rresp\(1),
      s_axi_rvalid_reg_0 => s_axi_rvalid,
      s_axi_wready => s_axi_wready,
      s_axi_wvalid => s_axi_wvalid
    );
end STRUCTURE;
