-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 30 22:06:56 2026
-- Host        : build-host running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_lifecycle_0/c6v_capture_lifecycle_0_sim_netlist.vhdl
-- Design      : c6v_capture_lifecycle_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_capture_lifecycle_0_vision_frame_owner is
  port (
    owner_fault_causes : out STD_LOGIC_VECTOR ( 3 downto 0 );
    clear : out STD_LOGIC;
    available_frame_id : out STD_LOGIC_VECTOR ( 31 downto 0 );
    \out\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    CO : out STD_LOGIC_VECTOR ( 0 to 0 );
    release_accepted : out STD_LOGIC;
    configuration_locked : out STD_LOGIC;
    closure_held_reg_0 : out STD_LOGIC;
    cpu_held_reg_0 : out STD_LOGIC;
    claim_accepted : out STD_LOGIC;
    \released_frames_reg[31]_0\ : out STD_LOGIC_VECTOR ( 31 downto 0 );
    grant_slot : out STD_LOGIC_VECTOR ( 1 downto 0 );
    available_slot : out STD_LOGIC_VECTOR ( 1 downto 0 );
    configuration_locked1 : out STD_LOGIC;
    request_open0 : out STD_LOGIC;
    configuration_locked_reg_0 : out STD_LOGIC;
    request_close0 : out STD_LOGIC;
    cpu_release_0 : out STD_LOGIC;
    owner_drained : out STD_LOGIC;
    frame_credit_ready : out STD_LOGIC;
    cpu_available : out STD_LOGIC;
    \granted_frames_reg[3]_0\ : out STD_LOGIC;
    available_epoch : out STD_LOGIC_VECTOR ( 31 downto 0 );
    Q : out STD_LOGIC_VECTOR ( 11 downto 0 );
    \released_frames_reg[1]_0\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    grant_frame_id : out STD_LOGIC_VECTOR ( 31 downto 0 );
    capture_fault_held_reg : out STD_LOGIC;
    aclk : in STD_LOGIC;
    \fault_causes_reg[0]_0\ : in STD_LOGIC;
    \closure_bad2_carry__0_0\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \closure_bad2_carry__1_0\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    owner_fault_INST_0_i_1_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    \closure_bad1_carry__0_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \closure_bad1_carry__1_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \closure_bad1_carry__2_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    owner_fault_INST_0_i_1_1 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    DI : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \grant_ready1_carry__0_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \grant_ready1_carry__1_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \grant_ready1_carry__1_1\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \grant_ready1_carry__2_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \grant_ready1_carry__2_1\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    frame_credit_ready_INST_0_i_3 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    frame_credit_ready_INST_0_i_3_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    configuration_locked_reg_1 : in STD_LOGIC;
    closure_held_reg_1 : in STD_LOGIC;
    capture_aresetn : in STD_LOGIC;
    frame_credit_request : in STD_LOGIC;
    control_barrier_request : in STD_LOGIC;
    control_abort_requested : in STD_LOGIC;
    control_capture_aresetn : in STD_LOGIC;
    \epoch_reg[31]_0\ : in STD_LOGIC;
    control_armed : in STD_LOGIC;
    cpu_claim : in STD_LOGIC;
    cpu_release : in STD_LOGIC;
    common_aresetn : in STD_LOGIC;
    pipeline_drained : in STD_LOGIC;
    dma_drained : in STD_LOGIC;
    frame_credit_ready_0 : in STD_LOGIC;
    claim_accepted_reg_0 : in STD_LOGIC;
    upstream_fault0 : in STD_LOGIC;
    cfg_frame_context : in STD_LOGIC_VECTOR ( 63 downto 0 );
    packet_completed_frames : in STD_LOGIC_VECTOR ( 31 downto 0 );
    status_completed_frames : in STD_LOGIC_VECTOR ( 31 downto 0 );
    rgb_completed_frames : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \granted_frames_reg[31]_0\ : in STD_LOGIC;
    budget_checked : in STD_LOGIC;
    closure_held : in STD_LOGIC;
    dest_arst : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 31 downto 0 );
    cpu_epoch : in STD_LOGIC_VECTOR ( 31 downto 0 );
    cpu_frame_id : in STD_LOGIC_VECTOR ( 31 downto 0 );
    capture_fault_held : in STD_LOGIC;
    E : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_capture_lifecycle_0_vision_frame_owner : entity is "vision_frame_owner";
end c6v_capture_lifecycle_0_vision_frame_owner;

architecture STRUCTURE of c6v_capture_lifecycle_0_vision_frame_owner is
  signal \^co\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^q\ : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal \^available_epoch\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^available_frame_id\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^available_slot\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal claim_accepted_i_1_n_0 : STD_LOGIC;
  signal \^clear\ : STD_LOGIC;
  signal closure_bad1 : STD_LOGIC;
  signal \closure_bad1_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \closure_bad1_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \closure_bad1_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \closure_bad1_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \closure_bad1_carry__0_n_0\ : STD_LOGIC;
  signal \closure_bad1_carry__0_n_1\ : STD_LOGIC;
  signal \closure_bad1_carry__0_n_2\ : STD_LOGIC;
  signal \closure_bad1_carry__0_n_3\ : STD_LOGIC;
  signal \closure_bad1_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \closure_bad1_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \closure_bad1_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \closure_bad1_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \closure_bad1_carry__1_n_0\ : STD_LOGIC;
  signal \closure_bad1_carry__1_n_1\ : STD_LOGIC;
  signal \closure_bad1_carry__1_n_2\ : STD_LOGIC;
  signal \closure_bad1_carry__1_n_3\ : STD_LOGIC;
  signal \closure_bad1_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \closure_bad1_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \closure_bad1_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \closure_bad1_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \closure_bad1_carry__2_n_1\ : STD_LOGIC;
  signal \closure_bad1_carry__2_n_2\ : STD_LOGIC;
  signal \closure_bad1_carry__2_n_3\ : STD_LOGIC;
  signal closure_bad1_carry_i_1_n_0 : STD_LOGIC;
  signal closure_bad1_carry_i_2_n_0 : STD_LOGIC;
  signal closure_bad1_carry_i_3_n_0 : STD_LOGIC;
  signal closure_bad1_carry_i_4_n_0 : STD_LOGIC;
  signal closure_bad1_carry_n_0 : STD_LOGIC;
  signal closure_bad1_carry_n_1 : STD_LOGIC;
  signal closure_bad1_carry_n_2 : STD_LOGIC;
  signal closure_bad1_carry_n_3 : STD_LOGIC;
  signal closure_bad2 : STD_LOGIC;
  signal \closure_bad2_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \closure_bad2_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \closure_bad2_carry__0_n_0\ : STD_LOGIC;
  signal \closure_bad2_carry__0_n_1\ : STD_LOGIC;
  signal \closure_bad2_carry__0_n_2\ : STD_LOGIC;
  signal \closure_bad2_carry__0_n_3\ : STD_LOGIC;
  signal \closure_bad2_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \closure_bad2_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \closure_bad2_carry__1_n_2\ : STD_LOGIC;
  signal \closure_bad2_carry__1_n_3\ : STD_LOGIC;
  signal closure_bad2_carry_i_1_n_0 : STD_LOGIC;
  signal closure_bad2_carry_i_3_n_0 : STD_LOGIC;
  signal closure_bad2_carry_i_4_n_0 : STD_LOGIC;
  signal closure_bad2_carry_n_0 : STD_LOGIC;
  signal closure_bad2_carry_n_1 : STD_LOGIC;
  signal closure_bad2_carry_n_2 : STD_LOGIC;
  signal closure_bad2_carry_n_3 : STD_LOGIC;
  signal \^closure_held_reg_0\ : STD_LOGIC;
  signal configuration_bad1 : STD_LOGIC;
  signal \configuration_bad1_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \configuration_bad1_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \configuration_bad1_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \configuration_bad1_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \configuration_bad1_carry__0_n_0\ : STD_LOGIC;
  signal \configuration_bad1_carry__0_n_1\ : STD_LOGIC;
  signal \configuration_bad1_carry__0_n_2\ : STD_LOGIC;
  signal \configuration_bad1_carry__0_n_3\ : STD_LOGIC;
  signal \configuration_bad1_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \configuration_bad1_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \configuration_bad1_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \configuration_bad1_carry__1_n_2\ : STD_LOGIC;
  signal \configuration_bad1_carry__1_n_3\ : STD_LOGIC;
  signal configuration_bad1_carry_i_1_n_0 : STD_LOGIC;
  signal configuration_bad1_carry_i_2_n_0 : STD_LOGIC;
  signal configuration_bad1_carry_i_3_n_0 : STD_LOGIC;
  signal configuration_bad1_carry_i_4_n_0 : STD_LOGIC;
  signal configuration_bad1_carry_n_0 : STD_LOGIC;
  signal configuration_bad1_carry_n_1 : STD_LOGIC;
  signal configuration_bad1_carry_n_2 : STD_LOGIC;
  signal configuration_bad1_carry_n_3 : STD_LOGIC;
  signal \configuration_bad2_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \configuration_bad2_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \configuration_bad2_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \configuration_bad2_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \configuration_bad2_carry__0_n_0\ : STD_LOGIC;
  signal \configuration_bad2_carry__0_n_1\ : STD_LOGIC;
  signal \configuration_bad2_carry__0_n_2\ : STD_LOGIC;
  signal \configuration_bad2_carry__0_n_3\ : STD_LOGIC;
  signal \configuration_bad2_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \configuration_bad2_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \configuration_bad2_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \configuration_bad2_carry__1_n_1\ : STD_LOGIC;
  signal \configuration_bad2_carry__1_n_2\ : STD_LOGIC;
  signal \configuration_bad2_carry__1_n_3\ : STD_LOGIC;
  signal configuration_bad2_carry_i_1_n_0 : STD_LOGIC;
  signal configuration_bad2_carry_i_2_n_0 : STD_LOGIC;
  signal configuration_bad2_carry_i_3_n_0 : STD_LOGIC;
  signal configuration_bad2_carry_i_4_n_0 : STD_LOGIC;
  signal configuration_bad2_carry_n_0 : STD_LOGIC;
  signal configuration_bad2_carry_n_1 : STD_LOGIC;
  signal configuration_bad2_carry_n_2 : STD_LOGIC;
  signal configuration_bad2_carry_n_3 : STD_LOGIC;
  signal \^configuration_locked\ : STD_LOGIC;
  signal \^configuration_locked1\ : STD_LOGIC;
  signal configuration_locked17_out : STD_LOGIC;
  signal \^configuration_locked_reg_0\ : STD_LOGIC;
  signal \consumer_identity_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__0_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__0_n_1\ : STD_LOGIC;
  signal \consumer_identity_carry__0_n_2\ : STD_LOGIC;
  signal \consumer_identity_carry__0_n_3\ : STD_LOGIC;
  signal \consumer_identity_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__1_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__1_n_1\ : STD_LOGIC;
  signal \consumer_identity_carry__1_n_2\ : STD_LOGIC;
  signal \consumer_identity_carry__1_n_3\ : STD_LOGIC;
  signal \consumer_identity_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__2_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__2_n_1\ : STD_LOGIC;
  signal \consumer_identity_carry__2_n_2\ : STD_LOGIC;
  signal \consumer_identity_carry__2_n_3\ : STD_LOGIC;
  signal \consumer_identity_carry__3_i_1_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__3_i_2_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__3_i_3_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__3_i_4_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__3_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__3_n_1\ : STD_LOGIC;
  signal \consumer_identity_carry__3_n_2\ : STD_LOGIC;
  signal \consumer_identity_carry__3_n_3\ : STD_LOGIC;
  signal \consumer_identity_carry__4_i_1_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__4_i_2_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__4_i_3_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__4_i_4_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__4_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__4_n_1\ : STD_LOGIC;
  signal \consumer_identity_carry__4_n_2\ : STD_LOGIC;
  signal \consumer_identity_carry__4_n_3\ : STD_LOGIC;
  signal \consumer_identity_carry__5_i_1_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__5_i_2_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__5_i_3_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__5_i_4_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__5_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__5_n_1\ : STD_LOGIC;
  signal \consumer_identity_carry__5_n_2\ : STD_LOGIC;
  signal \consumer_identity_carry__5_n_3\ : STD_LOGIC;
  signal \consumer_identity_carry__6_i_1_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__6_i_2_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__6_i_3_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__6_i_4_n_0\ : STD_LOGIC;
  signal \consumer_identity_carry__6_n_1\ : STD_LOGIC;
  signal \consumer_identity_carry__6_n_2\ : STD_LOGIC;
  signal \consumer_identity_carry__6_n_3\ : STD_LOGIC;
  signal consumer_identity_carry_i_1_n_0 : STD_LOGIC;
  signal consumer_identity_carry_i_2_n_0 : STD_LOGIC;
  signal consumer_identity_carry_i_3_n_0 : STD_LOGIC;
  signal consumer_identity_carry_i_4_n_0 : STD_LOGIC;
  signal consumer_identity_carry_n_0 : STD_LOGIC;
  signal consumer_identity_carry_n_1 : STD_LOGIC;
  signal consumer_identity_carry_n_2 : STD_LOGIC;
  signal consumer_identity_carry_n_3 : STD_LOGIC;
  signal consumer_slot : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \consumer_slot[0]_i_1_n_0\ : STD_LOGIC;
  signal \consumer_slot[1]_i_1_n_0\ : STD_LOGIC;
  signal counters_bad1 : STD_LOGIC;
  signal \counters_bad1_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__0_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__0_n_1\ : STD_LOGIC;
  signal \counters_bad1_carry__0_n_2\ : STD_LOGIC;
  signal \counters_bad1_carry__0_n_3\ : STD_LOGIC;
  signal \counters_bad1_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__1_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__1_n_1\ : STD_LOGIC;
  signal \counters_bad1_carry__1_n_2\ : STD_LOGIC;
  signal \counters_bad1_carry__1_n_3\ : STD_LOGIC;
  signal \counters_bad1_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad1_carry__2_n_1\ : STD_LOGIC;
  signal \counters_bad1_carry__2_n_2\ : STD_LOGIC;
  signal \counters_bad1_carry__2_n_3\ : STD_LOGIC;
  signal counters_bad1_carry_i_1_n_0 : STD_LOGIC;
  signal counters_bad1_carry_i_2_n_0 : STD_LOGIC;
  signal counters_bad1_carry_i_3_n_0 : STD_LOGIC;
  signal counters_bad1_carry_i_4_n_0 : STD_LOGIC;
  signal counters_bad1_carry_i_5_n_0 : STD_LOGIC;
  signal counters_bad1_carry_i_6_n_0 : STD_LOGIC;
  signal counters_bad1_carry_i_7_n_0 : STD_LOGIC;
  signal counters_bad1_carry_i_8_n_0 : STD_LOGIC;
  signal counters_bad1_carry_n_0 : STD_LOGIC;
  signal counters_bad1_carry_n_1 : STD_LOGIC;
  signal counters_bad1_carry_n_2 : STD_LOGIC;
  signal counters_bad1_carry_n_3 : STD_LOGIC;
  signal counters_bad2 : STD_LOGIC;
  signal \counters_bad2_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__0_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__0_n_1\ : STD_LOGIC;
  signal \counters_bad2_carry__0_n_2\ : STD_LOGIC;
  signal \counters_bad2_carry__0_n_3\ : STD_LOGIC;
  signal \counters_bad2_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__1_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__1_n_1\ : STD_LOGIC;
  signal \counters_bad2_carry__1_n_2\ : STD_LOGIC;
  signal \counters_bad2_carry__1_n_3\ : STD_LOGIC;
  signal \counters_bad2_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad2_carry__2_n_1\ : STD_LOGIC;
  signal \counters_bad2_carry__2_n_2\ : STD_LOGIC;
  signal \counters_bad2_carry__2_n_3\ : STD_LOGIC;
  signal counters_bad2_carry_i_1_n_0 : STD_LOGIC;
  signal counters_bad2_carry_i_2_n_0 : STD_LOGIC;
  signal counters_bad2_carry_i_3_n_0 : STD_LOGIC;
  signal counters_bad2_carry_i_4_n_0 : STD_LOGIC;
  signal counters_bad2_carry_i_5_n_0 : STD_LOGIC;
  signal counters_bad2_carry_i_6_n_0 : STD_LOGIC;
  signal counters_bad2_carry_i_7_n_0 : STD_LOGIC;
  signal counters_bad2_carry_i_8_n_0 : STD_LOGIC;
  signal counters_bad2_carry_n_0 : STD_LOGIC;
  signal counters_bad2_carry_n_1 : STD_LOGIC;
  signal counters_bad2_carry_n_2 : STD_LOGIC;
  signal counters_bad2_carry_n_3 : STD_LOGIC;
  signal counters_bad3 : STD_LOGIC;
  signal \counters_bad3_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__0_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__0_n_1\ : STD_LOGIC;
  signal \counters_bad3_carry__0_n_2\ : STD_LOGIC;
  signal \counters_bad3_carry__0_n_3\ : STD_LOGIC;
  signal \counters_bad3_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__1_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__1_n_1\ : STD_LOGIC;
  signal \counters_bad3_carry__1_n_2\ : STD_LOGIC;
  signal \counters_bad3_carry__1_n_3\ : STD_LOGIC;
  signal \counters_bad3_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad3_carry__2_n_1\ : STD_LOGIC;
  signal \counters_bad3_carry__2_n_2\ : STD_LOGIC;
  signal \counters_bad3_carry__2_n_3\ : STD_LOGIC;
  signal counters_bad3_carry_i_1_n_0 : STD_LOGIC;
  signal counters_bad3_carry_i_2_n_0 : STD_LOGIC;
  signal counters_bad3_carry_i_3_n_0 : STD_LOGIC;
  signal counters_bad3_carry_i_4_n_0 : STD_LOGIC;
  signal counters_bad3_carry_i_5_n_0 : STD_LOGIC;
  signal counters_bad3_carry_i_6_n_0 : STD_LOGIC;
  signal counters_bad3_carry_i_7_n_0 : STD_LOGIC;
  signal counters_bad3_carry_i_8_n_0 : STD_LOGIC;
  signal counters_bad3_carry_n_0 : STD_LOGIC;
  signal counters_bad3_carry_n_1 : STD_LOGIC;
  signal counters_bad3_carry_n_2 : STD_LOGIC;
  signal counters_bad3_carry_n_3 : STD_LOGIC;
  signal counters_bad4 : STD_LOGIC;
  signal \counters_bad4_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__0_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__0_n_1\ : STD_LOGIC;
  signal \counters_bad4_carry__0_n_2\ : STD_LOGIC;
  signal \counters_bad4_carry__0_n_3\ : STD_LOGIC;
  signal \counters_bad4_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__1_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__1_n_1\ : STD_LOGIC;
  signal \counters_bad4_carry__1_n_2\ : STD_LOGIC;
  signal \counters_bad4_carry__1_n_3\ : STD_LOGIC;
  signal \counters_bad4_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad4_carry__2_n_1\ : STD_LOGIC;
  signal \counters_bad4_carry__2_n_2\ : STD_LOGIC;
  signal \counters_bad4_carry__2_n_3\ : STD_LOGIC;
  signal counters_bad4_carry_i_1_n_0 : STD_LOGIC;
  signal counters_bad4_carry_i_2_n_0 : STD_LOGIC;
  signal counters_bad4_carry_i_3_n_0 : STD_LOGIC;
  signal counters_bad4_carry_i_4_n_0 : STD_LOGIC;
  signal counters_bad4_carry_i_5_n_0 : STD_LOGIC;
  signal counters_bad4_carry_i_6_n_0 : STD_LOGIC;
  signal counters_bad4_carry_i_7_n_0 : STD_LOGIC;
  signal counters_bad4_carry_i_8_n_0 : STD_LOGIC;
  signal counters_bad4_carry_n_0 : STD_LOGIC;
  signal counters_bad4_carry_n_1 : STD_LOGIC;
  signal counters_bad4_carry_n_2 : STD_LOGIC;
  signal counters_bad4_carry_n_3 : STD_LOGIC;
  signal counters_bad5 : STD_LOGIC;
  signal counters_bad54_in : STD_LOGIC;
  signal \counters_bad5_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__0_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__0_n_1\ : STD_LOGIC;
  signal \counters_bad5_carry__0_n_2\ : STD_LOGIC;
  signal \counters_bad5_carry__0_n_3\ : STD_LOGIC;
  signal \counters_bad5_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__1_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__1_n_1\ : STD_LOGIC;
  signal \counters_bad5_carry__1_n_2\ : STD_LOGIC;
  signal \counters_bad5_carry__1_n_3\ : STD_LOGIC;
  signal \counters_bad5_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \counters_bad5_carry__2_n_1\ : STD_LOGIC;
  signal \counters_bad5_carry__2_n_2\ : STD_LOGIC;
  signal \counters_bad5_carry__2_n_3\ : STD_LOGIC;
  signal counters_bad5_carry_i_1_n_0 : STD_LOGIC;
  signal counters_bad5_carry_i_2_n_0 : STD_LOGIC;
  signal counters_bad5_carry_i_3_n_0 : STD_LOGIC;
  signal counters_bad5_carry_i_4_n_0 : STD_LOGIC;
  signal counters_bad5_carry_i_5_n_0 : STD_LOGIC;
  signal counters_bad5_carry_i_6_n_0 : STD_LOGIC;
  signal counters_bad5_carry_i_7_n_0 : STD_LOGIC;
  signal counters_bad5_carry_i_8_n_0 : STD_LOGIC;
  signal counters_bad5_carry_n_0 : STD_LOGIC;
  signal counters_bad5_carry_n_1 : STD_LOGIC;
  signal counters_bad5_carry_n_2 : STD_LOGIC;
  signal counters_bad5_carry_n_3 : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry__0_n_0\ : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry__0_n_1\ : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry__0_n_2\ : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry__0_n_3\ : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry__1_n_0\ : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry__1_n_1\ : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry__1_n_2\ : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry__1_n_3\ : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry__2_n_1\ : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry__2_n_2\ : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry__2_n_3\ : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry_n_0\ : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry_n_1\ : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry_n_2\ : STD_LOGIC;
  signal \counters_bad5_inferred__0/i__carry_n_3\ : STD_LOGIC;
  signal cpu_available0 : STD_LOGIC;
  signal \cpu_available0_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__0_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__0_n_1\ : STD_LOGIC;
  signal \cpu_available0_carry__0_n_2\ : STD_LOGIC;
  signal \cpu_available0_carry__0_n_3\ : STD_LOGIC;
  signal \cpu_available0_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__1_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__1_n_1\ : STD_LOGIC;
  signal \cpu_available0_carry__1_n_2\ : STD_LOGIC;
  signal \cpu_available0_carry__1_n_3\ : STD_LOGIC;
  signal \cpu_available0_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \cpu_available0_carry__2_n_1\ : STD_LOGIC;
  signal \cpu_available0_carry__2_n_2\ : STD_LOGIC;
  signal \cpu_available0_carry__2_n_3\ : STD_LOGIC;
  signal cpu_available0_carry_i_1_n_0 : STD_LOGIC;
  signal cpu_available0_carry_i_2_n_0 : STD_LOGIC;
  signal cpu_available0_carry_i_3_n_0 : STD_LOGIC;
  signal cpu_available0_carry_i_4_n_0 : STD_LOGIC;
  signal cpu_available0_carry_i_5_n_0 : STD_LOGIC;
  signal cpu_available0_carry_i_6_n_0 : STD_LOGIC;
  signal cpu_available0_carry_i_7_n_0 : STD_LOGIC;
  signal cpu_available0_carry_i_8_n_0 : STD_LOGIC;
  signal cpu_available0_carry_n_0 : STD_LOGIC;
  signal cpu_available0_carry_n_1 : STD_LOGIC;
  signal cpu_available0_carry_n_2 : STD_LOGIC;
  signal cpu_available0_carry_n_3 : STD_LOGIC;
  signal cpu_available1 : STD_LOGIC;
  signal \cpu_available1_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__0_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__0_n_1\ : STD_LOGIC;
  signal \cpu_available1_carry__0_n_2\ : STD_LOGIC;
  signal \cpu_available1_carry__0_n_3\ : STD_LOGIC;
  signal \cpu_available1_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__1_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__1_n_1\ : STD_LOGIC;
  signal \cpu_available1_carry__1_n_2\ : STD_LOGIC;
  signal \cpu_available1_carry__1_n_3\ : STD_LOGIC;
  signal \cpu_available1_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \cpu_available1_carry__2_n_1\ : STD_LOGIC;
  signal \cpu_available1_carry__2_n_2\ : STD_LOGIC;
  signal \cpu_available1_carry__2_n_3\ : STD_LOGIC;
  signal cpu_available1_carry_i_1_n_0 : STD_LOGIC;
  signal cpu_available1_carry_i_2_n_0 : STD_LOGIC;
  signal cpu_available1_carry_i_3_n_0 : STD_LOGIC;
  signal cpu_available1_carry_i_4_n_0 : STD_LOGIC;
  signal cpu_available1_carry_i_5_n_0 : STD_LOGIC;
  signal cpu_available1_carry_i_6_n_0 : STD_LOGIC;
  signal cpu_available1_carry_i_7_n_0 : STD_LOGIC;
  signal cpu_available1_carry_i_8_n_0 : STD_LOGIC;
  signal cpu_available1_carry_n_0 : STD_LOGIC;
  signal cpu_available1_carry_n_1 : STD_LOGIC;
  signal cpu_available1_carry_n_2 : STD_LOGIC;
  signal cpu_available1_carry_n_3 : STD_LOGIC;
  signal cpu_available2 : STD_LOGIC;
  signal \cpu_available2_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__0_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__0_n_1\ : STD_LOGIC;
  signal \cpu_available2_carry__0_n_2\ : STD_LOGIC;
  signal \cpu_available2_carry__0_n_3\ : STD_LOGIC;
  signal \cpu_available2_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__1_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__1_n_1\ : STD_LOGIC;
  signal \cpu_available2_carry__1_n_2\ : STD_LOGIC;
  signal \cpu_available2_carry__1_n_3\ : STD_LOGIC;
  signal \cpu_available2_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \cpu_available2_carry__2_n_1\ : STD_LOGIC;
  signal \cpu_available2_carry__2_n_2\ : STD_LOGIC;
  signal \cpu_available2_carry__2_n_3\ : STD_LOGIC;
  signal cpu_available2_carry_i_1_n_0 : STD_LOGIC;
  signal cpu_available2_carry_i_2_n_0 : STD_LOGIC;
  signal cpu_available2_carry_i_3_n_0 : STD_LOGIC;
  signal cpu_available2_carry_i_4_n_0 : STD_LOGIC;
  signal cpu_available2_carry_i_5_n_0 : STD_LOGIC;
  signal cpu_available2_carry_i_6_n_0 : STD_LOGIC;
  signal cpu_available2_carry_i_7_n_0 : STD_LOGIC;
  signal cpu_available2_carry_i_8_n_0 : STD_LOGIC;
  signal cpu_available2_carry_n_0 : STD_LOGIC;
  signal cpu_available2_carry_n_1 : STD_LOGIC;
  signal cpu_available2_carry_n_2 : STD_LOGIC;
  signal cpu_available2_carry_n_3 : STD_LOGIC;
  signal cpu_available3 : STD_LOGIC;
  signal \cpu_available3_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__0_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__0_n_1\ : STD_LOGIC;
  signal \cpu_available3_carry__0_n_2\ : STD_LOGIC;
  signal \cpu_available3_carry__0_n_3\ : STD_LOGIC;
  signal \cpu_available3_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__1_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__1_n_1\ : STD_LOGIC;
  signal \cpu_available3_carry__1_n_2\ : STD_LOGIC;
  signal \cpu_available3_carry__1_n_3\ : STD_LOGIC;
  signal \cpu_available3_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \cpu_available3_carry__2_n_1\ : STD_LOGIC;
  signal \cpu_available3_carry__2_n_2\ : STD_LOGIC;
  signal \cpu_available3_carry__2_n_3\ : STD_LOGIC;
  signal cpu_available3_carry_i_1_n_0 : STD_LOGIC;
  signal cpu_available3_carry_i_2_n_0 : STD_LOGIC;
  signal cpu_available3_carry_i_3_n_0 : STD_LOGIC;
  signal cpu_available3_carry_i_4_n_0 : STD_LOGIC;
  signal cpu_available3_carry_i_5_n_0 : STD_LOGIC;
  signal cpu_available3_carry_i_6_n_0 : STD_LOGIC;
  signal cpu_available3_carry_i_7_n_0 : STD_LOGIC;
  signal cpu_available3_carry_i_8_n_0 : STD_LOGIC;
  signal cpu_available3_carry_n_0 : STD_LOGIC;
  signal cpu_available3_carry_n_1 : STD_LOGIC;
  signal cpu_available3_carry_n_2 : STD_LOGIC;
  signal cpu_available3_carry_n_3 : STD_LOGIC;
  signal cpu_available_INST_0_i_1_n_0 : STD_LOGIC;
  signal cpu_available_INST_0_i_2_n_0 : STD_LOGIC;
  signal cpu_held_i_1_n_0 : STD_LOGIC;
  signal cpu_held_i_2_n_0 : STD_LOGIC;
  signal cpu_held_i_3_n_0 : STD_LOGIC;
  signal \^cpu_held_reg_0\ : STD_LOGIC;
  signal \epoch[31]_i_10_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_11_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_12_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_13_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_14_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_15_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_16_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_17_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_18_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_19_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_20_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_21_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_22_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_23_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_24_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_25_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_26_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_27_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_28_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_29_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_30_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_31_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_32_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_33_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_34_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_35_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_36_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_37_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_38_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_39_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_3_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_40_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_41_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_42_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_43_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_44_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_4_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_5_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_6_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_7_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_8_n_0\ : STD_LOGIC;
  signal \epoch[31]_i_9_n_0\ : STD_LOGIC;
  signal \fault_causes[1]_i_1_n_0\ : STD_LOGIC;
  signal \fault_causes[1]_i_2_n_0\ : STD_LOGIC;
  signal \fault_causes[1]_i_3_n_0\ : STD_LOGIC;
  signal \fault_causes[1]_i_4_n_0\ : STD_LOGIC;
  signal \fault_causes[2]_i_1_n_0\ : STD_LOGIC;
  signal \fault_causes[3]_i_1_n_0\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[0]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[10]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[11]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[12]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[13]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[14]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[15]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[16]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[17]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[1]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[27]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[28]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[29]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[2]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[30]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[31]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[3]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[4]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[5]\ : STD_LOGIC;
  signal \final_frame_count_reg_n_0_[9]\ : STD_LOGIC;
  signal first_frame_id : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal frame_credit_ready_INST_0_i_10_n_0 : STD_LOGIC;
  signal frame_credit_ready_INST_0_i_11_n_0 : STD_LOGIC;
  signal frame_credit_ready_INST_0_i_12_n_0 : STD_LOGIC;
  signal frame_credit_ready_INST_0_i_13_n_0 : STD_LOGIC;
  signal frame_credit_ready_INST_0_i_14_n_0 : STD_LOGIC;
  signal frame_credit_ready_INST_0_i_15_n_0 : STD_LOGIC;
  signal frame_credit_ready_INST_0_i_16_n_0 : STD_LOGIC;
  signal frame_credit_ready_INST_0_i_17_n_0 : STD_LOGIC;
  signal frame_credit_ready_INST_0_i_1_n_0 : STD_LOGIC;
  signal frame_credit_ready_INST_0_i_2_n_0 : STD_LOGIC;
  signal frame_credit_ready_INST_0_i_4_n_0 : STD_LOGIC;
  signal frame_credit_ready_INST_0_i_5_n_0 : STD_LOGIC;
  signal frame_credit_ready_INST_0_i_6_n_0 : STD_LOGIC;
  signal frame_credit_ready_INST_0_i_7_n_0 : STD_LOGIC;
  signal frame_credit_ready_INST_0_i_8_n_0 : STD_LOGIC;
  signal \grant_frame_id[0]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \grant_frame_id[0]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \grant_frame_id[0]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \grant_frame_id[0]_INST_0_i_4_n_0\ : STD_LOGIC;
  signal \grant_frame_id[0]_INST_0_n_0\ : STD_LOGIC;
  signal \grant_frame_id[0]_INST_0_n_1\ : STD_LOGIC;
  signal \grant_frame_id[0]_INST_0_n_2\ : STD_LOGIC;
  signal \grant_frame_id[0]_INST_0_n_3\ : STD_LOGIC;
  signal \grant_frame_id[12]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \grant_frame_id[12]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \grant_frame_id[12]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \grant_frame_id[12]_INST_0_i_4_n_0\ : STD_LOGIC;
  signal \grant_frame_id[12]_INST_0_n_0\ : STD_LOGIC;
  signal \grant_frame_id[12]_INST_0_n_1\ : STD_LOGIC;
  signal \grant_frame_id[12]_INST_0_n_2\ : STD_LOGIC;
  signal \grant_frame_id[12]_INST_0_n_3\ : STD_LOGIC;
  signal \grant_frame_id[16]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \grant_frame_id[16]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \grant_frame_id[16]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \grant_frame_id[16]_INST_0_i_4_n_0\ : STD_LOGIC;
  signal \grant_frame_id[16]_INST_0_n_0\ : STD_LOGIC;
  signal \grant_frame_id[16]_INST_0_n_1\ : STD_LOGIC;
  signal \grant_frame_id[16]_INST_0_n_2\ : STD_LOGIC;
  signal \grant_frame_id[16]_INST_0_n_3\ : STD_LOGIC;
  signal \grant_frame_id[20]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \grant_frame_id[20]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \grant_frame_id[20]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \grant_frame_id[20]_INST_0_i_4_n_0\ : STD_LOGIC;
  signal \grant_frame_id[20]_INST_0_n_0\ : STD_LOGIC;
  signal \grant_frame_id[20]_INST_0_n_1\ : STD_LOGIC;
  signal \grant_frame_id[20]_INST_0_n_2\ : STD_LOGIC;
  signal \grant_frame_id[20]_INST_0_n_3\ : STD_LOGIC;
  signal \grant_frame_id[24]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \grant_frame_id[24]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \grant_frame_id[24]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \grant_frame_id[24]_INST_0_i_4_n_0\ : STD_LOGIC;
  signal \grant_frame_id[24]_INST_0_n_0\ : STD_LOGIC;
  signal \grant_frame_id[24]_INST_0_n_1\ : STD_LOGIC;
  signal \grant_frame_id[24]_INST_0_n_2\ : STD_LOGIC;
  signal \grant_frame_id[24]_INST_0_n_3\ : STD_LOGIC;
  signal \grant_frame_id[28]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \grant_frame_id[28]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \grant_frame_id[28]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \grant_frame_id[28]_INST_0_i_4_n_0\ : STD_LOGIC;
  signal \grant_frame_id[28]_INST_0_n_0\ : STD_LOGIC;
  signal \grant_frame_id[28]_INST_0_n_1\ : STD_LOGIC;
  signal \grant_frame_id[28]_INST_0_n_2\ : STD_LOGIC;
  signal \grant_frame_id[28]_INST_0_n_3\ : STD_LOGIC;
  signal \grant_frame_id[4]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \grant_frame_id[4]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \grant_frame_id[4]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \grant_frame_id[4]_INST_0_i_4_n_0\ : STD_LOGIC;
  signal \grant_frame_id[4]_INST_0_n_0\ : STD_LOGIC;
  signal \grant_frame_id[4]_INST_0_n_1\ : STD_LOGIC;
  signal \grant_frame_id[4]_INST_0_n_2\ : STD_LOGIC;
  signal \grant_frame_id[4]_INST_0_n_3\ : STD_LOGIC;
  signal \grant_frame_id[8]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \grant_frame_id[8]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \grant_frame_id[8]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \grant_frame_id[8]_INST_0_i_4_n_0\ : STD_LOGIC;
  signal \grant_frame_id[8]_INST_0_n_0\ : STD_LOGIC;
  signal \grant_frame_id[8]_INST_0_n_1\ : STD_LOGIC;
  signal \grant_frame_id[8]_INST_0_n_2\ : STD_LOGIC;
  signal \grant_frame_id[8]_INST_0_n_3\ : STD_LOGIC;
  signal \grant_ready1_carry__0_n_0\ : STD_LOGIC;
  signal \grant_ready1_carry__0_n_1\ : STD_LOGIC;
  signal \grant_ready1_carry__0_n_2\ : STD_LOGIC;
  signal \grant_ready1_carry__0_n_3\ : STD_LOGIC;
  signal \grant_ready1_carry__1_n_0\ : STD_LOGIC;
  signal \grant_ready1_carry__1_n_1\ : STD_LOGIC;
  signal \grant_ready1_carry__1_n_2\ : STD_LOGIC;
  signal \grant_ready1_carry__1_n_3\ : STD_LOGIC;
  signal \grant_ready1_carry__2_n_1\ : STD_LOGIC;
  signal \grant_ready1_carry__2_n_2\ : STD_LOGIC;
  signal \grant_ready1_carry__2_n_3\ : STD_LOGIC;
  signal grant_ready1_carry_n_0 : STD_LOGIC;
  signal grant_ready1_carry_n_1 : STD_LOGIC;
  signal grant_ready1_carry_n_2 : STD_LOGIC;
  signal grant_ready1_carry_n_3 : STD_LOGIC;
  signal grant_ready40_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \grant_ready4_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__0_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__0_n_1\ : STD_LOGIC;
  signal \grant_ready4_carry__0_n_2\ : STD_LOGIC;
  signal \grant_ready4_carry__0_n_3\ : STD_LOGIC;
  signal \grant_ready4_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__1_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__1_n_1\ : STD_LOGIC;
  signal \grant_ready4_carry__1_n_2\ : STD_LOGIC;
  signal \grant_ready4_carry__1_n_3\ : STD_LOGIC;
  signal \grant_ready4_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__2_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__2_n_1\ : STD_LOGIC;
  signal \grant_ready4_carry__2_n_2\ : STD_LOGIC;
  signal \grant_ready4_carry__2_n_3\ : STD_LOGIC;
  signal \grant_ready4_carry__3_i_1_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__3_i_2_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__3_i_3_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__3_i_4_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__3_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__3_n_1\ : STD_LOGIC;
  signal \grant_ready4_carry__3_n_2\ : STD_LOGIC;
  signal \grant_ready4_carry__3_n_3\ : STD_LOGIC;
  signal \grant_ready4_carry__4_i_1_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__4_i_2_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__4_i_3_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__4_i_4_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__4_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__4_n_1\ : STD_LOGIC;
  signal \grant_ready4_carry__4_n_2\ : STD_LOGIC;
  signal \grant_ready4_carry__4_n_3\ : STD_LOGIC;
  signal \grant_ready4_carry__5_i_1_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__5_i_2_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__5_i_3_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__5_i_4_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__5_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__5_n_1\ : STD_LOGIC;
  signal \grant_ready4_carry__5_n_2\ : STD_LOGIC;
  signal \grant_ready4_carry__5_n_3\ : STD_LOGIC;
  signal \grant_ready4_carry__6_i_1_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__6_i_2_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__6_i_3_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__6_i_4_n_0\ : STD_LOGIC;
  signal \grant_ready4_carry__6_n_1\ : STD_LOGIC;
  signal \grant_ready4_carry__6_n_2\ : STD_LOGIC;
  signal \grant_ready4_carry__6_n_3\ : STD_LOGIC;
  signal grant_ready4_carry_i_1_n_0 : STD_LOGIC;
  signal grant_ready4_carry_i_2_n_0 : STD_LOGIC;
  signal grant_ready4_carry_i_3_n_0 : STD_LOGIC;
  signal grant_ready4_carry_i_4_n_0 : STD_LOGIC;
  signal grant_ready4_carry_n_0 : STD_LOGIC;
  signal grant_ready4_carry_n_1 : STD_LOGIC;
  signal grant_ready4_carry_n_2 : STD_LOGIC;
  signal grant_ready4_carry_n_3 : STD_LOGIC;
  signal \^grant_slot\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \granted_frames[3]_i_2_n_0\ : STD_LOGIC;
  signal \granted_frames_reg[11]_i_1_n_0\ : STD_LOGIC;
  signal \granted_frames_reg[11]_i_1_n_1\ : STD_LOGIC;
  signal \granted_frames_reg[11]_i_1_n_2\ : STD_LOGIC;
  signal \granted_frames_reg[11]_i_1_n_3\ : STD_LOGIC;
  signal \granted_frames_reg[11]_i_1_n_4\ : STD_LOGIC;
  signal \granted_frames_reg[11]_i_1_n_5\ : STD_LOGIC;
  signal \granted_frames_reg[11]_i_1_n_6\ : STD_LOGIC;
  signal \granted_frames_reg[11]_i_1_n_7\ : STD_LOGIC;
  signal \granted_frames_reg[15]_i_1_n_0\ : STD_LOGIC;
  signal \granted_frames_reg[15]_i_1_n_1\ : STD_LOGIC;
  signal \granted_frames_reg[15]_i_1_n_2\ : STD_LOGIC;
  signal \granted_frames_reg[15]_i_1_n_3\ : STD_LOGIC;
  signal \granted_frames_reg[15]_i_1_n_4\ : STD_LOGIC;
  signal \granted_frames_reg[15]_i_1_n_5\ : STD_LOGIC;
  signal \granted_frames_reg[15]_i_1_n_6\ : STD_LOGIC;
  signal \granted_frames_reg[15]_i_1_n_7\ : STD_LOGIC;
  signal \granted_frames_reg[19]_i_1_n_0\ : STD_LOGIC;
  signal \granted_frames_reg[19]_i_1_n_1\ : STD_LOGIC;
  signal \granted_frames_reg[19]_i_1_n_2\ : STD_LOGIC;
  signal \granted_frames_reg[19]_i_1_n_3\ : STD_LOGIC;
  signal \granted_frames_reg[19]_i_1_n_4\ : STD_LOGIC;
  signal \granted_frames_reg[19]_i_1_n_5\ : STD_LOGIC;
  signal \granted_frames_reg[19]_i_1_n_6\ : STD_LOGIC;
  signal \granted_frames_reg[19]_i_1_n_7\ : STD_LOGIC;
  signal \granted_frames_reg[23]_i_1_n_0\ : STD_LOGIC;
  signal \granted_frames_reg[23]_i_1_n_1\ : STD_LOGIC;
  signal \granted_frames_reg[23]_i_1_n_2\ : STD_LOGIC;
  signal \granted_frames_reg[23]_i_1_n_3\ : STD_LOGIC;
  signal \granted_frames_reg[23]_i_1_n_4\ : STD_LOGIC;
  signal \granted_frames_reg[23]_i_1_n_5\ : STD_LOGIC;
  signal \granted_frames_reg[23]_i_1_n_6\ : STD_LOGIC;
  signal \granted_frames_reg[23]_i_1_n_7\ : STD_LOGIC;
  signal \granted_frames_reg[27]_i_1_n_0\ : STD_LOGIC;
  signal \granted_frames_reg[27]_i_1_n_1\ : STD_LOGIC;
  signal \granted_frames_reg[27]_i_1_n_2\ : STD_LOGIC;
  signal \granted_frames_reg[27]_i_1_n_3\ : STD_LOGIC;
  signal \granted_frames_reg[27]_i_1_n_4\ : STD_LOGIC;
  signal \granted_frames_reg[27]_i_1_n_5\ : STD_LOGIC;
  signal \granted_frames_reg[27]_i_1_n_6\ : STD_LOGIC;
  signal \granted_frames_reg[27]_i_1_n_7\ : STD_LOGIC;
  signal \granted_frames_reg[31]_i_1_n_1\ : STD_LOGIC;
  signal \granted_frames_reg[31]_i_1_n_2\ : STD_LOGIC;
  signal \granted_frames_reg[31]_i_1_n_3\ : STD_LOGIC;
  signal \granted_frames_reg[31]_i_1_n_4\ : STD_LOGIC;
  signal \granted_frames_reg[31]_i_1_n_5\ : STD_LOGIC;
  signal \granted_frames_reg[31]_i_1_n_6\ : STD_LOGIC;
  signal \granted_frames_reg[31]_i_1_n_7\ : STD_LOGIC;
  signal \^granted_frames_reg[3]_0\ : STD_LOGIC;
  signal \granted_frames_reg[3]_i_1_n_0\ : STD_LOGIC;
  signal \granted_frames_reg[3]_i_1_n_1\ : STD_LOGIC;
  signal \granted_frames_reg[3]_i_1_n_2\ : STD_LOGIC;
  signal \granted_frames_reg[3]_i_1_n_3\ : STD_LOGIC;
  signal \granted_frames_reg[3]_i_1_n_4\ : STD_LOGIC;
  signal \granted_frames_reg[3]_i_1_n_5\ : STD_LOGIC;
  signal \granted_frames_reg[3]_i_1_n_6\ : STD_LOGIC;
  signal \granted_frames_reg[3]_i_1_n_7\ : STD_LOGIC;
  signal \granted_frames_reg[7]_i_1_n_0\ : STD_LOGIC;
  signal \granted_frames_reg[7]_i_1_n_1\ : STD_LOGIC;
  signal \granted_frames_reg[7]_i_1_n_2\ : STD_LOGIC;
  signal \granted_frames_reg[7]_i_1_n_3\ : STD_LOGIC;
  signal \granted_frames_reg[7]_i_1_n_4\ : STD_LOGIC;
  signal \granted_frames_reg[7]_i_1_n_5\ : STD_LOGIC;
  signal \granted_frames_reg[7]_i_1_n_6\ : STD_LOGIC;
  signal \granted_frames_reg[7]_i_1_n_7\ : STD_LOGIC;
  signal \i__carry__0_i_1__0_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_1_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_2__0_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_2_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_3__0_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_3_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_4__0_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_4_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_5_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_6_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_7_n_0\ : STD_LOGIC;
  signal \i__carry__0_i_8_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_1__0_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_1_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_2__0_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_2_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_3__0_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_3_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_4_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_5_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_6_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_7_n_0\ : STD_LOGIC;
  signal \i__carry__1_i_8_n_0\ : STD_LOGIC;
  signal \i__carry__2_i_1_n_0\ : STD_LOGIC;
  signal \i__carry__2_i_2_n_0\ : STD_LOGIC;
  signal \i__carry__2_i_3_n_0\ : STD_LOGIC;
  signal \i__carry__2_i_4_n_0\ : STD_LOGIC;
  signal \i__carry__2_i_5_n_0\ : STD_LOGIC;
  signal \i__carry__2_i_6_n_0\ : STD_LOGIC;
  signal \i__carry__2_i_7_n_0\ : STD_LOGIC;
  signal \i__carry__2_i_8_n_0\ : STD_LOGIC;
  signal \i__carry_i_1__0_n_0\ : STD_LOGIC;
  signal \i__carry_i_1_n_0\ : STD_LOGIC;
  signal \i__carry_i_2__0_n_0\ : STD_LOGIC;
  signal \i__carry_i_2_n_0\ : STD_LOGIC;
  signal \i__carry_i_3__0_n_0\ : STD_LOGIC;
  signal \i__carry_i_3_n_0\ : STD_LOGIC;
  signal \i__carry_i_4__0_n_0\ : STD_LOGIC;
  signal \i__carry_i_4_n_0\ : STD_LOGIC;
  signal \i__carry_i_5_n_0\ : STD_LOGIC;
  signal \i__carry_i_6_n_0\ : STD_LOGIC;
  signal \i__carry_i_7_n_0\ : STD_LOGIC;
  signal \i__carry_i_8_n_0\ : STD_LOGIC;
  signal \^out\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal owner_drained4 : STD_LOGIC;
  signal \owner_drained4_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \owner_drained4_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \owner_drained4_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \owner_drained4_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \owner_drained4_carry__0_n_0\ : STD_LOGIC;
  signal \owner_drained4_carry__0_n_1\ : STD_LOGIC;
  signal \owner_drained4_carry__0_n_2\ : STD_LOGIC;
  signal \owner_drained4_carry__0_n_3\ : STD_LOGIC;
  signal \owner_drained4_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \owner_drained4_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \owner_drained4_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \owner_drained4_carry__1_n_2\ : STD_LOGIC;
  signal \owner_drained4_carry__1_n_3\ : STD_LOGIC;
  signal owner_drained4_carry_i_1_n_0 : STD_LOGIC;
  signal owner_drained4_carry_i_2_n_0 : STD_LOGIC;
  signal owner_drained4_carry_i_3_n_0 : STD_LOGIC;
  signal owner_drained4_carry_i_4_n_0 : STD_LOGIC;
  signal owner_drained4_carry_n_0 : STD_LOGIC;
  signal owner_drained4_carry_n_1 : STD_LOGIC;
  signal owner_drained4_carry_n_2 : STD_LOGIC;
  signal owner_drained4_carry_n_3 : STD_LOGIC;
  signal owner_drained5 : STD_LOGIC;
  signal \owner_drained5_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \owner_drained5_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \owner_drained5_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \owner_drained5_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \owner_drained5_carry__0_n_0\ : STD_LOGIC;
  signal \owner_drained5_carry__0_n_1\ : STD_LOGIC;
  signal \owner_drained5_carry__0_n_2\ : STD_LOGIC;
  signal \owner_drained5_carry__0_n_3\ : STD_LOGIC;
  signal \owner_drained5_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \owner_drained5_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \owner_drained5_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \owner_drained5_carry__1_n_2\ : STD_LOGIC;
  signal \owner_drained5_carry__1_n_3\ : STD_LOGIC;
  signal owner_drained5_carry_i_1_n_0 : STD_LOGIC;
  signal owner_drained5_carry_i_2_n_0 : STD_LOGIC;
  signal owner_drained5_carry_i_3_n_0 : STD_LOGIC;
  signal owner_drained5_carry_i_4_n_0 : STD_LOGIC;
  signal owner_drained5_carry_n_0 : STD_LOGIC;
  signal owner_drained5_carry_n_1 : STD_LOGIC;
  signal owner_drained5_carry_n_2 : STD_LOGIC;
  signal owner_drained5_carry_n_3 : STD_LOGIC;
  signal owner_drained6 : STD_LOGIC;
  signal \owner_drained6_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \owner_drained6_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \owner_drained6_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \owner_drained6_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \owner_drained6_carry__0_n_0\ : STD_LOGIC;
  signal \owner_drained6_carry__0_n_1\ : STD_LOGIC;
  signal \owner_drained6_carry__0_n_2\ : STD_LOGIC;
  signal \owner_drained6_carry__0_n_3\ : STD_LOGIC;
  signal \owner_drained6_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \owner_drained6_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \owner_drained6_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \owner_drained6_carry__1_n_2\ : STD_LOGIC;
  signal \owner_drained6_carry__1_n_3\ : STD_LOGIC;
  signal owner_drained6_carry_i_1_n_0 : STD_LOGIC;
  signal owner_drained6_carry_i_2_n_0 : STD_LOGIC;
  signal owner_drained6_carry_i_3_n_0 : STD_LOGIC;
  signal owner_drained6_carry_i_4_n_0 : STD_LOGIC;
  signal owner_drained6_carry_n_0 : STD_LOGIC;
  signal owner_drained6_carry_n_1 : STD_LOGIC;
  signal owner_drained6_carry_n_2 : STD_LOGIC;
  signal owner_drained6_carry_n_3 : STD_LOGIC;
  signal owner_drained7 : STD_LOGIC;
  signal \owner_drained7_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \owner_drained7_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \owner_drained7_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \owner_drained7_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \owner_drained7_carry__0_n_0\ : STD_LOGIC;
  signal \owner_drained7_carry__0_n_1\ : STD_LOGIC;
  signal \owner_drained7_carry__0_n_2\ : STD_LOGIC;
  signal \owner_drained7_carry__0_n_3\ : STD_LOGIC;
  signal \owner_drained7_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \owner_drained7_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \owner_drained7_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \owner_drained7_carry__1_n_2\ : STD_LOGIC;
  signal \owner_drained7_carry__1_n_3\ : STD_LOGIC;
  signal owner_drained7_carry_i_1_n_0 : STD_LOGIC;
  signal owner_drained7_carry_i_2_n_0 : STD_LOGIC;
  signal owner_drained7_carry_i_3_n_0 : STD_LOGIC;
  signal owner_drained7_carry_i_4_n_0 : STD_LOGIC;
  signal owner_drained7_carry_n_0 : STD_LOGIC;
  signal owner_drained7_carry_n_1 : STD_LOGIC;
  signal owner_drained7_carry_n_2 : STD_LOGIC;
  signal owner_drained7_carry_n_3 : STD_LOGIC;
  signal owner_drained8 : STD_LOGIC;
  signal \owner_drained8_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \owner_drained8_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \owner_drained8_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \owner_drained8_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \owner_drained8_carry__0_n_0\ : STD_LOGIC;
  signal \owner_drained8_carry__0_n_1\ : STD_LOGIC;
  signal \owner_drained8_carry__0_n_2\ : STD_LOGIC;
  signal \owner_drained8_carry__0_n_3\ : STD_LOGIC;
  signal \owner_drained8_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \owner_drained8_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \owner_drained8_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \owner_drained8_carry__1_n_2\ : STD_LOGIC;
  signal \owner_drained8_carry__1_n_3\ : STD_LOGIC;
  signal owner_drained8_carry_i_1_n_0 : STD_LOGIC;
  signal owner_drained8_carry_i_2_n_0 : STD_LOGIC;
  signal owner_drained8_carry_i_3_n_0 : STD_LOGIC;
  signal owner_drained8_carry_i_4_n_0 : STD_LOGIC;
  signal owner_drained8_carry_n_0 : STD_LOGIC;
  signal owner_drained8_carry_n_1 : STD_LOGIC;
  signal owner_drained8_carry_n_2 : STD_LOGIC;
  signal owner_drained8_carry_n_3 : STD_LOGIC;
  signal owner_drained_INST_0_i_1_n_0 : STD_LOGIC;
  signal owner_drained_INST_0_i_2_n_0 : STD_LOGIC;
  signal owner_fault_INST_0_i_1_n_0 : STD_LOGIC;
  signal owner_fault_INST_0_i_2_n_0 : STD_LOGIC;
  signal owner_fault_INST_0_i_3_n_0 : STD_LOGIC;
  signal owner_fault_INST_0_i_4_n_0 : STD_LOGIC;
  signal \^owner_fault_causes\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal p_0_in28_in : STD_LOGIC;
  signal previous_packet : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal previous_rgb : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal previous_status : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal producer_slot : STD_LOGIC;
  signal \producer_slot[0]_i_1_n_0\ : STD_LOGIC;
  signal \producer_slot[1]_i_3_n_0\ : STD_LOGIC;
  signal \producer_slot[1]_i_4_n_0\ : STD_LOGIC;
  signal \producer_slot[1]_i_5_n_0\ : STD_LOGIC;
  signal \released_frames[3]_i_2_n_0\ : STD_LOGIC;
  signal \released_frames_reg[11]_i_1_n_0\ : STD_LOGIC;
  signal \released_frames_reg[11]_i_1_n_1\ : STD_LOGIC;
  signal \released_frames_reg[11]_i_1_n_2\ : STD_LOGIC;
  signal \released_frames_reg[11]_i_1_n_3\ : STD_LOGIC;
  signal \released_frames_reg[11]_i_1_n_4\ : STD_LOGIC;
  signal \released_frames_reg[11]_i_1_n_5\ : STD_LOGIC;
  signal \released_frames_reg[11]_i_1_n_6\ : STD_LOGIC;
  signal \released_frames_reg[11]_i_1_n_7\ : STD_LOGIC;
  signal \released_frames_reg[15]_i_1_n_0\ : STD_LOGIC;
  signal \released_frames_reg[15]_i_1_n_1\ : STD_LOGIC;
  signal \released_frames_reg[15]_i_1_n_2\ : STD_LOGIC;
  signal \released_frames_reg[15]_i_1_n_3\ : STD_LOGIC;
  signal \released_frames_reg[15]_i_1_n_4\ : STD_LOGIC;
  signal \released_frames_reg[15]_i_1_n_5\ : STD_LOGIC;
  signal \released_frames_reg[15]_i_1_n_6\ : STD_LOGIC;
  signal \released_frames_reg[15]_i_1_n_7\ : STD_LOGIC;
  signal \released_frames_reg[19]_i_1_n_0\ : STD_LOGIC;
  signal \released_frames_reg[19]_i_1_n_1\ : STD_LOGIC;
  signal \released_frames_reg[19]_i_1_n_2\ : STD_LOGIC;
  signal \released_frames_reg[19]_i_1_n_3\ : STD_LOGIC;
  signal \released_frames_reg[19]_i_1_n_4\ : STD_LOGIC;
  signal \released_frames_reg[19]_i_1_n_5\ : STD_LOGIC;
  signal \released_frames_reg[19]_i_1_n_6\ : STD_LOGIC;
  signal \released_frames_reg[19]_i_1_n_7\ : STD_LOGIC;
  signal \released_frames_reg[23]_i_1_n_0\ : STD_LOGIC;
  signal \released_frames_reg[23]_i_1_n_1\ : STD_LOGIC;
  signal \released_frames_reg[23]_i_1_n_2\ : STD_LOGIC;
  signal \released_frames_reg[23]_i_1_n_3\ : STD_LOGIC;
  signal \released_frames_reg[23]_i_1_n_4\ : STD_LOGIC;
  signal \released_frames_reg[23]_i_1_n_5\ : STD_LOGIC;
  signal \released_frames_reg[23]_i_1_n_6\ : STD_LOGIC;
  signal \released_frames_reg[23]_i_1_n_7\ : STD_LOGIC;
  signal \released_frames_reg[27]_i_1_n_0\ : STD_LOGIC;
  signal \released_frames_reg[27]_i_1_n_1\ : STD_LOGIC;
  signal \released_frames_reg[27]_i_1_n_2\ : STD_LOGIC;
  signal \released_frames_reg[27]_i_1_n_3\ : STD_LOGIC;
  signal \released_frames_reg[27]_i_1_n_4\ : STD_LOGIC;
  signal \released_frames_reg[27]_i_1_n_5\ : STD_LOGIC;
  signal \released_frames_reg[27]_i_1_n_6\ : STD_LOGIC;
  signal \released_frames_reg[27]_i_1_n_7\ : STD_LOGIC;
  signal \^released_frames_reg[31]_0\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \released_frames_reg[31]_i_1_n_1\ : STD_LOGIC;
  signal \released_frames_reg[31]_i_1_n_2\ : STD_LOGIC;
  signal \released_frames_reg[31]_i_1_n_3\ : STD_LOGIC;
  signal \released_frames_reg[31]_i_1_n_4\ : STD_LOGIC;
  signal \released_frames_reg[31]_i_1_n_5\ : STD_LOGIC;
  signal \released_frames_reg[31]_i_1_n_6\ : STD_LOGIC;
  signal \released_frames_reg[31]_i_1_n_7\ : STD_LOGIC;
  signal \released_frames_reg[3]_i_1_n_0\ : STD_LOGIC;
  signal \released_frames_reg[3]_i_1_n_1\ : STD_LOGIC;
  signal \released_frames_reg[3]_i_1_n_2\ : STD_LOGIC;
  signal \released_frames_reg[3]_i_1_n_3\ : STD_LOGIC;
  signal \released_frames_reg[3]_i_1_n_4\ : STD_LOGIC;
  signal \released_frames_reg[3]_i_1_n_5\ : STD_LOGIC;
  signal \released_frames_reg[3]_i_1_n_6\ : STD_LOGIC;
  signal \released_frames_reg[3]_i_1_n_7\ : STD_LOGIC;
  signal \released_frames_reg[7]_i_1_n_0\ : STD_LOGIC;
  signal \released_frames_reg[7]_i_1_n_1\ : STD_LOGIC;
  signal \released_frames_reg[7]_i_1_n_2\ : STD_LOGIC;
  signal \released_frames_reg[7]_i_1_n_3\ : STD_LOGIC;
  signal \released_frames_reg[7]_i_1_n_4\ : STD_LOGIC;
  signal \released_frames_reg[7]_i_1_n_5\ : STD_LOGIC;
  signal \released_frames_reg[7]_i_1_n_6\ : STD_LOGIC;
  signal \released_frames_reg[7]_i_1_n_7\ : STD_LOGIC;
  signal token_matches0 : STD_LOGIC;
  signal token_matches00_out : STD_LOGIC;
  signal \token_matches0_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \token_matches0_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \token_matches0_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \token_matches0_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \token_matches0_carry__0_n_0\ : STD_LOGIC;
  signal \token_matches0_carry__0_n_1\ : STD_LOGIC;
  signal \token_matches0_carry__0_n_2\ : STD_LOGIC;
  signal \token_matches0_carry__0_n_3\ : STD_LOGIC;
  signal \token_matches0_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \token_matches0_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \token_matches0_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \token_matches0_carry__1_n_2\ : STD_LOGIC;
  signal \token_matches0_carry__1_n_3\ : STD_LOGIC;
  signal token_matches0_carry_i_1_n_0 : STD_LOGIC;
  signal token_matches0_carry_i_2_n_0 : STD_LOGIC;
  signal token_matches0_carry_i_3_n_0 : STD_LOGIC;
  signal token_matches0_carry_i_4_n_0 : STD_LOGIC;
  signal token_matches0_carry_n_0 : STD_LOGIC;
  signal token_matches0_carry_n_1 : STD_LOGIC;
  signal token_matches0_carry_n_2 : STD_LOGIC;
  signal token_matches0_carry_n_3 : STD_LOGIC;
  signal \token_matches0_inferred__0/i__carry__0_n_0\ : STD_LOGIC;
  signal \token_matches0_inferred__0/i__carry__0_n_1\ : STD_LOGIC;
  signal \token_matches0_inferred__0/i__carry__0_n_2\ : STD_LOGIC;
  signal \token_matches0_inferred__0/i__carry__0_n_3\ : STD_LOGIC;
  signal \token_matches0_inferred__0/i__carry__1_n_2\ : STD_LOGIC;
  signal \token_matches0_inferred__0/i__carry__1_n_3\ : STD_LOGIC;
  signal \token_matches0_inferred__0/i__carry_n_0\ : STD_LOGIC;
  signal \token_matches0_inferred__0/i__carry_n_1\ : STD_LOGIC;
  signal \token_matches0_inferred__0/i__carry_n_2\ : STD_LOGIC;
  signal \token_matches0_inferred__0/i__carry_n_3\ : STD_LOGIC;
  signal NLW_closure_bad1_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_closure_bad1_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_closure_bad1_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_closure_bad1_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_closure_bad2_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_closure_bad2_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_closure_bad2_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_closure_bad2_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_configuration_bad1_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_configuration_bad1_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_configuration_bad1_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_configuration_bad1_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_configuration_bad2_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_configuration_bad2_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_configuration_bad2_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_configuration_bad2_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_consumer_identity_carry__6_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal NLW_counters_bad1_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad1_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad1_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad1_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_counters_bad2_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad2_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad2_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad2_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_counters_bad3_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad3_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad3_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad3_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_counters_bad4_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad4_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad4_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad4_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_counters_bad5_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad5_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad5_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad5_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad5_inferred__0/i__carry_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad5_inferred__0/i__carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad5_inferred__0/i__carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_counters_bad5_inferred__0/i__carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_cpu_available0_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_cpu_available0_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_cpu_available0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_cpu_available0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_cpu_available1_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_cpu_available1_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_cpu_available1_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_cpu_available1_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_cpu_available2_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_cpu_available2_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_cpu_available2_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_cpu_available2_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_cpu_available3_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_cpu_available3_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_cpu_available3_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_cpu_available3_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_fault_causes_reg[2]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_fault_causes_reg[2]_i_2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_grant_ready1_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_grant_ready1_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_grant_ready1_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_grant_ready1_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_grant_ready4_carry__6_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_granted_frames_reg[31]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal NLW_owner_drained4_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_owner_drained4_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_owner_drained4_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_owner_drained4_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_owner_drained5_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_owner_drained5_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_owner_drained5_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_owner_drained5_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_owner_drained6_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_owner_drained6_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_owner_drained6_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_owner_drained6_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_owner_drained7_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_owner_drained7_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_owner_drained7_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_owner_drained7_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_owner_drained8_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_owner_drained8_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_owner_drained8_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_owner_drained8_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_released_frames_reg[31]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal NLW_token_matches0_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_token_matches0_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_token_matches0_carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_token_matches0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_token_matches0_inferred__0/i__carry_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_token_matches0_inferred__0/i__carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_token_matches0_inferred__0/i__carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_token_matches0_inferred__0/i__carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of capture_fault_held_i_1 : label is "soft_lutpair16";
  attribute COMPARATOR_THRESHOLD : integer;
  attribute COMPARATOR_THRESHOLD of closure_bad1_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \closure_bad1_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \closure_bad1_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \closure_bad1_carry__2\ : label is 11;
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of consumer_identity_carry : label is 35;
  attribute ADDER_THRESHOLD of \consumer_identity_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \consumer_identity_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \consumer_identity_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of \consumer_identity_carry__3\ : label is 35;
  attribute ADDER_THRESHOLD of \consumer_identity_carry__4\ : label is 35;
  attribute ADDER_THRESHOLD of \consumer_identity_carry__5\ : label is 35;
  attribute ADDER_THRESHOLD of \consumer_identity_carry__6\ : label is 35;
  attribute SOFT_HLUTNM of \consumer_slot[0]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \consumer_slot[1]_i_1\ : label is "soft_lutpair18";
  attribute COMPARATOR_THRESHOLD of counters_bad1_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad1_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad1_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad1_carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of counters_bad2_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad2_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad2_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad2_carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of counters_bad3_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad3_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad3_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad3_carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of counters_bad4_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad4_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad4_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad4_carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of counters_bad5_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad5_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad5_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad5_carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad5_inferred__0/i__carry\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad5_inferred__0/i__carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad5_inferred__0/i__carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \counters_bad5_inferred__0/i__carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of cpu_available0_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \cpu_available0_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \cpu_available0_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \cpu_available0_carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of cpu_available1_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \cpu_available1_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \cpu_available1_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \cpu_available1_carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of cpu_available2_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \cpu_available2_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \cpu_available2_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \cpu_available2_carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of cpu_available3_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \cpu_available3_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \cpu_available3_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \cpu_available3_carry__2\ : label is 11;
  attribute SOFT_HLUTNM of cpu_available_INST_0 : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of cpu_held_i_2 : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \fault_causes[1]_i_2\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \fault_causes[1]_i_3\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \fault_causes[1]_i_4\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of frame_credit_ready_INST_0_i_1 : label is "soft_lutpair14";
  attribute COMPARATOR_THRESHOLD of grant_ready1_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \grant_ready1_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \grant_ready1_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \grant_ready1_carry__2\ : label is 11;
  attribute ADDER_THRESHOLD of grant_ready4_carry : label is 35;
  attribute ADDER_THRESHOLD of \grant_ready4_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \grant_ready4_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \grant_ready4_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of \grant_ready4_carry__3\ : label is 35;
  attribute ADDER_THRESHOLD of \grant_ready4_carry__4\ : label is 35;
  attribute ADDER_THRESHOLD of \grant_ready4_carry__5\ : label is 35;
  attribute ADDER_THRESHOLD of \grant_ready4_carry__6\ : label is 35;
  attribute ADDER_THRESHOLD of \granted_frames_reg[11]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \granted_frames_reg[15]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \granted_frames_reg[19]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \granted_frames_reg[23]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \granted_frames_reg[27]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \granted_frames_reg[31]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \granted_frames_reg[3]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \granted_frames_reg[7]_i_1\ : label is 35;
  attribute SOFT_HLUTNM of \producer_slot[0]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \producer_slot[1]_i_3\ : label is "soft_lutpair17";
  attribute ADDER_THRESHOLD of \released_frames_reg[11]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \released_frames_reg[15]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \released_frames_reg[19]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \released_frames_reg[23]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \released_frames_reg[27]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \released_frames_reg[31]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \released_frames_reg[3]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \released_frames_reg[7]_i_1\ : label is 35;
  attribute SOFT_HLUTNM of request_close_i_1 : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \source_gray[0]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \source_gray[1]_i_1\ : label is "soft_lutpair19";
begin
  CO(0) <= \^co\(0);
  Q(11 downto 0) <= \^q\(11 downto 0);
  available_epoch(31 downto 0) <= \^available_epoch\(31 downto 0);
  available_frame_id(31 downto 0) <= \^available_frame_id\(31 downto 0);
  available_slot(1 downto 0) <= \^available_slot\(1 downto 0);
  clear <= \^clear\;
  closure_held_reg_0 <= \^closure_held_reg_0\;
  configuration_locked <= \^configuration_locked\;
  configuration_locked1 <= \^configuration_locked1\;
  configuration_locked_reg_0 <= \^configuration_locked_reg_0\;
  cpu_held_reg_0 <= \^cpu_held_reg_0\;
  grant_slot(1 downto 0) <= \^grant_slot\(1 downto 0);
  \granted_frames_reg[3]_0\ <= \^granted_frames_reg[3]_0\;
  \out\(31 downto 0) <= \^out\(31 downto 0);
  owner_fault_causes(3 downto 0) <= \^owner_fault_causes\(3 downto 0);
  \released_frames_reg[31]_0\(31 downto 0) <= \^released_frames_reg[31]_0\(31 downto 0);
capture_fault_held_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \^configuration_locked_reg_0\,
      I1 => capture_fault_held,
      O => capture_fault_held_reg
    );
claim_accepted_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0008"
    )
        port map (
      I0 => cpu_held_i_3_n_0,
      I1 => common_aresetn,
      I2 => cpu_release,
      I3 => cpu_available_INST_0_i_1_n_0,
      O => claim_accepted_i_1_n_0
    );
claim_accepted_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => claim_accepted_i_1_n_0,
      Q => claim_accepted,
      R => '0'
    );
closure_bad1_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => closure_bad1_carry_n_0,
      CO(2) => closure_bad1_carry_n_1,
      CO(1) => closure_bad1_carry_n_2,
      CO(0) => closure_bad1_carry_n_3,
      CYINIT => '0',
      DI(3) => closure_bad1_carry_i_1_n_0,
      DI(2) => closure_bad1_carry_i_2_n_0,
      DI(1) => closure_bad1_carry_i_3_n_0,
      DI(0) => closure_bad1_carry_i_4_n_0,
      O(3 downto 0) => NLW_closure_bad1_carry_O_UNCONNECTED(3 downto 0),
      S(3 downto 0) => \closure_bad1_carry__0_0\(3 downto 0)
    );
\closure_bad1_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => closure_bad1_carry_n_0,
      CO(3) => \closure_bad1_carry__0_n_0\,
      CO(2) => \closure_bad1_carry__0_n_1\,
      CO(1) => \closure_bad1_carry__0_n_2\,
      CO(0) => \closure_bad1_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \closure_bad1_carry__0_i_1_n_0\,
      DI(2) => \closure_bad1_carry__0_i_2_n_0\,
      DI(1) => \closure_bad1_carry__0_i_3_n_0\,
      DI(0) => \closure_bad1_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_closure_bad1_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => \closure_bad1_carry__1_0\(3 downto 0)
    );
\closure_bad1_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(14),
      I1 => D(14),
      I2 => D(15),
      I3 => \^out\(15),
      O => \closure_bad1_carry__0_i_1_n_0\
    );
\closure_bad1_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(12),
      I1 => D(12),
      I2 => D(13),
      I3 => \^out\(13),
      O => \closure_bad1_carry__0_i_2_n_0\
    );
\closure_bad1_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(10),
      I1 => D(10),
      I2 => D(11),
      I3 => \^out\(11),
      O => \closure_bad1_carry__0_i_3_n_0\
    );
\closure_bad1_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(8),
      I1 => D(8),
      I2 => D(9),
      I3 => \^out\(9),
      O => \closure_bad1_carry__0_i_4_n_0\
    );
\closure_bad1_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \closure_bad1_carry__0_n_0\,
      CO(3) => \closure_bad1_carry__1_n_0\,
      CO(2) => \closure_bad1_carry__1_n_1\,
      CO(1) => \closure_bad1_carry__1_n_2\,
      CO(0) => \closure_bad1_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \closure_bad1_carry__1_i_1_n_0\,
      DI(2) => \closure_bad1_carry__1_i_2_n_0\,
      DI(1) => \closure_bad1_carry__1_i_3_n_0\,
      DI(0) => \closure_bad1_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_closure_bad1_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => \closure_bad1_carry__2_0\(3 downto 0)
    );
\closure_bad1_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(22),
      I1 => D(22),
      I2 => D(23),
      I3 => \^out\(23),
      O => \closure_bad1_carry__1_i_1_n_0\
    );
\closure_bad1_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(20),
      I1 => D(20),
      I2 => D(21),
      I3 => \^out\(21),
      O => \closure_bad1_carry__1_i_2_n_0\
    );
\closure_bad1_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(18),
      I1 => D(18),
      I2 => D(19),
      I3 => \^out\(19),
      O => \closure_bad1_carry__1_i_3_n_0\
    );
\closure_bad1_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(16),
      I1 => D(16),
      I2 => D(17),
      I3 => \^out\(17),
      O => \closure_bad1_carry__1_i_4_n_0\
    );
\closure_bad1_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \closure_bad1_carry__1_n_0\,
      CO(3) => closure_bad1,
      CO(2) => \closure_bad1_carry__2_n_1\,
      CO(1) => \closure_bad1_carry__2_n_2\,
      CO(0) => \closure_bad1_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \closure_bad1_carry__2_i_1_n_0\,
      DI(2) => \closure_bad1_carry__2_i_2_n_0\,
      DI(1) => \closure_bad1_carry__2_i_3_n_0\,
      DI(0) => \closure_bad1_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_closure_bad1_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => owner_fault_INST_0_i_1_1(3 downto 0)
    );
\closure_bad1_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(30),
      I1 => D(30),
      I2 => D(31),
      I3 => \^out\(31),
      O => \closure_bad1_carry__2_i_1_n_0\
    );
\closure_bad1_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(28),
      I1 => D(28),
      I2 => D(29),
      I3 => \^out\(29),
      O => \closure_bad1_carry__2_i_2_n_0\
    );
\closure_bad1_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(26),
      I1 => D(26),
      I2 => D(27),
      I3 => \^out\(27),
      O => \closure_bad1_carry__2_i_3_n_0\
    );
\closure_bad1_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(24),
      I1 => D(24),
      I2 => D(25),
      I3 => \^out\(25),
      O => \closure_bad1_carry__2_i_4_n_0\
    );
closure_bad1_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(6),
      I1 => D(6),
      I2 => D(7),
      I3 => \^out\(7),
      O => closure_bad1_carry_i_1_n_0
    );
closure_bad1_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(4),
      I1 => D(4),
      I2 => D(5),
      I3 => \^out\(5),
      O => closure_bad1_carry_i_2_n_0
    );
closure_bad1_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(2),
      I1 => D(2),
      I2 => D(3),
      I3 => \^out\(3),
      O => closure_bad1_carry_i_3_n_0
    );
closure_bad1_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^out\(0),
      I1 => D(0),
      I2 => D(1),
      I3 => \^out\(1),
      O => closure_bad1_carry_i_4_n_0
    );
closure_bad2_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => closure_bad2_carry_n_0,
      CO(2) => closure_bad2_carry_n_1,
      CO(1) => closure_bad2_carry_n_2,
      CO(0) => closure_bad2_carry_n_3,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => NLW_closure_bad2_carry_O_UNCONNECTED(3 downto 0),
      S(3) => closure_bad2_carry_i_1_n_0,
      S(2) => \closure_bad2_carry__0_0\(0),
      S(1) => closure_bad2_carry_i_3_n_0,
      S(0) => closure_bad2_carry_i_4_n_0
    );
\closure_bad2_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => closure_bad2_carry_n_0,
      CO(3) => \closure_bad2_carry__0_n_0\,
      CO(2) => \closure_bad2_carry__0_n_1\,
      CO(1) => \closure_bad2_carry__0_n_2\,
      CO(0) => \closure_bad2_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_closure_bad2_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3 downto 2) => \closure_bad2_carry__1_0\(1 downto 0),
      S(1) => \closure_bad2_carry__0_i_3_n_0\,
      S(0) => \closure_bad2_carry__0_i_4_n_0\
    );
\closure_bad2_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \final_frame_count_reg_n_0_[16]\,
      I1 => D(16),
      I2 => D(17),
      I3 => \final_frame_count_reg_n_0_[17]\,
      I4 => D(15),
      I5 => \final_frame_count_reg_n_0_[15]\,
      O => \closure_bad2_carry__0_i_3_n_0\
    );
\closure_bad2_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \final_frame_count_reg_n_0_[12]\,
      I1 => D(12),
      I2 => D(14),
      I3 => \final_frame_count_reg_n_0_[14]\,
      I4 => D(13),
      I5 => \final_frame_count_reg_n_0_[13]\,
      O => \closure_bad2_carry__0_i_4_n_0\
    );
\closure_bad2_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \closure_bad2_carry__0_n_0\,
      CO(3) => \NLW_closure_bad2_carry__1_CO_UNCONNECTED\(3),
      CO(2) => closure_bad2,
      CO(1) => \closure_bad2_carry__1_n_2\,
      CO(0) => \closure_bad2_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0111",
      O(3 downto 0) => \NLW_closure_bad2_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \closure_bad2_carry__1_i_1_n_0\,
      S(1) => \closure_bad2_carry__1_i_2_n_0\,
      S(0) => owner_fault_INST_0_i_1_0(0)
    );
\closure_bad2_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \final_frame_count_reg_n_0_[30]\,
      I1 => D(30),
      I2 => \final_frame_count_reg_n_0_[31]\,
      I3 => D(31),
      O => \closure_bad2_carry__1_i_1_n_0\
    );
\closure_bad2_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \final_frame_count_reg_n_0_[28]\,
      I1 => D(28),
      I2 => D(29),
      I3 => \final_frame_count_reg_n_0_[29]\,
      I4 => D(27),
      I5 => \final_frame_count_reg_n_0_[27]\,
      O => \closure_bad2_carry__1_i_2_n_0\
    );
closure_bad2_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \final_frame_count_reg_n_0_[10]\,
      I1 => D(10),
      I2 => D(11),
      I3 => \final_frame_count_reg_n_0_[11]\,
      I4 => D(9),
      I5 => \final_frame_count_reg_n_0_[9]\,
      O => closure_bad2_carry_i_1_n_0
    );
closure_bad2_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \final_frame_count_reg_n_0_[3]\,
      I1 => D(3),
      I2 => D(5),
      I3 => \final_frame_count_reg_n_0_[5]\,
      I4 => D(4),
      I5 => \final_frame_count_reg_n_0_[4]\,
      O => closure_bad2_carry_i_3_n_0
    );
closure_bad2_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \final_frame_count_reg_n_0_[1]\,
      I1 => D(1),
      I2 => D(2),
      I3 => \final_frame_count_reg_n_0_[2]\,
      I4 => D(0),
      I5 => \final_frame_count_reg_n_0_[0]\,
      O => closure_bad2_carry_i_4_n_0
    );
closure_held_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => closure_held_reg_1,
      Q => \^closure_held_reg_0\,
      R => \^clear\
    );
configuration_bad1_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => configuration_bad1_carry_n_0,
      CO(2) => configuration_bad1_carry_n_1,
      CO(1) => configuration_bad1_carry_n_2,
      CO(0) => configuration_bad1_carry_n_3,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => NLW_configuration_bad1_carry_O_UNCONNECTED(3 downto 0),
      S(3) => configuration_bad1_carry_i_1_n_0,
      S(2) => configuration_bad1_carry_i_2_n_0,
      S(1) => configuration_bad1_carry_i_3_n_0,
      S(0) => configuration_bad1_carry_i_4_n_0
    );
\configuration_bad1_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => configuration_bad1_carry_n_0,
      CO(3) => \configuration_bad1_carry__0_n_0\,
      CO(2) => \configuration_bad1_carry__0_n_1\,
      CO(1) => \configuration_bad1_carry__0_n_2\,
      CO(0) => \configuration_bad1_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_configuration_bad1_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \configuration_bad1_carry__0_i_1_n_0\,
      S(2) => \configuration_bad1_carry__0_i_2_n_0\,
      S(1) => \configuration_bad1_carry__0_i_3_n_0\,
      S(0) => \configuration_bad1_carry__0_i_4_n_0\
    );
\configuration_bad1_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(21),
      I1 => first_frame_id(21),
      I2 => cfg_frame_context(22),
      I3 => first_frame_id(22),
      I4 => first_frame_id(23),
      I5 => cfg_frame_context(23),
      O => \configuration_bad1_carry__0_i_1_n_0\
    );
\configuration_bad1_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(18),
      I1 => first_frame_id(18),
      I2 => cfg_frame_context(19),
      I3 => first_frame_id(19),
      I4 => first_frame_id(20),
      I5 => cfg_frame_context(20),
      O => \configuration_bad1_carry__0_i_2_n_0\
    );
\configuration_bad1_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(15),
      I1 => first_frame_id(15),
      I2 => cfg_frame_context(16),
      I3 => first_frame_id(16),
      I4 => first_frame_id(17),
      I5 => cfg_frame_context(17),
      O => \configuration_bad1_carry__0_i_3_n_0\
    );
\configuration_bad1_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(12),
      I1 => first_frame_id(12),
      I2 => cfg_frame_context(13),
      I3 => first_frame_id(13),
      I4 => first_frame_id(14),
      I5 => cfg_frame_context(14),
      O => \configuration_bad1_carry__0_i_4_n_0\
    );
\configuration_bad1_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \configuration_bad1_carry__0_n_0\,
      CO(3) => \NLW_configuration_bad1_carry__1_CO_UNCONNECTED\(3),
      CO(2) => configuration_bad1,
      CO(1) => \configuration_bad1_carry__1_n_2\,
      CO(0) => \configuration_bad1_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0111",
      O(3 downto 0) => \NLW_configuration_bad1_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \configuration_bad1_carry__1_i_1_n_0\,
      S(1) => \configuration_bad1_carry__1_i_2_n_0\,
      S(0) => \configuration_bad1_carry__1_i_3_n_0\
    );
\configuration_bad1_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => first_frame_id(31),
      I1 => cfg_frame_context(31),
      I2 => first_frame_id(30),
      I3 => cfg_frame_context(30),
      O => \configuration_bad1_carry__1_i_1_n_0\
    );
\configuration_bad1_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(27),
      I1 => first_frame_id(27),
      I2 => cfg_frame_context(28),
      I3 => first_frame_id(28),
      I4 => first_frame_id(29),
      I5 => cfg_frame_context(29),
      O => \configuration_bad1_carry__1_i_2_n_0\
    );
\configuration_bad1_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(25),
      I1 => first_frame_id(25),
      I2 => cfg_frame_context(24),
      I3 => first_frame_id(24),
      I4 => first_frame_id(26),
      I5 => cfg_frame_context(26),
      O => \configuration_bad1_carry__1_i_3_n_0\
    );
configuration_bad1_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(9),
      I1 => first_frame_id(9),
      I2 => cfg_frame_context(10),
      I3 => first_frame_id(10),
      I4 => first_frame_id(11),
      I5 => cfg_frame_context(11),
      O => configuration_bad1_carry_i_1_n_0
    );
configuration_bad1_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(6),
      I1 => first_frame_id(6),
      I2 => cfg_frame_context(7),
      I3 => first_frame_id(7),
      I4 => first_frame_id(8),
      I5 => cfg_frame_context(8),
      O => configuration_bad1_carry_i_2_n_0
    );
configuration_bad1_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(5),
      I1 => first_frame_id(5),
      I2 => cfg_frame_context(3),
      I3 => first_frame_id(3),
      I4 => first_frame_id(4),
      I5 => cfg_frame_context(4),
      O => configuration_bad1_carry_i_3_n_0
    );
configuration_bad1_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(0),
      I1 => first_frame_id(0),
      I2 => cfg_frame_context(1),
      I3 => first_frame_id(1),
      I4 => first_frame_id(2),
      I5 => cfg_frame_context(2),
      O => configuration_bad1_carry_i_4_n_0
    );
configuration_bad2_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => configuration_bad2_carry_n_0,
      CO(2) => configuration_bad2_carry_n_1,
      CO(1) => configuration_bad2_carry_n_2,
      CO(0) => configuration_bad2_carry_n_3,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => NLW_configuration_bad2_carry_O_UNCONNECTED(3 downto 0),
      S(3) => configuration_bad2_carry_i_1_n_0,
      S(2) => configuration_bad2_carry_i_2_n_0,
      S(1) => configuration_bad2_carry_i_3_n_0,
      S(0) => configuration_bad2_carry_i_4_n_0
    );
\configuration_bad2_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => configuration_bad2_carry_n_0,
      CO(3) => \configuration_bad2_carry__0_n_0\,
      CO(2) => \configuration_bad2_carry__0_n_1\,
      CO(1) => \configuration_bad2_carry__0_n_2\,
      CO(0) => \configuration_bad2_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_configuration_bad2_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \configuration_bad2_carry__0_i_1_n_0\,
      S(2) => \configuration_bad2_carry__0_i_2_n_0\,
      S(1) => \configuration_bad2_carry__0_i_3_n_0\,
      S(0) => \configuration_bad2_carry__0_i_4_n_0\
    );
\configuration_bad2_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(55),
      I1 => \^available_epoch\(23),
      I2 => cfg_frame_context(53),
      I3 => \^available_epoch\(21),
      I4 => \^available_epoch\(22),
      I5 => cfg_frame_context(54),
      O => \configuration_bad2_carry__0_i_1_n_0\
    );
\configuration_bad2_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(52),
      I1 => \^available_epoch\(20),
      I2 => cfg_frame_context(51),
      I3 => \^available_epoch\(19),
      I4 => \^available_epoch\(18),
      I5 => cfg_frame_context(50),
      O => \configuration_bad2_carry__0_i_2_n_0\
    );
\configuration_bad2_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(49),
      I1 => \^available_epoch\(17),
      I2 => cfg_frame_context(47),
      I3 => \^available_epoch\(15),
      I4 => \^available_epoch\(16),
      I5 => cfg_frame_context(48),
      O => \configuration_bad2_carry__0_i_3_n_0\
    );
\configuration_bad2_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(46),
      I1 => \^available_epoch\(14),
      I2 => cfg_frame_context(45),
      I3 => \^available_epoch\(13),
      I4 => \^available_epoch\(12),
      I5 => cfg_frame_context(44),
      O => \configuration_bad2_carry__0_i_4_n_0\
    );
\configuration_bad2_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \configuration_bad2_carry__0_n_0\,
      CO(3) => \NLW_configuration_bad2_carry__1_CO_UNCONNECTED\(3),
      CO(2) => \configuration_bad2_carry__1_n_1\,
      CO(1) => \configuration_bad2_carry__1_n_2\,
      CO(0) => \configuration_bad2_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0111",
      O(3 downto 0) => \NLW_configuration_bad2_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \configuration_bad2_carry__1_i_1_n_0\,
      S(1) => \configuration_bad2_carry__1_i_2_n_0\,
      S(0) => \configuration_bad2_carry__1_i_3_n_0\
    );
\configuration_bad2_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^available_epoch\(30),
      I1 => cfg_frame_context(62),
      I2 => \^available_epoch\(31),
      I3 => cfg_frame_context(63),
      O => \configuration_bad2_carry__1_i_1_n_0\
    );
\configuration_bad2_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(61),
      I1 => \^available_epoch\(29),
      I2 => cfg_frame_context(60),
      I3 => \^available_epoch\(28),
      I4 => \^available_epoch\(27),
      I5 => cfg_frame_context(59),
      O => \configuration_bad2_carry__1_i_2_n_0\
    );
\configuration_bad2_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(58),
      I1 => \^available_epoch\(26),
      I2 => cfg_frame_context(56),
      I3 => \^available_epoch\(24),
      I4 => \^available_epoch\(25),
      I5 => cfg_frame_context(57),
      O => \configuration_bad2_carry__1_i_3_n_0\
    );
configuration_bad2_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(43),
      I1 => \^available_epoch\(11),
      I2 => cfg_frame_context(41),
      I3 => \^available_epoch\(9),
      I4 => \^available_epoch\(10),
      I5 => cfg_frame_context(42),
      O => configuration_bad2_carry_i_1_n_0
    );
configuration_bad2_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(40),
      I1 => \^available_epoch\(8),
      I2 => cfg_frame_context(38),
      I3 => \^available_epoch\(6),
      I4 => \^available_epoch\(7),
      I5 => cfg_frame_context(39),
      O => configuration_bad2_carry_i_2_n_0
    );
configuration_bad2_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(37),
      I1 => \^available_epoch\(5),
      I2 => cfg_frame_context(36),
      I3 => \^available_epoch\(4),
      I4 => \^available_epoch\(3),
      I5 => cfg_frame_context(35),
      O => configuration_bad2_carry_i_3_n_0
    );
configuration_bad2_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cfg_frame_context(34),
      I1 => \^available_epoch\(2),
      I2 => cfg_frame_context(32),
      I3 => \^available_epoch\(0),
      I4 => \^available_epoch\(1),
      I5 => cfg_frame_context(33),
      O => configuration_bad2_carry_i_4_n_0
    );
configuration_locked_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => configuration_locked_reg_1,
      Q => \^configuration_locked\,
      R => \^clear\
    );
consumer_identity_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => consumer_identity_carry_n_0,
      CO(2) => consumer_identity_carry_n_1,
      CO(1) => consumer_identity_carry_n_2,
      CO(0) => consumer_identity_carry_n_3,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(3 downto 0),
      O(3 downto 0) => \^available_frame_id\(3 downto 0),
      S(3) => consumer_identity_carry_i_1_n_0,
      S(2) => consumer_identity_carry_i_2_n_0,
      S(1) => consumer_identity_carry_i_3_n_0,
      S(0) => consumer_identity_carry_i_4_n_0
    );
\consumer_identity_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => consumer_identity_carry_n_0,
      CO(3) => \consumer_identity_carry__0_n_0\,
      CO(2) => \consumer_identity_carry__0_n_1\,
      CO(1) => \consumer_identity_carry__0_n_2\,
      CO(0) => \consumer_identity_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(7 downto 4),
      O(3 downto 0) => \^available_frame_id\(7 downto 4),
      S(3) => \consumer_identity_carry__0_i_1_n_0\,
      S(2) => \consumer_identity_carry__0_i_2_n_0\,
      S(1) => \consumer_identity_carry__0_i_3_n_0\,
      S(0) => \consumer_identity_carry__0_i_4_n_0\
    );
\consumer_identity_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(7),
      I1 => \^released_frames_reg[31]_0\(7),
      O => \consumer_identity_carry__0_i_1_n_0\
    );
\consumer_identity_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(6),
      I1 => \^released_frames_reg[31]_0\(6),
      O => \consumer_identity_carry__0_i_2_n_0\
    );
\consumer_identity_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(5),
      I1 => \^released_frames_reg[31]_0\(5),
      O => \consumer_identity_carry__0_i_3_n_0\
    );
\consumer_identity_carry__0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(4),
      I1 => \^released_frames_reg[31]_0\(4),
      O => \consumer_identity_carry__0_i_4_n_0\
    );
\consumer_identity_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \consumer_identity_carry__0_n_0\,
      CO(3) => \consumer_identity_carry__1_n_0\,
      CO(2) => \consumer_identity_carry__1_n_1\,
      CO(1) => \consumer_identity_carry__1_n_2\,
      CO(0) => \consumer_identity_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(11 downto 8),
      O(3 downto 0) => \^available_frame_id\(11 downto 8),
      S(3) => \consumer_identity_carry__1_i_1_n_0\,
      S(2) => \consumer_identity_carry__1_i_2_n_0\,
      S(1) => \consumer_identity_carry__1_i_3_n_0\,
      S(0) => \consumer_identity_carry__1_i_4_n_0\
    );
\consumer_identity_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(11),
      I1 => \^released_frames_reg[31]_0\(11),
      O => \consumer_identity_carry__1_i_1_n_0\
    );
\consumer_identity_carry__1_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(10),
      I1 => \^released_frames_reg[31]_0\(10),
      O => \consumer_identity_carry__1_i_2_n_0\
    );
\consumer_identity_carry__1_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(9),
      I1 => \^released_frames_reg[31]_0\(9),
      O => \consumer_identity_carry__1_i_3_n_0\
    );
\consumer_identity_carry__1_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(8),
      I1 => \^released_frames_reg[31]_0\(8),
      O => \consumer_identity_carry__1_i_4_n_0\
    );
\consumer_identity_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \consumer_identity_carry__1_n_0\,
      CO(3) => \consumer_identity_carry__2_n_0\,
      CO(2) => \consumer_identity_carry__2_n_1\,
      CO(1) => \consumer_identity_carry__2_n_2\,
      CO(0) => \consumer_identity_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(15 downto 12),
      O(3 downto 0) => \^available_frame_id\(15 downto 12),
      S(3) => \consumer_identity_carry__2_i_1_n_0\,
      S(2) => \consumer_identity_carry__2_i_2_n_0\,
      S(1) => \consumer_identity_carry__2_i_3_n_0\,
      S(0) => \consumer_identity_carry__2_i_4_n_0\
    );
\consumer_identity_carry__2_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(15),
      I1 => \^released_frames_reg[31]_0\(15),
      O => \consumer_identity_carry__2_i_1_n_0\
    );
\consumer_identity_carry__2_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(14),
      I1 => \^released_frames_reg[31]_0\(14),
      O => \consumer_identity_carry__2_i_2_n_0\
    );
\consumer_identity_carry__2_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(13),
      I1 => \^released_frames_reg[31]_0\(13),
      O => \consumer_identity_carry__2_i_3_n_0\
    );
\consumer_identity_carry__2_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(12),
      I1 => \^released_frames_reg[31]_0\(12),
      O => \consumer_identity_carry__2_i_4_n_0\
    );
\consumer_identity_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \consumer_identity_carry__2_n_0\,
      CO(3) => \consumer_identity_carry__3_n_0\,
      CO(2) => \consumer_identity_carry__3_n_1\,
      CO(1) => \consumer_identity_carry__3_n_2\,
      CO(0) => \consumer_identity_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(19 downto 16),
      O(3 downto 0) => \^available_frame_id\(19 downto 16),
      S(3) => \consumer_identity_carry__3_i_1_n_0\,
      S(2) => \consumer_identity_carry__3_i_2_n_0\,
      S(1) => \consumer_identity_carry__3_i_3_n_0\,
      S(0) => \consumer_identity_carry__3_i_4_n_0\
    );
\consumer_identity_carry__3_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(19),
      I1 => \^released_frames_reg[31]_0\(19),
      O => \consumer_identity_carry__3_i_1_n_0\
    );
\consumer_identity_carry__3_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(18),
      I1 => \^released_frames_reg[31]_0\(18),
      O => \consumer_identity_carry__3_i_2_n_0\
    );
\consumer_identity_carry__3_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(17),
      I1 => \^released_frames_reg[31]_0\(17),
      O => \consumer_identity_carry__3_i_3_n_0\
    );
\consumer_identity_carry__3_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(16),
      I1 => \^released_frames_reg[31]_0\(16),
      O => \consumer_identity_carry__3_i_4_n_0\
    );
\consumer_identity_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \consumer_identity_carry__3_n_0\,
      CO(3) => \consumer_identity_carry__4_n_0\,
      CO(2) => \consumer_identity_carry__4_n_1\,
      CO(1) => \consumer_identity_carry__4_n_2\,
      CO(0) => \consumer_identity_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(23 downto 20),
      O(3 downto 0) => \^available_frame_id\(23 downto 20),
      S(3) => \consumer_identity_carry__4_i_1_n_0\,
      S(2) => \consumer_identity_carry__4_i_2_n_0\,
      S(1) => \consumer_identity_carry__4_i_3_n_0\,
      S(0) => \consumer_identity_carry__4_i_4_n_0\
    );
\consumer_identity_carry__4_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(23),
      I1 => \^released_frames_reg[31]_0\(23),
      O => \consumer_identity_carry__4_i_1_n_0\
    );
\consumer_identity_carry__4_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(22),
      I1 => \^released_frames_reg[31]_0\(22),
      O => \consumer_identity_carry__4_i_2_n_0\
    );
\consumer_identity_carry__4_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(21),
      I1 => \^released_frames_reg[31]_0\(21),
      O => \consumer_identity_carry__4_i_3_n_0\
    );
\consumer_identity_carry__4_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(20),
      I1 => \^released_frames_reg[31]_0\(20),
      O => \consumer_identity_carry__4_i_4_n_0\
    );
\consumer_identity_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \consumer_identity_carry__4_n_0\,
      CO(3) => \consumer_identity_carry__5_n_0\,
      CO(2) => \consumer_identity_carry__5_n_1\,
      CO(1) => \consumer_identity_carry__5_n_2\,
      CO(0) => \consumer_identity_carry__5_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(27 downto 24),
      O(3 downto 0) => \^available_frame_id\(27 downto 24),
      S(3) => \consumer_identity_carry__5_i_1_n_0\,
      S(2) => \consumer_identity_carry__5_i_2_n_0\,
      S(1) => \consumer_identity_carry__5_i_3_n_0\,
      S(0) => \consumer_identity_carry__5_i_4_n_0\
    );
\consumer_identity_carry__5_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(27),
      I1 => \^released_frames_reg[31]_0\(27),
      O => \consumer_identity_carry__5_i_1_n_0\
    );
\consumer_identity_carry__5_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(26),
      I1 => \^released_frames_reg[31]_0\(26),
      O => \consumer_identity_carry__5_i_2_n_0\
    );
\consumer_identity_carry__5_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(25),
      I1 => \^released_frames_reg[31]_0\(25),
      O => \consumer_identity_carry__5_i_3_n_0\
    );
\consumer_identity_carry__5_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(24),
      I1 => \^released_frames_reg[31]_0\(24),
      O => \consumer_identity_carry__5_i_4_n_0\
    );
\consumer_identity_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \consumer_identity_carry__5_n_0\,
      CO(3) => \NLW_consumer_identity_carry__6_CO_UNCONNECTED\(3),
      CO(2) => \consumer_identity_carry__6_n_1\,
      CO(1) => \consumer_identity_carry__6_n_2\,
      CO(0) => \consumer_identity_carry__6_n_3\,
      CYINIT => '0',
      DI(3) => '0',
      DI(2 downto 0) => first_frame_id(30 downto 28),
      O(3 downto 0) => \^available_frame_id\(31 downto 28),
      S(3) => \consumer_identity_carry__6_i_1_n_0\,
      S(2) => \consumer_identity_carry__6_i_2_n_0\,
      S(1) => \consumer_identity_carry__6_i_3_n_0\,
      S(0) => \consumer_identity_carry__6_i_4_n_0\
    );
\consumer_identity_carry__6_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(31),
      I1 => \^released_frames_reg[31]_0\(31),
      O => \consumer_identity_carry__6_i_1_n_0\
    );
\consumer_identity_carry__6_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(30),
      I1 => \^released_frames_reg[31]_0\(30),
      O => \consumer_identity_carry__6_i_2_n_0\
    );
\consumer_identity_carry__6_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(29),
      I1 => \^released_frames_reg[31]_0\(29),
      O => \consumer_identity_carry__6_i_3_n_0\
    );
\consumer_identity_carry__6_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(28),
      I1 => \^released_frames_reg[31]_0\(28),
      O => \consumer_identity_carry__6_i_4_n_0\
    );
consumer_identity_carry_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(3),
      I1 => \^released_frames_reg[31]_0\(3),
      O => consumer_identity_carry_i_1_n_0
    );
consumer_identity_carry_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(2),
      I1 => \^released_frames_reg[31]_0\(2),
      O => consumer_identity_carry_i_2_n_0
    );
consumer_identity_carry_i_3: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(1),
      I1 => \^released_frames_reg[31]_0\(1),
      O => consumer_identity_carry_i_3_n_0
    );
consumer_identity_carry_i_4: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(0),
      I1 => \^released_frames_reg[31]_0\(0),
      O => consumer_identity_carry_i_4_n_0
    );
\consumer_slot[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^available_slot\(1),
      I1 => \^available_slot\(0),
      O => \consumer_slot[0]_i_1_n_0\
    );
\consumer_slot[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"4"
    )
        port map (
      I0 => \^available_slot\(1),
      I1 => \^available_slot\(0),
      O => \consumer_slot[1]_i_1_n_0\
    );
\consumer_slot_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \consumer_slot[0]_i_1_n_0\,
      Q => \^available_slot\(0),
      R => \^clear\
    );
\consumer_slot_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \consumer_slot[1]_i_1_n_0\,
      Q => \^available_slot\(1),
      R => \^clear\
    );
counters_bad1_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => counters_bad1_carry_n_0,
      CO(2) => counters_bad1_carry_n_1,
      CO(1) => counters_bad1_carry_n_2,
      CO(0) => counters_bad1_carry_n_3,
      CYINIT => '0',
      DI(3) => counters_bad1_carry_i_1_n_0,
      DI(2) => counters_bad1_carry_i_2_n_0,
      DI(1) => counters_bad1_carry_i_3_n_0,
      DI(0) => counters_bad1_carry_i_4_n_0,
      O(3 downto 0) => NLW_counters_bad1_carry_O_UNCONNECTED(3 downto 0),
      S(3) => counters_bad1_carry_i_5_n_0,
      S(2) => counters_bad1_carry_i_6_n_0,
      S(1) => counters_bad1_carry_i_7_n_0,
      S(0) => counters_bad1_carry_i_8_n_0
    );
\counters_bad1_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => counters_bad1_carry_n_0,
      CO(3) => \counters_bad1_carry__0_n_0\,
      CO(2) => \counters_bad1_carry__0_n_1\,
      CO(1) => \counters_bad1_carry__0_n_2\,
      CO(0) => \counters_bad1_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad1_carry__0_i_1_n_0\,
      DI(2) => \counters_bad1_carry__0_i_2_n_0\,
      DI(1) => \counters_bad1_carry__0_i_3_n_0\,
      DI(0) => \counters_bad1_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad1_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad1_carry__0_i_5_n_0\,
      S(2) => \counters_bad1_carry__0_i_6_n_0\,
      S(1) => \counters_bad1_carry__0_i_7_n_0\,
      S(0) => \counters_bad1_carry__0_i_8_n_0\
    );
\counters_bad1_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(15),
      I1 => status_completed_frames(15),
      I2 => status_completed_frames(14),
      I3 => \^out\(14),
      O => \counters_bad1_carry__0_i_1_n_0\
    );
\counters_bad1_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(13),
      I1 => status_completed_frames(13),
      I2 => status_completed_frames(12),
      I3 => \^out\(12),
      O => \counters_bad1_carry__0_i_2_n_0\
    );
\counters_bad1_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(11),
      I1 => status_completed_frames(11),
      I2 => status_completed_frames(10),
      I3 => \^out\(10),
      O => \counters_bad1_carry__0_i_3_n_0\
    );
\counters_bad1_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(9),
      I1 => status_completed_frames(9),
      I2 => status_completed_frames(8),
      I3 => \^out\(8),
      O => \counters_bad1_carry__0_i_4_n_0\
    );
\counters_bad1_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(15),
      I1 => \^out\(15),
      I2 => status_completed_frames(14),
      I3 => \^out\(14),
      O => \counters_bad1_carry__0_i_5_n_0\
    );
\counters_bad1_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(13),
      I1 => \^out\(13),
      I2 => status_completed_frames(12),
      I3 => \^out\(12),
      O => \counters_bad1_carry__0_i_6_n_0\
    );
\counters_bad1_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(11),
      I1 => \^out\(11),
      I2 => status_completed_frames(10),
      I3 => \^out\(10),
      O => \counters_bad1_carry__0_i_7_n_0\
    );
\counters_bad1_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(9),
      I1 => \^out\(9),
      I2 => status_completed_frames(8),
      I3 => \^out\(8),
      O => \counters_bad1_carry__0_i_8_n_0\
    );
\counters_bad1_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \counters_bad1_carry__0_n_0\,
      CO(3) => \counters_bad1_carry__1_n_0\,
      CO(2) => \counters_bad1_carry__1_n_1\,
      CO(1) => \counters_bad1_carry__1_n_2\,
      CO(0) => \counters_bad1_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad1_carry__1_i_1_n_0\,
      DI(2) => \counters_bad1_carry__1_i_2_n_0\,
      DI(1) => \counters_bad1_carry__1_i_3_n_0\,
      DI(0) => \counters_bad1_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad1_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad1_carry__1_i_5_n_0\,
      S(2) => \counters_bad1_carry__1_i_6_n_0\,
      S(1) => \counters_bad1_carry__1_i_7_n_0\,
      S(0) => \counters_bad1_carry__1_i_8_n_0\
    );
\counters_bad1_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(23),
      I1 => status_completed_frames(23),
      I2 => status_completed_frames(22),
      I3 => \^out\(22),
      O => \counters_bad1_carry__1_i_1_n_0\
    );
\counters_bad1_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(21),
      I1 => status_completed_frames(21),
      I2 => status_completed_frames(20),
      I3 => \^out\(20),
      O => \counters_bad1_carry__1_i_2_n_0\
    );
\counters_bad1_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(19),
      I1 => status_completed_frames(19),
      I2 => status_completed_frames(18),
      I3 => \^out\(18),
      O => \counters_bad1_carry__1_i_3_n_0\
    );
\counters_bad1_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(17),
      I1 => status_completed_frames(17),
      I2 => status_completed_frames(16),
      I3 => \^out\(16),
      O => \counters_bad1_carry__1_i_4_n_0\
    );
\counters_bad1_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(23),
      I1 => \^out\(23),
      I2 => status_completed_frames(22),
      I3 => \^out\(22),
      O => \counters_bad1_carry__1_i_5_n_0\
    );
\counters_bad1_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(21),
      I1 => \^out\(21),
      I2 => status_completed_frames(20),
      I3 => \^out\(20),
      O => \counters_bad1_carry__1_i_6_n_0\
    );
\counters_bad1_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(19),
      I1 => \^out\(19),
      I2 => status_completed_frames(18),
      I3 => \^out\(18),
      O => \counters_bad1_carry__1_i_7_n_0\
    );
\counters_bad1_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(17),
      I1 => \^out\(17),
      I2 => status_completed_frames(16),
      I3 => \^out\(16),
      O => \counters_bad1_carry__1_i_8_n_0\
    );
\counters_bad1_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \counters_bad1_carry__1_n_0\,
      CO(3) => counters_bad1,
      CO(2) => \counters_bad1_carry__2_n_1\,
      CO(1) => \counters_bad1_carry__2_n_2\,
      CO(0) => \counters_bad1_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad1_carry__2_i_1_n_0\,
      DI(2) => \counters_bad1_carry__2_i_2_n_0\,
      DI(1) => \counters_bad1_carry__2_i_3_n_0\,
      DI(0) => \counters_bad1_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad1_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad1_carry__2_i_5_n_0\,
      S(2) => \counters_bad1_carry__2_i_6_n_0\,
      S(1) => \counters_bad1_carry__2_i_7_n_0\,
      S(0) => \counters_bad1_carry__2_i_8_n_0\
    );
\counters_bad1_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(31),
      I1 => status_completed_frames(31),
      I2 => status_completed_frames(30),
      I3 => \^out\(30),
      O => \counters_bad1_carry__2_i_1_n_0\
    );
\counters_bad1_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(29),
      I1 => status_completed_frames(29),
      I2 => status_completed_frames(28),
      I3 => \^out\(28),
      O => \counters_bad1_carry__2_i_2_n_0\
    );
\counters_bad1_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(27),
      I1 => status_completed_frames(27),
      I2 => status_completed_frames(26),
      I3 => \^out\(26),
      O => \counters_bad1_carry__2_i_3_n_0\
    );
\counters_bad1_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(25),
      I1 => status_completed_frames(25),
      I2 => status_completed_frames(24),
      I3 => \^out\(24),
      O => \counters_bad1_carry__2_i_4_n_0\
    );
\counters_bad1_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(31),
      I1 => \^out\(31),
      I2 => status_completed_frames(30),
      I3 => \^out\(30),
      O => \counters_bad1_carry__2_i_5_n_0\
    );
\counters_bad1_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(29),
      I1 => \^out\(29),
      I2 => status_completed_frames(28),
      I3 => \^out\(28),
      O => \counters_bad1_carry__2_i_6_n_0\
    );
\counters_bad1_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(27),
      I1 => \^out\(27),
      I2 => status_completed_frames(26),
      I3 => \^out\(26),
      O => \counters_bad1_carry__2_i_7_n_0\
    );
\counters_bad1_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(25),
      I1 => \^out\(25),
      I2 => status_completed_frames(24),
      I3 => \^out\(24),
      O => \counters_bad1_carry__2_i_8_n_0\
    );
counters_bad1_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(7),
      I1 => status_completed_frames(7),
      I2 => status_completed_frames(6),
      I3 => \^out\(6),
      O => counters_bad1_carry_i_1_n_0
    );
counters_bad1_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(5),
      I1 => status_completed_frames(5),
      I2 => status_completed_frames(4),
      I3 => \^out\(4),
      O => counters_bad1_carry_i_2_n_0
    );
counters_bad1_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(3),
      I1 => status_completed_frames(3),
      I2 => status_completed_frames(2),
      I3 => \^out\(2),
      O => counters_bad1_carry_i_3_n_0
    );
counters_bad1_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(1),
      I1 => status_completed_frames(1),
      I2 => status_completed_frames(0),
      I3 => \^out\(0),
      O => counters_bad1_carry_i_4_n_0
    );
counters_bad1_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(7),
      I1 => \^out\(7),
      I2 => status_completed_frames(6),
      I3 => \^out\(6),
      O => counters_bad1_carry_i_5_n_0
    );
counters_bad1_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(5),
      I1 => \^out\(5),
      I2 => status_completed_frames(4),
      I3 => \^out\(4),
      O => counters_bad1_carry_i_6_n_0
    );
counters_bad1_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(3),
      I1 => \^out\(3),
      I2 => status_completed_frames(2),
      I3 => \^out\(2),
      O => counters_bad1_carry_i_7_n_0
    );
counters_bad1_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(1),
      I1 => \^out\(1),
      I2 => status_completed_frames(0),
      I3 => \^out\(0),
      O => counters_bad1_carry_i_8_n_0
    );
counters_bad2_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => counters_bad2_carry_n_0,
      CO(2) => counters_bad2_carry_n_1,
      CO(1) => counters_bad2_carry_n_2,
      CO(0) => counters_bad2_carry_n_3,
      CYINIT => '0',
      DI(3) => counters_bad2_carry_i_1_n_0,
      DI(2) => counters_bad2_carry_i_2_n_0,
      DI(1) => counters_bad2_carry_i_3_n_0,
      DI(0) => counters_bad2_carry_i_4_n_0,
      O(3 downto 0) => NLW_counters_bad2_carry_O_UNCONNECTED(3 downto 0),
      S(3) => counters_bad2_carry_i_5_n_0,
      S(2) => counters_bad2_carry_i_6_n_0,
      S(1) => counters_bad2_carry_i_7_n_0,
      S(0) => counters_bad2_carry_i_8_n_0
    );
\counters_bad2_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => counters_bad2_carry_n_0,
      CO(3) => \counters_bad2_carry__0_n_0\,
      CO(2) => \counters_bad2_carry__0_n_1\,
      CO(1) => \counters_bad2_carry__0_n_2\,
      CO(0) => \counters_bad2_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad2_carry__0_i_1_n_0\,
      DI(2) => \counters_bad2_carry__0_i_2_n_0\,
      DI(1) => \counters_bad2_carry__0_i_3_n_0\,
      DI(0) => \counters_bad2_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad2_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad2_carry__0_i_5_n_0\,
      S(2) => \counters_bad2_carry__0_i_6_n_0\,
      S(1) => \counters_bad2_carry__0_i_7_n_0\,
      S(0) => \counters_bad2_carry__0_i_8_n_0\
    );
\counters_bad2_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(15),
      I1 => packet_completed_frames(15),
      I2 => packet_completed_frames(14),
      I3 => \^out\(14),
      O => \counters_bad2_carry__0_i_1_n_0\
    );
\counters_bad2_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(13),
      I1 => packet_completed_frames(13),
      I2 => packet_completed_frames(12),
      I3 => \^out\(12),
      O => \counters_bad2_carry__0_i_2_n_0\
    );
\counters_bad2_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(11),
      I1 => packet_completed_frames(11),
      I2 => packet_completed_frames(10),
      I3 => \^out\(10),
      O => \counters_bad2_carry__0_i_3_n_0\
    );
\counters_bad2_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(9),
      I1 => packet_completed_frames(9),
      I2 => packet_completed_frames(8),
      I3 => \^out\(8),
      O => \counters_bad2_carry__0_i_4_n_0\
    );
\counters_bad2_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(15),
      I1 => \^out\(15),
      I2 => packet_completed_frames(14),
      I3 => \^out\(14),
      O => \counters_bad2_carry__0_i_5_n_0\
    );
\counters_bad2_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(13),
      I1 => \^out\(13),
      I2 => packet_completed_frames(12),
      I3 => \^out\(12),
      O => \counters_bad2_carry__0_i_6_n_0\
    );
\counters_bad2_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(11),
      I1 => \^out\(11),
      I2 => packet_completed_frames(10),
      I3 => \^out\(10),
      O => \counters_bad2_carry__0_i_7_n_0\
    );
\counters_bad2_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(9),
      I1 => \^out\(9),
      I2 => packet_completed_frames(8),
      I3 => \^out\(8),
      O => \counters_bad2_carry__0_i_8_n_0\
    );
\counters_bad2_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \counters_bad2_carry__0_n_0\,
      CO(3) => \counters_bad2_carry__1_n_0\,
      CO(2) => \counters_bad2_carry__1_n_1\,
      CO(1) => \counters_bad2_carry__1_n_2\,
      CO(0) => \counters_bad2_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad2_carry__1_i_1_n_0\,
      DI(2) => \counters_bad2_carry__1_i_2_n_0\,
      DI(1) => \counters_bad2_carry__1_i_3_n_0\,
      DI(0) => \counters_bad2_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad2_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad2_carry__1_i_5_n_0\,
      S(2) => \counters_bad2_carry__1_i_6_n_0\,
      S(1) => \counters_bad2_carry__1_i_7_n_0\,
      S(0) => \counters_bad2_carry__1_i_8_n_0\
    );
\counters_bad2_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(23),
      I1 => packet_completed_frames(23),
      I2 => packet_completed_frames(22),
      I3 => \^out\(22),
      O => \counters_bad2_carry__1_i_1_n_0\
    );
\counters_bad2_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(21),
      I1 => packet_completed_frames(21),
      I2 => packet_completed_frames(20),
      I3 => \^out\(20),
      O => \counters_bad2_carry__1_i_2_n_0\
    );
\counters_bad2_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(19),
      I1 => packet_completed_frames(19),
      I2 => packet_completed_frames(18),
      I3 => \^out\(18),
      O => \counters_bad2_carry__1_i_3_n_0\
    );
\counters_bad2_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(17),
      I1 => packet_completed_frames(17),
      I2 => packet_completed_frames(16),
      I3 => \^out\(16),
      O => \counters_bad2_carry__1_i_4_n_0\
    );
\counters_bad2_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(23),
      I1 => \^out\(23),
      I2 => packet_completed_frames(22),
      I3 => \^out\(22),
      O => \counters_bad2_carry__1_i_5_n_0\
    );
\counters_bad2_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(21),
      I1 => \^out\(21),
      I2 => packet_completed_frames(20),
      I3 => \^out\(20),
      O => \counters_bad2_carry__1_i_6_n_0\
    );
\counters_bad2_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(19),
      I1 => \^out\(19),
      I2 => packet_completed_frames(18),
      I3 => \^out\(18),
      O => \counters_bad2_carry__1_i_7_n_0\
    );
\counters_bad2_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(17),
      I1 => \^out\(17),
      I2 => packet_completed_frames(16),
      I3 => \^out\(16),
      O => \counters_bad2_carry__1_i_8_n_0\
    );
\counters_bad2_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \counters_bad2_carry__1_n_0\,
      CO(3) => counters_bad2,
      CO(2) => \counters_bad2_carry__2_n_1\,
      CO(1) => \counters_bad2_carry__2_n_2\,
      CO(0) => \counters_bad2_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad2_carry__2_i_1_n_0\,
      DI(2) => \counters_bad2_carry__2_i_2_n_0\,
      DI(1) => \counters_bad2_carry__2_i_3_n_0\,
      DI(0) => \counters_bad2_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad2_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad2_carry__2_i_5_n_0\,
      S(2) => \counters_bad2_carry__2_i_6_n_0\,
      S(1) => \counters_bad2_carry__2_i_7_n_0\,
      S(0) => \counters_bad2_carry__2_i_8_n_0\
    );
\counters_bad2_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(31),
      I1 => packet_completed_frames(31),
      I2 => packet_completed_frames(30),
      I3 => \^out\(30),
      O => \counters_bad2_carry__2_i_1_n_0\
    );
\counters_bad2_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(29),
      I1 => packet_completed_frames(29),
      I2 => packet_completed_frames(28),
      I3 => \^out\(28),
      O => \counters_bad2_carry__2_i_2_n_0\
    );
\counters_bad2_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(27),
      I1 => packet_completed_frames(27),
      I2 => packet_completed_frames(26),
      I3 => \^out\(26),
      O => \counters_bad2_carry__2_i_3_n_0\
    );
\counters_bad2_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(25),
      I1 => packet_completed_frames(25),
      I2 => packet_completed_frames(24),
      I3 => \^out\(24),
      O => \counters_bad2_carry__2_i_4_n_0\
    );
\counters_bad2_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(31),
      I1 => \^out\(31),
      I2 => packet_completed_frames(30),
      I3 => \^out\(30),
      O => \counters_bad2_carry__2_i_5_n_0\
    );
\counters_bad2_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(29),
      I1 => \^out\(29),
      I2 => packet_completed_frames(28),
      I3 => \^out\(28),
      O => \counters_bad2_carry__2_i_6_n_0\
    );
\counters_bad2_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(27),
      I1 => \^out\(27),
      I2 => packet_completed_frames(26),
      I3 => \^out\(26),
      O => \counters_bad2_carry__2_i_7_n_0\
    );
\counters_bad2_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(25),
      I1 => \^out\(25),
      I2 => packet_completed_frames(24),
      I3 => \^out\(24),
      O => \counters_bad2_carry__2_i_8_n_0\
    );
counters_bad2_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(7),
      I1 => packet_completed_frames(7),
      I2 => packet_completed_frames(6),
      I3 => \^out\(6),
      O => counters_bad2_carry_i_1_n_0
    );
counters_bad2_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(5),
      I1 => packet_completed_frames(5),
      I2 => packet_completed_frames(4),
      I3 => \^out\(4),
      O => counters_bad2_carry_i_2_n_0
    );
counters_bad2_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(3),
      I1 => packet_completed_frames(3),
      I2 => packet_completed_frames(2),
      I3 => \^out\(2),
      O => counters_bad2_carry_i_3_n_0
    );
counters_bad2_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(1),
      I1 => packet_completed_frames(1),
      I2 => packet_completed_frames(0),
      I3 => \^out\(0),
      O => counters_bad2_carry_i_4_n_0
    );
counters_bad2_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(7),
      I1 => \^out\(7),
      I2 => packet_completed_frames(6),
      I3 => \^out\(6),
      O => counters_bad2_carry_i_5_n_0
    );
counters_bad2_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(5),
      I1 => \^out\(5),
      I2 => packet_completed_frames(4),
      I3 => \^out\(4),
      O => counters_bad2_carry_i_6_n_0
    );
counters_bad2_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(3),
      I1 => \^out\(3),
      I2 => packet_completed_frames(2),
      I3 => \^out\(2),
      O => counters_bad2_carry_i_7_n_0
    );
counters_bad2_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(1),
      I1 => \^out\(1),
      I2 => packet_completed_frames(0),
      I3 => \^out\(0),
      O => counters_bad2_carry_i_8_n_0
    );
counters_bad3_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => counters_bad3_carry_n_0,
      CO(2) => counters_bad3_carry_n_1,
      CO(1) => counters_bad3_carry_n_2,
      CO(0) => counters_bad3_carry_n_3,
      CYINIT => '0',
      DI(3) => counters_bad3_carry_i_1_n_0,
      DI(2) => counters_bad3_carry_i_2_n_0,
      DI(1) => counters_bad3_carry_i_3_n_0,
      DI(0) => counters_bad3_carry_i_4_n_0,
      O(3 downto 0) => NLW_counters_bad3_carry_O_UNCONNECTED(3 downto 0),
      S(3) => counters_bad3_carry_i_5_n_0,
      S(2) => counters_bad3_carry_i_6_n_0,
      S(1) => counters_bad3_carry_i_7_n_0,
      S(0) => counters_bad3_carry_i_8_n_0
    );
\counters_bad3_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => counters_bad3_carry_n_0,
      CO(3) => \counters_bad3_carry__0_n_0\,
      CO(2) => \counters_bad3_carry__0_n_1\,
      CO(1) => \counters_bad3_carry__0_n_2\,
      CO(0) => \counters_bad3_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad3_carry__0_i_1_n_0\,
      DI(2) => \counters_bad3_carry__0_i_2_n_0\,
      DI(1) => \counters_bad3_carry__0_i_3_n_0\,
      DI(0) => \counters_bad3_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad3_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad3_carry__0_i_5_n_0\,
      S(2) => \counters_bad3_carry__0_i_6_n_0\,
      S(1) => \counters_bad3_carry__0_i_7_n_0\,
      S(0) => \counters_bad3_carry__0_i_8_n_0\
    );
\counters_bad3_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(15),
      I1 => rgb_completed_frames(15),
      I2 => rgb_completed_frames(14),
      I3 => \^out\(14),
      O => \counters_bad3_carry__0_i_1_n_0\
    );
\counters_bad3_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(13),
      I1 => rgb_completed_frames(13),
      I2 => rgb_completed_frames(12),
      I3 => \^out\(12),
      O => \counters_bad3_carry__0_i_2_n_0\
    );
\counters_bad3_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(11),
      I1 => rgb_completed_frames(11),
      I2 => rgb_completed_frames(10),
      I3 => \^out\(10),
      O => \counters_bad3_carry__0_i_3_n_0\
    );
\counters_bad3_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(9),
      I1 => rgb_completed_frames(9),
      I2 => rgb_completed_frames(8),
      I3 => \^out\(8),
      O => \counters_bad3_carry__0_i_4_n_0\
    );
\counters_bad3_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(15),
      I1 => \^out\(15),
      I2 => rgb_completed_frames(14),
      I3 => \^out\(14),
      O => \counters_bad3_carry__0_i_5_n_0\
    );
\counters_bad3_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(13),
      I1 => \^out\(13),
      I2 => rgb_completed_frames(12),
      I3 => \^out\(12),
      O => \counters_bad3_carry__0_i_6_n_0\
    );
\counters_bad3_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(11),
      I1 => \^out\(11),
      I2 => rgb_completed_frames(10),
      I3 => \^out\(10),
      O => \counters_bad3_carry__0_i_7_n_0\
    );
\counters_bad3_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(9),
      I1 => \^out\(9),
      I2 => rgb_completed_frames(8),
      I3 => \^out\(8),
      O => \counters_bad3_carry__0_i_8_n_0\
    );
\counters_bad3_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \counters_bad3_carry__0_n_0\,
      CO(3) => \counters_bad3_carry__1_n_0\,
      CO(2) => \counters_bad3_carry__1_n_1\,
      CO(1) => \counters_bad3_carry__1_n_2\,
      CO(0) => \counters_bad3_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad3_carry__1_i_1_n_0\,
      DI(2) => \counters_bad3_carry__1_i_2_n_0\,
      DI(1) => \counters_bad3_carry__1_i_3_n_0\,
      DI(0) => \counters_bad3_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad3_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad3_carry__1_i_5_n_0\,
      S(2) => \counters_bad3_carry__1_i_6_n_0\,
      S(1) => \counters_bad3_carry__1_i_7_n_0\,
      S(0) => \counters_bad3_carry__1_i_8_n_0\
    );
\counters_bad3_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(23),
      I1 => rgb_completed_frames(23),
      I2 => rgb_completed_frames(22),
      I3 => \^out\(22),
      O => \counters_bad3_carry__1_i_1_n_0\
    );
\counters_bad3_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(21),
      I1 => rgb_completed_frames(21),
      I2 => rgb_completed_frames(20),
      I3 => \^out\(20),
      O => \counters_bad3_carry__1_i_2_n_0\
    );
\counters_bad3_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(19),
      I1 => rgb_completed_frames(19),
      I2 => rgb_completed_frames(18),
      I3 => \^out\(18),
      O => \counters_bad3_carry__1_i_3_n_0\
    );
\counters_bad3_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(17),
      I1 => rgb_completed_frames(17),
      I2 => rgb_completed_frames(16),
      I3 => \^out\(16),
      O => \counters_bad3_carry__1_i_4_n_0\
    );
\counters_bad3_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(23),
      I1 => \^out\(23),
      I2 => rgb_completed_frames(22),
      I3 => \^out\(22),
      O => \counters_bad3_carry__1_i_5_n_0\
    );
\counters_bad3_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(21),
      I1 => \^out\(21),
      I2 => rgb_completed_frames(20),
      I3 => \^out\(20),
      O => \counters_bad3_carry__1_i_6_n_0\
    );
\counters_bad3_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(19),
      I1 => \^out\(19),
      I2 => rgb_completed_frames(18),
      I3 => \^out\(18),
      O => \counters_bad3_carry__1_i_7_n_0\
    );
\counters_bad3_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(17),
      I1 => \^out\(17),
      I2 => rgb_completed_frames(16),
      I3 => \^out\(16),
      O => \counters_bad3_carry__1_i_8_n_0\
    );
\counters_bad3_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \counters_bad3_carry__1_n_0\,
      CO(3) => counters_bad3,
      CO(2) => \counters_bad3_carry__2_n_1\,
      CO(1) => \counters_bad3_carry__2_n_2\,
      CO(0) => \counters_bad3_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad3_carry__2_i_1_n_0\,
      DI(2) => \counters_bad3_carry__2_i_2_n_0\,
      DI(1) => \counters_bad3_carry__2_i_3_n_0\,
      DI(0) => \counters_bad3_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad3_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad3_carry__2_i_5_n_0\,
      S(2) => \counters_bad3_carry__2_i_6_n_0\,
      S(1) => \counters_bad3_carry__2_i_7_n_0\,
      S(0) => \counters_bad3_carry__2_i_8_n_0\
    );
\counters_bad3_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(31),
      I1 => rgb_completed_frames(31),
      I2 => rgb_completed_frames(30),
      I3 => \^out\(30),
      O => \counters_bad3_carry__2_i_1_n_0\
    );
\counters_bad3_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(29),
      I1 => rgb_completed_frames(29),
      I2 => rgb_completed_frames(28),
      I3 => \^out\(28),
      O => \counters_bad3_carry__2_i_2_n_0\
    );
\counters_bad3_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(27),
      I1 => rgb_completed_frames(27),
      I2 => rgb_completed_frames(26),
      I3 => \^out\(26),
      O => \counters_bad3_carry__2_i_3_n_0\
    );
\counters_bad3_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(25),
      I1 => rgb_completed_frames(25),
      I2 => rgb_completed_frames(24),
      I3 => \^out\(24),
      O => \counters_bad3_carry__2_i_4_n_0\
    );
\counters_bad3_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(31),
      I1 => \^out\(31),
      I2 => rgb_completed_frames(30),
      I3 => \^out\(30),
      O => \counters_bad3_carry__2_i_5_n_0\
    );
\counters_bad3_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(29),
      I1 => \^out\(29),
      I2 => rgb_completed_frames(28),
      I3 => \^out\(28),
      O => \counters_bad3_carry__2_i_6_n_0\
    );
\counters_bad3_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(27),
      I1 => \^out\(27),
      I2 => rgb_completed_frames(26),
      I3 => \^out\(26),
      O => \counters_bad3_carry__2_i_7_n_0\
    );
\counters_bad3_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(25),
      I1 => \^out\(25),
      I2 => rgb_completed_frames(24),
      I3 => \^out\(24),
      O => \counters_bad3_carry__2_i_8_n_0\
    );
counters_bad3_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(7),
      I1 => rgb_completed_frames(7),
      I2 => rgb_completed_frames(6),
      I3 => \^out\(6),
      O => counters_bad3_carry_i_1_n_0
    );
counters_bad3_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(5),
      I1 => rgb_completed_frames(5),
      I2 => rgb_completed_frames(4),
      I3 => \^out\(4),
      O => counters_bad3_carry_i_2_n_0
    );
counters_bad3_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(3),
      I1 => rgb_completed_frames(3),
      I2 => rgb_completed_frames(2),
      I3 => \^out\(2),
      O => counters_bad3_carry_i_3_n_0
    );
counters_bad3_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^out\(1),
      I1 => rgb_completed_frames(1),
      I2 => rgb_completed_frames(0),
      I3 => \^out\(0),
      O => counters_bad3_carry_i_4_n_0
    );
counters_bad3_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(7),
      I1 => \^out\(7),
      I2 => rgb_completed_frames(6),
      I3 => \^out\(6),
      O => counters_bad3_carry_i_5_n_0
    );
counters_bad3_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(5),
      I1 => \^out\(5),
      I2 => rgb_completed_frames(4),
      I3 => \^out\(4),
      O => counters_bad3_carry_i_6_n_0
    );
counters_bad3_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(3),
      I1 => \^out\(3),
      I2 => rgb_completed_frames(2),
      I3 => \^out\(2),
      O => counters_bad3_carry_i_7_n_0
    );
counters_bad3_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(1),
      I1 => \^out\(1),
      I2 => rgb_completed_frames(0),
      I3 => \^out\(0),
      O => counters_bad3_carry_i_8_n_0
    );
counters_bad4_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => counters_bad4_carry_n_0,
      CO(2) => counters_bad4_carry_n_1,
      CO(1) => counters_bad4_carry_n_2,
      CO(0) => counters_bad4_carry_n_3,
      CYINIT => '0',
      DI(3) => counters_bad4_carry_i_1_n_0,
      DI(2) => counters_bad4_carry_i_2_n_0,
      DI(1) => counters_bad4_carry_i_3_n_0,
      DI(0) => counters_bad4_carry_i_4_n_0,
      O(3 downto 0) => NLW_counters_bad4_carry_O_UNCONNECTED(3 downto 0),
      S(3) => counters_bad4_carry_i_5_n_0,
      S(2) => counters_bad4_carry_i_6_n_0,
      S(1) => counters_bad4_carry_i_7_n_0,
      S(0) => counters_bad4_carry_i_8_n_0
    );
\counters_bad4_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => counters_bad4_carry_n_0,
      CO(3) => \counters_bad4_carry__0_n_0\,
      CO(2) => \counters_bad4_carry__0_n_1\,
      CO(1) => \counters_bad4_carry__0_n_2\,
      CO(0) => \counters_bad4_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad4_carry__0_i_1_n_0\,
      DI(2) => \counters_bad4_carry__0_i_2_n_0\,
      DI(1) => \counters_bad4_carry__0_i_3_n_0\,
      DI(0) => \counters_bad4_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad4_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad4_carry__0_i_5_n_0\,
      S(2) => \counters_bad4_carry__0_i_6_n_0\,
      S(1) => \counters_bad4_carry__0_i_7_n_0\,
      S(0) => \counters_bad4_carry__0_i_8_n_0\
    );
\counters_bad4_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(15),
      I1 => previous_status(15),
      I2 => previous_status(14),
      I3 => status_completed_frames(14),
      O => \counters_bad4_carry__0_i_1_n_0\
    );
\counters_bad4_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(13),
      I1 => previous_status(13),
      I2 => previous_status(12),
      I3 => status_completed_frames(12),
      O => \counters_bad4_carry__0_i_2_n_0\
    );
\counters_bad4_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(11),
      I1 => previous_status(11),
      I2 => previous_status(10),
      I3 => status_completed_frames(10),
      O => \counters_bad4_carry__0_i_3_n_0\
    );
\counters_bad4_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(9),
      I1 => previous_status(9),
      I2 => previous_status(8),
      I3 => status_completed_frames(8),
      O => \counters_bad4_carry__0_i_4_n_0\
    );
\counters_bad4_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(15),
      I1 => status_completed_frames(15),
      I2 => previous_status(14),
      I3 => status_completed_frames(14),
      O => \counters_bad4_carry__0_i_5_n_0\
    );
\counters_bad4_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(13),
      I1 => status_completed_frames(13),
      I2 => previous_status(12),
      I3 => status_completed_frames(12),
      O => \counters_bad4_carry__0_i_6_n_0\
    );
\counters_bad4_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(11),
      I1 => status_completed_frames(11),
      I2 => previous_status(10),
      I3 => status_completed_frames(10),
      O => \counters_bad4_carry__0_i_7_n_0\
    );
\counters_bad4_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(9),
      I1 => status_completed_frames(9),
      I2 => previous_status(8),
      I3 => status_completed_frames(8),
      O => \counters_bad4_carry__0_i_8_n_0\
    );
\counters_bad4_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \counters_bad4_carry__0_n_0\,
      CO(3) => \counters_bad4_carry__1_n_0\,
      CO(2) => \counters_bad4_carry__1_n_1\,
      CO(1) => \counters_bad4_carry__1_n_2\,
      CO(0) => \counters_bad4_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad4_carry__1_i_1_n_0\,
      DI(2) => \counters_bad4_carry__1_i_2_n_0\,
      DI(1) => \counters_bad4_carry__1_i_3_n_0\,
      DI(0) => \counters_bad4_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad4_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad4_carry__1_i_5_n_0\,
      S(2) => \counters_bad4_carry__1_i_6_n_0\,
      S(1) => \counters_bad4_carry__1_i_7_n_0\,
      S(0) => \counters_bad4_carry__1_i_8_n_0\
    );
\counters_bad4_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(23),
      I1 => previous_status(23),
      I2 => previous_status(22),
      I3 => status_completed_frames(22),
      O => \counters_bad4_carry__1_i_1_n_0\
    );
\counters_bad4_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(21),
      I1 => previous_status(21),
      I2 => previous_status(20),
      I3 => status_completed_frames(20),
      O => \counters_bad4_carry__1_i_2_n_0\
    );
\counters_bad4_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(19),
      I1 => previous_status(19),
      I2 => previous_status(18),
      I3 => status_completed_frames(18),
      O => \counters_bad4_carry__1_i_3_n_0\
    );
\counters_bad4_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(17),
      I1 => previous_status(17),
      I2 => previous_status(16),
      I3 => status_completed_frames(16),
      O => \counters_bad4_carry__1_i_4_n_0\
    );
\counters_bad4_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(23),
      I1 => status_completed_frames(23),
      I2 => previous_status(22),
      I3 => status_completed_frames(22),
      O => \counters_bad4_carry__1_i_5_n_0\
    );
\counters_bad4_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(21),
      I1 => status_completed_frames(21),
      I2 => previous_status(20),
      I3 => status_completed_frames(20),
      O => \counters_bad4_carry__1_i_6_n_0\
    );
\counters_bad4_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(19),
      I1 => status_completed_frames(19),
      I2 => previous_status(18),
      I3 => status_completed_frames(18),
      O => \counters_bad4_carry__1_i_7_n_0\
    );
\counters_bad4_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(17),
      I1 => status_completed_frames(17),
      I2 => previous_status(16),
      I3 => status_completed_frames(16),
      O => \counters_bad4_carry__1_i_8_n_0\
    );
\counters_bad4_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \counters_bad4_carry__1_n_0\,
      CO(3) => counters_bad4,
      CO(2) => \counters_bad4_carry__2_n_1\,
      CO(1) => \counters_bad4_carry__2_n_2\,
      CO(0) => \counters_bad4_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad4_carry__2_i_1_n_0\,
      DI(2) => \counters_bad4_carry__2_i_2_n_0\,
      DI(1) => \counters_bad4_carry__2_i_3_n_0\,
      DI(0) => \counters_bad4_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad4_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad4_carry__2_i_5_n_0\,
      S(2) => \counters_bad4_carry__2_i_6_n_0\,
      S(1) => \counters_bad4_carry__2_i_7_n_0\,
      S(0) => \counters_bad4_carry__2_i_8_n_0\
    );
\counters_bad4_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(31),
      I1 => previous_status(31),
      I2 => previous_status(30),
      I3 => status_completed_frames(30),
      O => \counters_bad4_carry__2_i_1_n_0\
    );
\counters_bad4_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(29),
      I1 => previous_status(29),
      I2 => previous_status(28),
      I3 => status_completed_frames(28),
      O => \counters_bad4_carry__2_i_2_n_0\
    );
\counters_bad4_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(27),
      I1 => previous_status(27),
      I2 => previous_status(26),
      I3 => status_completed_frames(26),
      O => \counters_bad4_carry__2_i_3_n_0\
    );
\counters_bad4_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(25),
      I1 => previous_status(25),
      I2 => previous_status(24),
      I3 => status_completed_frames(24),
      O => \counters_bad4_carry__2_i_4_n_0\
    );
\counters_bad4_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(31),
      I1 => status_completed_frames(31),
      I2 => previous_status(30),
      I3 => status_completed_frames(30),
      O => \counters_bad4_carry__2_i_5_n_0\
    );
\counters_bad4_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(29),
      I1 => status_completed_frames(29),
      I2 => previous_status(28),
      I3 => status_completed_frames(28),
      O => \counters_bad4_carry__2_i_6_n_0\
    );
\counters_bad4_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(27),
      I1 => status_completed_frames(27),
      I2 => previous_status(26),
      I3 => status_completed_frames(26),
      O => \counters_bad4_carry__2_i_7_n_0\
    );
\counters_bad4_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(25),
      I1 => status_completed_frames(25),
      I2 => previous_status(24),
      I3 => status_completed_frames(24),
      O => \counters_bad4_carry__2_i_8_n_0\
    );
counters_bad4_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(7),
      I1 => previous_status(7),
      I2 => previous_status(6),
      I3 => status_completed_frames(6),
      O => counters_bad4_carry_i_1_n_0
    );
counters_bad4_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(5),
      I1 => previous_status(5),
      I2 => previous_status(4),
      I3 => status_completed_frames(4),
      O => counters_bad4_carry_i_2_n_0
    );
counters_bad4_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(3),
      I1 => previous_status(3),
      I2 => previous_status(2),
      I3 => status_completed_frames(2),
      O => counters_bad4_carry_i_3_n_0
    );
counters_bad4_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => status_completed_frames(1),
      I1 => previous_status(1),
      I2 => previous_status(0),
      I3 => status_completed_frames(0),
      O => counters_bad4_carry_i_4_n_0
    );
counters_bad4_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(7),
      I1 => status_completed_frames(7),
      I2 => previous_status(6),
      I3 => status_completed_frames(6),
      O => counters_bad4_carry_i_5_n_0
    );
counters_bad4_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(5),
      I1 => status_completed_frames(5),
      I2 => previous_status(4),
      I3 => status_completed_frames(4),
      O => counters_bad4_carry_i_6_n_0
    );
counters_bad4_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(3),
      I1 => status_completed_frames(3),
      I2 => previous_status(2),
      I3 => status_completed_frames(2),
      O => counters_bad4_carry_i_7_n_0
    );
counters_bad4_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => previous_status(1),
      I1 => status_completed_frames(1),
      I2 => previous_status(0),
      I3 => status_completed_frames(0),
      O => counters_bad4_carry_i_8_n_0
    );
counters_bad5_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => counters_bad5_carry_n_0,
      CO(2) => counters_bad5_carry_n_1,
      CO(1) => counters_bad5_carry_n_2,
      CO(0) => counters_bad5_carry_n_3,
      CYINIT => '0',
      DI(3) => counters_bad5_carry_i_1_n_0,
      DI(2) => counters_bad5_carry_i_2_n_0,
      DI(1) => counters_bad5_carry_i_3_n_0,
      DI(0) => counters_bad5_carry_i_4_n_0,
      O(3 downto 0) => NLW_counters_bad5_carry_O_UNCONNECTED(3 downto 0),
      S(3) => counters_bad5_carry_i_5_n_0,
      S(2) => counters_bad5_carry_i_6_n_0,
      S(1) => counters_bad5_carry_i_7_n_0,
      S(0) => counters_bad5_carry_i_8_n_0
    );
\counters_bad5_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => counters_bad5_carry_n_0,
      CO(3) => \counters_bad5_carry__0_n_0\,
      CO(2) => \counters_bad5_carry__0_n_1\,
      CO(1) => \counters_bad5_carry__0_n_2\,
      CO(0) => \counters_bad5_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad5_carry__0_i_1_n_0\,
      DI(2) => \counters_bad5_carry__0_i_2_n_0\,
      DI(1) => \counters_bad5_carry__0_i_3_n_0\,
      DI(0) => \counters_bad5_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad5_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad5_carry__0_i_5_n_0\,
      S(2) => \counters_bad5_carry__0_i_6_n_0\,
      S(1) => \counters_bad5_carry__0_i_7_n_0\,
      S(0) => \counters_bad5_carry__0_i_8_n_0\
    );
\counters_bad5_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(15),
      I1 => rgb_completed_frames(15),
      I2 => previous_rgb(14),
      I3 => rgb_completed_frames(14),
      O => \counters_bad5_carry__0_i_1_n_0\
    );
\counters_bad5_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(13),
      I1 => rgb_completed_frames(13),
      I2 => previous_rgb(12),
      I3 => rgb_completed_frames(12),
      O => \counters_bad5_carry__0_i_2_n_0\
    );
\counters_bad5_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(11),
      I1 => rgb_completed_frames(11),
      I2 => previous_rgb(10),
      I3 => rgb_completed_frames(10),
      O => \counters_bad5_carry__0_i_3_n_0\
    );
\counters_bad5_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(9),
      I1 => rgb_completed_frames(9),
      I2 => previous_rgb(8),
      I3 => rgb_completed_frames(8),
      O => \counters_bad5_carry__0_i_4_n_0\
    );
\counters_bad5_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(15),
      I1 => previous_rgb(15),
      I2 => rgb_completed_frames(14),
      I3 => previous_rgb(14),
      O => \counters_bad5_carry__0_i_5_n_0\
    );
\counters_bad5_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(13),
      I1 => previous_rgb(13),
      I2 => rgb_completed_frames(12),
      I3 => previous_rgb(12),
      O => \counters_bad5_carry__0_i_6_n_0\
    );
\counters_bad5_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(11),
      I1 => previous_rgb(11),
      I2 => rgb_completed_frames(10),
      I3 => previous_rgb(10),
      O => \counters_bad5_carry__0_i_7_n_0\
    );
\counters_bad5_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(9),
      I1 => previous_rgb(9),
      I2 => rgb_completed_frames(8),
      I3 => previous_rgb(8),
      O => \counters_bad5_carry__0_i_8_n_0\
    );
\counters_bad5_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \counters_bad5_carry__0_n_0\,
      CO(3) => \counters_bad5_carry__1_n_0\,
      CO(2) => \counters_bad5_carry__1_n_1\,
      CO(1) => \counters_bad5_carry__1_n_2\,
      CO(0) => \counters_bad5_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad5_carry__1_i_1_n_0\,
      DI(2) => \counters_bad5_carry__1_i_2_n_0\,
      DI(1) => \counters_bad5_carry__1_i_3_n_0\,
      DI(0) => \counters_bad5_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad5_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad5_carry__1_i_5_n_0\,
      S(2) => \counters_bad5_carry__1_i_6_n_0\,
      S(1) => \counters_bad5_carry__1_i_7_n_0\,
      S(0) => \counters_bad5_carry__1_i_8_n_0\
    );
\counters_bad5_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(23),
      I1 => rgb_completed_frames(23),
      I2 => previous_rgb(22),
      I3 => rgb_completed_frames(22),
      O => \counters_bad5_carry__1_i_1_n_0\
    );
\counters_bad5_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(21),
      I1 => rgb_completed_frames(21),
      I2 => previous_rgb(20),
      I3 => rgb_completed_frames(20),
      O => \counters_bad5_carry__1_i_2_n_0\
    );
\counters_bad5_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(19),
      I1 => rgb_completed_frames(19),
      I2 => previous_rgb(18),
      I3 => rgb_completed_frames(18),
      O => \counters_bad5_carry__1_i_3_n_0\
    );
\counters_bad5_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(17),
      I1 => rgb_completed_frames(17),
      I2 => previous_rgb(16),
      I3 => rgb_completed_frames(16),
      O => \counters_bad5_carry__1_i_4_n_0\
    );
\counters_bad5_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(23),
      I1 => previous_rgb(23),
      I2 => rgb_completed_frames(22),
      I3 => previous_rgb(22),
      O => \counters_bad5_carry__1_i_5_n_0\
    );
\counters_bad5_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(21),
      I1 => previous_rgb(21),
      I2 => rgb_completed_frames(20),
      I3 => previous_rgb(20),
      O => \counters_bad5_carry__1_i_6_n_0\
    );
\counters_bad5_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(19),
      I1 => previous_rgb(19),
      I2 => rgb_completed_frames(18),
      I3 => previous_rgb(18),
      O => \counters_bad5_carry__1_i_7_n_0\
    );
\counters_bad5_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(17),
      I1 => previous_rgb(17),
      I2 => rgb_completed_frames(16),
      I3 => previous_rgb(16),
      O => \counters_bad5_carry__1_i_8_n_0\
    );
\counters_bad5_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \counters_bad5_carry__1_n_0\,
      CO(3) => counters_bad54_in,
      CO(2) => \counters_bad5_carry__2_n_1\,
      CO(1) => \counters_bad5_carry__2_n_2\,
      CO(0) => \counters_bad5_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \counters_bad5_carry__2_i_1_n_0\,
      DI(2) => \counters_bad5_carry__2_i_2_n_0\,
      DI(1) => \counters_bad5_carry__2_i_3_n_0\,
      DI(0) => \counters_bad5_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad5_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \counters_bad5_carry__2_i_5_n_0\,
      S(2) => \counters_bad5_carry__2_i_6_n_0\,
      S(1) => \counters_bad5_carry__2_i_7_n_0\,
      S(0) => \counters_bad5_carry__2_i_8_n_0\
    );
\counters_bad5_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(31),
      I1 => rgb_completed_frames(31),
      I2 => previous_rgb(30),
      I3 => rgb_completed_frames(30),
      O => \counters_bad5_carry__2_i_1_n_0\
    );
\counters_bad5_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(29),
      I1 => rgb_completed_frames(29),
      I2 => previous_rgb(28),
      I3 => rgb_completed_frames(28),
      O => \counters_bad5_carry__2_i_2_n_0\
    );
\counters_bad5_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(27),
      I1 => rgb_completed_frames(27),
      I2 => previous_rgb(26),
      I3 => rgb_completed_frames(26),
      O => \counters_bad5_carry__2_i_3_n_0\
    );
\counters_bad5_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(25),
      I1 => rgb_completed_frames(25),
      I2 => previous_rgb(24),
      I3 => rgb_completed_frames(24),
      O => \counters_bad5_carry__2_i_4_n_0\
    );
\counters_bad5_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(31),
      I1 => previous_rgb(31),
      I2 => rgb_completed_frames(30),
      I3 => previous_rgb(30),
      O => \counters_bad5_carry__2_i_5_n_0\
    );
\counters_bad5_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(29),
      I1 => previous_rgb(29),
      I2 => rgb_completed_frames(28),
      I3 => previous_rgb(28),
      O => \counters_bad5_carry__2_i_6_n_0\
    );
\counters_bad5_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(27),
      I1 => previous_rgb(27),
      I2 => rgb_completed_frames(26),
      I3 => previous_rgb(26),
      O => \counters_bad5_carry__2_i_7_n_0\
    );
\counters_bad5_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(25),
      I1 => previous_rgb(25),
      I2 => rgb_completed_frames(24),
      I3 => previous_rgb(24),
      O => \counters_bad5_carry__2_i_8_n_0\
    );
counters_bad5_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(7),
      I1 => rgb_completed_frames(7),
      I2 => previous_rgb(6),
      I3 => rgb_completed_frames(6),
      O => counters_bad5_carry_i_1_n_0
    );
counters_bad5_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(5),
      I1 => rgb_completed_frames(5),
      I2 => previous_rgb(4),
      I3 => rgb_completed_frames(4),
      O => counters_bad5_carry_i_2_n_0
    );
counters_bad5_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(3),
      I1 => rgb_completed_frames(3),
      I2 => previous_rgb(2),
      I3 => rgb_completed_frames(2),
      O => counters_bad5_carry_i_3_n_0
    );
counters_bad5_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_rgb(1),
      I1 => rgb_completed_frames(1),
      I2 => previous_rgb(0),
      I3 => rgb_completed_frames(0),
      O => counters_bad5_carry_i_4_n_0
    );
counters_bad5_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(7),
      I1 => previous_rgb(7),
      I2 => rgb_completed_frames(6),
      I3 => previous_rgb(6),
      O => counters_bad5_carry_i_5_n_0
    );
counters_bad5_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(5),
      I1 => previous_rgb(5),
      I2 => rgb_completed_frames(4),
      I3 => previous_rgb(4),
      O => counters_bad5_carry_i_6_n_0
    );
counters_bad5_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(3),
      I1 => previous_rgb(3),
      I2 => rgb_completed_frames(2),
      I3 => previous_rgb(2),
      O => counters_bad5_carry_i_7_n_0
    );
counters_bad5_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(1),
      I1 => previous_rgb(1),
      I2 => rgb_completed_frames(0),
      I3 => previous_rgb(0),
      O => counters_bad5_carry_i_8_n_0
    );
\counters_bad5_inferred__0/i__carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \counters_bad5_inferred__0/i__carry_n_0\,
      CO(2) => \counters_bad5_inferred__0/i__carry_n_1\,
      CO(1) => \counters_bad5_inferred__0/i__carry_n_2\,
      CO(0) => \counters_bad5_inferred__0/i__carry_n_3\,
      CYINIT => '0',
      DI(3) => \i__carry_i_1_n_0\,
      DI(2) => \i__carry_i_2_n_0\,
      DI(1) => \i__carry_i_3_n_0\,
      DI(0) => \i__carry_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad5_inferred__0/i__carry_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry_i_5_n_0\,
      S(2) => \i__carry_i_6_n_0\,
      S(1) => \i__carry_i_7_n_0\,
      S(0) => \i__carry_i_8_n_0\
    );
\counters_bad5_inferred__0/i__carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \counters_bad5_inferred__0/i__carry_n_0\,
      CO(3) => \counters_bad5_inferred__0/i__carry__0_n_0\,
      CO(2) => \counters_bad5_inferred__0/i__carry__0_n_1\,
      CO(1) => \counters_bad5_inferred__0/i__carry__0_n_2\,
      CO(0) => \counters_bad5_inferred__0/i__carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \i__carry__0_i_1_n_0\,
      DI(2) => \i__carry__0_i_2_n_0\,
      DI(1) => \i__carry__0_i_3_n_0\,
      DI(0) => \i__carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad5_inferred__0/i__carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry__0_i_5_n_0\,
      S(2) => \i__carry__0_i_6_n_0\,
      S(1) => \i__carry__0_i_7_n_0\,
      S(0) => \i__carry__0_i_8_n_0\
    );
\counters_bad5_inferred__0/i__carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \counters_bad5_inferred__0/i__carry__0_n_0\,
      CO(3) => \counters_bad5_inferred__0/i__carry__1_n_0\,
      CO(2) => \counters_bad5_inferred__0/i__carry__1_n_1\,
      CO(1) => \counters_bad5_inferred__0/i__carry__1_n_2\,
      CO(0) => \counters_bad5_inferred__0/i__carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \i__carry__1_i_1_n_0\,
      DI(2) => \i__carry__1_i_2_n_0\,
      DI(1) => \i__carry__1_i_3_n_0\,
      DI(0) => \i__carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad5_inferred__0/i__carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry__1_i_5_n_0\,
      S(2) => \i__carry__1_i_6_n_0\,
      S(1) => \i__carry__1_i_7_n_0\,
      S(0) => \i__carry__1_i_8_n_0\
    );
\counters_bad5_inferred__0/i__carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \counters_bad5_inferred__0/i__carry__1_n_0\,
      CO(3) => counters_bad5,
      CO(2) => \counters_bad5_inferred__0/i__carry__2_n_1\,
      CO(1) => \counters_bad5_inferred__0/i__carry__2_n_2\,
      CO(0) => \counters_bad5_inferred__0/i__carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \i__carry__2_i_1_n_0\,
      DI(2) => \i__carry__2_i_2_n_0\,
      DI(1) => \i__carry__2_i_3_n_0\,
      DI(0) => \i__carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_counters_bad5_inferred__0/i__carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry__2_i_5_n_0\,
      S(2) => \i__carry__2_i_6_n_0\,
      S(1) => \i__carry__2_i_7_n_0\,
      S(0) => \i__carry__2_i_8_n_0\
    );
cpu_available0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => cpu_available0_carry_n_0,
      CO(2) => cpu_available0_carry_n_1,
      CO(1) => cpu_available0_carry_n_2,
      CO(0) => cpu_available0_carry_n_3,
      CYINIT => '0',
      DI(3) => cpu_available0_carry_i_1_n_0,
      DI(2) => cpu_available0_carry_i_2_n_0,
      DI(1) => cpu_available0_carry_i_3_n_0,
      DI(0) => cpu_available0_carry_i_4_n_0,
      O(3 downto 0) => NLW_cpu_available0_carry_O_UNCONNECTED(3 downto 0),
      S(3) => cpu_available0_carry_i_5_n_0,
      S(2) => cpu_available0_carry_i_6_n_0,
      S(1) => cpu_available0_carry_i_7_n_0,
      S(0) => cpu_available0_carry_i_8_n_0
    );
\cpu_available0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => cpu_available0_carry_n_0,
      CO(3) => \cpu_available0_carry__0_n_0\,
      CO(2) => \cpu_available0_carry__0_n_1\,
      CO(1) => \cpu_available0_carry__0_n_2\,
      CO(0) => \cpu_available0_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \cpu_available0_carry__0_i_1_n_0\,
      DI(2) => \cpu_available0_carry__0_i_2_n_0\,
      DI(1) => \cpu_available0_carry__0_i_3_n_0\,
      DI(0) => \cpu_available0_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_cpu_available0_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \cpu_available0_carry__0_i_5_n_0\,
      S(2) => \cpu_available0_carry__0_i_6_n_0\,
      S(1) => \cpu_available0_carry__0_i_7_n_0\,
      S(0) => \cpu_available0_carry__0_i_8_n_0\
    );
\cpu_available0_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(15),
      I1 => \^released_frames_reg[31]_0\(15),
      I2 => status_completed_frames(14),
      I3 => \^released_frames_reg[31]_0\(14),
      O => \cpu_available0_carry__0_i_1_n_0\
    );
\cpu_available0_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(13),
      I1 => \^released_frames_reg[31]_0\(13),
      I2 => status_completed_frames(12),
      I3 => \^released_frames_reg[31]_0\(12),
      O => \cpu_available0_carry__0_i_2_n_0\
    );
\cpu_available0_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(11),
      I1 => \^released_frames_reg[31]_0\(11),
      I2 => status_completed_frames(10),
      I3 => \^released_frames_reg[31]_0\(10),
      O => \cpu_available0_carry__0_i_3_n_0\
    );
\cpu_available0_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(9),
      I1 => \^released_frames_reg[31]_0\(9),
      I2 => status_completed_frames(8),
      I3 => \^released_frames_reg[31]_0\(8),
      O => \cpu_available0_carry__0_i_4_n_0\
    );
\cpu_available0_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(15),
      I1 => status_completed_frames(15),
      I2 => \^released_frames_reg[31]_0\(14),
      I3 => status_completed_frames(14),
      O => \cpu_available0_carry__0_i_5_n_0\
    );
\cpu_available0_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(13),
      I1 => status_completed_frames(13),
      I2 => \^released_frames_reg[31]_0\(12),
      I3 => status_completed_frames(12),
      O => \cpu_available0_carry__0_i_6_n_0\
    );
\cpu_available0_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(11),
      I1 => status_completed_frames(11),
      I2 => \^released_frames_reg[31]_0\(10),
      I3 => status_completed_frames(10),
      O => \cpu_available0_carry__0_i_7_n_0\
    );
\cpu_available0_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(9),
      I1 => status_completed_frames(9),
      I2 => \^released_frames_reg[31]_0\(8),
      I3 => status_completed_frames(8),
      O => \cpu_available0_carry__0_i_8_n_0\
    );
\cpu_available0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \cpu_available0_carry__0_n_0\,
      CO(3) => \cpu_available0_carry__1_n_0\,
      CO(2) => \cpu_available0_carry__1_n_1\,
      CO(1) => \cpu_available0_carry__1_n_2\,
      CO(0) => \cpu_available0_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \cpu_available0_carry__1_i_1_n_0\,
      DI(2) => \cpu_available0_carry__1_i_2_n_0\,
      DI(1) => \cpu_available0_carry__1_i_3_n_0\,
      DI(0) => \cpu_available0_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_cpu_available0_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \cpu_available0_carry__1_i_5_n_0\,
      S(2) => \cpu_available0_carry__1_i_6_n_0\,
      S(1) => \cpu_available0_carry__1_i_7_n_0\,
      S(0) => \cpu_available0_carry__1_i_8_n_0\
    );
\cpu_available0_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(23),
      I1 => \^released_frames_reg[31]_0\(23),
      I2 => status_completed_frames(22),
      I3 => \^released_frames_reg[31]_0\(22),
      O => \cpu_available0_carry__1_i_1_n_0\
    );
\cpu_available0_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(21),
      I1 => \^released_frames_reg[31]_0\(21),
      I2 => status_completed_frames(20),
      I3 => \^released_frames_reg[31]_0\(20),
      O => \cpu_available0_carry__1_i_2_n_0\
    );
\cpu_available0_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(19),
      I1 => \^released_frames_reg[31]_0\(19),
      I2 => status_completed_frames(18),
      I3 => \^released_frames_reg[31]_0\(18),
      O => \cpu_available0_carry__1_i_3_n_0\
    );
\cpu_available0_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(17),
      I1 => \^released_frames_reg[31]_0\(17),
      I2 => status_completed_frames(16),
      I3 => \^released_frames_reg[31]_0\(16),
      O => \cpu_available0_carry__1_i_4_n_0\
    );
\cpu_available0_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(23),
      I1 => status_completed_frames(23),
      I2 => \^released_frames_reg[31]_0\(22),
      I3 => status_completed_frames(22),
      O => \cpu_available0_carry__1_i_5_n_0\
    );
\cpu_available0_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(21),
      I1 => status_completed_frames(21),
      I2 => \^released_frames_reg[31]_0\(20),
      I3 => status_completed_frames(20),
      O => \cpu_available0_carry__1_i_6_n_0\
    );
\cpu_available0_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(19),
      I1 => status_completed_frames(19),
      I2 => \^released_frames_reg[31]_0\(18),
      I3 => status_completed_frames(18),
      O => \cpu_available0_carry__1_i_7_n_0\
    );
\cpu_available0_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(17),
      I1 => status_completed_frames(17),
      I2 => \^released_frames_reg[31]_0\(16),
      I3 => status_completed_frames(16),
      O => \cpu_available0_carry__1_i_8_n_0\
    );
\cpu_available0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \cpu_available0_carry__1_n_0\,
      CO(3) => cpu_available0,
      CO(2) => \cpu_available0_carry__2_n_1\,
      CO(1) => \cpu_available0_carry__2_n_2\,
      CO(0) => \cpu_available0_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \cpu_available0_carry__2_i_1_n_0\,
      DI(2) => \cpu_available0_carry__2_i_2_n_0\,
      DI(1) => \cpu_available0_carry__2_i_3_n_0\,
      DI(0) => \cpu_available0_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_cpu_available0_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \cpu_available0_carry__2_i_5_n_0\,
      S(2) => \cpu_available0_carry__2_i_6_n_0\,
      S(1) => \cpu_available0_carry__2_i_7_n_0\,
      S(0) => \cpu_available0_carry__2_i_8_n_0\
    );
\cpu_available0_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(31),
      I1 => \^released_frames_reg[31]_0\(31),
      I2 => status_completed_frames(30),
      I3 => \^released_frames_reg[31]_0\(30),
      O => \cpu_available0_carry__2_i_1_n_0\
    );
\cpu_available0_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(29),
      I1 => \^released_frames_reg[31]_0\(29),
      I2 => status_completed_frames(28),
      I3 => \^released_frames_reg[31]_0\(28),
      O => \cpu_available0_carry__2_i_2_n_0\
    );
\cpu_available0_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(27),
      I1 => \^released_frames_reg[31]_0\(27),
      I2 => status_completed_frames(26),
      I3 => \^released_frames_reg[31]_0\(26),
      O => \cpu_available0_carry__2_i_3_n_0\
    );
\cpu_available0_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(25),
      I1 => \^released_frames_reg[31]_0\(25),
      I2 => status_completed_frames(24),
      I3 => \^released_frames_reg[31]_0\(24),
      O => \cpu_available0_carry__2_i_4_n_0\
    );
\cpu_available0_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(31),
      I1 => status_completed_frames(31),
      I2 => \^released_frames_reg[31]_0\(30),
      I3 => status_completed_frames(30),
      O => \cpu_available0_carry__2_i_5_n_0\
    );
\cpu_available0_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(29),
      I1 => status_completed_frames(29),
      I2 => \^released_frames_reg[31]_0\(28),
      I3 => status_completed_frames(28),
      O => \cpu_available0_carry__2_i_6_n_0\
    );
\cpu_available0_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(27),
      I1 => status_completed_frames(27),
      I2 => \^released_frames_reg[31]_0\(26),
      I3 => status_completed_frames(26),
      O => \cpu_available0_carry__2_i_7_n_0\
    );
\cpu_available0_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(25),
      I1 => status_completed_frames(25),
      I2 => \^released_frames_reg[31]_0\(24),
      I3 => status_completed_frames(24),
      O => \cpu_available0_carry__2_i_8_n_0\
    );
cpu_available0_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(7),
      I1 => \^released_frames_reg[31]_0\(7),
      I2 => status_completed_frames(6),
      I3 => \^released_frames_reg[31]_0\(6),
      O => cpu_available0_carry_i_1_n_0
    );
cpu_available0_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(5),
      I1 => \^released_frames_reg[31]_0\(5),
      I2 => status_completed_frames(4),
      I3 => \^released_frames_reg[31]_0\(4),
      O => cpu_available0_carry_i_2_n_0
    );
cpu_available0_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(3),
      I1 => \^released_frames_reg[31]_0\(3),
      I2 => status_completed_frames(2),
      I3 => \^released_frames_reg[31]_0\(2),
      O => cpu_available0_carry_i_3_n_0
    );
cpu_available0_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => status_completed_frames(1),
      I1 => \^released_frames_reg[31]_0\(1),
      I2 => status_completed_frames(0),
      I3 => \^released_frames_reg[31]_0\(0),
      O => cpu_available0_carry_i_4_n_0
    );
cpu_available0_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(7),
      I1 => status_completed_frames(7),
      I2 => \^released_frames_reg[31]_0\(6),
      I3 => status_completed_frames(6),
      O => cpu_available0_carry_i_5_n_0
    );
cpu_available0_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(5),
      I1 => status_completed_frames(5),
      I2 => \^released_frames_reg[31]_0\(4),
      I3 => status_completed_frames(4),
      O => cpu_available0_carry_i_6_n_0
    );
cpu_available0_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(3),
      I1 => status_completed_frames(3),
      I2 => \^released_frames_reg[31]_0\(2),
      I3 => status_completed_frames(2),
      O => cpu_available0_carry_i_7_n_0
    );
cpu_available0_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(1),
      I1 => status_completed_frames(1),
      I2 => \^released_frames_reg[31]_0\(0),
      I3 => status_completed_frames(0),
      O => cpu_available0_carry_i_8_n_0
    );
cpu_available1_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => cpu_available1_carry_n_0,
      CO(2) => cpu_available1_carry_n_1,
      CO(1) => cpu_available1_carry_n_2,
      CO(0) => cpu_available1_carry_n_3,
      CYINIT => '0',
      DI(3) => cpu_available1_carry_i_1_n_0,
      DI(2) => cpu_available1_carry_i_2_n_0,
      DI(1) => cpu_available1_carry_i_3_n_0,
      DI(0) => cpu_available1_carry_i_4_n_0,
      O(3 downto 0) => NLW_cpu_available1_carry_O_UNCONNECTED(3 downto 0),
      S(3) => cpu_available1_carry_i_5_n_0,
      S(2) => cpu_available1_carry_i_6_n_0,
      S(1) => cpu_available1_carry_i_7_n_0,
      S(0) => cpu_available1_carry_i_8_n_0
    );
\cpu_available1_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => cpu_available1_carry_n_0,
      CO(3) => \cpu_available1_carry__0_n_0\,
      CO(2) => \cpu_available1_carry__0_n_1\,
      CO(1) => \cpu_available1_carry__0_n_2\,
      CO(0) => \cpu_available1_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \cpu_available1_carry__0_i_1_n_0\,
      DI(2) => \cpu_available1_carry__0_i_2_n_0\,
      DI(1) => \cpu_available1_carry__0_i_3_n_0\,
      DI(0) => \cpu_available1_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_cpu_available1_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \cpu_available1_carry__0_i_5_n_0\,
      S(2) => \cpu_available1_carry__0_i_6_n_0\,
      S(1) => \cpu_available1_carry__0_i_7_n_0\,
      S(0) => \cpu_available1_carry__0_i_8_n_0\
    );
\cpu_available1_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(15),
      I1 => \^released_frames_reg[31]_0\(15),
      I2 => packet_completed_frames(14),
      I3 => \^released_frames_reg[31]_0\(14),
      O => \cpu_available1_carry__0_i_1_n_0\
    );
\cpu_available1_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(13),
      I1 => \^released_frames_reg[31]_0\(13),
      I2 => packet_completed_frames(12),
      I3 => \^released_frames_reg[31]_0\(12),
      O => \cpu_available1_carry__0_i_2_n_0\
    );
\cpu_available1_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(11),
      I1 => \^released_frames_reg[31]_0\(11),
      I2 => packet_completed_frames(10),
      I3 => \^released_frames_reg[31]_0\(10),
      O => \cpu_available1_carry__0_i_3_n_0\
    );
\cpu_available1_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(9),
      I1 => \^released_frames_reg[31]_0\(9),
      I2 => packet_completed_frames(8),
      I3 => \^released_frames_reg[31]_0\(8),
      O => \cpu_available1_carry__0_i_4_n_0\
    );
\cpu_available1_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(15),
      I1 => packet_completed_frames(15),
      I2 => \^released_frames_reg[31]_0\(14),
      I3 => packet_completed_frames(14),
      O => \cpu_available1_carry__0_i_5_n_0\
    );
\cpu_available1_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(13),
      I1 => packet_completed_frames(13),
      I2 => \^released_frames_reg[31]_0\(12),
      I3 => packet_completed_frames(12),
      O => \cpu_available1_carry__0_i_6_n_0\
    );
\cpu_available1_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(11),
      I1 => packet_completed_frames(11),
      I2 => \^released_frames_reg[31]_0\(10),
      I3 => packet_completed_frames(10),
      O => \cpu_available1_carry__0_i_7_n_0\
    );
\cpu_available1_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(9),
      I1 => packet_completed_frames(9),
      I2 => \^released_frames_reg[31]_0\(8),
      I3 => packet_completed_frames(8),
      O => \cpu_available1_carry__0_i_8_n_0\
    );
\cpu_available1_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \cpu_available1_carry__0_n_0\,
      CO(3) => \cpu_available1_carry__1_n_0\,
      CO(2) => \cpu_available1_carry__1_n_1\,
      CO(1) => \cpu_available1_carry__1_n_2\,
      CO(0) => \cpu_available1_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \cpu_available1_carry__1_i_1_n_0\,
      DI(2) => \cpu_available1_carry__1_i_2_n_0\,
      DI(1) => \cpu_available1_carry__1_i_3_n_0\,
      DI(0) => \cpu_available1_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_cpu_available1_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \cpu_available1_carry__1_i_5_n_0\,
      S(2) => \cpu_available1_carry__1_i_6_n_0\,
      S(1) => \cpu_available1_carry__1_i_7_n_0\,
      S(0) => \cpu_available1_carry__1_i_8_n_0\
    );
\cpu_available1_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(23),
      I1 => \^released_frames_reg[31]_0\(23),
      I2 => packet_completed_frames(22),
      I3 => \^released_frames_reg[31]_0\(22),
      O => \cpu_available1_carry__1_i_1_n_0\
    );
\cpu_available1_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(21),
      I1 => \^released_frames_reg[31]_0\(21),
      I2 => packet_completed_frames(20),
      I3 => \^released_frames_reg[31]_0\(20),
      O => \cpu_available1_carry__1_i_2_n_0\
    );
\cpu_available1_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(19),
      I1 => \^released_frames_reg[31]_0\(19),
      I2 => packet_completed_frames(18),
      I3 => \^released_frames_reg[31]_0\(18),
      O => \cpu_available1_carry__1_i_3_n_0\
    );
\cpu_available1_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(17),
      I1 => \^released_frames_reg[31]_0\(17),
      I2 => packet_completed_frames(16),
      I3 => \^released_frames_reg[31]_0\(16),
      O => \cpu_available1_carry__1_i_4_n_0\
    );
\cpu_available1_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(23),
      I1 => packet_completed_frames(23),
      I2 => \^released_frames_reg[31]_0\(22),
      I3 => packet_completed_frames(22),
      O => \cpu_available1_carry__1_i_5_n_0\
    );
\cpu_available1_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(21),
      I1 => packet_completed_frames(21),
      I2 => \^released_frames_reg[31]_0\(20),
      I3 => packet_completed_frames(20),
      O => \cpu_available1_carry__1_i_6_n_0\
    );
\cpu_available1_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(19),
      I1 => packet_completed_frames(19),
      I2 => \^released_frames_reg[31]_0\(18),
      I3 => packet_completed_frames(18),
      O => \cpu_available1_carry__1_i_7_n_0\
    );
\cpu_available1_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(17),
      I1 => packet_completed_frames(17),
      I2 => \^released_frames_reg[31]_0\(16),
      I3 => packet_completed_frames(16),
      O => \cpu_available1_carry__1_i_8_n_0\
    );
\cpu_available1_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \cpu_available1_carry__1_n_0\,
      CO(3) => cpu_available1,
      CO(2) => \cpu_available1_carry__2_n_1\,
      CO(1) => \cpu_available1_carry__2_n_2\,
      CO(0) => \cpu_available1_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \cpu_available1_carry__2_i_1_n_0\,
      DI(2) => \cpu_available1_carry__2_i_2_n_0\,
      DI(1) => \cpu_available1_carry__2_i_3_n_0\,
      DI(0) => \cpu_available1_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_cpu_available1_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \cpu_available1_carry__2_i_5_n_0\,
      S(2) => \cpu_available1_carry__2_i_6_n_0\,
      S(1) => \cpu_available1_carry__2_i_7_n_0\,
      S(0) => \cpu_available1_carry__2_i_8_n_0\
    );
\cpu_available1_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(31),
      I1 => \^released_frames_reg[31]_0\(31),
      I2 => packet_completed_frames(30),
      I3 => \^released_frames_reg[31]_0\(30),
      O => \cpu_available1_carry__2_i_1_n_0\
    );
\cpu_available1_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(29),
      I1 => \^released_frames_reg[31]_0\(29),
      I2 => packet_completed_frames(28),
      I3 => \^released_frames_reg[31]_0\(28),
      O => \cpu_available1_carry__2_i_2_n_0\
    );
\cpu_available1_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(27),
      I1 => \^released_frames_reg[31]_0\(27),
      I2 => packet_completed_frames(26),
      I3 => \^released_frames_reg[31]_0\(26),
      O => \cpu_available1_carry__2_i_3_n_0\
    );
\cpu_available1_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(25),
      I1 => \^released_frames_reg[31]_0\(25),
      I2 => packet_completed_frames(24),
      I3 => \^released_frames_reg[31]_0\(24),
      O => \cpu_available1_carry__2_i_4_n_0\
    );
\cpu_available1_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(31),
      I1 => packet_completed_frames(31),
      I2 => \^released_frames_reg[31]_0\(30),
      I3 => packet_completed_frames(30),
      O => \cpu_available1_carry__2_i_5_n_0\
    );
\cpu_available1_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(29),
      I1 => packet_completed_frames(29),
      I2 => \^released_frames_reg[31]_0\(28),
      I3 => packet_completed_frames(28),
      O => \cpu_available1_carry__2_i_6_n_0\
    );
\cpu_available1_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(27),
      I1 => packet_completed_frames(27),
      I2 => \^released_frames_reg[31]_0\(26),
      I3 => packet_completed_frames(26),
      O => \cpu_available1_carry__2_i_7_n_0\
    );
\cpu_available1_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(25),
      I1 => packet_completed_frames(25),
      I2 => \^released_frames_reg[31]_0\(24),
      I3 => packet_completed_frames(24),
      O => \cpu_available1_carry__2_i_8_n_0\
    );
cpu_available1_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(7),
      I1 => \^released_frames_reg[31]_0\(7),
      I2 => packet_completed_frames(6),
      I3 => \^released_frames_reg[31]_0\(6),
      O => cpu_available1_carry_i_1_n_0
    );
cpu_available1_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(5),
      I1 => \^released_frames_reg[31]_0\(5),
      I2 => packet_completed_frames(4),
      I3 => \^released_frames_reg[31]_0\(4),
      O => cpu_available1_carry_i_2_n_0
    );
cpu_available1_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(3),
      I1 => \^released_frames_reg[31]_0\(3),
      I2 => packet_completed_frames(2),
      I3 => \^released_frames_reg[31]_0\(2),
      O => cpu_available1_carry_i_3_n_0
    );
cpu_available1_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => packet_completed_frames(1),
      I1 => \^released_frames_reg[31]_0\(1),
      I2 => packet_completed_frames(0),
      I3 => \^released_frames_reg[31]_0\(0),
      O => cpu_available1_carry_i_4_n_0
    );
cpu_available1_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(7),
      I1 => packet_completed_frames(7),
      I2 => \^released_frames_reg[31]_0\(6),
      I3 => packet_completed_frames(6),
      O => cpu_available1_carry_i_5_n_0
    );
cpu_available1_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(5),
      I1 => packet_completed_frames(5),
      I2 => \^released_frames_reg[31]_0\(4),
      I3 => packet_completed_frames(4),
      O => cpu_available1_carry_i_6_n_0
    );
cpu_available1_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(3),
      I1 => packet_completed_frames(3),
      I2 => \^released_frames_reg[31]_0\(2),
      I3 => packet_completed_frames(2),
      O => cpu_available1_carry_i_7_n_0
    );
cpu_available1_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(1),
      I1 => packet_completed_frames(1),
      I2 => \^released_frames_reg[31]_0\(0),
      I3 => packet_completed_frames(0),
      O => cpu_available1_carry_i_8_n_0
    );
cpu_available2_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => cpu_available2_carry_n_0,
      CO(2) => cpu_available2_carry_n_1,
      CO(1) => cpu_available2_carry_n_2,
      CO(0) => cpu_available2_carry_n_3,
      CYINIT => '0',
      DI(3) => cpu_available2_carry_i_1_n_0,
      DI(2) => cpu_available2_carry_i_2_n_0,
      DI(1) => cpu_available2_carry_i_3_n_0,
      DI(0) => cpu_available2_carry_i_4_n_0,
      O(3 downto 0) => NLW_cpu_available2_carry_O_UNCONNECTED(3 downto 0),
      S(3) => cpu_available2_carry_i_5_n_0,
      S(2) => cpu_available2_carry_i_6_n_0,
      S(1) => cpu_available2_carry_i_7_n_0,
      S(0) => cpu_available2_carry_i_8_n_0
    );
\cpu_available2_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => cpu_available2_carry_n_0,
      CO(3) => \cpu_available2_carry__0_n_0\,
      CO(2) => \cpu_available2_carry__0_n_1\,
      CO(1) => \cpu_available2_carry__0_n_2\,
      CO(0) => \cpu_available2_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \cpu_available2_carry__0_i_1_n_0\,
      DI(2) => \cpu_available2_carry__0_i_2_n_0\,
      DI(1) => \cpu_available2_carry__0_i_3_n_0\,
      DI(0) => \cpu_available2_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_cpu_available2_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \cpu_available2_carry__0_i_5_n_0\,
      S(2) => \cpu_available2_carry__0_i_6_n_0\,
      S(1) => \cpu_available2_carry__0_i_7_n_0\,
      S(0) => \cpu_available2_carry__0_i_8_n_0\
    );
\cpu_available2_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(15),
      I1 => \^released_frames_reg[31]_0\(15),
      I2 => rgb_completed_frames(14),
      I3 => \^released_frames_reg[31]_0\(14),
      O => \cpu_available2_carry__0_i_1_n_0\
    );
\cpu_available2_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(13),
      I1 => \^released_frames_reg[31]_0\(13),
      I2 => rgb_completed_frames(12),
      I3 => \^released_frames_reg[31]_0\(12),
      O => \cpu_available2_carry__0_i_2_n_0\
    );
\cpu_available2_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(11),
      I1 => \^released_frames_reg[31]_0\(11),
      I2 => rgb_completed_frames(10),
      I3 => \^released_frames_reg[31]_0\(10),
      O => \cpu_available2_carry__0_i_3_n_0\
    );
\cpu_available2_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(9),
      I1 => \^released_frames_reg[31]_0\(9),
      I2 => rgb_completed_frames(8),
      I3 => \^released_frames_reg[31]_0\(8),
      O => \cpu_available2_carry__0_i_4_n_0\
    );
\cpu_available2_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(15),
      I1 => rgb_completed_frames(15),
      I2 => \^released_frames_reg[31]_0\(14),
      I3 => rgb_completed_frames(14),
      O => \cpu_available2_carry__0_i_5_n_0\
    );
\cpu_available2_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(13),
      I1 => rgb_completed_frames(13),
      I2 => \^released_frames_reg[31]_0\(12),
      I3 => rgb_completed_frames(12),
      O => \cpu_available2_carry__0_i_6_n_0\
    );
\cpu_available2_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(11),
      I1 => rgb_completed_frames(11),
      I2 => \^released_frames_reg[31]_0\(10),
      I3 => rgb_completed_frames(10),
      O => \cpu_available2_carry__0_i_7_n_0\
    );
\cpu_available2_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(9),
      I1 => rgb_completed_frames(9),
      I2 => \^released_frames_reg[31]_0\(8),
      I3 => rgb_completed_frames(8),
      O => \cpu_available2_carry__0_i_8_n_0\
    );
\cpu_available2_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \cpu_available2_carry__0_n_0\,
      CO(3) => \cpu_available2_carry__1_n_0\,
      CO(2) => \cpu_available2_carry__1_n_1\,
      CO(1) => \cpu_available2_carry__1_n_2\,
      CO(0) => \cpu_available2_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \cpu_available2_carry__1_i_1_n_0\,
      DI(2) => \cpu_available2_carry__1_i_2_n_0\,
      DI(1) => \cpu_available2_carry__1_i_3_n_0\,
      DI(0) => \cpu_available2_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_cpu_available2_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \cpu_available2_carry__1_i_5_n_0\,
      S(2) => \cpu_available2_carry__1_i_6_n_0\,
      S(1) => \cpu_available2_carry__1_i_7_n_0\,
      S(0) => \cpu_available2_carry__1_i_8_n_0\
    );
\cpu_available2_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(23),
      I1 => \^released_frames_reg[31]_0\(23),
      I2 => rgb_completed_frames(22),
      I3 => \^released_frames_reg[31]_0\(22),
      O => \cpu_available2_carry__1_i_1_n_0\
    );
\cpu_available2_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(21),
      I1 => \^released_frames_reg[31]_0\(21),
      I2 => rgb_completed_frames(20),
      I3 => \^released_frames_reg[31]_0\(20),
      O => \cpu_available2_carry__1_i_2_n_0\
    );
\cpu_available2_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(19),
      I1 => \^released_frames_reg[31]_0\(19),
      I2 => rgb_completed_frames(18),
      I3 => \^released_frames_reg[31]_0\(18),
      O => \cpu_available2_carry__1_i_3_n_0\
    );
\cpu_available2_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(17),
      I1 => \^released_frames_reg[31]_0\(17),
      I2 => rgb_completed_frames(16),
      I3 => \^released_frames_reg[31]_0\(16),
      O => \cpu_available2_carry__1_i_4_n_0\
    );
\cpu_available2_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(23),
      I1 => rgb_completed_frames(23),
      I2 => \^released_frames_reg[31]_0\(22),
      I3 => rgb_completed_frames(22),
      O => \cpu_available2_carry__1_i_5_n_0\
    );
\cpu_available2_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(21),
      I1 => rgb_completed_frames(21),
      I2 => \^released_frames_reg[31]_0\(20),
      I3 => rgb_completed_frames(20),
      O => \cpu_available2_carry__1_i_6_n_0\
    );
\cpu_available2_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(19),
      I1 => rgb_completed_frames(19),
      I2 => \^released_frames_reg[31]_0\(18),
      I3 => rgb_completed_frames(18),
      O => \cpu_available2_carry__1_i_7_n_0\
    );
\cpu_available2_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(17),
      I1 => rgb_completed_frames(17),
      I2 => \^released_frames_reg[31]_0\(16),
      I3 => rgb_completed_frames(16),
      O => \cpu_available2_carry__1_i_8_n_0\
    );
\cpu_available2_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \cpu_available2_carry__1_n_0\,
      CO(3) => cpu_available2,
      CO(2) => \cpu_available2_carry__2_n_1\,
      CO(1) => \cpu_available2_carry__2_n_2\,
      CO(0) => \cpu_available2_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \cpu_available2_carry__2_i_1_n_0\,
      DI(2) => \cpu_available2_carry__2_i_2_n_0\,
      DI(1) => \cpu_available2_carry__2_i_3_n_0\,
      DI(0) => \cpu_available2_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_cpu_available2_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \cpu_available2_carry__2_i_5_n_0\,
      S(2) => \cpu_available2_carry__2_i_6_n_0\,
      S(1) => \cpu_available2_carry__2_i_7_n_0\,
      S(0) => \cpu_available2_carry__2_i_8_n_0\
    );
\cpu_available2_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(31),
      I1 => \^released_frames_reg[31]_0\(31),
      I2 => rgb_completed_frames(30),
      I3 => \^released_frames_reg[31]_0\(30),
      O => \cpu_available2_carry__2_i_1_n_0\
    );
\cpu_available2_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(29),
      I1 => \^released_frames_reg[31]_0\(29),
      I2 => rgb_completed_frames(28),
      I3 => \^released_frames_reg[31]_0\(28),
      O => \cpu_available2_carry__2_i_2_n_0\
    );
\cpu_available2_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(27),
      I1 => \^released_frames_reg[31]_0\(27),
      I2 => rgb_completed_frames(26),
      I3 => \^released_frames_reg[31]_0\(26),
      O => \cpu_available2_carry__2_i_3_n_0\
    );
\cpu_available2_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(25),
      I1 => \^released_frames_reg[31]_0\(25),
      I2 => rgb_completed_frames(24),
      I3 => \^released_frames_reg[31]_0\(24),
      O => \cpu_available2_carry__2_i_4_n_0\
    );
\cpu_available2_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(31),
      I1 => rgb_completed_frames(31),
      I2 => \^released_frames_reg[31]_0\(30),
      I3 => rgb_completed_frames(30),
      O => \cpu_available2_carry__2_i_5_n_0\
    );
\cpu_available2_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(29),
      I1 => rgb_completed_frames(29),
      I2 => \^released_frames_reg[31]_0\(28),
      I3 => rgb_completed_frames(28),
      O => \cpu_available2_carry__2_i_6_n_0\
    );
\cpu_available2_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(27),
      I1 => rgb_completed_frames(27),
      I2 => \^released_frames_reg[31]_0\(26),
      I3 => rgb_completed_frames(26),
      O => \cpu_available2_carry__2_i_7_n_0\
    );
\cpu_available2_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(25),
      I1 => rgb_completed_frames(25),
      I2 => \^released_frames_reg[31]_0\(24),
      I3 => rgb_completed_frames(24),
      O => \cpu_available2_carry__2_i_8_n_0\
    );
cpu_available2_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(7),
      I1 => \^released_frames_reg[31]_0\(7),
      I2 => rgb_completed_frames(6),
      I3 => \^released_frames_reg[31]_0\(6),
      O => cpu_available2_carry_i_1_n_0
    );
cpu_available2_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(5),
      I1 => \^released_frames_reg[31]_0\(5),
      I2 => rgb_completed_frames(4),
      I3 => \^released_frames_reg[31]_0\(4),
      O => cpu_available2_carry_i_2_n_0
    );
cpu_available2_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(3),
      I1 => \^released_frames_reg[31]_0\(3),
      I2 => rgb_completed_frames(2),
      I3 => \^released_frames_reg[31]_0\(2),
      O => cpu_available2_carry_i_3_n_0
    );
cpu_available2_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => rgb_completed_frames(1),
      I1 => \^released_frames_reg[31]_0\(1),
      I2 => rgb_completed_frames(0),
      I3 => \^released_frames_reg[31]_0\(0),
      O => cpu_available2_carry_i_4_n_0
    );
cpu_available2_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(7),
      I1 => rgb_completed_frames(7),
      I2 => \^released_frames_reg[31]_0\(6),
      I3 => rgb_completed_frames(6),
      O => cpu_available2_carry_i_5_n_0
    );
cpu_available2_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(5),
      I1 => rgb_completed_frames(5),
      I2 => \^released_frames_reg[31]_0\(4),
      I3 => rgb_completed_frames(4),
      O => cpu_available2_carry_i_6_n_0
    );
cpu_available2_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(3),
      I1 => rgb_completed_frames(3),
      I2 => \^released_frames_reg[31]_0\(2),
      I3 => rgb_completed_frames(2),
      O => cpu_available2_carry_i_7_n_0
    );
cpu_available2_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(1),
      I1 => rgb_completed_frames(1),
      I2 => \^released_frames_reg[31]_0\(0),
      I3 => rgb_completed_frames(0),
      O => cpu_available2_carry_i_8_n_0
    );
cpu_available3_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => cpu_available3_carry_n_0,
      CO(2) => cpu_available3_carry_n_1,
      CO(1) => cpu_available3_carry_n_2,
      CO(0) => cpu_available3_carry_n_3,
      CYINIT => '0',
      DI(3) => cpu_available3_carry_i_1_n_0,
      DI(2) => cpu_available3_carry_i_2_n_0,
      DI(1) => cpu_available3_carry_i_3_n_0,
      DI(0) => cpu_available3_carry_i_4_n_0,
      O(3 downto 0) => NLW_cpu_available3_carry_O_UNCONNECTED(3 downto 0),
      S(3) => cpu_available3_carry_i_5_n_0,
      S(2) => cpu_available3_carry_i_6_n_0,
      S(1) => cpu_available3_carry_i_7_n_0,
      S(0) => cpu_available3_carry_i_8_n_0
    );
\cpu_available3_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => cpu_available3_carry_n_0,
      CO(3) => \cpu_available3_carry__0_n_0\,
      CO(2) => \cpu_available3_carry__0_n_1\,
      CO(1) => \cpu_available3_carry__0_n_2\,
      CO(0) => \cpu_available3_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \cpu_available3_carry__0_i_1_n_0\,
      DI(2) => \cpu_available3_carry__0_i_2_n_0\,
      DI(1) => \cpu_available3_carry__0_i_3_n_0\,
      DI(0) => \cpu_available3_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_cpu_available3_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \cpu_available3_carry__0_i_5_n_0\,
      S(2) => \cpu_available3_carry__0_i_6_n_0\,
      S(1) => \cpu_available3_carry__0_i_7_n_0\,
      S(0) => \cpu_available3_carry__0_i_8_n_0\
    );
\cpu_available3_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(15),
      I1 => \^out\(15),
      I2 => \^out\(14),
      I3 => \^released_frames_reg[31]_0\(14),
      O => \cpu_available3_carry__0_i_1_n_0\
    );
\cpu_available3_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(13),
      I1 => \^out\(13),
      I2 => \^out\(12),
      I3 => \^released_frames_reg[31]_0\(12),
      O => \cpu_available3_carry__0_i_2_n_0\
    );
\cpu_available3_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(11),
      I1 => \^out\(11),
      I2 => \^out\(10),
      I3 => \^released_frames_reg[31]_0\(10),
      O => \cpu_available3_carry__0_i_3_n_0\
    );
\cpu_available3_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(9),
      I1 => \^out\(9),
      I2 => \^out\(8),
      I3 => \^released_frames_reg[31]_0\(8),
      O => \cpu_available3_carry__0_i_4_n_0\
    );
\cpu_available3_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(15),
      I1 => \^released_frames_reg[31]_0\(15),
      I2 => \^out\(14),
      I3 => \^released_frames_reg[31]_0\(14),
      O => \cpu_available3_carry__0_i_5_n_0\
    );
\cpu_available3_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(13),
      I1 => \^released_frames_reg[31]_0\(13),
      I2 => \^out\(12),
      I3 => \^released_frames_reg[31]_0\(12),
      O => \cpu_available3_carry__0_i_6_n_0\
    );
\cpu_available3_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(11),
      I1 => \^released_frames_reg[31]_0\(11),
      I2 => \^out\(10),
      I3 => \^released_frames_reg[31]_0\(10),
      O => \cpu_available3_carry__0_i_7_n_0\
    );
\cpu_available3_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(9),
      I1 => \^released_frames_reg[31]_0\(9),
      I2 => \^out\(8),
      I3 => \^released_frames_reg[31]_0\(8),
      O => \cpu_available3_carry__0_i_8_n_0\
    );
\cpu_available3_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \cpu_available3_carry__0_n_0\,
      CO(3) => \cpu_available3_carry__1_n_0\,
      CO(2) => \cpu_available3_carry__1_n_1\,
      CO(1) => \cpu_available3_carry__1_n_2\,
      CO(0) => \cpu_available3_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \cpu_available3_carry__1_i_1_n_0\,
      DI(2) => \cpu_available3_carry__1_i_2_n_0\,
      DI(1) => \cpu_available3_carry__1_i_3_n_0\,
      DI(0) => \cpu_available3_carry__1_i_4_n_0\,
      O(3 downto 0) => \NLW_cpu_available3_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \cpu_available3_carry__1_i_5_n_0\,
      S(2) => \cpu_available3_carry__1_i_6_n_0\,
      S(1) => \cpu_available3_carry__1_i_7_n_0\,
      S(0) => \cpu_available3_carry__1_i_8_n_0\
    );
\cpu_available3_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(23),
      I1 => \^out\(23),
      I2 => \^out\(22),
      I3 => \^released_frames_reg[31]_0\(22),
      O => \cpu_available3_carry__1_i_1_n_0\
    );
\cpu_available3_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(21),
      I1 => \^out\(21),
      I2 => \^out\(20),
      I3 => \^released_frames_reg[31]_0\(20),
      O => \cpu_available3_carry__1_i_2_n_0\
    );
\cpu_available3_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(19),
      I1 => \^out\(19),
      I2 => \^out\(18),
      I3 => \^released_frames_reg[31]_0\(18),
      O => \cpu_available3_carry__1_i_3_n_0\
    );
\cpu_available3_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(17),
      I1 => \^out\(17),
      I2 => \^out\(16),
      I3 => \^released_frames_reg[31]_0\(16),
      O => \cpu_available3_carry__1_i_4_n_0\
    );
\cpu_available3_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(23),
      I1 => \^released_frames_reg[31]_0\(23),
      I2 => \^out\(22),
      I3 => \^released_frames_reg[31]_0\(22),
      O => \cpu_available3_carry__1_i_5_n_0\
    );
\cpu_available3_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(21),
      I1 => \^released_frames_reg[31]_0\(21),
      I2 => \^out\(20),
      I3 => \^released_frames_reg[31]_0\(20),
      O => \cpu_available3_carry__1_i_6_n_0\
    );
\cpu_available3_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(19),
      I1 => \^released_frames_reg[31]_0\(19),
      I2 => \^out\(18),
      I3 => \^released_frames_reg[31]_0\(18),
      O => \cpu_available3_carry__1_i_7_n_0\
    );
\cpu_available3_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(17),
      I1 => \^released_frames_reg[31]_0\(17),
      I2 => \^out\(16),
      I3 => \^released_frames_reg[31]_0\(16),
      O => \cpu_available3_carry__1_i_8_n_0\
    );
\cpu_available3_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \cpu_available3_carry__1_n_0\,
      CO(3) => cpu_available3,
      CO(2) => \cpu_available3_carry__2_n_1\,
      CO(1) => \cpu_available3_carry__2_n_2\,
      CO(0) => \cpu_available3_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \cpu_available3_carry__2_i_1_n_0\,
      DI(2) => \cpu_available3_carry__2_i_2_n_0\,
      DI(1) => \cpu_available3_carry__2_i_3_n_0\,
      DI(0) => \cpu_available3_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_cpu_available3_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \cpu_available3_carry__2_i_5_n_0\,
      S(2) => \cpu_available3_carry__2_i_6_n_0\,
      S(1) => \cpu_available3_carry__2_i_7_n_0\,
      S(0) => \cpu_available3_carry__2_i_8_n_0\
    );
\cpu_available3_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2B22"
    )
        port map (
      I0 => \^out\(31),
      I1 => \^released_frames_reg[31]_0\(31),
      I2 => \^released_frames_reg[31]_0\(30),
      I3 => \^out\(30),
      O => \cpu_available3_carry__2_i_1_n_0\
    );
\cpu_available3_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(29),
      I1 => \^out\(29),
      I2 => \^out\(28),
      I3 => \^released_frames_reg[31]_0\(28),
      O => \cpu_available3_carry__2_i_2_n_0\
    );
\cpu_available3_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(27),
      I1 => \^out\(27),
      I2 => \^out\(26),
      I3 => \^released_frames_reg[31]_0\(26),
      O => \cpu_available3_carry__2_i_3_n_0\
    );
\cpu_available3_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(25),
      I1 => \^out\(25),
      I2 => \^out\(24),
      I3 => \^released_frames_reg[31]_0\(24),
      O => \cpu_available3_carry__2_i_4_n_0\
    );
\cpu_available3_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(31),
      I1 => \^out\(31),
      I2 => \^out\(30),
      I3 => \^released_frames_reg[31]_0\(30),
      O => \cpu_available3_carry__2_i_5_n_0\
    );
\cpu_available3_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(29),
      I1 => \^released_frames_reg[31]_0\(29),
      I2 => \^out\(28),
      I3 => \^released_frames_reg[31]_0\(28),
      O => \cpu_available3_carry__2_i_6_n_0\
    );
\cpu_available3_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(27),
      I1 => \^released_frames_reg[31]_0\(27),
      I2 => \^out\(26),
      I3 => \^released_frames_reg[31]_0\(26),
      O => \cpu_available3_carry__2_i_7_n_0\
    );
\cpu_available3_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(25),
      I1 => \^released_frames_reg[31]_0\(25),
      I2 => \^out\(24),
      I3 => \^released_frames_reg[31]_0\(24),
      O => \cpu_available3_carry__2_i_8_n_0\
    );
cpu_available3_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(7),
      I1 => \^out\(7),
      I2 => \^out\(6),
      I3 => \^released_frames_reg[31]_0\(6),
      O => cpu_available3_carry_i_1_n_0
    );
cpu_available3_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(5),
      I1 => \^out\(5),
      I2 => \^out\(4),
      I3 => \^released_frames_reg[31]_0\(4),
      O => cpu_available3_carry_i_2_n_0
    );
cpu_available3_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(3),
      I1 => \^out\(3),
      I2 => \^out\(2),
      I3 => \^released_frames_reg[31]_0\(2),
      O => cpu_available3_carry_i_3_n_0
    );
cpu_available3_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"44D4"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(1),
      I1 => \^out\(1),
      I2 => \^out\(0),
      I3 => \^released_frames_reg[31]_0\(0),
      O => cpu_available3_carry_i_4_n_0
    );
cpu_available3_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(7),
      I1 => \^released_frames_reg[31]_0\(7),
      I2 => \^out\(6),
      I3 => \^released_frames_reg[31]_0\(6),
      O => cpu_available3_carry_i_5_n_0
    );
cpu_available3_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(5),
      I1 => \^released_frames_reg[31]_0\(5),
      I2 => \^out\(4),
      I3 => \^released_frames_reg[31]_0\(4),
      O => cpu_available3_carry_i_6_n_0
    );
cpu_available3_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(3),
      I1 => \^released_frames_reg[31]_0\(3),
      I2 => \^out\(2),
      I3 => \^released_frames_reg[31]_0\(2),
      O => cpu_available3_carry_i_7_n_0
    );
cpu_available3_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^out\(1),
      I1 => \^released_frames_reg[31]_0\(1),
      I2 => \^out\(0),
      I3 => \^released_frames_reg[31]_0\(0),
      O => cpu_available3_carry_i_8_n_0
    );
cpu_available_INST_0: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000080"
    )
        port map (
      I0 => common_aresetn,
      I1 => \epoch_reg[31]_0\,
      I2 => control_capture_aresetn,
      I3 => cpu_available_INST_0_i_1_n_0,
      I4 => cpu_available_INST_0_i_2_n_0,
      O => cpu_available
    );
cpu_available_INST_0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FEFFFFFFFFFFFFFF"
    )
        port map (
      I0 => upstream_fault0,
      I1 => owner_fault_INST_0_i_4_n_0,
      I2 => owner_fault_INST_0_i_3_n_0,
      I3 => owner_fault_INST_0_i_2_n_0,
      I4 => owner_fault_INST_0_i_1_n_0,
      I5 => \^configuration_locked\,
      O => cpu_available_INST_0_i_1_n_0
    );
cpu_available_INST_0_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF7FFFFF"
    )
        port map (
      I0 => cpu_available0,
      I1 => cpu_available1,
      I2 => cpu_available3,
      I3 => \^cpu_held_reg_0\,
      I4 => cpu_available2,
      O => cpu_available_INST_0_i_2_n_0
    );
cpu_held_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFF2F2000000D0"
    )
        port map (
      I0 => cpu_held_i_2_n_0,
      I1 => cpu_held_i_3_n_0,
      I2 => cpu_claim,
      I3 => cpu_release,
      I4 => cpu_available_INST_0_i_1_n_0,
      I5 => \^cpu_held_reg_0\,
      O => cpu_held_i_1_n_0
    );
cpu_held_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => cpu_release,
      I1 => token_matches00_out,
      I2 => token_matches0,
      I3 => \^cpu_held_reg_0\,
      I4 => cpu_claim,
      O => cpu_held_i_2_n_0
    );
cpu_held_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0100000000000000"
    )
        port map (
      I0 => cpu_available_INST_0_i_2_n_0,
      I1 => cpu_available_INST_0_i_1_n_0,
      I2 => claim_accepted_reg_0,
      I3 => cpu_claim,
      I4 => token_matches00_out,
      I5 => token_matches0,
      O => cpu_held_i_3_n_0
    );
cpu_held_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => cpu_held_i_1_n_0,
      Q => \^cpu_held_reg_0\,
      R => \^clear\
    );
\epoch[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0040"
    )
        port map (
      I0 => \^configuration_locked\,
      I1 => control_capture_aresetn,
      I2 => \epoch_reg[31]_0\,
      I3 => \^configuration_locked1\,
      O => configuration_locked17_out
    );
\epoch[31]_i_10\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => status_completed_frames(22),
      I1 => packet_completed_frames(20),
      I2 => packet_completed_frames(26),
      I3 => packet_completed_frames(18),
      O => \epoch[31]_i_10_n_0\
    );
\epoch[31]_i_11\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => rgb_completed_frames(18),
      I1 => rgb_completed_frames(26),
      I2 => rgb_completed_frames(6),
      I3 => rgb_completed_frames(27),
      I4 => \epoch[31]_i_23_n_0\,
      O => \epoch[31]_i_11_n_0\
    );
\epoch[31]_i_12\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => status_completed_frames(17),
      I1 => packet_completed_frames(15),
      I2 => rgb_completed_frames(21),
      I3 => rgb_completed_frames(8),
      O => \epoch[31]_i_12_n_0\
    );
\epoch[31]_i_13\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => rgb_completed_frames(25),
      I1 => rgb_completed_frames(9),
      I2 => rgb_completed_frames(24),
      I3 => rgb_completed_frames(13),
      O => \epoch[31]_i_13_n_0\
    );
\epoch[31]_i_14\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \epoch[31]_i_24_n_0\,
      I1 => cfg_frame_context(2),
      I2 => cfg_frame_context(1),
      I3 => cfg_frame_context(3),
      I4 => cfg_frame_context(0),
      I5 => \epoch[31]_i_25_n_0\,
      O => \epoch[31]_i_14_n_0\
    );
\epoch[31]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => \epoch[31]_i_26_n_0\,
      I1 => cfg_frame_context(18),
      I2 => cfg_frame_context(17),
      I3 => cfg_frame_context(19),
      I4 => cfg_frame_context(16),
      I5 => \epoch[31]_i_27_n_0\,
      O => \epoch[31]_i_15_n_0\
    );
\epoch[31]_i_16\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \epoch[31]_i_28_n_0\,
      I1 => cfg_frame_context(42),
      I2 => cfg_frame_context(41),
      I3 => cfg_frame_context(43),
      I4 => cfg_frame_context(40),
      I5 => \epoch[31]_i_29_n_0\,
      O => \epoch[31]_i_16_n_0\
    );
\epoch[31]_i_17\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => \epoch[31]_i_30_n_0\,
      I1 => cfg_frame_context(50),
      I2 => cfg_frame_context(49),
      I3 => cfg_frame_context(51),
      I4 => cfg_frame_context(48),
      I5 => \epoch[31]_i_31_n_0\,
      O => \epoch[31]_i_17_n_0\
    );
\epoch[31]_i_18\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \epoch[31]_i_32_n_0\,
      I1 => rgb_completed_frames(5),
      I2 => rgb_completed_frames(2),
      I3 => status_completed_frames(8),
      I4 => status_completed_frames(1),
      I5 => \epoch[31]_i_33_n_0\,
      O => \epoch[31]_i_18_n_0\
    );
\epoch[31]_i_19\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => cpu_release,
      I1 => cpu_claim,
      I2 => packet_completed_frames(9),
      I3 => status_completed_frames(26),
      I4 => packet_completed_frames(6),
      I5 => packet_completed_frames(8),
      O => \epoch[31]_i_19_n_0\
    );
\epoch[31]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => \epoch[31]_i_3_n_0\,
      I1 => \epoch[31]_i_4_n_0\,
      I2 => \epoch[31]_i_5_n_0\,
      I3 => \epoch[31]_i_6_n_0\,
      I4 => \epoch[31]_i_7_n_0\,
      O => \^configuration_locked1\
    );
\epoch[31]_i_20\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \epoch[31]_i_34_n_0\,
      I1 => packet_completed_frames(27),
      I2 => packet_completed_frames(23),
      I3 => status_completed_frames(4),
      I4 => packet_completed_frames(28),
      I5 => \epoch[31]_i_35_n_0\,
      O => \epoch[31]_i_20_n_0\
    );
\epoch[31]_i_21\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \epoch[31]_i_36_n_0\,
      I1 => rgb_completed_frames(28),
      I2 => rgb_completed_frames(17),
      I3 => packet_completed_frames(12),
      I4 => packet_completed_frames(10),
      I5 => \epoch[31]_i_37_n_0\,
      O => \epoch[31]_i_21_n_0\
    );
\epoch[31]_i_22\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => status_completed_frames(29),
      I1 => status_completed_frames(12),
      I2 => status_completed_frames(15),
      I3 => packet_completed_frames(25),
      O => \epoch[31]_i_22_n_0\
    );
\epoch[31]_i_23\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => status_completed_frames(18),
      I1 => packet_completed_frames(14),
      I2 => packet_completed_frames(0),
      I3 => rgb_completed_frames(7),
      O => \epoch[31]_i_23_n_0\
    );
\epoch[31]_i_24\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => cfg_frame_context(5),
      I1 => cfg_frame_context(4),
      I2 => cfg_frame_context(7),
      I3 => cfg_frame_context(6),
      O => \epoch[31]_i_24_n_0\
    );
\epoch[31]_i_25\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => cfg_frame_context(10),
      I1 => cfg_frame_context(11),
      I2 => cfg_frame_context(8),
      I3 => cfg_frame_context(9),
      I4 => \epoch[31]_i_38_n_0\,
      O => \epoch[31]_i_25_n_0\
    );
\epoch[31]_i_26\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => cfg_frame_context(21),
      I1 => cfg_frame_context(20),
      I2 => cfg_frame_context(23),
      I3 => cfg_frame_context(22),
      O => \epoch[31]_i_26_n_0\
    );
\epoch[31]_i_27\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => cfg_frame_context(26),
      I1 => cfg_frame_context(27),
      I2 => cfg_frame_context(24),
      I3 => cfg_frame_context(25),
      I4 => \epoch[31]_i_39_n_0\,
      O => \epoch[31]_i_27_n_0\
    );
\epoch[31]_i_28\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => cfg_frame_context(45),
      I1 => cfg_frame_context(44),
      I2 => cfg_frame_context(47),
      I3 => cfg_frame_context(46),
      O => \epoch[31]_i_28_n_0\
    );
\epoch[31]_i_29\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => cfg_frame_context(34),
      I1 => cfg_frame_context(35),
      I2 => cfg_frame_context(32),
      I3 => cfg_frame_context(33),
      I4 => \epoch[31]_i_40_n_0\,
      O => \epoch[31]_i_29_n_0\
    );
\epoch[31]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \epoch[31]_i_8_n_0\,
      I1 => status_completed_frames(27),
      I2 => packet_completed_frames(2),
      I3 => status_completed_frames(19),
      I4 => packet_completed_frames(19),
      I5 => \epoch[31]_i_9_n_0\,
      O => \epoch[31]_i_3_n_0\
    );
\epoch[31]_i_30\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => cfg_frame_context(53),
      I1 => cfg_frame_context(52),
      I2 => cfg_frame_context(55),
      I3 => cfg_frame_context(54),
      O => \epoch[31]_i_30_n_0\
    );
\epoch[31]_i_31\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => cfg_frame_context(58),
      I1 => cfg_frame_context(59),
      I2 => cfg_frame_context(56),
      I3 => cfg_frame_context(57),
      I4 => \epoch[31]_i_41_n_0\,
      O => \epoch[31]_i_31_n_0\
    );
\epoch[31]_i_32\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => rgb_completed_frames(23),
      I1 => rgb_completed_frames(10),
      I2 => status_completed_frames(21),
      I3 => status_completed_frames(10),
      O => \epoch[31]_i_32_n_0\
    );
\epoch[31]_i_33\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => status_completed_frames(0),
      I1 => status_completed_frames(11),
      I2 => status_completed_frames(14),
      I3 => status_completed_frames(20),
      I4 => \epoch[31]_i_42_n_0\,
      O => \epoch[31]_i_33_n_0\
    );
\epoch[31]_i_34\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => status_completed_frames(28),
      I1 => status_completed_frames(3),
      I2 => status_completed_frames(16),
      I3 => status_completed_frames(13),
      O => \epoch[31]_i_34_n_0\
    );
\epoch[31]_i_35\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => rgb_completed_frames(3),
      I1 => rgb_completed_frames(16),
      I2 => rgb_completed_frames(31),
      I3 => packet_completed_frames(13),
      I4 => \epoch[31]_i_43_n_0\,
      O => \epoch[31]_i_35_n_0\
    );
\epoch[31]_i_36\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => rgb_completed_frames(19),
      I1 => rgb_completed_frames(15),
      I2 => rgb_completed_frames(20),
      I3 => rgb_completed_frames(4),
      O => \epoch[31]_i_36_n_0\
    );
\epoch[31]_i_37\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => packet_completed_frames(24),
      I1 => packet_completed_frames(29),
      I2 => rgb_completed_frames(11),
      I3 => status_completed_frames(24),
      I4 => \epoch[31]_i_44_n_0\,
      O => \epoch[31]_i_37_n_0\
    );
\epoch[31]_i_38\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => cfg_frame_context(13),
      I1 => cfg_frame_context(12),
      I2 => cfg_frame_context(15),
      I3 => cfg_frame_context(14),
      O => \epoch[31]_i_38_n_0\
    );
\epoch[31]_i_39\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => cfg_frame_context(30),
      I1 => cfg_frame_context(29),
      I2 => cfg_frame_context(31),
      I3 => cfg_frame_context(28),
      O => \epoch[31]_i_39_n_0\
    );
\epoch[31]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \epoch[31]_i_10_n_0\,
      I1 => status_completed_frames(2),
      I2 => packet_completed_frames(21),
      I3 => status_completed_frames(7),
      I4 => rgb_completed_frames(0),
      I5 => \epoch[31]_i_11_n_0\,
      O => \epoch[31]_i_4_n_0\
    );
\epoch[31]_i_40\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => cfg_frame_context(37),
      I1 => cfg_frame_context(36),
      I2 => cfg_frame_context(39),
      I3 => cfg_frame_context(38),
      O => \epoch[31]_i_40_n_0\
    );
\epoch[31]_i_41\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => cfg_frame_context(63),
      I1 => cfg_frame_context(62),
      I2 => cfg_frame_context(61),
      I3 => cfg_frame_context(60),
      O => \epoch[31]_i_41_n_0\
    );
\epoch[31]_i_42\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => status_completed_frames(9),
      I1 => packet_completed_frames(30),
      I2 => status_completed_frames(31),
      I3 => status_completed_frames(6),
      O => \epoch[31]_i_42_n_0\
    );
\epoch[31]_i_43\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => status_completed_frames(30),
      I1 => rgb_completed_frames(30),
      I2 => packet_completed_frames(5),
      I3 => packet_completed_frames(4),
      O => \epoch[31]_i_43_n_0\
    );
\epoch[31]_i_44\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => status_completed_frames(25),
      I1 => packet_completed_frames(7),
      I2 => packet_completed_frames(11),
      I3 => rgb_completed_frames(22),
      O => \epoch[31]_i_44_n_0\
    );
\epoch[31]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => rgb_completed_frames(29),
      I1 => packet_completed_frames(1),
      I2 => rgb_completed_frames(12),
      I3 => status_completed_frames(23),
      I4 => \epoch[31]_i_12_n_0\,
      I5 => \epoch[31]_i_13_n_0\,
      O => \epoch[31]_i_5_n_0\
    );
\epoch[31]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4F44"
    )
        port map (
      I0 => \epoch[31]_i_14_n_0\,
      I1 => \epoch[31]_i_15_n_0\,
      I2 => \epoch[31]_i_16_n_0\,
      I3 => \epoch[31]_i_17_n_0\,
      O => \epoch[31]_i_6_n_0\
    );
\epoch[31]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \epoch[31]_i_18_n_0\,
      I1 => \epoch[31]_i_19_n_0\,
      I2 => \epoch[31]_i_20_n_0\,
      I3 => \epoch[31]_i_21_n_0\,
      O => \epoch[31]_i_7_n_0\
    );
\epoch[31]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => status_completed_frames(5),
      I1 => rgb_completed_frames(1),
      I2 => packet_completed_frames(31),
      I3 => packet_completed_frames(3),
      O => \epoch[31]_i_8_n_0\
    );
\epoch[31]_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => rgb_completed_frames(14),
      I1 => packet_completed_frames(16),
      I2 => packet_completed_frames(17),
      I3 => packet_completed_frames(22),
      I4 => \epoch[31]_i_22_n_0\,
      O => \epoch[31]_i_9_n_0\
    );
\epoch_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(32),
      Q => \^available_epoch\(0),
      R => \^clear\
    );
\epoch_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(42),
      Q => \^available_epoch\(10),
      R => \^clear\
    );
\epoch_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(43),
      Q => \^available_epoch\(11),
      R => \^clear\
    );
\epoch_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(44),
      Q => \^available_epoch\(12),
      R => \^clear\
    );
\epoch_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(45),
      Q => \^available_epoch\(13),
      R => \^clear\
    );
\epoch_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(46),
      Q => \^available_epoch\(14),
      R => \^clear\
    );
\epoch_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(47),
      Q => \^available_epoch\(15),
      R => \^clear\
    );
\epoch_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(48),
      Q => \^available_epoch\(16),
      R => \^clear\
    );
\epoch_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(49),
      Q => \^available_epoch\(17),
      R => \^clear\
    );
\epoch_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(50),
      Q => \^available_epoch\(18),
      R => \^clear\
    );
\epoch_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(51),
      Q => \^available_epoch\(19),
      R => \^clear\
    );
\epoch_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(33),
      Q => \^available_epoch\(1),
      R => \^clear\
    );
\epoch_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(52),
      Q => \^available_epoch\(20),
      R => \^clear\
    );
\epoch_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(53),
      Q => \^available_epoch\(21),
      R => \^clear\
    );
\epoch_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(54),
      Q => \^available_epoch\(22),
      R => \^clear\
    );
\epoch_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(55),
      Q => \^available_epoch\(23),
      R => \^clear\
    );
\epoch_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(56),
      Q => \^available_epoch\(24),
      R => \^clear\
    );
\epoch_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(57),
      Q => \^available_epoch\(25),
      R => \^clear\
    );
\epoch_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(58),
      Q => \^available_epoch\(26),
      R => \^clear\
    );
\epoch_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(59),
      Q => \^available_epoch\(27),
      R => \^clear\
    );
\epoch_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(60),
      Q => \^available_epoch\(28),
      R => \^clear\
    );
\epoch_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(61),
      Q => \^available_epoch\(29),
      R => \^clear\
    );
\epoch_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(34),
      Q => \^available_epoch\(2),
      R => \^clear\
    );
\epoch_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(62),
      Q => \^available_epoch\(30),
      R => \^clear\
    );
\epoch_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(63),
      Q => \^available_epoch\(31),
      R => \^clear\
    );
\epoch_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(35),
      Q => \^available_epoch\(3),
      R => \^clear\
    );
\epoch_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(36),
      Q => \^available_epoch\(4),
      R => \^clear\
    );
\epoch_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(37),
      Q => \^available_epoch\(5),
      R => \^clear\
    );
\epoch_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(38),
      Q => \^available_epoch\(6),
      R => \^clear\
    );
\epoch_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(39),
      Q => \^available_epoch\(7),
      R => \^clear\
    );
\epoch_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(40),
      Q => \^available_epoch\(8),
      R => \^clear\
    );
\epoch_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(41),
      Q => \^available_epoch\(9),
      R => \^clear\
    );
epoch_sealed_INST_0_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0001000000000000"
    )
        port map (
      I0 => owner_drained_INST_0_i_2_n_0,
      I1 => owner_drained_INST_0_i_1_n_0,
      I2 => cpu_release,
      I3 => cpu_available_INST_0_i_1_n_0,
      I4 => pipeline_drained,
      I5 => dma_drained,
      O => cpu_release_0
    );
\fault_causes[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFF00F1"
    )
        port map (
      I0 => cpu_held_i_3_n_0,
      I1 => \fault_causes[1]_i_2_n_0\,
      I2 => \fault_causes[1]_i_3_n_0\,
      I3 => cpu_available_INST_0_i_1_n_0,
      I4 => \fault_causes[1]_i_4_n_0\,
      I5 => \^owner_fault_causes\(1),
      O => \fault_causes[1]_i_1_n_0\
    );
\fault_causes[1]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000D555"
    )
        port map (
      I0 => cpu_release,
      I1 => token_matches00_out,
      I2 => token_matches0,
      I3 => \^cpu_held_reg_0\,
      I4 => cpu_claim,
      O => \fault_causes[1]_i_2_n_0\
    );
\fault_causes[1]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => cpu_claim,
      I1 => cpu_release,
      O => \fault_causes[1]_i_3_n_0\
    );
\fault_causes[1]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"000E0E0E"
    )
        port map (
      I0 => cpu_claim,
      I1 => cpu_release,
      I2 => \^configuration_locked\,
      I3 => \epoch_reg[31]_0\,
      I4 => control_capture_aresetn,
      O => \fault_causes[1]_i_4_n_0\
    );
\fault_causes[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFD500FF00"
    )
        port map (
      I0 => owner_fault_INST_0_i_1_n_0,
      I1 => frame_credit_request,
      I2 => p_0_in28_in,
      I3 => \^configuration_locked\,
      I4 => owner_fault_INST_0_i_2_n_0,
      I5 => \^owner_fault_causes\(2),
      O => \fault_causes[2]_i_1_n_0\
    );
\fault_causes[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFF38888"
    )
        port map (
      I0 => \^configuration_locked1\,
      I1 => capture_aresetn,
      I2 => configuration_bad1,
      I3 => \configuration_bad2_carry__1_n_1\,
      I4 => \^configuration_locked\,
      I5 => \^owner_fault_causes\(3),
      O => \fault_causes[3]_i_1_n_0\
    );
\fault_causes_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \fault_causes_reg[0]_0\,
      Q => \^owner_fault_causes\(0),
      R => \^clear\
    );
\fault_causes_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \fault_causes[1]_i_1_n_0\,
      Q => \^owner_fault_causes\(1),
      R => \^clear\
    );
\fault_causes_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \fault_causes[2]_i_1_n_0\,
      Q => \^owner_fault_causes\(2),
      R => \^clear\
    );
\fault_causes_reg[2]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_frame_id[28]_INST_0_n_0\,
      CO(3 downto 1) => \NLW_fault_causes_reg[2]_i_2_CO_UNCONNECTED\(3 downto 1),
      CO(0) => p_0_in28_in,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_fault_causes_reg[2]_i_2_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => B"0001"
    );
\fault_causes_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \fault_causes[3]_i_1_n_0\,
      Q => \^owner_fault_causes\(3),
      R => \^clear\
    );
\final_frame_count_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(0),
      Q => \final_frame_count_reg_n_0_[0]\,
      R => \^clear\
    );
\final_frame_count_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(10),
      Q => \final_frame_count_reg_n_0_[10]\,
      R => \^clear\
    );
\final_frame_count_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(11),
      Q => \final_frame_count_reg_n_0_[11]\,
      R => \^clear\
    );
\final_frame_count_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(12),
      Q => \final_frame_count_reg_n_0_[12]\,
      R => \^clear\
    );
\final_frame_count_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(13),
      Q => \final_frame_count_reg_n_0_[13]\,
      R => \^clear\
    );
\final_frame_count_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(14),
      Q => \final_frame_count_reg_n_0_[14]\,
      R => \^clear\
    );
\final_frame_count_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(15),
      Q => \final_frame_count_reg_n_0_[15]\,
      R => \^clear\
    );
\final_frame_count_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(16),
      Q => \final_frame_count_reg_n_0_[16]\,
      R => \^clear\
    );
\final_frame_count_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(17),
      Q => \final_frame_count_reg_n_0_[17]\,
      R => \^clear\
    );
\final_frame_count_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(18),
      Q => \^q\(3),
      R => \^clear\
    );
\final_frame_count_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(19),
      Q => \^q\(4),
      R => \^clear\
    );
\final_frame_count_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(1),
      Q => \final_frame_count_reg_n_0_[1]\,
      R => \^clear\
    );
\final_frame_count_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(20),
      Q => \^q\(5),
      R => \^clear\
    );
\final_frame_count_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(21),
      Q => \^q\(6),
      R => \^clear\
    );
\final_frame_count_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(22),
      Q => \^q\(7),
      R => \^clear\
    );
\final_frame_count_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(23),
      Q => \^q\(8),
      R => \^clear\
    );
\final_frame_count_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(24),
      Q => \^q\(9),
      R => \^clear\
    );
\final_frame_count_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(25),
      Q => \^q\(10),
      R => \^clear\
    );
\final_frame_count_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(26),
      Q => \^q\(11),
      R => \^clear\
    );
\final_frame_count_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(27),
      Q => \final_frame_count_reg_n_0_[27]\,
      R => \^clear\
    );
\final_frame_count_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(28),
      Q => \final_frame_count_reg_n_0_[28]\,
      R => \^clear\
    );
\final_frame_count_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(29),
      Q => \final_frame_count_reg_n_0_[29]\,
      R => \^clear\
    );
\final_frame_count_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(2),
      Q => \final_frame_count_reg_n_0_[2]\,
      R => \^clear\
    );
\final_frame_count_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(30),
      Q => \final_frame_count_reg_n_0_[30]\,
      R => \^clear\
    );
\final_frame_count_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(31),
      Q => \final_frame_count_reg_n_0_[31]\,
      R => \^clear\
    );
\final_frame_count_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(3),
      Q => \final_frame_count_reg_n_0_[3]\,
      R => \^clear\
    );
\final_frame_count_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(4),
      Q => \final_frame_count_reg_n_0_[4]\,
      R => \^clear\
    );
\final_frame_count_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(5),
      Q => \final_frame_count_reg_n_0_[5]\,
      R => \^clear\
    );
\final_frame_count_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(6),
      Q => \^q\(0),
      R => \^clear\
    );
\final_frame_count_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(7),
      Q => \^q\(1),
      R => \^clear\
    );
\final_frame_count_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(8),
      Q => \^q\(2),
      R => \^clear\
    );
\final_frame_count_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => E(0),
      D => D(9),
      Q => \final_frame_count_reg_n_0_[9]\,
      R => \^clear\
    );
\first_frame_id_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(0),
      Q => first_frame_id(0),
      R => \^clear\
    );
\first_frame_id_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(10),
      Q => first_frame_id(10),
      R => \^clear\
    );
\first_frame_id_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(11),
      Q => first_frame_id(11),
      R => \^clear\
    );
\first_frame_id_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(12),
      Q => first_frame_id(12),
      R => \^clear\
    );
\first_frame_id_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(13),
      Q => first_frame_id(13),
      R => \^clear\
    );
\first_frame_id_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(14),
      Q => first_frame_id(14),
      R => \^clear\
    );
\first_frame_id_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(15),
      Q => first_frame_id(15),
      R => \^clear\
    );
\first_frame_id_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(16),
      Q => first_frame_id(16),
      R => \^clear\
    );
\first_frame_id_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(17),
      Q => first_frame_id(17),
      R => \^clear\
    );
\first_frame_id_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(18),
      Q => first_frame_id(18),
      R => \^clear\
    );
\first_frame_id_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(19),
      Q => first_frame_id(19),
      R => \^clear\
    );
\first_frame_id_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(1),
      Q => first_frame_id(1),
      R => \^clear\
    );
\first_frame_id_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(20),
      Q => first_frame_id(20),
      R => \^clear\
    );
\first_frame_id_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(21),
      Q => first_frame_id(21),
      R => \^clear\
    );
\first_frame_id_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(22),
      Q => first_frame_id(22),
      R => \^clear\
    );
\first_frame_id_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(23),
      Q => first_frame_id(23),
      R => \^clear\
    );
\first_frame_id_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(24),
      Q => first_frame_id(24),
      R => \^clear\
    );
\first_frame_id_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(25),
      Q => first_frame_id(25),
      R => \^clear\
    );
\first_frame_id_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(26),
      Q => first_frame_id(26),
      R => \^clear\
    );
\first_frame_id_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(27),
      Q => first_frame_id(27),
      R => \^clear\
    );
\first_frame_id_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(28),
      Q => first_frame_id(28),
      R => \^clear\
    );
\first_frame_id_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(29),
      Q => first_frame_id(29),
      R => \^clear\
    );
\first_frame_id_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(2),
      Q => first_frame_id(2),
      R => \^clear\
    );
\first_frame_id_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(30),
      Q => first_frame_id(30),
      R => \^clear\
    );
\first_frame_id_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(31),
      Q => first_frame_id(31),
      R => \^clear\
    );
\first_frame_id_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(3),
      Q => first_frame_id(3),
      R => \^clear\
    );
\first_frame_id_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(4),
      Q => first_frame_id(4),
      R => \^clear\
    );
\first_frame_id_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(5),
      Q => first_frame_id(5),
      R => \^clear\
    );
\first_frame_id_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(6),
      Q => first_frame_id(6),
      R => \^clear\
    );
\first_frame_id_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(7),
      Q => first_frame_id(7),
      R => \^clear\
    );
\first_frame_id_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(8),
      Q => first_frame_id(8),
      R => \^clear\
    );
\first_frame_id_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => configuration_locked17_out,
      D => cfg_frame_context(9),
      Q => first_frame_id(9),
      R => \^clear\
    );
frame_credit_ready_INST_0: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0002000000020002"
    )
        port map (
      I0 => frame_credit_ready_INST_0_i_1_n_0,
      I1 => frame_credit_ready_INST_0_i_2_n_0,
      I2 => frame_credit_ready_0,
      I3 => frame_credit_ready_INST_0_i_4_n_0,
      I4 => frame_credit_ready_INST_0_i_5_n_0,
      I5 => frame_credit_ready_INST_0_i_6_n_0,
      O => frame_credit_ready
    );
frame_credit_ready_INST_0_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => cpu_available_INST_0_i_1_n_0,
      I1 => control_capture_aresetn,
      I2 => \epoch_reg[31]_0\,
      I3 => common_aresetn,
      O => frame_credit_ready_INST_0_i_1_n_0
    );
frame_credit_ready_INST_0_i_10: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => grant_ready40_out(6),
      I1 => grant_ready40_out(13),
      I2 => grant_ready40_out(21),
      I3 => p_0_in28_in,
      O => frame_credit_ready_INST_0_i_10_n_0
    );
frame_credit_ready_INST_0_i_11: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => grant_ready40_out(10),
      I1 => grant_ready40_out(15),
      I2 => grant_ready40_out(20),
      I3 => grant_ready40_out(28),
      O => frame_credit_ready_INST_0_i_11_n_0
    );
frame_credit_ready_INST_0_i_12: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFFFFFFFFFF"
    )
        port map (
      I0 => \^out\(14),
      I1 => \^out\(13),
      I2 => \^out\(8),
      I3 => \^out\(9),
      I4 => \^out\(10),
      I5 => \^out\(11),
      O => frame_credit_ready_INST_0_i_12_n_0
    );
frame_credit_ready_INST_0_i_13: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFFFFFFFFFF"
    )
        port map (
      I0 => \^out\(0),
      I1 => \^out\(3),
      I2 => \^out\(1),
      I3 => \^out\(2),
      I4 => \^out\(7),
      I5 => \^out\(4),
      O => frame_credit_ready_INST_0_i_13_n_0
    );
frame_credit_ready_INST_0_i_14: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^out\(21),
      I1 => \^out\(20),
      I2 => \^out\(23),
      I3 => \^out\(22),
      O => frame_credit_ready_INST_0_i_14_n_0
    );
frame_credit_ready_INST_0_i_15: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => \^out\(26),
      I1 => \^out\(27),
      I2 => \^out\(24),
      I3 => \^out\(25),
      I4 => frame_credit_ready_INST_0_i_17_n_0,
      O => frame_credit_ready_INST_0_i_15_n_0
    );
frame_credit_ready_INST_0_i_16: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => grant_ready40_out(17),
      I1 => grant_ready40_out(27),
      I2 => grant_ready40_out(12),
      I3 => grant_ready40_out(25),
      O => frame_credit_ready_INST_0_i_16_n_0
    );
frame_credit_ready_INST_0_i_17: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^out\(29),
      I1 => \^out\(28),
      I2 => \^out\(31),
      I3 => \^out\(30),
      O => frame_credit_ready_INST_0_i_17_n_0
    );
frame_credit_ready_INST_0_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => frame_credit_ready_INST_0_i_7_n_0,
      I1 => grant_ready40_out(7),
      I2 => grant_ready40_out(23),
      I3 => grant_ready40_out(3),
      I4 => grant_ready40_out(30),
      I5 => frame_credit_ready_INST_0_i_8_n_0,
      O => frame_credit_ready_INST_0_i_2_n_0
    );
frame_credit_ready_INST_0_i_4: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => grant_ready40_out(8),
      I1 => grant_ready40_out(2),
      I2 => grant_ready40_out(26),
      I3 => frame_credit_ready_INST_0_i_10_n_0,
      I4 => frame_credit_ready_INST_0_i_11_n_0,
      O => frame_credit_ready_INST_0_i_4_n_0
    );
frame_credit_ready_INST_0_i_5: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFBFFFFFFF"
    )
        port map (
      I0 => frame_credit_ready_INST_0_i_12_n_0,
      I1 => \^out\(6),
      I2 => \^out\(5),
      I3 => \^out\(15),
      I4 => \^out\(12),
      I5 => frame_credit_ready_INST_0_i_13_n_0,
      O => frame_credit_ready_INST_0_i_5_n_0
    );
frame_credit_ready_INST_0_i_6: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040000000"
    )
        port map (
      I0 => frame_credit_ready_INST_0_i_14_n_0,
      I1 => \^out\(18),
      I2 => \^out\(17),
      I3 => \^out\(19),
      I4 => \^out\(16),
      I5 => frame_credit_ready_INST_0_i_15_n_0,
      O => frame_credit_ready_INST_0_i_6_n_0
    );
frame_credit_ready_INST_0_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => grant_ready40_out(24),
      I1 => grant_ready40_out(31),
      I2 => grant_ready40_out(11),
      I3 => grant_ready40_out(19),
      O => frame_credit_ready_INST_0_i_7_n_0
    );
frame_credit_ready_INST_0_i_8: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => grant_ready40_out(18),
      I1 => grant_ready40_out(9),
      I2 => grant_ready40_out(29),
      I3 => grant_ready40_out(22),
      I4 => frame_credit_ready_INST_0_i_16_n_0,
      O => frame_credit_ready_INST_0_i_8_n_0
    );
frame_credit_ready_INST_0_i_9: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFF8"
    )
        port map (
      I0 => grant_ready40_out(1),
      I1 => grant_ready40_out(0),
      I2 => grant_ready40_out(16),
      I3 => grant_ready40_out(14),
      I4 => grant_ready40_out(5),
      I5 => grant_ready40_out(4),
      O => \^granted_frames_reg[3]_0\
    );
\grant_frame_id[0]_INST_0\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \grant_frame_id[0]_INST_0_n_0\,
      CO(2) => \grant_frame_id[0]_INST_0_n_1\,
      CO(1) => \grant_frame_id[0]_INST_0_n_2\,
      CO(0) => \grant_frame_id[0]_INST_0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(3 downto 0),
      O(3 downto 0) => grant_frame_id(3 downto 0),
      S(3) => \grant_frame_id[0]_INST_0_i_1_n_0\,
      S(2) => \grant_frame_id[0]_INST_0_i_2_n_0\,
      S(1) => \grant_frame_id[0]_INST_0_i_3_n_0\,
      S(0) => \grant_frame_id[0]_INST_0_i_4_n_0\
    );
\grant_frame_id[0]_INST_0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(3),
      I1 => \^out\(3),
      O => \grant_frame_id[0]_INST_0_i_1_n_0\
    );
\grant_frame_id[0]_INST_0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(2),
      I1 => \^out\(2),
      O => \grant_frame_id[0]_INST_0_i_2_n_0\
    );
\grant_frame_id[0]_INST_0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(1),
      I1 => \^out\(1),
      O => \grant_frame_id[0]_INST_0_i_3_n_0\
    );
\grant_frame_id[0]_INST_0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(0),
      I1 => \^out\(0),
      O => \grant_frame_id[0]_INST_0_i_4_n_0\
    );
\grant_frame_id[12]_INST_0\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_frame_id[8]_INST_0_n_0\,
      CO(3) => \grant_frame_id[12]_INST_0_n_0\,
      CO(2) => \grant_frame_id[12]_INST_0_n_1\,
      CO(1) => \grant_frame_id[12]_INST_0_n_2\,
      CO(0) => \grant_frame_id[12]_INST_0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(15 downto 12),
      O(3 downto 0) => grant_frame_id(15 downto 12),
      S(3) => \grant_frame_id[12]_INST_0_i_1_n_0\,
      S(2) => \grant_frame_id[12]_INST_0_i_2_n_0\,
      S(1) => \grant_frame_id[12]_INST_0_i_3_n_0\,
      S(0) => \grant_frame_id[12]_INST_0_i_4_n_0\
    );
\grant_frame_id[12]_INST_0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(15),
      I1 => \^out\(15),
      O => \grant_frame_id[12]_INST_0_i_1_n_0\
    );
\grant_frame_id[12]_INST_0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(14),
      I1 => \^out\(14),
      O => \grant_frame_id[12]_INST_0_i_2_n_0\
    );
\grant_frame_id[12]_INST_0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(13),
      I1 => \^out\(13),
      O => \grant_frame_id[12]_INST_0_i_3_n_0\
    );
\grant_frame_id[12]_INST_0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(12),
      I1 => \^out\(12),
      O => \grant_frame_id[12]_INST_0_i_4_n_0\
    );
\grant_frame_id[16]_INST_0\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_frame_id[12]_INST_0_n_0\,
      CO(3) => \grant_frame_id[16]_INST_0_n_0\,
      CO(2) => \grant_frame_id[16]_INST_0_n_1\,
      CO(1) => \grant_frame_id[16]_INST_0_n_2\,
      CO(0) => \grant_frame_id[16]_INST_0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(19 downto 16),
      O(3 downto 0) => grant_frame_id(19 downto 16),
      S(3) => \grant_frame_id[16]_INST_0_i_1_n_0\,
      S(2) => \grant_frame_id[16]_INST_0_i_2_n_0\,
      S(1) => \grant_frame_id[16]_INST_0_i_3_n_0\,
      S(0) => \grant_frame_id[16]_INST_0_i_4_n_0\
    );
\grant_frame_id[16]_INST_0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(19),
      I1 => \^out\(19),
      O => \grant_frame_id[16]_INST_0_i_1_n_0\
    );
\grant_frame_id[16]_INST_0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(18),
      I1 => \^out\(18),
      O => \grant_frame_id[16]_INST_0_i_2_n_0\
    );
\grant_frame_id[16]_INST_0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(17),
      I1 => \^out\(17),
      O => \grant_frame_id[16]_INST_0_i_3_n_0\
    );
\grant_frame_id[16]_INST_0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(16),
      I1 => \^out\(16),
      O => \grant_frame_id[16]_INST_0_i_4_n_0\
    );
\grant_frame_id[20]_INST_0\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_frame_id[16]_INST_0_n_0\,
      CO(3) => \grant_frame_id[20]_INST_0_n_0\,
      CO(2) => \grant_frame_id[20]_INST_0_n_1\,
      CO(1) => \grant_frame_id[20]_INST_0_n_2\,
      CO(0) => \grant_frame_id[20]_INST_0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(23 downto 20),
      O(3 downto 0) => grant_frame_id(23 downto 20),
      S(3) => \grant_frame_id[20]_INST_0_i_1_n_0\,
      S(2) => \grant_frame_id[20]_INST_0_i_2_n_0\,
      S(1) => \grant_frame_id[20]_INST_0_i_3_n_0\,
      S(0) => \grant_frame_id[20]_INST_0_i_4_n_0\
    );
\grant_frame_id[20]_INST_0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(23),
      I1 => \^out\(23),
      O => \grant_frame_id[20]_INST_0_i_1_n_0\
    );
\grant_frame_id[20]_INST_0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(22),
      I1 => \^out\(22),
      O => \grant_frame_id[20]_INST_0_i_2_n_0\
    );
\grant_frame_id[20]_INST_0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(21),
      I1 => \^out\(21),
      O => \grant_frame_id[20]_INST_0_i_3_n_0\
    );
\grant_frame_id[20]_INST_0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(20),
      I1 => \^out\(20),
      O => \grant_frame_id[20]_INST_0_i_4_n_0\
    );
\grant_frame_id[24]_INST_0\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_frame_id[20]_INST_0_n_0\,
      CO(3) => \grant_frame_id[24]_INST_0_n_0\,
      CO(2) => \grant_frame_id[24]_INST_0_n_1\,
      CO(1) => \grant_frame_id[24]_INST_0_n_2\,
      CO(0) => \grant_frame_id[24]_INST_0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(27 downto 24),
      O(3 downto 0) => grant_frame_id(27 downto 24),
      S(3) => \grant_frame_id[24]_INST_0_i_1_n_0\,
      S(2) => \grant_frame_id[24]_INST_0_i_2_n_0\,
      S(1) => \grant_frame_id[24]_INST_0_i_3_n_0\,
      S(0) => \grant_frame_id[24]_INST_0_i_4_n_0\
    );
\grant_frame_id[24]_INST_0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(27),
      I1 => \^out\(27),
      O => \grant_frame_id[24]_INST_0_i_1_n_0\
    );
\grant_frame_id[24]_INST_0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(26),
      I1 => \^out\(26),
      O => \grant_frame_id[24]_INST_0_i_2_n_0\
    );
\grant_frame_id[24]_INST_0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(25),
      I1 => \^out\(25),
      O => \grant_frame_id[24]_INST_0_i_3_n_0\
    );
\grant_frame_id[24]_INST_0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(24),
      I1 => \^out\(24),
      O => \grant_frame_id[24]_INST_0_i_4_n_0\
    );
\grant_frame_id[28]_INST_0\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_frame_id[24]_INST_0_n_0\,
      CO(3) => \grant_frame_id[28]_INST_0_n_0\,
      CO(2) => \grant_frame_id[28]_INST_0_n_1\,
      CO(1) => \grant_frame_id[28]_INST_0_n_2\,
      CO(0) => \grant_frame_id[28]_INST_0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(31 downto 28),
      O(3 downto 0) => grant_frame_id(31 downto 28),
      S(3) => \grant_frame_id[28]_INST_0_i_1_n_0\,
      S(2) => \grant_frame_id[28]_INST_0_i_2_n_0\,
      S(1) => \grant_frame_id[28]_INST_0_i_3_n_0\,
      S(0) => \grant_frame_id[28]_INST_0_i_4_n_0\
    );
\grant_frame_id[28]_INST_0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(31),
      I1 => \^out\(31),
      O => \grant_frame_id[28]_INST_0_i_1_n_0\
    );
\grant_frame_id[28]_INST_0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(30),
      I1 => \^out\(30),
      O => \grant_frame_id[28]_INST_0_i_2_n_0\
    );
\grant_frame_id[28]_INST_0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(29),
      I1 => \^out\(29),
      O => \grant_frame_id[28]_INST_0_i_3_n_0\
    );
\grant_frame_id[28]_INST_0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(28),
      I1 => \^out\(28),
      O => \grant_frame_id[28]_INST_0_i_4_n_0\
    );
\grant_frame_id[4]_INST_0\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_frame_id[0]_INST_0_n_0\,
      CO(3) => \grant_frame_id[4]_INST_0_n_0\,
      CO(2) => \grant_frame_id[4]_INST_0_n_1\,
      CO(1) => \grant_frame_id[4]_INST_0_n_2\,
      CO(0) => \grant_frame_id[4]_INST_0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(7 downto 4),
      O(3 downto 0) => grant_frame_id(7 downto 4),
      S(3) => \grant_frame_id[4]_INST_0_i_1_n_0\,
      S(2) => \grant_frame_id[4]_INST_0_i_2_n_0\,
      S(1) => \grant_frame_id[4]_INST_0_i_3_n_0\,
      S(0) => \grant_frame_id[4]_INST_0_i_4_n_0\
    );
\grant_frame_id[4]_INST_0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(7),
      I1 => \^out\(7),
      O => \grant_frame_id[4]_INST_0_i_1_n_0\
    );
\grant_frame_id[4]_INST_0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(6),
      I1 => \^out\(6),
      O => \grant_frame_id[4]_INST_0_i_2_n_0\
    );
\grant_frame_id[4]_INST_0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(5),
      I1 => \^out\(5),
      O => \grant_frame_id[4]_INST_0_i_3_n_0\
    );
\grant_frame_id[4]_INST_0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(4),
      I1 => \^out\(4),
      O => \grant_frame_id[4]_INST_0_i_4_n_0\
    );
\grant_frame_id[8]_INST_0\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_frame_id[4]_INST_0_n_0\,
      CO(3) => \grant_frame_id[8]_INST_0_n_0\,
      CO(2) => \grant_frame_id[8]_INST_0_n_1\,
      CO(1) => \grant_frame_id[8]_INST_0_n_2\,
      CO(0) => \grant_frame_id[8]_INST_0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => first_frame_id(11 downto 8),
      O(3 downto 0) => grant_frame_id(11 downto 8),
      S(3) => \grant_frame_id[8]_INST_0_i_1_n_0\,
      S(2) => \grant_frame_id[8]_INST_0_i_2_n_0\,
      S(1) => \grant_frame_id[8]_INST_0_i_3_n_0\,
      S(0) => \grant_frame_id[8]_INST_0_i_4_n_0\
    );
\grant_frame_id[8]_INST_0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(11),
      I1 => \^out\(11),
      O => \grant_frame_id[8]_INST_0_i_1_n_0\
    );
\grant_frame_id[8]_INST_0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(10),
      I1 => \^out\(10),
      O => \grant_frame_id[8]_INST_0_i_2_n_0\
    );
\grant_frame_id[8]_INST_0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(9),
      I1 => \^out\(9),
      O => \grant_frame_id[8]_INST_0_i_3_n_0\
    );
\grant_frame_id[8]_INST_0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => first_frame_id(8),
      I1 => \^out\(8),
      O => \grant_frame_id[8]_INST_0_i_4_n_0\
    );
grant_ready1_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => grant_ready1_carry_n_0,
      CO(2) => grant_ready1_carry_n_1,
      CO(1) => grant_ready1_carry_n_2,
      CO(0) => grant_ready1_carry_n_3,
      CYINIT => '0',
      DI(3 downto 0) => DI(3 downto 0),
      O(3 downto 0) => NLW_grant_ready1_carry_O_UNCONNECTED(3 downto 0),
      S(3 downto 0) => \grant_ready1_carry__0_0\(3 downto 0)
    );
\grant_ready1_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => grant_ready1_carry_n_0,
      CO(3) => \grant_ready1_carry__0_n_0\,
      CO(2) => \grant_ready1_carry__0_n_1\,
      CO(1) => \grant_ready1_carry__0_n_2\,
      CO(0) => \grant_ready1_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => \grant_ready1_carry__1_0\(3 downto 0),
      O(3 downto 0) => \NLW_grant_ready1_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => \grant_ready1_carry__1_1\(3 downto 0)
    );
\grant_ready1_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_ready1_carry__0_n_0\,
      CO(3) => \grant_ready1_carry__1_n_0\,
      CO(2) => \grant_ready1_carry__1_n_1\,
      CO(1) => \grant_ready1_carry__1_n_2\,
      CO(0) => \grant_ready1_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => \grant_ready1_carry__2_0\(3 downto 0),
      O(3 downto 0) => \NLW_grant_ready1_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => \grant_ready1_carry__2_1\(3 downto 0)
    );
\grant_ready1_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_ready1_carry__1_n_0\,
      CO(3) => \^co\(0),
      CO(2) => \grant_ready1_carry__2_n_1\,
      CO(1) => \grant_ready1_carry__2_n_2\,
      CO(0) => \grant_ready1_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => frame_credit_ready_INST_0_i_3(3 downto 0),
      O(3 downto 0) => \NLW_grant_ready1_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => frame_credit_ready_INST_0_i_3_0(3 downto 0)
    );
grant_ready4_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => grant_ready4_carry_n_0,
      CO(2) => grant_ready4_carry_n_1,
      CO(1) => grant_ready4_carry_n_2,
      CO(0) => grant_ready4_carry_n_3,
      CYINIT => '1',
      DI(3 downto 0) => \^out\(3 downto 0),
      O(3 downto 0) => grant_ready40_out(3 downto 0),
      S(3) => grant_ready4_carry_i_1_n_0,
      S(2) => grant_ready4_carry_i_2_n_0,
      S(1) => grant_ready4_carry_i_3_n_0,
      S(0) => grant_ready4_carry_i_4_n_0
    );
\grant_ready4_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => grant_ready4_carry_n_0,
      CO(3) => \grant_ready4_carry__0_n_0\,
      CO(2) => \grant_ready4_carry__0_n_1\,
      CO(1) => \grant_ready4_carry__0_n_2\,
      CO(0) => \grant_ready4_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => \^out\(7 downto 4),
      O(3 downto 0) => grant_ready40_out(7 downto 4),
      S(3) => \grant_ready4_carry__0_i_1_n_0\,
      S(2) => \grant_ready4_carry__0_i_2_n_0\,
      S(1) => \grant_ready4_carry__0_i_3_n_0\,
      S(0) => \grant_ready4_carry__0_i_4_n_0\
    );
\grant_ready4_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(7),
      I1 => \^released_frames_reg[31]_0\(7),
      O => \grant_ready4_carry__0_i_1_n_0\
    );
\grant_ready4_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(6),
      I1 => \^released_frames_reg[31]_0\(6),
      O => \grant_ready4_carry__0_i_2_n_0\
    );
\grant_ready4_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(5),
      I1 => \^released_frames_reg[31]_0\(5),
      O => \grant_ready4_carry__0_i_3_n_0\
    );
\grant_ready4_carry__0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(4),
      I1 => \^released_frames_reg[31]_0\(4),
      O => \grant_ready4_carry__0_i_4_n_0\
    );
\grant_ready4_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_ready4_carry__0_n_0\,
      CO(3) => \grant_ready4_carry__1_n_0\,
      CO(2) => \grant_ready4_carry__1_n_1\,
      CO(1) => \grant_ready4_carry__1_n_2\,
      CO(0) => \grant_ready4_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => \^out\(11 downto 8),
      O(3 downto 0) => grant_ready40_out(11 downto 8),
      S(3) => \grant_ready4_carry__1_i_1_n_0\,
      S(2) => \grant_ready4_carry__1_i_2_n_0\,
      S(1) => \grant_ready4_carry__1_i_3_n_0\,
      S(0) => \grant_ready4_carry__1_i_4_n_0\
    );
\grant_ready4_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(11),
      I1 => \^released_frames_reg[31]_0\(11),
      O => \grant_ready4_carry__1_i_1_n_0\
    );
\grant_ready4_carry__1_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(10),
      I1 => \^released_frames_reg[31]_0\(10),
      O => \grant_ready4_carry__1_i_2_n_0\
    );
\grant_ready4_carry__1_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(9),
      I1 => \^released_frames_reg[31]_0\(9),
      O => \grant_ready4_carry__1_i_3_n_0\
    );
\grant_ready4_carry__1_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(8),
      I1 => \^released_frames_reg[31]_0\(8),
      O => \grant_ready4_carry__1_i_4_n_0\
    );
\grant_ready4_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_ready4_carry__1_n_0\,
      CO(3) => \grant_ready4_carry__2_n_0\,
      CO(2) => \grant_ready4_carry__2_n_1\,
      CO(1) => \grant_ready4_carry__2_n_2\,
      CO(0) => \grant_ready4_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => \^out\(15 downto 12),
      O(3 downto 0) => grant_ready40_out(15 downto 12),
      S(3) => \grant_ready4_carry__2_i_1_n_0\,
      S(2) => \grant_ready4_carry__2_i_2_n_0\,
      S(1) => \grant_ready4_carry__2_i_3_n_0\,
      S(0) => \grant_ready4_carry__2_i_4_n_0\
    );
\grant_ready4_carry__2_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(15),
      I1 => \^released_frames_reg[31]_0\(15),
      O => \grant_ready4_carry__2_i_1_n_0\
    );
\grant_ready4_carry__2_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(14),
      I1 => \^released_frames_reg[31]_0\(14),
      O => \grant_ready4_carry__2_i_2_n_0\
    );
\grant_ready4_carry__2_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(13),
      I1 => \^released_frames_reg[31]_0\(13),
      O => \grant_ready4_carry__2_i_3_n_0\
    );
\grant_ready4_carry__2_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(12),
      I1 => \^released_frames_reg[31]_0\(12),
      O => \grant_ready4_carry__2_i_4_n_0\
    );
\grant_ready4_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_ready4_carry__2_n_0\,
      CO(3) => \grant_ready4_carry__3_n_0\,
      CO(2) => \grant_ready4_carry__3_n_1\,
      CO(1) => \grant_ready4_carry__3_n_2\,
      CO(0) => \grant_ready4_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => \^out\(19 downto 16),
      O(3 downto 0) => grant_ready40_out(19 downto 16),
      S(3) => \grant_ready4_carry__3_i_1_n_0\,
      S(2) => \grant_ready4_carry__3_i_2_n_0\,
      S(1) => \grant_ready4_carry__3_i_3_n_0\,
      S(0) => \grant_ready4_carry__3_i_4_n_0\
    );
\grant_ready4_carry__3_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(19),
      I1 => \^released_frames_reg[31]_0\(19),
      O => \grant_ready4_carry__3_i_1_n_0\
    );
\grant_ready4_carry__3_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(18),
      I1 => \^released_frames_reg[31]_0\(18),
      O => \grant_ready4_carry__3_i_2_n_0\
    );
\grant_ready4_carry__3_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(17),
      I1 => \^released_frames_reg[31]_0\(17),
      O => \grant_ready4_carry__3_i_3_n_0\
    );
\grant_ready4_carry__3_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(16),
      I1 => \^released_frames_reg[31]_0\(16),
      O => \grant_ready4_carry__3_i_4_n_0\
    );
\grant_ready4_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_ready4_carry__3_n_0\,
      CO(3) => \grant_ready4_carry__4_n_0\,
      CO(2) => \grant_ready4_carry__4_n_1\,
      CO(1) => \grant_ready4_carry__4_n_2\,
      CO(0) => \grant_ready4_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => \^out\(23 downto 20),
      O(3 downto 0) => grant_ready40_out(23 downto 20),
      S(3) => \grant_ready4_carry__4_i_1_n_0\,
      S(2) => \grant_ready4_carry__4_i_2_n_0\,
      S(1) => \grant_ready4_carry__4_i_3_n_0\,
      S(0) => \grant_ready4_carry__4_i_4_n_0\
    );
\grant_ready4_carry__4_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(23),
      I1 => \^released_frames_reg[31]_0\(23),
      O => \grant_ready4_carry__4_i_1_n_0\
    );
\grant_ready4_carry__4_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(22),
      I1 => \^released_frames_reg[31]_0\(22),
      O => \grant_ready4_carry__4_i_2_n_0\
    );
\grant_ready4_carry__4_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(21),
      I1 => \^released_frames_reg[31]_0\(21),
      O => \grant_ready4_carry__4_i_3_n_0\
    );
\grant_ready4_carry__4_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(20),
      I1 => \^released_frames_reg[31]_0\(20),
      O => \grant_ready4_carry__4_i_4_n_0\
    );
\grant_ready4_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_ready4_carry__4_n_0\,
      CO(3) => \grant_ready4_carry__5_n_0\,
      CO(2) => \grant_ready4_carry__5_n_1\,
      CO(1) => \grant_ready4_carry__5_n_2\,
      CO(0) => \grant_ready4_carry__5_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => \^out\(27 downto 24),
      O(3 downto 0) => grant_ready40_out(27 downto 24),
      S(3) => \grant_ready4_carry__5_i_1_n_0\,
      S(2) => \grant_ready4_carry__5_i_2_n_0\,
      S(1) => \grant_ready4_carry__5_i_3_n_0\,
      S(0) => \grant_ready4_carry__5_i_4_n_0\
    );
\grant_ready4_carry__5_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(27),
      I1 => \^released_frames_reg[31]_0\(27),
      O => \grant_ready4_carry__5_i_1_n_0\
    );
\grant_ready4_carry__5_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(26),
      I1 => \^released_frames_reg[31]_0\(26),
      O => \grant_ready4_carry__5_i_2_n_0\
    );
\grant_ready4_carry__5_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(25),
      I1 => \^released_frames_reg[31]_0\(25),
      O => \grant_ready4_carry__5_i_3_n_0\
    );
\grant_ready4_carry__5_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(24),
      I1 => \^released_frames_reg[31]_0\(24),
      O => \grant_ready4_carry__5_i_4_n_0\
    );
\grant_ready4_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \grant_ready4_carry__5_n_0\,
      CO(3) => \NLW_grant_ready4_carry__6_CO_UNCONNECTED\(3),
      CO(2) => \grant_ready4_carry__6_n_1\,
      CO(1) => \grant_ready4_carry__6_n_2\,
      CO(0) => \grant_ready4_carry__6_n_3\,
      CYINIT => '0',
      DI(3) => '0',
      DI(2 downto 0) => \^out\(30 downto 28),
      O(3 downto 0) => grant_ready40_out(31 downto 28),
      S(3) => \grant_ready4_carry__6_i_1_n_0\,
      S(2) => \grant_ready4_carry__6_i_2_n_0\,
      S(1) => \grant_ready4_carry__6_i_3_n_0\,
      S(0) => \grant_ready4_carry__6_i_4_n_0\
    );
\grant_ready4_carry__6_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(31),
      I1 => \^out\(31),
      O => \grant_ready4_carry__6_i_1_n_0\
    );
\grant_ready4_carry__6_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(30),
      I1 => \^released_frames_reg[31]_0\(30),
      O => \grant_ready4_carry__6_i_2_n_0\
    );
\grant_ready4_carry__6_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(29),
      I1 => \^released_frames_reg[31]_0\(29),
      O => \grant_ready4_carry__6_i_3_n_0\
    );
\grant_ready4_carry__6_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(28),
      I1 => \^released_frames_reg[31]_0\(28),
      O => \grant_ready4_carry__6_i_4_n_0\
    );
grant_ready4_carry_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(3),
      I1 => \^released_frames_reg[31]_0\(3),
      O => grant_ready4_carry_i_1_n_0
    );
grant_ready4_carry_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(2),
      I1 => \^released_frames_reg[31]_0\(2),
      O => grant_ready4_carry_i_2_n_0
    );
grant_ready4_carry_i_3: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(1),
      I1 => \^released_frames_reg[31]_0\(1),
      O => grant_ready4_carry_i_3_n_0
    );
grant_ready4_carry_i_4: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^out\(0),
      I1 => \^released_frames_reg[31]_0\(0),
      O => grant_ready4_carry_i_4_n_0
    );
\granted_frames[3]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^out\(0),
      O => \granted_frames[3]_i_2_n_0\
    );
\granted_frames_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[3]_i_1_n_7\,
      Q => \^out\(0),
      R => \^clear\
    );
\granted_frames_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[11]_i_1_n_5\,
      Q => \^out\(10),
      R => \^clear\
    );
\granted_frames_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[11]_i_1_n_4\,
      Q => \^out\(11),
      R => \^clear\
    );
\granted_frames_reg[11]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \granted_frames_reg[7]_i_1_n_0\,
      CO(3) => \granted_frames_reg[11]_i_1_n_0\,
      CO(2) => \granted_frames_reg[11]_i_1_n_1\,
      CO(1) => \granted_frames_reg[11]_i_1_n_2\,
      CO(0) => \granted_frames_reg[11]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \granted_frames_reg[11]_i_1_n_4\,
      O(2) => \granted_frames_reg[11]_i_1_n_5\,
      O(1) => \granted_frames_reg[11]_i_1_n_6\,
      O(0) => \granted_frames_reg[11]_i_1_n_7\,
      S(3 downto 0) => \^out\(11 downto 8)
    );
\granted_frames_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[15]_i_1_n_7\,
      Q => \^out\(12),
      R => \^clear\
    );
\granted_frames_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[15]_i_1_n_6\,
      Q => \^out\(13),
      R => \^clear\
    );
\granted_frames_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[15]_i_1_n_5\,
      Q => \^out\(14),
      R => \^clear\
    );
\granted_frames_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[15]_i_1_n_4\,
      Q => \^out\(15),
      R => \^clear\
    );
\granted_frames_reg[15]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \granted_frames_reg[11]_i_1_n_0\,
      CO(3) => \granted_frames_reg[15]_i_1_n_0\,
      CO(2) => \granted_frames_reg[15]_i_1_n_1\,
      CO(1) => \granted_frames_reg[15]_i_1_n_2\,
      CO(0) => \granted_frames_reg[15]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \granted_frames_reg[15]_i_1_n_4\,
      O(2) => \granted_frames_reg[15]_i_1_n_5\,
      O(1) => \granted_frames_reg[15]_i_1_n_6\,
      O(0) => \granted_frames_reg[15]_i_1_n_7\,
      S(3 downto 0) => \^out\(15 downto 12)
    );
\granted_frames_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[19]_i_1_n_7\,
      Q => \^out\(16),
      R => \^clear\
    );
\granted_frames_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[19]_i_1_n_6\,
      Q => \^out\(17),
      R => \^clear\
    );
\granted_frames_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[19]_i_1_n_5\,
      Q => \^out\(18),
      R => \^clear\
    );
\granted_frames_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[19]_i_1_n_4\,
      Q => \^out\(19),
      R => \^clear\
    );
\granted_frames_reg[19]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \granted_frames_reg[15]_i_1_n_0\,
      CO(3) => \granted_frames_reg[19]_i_1_n_0\,
      CO(2) => \granted_frames_reg[19]_i_1_n_1\,
      CO(1) => \granted_frames_reg[19]_i_1_n_2\,
      CO(0) => \granted_frames_reg[19]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \granted_frames_reg[19]_i_1_n_4\,
      O(2) => \granted_frames_reg[19]_i_1_n_5\,
      O(1) => \granted_frames_reg[19]_i_1_n_6\,
      O(0) => \granted_frames_reg[19]_i_1_n_7\,
      S(3 downto 0) => \^out\(19 downto 16)
    );
\granted_frames_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[3]_i_1_n_6\,
      Q => \^out\(1),
      R => \^clear\
    );
\granted_frames_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[23]_i_1_n_7\,
      Q => \^out\(20),
      R => \^clear\
    );
\granted_frames_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[23]_i_1_n_6\,
      Q => \^out\(21),
      R => \^clear\
    );
\granted_frames_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[23]_i_1_n_5\,
      Q => \^out\(22),
      R => \^clear\
    );
\granted_frames_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[23]_i_1_n_4\,
      Q => \^out\(23),
      R => \^clear\
    );
\granted_frames_reg[23]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \granted_frames_reg[19]_i_1_n_0\,
      CO(3) => \granted_frames_reg[23]_i_1_n_0\,
      CO(2) => \granted_frames_reg[23]_i_1_n_1\,
      CO(1) => \granted_frames_reg[23]_i_1_n_2\,
      CO(0) => \granted_frames_reg[23]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \granted_frames_reg[23]_i_1_n_4\,
      O(2) => \granted_frames_reg[23]_i_1_n_5\,
      O(1) => \granted_frames_reg[23]_i_1_n_6\,
      O(0) => \granted_frames_reg[23]_i_1_n_7\,
      S(3 downto 0) => \^out\(23 downto 20)
    );
\granted_frames_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[27]_i_1_n_7\,
      Q => \^out\(24),
      R => \^clear\
    );
\granted_frames_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[27]_i_1_n_6\,
      Q => \^out\(25),
      R => \^clear\
    );
\granted_frames_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[27]_i_1_n_5\,
      Q => \^out\(26),
      R => \^clear\
    );
\granted_frames_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[27]_i_1_n_4\,
      Q => \^out\(27),
      R => \^clear\
    );
\granted_frames_reg[27]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \granted_frames_reg[23]_i_1_n_0\,
      CO(3) => \granted_frames_reg[27]_i_1_n_0\,
      CO(2) => \granted_frames_reg[27]_i_1_n_1\,
      CO(1) => \granted_frames_reg[27]_i_1_n_2\,
      CO(0) => \granted_frames_reg[27]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \granted_frames_reg[27]_i_1_n_4\,
      O(2) => \granted_frames_reg[27]_i_1_n_5\,
      O(1) => \granted_frames_reg[27]_i_1_n_6\,
      O(0) => \granted_frames_reg[27]_i_1_n_7\,
      S(3 downto 0) => \^out\(27 downto 24)
    );
\granted_frames_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[31]_i_1_n_7\,
      Q => \^out\(28),
      R => \^clear\
    );
\granted_frames_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[31]_i_1_n_6\,
      Q => \^out\(29),
      R => \^clear\
    );
\granted_frames_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[3]_i_1_n_5\,
      Q => \^out\(2),
      R => \^clear\
    );
\granted_frames_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[31]_i_1_n_5\,
      Q => \^out\(30),
      R => \^clear\
    );
\granted_frames_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[31]_i_1_n_4\,
      Q => \^out\(31),
      R => \^clear\
    );
\granted_frames_reg[31]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \granted_frames_reg[27]_i_1_n_0\,
      CO(3) => \NLW_granted_frames_reg[31]_i_1_CO_UNCONNECTED\(3),
      CO(2) => \granted_frames_reg[31]_i_1_n_1\,
      CO(1) => \granted_frames_reg[31]_i_1_n_2\,
      CO(0) => \granted_frames_reg[31]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \granted_frames_reg[31]_i_1_n_4\,
      O(2) => \granted_frames_reg[31]_i_1_n_5\,
      O(1) => \granted_frames_reg[31]_i_1_n_6\,
      O(0) => \granted_frames_reg[31]_i_1_n_7\,
      S(3 downto 0) => \^out\(31 downto 28)
    );
\granted_frames_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[3]_i_1_n_4\,
      Q => \^out\(3),
      R => \^clear\
    );
\granted_frames_reg[3]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \granted_frames_reg[3]_i_1_n_0\,
      CO(2) => \granted_frames_reg[3]_i_1_n_1\,
      CO(1) => \granted_frames_reg[3]_i_1_n_2\,
      CO(0) => \granted_frames_reg[3]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \granted_frames_reg[3]_i_1_n_4\,
      O(2) => \granted_frames_reg[3]_i_1_n_5\,
      O(1) => \granted_frames_reg[3]_i_1_n_6\,
      O(0) => \granted_frames_reg[3]_i_1_n_7\,
      S(3 downto 1) => \^out\(3 downto 1),
      S(0) => \granted_frames[3]_i_2_n_0\
    );
\granted_frames_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[7]_i_1_n_7\,
      Q => \^out\(4),
      R => \^clear\
    );
\granted_frames_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[7]_i_1_n_6\,
      Q => \^out\(5),
      R => \^clear\
    );
\granted_frames_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[7]_i_1_n_5\,
      Q => \^out\(6),
      R => \^clear\
    );
\granted_frames_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[7]_i_1_n_4\,
      Q => \^out\(7),
      R => \^clear\
    );
\granted_frames_reg[7]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \granted_frames_reg[3]_i_1_n_0\,
      CO(3) => \granted_frames_reg[7]_i_1_n_0\,
      CO(2) => \granted_frames_reg[7]_i_1_n_1\,
      CO(1) => \granted_frames_reg[7]_i_1_n_2\,
      CO(0) => \granted_frames_reg[7]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \granted_frames_reg[7]_i_1_n_4\,
      O(2) => \granted_frames_reg[7]_i_1_n_5\,
      O(1) => \granted_frames_reg[7]_i_1_n_6\,
      O(0) => \granted_frames_reg[7]_i_1_n_7\,
      S(3 downto 0) => \^out\(7 downto 4)
    );
\granted_frames_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[11]_i_1_n_7\,
      Q => \^out\(8),
      R => \^clear\
    );
\granted_frames_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \granted_frames_reg[11]_i_1_n_6\,
      Q => \^out\(9),
      R => \^clear\
    );
\i__carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(15),
      I1 => packet_completed_frames(15),
      I2 => previous_packet(14),
      I3 => packet_completed_frames(14),
      O => \i__carry__0_i_1_n_0\
    );
\i__carry__0_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_frame_id(22),
      I1 => \^available_frame_id\(22),
      I2 => cpu_frame_id(21),
      I3 => \^available_frame_id\(21),
      I4 => \^available_frame_id\(23),
      I5 => cpu_frame_id(23),
      O => \i__carry__0_i_1__0_n_0\
    );
\i__carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(13),
      I1 => packet_completed_frames(13),
      I2 => previous_packet(12),
      I3 => packet_completed_frames(12),
      O => \i__carry__0_i_2_n_0\
    );
\i__carry__0_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_frame_id(20),
      I1 => \^available_frame_id\(20),
      I2 => cpu_frame_id(18),
      I3 => \^available_frame_id\(18),
      I4 => \^available_frame_id\(19),
      I5 => cpu_frame_id(19),
      O => \i__carry__0_i_2__0_n_0\
    );
\i__carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(11),
      I1 => packet_completed_frames(11),
      I2 => previous_packet(10),
      I3 => packet_completed_frames(10),
      O => \i__carry__0_i_3_n_0\
    );
\i__carry__0_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_frame_id(16),
      I1 => \^available_frame_id\(16),
      I2 => cpu_frame_id(15),
      I3 => \^available_frame_id\(15),
      I4 => \^available_frame_id\(17),
      I5 => cpu_frame_id(17),
      O => \i__carry__0_i_3__0_n_0\
    );
\i__carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(9),
      I1 => packet_completed_frames(9),
      I2 => previous_packet(8),
      I3 => packet_completed_frames(8),
      O => \i__carry__0_i_4_n_0\
    );
\i__carry__0_i_4__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_frame_id(12),
      I1 => \^available_frame_id\(12),
      I2 => cpu_frame_id(13),
      I3 => \^available_frame_id\(13),
      I4 => \^available_frame_id\(14),
      I5 => cpu_frame_id(14),
      O => \i__carry__0_i_4__0_n_0\
    );
\i__carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(15),
      I1 => previous_packet(15),
      I2 => packet_completed_frames(14),
      I3 => previous_packet(14),
      O => \i__carry__0_i_5_n_0\
    );
\i__carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(13),
      I1 => previous_packet(13),
      I2 => packet_completed_frames(12),
      I3 => previous_packet(12),
      O => \i__carry__0_i_6_n_0\
    );
\i__carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(11),
      I1 => previous_packet(11),
      I2 => packet_completed_frames(10),
      I3 => previous_packet(10),
      O => \i__carry__0_i_7_n_0\
    );
\i__carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(9),
      I1 => previous_packet(9),
      I2 => packet_completed_frames(8),
      I3 => previous_packet(8),
      O => \i__carry__0_i_8_n_0\
    );
\i__carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(23),
      I1 => packet_completed_frames(23),
      I2 => previous_packet(22),
      I3 => packet_completed_frames(22),
      O => \i__carry__1_i_1_n_0\
    );
\i__carry__1_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^available_frame_id\(31),
      I1 => cpu_frame_id(31),
      I2 => \^available_frame_id\(30),
      I3 => cpu_frame_id(30),
      O => \i__carry__1_i_1__0_n_0\
    );
\i__carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(21),
      I1 => packet_completed_frames(21),
      I2 => previous_packet(20),
      I3 => packet_completed_frames(20),
      O => \i__carry__1_i_2_n_0\
    );
\i__carry__1_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_frame_id(27),
      I1 => \^available_frame_id\(27),
      I2 => cpu_frame_id(28),
      I3 => \^available_frame_id\(28),
      I4 => \^available_frame_id\(29),
      I5 => cpu_frame_id(29),
      O => \i__carry__1_i_2__0_n_0\
    );
\i__carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(19),
      I1 => packet_completed_frames(19),
      I2 => previous_packet(18),
      I3 => packet_completed_frames(18),
      O => \i__carry__1_i_3_n_0\
    );
\i__carry__1_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_frame_id(25),
      I1 => \^available_frame_id\(25),
      I2 => cpu_frame_id(24),
      I3 => \^available_frame_id\(24),
      I4 => \^available_frame_id\(26),
      I5 => cpu_frame_id(26),
      O => \i__carry__1_i_3__0_n_0\
    );
\i__carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(17),
      I1 => packet_completed_frames(17),
      I2 => previous_packet(16),
      I3 => packet_completed_frames(16),
      O => \i__carry__1_i_4_n_0\
    );
\i__carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(23),
      I1 => previous_packet(23),
      I2 => packet_completed_frames(22),
      I3 => previous_packet(22),
      O => \i__carry__1_i_5_n_0\
    );
\i__carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(21),
      I1 => previous_packet(21),
      I2 => packet_completed_frames(20),
      I3 => previous_packet(20),
      O => \i__carry__1_i_6_n_0\
    );
\i__carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(19),
      I1 => previous_packet(19),
      I2 => packet_completed_frames(18),
      I3 => previous_packet(18),
      O => \i__carry__1_i_7_n_0\
    );
\i__carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(17),
      I1 => previous_packet(17),
      I2 => packet_completed_frames(16),
      I3 => previous_packet(16),
      O => \i__carry__1_i_8_n_0\
    );
\i__carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(31),
      I1 => packet_completed_frames(31),
      I2 => previous_packet(30),
      I3 => packet_completed_frames(30),
      O => \i__carry__2_i_1_n_0\
    );
\i__carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(29),
      I1 => packet_completed_frames(29),
      I2 => previous_packet(28),
      I3 => packet_completed_frames(28),
      O => \i__carry__2_i_2_n_0\
    );
\i__carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(27),
      I1 => packet_completed_frames(27),
      I2 => previous_packet(26),
      I3 => packet_completed_frames(26),
      O => \i__carry__2_i_3_n_0\
    );
\i__carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(25),
      I1 => packet_completed_frames(25),
      I2 => previous_packet(24),
      I3 => packet_completed_frames(24),
      O => \i__carry__2_i_4_n_0\
    );
\i__carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(31),
      I1 => previous_packet(31),
      I2 => packet_completed_frames(30),
      I3 => previous_packet(30),
      O => \i__carry__2_i_5_n_0\
    );
\i__carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(29),
      I1 => previous_packet(29),
      I2 => packet_completed_frames(28),
      I3 => previous_packet(28),
      O => \i__carry__2_i_6_n_0\
    );
\i__carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(27),
      I1 => previous_packet(27),
      I2 => packet_completed_frames(26),
      I3 => previous_packet(26),
      O => \i__carry__2_i_7_n_0\
    );
\i__carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(25),
      I1 => previous_packet(25),
      I2 => packet_completed_frames(24),
      I3 => previous_packet(24),
      O => \i__carry__2_i_8_n_0\
    );
\i__carry_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(7),
      I1 => packet_completed_frames(7),
      I2 => previous_packet(6),
      I3 => packet_completed_frames(6),
      O => \i__carry_i_1_n_0\
    );
\i__carry_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_frame_id(9),
      I1 => \^available_frame_id\(9),
      I2 => cpu_frame_id(10),
      I3 => \^available_frame_id\(10),
      I4 => \^available_frame_id\(11),
      I5 => cpu_frame_id(11),
      O => \i__carry_i_1__0_n_0\
    );
\i__carry_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(5),
      I1 => packet_completed_frames(5),
      I2 => previous_packet(4),
      I3 => packet_completed_frames(4),
      O => \i__carry_i_2_n_0\
    );
\i__carry_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_frame_id(6),
      I1 => \^available_frame_id\(6),
      I2 => cpu_frame_id(7),
      I3 => \^available_frame_id\(7),
      I4 => \^available_frame_id\(8),
      I5 => cpu_frame_id(8),
      O => \i__carry_i_2__0_n_0\
    );
\i__carry_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(3),
      I1 => packet_completed_frames(3),
      I2 => previous_packet(2),
      I3 => packet_completed_frames(2),
      O => \i__carry_i_3_n_0\
    );
\i__carry_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_frame_id(3),
      I1 => \^available_frame_id\(3),
      I2 => cpu_frame_id(4),
      I3 => \^available_frame_id\(4),
      I4 => \^available_frame_id\(5),
      I5 => cpu_frame_id(5),
      O => \i__carry_i_3__0_n_0\
    );
\i__carry_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22B2"
    )
        port map (
      I0 => previous_packet(1),
      I1 => packet_completed_frames(1),
      I2 => previous_packet(0),
      I3 => packet_completed_frames(0),
      O => \i__carry_i_4_n_0\
    );
\i__carry_i_4__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_frame_id(2),
      I1 => \^available_frame_id\(2),
      I2 => cpu_frame_id(0),
      I3 => \^available_frame_id\(0),
      I4 => \^available_frame_id\(1),
      I5 => cpu_frame_id(1),
      O => \i__carry_i_4__0_n_0\
    );
\i__carry_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(7),
      I1 => previous_packet(7),
      I2 => packet_completed_frames(6),
      I3 => previous_packet(6),
      O => \i__carry_i_5_n_0\
    );
\i__carry_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(5),
      I1 => previous_packet(5),
      I2 => packet_completed_frames(4),
      I3 => previous_packet(4),
      O => \i__carry_i_6_n_0\
    );
\i__carry_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(3),
      I1 => previous_packet(3),
      I2 => packet_completed_frames(2),
      I3 => previous_packet(2),
      O => \i__carry_i_7_n_0\
    );
\i__carry_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(1),
      I1 => previous_packet(1),
      I2 => packet_completed_frames(0),
      I3 => previous_packet(0),
      O => \i__carry_i_8_n_0\
    );
owner_drained4_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => owner_drained4_carry_n_0,
      CO(2) => owner_drained4_carry_n_1,
      CO(1) => owner_drained4_carry_n_2,
      CO(0) => owner_drained4_carry_n_3,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_owner_drained4_carry_O_UNCONNECTED(3 downto 0),
      S(3) => owner_drained4_carry_i_1_n_0,
      S(2) => owner_drained4_carry_i_2_n_0,
      S(1) => owner_drained4_carry_i_3_n_0,
      S(0) => owner_drained4_carry_i_4_n_0
    );
\owner_drained4_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => owner_drained4_carry_n_0,
      CO(3) => \owner_drained4_carry__0_n_0\,
      CO(2) => \owner_drained4_carry__0_n_1\,
      CO(1) => \owner_drained4_carry__0_n_2\,
      CO(0) => \owner_drained4_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_owner_drained4_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \owner_drained4_carry__0_i_1_n_0\,
      S(2) => \owner_drained4_carry__0_i_2_n_0\,
      S(1) => \owner_drained4_carry__0_i_3_n_0\,
      S(0) => \owner_drained4_carry__0_i_4_n_0\
    );
\owner_drained4_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(22),
      I1 => status_completed_frames(22),
      I2 => \^out\(23),
      I3 => status_completed_frames(23),
      I4 => status_completed_frames(21),
      I5 => \^out\(21),
      O => \owner_drained4_carry__0_i_1_n_0\
    );
\owner_drained4_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(18),
      I1 => status_completed_frames(18),
      I2 => \^out\(19),
      I3 => status_completed_frames(19),
      I4 => status_completed_frames(20),
      I5 => \^out\(20),
      O => \owner_drained4_carry__0_i_2_n_0\
    );
\owner_drained4_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(16),
      I1 => status_completed_frames(16),
      I2 => \^out\(17),
      I3 => status_completed_frames(17),
      I4 => status_completed_frames(15),
      I5 => \^out\(15),
      O => \owner_drained4_carry__0_i_3_n_0\
    );
\owner_drained4_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(12),
      I1 => status_completed_frames(12),
      I2 => \^out\(13),
      I3 => status_completed_frames(13),
      I4 => status_completed_frames(14),
      I5 => \^out\(14),
      O => \owner_drained4_carry__0_i_4_n_0\
    );
\owner_drained4_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \owner_drained4_carry__0_n_0\,
      CO(3) => \NLW_owner_drained4_carry__1_CO_UNCONNECTED\(3),
      CO(2) => owner_drained4,
      CO(1) => \owner_drained4_carry__1_n_2\,
      CO(0) => \owner_drained4_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_owner_drained4_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \owner_drained4_carry__1_i_1_n_0\,
      S(1) => \owner_drained4_carry__1_i_2_n_0\,
      S(0) => \owner_drained4_carry__1_i_3_n_0\
    );
\owner_drained4_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => status_completed_frames(31),
      I1 => \^out\(31),
      I2 => status_completed_frames(30),
      I3 => \^out\(30),
      O => \owner_drained4_carry__1_i_1_n_0\
    );
\owner_drained4_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(28),
      I1 => status_completed_frames(28),
      I2 => \^out\(29),
      I3 => status_completed_frames(29),
      I4 => status_completed_frames(27),
      I5 => \^out\(27),
      O => \owner_drained4_carry__1_i_2_n_0\
    );
\owner_drained4_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(24),
      I1 => status_completed_frames(24),
      I2 => \^out\(25),
      I3 => status_completed_frames(25),
      I4 => status_completed_frames(26),
      I5 => \^out\(26),
      O => \owner_drained4_carry__1_i_3_n_0\
    );
owner_drained4_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(10),
      I1 => status_completed_frames(10),
      I2 => \^out\(11),
      I3 => status_completed_frames(11),
      I4 => status_completed_frames(9),
      I5 => \^out\(9),
      O => owner_drained4_carry_i_1_n_0
    );
owner_drained4_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(6),
      I1 => status_completed_frames(6),
      I2 => \^out\(7),
      I3 => status_completed_frames(7),
      I4 => status_completed_frames(8),
      I5 => \^out\(8),
      O => owner_drained4_carry_i_2_n_0
    );
owner_drained4_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(4),
      I1 => status_completed_frames(4),
      I2 => \^out\(5),
      I3 => status_completed_frames(5),
      I4 => status_completed_frames(3),
      I5 => \^out\(3),
      O => owner_drained4_carry_i_3_n_0
    );
owner_drained4_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(0),
      I1 => status_completed_frames(0),
      I2 => \^out\(1),
      I3 => status_completed_frames(1),
      I4 => status_completed_frames(2),
      I5 => \^out\(2),
      O => owner_drained4_carry_i_4_n_0
    );
owner_drained5_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => owner_drained5_carry_n_0,
      CO(2) => owner_drained5_carry_n_1,
      CO(1) => owner_drained5_carry_n_2,
      CO(0) => owner_drained5_carry_n_3,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_owner_drained5_carry_O_UNCONNECTED(3 downto 0),
      S(3) => owner_drained5_carry_i_1_n_0,
      S(2) => owner_drained5_carry_i_2_n_0,
      S(1) => owner_drained5_carry_i_3_n_0,
      S(0) => owner_drained5_carry_i_4_n_0
    );
\owner_drained5_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => owner_drained5_carry_n_0,
      CO(3) => \owner_drained5_carry__0_n_0\,
      CO(2) => \owner_drained5_carry__0_n_1\,
      CO(1) => \owner_drained5_carry__0_n_2\,
      CO(0) => \owner_drained5_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_owner_drained5_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \owner_drained5_carry__0_i_1_n_0\,
      S(2) => \owner_drained5_carry__0_i_2_n_0\,
      S(1) => \owner_drained5_carry__0_i_3_n_0\,
      S(0) => \owner_drained5_carry__0_i_4_n_0\
    );
\owner_drained5_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(22),
      I1 => packet_completed_frames(22),
      I2 => \^out\(23),
      I3 => packet_completed_frames(23),
      I4 => packet_completed_frames(21),
      I5 => \^out\(21),
      O => \owner_drained5_carry__0_i_1_n_0\
    );
\owner_drained5_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(18),
      I1 => packet_completed_frames(18),
      I2 => \^out\(19),
      I3 => packet_completed_frames(19),
      I4 => packet_completed_frames(20),
      I5 => \^out\(20),
      O => \owner_drained5_carry__0_i_2_n_0\
    );
\owner_drained5_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(16),
      I1 => packet_completed_frames(16),
      I2 => \^out\(17),
      I3 => packet_completed_frames(17),
      I4 => packet_completed_frames(15),
      I5 => \^out\(15),
      O => \owner_drained5_carry__0_i_3_n_0\
    );
\owner_drained5_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(12),
      I1 => packet_completed_frames(12),
      I2 => \^out\(13),
      I3 => packet_completed_frames(13),
      I4 => packet_completed_frames(14),
      I5 => \^out\(14),
      O => \owner_drained5_carry__0_i_4_n_0\
    );
\owner_drained5_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \owner_drained5_carry__0_n_0\,
      CO(3) => \NLW_owner_drained5_carry__1_CO_UNCONNECTED\(3),
      CO(2) => owner_drained5,
      CO(1) => \owner_drained5_carry__1_n_2\,
      CO(0) => \owner_drained5_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_owner_drained5_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \owner_drained5_carry__1_i_1_n_0\,
      S(1) => \owner_drained5_carry__1_i_2_n_0\,
      S(0) => \owner_drained5_carry__1_i_3_n_0\
    );
\owner_drained5_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => packet_completed_frames(31),
      I1 => \^out\(31),
      I2 => packet_completed_frames(30),
      I3 => \^out\(30),
      O => \owner_drained5_carry__1_i_1_n_0\
    );
\owner_drained5_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(28),
      I1 => packet_completed_frames(28),
      I2 => \^out\(29),
      I3 => packet_completed_frames(29),
      I4 => packet_completed_frames(27),
      I5 => \^out\(27),
      O => \owner_drained5_carry__1_i_2_n_0\
    );
\owner_drained5_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(24),
      I1 => packet_completed_frames(24),
      I2 => \^out\(25),
      I3 => packet_completed_frames(25),
      I4 => packet_completed_frames(26),
      I5 => \^out\(26),
      O => \owner_drained5_carry__1_i_3_n_0\
    );
owner_drained5_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(10),
      I1 => packet_completed_frames(10),
      I2 => \^out\(11),
      I3 => packet_completed_frames(11),
      I4 => packet_completed_frames(9),
      I5 => \^out\(9),
      O => owner_drained5_carry_i_1_n_0
    );
owner_drained5_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(6),
      I1 => packet_completed_frames(6),
      I2 => \^out\(7),
      I3 => packet_completed_frames(7),
      I4 => packet_completed_frames(8),
      I5 => \^out\(8),
      O => owner_drained5_carry_i_2_n_0
    );
owner_drained5_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(4),
      I1 => packet_completed_frames(4),
      I2 => \^out\(5),
      I3 => packet_completed_frames(5),
      I4 => packet_completed_frames(3),
      I5 => \^out\(3),
      O => owner_drained5_carry_i_3_n_0
    );
owner_drained5_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(0),
      I1 => packet_completed_frames(0),
      I2 => \^out\(1),
      I3 => packet_completed_frames(1),
      I4 => packet_completed_frames(2),
      I5 => \^out\(2),
      O => owner_drained5_carry_i_4_n_0
    );
owner_drained6_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => owner_drained6_carry_n_0,
      CO(2) => owner_drained6_carry_n_1,
      CO(1) => owner_drained6_carry_n_2,
      CO(0) => owner_drained6_carry_n_3,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_owner_drained6_carry_O_UNCONNECTED(3 downto 0),
      S(3) => owner_drained6_carry_i_1_n_0,
      S(2) => owner_drained6_carry_i_2_n_0,
      S(1) => owner_drained6_carry_i_3_n_0,
      S(0) => owner_drained6_carry_i_4_n_0
    );
\owner_drained6_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => owner_drained6_carry_n_0,
      CO(3) => \owner_drained6_carry__0_n_0\,
      CO(2) => \owner_drained6_carry__0_n_1\,
      CO(1) => \owner_drained6_carry__0_n_2\,
      CO(0) => \owner_drained6_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_owner_drained6_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \owner_drained6_carry__0_i_1_n_0\,
      S(2) => \owner_drained6_carry__0_i_2_n_0\,
      S(1) => \owner_drained6_carry__0_i_3_n_0\,
      S(0) => \owner_drained6_carry__0_i_4_n_0\
    );
\owner_drained6_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(22),
      I1 => rgb_completed_frames(22),
      I2 => \^out\(23),
      I3 => rgb_completed_frames(23),
      I4 => rgb_completed_frames(21),
      I5 => \^out\(21),
      O => \owner_drained6_carry__0_i_1_n_0\
    );
\owner_drained6_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(18),
      I1 => rgb_completed_frames(18),
      I2 => \^out\(19),
      I3 => rgb_completed_frames(19),
      I4 => rgb_completed_frames(20),
      I5 => \^out\(20),
      O => \owner_drained6_carry__0_i_2_n_0\
    );
\owner_drained6_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(16),
      I1 => rgb_completed_frames(16),
      I2 => \^out\(17),
      I3 => rgb_completed_frames(17),
      I4 => rgb_completed_frames(15),
      I5 => \^out\(15),
      O => \owner_drained6_carry__0_i_3_n_0\
    );
\owner_drained6_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(12),
      I1 => rgb_completed_frames(12),
      I2 => \^out\(13),
      I3 => rgb_completed_frames(13),
      I4 => rgb_completed_frames(14),
      I5 => \^out\(14),
      O => \owner_drained6_carry__0_i_4_n_0\
    );
\owner_drained6_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \owner_drained6_carry__0_n_0\,
      CO(3) => \NLW_owner_drained6_carry__1_CO_UNCONNECTED\(3),
      CO(2) => owner_drained6,
      CO(1) => \owner_drained6_carry__1_n_2\,
      CO(0) => \owner_drained6_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_owner_drained6_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \owner_drained6_carry__1_i_1_n_0\,
      S(1) => \owner_drained6_carry__1_i_2_n_0\,
      S(0) => \owner_drained6_carry__1_i_3_n_0\
    );
\owner_drained6_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => rgb_completed_frames(31),
      I1 => \^out\(31),
      I2 => rgb_completed_frames(30),
      I3 => \^out\(30),
      O => \owner_drained6_carry__1_i_1_n_0\
    );
\owner_drained6_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(28),
      I1 => rgb_completed_frames(28),
      I2 => \^out\(29),
      I3 => rgb_completed_frames(29),
      I4 => rgb_completed_frames(27),
      I5 => \^out\(27),
      O => \owner_drained6_carry__1_i_2_n_0\
    );
\owner_drained6_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(24),
      I1 => rgb_completed_frames(24),
      I2 => \^out\(25),
      I3 => rgb_completed_frames(25),
      I4 => rgb_completed_frames(26),
      I5 => \^out\(26),
      O => \owner_drained6_carry__1_i_3_n_0\
    );
owner_drained6_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(10),
      I1 => rgb_completed_frames(10),
      I2 => \^out\(11),
      I3 => rgb_completed_frames(11),
      I4 => rgb_completed_frames(9),
      I5 => \^out\(9),
      O => owner_drained6_carry_i_1_n_0
    );
owner_drained6_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(6),
      I1 => rgb_completed_frames(6),
      I2 => \^out\(7),
      I3 => rgb_completed_frames(7),
      I4 => rgb_completed_frames(8),
      I5 => \^out\(8),
      O => owner_drained6_carry_i_2_n_0
    );
owner_drained6_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(4),
      I1 => rgb_completed_frames(4),
      I2 => \^out\(5),
      I3 => rgb_completed_frames(5),
      I4 => rgb_completed_frames(3),
      I5 => \^out\(3),
      O => owner_drained6_carry_i_3_n_0
    );
owner_drained6_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(0),
      I1 => rgb_completed_frames(0),
      I2 => \^out\(1),
      I3 => rgb_completed_frames(1),
      I4 => rgb_completed_frames(2),
      I5 => \^out\(2),
      O => owner_drained6_carry_i_4_n_0
    );
owner_drained7_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => owner_drained7_carry_n_0,
      CO(2) => owner_drained7_carry_n_1,
      CO(1) => owner_drained7_carry_n_2,
      CO(0) => owner_drained7_carry_n_3,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_owner_drained7_carry_O_UNCONNECTED(3 downto 0),
      S(3) => owner_drained7_carry_i_1_n_0,
      S(2) => owner_drained7_carry_i_2_n_0,
      S(1) => owner_drained7_carry_i_3_n_0,
      S(0) => owner_drained7_carry_i_4_n_0
    );
\owner_drained7_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => owner_drained7_carry_n_0,
      CO(3) => \owner_drained7_carry__0_n_0\,
      CO(2) => \owner_drained7_carry__0_n_1\,
      CO(1) => \owner_drained7_carry__0_n_2\,
      CO(0) => \owner_drained7_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_owner_drained7_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \owner_drained7_carry__0_i_1_n_0\,
      S(2) => \owner_drained7_carry__0_i_2_n_0\,
      S(1) => \owner_drained7_carry__0_i_3_n_0\,
      S(0) => \owner_drained7_carry__0_i_4_n_0\
    );
\owner_drained7_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(22),
      I1 => \^out\(22),
      I2 => \^released_frames_reg[31]_0\(23),
      I3 => \^out\(23),
      I4 => \^out\(21),
      I5 => \^released_frames_reg[31]_0\(21),
      O => \owner_drained7_carry__0_i_1_n_0\
    );
\owner_drained7_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(18),
      I1 => \^out\(18),
      I2 => \^released_frames_reg[31]_0\(19),
      I3 => \^out\(19),
      I4 => \^out\(20),
      I5 => \^released_frames_reg[31]_0\(20),
      O => \owner_drained7_carry__0_i_2_n_0\
    );
\owner_drained7_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(16),
      I1 => \^out\(16),
      I2 => \^released_frames_reg[31]_0\(17),
      I3 => \^out\(17),
      I4 => \^out\(15),
      I5 => \^released_frames_reg[31]_0\(15),
      O => \owner_drained7_carry__0_i_3_n_0\
    );
\owner_drained7_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(12),
      I1 => \^out\(12),
      I2 => \^released_frames_reg[31]_0\(13),
      I3 => \^out\(13),
      I4 => \^out\(14),
      I5 => \^released_frames_reg[31]_0\(14),
      O => \owner_drained7_carry__0_i_4_n_0\
    );
\owner_drained7_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \owner_drained7_carry__0_n_0\,
      CO(3) => \NLW_owner_drained7_carry__1_CO_UNCONNECTED\(3),
      CO(2) => owner_drained7,
      CO(1) => \owner_drained7_carry__1_n_2\,
      CO(0) => \owner_drained7_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_owner_drained7_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \owner_drained7_carry__1_i_1_n_0\,
      S(1) => \owner_drained7_carry__1_i_2_n_0\,
      S(0) => \owner_drained7_carry__1_i_3_n_0\
    );
\owner_drained7_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(31),
      I1 => \^out\(31),
      I2 => \^out\(30),
      I3 => \^released_frames_reg[31]_0\(30),
      O => \owner_drained7_carry__1_i_1_n_0\
    );
\owner_drained7_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(28),
      I1 => \^out\(28),
      I2 => \^released_frames_reg[31]_0\(29),
      I3 => \^out\(29),
      I4 => \^out\(27),
      I5 => \^released_frames_reg[31]_0\(27),
      O => \owner_drained7_carry__1_i_2_n_0\
    );
\owner_drained7_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(24),
      I1 => \^out\(24),
      I2 => \^released_frames_reg[31]_0\(25),
      I3 => \^out\(25),
      I4 => \^out\(26),
      I5 => \^released_frames_reg[31]_0\(26),
      O => \owner_drained7_carry__1_i_3_n_0\
    );
owner_drained7_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(10),
      I1 => \^out\(10),
      I2 => \^released_frames_reg[31]_0\(11),
      I3 => \^out\(11),
      I4 => \^out\(9),
      I5 => \^released_frames_reg[31]_0\(9),
      O => owner_drained7_carry_i_1_n_0
    );
owner_drained7_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(6),
      I1 => \^out\(6),
      I2 => \^released_frames_reg[31]_0\(7),
      I3 => \^out\(7),
      I4 => \^out\(8),
      I5 => \^released_frames_reg[31]_0\(8),
      O => owner_drained7_carry_i_2_n_0
    );
owner_drained7_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(4),
      I1 => \^out\(4),
      I2 => \^released_frames_reg[31]_0\(5),
      I3 => \^out\(5),
      I4 => \^out\(3),
      I5 => \^released_frames_reg[31]_0\(3),
      O => owner_drained7_carry_i_3_n_0
    );
owner_drained7_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(0),
      I1 => \^out\(0),
      I2 => \^released_frames_reg[31]_0\(1),
      I3 => \^out\(1),
      I4 => \^out\(2),
      I5 => \^released_frames_reg[31]_0\(2),
      O => owner_drained7_carry_i_4_n_0
    );
owner_drained8_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => owner_drained8_carry_n_0,
      CO(2) => owner_drained8_carry_n_1,
      CO(1) => owner_drained8_carry_n_2,
      CO(0) => owner_drained8_carry_n_3,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_owner_drained8_carry_O_UNCONNECTED(3 downto 0),
      S(3) => owner_drained8_carry_i_1_n_0,
      S(2) => owner_drained8_carry_i_2_n_0,
      S(1) => owner_drained8_carry_i_3_n_0,
      S(0) => owner_drained8_carry_i_4_n_0
    );
\owner_drained8_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => owner_drained8_carry_n_0,
      CO(3) => \owner_drained8_carry__0_n_0\,
      CO(2) => \owner_drained8_carry__0_n_1\,
      CO(1) => \owner_drained8_carry__0_n_2\,
      CO(0) => \owner_drained8_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_owner_drained8_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \owner_drained8_carry__0_i_1_n_0\,
      S(2) => \owner_drained8_carry__0_i_2_n_0\,
      S(1) => \owner_drained8_carry__0_i_3_n_0\,
      S(0) => \owner_drained8_carry__0_i_4_n_0\
    );
\owner_drained8_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(23),
      I1 => \^q\(8),
      I2 => \^out\(21),
      I3 => \^q\(6),
      I4 => \^q\(7),
      I5 => \^out\(22),
      O => \owner_drained8_carry__0_i_1_n_0\
    );
\owner_drained8_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(20),
      I1 => \^q\(5),
      I2 => \^out\(19),
      I3 => \^q\(4),
      I4 => \^q\(3),
      I5 => \^out\(18),
      O => \owner_drained8_carry__0_i_2_n_0\
    );
\owner_drained8_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(17),
      I1 => \final_frame_count_reg_n_0_[17]\,
      I2 => \^out\(16),
      I3 => \final_frame_count_reg_n_0_[16]\,
      I4 => \final_frame_count_reg_n_0_[15]\,
      I5 => \^out\(15),
      O => \owner_drained8_carry__0_i_3_n_0\
    );
\owner_drained8_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(14),
      I1 => \final_frame_count_reg_n_0_[14]\,
      I2 => \^out\(12),
      I3 => \final_frame_count_reg_n_0_[12]\,
      I4 => \final_frame_count_reg_n_0_[13]\,
      I5 => \^out\(13),
      O => \owner_drained8_carry__0_i_4_n_0\
    );
\owner_drained8_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \owner_drained8_carry__0_n_0\,
      CO(3) => \NLW_owner_drained8_carry__1_CO_UNCONNECTED\(3),
      CO(2) => owner_drained8,
      CO(1) => \owner_drained8_carry__1_n_2\,
      CO(0) => \owner_drained8_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_owner_drained8_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \owner_drained8_carry__1_i_1_n_0\,
      S(1) => \owner_drained8_carry__1_i_2_n_0\,
      S(0) => \owner_drained8_carry__1_i_3_n_0\
    );
\owner_drained8_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \final_frame_count_reg_n_0_[30]\,
      I1 => \^out\(30),
      I2 => \final_frame_count_reg_n_0_[31]\,
      I3 => \^out\(31),
      O => \owner_drained8_carry__1_i_1_n_0\
    );
\owner_drained8_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(29),
      I1 => \final_frame_count_reg_n_0_[29]\,
      I2 => \^out\(28),
      I3 => \final_frame_count_reg_n_0_[28]\,
      I4 => \final_frame_count_reg_n_0_[27]\,
      I5 => \^out\(27),
      O => \owner_drained8_carry__1_i_2_n_0\
    );
\owner_drained8_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(26),
      I1 => \^q\(11),
      I2 => \^out\(24),
      I3 => \^q\(9),
      I4 => \^q\(10),
      I5 => \^out\(25),
      O => \owner_drained8_carry__1_i_3_n_0\
    );
owner_drained8_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(11),
      I1 => \final_frame_count_reg_n_0_[11]\,
      I2 => \^out\(10),
      I3 => \final_frame_count_reg_n_0_[10]\,
      I4 => \final_frame_count_reg_n_0_[9]\,
      I5 => \^out\(9),
      O => owner_drained8_carry_i_1_n_0
    );
owner_drained8_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(8),
      I1 => \^q\(2),
      I2 => \^out\(6),
      I3 => \^q\(0),
      I4 => \^q\(1),
      I5 => \^out\(7),
      O => owner_drained8_carry_i_2_n_0
    );
owner_drained8_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^out\(5),
      I1 => \final_frame_count_reg_n_0_[5]\,
      I2 => \^out\(3),
      I3 => \final_frame_count_reg_n_0_[3]\,
      I4 => \final_frame_count_reg_n_0_[4]\,
      I5 => \^out\(4),
      O => owner_drained8_carry_i_3_n_0
    );
owner_drained8_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \final_frame_count_reg_n_0_[0]\,
      I1 => \^out\(0),
      I2 => \^out\(2),
      I3 => \final_frame_count_reg_n_0_[2]\,
      I4 => \^out\(1),
      I5 => \final_frame_count_reg_n_0_[1]\,
      O => owner_drained8_carry_i_4_n_0
    );
owner_drained_INST_0: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => cpu_available_INST_0_i_1_n_0,
      I1 => cpu_release,
      I2 => owner_drained_INST_0_i_1_n_0,
      I3 => owner_drained_INST_0_i_2_n_0,
      O => owner_drained
    );
owner_drained_INST_0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF7FFFFFFFFFFF"
    )
        port map (
      I0 => control_capture_aresetn,
      I1 => \epoch_reg[31]_0\,
      I2 => common_aresetn,
      I3 => owner_drained8,
      I4 => \^cpu_held_reg_0\,
      I5 => owner_drained6,
      O => owner_drained_INST_0_i_1_n_0
    );
owner_drained_INST_0_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFDFFFFFFFFFFF"
    )
        port map (
      I0 => \^closure_held_reg_0\,
      I1 => frame_credit_request,
      I2 => owner_drained7,
      I3 => owner_drained4,
      I4 => cpu_claim,
      I5 => owner_drained5,
      O => owner_drained_INST_0_i_2_n_0
    );
owner_fault_INST_0: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFF70"
    )
        port map (
      I0 => owner_fault_INST_0_i_1_n_0,
      I1 => owner_fault_INST_0_i_2_n_0,
      I2 => \^configuration_locked\,
      I3 => owner_fault_INST_0_i_3_n_0,
      I4 => owner_fault_INST_0_i_4_n_0,
      I5 => upstream_fault0,
      O => \^configuration_locked_reg_0\
    );
owner_fault_INST_0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0333333373333333"
    )
        port map (
      I0 => closure_bad2,
      I1 => \^closure_held_reg_0\,
      I2 => budget_checked,
      I3 => closure_held,
      I4 => dest_arst,
      I5 => closure_bad1,
      O => owner_fault_INST_0_i_1_n_0
    );
owner_fault_INST_0_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => counters_bad1,
      I1 => counters_bad2,
      I2 => counters_bad3,
      I3 => counters_bad4,
      I4 => counters_bad54_in,
      I5 => counters_bad5,
      O => owner_fault_INST_0_i_2_n_0
    );
owner_fault_INST_0_i_3: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A8AAAAAA"
    )
        port map (
      I0 => \^configuration_locked\,
      I1 => \configuration_bad2_carry__1_n_1\,
      I2 => configuration_bad1,
      I3 => control_capture_aresetn,
      I4 => \epoch_reg[31]_0\,
      O => owner_fault_INST_0_i_3_n_0
    );
owner_fault_INST_0_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^owner_fault_causes\(1),
      I1 => \^owner_fault_causes\(2),
      I2 => \^owner_fault_causes\(0),
      I3 => \^owner_fault_causes\(3),
      O => owner_fault_INST_0_i_4_n_0
    );
\previous_packet_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(0),
      Q => previous_packet(0),
      R => \^clear\
    );
\previous_packet_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(10),
      Q => previous_packet(10),
      R => \^clear\
    );
\previous_packet_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(11),
      Q => previous_packet(11),
      R => \^clear\
    );
\previous_packet_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(12),
      Q => previous_packet(12),
      R => \^clear\
    );
\previous_packet_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(13),
      Q => previous_packet(13),
      R => \^clear\
    );
\previous_packet_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(14),
      Q => previous_packet(14),
      R => \^clear\
    );
\previous_packet_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(15),
      Q => previous_packet(15),
      R => \^clear\
    );
\previous_packet_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(16),
      Q => previous_packet(16),
      R => \^clear\
    );
\previous_packet_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(17),
      Q => previous_packet(17),
      R => \^clear\
    );
\previous_packet_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(18),
      Q => previous_packet(18),
      R => \^clear\
    );
\previous_packet_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(19),
      Q => previous_packet(19),
      R => \^clear\
    );
\previous_packet_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(1),
      Q => previous_packet(1),
      R => \^clear\
    );
\previous_packet_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(20),
      Q => previous_packet(20),
      R => \^clear\
    );
\previous_packet_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(21),
      Q => previous_packet(21),
      R => \^clear\
    );
\previous_packet_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(22),
      Q => previous_packet(22),
      R => \^clear\
    );
\previous_packet_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(23),
      Q => previous_packet(23),
      R => \^clear\
    );
\previous_packet_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(24),
      Q => previous_packet(24),
      R => \^clear\
    );
\previous_packet_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(25),
      Q => previous_packet(25),
      R => \^clear\
    );
\previous_packet_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(26),
      Q => previous_packet(26),
      R => \^clear\
    );
\previous_packet_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(27),
      Q => previous_packet(27),
      R => \^clear\
    );
\previous_packet_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(28),
      Q => previous_packet(28),
      R => \^clear\
    );
\previous_packet_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(29),
      Q => previous_packet(29),
      R => \^clear\
    );
\previous_packet_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(2),
      Q => previous_packet(2),
      R => \^clear\
    );
\previous_packet_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(30),
      Q => previous_packet(30),
      R => \^clear\
    );
\previous_packet_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(31),
      Q => previous_packet(31),
      R => \^clear\
    );
\previous_packet_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(3),
      Q => previous_packet(3),
      R => \^clear\
    );
\previous_packet_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(4),
      Q => previous_packet(4),
      R => \^clear\
    );
\previous_packet_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(5),
      Q => previous_packet(5),
      R => \^clear\
    );
\previous_packet_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(6),
      Q => previous_packet(6),
      R => \^clear\
    );
\previous_packet_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(7),
      Q => previous_packet(7),
      R => \^clear\
    );
\previous_packet_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(8),
      Q => previous_packet(8),
      R => \^clear\
    );
\previous_packet_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => packet_completed_frames(9),
      Q => previous_packet(9),
      R => \^clear\
    );
\previous_rgb_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(0),
      Q => previous_rgb(0),
      R => \^clear\
    );
\previous_rgb_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(10),
      Q => previous_rgb(10),
      R => \^clear\
    );
\previous_rgb_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(11),
      Q => previous_rgb(11),
      R => \^clear\
    );
\previous_rgb_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(12),
      Q => previous_rgb(12),
      R => \^clear\
    );
\previous_rgb_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(13),
      Q => previous_rgb(13),
      R => \^clear\
    );
\previous_rgb_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(14),
      Q => previous_rgb(14),
      R => \^clear\
    );
\previous_rgb_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(15),
      Q => previous_rgb(15),
      R => \^clear\
    );
\previous_rgb_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(16),
      Q => previous_rgb(16),
      R => \^clear\
    );
\previous_rgb_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(17),
      Q => previous_rgb(17),
      R => \^clear\
    );
\previous_rgb_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(18),
      Q => previous_rgb(18),
      R => \^clear\
    );
\previous_rgb_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(19),
      Q => previous_rgb(19),
      R => \^clear\
    );
\previous_rgb_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(1),
      Q => previous_rgb(1),
      R => \^clear\
    );
\previous_rgb_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(20),
      Q => previous_rgb(20),
      R => \^clear\
    );
\previous_rgb_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(21),
      Q => previous_rgb(21),
      R => \^clear\
    );
\previous_rgb_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(22),
      Q => previous_rgb(22),
      R => \^clear\
    );
\previous_rgb_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(23),
      Q => previous_rgb(23),
      R => \^clear\
    );
\previous_rgb_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(24),
      Q => previous_rgb(24),
      R => \^clear\
    );
\previous_rgb_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(25),
      Q => previous_rgb(25),
      R => \^clear\
    );
\previous_rgb_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(26),
      Q => previous_rgb(26),
      R => \^clear\
    );
\previous_rgb_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(27),
      Q => previous_rgb(27),
      R => \^clear\
    );
\previous_rgb_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(28),
      Q => previous_rgb(28),
      R => \^clear\
    );
\previous_rgb_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(29),
      Q => previous_rgb(29),
      R => \^clear\
    );
\previous_rgb_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(2),
      Q => previous_rgb(2),
      R => \^clear\
    );
\previous_rgb_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(30),
      Q => previous_rgb(30),
      R => \^clear\
    );
\previous_rgb_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(31),
      Q => previous_rgb(31),
      R => \^clear\
    );
\previous_rgb_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(3),
      Q => previous_rgb(3),
      R => \^clear\
    );
\previous_rgb_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(4),
      Q => previous_rgb(4),
      R => \^clear\
    );
\previous_rgb_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(5),
      Q => previous_rgb(5),
      R => \^clear\
    );
\previous_rgb_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(6),
      Q => previous_rgb(6),
      R => \^clear\
    );
\previous_rgb_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(7),
      Q => previous_rgb(7),
      R => \^clear\
    );
\previous_rgb_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(8),
      Q => previous_rgb(8),
      R => \^clear\
    );
\previous_rgb_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => rgb_completed_frames(9),
      Q => previous_rgb(9),
      R => \^clear\
    );
\previous_status_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(0),
      Q => previous_status(0),
      R => \^clear\
    );
\previous_status_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(10),
      Q => previous_status(10),
      R => \^clear\
    );
\previous_status_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(11),
      Q => previous_status(11),
      R => \^clear\
    );
\previous_status_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(12),
      Q => previous_status(12),
      R => \^clear\
    );
\previous_status_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(13),
      Q => previous_status(13),
      R => \^clear\
    );
\previous_status_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(14),
      Q => previous_status(14),
      R => \^clear\
    );
\previous_status_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(15),
      Q => previous_status(15),
      R => \^clear\
    );
\previous_status_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(16),
      Q => previous_status(16),
      R => \^clear\
    );
\previous_status_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(17),
      Q => previous_status(17),
      R => \^clear\
    );
\previous_status_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(18),
      Q => previous_status(18),
      R => \^clear\
    );
\previous_status_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(19),
      Q => previous_status(19),
      R => \^clear\
    );
\previous_status_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(1),
      Q => previous_status(1),
      R => \^clear\
    );
\previous_status_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(20),
      Q => previous_status(20),
      R => \^clear\
    );
\previous_status_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(21),
      Q => previous_status(21),
      R => \^clear\
    );
\previous_status_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(22),
      Q => previous_status(22),
      R => \^clear\
    );
\previous_status_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(23),
      Q => previous_status(23),
      R => \^clear\
    );
\previous_status_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(24),
      Q => previous_status(24),
      R => \^clear\
    );
\previous_status_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(25),
      Q => previous_status(25),
      R => \^clear\
    );
\previous_status_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(26),
      Q => previous_status(26),
      R => \^clear\
    );
\previous_status_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(27),
      Q => previous_status(27),
      R => \^clear\
    );
\previous_status_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(28),
      Q => previous_status(28),
      R => \^clear\
    );
\previous_status_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(29),
      Q => previous_status(29),
      R => \^clear\
    );
\previous_status_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(2),
      Q => previous_status(2),
      R => \^clear\
    );
\previous_status_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(30),
      Q => previous_status(30),
      R => \^clear\
    );
\previous_status_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(31),
      Q => previous_status(31),
      R => \^clear\
    );
\previous_status_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(3),
      Q => previous_status(3),
      R => \^clear\
    );
\previous_status_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(4),
      Q => previous_status(4),
      R => \^clear\
    );
\previous_status_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(5),
      Q => previous_status(5),
      R => \^clear\
    );
\previous_status_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(6),
      Q => previous_status(6),
      R => \^clear\
    );
\previous_status_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(7),
      Q => previous_status(7),
      R => \^clear\
    );
\previous_status_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(8),
      Q => previous_status(8),
      R => \^clear\
    );
\previous_status_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => \^configuration_locked\,
      D => status_completed_frames(9),
      Q => previous_status(9),
      R => \^clear\
    );
\producer_slot[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^grant_slot\(1),
      I1 => \^grant_slot\(0),
      O => \producer_slot[0]_i_1_n_0\
    );
\producer_slot[1]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => common_aresetn,
      O => \^clear\
    );
\producer_slot[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0008000000080008"
    )
        port map (
      I0 => frame_credit_request,
      I1 => frame_credit_ready_INST_0_i_1_n_0,
      I2 => \producer_slot[1]_i_4_n_0\,
      I3 => frame_credit_ready_INST_0_i_4_n_0,
      I4 => frame_credit_ready_INST_0_i_5_n_0,
      I5 => frame_credit_ready_INST_0_i_6_n_0,
      O => producer_slot
    );
\producer_slot[1]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"4"
    )
        port map (
      I0 => \^grant_slot\(1),
      I1 => \^grant_slot\(0),
      O => \producer_slot[1]_i_3_n_0\
    );
\producer_slot[1]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEFEFEFF"
    )
        port map (
      I0 => frame_credit_ready_INST_0_i_8_n_0,
      I1 => \producer_slot[1]_i_5_n_0\,
      I2 => \^granted_frames_reg[3]_0\,
      I3 => \^co\(0),
      I4 => \granted_frames_reg[31]_0\,
      O => \producer_slot[1]_i_4_n_0\
    );
\producer_slot[1]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => grant_ready40_out(30),
      I1 => grant_ready40_out(3),
      I2 => grant_ready40_out(23),
      I3 => grant_ready40_out(7),
      I4 => frame_credit_ready_INST_0_i_7_n_0,
      O => \producer_slot[1]_i_5_n_0\
    );
\producer_slot_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \producer_slot[0]_i_1_n_0\,
      Q => \^grant_slot\(0),
      R => \^clear\
    );
\producer_slot_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => producer_slot,
      D => \producer_slot[1]_i_3_n_0\,
      Q => \^grant_slot\(1),
      R => \^clear\
    );
release_accepted_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"1000000000000000"
    )
        port map (
      I0 => cpu_available_INST_0_i_1_n_0,
      I1 => cpu_claim,
      I2 => \^cpu_held_reg_0\,
      I3 => token_matches0,
      I4 => token_matches00_out,
      I5 => cpu_release,
      O => consumer_slot(0)
    );
release_accepted_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => consumer_slot(0),
      Q => release_accepted,
      R => \^clear\
    );
\released_frames[3]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(0),
      O => \released_frames[3]_i_2_n_0\
    );
\released_frames_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[3]_i_1_n_7\,
      Q => \^released_frames_reg[31]_0\(0),
      R => \^clear\
    );
\released_frames_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[11]_i_1_n_5\,
      Q => \^released_frames_reg[31]_0\(10),
      R => \^clear\
    );
\released_frames_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[11]_i_1_n_4\,
      Q => \^released_frames_reg[31]_0\(11),
      R => \^clear\
    );
\released_frames_reg[11]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \released_frames_reg[7]_i_1_n_0\,
      CO(3) => \released_frames_reg[11]_i_1_n_0\,
      CO(2) => \released_frames_reg[11]_i_1_n_1\,
      CO(1) => \released_frames_reg[11]_i_1_n_2\,
      CO(0) => \released_frames_reg[11]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \released_frames_reg[11]_i_1_n_4\,
      O(2) => \released_frames_reg[11]_i_1_n_5\,
      O(1) => \released_frames_reg[11]_i_1_n_6\,
      O(0) => \released_frames_reg[11]_i_1_n_7\,
      S(3 downto 0) => \^released_frames_reg[31]_0\(11 downto 8)
    );
\released_frames_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[15]_i_1_n_7\,
      Q => \^released_frames_reg[31]_0\(12),
      R => \^clear\
    );
\released_frames_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[15]_i_1_n_6\,
      Q => \^released_frames_reg[31]_0\(13),
      R => \^clear\
    );
\released_frames_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[15]_i_1_n_5\,
      Q => \^released_frames_reg[31]_0\(14),
      R => \^clear\
    );
\released_frames_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[15]_i_1_n_4\,
      Q => \^released_frames_reg[31]_0\(15),
      R => \^clear\
    );
\released_frames_reg[15]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \released_frames_reg[11]_i_1_n_0\,
      CO(3) => \released_frames_reg[15]_i_1_n_0\,
      CO(2) => \released_frames_reg[15]_i_1_n_1\,
      CO(1) => \released_frames_reg[15]_i_1_n_2\,
      CO(0) => \released_frames_reg[15]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \released_frames_reg[15]_i_1_n_4\,
      O(2) => \released_frames_reg[15]_i_1_n_5\,
      O(1) => \released_frames_reg[15]_i_1_n_6\,
      O(0) => \released_frames_reg[15]_i_1_n_7\,
      S(3 downto 0) => \^released_frames_reg[31]_0\(15 downto 12)
    );
\released_frames_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[19]_i_1_n_7\,
      Q => \^released_frames_reg[31]_0\(16),
      R => \^clear\
    );
\released_frames_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[19]_i_1_n_6\,
      Q => \^released_frames_reg[31]_0\(17),
      R => \^clear\
    );
\released_frames_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[19]_i_1_n_5\,
      Q => \^released_frames_reg[31]_0\(18),
      R => \^clear\
    );
\released_frames_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[19]_i_1_n_4\,
      Q => \^released_frames_reg[31]_0\(19),
      R => \^clear\
    );
\released_frames_reg[19]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \released_frames_reg[15]_i_1_n_0\,
      CO(3) => \released_frames_reg[19]_i_1_n_0\,
      CO(2) => \released_frames_reg[19]_i_1_n_1\,
      CO(1) => \released_frames_reg[19]_i_1_n_2\,
      CO(0) => \released_frames_reg[19]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \released_frames_reg[19]_i_1_n_4\,
      O(2) => \released_frames_reg[19]_i_1_n_5\,
      O(1) => \released_frames_reg[19]_i_1_n_6\,
      O(0) => \released_frames_reg[19]_i_1_n_7\,
      S(3 downto 0) => \^released_frames_reg[31]_0\(19 downto 16)
    );
\released_frames_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[3]_i_1_n_6\,
      Q => \^released_frames_reg[31]_0\(1),
      R => \^clear\
    );
\released_frames_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[23]_i_1_n_7\,
      Q => \^released_frames_reg[31]_0\(20),
      R => \^clear\
    );
\released_frames_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[23]_i_1_n_6\,
      Q => \^released_frames_reg[31]_0\(21),
      R => \^clear\
    );
\released_frames_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[23]_i_1_n_5\,
      Q => \^released_frames_reg[31]_0\(22),
      R => \^clear\
    );
\released_frames_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[23]_i_1_n_4\,
      Q => \^released_frames_reg[31]_0\(23),
      R => \^clear\
    );
\released_frames_reg[23]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \released_frames_reg[19]_i_1_n_0\,
      CO(3) => \released_frames_reg[23]_i_1_n_0\,
      CO(2) => \released_frames_reg[23]_i_1_n_1\,
      CO(1) => \released_frames_reg[23]_i_1_n_2\,
      CO(0) => \released_frames_reg[23]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \released_frames_reg[23]_i_1_n_4\,
      O(2) => \released_frames_reg[23]_i_1_n_5\,
      O(1) => \released_frames_reg[23]_i_1_n_6\,
      O(0) => \released_frames_reg[23]_i_1_n_7\,
      S(3 downto 0) => \^released_frames_reg[31]_0\(23 downto 20)
    );
\released_frames_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[27]_i_1_n_7\,
      Q => \^released_frames_reg[31]_0\(24),
      R => \^clear\
    );
\released_frames_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[27]_i_1_n_6\,
      Q => \^released_frames_reg[31]_0\(25),
      R => \^clear\
    );
\released_frames_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[27]_i_1_n_5\,
      Q => \^released_frames_reg[31]_0\(26),
      R => \^clear\
    );
\released_frames_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[27]_i_1_n_4\,
      Q => \^released_frames_reg[31]_0\(27),
      R => \^clear\
    );
\released_frames_reg[27]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \released_frames_reg[23]_i_1_n_0\,
      CO(3) => \released_frames_reg[27]_i_1_n_0\,
      CO(2) => \released_frames_reg[27]_i_1_n_1\,
      CO(1) => \released_frames_reg[27]_i_1_n_2\,
      CO(0) => \released_frames_reg[27]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \released_frames_reg[27]_i_1_n_4\,
      O(2) => \released_frames_reg[27]_i_1_n_5\,
      O(1) => \released_frames_reg[27]_i_1_n_6\,
      O(0) => \released_frames_reg[27]_i_1_n_7\,
      S(3 downto 0) => \^released_frames_reg[31]_0\(27 downto 24)
    );
\released_frames_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[31]_i_1_n_7\,
      Q => \^released_frames_reg[31]_0\(28),
      R => \^clear\
    );
\released_frames_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[31]_i_1_n_6\,
      Q => \^released_frames_reg[31]_0\(29),
      R => \^clear\
    );
\released_frames_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[3]_i_1_n_5\,
      Q => \^released_frames_reg[31]_0\(2),
      R => \^clear\
    );
\released_frames_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[31]_i_1_n_5\,
      Q => \^released_frames_reg[31]_0\(30),
      R => \^clear\
    );
\released_frames_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[31]_i_1_n_4\,
      Q => \^released_frames_reg[31]_0\(31),
      R => \^clear\
    );
\released_frames_reg[31]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \released_frames_reg[27]_i_1_n_0\,
      CO(3) => \NLW_released_frames_reg[31]_i_1_CO_UNCONNECTED\(3),
      CO(2) => \released_frames_reg[31]_i_1_n_1\,
      CO(1) => \released_frames_reg[31]_i_1_n_2\,
      CO(0) => \released_frames_reg[31]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \released_frames_reg[31]_i_1_n_4\,
      O(2) => \released_frames_reg[31]_i_1_n_5\,
      O(1) => \released_frames_reg[31]_i_1_n_6\,
      O(0) => \released_frames_reg[31]_i_1_n_7\,
      S(3 downto 0) => \^released_frames_reg[31]_0\(31 downto 28)
    );
\released_frames_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[3]_i_1_n_4\,
      Q => \^released_frames_reg[31]_0\(3),
      R => \^clear\
    );
\released_frames_reg[3]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \released_frames_reg[3]_i_1_n_0\,
      CO(2) => \released_frames_reg[3]_i_1_n_1\,
      CO(1) => \released_frames_reg[3]_i_1_n_2\,
      CO(0) => \released_frames_reg[3]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \released_frames_reg[3]_i_1_n_4\,
      O(2) => \released_frames_reg[3]_i_1_n_5\,
      O(1) => \released_frames_reg[3]_i_1_n_6\,
      O(0) => \released_frames_reg[3]_i_1_n_7\,
      S(3 downto 1) => \^released_frames_reg[31]_0\(3 downto 1),
      S(0) => \released_frames[3]_i_2_n_0\
    );
\released_frames_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[7]_i_1_n_7\,
      Q => \^released_frames_reg[31]_0\(4),
      R => \^clear\
    );
\released_frames_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[7]_i_1_n_6\,
      Q => \^released_frames_reg[31]_0\(5),
      R => \^clear\
    );
\released_frames_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[7]_i_1_n_5\,
      Q => \^released_frames_reg[31]_0\(6),
      R => \^clear\
    );
\released_frames_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[7]_i_1_n_4\,
      Q => \^released_frames_reg[31]_0\(7),
      R => \^clear\
    );
\released_frames_reg[7]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \released_frames_reg[3]_i_1_n_0\,
      CO(3) => \released_frames_reg[7]_i_1_n_0\,
      CO(2) => \released_frames_reg[7]_i_1_n_1\,
      CO(1) => \released_frames_reg[7]_i_1_n_2\,
      CO(0) => \released_frames_reg[7]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \released_frames_reg[7]_i_1_n_4\,
      O(2) => \released_frames_reg[7]_i_1_n_5\,
      O(1) => \released_frames_reg[7]_i_1_n_6\,
      O(0) => \released_frames_reg[7]_i_1_n_7\,
      S(3 downto 0) => \^released_frames_reg[31]_0\(7 downto 4)
    );
\released_frames_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[11]_i_1_n_7\,
      Q => \^released_frames_reg[31]_0\(8),
      R => \^clear\
    );
\released_frames_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => consumer_slot(0),
      D => \released_frames_reg[11]_i_1_n_6\,
      Q => \^released_frames_reg[31]_0\(9),
      R => \^clear\
    );
request_close_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => control_barrier_request,
      I1 => control_abort_requested,
      I2 => \^configuration_locked_reg_0\,
      O => request_close0
    );
request_open_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0100000000000000"
    )
        port map (
      I0 => control_barrier_request,
      I1 => control_abort_requested,
      I2 => \^configuration_locked_reg_0\,
      I3 => control_capture_aresetn,
      I4 => \epoch_reg[31]_0\,
      I5 => control_armed,
      O => request_open0
    );
\source_gray[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(0),
      I1 => \^released_frames_reg[31]_0\(1),
      O => \released_frames_reg[1]_0\(0)
    );
\source_gray[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \^released_frames_reg[31]_0\(1),
      I1 => \^released_frames_reg[31]_0\(2),
      O => \released_frames_reg[1]_0\(1)
    );
token_matches0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => token_matches0_carry_n_0,
      CO(2) => token_matches0_carry_n_1,
      CO(1) => token_matches0_carry_n_2,
      CO(0) => token_matches0_carry_n_3,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_token_matches0_carry_O_UNCONNECTED(3 downto 0),
      S(3) => token_matches0_carry_i_1_n_0,
      S(2) => token_matches0_carry_i_2_n_0,
      S(1) => token_matches0_carry_i_3_n_0,
      S(0) => token_matches0_carry_i_4_n_0
    );
\token_matches0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => token_matches0_carry_n_0,
      CO(3) => \token_matches0_carry__0_n_0\,
      CO(2) => \token_matches0_carry__0_n_1\,
      CO(1) => \token_matches0_carry__0_n_2\,
      CO(0) => \token_matches0_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_token_matches0_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \token_matches0_carry__0_i_1_n_0\,
      S(2) => \token_matches0_carry__0_i_2_n_0\,
      S(1) => \token_matches0_carry__0_i_3_n_0\,
      S(0) => \token_matches0_carry__0_i_4_n_0\
    );
\token_matches0_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_epoch(23),
      I1 => \^available_epoch\(23),
      I2 => cpu_epoch(21),
      I3 => \^available_epoch\(21),
      I4 => \^available_epoch\(22),
      I5 => cpu_epoch(22),
      O => \token_matches0_carry__0_i_1_n_0\
    );
\token_matches0_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_epoch(20),
      I1 => \^available_epoch\(20),
      I2 => cpu_epoch(19),
      I3 => \^available_epoch\(19),
      I4 => \^available_epoch\(18),
      I5 => cpu_epoch(18),
      O => \token_matches0_carry__0_i_2_n_0\
    );
\token_matches0_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_epoch(17),
      I1 => \^available_epoch\(17),
      I2 => cpu_epoch(16),
      I3 => \^available_epoch\(16),
      I4 => \^available_epoch\(15),
      I5 => cpu_epoch(15),
      O => \token_matches0_carry__0_i_3_n_0\
    );
\token_matches0_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_epoch(14),
      I1 => \^available_epoch\(14),
      I2 => cpu_epoch(13),
      I3 => \^available_epoch\(13),
      I4 => \^available_epoch\(12),
      I5 => cpu_epoch(12),
      O => \token_matches0_carry__0_i_4_n_0\
    );
\token_matches0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \token_matches0_carry__0_n_0\,
      CO(3) => \NLW_token_matches0_carry__1_CO_UNCONNECTED\(3),
      CO(2) => token_matches00_out,
      CO(1) => \token_matches0_carry__1_n_2\,
      CO(0) => \token_matches0_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_token_matches0_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \token_matches0_carry__1_i_1_n_0\,
      S(1) => \token_matches0_carry__1_i_2_n_0\,
      S(0) => \token_matches0_carry__1_i_3_n_0\
    );
\token_matches0_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^available_epoch\(30),
      I1 => cpu_epoch(30),
      I2 => \^available_epoch\(31),
      I3 => cpu_epoch(31),
      O => \token_matches0_carry__1_i_1_n_0\
    );
\token_matches0_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_epoch(29),
      I1 => \^available_epoch\(29),
      I2 => cpu_epoch(28),
      I3 => \^available_epoch\(28),
      I4 => \^available_epoch\(27),
      I5 => cpu_epoch(27),
      O => \token_matches0_carry__1_i_2_n_0\
    );
\token_matches0_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_epoch(26),
      I1 => \^available_epoch\(26),
      I2 => cpu_epoch(25),
      I3 => \^available_epoch\(25),
      I4 => \^available_epoch\(24),
      I5 => cpu_epoch(24),
      O => \token_matches0_carry__1_i_3_n_0\
    );
token_matches0_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_epoch(11),
      I1 => \^available_epoch\(11),
      I2 => cpu_epoch(10),
      I3 => \^available_epoch\(10),
      I4 => \^available_epoch\(9),
      I5 => cpu_epoch(9),
      O => token_matches0_carry_i_1_n_0
    );
token_matches0_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_epoch(8),
      I1 => \^available_epoch\(8),
      I2 => cpu_epoch(6),
      I3 => \^available_epoch\(6),
      I4 => \^available_epoch\(7),
      I5 => cpu_epoch(7),
      O => token_matches0_carry_i_2_n_0
    );
token_matches0_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_epoch(5),
      I1 => \^available_epoch\(5),
      I2 => cpu_epoch(4),
      I3 => \^available_epoch\(4),
      I4 => \^available_epoch\(3),
      I5 => cpu_epoch(3),
      O => token_matches0_carry_i_3_n_0
    );
token_matches0_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => cpu_epoch(2),
      I1 => \^available_epoch\(2),
      I2 => cpu_epoch(1),
      I3 => \^available_epoch\(1),
      I4 => \^available_epoch\(0),
      I5 => cpu_epoch(0),
      O => token_matches0_carry_i_4_n_0
    );
\token_matches0_inferred__0/i__carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \token_matches0_inferred__0/i__carry_n_0\,
      CO(2) => \token_matches0_inferred__0/i__carry_n_1\,
      CO(1) => \token_matches0_inferred__0/i__carry_n_2\,
      CO(0) => \token_matches0_inferred__0/i__carry_n_3\,
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_token_matches0_inferred__0/i__carry_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry_i_1__0_n_0\,
      S(2) => \i__carry_i_2__0_n_0\,
      S(1) => \i__carry_i_3__0_n_0\,
      S(0) => \i__carry_i_4__0_n_0\
    );
\token_matches0_inferred__0/i__carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \token_matches0_inferred__0/i__carry_n_0\,
      CO(3) => \token_matches0_inferred__0/i__carry__0_n_0\,
      CO(2) => \token_matches0_inferred__0/i__carry__0_n_1\,
      CO(1) => \token_matches0_inferred__0/i__carry__0_n_2\,
      CO(0) => \token_matches0_inferred__0/i__carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_token_matches0_inferred__0/i__carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \i__carry__0_i_1__0_n_0\,
      S(2) => \i__carry__0_i_2__0_n_0\,
      S(1) => \i__carry__0_i_3__0_n_0\,
      S(0) => \i__carry__0_i_4__0_n_0\
    );
\token_matches0_inferred__0/i__carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \token_matches0_inferred__0/i__carry__0_n_0\,
      CO(3) => \NLW_token_matches0_inferred__0/i__carry__1_CO_UNCONNECTED\(3),
      CO(2) => token_matches0,
      CO(1) => \token_matches0_inferred__0/i__carry__1_n_2\,
      CO(0) => \token_matches0_inferred__0/i__carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_token_matches0_inferred__0/i__carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => '0',
      S(2) => \i__carry__1_i_1__0_n_0\,
      S(1) => \i__carry__1_i_2__0_n_0\,
      S(0) => \i__carry__1_i_3__0_n_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_capture_lifecycle_0_xpm_cdc_async_rst is
  port (
    src_arst : in STD_LOGIC;
    dest_clk : in STD_LOGIC;
    dest_arst : out STD_LOGIC
  );
  attribute DEF_VAL : string;
  attribute DEF_VAL of c6v_capture_lifecycle_0_xpm_cdc_async_rst : entity is "1'b1";
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of c6v_capture_lifecycle_0_xpm_cdc_async_rst : entity is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of c6v_capture_lifecycle_0_xpm_cdc_async_rst : entity is 0;
  attribute INV_DEF_VAL : string;
  attribute INV_DEF_VAL of c6v_capture_lifecycle_0_xpm_cdc_async_rst : entity is "1'b0";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_capture_lifecycle_0_xpm_cdc_async_rst : entity is "xpm_cdc_async_rst";
  attribute RST_ACTIVE_HIGH : integer;
  attribute RST_ACTIVE_HIGH of c6v_capture_lifecycle_0_xpm_cdc_async_rst : entity is 0;
  attribute VERSION : integer;
  attribute VERSION of c6v_capture_lifecycle_0_xpm_cdc_async_rst : entity is 0;
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of c6v_capture_lifecycle_0_xpm_cdc_async_rst : entity is "TRUE";
  attribute keep_hierarchy : string;
  attribute keep_hierarchy of c6v_capture_lifecycle_0_xpm_cdc_async_rst : entity is "soft";
  attribute xpm_cdc : string;
  attribute xpm_cdc of c6v_capture_lifecycle_0_xpm_cdc_async_rst : entity is "ASYNC_RST";
end c6v_capture_lifecycle_0_xpm_cdc_async_rst;

architecture STRUCTURE of c6v_capture_lifecycle_0_xpm_cdc_async_rst is
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
entity \c6v_capture_lifecycle_0_xpm_cdc_async_rst__1\ is
  port (
    src_arst : in STD_LOGIC;
    dest_clk : in STD_LOGIC;
    dest_arst : out STD_LOGIC
  );
  attribute DEF_VAL : string;
  attribute DEF_VAL of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__1\ : entity is "1'b1";
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__1\ : entity is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__1\ : entity is 0;
  attribute INV_DEF_VAL : string;
  attribute INV_DEF_VAL of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__1\ : entity is "1'b0";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__1\ : entity is "xpm_cdc_async_rst";
  attribute RST_ACTIVE_HIGH : integer;
  attribute RST_ACTIVE_HIGH of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__1\ : entity is 0;
  attribute VERSION : integer;
  attribute VERSION of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__1\ : entity is 0;
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__1\ : entity is "TRUE";
  attribute keep_hierarchy : string;
  attribute keep_hierarchy of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__1\ : entity is "soft";
  attribute xpm_cdc : string;
  attribute xpm_cdc of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__1\ : entity is "ASYNC_RST";
end \c6v_capture_lifecycle_0_xpm_cdc_async_rst__1\;

architecture STRUCTURE of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__1\ is
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
entity \c6v_capture_lifecycle_0_xpm_cdc_async_rst__2\ is
  port (
    src_arst : in STD_LOGIC;
    dest_clk : in STD_LOGIC;
    dest_arst : out STD_LOGIC
  );
  attribute DEF_VAL : string;
  attribute DEF_VAL of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__2\ : entity is "1'b1";
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__2\ : entity is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__2\ : entity is 0;
  attribute INV_DEF_VAL : string;
  attribute INV_DEF_VAL of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__2\ : entity is "1'b0";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__2\ : entity is "xpm_cdc_async_rst";
  attribute RST_ACTIVE_HIGH : integer;
  attribute RST_ACTIVE_HIGH of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__2\ : entity is 0;
  attribute VERSION : integer;
  attribute VERSION of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__2\ : entity is 0;
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__2\ : entity is "TRUE";
  attribute keep_hierarchy : string;
  attribute keep_hierarchy of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__2\ : entity is "soft";
  attribute xpm_cdc : string;
  attribute xpm_cdc of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__2\ : entity is "ASYNC_RST";
end \c6v_capture_lifecycle_0_xpm_cdc_async_rst__2\;

architecture STRUCTURE of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__2\ is
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
entity \c6v_capture_lifecycle_0_xpm_cdc_async_rst__3\ is
  port (
    src_arst : in STD_LOGIC;
    dest_clk : in STD_LOGIC;
    dest_arst : out STD_LOGIC
  );
  attribute DEF_VAL : string;
  attribute DEF_VAL of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__3\ : entity is "1'b1";
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__3\ : entity is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__3\ : entity is 0;
  attribute INV_DEF_VAL : string;
  attribute INV_DEF_VAL of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__3\ : entity is "1'b0";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__3\ : entity is "xpm_cdc_async_rst";
  attribute RST_ACTIVE_HIGH : integer;
  attribute RST_ACTIVE_HIGH of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__3\ : entity is 0;
  attribute VERSION : integer;
  attribute VERSION of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__3\ : entity is 0;
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__3\ : entity is "TRUE";
  attribute keep_hierarchy : string;
  attribute keep_hierarchy of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__3\ : entity is "soft";
  attribute xpm_cdc : string;
  attribute xpm_cdc of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__3\ : entity is "ASYNC_RST";
end \c6v_capture_lifecycle_0_xpm_cdc_async_rst__3\;

architecture STRUCTURE of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__3\ is
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
entity \c6v_capture_lifecycle_0_xpm_cdc_async_rst__4\ is
  port (
    src_arst : in STD_LOGIC;
    dest_clk : in STD_LOGIC;
    dest_arst : out STD_LOGIC
  );
  attribute DEF_VAL : string;
  attribute DEF_VAL of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__4\ : entity is "1'b1";
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__4\ : entity is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__4\ : entity is 0;
  attribute INV_DEF_VAL : string;
  attribute INV_DEF_VAL of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__4\ : entity is "1'b0";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__4\ : entity is "xpm_cdc_async_rst";
  attribute RST_ACTIVE_HIGH : integer;
  attribute RST_ACTIVE_HIGH of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__4\ : entity is 0;
  attribute VERSION : integer;
  attribute VERSION of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__4\ : entity is 0;
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__4\ : entity is "TRUE";
  attribute keep_hierarchy : string;
  attribute keep_hierarchy of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__4\ : entity is "soft";
  attribute xpm_cdc : string;
  attribute xpm_cdc of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__4\ : entity is "ASYNC_RST";
end \c6v_capture_lifecycle_0_xpm_cdc_async_rst__4\;

architecture STRUCTURE of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__4\ is
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
entity \c6v_capture_lifecycle_0_xpm_cdc_async_rst__5\ is
  port (
    src_arst : in STD_LOGIC;
    dest_clk : in STD_LOGIC;
    dest_arst : out STD_LOGIC
  );
  attribute DEF_VAL : string;
  attribute DEF_VAL of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__5\ : entity is "1'b1";
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__5\ : entity is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__5\ : entity is 0;
  attribute INV_DEF_VAL : string;
  attribute INV_DEF_VAL of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__5\ : entity is "1'b0";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__5\ : entity is "xpm_cdc_async_rst";
  attribute RST_ACTIVE_HIGH : integer;
  attribute RST_ACTIVE_HIGH of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__5\ : entity is 0;
  attribute VERSION : integer;
  attribute VERSION of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__5\ : entity is 0;
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__5\ : entity is "TRUE";
  attribute keep_hierarchy : string;
  attribute keep_hierarchy of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__5\ : entity is "soft";
  attribute xpm_cdc : string;
  attribute xpm_cdc of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__5\ : entity is "ASYNC_RST";
end \c6v_capture_lifecycle_0_xpm_cdc_async_rst__5\;

architecture STRUCTURE of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__5\ is
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
entity \c6v_capture_lifecycle_0_xpm_cdc_async_rst__6\ is
  port (
    src_arst : in STD_LOGIC;
    dest_clk : in STD_LOGIC;
    dest_arst : out STD_LOGIC
  );
  attribute DEF_VAL : string;
  attribute DEF_VAL of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__6\ : entity is "1'b1";
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__6\ : entity is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__6\ : entity is 0;
  attribute INV_DEF_VAL : string;
  attribute INV_DEF_VAL of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__6\ : entity is "1'b0";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__6\ : entity is "xpm_cdc_async_rst";
  attribute RST_ACTIVE_HIGH : integer;
  attribute RST_ACTIVE_HIGH of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__6\ : entity is 0;
  attribute VERSION : integer;
  attribute VERSION of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__6\ : entity is 0;
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__6\ : entity is "TRUE";
  attribute keep_hierarchy : string;
  attribute keep_hierarchy of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__6\ : entity is "soft";
  attribute xpm_cdc : string;
  attribute xpm_cdc of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__6\ : entity is "ASYNC_RST";
end \c6v_capture_lifecycle_0_xpm_cdc_async_rst__6\;

architecture STRUCTURE of \c6v_capture_lifecycle_0_xpm_cdc_async_rst__6\ is
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
entity c6v_capture_lifecycle_0_xpm_cdc_single is
  port (
    src_clk : in STD_LOGIC;
    src_in : in STD_LOGIC;
    dest_clk : in STD_LOGIC;
    dest_out : out STD_LOGIC
  );
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of c6v_capture_lifecycle_0_xpm_cdc_single : entity is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of c6v_capture_lifecycle_0_xpm_cdc_single : entity is 0;
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_capture_lifecycle_0_xpm_cdc_single : entity is "xpm_cdc_single";
  attribute SIM_ASSERT_CHK : integer;
  attribute SIM_ASSERT_CHK of c6v_capture_lifecycle_0_xpm_cdc_single : entity is 1;
  attribute SRC_INPUT_REG : integer;
  attribute SRC_INPUT_REG of c6v_capture_lifecycle_0_xpm_cdc_single : entity is 0;
  attribute VERSION : integer;
  attribute VERSION of c6v_capture_lifecycle_0_xpm_cdc_single : entity is 0;
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of c6v_capture_lifecycle_0_xpm_cdc_single : entity is "TRUE";
  attribute keep_hierarchy : string;
  attribute keep_hierarchy of c6v_capture_lifecycle_0_xpm_cdc_single : entity is "soft";
  attribute xpm_cdc : string;
  attribute xpm_cdc of c6v_capture_lifecycle_0_xpm_cdc_single : entity is "SINGLE";
end c6v_capture_lifecycle_0_xpm_cdc_single;

architecture STRUCTURE of c6v_capture_lifecycle_0_xpm_cdc_single is
  signal syncstages_ff : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute RTL_KEEP : string;
  attribute RTL_KEEP of syncstages_ff : signal is "true";
  attribute async_reg : string;
  attribute async_reg of syncstages_ff : signal is "true";
  attribute xpm_cdc of syncstages_ff : signal is "SINGLE";
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \syncstages_ff_reg[0]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[0]\ : label is "SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[1]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[1]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[1]\ : label is "SINGLE";
  attribute ASYNC_REG_boolean of \syncstages_ff_reg[2]\ : label is std.standard.true;
  attribute KEEP of \syncstages_ff_reg[2]\ : label is "true";
  attribute XPM_CDC of \syncstages_ff_reg[2]\ : label is "SINGLE";
begin
  dest_out <= syncstages_ff(2);
\syncstages_ff_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => src_in,
      Q => syncstages_ff(0),
      R => '0'
    );
\syncstages_ff_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => syncstages_ff(0),
      Q => syncstages_ff(1),
      R => '0'
    );
\syncstages_ff_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => dest_clk,
      CE => '1',
      D => syncstages_ff(1),
      Q => syncstages_ff(2),
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_capture_lifecycle_0_vision_release_credit_cdc is
  port (
    Q : out STD_LOGIC_VECTOR ( 2 downto 0 );
    common_aresetn : in STD_LOGIC;
    vid_io_in_clk : in STD_LOGIC;
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    D : in STD_LOGIC_VECTOR ( 2 downto 0 );
    aclk : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_capture_lifecycle_0_vision_release_credit_cdc : entity is "vision_release_credit_cdc";
end c6v_capture_lifecycle_0_vision_release_credit_cdc;

architecture STRUCTURE of c6v_capture_lifecycle_0_vision_release_credit_cdc is
  signal gray_meta : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg : string;
  attribute async_reg of gray_meta : signal is "true";
  attribute shreg_extract : string;
  attribute shreg_extract of gray_meta : signal is "no";
  signal \gray_meta[2]_i_1_n_0\ : STD_LOGIC;
  signal gray_settled : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg of gray_settled : signal is "true";
  attribute shreg_extract of gray_settled : signal is "no";
  signal gray_sync : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg of gray_sync : signal is "true";
  attribute shreg_extract of gray_sync : signal is "no";
  signal p_2_out : STD_LOGIC_VECTOR ( 1 to 1 );
  signal released_sequence0_n_0 : STD_LOGIC;
  signal source_gray : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal video_resetn : STD_LOGIC;
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \gray_meta_reg[0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \gray_meta_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \gray_meta_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \gray_meta_reg[1]\ : label is std.standard.true;
  attribute KEEP of \gray_meta_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \gray_meta_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \gray_meta_reg[2]\ : label is std.standard.true;
  attribute KEEP of \gray_meta_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \gray_meta_reg[2]\ : label is "NO";
  attribute ASYNC_REG_boolean of \gray_settled_reg[0]\ : label is std.standard.true;
  attribute KEEP of \gray_settled_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \gray_settled_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \gray_settled_reg[1]\ : label is std.standard.true;
  attribute KEEP of \gray_settled_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \gray_settled_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \gray_settled_reg[2]\ : label is std.standard.true;
  attribute KEEP of \gray_settled_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \gray_settled_reg[2]\ : label is "NO";
  attribute ASYNC_REG_boolean of \gray_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP of \gray_sync_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \gray_sync_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \gray_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \gray_sync_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \gray_sync_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \gray_sync_reg[2]\ : label is std.standard.true;
  attribute KEEP of \gray_sync_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \gray_sync_reg[2]\ : label is "NO";
  attribute DEF_VAL : string;
  attribute DEF_VAL of video_reset : label is "1'b1";
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of video_reset : label is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of video_reset : label is 0;
  attribute INV_DEF_VAL : string;
  attribute INV_DEF_VAL of video_reset : label is "1'b0";
  attribute RST_ACTIVE_HIGH : integer;
  attribute RST_ACTIVE_HIGH of video_reset : label is 0;
  attribute VERSION : integer;
  attribute VERSION of video_reset : label is 0;
  attribute XPM_CDC : string;
  attribute XPM_CDC of video_reset : label is "ASYNC_RST";
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of video_reset : label is "TRUE";
begin
\gray_meta[2]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => video_resetn,
      O => \gray_meta[2]_i_1_n_0\
    );
\gray_meta_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \gray_meta[2]_i_1_n_0\,
      D => source_gray(0),
      Q => gray_meta(0)
    );
\gray_meta_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \gray_meta[2]_i_1_n_0\,
      D => source_gray(1),
      Q => gray_meta(1)
    );
\gray_meta_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \gray_meta[2]_i_1_n_0\,
      D => source_gray(2),
      Q => gray_meta(2)
    );
\gray_settled_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \gray_meta[2]_i_1_n_0\,
      D => gray_sync(0),
      Q => gray_settled(0)
    );
\gray_settled_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \gray_meta[2]_i_1_n_0\,
      D => gray_sync(1),
      Q => gray_settled(1)
    );
\gray_settled_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \gray_meta[2]_i_1_n_0\,
      D => gray_sync(2),
      Q => gray_settled(2)
    );
\gray_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \gray_meta[2]_i_1_n_0\,
      D => gray_meta(0),
      Q => gray_sync(0)
    );
\gray_sync_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \gray_meta[2]_i_1_n_0\,
      D => gray_meta(1),
      Q => gray_sync(1)
    );
\gray_sync_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \gray_meta[2]_i_1_n_0\,
      D => gray_meta(2),
      Q => gray_sync(2)
    );
released_sequence0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => gray_settled(2),
      I1 => gray_settled(0),
      I2 => gray_settled(1),
      O => released_sequence0_n_0
    );
\released_sequence[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => gray_settled(1),
      I1 => gray_settled(2),
      O => p_2_out(1)
    );
\released_sequence_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \gray_meta[2]_i_1_n_0\,
      D => released_sequence0_n_0,
      Q => Q(0)
    );
\released_sequence_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \gray_meta[2]_i_1_n_0\,
      D => p_2_out(1),
      Q => Q(1)
    );
\released_sequence_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \gray_meta[2]_i_1_n_0\,
      D => gray_settled(2),
      Q => Q(2)
    );
\source_gray_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => D(0),
      Q => source_gray(0),
      R => SR(0)
    );
\source_gray_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => D(1),
      Q => source_gray(1),
      R => SR(0)
    );
\source_gray_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => D(2),
      Q => source_gray(2),
      R => SR(0)
    );
video_reset: entity work.\c6v_capture_lifecycle_0_xpm_cdc_async_rst__1\
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
entity c6v_capture_lifecycle_0_vision_source_admission is
  port (
    src_in : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 95 downto 0 );
    axis_enable : out STD_LOGIC;
    source_quiescent : out STD_LOGIC;
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    \arststages_ff_reg[2]\ : out STD_LOGIC;
    S : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \admitted_pixels_reg[23]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \admitted_pixels_reg[35]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \admitted_pixels_reg[47]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \admitted_pixels_reg[59]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \admitted_frames_reg[7]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \admitted_frames_reg[19]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \admitted_frames_reg[31]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    common_aresetn : in STD_LOGIC;
    vid_io_in_clk : in STD_LOGIC;
    vid_vsync : in STD_LOGIC;
    vid_active_video : in STD_LOGIC;
    \close_sync_reg[0]_0\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \open_sync_reg[0]_0\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    Q : in STD_LOGIC_VECTOR ( 2 downto 0 );
    request_held_reg : in STD_LOGIC_VECTOR ( 0 to 0 );
    \source_protocol_fault3_carry__6\ : in STD_LOGIC_VECTOR ( 95 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_capture_lifecycle_0_vision_source_admission : entity is "vision_source_admission";
end c6v_capture_lifecycle_0_vision_source_admission;

architecture STRUCTURE of c6v_capture_lifecycle_0_vision_source_admission is
  signal \^d\ : STD_LOGIC_VECTOR ( 95 downto 0 );
  signal \FSM_sequential_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[0]_i_2_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_frames[31]_i_10_n_0\ : STD_LOGIC;
  signal \admitted_frames[31]_i_11_n_0\ : STD_LOGIC;
  signal \admitted_frames[31]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_frames[31]_i_3_n_0\ : STD_LOGIC;
  signal \admitted_frames[31]_i_4_n_0\ : STD_LOGIC;
  signal \admitted_frames[31]_i_5_n_0\ : STD_LOGIC;
  signal \admitted_frames[31]_i_6_n_0\ : STD_LOGIC;
  signal \admitted_frames[31]_i_7_n_0\ : STD_LOGIC;
  signal \admitted_frames[31]_i_8_n_0\ : STD_LOGIC;
  signal \admitted_frames[31]_i_9_n_0\ : STD_LOGIC;
  signal \admitted_frames[3]_i_2_n_0\ : STD_LOGIC;
  signal \admitted_frames_reg[11]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_frames_reg[11]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_frames_reg[11]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_frames_reg[11]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_frames_reg[11]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_frames_reg[11]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_frames_reg[11]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_frames_reg[11]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_frames_reg[15]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_frames_reg[15]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_frames_reg[15]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_frames_reg[15]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_frames_reg[15]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_frames_reg[15]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_frames_reg[15]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_frames_reg[15]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_frames_reg[19]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_frames_reg[19]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_frames_reg[19]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_frames_reg[19]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_frames_reg[19]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_frames_reg[19]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_frames_reg[19]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_frames_reg[19]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_frames_reg[23]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_frames_reg[23]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_frames_reg[23]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_frames_reg[23]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_frames_reg[23]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_frames_reg[23]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_frames_reg[23]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_frames_reg[23]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_frames_reg[27]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_frames_reg[27]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_frames_reg[27]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_frames_reg[27]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_frames_reg[27]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_frames_reg[27]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_frames_reg[27]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_frames_reg[27]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_frames_reg[31]_i_2_n_1\ : STD_LOGIC;
  signal \admitted_frames_reg[31]_i_2_n_2\ : STD_LOGIC;
  signal \admitted_frames_reg[31]_i_2_n_3\ : STD_LOGIC;
  signal \admitted_frames_reg[31]_i_2_n_4\ : STD_LOGIC;
  signal \admitted_frames_reg[31]_i_2_n_5\ : STD_LOGIC;
  signal \admitted_frames_reg[31]_i_2_n_6\ : STD_LOGIC;
  signal \admitted_frames_reg[31]_i_2_n_7\ : STD_LOGIC;
  signal \admitted_frames_reg[3]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_frames_reg[3]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_frames_reg[3]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_frames_reg[3]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_frames_reg[3]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_frames_reg[3]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_frames_reg[3]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_frames_reg[3]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_frames_reg[7]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_frames_reg[7]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_frames_reg[7]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_frames_reg[7]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_frames_reg[7]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_frames_reg[7]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_frames_reg[7]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_frames_reg[7]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels[3]_i_2_n_0\ : STD_LOGIC;
  signal \admitted_pixels[63]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[11]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[11]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[11]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[11]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[11]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[11]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[11]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[11]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[15]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[15]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[15]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[15]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[15]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[15]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[15]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[15]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[19]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[19]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[19]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[19]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[19]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[19]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[19]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[19]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[23]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[23]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[23]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[23]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[23]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[23]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[23]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[23]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[27]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[27]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[27]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[27]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[27]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[27]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[27]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[27]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[31]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[31]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[31]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[31]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[31]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[31]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[31]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[31]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[35]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[35]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[35]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[35]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[35]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[35]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[35]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[35]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[39]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[39]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[39]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[39]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[39]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[39]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[39]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[39]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[3]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[3]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[3]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[3]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[3]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[3]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[3]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[3]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[43]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[43]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[43]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[43]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[43]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[43]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[43]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[43]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[47]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[47]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[47]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[47]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[47]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[47]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[47]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[47]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[51]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[51]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[51]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[51]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[51]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[51]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[51]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[51]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[55]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[55]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[55]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[55]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[55]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[55]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[55]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[55]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[59]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[59]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[59]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[59]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[59]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[59]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[59]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[59]_i_1_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[63]_i_2_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[63]_i_2_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[63]_i_2_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[63]_i_2_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[63]_i_2_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[63]_i_2_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[63]_i_2_n_7\ : STD_LOGIC;
  signal \admitted_pixels_reg[7]_i_1_n_0\ : STD_LOGIC;
  signal \admitted_pixels_reg[7]_i_1_n_1\ : STD_LOGIC;
  signal \admitted_pixels_reg[7]_i_1_n_2\ : STD_LOGIC;
  signal \admitted_pixels_reg[7]_i_1_n_3\ : STD_LOGIC;
  signal \admitted_pixels_reg[7]_i_1_n_4\ : STD_LOGIC;
  signal \admitted_pixels_reg[7]_i_1_n_5\ : STD_LOGIC;
  signal \admitted_pixels_reg[7]_i_1_n_6\ : STD_LOGIC;
  signal \admitted_pixels_reg[7]_i_1_n_7\ : STD_LOGIC;
  signal \^axis_enable\ : STD_LOGIC;
  signal boundary_fault_i_10_n_0 : STD_LOGIC;
  signal boundary_fault_i_11_n_0 : STD_LOGIC;
  signal boundary_fault_i_12_n_0 : STD_LOGIC;
  signal boundary_fault_i_13_n_0 : STD_LOGIC;
  signal boundary_fault_i_14_n_0 : STD_LOGIC;
  signal boundary_fault_i_15_n_0 : STD_LOGIC;
  signal boundary_fault_i_16_n_0 : STD_LOGIC;
  signal boundary_fault_i_17_n_0 : STD_LOGIC;
  signal boundary_fault_i_18_n_0 : STD_LOGIC;
  signal boundary_fault_i_19_n_0 : STD_LOGIC;
  signal boundary_fault_i_1_n_0 : STD_LOGIC;
  signal boundary_fault_i_20_n_0 : STD_LOGIC;
  signal boundary_fault_i_21_n_0 : STD_LOGIC;
  signal boundary_fault_i_2_n_0 : STD_LOGIC;
  signal boundary_fault_i_3_n_0 : STD_LOGIC;
  signal boundary_fault_i_4_n_0 : STD_LOGIC;
  signal boundary_fault_i_5_n_0 : STD_LOGIC;
  signal boundary_fault_i_6_n_0 : STD_LOGIC;
  signal boundary_fault_i_7_n_0 : STD_LOGIC;
  signal boundary_fault_i_8_n_0 : STD_LOGIC;
  signal boundary_fault_i_9_n_0 : STD_LOGIC;
  signal close_sync : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg : string;
  attribute async_reg of close_sync : signal is "true";
  attribute shreg_extract : string;
  attribute shreg_extract of close_sync : signal is "no";
  signal frame_admitted : STD_LOGIC;
  signal frame_event_pending : STD_LOGIC;
  signal frame_present_i_1_n_0 : STD_LOGIC;
  signal frame_present_reg_n_0 : STD_LOGIC;
  signal frame_selected : STD_LOGIC;
  signal frame_selected_i_1_n_0 : STD_LOGIC;
  signal frame_selected_i_2_n_0 : STD_LOGIC;
  signal frame_selected_i_3_n_0 : STD_LOGIC;
  signal open_sync : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg of open_sync : signal is "true";
  attribute shreg_extract of open_sync : signal is "no";
  signal pixel_admitted : STD_LOGIC;
  signal pixel_event_pending : STD_LOGIC;
  signal reserved_sequence : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \reserved_sequence[0]_i_1_n_0\ : STD_LOGIC;
  signal \reserved_sequence[1]_i_1_n_0\ : STD_LOGIC;
  signal \reserved_sequence[2]_i_1_n_0\ : STD_LOGIC;
  signal reserved_sequence_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^src_in\ : STD_LOGIC;
  signal state : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal video_resetn : STD_LOGIC;
  signal vsync_held : STD_LOGIC;
  signal \NLW_admitted_frames_reg[31]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_admitted_pixels_reg[63]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_sequential_state[0]_i_2\ : label is "soft_lutpair0";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[0]\ : label is "WAIT_START:11,RUNNING:10,CLOSING:01,CLOSED:00";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[1]\ : label is "WAIT_START:11,RUNNING:10,CLOSING:01,CLOSED:00";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of \admitted_frames_reg[11]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_frames_reg[15]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_frames_reg[19]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_frames_reg[23]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_frames_reg[27]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_frames_reg[31]_i_2\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_frames_reg[3]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_frames_reg[7]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[11]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[15]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[19]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[23]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[27]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[31]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[35]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[39]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[3]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[43]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[47]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[51]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[55]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[59]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[63]_i_2\ : label is 35;
  attribute ADDER_THRESHOLD of \admitted_pixels_reg[7]_i_1\ : label is 35;
  attribute SOFT_HLUTNM of axis_enable_INST_0 : label is "soft_lutpair1";
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \close_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \close_sync_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \close_sync_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \close_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \close_sync_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \close_sync_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \close_sync_reg[2]\ : label is std.standard.true;
  attribute KEEP of \close_sync_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \close_sync_reg[2]\ : label is "NO";
  attribute SOFT_HLUTNM of frame_present_i_1 : label is "soft_lutpair0";
  attribute ASYNC_REG_boolean of \open_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP of \open_sync_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \open_sync_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \open_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \open_sync_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \open_sync_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \open_sync_reg[2]\ : label is std.standard.true;
  attribute KEEP of \open_sync_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \open_sync_reg[2]\ : label is "NO";
  attribute SOFT_HLUTNM of pixel_event_pending_i_1 : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \reserved_sequence[1]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \reserved_sequence[2]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of source_protocol_fault_i_2 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of source_quiescent_INST_0 : label is "soft_lutpair2";
  attribute DEF_VAL : string;
  attribute DEF_VAL of source_reset : label is "1'b1";
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of source_reset : label is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of source_reset : label is 0;
  attribute INV_DEF_VAL : string;
  attribute INV_DEF_VAL of source_reset : label is "1'b0";
  attribute RST_ACTIVE_HIGH : integer;
  attribute RST_ACTIVE_HIGH of source_reset : label is 0;
  attribute VERSION : integer;
  attribute VERSION of source_reset : label is 0;
  attribute XPM_CDC : string;
  attribute XPM_CDC of source_reset : label is "ASYNC_RST";
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of source_reset : label is "TRUE";
begin
  D(95 downto 0) <= \^d\(95 downto 0);
  axis_enable <= \^axis_enable\;
  src_in <= \^src_in\;
\FSM_sequential_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0AA0B0A0"
    )
        port map (
      I0 => \FSM_sequential_state[0]_i_2_n_0\,
      I1 => open_sync(2),
      I2 => state(0),
      I3 => state(1),
      I4 => close_sync(2),
      O => \FSM_sequential_state[0]_i_1_n_0\
    );
\FSM_sequential_state[0]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FD"
    )
        port map (
      I0 => vid_vsync,
      I1 => vsync_held,
      I2 => vid_active_video,
      O => \FSM_sequential_state[0]_i_2_n_0\
    );
\FSM_sequential_state[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => state(1),
      I1 => close_sync(2),
      O => \FSM_sequential_state[1]_i_1_n_0\
    );
\FSM_sequential_state_reg[0]\: unisim.vcomponents.FDPE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      D => \FSM_sequential_state[0]_i_1_n_0\,
      PRE => boundary_fault_i_2_n_0,
      Q => state(0)
    );
\FSM_sequential_state_reg[1]\: unisim.vcomponents.FDPE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      D => \FSM_sequential_state[1]_i_1_n_0\,
      PRE => boundary_fault_i_2_n_0,
      Q => state(1)
    );
\admitted_frames[31]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \admitted_frames[31]_i_3_n_0\,
      I1 => frame_event_pending,
      O => \admitted_frames[31]_i_1_n_0\
    );
\admitted_frames[31]_i_10\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^d\(93),
      I1 => \^d\(92),
      I2 => \^d\(95),
      I3 => \^d\(94),
      O => \admitted_frames[31]_i_10_n_0\
    );
\admitted_frames[31]_i_11\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^d\(85),
      I1 => \^d\(84),
      I2 => \^d\(87),
      I3 => \^d\(86),
      O => \admitted_frames[31]_i_11_n_0\
    );
\admitted_frames[31]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \admitted_frames[31]_i_4_n_0\,
      I1 => \admitted_frames[31]_i_5_n_0\,
      I2 => \admitted_frames[31]_i_6_n_0\,
      I3 => \admitted_frames[31]_i_7_n_0\,
      O => \admitted_frames[31]_i_3_n_0\
    );
\admitted_frames[31]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => \^d\(74),
      I1 => \^d\(75),
      I2 => \^d\(72),
      I3 => \^d\(73),
      I4 => \admitted_frames[31]_i_8_n_0\,
      O => \admitted_frames[31]_i_4_n_0\
    );
\admitted_frames[31]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => \^d\(66),
      I1 => \^d\(67),
      I2 => \^d\(64),
      I3 => \^d\(65),
      I4 => \admitted_frames[31]_i_9_n_0\,
      O => \admitted_frames[31]_i_5_n_0\
    );
\admitted_frames[31]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => \^d\(90),
      I1 => \^d\(91),
      I2 => \^d\(88),
      I3 => \^d\(89),
      I4 => \admitted_frames[31]_i_10_n_0\,
      O => \admitted_frames[31]_i_6_n_0\
    );
\admitted_frames[31]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => \^d\(82),
      I1 => \^d\(83),
      I2 => \^d\(80),
      I3 => \^d\(81),
      I4 => \admitted_frames[31]_i_11_n_0\,
      O => \admitted_frames[31]_i_7_n_0\
    );
\admitted_frames[31]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^d\(77),
      I1 => \^d\(76),
      I2 => \^d\(79),
      I3 => \^d\(78),
      O => \admitted_frames[31]_i_8_n_0\
    );
\admitted_frames[31]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^d\(69),
      I1 => \^d\(68),
      I2 => \^d\(71),
      I3 => \^d\(70),
      O => \admitted_frames[31]_i_9_n_0\
    );
\admitted_frames[3]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^d\(64),
      O => \admitted_frames[3]_i_2_n_0\
    );
\admitted_frames_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[3]_i_1_n_7\,
      Q => \^d\(64)
    );
\admitted_frames_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[11]_i_1_n_5\,
      Q => \^d\(74)
    );
\admitted_frames_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[11]_i_1_n_4\,
      Q => \^d\(75)
    );
\admitted_frames_reg[11]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_frames_reg[7]_i_1_n_0\,
      CO(3) => \admitted_frames_reg[11]_i_1_n_0\,
      CO(2) => \admitted_frames_reg[11]_i_1_n_1\,
      CO(1) => \admitted_frames_reg[11]_i_1_n_2\,
      CO(0) => \admitted_frames_reg[11]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_frames_reg[11]_i_1_n_4\,
      O(2) => \admitted_frames_reg[11]_i_1_n_5\,
      O(1) => \admitted_frames_reg[11]_i_1_n_6\,
      O(0) => \admitted_frames_reg[11]_i_1_n_7\,
      S(3 downto 0) => \^d\(75 downto 72)
    );
\admitted_frames_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[15]_i_1_n_7\,
      Q => \^d\(76)
    );
\admitted_frames_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[15]_i_1_n_6\,
      Q => \^d\(77)
    );
\admitted_frames_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[15]_i_1_n_5\,
      Q => \^d\(78)
    );
\admitted_frames_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[15]_i_1_n_4\,
      Q => \^d\(79)
    );
\admitted_frames_reg[15]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_frames_reg[11]_i_1_n_0\,
      CO(3) => \admitted_frames_reg[15]_i_1_n_0\,
      CO(2) => \admitted_frames_reg[15]_i_1_n_1\,
      CO(1) => \admitted_frames_reg[15]_i_1_n_2\,
      CO(0) => \admitted_frames_reg[15]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_frames_reg[15]_i_1_n_4\,
      O(2) => \admitted_frames_reg[15]_i_1_n_5\,
      O(1) => \admitted_frames_reg[15]_i_1_n_6\,
      O(0) => \admitted_frames_reg[15]_i_1_n_7\,
      S(3 downto 0) => \^d\(79 downto 76)
    );
\admitted_frames_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[19]_i_1_n_7\,
      Q => \^d\(80)
    );
\admitted_frames_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[19]_i_1_n_6\,
      Q => \^d\(81)
    );
\admitted_frames_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[19]_i_1_n_5\,
      Q => \^d\(82)
    );
\admitted_frames_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[19]_i_1_n_4\,
      Q => \^d\(83)
    );
\admitted_frames_reg[19]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_frames_reg[15]_i_1_n_0\,
      CO(3) => \admitted_frames_reg[19]_i_1_n_0\,
      CO(2) => \admitted_frames_reg[19]_i_1_n_1\,
      CO(1) => \admitted_frames_reg[19]_i_1_n_2\,
      CO(0) => \admitted_frames_reg[19]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_frames_reg[19]_i_1_n_4\,
      O(2) => \admitted_frames_reg[19]_i_1_n_5\,
      O(1) => \admitted_frames_reg[19]_i_1_n_6\,
      O(0) => \admitted_frames_reg[19]_i_1_n_7\,
      S(3 downto 0) => \^d\(83 downto 80)
    );
\admitted_frames_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[3]_i_1_n_6\,
      Q => \^d\(65)
    );
\admitted_frames_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[23]_i_1_n_7\,
      Q => \^d\(84)
    );
\admitted_frames_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[23]_i_1_n_6\,
      Q => \^d\(85)
    );
\admitted_frames_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[23]_i_1_n_5\,
      Q => \^d\(86)
    );
\admitted_frames_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[23]_i_1_n_4\,
      Q => \^d\(87)
    );
\admitted_frames_reg[23]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_frames_reg[19]_i_1_n_0\,
      CO(3) => \admitted_frames_reg[23]_i_1_n_0\,
      CO(2) => \admitted_frames_reg[23]_i_1_n_1\,
      CO(1) => \admitted_frames_reg[23]_i_1_n_2\,
      CO(0) => \admitted_frames_reg[23]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_frames_reg[23]_i_1_n_4\,
      O(2) => \admitted_frames_reg[23]_i_1_n_5\,
      O(1) => \admitted_frames_reg[23]_i_1_n_6\,
      O(0) => \admitted_frames_reg[23]_i_1_n_7\,
      S(3 downto 0) => \^d\(87 downto 84)
    );
\admitted_frames_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[27]_i_1_n_7\,
      Q => \^d\(88)
    );
\admitted_frames_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[27]_i_1_n_6\,
      Q => \^d\(89)
    );
\admitted_frames_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[27]_i_1_n_5\,
      Q => \^d\(90)
    );
\admitted_frames_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[27]_i_1_n_4\,
      Q => \^d\(91)
    );
\admitted_frames_reg[27]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_frames_reg[23]_i_1_n_0\,
      CO(3) => \admitted_frames_reg[27]_i_1_n_0\,
      CO(2) => \admitted_frames_reg[27]_i_1_n_1\,
      CO(1) => \admitted_frames_reg[27]_i_1_n_2\,
      CO(0) => \admitted_frames_reg[27]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_frames_reg[27]_i_1_n_4\,
      O(2) => \admitted_frames_reg[27]_i_1_n_5\,
      O(1) => \admitted_frames_reg[27]_i_1_n_6\,
      O(0) => \admitted_frames_reg[27]_i_1_n_7\,
      S(3 downto 0) => \^d\(91 downto 88)
    );
\admitted_frames_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[31]_i_2_n_7\,
      Q => \^d\(92)
    );
\admitted_frames_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[31]_i_2_n_6\,
      Q => \^d\(93)
    );
\admitted_frames_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[3]_i_1_n_5\,
      Q => \^d\(66)
    );
\admitted_frames_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[31]_i_2_n_5\,
      Q => \^d\(94)
    );
\admitted_frames_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[31]_i_2_n_4\,
      Q => \^d\(95)
    );
\admitted_frames_reg[31]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_frames_reg[27]_i_1_n_0\,
      CO(3) => \NLW_admitted_frames_reg[31]_i_2_CO_UNCONNECTED\(3),
      CO(2) => \admitted_frames_reg[31]_i_2_n_1\,
      CO(1) => \admitted_frames_reg[31]_i_2_n_2\,
      CO(0) => \admitted_frames_reg[31]_i_2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_frames_reg[31]_i_2_n_4\,
      O(2) => \admitted_frames_reg[31]_i_2_n_5\,
      O(1) => \admitted_frames_reg[31]_i_2_n_6\,
      O(0) => \admitted_frames_reg[31]_i_2_n_7\,
      S(3 downto 0) => \^d\(95 downto 92)
    );
\admitted_frames_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[3]_i_1_n_4\,
      Q => \^d\(67)
    );
\admitted_frames_reg[3]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \admitted_frames_reg[3]_i_1_n_0\,
      CO(2) => \admitted_frames_reg[3]_i_1_n_1\,
      CO(1) => \admitted_frames_reg[3]_i_1_n_2\,
      CO(0) => \admitted_frames_reg[3]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \admitted_frames_reg[3]_i_1_n_4\,
      O(2) => \admitted_frames_reg[3]_i_1_n_5\,
      O(1) => \admitted_frames_reg[3]_i_1_n_6\,
      O(0) => \admitted_frames_reg[3]_i_1_n_7\,
      S(3 downto 1) => \^d\(67 downto 65),
      S(0) => \admitted_frames[3]_i_2_n_0\
    );
\admitted_frames_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[7]_i_1_n_7\,
      Q => \^d\(68)
    );
\admitted_frames_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[7]_i_1_n_6\,
      Q => \^d\(69)
    );
\admitted_frames_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[7]_i_1_n_5\,
      Q => \^d\(70)
    );
\admitted_frames_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[7]_i_1_n_4\,
      Q => \^d\(71)
    );
\admitted_frames_reg[7]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_frames_reg[3]_i_1_n_0\,
      CO(3) => \admitted_frames_reg[7]_i_1_n_0\,
      CO(2) => \admitted_frames_reg[7]_i_1_n_1\,
      CO(1) => \admitted_frames_reg[7]_i_1_n_2\,
      CO(0) => \admitted_frames_reg[7]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_frames_reg[7]_i_1_n_4\,
      O(2) => \admitted_frames_reg[7]_i_1_n_5\,
      O(1) => \admitted_frames_reg[7]_i_1_n_6\,
      O(0) => \admitted_frames_reg[7]_i_1_n_7\,
      S(3 downto 0) => \^d\(71 downto 68)
    );
\admitted_frames_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[11]_i_1_n_7\,
      Q => \^d\(72)
    );
\admitted_frames_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_frames[31]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_frames_reg[11]_i_1_n_6\,
      Q => \^d\(73)
    );
\admitted_pixels[3]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^d\(0),
      O => \admitted_pixels[3]_i_2_n_0\
    );
\admitted_pixels[63]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => boundary_fault_i_5_n_0,
      I1 => pixel_event_pending,
      O => \admitted_pixels[63]_i_1_n_0\
    );
\admitted_pixels_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[3]_i_1_n_7\,
      Q => \^d\(0)
    );
\admitted_pixels_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[11]_i_1_n_5\,
      Q => \^d\(10)
    );
\admitted_pixels_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[11]_i_1_n_4\,
      Q => \^d\(11)
    );
\admitted_pixels_reg[11]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[7]_i_1_n_0\,
      CO(3) => \admitted_pixels_reg[11]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[11]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[11]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[11]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[11]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[11]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[11]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[11]_i_1_n_7\,
      S(3 downto 0) => \^d\(11 downto 8)
    );
\admitted_pixels_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[15]_i_1_n_7\,
      Q => \^d\(12)
    );
\admitted_pixels_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[15]_i_1_n_6\,
      Q => \^d\(13)
    );
\admitted_pixels_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[15]_i_1_n_5\,
      Q => \^d\(14)
    );
\admitted_pixels_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[15]_i_1_n_4\,
      Q => \^d\(15)
    );
\admitted_pixels_reg[15]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[11]_i_1_n_0\,
      CO(3) => \admitted_pixels_reg[15]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[15]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[15]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[15]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[15]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[15]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[15]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[15]_i_1_n_7\,
      S(3 downto 0) => \^d\(15 downto 12)
    );
\admitted_pixels_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[19]_i_1_n_7\,
      Q => \^d\(16)
    );
\admitted_pixels_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[19]_i_1_n_6\,
      Q => \^d\(17)
    );
\admitted_pixels_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[19]_i_1_n_5\,
      Q => \^d\(18)
    );
\admitted_pixels_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[19]_i_1_n_4\,
      Q => \^d\(19)
    );
\admitted_pixels_reg[19]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[15]_i_1_n_0\,
      CO(3) => \admitted_pixels_reg[19]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[19]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[19]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[19]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[19]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[19]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[19]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[19]_i_1_n_7\,
      S(3 downto 0) => \^d\(19 downto 16)
    );
\admitted_pixels_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[3]_i_1_n_6\,
      Q => \^d\(1)
    );
\admitted_pixels_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[23]_i_1_n_7\,
      Q => \^d\(20)
    );
\admitted_pixels_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[23]_i_1_n_6\,
      Q => \^d\(21)
    );
\admitted_pixels_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[23]_i_1_n_5\,
      Q => \^d\(22)
    );
\admitted_pixels_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[23]_i_1_n_4\,
      Q => \^d\(23)
    );
\admitted_pixels_reg[23]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[19]_i_1_n_0\,
      CO(3) => \admitted_pixels_reg[23]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[23]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[23]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[23]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[23]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[23]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[23]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[23]_i_1_n_7\,
      S(3 downto 0) => \^d\(23 downto 20)
    );
\admitted_pixels_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[27]_i_1_n_7\,
      Q => \^d\(24)
    );
\admitted_pixels_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[27]_i_1_n_6\,
      Q => \^d\(25)
    );
\admitted_pixels_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[27]_i_1_n_5\,
      Q => \^d\(26)
    );
\admitted_pixels_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[27]_i_1_n_4\,
      Q => \^d\(27)
    );
\admitted_pixels_reg[27]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[23]_i_1_n_0\,
      CO(3) => \admitted_pixels_reg[27]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[27]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[27]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[27]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[27]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[27]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[27]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[27]_i_1_n_7\,
      S(3 downto 0) => \^d\(27 downto 24)
    );
\admitted_pixels_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[31]_i_1_n_7\,
      Q => \^d\(28)
    );
\admitted_pixels_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[31]_i_1_n_6\,
      Q => \^d\(29)
    );
\admitted_pixels_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[3]_i_1_n_5\,
      Q => \^d\(2)
    );
\admitted_pixels_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[31]_i_1_n_5\,
      Q => \^d\(30)
    );
\admitted_pixels_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[31]_i_1_n_4\,
      Q => \^d\(31)
    );
\admitted_pixels_reg[31]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[27]_i_1_n_0\,
      CO(3) => \admitted_pixels_reg[31]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[31]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[31]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[31]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[31]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[31]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[31]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[31]_i_1_n_7\,
      S(3 downto 0) => \^d\(31 downto 28)
    );
\admitted_pixels_reg[32]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[35]_i_1_n_7\,
      Q => \^d\(32)
    );
\admitted_pixels_reg[33]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[35]_i_1_n_6\,
      Q => \^d\(33)
    );
\admitted_pixels_reg[34]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[35]_i_1_n_5\,
      Q => \^d\(34)
    );
\admitted_pixels_reg[35]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[35]_i_1_n_4\,
      Q => \^d\(35)
    );
\admitted_pixels_reg[35]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[31]_i_1_n_0\,
      CO(3) => \admitted_pixels_reg[35]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[35]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[35]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[35]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[35]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[35]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[35]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[35]_i_1_n_7\,
      S(3 downto 0) => \^d\(35 downto 32)
    );
\admitted_pixels_reg[36]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[39]_i_1_n_7\,
      Q => \^d\(36)
    );
\admitted_pixels_reg[37]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[39]_i_1_n_6\,
      Q => \^d\(37)
    );
\admitted_pixels_reg[38]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[39]_i_1_n_5\,
      Q => \^d\(38)
    );
\admitted_pixels_reg[39]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[39]_i_1_n_4\,
      Q => \^d\(39)
    );
\admitted_pixels_reg[39]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[35]_i_1_n_0\,
      CO(3) => \admitted_pixels_reg[39]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[39]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[39]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[39]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[39]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[39]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[39]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[39]_i_1_n_7\,
      S(3 downto 0) => \^d\(39 downto 36)
    );
\admitted_pixels_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[3]_i_1_n_4\,
      Q => \^d\(3)
    );
\admitted_pixels_reg[3]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \admitted_pixels_reg[3]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[3]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[3]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[3]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \admitted_pixels_reg[3]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[3]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[3]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[3]_i_1_n_7\,
      S(3 downto 1) => \^d\(3 downto 1),
      S(0) => \admitted_pixels[3]_i_2_n_0\
    );
\admitted_pixels_reg[40]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[43]_i_1_n_7\,
      Q => \^d\(40)
    );
\admitted_pixels_reg[41]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[43]_i_1_n_6\,
      Q => \^d\(41)
    );
\admitted_pixels_reg[42]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[43]_i_1_n_5\,
      Q => \^d\(42)
    );
\admitted_pixels_reg[43]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[43]_i_1_n_4\,
      Q => \^d\(43)
    );
\admitted_pixels_reg[43]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[39]_i_1_n_0\,
      CO(3) => \admitted_pixels_reg[43]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[43]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[43]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[43]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[43]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[43]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[43]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[43]_i_1_n_7\,
      S(3 downto 0) => \^d\(43 downto 40)
    );
\admitted_pixels_reg[44]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[47]_i_1_n_7\,
      Q => \^d\(44)
    );
\admitted_pixels_reg[45]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[47]_i_1_n_6\,
      Q => \^d\(45)
    );
\admitted_pixels_reg[46]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[47]_i_1_n_5\,
      Q => \^d\(46)
    );
\admitted_pixels_reg[47]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[47]_i_1_n_4\,
      Q => \^d\(47)
    );
\admitted_pixels_reg[47]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[43]_i_1_n_0\,
      CO(3) => \admitted_pixels_reg[47]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[47]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[47]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[47]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[47]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[47]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[47]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[47]_i_1_n_7\,
      S(3 downto 0) => \^d\(47 downto 44)
    );
\admitted_pixels_reg[48]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[51]_i_1_n_7\,
      Q => \^d\(48)
    );
\admitted_pixels_reg[49]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[51]_i_1_n_6\,
      Q => \^d\(49)
    );
\admitted_pixels_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[7]_i_1_n_7\,
      Q => \^d\(4)
    );
\admitted_pixels_reg[50]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[51]_i_1_n_5\,
      Q => \^d\(50)
    );
\admitted_pixels_reg[51]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[51]_i_1_n_4\,
      Q => \^d\(51)
    );
\admitted_pixels_reg[51]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[47]_i_1_n_0\,
      CO(3) => \admitted_pixels_reg[51]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[51]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[51]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[51]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[51]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[51]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[51]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[51]_i_1_n_7\,
      S(3 downto 0) => \^d\(51 downto 48)
    );
\admitted_pixels_reg[52]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[55]_i_1_n_7\,
      Q => \^d\(52)
    );
\admitted_pixels_reg[53]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[55]_i_1_n_6\,
      Q => \^d\(53)
    );
\admitted_pixels_reg[54]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[55]_i_1_n_5\,
      Q => \^d\(54)
    );
\admitted_pixels_reg[55]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[55]_i_1_n_4\,
      Q => \^d\(55)
    );
\admitted_pixels_reg[55]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[51]_i_1_n_0\,
      CO(3) => \admitted_pixels_reg[55]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[55]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[55]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[55]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[55]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[55]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[55]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[55]_i_1_n_7\,
      S(3 downto 0) => \^d\(55 downto 52)
    );
\admitted_pixels_reg[56]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[59]_i_1_n_7\,
      Q => \^d\(56)
    );
\admitted_pixels_reg[57]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[59]_i_1_n_6\,
      Q => \^d\(57)
    );
\admitted_pixels_reg[58]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[59]_i_1_n_5\,
      Q => \^d\(58)
    );
\admitted_pixels_reg[59]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[59]_i_1_n_4\,
      Q => \^d\(59)
    );
\admitted_pixels_reg[59]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[55]_i_1_n_0\,
      CO(3) => \admitted_pixels_reg[59]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[59]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[59]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[59]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[59]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[59]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[59]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[59]_i_1_n_7\,
      S(3 downto 0) => \^d\(59 downto 56)
    );
\admitted_pixels_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[7]_i_1_n_6\,
      Q => \^d\(5)
    );
\admitted_pixels_reg[60]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[63]_i_2_n_7\,
      Q => \^d\(60)
    );
\admitted_pixels_reg[61]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[63]_i_2_n_6\,
      Q => \^d\(61)
    );
\admitted_pixels_reg[62]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[63]_i_2_n_5\,
      Q => \^d\(62)
    );
\admitted_pixels_reg[63]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[63]_i_2_n_4\,
      Q => \^d\(63)
    );
\admitted_pixels_reg[63]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[59]_i_1_n_0\,
      CO(3) => \NLW_admitted_pixels_reg[63]_i_2_CO_UNCONNECTED\(3),
      CO(2) => \admitted_pixels_reg[63]_i_2_n_1\,
      CO(1) => \admitted_pixels_reg[63]_i_2_n_2\,
      CO(0) => \admitted_pixels_reg[63]_i_2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[63]_i_2_n_4\,
      O(2) => \admitted_pixels_reg[63]_i_2_n_5\,
      O(1) => \admitted_pixels_reg[63]_i_2_n_6\,
      O(0) => \admitted_pixels_reg[63]_i_2_n_7\,
      S(3 downto 0) => \^d\(63 downto 60)
    );
\admitted_pixels_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[7]_i_1_n_5\,
      Q => \^d\(6)
    );
\admitted_pixels_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[7]_i_1_n_4\,
      Q => \^d\(7)
    );
\admitted_pixels_reg[7]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \admitted_pixels_reg[3]_i_1_n_0\,
      CO(3) => \admitted_pixels_reg[7]_i_1_n_0\,
      CO(2) => \admitted_pixels_reg[7]_i_1_n_1\,
      CO(1) => \admitted_pixels_reg[7]_i_1_n_2\,
      CO(0) => \admitted_pixels_reg[7]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \admitted_pixels_reg[7]_i_1_n_4\,
      O(2) => \admitted_pixels_reg[7]_i_1_n_5\,
      O(1) => \admitted_pixels_reg[7]_i_1_n_6\,
      O(0) => \admitted_pixels_reg[7]_i_1_n_7\,
      S(3 downto 0) => \^d\(7 downto 4)
    );
\admitted_pixels_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[11]_i_1_n_7\,
      Q => \^d\(8)
    );
\admitted_pixels_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => \admitted_pixels[63]_i_1_n_0\,
      CLR => boundary_fault_i_2_n_0,
      D => \admitted_pixels_reg[11]_i_1_n_6\,
      Q => \^d\(9)
    );
axis_enable_INST_0: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0880"
    )
        port map (
      I0 => video_resetn,
      I1 => frame_selected,
      I2 => state(1),
      I3 => state(0),
      O => \^axis_enable\
    );
boundary_fault_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFEFEE"
    )
        port map (
      I0 => boundary_fault_i_3_n_0,
      I1 => boundary_fault_i_4_n_0,
      I2 => boundary_fault_i_5_n_0,
      I3 => pixel_event_pending,
      I4 => \^src_in\,
      O => boundary_fault_i_1_n_0
    );
boundary_fault_i_10: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^d\(21),
      I1 => \^d\(20),
      I2 => \^d\(23),
      I3 => \^d\(22),
      O => boundary_fault_i_10_n_0
    );
boundary_fault_i_11: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => \^d\(26),
      I1 => \^d\(27),
      I2 => \^d\(24),
      I3 => \^d\(25),
      I4 => boundary_fault_i_18_n_0,
      O => boundary_fault_i_11_n_0
    );
boundary_fault_i_12: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^d\(5),
      I1 => \^d\(4),
      I2 => \^d\(7),
      I3 => \^d\(6),
      O => boundary_fault_i_12_n_0
    );
boundary_fault_i_13: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => \^d\(10),
      I1 => \^d\(11),
      I2 => \^d\(8),
      I3 => \^d\(9),
      I4 => boundary_fault_i_19_n_0,
      O => boundary_fault_i_13_n_0
    );
boundary_fault_i_14: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^d\(53),
      I1 => \^d\(52),
      I2 => \^d\(55),
      I3 => \^d\(54),
      O => boundary_fault_i_14_n_0
    );
boundary_fault_i_15: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => \^d\(58),
      I1 => \^d\(59),
      I2 => \^d\(56),
      I3 => \^d\(57),
      I4 => boundary_fault_i_20_n_0,
      O => boundary_fault_i_15_n_0
    );
boundary_fault_i_16: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^d\(37),
      I1 => \^d\(36),
      I2 => \^d\(39),
      I3 => \^d\(38),
      O => boundary_fault_i_16_n_0
    );
boundary_fault_i_17: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => \^d\(42),
      I1 => \^d\(43),
      I2 => \^d\(40),
      I3 => \^d\(41),
      I4 => boundary_fault_i_21_n_0,
      O => boundary_fault_i_17_n_0
    );
boundary_fault_i_18: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^d\(29),
      I1 => \^d\(28),
      I2 => \^d\(31),
      I3 => \^d\(30),
      O => boundary_fault_i_18_n_0
    );
boundary_fault_i_19: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^d\(13),
      I1 => \^d\(12),
      I2 => \^d\(15),
      I3 => \^d\(14),
      O => boundary_fault_i_19_n_0
    );
boundary_fault_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => video_resetn,
      O => boundary_fault_i_2_n_0
    );
boundary_fault_i_20: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^d\(61),
      I1 => \^d\(60),
      I2 => \^d\(63),
      I3 => \^d\(62),
      O => boundary_fault_i_20_n_0
    );
boundary_fault_i_21: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^d\(45),
      I1 => \^d\(44),
      I2 => \^d\(47),
      I3 => \^d\(46),
      O => boundary_fault_i_21_n_0
    );
boundary_fault_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"44D4BB2BBB2B44D4"
    )
        port map (
      I0 => reserved_sequence(1),
      I1 => Q(1),
      I2 => Q(0),
      I3 => reserved_sequence(0),
      I4 => Q(2),
      I5 => reserved_sequence(2),
      O => boundary_fault_i_3_n_0
    );
boundary_fault_i_4: unisim.vcomponents.LUT5
    generic map(
      INIT => X"4F444444"
    )
        port map (
      I0 => \admitted_frames[31]_i_3_n_0\,
      I1 => frame_event_pending,
      I2 => vsync_held,
      I3 => vid_vsync,
      I4 => vid_active_video,
      O => boundary_fault_i_4_n_0
    );
boundary_fault_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => boundary_fault_i_6_n_0,
      I1 => boundary_fault_i_7_n_0,
      I2 => boundary_fault_i_8_n_0,
      I3 => boundary_fault_i_9_n_0,
      O => boundary_fault_i_5_n_0
    );
boundary_fault_i_6: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFBFFFFFFF"
    )
        port map (
      I0 => boundary_fault_i_10_n_0,
      I1 => \^d\(17),
      I2 => \^d\(16),
      I3 => \^d\(19),
      I4 => \^d\(18),
      I5 => boundary_fault_i_11_n_0,
      O => boundary_fault_i_6_n_0
    );
boundary_fault_i_7: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFBFFFFFFF"
    )
        port map (
      I0 => boundary_fault_i_12_n_0,
      I1 => \^d\(1),
      I2 => \^d\(0),
      I3 => \^d\(3),
      I4 => \^d\(2),
      I5 => boundary_fault_i_13_n_0,
      O => boundary_fault_i_7_n_0
    );
boundary_fault_i_8: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFBFFFFFFF"
    )
        port map (
      I0 => boundary_fault_i_14_n_0,
      I1 => \^d\(49),
      I2 => \^d\(48),
      I3 => \^d\(51),
      I4 => \^d\(50),
      I5 => boundary_fault_i_15_n_0,
      O => boundary_fault_i_8_n_0
    );
boundary_fault_i_9: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFBFFFFFFF"
    )
        port map (
      I0 => boundary_fault_i_16_n_0,
      I1 => \^d\(33),
      I2 => \^d\(32),
      I3 => \^d\(35),
      I4 => \^d\(34),
      I5 => boundary_fault_i_17_n_0,
      O => boundary_fault_i_9_n_0
    );
boundary_fault_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => boundary_fault_i_1_n_0,
      Q => \^src_in\
    );
\close_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => \close_sync_reg[0]_0\(0),
      Q => close_sync(0)
    );
\close_sync_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => close_sync(0),
      Q => close_sync(1)
    );
\close_sync_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => close_sync(1),
      Q => close_sync(2)
    );
frame_event_pending_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0440000000000000"
    )
        port map (
      I0 => \FSM_sequential_state[0]_i_2_n_0\,
      I1 => frame_present_reg_n_0,
      I2 => state(0),
      I3 => state(1),
      I4 => frame_selected,
      I5 => video_resetn,
      O => frame_admitted
    );
frame_event_pending_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => frame_admitted,
      Q => frame_event_pending
    );
frame_present_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F8F8B8F8"
    )
        port map (
      I0 => vid_active_video,
      I1 => \^axis_enable\,
      I2 => frame_present_reg_n_0,
      I3 => vid_vsync,
      I4 => vsync_held,
      O => frame_present_i_1_n_0
    );
frame_present_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => frame_present_i_1_n_0,
      Q => frame_present_reg_n_0
    );
frame_selected_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAEAAA2AAA2AAA2"
    )
        port map (
      I0 => frame_selected,
      I1 => vid_vsync,
      I2 => vsync_held,
      I3 => vid_active_video,
      I4 => frame_selected_i_2_n_0,
      I5 => frame_selected_i_3_n_0,
      O => frame_selected_i_1_n_0
    );
frame_selected_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"04040004"
    )
        port map (
      I0 => \^src_in\,
      I1 => state(1),
      I2 => close_sync(2),
      I3 => state(0),
      I4 => open_sync(2),
      O => frame_selected_i_2_n_0
    );
frame_selected_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9990099960996609"
    )
        port map (
      I0 => reserved_sequence(2),
      I1 => Q(2),
      I2 => Q(0),
      I3 => Q(1),
      I4 => reserved_sequence(0),
      I5 => reserved_sequence(1),
      O => frame_selected_i_3_n_0
    );
frame_selected_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => frame_selected_i_1_n_0,
      Q => frame_selected
    );
\open_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => \open_sync_reg[0]_0\(0),
      Q => open_sync(0)
    );
\open_sync_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => open_sync(0),
      Q => open_sync(1)
    );
\open_sync_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => open_sync(1),
      Q => open_sync(2)
    );
pixel_event_pending_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"60000000"
    )
        port map (
      I0 => state(0),
      I1 => state(1),
      I2 => frame_selected,
      I3 => video_resetn,
      I4 => vid_active_video,
      O => pixel_admitted
    );
pixel_event_pending_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => pixel_admitted,
      Q => pixel_event_pending
    );
request_held_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000010000"
    )
        port map (
      I0 => frame_event_pending,
      I1 => pixel_event_pending,
      I2 => state(1),
      I3 => state(0),
      I4 => video_resetn,
      I5 => request_held_reg(0),
      O => E(0)
    );
\reserved_sequence[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => reserved_sequence_0(0),
      I1 => reserved_sequence(0),
      O => \reserved_sequence[0]_i_1_n_0\
    );
\reserved_sequence[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => reserved_sequence(0),
      I1 => reserved_sequence_0(0),
      I2 => reserved_sequence(1),
      O => \reserved_sequence[1]_i_1_n_0\
    );
\reserved_sequence[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => reserved_sequence(1),
      I1 => reserved_sequence(0),
      I2 => reserved_sequence_0(0),
      I3 => reserved_sequence(2),
      O => \reserved_sequence[2]_i_1_n_0\
    );
\reserved_sequence[2]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"02000000"
    )
        port map (
      I0 => vid_vsync,
      I1 => vsync_held,
      I2 => vid_active_video,
      I3 => frame_selected_i_2_n_0,
      I4 => frame_selected_i_3_n_0,
      O => reserved_sequence_0(0)
    );
\reserved_sequence_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => \reserved_sequence[0]_i_1_n_0\,
      Q => reserved_sequence(0)
    );
\reserved_sequence_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => \reserved_sequence[1]_i_1_n_0\,
      Q => reserved_sequence(1)
    );
\reserved_sequence_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => \reserved_sequence[2]_i_1_n_0\,
      Q => reserved_sequence(2)
    );
\source_protocol_fault3_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(23),
      I1 => \source_protocol_fault3_carry__6\(23),
      I2 => \^d\(22),
      I3 => \source_protocol_fault3_carry__6\(22),
      I4 => \source_protocol_fault3_carry__6\(21),
      I5 => \^d\(21),
      O => \admitted_pixels_reg[23]_0\(3)
    );
\source_protocol_fault3_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(20),
      I1 => \source_protocol_fault3_carry__6\(20),
      I2 => \^d\(19),
      I3 => \source_protocol_fault3_carry__6\(19),
      I4 => \source_protocol_fault3_carry__6\(18),
      I5 => \^d\(18),
      O => \admitted_pixels_reg[23]_0\(2)
    );
\source_protocol_fault3_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(17),
      I1 => \source_protocol_fault3_carry__6\(17),
      I2 => \^d\(16),
      I3 => \source_protocol_fault3_carry__6\(16),
      I4 => \source_protocol_fault3_carry__6\(15),
      I5 => \^d\(15),
      O => \admitted_pixels_reg[23]_0\(1)
    );
\source_protocol_fault3_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(14),
      I1 => \source_protocol_fault3_carry__6\(14),
      I2 => \^d\(13),
      I3 => \source_protocol_fault3_carry__6\(13),
      I4 => \source_protocol_fault3_carry__6\(12),
      I5 => \^d\(12),
      O => \admitted_pixels_reg[23]_0\(0)
    );
\source_protocol_fault3_carry__1_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(35),
      I1 => \source_protocol_fault3_carry__6\(35),
      I2 => \^d\(34),
      I3 => \source_protocol_fault3_carry__6\(34),
      I4 => \source_protocol_fault3_carry__6\(33),
      I5 => \^d\(33),
      O => \admitted_pixels_reg[35]_0\(3)
    );
\source_protocol_fault3_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(32),
      I1 => \source_protocol_fault3_carry__6\(32),
      I2 => \^d\(31),
      I3 => \source_protocol_fault3_carry__6\(31),
      I4 => \source_protocol_fault3_carry__6\(30),
      I5 => \^d\(30),
      O => \admitted_pixels_reg[35]_0\(2)
    );
\source_protocol_fault3_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(29),
      I1 => \source_protocol_fault3_carry__6\(29),
      I2 => \^d\(28),
      I3 => \source_protocol_fault3_carry__6\(28),
      I4 => \source_protocol_fault3_carry__6\(27),
      I5 => \^d\(27),
      O => \admitted_pixels_reg[35]_0\(1)
    );
\source_protocol_fault3_carry__1_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(26),
      I1 => \source_protocol_fault3_carry__6\(26),
      I2 => \^d\(25),
      I3 => \source_protocol_fault3_carry__6\(25),
      I4 => \source_protocol_fault3_carry__6\(24),
      I5 => \^d\(24),
      O => \admitted_pixels_reg[35]_0\(0)
    );
\source_protocol_fault3_carry__2_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(47),
      I1 => \source_protocol_fault3_carry__6\(47),
      I2 => \^d\(46),
      I3 => \source_protocol_fault3_carry__6\(46),
      I4 => \source_protocol_fault3_carry__6\(45),
      I5 => \^d\(45),
      O => \admitted_pixels_reg[47]_0\(3)
    );
\source_protocol_fault3_carry__2_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(44),
      I1 => \source_protocol_fault3_carry__6\(44),
      I2 => \^d\(43),
      I3 => \source_protocol_fault3_carry__6\(43),
      I4 => \source_protocol_fault3_carry__6\(42),
      I5 => \^d\(42),
      O => \admitted_pixels_reg[47]_0\(2)
    );
\source_protocol_fault3_carry__2_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(41),
      I1 => \source_protocol_fault3_carry__6\(41),
      I2 => \^d\(40),
      I3 => \source_protocol_fault3_carry__6\(40),
      I4 => \source_protocol_fault3_carry__6\(39),
      I5 => \^d\(39),
      O => \admitted_pixels_reg[47]_0\(1)
    );
\source_protocol_fault3_carry__2_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(38),
      I1 => \source_protocol_fault3_carry__6\(38),
      I2 => \^d\(37),
      I3 => \source_protocol_fault3_carry__6\(37),
      I4 => \source_protocol_fault3_carry__6\(36),
      I5 => \^d\(36),
      O => \admitted_pixels_reg[47]_0\(0)
    );
\source_protocol_fault3_carry__3_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(59),
      I1 => \source_protocol_fault3_carry__6\(59),
      I2 => \^d\(58),
      I3 => \source_protocol_fault3_carry__6\(58),
      I4 => \source_protocol_fault3_carry__6\(57),
      I5 => \^d\(57),
      O => \admitted_pixels_reg[59]_0\(3)
    );
\source_protocol_fault3_carry__3_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(56),
      I1 => \source_protocol_fault3_carry__6\(56),
      I2 => \^d\(55),
      I3 => \source_protocol_fault3_carry__6\(55),
      I4 => \source_protocol_fault3_carry__6\(54),
      I5 => \^d\(54),
      O => \admitted_pixels_reg[59]_0\(2)
    );
\source_protocol_fault3_carry__3_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(53),
      I1 => \source_protocol_fault3_carry__6\(53),
      I2 => \^d\(52),
      I3 => \source_protocol_fault3_carry__6\(52),
      I4 => \source_protocol_fault3_carry__6\(51),
      I5 => \^d\(51),
      O => \admitted_pixels_reg[59]_0\(1)
    );
\source_protocol_fault3_carry__3_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(50),
      I1 => \source_protocol_fault3_carry__6\(50),
      I2 => \^d\(49),
      I3 => \source_protocol_fault3_carry__6\(49),
      I4 => \source_protocol_fault3_carry__6\(48),
      I5 => \^d\(48),
      O => \admitted_pixels_reg[59]_0\(0)
    );
\source_protocol_fault3_carry__4_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(71),
      I1 => \source_protocol_fault3_carry__6\(71),
      I2 => \^d\(70),
      I3 => \source_protocol_fault3_carry__6\(70),
      I4 => \source_protocol_fault3_carry__6\(69),
      I5 => \^d\(69),
      O => \admitted_frames_reg[7]_0\(3)
    );
\source_protocol_fault3_carry__4_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(68),
      I1 => \source_protocol_fault3_carry__6\(68),
      I2 => \^d\(67),
      I3 => \source_protocol_fault3_carry__6\(67),
      I4 => \source_protocol_fault3_carry__6\(66),
      I5 => \^d\(66),
      O => \admitted_frames_reg[7]_0\(2)
    );
\source_protocol_fault3_carry__4_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(65),
      I1 => \source_protocol_fault3_carry__6\(65),
      I2 => \^d\(64),
      I3 => \source_protocol_fault3_carry__6\(64),
      I4 => \source_protocol_fault3_carry__6\(63),
      I5 => \^d\(63),
      O => \admitted_frames_reg[7]_0\(1)
    );
\source_protocol_fault3_carry__4_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(62),
      I1 => \source_protocol_fault3_carry__6\(62),
      I2 => \^d\(61),
      I3 => \source_protocol_fault3_carry__6\(61),
      I4 => \source_protocol_fault3_carry__6\(60),
      I5 => \^d\(60),
      O => \admitted_frames_reg[7]_0\(0)
    );
\source_protocol_fault3_carry__5_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(83),
      I1 => \source_protocol_fault3_carry__6\(83),
      I2 => \^d\(82),
      I3 => \source_protocol_fault3_carry__6\(82),
      I4 => \source_protocol_fault3_carry__6\(81),
      I5 => \^d\(81),
      O => \admitted_frames_reg[19]_0\(3)
    );
\source_protocol_fault3_carry__5_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(80),
      I1 => \source_protocol_fault3_carry__6\(80),
      I2 => \^d\(79),
      I3 => \source_protocol_fault3_carry__6\(79),
      I4 => \source_protocol_fault3_carry__6\(78),
      I5 => \^d\(78),
      O => \admitted_frames_reg[19]_0\(2)
    );
\source_protocol_fault3_carry__5_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(77),
      I1 => \source_protocol_fault3_carry__6\(77),
      I2 => \^d\(76),
      I3 => \source_protocol_fault3_carry__6\(76),
      I4 => \source_protocol_fault3_carry__6\(75),
      I5 => \^d\(75),
      O => \admitted_frames_reg[19]_0\(1)
    );
\source_protocol_fault3_carry__5_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(74),
      I1 => \source_protocol_fault3_carry__6\(74),
      I2 => \^d\(73),
      I3 => \source_protocol_fault3_carry__6\(73),
      I4 => \source_protocol_fault3_carry__6\(72),
      I5 => \^d\(72),
      O => \admitted_frames_reg[19]_0\(0)
    );
\source_protocol_fault3_carry__6_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(95),
      I1 => \source_protocol_fault3_carry__6\(95),
      I2 => \^d\(94),
      I3 => \source_protocol_fault3_carry__6\(94),
      I4 => \source_protocol_fault3_carry__6\(93),
      I5 => \^d\(93),
      O => \admitted_frames_reg[31]_0\(3)
    );
\source_protocol_fault3_carry__6_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(92),
      I1 => \source_protocol_fault3_carry__6\(92),
      I2 => \^d\(91),
      I3 => \source_protocol_fault3_carry__6\(91),
      I4 => \source_protocol_fault3_carry__6\(90),
      I5 => \^d\(90),
      O => \admitted_frames_reg[31]_0\(2)
    );
\source_protocol_fault3_carry__6_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(89),
      I1 => \source_protocol_fault3_carry__6\(89),
      I2 => \^d\(88),
      I3 => \source_protocol_fault3_carry__6\(88),
      I4 => \source_protocol_fault3_carry__6\(87),
      I5 => \^d\(87),
      O => \admitted_frames_reg[31]_0\(1)
    );
\source_protocol_fault3_carry__6_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(86),
      I1 => \source_protocol_fault3_carry__6\(86),
      I2 => \^d\(85),
      I3 => \source_protocol_fault3_carry__6\(85),
      I4 => \source_protocol_fault3_carry__6\(84),
      I5 => \^d\(84),
      O => \admitted_frames_reg[31]_0\(0)
    );
source_protocol_fault3_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(11),
      I1 => \source_protocol_fault3_carry__6\(11),
      I2 => \^d\(10),
      I3 => \source_protocol_fault3_carry__6\(10),
      I4 => \source_protocol_fault3_carry__6\(9),
      I5 => \^d\(9),
      O => S(3)
    );
source_protocol_fault3_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(8),
      I1 => \source_protocol_fault3_carry__6\(8),
      I2 => \^d\(7),
      I3 => \source_protocol_fault3_carry__6\(7),
      I4 => \source_protocol_fault3_carry__6\(6),
      I5 => \^d\(6),
      O => S(2)
    );
source_protocol_fault3_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(5),
      I1 => \source_protocol_fault3_carry__6\(5),
      I2 => \^d\(4),
      I3 => \source_protocol_fault3_carry__6\(4),
      I4 => \source_protocol_fault3_carry__6\(3),
      I5 => \^d\(3),
      O => S(1)
    );
source_protocol_fault3_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^d\(2),
      I1 => \source_protocol_fault3_carry__6\(2),
      I2 => \^d\(1),
      I3 => \source_protocol_fault3_carry__6\(1),
      I4 => \source_protocol_fault3_carry__6\(0),
      I5 => \^d\(0),
      O => S(0)
    );
source_protocol_fault_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFD"
    )
        port map (
      I0 => video_resetn,
      I1 => state(0),
      I2 => state(1),
      I3 => pixel_event_pending,
      I4 => frame_event_pending,
      O => \arststages_ff_reg[2]\
    );
source_quiescent_INST_0: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00010000"
    )
        port map (
      I0 => frame_event_pending,
      I1 => pixel_event_pending,
      I2 => state(1),
      I3 => state(0),
      I4 => video_resetn,
      O => source_quiescent
    );
source_reset: entity work.\c6v_capture_lifecycle_0_xpm_cdc_async_rst__2\
     port map (
      dest_arst => video_resetn,
      dest_clk => vid_io_in_clk,
      src_arst => common_aresetn
    );
vsync_held_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => boundary_fault_i_2_n_0,
      D => vid_vsync,
      Q => vsync_held
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_capture_lifecycle_0_vision_source_budget_cdc is
  port (
    dest_arst : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 0 to 0 );
    closure_held : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 31 downto 0 );
    budget_checked : out STD_LOGIC;
    dma_fault_0 : out STD_LOGIC;
    capture_source_fault : out STD_LOGIC;
    budget_checked_reg_0 : out STD_LOGIC;
    source_closed : out STD_LOGIC;
    closure_held_reg_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    budget_checked_reg_1 : out STD_LOGIC;
    upstream_fault0 : out STD_LOGIC;
    budget_fault : out STD_LOGIC;
    \closed_frame_count_reg[8]_0\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    \closed_frame_count_reg[23]_0\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \closed_frame_count_reg[26]_0\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    \closed_frame_count_reg[6]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    DI : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \closed_frame_count_reg[14]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \closed_frame_count_reg[14]_1\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \closed_frame_count_reg[22]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \closed_frame_count_reg[22]_1\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \closed_frame_count_reg[30]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \closed_frame_count_reg[30]_1\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    closed_pixel_count : out STD_LOGIC_VECTOR ( 63 downto 0 );
    \closed_frame_count_reg[6]_1\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \closed_frame_count_reg[14]_2\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \closed_frame_count_reg[22]_2\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \closed_frame_count_reg[30]_2\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    budget_checked_reg_2 : out STD_LOGIC;
    \held_budget_reg[95]_0\ : out STD_LOGIC_VECTOR ( 95 downto 0 );
    aclk : in STD_LOGIC;
    common_aresetn : in STD_LOGIC;
    vid_io_in_clk : in STD_LOGIC;
    E : in STD_LOGIC_VECTOR ( 0 to 0 );
    S : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \source_protocol_fault3_carry__1_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \source_protocol_fault3_carry__2_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \source_protocol_fault3_carry__3_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \source_protocol_fault3_carry__4_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \source_protocol_fault3_carry__5_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \source_protocol_fault3_carry__6_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    source_protocol_fault_reg_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    dma_fault : in STD_LOGIC;
    capture_fault : in STD_LOGIC;
    cpu_command_fault : in STD_LOGIC;
    owner_fault_causes : in STD_LOGIC_VECTOR ( 0 to 0 );
    CO : in STD_LOGIC_VECTOR ( 0 to 0 );
    frame_credit_ready : in STD_LOGIC;
    closure_held_reg_1 : in STD_LOGIC;
    configuration_locked : in STD_LOGIC;
    capture_source_fault_0 : in STD_LOGIC;
    dest_out : in STD_LOGIC;
    \closure_bad2_carry__1\ : in STD_LOGIC_VECTOR ( 11 downto 0 );
    \out\ : in STD_LOGIC_VECTOR ( 31 downto 0 );
    source_protocol_fault_reg_1 : in STD_LOGIC;
    p_0_in0_in : in STD_LOGIC_VECTOR ( 95 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_capture_lifecycle_0_vision_source_budget_cdc : entity is "vision_source_budget_cdc";
end c6v_capture_lifecycle_0_vision_source_budget_cdc;

architecture STRUCTURE of c6v_capture_lifecycle_0_vision_source_budget_cdc is
  signal \^d\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^q\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^budget_checked\ : STD_LOGIC;
  signal budget_checked_i_1_n_0 : STD_LOGIC;
  signal budget_meta : STD_LOGIC_VECTOR ( 95 downto 0 );
  attribute async_reg : string;
  attribute async_reg of budget_meta : signal is "true";
  attribute shreg_extract : string;
  attribute shreg_extract of budget_meta : signal is "no";
  signal budget_product_ready : STD_LOGIC;
  signal budget_product_ready0 : STD_LOGIC;
  signal budget_sync : STD_LOGIC_VECTOR ( 95 downto 0 );
  attribute async_reg of budget_sync : signal is "true";
  attribute shreg_extract of budget_sync : signal is "no";
  signal \^capture_source_fault\ : STD_LOGIC;
  signal \closed_frame_count[31]_i_2_n_0\ : STD_LOGIC;
  signal \^closed_pixel_count\ : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal \^closure_held\ : STD_LOGIC;
  signal closure_held0 : STD_LOGIC;
  signal \^dest_arst\ : STD_LOGIC;
  signal \expected_pixels0__0_n_100\ : STD_LOGIC;
  signal \expected_pixels0__0_n_101\ : STD_LOGIC;
  signal \expected_pixels0__0_n_102\ : STD_LOGIC;
  signal \expected_pixels0__0_n_103\ : STD_LOGIC;
  signal \expected_pixels0__0_n_104\ : STD_LOGIC;
  signal \expected_pixels0__0_n_105\ : STD_LOGIC;
  signal \expected_pixels0__0_n_58\ : STD_LOGIC;
  signal \expected_pixels0__0_n_59\ : STD_LOGIC;
  signal \expected_pixels0__0_n_60\ : STD_LOGIC;
  signal \expected_pixels0__0_n_61\ : STD_LOGIC;
  signal \expected_pixels0__0_n_62\ : STD_LOGIC;
  signal \expected_pixels0__0_n_63\ : STD_LOGIC;
  signal \expected_pixels0__0_n_64\ : STD_LOGIC;
  signal \expected_pixels0__0_n_65\ : STD_LOGIC;
  signal \expected_pixels0__0_n_66\ : STD_LOGIC;
  signal \expected_pixels0__0_n_67\ : STD_LOGIC;
  signal \expected_pixels0__0_n_68\ : STD_LOGIC;
  signal \expected_pixels0__0_n_69\ : STD_LOGIC;
  signal \expected_pixels0__0_n_70\ : STD_LOGIC;
  signal \expected_pixels0__0_n_71\ : STD_LOGIC;
  signal \expected_pixels0__0_n_72\ : STD_LOGIC;
  signal \expected_pixels0__0_n_73\ : STD_LOGIC;
  signal \expected_pixels0__0_n_74\ : STD_LOGIC;
  signal \expected_pixels0__0_n_75\ : STD_LOGIC;
  signal \expected_pixels0__0_n_76\ : STD_LOGIC;
  signal \expected_pixels0__0_n_77\ : STD_LOGIC;
  signal \expected_pixels0__0_n_78\ : STD_LOGIC;
  signal \expected_pixels0__0_n_79\ : STD_LOGIC;
  signal \expected_pixels0__0_n_80\ : STD_LOGIC;
  signal \expected_pixels0__0_n_81\ : STD_LOGIC;
  signal \expected_pixels0__0_n_82\ : STD_LOGIC;
  signal \expected_pixels0__0_n_83\ : STD_LOGIC;
  signal \expected_pixels0__0_n_84\ : STD_LOGIC;
  signal \expected_pixels0__0_n_85\ : STD_LOGIC;
  signal \expected_pixels0__0_n_86\ : STD_LOGIC;
  signal \expected_pixels0__0_n_87\ : STD_LOGIC;
  signal \expected_pixels0__0_n_88\ : STD_LOGIC;
  signal \expected_pixels0__0_n_89\ : STD_LOGIC;
  signal \expected_pixels0__0_n_90\ : STD_LOGIC;
  signal \expected_pixels0__0_n_91\ : STD_LOGIC;
  signal \expected_pixels0__0_n_92\ : STD_LOGIC;
  signal \expected_pixels0__0_n_93\ : STD_LOGIC;
  signal \expected_pixels0__0_n_94\ : STD_LOGIC;
  signal \expected_pixels0__0_n_95\ : STD_LOGIC;
  signal \expected_pixels0__0_n_96\ : STD_LOGIC;
  signal \expected_pixels0__0_n_97\ : STD_LOGIC;
  signal \expected_pixels0__0_n_98\ : STD_LOGIC;
  signal \expected_pixels0__0_n_99\ : STD_LOGIC;
  signal expected_pixels0_n_100 : STD_LOGIC;
  signal expected_pixels0_n_101 : STD_LOGIC;
  signal expected_pixels0_n_102 : STD_LOGIC;
  signal expected_pixels0_n_103 : STD_LOGIC;
  signal expected_pixels0_n_104 : STD_LOGIC;
  signal expected_pixels0_n_105 : STD_LOGIC;
  signal expected_pixels0_n_106 : STD_LOGIC;
  signal expected_pixels0_n_107 : STD_LOGIC;
  signal expected_pixels0_n_108 : STD_LOGIC;
  signal expected_pixels0_n_109 : STD_LOGIC;
  signal expected_pixels0_n_110 : STD_LOGIC;
  signal expected_pixels0_n_111 : STD_LOGIC;
  signal expected_pixels0_n_112 : STD_LOGIC;
  signal expected_pixels0_n_113 : STD_LOGIC;
  signal expected_pixels0_n_114 : STD_LOGIC;
  signal expected_pixels0_n_115 : STD_LOGIC;
  signal expected_pixels0_n_116 : STD_LOGIC;
  signal expected_pixels0_n_117 : STD_LOGIC;
  signal expected_pixels0_n_118 : STD_LOGIC;
  signal expected_pixels0_n_119 : STD_LOGIC;
  signal expected_pixels0_n_120 : STD_LOGIC;
  signal expected_pixels0_n_121 : STD_LOGIC;
  signal expected_pixels0_n_122 : STD_LOGIC;
  signal expected_pixels0_n_123 : STD_LOGIC;
  signal expected_pixels0_n_124 : STD_LOGIC;
  signal expected_pixels0_n_125 : STD_LOGIC;
  signal expected_pixels0_n_126 : STD_LOGIC;
  signal expected_pixels0_n_127 : STD_LOGIC;
  signal expected_pixels0_n_128 : STD_LOGIC;
  signal expected_pixels0_n_129 : STD_LOGIC;
  signal expected_pixels0_n_130 : STD_LOGIC;
  signal expected_pixels0_n_131 : STD_LOGIC;
  signal expected_pixels0_n_132 : STD_LOGIC;
  signal expected_pixels0_n_133 : STD_LOGIC;
  signal expected_pixels0_n_134 : STD_LOGIC;
  signal expected_pixels0_n_135 : STD_LOGIC;
  signal expected_pixels0_n_136 : STD_LOGIC;
  signal expected_pixels0_n_137 : STD_LOGIC;
  signal expected_pixels0_n_138 : STD_LOGIC;
  signal expected_pixels0_n_139 : STD_LOGIC;
  signal expected_pixels0_n_140 : STD_LOGIC;
  signal expected_pixels0_n_141 : STD_LOGIC;
  signal expected_pixels0_n_142 : STD_LOGIC;
  signal expected_pixels0_n_143 : STD_LOGIC;
  signal expected_pixels0_n_144 : STD_LOGIC;
  signal expected_pixels0_n_145 : STD_LOGIC;
  signal expected_pixels0_n_146 : STD_LOGIC;
  signal expected_pixels0_n_147 : STD_LOGIC;
  signal expected_pixels0_n_148 : STD_LOGIC;
  signal expected_pixels0_n_149 : STD_LOGIC;
  signal expected_pixels0_n_150 : STD_LOGIC;
  signal expected_pixels0_n_151 : STD_LOGIC;
  signal expected_pixels0_n_152 : STD_LOGIC;
  signal expected_pixels0_n_153 : STD_LOGIC;
  signal expected_pixels0_n_24 : STD_LOGIC;
  signal expected_pixels0_n_25 : STD_LOGIC;
  signal expected_pixels0_n_26 : STD_LOGIC;
  signal expected_pixels0_n_27 : STD_LOGIC;
  signal expected_pixels0_n_28 : STD_LOGIC;
  signal expected_pixels0_n_29 : STD_LOGIC;
  signal expected_pixels0_n_30 : STD_LOGIC;
  signal expected_pixels0_n_31 : STD_LOGIC;
  signal expected_pixels0_n_32 : STD_LOGIC;
  signal expected_pixels0_n_33 : STD_LOGIC;
  signal expected_pixels0_n_34 : STD_LOGIC;
  signal expected_pixels0_n_35 : STD_LOGIC;
  signal expected_pixels0_n_36 : STD_LOGIC;
  signal expected_pixels0_n_37 : STD_LOGIC;
  signal expected_pixels0_n_38 : STD_LOGIC;
  signal expected_pixels0_n_39 : STD_LOGIC;
  signal expected_pixels0_n_40 : STD_LOGIC;
  signal expected_pixels0_n_41 : STD_LOGIC;
  signal expected_pixels0_n_42 : STD_LOGIC;
  signal expected_pixels0_n_43 : STD_LOGIC;
  signal expected_pixels0_n_44 : STD_LOGIC;
  signal expected_pixels0_n_45 : STD_LOGIC;
  signal expected_pixels0_n_46 : STD_LOGIC;
  signal expected_pixels0_n_47 : STD_LOGIC;
  signal expected_pixels0_n_48 : STD_LOGIC;
  signal expected_pixels0_n_49 : STD_LOGIC;
  signal expected_pixels0_n_50 : STD_LOGIC;
  signal expected_pixels0_n_51 : STD_LOGIC;
  signal expected_pixels0_n_52 : STD_LOGIC;
  signal expected_pixels0_n_53 : STD_LOGIC;
  signal expected_pixels0_n_58 : STD_LOGIC;
  signal expected_pixels0_n_59 : STD_LOGIC;
  signal expected_pixels0_n_60 : STD_LOGIC;
  signal expected_pixels0_n_61 : STD_LOGIC;
  signal expected_pixels0_n_62 : STD_LOGIC;
  signal expected_pixels0_n_63 : STD_LOGIC;
  signal expected_pixels0_n_64 : STD_LOGIC;
  signal expected_pixels0_n_65 : STD_LOGIC;
  signal expected_pixels0_n_66 : STD_LOGIC;
  signal expected_pixels0_n_67 : STD_LOGIC;
  signal expected_pixels0_n_68 : STD_LOGIC;
  signal expected_pixels0_n_69 : STD_LOGIC;
  signal expected_pixels0_n_70 : STD_LOGIC;
  signal expected_pixels0_n_71 : STD_LOGIC;
  signal expected_pixels0_n_72 : STD_LOGIC;
  signal expected_pixels0_n_73 : STD_LOGIC;
  signal expected_pixels0_n_74 : STD_LOGIC;
  signal expected_pixels0_n_75 : STD_LOGIC;
  signal expected_pixels0_n_76 : STD_LOGIC;
  signal expected_pixels0_n_77 : STD_LOGIC;
  signal expected_pixels0_n_78 : STD_LOGIC;
  signal expected_pixels0_n_79 : STD_LOGIC;
  signal expected_pixels0_n_80 : STD_LOGIC;
  signal expected_pixels0_n_81 : STD_LOGIC;
  signal expected_pixels0_n_82 : STD_LOGIC;
  signal expected_pixels0_n_83 : STD_LOGIC;
  signal expected_pixels0_n_84 : STD_LOGIC;
  signal expected_pixels0_n_85 : STD_LOGIC;
  signal expected_pixels0_n_86 : STD_LOGIC;
  signal expected_pixels0_n_87 : STD_LOGIC;
  signal expected_pixels0_n_88 : STD_LOGIC;
  signal expected_pixels0_n_89 : STD_LOGIC;
  signal expected_pixels0_n_90 : STD_LOGIC;
  signal expected_pixels0_n_91 : STD_LOGIC;
  signal expected_pixels0_n_92 : STD_LOGIC;
  signal expected_pixels0_n_93 : STD_LOGIC;
  signal expected_pixels0_n_94 : STD_LOGIC;
  signal expected_pixels0_n_95 : STD_LOGIC;
  signal expected_pixels0_n_96 : STD_LOGIC;
  signal expected_pixels0_n_97 : STD_LOGIC;
  signal expected_pixels0_n_98 : STD_LOGIC;
  signal expected_pixels0_n_99 : STD_LOGIC;
  signal expected_pixels_reg : STD_LOGIC_VECTOR ( 16 downto 0 );
  signal fault_held : STD_LOGIC;
  signal fault_held0 : STD_LOGIC;
  signal fault_held2 : STD_LOGIC;
  signal \fault_held2_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__0_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__0_n_1\ : STD_LOGIC;
  signal \fault_held2_carry__0_n_2\ : STD_LOGIC;
  signal \fault_held2_carry__0_n_3\ : STD_LOGIC;
  signal \fault_held2_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__1_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__1_n_1\ : STD_LOGIC;
  signal \fault_held2_carry__1_n_2\ : STD_LOGIC;
  signal \fault_held2_carry__1_n_3\ : STD_LOGIC;
  signal \fault_held2_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__2_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__2_n_1\ : STD_LOGIC;
  signal \fault_held2_carry__2_n_2\ : STD_LOGIC;
  signal \fault_held2_carry__2_n_3\ : STD_LOGIC;
  signal \fault_held2_carry__3_i_1_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__3_i_2_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__3_i_3_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__3_i_4_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__3_i_5_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__3_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__3_n_1\ : STD_LOGIC;
  signal \fault_held2_carry__3_n_2\ : STD_LOGIC;
  signal \fault_held2_carry__3_n_3\ : STD_LOGIC;
  signal \fault_held2_carry__4_i_1_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__4_i_2_n_0\ : STD_LOGIC;
  signal \fault_held2_carry__4_n_3\ : STD_LOGIC;
  signal fault_held2_carry_i_1_n_0 : STD_LOGIC;
  signal fault_held2_carry_i_2_n_0 : STD_LOGIC;
  signal fault_held2_carry_i_3_n_0 : STD_LOGIC;
  signal fault_held2_carry_i_4_n_0 : STD_LOGIC;
  signal fault_held2_carry_n_0 : STD_LOGIC;
  signal fault_held2_carry_n_1 : STD_LOGIC;
  signal fault_held2_carry_n_2 : STD_LOGIC;
  signal fault_held2_carry_n_3 : STD_LOGIC;
  signal fault_held4 : STD_LOGIC;
  signal \fault_held4_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__0_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__0_n_1\ : STD_LOGIC;
  signal \fault_held4_carry__0_n_2\ : STD_LOGIC;
  signal \fault_held4_carry__0_n_3\ : STD_LOGIC;
  signal \fault_held4_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__1_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__1_n_1\ : STD_LOGIC;
  signal \fault_held4_carry__1_n_2\ : STD_LOGIC;
  signal \fault_held4_carry__1_n_3\ : STD_LOGIC;
  signal \fault_held4_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__2_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__2_n_1\ : STD_LOGIC;
  signal \fault_held4_carry__2_n_2\ : STD_LOGIC;
  signal \fault_held4_carry__2_n_3\ : STD_LOGIC;
  signal \fault_held4_carry__3_i_1_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__3_i_2_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__3_i_3_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__3_i_4_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__3_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__3_n_1\ : STD_LOGIC;
  signal \fault_held4_carry__3_n_2\ : STD_LOGIC;
  signal \fault_held4_carry__3_n_3\ : STD_LOGIC;
  signal \fault_held4_carry__4_i_1_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__4_i_2_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__4_i_3_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__4_i_4_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__4_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__4_n_1\ : STD_LOGIC;
  signal \fault_held4_carry__4_n_2\ : STD_LOGIC;
  signal \fault_held4_carry__4_n_3\ : STD_LOGIC;
  signal \fault_held4_carry__5_i_1_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__5_i_2_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__5_i_3_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__5_i_4_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__5_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__5_n_1\ : STD_LOGIC;
  signal \fault_held4_carry__5_n_2\ : STD_LOGIC;
  signal \fault_held4_carry__5_n_3\ : STD_LOGIC;
  signal \fault_held4_carry__6_i_1_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__6_i_2_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__6_i_3_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__6_i_4_n_0\ : STD_LOGIC;
  signal \fault_held4_carry__6_n_1\ : STD_LOGIC;
  signal \fault_held4_carry__6_n_2\ : STD_LOGIC;
  signal \fault_held4_carry__6_n_3\ : STD_LOGIC;
  signal fault_held4_carry_i_1_n_0 : STD_LOGIC;
  signal fault_held4_carry_i_2_n_0 : STD_LOGIC;
  signal fault_held4_carry_i_3_n_0 : STD_LOGIC;
  signal fault_held4_carry_i_4_n_0 : STD_LOGIC;
  signal fault_held4_carry_n_0 : STD_LOGIC;
  signal fault_held4_carry_n_1 : STD_LOGIC;
  signal fault_held4_carry_n_2 : STD_LOGIC;
  signal fault_held4_carry_n_3 : STD_LOGIC;
  signal fault_held_i_1_n_0 : STD_LOGIC;
  signal fault_sync : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg of fault_sync : signal is "true";
  attribute shreg_extract of fault_sync : signal is "no";
  signal \^held_budget_reg[95]_0\ : STD_LOGIC_VECTOR ( 95 downto 0 );
  signal reply_sync : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg of reply_sync : signal is "true";
  attribute shreg_extract of reply_sync : signal is "no";
  signal request_held_i_2_n_0 : STD_LOGIC;
  signal request_sync : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg of request_sync : signal is "true";
  attribute shreg_extract of request_sync : signal is "no";
  signal source_protocol_fault : STD_LOGIC;
  signal source_protocol_fault3 : STD_LOGIC;
  signal \source_protocol_fault3_carry__0_n_0\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__0_n_1\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__0_n_2\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__0_n_3\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__1_n_0\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__1_n_1\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__1_n_2\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__1_n_3\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__2_n_0\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__2_n_1\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__2_n_2\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__2_n_3\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__3_n_0\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__3_n_1\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__3_n_2\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__3_n_3\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__4_n_0\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__4_n_1\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__4_n_2\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__4_n_3\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__5_n_0\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__5_n_1\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__5_n_2\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__5_n_3\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__6_n_1\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__6_n_2\ : STD_LOGIC;
  signal \source_protocol_fault3_carry__6_n_3\ : STD_LOGIC;
  signal source_protocol_fault3_carry_n_0 : STD_LOGIC;
  signal source_protocol_fault3_carry_n_1 : STD_LOGIC;
  signal source_protocol_fault3_carry_n_2 : STD_LOGIC;
  signal source_protocol_fault3_carry_n_3 : STD_LOGIC;
  signal \source_protocol_fault_i_1__0_n_0\ : STD_LOGIC;
  signal video_resetn : STD_LOGIC;
  signal NLW_expected_pixels0_CARRYCASCOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_expected_pixels0_MULTSIGNOUT_UNCONNECTED : STD_LOGIC;
  signal NLW_expected_pixels0_OVERFLOW_UNCONNECTED : STD_LOGIC;
  signal NLW_expected_pixels0_PATTERNBDETECT_UNCONNECTED : STD_LOGIC;
  signal NLW_expected_pixels0_PATTERNDETECT_UNCONNECTED : STD_LOGIC;
  signal NLW_expected_pixels0_UNDERFLOW_UNCONNECTED : STD_LOGIC;
  signal NLW_expected_pixels0_BCOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal NLW_expected_pixels0_CARRYOUT_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_expected_pixels0__0_CARRYCASCOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_expected_pixels0__0_MULTSIGNOUT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_expected_pixels0__0_OVERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_expected_pixels0__0_PATTERNBDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_expected_pixels0__0_PATTERNDETECT_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_expected_pixels0__0_UNDERFLOW_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_expected_pixels0__0_ACOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal \NLW_expected_pixels0__0_BCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal \NLW_expected_pixels0__0_CARRYOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_expected_pixels0__0_PCOUT_UNCONNECTED\ : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal NLW_fault_held2_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_fault_held2_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_fault_held2_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_fault_held2_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_fault_held2_carry__3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_fault_held2_carry__4_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_fault_held2_carry__4_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_fault_held4_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_fault_held4_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_fault_held4_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_fault_held4_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_fault_held4_carry__3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_fault_held4_carry__4_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_fault_held4_carry__5_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_fault_held4_carry__6_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_source_protocol_fault3_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_source_protocol_fault3_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_source_protocol_fault3_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_source_protocol_fault3_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_source_protocol_fault3_carry__3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_source_protocol_fault3_carry__4_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_source_protocol_fault3_carry__5_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_source_protocol_fault3_carry__6_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of budget_checked_i_1 : label is "soft_lutpair7";
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \budget_meta_reg[0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \budget_meta_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[10]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[10]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[10]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[11]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[11]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[11]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[12]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[12]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[12]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[13]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[13]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[13]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[14]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[14]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[14]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[15]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[15]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[15]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[16]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[16]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[16]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[17]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[17]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[17]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[18]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[18]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[18]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[19]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[19]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[19]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[1]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[20]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[20]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[20]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[21]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[21]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[21]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[22]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[22]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[22]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[23]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[23]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[23]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[24]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[24]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[24]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[25]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[25]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[25]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[26]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[26]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[26]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[27]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[27]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[27]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[28]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[28]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[28]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[29]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[29]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[29]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[2]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[2]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[30]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[30]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[30]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[31]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[31]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[31]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[32]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[32]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[32]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[33]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[33]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[33]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[34]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[34]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[34]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[35]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[35]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[35]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[36]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[36]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[36]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[37]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[37]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[37]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[38]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[38]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[38]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[39]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[39]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[39]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[3]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[3]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[3]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[40]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[40]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[40]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[41]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[41]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[41]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[42]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[42]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[42]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[43]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[43]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[43]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[44]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[44]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[44]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[45]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[45]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[45]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[46]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[46]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[46]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[47]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[47]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[47]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[48]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[48]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[48]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[49]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[49]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[49]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[4]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[4]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[4]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[50]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[50]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[50]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[51]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[51]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[51]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[52]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[52]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[52]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[53]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[53]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[53]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[54]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[54]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[54]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[55]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[55]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[55]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[56]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[56]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[56]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[57]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[57]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[57]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[58]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[58]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[58]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[59]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[59]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[59]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[5]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[5]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[5]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[60]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[60]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[60]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[61]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[61]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[61]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[62]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[62]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[62]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[63]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[63]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[63]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[64]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[64]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[64]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[65]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[65]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[65]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[66]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[66]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[66]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[67]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[67]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[67]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[68]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[68]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[68]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[69]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[69]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[69]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[6]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[6]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[6]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[70]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[70]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[70]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[71]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[71]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[71]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[72]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[72]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[72]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[73]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[73]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[73]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[74]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[74]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[74]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[75]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[75]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[75]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[76]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[76]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[76]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[77]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[77]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[77]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[78]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[78]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[78]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[79]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[79]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[79]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[7]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[7]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[7]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[80]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[80]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[80]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[81]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[81]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[81]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[82]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[82]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[82]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[83]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[83]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[83]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[84]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[84]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[84]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[85]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[85]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[85]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[86]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[86]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[86]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[87]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[87]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[87]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[88]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[88]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[88]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[89]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[89]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[89]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[8]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[8]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[8]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[90]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[90]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[90]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[91]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[91]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[91]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[92]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[92]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[92]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[93]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[93]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[93]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[94]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[94]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[94]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[95]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[95]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[95]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_meta_reg[9]\ : label is std.standard.true;
  attribute KEEP of \budget_meta_reg[9]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_meta_reg[9]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[10]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[10]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[10]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[11]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[11]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[11]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[12]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[12]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[12]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[13]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[13]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[13]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[14]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[14]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[14]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[15]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[15]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[15]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[16]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[16]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[16]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[17]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[17]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[17]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[18]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[18]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[18]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[19]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[19]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[19]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[20]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[20]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[20]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[21]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[21]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[21]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[22]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[22]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[22]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[23]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[23]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[23]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[24]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[24]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[24]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[25]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[25]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[25]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[26]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[26]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[26]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[27]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[27]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[27]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[28]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[28]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[28]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[29]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[29]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[29]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[2]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[2]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[30]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[30]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[30]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[31]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[31]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[31]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[32]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[32]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[32]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[33]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[33]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[33]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[34]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[34]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[34]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[35]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[35]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[35]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[36]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[36]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[36]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[37]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[37]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[37]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[38]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[38]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[38]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[39]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[39]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[39]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[3]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[3]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[3]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[40]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[40]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[40]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[41]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[41]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[41]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[42]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[42]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[42]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[43]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[43]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[43]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[44]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[44]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[44]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[45]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[45]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[45]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[46]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[46]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[46]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[47]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[47]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[47]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[48]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[48]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[48]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[49]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[49]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[49]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[4]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[4]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[4]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[50]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[50]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[50]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[51]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[51]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[51]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[52]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[52]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[52]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[53]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[53]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[53]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[54]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[54]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[54]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[55]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[55]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[55]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[56]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[56]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[56]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[57]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[57]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[57]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[58]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[58]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[58]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[59]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[59]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[59]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[5]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[5]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[5]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[60]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[60]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[60]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[61]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[61]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[61]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[62]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[62]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[62]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[63]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[63]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[63]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[64]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[64]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[64]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[65]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[65]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[65]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[66]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[66]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[66]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[67]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[67]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[67]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[68]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[68]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[68]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[69]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[69]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[69]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[6]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[6]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[6]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[70]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[70]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[70]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[71]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[71]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[71]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[72]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[72]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[72]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[73]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[73]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[73]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[74]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[74]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[74]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[75]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[75]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[75]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[76]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[76]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[76]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[77]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[77]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[77]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[78]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[78]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[78]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[79]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[79]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[79]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[7]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[7]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[7]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[80]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[80]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[80]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[81]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[81]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[81]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[82]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[82]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[82]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[83]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[83]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[83]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[84]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[84]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[84]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[85]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[85]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[85]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[86]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[86]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[86]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[87]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[87]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[87]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[88]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[88]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[88]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[89]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[89]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[89]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[8]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[8]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[8]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[90]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[90]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[90]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[91]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[91]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[91]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[92]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[92]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[92]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[93]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[93]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[93]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[94]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[94]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[94]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[95]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[95]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[95]\ : label is "NO";
  attribute ASYNC_REG_boolean of \budget_sync_reg[9]\ : label is std.standard.true;
  attribute KEEP of \budget_sync_reg[9]\ : label is "yes";
  attribute SHREG_EXTRACT of \budget_sync_reg[9]\ : label is "NO";
  attribute SOFT_HLUTNM of closure_held_i_1 : label is "soft_lutpair6";
  attribute METHODOLOGY_DRC_VIOS : string;
  attribute METHODOLOGY_DRC_VIOS of expected_pixels0 : label is "{SYNTH-13 {cell *THIS*}}";
  attribute METHODOLOGY_DRC_VIOS of \expected_pixels0__0\ : label is "{SYNTH-12 {cell *THIS*}}";
  attribute SOFT_HLUTNM of \fault_causes[0]_i_1\ : label is "soft_lutpair4";
  attribute ASYNC_REG_boolean of \fault_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP of \fault_sync_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \fault_sync_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \fault_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \fault_sync_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \fault_sync_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \fault_sync_reg[2]\ : label is std.standard.true;
  attribute KEEP of \fault_sync_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \fault_sync_reg[2]\ : label is "NO";
  attribute SOFT_HLUTNM of \final_frame_count[31]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of frame_credit_ready_INST_0_i_3 : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of owner_fault_INST_0_i_5 : label is "soft_lutpair4";
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
  attribute SOFT_HLUTNM of \producer_slot[1]_i_6\ : label is "soft_lutpair7";
  attribute ASYNC_REG_boolean of \reply_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP of \reply_sync_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \reply_sync_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \reply_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \reply_sync_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \reply_sync_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \reply_sync_reg[2]\ : label is std.standard.true;
  attribute KEEP of \reply_sync_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \reply_sync_reg[2]\ : label is "NO";
  attribute ASYNC_REG_boolean of \request_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP of \request_sync_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \request_sync_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \request_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \request_sync_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \request_sync_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \request_sync_reg[2]\ : label is std.standard.true;
  attribute KEEP of \request_sync_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \request_sync_reg[2]\ : label is "NO";
  attribute SOFT_HLUTNM of source_closed_INST_0 : label is "soft_lutpair5";
  attribute DEF_VAL of video_reset : label is "1'b1";
  attribute DEST_SYNC_FF of video_reset : label is 3;
  attribute INIT_SYNC_FF of video_reset : label is 0;
  attribute INV_DEF_VAL of video_reset : label is "1'b0";
  attribute RST_ACTIVE_HIGH of video_reset : label is 0;
  attribute VERSION of video_reset : label is 0;
  attribute XPM_CDC of video_reset : label is "ASYNC_RST";
  attribute XPM_MODULE of video_reset : label is "TRUE";
begin
  D(0) <= \^d\(0);
  Q(31 downto 0) <= \^q\(31 downto 0);
  budget_checked <= \^budget_checked\;
  capture_source_fault <= \^capture_source_fault\;
  closed_pixel_count(63 downto 0) <= \^closed_pixel_count\(63 downto 0);
  closure_held <= \^closure_held\;
  dest_arst <= \^dest_arst\;
  \held_budget_reg[95]_0\(95 downto 0) <= \^held_budget_reg[95]_0\(95 downto 0);
budget_checked_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => budget_product_ready,
      I1 => \^budget_checked\,
      O => budget_checked_i_1_n_0
    );
budget_checked_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_checked_i_1_n_0,
      Q => \^budget_checked\
    );
budget_fault_INST_0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => \^dest_arst\,
      I1 => fault_held,
      I2 => fault_sync(2),
      O => budget_fault
    );
\budget_meta_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(0),
      Q => budget_meta(0)
    );
\budget_meta_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(10),
      Q => budget_meta(10)
    );
\budget_meta_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(11),
      Q => budget_meta(11)
    );
\budget_meta_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(12),
      Q => budget_meta(12)
    );
\budget_meta_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(13),
      Q => budget_meta(13)
    );
\budget_meta_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(14),
      Q => budget_meta(14)
    );
\budget_meta_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(15),
      Q => budget_meta(15)
    );
\budget_meta_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(16),
      Q => budget_meta(16)
    );
\budget_meta_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(17),
      Q => budget_meta(17)
    );
\budget_meta_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(18),
      Q => budget_meta(18)
    );
\budget_meta_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(19),
      Q => budget_meta(19)
    );
\budget_meta_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(1),
      Q => budget_meta(1)
    );
\budget_meta_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(20),
      Q => budget_meta(20)
    );
\budget_meta_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(21),
      Q => budget_meta(21)
    );
\budget_meta_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(22),
      Q => budget_meta(22)
    );
\budget_meta_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(23),
      Q => budget_meta(23)
    );
\budget_meta_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(24),
      Q => budget_meta(24)
    );
\budget_meta_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(25),
      Q => budget_meta(25)
    );
\budget_meta_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(26),
      Q => budget_meta(26)
    );
\budget_meta_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(27),
      Q => budget_meta(27)
    );
\budget_meta_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(28),
      Q => budget_meta(28)
    );
\budget_meta_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(29),
      Q => budget_meta(29)
    );
\budget_meta_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(2),
      Q => budget_meta(2)
    );
\budget_meta_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(30),
      Q => budget_meta(30)
    );
\budget_meta_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(31),
      Q => budget_meta(31)
    );
\budget_meta_reg[32]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(32),
      Q => budget_meta(32)
    );
\budget_meta_reg[33]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(33),
      Q => budget_meta(33)
    );
\budget_meta_reg[34]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(34),
      Q => budget_meta(34)
    );
\budget_meta_reg[35]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(35),
      Q => budget_meta(35)
    );
\budget_meta_reg[36]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(36),
      Q => budget_meta(36)
    );
\budget_meta_reg[37]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(37),
      Q => budget_meta(37)
    );
\budget_meta_reg[38]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(38),
      Q => budget_meta(38)
    );
\budget_meta_reg[39]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(39),
      Q => budget_meta(39)
    );
\budget_meta_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(3),
      Q => budget_meta(3)
    );
\budget_meta_reg[40]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(40),
      Q => budget_meta(40)
    );
\budget_meta_reg[41]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(41),
      Q => budget_meta(41)
    );
\budget_meta_reg[42]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(42),
      Q => budget_meta(42)
    );
\budget_meta_reg[43]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(43),
      Q => budget_meta(43)
    );
\budget_meta_reg[44]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(44),
      Q => budget_meta(44)
    );
\budget_meta_reg[45]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(45),
      Q => budget_meta(45)
    );
\budget_meta_reg[46]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(46),
      Q => budget_meta(46)
    );
\budget_meta_reg[47]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(47),
      Q => budget_meta(47)
    );
\budget_meta_reg[48]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(48),
      Q => budget_meta(48)
    );
\budget_meta_reg[49]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(49),
      Q => budget_meta(49)
    );
\budget_meta_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(4),
      Q => budget_meta(4)
    );
\budget_meta_reg[50]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(50),
      Q => budget_meta(50)
    );
\budget_meta_reg[51]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(51),
      Q => budget_meta(51)
    );
\budget_meta_reg[52]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(52),
      Q => budget_meta(52)
    );
\budget_meta_reg[53]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(53),
      Q => budget_meta(53)
    );
\budget_meta_reg[54]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(54),
      Q => budget_meta(54)
    );
\budget_meta_reg[55]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(55),
      Q => budget_meta(55)
    );
\budget_meta_reg[56]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(56),
      Q => budget_meta(56)
    );
\budget_meta_reg[57]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(57),
      Q => budget_meta(57)
    );
\budget_meta_reg[58]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(58),
      Q => budget_meta(58)
    );
\budget_meta_reg[59]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(59),
      Q => budget_meta(59)
    );
\budget_meta_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(5),
      Q => budget_meta(5)
    );
\budget_meta_reg[60]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(60),
      Q => budget_meta(60)
    );
\budget_meta_reg[61]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(61),
      Q => budget_meta(61)
    );
\budget_meta_reg[62]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(62),
      Q => budget_meta(62)
    );
\budget_meta_reg[63]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(63),
      Q => budget_meta(63)
    );
\budget_meta_reg[64]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(64),
      Q => budget_meta(64)
    );
\budget_meta_reg[65]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(65),
      Q => budget_meta(65)
    );
\budget_meta_reg[66]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(66),
      Q => budget_meta(66)
    );
\budget_meta_reg[67]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(67),
      Q => budget_meta(67)
    );
\budget_meta_reg[68]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(68),
      Q => budget_meta(68)
    );
\budget_meta_reg[69]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(69),
      Q => budget_meta(69)
    );
\budget_meta_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(6),
      Q => budget_meta(6)
    );
\budget_meta_reg[70]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(70),
      Q => budget_meta(70)
    );
\budget_meta_reg[71]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(71),
      Q => budget_meta(71)
    );
\budget_meta_reg[72]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(72),
      Q => budget_meta(72)
    );
\budget_meta_reg[73]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(73),
      Q => budget_meta(73)
    );
\budget_meta_reg[74]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(74),
      Q => budget_meta(74)
    );
\budget_meta_reg[75]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(75),
      Q => budget_meta(75)
    );
\budget_meta_reg[76]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(76),
      Q => budget_meta(76)
    );
\budget_meta_reg[77]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(77),
      Q => budget_meta(77)
    );
\budget_meta_reg[78]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(78),
      Q => budget_meta(78)
    );
\budget_meta_reg[79]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(79),
      Q => budget_meta(79)
    );
\budget_meta_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(7),
      Q => budget_meta(7)
    );
\budget_meta_reg[80]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(80),
      Q => budget_meta(80)
    );
\budget_meta_reg[81]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(81),
      Q => budget_meta(81)
    );
\budget_meta_reg[82]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(82),
      Q => budget_meta(82)
    );
\budget_meta_reg[83]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(83),
      Q => budget_meta(83)
    );
\budget_meta_reg[84]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(84),
      Q => budget_meta(84)
    );
\budget_meta_reg[85]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(85),
      Q => budget_meta(85)
    );
\budget_meta_reg[86]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(86),
      Q => budget_meta(86)
    );
\budget_meta_reg[87]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(87),
      Q => budget_meta(87)
    );
\budget_meta_reg[88]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(88),
      Q => budget_meta(88)
    );
\budget_meta_reg[89]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(89),
      Q => budget_meta(89)
    );
\budget_meta_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(8),
      Q => budget_meta(8)
    );
\budget_meta_reg[90]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(90),
      Q => budget_meta(90)
    );
\budget_meta_reg[91]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(91),
      Q => budget_meta(91)
    );
\budget_meta_reg[92]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(92),
      Q => budget_meta(92)
    );
\budget_meta_reg[93]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(93),
      Q => budget_meta(93)
    );
\budget_meta_reg[94]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(94),
      Q => budget_meta(94)
    );
\budget_meta_reg[95]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(95),
      Q => budget_meta(95)
    );
\budget_meta_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^held_budget_reg[95]_0\(9),
      Q => budget_meta(9)
    );
budget_product_ready_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => '1',
      Q => budget_product_ready
    );
\budget_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(0),
      Q => budget_sync(0)
    );
\budget_sync_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(10),
      Q => budget_sync(10)
    );
\budget_sync_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(11),
      Q => budget_sync(11)
    );
\budget_sync_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(12),
      Q => budget_sync(12)
    );
\budget_sync_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(13),
      Q => budget_sync(13)
    );
\budget_sync_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(14),
      Q => budget_sync(14)
    );
\budget_sync_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(15),
      Q => budget_sync(15)
    );
\budget_sync_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(16),
      Q => budget_sync(16)
    );
\budget_sync_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(17),
      Q => budget_sync(17)
    );
\budget_sync_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(18),
      Q => budget_sync(18)
    );
\budget_sync_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(19),
      Q => budget_sync(19)
    );
\budget_sync_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(1),
      Q => budget_sync(1)
    );
\budget_sync_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(20),
      Q => budget_sync(20)
    );
\budget_sync_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(21),
      Q => budget_sync(21)
    );
\budget_sync_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(22),
      Q => budget_sync(22)
    );
\budget_sync_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(23),
      Q => budget_sync(23)
    );
\budget_sync_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(24),
      Q => budget_sync(24)
    );
\budget_sync_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(25),
      Q => budget_sync(25)
    );
\budget_sync_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(26),
      Q => budget_sync(26)
    );
\budget_sync_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(27),
      Q => budget_sync(27)
    );
\budget_sync_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(28),
      Q => budget_sync(28)
    );
\budget_sync_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(29),
      Q => budget_sync(29)
    );
\budget_sync_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(2),
      Q => budget_sync(2)
    );
\budget_sync_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(30),
      Q => budget_sync(30)
    );
\budget_sync_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(31),
      Q => budget_sync(31)
    );
\budget_sync_reg[32]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(32),
      Q => budget_sync(32)
    );
\budget_sync_reg[33]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(33),
      Q => budget_sync(33)
    );
\budget_sync_reg[34]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(34),
      Q => budget_sync(34)
    );
\budget_sync_reg[35]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(35),
      Q => budget_sync(35)
    );
\budget_sync_reg[36]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(36),
      Q => budget_sync(36)
    );
\budget_sync_reg[37]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(37),
      Q => budget_sync(37)
    );
\budget_sync_reg[38]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(38),
      Q => budget_sync(38)
    );
\budget_sync_reg[39]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(39),
      Q => budget_sync(39)
    );
\budget_sync_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(3),
      Q => budget_sync(3)
    );
\budget_sync_reg[40]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(40),
      Q => budget_sync(40)
    );
\budget_sync_reg[41]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(41),
      Q => budget_sync(41)
    );
\budget_sync_reg[42]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(42),
      Q => budget_sync(42)
    );
\budget_sync_reg[43]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(43),
      Q => budget_sync(43)
    );
\budget_sync_reg[44]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(44),
      Q => budget_sync(44)
    );
\budget_sync_reg[45]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(45),
      Q => budget_sync(45)
    );
\budget_sync_reg[46]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(46),
      Q => budget_sync(46)
    );
\budget_sync_reg[47]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(47),
      Q => budget_sync(47)
    );
\budget_sync_reg[48]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(48),
      Q => budget_sync(48)
    );
\budget_sync_reg[49]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(49),
      Q => budget_sync(49)
    );
\budget_sync_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(4),
      Q => budget_sync(4)
    );
\budget_sync_reg[50]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(50),
      Q => budget_sync(50)
    );
\budget_sync_reg[51]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(51),
      Q => budget_sync(51)
    );
\budget_sync_reg[52]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(52),
      Q => budget_sync(52)
    );
\budget_sync_reg[53]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(53),
      Q => budget_sync(53)
    );
\budget_sync_reg[54]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(54),
      Q => budget_sync(54)
    );
\budget_sync_reg[55]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(55),
      Q => budget_sync(55)
    );
\budget_sync_reg[56]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(56),
      Q => budget_sync(56)
    );
\budget_sync_reg[57]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(57),
      Q => budget_sync(57)
    );
\budget_sync_reg[58]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(58),
      Q => budget_sync(58)
    );
\budget_sync_reg[59]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(59),
      Q => budget_sync(59)
    );
\budget_sync_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(5),
      Q => budget_sync(5)
    );
\budget_sync_reg[60]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(60),
      Q => budget_sync(60)
    );
\budget_sync_reg[61]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(61),
      Q => budget_sync(61)
    );
\budget_sync_reg[62]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(62),
      Q => budget_sync(62)
    );
\budget_sync_reg[63]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(63),
      Q => budget_sync(63)
    );
\budget_sync_reg[64]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(64),
      Q => budget_sync(64)
    );
\budget_sync_reg[65]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(65),
      Q => budget_sync(65)
    );
\budget_sync_reg[66]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(66),
      Q => budget_sync(66)
    );
\budget_sync_reg[67]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(67),
      Q => budget_sync(67)
    );
\budget_sync_reg[68]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(68),
      Q => budget_sync(68)
    );
\budget_sync_reg[69]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(69),
      Q => budget_sync(69)
    );
\budget_sync_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(6),
      Q => budget_sync(6)
    );
\budget_sync_reg[70]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(70),
      Q => budget_sync(70)
    );
\budget_sync_reg[71]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(71),
      Q => budget_sync(71)
    );
\budget_sync_reg[72]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(72),
      Q => budget_sync(72)
    );
\budget_sync_reg[73]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(73),
      Q => budget_sync(73)
    );
\budget_sync_reg[74]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(74),
      Q => budget_sync(74)
    );
\budget_sync_reg[75]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(75),
      Q => budget_sync(75)
    );
\budget_sync_reg[76]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(76),
      Q => budget_sync(76)
    );
\budget_sync_reg[77]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(77),
      Q => budget_sync(77)
    );
\budget_sync_reg[78]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(78),
      Q => budget_sync(78)
    );
\budget_sync_reg[79]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(79),
      Q => budget_sync(79)
    );
\budget_sync_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(7),
      Q => budget_sync(7)
    );
\budget_sync_reg[80]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(80),
      Q => budget_sync(80)
    );
\budget_sync_reg[81]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(81),
      Q => budget_sync(81)
    );
\budget_sync_reg[82]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(82),
      Q => budget_sync(82)
    );
\budget_sync_reg[83]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(83),
      Q => budget_sync(83)
    );
\budget_sync_reg[84]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(84),
      Q => budget_sync(84)
    );
\budget_sync_reg[85]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(85),
      Q => budget_sync(85)
    );
\budget_sync_reg[86]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(86),
      Q => budget_sync(86)
    );
\budget_sync_reg[87]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(87),
      Q => budget_sync(87)
    );
\budget_sync_reg[88]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(88),
      Q => budget_sync(88)
    );
\budget_sync_reg[89]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(89),
      Q => budget_sync(89)
    );
\budget_sync_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(8),
      Q => budget_sync(8)
    );
\budget_sync_reg[90]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(90),
      Q => budget_sync(90)
    );
\budget_sync_reg[91]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(91),
      Q => budget_sync(91)
    );
\budget_sync_reg[92]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(92),
      Q => budget_sync(92)
    );
\budget_sync_reg[93]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(93),
      Q => budget_sync(93)
    );
\budget_sync_reg[94]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(94),
      Q => budget_sync(94)
    );
\budget_sync_reg[95]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(95),
      Q => budget_sync(95)
    );
\budget_sync_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_meta(9),
      Q => budget_sync(9)
    );
capture_source_fault_INST_0: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFEEEA"
    )
        port map (
      I0 => capture_source_fault_0,
      I1 => \^dest_arst\,
      I2 => fault_held,
      I3 => fault_sync(2),
      I4 => dest_out,
      O => \^capture_source_fault\
    );
\closed_frame_count[31]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => request_sync(2),
      I1 => \^closure_held\,
      O => closure_held0
    );
\closed_frame_count[31]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^dest_arst\,
      O => \closed_frame_count[31]_i_2_n_0\
    );
\closed_frame_count_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(64),
      Q => \^q\(0)
    );
\closed_frame_count_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(74),
      Q => \^q\(10)
    );
\closed_frame_count_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(75),
      Q => \^q\(11)
    );
\closed_frame_count_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(76),
      Q => \^q\(12)
    );
\closed_frame_count_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(77),
      Q => \^q\(13)
    );
\closed_frame_count_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(78),
      Q => \^q\(14)
    );
\closed_frame_count_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(79),
      Q => \^q\(15)
    );
\closed_frame_count_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(80),
      Q => \^q\(16)
    );
\closed_frame_count_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(81),
      Q => \^q\(17)
    );
\closed_frame_count_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(82),
      Q => \^q\(18)
    );
\closed_frame_count_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(83),
      Q => \^q\(19)
    );
\closed_frame_count_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(65),
      Q => \^q\(1)
    );
\closed_frame_count_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(84),
      Q => \^q\(20)
    );
\closed_frame_count_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(85),
      Q => \^q\(21)
    );
\closed_frame_count_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(86),
      Q => \^q\(22)
    );
\closed_frame_count_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(87),
      Q => \^q\(23)
    );
\closed_frame_count_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(88),
      Q => \^q\(24)
    );
\closed_frame_count_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(89),
      Q => \^q\(25)
    );
\closed_frame_count_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(90),
      Q => \^q\(26)
    );
\closed_frame_count_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(91),
      Q => \^q\(27)
    );
\closed_frame_count_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(92),
      Q => \^q\(28)
    );
\closed_frame_count_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(93),
      Q => \^q\(29)
    );
\closed_frame_count_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(66),
      Q => \^q\(2)
    );
\closed_frame_count_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(94),
      Q => \^q\(30)
    );
\closed_frame_count_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(95),
      Q => \^q\(31)
    );
\closed_frame_count_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(67),
      Q => \^q\(3)
    );
\closed_frame_count_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(68),
      Q => \^q\(4)
    );
\closed_frame_count_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(69),
      Q => \^q\(5)
    );
\closed_frame_count_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(70),
      Q => \^q\(6)
    );
\closed_frame_count_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(71),
      Q => \^q\(7)
    );
\closed_frame_count_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(72),
      Q => \^q\(8)
    );
\closed_frame_count_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(73),
      Q => \^q\(9)
    );
\closed_pixel_count_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(0),
      Q => \^closed_pixel_count\(0)
    );
\closed_pixel_count_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(10),
      Q => \^closed_pixel_count\(10)
    );
\closed_pixel_count_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(11),
      Q => \^closed_pixel_count\(11)
    );
\closed_pixel_count_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(12),
      Q => \^closed_pixel_count\(12)
    );
\closed_pixel_count_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(13),
      Q => \^closed_pixel_count\(13)
    );
\closed_pixel_count_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(14),
      Q => \^closed_pixel_count\(14)
    );
\closed_pixel_count_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(15),
      Q => \^closed_pixel_count\(15)
    );
\closed_pixel_count_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(16),
      Q => \^closed_pixel_count\(16)
    );
\closed_pixel_count_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(17),
      Q => \^closed_pixel_count\(17)
    );
\closed_pixel_count_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(18),
      Q => \^closed_pixel_count\(18)
    );
\closed_pixel_count_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(19),
      Q => \^closed_pixel_count\(19)
    );
\closed_pixel_count_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(1),
      Q => \^closed_pixel_count\(1)
    );
\closed_pixel_count_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(20),
      Q => \^closed_pixel_count\(20)
    );
\closed_pixel_count_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(21),
      Q => \^closed_pixel_count\(21)
    );
\closed_pixel_count_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(22),
      Q => \^closed_pixel_count\(22)
    );
\closed_pixel_count_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(23),
      Q => \^closed_pixel_count\(23)
    );
\closed_pixel_count_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(24),
      Q => \^closed_pixel_count\(24)
    );
\closed_pixel_count_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(25),
      Q => \^closed_pixel_count\(25)
    );
\closed_pixel_count_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(26),
      Q => \^closed_pixel_count\(26)
    );
\closed_pixel_count_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(27),
      Q => \^closed_pixel_count\(27)
    );
\closed_pixel_count_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(28),
      Q => \^closed_pixel_count\(28)
    );
\closed_pixel_count_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(29),
      Q => \^closed_pixel_count\(29)
    );
\closed_pixel_count_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(2),
      Q => \^closed_pixel_count\(2)
    );
\closed_pixel_count_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(30),
      Q => \^closed_pixel_count\(30)
    );
\closed_pixel_count_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(31),
      Q => \^closed_pixel_count\(31)
    );
\closed_pixel_count_reg[32]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(32),
      Q => \^closed_pixel_count\(32)
    );
\closed_pixel_count_reg[33]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(33),
      Q => \^closed_pixel_count\(33)
    );
\closed_pixel_count_reg[34]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(34),
      Q => \^closed_pixel_count\(34)
    );
\closed_pixel_count_reg[35]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(35),
      Q => \^closed_pixel_count\(35)
    );
\closed_pixel_count_reg[36]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(36),
      Q => \^closed_pixel_count\(36)
    );
\closed_pixel_count_reg[37]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(37),
      Q => \^closed_pixel_count\(37)
    );
\closed_pixel_count_reg[38]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(38),
      Q => \^closed_pixel_count\(38)
    );
\closed_pixel_count_reg[39]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(39),
      Q => \^closed_pixel_count\(39)
    );
\closed_pixel_count_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(3),
      Q => \^closed_pixel_count\(3)
    );
\closed_pixel_count_reg[40]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(40),
      Q => \^closed_pixel_count\(40)
    );
\closed_pixel_count_reg[41]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(41),
      Q => \^closed_pixel_count\(41)
    );
\closed_pixel_count_reg[42]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(42),
      Q => \^closed_pixel_count\(42)
    );
\closed_pixel_count_reg[43]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(43),
      Q => \^closed_pixel_count\(43)
    );
\closed_pixel_count_reg[44]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(44),
      Q => \^closed_pixel_count\(44)
    );
\closed_pixel_count_reg[45]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(45),
      Q => \^closed_pixel_count\(45)
    );
\closed_pixel_count_reg[46]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(46),
      Q => \^closed_pixel_count\(46)
    );
\closed_pixel_count_reg[47]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(47),
      Q => \^closed_pixel_count\(47)
    );
\closed_pixel_count_reg[48]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(48),
      Q => \^closed_pixel_count\(48)
    );
\closed_pixel_count_reg[49]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(49),
      Q => \^closed_pixel_count\(49)
    );
\closed_pixel_count_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(4),
      Q => \^closed_pixel_count\(4)
    );
\closed_pixel_count_reg[50]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(50),
      Q => \^closed_pixel_count\(50)
    );
\closed_pixel_count_reg[51]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(51),
      Q => \^closed_pixel_count\(51)
    );
\closed_pixel_count_reg[52]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(52),
      Q => \^closed_pixel_count\(52)
    );
\closed_pixel_count_reg[53]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(53),
      Q => \^closed_pixel_count\(53)
    );
\closed_pixel_count_reg[54]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(54),
      Q => \^closed_pixel_count\(54)
    );
\closed_pixel_count_reg[55]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(55),
      Q => \^closed_pixel_count\(55)
    );
\closed_pixel_count_reg[56]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(56),
      Q => \^closed_pixel_count\(56)
    );
\closed_pixel_count_reg[57]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(57),
      Q => \^closed_pixel_count\(57)
    );
\closed_pixel_count_reg[58]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(58),
      Q => \^closed_pixel_count\(58)
    );
\closed_pixel_count_reg[59]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(59),
      Q => \^closed_pixel_count\(59)
    );
\closed_pixel_count_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(5),
      Q => \^closed_pixel_count\(5)
    );
\closed_pixel_count_reg[60]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(60),
      Q => \^closed_pixel_count\(60)
    );
\closed_pixel_count_reg[61]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(61),
      Q => \^closed_pixel_count\(61)
    );
\closed_pixel_count_reg[62]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(62),
      Q => \^closed_pixel_count\(62)
    );
\closed_pixel_count_reg[63]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(63),
      Q => \^closed_pixel_count\(63)
    );
\closed_pixel_count_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(6),
      Q => \^closed_pixel_count\(6)
    );
\closed_pixel_count_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(7),
      Q => \^closed_pixel_count\(7)
    );
\closed_pixel_count_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(8),
      Q => \^closed_pixel_count\(8)
    );
\closed_pixel_count_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => budget_sync(9),
      Q => \^closed_pixel_count\(9)
    );
\closure_bad1_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(14),
      I1 => \out\(14),
      I2 => \out\(15),
      I3 => \^q\(15),
      O => \closed_frame_count_reg[14]_2\(3)
    );
\closure_bad1_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(12),
      I1 => \out\(12),
      I2 => \out\(13),
      I3 => \^q\(13),
      O => \closed_frame_count_reg[14]_2\(2)
    );
\closure_bad1_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(10),
      I1 => \out\(10),
      I2 => \out\(11),
      I3 => \^q\(11),
      O => \closed_frame_count_reg[14]_2\(1)
    );
\closure_bad1_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(8),
      I1 => \out\(8),
      I2 => \out\(9),
      I3 => \^q\(9),
      O => \closed_frame_count_reg[14]_2\(0)
    );
\closure_bad1_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(22),
      I1 => \out\(22),
      I2 => \out\(23),
      I3 => \^q\(23),
      O => \closed_frame_count_reg[22]_2\(3)
    );
\closure_bad1_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(20),
      I1 => \out\(20),
      I2 => \out\(21),
      I3 => \^q\(21),
      O => \closed_frame_count_reg[22]_2\(2)
    );
\closure_bad1_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(18),
      I1 => \out\(18),
      I2 => \out\(19),
      I3 => \^q\(19),
      O => \closed_frame_count_reg[22]_2\(1)
    );
\closure_bad1_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(16),
      I1 => \out\(16),
      I2 => \out\(17),
      I3 => \^q\(17),
      O => \closed_frame_count_reg[22]_2\(0)
    );
\closure_bad1_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(30),
      I1 => \out\(30),
      I2 => \out\(31),
      I3 => \^q\(31),
      O => \closed_frame_count_reg[30]_2\(3)
    );
\closure_bad1_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(28),
      I1 => \out\(28),
      I2 => \out\(29),
      I3 => \^q\(29),
      O => \closed_frame_count_reg[30]_2\(2)
    );
\closure_bad1_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(26),
      I1 => \out\(26),
      I2 => \out\(27),
      I3 => \^q\(27),
      O => \closed_frame_count_reg[30]_2\(1)
    );
\closure_bad1_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(24),
      I1 => \out\(24),
      I2 => \out\(25),
      I3 => \^q\(25),
      O => \closed_frame_count_reg[30]_2\(0)
    );
closure_bad1_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(6),
      I1 => \out\(6),
      I2 => \out\(7),
      I3 => \^q\(7),
      O => \closed_frame_count_reg[6]_1\(3)
    );
closure_bad1_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(4),
      I1 => \out\(4),
      I2 => \out\(5),
      I3 => \^q\(5),
      O => \closed_frame_count_reg[6]_1\(2)
    );
closure_bad1_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(2),
      I1 => \out\(2),
      I2 => \out\(3),
      I3 => \^q\(3),
      O => \closed_frame_count_reg[6]_1\(1)
    );
closure_bad1_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(0),
      I1 => \out\(0),
      I2 => \out\(1),
      I3 => \^q\(1),
      O => \closed_frame_count_reg[6]_1\(0)
    );
\closure_bad2_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^q\(23),
      I1 => \closure_bad2_carry__1\(8),
      I2 => \^q\(21),
      I3 => \closure_bad2_carry__1\(6),
      I4 => \closure_bad2_carry__1\(7),
      I5 => \^q\(22),
      O => \closed_frame_count_reg[23]_0\(1)
    );
\closure_bad2_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^q\(20),
      I1 => \closure_bad2_carry__1\(5),
      I2 => \^q\(19),
      I3 => \closure_bad2_carry__1\(4),
      I4 => \closure_bad2_carry__1\(3),
      I5 => \^q\(18),
      O => \closed_frame_count_reg[23]_0\(0)
    );
\closure_bad2_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^q\(26),
      I1 => \closure_bad2_carry__1\(11),
      I2 => \^q\(25),
      I3 => \closure_bad2_carry__1\(10),
      I4 => \closure_bad2_carry__1\(9),
      I5 => \^q\(24),
      O => \closed_frame_count_reg[26]_0\(0)
    );
closure_bad2_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^q\(8),
      I1 => \closure_bad2_carry__1\(2),
      I2 => \^q\(7),
      I3 => \closure_bad2_carry__1\(1),
      I4 => \closure_bad2_carry__1\(0),
      I5 => \^q\(6),
      O => \closed_frame_count_reg[8]_0\(0)
    );
closure_held_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF8000"
    )
        port map (
      I0 => \^budget_checked\,
      I1 => \^closure_held\,
      I2 => \^dest_arst\,
      I3 => configuration_locked,
      I4 => closure_held_reg_1,
      O => budget_checked_reg_2
    );
closure_held_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => closure_held0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => '1',
      Q => \^closure_held\
    );
expected_pixels0: unisim.vcomponents.DSP48E1
    generic map(
      ACASCREG => 0,
      ADREG => 1,
      ALUMODEREG => 0,
      AREG => 0,
      AUTORESET_PATDET => "NO_RESET",
      A_INPUT => "DIRECT",
      BCASCREG => 0,
      BREG => 0,
      B_INPUT => "DIRECT",
      CARRYINREG => 0,
      CARRYINSELREG => 0,
      CREG => 1,
      DREG => 1,
      INMODEREG => 0,
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 0,
      PATTERN => X"000000000000",
      PREG => 0,
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_DPORT => false,
      USE_MULT => "MULTIPLY",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48"
    )
        port map (
      A(29 downto 0) => B"000000000011100001000000000000",
      ACIN(29 downto 0) => B"000000000000000000000000000000",
      ACOUT(29) => expected_pixels0_n_24,
      ACOUT(28) => expected_pixels0_n_25,
      ACOUT(27) => expected_pixels0_n_26,
      ACOUT(26) => expected_pixels0_n_27,
      ACOUT(25) => expected_pixels0_n_28,
      ACOUT(24) => expected_pixels0_n_29,
      ACOUT(23) => expected_pixels0_n_30,
      ACOUT(22) => expected_pixels0_n_31,
      ACOUT(21) => expected_pixels0_n_32,
      ACOUT(20) => expected_pixels0_n_33,
      ACOUT(19) => expected_pixels0_n_34,
      ACOUT(18) => expected_pixels0_n_35,
      ACOUT(17) => expected_pixels0_n_36,
      ACOUT(16) => expected_pixels0_n_37,
      ACOUT(15) => expected_pixels0_n_38,
      ACOUT(14) => expected_pixels0_n_39,
      ACOUT(13) => expected_pixels0_n_40,
      ACOUT(12) => expected_pixels0_n_41,
      ACOUT(11) => expected_pixels0_n_42,
      ACOUT(10) => expected_pixels0_n_43,
      ACOUT(9) => expected_pixels0_n_44,
      ACOUT(8) => expected_pixels0_n_45,
      ACOUT(7) => expected_pixels0_n_46,
      ACOUT(6) => expected_pixels0_n_47,
      ACOUT(5) => expected_pixels0_n_48,
      ACOUT(4) => expected_pixels0_n_49,
      ACOUT(3) => expected_pixels0_n_50,
      ACOUT(2) => expected_pixels0_n_51,
      ACOUT(1) => expected_pixels0_n_52,
      ACOUT(0) => expected_pixels0_n_53,
      ALUMODE(3 downto 0) => B"0000",
      B(17) => '0',
      B(16 downto 0) => \^q\(16 downto 0),
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => NLW_expected_pixels0_BCOUT_UNCONNECTED(17 downto 0),
      C(47 downto 0) => B"111111111111111111111111111111111111111111111111",
      CARRYCASCIN => '0',
      CARRYCASCOUT => NLW_expected_pixels0_CARRYCASCOUT_UNCONNECTED,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => NLW_expected_pixels0_CARRYOUT_UNCONNECTED(3 downto 0),
      CEA1 => '0',
      CEA2 => '0',
      CEAD => '0',
      CEALUMODE => '0',
      CEB1 => '0',
      CEB2 => '0',
      CEC => '0',
      CECARRYIN => '0',
      CECTRL => '0',
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => '0',
      CLK => '0',
      D(24 downto 0) => B"0000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => NLW_expected_pixels0_MULTSIGNOUT_UNCONNECTED,
      OPMODE(6 downto 0) => B"0000101",
      OVERFLOW => NLW_expected_pixels0_OVERFLOW_UNCONNECTED,
      P(47) => expected_pixels0_n_58,
      P(46) => expected_pixels0_n_59,
      P(45) => expected_pixels0_n_60,
      P(44) => expected_pixels0_n_61,
      P(43) => expected_pixels0_n_62,
      P(42) => expected_pixels0_n_63,
      P(41) => expected_pixels0_n_64,
      P(40) => expected_pixels0_n_65,
      P(39) => expected_pixels0_n_66,
      P(38) => expected_pixels0_n_67,
      P(37) => expected_pixels0_n_68,
      P(36) => expected_pixels0_n_69,
      P(35) => expected_pixels0_n_70,
      P(34) => expected_pixels0_n_71,
      P(33) => expected_pixels0_n_72,
      P(32) => expected_pixels0_n_73,
      P(31) => expected_pixels0_n_74,
      P(30) => expected_pixels0_n_75,
      P(29) => expected_pixels0_n_76,
      P(28) => expected_pixels0_n_77,
      P(27) => expected_pixels0_n_78,
      P(26) => expected_pixels0_n_79,
      P(25) => expected_pixels0_n_80,
      P(24) => expected_pixels0_n_81,
      P(23) => expected_pixels0_n_82,
      P(22) => expected_pixels0_n_83,
      P(21) => expected_pixels0_n_84,
      P(20) => expected_pixels0_n_85,
      P(19) => expected_pixels0_n_86,
      P(18) => expected_pixels0_n_87,
      P(17) => expected_pixels0_n_88,
      P(16) => expected_pixels0_n_89,
      P(15) => expected_pixels0_n_90,
      P(14) => expected_pixels0_n_91,
      P(13) => expected_pixels0_n_92,
      P(12) => expected_pixels0_n_93,
      P(11) => expected_pixels0_n_94,
      P(10) => expected_pixels0_n_95,
      P(9) => expected_pixels0_n_96,
      P(8) => expected_pixels0_n_97,
      P(7) => expected_pixels0_n_98,
      P(6) => expected_pixels0_n_99,
      P(5) => expected_pixels0_n_100,
      P(4) => expected_pixels0_n_101,
      P(3) => expected_pixels0_n_102,
      P(2) => expected_pixels0_n_103,
      P(1) => expected_pixels0_n_104,
      P(0) => expected_pixels0_n_105,
      PATTERNBDETECT => NLW_expected_pixels0_PATTERNBDETECT_UNCONNECTED,
      PATTERNDETECT => NLW_expected_pixels0_PATTERNDETECT_UNCONNECTED,
      PCIN(47 downto 0) => B"000000000000000000000000000000000000000000000000",
      PCOUT(47) => expected_pixels0_n_106,
      PCOUT(46) => expected_pixels0_n_107,
      PCOUT(45) => expected_pixels0_n_108,
      PCOUT(44) => expected_pixels0_n_109,
      PCOUT(43) => expected_pixels0_n_110,
      PCOUT(42) => expected_pixels0_n_111,
      PCOUT(41) => expected_pixels0_n_112,
      PCOUT(40) => expected_pixels0_n_113,
      PCOUT(39) => expected_pixels0_n_114,
      PCOUT(38) => expected_pixels0_n_115,
      PCOUT(37) => expected_pixels0_n_116,
      PCOUT(36) => expected_pixels0_n_117,
      PCOUT(35) => expected_pixels0_n_118,
      PCOUT(34) => expected_pixels0_n_119,
      PCOUT(33) => expected_pixels0_n_120,
      PCOUT(32) => expected_pixels0_n_121,
      PCOUT(31) => expected_pixels0_n_122,
      PCOUT(30) => expected_pixels0_n_123,
      PCOUT(29) => expected_pixels0_n_124,
      PCOUT(28) => expected_pixels0_n_125,
      PCOUT(27) => expected_pixels0_n_126,
      PCOUT(26) => expected_pixels0_n_127,
      PCOUT(25) => expected_pixels0_n_128,
      PCOUT(24) => expected_pixels0_n_129,
      PCOUT(23) => expected_pixels0_n_130,
      PCOUT(22) => expected_pixels0_n_131,
      PCOUT(21) => expected_pixels0_n_132,
      PCOUT(20) => expected_pixels0_n_133,
      PCOUT(19) => expected_pixels0_n_134,
      PCOUT(18) => expected_pixels0_n_135,
      PCOUT(17) => expected_pixels0_n_136,
      PCOUT(16) => expected_pixels0_n_137,
      PCOUT(15) => expected_pixels0_n_138,
      PCOUT(14) => expected_pixels0_n_139,
      PCOUT(13) => expected_pixels0_n_140,
      PCOUT(12) => expected_pixels0_n_141,
      PCOUT(11) => expected_pixels0_n_142,
      PCOUT(10) => expected_pixels0_n_143,
      PCOUT(9) => expected_pixels0_n_144,
      PCOUT(8) => expected_pixels0_n_145,
      PCOUT(7) => expected_pixels0_n_146,
      PCOUT(6) => expected_pixels0_n_147,
      PCOUT(5) => expected_pixels0_n_148,
      PCOUT(4) => expected_pixels0_n_149,
      PCOUT(3) => expected_pixels0_n_150,
      PCOUT(2) => expected_pixels0_n_151,
      PCOUT(1) => expected_pixels0_n_152,
      PCOUT(0) => expected_pixels0_n_153,
      RSTA => '0',
      RSTALLCARRYIN => '0',
      RSTALUMODE => '0',
      RSTB => '0',
      RSTC => '0',
      RSTCTRL => '0',
      RSTD => '0',
      RSTINMODE => '0',
      RSTM => '0',
      RSTP => '0',
      UNDERFLOW => NLW_expected_pixels0_UNDERFLOW_UNCONNECTED
    );
\expected_pixels0__0\: unisim.vcomponents.DSP48E1
    generic map(
      ACASCREG => 0,
      ADREG => 1,
      ALUMODEREG => 0,
      AREG => 0,
      AUTORESET_PATDET => "NO_RESET",
      A_INPUT => "CASCADE",
      BCASCREG => 0,
      BREG => 0,
      B_INPUT => "DIRECT",
      CARRYINREG => 0,
      CARRYINSELREG => 0,
      CREG => 1,
      DREG => 1,
      INMODEREG => 0,
      MASK => X"3FFFFFFFFFFF",
      MREG => 0,
      OPMODEREG => 0,
      PATTERN => X"000000000000",
      PREG => 1,
      SEL_MASK => "MASK",
      SEL_PATTERN => "PATTERN",
      USE_DPORT => false,
      USE_MULT => "MULTIPLY",
      USE_PATTERN_DETECT => "NO_PATDET",
      USE_SIMD => "ONE48"
    )
        port map (
      A(29 downto 0) => B"000000000000000000000000000000",
      ACIN(29) => expected_pixels0_n_24,
      ACIN(28) => expected_pixels0_n_25,
      ACIN(27) => expected_pixels0_n_26,
      ACIN(26) => expected_pixels0_n_27,
      ACIN(25) => expected_pixels0_n_28,
      ACIN(24) => expected_pixels0_n_29,
      ACIN(23) => expected_pixels0_n_30,
      ACIN(22) => expected_pixels0_n_31,
      ACIN(21) => expected_pixels0_n_32,
      ACIN(20) => expected_pixels0_n_33,
      ACIN(19) => expected_pixels0_n_34,
      ACIN(18) => expected_pixels0_n_35,
      ACIN(17) => expected_pixels0_n_36,
      ACIN(16) => expected_pixels0_n_37,
      ACIN(15) => expected_pixels0_n_38,
      ACIN(14) => expected_pixels0_n_39,
      ACIN(13) => expected_pixels0_n_40,
      ACIN(12) => expected_pixels0_n_41,
      ACIN(11) => expected_pixels0_n_42,
      ACIN(10) => expected_pixels0_n_43,
      ACIN(9) => expected_pixels0_n_44,
      ACIN(8) => expected_pixels0_n_45,
      ACIN(7) => expected_pixels0_n_46,
      ACIN(6) => expected_pixels0_n_47,
      ACIN(5) => expected_pixels0_n_48,
      ACIN(4) => expected_pixels0_n_49,
      ACIN(3) => expected_pixels0_n_50,
      ACIN(2) => expected_pixels0_n_51,
      ACIN(1) => expected_pixels0_n_52,
      ACIN(0) => expected_pixels0_n_53,
      ACOUT(29 downto 0) => \NLW_expected_pixels0__0_ACOUT_UNCONNECTED\(29 downto 0),
      ALUMODE(3 downto 0) => B"0000",
      B(17 downto 15) => B"000",
      B(14 downto 0) => \^q\(31 downto 17),
      BCIN(17 downto 0) => B"000000000000000000",
      BCOUT(17 downto 0) => \NLW_expected_pixels0__0_BCOUT_UNCONNECTED\(17 downto 0),
      C(47 downto 0) => B"111111111111111111111111111111111111111111111111",
      CARRYCASCIN => '0',
      CARRYCASCOUT => \NLW_expected_pixels0__0_CARRYCASCOUT_UNCONNECTED\,
      CARRYIN => '0',
      CARRYINSEL(2 downto 0) => B"000",
      CARRYOUT(3 downto 0) => \NLW_expected_pixels0__0_CARRYOUT_UNCONNECTED\(3 downto 0),
      CEA1 => '0',
      CEA2 => '0',
      CEAD => '0',
      CEALUMODE => '0',
      CEB1 => '0',
      CEB2 => '0',
      CEC => '0',
      CECARRYIN => '0',
      CECTRL => '0',
      CED => '0',
      CEINMODE => '0',
      CEM => '0',
      CEP => budget_product_ready0,
      CLK => aclk,
      D(24 downto 0) => B"0000000000000000000000000",
      INMODE(4 downto 0) => B"00000",
      MULTSIGNIN => '0',
      MULTSIGNOUT => \NLW_expected_pixels0__0_MULTSIGNOUT_UNCONNECTED\,
      OPMODE(6 downto 0) => B"1010101",
      OVERFLOW => \NLW_expected_pixels0__0_OVERFLOW_UNCONNECTED\,
      P(47) => \expected_pixels0__0_n_58\,
      P(46) => \expected_pixels0__0_n_59\,
      P(45) => \expected_pixels0__0_n_60\,
      P(44) => \expected_pixels0__0_n_61\,
      P(43) => \expected_pixels0__0_n_62\,
      P(42) => \expected_pixels0__0_n_63\,
      P(41) => \expected_pixels0__0_n_64\,
      P(40) => \expected_pixels0__0_n_65\,
      P(39) => \expected_pixels0__0_n_66\,
      P(38) => \expected_pixels0__0_n_67\,
      P(37) => \expected_pixels0__0_n_68\,
      P(36) => \expected_pixels0__0_n_69\,
      P(35) => \expected_pixels0__0_n_70\,
      P(34) => \expected_pixels0__0_n_71\,
      P(33) => \expected_pixels0__0_n_72\,
      P(32) => \expected_pixels0__0_n_73\,
      P(31) => \expected_pixels0__0_n_74\,
      P(30) => \expected_pixels0__0_n_75\,
      P(29) => \expected_pixels0__0_n_76\,
      P(28) => \expected_pixels0__0_n_77\,
      P(27) => \expected_pixels0__0_n_78\,
      P(26) => \expected_pixels0__0_n_79\,
      P(25) => \expected_pixels0__0_n_80\,
      P(24) => \expected_pixels0__0_n_81\,
      P(23) => \expected_pixels0__0_n_82\,
      P(22) => \expected_pixels0__0_n_83\,
      P(21) => \expected_pixels0__0_n_84\,
      P(20) => \expected_pixels0__0_n_85\,
      P(19) => \expected_pixels0__0_n_86\,
      P(18) => \expected_pixels0__0_n_87\,
      P(17) => \expected_pixels0__0_n_88\,
      P(16) => \expected_pixels0__0_n_89\,
      P(15) => \expected_pixels0__0_n_90\,
      P(14) => \expected_pixels0__0_n_91\,
      P(13) => \expected_pixels0__0_n_92\,
      P(12) => \expected_pixels0__0_n_93\,
      P(11) => \expected_pixels0__0_n_94\,
      P(10) => \expected_pixels0__0_n_95\,
      P(9) => \expected_pixels0__0_n_96\,
      P(8) => \expected_pixels0__0_n_97\,
      P(7) => \expected_pixels0__0_n_98\,
      P(6) => \expected_pixels0__0_n_99\,
      P(5) => \expected_pixels0__0_n_100\,
      P(4) => \expected_pixels0__0_n_101\,
      P(3) => \expected_pixels0__0_n_102\,
      P(2) => \expected_pixels0__0_n_103\,
      P(1) => \expected_pixels0__0_n_104\,
      P(0) => \expected_pixels0__0_n_105\,
      PATTERNBDETECT => \NLW_expected_pixels0__0_PATTERNBDETECT_UNCONNECTED\,
      PATTERNDETECT => \NLW_expected_pixels0__0_PATTERNDETECT_UNCONNECTED\,
      PCIN(47) => expected_pixels0_n_106,
      PCIN(46) => expected_pixels0_n_107,
      PCIN(45) => expected_pixels0_n_108,
      PCIN(44) => expected_pixels0_n_109,
      PCIN(43) => expected_pixels0_n_110,
      PCIN(42) => expected_pixels0_n_111,
      PCIN(41) => expected_pixels0_n_112,
      PCIN(40) => expected_pixels0_n_113,
      PCIN(39) => expected_pixels0_n_114,
      PCIN(38) => expected_pixels0_n_115,
      PCIN(37) => expected_pixels0_n_116,
      PCIN(36) => expected_pixels0_n_117,
      PCIN(35) => expected_pixels0_n_118,
      PCIN(34) => expected_pixels0_n_119,
      PCIN(33) => expected_pixels0_n_120,
      PCIN(32) => expected_pixels0_n_121,
      PCIN(31) => expected_pixels0_n_122,
      PCIN(30) => expected_pixels0_n_123,
      PCIN(29) => expected_pixels0_n_124,
      PCIN(28) => expected_pixels0_n_125,
      PCIN(27) => expected_pixels0_n_126,
      PCIN(26) => expected_pixels0_n_127,
      PCIN(25) => expected_pixels0_n_128,
      PCIN(24) => expected_pixels0_n_129,
      PCIN(23) => expected_pixels0_n_130,
      PCIN(22) => expected_pixels0_n_131,
      PCIN(21) => expected_pixels0_n_132,
      PCIN(20) => expected_pixels0_n_133,
      PCIN(19) => expected_pixels0_n_134,
      PCIN(18) => expected_pixels0_n_135,
      PCIN(17) => expected_pixels0_n_136,
      PCIN(16) => expected_pixels0_n_137,
      PCIN(15) => expected_pixels0_n_138,
      PCIN(14) => expected_pixels0_n_139,
      PCIN(13) => expected_pixels0_n_140,
      PCIN(12) => expected_pixels0_n_141,
      PCIN(11) => expected_pixels0_n_142,
      PCIN(10) => expected_pixels0_n_143,
      PCIN(9) => expected_pixels0_n_144,
      PCIN(8) => expected_pixels0_n_145,
      PCIN(7) => expected_pixels0_n_146,
      PCIN(6) => expected_pixels0_n_147,
      PCIN(5) => expected_pixels0_n_148,
      PCIN(4) => expected_pixels0_n_149,
      PCIN(3) => expected_pixels0_n_150,
      PCIN(2) => expected_pixels0_n_151,
      PCIN(1) => expected_pixels0_n_152,
      PCIN(0) => expected_pixels0_n_153,
      PCOUT(47 downto 0) => \NLW_expected_pixels0__0_PCOUT_UNCONNECTED\(47 downto 0),
      RSTA => '0',
      RSTALLCARRYIN => '0',
      RSTALUMODE => '0',
      RSTB => '0',
      RSTC => '0',
      RSTCTRL => '0',
      RSTD => '0',
      RSTINMODE => '0',
      RSTM => '0',
      RSTP => '0',
      UNDERFLOW => \NLW_expected_pixels0__0_UNDERFLOW_UNCONNECTED\
    );
\expected_pixels[16]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \^closure_held\,
      I1 => budget_product_ready,
      O => budget_product_ready0
    );
\expected_pixels_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_105,
      Q => expected_pixels_reg(0)
    );
\expected_pixels_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_95,
      Q => expected_pixels_reg(10)
    );
\expected_pixels_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_94,
      Q => expected_pixels_reg(11)
    );
\expected_pixels_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_93,
      Q => expected_pixels_reg(12)
    );
\expected_pixels_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_92,
      Q => expected_pixels_reg(13)
    );
\expected_pixels_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_91,
      Q => expected_pixels_reg(14)
    );
\expected_pixels_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_90,
      Q => expected_pixels_reg(15)
    );
\expected_pixels_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_89,
      Q => expected_pixels_reg(16)
    );
\expected_pixels_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_104,
      Q => expected_pixels_reg(1)
    );
\expected_pixels_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_103,
      Q => expected_pixels_reg(2)
    );
\expected_pixels_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_102,
      Q => expected_pixels_reg(3)
    );
\expected_pixels_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_101,
      Q => expected_pixels_reg(4)
    );
\expected_pixels_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_100,
      Q => expected_pixels_reg(5)
    );
\expected_pixels_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_99,
      Q => expected_pixels_reg(6)
    );
\expected_pixels_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_98,
      Q => expected_pixels_reg(7)
    );
\expected_pixels_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_97,
      Q => expected_pixels_reg(8)
    );
\expected_pixels_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => budget_product_ready0,
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => expected_pixels0_n_96,
      Q => expected_pixels_reg(9)
    );
\fault_causes[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFE"
    )
        port map (
      I0 => dma_fault,
      I1 => capture_fault,
      I2 => cpu_command_fault,
      I3 => \^capture_source_fault\,
      I4 => owner_fault_causes(0),
      O => dma_fault_0
    );
fault_held2_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => fault_held2_carry_n_0,
      CO(2) => fault_held2_carry_n_1,
      CO(1) => fault_held2_carry_n_2,
      CO(0) => fault_held2_carry_n_3,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => NLW_fault_held2_carry_O_UNCONNECTED(3 downto 0),
      S(3) => fault_held2_carry_i_1_n_0,
      S(2) => fault_held2_carry_i_2_n_0,
      S(1) => fault_held2_carry_i_3_n_0,
      S(0) => fault_held2_carry_i_4_n_0
    );
\fault_held2_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => fault_held2_carry_n_0,
      CO(3) => \fault_held2_carry__0_n_0\,
      CO(2) => \fault_held2_carry__0_n_1\,
      CO(1) => \fault_held2_carry__0_n_2\,
      CO(0) => \fault_held2_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_fault_held2_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \fault_held2_carry__0_i_1_n_0\,
      S(2) => \fault_held2_carry__0_i_2_n_0\,
      S(1) => \fault_held2_carry__0_i_3_n_0\,
      S(0) => \fault_held2_carry__0_i_4_n_0\
    );
\fault_held2_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"802A"
    )
        port map (
      I0 => \fault_held2_carry__0_i_5_n_0\,
      I1 => \expected_pixels0__0_n_99\,
      I2 => budget_product_ready,
      I3 => \^closed_pixel_count\(23),
      O => \fault_held2_carry__0_i_1_n_0\
    );
\fault_held2_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0087"
    )
        port map (
      I0 => \expected_pixels0__0_n_102\,
      I1 => budget_product_ready,
      I2 => \^closed_pixel_count\(20),
      I3 => \fault_held2_carry__0_i_6_n_0\,
      O => \fault_held2_carry__0_i_2_n_0\
    );
\fault_held2_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0087"
    )
        port map (
      I0 => \expected_pixels0__0_n_105\,
      I1 => budget_product_ready,
      I2 => \^closed_pixel_count\(17),
      I3 => \fault_held2_carry__0_i_7_n_0\,
      O => \fault_held2_carry__0_i_3_n_0\
    );
\fault_held2_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => expected_pixels_reg(14),
      I1 => \^closed_pixel_count\(14),
      I2 => \^closed_pixel_count\(13),
      I3 => expected_pixels_reg(13),
      I4 => \^closed_pixel_count\(12),
      I5 => expected_pixels_reg(12),
      O => \fault_held2_carry__0_i_4_n_0\
    );
\fault_held2_carry__0_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"90000933"
    )
        port map (
      I0 => \expected_pixels0__0_n_101\,
      I1 => \^closed_pixel_count\(21),
      I2 => \expected_pixels0__0_n_100\,
      I3 => budget_product_ready,
      I4 => \^closed_pixel_count\(22),
      O => \fault_held2_carry__0_i_5_n_0\
    );
\fault_held2_carry__0_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6FFFF6CC"
    )
        port map (
      I0 => \expected_pixels0__0_n_103\,
      I1 => \^closed_pixel_count\(19),
      I2 => \expected_pixels0__0_n_104\,
      I3 => budget_product_ready,
      I4 => \^closed_pixel_count\(18),
      O => \fault_held2_carry__0_i_6_n_0\
    );
\fault_held2_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6FF6"
    )
        port map (
      I0 => expected_pixels_reg(16),
      I1 => \^closed_pixel_count\(16),
      I2 => expected_pixels_reg(15),
      I3 => \^closed_pixel_count\(15),
      O => \fault_held2_carry__0_i_7_n_0\
    );
\fault_held2_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \fault_held2_carry__0_n_0\,
      CO(3) => \fault_held2_carry__1_n_0\,
      CO(2) => \fault_held2_carry__1_n_1\,
      CO(1) => \fault_held2_carry__1_n_2\,
      CO(0) => \fault_held2_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_fault_held2_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \fault_held2_carry__1_i_1_n_0\,
      S(2) => \fault_held2_carry__1_i_2_n_0\,
      S(1) => \fault_held2_carry__1_i_3_n_0\,
      S(0) => \fault_held2_carry__1_i_4_n_0\
    );
\fault_held2_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0087"
    )
        port map (
      I0 => \expected_pixels0__0_n_87\,
      I1 => budget_product_ready,
      I2 => \^closed_pixel_count\(35),
      I3 => \fault_held2_carry__1_i_5_n_0\,
      O => \fault_held2_carry__1_i_1_n_0\
    );
\fault_held2_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0087"
    )
        port map (
      I0 => \expected_pixels0__0_n_90\,
      I1 => budget_product_ready,
      I2 => \^closed_pixel_count\(32),
      I3 => \fault_held2_carry__1_i_6_n_0\,
      O => \fault_held2_carry__1_i_2_n_0\
    );
\fault_held2_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0087"
    )
        port map (
      I0 => \expected_pixels0__0_n_93\,
      I1 => budget_product_ready,
      I2 => \^closed_pixel_count\(29),
      I3 => \fault_held2_carry__1_i_7_n_0\,
      O => \fault_held2_carry__1_i_3_n_0\
    );
\fault_held2_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0087"
    )
        port map (
      I0 => \expected_pixels0__0_n_96\,
      I1 => budget_product_ready,
      I2 => \^closed_pixel_count\(26),
      I3 => \fault_held2_carry__1_i_8_n_0\,
      O => \fault_held2_carry__1_i_4_n_0\
    );
\fault_held2_carry__1_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6FFFF6CC"
    )
        port map (
      I0 => \expected_pixels0__0_n_88\,
      I1 => \^closed_pixel_count\(34),
      I2 => \expected_pixels0__0_n_89\,
      I3 => budget_product_ready,
      I4 => \^closed_pixel_count\(33),
      O => \fault_held2_carry__1_i_5_n_0\
    );
\fault_held2_carry__1_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6FFFF6CC"
    )
        port map (
      I0 => \expected_pixels0__0_n_91\,
      I1 => \^closed_pixel_count\(31),
      I2 => \expected_pixels0__0_n_92\,
      I3 => budget_product_ready,
      I4 => \^closed_pixel_count\(30),
      O => \fault_held2_carry__1_i_6_n_0\
    );
\fault_held2_carry__1_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6FFFF6CC"
    )
        port map (
      I0 => \expected_pixels0__0_n_95\,
      I1 => \^closed_pixel_count\(27),
      I2 => \expected_pixels0__0_n_94\,
      I3 => budget_product_ready,
      I4 => \^closed_pixel_count\(28),
      O => \fault_held2_carry__1_i_7_n_0\
    );
\fault_held2_carry__1_i_8\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6FFFF6CC"
    )
        port map (
      I0 => \expected_pixels0__0_n_97\,
      I1 => \^closed_pixel_count\(25),
      I2 => \expected_pixels0__0_n_98\,
      I3 => budget_product_ready,
      I4 => \^closed_pixel_count\(24),
      O => \fault_held2_carry__1_i_8_n_0\
    );
\fault_held2_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \fault_held2_carry__1_n_0\,
      CO(3) => \fault_held2_carry__2_n_0\,
      CO(2) => \fault_held2_carry__2_n_1\,
      CO(1) => \fault_held2_carry__2_n_2\,
      CO(0) => \fault_held2_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_fault_held2_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \fault_held2_carry__2_i_1_n_0\,
      S(2) => \fault_held2_carry__2_i_2_n_0\,
      S(1) => \fault_held2_carry__2_i_3_n_0\,
      S(0) => \fault_held2_carry__2_i_4_n_0\
    );
\fault_held2_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0087"
    )
        port map (
      I0 => \expected_pixels0__0_n_75\,
      I1 => budget_product_ready,
      I2 => \^closed_pixel_count\(47),
      I3 => \fault_held2_carry__2_i_5_n_0\,
      O => \fault_held2_carry__2_i_1_n_0\
    );
\fault_held2_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"802A"
    )
        port map (
      I0 => \fault_held2_carry__2_i_6_n_0\,
      I1 => \expected_pixels0__0_n_78\,
      I2 => budget_product_ready,
      I3 => \^closed_pixel_count\(44),
      O => \fault_held2_carry__2_i_2_n_0\
    );
\fault_held2_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"802A"
    )
        port map (
      I0 => \fault_held2_carry__2_i_7_n_0\,
      I1 => \expected_pixels0__0_n_81\,
      I2 => budget_product_ready,
      I3 => \^closed_pixel_count\(41),
      O => \fault_held2_carry__2_i_3_n_0\
    );
\fault_held2_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"802A"
    )
        port map (
      I0 => \fault_held2_carry__2_i_8_n_0\,
      I1 => \expected_pixels0__0_n_84\,
      I2 => budget_product_ready,
      I3 => \^closed_pixel_count\(38),
      O => \fault_held2_carry__2_i_4_n_0\
    );
\fault_held2_carry__2_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6FFFF6CC"
    )
        port map (
      I0 => \expected_pixels0__0_n_76\,
      I1 => \^closed_pixel_count\(46),
      I2 => \expected_pixels0__0_n_77\,
      I3 => budget_product_ready,
      I4 => \^closed_pixel_count\(45),
      O => \fault_held2_carry__2_i_5_n_0\
    );
\fault_held2_carry__2_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"90000933"
    )
        port map (
      I0 => \expected_pixels0__0_n_79\,
      I1 => \^closed_pixel_count\(43),
      I2 => \expected_pixels0__0_n_80\,
      I3 => budget_product_ready,
      I4 => \^closed_pixel_count\(42),
      O => \fault_held2_carry__2_i_6_n_0\
    );
\fault_held2_carry__2_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"90000933"
    )
        port map (
      I0 => \expected_pixels0__0_n_82\,
      I1 => \^closed_pixel_count\(40),
      I2 => \expected_pixels0__0_n_83\,
      I3 => budget_product_ready,
      I4 => \^closed_pixel_count\(39),
      O => \fault_held2_carry__2_i_7_n_0\
    );
\fault_held2_carry__2_i_8\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"90000933"
    )
        port map (
      I0 => \expected_pixels0__0_n_85\,
      I1 => \^closed_pixel_count\(37),
      I2 => \expected_pixels0__0_n_86\,
      I3 => budget_product_ready,
      I4 => \^closed_pixel_count\(36),
      O => \fault_held2_carry__2_i_8_n_0\
    );
\fault_held2_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \fault_held2_carry__2_n_0\,
      CO(3) => \fault_held2_carry__3_n_0\,
      CO(2) => \fault_held2_carry__3_n_1\,
      CO(1) => \fault_held2_carry__3_n_2\,
      CO(0) => \fault_held2_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_fault_held2_carry__3_O_UNCONNECTED\(3 downto 0),
      S(3) => \fault_held2_carry__3_i_1_n_0\,
      S(2) => \fault_held2_carry__3_i_2_n_0\,
      S(1) => \fault_held2_carry__3_i_3_n_0\,
      S(0) => \fault_held2_carry__3_i_4_n_0\
    );
\fault_held2_carry__3_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => \^closed_pixel_count\(58),
      I1 => \^closed_pixel_count\(59),
      I2 => \^closed_pixel_count\(57),
      O => \fault_held2_carry__3_i_1_n_0\
    );
\fault_held2_carry__3_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => \^closed_pixel_count\(55),
      I1 => \^closed_pixel_count\(56),
      I2 => \^closed_pixel_count\(54),
      O => \fault_held2_carry__3_i_2_n_0\
    );
\fault_held2_carry__3_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"10000111"
    )
        port map (
      I0 => \^closed_pixel_count\(52),
      I1 => \^closed_pixel_count\(53),
      I2 => \expected_pixels0__0_n_71\,
      I3 => budget_product_ready,
      I4 => \^closed_pixel_count\(51),
      O => \fault_held2_carry__3_i_3_n_0\
    );
\fault_held2_carry__3_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"802A"
    )
        port map (
      I0 => \fault_held2_carry__3_i_5_n_0\,
      I1 => \expected_pixels0__0_n_72\,
      I2 => budget_product_ready,
      I3 => \^closed_pixel_count\(50),
      O => \fault_held2_carry__3_i_4_n_0\
    );
\fault_held2_carry__3_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"90000933"
    )
        port map (
      I0 => \expected_pixels0__0_n_73\,
      I1 => \^closed_pixel_count\(49),
      I2 => \expected_pixels0__0_n_74\,
      I3 => budget_product_ready,
      I4 => \^closed_pixel_count\(48),
      O => \fault_held2_carry__3_i_5_n_0\
    );
\fault_held2_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \fault_held2_carry__3_n_0\,
      CO(3 downto 2) => \NLW_fault_held2_carry__4_CO_UNCONNECTED\(3 downto 2),
      CO(1) => fault_held2,
      CO(0) => \fault_held2_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0011",
      O(3 downto 0) => \NLW_fault_held2_carry__4_O_UNCONNECTED\(3 downto 0),
      S(3 downto 2) => B"00",
      S(1) => \fault_held2_carry__4_i_1_n_0\,
      S(0) => \fault_held2_carry__4_i_2_n_0\
    );
\fault_held2_carry__4_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^closed_pixel_count\(63),
      O => \fault_held2_carry__4_i_1_n_0\
    );
\fault_held2_carry__4_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => \^closed_pixel_count\(61),
      I1 => \^closed_pixel_count\(62),
      I2 => \^closed_pixel_count\(60),
      O => \fault_held2_carry__4_i_2_n_0\
    );
fault_held2_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^closed_pixel_count\(11),
      I1 => expected_pixels_reg(11),
      I2 => \^closed_pixel_count\(9),
      I3 => expected_pixels_reg(9),
      I4 => expected_pixels_reg(10),
      I5 => \^closed_pixel_count\(10),
      O => fault_held2_carry_i_1_n_0
    );
fault_held2_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^closed_pixel_count\(6),
      I1 => expected_pixels_reg(6),
      I2 => \^closed_pixel_count\(7),
      I3 => expected_pixels_reg(7),
      I4 => expected_pixels_reg(8),
      I5 => \^closed_pixel_count\(8),
      O => fault_held2_carry_i_2_n_0
    );
fault_held2_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => expected_pixels_reg(5),
      I1 => \^closed_pixel_count\(5),
      I2 => \^closed_pixel_count\(3),
      I3 => expected_pixels_reg(3),
      I4 => \^closed_pixel_count\(4),
      I5 => expected_pixels_reg(4),
      O => fault_held2_carry_i_3_n_0
    );
fault_held2_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => expected_pixels_reg(2),
      I1 => \^closed_pixel_count\(2),
      I2 => \^closed_pixel_count\(0),
      I3 => expected_pixels_reg(0),
      I4 => \^closed_pixel_count\(1),
      I5 => expected_pixels_reg(1),
      O => fault_held2_carry_i_4_n_0
    );
fault_held4_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => fault_held4_carry_n_0,
      CO(2) => fault_held4_carry_n_1,
      CO(1) => fault_held4_carry_n_2,
      CO(0) => fault_held4_carry_n_3,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => NLW_fault_held4_carry_O_UNCONNECTED(3 downto 0),
      S(3) => fault_held4_carry_i_1_n_0,
      S(2) => fault_held4_carry_i_2_n_0,
      S(1) => fault_held4_carry_i_3_n_0,
      S(0) => fault_held4_carry_i_4_n_0
    );
\fault_held4_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => fault_held4_carry_n_0,
      CO(3) => \fault_held4_carry__0_n_0\,
      CO(2) => \fault_held4_carry__0_n_1\,
      CO(1) => \fault_held4_carry__0_n_2\,
      CO(0) => \fault_held4_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_fault_held4_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \fault_held4_carry__0_i_1_n_0\,
      S(2) => \fault_held4_carry__0_i_2_n_0\,
      S(1) => \fault_held4_carry__0_i_3_n_0\,
      S(0) => \fault_held4_carry__0_i_4_n_0\
    );
\fault_held4_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^closed_pixel_count\(23),
      I1 => budget_sync(23),
      I2 => \^closed_pixel_count\(21),
      I3 => budget_sync(21),
      I4 => budget_sync(22),
      I5 => \^closed_pixel_count\(22),
      O => \fault_held4_carry__0_i_1_n_0\
    );
\fault_held4_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(20),
      I1 => \^closed_pixel_count\(20),
      I2 => \^closed_pixel_count\(18),
      I3 => budget_sync(18),
      I4 => \^closed_pixel_count\(19),
      I5 => budget_sync(19),
      O => \fault_held4_carry__0_i_2_n_0\
    );
\fault_held4_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(17),
      I1 => \^closed_pixel_count\(17),
      I2 => \^closed_pixel_count\(15),
      I3 => budget_sync(15),
      I4 => \^closed_pixel_count\(16),
      I5 => budget_sync(16),
      O => \fault_held4_carry__0_i_3_n_0\
    );
\fault_held4_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(14),
      I1 => \^closed_pixel_count\(14),
      I2 => \^closed_pixel_count\(12),
      I3 => budget_sync(12),
      I4 => \^closed_pixel_count\(13),
      I5 => budget_sync(13),
      O => \fault_held4_carry__0_i_4_n_0\
    );
\fault_held4_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \fault_held4_carry__0_n_0\,
      CO(3) => \fault_held4_carry__1_n_0\,
      CO(2) => \fault_held4_carry__1_n_1\,
      CO(1) => \fault_held4_carry__1_n_2\,
      CO(0) => \fault_held4_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_fault_held4_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \fault_held4_carry__1_i_1_n_0\,
      S(2) => \fault_held4_carry__1_i_2_n_0\,
      S(1) => \fault_held4_carry__1_i_3_n_0\,
      S(0) => \fault_held4_carry__1_i_4_n_0\
    );
\fault_held4_carry__1_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(35),
      I1 => \^closed_pixel_count\(35),
      I2 => \^closed_pixel_count\(33),
      I3 => budget_sync(33),
      I4 => \^closed_pixel_count\(34),
      I5 => budget_sync(34),
      O => \fault_held4_carry__1_i_1_n_0\
    );
\fault_held4_carry__1_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(32),
      I1 => \^closed_pixel_count\(32),
      I2 => \^closed_pixel_count\(31),
      I3 => budget_sync(31),
      I4 => \^closed_pixel_count\(30),
      I5 => budget_sync(30),
      O => \fault_held4_carry__1_i_2_n_0\
    );
\fault_held4_carry__1_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(29),
      I1 => \^closed_pixel_count\(29),
      I2 => \^closed_pixel_count\(28),
      I3 => budget_sync(28),
      I4 => \^closed_pixel_count\(27),
      I5 => budget_sync(27),
      O => \fault_held4_carry__1_i_3_n_0\
    );
\fault_held4_carry__1_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(26),
      I1 => \^closed_pixel_count\(26),
      I2 => \^closed_pixel_count\(24),
      I3 => budget_sync(24),
      I4 => \^closed_pixel_count\(25),
      I5 => budget_sync(25),
      O => \fault_held4_carry__1_i_4_n_0\
    );
\fault_held4_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \fault_held4_carry__1_n_0\,
      CO(3) => \fault_held4_carry__2_n_0\,
      CO(2) => \fault_held4_carry__2_n_1\,
      CO(1) => \fault_held4_carry__2_n_2\,
      CO(0) => \fault_held4_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_fault_held4_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \fault_held4_carry__2_i_1_n_0\,
      S(2) => \fault_held4_carry__2_i_2_n_0\,
      S(1) => \fault_held4_carry__2_i_3_n_0\,
      S(0) => \fault_held4_carry__2_i_4_n_0\
    );
\fault_held4_carry__2_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(47),
      I1 => \^closed_pixel_count\(47),
      I2 => \^closed_pixel_count\(46),
      I3 => budget_sync(46),
      I4 => \^closed_pixel_count\(45),
      I5 => budget_sync(45),
      O => \fault_held4_carry__2_i_1_n_0\
    );
\fault_held4_carry__2_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^closed_pixel_count\(44),
      I1 => budget_sync(44),
      I2 => \^closed_pixel_count\(42),
      I3 => budget_sync(42),
      I4 => budget_sync(43),
      I5 => \^closed_pixel_count\(43),
      O => \fault_held4_carry__2_i_2_n_0\
    );
\fault_held4_carry__2_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^closed_pixel_count\(41),
      I1 => budget_sync(41),
      I2 => \^closed_pixel_count\(39),
      I3 => budget_sync(39),
      I4 => budget_sync(40),
      I5 => \^closed_pixel_count\(40),
      O => \fault_held4_carry__2_i_3_n_0\
    );
\fault_held4_carry__2_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^closed_pixel_count\(38),
      I1 => budget_sync(38),
      I2 => \^closed_pixel_count\(36),
      I3 => budget_sync(36),
      I4 => budget_sync(37),
      I5 => \^closed_pixel_count\(37),
      O => \fault_held4_carry__2_i_4_n_0\
    );
\fault_held4_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \fault_held4_carry__2_n_0\,
      CO(3) => \fault_held4_carry__3_n_0\,
      CO(2) => \fault_held4_carry__3_n_1\,
      CO(1) => \fault_held4_carry__3_n_2\,
      CO(0) => \fault_held4_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_fault_held4_carry__3_O_UNCONNECTED\(3 downto 0),
      S(3) => \fault_held4_carry__3_i_1_n_0\,
      S(2) => \fault_held4_carry__3_i_2_n_0\,
      S(1) => \fault_held4_carry__3_i_3_n_0\,
      S(0) => \fault_held4_carry__3_i_4_n_0\
    );
\fault_held4_carry__3_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(59),
      I1 => \^closed_pixel_count\(59),
      I2 => budget_sync(57),
      I3 => \^closed_pixel_count\(57),
      I4 => \^closed_pixel_count\(58),
      I5 => budget_sync(58),
      O => \fault_held4_carry__3_i_1_n_0\
    );
\fault_held4_carry__3_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(56),
      I1 => \^closed_pixel_count\(56),
      I2 => budget_sync(55),
      I3 => \^closed_pixel_count\(55),
      I4 => \^closed_pixel_count\(54),
      I5 => budget_sync(54),
      O => \fault_held4_carry__3_i_2_n_0\
    );
\fault_held4_carry__3_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(53),
      I1 => \^closed_pixel_count\(53),
      I2 => \^closed_pixel_count\(51),
      I3 => budget_sync(51),
      I4 => \^closed_pixel_count\(52),
      I5 => budget_sync(52),
      O => \fault_held4_carry__3_i_3_n_0\
    );
\fault_held4_carry__3_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^closed_pixel_count\(50),
      I1 => budget_sync(50),
      I2 => \^closed_pixel_count\(48),
      I3 => budget_sync(48),
      I4 => budget_sync(49),
      I5 => \^closed_pixel_count\(49),
      O => \fault_held4_carry__3_i_4_n_0\
    );
\fault_held4_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \fault_held4_carry__3_n_0\,
      CO(3) => \fault_held4_carry__4_n_0\,
      CO(2) => \fault_held4_carry__4_n_1\,
      CO(1) => \fault_held4_carry__4_n_2\,
      CO(0) => \fault_held4_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_fault_held4_carry__4_O_UNCONNECTED\(3 downto 0),
      S(3) => \fault_held4_carry__4_i_1_n_0\,
      S(2) => \fault_held4_carry__4_i_2_n_0\,
      S(1) => \fault_held4_carry__4_i_3_n_0\,
      S(0) => \fault_held4_carry__4_i_4_n_0\
    );
\fault_held4_carry__4_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^q\(5),
      I1 => budget_sync(69),
      I2 => \^q\(6),
      I3 => budget_sync(70),
      I4 => budget_sync(71),
      I5 => \^q\(7),
      O => \fault_held4_carry__4_i_1_n_0\
    );
\fault_held4_carry__4_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(67),
      I1 => \^q\(3),
      I2 => \^q\(4),
      I3 => budget_sync(68),
      I4 => \^q\(2),
      I5 => budget_sync(66),
      O => \fault_held4_carry__4_i_2_n_0\
    );
\fault_held4_carry__4_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(65),
      I1 => \^q\(1),
      I2 => budget_sync(63),
      I3 => \^closed_pixel_count\(63),
      I4 => \^q\(0),
      I5 => budget_sync(64),
      O => \fault_held4_carry__4_i_3_n_0\
    );
\fault_held4_carry__4_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(62),
      I1 => \^closed_pixel_count\(62),
      I2 => budget_sync(60),
      I3 => \^closed_pixel_count\(60),
      I4 => \^closed_pixel_count\(61),
      I5 => budget_sync(61),
      O => \fault_held4_carry__4_i_4_n_0\
    );
\fault_held4_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \fault_held4_carry__4_n_0\,
      CO(3) => \fault_held4_carry__5_n_0\,
      CO(2) => \fault_held4_carry__5_n_1\,
      CO(1) => \fault_held4_carry__5_n_2\,
      CO(0) => \fault_held4_carry__5_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_fault_held4_carry__5_O_UNCONNECTED\(3 downto 0),
      S(3) => \fault_held4_carry__5_i_1_n_0\,
      S(2) => \fault_held4_carry__5_i_2_n_0\,
      S(1) => \fault_held4_carry__5_i_3_n_0\,
      S(0) => \fault_held4_carry__5_i_4_n_0\
    );
\fault_held4_carry__5_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^q\(18),
      I1 => budget_sync(82),
      I2 => \^q\(17),
      I3 => budget_sync(81),
      I4 => budget_sync(83),
      I5 => \^q\(19),
      O => \fault_held4_carry__5_i_1_n_0\
    );
\fault_held4_carry__5_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(80),
      I1 => \^q\(16),
      I2 => \^q\(14),
      I3 => budget_sync(78),
      I4 => \^q\(15),
      I5 => budget_sync(79),
      O => \fault_held4_carry__5_i_2_n_0\
    );
\fault_held4_carry__5_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(76),
      I1 => \^q\(12),
      I2 => \^q\(13),
      I3 => budget_sync(77),
      I4 => \^q\(11),
      I5 => budget_sync(75),
      O => \fault_held4_carry__5_i_3_n_0\
    );
\fault_held4_carry__5_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(74),
      I1 => \^q\(10),
      I2 => \^q\(8),
      I3 => budget_sync(72),
      I4 => \^q\(9),
      I5 => budget_sync(73),
      O => \fault_held4_carry__5_i_4_n_0\
    );
\fault_held4_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \fault_held4_carry__5_n_0\,
      CO(3) => fault_held4,
      CO(2) => \fault_held4_carry__6_n_1\,
      CO(1) => \fault_held4_carry__6_n_2\,
      CO(0) => \fault_held4_carry__6_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_fault_held4_carry__6_O_UNCONNECTED\(3 downto 0),
      S(3) => \fault_held4_carry__6_i_1_n_0\,
      S(2) => \fault_held4_carry__6_i_2_n_0\,
      S(1) => \fault_held4_carry__6_i_3_n_0\,
      S(0) => \fault_held4_carry__6_i_4_n_0\
    );
\fault_held4_carry__6_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^q\(29),
      I1 => budget_sync(93),
      I2 => \^q\(30),
      I3 => budget_sync(94),
      I4 => budget_sync(95),
      I5 => \^q\(31),
      O => \fault_held4_carry__6_i_1_n_0\
    );
\fault_held4_carry__6_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(92),
      I1 => \^q\(28),
      I2 => \^q\(26),
      I3 => budget_sync(90),
      I4 => \^q\(27),
      I5 => budget_sync(91),
      O => \fault_held4_carry__6_i_2_n_0\
    );
\fault_held4_carry__6_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^q\(23),
      I1 => budget_sync(87),
      I2 => \^q\(24),
      I3 => budget_sync(88),
      I4 => budget_sync(89),
      I5 => \^q\(25),
      O => \fault_held4_carry__6_i_3_n_0\
    );
\fault_held4_carry__6_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^q\(22),
      I1 => budget_sync(86),
      I2 => \^q\(20),
      I3 => budget_sync(84),
      I4 => budget_sync(85),
      I5 => \^q\(21),
      O => \fault_held4_carry__6_i_4_n_0\
    );
fault_held4_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^closed_pixel_count\(9),
      I1 => budget_sync(9),
      I2 => \^closed_pixel_count\(10),
      I3 => budget_sync(10),
      I4 => budget_sync(11),
      I5 => \^closed_pixel_count\(11),
      O => fault_held4_carry_i_1_n_0
    );
fault_held4_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \^closed_pixel_count\(8),
      I1 => budget_sync(8),
      I2 => \^closed_pixel_count\(6),
      I3 => budget_sync(6),
      I4 => budget_sync(7),
      I5 => \^closed_pixel_count\(7),
      O => fault_held4_carry_i_2_n_0
    );
fault_held4_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(5),
      I1 => \^closed_pixel_count\(5),
      I2 => \^closed_pixel_count\(3),
      I3 => budget_sync(3),
      I4 => \^closed_pixel_count\(4),
      I5 => budget_sync(4),
      O => fault_held4_carry_i_3_n_0
    );
fault_held4_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => budget_sync(2),
      I1 => \^closed_pixel_count\(2),
      I2 => \^closed_pixel_count\(1),
      I3 => budget_sync(1),
      I4 => \^closed_pixel_count\(0),
      I5 => budget_sync(0),
      O => fault_held4_carry_i_4_n_0
    );
fault_held_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => fault_held0,
      I1 => fault_held,
      O => fault_held_i_1_n_0
    );
fault_held_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFD0D0D0"
    )
        port map (
      I0 => request_sync(2),
      I1 => fault_held4,
      I2 => \^closure_held\,
      I3 => budget_product_ready,
      I4 => fault_held2,
      I5 => fault_sync(2),
      O => fault_held0
    );
fault_held_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => fault_held_i_1_n_0,
      Q => fault_held
    );
\fault_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => source_protocol_fault,
      Q => fault_sync(0)
    );
\fault_sync_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => fault_sync(0),
      Q => fault_sync(1)
    );
\fault_sync_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => fault_sync(1),
      Q => fault_sync(2)
    );
\final_frame_count[31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"40000000"
    )
        port map (
      I0 => closure_held_reg_1,
      I1 => configuration_locked,
      I2 => \^dest_arst\,
      I3 => \^closure_held\,
      I4 => \^budget_checked\,
      O => closure_held_reg_0(0)
    );
frame_credit_ready_INST_0_i_3: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF0080"
    )
        port map (
      I0 => \^budget_checked\,
      I1 => \^closure_held\,
      I2 => \^dest_arst\,
      I3 => CO(0),
      I4 => frame_credit_ready,
      O => budget_checked_reg_0
    );
\grant_ready1_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(14),
      I1 => \out\(14),
      I2 => \out\(15),
      I3 => \^q\(15),
      O => \closed_frame_count_reg[14]_1\(3)
    );
\grant_ready1_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(12),
      I1 => \out\(12),
      I2 => \out\(13),
      I3 => \^q\(13),
      O => \closed_frame_count_reg[14]_1\(2)
    );
\grant_ready1_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(10),
      I1 => \out\(10),
      I2 => \out\(11),
      I3 => \^q\(11),
      O => \closed_frame_count_reg[14]_1\(1)
    );
\grant_ready1_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(8),
      I1 => \out\(8),
      I2 => \out\(9),
      I3 => \^q\(9),
      O => \closed_frame_count_reg[14]_1\(0)
    );
\grant_ready1_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(14),
      I1 => \out\(14),
      I2 => \out\(15),
      I3 => \^q\(15),
      O => \closed_frame_count_reg[14]_0\(3)
    );
\grant_ready1_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(12),
      I1 => \out\(12),
      I2 => \out\(13),
      I3 => \^q\(13),
      O => \closed_frame_count_reg[14]_0\(2)
    );
\grant_ready1_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(10),
      I1 => \out\(10),
      I2 => \out\(11),
      I3 => \^q\(11),
      O => \closed_frame_count_reg[14]_0\(1)
    );
\grant_ready1_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(8),
      I1 => \out\(8),
      I2 => \out\(9),
      I3 => \^q\(9),
      O => \closed_frame_count_reg[14]_0\(0)
    );
\grant_ready1_carry__1_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(22),
      I1 => \out\(22),
      I2 => \out\(23),
      I3 => \^q\(23),
      O => \closed_frame_count_reg[22]_1\(3)
    );
\grant_ready1_carry__1_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(20),
      I1 => \out\(20),
      I2 => \out\(21),
      I3 => \^q\(21),
      O => \closed_frame_count_reg[22]_1\(2)
    );
\grant_ready1_carry__1_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(18),
      I1 => \out\(18),
      I2 => \out\(19),
      I3 => \^q\(19),
      O => \closed_frame_count_reg[22]_1\(1)
    );
\grant_ready1_carry__1_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(16),
      I1 => \out\(16),
      I2 => \out\(17),
      I3 => \^q\(17),
      O => \closed_frame_count_reg[22]_1\(0)
    );
\grant_ready1_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(22),
      I1 => \out\(22),
      I2 => \out\(23),
      I3 => \^q\(23),
      O => \closed_frame_count_reg[22]_0\(3)
    );
\grant_ready1_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(20),
      I1 => \out\(20),
      I2 => \out\(21),
      I3 => \^q\(21),
      O => \closed_frame_count_reg[22]_0\(2)
    );
\grant_ready1_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(18),
      I1 => \out\(18),
      I2 => \out\(19),
      I3 => \^q\(19),
      O => \closed_frame_count_reg[22]_0\(1)
    );
\grant_ready1_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(16),
      I1 => \out\(16),
      I2 => \out\(17),
      I3 => \^q\(17),
      O => \closed_frame_count_reg[22]_0\(0)
    );
\grant_ready1_carry__2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(30),
      I1 => \out\(30),
      I2 => \out\(31),
      I3 => \^q\(31),
      O => \closed_frame_count_reg[30]_1\(3)
    );
\grant_ready1_carry__2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(28),
      I1 => \out\(28),
      I2 => \out\(29),
      I3 => \^q\(29),
      O => \closed_frame_count_reg[30]_1\(2)
    );
\grant_ready1_carry__2_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(26),
      I1 => \out\(26),
      I2 => \out\(27),
      I3 => \^q\(27),
      O => \closed_frame_count_reg[30]_1\(1)
    );
\grant_ready1_carry__2_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(24),
      I1 => \out\(24),
      I2 => \out\(25),
      I3 => \^q\(25),
      O => \closed_frame_count_reg[30]_1\(0)
    );
\grant_ready1_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(30),
      I1 => \out\(30),
      I2 => \out\(31),
      I3 => \^q\(31),
      O => \closed_frame_count_reg[30]_0\(3)
    );
\grant_ready1_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(28),
      I1 => \out\(28),
      I2 => \out\(29),
      I3 => \^q\(29),
      O => \closed_frame_count_reg[30]_0\(2)
    );
\grant_ready1_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(26),
      I1 => \out\(26),
      I2 => \out\(27),
      I3 => \^q\(27),
      O => \closed_frame_count_reg[30]_0\(1)
    );
\grant_ready1_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(24),
      I1 => \out\(24),
      I2 => \out\(25),
      I3 => \^q\(25),
      O => \closed_frame_count_reg[30]_0\(0)
    );
grant_ready1_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(6),
      I1 => \out\(6),
      I2 => \out\(7),
      I3 => \^q\(7),
      O => DI(3)
    );
grant_ready1_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(4),
      I1 => \out\(4),
      I2 => \out\(5),
      I3 => \^q\(5),
      O => DI(2)
    );
grant_ready1_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(2),
      I1 => \out\(2),
      I2 => \out\(3),
      I3 => \^q\(3),
      O => DI(1)
    );
grant_ready1_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2F02"
    )
        port map (
      I0 => \^q\(0),
      I1 => \out\(0),
      I2 => \out\(1),
      I3 => \^q\(1),
      O => DI(0)
    );
grant_ready1_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(6),
      I1 => \out\(6),
      I2 => \out\(7),
      I3 => \^q\(7),
      O => \closed_frame_count_reg[6]_0\(3)
    );
grant_ready1_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(4),
      I1 => \out\(4),
      I2 => \out\(5),
      I3 => \^q\(5),
      O => \closed_frame_count_reg[6]_0\(2)
    );
grant_ready1_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(2),
      I1 => \out\(2),
      I2 => \out\(3),
      I3 => \^q\(3),
      O => \closed_frame_count_reg[6]_0\(1)
    );
grant_ready1_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9009"
    )
        port map (
      I0 => \^q\(0),
      I1 => \out\(0),
      I2 => \out\(1),
      I3 => \^q\(1),
      O => \closed_frame_count_reg[6]_0\(0)
    );
\held_budget_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(0),
      Q => \^held_budget_reg[95]_0\(0)
    );
\held_budget_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(10),
      Q => \^held_budget_reg[95]_0\(10)
    );
\held_budget_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(11),
      Q => \^held_budget_reg[95]_0\(11)
    );
\held_budget_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(12),
      Q => \^held_budget_reg[95]_0\(12)
    );
\held_budget_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(13),
      Q => \^held_budget_reg[95]_0\(13)
    );
\held_budget_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(14),
      Q => \^held_budget_reg[95]_0\(14)
    );
\held_budget_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(15),
      Q => \^held_budget_reg[95]_0\(15)
    );
\held_budget_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(16),
      Q => \^held_budget_reg[95]_0\(16)
    );
\held_budget_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(17),
      Q => \^held_budget_reg[95]_0\(17)
    );
\held_budget_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(18),
      Q => \^held_budget_reg[95]_0\(18)
    );
\held_budget_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(19),
      Q => \^held_budget_reg[95]_0\(19)
    );
\held_budget_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(1),
      Q => \^held_budget_reg[95]_0\(1)
    );
\held_budget_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(20),
      Q => \^held_budget_reg[95]_0\(20)
    );
\held_budget_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(21),
      Q => \^held_budget_reg[95]_0\(21)
    );
\held_budget_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(22),
      Q => \^held_budget_reg[95]_0\(22)
    );
\held_budget_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(23),
      Q => \^held_budget_reg[95]_0\(23)
    );
\held_budget_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(24),
      Q => \^held_budget_reg[95]_0\(24)
    );
\held_budget_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(25),
      Q => \^held_budget_reg[95]_0\(25)
    );
\held_budget_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(26),
      Q => \^held_budget_reg[95]_0\(26)
    );
\held_budget_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(27),
      Q => \^held_budget_reg[95]_0\(27)
    );
\held_budget_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(28),
      Q => \^held_budget_reg[95]_0\(28)
    );
\held_budget_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(29),
      Q => \^held_budget_reg[95]_0\(29)
    );
\held_budget_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(2),
      Q => \^held_budget_reg[95]_0\(2)
    );
\held_budget_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(30),
      Q => \^held_budget_reg[95]_0\(30)
    );
\held_budget_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(31),
      Q => \^held_budget_reg[95]_0\(31)
    );
\held_budget_reg[32]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(32),
      Q => \^held_budget_reg[95]_0\(32)
    );
\held_budget_reg[33]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(33),
      Q => \^held_budget_reg[95]_0\(33)
    );
\held_budget_reg[34]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(34),
      Q => \^held_budget_reg[95]_0\(34)
    );
\held_budget_reg[35]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(35),
      Q => \^held_budget_reg[95]_0\(35)
    );
\held_budget_reg[36]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(36),
      Q => \^held_budget_reg[95]_0\(36)
    );
\held_budget_reg[37]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(37),
      Q => \^held_budget_reg[95]_0\(37)
    );
\held_budget_reg[38]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(38),
      Q => \^held_budget_reg[95]_0\(38)
    );
\held_budget_reg[39]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(39),
      Q => \^held_budget_reg[95]_0\(39)
    );
\held_budget_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(3),
      Q => \^held_budget_reg[95]_0\(3)
    );
\held_budget_reg[40]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(40),
      Q => \^held_budget_reg[95]_0\(40)
    );
\held_budget_reg[41]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(41),
      Q => \^held_budget_reg[95]_0\(41)
    );
\held_budget_reg[42]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(42),
      Q => \^held_budget_reg[95]_0\(42)
    );
\held_budget_reg[43]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(43),
      Q => \^held_budget_reg[95]_0\(43)
    );
\held_budget_reg[44]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(44),
      Q => \^held_budget_reg[95]_0\(44)
    );
\held_budget_reg[45]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(45),
      Q => \^held_budget_reg[95]_0\(45)
    );
\held_budget_reg[46]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(46),
      Q => \^held_budget_reg[95]_0\(46)
    );
\held_budget_reg[47]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(47),
      Q => \^held_budget_reg[95]_0\(47)
    );
\held_budget_reg[48]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(48),
      Q => \^held_budget_reg[95]_0\(48)
    );
\held_budget_reg[49]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(49),
      Q => \^held_budget_reg[95]_0\(49)
    );
\held_budget_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(4),
      Q => \^held_budget_reg[95]_0\(4)
    );
\held_budget_reg[50]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(50),
      Q => \^held_budget_reg[95]_0\(50)
    );
\held_budget_reg[51]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(51),
      Q => \^held_budget_reg[95]_0\(51)
    );
\held_budget_reg[52]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(52),
      Q => \^held_budget_reg[95]_0\(52)
    );
\held_budget_reg[53]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(53),
      Q => \^held_budget_reg[95]_0\(53)
    );
\held_budget_reg[54]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(54),
      Q => \^held_budget_reg[95]_0\(54)
    );
\held_budget_reg[55]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(55),
      Q => \^held_budget_reg[95]_0\(55)
    );
\held_budget_reg[56]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(56),
      Q => \^held_budget_reg[95]_0\(56)
    );
\held_budget_reg[57]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(57),
      Q => \^held_budget_reg[95]_0\(57)
    );
\held_budget_reg[58]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(58),
      Q => \^held_budget_reg[95]_0\(58)
    );
\held_budget_reg[59]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(59),
      Q => \^held_budget_reg[95]_0\(59)
    );
\held_budget_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(5),
      Q => \^held_budget_reg[95]_0\(5)
    );
\held_budget_reg[60]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(60),
      Q => \^held_budget_reg[95]_0\(60)
    );
\held_budget_reg[61]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(61),
      Q => \^held_budget_reg[95]_0\(61)
    );
\held_budget_reg[62]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(62),
      Q => \^held_budget_reg[95]_0\(62)
    );
\held_budget_reg[63]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(63),
      Q => \^held_budget_reg[95]_0\(63)
    );
\held_budget_reg[64]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(64),
      Q => \^held_budget_reg[95]_0\(64)
    );
\held_budget_reg[65]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(65),
      Q => \^held_budget_reg[95]_0\(65)
    );
\held_budget_reg[66]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(66),
      Q => \^held_budget_reg[95]_0\(66)
    );
\held_budget_reg[67]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(67),
      Q => \^held_budget_reg[95]_0\(67)
    );
\held_budget_reg[68]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(68),
      Q => \^held_budget_reg[95]_0\(68)
    );
\held_budget_reg[69]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(69),
      Q => \^held_budget_reg[95]_0\(69)
    );
\held_budget_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(6),
      Q => \^held_budget_reg[95]_0\(6)
    );
\held_budget_reg[70]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(70),
      Q => \^held_budget_reg[95]_0\(70)
    );
\held_budget_reg[71]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(71),
      Q => \^held_budget_reg[95]_0\(71)
    );
\held_budget_reg[72]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(72),
      Q => \^held_budget_reg[95]_0\(72)
    );
\held_budget_reg[73]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(73),
      Q => \^held_budget_reg[95]_0\(73)
    );
\held_budget_reg[74]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(74),
      Q => \^held_budget_reg[95]_0\(74)
    );
\held_budget_reg[75]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(75),
      Q => \^held_budget_reg[95]_0\(75)
    );
\held_budget_reg[76]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(76),
      Q => \^held_budget_reg[95]_0\(76)
    );
\held_budget_reg[77]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(77),
      Q => \^held_budget_reg[95]_0\(77)
    );
\held_budget_reg[78]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(78),
      Q => \^held_budget_reg[95]_0\(78)
    );
\held_budget_reg[79]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(79),
      Q => \^held_budget_reg[95]_0\(79)
    );
\held_budget_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(7),
      Q => \^held_budget_reg[95]_0\(7)
    );
\held_budget_reg[80]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(80),
      Q => \^held_budget_reg[95]_0\(80)
    );
\held_budget_reg[81]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(81),
      Q => \^held_budget_reg[95]_0\(81)
    );
\held_budget_reg[82]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(82),
      Q => \^held_budget_reg[95]_0\(82)
    );
\held_budget_reg[83]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(83),
      Q => \^held_budget_reg[95]_0\(83)
    );
\held_budget_reg[84]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(84),
      Q => \^held_budget_reg[95]_0\(84)
    );
\held_budget_reg[85]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(85),
      Q => \^held_budget_reg[95]_0\(85)
    );
\held_budget_reg[86]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(86),
      Q => \^held_budget_reg[95]_0\(86)
    );
\held_budget_reg[87]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(87),
      Q => \^held_budget_reg[95]_0\(87)
    );
\held_budget_reg[88]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(88),
      Q => \^held_budget_reg[95]_0\(88)
    );
\held_budget_reg[89]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(89),
      Q => \^held_budget_reg[95]_0\(89)
    );
\held_budget_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(8),
      Q => \^held_budget_reg[95]_0\(8)
    );
\held_budget_reg[90]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(90),
      Q => \^held_budget_reg[95]_0\(90)
    );
\held_budget_reg[91]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(91),
      Q => \^held_budget_reg[95]_0\(91)
    );
\held_budget_reg[92]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(92),
      Q => \^held_budget_reg[95]_0\(92)
    );
\held_budget_reg[93]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(93),
      Q => \^held_budget_reg[95]_0\(93)
    );
\held_budget_reg[94]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(94),
      Q => \^held_budget_reg[95]_0\(94)
    );
\held_budget_reg[95]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(95),
      Q => \^held_budget_reg[95]_0\(95)
    );
\held_budget_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => p_0_in0_in(9),
      Q => \^held_budget_reg[95]_0\(9)
    );
owner_fault_INST_0_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \^capture_source_fault\,
      I1 => cpu_command_fault,
      I2 => capture_fault,
      I3 => dma_fault,
      O => upstream_fault0
    );
processing_reset: entity work.\c6v_capture_lifecycle_0_xpm_cdc_async_rst__4\
     port map (
      dest_arst => \^dest_arst\,
      dest_clk => aclk,
      src_arst => common_aresetn
    );
\producer_slot[1]_i_6\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"7F"
    )
        port map (
      I0 => \^budget_checked\,
      I1 => \^closure_held\,
      I2 => \^dest_arst\,
      O => budget_checked_reg_1
    );
\reply_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => request_held_i_2_n_0,
      D => \^closure_held\,
      Q => reply_sync(0)
    );
\reply_sync_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => request_held_i_2_n_0,
      D => reply_sync(0),
      Q => reply_sync(1)
    );
\reply_sync_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => request_held_i_2_n_0,
      D => reply_sync(1),
      Q => reply_sync(2)
    );
request_held_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => video_resetn,
      O => request_held_i_2_n_0
    );
request_held_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => E(0),
      CLR => request_held_i_2_n_0,
      D => '1',
      Q => \^d\(0)
    );
\request_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => \^d\(0),
      Q => request_sync(0)
    );
\request_sync_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => request_sync(0),
      Q => request_sync(1)
    );
\request_sync_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => \closed_frame_count[31]_i_2_n_0\,
      D => request_sync(1),
      Q => request_sync(2)
    );
source_closed_INST_0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^dest_arst\,
      I1 => \^closure_held\,
      I2 => \^budget_checked\,
      O => source_closed
    );
source_protocol_fault3_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => source_protocol_fault3_carry_n_0,
      CO(2) => source_protocol_fault3_carry_n_1,
      CO(1) => source_protocol_fault3_carry_n_2,
      CO(0) => source_protocol_fault3_carry_n_3,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => NLW_source_protocol_fault3_carry_O_UNCONNECTED(3 downto 0),
      S(3 downto 0) => S(3 downto 0)
    );
\source_protocol_fault3_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => source_protocol_fault3_carry_n_0,
      CO(3) => \source_protocol_fault3_carry__0_n_0\,
      CO(2) => \source_protocol_fault3_carry__0_n_1\,
      CO(1) => \source_protocol_fault3_carry__0_n_2\,
      CO(0) => \source_protocol_fault3_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_source_protocol_fault3_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => \source_protocol_fault3_carry__1_0\(3 downto 0)
    );
\source_protocol_fault3_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \source_protocol_fault3_carry__0_n_0\,
      CO(3) => \source_protocol_fault3_carry__1_n_0\,
      CO(2) => \source_protocol_fault3_carry__1_n_1\,
      CO(1) => \source_protocol_fault3_carry__1_n_2\,
      CO(0) => \source_protocol_fault3_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_source_protocol_fault3_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => \source_protocol_fault3_carry__2_0\(3 downto 0)
    );
\source_protocol_fault3_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \source_protocol_fault3_carry__1_n_0\,
      CO(3) => \source_protocol_fault3_carry__2_n_0\,
      CO(2) => \source_protocol_fault3_carry__2_n_1\,
      CO(1) => \source_protocol_fault3_carry__2_n_2\,
      CO(0) => \source_protocol_fault3_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_source_protocol_fault3_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => \source_protocol_fault3_carry__3_0\(3 downto 0)
    );
\source_protocol_fault3_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \source_protocol_fault3_carry__2_n_0\,
      CO(3) => \source_protocol_fault3_carry__3_n_0\,
      CO(2) => \source_protocol_fault3_carry__3_n_1\,
      CO(1) => \source_protocol_fault3_carry__3_n_2\,
      CO(0) => \source_protocol_fault3_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_source_protocol_fault3_carry__3_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => \source_protocol_fault3_carry__4_0\(3 downto 0)
    );
\source_protocol_fault3_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \source_protocol_fault3_carry__3_n_0\,
      CO(3) => \source_protocol_fault3_carry__4_n_0\,
      CO(2) => \source_protocol_fault3_carry__4_n_1\,
      CO(1) => \source_protocol_fault3_carry__4_n_2\,
      CO(0) => \source_protocol_fault3_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_source_protocol_fault3_carry__4_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => \source_protocol_fault3_carry__5_0\(3 downto 0)
    );
\source_protocol_fault3_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \source_protocol_fault3_carry__4_n_0\,
      CO(3) => \source_protocol_fault3_carry__5_n_0\,
      CO(2) => \source_protocol_fault3_carry__5_n_1\,
      CO(1) => \source_protocol_fault3_carry__5_n_2\,
      CO(0) => \source_protocol_fault3_carry__5_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_source_protocol_fault3_carry__5_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => \source_protocol_fault3_carry__6_0\(3 downto 0)
    );
\source_protocol_fault3_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \source_protocol_fault3_carry__5_n_0\,
      CO(3) => source_protocol_fault3,
      CO(2) => \source_protocol_fault3_carry__6_n_1\,
      CO(1) => \source_protocol_fault3_carry__6_n_2\,
      CO(0) => \source_protocol_fault3_carry__6_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"1111",
      O(3 downto 0) => \NLW_source_protocol_fault3_carry__6_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => source_protocol_fault_reg_0(3 downto 0)
    );
\source_protocol_fault_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFCB8"
    )
        port map (
      I0 => source_protocol_fault3,
      I1 => \^d\(0),
      I2 => reply_sync(2),
      I3 => source_protocol_fault_reg_1,
      I4 => source_protocol_fault,
      O => \source_protocol_fault_i_1__0_n_0\
    );
source_protocol_fault_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => request_held_i_2_n_0,
      D => \source_protocol_fault_i_1__0_n_0\,
      Q => source_protocol_fault
    );
video_reset: entity work.\c6v_capture_lifecycle_0_xpm_cdc_async_rst__3\
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
entity c6v_capture_lifecycle_0_vision_source_fault_cdc is
  port (
    capture_aresetn_reg_0 : out STD_LOGIC;
    epoch_sealed : out STD_LOGIC;
    fault_causes : out STD_LOGIC_VECTOR ( 2 downto 0 );
    common_aresetn_0 : out STD_LOGIC;
    capture_aresetn : out STD_LOGIC;
    aclk_underflow_0 : out STD_LOGIC;
    barrier_complete : out STD_LOGIC;
    capture_aresetn_reg_1 : out STD_LOGIC;
    \clean_sync_reg[2]\ : out STD_LOGIC;
    capture_aresetn_reg_2 : out STD_LOGIC;
    common_aresetn : in STD_LOGIC;
    vid_io_in_clk : in STD_LOGIC;
    aclk : in STD_LOGIC;
    epoch_sealed_0 : in STD_LOGIC;
    sealed_held : in STD_LOGIC;
    fault_causes_2_sp_1 : in STD_LOGIC;
    \out\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    capture_fault_held : in STD_LOGIC;
    protocol_fault : in STD_LOGIC;
    control_capture_aresetn : in STD_LOGIC;
    aclk_underflow : in STD_LOGIC;
    \fault_causes[0]\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    sealed_held_reg : in STD_LOGIC_VECTOR ( 0 to 0 );
    D : in STD_LOGIC_VECTOR ( 0 to 0 );
    configuration_locked1 : in STD_LOGIC;
    configuration_locked : in STD_LOGIC;
    video_overflow : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_capture_lifecycle_0_vision_source_fault_cdc : entity is "vision_source_fault_cdc";
end c6v_capture_lifecycle_0_vision_source_fault_cdc;

architecture STRUCTURE of c6v_capture_lifecycle_0_vision_source_fault_cdc is
  signal aclk_resetn : STD_LOGIC;
  signal armed_sync : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg : string;
  attribute async_reg of armed_sync : signal is "true";
  attribute shreg_extract : string;
  attribute shreg_extract of armed_sync : signal is "no";
  signal \^barrier_complete\ : STD_LOGIC;
  signal capture_aresetn_i_1_n_0 : STD_LOGIC;
  signal \^capture_aresetn_reg_0\ : STD_LOGIC;
  signal epoch_sealed_INST_0_i_1_n_0 : STD_LOGIC;
  signal fault_causes_2_sn_1 : STD_LOGIC;
  signal monitor_faults : STD_LOGIC_VECTOR ( 1 to 1 );
  signal overflow_latched : STD_LOGIC;
  signal overflow_latched_i_1_n_0 : STD_LOGIC;
  signal overflow_sync : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg of overflow_sync : signal is "true";
  attribute shreg_extract of overflow_sync : signal is "no";
  signal underflow_latched_i_1_n_0 : STD_LOGIC;
  signal video_armed : STD_LOGIC;
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
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of barrier_complete_INST_0 : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of capture_aresetn_INST_0 : label is "soft_lutpair9";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of capture_aresetn_reg : label is "xilinx.com:signal:reset:1.0 capture_aresetn RST";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of capture_aresetn_reg : label is "POLARITY ACTIVE_LOW";
  attribute SOFT_HLUTNM of configuration_locked_i_1 : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of cpu_held_i_4 : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of epoch_sealed_INST_0 : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of epoch_sealed_INST_0_i_1 : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \fault_causes[1]_INST_0\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \fault_causes[2]_INST_0\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \fault_sync[2]_i_1\ : label is "soft_lutpair10";
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
  attribute SOFT_HLUTNM of underflow_latched_i_1 : label is "soft_lutpair12";
  attribute DEF_VAL of video_reset : label is "1'b1";
  attribute DEST_SYNC_FF of video_reset : label is 3;
  attribute INIT_SYNC_FF of video_reset : label is 0;
  attribute INV_DEF_VAL of video_reset : label is "1'b0";
  attribute RST_ACTIVE_HIGH of video_reset : label is 0;
  attribute VERSION of video_reset : label is 0;
  attribute XPM_CDC of video_reset : label is "ASYNC_RST";
  attribute XPM_MODULE of video_reset : label is "TRUE";
begin
  barrier_complete <= \^barrier_complete\;
  capture_aresetn_reg_0 <= \^capture_aresetn_reg_0\;
  fault_causes_2_sn_1 <= fault_causes_2_sp_1;
\armed_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => capture_aresetn_i_1_n_0,
      D => video_armed,
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
barrier_complete_INST_0: unisim.vcomponents.LUT4
    generic map(
      INIT => X"E000"
    )
        port map (
      I0 => sealed_held_reg(0),
      I1 => \fault_causes[0]\(0),
      I2 => D(0),
      I3 => \^capture_aresetn_reg_0\,
      O => \^barrier_complete\
    );
capture_aresetn_INST_0: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => control_capture_aresetn,
      I1 => \^capture_aresetn_reg_0\,
      O => capture_aresetn
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
      Q => \^capture_aresetn_reg_0\
    );
capture_source_fault_INST_0_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFE0000"
    )
        port map (
      I0 => aclk_underflow,
      I1 => monitor_faults(1),
      I2 => \fault_causes[0]\(0),
      I3 => overflow_sync(2),
      I4 => \^capture_aresetn_reg_0\,
      O => aclk_underflow_0
    );
configuration_locked_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FF40"
    )
        port map (
      I0 => configuration_locked1,
      I1 => \^capture_aresetn_reg_0\,
      I2 => control_capture_aresetn,
      I3 => configuration_locked,
      O => capture_aresetn_reg_2
    );
cpu_held_i_4: unisim.vcomponents.LUT3
    generic map(
      INIT => X"7F"
    )
        port map (
      I0 => common_aresetn,
      I1 => \^capture_aresetn_reg_0\,
      I2 => control_capture_aresetn,
      O => common_aresetn_0
    );
epoch_sealed_INST_0: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => epoch_sealed_INST_0_i_1_n_0,
      I1 => epoch_sealed_0,
      I2 => sealed_held,
      I3 => \^capture_aresetn_reg_0\,
      O => epoch_sealed
    );
epoch_sealed_INST_0_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0001FFFF"
    )
        port map (
      I0 => protocol_fault,
      I1 => capture_fault_held,
      I2 => \out\(0),
      I3 => fault_causes_2_sn_1,
      I4 => \^capture_aresetn_reg_0\,
      O => epoch_sealed_INST_0_i_1_n_0
    );
\fault_causes[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => \^capture_aresetn_reg_0\,
      I1 => overflow_sync(2),
      I2 => \fault_causes[0]\(0),
      O => fault_causes(0)
    );
\fault_causes[1]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => \^capture_aresetn_reg_0\,
      I1 => monitor_faults(1),
      I2 => aclk_underflow,
      O => fault_causes(1)
    );
\fault_causes[2]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AAAAAAA8"
    )
        port map (
      I0 => \^capture_aresetn_reg_0\,
      I1 => fault_causes_2_sn_1,
      I2 => \out\(0),
      I3 => capture_fault_held,
      I4 => protocol_fault,
      O => fault_causes(2)
    );
\fault_sync[2]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^capture_aresetn_reg_0\,
      O => capture_aresetn_reg_1
    );
overflow_latched_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => video_overflow,
      I1 => overflow_latched,
      O => overflow_latched_i_1_n_0
    );
overflow_latched_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => video_armed_i_1_n_0,
      D => overflow_latched_i_1_n_0,
      Q => overflow_latched
    );
\overflow_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => capture_aresetn_i_1_n_0,
      D => overflow_latched,
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
processing_reset: entity work.\c6v_capture_lifecycle_0_xpm_cdc_async_rst__6\
     port map (
      dest_arst => aclk_resetn,
      dest_clk => aclk,
      src_arst => common_aresetn
    );
sealed_held_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF8000"
    )
        port map (
      I0 => sealed_held_reg(0),
      I1 => \^barrier_complete\,
      I2 => epoch_sealed_0,
      I3 => epoch_sealed_INST_0_i_1_n_0,
      I4 => sealed_held,
      O => \clean_sync_reg[2]\
    );
underflow_latched_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => monitor_faults(1),
      I1 => aclk_underflow,
      O => underflow_latched_i_1_n_0
    );
underflow_latched_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => capture_aresetn_i_1_n_0,
      D => underflow_latched_i_1_n_0,
      Q => monitor_faults(1)
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
      Q => video_armed
    );
video_reset: entity work.\c6v_capture_lifecycle_0_xpm_cdc_async_rst__5\
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
entity c6v_capture_lifecycle_0_vision_epoch_fence is
  port (
    capture_aresetn_reg : out STD_LOGIC;
    capture_fault_held : out STD_LOGIC;
    epoch_sealed : out STD_LOGIC;
    fault_causes : out STD_LOGIC_VECTOR ( 2 downto 0 );
    common_aresetn_0 : out STD_LOGIC;
    capture_aresetn : out STD_LOGIC;
    aclk_underflow_0 : out STD_LOGIC;
    barrier_complete : out STD_LOGIC;
    capture_aresetn_reg_0 : out STD_LOGIC;
    common_aresetn : in STD_LOGIC;
    vid_io_in_clk : in STD_LOGIC;
    aclk : in STD_LOGIC;
    capture_fault_held_reg_0 : in STD_LOGIC;
    epoch_sealed_0 : in STD_LOGIC;
    fault_causes_2_sp_1 : in STD_LOGIC;
    control_capture_aresetn : in STD_LOGIC;
    aclk_underflow : in STD_LOGIC;
    video_overflow : in STD_LOGIC;
    reply_clean_reg_0 : in STD_LOGIC;
    configuration_locked1 : in STD_LOGIC;
    configuration_locked : in STD_LOGIC;
    request_held_reg_0 : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_capture_lifecycle_0_vision_epoch_fence : entity is "vision_epoch_fence";
end c6v_capture_lifecycle_0_vision_epoch_fence;

architecture STRUCTURE of c6v_capture_lifecycle_0_vision_epoch_fence is
  signal \^capture_fault_held\ : STD_LOGIC;
  signal clean_sync : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg : string;
  attribute async_reg of clean_sync : signal is "true";
  attribute shreg_extract : string;
  attribute shreg_extract of clean_sync : signal is "no";
  signal fault_causes_2_sn_1 : STD_LOGIC;
  signal fault_sync : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg of fault_sync : signal is "true";
  attribute shreg_extract of fault_sync : signal is "no";
  signal monitor_n_10 : STD_LOGIC;
  signal monitor_n_9 : STD_LOGIC;
  signal overflow_held : STD_LOGIC;
  signal overflow_held_i_1_n_0 : STD_LOGIC;
  signal protocol_fault : STD_LOGIC;
  signal protocol_fault_i_1_n_0 : STD_LOGIC;
  signal protocol_sync : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg of protocol_sync : signal is "true";
  attribute shreg_extract of protocol_sync : signal is "no";
  signal reply_clean : STD_LOGIC;
  signal reply_clean_i_1_n_0 : STD_LOGIC;
  signal reply_fault_i_1_n_0 : STD_LOGIC;
  signal reply_fault_reg_n_0 : STD_LOGIC;
  signal request_held : STD_LOGIC;
  signal \request_held_i_1__0_n_0\ : STD_LOGIC;
  signal request_sync : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute async_reg of request_sync : signal is "true";
  attribute shreg_extract of request_sync : signal is "no";
  signal \request_sync[2]_i_1_n_0\ : STD_LOGIC;
  signal sealed_held : STD_LOGIC;
  signal source_protocol_fault_i_1_n_0 : STD_LOGIC;
  signal source_protocol_fault_reg_n_0 : STD_LOGIC;
  signal video_resetn : STD_LOGIC;
  attribute ASYNC_REG_boolean : boolean;
  attribute ASYNC_REG_boolean of \clean_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP : string;
  attribute KEEP of \clean_sync_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \clean_sync_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \clean_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \clean_sync_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \clean_sync_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \clean_sync_reg[2]\ : label is std.standard.true;
  attribute KEEP of \clean_sync_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \clean_sync_reg[2]\ : label is "NO";
  attribute ASYNC_REG_boolean of \fault_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP of \fault_sync_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \fault_sync_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \fault_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \fault_sync_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \fault_sync_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \fault_sync_reg[2]\ : label is std.standard.true;
  attribute KEEP of \fault_sync_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \fault_sync_reg[2]\ : label is "NO";
  attribute ASYNC_REG_boolean of \protocol_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP of \protocol_sync_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \protocol_sync_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \protocol_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \protocol_sync_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \protocol_sync_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \protocol_sync_reg[2]\ : label is std.standard.true;
  attribute KEEP of \protocol_sync_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \protocol_sync_reg[2]\ : label is "NO";
  attribute ASYNC_REG_boolean of \request_sync_reg[0]\ : label is std.standard.true;
  attribute KEEP of \request_sync_reg[0]\ : label is "yes";
  attribute SHREG_EXTRACT of \request_sync_reg[0]\ : label is "NO";
  attribute ASYNC_REG_boolean of \request_sync_reg[1]\ : label is std.standard.true;
  attribute KEEP of \request_sync_reg[1]\ : label is "yes";
  attribute SHREG_EXTRACT of \request_sync_reg[1]\ : label is "NO";
  attribute ASYNC_REG_boolean of \request_sync_reg[2]\ : label is std.standard.true;
  attribute KEEP of \request_sync_reg[2]\ : label is "yes";
  attribute SHREG_EXTRACT of \request_sync_reg[2]\ : label is "NO";
  attribute DEF_VAL : string;
  attribute DEF_VAL of source_reset : label is "1'b1";
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of source_reset : label is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of source_reset : label is 0;
  attribute INV_DEF_VAL : string;
  attribute INV_DEF_VAL of source_reset : label is "1'b0";
  attribute RST_ACTIVE_HIGH : integer;
  attribute RST_ACTIVE_HIGH of source_reset : label is 0;
  attribute VERSION : integer;
  attribute VERSION of source_reset : label is 0;
  attribute XPM_CDC : string;
  attribute XPM_CDC of source_reset : label is "ASYNC_RST";
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of source_reset : label is "TRUE";
begin
  capture_fault_held <= \^capture_fault_held\;
  fault_causes_2_sn_1 <= fault_causes_2_sp_1;
capture_fault_held_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => monitor_n_9,
      D => capture_fault_held_reg_0,
      Q => \^capture_fault_held\
    );
\clean_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => monitor_n_9,
      D => reply_clean,
      Q => clean_sync(0)
    );
\clean_sync_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => monitor_n_9,
      D => clean_sync(0),
      Q => clean_sync(1)
    );
\clean_sync_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => monitor_n_9,
      D => clean_sync(1),
      Q => clean_sync(2)
    );
\fault_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => monitor_n_9,
      D => reply_fault_reg_n_0,
      Q => fault_sync(0)
    );
\fault_sync_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => monitor_n_9,
      D => fault_sync(0),
      Q => fault_sync(1)
    );
\fault_sync_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => monitor_n_9,
      D => fault_sync(1),
      Q => fault_sync(2)
    );
monitor: entity work.c6v_capture_lifecycle_0_vision_source_fault_cdc
     port map (
      D(0) => request_held,
      aclk => aclk,
      aclk_underflow => aclk_underflow,
      aclk_underflow_0 => aclk_underflow_0,
      barrier_complete => barrier_complete,
      capture_aresetn => capture_aresetn,
      capture_aresetn_reg_0 => capture_aresetn_reg,
      capture_aresetn_reg_1 => monitor_n_9,
      capture_aresetn_reg_2 => capture_aresetn_reg_0,
      capture_fault_held => \^capture_fault_held\,
      \clean_sync_reg[2]\ => monitor_n_10,
      common_aresetn => common_aresetn,
      common_aresetn_0 => common_aresetn_0,
      configuration_locked => configuration_locked,
      configuration_locked1 => configuration_locked1,
      control_capture_aresetn => control_capture_aresetn,
      epoch_sealed => epoch_sealed,
      epoch_sealed_0 => epoch_sealed_0,
      fault_causes(2 downto 0) => fault_causes(2 downto 0),
      \fault_causes[0]\(0) => fault_sync(2),
      fault_causes_2_sp_1 => fault_causes_2_sn_1,
      \out\(0) => protocol_sync(2),
      protocol_fault => protocol_fault,
      sealed_held => sealed_held,
      sealed_held_reg(0) => clean_sync(2),
      vid_io_in_clk => vid_io_in_clk,
      video_overflow => video_overflow
    );
overflow_held_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => video_overflow,
      I1 => overflow_held,
      O => overflow_held_i_1_n_0
    );
overflow_held_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \request_sync[2]_i_1_n_0\,
      D => overflow_held_i_1_n_0,
      Q => overflow_held
    );
protocol_fault_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF88F8"
    )
        port map (
      I0 => fault_sync(2),
      I1 => clean_sync(2),
      I2 => sealed_held,
      I3 => epoch_sealed_0,
      I4 => protocol_fault,
      O => protocol_fault_i_1_n_0
    );
protocol_fault_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => monitor_n_9,
      D => protocol_fault_i_1_n_0,
      Q => protocol_fault
    );
\protocol_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => monitor_n_9,
      D => source_protocol_fault_reg_n_0,
      Q => protocol_sync(0)
    );
\protocol_sync_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => monitor_n_9,
      D => protocol_sync(0),
      Q => protocol_sync(1)
    );
\protocol_sync_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => monitor_n_9,
      D => protocol_sync(1),
      Q => protocol_sync(2)
    );
reply_clean_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCCCCCCCCCCCCCDC"
    )
        port map (
      I0 => reply_fault_reg_n_0,
      I1 => reply_clean,
      I2 => request_sync(2),
      I3 => video_overflow,
      I4 => overflow_held,
      I5 => reply_clean_reg_0,
      O => reply_clean_i_1_n_0
    );
reply_clean_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \request_sync[2]_i_1_n_0\,
      D => reply_clean_i_1_n_0,
      Q => reply_clean
    );
reply_fault_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAABBBAAAAA"
    )
        port map (
      I0 => reply_fault_reg_n_0,
      I1 => reply_clean,
      I2 => video_overflow,
      I3 => overflow_held,
      I4 => request_sync(2),
      I5 => reply_clean_reg_0,
      O => reply_fault_i_1_n_0
    );
reply_fault_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \request_sync[2]_i_1_n_0\,
      D => reply_fault_i_1_n_0,
      Q => reply_fault_reg_n_0
    );
\request_held_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => request_held_reg_0(0),
      I1 => request_held,
      O => \request_held_i_1__0_n_0\
    );
request_held_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => monitor_n_9,
      D => \request_held_i_1__0_n_0\,
      Q => request_held
    );
\request_sync[2]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => video_resetn,
      O => \request_sync[2]_i_1_n_0\
    );
\request_sync_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \request_sync[2]_i_1_n_0\,
      D => request_held,
      Q => request_sync(0)
    );
\request_sync_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \request_sync[2]_i_1_n_0\,
      D => request_sync(0),
      Q => request_sync(1)
    );
\request_sync_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \request_sync[2]_i_1_n_0\,
      D => request_sync(1),
      Q => request_sync(2)
    );
sealed_held_reg: unisim.vcomponents.FDCE
     port map (
      C => aclk,
      CE => '1',
      CLR => monitor_n_9,
      D => monitor_n_10,
      Q => sealed_held
    );
source_protocol_fault_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFE0"
    )
        port map (
      I0 => reply_fault_reg_n_0,
      I1 => reply_clean,
      I2 => reply_clean_reg_0,
      I3 => source_protocol_fault_reg_n_0,
      O => source_protocol_fault_i_1_n_0
    );
source_protocol_fault_reg: unisim.vcomponents.FDCE
     port map (
      C => vid_io_in_clk,
      CE => '1',
      CLR => \request_sync[2]_i_1_n_0\,
      D => source_protocol_fault_i_1_n_0,
      Q => source_protocol_fault_reg_n_0
    );
source_reset: entity work.c6v_capture_lifecycle_0_xpm_cdc_async_rst
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
entity c6v_capture_lifecycle_0_vision_capture_lifecycle is
  port (
    granted_frames : out STD_LOGIC_VECTOR ( 31 downto 0 );
    released_frames : out STD_LOGIC_VECTOR ( 30 downto 0 );
    D : out STD_LOGIC_VECTOR ( 0 to 0 );
    grant_slot : out STD_LOGIC_VECTOR ( 1 downto 0 );
    available_slot : out STD_LOGIC_VECTOR ( 1 downto 0 );
    src_in : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 31 downto 0 );
    available_epoch : out STD_LOGIC_VECTOR ( 31 downto 0 );
    capture_aresetn : out STD_LOGIC;
    owner_fault_causes : out STD_LOGIC_VECTOR ( 3 downto 0 );
    capture_source_fault : out STD_LOGIC;
    p_0_in0_in : out STD_LOGIC_VECTOR ( 95 downto 0 );
    closed_pixel_count : out STD_LOGIC_VECTOR ( 63 downto 0 );
    monitor_ready : out STD_LOGIC;
    configuration_locked_reg : out STD_LOGIC;
    epoch_sealed : out STD_LOGIC;
    fault_causes : out STD_LOGIC_VECTOR ( 2 downto 0 );
    cpu_held_reg : out STD_LOGIC;
    owner_drained : out STD_LOGIC;
    frame_credit_ready : out STD_LOGIC;
    cpu_available : out STD_LOGIC;
    source_closed : out STD_LOGIC;
    budget_fault : out STD_LOGIC;
    available_frame_id : out STD_LOGIC_VECTOR ( 31 downto 0 );
    barrier_complete : out STD_LOGIC;
    grant_frame_id : out STD_LOGIC_VECTOR ( 31 downto 0 );
    axis_enable : out STD_LOGIC;
    source_quiescent : out STD_LOGIC;
    release_accepted : out STD_LOGIC;
    claim_accepted : out STD_LOGIC;
    aclk : in STD_LOGIC;
    common_aresetn : in STD_LOGIC;
    vid_io_in_clk : in STD_LOGIC;
    rgb_completed_frames : in STD_LOGIC_VECTOR ( 31 downto 0 );
    packet_completed_frames : in STD_LOGIC_VECTOR ( 31 downto 0 );
    status_completed_frames : in STD_LOGIC_VECTOR ( 31 downto 0 );
    cfg_frame_context : in STD_LOGIC_VECTOR ( 63 downto 0 );
    frame_credit_request : in STD_LOGIC;
    dma_fault : in STD_LOGIC;
    capture_fault : in STD_LOGIC;
    cpu_command_fault : in STD_LOGIC;
    vid_vsync : in STD_LOGIC;
    control_barrier_request : in STD_LOGIC;
    control_abort_requested : in STD_LOGIC;
    control_capture_aresetn : in STD_LOGIC;
    control_armed : in STD_LOGIC;
    cpu_claim : in STD_LOGIC;
    cpu_release : in STD_LOGIC;
    pipeline_drained : in STD_LOGIC;
    dma_drained : in STD_LOGIC;
    aclk_underflow : in STD_LOGIC;
    cpu_epoch : in STD_LOGIC_VECTOR ( 31 downto 0 );
    cpu_frame_id : in STD_LOGIC_VECTOR ( 31 downto 0 );
    vid_active_video : in STD_LOGIC;
    video_overflow : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of c6v_capture_lifecycle_0_vision_capture_lifecycle : entity is "vision_capture_lifecycle";
end c6v_capture_lifecycle_0_vision_capture_lifecycle;

architecture STRUCTURE of c6v_capture_lifecycle_0_vision_capture_lifecycle is
  signal \^d\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^q\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal aclk_resetn : STD_LOGIC;
  signal admission_n_100 : STD_LOGIC;
  signal admission_n_101 : STD_LOGIC;
  signal admission_n_102 : STD_LOGIC;
  signal admission_n_103 : STD_LOGIC;
  signal admission_n_104 : STD_LOGIC;
  signal admission_n_105 : STD_LOGIC;
  signal admission_n_106 : STD_LOGIC;
  signal admission_n_107 : STD_LOGIC;
  signal admission_n_108 : STD_LOGIC;
  signal admission_n_109 : STD_LOGIC;
  signal admission_n_110 : STD_LOGIC;
  signal admission_n_111 : STD_LOGIC;
  signal admission_n_112 : STD_LOGIC;
  signal admission_n_113 : STD_LOGIC;
  signal admission_n_114 : STD_LOGIC;
  signal admission_n_115 : STD_LOGIC;
  signal admission_n_116 : STD_LOGIC;
  signal admission_n_117 : STD_LOGIC;
  signal admission_n_118 : STD_LOGIC;
  signal admission_n_119 : STD_LOGIC;
  signal admission_n_120 : STD_LOGIC;
  signal admission_n_121 : STD_LOGIC;
  signal admission_n_122 : STD_LOGIC;
  signal admission_n_123 : STD_LOGIC;
  signal admission_n_124 : STD_LOGIC;
  signal admission_n_125 : STD_LOGIC;
  signal admission_n_126 : STD_LOGIC;
  signal admission_n_127 : STD_LOGIC;
  signal admission_n_128 : STD_LOGIC;
  signal admission_n_129 : STD_LOGIC;
  signal admission_n_130 : STD_LOGIC;
  signal admission_n_131 : STD_LOGIC;
  signal admission_n_132 : STD_LOGIC;
  signal boundary_fault_sync : STD_LOGIC;
  signal budget_checked : STD_LOGIC;
  signal budget_n_144 : STD_LOGIC;
  signal budget_n_145 : STD_LOGIC;
  signal budget_n_146 : STD_LOGIC;
  signal budget_n_147 : STD_LOGIC;
  signal budget_n_148 : STD_LOGIC;
  signal budget_n_149 : STD_LOGIC;
  signal budget_n_150 : STD_LOGIC;
  signal budget_n_151 : STD_LOGIC;
  signal budget_n_152 : STD_LOGIC;
  signal budget_n_153 : STD_LOGIC;
  signal budget_n_154 : STD_LOGIC;
  signal budget_n_155 : STD_LOGIC;
  signal budget_n_156 : STD_LOGIC;
  signal budget_n_157 : STD_LOGIC;
  signal budget_n_158 : STD_LOGIC;
  signal budget_n_159 : STD_LOGIC;
  signal budget_n_160 : STD_LOGIC;
  signal budget_n_36 : STD_LOGIC;
  signal budget_n_38 : STD_LOGIC;
  signal budget_n_41 : STD_LOGIC;
  signal budget_n_44 : STD_LOGIC;
  signal budget_n_45 : STD_LOGIC;
  signal budget_n_46 : STD_LOGIC;
  signal budget_n_47 : STD_LOGIC;
  signal budget_n_48 : STD_LOGIC;
  signal budget_n_49 : STD_LOGIC;
  signal budget_n_50 : STD_LOGIC;
  signal budget_n_51 : STD_LOGIC;
  signal budget_n_52 : STD_LOGIC;
  signal budget_n_53 : STD_LOGIC;
  signal budget_n_54 : STD_LOGIC;
  signal budget_n_55 : STD_LOGIC;
  signal budget_n_56 : STD_LOGIC;
  signal budget_n_57 : STD_LOGIC;
  signal budget_n_58 : STD_LOGIC;
  signal budget_n_59 : STD_LOGIC;
  signal budget_n_60 : STD_LOGIC;
  signal budget_n_61 : STD_LOGIC;
  signal budget_n_62 : STD_LOGIC;
  signal budget_n_63 : STD_LOGIC;
  signal budget_n_64 : STD_LOGIC;
  signal budget_n_65 : STD_LOGIC;
  signal budget_n_66 : STD_LOGIC;
  signal budget_n_67 : STD_LOGIC;
  signal budget_n_68 : STD_LOGIC;
  signal budget_n_69 : STD_LOGIC;
  signal budget_n_70 : STD_LOGIC;
  signal budget_n_71 : STD_LOGIC;
  signal budget_n_72 : STD_LOGIC;
  signal budget_n_73 : STD_LOGIC;
  signal budget_n_74 : STD_LOGIC;
  signal budget_n_75 : STD_LOGIC;
  signal budget_n_76 : STD_LOGIC;
  signal budget_n_77 : STD_LOGIC;
  signal budget_n_78 : STD_LOGIC;
  signal budget_n_79 : STD_LOGIC;
  signal \^capture_aresetn\ : STD_LOGIC;
  signal capture_fault_held : STD_LOGIC;
  signal clear : STD_LOGIC;
  signal closure_held : STD_LOGIC;
  signal closure_held_0 : STD_LOGIC;
  signal configuration_locked : STD_LOGIC;
  signal configuration_locked1 : STD_LOGIC;
  signal \^configuration_locked_reg\ : STD_LOGIC;
  signal fence_n_10 : STD_LOGIC;
  signal fence_n_6 : STD_LOGIC;
  signal fence_n_8 : STD_LOGIC;
  signal grant_ready1 : STD_LOGIC;
  signal \^granted_frames\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal held_budget : STD_LOGIC_VECTOR ( 95 downto 0 );
  signal \^monitor_ready\ : STD_LOGIC;
  signal \^owner_fault_causes\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal owner_n_115 : STD_LOGIC;
  signal owner_n_119 : STD_LOGIC;
  signal owner_n_152 : STD_LOGIC;
  signal owner_n_153 : STD_LOGIC;
  signal owner_n_154 : STD_LOGIC;
  signal owner_n_155 : STD_LOGIC;
  signal owner_n_156 : STD_LOGIC;
  signal owner_n_157 : STD_LOGIC;
  signal owner_n_158 : STD_LOGIC;
  signal owner_n_159 : STD_LOGIC;
  signal owner_n_160 : STD_LOGIC;
  signal owner_n_161 : STD_LOGIC;
  signal owner_n_162 : STD_LOGIC;
  signal owner_n_163 : STD_LOGIC;
  signal owner_n_164 : STD_LOGIC;
  signal owner_n_165 : STD_LOGIC;
  signal owner_n_198 : STD_LOGIC;
  signal owner_n_72 : STD_LOGIC;
  signal \^p_0_in0_in\ : STD_LOGIC_VECTOR ( 95 downto 0 );
  signal released_sequence : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal request_close : STD_LOGIC;
  signal request_close0 : STD_LOGIC;
  signal request_held : STD_LOGIC;
  signal request_held0 : STD_LOGIC;
  signal request_open : STD_LOGIC;
  signal request_open0 : STD_LOGIC;
  signal \^src_in\ : STD_LOGIC;
  signal upstream_fault0 : STD_LOGIC;
  attribute DEST_SYNC_FF : integer;
  attribute DEST_SYNC_FF of boundary_cdc : label is 3;
  attribute INIT_SYNC_FF : integer;
  attribute INIT_SYNC_FF of boundary_cdc : label is 0;
  attribute SIM_ASSERT_CHK : integer;
  attribute SIM_ASSERT_CHK of boundary_cdc : label is 1;
  attribute SRC_INPUT_REG : integer;
  attribute SRC_INPUT_REG of boundary_cdc : label is 0;
  attribute VERSION : integer;
  attribute VERSION of boundary_cdc : label is 0;
  attribute XPM_CDC : string;
  attribute XPM_CDC of boundary_cdc : label is "SINGLE";
  attribute XPM_MODULE : string;
  attribute XPM_MODULE of boundary_cdc : label is "TRUE";
begin
  D(0) <= \^d\(0);
  Q(31 downto 0) <= \^q\(31 downto 0);
  capture_aresetn <= \^capture_aresetn\;
  configuration_locked_reg <= \^configuration_locked_reg\;
  granted_frames(31 downto 0) <= \^granted_frames\(31 downto 0);
  monitor_ready <= \^monitor_ready\;
  owner_fault_causes(3 downto 0) <= \^owner_fault_causes\(3 downto 0);
  p_0_in0_in(95 downto 0) <= \^p_0_in0_in\(95 downto 0);
  src_in <= \^src_in\;
admission: entity work.c6v_capture_lifecycle_0_vision_source_admission
     port map (
      D(95 downto 0) => \^p_0_in0_in\(95 downto 0),
      E(0) => request_held0,
      Q(2 downto 0) => released_sequence(2 downto 0),
      S(3) => admission_n_101,
      S(2) => admission_n_102,
      S(1) => admission_n_103,
      S(0) => admission_n_104,
      \admitted_frames_reg[19]_0\(3) => admission_n_125,
      \admitted_frames_reg[19]_0\(2) => admission_n_126,
      \admitted_frames_reg[19]_0\(1) => admission_n_127,
      \admitted_frames_reg[19]_0\(0) => admission_n_128,
      \admitted_frames_reg[31]_0\(3) => admission_n_129,
      \admitted_frames_reg[31]_0\(2) => admission_n_130,
      \admitted_frames_reg[31]_0\(1) => admission_n_131,
      \admitted_frames_reg[31]_0\(0) => admission_n_132,
      \admitted_frames_reg[7]_0\(3) => admission_n_121,
      \admitted_frames_reg[7]_0\(2) => admission_n_122,
      \admitted_frames_reg[7]_0\(1) => admission_n_123,
      \admitted_frames_reg[7]_0\(0) => admission_n_124,
      \admitted_pixels_reg[23]_0\(3) => admission_n_105,
      \admitted_pixels_reg[23]_0\(2) => admission_n_106,
      \admitted_pixels_reg[23]_0\(1) => admission_n_107,
      \admitted_pixels_reg[23]_0\(0) => admission_n_108,
      \admitted_pixels_reg[35]_0\(3) => admission_n_109,
      \admitted_pixels_reg[35]_0\(2) => admission_n_110,
      \admitted_pixels_reg[35]_0\(1) => admission_n_111,
      \admitted_pixels_reg[35]_0\(0) => admission_n_112,
      \admitted_pixels_reg[47]_0\(3) => admission_n_113,
      \admitted_pixels_reg[47]_0\(2) => admission_n_114,
      \admitted_pixels_reg[47]_0\(1) => admission_n_115,
      \admitted_pixels_reg[47]_0\(0) => admission_n_116,
      \admitted_pixels_reg[59]_0\(3) => admission_n_117,
      \admitted_pixels_reg[59]_0\(2) => admission_n_118,
      \admitted_pixels_reg[59]_0\(1) => admission_n_119,
      \admitted_pixels_reg[59]_0\(0) => admission_n_120,
      \arststages_ff_reg[2]\ => admission_n_100,
      axis_enable => axis_enable,
      \close_sync_reg[0]_0\(0) => request_close,
      common_aresetn => common_aresetn,
      \open_sync_reg[0]_0\(0) => request_open,
      request_held_reg(0) => request_held,
      \source_protocol_fault3_carry__6\(95 downto 0) => held_budget(95 downto 0),
      source_quiescent => source_quiescent,
      src_in => \^src_in\,
      vid_active_video => vid_active_video,
      vid_io_in_clk => vid_io_in_clk,
      vid_vsync => vid_vsync
    );
boundary_cdc: entity work.c6v_capture_lifecycle_0_xpm_cdc_single
     port map (
      dest_clk => aclk,
      dest_out => boundary_fault_sync,
      src_clk => '0',
      src_in => \^src_in\
    );
budget: entity work.c6v_capture_lifecycle_0_vision_source_budget_cdc
     port map (
      CO(0) => grant_ready1,
      D(0) => request_held,
      DI(3) => budget_n_52,
      DI(2) => budget_n_53,
      DI(1) => budget_n_54,
      DI(0) => budget_n_55,
      E(0) => request_held0,
      Q(31 downto 0) => \^q\(31 downto 0),
      S(3) => admission_n_101,
      S(2) => admission_n_102,
      S(1) => admission_n_103,
      S(0) => admission_n_104,
      aclk => aclk,
      budget_checked => budget_checked,
      budget_checked_reg_0 => budget_n_38,
      budget_checked_reg_1 => budget_n_41,
      budget_checked_reg_2 => budget_n_160,
      budget_fault => budget_fault,
      capture_fault => capture_fault,
      capture_source_fault => capture_source_fault,
      capture_source_fault_0 => fence_n_8,
      \closed_frame_count_reg[14]_0\(3) => budget_n_56,
      \closed_frame_count_reg[14]_0\(2) => budget_n_57,
      \closed_frame_count_reg[14]_0\(1) => budget_n_58,
      \closed_frame_count_reg[14]_0\(0) => budget_n_59,
      \closed_frame_count_reg[14]_1\(3) => budget_n_60,
      \closed_frame_count_reg[14]_1\(2) => budget_n_61,
      \closed_frame_count_reg[14]_1\(1) => budget_n_62,
      \closed_frame_count_reg[14]_1\(0) => budget_n_63,
      \closed_frame_count_reg[14]_2\(3) => budget_n_148,
      \closed_frame_count_reg[14]_2\(2) => budget_n_149,
      \closed_frame_count_reg[14]_2\(1) => budget_n_150,
      \closed_frame_count_reg[14]_2\(0) => budget_n_151,
      \closed_frame_count_reg[22]_0\(3) => budget_n_64,
      \closed_frame_count_reg[22]_0\(2) => budget_n_65,
      \closed_frame_count_reg[22]_0\(1) => budget_n_66,
      \closed_frame_count_reg[22]_0\(0) => budget_n_67,
      \closed_frame_count_reg[22]_1\(3) => budget_n_68,
      \closed_frame_count_reg[22]_1\(2) => budget_n_69,
      \closed_frame_count_reg[22]_1\(1) => budget_n_70,
      \closed_frame_count_reg[22]_1\(0) => budget_n_71,
      \closed_frame_count_reg[22]_2\(3) => budget_n_152,
      \closed_frame_count_reg[22]_2\(2) => budget_n_153,
      \closed_frame_count_reg[22]_2\(1) => budget_n_154,
      \closed_frame_count_reg[22]_2\(0) => budget_n_155,
      \closed_frame_count_reg[23]_0\(1) => budget_n_45,
      \closed_frame_count_reg[23]_0\(0) => budget_n_46,
      \closed_frame_count_reg[26]_0\(0) => budget_n_47,
      \closed_frame_count_reg[30]_0\(3) => budget_n_72,
      \closed_frame_count_reg[30]_0\(2) => budget_n_73,
      \closed_frame_count_reg[30]_0\(1) => budget_n_74,
      \closed_frame_count_reg[30]_0\(0) => budget_n_75,
      \closed_frame_count_reg[30]_1\(3) => budget_n_76,
      \closed_frame_count_reg[30]_1\(2) => budget_n_77,
      \closed_frame_count_reg[30]_1\(1) => budget_n_78,
      \closed_frame_count_reg[30]_1\(0) => budget_n_79,
      \closed_frame_count_reg[30]_2\(3) => budget_n_156,
      \closed_frame_count_reg[30]_2\(2) => budget_n_157,
      \closed_frame_count_reg[30]_2\(1) => budget_n_158,
      \closed_frame_count_reg[30]_2\(0) => budget_n_159,
      \closed_frame_count_reg[6]_0\(3) => budget_n_48,
      \closed_frame_count_reg[6]_0\(2) => budget_n_49,
      \closed_frame_count_reg[6]_0\(1) => budget_n_50,
      \closed_frame_count_reg[6]_0\(0) => budget_n_51,
      \closed_frame_count_reg[6]_1\(3) => budget_n_144,
      \closed_frame_count_reg[6]_1\(2) => budget_n_145,
      \closed_frame_count_reg[6]_1\(1) => budget_n_146,
      \closed_frame_count_reg[6]_1\(0) => budget_n_147,
      \closed_frame_count_reg[8]_0\(0) => budget_n_44,
      closed_pixel_count(63 downto 0) => closed_pixel_count(63 downto 0),
      \closure_bad2_carry__1\(11) => owner_n_152,
      \closure_bad2_carry__1\(10) => owner_n_153,
      \closure_bad2_carry__1\(9) => owner_n_154,
      \closure_bad2_carry__1\(8) => owner_n_155,
      \closure_bad2_carry__1\(7) => owner_n_156,
      \closure_bad2_carry__1\(6) => owner_n_157,
      \closure_bad2_carry__1\(5) => owner_n_158,
      \closure_bad2_carry__1\(4) => owner_n_159,
      \closure_bad2_carry__1\(3) => owner_n_160,
      \closure_bad2_carry__1\(2) => owner_n_161,
      \closure_bad2_carry__1\(1) => owner_n_162,
      \closure_bad2_carry__1\(0) => owner_n_163,
      closure_held => closure_held_0,
      closure_held_reg_0(0) => closure_held,
      closure_held_reg_1 => owner_n_72,
      common_aresetn => common_aresetn,
      configuration_locked => configuration_locked,
      cpu_command_fault => cpu_command_fault,
      dest_arst => aclk_resetn,
      dest_out => boundary_fault_sync,
      dma_fault => dma_fault,
      dma_fault_0 => budget_n_36,
      frame_credit_ready => owner_n_119,
      \held_budget_reg[95]_0\(95 downto 0) => held_budget(95 downto 0),
      \out\(31 downto 0) => \^granted_frames\(31 downto 0),
      owner_fault_causes(0) => \^owner_fault_causes\(0),
      p_0_in0_in(95 downto 0) => \^p_0_in0_in\(95 downto 0),
      source_closed => source_closed,
      \source_protocol_fault3_carry__1_0\(3) => admission_n_105,
      \source_protocol_fault3_carry__1_0\(2) => admission_n_106,
      \source_protocol_fault3_carry__1_0\(1) => admission_n_107,
      \source_protocol_fault3_carry__1_0\(0) => admission_n_108,
      \source_protocol_fault3_carry__2_0\(3) => admission_n_109,
      \source_protocol_fault3_carry__2_0\(2) => admission_n_110,
      \source_protocol_fault3_carry__2_0\(1) => admission_n_111,
      \source_protocol_fault3_carry__2_0\(0) => admission_n_112,
      \source_protocol_fault3_carry__3_0\(3) => admission_n_113,
      \source_protocol_fault3_carry__3_0\(2) => admission_n_114,
      \source_protocol_fault3_carry__3_0\(1) => admission_n_115,
      \source_protocol_fault3_carry__3_0\(0) => admission_n_116,
      \source_protocol_fault3_carry__4_0\(3) => admission_n_117,
      \source_protocol_fault3_carry__4_0\(2) => admission_n_118,
      \source_protocol_fault3_carry__4_0\(1) => admission_n_119,
      \source_protocol_fault3_carry__4_0\(0) => admission_n_120,
      \source_protocol_fault3_carry__5_0\(3) => admission_n_121,
      \source_protocol_fault3_carry__5_0\(2) => admission_n_122,
      \source_protocol_fault3_carry__5_0\(1) => admission_n_123,
      \source_protocol_fault3_carry__5_0\(0) => admission_n_124,
      \source_protocol_fault3_carry__6_0\(3) => admission_n_125,
      \source_protocol_fault3_carry__6_0\(2) => admission_n_126,
      \source_protocol_fault3_carry__6_0\(1) => admission_n_127,
      \source_protocol_fault3_carry__6_0\(0) => admission_n_128,
      source_protocol_fault_reg_0(3) => admission_n_129,
      source_protocol_fault_reg_0(2) => admission_n_130,
      source_protocol_fault_reg_0(1) => admission_n_131,
      source_protocol_fault_reg_0(0) => admission_n_132,
      source_protocol_fault_reg_1 => admission_n_100,
      upstream_fault0 => upstream_fault0,
      vid_io_in_clk => vid_io_in_clk
    );
fence: entity work.c6v_capture_lifecycle_0_vision_epoch_fence
     port map (
      aclk => aclk,
      aclk_underflow => aclk_underflow,
      aclk_underflow_0 => fence_n_8,
      barrier_complete => barrier_complete,
      capture_aresetn => \^capture_aresetn\,
      capture_aresetn_reg => \^monitor_ready\,
      capture_aresetn_reg_0 => fence_n_10,
      capture_fault_held => capture_fault_held,
      capture_fault_held_reg_0 => owner_n_198,
      common_aresetn => common_aresetn,
      common_aresetn_0 => fence_n_6,
      configuration_locked => configuration_locked,
      configuration_locked1 => configuration_locked1,
      control_capture_aresetn => control_capture_aresetn,
      epoch_sealed => epoch_sealed,
      epoch_sealed_0 => owner_n_115,
      fault_causes(2 downto 0) => fault_causes(2 downto 0),
      fault_causes_2_sp_1 => \^configuration_locked_reg\,
      reply_clean_reg_0 => admission_n_100,
      request_held_reg_0(0) => request_close,
      vid_io_in_clk => vid_io_in_clk,
      video_overflow => video_overflow
    );
owner: entity work.c6v_capture_lifecycle_0_vision_frame_owner
     port map (
      CO(0) => grant_ready1,
      D(31 downto 0) => \^q\(31 downto 0),
      DI(3) => budget_n_52,
      DI(2) => budget_n_53,
      DI(1) => budget_n_54,
      DI(0) => budget_n_55,
      E(0) => closure_held,
      Q(11) => owner_n_152,
      Q(10) => owner_n_153,
      Q(9) => owner_n_154,
      Q(8) => owner_n_155,
      Q(7) => owner_n_156,
      Q(6) => owner_n_157,
      Q(5) => owner_n_158,
      Q(4) => owner_n_159,
      Q(3) => owner_n_160,
      Q(2) => owner_n_161,
      Q(1) => owner_n_162,
      Q(0) => owner_n_163,
      aclk => aclk,
      available_epoch(31 downto 0) => available_epoch(31 downto 0),
      available_frame_id(31 downto 0) => available_frame_id(31 downto 0),
      available_slot(1 downto 0) => available_slot(1 downto 0),
      budget_checked => budget_checked,
      capture_aresetn => \^capture_aresetn\,
      capture_fault_held => capture_fault_held,
      capture_fault_held_reg => owner_n_198,
      cfg_frame_context(63 downto 0) => cfg_frame_context(63 downto 0),
      claim_accepted => claim_accepted,
      claim_accepted_reg_0 => fence_n_6,
      clear => clear,
      \closure_bad1_carry__0_0\(3) => budget_n_144,
      \closure_bad1_carry__0_0\(2) => budget_n_145,
      \closure_bad1_carry__0_0\(1) => budget_n_146,
      \closure_bad1_carry__0_0\(0) => budget_n_147,
      \closure_bad1_carry__1_0\(3) => budget_n_148,
      \closure_bad1_carry__1_0\(2) => budget_n_149,
      \closure_bad1_carry__1_0\(1) => budget_n_150,
      \closure_bad1_carry__1_0\(0) => budget_n_151,
      \closure_bad1_carry__2_0\(3) => budget_n_152,
      \closure_bad1_carry__2_0\(2) => budget_n_153,
      \closure_bad1_carry__2_0\(1) => budget_n_154,
      \closure_bad1_carry__2_0\(0) => budget_n_155,
      \closure_bad2_carry__0_0\(0) => budget_n_44,
      \closure_bad2_carry__1_0\(1) => budget_n_45,
      \closure_bad2_carry__1_0\(0) => budget_n_46,
      closure_held => closure_held_0,
      closure_held_reg_0 => owner_n_72,
      closure_held_reg_1 => budget_n_160,
      common_aresetn => common_aresetn,
      configuration_locked => configuration_locked,
      configuration_locked1 => configuration_locked1,
      configuration_locked_reg_0 => \^configuration_locked_reg\,
      configuration_locked_reg_1 => fence_n_10,
      control_abort_requested => control_abort_requested,
      control_armed => control_armed,
      control_barrier_request => control_barrier_request,
      control_capture_aresetn => control_capture_aresetn,
      cpu_available => cpu_available,
      cpu_claim => cpu_claim,
      cpu_epoch(31 downto 0) => cpu_epoch(31 downto 0),
      cpu_frame_id(31 downto 0) => cpu_frame_id(31 downto 0),
      cpu_held_reg_0 => cpu_held_reg,
      cpu_release => cpu_release,
      cpu_release_0 => owner_n_115,
      dest_arst => aclk_resetn,
      dma_drained => dma_drained,
      \epoch_reg[31]_0\ => \^monitor_ready\,
      \fault_causes_reg[0]_0\ => budget_n_36,
      frame_credit_ready => frame_credit_ready,
      frame_credit_ready_0 => budget_n_38,
      frame_credit_ready_INST_0_i_3(3) => budget_n_76,
      frame_credit_ready_INST_0_i_3(2) => budget_n_77,
      frame_credit_ready_INST_0_i_3(1) => budget_n_78,
      frame_credit_ready_INST_0_i_3(0) => budget_n_79,
      frame_credit_ready_INST_0_i_3_0(3) => budget_n_72,
      frame_credit_ready_INST_0_i_3_0(2) => budget_n_73,
      frame_credit_ready_INST_0_i_3_0(1) => budget_n_74,
      frame_credit_ready_INST_0_i_3_0(0) => budget_n_75,
      frame_credit_request => frame_credit_request,
      grant_frame_id(31 downto 0) => grant_frame_id(31 downto 0),
      \grant_ready1_carry__0_0\(3) => budget_n_48,
      \grant_ready1_carry__0_0\(2) => budget_n_49,
      \grant_ready1_carry__0_0\(1) => budget_n_50,
      \grant_ready1_carry__0_0\(0) => budget_n_51,
      \grant_ready1_carry__1_0\(3) => budget_n_60,
      \grant_ready1_carry__1_0\(2) => budget_n_61,
      \grant_ready1_carry__1_0\(1) => budget_n_62,
      \grant_ready1_carry__1_0\(0) => budget_n_63,
      \grant_ready1_carry__1_1\(3) => budget_n_56,
      \grant_ready1_carry__1_1\(2) => budget_n_57,
      \grant_ready1_carry__1_1\(1) => budget_n_58,
      \grant_ready1_carry__1_1\(0) => budget_n_59,
      \grant_ready1_carry__2_0\(3) => budget_n_68,
      \grant_ready1_carry__2_0\(2) => budget_n_69,
      \grant_ready1_carry__2_0\(1) => budget_n_70,
      \grant_ready1_carry__2_0\(0) => budget_n_71,
      \grant_ready1_carry__2_1\(3) => budget_n_64,
      \grant_ready1_carry__2_1\(2) => budget_n_65,
      \grant_ready1_carry__2_1\(1) => budget_n_66,
      \grant_ready1_carry__2_1\(0) => budget_n_67,
      grant_slot(1 downto 0) => grant_slot(1 downto 0),
      \granted_frames_reg[31]_0\ => budget_n_41,
      \granted_frames_reg[3]_0\ => owner_n_119,
      \out\(31 downto 0) => \^granted_frames\(31 downto 0),
      owner_drained => owner_drained,
      owner_fault_INST_0_i_1_0(0) => budget_n_47,
      owner_fault_INST_0_i_1_1(3) => budget_n_156,
      owner_fault_INST_0_i_1_1(2) => budget_n_157,
      owner_fault_INST_0_i_1_1(1) => budget_n_158,
      owner_fault_INST_0_i_1_1(0) => budget_n_159,
      owner_fault_causes(3 downto 0) => \^owner_fault_causes\(3 downto 0),
      packet_completed_frames(31 downto 0) => packet_completed_frames(31 downto 0),
      pipeline_drained => pipeline_drained,
      release_accepted => release_accepted,
      \released_frames_reg[1]_0\(1) => owner_n_164,
      \released_frames_reg[1]_0\(0) => owner_n_165,
      \released_frames_reg[31]_0\(31 downto 3) => released_frames(30 downto 2),
      \released_frames_reg[31]_0\(2) => \^d\(0),
      \released_frames_reg[31]_0\(1 downto 0) => released_frames(1 downto 0),
      request_close0 => request_close0,
      request_open0 => request_open0,
      rgb_completed_frames(31 downto 0) => rgb_completed_frames(31 downto 0),
      status_completed_frames(31 downto 0) => status_completed_frames(31 downto 0),
      upstream_fault0 => upstream_fault0
    );
release_credit: entity work.c6v_capture_lifecycle_0_vision_release_credit_cdc
     port map (
      D(2) => \^d\(0),
      D(1) => owner_n_164,
      D(0) => owner_n_165,
      Q(2 downto 0) => released_sequence(2 downto 0),
      SR(0) => clear,
      aclk => aclk,
      common_aresetn => common_aresetn,
      vid_io_in_clk => vid_io_in_clk
    );
request_close_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => request_close0,
      Q => request_close,
      R => clear
    );
request_open_reg: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => request_open0,
      Q => request_open,
      R => clear
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity c6v_capture_lifecycle_0 is
  port (
    aclk : in STD_LOGIC;
    vid_io_in_clk : in STD_LOGIC;
    common_aresetn : in STD_LOGIC;
    control_capture_aresetn : in STD_LOGIC;
    control_armed : in STD_LOGIC;
    control_abort_requested : in STD_LOGIC;
    control_barrier_request : in STD_LOGIC;
    cfg_frame_context : in STD_LOGIC_VECTOR ( 143 downto 0 );
    vid_active_video : in STD_LOGIC;
    vid_vsync : in STD_LOGIC;
    video_overflow : in STD_LOGIC;
    aclk_underflow : in STD_LOGIC;
    capture_fault : in STD_LOGIC;
    pipeline_drained : in STD_LOGIC;
    dma_drained : in STD_LOGIC;
    dma_fault : in STD_LOGIC;
    rgb_completed_frames : in STD_LOGIC_VECTOR ( 31 downto 0 );
    packet_completed_frames : in STD_LOGIC_VECTOR ( 31 downto 0 );
    status_completed_frames : in STD_LOGIC_VECTOR ( 31 downto 0 );
    frame_credit_request : in STD_LOGIC;
    cpu_claim : in STD_LOGIC;
    cpu_release : in STD_LOGIC;
    cpu_command_fault : in STD_LOGIC;
    cpu_epoch : in STD_LOGIC_VECTOR ( 31 downto 0 );
    cpu_frame_id : in STD_LOGIC_VECTOR ( 31 downto 0 );
    axis_enable : out STD_LOGIC;
    capture_aresetn : out STD_LOGIC;
    capture_source_fault : out STD_LOGIC;
    monitor_ready : out STD_LOGIC;
    source_quiescent : out STD_LOGIC;
    source_closed : out STD_LOGIC;
    budget_fault : out STD_LOGIC;
    boundary_fault : out STD_LOGIC;
    admitted_frames : out STD_LOGIC_VECTOR ( 31 downto 0 );
    closed_frame_count : out STD_LOGIC_VECTOR ( 31 downto 0 );
    admitted_pixels : out STD_LOGIC_VECTOR ( 63 downto 0 );
    closed_pixel_count : out STD_LOGIC_VECTOR ( 63 downto 0 );
    frame_credit_ready : out STD_LOGIC;
    grant_frame_id : out STD_LOGIC_VECTOR ( 31 downto 0 );
    grant_slot : out STD_LOGIC_VECTOR ( 1 downto 0 );
    cpu_available : out STD_LOGIC;
    cpu_held : out STD_LOGIC;
    claim_accepted : out STD_LOGIC;
    release_accepted : out STD_LOGIC;
    available_epoch : out STD_LOGIC_VECTOR ( 31 downto 0 );
    available_frame_id : out STD_LOGIC_VECTOR ( 31 downto 0 );
    available_slot : out STD_LOGIC_VECTOR ( 31 downto 0 );
    granted_frames : out STD_LOGIC_VECTOR ( 31 downto 0 );
    released_frames : out STD_LOGIC_VECTOR ( 31 downto 0 );
    owner_drained : out STD_LOGIC;
    owner_fault : out STD_LOGIC;
    owner_fault_causes : out STD_LOGIC_VECTOR ( 3 downto 0 );
    barrier_complete : out STD_LOGIC;
    epoch_sealed : out STD_LOGIC;
    fault_causes : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of c6v_capture_lifecycle_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_capture_lifecycle_0 : entity is "c6v_capture_lifecycle_0,vision_capture_lifecycle,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_capture_lifecycle_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_capture_lifecycle_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of c6v_capture_lifecycle_0 : entity is "vision_capture_lifecycle,Vivado 2026.1";
end c6v_capture_lifecycle_0;

architecture STRUCTURE of c6v_capture_lifecycle_0 is
  signal \<const0>\ : STD_LOGIC;
  signal \^available_slot\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of aclk : signal is "xilinx.com:signal:clock:1.0 aclk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of aclk : signal is "XIL_INTERFACENAME aclk, ASSOCIATED_RESET common_aresetn:control_capture_aresetn:capture_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of capture_aresetn : signal is "xilinx.com:signal:reset:1.0 capture_aresetn RST";
  attribute X_INTERFACE_MODE of capture_aresetn : signal is "master";
  attribute X_INTERFACE_PARAMETER of capture_aresetn : signal is "XIL_INTERFACENAME capture_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of common_aresetn : signal is "xilinx.com:signal:reset:1.0 common_aresetn RST";
  attribute X_INTERFACE_MODE of common_aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of common_aresetn : signal is "XIL_INTERFACENAME common_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of control_capture_aresetn : signal is "xilinx.com:signal:reset:1.0 control_capture_aresetn RST";
  attribute X_INTERFACE_MODE of control_capture_aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of control_capture_aresetn : signal is "XIL_INTERFACENAME control_capture_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of vid_io_in_clk : signal is "xilinx.com:signal:clock:1.0 vid_io_in_clk CLK";
  attribute X_INTERFACE_MODE of vid_io_in_clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER of vid_io_in_clk : signal is "XIL_INTERFACENAME vid_io_in_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0";
begin
  available_slot(31) <= \<const0>\;
  available_slot(30) <= \<const0>\;
  available_slot(29) <= \<const0>\;
  available_slot(28) <= \<const0>\;
  available_slot(27) <= \<const0>\;
  available_slot(26) <= \<const0>\;
  available_slot(25) <= \<const0>\;
  available_slot(24) <= \<const0>\;
  available_slot(23) <= \<const0>\;
  available_slot(22) <= \<const0>\;
  available_slot(21) <= \<const0>\;
  available_slot(20) <= \<const0>\;
  available_slot(19) <= \<const0>\;
  available_slot(18) <= \<const0>\;
  available_slot(17) <= \<const0>\;
  available_slot(16) <= \<const0>\;
  available_slot(15) <= \<const0>\;
  available_slot(14) <= \<const0>\;
  available_slot(13) <= \<const0>\;
  available_slot(12) <= \<const0>\;
  available_slot(11) <= \<const0>\;
  available_slot(10) <= \<const0>\;
  available_slot(9) <= \<const0>\;
  available_slot(8) <= \<const0>\;
  available_slot(7) <= \<const0>\;
  available_slot(6) <= \<const0>\;
  available_slot(5) <= \<const0>\;
  available_slot(4) <= \<const0>\;
  available_slot(3) <= \<const0>\;
  available_slot(2) <= \<const0>\;
  available_slot(1 downto 0) <= \^available_slot\(1 downto 0);
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
inst: entity work.c6v_capture_lifecycle_0_vision_capture_lifecycle
     port map (
      D(0) => released_frames(2),
      Q(31 downto 0) => closed_frame_count(31 downto 0),
      aclk => aclk,
      aclk_underflow => aclk_underflow,
      available_epoch(31 downto 0) => available_epoch(31 downto 0),
      available_frame_id(31 downto 0) => available_frame_id(31 downto 0),
      available_slot(1 downto 0) => \^available_slot\(1 downto 0),
      axis_enable => axis_enable,
      barrier_complete => barrier_complete,
      budget_fault => budget_fault,
      capture_aresetn => capture_aresetn,
      capture_fault => capture_fault,
      capture_source_fault => capture_source_fault,
      cfg_frame_context(63 downto 32) => cfg_frame_context(143 downto 112),
      cfg_frame_context(31 downto 0) => cfg_frame_context(79 downto 48),
      claim_accepted => claim_accepted,
      closed_pixel_count(63 downto 0) => closed_pixel_count(63 downto 0),
      common_aresetn => common_aresetn,
      configuration_locked_reg => owner_fault,
      control_abort_requested => control_abort_requested,
      control_armed => control_armed,
      control_barrier_request => control_barrier_request,
      control_capture_aresetn => control_capture_aresetn,
      cpu_available => cpu_available,
      cpu_claim => cpu_claim,
      cpu_command_fault => cpu_command_fault,
      cpu_epoch(31 downto 0) => cpu_epoch(31 downto 0),
      cpu_frame_id(31 downto 0) => cpu_frame_id(31 downto 0),
      cpu_held_reg => cpu_held,
      cpu_release => cpu_release,
      dma_drained => dma_drained,
      dma_fault => dma_fault,
      epoch_sealed => epoch_sealed,
      fault_causes(2 downto 0) => fault_causes(2 downto 0),
      frame_credit_ready => frame_credit_ready,
      frame_credit_request => frame_credit_request,
      grant_frame_id(31 downto 0) => grant_frame_id(31 downto 0),
      grant_slot(1 downto 0) => grant_slot(1 downto 0),
      granted_frames(31 downto 0) => granted_frames(31 downto 0),
      monitor_ready => monitor_ready,
      owner_drained => owner_drained,
      owner_fault_causes(3 downto 0) => owner_fault_causes(3 downto 0),
      p_0_in0_in(95 downto 64) => admitted_frames(31 downto 0),
      p_0_in0_in(63 downto 0) => admitted_pixels(63 downto 0),
      packet_completed_frames(31 downto 0) => packet_completed_frames(31 downto 0),
      pipeline_drained => pipeline_drained,
      release_accepted => release_accepted,
      released_frames(30 downto 2) => released_frames(31 downto 3),
      released_frames(1 downto 0) => released_frames(1 downto 0),
      rgb_completed_frames(31 downto 0) => rgb_completed_frames(31 downto 0),
      source_closed => source_closed,
      source_quiescent => source_quiescent,
      src_in => boundary_fault,
      status_completed_frames(31 downto 0) => status_completed_frames(31 downto 0),
      vid_active_video => vid_active_video,
      vid_io_in_clk => vid_io_in_clk,
      vid_vsync => vid_vsync,
      video_overflow => video_overflow
    );
end STRUCTURE;
