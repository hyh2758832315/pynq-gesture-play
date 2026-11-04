module axis_rgb_capture_bd #(
    parameter integer INPUT_WIDTH = 1280,
    parameter integer INPUT_HEIGHT = 720,
    parameter integer EPOCH_FRAMES = 1,
    parameter integer CONTINUOUS = 0,
    parameter integer SEQUENCE_FRAME_IDS = 0,
    parameter integer USE_FRAME_CREDITS = 0
)(
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF S_AXIS:M_RGB:M_PACKET, ASSOCIATED_RESET aresetn" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
    input wire aclk,
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
    input wire aresetn,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TDATA" *)
    input wire [23:0] s_axis_tdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TKEEP" *)
    input wire [2:0] s_axis_tkeep,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TVALID" *)
    input wire s_axis_tvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TREADY" *)
    output wire s_axis_tready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TUSER" *)
    input wire s_axis_tuser,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TLAST" *)
    input wire s_axis_tlast,
    input wire [143:0] cfg_frame_context,
    input wire source_fault, abort_requested,
    input wire source_closed,
    input wire [31:0] closed_frame_count,
    input wire frame_credit_ready,
    output wire frame_credit_request,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TDATA" *)
    output wire [23:0] m_rgb_tdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TKEEP" *)
    output wire [2:0] m_rgb_tkeep,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TVALID" *)
    output wire m_rgb_tvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TREADY" *)
    input wire m_rgb_tready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TUSER" *)
    output wire m_rgb_tuser,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_RGB TLAST" *)
    output wire m_rgb_tlast,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TDATA" *)
    output wire [31:0] m_packet_tdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TKEEP" *)
    output wire [3:0] m_packet_tkeep,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TVALID" *)
    output wire m_packet_tvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TREADY" *)
    input wire m_packet_tready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_PACKET TLAST" *)
    output wire m_packet_tlast,
    output wire frame_fault, pipeline_drained
);
    reg keep_fault_latched;
    wire capture_ready, credit_available;
    assign s_axis_tready = capture_ready && credit_available;
    generate if (USE_FRAME_CREDITS) begin : frame_credit_gate
        localparam integer PIXEL_BITS = $clog2(INPUT_WIDTH*INPUT_HEIGHT+1);
        reg frame_active;
        reg [PIXEL_BITS-1:0] remaining_pixels;
        assign credit_available = frame_active || frame_credit_ready;
        assign frame_credit_request = s_axis_tvalid && s_axis_tready && s_axis_tuser && !frame_active;
        always @(posedge aclk) begin
            if (!aresetn) begin frame_active <= 0; remaining_pixels <= 0; end
            else if (s_axis_tvalid && s_axis_tready) begin
                if (!frame_active && s_axis_tuser) begin
                    frame_active <= INPUT_WIDTH*INPUT_HEIGHT > 1;
                    remaining_pixels <= INPUT_WIDTH*INPUT_HEIGHT-1;
                end else if (frame_active) begin
                    if (remaining_pixels == 1) begin frame_active <= 0; remaining_pixels <= 0; end
                    else remaining_pixels <= remaining_pixels - 1'b1;
                end
            end
        end
    end else begin : no_frame_credit_gate
        assign credit_available = 1;
        assign frame_credit_request = 0;
    end endgenerate
    wire keep_fault = s_axis_tvalid && s_axis_tkeep != 3'b111;
    always @(posedge aclk) begin
        if (!aresetn) keep_fault_latched <= 0;
        else if (keep_fault) keep_fault_latched <= 1;
    end
    assign m_rgb_tkeep = 3'b111;
    axis_rgb_capture_tracked #(
        .INPUT_WIDTH(INPUT_WIDTH), .INPUT_HEIGHT(INPUT_HEIGHT), .EPOCH_FRAMES(EPOCH_FRAMES),
        .CONTINUOUS(CONTINUOUS), .SEQUENCE_FRAME_IDS(SEQUENCE_FRAME_IDS)
    ) capture (
        .aclk(aclk), .aresetn(aresetn), .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid && credit_available), .s_axis_tready(capture_ready),
        .s_axis_tuser(s_axis_tuser), .s_axis_tlast(s_axis_tlast),
        .cfg_frame_context(cfg_frame_context),
        .source_fault(source_fault || abort_requested || keep_fault || keep_fault_latched),
        .source_closed(source_closed), .closed_frame_count(closed_frame_count),
        .m_rgb_tdata(m_rgb_tdata), .m_rgb_tvalid(m_rgb_tvalid), .m_rgb_tready(m_rgb_tready),
        .m_rgb_tuser(m_rgb_tuser), .m_rgb_tlast(m_rgb_tlast),
        .m_packet_tdata(m_packet_tdata), .m_packet_tkeep(m_packet_tkeep),
        .m_packet_tvalid(m_packet_tvalid), .m_packet_tready(m_packet_tready),
        .m_packet_tlast(m_packet_tlast), .frame_fault(frame_fault), .pipeline_drained(pipeline_drained)
    );
endmodule