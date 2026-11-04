module vision_capture_lifecycle #(
    parameter integer INPUT_WIDTH = 1280,
    parameter integer INPUT_HEIGHT = 720
)(
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_RESET common_aresetn:control_capture_aresetn:capture_aresetn, FREQ_HZ 100000000" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
    input wire aclk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 vid_io_in_clk CLK" *)
    input wire vid_io_in_clk,
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 common_aresetn RST" *)
    input wire common_aresetn,
    input wire control_capture_aresetn, control_armed, control_abort_requested, control_barrier_request,
    input wire [143:0] cfg_frame_context,
    input wire vid_active_video, vid_vsync, video_overflow, aclk_underflow,
    input wire capture_fault, pipeline_drained, dma_drained, dma_fault,
    input wire [31:0] rgb_completed_frames, packet_completed_frames, status_completed_frames,
    input wire frame_credit_request,
    input wire cpu_claim, cpu_release, cpu_command_fault,
    input wire [31:0] cpu_epoch, cpu_frame_id,
    output wire axis_enable,
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 capture_aresetn RST" *)
    output wire capture_aresetn,
    output wire capture_source_fault, monitor_ready,
    output wire source_quiescent, source_closed, budget_fault, boundary_fault,
    output wire [31:0] admitted_frames, closed_frame_count,
    output wire [63:0] admitted_pixels, closed_pixel_count,
    output wire frame_credit_ready,
    output wire [31:0] grant_frame_id,
    output wire [1:0] grant_slot,
    output wire cpu_available, cpu_held, claim_accepted, release_accepted,
    output wire [31:0] available_epoch, available_frame_id, available_slot,
    output wire [31:0] granted_frames, released_frames,
    output wire owner_drained, owner_fault,
    output wire [3:0] owner_fault_causes,
    output wire barrier_complete, epoch_sealed,
    output wire [2:0] fault_causes
);
    wire boundary_fault_sync;
    wire [2:0] released_sequence_video;
    wire [1:0] consumer_slot;
    reg request_close, request_open;
    always @(posedge aclk) begin
        if (!common_aresetn) begin
            request_close <= 0;
            request_open <= 0;
        end else begin
            request_close <= control_abort_requested || control_barrier_request || owner_fault;
            request_open <= control_armed && capture_aresetn &&
                !(control_abort_requested || control_barrier_request || owner_fault);
        end
    end
    assign capture_aresetn = monitor_ready && control_capture_aresetn;
    assign capture_source_fault = (|fault_causes[1:0]) || boundary_fault_sync || budget_fault;
    assign available_slot = {30'd0,consumer_slot};
    xpm_cdc_single #(.DEST_SYNC_FF(3), .INIT_SYNC_FF(0), .SIM_ASSERT_CHK(1), .SRC_INPUT_REG(0)) boundary_cdc (
        .src_clk(vid_io_in_clk), .src_in(boundary_fault), .dest_clk(aclk), .dest_out(boundary_fault_sync)
    );
    vision_release_credit_cdc release_credit (
        .aclk(aclk), .vid_io_in_clk(vid_io_in_clk), .common_aresetn(common_aresetn),
        .released_frames(released_frames), .released_sequence(released_sequence_video)
    );
    vision_source_admission admission (
        .vid_io_in_clk(vid_io_in_clk), .common_aresetn(common_aresetn),
        .request_open(request_open), .request_close(request_close),
        .released_sequence(released_sequence_video),
        .vid_active_video(vid_active_video), .vid_vsync(vid_vsync),
        .axis_enable(axis_enable), .source_quiescent(source_quiescent), .boundary_fault(boundary_fault),
        .admitted_frames(admitted_frames), .admitted_pixels(admitted_pixels)
    );
    vision_source_budget_cdc #(.INPUT_WIDTH(INPUT_WIDTH), .INPUT_HEIGHT(INPUT_HEIGHT)) budget (
        .vid_io_in_clk(vid_io_in_clk), .aclk(aclk), .common_aresetn(common_aresetn),
        .source_quiescent(source_quiescent), .admitted_frames(admitted_frames), .admitted_pixels(admitted_pixels),
        .source_closed(source_closed), .budget_fault(budget_fault),
        .closed_frame_count(closed_frame_count), .closed_pixel_count(closed_pixel_count)
    );
    vision_frame_owner owner (
        .aclk(aclk), .common_aresetn(common_aresetn), .enabled(capture_aresetn),
        .upstream_fault(capture_fault || dma_fault || capture_source_fault || cpu_command_fault),
        .cfg_epoch(cfg_frame_context[143:112]), .cfg_first_frame_id(cfg_frame_context[79:48]),
        .grant_request(frame_credit_request), .grant_ready(frame_credit_ready),
        .grant_frame_id(grant_frame_id), .grant_slot(grant_slot),
        .rgb_completed_frames(rgb_completed_frames), .packet_completed_frames(packet_completed_frames),
        .status_completed_frames(status_completed_frames),
        .source_closed(source_closed), .closed_frame_count(closed_frame_count),
        .cpu_claim(cpu_claim), .cpu_release(cpu_release), .cpu_epoch(cpu_epoch), .cpu_frame_id(cpu_frame_id),
        .cpu_available(cpu_available), .available_epoch(available_epoch), .available_frame_id(available_frame_id),
        .available_slot(consumer_slot), .cpu_held(cpu_held),
        .claim_accepted(claim_accepted), .release_accepted(release_accepted),
        .granted_frames(granted_frames), .released_frames(released_frames),
        .owner_drained(owner_drained), .owner_fault(owner_fault), .fault_causes(owner_fault_causes)
    );
    vision_epoch_fence fence (
        .vid_io_in_clk(vid_io_in_clk), .aclk(aclk), .common_aresetn(common_aresetn),
        .video_overflow(video_overflow), .aclk_underflow(aclk_underflow),
        .capture_fault(owner_fault), .source_quiescent(source_quiescent),
        .request_seal(request_close), .pipeline_drained(pipeline_drained), .dma_drained(dma_drained && owner_drained),
        .monitor_ready(monitor_ready), .barrier_complete(barrier_complete),
        .epoch_sealed(epoch_sealed), .fault_causes(fault_causes)
    );
endmodule
