`timescale 1ns/1ps
module vision_source_fault_cdc_case #(
    parameter integer CASE_ID = 0,
    parameter integer VIDEO_HALF = 2,
    parameter integer ACLK_HALF = 5
)(output reg done = 0);
    reg video_clk = 0, aclk = 0;
    reg video_running = 1, aclk_running = 1;
    reg common_aresetn = 0, overflow = 0, underflow = 0;
    wire capture_aresetn, source_fault;
    wire [1:0] status;
    integer scenarios = 0;
    integer phase_index;
    always #(VIDEO_HALF) begin
        if (video_running) video_clk = !video_clk;
        else video_clk = 0;
    end
    always #(ACLK_HALF) begin
        if (aclk_running) aclk = !aclk;
        else aclk = 0;
    end
    vision_source_fault_cdc dut (
        .vid_io_in_clk(video_clk), .aclk(aclk), .common_aresetn(common_aresetn),
        .video_overflow(overflow), .aclk_underflow(underflow),
        .capture_aresetn(capture_aresetn), .source_fault(source_fault), .fault_status(status)
    );
    task automatic assert_clear;
        begin
            if (source_fault !== 0 || status !== 0)
                $fatal(1, "CDC stale/false fault case=%0d status=%b", CASE_ID, status);
        end
    endtask
    task automatic assert_overflow;
        begin
            if (source_fault !== 1 || status !== 2'b01 || capture_aresetn !== 1)
                $fatal(1, "CDC lost overflow case=%0d status=%b armed=%b", CASE_ID, status, capture_aresetn);
        end
    endtask
    task automatic reset_both;
        begin
            common_aresetn = 0;
            overflow = 0;
            underflow = 0;
            #1;
            if (capture_aresetn !== 0) $fatal(1, "CDC asynchronous reset failed");
            assert_clear();
            repeat (5) @(negedge aclk);
            common_aresetn = 1;
            wait (capture_aresetn === 1);
            @(negedge aclk);
            assert_clear();
        end
    endtask
    task automatic pulse_overflow;
        begin
            @(negedge video_clk); overflow = 1;
            @(negedge video_clk); overflow = 0;
        end
    endtask
    initial begin
        #1;
        reset_both();
        repeat (32) @(negedge aclk);
        assert_clear();
        scenarios = scenarios + 1;
        for (phase_index = 0; phase_index < 16; phase_index = phase_index + 1) begin
            reset_both();
            #(phase_index + CASE_ID);
            pulse_overflow();
            repeat (8) @(negedge aclk);
            assert_overflow();
            pulse_overflow();
            repeat (16) @(negedge aclk);
            assert_overflow();
            scenarios = scenarios + 1;
        end
        reset_both();
        @(negedge aclk); aclk_running = 0;
        pulse_overflow();
        repeat (8) @(negedge video_clk);
        aclk_running = 1;
        repeat (8) @(negedge aclk);
        assert_overflow();
        scenarios = scenarios + 1;

        reset_both();
        pulse_overflow();
        video_running = 0;
        repeat (16) @(negedge aclk);
        assert_overflow();
        video_running = 1;
        scenarios = scenarios + 1;

        reset_both();
        @(negedge aclk); underflow = 1;
        #1;
        if (source_fault !== 1) $fatal(1, "ACLK underflow not immediate");
        @(negedge aclk); underflow = 0;
        repeat (16) @(negedge aclk);
        if (source_fault !== 1 || status !== 2'b10) $fatal(1, "ACLK underflow not sticky");
        scenarios = scenarios + 1;

        @(negedge video_clk); video_running = 0;
        common_aresetn = 0;
        #1;
        if (capture_aresetn !== 0) $fatal(1, "Stopped video reset did not assert");
        assert_clear();
        repeat (5) @(negedge aclk);
        common_aresetn = 1;
        repeat (16) begin
            @(negedge aclk);
            if (capture_aresetn !== 0) $fatal(1, "Capture released without video clock");
        end
        video_running = 1;
        wait (capture_aresetn === 1);
        @(negedge aclk); assert_clear();
        scenarios = scenarios + 1;

        pulse_overflow();
        repeat (8) @(negedge aclk);
        assert_overflow();
        @(negedge aclk); aclk_running = 0;
        common_aresetn = 0;
        #1;
        if (capture_aresetn !== 0) $fatal(1, "Stopped ACLK reset did not assert");
        assert_clear();
        repeat (5) @(negedge video_clk);
        common_aresetn = 1;
        repeat (16) @(negedge video_clk);
        if (capture_aresetn !== 0) $fatal(1, "Capture released without ACLK");
        aclk_running = 1;
        wait (capture_aresetn === 1);
        @(negedge aclk); assert_clear();
        scenarios = scenarios + 1;

        reset_both();
        @(negedge aclk); aclk_running = 0;
        common_aresetn = 0;
        repeat (5) @(negedge video_clk);
        common_aresetn = 1;
        repeat (8) @(negedge video_clk);
        pulse_overflow();
        aclk_running = 1;
        wait (capture_aresetn === 1);
        #1; assert_overflow();
        scenarios = scenarios + 1;

        reset_both();
        @(negedge aclk); underflow = 1;
        pulse_overflow();
        @(negedge aclk); underflow = 0;
        repeat (8) @(negedge aclk);
        if (source_fault !== 1 || status !== 2'b11) $fatal(1, "Combined source fault lost");
        scenarios = scenarios + 1;
        reset_both();
        if (scenarios != 24) $fatal(1, "CDC scenario count differs: %0d", scenarios);
        $display("CDC_CASE_PASS case=%0d video_half=%0d aclk_half=%0d scenarios=%0d", CASE_ID, VIDEO_HALF, ACLK_HALF, scenarios);
        done = 1;
    end
endmodule

module tb_vision_source_fault_cdc;
    wire [2:0] done;
    vision_source_fault_cdc_case #(.CASE_ID(0), .VIDEO_HALF(2), .ACLK_HALF(5)) fast_video (.done(done[0]));
    vision_source_fault_cdc_case #(.CASE_ID(1), .VIDEO_HALF(11), .ACLK_HALF(3)) slow_video (.done(done[1]));
    vision_source_fault_cdc_case #(.CASE_ID(2), .VIDEO_HALF(7), .ACLK_HALF(5)) drifting (.done(done[2]));
    initial begin
        wait (&done);
        $display("TEST_PASS VISION_SOURCE_FAULT_CDC cases=3 scenarios=72 PULSE_STICKY_CLOCK_STOP_COMMON_RESET_ARMING");
        $finish;
    end
    initial begin
        #190000;
        $fatal(1, "CDC watchdog expired");
    end
endmodule