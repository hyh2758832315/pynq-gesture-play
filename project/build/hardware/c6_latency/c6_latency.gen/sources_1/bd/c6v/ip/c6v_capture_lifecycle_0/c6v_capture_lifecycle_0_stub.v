// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Fri Oct 30 22:06:56 2026
// Host        : build-host running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_lifecycle_0/c6v_capture_lifecycle_0_stub.v
// Design      : c6v_capture_lifecycle_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "c6v_capture_lifecycle_0,vision_capture_lifecycle,{}" *) (* CORE_GENERATION_INFO = "c6v_capture_lifecycle_0,vision_capture_lifecycle,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=vision_capture_lifecycle,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,INPUT_WIDTH=1280,INPUT_HEIGHT=720}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* IP_DEFINITION_SOURCE = "module_ref" *) (* X_CORE_INFO = "vision_capture_lifecycle,Vivado 2026.1" *) 
module c6v_capture_lifecycle_0(aclk, vid_io_in_clk, common_aresetn, 
  control_capture_aresetn, control_armed, control_abort_requested, 
  control_barrier_request, cfg_frame_context, vid_active_video, vid_vsync, video_overflow, 
  aclk_underflow, capture_fault, pipeline_drained, dma_drained, dma_fault, 
  rgb_completed_frames, packet_completed_frames, status_completed_frames, 
  frame_credit_request, cpu_claim, cpu_release, cpu_command_fault, cpu_epoch, cpu_frame_id, 
  axis_enable, capture_aresetn, capture_source_fault, monitor_ready, source_quiescent, 
  source_closed, budget_fault, boundary_fault, admitted_frames, closed_frame_count, 
  admitted_pixels, closed_pixel_count, frame_credit_ready, grant_frame_id, grant_slot, 
  cpu_available, cpu_held, claim_accepted, release_accepted, available_epoch, 
  available_frame_id, available_slot, granted_frames, released_frames, owner_drained, 
  owner_fault, owner_fault_causes, barrier_complete, epoch_sealed, fault_causes)
/* synthesis syn_black_box black_box_pad_pin="common_aresetn,control_capture_aresetn,control_armed,control_abort_requested,control_barrier_request,cfg_frame_context[143:0],vid_active_video,vid_vsync,video_overflow,aclk_underflow,capture_fault,pipeline_drained,dma_drained,dma_fault,rgb_completed_frames[31:0],packet_completed_frames[31:0],status_completed_frames[31:0],frame_credit_request,cpu_claim,cpu_release,cpu_command_fault,cpu_epoch[31:0],cpu_frame_id[31:0],axis_enable,capture_aresetn,capture_source_fault,monitor_ready,source_quiescent,source_closed,budget_fault,boundary_fault,admitted_frames[31:0],closed_frame_count[31:0],admitted_pixels[63:0],closed_pixel_count[63:0],frame_credit_ready,grant_frame_id[31:0],grant_slot[1:0],cpu_available,cpu_held,claim_accepted,release_accepted,available_epoch[31:0],available_frame_id[31:0],available_slot[31:0],granted_frames[31:0],released_frames[31:0],owner_drained,owner_fault,owner_fault_causes[3:0],barrier_complete,epoch_sealed,fault_causes[2:0]" */
/* synthesis syn_force_seq_prim="aclk" */
/* synthesis syn_force_seq_prim="vid_io_in_clk" */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_RESET common_aresetn:control_capture_aresetn:capture_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input aclk /* synthesis syn_isclock = 1 */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 vid_io_in_clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vid_io_in_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input vid_io_in_clk /* synthesis syn_isclock = 1 */;
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
endmodule
