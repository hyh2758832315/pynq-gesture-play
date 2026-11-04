module axis_rgb_capture_tracked #(
    parameter integer INPUT_WIDTH = 1280,
    parameter integer INPUT_HEIGHT = 720,
    parameter integer EPOCH_FRAMES = 1,
    parameter integer SEQUENCE_FRAME_IDS = 0,
    parameter integer CONTINUOUS = 0
)(
    input wire aclk, aresetn,
    input wire [23:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,
    input wire s_axis_tuser, s_axis_tlast,
    input wire [143:0] cfg_frame_context,
    input wire source_fault,
    input wire source_closed,
    input wire [31:0] closed_frame_count,
    output wire [23:0] m_rgb_tdata,
    output wire m_rgb_tvalid,
    input wire m_rgb_tready,
    output wire m_rgb_tuser, m_rgb_tlast,
    output wire [31:0] m_packet_tdata,
    output wire [3:0] m_packet_tkeep,
    output wire m_packet_tvalid,
    input wire m_packet_tready,
    output wire m_packet_tlast, frame_fault, pipeline_drained
);
    wire capture_fault, drain_fault;
    assign frame_fault = capture_fault || drain_fault;
    axis_rgb_dual_mask_capture #(.INPUT_WIDTH(INPUT_WIDTH), .INPUT_HEIGHT(INPUT_HEIGHT),
        .SEQUENCE_FRAME_IDS(SEQUENCE_FRAME_IDS)) capture (
        .aclk(aclk), .aresetn(aresetn), .s_axis_tdata(s_axis_tdata), .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready), .s_axis_tuser(s_axis_tuser), .s_axis_tlast(s_axis_tlast),
        .cfg_frame_context(cfg_frame_context), .source_fault(source_fault),
        .m_rgb_tdata(m_rgb_tdata), .m_rgb_tvalid(m_rgb_tvalid), .m_rgb_tready(m_rgb_tready),
        .m_rgb_tuser(m_rgb_tuser), .m_rgb_tlast(m_rgb_tlast),
        .m_packet_tdata(m_packet_tdata), .m_packet_tkeep(m_packet_tkeep), .m_packet_tvalid(m_packet_tvalid),
        .m_packet_tready(m_packet_tready), .m_packet_tlast(m_packet_tlast), .frame_fault(capture_fault)
    );
    vision_capture_drain #(.INPUT_WIDTH(INPUT_WIDTH), .INPUT_HEIGHT(INPUT_HEIGHT), .EPOCH_FRAMES(EPOCH_FRAMES),
        .CONTINUOUS(CONTINUOUS)) drain (
        .aclk(aclk), .aresetn(aresetn), .source_valid(s_axis_tvalid), .source_ready(s_axis_tready),
        .rgb_valid(m_rgb_tvalid), .rgb_ready(m_rgb_tready), .packet_valid(m_packet_tvalid),
        .packet_ready(m_packet_tready), .packet_last(m_packet_tlast), .packet_keep(m_packet_tkeep),
        .capture_fault(capture_fault), .source_closed(source_closed), .closed_frame_count(closed_frame_count),
        .pipeline_drained(pipeline_drained), .integrity_fault(drain_fault)
    );
endmodule