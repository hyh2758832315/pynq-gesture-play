`timescale 1ns/1ps
module area2x2_case #(
    parameter integer WIDTH = 8,
    parameter integer HEIGHT = 6,
    parameter integer FULL_FRAME = 0
)(input wire clock, output reg done = 0);
    reg resetn = 0;
    reg [23:0] source_data = 0;
    reg source_valid = 0, source_user = 0, source_last = 0;
    wire source_ready;
    wire [23:0] output_data;
    wire output_valid, output_user, output_last, fault;
    reg output_ready = 0;
    integer cycle_count = 0, output_count = 0, pattern = 0, phase;
    integer source_column, source_row, output_column, output_row;
    integer output_lane, expected_sum;
    reg [23:0] expected_pixel;
    reg blocked = 0;
    reg [25:0] held_output;
    localparam integer OUTPUT_PIXELS = WIDTH * HEIGHT / 4;
    axis_area2x2 #(.INPUT_WIDTH(WIDTH), .INPUT_HEIGHT(HEIGHT)) dut (
        .aclk(clock), .aresetn(resetn), .s_axis_tdata(source_data),
        .s_axis_tvalid(source_valid), .s_axis_tuser(source_user), .s_axis_tlast(source_last),
        .s_axis_tready(source_ready), .m_axis_tdata(output_data), .m_axis_tvalid(output_valid),
        .m_axis_tuser(output_user), .m_axis_tlast(output_last), .m_axis_tready(output_ready), .frame_fault(fault)
    );
    function automatic integer sample(input integer column_index, row_index, lane_index, pattern_index);
        case (pattern_index)
            0: sample = 0;
            1: sample = 255;
            2: sample = ((column_index * 37) ^ (row_index * 91) ^ (lane_index * 53) ^ (column_index * row_index * 7)) & 255;
            3: sample = (column_index % 2 && row_index % 2) ? (column_index / 2 + row_index / 2 + lane_index) % 4 : 0;
            default: sample = column_index == 0 || row_index == 0 || column_index == WIDTH-1 || row_index == HEIGHT-1 ? 255 : 0;
        endcase
    endfunction
    always @(negedge clock) begin
        cycle_count = cycle_count + 1;
        output_ready = cycle_count % 7 != 0 && cycle_count % 11 != 0;
    end
    always @(posedge clock) begin
        if (!resetn) begin
            output_count = 0;
            blocked = 0;
        end else begin
            if (blocked && (!output_valid || {output_data, output_user, output_last} !== held_output))
                $fatal(1, "AREA2X2 unstable stalled output WIDTH=%0d", WIDTH);
            blocked = output_valid && !output_ready;
            held_output = {output_data, output_user, output_last};
            if (output_valid && output_ready) begin
                if (output_count >= OUTPUT_PIXELS) $fatal(1, "AREA2X2 extra output");
                output_column = (output_count % (WIDTH/2)) * 2;
                output_row = (output_count / (WIDTH/2)) * 2;
                for (output_lane = 0; output_lane < 3; output_lane = output_lane + 1) begin
                    expected_sum = sample(output_column, output_row, output_lane, pattern) + sample(output_column+1, output_row, output_lane, pattern) +
                                   sample(output_column, output_row+1, output_lane, pattern) + sample(output_column+1, output_row+1, output_lane, pattern);
                    expected_pixel[output_lane*8 +: 8] = (expected_sum + 2) / 4;
                end
                if (output_data !== expected_pixel || output_user !== (output_count == 0) || output_last !== (output_count == OUTPUT_PIXELS-1))
                    $fatal(1, "AREA2X2 mismatch WIDTH=%0d index=%0d got=%h expected=%h", WIDTH, output_count, output_data, expected_pixel);
                output_count = output_count + 1;
            end
        end
    end
    task automatic reset_case;
        begin
            @(negedge clock);
            resetn = 0;
            source_valid = 0;
            repeat (4) @(negedge clock);
            resetn = 1;
        end
    endtask
    task automatic send_pixel(input integer column_index, row_index, input bit user_bit, last_bit);
        integer lane_index;
        begin
            if ((column_index + row_index) % 5 == 0) @(negedge clock);
            @(negedge clock);
            for (lane_index = 0; lane_index < 3; lane_index = lane_index + 1)
                source_data[lane_index*8 +: 8] = sample(column_index, row_index, lane_index, pattern);
            source_valid = 1;
            source_user = user_bit;
            source_last = last_bit;
            do @(posedge clock); while (!source_ready);
            @(negedge clock);
            source_valid = 0;
        end
    endtask
    initial begin
        reset_case();
        for (phase = 0; phase < (FULL_FRAME ? 1 : 5); phase = phase + 1) begin
            pattern = FULL_FRAME ? 2 : phase;
            output_count = 0;
            for (source_row = 0; source_row < HEIGHT; source_row = source_row + 1)
                for (source_column = 0; source_column < WIDTH; source_column = source_column + 1)
                    send_pixel(source_column, source_row, source_column == 0 && source_row == 0, source_column == WIDTH-1);
            wait (output_count == OUTPUT_PIXELS);
            repeat (4) @(negedge clock);
            if (fault) $fatal(1, "AREA2X2 unexpected frame fault");
        end
        if (!FULL_FRAME) begin
            send_pixel(0, 0, 0, 0);
            repeat (4) @(negedge clock);
            if (!fault || source_ready || output_valid) $fatal(1, "AREA2X2 missing-SOF rejection failed");
            reset_case();
            send_pixel(0, 0, 1, 1);
            repeat (4) @(negedge clock);
            if (!fault || source_ready || output_valid) $fatal(1, "AREA2X2 bad-EOL rejection failed");
            reset_case();
            send_pixel(0, 0, 1, 0);
            reset_case();
            pattern = 3;
            for (source_row = 0; source_row < HEIGHT; source_row = source_row + 1)
                for (source_column = 0; source_column < WIDTH; source_column = source_column + 1)
                    send_pixel(source_column, source_row, source_column == 0 && source_row == 0, source_column == WIDTH-1);
            wait (output_count == OUTPUT_PIXELS);
            if (fault) $fatal(1, "AREA2X2 reset recovery failed");
        end
        $display("AREA2X2_CASE_PASS WIDTH=%0d HEIGHT=%0d FULL=%0d", WIDTH, HEIGHT, FULL_FRAME);
        done = 1;
    end
endmodule

module tb_axis_area2x2;
    reg clock = 0;
    wire small_done, minimum_done, full_done;
    always #5 clock = !clock;
    area2x2_case #(.WIDTH(8), .HEIGHT(6)) small_case(clock, small_done);
    area2x2_case #(.WIDTH(2), .HEIGHT(2)) minimum_case(clock, minimum_done);
    area2x2_case #(.WIDTH(1280), .HEIGHT(720), .FULL_FRAME(1)) full_case(clock, full_done);
    initial begin
        wait (small_done && minimum_done && full_done);
        $display("TEST_PASS AREA2X2 NUMERIC_BACKPRESSURE_FRAMING_RESET full_output_pixels=230400");
        $finish;
    end
    initial begin
        #100000000;
        $fatal(1, "AREA2X2 watchdog");
    end
endmodule