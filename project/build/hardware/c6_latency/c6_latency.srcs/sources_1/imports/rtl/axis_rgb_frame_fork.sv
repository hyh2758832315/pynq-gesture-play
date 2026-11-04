module axis_rgb_frame_fork #(
    parameter integer SEQUENCE_FRAME_IDS = 0
)(
    input wire aclk,
    input wire aresetn,
    input wire [23:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,
    input wire s_axis_tuser,
    input wire s_axis_tlast,
    input wire [143:0] s_frame_context,
    output reg [23:0] m_rgb_tdata,
    output reg m_rgb_tvalid,
    input wire m_rgb_tready,
    output reg m_rgb_tuser,
    output reg m_rgb_tlast,
    output wire [23:0] m_mask_tdata,
    output reg m_mask_tvalid,
    input wire m_mask_tready,
    output wire m_mask_tuser,
    output wire m_mask_tlast,
    output reg [143:0] m_frame_context,
    output reg identity_fault, identity_exhausted
);
    reg identity_started;
    reg [143:0] locked_context;
    reg [31:0] next_frame_id;
    wire [31:0] incoming_frame_id = identity_started ? next_frame_id : s_frame_context[79:48];
    wire context_matches = !identity_started || s_frame_context == locked_context;
    assign s_axis_tready = aresetn && (!m_rgb_tvalid || m_rgb_tready) &&
                           (!m_mask_tvalid || m_mask_tready) && !identity_fault &&
                           (!SEQUENCE_FRAME_IDS || !s_axis_tuser || (!identity_exhausted && context_matches));
    assign m_mask_tdata = m_rgb_tdata;
    assign m_mask_tuser = m_rgb_tuser;
    assign m_mask_tlast = m_rgb_tlast;

    always @(posedge aclk) begin
        if (!aresetn) begin
            m_rgb_tdata <= 0;
            m_rgb_tvalid <= 0;
            m_mask_tvalid <= 0;
            m_rgb_tuser <= 0;
            m_rgb_tlast <= 0;
            m_frame_context <= 0;
            identity_started <= 0;
            locked_context <= 0;
            next_frame_id <= 0;
            identity_fault <= 0;
            identity_exhausted <= 0;
        end else begin
            if (SEQUENCE_FRAME_IDS && s_axis_tvalid && s_axis_tuser &&
                (identity_exhausted || !context_matches)) identity_fault <= 1;
            if (m_rgb_tready) m_rgb_tvalid <= 0;
            if (m_mask_tready) m_mask_tvalid <= 0;
            if (s_axis_tvalid && s_axis_tready) begin
                m_rgb_tdata <= s_axis_tdata;
                m_rgb_tuser <= s_axis_tuser;
                m_rgb_tlast <= s_axis_tlast;
                m_rgb_tvalid <= 1;
                m_mask_tvalid <= 1;
                if (s_axis_tuser) begin
                    if (SEQUENCE_FRAME_IDS) begin
                        m_frame_context <= {s_frame_context[143:80], incoming_frame_id, s_frame_context[47:0]};
                        identity_started <= 1;
                        locked_context <= s_frame_context;
                        if (incoming_frame_id == 32'hffffffff) identity_exhausted <= 1;
                        else next_frame_id <= incoming_frame_id + 1'b1;
                    end else m_frame_context <= s_frame_context;
                end
            end
        end
    end
endmodule