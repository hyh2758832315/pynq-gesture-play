`timescale 1ns/1ps
module dual_mask_packet_case #(
    parameter integer WIDTH = 2,
    parameter integer HEIGHT = 2
)(input wire clock, output reg done = 0);
    localparam integer PIXELS = WIDTH * HEIGHT;
    localparam string OUT = "E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r270-packet-reset-output";
    reg resetn = 0;
    reg [15:0] source_data = 0;
    reg source_valid = 0, source_user = 0, source_last = 0, upstream_fault = 0;
    reg [143:0] source_context = 0;
    wire source_ready, output_valid, output_last, frame_fault;
    wire [31:0] output_data;
    wire [3:0] output_keep;
    reg output_ready = 0;
    reg force_stall = 0;
    reg blocked = 0;
    reg [36:0] held;
    integer cycles = 0, scenario = 0, output_index = 0, finished = 0;
    integer pixel_index, file_handle = 0, active_pixels, active_status, frame_number;
    reg [31:0] expected_word, check_crc = 32'hffffffff;
    integer trailer_index, reset_case;

    function automatic [15:0] pair_value(input integer index_value, frame_value);
        reg [7:0] filtered;
        begin
            filtered = index_value * 17 + frame_value * 31;
            pair_value = {filtered, index_value % 2 ? 8'hff : 8'h00};
        end
    endfunction
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
    axis_dual_mask_packet #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) dut (
        .aclk(clock), .aresetn(resetn), .s_axis_tdata(source_data), .s_axis_tvalid(source_valid),
        .s_axis_tready(source_ready), .s_axis_tuser(source_user), .s_axis_tlast(source_last),
        .s_frame_context(source_context), .upstream_fault(upstream_fault), .m_axis_tdata(output_data),
        .m_axis_tkeep(output_keep), .m_axis_tvalid(output_valid), .m_axis_tready(output_ready),
        .m_axis_tlast(output_last), .frame_fault(frame_fault)
    );
    always @(negedge clock) begin
        cycles = cycles + 1;
        output_ready = !force_stall && cycles % 13 < 9 && cycles % 503 >= 80;
    end
    always @(posedge clock) begin
        if (!resetn) blocked = 0;
        else begin
            if (blocked && (!output_valid || {output_data, output_keep, output_last} !== held))
                $fatal(1, "DMS1 stalled output changed");
            blocked = output_valid && !output_ready;
            held = {output_data, output_keep, output_last};
            if (output_valid && output_ready) begin
                if (!file_handle) $fatal(1, "DMS1 unexpected packet");
                if (output_index < (active_pixels+1)/2) begin
                    expected_word[15:0] = scenario == 2 ? 16'h3301 : pair_value(output_index*2, frame_number);
                    expected_word[31:16] = output_index*2+1 < active_pixels ? pair_value(output_index*2+1, frame_number) : 16'd0;
                end else begin
                    trailer_index = output_index - (active_pixels+1)/2;
                    case (trailer_index)
                        0: expected_word = 32'h31534d44;
                        1: expected_word = 32'h00100001;
                        2: expected_word = 32'h10203000 + frame_number;
                        3: expected_word = 32'h40506000 + frame_number;
                        4: expected_word = 32'h70809000 + frame_number;
                        5: expected_word = (HEIGHT << 16) | WIDTH;
                        6: expected_word = active_pixels;
                        7: expected_word = ((active_pixels+1)/2)*4;
                        8: expected_word = active_status;
                        9: expected_word = 32'hba987654;
                        10: expected_word = 32'h0000fedc;
                        11: expected_word = 32'h00010802;
                        15: expected_word = ~check_crc;
                        default: expected_word = 0;
                    endcase
                end
                if (output_data !== expected_word || output_keep !== 4'hf ||
                    output_last !== (output_index == (active_pixels+1)/2+15))
                    $fatal(1, "DMS1 mismatch size=%0dx%0d scenario=%0d word=%0d got=%h expected=%h",
                        WIDTH, HEIGHT, scenario, output_index, output_data, expected_word);
                $fwrite(file_handle, "%c%c%c%c", output_data[7:0], output_data[15:8], output_data[23:16], output_data[31:24]);
                check_crc = crc_word(check_crc, output_data);
                output_index = output_index + 1;
                if (output_last) begin
                    $fclose(file_handle);
                    file_handle = 0;
                    finished = finished + 1;
                end
            end
        end
    end
    task automatic send_pixel(input integer index_value);
        begin
            @(negedge clock);
            source_data = scenario == 2 ? 16'h3301 : pair_value(index_value, frame_number);
            source_user = index_value == 0 || (scenario == 3 && index_value == 1);
            source_last = index_value == PIXELS-1 && scenario != 5;
            if (scenario == 4) source_last = 1;
            source_context = {32'h70809000 + frame_number, 32'h40506000 + frame_number,
                32'h10203000 + frame_number, 48'hfedcba987654};
            if (scenario == 6 && index_value == 1) source_context = source_context ^ 144'd1;
            source_valid = 1;
            do @(posedge clock); while (!source_ready);
            @(negedge clock);
            source_valid = 0;
        end
    endtask
    initial begin
        if (WIDTH == 2) begin
            force_stall = 1;
            frame_number = 0;
            for (reset_case = 0; reset_case < 2; reset_case = reset_case + 1) begin
                resetn = 0;
                repeat (4) @(negedge clock);
                resetn = 1;
                send_pixel(0);
                if (reset_case == 1) send_pixel(1);
                repeat (8) @(negedge clock);
                if (output_valid !== (reset_case == 1)) $fatal(1, "DMS1 partial reset fixture");
                resetn = 0;
                repeat (4) @(negedge clock);
                if (output_valid || frame_fault) $fatal(1, "DMS1 partial reset failed");
            end
            force_stall = 0;
            $display("DMS1_PARTIAL_RESET_PASS half_pair=1 stalled_word=1");
        end
        for (scenario = 0; scenario < (WIDTH == 2 ? 8 : 2); scenario = scenario + 1) begin
            @(negedge clock);
            if (scenario != 1) begin
                resetn = 0;
                upstream_fault = 0;
                repeat (4) @(negedge clock);
                resetn = 1;
            end
            frame_number = scenario < 2 ? scenario : 0;
            active_pixels = PIXELS;
            active_status = 0;
            case (scenario)
                2: begin active_pixels = 1; active_status = 2; end
                3: begin active_pixels = 2; active_status = 1; end
                4: begin active_pixels = 1; active_status = 1; end
                5: begin active_pixels = PIXELS; active_status = 1; end
                6: begin active_pixels = 2; active_status = 4; end
                7: begin active_pixels = 1; active_status = 8; end
                default: begin end
            endcase
            output_index = 0;
            check_crc = 32'hffffffff;
            file_handle = $fopen($sformatf("%s/w%03d-h%03d-case-%02d.bin", OUT, WIDTH, HEIGHT, scenario), "wb");
            if (!file_handle) $fatal(1, "DMS1 output file unavailable");
            for (pixel_index = 0; pixel_index < active_pixels; pixel_index = pixel_index + 1) send_pixel(pixel_index);
            if (scenario == 7) upstream_fault = 1;
            wait (finished == scenario+1);
            repeat (8) @(negedge clock);
            if (output_valid || frame_fault !== (scenario >= 2) || (scenario >= 2 && source_ready))
                $fatal(1, "DMS1 fault/drain mismatch");
        end
        $display("DMS1_CASE_PASS size=%0dx%0d packets=%0d normal_pairs=%0d", WIDTH, HEIGHT, finished, PIXELS*2);
        done = 1;
    end
endmodule

module tb_axis_dual_mask_packet;
    reg clock = 0;
    always #5 clock = !clock;
    wire even_done, odd_done, full_done;
    dual_mask_packet_case #(.WIDTH(2), .HEIGHT(2)) even_case (.clock(clock), .done(even_done));
    dual_mask_packet_case #(.WIDTH(3), .HEIGHT(3)) odd_case (.clock(clock), .done(odd_done));
    dual_mask_packet_case #(.WIDTH(640), .HEIGHT(360)) full_case (.clock(clock), .done(full_done));
    initial begin
        wait (even_done && odd_done && full_done);
        $display("TEST_PASS DMS1_PACKET PACKING_IDENTITY_CRC_STALL_ODD_FAULT_ABORT_RESET packets=12 normal_pairs=460826 partial_resets=2");
        $finish;
    end
    initial begin
        #50000000;
        $fatal(1, "DMS1 watchdog");
    end
endmodule