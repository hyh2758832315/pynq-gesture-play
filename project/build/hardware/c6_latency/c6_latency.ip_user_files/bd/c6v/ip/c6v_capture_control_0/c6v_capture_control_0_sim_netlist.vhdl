-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 23 06:47:56 2026
-- Host        : build-host running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               e:/vvl/c0e/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_control_0/c6v_capture_control_0_sim_netlist.vhdl
-- Design      : c6v_capture_control_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_capture_control_0_axi_vision_capture_control is
  port (
    owner_command_fault_reg_0 : out STD_LOGIC;
    armed_reg_0 : out STD_LOGIC;
    cfg_frame_context : out STD_LOGIC_VECTOR ( 143 downto 0 );
    owner_cpu_epoch : out STD_LOGIC_VECTOR ( 31 downto 0 );
    owner_cpu_frame_id : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    capture_aresetn : out STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bvalid_reg_0 : out STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    barrier_request_reg_0 : out STD_LOGIC;
    abort_requested_reg_0 : out STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rvalid_reg_0 : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 0 to 0 );
    owner_cpu_claim : out STD_LOGIC;
    owner_cpu_release : out STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    owner_fault : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    owner_release_accepted : in STD_LOGIC;
    owner_claim_accepted : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_aclk : in STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    D : in STD_LOGIC_VECTOR ( 2 downto 0 );
    common_aresetn : in STD_LOGIC;
    s_axi_arvalid : in STD_LOGIC;
    owner_released_frames : in STD_LOGIC_VECTOR ( 31 downto 0 );
    owner_fault_causes : in STD_LOGIC_VECTOR ( 3 downto 0 );
    owner_granted_frames : in STD_LOGIC_VECTOR ( 31 downto 0 );
    owner_slot : in STD_LOGIC_VECTOR ( 31 downto 0 );
    owner_frame_id : in STD_LOGIC_VECTOR ( 31 downto 0 );
    owner_epoch : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_capture_control_0_axi_vision_capture_control : entity is "axi_vision_capture_control";
end c6v_capture_control_0_axi_vision_capture_control;

architecture STRUCTURE of c6v_capture_control_0_axi_vision_capture_control is
  signal abort_requested0 : STD_LOGIC;
  signal abort_requested2 : STD_LOGIC;
  signal abort_requested_i_1_n_0 : STD_LOGIC;
  signal abort_requested_i_3_n_0 : STD_LOGIC;
  signal abort_requested_i_4_n_0 : STD_LOGIC;
  signal abort_requested_i_5_n_0 : STD_LOGIC;
  signal \^abort_requested_reg_0\ : STD_LOGIC;
  signal \address_held_reg_n_0_[0]\ : STD_LOGIC;
  signal \address_held_reg_n_0_[10]\ : STD_LOGIC;
  signal \address_held_reg_n_0_[11]\ : STD_LOGIC;
  signal \address_held_reg_n_0_[1]\ : STD_LOGIC;
  signal \address_held_reg_n_0_[4]\ : STD_LOGIC;
  signal \address_held_reg_n_0_[5]\ : STD_LOGIC;
  signal \address_held_reg_n_0_[6]\ : STD_LOGIC;
  signal \address_held_reg_n_0_[7]\ : STD_LOGIC;
  signal \address_held_reg_n_0_[8]\ : STD_LOGIC;
  signal \address_held_reg_n_0_[9]\ : STD_LOGIC;
  signal armed0 : STD_LOGIC;
  signal armed_i_10_n_0 : STD_LOGIC;
  signal armed_i_11_n_0 : STD_LOGIC;
  signal armed_i_12_n_0 : STD_LOGIC;
  signal armed_i_13_n_0 : STD_LOGIC;
  signal armed_i_1_n_0 : STD_LOGIC;
  signal armed_i_3_n_0 : STD_LOGIC;
  signal armed_i_4_n_0 : STD_LOGIC;
  signal armed_i_5_n_0 : STD_LOGIC;
  signal armed_i_6_n_0 : STD_LOGIC;
  signal armed_i_7_n_0 : STD_LOGIC;
  signal armed_i_8_n_0 : STD_LOGIC;
  signal armed_i_9_n_0 : STD_LOGIC;
  signal \^armed_reg_0\ : STD_LOGIC;
  signal aw_held : STD_LOGIC;
  signal aw_held0 : STD_LOGIC;
  signal aw_held_i_1_n_0 : STD_LOGIC;
  signal barrier_request0 : STD_LOGIC;
  signal barrier_request_i_1_n_0 : STD_LOGIC;
  signal \^barrier_request_reg_0\ : STD_LOGIC;
  signal capture_aresetn0 : STD_LOGIC;
  signal capture_aresetn_i_2_n_0 : STD_LOGIC;
  signal \^cfg_frame_context\ : STD_LOGIC_VECTOR ( 143 downto 0 );
  signal cfg_frame_context0 : STD_LOGIC_VECTOR ( 95 downto 0 );
  signal \cfg_frame_context[127]_i_1_n_0\ : STD_LOGIC;
  signal \cfg_frame_context[127]_i_2_n_0\ : STD_LOGIC;
  signal \cfg_frame_context[127]_i_3_n_0\ : STD_LOGIC;
  signal \cfg_frame_context[143]_i_1_n_0\ : STD_LOGIC;
  signal \cfg_frame_context[143]_i_3_n_0\ : STD_LOGIC;
  signal \cfg_frame_context[31]_i_1_n_0\ : STD_LOGIC;
  signal \cfg_frame_context[31]_i_3_n_0\ : STD_LOGIC;
  signal \cfg_frame_context[63]_i_1_n_0\ : STD_LOGIC;
  signal \cfg_frame_context[95]_i_1_n_0\ : STD_LOGIC;
  signal \cfg_frame_context[95]_i_3_n_0\ : STD_LOGIC;
  signal \configured[0]_i_1_n_0\ : STD_LOGIC;
  signal \configured[1]_i_1_n_0\ : STD_LOGIC;
  signal \configured[2]_i_1_n_0\ : STD_LOGIC;
  signal \configured[3]_i_1_n_0\ : STD_LOGIC;
  signal \configured[4]_i_1_n_0\ : STD_LOGIC;
  signal \configured[4]_i_2_n_0\ : STD_LOGIC;
  signal \configured[4]_i_3_n_0\ : STD_LOGIC;
  signal \configured[4]_i_4_n_0\ : STD_LOGIC;
  signal \configured[4]_i_5_n_0\ : STD_LOGIC;
  signal \configured[4]_i_6_n_0\ : STD_LOGIC;
  signal \configured_reg_n_0_[0]\ : STD_LOGIC;
  signal \configured_reg_n_0_[1]\ : STD_LOGIC;
  signal \configured_reg_n_0_[2]\ : STD_LOGIC;
  signal \configured_reg_n_0_[3]\ : STD_LOGIC;
  signal \configured_reg_n_0_[4]\ : STD_LOGIC;
  signal data_held : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal owner_command_fault_i_1_n_0 : STD_LOGIC;
  signal owner_command_fault_i_2_n_0 : STD_LOGIC;
  signal \^owner_command_fault_reg_0\ : STD_LOGIC;
  signal owner_command_is_release_i_1_n_0 : STD_LOGIC;
  signal owner_command_is_release_reg_n_0 : STD_LOGIC;
  signal owner_command_pending18_out : STD_LOGIC;
  signal owner_command_pending_i_1_n_0 : STD_LOGIC;
  signal owner_command_pending_reg_n_0 : STD_LOGIC;
  signal \owner_command_wait[0]_i_1_n_0\ : STD_LOGIC;
  signal \owner_command_wait[1]_i_1_n_0\ : STD_LOGIC;
  signal \owner_command_wait[1]_i_2_n_0\ : STD_LOGIC;
  signal \owner_command_wait[1]_i_3_n_0\ : STD_LOGIC;
  signal \owner_command_wait[1]_i_4_n_0\ : STD_LOGIC;
  signal \owner_command_wait_reg_n_0_[0]\ : STD_LOGIC;
  signal \owner_command_wait_reg_n_0_[1]\ : STD_LOGIC;
  signal owner_cpu_claim_i_1_n_0 : STD_LOGIC;
  signal owner_cpu_claim_i_2_n_0 : STD_LOGIC;
  signal owner_cpu_claim_i_3_n_0 : STD_LOGIC;
  signal owner_cpu_claim_i_4_n_0 : STD_LOGIC;
  signal owner_cpu_claim_i_5_n_0 : STD_LOGIC;
  signal owner_cpu_claim_i_6_n_0 : STD_LOGIC;
  signal owner_cpu_claim_i_7_n_0 : STD_LOGIC;
  signal owner_cpu_claim_i_8_n_0 : STD_LOGIC;
  signal owner_cpu_claim_i_9_n_0 : STD_LOGIC;
  signal \^owner_cpu_epoch\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \owner_cpu_epoch[31]_i_1_n_0\ : STD_LOGIC;
  signal \owner_cpu_epoch[31]_i_2_n_0\ : STD_LOGIC;
  signal \owner_cpu_epoch[31]_i_3_n_0\ : STD_LOGIC;
  signal \owner_cpu_epoch[31]_i_4_n_0\ : STD_LOGIC;
  signal \^owner_cpu_frame_id\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \owner_cpu_frame_id[31]_i_1_n_0\ : STD_LOGIC;
  signal owner_cpu_release_i_1_n_0 : STD_LOGIC;
  signal \owner_status_held[6]_i_2_n_0\ : STD_LOGIC;
  signal \owner_status_held[6]_i_3_n_0\ : STD_LOGIC;
  signal \owner_status_held[6]_i_4_n_0\ : STD_LOGIC;
  signal \owner_status_held[6]_i_5_n_0\ : STD_LOGIC;
  signal \owner_status_held_reg_n_0_[0]\ : STD_LOGIC;
  signal \owner_status_held_reg_n_0_[1]\ : STD_LOGIC;
  signal \owner_status_held_reg_n_0_[2]\ : STD_LOGIC;
  signal \owner_status_held_reg_n_0_[3]\ : STD_LOGIC;
  signal \owner_status_held_reg_n_0_[4]\ : STD_LOGIC;
  signal \owner_status_held_reg_n_0_[5]\ : STD_LOGIC;
  signal \owner_status_held_reg_n_0_[6]\ : STD_LOGIC;
  signal owner_status_pending1 : STD_LOGIC;
  signal owner_status_pending3_out : STD_LOGIC;
  signal owner_status_pending_i_1_n_0 : STD_LOGIC;
  signal owner_status_pending_reg_n_0 : STD_LOGIC;
  signal \owner_token_configured[0]_i_1_n_0\ : STD_LOGIC;
  signal \owner_token_configured[1]_i_1_n_0\ : STD_LOGIC;
  signal \owner_token_configured[1]_i_2_n_0\ : STD_LOGIC;
  signal \owner_token_configured[1]_i_3_n_0\ : STD_LOGIC;
  signal \owner_token_configured[1]_i_4_n_0\ : STD_LOGIC;
  signal \owner_token_configured[1]_i_5_n_0\ : STD_LOGIC;
  signal \owner_token_configured_reg_n_0_[0]\ : STD_LOGIC;
  signal \owner_token_configured_reg_n_0_[1]\ : STD_LOGIC;
  signal p_0_in : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal p_0_out : STD_LOGIC_VECTOR ( 3 to 3 );
  signal p_2_in : STD_LOGIC_VECTOR ( 143 downto 128 );
  signal \^s_axi_bresp\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \s_axi_bresp[1]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_11_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_12_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_13_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_14_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_15_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_16_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_17_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_18_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_19_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_20_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_21_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_22_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_23_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_24_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_25_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_26_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_27_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_bresp[1]_i_9_n_0\ : STD_LOGIC;
  signal s_axi_bvalid_i_1_n_0 : STD_LOGIC;
  signal s_axi_bvalid_i_3_n_0 : STD_LOGIC;
  signal s_axi_bvalid_i_4_n_0 : STD_LOGIC;
  signal \^s_axi_bvalid_reg_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[0]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_10_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_11_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_12_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_7_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_8_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_9_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_6_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[7]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[7]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[7]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[7]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[7]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_5_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[9]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[9]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[9]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[9]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[9]_i_5_n_0\ : STD_LOGIC;
  signal \^s_axi_rresp\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \s_axi_rresp[1]_i_1_n_0\ : STD_LOGIC;
  signal \s_axi_rresp[1]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rresp[1]_i_3_n_0\ : STD_LOGIC;
  signal \s_axi_rresp[1]_i_4_n_0\ : STD_LOGIC;
  signal \s_axi_rresp[1]_i_5_n_0\ : STD_LOGIC;
  signal s_axi_rvalid_i_1_n_0 : STD_LOGIC;
  signal s_axi_rvalid_i_2_n_0 : STD_LOGIC;
  signal \^s_axi_rvalid_reg_0\ : STD_LOGIC;
  signal strobes_held : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal w_held0 : STD_LOGIC;
  signal w_held_i_1_n_0 : STD_LOGIC;
  signal w_held_reg_n_0 : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of abort_requested_i_1 : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of abort_requested_i_2 : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of abort_requested_i_4 : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of armed_i_1 : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of armed_i_10 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of armed_i_11 : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of armed_i_8 : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of armed_i_9 : label is "soft_lutpair5";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of capture_aresetn_reg : label is "xilinx.com:signal:reset:1.0 capture_aresetn RST";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of capture_aresetn_reg : label is "POLARITY ACTIVE_LOW";
  attribute SOFT_HLUTNM of \cfg_frame_context[0]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \cfg_frame_context[10]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \cfg_frame_context[11]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \cfg_frame_context[127]_i_3\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \cfg_frame_context[128]_i_1\ : label is "soft_lutpair61";
  attribute SOFT_HLUTNM of \cfg_frame_context[129]_i_1\ : label is "soft_lutpair61";
  attribute SOFT_HLUTNM of \cfg_frame_context[12]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \cfg_frame_context[130]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \cfg_frame_context[131]_i_1\ : label is "soft_lutpair60";
  attribute SOFT_HLUTNM of \cfg_frame_context[132]_i_1\ : label is "soft_lutpair60";
  attribute SOFT_HLUTNM of \cfg_frame_context[133]_i_1\ : label is "soft_lutpair59";
  attribute SOFT_HLUTNM of \cfg_frame_context[134]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \cfg_frame_context[135]_i_1\ : label is "soft_lutpair59";
  attribute SOFT_HLUTNM of \cfg_frame_context[136]_i_1\ : label is "soft_lutpair58";
  attribute SOFT_HLUTNM of \cfg_frame_context[137]_i_1\ : label is "soft_lutpair58";
  attribute SOFT_HLUTNM of \cfg_frame_context[138]_i_1\ : label is "soft_lutpair57";
  attribute SOFT_HLUTNM of \cfg_frame_context[139]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \cfg_frame_context[13]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \cfg_frame_context[140]_i_1\ : label is "soft_lutpair57";
  attribute SOFT_HLUTNM of \cfg_frame_context[141]_i_1\ : label is "soft_lutpair56";
  attribute SOFT_HLUTNM of \cfg_frame_context[142]_i_1\ : label is "soft_lutpair56";
  attribute SOFT_HLUTNM of \cfg_frame_context[143]_i_2\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \cfg_frame_context[14]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \cfg_frame_context[15]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \cfg_frame_context[16]_i_1\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \cfg_frame_context[17]_i_1\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \cfg_frame_context[18]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \cfg_frame_context[19]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \cfg_frame_context[1]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \cfg_frame_context[20]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \cfg_frame_context[21]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \cfg_frame_context[22]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \cfg_frame_context[23]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \cfg_frame_context[24]_i_1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \cfg_frame_context[25]_i_1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \cfg_frame_context[26]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \cfg_frame_context[27]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \cfg_frame_context[28]_i_1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \cfg_frame_context[29]_i_1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \cfg_frame_context[2]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \cfg_frame_context[30]_i_1\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \cfg_frame_context[31]_i_2\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \cfg_frame_context[31]_i_3\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \cfg_frame_context[3]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \cfg_frame_context[4]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \cfg_frame_context[5]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \cfg_frame_context[64]_i_1\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \cfg_frame_context[65]_i_1\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \cfg_frame_context[66]_i_1\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \cfg_frame_context[67]_i_1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \cfg_frame_context[68]_i_1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \cfg_frame_context[69]_i_1\ : label is "soft_lutpair41";
  attribute SOFT_HLUTNM of \cfg_frame_context[6]_i_1\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \cfg_frame_context[70]_i_1\ : label is "soft_lutpair41";
  attribute SOFT_HLUTNM of \cfg_frame_context[71]_i_1\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of \cfg_frame_context[72]_i_1\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of \cfg_frame_context[73]_i_1\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of \cfg_frame_context[74]_i_1\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of \cfg_frame_context[75]_i_1\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of \cfg_frame_context[76]_i_1\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of \cfg_frame_context[77]_i_1\ : label is "soft_lutpair45";
  attribute SOFT_HLUTNM of \cfg_frame_context[78]_i_1\ : label is "soft_lutpair45";
  attribute SOFT_HLUTNM of \cfg_frame_context[79]_i_1\ : label is "soft_lutpair46";
  attribute SOFT_HLUTNM of \cfg_frame_context[7]_i_1\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \cfg_frame_context[80]_i_1\ : label is "soft_lutpair46";
  attribute SOFT_HLUTNM of \cfg_frame_context[81]_i_1\ : label is "soft_lutpair47";
  attribute SOFT_HLUTNM of \cfg_frame_context[82]_i_1\ : label is "soft_lutpair47";
  attribute SOFT_HLUTNM of \cfg_frame_context[83]_i_1\ : label is "soft_lutpair48";
  attribute SOFT_HLUTNM of \cfg_frame_context[84]_i_1\ : label is "soft_lutpair48";
  attribute SOFT_HLUTNM of \cfg_frame_context[85]_i_1\ : label is "soft_lutpair49";
  attribute SOFT_HLUTNM of \cfg_frame_context[86]_i_1\ : label is "soft_lutpair49";
  attribute SOFT_HLUTNM of \cfg_frame_context[87]_i_1\ : label is "soft_lutpair50";
  attribute SOFT_HLUTNM of \cfg_frame_context[88]_i_1\ : label is "soft_lutpair50";
  attribute SOFT_HLUTNM of \cfg_frame_context[89]_i_1\ : label is "soft_lutpair51";
  attribute SOFT_HLUTNM of \cfg_frame_context[8]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \cfg_frame_context[90]_i_1\ : label is "soft_lutpair51";
  attribute SOFT_HLUTNM of \cfg_frame_context[91]_i_1\ : label is "soft_lutpair52";
  attribute SOFT_HLUTNM of \cfg_frame_context[92]_i_1\ : label is "soft_lutpair52";
  attribute SOFT_HLUTNM of \cfg_frame_context[93]_i_1\ : label is "soft_lutpair53";
  attribute SOFT_HLUTNM of \cfg_frame_context[94]_i_1\ : label is "soft_lutpair53";
  attribute SOFT_HLUTNM of \cfg_frame_context[95]_i_2\ : label is "soft_lutpair54";
  attribute SOFT_HLUTNM of \cfg_frame_context[95]_i_3\ : label is "soft_lutpair54";
  attribute SOFT_HLUTNM of \cfg_frame_context[9]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \configured[4]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of owner_command_fault_i_2 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of owner_cpu_claim_i_3 : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of owner_cpu_claim_i_9 : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \owner_cpu_epoch[31]_i_4\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \owner_status_held[3]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \owner_status_held[6]_i_2\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \owner_status_held[6]_i_3\ : label is "soft_lutpair55";
  attribute SOFT_HLUTNM of \owner_token_configured[1]_i_2\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \owner_token_configured[1]_i_3\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \owner_token_configured[1]_i_5\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of s_axi_arready_INST_0 : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of s_axi_awready_INST_0 : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \s_axi_bresp[1]_i_21\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \s_axi_bresp[1]_i_23\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \s_axi_bresp[1]_i_25\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \s_axi_bresp[1]_i_27\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \s_axi_bresp[1]_i_5\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \s_axi_bresp[1]_i_7\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \s_axi_bresp[1]_i_9\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of s_axi_bvalid_i_4 : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \s_axi_rdata[12]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \s_axi_rdata[14]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \s_axi_rdata[17]_i_2\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \s_axi_rdata[29]_i_2\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \s_axi_rdata[30]_i_5\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \s_axi_rdata[31]_i_11\ : label is "soft_lutpair55";
  attribute SOFT_HLUTNM of \s_axi_rdata[3]_i_3\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \s_axi_rdata[3]_i_4\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \s_axi_rdata[4]_i_2\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \s_axi_rdata[4]_i_4\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \s_axi_rresp[1]_i_2\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of s_axi_wready_INST_0 : label is "soft_lutpair11";
begin
  abort_requested_reg_0 <= \^abort_requested_reg_0\;
  armed_reg_0 <= \^armed_reg_0\;
  barrier_request_reg_0 <= \^barrier_request_reg_0\;
  cfg_frame_context(143 downto 0) <= \^cfg_frame_context\(143 downto 0);
  owner_command_fault_reg_0 <= \^owner_command_fault_reg_0\;
  owner_cpu_epoch(31 downto 0) <= \^owner_cpu_epoch\(31 downto 0);
  owner_cpu_frame_id(31 downto 0) <= \^owner_cpu_frame_id\(31 downto 0);
  s_axi_bresp(0) <= \^s_axi_bresp\(0);
  s_axi_bvalid_reg_0 <= \^s_axi_bvalid_reg_0\;
  s_axi_rresp(0) <= \^s_axi_rresp\(0);
  s_axi_rvalid_reg_0 <= \^s_axi_rvalid_reg_0\;
abort_requested_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AAAAAAEA"
    )
        port map (
      I0 => \^abort_requested_reg_0\,
      I1 => \^armed_reg_0\,
      I2 => abort_requested2,
      I3 => armed_i_3_n_0,
      I4 => armed0,
      O => abort_requested_i_1_n_0
    );
abort_requested_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0010"
    )
        port map (
      I0 => \configured[4]_i_2_n_0\,
      I1 => data_held(2),
      I2 => data_held(1),
      I3 => abort_requested_i_3_n_0,
      O => abort_requested2
    );
abort_requested_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => abort_requested_i_4_n_0,
      I1 => data_held(13),
      I2 => data_held(9),
      I3 => data_held(14),
      I4 => data_held(12),
      I5 => abort_requested_i_5_n_0,
      O => abort_requested_i_3_n_0
    );
abort_requested_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => data_held(15),
      I1 => data_held(11),
      I2 => data_held(8),
      I3 => data_held(10),
      O => abort_requested_i_4_n_0
    );
abort_requested_i_5: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => data_held(4),
      I1 => data_held(7),
      I2 => data_held(5),
      I3 => data_held(6),
      I4 => data_held(0),
      I5 => data_held(3),
      O => abort_requested_i_5_n_0
    );
abort_requested_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => abort_requested_i_1_n_0,
      Q => \^abort_requested_reg_0\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\address_held[11]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0002"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => \^s_axi_bvalid_reg_0\,
      I2 => owner_command_pending_reg_n_0,
      I3 => aw_held,
      O => aw_held0
    );
\address_held_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(0),
      Q => \address_held_reg_n_0_[0]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\address_held_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(10),
      Q => \address_held_reg_n_0_[10]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\address_held_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(11),
      Q => \address_held_reg_n_0_[11]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\address_held_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(1),
      Q => \address_held_reg_n_0_[1]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\address_held_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(2),
      Q => p_0_in(0),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\address_held_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(3),
      Q => p_0_in(1),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\address_held_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(4),
      Q => \address_held_reg_n_0_[4]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\address_held_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(5),
      Q => \address_held_reg_n_0_[5]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\address_held_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(6),
      Q => \address_held_reg_n_0_[6]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\address_held_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(7),
      Q => \address_held_reg_n_0_[7]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\address_held_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(8),
      Q => \address_held_reg_n_0_[8]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\address_held_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => aw_held0,
      D => s_axi_awaddr(9),
      Q => \address_held_reg_n_0_[9]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
armed_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F2"
    )
        port map (
      I0 => armed0,
      I1 => armed_i_3_n_0,
      I2 => \^armed_reg_0\,
      O => armed_i_1_n_0
    );
armed_i_10: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(129),
      I1 => \^cfg_frame_context\(130),
      I2 => \^cfg_frame_context\(128),
      I3 => \^cfg_frame_context\(131),
      I4 => \s_axi_bresp[1]_i_22_n_0\,
      O => armed_i_10_n_0
    );
armed_i_11: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(138),
      I1 => \^cfg_frame_context\(139),
      I2 => \^cfg_frame_context\(136),
      I3 => \^cfg_frame_context\(137),
      I4 => \s_axi_bresp[1]_i_20_n_0\,
      O => armed_i_11_n_0
    );
armed_i_12: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(69),
      I1 => \^cfg_frame_context\(68),
      I2 => \^cfg_frame_context\(71),
      I3 => \^cfg_frame_context\(70),
      O => armed_i_12_n_0
    );
armed_i_13: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(53),
      I1 => \^cfg_frame_context\(52),
      I2 => \^cfg_frame_context\(55),
      I3 => \^cfg_frame_context\(54),
      O => armed_i_13_n_0
    );
armed_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"04040004"
    )
        port map (
      I0 => armed_i_4_n_0,
      I1 => owner_cpu_claim_i_3_n_0,
      I2 => armed_i_5_n_0,
      I3 => armed_i_6_n_0,
      I4 => armed_i_7_n_0,
      O => armed0
    );
armed_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFDFFFF"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_5_n_0\,
      I1 => \address_held_reg_n_0_[5]\,
      I2 => p_0_in(0),
      I3 => p_0_in(1),
      I4 => \address_held_reg_n_0_[4]\,
      I5 => \address_held_reg_n_0_[6]\,
      O => armed_i_3_n_0
    );
armed_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"DFFFFFFFFFFFFFFF"
    )
        port map (
      I0 => \configured_reg_n_0_[0]\,
      I1 => \^armed_reg_0\,
      I2 => \configured_reg_n_0_[2]\,
      I3 => \configured_reg_n_0_[1]\,
      I4 => \configured_reg_n_0_[4]\,
      I5 => \configured_reg_n_0_[3]\,
      O => armed_i_4_n_0
    );
armed_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0004"
    )
        port map (
      I0 => armed_i_8_n_0,
      I1 => armed_i_9_n_0,
      I2 => armed_i_10_n_0,
      I3 => armed_i_11_n_0,
      O => armed_i_5_n_0
    );
armed_i_6: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => armed_i_12_n_0,
      I1 => \^cfg_frame_context\(67),
      I2 => \^cfg_frame_context\(66),
      I3 => \^cfg_frame_context\(65),
      I4 => \^cfg_frame_context\(64),
      I5 => \s_axi_bresp[1]_i_15_n_0\,
      O => armed_i_6_n_0
    );
armed_i_7: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => armed_i_13_n_0,
      I1 => \^cfg_frame_context\(50),
      I2 => \^cfg_frame_context\(49),
      I3 => \^cfg_frame_context\(51),
      I4 => \^cfg_frame_context\(48),
      I5 => \s_axi_bresp[1]_i_13_n_0\,
      O => armed_i_7_n_0
    );
armed_i_8: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(112),
      I1 => \^cfg_frame_context\(113),
      I2 => \^cfg_frame_context\(114),
      I3 => \^cfg_frame_context\(115),
      I4 => \s_axi_bresp[1]_i_26_n_0\,
      O => armed_i_8_n_0
    );
armed_i_9: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => \^cfg_frame_context\(121),
      I1 => \^cfg_frame_context\(122),
      I2 => \^cfg_frame_context\(120),
      I3 => \^cfg_frame_context\(123),
      I4 => \s_axi_bresp[1]_i_24_n_0\,
      O => armed_i_9_n_0
    );
armed_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => armed_i_1_n_0,
      Q => \^armed_reg_0\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
aw_held_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0000020F0F00020"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => owner_command_pending_reg_n_0,
      I2 => s_axi_aresetn,
      I3 => \^s_axi_bvalid_reg_0\,
      I4 => aw_held,
      I5 => w_held_reg_n_0,
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
barrier_request_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FF02"
    )
        port map (
      I0 => barrier_request0,
      I1 => armed_i_3_n_0,
      I2 => armed0,
      I3 => \^barrier_request_reg_0\,
      O => barrier_request_i_1_n_0
    );
barrier_request_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000001000000"
    )
        port map (
      I0 => \configured[4]_i_2_n_0\,
      I1 => \^barrier_request_reg_0\,
      I2 => data_held(1),
      I3 => data_held(2),
      I4 => \^armed_reg_0\,
      I5 => abort_requested_i_3_n_0,
      O => barrier_request0
    );
barrier_request_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => barrier_request_i_1_n_0,
      Q => \^barrier_request_reg_0\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
capture_aresetn_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^armed_reg_0\,
      I1 => s_axi_aresetn,
      O => capture_aresetn0
    );
capture_aresetn_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => common_aresetn,
      O => capture_aresetn_i_2_n_0
    );
capture_aresetn_reg: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => '1',
      CLR => capture_aresetn_i_2_n_0,
      D => capture_aresetn0,
      Q => capture_aresetn
    );
\cfg_frame_context[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(0),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(0)
    );
\cfg_frame_context[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(10),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(10)
    );
\cfg_frame_context[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(11),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(11)
    );
\cfg_frame_context[127]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000400000000"
    )
        port map (
      I0 => \cfg_frame_context[127]_i_2_n_0\,
      I1 => p_0_in(1),
      I2 => \cfg_frame_context[127]_i_3_n_0\,
      I3 => \address_held_reg_n_0_[0]\,
      I4 => \address_held_reg_n_0_[1]\,
      I5 => p_0_in(0),
      O => \cfg_frame_context[127]_i_1_n_0\
    );
\cfg_frame_context[127]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BFFFFFFFFFFFFFFF"
    )
        port map (
      I0 => owner_cpu_claim_i_5_n_0,
      I1 => strobes_held(1),
      I2 => strobes_held(3),
      I3 => strobes_held(0),
      I4 => strobes_held(2),
      I5 => s_axi_bvalid_i_4_n_0,
      O => \cfg_frame_context[127]_i_2_n_0\
    );
\cfg_frame_context[127]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFD"
    )
        port map (
      I0 => \address_held_reg_n_0_[5]\,
      I1 => \address_held_reg_n_0_[6]\,
      I2 => \address_held_reg_n_0_[4]\,
      I3 => \^armed_reg_0\,
      O => \cfg_frame_context[127]_i_3_n_0\
    );
\cfg_frame_context[128]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(0),
      O => p_2_in(128)
    );
\cfg_frame_context[129]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(1),
      O => p_2_in(129)
    );
\cfg_frame_context[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(12),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(12)
    );
\cfg_frame_context[130]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(2),
      O => p_2_in(130)
    );
\cfg_frame_context[131]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(3),
      O => p_2_in(131)
    );
\cfg_frame_context[132]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(4),
      O => p_2_in(132)
    );
\cfg_frame_context[133]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(5),
      O => p_2_in(133)
    );
\cfg_frame_context[134]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(6),
      O => p_2_in(134)
    );
\cfg_frame_context[135]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(7),
      O => p_2_in(135)
    );
\cfg_frame_context[136]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(8),
      O => p_2_in(136)
    );
\cfg_frame_context[137]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(9),
      O => p_2_in(137)
    );
\cfg_frame_context[138]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(10),
      O => p_2_in(138)
    );
\cfg_frame_context[139]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(11),
      O => p_2_in(139)
    );
\cfg_frame_context[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(13),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(13)
    );
\cfg_frame_context[140]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(12),
      O => p_2_in(140)
    );
\cfg_frame_context[141]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(13),
      O => p_2_in(141)
    );
\cfg_frame_context[142]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(14),
      O => p_2_in(142)
    );
\cfg_frame_context[143]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \cfg_frame_context[143]_i_3_n_0\,
      I1 => \s_axi_bresp[1]_i_5_n_0\,
      I2 => \address_held_reg_n_0_[5]\,
      O => \cfg_frame_context[143]_i_1_n_0\
    );
\cfg_frame_context[143]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => data_held(15),
      O => p_2_in(143)
    );
\cfg_frame_context[143]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000004"
    )
        port map (
      I0 => \address_held_reg_n_0_[6]\,
      I1 => \address_held_reg_n_0_[4]\,
      I2 => p_0_in(1),
      I3 => p_0_in(0),
      I4 => \configured[4]_i_2_n_0\,
      I5 => \^armed_reg_0\,
      O => \cfg_frame_context[143]_i_3_n_0\
    );
\cfg_frame_context[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(14),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(14)
    );
\cfg_frame_context[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(15),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(15)
    );
\cfg_frame_context[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(16),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(16)
    );
\cfg_frame_context[17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(17),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(17)
    );
\cfg_frame_context[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(18),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(18)
    );
\cfg_frame_context[19]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(19),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(19)
    );
\cfg_frame_context[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(1),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(1)
    );
\cfg_frame_context[20]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(20),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(20)
    );
\cfg_frame_context[21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(21),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(21)
    );
\cfg_frame_context[22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(22),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(22)
    );
\cfg_frame_context[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(23),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(23)
    );
\cfg_frame_context[24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(24),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(24)
    );
\cfg_frame_context[25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(25),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(25)
    );
\cfg_frame_context[26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(26),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(26)
    );
\cfg_frame_context[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(27),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(27)
    );
\cfg_frame_context[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(28),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(28)
    );
\cfg_frame_context[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(29),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(29)
    );
\cfg_frame_context[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(2),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(2)
    );
\cfg_frame_context[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(30),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(30)
    );
\cfg_frame_context[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000008"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_5_n_0\,
      I1 => \address_held_reg_n_0_[5]\,
      I2 => \address_held_reg_n_0_[6]\,
      I3 => \address_held_reg_n_0_[4]\,
      I4 => \^armed_reg_0\,
      I5 => \cfg_frame_context[31]_i_3_n_0\,
      O => \cfg_frame_context[31]_i_1_n_0\
    );
\cfg_frame_context[31]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(31),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(31)
    );
\cfg_frame_context[31]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in(1),
      I1 => p_0_in(0),
      O => \cfg_frame_context[31]_i_3_n_0\
    );
\cfg_frame_context[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(3),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(3)
    );
\cfg_frame_context[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(4),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(4)
    );
\cfg_frame_context[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(5),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(5)
    );
\cfg_frame_context[63]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000010000"
    )
        port map (
      I0 => \cfg_frame_context[127]_i_2_n_0\,
      I1 => \cfg_frame_context[127]_i_3_n_0\,
      I2 => \address_held_reg_n_0_[0]\,
      I3 => \address_held_reg_n_0_[1]\,
      I4 => p_0_in(0),
      I5 => p_0_in(1),
      O => \cfg_frame_context[63]_i_1_n_0\
    );
\cfg_frame_context[64]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(0),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(64)
    );
\cfg_frame_context[65]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(1),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(65)
    );
\cfg_frame_context[66]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(2),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(66)
    );
\cfg_frame_context[67]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(3),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(67)
    );
\cfg_frame_context[68]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(4),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(68)
    );
\cfg_frame_context[69]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(5),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(69)
    );
\cfg_frame_context[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(6),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(6)
    );
\cfg_frame_context[70]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(6),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(70)
    );
\cfg_frame_context[71]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(7),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(71)
    );
\cfg_frame_context[72]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(8),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(72)
    );
\cfg_frame_context[73]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(9),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(73)
    );
\cfg_frame_context[74]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(10),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(74)
    );
\cfg_frame_context[75]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(11),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(75)
    );
\cfg_frame_context[76]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(12),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(76)
    );
\cfg_frame_context[77]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(13),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(77)
    );
\cfg_frame_context[78]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(14),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(78)
    );
\cfg_frame_context[79]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(15),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(79)
    );
\cfg_frame_context[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(7),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(7)
    );
\cfg_frame_context[80]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(16),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(80)
    );
\cfg_frame_context[81]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(17),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(81)
    );
\cfg_frame_context[82]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(18),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(82)
    );
\cfg_frame_context[83]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(19),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(83)
    );
\cfg_frame_context[84]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(20),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(84)
    );
\cfg_frame_context[85]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(21),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(85)
    );
\cfg_frame_context[86]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(22),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(86)
    );
\cfg_frame_context[87]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(23),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(87)
    );
\cfg_frame_context[88]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(24),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(88)
    );
\cfg_frame_context[89]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(25),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(89)
    );
\cfg_frame_context[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(8),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(8)
    );
\cfg_frame_context[90]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(26),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(90)
    );
\cfg_frame_context[91]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(27),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(91)
    );
\cfg_frame_context[92]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(28),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(92)
    );
\cfg_frame_context[93]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(29),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(93)
    );
\cfg_frame_context[94]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(30),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(94)
    );
\cfg_frame_context[95]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000020"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_5_n_0\,
      I1 => \cfg_frame_context[95]_i_3_n_0\,
      I2 => \address_held_reg_n_0_[5]\,
      I3 => \address_held_reg_n_0_[6]\,
      I4 => \address_held_reg_n_0_[4]\,
      I5 => \^armed_reg_0\,
      O => \cfg_frame_context[95]_i_1_n_0\
    );
\cfg_frame_context[95]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => data_held(31),
      I1 => p_0_in(1),
      I2 => p_0_in(0),
      O => cfg_frame_context0(95)
    );
\cfg_frame_context[95]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => p_0_in(0),
      I1 => p_0_in(1),
      O => \cfg_frame_context[95]_i_3_n_0\
    );
\cfg_frame_context[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => data_held(9),
      I1 => p_0_in(0),
      I2 => p_0_in(1),
      O => cfg_frame_context0(9)
    );
\cfg_frame_context_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(0),
      Q => \^cfg_frame_context\(0),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[100]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(4),
      Q => \^cfg_frame_context\(100),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[101]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(5),
      Q => \^cfg_frame_context\(101),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[102]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(6),
      Q => \^cfg_frame_context\(102),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[103]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(7),
      Q => \^cfg_frame_context\(103),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[104]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(8),
      Q => \^cfg_frame_context\(104),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[105]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(9),
      Q => \^cfg_frame_context\(105),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[106]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(10),
      Q => \^cfg_frame_context\(106),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[107]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(11),
      Q => \^cfg_frame_context\(107),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[108]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(12),
      Q => \^cfg_frame_context\(108),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[109]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(13),
      Q => \^cfg_frame_context\(109),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(10),
      Q => \^cfg_frame_context\(10),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[110]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(14),
      Q => \^cfg_frame_context\(110),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[111]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(15),
      Q => \^cfg_frame_context\(111),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[112]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(16),
      Q => \^cfg_frame_context\(112),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[113]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(17),
      Q => \^cfg_frame_context\(113),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[114]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(18),
      Q => \^cfg_frame_context\(114),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[115]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(19),
      Q => \^cfg_frame_context\(115),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[116]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(20),
      Q => \^cfg_frame_context\(116),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[117]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(21),
      Q => \^cfg_frame_context\(117),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[118]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(22),
      Q => \^cfg_frame_context\(118),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[119]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(23),
      Q => \^cfg_frame_context\(119),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(11),
      Q => \^cfg_frame_context\(11),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[120]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(24),
      Q => \^cfg_frame_context\(120),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[121]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(25),
      Q => \^cfg_frame_context\(121),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[122]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(26),
      Q => \^cfg_frame_context\(122),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[123]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(27),
      Q => \^cfg_frame_context\(123),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[124]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(28),
      Q => \^cfg_frame_context\(124),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[125]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(29),
      Q => \^cfg_frame_context\(125),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[126]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(30),
      Q => \^cfg_frame_context\(126),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[127]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(31),
      Q => \^cfg_frame_context\(127),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[128]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(128),
      Q => \^cfg_frame_context\(128),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[129]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(129),
      Q => \^cfg_frame_context\(129),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(12),
      Q => \^cfg_frame_context\(12),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[130]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(130),
      Q => \^cfg_frame_context\(130),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[131]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(131),
      Q => \^cfg_frame_context\(131),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[132]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(132),
      Q => \^cfg_frame_context\(132),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[133]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(133),
      Q => \^cfg_frame_context\(133),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[134]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(134),
      Q => \^cfg_frame_context\(134),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[135]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(135),
      Q => \^cfg_frame_context\(135),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[136]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(136),
      Q => \^cfg_frame_context\(136),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[137]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(137),
      Q => \^cfg_frame_context\(137),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[138]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(138),
      Q => \^cfg_frame_context\(138),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[139]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(139),
      Q => \^cfg_frame_context\(139),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(13),
      Q => \^cfg_frame_context\(13),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[140]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(140),
      Q => \^cfg_frame_context\(140),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[141]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(141),
      Q => \^cfg_frame_context\(141),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[142]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(142),
      Q => \^cfg_frame_context\(142),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[143]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => p_2_in(143),
      Q => \^cfg_frame_context\(143),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(14),
      Q => \^cfg_frame_context\(14),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(15),
      Q => \^cfg_frame_context\(15),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(16),
      Q => \^cfg_frame_context\(16),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(17),
      Q => \^cfg_frame_context\(17),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(18),
      Q => \^cfg_frame_context\(18),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(19),
      Q => \^cfg_frame_context\(19),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(1),
      Q => \^cfg_frame_context\(1),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(20),
      Q => \^cfg_frame_context\(20),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(21),
      Q => \^cfg_frame_context\(21),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(22),
      Q => \^cfg_frame_context\(22),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(23),
      Q => \^cfg_frame_context\(23),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(24),
      Q => \^cfg_frame_context\(24),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(25),
      Q => \^cfg_frame_context\(25),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(26),
      Q => \^cfg_frame_context\(26),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(27),
      Q => \^cfg_frame_context\(27),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(28),
      Q => \^cfg_frame_context\(28),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(29),
      Q => \^cfg_frame_context\(29),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(2),
      Q => \^cfg_frame_context\(2),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(30),
      Q => \^cfg_frame_context\(30),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(31),
      Q => \^cfg_frame_context\(31),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[32]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(0),
      Q => \^cfg_frame_context\(32),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[33]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(1),
      Q => \^cfg_frame_context\(33),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[34]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(2),
      Q => \^cfg_frame_context\(34),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[35]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(3),
      Q => \^cfg_frame_context\(35),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[36]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(4),
      Q => \^cfg_frame_context\(36),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[37]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(5),
      Q => \^cfg_frame_context\(37),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[38]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(6),
      Q => \^cfg_frame_context\(38),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[39]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(7),
      Q => \^cfg_frame_context\(39),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(3),
      Q => \^cfg_frame_context\(3),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[40]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(8),
      Q => \^cfg_frame_context\(40),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[41]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(9),
      Q => \^cfg_frame_context\(41),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[42]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(10),
      Q => \^cfg_frame_context\(42),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[43]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(11),
      Q => \^cfg_frame_context\(43),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[44]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(12),
      Q => \^cfg_frame_context\(44),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[45]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(13),
      Q => \^cfg_frame_context\(45),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[46]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(14),
      Q => \^cfg_frame_context\(46),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[47]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(15),
      Q => \^cfg_frame_context\(47),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[48]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(16),
      Q => \^cfg_frame_context\(48),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[49]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(17),
      Q => \^cfg_frame_context\(49),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(4),
      Q => \^cfg_frame_context\(4),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[50]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(18),
      Q => \^cfg_frame_context\(50),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[51]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(19),
      Q => \^cfg_frame_context\(51),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[52]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(20),
      Q => \^cfg_frame_context\(52),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[53]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(21),
      Q => \^cfg_frame_context\(53),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[54]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(22),
      Q => \^cfg_frame_context\(54),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[55]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(23),
      Q => \^cfg_frame_context\(55),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[56]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(24),
      Q => \^cfg_frame_context\(56),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[57]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(25),
      Q => \^cfg_frame_context\(57),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[58]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(26),
      Q => \^cfg_frame_context\(58),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[59]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(27),
      Q => \^cfg_frame_context\(59),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(5),
      Q => \^cfg_frame_context\(5),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[60]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(28),
      Q => \^cfg_frame_context\(60),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[61]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(29),
      Q => \^cfg_frame_context\(61),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[62]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(30),
      Q => \^cfg_frame_context\(62),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[63]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[63]_i_1_n_0\,
      D => data_held(31),
      Q => \^cfg_frame_context\(63),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[64]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(64),
      Q => \^cfg_frame_context\(64),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[65]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(65),
      Q => \^cfg_frame_context\(65),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[66]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(66),
      Q => \^cfg_frame_context\(66),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[67]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(67),
      Q => \^cfg_frame_context\(67),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[68]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(68),
      Q => \^cfg_frame_context\(68),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[69]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(69),
      Q => \^cfg_frame_context\(69),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(6),
      Q => \^cfg_frame_context\(6),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[70]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(70),
      Q => \^cfg_frame_context\(70),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[71]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(71),
      Q => \^cfg_frame_context\(71),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[72]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(72),
      Q => \^cfg_frame_context\(72),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[73]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(73),
      Q => \^cfg_frame_context\(73),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[74]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(74),
      Q => \^cfg_frame_context\(74),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[75]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(75),
      Q => \^cfg_frame_context\(75),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[76]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(76),
      Q => \^cfg_frame_context\(76),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[77]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(77),
      Q => \^cfg_frame_context\(77),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[78]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(78),
      Q => \^cfg_frame_context\(78),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[79]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(79),
      Q => \^cfg_frame_context\(79),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(7),
      Q => \^cfg_frame_context\(7),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[80]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(80),
      Q => \^cfg_frame_context\(80),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[81]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(81),
      Q => \^cfg_frame_context\(81),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[82]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(82),
      Q => \^cfg_frame_context\(82),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[83]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(83),
      Q => \^cfg_frame_context\(83),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[84]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(84),
      Q => \^cfg_frame_context\(84),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[85]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(85),
      Q => \^cfg_frame_context\(85),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[86]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(86),
      Q => \^cfg_frame_context\(86),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[87]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(87),
      Q => \^cfg_frame_context\(87),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[88]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(88),
      Q => \^cfg_frame_context\(88),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[89]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(89),
      Q => \^cfg_frame_context\(89),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(8),
      Q => \^cfg_frame_context\(8),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[90]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(90),
      Q => \^cfg_frame_context\(90),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[91]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(91),
      Q => \^cfg_frame_context\(91),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[92]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(92),
      Q => \^cfg_frame_context\(92),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[93]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(93),
      Q => \^cfg_frame_context\(93),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[94]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(94),
      Q => \^cfg_frame_context\(94),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[95]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[95]_i_1_n_0\,
      D => cfg_frame_context0(95),
      Q => \^cfg_frame_context\(95),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[96]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(0),
      Q => \^cfg_frame_context\(96),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[97]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(1),
      Q => \^cfg_frame_context\(97),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[98]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(2),
      Q => \^cfg_frame_context\(98),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[99]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[127]_i_1_n_0\,
      D => data_held(3),
      Q => \^cfg_frame_context\(99),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\cfg_frame_context_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[31]_i_1_n_0\,
      D => cfg_frame_context0(9),
      Q => \^cfg_frame_context\(9),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\configured[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \cfg_frame_context[31]_i_1_n_0\,
      I1 => \configured_reg_n_0_[0]\,
      O => \configured[0]_i_1_n_0\
    );
\configured[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \cfg_frame_context[63]_i_1_n_0\,
      I1 => \configured_reg_n_0_[1]\,
      O => \configured[1]_i_1_n_0\
    );
\configured[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \cfg_frame_context[95]_i_1_n_0\,
      I1 => \configured_reg_n_0_[2]\,
      O => \configured[2]_i_1_n_0\
    );
\configured[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \cfg_frame_context[127]_i_1_n_0\,
      I1 => \configured_reg_n_0_[3]\,
      O => \configured[3]_i_1_n_0\
    );
\configured[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FF1F"
    )
        port map (
      I0 => \^armed_reg_0\,
      I1 => \configured[4]_i_2_n_0\,
      I2 => \address_held_reg_n_0_[4]\,
      I3 => p_0_in(1),
      O => \configured[4]_i_1_n_0\
    );
\configured[4]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \configured[4]_i_3_n_0\,
      I1 => \configured[4]_i_4_n_0\,
      I2 => \configured[4]_i_5_n_0\,
      I3 => \configured[4]_i_6_n_0\,
      O => \configured[4]_i_2_n_0\
    );
\configured[4]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => data_held(19),
      I1 => data_held(20),
      I2 => data_held(28),
      I3 => data_held(27),
      O => \configured[4]_i_3_n_0\
    );
\configured[4]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => data_held(31),
      I1 => data_held(26),
      I2 => data_held(30),
      I3 => data_held(24),
      O => \configured[4]_i_4_n_0\
    );
\configured[4]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => data_held(22),
      I1 => data_held(23),
      I2 => data_held(25),
      I3 => data_held(16),
      O => \configured[4]_i_5_n_0\
    );
\configured[4]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => data_held(18),
      I1 => data_held(21),
      I2 => data_held(29),
      I3 => data_held(17),
      O => \configured[4]_i_6_n_0\
    );
\configured_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \configured[0]_i_1_n_0\,
      Q => \configured_reg_n_0_[0]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\configured_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \configured[1]_i_1_n_0\,
      Q => \configured_reg_n_0_[1]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\configured_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \configured[2]_i_1_n_0\,
      Q => \configured_reg_n_0_[2]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\configured_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \configured[3]_i_1_n_0\,
      Q => \configured_reg_n_0_[3]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\configured_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \cfg_frame_context[143]_i_1_n_0\,
      D => \configured[4]_i_1_n_0\,
      Q => \configured_reg_n_0_[4]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0002"
    )
        port map (
      I0 => s_axi_wvalid,
      I1 => \^s_axi_bvalid_reg_0\,
      I2 => owner_command_pending_reg_n_0,
      I3 => w_held_reg_n_0,
      O => w_held0
    );
\data_held_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(0),
      Q => data_held(0),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(10),
      Q => data_held(10),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(11),
      Q => data_held(11),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(12),
      Q => data_held(12),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(13),
      Q => data_held(13),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(14),
      Q => data_held(14),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(15),
      Q => data_held(15),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(16),
      Q => data_held(16),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(17),
      Q => data_held(17),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(18),
      Q => data_held(18),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(19),
      Q => data_held(19),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(1),
      Q => data_held(1),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(20),
      Q => data_held(20),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(21),
      Q => data_held(21),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(22),
      Q => data_held(22),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(23),
      Q => data_held(23),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(24),
      Q => data_held(24),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(25),
      Q => data_held(25),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(26),
      Q => data_held(26),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(27),
      Q => data_held(27),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(28),
      Q => data_held(28),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(29),
      Q => data_held(29),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(2),
      Q => data_held(2),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(30),
      Q => data_held(30),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(31),
      Q => data_held(31),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(3),
      Q => data_held(3),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(4),
      Q => data_held(4),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(5),
      Q => data_held(5),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(6),
      Q => data_held(6),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(7),
      Q => data_held(7),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(8),
      Q => data_held(8),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\data_held_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wdata(9),
      Q => data_held(9),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
owner_command_fault_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF44404040"
    )
        port map (
      I0 => owner_command_fault_i_2_n_0,
      I1 => owner_command_pending_reg_n_0,
      I2 => owner_fault,
      I3 => \owner_command_wait_reg_n_0_[1]\,
      I4 => \owner_command_wait_reg_n_0_[0]\,
      I5 => \^owner_command_fault_reg_0\,
      O => owner_command_fault_i_1_n_0
    );
owner_command_fault_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"00E2"
    )
        port map (
      I0 => owner_claim_accepted,
      I1 => owner_command_is_release_reg_n_0,
      I2 => owner_release_accepted,
      I3 => owner_fault,
      O => owner_command_fault_i_2_n_0
    );
owner_command_fault_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => owner_command_fault_i_1_n_0,
      Q => \^owner_command_fault_reg_0\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
owner_command_is_release_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => abort_requested2,
      I1 => owner_command_pending18_out,
      I2 => owner_command_is_release_reg_n_0,
      O => owner_command_is_release_i_1_n_0
    );
owner_command_is_release_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => owner_command_is_release_i_1_n_0,
      Q => owner_command_is_release_reg_n_0,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
owner_command_pending_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BA88"
    )
        port map (
      I0 => owner_command_pending18_out,
      I1 => \owner_command_wait[1]_i_2_n_0\,
      I2 => s_axi_bvalid_i_3_n_0,
      I3 => owner_command_pending_reg_n_0,
      O => owner_command_pending_i_1_n_0
    );
owner_command_pending_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => owner_command_pending_i_1_n_0,
      Q => owner_command_pending_reg_n_0,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_command_wait[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FF00FD22"
    )
        port map (
      I0 => owner_command_pending_reg_n_0,
      I1 => owner_fault,
      I2 => \owner_command_wait_reg_n_0_[1]\,
      I3 => \owner_command_wait_reg_n_0_[0]\,
      I4 => owner_command_fault_i_2_n_0,
      I5 => \owner_command_wait[1]_i_2_n_0\,
      O => \owner_command_wait[0]_i_1_n_0\
    );
\owner_command_wait[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000F0F0F2F0"
    )
        port map (
      I0 => owner_command_pending_reg_n_0,
      I1 => owner_fault,
      I2 => \owner_command_wait_reg_n_0_[1]\,
      I3 => \owner_command_wait_reg_n_0_[0]\,
      I4 => owner_command_fault_i_2_n_0,
      I5 => \owner_command_wait[1]_i_2_n_0\,
      O => \owner_command_wait[1]_i_1_n_0\
    );
\owner_command_wait[1]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0054"
    )
        port map (
      I0 => owner_cpu_claim_i_2_n_0,
      I1 => abort_requested2,
      I2 => owner_cpu_claim_i_3_n_0,
      I3 => \owner_command_wait[1]_i_3_n_0\,
      O => \owner_command_wait[1]_i_2_n_0\
    );
\owner_command_wait[1]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFEEEFEF"
    )
        port map (
      I0 => \cfg_frame_context[127]_i_2_n_0\,
      I1 => \owner_command_wait[1]_i_4_n_0\,
      I2 => \address_held_reg_n_0_[0]\,
      I3 => \address_held_reg_n_0_[4]\,
      I4 => \address_held_reg_n_0_[6]\,
      O => \owner_command_wait[1]_i_3_n_0\
    );
\owner_command_wait[1]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFEFFFFFFFF"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => \address_held_reg_n_0_[0]\,
      I2 => \address_held_reg_n_0_[1]\,
      I3 => \address_held_reg_n_0_[5]\,
      I4 => p_0_in(0),
      I5 => p_0_in(1),
      O => \owner_command_wait[1]_i_4_n_0\
    );
\owner_command_wait_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \owner_command_wait[0]_i_1_n_0\,
      Q => \owner_command_wait_reg_n_0_[0]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_command_wait_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \owner_command_wait[1]_i_1_n_0\,
      Q => \owner_command_wait_reg_n_0_[1]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
owner_cpu_claim_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000004"
    )
        port map (
      I0 => owner_cpu_claim_i_2_n_0,
      I1 => owner_cpu_claim_i_3_n_0,
      I2 => owner_cpu_claim_i_4_n_0,
      I3 => owner_cpu_claim_i_5_n_0,
      I4 => owner_cpu_claim_i_6_n_0,
      O => owner_cpu_claim_i_1_n_0
    );
owner_cpu_claim_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FDFFFFFFFFFFFFFF"
    )
        port map (
      I0 => \^armed_reg_0\,
      I1 => \^owner_command_fault_reg_0\,
      I2 => owner_fault,
      I3 => p_0_in(1),
      I4 => \owner_token_configured_reg_n_0_[1]\,
      I5 => \owner_token_configured_reg_n_0_[0]\,
      O => owner_cpu_claim_i_2_n_0
    );
owner_cpu_claim_i_3: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => \configured[4]_i_2_n_0\,
      I1 => owner_cpu_claim_i_7_n_0,
      I2 => owner_cpu_claim_i_8_n_0,
      O => owner_cpu_claim_i_3_n_0
    );
owner_cpu_claim_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFB"
    )
        port map (
      I0 => \address_held_reg_n_0_[4]\,
      I1 => \address_held_reg_n_0_[6]\,
      I2 => \address_held_reg_n_0_[0]\,
      I3 => \address_held_reg_n_0_[1]\,
      I4 => p_0_in(0),
      I5 => \address_held_reg_n_0_[5]\,
      O => owner_cpu_claim_i_4_n_0
    );
owner_cpu_claim_i_5: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \address_held_reg_n_0_[7]\,
      I1 => \address_held_reg_n_0_[8]\,
      I2 => \address_held_reg_n_0_[11]\,
      I3 => \address_held_reg_n_0_[9]\,
      I4 => \address_held_reg_n_0_[10]\,
      O => owner_cpu_claim_i_5_n_0
    );
owner_cpu_claim_i_6: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFFFFFFFFFF"
    )
        port map (
      I0 => strobes_held(1),
      I1 => strobes_held(3),
      I2 => strobes_held(0),
      I3 => strobes_held(2),
      I4 => s_axi_bvalid_i_4_n_0,
      I5 => s_axi_aresetn,
      O => owner_cpu_claim_i_6_n_0
    );
owner_cpu_claim_i_7: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFEF"
    )
        port map (
      I0 => owner_cpu_claim_i_9_n_0,
      I1 => data_held(1),
      I2 => data_held(0),
      I3 => data_held(3),
      I4 => data_held(2),
      O => owner_cpu_claim_i_7_n_0
    );
owner_cpu_claim_i_8: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => data_held(12),
      I1 => data_held(14),
      I2 => data_held(9),
      I3 => data_held(13),
      I4 => abort_requested_i_4_n_0,
      O => owner_cpu_claim_i_8_n_0
    );
owner_cpu_claim_i_9: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => data_held(6),
      I1 => data_held(5),
      I2 => data_held(7),
      I3 => data_held(4),
      O => owner_cpu_claim_i_9_n_0
    );
owner_cpu_claim_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => owner_cpu_claim_i_1_n_0,
      Q => owner_cpu_claim,
      R => '0'
    );
\owner_cpu_epoch[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => \owner_cpu_epoch[31]_i_2_n_0\,
      I1 => \owner_cpu_epoch[31]_i_3_n_0\,
      I2 => \address_held_reg_n_0_[10]\,
      I3 => \address_held_reg_n_0_[9]\,
      I4 => \address_held_reg_n_0_[11]\,
      I5 => \address_held_reg_n_0_[8]\,
      O => \owner_cpu_epoch[31]_i_1_n_0\
    );
\owner_cpu_epoch[31]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFEFFFFFFFFFF"
    )
        port map (
      I0 => \address_held_reg_n_0_[5]\,
      I1 => p_0_in(1),
      I2 => \address_held_reg_n_0_[4]\,
      I3 => \address_held_reg_n_0_[6]\,
      I4 => \owner_token_configured[1]_i_3_n_0\,
      I5 => \s_axi_bresp[1]_i_5_n_0\,
      O => \owner_cpu_epoch[31]_i_2_n_0\
    );
\owner_cpu_epoch[31]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \address_held_reg_n_0_[5]\,
      I1 => \address_held_reg_n_0_[7]\,
      I2 => \address_held_reg_n_0_[4]\,
      I3 => \address_held_reg_n_0_[0]\,
      I4 => \cfg_frame_context[31]_i_3_n_0\,
      I5 => \owner_cpu_epoch[31]_i_4_n_0\,
      O => \owner_cpu_epoch[31]_i_3_n_0\
    );
\owner_cpu_epoch[31]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => \address_held_reg_n_0_[1]\,
      I1 => \address_held_reg_n_0_[6]\,
      O => \owner_cpu_epoch[31]_i_4_n_0\
    );
\owner_cpu_epoch_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(0),
      Q => \^owner_cpu_epoch\(0),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(10),
      Q => \^owner_cpu_epoch\(10),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(11),
      Q => \^owner_cpu_epoch\(11),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(12),
      Q => \^owner_cpu_epoch\(12),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(13),
      Q => \^owner_cpu_epoch\(13),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(14),
      Q => \^owner_cpu_epoch\(14),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(15),
      Q => \^owner_cpu_epoch\(15),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(16),
      Q => \^owner_cpu_epoch\(16),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(17),
      Q => \^owner_cpu_epoch\(17),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(18),
      Q => \^owner_cpu_epoch\(18),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(19),
      Q => \^owner_cpu_epoch\(19),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(1),
      Q => \^owner_cpu_epoch\(1),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(20),
      Q => \^owner_cpu_epoch\(20),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(21),
      Q => \^owner_cpu_epoch\(21),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(22),
      Q => \^owner_cpu_epoch\(22),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(23),
      Q => \^owner_cpu_epoch\(23),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(24),
      Q => \^owner_cpu_epoch\(24),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(25),
      Q => \^owner_cpu_epoch\(25),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(26),
      Q => \^owner_cpu_epoch\(26),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(27),
      Q => \^owner_cpu_epoch\(27),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(28),
      Q => \^owner_cpu_epoch\(28),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(29),
      Q => \^owner_cpu_epoch\(29),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(2),
      Q => \^owner_cpu_epoch\(2),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(30),
      Q => \^owner_cpu_epoch\(30),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(31),
      Q => \^owner_cpu_epoch\(31),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(3),
      Q => \^owner_cpu_epoch\(3),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(4),
      Q => \^owner_cpu_epoch\(4),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(5),
      Q => \^owner_cpu_epoch\(5),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(6),
      Q => \^owner_cpu_epoch\(6),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(7),
      Q => \^owner_cpu_epoch\(7),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(8),
      Q => \^owner_cpu_epoch\(8),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_epoch_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_epoch[31]_i_1_n_0\,
      D => data_held(9),
      Q => \^owner_cpu_epoch\(9),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id[31]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => p_0_in(0),
      I1 => \owner_cpu_epoch[31]_i_2_n_0\,
      O => \owner_cpu_frame_id[31]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(0),
      Q => \^owner_cpu_frame_id\(0),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(10),
      Q => \^owner_cpu_frame_id\(10),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(11),
      Q => \^owner_cpu_frame_id\(11),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(12),
      Q => \^owner_cpu_frame_id\(12),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(13),
      Q => \^owner_cpu_frame_id\(13),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(14),
      Q => \^owner_cpu_frame_id\(14),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(15),
      Q => \^owner_cpu_frame_id\(15),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(16),
      Q => \^owner_cpu_frame_id\(16),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(17),
      Q => \^owner_cpu_frame_id\(17),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(18),
      Q => \^owner_cpu_frame_id\(18),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(19),
      Q => \^owner_cpu_frame_id\(19),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(1),
      Q => \^owner_cpu_frame_id\(1),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(20),
      Q => \^owner_cpu_frame_id\(20),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(21),
      Q => \^owner_cpu_frame_id\(21),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(22),
      Q => \^owner_cpu_frame_id\(22),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(23),
      Q => \^owner_cpu_frame_id\(23),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(24),
      Q => \^owner_cpu_frame_id\(24),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(25),
      Q => \^owner_cpu_frame_id\(25),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(26),
      Q => \^owner_cpu_frame_id\(26),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(27),
      Q => \^owner_cpu_frame_id\(27),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(28),
      Q => \^owner_cpu_frame_id\(28),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(29),
      Q => \^owner_cpu_frame_id\(29),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(2),
      Q => \^owner_cpu_frame_id\(2),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(30),
      Q => \^owner_cpu_frame_id\(30),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(31),
      Q => \^owner_cpu_frame_id\(31),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(3),
      Q => \^owner_cpu_frame_id\(3),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(4),
      Q => \^owner_cpu_frame_id\(4),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(5),
      Q => \^owner_cpu_frame_id\(5),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(6),
      Q => \^owner_cpu_frame_id\(6),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(7),
      Q => \^owner_cpu_frame_id\(7),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(8),
      Q => \^owner_cpu_frame_id\(8),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_cpu_frame_id_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \owner_cpu_frame_id[31]_i_1_n_0\,
      D => data_held(9),
      Q => \^owner_cpu_frame_id\(9),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
owner_cpu_release_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000004"
    )
        port map (
      I0 => owner_cpu_claim_i_2_n_0,
      I1 => abort_requested2,
      I2 => owner_cpu_claim_i_4_n_0,
      I3 => owner_cpu_claim_i_5_n_0,
      I4 => owner_cpu_claim_i_6_n_0,
      O => owner_cpu_release_i_1_n_0
    );
owner_cpu_release_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => owner_cpu_release_i_1_n_0,
      Q => owner_cpu_release,
      R => '0'
    );
\owner_status_held[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \^owner_command_fault_reg_0\,
      I1 => owner_fault,
      O => p_0_out(3)
    );
\owner_status_held[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000010000"
    )
        port map (
      I0 => \owner_status_held[6]_i_2_n_0\,
      I1 => \owner_status_held[6]_i_3_n_0\,
      I2 => s_axi_araddr(5),
      I3 => s_axi_araddr(4),
      I4 => \owner_status_held[6]_i_4_n_0\,
      I5 => \owner_status_held[6]_i_5_n_0\,
      O => owner_status_pending3_out
    );
\owner_status_held[6]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFB"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_4_n_0\,
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      O => \owner_status_held[6]_i_2_n_0\
    );
\owner_status_held[6]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(3),
      O => \owner_status_held[6]_i_3_n_0\
    );
\owner_status_held[6]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000002"
    )
        port map (
      I0 => owner_status_pending1,
      I1 => s_axi_araddr(7),
      I2 => s_axi_araddr(11),
      I3 => s_axi_araddr(8),
      I4 => s_axi_araddr(9),
      I5 => s_axi_araddr(10),
      O => \owner_status_held[6]_i_4_n_0\
    );
\owner_status_held[6]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FEFEFEFEFEEFEEEE"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(1),
      I2 => s_axi_araddr(5),
      I3 => s_axi_araddr(2),
      I4 => s_axi_araddr(3),
      I5 => s_axi_araddr(4),
      O => \owner_status_held[6]_i_5_n_0\
    );
\owner_status_held_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => owner_status_pending3_out,
      D => D(0),
      Q => \owner_status_held_reg_n_0_[0]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_status_held_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => owner_status_pending3_out,
      D => D(1),
      Q => \owner_status_held_reg_n_0_[1]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_status_held_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => owner_status_pending3_out,
      D => D(2),
      Q => \owner_status_held_reg_n_0_[2]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_status_held_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => owner_status_pending3_out,
      D => p_0_out(3),
      Q => \owner_status_held_reg_n_0_[3]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_status_held_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => owner_status_pending3_out,
      D => owner_command_pending_reg_n_0,
      Q => \owner_status_held_reg_n_0_[4]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_status_held_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => owner_status_pending3_out,
      D => \owner_token_configured_reg_n_0_[0]\,
      Q => \owner_status_held_reg_n_0_[5]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_status_held_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => owner_status_pending3_out,
      D => \owner_token_configured_reg_n_0_[1]\,
      Q => \owner_status_held_reg_n_0_[6]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
owner_status_pending_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000010000"
    )
        port map (
      I0 => \owner_status_held[6]_i_2_n_0\,
      I1 => \owner_status_held[6]_i_3_n_0\,
      I2 => s_axi_araddr(5),
      I3 => s_axi_araddr(4),
      I4 => \owner_status_held[6]_i_4_n_0\,
      I5 => \owner_status_held[6]_i_5_n_0\,
      O => owner_status_pending_i_1_n_0
    );
owner_status_pending_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => owner_status_pending_i_1_n_0,
      Q => owner_status_pending_reg_n_0,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_token_configured[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3735373704050404"
    )
        port map (
      I0 => \owner_cpu_epoch[31]_i_2_n_0\,
      I1 => \owner_token_configured[1]_i_2_n_0\,
      I2 => p_0_in(0),
      I3 => \owner_token_configured[1]_i_3_n_0\,
      I4 => \owner_token_configured[1]_i_4_n_0\,
      I5 => \owner_token_configured_reg_n_0_[0]\,
      O => \owner_token_configured[0]_i_1_n_0\
    );
\owner_token_configured[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7533773345004400"
    )
        port map (
      I0 => \owner_cpu_epoch[31]_i_2_n_0\,
      I1 => \owner_token_configured[1]_i_2_n_0\,
      I2 => \owner_token_configured[1]_i_3_n_0\,
      I3 => p_0_in(0),
      I4 => \owner_token_configured[1]_i_4_n_0\,
      I5 => \owner_token_configured_reg_n_0_[1]\,
      O => \owner_token_configured[1]_i_1_n_0\
    );
\owner_token_configured[1]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"45400000"
    )
        port map (
      I0 => owner_fault,
      I1 => owner_release_accepted,
      I2 => owner_command_is_release_reg_n_0,
      I3 => owner_claim_accepted,
      I4 => owner_command_pending_reg_n_0,
      O => \owner_token_configured[1]_i_2_n_0\
    );
\owner_token_configured[1]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"EF"
    )
        port map (
      I0 => owner_fault,
      I1 => \^owner_command_fault_reg_0\,
      I2 => \^armed_reg_0\,
      O => \owner_token_configured[1]_i_3_n_0\
    );
\owner_token_configured[1]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000202200000000"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_5_n_0\,
      I1 => \owner_token_configured[1]_i_5_n_0\,
      I2 => \address_held_reg_n_0_[0]\,
      I3 => \address_held_reg_n_0_[4]\,
      I4 => \address_held_reg_n_0_[1]\,
      I5 => \address_held_reg_n_0_[6]\,
      O => \owner_token_configured[1]_i_4_n_0\
    );
\owner_token_configured[1]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in(1),
      I1 => \address_held_reg_n_0_[5]\,
      O => \owner_token_configured[1]_i_5_n_0\
    );
\owner_token_configured_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \owner_token_configured[0]_i_1_n_0\,
      Q => \owner_token_configured_reg_n_0_[0]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\owner_token_configured_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \owner_token_configured[1]_i_1_n_0\,
      Q => \owner_token_configured_reg_n_0_[1]\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
s_axi_arready_INST_0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"04"
    )
        port map (
      I0 => owner_status_pending_reg_n_0,
      I1 => s_axi_aresetn,
      I2 => \^s_axi_rvalid_reg_0\,
      O => s_axi_arready
    );
s_axi_awready_INST_0: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0010"
    )
        port map (
      I0 => aw_held,
      I1 => owner_command_pending_reg_n_0,
      I2 => s_axi_aresetn,
      I3 => \^s_axi_bvalid_reg_0\,
      O => s_axi_awready
    );
\s_axi_bresp[1]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s_axi_aresetn,
      O => \s_axi_bresp[1]_i_1_n_0\
    );
\s_axi_bresp[1]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0010FFFF00100010"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_12_n_0\,
      I1 => \s_axi_bresp[1]_i_13_n_0\,
      I2 => \s_axi_bresp[1]_i_14_n_0\,
      I3 => \s_axi_bresp[1]_i_15_n_0\,
      I4 => \s_axi_bresp[1]_i_16_n_0\,
      I5 => \s_axi_bresp[1]_i_17_n_0\,
      O => \s_axi_bresp[1]_i_10_n_0\
    );
\s_axi_bresp[1]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFA8FFFF"
    )
        port map (
      I0 => \address_held_reg_n_0_[5]\,
      I1 => \^armed_reg_0\,
      I2 => \configured[4]_i_2_n_0\,
      I3 => \cfg_frame_context[31]_i_3_n_0\,
      I4 => \address_held_reg_n_0_[4]\,
      I5 => \address_held_reg_n_0_[6]\,
      O => \s_axi_bresp[1]_i_11_n_0\
    );
\s_axi_bresp[1]_i_12\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(48),
      I1 => \^cfg_frame_context\(51),
      I2 => \^cfg_frame_context\(49),
      I3 => \^cfg_frame_context\(50),
      I4 => armed_i_13_n_0,
      O => \s_axi_bresp[1]_i_12_n_0\
    );
\s_axi_bresp[1]_i_13\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(56),
      I1 => \^cfg_frame_context\(57),
      I2 => \^cfg_frame_context\(58),
      I3 => \^cfg_frame_context\(59),
      I4 => \s_axi_bresp[1]_i_18_n_0\,
      O => \s_axi_bresp[1]_i_13_n_0\
    );
\s_axi_bresp[1]_i_14\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => \^cfg_frame_context\(64),
      I1 => \^cfg_frame_context\(65),
      I2 => \^cfg_frame_context\(66),
      I3 => \^cfg_frame_context\(67),
      I4 => armed_i_12_n_0,
      O => \s_axi_bresp[1]_i_14_n_0\
    );
\s_axi_bresp[1]_i_15\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(72),
      I1 => \^cfg_frame_context\(73),
      I2 => \^cfg_frame_context\(74),
      I3 => \^cfg_frame_context\(75),
      I4 => \s_axi_bresp[1]_i_19_n_0\,
      O => \s_axi_bresp[1]_i_15_n_0\
    );
\s_axi_bresp[1]_i_16\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_20_n_0\,
      I1 => \s_axi_bresp[1]_i_21_n_0\,
      I2 => \s_axi_bresp[1]_i_22_n_0\,
      I3 => \s_axi_bresp[1]_i_23_n_0\,
      O => \s_axi_bresp[1]_i_16_n_0\
    );
\s_axi_bresp[1]_i_17\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0004"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_24_n_0\,
      I1 => \s_axi_bresp[1]_i_25_n_0\,
      I2 => \s_axi_bresp[1]_i_26_n_0\,
      I3 => \s_axi_bresp[1]_i_27_n_0\,
      O => \s_axi_bresp[1]_i_17_n_0\
    );
\s_axi_bresp[1]_i_18\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(61),
      I1 => \^cfg_frame_context\(60),
      I2 => \^cfg_frame_context\(63),
      I3 => \^cfg_frame_context\(62),
      O => \s_axi_bresp[1]_i_18_n_0\
    );
\s_axi_bresp[1]_i_19\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(77),
      I1 => \^cfg_frame_context\(76),
      I2 => \^cfg_frame_context\(78),
      I3 => \^cfg_frame_context\(79),
      O => \s_axi_bresp[1]_i_19_n_0\
    );
\s_axi_bresp[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"004FFFFF004F0000"
    )
        port map (
      I0 => \s_axi_bresp[1]_i_3_n_0\,
      I1 => \s_axi_bresp[1]_i_4_n_0\,
      I2 => \s_axi_bresp[1]_i_5_n_0\,
      I3 => \s_axi_bresp[1]_i_6_n_0\,
      I4 => \s_axi_bresp[1]_i_7_n_0\,
      I5 => \^s_axi_bresp\(0),
      O => \s_axi_bresp[1]_i_2_n_0\
    );
\s_axi_bresp[1]_i_20\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(143),
      I1 => \^cfg_frame_context\(141),
      I2 => \^cfg_frame_context\(142),
      I3 => \^cfg_frame_context\(140),
      O => \s_axi_bresp[1]_i_20_n_0\
    );
\s_axi_bresp[1]_i_21\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(137),
      I1 => \^cfg_frame_context\(136),
      I2 => \^cfg_frame_context\(139),
      I3 => \^cfg_frame_context\(138),
      O => \s_axi_bresp[1]_i_21_n_0\
    );
\s_axi_bresp[1]_i_22\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(133),
      I1 => \^cfg_frame_context\(132),
      I2 => \^cfg_frame_context\(135),
      I3 => \^cfg_frame_context\(134),
      O => \s_axi_bresp[1]_i_22_n_0\
    );
\s_axi_bresp[1]_i_23\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(131),
      I1 => \^cfg_frame_context\(128),
      I2 => \^cfg_frame_context\(130),
      I3 => \^cfg_frame_context\(129),
      O => \s_axi_bresp[1]_i_23_n_0\
    );
\s_axi_bresp[1]_i_24\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(125),
      I1 => \^cfg_frame_context\(124),
      I2 => \^cfg_frame_context\(127),
      I3 => \^cfg_frame_context\(126),
      O => \s_axi_bresp[1]_i_24_n_0\
    );
\s_axi_bresp[1]_i_25\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => \^cfg_frame_context\(123),
      I1 => \^cfg_frame_context\(120),
      I2 => \^cfg_frame_context\(122),
      I3 => \^cfg_frame_context\(121),
      O => \s_axi_bresp[1]_i_25_n_0\
    );
\s_axi_bresp[1]_i_26\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(119),
      I1 => \^cfg_frame_context\(118),
      I2 => \^cfg_frame_context\(117),
      I3 => \^cfg_frame_context\(116),
      O => \s_axi_bresp[1]_i_26_n_0\
    );
\s_axi_bresp[1]_i_27\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^cfg_frame_context\(115),
      I1 => \^cfg_frame_context\(114),
      I2 => \^cfg_frame_context\(113),
      I3 => \^cfg_frame_context\(112),
      O => \s_axi_bresp[1]_i_27_n_0\
    );
\s_axi_bresp[1]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000F00110000"
    )
        port map (
      I0 => p_0_in(1),
      I1 => \owner_token_configured[1]_i_3_n_0\,
      I2 => \^armed_reg_0\,
      I3 => \address_held_reg_n_0_[4]\,
      I4 => \address_held_reg_n_0_[6]\,
      I5 => \address_held_reg_n_0_[5]\,
      O => \s_axi_bresp[1]_i_3_n_0\
    );
\s_axi_bresp[1]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF01010001"
    )
        port map (
      I0 => abort_requested0,
      I1 => barrier_request0,
      I2 => \address_held_reg_n_0_[5]\,
      I3 => \s_axi_bresp[1]_i_9_n_0\,
      I4 => \s_axi_bresp[1]_i_10_n_0\,
      I5 => \s_axi_bresp[1]_i_11_n_0\,
      O => \s_axi_bresp[1]_i_4_n_0\
    );
\s_axi_bresp[1]_i_5\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => \address_held_reg_n_0_[1]\,
      I1 => \address_held_reg_n_0_[0]\,
      I2 => \cfg_frame_context[127]_i_2_n_0\,
      O => \s_axi_bresp[1]_i_5_n_0\
    );
\s_axi_bresp[1]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00004540"
    )
        port map (
      I0 => owner_fault,
      I1 => owner_release_accepted,
      I2 => owner_command_is_release_reg_n_0,
      I3 => owner_claim_accepted,
      I4 => s_axi_bvalid_i_4_n_0,
      O => \s_axi_bresp[1]_i_6_n_0\
    );
\s_axi_bresp[1]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"08FF0808"
    )
        port map (
      I0 => w_held_reg_n_0,
      I1 => aw_held,
      I2 => \^s_axi_bvalid_reg_0\,
      I3 => s_axi_bvalid_i_3_n_0,
      I4 => owner_command_pending_reg_n_0,
      O => \s_axi_bresp[1]_i_7_n_0\
    );
\s_axi_bresp[1]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000040000"
    )
        port map (
      I0 => abort_requested_i_3_n_0,
      I1 => data_held(1),
      I2 => data_held(2),
      I3 => \configured[4]_i_2_n_0\,
      I4 => \^armed_reg_0\,
      I5 => \^abort_requested_reg_0\,
      O => abort_requested0
    );
\s_axi_bresp[1]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => owner_cpu_claim_i_8_n_0,
      I1 => owner_cpu_claim_i_7_n_0,
      I2 => \configured[4]_i_2_n_0\,
      I3 => armed_i_4_n_0,
      O => \s_axi_bresp[1]_i_9_n_0\
    );
\s_axi_bresp_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \s_axi_bresp[1]_i_2_n_0\,
      Q => \^s_axi_bresp\(0),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
s_axi_bvalid_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555555530301530"
    )
        port map (
      I0 => owner_command_pending18_out,
      I1 => s_axi_bready,
      I2 => \^s_axi_bvalid_reg_0\,
      I3 => owner_command_pending_reg_n_0,
      I4 => s_axi_bvalid_i_3_n_0,
      I5 => s_axi_bvalid_i_4_n_0,
      O => s_axi_bvalid_i_1_n_0
    );
s_axi_bvalid_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000054"
    )
        port map (
      I0 => owner_cpu_claim_i_4_n_0,
      I1 => owner_cpu_claim_i_3_n_0,
      I2 => abort_requested2,
      I3 => owner_cpu_claim_i_2_n_0,
      I4 => \cfg_frame_context[127]_i_2_n_0\,
      O => owner_command_pending18_out
    );
s_axi_bvalid_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0007000000070707"
    )
        port map (
      I0 => \owner_command_wait_reg_n_0_[1]\,
      I1 => \owner_command_wait_reg_n_0_[0]\,
      I2 => owner_fault,
      I3 => owner_release_accepted,
      I4 => owner_command_is_release_reg_n_0,
      I5 => owner_claim_accepted,
      O => s_axi_bvalid_i_3_n_0
    );
s_axi_bvalid_i_4: unisim.vcomponents.LUT3
    generic map(
      INIT => X"40"
    )
        port map (
      I0 => \^s_axi_bvalid_reg_0\,
      I1 => aw_held,
      I2 => w_held_reg_n_0,
      O => s_axi_bvalid_i_4_n_0
    );
s_axi_bvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => s_axi_bvalid_i_1_n_0,
      Q => \^s_axi_bvalid_reg_0\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\s_axi_rdata[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FEFEFEEEFEFEFEFE"
    )
        port map (
      I0 => \s_axi_rdata[0]_i_2_n_0\,
      I1 => \s_axi_rdata[0]_i_3_n_0\,
      I2 => \owner_status_held_reg_n_0_[0]\,
      I3 => \^s_axi_rvalid_reg_0\,
      I4 => \s_axi_rdata[31]_i_1_n_0\,
      I5 => s_axi_arvalid,
      O => \s_axi_rdata[0]_i_1_n_0\
    );
\s_axi_rdata[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8888888A888"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_6_n_0\,
      I1 => \s_axi_rdata[0]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \^cfg_frame_context\(128),
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[0]_i_5_n_0\,
      O => \s_axi_rdata[0]_i_2_n_0\
    );
\s_axi_rdata[0]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"1010100000001000"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[4]_i_4_n_0\,
      I2 => \owner_status_held[6]_i_4_n_0\,
      I3 => \configured_reg_n_0_[0]\,
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \^armed_reg_0\,
      O => \s_axi_rdata[0]_i_3_n_0\
    );
\s_axi_rdata[0]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000F4000000"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[0]_i_6_n_0\,
      I3 => \s_axi_rdata[31]_i_5_n_0\,
      I4 => \s_axi_rdata[0]_i_7_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[0]_i_4_n_0\
    );
\s_axi_rdata[0]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFAACCF000AACCF0"
    )
        port map (
      I0 => \^cfg_frame_context\(32),
      I1 => \^cfg_frame_context\(64),
      I2 => \^cfg_frame_context\(0),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(96),
      O => \s_axi_rdata[0]_i_5_n_0\
    );
\s_axi_rdata[0]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[0]_i_8_n_0\,
      I1 => \^owner_cpu_epoch\(0),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(0),
      O => \s_axi_rdata[0]_i_6_n_0\
    );
\s_axi_rdata[0]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F3F3FFFFFBFBFFF3"
    )
        port map (
      I0 => owner_fault_causes(0),
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(0),
      I3 => owner_released_frames(0),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(3),
      O => \s_axi_rdata[0]_i_7_n_0\
    );
\s_axi_rdata[0]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(0),
      I1 => owner_slot(0),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(0),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(0),
      O => \s_axi_rdata[0]_i_8_n_0\
    );
\s_axi_rdata[10]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBAA"
    )
        port map (
      I0 => \s_axi_rdata[29]_i_2_n_0\,
      I1 => \s_axi_rdata[10]_i_2_n_0\,
      I2 => \s_axi_rdata[10]_i_3_n_0\,
      I3 => \s_axi_rdata[31]_i_6_n_0\,
      O => \s_axi_rdata[10]_i_1_n_0\
    );
\s_axi_rdata[10]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"57F7"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \^cfg_frame_context\(138),
      I2 => \s_axi_rdata[31]_i_5_n_0\,
      I3 => \s_axi_rdata[10]_i_4_n_0\,
      O => \s_axi_rdata[10]_i_2_n_0\
    );
\s_axi_rdata[10]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[10]_i_5_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(10),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[10]_i_3_n_0\
    );
\s_axi_rdata[10]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFAACCF000AACCF0"
    )
        port map (
      I0 => \^cfg_frame_context\(42),
      I1 => \^cfg_frame_context\(74),
      I2 => \^cfg_frame_context\(10),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(106),
      O => \s_axi_rdata[10]_i_4_n_0\
    );
\s_axi_rdata[10]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[10]_i_6_n_0\,
      I1 => \^owner_cpu_epoch\(10),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(10),
      O => \s_axi_rdata[10]_i_5_n_0\
    );
\s_axi_rdata[10]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(10),
      I1 => owner_slot(10),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(10),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(10),
      O => \s_axi_rdata[10]_i_6_n_0\
    );
\s_axi_rdata[11]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8888888A888"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_6_n_0\,
      I1 => \s_axi_rdata[11]_i_2_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \^cfg_frame_context\(139),
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[11]_i_3_n_0\,
      O => \s_axi_rdata[11]_i_1_n_0\
    );
\s_axi_rdata[11]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[11]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(11),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[11]_i_2_n_0\
    );
\s_axi_rdata[11]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCAAFFF0CCAA00F0"
    )
        port map (
      I0 => \^cfg_frame_context\(43),
      I1 => \^cfg_frame_context\(107),
      I2 => \^cfg_frame_context\(11),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(75),
      O => \s_axi_rdata[11]_i_3_n_0\
    );
\s_axi_rdata[11]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[11]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(11),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(11),
      O => \s_axi_rdata[11]_i_4_n_0\
    );
\s_axi_rdata[11]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(11),
      I1 => owner_slot(11),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(11),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(11),
      O => \s_axi_rdata[11]_i_5_n_0\
    );
\s_axi_rdata[12]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FBAA"
    )
        port map (
      I0 => \s_axi_rdata[29]_i_2_n_0\,
      I1 => \s_axi_rdata[12]_i_2_n_0\,
      I2 => \s_axi_rdata[12]_i_3_n_0\,
      I3 => \s_axi_rdata[31]_i_6_n_0\,
      O => \s_axi_rdata[12]_i_1_n_0\
    );
\s_axi_rdata[12]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"57F7"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \^cfg_frame_context\(140),
      I2 => \s_axi_rdata[31]_i_5_n_0\,
      I3 => \s_axi_rdata[12]_i_4_n_0\,
      O => \s_axi_rdata[12]_i_2_n_0\
    );
\s_axi_rdata[12]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[12]_i_5_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(12),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[12]_i_3_n_0\
    );
\s_axi_rdata[12]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFAACCF000AACCF0"
    )
        port map (
      I0 => \^cfg_frame_context\(44),
      I1 => \^cfg_frame_context\(76),
      I2 => \^cfg_frame_context\(12),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(108),
      O => \s_axi_rdata[12]_i_4_n_0\
    );
\s_axi_rdata[12]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[12]_i_6_n_0\,
      I1 => \^owner_cpu_epoch\(12),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(12),
      O => \s_axi_rdata[12]_i_5_n_0\
    );
\s_axi_rdata[12]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(12),
      I1 => owner_slot(12),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(12),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(12),
      O => \s_axi_rdata[12]_i_6_n_0\
    );
\s_axi_rdata[13]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8888888A888"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_6_n_0\,
      I1 => \s_axi_rdata[13]_i_2_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \^cfg_frame_context\(141),
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[13]_i_3_n_0\,
      O => \s_axi_rdata[13]_i_1_n_0\
    );
\s_axi_rdata[13]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000004044004440"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_8_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(13),
      I3 => \s_axi_rdata[30]_i_5_n_0\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \s_axi_rdata[13]_i_4_n_0\,
      O => \s_axi_rdata[13]_i_2_n_0\
    );
\s_axi_rdata[13]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCAAFFF0CCAA00F0"
    )
        port map (
      I0 => \^cfg_frame_context\(45),
      I1 => \^cfg_frame_context\(109),
      I2 => \^cfg_frame_context\(13),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(77),
      O => \s_axi_rdata[13]_i_3_n_0\
    );
\s_axi_rdata[13]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555FF035555FFF3"
    )
        port map (
      I0 => \s_axi_rdata[13]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(13),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(13),
      O => \s_axi_rdata[13]_i_4_n_0\
    );
\s_axi_rdata[13]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(13),
      I1 => owner_slot(13),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(13),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(13),
      O => \s_axi_rdata[13]_i_5_n_0\
    );
\s_axi_rdata[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BA"
    )
        port map (
      I0 => \s_axi_rdata[29]_i_2_n_0\,
      I1 => \s_axi_rdata[14]_i_2_n_0\,
      I2 => \s_axi_rdata[31]_i_6_n_0\,
      O => \s_axi_rdata[14]_i_1_n_0\
    );
\s_axi_rdata[14]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5F5F3F3F5F003F3F"
    )
        port map (
      I0 => \s_axi_rdata[14]_i_3_n_0\,
      I1 => \^cfg_frame_context\(142),
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \s_axi_rdata[14]_i_4_n_0\,
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[14]_i_2_n_0\
    );
\s_axi_rdata[14]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCAAFFF0CCAA00F0"
    )
        port map (
      I0 => \^cfg_frame_context\(46),
      I1 => \^cfg_frame_context\(110),
      I2 => \^cfg_frame_context\(14),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(78),
      O => \s_axi_rdata[14]_i_3_n_0\
    );
\s_axi_rdata[14]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAFCAAAAAAFFAA"
    )
        port map (
      I0 => \s_axi_rdata[14]_i_5_n_0\,
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(5),
      I4 => s_axi_araddr(0),
      I5 => owner_released_frames(14),
      O => \s_axi_rdata[14]_i_4_n_0\
    );
\s_axi_rdata[14]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555FF035555FFF3"
    )
        port map (
      I0 => \s_axi_rdata[14]_i_6_n_0\,
      I1 => \^owner_cpu_epoch\(14),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(14),
      O => \s_axi_rdata[14]_i_5_n_0\
    );
\s_axi_rdata[14]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(14),
      I1 => owner_slot(14),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(14),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(14),
      O => \s_axi_rdata[14]_i_6_n_0\
    );
\s_axi_rdata[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8888888A888"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_6_n_0\,
      I1 => \s_axi_rdata[15]_i_2_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \^cfg_frame_context\(143),
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[15]_i_3_n_0\,
      O => \s_axi_rdata[15]_i_1_n_0\
    );
\s_axi_rdata[15]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[15]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(15),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[15]_i_2_n_0\
    );
\s_axi_rdata[15]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCFFF0AACC00F0AA"
    )
        port map (
      I0 => \^cfg_frame_context\(15),
      I1 => \^cfg_frame_context\(111),
      I2 => \^cfg_frame_context\(47),
      I3 => s_axi_araddr(2),
      I4 => s_axi_araddr(3),
      I5 => \^cfg_frame_context\(79),
      O => \s_axi_rdata[15]_i_3_n_0\
    );
\s_axi_rdata[15]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[15]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(15),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(15),
      O => \s_axi_rdata[15]_i_4_n_0\
    );
\s_axi_rdata[15]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(15),
      I1 => owner_slot(15),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(15),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(15),
      O => \s_axi_rdata[15]_i_5_n_0\
    );
\s_axi_rdata[16]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFF0F8F0F0F0F0"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => \s_axi_rdata[29]_i_2_n_0\,
      I3 => \s_axi_rdata[16]_i_2_n_0\,
      I4 => \s_axi_rdata[16]_i_3_n_0\,
      I5 => \s_axi_rdata[31]_i_6_n_0\,
      O => \s_axi_rdata[16]_i_1_n_0\
    );
\s_axi_rdata[16]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F3300550F33FF55"
    )
        port map (
      I0 => \^cfg_frame_context\(16),
      I1 => \^cfg_frame_context\(48),
      I2 => \^cfg_frame_context\(112),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(80),
      O => \s_axi_rdata[16]_i_2_n_0\
    );
\s_axi_rdata[16]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000004044004440"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_8_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(16),
      I3 => \s_axi_rdata[30]_i_5_n_0\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \s_axi_rdata[16]_i_4_n_0\,
      O => \s_axi_rdata[16]_i_3_n_0\
    );
\s_axi_rdata[16]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555FF035555FFF3"
    )
        port map (
      I0 => \s_axi_rdata[16]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(16),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(16),
      O => \s_axi_rdata[16]_i_4_n_0\
    );
\s_axi_rdata[16]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(16),
      I1 => owner_slot(16),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(16),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(16),
      O => \s_axi_rdata[16]_i_5_n_0\
    );
\s_axi_rdata[17]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF0FFF0F0F0F8F0F"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => \s_axi_rdata[17]_i_2_n_0\,
      I3 => \s_axi_rdata[31]_i_6_n_0\,
      I4 => \s_axi_rdata[17]_i_3_n_0\,
      I5 => \s_axi_rdata[17]_i_4_n_0\,
      O => \s_axi_rdata[17]_i_1_n_0\
    );
\s_axi_rdata[17]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"EFFF"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(4),
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \owner_status_held[6]_i_4_n_0\,
      O => \s_axi_rdata[17]_i_2_n_0\
    );
\s_axi_rdata[17]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0F3300550F33FF55"
    )
        port map (
      I0 => \^cfg_frame_context\(17),
      I1 => \^cfg_frame_context\(49),
      I2 => \^cfg_frame_context\(113),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(81),
      O => \s_axi_rdata[17]_i_3_n_0\
    );
\s_axi_rdata[17]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000004044004440"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_8_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(17),
      I3 => \s_axi_rdata[30]_i_5_n_0\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \s_axi_rdata[17]_i_5_n_0\,
      O => \s_axi_rdata[17]_i_4_n_0\
    );
\s_axi_rdata[17]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555FF035555FFF3"
    )
        port map (
      I0 => \s_axi_rdata[17]_i_6_n_0\,
      I1 => \^owner_cpu_epoch\(17),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(17),
      O => \s_axi_rdata[17]_i_5_n_0\
    );
\s_axi_rdata[17]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(17),
      I1 => owner_slot(17),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(17),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(17),
      O => \s_axi_rdata[17]_i_6_n_0\
    );
\s_axi_rdata[18]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00200020A0A00020"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_6_n_0\,
      I1 => \s_axi_rdata[31]_i_8_n_0\,
      I2 => \s_axi_rdata[31]_i_5_n_0\,
      I3 => \s_axi_rdata[18]_i_2_n_0\,
      I4 => \s_axi_rdata[31]_i_4_n_0\,
      I5 => \s_axi_rdata[18]_i_3_n_0\,
      O => \s_axi_rdata[18]_i_1_n_0\
    );
\s_axi_rdata[18]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAFCAAAAAAFFAA"
    )
        port map (
      I0 => \s_axi_rdata[18]_i_4_n_0\,
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(5),
      I4 => s_axi_araddr(0),
      I5 => owner_released_frames(18),
      O => \s_axi_rdata[18]_i_2_n_0\
    );
\s_axi_rdata[18]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3355000F3355FF0F"
    )
        port map (
      I0 => \^cfg_frame_context\(50),
      I1 => \^cfg_frame_context\(114),
      I2 => \^cfg_frame_context\(18),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(82),
      O => \s_axi_rdata[18]_i_3_n_0\
    );
\s_axi_rdata[18]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555FF035555FFF3"
    )
        port map (
      I0 => \s_axi_rdata[18]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(18),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(18),
      O => \s_axi_rdata[18]_i_4_n_0\
    );
\s_axi_rdata[18]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(18),
      I1 => owner_slot(18),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(18),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(18),
      O => \s_axi_rdata[18]_i_5_n_0\
    );
\s_axi_rdata[19]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F000F080"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => \s_axi_rdata[31]_i_6_n_0\,
      I3 => \s_axi_rdata[19]_i_2_n_0\,
      I4 => \s_axi_rdata[19]_i_3_n_0\,
      O => \s_axi_rdata[19]_i_1_n_0\
    );
\s_axi_rdata[19]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[19]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(19),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[19]_i_2_n_0\
    );
\s_axi_rdata[19]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000F3355FF0F3355"
    )
        port map (
      I0 => \^cfg_frame_context\(19),
      I1 => \^cfg_frame_context\(51),
      I2 => \^cfg_frame_context\(83),
      I3 => s_axi_araddr(2),
      I4 => s_axi_araddr(3),
      I5 => \^cfg_frame_context\(115),
      O => \s_axi_rdata[19]_i_3_n_0\
    );
\s_axi_rdata[19]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[19]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(19),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(19),
      O => \s_axi_rdata[19]_i_4_n_0\
    );
\s_axi_rdata[19]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(19),
      I1 => owner_slot(19),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(19),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(19),
      O => \s_axi_rdata[19]_i_5_n_0\
    );
\s_axi_rdata[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FEFEFEEEFEFEFEFE"
    )
        port map (
      I0 => \s_axi_rdata[1]_i_2_n_0\,
      I1 => \s_axi_rdata[1]_i_3_n_0\,
      I2 => \owner_status_held_reg_n_0_[1]\,
      I3 => \^s_axi_rvalid_reg_0\,
      I4 => \s_axi_rdata[31]_i_1_n_0\,
      I5 => s_axi_arvalid,
      O => \s_axi_rdata[1]_i_1_n_0\
    );
\s_axi_rdata[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8888888A888"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_6_n_0\,
      I1 => \s_axi_rdata[1]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \^cfg_frame_context\(129),
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[1]_i_5_n_0\,
      O => \s_axi_rdata[1]_i_2_n_0\
    );
\s_axi_rdata[1]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3030000030002020"
    )
        port map (
      I0 => \configured_reg_n_0_[1]\,
      I1 => \s_axi_rdata[4]_i_4_n_0\,
      I2 => \owner_status_held[6]_i_4_n_0\,
      I3 => \^abort_requested_reg_0\,
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[1]_i_3_n_0\
    );
\s_axi_rdata[1]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000F4000000"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[1]_i_6_n_0\,
      I3 => \s_axi_rdata[31]_i_5_n_0\,
      I4 => \s_axi_rdata[1]_i_7_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[1]_i_4_n_0\
    );
\s_axi_rdata[1]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFAACCF000AACCF0"
    )
        port map (
      I0 => \^cfg_frame_context\(33),
      I1 => \^cfg_frame_context\(65),
      I2 => \^cfg_frame_context\(1),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(97),
      O => \s_axi_rdata[1]_i_5_n_0\
    );
\s_axi_rdata[1]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[1]_i_8_n_0\,
      I1 => \^owner_cpu_epoch\(1),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(1),
      O => \s_axi_rdata[1]_i_6_n_0\
    );
\s_axi_rdata[1]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBFFBBFFFBFFFBBB"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      I2 => owner_fault_causes(1),
      I3 => s_axi_araddr(2),
      I4 => owner_released_frames(1),
      I5 => s_axi_araddr(3),
      O => \s_axi_rdata[1]_i_7_n_0\
    );
\s_axi_rdata[1]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(1),
      I1 => owner_slot(1),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(1),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(1),
      O => \s_axi_rdata[1]_i_8_n_0\
    );
\s_axi_rdata[20]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F000F080"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => \s_axi_rdata[31]_i_6_n_0\,
      I3 => \s_axi_rdata[20]_i_2_n_0\,
      I4 => \s_axi_rdata[20]_i_3_n_0\,
      O => \s_axi_rdata[20]_i_1_n_0\
    );
\s_axi_rdata[20]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[20]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(20),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[20]_i_2_n_0\
    );
\s_axi_rdata[20]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000F3355FF0F3355"
    )
        port map (
      I0 => \^cfg_frame_context\(20),
      I1 => \^cfg_frame_context\(52),
      I2 => \^cfg_frame_context\(84),
      I3 => s_axi_araddr(2),
      I4 => s_axi_araddr(3),
      I5 => \^cfg_frame_context\(116),
      O => \s_axi_rdata[20]_i_3_n_0\
    );
\s_axi_rdata[20]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[20]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(20),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(20),
      O => \s_axi_rdata[20]_i_4_n_0\
    );
\s_axi_rdata[20]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(20),
      I1 => owner_slot(20),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(20),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(20),
      O => \s_axi_rdata[20]_i_5_n_0\
    );
\s_axi_rdata[21]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00200020A0A00020"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_6_n_0\,
      I1 => \s_axi_rdata[31]_i_8_n_0\,
      I2 => \s_axi_rdata[31]_i_5_n_0\,
      I3 => \s_axi_rdata[21]_i_2_n_0\,
      I4 => \s_axi_rdata[31]_i_4_n_0\,
      I5 => \s_axi_rdata[21]_i_3_n_0\,
      O => \s_axi_rdata[21]_i_1_n_0\
    );
\s_axi_rdata[21]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAFCAAAAAAFFAA"
    )
        port map (
      I0 => \s_axi_rdata[21]_i_4_n_0\,
      I1 => s_axi_araddr(3),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(5),
      I4 => s_axi_araddr(0),
      I5 => owner_released_frames(21),
      O => \s_axi_rdata[21]_i_2_n_0\
    );
\s_axi_rdata[21]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3355000F3355FF0F"
    )
        port map (
      I0 => \^cfg_frame_context\(53),
      I1 => \^cfg_frame_context\(117),
      I2 => \^cfg_frame_context\(21),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(85),
      O => \s_axi_rdata[21]_i_3_n_0\
    );
\s_axi_rdata[21]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555FF035555FFF3"
    )
        port map (
      I0 => \s_axi_rdata[21]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(21),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(21),
      O => \s_axi_rdata[21]_i_4_n_0\
    );
\s_axi_rdata[21]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(21),
      I1 => owner_slot(21),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(21),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(21),
      O => \s_axi_rdata[21]_i_5_n_0\
    );
\s_axi_rdata[22]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFF0F8F0F0F0F0"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => \s_axi_rdata[29]_i_2_n_0\,
      I3 => \s_axi_rdata[22]_i_2_n_0\,
      I4 => \s_axi_rdata[22]_i_3_n_0\,
      I5 => \s_axi_rdata[31]_i_6_n_0\,
      O => \s_axi_rdata[22]_i_1_n_0\
    );
\s_axi_rdata[22]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0055330FFF55330F"
    )
        port map (
      I0 => \^cfg_frame_context\(54),
      I1 => \^cfg_frame_context\(86),
      I2 => \^cfg_frame_context\(22),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(118),
      O => \s_axi_rdata[22]_i_2_n_0\
    );
\s_axi_rdata[22]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000004044004440"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_8_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(22),
      I3 => \s_axi_rdata[30]_i_5_n_0\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \s_axi_rdata[22]_i_4_n_0\,
      O => \s_axi_rdata[22]_i_3_n_0\
    );
\s_axi_rdata[22]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555FF035555FFF3"
    )
        port map (
      I0 => \s_axi_rdata[22]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(22),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(22),
      O => \s_axi_rdata[22]_i_4_n_0\
    );
\s_axi_rdata[22]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(22),
      I1 => owner_slot(22),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(22),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(22),
      O => \s_axi_rdata[22]_i_5_n_0\
    );
\s_axi_rdata[23]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F000F080"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => \s_axi_rdata[31]_i_6_n_0\,
      I3 => \s_axi_rdata[23]_i_2_n_0\,
      I4 => \s_axi_rdata[23]_i_3_n_0\,
      O => \s_axi_rdata[23]_i_1_n_0\
    );
\s_axi_rdata[23]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[23]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(23),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[23]_i_2_n_0\
    );
\s_axi_rdata[23]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0055330FFF55330F"
    )
        port map (
      I0 => \^cfg_frame_context\(55),
      I1 => \^cfg_frame_context\(87),
      I2 => \^cfg_frame_context\(23),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(119),
      O => \s_axi_rdata[23]_i_3_n_0\
    );
\s_axi_rdata[23]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[23]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(23),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(23),
      O => \s_axi_rdata[23]_i_4_n_0\
    );
\s_axi_rdata[23]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(23),
      I1 => owner_slot(23),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(23),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(23),
      O => \s_axi_rdata[23]_i_5_n_0\
    );
\s_axi_rdata[24]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFF0F8F0F0F0F0"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => \s_axi_rdata[29]_i_2_n_0\,
      I3 => \s_axi_rdata[24]_i_2_n_0\,
      I4 => \s_axi_rdata[24]_i_3_n_0\,
      I5 => \s_axi_rdata[31]_i_6_n_0\,
      O => \s_axi_rdata[24]_i_1_n_0\
    );
\s_axi_rdata[24]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0055330FFF55330F"
    )
        port map (
      I0 => \^cfg_frame_context\(56),
      I1 => \^cfg_frame_context\(88),
      I2 => \^cfg_frame_context\(24),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(120),
      O => \s_axi_rdata[24]_i_2_n_0\
    );
\s_axi_rdata[24]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[24]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(24),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[24]_i_3_n_0\
    );
\s_axi_rdata[24]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[24]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(24),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(24),
      O => \s_axi_rdata[24]_i_4_n_0\
    );
\s_axi_rdata[24]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(24),
      I1 => owner_slot(24),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(24),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(24),
      O => \s_axi_rdata[24]_i_5_n_0\
    );
\s_axi_rdata[25]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F000F080"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => \s_axi_rdata[31]_i_6_n_0\,
      I3 => \s_axi_rdata[25]_i_2_n_0\,
      I4 => \s_axi_rdata[25]_i_3_n_0\,
      O => \s_axi_rdata[25]_i_1_n_0\
    );
\s_axi_rdata[25]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[25]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(25),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[25]_i_2_n_0\
    );
\s_axi_rdata[25]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000F3355FF0F3355"
    )
        port map (
      I0 => \^cfg_frame_context\(25),
      I1 => \^cfg_frame_context\(57),
      I2 => \^cfg_frame_context\(89),
      I3 => s_axi_araddr(2),
      I4 => s_axi_araddr(3),
      I5 => \^cfg_frame_context\(121),
      O => \s_axi_rdata[25]_i_3_n_0\
    );
\s_axi_rdata[25]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[25]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(25),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(25),
      O => \s_axi_rdata[25]_i_4_n_0\
    );
\s_axi_rdata[25]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(25),
      I1 => owner_slot(25),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(25),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(25),
      O => \s_axi_rdata[25]_i_5_n_0\
    );
\s_axi_rdata[26]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F000F080"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => \s_axi_rdata[31]_i_6_n_0\,
      I3 => \s_axi_rdata[26]_i_2_n_0\,
      I4 => \s_axi_rdata[26]_i_3_n_0\,
      O => \s_axi_rdata[26]_i_1_n_0\
    );
\s_axi_rdata[26]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[26]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(26),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[26]_i_2_n_0\
    );
\s_axi_rdata[26]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0055330FFF55330F"
    )
        port map (
      I0 => \^cfg_frame_context\(58),
      I1 => \^cfg_frame_context\(90),
      I2 => \^cfg_frame_context\(26),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(122),
      O => \s_axi_rdata[26]_i_3_n_0\
    );
\s_axi_rdata[26]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[26]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(26),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(26),
      O => \s_axi_rdata[26]_i_4_n_0\
    );
\s_axi_rdata[26]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(26),
      I1 => owner_slot(26),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(26),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(26),
      O => \s_axi_rdata[26]_i_5_n_0\
    );
\s_axi_rdata[27]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F000F080"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => \s_axi_rdata[31]_i_6_n_0\,
      I3 => \s_axi_rdata[27]_i_2_n_0\,
      I4 => \s_axi_rdata[27]_i_3_n_0\,
      O => \s_axi_rdata[27]_i_1_n_0\
    );
\s_axi_rdata[27]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[27]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(27),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[27]_i_2_n_0\
    );
\s_axi_rdata[27]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3355000F3355FF0F"
    )
        port map (
      I0 => \^cfg_frame_context\(59),
      I1 => \^cfg_frame_context\(123),
      I2 => \^cfg_frame_context\(27),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(91),
      O => \s_axi_rdata[27]_i_3_n_0\
    );
\s_axi_rdata[27]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[27]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(27),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(27),
      O => \s_axi_rdata[27]_i_4_n_0\
    );
\s_axi_rdata[27]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(27),
      I1 => owner_slot(27),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(27),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(27),
      O => \s_axi_rdata[27]_i_5_n_0\
    );
\s_axi_rdata[28]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFF0F8F0F0F0F0"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => \s_axi_rdata[29]_i_2_n_0\,
      I3 => \s_axi_rdata[28]_i_2_n_0\,
      I4 => \s_axi_rdata[28]_i_3_n_0\,
      I5 => \s_axi_rdata[31]_i_6_n_0\,
      O => \s_axi_rdata[28]_i_1_n_0\
    );
\s_axi_rdata[28]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000F3355FF0F3355"
    )
        port map (
      I0 => \^cfg_frame_context\(28),
      I1 => \^cfg_frame_context\(60),
      I2 => \^cfg_frame_context\(92),
      I3 => s_axi_araddr(2),
      I4 => s_axi_araddr(3),
      I5 => \^cfg_frame_context\(124),
      O => \s_axi_rdata[28]_i_2_n_0\
    );
\s_axi_rdata[28]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[28]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(28),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[28]_i_3_n_0\
    );
\s_axi_rdata[28]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[28]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(28),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(28),
      O => \s_axi_rdata[28]_i_4_n_0\
    );
\s_axi_rdata[28]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(28),
      I1 => owner_slot(28),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(28),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(28),
      O => \s_axi_rdata[28]_i_5_n_0\
    );
\s_axi_rdata[29]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFF0F8F0F0F0F0"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => \s_axi_rdata[29]_i_2_n_0\,
      I3 => \s_axi_rdata[29]_i_3_n_0\,
      I4 => \s_axi_rdata[29]_i_4_n_0\,
      I5 => \s_axi_rdata[31]_i_6_n_0\,
      O => \s_axi_rdata[29]_i_1_n_0\
    );
\s_axi_rdata[29]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000080"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_5_n_0\,
      I1 => \owner_status_held[6]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => s_axi_araddr(4),
      I4 => s_axi_araddr(5),
      O => \s_axi_rdata[29]_i_2_n_0\
    );
\s_axi_rdata[29]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3355000F3355FF0F"
    )
        port map (
      I0 => \^cfg_frame_context\(61),
      I1 => \^cfg_frame_context\(125),
      I2 => \^cfg_frame_context\(29),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(93),
      O => \s_axi_rdata[29]_i_3_n_0\
    );
\s_axi_rdata[29]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000004044004440"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_8_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(29),
      I3 => \s_axi_rdata[30]_i_5_n_0\,
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => \s_axi_rdata[29]_i_5_n_0\,
      O => \s_axi_rdata[29]_i_4_n_0\
    );
\s_axi_rdata[29]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555FF035555FFF3"
    )
        port map (
      I0 => \s_axi_rdata[29]_i_6_n_0\,
      I1 => \^owner_cpu_epoch\(29),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(29),
      O => \s_axi_rdata[29]_i_5_n_0\
    );
\s_axi_rdata[29]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(29),
      I1 => owner_slot(29),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(29),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(29),
      O => \s_axi_rdata[29]_i_6_n_0\
    );
\s_axi_rdata[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FEFEFEEEFEFEFEFE"
    )
        port map (
      I0 => \s_axi_rdata[2]_i_2_n_0\,
      I1 => \s_axi_rdata[2]_i_3_n_0\,
      I2 => \owner_status_held_reg_n_0_[2]\,
      I3 => \^s_axi_rvalid_reg_0\,
      I4 => \s_axi_rdata[31]_i_1_n_0\,
      I5 => s_axi_arvalid,
      O => \s_axi_rdata[2]_i_1_n_0\
    );
\s_axi_rdata[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8888888A888"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_6_n_0\,
      I1 => \s_axi_rdata[2]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \^cfg_frame_context\(130),
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[2]_i_5_n_0\,
      O => \s_axi_rdata[2]_i_2_n_0\
    );
\s_axi_rdata[2]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3030000030002020"
    )
        port map (
      I0 => \configured_reg_n_0_[2]\,
      I1 => \s_axi_rdata[4]_i_4_n_0\,
      I2 => \owner_status_held[6]_i_4_n_0\,
      I3 => \^barrier_request_reg_0\,
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[2]_i_3_n_0\
    );
\s_axi_rdata[2]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000F4000000"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[2]_i_6_n_0\,
      I3 => \s_axi_rdata[31]_i_5_n_0\,
      I4 => \s_axi_rdata[2]_i_7_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[2]_i_4_n_0\
    );
\s_axi_rdata[2]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCAAFFF0CCAA00F0"
    )
        port map (
      I0 => \^cfg_frame_context\(34),
      I1 => \^cfg_frame_context\(98),
      I2 => \^cfg_frame_context\(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(66),
      O => \s_axi_rdata[2]_i_5_n_0\
    );
\s_axi_rdata[2]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[2]_i_8_n_0\,
      I1 => \^owner_cpu_epoch\(2),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(2),
      O => \s_axi_rdata[2]_i_6_n_0\
    );
\s_axi_rdata[2]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFCFFFCFCFCFEFEF"
    )
        port map (
      I0 => owner_released_frames(2),
      I1 => s_axi_araddr(0),
      I2 => s_axi_araddr(5),
      I3 => owner_fault_causes(2),
      I4 => s_axi_araddr(3),
      I5 => s_axi_araddr(2),
      O => \s_axi_rdata[2]_i_7_n_0\
    );
\s_axi_rdata[2]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(2),
      I1 => owner_slot(2),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(2),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(2),
      O => \s_axi_rdata[2]_i_8_n_0\
    );
\s_axi_rdata[30]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F000F080"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => \s_axi_rdata[31]_i_6_n_0\,
      I3 => \s_axi_rdata[30]_i_2_n_0\,
      I4 => \s_axi_rdata[30]_i_3_n_0\,
      O => \s_axi_rdata[30]_i_1_n_0\
    );
\s_axi_rdata[30]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[30]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(30),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[30]_i_2_n_0\
    );
\s_axi_rdata[30]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000F3355FF0F3355"
    )
        port map (
      I0 => \^cfg_frame_context\(30),
      I1 => \^cfg_frame_context\(62),
      I2 => \^cfg_frame_context\(94),
      I3 => s_axi_araddr(2),
      I4 => s_axi_araddr(3),
      I5 => \^cfg_frame_context\(126),
      O => \s_axi_rdata[30]_i_3_n_0\
    );
\s_axi_rdata[30]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[30]_i_6_n_0\,
      I1 => \^owner_cpu_epoch\(30),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(30),
      O => \s_axi_rdata[30]_i_4_n_0\
    );
\s_axi_rdata[30]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      O => \s_axi_rdata[30]_i_5_n_0\
    );
\s_axi_rdata[30]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(30),
      I1 => owner_slot(30),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(30),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(30),
      O => \s_axi_rdata[30]_i_6_n_0\
    );
\s_axi_rdata[31]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => owner_status_pending_reg_n_0,
      I1 => s_axi_aresetn,
      O => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata[31]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_12_n_0\,
      I1 => \^owner_cpu_epoch\(31),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(31),
      O => \s_axi_rdata[31]_i_10_n_0\
    );
\s_axi_rdata[31]_i_11\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(3),
      O => \s_axi_rdata[31]_i_11_n_0\
    );
\s_axi_rdata[31]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(31),
      I1 => owner_slot(31),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(31),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(31),
      O => \s_axi_rdata[31]_i_12_n_0\
    );
\s_axi_rdata[31]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F4F0"
    )
        port map (
      I0 => \^s_axi_rvalid_reg_0\,
      I1 => s_axi_aresetn,
      I2 => owner_status_pending_reg_n_0,
      I3 => s_axi_arvalid,
      O => \s_axi_rdata[31]_i_2_n_0\
    );
\s_axi_rdata[31]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8080F0800000F000"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => \s_axi_rdata[31]_i_6_n_0\,
      I3 => \s_axi_rdata[31]_i_7_n_0\,
      I4 => \s_axi_rdata[31]_i_8_n_0\,
      I5 => \s_axi_rdata[31]_i_9_n_0\,
      O => \s_axi_rdata[31]_i_3_n_0\
    );
\s_axi_rdata[31]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0101000001110101"
    )
        port map (
      I0 => s_axi_araddr(6),
      I1 => \s_axi_rresp[1]_i_2_n_0\,
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(2),
      I4 => s_axi_araddr(5),
      I5 => s_axi_araddr(3),
      O => \s_axi_rdata[31]_i_4_n_0\
    );
\s_axi_rdata[31]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000070FCCC7"
    )
        port map (
      I0 => s_axi_araddr(3),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(4),
      I3 => s_axi_araddr(2),
      I4 => s_axi_araddr(5),
      I5 => \s_axi_rresp[1]_i_2_n_0\,
      O => \s_axi_rdata[31]_i_5_n_0\
    );
\s_axi_rdata[31]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAAAAA8"
    )
        port map (
      I0 => \owner_status_held[6]_i_4_n_0\,
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(1),
      I3 => s_axi_araddr(0),
      I4 => s_axi_araddr(4),
      I5 => s_axi_araddr(5),
      O => \s_axi_rdata[31]_i_6_n_0\
    );
\s_axi_rdata[31]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A2AEA2A200000000"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_10_n_0\,
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(0),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => owner_released_frames(31),
      I5 => \s_axi_rdata[31]_i_5_n_0\,
      O => \s_axi_rdata[31]_i_7_n_0\
    );
\s_axi_rdata[31]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFEFFFEFFFEF"
    )
        port map (
      I0 => s_axi_araddr(1),
      I1 => s_axi_araddr(0),
      I2 => s_axi_araddr(6),
      I3 => \s_axi_rresp[1]_i_4_n_0\,
      I4 => s_axi_araddr(5),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[31]_i_8_n_0\
    );
\s_axi_rdata[31]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0CCFFAAF0CC00AA"
    )
        port map (
      I0 => \^cfg_frame_context\(31),
      I1 => \^cfg_frame_context\(63),
      I2 => \^cfg_frame_context\(127),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(95),
      O => \s_axi_rdata[31]_i_9_n_0\
    );
\s_axi_rdata[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAEAAAEAFFFFAAEA"
    )
        port map (
      I0 => \s_axi_rdata[3]_i_2_n_0\,
      I1 => \s_axi_rdata[3]_i_3_n_0\,
      I2 => \configured_reg_n_0_[3]\,
      I3 => \s_axi_rdata[31]_i_5_n_0\,
      I4 => \owner_status_held_reg_n_0_[3]\,
      I5 => owner_status_pending1,
      O => \s_axi_rdata[3]_i_1_n_0\
    );
\s_axi_rdata[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8888888A888"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_6_n_0\,
      I1 => \s_axi_rdata[3]_i_5_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \^cfg_frame_context\(131),
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[3]_i_6_n_0\,
      O => \s_axi_rdata[3]_i_2_n_0\
    );
\s_axi_rdata[3]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => \owner_status_held[6]_i_4_n_0\,
      I1 => \s_axi_rdata[4]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      O => \s_axi_rdata[3]_i_3_n_0\
    );
\s_axi_rdata[3]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0020"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => owner_status_pending_reg_n_0,
      I2 => s_axi_aresetn,
      I3 => \^s_axi_rvalid_reg_0\,
      O => owner_status_pending1
    );
\s_axi_rdata[3]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000F4000000"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(5),
      I2 => \s_axi_rdata[3]_i_7_n_0\,
      I3 => \s_axi_rdata[31]_i_5_n_0\,
      I4 => \s_axi_rdata[3]_i_8_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[3]_i_5_n_0\
    );
\s_axi_rdata[3]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFAACCF000AACCF0"
    )
        port map (
      I0 => \^cfg_frame_context\(35),
      I1 => \^cfg_frame_context\(67),
      I2 => \^cfg_frame_context\(3),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(99),
      O => \s_axi_rdata[3]_i_6_n_0\
    );
\s_axi_rdata[3]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[3]_i_9_n_0\,
      I1 => \^owner_cpu_epoch\(3),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(3),
      O => \s_axi_rdata[3]_i_7_n_0\
    );
\s_axi_rdata[3]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFCFFFCFCFCFEFEF"
    )
        port map (
      I0 => owner_released_frames(3),
      I1 => s_axi_araddr(0),
      I2 => s_axi_araddr(5),
      I3 => owner_fault_causes(3),
      I4 => s_axi_araddr(3),
      I5 => s_axi_araddr(2),
      O => \s_axi_rdata[3]_i_8_n_0\
    );
\s_axi_rdata[3]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(3),
      I1 => owner_slot(3),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(3),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(3),
      O => \s_axi_rdata[3]_i_9_n_0\
    );
\s_axi_rdata[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FD00FFFFFD00FD00"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => \s_axi_rdata[31]_i_1_n_0\,
      I2 => \^s_axi_rvalid_reg_0\,
      I3 => \owner_status_held_reg_n_0_[4]\,
      I4 => \s_axi_rdata[4]_i_2_n_0\,
      I5 => \s_axi_rdata[4]_i_3_n_0\,
      O => \s_axi_rdata[4]_i_1_n_0\
    );
\s_axi_rdata[4]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"555577DF"
    )
        port map (
      I0 => \owner_status_held[6]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_4_n_0\,
      I2 => \configured_reg_n_0_[4]\,
      I3 => \s_axi_rdata[31]_i_5_n_0\,
      I4 => \s_axi_rdata[4]_i_4_n_0\,
      O => \s_axi_rdata[4]_i_2_n_0\
    );
\s_axi_rdata[4]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FBFBFBBBBBBBFBBB"
    )
        port map (
      I0 => \s_axi_rdata[4]_i_5_n_0\,
      I1 => \s_axi_rdata[4]_i_4_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \^cfg_frame_context\(132),
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[4]_i_6_n_0\,
      O => \s_axi_rdata[4]_i_3_n_0\
    );
\s_axi_rdata[4]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(0),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(6),
      O => \s_axi_rdata[4]_i_4_n_0\
    );
\s_axi_rdata[4]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000080808880"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_5_n_0\,
      I1 => \s_axi_rdata[4]_i_7_n_0\,
      I2 => \s_axi_rdata[4]_i_8_n_0\,
      I3 => s_axi_araddr(5),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[4]_i_5_n_0\
    );
\s_axi_rdata[4]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFAACCF000AACCF0"
    )
        port map (
      I0 => \^cfg_frame_context\(36),
      I1 => \^cfg_frame_context\(68),
      I2 => \^cfg_frame_context\(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(100),
      O => \s_axi_rdata[4]_i_6_n_0\
    );
\s_axi_rdata[4]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFCFFFCFCFCFEFEF"
    )
        port map (
      I0 => owner_released_frames(4),
      I1 => s_axi_araddr(0),
      I2 => s_axi_araddr(5),
      I3 => \^owner_command_fault_reg_0\,
      I4 => s_axi_araddr(3),
      I5 => s_axi_araddr(2),
      O => \s_axi_rdata[4]_i_7_n_0\
    );
\s_axi_rdata[4]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[4]_i_9_n_0\,
      I1 => \^owner_cpu_epoch\(4),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(4),
      O => \s_axi_rdata[4]_i_8_n_0\
    );
\s_axi_rdata[4]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(4),
      I1 => owner_slot(4),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(4),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(4),
      O => \s_axi_rdata[4]_i_9_n_0\
    );
\s_axi_rdata[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFD00"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => owner_status_pending_reg_n_0,
      I2 => \^s_axi_rvalid_reg_0\,
      I3 => \owner_status_held_reg_n_0_[5]\,
      I4 => \s_axi_rdata[5]_i_2_n_0\,
      O => \s_axi_rdata[5]_i_1_n_0\
    );
\s_axi_rdata[5]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8888888A888"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_6_n_0\,
      I1 => \s_axi_rdata[5]_i_3_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \^cfg_frame_context\(133),
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[5]_i_4_n_0\,
      O => \s_axi_rdata[5]_i_2_n_0\
    );
\s_axi_rdata[5]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[5]_i_5_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(5),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[5]_i_3_n_0\
    );
\s_axi_rdata[5]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFAACCF000AACCF0"
    )
        port map (
      I0 => \^cfg_frame_context\(37),
      I1 => \^cfg_frame_context\(69),
      I2 => \^cfg_frame_context\(5),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(101),
      O => \s_axi_rdata[5]_i_4_n_0\
    );
\s_axi_rdata[5]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[5]_i_6_n_0\,
      I1 => \^owner_cpu_epoch\(5),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(5),
      O => \s_axi_rdata[5]_i_5_n_0\
    );
\s_axi_rdata[5]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(5),
      I1 => owner_slot(5),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(5),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(5),
      O => \s_axi_rdata[5]_i_6_n_0\
    );
\s_axi_rdata[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFEEEAEEEE"
    )
        port map (
      I0 => \s_axi_rdata[6]_i_2_n_0\,
      I1 => \owner_status_held_reg_n_0_[6]\,
      I2 => \^s_axi_rvalid_reg_0\,
      I3 => \s_axi_rdata[31]_i_1_n_0\,
      I4 => s_axi_arvalid,
      I5 => \s_axi_rdata[29]_i_2_n_0\,
      O => \s_axi_rdata[6]_i_1_n_0\
    );
\s_axi_rdata[6]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8888888A888"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_6_n_0\,
      I1 => \s_axi_rdata[6]_i_3_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \^cfg_frame_context\(134),
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[6]_i_4_n_0\,
      O => \s_axi_rdata[6]_i_2_n_0\
    );
\s_axi_rdata[6]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[6]_i_5_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(6),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[6]_i_3_n_0\
    );
\s_axi_rdata[6]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFAACCF000AACCF0"
    )
        port map (
      I0 => \^cfg_frame_context\(38),
      I1 => \^cfg_frame_context\(70),
      I2 => \^cfg_frame_context\(6),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(102),
      O => \s_axi_rdata[6]_i_4_n_0\
    );
\s_axi_rdata[6]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[6]_i_6_n_0\,
      I1 => \^owner_cpu_epoch\(6),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(6),
      O => \s_axi_rdata[6]_i_5_n_0\
    );
\s_axi_rdata[6]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(6),
      I1 => owner_slot(6),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(6),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(6),
      O => \s_axi_rdata[6]_i_6_n_0\
    );
\s_axi_rdata[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8888888A888"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_6_n_0\,
      I1 => \s_axi_rdata[7]_i_2_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \^cfg_frame_context\(135),
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[7]_i_3_n_0\,
      O => \s_axi_rdata[7]_i_1_n_0\
    );
\s_axi_rdata[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[7]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(7),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[7]_i_2_n_0\
    );
\s_axi_rdata[7]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCAAFFF0CCAA00F0"
    )
        port map (
      I0 => \^cfg_frame_context\(39),
      I1 => \^cfg_frame_context\(103),
      I2 => \^cfg_frame_context\(7),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(71),
      O => \s_axi_rdata[7]_i_3_n_0\
    );
\s_axi_rdata[7]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[7]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(7),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(7),
      O => \s_axi_rdata[7]_i_4_n_0\
    );
\s_axi_rdata[7]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(7),
      I1 => owner_slot(7),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(7),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(7),
      O => \s_axi_rdata[7]_i_5_n_0\
    );
\s_axi_rdata[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8888888A888"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_6_n_0\,
      I1 => \s_axi_rdata[8]_i_2_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \^cfg_frame_context\(136),
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[8]_i_3_n_0\,
      O => \s_axi_rdata[8]_i_1_n_0\
    );
\s_axi_rdata[8]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[8]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(8),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[8]_i_2_n_0\
    );
\s_axi_rdata[8]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFCCF0AA00CCF0AA"
    )
        port map (
      I0 => \^cfg_frame_context\(8),
      I1 => \^cfg_frame_context\(72),
      I2 => \^cfg_frame_context\(40),
      I3 => s_axi_araddr(2),
      I4 => s_axi_araddr(3),
      I5 => \^cfg_frame_context\(104),
      O => \s_axi_rdata[8]_i_3_n_0\
    );
\s_axi_rdata[8]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[8]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(8),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(8),
      O => \s_axi_rdata[8]_i_4_n_0\
    );
\s_axi_rdata[8]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(8),
      I1 => owner_slot(8),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(8),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(8),
      O => \s_axi_rdata[8]_i_5_n_0\
    );
\s_axi_rdata[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8A8A8888888A888"
    )
        port map (
      I0 => \s_axi_rdata[31]_i_6_n_0\,
      I1 => \s_axi_rdata[9]_i_2_n_0\,
      I2 => \s_axi_rdata[31]_i_4_n_0\,
      I3 => \^cfg_frame_context\(137),
      I4 => \s_axi_rdata[31]_i_5_n_0\,
      I5 => \s_axi_rdata[9]_i_3_n_0\,
      O => \s_axi_rdata[9]_i_1_n_0\
    );
\s_axi_rdata[9]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000888800C0"
    )
        port map (
      I0 => \s_axi_rdata[9]_i_4_n_0\,
      I1 => \s_axi_rdata[31]_i_5_n_0\,
      I2 => owner_released_frames(9),
      I3 => \s_axi_rdata[31]_i_11_n_0\,
      I4 => \s_axi_rdata[30]_i_5_n_0\,
      I5 => \s_axi_rdata[31]_i_8_n_0\,
      O => \s_axi_rdata[9]_i_2_n_0\
    );
\s_axi_rdata[9]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCAAFFF0CCAA00F0"
    )
        port map (
      I0 => \^cfg_frame_context\(41),
      I1 => \^cfg_frame_context\(105),
      I2 => \^cfg_frame_context\(9),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => \^cfg_frame_context\(73),
      O => \s_axi_rdata[9]_i_3_n_0\
    );
\s_axi_rdata[9]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA00FCAAAA000C"
    )
        port map (
      I0 => \s_axi_rdata[9]_i_5_n_0\,
      I1 => \^owner_cpu_epoch\(9),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(4),
      I5 => \^owner_cpu_frame_id\(9),
      O => \s_axi_rdata[9]_i_4_n_0\
    );
\s_axi_rdata[9]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => owner_granted_frames(9),
      I1 => owner_slot(9),
      I2 => s_axi_araddr(3),
      I3 => owner_frame_id(9),
      I4 => s_axi_araddr(2),
      I5 => owner_epoch(9),
      O => \s_axi_rdata[9]_i_5_n_0\
    );
\s_axi_rdata_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[0]_i_1_n_0\,
      Q => s_axi_rdata(0),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\s_axi_rdata_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[10]_i_1_n_0\,
      Q => s_axi_rdata(10),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[11]_i_1_n_0\,
      Q => s_axi_rdata(11),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[12]_i_1_n_0\,
      Q => s_axi_rdata(12),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[13]_i_1_n_0\,
      Q => s_axi_rdata(13),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[14]_i_1_n_0\,
      Q => s_axi_rdata(14),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[15]_i_1_n_0\,
      Q => s_axi_rdata(15),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[16]_i_1_n_0\,
      Q => s_axi_rdata(16),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[17]_i_1_n_0\,
      Q => s_axi_rdata(17),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[18]_i_1_n_0\,
      Q => s_axi_rdata(18),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[19]_i_1_n_0\,
      Q => s_axi_rdata(19),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[1]_i_1_n_0\,
      Q => s_axi_rdata(1),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\s_axi_rdata_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[20]_i_1_n_0\,
      Q => s_axi_rdata(20),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[21]_i_1_n_0\,
      Q => s_axi_rdata(21),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[22]_i_1_n_0\,
      Q => s_axi_rdata(22),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[23]_i_1_n_0\,
      Q => s_axi_rdata(23),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[24]_i_1_n_0\,
      Q => s_axi_rdata(24),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[25]_i_1_n_0\,
      Q => s_axi_rdata(25),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[26]_i_1_n_0\,
      Q => s_axi_rdata(26),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[27]_i_1_n_0\,
      Q => s_axi_rdata(27),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[28]_i_1_n_0\,
      Q => s_axi_rdata(28),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[29]_i_1_n_0\,
      Q => s_axi_rdata(29),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[2]_i_1_n_0\,
      Q => s_axi_rdata(2),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\s_axi_rdata_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[30]_i_1_n_0\,
      Q => s_axi_rdata(30),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[31]_i_3_n_0\,
      Q => s_axi_rdata(31),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[3]_i_1_n_0\,
      Q => s_axi_rdata(3),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\s_axi_rdata_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[4]_i_1_n_0\,
      Q => s_axi_rdata(4),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\s_axi_rdata_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[5]_i_1_n_0\,
      Q => s_axi_rdata(5),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\s_axi_rdata_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[6]_i_1_n_0\,
      Q => s_axi_rdata(6),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\s_axi_rdata_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[7]_i_1_n_0\,
      Q => s_axi_rdata(7),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[8]_i_1_n_0\,
      Q => s_axi_rdata(8),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rdata_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => \s_axi_rdata[31]_i_2_n_0\,
      D => \s_axi_rdata[9]_i_1_n_0\,
      Q => s_axi_rdata(9),
      R => \s_axi_rdata[31]_i_1_n_0\
    );
\s_axi_rresp[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000EEEEEEE2"
    )
        port map (
      I0 => \^s_axi_rresp\(0),
      I1 => owner_status_pending1,
      I2 => \s_axi_rresp[1]_i_2_n_0\,
      I3 => \s_axi_rresp[1]_i_3_n_0\,
      I4 => \s_axi_rresp[1]_i_4_n_0\,
      I5 => \s_axi_rdata[31]_i_1_n_0\,
      O => \s_axi_rresp[1]_i_1_n_0\
    );
\s_axi_rresp[1]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(1),
      O => \s_axi_rresp[1]_i_2_n_0\
    );
\s_axi_rresp[1]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BFB0B0B0BFB0BFB0"
    )
        port map (
      I0 => \owner_status_held[6]_i_5_n_0\,
      I1 => \s_axi_rresp[1]_i_5_n_0\,
      I2 => s_axi_araddr(6),
      I3 => s_axi_araddr(4),
      I4 => \s_axi_rdata[31]_i_11_n_0\,
      I5 => s_axi_araddr(5),
      O => \s_axi_rresp[1]_i_3_n_0\
    );
\s_axi_rresp[1]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => s_axi_araddr(10),
      I1 => s_axi_araddr(9),
      I2 => s_axi_araddr(8),
      I3 => s_axi_araddr(11),
      I4 => s_axi_araddr(7),
      O => \s_axi_rresp[1]_i_4_n_0\
    );
\s_axi_rresp[1]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000010"
    )
        port map (
      I0 => s_axi_araddr(8),
      I1 => s_axi_araddr(9),
      I2 => s_axi_araddr(6),
      I3 => s_axi_araddr(7),
      I4 => s_axi_araddr(11),
      I5 => s_axi_araddr(10),
      O => \s_axi_rresp[1]_i_5_n_0\
    );
\s_axi_rresp_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \s_axi_rresp[1]_i_1_n_0\,
      Q => \^s_axi_rresp\(0),
      R => '0'
    );
s_axi_rvalid_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F0FFF4F4"
    )
        port map (
      I0 => s_axi_rvalid_i_2_n_0,
      I1 => s_axi_arvalid,
      I2 => owner_status_pending_reg_n_0,
      I3 => s_axi_rready,
      I4 => \^s_axi_rvalid_reg_0\,
      O => s_axi_rvalid_i_1_n_0
    );
s_axi_rvalid_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000002"
    )
        port map (
      I0 => \s_axi_rresp[1]_i_5_n_0\,
      I1 => s_axi_araddr(1),
      I2 => s_axi_araddr(0),
      I3 => \owner_status_held[6]_i_3_n_0\,
      I4 => s_axi_araddr(4),
      I5 => s_axi_araddr(5),
      O => s_axi_rvalid_i_2_n_0
    );
s_axi_rvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => s_axi_rvalid_i_1_n_0,
      Q => \^s_axi_rvalid_reg_0\,
      R => \s_axi_bresp[1]_i_1_n_0\
    );
s_axi_wready_INST_0: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0010"
    )
        port map (
      I0 => w_held_reg_n_0,
      I1 => owner_command_pending_reg_n_0,
      I2 => s_axi_aresetn,
      I3 => \^s_axi_bvalid_reg_0\,
      O => s_axi_wready
    );
\strobes_held_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wstrb(0),
      Q => strobes_held(0),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\strobes_held_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wstrb(1),
      Q => strobes_held(1),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\strobes_held_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wstrb(2),
      Q => strobes_held(2),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
\strobes_held_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => w_held0,
      D => s_axi_wstrb(3),
      Q => strobes_held(3),
      R => \s_axi_bresp[1]_i_1_n_0\
    );
w_held_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F000F0F000200020"
    )
        port map (
      I0 => s_axi_wvalid,
      I1 => owner_command_pending_reg_n_0,
      I2 => s_axi_aresetn,
      I3 => \^s_axi_bvalid_reg_0\,
      I4 => aw_held,
      I5 => w_held_reg_n_0,
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
entity c6v_capture_control_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    common_aresetn : in STD_LOGIC;
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
    cfg_frame_context : out STD_LOGIC_VECTOR ( 143 downto 0 );
    capture_aresetn : out STD_LOGIC;
    armed : out STD_LOGIC;
    abort_requested : out STD_LOGIC;
    barrier_request : out STD_LOGIC;
    owner_available : in STD_LOGIC;
    owner_cpu_held : in STD_LOGIC;
    owner_drained : in STD_LOGIC;
    owner_fault : in STD_LOGIC;
    owner_claim_accepted : in STD_LOGIC;
    owner_release_accepted : in STD_LOGIC;
    owner_epoch : in STD_LOGIC_VECTOR ( 31 downto 0 );
    owner_frame_id : in STD_LOGIC_VECTOR ( 31 downto 0 );
    owner_slot : in STD_LOGIC_VECTOR ( 31 downto 0 );
    owner_granted_frames : in STD_LOGIC_VECTOR ( 31 downto 0 );
    owner_released_frames : in STD_LOGIC_VECTOR ( 31 downto 0 );
    owner_fault_causes : in STD_LOGIC_VECTOR ( 3 downto 0 );
    owner_cpu_claim : out STD_LOGIC;
    owner_cpu_release : out STD_LOGIC;
    owner_command_fault : out STD_LOGIC;
    owner_cpu_epoch : out STD_LOGIC_VECTOR ( 31 downto 0 );
    owner_cpu_frame_id : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of c6v_capture_control_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_capture_control_0 : entity is "c6v_capture_control_0,axi_vision_capture_control,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_capture_control_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_capture_control_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of c6v_capture_control_0 : entity is "axi_vision_capture_control,Vivado 2026.1";
end c6v_capture_control_0;

architecture STRUCTURE of c6v_capture_control_0 is
  signal \<const0>\ : STD_LOGIC;
  signal \^s_axi_bresp\ : STD_LOGIC_VECTOR ( 1 to 1 );
  signal \^s_axi_rresp\ : STD_LOGIC_VECTOR ( 1 to 1 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of capture_aresetn : signal is "xilinx.com:signal:reset:1.0 capture_aresetn RST";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of capture_aresetn : signal is "master";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of capture_aresetn : signal is "XIL_INTERFACENAME capture_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of common_aresetn : signal is "xilinx.com:signal:reset:1.0 common_aresetn RST";
  attribute X_INTERFACE_MODE of common_aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of common_aresetn : signal is "XIL_INTERFACENAME common_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_aclk : signal is "xilinx.com:signal:clock:1.0 s_axi_aclk CLK";
  attribute X_INTERFACE_MODE of s_axi_aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s_axi_aclk : signal is "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn:common_aresetn:capture_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0";
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
  s_axi_bresp(1) <= \^s_axi_bresp\(1);
  s_axi_bresp(0) <= \<const0>\;
  s_axi_rresp(1) <= \^s_axi_rresp\(1);
  s_axi_rresp(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
inst: entity work.c6v_capture_control_0_axi_vision_capture_control
     port map (
      D(2) => owner_drained,
      D(1) => owner_cpu_held,
      D(0) => owner_available,
      abort_requested_reg_0 => abort_requested,
      armed_reg_0 => armed,
      barrier_request_reg_0 => barrier_request,
      capture_aresetn => capture_aresetn,
      cfg_frame_context(143 downto 0) => cfg_frame_context(143 downto 0),
      common_aresetn => common_aresetn,
      owner_claim_accepted => owner_claim_accepted,
      owner_command_fault_reg_0 => owner_command_fault,
      owner_cpu_claim => owner_cpu_claim,
      owner_cpu_epoch(31 downto 0) => owner_cpu_epoch(31 downto 0),
      owner_cpu_frame_id(31 downto 0) => owner_cpu_frame_id(31 downto 0),
      owner_cpu_release => owner_cpu_release,
      owner_epoch(31 downto 0) => owner_epoch(31 downto 0),
      owner_fault => owner_fault,
      owner_fault_causes(3 downto 0) => owner_fault_causes(3 downto 0),
      owner_frame_id(31 downto 0) => owner_frame_id(31 downto 0),
      owner_granted_frames(31 downto 0) => owner_granted_frames(31 downto 0),
      owner_release_accepted => owner_release_accepted,
      owner_released_frames(31 downto 0) => owner_released_frames(31 downto 0),
      owner_slot(31 downto 0) => owner_slot(31 downto 0),
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
      s_axi_bvalid_reg_0 => s_axi_bvalid,
      s_axi_rdata(31 downto 0) => s_axi_rdata(31 downto 0),
      s_axi_rready => s_axi_rready,
      s_axi_rresp(0) => \^s_axi_rresp\(1),
      s_axi_rvalid_reg_0 => s_axi_rvalid,
      s_axi_wdata(31 downto 0) => s_axi_wdata(31 downto 0),
      s_axi_wready => s_axi_wready,
      s_axi_wstrb(3 downto 0) => s_axi_wstrb(3 downto 0),
      s_axi_wvalid => s_axi_wvalid
    );
end STRUCTURE;
