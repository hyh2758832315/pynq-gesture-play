-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 23 06:46:42 2026
-- Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               e:/vvl/c0e/c6_latency.gen/sources_1/bd/c6v/ip/c6v_return_source_0/c6v_return_source_0_sim_netlist.vhdl
-- Design      : c6v_return_source_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_return_source_0_scene2d_return_source is
  port (
    busy_reg_0 : out STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 10 downto 0 );
    completed_byte_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    completed_packet_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    rejected_start_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_tkeep : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tlast : out STD_LOGIC;
    start : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    requested_byte_count : in STD_LOGIC_VECTOR ( 31 downto 0 );
    aclk : in STD_LOGIC;
    seed : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_tready : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_return_source_0_scene2d_return_source : entity is "scene2d_return_source";
end c6v_return_source_0_scene2d_return_source;

architecture STRUCTURE of c6v_return_source_0_scene2d_return_source is
  signal active_byte_count : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal active_byte_count_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal active_seed : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal busy_i_10_n_0 : STD_LOGIC;
  signal busy_i_1_n_0 : STD_LOGIC;
  signal busy_i_2_n_0 : STD_LOGIC;
  signal busy_i_3_n_0 : STD_LOGIC;
  signal busy_i_4_n_0 : STD_LOGIC;
  signal busy_i_5_n_0 : STD_LOGIC;
  signal busy_i_6_n_0 : STD_LOGIC;
  signal busy_i_7_n_0 : STD_LOGIC;
  signal busy_i_8_n_0 : STD_LOGIC;
  signal busy_i_9_n_0 : STD_LOGIC;
  signal \^busy_reg_0\ : STD_LOGIC;
  signal byte_offset : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \byte_offset3_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__0_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__0_n_1\ : STD_LOGIC;
  signal \byte_offset3_carry__0_n_2\ : STD_LOGIC;
  signal \byte_offset3_carry__0_n_3\ : STD_LOGIC;
  signal \byte_offset3_carry__0_n_4\ : STD_LOGIC;
  signal \byte_offset3_carry__0_n_5\ : STD_LOGIC;
  signal \byte_offset3_carry__0_n_6\ : STD_LOGIC;
  signal \byte_offset3_carry__0_n_7\ : STD_LOGIC;
  signal \byte_offset3_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__1_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__1_n_1\ : STD_LOGIC;
  signal \byte_offset3_carry__1_n_2\ : STD_LOGIC;
  signal \byte_offset3_carry__1_n_3\ : STD_LOGIC;
  signal \byte_offset3_carry__1_n_4\ : STD_LOGIC;
  signal \byte_offset3_carry__1_n_5\ : STD_LOGIC;
  signal \byte_offset3_carry__1_n_6\ : STD_LOGIC;
  signal \byte_offset3_carry__1_n_7\ : STD_LOGIC;
  signal \byte_offset3_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__2_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__2_n_1\ : STD_LOGIC;
  signal \byte_offset3_carry__2_n_2\ : STD_LOGIC;
  signal \byte_offset3_carry__2_n_3\ : STD_LOGIC;
  signal \byte_offset3_carry__2_n_4\ : STD_LOGIC;
  signal \byte_offset3_carry__2_n_5\ : STD_LOGIC;
  signal \byte_offset3_carry__2_n_6\ : STD_LOGIC;
  signal \byte_offset3_carry__2_n_7\ : STD_LOGIC;
  signal \byte_offset3_carry__3_i_1_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__3_i_2_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__3_i_3_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__3_i_4_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__3_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__3_n_1\ : STD_LOGIC;
  signal \byte_offset3_carry__3_n_2\ : STD_LOGIC;
  signal \byte_offset3_carry__3_n_3\ : STD_LOGIC;
  signal \byte_offset3_carry__3_n_4\ : STD_LOGIC;
  signal \byte_offset3_carry__3_n_5\ : STD_LOGIC;
  signal \byte_offset3_carry__3_n_6\ : STD_LOGIC;
  signal \byte_offset3_carry__3_n_7\ : STD_LOGIC;
  signal \byte_offset3_carry__4_i_1_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__4_i_2_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__4_i_3_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__4_i_4_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__4_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__4_n_1\ : STD_LOGIC;
  signal \byte_offset3_carry__4_n_2\ : STD_LOGIC;
  signal \byte_offset3_carry__4_n_3\ : STD_LOGIC;
  signal \byte_offset3_carry__4_n_4\ : STD_LOGIC;
  signal \byte_offset3_carry__4_n_5\ : STD_LOGIC;
  signal \byte_offset3_carry__4_n_6\ : STD_LOGIC;
  signal \byte_offset3_carry__4_n_7\ : STD_LOGIC;
  signal \byte_offset3_carry__5_i_1_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__5_i_2_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__5_i_3_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__5_i_4_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__5_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__5_n_1\ : STD_LOGIC;
  signal \byte_offset3_carry__5_n_2\ : STD_LOGIC;
  signal \byte_offset3_carry__5_n_3\ : STD_LOGIC;
  signal \byte_offset3_carry__5_n_4\ : STD_LOGIC;
  signal \byte_offset3_carry__5_n_5\ : STD_LOGIC;
  signal \byte_offset3_carry__5_n_6\ : STD_LOGIC;
  signal \byte_offset3_carry__5_n_7\ : STD_LOGIC;
  signal \byte_offset3_carry__6_i_1_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__6_i_2_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__6_i_3_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__6_i_4_n_0\ : STD_LOGIC;
  signal \byte_offset3_carry__6_n_1\ : STD_LOGIC;
  signal \byte_offset3_carry__6_n_2\ : STD_LOGIC;
  signal \byte_offset3_carry__6_n_3\ : STD_LOGIC;
  signal \byte_offset3_carry__6_n_4\ : STD_LOGIC;
  signal \byte_offset3_carry__6_n_5\ : STD_LOGIC;
  signal \byte_offset3_carry__6_n_6\ : STD_LOGIC;
  signal \byte_offset3_carry__6_n_7\ : STD_LOGIC;
  signal byte_offset3_carry_i_1_n_0 : STD_LOGIC;
  signal byte_offset3_carry_i_2_n_0 : STD_LOGIC;
  signal byte_offset3_carry_i_3_n_0 : STD_LOGIC;
  signal byte_offset3_carry_i_4_n_0 : STD_LOGIC;
  signal byte_offset3_carry_n_0 : STD_LOGIC;
  signal byte_offset3_carry_n_1 : STD_LOGIC;
  signal byte_offset3_carry_n_2 : STD_LOGIC;
  signal byte_offset3_carry_n_3 : STD_LOGIC;
  signal byte_offset3_carry_n_4 : STD_LOGIC;
  signal byte_offset3_carry_n_5 : STD_LOGIC;
  signal byte_offset3_carry_n_6 : STD_LOGIC;
  signal byte_offset3_carry_n_7 : STD_LOGIC;
  signal \byte_offset[3]_i_1_n_0\ : STD_LOGIC;
  signal \byte_offset[3]_i_4_n_0\ : STD_LOGIC;
  signal byte_offset_reg : STD_LOGIC_VECTOR ( 31 downto 3 );
  signal \byte_offset_reg[11]_i_1_n_0\ : STD_LOGIC;
  signal \byte_offset_reg[11]_i_1_n_1\ : STD_LOGIC;
  signal \byte_offset_reg[11]_i_1_n_2\ : STD_LOGIC;
  signal \byte_offset_reg[11]_i_1_n_3\ : STD_LOGIC;
  signal \byte_offset_reg[11]_i_1_n_4\ : STD_LOGIC;
  signal \byte_offset_reg[11]_i_1_n_5\ : STD_LOGIC;
  signal \byte_offset_reg[11]_i_1_n_6\ : STD_LOGIC;
  signal \byte_offset_reg[11]_i_1_n_7\ : STD_LOGIC;
  signal \byte_offset_reg[15]_i_1_n_0\ : STD_LOGIC;
  signal \byte_offset_reg[15]_i_1_n_1\ : STD_LOGIC;
  signal \byte_offset_reg[15]_i_1_n_2\ : STD_LOGIC;
  signal \byte_offset_reg[15]_i_1_n_3\ : STD_LOGIC;
  signal \byte_offset_reg[15]_i_1_n_4\ : STD_LOGIC;
  signal \byte_offset_reg[15]_i_1_n_5\ : STD_LOGIC;
  signal \byte_offset_reg[15]_i_1_n_6\ : STD_LOGIC;
  signal \byte_offset_reg[15]_i_1_n_7\ : STD_LOGIC;
  signal \byte_offset_reg[19]_i_1_n_0\ : STD_LOGIC;
  signal \byte_offset_reg[19]_i_1_n_1\ : STD_LOGIC;
  signal \byte_offset_reg[19]_i_1_n_2\ : STD_LOGIC;
  signal \byte_offset_reg[19]_i_1_n_3\ : STD_LOGIC;
  signal \byte_offset_reg[19]_i_1_n_4\ : STD_LOGIC;
  signal \byte_offset_reg[19]_i_1_n_5\ : STD_LOGIC;
  signal \byte_offset_reg[19]_i_1_n_6\ : STD_LOGIC;
  signal \byte_offset_reg[19]_i_1_n_7\ : STD_LOGIC;
  signal \byte_offset_reg[23]_i_1_n_0\ : STD_LOGIC;
  signal \byte_offset_reg[23]_i_1_n_1\ : STD_LOGIC;
  signal \byte_offset_reg[23]_i_1_n_2\ : STD_LOGIC;
  signal \byte_offset_reg[23]_i_1_n_3\ : STD_LOGIC;
  signal \byte_offset_reg[23]_i_1_n_4\ : STD_LOGIC;
  signal \byte_offset_reg[23]_i_1_n_5\ : STD_LOGIC;
  signal \byte_offset_reg[23]_i_1_n_6\ : STD_LOGIC;
  signal \byte_offset_reg[23]_i_1_n_7\ : STD_LOGIC;
  signal \byte_offset_reg[27]_i_1_n_0\ : STD_LOGIC;
  signal \byte_offset_reg[27]_i_1_n_1\ : STD_LOGIC;
  signal \byte_offset_reg[27]_i_1_n_2\ : STD_LOGIC;
  signal \byte_offset_reg[27]_i_1_n_3\ : STD_LOGIC;
  signal \byte_offset_reg[27]_i_1_n_4\ : STD_LOGIC;
  signal \byte_offset_reg[27]_i_1_n_5\ : STD_LOGIC;
  signal \byte_offset_reg[27]_i_1_n_6\ : STD_LOGIC;
  signal \byte_offset_reg[27]_i_1_n_7\ : STD_LOGIC;
  signal \byte_offset_reg[31]_i_1_n_7\ : STD_LOGIC;
  signal \byte_offset_reg[3]_i_3_n_0\ : STD_LOGIC;
  signal \byte_offset_reg[3]_i_3_n_1\ : STD_LOGIC;
  signal \byte_offset_reg[3]_i_3_n_2\ : STD_LOGIC;
  signal \byte_offset_reg[3]_i_3_n_3\ : STD_LOGIC;
  signal \byte_offset_reg[3]_i_3_n_4\ : STD_LOGIC;
  signal \byte_offset_reg[3]_i_3_n_5\ : STD_LOGIC;
  signal \byte_offset_reg[3]_i_3_n_6\ : STD_LOGIC;
  signal \byte_offset_reg[3]_i_3_n_7\ : STD_LOGIC;
  signal \byte_offset_reg[7]_i_1_n_0\ : STD_LOGIC;
  signal \byte_offset_reg[7]_i_1_n_1\ : STD_LOGIC;
  signal \byte_offset_reg[7]_i_1_n_2\ : STD_LOGIC;
  signal \byte_offset_reg[7]_i_1_n_3\ : STD_LOGIC;
  signal \byte_offset_reg[7]_i_1_n_4\ : STD_LOGIC;
  signal \byte_offset_reg[7]_i_1_n_5\ : STD_LOGIC;
  signal \byte_offset_reg[7]_i_1_n_6\ : STD_LOGIC;
  signal \byte_offset_reg[7]_i_1_n_7\ : STD_LOGIC;
  signal clear : STD_LOGIC;
  signal \completed_byte_count[31]_i_2_n_0\ : STD_LOGIC;
  signal \completed_byte_count[31]_i_3_n_0\ : STD_LOGIC;
  signal \completed_byte_count[31]_i_4_n_0\ : STD_LOGIC;
  signal \^completed_packet_count\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \completed_packet_count[3]_i_2_n_0\ : STD_LOGIC;
  signal \completed_packet_count_reg[11]_i_1_n_0\ : STD_LOGIC;
  signal \completed_packet_count_reg[11]_i_1_n_1\ : STD_LOGIC;
  signal \completed_packet_count_reg[11]_i_1_n_2\ : STD_LOGIC;
  signal \completed_packet_count_reg[11]_i_1_n_3\ : STD_LOGIC;
  signal \completed_packet_count_reg[11]_i_1_n_4\ : STD_LOGIC;
  signal \completed_packet_count_reg[11]_i_1_n_5\ : STD_LOGIC;
  signal \completed_packet_count_reg[11]_i_1_n_6\ : STD_LOGIC;
  signal \completed_packet_count_reg[11]_i_1_n_7\ : STD_LOGIC;
  signal \completed_packet_count_reg[15]_i_1_n_0\ : STD_LOGIC;
  signal \completed_packet_count_reg[15]_i_1_n_1\ : STD_LOGIC;
  signal \completed_packet_count_reg[15]_i_1_n_2\ : STD_LOGIC;
  signal \completed_packet_count_reg[15]_i_1_n_3\ : STD_LOGIC;
  signal \completed_packet_count_reg[15]_i_1_n_4\ : STD_LOGIC;
  signal \completed_packet_count_reg[15]_i_1_n_5\ : STD_LOGIC;
  signal \completed_packet_count_reg[15]_i_1_n_6\ : STD_LOGIC;
  signal \completed_packet_count_reg[15]_i_1_n_7\ : STD_LOGIC;
  signal \completed_packet_count_reg[19]_i_1_n_0\ : STD_LOGIC;
  signal \completed_packet_count_reg[19]_i_1_n_1\ : STD_LOGIC;
  signal \completed_packet_count_reg[19]_i_1_n_2\ : STD_LOGIC;
  signal \completed_packet_count_reg[19]_i_1_n_3\ : STD_LOGIC;
  signal \completed_packet_count_reg[19]_i_1_n_4\ : STD_LOGIC;
  signal \completed_packet_count_reg[19]_i_1_n_5\ : STD_LOGIC;
  signal \completed_packet_count_reg[19]_i_1_n_6\ : STD_LOGIC;
  signal \completed_packet_count_reg[19]_i_1_n_7\ : STD_LOGIC;
  signal \completed_packet_count_reg[23]_i_1_n_0\ : STD_LOGIC;
  signal \completed_packet_count_reg[23]_i_1_n_1\ : STD_LOGIC;
  signal \completed_packet_count_reg[23]_i_1_n_2\ : STD_LOGIC;
  signal \completed_packet_count_reg[23]_i_1_n_3\ : STD_LOGIC;
  signal \completed_packet_count_reg[23]_i_1_n_4\ : STD_LOGIC;
  signal \completed_packet_count_reg[23]_i_1_n_5\ : STD_LOGIC;
  signal \completed_packet_count_reg[23]_i_1_n_6\ : STD_LOGIC;
  signal \completed_packet_count_reg[23]_i_1_n_7\ : STD_LOGIC;
  signal \completed_packet_count_reg[27]_i_1_n_0\ : STD_LOGIC;
  signal \completed_packet_count_reg[27]_i_1_n_1\ : STD_LOGIC;
  signal \completed_packet_count_reg[27]_i_1_n_2\ : STD_LOGIC;
  signal \completed_packet_count_reg[27]_i_1_n_3\ : STD_LOGIC;
  signal \completed_packet_count_reg[27]_i_1_n_4\ : STD_LOGIC;
  signal \completed_packet_count_reg[27]_i_1_n_5\ : STD_LOGIC;
  signal \completed_packet_count_reg[27]_i_1_n_6\ : STD_LOGIC;
  signal \completed_packet_count_reg[27]_i_1_n_7\ : STD_LOGIC;
  signal \completed_packet_count_reg[31]_i_1_n_1\ : STD_LOGIC;
  signal \completed_packet_count_reg[31]_i_1_n_2\ : STD_LOGIC;
  signal \completed_packet_count_reg[31]_i_1_n_3\ : STD_LOGIC;
  signal \completed_packet_count_reg[31]_i_1_n_4\ : STD_LOGIC;
  signal \completed_packet_count_reg[31]_i_1_n_5\ : STD_LOGIC;
  signal \completed_packet_count_reg[31]_i_1_n_6\ : STD_LOGIC;
  signal \completed_packet_count_reg[31]_i_1_n_7\ : STD_LOGIC;
  signal \completed_packet_count_reg[3]_i_1_n_0\ : STD_LOGIC;
  signal \completed_packet_count_reg[3]_i_1_n_1\ : STD_LOGIC;
  signal \completed_packet_count_reg[3]_i_1_n_2\ : STD_LOGIC;
  signal \completed_packet_count_reg[3]_i_1_n_3\ : STD_LOGIC;
  signal \completed_packet_count_reg[3]_i_1_n_4\ : STD_LOGIC;
  signal \completed_packet_count_reg[3]_i_1_n_5\ : STD_LOGIC;
  signal \completed_packet_count_reg[3]_i_1_n_6\ : STD_LOGIC;
  signal \completed_packet_count_reg[3]_i_1_n_7\ : STD_LOGIC;
  signal \completed_packet_count_reg[7]_i_1_n_0\ : STD_LOGIC;
  signal \completed_packet_count_reg[7]_i_1_n_1\ : STD_LOGIC;
  signal \completed_packet_count_reg[7]_i_1_n_2\ : STD_LOGIC;
  signal \completed_packet_count_reg[7]_i_1_n_3\ : STD_LOGIC;
  signal \completed_packet_count_reg[7]_i_1_n_4\ : STD_LOGIC;
  signal \completed_packet_count_reg[7]_i_1_n_5\ : STD_LOGIC;
  signal \completed_packet_count_reg[7]_i_1_n_6\ : STD_LOGIC;
  signal \completed_packet_count_reg[7]_i_1_n_7\ : STD_LOGIC;
  signal \m_axis_tdata[17]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_tdata[34]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_tdata[3]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_tdata[4]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_tdata[5]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_tdata[6]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_tdata[7]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_tdata[8]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_tkeep[7]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_tkeep[7]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \m_axis_tkeep[7]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \m_axis_tkeep[7]_INST_0_i_4_n_0\ : STD_LOGIC;
  signal \m_axis_tkeep[7]_INST_0_i_5_n_0\ : STD_LOGIC;
  signal \m_axis_tkeep[7]_INST_0_i_6_n_0\ : STD_LOGIC;
  signal \m_axis_tkeep[7]_INST_0_i_7_n_0\ : STD_LOGIC;
  signal \m_axis_tkeep[7]_INST_0_i_8_n_0\ : STD_LOGIC;
  signal \^rejected_start_count\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \rejected_start_count[31]_i_1_n_0\ : STD_LOGIC;
  signal \rejected_start_count[3]_i_2_n_0\ : STD_LOGIC;
  signal \rejected_start_count_reg[11]_i_1_n_0\ : STD_LOGIC;
  signal \rejected_start_count_reg[11]_i_1_n_1\ : STD_LOGIC;
  signal \rejected_start_count_reg[11]_i_1_n_2\ : STD_LOGIC;
  signal \rejected_start_count_reg[11]_i_1_n_3\ : STD_LOGIC;
  signal \rejected_start_count_reg[11]_i_1_n_4\ : STD_LOGIC;
  signal \rejected_start_count_reg[11]_i_1_n_5\ : STD_LOGIC;
  signal \rejected_start_count_reg[11]_i_1_n_6\ : STD_LOGIC;
  signal \rejected_start_count_reg[11]_i_1_n_7\ : STD_LOGIC;
  signal \rejected_start_count_reg[15]_i_1_n_0\ : STD_LOGIC;
  signal \rejected_start_count_reg[15]_i_1_n_1\ : STD_LOGIC;
  signal \rejected_start_count_reg[15]_i_1_n_2\ : STD_LOGIC;
  signal \rejected_start_count_reg[15]_i_1_n_3\ : STD_LOGIC;
  signal \rejected_start_count_reg[15]_i_1_n_4\ : STD_LOGIC;
  signal \rejected_start_count_reg[15]_i_1_n_5\ : STD_LOGIC;
  signal \rejected_start_count_reg[15]_i_1_n_6\ : STD_LOGIC;
  signal \rejected_start_count_reg[15]_i_1_n_7\ : STD_LOGIC;
  signal \rejected_start_count_reg[19]_i_1_n_0\ : STD_LOGIC;
  signal \rejected_start_count_reg[19]_i_1_n_1\ : STD_LOGIC;
  signal \rejected_start_count_reg[19]_i_1_n_2\ : STD_LOGIC;
  signal \rejected_start_count_reg[19]_i_1_n_3\ : STD_LOGIC;
  signal \rejected_start_count_reg[19]_i_1_n_4\ : STD_LOGIC;
  signal \rejected_start_count_reg[19]_i_1_n_5\ : STD_LOGIC;
  signal \rejected_start_count_reg[19]_i_1_n_6\ : STD_LOGIC;
  signal \rejected_start_count_reg[19]_i_1_n_7\ : STD_LOGIC;
  signal \rejected_start_count_reg[23]_i_1_n_0\ : STD_LOGIC;
  signal \rejected_start_count_reg[23]_i_1_n_1\ : STD_LOGIC;
  signal \rejected_start_count_reg[23]_i_1_n_2\ : STD_LOGIC;
  signal \rejected_start_count_reg[23]_i_1_n_3\ : STD_LOGIC;
  signal \rejected_start_count_reg[23]_i_1_n_4\ : STD_LOGIC;
  signal \rejected_start_count_reg[23]_i_1_n_5\ : STD_LOGIC;
  signal \rejected_start_count_reg[23]_i_1_n_6\ : STD_LOGIC;
  signal \rejected_start_count_reg[23]_i_1_n_7\ : STD_LOGIC;
  signal \rejected_start_count_reg[27]_i_1_n_0\ : STD_LOGIC;
  signal \rejected_start_count_reg[27]_i_1_n_1\ : STD_LOGIC;
  signal \rejected_start_count_reg[27]_i_1_n_2\ : STD_LOGIC;
  signal \rejected_start_count_reg[27]_i_1_n_3\ : STD_LOGIC;
  signal \rejected_start_count_reg[27]_i_1_n_4\ : STD_LOGIC;
  signal \rejected_start_count_reg[27]_i_1_n_5\ : STD_LOGIC;
  signal \rejected_start_count_reg[27]_i_1_n_6\ : STD_LOGIC;
  signal \rejected_start_count_reg[27]_i_1_n_7\ : STD_LOGIC;
  signal \rejected_start_count_reg[31]_i_2_n_1\ : STD_LOGIC;
  signal \rejected_start_count_reg[31]_i_2_n_2\ : STD_LOGIC;
  signal \rejected_start_count_reg[31]_i_2_n_3\ : STD_LOGIC;
  signal \rejected_start_count_reg[31]_i_2_n_4\ : STD_LOGIC;
  signal \rejected_start_count_reg[31]_i_2_n_5\ : STD_LOGIC;
  signal \rejected_start_count_reg[31]_i_2_n_6\ : STD_LOGIC;
  signal \rejected_start_count_reg[31]_i_2_n_7\ : STD_LOGIC;
  signal \rejected_start_count_reg[3]_i_1_n_0\ : STD_LOGIC;
  signal \rejected_start_count_reg[3]_i_1_n_1\ : STD_LOGIC;
  signal \rejected_start_count_reg[3]_i_1_n_2\ : STD_LOGIC;
  signal \rejected_start_count_reg[3]_i_1_n_3\ : STD_LOGIC;
  signal \rejected_start_count_reg[3]_i_1_n_4\ : STD_LOGIC;
  signal \rejected_start_count_reg[3]_i_1_n_5\ : STD_LOGIC;
  signal \rejected_start_count_reg[3]_i_1_n_6\ : STD_LOGIC;
  signal \rejected_start_count_reg[3]_i_1_n_7\ : STD_LOGIC;
  signal \rejected_start_count_reg[7]_i_1_n_0\ : STD_LOGIC;
  signal \rejected_start_count_reg[7]_i_1_n_1\ : STD_LOGIC;
  signal \rejected_start_count_reg[7]_i_1_n_2\ : STD_LOGIC;
  signal \rejected_start_count_reg[7]_i_1_n_3\ : STD_LOGIC;
  signal \rejected_start_count_reg[7]_i_1_n_4\ : STD_LOGIC;
  signal \rejected_start_count_reg[7]_i_1_n_5\ : STD_LOGIC;
  signal \rejected_start_count_reg[7]_i_1_n_6\ : STD_LOGIC;
  signal \rejected_start_count_reg[7]_i_1_n_7\ : STD_LOGIC;
  signal start_delayed : STD_LOGIC;
  signal start_delayed_i_1_n_0 : STD_LOGIC;
  signal \NLW_byte_offset3_carry__6_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_byte_offset_reg[31]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_byte_offset_reg[31]_i_1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_completed_packet_count_reg[31]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_rejected_start_count_reg[31]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of busy_reg : label is "xilinx.com:interface:axis:1.0 M_AXIS TVALID";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of byte_offset3_carry : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset3_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset3_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset3_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset3_carry__3\ : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset3_carry__4\ : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset3_carry__5\ : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset3_carry__6\ : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset_reg[11]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset_reg[15]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset_reg[19]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset_reg[23]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset_reg[27]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset_reg[31]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset_reg[3]_i_3\ : label is 35;
  attribute ADDER_THRESHOLD of \byte_offset_reg[7]_i_1\ : label is 35;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \completed_byte_count[31]_i_3\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \completed_byte_count[31]_i_4\ : label is "soft_lutpair7";
  attribute ADDER_THRESHOLD of \completed_packet_count_reg[11]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \completed_packet_count_reg[15]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \completed_packet_count_reg[19]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \completed_packet_count_reg[23]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \completed_packet_count_reg[27]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \completed_packet_count_reg[31]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \completed_packet_count_reg[3]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \completed_packet_count_reg[7]_i_1\ : label is 35;
  attribute SOFT_HLUTNM of \m_axis_tdata[0]_INST_0\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \m_axis_tdata[17]_INST_0\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \m_axis_tdata[1]_INST_0\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \m_axis_tdata[2]_INST_0\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \m_axis_tdata[34]_INST_0\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \m_axis_tdata[8]_INST_0\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \m_axis_tkeep[0]_INST_0\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \m_axis_tkeep[1]_INST_0\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \m_axis_tkeep[2]_INST_0\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \m_axis_tkeep[3]_INST_0\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \m_axis_tkeep[4]_INST_0\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \m_axis_tkeep[5]_INST_0\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \m_axis_tkeep[6]_INST_0\ : label is "soft_lutpair1";
  attribute ADDER_THRESHOLD of \rejected_start_count_reg[11]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \rejected_start_count_reg[15]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \rejected_start_count_reg[19]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \rejected_start_count_reg[23]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \rejected_start_count_reg[27]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \rejected_start_count_reg[31]_i_2\ : label is 35;
  attribute ADDER_THRESHOLD of \rejected_start_count_reg[3]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \rejected_start_count_reg[7]_i_1\ : label is 35;
  attribute SOFT_HLUTNM of start_delayed_i_1 : label is "soft_lutpair5";
begin
  busy_reg_0 <= \^busy_reg_0\;
  completed_packet_count(31 downto 0) <= \^completed_packet_count\(31 downto 0);
  rejected_start_count(31 downto 0) <= \^rejected_start_count\(31 downto 0);
\active_byte_count[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0200"
    )
        port map (
      I0 => busy_i_2_n_0,
      I1 => \^busy_reg_0\,
      I2 => start_delayed,
      I3 => start,
      O => active_byte_count_0(0)
    );
\active_byte_count_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(0),
      Q => active_byte_count(0),
      R => clear
    );
\active_byte_count_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(10),
      Q => active_byte_count(10),
      R => clear
    );
\active_byte_count_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(11),
      Q => active_byte_count(11),
      R => clear
    );
\active_byte_count_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(12),
      Q => active_byte_count(12),
      R => clear
    );
\active_byte_count_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(13),
      Q => active_byte_count(13),
      R => clear
    );
\active_byte_count_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(14),
      Q => active_byte_count(14),
      R => clear
    );
\active_byte_count_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(15),
      Q => active_byte_count(15),
      R => clear
    );
\active_byte_count_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(16),
      Q => active_byte_count(16),
      R => clear
    );
\active_byte_count_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(17),
      Q => active_byte_count(17),
      R => clear
    );
\active_byte_count_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(18),
      Q => active_byte_count(18),
      R => clear
    );
\active_byte_count_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(19),
      Q => active_byte_count(19),
      R => clear
    );
\active_byte_count_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(1),
      Q => active_byte_count(1),
      R => clear
    );
\active_byte_count_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(20),
      Q => active_byte_count(20),
      R => clear
    );
\active_byte_count_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(21),
      Q => active_byte_count(21),
      R => clear
    );
\active_byte_count_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(22),
      Q => active_byte_count(22),
      R => clear
    );
\active_byte_count_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(23),
      Q => active_byte_count(23),
      R => clear
    );
\active_byte_count_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(24),
      Q => active_byte_count(24),
      R => clear
    );
\active_byte_count_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(25),
      Q => active_byte_count(25),
      R => clear
    );
\active_byte_count_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(26),
      Q => active_byte_count(26),
      R => clear
    );
\active_byte_count_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(27),
      Q => active_byte_count(27),
      R => clear
    );
\active_byte_count_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(28),
      Q => active_byte_count(28),
      R => clear
    );
\active_byte_count_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(29),
      Q => active_byte_count(29),
      R => clear
    );
\active_byte_count_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(2),
      Q => active_byte_count(2),
      R => clear
    );
\active_byte_count_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(30),
      Q => active_byte_count(30),
      R => clear
    );
\active_byte_count_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(31),
      Q => active_byte_count(31),
      R => clear
    );
\active_byte_count_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(3),
      Q => active_byte_count(3),
      R => clear
    );
\active_byte_count_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(4),
      Q => active_byte_count(4),
      R => clear
    );
\active_byte_count_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(5),
      Q => active_byte_count(5),
      R => clear
    );
\active_byte_count_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(6),
      Q => active_byte_count(6),
      R => clear
    );
\active_byte_count_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(7),
      Q => active_byte_count(7),
      R => clear
    );
\active_byte_count_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(8),
      Q => active_byte_count(8),
      R => clear
    );
\active_byte_count_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => requested_byte_count(9),
      Q => active_byte_count(9),
      R => clear
    );
\active_seed_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(0),
      Q => active_seed(0),
      R => clear
    );
\active_seed_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(10),
      Q => active_seed(10),
      R => clear
    );
\active_seed_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(11),
      Q => active_seed(11),
      R => clear
    );
\active_seed_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(12),
      Q => active_seed(12),
      R => clear
    );
\active_seed_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(13),
      Q => active_seed(13),
      R => clear
    );
\active_seed_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(14),
      Q => active_seed(14),
      R => clear
    );
\active_seed_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(15),
      Q => active_seed(15),
      R => clear
    );
\active_seed_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(16),
      Q => active_seed(16),
      R => clear
    );
\active_seed_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(17),
      Q => active_seed(17),
      R => clear
    );
\active_seed_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(18),
      Q => active_seed(18),
      R => clear
    );
\active_seed_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(19),
      Q => active_seed(19),
      R => clear
    );
\active_seed_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(1),
      Q => active_seed(1),
      R => clear
    );
\active_seed_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(20),
      Q => active_seed(20),
      R => clear
    );
\active_seed_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(21),
      Q => active_seed(21),
      R => clear
    );
\active_seed_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(22),
      Q => active_seed(22),
      R => clear
    );
\active_seed_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(23),
      Q => active_seed(23),
      R => clear
    );
\active_seed_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(24),
      Q => active_seed(24),
      R => clear
    );
\active_seed_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(25),
      Q => active_seed(25),
      R => clear
    );
\active_seed_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(26),
      Q => active_seed(26),
      R => clear
    );
\active_seed_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(27),
      Q => active_seed(27),
      R => clear
    );
\active_seed_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(28),
      Q => active_seed(28),
      R => clear
    );
\active_seed_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(29),
      Q => active_seed(29),
      R => clear
    );
\active_seed_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(2),
      Q => active_seed(2),
      R => clear
    );
\active_seed_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(30),
      Q => active_seed(30),
      R => clear
    );
\active_seed_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(31),
      Q => active_seed(31),
      R => clear
    );
\active_seed_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(3),
      Q => active_seed(3),
      R => clear
    );
\active_seed_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(4),
      Q => active_seed(4),
      R => clear
    );
\active_seed_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(5),
      Q => active_seed(5),
      R => clear
    );
\active_seed_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(6),
      Q => active_seed(6),
      R => clear
    );
\active_seed_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(7),
      Q => active_seed(7),
      R => clear
    );
\active_seed_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(8),
      Q => active_seed(8),
      R => clear
    );
\active_seed_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => active_byte_count_0(0),
      D => seed(9),
      Q => active_seed(9),
      R => clear
    );
busy_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F00CECC00000000"
    )
        port map (
      I0 => busy_i_2_n_0,
      I1 => \^busy_reg_0\,
      I2 => start_delayed,
      I3 => start,
      I4 => \completed_byte_count[31]_i_2_n_0\,
      I5 => aresetn,
      O => busy_i_1_n_0
    );
busy_i_10: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => requested_byte_count(21),
      I1 => requested_byte_count(20),
      I2 => requested_byte_count(23),
      I3 => requested_byte_count(22),
      O => busy_i_10_n_0
    );
busy_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => busy_i_3_n_0,
      I1 => busy_i_4_n_0,
      I2 => busy_i_5_n_0,
      I3 => busy_i_6_n_0,
      O => busy_i_2_n_0
    );
busy_i_3: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => requested_byte_count(10),
      I1 => requested_byte_count(11),
      I2 => requested_byte_count(8),
      I3 => requested_byte_count(9),
      I4 => busy_i_7_n_0,
      O => busy_i_3_n_0
    );
busy_i_4: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => requested_byte_count(2),
      I1 => requested_byte_count(3),
      I2 => requested_byte_count(0),
      I3 => requested_byte_count(1),
      I4 => busy_i_8_n_0,
      O => busy_i_4_n_0
    );
busy_i_5: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => requested_byte_count(26),
      I1 => requested_byte_count(27),
      I2 => requested_byte_count(24),
      I3 => requested_byte_count(25),
      I4 => busy_i_9_n_0,
      O => busy_i_5_n_0
    );
busy_i_6: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => requested_byte_count(18),
      I1 => requested_byte_count(19),
      I2 => requested_byte_count(16),
      I3 => requested_byte_count(17),
      I4 => busy_i_10_n_0,
      O => busy_i_6_n_0
    );
busy_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => requested_byte_count(13),
      I1 => requested_byte_count(12),
      I2 => requested_byte_count(15),
      I3 => requested_byte_count(14),
      O => busy_i_7_n_0
    );
busy_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => requested_byte_count(5),
      I1 => requested_byte_count(4),
      I2 => requested_byte_count(7),
      I3 => requested_byte_count(6),
      O => busy_i_8_n_0
    );
busy_i_9: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => requested_byte_count(29),
      I1 => requested_byte_count(28),
      I2 => requested_byte_count(31),
      I3 => requested_byte_count(30),
      O => busy_i_9_n_0
    );
busy_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => busy_i_1_n_0,
      Q => \^busy_reg_0\,
      R => '0'
    );
byte_offset3_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => byte_offset3_carry_n_0,
      CO(2) => byte_offset3_carry_n_1,
      CO(1) => byte_offset3_carry_n_2,
      CO(0) => byte_offset3_carry_n_3,
      CYINIT => '1',
      DI(3 downto 0) => active_byte_count(3 downto 0),
      O(3) => byte_offset3_carry_n_4,
      O(2) => byte_offset3_carry_n_5,
      O(1) => byte_offset3_carry_n_6,
      O(0) => byte_offset3_carry_n_7,
      S(3) => byte_offset3_carry_i_1_n_0,
      S(2) => byte_offset3_carry_i_2_n_0,
      S(1) => byte_offset3_carry_i_3_n_0,
      S(0) => byte_offset3_carry_i_4_n_0
    );
\byte_offset3_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => byte_offset3_carry_n_0,
      CO(3) => \byte_offset3_carry__0_n_0\,
      CO(2) => \byte_offset3_carry__0_n_1\,
      CO(1) => \byte_offset3_carry__0_n_2\,
      CO(0) => \byte_offset3_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => active_byte_count(7 downto 4),
      O(3) => \byte_offset3_carry__0_n_4\,
      O(2) => \byte_offset3_carry__0_n_5\,
      O(1) => \byte_offset3_carry__0_n_6\,
      O(0) => \byte_offset3_carry__0_n_7\,
      S(3) => \byte_offset3_carry__0_i_1_n_0\,
      S(2) => \byte_offset3_carry__0_i_2_n_0\,
      S(1) => \byte_offset3_carry__0_i_3_n_0\,
      S(0) => \byte_offset3_carry__0_i_4_n_0\
    );
\byte_offset3_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(7),
      I1 => byte_offset_reg(7),
      O => \byte_offset3_carry__0_i_1_n_0\
    );
\byte_offset3_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(6),
      I1 => byte_offset_reg(6),
      O => \byte_offset3_carry__0_i_2_n_0\
    );
\byte_offset3_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(5),
      I1 => byte_offset_reg(5),
      O => \byte_offset3_carry__0_i_3_n_0\
    );
\byte_offset3_carry__0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(4),
      I1 => byte_offset_reg(4),
      O => \byte_offset3_carry__0_i_4_n_0\
    );
\byte_offset3_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \byte_offset3_carry__0_n_0\,
      CO(3) => \byte_offset3_carry__1_n_0\,
      CO(2) => \byte_offset3_carry__1_n_1\,
      CO(1) => \byte_offset3_carry__1_n_2\,
      CO(0) => \byte_offset3_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => active_byte_count(11 downto 8),
      O(3) => \byte_offset3_carry__1_n_4\,
      O(2) => \byte_offset3_carry__1_n_5\,
      O(1) => \byte_offset3_carry__1_n_6\,
      O(0) => \byte_offset3_carry__1_n_7\,
      S(3) => \byte_offset3_carry__1_i_1_n_0\,
      S(2) => \byte_offset3_carry__1_i_2_n_0\,
      S(1) => \byte_offset3_carry__1_i_3_n_0\,
      S(0) => \byte_offset3_carry__1_i_4_n_0\
    );
\byte_offset3_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(11),
      I1 => byte_offset_reg(11),
      O => \byte_offset3_carry__1_i_1_n_0\
    );
\byte_offset3_carry__1_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(10),
      I1 => byte_offset_reg(10),
      O => \byte_offset3_carry__1_i_2_n_0\
    );
\byte_offset3_carry__1_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(9),
      I1 => byte_offset_reg(9),
      O => \byte_offset3_carry__1_i_3_n_0\
    );
\byte_offset3_carry__1_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(8),
      I1 => byte_offset_reg(8),
      O => \byte_offset3_carry__1_i_4_n_0\
    );
\byte_offset3_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \byte_offset3_carry__1_n_0\,
      CO(3) => \byte_offset3_carry__2_n_0\,
      CO(2) => \byte_offset3_carry__2_n_1\,
      CO(1) => \byte_offset3_carry__2_n_2\,
      CO(0) => \byte_offset3_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => active_byte_count(15 downto 12),
      O(3) => \byte_offset3_carry__2_n_4\,
      O(2) => \byte_offset3_carry__2_n_5\,
      O(1) => \byte_offset3_carry__2_n_6\,
      O(0) => \byte_offset3_carry__2_n_7\,
      S(3) => \byte_offset3_carry__2_i_1_n_0\,
      S(2) => \byte_offset3_carry__2_i_2_n_0\,
      S(1) => \byte_offset3_carry__2_i_3_n_0\,
      S(0) => \byte_offset3_carry__2_i_4_n_0\
    );
\byte_offset3_carry__2_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(15),
      I1 => byte_offset_reg(15),
      O => \byte_offset3_carry__2_i_1_n_0\
    );
\byte_offset3_carry__2_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(14),
      I1 => byte_offset_reg(14),
      O => \byte_offset3_carry__2_i_2_n_0\
    );
\byte_offset3_carry__2_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(13),
      I1 => byte_offset_reg(13),
      O => \byte_offset3_carry__2_i_3_n_0\
    );
\byte_offset3_carry__2_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(12),
      I1 => byte_offset_reg(12),
      O => \byte_offset3_carry__2_i_4_n_0\
    );
\byte_offset3_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \byte_offset3_carry__2_n_0\,
      CO(3) => \byte_offset3_carry__3_n_0\,
      CO(2) => \byte_offset3_carry__3_n_1\,
      CO(1) => \byte_offset3_carry__3_n_2\,
      CO(0) => \byte_offset3_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => active_byte_count(19 downto 16),
      O(3) => \byte_offset3_carry__3_n_4\,
      O(2) => \byte_offset3_carry__3_n_5\,
      O(1) => \byte_offset3_carry__3_n_6\,
      O(0) => \byte_offset3_carry__3_n_7\,
      S(3) => \byte_offset3_carry__3_i_1_n_0\,
      S(2) => \byte_offset3_carry__3_i_2_n_0\,
      S(1) => \byte_offset3_carry__3_i_3_n_0\,
      S(0) => \byte_offset3_carry__3_i_4_n_0\
    );
\byte_offset3_carry__3_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(19),
      I1 => byte_offset_reg(19),
      O => \byte_offset3_carry__3_i_1_n_0\
    );
\byte_offset3_carry__3_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(18),
      I1 => byte_offset_reg(18),
      O => \byte_offset3_carry__3_i_2_n_0\
    );
\byte_offset3_carry__3_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(17),
      I1 => byte_offset_reg(17),
      O => \byte_offset3_carry__3_i_3_n_0\
    );
\byte_offset3_carry__3_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(16),
      I1 => byte_offset_reg(16),
      O => \byte_offset3_carry__3_i_4_n_0\
    );
\byte_offset3_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \byte_offset3_carry__3_n_0\,
      CO(3) => \byte_offset3_carry__4_n_0\,
      CO(2) => \byte_offset3_carry__4_n_1\,
      CO(1) => \byte_offset3_carry__4_n_2\,
      CO(0) => \byte_offset3_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => active_byte_count(23 downto 20),
      O(3) => \byte_offset3_carry__4_n_4\,
      O(2) => \byte_offset3_carry__4_n_5\,
      O(1) => \byte_offset3_carry__4_n_6\,
      O(0) => \byte_offset3_carry__4_n_7\,
      S(3) => \byte_offset3_carry__4_i_1_n_0\,
      S(2) => \byte_offset3_carry__4_i_2_n_0\,
      S(1) => \byte_offset3_carry__4_i_3_n_0\,
      S(0) => \byte_offset3_carry__4_i_4_n_0\
    );
\byte_offset3_carry__4_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(23),
      I1 => byte_offset_reg(23),
      O => \byte_offset3_carry__4_i_1_n_0\
    );
\byte_offset3_carry__4_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(22),
      I1 => byte_offset_reg(22),
      O => \byte_offset3_carry__4_i_2_n_0\
    );
\byte_offset3_carry__4_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(21),
      I1 => byte_offset_reg(21),
      O => \byte_offset3_carry__4_i_3_n_0\
    );
\byte_offset3_carry__4_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(20),
      I1 => byte_offset_reg(20),
      O => \byte_offset3_carry__4_i_4_n_0\
    );
\byte_offset3_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \byte_offset3_carry__4_n_0\,
      CO(3) => \byte_offset3_carry__5_n_0\,
      CO(2) => \byte_offset3_carry__5_n_1\,
      CO(1) => \byte_offset3_carry__5_n_2\,
      CO(0) => \byte_offset3_carry__5_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => active_byte_count(27 downto 24),
      O(3) => \byte_offset3_carry__5_n_4\,
      O(2) => \byte_offset3_carry__5_n_5\,
      O(1) => \byte_offset3_carry__5_n_6\,
      O(0) => \byte_offset3_carry__5_n_7\,
      S(3) => \byte_offset3_carry__5_i_1_n_0\,
      S(2) => \byte_offset3_carry__5_i_2_n_0\,
      S(1) => \byte_offset3_carry__5_i_3_n_0\,
      S(0) => \byte_offset3_carry__5_i_4_n_0\
    );
\byte_offset3_carry__5_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(27),
      I1 => byte_offset_reg(27),
      O => \byte_offset3_carry__5_i_1_n_0\
    );
\byte_offset3_carry__5_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(26),
      I1 => byte_offset_reg(26),
      O => \byte_offset3_carry__5_i_2_n_0\
    );
\byte_offset3_carry__5_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(25),
      I1 => byte_offset_reg(25),
      O => \byte_offset3_carry__5_i_3_n_0\
    );
\byte_offset3_carry__5_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(24),
      I1 => byte_offset_reg(24),
      O => \byte_offset3_carry__5_i_4_n_0\
    );
\byte_offset3_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \byte_offset3_carry__5_n_0\,
      CO(3) => \NLW_byte_offset3_carry__6_CO_UNCONNECTED\(3),
      CO(2) => \byte_offset3_carry__6_n_1\,
      CO(1) => \byte_offset3_carry__6_n_2\,
      CO(0) => \byte_offset3_carry__6_n_3\,
      CYINIT => '0',
      DI(3) => '0',
      DI(2 downto 0) => active_byte_count(30 downto 28),
      O(3) => \byte_offset3_carry__6_n_4\,
      O(2) => \byte_offset3_carry__6_n_5\,
      O(1) => \byte_offset3_carry__6_n_6\,
      O(0) => \byte_offset3_carry__6_n_7\,
      S(3) => \byte_offset3_carry__6_i_1_n_0\,
      S(2) => \byte_offset3_carry__6_i_2_n_0\,
      S(1) => \byte_offset3_carry__6_i_3_n_0\,
      S(0) => \byte_offset3_carry__6_i_4_n_0\
    );
\byte_offset3_carry__6_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(31),
      I1 => byte_offset_reg(31),
      O => \byte_offset3_carry__6_i_1_n_0\
    );
\byte_offset3_carry__6_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(30),
      I1 => byte_offset_reg(30),
      O => \byte_offset3_carry__6_i_2_n_0\
    );
\byte_offset3_carry__6_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(29),
      I1 => byte_offset_reg(29),
      O => \byte_offset3_carry__6_i_3_n_0\
    );
\byte_offset3_carry__6_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(28),
      I1 => byte_offset_reg(28),
      O => \byte_offset3_carry__6_i_4_n_0\
    );
byte_offset3_carry_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => active_byte_count(3),
      I1 => byte_offset_reg(3),
      O => byte_offset3_carry_i_1_n_0
    );
byte_offset3_carry_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => active_byte_count(2),
      O => byte_offset3_carry_i_2_n_0
    );
byte_offset3_carry_i_3: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => active_byte_count(1),
      O => byte_offset3_carry_i_3_n_0
    );
byte_offset3_carry_i_4: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => active_byte_count(0),
      O => byte_offset3_carry_i_4_n_0
    );
\byte_offset[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0200FFFF"
    )
        port map (
      I0 => busy_i_2_n_0,
      I1 => \^busy_reg_0\,
      I2 => start_delayed,
      I3 => start,
      I4 => aresetn,
      O => \byte_offset[3]_i_1_n_0\
    );
\byte_offset[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF0000FE000000"
    )
        port map (
      I0 => byte_offset3_carry_n_5,
      I1 => byte_offset3_carry_n_7,
      I2 => byte_offset3_carry_n_6,
      I3 => byte_offset3_carry_n_4,
      I4 => \completed_byte_count[31]_i_3_n_0\,
      I5 => \m_axis_tkeep[7]_INST_0_i_1_n_0\,
      O => byte_offset(0)
    );
\byte_offset[3]_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => byte_offset_reg(3),
      O => \byte_offset[3]_i_4_n_0\
    );
\byte_offset_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[7]_i_1_n_4\,
      Q => byte_offset_reg(10),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[11]_i_1_n_7\,
      Q => byte_offset_reg(11),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[11]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \byte_offset_reg[7]_i_1_n_0\,
      CO(3) => \byte_offset_reg[11]_i_1_n_0\,
      CO(2) => \byte_offset_reg[11]_i_1_n_1\,
      CO(1) => \byte_offset_reg[11]_i_1_n_2\,
      CO(0) => \byte_offset_reg[11]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \byte_offset_reg[11]_i_1_n_4\,
      O(2) => \byte_offset_reg[11]_i_1_n_5\,
      O(1) => \byte_offset_reg[11]_i_1_n_6\,
      O(0) => \byte_offset_reg[11]_i_1_n_7\,
      S(3 downto 0) => byte_offset_reg(14 downto 11)
    );
\byte_offset_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[11]_i_1_n_6\,
      Q => byte_offset_reg(12),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[11]_i_1_n_5\,
      Q => byte_offset_reg(13),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[11]_i_1_n_4\,
      Q => byte_offset_reg(14),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[15]_i_1_n_7\,
      Q => byte_offset_reg(15),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[15]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \byte_offset_reg[11]_i_1_n_0\,
      CO(3) => \byte_offset_reg[15]_i_1_n_0\,
      CO(2) => \byte_offset_reg[15]_i_1_n_1\,
      CO(1) => \byte_offset_reg[15]_i_1_n_2\,
      CO(0) => \byte_offset_reg[15]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \byte_offset_reg[15]_i_1_n_4\,
      O(2) => \byte_offset_reg[15]_i_1_n_5\,
      O(1) => \byte_offset_reg[15]_i_1_n_6\,
      O(0) => \byte_offset_reg[15]_i_1_n_7\,
      S(3 downto 0) => byte_offset_reg(18 downto 15)
    );
\byte_offset_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[15]_i_1_n_6\,
      Q => byte_offset_reg(16),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[15]_i_1_n_5\,
      Q => byte_offset_reg(17),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[15]_i_1_n_4\,
      Q => byte_offset_reg(18),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[19]_i_1_n_7\,
      Q => byte_offset_reg(19),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[19]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \byte_offset_reg[15]_i_1_n_0\,
      CO(3) => \byte_offset_reg[19]_i_1_n_0\,
      CO(2) => \byte_offset_reg[19]_i_1_n_1\,
      CO(1) => \byte_offset_reg[19]_i_1_n_2\,
      CO(0) => \byte_offset_reg[19]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \byte_offset_reg[19]_i_1_n_4\,
      O(2) => \byte_offset_reg[19]_i_1_n_5\,
      O(1) => \byte_offset_reg[19]_i_1_n_6\,
      O(0) => \byte_offset_reg[19]_i_1_n_7\,
      S(3 downto 0) => byte_offset_reg(22 downto 19)
    );
\byte_offset_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[19]_i_1_n_6\,
      Q => byte_offset_reg(20),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[19]_i_1_n_5\,
      Q => byte_offset_reg(21),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[19]_i_1_n_4\,
      Q => byte_offset_reg(22),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[23]_i_1_n_7\,
      Q => byte_offset_reg(23),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[23]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \byte_offset_reg[19]_i_1_n_0\,
      CO(3) => \byte_offset_reg[23]_i_1_n_0\,
      CO(2) => \byte_offset_reg[23]_i_1_n_1\,
      CO(1) => \byte_offset_reg[23]_i_1_n_2\,
      CO(0) => \byte_offset_reg[23]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \byte_offset_reg[23]_i_1_n_4\,
      O(2) => \byte_offset_reg[23]_i_1_n_5\,
      O(1) => \byte_offset_reg[23]_i_1_n_6\,
      O(0) => \byte_offset_reg[23]_i_1_n_7\,
      S(3 downto 0) => byte_offset_reg(26 downto 23)
    );
\byte_offset_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[23]_i_1_n_6\,
      Q => byte_offset_reg(24),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[23]_i_1_n_5\,
      Q => byte_offset_reg(25),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[23]_i_1_n_4\,
      Q => byte_offset_reg(26),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[27]_i_1_n_7\,
      Q => byte_offset_reg(27),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[27]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \byte_offset_reg[23]_i_1_n_0\,
      CO(3) => \byte_offset_reg[27]_i_1_n_0\,
      CO(2) => \byte_offset_reg[27]_i_1_n_1\,
      CO(1) => \byte_offset_reg[27]_i_1_n_2\,
      CO(0) => \byte_offset_reg[27]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \byte_offset_reg[27]_i_1_n_4\,
      O(2) => \byte_offset_reg[27]_i_1_n_5\,
      O(1) => \byte_offset_reg[27]_i_1_n_6\,
      O(0) => \byte_offset_reg[27]_i_1_n_7\,
      S(3 downto 0) => byte_offset_reg(30 downto 27)
    );
\byte_offset_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[27]_i_1_n_6\,
      Q => byte_offset_reg(28),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[27]_i_1_n_5\,
      Q => byte_offset_reg(29),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[27]_i_1_n_4\,
      Q => byte_offset_reg(30),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[31]_i_1_n_7\,
      Q => byte_offset_reg(31),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[31]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \byte_offset_reg[27]_i_1_n_0\,
      CO(3 downto 0) => \NLW_byte_offset_reg[31]_i_1_CO_UNCONNECTED\(3 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 1) => \NLW_byte_offset_reg[31]_i_1_O_UNCONNECTED\(3 downto 1),
      O(0) => \byte_offset_reg[31]_i_1_n_7\,
      S(3 downto 1) => B"000",
      S(0) => byte_offset_reg(31)
    );
\byte_offset_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[3]_i_3_n_7\,
      Q => byte_offset_reg(3),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[3]_i_3\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \byte_offset_reg[3]_i_3_n_0\,
      CO(2) => \byte_offset_reg[3]_i_3_n_1\,
      CO(1) => \byte_offset_reg[3]_i_3_n_2\,
      CO(0) => \byte_offset_reg[3]_i_3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \byte_offset_reg[3]_i_3_n_4\,
      O(2) => \byte_offset_reg[3]_i_3_n_5\,
      O(1) => \byte_offset_reg[3]_i_3_n_6\,
      O(0) => \byte_offset_reg[3]_i_3_n_7\,
      S(3 downto 1) => byte_offset_reg(6 downto 4),
      S(0) => \byte_offset[3]_i_4_n_0\
    );
\byte_offset_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[3]_i_3_n_6\,
      Q => byte_offset_reg(4),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[3]_i_3_n_5\,
      Q => byte_offset_reg(5),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[3]_i_3_n_4\,
      Q => byte_offset_reg(6),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[7]_i_1_n_7\,
      Q => byte_offset_reg(7),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[7]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \byte_offset_reg[3]_i_3_n_0\,
      CO(3) => \byte_offset_reg[7]_i_1_n_0\,
      CO(2) => \byte_offset_reg[7]_i_1_n_1\,
      CO(1) => \byte_offset_reg[7]_i_1_n_2\,
      CO(0) => \byte_offset_reg[7]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \byte_offset_reg[7]_i_1_n_4\,
      O(2) => \byte_offset_reg[7]_i_1_n_5\,
      O(1) => \byte_offset_reg[7]_i_1_n_6\,
      O(0) => \byte_offset_reg[7]_i_1_n_7\,
      S(3 downto 0) => byte_offset_reg(10 downto 7)
    );
\byte_offset_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[7]_i_1_n_6\,
      Q => byte_offset_reg(8),
      R => \byte_offset[3]_i_1_n_0\
    );
\byte_offset_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => byte_offset(0),
      D => \byte_offset_reg[7]_i_1_n_5\,
      Q => byte_offset_reg(9),
      R => \byte_offset[3]_i_1_n_0\
    );
\completed_byte_count[31]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => aresetn,
      O => clear
    );
\completed_byte_count[31]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000008"
    )
        port map (
      I0 => \completed_byte_count[31]_i_3_n_0\,
      I1 => \completed_byte_count[31]_i_4_n_0\,
      I2 => \m_axis_tkeep[7]_INST_0_i_4_n_0\,
      I3 => \m_axis_tkeep[7]_INST_0_i_3_n_0\,
      I4 => \m_axis_tkeep[7]_INST_0_i_2_n_0\,
      O => \completed_byte_count[31]_i_2_n_0\
    );
\completed_byte_count[31]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8808"
    )
        port map (
      I0 => m_axis_tready,
      I1 => \^busy_reg_0\,
      I2 => start,
      I3 => start_delayed,
      O => \completed_byte_count[31]_i_3_n_0\
    );
\completed_byte_count[31]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"01FF"
    )
        port map (
      I0 => byte_offset3_carry_n_7,
      I1 => byte_offset3_carry_n_6,
      I2 => byte_offset3_carry_n_5,
      I3 => byte_offset3_carry_n_4,
      O => \completed_byte_count[31]_i_4_n_0\
    );
\completed_byte_count_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(0),
      Q => completed_byte_count(0),
      R => clear
    );
\completed_byte_count_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(10),
      Q => completed_byte_count(10),
      R => clear
    );
\completed_byte_count_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(11),
      Q => completed_byte_count(11),
      R => clear
    );
\completed_byte_count_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(12),
      Q => completed_byte_count(12),
      R => clear
    );
\completed_byte_count_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(13),
      Q => completed_byte_count(13),
      R => clear
    );
\completed_byte_count_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(14),
      Q => completed_byte_count(14),
      R => clear
    );
\completed_byte_count_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(15),
      Q => completed_byte_count(15),
      R => clear
    );
\completed_byte_count_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(16),
      Q => completed_byte_count(16),
      R => clear
    );
\completed_byte_count_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(17),
      Q => completed_byte_count(17),
      R => clear
    );
\completed_byte_count_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(18),
      Q => completed_byte_count(18),
      R => clear
    );
\completed_byte_count_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(19),
      Q => completed_byte_count(19),
      R => clear
    );
\completed_byte_count_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(1),
      Q => completed_byte_count(1),
      R => clear
    );
\completed_byte_count_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(20),
      Q => completed_byte_count(20),
      R => clear
    );
\completed_byte_count_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(21),
      Q => completed_byte_count(21),
      R => clear
    );
\completed_byte_count_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(22),
      Q => completed_byte_count(22),
      R => clear
    );
\completed_byte_count_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(23),
      Q => completed_byte_count(23),
      R => clear
    );
\completed_byte_count_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(24),
      Q => completed_byte_count(24),
      R => clear
    );
\completed_byte_count_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(25),
      Q => completed_byte_count(25),
      R => clear
    );
\completed_byte_count_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(26),
      Q => completed_byte_count(26),
      R => clear
    );
\completed_byte_count_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(27),
      Q => completed_byte_count(27),
      R => clear
    );
\completed_byte_count_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(28),
      Q => completed_byte_count(28),
      R => clear
    );
\completed_byte_count_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(29),
      Q => completed_byte_count(29),
      R => clear
    );
\completed_byte_count_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(2),
      Q => completed_byte_count(2),
      R => clear
    );
\completed_byte_count_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(30),
      Q => completed_byte_count(30),
      R => clear
    );
\completed_byte_count_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(31),
      Q => completed_byte_count(31),
      R => clear
    );
\completed_byte_count_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(3),
      Q => completed_byte_count(3),
      R => clear
    );
\completed_byte_count_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(4),
      Q => completed_byte_count(4),
      R => clear
    );
\completed_byte_count_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(5),
      Q => completed_byte_count(5),
      R => clear
    );
\completed_byte_count_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(6),
      Q => completed_byte_count(6),
      R => clear
    );
\completed_byte_count_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(7),
      Q => completed_byte_count(7),
      R => clear
    );
\completed_byte_count_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(8),
      Q => completed_byte_count(8),
      R => clear
    );
\completed_byte_count_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => active_byte_count(9),
      Q => completed_byte_count(9),
      R => clear
    );
\completed_packet_count[3]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^completed_packet_count\(0),
      O => \completed_packet_count[3]_i_2_n_0\
    );
\completed_packet_count_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[3]_i_1_n_7\,
      Q => \^completed_packet_count\(0),
      R => clear
    );
\completed_packet_count_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[11]_i_1_n_5\,
      Q => \^completed_packet_count\(10),
      R => clear
    );
\completed_packet_count_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[11]_i_1_n_4\,
      Q => \^completed_packet_count\(11),
      R => clear
    );
\completed_packet_count_reg[11]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \completed_packet_count_reg[7]_i_1_n_0\,
      CO(3) => \completed_packet_count_reg[11]_i_1_n_0\,
      CO(2) => \completed_packet_count_reg[11]_i_1_n_1\,
      CO(1) => \completed_packet_count_reg[11]_i_1_n_2\,
      CO(0) => \completed_packet_count_reg[11]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \completed_packet_count_reg[11]_i_1_n_4\,
      O(2) => \completed_packet_count_reg[11]_i_1_n_5\,
      O(1) => \completed_packet_count_reg[11]_i_1_n_6\,
      O(0) => \completed_packet_count_reg[11]_i_1_n_7\,
      S(3 downto 0) => \^completed_packet_count\(11 downto 8)
    );
\completed_packet_count_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[15]_i_1_n_7\,
      Q => \^completed_packet_count\(12),
      R => clear
    );
\completed_packet_count_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[15]_i_1_n_6\,
      Q => \^completed_packet_count\(13),
      R => clear
    );
\completed_packet_count_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[15]_i_1_n_5\,
      Q => \^completed_packet_count\(14),
      R => clear
    );
\completed_packet_count_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[15]_i_1_n_4\,
      Q => \^completed_packet_count\(15),
      R => clear
    );
\completed_packet_count_reg[15]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \completed_packet_count_reg[11]_i_1_n_0\,
      CO(3) => \completed_packet_count_reg[15]_i_1_n_0\,
      CO(2) => \completed_packet_count_reg[15]_i_1_n_1\,
      CO(1) => \completed_packet_count_reg[15]_i_1_n_2\,
      CO(0) => \completed_packet_count_reg[15]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \completed_packet_count_reg[15]_i_1_n_4\,
      O(2) => \completed_packet_count_reg[15]_i_1_n_5\,
      O(1) => \completed_packet_count_reg[15]_i_1_n_6\,
      O(0) => \completed_packet_count_reg[15]_i_1_n_7\,
      S(3 downto 0) => \^completed_packet_count\(15 downto 12)
    );
\completed_packet_count_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[19]_i_1_n_7\,
      Q => \^completed_packet_count\(16),
      R => clear
    );
\completed_packet_count_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[19]_i_1_n_6\,
      Q => \^completed_packet_count\(17),
      R => clear
    );
\completed_packet_count_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[19]_i_1_n_5\,
      Q => \^completed_packet_count\(18),
      R => clear
    );
\completed_packet_count_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[19]_i_1_n_4\,
      Q => \^completed_packet_count\(19),
      R => clear
    );
\completed_packet_count_reg[19]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \completed_packet_count_reg[15]_i_1_n_0\,
      CO(3) => \completed_packet_count_reg[19]_i_1_n_0\,
      CO(2) => \completed_packet_count_reg[19]_i_1_n_1\,
      CO(1) => \completed_packet_count_reg[19]_i_1_n_2\,
      CO(0) => \completed_packet_count_reg[19]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \completed_packet_count_reg[19]_i_1_n_4\,
      O(2) => \completed_packet_count_reg[19]_i_1_n_5\,
      O(1) => \completed_packet_count_reg[19]_i_1_n_6\,
      O(0) => \completed_packet_count_reg[19]_i_1_n_7\,
      S(3 downto 0) => \^completed_packet_count\(19 downto 16)
    );
\completed_packet_count_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[3]_i_1_n_6\,
      Q => \^completed_packet_count\(1),
      R => clear
    );
\completed_packet_count_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[23]_i_1_n_7\,
      Q => \^completed_packet_count\(20),
      R => clear
    );
\completed_packet_count_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[23]_i_1_n_6\,
      Q => \^completed_packet_count\(21),
      R => clear
    );
\completed_packet_count_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[23]_i_1_n_5\,
      Q => \^completed_packet_count\(22),
      R => clear
    );
\completed_packet_count_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[23]_i_1_n_4\,
      Q => \^completed_packet_count\(23),
      R => clear
    );
\completed_packet_count_reg[23]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \completed_packet_count_reg[19]_i_1_n_0\,
      CO(3) => \completed_packet_count_reg[23]_i_1_n_0\,
      CO(2) => \completed_packet_count_reg[23]_i_1_n_1\,
      CO(1) => \completed_packet_count_reg[23]_i_1_n_2\,
      CO(0) => \completed_packet_count_reg[23]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \completed_packet_count_reg[23]_i_1_n_4\,
      O(2) => \completed_packet_count_reg[23]_i_1_n_5\,
      O(1) => \completed_packet_count_reg[23]_i_1_n_6\,
      O(0) => \completed_packet_count_reg[23]_i_1_n_7\,
      S(3 downto 0) => \^completed_packet_count\(23 downto 20)
    );
\completed_packet_count_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[27]_i_1_n_7\,
      Q => \^completed_packet_count\(24),
      R => clear
    );
\completed_packet_count_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[27]_i_1_n_6\,
      Q => \^completed_packet_count\(25),
      R => clear
    );
\completed_packet_count_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[27]_i_1_n_5\,
      Q => \^completed_packet_count\(26),
      R => clear
    );
\completed_packet_count_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[27]_i_1_n_4\,
      Q => \^completed_packet_count\(27),
      R => clear
    );
\completed_packet_count_reg[27]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \completed_packet_count_reg[23]_i_1_n_0\,
      CO(3) => \completed_packet_count_reg[27]_i_1_n_0\,
      CO(2) => \completed_packet_count_reg[27]_i_1_n_1\,
      CO(1) => \completed_packet_count_reg[27]_i_1_n_2\,
      CO(0) => \completed_packet_count_reg[27]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \completed_packet_count_reg[27]_i_1_n_4\,
      O(2) => \completed_packet_count_reg[27]_i_1_n_5\,
      O(1) => \completed_packet_count_reg[27]_i_1_n_6\,
      O(0) => \completed_packet_count_reg[27]_i_1_n_7\,
      S(3 downto 0) => \^completed_packet_count\(27 downto 24)
    );
\completed_packet_count_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[31]_i_1_n_7\,
      Q => \^completed_packet_count\(28),
      R => clear
    );
\completed_packet_count_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[31]_i_1_n_6\,
      Q => \^completed_packet_count\(29),
      R => clear
    );
\completed_packet_count_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[3]_i_1_n_5\,
      Q => \^completed_packet_count\(2),
      R => clear
    );
\completed_packet_count_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[31]_i_1_n_5\,
      Q => \^completed_packet_count\(30),
      R => clear
    );
\completed_packet_count_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[31]_i_1_n_4\,
      Q => \^completed_packet_count\(31),
      R => clear
    );
\completed_packet_count_reg[31]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \completed_packet_count_reg[27]_i_1_n_0\,
      CO(3) => \NLW_completed_packet_count_reg[31]_i_1_CO_UNCONNECTED\(3),
      CO(2) => \completed_packet_count_reg[31]_i_1_n_1\,
      CO(1) => \completed_packet_count_reg[31]_i_1_n_2\,
      CO(0) => \completed_packet_count_reg[31]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \completed_packet_count_reg[31]_i_1_n_4\,
      O(2) => \completed_packet_count_reg[31]_i_1_n_5\,
      O(1) => \completed_packet_count_reg[31]_i_1_n_6\,
      O(0) => \completed_packet_count_reg[31]_i_1_n_7\,
      S(3 downto 0) => \^completed_packet_count\(31 downto 28)
    );
\completed_packet_count_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[3]_i_1_n_4\,
      Q => \^completed_packet_count\(3),
      R => clear
    );
\completed_packet_count_reg[3]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \completed_packet_count_reg[3]_i_1_n_0\,
      CO(2) => \completed_packet_count_reg[3]_i_1_n_1\,
      CO(1) => \completed_packet_count_reg[3]_i_1_n_2\,
      CO(0) => \completed_packet_count_reg[3]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \completed_packet_count_reg[3]_i_1_n_4\,
      O(2) => \completed_packet_count_reg[3]_i_1_n_5\,
      O(1) => \completed_packet_count_reg[3]_i_1_n_6\,
      O(0) => \completed_packet_count_reg[3]_i_1_n_7\,
      S(3 downto 1) => \^completed_packet_count\(3 downto 1),
      S(0) => \completed_packet_count[3]_i_2_n_0\
    );
\completed_packet_count_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[7]_i_1_n_7\,
      Q => \^completed_packet_count\(4),
      R => clear
    );
\completed_packet_count_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[7]_i_1_n_6\,
      Q => \^completed_packet_count\(5),
      R => clear
    );
\completed_packet_count_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[7]_i_1_n_5\,
      Q => \^completed_packet_count\(6),
      R => clear
    );
\completed_packet_count_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[7]_i_1_n_4\,
      Q => \^completed_packet_count\(7),
      R => clear
    );
\completed_packet_count_reg[7]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \completed_packet_count_reg[3]_i_1_n_0\,
      CO(3) => \completed_packet_count_reg[7]_i_1_n_0\,
      CO(2) => \completed_packet_count_reg[7]_i_1_n_1\,
      CO(1) => \completed_packet_count_reg[7]_i_1_n_2\,
      CO(0) => \completed_packet_count_reg[7]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \completed_packet_count_reg[7]_i_1_n_4\,
      O(2) => \completed_packet_count_reg[7]_i_1_n_5\,
      O(1) => \completed_packet_count_reg[7]_i_1_n_6\,
      O(0) => \completed_packet_count_reg[7]_i_1_n_7\,
      S(3 downto 0) => \^completed_packet_count\(7 downto 4)
    );
\completed_packet_count_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[11]_i_1_n_7\,
      Q => \^completed_packet_count\(8),
      R => clear
    );
\completed_packet_count_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \completed_byte_count[31]_i_2_n_0\,
      D => \completed_packet_count_reg[11]_i_1_n_6\,
      Q => \^completed_packet_count\(9),
      R => clear
    );
\m_axis_tdata[0]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9669"
    )
        port map (
      I0 => \m_axis_tdata[8]_INST_0_i_1_n_0\,
      I1 => byte_offset_reg(8),
      I2 => active_seed(16),
      I3 => active_seed(24),
      O => m_axis_tdata(2)
    );
\m_axis_tdata[17]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \m_axis_tdata[17]_INST_0_i_1_n_0\,
      I1 => byte_offset_reg(9),
      I2 => active_seed(17),
      I3 => active_seed(25),
      O => m_axis_tdata(4)
    );
\m_axis_tdata[17]_INST_0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9669"
    )
        port map (
      I0 => byte_offset_reg(25),
      I1 => byte_offset_reg(17),
      I2 => active_seed(9),
      I3 => active_seed(1),
      O => \m_axis_tdata[17]_INST_0_i_1_n_0\
    );
\m_axis_tdata[1]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9669"
    )
        port map (
      I0 => \m_axis_tdata[17]_INST_0_i_1_n_0\,
      I1 => byte_offset_reg(9),
      I2 => active_seed(17),
      I3 => active_seed(25),
      O => m_axis_tdata(1)
    );
\m_axis_tdata[2]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9669"
    )
        port map (
      I0 => \m_axis_tdata[34]_INST_0_i_1_n_0\,
      I1 => byte_offset_reg(10),
      I2 => active_seed(18),
      I3 => active_seed(26),
      O => m_axis_tdata(0)
    );
\m_axis_tdata[34]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \m_axis_tdata[34]_INST_0_i_1_n_0\,
      I1 => byte_offset_reg(10),
      I2 => active_seed(18),
      I3 => active_seed(26),
      O => m_axis_tdata(5)
    );
\m_axis_tdata[34]_INST_0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9669"
    )
        port map (
      I0 => byte_offset_reg(26),
      I1 => byte_offset_reg(18),
      I2 => active_seed(10),
      I3 => active_seed(2),
      O => \m_axis_tdata[34]_INST_0_i_1_n_0\
    );
\m_axis_tdata[3]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69969669"
    )
        port map (
      I0 => byte_offset_reg(19),
      I1 => byte_offset_reg(27),
      I2 => byte_offset_reg(3),
      I3 => byte_offset_reg(11),
      I4 => \m_axis_tdata[3]_INST_0_i_1_n_0\,
      O => m_axis_tdata(6)
    );
\m_axis_tdata[3]_INST_0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9669"
    )
        port map (
      I0 => active_seed(11),
      I1 => active_seed(3),
      I2 => active_seed(27),
      I3 => active_seed(19),
      O => \m_axis_tdata[3]_INST_0_i_1_n_0\
    );
\m_axis_tdata[4]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69969669"
    )
        port map (
      I0 => byte_offset_reg(20),
      I1 => byte_offset_reg(28),
      I2 => byte_offset_reg(4),
      I3 => byte_offset_reg(12),
      I4 => \m_axis_tdata[4]_INST_0_i_1_n_0\,
      O => m_axis_tdata(7)
    );
\m_axis_tdata[4]_INST_0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9669"
    )
        port map (
      I0 => active_seed(12),
      I1 => active_seed(4),
      I2 => active_seed(28),
      I3 => active_seed(20),
      O => \m_axis_tdata[4]_INST_0_i_1_n_0\
    );
\m_axis_tdata[5]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69969669"
    )
        port map (
      I0 => byte_offset_reg(21),
      I1 => byte_offset_reg(29),
      I2 => byte_offset_reg(5),
      I3 => byte_offset_reg(13),
      I4 => \m_axis_tdata[5]_INST_0_i_1_n_0\,
      O => m_axis_tdata(8)
    );
\m_axis_tdata[5]_INST_0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9669"
    )
        port map (
      I0 => active_seed(13),
      I1 => active_seed(5),
      I2 => active_seed(29),
      I3 => active_seed(21),
      O => \m_axis_tdata[5]_INST_0_i_1_n_0\
    );
\m_axis_tdata[6]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69969669"
    )
        port map (
      I0 => byte_offset_reg(22),
      I1 => byte_offset_reg(30),
      I2 => byte_offset_reg(6),
      I3 => byte_offset_reg(14),
      I4 => \m_axis_tdata[6]_INST_0_i_1_n_0\,
      O => m_axis_tdata(9)
    );
\m_axis_tdata[6]_INST_0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9669"
    )
        port map (
      I0 => active_seed(14),
      I1 => active_seed(6),
      I2 => active_seed(30),
      I3 => active_seed(22),
      O => \m_axis_tdata[6]_INST_0_i_1_n_0\
    );
\m_axis_tdata[7]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69969669"
    )
        port map (
      I0 => byte_offset_reg(23),
      I1 => byte_offset_reg(31),
      I2 => byte_offset_reg(7),
      I3 => byte_offset_reg(15),
      I4 => \m_axis_tdata[7]_INST_0_i_1_n_0\,
      O => m_axis_tdata(10)
    );
\m_axis_tdata[7]_INST_0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9669"
    )
        port map (
      I0 => active_seed(15),
      I1 => active_seed(7),
      I2 => active_seed(31),
      I3 => active_seed(23),
      O => \m_axis_tdata[7]_INST_0_i_1_n_0\
    );
\m_axis_tdata[8]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \m_axis_tdata[8]_INST_0_i_1_n_0\,
      I1 => byte_offset_reg(8),
      I2 => active_seed(16),
      I3 => active_seed(24),
      O => m_axis_tdata(3)
    );
\m_axis_tdata[8]_INST_0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9669"
    )
        port map (
      I0 => byte_offset_reg(24),
      I1 => byte_offset_reg(16),
      I2 => active_seed(8),
      I3 => active_seed(0),
      O => \m_axis_tdata[8]_INST_0_i_1_n_0\
    );
\m_axis_tkeep[0]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => byte_offset3_carry_n_5,
      I1 => byte_offset3_carry_n_7,
      I2 => byte_offset3_carry_n_6,
      I3 => byte_offset3_carry_n_4,
      I4 => \m_axis_tkeep[7]_INST_0_i_1_n_0\,
      O => m_axis_tkeep(0)
    );
\m_axis_tkeep[1]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => byte_offset3_carry_n_5,
      I1 => \m_axis_tkeep[7]_INST_0_i_1_n_0\,
      I2 => byte_offset3_carry_n_4,
      I3 => byte_offset3_carry_n_6,
      O => m_axis_tkeep(1)
    );
\m_axis_tkeep[2]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFF8"
    )
        port map (
      I0 => byte_offset3_carry_n_6,
      I1 => byte_offset3_carry_n_7,
      I2 => byte_offset3_carry_n_5,
      I3 => \m_axis_tkeep[7]_INST_0_i_1_n_0\,
      I4 => byte_offset3_carry_n_4,
      O => m_axis_tkeep(2)
    );
\m_axis_tkeep[3]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => byte_offset3_carry_n_4,
      I1 => \m_axis_tkeep[7]_INST_0_i_1_n_0\,
      I2 => byte_offset3_carry_n_5,
      O => m_axis_tkeep(3)
    );
\m_axis_tkeep[4]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFA8"
    )
        port map (
      I0 => byte_offset3_carry_n_5,
      I1 => byte_offset3_carry_n_7,
      I2 => byte_offset3_carry_n_6,
      I3 => byte_offset3_carry_n_4,
      I4 => \m_axis_tkeep[7]_INST_0_i_1_n_0\,
      O => m_axis_tkeep(4)
    );
\m_axis_tkeep[5]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFF8"
    )
        port map (
      I0 => byte_offset3_carry_n_5,
      I1 => byte_offset3_carry_n_6,
      I2 => byte_offset3_carry_n_4,
      I3 => \m_axis_tkeep[7]_INST_0_i_1_n_0\,
      O => m_axis_tkeep(5)
    );
\m_axis_tkeep[6]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFF80"
    )
        port map (
      I0 => byte_offset3_carry_n_7,
      I1 => byte_offset3_carry_n_6,
      I2 => byte_offset3_carry_n_5,
      I3 => byte_offset3_carry_n_4,
      I4 => \m_axis_tkeep[7]_INST_0_i_1_n_0\,
      O => m_axis_tkeep(6)
    );
\m_axis_tkeep[7]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \m_axis_tkeep[7]_INST_0_i_1_n_0\,
      I1 => byte_offset3_carry_n_4,
      O => m_axis_tkeep(7)
    );
\m_axis_tkeep[7]_INST_0_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => \m_axis_tkeep[7]_INST_0_i_2_n_0\,
      I1 => \m_axis_tkeep[7]_INST_0_i_3_n_0\,
      I2 => \m_axis_tkeep[7]_INST_0_i_4_n_0\,
      O => \m_axis_tkeep[7]_INST_0_i_1_n_0\
    );
\m_axis_tkeep[7]_INST_0_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \byte_offset3_carry__3_n_5\,
      I1 => \byte_offset3_carry__3_n_4\,
      I2 => \byte_offset3_carry__3_n_7\,
      I3 => \byte_offset3_carry__3_n_6\,
      I4 => \m_axis_tkeep[7]_INST_0_i_5_n_0\,
      O => \m_axis_tkeep[7]_INST_0_i_2_n_0\
    );
\m_axis_tkeep[7]_INST_0_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \byte_offset3_carry__1_n_5\,
      I1 => \byte_offset3_carry__1_n_4\,
      I2 => \byte_offset3_carry__1_n_7\,
      I3 => \byte_offset3_carry__1_n_6\,
      I4 => \m_axis_tkeep[7]_INST_0_i_6_n_0\,
      O => \m_axis_tkeep[7]_INST_0_i_3_n_0\
    );
\m_axis_tkeep[7]_INST_0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \m_axis_tkeep[7]_INST_0_i_7_n_0\,
      I1 => \byte_offset3_carry__5_n_6\,
      I2 => \byte_offset3_carry__5_n_7\,
      I3 => \byte_offset3_carry__5_n_4\,
      I4 => \byte_offset3_carry__5_n_5\,
      I5 => \m_axis_tkeep[7]_INST_0_i_8_n_0\,
      O => \m_axis_tkeep[7]_INST_0_i_4_n_0\
    );
\m_axis_tkeep[7]_INST_0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \byte_offset3_carry__4_n_6\,
      I1 => \byte_offset3_carry__4_n_7\,
      I2 => \byte_offset3_carry__4_n_4\,
      I3 => \byte_offset3_carry__4_n_5\,
      O => \m_axis_tkeep[7]_INST_0_i_5_n_0\
    );
\m_axis_tkeep[7]_INST_0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \byte_offset3_carry__2_n_6\,
      I1 => \byte_offset3_carry__2_n_7\,
      I2 => \byte_offset3_carry__2_n_4\,
      I3 => \byte_offset3_carry__2_n_5\,
      O => \m_axis_tkeep[7]_INST_0_i_6_n_0\
    );
\m_axis_tkeep[7]_INST_0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \byte_offset3_carry__6_n_6\,
      I1 => \byte_offset3_carry__6_n_7\,
      I2 => \byte_offset3_carry__6_n_4\,
      I3 => \byte_offset3_carry__6_n_5\,
      O => \m_axis_tkeep[7]_INST_0_i_7_n_0\
    );
\m_axis_tkeep[7]_INST_0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \byte_offset3_carry__0_n_6\,
      I1 => \byte_offset3_carry__0_n_7\,
      I2 => \byte_offset3_carry__0_n_4\,
      I3 => \byte_offset3_carry__0_n_5\,
      O => \m_axis_tkeep[7]_INST_0_i_8_n_0\
    );
m_axis_tlast_INST_0: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000000002AAAA"
    )
        port map (
      I0 => \^busy_reg_0\,
      I1 => byte_offset3_carry_n_7,
      I2 => byte_offset3_carry_n_6,
      I3 => byte_offset3_carry_n_5,
      I4 => byte_offset3_carry_n_4,
      I5 => \m_axis_tkeep[7]_INST_0_i_1_n_0\,
      O => m_axis_tlast
    );
\rejected_start_count[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3010"
    )
        port map (
      I0 => busy_i_2_n_0,
      I1 => start_delayed,
      I2 => start,
      I3 => \^busy_reg_0\,
      O => \rejected_start_count[31]_i_1_n_0\
    );
\rejected_start_count[3]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^rejected_start_count\(0),
      O => \rejected_start_count[3]_i_2_n_0\
    );
\rejected_start_count_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[3]_i_1_n_7\,
      Q => \^rejected_start_count\(0),
      R => clear
    );
\rejected_start_count_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[11]_i_1_n_5\,
      Q => \^rejected_start_count\(10),
      R => clear
    );
\rejected_start_count_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[11]_i_1_n_4\,
      Q => \^rejected_start_count\(11),
      R => clear
    );
\rejected_start_count_reg[11]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \rejected_start_count_reg[7]_i_1_n_0\,
      CO(3) => \rejected_start_count_reg[11]_i_1_n_0\,
      CO(2) => \rejected_start_count_reg[11]_i_1_n_1\,
      CO(1) => \rejected_start_count_reg[11]_i_1_n_2\,
      CO(0) => \rejected_start_count_reg[11]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \rejected_start_count_reg[11]_i_1_n_4\,
      O(2) => \rejected_start_count_reg[11]_i_1_n_5\,
      O(1) => \rejected_start_count_reg[11]_i_1_n_6\,
      O(0) => \rejected_start_count_reg[11]_i_1_n_7\,
      S(3 downto 0) => \^rejected_start_count\(11 downto 8)
    );
\rejected_start_count_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[15]_i_1_n_7\,
      Q => \^rejected_start_count\(12),
      R => clear
    );
\rejected_start_count_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[15]_i_1_n_6\,
      Q => \^rejected_start_count\(13),
      R => clear
    );
\rejected_start_count_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[15]_i_1_n_5\,
      Q => \^rejected_start_count\(14),
      R => clear
    );
\rejected_start_count_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[15]_i_1_n_4\,
      Q => \^rejected_start_count\(15),
      R => clear
    );
\rejected_start_count_reg[15]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \rejected_start_count_reg[11]_i_1_n_0\,
      CO(3) => \rejected_start_count_reg[15]_i_1_n_0\,
      CO(2) => \rejected_start_count_reg[15]_i_1_n_1\,
      CO(1) => \rejected_start_count_reg[15]_i_1_n_2\,
      CO(0) => \rejected_start_count_reg[15]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \rejected_start_count_reg[15]_i_1_n_4\,
      O(2) => \rejected_start_count_reg[15]_i_1_n_5\,
      O(1) => \rejected_start_count_reg[15]_i_1_n_6\,
      O(0) => \rejected_start_count_reg[15]_i_1_n_7\,
      S(3 downto 0) => \^rejected_start_count\(15 downto 12)
    );
\rejected_start_count_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[19]_i_1_n_7\,
      Q => \^rejected_start_count\(16),
      R => clear
    );
\rejected_start_count_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[19]_i_1_n_6\,
      Q => \^rejected_start_count\(17),
      R => clear
    );
\rejected_start_count_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[19]_i_1_n_5\,
      Q => \^rejected_start_count\(18),
      R => clear
    );
\rejected_start_count_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[19]_i_1_n_4\,
      Q => \^rejected_start_count\(19),
      R => clear
    );
\rejected_start_count_reg[19]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \rejected_start_count_reg[15]_i_1_n_0\,
      CO(3) => \rejected_start_count_reg[19]_i_1_n_0\,
      CO(2) => \rejected_start_count_reg[19]_i_1_n_1\,
      CO(1) => \rejected_start_count_reg[19]_i_1_n_2\,
      CO(0) => \rejected_start_count_reg[19]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \rejected_start_count_reg[19]_i_1_n_4\,
      O(2) => \rejected_start_count_reg[19]_i_1_n_5\,
      O(1) => \rejected_start_count_reg[19]_i_1_n_6\,
      O(0) => \rejected_start_count_reg[19]_i_1_n_7\,
      S(3 downto 0) => \^rejected_start_count\(19 downto 16)
    );
\rejected_start_count_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[3]_i_1_n_6\,
      Q => \^rejected_start_count\(1),
      R => clear
    );
\rejected_start_count_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[23]_i_1_n_7\,
      Q => \^rejected_start_count\(20),
      R => clear
    );
\rejected_start_count_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[23]_i_1_n_6\,
      Q => \^rejected_start_count\(21),
      R => clear
    );
\rejected_start_count_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[23]_i_1_n_5\,
      Q => \^rejected_start_count\(22),
      R => clear
    );
\rejected_start_count_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[23]_i_1_n_4\,
      Q => \^rejected_start_count\(23),
      R => clear
    );
\rejected_start_count_reg[23]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \rejected_start_count_reg[19]_i_1_n_0\,
      CO(3) => \rejected_start_count_reg[23]_i_1_n_0\,
      CO(2) => \rejected_start_count_reg[23]_i_1_n_1\,
      CO(1) => \rejected_start_count_reg[23]_i_1_n_2\,
      CO(0) => \rejected_start_count_reg[23]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \rejected_start_count_reg[23]_i_1_n_4\,
      O(2) => \rejected_start_count_reg[23]_i_1_n_5\,
      O(1) => \rejected_start_count_reg[23]_i_1_n_6\,
      O(0) => \rejected_start_count_reg[23]_i_1_n_7\,
      S(3 downto 0) => \^rejected_start_count\(23 downto 20)
    );
\rejected_start_count_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[27]_i_1_n_7\,
      Q => \^rejected_start_count\(24),
      R => clear
    );
\rejected_start_count_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[27]_i_1_n_6\,
      Q => \^rejected_start_count\(25),
      R => clear
    );
\rejected_start_count_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[27]_i_1_n_5\,
      Q => \^rejected_start_count\(26),
      R => clear
    );
\rejected_start_count_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[27]_i_1_n_4\,
      Q => \^rejected_start_count\(27),
      R => clear
    );
\rejected_start_count_reg[27]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \rejected_start_count_reg[23]_i_1_n_0\,
      CO(3) => \rejected_start_count_reg[27]_i_1_n_0\,
      CO(2) => \rejected_start_count_reg[27]_i_1_n_1\,
      CO(1) => \rejected_start_count_reg[27]_i_1_n_2\,
      CO(0) => \rejected_start_count_reg[27]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \rejected_start_count_reg[27]_i_1_n_4\,
      O(2) => \rejected_start_count_reg[27]_i_1_n_5\,
      O(1) => \rejected_start_count_reg[27]_i_1_n_6\,
      O(0) => \rejected_start_count_reg[27]_i_1_n_7\,
      S(3 downto 0) => \^rejected_start_count\(27 downto 24)
    );
\rejected_start_count_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[31]_i_2_n_7\,
      Q => \^rejected_start_count\(28),
      R => clear
    );
\rejected_start_count_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[31]_i_2_n_6\,
      Q => \^rejected_start_count\(29),
      R => clear
    );
\rejected_start_count_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[3]_i_1_n_5\,
      Q => \^rejected_start_count\(2),
      R => clear
    );
\rejected_start_count_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[31]_i_2_n_5\,
      Q => \^rejected_start_count\(30),
      R => clear
    );
\rejected_start_count_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[31]_i_2_n_4\,
      Q => \^rejected_start_count\(31),
      R => clear
    );
\rejected_start_count_reg[31]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \rejected_start_count_reg[27]_i_1_n_0\,
      CO(3) => \NLW_rejected_start_count_reg[31]_i_2_CO_UNCONNECTED\(3),
      CO(2) => \rejected_start_count_reg[31]_i_2_n_1\,
      CO(1) => \rejected_start_count_reg[31]_i_2_n_2\,
      CO(0) => \rejected_start_count_reg[31]_i_2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \rejected_start_count_reg[31]_i_2_n_4\,
      O(2) => \rejected_start_count_reg[31]_i_2_n_5\,
      O(1) => \rejected_start_count_reg[31]_i_2_n_6\,
      O(0) => \rejected_start_count_reg[31]_i_2_n_7\,
      S(3 downto 0) => \^rejected_start_count\(31 downto 28)
    );
\rejected_start_count_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[3]_i_1_n_4\,
      Q => \^rejected_start_count\(3),
      R => clear
    );
\rejected_start_count_reg[3]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \rejected_start_count_reg[3]_i_1_n_0\,
      CO(2) => \rejected_start_count_reg[3]_i_1_n_1\,
      CO(1) => \rejected_start_count_reg[3]_i_1_n_2\,
      CO(0) => \rejected_start_count_reg[3]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \rejected_start_count_reg[3]_i_1_n_4\,
      O(2) => \rejected_start_count_reg[3]_i_1_n_5\,
      O(1) => \rejected_start_count_reg[3]_i_1_n_6\,
      O(0) => \rejected_start_count_reg[3]_i_1_n_7\,
      S(3 downto 1) => \^rejected_start_count\(3 downto 1),
      S(0) => \rejected_start_count[3]_i_2_n_0\
    );
\rejected_start_count_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[7]_i_1_n_7\,
      Q => \^rejected_start_count\(4),
      R => clear
    );
\rejected_start_count_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[7]_i_1_n_6\,
      Q => \^rejected_start_count\(5),
      R => clear
    );
\rejected_start_count_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[7]_i_1_n_5\,
      Q => \^rejected_start_count\(6),
      R => clear
    );
\rejected_start_count_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[7]_i_1_n_4\,
      Q => \^rejected_start_count\(7),
      R => clear
    );
\rejected_start_count_reg[7]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \rejected_start_count_reg[3]_i_1_n_0\,
      CO(3) => \rejected_start_count_reg[7]_i_1_n_0\,
      CO(2) => \rejected_start_count_reg[7]_i_1_n_1\,
      CO(1) => \rejected_start_count_reg[7]_i_1_n_2\,
      CO(0) => \rejected_start_count_reg[7]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \rejected_start_count_reg[7]_i_1_n_4\,
      O(2) => \rejected_start_count_reg[7]_i_1_n_5\,
      O(1) => \rejected_start_count_reg[7]_i_1_n_6\,
      O(0) => \rejected_start_count_reg[7]_i_1_n_7\,
      S(3 downto 0) => \^rejected_start_count\(7 downto 4)
    );
\rejected_start_count_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[11]_i_1_n_7\,
      Q => \^rejected_start_count\(8),
      R => clear
    );
\rejected_start_count_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \rejected_start_count[31]_i_1_n_0\,
      D => \rejected_start_count_reg[11]_i_1_n_6\,
      Q => \^rejected_start_count\(9),
      R => clear
    );
start_delayed_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => start,
      I1 => aresetn,
      O => start_delayed_i_1_n_0
    );
start_delayed_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => start_delayed_i_1_n_0,
      Q => start_delayed,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_return_source_0 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    start : in STD_LOGIC;
    requested_byte_count : in STD_LOGIC_VECTOR ( 31 downto 0 );
    seed : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_tdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    m_axis_tkeep : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tlast : out STD_LOGIC;
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tready : in STD_LOGIC;
    busy : out STD_LOGIC;
    completed_byte_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    completed_packet_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    rejected_start_count : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of c6v_return_source_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_return_source_0 : entity is "c6v_return_source_0,scene2d_return_source,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_return_source_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_return_source_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of c6v_return_source_0 : entity is "scene2d_return_source,Vivado 2026.1";
end c6v_return_source_0;

architecture STRUCTURE of c6v_return_source_0 is
  signal \^m_axis_tdata\ : STD_LOGIC_VECTOR ( 63 downto 26 );
  signal \^m_axis_tvalid\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of aclk : signal is "xilinx.com:signal:clock:1.0 aclk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of aclk : signal is "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF M_AXIS, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of aresetn : signal is "xilinx.com:signal:reset:1.0 aresetn RST";
  attribute X_INTERFACE_MODE of aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of aresetn : signal is "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axis_tlast : signal is "xilinx.com:interface:axis:1.0 M_AXIS TLAST";
  attribute X_INTERFACE_INFO of m_axis_tready : signal is "xilinx.com:interface:axis:1.0 M_AXIS TREADY";
  attribute X_INTERFACE_INFO of m_axis_tvalid : signal is "xilinx.com:interface:axis:1.0 M_AXIS TVALID";
  attribute X_INTERFACE_INFO of m_axis_tdata : signal is "xilinx.com:interface:axis:1.0 M_AXIS TDATA";
  attribute X_INTERFACE_MODE of m_axis_tdata : signal is "master";
  attribute X_INTERFACE_PARAMETER of m_axis_tdata : signal is "XIL_INTERFACENAME M_AXIS, TDATA_NUM_BYTES 8, HAS_TKEEP 1, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 0, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axis_tkeep : signal is "xilinx.com:interface:axis:1.0 M_AXIS TKEEP";
begin
  busy <= \^m_axis_tvalid\;
  m_axis_tdata(63 downto 56) <= \^m_axis_tdata\(63 downto 56);
  m_axis_tdata(55 downto 49) <= \^m_axis_tdata\(63 downto 57);
  m_axis_tdata(48) <= \^m_axis_tdata\(48);
  m_axis_tdata(47 downto 42) <= \^m_axis_tdata\(63 downto 58);
  m_axis_tdata(41) <= \^m_axis_tdata\(41);
  m_axis_tdata(40) <= \^m_axis_tdata\(56);
  m_axis_tdata(39 downto 34) <= \^m_axis_tdata\(63 downto 58);
  m_axis_tdata(33) <= \^m_axis_tdata\(41);
  m_axis_tdata(32) <= \^m_axis_tdata\(48);
  m_axis_tdata(31 downto 27) <= \^m_axis_tdata\(63 downto 59);
  m_axis_tdata(26) <= \^m_axis_tdata\(26);
  m_axis_tdata(25 downto 24) <= \^m_axis_tdata\(57 downto 56);
  m_axis_tdata(23 downto 19) <= \^m_axis_tdata\(63 downto 59);
  m_axis_tdata(18) <= \^m_axis_tdata\(26);
  m_axis_tdata(17) <= \^m_axis_tdata\(57);
  m_axis_tdata(16) <= \^m_axis_tdata\(48);
  m_axis_tdata(15 downto 11) <= \^m_axis_tdata\(63 downto 59);
  m_axis_tdata(10) <= \^m_axis_tdata\(26);
  m_axis_tdata(9) <= \^m_axis_tdata\(41);
  m_axis_tdata(8) <= \^m_axis_tdata\(56);
  m_axis_tdata(7 downto 3) <= \^m_axis_tdata\(63 downto 59);
  m_axis_tdata(2) <= \^m_axis_tdata\(26);
  m_axis_tdata(1) <= \^m_axis_tdata\(41);
  m_axis_tdata(0) <= \^m_axis_tdata\(48);
  m_axis_tvalid <= \^m_axis_tvalid\;
inst: entity work.c6v_return_source_0_scene2d_return_source
     port map (
      aclk => aclk,
      aresetn => aresetn,
      busy_reg_0 => \^m_axis_tvalid\,
      completed_byte_count(31 downto 0) => completed_byte_count(31 downto 0),
      completed_packet_count(31 downto 0) => completed_packet_count(31 downto 0),
      m_axis_tdata(10 downto 3) => \^m_axis_tdata\(63 downto 56),
      m_axis_tdata(2) => \^m_axis_tdata\(48),
      m_axis_tdata(1) => \^m_axis_tdata\(41),
      m_axis_tdata(0) => \^m_axis_tdata\(26),
      m_axis_tkeep(7 downto 0) => m_axis_tkeep(7 downto 0),
      m_axis_tlast => m_axis_tlast,
      m_axis_tready => m_axis_tready,
      rejected_start_count(31 downto 0) => rejected_start_count(31 downto 0),
      requested_byte_count(31 downto 0) => requested_byte_count(31 downto 0),
      seed(31 downto 0) => seed(31 downto 0),
      start => start
    );
end STRUCTURE;
