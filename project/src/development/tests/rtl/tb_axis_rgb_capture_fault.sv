`timescale 1ns/1ps
module tb_axis_rgb_capture_fault #(
    parameter integer USE_CDC = 0,
    parameter OUTPUT_ROOT = "E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r273-source-fault-output"
);
    reg clock = 0;
    always #5 clock = !clock;
    reg video_clock = 0;
    always #2 video_clock = !video_clock;
    reg resetn = 0, source_valid = 0, source_user = 0, source_last = 0, injected_fault = 0;
    reg video_overflow = 0;
    wire source_fault, capture_resetn;
    wire [1:0] fault_status;
    wire source_ready, frame_fault;
    wire [23:0] rgb_data;
    wire rgb_valid, rgb_user, rgb_last;
    wire [31:0] packet_data;
    wire [3:0] packet_keep;
    wire packet_valid, packet_last;
    reg output_enable = 0;
    integer cycles = 0, phase = 0, pixel_index, output_index = 0, finished = 0, rgb_count = 0;
    integer file_handle = 0, payload_words, trailer_index;
    reg [31:0] expected, check_crc = 32'hffffffff;
    reg stalled = 0;
    reg [36:0] held;
    wire output_ready = output_enable && cycles % 11 < 7;
    localparam [143:0] CONTEXT = {32'd3, 32'd2, 32'd1, 48'hff2dff231600};
    localparam integer FAULT_PIXELS = USE_CDC ? 2 : 1;

    generate
        if (USE_CDC) begin : cdc
            vision_source_fault_cdc monitor (
                .vid_io_in_clk(video_clock), .aclk(clock), .common_aresetn(resetn),
                .video_overflow(video_overflow), .aclk_underflow(1'b0),
                .capture_aresetn(capture_resetn), .source_fault(source_fault), .fault_status(fault_status)
            );
        end else begin : direct
            assign source_fault = injected_fault;
            assign capture_resetn = resetn;
            assign fault_status = 0;
        end
    endgenerate

    function automatic [31:0] crc_word(input [31:0] previous_crc, value);
        reg [31:0] work;
        integer bit_index;
        begin
            work = previous_crc ^ value;
            for (bit_index = 0; bit_index < 32; bit_index = bit_index + 1)
                work = (work >> 1) ^ (work[0] ? 32'hedb88320 : 32'd0);
            crc_word = work;
        end
    endfunction
    axis_rgb_dual_mask_capture #(.INPUT_WIDTH(4), .INPUT_HEIGHT(4)) dut (
        .aclk(clock), .aresetn(capture_resetn), .s_axis_tdata(24'h0000ff), .s_axis_tvalid(source_valid),
        .s_axis_tready(source_ready), .s_axis_tuser(source_user), .s_axis_tlast(source_last),
        .cfg_frame_context(CONTEXT), .source_fault(source_fault), .m_rgb_tdata(rgb_data),
        .m_rgb_tvalid(rgb_valid), .m_rgb_tready(1'b1), .m_rgb_tuser(rgb_user), .m_rgb_tlast(rgb_last),
        .m_packet_tdata(packet_data), .m_packet_tkeep(packet_keep), .m_packet_tvalid(packet_valid),
        .m_packet_tready(output_ready), .m_packet_tlast(packet_last), .frame_fault(frame_fault)
    );
    always @(negedge clock) cycles = cycles + 1;
    always @(posedge clock) begin
        if (!capture_resetn) stalled = 0;
        else begin
            if (stalled && (!packet_valid || {packet_data, packet_keep, packet_last} !== held))
                $fatal(1, "SOURCE_FAULT stalled packet changed");
            stalled = packet_valid && !output_ready;
            held = {packet_data, packet_keep, packet_last};
            if (rgb_valid) begin
                if (rgb_data !== 24'h0000ff || rgb_user !== (rgb_count == 0) || rgb_last !== (rgb_count % 4 == 3))
                    $fatal(1, "SOURCE_FAULT RGB mismatch");
                rgb_count = rgb_count + 1;
            end
            if (packet_valid && output_ready) begin
                if (!file_handle) $fatal(1, "SOURCE_FAULT unexpected packet");
                payload_words = phase == 0 ? 1 : 2;
                if (output_index < payload_words) expected = phase == 0 && FAULT_PIXELS == 1 ? 32'h0000ffff : 32'hffffffff;
                else begin
                    trailer_index = output_index - payload_words;
                    case (trailer_index)
                        0: expected = 32'h31534d44;
                        1: expected = 32'h00100001;
                        2: expected = 1;
                        3: expected = 2;
                        4: expected = 3;
                        5: expected = 32'h00020002;
                        6: expected = phase == 0 ? FAULT_PIXELS : 4;
                        7: expected = phase == 0 ? 4 : 8;
                        8: expected = phase == 0 ? 8 : 0;
                        9: expected = 32'hff231600;
                        10: expected = 32'h0000ff2d;
                        11: expected = 32'h00010802;
                        15: expected = ~check_crc;
                        default: expected = 0;
                    endcase
                end
                if (packet_data !== expected || packet_keep !== 4'hf || packet_last !== (output_index == payload_words+15))
                    $fatal(1, "SOURCE_FAULT packet mismatch phase=%0d word=%0d got=%h expected=%h", phase, output_index, packet_data, expected);
                $fwrite(file_handle, "%c%c%c%c", packet_data[7:0], packet_data[15:8], packet_data[23:16], packet_data[31:24]);
                check_crc = crc_word(check_crc, packet_data);
                output_index = output_index + 1;
                if (packet_last) begin
                    $fclose(file_handle);
                    file_handle = 0;
                    finished = finished + 1;
                end
            end
        end
    end
    task automatic send_frame;
        begin
            for (pixel_index = 0; pixel_index < 16; pixel_index = pixel_index + 1) begin
                @(negedge clock);
                source_valid = 1;
                source_user = pixel_index == 0;
                source_last = pixel_index % 4 == 3;
                do @(posedge clock); while (!source_ready);
            end
            @(negedge clock);
            source_valid = 0;
        end
    endtask
    initial begin
        for (phase = 0; phase < 2; phase = phase + 1) begin
            resetn = 0;
            source_valid = 0;
            injected_fault = 0;
            video_overflow = 0;
            output_enable = 0;
            output_index = 0;
            rgb_count = 0;
            check_crc = 32'hffffffff;
            repeat (8) @(negedge clock);
            resetn = 1;
            wait (capture_resetn === 1);
            @(negedge clock);
            if (frame_fault) $fatal(1, "SOURCE_FAULT reset failed");
            file_handle = $fopen($sformatf("%s/phase-%0d.bin", OUTPUT_ROOT, phase), "wb");
            if (!file_handle) $fatal(1, "SOURCE_FAULT output unavailable");
            send_frame();
            if (phase == 0) begin
                wait (dut.packet.pixel_count == 1);
                if (USE_CDC) begin
                    @(negedge video_clock); video_overflow = 1;
                    @(negedge video_clock); video_overflow = 0;
                end else begin
                    @(negedge clock); injected_fault = 1;
                    @(negedge clock); injected_fault = 0;
                end
                repeat (8) @(negedge clock);
                if (!frame_fault || source_ready) $fatal(1, "SOURCE_FAULT pulse not sticky");
                if (USE_CDC && fault_status !== 2'b01) $fatal(1, "SOURCE_FAULT CDC status differs");
                source_valid = 1;
                source_user = 1;
            end
            output_enable = 1;
            wait (finished == phase+1);
            repeat (8) @(negedge clock);
            if (packet_valid || rgb_count != 16 || frame_fault !== (phase == 0) || (phase == 0 && source_ready))
                $fatal(1, "SOURCE_FAULT drain/stop mismatch");
        end
        if (USE_CDC) $display("TEST_PASS RGB_CAPTURE_CDC_SOURCE_FAULT VIDEO_PULSE_CRC_RGB_DRAIN_COMMON_RESET_RECOVERY packets=2");
        else $display("TEST_PASS RGB_CAPTURE_SOURCE_FAULT PULSE_STICKY_ABORT_CRC_RGB_DRAIN_RESET_RECOVERY packets=2");
        $finish;
    end
    initial begin
        #2000000;
        $fatal(1, "SOURCE_FAULT watchdog");
    end
endmodule

module tb_axis_rgb_capture_fault_cdc;
    tb_axis_rgb_capture_fault #(
        .USE_CDC(1),
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r279-cdc-capture-output")
    ) test_case ();
endmodule

module tb_axis_rgb_capture_fault_direct;
    tb_axis_rgb_capture_fault #(
        .OUTPUT_ROOT("E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r280-direct-capture-output")
    ) test_case ();
endmodule