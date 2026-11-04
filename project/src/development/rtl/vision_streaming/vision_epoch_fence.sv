module vision_epoch_fence (
    input wire vid_io_in_clk, aclk, common_aresetn,
    input wire video_overflow, aclk_underflow, capture_fault,
    input wire source_quiescent,
    input wire request_seal, pipeline_drained, dma_drained,
    output wire monitor_ready, barrier_complete, epoch_sealed,
    output wire [2:0] fault_causes
);
    wire video_resetn;
    wire [1:0] monitor_faults;
    reg request_held, sealed_held, capture_fault_held, protocol_fault;
    reg overflow_held, reply_clean, reply_fault, source_protocol_fault;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) reg [2:0] request_sync;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) reg [2:0] clean_sync;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) reg [2:0] fault_sync;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) reg [2:0] protocol_sync;

    vision_source_fault_cdc monitor (
        .vid_io_in_clk(vid_io_in_clk), .aclk(aclk), .common_aresetn(common_aresetn),
        .video_overflow(video_overflow), .aclk_underflow(aclk_underflow),
        .capture_aresetn(monitor_ready), .source_fault(), .fault_status(monitor_faults)
    );
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF(3), .INIT_SYNC_FF(0), .RST_ACTIVE_HIGH(0)
    ) source_reset (
        .src_arst(common_aresetn), .dest_clk(vid_io_in_clk), .dest_arst(video_resetn)
    );

    always @(posedge vid_io_in_clk or negedge video_resetn) begin
        if (!video_resetn) begin
            request_sync <= 0;
            overflow_held <= 0;
            reply_clean <= 0;
            reply_fault <= 0;
            source_protocol_fault <= 0;
        end else begin
            request_sync <= {request_sync[1:0], request_held};
            if (video_overflow) overflow_held <= 1;
            if (request_sync[2] && source_quiescent && !reply_clean && !reply_fault) begin
                if (overflow_held || video_overflow) reply_fault <= 1;
                else reply_clean <= 1;
            end
            if ((reply_clean || reply_fault) && !source_quiescent) source_protocol_fault <= 1;
        end
    end

    assign fault_causes = monitor_ready ?
        {protocol_fault || protocol_sync[2] || capture_fault_held || capture_fault,
         monitor_faults[1] || aclk_underflow, monitor_faults[0] || fault_sync[2]} : 3'b000;
    assign barrier_complete = monitor_ready && request_held && (clean_sync[2] || fault_sync[2]);
    assign epoch_sealed = sealed_held && monitor_ready && pipeline_drained && dma_drained && !(|fault_causes);

    always @(posedge aclk or negedge monitor_ready) begin
        if (!monitor_ready) begin
            request_held <= 0;
            sealed_held <= 0;
            capture_fault_held <= 0;
            protocol_fault <= 0;
            clean_sync <= 0;
            fault_sync <= 0;
            protocol_sync <= 0;
        end else begin
            clean_sync <= {clean_sync[1:0], reply_clean};
            fault_sync <= {fault_sync[1:0], reply_fault};
            protocol_sync <= {protocol_sync[1:0], source_protocol_fault};
            if (request_seal) request_held <= 1;
            if (capture_fault) capture_fault_held <= 1;
            if ((clean_sync[2] && fault_sync[2]) || (sealed_held && (!pipeline_drained || !dma_drained))) protocol_fault <= 1;
            if (barrier_complete && clean_sync[2] && !(|fault_causes) && pipeline_drained && dma_drained) sealed_held <= 1;
        end
    end
endmodule