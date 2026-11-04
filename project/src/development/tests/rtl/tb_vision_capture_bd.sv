`timescale 1ns/1ps
module capture_bd_fault_unit(output reg done = 0);
    reg clock = 0;
    always #5 clock = !clock;
    reg resetn = 0, source_valid = 0, source_fault = 0, abort_requested = 0;
    reg [2:0] source_keep = 3'b111;
    wire source_ready, frame_fault, pipeline_drained;
    integer scenario;
    axis_rgb_capture_bd #(.INPUT_WIDTH(4), .INPUT_HEIGHT(4)) dut (
        .aclk(clock), .aresetn(resetn), .s_axis_tdata(24'h0000ff), .s_axis_tkeep(source_keep),
        .s_axis_tvalid(source_valid), .s_axis_tready(source_ready), .s_axis_tuser(1'b1), .s_axis_tlast(1'b0),
        .cfg_frame_context({32'd3,32'd2,32'd1,48'hff2dff231600}),
        .source_closed(1'b0), .closed_frame_count(32'd0),
        .frame_credit_ready(1'b1),
        .source_fault(source_fault), .abort_requested(abort_requested), .m_rgb_tready(1'b1),
        .m_packet_tready(1'b1), .frame_fault(frame_fault), .pipeline_drained(pipeline_drained)
    );
    task automatic reset_case;
        @(negedge clock);
        resetn = 0;
        source_valid = 0;
        source_keep = 3'b111;
        source_fault = 0;
        abort_requested = 0;
        repeat (4) @(negedge clock);
        resetn = 1;
        repeat (2) @(negedge clock);
        if (frame_fault || pipeline_drained || !source_ready) $fatal(1,"BD_CAPTURE reset recovery failed");
    endtask
    initial begin
        for (scenario = 0; scenario < 4; scenario++) begin
            reset_case();
            case (scenario)
                0: begin source_keep = 3'b011; source_valid = 1; end
                1: begin source_keep = 3'b000; source_valid = 1; end
                2: abort_requested = 1;
                3: source_fault = 1;
            endcase
            repeat (2) @(negedge clock);
            source_keep = 3'b111;
            source_valid = 0;
            abort_requested = 0;
            source_fault = 0;
            repeat (8) @(negedge clock);
            if (!frame_fault || source_ready || pipeline_drained) $fatal(1,"BD_CAPTURE sticky fault failed scenario=%0d",scenario);
        end
        reset_case();
        source_keep = 0;
        repeat (8) @(negedge clock);
        if (frame_fault || !source_ready || pipeline_drained) $fatal(1,"BD_CAPTURE idle keep caused fault");
        done = 1;
    end
endmodule

module tb_vision_capture_bd;
    wire capture_done, fault_done;
    capture_drain_integration #(
        .USE_AXI_WRITE_PROOF(1), .USE_BD_WRAPPER(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r333-bd-output")
    ) capture_case(capture_done);
    capture_bd_fault_unit fault_case(fault_done);
    initial begin
        wait (capture_done && fault_done);
        $display("TEST_PASS VISION_CAPTURE_BD epochs=2 packets=4 fault_cases=5 CRC_TWO_OUTPUT_STALL_RESET_KEEP_ABORT_RESPONSE_GATES");
        $finish;
    end
    initial begin #2000000; $fatal(1,"BD_CAPTURE watchdog"); end
endmodule

module tb_vision_capture_bd_compat;
    wire capture_done, unit_done;
    capture_drain_integration #(
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r334-compat-output")
    ) capture_case(capture_done);
    capture_drain_unit unit_case(unit_done);
    initial begin
        wait (capture_done && unit_done);
        $display("TEST_PASS VISION_CAPTURE_BD_COMPAT original_unit_cases=10 epochs=2 packets=4 ORIGINAL_DEFAULT_BRANCH");
        $finish;
    end
    initial begin #2000000; $fatal(1,"BD_CAPTURE_COMPAT watchdog"); end
endmodule

module tb_vision_capture_bd_default_guard #(
    parameter OUTPUT_ROOT = "E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r416-native-bd-dma/legacy"
);
    wire capture_done, fault_done;
    capture_drain_integration #(
        .USE_AXI_WRITE_PROOF(1), .USE_BD_WRAPPER(1),
        .OUTPUT_ROOT(OUTPUT_ROOT)
    ) capture_case(capture_done);
    capture_bd_fault_unit fault_case(fault_done);
    initial begin
        wait (capture_done && fault_done);
        $display("TEST_PASS VISION_CAPTURE_BD_DEFAULT_GUARD epochs=2 packets=4 fault_cases=5 ORIGINAL_DEFAULTS");
        $finish;
    end
    initial begin #2000000; $fatal(1,"BD_CAPTURE_DEFAULT_GUARD watchdog"); end
endmodule

module tb_vision_capture_bd_budget_tied;
    tb_vision_capture_bd_default_guard #(
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r417-bd-budget-tied/packets")
    ) cases ();
endmodule