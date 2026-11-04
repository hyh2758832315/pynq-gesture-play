`timescale 1ns/1ps
module gaussian5_case #(
    parameter integer WIDTH = 16,
    parameter integer HEIGHT = 12,
    parameter integer CHAIN = 0
)(input wire clock, output reg done = 0);
    localparam integer PIXELS = WIDTH * HEIGHT;
    localparam integer FIRST_CASE = CHAIN && WIDTH == 640 ? 8 : 0;
    localparam integer CASES = CHAIN && WIDTH == 640 ? 2 : 8;
    localparam string GOLD = CHAIN ?
        "E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r236-board-reference" :
        "E:/projects/fpga/voice-view-game/results/game-validation/vision-pl-streaming-20261015/r245-gaussian-reference";
    reg resetn = 0;
    reg [7:0] source_data = 0;
    reg source_valid = 0, source_user = 0, source_last = 0;
    wire source_ready;
    wire [7:0] output_data;
    wire output_valid, output_user, output_last, fault;
    wire [7:0] link_data;
    wire link_valid, link_ready, link_user, link_last, link_fault, gaussian_fault;
    wire [15:0] pair_data;
    reg output_ready = 0, blocked = 0;
    reg [9:0] held;
    reg [7:0] raw [0:PIXELS-1];
    reg [7:0] expected [0:PIXELS-1];
    integer cycle_count = 0, output_count = 0, raw_high_water = 0;
    integer case_index, source_index, file_handle, bytes_read;
    integer overlap_received = 0, overlap_frame, stall_until_cycle = 0;
    reg overlap_mode = 0, overlap_observed = 0;
    wire [7:0] expected_pixel = overlap_mode ? (overlap_received == 0 ? 8'h00 : 8'hff) : expected[output_count];
    wire [7:0] expected_raw = overlap_mode ? (overlap_received == 0 ? 8'h00 : 8'hff) : raw[output_count];
    assign fault = link_fault || gaussian_fault;
    generate
        if (CHAIN == 2) begin : with_pair
            axis_binary_mask_pair #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) dut (
                .aclk(clock), .aresetn(resetn), .s_axis_tdata(source_data),
                .s_axis_tvalid(source_valid), .s_axis_tready(source_ready),
                .s_axis_tuser(source_user), .s_axis_tlast(source_last),
                .m_axis_tdata(pair_data), .m_axis_tvalid(output_valid),
                .m_axis_tready(output_ready), .m_axis_tuser(output_user),
                .m_axis_tlast(output_last), .frame_fault(gaussian_fault)
            );
            assign output_data = pair_data[15:8];
            assign link_fault = 0;
            always @(posedge clock) begin
                if (resetn) begin
                    if (dut.raw_count > raw_high_water) raw_high_water = dut.raw_count;
                    if (dut.raw_count > 6 * WIDTH + 32) $fatal(1, "MASK_PAIR raw lead exceeded test bound");
                    if (overlap_mode && overlap_received == 0 && dut.dilated_valid &&
                        dut.dilated_ready && dut.dilated_last) stall_until_cycle = cycle_count + 6000;
                end
            end
        end else begin : without_pair
        if (CHAIN == 1) begin : with_dilation
            axis_binary_dilate9 #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) dilation (
                .aclk(clock), .aresetn(resetn), .s_axis_tdata(source_data),
                .s_axis_tvalid(source_valid), .s_axis_tready(source_ready),
                .s_axis_tuser(source_user), .s_axis_tlast(source_last),
                .m_axis_tdata(link_data), .m_axis_tvalid(link_valid),
                .m_axis_tready(link_ready), .m_axis_tuser(link_user),
                .m_axis_tlast(link_last), .frame_fault(link_fault)
            );
        end else begin : gaussian_only
            assign link_data = source_data;
            assign link_valid = source_valid;
            assign source_ready = link_ready;
            assign link_user = source_user;
            assign link_last = source_last;
            assign link_fault = 0;
        end
    axis_binary_gaussian5 #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) dut (
        .aclk(clock), .aresetn(resetn), .s_axis_tdata(link_data),
        .s_axis_tvalid(link_valid), .s_axis_tready(link_ready),
        .s_axis_tuser(link_user), .s_axis_tlast(link_last),
        .m_axis_tdata(output_data), .m_axis_tvalid(output_valid),
        .m_axis_tready(output_ready), .m_axis_tuser(output_user),
        .m_axis_tlast(output_last), .frame_fault(gaussian_fault)
    );
        end
    endgenerate
    always @(negedge clock) begin
        cycle_count = cycle_count + 1;
        output_ready = cycle_count % 7 != 0 && cycle_count % 11 != 0 && cycle_count % 131 < 112;
        if (CHAIN == 2 && cycle_count % 4093 < 768) output_ready = 0;
        if (CHAIN == 2 && cycle_count < stall_until_cycle) output_ready = 0;
    end
    always @(posedge clock) begin
        if (!resetn) begin
            output_count = 0;
            blocked = 0;
        end else begin
            if (blocked && (!output_valid || {output_data, output_user, output_last} !== held))
                $fatal(1, "GAUSSIAN stalled output changed WIDTH=%0d HEIGHT=%0d", WIDTH, HEIGHT);
            blocked = output_valid && !output_ready;
            held = {output_data, output_user, output_last};
            if (output_valid && output_ready) begin
                if (output_count >= PIXELS) $fatal(1, "GAUSSIAN extra output");
                if (CHAIN == 2 && pair_data[7:0] !== expected_raw)
                    $fatal(1, "MASK_PAIR raw alignment mismatch index=%0d", output_count);
                if (output_data !== expected_pixel || output_user !== (output_count == 0) ||
                    output_last !== (output_count == PIXELS-1))
                    $fatal(1, "GAUSSIAN mismatch WIDTH=%0d HEIGHT=%0d case=%0d index=%0d got=%h expected=%h", WIDTH, HEIGHT, case_index, output_count, output_data, expected[output_count]);
                if (overlap_mode && output_count == PIXELS-1) begin
                    output_count = 0;
                    overlap_received = overlap_received + 1;
                end else output_count = output_count + 1;
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
    task automatic send_frame(input bit burst, input bit omit_eof = 0);
        begin
            output_count = 0;
            @(negedge clock);
            for (source_index = 0; source_index < PIXELS; source_index = source_index + 1) begin
                source_data = raw[source_index];
                source_user = source_index == 0;
                source_last = source_index == PIXELS-1 && !omit_eof;
                source_valid = 1;
                do @(posedge clock); while (!source_ready);
                @(negedge clock);
                if (!burst) begin
                    source_valid = 0;
                    @(negedge clock);
                end
            end
            source_valid = 0;
            if (omit_eof) begin
                repeat (5) @(negedge clock);
                if (!fault || source_ready) $fatal(1, "GAUSSIAN missing EOF not rejected");
            end else begin
                wait (output_count == PIXELS);
                repeat (8) @(negedge clock);
                if (fault) $fatal(1, "GAUSSIAN valid frame fault");
            end
        end
    endtask
    task automatic send_one(input reg [7:0] value, input bit user_bit, last_bit);
        begin
            @(negedge clock);
            source_data = value;
            source_user = user_bit;
            source_last = last_bit;
            source_valid = 1;
            do @(posedge clock); while (!source_ready);
            @(negedge clock);
            source_valid = 0;
        end
    endtask
    task automatic send_overlapped_frames;
        begin
            output_count = 0;
            overlap_received = 0;
            overlap_mode = 1;
            @(negedge clock);
            for (overlap_frame = 0; overlap_frame < 2; overlap_frame = overlap_frame + 1) begin
                for (source_index = 0; source_index < PIXELS; source_index = source_index + 1) begin
                    source_data = overlap_frame == 0 ? 0 : 255;
                    source_user = source_index == 0;
                    source_last = source_index == PIXELS-1;
                    source_valid = 1;
                    do @(posedge clock); while (!source_ready);
                    if (overlap_frame == 1 && source_index == 0 && overlap_received == 0) overlap_observed = 1;
                    @(negedge clock);
                end
            end
            source_valid = 0;
            wait (overlap_received == 2);
            repeat (8) @(negedge clock);
            if (fault || !overlap_observed) $fatal(1, "MASK_PAIR overlap not actually verified");
        end
    endtask
    initial begin
        reset_case();
        for (case_index = FIRST_CASE; case_index < FIRST_CASE + CASES; case_index = case_index + 1) begin
            if (CHAIN) file_handle = $fopen($sformatf("%s/case-%02d-raw.bin", GOLD, case_index), "rb");
            else file_handle = $fopen($sformatf("%s/h%03d-w%03d-case-%02d-input.bin", GOLD, HEIGHT, WIDTH, case_index), "rb");
            if (!file_handle) $fatal(1, "GAUSSIAN input vector missing");
            bytes_read = $fread(raw, file_handle);
            $fclose(file_handle);
            if (bytes_read != PIXELS) $fatal(1, "GAUSSIAN input vector length");
            if (CHAIN) file_handle = $fopen($sformatf("%s/case-%02d-filtered.bin", GOLD, case_index), "rb");
            else file_handle = $fopen($sformatf("%s/h%03d-w%03d-case-%02d-filtered.bin", GOLD, HEIGHT, WIDTH, case_index), "rb");
            if (!file_handle) $fatal(1, "GAUSSIAN gold vector missing");
            bytes_read = $fread(expected, file_handle);
            $fclose(file_handle);
            if (bytes_read != PIXELS) $fatal(1, "GAUSSIAN gold vector length");
            send_frame(case_index % 2);
        end
        if (WIDTH < 640) begin
            @(negedge clock);
            source_valid = 1;
            source_user = 0;
            repeat (5) @(negedge clock);
            source_valid = 0;
            if (!fault || source_ready) $fatal(1, "GAUSSIAN missing SOF not rejected");
            reset_case();
            send_one(raw[0], 1, 1);
            repeat (4) @(negedge clock);
            if (!fault || source_ready) $fatal(1, "GAUSSIAN early EOF not rejected");
            reset_case();
            send_one(1, 1, 0);
            repeat (4) @(negedge clock);
            if (!fault || source_ready) $fatal(1, "GAUSSIAN nonbinary pixel not rejected");
            reset_case();
            send_one(raw[0], 1, 0);
            send_one(raw[1], 1, 0);
            repeat (4) @(negedge clock);
            if (!fault || source_ready) $fatal(1, "GAUSSIAN unexpected SOF not rejected");
            reset_case();
            send_frame(1, 1);
            reset_case();
            send_one(raw[0], 1, 0);
            reset_case();
            send_frame(0);
        end
        send_frame(1);
        if (CHAIN == 2) send_overlapped_frames();
        if (CHAIN == 2) $display("MASK_PAIR_CASE_PASS WIDTH=%0d HEIGHT=%0d CASES=%0d RAW_HIGH_WATER=%0d", WIDTH, HEIGHT, CASES, raw_high_water);
        else if (CHAIN) $display("FILTER_CHAIN_CASE_PASS WIDTH=%0d HEIGHT=%0d CASES=%0d", WIDTH, HEIGHT, CASES);
        else $display("GAUSSIAN_CASE_PASS WIDTH=%0d HEIGHT=%0d CASES=%0d", WIDTH, HEIGHT, CASES);
        done = 1;
    end
endmodule

module tb_axis_binary_gaussian5 #(parameter integer AUTOFINISH = 1)(output reg done = 0);
    reg clock = 0;
    wire [5:0] cases_done;
    always #5 clock = !clock;
    gaussian5_case #(.WIDTH(2), .HEIGHT(2)) minimum_case(clock, cases_done[0]);
    gaussian5_case #(.WIDTH(2), .HEIGHT(3)) vertical_case(clock, cases_done[1]);
    gaussian5_case #(.WIDTH(3), .HEIGHT(2)) horizontal_case(clock, cases_done[2]);
    gaussian5_case #(.WIDTH(3), .HEIGHT(3)) three_case(clock, cases_done[3]);
    gaussian5_case small_case(clock, cases_done[4]);
    gaussian5_case #(.WIDTH(640), .HEIGHT(360)) full_case(clock, cases_done[5]);
    initial begin
        wait (&cases_done);
        $display("TEST_PASS GAUSSIAN BOARD_GOLD_REFLECT101_BACKPRESSURE_FRAMING_RESET full_output_pixels=2073600 dimensions=6 cases=48");
        done = 1;
        if (AUTOFINISH) $finish;
    end
    initial begin
        #200000000;
        $fatal(1, "GAUSSIAN watchdog");
    end
endmodule

module tb_binary_filter_chain;
    reg clock = 0;
    wire small_done, full_done, regression_done;
    always #5 clock = !clock;
    gaussian5_case #(.CHAIN(1)) small_case(clock, small_done);
    gaussian5_case #(.WIDTH(640), .HEIGHT(360), .CHAIN(1)) full_case(clock, full_done);
    tb_axis_binary_gaussian5 #(.AUTOFINISH(0)) unit_regression(regression_done);
    initial begin
        wait (small_done && full_done && regression_done);
        $display("TEST_PASS FILTER_CHAIN BOARD_GOLD_BACKPRESSURE_FRAMING_RESET chain_full_pixels=691200 gaussian_regression_full_pixels=2073600");
        $finish;
    end
    initial begin
        #200000000;
        $fatal(1, "FILTER_CHAIN watchdog");
    end
endmodule

module tb_binary_mask_pair;
    reg clock = 0;
    wire small_done, full_done, regression_done;
    always #5 clock = !clock;
    gaussian5_case #(.CHAIN(2)) small_case(clock, small_done);
    gaussian5_case #(.WIDTH(640), .HEIGHT(360), .CHAIN(2)) full_case(clock, full_done);
    tb_axis_binary_gaussian5 #(.AUTOFINISH(0)) unit_regression(regression_done);
    initial begin
        wait (small_done && full_done && regression_done);
        $display("TEST_PASS MASK_PAIR BOARD_GOLD_RAW_FILTERED_BACKPRESSURE_FRAMING_RESET full_pairs=1152000 overlapped_frames=4 forced_tail_stall_cycles=6000 gaussian_regression_full_pixels=2073600");
        $finish;
    end
    initial begin
        #200000000;
        $fatal(1, "MASK_PAIR watchdog");
    end
endmodule