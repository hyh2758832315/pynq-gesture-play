`timescale 1ns/1ps
module tb_vision_continuous_drain;
    reg clock = 0;
    always #5 clock = ~clock;
    reg resetn = 0, source_valid = 0, rgb_valid = 0, packet_valid = 0;
    reg packet_ready = 1, packet_last = 0, source_closed = 0;
    reg [31:0] closed_frames = 0;
    wire drained, fault, legacy_done;
    integer checks = 0;
    capture_drain_unit legacy_test (.done(legacy_done));
    vision_capture_drain #(.INPUT_WIDTH(4), .INPUT_HEIGHT(4), .CONTINUOUS(1)) dut (
        .aclk(clock), .aresetn(resetn), .source_valid(source_valid), .source_ready(1'b1),
        .rgb_valid(rgb_valid), .rgb_ready(1'b1), .packet_valid(packet_valid), .packet_ready(packet_ready),
        .packet_last(packet_last), .packet_keep(4'hf), .capture_fault(1'b0),
        .source_closed(source_closed), .closed_frame_count(closed_frames),
        .pipeline_drained(drained), .integrity_fault(fault)
    );
    task automatic check(input bit condition, input string message);
        begin
            checks = checks + 1;
            if (!condition) $fatal(1, "CONTINUOUS_DRAIN_FAIL %s", message);
        end
    endtask
    task automatic reset_case;
        @(negedge clock);
        resetn = 0; source_valid = 0; rgb_valid = 0; packet_valid = 0;
        packet_last = 0; packet_ready = 1; source_closed = 0; closed_frames = 0;
        repeat (4) @(negedge clock);
        resetn = 1;
    endtask
    task automatic channel_words(input integer channel, count);
        integer position;
        for (position = 0; position < count; position = position + 1) begin
            @(negedge clock);
            source_valid = channel == 0; rgb_valid = channel == 1; packet_valid = channel == 2;
            packet_last = channel == 2 && position == 17;
            @(posedge clock);
        end
        @(negedge clock);
        source_valid = 0; rgb_valid = 0; packet_valid = 0; packet_last = 0;
    endtask
    task automatic frame;
        channel_words(0, 16); channel_words(1, 16); channel_words(2, 18);
        check(!drained && !fault, "running stream reached finite limit or falsely drained");
    endtask
    initial begin
        reset_case(); frame(); frame();
        channel_words(0,16); channel_words(1,16); channel_words(2,17);
        packet_valid = 1; packet_last = 1; packet_ready = 0;
        source_closed = 1; closed_frames = 3;
        repeat (20) @(negedge clock);
        check(!drained && !fault, "closed stream ignored stalled final word");
        packet_ready = 1;
        @(negedge clock); packet_valid = 0; packet_last = 0;
        repeat (3) @(negedge clock);
        check(drained && !fault, "dynamic three-frame closure did not drain");
        channel_words(0,1);
        check(!drained && fault, "accepted source beyond sealed budget not rejected");

        reset_case(); frame();
        source_closed = 1; closed_frames = 0;
        repeat (4) @(negedge clock);
        check(!drained && fault, "understated source budget not rejected");

        reset_case(); frame();
        source_closed = 1; closed_frames = 1;
        repeat (4) @(negedge clock);
        check(drained && !fault, "single-frame dynamic closure failed");
        closed_frames = 2;
        repeat (4) @(negedge clock);
        check(!drained && fault, "changed closure count not sticky");

        reset_case(); frame();
        source_closed = 1; closed_frames = 1;
        repeat (4) @(negedge clock);
        source_closed = 0;
        repeat (4) @(negedge clock);
        check(!drained && fault, "closure withdrawn without reset");

        reset_case(); source_closed = 1;
        repeat (4) @(negedge clock);
        check(drained && !fault, "empty cancelled admission could not drain");

        reset_case(); frame();
        source_closed = 1; closed_frames = 2;
        repeat (50) @(negedge clock);
        check(!drained && !fault, "missing source frame became complete");
        wait (legacy_done);
        $display("TEST_PASS CONTINUOUS_DRAIN scenarios=6 checks=%0d LEGACY10_PASS CLOSED_BUDGET_SYNTHETIC", checks);
        $finish;
    end
    initial begin
        #3000000;
        $fatal(1, "CONTINUOUS_DRAIN watchdog");
    end
endmodule

module capture_drain_unit(output reg done = 0);
    reg clock = 0;
    always #5 clock = !clock;
    reg resetn = 0, source_valid = 0, rgb_valid = 0, packet_valid = 0;
    reg packet_ready = 1, packet_last = 0, injected_fault = 0;
    reg [3:0] packet_keep = 15;
    wire drained, fault;
    integer scenarios = 0;
    vision_capture_drain #(.INPUT_WIDTH(4),.INPUT_HEIGHT(4)) dut (
        .aclk(clock), .aresetn(resetn), .source_valid(source_valid), .source_ready(1'b1),
        .rgb_valid(rgb_valid), .rgb_ready(1'b1), .packet_valid(packet_valid), .packet_ready(packet_ready),
        .packet_last(packet_last), .packet_keep(packet_keep), .capture_fault(injected_fault),
        .pipeline_drained(drained), .integrity_fault(fault)
    );
    task automatic reset_case;
        @(negedge clock); resetn = 0; source_valid = 0; rgb_valid = 0; packet_valid = 0;
        injected_fault = 0; packet_keep = 15; packet_last = 0; packet_ready = 1;
        repeat (4) @(negedge clock);
        resetn = 1;
        @(negedge clock);
        if (drained || fault) $fatal(1,"DRAIN reset failed");
    endtask
    task automatic send_words(input integer channel, count, mode);
        integer index;
        for (index = 0; index < count; index++) begin
            @(negedge clock);
            source_valid = channel == 0; rgb_valid = channel == 1; packet_valid = channel == 2;
            packet_last = (index == 17) || (mode == 2 && index == 0);
            packet_keep = mode == 1 && index == 0 ? 0 : 15;
            @(posedge clock);
        end
        @(negedge clock); source_valid = 0; rgb_valid = 0; packet_valid = 0;
        @(negedge clock);
    endtask
    initial begin
        reset_case(); repeat (30) @(negedge clock);
        if (drained) $fatal(1,"DRAIN idle mistaken for completion"); scenarios++;
        send_words(0,16,0); send_words(1,16,0); send_words(2,17,0);
        packet_valid = 1; packet_last = 1; packet_ready = 0;
        repeat (30) @(negedge clock);
        if (drained || fault) $fatal(1,"DRAIN stalled trailer escaped"); scenarios++;
        packet_ready = 1; @(negedge clock); packet_valid = 0;
        @(negedge clock);
        if (!drained || fault) $fatal(1,"DRAIN clean completion failed"); scenarios++;
        send_words(0,1,0);
        if (drained || !fault) $fatal(1,"DRAIN excess source not sticky"); scenarios++;
        reset_case(); send_words(0,7,0); repeat (30) @(negedge clock);
        if (drained || fault) $fatal(1,"DRAIN partial input escaped"); scenarios++;
        reset_case(); send_words(0,16,0); send_words(1,15,0); send_words(2,18,0);
        if (drained || fault) $fatal(1,"DRAIN missing RGB escaped");
        send_words(1,1,0);
        if (!drained) $fatal(1,"DRAIN delayed RGB failed"); scenarios++;
        reset_case(); send_words(0,16,0); send_words(1,16,0); send_words(2,18,1);
        if (drained || !fault) $fatal(1,"DRAIN bad keep escaped"); scenarios++;
        reset_case(); send_words(0,16,0); send_words(1,16,0); send_words(2,18,2);
        if (drained || !fault) $fatal(1,"DRAIN early TLAST escaped"); scenarios++;
        reset_case(); injected_fault = 1; @(negedge clock); injected_fault = 0;
        send_words(0,16,0); send_words(1,16,0); send_words(2,18,0);
        if (drained || !fault) $fatal(1,"DRAIN capture fault not sticky"); scenarios++;
        reset_case(); send_words(1,1,0);
        if (drained || !fault) $fatal(1,"DRAIN unsolicited RGB escaped"); scenarios++;
        $display("DRAIN_UNIT_PASS scenarios=%0d",scenarios);
        done = 1;
    end
endmodule

module capture_drain_integration #(
    parameter integer USE_AXI_WRITE_PROOF = 0,
    parameter integer USE_BD_WRAPPER = 0,
    parameter integer SEQUENCE_FRAME_IDS = 0,
    parameter integer CONTINUOUS = 0,
    parameter integer FRAME_COUNT = 2,
    parameter OUTPUT_ROOT = "E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r295-drain-output"
)(output reg done = 0);
    reg clock = 0, video_clock = 0;
    always #5 clock = !clock;
    always #7 video_clock = !video_clock;
    reg resetn = 0, source_valid = 0, source_user = 0, source_last = 0;
    reg request_seal = 0, source_quiescent = 0, dma_drained = 0;
    reg block_rgb_last = 1, block_packet_last = 1;
    reg allow_rgb_responses = 0, allow_packet_responses = 0;
    wire rgb_writes_done, packet_writes_done;
    wire [1:0] write_faults;
    wire dma_verified = dma_drained && (!USE_AXI_WRITE_PROOF || (rgb_writes_done && packet_writes_done));
    wire capture_resetn, source_ready, frame_fault, pipeline_drained, sealed, barrier;
    wire [2:0] faults;
    wire [23:0] rgb_data;
    wire rgb_valid, rgb_user, rgb_last, packet_valid, packet_last;
    wire [31:0] packet_data;
    wire [3:0] packet_keep;
    integer cycles = 0, phase = 0, frame_id = 1, rgb_count = 0, word_count = 0;
    integer pixel, file_handle = 0, trailer, packet_frame, packet_word;
    reg [31:0] expected, crc = 32'hffffffff;
    wire rgb_ready = !(block_rgb_last && rgb_count == FRAME_COUNT*16-1) && cycles % 7 < 4;
    wire packet_ready = !(block_packet_last && word_count == FRAME_COUNT*18-1) && cycles % 11 < 7;
    wire [143:0] context_word = {32'(phase+3),32'd2,32'(SEQUENCE_FRAME_IDS ? 1 : frame_id),48'hff2dff231600};
    generate if (USE_AXI_WRITE_PROOF) begin : write_proof
        capture_write_response_model #(.EXPECTED_BYTES(FRAME_COUNT*48),.STROBES(4'h7)) rgb_sink (
            .clock(clock),.resetn(capture_resetn),.accepted(rgb_valid && rgb_ready),
            .allow_response(allow_rgb_responses),.upstream_fault(frame_fault),
            .writes_done(rgb_writes_done),.fault(write_faults[0])
        );
        capture_write_response_model #(.EXPECTED_BYTES(FRAME_COUNT*72),.STROBES(4'hf)) packet_sink (
            .clock(clock),.resetn(capture_resetn),.accepted(packet_valid && packet_ready),
            .allow_response(allow_packet_responses),.upstream_fault(frame_fault),
            .writes_done(packet_writes_done),.fault(write_faults[1])
        );
    end else begin : original_dma_model
        assign rgb_writes_done = 1'b1;
        assign packet_writes_done = 1'b1;
        assign write_faults = 2'b00;
    end endgenerate
    vision_epoch_fence fence (
        .vid_io_in_clk(video_clock), .aclk(clock), .common_aresetn(resetn),
        .video_overflow(1'b0), .aclk_underflow(1'b0), .capture_fault(frame_fault || (|write_faults)),
        .source_quiescent(source_quiescent), .request_seal(request_seal),
        .pipeline_drained(pipeline_drained), .dma_drained(dma_verified),
        .monitor_ready(capture_resetn), .barrier_complete(barrier), .epoch_sealed(sealed), .fault_causes(faults)
    );
    generate if (USE_BD_WRAPPER) begin : bd_wrapper
        wire [2:0] rgb_keep;
        axis_rgb_capture_bd #(.INPUT_WIDTH(4),.INPUT_HEIGHT(4),.EPOCH_FRAMES(2)) dut (
            .aclk(clock), .aresetn(capture_resetn), .s_axis_tdata(24'h0000ff), .s_axis_tkeep(3'b111),
            .s_axis_tvalid(source_valid), .s_axis_tready(source_ready), .s_axis_tuser(source_user), .s_axis_tlast(source_last),
            .cfg_frame_context(context_word), .source_fault(|faults[1:0]), .abort_requested(1'b0),
            .source_closed(source_quiescent), .closed_frame_count(32'(FRAME_COUNT)),
            .frame_credit_ready(1'b1),
            .m_rgb_tdata(rgb_data), .m_rgb_tkeep(rgb_keep), .m_rgb_tvalid(rgb_valid), .m_rgb_tready(rgb_ready),
            .m_rgb_tuser(rgb_user), .m_rgb_tlast(rgb_last), .m_packet_tdata(packet_data), .m_packet_tkeep(packet_keep),
            .m_packet_tvalid(packet_valid), .m_packet_tready(packet_ready), .m_packet_tlast(packet_last),
            .frame_fault(frame_fault), .pipeline_drained(pipeline_drained)
        );
        always @(posedge clock) if (capture_resetn && rgb_valid && rgb_keep !== 3'b111)
            $fatal(1,"BD_CAPTURE RGB keep changed");
    end else begin : original_capture
    axis_rgb_capture_tracked #(.INPUT_WIDTH(4),.INPUT_HEIGHT(4),.EPOCH_FRAMES(CONTINUOUS ? 1 : FRAME_COUNT),
        .SEQUENCE_FRAME_IDS(SEQUENCE_FRAME_IDS),.CONTINUOUS(CONTINUOUS)) dut (
        .aclk(clock), .aresetn(capture_resetn), .s_axis_tdata(24'h0000ff), .s_axis_tvalid(source_valid),
        .s_axis_tready(source_ready), .s_axis_tuser(source_user), .s_axis_tlast(source_last),
        .cfg_frame_context(context_word), .source_fault(|faults[1:0]),
        .source_closed(source_quiescent), .closed_frame_count(32'(FRAME_COUNT)),
        .m_rgb_tdata(rgb_data), .m_rgb_tvalid(rgb_valid), .m_rgb_tready(rgb_ready), .m_rgb_tuser(rgb_user), .m_rgb_tlast(rgb_last),
        .m_packet_tdata(packet_data), .m_packet_tkeep(packet_keep), .m_packet_tvalid(packet_valid),
        .m_packet_tready(packet_ready), .m_packet_tlast(packet_last), .frame_fault(frame_fault), .pipeline_drained(pipeline_drained)
    );
    end endgenerate
    function automatic [31:0] crc_word(input [31:0] previous_crc, value);
        reg [31:0] work;
        integer bit_index;
        begin
            work = previous_crc ^ value;
            for (bit_index = 0; bit_index < 32; bit_index++) work = (work >> 1) ^ (work[0] ? 32'hedb88320 : 0);
            crc_word = work;
        end
    endfunction
    always @(negedge clock) cycles = cycles + 1;
    always @(posedge clock) begin
        if (!capture_resetn) begin rgb_count = 0; word_count = 0; crc = 32'hffffffff; end
        else begin
            if (rgb_valid && rgb_ready) begin
                if (rgb_data !== 24'h0000ff || rgb_user !== (rgb_count % 16 == 0) || rgb_last !== (rgb_count % 4 == 3))
                    $fatal(1,"DRAIN RGB mismatch");
                rgb_count++;
            end
            if (packet_valid && packet_ready) begin
                packet_frame = word_count / 18; packet_word = word_count % 18;
                if (packet_word == 0) begin
                    file_handle = $fopen($sformatf("%s/phase-%0d-frame-%0d.bin",OUTPUT_ROOT,phase,packet_frame),"wb");
                    if (!file_handle) $fatal(1,"DRAIN trace open failed");
                end
                if (packet_word < 2) expected = 32'hffffffff;
                else begin
                    trailer = packet_word - 2;
                    case (trailer)
                        0: expected = 32'h31534d44;
                        1: expected = 32'h00100001;
                        2: expected = packet_frame + 1;
                        3: expected = 2;
                        4: expected = phase + 3;
                        5: expected = 32'h00020002;
                        6: expected = 4;
                        7: expected = 8;
                        9: expected = 32'hff231600;
                        10: expected = 32'hff2d;
                        11: expected = 32'h00010802;
                        15: expected = ~crc;
                        default: expected = 0;
                    endcase
                end
                if (packet_data !== expected || packet_keep !== 15 || packet_last !== (packet_word == 17))
                    $fatal(1,"DRAIN packet mismatch phase=%0d word=%0d got=%h expected=%h",phase,word_count,packet_data,expected);
                $fwrite(file_handle,"%c%c%c%c",packet_data[7:0],packet_data[15:8],packet_data[23:16],packet_data[31:24]);
                if (packet_last) begin $fclose(file_handle); file_handle = 0; crc = 32'hffffffff; end
                else crc = crc_word(crc,packet_data);
                word_count++;
            end
        end
    end
    task automatic reset_case;
        @(negedge clock); resetn = 0; source_valid = 0;
        source_quiescent = 0; request_seal = 0; dma_drained = 0;
        allow_rgb_responses = 0; allow_packet_responses = 0;
        block_rgb_last = 1; block_packet_last = 1; frame_id = 1;
        repeat (8) @(negedge clock);
        resetn = 1; wait (capture_resetn === 1); repeat (4) @(negedge clock);
    endtask
    task automatic send_pixels(input integer count);
        for (pixel = 0; pixel < count; pixel++) begin
            @(negedge clock); source_valid = 1; source_user = pixel == 0; source_last = pixel % 4 == 3;
            do @(posedge clock); while (!source_ready);
        end
        @(negedge clock); source_valid = 0;
    endtask
    initial begin
        reset_case(); send_pixels(3);
        repeat (60) @(negedge clock);
        if (pipeline_drained || sealed || frame_fault) $fatal(1,"DRAIN partial frame became complete");
        for (phase = 0; phase < 2; phase++) begin
            reset_case();
            for (frame_id = 1; frame_id <= FRAME_COUNT; frame_id++) send_pixels(16);
            @(negedge video_clock); source_quiescent = 1;
            @(negedge clock); request_seal = 1;
            @(negedge clock); request_seal = 0;
            wait (packet_valid && packet_last && word_count == FRAME_COUNT*18-1);
            repeat (20) @(negedge clock);
            if (pipeline_drained || sealed || frame_fault) $fatal(1,"DRAIN last packet stall escaped");
            block_packet_last = 0;
            wait (word_count == FRAME_COUNT*18); repeat (10) @(negedge clock);
            if (pipeline_drained || sealed || frame_fault || rgb_count != FRAME_COUNT*16-1) $fatal(1,"DRAIN RGB last stall escaped");
            block_rgb_last = 0;
            wait (rgb_count == FRAME_COUNT*16); repeat (20) @(negedge clock);
            if (!pipeline_drained || sealed || !barrier || frame_fault) $fatal(1,"DRAIN real pipeline completion failed");
            dma_drained = 1;
            if (USE_AXI_WRITE_PROOF) begin
                repeat (64) @(negedge clock);
                if (sealed || rgb_writes_done || packet_writes_done || write_faults) $fatal(1,"WRITE_FENCE pending responses escaped");
                allow_rgb_responses = 1;
                wait (rgb_writes_done); repeat (10) @(negedge clock);
                if (sealed || packet_writes_done || !pipeline_drained || write_faults) $fatal(1,"WRITE_FENCE packet responses escaped");
                allow_packet_responses = 1;
                wait (packet_writes_done);
            end
            repeat (10) @(negedge clock);
            if (!sealed || faults) $fatal(1,"DRAIN fence failed after independent DMA confirmation");
            if (USE_AXI_WRITE_PROOF) $display("WRITE_CAPTURE_BARRIER_PASS phase=%0d rgb_bytes=96 packet_bytes=144 TWO_RESPONSE_GATES_OWNER_MODEL",phase);
            @(negedge clock); source_valid = 1; source_user = 1; source_last = 0;
            do @(posedge clock); while (!source_ready);
            @(negedge clock); source_valid = 0;
            repeat (10) @(negedge clock);
            if (pipeline_drained || sealed || !frame_fault || faults != 4) $fatal(1,"DRAIN excess accepted work escaped");
            $display("DRAIN_CAPTURE_PASS phase=%0d frames=%0d rgb=%0d packet_words=%0d REAL_PIPELINE_LAST_STALL_DMA_GATE_RESET",phase,FRAME_COUNT,FRAME_COUNT*16,FRAME_COUNT*18);
        end
        done = 1;
    end
endmodule

module tb_vision_capture_drain;
    wire unit_done, capture_done;
    capture_drain_unit unit_case(unit_done);
    capture_drain_integration capture_case(capture_done);
    initial begin
        wait (unit_done && capture_done);
        $display("TEST_PASS VISION_CAPTURE_DRAIN unit_scenarios=10 capture_epochs=2 packets=4 PARTIAL_RESET_TWO_OUTPUT_STALL_REAL_FENCE");
        $finish;
    end
    initial begin #2000000; $fatal(1,"DRAIN watchdog"); end
endmodule

module tb_vision_frame_identity;
    wire unit_done, legacy_done, sequence_done;
    capture_drain_unit unit_test (.done(unit_done));
    capture_drain_integration #(
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r383-frame-identity-capture/legacy")
    ) legacy_test (.done(legacy_done));
    capture_drain_integration #(
        .SEQUENCE_FRAME_IDS(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r383-frame-identity-capture/sequence")
    ) sequence_test (.done(sequence_done));
    initial begin
        wait (unit_done && legacy_done && sequence_done);
        $display("TEST_PASS FRAME_IDENTITY_CAPTURE LEGACY_AND_SEQUENCE_PHASES2 EACH_FRAMES2 DMS1_CRC_RGB_STALL_DMA_ORACLE");
        $finish;
    end
    initial begin
        #3000000;
        $fatal(1, "FRAME_IDENTITY_CAPTURE watchdog");
    end
endmodule

module tb_vision_continuous_capture;
    wire legacy_done, continuous_done;
    capture_drain_integration #(
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r385-continuous-capture/legacy")
    ) legacy_test (.done(legacy_done));
    capture_drain_integration #(
        .SEQUENCE_FRAME_IDS(1), .CONTINUOUS(1), .FRAME_COUNT(7),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r385-continuous-capture/continuous")
    ) continuous_test (.done(continuous_done));
    initial begin
        wait (legacy_done && continuous_done);
        $display("TEST_PASS CONTINUOUS_CAPTURE PHASES2 FRAMES7 EPOCH_PARAMETER1 LEGACY_PHASES2_FRAMES2 SOURCE_DMA_ORACLES");
        $finish;
    end
    initial begin
        #3000000;
        $fatal(1, "CONTINUOUS_CAPTURE watchdog");
    end
endmodule