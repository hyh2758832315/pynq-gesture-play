module axis_rgb_dual_mask_capture #(
    parameter integer INPUT_WIDTH = 1280,
    parameter integer INPUT_HEIGHT = 720,
    parameter integer SEQUENCE_FRAME_IDS = 0
)(
    input wire aclk,
    input wire aresetn,
    input wire [23:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,
    input wire s_axis_tuser,
    input wire s_axis_tlast,
    input wire [143:0] cfg_frame_context,
    input wire source_fault,
    output wire [23:0] m_rgb_tdata,
    output wire m_rgb_tvalid,
    input wire m_rgb_tready,
    output wire m_rgb_tuser,
    output wire m_rgb_tlast,
    output wire [31:0] m_packet_tdata,
    output wire [3:0] m_packet_tkeep,
    output wire m_packet_tvalid,
    input wire m_packet_tready,
    output wire m_packet_tlast,
    output wire frame_fault
);
    wire fork_ready, camera_valid;
    wire [23:0] camera_data;
    wire camera_ready, camera_user, camera_last;
    wire [143:0] camera_context;
    wire [15:0] mask_data;
    wire mask_valid, mask_ready, mask_user, mask_last;
    wire [31:0] mask_frame, mask_config, mask_epoch;
    wire [47:0] mask_thresholds;
    wire frontend_fault, packet_fault, identity_fault;
    reg source_fault_latched;
    wire upstream_fault = source_fault || source_fault_latched || frontend_fault || identity_fault;
    always @(posedge aclk) begin
        if (!aresetn) source_fault_latched <= 0;
        else if (source_fault) source_fault_latched <= 1;
    end
    assign frame_fault = upstream_fault || packet_fault;
    assign s_axis_tready = fork_ready && !frame_fault;

    axis_rgb_frame_fork #(.SEQUENCE_FRAME_IDS(SEQUENCE_FRAME_IDS)) fork_rgb (
        .aclk(aclk), .aresetn(aresetn), .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid && !frame_fault), .s_axis_tready(fork_ready),
        .s_axis_tuser(s_axis_tuser), .s_axis_tlast(s_axis_tlast), .s_frame_context(cfg_frame_context),
        .m_rgb_tdata(m_rgb_tdata), .m_rgb_tvalid(m_rgb_tvalid), .m_rgb_tready(m_rgb_tready),
        .m_rgb_tuser(m_rgb_tuser), .m_rgb_tlast(m_rgb_tlast),
        .m_mask_tdata(camera_data), .m_mask_tvalid(camera_valid), .m_mask_tready(camera_ready),
        .m_mask_tuser(camera_user), .m_mask_tlast(camera_last), .m_frame_context(camera_context),
        .identity_fault(identity_fault), .identity_exhausted()
    );
    axis_rgb_mask_frontend #(.INPUT_WIDTH(INPUT_WIDTH), .INPUT_HEIGHT(INPUT_HEIGHT)) frontend (
        .aclk(aclk), .aresetn(aresetn), .s_axis_tdata(camera_data),
        .s_axis_tvalid(camera_valid), .s_axis_tready(camera_ready),
        .s_axis_tuser(camera_user), .s_axis_tlast(camera_last),
        .cfg_h_lo(camera_context[7:0]), .cfg_h_hi(camera_context[15:8]),
        .cfg_s_lo(camera_context[23:16]), .cfg_s_hi(camera_context[31:24]),
        .cfg_v_lo(camera_context[39:32]), .cfg_v_hi(camera_context[47:40]),
        .cfg_frame_id(camera_context[79:48]), .cfg_config_id(camera_context[111:80]),
        .cfg_epoch(camera_context[143:112]), .m_axis_tdata(mask_data), .m_axis_tvalid(mask_valid),
        .m_axis_tready(mask_ready), .m_axis_tuser(mask_user), .m_axis_tlast(mask_last),
        .m_frame_id(mask_frame), .m_config_id(mask_config), .m_epoch(mask_epoch),
        .m_thresholds(mask_thresholds), .m_width(), .m_height(), .frame_fault(frontend_fault)
    );
    axis_dual_mask_packet #(.WIDTH(INPUT_WIDTH/2), .HEIGHT(INPUT_HEIGHT/2)) packet (
        .aclk(aclk), .aresetn(aresetn), .s_axis_tdata(mask_data), .s_axis_tvalid(mask_valid),
        .s_axis_tready(mask_ready), .s_axis_tuser(mask_user), .s_axis_tlast(mask_last),
        .s_frame_context({mask_epoch, mask_config, mask_frame, mask_thresholds}),
        .upstream_fault(upstream_fault), .m_axis_tdata(m_packet_tdata),
        .m_axis_tkeep(m_packet_tkeep), .m_axis_tvalid(m_packet_tvalid),
        .m_axis_tready(m_packet_tready), .m_axis_tlast(m_packet_tlast), .frame_fault(packet_fault)
    );
endmodule