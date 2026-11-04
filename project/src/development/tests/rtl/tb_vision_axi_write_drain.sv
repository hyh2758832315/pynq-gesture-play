`timescale 1ns/1ps
module tb_vision_single_beat_status;
    reg aclk = 0;
    always #5 aclk = ~aclk;
    reg aresetn = 0, awvalid = 0, wvalid = 0, bvalid = 0;
    reg [7:0] awlen = 0;
    wire writes_drained, integrity_fault;
    wire [31:0] acknowledged_frames;
    integer checks = 0;
    vision_axi_write_drain #(
        .DATA_BYTES(4), .EXPECTED_BYTES(4), .CONTINUOUS(1),
        .TRACK_FRAME_COMPLETIONS(1)
    ) dut (
        .aclk, .aresetn, .awvalid, .awready(1'b1), .awlen,
        .wvalid, .wready(1'b1), .wlast(1'b1), .wstrb(4'hf),
        .bvalid, .bready(1'b1), .bresp(2'b00), .upstream_fault(1'b0),
        .source_closed(1'b0), .closed_byte_count(64'd0),
        .writes_drained, .acknowledged_frames, .integrity_fault
    );
    initial begin
        for (integer bypass_mode = 0; bypass_mode < 2; bypass_mode = bypass_mode + 1) begin
            for (integer length_value = 0; length_value < 256; length_value = length_value + 1) begin
                @(negedge aclk);
                aresetn = 0; awvalid = 0; wvalid = 0; bvalid = 0;
                repeat (2) @(posedge aclk);
                @(negedge aclk);
                aresetn = 1; awvalid = 1; wvalid = 1;
                awlen = length_value[7:0]; bvalid = bypass_mode != 0;
                @(posedge aclk);
                @(negedge aclk);
                awvalid = 0; wvalid = 0; awlen = ~length_value[7:0];
                bvalid = bypass_mode == 0;
                @(posedge aclk);
                @(negedge aclk);
                bvalid = 0;
                repeat (3) @(posedge aclk);
                #0.001;
                if (acknowledged_frames !== (length_value == 0 ? 32'd1 : 32'd0) ||
                    integrity_fault !== (length_value != 0))
                    $fatal(1, "single beat mismatch AWLEN=%0d bypass=%0d ack=%0d fault=%b",
                        length_value, bypass_mode, acknowledged_frames, integrity_fault);
                checks = checks + 1;
            end
        end
        $display("TEST_PASS SINGLE_BEAT_STATUS checks=%0d FULL_AWLEN QUEUED_LENGTH BYPASS", checks);
        $finish;
    end
    initial begin
        #1000000;
        $fatal(1, "single beat status watchdog");
    end
endmodule

module axi_write_drain_cases #(parameter integer DATA_BYTES = 4)(output reg done = 0);
    reg aclk = 0;
    always #5 aclk = ~aclk;
    reg aresetn = 0, awvalid = 0, awready = 0, wvalid = 0, wready = 0;
    reg wlast = 0, bvalid = 0, bready = 0, upstream_fault = 0;
    reg [7:0] awlen = 0;
    reg [DATA_BYTES-1:0] wstrb = 0;
    reg [1:0] bresp = 0;
    wire writes_drained, integrity_fault;
    wire [31:0] acknowledged_frames;
    wire source_closed = 1'b0;
    wire [63:0] closed_byte_count = 64'd0;
    integer scenarios = 0, checks = 0, beat;
    vision_axi_write_drain #(.DATA_BYTES(DATA_BYTES), .EXPECTED_BYTES(16), .MAX_WRITE_BEATS(16)) dut (.*);
    task automatic tick;
        begin @(posedge aclk); #0.001; @(negedge aclk); end
    endtask
    task automatic expect_state(input bit drained, fault);
        begin
            #0.001;
            if (writes_drained !== drained || integrity_fault !== fault)
                $fatal(1,"WRITE_DRAIN bytes=%0d case=%0d expected=%b/%b actual=%b/%b",DATA_BYTES,scenarios,drained,fault,writes_drained,integrity_fault);
            checks = checks + 1;
        end
    endtask
    task automatic reset_case;
        begin
            @(negedge aclk);
            aresetn = 0; awvalid = 0; awready = 0; wvalid = 0; wready = 0;
            wlast = 0; wstrb = 0; bvalid = 0; bready = 0; bresp = 0; upstream_fault = 0;
            repeat (2) tick();
            aresetn = 1; tick(); expect_state(0,0);
        end
    endtask
    task automatic address(input [7:0] length);
        begin awlen = length; awvalid = 1; awready = 1; tick(); awvalid = 0; awready = 0; end
    endtask
    task automatic data_beat(input [DATA_BYTES-1:0] strobes, input bit last);
        begin wstrb = strobes; wlast = last; wvalid = 1; wready = 1; tick(); wvalid = 0; wready = 0; end
    endtask
    task automatic response(input [1:0] status);
        begin bresp = status; bvalid = 1; bready = 1; tick(); bvalid = 0; bready = 0; end
    endtask
    task automatic four_words;
        begin
            for (integer word_index = 0; word_index < 4; word_index = word_index + 1)
                data_beat(4'hf,word_index == 3);
        end
    endtask
    task automatic finish_case(input string label_text);
        begin scenarios = scenarios + 1; $display("WRITE_CASE_PASS bytes=%0d case=%0d %s",DATA_BYTES,scenarios,label_text); end
    endtask
    initial begin
        reset_case(); repeat (8) begin tick(); expect_state(0,0); end
        finish_case("idle_is_not_complete");

        reset_case(); address(3); four_words(); expect_state(0,0);
        bvalid = 1; bready = 0;
        repeat (64) begin tick(); expect_state(0,0); end
        bready = 1; tick(); bvalid = 0; bready = 0; expect_state(1,0);
        finish_case("last_response_stall64");

        reset_case(); four_words(); expect_state(0,0); address(3); response(0); expect_state(1,0);
        finish_case("write_data_before_address");

        reset_case(); awvalid = 1; awready = 0; awlen = 3;
        repeat (7) begin tick(); expect_state(0,0); end
        awready = 1; tick(); awvalid = 0; awready = 0;
        four_words(); response(0); expect_state(1,0); finish_case("address_stall_no_phantom_accept");

        reset_case(); address(1); address(1);
        data_beat(15,0); data_beat(15,1); data_beat(15,0); data_beat(15,1);
        response(0); expect_state(0,0); response(0); expect_state(1,0);
        finish_case("two_outstanding_responses");

        reset_case(); address(4);
        data_beat(15,0); data_beat(15,0); data_beat(15,0); data_beat(7,0); data_beat(1,1);
        response(0); expect_state(1,0); finish_case("partial_strobes_exact_bytes");

        for (integer status = 1; status < 4; status = status + 1) begin
            reset_case(); address(3); four_words(); response(status[1:0]); expect_state(0,1);
            repeat (4) tick(); expect_state(0,1); finish_case("non_okay_response_sticky");
        end

        reset_case(); response(0); expect_state(0,1); finish_case("unsolicited_response");
        reset_case(); address(3); response(0); expect_state(0,1); finish_case("response_before_last_write");

        reset_case(); address(3);
        repeat (4) data_beat(15,0);
        response(0); expect_state(0,1); finish_case("missing_wlast_rejected");

        reset_case(); address(4); four_words(); response(0); expect_state(0,0);
        finish_case("declared_beats_incomplete");

        reset_case(); address(3); four_words(); response(0); expect_state(1,0);
        data_beat(1,1); expect_state(0,1); finish_case("extra_write_after_completion");

        reset_case(); address(3); four_words(); response(0); expect_state(1,0);
        address(0); expect_state(0,1); finish_case("extra_address_after_completion");

        reset_case(); address(3); four_words(); response(0); expect_state(1,0);
        response(0); expect_state(0,1); finish_case("duplicate_response");

        reset_case(); address(255); expect_state(0,1); finish_case("declared_beat_capacity");
        reset_case(); repeat (17) data_beat(0,0); expect_state(0,1); finish_case("zero_strobe_beat_saturation");
        reset_case(); repeat (17) address(0); expect_state(0,1); finish_case("address_count_saturation");

        reset_case(); address(15);
        for (beat = 0; beat < 16; beat = beat + 1) data_beat(1 << (beat % DATA_BYTES),beat == 15);
        response(0); expect_state(1,0); finish_case("all_strobe_lanes_boundary");

        reset_case(); address(3); data_beat(15,0); upstream_fault = 1; tick(); upstream_fault = 0;
        expect_state(0,1); finish_case("upstream_fault_sticky");

        reset_case(); address(3); data_beat(15,0);
        reset_case(); expect_state(0,0); address(3); four_words(); response(0); expect_state(1,0);
        finish_case("partial_reset_recovery");

        if (scenarios != 22) $fatal(1,"WRITE_DRAIN case count differs");
        $display("WRITE_UNIT_PASS bytes=%0d scenarios=%0d checks=%0d",DATA_BYTES,scenarios,checks);
        done = 1;
    end
endmodule

module tb_vision_axi_write_drain;
    wire done4, done8;
    axi_write_drain_cases #(.DATA_BYTES(4)) cases4(.done(done4));
    axi_write_drain_cases #(.DATA_BYTES(8)) cases8(.done(done8));
    initial begin
        wait (done4 && done8);
        $display("TEST_PASS VISION_AXI_WRITE_DRAIN scenarios=44 widths=4,8 LAST_B_STALL_W_BEFORE_AW_STROBES_SATURATION_RESET");
        $finish;
    end
    initial begin #1000000; $fatal(1,"WRITE_DRAIN watchdog"); end
endmodule

module capture_write_response_model #(
    parameter integer EXPECTED_BYTES = 96,
    parameter [3:0] STROBES = 4'h7
)(
    input wire clock, resetn, accepted, allow_response, upstream_fault,
    output wire writes_done, fault
);
    integer pending_responses = 0;
    wire response_valid = pending_responses != 0;
    always @(posedge clock) begin
        if (!resetn) pending_responses <= 0;
        else case ({accepted,response_valid && allow_response})
            2'b10: pending_responses <= pending_responses + 1;
            2'b01: pending_responses <= pending_responses - 1;
            default: pending_responses <= pending_responses;
        endcase
    end
    vision_axi_write_drain #(.DATA_BYTES(4),.EXPECTED_BYTES(EXPECTED_BYTES)) monitor (
        .aclk(clock),.aresetn(resetn),.awvalid(accepted),.awready(1'b1),.awlen(8'd0),
        .wvalid(accepted),.wready(1'b1),.wlast(1'b1),.wstrb(STROBES),
        .bvalid(response_valid),.bready(allow_response),.bresp(2'b00),
        .upstream_fault(upstream_fault),.writes_drained(writes_done),.integrity_fault(fault)
    );
endmodule

module tb_vision_capture_write_drain;
    wire done;
    capture_drain_integration #(
        .USE_AXI_WRITE_PROOF(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r300-write-capture-output")
    ) capture_case(.done(done));
    initial begin
        wait (done);
        $display("TEST_PASS VISION_CAPTURE_WRITE_DRAIN epochs=2 packets=4 REAL_CAPTURE_REAL_FENCE_TWO_AXI_RESPONSE_OBSERVERS");
        $finish;
    end
    initial begin #2000000; $fatal(1,"WRITE_CAPTURE watchdog"); end
endmodule

module tb_vision_capture_drain_compat;
    wire unit_done, capture_done;
    capture_drain_unit unit_case(.done(unit_done));
    capture_drain_integration #(
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r302-compat-output")
    ) capture_case(.done(capture_done));
    initial begin
        wait (unit_done && capture_done);
        $display("TEST_PASS VISION_CAPTURE_DRAIN_COMPAT unit_scenarios=10 epochs=2 packets=4 DEFAULT_WRITE_PROOF_DISABLED");
        $finish;
    end
    initial begin #2000000; $fatal(1,"WRITE_COMPAT watchdog"); end
endmodule

module tb_vision_dma_write_pair #(parameter integer CONTINUOUS = 0, parameter integer TRACK_FRAME_COMPLETIONS = 0, parameter integer SG_STATUS = 0);
    reg aclk = 0;
    always #5 aclk = ~aclk;
    reg aresetn = 0, capture_fault = 0;
    reg source_closed = 0;
    reg [31:0] closed_frame_count = 0;
    reg rgb_address_valid = 0, rgb_address_ready = 0;
    reg [31:0] rgb_address = 32'h12340000;
    reg [63:0] rgb_write_data = 64'h0123456789abcdef;
    reg [7:0] rgb_address_length = 1;
    reg rgb_data_valid = 0, rgb_data_ready = 0, rgb_data_last = 0;
    reg [7:0] rgb_data_strobes = 8'hff;
    reg rgb_response_valid = 0, rgb_response_ready = 0;
    reg [1:0] rgb_response_status = 0;
    reg packet_address_valid = 0, packet_address_ready = 0;
    reg [31:0] packet_address = 32'h56780000;
    reg [63:0] packet_write_data = 64'hfedcba9876543210;
    reg [7:0] packet_address_length = 1;
    reg packet_data_valid = 0, packet_data_ready = 0, packet_data_last = 0;
    reg [7:0] packet_data_strobes = 8'hff;
    reg packet_response_valid = 0, packet_response_ready = 0;
    reg [1:0] packet_response_status = 0;
    wire rgb_writes_drained, packet_writes_drained, writes_drained, status_fault;
    wire status_writes_drained;
    wire [31:0] rgb_completed_frames, packet_completed_frames, status_completed_frames;
    reg status_manual = 0, status_manual_valid = 0, status_manual_ready = 0;
    reg [1:0] status_manual_response = 0;
    wire status_address_valid = SG_STATUS && packet_address_valid;
    wire status_address_ready = SG_STATUS && packet_address_ready;
    wire [31:0] status_address = 32'h56790000;
    wire [7:0] status_address_length = 0;
    wire [31:0] status_write_data = 32'h80000010;
    wire status_data_valid = SG_STATUS && packet_data_valid && packet_data_last;
    wire status_data_ready = SG_STATUS && packet_data_ready;
    wire status_data_last = 1;
    wire [3:0] status_data_strobes = 15;
    wire status_response_valid = SG_STATUS && (status_manual ? status_manual_valid : packet_response_valid);
    wire status_response_ready = SG_STATUS && (status_manual ? status_manual_ready : packet_response_ready);
    wire [1:0] status_response_status = status_manual ? status_manual_response : packet_response_status;
    reg [31:0] expected_rgb_frames = 0, expected_packet_frames = 0, expected_status_frames = 0;
    reg expected_rgb_fault = 0, expected_packet_fault = 0, expected_status_fault = 0;
    wire done4, done8;
    integer scenarios = 0, checks = 0;
    vision_dma_write_pair #(.RGB_BYTES(16), .PACKET_BYTES(16), .CONTINUOUS(CONTINUOUS),
        .TRACK_FRAME_COMPLETIONS(TRACK_FRAME_COMPLETIONS), .SG_STATUS(SG_STATUS)) dut (
        .status_address_size(3'd2), .status_address_burst(2'b01), .status_address_protection(3'd0), .status_address_cache(4'd3),
        .status_read_address(32'd0), .status_read_address_length(8'd0), .status_read_address_size(3'd2),
        .status_read_address_burst(2'b01), .status_read_address_protection(3'd0), .status_read_address_cache(4'd3),
        .status_read_address_valid(1'b1), .status_read_address_ready(1'b1),
        .status_read_data(32'd0), .status_read_response(2'b00), .status_read_last(1'b1), .status_read_valid(1'b1), .status_read_ready(1'b1), .*
    );
    always @(posedge aclk) begin
        if (!aresetn) begin
            expected_rgb_frames <= 0; expected_packet_frames <= 0; expected_status_frames <= 0;
            expected_rgb_fault <= 0; expected_packet_fault <= 0; expected_status_fault <= 0;
        end else begin
            if (capture_fault || (rgb_response_valid && rgb_response_ready && rgb_response_status != 0)) expected_rgb_fault <= 1;
            if (capture_fault || (packet_response_valid && packet_response_ready && packet_response_status != 0)) expected_packet_fault <= 1;
            if (capture_fault || (status_response_valid && status_response_ready && status_response_status != 0)) expected_status_fault <= 1;
            if (!capture_fault && !expected_rgb_fault && rgb_response_valid && rgb_response_ready && rgb_response_status == 0)
                expected_rgb_frames <= expected_rgb_frames+1;
            if (!capture_fault && !expected_packet_fault && packet_response_valid && packet_response_ready && packet_response_status == 0)
                expected_packet_frames <= expected_packet_frames+1;
            if (!capture_fault && !expected_status_fault && status_response_valid && status_response_ready && status_response_status == 0)
                expected_status_frames <= expected_status_frames+1;
        end
    end
    axi_write_drain_cases #(.DATA_BYTES(4)) original4(.done(done4));
    axi_write_drain_cases #(.DATA_BYTES(8)) original8(.done(done8));
    task automatic tick;
        begin
            @(posedge aclk); #0.001; @(negedge aclk);
            if (TRACK_FRAME_COMPLETIONS && ({rgb_completed_frames,packet_completed_frames,status_completed_frames} !==
                {expected_rgb_frames,expected_packet_frames,SG_STATUS ? expected_status_frames : 32'd0}))
                $fatal(1,"WRITE_PAIR per-frame receipts differ from independent B scoreboard");
        end
    endtask
    task automatic expect_state(input bit rgb_done, packet_done, fault);
        begin
            #0.001;
            if ({rgb_writes_drained,packet_writes_drained,writes_drained,status_fault} !==
                {rgb_done,packet_done,rgb_done && packet_done,fault})
                $fatal(1,"WRITE_PAIR case=%0d expected=%b%b%b%b actual=%b%b%b%b",scenarios,
                    rgb_done,packet_done,rgb_done && packet_done,fault,
                    rgb_writes_drained,packet_writes_drained,writes_drained,status_fault);
            checks = checks + 1;
        end
    endtask
    task automatic reset_case;
        begin
            aresetn = 0; capture_fault = 0;
            status_manual = 0; status_manual_valid = 0; status_manual_ready = 0; status_manual_response = 0;
            source_closed = 0; closed_frame_count = 0;
            rgb_address_valid = 0; rgb_address_ready = 0;
            packet_address_valid = 0; packet_address_ready = 0;
            rgb_data_valid = 0; rgb_data_ready = 0; rgb_data_last = 0;
            packet_data_valid = 0; packet_data_ready = 0; packet_data_last = 0;
            rgb_response_valid = 0; rgb_response_ready = 0; rgb_response_status = 0;
            packet_response_valid = 0; packet_response_ready = 0; packet_response_status = 0;
            repeat (2) tick(); aresetn = 1; tick(); expect_state(0,0,0);
        end
    endtask
    task automatic both_payloads;
        begin
            rgb_data_last = 0; packet_data_last = 0;
            rgb_address_valid = 1; rgb_address_ready = 1;
            packet_address_valid = 1; packet_address_ready = 1; tick();
            rgb_address_valid = 0; packet_address_valid = 0;
            rgb_data_valid = 1; rgb_data_ready = 1;
            packet_data_valid = 1; packet_data_ready = 1; tick();
            rgb_data_last = 1; packet_data_last = 1; tick();
            rgb_data_valid = 0; packet_data_valid = 0; expect_state(0,0,0);
        end
    endtask
    task automatic prepare_epoch;
        begin
            for (integer frame_index = 0; frame_index < (CONTINUOUS ? 3 : 1); frame_index = frame_index + 1) begin
                both_payloads();
                if (CONTINUOUS && frame_index < 2) begin
                    rgb_response_valid = 1; packet_response_valid = 1;
                    rgb_response_ready = 1; packet_response_ready = 1; tick();
                    rgb_response_valid = 0; packet_response_valid = 0;
                    rgb_response_ready = 0; packet_response_ready = 0;
                    expect_state(0,0,0);
                end
            end
            if (CONTINUOUS) begin
                source_closed = 1; closed_frame_count = 3; tick(); expect_state(0,0,0);
            end
        end
    endtask
    initial begin
        for (integer first_channel = 0; first_channel < 2; first_channel = first_channel + 1) begin
            reset_case(); prepare_epoch();
            rgb_response_valid = 1; packet_response_valid = 1;
            rgb_response_ready = first_channel == 0;
            packet_response_ready = first_channel == 1; tick();
            if (first_channel == 0) rgb_response_valid = 0;
            else packet_response_valid = 0;
            repeat (64) begin tick(); expect_state(first_channel == 0,first_channel == 1,0); end
            rgb_response_ready = 1; packet_response_ready = 1; tick();
            rgb_response_valid = 0; packet_response_valid = 0; expect_state(1,1,0);
            scenarios = scenarios + 1;
        end
        for (integer failing_channel = 0; failing_channel < 2; failing_channel = failing_channel + 1) begin
            reset_case(); prepare_epoch();
            rgb_response_status = failing_channel == 0 ? 2'b10 : 2'b00;
            packet_response_status = failing_channel == 1 ? 2'b10 : 2'b00;
            rgb_response_valid = 1; rgb_response_ready = 1;
            packet_response_valid = 1; packet_response_ready = 1; tick();
            rgb_response_valid = 0; packet_response_valid = 0;
            repeat (4) begin tick(); expect_state(failing_channel != 0,failing_channel != 1,1); end
            scenarios = scenarios + 1;
        end
        reset_case(); prepare_epoch(); capture_fault = 1;
        expect_state(0,0,1); tick(); capture_fault = 0; expect_state(0,0,1);
        scenarios = scenarios + 1;
        reset_case(); prepare_epoch();
        rgb_response_valid = 1; rgb_response_ready = 1;
        packet_response_valid = 1; packet_response_ready = 1; tick();
        rgb_response_valid = 0; packet_response_valid = 0; expect_state(1,1,0);
        reset_case(); scenarios = scenarios + 1;
        if (SG_STATUS) begin
            reset_case(); prepare_epoch(); status_manual = 1;
            status_manual_valid = 1;
            rgb_response_valid = 1; rgb_response_ready = 1;
            packet_response_valid = 1; packet_response_ready = 1; tick();
            rgb_response_valid = 0; packet_response_valid = 0;
            repeat (64) begin
                tick();
                if (!rgb_writes_drained || !packet_writes_drained || status_writes_drained || writes_drained || status_fault || status_completed_frames != 2)
                    $fatal(1,"WRITE_PAIR final SG B escaped frame/drain gate");
                checks = checks+1;
            end
            status_manual_ready = 1; tick(); status_manual_valid = 0; expect_state(1,1,0);
            if (status_completed_frames != 3) $fatal(1,"WRITE_PAIR final SG completion missing");
            scenarios = scenarios+1;

            reset_case(); prepare_epoch(); status_manual = 1; status_manual_valid = 1;
            status_manual_ready = 1; status_manual_response = 2;
            rgb_response_valid = 1; rgb_response_ready = 1;
            packet_response_valid = 1; packet_response_ready = 1; tick();
            rgb_response_valid = 0; packet_response_valid = 0; status_manual_valid = 0;
            repeat (4) begin
                tick();
                if (!rgb_writes_drained || !packet_writes_drained || status_writes_drained || writes_drained || !status_fault || status_completed_frames != 2)
                    $fatal(1,"WRITE_PAIR SG error failed to poison common owner");
                checks = checks+1;
            end
            scenarios = scenarios+1;
        end
        wait (done4 && done8);
        if (scenarios != (SG_STATUS ? 8 : 6) || checks < 140) $fatal(1,"WRITE_PAIR coverage gate");
        $display("TEST_PASS VISION_DMA_WRITE_PAIR scenarios=%0d checks=%0d ORIGINAL44 BOTH_B_STALL64 FAULT_STICKY_RESET CONTINUOUS=%0d",scenarios,checks,CONTINUOUS);
        if (TRACK_FRAME_COMPLETIONS) $display("TEST_PASS WRITE_PAIR_FRAME_RECEIPTS channels=%0d SG_STATUS_B_STALL64 SG_ERROR_STICKY INDEPENDENT_B_SCOREBOARD",SG_STATUS ? 3 : 2);
        $finish;
    end
    initial begin #1000000; $fatal(1,"WRITE_PAIR watchdog"); end
endmodule

module tb_vision_write_response_comparison;
    reg aclk = 0, aresetn = 1;
    reg awvalid = 0, awready = 0, wvalid = 0, wready = 0, wlast = 0;
    reg [63:0] response_value, available_value;
    reg [64:0] reference_response, reference_addresses, reference_lasts;
    wire writes_drained, integrity_fault;
    wire [31:0] acknowledged_frames;
    integer checks = 0;
    vision_axi_write_drain #(.DATA_BYTES(4), .EXPECTED_BYTES(16),
        .MAX_WRITE_BEATS(16), .CONTINUOUS(1), .TRACK_FRAME_COMPLETIONS(1)) dut (
        .aclk(aclk), .aresetn(aresetn), .awvalid(awvalid), .awready(awready), .awlen(8'd0),
        .wvalid(wvalid), .wready(wready), .wlast(wlast), .wstrb(4'hf),
        .bvalid(1'b0), .bready(1'b1), .bresp(2'b00), .upstream_fault(1'b0),
        .source_closed(1'b0), .closed_byte_count(64'd0), .writes_drained(writes_drained),
        .acknowledged_frames(acknowledged_frames), .integrity_fault(integrity_fault)
    );
    function automatic [63:0] boundary_value(input integer position);
        if (position < 16) boundary_value = position;
        else case (position)
            16: boundary_value = 64'h000000007fffffff;
            17: boundary_value = 64'h00000000ffffffff;
            18: boundary_value = 64'h0000000100000000;
            19: boundary_value = 64'h7fffffffffffffff;
            20: boundary_value = 64'h8000000000000000;
            21: boundary_value = 64'hfffffffffffffffe;
            default: boundary_value = 64'hffffffffffffffff;
        endcase
    endfunction
    initial begin
        for (integer response_index = 0; response_index < 23; response_index = response_index + 1)
            for (integer available_index = 0; available_index < 23; available_index = available_index + 1)
                for (integer handshake = 0; handshake < 32; handshake = handshake + 1) begin
                    response_value = boundary_value(response_index);
                    available_value = boundary_value(available_index);
                    dut.response_count = response_value;
                    dut.aw_count = available_value;
                    dut.last_count = available_value;
                    {wlast,wready,wvalid,awready,awvalid} = handshake[4:0];
                    reference_response = 65'd1 + response_value;
                    reference_addresses = 65'd0 + available_value + (awvalid && awready);
                    reference_lasts = 65'd0 + available_value + (wvalid && wready && wlast);
                    #1;
                    if (dut.response_has_address !== (reference_response <= reference_addresses) ||
                        dut.response_has_last !== (reference_response <= reference_lasts))
                        $fatal(1,"WRITE_RESPONSE comparison mismatch response=%h available=%h handshake=%h",
                            response_value,available_value,handshake);
                    checks = checks + 2;
                end
        if (checks != 33856) $fatal(1,"WRITE_RESPONSE comparison coverage missing");
        $display("TEST_PASS WRITE_RESPONSE_COMPARISON checks=%0d EXACT_65BIT_REFERENCE MAX_U64 ALL_HANDSHAKES",checks);
        $finish;
    end
    initial begin #1000000; $fatal(1,"WRITE_RESPONSE comparison watchdog"); end
endmodule

module tb_vision_continuous_write_drain;
    reg aclk = 0;
    always #5 aclk = ~aclk;
    reg aresetn = 0, awvalid = 0, wvalid = 0, wlast = 0, bvalid = 0, bready = 1;
    reg source_closed = 0;
    reg [63:0] closed_byte_count = 0;
    reg [7:0] awlen = 0;
    reg [3:0] wstrb = 15;
    reg [1:0] bresp = 0;
    wire drained, fault, done4, done8;
    integer checks = 0, beat;
    axi_write_drain_cases #(.DATA_BYTES(4)) legacy4 (.done(done4));
    axi_write_drain_cases #(.DATA_BYTES(8)) legacy8 (.done(done8));
    vision_axi_write_drain #(.DATA_BYTES(4), .EXPECTED_BYTES(16), .MAX_WRITE_BEATS(16), .CONTINUOUS(1)) dut (
        .aclk(aclk), .aresetn(aresetn), .awvalid(awvalid), .awready(1'b1), .awlen(awlen),
        .wvalid(wvalid), .wready(1'b1), .wlast(wlast), .wstrb(wstrb), .bvalid(bvalid), .bready(bready), .bresp(bresp),
        .upstream_fault(1'b0), .source_closed(source_closed), .closed_byte_count(closed_byte_count),
        .writes_drained(drained), .integrity_fault(fault)
    );
    task automatic check(input bit condition, input string message);
        checks = checks + 1;
        if (!condition) $fatal(1,"CONTINUOUS_WRITE_FAIL %s",message);
    endtask
    task automatic tick;
        @(posedge aclk); #0.001; @(negedge aclk);
    endtask
    task automatic reset_case;
        @(negedge aclk); aresetn = 0; awvalid = 0; wvalid = 0; wlast = 0; bvalid = 0; bready = 1;
        source_closed = 0; closed_byte_count = 0; bresp = 0; wstrb = 15;
        repeat (3) tick(); aresetn = 1; tick(); check(!drained && !fault,"reset");
    endtask
    task automatic address(input [7:0] length);
        awlen = length; awvalid = 1; tick(); awvalid = 0; #0.001;
    endtask
    task automatic data_words(input integer count, input [3:0] strobes);
        for (integer position = 0; position < count; position = position + 1) begin
            wvalid = 1; wstrb = strobes; wlast = position == count-1; tick();
        end
        wvalid = 0; wlast = 0; #0.001;
    endtask
    task automatic response;
        bvalid = 1; tick(); bvalid = 0; #0.001;
    endtask
    initial begin
        reset_case();
        repeat (2) begin address(3); data_words(4,15); response(); check(!drained && !fault,"running finite byte limit"); end
        address(3); data_words(4,15);
        source_closed = 1; closed_byte_count = 48; bready = 0; bvalid = 1;
        repeat (64) begin tick(); check(!drained && !fault,"pending final B escaped"); end
        bready = 1; tick(); bvalid = 0; #0.001;
        check(drained && !fault,"three-burst closure");
        wvalid = 1; wstrb = 0; wlast = 1; tick(); wvalid = 0;
        check(!drained && fault,"post-budget zero-strobe write accepted");

        reset_case(); data_words(4,15); source_closed = 1; closed_byte_count = 16; tick();
        address(3); response(); check(drained && !fault,"W-before-AW final closure");

        reset_case(); address(255); data_words(256,1); response();
        check(!drained && !fault,"running beat limit remained finite");
        source_closed = 1; closed_byte_count = 256; tick(); check(drained && !fault,"256beat dynamic closure");
        closed_byte_count = 257; tick(); check(!drained && fault,"changed byte budget");

        reset_case(); address(3); data_words(4,15); response(); source_closed = 1; closed_byte_count = 16; tick();
        source_closed = 0; tick(); check(!drained && fault,"withdrawn source closure");

        reset_case(); address(3); data_words(4,15); response(); source_closed = 1; closed_byte_count = 8; tick(); tick();
        check(!drained && fault,"understated final bytes");

        reset_case(); source_closed = 1; tick(); check(drained && !fault,"empty cancelled admission");

        reset_case(); response(); check(!drained && fault,"unsolicited continuous response");

        reset_case(); force dut.byte_count = 64'hffffffffffffffff;
        wvalid = 1; wstrb = 1; tick(); wvalid = 0; release dut.byte_count;
        check(!drained && fault,"64bit byte overflow wrapped");
        wait (done4 && done8);
        $display("TEST_PASS CONTINUOUS_AXI_WRITE scenarios=8 checks=%0d LEGACY44_PASS",checks);
        $finish;
    end
    initial begin #1000000; $fatal(1,"CONTINUOUS_WRITE watchdog"); end
endmodule

module tb_vision_continuous_dma_write_pair;
    tb_vision_dma_write_pair #(.CONTINUOUS(1)) cases ();
endmodule

module tb_vision_actual_packet_dma #(
    parameter integer EXTERNAL_SOURCE = 0,
    parameter integer SCATTER_GATHER = 0,
    parameter integer WIDE_STREAM = 0,
    parameter integer REJECT_STALE_DESCRIPTOR = 0,
    parameter integer FRAME_COUNT = 7,
    parameter integer RECYCLE_SLOTS = 0
)(
    input wire external_clock, external_resetn,
    input wire [31:0] external_data,
    input wire [3:0] external_keep,
    input wire external_valid, external_last, external_closed, allow_final_response,
    input wire cpu_release_accepted,
    input wire [31:0] cpu_released_frames, granted_frames,
    output wire external_ready, external_drained, external_fault,
    output wire [31:0] external_committed_frames,
    output reg external_done = 0
);
    reg local_clock = 0, local_resetn = 0;
    always #5 local_clock = ~local_clock;
    wire clock = EXTERNAL_SOURCE ? external_clock : local_clock;
    wire resetn = EXTERNAL_SOURCE ? external_resetn : local_resetn;
    reg stream_go = 0, release_final_b = 0, replay_closed = 0;
    wire source_closed = EXTERNAL_SOURCE ? external_closed : replay_closed;
    reg [9:0] control_awaddr = 0, control_araddr = 0;
    reg [31:0] control_wdata = 0;
    reg control_awvalid = 0, control_wvalid = 0, control_arvalid = 0;
    wire control_awready, control_wready, control_bvalid, control_arready, control_rvalid;
    wire [1:0] control_bresp, control_rresp;
    wire [31:0] control_rdata;
    wire [31:0] write_address;
    wire [7:0] write_length, write_strobes;
    wire [2:0] write_size, write_protection;
    wire [1:0] write_burst;
    wire [3:0] write_cache;
    wire [63:0] write_data;
    wire address_valid, data_valid, data_last, response_ready, stream_ready, drained, fault;
    wire sg_drained, sg_fault;
    wire [31:0] data_acknowledged_frames, sg_acknowledged_frames;
    reg [31:0] replay_data = 0;
    reg replay_valid = 0, replay_last = 0;
    wire [31:0] stream_data = EXTERNAL_SOURCE ? external_data : replay_data;
    wire [3:0] stream_keep = EXTERNAL_SOURCE ? external_keep : 4'b1111;
    wire stream_valid = EXTERNAL_SOURCE ? external_valid : replay_valid;
    wire stream_last = EXTERNAL_SOURCE ? external_last : replay_last;
    assign external_ready = stream_ready;
    assign external_drained = drained && (!SCATTER_GATHER || sg_drained);
    assign external_fault = fault || (SCATTER_GATHER && sg_fault);
    assign external_committed_frames = !SCATTER_GATHER || data_acknowledged_frames < sg_acknowledged_frames ?
        data_acknowledged_frames : sg_acknowledged_frames;
    reg [7:0] reference_bytes [0:671];
    reg [7:0] memory_bytes [0:895];
    reg written [0:895];
    reg [31:0] addresses [0:15];
    reg [7:0] lengths [0:15];
    localparam integer SLOT_COUNT = RECYCLE_SLOTS ? 3 : FRAME_COUNT;
    integer slot_frame [0:6];
    integer cpu_retired_frames = 0;
    integer cycles = 0, checks = 0, stream_words = 0, written_bytes = 0;
    integer address_head = 0, address_tail = 0, beat_index = 0, pending_responses = 0;
    integer address_count = 0, last_count = 0, response_count = 0;
    integer file_handle, read_count, frame_index, word_index, lane_index, memory_index;
    reg [31:0] status_value;
    wire address_ready = address_tail - address_head < 16 && cycles % 5 != 0;
    wire data_ready = address_head < address_tail && cycles % 7 < 5;
    wire response_valid = pending_responses != 0 && (written_bytes < FRAME_COUNT*96 || release_final_b);

    wire [31:0] sg_awaddr, sg_wdata, sg_araddr;
    wire [7:0] sg_awlen, sg_arlen;
    wire [2:0] sg_awsize, sg_arsize;
    wire [1:0] sg_awburst, sg_arburst;
    wire [3:0] sg_wstrb;
    wire sg_awvalid, sg_wvalid, sg_wlast, sg_bready, sg_arvalid, sg_rready;
    reg sg_write_active = 0, sg_read_active = 0, sg_bvalid = 0, sg_rvalid = 0, sg_rlast = 0;
    reg [31:0] sg_rdata = 0, sg_write_address = 0, sg_read_address = 0;
    integer sg_write_beats = 0, sg_read_beats = 0, descriptor_writes = 0;
    integer published_frames = SCATTER_GATHER ? 0 : FRAME_COUNT;
    reg [31:0] descriptor_memory [0:111];
    reg release_final_sg_b = 0;
    wire sg_response_valid = sg_bvalid && (descriptor_writes < FRAME_COUNT || release_final_sg_b);
    wire sg_awready = !sg_write_active && !sg_bvalid && cycles % 5 != 0;
    wire sg_wready = sg_write_active && cycles % 7 < 5;
    wire sg_arready = !sg_read_active && !sg_rvalid && cycles % 3 != 0;

    if (SCATTER_GATHER && WIDE_STREAM) begin : wide_sg_mode
        wire [63:0] converted_data;
        wire [7:0] converted_keep;
        wire converted_valid, converted_ready, converted_last;
        vvg_packet_width converter (
            .aclk(clock), .aresetn(resetn),
            .s_axis_tdata(stream_data), .s_axis_tkeep(stream_keep),
            .s_axis_tvalid(stream_valid), .s_axis_tready(stream_ready), .s_axis_tlast(stream_last),
            .m_axis_tdata(converted_data), .m_axis_tkeep(converted_keep),
            .m_axis_tvalid(converted_valid), .m_axis_tready(converted_ready), .m_axis_tlast(converted_last)
        );
        vvg_packet_wide_sg dma (
            .s_axi_lite_aclk(clock), .m_axi_sg_aclk(clock), .m_axi_s2mm_aclk(clock), .axi_resetn(resetn),
            .s_axi_lite_awaddr(control_awaddr), .s_axi_lite_awvalid(control_awvalid), .s_axi_lite_awready(control_awready),
            .s_axi_lite_wdata(control_wdata), .s_axi_lite_wvalid(control_wvalid), .s_axi_lite_wready(control_wready),
            .s_axi_lite_bresp(control_bresp), .s_axi_lite_bvalid(control_bvalid), .s_axi_lite_bready(1'b1),
            .s_axi_lite_araddr(control_araddr), .s_axi_lite_arvalid(control_arvalid), .s_axi_lite_arready(control_arready),
            .s_axi_lite_rdata(control_rdata), .s_axi_lite_rresp(control_rresp), .s_axi_lite_rvalid(control_rvalid), .s_axi_lite_rready(1'b1),
            .m_axi_sg_awaddr(sg_awaddr), .m_axi_sg_awlen(sg_awlen), .m_axi_sg_awsize(sg_awsize), .m_axi_sg_awburst(sg_awburst),
            .m_axi_sg_awprot(), .m_axi_sg_awcache(), .m_axi_sg_awvalid(sg_awvalid), .m_axi_sg_awready(sg_awready),
            .m_axi_sg_wdata(sg_wdata), .m_axi_sg_wstrb(sg_wstrb), .m_axi_sg_wlast(sg_wlast),
            .m_axi_sg_wvalid(sg_wvalid), .m_axi_sg_wready(sg_wready), .m_axi_sg_bresp(2'b00), .m_axi_sg_bvalid(sg_response_valid), .m_axi_sg_bready(sg_bready),
            .m_axi_sg_araddr(sg_araddr), .m_axi_sg_arlen(sg_arlen), .m_axi_sg_arsize(sg_arsize), .m_axi_sg_arburst(sg_arburst),
            .m_axi_sg_arprot(), .m_axi_sg_arcache(), .m_axi_sg_arvalid(sg_arvalid), .m_axi_sg_arready(sg_arready),
            .m_axi_sg_rdata(sg_rdata), .m_axi_sg_rresp(2'b00), .m_axi_sg_rlast(sg_rlast), .m_axi_sg_rvalid(sg_rvalid), .m_axi_sg_rready(sg_rready),
            .m_axi_s2mm_awaddr(write_address), .m_axi_s2mm_awlen(write_length), .m_axi_s2mm_awsize(write_size),
            .m_axi_s2mm_awburst(write_burst), .m_axi_s2mm_awprot(write_protection), .m_axi_s2mm_awcache(write_cache),
            .m_axi_s2mm_awvalid(address_valid), .m_axi_s2mm_awready(address_ready),
            .m_axi_s2mm_wdata(write_data), .m_axi_s2mm_wstrb(write_strobes), .m_axi_s2mm_wlast(data_last),
            .m_axi_s2mm_wvalid(data_valid), .m_axi_s2mm_wready(data_ready),
            .m_axi_s2mm_bresp(2'b00), .m_axi_s2mm_bvalid(response_valid), .m_axi_s2mm_bready(response_ready),
            .s_axis_s2mm_tdata(converted_data), .s_axis_s2mm_tkeep(converted_keep), .s_axis_s2mm_tvalid(converted_valid),
            .s_axis_s2mm_tready(converted_ready), .s_axis_s2mm_tlast(converted_last),
            .s2mm_prmry_reset_out_n(), .s2mm_introut(), .axi_dma_tstvec()
        );
    end else if (SCATTER_GATHER) begin : sg_mode
        vvg_packet_sg dma (
            .s_axi_lite_aclk(clock), .m_axi_sg_aclk(clock), .m_axi_s2mm_aclk(clock), .axi_resetn(resetn),
            .s_axi_lite_awaddr(control_awaddr), .s_axi_lite_awvalid(control_awvalid), .s_axi_lite_awready(control_awready),
            .s_axi_lite_wdata(control_wdata), .s_axi_lite_wvalid(control_wvalid), .s_axi_lite_wready(control_wready),
            .s_axi_lite_bresp(control_bresp), .s_axi_lite_bvalid(control_bvalid), .s_axi_lite_bready(1'b1),
            .s_axi_lite_araddr(control_araddr), .s_axi_lite_arvalid(control_arvalid), .s_axi_lite_arready(control_arready),
            .s_axi_lite_rdata(control_rdata), .s_axi_lite_rresp(control_rresp), .s_axi_lite_rvalid(control_rvalid), .s_axi_lite_rready(1'b1),
            .m_axi_sg_awaddr(sg_awaddr), .m_axi_sg_awlen(sg_awlen), .m_axi_sg_awsize(sg_awsize), .m_axi_sg_awburst(sg_awburst),
            .m_axi_sg_awprot(), .m_axi_sg_awcache(), .m_axi_sg_awvalid(sg_awvalid), .m_axi_sg_awready(sg_awready),
            .m_axi_sg_wdata(sg_wdata), .m_axi_sg_wstrb(sg_wstrb), .m_axi_sg_wlast(sg_wlast),
            .m_axi_sg_wvalid(sg_wvalid), .m_axi_sg_wready(sg_wready), .m_axi_sg_bresp(2'b00), .m_axi_sg_bvalid(sg_response_valid), .m_axi_sg_bready(sg_bready),
            .m_axi_sg_araddr(sg_araddr), .m_axi_sg_arlen(sg_arlen), .m_axi_sg_arsize(sg_arsize), .m_axi_sg_arburst(sg_arburst),
            .m_axi_sg_arprot(), .m_axi_sg_arcache(), .m_axi_sg_arvalid(sg_arvalid), .m_axi_sg_arready(sg_arready),
            .m_axi_sg_rdata(sg_rdata), .m_axi_sg_rresp(2'b00), .m_axi_sg_rlast(sg_rlast), .m_axi_sg_rvalid(sg_rvalid), .m_axi_sg_rready(sg_rready),
            .m_axi_s2mm_awaddr(write_address), .m_axi_s2mm_awlen(write_length), .m_axi_s2mm_awsize(write_size),
            .m_axi_s2mm_awburst(write_burst), .m_axi_s2mm_awprot(write_protection), .m_axi_s2mm_awcache(write_cache),
            .m_axi_s2mm_awvalid(address_valid), .m_axi_s2mm_awready(address_ready),
            .m_axi_s2mm_wdata(write_data), .m_axi_s2mm_wstrb(write_strobes), .m_axi_s2mm_wlast(data_last),
            .m_axi_s2mm_wvalid(data_valid), .m_axi_s2mm_wready(data_ready),
            .m_axi_s2mm_bresp(2'b00), .m_axi_s2mm_bvalid(response_valid), .m_axi_s2mm_bready(response_ready),
            .s_axis_s2mm_tdata(stream_data), .s_axis_s2mm_tkeep(stream_keep), .s_axis_s2mm_tvalid(stream_valid),
            .s_axis_s2mm_tready(stream_ready), .s_axis_s2mm_tlast(stream_last),
            .s2mm_prmry_reset_out_n(), .s2mm_introut(), .axi_dma_tstvec()
        );
    end else begin : direct_mode
    c6v_moments_dma_0 dma (
        .s_axi_lite_aclk(clock), .m_axi_s2mm_aclk(clock), .axi_resetn(resetn),
        .s_axi_lite_awaddr(control_awaddr), .s_axi_lite_awvalid(control_awvalid), .s_axi_lite_awready(control_awready),
        .s_axi_lite_wdata(control_wdata), .s_axi_lite_wvalid(control_wvalid), .s_axi_lite_wready(control_wready),
        .s_axi_lite_bresp(control_bresp), .s_axi_lite_bvalid(control_bvalid), .s_axi_lite_bready(1'b1),
        .s_axi_lite_araddr(control_araddr), .s_axi_lite_arvalid(control_arvalid), .s_axi_lite_arready(control_arready),
        .s_axi_lite_rdata(control_rdata), .s_axi_lite_rresp(control_rresp), .s_axi_lite_rvalid(control_rvalid), .s_axi_lite_rready(1'b1),
        .m_axi_s2mm_awaddr(write_address), .m_axi_s2mm_awlen(write_length), .m_axi_s2mm_awsize(write_size),
        .m_axi_s2mm_awburst(write_burst), .m_axi_s2mm_awprot(write_protection), .m_axi_s2mm_awcache(write_cache),
        .m_axi_s2mm_awvalid(address_valid), .m_axi_s2mm_awready(address_ready),
        .m_axi_s2mm_wdata(write_data), .m_axi_s2mm_wstrb(write_strobes), .m_axi_s2mm_wlast(data_last),
        .m_axi_s2mm_wvalid(data_valid), .m_axi_s2mm_wready(data_ready),
        .m_axi_s2mm_bresp(2'b00), .m_axi_s2mm_bvalid(response_valid), .m_axi_s2mm_bready(response_ready),
        .s_axis_s2mm_tdata(stream_data), .s_axis_s2mm_tkeep(stream_keep), .s_axis_s2mm_tvalid(stream_valid),
        .s_axis_s2mm_tready(stream_ready), .s_axis_s2mm_tlast(stream_last),
        .s2mm_prmry_reset_out_n(), .s2mm_introut(), .axi_dma_tstvec()
    );
    end
    if (SCATTER_GATHER) begin : sg_status_monitor
        vision_axi_write_drain #(.DATA_BYTES(4), .EXPECTED_BYTES(4), .CONTINUOUS(1), .TRACK_FRAME_COMPLETIONS(1)) observer (
            .aclk(clock), .aresetn(resetn), .awvalid(sg_awvalid), .awready(sg_awready), .awlen(sg_awlen),
            .wvalid(sg_wvalid), .wready(sg_wready), .wlast(sg_wlast), .wstrb(sg_wstrb),
            .bvalid(sg_response_valid), .bready(sg_bready), .bresp(2'b00), .upstream_fault(1'b0),
            .source_closed(source_closed), .closed_byte_count(64'(FRAME_COUNT*4)), .writes_drained(sg_drained), .integrity_fault(sg_fault),
            .acknowledged_frames(sg_acknowledged_frames)
        );
    end else begin : no_sg_status
        assign sg_drained = 1;
        assign sg_fault = 0;
        assign sg_acknowledged_frames = 0;
    end
    vision_axi_write_drain #(.DATA_BYTES(8), .EXPECTED_BYTES(96), .CONTINUOUS(1), .TRACK_FRAME_COMPLETIONS(1)) observer (
        .aclk(clock), .aresetn(resetn), .awvalid(address_valid), .awready(address_ready), .awlen(write_length),
        .wvalid(data_valid), .wready(data_ready), .wlast(data_last), .wstrb(write_strobes),
        .bvalid(response_valid), .bready(response_ready), .bresp(2'b00), .upstream_fault(1'b0),
        .source_closed(source_closed), .closed_byte_count(64'(FRAME_COUNT*96)), .writes_drained(drained), .integrity_fault(fault),
        .acknowledged_frames(data_acknowledged_frames)
    );
    task automatic check(input bit condition, input string message);
        begin
            checks = checks + 1;
            if (!condition) $fatal(1,"ACTUAL_PACKET_DMA_FAIL %s words=%0d bytes=%0d",message,stream_words,written_bytes);
        end
    endtask
    task automatic tick;
        begin @(posedge clock); #0.001; @(negedge clock); end
    endtask
    task automatic control_write(input [9:0] offset, input [31:0] value);
        reg address_accepted, data_accepted;
        begin
            control_awaddr = offset; control_wdata = value;
            control_awvalid = 1; control_wvalid = 1;
            while (control_awvalid || control_wvalid) begin
                @(posedge clock);
                address_accepted = control_awready;
                data_accepted = control_wready;
                #0.001;
                if (address_accepted) control_awvalid = 0;
                if (data_accepted) control_wvalid = 0;
                @(negedge clock);
            end
            wait (control_bvalid); check(control_bresp == 0,"AXI Lite write response"); tick();
        end
    endtask
    task automatic control_read(input [9:0] offset, output [31:0] value);
        begin
            control_araddr = offset; control_arvalid = 1;
            do @(posedge clock); while (!control_arready);
            #0.001; control_arvalid = 0;
            wait (control_rvalid); value = control_rdata;
            check(control_rresp == 0,"AXI Lite read response"); tick();
        end
    endtask
    always @(negedge clock) cycles = cycles + 1;
    always @(posedge clock) begin
        if (resetn && SCATTER_GATHER) begin
            if (sg_arvalid && sg_arready) begin
                check(sg_arsize == 2 && sg_arburst == 1 && sg_araddr[1:0] == 0,
                    "SG read burst shape");
                check(sg_araddr >= 32'h02000000 && sg_araddr + (sg_arlen+1)*4 <= 32'h02000000+SLOT_COUNT*64,
                    "SG descriptor read range");
                sg_read_address <= sg_araddr; sg_read_beats <= sg_arlen+1; sg_read_active <= 1;
            end
            if (sg_read_active && (!sg_rvalid || sg_rready)) begin
                sg_rdata <= descriptor_memory[(sg_read_address - 32'h02000000)/4];
                sg_rvalid <= 1; sg_rlast <= sg_read_beats == 1;
                sg_read_address <= sg_read_address + 4;
                sg_read_beats <= sg_read_beats - 1;
                if (sg_read_beats == 1) sg_read_active <= 0;
            end else if (sg_rvalid && sg_rready) sg_rvalid <= 0;
            if (sg_response_valid && sg_bready) sg_bvalid <= 0;
            if (sg_awvalid && sg_awready) begin
                check(sg_awsize == 2 && sg_awburst == 1 && sg_awaddr[1:0] == 0,"SG status burst shape");
                check(sg_awaddr >= 32'h02000000 && sg_awaddr + (sg_awlen+1)*4 <= 32'h02000000+SLOT_COUNT*64,
                    "SG descriptor write range");
                sg_write_address <= sg_awaddr; sg_write_beats <= sg_awlen+1; sg_write_active <= 1;
            end
            if (sg_wvalid && sg_wready) begin
                check(sg_wlast == (sg_write_beats == 1) && sg_wstrb == 4'b1111,"SG WLAST/strobes");
                check(sg_write_address[5:0] == 28,"SG may update only descriptor status");
                check(sg_wdata == 32'h8c000060,"SG complete SOF EOF length errors");
                if (RECYCLE_SLOTS) check(descriptor_memory[(sg_write_address-32'h02000000)/4] == 0 &&
                    slot_frame[(sg_write_address-32'h02000000)/64] < published_frames &&
                    slot_frame[(sg_write_address-32'h02000000)/64] < granted_frames,"SG status reused before CPU credit");
                descriptor_memory[(sg_write_address - 32'h02000000)/4] <= sg_wdata;
                descriptor_writes = descriptor_writes + 1;
                sg_write_address <= sg_write_address + 4; sg_write_beats <= sg_write_beats - 1;
                if (sg_wlast) begin sg_write_active <= 0; sg_bvalid <= 1; end
            end
        end
    end
    always @(posedge clock) begin
        if (resetn) begin
            check(!fault && (!SCATTER_GATHER || !sg_fault),"write observer fault");
            if (stream_valid && stream_ready) stream_words = stream_words + 1;
            if (response_valid && response_ready) begin
                pending_responses = pending_responses - 1;
                response_count = response_count + 1;
            end
            if (address_valid && address_ready) begin
                check(write_size == 3 && write_burst == 1 && write_address[2:0] == 0,"AXI memory burst shape");
                if (RECYCLE_SLOTS) check(write_address >= 32'h01000000 && write_address < 32'h01000000+SLOT_COUNT*128 &&
                    slot_frame[(write_address-32'h01000000)/128] < published_frames &&
                    slot_frame[(write_address-32'h01000000)/128] < granted_frames,"packet AW before owner or tail credit");
                addresses[address_tail % 16] = write_address;
                lengths[address_tail % 16] = write_length;
                address_tail = address_tail + 1; address_count = address_count + 1;
            end
            if (data_valid && data_ready) begin
                check(data_last == (beat_index == lengths[address_head % 16]),"AXI WLAST matches AWLEN");
                for (integer lane = 0; lane < 8; lane = lane + 1) begin
                    if (write_strobes[lane]) begin
                        memory_index = addresses[address_head % 16] + beat_index*8 + lane - 32'h01000000;
                        check(memory_index >= 0 && memory_index < SLOT_COUNT*128 && memory_index % 128 < 96,"write outside owned packet region");
                        if (SCATTER_GATHER) check(slot_frame[memory_index/128] < published_frames,"write beyond published descriptor credit");
                        check(!written[memory_index],"duplicate/overwritten packet byte");
                        check(write_data[lane*8 +: 8] === reference_bytes[slot_frame[memory_index/128]*96 + memory_index % 128],"packet byte differs");
                        written[memory_index] = 1; memory_bytes[memory_index] = write_data[lane*8 +: 8];
                        written_bytes = written_bytes + 1;
                    end
                end
                if (data_last) begin
                    address_head = address_head + 1; beat_index = 0;
                    last_count = last_count + 1; pending_responses = pending_responses + 1;
                end else beat_index = beat_index + 1;
            end
            if (RECYCLE_SLOTS && cpu_release_accepted) begin
                check(cpu_released_frames == cpu_retired_frames+1 && external_committed_frames >= cpu_released_frames,
                    "packet CPU retirement before both B receipts or out of order");
                check(descriptor_memory[(cpu_retired_frames%3)*16+7] == 32'h8c000060,"CPU released incomplete SG descriptor");
                for (integer offset = 0; offset < 96; offset = offset+1) begin
                    check(written[(cpu_retired_frames%3)*128+offset],"CPU released partial packet");
                    written[(cpu_retired_frames%3)*128+offset] = 0;
                end
                descriptor_memory[(cpu_retired_frames%3)*16+7] = 0;
                slot_frame[cpu_retired_frames%3] = slot_frame[cpu_retired_frames%3]+3;
                cpu_retired_frames = cpu_retired_frames+1;
            end
        end
    end
    initial begin
        for (integer offset = 0; offset < 896; offset = offset + 1) begin memory_bytes[offset] = 8'ha5; written[offset] = 0; end
        for (integer offset = 0; offset < 112; offset = offset + 1) descriptor_memory[offset] = 0;
        for (integer slot = 0; slot < 7; slot = slot+1) slot_frame[slot] = slot;
        check(FRAME_COUNT == 3 || FRAME_COUNT == 7,"fixture frame count supported");
        check(!RECYCLE_SLOTS || (EXTERNAL_SOURCE && SCATTER_GATHER && !REJECT_STALE_DESCRIPTOR),"SG recycle fixture requires owner external mode");
        for (integer packet_index = 0; packet_index < SLOT_COUNT; packet_index = packet_index + 1) begin
            descriptor_memory[packet_index*16] = 32'h02000000 + ((packet_index+1)%SLOT_COUNT)*64;
            descriptor_memory[packet_index*16+2] = 32'h01000000 + packet_index*128;
            descriptor_memory[packet_index*16+6] = 96;
        end
        for (integer packet_index = 0; packet_index < FRAME_COUNT; packet_index = packet_index + 1) begin
            file_handle = $fopen($sformatf("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r393-continuous-evidence/rounds/r387-native-continuous-capture/frame-%0d.bin",packet_index),"rb");
            check(file_handle != 0,"sealed packet open");
            read_count = $fread(reference_bytes,file_handle,packet_index*96,96);
            check(read_count == 96 && $fgetc(file_handle) == -1,"sealed packet exact length");
            $fclose(file_handle);
        end
        if (EXTERNAL_SOURCE) wait (resetn);
        else begin repeat (20) tick(); local_resetn = 1; end
        repeat (40) tick();
        control_read(10'h034,status_value); check(status_value[0],"DMA initial halted");
        if (SCATTER_GATHER) begin
            check(status_value[3],"SG engine present");
            control_write(10'h038,32'h02000000);
            control_write(10'h030,32'h00000001);
            if (RECYCLE_SLOTS) begin
                published_frames = SLOT_COUNT;
                control_write(10'h040,32'h02000000+(SLOT_COUNT-1)*64);
                stream_go = 1;
                for (frame_index = SLOT_COUNT; frame_index < FRAME_COUNT; frame_index = frame_index+1) begin
                    wait (cpu_retired_frames >= frame_index-SLOT_COUNT+1);
                    repeat (128) tick();
                    check(descriptor_memory[(frame_index%SLOT_COUNT)*16+7] == 0,"republication requires CPU-cleared Complete");
                    published_frames = frame_index+1;
                    control_write(10'h040,32'h02000000+(frame_index%SLOT_COUNT)*64);
                end
                wait (descriptor_writes == FRAME_COUNT && sg_drained);
                status_value = 0;
                while (!status_value[1]) begin
                    control_read(10'h034,status_value);
                    check((status_value & 32'h00000770) == 0,"SG recycled transfer error");
                end
                wait (cpu_retired_frames == FRAME_COUNT);
            end else for (frame_index = 3; frame_index <= FRAME_COUNT; frame_index = frame_index + 2) begin
                published_frames = frame_index;
                control_write(10'h040,32'h02000000 + (frame_index-1)*64);
                stream_go = 1;
                wait (descriptor_writes == frame_index);
                status_value = 0;
                while (!status_value[1]) begin
                    control_read(10'h034,status_value);
                    check((status_value & 32'h00000770) == 0,"SG transfer error");
                end
                repeat (128) begin
                    tick();
                    check(written_bytes == frame_index*96 && descriptor_writes == frame_index,
                        "tail must stop writes while CPU holds completed buffers");
                end
                for (integer descriptor = 0; descriptor < frame_index; descriptor = descriptor + 1)
                    check(descriptor_memory[descriptor*16+7] == 32'h8c000060,"CPU observes completed descriptor");
            end
            check(descriptor_writes == FRAME_COUNT && !sg_bvalid && !sg_write_active,"SG final status response settled");
        end else begin
            control_write(10'h030,32'h00000001);
            for (frame_index = 0; frame_index < FRAME_COUNT; frame_index = frame_index + 1) begin
                control_write(10'h048,32'h01000000 + frame_index*128);
                control_write(10'h058,96);
                stream_go = 1;
                wait (stream_words >= (frame_index+1)*24);
                status_value = 0;
                while (!status_value[1]) begin
                    control_read(10'h034,status_value);
                    check((status_value & 32'h00000770) == 0,"DMA transfer error");
                end
                control_read(10'h058,status_value); check(status_value == 96,"DMA actual received length");
            end
        end
        repeat (10) tick();
        check(external_drained && !external_fault && written_bytes == FRAME_COUNT*96 && address_head == address_tail && pending_responses == 0 &&
            address_count == last_count && last_count == response_count,"actual DMA final ledger");
        for (integer offset = 0; offset < FRAME_COUNT*128; offset = offset + 1)
            check(offset % 128 < 96 && offset < SLOT_COUNT*128 ? (RECYCLE_SLOTS ? !written[offset] : written[offset]) :
                (!written[offset] && memory_bytes[offset] == 8'ha5),"owned byte/guard preservation");
        if (REJECT_STALE_DESCRIPTOR) begin
            control_write(10'h040,32'h02000000);
            status_value = 0;
            while (!status_value[0] || !status_value[8]) control_read(10'h034,status_value);
            check((status_value & 32'h00000770) == 32'h00000100,"stale descriptor must produce only SGIntErr");
            repeat (128) begin
                tick();
                check(written_bytes == FRAME_COUNT*96 && descriptor_writes == FRAME_COUNT && external_drained && !external_fault,
                    "stale descriptor rejection must not rewrite completed buffers");
            end
            $display("TEST_PASS SG_STALE_DESCRIPTOR_REJECT SGINTERR HALTED NO_REWRITE bytes=672 descriptors=7");
        end
        check(external_committed_frames == FRAME_COUNT,"packet frame receipts incomplete");
        external_done = 1;
        $display("TEST_PASS PACKET_FRAME_RECEIPTS data=%0d sg=%0d committed=%0d",data_acknowledged_frames,sg_acknowledged_frames,external_committed_frames);
        $display("TEST_PASS ACTUAL_PACKET_DMA frames=%0d bytes=%0d words=%0d checks=%0d FINAL_B_STALL64 REAL_S2MM_REARM MEMORY_MODEL EXTERNAL_SOURCE=%0d",FRAME_COUNT,FRAME_COUNT*96,FRAME_COUNT*24,checks,EXTERNAL_SOURCE);
        if (SCATTER_GATHER) $display("TEST_PASS ACTUAL_SG_DMA descriptors=%0d grants=%0d bytes=%0d TAIL_PAUSE128 CREDIT_NO_OVERWRITE SG_STATUS_ACK DATA_B_STALL64 checks=%0d SG_STATUS_B_STALL64",FRAME_COUNT,RECYCLE_SLOTS ? FRAME_COUNT-SLOT_COUNT+1 : (FRAME_COUNT-1)/2,FRAME_COUNT*96,checks);
        if (RECYCLE_SLOTS) $display("TEST_PASS PACKET_SG_OWNER_RECYCLE frames=%0d slots=3 descriptor_slots=3 retired=%0d NONCYCLIC_TAIL CPU_CLEAR_COMPLETE BEFORE_REPUBLISH NO_HELD_OVERWRITE",FRAME_COUNT,cpu_retired_frames);
        if (!EXTERNAL_SOURCE) $finish;
    end
    if (!EXTERNAL_SOURCE) initial begin
        wait (stream_go);
        for (word_index = 0; word_index < FRAME_COUNT*24; word_index = word_index + 1) begin
            for (lane_index = 0; lane_index < 4; lane_index = lane_index + 1)
                replay_data[lane_index*8 +: 8] = reference_bytes[word_index*4 + lane_index];
            replay_valid = 1; replay_last = word_index % 24 == 23;
            do @(posedge clock); while (!stream_ready);
            @(negedge clock);
        end
        replay_valid = 0; replay_last = 0; replay_closed = 1;
    end
    initial begin
        wait (written_bytes == FRAME_COUNT*96);
        repeat (64) begin tick(); check(!drained && !fault && data_acknowledged_frames < FRAME_COUNT,"final real B must block drain and receipt"); end
        if (EXTERNAL_SOURCE) wait (allow_final_response);
        release_final_b = 1;
    end
    if (SCATTER_GATHER) initial begin
        wait (descriptor_writes == FRAME_COUNT);
        repeat (64) begin
            tick();
            check(drained && !fault && !external_drained && !external_fault && external_committed_frames < FRAME_COUNT,
                "final real SG status B must block combined drain after data drain");
        end
        release_final_sg_b = 1;
    end
    initial begin #2000000; $fatal(1,"ACTUAL_PACKET_DMA watchdog words=%0d bytes=%0d",stream_words,written_bytes); end
endmodule

module tb_vision_actual_sg_dma;
    tb_vision_actual_packet_dma #(.SCATTER_GATHER(1)) cases ();
endmodule

module tb_vision_sg_stale_descriptor;
    tb_vision_actual_packet_dma #(.SCATTER_GATHER(1), .REJECT_STALE_DESCRIPTOR(1)) cases ();
endmodule

module tb_vision_wide_packet_dma;
    tb_vision_actual_packet_dma #(.SCATTER_GATHER(1), .WIDE_STREAM(1)) cases ();
endmodule

module tb_vision_wide_stale_descriptor;
    tb_vision_actual_packet_dma #(.SCATTER_GATHER(1), .WIDE_STREAM(1), .REJECT_STALE_DESCRIPTOR(1)) cases ();
endmodule

module tb_vision_actual_rgb_vdma #(
    parameter integer EXTERNAL_SOURCE = 0,
    parameter integer FRAME_COUNT = 3,
    parameter integer RECYCLE_SLOTS = 0
)(
    input wire external_clock, external_resetn,
    input wire [23:0] external_data,
    input wire external_valid, external_user, external_last, external_closed, allow_final_response,
    input wire cpu_release_accepted,
    input wire [31:0] cpu_released_frames, granted_frames,
    output wire external_ready, external_drained, external_fault, external_armed,
    output wire [31:0] external_committed_frames,
    output reg external_done = 0
);
    reg local_clock = 0, local_resetn = 0;
    always #5 local_clock = ~local_clock;
    wire clock = EXTERNAL_SOURCE ? external_clock : local_clock;
    wire resetn = EXTERNAL_SOURCE ? external_resetn : local_resetn;
    reg [8:0] control_awaddr = 0, control_araddr = 0;
    reg [31:0] control_wdata = 0;
    reg control_awvalid = 0, control_wvalid = 0, control_arvalid = 0;
    wire control_awready, control_wready, control_bvalid, control_arready, control_rvalid;
    wire [1:0] control_bresp, control_rresp;
    wire [31:0] control_rdata, write_address;
    wire [7:0] write_length, write_strobes;
    wire [2:0] write_size;
    wire [1:0] write_burst;
    wire [63:0] write_data;
    wire address_valid, data_valid, data_last, response_ready, stream_ready, drained, fault;
    wire [31:0] acknowledged_frames;
    reg [23:0] replay_data = 0;
    reg replay_valid = 0, replay_user = 0, replay_last = 0, replay_closed = 0, stream_go = 0;
    wire [23:0] stream_data = EXTERNAL_SOURCE ? external_data : replay_data;
    wire stream_valid = EXTERNAL_SOURCE ? external_valid && stream_go : replay_valid;
    wire stream_user = EXTERNAL_SOURCE ? external_user : replay_user;
    wire stream_last = EXTERNAL_SOURCE ? external_last : replay_last;
    wire source_closed = EXTERNAL_SOURCE ? external_closed : replay_closed;
    assign external_ready = stream_ready && stream_go;
    assign external_armed = stream_go;
    assign external_drained = drained;
    assign external_fault = fault;
    assign external_committed_frames = acknowledged_frames;
    reg address_ready = 0, data_ready = 0, response_valid = 0, release_final_b = 0;
    reg [31:0] addresses [0:15];
    reg [7:0] lengths [0:15], memory_bytes [0:767];
    reg written [0:767];
    integer slot_frame [0:2];
    integer cpu_retired_frames = 0;
    integer cycles = 0, checks = 0, pixel_count = 0, written_bytes = 0;
    integer address_head = 0, address_tail = 0, beat_index = 0, pending_responses = 0;
    integer address_count = 0, last_count = 0, response_count = 0;
    integer memory_index, pixel_index;
    reg [7:0] expected_byte;
    reg [31:0] status_value, control_value;

    c6v_frame_dma_0 dma (
        .s_axi_lite_aclk(clock), .m_axi_s2mm_aclk(clock), .s_axis_s2mm_aclk(clock), .axi_resetn(resetn),
        .s_axi_lite_awaddr(control_awaddr), .s_axi_lite_awvalid(control_awvalid), .s_axi_lite_awready(control_awready),
        .s_axi_lite_wdata(control_wdata), .s_axi_lite_wvalid(control_wvalid), .s_axi_lite_wready(control_wready),
        .s_axi_lite_bresp(control_bresp), .s_axi_lite_bvalid(control_bvalid), .s_axi_lite_bready(1'b1),
        .s_axi_lite_araddr(control_araddr), .s_axi_lite_arvalid(control_arvalid), .s_axi_lite_arready(control_arready),
        .s_axi_lite_rdata(control_rdata), .s_axi_lite_rresp(control_rresp), .s_axi_lite_rvalid(control_rvalid), .s_axi_lite_rready(1'b1),
        .s2mm_frame_ptr_in(6'd0), .s2mm_frame_ptr_out(),
        .m_axi_s2mm_awaddr(write_address), .m_axi_s2mm_awlen(write_length), .m_axi_s2mm_awsize(write_size),
        .m_axi_s2mm_awburst(write_burst), .m_axi_s2mm_awprot(), .m_axi_s2mm_awcache(),
        .m_axi_s2mm_awvalid(address_valid), .m_axi_s2mm_awready(address_ready),
        .m_axi_s2mm_wdata(write_data), .m_axi_s2mm_wstrb(write_strobes), .m_axi_s2mm_wlast(data_last),
        .m_axi_s2mm_wvalid(data_valid), .m_axi_s2mm_wready(data_ready),
        .m_axi_s2mm_bresp(2'b00), .m_axi_s2mm_bvalid(response_valid), .m_axi_s2mm_bready(response_ready),
        .s_axis_s2mm_tdata(stream_data), .s_axis_s2mm_tkeep(3'b111), .s_axis_s2mm_tuser(stream_user),
        .s_axis_s2mm_tvalid(stream_valid), .s_axis_s2mm_tready(stream_ready), .s_axis_s2mm_tlast(stream_last), .s2mm_introut()
    );
    vision_axi_write_drain #(.DATA_BYTES(8), .EXPECTED_BYTES(192), .CONTINUOUS(1), .TRACK_FRAME_COMPLETIONS(1)) observer (
        .aclk(clock), .aresetn(resetn), .awvalid(address_valid), .awready(address_ready), .awlen(write_length),
        .wvalid(data_valid), .wready(data_ready), .wlast(data_last), .wstrb(write_strobes),
        .bvalid(response_valid), .bready(response_ready), .bresp(2'b00), .upstream_fault(1'b0),
        .source_closed(source_closed), .closed_byte_count(64'(FRAME_COUNT*192)), .writes_drained(drained), .integrity_fault(fault),
        .acknowledged_frames(acknowledged_frames)
    );
    task automatic check(input bit condition, input string message);
        begin
            checks = checks + 1;
            if (!condition) $fatal(1,"ACTUAL_RGB_VDMA_FAIL %s pixels=%0d bytes=%0d",message,pixel_count,written_bytes);
        end
    endtask
    task automatic tick;
        begin @(posedge clock); #0.001; @(negedge clock); end
    endtask
    task automatic control_write(input [8:0] offset, input [31:0] value);
        reg address_accepted, data_accepted;
        begin
            control_awaddr = offset; control_wdata = value; control_awvalid = 1; control_wvalid = 1;
            while (control_awvalid || control_wvalid) begin
                @(posedge clock);
                address_accepted = control_awready; data_accepted = control_wready;
                #0.001;
                if (address_accepted) control_awvalid = 0;
                if (data_accepted) control_wvalid = 0;
                @(negedge clock);
            end
            wait (control_bvalid); check(control_bresp == 0,"AXI Lite write response"); tick();
        end
    endtask
    task automatic control_read(input [8:0] offset, output [31:0] value);
        begin
            control_araddr = offset; control_arvalid = 1;
            do @(posedge clock); while (!control_arready);
            #0.001; control_arvalid = 0;
            wait (control_rvalid); value = control_rdata;
            check(control_rresp == 0,"AXI Lite read response"); tick();
        end
    endtask
    always @(negedge clock) begin
        cycles = cycles + 1;
        address_ready = resetn && address_tail-address_head < 16 && cycles % 5 != 0;
        data_ready = resetn && address_head < address_tail && cycles % 7 < 5;
        response_valid = resetn && pending_responses != 0 && (written_bytes < FRAME_COUNT*192 || release_final_b);
    end
    always @(posedge clock) begin
        if (resetn) begin
            check(!fault,"RGB write observer fault");
            if (stream_valid && stream_ready) begin
                check(stream_data === {16'd0,8'(pixel_count)} && stream_user == (pixel_count % 64 == 0) &&
                    stream_last == (pixel_count % 16 == 15),"RGB SOF/EOL stream contract");
                pixel_count = pixel_count + 1;
            end
            if (response_valid && response_ready) begin pending_responses = pending_responses-1; response_count = response_count+1; end
            if (address_valid && address_ready) begin
                check(write_size == 3 && write_burst == 1 && write_address[2:0] == 0,"RGB AXI burst shape");
                if (RECYCLE_SLOTS) check(write_address >= 32'h03000000 && write_address < 32'h03000300 &&
                    slot_frame[(write_address-32'h03000000)/256] < granted_frames,"RGB AW before owner frame credit");
                addresses[address_tail % 16] = write_address; lengths[address_tail % 16] = write_length;
                address_tail = address_tail+1; address_count = address_count+1;
            end
            if (data_valid && data_ready) begin
                check(data_last == (beat_index == lengths[address_head % 16]),"RGB WLAST matches AWLEN");
                for (integer lane = 0; lane < 8; lane = lane+1) begin
                    if (write_strobes[lane]) begin
                        memory_index = addresses[address_head % 16] + beat_index*8 + lane - 32'h03000000;
                        check(memory_index >= 0 && memory_index < 768 && memory_index % 64 < 48,"RGB write outside owned row");
                        check(!written[memory_index],"RGB duplicate/overwritten byte");
                        expected_byte = memory_index % 64 % 3 == 0 ?
                            8'(slot_frame[memory_index/256]*64 + ((memory_index%256)/64)*16 + (memory_index%64)/3) : 8'd0;
                        check(write_data[lane*8 +: 8] === expected_byte,"RGB memory byte differs");
                        memory_bytes[memory_index] = write_data[lane*8 +: 8]; written[memory_index] = 1;
                        written_bytes = written_bytes+1;
                    end
                end
                if (data_last) begin address_head = address_head+1; beat_index = 0; last_count = last_count+1; pending_responses = pending_responses+1; end
                else beat_index = beat_index+1;
            end
            if (RECYCLE_SLOTS && cpu_release_accepted) begin
                check(cpu_released_frames == cpu_retired_frames+1 && acknowledged_frames >= cpu_released_frames,
                    "RGB CPU retirement before real B or out of order");
                for (integer offset = 0; offset < 256; offset = offset+1) begin
                    if (offset % 64 < 48) begin
                        check(written[(cpu_retired_frames%3)*256+offset],"CPU released partially written RGB slot");
                        written[(cpu_retired_frames%3)*256+offset] = 0;
                    end
                end
                slot_frame[cpu_retired_frames%3] = slot_frame[cpu_retired_frames%3]+3;
                cpu_retired_frames = cpu_retired_frames+1;
            end
        end
    end
    initial begin
        for (integer offset = 0; offset < 768; offset = offset+1) begin memory_bytes[offset] = 8'ha5; written[offset] = 0; end
        for (integer slot = 0; slot < 3; slot = slot+1) slot_frame[slot] = slot;
        check(FRAME_COUNT == 3 || (FRAME_COUNT == 7 && RECYCLE_SLOTS && EXTERNAL_SOURCE),"RGB fixture finite or owner-recycled capacity");
        if (EXTERNAL_SOURCE) wait (resetn);
        else begin repeat (20) tick(); local_resetn = 1; end
        repeat (40) tick();
        control_read(9'h034,status_value); check(status_value[0],"VDMA initially halted");
        control_write(9'h030,RECYCLE_SLOTS ? 32'h00000003 : 32'h00030013);
        control_write(9'h0ac,32'h03000000); control_write(9'h0b0,32'h03000100); control_write(9'h0b4,32'h03000200);
        control_write(9'h0a8,64); control_write(9'h0a4,48); control_write(9'h0a0,4);
        stream_go = 1;
        wait (source_closed);
        wait (drained);
        control_read(9'h030,control_value);
        control_write(9'h030,control_value & 32'hfffffffe);
        status_value = 0;
        while (!status_value[0]) begin
            control_read(9'h034,status_value);
            check((status_value & 32'h000089f0) == 0,"VDMA status error");
        end
        if (RECYCLE_SLOTS) wait (cpu_retired_frames == FRAME_COUNT);
        repeat (10) tick();
        check(pixel_count == FRAME_COUNT*64 && written_bytes == FRAME_COUNT*192 && !fault && address_head == address_tail &&
            pending_responses == 0 && address_count == last_count && last_count == response_count,"VDMA exact final write ledger");
        for (integer offset = 0; offset < 768; offset = offset+1)
            check(offset % 64 < 48 ? (RECYCLE_SLOTS ? !written[offset] : written[offset]) :
                (!written[offset] && memory_bytes[offset] == 8'ha5),"RGB owned row and guard preservation");
        check(acknowledged_frames == FRAME_COUNT,"RGB frame receipts incomplete");
        external_done = 1;
        $display("TEST_PASS RGB_FRAME_RECEIPTS committed=%0d AFTER_REAL_B",acknowledged_frames);
        $display("TEST_PASS ACTUAL_RGB_VDMA frames=%0d pixels=%0d bytes=%0d checks=%0d SOF_EOL STRIDE_GUARD NO_OVERWRITE FINAL_B_STALL64 HALTED FINITE_ONLY EXTERNAL_SOURCE=%0d",FRAME_COUNT,FRAME_COUNT*64,FRAME_COUNT*192,checks,EXTERNAL_SOURCE);
        if (RECYCLE_SLOTS) $display("TEST_PASS ACTUAL_RGB_OWNER_RECYCLE frames=%0d slots=3 retired=%0d REAL_B BEFORE_CPU_RELEASE BEFORE_NEXT_AW NO_HELD_SLOT_OVERWRITE",FRAME_COUNT,cpu_retired_frames);
        $display("TEST_PASS RGB_VDMA_QUIET_DRAIN_STOP SOURCE_CLOSED DATA_B_SETTLED RS0 THEN_HALTED");
        if (!EXTERNAL_SOURCE) $finish;
    end
    if (!EXTERNAL_SOURCE) initial begin
        wait (stream_go);
        for (pixel_index = 0; pixel_index < 192; pixel_index = pixel_index+1) begin
            replay_data = {16'd0,8'(pixel_index)};
            replay_user = pixel_index % 64 == 0; replay_last = pixel_index % 16 == 15; replay_valid = 1;
            do @(posedge clock); while (!stream_ready);
            @(negedge clock);
        end
        replay_valid = 0; replay_user = 0; replay_last = 0; replay_closed = 1;
    end
    initial begin
        wait (written_bytes == FRAME_COUNT*192);
        repeat (64) begin tick(); check(!drained && !fault && acknowledged_frames < FRAME_COUNT,"final real RGB B must block drain and receipt"); end
        if (EXTERNAL_SOURCE) wait (allow_final_response);
        release_final_b = 1;
    end
    initial begin #2000000; $fatal(1,"ACTUAL_RGB_VDMA watchdog pixels=%0d bytes=%0d",pixel_count,written_bytes); end
endmodule

module tb_vision_three_frame_sg_dma;
    tb_vision_actual_packet_dma #(.SCATTER_GATHER(1), .FRAME_COUNT(3)) cases ();
endmodule

module tb_vision_write_frame_completion;
    reg aclk = 0, aresetn = 0;
    always #5 aclk = ~aclk;
    reg awvalid = 0, wvalid = 0, bvalid = 0, wlast = 0, source_closed = 0;
    reg [7:0] awlen = 0;
    reg [3:0] wstrb = 15;
    reg [1:0] bresp = 0;
    reg [63:0] closed_byte_count = 0;
    wire writes_drained, integrity_fault;
    wire [31:0] acknowledged_frames;
    wire legacy4_done, legacy8_done;
    integer checks = 0, scenarios = 0;
    axi_write_drain_cases #(.DATA_BYTES(4)) legacy4(legacy4_done);
    axi_write_drain_cases #(.DATA_BYTES(8)) legacy8(legacy8_done);
    vision_axi_write_drain #(.DATA_BYTES(4), .EXPECTED_BYTES(16), .CONTINUOUS(1),
        .TRACK_FRAME_COMPLETIONS(1), .RESPONSE_DEPTH(2)) dut (
        .aclk(aclk), .aresetn(aresetn), .awvalid(awvalid), .awready(1'b1), .awlen(awlen),
        .wvalid(wvalid), .wready(1'b1), .wlast(wlast), .wstrb(wstrb),
        .bvalid(bvalid), .bready(1'b1), .bresp(bresp), .upstream_fault(1'b0),
        .source_closed(source_closed), .closed_byte_count(closed_byte_count),
        .writes_drained(writes_drained), .integrity_fault(integrity_fault), .acknowledged_frames(acknowledged_frames)
    );
    task automatic tick;
        @(posedge aclk); #0.001; @(negedge aclk);
    endtask
    task automatic check(input bit condition, input string message);
        checks = checks+1;
        if (!condition) $fatal(1,"FRAME_COMPLETION_FAIL %s frames=%0d fault=%b",message,acknowledged_frames,integrity_fault);
    endtask
    task automatic reset_case;
        @(negedge aclk);
        aresetn = 0; awvalid = 0; wvalid = 0; bvalid = 0; wlast = 0; wstrb = 15; bresp = 0;
        source_closed = 0; closed_byte_count = 0;
        repeat (3) tick(); aresetn = 1; tick();
        check(acknowledged_frames == 0 && !integrity_fault && !writes_drained,"reset");
        scenarios = scenarios+1;
    endtask
    task automatic address(input [7:0] length);
        awlen = length; awvalid = 1; tick(); awvalid = 0;
    endtask
    task automatic data_words(input integer count);
        for (integer word_index = 0; word_index < count; word_index = word_index+1) begin
            wvalid = 1; wlast = word_index == count-1; tick();
        end
        wvalid = 0; wlast = 0;
    endtask
    task automatic response;
        bvalid = 1; tick(); bvalid = 0;
    endtask
    initial begin
        reset_case(); address(1); address(1); data_words(2); data_words(2);
        repeat (64) begin tick(); check(acknowledged_frames == 0 && !integrity_fault,"B stall committed frame"); end
        response(); check(acknowledged_frames == 0 && !integrity_fault,"partial frame response");
        response(); check(acknowledged_frames == 1 && !integrity_fault && !writes_drained,"first frame in open source");
        address(3); data_words(4);
        repeat (64) begin tick(); check(acknowledged_frames == 1 && !integrity_fault,"next frame B stall"); end
        response(); check(acknowledged_frames == 2 && !integrity_fault,"second frame response");
        source_closed = 1; closed_byte_count = 32; tick(); check(writes_drained && !integrity_fault,"final frame closure");

        reset_case(); data_words(4); awlen = 3; awvalid = 1; bvalid = 1; tick(); awvalid = 0; bvalid = 0;
        check(acknowledged_frames == 1 && !integrity_fault,"W before same-edge AW and B");

        reset_case(); address(3); data_words(4); bresp = 2; response(); tick();
        check(acknowledged_frames == 0 && integrity_fault && !writes_drained,"bad B committed frame");

        reset_case(); address(3); wstrb = 7; data_words(4); tick(); response();
        check(acknowledged_frames == 0 && integrity_fault && !writes_drained,"partial strobe frame receipt");

        reset_case(); address(0); address(0); address(0); tick();
        check(acknowledged_frames == 0 && integrity_fault && !writes_drained,"response capacity overflow");

        reset_case(); address(4); data_words(5); response(); tick();
        check(acknowledged_frames == 0 && integrity_fault && !writes_drained,"burst crossing frame boundary");

        reset_case(); force dut.frame_completion.completed_frames = 32'hffffffff;
        address(3); data_words(4); response(); tick();
        check(integrity_fault && !writes_drained,"frame receipt wrapped");
        release dut.frame_completion.completed_frames;
        check(scenarios == 7,"exact scenario count");
        wait (legacy4_done && legacy8_done);
        $display("TEST_PASS WRITE_FRAME_COMPLETION scenarios=7 checks=%0d FINAL_B64 AW_QUEUE W_BEFORE_AW BAD_B PARTIAL_STROBE CAPACITY CROSS_FRAME WRAP LEGACY44",checks);
        $finish;
    end
    initial begin #1000000; $fatal(1,"WRITE_FRAME_COMPLETION watchdog"); end
endmodule

module tb_vision_sg_dma_write_pair;
    tb_vision_dma_write_pair #(.CONTINUOUS(1), .TRACK_FRAME_COMPLETIONS(1), .SG_STATUS(1)) cases ();
endmodule