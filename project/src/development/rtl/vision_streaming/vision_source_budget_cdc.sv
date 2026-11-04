module vision_source_budget_cdc #(
    parameter integer INPUT_WIDTH = 1280,
    parameter integer INPUT_HEIGHT = 720
)(
    input wire vid_io_in_clk, aclk, common_aresetn,
    input wire source_quiescent,
    input wire [31:0] admitted_frames,
    input wire [63:0] admitted_pixels,
    output wire source_closed, budget_fault,
    output reg [31:0] closed_frame_count,
    output reg [63:0] closed_pixel_count
);
    wire video_resetn, aclk_resetn;
    reg request_held, closure_held, source_protocol_fault, fault_held, budget_checked;
    reg budget_product_ready;
    reg [63:0] expected_pixels;
    reg [95:0] held_budget;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) reg [2:0] request_sync, reply_sync, fault_sync;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) reg [95:0] budget_meta, budget_sync;

    xpm_cdc_async_rst #(.DEST_SYNC_FF(3), .INIT_SYNC_FF(0), .RST_ACTIVE_HIGH(0)) video_reset (
        .src_arst(common_aresetn), .dest_clk(vid_io_in_clk), .dest_arst(video_resetn)
    );
    xpm_cdc_async_rst #(.DEST_SYNC_FF(3), .INIT_SYNC_FF(0), .RST_ACTIVE_HIGH(0)) processing_reset (
        .src_arst(common_aresetn), .dest_clk(aclk), .dest_arst(aclk_resetn)
    );
    assign source_closed = aclk_resetn && closure_held && budget_checked;
    assign budget_fault = aclk_resetn && (fault_held || fault_sync[2]);

    always @(posedge vid_io_in_clk or negedge video_resetn) begin
        if (!video_resetn) begin
            request_held <= 0;
            held_budget <= 0;
            reply_sync <= 0;
            source_protocol_fault <= 0;
        end else begin
            reply_sync <= {reply_sync[1:0], closure_held};
            if (reply_sync[2] && !request_held) source_protocol_fault <= 1;
            if (source_quiescent && !request_held) begin
                held_budget <= {admitted_frames, admitted_pixels};
                request_held <= 1;
            end
            if (request_held && (!source_quiescent || held_budget != {admitted_frames, admitted_pixels}))
                source_protocol_fault <= 1;
        end
    end

    always @(posedge aclk or negedge aclk_resetn) begin
        if (!aclk_resetn) begin
            request_sync <= 0;
            fault_sync <= 0;
            budget_meta <= 0;
            budget_sync <= 0;
            closure_held <= 0;
            budget_checked <= 0;
            budget_product_ready <= 0;
            expected_pixels <= 0;
            closed_frame_count <= 0;
            closed_pixel_count <= 0;
            fault_held <= 0;
        end else begin
            request_sync <= {request_sync[1:0], request_held};
            fault_sync <= {fault_sync[1:0], source_protocol_fault};
            budget_meta <= held_budget;
            budget_sync <= budget_meta;
            if (closure_held && !budget_product_ready) begin
                expected_pixels <= 64'd1 * INPUT_WIDTH * INPUT_HEIGHT * closed_frame_count;
                budget_product_ready <= 1;
            end
            if (budget_product_ready) budget_checked <= 1;
            if (request_sync[2] && !closure_held) begin
                closure_held <= 1;
                {closed_frame_count, closed_pixel_count} <= budget_sync;
            end
            if ((closure_held && (!request_sync[2] || budget_sync != {closed_frame_count, closed_pixel_count})) ||
                fault_sync[2] || (budget_product_ready && closed_pixel_count != expected_pixels)) fault_held <= 1;
        end
    end
endmodule