-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
-- Date        : Fri Oct 30 22:06:56 2026
-- Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_lifecycle_0/c6v_capture_lifecycle_0_stub.vhdl
-- Design      : c6v_capture_lifecycle_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity c6v_capture_lifecycle_0 is
  Port ( 
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

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of c6v_capture_lifecycle_0 : entity is "c6v_capture_lifecycle_0,vision_capture_lifecycle,{}";
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of c6v_capture_lifecycle_0 : entity is "c6v_capture_lifecycle_0,vision_capture_lifecycle,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=vision_capture_lifecycle,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,INPUT_WIDTH=1280,INPUT_HEIGHT=720}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of c6v_capture_lifecycle_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of c6v_capture_lifecycle_0 : entity is "module_ref";
end c6v_capture_lifecycle_0;

architecture stub of c6v_capture_lifecycle_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "aclk,vid_io_in_clk,common_aresetn,control_capture_aresetn,control_armed,control_abort_requested,control_barrier_request,cfg_frame_context[143:0],vid_active_video,vid_vsync,video_overflow,aclk_underflow,capture_fault,pipeline_drained,dma_drained,dma_fault,rgb_completed_frames[31:0],packet_completed_frames[31:0],status_completed_frames[31:0],frame_credit_request,cpu_claim,cpu_release,cpu_command_fault,cpu_epoch[31:0],cpu_frame_id[31:0],axis_enable,capture_aresetn,capture_source_fault,monitor_ready,source_quiescent,source_closed,budget_fault,boundary_fault,admitted_frames[31:0],closed_frame_count[31:0],admitted_pixels[63:0],closed_pixel_count[63:0],frame_credit_ready,grant_frame_id[31:0],grant_slot[1:0],cpu_available,cpu_held,claim_accepted,release_accepted,available_epoch[31:0],available_frame_id[31:0],available_slot[31:0],granted_frames[31:0],released_frames[31:0],owner_drained,owner_fault,owner_fault_causes[3:0],barrier_complete,epoch_sealed,fault_causes[2:0]";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of aclk : signal is "xilinx.com:signal:clock:1.0 aclk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of aclk : signal is "XIL_INTERFACENAME aclk, ASSOCIATED_RESET common_aresetn:control_capture_aresetn:capture_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of vid_io_in_clk : signal is "xilinx.com:signal:clock:1.0 vid_io_in_clk CLK";
  attribute X_INTERFACE_MODE of vid_io_in_clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER of vid_io_in_clk : signal is "XIL_INTERFACENAME vid_io_in_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of common_aresetn : signal is "xilinx.com:signal:reset:1.0 common_aresetn RST";
  attribute X_INTERFACE_MODE of common_aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of common_aresetn : signal is "XIL_INTERFACENAME common_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of control_capture_aresetn : signal is "xilinx.com:signal:reset:1.0 control_capture_aresetn RST";
  attribute X_INTERFACE_MODE of control_capture_aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of control_capture_aresetn : signal is "XIL_INTERFACENAME control_capture_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of capture_aresetn : signal is "xilinx.com:signal:reset:1.0 capture_aresetn RST";
  attribute X_INTERFACE_MODE of capture_aresetn : signal is "master";
  attribute X_INTERFACE_PARAMETER of capture_aresetn : signal is "XIL_INTERFACENAME capture_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of stub : architecture is "vision_capture_lifecycle,Vivado 2026.1";
begin
end;
