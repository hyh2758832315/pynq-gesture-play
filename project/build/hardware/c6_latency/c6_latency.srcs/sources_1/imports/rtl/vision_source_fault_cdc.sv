module vision_source_fault_cdc (
    input wire vid_io_in_clk,
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_RESET capture_aresetn" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
    input wire aclk,
    input wire common_aresetn,
    input wire video_overflow,
    input wire aclk_underflow,
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 capture_aresetn RST" *)
    output reg capture_aresetn,
    output wire source_fault,
    output wire [1:0] fault_status
);
    wire video_resetn, aclk_resetn;
    reg video_armed, overflow_latched, underflow_latched;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) reg [2:0] overflow_sync;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) reg [2:0] armed_sync;

    xpm_cdc_async_rst #(
        .DEST_SYNC_FF(3), .INIT_SYNC_FF(0), .RST_ACTIVE_HIGH(0)
    ) video_reset (
        .src_arst(common_aresetn), .dest_clk(vid_io_in_clk), .dest_arst(video_resetn)
    );
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF(3), .INIT_SYNC_FF(0), .RST_ACTIVE_HIGH(0)
    ) processing_reset (
        .src_arst(common_aresetn), .dest_clk(aclk), .dest_arst(aclk_resetn)
    );

    always @(posedge vid_io_in_clk or negedge video_resetn) begin
        if (!video_resetn) begin
            video_armed <= 0;
            overflow_latched <= 0;
        end else begin
            video_armed <= 1;
            if (video_overflow) overflow_latched <= 1;
        end
    end
    always @(posedge aclk or negedge aclk_resetn) begin
        if (!aclk_resetn) begin
            capture_aresetn <= 0;
            overflow_sync <= 0;
            armed_sync <= 0;
            underflow_latched <= 0;
        end else begin
            capture_aresetn <= armed_sync[2];
            overflow_sync <= {overflow_sync[1:0], overflow_latched};
            armed_sync <= {armed_sync[1:0], video_armed};
            if (aclk_underflow) underflow_latched <= 1;
        end
    end

    assign fault_status = {underflow_latched, overflow_sync[2]};
    assign source_fault = aclk_resetn && (|fault_status || aclk_underflow);
endmodule