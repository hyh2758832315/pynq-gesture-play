`timescale 1ns/1ps
module dilate9_case #(
    parameter integer WIDTH = 16,
    parameter integer HEIGHT = 12,
    parameter integer FIRST_CASE = 0,
    parameter integer CASES = 8,
    parameter integer MINIMUM = 0
)(input wire clock, output reg done = 0);
    localparam integer PIXELS = WIDTH * HEIGHT;
    localparam string GOLD = "E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r236-board-reference";
    reg resetn = 0;
    reg [7:0] source_data = 0;
    reg source_valid = 0, source_user = 0, source_last = 0;
    wire source_ready;
    wire [7:0] output_data;
    wire output_valid, output_user, output_last, fault;
    reg output_ready = 0;
    reg [7:0] raw [0:PIXELS-1];
    reg [7:0] expected [0:PIXELS-1];
    reg blocked = 0;
    reg [9:0] held;
    reg [7:0] saved_pixel;
    integer cycle_count = 0, output_count = 0;
    integer case_index, source_index, file_handle, bytes_read, pixel_index;
    axis_binary_dilate9 #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) dut (
        .aclk(clock), .aresetn(resetn), .s_axis_tdata(source_data),
        .s_axis_tvalid(source_valid), .s_axis_tready(source_ready),
        .s_axis_tuser(source_user), .s_axis_tlast(source_last),
        .m_axis_tdata(output_data), .m_axis_tvalid(output_valid),
        .m_axis_tready(output_ready), .m_axis_tuser(output_user),
        .m_axis_tlast(output_last), .frame_fault(fault)
    );
    always @(negedge clock) begin
        cycle_count = cycle_count + 1;
        output_ready = cycle_count % 7 != 0 && cycle_count % 11 != 0 && cycle_count % 131 < 112;
    end
    always @(posedge clock) begin
        if (!resetn) begin
            output_count = 0;
            blocked = 0;
        end else begin
            if (blocked && (!output_valid || {output_data, output_user, output_last} !== held))
                $fatal(1, "DILATE9 stalled output changed WIDTH=%0d", WIDTH);
            blocked = output_valid && !output_ready;
            held = {output_data, output_user, output_last};
            if (output_valid && output_ready) begin
                if (output_count >= PIXELS) $fatal(1, "DILATE9 extra output");
                if (output_data !== expected[output_count] || output_user !== (output_count == 0) ||
                    output_last !== (output_count == PIXELS-1))
                    $fatal(1, "DILATE9 mismatch WIDTH=%0d case=%0d index=%0d got=%h expected=%h", WIDTH, case_index, output_count, output_data, expected[output_count]);
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
    task automatic send_pixel(input integer index, input bit user_bit, last_bit);
        begin
            if (index % 5 == 0) @(negedge clock);
            @(negedge clock);
            source_data = raw[index];
            source_user = user_bit;
            source_last = last_bit;
            source_valid = 1;
            do @(posedge clock); while (!source_ready);
            @(negedge clock);
            source_valid = 0;
        end
    endtask
    task automatic send_frame;
        begin
            output_count = 0;
            for (source_index = 0; source_index < PIXELS; source_index = source_index + 1)
                send_pixel(source_index, source_index == 0, source_index == PIXELS-1);
            wait (output_count == PIXELS);
            repeat (8) @(negedge clock);
            if (fault) $fatal(1, "DILATE9 unexpected fault");
        end
    endtask
    task automatic send_burst_frame;
        begin
            output_count = 0;
            @(negedge clock);
            source_valid = 1;
            for (source_index = 0; source_index < PIXELS; source_index = source_index + 1) begin
                source_data = raw[source_index];
                source_user = source_index == 0;
                source_last = source_index == PIXELS-1;
                do @(posedge clock); while (!source_ready);
                @(negedge clock);
            end
            source_valid = 0;
            wait (output_count == PIXELS);
            repeat (8) @(negedge clock);
            if (fault) $fatal(1, "DILATE9 burst frame fault");
        end
    endtask
    initial begin
        reset_case();
        for (case_index = FIRST_CASE; case_index < FIRST_CASE + CASES; case_index = case_index + 1) begin
            if (MINIMUM) begin
                for (pixel_index = 0; pixel_index < PIXELS; pixel_index = pixel_index + 1) begin
                    raw[pixel_index] = pixel_index == case_index ? 255 : 0;
                    expected[pixel_index] = 255;
                end
            end else begin
                file_handle = $fopen($sformatf("%s/case-%02d-raw.bin", GOLD, case_index), "rb");
                if (!file_handle) $fatal(1, "DILATE9 raw vector missing");
                bytes_read = $fread(raw, file_handle);
                $fclose(file_handle);
                if (bytes_read != PIXELS) $fatal(1, "DILATE9 raw vector length");
                file_handle = $fopen($sformatf("%s/case-%02d-dilated.bin", GOLD, case_index), "rb");
                if (!file_handle) $fatal(1, "DILATE9 gold vector missing");
                bytes_read = $fread(expected, file_handle);
                $fclose(file_handle);
                if (bytes_read != PIXELS) $fatal(1, "DILATE9 gold vector length");
            end
            send_frame();
        end
        if (WIDTH < 640) begin
            @(negedge clock);
            source_user = 0;
            source_valid = 1;
            repeat (5) @(negedge clock);
            source_valid = 0;
            if (!fault || source_ready) $fatal(1, "DILATE9 missing SOF not rejected");
            reset_case();
            send_pixel(0, 1, 1);
            repeat (4) @(negedge clock);
            if (!fault || source_ready) $fatal(1, "DILATE9 early EOF not rejected");
            reset_case();
            saved_pixel = raw[0];
            raw[0] = 1;
            send_pixel(0, 1, 0);
            repeat (4) @(negedge clock);
            if (!fault || source_ready) $fatal(1, "DILATE9 nonbinary pixel not rejected");
            reset_case();
            raw[0] = saved_pixel;
            send_pixel(0, 1, 0);
            reset_case();
            send_frame();
        end
        send_burst_frame();
        $display("DILATE9_CASE_PASS WIDTH=%0d HEIGHT=%0d CASES=%0d", WIDTH, HEIGHT, CASES);
        done = 1;
    end
endmodule

module tb_axis_binary_dilate9;
    reg clock = 0;
    wire minimum_done, small_done, full_done;
    always #5 clock = !clock;
    dilate9_case #(.WIDTH(2), .HEIGHT(2), .CASES(4), .MINIMUM(1)) minimum_case(clock, minimum_done);
    dilate9_case small_case(clock, small_done);
    dilate9_case #(.WIDTH(640), .HEIGHT(360), .FIRST_CASE(8), .CASES(2)) full_case(clock, full_done);
    initial begin
        wait (minimum_done && small_done && full_done);
        $display("TEST_PASS DILATE9 BOARD_GOLD_BACKPRESSURE_FRAMING_RESET full_output_pixels=691200 burst_frames=3 binary_reject=2");
        $finish;
    end
    initial begin
        #100000000;
        $fatal(1, "DILATE9 watchdog");
    end
endmodule