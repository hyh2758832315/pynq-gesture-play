// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:vision_capture_lifecycle:1.0
// IP Revision: 1

(* X_CORE_INFO = "vision_capture_lifecycle,Vivado 2026.1" *)
(* CHECK_LICENSE_TYPE = "c6v_capture_lifecycle_0,vision_capture_lifecycle,{}" *)
(* CORE_GENERATION_INFO = "c6v_capture_lifecycle_0,vision_capture_lifecycle,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=vision_capture_lifecycle,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,INPUT_WIDTH=1280,INPUT_HEIGHT=720}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module c6v_capture_lifecycle_0 (
  aclk,
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
  fault_causes
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_RESET common_aresetn:control_capture_aresetn:capture_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
input wire aclk;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 vid_io_in_clk CLK" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vid_io_in_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *)
input wire vid_io_in_clk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 common_aresetn RST" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME common_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
input wire common_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 control_capture_aresetn RST" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME control_capture_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
input wire control_capture_aresetn;
input wire control_armed;
input wire control_abort_requested;
input wire control_barrier_request;
input wire [143 : 0] cfg_frame_context;
input wire vid_active_video;
input wire vid_vsync;
input wire video_overflow;
input wire aclk_underflow;
input wire capture_fault;
input wire pipeline_drained;
input wire dma_drained;
input wire dma_fault;
input wire [31 : 0] rgb_completed_frames;
input wire [31 : 0] packet_completed_frames;
input wire [31 : 0] status_completed_frames;
input wire frame_credit_request;
input wire cpu_claim;
input wire cpu_release;
input wire cpu_command_fault;
input wire [31 : 0] cpu_epoch;
input wire [31 : 0] cpu_frame_id;
output wire axis_enable;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 capture_aresetn RST" *)
(* X_INTERFACE_MODE = "master" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME capture_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
output wire capture_aresetn;
output wire capture_source_fault;
output wire monitor_ready;
output wire source_quiescent;
output wire source_closed;
output wire budget_fault;
output wire boundary_fault;
output wire [31 : 0] admitted_frames;
output wire [31 : 0] closed_frame_count;
output wire [63 : 0] admitted_pixels;
output wire [63 : 0] closed_pixel_count;
output wire frame_credit_ready;
output wire [31 : 0] grant_frame_id;
output wire [1 : 0] grant_slot;
output wire cpu_available;
output wire cpu_held;
output wire claim_accepted;
output wire release_accepted;
output wire [31 : 0] available_epoch;
output wire [31 : 0] available_frame_id;
output wire [31 : 0] available_slot;
output wire [31 : 0] granted_frames;
output wire [31 : 0] released_frames;
output wire owner_drained;
output wire owner_fault;
output wire [3 : 0] owner_fault_causes;
output wire barrier_complete;
output wire epoch_sealed;
output wire [2 : 0] fault_causes;

  vision_capture_lifecycle #(
    .INPUT_WIDTH(1280),
    .INPUT_HEIGHT(720)
  ) inst (
    .aclk(aclk),
    .vid_io_in_clk(vid_io_in_clk),
    .common_aresetn(common_aresetn),
    .control_capture_aresetn(control_capture_aresetn),
    .control_armed(control_armed),
    .control_abort_requested(control_abort_requested),
    .control_barrier_request(control_barrier_request),
    .cfg_frame_context(cfg_frame_context),
    .vid_active_video(vid_active_video),
    .vid_vsync(vid_vsync),
    .video_overflow(video_overflow),
    .aclk_underflow(aclk_underflow),
    .capture_fault(capture_fault),
    .pipeline_drained(pipeline_drained),
    .dma_drained(dma_drained),
    .dma_fault(dma_fault),
    .rgb_completed_frames(rgb_completed_frames),
    .packet_completed_frames(packet_completed_frames),
    .status_completed_frames(status_completed_frames),
    .frame_credit_request(frame_credit_request),
    .cpu_claim(cpu_claim),
    .cpu_release(cpu_release),
    .cpu_command_fault(cpu_command_fault),
    .cpu_epoch(cpu_epoch),
    .cpu_frame_id(cpu_frame_id),
    .axis_enable(axis_enable),
    .capture_aresetn(capture_aresetn),
    .capture_source_fault(capture_source_fault),
    .monitor_ready(monitor_ready),
    .source_quiescent(source_quiescent),
    .source_closed(source_closed),
    .budget_fault(budget_fault),
    .boundary_fault(boundary_fault),
    .admitted_frames(admitted_frames),
    .closed_frame_count(closed_frame_count),
    .admitted_pixels(admitted_pixels),
    .closed_pixel_count(closed_pixel_count),
    .frame_credit_ready(frame_credit_ready),
    .grant_frame_id(grant_frame_id),
    .grant_slot(grant_slot),
    .cpu_available(cpu_available),
    .cpu_held(cpu_held),
    .claim_accepted(claim_accepted),
    .release_accepted(release_accepted),
    .available_epoch(available_epoch),
    .available_frame_id(available_frame_id),
    .available_slot(available_slot),
    .granted_frames(granted_frames),
    .released_frames(released_frames),
    .owner_drained(owner_drained),
    .owner_fault(owner_fault),
    .owner_fault_causes(owner_fault_causes),
    .barrier_complete(barrier_complete),
    .epoch_sealed(epoch_sealed),
    .fault_causes(fault_causes)
  );
endmodule
