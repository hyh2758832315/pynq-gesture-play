// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Fri Oct 23 06:48:24 2026
// Host        : build-host running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/vvl/c0e/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_lifecycle_0/c6v_capture_lifecycle_0_sim_netlist.v
// Design      : c6v_capture_lifecycle_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "c6v_capture_lifecycle_0,vision_capture_lifecycle,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "vision_capture_lifecycle,Vivado 2026.1" *) 
(* NotValidForBitStream *)
module c6v_capture_lifecycle_0
   (aclk,
    vid_io_in_clk,
    common_aresetn,
    control_capture_aresetn,
    control_armed,
    control_abort_requested,
    control_barrier_request,
    cfg_frame_context,
    vid_active_video,
    vid_vsync,
    video_overflow,
    aclk_underflow,
    capture_fault,
    pipeline_drained,
    dma_drained,
    dma_fault,
    rgb_completed_frames,
    packet_completed_frames,
    status_completed_frames,
    frame_credit_request,
    cpu_claim,
    cpu_release,
    cpu_command_fault,
    cpu_epoch,
    cpu_frame_id,
    axis_enable,
    capture_aresetn,
    capture_source_fault,
    monitor_ready,
    source_quiescent,
    source_closed,
    budget_fault,
    boundary_fault,
    admitted_frames,
    closed_frame_count,
    admitted_pixels,
    closed_pixel_count,
    frame_credit_ready,
    grant_frame_id,
    grant_slot,
    cpu_available,
    cpu_held,
    claim_accepted,
    release_accepted,
    available_epoch,
    available_frame_id,
    available_slot,
    granted_frames,
    released_frames,
    owner_drained,
    owner_fault,
    owner_fault_causes,
    barrier_complete,
    epoch_sealed,
    fault_causes);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_RESET common_aresetn:control_capture_aresetn:capture_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 vid_io_in_clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vid_io_in_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input vid_io_in_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 common_aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME common_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input common_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 control_capture_aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME control_capture_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input control_capture_aresetn;
  input control_armed;
  input control_abort_requested;
  input control_barrier_request;
  input [143:0]cfg_frame_context;
  input vid_active_video;
  input vid_vsync;
  input video_overflow;
  input aclk_underflow;
  input capture_fault;
  input pipeline_drained;
  input dma_drained;
  input dma_fault;
  input [31:0]rgb_completed_frames;
  input [31:0]packet_completed_frames;
  input [31:0]status_completed_frames;
  input frame_credit_request;
  input cpu_claim;
  input cpu_release;
  input cpu_command_fault;
  input [31:0]cpu_epoch;
  input [31:0]cpu_frame_id;
  output axis_enable;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 capture_aresetn RST" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME capture_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) output capture_aresetn;
  output capture_source_fault;
  output monitor_ready;
  output source_quiescent;
  output source_closed;
  output budget_fault;
  output boundary_fault;
  output [31:0]admitted_frames;
  output [31:0]closed_frame_count;
  output [63:0]admitted_pixels;
  output [63:0]closed_pixel_count;
  output frame_credit_ready;
  output [31:0]grant_frame_id;
  output [1:0]grant_slot;
  output cpu_available;
  output cpu_held;
  output claim_accepted;
  output release_accepted;
  output [31:0]available_epoch;
  output [31:0]available_frame_id;
  output [31:0]available_slot;
  output [31:0]granted_frames;
  output [31:0]released_frames;
  output owner_drained;
  output owner_fault;
  output [3:0]owner_fault_causes;
  output barrier_complete;
  output epoch_sealed;
  output [2:0]fault_causes;

  wire \<const0> ;
  wire aclk;
  wire aclk_underflow;
  wire [31:0]admitted_frames;
  wire [63:0]admitted_pixels;
  wire [31:0]available_epoch;
  wire [31:0]available_frame_id;
  wire [1:0]\^available_slot ;
  wire axis_enable;
  wire barrier_complete;
  wire boundary_fault;
  wire budget_fault;
  wire capture_aresetn;
  wire capture_fault;
  wire capture_source_fault;
  wire [143:0]cfg_frame_context;
  wire claim_accepted;
  wire [31:0]closed_frame_count;
  wire [63:0]closed_pixel_count;
  wire common_aresetn;
  wire control_abort_requested;
  wire control_armed;
  wire control_barrier_request;
  wire control_capture_aresetn;
  wire cpu_available;
  wire cpu_claim;
  wire cpu_command_fault;
  wire [31:0]cpu_epoch;
  wire [31:0]cpu_frame_id;
  wire cpu_held;
  wire cpu_release;
  wire dma_drained;
  wire dma_fault;
  wire epoch_sealed;
  wire [2:0]fault_causes;
  wire frame_credit_ready;
  wire frame_credit_request;
  wire [31:0]grant_frame_id;
  wire [1:0]grant_slot;
  wire [31:0]granted_frames;
  wire monitor_ready;
  wire owner_drained;
  wire owner_fault;
  wire [3:0]owner_fault_causes;
  wire [31:0]packet_completed_frames;
  wire pipeline_drained;
  wire release_accepted;
  wire [31:0]released_frames;
  wire [31:0]rgb_completed_frames;
  wire source_closed;
  wire source_quiescent;
  wire [31:0]status_completed_frames;
  wire vid_active_video;
  wire vid_io_in_clk;
  wire vid_vsync;
  wire video_overflow;

  assign available_slot[31] = \<const0> ;
  assign available_slot[30] = \<const0> ;
  assign available_slot[29] = \<const0> ;
  assign available_slot[28] = \<const0> ;
  assign available_slot[27] = \<const0> ;
  assign available_slot[26] = \<const0> ;
  assign available_slot[25] = \<const0> ;
  assign available_slot[24] = \<const0> ;
  assign available_slot[23] = \<const0> ;
  assign available_slot[22] = \<const0> ;
  assign available_slot[21] = \<const0> ;
  assign available_slot[20] = \<const0> ;
  assign available_slot[19] = \<const0> ;
  assign available_slot[18] = \<const0> ;
  assign available_slot[17] = \<const0> ;
  assign available_slot[16] = \<const0> ;
  assign available_slot[15] = \<const0> ;
  assign available_slot[14] = \<const0> ;
  assign available_slot[13] = \<const0> ;
  assign available_slot[12] = \<const0> ;
  assign available_slot[11] = \<const0> ;
  assign available_slot[10] = \<const0> ;
  assign available_slot[9] = \<const0> ;
  assign available_slot[8] = \<const0> ;
  assign available_slot[7] = \<const0> ;
  assign available_slot[6] = \<const0> ;
  assign available_slot[5] = \<const0> ;
  assign available_slot[4] = \<const0> ;
  assign available_slot[3] = \<const0> ;
  assign available_slot[2] = \<const0> ;
  assign available_slot[1:0] = \^available_slot [1:0];
  GND GND
       (.G(\<const0> ));
  c6v_capture_lifecycle_0_vision_capture_lifecycle inst
       (.Q(closed_frame_count),
        .aclk(aclk),
        .aclk_underflow(aclk_underflow),
        .available_epoch(available_epoch),
        .available_frame_id(available_frame_id),
        .available_slot(\^available_slot ),
        .axis_enable(axis_enable),
        .barrier_complete(barrier_complete),
        .boundary_fault(boundary_fault),
        .budget_fault(budget_fault),
        .capture_aresetn(capture_aresetn),
        .capture_fault(capture_fault),
        .capture_source_fault(capture_source_fault),
        .cfg_frame_context({cfg_frame_context[143:112],cfg_frame_context[79:48]}),
        .claim_accepted(claim_accepted),
        .closed_pixel_count(closed_pixel_count),
        .common_aresetn(common_aresetn),
        .configuration_locked_reg(owner_fault),
        .control_abort_requested(control_abort_requested),
        .control_armed(control_armed),
        .control_barrier_request(control_barrier_request),
        .control_capture_aresetn(control_capture_aresetn),
        .cpu_available(cpu_available),
        .cpu_claim(cpu_claim),
        .cpu_command_fault(cpu_command_fault),
        .cpu_epoch(cpu_epoch),
        .cpu_frame_id(cpu_frame_id),
        .cpu_held_reg(cpu_held),
        .cpu_release(cpu_release),
        .dma_drained(dma_drained),
        .dma_fault(dma_fault),
        .epoch_sealed(epoch_sealed),
        .fault_causes(fault_causes),
        .frame_credit_ready(frame_credit_ready),
        .frame_credit_request(frame_credit_request),
        .grant_frame_id(grant_frame_id),
        .grant_slot(grant_slot),
        .granted_frames(granted_frames),
        .monitor_ready(monitor_ready),
        .owner_drained(owner_drained),
        .owner_fault_causes(owner_fault_causes),
        .p_0_in0_in({admitted_frames,admitted_pixels}),
        .packet_completed_frames(packet_completed_frames),
        .pipeline_drained(pipeline_drained),
        .release_accepted(release_accepted),
        .released_frames(released_frames),
        .rgb_completed_frames(rgb_completed_frames),
        .source_closed(source_closed),
        .source_quiescent(source_quiescent),
        .status_completed_frames(status_completed_frames),
        .vid_active_video(vid_active_video),
        .vid_io_in_clk(vid_io_in_clk),
        .vid_vsync(vid_vsync),
        .video_overflow(video_overflow));
endmodule

(* ORIG_REF_NAME = "vision_capture_lifecycle" *) 
module c6v_capture_lifecycle_0_vision_capture_lifecycle
   (axis_enable,
    granted_frames,
    released_frames,
    grant_slot,
    available_slot,
    boundary_fault,
    Q,
    available_epoch,
    capture_aresetn,
    owner_fault_causes,
    capture_source_fault,
    p_0_in0_in,
    closed_pixel_count,
    monitor_ready,
    source_quiescent,
    configuration_locked_reg,
    epoch_sealed,
    fault_causes,
    cpu_held_reg,
    owner_drained,
    frame_credit_ready,
    cpu_available,
    source_closed,
    budget_fault,
    available_frame_id,
    barrier_complete,
    grant_frame_id,
    release_accepted,
    claim_accepted,
    aclk,
    vid_active_video,
    vid_vsync,
    common_aresetn,
    vid_io_in_clk,
    rgb_completed_frames,
    packet_completed_frames,
    status_completed_frames,
    cfg_frame_context,
    frame_credit_request,
    dma_fault,
    capture_fault,
    cpu_command_fault,
    control_barrier_request,
    control_abort_requested,
    control_capture_aresetn,
    control_armed,
    cpu_claim,
    cpu_release,
    pipeline_drained,
    dma_drained,
    aclk_underflow,
    cpu_epoch,
    cpu_frame_id,
    video_overflow);
  output axis_enable;
  output [31:0]granted_frames;
  output [31:0]released_frames;
  output [1:0]grant_slot;
  output [1:0]available_slot;
  output boundary_fault;
  output [31:0]Q;
  output [31:0]available_epoch;
  output capture_aresetn;
  output [3:0]owner_fault_causes;
  output capture_source_fault;
  output [95:0]p_0_in0_in;
  output [63:0]closed_pixel_count;
  output monitor_ready;
  output source_quiescent;
  output configuration_locked_reg;
  output epoch_sealed;
  output [2:0]fault_causes;
  output cpu_held_reg;
  output owner_drained;
  output frame_credit_ready;
  output cpu_available;
  output source_closed;
  output budget_fault;
  output [31:0]available_frame_id;
  output barrier_complete;
  output [31:0]grant_frame_id;
  output release_accepted;
  output claim_accepted;
  input aclk;
  input vid_active_video;
  input vid_vsync;
  input common_aresetn;
  input vid_io_in_clk;
  input [31:0]rgb_completed_frames;
  input [31:0]packet_completed_frames;
  input [31:0]status_completed_frames;
  input [63:0]cfg_frame_context;
  input frame_credit_request;
  input dma_fault;
  input capture_fault;
  input cpu_command_fault;
  input control_barrier_request;
  input control_abort_requested;
  input control_capture_aresetn;
  input control_armed;
  input cpu_claim;
  input cpu_release;
  input pipeline_drained;
  input dma_drained;
  input aclk_underflow;
  input [31:0]cpu_epoch;
  input [31:0]cpu_frame_id;
  input video_overflow;

  wire [31:0]Q;
  wire aclk;
  wire aclk_resetn;
  wire aclk_underflow;
  wire admission_n_100;
  wire admission_n_101;
  wire admission_n_2;
  wire [31:0]available_epoch;
  wire [31:0]available_frame_id;
  wire [1:0]available_slot;
  wire axis_enable;
  wire barrier_complete;
  wire boundary_fault;
  wire boundary_fault_sync;
  wire budget_checked;
  wire budget_fault;
  wire budget_n_147;
  wire budget_n_148;
  wire budget_n_149;
  wire budget_n_150;
  wire budget_n_151;
  wire budget_n_152;
  wire budget_n_153;
  wire budget_n_154;
  wire budget_n_155;
  wire budget_n_156;
  wire budget_n_157;
  wire budget_n_158;
  wire budget_n_159;
  wire budget_n_160;
  wire budget_n_161;
  wire budget_n_162;
  wire budget_n_163;
  wire budget_n_36;
  wire budget_n_41;
  wire budget_n_46;
  wire budget_n_47;
  wire budget_n_48;
  wire budget_n_49;
  wire budget_n_50;
  wire budget_n_51;
  wire budget_n_52;
  wire budget_n_53;
  wire budget_n_54;
  wire budget_n_55;
  wire budget_n_56;
  wire budget_n_57;
  wire budget_n_58;
  wire budget_n_59;
  wire budget_n_60;
  wire budget_n_61;
  wire budget_n_62;
  wire budget_n_63;
  wire budget_n_64;
  wire budget_n_65;
  wire budget_n_66;
  wire budget_n_67;
  wire budget_n_68;
  wire budget_n_69;
  wire budget_n_70;
  wire budget_n_71;
  wire budget_n_72;
  wire budget_n_73;
  wire budget_n_74;
  wire budget_n_75;
  wire budget_n_76;
  wire budget_n_77;
  wire budget_n_78;
  wire budget_n_79;
  wire budget_n_80;
  wire budget_n_81;
  wire budget_n_82;
  wire capture_aresetn;
  wire capture_fault;
  wire capture_fault_held;
  wire capture_source_fault;
  wire [63:0]cfg_frame_context;
  wire claim_accepted;
  wire clear;
  wire [63:0]closed_pixel_count;
  wire closure_held;
  wire closure_held_0;
  wire common_aresetn;
  wire configuration_locked;
  wire configuration_locked1;
  wire configuration_locked_reg;
  wire control_abort_requested;
  wire control_armed;
  wire control_barrier_request;
  wire control_capture_aresetn;
  wire cpu_available;
  wire cpu_claim;
  wire cpu_command_fault;
  wire [31:0]cpu_epoch;
  wire [31:0]cpu_frame_id;
  wire cpu_held_reg;
  wire cpu_release;
  wire dma_drained;
  wire dma_fault;
  wire epoch_sealed;
  wire [2:0]fault_causes;
  wire fence_n_10;
  wire fence_n_6;
  wire fence_n_8;
  wire frame_credit_ready;
  wire frame_credit_request;
  wire [31:0]grant_frame_id;
  wire grant_ready1;
  wire [1:0]grant_slot;
  wire [31:0]granted_frames;
  wire [2:0]held_budget;
  wire monitor_ready;
  wire owner_drained;
  wire [3:0]owner_fault_causes;
  wire owner_n_115;
  wire owner_n_151;
  wire owner_n_152;
  wire owner_n_153;
  wire owner_n_154;
  wire owner_n_155;
  wire owner_n_156;
  wire owner_n_157;
  wire owner_n_158;
  wire owner_n_159;
  wire owner_n_160;
  wire owner_n_161;
  wire owner_n_162;
  wire owner_n_163;
  wire owner_n_164;
  wire owner_n_165;
  wire owner_n_166;
  wire owner_n_199;
  wire owner_n_72;
  wire [95:0]p_0_in0_in;
  wire [31:0]packet_completed_frames;
  wire pipeline_drained;
  wire release_accepted;
  wire [31:0]released_frames;
  wire request_close;
  wire request_close0;
  wire request_held;
  wire request_open;
  wire request_open0;
  wire [31:0]rgb_completed_frames;
  wire source_closed;
  wire source_quiescent;
  wire [31:0]status_completed_frames;
  wire upstream_fault0;
  wire vid_active_video;
  wire vid_io_in_clk;
  wire vid_vsync;
  wire video_overflow;

  c6v_capture_lifecycle_0_vision_source_admission admission
       (.D(request_held),
        .E(admission_n_2),
        .\FSM_sequential_state_reg[0]_0 (admission_n_100),
        .Q(held_budget),
        .S(admission_n_101),
        .\admitted_frames_reg[31]_0 (p_0_in0_in),
        .axis_enable(axis_enable),
        .boundary_fault(boundary_fault),
        .\close_sync_reg[0]_0 (request_close),
        .common_aresetn(common_aresetn),
        .\open_sync_reg[0]_0 (request_open),
        .source_quiescent(source_quiescent),
        .vid_active_video(vid_active_video),
        .vid_io_in_clk(vid_io_in_clk),
        .vid_vsync(vid_vsync));
  (* DEST_SYNC_FF = "3" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* SIM_ASSERT_CHK = "1" *) 
  (* SRC_INPUT_REG = "0" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "SINGLE" *) 
  (* XPM_MODULE = "TRUE" *) 
  c6v_capture_lifecycle_0_xpm_cdc_single boundary_cdc
       (.dest_clk(aclk),
        .dest_out(boundary_fault_sync),
        .src_clk(1'b0),
        .src_in(boundary_fault));
  c6v_capture_lifecycle_0_vision_source_budget_cdc budget
       (.CO(grant_ready1),
        .D(request_held),
        .DI({budget_n_55,budget_n_56,budget_n_57,budget_n_58}),
        .E(admission_n_2),
        .Q(Q),
        .S(admission_n_101),
        .aclk(aclk),
        .budget_checked(budget_checked),
        .budget_checked_reg_0(budget_n_41),
        .budget_checked_reg_1(budget_n_163),
        .budget_fault(budget_fault),
        .capture_fault(capture_fault),
        .capture_source_fault(capture_source_fault),
        .capture_source_fault_0(fence_n_8),
        .\closed_frame_count_reg[14]_0 ({budget_n_59,budget_n_60,budget_n_61,budget_n_62}),
        .\closed_frame_count_reg[14]_1 ({budget_n_63,budget_n_64,budget_n_65,budget_n_66}),
        .\closed_frame_count_reg[14]_2 ({budget_n_151,budget_n_152,budget_n_153,budget_n_154}),
        .\closed_frame_count_reg[22]_0 ({budget_n_67,budget_n_68,budget_n_69,budget_n_70}),
        .\closed_frame_count_reg[22]_1 ({budget_n_71,budget_n_72,budget_n_73,budget_n_74}),
        .\closed_frame_count_reg[22]_2 ({budget_n_155,budget_n_156,budget_n_157,budget_n_158}),
        .\closed_frame_count_reg[23]_0 ({budget_n_48,budget_n_49,budget_n_50}),
        .\closed_frame_count_reg[30]_0 ({budget_n_75,budget_n_76,budget_n_77,budget_n_78}),
        .\closed_frame_count_reg[30]_1 ({budget_n_79,budget_n_80,budget_n_81,budget_n_82}),
        .\closed_frame_count_reg[30]_2 ({budget_n_159,budget_n_160,budget_n_161,budget_n_162}),
        .\closed_frame_count_reg[6]_0 ({budget_n_51,budget_n_52,budget_n_53,budget_n_54}),
        .\closed_frame_count_reg[6]_1 ({budget_n_147,budget_n_148,budget_n_149,budget_n_150}),
        .\closed_frame_count_reg[8]_0 ({budget_n_46,budget_n_47}),
        .closed_pixel_count(closed_pixel_count),
        .closure_bad2_carry__0({owner_n_151,owner_n_152,owner_n_153,owner_n_154,owner_n_155,owner_n_156,owner_n_157,owner_n_158,owner_n_159,owner_n_160,owner_n_161,owner_n_162,owner_n_163,owner_n_164,owner_n_165}),
        .closure_held(closure_held_0),
        .closure_held_reg_0(closure_held),
        .closure_held_reg_1(owner_n_72),
        .common_aresetn(common_aresetn),
        .configuration_locked(configuration_locked),
        .cpu_command_fault(cpu_command_fault),
        .dest_arst(aclk_resetn),
        .dest_out(boundary_fault_sync),
        .dma_fault(dma_fault),
        .dma_fault_0(budget_n_36),
        .\granted_frames_reg[31] (owner_n_166),
        .\held_budget_reg[2]_0 (held_budget),
        .out(granted_frames),
        .owner_fault_causes(owner_fault_causes[0]),
        .p_0_in0_in(p_0_in0_in),
        .source_closed(source_closed),
        .source_protocol_fault_reg_0(admission_n_100),
        .upstream_fault0(upstream_fault0),
        .vid_io_in_clk(vid_io_in_clk));
  c6v_capture_lifecycle_0_vision_epoch_fence fence
       (.aclk(aclk),
        .aclk_underflow(aclk_underflow),
        .aclk_underflow_0(fence_n_8),
        .barrier_complete(barrier_complete),
        .capture_aresetn(capture_aresetn),
        .capture_aresetn_reg(monitor_ready),
        .capture_aresetn_reg_0(fence_n_10),
        .capture_fault_held(capture_fault_held),
        .capture_fault_held_reg_0(owner_n_199),
        .common_aresetn(common_aresetn),
        .common_aresetn_0(fence_n_6),
        .configuration_locked(configuration_locked),
        .configuration_locked1(configuration_locked1),
        .control_capture_aresetn(control_capture_aresetn),
        .epoch_sealed(epoch_sealed),
        .epoch_sealed_0(owner_n_115),
        .fault_causes(fault_causes),
        .fault_causes_2_sp_1(configuration_locked_reg),
        .reply_clean_reg_0(admission_n_100),
        .request_held_reg_0(request_close),
        .vid_io_in_clk(vid_io_in_clk),
        .video_overflow(video_overflow));
  c6v_capture_lifecycle_0_vision_frame_owner owner
       (.CO(grant_ready1),
        .D(Q),
        .DI({budget_n_55,budget_n_56,budget_n_57,budget_n_58}),
        .E(closure_held),
        .Q({owner_n_151,owner_n_152,owner_n_153,owner_n_154,owner_n_155,owner_n_156,owner_n_157,owner_n_158,owner_n_159,owner_n_160,owner_n_161,owner_n_162,owner_n_163,owner_n_164,owner_n_165}),
        .aclk(aclk),
        .available_epoch(available_epoch),
        .available_frame_id(available_frame_id),
        .available_slot(available_slot),
        .budget_checked(budget_checked),
        .capture_aresetn(capture_aresetn),
        .capture_fault_held(capture_fault_held),
        .capture_fault_held_reg(owner_n_199),
        .cfg_frame_context(cfg_frame_context),
        .claim_accepted(claim_accepted),
        .claim_accepted_reg_0(fence_n_6),
        .clear(clear),
        .closure_bad1_carry__0_0({budget_n_147,budget_n_148,budget_n_149,budget_n_150}),
        .closure_bad1_carry__1_0({budget_n_151,budget_n_152,budget_n_153,budget_n_154}),
        .closure_bad1_carry__2_0({budget_n_155,budget_n_156,budget_n_157,budget_n_158}),
        .closure_bad2_carry__0_0({budget_n_46,budget_n_47}),
        .closure_bad2_carry__1_0({budget_n_48,budget_n_49,budget_n_50}),
        .closure_held(closure_held_0),
        .closure_held_reg_0(owner_n_72),
        .closure_held_reg_1(budget_n_163),
        .common_aresetn(common_aresetn),
        .configuration_locked(configuration_locked),
        .configuration_locked1(configuration_locked1),
        .configuration_locked_reg_0(configuration_locked_reg),
        .configuration_locked_reg_1(fence_n_10),
        .control_abort_requested(control_abort_requested),
        .control_armed(control_armed),
        .control_barrier_request(control_barrier_request),
        .control_capture_aresetn(control_capture_aresetn),
        .cpu_available(cpu_available),
        .cpu_claim(cpu_claim),
        .cpu_epoch(cpu_epoch),
        .cpu_frame_id(cpu_frame_id),
        .cpu_held_reg_0(cpu_held_reg),
        .cpu_release(cpu_release),
        .cpu_release_0(owner_n_115),
        .dest_arst(aclk_resetn),
        .dma_drained(dma_drained),
        .\epoch_reg[31]_0 (monitor_ready),
        .\fault_causes_reg[0]_0 (budget_n_36),
        .frame_credit_ready(frame_credit_ready),
        .frame_credit_ready_INST_0_i_3({budget_n_79,budget_n_80,budget_n_81,budget_n_82}),
        .frame_credit_ready_INST_0_i_3_0({budget_n_75,budget_n_76,budget_n_77,budget_n_78}),
        .frame_credit_request(frame_credit_request),
        .grant_frame_id(grant_frame_id),
        .grant_ready1_carry__0_0({budget_n_51,budget_n_52,budget_n_53,budget_n_54}),
        .grant_ready1_carry__1_0({budget_n_63,budget_n_64,budget_n_65,budget_n_66}),
        .grant_ready1_carry__1_1({budget_n_59,budget_n_60,budget_n_61,budget_n_62}),
        .grant_ready1_carry__2_0({budget_n_71,budget_n_72,budget_n_73,budget_n_74}),
        .grant_ready1_carry__2_1({budget_n_67,budget_n_68,budget_n_69,budget_n_70}),
        .grant_slot(grant_slot),
        .\granted_frames_reg[31]_0 (budget_n_41),
        .\granted_frames_reg[3]_0 (owner_n_166),
        .out(granted_frames),
        .owner_drained(owner_drained),
        .owner_fault_INST_0_i_1_0({budget_n_159,budget_n_160,budget_n_161,budget_n_162}),
        .owner_fault_causes(owner_fault_causes),
        .packet_completed_frames(packet_completed_frames),
        .pipeline_drained(pipeline_drained),
        .release_accepted(release_accepted),
        .\released_frames_reg[31]_0 (released_frames),
        .request_close0(request_close0),
        .request_open0(request_open0),
        .rgb_completed_frames(rgb_completed_frames),
        .status_completed_frames(status_completed_frames),
        .upstream_fault0(upstream_fault0));
  FDRE request_close_reg
       (.C(aclk),
        .CE(1'b1),
        .D(request_close0),
        .Q(request_close),
        .R(clear));
  FDRE request_open_reg
       (.C(aclk),
        .CE(1'b1),
        .D(request_open0),
        .Q(request_open),
        .R(clear));
endmodule

(* ORIG_REF_NAME = "vision_epoch_fence" *) 
module c6v_capture_lifecycle_0_vision_epoch_fence
   (capture_aresetn_reg,
    capture_fault_held,
    epoch_sealed,
    fault_causes,
    common_aresetn_0,
    capture_aresetn,
    aclk_underflow_0,
    barrier_complete,
    capture_aresetn_reg_0,
    common_aresetn,
    vid_io_in_clk,
    aclk,
    capture_fault_held_reg_0,
    epoch_sealed_0,
    fault_causes_2_sp_1,
    control_capture_aresetn,
    aclk_underflow,
    reply_clean_reg_0,
    video_overflow,
    configuration_locked1,
    configuration_locked,
    request_held_reg_0);
  output capture_aresetn_reg;
  output capture_fault_held;
  output epoch_sealed;
  output [2:0]fault_causes;
  output common_aresetn_0;
  output capture_aresetn;
  output aclk_underflow_0;
  output barrier_complete;
  output capture_aresetn_reg_0;
  input common_aresetn;
  input vid_io_in_clk;
  input aclk;
  input capture_fault_held_reg_0;
  input epoch_sealed_0;
  input fault_causes_2_sp_1;
  input control_capture_aresetn;
  input aclk_underflow;
  input reply_clean_reg_0;
  input video_overflow;
  input configuration_locked1;
  input configuration_locked;
  input [0:0]request_held_reg_0;

  wire aclk;
  wire aclk_underflow;
  wire aclk_underflow_0;
  wire barrier_complete;
  wire capture_aresetn;
  wire capture_aresetn_reg;
  wire capture_aresetn_reg_0;
  wire capture_fault_held;
  wire capture_fault_held_reg_0;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]clean_sync;
  wire common_aresetn;
  wire common_aresetn_0;
  wire configuration_locked;
  wire configuration_locked1;
  wire control_capture_aresetn;
  wire epoch_sealed;
  wire epoch_sealed_0;
  wire [2:0]fault_causes;
  wire fault_causes_2_sn_1;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]fault_sync;
  wire monitor_n_10;
  wire monitor_n_9;
  wire overflow_held;
  wire protocol_fault;
  wire protocol_fault_i_1_n_0;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]protocol_sync;
  wire reply_clean;
  wire reply_clean1;
  wire reply_clean_i_1_n_0;
  wire reply_clean_reg_0;
  wire reply_fault_i_1_n_0;
  wire reply_fault_reg_n_0;
  wire request_held;
  wire request_held_i_1_n_0;
  wire [0:0]request_held_reg_0;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]request_sync;
  wire \request_sync[2]_i_1_n_0 ;
  wire sealed_held;
  wire source_protocol_fault_i_1_n_0;
  wire source_protocol_fault_reg_n_0;
  wire vid_io_in_clk;
  wire video_overflow;
  wire video_resetn;

  assign fault_causes_2_sn_1 = fault_causes_2_sp_1;
  FDCE capture_fault_held_reg
       (.C(aclk),
        .CE(1'b1),
        .CLR(monitor_n_9),
        .D(capture_fault_held_reg_0),
        .Q(capture_fault_held));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \clean_sync_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(monitor_n_9),
        .D(reply_clean),
        .Q(clean_sync[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \clean_sync_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(monitor_n_9),
        .D(clean_sync[0]),
        .Q(clean_sync[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \clean_sync_reg[2] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(monitor_n_9),
        .D(clean_sync[1]),
        .Q(clean_sync[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \fault_sync_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(monitor_n_9),
        .D(reply_fault_reg_n_0),
        .Q(fault_sync[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \fault_sync_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(monitor_n_9),
        .D(fault_sync[0]),
        .Q(fault_sync[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \fault_sync_reg[2] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(monitor_n_9),
        .D(fault_sync[1]),
        .Q(fault_sync[2]));
  c6v_capture_lifecycle_0_vision_source_fault_cdc monitor
       (.D(request_held),
        .aclk(aclk),
        .aclk_underflow(aclk_underflow),
        .aclk_underflow_0(aclk_underflow_0),
        .barrier_complete(barrier_complete),
        .capture_aresetn(capture_aresetn),
        .capture_aresetn_reg_0(capture_aresetn_reg),
        .capture_aresetn_reg_1(monitor_n_9),
        .capture_aresetn_reg_2(capture_aresetn_reg_0),
        .capture_fault_held(capture_fault_held),
        .\clean_sync_reg[2] (monitor_n_10),
        .common_aresetn(common_aresetn),
        .common_aresetn_0(common_aresetn_0),
        .configuration_locked(configuration_locked),
        .configuration_locked1(configuration_locked1),
        .control_capture_aresetn(control_capture_aresetn),
        .epoch_sealed(epoch_sealed),
        .epoch_sealed_0(epoch_sealed_0),
        .fault_causes(fault_causes),
        .\fault_causes[0] (fault_sync[2]),
        .fault_causes_2_sp_1(fault_causes_2_sn_1),
        .out(protocol_sync[2]),
        .protocol_fault(protocol_fault),
        .sealed_held(sealed_held),
        .sealed_held_reg(clean_sync[2]),
        .vid_io_in_clk(vid_io_in_clk),
        .video_overflow(video_overflow));
  LUT2 #(
    .INIT(4'hE)) 
    overflow_held_i_1
       (.I0(video_overflow),
        .I1(overflow_held),
        .O(reply_clean1));
  FDCE overflow_held_reg
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(\request_sync[2]_i_1_n_0 ),
        .D(reply_clean1),
        .Q(overflow_held));
  LUT5 #(
    .INIT(32'hFFFF88F8)) 
    protocol_fault_i_1
       (.I0(fault_sync[2]),
        .I1(clean_sync[2]),
        .I2(sealed_held),
        .I3(epoch_sealed_0),
        .I4(protocol_fault),
        .O(protocol_fault_i_1_n_0));
  FDCE protocol_fault_reg
       (.C(aclk),
        .CE(1'b1),
        .CLR(monitor_n_9),
        .D(protocol_fault_i_1_n_0),
        .Q(protocol_fault));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \protocol_sync_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(monitor_n_9),
        .D(source_protocol_fault_reg_n_0),
        .Q(protocol_sync[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \protocol_sync_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(monitor_n_9),
        .D(protocol_sync[0]),
        .Q(protocol_sync[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \protocol_sync_reg[2] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(monitor_n_9),
        .D(protocol_sync[1]),
        .Q(protocol_sync[2]));
  LUT6 #(
    .INIT(64'hCCCCCCCCCCCCCCDC)) 
    reply_clean_i_1
       (.I0(reply_fault_reg_n_0),
        .I1(reply_clean),
        .I2(request_sync[2]),
        .I3(reply_clean_reg_0),
        .I4(overflow_held),
        .I5(video_overflow),
        .O(reply_clean_i_1_n_0));
  FDCE reply_clean_reg
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(\request_sync[2]_i_1_n_0 ),
        .D(reply_clean_i_1_n_0),
        .Q(reply_clean));
  LUT6 #(
    .INIT(64'hF0F0F0F0F0FEF0F0)) 
    reply_fault_i_1
       (.I0(overflow_held),
        .I1(video_overflow),
        .I2(reply_fault_reg_n_0),
        .I3(reply_clean),
        .I4(request_sync[2]),
        .I5(reply_clean_reg_0),
        .O(reply_fault_i_1_n_0));
  FDCE reply_fault_reg
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(\request_sync[2]_i_1_n_0 ),
        .D(reply_fault_i_1_n_0),
        .Q(reply_fault_reg_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    request_held_i_1
       (.I0(request_held_reg_0),
        .I1(request_held),
        .O(request_held_i_1_n_0));
  FDCE request_held_reg
       (.C(aclk),
        .CE(1'b1),
        .CLR(monitor_n_9),
        .D(request_held_i_1_n_0),
        .Q(request_held));
  LUT1 #(
    .INIT(2'h1)) 
    \request_sync[2]_i_1 
       (.I0(video_resetn),
        .O(\request_sync[2]_i_1_n_0 ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \request_sync_reg[0] 
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(\request_sync[2]_i_1_n_0 ),
        .D(request_held),
        .Q(request_sync[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \request_sync_reg[1] 
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(\request_sync[2]_i_1_n_0 ),
        .D(request_sync[0]),
        .Q(request_sync[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \request_sync_reg[2] 
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(\request_sync[2]_i_1_n_0 ),
        .D(request_sync[1]),
        .Q(request_sync[2]));
  FDCE sealed_held_reg
       (.C(aclk),
        .CE(1'b1),
        .CLR(monitor_n_9),
        .D(monitor_n_10),
        .Q(sealed_held));
  LUT4 #(
    .INIT(16'hFFE0)) 
    source_protocol_fault_i_1
       (.I0(reply_clean),
        .I1(reply_fault_reg_n_0),
        .I2(reply_clean_reg_0),
        .I3(source_protocol_fault_reg_n_0),
        .O(source_protocol_fault_i_1_n_0));
  FDCE source_protocol_fault_reg
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(\request_sync[2]_i_1_n_0 ),
        .D(source_protocol_fault_i_1_n_0),
        .Q(source_protocol_fault_reg_n_0));
  (* DEF_VAL = "1'b1" *) 
  (* DEST_SYNC_FF = "3" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* INV_DEF_VAL = "1'b0" *) 
  (* RST_ACTIVE_HIGH = "0" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  (* XPM_MODULE = "TRUE" *) 
  c6v_capture_lifecycle_0_xpm_cdc_async_rst source_reset
       (.dest_arst(video_resetn),
        .dest_clk(vid_io_in_clk),
        .src_arst(common_aresetn));
endmodule

(* ORIG_REF_NAME = "vision_frame_owner" *) 
module c6v_capture_lifecycle_0_vision_frame_owner
   (owner_fault_causes,
    clear,
    available_frame_id,
    out,
    CO,
    release_accepted,
    configuration_locked,
    closure_held_reg_0,
    cpu_held_reg_0,
    claim_accepted,
    \released_frames_reg[31]_0 ,
    grant_slot,
    available_slot,
    configuration_locked1,
    request_open0,
    configuration_locked_reg_0,
    request_close0,
    cpu_release_0,
    owner_drained,
    frame_credit_ready,
    cpu_available,
    available_epoch,
    Q,
    \granted_frames_reg[3]_0 ,
    grant_frame_id,
    capture_fault_held_reg,
    aclk,
    \fault_causes_reg[0]_0 ,
    closure_bad2_carry__0_0,
    closure_bad2_carry__1_0,
    closure_bad1_carry__0_0,
    closure_bad1_carry__1_0,
    closure_bad1_carry__2_0,
    owner_fault_INST_0_i_1_0,
    DI,
    grant_ready1_carry__0_0,
    grant_ready1_carry__1_0,
    grant_ready1_carry__1_1,
    grant_ready1_carry__2_0,
    grant_ready1_carry__2_1,
    frame_credit_ready_INST_0_i_3,
    frame_credit_ready_INST_0_i_3_0,
    configuration_locked_reg_1,
    closure_held_reg_1,
    capture_aresetn,
    frame_credit_request,
    control_barrier_request,
    control_abort_requested,
    control_capture_aresetn,
    \epoch_reg[31]_0 ,
    control_armed,
    cpu_claim,
    cpu_release,
    common_aresetn,
    pipeline_drained,
    dma_drained,
    \granted_frames_reg[31]_0 ,
    claim_accepted_reg_0,
    upstream_fault0,
    cfg_frame_context,
    status_completed_frames,
    packet_completed_frames,
    rgb_completed_frames,
    budget_checked,
    closure_held,
    dest_arst,
    D,
    cpu_epoch,
    cpu_frame_id,
    capture_fault_held,
    E);
  output [3:0]owner_fault_causes;
  output clear;
  output [31:0]available_frame_id;
  output [31:0]out;
  output [0:0]CO;
  output release_accepted;
  output configuration_locked;
  output closure_held_reg_0;
  output cpu_held_reg_0;
  output claim_accepted;
  output [31:0]\released_frames_reg[31]_0 ;
  output [1:0]grant_slot;
  output [1:0]available_slot;
  output configuration_locked1;
  output request_open0;
  output configuration_locked_reg_0;
  output request_close0;
  output cpu_release_0;
  output owner_drained;
  output frame_credit_ready;
  output cpu_available;
  output [31:0]available_epoch;
  output [14:0]Q;
  output \granted_frames_reg[3]_0 ;
  output [31:0]grant_frame_id;
  output capture_fault_held_reg;
  input aclk;
  input \fault_causes_reg[0]_0 ;
  input [1:0]closure_bad2_carry__0_0;
  input [2:0]closure_bad2_carry__1_0;
  input [3:0]closure_bad1_carry__0_0;
  input [3:0]closure_bad1_carry__1_0;
  input [3:0]closure_bad1_carry__2_0;
  input [3:0]owner_fault_INST_0_i_1_0;
  input [3:0]DI;
  input [3:0]grant_ready1_carry__0_0;
  input [3:0]grant_ready1_carry__1_0;
  input [3:0]grant_ready1_carry__1_1;
  input [3:0]grant_ready1_carry__2_0;
  input [3:0]grant_ready1_carry__2_1;
  input [3:0]frame_credit_ready_INST_0_i_3;
  input [3:0]frame_credit_ready_INST_0_i_3_0;
  input configuration_locked_reg_1;
  input closure_held_reg_1;
  input capture_aresetn;
  input frame_credit_request;
  input control_barrier_request;
  input control_abort_requested;
  input control_capture_aresetn;
  input \epoch_reg[31]_0 ;
  input control_armed;
  input cpu_claim;
  input cpu_release;
  input common_aresetn;
  input pipeline_drained;
  input dma_drained;
  input \granted_frames_reg[31]_0 ;
  input claim_accepted_reg_0;
  input upstream_fault0;
  input [63:0]cfg_frame_context;
  input [31:0]status_completed_frames;
  input [31:0]packet_completed_frames;
  input [31:0]rgb_completed_frames;
  input budget_checked;
  input closure_held;
  input dest_arst;
  input [31:0]D;
  input [31:0]cpu_epoch;
  input [31:0]cpu_frame_id;
  input capture_fault_held;
  input [0:0]E;

  wire [0:0]CO;
  wire [31:0]D;
  wire [3:0]DI;
  wire [0:0]E;
  wire [14:0]Q;
  wire aclk;
  wire [31:0]available_epoch;
  wire [31:0]available_frame_id;
  wire [1:0]available_slot;
  wire budget_checked;
  wire capture_aresetn;
  wire capture_fault_held;
  wire capture_fault_held_reg;
  wire [63:0]cfg_frame_context;
  wire claim_accepted;
  wire claim_accepted_i_1_n_0;
  wire claim_accepted_reg_0;
  wire clear;
  wire closure_bad1;
  wire [3:0]closure_bad1_carry__0_0;
  wire closure_bad1_carry__0_i_1_n_0;
  wire closure_bad1_carry__0_i_2_n_0;
  wire closure_bad1_carry__0_i_3_n_0;
  wire closure_bad1_carry__0_i_4_n_0;
  wire closure_bad1_carry__0_n_0;
  wire closure_bad1_carry__0_n_1;
  wire closure_bad1_carry__0_n_2;
  wire closure_bad1_carry__0_n_3;
  wire [3:0]closure_bad1_carry__1_0;
  wire closure_bad1_carry__1_i_1_n_0;
  wire closure_bad1_carry__1_i_2_n_0;
  wire closure_bad1_carry__1_i_3_n_0;
  wire closure_bad1_carry__1_i_4_n_0;
  wire closure_bad1_carry__1_n_0;
  wire closure_bad1_carry__1_n_1;
  wire closure_bad1_carry__1_n_2;
  wire closure_bad1_carry__1_n_3;
  wire [3:0]closure_bad1_carry__2_0;
  wire closure_bad1_carry__2_i_1_n_0;
  wire closure_bad1_carry__2_i_2_n_0;
  wire closure_bad1_carry__2_i_3_n_0;
  wire closure_bad1_carry__2_i_4_n_0;
  wire closure_bad1_carry__2_n_1;
  wire closure_bad1_carry__2_n_2;
  wire closure_bad1_carry__2_n_3;
  wire closure_bad1_carry_i_1_n_0;
  wire closure_bad1_carry_i_2_n_0;
  wire closure_bad1_carry_i_3_n_0;
  wire closure_bad1_carry_i_4_n_0;
  wire closure_bad1_carry_n_0;
  wire closure_bad1_carry_n_1;
  wire closure_bad1_carry_n_2;
  wire closure_bad1_carry_n_3;
  wire closure_bad2;
  wire [1:0]closure_bad2_carry__0_0;
  wire closure_bad2_carry__0_i_2_n_0;
  wire closure_bad2_carry__0_n_0;
  wire closure_bad2_carry__0_n_1;
  wire closure_bad2_carry__0_n_2;
  wire closure_bad2_carry__0_n_3;
  wire [2:0]closure_bad2_carry__1_0;
  wire closure_bad2_carry__1_i_1_n_0;
  wire closure_bad2_carry__1_i_2_n_0;
  wire closure_bad2_carry__1_i_3_n_0;
  wire closure_bad2_carry__1_n_2;
  wire closure_bad2_carry__1_n_3;
  wire closure_bad2_carry_i_1_n_0;
  wire closure_bad2_carry_i_3_n_0;
  wire closure_bad2_carry_n_0;
  wire closure_bad2_carry_n_1;
  wire closure_bad2_carry_n_2;
  wire closure_bad2_carry_n_3;
  wire closure_held;
  wire closure_held_reg_0;
  wire closure_held_reg_1;
  wire common_aresetn;
  wire configuration_bad1;
  wire configuration_bad1_carry__0_i_1_n_0;
  wire configuration_bad1_carry__0_i_2_n_0;
  wire configuration_bad1_carry__0_i_3_n_0;
  wire configuration_bad1_carry__0_i_4_n_0;
  wire configuration_bad1_carry__0_n_0;
  wire configuration_bad1_carry__0_n_1;
  wire configuration_bad1_carry__0_n_2;
  wire configuration_bad1_carry__0_n_3;
  wire configuration_bad1_carry__1_i_1_n_0;
  wire configuration_bad1_carry__1_i_2_n_0;
  wire configuration_bad1_carry__1_i_3_n_0;
  wire configuration_bad1_carry__1_n_2;
  wire configuration_bad1_carry__1_n_3;
  wire configuration_bad1_carry_i_1_n_0;
  wire configuration_bad1_carry_i_2_n_0;
  wire configuration_bad1_carry_i_3_n_0;
  wire configuration_bad1_carry_i_4_n_0;
  wire configuration_bad1_carry_n_0;
  wire configuration_bad1_carry_n_1;
  wire configuration_bad1_carry_n_2;
  wire configuration_bad1_carry_n_3;
  wire configuration_bad2_carry__0_i_1_n_0;
  wire configuration_bad2_carry__0_i_2_n_0;
  wire configuration_bad2_carry__0_i_3_n_0;
  wire configuration_bad2_carry__0_i_4_n_0;
  wire configuration_bad2_carry__0_n_0;
  wire configuration_bad2_carry__0_n_1;
  wire configuration_bad2_carry__0_n_2;
  wire configuration_bad2_carry__0_n_3;
  wire configuration_bad2_carry__1_i_1_n_0;
  wire configuration_bad2_carry__1_i_2_n_0;
  wire configuration_bad2_carry__1_i_3_n_0;
  wire configuration_bad2_carry__1_n_1;
  wire configuration_bad2_carry__1_n_2;
  wire configuration_bad2_carry__1_n_3;
  wire configuration_bad2_carry_i_1_n_0;
  wire configuration_bad2_carry_i_2_n_0;
  wire configuration_bad2_carry_i_3_n_0;
  wire configuration_bad2_carry_i_4_n_0;
  wire configuration_bad2_carry_n_0;
  wire configuration_bad2_carry_n_1;
  wire configuration_bad2_carry_n_2;
  wire configuration_bad2_carry_n_3;
  wire configuration_locked;
  wire configuration_locked1;
  wire configuration_locked17_out;
  wire configuration_locked_reg_0;
  wire configuration_locked_reg_1;
  wire consumer_identity_carry__0_i_1_n_0;
  wire consumer_identity_carry__0_i_2_n_0;
  wire consumer_identity_carry__0_i_3_n_0;
  wire consumer_identity_carry__0_i_4_n_0;
  wire consumer_identity_carry__0_n_0;
  wire consumer_identity_carry__0_n_1;
  wire consumer_identity_carry__0_n_2;
  wire consumer_identity_carry__0_n_3;
  wire consumer_identity_carry__1_i_1_n_0;
  wire consumer_identity_carry__1_i_2_n_0;
  wire consumer_identity_carry__1_i_3_n_0;
  wire consumer_identity_carry__1_i_4_n_0;
  wire consumer_identity_carry__1_n_0;
  wire consumer_identity_carry__1_n_1;
  wire consumer_identity_carry__1_n_2;
  wire consumer_identity_carry__1_n_3;
  wire consumer_identity_carry__2_i_1_n_0;
  wire consumer_identity_carry__2_i_2_n_0;
  wire consumer_identity_carry__2_i_3_n_0;
  wire consumer_identity_carry__2_i_4_n_0;
  wire consumer_identity_carry__2_n_0;
  wire consumer_identity_carry__2_n_1;
  wire consumer_identity_carry__2_n_2;
  wire consumer_identity_carry__2_n_3;
  wire consumer_identity_carry__3_i_1_n_0;
  wire consumer_identity_carry__3_i_2_n_0;
  wire consumer_identity_carry__3_i_3_n_0;
  wire consumer_identity_carry__3_i_4_n_0;
  wire consumer_identity_carry__3_n_0;
  wire consumer_identity_carry__3_n_1;
  wire consumer_identity_carry__3_n_2;
  wire consumer_identity_carry__3_n_3;
  wire consumer_identity_carry__4_i_1_n_0;
  wire consumer_identity_carry__4_i_2_n_0;
  wire consumer_identity_carry__4_i_3_n_0;
  wire consumer_identity_carry__4_i_4_n_0;
  wire consumer_identity_carry__4_n_0;
  wire consumer_identity_carry__4_n_1;
  wire consumer_identity_carry__4_n_2;
  wire consumer_identity_carry__4_n_3;
  wire consumer_identity_carry__5_i_1_n_0;
  wire consumer_identity_carry__5_i_2_n_0;
  wire consumer_identity_carry__5_i_3_n_0;
  wire consumer_identity_carry__5_i_4_n_0;
  wire consumer_identity_carry__5_n_0;
  wire consumer_identity_carry__5_n_1;
  wire consumer_identity_carry__5_n_2;
  wire consumer_identity_carry__5_n_3;
  wire consumer_identity_carry__6_i_1_n_0;
  wire consumer_identity_carry__6_i_2_n_0;
  wire consumer_identity_carry__6_i_3_n_0;
  wire consumer_identity_carry__6_i_4_n_0;
  wire consumer_identity_carry__6_n_1;
  wire consumer_identity_carry__6_n_2;
  wire consumer_identity_carry__6_n_3;
  wire consumer_identity_carry_i_1_n_0;
  wire consumer_identity_carry_i_2_n_0;
  wire consumer_identity_carry_i_3_n_0;
  wire consumer_identity_carry_i_4_n_0;
  wire consumer_identity_carry_n_0;
  wire consumer_identity_carry_n_1;
  wire consumer_identity_carry_n_2;
  wire consumer_identity_carry_n_3;
  wire [0:0]consumer_slot;
  wire \consumer_slot[0]_i_1_n_0 ;
  wire \consumer_slot[1]_i_1_n_0 ;
  wire control_abort_requested;
  wire control_armed;
  wire control_barrier_request;
  wire control_capture_aresetn;
  wire counters_bad1;
  wire counters_bad1_carry__0_i_1_n_0;
  wire counters_bad1_carry__0_i_2_n_0;
  wire counters_bad1_carry__0_i_3_n_0;
  wire counters_bad1_carry__0_i_4_n_0;
  wire counters_bad1_carry__0_i_5_n_0;
  wire counters_bad1_carry__0_i_6_n_0;
  wire counters_bad1_carry__0_i_7_n_0;
  wire counters_bad1_carry__0_i_8_n_0;
  wire counters_bad1_carry__0_n_0;
  wire counters_bad1_carry__0_n_1;
  wire counters_bad1_carry__0_n_2;
  wire counters_bad1_carry__0_n_3;
  wire counters_bad1_carry__1_i_1_n_0;
  wire counters_bad1_carry__1_i_2_n_0;
  wire counters_bad1_carry__1_i_3_n_0;
  wire counters_bad1_carry__1_i_4_n_0;
  wire counters_bad1_carry__1_i_5_n_0;
  wire counters_bad1_carry__1_i_6_n_0;
  wire counters_bad1_carry__1_i_7_n_0;
  wire counters_bad1_carry__1_i_8_n_0;
  wire counters_bad1_carry__1_n_0;
  wire counters_bad1_carry__1_n_1;
  wire counters_bad1_carry__1_n_2;
  wire counters_bad1_carry__1_n_3;
  wire counters_bad1_carry__2_i_1_n_0;
  wire counters_bad1_carry__2_i_2_n_0;
  wire counters_bad1_carry__2_i_3_n_0;
  wire counters_bad1_carry__2_i_4_n_0;
  wire counters_bad1_carry__2_i_5_n_0;
  wire counters_bad1_carry__2_i_6_n_0;
  wire counters_bad1_carry__2_i_7_n_0;
  wire counters_bad1_carry__2_i_8_n_0;
  wire counters_bad1_carry__2_n_1;
  wire counters_bad1_carry__2_n_2;
  wire counters_bad1_carry__2_n_3;
  wire counters_bad1_carry_i_1_n_0;
  wire counters_bad1_carry_i_2_n_0;
  wire counters_bad1_carry_i_3_n_0;
  wire counters_bad1_carry_i_4_n_0;
  wire counters_bad1_carry_i_5_n_0;
  wire counters_bad1_carry_i_6_n_0;
  wire counters_bad1_carry_i_7_n_0;
  wire counters_bad1_carry_i_8_n_0;
  wire counters_bad1_carry_n_0;
  wire counters_bad1_carry_n_1;
  wire counters_bad1_carry_n_2;
  wire counters_bad1_carry_n_3;
  wire counters_bad2;
  wire counters_bad2_carry__0_i_1_n_0;
  wire counters_bad2_carry__0_i_2_n_0;
  wire counters_bad2_carry__0_i_3_n_0;
  wire counters_bad2_carry__0_i_4_n_0;
  wire counters_bad2_carry__0_i_5_n_0;
  wire counters_bad2_carry__0_i_6_n_0;
  wire counters_bad2_carry__0_i_7_n_0;
  wire counters_bad2_carry__0_i_8_n_0;
  wire counters_bad2_carry__0_n_0;
  wire counters_bad2_carry__0_n_1;
  wire counters_bad2_carry__0_n_2;
  wire counters_bad2_carry__0_n_3;
  wire counters_bad2_carry__1_i_1_n_0;
  wire counters_bad2_carry__1_i_2_n_0;
  wire counters_bad2_carry__1_i_3_n_0;
  wire counters_bad2_carry__1_i_4_n_0;
  wire counters_bad2_carry__1_i_5_n_0;
  wire counters_bad2_carry__1_i_6_n_0;
  wire counters_bad2_carry__1_i_7_n_0;
  wire counters_bad2_carry__1_i_8_n_0;
  wire counters_bad2_carry__1_n_0;
  wire counters_bad2_carry__1_n_1;
  wire counters_bad2_carry__1_n_2;
  wire counters_bad2_carry__1_n_3;
  wire counters_bad2_carry__2_i_1_n_0;
  wire counters_bad2_carry__2_i_2_n_0;
  wire counters_bad2_carry__2_i_3_n_0;
  wire counters_bad2_carry__2_i_4_n_0;
  wire counters_bad2_carry__2_i_5_n_0;
  wire counters_bad2_carry__2_i_6_n_0;
  wire counters_bad2_carry__2_i_7_n_0;
  wire counters_bad2_carry__2_i_8_n_0;
  wire counters_bad2_carry__2_n_1;
  wire counters_bad2_carry__2_n_2;
  wire counters_bad2_carry__2_n_3;
  wire counters_bad2_carry_i_1_n_0;
  wire counters_bad2_carry_i_2_n_0;
  wire counters_bad2_carry_i_3_n_0;
  wire counters_bad2_carry_i_4_n_0;
  wire counters_bad2_carry_i_5_n_0;
  wire counters_bad2_carry_i_6_n_0;
  wire counters_bad2_carry_i_7_n_0;
  wire counters_bad2_carry_i_8_n_0;
  wire counters_bad2_carry_n_0;
  wire counters_bad2_carry_n_1;
  wire counters_bad2_carry_n_2;
  wire counters_bad2_carry_n_3;
  wire counters_bad3;
  wire counters_bad3_carry__0_i_1_n_0;
  wire counters_bad3_carry__0_i_2_n_0;
  wire counters_bad3_carry__0_i_3_n_0;
  wire counters_bad3_carry__0_i_4_n_0;
  wire counters_bad3_carry__0_i_5_n_0;
  wire counters_bad3_carry__0_i_6_n_0;
  wire counters_bad3_carry__0_i_7_n_0;
  wire counters_bad3_carry__0_i_8_n_0;
  wire counters_bad3_carry__0_n_0;
  wire counters_bad3_carry__0_n_1;
  wire counters_bad3_carry__0_n_2;
  wire counters_bad3_carry__0_n_3;
  wire counters_bad3_carry__1_i_1_n_0;
  wire counters_bad3_carry__1_i_2_n_0;
  wire counters_bad3_carry__1_i_3_n_0;
  wire counters_bad3_carry__1_i_4_n_0;
  wire counters_bad3_carry__1_i_5_n_0;
  wire counters_bad3_carry__1_i_6_n_0;
  wire counters_bad3_carry__1_i_7_n_0;
  wire counters_bad3_carry__1_i_8_n_0;
  wire counters_bad3_carry__1_n_0;
  wire counters_bad3_carry__1_n_1;
  wire counters_bad3_carry__1_n_2;
  wire counters_bad3_carry__1_n_3;
  wire counters_bad3_carry__2_i_1_n_0;
  wire counters_bad3_carry__2_i_2_n_0;
  wire counters_bad3_carry__2_i_3_n_0;
  wire counters_bad3_carry__2_i_4_n_0;
  wire counters_bad3_carry__2_i_5_n_0;
  wire counters_bad3_carry__2_i_6_n_0;
  wire counters_bad3_carry__2_i_7_n_0;
  wire counters_bad3_carry__2_i_8_n_0;
  wire counters_bad3_carry__2_n_1;
  wire counters_bad3_carry__2_n_2;
  wire counters_bad3_carry__2_n_3;
  wire counters_bad3_carry_i_1_n_0;
  wire counters_bad3_carry_i_2_n_0;
  wire counters_bad3_carry_i_3_n_0;
  wire counters_bad3_carry_i_4_n_0;
  wire counters_bad3_carry_i_5_n_0;
  wire counters_bad3_carry_i_6_n_0;
  wire counters_bad3_carry_i_7_n_0;
  wire counters_bad3_carry_i_8_n_0;
  wire counters_bad3_carry_n_0;
  wire counters_bad3_carry_n_1;
  wire counters_bad3_carry_n_2;
  wire counters_bad3_carry_n_3;
  wire counters_bad4;
  wire counters_bad4_carry__0_i_1_n_0;
  wire counters_bad4_carry__0_i_2_n_0;
  wire counters_bad4_carry__0_i_3_n_0;
  wire counters_bad4_carry__0_i_4_n_0;
  wire counters_bad4_carry__0_i_5_n_0;
  wire counters_bad4_carry__0_i_6_n_0;
  wire counters_bad4_carry__0_i_7_n_0;
  wire counters_bad4_carry__0_i_8_n_0;
  wire counters_bad4_carry__0_n_0;
  wire counters_bad4_carry__0_n_1;
  wire counters_bad4_carry__0_n_2;
  wire counters_bad4_carry__0_n_3;
  wire counters_bad4_carry__1_i_1_n_0;
  wire counters_bad4_carry__1_i_2_n_0;
  wire counters_bad4_carry__1_i_3_n_0;
  wire counters_bad4_carry__1_i_4_n_0;
  wire counters_bad4_carry__1_i_5_n_0;
  wire counters_bad4_carry__1_i_6_n_0;
  wire counters_bad4_carry__1_i_7_n_0;
  wire counters_bad4_carry__1_i_8_n_0;
  wire counters_bad4_carry__1_n_0;
  wire counters_bad4_carry__1_n_1;
  wire counters_bad4_carry__1_n_2;
  wire counters_bad4_carry__1_n_3;
  wire counters_bad4_carry__2_i_1_n_0;
  wire counters_bad4_carry__2_i_2_n_0;
  wire counters_bad4_carry__2_i_3_n_0;
  wire counters_bad4_carry__2_i_4_n_0;
  wire counters_bad4_carry__2_i_5_n_0;
  wire counters_bad4_carry__2_i_6_n_0;
  wire counters_bad4_carry__2_i_7_n_0;
  wire counters_bad4_carry__2_i_8_n_0;
  wire counters_bad4_carry__2_n_1;
  wire counters_bad4_carry__2_n_2;
  wire counters_bad4_carry__2_n_3;
  wire counters_bad4_carry_i_1_n_0;
  wire counters_bad4_carry_i_2_n_0;
  wire counters_bad4_carry_i_3_n_0;
  wire counters_bad4_carry_i_4_n_0;
  wire counters_bad4_carry_i_5_n_0;
  wire counters_bad4_carry_i_6_n_0;
  wire counters_bad4_carry_i_7_n_0;
  wire counters_bad4_carry_i_8_n_0;
  wire counters_bad4_carry_n_0;
  wire counters_bad4_carry_n_1;
  wire counters_bad4_carry_n_2;
  wire counters_bad4_carry_n_3;
  wire counters_bad5;
  wire counters_bad54_in;
  wire counters_bad5_carry__0_i_1_n_0;
  wire counters_bad5_carry__0_i_2_n_0;
  wire counters_bad5_carry__0_i_3_n_0;
  wire counters_bad5_carry__0_i_4_n_0;
  wire counters_bad5_carry__0_i_5_n_0;
  wire counters_bad5_carry__0_i_6_n_0;
  wire counters_bad5_carry__0_i_7_n_0;
  wire counters_bad5_carry__0_i_8_n_0;
  wire counters_bad5_carry__0_n_0;
  wire counters_bad5_carry__0_n_1;
  wire counters_bad5_carry__0_n_2;
  wire counters_bad5_carry__0_n_3;
  wire counters_bad5_carry__1_i_1_n_0;
  wire counters_bad5_carry__1_i_2_n_0;
  wire counters_bad5_carry__1_i_3_n_0;
  wire counters_bad5_carry__1_i_4_n_0;
  wire counters_bad5_carry__1_i_5_n_0;
  wire counters_bad5_carry__1_i_6_n_0;
  wire counters_bad5_carry__1_i_7_n_0;
  wire counters_bad5_carry__1_i_8_n_0;
  wire counters_bad5_carry__1_n_0;
  wire counters_bad5_carry__1_n_1;
  wire counters_bad5_carry__1_n_2;
  wire counters_bad5_carry__1_n_3;
  wire counters_bad5_carry__2_i_1_n_0;
  wire counters_bad5_carry__2_i_2_n_0;
  wire counters_bad5_carry__2_i_3_n_0;
  wire counters_bad5_carry__2_i_4_n_0;
  wire counters_bad5_carry__2_i_5_n_0;
  wire counters_bad5_carry__2_i_6_n_0;
  wire counters_bad5_carry__2_i_7_n_0;
  wire counters_bad5_carry__2_i_8_n_0;
  wire counters_bad5_carry__2_n_1;
  wire counters_bad5_carry__2_n_2;
  wire counters_bad5_carry__2_n_3;
  wire counters_bad5_carry_i_1_n_0;
  wire counters_bad5_carry_i_2_n_0;
  wire counters_bad5_carry_i_3_n_0;
  wire counters_bad5_carry_i_4_n_0;
  wire counters_bad5_carry_i_5_n_0;
  wire counters_bad5_carry_i_6_n_0;
  wire counters_bad5_carry_i_7_n_0;
  wire counters_bad5_carry_i_8_n_0;
  wire counters_bad5_carry_n_0;
  wire counters_bad5_carry_n_1;
  wire counters_bad5_carry_n_2;
  wire counters_bad5_carry_n_3;
  wire \counters_bad5_inferred__0/i__carry__0_n_0 ;
  wire \counters_bad5_inferred__0/i__carry__0_n_1 ;
  wire \counters_bad5_inferred__0/i__carry__0_n_2 ;
  wire \counters_bad5_inferred__0/i__carry__0_n_3 ;
  wire \counters_bad5_inferred__0/i__carry__1_n_0 ;
  wire \counters_bad5_inferred__0/i__carry__1_n_1 ;
  wire \counters_bad5_inferred__0/i__carry__1_n_2 ;
  wire \counters_bad5_inferred__0/i__carry__1_n_3 ;
  wire \counters_bad5_inferred__0/i__carry__2_n_1 ;
  wire \counters_bad5_inferred__0/i__carry__2_n_2 ;
  wire \counters_bad5_inferred__0/i__carry__2_n_3 ;
  wire \counters_bad5_inferred__0/i__carry_n_0 ;
  wire \counters_bad5_inferred__0/i__carry_n_1 ;
  wire \counters_bad5_inferred__0/i__carry_n_2 ;
  wire \counters_bad5_inferred__0/i__carry_n_3 ;
  wire cpu_available;
  wire cpu_available0;
  wire cpu_available0_carry__0_i_1_n_0;
  wire cpu_available0_carry__0_i_2_n_0;
  wire cpu_available0_carry__0_i_3_n_0;
  wire cpu_available0_carry__0_i_4_n_0;
  wire cpu_available0_carry__0_i_5_n_0;
  wire cpu_available0_carry__0_i_6_n_0;
  wire cpu_available0_carry__0_i_7_n_0;
  wire cpu_available0_carry__0_i_8_n_0;
  wire cpu_available0_carry__0_n_0;
  wire cpu_available0_carry__0_n_1;
  wire cpu_available0_carry__0_n_2;
  wire cpu_available0_carry__0_n_3;
  wire cpu_available0_carry__1_i_1_n_0;
  wire cpu_available0_carry__1_i_2_n_0;
  wire cpu_available0_carry__1_i_3_n_0;
  wire cpu_available0_carry__1_i_4_n_0;
  wire cpu_available0_carry__1_i_5_n_0;
  wire cpu_available0_carry__1_i_6_n_0;
  wire cpu_available0_carry__1_i_7_n_0;
  wire cpu_available0_carry__1_i_8_n_0;
  wire cpu_available0_carry__1_n_0;
  wire cpu_available0_carry__1_n_1;
  wire cpu_available0_carry__1_n_2;
  wire cpu_available0_carry__1_n_3;
  wire cpu_available0_carry__2_i_1_n_0;
  wire cpu_available0_carry__2_i_2_n_0;
  wire cpu_available0_carry__2_i_3_n_0;
  wire cpu_available0_carry__2_i_4_n_0;
  wire cpu_available0_carry__2_i_5_n_0;
  wire cpu_available0_carry__2_i_6_n_0;
  wire cpu_available0_carry__2_i_7_n_0;
  wire cpu_available0_carry__2_i_8_n_0;
  wire cpu_available0_carry__2_n_1;
  wire cpu_available0_carry__2_n_2;
  wire cpu_available0_carry__2_n_3;
  wire cpu_available0_carry_i_1_n_0;
  wire cpu_available0_carry_i_2_n_0;
  wire cpu_available0_carry_i_3_n_0;
  wire cpu_available0_carry_i_4_n_0;
  wire cpu_available0_carry_i_5_n_0;
  wire cpu_available0_carry_i_6_n_0;
  wire cpu_available0_carry_i_7_n_0;
  wire cpu_available0_carry_i_8_n_0;
  wire cpu_available0_carry_n_0;
  wire cpu_available0_carry_n_1;
  wire cpu_available0_carry_n_2;
  wire cpu_available0_carry_n_3;
  wire cpu_available1;
  wire cpu_available1_carry__0_i_1_n_0;
  wire cpu_available1_carry__0_i_2_n_0;
  wire cpu_available1_carry__0_i_3_n_0;
  wire cpu_available1_carry__0_i_4_n_0;
  wire cpu_available1_carry__0_i_5_n_0;
  wire cpu_available1_carry__0_i_6_n_0;
  wire cpu_available1_carry__0_i_7_n_0;
  wire cpu_available1_carry__0_i_8_n_0;
  wire cpu_available1_carry__0_n_0;
  wire cpu_available1_carry__0_n_1;
  wire cpu_available1_carry__0_n_2;
  wire cpu_available1_carry__0_n_3;
  wire cpu_available1_carry__1_i_1_n_0;
  wire cpu_available1_carry__1_i_2_n_0;
  wire cpu_available1_carry__1_i_3_n_0;
  wire cpu_available1_carry__1_i_4_n_0;
  wire cpu_available1_carry__1_i_5_n_0;
  wire cpu_available1_carry__1_i_6_n_0;
  wire cpu_available1_carry__1_i_7_n_0;
  wire cpu_available1_carry__1_i_8_n_0;
  wire cpu_available1_carry__1_n_0;
  wire cpu_available1_carry__1_n_1;
  wire cpu_available1_carry__1_n_2;
  wire cpu_available1_carry__1_n_3;
  wire cpu_available1_carry__2_i_1_n_0;
  wire cpu_available1_carry__2_i_2_n_0;
  wire cpu_available1_carry__2_i_3_n_0;
  wire cpu_available1_carry__2_i_4_n_0;
  wire cpu_available1_carry__2_i_5_n_0;
  wire cpu_available1_carry__2_i_6_n_0;
  wire cpu_available1_carry__2_i_7_n_0;
  wire cpu_available1_carry__2_i_8_n_0;
  wire cpu_available1_carry__2_n_1;
  wire cpu_available1_carry__2_n_2;
  wire cpu_available1_carry__2_n_3;
  wire cpu_available1_carry_i_1_n_0;
  wire cpu_available1_carry_i_2_n_0;
  wire cpu_available1_carry_i_3_n_0;
  wire cpu_available1_carry_i_4_n_0;
  wire cpu_available1_carry_i_5_n_0;
  wire cpu_available1_carry_i_6_n_0;
  wire cpu_available1_carry_i_7_n_0;
  wire cpu_available1_carry_i_8_n_0;
  wire cpu_available1_carry_n_0;
  wire cpu_available1_carry_n_1;
  wire cpu_available1_carry_n_2;
  wire cpu_available1_carry_n_3;
  wire cpu_available2;
  wire cpu_available2_carry__0_i_1_n_0;
  wire cpu_available2_carry__0_i_2_n_0;
  wire cpu_available2_carry__0_i_3_n_0;
  wire cpu_available2_carry__0_i_4_n_0;
  wire cpu_available2_carry__0_i_5_n_0;
  wire cpu_available2_carry__0_i_6_n_0;
  wire cpu_available2_carry__0_i_7_n_0;
  wire cpu_available2_carry__0_i_8_n_0;
  wire cpu_available2_carry__0_n_0;
  wire cpu_available2_carry__0_n_1;
  wire cpu_available2_carry__0_n_2;
  wire cpu_available2_carry__0_n_3;
  wire cpu_available2_carry__1_i_1_n_0;
  wire cpu_available2_carry__1_i_2_n_0;
  wire cpu_available2_carry__1_i_3_n_0;
  wire cpu_available2_carry__1_i_4_n_0;
  wire cpu_available2_carry__1_i_5_n_0;
  wire cpu_available2_carry__1_i_6_n_0;
  wire cpu_available2_carry__1_i_7_n_0;
  wire cpu_available2_carry__1_i_8_n_0;
  wire cpu_available2_carry__1_n_0;
  wire cpu_available2_carry__1_n_1;
  wire cpu_available2_carry__1_n_2;
  wire cpu_available2_carry__1_n_3;
  wire cpu_available2_carry__2_i_1_n_0;
  wire cpu_available2_carry__2_i_2_n_0;
  wire cpu_available2_carry__2_i_3_n_0;
  wire cpu_available2_carry__2_i_4_n_0;
  wire cpu_available2_carry__2_i_5_n_0;
  wire cpu_available2_carry__2_i_6_n_0;
  wire cpu_available2_carry__2_i_7_n_0;
  wire cpu_available2_carry__2_i_8_n_0;
  wire cpu_available2_carry__2_n_1;
  wire cpu_available2_carry__2_n_2;
  wire cpu_available2_carry__2_n_3;
  wire cpu_available2_carry_i_1_n_0;
  wire cpu_available2_carry_i_2_n_0;
  wire cpu_available2_carry_i_3_n_0;
  wire cpu_available2_carry_i_4_n_0;
  wire cpu_available2_carry_i_5_n_0;
  wire cpu_available2_carry_i_6_n_0;
  wire cpu_available2_carry_i_7_n_0;
  wire cpu_available2_carry_i_8_n_0;
  wire cpu_available2_carry_n_0;
  wire cpu_available2_carry_n_1;
  wire cpu_available2_carry_n_2;
  wire cpu_available2_carry_n_3;
  wire cpu_available3;
  wire cpu_available3_carry__0_i_1_n_0;
  wire cpu_available3_carry__0_i_2_n_0;
  wire cpu_available3_carry__0_i_3_n_0;
  wire cpu_available3_carry__0_i_4_n_0;
  wire cpu_available3_carry__0_i_5_n_0;
  wire cpu_available3_carry__0_i_6_n_0;
  wire cpu_available3_carry__0_i_7_n_0;
  wire cpu_available3_carry__0_i_8_n_0;
  wire cpu_available3_carry__0_n_0;
  wire cpu_available3_carry__0_n_1;
  wire cpu_available3_carry__0_n_2;
  wire cpu_available3_carry__0_n_3;
  wire cpu_available3_carry__1_i_1_n_0;
  wire cpu_available3_carry__1_i_2_n_0;
  wire cpu_available3_carry__1_i_3_n_0;
  wire cpu_available3_carry__1_i_4_n_0;
  wire cpu_available3_carry__1_i_5_n_0;
  wire cpu_available3_carry__1_i_6_n_0;
  wire cpu_available3_carry__1_i_7_n_0;
  wire cpu_available3_carry__1_i_8_n_0;
  wire cpu_available3_carry__1_n_0;
  wire cpu_available3_carry__1_n_1;
  wire cpu_available3_carry__1_n_2;
  wire cpu_available3_carry__1_n_3;
  wire cpu_available3_carry__2_i_1_n_0;
  wire cpu_available3_carry__2_i_2_n_0;
  wire cpu_available3_carry__2_i_3_n_0;
  wire cpu_available3_carry__2_i_4_n_0;
  wire cpu_available3_carry__2_i_5_n_0;
  wire cpu_available3_carry__2_i_6_n_0;
  wire cpu_available3_carry__2_i_7_n_0;
  wire cpu_available3_carry__2_i_8_n_0;
  wire cpu_available3_carry__2_n_1;
  wire cpu_available3_carry__2_n_2;
  wire cpu_available3_carry__2_n_3;
  wire cpu_available3_carry_i_1_n_0;
  wire cpu_available3_carry_i_2_n_0;
  wire cpu_available3_carry_i_3_n_0;
  wire cpu_available3_carry_i_4_n_0;
  wire cpu_available3_carry_i_5_n_0;
  wire cpu_available3_carry_i_6_n_0;
  wire cpu_available3_carry_i_7_n_0;
  wire cpu_available3_carry_i_8_n_0;
  wire cpu_available3_carry_n_0;
  wire cpu_available3_carry_n_1;
  wire cpu_available3_carry_n_2;
  wire cpu_available3_carry_n_3;
  wire cpu_available_INST_0_i_1_n_0;
  wire cpu_available_INST_0_i_2_n_0;
  wire cpu_claim;
  wire [31:0]cpu_epoch;
  wire [31:0]cpu_frame_id;
  wire cpu_held_i_1_n_0;
  wire cpu_held_i_2_n_0;
  wire cpu_held_i_3_n_0;
  wire cpu_held_reg_0;
  wire cpu_release;
  wire cpu_release_0;
  wire dest_arst;
  wire dma_drained;
  wire \epoch[31]_i_10_n_0 ;
  wire \epoch[31]_i_11_n_0 ;
  wire \epoch[31]_i_12_n_0 ;
  wire \epoch[31]_i_13_n_0 ;
  wire \epoch[31]_i_14_n_0 ;
  wire \epoch[31]_i_15_n_0 ;
  wire \epoch[31]_i_16_n_0 ;
  wire \epoch[31]_i_17_n_0 ;
  wire \epoch[31]_i_18_n_0 ;
  wire \epoch[31]_i_19_n_0 ;
  wire \epoch[31]_i_20_n_0 ;
  wire \epoch[31]_i_21_n_0 ;
  wire \epoch[31]_i_22_n_0 ;
  wire \epoch[31]_i_23_n_0 ;
  wire \epoch[31]_i_24_n_0 ;
  wire \epoch[31]_i_25_n_0 ;
  wire \epoch[31]_i_26_n_0 ;
  wire \epoch[31]_i_27_n_0 ;
  wire \epoch[31]_i_28_n_0 ;
  wire \epoch[31]_i_29_n_0 ;
  wire \epoch[31]_i_30_n_0 ;
  wire \epoch[31]_i_31_n_0 ;
  wire \epoch[31]_i_32_n_0 ;
  wire \epoch[31]_i_33_n_0 ;
  wire \epoch[31]_i_34_n_0 ;
  wire \epoch[31]_i_35_n_0 ;
  wire \epoch[31]_i_36_n_0 ;
  wire \epoch[31]_i_37_n_0 ;
  wire \epoch[31]_i_38_n_0 ;
  wire \epoch[31]_i_39_n_0 ;
  wire \epoch[31]_i_3_n_0 ;
  wire \epoch[31]_i_40_n_0 ;
  wire \epoch[31]_i_41_n_0 ;
  wire \epoch[31]_i_42_n_0 ;
  wire \epoch[31]_i_43_n_0 ;
  wire \epoch[31]_i_44_n_0 ;
  wire \epoch[31]_i_4_n_0 ;
  wire \epoch[31]_i_5_n_0 ;
  wire \epoch[31]_i_6_n_0 ;
  wire \epoch[31]_i_7_n_0 ;
  wire \epoch[31]_i_8_n_0 ;
  wire \epoch[31]_i_9_n_0 ;
  wire \epoch_reg[31]_0 ;
  wire \fault_causes[1]_i_1_n_0 ;
  wire \fault_causes[1]_i_2_n_0 ;
  wire \fault_causes[1]_i_3_n_0 ;
  wire \fault_causes[1]_i_4_n_0 ;
  wire \fault_causes[2]_i_1_n_0 ;
  wire \fault_causes[3]_i_1_n_0 ;
  wire \fault_causes_reg[0]_0 ;
  wire \final_frame_count_reg_n_0_[10] ;
  wire \final_frame_count_reg_n_0_[11] ;
  wire \final_frame_count_reg_n_0_[18] ;
  wire \final_frame_count_reg_n_0_[19] ;
  wire \final_frame_count_reg_n_0_[20] ;
  wire \final_frame_count_reg_n_0_[24] ;
  wire \final_frame_count_reg_n_0_[25] ;
  wire \final_frame_count_reg_n_0_[26] ;
  wire \final_frame_count_reg_n_0_[27] ;
  wire \final_frame_count_reg_n_0_[28] ;
  wire \final_frame_count_reg_n_0_[29] ;
  wire \final_frame_count_reg_n_0_[30] ;
  wire \final_frame_count_reg_n_0_[31] ;
  wire \final_frame_count_reg_n_0_[3] ;
  wire \final_frame_count_reg_n_0_[4] ;
  wire \final_frame_count_reg_n_0_[5] ;
  wire \final_frame_count_reg_n_0_[9] ;
  wire [31:0]first_frame_id;
  wire frame_credit_ready;
  wire frame_credit_ready_INST_0_i_10_n_0;
  wire frame_credit_ready_INST_0_i_11_n_0;
  wire frame_credit_ready_INST_0_i_12_n_0;
  wire frame_credit_ready_INST_0_i_13_n_0;
  wire frame_credit_ready_INST_0_i_14_n_0;
  wire frame_credit_ready_INST_0_i_15_n_0;
  wire frame_credit_ready_INST_0_i_16_n_0;
  wire frame_credit_ready_INST_0_i_17_n_0;
  wire frame_credit_ready_INST_0_i_18_n_0;
  wire frame_credit_ready_INST_0_i_19_n_0;
  wire frame_credit_ready_INST_0_i_1_n_0;
  wire frame_credit_ready_INST_0_i_2_n_0;
  wire [3:0]frame_credit_ready_INST_0_i_3;
  wire [3:0]frame_credit_ready_INST_0_i_3_0;
  wire frame_credit_ready_INST_0_i_4_n_0;
  wire frame_credit_ready_INST_0_i_5_n_0;
  wire frame_credit_ready_INST_0_i_6_n_0;
  wire frame_credit_ready_INST_0_i_8_n_0;
  wire frame_credit_request;
  wire [31:0]grant_frame_id;
  wire \grant_frame_id[0]_INST_0_i_1_n_0 ;
  wire \grant_frame_id[0]_INST_0_i_2_n_0 ;
  wire \grant_frame_id[0]_INST_0_i_3_n_0 ;
  wire \grant_frame_id[0]_INST_0_i_4_n_0 ;
  wire \grant_frame_id[0]_INST_0_n_0 ;
  wire \grant_frame_id[0]_INST_0_n_1 ;
  wire \grant_frame_id[0]_INST_0_n_2 ;
  wire \grant_frame_id[0]_INST_0_n_3 ;
  wire \grant_frame_id[12]_INST_0_i_1_n_0 ;
  wire \grant_frame_id[12]_INST_0_i_2_n_0 ;
  wire \grant_frame_id[12]_INST_0_i_3_n_0 ;
  wire \grant_frame_id[12]_INST_0_i_4_n_0 ;
  wire \grant_frame_id[12]_INST_0_n_0 ;
  wire \grant_frame_id[12]_INST_0_n_1 ;
  wire \grant_frame_id[12]_INST_0_n_2 ;
  wire \grant_frame_id[12]_INST_0_n_3 ;
  wire \grant_frame_id[16]_INST_0_i_1_n_0 ;
  wire \grant_frame_id[16]_INST_0_i_2_n_0 ;
  wire \grant_frame_id[16]_INST_0_i_3_n_0 ;
  wire \grant_frame_id[16]_INST_0_i_4_n_0 ;
  wire \grant_frame_id[16]_INST_0_n_0 ;
  wire \grant_frame_id[16]_INST_0_n_1 ;
  wire \grant_frame_id[16]_INST_0_n_2 ;
  wire \grant_frame_id[16]_INST_0_n_3 ;
  wire \grant_frame_id[20]_INST_0_i_1_n_0 ;
  wire \grant_frame_id[20]_INST_0_i_2_n_0 ;
  wire \grant_frame_id[20]_INST_0_i_3_n_0 ;
  wire \grant_frame_id[20]_INST_0_i_4_n_0 ;
  wire \grant_frame_id[20]_INST_0_n_0 ;
  wire \grant_frame_id[20]_INST_0_n_1 ;
  wire \grant_frame_id[20]_INST_0_n_2 ;
  wire \grant_frame_id[20]_INST_0_n_3 ;
  wire \grant_frame_id[24]_INST_0_i_1_n_0 ;
  wire \grant_frame_id[24]_INST_0_i_2_n_0 ;
  wire \grant_frame_id[24]_INST_0_i_3_n_0 ;
  wire \grant_frame_id[24]_INST_0_i_4_n_0 ;
  wire \grant_frame_id[24]_INST_0_n_0 ;
  wire \grant_frame_id[24]_INST_0_n_1 ;
  wire \grant_frame_id[24]_INST_0_n_2 ;
  wire \grant_frame_id[24]_INST_0_n_3 ;
  wire \grant_frame_id[28]_INST_0_i_1_n_0 ;
  wire \grant_frame_id[28]_INST_0_i_2_n_0 ;
  wire \grant_frame_id[28]_INST_0_i_3_n_0 ;
  wire \grant_frame_id[28]_INST_0_i_4_n_0 ;
  wire \grant_frame_id[28]_INST_0_n_0 ;
  wire \grant_frame_id[28]_INST_0_n_1 ;
  wire \grant_frame_id[28]_INST_0_n_2 ;
  wire \grant_frame_id[28]_INST_0_n_3 ;
  wire \grant_frame_id[4]_INST_0_i_1_n_0 ;
  wire \grant_frame_id[4]_INST_0_i_2_n_0 ;
  wire \grant_frame_id[4]_INST_0_i_3_n_0 ;
  wire \grant_frame_id[4]_INST_0_i_4_n_0 ;
  wire \grant_frame_id[4]_INST_0_n_0 ;
  wire \grant_frame_id[4]_INST_0_n_1 ;
  wire \grant_frame_id[4]_INST_0_n_2 ;
  wire \grant_frame_id[4]_INST_0_n_3 ;
  wire \grant_frame_id[8]_INST_0_i_1_n_0 ;
  wire \grant_frame_id[8]_INST_0_i_2_n_0 ;
  wire \grant_frame_id[8]_INST_0_i_3_n_0 ;
  wire \grant_frame_id[8]_INST_0_i_4_n_0 ;
  wire \grant_frame_id[8]_INST_0_n_0 ;
  wire \grant_frame_id[8]_INST_0_n_1 ;
  wire \grant_frame_id[8]_INST_0_n_2 ;
  wire \grant_frame_id[8]_INST_0_n_3 ;
  wire [3:0]grant_ready1_carry__0_0;
  wire grant_ready1_carry__0_n_0;
  wire grant_ready1_carry__0_n_1;
  wire grant_ready1_carry__0_n_2;
  wire grant_ready1_carry__0_n_3;
  wire [3:0]grant_ready1_carry__1_0;
  wire [3:0]grant_ready1_carry__1_1;
  wire grant_ready1_carry__1_n_0;
  wire grant_ready1_carry__1_n_1;
  wire grant_ready1_carry__1_n_2;
  wire grant_ready1_carry__1_n_3;
  wire [3:0]grant_ready1_carry__2_0;
  wire [3:0]grant_ready1_carry__2_1;
  wire grant_ready1_carry__2_n_1;
  wire grant_ready1_carry__2_n_2;
  wire grant_ready1_carry__2_n_3;
  wire grant_ready1_carry_n_0;
  wire grant_ready1_carry_n_1;
  wire grant_ready1_carry_n_2;
  wire grant_ready1_carry_n_3;
  wire [31:0]grant_ready40_out;
  wire grant_ready4_carry__0_i_1_n_0;
  wire grant_ready4_carry__0_i_2_n_0;
  wire grant_ready4_carry__0_i_3_n_0;
  wire grant_ready4_carry__0_i_4_n_0;
  wire grant_ready4_carry__0_n_0;
  wire grant_ready4_carry__0_n_1;
  wire grant_ready4_carry__0_n_2;
  wire grant_ready4_carry__0_n_3;
  wire grant_ready4_carry__1_i_1_n_0;
  wire grant_ready4_carry__1_i_2_n_0;
  wire grant_ready4_carry__1_i_3_n_0;
  wire grant_ready4_carry__1_i_4_n_0;
  wire grant_ready4_carry__1_n_0;
  wire grant_ready4_carry__1_n_1;
  wire grant_ready4_carry__1_n_2;
  wire grant_ready4_carry__1_n_3;
  wire grant_ready4_carry__2_i_1_n_0;
  wire grant_ready4_carry__2_i_2_n_0;
  wire grant_ready4_carry__2_i_3_n_0;
  wire grant_ready4_carry__2_i_4_n_0;
  wire grant_ready4_carry__2_n_0;
  wire grant_ready4_carry__2_n_1;
  wire grant_ready4_carry__2_n_2;
  wire grant_ready4_carry__2_n_3;
  wire grant_ready4_carry__3_i_1_n_0;
  wire grant_ready4_carry__3_i_2_n_0;
  wire grant_ready4_carry__3_i_3_n_0;
  wire grant_ready4_carry__3_i_4_n_0;
  wire grant_ready4_carry__3_n_0;
  wire grant_ready4_carry__3_n_1;
  wire grant_ready4_carry__3_n_2;
  wire grant_ready4_carry__3_n_3;
  wire grant_ready4_carry__4_i_1_n_0;
  wire grant_ready4_carry__4_i_2_n_0;
  wire grant_ready4_carry__4_i_3_n_0;
  wire grant_ready4_carry__4_i_4_n_0;
  wire grant_ready4_carry__4_n_0;
  wire grant_ready4_carry__4_n_1;
  wire grant_ready4_carry__4_n_2;
  wire grant_ready4_carry__4_n_3;
  wire grant_ready4_carry__5_i_1_n_0;
  wire grant_ready4_carry__5_i_2_n_0;
  wire grant_ready4_carry__5_i_3_n_0;
  wire grant_ready4_carry__5_i_4_n_0;
  wire grant_ready4_carry__5_n_0;
  wire grant_ready4_carry__5_n_1;
  wire grant_ready4_carry__5_n_2;
  wire grant_ready4_carry__5_n_3;
  wire grant_ready4_carry__6_i_1_n_0;
  wire grant_ready4_carry__6_i_2_n_0;
  wire grant_ready4_carry__6_i_3_n_0;
  wire grant_ready4_carry__6_i_4_n_0;
  wire grant_ready4_carry__6_n_1;
  wire grant_ready4_carry__6_n_2;
  wire grant_ready4_carry__6_n_3;
  wire grant_ready4_carry_i_1_n_0;
  wire grant_ready4_carry_i_2_n_0;
  wire grant_ready4_carry_i_3_n_0;
  wire grant_ready4_carry_i_4_n_0;
  wire grant_ready4_carry_n_0;
  wire grant_ready4_carry_n_1;
  wire grant_ready4_carry_n_2;
  wire grant_ready4_carry_n_3;
  wire [1:0]grant_slot;
  wire \granted_frames[3]_i_2_n_0 ;
  wire \granted_frames_reg[11]_i_1_n_0 ;
  wire \granted_frames_reg[11]_i_1_n_1 ;
  wire \granted_frames_reg[11]_i_1_n_2 ;
  wire \granted_frames_reg[11]_i_1_n_3 ;
  wire \granted_frames_reg[11]_i_1_n_4 ;
  wire \granted_frames_reg[11]_i_1_n_5 ;
  wire \granted_frames_reg[11]_i_1_n_6 ;
  wire \granted_frames_reg[11]_i_1_n_7 ;
  wire \granted_frames_reg[15]_i_1_n_0 ;
  wire \granted_frames_reg[15]_i_1_n_1 ;
  wire \granted_frames_reg[15]_i_1_n_2 ;
  wire \granted_frames_reg[15]_i_1_n_3 ;
  wire \granted_frames_reg[15]_i_1_n_4 ;
  wire \granted_frames_reg[15]_i_1_n_5 ;
  wire \granted_frames_reg[15]_i_1_n_6 ;
  wire \granted_frames_reg[15]_i_1_n_7 ;
  wire \granted_frames_reg[19]_i_1_n_0 ;
  wire \granted_frames_reg[19]_i_1_n_1 ;
  wire \granted_frames_reg[19]_i_1_n_2 ;
  wire \granted_frames_reg[19]_i_1_n_3 ;
  wire \granted_frames_reg[19]_i_1_n_4 ;
  wire \granted_frames_reg[19]_i_1_n_5 ;
  wire \granted_frames_reg[19]_i_1_n_6 ;
  wire \granted_frames_reg[19]_i_1_n_7 ;
  wire \granted_frames_reg[23]_i_1_n_0 ;
  wire \granted_frames_reg[23]_i_1_n_1 ;
  wire \granted_frames_reg[23]_i_1_n_2 ;
  wire \granted_frames_reg[23]_i_1_n_3 ;
  wire \granted_frames_reg[23]_i_1_n_4 ;
  wire \granted_frames_reg[23]_i_1_n_5 ;
  wire \granted_frames_reg[23]_i_1_n_6 ;
  wire \granted_frames_reg[23]_i_1_n_7 ;
  wire \granted_frames_reg[27]_i_1_n_0 ;
  wire \granted_frames_reg[27]_i_1_n_1 ;
  wire \granted_frames_reg[27]_i_1_n_2 ;
  wire \granted_frames_reg[27]_i_1_n_3 ;
  wire \granted_frames_reg[27]_i_1_n_4 ;
  wire \granted_frames_reg[27]_i_1_n_5 ;
  wire \granted_frames_reg[27]_i_1_n_6 ;
  wire \granted_frames_reg[27]_i_1_n_7 ;
  wire \granted_frames_reg[31]_0 ;
  wire \granted_frames_reg[31]_i_1_n_1 ;
  wire \granted_frames_reg[31]_i_1_n_2 ;
  wire \granted_frames_reg[31]_i_1_n_3 ;
  wire \granted_frames_reg[31]_i_1_n_4 ;
  wire \granted_frames_reg[31]_i_1_n_5 ;
  wire \granted_frames_reg[31]_i_1_n_6 ;
  wire \granted_frames_reg[31]_i_1_n_7 ;
  wire \granted_frames_reg[3]_0 ;
  wire \granted_frames_reg[3]_i_1_n_0 ;
  wire \granted_frames_reg[3]_i_1_n_1 ;
  wire \granted_frames_reg[3]_i_1_n_2 ;
  wire \granted_frames_reg[3]_i_1_n_3 ;
  wire \granted_frames_reg[3]_i_1_n_4 ;
  wire \granted_frames_reg[3]_i_1_n_5 ;
  wire \granted_frames_reg[3]_i_1_n_6 ;
  wire \granted_frames_reg[3]_i_1_n_7 ;
  wire \granted_frames_reg[7]_i_1_n_0 ;
  wire \granted_frames_reg[7]_i_1_n_1 ;
  wire \granted_frames_reg[7]_i_1_n_2 ;
  wire \granted_frames_reg[7]_i_1_n_3 ;
  wire \granted_frames_reg[7]_i_1_n_4 ;
  wire \granted_frames_reg[7]_i_1_n_5 ;
  wire \granted_frames_reg[7]_i_1_n_6 ;
  wire \granted_frames_reg[7]_i_1_n_7 ;
  wire i__carry__0_i_1__0_n_0;
  wire i__carry__0_i_1_n_0;
  wire i__carry__0_i_2__0_n_0;
  wire i__carry__0_i_2_n_0;
  wire i__carry__0_i_3__0_n_0;
  wire i__carry__0_i_3_n_0;
  wire i__carry__0_i_4__0_n_0;
  wire i__carry__0_i_4_n_0;
  wire i__carry__0_i_5_n_0;
  wire i__carry__0_i_6_n_0;
  wire i__carry__0_i_7_n_0;
  wire i__carry__0_i_8_n_0;
  wire i__carry__1_i_1__0_n_0;
  wire i__carry__1_i_1_n_0;
  wire i__carry__1_i_2__0_n_0;
  wire i__carry__1_i_2_n_0;
  wire i__carry__1_i_3__0_n_0;
  wire i__carry__1_i_3_n_0;
  wire i__carry__1_i_4_n_0;
  wire i__carry__1_i_5_n_0;
  wire i__carry__1_i_6_n_0;
  wire i__carry__1_i_7_n_0;
  wire i__carry__1_i_8_n_0;
  wire i__carry__2_i_1_n_0;
  wire i__carry__2_i_2_n_0;
  wire i__carry__2_i_3_n_0;
  wire i__carry__2_i_4_n_0;
  wire i__carry__2_i_5_n_0;
  wire i__carry__2_i_6_n_0;
  wire i__carry__2_i_7_n_0;
  wire i__carry__2_i_8_n_0;
  wire i__carry_i_1__0_n_0;
  wire i__carry_i_1_n_0;
  wire i__carry_i_2__0_n_0;
  wire i__carry_i_2_n_0;
  wire i__carry_i_3__0_n_0;
  wire i__carry_i_3_n_0;
  wire i__carry_i_4__0_n_0;
  wire i__carry_i_4_n_0;
  wire i__carry_i_5_n_0;
  wire i__carry_i_6_n_0;
  wire i__carry_i_7_n_0;
  wire i__carry_i_8_n_0;
  wire [31:0]out;
  wire owner_drained;
  wire owner_drained4;
  wire owner_drained4_carry__0_i_1_n_0;
  wire owner_drained4_carry__0_i_2_n_0;
  wire owner_drained4_carry__0_i_3_n_0;
  wire owner_drained4_carry__0_i_4_n_0;
  wire owner_drained4_carry__0_n_0;
  wire owner_drained4_carry__0_n_1;
  wire owner_drained4_carry__0_n_2;
  wire owner_drained4_carry__0_n_3;
  wire owner_drained4_carry__1_i_1_n_0;
  wire owner_drained4_carry__1_i_2_n_0;
  wire owner_drained4_carry__1_i_3_n_0;
  wire owner_drained4_carry__1_n_2;
  wire owner_drained4_carry__1_n_3;
  wire owner_drained4_carry_i_1_n_0;
  wire owner_drained4_carry_i_2_n_0;
  wire owner_drained4_carry_i_3_n_0;
  wire owner_drained4_carry_i_4_n_0;
  wire owner_drained4_carry_n_0;
  wire owner_drained4_carry_n_1;
  wire owner_drained4_carry_n_2;
  wire owner_drained4_carry_n_3;
  wire owner_drained5;
  wire owner_drained5_carry__0_i_1_n_0;
  wire owner_drained5_carry__0_i_2_n_0;
  wire owner_drained5_carry__0_i_3_n_0;
  wire owner_drained5_carry__0_i_4_n_0;
  wire owner_drained5_carry__0_n_0;
  wire owner_drained5_carry__0_n_1;
  wire owner_drained5_carry__0_n_2;
  wire owner_drained5_carry__0_n_3;
  wire owner_drained5_carry__1_i_1_n_0;
  wire owner_drained5_carry__1_i_2_n_0;
  wire owner_drained5_carry__1_i_3_n_0;
  wire owner_drained5_carry__1_n_2;
  wire owner_drained5_carry__1_n_3;
  wire owner_drained5_carry_i_1_n_0;
  wire owner_drained5_carry_i_2_n_0;
  wire owner_drained5_carry_i_3_n_0;
  wire owner_drained5_carry_i_4_n_0;
  wire owner_drained5_carry_n_0;
  wire owner_drained5_carry_n_1;
  wire owner_drained5_carry_n_2;
  wire owner_drained5_carry_n_3;
  wire owner_drained6;
  wire owner_drained6_carry__0_i_1_n_0;
  wire owner_drained6_carry__0_i_2_n_0;
  wire owner_drained6_carry__0_i_3_n_0;
  wire owner_drained6_carry__0_i_4_n_0;
  wire owner_drained6_carry__0_n_0;
  wire owner_drained6_carry__0_n_1;
  wire owner_drained6_carry__0_n_2;
  wire owner_drained6_carry__0_n_3;
  wire owner_drained6_carry__1_i_1_n_0;
  wire owner_drained6_carry__1_i_2_n_0;
  wire owner_drained6_carry__1_i_3_n_0;
  wire owner_drained6_carry__1_n_2;
  wire owner_drained6_carry__1_n_3;
  wire owner_drained6_carry_i_1_n_0;
  wire owner_drained6_carry_i_2_n_0;
  wire owner_drained6_carry_i_3_n_0;
  wire owner_drained6_carry_i_4_n_0;
  wire owner_drained6_carry_n_0;
  wire owner_drained6_carry_n_1;
  wire owner_drained6_carry_n_2;
  wire owner_drained6_carry_n_3;
  wire owner_drained7;
  wire owner_drained7_carry__0_i_1_n_0;
  wire owner_drained7_carry__0_i_2_n_0;
  wire owner_drained7_carry__0_i_3_n_0;
  wire owner_drained7_carry__0_i_4_n_0;
  wire owner_drained7_carry__0_n_0;
  wire owner_drained7_carry__0_n_1;
  wire owner_drained7_carry__0_n_2;
  wire owner_drained7_carry__0_n_3;
  wire owner_drained7_carry__1_i_1_n_0;
  wire owner_drained7_carry__1_i_2_n_0;
  wire owner_drained7_carry__1_i_3_n_0;
  wire owner_drained7_carry__1_n_2;
  wire owner_drained7_carry__1_n_3;
  wire owner_drained7_carry_i_1_n_0;
  wire owner_drained7_carry_i_2_n_0;
  wire owner_drained7_carry_i_3_n_0;
  wire owner_drained7_carry_i_4_n_0;
  wire owner_drained7_carry_n_0;
  wire owner_drained7_carry_n_1;
  wire owner_drained7_carry_n_2;
  wire owner_drained7_carry_n_3;
  wire owner_drained8;
  wire owner_drained8_carry__0_i_1_n_0;
  wire owner_drained8_carry__0_i_2_n_0;
  wire owner_drained8_carry__0_i_3_n_0;
  wire owner_drained8_carry__0_i_4_n_0;
  wire owner_drained8_carry__0_n_0;
  wire owner_drained8_carry__0_n_1;
  wire owner_drained8_carry__0_n_2;
  wire owner_drained8_carry__0_n_3;
  wire owner_drained8_carry__1_i_1_n_0;
  wire owner_drained8_carry__1_i_2_n_0;
  wire owner_drained8_carry__1_i_3_n_0;
  wire owner_drained8_carry__1_n_2;
  wire owner_drained8_carry__1_n_3;
  wire owner_drained8_carry_i_1_n_0;
  wire owner_drained8_carry_i_2_n_0;
  wire owner_drained8_carry_i_3_n_0;
  wire owner_drained8_carry_i_4_n_0;
  wire owner_drained8_carry_n_0;
  wire owner_drained8_carry_n_1;
  wire owner_drained8_carry_n_2;
  wire owner_drained8_carry_n_3;
  wire owner_drained_INST_0_i_1_n_0;
  wire owner_drained_INST_0_i_2_n_0;
  wire [3:0]owner_fault_INST_0_i_1_0;
  wire owner_fault_INST_0_i_1_n_0;
  wire owner_fault_INST_0_i_2_n_0;
  wire owner_fault_INST_0_i_3_n_0;
  wire owner_fault_INST_0_i_4_n_0;
  wire [3:0]owner_fault_causes;
  wire p_0_in28_in;
  wire [31:0]packet_completed_frames;
  wire pipeline_drained;
  wire [31:0]previous_packet;
  wire [31:0]previous_rgb;
  wire [31:0]previous_status;
  wire producer_slot;
  wire \producer_slot[0]_i_1_n_0 ;
  wire \producer_slot[1]_i_3_n_0 ;
  wire release_accepted;
  wire \released_frames[3]_i_2_n_0 ;
  wire \released_frames_reg[11]_i_1_n_0 ;
  wire \released_frames_reg[11]_i_1_n_1 ;
  wire \released_frames_reg[11]_i_1_n_2 ;
  wire \released_frames_reg[11]_i_1_n_3 ;
  wire \released_frames_reg[11]_i_1_n_4 ;
  wire \released_frames_reg[11]_i_1_n_5 ;
  wire \released_frames_reg[11]_i_1_n_6 ;
  wire \released_frames_reg[11]_i_1_n_7 ;
  wire \released_frames_reg[15]_i_1_n_0 ;
  wire \released_frames_reg[15]_i_1_n_1 ;
  wire \released_frames_reg[15]_i_1_n_2 ;
  wire \released_frames_reg[15]_i_1_n_3 ;
  wire \released_frames_reg[15]_i_1_n_4 ;
  wire \released_frames_reg[15]_i_1_n_5 ;
  wire \released_frames_reg[15]_i_1_n_6 ;
  wire \released_frames_reg[15]_i_1_n_7 ;
  wire \released_frames_reg[19]_i_1_n_0 ;
  wire \released_frames_reg[19]_i_1_n_1 ;
  wire \released_frames_reg[19]_i_1_n_2 ;
  wire \released_frames_reg[19]_i_1_n_3 ;
  wire \released_frames_reg[19]_i_1_n_4 ;
  wire \released_frames_reg[19]_i_1_n_5 ;
  wire \released_frames_reg[19]_i_1_n_6 ;
  wire \released_frames_reg[19]_i_1_n_7 ;
  wire \released_frames_reg[23]_i_1_n_0 ;
  wire \released_frames_reg[23]_i_1_n_1 ;
  wire \released_frames_reg[23]_i_1_n_2 ;
  wire \released_frames_reg[23]_i_1_n_3 ;
  wire \released_frames_reg[23]_i_1_n_4 ;
  wire \released_frames_reg[23]_i_1_n_5 ;
  wire \released_frames_reg[23]_i_1_n_6 ;
  wire \released_frames_reg[23]_i_1_n_7 ;
  wire \released_frames_reg[27]_i_1_n_0 ;
  wire \released_frames_reg[27]_i_1_n_1 ;
  wire \released_frames_reg[27]_i_1_n_2 ;
  wire \released_frames_reg[27]_i_1_n_3 ;
  wire \released_frames_reg[27]_i_1_n_4 ;
  wire \released_frames_reg[27]_i_1_n_5 ;
  wire \released_frames_reg[27]_i_1_n_6 ;
  wire \released_frames_reg[27]_i_1_n_7 ;
  wire [31:0]\released_frames_reg[31]_0 ;
  wire \released_frames_reg[31]_i_1_n_1 ;
  wire \released_frames_reg[31]_i_1_n_2 ;
  wire \released_frames_reg[31]_i_1_n_3 ;
  wire \released_frames_reg[31]_i_1_n_4 ;
  wire \released_frames_reg[31]_i_1_n_5 ;
  wire \released_frames_reg[31]_i_1_n_6 ;
  wire \released_frames_reg[31]_i_1_n_7 ;
  wire \released_frames_reg[3]_i_1_n_0 ;
  wire \released_frames_reg[3]_i_1_n_1 ;
  wire \released_frames_reg[3]_i_1_n_2 ;
  wire \released_frames_reg[3]_i_1_n_3 ;
  wire \released_frames_reg[3]_i_1_n_4 ;
  wire \released_frames_reg[3]_i_1_n_5 ;
  wire \released_frames_reg[3]_i_1_n_6 ;
  wire \released_frames_reg[3]_i_1_n_7 ;
  wire \released_frames_reg[7]_i_1_n_0 ;
  wire \released_frames_reg[7]_i_1_n_1 ;
  wire \released_frames_reg[7]_i_1_n_2 ;
  wire \released_frames_reg[7]_i_1_n_3 ;
  wire \released_frames_reg[7]_i_1_n_4 ;
  wire \released_frames_reg[7]_i_1_n_5 ;
  wire \released_frames_reg[7]_i_1_n_6 ;
  wire \released_frames_reg[7]_i_1_n_7 ;
  wire request_close0;
  wire request_open0;
  wire [31:0]rgb_completed_frames;
  wire [31:0]status_completed_frames;
  wire token_matches0;
  wire token_matches00_out;
  wire token_matches0_carry__0_i_1_n_0;
  wire token_matches0_carry__0_i_2_n_0;
  wire token_matches0_carry__0_i_3_n_0;
  wire token_matches0_carry__0_i_4_n_0;
  wire token_matches0_carry__0_n_0;
  wire token_matches0_carry__0_n_1;
  wire token_matches0_carry__0_n_2;
  wire token_matches0_carry__0_n_3;
  wire token_matches0_carry__1_i_1_n_0;
  wire token_matches0_carry__1_i_2_n_0;
  wire token_matches0_carry__1_i_3_n_0;
  wire token_matches0_carry__1_n_2;
  wire token_matches0_carry__1_n_3;
  wire token_matches0_carry_i_1_n_0;
  wire token_matches0_carry_i_2_n_0;
  wire token_matches0_carry_i_3_n_0;
  wire token_matches0_carry_i_4_n_0;
  wire token_matches0_carry_n_0;
  wire token_matches0_carry_n_1;
  wire token_matches0_carry_n_2;
  wire token_matches0_carry_n_3;
  wire \token_matches0_inferred__0/i__carry__0_n_0 ;
  wire \token_matches0_inferred__0/i__carry__0_n_1 ;
  wire \token_matches0_inferred__0/i__carry__0_n_2 ;
  wire \token_matches0_inferred__0/i__carry__0_n_3 ;
  wire \token_matches0_inferred__0/i__carry__1_n_2 ;
  wire \token_matches0_inferred__0/i__carry__1_n_3 ;
  wire \token_matches0_inferred__0/i__carry_n_0 ;
  wire \token_matches0_inferred__0/i__carry_n_1 ;
  wire \token_matches0_inferred__0/i__carry_n_2 ;
  wire \token_matches0_inferred__0/i__carry_n_3 ;
  wire upstream_fault0;
  wire [3:0]NLW_closure_bad1_carry_O_UNCONNECTED;
  wire [3:0]NLW_closure_bad1_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_closure_bad1_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_closure_bad1_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_closure_bad2_carry_O_UNCONNECTED;
  wire [3:0]NLW_closure_bad2_carry__0_O_UNCONNECTED;
  wire [3:3]NLW_closure_bad2_carry__1_CO_UNCONNECTED;
  wire [3:0]NLW_closure_bad2_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_configuration_bad1_carry_O_UNCONNECTED;
  wire [3:0]NLW_configuration_bad1_carry__0_O_UNCONNECTED;
  wire [3:3]NLW_configuration_bad1_carry__1_CO_UNCONNECTED;
  wire [3:0]NLW_configuration_bad1_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_configuration_bad2_carry_O_UNCONNECTED;
  wire [3:0]NLW_configuration_bad2_carry__0_O_UNCONNECTED;
  wire [3:3]NLW_configuration_bad2_carry__1_CO_UNCONNECTED;
  wire [3:0]NLW_configuration_bad2_carry__1_O_UNCONNECTED;
  wire [3:3]NLW_consumer_identity_carry__6_CO_UNCONNECTED;
  wire [3:0]NLW_counters_bad1_carry_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad1_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad1_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad1_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad2_carry_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad2_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad2_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad2_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad3_carry_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad3_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad3_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad3_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad4_carry_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad4_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad4_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad4_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad5_carry_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad5_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad5_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_counters_bad5_carry__2_O_UNCONNECTED;
  wire [3:0]\NLW_counters_bad5_inferred__0/i__carry_O_UNCONNECTED ;
  wire [3:0]\NLW_counters_bad5_inferred__0/i__carry__0_O_UNCONNECTED ;
  wire [3:0]\NLW_counters_bad5_inferred__0/i__carry__1_O_UNCONNECTED ;
  wire [3:0]\NLW_counters_bad5_inferred__0/i__carry__2_O_UNCONNECTED ;
  wire [3:0]NLW_cpu_available0_carry_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available0_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available0_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available0_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available1_carry_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available1_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available1_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available1_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available2_carry_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available2_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available2_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available2_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available3_carry_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available3_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available3_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_cpu_available3_carry__2_O_UNCONNECTED;
  wire [3:1]NLW_frame_credit_ready_INST_0_i_7_CO_UNCONNECTED;
  wire [3:0]NLW_frame_credit_ready_INST_0_i_7_O_UNCONNECTED;
  wire [3:0]NLW_grant_ready1_carry_O_UNCONNECTED;
  wire [3:0]NLW_grant_ready1_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_grant_ready1_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_grant_ready1_carry__2_O_UNCONNECTED;
  wire [3:3]NLW_grant_ready4_carry__6_CO_UNCONNECTED;
  wire [3:3]\NLW_granted_frames_reg[31]_i_1_CO_UNCONNECTED ;
  wire [3:0]NLW_owner_drained4_carry_O_UNCONNECTED;
  wire [3:0]NLW_owner_drained4_carry__0_O_UNCONNECTED;
  wire [3:3]NLW_owner_drained4_carry__1_CO_UNCONNECTED;
  wire [3:0]NLW_owner_drained4_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_owner_drained5_carry_O_UNCONNECTED;
  wire [3:0]NLW_owner_drained5_carry__0_O_UNCONNECTED;
  wire [3:3]NLW_owner_drained5_carry__1_CO_UNCONNECTED;
  wire [3:0]NLW_owner_drained5_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_owner_drained6_carry_O_UNCONNECTED;
  wire [3:0]NLW_owner_drained6_carry__0_O_UNCONNECTED;
  wire [3:3]NLW_owner_drained6_carry__1_CO_UNCONNECTED;
  wire [3:0]NLW_owner_drained6_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_owner_drained7_carry_O_UNCONNECTED;
  wire [3:0]NLW_owner_drained7_carry__0_O_UNCONNECTED;
  wire [3:3]NLW_owner_drained7_carry__1_CO_UNCONNECTED;
  wire [3:0]NLW_owner_drained7_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_owner_drained8_carry_O_UNCONNECTED;
  wire [3:0]NLW_owner_drained8_carry__0_O_UNCONNECTED;
  wire [3:3]NLW_owner_drained8_carry__1_CO_UNCONNECTED;
  wire [3:0]NLW_owner_drained8_carry__1_O_UNCONNECTED;
  wire [3:3]\NLW_released_frames_reg[31]_i_1_CO_UNCONNECTED ;
  wire [3:0]NLW_token_matches0_carry_O_UNCONNECTED;
  wire [3:0]NLW_token_matches0_carry__0_O_UNCONNECTED;
  wire [3:3]NLW_token_matches0_carry__1_CO_UNCONNECTED;
  wire [3:0]NLW_token_matches0_carry__1_O_UNCONNECTED;
  wire [3:0]\NLW_token_matches0_inferred__0/i__carry_O_UNCONNECTED ;
  wire [3:0]\NLW_token_matches0_inferred__0/i__carry__0_O_UNCONNECTED ;
  wire [3:3]\NLW_token_matches0_inferred__0/i__carry__1_CO_UNCONNECTED ;
  wire [3:0]\NLW_token_matches0_inferred__0/i__carry__1_O_UNCONNECTED ;

  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT2 #(
    .INIT(4'hE)) 
    capture_fault_held_i_1
       (.I0(configuration_locked_reg_0),
        .I1(capture_fault_held),
        .O(capture_fault_held_reg));
  LUT4 #(
    .INIT(16'h0008)) 
    claim_accepted_i_1
       (.I0(cpu_held_i_3_n_0),
        .I1(common_aresetn),
        .I2(cpu_release),
        .I3(cpu_available_INST_0_i_1_n_0),
        .O(claim_accepted_i_1_n_0));
  FDRE claim_accepted_reg
       (.C(aclk),
        .CE(1'b1),
        .D(claim_accepted_i_1_n_0),
        .Q(claim_accepted),
        .R(1'b0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 closure_bad1_carry
       (.CI(1'b0),
        .CO({closure_bad1_carry_n_0,closure_bad1_carry_n_1,closure_bad1_carry_n_2,closure_bad1_carry_n_3}),
        .CYINIT(1'b0),
        .DI({closure_bad1_carry_i_1_n_0,closure_bad1_carry_i_2_n_0,closure_bad1_carry_i_3_n_0,closure_bad1_carry_i_4_n_0}),
        .O(NLW_closure_bad1_carry_O_UNCONNECTED[3:0]),
        .S(closure_bad1_carry__0_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 closure_bad1_carry__0
       (.CI(closure_bad1_carry_n_0),
        .CO({closure_bad1_carry__0_n_0,closure_bad1_carry__0_n_1,closure_bad1_carry__0_n_2,closure_bad1_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({closure_bad1_carry__0_i_1_n_0,closure_bad1_carry__0_i_2_n_0,closure_bad1_carry__0_i_3_n_0,closure_bad1_carry__0_i_4_n_0}),
        .O(NLW_closure_bad1_carry__0_O_UNCONNECTED[3:0]),
        .S(closure_bad1_carry__1_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry__0_i_1
       (.I0(out[14]),
        .I1(D[14]),
        .I2(D[15]),
        .I3(out[15]),
        .O(closure_bad1_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry__0_i_2
       (.I0(out[12]),
        .I1(D[12]),
        .I2(D[13]),
        .I3(out[13]),
        .O(closure_bad1_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry__0_i_3
       (.I0(out[10]),
        .I1(D[10]),
        .I2(D[11]),
        .I3(out[11]),
        .O(closure_bad1_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry__0_i_4
       (.I0(out[8]),
        .I1(D[8]),
        .I2(D[9]),
        .I3(out[9]),
        .O(closure_bad1_carry__0_i_4_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 closure_bad1_carry__1
       (.CI(closure_bad1_carry__0_n_0),
        .CO({closure_bad1_carry__1_n_0,closure_bad1_carry__1_n_1,closure_bad1_carry__1_n_2,closure_bad1_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({closure_bad1_carry__1_i_1_n_0,closure_bad1_carry__1_i_2_n_0,closure_bad1_carry__1_i_3_n_0,closure_bad1_carry__1_i_4_n_0}),
        .O(NLW_closure_bad1_carry__1_O_UNCONNECTED[3:0]),
        .S(closure_bad1_carry__2_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry__1_i_1
       (.I0(out[22]),
        .I1(D[22]),
        .I2(D[23]),
        .I3(out[23]),
        .O(closure_bad1_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry__1_i_2
       (.I0(out[20]),
        .I1(D[20]),
        .I2(D[21]),
        .I3(out[21]),
        .O(closure_bad1_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry__1_i_3
       (.I0(out[18]),
        .I1(D[18]),
        .I2(D[19]),
        .I3(out[19]),
        .O(closure_bad1_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry__1_i_4
       (.I0(out[16]),
        .I1(D[16]),
        .I2(D[17]),
        .I3(out[17]),
        .O(closure_bad1_carry__1_i_4_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 closure_bad1_carry__2
       (.CI(closure_bad1_carry__1_n_0),
        .CO({closure_bad1,closure_bad1_carry__2_n_1,closure_bad1_carry__2_n_2,closure_bad1_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({closure_bad1_carry__2_i_1_n_0,closure_bad1_carry__2_i_2_n_0,closure_bad1_carry__2_i_3_n_0,closure_bad1_carry__2_i_4_n_0}),
        .O(NLW_closure_bad1_carry__2_O_UNCONNECTED[3:0]),
        .S(owner_fault_INST_0_i_1_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry__2_i_1
       (.I0(out[30]),
        .I1(D[30]),
        .I2(D[31]),
        .I3(out[31]),
        .O(closure_bad1_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry__2_i_2
       (.I0(out[28]),
        .I1(D[28]),
        .I2(D[29]),
        .I3(out[29]),
        .O(closure_bad1_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry__2_i_3
       (.I0(out[26]),
        .I1(D[26]),
        .I2(D[27]),
        .I3(out[27]),
        .O(closure_bad1_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry__2_i_4
       (.I0(out[24]),
        .I1(D[24]),
        .I2(D[25]),
        .I3(out[25]),
        .O(closure_bad1_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry_i_1
       (.I0(out[6]),
        .I1(D[6]),
        .I2(D[7]),
        .I3(out[7]),
        .O(closure_bad1_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry_i_2
       (.I0(out[4]),
        .I1(D[4]),
        .I2(D[5]),
        .I3(out[5]),
        .O(closure_bad1_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry_i_3
       (.I0(out[2]),
        .I1(D[2]),
        .I2(D[3]),
        .I3(out[3]),
        .O(closure_bad1_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    closure_bad1_carry_i_4
       (.I0(out[0]),
        .I1(D[0]),
        .I2(D[1]),
        .I3(out[1]),
        .O(closure_bad1_carry_i_4_n_0));
  CARRY4 closure_bad2_carry
       (.CI(1'b0),
        .CO({closure_bad2_carry_n_0,closure_bad2_carry_n_1,closure_bad2_carry_n_2,closure_bad2_carry_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_closure_bad2_carry_O_UNCONNECTED[3:0]),
        .S({closure_bad2_carry_i_1_n_0,closure_bad2_carry__0_0[1],closure_bad2_carry_i_3_n_0,closure_bad2_carry__0_0[0]}));
  CARRY4 closure_bad2_carry__0
       (.CI(closure_bad2_carry_n_0),
        .CO({closure_bad2_carry__0_n_0,closure_bad2_carry__0_n_1,closure_bad2_carry__0_n_2,closure_bad2_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_closure_bad2_carry__0_O_UNCONNECTED[3:0]),
        .S({closure_bad2_carry__1_0[2],closure_bad2_carry__0_i_2_n_0,closure_bad2_carry__1_0[1:0]}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    closure_bad2_carry__0_i_2
       (.I0(\final_frame_count_reg_n_0_[19] ),
        .I1(D[19]),
        .I2(D[20]),
        .I3(\final_frame_count_reg_n_0_[20] ),
        .I4(D[18]),
        .I5(\final_frame_count_reg_n_0_[18] ),
        .O(closure_bad2_carry__0_i_2_n_0));
  CARRY4 closure_bad2_carry__1
       (.CI(closure_bad2_carry__0_n_0),
        .CO({NLW_closure_bad2_carry__1_CO_UNCONNECTED[3],closure_bad2,closure_bad2_carry__1_n_2,closure_bad2_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b1,1'b1,1'b1}),
        .O(NLW_closure_bad2_carry__1_O_UNCONNECTED[3:0]),
        .S({1'b0,closure_bad2_carry__1_i_1_n_0,closure_bad2_carry__1_i_2_n_0,closure_bad2_carry__1_i_3_n_0}));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad2_carry__1_i_1
       (.I0(\final_frame_count_reg_n_0_[30] ),
        .I1(D[30]),
        .I2(\final_frame_count_reg_n_0_[31] ),
        .I3(D[31]),
        .O(closure_bad2_carry__1_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    closure_bad2_carry__1_i_2
       (.I0(\final_frame_count_reg_n_0_[28] ),
        .I1(D[28]),
        .I2(D[29]),
        .I3(\final_frame_count_reg_n_0_[29] ),
        .I4(D[27]),
        .I5(\final_frame_count_reg_n_0_[27] ),
        .O(closure_bad2_carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    closure_bad2_carry__1_i_3
       (.I0(\final_frame_count_reg_n_0_[25] ),
        .I1(D[25]),
        .I2(D[26]),
        .I3(\final_frame_count_reg_n_0_[26] ),
        .I4(D[24]),
        .I5(\final_frame_count_reg_n_0_[24] ),
        .O(closure_bad2_carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    closure_bad2_carry_i_1
       (.I0(\final_frame_count_reg_n_0_[9] ),
        .I1(D[9]),
        .I2(D[11]),
        .I3(\final_frame_count_reg_n_0_[11] ),
        .I4(D[10]),
        .I5(\final_frame_count_reg_n_0_[10] ),
        .O(closure_bad2_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    closure_bad2_carry_i_3
       (.I0(\final_frame_count_reg_n_0_[4] ),
        .I1(D[4]),
        .I2(D[5]),
        .I3(\final_frame_count_reg_n_0_[5] ),
        .I4(D[3]),
        .I5(\final_frame_count_reg_n_0_[3] ),
        .O(closure_bad2_carry_i_3_n_0));
  FDRE closure_held_reg
       (.C(aclk),
        .CE(1'b1),
        .D(closure_held_reg_1),
        .Q(closure_held_reg_0),
        .R(clear));
  CARRY4 configuration_bad1_carry
       (.CI(1'b0),
        .CO({configuration_bad1_carry_n_0,configuration_bad1_carry_n_1,configuration_bad1_carry_n_2,configuration_bad1_carry_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_configuration_bad1_carry_O_UNCONNECTED[3:0]),
        .S({configuration_bad1_carry_i_1_n_0,configuration_bad1_carry_i_2_n_0,configuration_bad1_carry_i_3_n_0,configuration_bad1_carry_i_4_n_0}));
  CARRY4 configuration_bad1_carry__0
       (.CI(configuration_bad1_carry_n_0),
        .CO({configuration_bad1_carry__0_n_0,configuration_bad1_carry__0_n_1,configuration_bad1_carry__0_n_2,configuration_bad1_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_configuration_bad1_carry__0_O_UNCONNECTED[3:0]),
        .S({configuration_bad1_carry__0_i_1_n_0,configuration_bad1_carry__0_i_2_n_0,configuration_bad1_carry__0_i_3_n_0,configuration_bad1_carry__0_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad1_carry__0_i_1
       (.I0(cfg_frame_context[21]),
        .I1(first_frame_id[21]),
        .I2(cfg_frame_context[22]),
        .I3(first_frame_id[22]),
        .I4(first_frame_id[23]),
        .I5(cfg_frame_context[23]),
        .O(configuration_bad1_carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad1_carry__0_i_2
       (.I0(cfg_frame_context[18]),
        .I1(first_frame_id[18]),
        .I2(cfg_frame_context[19]),
        .I3(first_frame_id[19]),
        .I4(first_frame_id[20]),
        .I5(cfg_frame_context[20]),
        .O(configuration_bad1_carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad1_carry__0_i_3
       (.I0(cfg_frame_context[15]),
        .I1(first_frame_id[15]),
        .I2(cfg_frame_context[16]),
        .I3(first_frame_id[16]),
        .I4(first_frame_id[17]),
        .I5(cfg_frame_context[17]),
        .O(configuration_bad1_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad1_carry__0_i_4
       (.I0(cfg_frame_context[12]),
        .I1(first_frame_id[12]),
        .I2(cfg_frame_context[13]),
        .I3(first_frame_id[13]),
        .I4(first_frame_id[14]),
        .I5(cfg_frame_context[14]),
        .O(configuration_bad1_carry__0_i_4_n_0));
  CARRY4 configuration_bad1_carry__1
       (.CI(configuration_bad1_carry__0_n_0),
        .CO({NLW_configuration_bad1_carry__1_CO_UNCONNECTED[3],configuration_bad1,configuration_bad1_carry__1_n_2,configuration_bad1_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b1,1'b1,1'b1}),
        .O(NLW_configuration_bad1_carry__1_O_UNCONNECTED[3:0]),
        .S({1'b0,configuration_bad1_carry__1_i_1_n_0,configuration_bad1_carry__1_i_2_n_0,configuration_bad1_carry__1_i_3_n_0}));
  LUT4 #(
    .INIT(16'h9009)) 
    configuration_bad1_carry__1_i_1
       (.I0(first_frame_id[31]),
        .I1(cfg_frame_context[31]),
        .I2(first_frame_id[30]),
        .I3(cfg_frame_context[30]),
        .O(configuration_bad1_carry__1_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad1_carry__1_i_2
       (.I0(cfg_frame_context[27]),
        .I1(first_frame_id[27]),
        .I2(cfg_frame_context[28]),
        .I3(first_frame_id[28]),
        .I4(first_frame_id[29]),
        .I5(cfg_frame_context[29]),
        .O(configuration_bad1_carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad1_carry__1_i_3
       (.I0(cfg_frame_context[24]),
        .I1(first_frame_id[24]),
        .I2(cfg_frame_context[25]),
        .I3(first_frame_id[25]),
        .I4(first_frame_id[26]),
        .I5(cfg_frame_context[26]),
        .O(configuration_bad1_carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad1_carry_i_1
       (.I0(cfg_frame_context[9]),
        .I1(first_frame_id[9]),
        .I2(cfg_frame_context[10]),
        .I3(first_frame_id[10]),
        .I4(first_frame_id[11]),
        .I5(cfg_frame_context[11]),
        .O(configuration_bad1_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad1_carry_i_2
       (.I0(cfg_frame_context[7]),
        .I1(first_frame_id[7]),
        .I2(cfg_frame_context[6]),
        .I3(first_frame_id[6]),
        .I4(first_frame_id[8]),
        .I5(cfg_frame_context[8]),
        .O(configuration_bad1_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad1_carry_i_3
       (.I0(cfg_frame_context[5]),
        .I1(first_frame_id[5]),
        .I2(cfg_frame_context[3]),
        .I3(first_frame_id[3]),
        .I4(first_frame_id[4]),
        .I5(cfg_frame_context[4]),
        .O(configuration_bad1_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad1_carry_i_4
       (.I0(cfg_frame_context[1]),
        .I1(first_frame_id[1]),
        .I2(cfg_frame_context[0]),
        .I3(first_frame_id[0]),
        .I4(first_frame_id[2]),
        .I5(cfg_frame_context[2]),
        .O(configuration_bad1_carry_i_4_n_0));
  CARRY4 configuration_bad2_carry
       (.CI(1'b0),
        .CO({configuration_bad2_carry_n_0,configuration_bad2_carry_n_1,configuration_bad2_carry_n_2,configuration_bad2_carry_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_configuration_bad2_carry_O_UNCONNECTED[3:0]),
        .S({configuration_bad2_carry_i_1_n_0,configuration_bad2_carry_i_2_n_0,configuration_bad2_carry_i_3_n_0,configuration_bad2_carry_i_4_n_0}));
  CARRY4 configuration_bad2_carry__0
       (.CI(configuration_bad2_carry_n_0),
        .CO({configuration_bad2_carry__0_n_0,configuration_bad2_carry__0_n_1,configuration_bad2_carry__0_n_2,configuration_bad2_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_configuration_bad2_carry__0_O_UNCONNECTED[3:0]),
        .S({configuration_bad2_carry__0_i_1_n_0,configuration_bad2_carry__0_i_2_n_0,configuration_bad2_carry__0_i_3_n_0,configuration_bad2_carry__0_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad2_carry__0_i_1
       (.I0(cfg_frame_context[55]),
        .I1(available_epoch[23]),
        .I2(cfg_frame_context[53]),
        .I3(available_epoch[21]),
        .I4(available_epoch[22]),
        .I5(cfg_frame_context[54]),
        .O(configuration_bad2_carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad2_carry__0_i_2
       (.I0(cfg_frame_context[52]),
        .I1(available_epoch[20]),
        .I2(cfg_frame_context[50]),
        .I3(available_epoch[18]),
        .I4(available_epoch[19]),
        .I5(cfg_frame_context[51]),
        .O(configuration_bad2_carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad2_carry__0_i_3
       (.I0(cfg_frame_context[49]),
        .I1(available_epoch[17]),
        .I2(cfg_frame_context[47]),
        .I3(available_epoch[15]),
        .I4(available_epoch[16]),
        .I5(cfg_frame_context[48]),
        .O(configuration_bad2_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad2_carry__0_i_4
       (.I0(cfg_frame_context[46]),
        .I1(available_epoch[14]),
        .I2(cfg_frame_context[45]),
        .I3(available_epoch[13]),
        .I4(available_epoch[12]),
        .I5(cfg_frame_context[44]),
        .O(configuration_bad2_carry__0_i_4_n_0));
  CARRY4 configuration_bad2_carry__1
       (.CI(configuration_bad2_carry__0_n_0),
        .CO({NLW_configuration_bad2_carry__1_CO_UNCONNECTED[3],configuration_bad2_carry__1_n_1,configuration_bad2_carry__1_n_2,configuration_bad2_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b1,1'b1,1'b1}),
        .O(NLW_configuration_bad2_carry__1_O_UNCONNECTED[3:0]),
        .S({1'b0,configuration_bad2_carry__1_i_1_n_0,configuration_bad2_carry__1_i_2_n_0,configuration_bad2_carry__1_i_3_n_0}));
  LUT4 #(
    .INIT(16'h9009)) 
    configuration_bad2_carry__1_i_1
       (.I0(available_epoch[30]),
        .I1(cfg_frame_context[62]),
        .I2(available_epoch[31]),
        .I3(cfg_frame_context[63]),
        .O(configuration_bad2_carry__1_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad2_carry__1_i_2
       (.I0(cfg_frame_context[61]),
        .I1(available_epoch[29]),
        .I2(cfg_frame_context[60]),
        .I3(available_epoch[28]),
        .I4(available_epoch[27]),
        .I5(cfg_frame_context[59]),
        .O(configuration_bad2_carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad2_carry__1_i_3
       (.I0(cfg_frame_context[58]),
        .I1(available_epoch[26]),
        .I2(cfg_frame_context[56]),
        .I3(available_epoch[24]),
        .I4(available_epoch[25]),
        .I5(cfg_frame_context[57]),
        .O(configuration_bad2_carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad2_carry_i_1
       (.I0(cfg_frame_context[43]),
        .I1(available_epoch[11]),
        .I2(cfg_frame_context[41]),
        .I3(available_epoch[9]),
        .I4(available_epoch[10]),
        .I5(cfg_frame_context[42]),
        .O(configuration_bad2_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad2_carry_i_2
       (.I0(cfg_frame_context[40]),
        .I1(available_epoch[8]),
        .I2(cfg_frame_context[38]),
        .I3(available_epoch[6]),
        .I4(available_epoch[7]),
        .I5(cfg_frame_context[39]),
        .O(configuration_bad2_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad2_carry_i_3
       (.I0(cfg_frame_context[37]),
        .I1(available_epoch[5]),
        .I2(cfg_frame_context[36]),
        .I3(available_epoch[4]),
        .I4(available_epoch[3]),
        .I5(cfg_frame_context[35]),
        .O(configuration_bad2_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    configuration_bad2_carry_i_4
       (.I0(cfg_frame_context[34]),
        .I1(available_epoch[2]),
        .I2(cfg_frame_context[33]),
        .I3(available_epoch[1]),
        .I4(available_epoch[0]),
        .I5(cfg_frame_context[32]),
        .O(configuration_bad2_carry_i_4_n_0));
  FDRE configuration_locked_reg
       (.C(aclk),
        .CE(1'b1),
        .D(configuration_locked_reg_1),
        .Q(configuration_locked),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 consumer_identity_carry
       (.CI(1'b0),
        .CO({consumer_identity_carry_n_0,consumer_identity_carry_n_1,consumer_identity_carry_n_2,consumer_identity_carry_n_3}),
        .CYINIT(1'b0),
        .DI(first_frame_id[3:0]),
        .O(available_frame_id[3:0]),
        .S({consumer_identity_carry_i_1_n_0,consumer_identity_carry_i_2_n_0,consumer_identity_carry_i_3_n_0,consumer_identity_carry_i_4_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 consumer_identity_carry__0
       (.CI(consumer_identity_carry_n_0),
        .CO({consumer_identity_carry__0_n_0,consumer_identity_carry__0_n_1,consumer_identity_carry__0_n_2,consumer_identity_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI(first_frame_id[7:4]),
        .O(available_frame_id[7:4]),
        .S({consumer_identity_carry__0_i_1_n_0,consumer_identity_carry__0_i_2_n_0,consumer_identity_carry__0_i_3_n_0,consumer_identity_carry__0_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__0_i_1
       (.I0(first_frame_id[7]),
        .I1(\released_frames_reg[31]_0 [7]),
        .O(consumer_identity_carry__0_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__0_i_2
       (.I0(first_frame_id[6]),
        .I1(\released_frames_reg[31]_0 [6]),
        .O(consumer_identity_carry__0_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__0_i_3
       (.I0(first_frame_id[5]),
        .I1(\released_frames_reg[31]_0 [5]),
        .O(consumer_identity_carry__0_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__0_i_4
       (.I0(first_frame_id[4]),
        .I1(\released_frames_reg[31]_0 [4]),
        .O(consumer_identity_carry__0_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 consumer_identity_carry__1
       (.CI(consumer_identity_carry__0_n_0),
        .CO({consumer_identity_carry__1_n_0,consumer_identity_carry__1_n_1,consumer_identity_carry__1_n_2,consumer_identity_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI(first_frame_id[11:8]),
        .O(available_frame_id[11:8]),
        .S({consumer_identity_carry__1_i_1_n_0,consumer_identity_carry__1_i_2_n_0,consumer_identity_carry__1_i_3_n_0,consumer_identity_carry__1_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__1_i_1
       (.I0(first_frame_id[11]),
        .I1(\released_frames_reg[31]_0 [11]),
        .O(consumer_identity_carry__1_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__1_i_2
       (.I0(first_frame_id[10]),
        .I1(\released_frames_reg[31]_0 [10]),
        .O(consumer_identity_carry__1_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__1_i_3
       (.I0(first_frame_id[9]),
        .I1(\released_frames_reg[31]_0 [9]),
        .O(consumer_identity_carry__1_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__1_i_4
       (.I0(first_frame_id[8]),
        .I1(\released_frames_reg[31]_0 [8]),
        .O(consumer_identity_carry__1_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 consumer_identity_carry__2
       (.CI(consumer_identity_carry__1_n_0),
        .CO({consumer_identity_carry__2_n_0,consumer_identity_carry__2_n_1,consumer_identity_carry__2_n_2,consumer_identity_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI(first_frame_id[15:12]),
        .O(available_frame_id[15:12]),
        .S({consumer_identity_carry__2_i_1_n_0,consumer_identity_carry__2_i_2_n_0,consumer_identity_carry__2_i_3_n_0,consumer_identity_carry__2_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__2_i_1
       (.I0(first_frame_id[15]),
        .I1(\released_frames_reg[31]_0 [15]),
        .O(consumer_identity_carry__2_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__2_i_2
       (.I0(first_frame_id[14]),
        .I1(\released_frames_reg[31]_0 [14]),
        .O(consumer_identity_carry__2_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__2_i_3
       (.I0(first_frame_id[13]),
        .I1(\released_frames_reg[31]_0 [13]),
        .O(consumer_identity_carry__2_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__2_i_4
       (.I0(first_frame_id[12]),
        .I1(\released_frames_reg[31]_0 [12]),
        .O(consumer_identity_carry__2_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 consumer_identity_carry__3
       (.CI(consumer_identity_carry__2_n_0),
        .CO({consumer_identity_carry__3_n_0,consumer_identity_carry__3_n_1,consumer_identity_carry__3_n_2,consumer_identity_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI(first_frame_id[19:16]),
        .O(available_frame_id[19:16]),
        .S({consumer_identity_carry__3_i_1_n_0,consumer_identity_carry__3_i_2_n_0,consumer_identity_carry__3_i_3_n_0,consumer_identity_carry__3_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__3_i_1
       (.I0(first_frame_id[19]),
        .I1(\released_frames_reg[31]_0 [19]),
        .O(consumer_identity_carry__3_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__3_i_2
       (.I0(first_frame_id[18]),
        .I1(\released_frames_reg[31]_0 [18]),
        .O(consumer_identity_carry__3_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__3_i_3
       (.I0(first_frame_id[17]),
        .I1(\released_frames_reg[31]_0 [17]),
        .O(consumer_identity_carry__3_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__3_i_4
       (.I0(first_frame_id[16]),
        .I1(\released_frames_reg[31]_0 [16]),
        .O(consumer_identity_carry__3_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 consumer_identity_carry__4
       (.CI(consumer_identity_carry__3_n_0),
        .CO({consumer_identity_carry__4_n_0,consumer_identity_carry__4_n_1,consumer_identity_carry__4_n_2,consumer_identity_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI(first_frame_id[23:20]),
        .O(available_frame_id[23:20]),
        .S({consumer_identity_carry__4_i_1_n_0,consumer_identity_carry__4_i_2_n_0,consumer_identity_carry__4_i_3_n_0,consumer_identity_carry__4_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__4_i_1
       (.I0(first_frame_id[23]),
        .I1(\released_frames_reg[31]_0 [23]),
        .O(consumer_identity_carry__4_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__4_i_2
       (.I0(first_frame_id[22]),
        .I1(\released_frames_reg[31]_0 [22]),
        .O(consumer_identity_carry__4_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__4_i_3
       (.I0(first_frame_id[21]),
        .I1(\released_frames_reg[31]_0 [21]),
        .O(consumer_identity_carry__4_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__4_i_4
       (.I0(first_frame_id[20]),
        .I1(\released_frames_reg[31]_0 [20]),
        .O(consumer_identity_carry__4_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 consumer_identity_carry__5
       (.CI(consumer_identity_carry__4_n_0),
        .CO({consumer_identity_carry__5_n_0,consumer_identity_carry__5_n_1,consumer_identity_carry__5_n_2,consumer_identity_carry__5_n_3}),
        .CYINIT(1'b0),
        .DI(first_frame_id[27:24]),
        .O(available_frame_id[27:24]),
        .S({consumer_identity_carry__5_i_1_n_0,consumer_identity_carry__5_i_2_n_0,consumer_identity_carry__5_i_3_n_0,consumer_identity_carry__5_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__5_i_1
       (.I0(first_frame_id[27]),
        .I1(\released_frames_reg[31]_0 [27]),
        .O(consumer_identity_carry__5_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__5_i_2
       (.I0(first_frame_id[26]),
        .I1(\released_frames_reg[31]_0 [26]),
        .O(consumer_identity_carry__5_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__5_i_3
       (.I0(first_frame_id[25]),
        .I1(\released_frames_reg[31]_0 [25]),
        .O(consumer_identity_carry__5_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__5_i_4
       (.I0(first_frame_id[24]),
        .I1(\released_frames_reg[31]_0 [24]),
        .O(consumer_identity_carry__5_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 consumer_identity_carry__6
       (.CI(consumer_identity_carry__5_n_0),
        .CO({NLW_consumer_identity_carry__6_CO_UNCONNECTED[3],consumer_identity_carry__6_n_1,consumer_identity_carry__6_n_2,consumer_identity_carry__6_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,first_frame_id[30:28]}),
        .O(available_frame_id[31:28]),
        .S({consumer_identity_carry__6_i_1_n_0,consumer_identity_carry__6_i_2_n_0,consumer_identity_carry__6_i_3_n_0,consumer_identity_carry__6_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__6_i_1
       (.I0(first_frame_id[31]),
        .I1(\released_frames_reg[31]_0 [31]),
        .O(consumer_identity_carry__6_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__6_i_2
       (.I0(first_frame_id[30]),
        .I1(\released_frames_reg[31]_0 [30]),
        .O(consumer_identity_carry__6_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__6_i_3
       (.I0(first_frame_id[29]),
        .I1(\released_frames_reg[31]_0 [29]),
        .O(consumer_identity_carry__6_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry__6_i_4
       (.I0(first_frame_id[28]),
        .I1(\released_frames_reg[31]_0 [28]),
        .O(consumer_identity_carry__6_i_4_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry_i_1
       (.I0(first_frame_id[3]),
        .I1(\released_frames_reg[31]_0 [3]),
        .O(consumer_identity_carry_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry_i_2
       (.I0(first_frame_id[2]),
        .I1(\released_frames_reg[31]_0 [2]),
        .O(consumer_identity_carry_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry_i_3
       (.I0(first_frame_id[1]),
        .I1(\released_frames_reg[31]_0 [1]),
        .O(consumer_identity_carry_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    consumer_identity_carry_i_4
       (.I0(first_frame_id[0]),
        .I1(\released_frames_reg[31]_0 [0]),
        .O(consumer_identity_carry_i_4_n_0));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \consumer_slot[0]_i_1 
       (.I0(available_slot[1]),
        .I1(available_slot[0]),
        .O(\consumer_slot[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \consumer_slot[1]_i_1 
       (.I0(available_slot[1]),
        .I1(available_slot[0]),
        .O(\consumer_slot[1]_i_1_n_0 ));
  FDRE \consumer_slot_reg[0] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\consumer_slot[0]_i_1_n_0 ),
        .Q(available_slot[0]),
        .R(clear));
  FDRE \consumer_slot_reg[1] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\consumer_slot[1]_i_1_n_0 ),
        .Q(available_slot[1]),
        .R(clear));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad1_carry
       (.CI(1'b0),
        .CO({counters_bad1_carry_n_0,counters_bad1_carry_n_1,counters_bad1_carry_n_2,counters_bad1_carry_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad1_carry_i_1_n_0,counters_bad1_carry_i_2_n_0,counters_bad1_carry_i_3_n_0,counters_bad1_carry_i_4_n_0}),
        .O(NLW_counters_bad1_carry_O_UNCONNECTED[3:0]),
        .S({counters_bad1_carry_i_5_n_0,counters_bad1_carry_i_6_n_0,counters_bad1_carry_i_7_n_0,counters_bad1_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad1_carry__0
       (.CI(counters_bad1_carry_n_0),
        .CO({counters_bad1_carry__0_n_0,counters_bad1_carry__0_n_1,counters_bad1_carry__0_n_2,counters_bad1_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad1_carry__0_i_1_n_0,counters_bad1_carry__0_i_2_n_0,counters_bad1_carry__0_i_3_n_0,counters_bad1_carry__0_i_4_n_0}),
        .O(NLW_counters_bad1_carry__0_O_UNCONNECTED[3:0]),
        .S({counters_bad1_carry__0_i_5_n_0,counters_bad1_carry__0_i_6_n_0,counters_bad1_carry__0_i_7_n_0,counters_bad1_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry__0_i_1
       (.I0(out[15]),
        .I1(status_completed_frames[15]),
        .I2(status_completed_frames[14]),
        .I3(out[14]),
        .O(counters_bad1_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry__0_i_2
       (.I0(out[13]),
        .I1(status_completed_frames[13]),
        .I2(status_completed_frames[12]),
        .I3(out[12]),
        .O(counters_bad1_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry__0_i_3
       (.I0(out[11]),
        .I1(status_completed_frames[11]),
        .I2(status_completed_frames[10]),
        .I3(out[10]),
        .O(counters_bad1_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry__0_i_4
       (.I0(out[9]),
        .I1(status_completed_frames[9]),
        .I2(status_completed_frames[8]),
        .I3(out[8]),
        .O(counters_bad1_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry__0_i_5
       (.I0(status_completed_frames[15]),
        .I1(out[15]),
        .I2(status_completed_frames[14]),
        .I3(out[14]),
        .O(counters_bad1_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry__0_i_6
       (.I0(status_completed_frames[13]),
        .I1(out[13]),
        .I2(status_completed_frames[12]),
        .I3(out[12]),
        .O(counters_bad1_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry__0_i_7
       (.I0(status_completed_frames[11]),
        .I1(out[11]),
        .I2(status_completed_frames[10]),
        .I3(out[10]),
        .O(counters_bad1_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry__0_i_8
       (.I0(status_completed_frames[9]),
        .I1(out[9]),
        .I2(status_completed_frames[8]),
        .I3(out[8]),
        .O(counters_bad1_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad1_carry__1
       (.CI(counters_bad1_carry__0_n_0),
        .CO({counters_bad1_carry__1_n_0,counters_bad1_carry__1_n_1,counters_bad1_carry__1_n_2,counters_bad1_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad1_carry__1_i_1_n_0,counters_bad1_carry__1_i_2_n_0,counters_bad1_carry__1_i_3_n_0,counters_bad1_carry__1_i_4_n_0}),
        .O(NLW_counters_bad1_carry__1_O_UNCONNECTED[3:0]),
        .S({counters_bad1_carry__1_i_5_n_0,counters_bad1_carry__1_i_6_n_0,counters_bad1_carry__1_i_7_n_0,counters_bad1_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry__1_i_1
       (.I0(out[23]),
        .I1(status_completed_frames[23]),
        .I2(status_completed_frames[22]),
        .I3(out[22]),
        .O(counters_bad1_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry__1_i_2
       (.I0(out[21]),
        .I1(status_completed_frames[21]),
        .I2(status_completed_frames[20]),
        .I3(out[20]),
        .O(counters_bad1_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry__1_i_3
       (.I0(out[19]),
        .I1(status_completed_frames[19]),
        .I2(status_completed_frames[18]),
        .I3(out[18]),
        .O(counters_bad1_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry__1_i_4
       (.I0(out[17]),
        .I1(status_completed_frames[17]),
        .I2(status_completed_frames[16]),
        .I3(out[16]),
        .O(counters_bad1_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry__1_i_5
       (.I0(status_completed_frames[23]),
        .I1(out[23]),
        .I2(status_completed_frames[22]),
        .I3(out[22]),
        .O(counters_bad1_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry__1_i_6
       (.I0(status_completed_frames[21]),
        .I1(out[21]),
        .I2(status_completed_frames[20]),
        .I3(out[20]),
        .O(counters_bad1_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry__1_i_7
       (.I0(status_completed_frames[19]),
        .I1(out[19]),
        .I2(status_completed_frames[18]),
        .I3(out[18]),
        .O(counters_bad1_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry__1_i_8
       (.I0(status_completed_frames[17]),
        .I1(out[17]),
        .I2(status_completed_frames[16]),
        .I3(out[16]),
        .O(counters_bad1_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad1_carry__2
       (.CI(counters_bad1_carry__1_n_0),
        .CO({counters_bad1,counters_bad1_carry__2_n_1,counters_bad1_carry__2_n_2,counters_bad1_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad1_carry__2_i_1_n_0,counters_bad1_carry__2_i_2_n_0,counters_bad1_carry__2_i_3_n_0,counters_bad1_carry__2_i_4_n_0}),
        .O(NLW_counters_bad1_carry__2_O_UNCONNECTED[3:0]),
        .S({counters_bad1_carry__2_i_5_n_0,counters_bad1_carry__2_i_6_n_0,counters_bad1_carry__2_i_7_n_0,counters_bad1_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry__2_i_1
       (.I0(out[31]),
        .I1(status_completed_frames[31]),
        .I2(status_completed_frames[30]),
        .I3(out[30]),
        .O(counters_bad1_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry__2_i_2
       (.I0(out[29]),
        .I1(status_completed_frames[29]),
        .I2(status_completed_frames[28]),
        .I3(out[28]),
        .O(counters_bad1_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry__2_i_3
       (.I0(out[27]),
        .I1(status_completed_frames[27]),
        .I2(status_completed_frames[26]),
        .I3(out[26]),
        .O(counters_bad1_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry__2_i_4
       (.I0(out[25]),
        .I1(status_completed_frames[25]),
        .I2(status_completed_frames[24]),
        .I3(out[24]),
        .O(counters_bad1_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry__2_i_5
       (.I0(status_completed_frames[31]),
        .I1(out[31]),
        .I2(status_completed_frames[30]),
        .I3(out[30]),
        .O(counters_bad1_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry__2_i_6
       (.I0(status_completed_frames[29]),
        .I1(out[29]),
        .I2(status_completed_frames[28]),
        .I3(out[28]),
        .O(counters_bad1_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry__2_i_7
       (.I0(status_completed_frames[27]),
        .I1(out[27]),
        .I2(status_completed_frames[26]),
        .I3(out[26]),
        .O(counters_bad1_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry__2_i_8
       (.I0(status_completed_frames[25]),
        .I1(out[25]),
        .I2(status_completed_frames[24]),
        .I3(out[24]),
        .O(counters_bad1_carry__2_i_8_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry_i_1
       (.I0(out[7]),
        .I1(status_completed_frames[7]),
        .I2(status_completed_frames[6]),
        .I3(out[6]),
        .O(counters_bad1_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry_i_2
       (.I0(out[5]),
        .I1(status_completed_frames[5]),
        .I2(status_completed_frames[4]),
        .I3(out[4]),
        .O(counters_bad1_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry_i_3
       (.I0(out[3]),
        .I1(status_completed_frames[3]),
        .I2(status_completed_frames[2]),
        .I3(out[2]),
        .O(counters_bad1_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad1_carry_i_4
       (.I0(out[1]),
        .I1(status_completed_frames[1]),
        .I2(status_completed_frames[0]),
        .I3(out[0]),
        .O(counters_bad1_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry_i_5
       (.I0(status_completed_frames[7]),
        .I1(out[7]),
        .I2(status_completed_frames[6]),
        .I3(out[6]),
        .O(counters_bad1_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry_i_6
       (.I0(status_completed_frames[5]),
        .I1(out[5]),
        .I2(status_completed_frames[4]),
        .I3(out[4]),
        .O(counters_bad1_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry_i_7
       (.I0(status_completed_frames[3]),
        .I1(out[3]),
        .I2(status_completed_frames[2]),
        .I3(out[2]),
        .O(counters_bad1_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad1_carry_i_8
       (.I0(status_completed_frames[1]),
        .I1(out[1]),
        .I2(status_completed_frames[0]),
        .I3(out[0]),
        .O(counters_bad1_carry_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad2_carry
       (.CI(1'b0),
        .CO({counters_bad2_carry_n_0,counters_bad2_carry_n_1,counters_bad2_carry_n_2,counters_bad2_carry_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad2_carry_i_1_n_0,counters_bad2_carry_i_2_n_0,counters_bad2_carry_i_3_n_0,counters_bad2_carry_i_4_n_0}),
        .O(NLW_counters_bad2_carry_O_UNCONNECTED[3:0]),
        .S({counters_bad2_carry_i_5_n_0,counters_bad2_carry_i_6_n_0,counters_bad2_carry_i_7_n_0,counters_bad2_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad2_carry__0
       (.CI(counters_bad2_carry_n_0),
        .CO({counters_bad2_carry__0_n_0,counters_bad2_carry__0_n_1,counters_bad2_carry__0_n_2,counters_bad2_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad2_carry__0_i_1_n_0,counters_bad2_carry__0_i_2_n_0,counters_bad2_carry__0_i_3_n_0,counters_bad2_carry__0_i_4_n_0}),
        .O(NLW_counters_bad2_carry__0_O_UNCONNECTED[3:0]),
        .S({counters_bad2_carry__0_i_5_n_0,counters_bad2_carry__0_i_6_n_0,counters_bad2_carry__0_i_7_n_0,counters_bad2_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry__0_i_1
       (.I0(out[15]),
        .I1(packet_completed_frames[15]),
        .I2(packet_completed_frames[14]),
        .I3(out[14]),
        .O(counters_bad2_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry__0_i_2
       (.I0(out[13]),
        .I1(packet_completed_frames[13]),
        .I2(packet_completed_frames[12]),
        .I3(out[12]),
        .O(counters_bad2_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry__0_i_3
       (.I0(out[11]),
        .I1(packet_completed_frames[11]),
        .I2(packet_completed_frames[10]),
        .I3(out[10]),
        .O(counters_bad2_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry__0_i_4
       (.I0(out[9]),
        .I1(packet_completed_frames[9]),
        .I2(packet_completed_frames[8]),
        .I3(out[8]),
        .O(counters_bad2_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry__0_i_5
       (.I0(packet_completed_frames[15]),
        .I1(out[15]),
        .I2(packet_completed_frames[14]),
        .I3(out[14]),
        .O(counters_bad2_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry__0_i_6
       (.I0(packet_completed_frames[13]),
        .I1(out[13]),
        .I2(packet_completed_frames[12]),
        .I3(out[12]),
        .O(counters_bad2_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry__0_i_7
       (.I0(packet_completed_frames[11]),
        .I1(out[11]),
        .I2(packet_completed_frames[10]),
        .I3(out[10]),
        .O(counters_bad2_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry__0_i_8
       (.I0(packet_completed_frames[9]),
        .I1(out[9]),
        .I2(packet_completed_frames[8]),
        .I3(out[8]),
        .O(counters_bad2_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad2_carry__1
       (.CI(counters_bad2_carry__0_n_0),
        .CO({counters_bad2_carry__1_n_0,counters_bad2_carry__1_n_1,counters_bad2_carry__1_n_2,counters_bad2_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad2_carry__1_i_1_n_0,counters_bad2_carry__1_i_2_n_0,counters_bad2_carry__1_i_3_n_0,counters_bad2_carry__1_i_4_n_0}),
        .O(NLW_counters_bad2_carry__1_O_UNCONNECTED[3:0]),
        .S({counters_bad2_carry__1_i_5_n_0,counters_bad2_carry__1_i_6_n_0,counters_bad2_carry__1_i_7_n_0,counters_bad2_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry__1_i_1
       (.I0(out[23]),
        .I1(packet_completed_frames[23]),
        .I2(packet_completed_frames[22]),
        .I3(out[22]),
        .O(counters_bad2_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry__1_i_2
       (.I0(out[21]),
        .I1(packet_completed_frames[21]),
        .I2(packet_completed_frames[20]),
        .I3(out[20]),
        .O(counters_bad2_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry__1_i_3
       (.I0(out[19]),
        .I1(packet_completed_frames[19]),
        .I2(packet_completed_frames[18]),
        .I3(out[18]),
        .O(counters_bad2_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry__1_i_4
       (.I0(out[17]),
        .I1(packet_completed_frames[17]),
        .I2(packet_completed_frames[16]),
        .I3(out[16]),
        .O(counters_bad2_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry__1_i_5
       (.I0(packet_completed_frames[23]),
        .I1(out[23]),
        .I2(packet_completed_frames[22]),
        .I3(out[22]),
        .O(counters_bad2_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry__1_i_6
       (.I0(packet_completed_frames[21]),
        .I1(out[21]),
        .I2(packet_completed_frames[20]),
        .I3(out[20]),
        .O(counters_bad2_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry__1_i_7
       (.I0(packet_completed_frames[19]),
        .I1(out[19]),
        .I2(packet_completed_frames[18]),
        .I3(out[18]),
        .O(counters_bad2_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry__1_i_8
       (.I0(packet_completed_frames[17]),
        .I1(out[17]),
        .I2(packet_completed_frames[16]),
        .I3(out[16]),
        .O(counters_bad2_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad2_carry__2
       (.CI(counters_bad2_carry__1_n_0),
        .CO({counters_bad2,counters_bad2_carry__2_n_1,counters_bad2_carry__2_n_2,counters_bad2_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad2_carry__2_i_1_n_0,counters_bad2_carry__2_i_2_n_0,counters_bad2_carry__2_i_3_n_0,counters_bad2_carry__2_i_4_n_0}),
        .O(NLW_counters_bad2_carry__2_O_UNCONNECTED[3:0]),
        .S({counters_bad2_carry__2_i_5_n_0,counters_bad2_carry__2_i_6_n_0,counters_bad2_carry__2_i_7_n_0,counters_bad2_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry__2_i_1
       (.I0(out[31]),
        .I1(packet_completed_frames[31]),
        .I2(packet_completed_frames[30]),
        .I3(out[30]),
        .O(counters_bad2_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry__2_i_2
       (.I0(out[29]),
        .I1(packet_completed_frames[29]),
        .I2(packet_completed_frames[28]),
        .I3(out[28]),
        .O(counters_bad2_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry__2_i_3
       (.I0(out[27]),
        .I1(packet_completed_frames[27]),
        .I2(packet_completed_frames[26]),
        .I3(out[26]),
        .O(counters_bad2_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry__2_i_4
       (.I0(out[25]),
        .I1(packet_completed_frames[25]),
        .I2(packet_completed_frames[24]),
        .I3(out[24]),
        .O(counters_bad2_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry__2_i_5
       (.I0(packet_completed_frames[31]),
        .I1(out[31]),
        .I2(packet_completed_frames[30]),
        .I3(out[30]),
        .O(counters_bad2_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry__2_i_6
       (.I0(packet_completed_frames[29]),
        .I1(out[29]),
        .I2(packet_completed_frames[28]),
        .I3(out[28]),
        .O(counters_bad2_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry__2_i_7
       (.I0(packet_completed_frames[27]),
        .I1(out[27]),
        .I2(packet_completed_frames[26]),
        .I3(out[26]),
        .O(counters_bad2_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry__2_i_8
       (.I0(packet_completed_frames[25]),
        .I1(out[25]),
        .I2(packet_completed_frames[24]),
        .I3(out[24]),
        .O(counters_bad2_carry__2_i_8_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry_i_1
       (.I0(out[7]),
        .I1(packet_completed_frames[7]),
        .I2(packet_completed_frames[6]),
        .I3(out[6]),
        .O(counters_bad2_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry_i_2
       (.I0(out[5]),
        .I1(packet_completed_frames[5]),
        .I2(packet_completed_frames[4]),
        .I3(out[4]),
        .O(counters_bad2_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry_i_3
       (.I0(out[3]),
        .I1(packet_completed_frames[3]),
        .I2(packet_completed_frames[2]),
        .I3(out[2]),
        .O(counters_bad2_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad2_carry_i_4
       (.I0(out[1]),
        .I1(packet_completed_frames[1]),
        .I2(packet_completed_frames[0]),
        .I3(out[0]),
        .O(counters_bad2_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry_i_5
       (.I0(packet_completed_frames[7]),
        .I1(out[7]),
        .I2(packet_completed_frames[6]),
        .I3(out[6]),
        .O(counters_bad2_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry_i_6
       (.I0(packet_completed_frames[5]),
        .I1(out[5]),
        .I2(packet_completed_frames[4]),
        .I3(out[4]),
        .O(counters_bad2_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry_i_7
       (.I0(packet_completed_frames[3]),
        .I1(out[3]),
        .I2(packet_completed_frames[2]),
        .I3(out[2]),
        .O(counters_bad2_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad2_carry_i_8
       (.I0(packet_completed_frames[1]),
        .I1(out[1]),
        .I2(packet_completed_frames[0]),
        .I3(out[0]),
        .O(counters_bad2_carry_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad3_carry
       (.CI(1'b0),
        .CO({counters_bad3_carry_n_0,counters_bad3_carry_n_1,counters_bad3_carry_n_2,counters_bad3_carry_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad3_carry_i_1_n_0,counters_bad3_carry_i_2_n_0,counters_bad3_carry_i_3_n_0,counters_bad3_carry_i_4_n_0}),
        .O(NLW_counters_bad3_carry_O_UNCONNECTED[3:0]),
        .S({counters_bad3_carry_i_5_n_0,counters_bad3_carry_i_6_n_0,counters_bad3_carry_i_7_n_0,counters_bad3_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad3_carry__0
       (.CI(counters_bad3_carry_n_0),
        .CO({counters_bad3_carry__0_n_0,counters_bad3_carry__0_n_1,counters_bad3_carry__0_n_2,counters_bad3_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad3_carry__0_i_1_n_0,counters_bad3_carry__0_i_2_n_0,counters_bad3_carry__0_i_3_n_0,counters_bad3_carry__0_i_4_n_0}),
        .O(NLW_counters_bad3_carry__0_O_UNCONNECTED[3:0]),
        .S({counters_bad3_carry__0_i_5_n_0,counters_bad3_carry__0_i_6_n_0,counters_bad3_carry__0_i_7_n_0,counters_bad3_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry__0_i_1
       (.I0(out[15]),
        .I1(rgb_completed_frames[15]),
        .I2(rgb_completed_frames[14]),
        .I3(out[14]),
        .O(counters_bad3_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry__0_i_2
       (.I0(out[13]),
        .I1(rgb_completed_frames[13]),
        .I2(rgb_completed_frames[12]),
        .I3(out[12]),
        .O(counters_bad3_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry__0_i_3
       (.I0(out[11]),
        .I1(rgb_completed_frames[11]),
        .I2(rgb_completed_frames[10]),
        .I3(out[10]),
        .O(counters_bad3_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry__0_i_4
       (.I0(out[9]),
        .I1(rgb_completed_frames[9]),
        .I2(rgb_completed_frames[8]),
        .I3(out[8]),
        .O(counters_bad3_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry__0_i_5
       (.I0(rgb_completed_frames[15]),
        .I1(out[15]),
        .I2(rgb_completed_frames[14]),
        .I3(out[14]),
        .O(counters_bad3_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry__0_i_6
       (.I0(rgb_completed_frames[13]),
        .I1(out[13]),
        .I2(rgb_completed_frames[12]),
        .I3(out[12]),
        .O(counters_bad3_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry__0_i_7
       (.I0(rgb_completed_frames[11]),
        .I1(out[11]),
        .I2(rgb_completed_frames[10]),
        .I3(out[10]),
        .O(counters_bad3_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry__0_i_8
       (.I0(rgb_completed_frames[9]),
        .I1(out[9]),
        .I2(rgb_completed_frames[8]),
        .I3(out[8]),
        .O(counters_bad3_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad3_carry__1
       (.CI(counters_bad3_carry__0_n_0),
        .CO({counters_bad3_carry__1_n_0,counters_bad3_carry__1_n_1,counters_bad3_carry__1_n_2,counters_bad3_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad3_carry__1_i_1_n_0,counters_bad3_carry__1_i_2_n_0,counters_bad3_carry__1_i_3_n_0,counters_bad3_carry__1_i_4_n_0}),
        .O(NLW_counters_bad3_carry__1_O_UNCONNECTED[3:0]),
        .S({counters_bad3_carry__1_i_5_n_0,counters_bad3_carry__1_i_6_n_0,counters_bad3_carry__1_i_7_n_0,counters_bad3_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry__1_i_1
       (.I0(out[23]),
        .I1(rgb_completed_frames[23]),
        .I2(rgb_completed_frames[22]),
        .I3(out[22]),
        .O(counters_bad3_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry__1_i_2
       (.I0(out[21]),
        .I1(rgb_completed_frames[21]),
        .I2(rgb_completed_frames[20]),
        .I3(out[20]),
        .O(counters_bad3_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry__1_i_3
       (.I0(out[19]),
        .I1(rgb_completed_frames[19]),
        .I2(rgb_completed_frames[18]),
        .I3(out[18]),
        .O(counters_bad3_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry__1_i_4
       (.I0(out[17]),
        .I1(rgb_completed_frames[17]),
        .I2(rgb_completed_frames[16]),
        .I3(out[16]),
        .O(counters_bad3_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry__1_i_5
       (.I0(rgb_completed_frames[23]),
        .I1(out[23]),
        .I2(rgb_completed_frames[22]),
        .I3(out[22]),
        .O(counters_bad3_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry__1_i_6
       (.I0(rgb_completed_frames[21]),
        .I1(out[21]),
        .I2(rgb_completed_frames[20]),
        .I3(out[20]),
        .O(counters_bad3_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry__1_i_7
       (.I0(rgb_completed_frames[19]),
        .I1(out[19]),
        .I2(rgb_completed_frames[18]),
        .I3(out[18]),
        .O(counters_bad3_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry__1_i_8
       (.I0(rgb_completed_frames[17]),
        .I1(out[17]),
        .I2(rgb_completed_frames[16]),
        .I3(out[16]),
        .O(counters_bad3_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad3_carry__2
       (.CI(counters_bad3_carry__1_n_0),
        .CO({counters_bad3,counters_bad3_carry__2_n_1,counters_bad3_carry__2_n_2,counters_bad3_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad3_carry__2_i_1_n_0,counters_bad3_carry__2_i_2_n_0,counters_bad3_carry__2_i_3_n_0,counters_bad3_carry__2_i_4_n_0}),
        .O(NLW_counters_bad3_carry__2_O_UNCONNECTED[3:0]),
        .S({counters_bad3_carry__2_i_5_n_0,counters_bad3_carry__2_i_6_n_0,counters_bad3_carry__2_i_7_n_0,counters_bad3_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry__2_i_1
       (.I0(out[31]),
        .I1(rgb_completed_frames[31]),
        .I2(rgb_completed_frames[30]),
        .I3(out[30]),
        .O(counters_bad3_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry__2_i_2
       (.I0(out[29]),
        .I1(rgb_completed_frames[29]),
        .I2(rgb_completed_frames[28]),
        .I3(out[28]),
        .O(counters_bad3_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry__2_i_3
       (.I0(out[27]),
        .I1(rgb_completed_frames[27]),
        .I2(rgb_completed_frames[26]),
        .I3(out[26]),
        .O(counters_bad3_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry__2_i_4
       (.I0(out[25]),
        .I1(rgb_completed_frames[25]),
        .I2(rgb_completed_frames[24]),
        .I3(out[24]),
        .O(counters_bad3_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry__2_i_5
       (.I0(rgb_completed_frames[31]),
        .I1(out[31]),
        .I2(rgb_completed_frames[30]),
        .I3(out[30]),
        .O(counters_bad3_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry__2_i_6
       (.I0(rgb_completed_frames[29]),
        .I1(out[29]),
        .I2(rgb_completed_frames[28]),
        .I3(out[28]),
        .O(counters_bad3_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry__2_i_7
       (.I0(rgb_completed_frames[27]),
        .I1(out[27]),
        .I2(rgb_completed_frames[26]),
        .I3(out[26]),
        .O(counters_bad3_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry__2_i_8
       (.I0(rgb_completed_frames[25]),
        .I1(out[25]),
        .I2(rgb_completed_frames[24]),
        .I3(out[24]),
        .O(counters_bad3_carry__2_i_8_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry_i_1
       (.I0(out[7]),
        .I1(rgb_completed_frames[7]),
        .I2(rgb_completed_frames[6]),
        .I3(out[6]),
        .O(counters_bad3_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry_i_2
       (.I0(out[5]),
        .I1(rgb_completed_frames[5]),
        .I2(rgb_completed_frames[4]),
        .I3(out[4]),
        .O(counters_bad3_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry_i_3
       (.I0(out[3]),
        .I1(rgb_completed_frames[3]),
        .I2(rgb_completed_frames[2]),
        .I3(out[2]),
        .O(counters_bad3_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad3_carry_i_4
       (.I0(out[1]),
        .I1(rgb_completed_frames[1]),
        .I2(rgb_completed_frames[0]),
        .I3(out[0]),
        .O(counters_bad3_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry_i_5
       (.I0(rgb_completed_frames[7]),
        .I1(out[7]),
        .I2(rgb_completed_frames[6]),
        .I3(out[6]),
        .O(counters_bad3_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry_i_6
       (.I0(rgb_completed_frames[5]),
        .I1(out[5]),
        .I2(rgb_completed_frames[4]),
        .I3(out[4]),
        .O(counters_bad3_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry_i_7
       (.I0(rgb_completed_frames[3]),
        .I1(out[3]),
        .I2(rgb_completed_frames[2]),
        .I3(out[2]),
        .O(counters_bad3_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad3_carry_i_8
       (.I0(rgb_completed_frames[1]),
        .I1(out[1]),
        .I2(rgb_completed_frames[0]),
        .I3(out[0]),
        .O(counters_bad3_carry_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad4_carry
       (.CI(1'b0),
        .CO({counters_bad4_carry_n_0,counters_bad4_carry_n_1,counters_bad4_carry_n_2,counters_bad4_carry_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad4_carry_i_1_n_0,counters_bad4_carry_i_2_n_0,counters_bad4_carry_i_3_n_0,counters_bad4_carry_i_4_n_0}),
        .O(NLW_counters_bad4_carry_O_UNCONNECTED[3:0]),
        .S({counters_bad4_carry_i_5_n_0,counters_bad4_carry_i_6_n_0,counters_bad4_carry_i_7_n_0,counters_bad4_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad4_carry__0
       (.CI(counters_bad4_carry_n_0),
        .CO({counters_bad4_carry__0_n_0,counters_bad4_carry__0_n_1,counters_bad4_carry__0_n_2,counters_bad4_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad4_carry__0_i_1_n_0,counters_bad4_carry__0_i_2_n_0,counters_bad4_carry__0_i_3_n_0,counters_bad4_carry__0_i_4_n_0}),
        .O(NLW_counters_bad4_carry__0_O_UNCONNECTED[3:0]),
        .S({counters_bad4_carry__0_i_5_n_0,counters_bad4_carry__0_i_6_n_0,counters_bad4_carry__0_i_7_n_0,counters_bad4_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry__0_i_1
       (.I0(status_completed_frames[15]),
        .I1(previous_status[15]),
        .I2(previous_status[14]),
        .I3(status_completed_frames[14]),
        .O(counters_bad4_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry__0_i_2
       (.I0(status_completed_frames[13]),
        .I1(previous_status[13]),
        .I2(previous_status[12]),
        .I3(status_completed_frames[12]),
        .O(counters_bad4_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry__0_i_3
       (.I0(status_completed_frames[11]),
        .I1(previous_status[11]),
        .I2(previous_status[10]),
        .I3(status_completed_frames[10]),
        .O(counters_bad4_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry__0_i_4
       (.I0(status_completed_frames[9]),
        .I1(previous_status[9]),
        .I2(previous_status[8]),
        .I3(status_completed_frames[8]),
        .O(counters_bad4_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry__0_i_5
       (.I0(previous_status[15]),
        .I1(status_completed_frames[15]),
        .I2(previous_status[14]),
        .I3(status_completed_frames[14]),
        .O(counters_bad4_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry__0_i_6
       (.I0(previous_status[13]),
        .I1(status_completed_frames[13]),
        .I2(previous_status[12]),
        .I3(status_completed_frames[12]),
        .O(counters_bad4_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry__0_i_7
       (.I0(previous_status[11]),
        .I1(status_completed_frames[11]),
        .I2(previous_status[10]),
        .I3(status_completed_frames[10]),
        .O(counters_bad4_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry__0_i_8
       (.I0(previous_status[9]),
        .I1(status_completed_frames[9]),
        .I2(previous_status[8]),
        .I3(status_completed_frames[8]),
        .O(counters_bad4_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad4_carry__1
       (.CI(counters_bad4_carry__0_n_0),
        .CO({counters_bad4_carry__1_n_0,counters_bad4_carry__1_n_1,counters_bad4_carry__1_n_2,counters_bad4_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad4_carry__1_i_1_n_0,counters_bad4_carry__1_i_2_n_0,counters_bad4_carry__1_i_3_n_0,counters_bad4_carry__1_i_4_n_0}),
        .O(NLW_counters_bad4_carry__1_O_UNCONNECTED[3:0]),
        .S({counters_bad4_carry__1_i_5_n_0,counters_bad4_carry__1_i_6_n_0,counters_bad4_carry__1_i_7_n_0,counters_bad4_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry__1_i_1
       (.I0(status_completed_frames[23]),
        .I1(previous_status[23]),
        .I2(previous_status[22]),
        .I3(status_completed_frames[22]),
        .O(counters_bad4_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry__1_i_2
       (.I0(status_completed_frames[21]),
        .I1(previous_status[21]),
        .I2(previous_status[20]),
        .I3(status_completed_frames[20]),
        .O(counters_bad4_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry__1_i_3
       (.I0(status_completed_frames[19]),
        .I1(previous_status[19]),
        .I2(previous_status[18]),
        .I3(status_completed_frames[18]),
        .O(counters_bad4_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry__1_i_4
       (.I0(status_completed_frames[17]),
        .I1(previous_status[17]),
        .I2(previous_status[16]),
        .I3(status_completed_frames[16]),
        .O(counters_bad4_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry__1_i_5
       (.I0(previous_status[23]),
        .I1(status_completed_frames[23]),
        .I2(previous_status[22]),
        .I3(status_completed_frames[22]),
        .O(counters_bad4_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry__1_i_6
       (.I0(previous_status[21]),
        .I1(status_completed_frames[21]),
        .I2(previous_status[20]),
        .I3(status_completed_frames[20]),
        .O(counters_bad4_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry__1_i_7
       (.I0(previous_status[19]),
        .I1(status_completed_frames[19]),
        .I2(previous_status[18]),
        .I3(status_completed_frames[18]),
        .O(counters_bad4_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry__1_i_8
       (.I0(previous_status[17]),
        .I1(status_completed_frames[17]),
        .I2(previous_status[16]),
        .I3(status_completed_frames[16]),
        .O(counters_bad4_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad4_carry__2
       (.CI(counters_bad4_carry__1_n_0),
        .CO({counters_bad4,counters_bad4_carry__2_n_1,counters_bad4_carry__2_n_2,counters_bad4_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad4_carry__2_i_1_n_0,counters_bad4_carry__2_i_2_n_0,counters_bad4_carry__2_i_3_n_0,counters_bad4_carry__2_i_4_n_0}),
        .O(NLW_counters_bad4_carry__2_O_UNCONNECTED[3:0]),
        .S({counters_bad4_carry__2_i_5_n_0,counters_bad4_carry__2_i_6_n_0,counters_bad4_carry__2_i_7_n_0,counters_bad4_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry__2_i_1
       (.I0(status_completed_frames[31]),
        .I1(previous_status[31]),
        .I2(previous_status[30]),
        .I3(status_completed_frames[30]),
        .O(counters_bad4_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry__2_i_2
       (.I0(status_completed_frames[29]),
        .I1(previous_status[29]),
        .I2(previous_status[28]),
        .I3(status_completed_frames[28]),
        .O(counters_bad4_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry__2_i_3
       (.I0(status_completed_frames[27]),
        .I1(previous_status[27]),
        .I2(previous_status[26]),
        .I3(status_completed_frames[26]),
        .O(counters_bad4_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry__2_i_4
       (.I0(status_completed_frames[25]),
        .I1(previous_status[25]),
        .I2(previous_status[24]),
        .I3(status_completed_frames[24]),
        .O(counters_bad4_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry__2_i_5
       (.I0(previous_status[31]),
        .I1(status_completed_frames[31]),
        .I2(previous_status[30]),
        .I3(status_completed_frames[30]),
        .O(counters_bad4_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry__2_i_6
       (.I0(previous_status[29]),
        .I1(status_completed_frames[29]),
        .I2(previous_status[28]),
        .I3(status_completed_frames[28]),
        .O(counters_bad4_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry__2_i_7
       (.I0(previous_status[27]),
        .I1(status_completed_frames[27]),
        .I2(previous_status[26]),
        .I3(status_completed_frames[26]),
        .O(counters_bad4_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry__2_i_8
       (.I0(previous_status[25]),
        .I1(status_completed_frames[25]),
        .I2(previous_status[24]),
        .I3(status_completed_frames[24]),
        .O(counters_bad4_carry__2_i_8_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry_i_1
       (.I0(status_completed_frames[7]),
        .I1(previous_status[7]),
        .I2(previous_status[6]),
        .I3(status_completed_frames[6]),
        .O(counters_bad4_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry_i_2
       (.I0(status_completed_frames[5]),
        .I1(previous_status[5]),
        .I2(previous_status[4]),
        .I3(status_completed_frames[4]),
        .O(counters_bad4_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry_i_3
       (.I0(status_completed_frames[3]),
        .I1(previous_status[3]),
        .I2(previous_status[2]),
        .I3(status_completed_frames[2]),
        .O(counters_bad4_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    counters_bad4_carry_i_4
       (.I0(status_completed_frames[1]),
        .I1(previous_status[1]),
        .I2(previous_status[0]),
        .I3(status_completed_frames[0]),
        .O(counters_bad4_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry_i_5
       (.I0(previous_status[7]),
        .I1(status_completed_frames[7]),
        .I2(previous_status[6]),
        .I3(status_completed_frames[6]),
        .O(counters_bad4_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry_i_6
       (.I0(previous_status[5]),
        .I1(status_completed_frames[5]),
        .I2(previous_status[4]),
        .I3(status_completed_frames[4]),
        .O(counters_bad4_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry_i_7
       (.I0(previous_status[3]),
        .I1(status_completed_frames[3]),
        .I2(previous_status[2]),
        .I3(status_completed_frames[2]),
        .O(counters_bad4_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad4_carry_i_8
       (.I0(previous_status[1]),
        .I1(status_completed_frames[1]),
        .I2(previous_status[0]),
        .I3(status_completed_frames[0]),
        .O(counters_bad4_carry_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad5_carry
       (.CI(1'b0),
        .CO({counters_bad5_carry_n_0,counters_bad5_carry_n_1,counters_bad5_carry_n_2,counters_bad5_carry_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad5_carry_i_1_n_0,counters_bad5_carry_i_2_n_0,counters_bad5_carry_i_3_n_0,counters_bad5_carry_i_4_n_0}),
        .O(NLW_counters_bad5_carry_O_UNCONNECTED[3:0]),
        .S({counters_bad5_carry_i_5_n_0,counters_bad5_carry_i_6_n_0,counters_bad5_carry_i_7_n_0,counters_bad5_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad5_carry__0
       (.CI(counters_bad5_carry_n_0),
        .CO({counters_bad5_carry__0_n_0,counters_bad5_carry__0_n_1,counters_bad5_carry__0_n_2,counters_bad5_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad5_carry__0_i_1_n_0,counters_bad5_carry__0_i_2_n_0,counters_bad5_carry__0_i_3_n_0,counters_bad5_carry__0_i_4_n_0}),
        .O(NLW_counters_bad5_carry__0_O_UNCONNECTED[3:0]),
        .S({counters_bad5_carry__0_i_5_n_0,counters_bad5_carry__0_i_6_n_0,counters_bad5_carry__0_i_7_n_0,counters_bad5_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry__0_i_1
       (.I0(previous_rgb[15]),
        .I1(rgb_completed_frames[15]),
        .I2(previous_rgb[14]),
        .I3(rgb_completed_frames[14]),
        .O(counters_bad5_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry__0_i_2
       (.I0(previous_rgb[13]),
        .I1(rgb_completed_frames[13]),
        .I2(previous_rgb[12]),
        .I3(rgb_completed_frames[12]),
        .O(counters_bad5_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry__0_i_3
       (.I0(previous_rgb[11]),
        .I1(rgb_completed_frames[11]),
        .I2(previous_rgb[10]),
        .I3(rgb_completed_frames[10]),
        .O(counters_bad5_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry__0_i_4
       (.I0(previous_rgb[9]),
        .I1(rgb_completed_frames[9]),
        .I2(previous_rgb[8]),
        .I3(rgb_completed_frames[8]),
        .O(counters_bad5_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry__0_i_5
       (.I0(rgb_completed_frames[15]),
        .I1(previous_rgb[15]),
        .I2(rgb_completed_frames[14]),
        .I3(previous_rgb[14]),
        .O(counters_bad5_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry__0_i_6
       (.I0(rgb_completed_frames[13]),
        .I1(previous_rgb[13]),
        .I2(rgb_completed_frames[12]),
        .I3(previous_rgb[12]),
        .O(counters_bad5_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry__0_i_7
       (.I0(rgb_completed_frames[11]),
        .I1(previous_rgb[11]),
        .I2(rgb_completed_frames[10]),
        .I3(previous_rgb[10]),
        .O(counters_bad5_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry__0_i_8
       (.I0(rgb_completed_frames[9]),
        .I1(previous_rgb[9]),
        .I2(rgb_completed_frames[8]),
        .I3(previous_rgb[8]),
        .O(counters_bad5_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad5_carry__1
       (.CI(counters_bad5_carry__0_n_0),
        .CO({counters_bad5_carry__1_n_0,counters_bad5_carry__1_n_1,counters_bad5_carry__1_n_2,counters_bad5_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad5_carry__1_i_1_n_0,counters_bad5_carry__1_i_2_n_0,counters_bad5_carry__1_i_3_n_0,counters_bad5_carry__1_i_4_n_0}),
        .O(NLW_counters_bad5_carry__1_O_UNCONNECTED[3:0]),
        .S({counters_bad5_carry__1_i_5_n_0,counters_bad5_carry__1_i_6_n_0,counters_bad5_carry__1_i_7_n_0,counters_bad5_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry__1_i_1
       (.I0(previous_rgb[23]),
        .I1(rgb_completed_frames[23]),
        .I2(previous_rgb[22]),
        .I3(rgb_completed_frames[22]),
        .O(counters_bad5_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry__1_i_2
       (.I0(previous_rgb[21]),
        .I1(rgb_completed_frames[21]),
        .I2(previous_rgb[20]),
        .I3(rgb_completed_frames[20]),
        .O(counters_bad5_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry__1_i_3
       (.I0(previous_rgb[19]),
        .I1(rgb_completed_frames[19]),
        .I2(previous_rgb[18]),
        .I3(rgb_completed_frames[18]),
        .O(counters_bad5_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry__1_i_4
       (.I0(previous_rgb[17]),
        .I1(rgb_completed_frames[17]),
        .I2(previous_rgb[16]),
        .I3(rgb_completed_frames[16]),
        .O(counters_bad5_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry__1_i_5
       (.I0(rgb_completed_frames[23]),
        .I1(previous_rgb[23]),
        .I2(rgb_completed_frames[22]),
        .I3(previous_rgb[22]),
        .O(counters_bad5_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry__1_i_6
       (.I0(rgb_completed_frames[21]),
        .I1(previous_rgb[21]),
        .I2(rgb_completed_frames[20]),
        .I3(previous_rgb[20]),
        .O(counters_bad5_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry__1_i_7
       (.I0(rgb_completed_frames[19]),
        .I1(previous_rgb[19]),
        .I2(rgb_completed_frames[18]),
        .I3(previous_rgb[18]),
        .O(counters_bad5_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry__1_i_8
       (.I0(rgb_completed_frames[17]),
        .I1(previous_rgb[17]),
        .I2(rgb_completed_frames[16]),
        .I3(previous_rgb[16]),
        .O(counters_bad5_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 counters_bad5_carry__2
       (.CI(counters_bad5_carry__1_n_0),
        .CO({counters_bad54_in,counters_bad5_carry__2_n_1,counters_bad5_carry__2_n_2,counters_bad5_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({counters_bad5_carry__2_i_1_n_0,counters_bad5_carry__2_i_2_n_0,counters_bad5_carry__2_i_3_n_0,counters_bad5_carry__2_i_4_n_0}),
        .O(NLW_counters_bad5_carry__2_O_UNCONNECTED[3:0]),
        .S({counters_bad5_carry__2_i_5_n_0,counters_bad5_carry__2_i_6_n_0,counters_bad5_carry__2_i_7_n_0,counters_bad5_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry__2_i_1
       (.I0(previous_rgb[31]),
        .I1(rgb_completed_frames[31]),
        .I2(previous_rgb[30]),
        .I3(rgb_completed_frames[30]),
        .O(counters_bad5_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry__2_i_2
       (.I0(previous_rgb[29]),
        .I1(rgb_completed_frames[29]),
        .I2(previous_rgb[28]),
        .I3(rgb_completed_frames[28]),
        .O(counters_bad5_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry__2_i_3
       (.I0(previous_rgb[27]),
        .I1(rgb_completed_frames[27]),
        .I2(previous_rgb[26]),
        .I3(rgb_completed_frames[26]),
        .O(counters_bad5_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry__2_i_4
       (.I0(previous_rgb[25]),
        .I1(rgb_completed_frames[25]),
        .I2(previous_rgb[24]),
        .I3(rgb_completed_frames[24]),
        .O(counters_bad5_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry__2_i_5
       (.I0(rgb_completed_frames[31]),
        .I1(previous_rgb[31]),
        .I2(rgb_completed_frames[30]),
        .I3(previous_rgb[30]),
        .O(counters_bad5_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry__2_i_6
       (.I0(rgb_completed_frames[29]),
        .I1(previous_rgb[29]),
        .I2(rgb_completed_frames[28]),
        .I3(previous_rgb[28]),
        .O(counters_bad5_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry__2_i_7
       (.I0(rgb_completed_frames[27]),
        .I1(previous_rgb[27]),
        .I2(rgb_completed_frames[26]),
        .I3(previous_rgb[26]),
        .O(counters_bad5_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry__2_i_8
       (.I0(rgb_completed_frames[25]),
        .I1(previous_rgb[25]),
        .I2(rgb_completed_frames[24]),
        .I3(previous_rgb[24]),
        .O(counters_bad5_carry__2_i_8_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry_i_1
       (.I0(previous_rgb[7]),
        .I1(rgb_completed_frames[7]),
        .I2(previous_rgb[6]),
        .I3(rgb_completed_frames[6]),
        .O(counters_bad5_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry_i_2
       (.I0(previous_rgb[5]),
        .I1(rgb_completed_frames[5]),
        .I2(previous_rgb[4]),
        .I3(rgb_completed_frames[4]),
        .O(counters_bad5_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry_i_3
       (.I0(previous_rgb[3]),
        .I1(rgb_completed_frames[3]),
        .I2(previous_rgb[2]),
        .I3(rgb_completed_frames[2]),
        .O(counters_bad5_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    counters_bad5_carry_i_4
       (.I0(previous_rgb[1]),
        .I1(rgb_completed_frames[1]),
        .I2(previous_rgb[0]),
        .I3(rgb_completed_frames[0]),
        .O(counters_bad5_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry_i_5
       (.I0(rgb_completed_frames[7]),
        .I1(previous_rgb[7]),
        .I2(rgb_completed_frames[6]),
        .I3(previous_rgb[6]),
        .O(counters_bad5_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry_i_6
       (.I0(rgb_completed_frames[5]),
        .I1(previous_rgb[5]),
        .I2(rgb_completed_frames[4]),
        .I3(previous_rgb[4]),
        .O(counters_bad5_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry_i_7
       (.I0(rgb_completed_frames[3]),
        .I1(previous_rgb[3]),
        .I2(rgb_completed_frames[2]),
        .I3(previous_rgb[2]),
        .O(counters_bad5_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    counters_bad5_carry_i_8
       (.I0(rgb_completed_frames[1]),
        .I1(previous_rgb[1]),
        .I2(rgb_completed_frames[0]),
        .I3(previous_rgb[0]),
        .O(counters_bad5_carry_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \counters_bad5_inferred__0/i__carry 
       (.CI(1'b0),
        .CO({\counters_bad5_inferred__0/i__carry_n_0 ,\counters_bad5_inferred__0/i__carry_n_1 ,\counters_bad5_inferred__0/i__carry_n_2 ,\counters_bad5_inferred__0/i__carry_n_3 }),
        .CYINIT(1'b0),
        .DI({i__carry_i_1_n_0,i__carry_i_2_n_0,i__carry_i_3_n_0,i__carry_i_4_n_0}),
        .O(\NLW_counters_bad5_inferred__0/i__carry_O_UNCONNECTED [3:0]),
        .S({i__carry_i_5_n_0,i__carry_i_6_n_0,i__carry_i_7_n_0,i__carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \counters_bad5_inferred__0/i__carry__0 
       (.CI(\counters_bad5_inferred__0/i__carry_n_0 ),
        .CO({\counters_bad5_inferred__0/i__carry__0_n_0 ,\counters_bad5_inferred__0/i__carry__0_n_1 ,\counters_bad5_inferred__0/i__carry__0_n_2 ,\counters_bad5_inferred__0/i__carry__0_n_3 }),
        .CYINIT(1'b0),
        .DI({i__carry__0_i_1_n_0,i__carry__0_i_2_n_0,i__carry__0_i_3_n_0,i__carry__0_i_4_n_0}),
        .O(\NLW_counters_bad5_inferred__0/i__carry__0_O_UNCONNECTED [3:0]),
        .S({i__carry__0_i_5_n_0,i__carry__0_i_6_n_0,i__carry__0_i_7_n_0,i__carry__0_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \counters_bad5_inferred__0/i__carry__1 
       (.CI(\counters_bad5_inferred__0/i__carry__0_n_0 ),
        .CO({\counters_bad5_inferred__0/i__carry__1_n_0 ,\counters_bad5_inferred__0/i__carry__1_n_1 ,\counters_bad5_inferred__0/i__carry__1_n_2 ,\counters_bad5_inferred__0/i__carry__1_n_3 }),
        .CYINIT(1'b0),
        .DI({i__carry__1_i_1_n_0,i__carry__1_i_2_n_0,i__carry__1_i_3_n_0,i__carry__1_i_4_n_0}),
        .O(\NLW_counters_bad5_inferred__0/i__carry__1_O_UNCONNECTED [3:0]),
        .S({i__carry__1_i_5_n_0,i__carry__1_i_6_n_0,i__carry__1_i_7_n_0,i__carry__1_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 \counters_bad5_inferred__0/i__carry__2 
       (.CI(\counters_bad5_inferred__0/i__carry__1_n_0 ),
        .CO({counters_bad5,\counters_bad5_inferred__0/i__carry__2_n_1 ,\counters_bad5_inferred__0/i__carry__2_n_2 ,\counters_bad5_inferred__0/i__carry__2_n_3 }),
        .CYINIT(1'b0),
        .DI({i__carry__2_i_1_n_0,i__carry__2_i_2_n_0,i__carry__2_i_3_n_0,i__carry__2_i_4_n_0}),
        .O(\NLW_counters_bad5_inferred__0/i__carry__2_O_UNCONNECTED [3:0]),
        .S({i__carry__2_i_5_n_0,i__carry__2_i_6_n_0,i__carry__2_i_7_n_0,i__carry__2_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available0_carry
       (.CI(1'b0),
        .CO({cpu_available0_carry_n_0,cpu_available0_carry_n_1,cpu_available0_carry_n_2,cpu_available0_carry_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available0_carry_i_1_n_0,cpu_available0_carry_i_2_n_0,cpu_available0_carry_i_3_n_0,cpu_available0_carry_i_4_n_0}),
        .O(NLW_cpu_available0_carry_O_UNCONNECTED[3:0]),
        .S({cpu_available0_carry_i_5_n_0,cpu_available0_carry_i_6_n_0,cpu_available0_carry_i_7_n_0,cpu_available0_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available0_carry__0
       (.CI(cpu_available0_carry_n_0),
        .CO({cpu_available0_carry__0_n_0,cpu_available0_carry__0_n_1,cpu_available0_carry__0_n_2,cpu_available0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available0_carry__0_i_1_n_0,cpu_available0_carry__0_i_2_n_0,cpu_available0_carry__0_i_3_n_0,cpu_available0_carry__0_i_4_n_0}),
        .O(NLW_cpu_available0_carry__0_O_UNCONNECTED[3:0]),
        .S({cpu_available0_carry__0_i_5_n_0,cpu_available0_carry__0_i_6_n_0,cpu_available0_carry__0_i_7_n_0,cpu_available0_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry__0_i_1
       (.I0(status_completed_frames[15]),
        .I1(\released_frames_reg[31]_0 [15]),
        .I2(status_completed_frames[14]),
        .I3(\released_frames_reg[31]_0 [14]),
        .O(cpu_available0_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry__0_i_2
       (.I0(status_completed_frames[13]),
        .I1(\released_frames_reg[31]_0 [13]),
        .I2(status_completed_frames[12]),
        .I3(\released_frames_reg[31]_0 [12]),
        .O(cpu_available0_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry__0_i_3
       (.I0(status_completed_frames[11]),
        .I1(\released_frames_reg[31]_0 [11]),
        .I2(status_completed_frames[10]),
        .I3(\released_frames_reg[31]_0 [10]),
        .O(cpu_available0_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry__0_i_4
       (.I0(status_completed_frames[9]),
        .I1(\released_frames_reg[31]_0 [9]),
        .I2(status_completed_frames[8]),
        .I3(\released_frames_reg[31]_0 [8]),
        .O(cpu_available0_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry__0_i_5
       (.I0(\released_frames_reg[31]_0 [15]),
        .I1(status_completed_frames[15]),
        .I2(\released_frames_reg[31]_0 [14]),
        .I3(status_completed_frames[14]),
        .O(cpu_available0_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry__0_i_6
       (.I0(\released_frames_reg[31]_0 [13]),
        .I1(status_completed_frames[13]),
        .I2(\released_frames_reg[31]_0 [12]),
        .I3(status_completed_frames[12]),
        .O(cpu_available0_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry__0_i_7
       (.I0(\released_frames_reg[31]_0 [11]),
        .I1(status_completed_frames[11]),
        .I2(\released_frames_reg[31]_0 [10]),
        .I3(status_completed_frames[10]),
        .O(cpu_available0_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry__0_i_8
       (.I0(\released_frames_reg[31]_0 [9]),
        .I1(status_completed_frames[9]),
        .I2(\released_frames_reg[31]_0 [8]),
        .I3(status_completed_frames[8]),
        .O(cpu_available0_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available0_carry__1
       (.CI(cpu_available0_carry__0_n_0),
        .CO({cpu_available0_carry__1_n_0,cpu_available0_carry__1_n_1,cpu_available0_carry__1_n_2,cpu_available0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available0_carry__1_i_1_n_0,cpu_available0_carry__1_i_2_n_0,cpu_available0_carry__1_i_3_n_0,cpu_available0_carry__1_i_4_n_0}),
        .O(NLW_cpu_available0_carry__1_O_UNCONNECTED[3:0]),
        .S({cpu_available0_carry__1_i_5_n_0,cpu_available0_carry__1_i_6_n_0,cpu_available0_carry__1_i_7_n_0,cpu_available0_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry__1_i_1
       (.I0(status_completed_frames[23]),
        .I1(\released_frames_reg[31]_0 [23]),
        .I2(status_completed_frames[22]),
        .I3(\released_frames_reg[31]_0 [22]),
        .O(cpu_available0_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry__1_i_2
       (.I0(status_completed_frames[21]),
        .I1(\released_frames_reg[31]_0 [21]),
        .I2(status_completed_frames[20]),
        .I3(\released_frames_reg[31]_0 [20]),
        .O(cpu_available0_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry__1_i_3
       (.I0(status_completed_frames[19]),
        .I1(\released_frames_reg[31]_0 [19]),
        .I2(status_completed_frames[18]),
        .I3(\released_frames_reg[31]_0 [18]),
        .O(cpu_available0_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry__1_i_4
       (.I0(status_completed_frames[17]),
        .I1(\released_frames_reg[31]_0 [17]),
        .I2(status_completed_frames[16]),
        .I3(\released_frames_reg[31]_0 [16]),
        .O(cpu_available0_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry__1_i_5
       (.I0(\released_frames_reg[31]_0 [23]),
        .I1(status_completed_frames[23]),
        .I2(\released_frames_reg[31]_0 [22]),
        .I3(status_completed_frames[22]),
        .O(cpu_available0_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry__1_i_6
       (.I0(\released_frames_reg[31]_0 [21]),
        .I1(status_completed_frames[21]),
        .I2(\released_frames_reg[31]_0 [20]),
        .I3(status_completed_frames[20]),
        .O(cpu_available0_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry__1_i_7
       (.I0(\released_frames_reg[31]_0 [19]),
        .I1(status_completed_frames[19]),
        .I2(\released_frames_reg[31]_0 [18]),
        .I3(status_completed_frames[18]),
        .O(cpu_available0_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry__1_i_8
       (.I0(\released_frames_reg[31]_0 [17]),
        .I1(status_completed_frames[17]),
        .I2(\released_frames_reg[31]_0 [16]),
        .I3(status_completed_frames[16]),
        .O(cpu_available0_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available0_carry__2
       (.CI(cpu_available0_carry__1_n_0),
        .CO({cpu_available0,cpu_available0_carry__2_n_1,cpu_available0_carry__2_n_2,cpu_available0_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available0_carry__2_i_1_n_0,cpu_available0_carry__2_i_2_n_0,cpu_available0_carry__2_i_3_n_0,cpu_available0_carry__2_i_4_n_0}),
        .O(NLW_cpu_available0_carry__2_O_UNCONNECTED[3:0]),
        .S({cpu_available0_carry__2_i_5_n_0,cpu_available0_carry__2_i_6_n_0,cpu_available0_carry__2_i_7_n_0,cpu_available0_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry__2_i_1
       (.I0(status_completed_frames[31]),
        .I1(\released_frames_reg[31]_0 [31]),
        .I2(status_completed_frames[30]),
        .I3(\released_frames_reg[31]_0 [30]),
        .O(cpu_available0_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry__2_i_2
       (.I0(status_completed_frames[29]),
        .I1(\released_frames_reg[31]_0 [29]),
        .I2(status_completed_frames[28]),
        .I3(\released_frames_reg[31]_0 [28]),
        .O(cpu_available0_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry__2_i_3
       (.I0(status_completed_frames[27]),
        .I1(\released_frames_reg[31]_0 [27]),
        .I2(status_completed_frames[26]),
        .I3(\released_frames_reg[31]_0 [26]),
        .O(cpu_available0_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry__2_i_4
       (.I0(status_completed_frames[25]),
        .I1(\released_frames_reg[31]_0 [25]),
        .I2(status_completed_frames[24]),
        .I3(\released_frames_reg[31]_0 [24]),
        .O(cpu_available0_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry__2_i_5
       (.I0(\released_frames_reg[31]_0 [31]),
        .I1(status_completed_frames[31]),
        .I2(\released_frames_reg[31]_0 [30]),
        .I3(status_completed_frames[30]),
        .O(cpu_available0_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry__2_i_6
       (.I0(\released_frames_reg[31]_0 [29]),
        .I1(status_completed_frames[29]),
        .I2(\released_frames_reg[31]_0 [28]),
        .I3(status_completed_frames[28]),
        .O(cpu_available0_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry__2_i_7
       (.I0(\released_frames_reg[31]_0 [27]),
        .I1(status_completed_frames[27]),
        .I2(\released_frames_reg[31]_0 [26]),
        .I3(status_completed_frames[26]),
        .O(cpu_available0_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry__2_i_8
       (.I0(\released_frames_reg[31]_0 [25]),
        .I1(status_completed_frames[25]),
        .I2(\released_frames_reg[31]_0 [24]),
        .I3(status_completed_frames[24]),
        .O(cpu_available0_carry__2_i_8_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry_i_1
       (.I0(status_completed_frames[7]),
        .I1(\released_frames_reg[31]_0 [7]),
        .I2(status_completed_frames[6]),
        .I3(\released_frames_reg[31]_0 [6]),
        .O(cpu_available0_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry_i_2
       (.I0(status_completed_frames[5]),
        .I1(\released_frames_reg[31]_0 [5]),
        .I2(status_completed_frames[4]),
        .I3(\released_frames_reg[31]_0 [4]),
        .O(cpu_available0_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry_i_3
       (.I0(status_completed_frames[3]),
        .I1(\released_frames_reg[31]_0 [3]),
        .I2(status_completed_frames[2]),
        .I3(\released_frames_reg[31]_0 [2]),
        .O(cpu_available0_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available0_carry_i_4
       (.I0(status_completed_frames[1]),
        .I1(\released_frames_reg[31]_0 [1]),
        .I2(status_completed_frames[0]),
        .I3(\released_frames_reg[31]_0 [0]),
        .O(cpu_available0_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry_i_5
       (.I0(\released_frames_reg[31]_0 [7]),
        .I1(status_completed_frames[7]),
        .I2(\released_frames_reg[31]_0 [6]),
        .I3(status_completed_frames[6]),
        .O(cpu_available0_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry_i_6
       (.I0(\released_frames_reg[31]_0 [5]),
        .I1(status_completed_frames[5]),
        .I2(\released_frames_reg[31]_0 [4]),
        .I3(status_completed_frames[4]),
        .O(cpu_available0_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry_i_7
       (.I0(\released_frames_reg[31]_0 [3]),
        .I1(status_completed_frames[3]),
        .I2(\released_frames_reg[31]_0 [2]),
        .I3(status_completed_frames[2]),
        .O(cpu_available0_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available0_carry_i_8
       (.I0(\released_frames_reg[31]_0 [1]),
        .I1(status_completed_frames[1]),
        .I2(\released_frames_reg[31]_0 [0]),
        .I3(status_completed_frames[0]),
        .O(cpu_available0_carry_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available1_carry
       (.CI(1'b0),
        .CO({cpu_available1_carry_n_0,cpu_available1_carry_n_1,cpu_available1_carry_n_2,cpu_available1_carry_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available1_carry_i_1_n_0,cpu_available1_carry_i_2_n_0,cpu_available1_carry_i_3_n_0,cpu_available1_carry_i_4_n_0}),
        .O(NLW_cpu_available1_carry_O_UNCONNECTED[3:0]),
        .S({cpu_available1_carry_i_5_n_0,cpu_available1_carry_i_6_n_0,cpu_available1_carry_i_7_n_0,cpu_available1_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available1_carry__0
       (.CI(cpu_available1_carry_n_0),
        .CO({cpu_available1_carry__0_n_0,cpu_available1_carry__0_n_1,cpu_available1_carry__0_n_2,cpu_available1_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available1_carry__0_i_1_n_0,cpu_available1_carry__0_i_2_n_0,cpu_available1_carry__0_i_3_n_0,cpu_available1_carry__0_i_4_n_0}),
        .O(NLW_cpu_available1_carry__0_O_UNCONNECTED[3:0]),
        .S({cpu_available1_carry__0_i_5_n_0,cpu_available1_carry__0_i_6_n_0,cpu_available1_carry__0_i_7_n_0,cpu_available1_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry__0_i_1
       (.I0(packet_completed_frames[15]),
        .I1(\released_frames_reg[31]_0 [15]),
        .I2(packet_completed_frames[14]),
        .I3(\released_frames_reg[31]_0 [14]),
        .O(cpu_available1_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry__0_i_2
       (.I0(packet_completed_frames[13]),
        .I1(\released_frames_reg[31]_0 [13]),
        .I2(packet_completed_frames[12]),
        .I3(\released_frames_reg[31]_0 [12]),
        .O(cpu_available1_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry__0_i_3
       (.I0(packet_completed_frames[11]),
        .I1(\released_frames_reg[31]_0 [11]),
        .I2(packet_completed_frames[10]),
        .I3(\released_frames_reg[31]_0 [10]),
        .O(cpu_available1_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry__0_i_4
       (.I0(packet_completed_frames[9]),
        .I1(\released_frames_reg[31]_0 [9]),
        .I2(packet_completed_frames[8]),
        .I3(\released_frames_reg[31]_0 [8]),
        .O(cpu_available1_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry__0_i_5
       (.I0(\released_frames_reg[31]_0 [15]),
        .I1(packet_completed_frames[15]),
        .I2(\released_frames_reg[31]_0 [14]),
        .I3(packet_completed_frames[14]),
        .O(cpu_available1_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry__0_i_6
       (.I0(\released_frames_reg[31]_0 [13]),
        .I1(packet_completed_frames[13]),
        .I2(\released_frames_reg[31]_0 [12]),
        .I3(packet_completed_frames[12]),
        .O(cpu_available1_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry__0_i_7
       (.I0(\released_frames_reg[31]_0 [11]),
        .I1(packet_completed_frames[11]),
        .I2(\released_frames_reg[31]_0 [10]),
        .I3(packet_completed_frames[10]),
        .O(cpu_available1_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry__0_i_8
       (.I0(\released_frames_reg[31]_0 [9]),
        .I1(packet_completed_frames[9]),
        .I2(\released_frames_reg[31]_0 [8]),
        .I3(packet_completed_frames[8]),
        .O(cpu_available1_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available1_carry__1
       (.CI(cpu_available1_carry__0_n_0),
        .CO({cpu_available1_carry__1_n_0,cpu_available1_carry__1_n_1,cpu_available1_carry__1_n_2,cpu_available1_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available1_carry__1_i_1_n_0,cpu_available1_carry__1_i_2_n_0,cpu_available1_carry__1_i_3_n_0,cpu_available1_carry__1_i_4_n_0}),
        .O(NLW_cpu_available1_carry__1_O_UNCONNECTED[3:0]),
        .S({cpu_available1_carry__1_i_5_n_0,cpu_available1_carry__1_i_6_n_0,cpu_available1_carry__1_i_7_n_0,cpu_available1_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry__1_i_1
       (.I0(packet_completed_frames[23]),
        .I1(\released_frames_reg[31]_0 [23]),
        .I2(packet_completed_frames[22]),
        .I3(\released_frames_reg[31]_0 [22]),
        .O(cpu_available1_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry__1_i_2
       (.I0(packet_completed_frames[21]),
        .I1(\released_frames_reg[31]_0 [21]),
        .I2(packet_completed_frames[20]),
        .I3(\released_frames_reg[31]_0 [20]),
        .O(cpu_available1_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry__1_i_3
       (.I0(packet_completed_frames[19]),
        .I1(\released_frames_reg[31]_0 [19]),
        .I2(packet_completed_frames[18]),
        .I3(\released_frames_reg[31]_0 [18]),
        .O(cpu_available1_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry__1_i_4
       (.I0(packet_completed_frames[17]),
        .I1(\released_frames_reg[31]_0 [17]),
        .I2(packet_completed_frames[16]),
        .I3(\released_frames_reg[31]_0 [16]),
        .O(cpu_available1_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry__1_i_5
       (.I0(\released_frames_reg[31]_0 [23]),
        .I1(packet_completed_frames[23]),
        .I2(\released_frames_reg[31]_0 [22]),
        .I3(packet_completed_frames[22]),
        .O(cpu_available1_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry__1_i_6
       (.I0(\released_frames_reg[31]_0 [21]),
        .I1(packet_completed_frames[21]),
        .I2(\released_frames_reg[31]_0 [20]),
        .I3(packet_completed_frames[20]),
        .O(cpu_available1_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry__1_i_7
       (.I0(\released_frames_reg[31]_0 [19]),
        .I1(packet_completed_frames[19]),
        .I2(\released_frames_reg[31]_0 [18]),
        .I3(packet_completed_frames[18]),
        .O(cpu_available1_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry__1_i_8
       (.I0(\released_frames_reg[31]_0 [17]),
        .I1(packet_completed_frames[17]),
        .I2(\released_frames_reg[31]_0 [16]),
        .I3(packet_completed_frames[16]),
        .O(cpu_available1_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available1_carry__2
       (.CI(cpu_available1_carry__1_n_0),
        .CO({cpu_available1,cpu_available1_carry__2_n_1,cpu_available1_carry__2_n_2,cpu_available1_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available1_carry__2_i_1_n_0,cpu_available1_carry__2_i_2_n_0,cpu_available1_carry__2_i_3_n_0,cpu_available1_carry__2_i_4_n_0}),
        .O(NLW_cpu_available1_carry__2_O_UNCONNECTED[3:0]),
        .S({cpu_available1_carry__2_i_5_n_0,cpu_available1_carry__2_i_6_n_0,cpu_available1_carry__2_i_7_n_0,cpu_available1_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry__2_i_1
       (.I0(packet_completed_frames[31]),
        .I1(\released_frames_reg[31]_0 [31]),
        .I2(packet_completed_frames[30]),
        .I3(\released_frames_reg[31]_0 [30]),
        .O(cpu_available1_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry__2_i_2
       (.I0(packet_completed_frames[29]),
        .I1(\released_frames_reg[31]_0 [29]),
        .I2(packet_completed_frames[28]),
        .I3(\released_frames_reg[31]_0 [28]),
        .O(cpu_available1_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry__2_i_3
       (.I0(packet_completed_frames[27]),
        .I1(\released_frames_reg[31]_0 [27]),
        .I2(packet_completed_frames[26]),
        .I3(\released_frames_reg[31]_0 [26]),
        .O(cpu_available1_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry__2_i_4
       (.I0(packet_completed_frames[25]),
        .I1(\released_frames_reg[31]_0 [25]),
        .I2(packet_completed_frames[24]),
        .I3(\released_frames_reg[31]_0 [24]),
        .O(cpu_available1_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry__2_i_5
       (.I0(\released_frames_reg[31]_0 [31]),
        .I1(packet_completed_frames[31]),
        .I2(\released_frames_reg[31]_0 [30]),
        .I3(packet_completed_frames[30]),
        .O(cpu_available1_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry__2_i_6
       (.I0(\released_frames_reg[31]_0 [29]),
        .I1(packet_completed_frames[29]),
        .I2(\released_frames_reg[31]_0 [28]),
        .I3(packet_completed_frames[28]),
        .O(cpu_available1_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry__2_i_7
       (.I0(\released_frames_reg[31]_0 [27]),
        .I1(packet_completed_frames[27]),
        .I2(\released_frames_reg[31]_0 [26]),
        .I3(packet_completed_frames[26]),
        .O(cpu_available1_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry__2_i_8
       (.I0(\released_frames_reg[31]_0 [25]),
        .I1(packet_completed_frames[25]),
        .I2(\released_frames_reg[31]_0 [24]),
        .I3(packet_completed_frames[24]),
        .O(cpu_available1_carry__2_i_8_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry_i_1
       (.I0(packet_completed_frames[7]),
        .I1(\released_frames_reg[31]_0 [7]),
        .I2(packet_completed_frames[6]),
        .I3(\released_frames_reg[31]_0 [6]),
        .O(cpu_available1_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry_i_2
       (.I0(packet_completed_frames[5]),
        .I1(\released_frames_reg[31]_0 [5]),
        .I2(packet_completed_frames[4]),
        .I3(\released_frames_reg[31]_0 [4]),
        .O(cpu_available1_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry_i_3
       (.I0(packet_completed_frames[3]),
        .I1(\released_frames_reg[31]_0 [3]),
        .I2(packet_completed_frames[2]),
        .I3(\released_frames_reg[31]_0 [2]),
        .O(cpu_available1_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available1_carry_i_4
       (.I0(packet_completed_frames[1]),
        .I1(\released_frames_reg[31]_0 [1]),
        .I2(packet_completed_frames[0]),
        .I3(\released_frames_reg[31]_0 [0]),
        .O(cpu_available1_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry_i_5
       (.I0(\released_frames_reg[31]_0 [7]),
        .I1(packet_completed_frames[7]),
        .I2(\released_frames_reg[31]_0 [6]),
        .I3(packet_completed_frames[6]),
        .O(cpu_available1_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry_i_6
       (.I0(\released_frames_reg[31]_0 [5]),
        .I1(packet_completed_frames[5]),
        .I2(\released_frames_reg[31]_0 [4]),
        .I3(packet_completed_frames[4]),
        .O(cpu_available1_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry_i_7
       (.I0(\released_frames_reg[31]_0 [3]),
        .I1(packet_completed_frames[3]),
        .I2(\released_frames_reg[31]_0 [2]),
        .I3(packet_completed_frames[2]),
        .O(cpu_available1_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available1_carry_i_8
       (.I0(\released_frames_reg[31]_0 [1]),
        .I1(packet_completed_frames[1]),
        .I2(\released_frames_reg[31]_0 [0]),
        .I3(packet_completed_frames[0]),
        .O(cpu_available1_carry_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available2_carry
       (.CI(1'b0),
        .CO({cpu_available2_carry_n_0,cpu_available2_carry_n_1,cpu_available2_carry_n_2,cpu_available2_carry_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available2_carry_i_1_n_0,cpu_available2_carry_i_2_n_0,cpu_available2_carry_i_3_n_0,cpu_available2_carry_i_4_n_0}),
        .O(NLW_cpu_available2_carry_O_UNCONNECTED[3:0]),
        .S({cpu_available2_carry_i_5_n_0,cpu_available2_carry_i_6_n_0,cpu_available2_carry_i_7_n_0,cpu_available2_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available2_carry__0
       (.CI(cpu_available2_carry_n_0),
        .CO({cpu_available2_carry__0_n_0,cpu_available2_carry__0_n_1,cpu_available2_carry__0_n_2,cpu_available2_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available2_carry__0_i_1_n_0,cpu_available2_carry__0_i_2_n_0,cpu_available2_carry__0_i_3_n_0,cpu_available2_carry__0_i_4_n_0}),
        .O(NLW_cpu_available2_carry__0_O_UNCONNECTED[3:0]),
        .S({cpu_available2_carry__0_i_5_n_0,cpu_available2_carry__0_i_6_n_0,cpu_available2_carry__0_i_7_n_0,cpu_available2_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry__0_i_1
       (.I0(rgb_completed_frames[15]),
        .I1(\released_frames_reg[31]_0 [15]),
        .I2(rgb_completed_frames[14]),
        .I3(\released_frames_reg[31]_0 [14]),
        .O(cpu_available2_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry__0_i_2
       (.I0(rgb_completed_frames[13]),
        .I1(\released_frames_reg[31]_0 [13]),
        .I2(rgb_completed_frames[12]),
        .I3(\released_frames_reg[31]_0 [12]),
        .O(cpu_available2_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry__0_i_3
       (.I0(rgb_completed_frames[11]),
        .I1(\released_frames_reg[31]_0 [11]),
        .I2(rgb_completed_frames[10]),
        .I3(\released_frames_reg[31]_0 [10]),
        .O(cpu_available2_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry__0_i_4
       (.I0(rgb_completed_frames[9]),
        .I1(\released_frames_reg[31]_0 [9]),
        .I2(rgb_completed_frames[8]),
        .I3(\released_frames_reg[31]_0 [8]),
        .O(cpu_available2_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry__0_i_5
       (.I0(\released_frames_reg[31]_0 [15]),
        .I1(rgb_completed_frames[15]),
        .I2(\released_frames_reg[31]_0 [14]),
        .I3(rgb_completed_frames[14]),
        .O(cpu_available2_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry__0_i_6
       (.I0(\released_frames_reg[31]_0 [13]),
        .I1(rgb_completed_frames[13]),
        .I2(\released_frames_reg[31]_0 [12]),
        .I3(rgb_completed_frames[12]),
        .O(cpu_available2_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry__0_i_7
       (.I0(\released_frames_reg[31]_0 [11]),
        .I1(rgb_completed_frames[11]),
        .I2(\released_frames_reg[31]_0 [10]),
        .I3(rgb_completed_frames[10]),
        .O(cpu_available2_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry__0_i_8
       (.I0(\released_frames_reg[31]_0 [9]),
        .I1(rgb_completed_frames[9]),
        .I2(\released_frames_reg[31]_0 [8]),
        .I3(rgb_completed_frames[8]),
        .O(cpu_available2_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available2_carry__1
       (.CI(cpu_available2_carry__0_n_0),
        .CO({cpu_available2_carry__1_n_0,cpu_available2_carry__1_n_1,cpu_available2_carry__1_n_2,cpu_available2_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available2_carry__1_i_1_n_0,cpu_available2_carry__1_i_2_n_0,cpu_available2_carry__1_i_3_n_0,cpu_available2_carry__1_i_4_n_0}),
        .O(NLW_cpu_available2_carry__1_O_UNCONNECTED[3:0]),
        .S({cpu_available2_carry__1_i_5_n_0,cpu_available2_carry__1_i_6_n_0,cpu_available2_carry__1_i_7_n_0,cpu_available2_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry__1_i_1
       (.I0(rgb_completed_frames[23]),
        .I1(\released_frames_reg[31]_0 [23]),
        .I2(rgb_completed_frames[22]),
        .I3(\released_frames_reg[31]_0 [22]),
        .O(cpu_available2_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry__1_i_2
       (.I0(rgb_completed_frames[21]),
        .I1(\released_frames_reg[31]_0 [21]),
        .I2(rgb_completed_frames[20]),
        .I3(\released_frames_reg[31]_0 [20]),
        .O(cpu_available2_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry__1_i_3
       (.I0(rgb_completed_frames[19]),
        .I1(\released_frames_reg[31]_0 [19]),
        .I2(rgb_completed_frames[18]),
        .I3(\released_frames_reg[31]_0 [18]),
        .O(cpu_available2_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry__1_i_4
       (.I0(rgb_completed_frames[17]),
        .I1(\released_frames_reg[31]_0 [17]),
        .I2(rgb_completed_frames[16]),
        .I3(\released_frames_reg[31]_0 [16]),
        .O(cpu_available2_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry__1_i_5
       (.I0(\released_frames_reg[31]_0 [23]),
        .I1(rgb_completed_frames[23]),
        .I2(\released_frames_reg[31]_0 [22]),
        .I3(rgb_completed_frames[22]),
        .O(cpu_available2_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry__1_i_6
       (.I0(\released_frames_reg[31]_0 [21]),
        .I1(rgb_completed_frames[21]),
        .I2(\released_frames_reg[31]_0 [20]),
        .I3(rgb_completed_frames[20]),
        .O(cpu_available2_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry__1_i_7
       (.I0(\released_frames_reg[31]_0 [19]),
        .I1(rgb_completed_frames[19]),
        .I2(\released_frames_reg[31]_0 [18]),
        .I3(rgb_completed_frames[18]),
        .O(cpu_available2_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry__1_i_8
       (.I0(\released_frames_reg[31]_0 [17]),
        .I1(rgb_completed_frames[17]),
        .I2(\released_frames_reg[31]_0 [16]),
        .I3(rgb_completed_frames[16]),
        .O(cpu_available2_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available2_carry__2
       (.CI(cpu_available2_carry__1_n_0),
        .CO({cpu_available2,cpu_available2_carry__2_n_1,cpu_available2_carry__2_n_2,cpu_available2_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available2_carry__2_i_1_n_0,cpu_available2_carry__2_i_2_n_0,cpu_available2_carry__2_i_3_n_0,cpu_available2_carry__2_i_4_n_0}),
        .O(NLW_cpu_available2_carry__2_O_UNCONNECTED[3:0]),
        .S({cpu_available2_carry__2_i_5_n_0,cpu_available2_carry__2_i_6_n_0,cpu_available2_carry__2_i_7_n_0,cpu_available2_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry__2_i_1
       (.I0(rgb_completed_frames[31]),
        .I1(\released_frames_reg[31]_0 [31]),
        .I2(rgb_completed_frames[30]),
        .I3(\released_frames_reg[31]_0 [30]),
        .O(cpu_available2_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry__2_i_2
       (.I0(rgb_completed_frames[29]),
        .I1(\released_frames_reg[31]_0 [29]),
        .I2(rgb_completed_frames[28]),
        .I3(\released_frames_reg[31]_0 [28]),
        .O(cpu_available2_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry__2_i_3
       (.I0(rgb_completed_frames[27]),
        .I1(\released_frames_reg[31]_0 [27]),
        .I2(rgb_completed_frames[26]),
        .I3(\released_frames_reg[31]_0 [26]),
        .O(cpu_available2_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry__2_i_4
       (.I0(rgb_completed_frames[25]),
        .I1(\released_frames_reg[31]_0 [25]),
        .I2(rgb_completed_frames[24]),
        .I3(\released_frames_reg[31]_0 [24]),
        .O(cpu_available2_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry__2_i_5
       (.I0(\released_frames_reg[31]_0 [31]),
        .I1(rgb_completed_frames[31]),
        .I2(\released_frames_reg[31]_0 [30]),
        .I3(rgb_completed_frames[30]),
        .O(cpu_available2_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry__2_i_6
       (.I0(\released_frames_reg[31]_0 [29]),
        .I1(rgb_completed_frames[29]),
        .I2(\released_frames_reg[31]_0 [28]),
        .I3(rgb_completed_frames[28]),
        .O(cpu_available2_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry__2_i_7
       (.I0(\released_frames_reg[31]_0 [27]),
        .I1(rgb_completed_frames[27]),
        .I2(\released_frames_reg[31]_0 [26]),
        .I3(rgb_completed_frames[26]),
        .O(cpu_available2_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry__2_i_8
       (.I0(\released_frames_reg[31]_0 [25]),
        .I1(rgb_completed_frames[25]),
        .I2(\released_frames_reg[31]_0 [24]),
        .I3(rgb_completed_frames[24]),
        .O(cpu_available2_carry__2_i_8_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry_i_1
       (.I0(rgb_completed_frames[7]),
        .I1(\released_frames_reg[31]_0 [7]),
        .I2(rgb_completed_frames[6]),
        .I3(\released_frames_reg[31]_0 [6]),
        .O(cpu_available2_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry_i_2
       (.I0(rgb_completed_frames[5]),
        .I1(\released_frames_reg[31]_0 [5]),
        .I2(rgb_completed_frames[4]),
        .I3(\released_frames_reg[31]_0 [4]),
        .O(cpu_available2_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry_i_3
       (.I0(rgb_completed_frames[3]),
        .I1(\released_frames_reg[31]_0 [3]),
        .I2(rgb_completed_frames[2]),
        .I3(\released_frames_reg[31]_0 [2]),
        .O(cpu_available2_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    cpu_available2_carry_i_4
       (.I0(rgb_completed_frames[1]),
        .I1(\released_frames_reg[31]_0 [1]),
        .I2(rgb_completed_frames[0]),
        .I3(\released_frames_reg[31]_0 [0]),
        .O(cpu_available2_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry_i_5
       (.I0(\released_frames_reg[31]_0 [7]),
        .I1(rgb_completed_frames[7]),
        .I2(\released_frames_reg[31]_0 [6]),
        .I3(rgb_completed_frames[6]),
        .O(cpu_available2_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry_i_6
       (.I0(\released_frames_reg[31]_0 [5]),
        .I1(rgb_completed_frames[5]),
        .I2(\released_frames_reg[31]_0 [4]),
        .I3(rgb_completed_frames[4]),
        .O(cpu_available2_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry_i_7
       (.I0(\released_frames_reg[31]_0 [3]),
        .I1(rgb_completed_frames[3]),
        .I2(\released_frames_reg[31]_0 [2]),
        .I3(rgb_completed_frames[2]),
        .O(cpu_available2_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available2_carry_i_8
       (.I0(\released_frames_reg[31]_0 [1]),
        .I1(rgb_completed_frames[1]),
        .I2(\released_frames_reg[31]_0 [0]),
        .I3(rgb_completed_frames[0]),
        .O(cpu_available2_carry_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available3_carry
       (.CI(1'b0),
        .CO({cpu_available3_carry_n_0,cpu_available3_carry_n_1,cpu_available3_carry_n_2,cpu_available3_carry_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available3_carry_i_1_n_0,cpu_available3_carry_i_2_n_0,cpu_available3_carry_i_3_n_0,cpu_available3_carry_i_4_n_0}),
        .O(NLW_cpu_available3_carry_O_UNCONNECTED[3:0]),
        .S({cpu_available3_carry_i_5_n_0,cpu_available3_carry_i_6_n_0,cpu_available3_carry_i_7_n_0,cpu_available3_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available3_carry__0
       (.CI(cpu_available3_carry_n_0),
        .CO({cpu_available3_carry__0_n_0,cpu_available3_carry__0_n_1,cpu_available3_carry__0_n_2,cpu_available3_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available3_carry__0_i_1_n_0,cpu_available3_carry__0_i_2_n_0,cpu_available3_carry__0_i_3_n_0,cpu_available3_carry__0_i_4_n_0}),
        .O(NLW_cpu_available3_carry__0_O_UNCONNECTED[3:0]),
        .S({cpu_available3_carry__0_i_5_n_0,cpu_available3_carry__0_i_6_n_0,cpu_available3_carry__0_i_7_n_0,cpu_available3_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry__0_i_1
       (.I0(\released_frames_reg[31]_0 [15]),
        .I1(out[15]),
        .I2(out[14]),
        .I3(\released_frames_reg[31]_0 [14]),
        .O(cpu_available3_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry__0_i_2
       (.I0(\released_frames_reg[31]_0 [13]),
        .I1(out[13]),
        .I2(out[12]),
        .I3(\released_frames_reg[31]_0 [12]),
        .O(cpu_available3_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry__0_i_3
       (.I0(\released_frames_reg[31]_0 [11]),
        .I1(out[11]),
        .I2(out[10]),
        .I3(\released_frames_reg[31]_0 [10]),
        .O(cpu_available3_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry__0_i_4
       (.I0(\released_frames_reg[31]_0 [9]),
        .I1(out[9]),
        .I2(out[8]),
        .I3(\released_frames_reg[31]_0 [8]),
        .O(cpu_available3_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry__0_i_5
       (.I0(out[15]),
        .I1(\released_frames_reg[31]_0 [15]),
        .I2(out[14]),
        .I3(\released_frames_reg[31]_0 [14]),
        .O(cpu_available3_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry__0_i_6
       (.I0(out[13]),
        .I1(\released_frames_reg[31]_0 [13]),
        .I2(out[12]),
        .I3(\released_frames_reg[31]_0 [12]),
        .O(cpu_available3_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry__0_i_7
       (.I0(out[11]),
        .I1(\released_frames_reg[31]_0 [11]),
        .I2(out[10]),
        .I3(\released_frames_reg[31]_0 [10]),
        .O(cpu_available3_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry__0_i_8
       (.I0(out[9]),
        .I1(\released_frames_reg[31]_0 [9]),
        .I2(out[8]),
        .I3(\released_frames_reg[31]_0 [8]),
        .O(cpu_available3_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available3_carry__1
       (.CI(cpu_available3_carry__0_n_0),
        .CO({cpu_available3_carry__1_n_0,cpu_available3_carry__1_n_1,cpu_available3_carry__1_n_2,cpu_available3_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available3_carry__1_i_1_n_0,cpu_available3_carry__1_i_2_n_0,cpu_available3_carry__1_i_3_n_0,cpu_available3_carry__1_i_4_n_0}),
        .O(NLW_cpu_available3_carry__1_O_UNCONNECTED[3:0]),
        .S({cpu_available3_carry__1_i_5_n_0,cpu_available3_carry__1_i_6_n_0,cpu_available3_carry__1_i_7_n_0,cpu_available3_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry__1_i_1
       (.I0(\released_frames_reg[31]_0 [23]),
        .I1(out[23]),
        .I2(out[22]),
        .I3(\released_frames_reg[31]_0 [22]),
        .O(cpu_available3_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry__1_i_2
       (.I0(\released_frames_reg[31]_0 [21]),
        .I1(out[21]),
        .I2(out[20]),
        .I3(\released_frames_reg[31]_0 [20]),
        .O(cpu_available3_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry__1_i_3
       (.I0(\released_frames_reg[31]_0 [19]),
        .I1(out[19]),
        .I2(out[18]),
        .I3(\released_frames_reg[31]_0 [18]),
        .O(cpu_available3_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry__1_i_4
       (.I0(\released_frames_reg[31]_0 [17]),
        .I1(out[17]),
        .I2(out[16]),
        .I3(\released_frames_reg[31]_0 [16]),
        .O(cpu_available3_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry__1_i_5
       (.I0(out[23]),
        .I1(\released_frames_reg[31]_0 [23]),
        .I2(out[22]),
        .I3(\released_frames_reg[31]_0 [22]),
        .O(cpu_available3_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry__1_i_6
       (.I0(out[21]),
        .I1(\released_frames_reg[31]_0 [21]),
        .I2(out[20]),
        .I3(\released_frames_reg[31]_0 [20]),
        .O(cpu_available3_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry__1_i_7
       (.I0(out[19]),
        .I1(\released_frames_reg[31]_0 [19]),
        .I2(out[18]),
        .I3(\released_frames_reg[31]_0 [18]),
        .O(cpu_available3_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry__1_i_8
       (.I0(out[17]),
        .I1(\released_frames_reg[31]_0 [17]),
        .I2(out[16]),
        .I3(\released_frames_reg[31]_0 [16]),
        .O(cpu_available3_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 cpu_available3_carry__2
       (.CI(cpu_available3_carry__1_n_0),
        .CO({cpu_available3,cpu_available3_carry__2_n_1,cpu_available3_carry__2_n_2,cpu_available3_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({cpu_available3_carry__2_i_1_n_0,cpu_available3_carry__2_i_2_n_0,cpu_available3_carry__2_i_3_n_0,cpu_available3_carry__2_i_4_n_0}),
        .O(NLW_cpu_available3_carry__2_O_UNCONNECTED[3:0]),
        .S({cpu_available3_carry__2_i_5_n_0,cpu_available3_carry__2_i_6_n_0,cpu_available3_carry__2_i_7_n_0,cpu_available3_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h2B22)) 
    cpu_available3_carry__2_i_1
       (.I0(out[31]),
        .I1(\released_frames_reg[31]_0 [31]),
        .I2(\released_frames_reg[31]_0 [30]),
        .I3(out[30]),
        .O(cpu_available3_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry__2_i_2
       (.I0(\released_frames_reg[31]_0 [29]),
        .I1(out[29]),
        .I2(out[28]),
        .I3(\released_frames_reg[31]_0 [28]),
        .O(cpu_available3_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry__2_i_3
       (.I0(\released_frames_reg[31]_0 [27]),
        .I1(out[27]),
        .I2(out[26]),
        .I3(\released_frames_reg[31]_0 [26]),
        .O(cpu_available3_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry__2_i_4
       (.I0(\released_frames_reg[31]_0 [25]),
        .I1(out[25]),
        .I2(out[24]),
        .I3(\released_frames_reg[31]_0 [24]),
        .O(cpu_available3_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry__2_i_5
       (.I0(\released_frames_reg[31]_0 [31]),
        .I1(out[31]),
        .I2(out[30]),
        .I3(\released_frames_reg[31]_0 [30]),
        .O(cpu_available3_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry__2_i_6
       (.I0(out[29]),
        .I1(\released_frames_reg[31]_0 [29]),
        .I2(out[28]),
        .I3(\released_frames_reg[31]_0 [28]),
        .O(cpu_available3_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry__2_i_7
       (.I0(out[27]),
        .I1(\released_frames_reg[31]_0 [27]),
        .I2(out[26]),
        .I3(\released_frames_reg[31]_0 [26]),
        .O(cpu_available3_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry__2_i_8
       (.I0(out[25]),
        .I1(\released_frames_reg[31]_0 [25]),
        .I2(out[24]),
        .I3(\released_frames_reg[31]_0 [24]),
        .O(cpu_available3_carry__2_i_8_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry_i_1
       (.I0(\released_frames_reg[31]_0 [7]),
        .I1(out[7]),
        .I2(out[6]),
        .I3(\released_frames_reg[31]_0 [6]),
        .O(cpu_available3_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry_i_2
       (.I0(\released_frames_reg[31]_0 [5]),
        .I1(out[5]),
        .I2(out[4]),
        .I3(\released_frames_reg[31]_0 [4]),
        .O(cpu_available3_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry_i_3
       (.I0(\released_frames_reg[31]_0 [3]),
        .I1(out[3]),
        .I2(out[2]),
        .I3(\released_frames_reg[31]_0 [2]),
        .O(cpu_available3_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    cpu_available3_carry_i_4
       (.I0(\released_frames_reg[31]_0 [1]),
        .I1(out[1]),
        .I2(out[0]),
        .I3(\released_frames_reg[31]_0 [0]),
        .O(cpu_available3_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry_i_5
       (.I0(out[7]),
        .I1(\released_frames_reg[31]_0 [7]),
        .I2(out[6]),
        .I3(\released_frames_reg[31]_0 [6]),
        .O(cpu_available3_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry_i_6
       (.I0(out[5]),
        .I1(\released_frames_reg[31]_0 [5]),
        .I2(out[4]),
        .I3(\released_frames_reg[31]_0 [4]),
        .O(cpu_available3_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry_i_7
       (.I0(out[3]),
        .I1(\released_frames_reg[31]_0 [3]),
        .I2(out[2]),
        .I3(\released_frames_reg[31]_0 [2]),
        .O(cpu_available3_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    cpu_available3_carry_i_8
       (.I0(out[1]),
        .I1(\released_frames_reg[31]_0 [1]),
        .I2(out[0]),
        .I3(\released_frames_reg[31]_0 [0]),
        .O(cpu_available3_carry_i_8_n_0));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'h00000080)) 
    cpu_available_INST_0
       (.I0(common_aresetn),
        .I1(\epoch_reg[31]_0 ),
        .I2(control_capture_aresetn),
        .I3(cpu_available_INST_0_i_1_n_0),
        .I4(cpu_available_INST_0_i_2_n_0),
        .O(cpu_available));
  LUT6 #(
    .INIT(64'hFEFFFFFFFFFFFFFF)) 
    cpu_available_INST_0_i_1
       (.I0(upstream_fault0),
        .I1(owner_fault_INST_0_i_4_n_0),
        .I2(owner_fault_INST_0_i_3_n_0),
        .I3(owner_fault_INST_0_i_2_n_0),
        .I4(owner_fault_INST_0_i_1_n_0),
        .I5(configuration_locked),
        .O(cpu_available_INST_0_i_1_n_0));
  LUT5 #(
    .INIT(32'hFF7FFFFF)) 
    cpu_available_INST_0_i_2
       (.I0(cpu_available0),
        .I1(cpu_available1),
        .I2(cpu_available3),
        .I3(cpu_held_reg_0),
        .I4(cpu_available2),
        .O(cpu_available_INST_0_i_2_n_0));
  LUT6 #(
    .INIT(64'hFFFFF2F2000000D0)) 
    cpu_held_i_1
       (.I0(cpu_held_i_2_n_0),
        .I1(cpu_held_i_3_n_0),
        .I2(cpu_claim),
        .I3(cpu_release),
        .I4(cpu_available_INST_0_i_1_n_0),
        .I5(cpu_held_reg_0),
        .O(cpu_held_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    cpu_held_i_2
       (.I0(cpu_release),
        .I1(token_matches00_out),
        .I2(token_matches0),
        .I3(cpu_held_reg_0),
        .I4(cpu_claim),
        .O(cpu_held_i_2_n_0));
  LUT6 #(
    .INIT(64'h0100000000000000)) 
    cpu_held_i_3
       (.I0(cpu_available_INST_0_i_2_n_0),
        .I1(cpu_available_INST_0_i_1_n_0),
        .I2(claim_accepted_reg_0),
        .I3(cpu_claim),
        .I4(token_matches00_out),
        .I5(token_matches0),
        .O(cpu_held_i_3_n_0));
  FDRE cpu_held_reg
       (.C(aclk),
        .CE(1'b1),
        .D(cpu_held_i_1_n_0),
        .Q(cpu_held_reg_0),
        .R(clear));
  LUT4 #(
    .INIT(16'h0040)) 
    \epoch[31]_i_1 
       (.I0(configuration_locked),
        .I1(control_capture_aresetn),
        .I2(\epoch_reg[31]_0 ),
        .I3(configuration_locked1),
        .O(configuration_locked17_out));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_10 
       (.I0(packet_completed_frames[7]),
        .I1(rgb_completed_frames[22]),
        .I2(packet_completed_frames[5]),
        .I3(rgb_completed_frames[17]),
        .O(\epoch[31]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \epoch[31]_i_11 
       (.I0(rgb_completed_frames[24]),
        .I1(rgb_completed_frames[27]),
        .I2(rgb_completed_frames[15]),
        .I3(rgb_completed_frames[28]),
        .I4(\epoch[31]_i_23_n_0 ),
        .O(\epoch[31]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_12 
       (.I0(status_completed_frames[29]),
        .I1(rgb_completed_frames[3]),
        .I2(status_completed_frames[3]),
        .I3(packet_completed_frames[18]),
        .O(\epoch[31]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_13 
       (.I0(status_completed_frames[5]),
        .I1(packet_completed_frames[25]),
        .I2(status_completed_frames[10]),
        .I3(status_completed_frames[7]),
        .O(\epoch[31]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \epoch[31]_i_14 
       (.I0(\epoch[31]_i_24_n_0 ),
        .I1(cfg_frame_context[2]),
        .I2(cfg_frame_context[1]),
        .I3(cfg_frame_context[3]),
        .I4(cfg_frame_context[0]),
        .I5(\epoch[31]_i_25_n_0 ),
        .O(\epoch[31]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \epoch[31]_i_15 
       (.I0(\epoch[31]_i_26_n_0 ),
        .I1(cfg_frame_context[18]),
        .I2(cfg_frame_context[17]),
        .I3(cfg_frame_context[19]),
        .I4(cfg_frame_context[16]),
        .I5(\epoch[31]_i_27_n_0 ),
        .O(\epoch[31]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \epoch[31]_i_16 
       (.I0(\epoch[31]_i_28_n_0 ),
        .I1(cfg_frame_context[42]),
        .I2(cfg_frame_context[41]),
        .I3(cfg_frame_context[43]),
        .I4(cfg_frame_context[40]),
        .I5(\epoch[31]_i_29_n_0 ),
        .O(\epoch[31]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \epoch[31]_i_17 
       (.I0(\epoch[31]_i_30_n_0 ),
        .I1(cfg_frame_context[50]),
        .I2(cfg_frame_context[49]),
        .I3(cfg_frame_context[51]),
        .I4(cfg_frame_context[48]),
        .I5(\epoch[31]_i_31_n_0 ),
        .O(\epoch[31]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \epoch[31]_i_18 
       (.I0(\epoch[31]_i_32_n_0 ),
        .I1(status_completed_frames[6]),
        .I2(rgb_completed_frames[5]),
        .I3(rgb_completed_frames[25]),
        .I4(rgb_completed_frames[7]),
        .I5(\epoch[31]_i_33_n_0 ),
        .O(\epoch[31]_i_18_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \epoch[31]_i_19 
       (.I0(cpu_release),
        .I1(cpu_claim),
        .I2(rgb_completed_frames[2]),
        .I3(rgb_completed_frames[12]),
        .I4(rgb_completed_frames[11]),
        .I5(packet_completed_frames[12]),
        .O(\epoch[31]_i_19_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \epoch[31]_i_2 
       (.I0(\epoch[31]_i_3_n_0 ),
        .I1(\epoch[31]_i_4_n_0 ),
        .I2(\epoch[31]_i_5_n_0 ),
        .I3(\epoch[31]_i_6_n_0 ),
        .I4(\epoch[31]_i_7_n_0 ),
        .O(configuration_locked1));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \epoch[31]_i_20 
       (.I0(\epoch[31]_i_34_n_0 ),
        .I1(status_completed_frames[23]),
        .I2(status_completed_frames[9]),
        .I3(status_completed_frames[8]),
        .I4(status_completed_frames[4]),
        .I5(\epoch[31]_i_35_n_0 ),
        .O(\epoch[31]_i_20_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \epoch[31]_i_21 
       (.I0(\epoch[31]_i_36_n_0 ),
        .I1(status_completed_frames[21]),
        .I2(rgb_completed_frames[0]),
        .I3(status_completed_frames[11]),
        .I4(packet_completed_frames[23]),
        .I5(\epoch[31]_i_37_n_0 ),
        .O(\epoch[31]_i_21_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_22 
       (.I0(status_completed_frames[15]),
        .I1(rgb_completed_frames[26]),
        .I2(status_completed_frames[17]),
        .I3(rgb_completed_frames[18]),
        .O(\epoch[31]_i_22_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_23 
       (.I0(packet_completed_frames[29]),
        .I1(rgb_completed_frames[14]),
        .I2(packet_completed_frames[17]),
        .I3(packet_completed_frames[0]),
        .O(\epoch[31]_i_23_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_24 
       (.I0(cfg_frame_context[5]),
        .I1(cfg_frame_context[4]),
        .I2(cfg_frame_context[7]),
        .I3(cfg_frame_context[6]),
        .O(\epoch[31]_i_24_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \epoch[31]_i_25 
       (.I0(cfg_frame_context[10]),
        .I1(cfg_frame_context[11]),
        .I2(cfg_frame_context[8]),
        .I3(cfg_frame_context[9]),
        .I4(\epoch[31]_i_38_n_0 ),
        .O(\epoch[31]_i_25_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_26 
       (.I0(cfg_frame_context[21]),
        .I1(cfg_frame_context[20]),
        .I2(cfg_frame_context[23]),
        .I3(cfg_frame_context[22]),
        .O(\epoch[31]_i_26_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \epoch[31]_i_27 
       (.I0(cfg_frame_context[24]),
        .I1(cfg_frame_context[25]),
        .I2(cfg_frame_context[26]),
        .I3(cfg_frame_context[27]),
        .I4(\epoch[31]_i_39_n_0 ),
        .O(\epoch[31]_i_27_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_28 
       (.I0(cfg_frame_context[45]),
        .I1(cfg_frame_context[44]),
        .I2(cfg_frame_context[47]),
        .I3(cfg_frame_context[46]),
        .O(\epoch[31]_i_28_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \epoch[31]_i_29 
       (.I0(cfg_frame_context[32]),
        .I1(cfg_frame_context[35]),
        .I2(cfg_frame_context[33]),
        .I3(cfg_frame_context[34]),
        .I4(\epoch[31]_i_40_n_0 ),
        .O(\epoch[31]_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \epoch[31]_i_3 
       (.I0(\epoch[31]_i_8_n_0 ),
        .I1(packet_completed_frames[8]),
        .I2(rgb_completed_frames[8]),
        .I3(packet_completed_frames[30]),
        .I4(rgb_completed_frames[16]),
        .I5(\epoch[31]_i_9_n_0 ),
        .O(\epoch[31]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_30 
       (.I0(cfg_frame_context[53]),
        .I1(cfg_frame_context[52]),
        .I2(cfg_frame_context[55]),
        .I3(cfg_frame_context[54]),
        .O(\epoch[31]_i_30_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \epoch[31]_i_31 
       (.I0(cfg_frame_context[56]),
        .I1(cfg_frame_context[59]),
        .I2(cfg_frame_context[57]),
        .I3(cfg_frame_context[58]),
        .I4(\epoch[31]_i_41_n_0 ),
        .O(\epoch[31]_i_31_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_32 
       (.I0(packet_completed_frames[11]),
        .I1(rgb_completed_frames[9]),
        .I2(packet_completed_frames[13]),
        .I3(packet_completed_frames[10]),
        .O(\epoch[31]_i_32_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \epoch[31]_i_33 
       (.I0(rgb_completed_frames[1]),
        .I1(rgb_completed_frames[31]),
        .I2(packet_completed_frames[2]),
        .I3(status_completed_frames[16]),
        .I4(\epoch[31]_i_42_n_0 ),
        .O(\epoch[31]_i_33_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_34 
       (.I0(status_completed_frames[24]),
        .I1(packet_completed_frames[1]),
        .I2(status_completed_frames[26]),
        .I3(status_completed_frames[22]),
        .O(\epoch[31]_i_34_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \epoch[31]_i_35 
       (.I0(packet_completed_frames[27]),
        .I1(status_completed_frames[30]),
        .I2(packet_completed_frames[15]),
        .I3(packet_completed_frames[19]),
        .I4(\epoch[31]_i_43_n_0 ),
        .O(\epoch[31]_i_35_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_36 
       (.I0(packet_completed_frames[26]),
        .I1(packet_completed_frames[24]),
        .I2(status_completed_frames[12]),
        .I3(status_completed_frames[0]),
        .O(\epoch[31]_i_36_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \epoch[31]_i_37 
       (.I0(rgb_completed_frames[10]),
        .I1(rgb_completed_frames[20]),
        .I2(rgb_completed_frames[30]),
        .I3(packet_completed_frames[22]),
        .I4(\epoch[31]_i_44_n_0 ),
        .O(\epoch[31]_i_37_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_38 
       (.I0(cfg_frame_context[13]),
        .I1(cfg_frame_context[12]),
        .I2(cfg_frame_context[15]),
        .I3(cfg_frame_context[14]),
        .O(\epoch[31]_i_38_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_39 
       (.I0(cfg_frame_context[29]),
        .I1(cfg_frame_context[28]),
        .I2(cfg_frame_context[31]),
        .I3(cfg_frame_context[30]),
        .O(\epoch[31]_i_39_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \epoch[31]_i_4 
       (.I0(\epoch[31]_i_10_n_0 ),
        .I1(packet_completed_frames[6]),
        .I2(rgb_completed_frames[23]),
        .I3(status_completed_frames[18]),
        .I4(rgb_completed_frames[29]),
        .I5(\epoch[31]_i_11_n_0 ),
        .O(\epoch[31]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_40 
       (.I0(cfg_frame_context[37]),
        .I1(cfg_frame_context[36]),
        .I2(cfg_frame_context[39]),
        .I3(cfg_frame_context[38]),
        .O(\epoch[31]_i_40_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_41 
       (.I0(cfg_frame_context[61]),
        .I1(cfg_frame_context[60]),
        .I2(cfg_frame_context[63]),
        .I3(cfg_frame_context[62]),
        .O(\epoch[31]_i_41_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_42 
       (.I0(status_completed_frames[20]),
        .I1(status_completed_frames[19]),
        .I2(packet_completed_frames[4]),
        .I3(packet_completed_frames[3]),
        .O(\epoch[31]_i_42_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_43 
       (.I0(status_completed_frames[25]),
        .I1(packet_completed_frames[31]),
        .I2(status_completed_frames[2]),
        .I3(packet_completed_frames[28]),
        .O(\epoch[31]_i_43_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_44 
       (.I0(status_completed_frames[31]),
        .I1(status_completed_frames[27]),
        .I2(rgb_completed_frames[6]),
        .I3(rgb_completed_frames[4]),
        .O(\epoch[31]_i_44_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \epoch[31]_i_5 
       (.I0(packet_completed_frames[21]),
        .I1(status_completed_frames[28]),
        .I2(packet_completed_frames[14]),
        .I3(status_completed_frames[14]),
        .I4(\epoch[31]_i_12_n_0 ),
        .I5(\epoch[31]_i_13_n_0 ),
        .O(\epoch[31]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h4F44)) 
    \epoch[31]_i_6 
       (.I0(\epoch[31]_i_14_n_0 ),
        .I1(\epoch[31]_i_15_n_0 ),
        .I2(\epoch[31]_i_16_n_0 ),
        .I3(\epoch[31]_i_17_n_0 ),
        .O(\epoch[31]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_7 
       (.I0(\epoch[31]_i_18_n_0 ),
        .I1(\epoch[31]_i_19_n_0 ),
        .I2(\epoch[31]_i_20_n_0 ),
        .I3(\epoch[31]_i_21_n_0 ),
        .O(\epoch[31]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \epoch[31]_i_8 
       (.I0(rgb_completed_frames[21]),
        .I1(rgb_completed_frames[19]),
        .I2(status_completed_frames[13]),
        .I3(packet_completed_frames[9]),
        .O(\epoch[31]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \epoch[31]_i_9 
       (.I0(rgb_completed_frames[13]),
        .I1(packet_completed_frames[20]),
        .I2(packet_completed_frames[16]),
        .I3(status_completed_frames[1]),
        .I4(\epoch[31]_i_22_n_0 ),
        .O(\epoch[31]_i_9_n_0 ));
  FDRE \epoch_reg[0] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[32]),
        .Q(available_epoch[0]),
        .R(clear));
  FDRE \epoch_reg[10] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[42]),
        .Q(available_epoch[10]),
        .R(clear));
  FDRE \epoch_reg[11] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[43]),
        .Q(available_epoch[11]),
        .R(clear));
  FDRE \epoch_reg[12] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[44]),
        .Q(available_epoch[12]),
        .R(clear));
  FDRE \epoch_reg[13] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[45]),
        .Q(available_epoch[13]),
        .R(clear));
  FDRE \epoch_reg[14] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[46]),
        .Q(available_epoch[14]),
        .R(clear));
  FDRE \epoch_reg[15] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[47]),
        .Q(available_epoch[15]),
        .R(clear));
  FDRE \epoch_reg[16] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[48]),
        .Q(available_epoch[16]),
        .R(clear));
  FDRE \epoch_reg[17] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[49]),
        .Q(available_epoch[17]),
        .R(clear));
  FDRE \epoch_reg[18] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[50]),
        .Q(available_epoch[18]),
        .R(clear));
  FDRE \epoch_reg[19] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[51]),
        .Q(available_epoch[19]),
        .R(clear));
  FDRE \epoch_reg[1] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[33]),
        .Q(available_epoch[1]),
        .R(clear));
  FDRE \epoch_reg[20] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[52]),
        .Q(available_epoch[20]),
        .R(clear));
  FDRE \epoch_reg[21] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[53]),
        .Q(available_epoch[21]),
        .R(clear));
  FDRE \epoch_reg[22] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[54]),
        .Q(available_epoch[22]),
        .R(clear));
  FDRE \epoch_reg[23] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[55]),
        .Q(available_epoch[23]),
        .R(clear));
  FDRE \epoch_reg[24] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[56]),
        .Q(available_epoch[24]),
        .R(clear));
  FDRE \epoch_reg[25] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[57]),
        .Q(available_epoch[25]),
        .R(clear));
  FDRE \epoch_reg[26] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[58]),
        .Q(available_epoch[26]),
        .R(clear));
  FDRE \epoch_reg[27] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[59]),
        .Q(available_epoch[27]),
        .R(clear));
  FDRE \epoch_reg[28] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[60]),
        .Q(available_epoch[28]),
        .R(clear));
  FDRE \epoch_reg[29] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[61]),
        .Q(available_epoch[29]),
        .R(clear));
  FDRE \epoch_reg[2] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[34]),
        .Q(available_epoch[2]),
        .R(clear));
  FDRE \epoch_reg[30] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[62]),
        .Q(available_epoch[30]),
        .R(clear));
  FDRE \epoch_reg[31] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[63]),
        .Q(available_epoch[31]),
        .R(clear));
  FDRE \epoch_reg[3] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[35]),
        .Q(available_epoch[3]),
        .R(clear));
  FDRE \epoch_reg[4] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[36]),
        .Q(available_epoch[4]),
        .R(clear));
  FDRE \epoch_reg[5] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[37]),
        .Q(available_epoch[5]),
        .R(clear));
  FDRE \epoch_reg[6] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[38]),
        .Q(available_epoch[6]),
        .R(clear));
  FDRE \epoch_reg[7] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[39]),
        .Q(available_epoch[7]),
        .R(clear));
  FDRE \epoch_reg[8] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[40]),
        .Q(available_epoch[8]),
        .R(clear));
  FDRE \epoch_reg[9] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[41]),
        .Q(available_epoch[9]),
        .R(clear));
  LUT6 #(
    .INIT(64'h0001000000000000)) 
    epoch_sealed_INST_0_i_2
       (.I0(owner_drained_INST_0_i_2_n_0),
        .I1(owner_drained_INST_0_i_1_n_0),
        .I2(cpu_release),
        .I3(cpu_available_INST_0_i_1_n_0),
        .I4(pipeline_drained),
        .I5(dma_drained),
        .O(cpu_release_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF00F1)) 
    \fault_causes[1]_i_1 
       (.I0(cpu_held_i_3_n_0),
        .I1(\fault_causes[1]_i_2_n_0 ),
        .I2(\fault_causes[1]_i_3_n_0 ),
        .I3(cpu_available_INST_0_i_1_n_0),
        .I4(\fault_causes[1]_i_4_n_0 ),
        .I5(owner_fault_causes[1]),
        .O(\fault_causes[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'h0000D555)) 
    \fault_causes[1]_i_2 
       (.I0(cpu_release),
        .I1(token_matches00_out),
        .I2(token_matches0),
        .I3(cpu_held_reg_0),
        .I4(cpu_claim),
        .O(\fault_causes[1]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \fault_causes[1]_i_3 
       (.I0(cpu_claim),
        .I1(cpu_release),
        .O(\fault_causes[1]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT5 #(
    .INIT(32'h000E0E0E)) 
    \fault_causes[1]_i_4 
       (.I0(cpu_claim),
        .I1(cpu_release),
        .I2(configuration_locked),
        .I3(\epoch_reg[31]_0 ),
        .I4(control_capture_aresetn),
        .O(\fault_causes[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFD500FF00)) 
    \fault_causes[2]_i_1 
       (.I0(owner_fault_INST_0_i_1_n_0),
        .I1(frame_credit_request),
        .I2(p_0_in28_in),
        .I3(configuration_locked),
        .I4(owner_fault_INST_0_i_2_n_0),
        .I5(owner_fault_causes[2]),
        .O(\fault_causes[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFF38888)) 
    \fault_causes[3]_i_1 
       (.I0(configuration_locked1),
        .I1(capture_aresetn),
        .I2(configuration_bad1),
        .I3(configuration_bad2_carry__1_n_1),
        .I4(configuration_locked),
        .I5(owner_fault_causes[3]),
        .O(\fault_causes[3]_i_1_n_0 ));
  FDRE \fault_causes_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .D(\fault_causes_reg[0]_0 ),
        .Q(owner_fault_causes[0]),
        .R(clear));
  FDRE \fault_causes_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .D(\fault_causes[1]_i_1_n_0 ),
        .Q(owner_fault_causes[1]),
        .R(clear));
  FDRE \fault_causes_reg[2] 
       (.C(aclk),
        .CE(1'b1),
        .D(\fault_causes[2]_i_1_n_0 ),
        .Q(owner_fault_causes[2]),
        .R(clear));
  FDRE \fault_causes_reg[3] 
       (.C(aclk),
        .CE(1'b1),
        .D(\fault_causes[3]_i_1_n_0 ),
        .Q(owner_fault_causes[3]),
        .R(clear));
  FDRE \final_frame_count_reg[0] 
       (.C(aclk),
        .CE(E),
        .D(D[0]),
        .Q(Q[0]),
        .R(clear));
  FDRE \final_frame_count_reg[10] 
       (.C(aclk),
        .CE(E),
        .D(D[10]),
        .Q(\final_frame_count_reg_n_0_[10] ),
        .R(clear));
  FDRE \final_frame_count_reg[11] 
       (.C(aclk),
        .CE(E),
        .D(D[11]),
        .Q(\final_frame_count_reg_n_0_[11] ),
        .R(clear));
  FDRE \final_frame_count_reg[12] 
       (.C(aclk),
        .CE(E),
        .D(D[12]),
        .Q(Q[6]),
        .R(clear));
  FDRE \final_frame_count_reg[13] 
       (.C(aclk),
        .CE(E),
        .D(D[13]),
        .Q(Q[7]),
        .R(clear));
  FDRE \final_frame_count_reg[14] 
       (.C(aclk),
        .CE(E),
        .D(D[14]),
        .Q(Q[8]),
        .R(clear));
  FDRE \final_frame_count_reg[15] 
       (.C(aclk),
        .CE(E),
        .D(D[15]),
        .Q(Q[9]),
        .R(clear));
  FDRE \final_frame_count_reg[16] 
       (.C(aclk),
        .CE(E),
        .D(D[16]),
        .Q(Q[10]),
        .R(clear));
  FDRE \final_frame_count_reg[17] 
       (.C(aclk),
        .CE(E),
        .D(D[17]),
        .Q(Q[11]),
        .R(clear));
  FDRE \final_frame_count_reg[18] 
       (.C(aclk),
        .CE(E),
        .D(D[18]),
        .Q(\final_frame_count_reg_n_0_[18] ),
        .R(clear));
  FDRE \final_frame_count_reg[19] 
       (.C(aclk),
        .CE(E),
        .D(D[19]),
        .Q(\final_frame_count_reg_n_0_[19] ),
        .R(clear));
  FDRE \final_frame_count_reg[1] 
       (.C(aclk),
        .CE(E),
        .D(D[1]),
        .Q(Q[1]),
        .R(clear));
  FDRE \final_frame_count_reg[20] 
       (.C(aclk),
        .CE(E),
        .D(D[20]),
        .Q(\final_frame_count_reg_n_0_[20] ),
        .R(clear));
  FDRE \final_frame_count_reg[21] 
       (.C(aclk),
        .CE(E),
        .D(D[21]),
        .Q(Q[12]),
        .R(clear));
  FDRE \final_frame_count_reg[22] 
       (.C(aclk),
        .CE(E),
        .D(D[22]),
        .Q(Q[13]),
        .R(clear));
  FDRE \final_frame_count_reg[23] 
       (.C(aclk),
        .CE(E),
        .D(D[23]),
        .Q(Q[14]),
        .R(clear));
  FDRE \final_frame_count_reg[24] 
       (.C(aclk),
        .CE(E),
        .D(D[24]),
        .Q(\final_frame_count_reg_n_0_[24] ),
        .R(clear));
  FDRE \final_frame_count_reg[25] 
       (.C(aclk),
        .CE(E),
        .D(D[25]),
        .Q(\final_frame_count_reg_n_0_[25] ),
        .R(clear));
  FDRE \final_frame_count_reg[26] 
       (.C(aclk),
        .CE(E),
        .D(D[26]),
        .Q(\final_frame_count_reg_n_0_[26] ),
        .R(clear));
  FDRE \final_frame_count_reg[27] 
       (.C(aclk),
        .CE(E),
        .D(D[27]),
        .Q(\final_frame_count_reg_n_0_[27] ),
        .R(clear));
  FDRE \final_frame_count_reg[28] 
       (.C(aclk),
        .CE(E),
        .D(D[28]),
        .Q(\final_frame_count_reg_n_0_[28] ),
        .R(clear));
  FDRE \final_frame_count_reg[29] 
       (.C(aclk),
        .CE(E),
        .D(D[29]),
        .Q(\final_frame_count_reg_n_0_[29] ),
        .R(clear));
  FDRE \final_frame_count_reg[2] 
       (.C(aclk),
        .CE(E),
        .D(D[2]),
        .Q(Q[2]),
        .R(clear));
  FDRE \final_frame_count_reg[30] 
       (.C(aclk),
        .CE(E),
        .D(D[30]),
        .Q(\final_frame_count_reg_n_0_[30] ),
        .R(clear));
  FDRE \final_frame_count_reg[31] 
       (.C(aclk),
        .CE(E),
        .D(D[31]),
        .Q(\final_frame_count_reg_n_0_[31] ),
        .R(clear));
  FDRE \final_frame_count_reg[3] 
       (.C(aclk),
        .CE(E),
        .D(D[3]),
        .Q(\final_frame_count_reg_n_0_[3] ),
        .R(clear));
  FDRE \final_frame_count_reg[4] 
       (.C(aclk),
        .CE(E),
        .D(D[4]),
        .Q(\final_frame_count_reg_n_0_[4] ),
        .R(clear));
  FDRE \final_frame_count_reg[5] 
       (.C(aclk),
        .CE(E),
        .D(D[5]),
        .Q(\final_frame_count_reg_n_0_[5] ),
        .R(clear));
  FDRE \final_frame_count_reg[6] 
       (.C(aclk),
        .CE(E),
        .D(D[6]),
        .Q(Q[3]),
        .R(clear));
  FDRE \final_frame_count_reg[7] 
       (.C(aclk),
        .CE(E),
        .D(D[7]),
        .Q(Q[4]),
        .R(clear));
  FDRE \final_frame_count_reg[8] 
       (.C(aclk),
        .CE(E),
        .D(D[8]),
        .Q(Q[5]),
        .R(clear));
  FDRE \final_frame_count_reg[9] 
       (.C(aclk),
        .CE(E),
        .D(D[9]),
        .Q(\final_frame_count_reg_n_0_[9] ),
        .R(clear));
  FDRE \first_frame_id_reg[0] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[0]),
        .Q(first_frame_id[0]),
        .R(clear));
  FDRE \first_frame_id_reg[10] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[10]),
        .Q(first_frame_id[10]),
        .R(clear));
  FDRE \first_frame_id_reg[11] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[11]),
        .Q(first_frame_id[11]),
        .R(clear));
  FDRE \first_frame_id_reg[12] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[12]),
        .Q(first_frame_id[12]),
        .R(clear));
  FDRE \first_frame_id_reg[13] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[13]),
        .Q(first_frame_id[13]),
        .R(clear));
  FDRE \first_frame_id_reg[14] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[14]),
        .Q(first_frame_id[14]),
        .R(clear));
  FDRE \first_frame_id_reg[15] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[15]),
        .Q(first_frame_id[15]),
        .R(clear));
  FDRE \first_frame_id_reg[16] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[16]),
        .Q(first_frame_id[16]),
        .R(clear));
  FDRE \first_frame_id_reg[17] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[17]),
        .Q(first_frame_id[17]),
        .R(clear));
  FDRE \first_frame_id_reg[18] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[18]),
        .Q(first_frame_id[18]),
        .R(clear));
  FDRE \first_frame_id_reg[19] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[19]),
        .Q(first_frame_id[19]),
        .R(clear));
  FDRE \first_frame_id_reg[1] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[1]),
        .Q(first_frame_id[1]),
        .R(clear));
  FDRE \first_frame_id_reg[20] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[20]),
        .Q(first_frame_id[20]),
        .R(clear));
  FDRE \first_frame_id_reg[21] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[21]),
        .Q(first_frame_id[21]),
        .R(clear));
  FDRE \first_frame_id_reg[22] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[22]),
        .Q(first_frame_id[22]),
        .R(clear));
  FDRE \first_frame_id_reg[23] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[23]),
        .Q(first_frame_id[23]),
        .R(clear));
  FDRE \first_frame_id_reg[24] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[24]),
        .Q(first_frame_id[24]),
        .R(clear));
  FDRE \first_frame_id_reg[25] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[25]),
        .Q(first_frame_id[25]),
        .R(clear));
  FDRE \first_frame_id_reg[26] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[26]),
        .Q(first_frame_id[26]),
        .R(clear));
  FDRE \first_frame_id_reg[27] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[27]),
        .Q(first_frame_id[27]),
        .R(clear));
  FDRE \first_frame_id_reg[28] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[28]),
        .Q(first_frame_id[28]),
        .R(clear));
  FDRE \first_frame_id_reg[29] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[29]),
        .Q(first_frame_id[29]),
        .R(clear));
  FDRE \first_frame_id_reg[2] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[2]),
        .Q(first_frame_id[2]),
        .R(clear));
  FDRE \first_frame_id_reg[30] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[30]),
        .Q(first_frame_id[30]),
        .R(clear));
  FDRE \first_frame_id_reg[31] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[31]),
        .Q(first_frame_id[31]),
        .R(clear));
  FDRE \first_frame_id_reg[3] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[3]),
        .Q(first_frame_id[3]),
        .R(clear));
  FDRE \first_frame_id_reg[4] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[4]),
        .Q(first_frame_id[4]),
        .R(clear));
  FDRE \first_frame_id_reg[5] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[5]),
        .Q(first_frame_id[5]),
        .R(clear));
  FDRE \first_frame_id_reg[6] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[6]),
        .Q(first_frame_id[6]),
        .R(clear));
  FDRE \first_frame_id_reg[7] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[7]),
        .Q(first_frame_id[7]),
        .R(clear));
  FDRE \first_frame_id_reg[8] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[8]),
        .Q(first_frame_id[8]),
        .R(clear));
  FDRE \first_frame_id_reg[9] 
       (.C(aclk),
        .CE(configuration_locked17_out),
        .D(cfg_frame_context[9]),
        .Q(first_frame_id[9]),
        .R(clear));
  LUT5 #(
    .INIT(32'h00000002)) 
    frame_credit_ready_INST_0
       (.I0(frame_credit_ready_INST_0_i_1_n_0),
        .I1(frame_credit_ready_INST_0_i_2_n_0),
        .I2(\granted_frames_reg[31]_0 ),
        .I3(frame_credit_ready_INST_0_i_4_n_0),
        .I4(frame_credit_ready_INST_0_i_5_n_0),
        .O(frame_credit_ready));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'h4000)) 
    frame_credit_ready_INST_0_i_1
       (.I0(cpu_available_INST_0_i_1_n_0),
        .I1(control_capture_aresetn),
        .I2(\epoch_reg[31]_0 ),
        .I3(common_aresetn),
        .O(frame_credit_ready_INST_0_i_1_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    frame_credit_ready_INST_0_i_10
       (.I0(grant_ready40_out[21]),
        .I1(grant_ready40_out[22]),
        .I2(grant_ready40_out[16]),
        .I3(grant_ready40_out[31]),
        .O(frame_credit_ready_INST_0_i_10_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    frame_credit_ready_INST_0_i_11
       (.I0(grant_ready40_out[8]),
        .I1(grant_ready40_out[17]),
        .I2(grant_ready40_out[25]),
        .I3(grant_ready40_out[27]),
        .O(frame_credit_ready_INST_0_i_11_n_0));
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    frame_credit_ready_INST_0_i_12
       (.I0(out[10]),
        .I1(out[11]),
        .I2(out[8]),
        .I3(out[9]),
        .I4(frame_credit_ready_INST_0_i_16_n_0),
        .O(frame_credit_ready_INST_0_i_12_n_0));
  LUT5 #(
    .INIT(32'h00008000)) 
    frame_credit_ready_INST_0_i_13
       (.I0(out[0]),
        .I1(out[3]),
        .I2(out[1]),
        .I3(out[2]),
        .I4(frame_credit_ready_INST_0_i_17_n_0),
        .O(frame_credit_ready_INST_0_i_13_n_0));
  LUT6 #(
    .INIT(64'hEFFFFFFFFFFFFFFF)) 
    frame_credit_ready_INST_0_i_14
       (.I0(frame_credit_ready_INST_0_i_18_n_0),
        .I1(frame_credit_ready_INST_0_i_19_n_0),
        .I2(out[25]),
        .I3(out[24]),
        .I4(out[27]),
        .I5(out[26]),
        .O(frame_credit_ready_INST_0_i_14_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    frame_credit_ready_INST_0_i_15
       (.I0(grant_ready40_out[18]),
        .I1(grant_ready40_out[20]),
        .I2(grant_ready40_out[3]),
        .I3(grant_ready40_out[13]),
        .O(frame_credit_ready_INST_0_i_15_n_0));
  LUT4 #(
    .INIT(16'h7FFF)) 
    frame_credit_ready_INST_0_i_16
       (.I0(out[14]),
        .I1(out[13]),
        .I2(out[15]),
        .I3(out[12]),
        .O(frame_credit_ready_INST_0_i_16_n_0));
  LUT4 #(
    .INIT(16'h7FFF)) 
    frame_credit_ready_INST_0_i_17
       (.I0(out[5]),
        .I1(out[4]),
        .I2(out[7]),
        .I3(out[6]),
        .O(frame_credit_ready_INST_0_i_17_n_0));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    frame_credit_ready_INST_0_i_18
       (.I0(out[16]),
        .I1(out[19]),
        .I2(out[17]),
        .I3(out[18]),
        .I4(out[23]),
        .I5(out[20]),
        .O(frame_credit_ready_INST_0_i_18_n_0));
  LUT4 #(
    .INIT(16'h7FFF)) 
    frame_credit_ready_INST_0_i_19
       (.I0(out[31]),
        .I1(out[30]),
        .I2(out[29]),
        .I3(out[28]),
        .O(frame_credit_ready_INST_0_i_19_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    frame_credit_ready_INST_0_i_2
       (.I0(frame_credit_ready_INST_0_i_6_n_0),
        .I1(grant_ready40_out[5]),
        .I2(grant_ready40_out[29]),
        .I3(grant_ready40_out[2]),
        .I4(p_0_in28_in),
        .I5(frame_credit_ready_INST_0_i_8_n_0),
        .O(frame_credit_ready_INST_0_i_2_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    frame_credit_ready_INST_0_i_4
       (.I0(grant_ready40_out[10]),
        .I1(grant_ready40_out[7]),
        .I2(grant_ready40_out[14]),
        .I3(frame_credit_ready_INST_0_i_10_n_0),
        .I4(frame_credit_ready_INST_0_i_11_n_0),
        .O(frame_credit_ready_INST_0_i_4_n_0));
  LUT5 #(
    .INIT(32'h04000000)) 
    frame_credit_ready_INST_0_i_5
       (.I0(frame_credit_ready_INST_0_i_12_n_0),
        .I1(frame_credit_ready_INST_0_i_13_n_0),
        .I2(frame_credit_ready_INST_0_i_14_n_0),
        .I3(out[21]),
        .I4(out[22]),
        .O(frame_credit_ready_INST_0_i_5_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    frame_credit_ready_INST_0_i_6
       (.I0(grant_ready40_out[28]),
        .I1(grant_ready40_out[30]),
        .I2(grant_ready40_out[11]),
        .I3(grant_ready40_out[15]),
        .O(frame_credit_ready_INST_0_i_6_n_0));
  CARRY4 frame_credit_ready_INST_0_i_7
       (.CI(\grant_frame_id[28]_INST_0_n_0 ),
        .CO({NLW_frame_credit_ready_INST_0_i_7_CO_UNCONNECTED[3:1],p_0_in28_in}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_frame_credit_ready_INST_0_i_7_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    frame_credit_ready_INST_0_i_8
       (.I0(grant_ready40_out[26]),
        .I1(grant_ready40_out[23]),
        .I2(grant_ready40_out[19]),
        .I3(grant_ready40_out[4]),
        .I4(frame_credit_ready_INST_0_i_15_n_0),
        .O(frame_credit_ready_INST_0_i_8_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFF8)) 
    frame_credit_ready_INST_0_i_9
       (.I0(grant_ready40_out[1]),
        .I1(grant_ready40_out[0]),
        .I2(grant_ready40_out[24]),
        .I3(grant_ready40_out[12]),
        .I4(grant_ready40_out[9]),
        .I5(grant_ready40_out[6]),
        .O(\granted_frames_reg[3]_0 ));
  CARRY4 \grant_frame_id[0]_INST_0 
       (.CI(1'b0),
        .CO({\grant_frame_id[0]_INST_0_n_0 ,\grant_frame_id[0]_INST_0_n_1 ,\grant_frame_id[0]_INST_0_n_2 ,\grant_frame_id[0]_INST_0_n_3 }),
        .CYINIT(1'b0),
        .DI(first_frame_id[3:0]),
        .O(grant_frame_id[3:0]),
        .S({\grant_frame_id[0]_INST_0_i_1_n_0 ,\grant_frame_id[0]_INST_0_i_2_n_0 ,\grant_frame_id[0]_INST_0_i_3_n_0 ,\grant_frame_id[0]_INST_0_i_4_n_0 }));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[0]_INST_0_i_1 
       (.I0(first_frame_id[3]),
        .I1(out[3]),
        .O(\grant_frame_id[0]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[0]_INST_0_i_2 
       (.I0(first_frame_id[2]),
        .I1(out[2]),
        .O(\grant_frame_id[0]_INST_0_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[0]_INST_0_i_3 
       (.I0(first_frame_id[1]),
        .I1(out[1]),
        .O(\grant_frame_id[0]_INST_0_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[0]_INST_0_i_4 
       (.I0(first_frame_id[0]),
        .I1(out[0]),
        .O(\grant_frame_id[0]_INST_0_i_4_n_0 ));
  CARRY4 \grant_frame_id[12]_INST_0 
       (.CI(\grant_frame_id[8]_INST_0_n_0 ),
        .CO({\grant_frame_id[12]_INST_0_n_0 ,\grant_frame_id[12]_INST_0_n_1 ,\grant_frame_id[12]_INST_0_n_2 ,\grant_frame_id[12]_INST_0_n_3 }),
        .CYINIT(1'b0),
        .DI(first_frame_id[15:12]),
        .O(grant_frame_id[15:12]),
        .S({\grant_frame_id[12]_INST_0_i_1_n_0 ,\grant_frame_id[12]_INST_0_i_2_n_0 ,\grant_frame_id[12]_INST_0_i_3_n_0 ,\grant_frame_id[12]_INST_0_i_4_n_0 }));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[12]_INST_0_i_1 
       (.I0(first_frame_id[15]),
        .I1(out[15]),
        .O(\grant_frame_id[12]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[12]_INST_0_i_2 
       (.I0(first_frame_id[14]),
        .I1(out[14]),
        .O(\grant_frame_id[12]_INST_0_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[12]_INST_0_i_3 
       (.I0(first_frame_id[13]),
        .I1(out[13]),
        .O(\grant_frame_id[12]_INST_0_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[12]_INST_0_i_4 
       (.I0(first_frame_id[12]),
        .I1(out[12]),
        .O(\grant_frame_id[12]_INST_0_i_4_n_0 ));
  CARRY4 \grant_frame_id[16]_INST_0 
       (.CI(\grant_frame_id[12]_INST_0_n_0 ),
        .CO({\grant_frame_id[16]_INST_0_n_0 ,\grant_frame_id[16]_INST_0_n_1 ,\grant_frame_id[16]_INST_0_n_2 ,\grant_frame_id[16]_INST_0_n_3 }),
        .CYINIT(1'b0),
        .DI(first_frame_id[19:16]),
        .O(grant_frame_id[19:16]),
        .S({\grant_frame_id[16]_INST_0_i_1_n_0 ,\grant_frame_id[16]_INST_0_i_2_n_0 ,\grant_frame_id[16]_INST_0_i_3_n_0 ,\grant_frame_id[16]_INST_0_i_4_n_0 }));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[16]_INST_0_i_1 
       (.I0(first_frame_id[19]),
        .I1(out[19]),
        .O(\grant_frame_id[16]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[16]_INST_0_i_2 
       (.I0(first_frame_id[18]),
        .I1(out[18]),
        .O(\grant_frame_id[16]_INST_0_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[16]_INST_0_i_3 
       (.I0(first_frame_id[17]),
        .I1(out[17]),
        .O(\grant_frame_id[16]_INST_0_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[16]_INST_0_i_4 
       (.I0(first_frame_id[16]),
        .I1(out[16]),
        .O(\grant_frame_id[16]_INST_0_i_4_n_0 ));
  CARRY4 \grant_frame_id[20]_INST_0 
       (.CI(\grant_frame_id[16]_INST_0_n_0 ),
        .CO({\grant_frame_id[20]_INST_0_n_0 ,\grant_frame_id[20]_INST_0_n_1 ,\grant_frame_id[20]_INST_0_n_2 ,\grant_frame_id[20]_INST_0_n_3 }),
        .CYINIT(1'b0),
        .DI(first_frame_id[23:20]),
        .O(grant_frame_id[23:20]),
        .S({\grant_frame_id[20]_INST_0_i_1_n_0 ,\grant_frame_id[20]_INST_0_i_2_n_0 ,\grant_frame_id[20]_INST_0_i_3_n_0 ,\grant_frame_id[20]_INST_0_i_4_n_0 }));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[20]_INST_0_i_1 
       (.I0(first_frame_id[23]),
        .I1(out[23]),
        .O(\grant_frame_id[20]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[20]_INST_0_i_2 
       (.I0(first_frame_id[22]),
        .I1(out[22]),
        .O(\grant_frame_id[20]_INST_0_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[20]_INST_0_i_3 
       (.I0(first_frame_id[21]),
        .I1(out[21]),
        .O(\grant_frame_id[20]_INST_0_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[20]_INST_0_i_4 
       (.I0(first_frame_id[20]),
        .I1(out[20]),
        .O(\grant_frame_id[20]_INST_0_i_4_n_0 ));
  CARRY4 \grant_frame_id[24]_INST_0 
       (.CI(\grant_frame_id[20]_INST_0_n_0 ),
        .CO({\grant_frame_id[24]_INST_0_n_0 ,\grant_frame_id[24]_INST_0_n_1 ,\grant_frame_id[24]_INST_0_n_2 ,\grant_frame_id[24]_INST_0_n_3 }),
        .CYINIT(1'b0),
        .DI(first_frame_id[27:24]),
        .O(grant_frame_id[27:24]),
        .S({\grant_frame_id[24]_INST_0_i_1_n_0 ,\grant_frame_id[24]_INST_0_i_2_n_0 ,\grant_frame_id[24]_INST_0_i_3_n_0 ,\grant_frame_id[24]_INST_0_i_4_n_0 }));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[24]_INST_0_i_1 
       (.I0(first_frame_id[27]),
        .I1(out[27]),
        .O(\grant_frame_id[24]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[24]_INST_0_i_2 
       (.I0(first_frame_id[26]),
        .I1(out[26]),
        .O(\grant_frame_id[24]_INST_0_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[24]_INST_0_i_3 
       (.I0(first_frame_id[25]),
        .I1(out[25]),
        .O(\grant_frame_id[24]_INST_0_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[24]_INST_0_i_4 
       (.I0(first_frame_id[24]),
        .I1(out[24]),
        .O(\grant_frame_id[24]_INST_0_i_4_n_0 ));
  CARRY4 \grant_frame_id[28]_INST_0 
       (.CI(\grant_frame_id[24]_INST_0_n_0 ),
        .CO({\grant_frame_id[28]_INST_0_n_0 ,\grant_frame_id[28]_INST_0_n_1 ,\grant_frame_id[28]_INST_0_n_2 ,\grant_frame_id[28]_INST_0_n_3 }),
        .CYINIT(1'b0),
        .DI(first_frame_id[31:28]),
        .O(grant_frame_id[31:28]),
        .S({\grant_frame_id[28]_INST_0_i_1_n_0 ,\grant_frame_id[28]_INST_0_i_2_n_0 ,\grant_frame_id[28]_INST_0_i_3_n_0 ,\grant_frame_id[28]_INST_0_i_4_n_0 }));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[28]_INST_0_i_1 
       (.I0(first_frame_id[31]),
        .I1(out[31]),
        .O(\grant_frame_id[28]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[28]_INST_0_i_2 
       (.I0(first_frame_id[30]),
        .I1(out[30]),
        .O(\grant_frame_id[28]_INST_0_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[28]_INST_0_i_3 
       (.I0(first_frame_id[29]),
        .I1(out[29]),
        .O(\grant_frame_id[28]_INST_0_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[28]_INST_0_i_4 
       (.I0(first_frame_id[28]),
        .I1(out[28]),
        .O(\grant_frame_id[28]_INST_0_i_4_n_0 ));
  CARRY4 \grant_frame_id[4]_INST_0 
       (.CI(\grant_frame_id[0]_INST_0_n_0 ),
        .CO({\grant_frame_id[4]_INST_0_n_0 ,\grant_frame_id[4]_INST_0_n_1 ,\grant_frame_id[4]_INST_0_n_2 ,\grant_frame_id[4]_INST_0_n_3 }),
        .CYINIT(1'b0),
        .DI(first_frame_id[7:4]),
        .O(grant_frame_id[7:4]),
        .S({\grant_frame_id[4]_INST_0_i_1_n_0 ,\grant_frame_id[4]_INST_0_i_2_n_0 ,\grant_frame_id[4]_INST_0_i_3_n_0 ,\grant_frame_id[4]_INST_0_i_4_n_0 }));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[4]_INST_0_i_1 
       (.I0(first_frame_id[7]),
        .I1(out[7]),
        .O(\grant_frame_id[4]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[4]_INST_0_i_2 
       (.I0(first_frame_id[6]),
        .I1(out[6]),
        .O(\grant_frame_id[4]_INST_0_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[4]_INST_0_i_3 
       (.I0(first_frame_id[5]),
        .I1(out[5]),
        .O(\grant_frame_id[4]_INST_0_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[4]_INST_0_i_4 
       (.I0(first_frame_id[4]),
        .I1(out[4]),
        .O(\grant_frame_id[4]_INST_0_i_4_n_0 ));
  CARRY4 \grant_frame_id[8]_INST_0 
       (.CI(\grant_frame_id[4]_INST_0_n_0 ),
        .CO({\grant_frame_id[8]_INST_0_n_0 ,\grant_frame_id[8]_INST_0_n_1 ,\grant_frame_id[8]_INST_0_n_2 ,\grant_frame_id[8]_INST_0_n_3 }),
        .CYINIT(1'b0),
        .DI(first_frame_id[11:8]),
        .O(grant_frame_id[11:8]),
        .S({\grant_frame_id[8]_INST_0_i_1_n_0 ,\grant_frame_id[8]_INST_0_i_2_n_0 ,\grant_frame_id[8]_INST_0_i_3_n_0 ,\grant_frame_id[8]_INST_0_i_4_n_0 }));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[8]_INST_0_i_1 
       (.I0(first_frame_id[11]),
        .I1(out[11]),
        .O(\grant_frame_id[8]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[8]_INST_0_i_2 
       (.I0(first_frame_id[10]),
        .I1(out[10]),
        .O(\grant_frame_id[8]_INST_0_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[8]_INST_0_i_3 
       (.I0(first_frame_id[9]),
        .I1(out[9]),
        .O(\grant_frame_id[8]_INST_0_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grant_frame_id[8]_INST_0_i_4 
       (.I0(first_frame_id[8]),
        .I1(out[8]),
        .O(\grant_frame_id[8]_INST_0_i_4_n_0 ));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 grant_ready1_carry
       (.CI(1'b0),
        .CO({grant_ready1_carry_n_0,grant_ready1_carry_n_1,grant_ready1_carry_n_2,grant_ready1_carry_n_3}),
        .CYINIT(1'b0),
        .DI(DI),
        .O(NLW_grant_ready1_carry_O_UNCONNECTED[3:0]),
        .S(grant_ready1_carry__0_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 grant_ready1_carry__0
       (.CI(grant_ready1_carry_n_0),
        .CO({grant_ready1_carry__0_n_0,grant_ready1_carry__0_n_1,grant_ready1_carry__0_n_2,grant_ready1_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI(grant_ready1_carry__1_0),
        .O(NLW_grant_ready1_carry__0_O_UNCONNECTED[3:0]),
        .S(grant_ready1_carry__1_1));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 grant_ready1_carry__1
       (.CI(grant_ready1_carry__0_n_0),
        .CO({grant_ready1_carry__1_n_0,grant_ready1_carry__1_n_1,grant_ready1_carry__1_n_2,grant_ready1_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI(grant_ready1_carry__2_0),
        .O(NLW_grant_ready1_carry__1_O_UNCONNECTED[3:0]),
        .S(grant_ready1_carry__2_1));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 grant_ready1_carry__2
       (.CI(grant_ready1_carry__1_n_0),
        .CO({CO,grant_ready1_carry__2_n_1,grant_ready1_carry__2_n_2,grant_ready1_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI(frame_credit_ready_INST_0_i_3),
        .O(NLW_grant_ready1_carry__2_O_UNCONNECTED[3:0]),
        .S(frame_credit_ready_INST_0_i_3_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 grant_ready4_carry
       (.CI(1'b0),
        .CO({grant_ready4_carry_n_0,grant_ready4_carry_n_1,grant_ready4_carry_n_2,grant_ready4_carry_n_3}),
        .CYINIT(1'b1),
        .DI(out[3:0]),
        .O(grant_ready40_out[3:0]),
        .S({grant_ready4_carry_i_1_n_0,grant_ready4_carry_i_2_n_0,grant_ready4_carry_i_3_n_0,grant_ready4_carry_i_4_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 grant_ready4_carry__0
       (.CI(grant_ready4_carry_n_0),
        .CO({grant_ready4_carry__0_n_0,grant_ready4_carry__0_n_1,grant_ready4_carry__0_n_2,grant_ready4_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI(out[7:4]),
        .O(grant_ready40_out[7:4]),
        .S({grant_ready4_carry__0_i_1_n_0,grant_ready4_carry__0_i_2_n_0,grant_ready4_carry__0_i_3_n_0,grant_ready4_carry__0_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__0_i_1
       (.I0(out[7]),
        .I1(\released_frames_reg[31]_0 [7]),
        .O(grant_ready4_carry__0_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__0_i_2
       (.I0(out[6]),
        .I1(\released_frames_reg[31]_0 [6]),
        .O(grant_ready4_carry__0_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__0_i_3
       (.I0(out[5]),
        .I1(\released_frames_reg[31]_0 [5]),
        .O(grant_ready4_carry__0_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__0_i_4
       (.I0(out[4]),
        .I1(\released_frames_reg[31]_0 [4]),
        .O(grant_ready4_carry__0_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 grant_ready4_carry__1
       (.CI(grant_ready4_carry__0_n_0),
        .CO({grant_ready4_carry__1_n_0,grant_ready4_carry__1_n_1,grant_ready4_carry__1_n_2,grant_ready4_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI(out[11:8]),
        .O(grant_ready40_out[11:8]),
        .S({grant_ready4_carry__1_i_1_n_0,grant_ready4_carry__1_i_2_n_0,grant_ready4_carry__1_i_3_n_0,grant_ready4_carry__1_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__1_i_1
       (.I0(out[11]),
        .I1(\released_frames_reg[31]_0 [11]),
        .O(grant_ready4_carry__1_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__1_i_2
       (.I0(out[10]),
        .I1(\released_frames_reg[31]_0 [10]),
        .O(grant_ready4_carry__1_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__1_i_3
       (.I0(out[9]),
        .I1(\released_frames_reg[31]_0 [9]),
        .O(grant_ready4_carry__1_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__1_i_4
       (.I0(out[8]),
        .I1(\released_frames_reg[31]_0 [8]),
        .O(grant_ready4_carry__1_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 grant_ready4_carry__2
       (.CI(grant_ready4_carry__1_n_0),
        .CO({grant_ready4_carry__2_n_0,grant_ready4_carry__2_n_1,grant_ready4_carry__2_n_2,grant_ready4_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI(out[15:12]),
        .O(grant_ready40_out[15:12]),
        .S({grant_ready4_carry__2_i_1_n_0,grant_ready4_carry__2_i_2_n_0,grant_ready4_carry__2_i_3_n_0,grant_ready4_carry__2_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__2_i_1
       (.I0(out[15]),
        .I1(\released_frames_reg[31]_0 [15]),
        .O(grant_ready4_carry__2_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__2_i_2
       (.I0(out[14]),
        .I1(\released_frames_reg[31]_0 [14]),
        .O(grant_ready4_carry__2_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__2_i_3
       (.I0(out[13]),
        .I1(\released_frames_reg[31]_0 [13]),
        .O(grant_ready4_carry__2_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__2_i_4
       (.I0(out[12]),
        .I1(\released_frames_reg[31]_0 [12]),
        .O(grant_ready4_carry__2_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 grant_ready4_carry__3
       (.CI(grant_ready4_carry__2_n_0),
        .CO({grant_ready4_carry__3_n_0,grant_ready4_carry__3_n_1,grant_ready4_carry__3_n_2,grant_ready4_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI(out[19:16]),
        .O(grant_ready40_out[19:16]),
        .S({grant_ready4_carry__3_i_1_n_0,grant_ready4_carry__3_i_2_n_0,grant_ready4_carry__3_i_3_n_0,grant_ready4_carry__3_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__3_i_1
       (.I0(out[19]),
        .I1(\released_frames_reg[31]_0 [19]),
        .O(grant_ready4_carry__3_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__3_i_2
       (.I0(out[18]),
        .I1(\released_frames_reg[31]_0 [18]),
        .O(grant_ready4_carry__3_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__3_i_3
       (.I0(out[17]),
        .I1(\released_frames_reg[31]_0 [17]),
        .O(grant_ready4_carry__3_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__3_i_4
       (.I0(out[16]),
        .I1(\released_frames_reg[31]_0 [16]),
        .O(grant_ready4_carry__3_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 grant_ready4_carry__4
       (.CI(grant_ready4_carry__3_n_0),
        .CO({grant_ready4_carry__4_n_0,grant_ready4_carry__4_n_1,grant_ready4_carry__4_n_2,grant_ready4_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI(out[23:20]),
        .O(grant_ready40_out[23:20]),
        .S({grant_ready4_carry__4_i_1_n_0,grant_ready4_carry__4_i_2_n_0,grant_ready4_carry__4_i_3_n_0,grant_ready4_carry__4_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__4_i_1
       (.I0(out[23]),
        .I1(\released_frames_reg[31]_0 [23]),
        .O(grant_ready4_carry__4_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__4_i_2
       (.I0(out[22]),
        .I1(\released_frames_reg[31]_0 [22]),
        .O(grant_ready4_carry__4_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__4_i_3
       (.I0(out[21]),
        .I1(\released_frames_reg[31]_0 [21]),
        .O(grant_ready4_carry__4_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__4_i_4
       (.I0(out[20]),
        .I1(\released_frames_reg[31]_0 [20]),
        .O(grant_ready4_carry__4_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 grant_ready4_carry__5
       (.CI(grant_ready4_carry__4_n_0),
        .CO({grant_ready4_carry__5_n_0,grant_ready4_carry__5_n_1,grant_ready4_carry__5_n_2,grant_ready4_carry__5_n_3}),
        .CYINIT(1'b0),
        .DI(out[27:24]),
        .O(grant_ready40_out[27:24]),
        .S({grant_ready4_carry__5_i_1_n_0,grant_ready4_carry__5_i_2_n_0,grant_ready4_carry__5_i_3_n_0,grant_ready4_carry__5_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__5_i_1
       (.I0(out[27]),
        .I1(\released_frames_reg[31]_0 [27]),
        .O(grant_ready4_carry__5_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__5_i_2
       (.I0(out[26]),
        .I1(\released_frames_reg[31]_0 [26]),
        .O(grant_ready4_carry__5_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__5_i_3
       (.I0(out[25]),
        .I1(\released_frames_reg[31]_0 [25]),
        .O(grant_ready4_carry__5_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__5_i_4
       (.I0(out[24]),
        .I1(\released_frames_reg[31]_0 [24]),
        .O(grant_ready4_carry__5_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 grant_ready4_carry__6
       (.CI(grant_ready4_carry__5_n_0),
        .CO({NLW_grant_ready4_carry__6_CO_UNCONNECTED[3],grant_ready4_carry__6_n_1,grant_ready4_carry__6_n_2,grant_ready4_carry__6_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,out[30:28]}),
        .O(grant_ready40_out[31:28]),
        .S({grant_ready4_carry__6_i_1_n_0,grant_ready4_carry__6_i_2_n_0,grant_ready4_carry__6_i_3_n_0,grant_ready4_carry__6_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__6_i_1
       (.I0(\released_frames_reg[31]_0 [31]),
        .I1(out[31]),
        .O(grant_ready4_carry__6_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__6_i_2
       (.I0(out[30]),
        .I1(\released_frames_reg[31]_0 [30]),
        .O(grant_ready4_carry__6_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__6_i_3
       (.I0(out[29]),
        .I1(\released_frames_reg[31]_0 [29]),
        .O(grant_ready4_carry__6_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry__6_i_4
       (.I0(out[28]),
        .I1(\released_frames_reg[31]_0 [28]),
        .O(grant_ready4_carry__6_i_4_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry_i_1
       (.I0(out[3]),
        .I1(\released_frames_reg[31]_0 [3]),
        .O(grant_ready4_carry_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry_i_2
       (.I0(out[2]),
        .I1(\released_frames_reg[31]_0 [2]),
        .O(grant_ready4_carry_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry_i_3
       (.I0(out[1]),
        .I1(\released_frames_reg[31]_0 [1]),
        .O(grant_ready4_carry_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    grant_ready4_carry_i_4
       (.I0(out[0]),
        .I1(\released_frames_reg[31]_0 [0]),
        .O(grant_ready4_carry_i_4_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    \granted_frames[3]_i_2 
       (.I0(out[0]),
        .O(\granted_frames[3]_i_2_n_0 ));
  FDRE \granted_frames_reg[0] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[3]_i_1_n_7 ),
        .Q(out[0]),
        .R(clear));
  FDRE \granted_frames_reg[10] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[11]_i_1_n_5 ),
        .Q(out[10]),
        .R(clear));
  FDRE \granted_frames_reg[11] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[11]_i_1_n_4 ),
        .Q(out[11]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \granted_frames_reg[11]_i_1 
       (.CI(\granted_frames_reg[7]_i_1_n_0 ),
        .CO({\granted_frames_reg[11]_i_1_n_0 ,\granted_frames_reg[11]_i_1_n_1 ,\granted_frames_reg[11]_i_1_n_2 ,\granted_frames_reg[11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\granted_frames_reg[11]_i_1_n_4 ,\granted_frames_reg[11]_i_1_n_5 ,\granted_frames_reg[11]_i_1_n_6 ,\granted_frames_reg[11]_i_1_n_7 }),
        .S(out[11:8]));
  FDRE \granted_frames_reg[12] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[15]_i_1_n_7 ),
        .Q(out[12]),
        .R(clear));
  FDRE \granted_frames_reg[13] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[15]_i_1_n_6 ),
        .Q(out[13]),
        .R(clear));
  FDRE \granted_frames_reg[14] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[15]_i_1_n_5 ),
        .Q(out[14]),
        .R(clear));
  FDRE \granted_frames_reg[15] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[15]_i_1_n_4 ),
        .Q(out[15]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \granted_frames_reg[15]_i_1 
       (.CI(\granted_frames_reg[11]_i_1_n_0 ),
        .CO({\granted_frames_reg[15]_i_1_n_0 ,\granted_frames_reg[15]_i_1_n_1 ,\granted_frames_reg[15]_i_1_n_2 ,\granted_frames_reg[15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\granted_frames_reg[15]_i_1_n_4 ,\granted_frames_reg[15]_i_1_n_5 ,\granted_frames_reg[15]_i_1_n_6 ,\granted_frames_reg[15]_i_1_n_7 }),
        .S(out[15:12]));
  FDRE \granted_frames_reg[16] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[19]_i_1_n_7 ),
        .Q(out[16]),
        .R(clear));
  FDRE \granted_frames_reg[17] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[19]_i_1_n_6 ),
        .Q(out[17]),
        .R(clear));
  FDRE \granted_frames_reg[18] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[19]_i_1_n_5 ),
        .Q(out[18]),
        .R(clear));
  FDRE \granted_frames_reg[19] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[19]_i_1_n_4 ),
        .Q(out[19]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \granted_frames_reg[19]_i_1 
       (.CI(\granted_frames_reg[15]_i_1_n_0 ),
        .CO({\granted_frames_reg[19]_i_1_n_0 ,\granted_frames_reg[19]_i_1_n_1 ,\granted_frames_reg[19]_i_1_n_2 ,\granted_frames_reg[19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\granted_frames_reg[19]_i_1_n_4 ,\granted_frames_reg[19]_i_1_n_5 ,\granted_frames_reg[19]_i_1_n_6 ,\granted_frames_reg[19]_i_1_n_7 }),
        .S(out[19:16]));
  FDRE \granted_frames_reg[1] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[3]_i_1_n_6 ),
        .Q(out[1]),
        .R(clear));
  FDRE \granted_frames_reg[20] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[23]_i_1_n_7 ),
        .Q(out[20]),
        .R(clear));
  FDRE \granted_frames_reg[21] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[23]_i_1_n_6 ),
        .Q(out[21]),
        .R(clear));
  FDRE \granted_frames_reg[22] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[23]_i_1_n_5 ),
        .Q(out[22]),
        .R(clear));
  FDRE \granted_frames_reg[23] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[23]_i_1_n_4 ),
        .Q(out[23]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \granted_frames_reg[23]_i_1 
       (.CI(\granted_frames_reg[19]_i_1_n_0 ),
        .CO({\granted_frames_reg[23]_i_1_n_0 ,\granted_frames_reg[23]_i_1_n_1 ,\granted_frames_reg[23]_i_1_n_2 ,\granted_frames_reg[23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\granted_frames_reg[23]_i_1_n_4 ,\granted_frames_reg[23]_i_1_n_5 ,\granted_frames_reg[23]_i_1_n_6 ,\granted_frames_reg[23]_i_1_n_7 }),
        .S(out[23:20]));
  FDRE \granted_frames_reg[24] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[27]_i_1_n_7 ),
        .Q(out[24]),
        .R(clear));
  FDRE \granted_frames_reg[25] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[27]_i_1_n_6 ),
        .Q(out[25]),
        .R(clear));
  FDRE \granted_frames_reg[26] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[27]_i_1_n_5 ),
        .Q(out[26]),
        .R(clear));
  FDRE \granted_frames_reg[27] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[27]_i_1_n_4 ),
        .Q(out[27]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \granted_frames_reg[27]_i_1 
       (.CI(\granted_frames_reg[23]_i_1_n_0 ),
        .CO({\granted_frames_reg[27]_i_1_n_0 ,\granted_frames_reg[27]_i_1_n_1 ,\granted_frames_reg[27]_i_1_n_2 ,\granted_frames_reg[27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\granted_frames_reg[27]_i_1_n_4 ,\granted_frames_reg[27]_i_1_n_5 ,\granted_frames_reg[27]_i_1_n_6 ,\granted_frames_reg[27]_i_1_n_7 }),
        .S(out[27:24]));
  FDRE \granted_frames_reg[28] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[31]_i_1_n_7 ),
        .Q(out[28]),
        .R(clear));
  FDRE \granted_frames_reg[29] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[31]_i_1_n_6 ),
        .Q(out[29]),
        .R(clear));
  FDRE \granted_frames_reg[2] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[3]_i_1_n_5 ),
        .Q(out[2]),
        .R(clear));
  FDRE \granted_frames_reg[30] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[31]_i_1_n_5 ),
        .Q(out[30]),
        .R(clear));
  FDRE \granted_frames_reg[31] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[31]_i_1_n_4 ),
        .Q(out[31]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \granted_frames_reg[31]_i_1 
       (.CI(\granted_frames_reg[27]_i_1_n_0 ),
        .CO({\NLW_granted_frames_reg[31]_i_1_CO_UNCONNECTED [3],\granted_frames_reg[31]_i_1_n_1 ,\granted_frames_reg[31]_i_1_n_2 ,\granted_frames_reg[31]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\granted_frames_reg[31]_i_1_n_4 ,\granted_frames_reg[31]_i_1_n_5 ,\granted_frames_reg[31]_i_1_n_6 ,\granted_frames_reg[31]_i_1_n_7 }),
        .S(out[31:28]));
  FDRE \granted_frames_reg[3] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[3]_i_1_n_4 ),
        .Q(out[3]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \granted_frames_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\granted_frames_reg[3]_i_1_n_0 ,\granted_frames_reg[3]_i_1_n_1 ,\granted_frames_reg[3]_i_1_n_2 ,\granted_frames_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\granted_frames_reg[3]_i_1_n_4 ,\granted_frames_reg[3]_i_1_n_5 ,\granted_frames_reg[3]_i_1_n_6 ,\granted_frames_reg[3]_i_1_n_7 }),
        .S({out[3:1],\granted_frames[3]_i_2_n_0 }));
  FDRE \granted_frames_reg[4] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[7]_i_1_n_7 ),
        .Q(out[4]),
        .R(clear));
  FDRE \granted_frames_reg[5] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[7]_i_1_n_6 ),
        .Q(out[5]),
        .R(clear));
  FDRE \granted_frames_reg[6] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[7]_i_1_n_5 ),
        .Q(out[6]),
        .R(clear));
  FDRE \granted_frames_reg[7] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[7]_i_1_n_4 ),
        .Q(out[7]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \granted_frames_reg[7]_i_1 
       (.CI(\granted_frames_reg[3]_i_1_n_0 ),
        .CO({\granted_frames_reg[7]_i_1_n_0 ,\granted_frames_reg[7]_i_1_n_1 ,\granted_frames_reg[7]_i_1_n_2 ,\granted_frames_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\granted_frames_reg[7]_i_1_n_4 ,\granted_frames_reg[7]_i_1_n_5 ,\granted_frames_reg[7]_i_1_n_6 ,\granted_frames_reg[7]_i_1_n_7 }),
        .S(out[7:4]));
  FDRE \granted_frames_reg[8] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[11]_i_1_n_7 ),
        .Q(out[8]),
        .R(clear));
  FDRE \granted_frames_reg[9] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\granted_frames_reg[11]_i_1_n_6 ),
        .Q(out[9]),
        .R(clear));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry__0_i_1
       (.I0(previous_packet[15]),
        .I1(packet_completed_frames[15]),
        .I2(previous_packet[14]),
        .I3(packet_completed_frames[14]),
        .O(i__carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    i__carry__0_i_1__0
       (.I0(cpu_frame_id[21]),
        .I1(available_frame_id[21]),
        .I2(cpu_frame_id[22]),
        .I3(available_frame_id[22]),
        .I4(available_frame_id[23]),
        .I5(cpu_frame_id[23]),
        .O(i__carry__0_i_1__0_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry__0_i_2
       (.I0(previous_packet[13]),
        .I1(packet_completed_frames[13]),
        .I2(previous_packet[12]),
        .I3(packet_completed_frames[12]),
        .O(i__carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    i__carry__0_i_2__0
       (.I0(cpu_frame_id[20]),
        .I1(available_frame_id[20]),
        .I2(cpu_frame_id[18]),
        .I3(available_frame_id[18]),
        .I4(available_frame_id[19]),
        .I5(cpu_frame_id[19]),
        .O(i__carry__0_i_2__0_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry__0_i_3
       (.I0(previous_packet[11]),
        .I1(packet_completed_frames[11]),
        .I2(previous_packet[10]),
        .I3(packet_completed_frames[10]),
        .O(i__carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    i__carry__0_i_3__0
       (.I0(cpu_frame_id[16]),
        .I1(available_frame_id[16]),
        .I2(cpu_frame_id[15]),
        .I3(available_frame_id[15]),
        .I4(available_frame_id[17]),
        .I5(cpu_frame_id[17]),
        .O(i__carry__0_i_3__0_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry__0_i_4
       (.I0(previous_packet[9]),
        .I1(packet_completed_frames[9]),
        .I2(previous_packet[8]),
        .I3(packet_completed_frames[8]),
        .O(i__carry__0_i_4_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    i__carry__0_i_4__0
       (.I0(cpu_frame_id[12]),
        .I1(available_frame_id[12]),
        .I2(cpu_frame_id[13]),
        .I3(available_frame_id[13]),
        .I4(available_frame_id[14]),
        .I5(cpu_frame_id[14]),
        .O(i__carry__0_i_4__0_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry__0_i_5
       (.I0(packet_completed_frames[15]),
        .I1(previous_packet[15]),
        .I2(packet_completed_frames[14]),
        .I3(previous_packet[14]),
        .O(i__carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry__0_i_6
       (.I0(packet_completed_frames[13]),
        .I1(previous_packet[13]),
        .I2(packet_completed_frames[12]),
        .I3(previous_packet[12]),
        .O(i__carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry__0_i_7
       (.I0(packet_completed_frames[11]),
        .I1(previous_packet[11]),
        .I2(packet_completed_frames[10]),
        .I3(previous_packet[10]),
        .O(i__carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry__0_i_8
       (.I0(packet_completed_frames[9]),
        .I1(previous_packet[9]),
        .I2(packet_completed_frames[8]),
        .I3(previous_packet[8]),
        .O(i__carry__0_i_8_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry__1_i_1
       (.I0(previous_packet[23]),
        .I1(packet_completed_frames[23]),
        .I2(previous_packet[22]),
        .I3(packet_completed_frames[22]),
        .O(i__carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry__1_i_1__0
       (.I0(available_frame_id[31]),
        .I1(cpu_frame_id[31]),
        .I2(available_frame_id[30]),
        .I3(cpu_frame_id[30]),
        .O(i__carry__1_i_1__0_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry__1_i_2
       (.I0(previous_packet[21]),
        .I1(packet_completed_frames[21]),
        .I2(previous_packet[20]),
        .I3(packet_completed_frames[20]),
        .O(i__carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    i__carry__1_i_2__0
       (.I0(cpu_frame_id[27]),
        .I1(available_frame_id[27]),
        .I2(cpu_frame_id[28]),
        .I3(available_frame_id[28]),
        .I4(available_frame_id[29]),
        .I5(cpu_frame_id[29]),
        .O(i__carry__1_i_2__0_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry__1_i_3
       (.I0(previous_packet[19]),
        .I1(packet_completed_frames[19]),
        .I2(previous_packet[18]),
        .I3(packet_completed_frames[18]),
        .O(i__carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    i__carry__1_i_3__0
       (.I0(cpu_frame_id[24]),
        .I1(available_frame_id[24]),
        .I2(cpu_frame_id[25]),
        .I3(available_frame_id[25]),
        .I4(available_frame_id[26]),
        .I5(cpu_frame_id[26]),
        .O(i__carry__1_i_3__0_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry__1_i_4
       (.I0(previous_packet[17]),
        .I1(packet_completed_frames[17]),
        .I2(previous_packet[16]),
        .I3(packet_completed_frames[16]),
        .O(i__carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry__1_i_5
       (.I0(packet_completed_frames[23]),
        .I1(previous_packet[23]),
        .I2(packet_completed_frames[22]),
        .I3(previous_packet[22]),
        .O(i__carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry__1_i_6
       (.I0(packet_completed_frames[21]),
        .I1(previous_packet[21]),
        .I2(packet_completed_frames[20]),
        .I3(previous_packet[20]),
        .O(i__carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry__1_i_7
       (.I0(packet_completed_frames[19]),
        .I1(previous_packet[19]),
        .I2(packet_completed_frames[18]),
        .I3(previous_packet[18]),
        .O(i__carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry__1_i_8
       (.I0(packet_completed_frames[17]),
        .I1(previous_packet[17]),
        .I2(packet_completed_frames[16]),
        .I3(previous_packet[16]),
        .O(i__carry__1_i_8_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry__2_i_1
       (.I0(previous_packet[31]),
        .I1(packet_completed_frames[31]),
        .I2(previous_packet[30]),
        .I3(packet_completed_frames[30]),
        .O(i__carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry__2_i_2
       (.I0(previous_packet[29]),
        .I1(packet_completed_frames[29]),
        .I2(previous_packet[28]),
        .I3(packet_completed_frames[28]),
        .O(i__carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry__2_i_3
       (.I0(previous_packet[27]),
        .I1(packet_completed_frames[27]),
        .I2(previous_packet[26]),
        .I3(packet_completed_frames[26]),
        .O(i__carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry__2_i_4
       (.I0(previous_packet[25]),
        .I1(packet_completed_frames[25]),
        .I2(previous_packet[24]),
        .I3(packet_completed_frames[24]),
        .O(i__carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry__2_i_5
       (.I0(packet_completed_frames[31]),
        .I1(previous_packet[31]),
        .I2(packet_completed_frames[30]),
        .I3(previous_packet[30]),
        .O(i__carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry__2_i_6
       (.I0(packet_completed_frames[29]),
        .I1(previous_packet[29]),
        .I2(packet_completed_frames[28]),
        .I3(previous_packet[28]),
        .O(i__carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry__2_i_7
       (.I0(packet_completed_frames[27]),
        .I1(previous_packet[27]),
        .I2(packet_completed_frames[26]),
        .I3(previous_packet[26]),
        .O(i__carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry__2_i_8
       (.I0(packet_completed_frames[25]),
        .I1(previous_packet[25]),
        .I2(packet_completed_frames[24]),
        .I3(previous_packet[24]),
        .O(i__carry__2_i_8_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry_i_1
       (.I0(previous_packet[7]),
        .I1(packet_completed_frames[7]),
        .I2(previous_packet[6]),
        .I3(packet_completed_frames[6]),
        .O(i__carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    i__carry_i_1__0
       (.I0(cpu_frame_id[9]),
        .I1(available_frame_id[9]),
        .I2(cpu_frame_id[10]),
        .I3(available_frame_id[10]),
        .I4(available_frame_id[11]),
        .I5(cpu_frame_id[11]),
        .O(i__carry_i_1__0_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry_i_2
       (.I0(previous_packet[5]),
        .I1(packet_completed_frames[5]),
        .I2(previous_packet[4]),
        .I3(packet_completed_frames[4]),
        .O(i__carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    i__carry_i_2__0
       (.I0(cpu_frame_id[6]),
        .I1(available_frame_id[6]),
        .I2(cpu_frame_id[7]),
        .I3(available_frame_id[7]),
        .I4(available_frame_id[8]),
        .I5(cpu_frame_id[8]),
        .O(i__carry_i_2__0_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry_i_3
       (.I0(previous_packet[3]),
        .I1(packet_completed_frames[3]),
        .I2(previous_packet[2]),
        .I3(packet_completed_frames[2]),
        .O(i__carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    i__carry_i_3__0
       (.I0(cpu_frame_id[3]),
        .I1(available_frame_id[3]),
        .I2(cpu_frame_id[4]),
        .I3(available_frame_id[4]),
        .I4(available_frame_id[5]),
        .I5(cpu_frame_id[5]),
        .O(i__carry_i_3__0_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    i__carry_i_4
       (.I0(previous_packet[1]),
        .I1(packet_completed_frames[1]),
        .I2(previous_packet[0]),
        .I3(packet_completed_frames[0]),
        .O(i__carry_i_4_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    i__carry_i_4__0
       (.I0(cpu_frame_id[2]),
        .I1(available_frame_id[2]),
        .I2(cpu_frame_id[0]),
        .I3(available_frame_id[0]),
        .I4(available_frame_id[1]),
        .I5(cpu_frame_id[1]),
        .O(i__carry_i_4__0_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry_i_5
       (.I0(packet_completed_frames[7]),
        .I1(previous_packet[7]),
        .I2(packet_completed_frames[6]),
        .I3(previous_packet[6]),
        .O(i__carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry_i_6
       (.I0(packet_completed_frames[5]),
        .I1(previous_packet[5]),
        .I2(packet_completed_frames[4]),
        .I3(previous_packet[4]),
        .O(i__carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry_i_7
       (.I0(packet_completed_frames[3]),
        .I1(previous_packet[3]),
        .I2(packet_completed_frames[2]),
        .I3(previous_packet[2]),
        .O(i__carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    i__carry_i_8
       (.I0(packet_completed_frames[1]),
        .I1(previous_packet[1]),
        .I2(packet_completed_frames[0]),
        .I3(previous_packet[0]),
        .O(i__carry_i_8_n_0));
  CARRY4 owner_drained4_carry
       (.CI(1'b0),
        .CO({owner_drained4_carry_n_0,owner_drained4_carry_n_1,owner_drained4_carry_n_2,owner_drained4_carry_n_3}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained4_carry_O_UNCONNECTED[3:0]),
        .S({owner_drained4_carry_i_1_n_0,owner_drained4_carry_i_2_n_0,owner_drained4_carry_i_3_n_0,owner_drained4_carry_i_4_n_0}));
  CARRY4 owner_drained4_carry__0
       (.CI(owner_drained4_carry_n_0),
        .CO({owner_drained4_carry__0_n_0,owner_drained4_carry__0_n_1,owner_drained4_carry__0_n_2,owner_drained4_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained4_carry__0_O_UNCONNECTED[3:0]),
        .S({owner_drained4_carry__0_i_1_n_0,owner_drained4_carry__0_i_2_n_0,owner_drained4_carry__0_i_3_n_0,owner_drained4_carry__0_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained4_carry__0_i_1
       (.I0(out[22]),
        .I1(status_completed_frames[22]),
        .I2(out[23]),
        .I3(status_completed_frames[23]),
        .I4(status_completed_frames[21]),
        .I5(out[21]),
        .O(owner_drained4_carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained4_carry__0_i_2
       (.I0(out[18]),
        .I1(status_completed_frames[18]),
        .I2(out[19]),
        .I3(status_completed_frames[19]),
        .I4(status_completed_frames[20]),
        .I5(out[20]),
        .O(owner_drained4_carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained4_carry__0_i_3
       (.I0(out[16]),
        .I1(status_completed_frames[16]),
        .I2(out[17]),
        .I3(status_completed_frames[17]),
        .I4(status_completed_frames[15]),
        .I5(out[15]),
        .O(owner_drained4_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained4_carry__0_i_4
       (.I0(out[12]),
        .I1(status_completed_frames[12]),
        .I2(out[13]),
        .I3(status_completed_frames[13]),
        .I4(status_completed_frames[14]),
        .I5(out[14]),
        .O(owner_drained4_carry__0_i_4_n_0));
  CARRY4 owner_drained4_carry__1
       (.CI(owner_drained4_carry__0_n_0),
        .CO({NLW_owner_drained4_carry__1_CO_UNCONNECTED[3],owner_drained4,owner_drained4_carry__1_n_2,owner_drained4_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained4_carry__1_O_UNCONNECTED[3:0]),
        .S({1'b0,owner_drained4_carry__1_i_1_n_0,owner_drained4_carry__1_i_2_n_0,owner_drained4_carry__1_i_3_n_0}));
  LUT4 #(
    .INIT(16'h9009)) 
    owner_drained4_carry__1_i_1
       (.I0(status_completed_frames[31]),
        .I1(out[31]),
        .I2(status_completed_frames[30]),
        .I3(out[30]),
        .O(owner_drained4_carry__1_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained4_carry__1_i_2
       (.I0(out[28]),
        .I1(status_completed_frames[28]),
        .I2(out[29]),
        .I3(status_completed_frames[29]),
        .I4(status_completed_frames[27]),
        .I5(out[27]),
        .O(owner_drained4_carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained4_carry__1_i_3
       (.I0(out[24]),
        .I1(status_completed_frames[24]),
        .I2(out[25]),
        .I3(status_completed_frames[25]),
        .I4(status_completed_frames[26]),
        .I5(out[26]),
        .O(owner_drained4_carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained4_carry_i_1
       (.I0(out[10]),
        .I1(status_completed_frames[10]),
        .I2(out[11]),
        .I3(status_completed_frames[11]),
        .I4(status_completed_frames[9]),
        .I5(out[9]),
        .O(owner_drained4_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained4_carry_i_2
       (.I0(out[6]),
        .I1(status_completed_frames[6]),
        .I2(out[7]),
        .I3(status_completed_frames[7]),
        .I4(status_completed_frames[8]),
        .I5(out[8]),
        .O(owner_drained4_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained4_carry_i_3
       (.I0(out[4]),
        .I1(status_completed_frames[4]),
        .I2(out[5]),
        .I3(status_completed_frames[5]),
        .I4(status_completed_frames[3]),
        .I5(out[3]),
        .O(owner_drained4_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained4_carry_i_4
       (.I0(out[0]),
        .I1(status_completed_frames[0]),
        .I2(out[1]),
        .I3(status_completed_frames[1]),
        .I4(status_completed_frames[2]),
        .I5(out[2]),
        .O(owner_drained4_carry_i_4_n_0));
  CARRY4 owner_drained5_carry
       (.CI(1'b0),
        .CO({owner_drained5_carry_n_0,owner_drained5_carry_n_1,owner_drained5_carry_n_2,owner_drained5_carry_n_3}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained5_carry_O_UNCONNECTED[3:0]),
        .S({owner_drained5_carry_i_1_n_0,owner_drained5_carry_i_2_n_0,owner_drained5_carry_i_3_n_0,owner_drained5_carry_i_4_n_0}));
  CARRY4 owner_drained5_carry__0
       (.CI(owner_drained5_carry_n_0),
        .CO({owner_drained5_carry__0_n_0,owner_drained5_carry__0_n_1,owner_drained5_carry__0_n_2,owner_drained5_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained5_carry__0_O_UNCONNECTED[3:0]),
        .S({owner_drained5_carry__0_i_1_n_0,owner_drained5_carry__0_i_2_n_0,owner_drained5_carry__0_i_3_n_0,owner_drained5_carry__0_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained5_carry__0_i_1
       (.I0(out[22]),
        .I1(packet_completed_frames[22]),
        .I2(out[23]),
        .I3(packet_completed_frames[23]),
        .I4(packet_completed_frames[21]),
        .I5(out[21]),
        .O(owner_drained5_carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained5_carry__0_i_2
       (.I0(out[18]),
        .I1(packet_completed_frames[18]),
        .I2(out[19]),
        .I3(packet_completed_frames[19]),
        .I4(packet_completed_frames[20]),
        .I5(out[20]),
        .O(owner_drained5_carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained5_carry__0_i_3
       (.I0(out[16]),
        .I1(packet_completed_frames[16]),
        .I2(out[17]),
        .I3(packet_completed_frames[17]),
        .I4(packet_completed_frames[15]),
        .I5(out[15]),
        .O(owner_drained5_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained5_carry__0_i_4
       (.I0(out[12]),
        .I1(packet_completed_frames[12]),
        .I2(out[13]),
        .I3(packet_completed_frames[13]),
        .I4(packet_completed_frames[14]),
        .I5(out[14]),
        .O(owner_drained5_carry__0_i_4_n_0));
  CARRY4 owner_drained5_carry__1
       (.CI(owner_drained5_carry__0_n_0),
        .CO({NLW_owner_drained5_carry__1_CO_UNCONNECTED[3],owner_drained5,owner_drained5_carry__1_n_2,owner_drained5_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained5_carry__1_O_UNCONNECTED[3:0]),
        .S({1'b0,owner_drained5_carry__1_i_1_n_0,owner_drained5_carry__1_i_2_n_0,owner_drained5_carry__1_i_3_n_0}));
  LUT4 #(
    .INIT(16'h9009)) 
    owner_drained5_carry__1_i_1
       (.I0(packet_completed_frames[31]),
        .I1(out[31]),
        .I2(packet_completed_frames[30]),
        .I3(out[30]),
        .O(owner_drained5_carry__1_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained5_carry__1_i_2
       (.I0(out[28]),
        .I1(packet_completed_frames[28]),
        .I2(out[29]),
        .I3(packet_completed_frames[29]),
        .I4(packet_completed_frames[27]),
        .I5(out[27]),
        .O(owner_drained5_carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained5_carry__1_i_3
       (.I0(out[24]),
        .I1(packet_completed_frames[24]),
        .I2(out[25]),
        .I3(packet_completed_frames[25]),
        .I4(packet_completed_frames[26]),
        .I5(out[26]),
        .O(owner_drained5_carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained5_carry_i_1
       (.I0(out[10]),
        .I1(packet_completed_frames[10]),
        .I2(out[11]),
        .I3(packet_completed_frames[11]),
        .I4(packet_completed_frames[9]),
        .I5(out[9]),
        .O(owner_drained5_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained5_carry_i_2
       (.I0(out[6]),
        .I1(packet_completed_frames[6]),
        .I2(out[7]),
        .I3(packet_completed_frames[7]),
        .I4(packet_completed_frames[8]),
        .I5(out[8]),
        .O(owner_drained5_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained5_carry_i_3
       (.I0(out[4]),
        .I1(packet_completed_frames[4]),
        .I2(out[5]),
        .I3(packet_completed_frames[5]),
        .I4(packet_completed_frames[3]),
        .I5(out[3]),
        .O(owner_drained5_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained5_carry_i_4
       (.I0(out[0]),
        .I1(packet_completed_frames[0]),
        .I2(out[1]),
        .I3(packet_completed_frames[1]),
        .I4(packet_completed_frames[2]),
        .I5(out[2]),
        .O(owner_drained5_carry_i_4_n_0));
  CARRY4 owner_drained6_carry
       (.CI(1'b0),
        .CO({owner_drained6_carry_n_0,owner_drained6_carry_n_1,owner_drained6_carry_n_2,owner_drained6_carry_n_3}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained6_carry_O_UNCONNECTED[3:0]),
        .S({owner_drained6_carry_i_1_n_0,owner_drained6_carry_i_2_n_0,owner_drained6_carry_i_3_n_0,owner_drained6_carry_i_4_n_0}));
  CARRY4 owner_drained6_carry__0
       (.CI(owner_drained6_carry_n_0),
        .CO({owner_drained6_carry__0_n_0,owner_drained6_carry__0_n_1,owner_drained6_carry__0_n_2,owner_drained6_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained6_carry__0_O_UNCONNECTED[3:0]),
        .S({owner_drained6_carry__0_i_1_n_0,owner_drained6_carry__0_i_2_n_0,owner_drained6_carry__0_i_3_n_0,owner_drained6_carry__0_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained6_carry__0_i_1
       (.I0(out[22]),
        .I1(rgb_completed_frames[22]),
        .I2(out[23]),
        .I3(rgb_completed_frames[23]),
        .I4(rgb_completed_frames[21]),
        .I5(out[21]),
        .O(owner_drained6_carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained6_carry__0_i_2
       (.I0(out[18]),
        .I1(rgb_completed_frames[18]),
        .I2(out[19]),
        .I3(rgb_completed_frames[19]),
        .I4(rgb_completed_frames[20]),
        .I5(out[20]),
        .O(owner_drained6_carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained6_carry__0_i_3
       (.I0(out[16]),
        .I1(rgb_completed_frames[16]),
        .I2(out[17]),
        .I3(rgb_completed_frames[17]),
        .I4(rgb_completed_frames[15]),
        .I5(out[15]),
        .O(owner_drained6_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained6_carry__0_i_4
       (.I0(out[12]),
        .I1(rgb_completed_frames[12]),
        .I2(out[13]),
        .I3(rgb_completed_frames[13]),
        .I4(rgb_completed_frames[14]),
        .I5(out[14]),
        .O(owner_drained6_carry__0_i_4_n_0));
  CARRY4 owner_drained6_carry__1
       (.CI(owner_drained6_carry__0_n_0),
        .CO({NLW_owner_drained6_carry__1_CO_UNCONNECTED[3],owner_drained6,owner_drained6_carry__1_n_2,owner_drained6_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained6_carry__1_O_UNCONNECTED[3:0]),
        .S({1'b0,owner_drained6_carry__1_i_1_n_0,owner_drained6_carry__1_i_2_n_0,owner_drained6_carry__1_i_3_n_0}));
  LUT4 #(
    .INIT(16'h9009)) 
    owner_drained6_carry__1_i_1
       (.I0(rgb_completed_frames[31]),
        .I1(out[31]),
        .I2(rgb_completed_frames[30]),
        .I3(out[30]),
        .O(owner_drained6_carry__1_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained6_carry__1_i_2
       (.I0(out[28]),
        .I1(rgb_completed_frames[28]),
        .I2(out[29]),
        .I3(rgb_completed_frames[29]),
        .I4(rgb_completed_frames[27]),
        .I5(out[27]),
        .O(owner_drained6_carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained6_carry__1_i_3
       (.I0(out[24]),
        .I1(rgb_completed_frames[24]),
        .I2(out[25]),
        .I3(rgb_completed_frames[25]),
        .I4(rgb_completed_frames[26]),
        .I5(out[26]),
        .O(owner_drained6_carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained6_carry_i_1
       (.I0(out[10]),
        .I1(rgb_completed_frames[10]),
        .I2(out[11]),
        .I3(rgb_completed_frames[11]),
        .I4(rgb_completed_frames[9]),
        .I5(out[9]),
        .O(owner_drained6_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained6_carry_i_2
       (.I0(out[6]),
        .I1(rgb_completed_frames[6]),
        .I2(out[7]),
        .I3(rgb_completed_frames[7]),
        .I4(rgb_completed_frames[8]),
        .I5(out[8]),
        .O(owner_drained6_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained6_carry_i_3
       (.I0(out[4]),
        .I1(rgb_completed_frames[4]),
        .I2(out[5]),
        .I3(rgb_completed_frames[5]),
        .I4(rgb_completed_frames[3]),
        .I5(out[3]),
        .O(owner_drained6_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained6_carry_i_4
       (.I0(out[0]),
        .I1(rgb_completed_frames[0]),
        .I2(out[1]),
        .I3(rgb_completed_frames[1]),
        .I4(rgb_completed_frames[2]),
        .I5(out[2]),
        .O(owner_drained6_carry_i_4_n_0));
  CARRY4 owner_drained7_carry
       (.CI(1'b0),
        .CO({owner_drained7_carry_n_0,owner_drained7_carry_n_1,owner_drained7_carry_n_2,owner_drained7_carry_n_3}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained7_carry_O_UNCONNECTED[3:0]),
        .S({owner_drained7_carry_i_1_n_0,owner_drained7_carry_i_2_n_0,owner_drained7_carry_i_3_n_0,owner_drained7_carry_i_4_n_0}));
  CARRY4 owner_drained7_carry__0
       (.CI(owner_drained7_carry_n_0),
        .CO({owner_drained7_carry__0_n_0,owner_drained7_carry__0_n_1,owner_drained7_carry__0_n_2,owner_drained7_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained7_carry__0_O_UNCONNECTED[3:0]),
        .S({owner_drained7_carry__0_i_1_n_0,owner_drained7_carry__0_i_2_n_0,owner_drained7_carry__0_i_3_n_0,owner_drained7_carry__0_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained7_carry__0_i_1
       (.I0(\released_frames_reg[31]_0 [22]),
        .I1(out[22]),
        .I2(\released_frames_reg[31]_0 [23]),
        .I3(out[23]),
        .I4(out[21]),
        .I5(\released_frames_reg[31]_0 [21]),
        .O(owner_drained7_carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained7_carry__0_i_2
       (.I0(\released_frames_reg[31]_0 [18]),
        .I1(out[18]),
        .I2(\released_frames_reg[31]_0 [19]),
        .I3(out[19]),
        .I4(out[20]),
        .I5(\released_frames_reg[31]_0 [20]),
        .O(owner_drained7_carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained7_carry__0_i_3
       (.I0(\released_frames_reg[31]_0 [16]),
        .I1(out[16]),
        .I2(\released_frames_reg[31]_0 [17]),
        .I3(out[17]),
        .I4(out[15]),
        .I5(\released_frames_reg[31]_0 [15]),
        .O(owner_drained7_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained7_carry__0_i_4
       (.I0(\released_frames_reg[31]_0 [12]),
        .I1(out[12]),
        .I2(\released_frames_reg[31]_0 [13]),
        .I3(out[13]),
        .I4(out[14]),
        .I5(\released_frames_reg[31]_0 [14]),
        .O(owner_drained7_carry__0_i_4_n_0));
  CARRY4 owner_drained7_carry__1
       (.CI(owner_drained7_carry__0_n_0),
        .CO({NLW_owner_drained7_carry__1_CO_UNCONNECTED[3],owner_drained7,owner_drained7_carry__1_n_2,owner_drained7_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained7_carry__1_O_UNCONNECTED[3:0]),
        .S({1'b0,owner_drained7_carry__1_i_1_n_0,owner_drained7_carry__1_i_2_n_0,owner_drained7_carry__1_i_3_n_0}));
  LUT4 #(
    .INIT(16'h9009)) 
    owner_drained7_carry__1_i_1
       (.I0(\released_frames_reg[31]_0 [31]),
        .I1(out[31]),
        .I2(out[30]),
        .I3(\released_frames_reg[31]_0 [30]),
        .O(owner_drained7_carry__1_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained7_carry__1_i_2
       (.I0(\released_frames_reg[31]_0 [28]),
        .I1(out[28]),
        .I2(\released_frames_reg[31]_0 [29]),
        .I3(out[29]),
        .I4(out[27]),
        .I5(\released_frames_reg[31]_0 [27]),
        .O(owner_drained7_carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained7_carry__1_i_3
       (.I0(\released_frames_reg[31]_0 [24]),
        .I1(out[24]),
        .I2(\released_frames_reg[31]_0 [25]),
        .I3(out[25]),
        .I4(out[26]),
        .I5(\released_frames_reg[31]_0 [26]),
        .O(owner_drained7_carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained7_carry_i_1
       (.I0(\released_frames_reg[31]_0 [10]),
        .I1(out[10]),
        .I2(\released_frames_reg[31]_0 [11]),
        .I3(out[11]),
        .I4(out[9]),
        .I5(\released_frames_reg[31]_0 [9]),
        .O(owner_drained7_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained7_carry_i_2
       (.I0(\released_frames_reg[31]_0 [6]),
        .I1(out[6]),
        .I2(\released_frames_reg[31]_0 [7]),
        .I3(out[7]),
        .I4(out[8]),
        .I5(\released_frames_reg[31]_0 [8]),
        .O(owner_drained7_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained7_carry_i_3
       (.I0(\released_frames_reg[31]_0 [4]),
        .I1(out[4]),
        .I2(\released_frames_reg[31]_0 [5]),
        .I3(out[5]),
        .I4(out[3]),
        .I5(\released_frames_reg[31]_0 [3]),
        .O(owner_drained7_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained7_carry_i_4
       (.I0(\released_frames_reg[31]_0 [0]),
        .I1(out[0]),
        .I2(\released_frames_reg[31]_0 [1]),
        .I3(out[1]),
        .I4(out[2]),
        .I5(\released_frames_reg[31]_0 [2]),
        .O(owner_drained7_carry_i_4_n_0));
  CARRY4 owner_drained8_carry
       (.CI(1'b0),
        .CO({owner_drained8_carry_n_0,owner_drained8_carry_n_1,owner_drained8_carry_n_2,owner_drained8_carry_n_3}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained8_carry_O_UNCONNECTED[3:0]),
        .S({owner_drained8_carry_i_1_n_0,owner_drained8_carry_i_2_n_0,owner_drained8_carry_i_3_n_0,owner_drained8_carry_i_4_n_0}));
  CARRY4 owner_drained8_carry__0
       (.CI(owner_drained8_carry_n_0),
        .CO({owner_drained8_carry__0_n_0,owner_drained8_carry__0_n_1,owner_drained8_carry__0_n_2,owner_drained8_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained8_carry__0_O_UNCONNECTED[3:0]),
        .S({owner_drained8_carry__0_i_1_n_0,owner_drained8_carry__0_i_2_n_0,owner_drained8_carry__0_i_3_n_0,owner_drained8_carry__0_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained8_carry__0_i_1
       (.I0(out[23]),
        .I1(Q[14]),
        .I2(out[22]),
        .I3(Q[13]),
        .I4(Q[12]),
        .I5(out[21]),
        .O(owner_drained8_carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained8_carry__0_i_2
       (.I0(out[20]),
        .I1(\final_frame_count_reg_n_0_[20] ),
        .I2(out[18]),
        .I3(\final_frame_count_reg_n_0_[18] ),
        .I4(\final_frame_count_reg_n_0_[19] ),
        .I5(out[19]),
        .O(owner_drained8_carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained8_carry__0_i_3
       (.I0(out[17]),
        .I1(Q[11]),
        .I2(out[16]),
        .I3(Q[10]),
        .I4(Q[9]),
        .I5(out[15]),
        .O(owner_drained8_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained8_carry__0_i_4
       (.I0(out[14]),
        .I1(Q[8]),
        .I2(out[13]),
        .I3(Q[7]),
        .I4(Q[6]),
        .I5(out[12]),
        .O(owner_drained8_carry__0_i_4_n_0));
  CARRY4 owner_drained8_carry__1
       (.CI(owner_drained8_carry__0_n_0),
        .CO({NLW_owner_drained8_carry__1_CO_UNCONNECTED[3],owner_drained8,owner_drained8_carry__1_n_2,owner_drained8_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_owner_drained8_carry__1_O_UNCONNECTED[3:0]),
        .S({1'b0,owner_drained8_carry__1_i_1_n_0,owner_drained8_carry__1_i_2_n_0,owner_drained8_carry__1_i_3_n_0}));
  LUT4 #(
    .INIT(16'h9009)) 
    owner_drained8_carry__1_i_1
       (.I0(\final_frame_count_reg_n_0_[30] ),
        .I1(out[30]),
        .I2(\final_frame_count_reg_n_0_[31] ),
        .I3(out[31]),
        .O(owner_drained8_carry__1_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained8_carry__1_i_2
       (.I0(out[29]),
        .I1(\final_frame_count_reg_n_0_[29] ),
        .I2(out[27]),
        .I3(\final_frame_count_reg_n_0_[27] ),
        .I4(\final_frame_count_reg_n_0_[28] ),
        .I5(out[28]),
        .O(owner_drained8_carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained8_carry__1_i_3
       (.I0(out[26]),
        .I1(\final_frame_count_reg_n_0_[26] ),
        .I2(out[25]),
        .I3(\final_frame_count_reg_n_0_[25] ),
        .I4(\final_frame_count_reg_n_0_[24] ),
        .I5(out[24]),
        .O(owner_drained8_carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained8_carry_i_1
       (.I0(out[11]),
        .I1(\final_frame_count_reg_n_0_[11] ),
        .I2(out[10]),
        .I3(\final_frame_count_reg_n_0_[10] ),
        .I4(\final_frame_count_reg_n_0_[9] ),
        .I5(out[9]),
        .O(owner_drained8_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained8_carry_i_2
       (.I0(out[8]),
        .I1(Q[5]),
        .I2(out[6]),
        .I3(Q[3]),
        .I4(Q[4]),
        .I5(out[7]),
        .O(owner_drained8_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained8_carry_i_3
       (.I0(out[5]),
        .I1(\final_frame_count_reg_n_0_[5] ),
        .I2(out[3]),
        .I3(\final_frame_count_reg_n_0_[3] ),
        .I4(\final_frame_count_reg_n_0_[4] ),
        .I5(out[4]),
        .O(owner_drained8_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    owner_drained8_carry_i_4
       (.I0(out[2]),
        .I1(Q[2]),
        .I2(out[0]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(out[1]),
        .O(owner_drained8_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h0001)) 
    owner_drained_INST_0
       (.I0(cpu_available_INST_0_i_1_n_0),
        .I1(cpu_release),
        .I2(owner_drained_INST_0_i_1_n_0),
        .I3(owner_drained_INST_0_i_2_n_0),
        .O(owner_drained));
  LUT6 #(
    .INIT(64'hFFFF7FFFFFFFFFFF)) 
    owner_drained_INST_0_i_1
       (.I0(control_capture_aresetn),
        .I1(\epoch_reg[31]_0 ),
        .I2(common_aresetn),
        .I3(owner_drained8),
        .I4(cpu_held_reg_0),
        .I5(owner_drained5),
        .O(owner_drained_INST_0_i_1_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF7FFF)) 
    owner_drained_INST_0_i_2
       (.I0(owner_drained4),
        .I1(closure_held_reg_0),
        .I2(owner_drained7),
        .I3(owner_drained6),
        .I4(cpu_claim),
        .I5(frame_credit_request),
        .O(owner_drained_INST_0_i_2_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFF70)) 
    owner_fault_INST_0
       (.I0(owner_fault_INST_0_i_1_n_0),
        .I1(owner_fault_INST_0_i_2_n_0),
        .I2(configuration_locked),
        .I3(owner_fault_INST_0_i_3_n_0),
        .I4(owner_fault_INST_0_i_4_n_0),
        .I5(upstream_fault0),
        .O(configuration_locked_reg_0));
  LUT6 #(
    .INIT(64'h0333333373333333)) 
    owner_fault_INST_0_i_1
       (.I0(closure_bad2),
        .I1(closure_held_reg_0),
        .I2(budget_checked),
        .I3(closure_held),
        .I4(dest_arst),
        .I5(closure_bad1),
        .O(owner_fault_INST_0_i_1_n_0));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    owner_fault_INST_0_i_2
       (.I0(counters_bad1),
        .I1(counters_bad2),
        .I2(counters_bad3),
        .I3(counters_bad4),
        .I4(counters_bad54_in),
        .I5(counters_bad5),
        .O(owner_fault_INST_0_i_2_n_0));
  LUT5 #(
    .INIT(32'hA8AAAAAA)) 
    owner_fault_INST_0_i_3
       (.I0(configuration_locked),
        .I1(configuration_bad2_carry__1_n_1),
        .I2(configuration_bad1),
        .I3(control_capture_aresetn),
        .I4(\epoch_reg[31]_0 ),
        .O(owner_fault_INST_0_i_3_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    owner_fault_INST_0_i_4
       (.I0(owner_fault_causes[1]),
        .I1(owner_fault_causes[2]),
        .I2(owner_fault_causes[0]),
        .I3(owner_fault_causes[3]),
        .O(owner_fault_INST_0_i_4_n_0));
  FDRE \previous_packet_reg[0] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[0]),
        .Q(previous_packet[0]),
        .R(clear));
  FDRE \previous_packet_reg[10] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[10]),
        .Q(previous_packet[10]),
        .R(clear));
  FDRE \previous_packet_reg[11] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[11]),
        .Q(previous_packet[11]),
        .R(clear));
  FDRE \previous_packet_reg[12] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[12]),
        .Q(previous_packet[12]),
        .R(clear));
  FDRE \previous_packet_reg[13] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[13]),
        .Q(previous_packet[13]),
        .R(clear));
  FDRE \previous_packet_reg[14] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[14]),
        .Q(previous_packet[14]),
        .R(clear));
  FDRE \previous_packet_reg[15] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[15]),
        .Q(previous_packet[15]),
        .R(clear));
  FDRE \previous_packet_reg[16] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[16]),
        .Q(previous_packet[16]),
        .R(clear));
  FDRE \previous_packet_reg[17] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[17]),
        .Q(previous_packet[17]),
        .R(clear));
  FDRE \previous_packet_reg[18] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[18]),
        .Q(previous_packet[18]),
        .R(clear));
  FDRE \previous_packet_reg[19] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[19]),
        .Q(previous_packet[19]),
        .R(clear));
  FDRE \previous_packet_reg[1] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[1]),
        .Q(previous_packet[1]),
        .R(clear));
  FDRE \previous_packet_reg[20] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[20]),
        .Q(previous_packet[20]),
        .R(clear));
  FDRE \previous_packet_reg[21] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[21]),
        .Q(previous_packet[21]),
        .R(clear));
  FDRE \previous_packet_reg[22] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[22]),
        .Q(previous_packet[22]),
        .R(clear));
  FDRE \previous_packet_reg[23] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[23]),
        .Q(previous_packet[23]),
        .R(clear));
  FDRE \previous_packet_reg[24] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[24]),
        .Q(previous_packet[24]),
        .R(clear));
  FDRE \previous_packet_reg[25] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[25]),
        .Q(previous_packet[25]),
        .R(clear));
  FDRE \previous_packet_reg[26] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[26]),
        .Q(previous_packet[26]),
        .R(clear));
  FDRE \previous_packet_reg[27] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[27]),
        .Q(previous_packet[27]),
        .R(clear));
  FDRE \previous_packet_reg[28] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[28]),
        .Q(previous_packet[28]),
        .R(clear));
  FDRE \previous_packet_reg[29] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[29]),
        .Q(previous_packet[29]),
        .R(clear));
  FDRE \previous_packet_reg[2] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[2]),
        .Q(previous_packet[2]),
        .R(clear));
  FDRE \previous_packet_reg[30] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[30]),
        .Q(previous_packet[30]),
        .R(clear));
  FDRE \previous_packet_reg[31] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[31]),
        .Q(previous_packet[31]),
        .R(clear));
  FDRE \previous_packet_reg[3] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[3]),
        .Q(previous_packet[3]),
        .R(clear));
  FDRE \previous_packet_reg[4] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[4]),
        .Q(previous_packet[4]),
        .R(clear));
  FDRE \previous_packet_reg[5] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[5]),
        .Q(previous_packet[5]),
        .R(clear));
  FDRE \previous_packet_reg[6] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[6]),
        .Q(previous_packet[6]),
        .R(clear));
  FDRE \previous_packet_reg[7] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[7]),
        .Q(previous_packet[7]),
        .R(clear));
  FDRE \previous_packet_reg[8] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[8]),
        .Q(previous_packet[8]),
        .R(clear));
  FDRE \previous_packet_reg[9] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(packet_completed_frames[9]),
        .Q(previous_packet[9]),
        .R(clear));
  FDRE \previous_rgb_reg[0] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[0]),
        .Q(previous_rgb[0]),
        .R(clear));
  FDRE \previous_rgb_reg[10] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[10]),
        .Q(previous_rgb[10]),
        .R(clear));
  FDRE \previous_rgb_reg[11] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[11]),
        .Q(previous_rgb[11]),
        .R(clear));
  FDRE \previous_rgb_reg[12] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[12]),
        .Q(previous_rgb[12]),
        .R(clear));
  FDRE \previous_rgb_reg[13] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[13]),
        .Q(previous_rgb[13]),
        .R(clear));
  FDRE \previous_rgb_reg[14] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[14]),
        .Q(previous_rgb[14]),
        .R(clear));
  FDRE \previous_rgb_reg[15] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[15]),
        .Q(previous_rgb[15]),
        .R(clear));
  FDRE \previous_rgb_reg[16] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[16]),
        .Q(previous_rgb[16]),
        .R(clear));
  FDRE \previous_rgb_reg[17] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[17]),
        .Q(previous_rgb[17]),
        .R(clear));
  FDRE \previous_rgb_reg[18] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[18]),
        .Q(previous_rgb[18]),
        .R(clear));
  FDRE \previous_rgb_reg[19] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[19]),
        .Q(previous_rgb[19]),
        .R(clear));
  FDRE \previous_rgb_reg[1] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[1]),
        .Q(previous_rgb[1]),
        .R(clear));
  FDRE \previous_rgb_reg[20] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[20]),
        .Q(previous_rgb[20]),
        .R(clear));
  FDRE \previous_rgb_reg[21] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[21]),
        .Q(previous_rgb[21]),
        .R(clear));
  FDRE \previous_rgb_reg[22] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[22]),
        .Q(previous_rgb[22]),
        .R(clear));
  FDRE \previous_rgb_reg[23] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[23]),
        .Q(previous_rgb[23]),
        .R(clear));
  FDRE \previous_rgb_reg[24] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[24]),
        .Q(previous_rgb[24]),
        .R(clear));
  FDRE \previous_rgb_reg[25] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[25]),
        .Q(previous_rgb[25]),
        .R(clear));
  FDRE \previous_rgb_reg[26] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[26]),
        .Q(previous_rgb[26]),
        .R(clear));
  FDRE \previous_rgb_reg[27] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[27]),
        .Q(previous_rgb[27]),
        .R(clear));
  FDRE \previous_rgb_reg[28] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[28]),
        .Q(previous_rgb[28]),
        .R(clear));
  FDRE \previous_rgb_reg[29] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[29]),
        .Q(previous_rgb[29]),
        .R(clear));
  FDRE \previous_rgb_reg[2] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[2]),
        .Q(previous_rgb[2]),
        .R(clear));
  FDRE \previous_rgb_reg[30] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[30]),
        .Q(previous_rgb[30]),
        .R(clear));
  FDRE \previous_rgb_reg[31] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[31]),
        .Q(previous_rgb[31]),
        .R(clear));
  FDRE \previous_rgb_reg[3] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[3]),
        .Q(previous_rgb[3]),
        .R(clear));
  FDRE \previous_rgb_reg[4] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[4]),
        .Q(previous_rgb[4]),
        .R(clear));
  FDRE \previous_rgb_reg[5] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[5]),
        .Q(previous_rgb[5]),
        .R(clear));
  FDRE \previous_rgb_reg[6] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[6]),
        .Q(previous_rgb[6]),
        .R(clear));
  FDRE \previous_rgb_reg[7] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[7]),
        .Q(previous_rgb[7]),
        .R(clear));
  FDRE \previous_rgb_reg[8] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[8]),
        .Q(previous_rgb[8]),
        .R(clear));
  FDRE \previous_rgb_reg[9] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(rgb_completed_frames[9]),
        .Q(previous_rgb[9]),
        .R(clear));
  FDRE \previous_status_reg[0] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[0]),
        .Q(previous_status[0]),
        .R(clear));
  FDRE \previous_status_reg[10] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[10]),
        .Q(previous_status[10]),
        .R(clear));
  FDRE \previous_status_reg[11] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[11]),
        .Q(previous_status[11]),
        .R(clear));
  FDRE \previous_status_reg[12] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[12]),
        .Q(previous_status[12]),
        .R(clear));
  FDRE \previous_status_reg[13] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[13]),
        .Q(previous_status[13]),
        .R(clear));
  FDRE \previous_status_reg[14] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[14]),
        .Q(previous_status[14]),
        .R(clear));
  FDRE \previous_status_reg[15] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[15]),
        .Q(previous_status[15]),
        .R(clear));
  FDRE \previous_status_reg[16] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[16]),
        .Q(previous_status[16]),
        .R(clear));
  FDRE \previous_status_reg[17] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[17]),
        .Q(previous_status[17]),
        .R(clear));
  FDRE \previous_status_reg[18] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[18]),
        .Q(previous_status[18]),
        .R(clear));
  FDRE \previous_status_reg[19] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[19]),
        .Q(previous_status[19]),
        .R(clear));
  FDRE \previous_status_reg[1] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[1]),
        .Q(previous_status[1]),
        .R(clear));
  FDRE \previous_status_reg[20] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[20]),
        .Q(previous_status[20]),
        .R(clear));
  FDRE \previous_status_reg[21] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[21]),
        .Q(previous_status[21]),
        .R(clear));
  FDRE \previous_status_reg[22] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[22]),
        .Q(previous_status[22]),
        .R(clear));
  FDRE \previous_status_reg[23] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[23]),
        .Q(previous_status[23]),
        .R(clear));
  FDRE \previous_status_reg[24] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[24]),
        .Q(previous_status[24]),
        .R(clear));
  FDRE \previous_status_reg[25] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[25]),
        .Q(previous_status[25]),
        .R(clear));
  FDRE \previous_status_reg[26] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[26]),
        .Q(previous_status[26]),
        .R(clear));
  FDRE \previous_status_reg[27] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[27]),
        .Q(previous_status[27]),
        .R(clear));
  FDRE \previous_status_reg[28] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[28]),
        .Q(previous_status[28]),
        .R(clear));
  FDRE \previous_status_reg[29] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[29]),
        .Q(previous_status[29]),
        .R(clear));
  FDRE \previous_status_reg[2] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[2]),
        .Q(previous_status[2]),
        .R(clear));
  FDRE \previous_status_reg[30] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[30]),
        .Q(previous_status[30]),
        .R(clear));
  FDRE \previous_status_reg[31] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[31]),
        .Q(previous_status[31]),
        .R(clear));
  FDRE \previous_status_reg[3] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[3]),
        .Q(previous_status[3]),
        .R(clear));
  FDRE \previous_status_reg[4] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[4]),
        .Q(previous_status[4]),
        .R(clear));
  FDRE \previous_status_reg[5] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[5]),
        .Q(previous_status[5]),
        .R(clear));
  FDRE \previous_status_reg[6] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[6]),
        .Q(previous_status[6]),
        .R(clear));
  FDRE \previous_status_reg[7] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[7]),
        .Q(previous_status[7]),
        .R(clear));
  FDRE \previous_status_reg[8] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[8]),
        .Q(previous_status[8]),
        .R(clear));
  FDRE \previous_status_reg[9] 
       (.C(aclk),
        .CE(configuration_locked),
        .D(status_completed_frames[9]),
        .Q(previous_status[9]),
        .R(clear));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \producer_slot[0]_i_1 
       (.I0(grant_slot[1]),
        .I1(grant_slot[0]),
        .O(\producer_slot[0]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \producer_slot[1]_i_1 
       (.I0(common_aresetn),
        .O(clear));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \producer_slot[1]_i_2 
       (.I0(frame_credit_request),
        .I1(frame_credit_ready_INST_0_i_1_n_0),
        .I2(frame_credit_ready_INST_0_i_2_n_0),
        .I3(\granted_frames_reg[31]_0 ),
        .I4(frame_credit_ready_INST_0_i_4_n_0),
        .I5(frame_credit_ready_INST_0_i_5_n_0),
        .O(producer_slot));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \producer_slot[1]_i_3 
       (.I0(grant_slot[1]),
        .I1(grant_slot[0]),
        .O(\producer_slot[1]_i_3_n_0 ));
  FDRE \producer_slot_reg[0] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\producer_slot[0]_i_1_n_0 ),
        .Q(grant_slot[0]),
        .R(clear));
  FDRE \producer_slot_reg[1] 
       (.C(aclk),
        .CE(producer_slot),
        .D(\producer_slot[1]_i_3_n_0 ),
        .Q(grant_slot[1]),
        .R(clear));
  LUT6 #(
    .INIT(64'h1000000000000000)) 
    release_accepted_i_1
       (.I0(cpu_available_INST_0_i_1_n_0),
        .I1(cpu_claim),
        .I2(cpu_held_reg_0),
        .I3(token_matches0),
        .I4(token_matches00_out),
        .I5(cpu_release),
        .O(consumer_slot));
  FDRE release_accepted_reg
       (.C(aclk),
        .CE(1'b1),
        .D(consumer_slot),
        .Q(release_accepted),
        .R(clear));
  LUT1 #(
    .INIT(2'h1)) 
    \released_frames[3]_i_2 
       (.I0(\released_frames_reg[31]_0 [0]),
        .O(\released_frames[3]_i_2_n_0 ));
  FDRE \released_frames_reg[0] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[3]_i_1_n_7 ),
        .Q(\released_frames_reg[31]_0 [0]),
        .R(clear));
  FDRE \released_frames_reg[10] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[11]_i_1_n_5 ),
        .Q(\released_frames_reg[31]_0 [10]),
        .R(clear));
  FDRE \released_frames_reg[11] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[11]_i_1_n_4 ),
        .Q(\released_frames_reg[31]_0 [11]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \released_frames_reg[11]_i_1 
       (.CI(\released_frames_reg[7]_i_1_n_0 ),
        .CO({\released_frames_reg[11]_i_1_n_0 ,\released_frames_reg[11]_i_1_n_1 ,\released_frames_reg[11]_i_1_n_2 ,\released_frames_reg[11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\released_frames_reg[11]_i_1_n_4 ,\released_frames_reg[11]_i_1_n_5 ,\released_frames_reg[11]_i_1_n_6 ,\released_frames_reg[11]_i_1_n_7 }),
        .S(\released_frames_reg[31]_0 [11:8]));
  FDRE \released_frames_reg[12] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[15]_i_1_n_7 ),
        .Q(\released_frames_reg[31]_0 [12]),
        .R(clear));
  FDRE \released_frames_reg[13] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[15]_i_1_n_6 ),
        .Q(\released_frames_reg[31]_0 [13]),
        .R(clear));
  FDRE \released_frames_reg[14] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[15]_i_1_n_5 ),
        .Q(\released_frames_reg[31]_0 [14]),
        .R(clear));
  FDRE \released_frames_reg[15] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[15]_i_1_n_4 ),
        .Q(\released_frames_reg[31]_0 [15]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \released_frames_reg[15]_i_1 
       (.CI(\released_frames_reg[11]_i_1_n_0 ),
        .CO({\released_frames_reg[15]_i_1_n_0 ,\released_frames_reg[15]_i_1_n_1 ,\released_frames_reg[15]_i_1_n_2 ,\released_frames_reg[15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\released_frames_reg[15]_i_1_n_4 ,\released_frames_reg[15]_i_1_n_5 ,\released_frames_reg[15]_i_1_n_6 ,\released_frames_reg[15]_i_1_n_7 }),
        .S(\released_frames_reg[31]_0 [15:12]));
  FDRE \released_frames_reg[16] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[19]_i_1_n_7 ),
        .Q(\released_frames_reg[31]_0 [16]),
        .R(clear));
  FDRE \released_frames_reg[17] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[19]_i_1_n_6 ),
        .Q(\released_frames_reg[31]_0 [17]),
        .R(clear));
  FDRE \released_frames_reg[18] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[19]_i_1_n_5 ),
        .Q(\released_frames_reg[31]_0 [18]),
        .R(clear));
  FDRE \released_frames_reg[19] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[19]_i_1_n_4 ),
        .Q(\released_frames_reg[31]_0 [19]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \released_frames_reg[19]_i_1 
       (.CI(\released_frames_reg[15]_i_1_n_0 ),
        .CO({\released_frames_reg[19]_i_1_n_0 ,\released_frames_reg[19]_i_1_n_1 ,\released_frames_reg[19]_i_1_n_2 ,\released_frames_reg[19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\released_frames_reg[19]_i_1_n_4 ,\released_frames_reg[19]_i_1_n_5 ,\released_frames_reg[19]_i_1_n_6 ,\released_frames_reg[19]_i_1_n_7 }),
        .S(\released_frames_reg[31]_0 [19:16]));
  FDRE \released_frames_reg[1] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[3]_i_1_n_6 ),
        .Q(\released_frames_reg[31]_0 [1]),
        .R(clear));
  FDRE \released_frames_reg[20] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[23]_i_1_n_7 ),
        .Q(\released_frames_reg[31]_0 [20]),
        .R(clear));
  FDRE \released_frames_reg[21] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[23]_i_1_n_6 ),
        .Q(\released_frames_reg[31]_0 [21]),
        .R(clear));
  FDRE \released_frames_reg[22] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[23]_i_1_n_5 ),
        .Q(\released_frames_reg[31]_0 [22]),
        .R(clear));
  FDRE \released_frames_reg[23] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[23]_i_1_n_4 ),
        .Q(\released_frames_reg[31]_0 [23]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \released_frames_reg[23]_i_1 
       (.CI(\released_frames_reg[19]_i_1_n_0 ),
        .CO({\released_frames_reg[23]_i_1_n_0 ,\released_frames_reg[23]_i_1_n_1 ,\released_frames_reg[23]_i_1_n_2 ,\released_frames_reg[23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\released_frames_reg[23]_i_1_n_4 ,\released_frames_reg[23]_i_1_n_5 ,\released_frames_reg[23]_i_1_n_6 ,\released_frames_reg[23]_i_1_n_7 }),
        .S(\released_frames_reg[31]_0 [23:20]));
  FDRE \released_frames_reg[24] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[27]_i_1_n_7 ),
        .Q(\released_frames_reg[31]_0 [24]),
        .R(clear));
  FDRE \released_frames_reg[25] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[27]_i_1_n_6 ),
        .Q(\released_frames_reg[31]_0 [25]),
        .R(clear));
  FDRE \released_frames_reg[26] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[27]_i_1_n_5 ),
        .Q(\released_frames_reg[31]_0 [26]),
        .R(clear));
  FDRE \released_frames_reg[27] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[27]_i_1_n_4 ),
        .Q(\released_frames_reg[31]_0 [27]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \released_frames_reg[27]_i_1 
       (.CI(\released_frames_reg[23]_i_1_n_0 ),
        .CO({\released_frames_reg[27]_i_1_n_0 ,\released_frames_reg[27]_i_1_n_1 ,\released_frames_reg[27]_i_1_n_2 ,\released_frames_reg[27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\released_frames_reg[27]_i_1_n_4 ,\released_frames_reg[27]_i_1_n_5 ,\released_frames_reg[27]_i_1_n_6 ,\released_frames_reg[27]_i_1_n_7 }),
        .S(\released_frames_reg[31]_0 [27:24]));
  FDRE \released_frames_reg[28] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[31]_i_1_n_7 ),
        .Q(\released_frames_reg[31]_0 [28]),
        .R(clear));
  FDRE \released_frames_reg[29] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[31]_i_1_n_6 ),
        .Q(\released_frames_reg[31]_0 [29]),
        .R(clear));
  FDRE \released_frames_reg[2] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[3]_i_1_n_5 ),
        .Q(\released_frames_reg[31]_0 [2]),
        .R(clear));
  FDRE \released_frames_reg[30] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[31]_i_1_n_5 ),
        .Q(\released_frames_reg[31]_0 [30]),
        .R(clear));
  FDRE \released_frames_reg[31] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[31]_i_1_n_4 ),
        .Q(\released_frames_reg[31]_0 [31]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \released_frames_reg[31]_i_1 
       (.CI(\released_frames_reg[27]_i_1_n_0 ),
        .CO({\NLW_released_frames_reg[31]_i_1_CO_UNCONNECTED [3],\released_frames_reg[31]_i_1_n_1 ,\released_frames_reg[31]_i_1_n_2 ,\released_frames_reg[31]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\released_frames_reg[31]_i_1_n_4 ,\released_frames_reg[31]_i_1_n_5 ,\released_frames_reg[31]_i_1_n_6 ,\released_frames_reg[31]_i_1_n_7 }),
        .S(\released_frames_reg[31]_0 [31:28]));
  FDRE \released_frames_reg[3] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[3]_i_1_n_4 ),
        .Q(\released_frames_reg[31]_0 [3]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \released_frames_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\released_frames_reg[3]_i_1_n_0 ,\released_frames_reg[3]_i_1_n_1 ,\released_frames_reg[3]_i_1_n_2 ,\released_frames_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\released_frames_reg[3]_i_1_n_4 ,\released_frames_reg[3]_i_1_n_5 ,\released_frames_reg[3]_i_1_n_6 ,\released_frames_reg[3]_i_1_n_7 }),
        .S({\released_frames_reg[31]_0 [3:1],\released_frames[3]_i_2_n_0 }));
  FDRE \released_frames_reg[4] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[7]_i_1_n_7 ),
        .Q(\released_frames_reg[31]_0 [4]),
        .R(clear));
  FDRE \released_frames_reg[5] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[7]_i_1_n_6 ),
        .Q(\released_frames_reg[31]_0 [5]),
        .R(clear));
  FDRE \released_frames_reg[6] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[7]_i_1_n_5 ),
        .Q(\released_frames_reg[31]_0 [6]),
        .R(clear));
  FDRE \released_frames_reg[7] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[7]_i_1_n_4 ),
        .Q(\released_frames_reg[31]_0 [7]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \released_frames_reg[7]_i_1 
       (.CI(\released_frames_reg[3]_i_1_n_0 ),
        .CO({\released_frames_reg[7]_i_1_n_0 ,\released_frames_reg[7]_i_1_n_1 ,\released_frames_reg[7]_i_1_n_2 ,\released_frames_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\released_frames_reg[7]_i_1_n_4 ,\released_frames_reg[7]_i_1_n_5 ,\released_frames_reg[7]_i_1_n_6 ,\released_frames_reg[7]_i_1_n_7 }),
        .S(\released_frames_reg[31]_0 [7:4]));
  FDRE \released_frames_reg[8] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[11]_i_1_n_7 ),
        .Q(\released_frames_reg[31]_0 [8]),
        .R(clear));
  FDRE \released_frames_reg[9] 
       (.C(aclk),
        .CE(consumer_slot),
        .D(\released_frames_reg[11]_i_1_n_6 ),
        .Q(\released_frames_reg[31]_0 [9]),
        .R(clear));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    request_close_i_1
       (.I0(control_barrier_request),
        .I1(control_abort_requested),
        .I2(configuration_locked_reg_0),
        .O(request_close0));
  LUT6 #(
    .INIT(64'h0100000000000000)) 
    request_open_i_1
       (.I0(control_barrier_request),
        .I1(control_abort_requested),
        .I2(configuration_locked_reg_0),
        .I3(control_capture_aresetn),
        .I4(\epoch_reg[31]_0 ),
        .I5(control_armed),
        .O(request_open0));
  CARRY4 token_matches0_carry
       (.CI(1'b0),
        .CO({token_matches0_carry_n_0,token_matches0_carry_n_1,token_matches0_carry_n_2,token_matches0_carry_n_3}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_token_matches0_carry_O_UNCONNECTED[3:0]),
        .S({token_matches0_carry_i_1_n_0,token_matches0_carry_i_2_n_0,token_matches0_carry_i_3_n_0,token_matches0_carry_i_4_n_0}));
  CARRY4 token_matches0_carry__0
       (.CI(token_matches0_carry_n_0),
        .CO({token_matches0_carry__0_n_0,token_matches0_carry__0_n_1,token_matches0_carry__0_n_2,token_matches0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_token_matches0_carry__0_O_UNCONNECTED[3:0]),
        .S({token_matches0_carry__0_i_1_n_0,token_matches0_carry__0_i_2_n_0,token_matches0_carry__0_i_3_n_0,token_matches0_carry__0_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    token_matches0_carry__0_i_1
       (.I0(cpu_epoch[23]),
        .I1(available_epoch[23]),
        .I2(cpu_epoch[21]),
        .I3(available_epoch[21]),
        .I4(available_epoch[22]),
        .I5(cpu_epoch[22]),
        .O(token_matches0_carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    token_matches0_carry__0_i_2
       (.I0(cpu_epoch[20]),
        .I1(available_epoch[20]),
        .I2(cpu_epoch[18]),
        .I3(available_epoch[18]),
        .I4(available_epoch[19]),
        .I5(cpu_epoch[19]),
        .O(token_matches0_carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    token_matches0_carry__0_i_3
       (.I0(cpu_epoch[17]),
        .I1(available_epoch[17]),
        .I2(cpu_epoch[16]),
        .I3(available_epoch[16]),
        .I4(available_epoch[15]),
        .I5(cpu_epoch[15]),
        .O(token_matches0_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    token_matches0_carry__0_i_4
       (.I0(cpu_epoch[14]),
        .I1(available_epoch[14]),
        .I2(cpu_epoch[13]),
        .I3(available_epoch[13]),
        .I4(available_epoch[12]),
        .I5(cpu_epoch[12]),
        .O(token_matches0_carry__0_i_4_n_0));
  CARRY4 token_matches0_carry__1
       (.CI(token_matches0_carry__0_n_0),
        .CO({NLW_token_matches0_carry__1_CO_UNCONNECTED[3],token_matches00_out,token_matches0_carry__1_n_2,token_matches0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_token_matches0_carry__1_O_UNCONNECTED[3:0]),
        .S({1'b0,token_matches0_carry__1_i_1_n_0,token_matches0_carry__1_i_2_n_0,token_matches0_carry__1_i_3_n_0}));
  LUT4 #(
    .INIT(16'h9009)) 
    token_matches0_carry__1_i_1
       (.I0(available_epoch[30]),
        .I1(cpu_epoch[30]),
        .I2(available_epoch[31]),
        .I3(cpu_epoch[31]),
        .O(token_matches0_carry__1_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    token_matches0_carry__1_i_2
       (.I0(cpu_epoch[29]),
        .I1(available_epoch[29]),
        .I2(cpu_epoch[28]),
        .I3(available_epoch[28]),
        .I4(available_epoch[27]),
        .I5(cpu_epoch[27]),
        .O(token_matches0_carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    token_matches0_carry__1_i_3
       (.I0(cpu_epoch[26]),
        .I1(available_epoch[26]),
        .I2(cpu_epoch[24]),
        .I3(available_epoch[24]),
        .I4(available_epoch[25]),
        .I5(cpu_epoch[25]),
        .O(token_matches0_carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    token_matches0_carry_i_1
       (.I0(cpu_epoch[11]),
        .I1(available_epoch[11]),
        .I2(cpu_epoch[9]),
        .I3(available_epoch[9]),
        .I4(available_epoch[10]),
        .I5(cpu_epoch[10]),
        .O(token_matches0_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    token_matches0_carry_i_2
       (.I0(cpu_epoch[8]),
        .I1(available_epoch[8]),
        .I2(cpu_epoch[6]),
        .I3(available_epoch[6]),
        .I4(available_epoch[7]),
        .I5(cpu_epoch[7]),
        .O(token_matches0_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    token_matches0_carry_i_3
       (.I0(cpu_epoch[5]),
        .I1(available_epoch[5]),
        .I2(cpu_epoch[4]),
        .I3(available_epoch[4]),
        .I4(available_epoch[3]),
        .I5(cpu_epoch[3]),
        .O(token_matches0_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    token_matches0_carry_i_4
       (.I0(cpu_epoch[2]),
        .I1(available_epoch[2]),
        .I2(cpu_epoch[0]),
        .I3(available_epoch[0]),
        .I4(available_epoch[1]),
        .I5(cpu_epoch[1]),
        .O(token_matches0_carry_i_4_n_0));
  CARRY4 \token_matches0_inferred__0/i__carry 
       (.CI(1'b0),
        .CO({\token_matches0_inferred__0/i__carry_n_0 ,\token_matches0_inferred__0/i__carry_n_1 ,\token_matches0_inferred__0/i__carry_n_2 ,\token_matches0_inferred__0/i__carry_n_3 }),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_token_matches0_inferred__0/i__carry_O_UNCONNECTED [3:0]),
        .S({i__carry_i_1__0_n_0,i__carry_i_2__0_n_0,i__carry_i_3__0_n_0,i__carry_i_4__0_n_0}));
  CARRY4 \token_matches0_inferred__0/i__carry__0 
       (.CI(\token_matches0_inferred__0/i__carry_n_0 ),
        .CO({\token_matches0_inferred__0/i__carry__0_n_0 ,\token_matches0_inferred__0/i__carry__0_n_1 ,\token_matches0_inferred__0/i__carry__0_n_2 ,\token_matches0_inferred__0/i__carry__0_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_token_matches0_inferred__0/i__carry__0_O_UNCONNECTED [3:0]),
        .S({i__carry__0_i_1__0_n_0,i__carry__0_i_2__0_n_0,i__carry__0_i_3__0_n_0,i__carry__0_i_4__0_n_0}));
  CARRY4 \token_matches0_inferred__0/i__carry__1 
       (.CI(\token_matches0_inferred__0/i__carry__0_n_0 ),
        .CO({\NLW_token_matches0_inferred__0/i__carry__1_CO_UNCONNECTED [3],token_matches0,\token_matches0_inferred__0/i__carry__1_n_2 ,\token_matches0_inferred__0/i__carry__1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_token_matches0_inferred__0/i__carry__1_O_UNCONNECTED [3:0]),
        .S({1'b0,i__carry__1_i_1__0_n_0,i__carry__1_i_2__0_n_0,i__carry__1_i_3__0_n_0}));
endmodule

(* ORIG_REF_NAME = "vision_source_admission" *) 
module c6v_capture_lifecycle_0_vision_source_admission
   (boundary_fault,
    axis_enable,
    E,
    \admitted_frames_reg[31]_0 ,
    source_quiescent,
    \FSM_sequential_state_reg[0]_0 ,
    S,
    common_aresetn,
    vid_io_in_clk,
    vid_vsync,
    vid_active_video,
    D,
    Q,
    \close_sync_reg[0]_0 ,
    \open_sync_reg[0]_0 );
  output boundary_fault;
  output axis_enable;
  output [0:0]E;
  output [95:0]\admitted_frames_reg[31]_0 ;
  output source_quiescent;
  output \FSM_sequential_state_reg[0]_0 ;
  output [0:0]S;
  input common_aresetn;
  input vid_io_in_clk;
  input vid_vsync;
  input vid_active_video;
  input [0:0]D;
  input [2:0]Q;
  input [0:0]\close_sync_reg[0]_0 ;
  input [0:0]\open_sync_reg[0]_0 ;

  wire [0:0]D;
  wire [0:0]E;
  wire \FSM_sequential_state[0]_i_1_n_0 ;
  wire \FSM_sequential_state[0]_i_2_n_0 ;
  wire \FSM_sequential_state[1]_i_1_n_0 ;
  wire \FSM_sequential_state_reg[0]_0 ;
  wire [2:0]Q;
  wire [0:0]S;
  wire \admitted_frames[31]_i_10_n_0 ;
  wire \admitted_frames[31]_i_1_n_0 ;
  wire \admitted_frames[31]_i_3_n_0 ;
  wire \admitted_frames[31]_i_4_n_0 ;
  wire \admitted_frames[31]_i_5_n_0 ;
  wire \admitted_frames[31]_i_6_n_0 ;
  wire \admitted_frames[31]_i_7_n_0 ;
  wire \admitted_frames[31]_i_8_n_0 ;
  wire \admitted_frames[31]_i_9_n_0 ;
  wire \admitted_frames[3]_i_2_n_0 ;
  wire \admitted_frames_reg[11]_i_1_n_0 ;
  wire \admitted_frames_reg[11]_i_1_n_1 ;
  wire \admitted_frames_reg[11]_i_1_n_2 ;
  wire \admitted_frames_reg[11]_i_1_n_3 ;
  wire \admitted_frames_reg[11]_i_1_n_4 ;
  wire \admitted_frames_reg[11]_i_1_n_5 ;
  wire \admitted_frames_reg[11]_i_1_n_6 ;
  wire \admitted_frames_reg[11]_i_1_n_7 ;
  wire \admitted_frames_reg[15]_i_1_n_0 ;
  wire \admitted_frames_reg[15]_i_1_n_1 ;
  wire \admitted_frames_reg[15]_i_1_n_2 ;
  wire \admitted_frames_reg[15]_i_1_n_3 ;
  wire \admitted_frames_reg[15]_i_1_n_4 ;
  wire \admitted_frames_reg[15]_i_1_n_5 ;
  wire \admitted_frames_reg[15]_i_1_n_6 ;
  wire \admitted_frames_reg[15]_i_1_n_7 ;
  wire \admitted_frames_reg[19]_i_1_n_0 ;
  wire \admitted_frames_reg[19]_i_1_n_1 ;
  wire \admitted_frames_reg[19]_i_1_n_2 ;
  wire \admitted_frames_reg[19]_i_1_n_3 ;
  wire \admitted_frames_reg[19]_i_1_n_4 ;
  wire \admitted_frames_reg[19]_i_1_n_5 ;
  wire \admitted_frames_reg[19]_i_1_n_6 ;
  wire \admitted_frames_reg[19]_i_1_n_7 ;
  wire \admitted_frames_reg[23]_i_1_n_0 ;
  wire \admitted_frames_reg[23]_i_1_n_1 ;
  wire \admitted_frames_reg[23]_i_1_n_2 ;
  wire \admitted_frames_reg[23]_i_1_n_3 ;
  wire \admitted_frames_reg[23]_i_1_n_4 ;
  wire \admitted_frames_reg[23]_i_1_n_5 ;
  wire \admitted_frames_reg[23]_i_1_n_6 ;
  wire \admitted_frames_reg[23]_i_1_n_7 ;
  wire \admitted_frames_reg[27]_i_1_n_0 ;
  wire \admitted_frames_reg[27]_i_1_n_1 ;
  wire \admitted_frames_reg[27]_i_1_n_2 ;
  wire \admitted_frames_reg[27]_i_1_n_3 ;
  wire \admitted_frames_reg[27]_i_1_n_4 ;
  wire \admitted_frames_reg[27]_i_1_n_5 ;
  wire \admitted_frames_reg[27]_i_1_n_6 ;
  wire \admitted_frames_reg[27]_i_1_n_7 ;
  wire [95:0]\admitted_frames_reg[31]_0 ;
  wire \admitted_frames_reg[31]_i_2_n_1 ;
  wire \admitted_frames_reg[31]_i_2_n_2 ;
  wire \admitted_frames_reg[31]_i_2_n_3 ;
  wire \admitted_frames_reg[31]_i_2_n_4 ;
  wire \admitted_frames_reg[31]_i_2_n_5 ;
  wire \admitted_frames_reg[31]_i_2_n_6 ;
  wire \admitted_frames_reg[31]_i_2_n_7 ;
  wire \admitted_frames_reg[3]_i_1_n_0 ;
  wire \admitted_frames_reg[3]_i_1_n_1 ;
  wire \admitted_frames_reg[3]_i_1_n_2 ;
  wire \admitted_frames_reg[3]_i_1_n_3 ;
  wire \admitted_frames_reg[3]_i_1_n_4 ;
  wire \admitted_frames_reg[3]_i_1_n_5 ;
  wire \admitted_frames_reg[3]_i_1_n_6 ;
  wire \admitted_frames_reg[3]_i_1_n_7 ;
  wire \admitted_frames_reg[7]_i_1_n_0 ;
  wire \admitted_frames_reg[7]_i_1_n_1 ;
  wire \admitted_frames_reg[7]_i_1_n_2 ;
  wire \admitted_frames_reg[7]_i_1_n_3 ;
  wire \admitted_frames_reg[7]_i_1_n_4 ;
  wire \admitted_frames_reg[7]_i_1_n_5 ;
  wire \admitted_frames_reg[7]_i_1_n_6 ;
  wire \admitted_frames_reg[7]_i_1_n_7 ;
  wire \admitted_pixels[3]_i_2_n_0 ;
  wire \admitted_pixels[63]_i_1_n_0 ;
  wire \admitted_pixels_reg[11]_i_1_n_0 ;
  wire \admitted_pixels_reg[11]_i_1_n_1 ;
  wire \admitted_pixels_reg[11]_i_1_n_2 ;
  wire \admitted_pixels_reg[11]_i_1_n_3 ;
  wire \admitted_pixels_reg[11]_i_1_n_4 ;
  wire \admitted_pixels_reg[11]_i_1_n_5 ;
  wire \admitted_pixels_reg[11]_i_1_n_6 ;
  wire \admitted_pixels_reg[11]_i_1_n_7 ;
  wire \admitted_pixels_reg[15]_i_1_n_0 ;
  wire \admitted_pixels_reg[15]_i_1_n_1 ;
  wire \admitted_pixels_reg[15]_i_1_n_2 ;
  wire \admitted_pixels_reg[15]_i_1_n_3 ;
  wire \admitted_pixels_reg[15]_i_1_n_4 ;
  wire \admitted_pixels_reg[15]_i_1_n_5 ;
  wire \admitted_pixels_reg[15]_i_1_n_6 ;
  wire \admitted_pixels_reg[15]_i_1_n_7 ;
  wire \admitted_pixels_reg[19]_i_1_n_0 ;
  wire \admitted_pixels_reg[19]_i_1_n_1 ;
  wire \admitted_pixels_reg[19]_i_1_n_2 ;
  wire \admitted_pixels_reg[19]_i_1_n_3 ;
  wire \admitted_pixels_reg[19]_i_1_n_4 ;
  wire \admitted_pixels_reg[19]_i_1_n_5 ;
  wire \admitted_pixels_reg[19]_i_1_n_6 ;
  wire \admitted_pixels_reg[19]_i_1_n_7 ;
  wire \admitted_pixels_reg[23]_i_1_n_0 ;
  wire \admitted_pixels_reg[23]_i_1_n_1 ;
  wire \admitted_pixels_reg[23]_i_1_n_2 ;
  wire \admitted_pixels_reg[23]_i_1_n_3 ;
  wire \admitted_pixels_reg[23]_i_1_n_4 ;
  wire \admitted_pixels_reg[23]_i_1_n_5 ;
  wire \admitted_pixels_reg[23]_i_1_n_6 ;
  wire \admitted_pixels_reg[23]_i_1_n_7 ;
  wire \admitted_pixels_reg[27]_i_1_n_0 ;
  wire \admitted_pixels_reg[27]_i_1_n_1 ;
  wire \admitted_pixels_reg[27]_i_1_n_2 ;
  wire \admitted_pixels_reg[27]_i_1_n_3 ;
  wire \admitted_pixels_reg[27]_i_1_n_4 ;
  wire \admitted_pixels_reg[27]_i_1_n_5 ;
  wire \admitted_pixels_reg[27]_i_1_n_6 ;
  wire \admitted_pixels_reg[27]_i_1_n_7 ;
  wire \admitted_pixels_reg[31]_i_1_n_0 ;
  wire \admitted_pixels_reg[31]_i_1_n_1 ;
  wire \admitted_pixels_reg[31]_i_1_n_2 ;
  wire \admitted_pixels_reg[31]_i_1_n_3 ;
  wire \admitted_pixels_reg[31]_i_1_n_4 ;
  wire \admitted_pixels_reg[31]_i_1_n_5 ;
  wire \admitted_pixels_reg[31]_i_1_n_6 ;
  wire \admitted_pixels_reg[31]_i_1_n_7 ;
  wire \admitted_pixels_reg[35]_i_1_n_0 ;
  wire \admitted_pixels_reg[35]_i_1_n_1 ;
  wire \admitted_pixels_reg[35]_i_1_n_2 ;
  wire \admitted_pixels_reg[35]_i_1_n_3 ;
  wire \admitted_pixels_reg[35]_i_1_n_4 ;
  wire \admitted_pixels_reg[35]_i_1_n_5 ;
  wire \admitted_pixels_reg[35]_i_1_n_6 ;
  wire \admitted_pixels_reg[35]_i_1_n_7 ;
  wire \admitted_pixels_reg[39]_i_1_n_0 ;
  wire \admitted_pixels_reg[39]_i_1_n_1 ;
  wire \admitted_pixels_reg[39]_i_1_n_2 ;
  wire \admitted_pixels_reg[39]_i_1_n_3 ;
  wire \admitted_pixels_reg[39]_i_1_n_4 ;
  wire \admitted_pixels_reg[39]_i_1_n_5 ;
  wire \admitted_pixels_reg[39]_i_1_n_6 ;
  wire \admitted_pixels_reg[39]_i_1_n_7 ;
  wire \admitted_pixels_reg[3]_i_1_n_0 ;
  wire \admitted_pixels_reg[3]_i_1_n_1 ;
  wire \admitted_pixels_reg[3]_i_1_n_2 ;
  wire \admitted_pixels_reg[3]_i_1_n_3 ;
  wire \admitted_pixels_reg[3]_i_1_n_4 ;
  wire \admitted_pixels_reg[3]_i_1_n_5 ;
  wire \admitted_pixels_reg[3]_i_1_n_6 ;
  wire \admitted_pixels_reg[3]_i_1_n_7 ;
  wire \admitted_pixels_reg[43]_i_1_n_0 ;
  wire \admitted_pixels_reg[43]_i_1_n_1 ;
  wire \admitted_pixels_reg[43]_i_1_n_2 ;
  wire \admitted_pixels_reg[43]_i_1_n_3 ;
  wire \admitted_pixels_reg[43]_i_1_n_4 ;
  wire \admitted_pixels_reg[43]_i_1_n_5 ;
  wire \admitted_pixels_reg[43]_i_1_n_6 ;
  wire \admitted_pixels_reg[43]_i_1_n_7 ;
  wire \admitted_pixels_reg[47]_i_1_n_0 ;
  wire \admitted_pixels_reg[47]_i_1_n_1 ;
  wire \admitted_pixels_reg[47]_i_1_n_2 ;
  wire \admitted_pixels_reg[47]_i_1_n_3 ;
  wire \admitted_pixels_reg[47]_i_1_n_4 ;
  wire \admitted_pixels_reg[47]_i_1_n_5 ;
  wire \admitted_pixels_reg[47]_i_1_n_6 ;
  wire \admitted_pixels_reg[47]_i_1_n_7 ;
  wire \admitted_pixels_reg[51]_i_1_n_0 ;
  wire \admitted_pixels_reg[51]_i_1_n_1 ;
  wire \admitted_pixels_reg[51]_i_1_n_2 ;
  wire \admitted_pixels_reg[51]_i_1_n_3 ;
  wire \admitted_pixels_reg[51]_i_1_n_4 ;
  wire \admitted_pixels_reg[51]_i_1_n_5 ;
  wire \admitted_pixels_reg[51]_i_1_n_6 ;
  wire \admitted_pixels_reg[51]_i_1_n_7 ;
  wire \admitted_pixels_reg[55]_i_1_n_0 ;
  wire \admitted_pixels_reg[55]_i_1_n_1 ;
  wire \admitted_pixels_reg[55]_i_1_n_2 ;
  wire \admitted_pixels_reg[55]_i_1_n_3 ;
  wire \admitted_pixels_reg[55]_i_1_n_4 ;
  wire \admitted_pixels_reg[55]_i_1_n_5 ;
  wire \admitted_pixels_reg[55]_i_1_n_6 ;
  wire \admitted_pixels_reg[55]_i_1_n_7 ;
  wire \admitted_pixels_reg[59]_i_1_n_0 ;
  wire \admitted_pixels_reg[59]_i_1_n_1 ;
  wire \admitted_pixels_reg[59]_i_1_n_2 ;
  wire \admitted_pixels_reg[59]_i_1_n_3 ;
  wire \admitted_pixels_reg[59]_i_1_n_4 ;
  wire \admitted_pixels_reg[59]_i_1_n_5 ;
  wire \admitted_pixels_reg[59]_i_1_n_6 ;
  wire \admitted_pixels_reg[59]_i_1_n_7 ;
  wire \admitted_pixels_reg[63]_i_2_n_1 ;
  wire \admitted_pixels_reg[63]_i_2_n_2 ;
  wire \admitted_pixels_reg[63]_i_2_n_3 ;
  wire \admitted_pixels_reg[63]_i_2_n_4 ;
  wire \admitted_pixels_reg[63]_i_2_n_5 ;
  wire \admitted_pixels_reg[63]_i_2_n_6 ;
  wire \admitted_pixels_reg[63]_i_2_n_7 ;
  wire \admitted_pixels_reg[7]_i_1_n_0 ;
  wire \admitted_pixels_reg[7]_i_1_n_1 ;
  wire \admitted_pixels_reg[7]_i_1_n_2 ;
  wire \admitted_pixels_reg[7]_i_1_n_3 ;
  wire \admitted_pixels_reg[7]_i_1_n_4 ;
  wire \admitted_pixels_reg[7]_i_1_n_5 ;
  wire \admitted_pixels_reg[7]_i_1_n_6 ;
  wire \admitted_pixels_reg[7]_i_1_n_7 ;
  wire axis_enable;
  wire boundary_fault;
  wire boundary_fault_i_10_n_0;
  wire boundary_fault_i_11_n_0;
  wire boundary_fault_i_12_n_0;
  wire boundary_fault_i_13_n_0;
  wire boundary_fault_i_14_n_0;
  wire boundary_fault_i_15_n_0;
  wire boundary_fault_i_16_n_0;
  wire boundary_fault_i_17_n_0;
  wire boundary_fault_i_18_n_0;
  wire boundary_fault_i_19_n_0;
  wire boundary_fault_i_1_n_0;
  wire boundary_fault_i_20_n_0;
  wire boundary_fault_i_2_n_0;
  wire boundary_fault_i_3_n_0;
  wire boundary_fault_i_4_n_0;
  wire boundary_fault_i_5_n_0;
  wire boundary_fault_i_6_n_0;
  wire boundary_fault_i_7_n_0;
  wire boundary_fault_i_8_n_0;
  wire boundary_fault_i_9_n_0;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]close_sync;
  wire [0:0]\close_sync_reg[0]_0 ;
  wire common_aresetn;
  wire frame_admitted;
  wire frame_event_pending;
  wire frame_present_i_1_n_0;
  wire frame_present_reg_n_0;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]open_sync;
  wire [0:0]\open_sync_reg[0]_0 ;
  wire pixel_event_pending;
  wire pixel_event_pending_i_1_n_0;
  wire source_quiescent;
  wire [1:0]state;
  wire vid_active_video;
  wire vid_io_in_clk;
  wire vid_vsync;
  wire video_resetn;
  wire vsync_held;
  wire [3:3]\NLW_admitted_frames_reg[31]_i_2_CO_UNCONNECTED ;
  wire [3:3]\NLW_admitted_pixels_reg[63]_i_2_CO_UNCONNECTED ;

  LUT5 #(
    .INIT(32'hFFCFCCF8)) 
    \FSM_sequential_state[0]_i_1 
       (.I0(open_sync[2]),
        .I1(\FSM_sequential_state[0]_i_2_n_0 ),
        .I2(close_sync[2]),
        .I3(state[1]),
        .I4(state[0]),
        .O(\FSM_sequential_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h04)) 
    \FSM_sequential_state[0]_i_2 
       (.I0(vid_active_video),
        .I1(vid_vsync),
        .I2(vsync_held),
        .O(\FSM_sequential_state[0]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \FSM_sequential_state[1]_i_1 
       (.I0(close_sync[2]),
        .I1(state[1]),
        .O(\FSM_sequential_state[1]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "WAIT_START:00,RUNNING:01,CLOSING:10,CLOSED:11" *) 
  FDCE \FSM_sequential_state_reg[0] 
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(boundary_fault_i_2_n_0),
        .D(\FSM_sequential_state[0]_i_1_n_0 ),
        .Q(state[0]));
  (* FSM_ENCODED_STATES = "WAIT_START:00,RUNNING:01,CLOSING:10,CLOSED:11" *) 
  FDCE \FSM_sequential_state_reg[1] 
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(boundary_fault_i_2_n_0),
        .D(\FSM_sequential_state[1]_i_1_n_0 ),
        .Q(state[1]));
  LUT3 #(
    .INIT(8'h8A)) 
    \admitted_frames[31]_i_1 
       (.I0(frame_event_pending),
        .I1(\admitted_frames[31]_i_3_n_0 ),
        .I2(\admitted_frames[31]_i_4_n_0 ),
        .O(\admitted_frames[31]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \admitted_frames[31]_i_10 
       (.I0(\admitted_frames_reg[31]_0 [94]),
        .I1(\admitted_frames_reg[31]_0 [90]),
        .I2(\admitted_frames_reg[31]_0 [73]),
        .I3(\admitted_frames_reg[31]_0 [68]),
        .O(\admitted_frames[31]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    \admitted_frames[31]_i_3 
       (.I0(\admitted_frames_reg[31]_0 [70]),
        .I1(\admitted_frames_reg[31]_0 [84]),
        .I2(\admitted_frames_reg[31]_0 [82]),
        .I3(\admitted_frames_reg[31]_0 [87]),
        .I4(\admitted_frames[31]_i_5_n_0 ),
        .O(\admitted_frames[31]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h00000002)) 
    \admitted_frames[31]_i_4 
       (.I0(\admitted_frames[31]_i_6_n_0 ),
        .I1(\admitted_frames[31]_i_7_n_0 ),
        .I2(\admitted_frames[31]_i_8_n_0 ),
        .I3(\admitted_frames[31]_i_9_n_0 ),
        .I4(\admitted_frames[31]_i_10_n_0 ),
        .O(\admitted_frames[31]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \admitted_frames[31]_i_5 
       (.I0(\admitted_frames_reg[31]_0 [86]),
        .I1(\admitted_frames_reg[31]_0 [81]),
        .I2(\admitted_frames_reg[31]_0 [83]),
        .I3(\admitted_frames_reg[31]_0 [85]),
        .I4(\admitted_frames_reg[31]_0 [71]),
        .I5(\admitted_frames_reg[31]_0 [80]),
        .O(\admitted_frames[31]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \admitted_frames[31]_i_6 
       (.I0(\admitted_frames_reg[31]_0 [64]),
        .I1(\admitted_frames_reg[31]_0 [72]),
        .I2(\admitted_frames_reg[31]_0 [74]),
        .I3(\admitted_frames_reg[31]_0 [91]),
        .I4(\admitted_frames_reg[31]_0 [88]),
        .I5(\admitted_frames_reg[31]_0 [89]),
        .O(\admitted_frames[31]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \admitted_frames[31]_i_7 
       (.I0(\admitted_frames_reg[31]_0 [95]),
        .I1(\admitted_frames_reg[31]_0 [77]),
        .I2(\admitted_frames_reg[31]_0 [93]),
        .I3(\admitted_frames_reg[31]_0 [78]),
        .O(\admitted_frames[31]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \admitted_frames[31]_i_8 
       (.I0(\admitted_frames_reg[31]_0 [69]),
        .I1(\admitted_frames_reg[31]_0 [65]),
        .I2(\admitted_frames_reg[31]_0 [79]),
        .I3(\admitted_frames_reg[31]_0 [66]),
        .O(\admitted_frames[31]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \admitted_frames[31]_i_9 
       (.I0(\admitted_frames_reg[31]_0 [92]),
        .I1(\admitted_frames_reg[31]_0 [75]),
        .I2(\admitted_frames_reg[31]_0 [76]),
        .I3(\admitted_frames_reg[31]_0 [67]),
        .O(\admitted_frames[31]_i_9_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \admitted_frames[3]_i_2 
       (.I0(\admitted_frames_reg[31]_0 [64]),
        .O(\admitted_frames[3]_i_2_n_0 ));
  FDCE \admitted_frames_reg[0] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[3]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [64]));
  FDCE \admitted_frames_reg[10] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[11]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [74]));
  FDCE \admitted_frames_reg[11] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[11]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [75]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_frames_reg[11]_i_1 
       (.CI(\admitted_frames_reg[7]_i_1_n_0 ),
        .CO({\admitted_frames_reg[11]_i_1_n_0 ,\admitted_frames_reg[11]_i_1_n_1 ,\admitted_frames_reg[11]_i_1_n_2 ,\admitted_frames_reg[11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_frames_reg[11]_i_1_n_4 ,\admitted_frames_reg[11]_i_1_n_5 ,\admitted_frames_reg[11]_i_1_n_6 ,\admitted_frames_reg[11]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [75:72]));
  FDCE \admitted_frames_reg[12] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[15]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [76]));
  FDCE \admitted_frames_reg[13] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[15]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [77]));
  FDCE \admitted_frames_reg[14] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[15]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [78]));
  FDCE \admitted_frames_reg[15] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[15]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [79]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_frames_reg[15]_i_1 
       (.CI(\admitted_frames_reg[11]_i_1_n_0 ),
        .CO({\admitted_frames_reg[15]_i_1_n_0 ,\admitted_frames_reg[15]_i_1_n_1 ,\admitted_frames_reg[15]_i_1_n_2 ,\admitted_frames_reg[15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_frames_reg[15]_i_1_n_4 ,\admitted_frames_reg[15]_i_1_n_5 ,\admitted_frames_reg[15]_i_1_n_6 ,\admitted_frames_reg[15]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [79:76]));
  FDCE \admitted_frames_reg[16] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[19]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [80]));
  FDCE \admitted_frames_reg[17] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[19]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [81]));
  FDCE \admitted_frames_reg[18] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[19]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [82]));
  FDCE \admitted_frames_reg[19] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[19]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [83]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_frames_reg[19]_i_1 
       (.CI(\admitted_frames_reg[15]_i_1_n_0 ),
        .CO({\admitted_frames_reg[19]_i_1_n_0 ,\admitted_frames_reg[19]_i_1_n_1 ,\admitted_frames_reg[19]_i_1_n_2 ,\admitted_frames_reg[19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_frames_reg[19]_i_1_n_4 ,\admitted_frames_reg[19]_i_1_n_5 ,\admitted_frames_reg[19]_i_1_n_6 ,\admitted_frames_reg[19]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [83:80]));
  FDCE \admitted_frames_reg[1] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[3]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [65]));
  FDCE \admitted_frames_reg[20] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[23]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [84]));
  FDCE \admitted_frames_reg[21] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[23]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [85]));
  FDCE \admitted_frames_reg[22] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[23]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [86]));
  FDCE \admitted_frames_reg[23] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[23]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [87]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_frames_reg[23]_i_1 
       (.CI(\admitted_frames_reg[19]_i_1_n_0 ),
        .CO({\admitted_frames_reg[23]_i_1_n_0 ,\admitted_frames_reg[23]_i_1_n_1 ,\admitted_frames_reg[23]_i_1_n_2 ,\admitted_frames_reg[23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_frames_reg[23]_i_1_n_4 ,\admitted_frames_reg[23]_i_1_n_5 ,\admitted_frames_reg[23]_i_1_n_6 ,\admitted_frames_reg[23]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [87:84]));
  FDCE \admitted_frames_reg[24] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[27]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [88]));
  FDCE \admitted_frames_reg[25] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[27]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [89]));
  FDCE \admitted_frames_reg[26] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[27]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [90]));
  FDCE \admitted_frames_reg[27] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[27]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [91]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_frames_reg[27]_i_1 
       (.CI(\admitted_frames_reg[23]_i_1_n_0 ),
        .CO({\admitted_frames_reg[27]_i_1_n_0 ,\admitted_frames_reg[27]_i_1_n_1 ,\admitted_frames_reg[27]_i_1_n_2 ,\admitted_frames_reg[27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_frames_reg[27]_i_1_n_4 ,\admitted_frames_reg[27]_i_1_n_5 ,\admitted_frames_reg[27]_i_1_n_6 ,\admitted_frames_reg[27]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [91:88]));
  FDCE \admitted_frames_reg[28] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[31]_i_2_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [92]));
  FDCE \admitted_frames_reg[29] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[31]_i_2_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [93]));
  FDCE \admitted_frames_reg[2] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[3]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [66]));
  FDCE \admitted_frames_reg[30] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[31]_i_2_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [94]));
  FDCE \admitted_frames_reg[31] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[31]_i_2_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [95]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_frames_reg[31]_i_2 
       (.CI(\admitted_frames_reg[27]_i_1_n_0 ),
        .CO({\NLW_admitted_frames_reg[31]_i_2_CO_UNCONNECTED [3],\admitted_frames_reg[31]_i_2_n_1 ,\admitted_frames_reg[31]_i_2_n_2 ,\admitted_frames_reg[31]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_frames_reg[31]_i_2_n_4 ,\admitted_frames_reg[31]_i_2_n_5 ,\admitted_frames_reg[31]_i_2_n_6 ,\admitted_frames_reg[31]_i_2_n_7 }),
        .S(\admitted_frames_reg[31]_0 [95:92]));
  FDCE \admitted_frames_reg[3] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[3]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [67]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_frames_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\admitted_frames_reg[3]_i_1_n_0 ,\admitted_frames_reg[3]_i_1_n_1 ,\admitted_frames_reg[3]_i_1_n_2 ,\admitted_frames_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\admitted_frames_reg[3]_i_1_n_4 ,\admitted_frames_reg[3]_i_1_n_5 ,\admitted_frames_reg[3]_i_1_n_6 ,\admitted_frames_reg[3]_i_1_n_7 }),
        .S({\admitted_frames_reg[31]_0 [67:65],\admitted_frames[3]_i_2_n_0 }));
  FDCE \admitted_frames_reg[4] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[7]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [68]));
  FDCE \admitted_frames_reg[5] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[7]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [69]));
  FDCE \admitted_frames_reg[6] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[7]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [70]));
  FDCE \admitted_frames_reg[7] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[7]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [71]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_frames_reg[7]_i_1 
       (.CI(\admitted_frames_reg[3]_i_1_n_0 ),
        .CO({\admitted_frames_reg[7]_i_1_n_0 ,\admitted_frames_reg[7]_i_1_n_1 ,\admitted_frames_reg[7]_i_1_n_2 ,\admitted_frames_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_frames_reg[7]_i_1_n_4 ,\admitted_frames_reg[7]_i_1_n_5 ,\admitted_frames_reg[7]_i_1_n_6 ,\admitted_frames_reg[7]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [71:68]));
  FDCE \admitted_frames_reg[8] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[11]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [72]));
  FDCE \admitted_frames_reg[9] 
       (.C(vid_io_in_clk),
        .CE(\admitted_frames[31]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_frames_reg[11]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [73]));
  LUT1 #(
    .INIT(2'h1)) 
    \admitted_pixels[3]_i_2 
       (.I0(\admitted_frames_reg[31]_0 [0]),
        .O(\admitted_pixels[3]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h8A)) 
    \admitted_pixels[63]_i_1 
       (.I0(pixel_event_pending),
        .I1(boundary_fault_i_4_n_0),
        .I2(boundary_fault_i_3_n_0),
        .O(\admitted_pixels[63]_i_1_n_0 ));
  FDCE \admitted_pixels_reg[0] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[3]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [0]));
  FDCE \admitted_pixels_reg[10] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[11]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [10]));
  FDCE \admitted_pixels_reg[11] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[11]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [11]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[11]_i_1 
       (.CI(\admitted_pixels_reg[7]_i_1_n_0 ),
        .CO({\admitted_pixels_reg[11]_i_1_n_0 ,\admitted_pixels_reg[11]_i_1_n_1 ,\admitted_pixels_reg[11]_i_1_n_2 ,\admitted_pixels_reg[11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[11]_i_1_n_4 ,\admitted_pixels_reg[11]_i_1_n_5 ,\admitted_pixels_reg[11]_i_1_n_6 ,\admitted_pixels_reg[11]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [11:8]));
  FDCE \admitted_pixels_reg[12] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[15]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [12]));
  FDCE \admitted_pixels_reg[13] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[15]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [13]));
  FDCE \admitted_pixels_reg[14] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[15]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [14]));
  FDCE \admitted_pixels_reg[15] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[15]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [15]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[15]_i_1 
       (.CI(\admitted_pixels_reg[11]_i_1_n_0 ),
        .CO({\admitted_pixels_reg[15]_i_1_n_0 ,\admitted_pixels_reg[15]_i_1_n_1 ,\admitted_pixels_reg[15]_i_1_n_2 ,\admitted_pixels_reg[15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[15]_i_1_n_4 ,\admitted_pixels_reg[15]_i_1_n_5 ,\admitted_pixels_reg[15]_i_1_n_6 ,\admitted_pixels_reg[15]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [15:12]));
  FDCE \admitted_pixels_reg[16] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[19]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [16]));
  FDCE \admitted_pixels_reg[17] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[19]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [17]));
  FDCE \admitted_pixels_reg[18] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[19]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [18]));
  FDCE \admitted_pixels_reg[19] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[19]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [19]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[19]_i_1 
       (.CI(\admitted_pixels_reg[15]_i_1_n_0 ),
        .CO({\admitted_pixels_reg[19]_i_1_n_0 ,\admitted_pixels_reg[19]_i_1_n_1 ,\admitted_pixels_reg[19]_i_1_n_2 ,\admitted_pixels_reg[19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[19]_i_1_n_4 ,\admitted_pixels_reg[19]_i_1_n_5 ,\admitted_pixels_reg[19]_i_1_n_6 ,\admitted_pixels_reg[19]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [19:16]));
  FDCE \admitted_pixels_reg[1] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[3]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [1]));
  FDCE \admitted_pixels_reg[20] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[23]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [20]));
  FDCE \admitted_pixels_reg[21] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[23]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [21]));
  FDCE \admitted_pixels_reg[22] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[23]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [22]));
  FDCE \admitted_pixels_reg[23] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[23]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [23]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[23]_i_1 
       (.CI(\admitted_pixels_reg[19]_i_1_n_0 ),
        .CO({\admitted_pixels_reg[23]_i_1_n_0 ,\admitted_pixels_reg[23]_i_1_n_1 ,\admitted_pixels_reg[23]_i_1_n_2 ,\admitted_pixels_reg[23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[23]_i_1_n_4 ,\admitted_pixels_reg[23]_i_1_n_5 ,\admitted_pixels_reg[23]_i_1_n_6 ,\admitted_pixels_reg[23]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [23:20]));
  FDCE \admitted_pixels_reg[24] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[27]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [24]));
  FDCE \admitted_pixels_reg[25] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[27]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [25]));
  FDCE \admitted_pixels_reg[26] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[27]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [26]));
  FDCE \admitted_pixels_reg[27] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[27]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [27]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[27]_i_1 
       (.CI(\admitted_pixels_reg[23]_i_1_n_0 ),
        .CO({\admitted_pixels_reg[27]_i_1_n_0 ,\admitted_pixels_reg[27]_i_1_n_1 ,\admitted_pixels_reg[27]_i_1_n_2 ,\admitted_pixels_reg[27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[27]_i_1_n_4 ,\admitted_pixels_reg[27]_i_1_n_5 ,\admitted_pixels_reg[27]_i_1_n_6 ,\admitted_pixels_reg[27]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [27:24]));
  FDCE \admitted_pixels_reg[28] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[31]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [28]));
  FDCE \admitted_pixels_reg[29] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[31]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [29]));
  FDCE \admitted_pixels_reg[2] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[3]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [2]));
  FDCE \admitted_pixels_reg[30] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[31]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [30]));
  FDCE \admitted_pixels_reg[31] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[31]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [31]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[31]_i_1 
       (.CI(\admitted_pixels_reg[27]_i_1_n_0 ),
        .CO({\admitted_pixels_reg[31]_i_1_n_0 ,\admitted_pixels_reg[31]_i_1_n_1 ,\admitted_pixels_reg[31]_i_1_n_2 ,\admitted_pixels_reg[31]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[31]_i_1_n_4 ,\admitted_pixels_reg[31]_i_1_n_5 ,\admitted_pixels_reg[31]_i_1_n_6 ,\admitted_pixels_reg[31]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [31:28]));
  FDCE \admitted_pixels_reg[32] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[35]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [32]));
  FDCE \admitted_pixels_reg[33] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[35]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [33]));
  FDCE \admitted_pixels_reg[34] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[35]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [34]));
  FDCE \admitted_pixels_reg[35] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[35]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [35]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[35]_i_1 
       (.CI(\admitted_pixels_reg[31]_i_1_n_0 ),
        .CO({\admitted_pixels_reg[35]_i_1_n_0 ,\admitted_pixels_reg[35]_i_1_n_1 ,\admitted_pixels_reg[35]_i_1_n_2 ,\admitted_pixels_reg[35]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[35]_i_1_n_4 ,\admitted_pixels_reg[35]_i_1_n_5 ,\admitted_pixels_reg[35]_i_1_n_6 ,\admitted_pixels_reg[35]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [35:32]));
  FDCE \admitted_pixels_reg[36] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[39]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [36]));
  FDCE \admitted_pixels_reg[37] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[39]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [37]));
  FDCE \admitted_pixels_reg[38] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[39]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [38]));
  FDCE \admitted_pixels_reg[39] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[39]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [39]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[39]_i_1 
       (.CI(\admitted_pixels_reg[35]_i_1_n_0 ),
        .CO({\admitted_pixels_reg[39]_i_1_n_0 ,\admitted_pixels_reg[39]_i_1_n_1 ,\admitted_pixels_reg[39]_i_1_n_2 ,\admitted_pixels_reg[39]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[39]_i_1_n_4 ,\admitted_pixels_reg[39]_i_1_n_5 ,\admitted_pixels_reg[39]_i_1_n_6 ,\admitted_pixels_reg[39]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [39:36]));
  FDCE \admitted_pixels_reg[3] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[3]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [3]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\admitted_pixels_reg[3]_i_1_n_0 ,\admitted_pixels_reg[3]_i_1_n_1 ,\admitted_pixels_reg[3]_i_1_n_2 ,\admitted_pixels_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\admitted_pixels_reg[3]_i_1_n_4 ,\admitted_pixels_reg[3]_i_1_n_5 ,\admitted_pixels_reg[3]_i_1_n_6 ,\admitted_pixels_reg[3]_i_1_n_7 }),
        .S({\admitted_frames_reg[31]_0 [3:1],\admitted_pixels[3]_i_2_n_0 }));
  FDCE \admitted_pixels_reg[40] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[43]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [40]));
  FDCE \admitted_pixels_reg[41] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[43]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [41]));
  FDCE \admitted_pixels_reg[42] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[43]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [42]));
  FDCE \admitted_pixels_reg[43] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[43]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [43]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[43]_i_1 
       (.CI(\admitted_pixels_reg[39]_i_1_n_0 ),
        .CO({\admitted_pixels_reg[43]_i_1_n_0 ,\admitted_pixels_reg[43]_i_1_n_1 ,\admitted_pixels_reg[43]_i_1_n_2 ,\admitted_pixels_reg[43]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[43]_i_1_n_4 ,\admitted_pixels_reg[43]_i_1_n_5 ,\admitted_pixels_reg[43]_i_1_n_6 ,\admitted_pixels_reg[43]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [43:40]));
  FDCE \admitted_pixels_reg[44] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[47]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [44]));
  FDCE \admitted_pixels_reg[45] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[47]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [45]));
  FDCE \admitted_pixels_reg[46] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[47]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [46]));
  FDCE \admitted_pixels_reg[47] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[47]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [47]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[47]_i_1 
       (.CI(\admitted_pixels_reg[43]_i_1_n_0 ),
        .CO({\admitted_pixels_reg[47]_i_1_n_0 ,\admitted_pixels_reg[47]_i_1_n_1 ,\admitted_pixels_reg[47]_i_1_n_2 ,\admitted_pixels_reg[47]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[47]_i_1_n_4 ,\admitted_pixels_reg[47]_i_1_n_5 ,\admitted_pixels_reg[47]_i_1_n_6 ,\admitted_pixels_reg[47]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [47:44]));
  FDCE \admitted_pixels_reg[48] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[51]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [48]));
  FDCE \admitted_pixels_reg[49] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[51]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [49]));
  FDCE \admitted_pixels_reg[4] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[7]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [4]));
  FDCE \admitted_pixels_reg[50] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[51]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [50]));
  FDCE \admitted_pixels_reg[51] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[51]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [51]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[51]_i_1 
       (.CI(\admitted_pixels_reg[47]_i_1_n_0 ),
        .CO({\admitted_pixels_reg[51]_i_1_n_0 ,\admitted_pixels_reg[51]_i_1_n_1 ,\admitted_pixels_reg[51]_i_1_n_2 ,\admitted_pixels_reg[51]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[51]_i_1_n_4 ,\admitted_pixels_reg[51]_i_1_n_5 ,\admitted_pixels_reg[51]_i_1_n_6 ,\admitted_pixels_reg[51]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [51:48]));
  FDCE \admitted_pixels_reg[52] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[55]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [52]));
  FDCE \admitted_pixels_reg[53] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[55]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [53]));
  FDCE \admitted_pixels_reg[54] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[55]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [54]));
  FDCE \admitted_pixels_reg[55] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[55]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [55]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[55]_i_1 
       (.CI(\admitted_pixels_reg[51]_i_1_n_0 ),
        .CO({\admitted_pixels_reg[55]_i_1_n_0 ,\admitted_pixels_reg[55]_i_1_n_1 ,\admitted_pixels_reg[55]_i_1_n_2 ,\admitted_pixels_reg[55]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[55]_i_1_n_4 ,\admitted_pixels_reg[55]_i_1_n_5 ,\admitted_pixels_reg[55]_i_1_n_6 ,\admitted_pixels_reg[55]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [55:52]));
  FDCE \admitted_pixels_reg[56] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[59]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [56]));
  FDCE \admitted_pixels_reg[57] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[59]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [57]));
  FDCE \admitted_pixels_reg[58] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[59]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [58]));
  FDCE \admitted_pixels_reg[59] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[59]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [59]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[59]_i_1 
       (.CI(\admitted_pixels_reg[55]_i_1_n_0 ),
        .CO({\admitted_pixels_reg[59]_i_1_n_0 ,\admitted_pixels_reg[59]_i_1_n_1 ,\admitted_pixels_reg[59]_i_1_n_2 ,\admitted_pixels_reg[59]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[59]_i_1_n_4 ,\admitted_pixels_reg[59]_i_1_n_5 ,\admitted_pixels_reg[59]_i_1_n_6 ,\admitted_pixels_reg[59]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [59:56]));
  FDCE \admitted_pixels_reg[5] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[7]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [5]));
  FDCE \admitted_pixels_reg[60] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[63]_i_2_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [60]));
  FDCE \admitted_pixels_reg[61] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[63]_i_2_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [61]));
  FDCE \admitted_pixels_reg[62] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[63]_i_2_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [62]));
  FDCE \admitted_pixels_reg[63] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[63]_i_2_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [63]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[63]_i_2 
       (.CI(\admitted_pixels_reg[59]_i_1_n_0 ),
        .CO({\NLW_admitted_pixels_reg[63]_i_2_CO_UNCONNECTED [3],\admitted_pixels_reg[63]_i_2_n_1 ,\admitted_pixels_reg[63]_i_2_n_2 ,\admitted_pixels_reg[63]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[63]_i_2_n_4 ,\admitted_pixels_reg[63]_i_2_n_5 ,\admitted_pixels_reg[63]_i_2_n_6 ,\admitted_pixels_reg[63]_i_2_n_7 }),
        .S(\admitted_frames_reg[31]_0 [63:60]));
  FDCE \admitted_pixels_reg[6] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[7]_i_1_n_5 ),
        .Q(\admitted_frames_reg[31]_0 [6]));
  FDCE \admitted_pixels_reg[7] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[7]_i_1_n_4 ),
        .Q(\admitted_frames_reg[31]_0 [7]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \admitted_pixels_reg[7]_i_1 
       (.CI(\admitted_pixels_reg[3]_i_1_n_0 ),
        .CO({\admitted_pixels_reg[7]_i_1_n_0 ,\admitted_pixels_reg[7]_i_1_n_1 ,\admitted_pixels_reg[7]_i_1_n_2 ,\admitted_pixels_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\admitted_pixels_reg[7]_i_1_n_4 ,\admitted_pixels_reg[7]_i_1_n_5 ,\admitted_pixels_reg[7]_i_1_n_6 ,\admitted_pixels_reg[7]_i_1_n_7 }),
        .S(\admitted_frames_reg[31]_0 [7:4]));
  FDCE \admitted_pixels_reg[8] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[11]_i_1_n_7 ),
        .Q(\admitted_frames_reg[31]_0 [8]));
  FDCE \admitted_pixels_reg[9] 
       (.C(vid_io_in_clk),
        .CE(\admitted_pixels[63]_i_1_n_0 ),
        .CLR(boundary_fault_i_2_n_0),
        .D(\admitted_pixels_reg[11]_i_1_n_6 ),
        .Q(\admitted_frames_reg[31]_0 [9]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h60)) 
    axis_enable_INST_0
       (.I0(state[0]),
        .I1(state[1]),
        .I2(video_resetn),
        .O(axis_enable));
  LUT5 #(
    .INIT(32'hFFFFFF08)) 
    boundary_fault_i_1
       (.I0(boundary_fault_i_3_n_0),
        .I1(pixel_event_pending),
        .I2(boundary_fault_i_4_n_0),
        .I3(boundary_fault_i_5_n_0),
        .I4(boundary_fault),
        .O(boundary_fault_i_1_n_0));
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    boundary_fault_i_10
       (.I0(\admitted_frames_reg[31]_0 [3]),
        .I1(\admitted_frames_reg[31]_0 [5]),
        .I2(\admitted_frames_reg[31]_0 [17]),
        .I3(\admitted_frames_reg[31]_0 [30]),
        .I4(boundary_fault_i_18_n_0),
        .O(boundary_fault_i_10_n_0));
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    boundary_fault_i_11
       (.I0(\admitted_frames_reg[31]_0 [4]),
        .I1(\admitted_frames_reg[31]_0 [10]),
        .I2(\admitted_frames_reg[31]_0 [8]),
        .I3(\admitted_frames_reg[31]_0 [9]),
        .I4(boundary_fault_i_19_n_0),
        .O(boundary_fault_i_11_n_0));
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    boundary_fault_i_12
       (.I0(\admitted_frames_reg[31]_0 [7]),
        .I1(\admitted_frames_reg[31]_0 [54]),
        .I2(\admitted_frames_reg[31]_0 [55]),
        .I3(\admitted_frames_reg[31]_0 [56]),
        .I4(boundary_fault_i_20_n_0),
        .O(boundary_fault_i_12_n_0));
  LUT4 #(
    .INIT(16'h7FFF)) 
    boundary_fault_i_13
       (.I0(\admitted_frames_reg[31]_0 [29]),
        .I1(\admitted_frames_reg[31]_0 [20]),
        .I2(\admitted_frames_reg[31]_0 [43]),
        .I3(\admitted_frames_reg[31]_0 [25]),
        .O(boundary_fault_i_13_n_0));
  LUT4 #(
    .INIT(16'h8000)) 
    boundary_fault_i_14
       (.I0(\admitted_frames_reg[31]_0 [60]),
        .I1(\admitted_frames_reg[31]_0 [19]),
        .I2(\admitted_frames_reg[31]_0 [63]),
        .I3(\admitted_frames_reg[31]_0 [18]),
        .O(boundary_fault_i_14_n_0));
  LUT4 #(
    .INIT(16'h7FFF)) 
    boundary_fault_i_15
       (.I0(\admitted_frames_reg[31]_0 [49]),
        .I1(\admitted_frames_reg[31]_0 [36]),
        .I2(\admitted_frames_reg[31]_0 [62]),
        .I3(\admitted_frames_reg[31]_0 [35]),
        .O(boundary_fault_i_15_n_0));
  LUT4 #(
    .INIT(16'h7FFF)) 
    boundary_fault_i_16
       (.I0(\admitted_frames_reg[31]_0 [28]),
        .I1(\admitted_frames_reg[31]_0 [26]),
        .I2(\admitted_frames_reg[31]_0 [44]),
        .I3(\admitted_frames_reg[31]_0 [34]),
        .O(boundary_fault_i_16_n_0));
  LUT4 #(
    .INIT(16'h7FFF)) 
    boundary_fault_i_17
       (.I0(\admitted_frames_reg[31]_0 [61]),
        .I1(\admitted_frames_reg[31]_0 [59]),
        .I2(\admitted_frames_reg[31]_0 [57]),
        .I3(\admitted_frames_reg[31]_0 [53]),
        .O(boundary_fault_i_17_n_0));
  LUT4 #(
    .INIT(16'h7FFF)) 
    boundary_fault_i_18
       (.I0(\admitted_frames_reg[31]_0 [40]),
        .I1(\admitted_frames_reg[31]_0 [15]),
        .I2(\admitted_frames_reg[31]_0 [41]),
        .I3(\admitted_frames_reg[31]_0 [16]),
        .O(boundary_fault_i_18_n_0));
  LUT4 #(
    .INIT(16'h7FFF)) 
    boundary_fault_i_19
       (.I0(\admitted_frames_reg[31]_0 [14]),
        .I1(\admitted_frames_reg[31]_0 [13]),
        .I2(\admitted_frames_reg[31]_0 [12]),
        .I3(\admitted_frames_reg[31]_0 [2]),
        .O(boundary_fault_i_19_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    boundary_fault_i_2
       (.I0(video_resetn),
        .O(boundary_fault_i_2_n_0));
  LUT4 #(
    .INIT(16'h7FFF)) 
    boundary_fault_i_20
       (.I0(\admitted_frames_reg[31]_0 [32]),
        .I1(\admitted_frames_reg[31]_0 [31]),
        .I2(\admitted_frames_reg[31]_0 [39]),
        .I3(\admitted_frames_reg[31]_0 [6]),
        .O(boundary_fault_i_20_n_0));
  LUT4 #(
    .INIT(16'h0002)) 
    boundary_fault_i_3
       (.I0(boundary_fault_i_6_n_0),
        .I1(boundary_fault_i_7_n_0),
        .I2(boundary_fault_i_8_n_0),
        .I3(boundary_fault_i_9_n_0),
        .O(boundary_fault_i_3_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFBFFF)) 
    boundary_fault_i_4
       (.I0(boundary_fault_i_10_n_0),
        .I1(\admitted_frames_reg[31]_0 [1]),
        .I2(\admitted_frames_reg[31]_0 [0]),
        .I3(\admitted_frames_reg[31]_0 [11]),
        .I4(boundary_fault_i_11_n_0),
        .I5(boundary_fault_i_12_n_0),
        .O(boundary_fault_i_4_n_0));
  LUT6 #(
    .INIT(64'h40FF404040404040)) 
    boundary_fault_i_5
       (.I0(vsync_held),
        .I1(vid_vsync),
        .I2(vid_active_video),
        .I3(\admitted_frames[31]_i_3_n_0 ),
        .I4(frame_event_pending),
        .I5(\admitted_frames[31]_i_4_n_0 ),
        .O(boundary_fault_i_5_n_0));
  LUT6 #(
    .INIT(64'h0400000000000000)) 
    boundary_fault_i_6
       (.I0(boundary_fault_i_13_n_0),
        .I1(boundary_fault_i_14_n_0),
        .I2(boundary_fault_i_15_n_0),
        .I3(\admitted_frames_reg[31]_0 [23]),
        .I4(\admitted_frames_reg[31]_0 [33]),
        .I5(\admitted_frames_reg[31]_0 [21]),
        .O(boundary_fault_i_6_n_0));
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    boundary_fault_i_7
       (.I0(\admitted_frames_reg[31]_0 [22]),
        .I1(\admitted_frames_reg[31]_0 [58]),
        .I2(\admitted_frames_reg[31]_0 [48]),
        .I3(\admitted_frames_reg[31]_0 [50]),
        .I4(boundary_fault_i_16_n_0),
        .O(boundary_fault_i_7_n_0));
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    boundary_fault_i_8
       (.I0(\admitted_frames_reg[31]_0 [24]),
        .I1(\admitted_frames_reg[31]_0 [42]),
        .I2(\admitted_frames_reg[31]_0 [46]),
        .I3(\admitted_frames_reg[31]_0 [52]),
        .I4(boundary_fault_i_17_n_0),
        .O(boundary_fault_i_8_n_0));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    boundary_fault_i_9
       (.I0(\admitted_frames_reg[31]_0 [51]),
        .I1(\admitted_frames_reg[31]_0 [47]),
        .I2(\admitted_frames_reg[31]_0 [27]),
        .I3(\admitted_frames_reg[31]_0 [37]),
        .I4(\admitted_frames_reg[31]_0 [38]),
        .I5(\admitted_frames_reg[31]_0 [45]),
        .O(boundary_fault_i_9_n_0));
  FDCE boundary_fault_reg
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(boundary_fault_i_2_n_0),
        .D(boundary_fault_i_1_n_0),
        .Q(boundary_fault));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \close_sync_reg[0] 
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(boundary_fault_i_2_n_0),
        .D(\close_sync_reg[0]_0 ),
        .Q(close_sync[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \close_sync_reg[1] 
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(boundary_fault_i_2_n_0),
        .D(close_sync[0]),
        .Q(close_sync[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \close_sync_reg[2] 
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(boundary_fault_i_2_n_0),
        .D(close_sync[1]),
        .Q(close_sync[2]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h28000000)) 
    frame_event_pending_i_1
       (.I0(video_resetn),
        .I1(state[1]),
        .I2(state[0]),
        .I3(\FSM_sequential_state[0]_i_2_n_0 ),
        .I4(frame_present_reg_n_0),
        .O(frame_admitted));
  FDCE frame_event_pending_reg
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(boundary_fault_i_2_n_0),
        .D(frame_admitted),
        .Q(frame_event_pending));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hFF8AAAAA)) 
    frame_present_i_1
       (.I0(frame_present_reg_n_0),
        .I1(vsync_held),
        .I2(vid_vsync),
        .I3(vid_active_video),
        .I4(axis_enable),
        .O(frame_present_i_1_n_0));
  FDCE frame_present_reg
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(boundary_fault_i_2_n_0),
        .D(frame_present_i_1_n_0),
        .Q(frame_present_reg_n_0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \open_sync_reg[0] 
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(boundary_fault_i_2_n_0),
        .D(\open_sync_reg[0]_0 ),
        .Q(open_sync[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \open_sync_reg[1] 
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(boundary_fault_i_2_n_0),
        .D(open_sync[0]),
        .Q(open_sync[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \open_sync_reg[2] 
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(boundary_fault_i_2_n_0),
        .D(open_sync[1]),
        .Q(open_sync[2]));
  LUT4 #(
    .INIT(16'h2800)) 
    pixel_event_pending_i_1
       (.I0(video_resetn),
        .I1(state[1]),
        .I2(state[0]),
        .I3(vid_active_video),
        .O(pixel_event_pending_i_1_n_0));
  FDCE pixel_event_pending_reg
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(boundary_fault_i_2_n_0),
        .D(pixel_event_pending_i_1_n_0),
        .Q(pixel_event_pending));
  LUT6 #(
    .INIT(64'h0010000000000000)) 
    request_held_i_1__0
       (.I0(D),
        .I1(frame_event_pending),
        .I2(video_resetn),
        .I3(pixel_event_pending),
        .I4(state[1]),
        .I5(state[0]),
        .O(E));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry_i_4
       (.I0(\admitted_frames_reg[31]_0 [0]),
        .I1(Q[0]),
        .I2(Q[2]),
        .I3(\admitted_frames_reg[31]_0 [2]),
        .I4(Q[1]),
        .I5(\admitted_frames_reg[31]_0 [1]),
        .O(S));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFFFFF7FF)) 
    source_protocol_fault_i_2
       (.I0(state[0]),
        .I1(state[1]),
        .I2(pixel_event_pending),
        .I3(video_resetn),
        .I4(frame_event_pending),
        .O(\FSM_sequential_state_reg[0]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h04000000)) 
    source_quiescent_INST_0
       (.I0(frame_event_pending),
        .I1(video_resetn),
        .I2(pixel_event_pending),
        .I3(state[1]),
        .I4(state[0]),
        .O(source_quiescent));
  (* DEF_VAL = "1'b1" *) 
  (* DEST_SYNC_FF = "3" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* INV_DEF_VAL = "1'b0" *) 
  (* RST_ACTIVE_HIGH = "0" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  (* XPM_MODULE = "TRUE" *) 
  c6v_capture_lifecycle_0_xpm_cdc_async_rst__1 source_reset
       (.dest_arst(video_resetn),
        .dest_clk(vid_io_in_clk),
        .src_arst(common_aresetn));
  FDCE vsync_held_reg
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(boundary_fault_i_2_n_0),
        .D(vid_vsync),
        .Q(vsync_held));
endmodule

(* ORIG_REF_NAME = "vision_source_budget_cdc" *) 
module c6v_capture_lifecycle_0_vision_source_budget_cdc
   (dest_arst,
    D,
    closure_held,
    Q,
    budget_checked,
    dma_fault_0,
    capture_source_fault,
    \held_budget_reg[2]_0 ,
    budget_checked_reg_0,
    source_closed,
    closure_held_reg_0,
    upstream_fault0,
    budget_fault,
    \closed_frame_count_reg[8]_0 ,
    \closed_frame_count_reg[23]_0 ,
    \closed_frame_count_reg[6]_0 ,
    DI,
    \closed_frame_count_reg[14]_0 ,
    \closed_frame_count_reg[14]_1 ,
    \closed_frame_count_reg[22]_0 ,
    \closed_frame_count_reg[22]_1 ,
    \closed_frame_count_reg[30]_0 ,
    \closed_frame_count_reg[30]_1 ,
    closed_pixel_count,
    \closed_frame_count_reg[6]_1 ,
    \closed_frame_count_reg[14]_2 ,
    \closed_frame_count_reg[22]_2 ,
    \closed_frame_count_reg[30]_2 ,
    budget_checked_reg_1,
    aclk,
    common_aresetn,
    vid_io_in_clk,
    E,
    S,
    dma_fault,
    capture_fault,
    cpu_command_fault,
    owner_fault_causes,
    p_0_in0_in,
    CO,
    \granted_frames_reg[31] ,
    closure_held_reg_1,
    configuration_locked,
    capture_source_fault_0,
    dest_out,
    closure_bad2_carry__0,
    out,
    source_protocol_fault_reg_0);
  output dest_arst;
  output [0:0]D;
  output closure_held;
  output [31:0]Q;
  output budget_checked;
  output dma_fault_0;
  output capture_source_fault;
  output [2:0]\held_budget_reg[2]_0 ;
  output budget_checked_reg_0;
  output source_closed;
  output [0:0]closure_held_reg_0;
  output upstream_fault0;
  output budget_fault;
  output [1:0]\closed_frame_count_reg[8]_0 ;
  output [2:0]\closed_frame_count_reg[23]_0 ;
  output [3:0]\closed_frame_count_reg[6]_0 ;
  output [3:0]DI;
  output [3:0]\closed_frame_count_reg[14]_0 ;
  output [3:0]\closed_frame_count_reg[14]_1 ;
  output [3:0]\closed_frame_count_reg[22]_0 ;
  output [3:0]\closed_frame_count_reg[22]_1 ;
  output [3:0]\closed_frame_count_reg[30]_0 ;
  output [3:0]\closed_frame_count_reg[30]_1 ;
  output [63:0]closed_pixel_count;
  output [3:0]\closed_frame_count_reg[6]_1 ;
  output [3:0]\closed_frame_count_reg[14]_2 ;
  output [3:0]\closed_frame_count_reg[22]_2 ;
  output [3:0]\closed_frame_count_reg[30]_2 ;
  output budget_checked_reg_1;
  input aclk;
  input common_aresetn;
  input vid_io_in_clk;
  input [0:0]E;
  input [0:0]S;
  input dma_fault;
  input capture_fault;
  input cpu_command_fault;
  input [0:0]owner_fault_causes;
  input [95:0]p_0_in0_in;
  input [0:0]CO;
  input \granted_frames_reg[31] ;
  input closure_held_reg_1;
  input configuration_locked;
  input capture_source_fault_0;
  input dest_out;
  input [14:0]closure_bad2_carry__0;
  input [31:0]out;
  input source_protocol_fault_reg_0;

  wire [0:0]CO;
  wire [0:0]D;
  wire [3:0]DI;
  wire [0:0]E;
  wire [31:0]Q;
  wire [0:0]S;
  wire aclk;
  wire budget_checked;
  wire budget_checked_i_1_n_0;
  wire budget_checked_reg_0;
  wire budget_checked_reg_1;
  wire budget_fault;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [95:0]budget_meta;
  wire budget_product_ready;
  wire budget_product_ready0;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [95:0]budget_sync;
  wire capture_fault;
  wire capture_source_fault;
  wire capture_source_fault_0;
  wire \closed_frame_count[31]_i_2_n_0 ;
  wire [3:0]\closed_frame_count_reg[14]_0 ;
  wire [3:0]\closed_frame_count_reg[14]_1 ;
  wire [3:0]\closed_frame_count_reg[14]_2 ;
  wire [3:0]\closed_frame_count_reg[22]_0 ;
  wire [3:0]\closed_frame_count_reg[22]_1 ;
  wire [3:0]\closed_frame_count_reg[22]_2 ;
  wire [2:0]\closed_frame_count_reg[23]_0 ;
  wire [3:0]\closed_frame_count_reg[30]_0 ;
  wire [3:0]\closed_frame_count_reg[30]_1 ;
  wire [3:0]\closed_frame_count_reg[30]_2 ;
  wire [3:0]\closed_frame_count_reg[6]_0 ;
  wire [3:0]\closed_frame_count_reg[6]_1 ;
  wire [1:0]\closed_frame_count_reg[8]_0 ;
  wire [63:0]closed_pixel_count;
  wire [14:0]closure_bad2_carry__0;
  wire closure_held;
  wire closure_held0;
  wire [0:0]closure_held_reg_0;
  wire closure_held_reg_1;
  wire common_aresetn;
  wire configuration_locked;
  wire cpu_command_fault;
  wire dest_arst;
  wire dest_out;
  wire dma_fault;
  wire dma_fault_0;
  wire expected_pixels0__0_n_100;
  wire expected_pixels0__0_n_101;
  wire expected_pixels0__0_n_102;
  wire expected_pixels0__0_n_103;
  wire expected_pixels0__0_n_104;
  wire expected_pixels0__0_n_105;
  wire expected_pixels0__0_n_58;
  wire expected_pixels0__0_n_59;
  wire expected_pixels0__0_n_60;
  wire expected_pixels0__0_n_61;
  wire expected_pixels0__0_n_62;
  wire expected_pixels0__0_n_63;
  wire expected_pixels0__0_n_64;
  wire expected_pixels0__0_n_65;
  wire expected_pixels0__0_n_66;
  wire expected_pixels0__0_n_67;
  wire expected_pixels0__0_n_68;
  wire expected_pixels0__0_n_69;
  wire expected_pixels0__0_n_70;
  wire expected_pixels0__0_n_71;
  wire expected_pixels0__0_n_72;
  wire expected_pixels0__0_n_73;
  wire expected_pixels0__0_n_74;
  wire expected_pixels0__0_n_75;
  wire expected_pixels0__0_n_76;
  wire expected_pixels0__0_n_77;
  wire expected_pixels0__0_n_78;
  wire expected_pixels0__0_n_79;
  wire expected_pixels0__0_n_80;
  wire expected_pixels0__0_n_81;
  wire expected_pixels0__0_n_82;
  wire expected_pixels0__0_n_83;
  wire expected_pixels0__0_n_84;
  wire expected_pixels0__0_n_85;
  wire expected_pixels0__0_n_86;
  wire expected_pixels0__0_n_87;
  wire expected_pixels0__0_n_88;
  wire expected_pixels0__0_n_89;
  wire expected_pixels0__0_n_90;
  wire expected_pixels0__0_n_91;
  wire expected_pixels0__0_n_92;
  wire expected_pixels0__0_n_93;
  wire expected_pixels0__0_n_94;
  wire expected_pixels0__0_n_95;
  wire expected_pixels0__0_n_96;
  wire expected_pixels0__0_n_97;
  wire expected_pixels0__0_n_98;
  wire expected_pixels0__0_n_99;
  wire expected_pixels0_n_100;
  wire expected_pixels0_n_101;
  wire expected_pixels0_n_102;
  wire expected_pixels0_n_103;
  wire expected_pixels0_n_104;
  wire expected_pixels0_n_105;
  wire expected_pixels0_n_106;
  wire expected_pixels0_n_107;
  wire expected_pixels0_n_108;
  wire expected_pixels0_n_109;
  wire expected_pixels0_n_110;
  wire expected_pixels0_n_111;
  wire expected_pixels0_n_112;
  wire expected_pixels0_n_113;
  wire expected_pixels0_n_114;
  wire expected_pixels0_n_115;
  wire expected_pixels0_n_116;
  wire expected_pixels0_n_117;
  wire expected_pixels0_n_118;
  wire expected_pixels0_n_119;
  wire expected_pixels0_n_120;
  wire expected_pixels0_n_121;
  wire expected_pixels0_n_122;
  wire expected_pixels0_n_123;
  wire expected_pixels0_n_124;
  wire expected_pixels0_n_125;
  wire expected_pixels0_n_126;
  wire expected_pixels0_n_127;
  wire expected_pixels0_n_128;
  wire expected_pixels0_n_129;
  wire expected_pixels0_n_130;
  wire expected_pixels0_n_131;
  wire expected_pixels0_n_132;
  wire expected_pixels0_n_133;
  wire expected_pixels0_n_134;
  wire expected_pixels0_n_135;
  wire expected_pixels0_n_136;
  wire expected_pixels0_n_137;
  wire expected_pixels0_n_138;
  wire expected_pixels0_n_139;
  wire expected_pixels0_n_140;
  wire expected_pixels0_n_141;
  wire expected_pixels0_n_142;
  wire expected_pixels0_n_143;
  wire expected_pixels0_n_144;
  wire expected_pixels0_n_145;
  wire expected_pixels0_n_146;
  wire expected_pixels0_n_147;
  wire expected_pixels0_n_148;
  wire expected_pixels0_n_149;
  wire expected_pixels0_n_150;
  wire expected_pixels0_n_151;
  wire expected_pixels0_n_152;
  wire expected_pixels0_n_153;
  wire expected_pixels0_n_24;
  wire expected_pixels0_n_25;
  wire expected_pixels0_n_26;
  wire expected_pixels0_n_27;
  wire expected_pixels0_n_28;
  wire expected_pixels0_n_29;
  wire expected_pixels0_n_30;
  wire expected_pixels0_n_31;
  wire expected_pixels0_n_32;
  wire expected_pixels0_n_33;
  wire expected_pixels0_n_34;
  wire expected_pixels0_n_35;
  wire expected_pixels0_n_36;
  wire expected_pixels0_n_37;
  wire expected_pixels0_n_38;
  wire expected_pixels0_n_39;
  wire expected_pixels0_n_40;
  wire expected_pixels0_n_41;
  wire expected_pixels0_n_42;
  wire expected_pixels0_n_43;
  wire expected_pixels0_n_44;
  wire expected_pixels0_n_45;
  wire expected_pixels0_n_46;
  wire expected_pixels0_n_47;
  wire expected_pixels0_n_48;
  wire expected_pixels0_n_49;
  wire expected_pixels0_n_50;
  wire expected_pixels0_n_51;
  wire expected_pixels0_n_52;
  wire expected_pixels0_n_53;
  wire expected_pixels0_n_58;
  wire expected_pixels0_n_59;
  wire expected_pixels0_n_60;
  wire expected_pixels0_n_61;
  wire expected_pixels0_n_62;
  wire expected_pixels0_n_63;
  wire expected_pixels0_n_64;
  wire expected_pixels0_n_65;
  wire expected_pixels0_n_66;
  wire expected_pixels0_n_67;
  wire expected_pixels0_n_68;
  wire expected_pixels0_n_69;
  wire expected_pixels0_n_70;
  wire expected_pixels0_n_71;
  wire expected_pixels0_n_72;
  wire expected_pixels0_n_73;
  wire expected_pixels0_n_74;
  wire expected_pixels0_n_75;
  wire expected_pixels0_n_76;
  wire expected_pixels0_n_77;
  wire expected_pixels0_n_78;
  wire expected_pixels0_n_79;
  wire expected_pixels0_n_80;
  wire expected_pixels0_n_81;
  wire expected_pixels0_n_82;
  wire expected_pixels0_n_83;
  wire expected_pixels0_n_84;
  wire expected_pixels0_n_85;
  wire expected_pixels0_n_86;
  wire expected_pixels0_n_87;
  wire expected_pixels0_n_88;
  wire expected_pixels0_n_89;
  wire expected_pixels0_n_90;
  wire expected_pixels0_n_91;
  wire expected_pixels0_n_92;
  wire expected_pixels0_n_93;
  wire expected_pixels0_n_94;
  wire expected_pixels0_n_95;
  wire expected_pixels0_n_96;
  wire expected_pixels0_n_97;
  wire expected_pixels0_n_98;
  wire expected_pixels0_n_99;
  wire [16:0]expected_pixels_reg;
  wire fault_held;
  wire fault_held0;
  wire fault_held2;
  wire fault_held2_carry__0_i_1_n_0;
  wire fault_held2_carry__0_i_2_n_0;
  wire fault_held2_carry__0_i_3_n_0;
  wire fault_held2_carry__0_i_4_n_0;
  wire fault_held2_carry__0_i_5_n_0;
  wire fault_held2_carry__0_i_6_n_0;
  wire fault_held2_carry__0_i_7_n_0;
  wire fault_held2_carry__0_n_0;
  wire fault_held2_carry__0_n_1;
  wire fault_held2_carry__0_n_2;
  wire fault_held2_carry__0_n_3;
  wire fault_held2_carry__1_i_1_n_0;
  wire fault_held2_carry__1_i_2_n_0;
  wire fault_held2_carry__1_i_3_n_0;
  wire fault_held2_carry__1_i_4_n_0;
  wire fault_held2_carry__1_i_5_n_0;
  wire fault_held2_carry__1_i_6_n_0;
  wire fault_held2_carry__1_i_7_n_0;
  wire fault_held2_carry__1_i_8_n_0;
  wire fault_held2_carry__1_n_0;
  wire fault_held2_carry__1_n_1;
  wire fault_held2_carry__1_n_2;
  wire fault_held2_carry__1_n_3;
  wire fault_held2_carry__2_i_1_n_0;
  wire fault_held2_carry__2_i_2_n_0;
  wire fault_held2_carry__2_i_3_n_0;
  wire fault_held2_carry__2_i_4_n_0;
  wire fault_held2_carry__2_i_5_n_0;
  wire fault_held2_carry__2_i_6_n_0;
  wire fault_held2_carry__2_i_7_n_0;
  wire fault_held2_carry__2_i_8_n_0;
  wire fault_held2_carry__2_n_0;
  wire fault_held2_carry__2_n_1;
  wire fault_held2_carry__2_n_2;
  wire fault_held2_carry__2_n_3;
  wire fault_held2_carry__3_i_1_n_0;
  wire fault_held2_carry__3_i_2_n_0;
  wire fault_held2_carry__3_i_3_n_0;
  wire fault_held2_carry__3_i_4_n_0;
  wire fault_held2_carry__3_i_5_n_0;
  wire fault_held2_carry__3_n_0;
  wire fault_held2_carry__3_n_1;
  wire fault_held2_carry__3_n_2;
  wire fault_held2_carry__3_n_3;
  wire fault_held2_carry__4_i_1_n_0;
  wire fault_held2_carry__4_i_2_n_0;
  wire fault_held2_carry__4_n_3;
  wire fault_held2_carry_i_1_n_0;
  wire fault_held2_carry_i_2_n_0;
  wire fault_held2_carry_i_3_n_0;
  wire fault_held2_carry_i_4_n_0;
  wire fault_held2_carry_n_0;
  wire fault_held2_carry_n_1;
  wire fault_held2_carry_n_2;
  wire fault_held2_carry_n_3;
  wire fault_held4;
  wire fault_held4_carry__0_i_1_n_0;
  wire fault_held4_carry__0_i_2_n_0;
  wire fault_held4_carry__0_i_3_n_0;
  wire fault_held4_carry__0_i_4_n_0;
  wire fault_held4_carry__0_n_0;
  wire fault_held4_carry__0_n_1;
  wire fault_held4_carry__0_n_2;
  wire fault_held4_carry__0_n_3;
  wire fault_held4_carry__1_i_1_n_0;
  wire fault_held4_carry__1_i_2_n_0;
  wire fault_held4_carry__1_i_3_n_0;
  wire fault_held4_carry__1_i_4_n_0;
  wire fault_held4_carry__1_n_0;
  wire fault_held4_carry__1_n_1;
  wire fault_held4_carry__1_n_2;
  wire fault_held4_carry__1_n_3;
  wire fault_held4_carry__2_i_1_n_0;
  wire fault_held4_carry__2_i_2_n_0;
  wire fault_held4_carry__2_i_3_n_0;
  wire fault_held4_carry__2_i_4_n_0;
  wire fault_held4_carry__2_n_0;
  wire fault_held4_carry__2_n_1;
  wire fault_held4_carry__2_n_2;
  wire fault_held4_carry__2_n_3;
  wire fault_held4_carry__3_i_1_n_0;
  wire fault_held4_carry__3_i_2_n_0;
  wire fault_held4_carry__3_i_3_n_0;
  wire fault_held4_carry__3_i_4_n_0;
  wire fault_held4_carry__3_n_0;
  wire fault_held4_carry__3_n_1;
  wire fault_held4_carry__3_n_2;
  wire fault_held4_carry__3_n_3;
  wire fault_held4_carry__4_i_1_n_0;
  wire fault_held4_carry__4_i_2_n_0;
  wire fault_held4_carry__4_i_3_n_0;
  wire fault_held4_carry__4_i_4_n_0;
  wire fault_held4_carry__4_n_0;
  wire fault_held4_carry__4_n_1;
  wire fault_held4_carry__4_n_2;
  wire fault_held4_carry__4_n_3;
  wire fault_held4_carry__5_i_1_n_0;
  wire fault_held4_carry__5_i_2_n_0;
  wire fault_held4_carry__5_i_3_n_0;
  wire fault_held4_carry__5_i_4_n_0;
  wire fault_held4_carry__5_n_0;
  wire fault_held4_carry__5_n_1;
  wire fault_held4_carry__5_n_2;
  wire fault_held4_carry__5_n_3;
  wire fault_held4_carry__6_i_1_n_0;
  wire fault_held4_carry__6_i_2_n_0;
  wire fault_held4_carry__6_i_3_n_0;
  wire fault_held4_carry__6_i_4_n_0;
  wire fault_held4_carry__6_n_1;
  wire fault_held4_carry__6_n_2;
  wire fault_held4_carry__6_n_3;
  wire fault_held4_carry_i_1_n_0;
  wire fault_held4_carry_i_2_n_0;
  wire fault_held4_carry_i_3_n_0;
  wire fault_held4_carry_i_4_n_0;
  wire fault_held4_carry_n_0;
  wire fault_held4_carry_n_1;
  wire fault_held4_carry_n_2;
  wire fault_held4_carry_n_3;
  wire fault_held_i_1_n_0;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]fault_sync;
  wire \granted_frames_reg[31] ;
  wire [95:3]held_budget;
  wire [2:0]\held_budget_reg[2]_0 ;
  wire [31:0]out;
  wire [0:0]owner_fault_causes;
  wire [95:0]p_0_in0_in;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]reply_sync;
  wire request_held_i_2_n_0;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]request_sync;
  wire source_closed;
  wire source_protocol_fault;
  wire source_protocol_fault3;
  wire source_protocol_fault3_carry__0_i_1_n_0;
  wire source_protocol_fault3_carry__0_i_2_n_0;
  wire source_protocol_fault3_carry__0_i_3_n_0;
  wire source_protocol_fault3_carry__0_i_4_n_0;
  wire source_protocol_fault3_carry__0_n_0;
  wire source_protocol_fault3_carry__0_n_1;
  wire source_protocol_fault3_carry__0_n_2;
  wire source_protocol_fault3_carry__0_n_3;
  wire source_protocol_fault3_carry__1_i_1_n_0;
  wire source_protocol_fault3_carry__1_i_2_n_0;
  wire source_protocol_fault3_carry__1_i_3_n_0;
  wire source_protocol_fault3_carry__1_i_4_n_0;
  wire source_protocol_fault3_carry__1_n_0;
  wire source_protocol_fault3_carry__1_n_1;
  wire source_protocol_fault3_carry__1_n_2;
  wire source_protocol_fault3_carry__1_n_3;
  wire source_protocol_fault3_carry__2_i_1_n_0;
  wire source_protocol_fault3_carry__2_i_2_n_0;
  wire source_protocol_fault3_carry__2_i_3_n_0;
  wire source_protocol_fault3_carry__2_i_4_n_0;
  wire source_protocol_fault3_carry__2_n_0;
  wire source_protocol_fault3_carry__2_n_1;
  wire source_protocol_fault3_carry__2_n_2;
  wire source_protocol_fault3_carry__2_n_3;
  wire source_protocol_fault3_carry__3_i_1_n_0;
  wire source_protocol_fault3_carry__3_i_2_n_0;
  wire source_protocol_fault3_carry__3_i_3_n_0;
  wire source_protocol_fault3_carry__3_i_4_n_0;
  wire source_protocol_fault3_carry__3_n_0;
  wire source_protocol_fault3_carry__3_n_1;
  wire source_protocol_fault3_carry__3_n_2;
  wire source_protocol_fault3_carry__3_n_3;
  wire source_protocol_fault3_carry__4_i_1_n_0;
  wire source_protocol_fault3_carry__4_i_2_n_0;
  wire source_protocol_fault3_carry__4_i_3_n_0;
  wire source_protocol_fault3_carry__4_i_4_n_0;
  wire source_protocol_fault3_carry__4_n_0;
  wire source_protocol_fault3_carry__4_n_1;
  wire source_protocol_fault3_carry__4_n_2;
  wire source_protocol_fault3_carry__4_n_3;
  wire source_protocol_fault3_carry__5_i_1_n_0;
  wire source_protocol_fault3_carry__5_i_2_n_0;
  wire source_protocol_fault3_carry__5_i_3_n_0;
  wire source_protocol_fault3_carry__5_i_4_n_0;
  wire source_protocol_fault3_carry__5_n_0;
  wire source_protocol_fault3_carry__5_n_1;
  wire source_protocol_fault3_carry__5_n_2;
  wire source_protocol_fault3_carry__5_n_3;
  wire source_protocol_fault3_carry__6_i_1_n_0;
  wire source_protocol_fault3_carry__6_i_2_n_0;
  wire source_protocol_fault3_carry__6_i_3_n_0;
  wire source_protocol_fault3_carry__6_i_4_n_0;
  wire source_protocol_fault3_carry__6_n_1;
  wire source_protocol_fault3_carry__6_n_2;
  wire source_protocol_fault3_carry__6_n_3;
  wire source_protocol_fault3_carry_i_1_n_0;
  wire source_protocol_fault3_carry_i_2_n_0;
  wire source_protocol_fault3_carry_i_3_n_0;
  wire source_protocol_fault3_carry_n_0;
  wire source_protocol_fault3_carry_n_1;
  wire source_protocol_fault3_carry_n_2;
  wire source_protocol_fault3_carry_n_3;
  wire source_protocol_fault_i_1__0_n_0;
  wire source_protocol_fault_reg_0;
  wire upstream_fault0;
  wire vid_io_in_clk;
  wire video_resetn;
  wire NLW_expected_pixels0_CARRYCASCOUT_UNCONNECTED;
  wire NLW_expected_pixels0_MULTSIGNOUT_UNCONNECTED;
  wire NLW_expected_pixels0_OVERFLOW_UNCONNECTED;
  wire NLW_expected_pixels0_PATTERNBDETECT_UNCONNECTED;
  wire NLW_expected_pixels0_PATTERNDETECT_UNCONNECTED;
  wire NLW_expected_pixels0_UNDERFLOW_UNCONNECTED;
  wire [17:0]NLW_expected_pixels0_BCOUT_UNCONNECTED;
  wire [3:0]NLW_expected_pixels0_CARRYOUT_UNCONNECTED;
  wire NLW_expected_pixels0__0_CARRYCASCOUT_UNCONNECTED;
  wire NLW_expected_pixels0__0_MULTSIGNOUT_UNCONNECTED;
  wire NLW_expected_pixels0__0_OVERFLOW_UNCONNECTED;
  wire NLW_expected_pixels0__0_PATTERNBDETECT_UNCONNECTED;
  wire NLW_expected_pixels0__0_PATTERNDETECT_UNCONNECTED;
  wire NLW_expected_pixels0__0_UNDERFLOW_UNCONNECTED;
  wire [29:0]NLW_expected_pixels0__0_ACOUT_UNCONNECTED;
  wire [17:0]NLW_expected_pixels0__0_BCOUT_UNCONNECTED;
  wire [3:0]NLW_expected_pixels0__0_CARRYOUT_UNCONNECTED;
  wire [47:0]NLW_expected_pixels0__0_PCOUT_UNCONNECTED;
  wire [3:0]NLW_fault_held2_carry_O_UNCONNECTED;
  wire [3:0]NLW_fault_held2_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_fault_held2_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_fault_held2_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_fault_held2_carry__3_O_UNCONNECTED;
  wire [3:2]NLW_fault_held2_carry__4_CO_UNCONNECTED;
  wire [3:0]NLW_fault_held2_carry__4_O_UNCONNECTED;
  wire [3:0]NLW_fault_held4_carry_O_UNCONNECTED;
  wire [3:0]NLW_fault_held4_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_fault_held4_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_fault_held4_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_fault_held4_carry__3_O_UNCONNECTED;
  wire [3:0]NLW_fault_held4_carry__4_O_UNCONNECTED;
  wire [3:0]NLW_fault_held4_carry__5_O_UNCONNECTED;
  wire [3:0]NLW_fault_held4_carry__6_O_UNCONNECTED;
  wire [3:0]NLW_source_protocol_fault3_carry_O_UNCONNECTED;
  wire [3:0]NLW_source_protocol_fault3_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_source_protocol_fault3_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_source_protocol_fault3_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_source_protocol_fault3_carry__3_O_UNCONNECTED;
  wire [3:0]NLW_source_protocol_fault3_carry__4_O_UNCONNECTED;
  wire [3:0]NLW_source_protocol_fault3_carry__5_O_UNCONNECTED;
  wire [3:0]NLW_source_protocol_fault3_carry__6_O_UNCONNECTED;

  LUT2 #(
    .INIT(4'hE)) 
    budget_checked_i_1
       (.I0(budget_product_ready),
        .I1(budget_checked),
        .O(budget_checked_i_1_n_0));
  FDCE budget_checked_reg
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_checked_i_1_n_0),
        .Q(budget_checked));
  LUT3 #(
    .INIT(8'hA8)) 
    budget_fault_INST_0
       (.I0(dest_arst),
        .I1(fault_held),
        .I2(fault_sync[2]),
        .O(budget_fault));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(\held_budget_reg[2]_0 [0]),
        .Q(budget_meta[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[10] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[10]),
        .Q(budget_meta[10]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[11] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[11]),
        .Q(budget_meta[11]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[12] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[12]),
        .Q(budget_meta[12]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[13] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[13]),
        .Q(budget_meta[13]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[14] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[14]),
        .Q(budget_meta[14]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[15] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[15]),
        .Q(budget_meta[15]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[16] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[16]),
        .Q(budget_meta[16]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[17] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[17]),
        .Q(budget_meta[17]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[18] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[18]),
        .Q(budget_meta[18]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[19] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[19]),
        .Q(budget_meta[19]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(\held_budget_reg[2]_0 [1]),
        .Q(budget_meta[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[20] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[20]),
        .Q(budget_meta[20]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[21] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[21]),
        .Q(budget_meta[21]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[22] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[22]),
        .Q(budget_meta[22]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[23] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[23]),
        .Q(budget_meta[23]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[24] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[24]),
        .Q(budget_meta[24]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[25] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[25]),
        .Q(budget_meta[25]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[26] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[26]),
        .Q(budget_meta[26]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[27] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[27]),
        .Q(budget_meta[27]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[28] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[28]),
        .Q(budget_meta[28]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[29] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[29]),
        .Q(budget_meta[29]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[2] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(\held_budget_reg[2]_0 [2]),
        .Q(budget_meta[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[30] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[30]),
        .Q(budget_meta[30]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[31] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[31]),
        .Q(budget_meta[31]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[32] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[32]),
        .Q(budget_meta[32]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[33] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[33]),
        .Q(budget_meta[33]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[34] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[34]),
        .Q(budget_meta[34]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[35] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[35]),
        .Q(budget_meta[35]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[36] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[36]),
        .Q(budget_meta[36]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[37] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[37]),
        .Q(budget_meta[37]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[38] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[38]),
        .Q(budget_meta[38]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[39] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[39]),
        .Q(budget_meta[39]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[3] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[3]),
        .Q(budget_meta[3]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[40] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[40]),
        .Q(budget_meta[40]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[41] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[41]),
        .Q(budget_meta[41]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[42] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[42]),
        .Q(budget_meta[42]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[43] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[43]),
        .Q(budget_meta[43]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[44] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[44]),
        .Q(budget_meta[44]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[45] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[45]),
        .Q(budget_meta[45]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[46] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[46]),
        .Q(budget_meta[46]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[47] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[47]),
        .Q(budget_meta[47]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[48] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[48]),
        .Q(budget_meta[48]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[49] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[49]),
        .Q(budget_meta[49]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[4] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[4]),
        .Q(budget_meta[4]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[50] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[50]),
        .Q(budget_meta[50]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[51] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[51]),
        .Q(budget_meta[51]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[52] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[52]),
        .Q(budget_meta[52]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[53] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[53]),
        .Q(budget_meta[53]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[54] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[54]),
        .Q(budget_meta[54]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[55] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[55]),
        .Q(budget_meta[55]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[56] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[56]),
        .Q(budget_meta[56]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[57] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[57]),
        .Q(budget_meta[57]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[58] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[58]),
        .Q(budget_meta[58]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[59] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[59]),
        .Q(budget_meta[59]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[5] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[5]),
        .Q(budget_meta[5]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[60] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[60]),
        .Q(budget_meta[60]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[61] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[61]),
        .Q(budget_meta[61]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[62] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[62]),
        .Q(budget_meta[62]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[63] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[63]),
        .Q(budget_meta[63]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[64] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[64]),
        .Q(budget_meta[64]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[65] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[65]),
        .Q(budget_meta[65]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[66] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[66]),
        .Q(budget_meta[66]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[67] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[67]),
        .Q(budget_meta[67]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[68] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[68]),
        .Q(budget_meta[68]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[69] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[69]),
        .Q(budget_meta[69]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[6] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[6]),
        .Q(budget_meta[6]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[70] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[70]),
        .Q(budget_meta[70]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[71] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[71]),
        .Q(budget_meta[71]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[72] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[72]),
        .Q(budget_meta[72]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[73] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[73]),
        .Q(budget_meta[73]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[74] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[74]),
        .Q(budget_meta[74]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[75] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[75]),
        .Q(budget_meta[75]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[76] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[76]),
        .Q(budget_meta[76]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[77] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[77]),
        .Q(budget_meta[77]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[78] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[78]),
        .Q(budget_meta[78]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[79] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[79]),
        .Q(budget_meta[79]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[7] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[7]),
        .Q(budget_meta[7]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[80] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[80]),
        .Q(budget_meta[80]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[81] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[81]),
        .Q(budget_meta[81]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[82] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[82]),
        .Q(budget_meta[82]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[83] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[83]),
        .Q(budget_meta[83]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[84] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[84]),
        .Q(budget_meta[84]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[85] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[85]),
        .Q(budget_meta[85]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[86] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[86]),
        .Q(budget_meta[86]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[87] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[87]),
        .Q(budget_meta[87]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[88] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[88]),
        .Q(budget_meta[88]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[89] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[89]),
        .Q(budget_meta[89]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[8] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[8]),
        .Q(budget_meta[8]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[90] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[90]),
        .Q(budget_meta[90]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[91] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[91]),
        .Q(budget_meta[91]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[92] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[92]),
        .Q(budget_meta[92]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[93] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[93]),
        .Q(budget_meta[93]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[94] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[94]),
        .Q(budget_meta[94]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[95] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[95]),
        .Q(budget_meta[95]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_meta_reg[9] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(held_budget[9]),
        .Q(budget_meta[9]));
  FDCE budget_product_ready_reg
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(1'b1),
        .Q(budget_product_ready));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[0]),
        .Q(budget_sync[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[10] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[10]),
        .Q(budget_sync[10]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[11] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[11]),
        .Q(budget_sync[11]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[12] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[12]),
        .Q(budget_sync[12]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[13] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[13]),
        .Q(budget_sync[13]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[14] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[14]),
        .Q(budget_sync[14]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[15] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[15]),
        .Q(budget_sync[15]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[16] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[16]),
        .Q(budget_sync[16]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[17] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[17]),
        .Q(budget_sync[17]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[18] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[18]),
        .Q(budget_sync[18]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[19] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[19]),
        .Q(budget_sync[19]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[1]),
        .Q(budget_sync[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[20] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[20]),
        .Q(budget_sync[20]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[21] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[21]),
        .Q(budget_sync[21]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[22] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[22]),
        .Q(budget_sync[22]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[23] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[23]),
        .Q(budget_sync[23]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[24] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[24]),
        .Q(budget_sync[24]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[25] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[25]),
        .Q(budget_sync[25]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[26] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[26]),
        .Q(budget_sync[26]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[27] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[27]),
        .Q(budget_sync[27]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[28] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[28]),
        .Q(budget_sync[28]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[29] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[29]),
        .Q(budget_sync[29]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[2] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[2]),
        .Q(budget_sync[2]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[30] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[30]),
        .Q(budget_sync[30]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[31] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[31]),
        .Q(budget_sync[31]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[32] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[32]),
        .Q(budget_sync[32]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[33] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[33]),
        .Q(budget_sync[33]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[34] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[34]),
        .Q(budget_sync[34]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[35] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[35]),
        .Q(budget_sync[35]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[36] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[36]),
        .Q(budget_sync[36]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[37] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[37]),
        .Q(budget_sync[37]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[38] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[38]),
        .Q(budget_sync[38]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[39] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[39]),
        .Q(budget_sync[39]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[3] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[3]),
        .Q(budget_sync[3]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[40] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[40]),
        .Q(budget_sync[40]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[41] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[41]),
        .Q(budget_sync[41]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[42] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[42]),
        .Q(budget_sync[42]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[43] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[43]),
        .Q(budget_sync[43]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[44] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[44]),
        .Q(budget_sync[44]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[45] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[45]),
        .Q(budget_sync[45]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[46] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[46]),
        .Q(budget_sync[46]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[47] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[47]),
        .Q(budget_sync[47]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[48] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[48]),
        .Q(budget_sync[48]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[49] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[49]),
        .Q(budget_sync[49]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[4] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[4]),
        .Q(budget_sync[4]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[50] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[50]),
        .Q(budget_sync[50]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[51] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[51]),
        .Q(budget_sync[51]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[52] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[52]),
        .Q(budget_sync[52]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[53] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[53]),
        .Q(budget_sync[53]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[54] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[54]),
        .Q(budget_sync[54]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[55] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[55]),
        .Q(budget_sync[55]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[56] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[56]),
        .Q(budget_sync[56]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[57] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[57]),
        .Q(budget_sync[57]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[58] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[58]),
        .Q(budget_sync[58]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[59] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[59]),
        .Q(budget_sync[59]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[5] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[5]),
        .Q(budget_sync[5]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[60] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[60]),
        .Q(budget_sync[60]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[61] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[61]),
        .Q(budget_sync[61]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[62] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[62]),
        .Q(budget_sync[62]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[63] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[63]),
        .Q(budget_sync[63]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[64] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[64]),
        .Q(budget_sync[64]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[65] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[65]),
        .Q(budget_sync[65]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[66] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[66]),
        .Q(budget_sync[66]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[67] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[67]),
        .Q(budget_sync[67]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[68] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[68]),
        .Q(budget_sync[68]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[69] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[69]),
        .Q(budget_sync[69]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[6] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[6]),
        .Q(budget_sync[6]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[70] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[70]),
        .Q(budget_sync[70]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[71] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[71]),
        .Q(budget_sync[71]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[72] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[72]),
        .Q(budget_sync[72]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[73] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[73]),
        .Q(budget_sync[73]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[74] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[74]),
        .Q(budget_sync[74]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[75] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[75]),
        .Q(budget_sync[75]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[76] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[76]),
        .Q(budget_sync[76]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[77] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[77]),
        .Q(budget_sync[77]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[78] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[78]),
        .Q(budget_sync[78]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[79] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[79]),
        .Q(budget_sync[79]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[7] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[7]),
        .Q(budget_sync[7]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[80] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[80]),
        .Q(budget_sync[80]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[81] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[81]),
        .Q(budget_sync[81]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[82] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[82]),
        .Q(budget_sync[82]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[83] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[83]),
        .Q(budget_sync[83]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[84] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[84]),
        .Q(budget_sync[84]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[85] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[85]),
        .Q(budget_sync[85]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[86] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[86]),
        .Q(budget_sync[86]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[87] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[87]),
        .Q(budget_sync[87]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[88] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[88]),
        .Q(budget_sync[88]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[89] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[89]),
        .Q(budget_sync[89]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[8] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[8]),
        .Q(budget_sync[8]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[90] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[90]),
        .Q(budget_sync[90]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[91] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[91]),
        .Q(budget_sync[91]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[92] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[92]),
        .Q(budget_sync[92]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[93] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[93]),
        .Q(budget_sync[93]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[94] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[94]),
        .Q(budget_sync[94]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[95] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[95]),
        .Q(budget_sync[95]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \budget_sync_reg[9] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_meta[9]),
        .Q(budget_sync[9]));
  LUT5 #(
    .INIT(32'hFFFFEEEA)) 
    capture_source_fault_INST_0
       (.I0(capture_source_fault_0),
        .I1(dest_arst),
        .I2(fault_held),
        .I3(fault_sync[2]),
        .I4(dest_out),
        .O(capture_source_fault));
  LUT2 #(
    .INIT(4'h2)) 
    \closed_frame_count[31]_i_1 
       (.I0(request_sync[2]),
        .I1(closure_held),
        .O(closure_held0));
  LUT1 #(
    .INIT(2'h1)) 
    \closed_frame_count[31]_i_2 
       (.I0(dest_arst),
        .O(\closed_frame_count[31]_i_2_n_0 ));
  FDCE \closed_frame_count_reg[0] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[64]),
        .Q(Q[0]));
  FDCE \closed_frame_count_reg[10] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[74]),
        .Q(Q[10]));
  FDCE \closed_frame_count_reg[11] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[75]),
        .Q(Q[11]));
  FDCE \closed_frame_count_reg[12] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[76]),
        .Q(Q[12]));
  FDCE \closed_frame_count_reg[13] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[77]),
        .Q(Q[13]));
  FDCE \closed_frame_count_reg[14] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[78]),
        .Q(Q[14]));
  FDCE \closed_frame_count_reg[15] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[79]),
        .Q(Q[15]));
  FDCE \closed_frame_count_reg[16] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[80]),
        .Q(Q[16]));
  FDCE \closed_frame_count_reg[17] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[81]),
        .Q(Q[17]));
  FDCE \closed_frame_count_reg[18] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[82]),
        .Q(Q[18]));
  FDCE \closed_frame_count_reg[19] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[83]),
        .Q(Q[19]));
  FDCE \closed_frame_count_reg[1] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[65]),
        .Q(Q[1]));
  FDCE \closed_frame_count_reg[20] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[84]),
        .Q(Q[20]));
  FDCE \closed_frame_count_reg[21] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[85]),
        .Q(Q[21]));
  FDCE \closed_frame_count_reg[22] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[86]),
        .Q(Q[22]));
  FDCE \closed_frame_count_reg[23] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[87]),
        .Q(Q[23]));
  FDCE \closed_frame_count_reg[24] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[88]),
        .Q(Q[24]));
  FDCE \closed_frame_count_reg[25] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[89]),
        .Q(Q[25]));
  FDCE \closed_frame_count_reg[26] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[90]),
        .Q(Q[26]));
  FDCE \closed_frame_count_reg[27] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[91]),
        .Q(Q[27]));
  FDCE \closed_frame_count_reg[28] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[92]),
        .Q(Q[28]));
  FDCE \closed_frame_count_reg[29] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[93]),
        .Q(Q[29]));
  FDCE \closed_frame_count_reg[2] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[66]),
        .Q(Q[2]));
  FDCE \closed_frame_count_reg[30] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[94]),
        .Q(Q[30]));
  FDCE \closed_frame_count_reg[31] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[95]),
        .Q(Q[31]));
  FDCE \closed_frame_count_reg[3] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[67]),
        .Q(Q[3]));
  FDCE \closed_frame_count_reg[4] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[68]),
        .Q(Q[4]));
  FDCE \closed_frame_count_reg[5] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[69]),
        .Q(Q[5]));
  FDCE \closed_frame_count_reg[6] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[70]),
        .Q(Q[6]));
  FDCE \closed_frame_count_reg[7] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[71]),
        .Q(Q[7]));
  FDCE \closed_frame_count_reg[8] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[72]),
        .Q(Q[8]));
  FDCE \closed_frame_count_reg[9] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[73]),
        .Q(Q[9]));
  FDCE \closed_pixel_count_reg[0] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[0]),
        .Q(closed_pixel_count[0]));
  FDCE \closed_pixel_count_reg[10] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[10]),
        .Q(closed_pixel_count[10]));
  FDCE \closed_pixel_count_reg[11] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[11]),
        .Q(closed_pixel_count[11]));
  FDCE \closed_pixel_count_reg[12] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[12]),
        .Q(closed_pixel_count[12]));
  FDCE \closed_pixel_count_reg[13] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[13]),
        .Q(closed_pixel_count[13]));
  FDCE \closed_pixel_count_reg[14] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[14]),
        .Q(closed_pixel_count[14]));
  FDCE \closed_pixel_count_reg[15] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[15]),
        .Q(closed_pixel_count[15]));
  FDCE \closed_pixel_count_reg[16] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[16]),
        .Q(closed_pixel_count[16]));
  FDCE \closed_pixel_count_reg[17] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[17]),
        .Q(closed_pixel_count[17]));
  FDCE \closed_pixel_count_reg[18] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[18]),
        .Q(closed_pixel_count[18]));
  FDCE \closed_pixel_count_reg[19] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[19]),
        .Q(closed_pixel_count[19]));
  FDCE \closed_pixel_count_reg[1] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[1]),
        .Q(closed_pixel_count[1]));
  FDCE \closed_pixel_count_reg[20] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[20]),
        .Q(closed_pixel_count[20]));
  FDCE \closed_pixel_count_reg[21] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[21]),
        .Q(closed_pixel_count[21]));
  FDCE \closed_pixel_count_reg[22] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[22]),
        .Q(closed_pixel_count[22]));
  FDCE \closed_pixel_count_reg[23] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[23]),
        .Q(closed_pixel_count[23]));
  FDCE \closed_pixel_count_reg[24] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[24]),
        .Q(closed_pixel_count[24]));
  FDCE \closed_pixel_count_reg[25] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[25]),
        .Q(closed_pixel_count[25]));
  FDCE \closed_pixel_count_reg[26] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[26]),
        .Q(closed_pixel_count[26]));
  FDCE \closed_pixel_count_reg[27] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[27]),
        .Q(closed_pixel_count[27]));
  FDCE \closed_pixel_count_reg[28] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[28]),
        .Q(closed_pixel_count[28]));
  FDCE \closed_pixel_count_reg[29] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[29]),
        .Q(closed_pixel_count[29]));
  FDCE \closed_pixel_count_reg[2] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[2]),
        .Q(closed_pixel_count[2]));
  FDCE \closed_pixel_count_reg[30] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[30]),
        .Q(closed_pixel_count[30]));
  FDCE \closed_pixel_count_reg[31] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[31]),
        .Q(closed_pixel_count[31]));
  FDCE \closed_pixel_count_reg[32] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[32]),
        .Q(closed_pixel_count[32]));
  FDCE \closed_pixel_count_reg[33] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[33]),
        .Q(closed_pixel_count[33]));
  FDCE \closed_pixel_count_reg[34] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[34]),
        .Q(closed_pixel_count[34]));
  FDCE \closed_pixel_count_reg[35] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[35]),
        .Q(closed_pixel_count[35]));
  FDCE \closed_pixel_count_reg[36] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[36]),
        .Q(closed_pixel_count[36]));
  FDCE \closed_pixel_count_reg[37] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[37]),
        .Q(closed_pixel_count[37]));
  FDCE \closed_pixel_count_reg[38] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[38]),
        .Q(closed_pixel_count[38]));
  FDCE \closed_pixel_count_reg[39] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[39]),
        .Q(closed_pixel_count[39]));
  FDCE \closed_pixel_count_reg[3] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[3]),
        .Q(closed_pixel_count[3]));
  FDCE \closed_pixel_count_reg[40] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[40]),
        .Q(closed_pixel_count[40]));
  FDCE \closed_pixel_count_reg[41] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[41]),
        .Q(closed_pixel_count[41]));
  FDCE \closed_pixel_count_reg[42] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[42]),
        .Q(closed_pixel_count[42]));
  FDCE \closed_pixel_count_reg[43] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[43]),
        .Q(closed_pixel_count[43]));
  FDCE \closed_pixel_count_reg[44] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[44]),
        .Q(closed_pixel_count[44]));
  FDCE \closed_pixel_count_reg[45] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[45]),
        .Q(closed_pixel_count[45]));
  FDCE \closed_pixel_count_reg[46] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[46]),
        .Q(closed_pixel_count[46]));
  FDCE \closed_pixel_count_reg[47] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[47]),
        .Q(closed_pixel_count[47]));
  FDCE \closed_pixel_count_reg[48] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[48]),
        .Q(closed_pixel_count[48]));
  FDCE \closed_pixel_count_reg[49] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[49]),
        .Q(closed_pixel_count[49]));
  FDCE \closed_pixel_count_reg[4] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[4]),
        .Q(closed_pixel_count[4]));
  FDCE \closed_pixel_count_reg[50] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[50]),
        .Q(closed_pixel_count[50]));
  FDCE \closed_pixel_count_reg[51] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[51]),
        .Q(closed_pixel_count[51]));
  FDCE \closed_pixel_count_reg[52] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[52]),
        .Q(closed_pixel_count[52]));
  FDCE \closed_pixel_count_reg[53] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[53]),
        .Q(closed_pixel_count[53]));
  FDCE \closed_pixel_count_reg[54] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[54]),
        .Q(closed_pixel_count[54]));
  FDCE \closed_pixel_count_reg[55] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[55]),
        .Q(closed_pixel_count[55]));
  FDCE \closed_pixel_count_reg[56] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[56]),
        .Q(closed_pixel_count[56]));
  FDCE \closed_pixel_count_reg[57] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[57]),
        .Q(closed_pixel_count[57]));
  FDCE \closed_pixel_count_reg[58] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[58]),
        .Q(closed_pixel_count[58]));
  FDCE \closed_pixel_count_reg[59] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[59]),
        .Q(closed_pixel_count[59]));
  FDCE \closed_pixel_count_reg[5] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[5]),
        .Q(closed_pixel_count[5]));
  FDCE \closed_pixel_count_reg[60] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[60]),
        .Q(closed_pixel_count[60]));
  FDCE \closed_pixel_count_reg[61] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[61]),
        .Q(closed_pixel_count[61]));
  FDCE \closed_pixel_count_reg[62] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[62]),
        .Q(closed_pixel_count[62]));
  FDCE \closed_pixel_count_reg[63] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[63]),
        .Q(closed_pixel_count[63]));
  FDCE \closed_pixel_count_reg[6] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[6]),
        .Q(closed_pixel_count[6]));
  FDCE \closed_pixel_count_reg[7] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[7]),
        .Q(closed_pixel_count[7]));
  FDCE \closed_pixel_count_reg[8] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[8]),
        .Q(closed_pixel_count[8]));
  FDCE \closed_pixel_count_reg[9] 
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(budget_sync[9]),
        .Q(closed_pixel_count[9]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry__0_i_5
       (.I0(Q[14]),
        .I1(out[14]),
        .I2(out[15]),
        .I3(Q[15]),
        .O(\closed_frame_count_reg[14]_2 [3]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry__0_i_6
       (.I0(Q[12]),
        .I1(out[12]),
        .I2(out[13]),
        .I3(Q[13]),
        .O(\closed_frame_count_reg[14]_2 [2]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry__0_i_7
       (.I0(Q[10]),
        .I1(out[10]),
        .I2(out[11]),
        .I3(Q[11]),
        .O(\closed_frame_count_reg[14]_2 [1]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry__0_i_8
       (.I0(Q[8]),
        .I1(out[8]),
        .I2(out[9]),
        .I3(Q[9]),
        .O(\closed_frame_count_reg[14]_2 [0]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry__1_i_5
       (.I0(Q[22]),
        .I1(out[22]),
        .I2(out[23]),
        .I3(Q[23]),
        .O(\closed_frame_count_reg[22]_2 [3]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry__1_i_6
       (.I0(Q[20]),
        .I1(out[20]),
        .I2(out[21]),
        .I3(Q[21]),
        .O(\closed_frame_count_reg[22]_2 [2]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry__1_i_7
       (.I0(Q[18]),
        .I1(out[18]),
        .I2(out[19]),
        .I3(Q[19]),
        .O(\closed_frame_count_reg[22]_2 [1]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry__1_i_8
       (.I0(Q[16]),
        .I1(out[16]),
        .I2(out[17]),
        .I3(Q[17]),
        .O(\closed_frame_count_reg[22]_2 [0]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry__2_i_5
       (.I0(Q[30]),
        .I1(out[30]),
        .I2(out[31]),
        .I3(Q[31]),
        .O(\closed_frame_count_reg[30]_2 [3]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry__2_i_6
       (.I0(Q[28]),
        .I1(out[28]),
        .I2(out[29]),
        .I3(Q[29]),
        .O(\closed_frame_count_reg[30]_2 [2]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry__2_i_7
       (.I0(Q[26]),
        .I1(out[26]),
        .I2(out[27]),
        .I3(Q[27]),
        .O(\closed_frame_count_reg[30]_2 [1]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry__2_i_8
       (.I0(Q[24]),
        .I1(out[24]),
        .I2(out[25]),
        .I3(Q[25]),
        .O(\closed_frame_count_reg[30]_2 [0]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry_i_5
       (.I0(Q[6]),
        .I1(out[6]),
        .I2(out[7]),
        .I3(Q[7]),
        .O(\closed_frame_count_reg[6]_1 [3]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry_i_6
       (.I0(Q[4]),
        .I1(out[4]),
        .I2(out[5]),
        .I3(Q[5]),
        .O(\closed_frame_count_reg[6]_1 [2]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry_i_7
       (.I0(Q[2]),
        .I1(out[2]),
        .I2(out[3]),
        .I3(Q[3]),
        .O(\closed_frame_count_reg[6]_1 [1]));
  LUT4 #(
    .INIT(16'h9009)) 
    closure_bad1_carry_i_8
       (.I0(Q[0]),
        .I1(out[0]),
        .I2(out[1]),
        .I3(Q[1]),
        .O(\closed_frame_count_reg[6]_1 [0]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    closure_bad2_carry__0_i_1
       (.I0(Q[23]),
        .I1(closure_bad2_carry__0[14]),
        .I2(Q[22]),
        .I3(closure_bad2_carry__0[13]),
        .I4(closure_bad2_carry__0[12]),
        .I5(Q[21]),
        .O(\closed_frame_count_reg[23]_0 [2]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    closure_bad2_carry__0_i_3
       (.I0(Q[17]),
        .I1(closure_bad2_carry__0[11]),
        .I2(Q[16]),
        .I3(closure_bad2_carry__0[10]),
        .I4(closure_bad2_carry__0[9]),
        .I5(Q[15]),
        .O(\closed_frame_count_reg[23]_0 [1]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    closure_bad2_carry__0_i_4
       (.I0(Q[14]),
        .I1(closure_bad2_carry__0[8]),
        .I2(Q[12]),
        .I3(closure_bad2_carry__0[6]),
        .I4(closure_bad2_carry__0[7]),
        .I5(Q[13]),
        .O(\closed_frame_count_reg[23]_0 [0]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    closure_bad2_carry_i_2
       (.I0(Q[8]),
        .I1(closure_bad2_carry__0[5]),
        .I2(Q[7]),
        .I3(closure_bad2_carry__0[4]),
        .I4(closure_bad2_carry__0[3]),
        .I5(Q[6]),
        .O(\closed_frame_count_reg[8]_0 [1]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    closure_bad2_carry_i_4
       (.I0(Q[2]),
        .I1(closure_bad2_carry__0[2]),
        .I2(Q[1]),
        .I3(closure_bad2_carry__0[1]),
        .I4(closure_bad2_carry__0[0]),
        .I5(Q[0]),
        .O(\closed_frame_count_reg[8]_0 [0]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'hFFFF8000)) 
    closure_held_i_1
       (.I0(budget_checked),
        .I1(closure_held),
        .I2(dest_arst),
        .I3(configuration_locked),
        .I4(closure_held_reg_1),
        .O(budget_checked_reg_1));
  FDCE closure_held_reg
       (.C(aclk),
        .CE(closure_held0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(1'b1),
        .Q(closure_held));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(1),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    expected_pixels0
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT({expected_pixels0_n_24,expected_pixels0_n_25,expected_pixels0_n_26,expected_pixels0_n_27,expected_pixels0_n_28,expected_pixels0_n_29,expected_pixels0_n_30,expected_pixels0_n_31,expected_pixels0_n_32,expected_pixels0_n_33,expected_pixels0_n_34,expected_pixels0_n_35,expected_pixels0_n_36,expected_pixels0_n_37,expected_pixels0_n_38,expected_pixels0_n_39,expected_pixels0_n_40,expected_pixels0_n_41,expected_pixels0_n_42,expected_pixels0_n_43,expected_pixels0_n_44,expected_pixels0_n_45,expected_pixels0_n_46,expected_pixels0_n_47,expected_pixels0_n_48,expected_pixels0_n_49,expected_pixels0_n_50,expected_pixels0_n_51,expected_pixels0_n_52,expected_pixels0_n_53}),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,Q[16:0]}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_expected_pixels0_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_expected_pixels0_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_expected_pixels0_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(1'b0),
        .CLK(1'b0),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_expected_pixels0_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_expected_pixels0_OVERFLOW_UNCONNECTED),
        .P({expected_pixels0_n_58,expected_pixels0_n_59,expected_pixels0_n_60,expected_pixels0_n_61,expected_pixels0_n_62,expected_pixels0_n_63,expected_pixels0_n_64,expected_pixels0_n_65,expected_pixels0_n_66,expected_pixels0_n_67,expected_pixels0_n_68,expected_pixels0_n_69,expected_pixels0_n_70,expected_pixels0_n_71,expected_pixels0_n_72,expected_pixels0_n_73,expected_pixels0_n_74,expected_pixels0_n_75,expected_pixels0_n_76,expected_pixels0_n_77,expected_pixels0_n_78,expected_pixels0_n_79,expected_pixels0_n_80,expected_pixels0_n_81,expected_pixels0_n_82,expected_pixels0_n_83,expected_pixels0_n_84,expected_pixels0_n_85,expected_pixels0_n_86,expected_pixels0_n_87,expected_pixels0_n_88,expected_pixels0_n_89,expected_pixels0_n_90,expected_pixels0_n_91,expected_pixels0_n_92,expected_pixels0_n_93,expected_pixels0_n_94,expected_pixels0_n_95,expected_pixels0_n_96,expected_pixels0_n_97,expected_pixels0_n_98,expected_pixels0_n_99,expected_pixels0_n_100,expected_pixels0_n_101,expected_pixels0_n_102,expected_pixels0_n_103,expected_pixels0_n_104,expected_pixels0_n_105}),
        .PATTERNBDETECT(NLW_expected_pixels0_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_expected_pixels0_PATTERNDETECT_UNCONNECTED),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT({expected_pixels0_n_106,expected_pixels0_n_107,expected_pixels0_n_108,expected_pixels0_n_109,expected_pixels0_n_110,expected_pixels0_n_111,expected_pixels0_n_112,expected_pixels0_n_113,expected_pixels0_n_114,expected_pixels0_n_115,expected_pixels0_n_116,expected_pixels0_n_117,expected_pixels0_n_118,expected_pixels0_n_119,expected_pixels0_n_120,expected_pixels0_n_121,expected_pixels0_n_122,expected_pixels0_n_123,expected_pixels0_n_124,expected_pixels0_n_125,expected_pixels0_n_126,expected_pixels0_n_127,expected_pixels0_n_128,expected_pixels0_n_129,expected_pixels0_n_130,expected_pixels0_n_131,expected_pixels0_n_132,expected_pixels0_n_133,expected_pixels0_n_134,expected_pixels0_n_135,expected_pixels0_n_136,expected_pixels0_n_137,expected_pixels0_n_138,expected_pixels0_n_139,expected_pixels0_n_140,expected_pixels0_n_141,expected_pixels0_n_142,expected_pixels0_n_143,expected_pixels0_n_144,expected_pixels0_n_145,expected_pixels0_n_146,expected_pixels0_n_147,expected_pixels0_n_148,expected_pixels0_n_149,expected_pixels0_n_150,expected_pixels0_n_151,expected_pixels0_n_152,expected_pixels0_n_153}),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_expected_pixels0_UNDERFLOW_UNCONNECTED));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-12 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("CASCADE"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(1),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    expected_pixels0__0
       (.A({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACIN({expected_pixels0_n_24,expected_pixels0_n_25,expected_pixels0_n_26,expected_pixels0_n_27,expected_pixels0_n_28,expected_pixels0_n_29,expected_pixels0_n_30,expected_pixels0_n_31,expected_pixels0_n_32,expected_pixels0_n_33,expected_pixels0_n_34,expected_pixels0_n_35,expected_pixels0_n_36,expected_pixels0_n_37,expected_pixels0_n_38,expected_pixels0_n_39,expected_pixels0_n_40,expected_pixels0_n_41,expected_pixels0_n_42,expected_pixels0_n_43,expected_pixels0_n_44,expected_pixels0_n_45,expected_pixels0_n_46,expected_pixels0_n_47,expected_pixels0_n_48,expected_pixels0_n_49,expected_pixels0_n_50,expected_pixels0_n_51,expected_pixels0_n_52,expected_pixels0_n_53}),
        .ACOUT(NLW_expected_pixels0__0_ACOUT_UNCONNECTED[29:0]),
        .ALUMODE({1'b0,1'b0,1'b0,1'b0}),
        .B({1'b0,1'b0,1'b0,Q[31:17]}),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_expected_pixels0__0_BCOUT_UNCONNECTED[17:0]),
        .C({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_expected_pixels0__0_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYINSEL({1'b0,1'b0,1'b0}),
        .CARRYOUT(NLW_expected_pixels0__0_CARRYOUT_UNCONNECTED[3:0]),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEAD(1'b0),
        .CEALUMODE(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEC(1'b0),
        .CECARRYIN(1'b0),
        .CECTRL(1'b0),
        .CED(1'b0),
        .CEINMODE(1'b0),
        .CEM(1'b0),
        .CEP(budget_product_ready0),
        .CLK(aclk),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .INMODE({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .MULTSIGNIN(1'b0),
        .MULTSIGNOUT(NLW_expected_pixels0__0_MULTSIGNOUT_UNCONNECTED),
        .OPMODE({1'b1,1'b0,1'b1,1'b0,1'b1,1'b0,1'b1}),
        .OVERFLOW(NLW_expected_pixels0__0_OVERFLOW_UNCONNECTED),
        .P({expected_pixels0__0_n_58,expected_pixels0__0_n_59,expected_pixels0__0_n_60,expected_pixels0__0_n_61,expected_pixels0__0_n_62,expected_pixels0__0_n_63,expected_pixels0__0_n_64,expected_pixels0__0_n_65,expected_pixels0__0_n_66,expected_pixels0__0_n_67,expected_pixels0__0_n_68,expected_pixels0__0_n_69,expected_pixels0__0_n_70,expected_pixels0__0_n_71,expected_pixels0__0_n_72,expected_pixels0__0_n_73,expected_pixels0__0_n_74,expected_pixels0__0_n_75,expected_pixels0__0_n_76,expected_pixels0__0_n_77,expected_pixels0__0_n_78,expected_pixels0__0_n_79,expected_pixels0__0_n_80,expected_pixels0__0_n_81,expected_pixels0__0_n_82,expected_pixels0__0_n_83,expected_pixels0__0_n_84,expected_pixels0__0_n_85,expected_pixels0__0_n_86,expected_pixels0__0_n_87,expected_pixels0__0_n_88,expected_pixels0__0_n_89,expected_pixels0__0_n_90,expected_pixels0__0_n_91,expected_pixels0__0_n_92,expected_pixels0__0_n_93,expected_pixels0__0_n_94,expected_pixels0__0_n_95,expected_pixels0__0_n_96,expected_pixels0__0_n_97,expected_pixels0__0_n_98,expected_pixels0__0_n_99,expected_pixels0__0_n_100,expected_pixels0__0_n_101,expected_pixels0__0_n_102,expected_pixels0__0_n_103,expected_pixels0__0_n_104,expected_pixels0__0_n_105}),
        .PATTERNBDETECT(NLW_expected_pixels0__0_PATTERNBDETECT_UNCONNECTED),
        .PATTERNDETECT(NLW_expected_pixels0__0_PATTERNDETECT_UNCONNECTED),
        .PCIN({expected_pixels0_n_106,expected_pixels0_n_107,expected_pixels0_n_108,expected_pixels0_n_109,expected_pixels0_n_110,expected_pixels0_n_111,expected_pixels0_n_112,expected_pixels0_n_113,expected_pixels0_n_114,expected_pixels0_n_115,expected_pixels0_n_116,expected_pixels0_n_117,expected_pixels0_n_118,expected_pixels0_n_119,expected_pixels0_n_120,expected_pixels0_n_121,expected_pixels0_n_122,expected_pixels0_n_123,expected_pixels0_n_124,expected_pixels0_n_125,expected_pixels0_n_126,expected_pixels0_n_127,expected_pixels0_n_128,expected_pixels0_n_129,expected_pixels0_n_130,expected_pixels0_n_131,expected_pixels0_n_132,expected_pixels0_n_133,expected_pixels0_n_134,expected_pixels0_n_135,expected_pixels0_n_136,expected_pixels0_n_137,expected_pixels0_n_138,expected_pixels0_n_139,expected_pixels0_n_140,expected_pixels0_n_141,expected_pixels0_n_142,expected_pixels0_n_143,expected_pixels0_n_144,expected_pixels0_n_145,expected_pixels0_n_146,expected_pixels0_n_147,expected_pixels0_n_148,expected_pixels0_n_149,expected_pixels0_n_150,expected_pixels0_n_151,expected_pixels0_n_152,expected_pixels0_n_153}),
        .PCOUT(NLW_expected_pixels0__0_PCOUT_UNCONNECTED[47:0]),
        .RSTA(1'b0),
        .RSTALLCARRYIN(1'b0),
        .RSTALUMODE(1'b0),
        .RSTB(1'b0),
        .RSTC(1'b0),
        .RSTCTRL(1'b0),
        .RSTD(1'b0),
        .RSTINMODE(1'b0),
        .RSTM(1'b0),
        .RSTP(1'b0),
        .UNDERFLOW(NLW_expected_pixels0__0_UNDERFLOW_UNCONNECTED));
  LUT2 #(
    .INIT(4'h2)) 
    \expected_pixels[16]_i_1 
       (.I0(closure_held),
        .I1(budget_product_ready),
        .O(budget_product_ready0));
  FDCE \expected_pixels_reg[0] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_105),
        .Q(expected_pixels_reg[0]));
  FDCE \expected_pixels_reg[10] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_95),
        .Q(expected_pixels_reg[10]));
  FDCE \expected_pixels_reg[11] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_94),
        .Q(expected_pixels_reg[11]));
  FDCE \expected_pixels_reg[12] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_93),
        .Q(expected_pixels_reg[12]));
  FDCE \expected_pixels_reg[13] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_92),
        .Q(expected_pixels_reg[13]));
  FDCE \expected_pixels_reg[14] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_91),
        .Q(expected_pixels_reg[14]));
  FDCE \expected_pixels_reg[15] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_90),
        .Q(expected_pixels_reg[15]));
  FDCE \expected_pixels_reg[16] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_89),
        .Q(expected_pixels_reg[16]));
  FDCE \expected_pixels_reg[1] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_104),
        .Q(expected_pixels_reg[1]));
  FDCE \expected_pixels_reg[2] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_103),
        .Q(expected_pixels_reg[2]));
  FDCE \expected_pixels_reg[3] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_102),
        .Q(expected_pixels_reg[3]));
  FDCE \expected_pixels_reg[4] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_101),
        .Q(expected_pixels_reg[4]));
  FDCE \expected_pixels_reg[5] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_100),
        .Q(expected_pixels_reg[5]));
  FDCE \expected_pixels_reg[6] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_99),
        .Q(expected_pixels_reg[6]));
  FDCE \expected_pixels_reg[7] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_98),
        .Q(expected_pixels_reg[7]));
  FDCE \expected_pixels_reg[8] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_97),
        .Q(expected_pixels_reg[8]));
  FDCE \expected_pixels_reg[9] 
       (.C(aclk),
        .CE(budget_product_ready0),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(expected_pixels0_n_96),
        .Q(expected_pixels_reg[9]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \fault_causes[0]_i_1 
       (.I0(dma_fault),
        .I1(capture_fault),
        .I2(cpu_command_fault),
        .I3(capture_source_fault),
        .I4(owner_fault_causes),
        .O(dma_fault_0));
  CARRY4 fault_held2_carry
       (.CI(1'b0),
        .CO({fault_held2_carry_n_0,fault_held2_carry_n_1,fault_held2_carry_n_2,fault_held2_carry_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_fault_held2_carry_O_UNCONNECTED[3:0]),
        .S({fault_held2_carry_i_1_n_0,fault_held2_carry_i_2_n_0,fault_held2_carry_i_3_n_0,fault_held2_carry_i_4_n_0}));
  CARRY4 fault_held2_carry__0
       (.CI(fault_held2_carry_n_0),
        .CO({fault_held2_carry__0_n_0,fault_held2_carry__0_n_1,fault_held2_carry__0_n_2,fault_held2_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_fault_held2_carry__0_O_UNCONNECTED[3:0]),
        .S({fault_held2_carry__0_i_1_n_0,fault_held2_carry__0_i_2_n_0,fault_held2_carry__0_i_3_n_0,fault_held2_carry__0_i_4_n_0}));
  LUT4 #(
    .INIT(16'h0087)) 
    fault_held2_carry__0_i_1
       (.I0(expected_pixels0__0_n_99),
        .I1(budget_product_ready),
        .I2(closed_pixel_count[23]),
        .I3(fault_held2_carry__0_i_5_n_0),
        .O(fault_held2_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h0087)) 
    fault_held2_carry__0_i_2
       (.I0(expected_pixels0__0_n_102),
        .I1(budget_product_ready),
        .I2(closed_pixel_count[20]),
        .I3(fault_held2_carry__0_i_6_n_0),
        .O(fault_held2_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h0087)) 
    fault_held2_carry__0_i_3
       (.I0(expected_pixels0__0_n_105),
        .I1(budget_product_ready),
        .I2(closed_pixel_count[17]),
        .I3(fault_held2_carry__0_i_7_n_0),
        .O(fault_held2_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held2_carry__0_i_4
       (.I0(expected_pixels_reg[14]),
        .I1(closed_pixel_count[14]),
        .I2(closed_pixel_count[13]),
        .I3(expected_pixels_reg[13]),
        .I4(closed_pixel_count[12]),
        .I5(expected_pixels_reg[12]),
        .O(fault_held2_carry__0_i_4_n_0));
  LUT5 #(
    .INIT(32'h6FFFF6CC)) 
    fault_held2_carry__0_i_5
       (.I0(expected_pixels0__0_n_100),
        .I1(closed_pixel_count[22]),
        .I2(expected_pixels0__0_n_101),
        .I3(budget_product_ready),
        .I4(closed_pixel_count[21]),
        .O(fault_held2_carry__0_i_5_n_0));
  LUT5 #(
    .INIT(32'h6FFFF6CC)) 
    fault_held2_carry__0_i_6
       (.I0(expected_pixels0__0_n_103),
        .I1(closed_pixel_count[19]),
        .I2(expected_pixels0__0_n_104),
        .I3(budget_product_ready),
        .I4(closed_pixel_count[18]),
        .O(fault_held2_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h6FF6)) 
    fault_held2_carry__0_i_7
       (.I0(expected_pixels_reg[16]),
        .I1(closed_pixel_count[16]),
        .I2(expected_pixels_reg[15]),
        .I3(closed_pixel_count[15]),
        .O(fault_held2_carry__0_i_7_n_0));
  CARRY4 fault_held2_carry__1
       (.CI(fault_held2_carry__0_n_0),
        .CO({fault_held2_carry__1_n_0,fault_held2_carry__1_n_1,fault_held2_carry__1_n_2,fault_held2_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_fault_held2_carry__1_O_UNCONNECTED[3:0]),
        .S({fault_held2_carry__1_i_1_n_0,fault_held2_carry__1_i_2_n_0,fault_held2_carry__1_i_3_n_0,fault_held2_carry__1_i_4_n_0}));
  LUT4 #(
    .INIT(16'h0087)) 
    fault_held2_carry__1_i_1
       (.I0(expected_pixels0__0_n_87),
        .I1(budget_product_ready),
        .I2(closed_pixel_count[35]),
        .I3(fault_held2_carry__1_i_5_n_0),
        .O(fault_held2_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h0087)) 
    fault_held2_carry__1_i_2
       (.I0(expected_pixels0__0_n_90),
        .I1(budget_product_ready),
        .I2(closed_pixel_count[32]),
        .I3(fault_held2_carry__1_i_6_n_0),
        .O(fault_held2_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h0087)) 
    fault_held2_carry__1_i_3
       (.I0(expected_pixels0__0_n_93),
        .I1(budget_product_ready),
        .I2(closed_pixel_count[29]),
        .I3(fault_held2_carry__1_i_7_n_0),
        .O(fault_held2_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h0087)) 
    fault_held2_carry__1_i_4
       (.I0(expected_pixels0__0_n_96),
        .I1(budget_product_ready),
        .I2(closed_pixel_count[26]),
        .I3(fault_held2_carry__1_i_8_n_0),
        .O(fault_held2_carry__1_i_4_n_0));
  LUT5 #(
    .INIT(32'h6FFFF6CC)) 
    fault_held2_carry__1_i_5
       (.I0(expected_pixels0__0_n_88),
        .I1(closed_pixel_count[34]),
        .I2(expected_pixels0__0_n_89),
        .I3(budget_product_ready),
        .I4(closed_pixel_count[33]),
        .O(fault_held2_carry__1_i_5_n_0));
  LUT5 #(
    .INIT(32'h6FFFF6CC)) 
    fault_held2_carry__1_i_6
       (.I0(expected_pixels0__0_n_91),
        .I1(closed_pixel_count[31]),
        .I2(expected_pixels0__0_n_92),
        .I3(budget_product_ready),
        .I4(closed_pixel_count[30]),
        .O(fault_held2_carry__1_i_6_n_0));
  LUT5 #(
    .INIT(32'h6FFFF6CC)) 
    fault_held2_carry__1_i_7
       (.I0(expected_pixels0__0_n_95),
        .I1(closed_pixel_count[27]),
        .I2(expected_pixels0__0_n_94),
        .I3(budget_product_ready),
        .I4(closed_pixel_count[28]),
        .O(fault_held2_carry__1_i_7_n_0));
  LUT5 #(
    .INIT(32'h6FFFF6CC)) 
    fault_held2_carry__1_i_8
       (.I0(expected_pixels0__0_n_97),
        .I1(closed_pixel_count[25]),
        .I2(expected_pixels0__0_n_98),
        .I3(budget_product_ready),
        .I4(closed_pixel_count[24]),
        .O(fault_held2_carry__1_i_8_n_0));
  CARRY4 fault_held2_carry__2
       (.CI(fault_held2_carry__1_n_0),
        .CO({fault_held2_carry__2_n_0,fault_held2_carry__2_n_1,fault_held2_carry__2_n_2,fault_held2_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_fault_held2_carry__2_O_UNCONNECTED[3:0]),
        .S({fault_held2_carry__2_i_1_n_0,fault_held2_carry__2_i_2_n_0,fault_held2_carry__2_i_3_n_0,fault_held2_carry__2_i_4_n_0}));
  LUT4 #(
    .INIT(16'h0087)) 
    fault_held2_carry__2_i_1
       (.I0(expected_pixels0__0_n_75),
        .I1(budget_product_ready),
        .I2(closed_pixel_count[47]),
        .I3(fault_held2_carry__2_i_5_n_0),
        .O(fault_held2_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h802A)) 
    fault_held2_carry__2_i_2
       (.I0(fault_held2_carry__2_i_6_n_0),
        .I1(expected_pixels0__0_n_78),
        .I2(budget_product_ready),
        .I3(closed_pixel_count[44]),
        .O(fault_held2_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h802A)) 
    fault_held2_carry__2_i_3
       (.I0(fault_held2_carry__2_i_7_n_0),
        .I1(expected_pixels0__0_n_81),
        .I2(budget_product_ready),
        .I3(closed_pixel_count[41]),
        .O(fault_held2_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h802A)) 
    fault_held2_carry__2_i_4
       (.I0(fault_held2_carry__2_i_8_n_0),
        .I1(expected_pixels0__0_n_84),
        .I2(budget_product_ready),
        .I3(closed_pixel_count[38]),
        .O(fault_held2_carry__2_i_4_n_0));
  LUT5 #(
    .INIT(32'h6FFFF6CC)) 
    fault_held2_carry__2_i_5
       (.I0(expected_pixels0__0_n_76),
        .I1(closed_pixel_count[46]),
        .I2(expected_pixels0__0_n_77),
        .I3(budget_product_ready),
        .I4(closed_pixel_count[45]),
        .O(fault_held2_carry__2_i_5_n_0));
  LUT5 #(
    .INIT(32'h90000933)) 
    fault_held2_carry__2_i_6
       (.I0(expected_pixels0__0_n_79),
        .I1(closed_pixel_count[43]),
        .I2(expected_pixels0__0_n_80),
        .I3(budget_product_ready),
        .I4(closed_pixel_count[42]),
        .O(fault_held2_carry__2_i_6_n_0));
  LUT5 #(
    .INIT(32'h90000933)) 
    fault_held2_carry__2_i_7
       (.I0(expected_pixels0__0_n_82),
        .I1(closed_pixel_count[40]),
        .I2(expected_pixels0__0_n_83),
        .I3(budget_product_ready),
        .I4(closed_pixel_count[39]),
        .O(fault_held2_carry__2_i_7_n_0));
  LUT5 #(
    .INIT(32'h90000933)) 
    fault_held2_carry__2_i_8
       (.I0(expected_pixels0__0_n_85),
        .I1(closed_pixel_count[37]),
        .I2(expected_pixels0__0_n_86),
        .I3(budget_product_ready),
        .I4(closed_pixel_count[36]),
        .O(fault_held2_carry__2_i_8_n_0));
  CARRY4 fault_held2_carry__3
       (.CI(fault_held2_carry__2_n_0),
        .CO({fault_held2_carry__3_n_0,fault_held2_carry__3_n_1,fault_held2_carry__3_n_2,fault_held2_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_fault_held2_carry__3_O_UNCONNECTED[3:0]),
        .S({fault_held2_carry__3_i_1_n_0,fault_held2_carry__3_i_2_n_0,fault_held2_carry__3_i_3_n_0,fault_held2_carry__3_i_4_n_0}));
  LUT3 #(
    .INIT(8'h01)) 
    fault_held2_carry__3_i_1
       (.I0(closed_pixel_count[58]),
        .I1(closed_pixel_count[59]),
        .I2(closed_pixel_count[57]),
        .O(fault_held2_carry__3_i_1_n_0));
  LUT3 #(
    .INIT(8'h01)) 
    fault_held2_carry__3_i_2
       (.I0(closed_pixel_count[55]),
        .I1(closed_pixel_count[56]),
        .I2(closed_pixel_count[54]),
        .O(fault_held2_carry__3_i_2_n_0));
  LUT5 #(
    .INIT(32'h10000111)) 
    fault_held2_carry__3_i_3
       (.I0(closed_pixel_count[52]),
        .I1(closed_pixel_count[53]),
        .I2(expected_pixels0__0_n_71),
        .I3(budget_product_ready),
        .I4(closed_pixel_count[51]),
        .O(fault_held2_carry__3_i_3_n_0));
  LUT4 #(
    .INIT(16'h802A)) 
    fault_held2_carry__3_i_4
       (.I0(fault_held2_carry__3_i_5_n_0),
        .I1(expected_pixels0__0_n_72),
        .I2(budget_product_ready),
        .I3(closed_pixel_count[50]),
        .O(fault_held2_carry__3_i_4_n_0));
  LUT5 #(
    .INIT(32'h90000933)) 
    fault_held2_carry__3_i_5
       (.I0(expected_pixels0__0_n_73),
        .I1(closed_pixel_count[49]),
        .I2(expected_pixels0__0_n_74),
        .I3(budget_product_ready),
        .I4(closed_pixel_count[48]),
        .O(fault_held2_carry__3_i_5_n_0));
  CARRY4 fault_held2_carry__4
       (.CI(fault_held2_carry__3_n_0),
        .CO({NLW_fault_held2_carry__4_CO_UNCONNECTED[3:2],fault_held2,fault_held2_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b1,1'b1}),
        .O(NLW_fault_held2_carry__4_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,fault_held2_carry__4_i_1_n_0,fault_held2_carry__4_i_2_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    fault_held2_carry__4_i_1
       (.I0(closed_pixel_count[63]),
        .O(fault_held2_carry__4_i_1_n_0));
  LUT3 #(
    .INIT(8'h01)) 
    fault_held2_carry__4_i_2
       (.I0(closed_pixel_count[61]),
        .I1(closed_pixel_count[62]),
        .I2(closed_pixel_count[60]),
        .O(fault_held2_carry__4_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held2_carry_i_1
       (.I0(expected_pixels_reg[11]),
        .I1(closed_pixel_count[11]),
        .I2(closed_pixel_count[10]),
        .I3(expected_pixels_reg[10]),
        .I4(closed_pixel_count[9]),
        .I5(expected_pixels_reg[9]),
        .O(fault_held2_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held2_carry_i_2
       (.I0(closed_pixel_count[6]),
        .I1(expected_pixels_reg[6]),
        .I2(closed_pixel_count[7]),
        .I3(expected_pixels_reg[7]),
        .I4(expected_pixels_reg[8]),
        .I5(closed_pixel_count[8]),
        .O(fault_held2_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held2_carry_i_3
       (.I0(closed_pixel_count[5]),
        .I1(expected_pixels_reg[5]),
        .I2(closed_pixel_count[3]),
        .I3(expected_pixels_reg[3]),
        .I4(expected_pixels_reg[4]),
        .I5(closed_pixel_count[4]),
        .O(fault_held2_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held2_carry_i_4
       (.I0(closed_pixel_count[2]),
        .I1(expected_pixels_reg[2]),
        .I2(closed_pixel_count[0]),
        .I3(expected_pixels_reg[0]),
        .I4(expected_pixels_reg[1]),
        .I5(closed_pixel_count[1]),
        .O(fault_held2_carry_i_4_n_0));
  CARRY4 fault_held4_carry
       (.CI(1'b0),
        .CO({fault_held4_carry_n_0,fault_held4_carry_n_1,fault_held4_carry_n_2,fault_held4_carry_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_fault_held4_carry_O_UNCONNECTED[3:0]),
        .S({fault_held4_carry_i_1_n_0,fault_held4_carry_i_2_n_0,fault_held4_carry_i_3_n_0,fault_held4_carry_i_4_n_0}));
  CARRY4 fault_held4_carry__0
       (.CI(fault_held4_carry_n_0),
        .CO({fault_held4_carry__0_n_0,fault_held4_carry__0_n_1,fault_held4_carry__0_n_2,fault_held4_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_fault_held4_carry__0_O_UNCONNECTED[3:0]),
        .S({fault_held4_carry__0_i_1_n_0,fault_held4_carry__0_i_2_n_0,fault_held4_carry__0_i_3_n_0,fault_held4_carry__0_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__0_i_1
       (.I0(budget_sync[23]),
        .I1(closed_pixel_count[23]),
        .I2(closed_pixel_count[21]),
        .I3(budget_sync[21]),
        .I4(closed_pixel_count[22]),
        .I5(budget_sync[22]),
        .O(fault_held4_carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__0_i_2
       (.I0(budget_sync[20]),
        .I1(closed_pixel_count[20]),
        .I2(closed_pixel_count[18]),
        .I3(budget_sync[18]),
        .I4(closed_pixel_count[19]),
        .I5(budget_sync[19]),
        .O(fault_held4_carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__0_i_3
       (.I0(budget_sync[17]),
        .I1(closed_pixel_count[17]),
        .I2(closed_pixel_count[15]),
        .I3(budget_sync[15]),
        .I4(closed_pixel_count[16]),
        .I5(budget_sync[16]),
        .O(fault_held4_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__0_i_4
       (.I0(budget_sync[14]),
        .I1(closed_pixel_count[14]),
        .I2(closed_pixel_count[12]),
        .I3(budget_sync[12]),
        .I4(closed_pixel_count[13]),
        .I5(budget_sync[13]),
        .O(fault_held4_carry__0_i_4_n_0));
  CARRY4 fault_held4_carry__1
       (.CI(fault_held4_carry__0_n_0),
        .CO({fault_held4_carry__1_n_0,fault_held4_carry__1_n_1,fault_held4_carry__1_n_2,fault_held4_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_fault_held4_carry__1_O_UNCONNECTED[3:0]),
        .S({fault_held4_carry__1_i_1_n_0,fault_held4_carry__1_i_2_n_0,fault_held4_carry__1_i_3_n_0,fault_held4_carry__1_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__1_i_1
       (.I0(budget_sync[35]),
        .I1(closed_pixel_count[35]),
        .I2(closed_pixel_count[33]),
        .I3(budget_sync[33]),
        .I4(closed_pixel_count[34]),
        .I5(budget_sync[34]),
        .O(fault_held4_carry__1_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__1_i_2
       (.I0(budget_sync[32]),
        .I1(closed_pixel_count[32]),
        .I2(closed_pixel_count[31]),
        .I3(budget_sync[31]),
        .I4(closed_pixel_count[30]),
        .I5(budget_sync[30]),
        .O(fault_held4_carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__1_i_3
       (.I0(budget_sync[29]),
        .I1(closed_pixel_count[29]),
        .I2(closed_pixel_count[28]),
        .I3(budget_sync[28]),
        .I4(closed_pixel_count[27]),
        .I5(budget_sync[27]),
        .O(fault_held4_carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__1_i_4
       (.I0(budget_sync[26]),
        .I1(closed_pixel_count[26]),
        .I2(closed_pixel_count[24]),
        .I3(budget_sync[24]),
        .I4(closed_pixel_count[25]),
        .I5(budget_sync[25]),
        .O(fault_held4_carry__1_i_4_n_0));
  CARRY4 fault_held4_carry__2
       (.CI(fault_held4_carry__1_n_0),
        .CO({fault_held4_carry__2_n_0,fault_held4_carry__2_n_1,fault_held4_carry__2_n_2,fault_held4_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_fault_held4_carry__2_O_UNCONNECTED[3:0]),
        .S({fault_held4_carry__2_i_1_n_0,fault_held4_carry__2_i_2_n_0,fault_held4_carry__2_i_3_n_0,fault_held4_carry__2_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__2_i_1
       (.I0(budget_sync[47]),
        .I1(closed_pixel_count[47]),
        .I2(closed_pixel_count[46]),
        .I3(budget_sync[46]),
        .I4(closed_pixel_count[45]),
        .I5(budget_sync[45]),
        .O(fault_held4_carry__2_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__2_i_2
       (.I0(closed_pixel_count[44]),
        .I1(budget_sync[44]),
        .I2(closed_pixel_count[42]),
        .I3(budget_sync[42]),
        .I4(budget_sync[43]),
        .I5(closed_pixel_count[43]),
        .O(fault_held4_carry__2_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__2_i_3
       (.I0(closed_pixel_count[41]),
        .I1(budget_sync[41]),
        .I2(closed_pixel_count[39]),
        .I3(budget_sync[39]),
        .I4(budget_sync[40]),
        .I5(closed_pixel_count[40]),
        .O(fault_held4_carry__2_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__2_i_4
       (.I0(closed_pixel_count[38]),
        .I1(budget_sync[38]),
        .I2(closed_pixel_count[36]),
        .I3(budget_sync[36]),
        .I4(budget_sync[37]),
        .I5(closed_pixel_count[37]),
        .O(fault_held4_carry__2_i_4_n_0));
  CARRY4 fault_held4_carry__3
       (.CI(fault_held4_carry__2_n_0),
        .CO({fault_held4_carry__3_n_0,fault_held4_carry__3_n_1,fault_held4_carry__3_n_2,fault_held4_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_fault_held4_carry__3_O_UNCONNECTED[3:0]),
        .S({fault_held4_carry__3_i_1_n_0,fault_held4_carry__3_i_2_n_0,fault_held4_carry__3_i_3_n_0,fault_held4_carry__3_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__3_i_1
       (.I0(budget_sync[59]),
        .I1(closed_pixel_count[59]),
        .I2(budget_sync[57]),
        .I3(closed_pixel_count[57]),
        .I4(closed_pixel_count[58]),
        .I5(budget_sync[58]),
        .O(fault_held4_carry__3_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__3_i_2
       (.I0(budget_sync[56]),
        .I1(closed_pixel_count[56]),
        .I2(budget_sync[54]),
        .I3(closed_pixel_count[54]),
        .I4(closed_pixel_count[55]),
        .I5(budget_sync[55]),
        .O(fault_held4_carry__3_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__3_i_3
       (.I0(budget_sync[53]),
        .I1(closed_pixel_count[53]),
        .I2(closed_pixel_count[51]),
        .I3(budget_sync[51]),
        .I4(closed_pixel_count[52]),
        .I5(budget_sync[52]),
        .O(fault_held4_carry__3_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__3_i_4
       (.I0(closed_pixel_count[50]),
        .I1(budget_sync[50]),
        .I2(closed_pixel_count[48]),
        .I3(budget_sync[48]),
        .I4(budget_sync[49]),
        .I5(closed_pixel_count[49]),
        .O(fault_held4_carry__3_i_4_n_0));
  CARRY4 fault_held4_carry__4
       (.CI(fault_held4_carry__3_n_0),
        .CO({fault_held4_carry__4_n_0,fault_held4_carry__4_n_1,fault_held4_carry__4_n_2,fault_held4_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_fault_held4_carry__4_O_UNCONNECTED[3:0]),
        .S({fault_held4_carry__4_i_1_n_0,fault_held4_carry__4_i_2_n_0,fault_held4_carry__4_i_3_n_0,fault_held4_carry__4_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__4_i_1
       (.I0(Q[5]),
        .I1(budget_sync[69]),
        .I2(Q[6]),
        .I3(budget_sync[70]),
        .I4(budget_sync[71]),
        .I5(Q[7]),
        .O(fault_held4_carry__4_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__4_i_2
       (.I0(budget_sync[68]),
        .I1(Q[4]),
        .I2(Q[2]),
        .I3(budget_sync[66]),
        .I4(Q[3]),
        .I5(budget_sync[67]),
        .O(fault_held4_carry__4_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__4_i_3
       (.I0(budget_sync[63]),
        .I1(closed_pixel_count[63]),
        .I2(Q[0]),
        .I3(budget_sync[64]),
        .I4(budget_sync[65]),
        .I5(Q[1]),
        .O(fault_held4_carry__4_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__4_i_4
       (.I0(budget_sync[62]),
        .I1(closed_pixel_count[62]),
        .I2(budget_sync[60]),
        .I3(closed_pixel_count[60]),
        .I4(closed_pixel_count[61]),
        .I5(budget_sync[61]),
        .O(fault_held4_carry__4_i_4_n_0));
  CARRY4 fault_held4_carry__5
       (.CI(fault_held4_carry__4_n_0),
        .CO({fault_held4_carry__5_n_0,fault_held4_carry__5_n_1,fault_held4_carry__5_n_2,fault_held4_carry__5_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_fault_held4_carry__5_O_UNCONNECTED[3:0]),
        .S({fault_held4_carry__5_i_1_n_0,fault_held4_carry__5_i_2_n_0,fault_held4_carry__5_i_3_n_0,fault_held4_carry__5_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__5_i_1
       (.I0(budget_sync[83]),
        .I1(Q[19]),
        .I2(Q[18]),
        .I3(budget_sync[82]),
        .I4(Q[17]),
        .I5(budget_sync[81]),
        .O(fault_held4_carry__5_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__5_i_2
       (.I0(Q[14]),
        .I1(budget_sync[78]),
        .I2(Q[15]),
        .I3(budget_sync[79]),
        .I4(budget_sync[80]),
        .I5(Q[16]),
        .O(fault_held4_carry__5_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__5_i_3
       (.I0(Q[13]),
        .I1(budget_sync[77]),
        .I2(Q[11]),
        .I3(budget_sync[75]),
        .I4(budget_sync[76]),
        .I5(Q[12]),
        .O(fault_held4_carry__5_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__5_i_4
       (.I0(budget_sync[73]),
        .I1(Q[9]),
        .I2(Q[10]),
        .I3(budget_sync[74]),
        .I4(Q[8]),
        .I5(budget_sync[72]),
        .O(fault_held4_carry__5_i_4_n_0));
  CARRY4 fault_held4_carry__6
       (.CI(fault_held4_carry__5_n_0),
        .CO({fault_held4,fault_held4_carry__6_n_1,fault_held4_carry__6_n_2,fault_held4_carry__6_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_fault_held4_carry__6_O_UNCONNECTED[3:0]),
        .S({fault_held4_carry__6_i_1_n_0,fault_held4_carry__6_i_2_n_0,fault_held4_carry__6_i_3_n_0,fault_held4_carry__6_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__6_i_1
       (.I0(Q[30]),
        .I1(budget_sync[94]),
        .I2(Q[29]),
        .I3(budget_sync[93]),
        .I4(budget_sync[95]),
        .I5(Q[31]),
        .O(fault_held4_carry__6_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__6_i_2
       (.I0(budget_sync[92]),
        .I1(Q[28]),
        .I2(Q[26]),
        .I3(budget_sync[90]),
        .I4(Q[27]),
        .I5(budget_sync[91]),
        .O(fault_held4_carry__6_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__6_i_3
       (.I0(budget_sync[89]),
        .I1(Q[25]),
        .I2(Q[23]),
        .I3(budget_sync[87]),
        .I4(Q[24]),
        .I5(budget_sync[88]),
        .O(fault_held4_carry__6_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry__6_i_4
       (.I0(Q[20]),
        .I1(budget_sync[84]),
        .I2(Q[21]),
        .I3(budget_sync[85]),
        .I4(budget_sync[86]),
        .I5(Q[22]),
        .O(fault_held4_carry__6_i_4_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry_i_1
       (.I0(budget_sync[11]),
        .I1(closed_pixel_count[11]),
        .I2(closed_pixel_count[9]),
        .I3(budget_sync[9]),
        .I4(closed_pixel_count[10]),
        .I5(budget_sync[10]),
        .O(fault_held4_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry_i_2
       (.I0(closed_pixel_count[8]),
        .I1(budget_sync[8]),
        .I2(closed_pixel_count[6]),
        .I3(budget_sync[6]),
        .I4(budget_sync[7]),
        .I5(closed_pixel_count[7]),
        .O(fault_held4_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry_i_3
       (.I0(closed_pixel_count[3]),
        .I1(budget_sync[3]),
        .I2(closed_pixel_count[4]),
        .I3(budget_sync[4]),
        .I4(budget_sync[5]),
        .I5(closed_pixel_count[5]),
        .O(fault_held4_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    fault_held4_carry_i_4
       (.I0(closed_pixel_count[1]),
        .I1(budget_sync[1]),
        .I2(closed_pixel_count[0]),
        .I3(budget_sync[0]),
        .I4(budget_sync[2]),
        .I5(closed_pixel_count[2]),
        .O(fault_held4_carry_i_4_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    fault_held_i_1
       (.I0(fault_held0),
        .I1(fault_held),
        .O(fault_held_i_1_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFD0D0D0)) 
    fault_held_i_2
       (.I0(request_sync[2]),
        .I1(fault_held4),
        .I2(closure_held),
        .I3(budget_product_ready),
        .I4(fault_held2),
        .I5(fault_sync[2]),
        .O(fault_held0));
  FDCE fault_held_reg
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(fault_held_i_1_n_0),
        .Q(fault_held));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \fault_sync_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(source_protocol_fault),
        .Q(fault_sync[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \fault_sync_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(fault_sync[0]),
        .Q(fault_sync[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \fault_sync_reg[2] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(fault_sync[1]),
        .Q(fault_sync[2]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'h40000000)) 
    \final_frame_count[31]_i_1 
       (.I0(closure_held_reg_1),
        .I1(configuration_locked),
        .I2(dest_arst),
        .I3(closure_held),
        .I4(budget_checked),
        .O(closure_held_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hFFFF0080)) 
    frame_credit_ready_INST_0_i_3
       (.I0(budget_checked),
        .I1(closure_held),
        .I2(dest_arst),
        .I3(CO),
        .I4(\granted_frames_reg[31] ),
        .O(budget_checked_reg_0));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry__0_i_1
       (.I0(Q[14]),
        .I1(out[14]),
        .I2(out[15]),
        .I3(Q[15]),
        .O(\closed_frame_count_reg[14]_1 [3]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry__0_i_2
       (.I0(Q[12]),
        .I1(out[12]),
        .I2(out[13]),
        .I3(Q[13]),
        .O(\closed_frame_count_reg[14]_1 [2]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry__0_i_3
       (.I0(Q[10]),
        .I1(out[10]),
        .I2(out[11]),
        .I3(Q[11]),
        .O(\closed_frame_count_reg[14]_1 [1]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry__0_i_4
       (.I0(Q[8]),
        .I1(out[8]),
        .I2(out[9]),
        .I3(Q[9]),
        .O(\closed_frame_count_reg[14]_1 [0]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry__0_i_5
       (.I0(Q[14]),
        .I1(out[14]),
        .I2(out[15]),
        .I3(Q[15]),
        .O(\closed_frame_count_reg[14]_0 [3]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry__0_i_6
       (.I0(Q[12]),
        .I1(out[12]),
        .I2(out[13]),
        .I3(Q[13]),
        .O(\closed_frame_count_reg[14]_0 [2]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry__0_i_7
       (.I0(Q[10]),
        .I1(out[10]),
        .I2(out[11]),
        .I3(Q[11]),
        .O(\closed_frame_count_reg[14]_0 [1]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry__0_i_8
       (.I0(Q[8]),
        .I1(out[8]),
        .I2(out[9]),
        .I3(Q[9]),
        .O(\closed_frame_count_reg[14]_0 [0]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry__1_i_1
       (.I0(Q[22]),
        .I1(out[22]),
        .I2(out[23]),
        .I3(Q[23]),
        .O(\closed_frame_count_reg[22]_1 [3]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry__1_i_2
       (.I0(Q[20]),
        .I1(out[20]),
        .I2(out[21]),
        .I3(Q[21]),
        .O(\closed_frame_count_reg[22]_1 [2]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry__1_i_3
       (.I0(Q[18]),
        .I1(out[18]),
        .I2(out[19]),
        .I3(Q[19]),
        .O(\closed_frame_count_reg[22]_1 [1]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry__1_i_4
       (.I0(Q[16]),
        .I1(out[16]),
        .I2(out[17]),
        .I3(Q[17]),
        .O(\closed_frame_count_reg[22]_1 [0]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry__1_i_5
       (.I0(Q[22]),
        .I1(out[22]),
        .I2(out[23]),
        .I3(Q[23]),
        .O(\closed_frame_count_reg[22]_0 [3]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry__1_i_6
       (.I0(Q[20]),
        .I1(out[20]),
        .I2(out[21]),
        .I3(Q[21]),
        .O(\closed_frame_count_reg[22]_0 [2]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry__1_i_7
       (.I0(Q[18]),
        .I1(out[18]),
        .I2(out[19]),
        .I3(Q[19]),
        .O(\closed_frame_count_reg[22]_0 [1]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry__1_i_8
       (.I0(Q[16]),
        .I1(out[16]),
        .I2(out[17]),
        .I3(Q[17]),
        .O(\closed_frame_count_reg[22]_0 [0]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry__2_i_1
       (.I0(Q[30]),
        .I1(out[30]),
        .I2(out[31]),
        .I3(Q[31]),
        .O(\closed_frame_count_reg[30]_1 [3]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry__2_i_2
       (.I0(Q[28]),
        .I1(out[28]),
        .I2(out[29]),
        .I3(Q[29]),
        .O(\closed_frame_count_reg[30]_1 [2]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry__2_i_3
       (.I0(Q[26]),
        .I1(out[26]),
        .I2(out[27]),
        .I3(Q[27]),
        .O(\closed_frame_count_reg[30]_1 [1]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry__2_i_4
       (.I0(Q[24]),
        .I1(out[24]),
        .I2(out[25]),
        .I3(Q[25]),
        .O(\closed_frame_count_reg[30]_1 [0]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry__2_i_5
       (.I0(Q[30]),
        .I1(out[30]),
        .I2(out[31]),
        .I3(Q[31]),
        .O(\closed_frame_count_reg[30]_0 [3]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry__2_i_6
       (.I0(Q[28]),
        .I1(out[28]),
        .I2(out[29]),
        .I3(Q[29]),
        .O(\closed_frame_count_reg[30]_0 [2]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry__2_i_7
       (.I0(Q[26]),
        .I1(out[26]),
        .I2(out[27]),
        .I3(Q[27]),
        .O(\closed_frame_count_reg[30]_0 [1]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry__2_i_8
       (.I0(Q[24]),
        .I1(out[24]),
        .I2(out[25]),
        .I3(Q[25]),
        .O(\closed_frame_count_reg[30]_0 [0]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry_i_1
       (.I0(Q[6]),
        .I1(out[6]),
        .I2(out[7]),
        .I3(Q[7]),
        .O(DI[3]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry_i_2
       (.I0(Q[4]),
        .I1(out[4]),
        .I2(out[5]),
        .I3(Q[5]),
        .O(DI[2]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry_i_3
       (.I0(Q[2]),
        .I1(out[2]),
        .I2(out[3]),
        .I3(Q[3]),
        .O(DI[1]));
  LUT4 #(
    .INIT(16'h2F02)) 
    grant_ready1_carry_i_4
       (.I0(Q[0]),
        .I1(out[0]),
        .I2(out[1]),
        .I3(Q[1]),
        .O(DI[0]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry_i_5
       (.I0(Q[6]),
        .I1(out[6]),
        .I2(out[7]),
        .I3(Q[7]),
        .O(\closed_frame_count_reg[6]_0 [3]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry_i_6
       (.I0(Q[4]),
        .I1(out[4]),
        .I2(out[5]),
        .I3(Q[5]),
        .O(\closed_frame_count_reg[6]_0 [2]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry_i_7
       (.I0(Q[2]),
        .I1(out[2]),
        .I2(out[3]),
        .I3(Q[3]),
        .O(\closed_frame_count_reg[6]_0 [1]));
  LUT4 #(
    .INIT(16'h9009)) 
    grant_ready1_carry_i_8
       (.I0(Q[0]),
        .I1(out[0]),
        .I2(out[1]),
        .I3(Q[1]),
        .O(\closed_frame_count_reg[6]_0 [0]));
  FDCE \held_budget_reg[0] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[0]),
        .Q(\held_budget_reg[2]_0 [0]));
  FDCE \held_budget_reg[10] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[10]),
        .Q(held_budget[10]));
  FDCE \held_budget_reg[11] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[11]),
        .Q(held_budget[11]));
  FDCE \held_budget_reg[12] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[12]),
        .Q(held_budget[12]));
  FDCE \held_budget_reg[13] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[13]),
        .Q(held_budget[13]));
  FDCE \held_budget_reg[14] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[14]),
        .Q(held_budget[14]));
  FDCE \held_budget_reg[15] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[15]),
        .Q(held_budget[15]));
  FDCE \held_budget_reg[16] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[16]),
        .Q(held_budget[16]));
  FDCE \held_budget_reg[17] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[17]),
        .Q(held_budget[17]));
  FDCE \held_budget_reg[18] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[18]),
        .Q(held_budget[18]));
  FDCE \held_budget_reg[19] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[19]),
        .Q(held_budget[19]));
  FDCE \held_budget_reg[1] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[1]),
        .Q(\held_budget_reg[2]_0 [1]));
  FDCE \held_budget_reg[20] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[20]),
        .Q(held_budget[20]));
  FDCE \held_budget_reg[21] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[21]),
        .Q(held_budget[21]));
  FDCE \held_budget_reg[22] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[22]),
        .Q(held_budget[22]));
  FDCE \held_budget_reg[23] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[23]),
        .Q(held_budget[23]));
  FDCE \held_budget_reg[24] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[24]),
        .Q(held_budget[24]));
  FDCE \held_budget_reg[25] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[25]),
        .Q(held_budget[25]));
  FDCE \held_budget_reg[26] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[26]),
        .Q(held_budget[26]));
  FDCE \held_budget_reg[27] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[27]),
        .Q(held_budget[27]));
  FDCE \held_budget_reg[28] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[28]),
        .Q(held_budget[28]));
  FDCE \held_budget_reg[29] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[29]),
        .Q(held_budget[29]));
  FDCE \held_budget_reg[2] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[2]),
        .Q(\held_budget_reg[2]_0 [2]));
  FDCE \held_budget_reg[30] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[30]),
        .Q(held_budget[30]));
  FDCE \held_budget_reg[31] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[31]),
        .Q(held_budget[31]));
  FDCE \held_budget_reg[32] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[32]),
        .Q(held_budget[32]));
  FDCE \held_budget_reg[33] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[33]),
        .Q(held_budget[33]));
  FDCE \held_budget_reg[34] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[34]),
        .Q(held_budget[34]));
  FDCE \held_budget_reg[35] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[35]),
        .Q(held_budget[35]));
  FDCE \held_budget_reg[36] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[36]),
        .Q(held_budget[36]));
  FDCE \held_budget_reg[37] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[37]),
        .Q(held_budget[37]));
  FDCE \held_budget_reg[38] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[38]),
        .Q(held_budget[38]));
  FDCE \held_budget_reg[39] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[39]),
        .Q(held_budget[39]));
  FDCE \held_budget_reg[3] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[3]),
        .Q(held_budget[3]));
  FDCE \held_budget_reg[40] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[40]),
        .Q(held_budget[40]));
  FDCE \held_budget_reg[41] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[41]),
        .Q(held_budget[41]));
  FDCE \held_budget_reg[42] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[42]),
        .Q(held_budget[42]));
  FDCE \held_budget_reg[43] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[43]),
        .Q(held_budget[43]));
  FDCE \held_budget_reg[44] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[44]),
        .Q(held_budget[44]));
  FDCE \held_budget_reg[45] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[45]),
        .Q(held_budget[45]));
  FDCE \held_budget_reg[46] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[46]),
        .Q(held_budget[46]));
  FDCE \held_budget_reg[47] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[47]),
        .Q(held_budget[47]));
  FDCE \held_budget_reg[48] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[48]),
        .Q(held_budget[48]));
  FDCE \held_budget_reg[49] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[49]),
        .Q(held_budget[49]));
  FDCE \held_budget_reg[4] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[4]),
        .Q(held_budget[4]));
  FDCE \held_budget_reg[50] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[50]),
        .Q(held_budget[50]));
  FDCE \held_budget_reg[51] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[51]),
        .Q(held_budget[51]));
  FDCE \held_budget_reg[52] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[52]),
        .Q(held_budget[52]));
  FDCE \held_budget_reg[53] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[53]),
        .Q(held_budget[53]));
  FDCE \held_budget_reg[54] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[54]),
        .Q(held_budget[54]));
  FDCE \held_budget_reg[55] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[55]),
        .Q(held_budget[55]));
  FDCE \held_budget_reg[56] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[56]),
        .Q(held_budget[56]));
  FDCE \held_budget_reg[57] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[57]),
        .Q(held_budget[57]));
  FDCE \held_budget_reg[58] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[58]),
        .Q(held_budget[58]));
  FDCE \held_budget_reg[59] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[59]),
        .Q(held_budget[59]));
  FDCE \held_budget_reg[5] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[5]),
        .Q(held_budget[5]));
  FDCE \held_budget_reg[60] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[60]),
        .Q(held_budget[60]));
  FDCE \held_budget_reg[61] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[61]),
        .Q(held_budget[61]));
  FDCE \held_budget_reg[62] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[62]),
        .Q(held_budget[62]));
  FDCE \held_budget_reg[63] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[63]),
        .Q(held_budget[63]));
  FDCE \held_budget_reg[64] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[64]),
        .Q(held_budget[64]));
  FDCE \held_budget_reg[65] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[65]),
        .Q(held_budget[65]));
  FDCE \held_budget_reg[66] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[66]),
        .Q(held_budget[66]));
  FDCE \held_budget_reg[67] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[67]),
        .Q(held_budget[67]));
  FDCE \held_budget_reg[68] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[68]),
        .Q(held_budget[68]));
  FDCE \held_budget_reg[69] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[69]),
        .Q(held_budget[69]));
  FDCE \held_budget_reg[6] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[6]),
        .Q(held_budget[6]));
  FDCE \held_budget_reg[70] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[70]),
        .Q(held_budget[70]));
  FDCE \held_budget_reg[71] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[71]),
        .Q(held_budget[71]));
  FDCE \held_budget_reg[72] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[72]),
        .Q(held_budget[72]));
  FDCE \held_budget_reg[73] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[73]),
        .Q(held_budget[73]));
  FDCE \held_budget_reg[74] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[74]),
        .Q(held_budget[74]));
  FDCE \held_budget_reg[75] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[75]),
        .Q(held_budget[75]));
  FDCE \held_budget_reg[76] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[76]),
        .Q(held_budget[76]));
  FDCE \held_budget_reg[77] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[77]),
        .Q(held_budget[77]));
  FDCE \held_budget_reg[78] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[78]),
        .Q(held_budget[78]));
  FDCE \held_budget_reg[79] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[79]),
        .Q(held_budget[79]));
  FDCE \held_budget_reg[7] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[7]),
        .Q(held_budget[7]));
  FDCE \held_budget_reg[80] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[80]),
        .Q(held_budget[80]));
  FDCE \held_budget_reg[81] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[81]),
        .Q(held_budget[81]));
  FDCE \held_budget_reg[82] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[82]),
        .Q(held_budget[82]));
  FDCE \held_budget_reg[83] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[83]),
        .Q(held_budget[83]));
  FDCE \held_budget_reg[84] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[84]),
        .Q(held_budget[84]));
  FDCE \held_budget_reg[85] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[85]),
        .Q(held_budget[85]));
  FDCE \held_budget_reg[86] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[86]),
        .Q(held_budget[86]));
  FDCE \held_budget_reg[87] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[87]),
        .Q(held_budget[87]));
  FDCE \held_budget_reg[88] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[88]),
        .Q(held_budget[88]));
  FDCE \held_budget_reg[89] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[89]),
        .Q(held_budget[89]));
  FDCE \held_budget_reg[8] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[8]),
        .Q(held_budget[8]));
  FDCE \held_budget_reg[90] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[90]),
        .Q(held_budget[90]));
  FDCE \held_budget_reg[91] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[91]),
        .Q(held_budget[91]));
  FDCE \held_budget_reg[92] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[92]),
        .Q(held_budget[92]));
  FDCE \held_budget_reg[93] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[93]),
        .Q(held_budget[93]));
  FDCE \held_budget_reg[94] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[94]),
        .Q(held_budget[94]));
  FDCE \held_budget_reg[95] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[95]),
        .Q(held_budget[95]));
  FDCE \held_budget_reg[9] 
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(p_0_in0_in[9]),
        .Q(held_budget[9]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    owner_fault_INST_0_i_5
       (.I0(capture_source_fault),
        .I1(cpu_command_fault),
        .I2(capture_fault),
        .I3(dma_fault),
        .O(upstream_fault0));
  (* DEF_VAL = "1'b1" *) 
  (* DEST_SYNC_FF = "3" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* INV_DEF_VAL = "1'b0" *) 
  (* RST_ACTIVE_HIGH = "0" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  (* XPM_MODULE = "TRUE" *) 
  c6v_capture_lifecycle_0_xpm_cdc_async_rst__3 processing_reset
       (.dest_arst(dest_arst),
        .dest_clk(aclk),
        .src_arst(common_aresetn));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \reply_sync_reg[0] 
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(request_held_i_2_n_0),
        .D(closure_held),
        .Q(reply_sync[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \reply_sync_reg[1] 
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(request_held_i_2_n_0),
        .D(reply_sync[0]),
        .Q(reply_sync[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \reply_sync_reg[2] 
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(request_held_i_2_n_0),
        .D(reply_sync[1]),
        .Q(reply_sync[2]));
  LUT1 #(
    .INIT(2'h1)) 
    request_held_i_2
       (.I0(video_resetn),
        .O(request_held_i_2_n_0));
  FDCE request_held_reg
       (.C(vid_io_in_clk),
        .CE(E),
        .CLR(request_held_i_2_n_0),
        .D(1'b1),
        .Q(D));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \request_sync_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(D),
        .Q(request_sync[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \request_sync_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(request_sync[0]),
        .Q(request_sync[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \request_sync_reg[2] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\closed_frame_count[31]_i_2_n_0 ),
        .D(request_sync[1]),
        .Q(request_sync[2]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h80)) 
    source_closed_INST_0
       (.I0(dest_arst),
        .I1(closure_held),
        .I2(budget_checked),
        .O(source_closed));
  CARRY4 source_protocol_fault3_carry
       (.CI(1'b0),
        .CO({source_protocol_fault3_carry_n_0,source_protocol_fault3_carry_n_1,source_protocol_fault3_carry_n_2,source_protocol_fault3_carry_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_source_protocol_fault3_carry_O_UNCONNECTED[3:0]),
        .S({source_protocol_fault3_carry_i_1_n_0,source_protocol_fault3_carry_i_2_n_0,source_protocol_fault3_carry_i_3_n_0,S}));
  CARRY4 source_protocol_fault3_carry__0
       (.CI(source_protocol_fault3_carry_n_0),
        .CO({source_protocol_fault3_carry__0_n_0,source_protocol_fault3_carry__0_n_1,source_protocol_fault3_carry__0_n_2,source_protocol_fault3_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_source_protocol_fault3_carry__0_O_UNCONNECTED[3:0]),
        .S({source_protocol_fault3_carry__0_i_1_n_0,source_protocol_fault3_carry__0_i_2_n_0,source_protocol_fault3_carry__0_i_3_n_0,source_protocol_fault3_carry__0_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__0_i_1
       (.I0(held_budget[22]),
        .I1(p_0_in0_in[22]),
        .I2(held_budget[21]),
        .I3(p_0_in0_in[21]),
        .I4(p_0_in0_in[23]),
        .I5(held_budget[23]),
        .O(source_protocol_fault3_carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__0_i_2
       (.I0(held_budget[18]),
        .I1(p_0_in0_in[18]),
        .I2(held_budget[19]),
        .I3(p_0_in0_in[19]),
        .I4(p_0_in0_in[20]),
        .I5(held_budget[20]),
        .O(source_protocol_fault3_carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__0_i_3
       (.I0(held_budget[16]),
        .I1(p_0_in0_in[16]),
        .I2(held_budget[15]),
        .I3(p_0_in0_in[15]),
        .I4(p_0_in0_in[17]),
        .I5(held_budget[17]),
        .O(source_protocol_fault3_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__0_i_4
       (.I0(held_budget[13]),
        .I1(p_0_in0_in[13]),
        .I2(held_budget[12]),
        .I3(p_0_in0_in[12]),
        .I4(p_0_in0_in[14]),
        .I5(held_budget[14]),
        .O(source_protocol_fault3_carry__0_i_4_n_0));
  CARRY4 source_protocol_fault3_carry__1
       (.CI(source_protocol_fault3_carry__0_n_0),
        .CO({source_protocol_fault3_carry__1_n_0,source_protocol_fault3_carry__1_n_1,source_protocol_fault3_carry__1_n_2,source_protocol_fault3_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_source_protocol_fault3_carry__1_O_UNCONNECTED[3:0]),
        .S({source_protocol_fault3_carry__1_i_1_n_0,source_protocol_fault3_carry__1_i_2_n_0,source_protocol_fault3_carry__1_i_3_n_0,source_protocol_fault3_carry__1_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__1_i_1
       (.I0(held_budget[33]),
        .I1(p_0_in0_in[33]),
        .I2(held_budget[34]),
        .I3(p_0_in0_in[34]),
        .I4(p_0_in0_in[35]),
        .I5(held_budget[35]),
        .O(source_protocol_fault3_carry__1_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__1_i_2
       (.I0(held_budget[31]),
        .I1(p_0_in0_in[31]),
        .I2(held_budget[30]),
        .I3(p_0_in0_in[30]),
        .I4(p_0_in0_in[32]),
        .I5(held_budget[32]),
        .O(source_protocol_fault3_carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__1_i_3
       (.I0(held_budget[27]),
        .I1(p_0_in0_in[27]),
        .I2(held_budget[28]),
        .I3(p_0_in0_in[28]),
        .I4(p_0_in0_in[29]),
        .I5(held_budget[29]),
        .O(source_protocol_fault3_carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__1_i_4
       (.I0(held_budget[24]),
        .I1(p_0_in0_in[24]),
        .I2(held_budget[25]),
        .I3(p_0_in0_in[25]),
        .I4(p_0_in0_in[26]),
        .I5(held_budget[26]),
        .O(source_protocol_fault3_carry__1_i_4_n_0));
  CARRY4 source_protocol_fault3_carry__2
       (.CI(source_protocol_fault3_carry__1_n_0),
        .CO({source_protocol_fault3_carry__2_n_0,source_protocol_fault3_carry__2_n_1,source_protocol_fault3_carry__2_n_2,source_protocol_fault3_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_source_protocol_fault3_carry__2_O_UNCONNECTED[3:0]),
        .S({source_protocol_fault3_carry__2_i_1_n_0,source_protocol_fault3_carry__2_i_2_n_0,source_protocol_fault3_carry__2_i_3_n_0,source_protocol_fault3_carry__2_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__2_i_1
       (.I0(held_budget[46]),
        .I1(p_0_in0_in[46]),
        .I2(held_budget[45]),
        .I3(p_0_in0_in[45]),
        .I4(p_0_in0_in[47]),
        .I5(held_budget[47]),
        .O(source_protocol_fault3_carry__2_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__2_i_2
       (.I0(held_budget[42]),
        .I1(p_0_in0_in[42]),
        .I2(held_budget[43]),
        .I3(p_0_in0_in[43]),
        .I4(p_0_in0_in[44]),
        .I5(held_budget[44]),
        .O(source_protocol_fault3_carry__2_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__2_i_3
       (.I0(held_budget[39]),
        .I1(p_0_in0_in[39]),
        .I2(held_budget[40]),
        .I3(p_0_in0_in[40]),
        .I4(p_0_in0_in[41]),
        .I5(held_budget[41]),
        .O(source_protocol_fault3_carry__2_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__2_i_4
       (.I0(held_budget[36]),
        .I1(p_0_in0_in[36]),
        .I2(held_budget[37]),
        .I3(p_0_in0_in[37]),
        .I4(p_0_in0_in[38]),
        .I5(held_budget[38]),
        .O(source_protocol_fault3_carry__2_i_4_n_0));
  CARRY4 source_protocol_fault3_carry__3
       (.CI(source_protocol_fault3_carry__2_n_0),
        .CO({source_protocol_fault3_carry__3_n_0,source_protocol_fault3_carry__3_n_1,source_protocol_fault3_carry__3_n_2,source_protocol_fault3_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_source_protocol_fault3_carry__3_O_UNCONNECTED[3:0]),
        .S({source_protocol_fault3_carry__3_i_1_n_0,source_protocol_fault3_carry__3_i_2_n_0,source_protocol_fault3_carry__3_i_3_n_0,source_protocol_fault3_carry__3_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__3_i_1
       (.I0(held_budget[57]),
        .I1(p_0_in0_in[57]),
        .I2(held_budget[58]),
        .I3(p_0_in0_in[58]),
        .I4(p_0_in0_in[59]),
        .I5(held_budget[59]),
        .O(source_protocol_fault3_carry__3_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__3_i_2
       (.I0(held_budget[54]),
        .I1(p_0_in0_in[54]),
        .I2(held_budget[55]),
        .I3(p_0_in0_in[55]),
        .I4(p_0_in0_in[56]),
        .I5(held_budget[56]),
        .O(source_protocol_fault3_carry__3_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__3_i_3
       (.I0(held_budget[51]),
        .I1(p_0_in0_in[51]),
        .I2(held_budget[52]),
        .I3(p_0_in0_in[52]),
        .I4(p_0_in0_in[53]),
        .I5(held_budget[53]),
        .O(source_protocol_fault3_carry__3_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__3_i_4
       (.I0(held_budget[48]),
        .I1(p_0_in0_in[48]),
        .I2(held_budget[49]),
        .I3(p_0_in0_in[49]),
        .I4(p_0_in0_in[50]),
        .I5(held_budget[50]),
        .O(source_protocol_fault3_carry__3_i_4_n_0));
  CARRY4 source_protocol_fault3_carry__4
       (.CI(source_protocol_fault3_carry__3_n_0),
        .CO({source_protocol_fault3_carry__4_n_0,source_protocol_fault3_carry__4_n_1,source_protocol_fault3_carry__4_n_2,source_protocol_fault3_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_source_protocol_fault3_carry__4_O_UNCONNECTED[3:0]),
        .S({source_protocol_fault3_carry__4_i_1_n_0,source_protocol_fault3_carry__4_i_2_n_0,source_protocol_fault3_carry__4_i_3_n_0,source_protocol_fault3_carry__4_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__4_i_1
       (.I0(held_budget[70]),
        .I1(p_0_in0_in[70]),
        .I2(held_budget[69]),
        .I3(p_0_in0_in[69]),
        .I4(p_0_in0_in[71]),
        .I5(held_budget[71]),
        .O(source_protocol_fault3_carry__4_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__4_i_2
       (.I0(held_budget[68]),
        .I1(p_0_in0_in[68]),
        .I2(held_budget[66]),
        .I3(p_0_in0_in[66]),
        .I4(p_0_in0_in[67]),
        .I5(held_budget[67]),
        .O(source_protocol_fault3_carry__4_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__4_i_3
       (.I0(held_budget[65]),
        .I1(p_0_in0_in[65]),
        .I2(held_budget[64]),
        .I3(p_0_in0_in[64]),
        .I4(p_0_in0_in[63]),
        .I5(held_budget[63]),
        .O(source_protocol_fault3_carry__4_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__4_i_4
       (.I0(held_budget[61]),
        .I1(p_0_in0_in[61]),
        .I2(held_budget[60]),
        .I3(p_0_in0_in[60]),
        .I4(p_0_in0_in[62]),
        .I5(held_budget[62]),
        .O(source_protocol_fault3_carry__4_i_4_n_0));
  CARRY4 source_protocol_fault3_carry__5
       (.CI(source_protocol_fault3_carry__4_n_0),
        .CO({source_protocol_fault3_carry__5_n_0,source_protocol_fault3_carry__5_n_1,source_protocol_fault3_carry__5_n_2,source_protocol_fault3_carry__5_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_source_protocol_fault3_carry__5_O_UNCONNECTED[3:0]),
        .S({source_protocol_fault3_carry__5_i_1_n_0,source_protocol_fault3_carry__5_i_2_n_0,source_protocol_fault3_carry__5_i_3_n_0,source_protocol_fault3_carry__5_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__5_i_1
       (.I0(held_budget[81]),
        .I1(p_0_in0_in[81]),
        .I2(held_budget[82]),
        .I3(p_0_in0_in[82]),
        .I4(p_0_in0_in[83]),
        .I5(held_budget[83]),
        .O(source_protocol_fault3_carry__5_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__5_i_2
       (.I0(held_budget[79]),
        .I1(p_0_in0_in[79]),
        .I2(held_budget[78]),
        .I3(p_0_in0_in[78]),
        .I4(p_0_in0_in[80]),
        .I5(held_budget[80]),
        .O(source_protocol_fault3_carry__5_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__5_i_3
       (.I0(held_budget[76]),
        .I1(p_0_in0_in[76]),
        .I2(held_budget[75]),
        .I3(p_0_in0_in[75]),
        .I4(p_0_in0_in[77]),
        .I5(held_budget[77]),
        .O(source_protocol_fault3_carry__5_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__5_i_4
       (.I0(held_budget[72]),
        .I1(p_0_in0_in[72]),
        .I2(held_budget[73]),
        .I3(p_0_in0_in[73]),
        .I4(p_0_in0_in[74]),
        .I5(held_budget[74]),
        .O(source_protocol_fault3_carry__5_i_4_n_0));
  CARRY4 source_protocol_fault3_carry__6
       (.CI(source_protocol_fault3_carry__5_n_0),
        .CO({source_protocol_fault3,source_protocol_fault3_carry__6_n_1,source_protocol_fault3_carry__6_n_2,source_protocol_fault3_carry__6_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_source_protocol_fault3_carry__6_O_UNCONNECTED[3:0]),
        .S({source_protocol_fault3_carry__6_i_1_n_0,source_protocol_fault3_carry__6_i_2_n_0,source_protocol_fault3_carry__6_i_3_n_0,source_protocol_fault3_carry__6_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__6_i_1
       (.I0(held_budget[95]),
        .I1(p_0_in0_in[95]),
        .I2(held_budget[93]),
        .I3(p_0_in0_in[93]),
        .I4(p_0_in0_in[94]),
        .I5(held_budget[94]),
        .O(source_protocol_fault3_carry__6_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__6_i_2
       (.I0(held_budget[90]),
        .I1(p_0_in0_in[90]),
        .I2(held_budget[91]),
        .I3(p_0_in0_in[91]),
        .I4(p_0_in0_in[92]),
        .I5(held_budget[92]),
        .O(source_protocol_fault3_carry__6_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__6_i_3
       (.I0(held_budget[87]),
        .I1(p_0_in0_in[87]),
        .I2(held_budget[88]),
        .I3(p_0_in0_in[88]),
        .I4(p_0_in0_in[89]),
        .I5(held_budget[89]),
        .O(source_protocol_fault3_carry__6_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry__6_i_4
       (.I0(held_budget[84]),
        .I1(p_0_in0_in[84]),
        .I2(held_budget[85]),
        .I3(p_0_in0_in[85]),
        .I4(p_0_in0_in[86]),
        .I5(held_budget[86]),
        .O(source_protocol_fault3_carry__6_i_4_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry_i_1
       (.I0(held_budget[9]),
        .I1(p_0_in0_in[9]),
        .I2(held_budget[10]),
        .I3(p_0_in0_in[10]),
        .I4(p_0_in0_in[11]),
        .I5(held_budget[11]),
        .O(source_protocol_fault3_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry_i_2
       (.I0(held_budget[6]),
        .I1(p_0_in0_in[6]),
        .I2(held_budget[7]),
        .I3(p_0_in0_in[7]),
        .I4(p_0_in0_in[8]),
        .I5(held_budget[8]),
        .O(source_protocol_fault3_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    source_protocol_fault3_carry_i_3
       (.I0(held_budget[3]),
        .I1(p_0_in0_in[3]),
        .I2(held_budget[4]),
        .I3(p_0_in0_in[4]),
        .I4(p_0_in0_in[5]),
        .I5(held_budget[5]),
        .O(source_protocol_fault3_carry_i_3_n_0));
  LUT5 #(
    .INIT(32'hFFFFEEE2)) 
    source_protocol_fault_i_1__0
       (.I0(reply_sync[2]),
        .I1(D),
        .I2(source_protocol_fault_reg_0),
        .I3(source_protocol_fault3),
        .I4(source_protocol_fault),
        .O(source_protocol_fault_i_1__0_n_0));
  FDCE source_protocol_fault_reg
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(request_held_i_2_n_0),
        .D(source_protocol_fault_i_1__0_n_0),
        .Q(source_protocol_fault));
  (* DEF_VAL = "1'b1" *) 
  (* DEST_SYNC_FF = "3" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* INV_DEF_VAL = "1'b0" *) 
  (* RST_ACTIVE_HIGH = "0" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  (* XPM_MODULE = "TRUE" *) 
  c6v_capture_lifecycle_0_xpm_cdc_async_rst__2 video_reset
       (.dest_arst(video_resetn),
        .dest_clk(vid_io_in_clk),
        .src_arst(common_aresetn));
endmodule

(* ORIG_REF_NAME = "vision_source_fault_cdc" *) 
module c6v_capture_lifecycle_0_vision_source_fault_cdc
   (capture_aresetn_reg_0,
    epoch_sealed,
    fault_causes,
    common_aresetn_0,
    capture_aresetn,
    aclk_underflow_0,
    barrier_complete,
    capture_aresetn_reg_1,
    \clean_sync_reg[2] ,
    capture_aresetn_reg_2,
    common_aresetn,
    vid_io_in_clk,
    aclk,
    epoch_sealed_0,
    sealed_held,
    fault_causes_2_sp_1,
    out,
    capture_fault_held,
    protocol_fault,
    control_capture_aresetn,
    aclk_underflow,
    \fault_causes[0] ,
    sealed_held_reg,
    D,
    configuration_locked1,
    configuration_locked,
    video_overflow);
  output capture_aresetn_reg_0;
  output epoch_sealed;
  output [2:0]fault_causes;
  output common_aresetn_0;
  output capture_aresetn;
  output aclk_underflow_0;
  output barrier_complete;
  output capture_aresetn_reg_1;
  output \clean_sync_reg[2] ;
  output capture_aresetn_reg_2;
  input common_aresetn;
  input vid_io_in_clk;
  input aclk;
  input epoch_sealed_0;
  input sealed_held;
  input fault_causes_2_sp_1;
  input [0:0]out;
  input capture_fault_held;
  input protocol_fault;
  input control_capture_aresetn;
  input aclk_underflow;
  input [0:0]\fault_causes[0] ;
  input [0:0]sealed_held_reg;
  input [0:0]D;
  input configuration_locked1;
  input configuration_locked;
  input video_overflow;

  wire [0:0]D;
  wire aclk;
  wire aclk_resetn;
  wire aclk_underflow;
  wire aclk_underflow_0;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]armed_sync;
  wire barrier_complete;
  wire capture_aresetn;
  wire capture_aresetn_i_1_n_0;
  wire capture_aresetn_reg_0;
  wire capture_aresetn_reg_1;
  wire capture_aresetn_reg_2;
  wire capture_fault_held;
  wire \clean_sync_reg[2] ;
  wire common_aresetn;
  wire common_aresetn_0;
  wire configuration_locked;
  wire configuration_locked1;
  wire control_capture_aresetn;
  wire epoch_sealed;
  wire epoch_sealed_0;
  wire epoch_sealed_INST_0_i_1_n_0;
  wire [2:0]fault_causes;
  wire [0:0]\fault_causes[0] ;
  wire fault_causes_2_sn_1;
  wire [1:1]monitor_faults;
  wire [0:0]out;
  wire overflow_latched;
  wire overflow_latched_i_1_n_0;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]overflow_sync;
  wire protocol_fault;
  wire sealed_held;
  wire [0:0]sealed_held_reg;
  wire underflow_latched_i_1_n_0;
  wire vid_io_in_clk;
  wire video_armed;
  wire video_armed_i_1_n_0;
  wire video_overflow;
  wire video_resetn;

  assign fault_causes_2_sn_1 = fault_causes_2_sp_1;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \armed_sync_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(video_armed),
        .Q(armed_sync[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \armed_sync_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(armed_sync[0]),
        .Q(armed_sync[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \armed_sync_reg[2] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(armed_sync[1]),
        .Q(armed_sync[2]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'hE000)) 
    barrier_complete_INST_0
       (.I0(sealed_held_reg),
        .I1(\fault_causes[0] ),
        .I2(D),
        .I3(capture_aresetn_reg_0),
        .O(barrier_complete));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h8)) 
    capture_aresetn_INST_0
       (.I0(control_capture_aresetn),
        .I1(capture_aresetn_reg_0),
        .O(capture_aresetn));
  LUT1 #(
    .INIT(2'h1)) 
    capture_aresetn_i_1
       (.I0(aclk_resetn),
        .O(capture_aresetn_i_1_n_0));
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 capture_aresetn RST" *) 
  (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *) 
  FDCE capture_aresetn_reg
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(armed_sync[2]),
        .Q(capture_aresetn_reg_0));
  LUT5 #(
    .INIT(32'hFFFE0000)) 
    capture_source_fault_INST_0_i_1
       (.I0(aclk_underflow),
        .I1(monitor_faults),
        .I2(\fault_causes[0] ),
        .I3(overflow_sync[2]),
        .I4(capture_aresetn_reg_0),
        .O(aclk_underflow_0));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'hFF40)) 
    configuration_locked_i_1
       (.I0(configuration_locked1),
        .I1(capture_aresetn_reg_0),
        .I2(control_capture_aresetn),
        .I3(configuration_locked),
        .O(capture_aresetn_reg_2));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'h7F)) 
    cpu_held_i_4
       (.I0(common_aresetn),
        .I1(capture_aresetn_reg_0),
        .I2(control_capture_aresetn),
        .O(common_aresetn_0));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    epoch_sealed_INST_0
       (.I0(epoch_sealed_INST_0_i_1_n_0),
        .I1(epoch_sealed_0),
        .I2(sealed_held),
        .I3(capture_aresetn_reg_0),
        .O(epoch_sealed));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'h0001FFFF)) 
    epoch_sealed_INST_0_i_1
       (.I0(protocol_fault),
        .I1(capture_fault_held),
        .I2(out),
        .I3(fault_causes_2_sn_1),
        .I4(capture_aresetn_reg_0),
        .O(epoch_sealed_INST_0_i_1_n_0));
  LUT3 #(
    .INIT(8'hA8)) 
    \fault_causes[0]_INST_0 
       (.I0(capture_aresetn_reg_0),
        .I1(overflow_sync[2]),
        .I2(\fault_causes[0] ),
        .O(fault_causes[0]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hA8)) 
    \fault_causes[1]_INST_0 
       (.I0(capture_aresetn_reg_0),
        .I1(monitor_faults),
        .I2(aclk_underflow),
        .O(fault_causes[1]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'hAAAAAAA8)) 
    \fault_causes[2]_INST_0 
       (.I0(capture_aresetn_reg_0),
        .I1(fault_causes_2_sn_1),
        .I2(out),
        .I3(capture_fault_held),
        .I4(protocol_fault),
        .O(fault_causes[2]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \fault_sync[2]_i_1 
       (.I0(capture_aresetn_reg_0),
        .O(capture_aresetn_reg_1));
  LUT2 #(
    .INIT(4'hE)) 
    overflow_latched_i_1
       (.I0(video_overflow),
        .I1(overflow_latched),
        .O(overflow_latched_i_1_n_0));
  FDCE overflow_latched_reg
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(video_armed_i_1_n_0),
        .D(overflow_latched_i_1_n_0),
        .Q(overflow_latched));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \overflow_sync_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(overflow_latched),
        .Q(overflow_sync[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \overflow_sync_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(overflow_sync[0]),
        .Q(overflow_sync[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \overflow_sync_reg[2] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(overflow_sync[1]),
        .Q(overflow_sync[2]));
  (* DEF_VAL = "1'b1" *) 
  (* DEST_SYNC_FF = "3" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* INV_DEF_VAL = "1'b0" *) 
  (* RST_ACTIVE_HIGH = "0" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  (* XPM_MODULE = "TRUE" *) 
  c6v_capture_lifecycle_0_xpm_cdc_async_rst__5 processing_reset
       (.dest_arst(aclk_resetn),
        .dest_clk(aclk),
        .src_arst(common_aresetn));
  LUT5 #(
    .INIT(32'hFFFF8000)) 
    sealed_held_i_1
       (.I0(sealed_held_reg),
        .I1(barrier_complete),
        .I2(epoch_sealed_0),
        .I3(epoch_sealed_INST_0_i_1_n_0),
        .I4(sealed_held),
        .O(\clean_sync_reg[2] ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'hE)) 
    underflow_latched_i_1
       (.I0(monitor_faults),
        .I1(aclk_underflow),
        .O(underflow_latched_i_1_n_0));
  FDCE underflow_latched_reg
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(underflow_latched_i_1_n_0),
        .Q(monitor_faults));
  LUT1 #(
    .INIT(2'h1)) 
    video_armed_i_1
       (.I0(video_resetn),
        .O(video_armed_i_1_n_0));
  FDCE video_armed_reg
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(video_armed_i_1_n_0),
        .D(1'b1),
        .Q(video_armed));
  (* DEF_VAL = "1'b1" *) 
  (* DEST_SYNC_FF = "3" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* INV_DEF_VAL = "1'b0" *) 
  (* RST_ACTIVE_HIGH = "0" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  (* XPM_MODULE = "TRUE" *) 
  c6v_capture_lifecycle_0_xpm_cdc_async_rst__4 video_reset
       (.dest_arst(video_resetn),
        .dest_clk(vid_io_in_clk),
        .src_arst(common_aresetn));
endmodule

(* DEF_VAL = "1'b1" *) (* DEST_SYNC_FF = "3" *) (* INIT_SYNC_FF = "0" *) 
(* INV_DEF_VAL = "1'b0" *) (* ORIG_REF_NAME = "xpm_cdc_async_rst" *) (* RST_ACTIVE_HIGH = "0" *) 
(* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "soft" *) 
(* xpm_cdc = "ASYNC_RST" *) 
module c6v_capture_lifecycle_0_xpm_cdc_async_rst
   (src_arst,
    dest_clk,
    dest_arst);
  input src_arst;
  input dest_clk;
  output dest_arst;

  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ASYNC_RST" *) wire [2:0]arststages_ff;
  wire dest_clk;
  wire reset_pol;
  wire src_arst;

  assign dest_arst = arststages_ff[2];
  LUT1 #(
    .INIT(2'h1)) 
    \arststages_ff[2]_i_1 
       (.I0(src_arst),
        .O(reset_pol));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(1'b1),
        .Q(arststages_ff[0]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[0]),
        .Q(arststages_ff[1]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[1]),
        .Q(arststages_ff[2]));
endmodule

(* DEF_VAL = "1'b1" *) (* DEST_SYNC_FF = "3" *) (* INIT_SYNC_FF = "0" *) 
(* INV_DEF_VAL = "1'b0" *) (* ORIG_REF_NAME = "xpm_cdc_async_rst" *) (* RST_ACTIVE_HIGH = "0" *) 
(* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "soft" *) 
(* xpm_cdc = "ASYNC_RST" *) 
module c6v_capture_lifecycle_0_xpm_cdc_async_rst__1
   (src_arst,
    dest_clk,
    dest_arst);
  input src_arst;
  input dest_clk;
  output dest_arst;

  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ASYNC_RST" *) wire [2:0]arststages_ff;
  wire dest_clk;
  wire reset_pol;
  wire src_arst;

  assign dest_arst = arststages_ff[2];
  LUT1 #(
    .INIT(2'h1)) 
    \arststages_ff[2]_i_1 
       (.I0(src_arst),
        .O(reset_pol));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(1'b1),
        .Q(arststages_ff[0]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[0]),
        .Q(arststages_ff[1]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[1]),
        .Q(arststages_ff[2]));
endmodule

(* DEF_VAL = "1'b1" *) (* DEST_SYNC_FF = "3" *) (* INIT_SYNC_FF = "0" *) 
(* INV_DEF_VAL = "1'b0" *) (* ORIG_REF_NAME = "xpm_cdc_async_rst" *) (* RST_ACTIVE_HIGH = "0" *) 
(* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "soft" *) 
(* xpm_cdc = "ASYNC_RST" *) 
module c6v_capture_lifecycle_0_xpm_cdc_async_rst__2
   (src_arst,
    dest_clk,
    dest_arst);
  input src_arst;
  input dest_clk;
  output dest_arst;

  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ASYNC_RST" *) wire [2:0]arststages_ff;
  wire dest_clk;
  wire reset_pol;
  wire src_arst;

  assign dest_arst = arststages_ff[2];
  LUT1 #(
    .INIT(2'h1)) 
    \arststages_ff[2]_i_1 
       (.I0(src_arst),
        .O(reset_pol));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(1'b1),
        .Q(arststages_ff[0]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[0]),
        .Q(arststages_ff[1]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[1]),
        .Q(arststages_ff[2]));
endmodule

(* DEF_VAL = "1'b1" *) (* DEST_SYNC_FF = "3" *) (* INIT_SYNC_FF = "0" *) 
(* INV_DEF_VAL = "1'b0" *) (* ORIG_REF_NAME = "xpm_cdc_async_rst" *) (* RST_ACTIVE_HIGH = "0" *) 
(* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "soft" *) 
(* xpm_cdc = "ASYNC_RST" *) 
module c6v_capture_lifecycle_0_xpm_cdc_async_rst__3
   (src_arst,
    dest_clk,
    dest_arst);
  input src_arst;
  input dest_clk;
  output dest_arst;

  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ASYNC_RST" *) wire [2:0]arststages_ff;
  wire dest_clk;
  wire reset_pol;
  wire src_arst;

  assign dest_arst = arststages_ff[2];
  LUT1 #(
    .INIT(2'h1)) 
    \arststages_ff[2]_i_1 
       (.I0(src_arst),
        .O(reset_pol));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(1'b1),
        .Q(arststages_ff[0]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[0]),
        .Q(arststages_ff[1]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[1]),
        .Q(arststages_ff[2]));
endmodule

(* DEF_VAL = "1'b1" *) (* DEST_SYNC_FF = "3" *) (* INIT_SYNC_FF = "0" *) 
(* INV_DEF_VAL = "1'b0" *) (* ORIG_REF_NAME = "xpm_cdc_async_rst" *) (* RST_ACTIVE_HIGH = "0" *) 
(* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "soft" *) 
(* xpm_cdc = "ASYNC_RST" *) 
module c6v_capture_lifecycle_0_xpm_cdc_async_rst__4
   (src_arst,
    dest_clk,
    dest_arst);
  input src_arst;
  input dest_clk;
  output dest_arst;

  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ASYNC_RST" *) wire [2:0]arststages_ff;
  wire dest_clk;
  wire reset_pol;
  wire src_arst;

  assign dest_arst = arststages_ff[2];
  LUT1 #(
    .INIT(2'h1)) 
    \arststages_ff[2]_i_1 
       (.I0(src_arst),
        .O(reset_pol));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(1'b1),
        .Q(arststages_ff[0]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[0]),
        .Q(arststages_ff[1]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[1]),
        .Q(arststages_ff[2]));
endmodule

(* DEF_VAL = "1'b1" *) (* DEST_SYNC_FF = "3" *) (* INIT_SYNC_FF = "0" *) 
(* INV_DEF_VAL = "1'b0" *) (* ORIG_REF_NAME = "xpm_cdc_async_rst" *) (* RST_ACTIVE_HIGH = "0" *) 
(* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "soft" *) 
(* xpm_cdc = "ASYNC_RST" *) 
module c6v_capture_lifecycle_0_xpm_cdc_async_rst__5
   (src_arst,
    dest_clk,
    dest_arst);
  input src_arst;
  input dest_clk;
  output dest_arst;

  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ASYNC_RST" *) wire [2:0]arststages_ff;
  wire dest_clk;
  wire reset_pol;
  wire src_arst;

  assign dest_arst = arststages_ff[2];
  LUT1 #(
    .INIT(2'h1)) 
    \arststages_ff[2]_i_1 
       (.I0(src_arst),
        .O(reset_pol));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(1'b1),
        .Q(arststages_ff[0]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[0]),
        .Q(arststages_ff[1]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[1]),
        .Q(arststages_ff[2]));
endmodule

(* DEST_SYNC_FF = "3" *) (* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_single" *) 
(* SIM_ASSERT_CHK = "1" *) (* SRC_INPUT_REG = "0" *) (* VERSION = "0" *) 
(* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "soft" *) (* xpm_cdc = "SINGLE" *) 
module c6v_capture_lifecycle_0_xpm_cdc_single
   (src_clk,
    src_in,
    dest_clk,
    dest_out);
  input src_clk;
  input src_in;
  input dest_clk;
  output dest_out;

  wire dest_clk;
  wire src_in;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "SINGLE" *) wire [2:0]syncstages_ff;

  assign dest_out = syncstages_ff[2];
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(src_in),
        .Q(syncstages_ff[0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[0]),
        .Q(syncstages_ff[1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "SINGLE" *) 
  FDRE \syncstages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(syncstages_ff[1]),
        .Q(syncstages_ff[2]),
        .R(1'b0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
