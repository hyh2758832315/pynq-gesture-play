`timescale 1ns/1ps
module epoch_fence_case #(
    parameter integer VIDEO_HALF = 2,
    parameter integer ACLK_HALF = 5,
    parameter integer CASE_ID = 0
)(output reg done = 0, output integer scenarios = 0);
    reg video_clk = 0, aclk = 0, video_running = 1, aclk_running = 1;
    always begin #(VIDEO_HALF); if (video_running) video_clk = !video_clk; else video_clk = 0; end
    always begin #(ACLK_HALF); if (aclk_running) aclk = !aclk; else aclk = 0; end
    reg common_resetn = 0, video_overflow = 0, underflow = 0, capture_fault = 0;
    reg source_quiescent = 0, request_seal = 0, pipeline_drained = 0, dma_drained = 0;
    wire ready, barrier, sealed;
    wire [2:0] faults;
    reg [31:0] epoch = 32'h71800000 + CASE_ID * 256;
    reg [11:0] araddr = 0;
    reg arvalid = 0, rready = 0;
    wire arready, rvalid;
    wire [31:0] rdata;
    wire [1:0] rresp;
    integer trace, snapshot_id = 0;
    vision_epoch_fence dut (
        .vid_io_in_clk(video_clk), .aclk(aclk), .common_aresetn(common_resetn),
        .video_overflow(video_overflow), .aclk_underflow(underflow), .capture_fault(capture_fault),
        .source_quiescent(source_quiescent), .request_seal(request_seal),
        .pipeline_drained(pipeline_drained), .dma_drained(dma_drained),
        .monitor_ready(ready), .barrier_complete(barrier), .epoch_sealed(sealed), .fault_causes(faults)
    );
    axi_vision_capture_status status_bank (
        .s_axi_aclk(aclk), .s_axi_aresetn(common_resetn),
        .s_axi_awaddr(12'd0), .s_axi_awvalid(1'b0), .s_axi_awready(),
        .s_axi_wdata(32'd0), .s_axi_wstrb(4'd0), .s_axi_wvalid(1'b0), .s_axi_wready(),
        .s_axi_bresp(), .s_axi_bvalid(), .s_axi_bready(1'b0),
        .s_axi_araddr(araddr), .s_axi_arvalid(arvalid), .s_axi_arready(arready),
        .s_axi_rdata(rdata), .s_axi_rresp(rresp), .s_axi_rvalid(rvalid), .s_axi_rready(rready),
        .monitor_ready(ready), .capture_armed(1'b1),
        .epoch_sealed(sealed), .capture_epoch(epoch), .fault_causes(faults)
    );
    always @(negedge aclk) begin
        #0.001;
        if (sealed && (!ready || !barrier || !pipeline_drained || !dma_drained || |faults))
            $fatal(1,"FENCE unsafe seal case=%0d time=%0t", CASE_ID, $time);
    end
    task automatic ticks(input integer count);
        repeat (count) @(negedge aclk);
    endtask
    task automatic reset_case;
        common_resetn = 0;
        request_seal = 0; source_quiescent = 0; video_overflow = 0;
        underflow = 0; capture_fault = 0; pipeline_drained = 0; dma_drained = 0;
        arvalid = 0; rready = 0;
        video_running = 1; aclk_running = 1;
        epoch = epoch + 1;
        #(8 * (VIDEO_HALF + ACLK_HALF));
        @(negedge aclk); common_resetn = 1;
        ticks(80);
        if (!ready || sealed || barrier || faults) $fatal(1,"FENCE reset case=%0d",CASE_ID);
    endtask
    task automatic request_once;
        @(negedge aclk); request_seal = 1;
        @(negedge aclk); request_seal = 0;
    endtask
    task automatic wait_barrier;
        ticks(80);
        if (!barrier) $fatal(1,"FENCE no response case=%0d",CASE_ID);
    endtask
    task automatic read_word(input [11:0] address, input [31:0] expected);
        @(negedge aclk); araddr = address; arvalid = 1;
        @(posedge aclk); if (!arready) $fatal(1,"FENCE AXI address blocked");
        @(negedge aclk); arvalid = 0;
        repeat (3) begin
            if (!rvalid || rresp != 0 || rdata !== expected) $fatal(1,"FENCE AXI mismatch case=%0d offset=%h got=%h expected=%h",CASE_ID,address,rdata,expected);
            @(negedge aclk);
        end
        $fdisplay(trace,"%0d,%03x,%08x,%01x",snapshot_id,address,rdata,rresp);
        rready = 1;
        @(negedge aclk); rready = 0;
    endtask
    task automatic snapshot(input [31:0] flags, input [31:0] causes);
        read_word(0,32'h31545356); read_word(4,32'h00010000);
        read_word(16,epoch); read_word(8,flags); read_word(12,causes); read_word(16,epoch);
        snapshot_id = snapshot_id + 1;
    endtask
    initial begin : exercise
        integer offset;
        trace = $fopen($sformatf("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r291-fence-output/case%0d.csv",CASE_ID),"w");
        if (!trace) $fatal(1,"FENCE trace open failed");
        $fdisplay(trace,"snapshot,offset,value,response");
        reset_case();
        source_quiescent = 1; pipeline_drained = 1; dma_drained = 1;
        ticks(80);
        if (sealed || barrier) $fatal(1,"FENCE unsolicited response");
        scenarios++;

        reset_case(); snapshot(1,0);
        request_once(); pipeline_drained = 1; dma_drained = 1;
        ticks(80);
        if (sealed || barrier) $fatal(1,"FENCE bypassed source");
        snapshot(1,0);
        pipeline_drained = 0; dma_drained = 0;
        @(negedge video_clk); source_quiescent = 1;
        wait_barrier();
        if (sealed || faults) $fatal(1,"FENCE bypassed drain");
        snapshot(1,0);
        pipeline_drained = 1; ticks(10);
        if (sealed) $fatal(1,"FENCE bypassed DMA");
        pipeline_drained = 0; dma_drained = 1; ticks(10);
        if (sealed) $fatal(1,"FENCE bypassed pipeline");
        pipeline_drained = 1; ticks(10);
        if (!sealed || faults) $fatal(1,"FENCE clean seal failed");
        snapshot(3,0);
        dma_drained = 0; ticks(10); dma_drained = 1; ticks(10);
        if (sealed || faults != 4) $fatal(1,"FENCE drain loss not sticky");
        snapshot(5,4); scenarios++;

        for (offset = 0; offset < 16; offset++) begin
            reset_case(); request_once(); pipeline_drained = 1; dma_drained = 1;
            repeat (5) @(negedge video_clk);
            #(offset); video_overflow = 1; source_quiescent = 1;
            repeat (2) @(negedge video_clk);
            video_overflow = 0;
            wait_barrier();
            if (sealed || faults != 1) $fatal(1,"FENCE source fault escaped phase=%0d case=%0d",offset,CASE_ID);
            scenarios++;
        end
        reset_case(); request_once(); pipeline_drained = 1; dma_drained = 1;
        underflow = 1; ticks(1); underflow = 0;
        @(negedge video_clk); source_quiescent = 1;
        wait_barrier();
        if (sealed || faults != 2) $fatal(1,"FENCE underflow escaped"); scenarios++;

        reset_case(); request_once(); pipeline_drained = 1; dma_drained = 1;
        capture_fault = 1; ticks(1); capture_fault = 0;
        @(negedge video_clk); source_quiescent = 1;
        wait_barrier();
        if (sealed || faults != 4) $fatal(1,"FENCE capture fault escaped"); scenarios++;

        reset_case();
        @(negedge video_clk); source_quiescent = 1;
        @(negedge video_clk); source_quiescent = 0;
        request_once(); pipeline_drained = 1; dma_drained = 1; ticks(80);
        if (sealed || barrier) $fatal(1,"FENCE stale quiescence reused"); scenarios++;

        reset_case();
        @(negedge video_clk); video_running = 0;
        request_once(); source_quiescent = 1; pipeline_drained = 1; dma_drained = 1;
        ticks(80);
        if (sealed || barrier) $fatal(1,"FENCE stopped source acknowledged");
        video_running = 1; wait_barrier();
        if (!sealed || faults) $fatal(1,"FENCE source restart failed"); scenarios++;

        reset_case();
        @(negedge video_clk); video_running = 0;
        request_once(); source_quiescent = 1; pipeline_drained = 1; dma_drained = 1;
        ticks(10); common_resetn = 0; #1;
        if (sealed || ready || barrier) $fatal(1,"FENCE stopped reset did not assert");
        ticks(10); common_resetn = 1; ticks(80);
        if (ready || sealed) $fatal(1,"FENCE armed without source reset release");
        video_running = 1; ticks(80);
        if (!ready || sealed || barrier) $fatal(1,"FENCE stale pending request after reset"); scenarios++;

        reset_case(); request_once();
        @(negedge video_clk); source_quiescent = 1;
        wait_barrier();
        video_overflow = 1; repeat (2) @(negedge video_clk); video_overflow = 0;
        ticks(80); pipeline_drained = 1; dma_drained = 1; ticks(10);
        if (sealed || faults != 1) $fatal(1,"FENCE late pre-drain source fault escaped"); scenarios++;

        reset_case(); request_once();
        @(negedge video_clk); source_quiescent = 1;
        wait_barrier();
        source_quiescent = 0; ticks(80); source_quiescent = 1;
        pipeline_drained = 1; dma_drained = 1; ticks(10);
        if (sealed || faults != 4) $fatal(1,"FENCE withdrawn quiescence not sticky"); scenarios++;

        reset_case(); request_once();
        @(negedge video_clk); source_quiescent = 1;
        wait_barrier();
        @(negedge aclk); aclk_running = 0;
        common_resetn = 0; #1;
        if (sealed || ready || barrier) $fatal(1,"FENCE reset with stopped ACLK");
        #(16 * (VIDEO_HALF + ACLK_HALF));
        common_resetn = 1;
        #(16 * (VIDEO_HALF + ACLK_HALF));
        if (ready || sealed) $fatal(1,"FENCE premature processing reset release");
        aclk_running = 1; ticks(80);
        if (!ready || sealed || barrier) $fatal(1,"FENCE stale response after stopped reset"); scenarios++;
        $fclose(trace);
        $display("FENCE_CASE_PASS case=%0d scenarios=%0d snapshots=%0d",CASE_ID,scenarios,snapshot_id);
        done = 1;
    end
endmodule

module tb_vision_epoch_fence;
    wire [2:0] done;
    wire [31:0] scenarios0, scenarios1, scenarios2;
    epoch_fence_case #(.VIDEO_HALF(2),.ACLK_HALF(5),.CASE_ID(0)) fast_source(done[0],scenarios0);
    epoch_fence_case #(.VIDEO_HALF(11),.ACLK_HALF(3),.CASE_ID(1)) slow_source(done[1],scenarios1);
    epoch_fence_case #(.VIDEO_HALF(7),.ACLK_HALF(5),.CASE_ID(2)) crossed(done[2],scenarios2);
    initial begin
        wait (&done);
        $display("TEST_PASS VISION_EPOCH_FENCE ratios=3 scenarios=%0d AXI_SNAPSHOTS=15 REQUEST_SOURCE_BARRIER_DRAIN_FAULT_STOP_RESET",scenarios0+scenarios1+scenarios2);
        $finish;
    end
    initial begin #200000; $fatal(1,"FENCE watchdog"); end
endmodule