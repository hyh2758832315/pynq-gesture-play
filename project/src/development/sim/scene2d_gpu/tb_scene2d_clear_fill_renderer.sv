module tb_scene2d_clear_fill_renderer #(
    parameter bit TEST_TILE_PIPELINE_CANCEL = 1'b0,
    parameter bit TILE_PIXEL_PAIR_ENABLE = 1'b0,
    parameter bit BLIT_PIXEL_PAIR_ENABLE = 1'b0,
    parameter bit CLEAR_FILL_PIXEL_PAIR_ENABLE = 1'b0,
    parameter bit TEST_RASTER_PAIR_CASES = 1'b0,
    parameter bit TEST_BLIT_PAIR_CANCEL = 1'b0
);

    timeunit 1ns;
    timeprecision 1ps;

    localparam int EXPECTED_WRITE_COUNT = 57608;
    localparam logic [31:0] EXPECTED_TRACE_CRC32 = 32'hB62CC96A;

    logic clk = 1'b0;
    logic resetn = 1'b0;
    logic start = 1'b0;
    logic [31:0] submit_seq = '0;
    logic [8:0] command_count = '0;
    logic [8:0] command_read_address;
    logic [63:0] command_read_data;
    logic [15:0] atlas_read_address;
    logic [3:0] atlas_read_index;
    logic write_valid;
    logic write_second_valid;
    logic [7:0] write_second_token;
    logic [15:0] observed_lane_address;
    logic [7:0] observed_lane_token;
    logic [15:0] write_address;
    logic [7:0] write_token;
    logic busy;
    logic done;
    logic [31:0] completed_seq;
    logic [31:0] completed_write_count;
    logic [31:0] completed_trace_crc32;
    logic [31:0] completed_cycles;
    logic [31:0] maximum_cycles;
    logic [3:0] last_error_flags;
    logic [3:0] sticky_error_flags;
    logic [7:0] first_error_command;

    logic watchdog_start = 1'b0;
    logic [8:0] watchdog_read_address;
    logic [63:0] watchdog_read_data;
    logic watchdog_write_valid;
    logic watchdog_write_second_valid;
    logic watchdog_done;
    logic [31:0] watchdog_completed_write_count;
    logic [31:0] watchdog_completed_crc;
    logic [31:0] watchdog_observed_crc = 32'hFFFFFFFF;
    integer watchdog_observed_count = 0;
    logic watchdog_retry = 1'b0;
    logic [3:0] watchdog_last_error_flags;

    logic [63:0] command_memory [0:511];
    logic [23:0] expected_writes [0:EXPECTED_WRITE_COUNT-1];
    logic [7:0] expected_tokens [0:57599];
    logic [7:0] observed_tokens [0:57599];
    integer observed_write_count = 0;
    integer observed_second_count = 0;
    logic check_writes = 1'b0;
    logic check_blit = 1'b0;
    logic check_runtime_blit = 1'b0;
    logic runtime_asset_enable = 1'b0;
    logic [15:0] runtime_asset_width = 16'd2;
    logic [15:0] runtime_asset_height = 16'd1;
    logic [15:0] runtime_asset_stride = 16'd1;
    logic [7:0] runtime_asset_byte = 8'h21;
    logic check_extra = 1'b0;
    logic [23:0] extra_expected [0:4095];
    integer extra_count = 0;
    logic [31:0] extra_crc;
    logic [31:0] observed_crc = 32'hFFFFFFFF;
    integer runtime_blit_start_count = 0;
    logic [3:0] atlas [0:5];
    logic tile_cancel_test_done = !(TEST_TILE_PIPELINE_CANCEL || TEST_BLIT_PAIR_CANCEL);

    always #5ns clk = ~clk;

    generate
        if (TEST_TILE_PIPELINE_CANCEL || TEST_BLIT_PAIR_CANCEL) begin : tile_pipeline_cancel_test
            logic cancel_resetn = 1'b0;
            logic cancel_start = 1'b0;
            logic [31:0] cancel_submit_seq = '0;
            logic [8:0] cancel_command_address;
            logic [63:0] cancel_command_data = '0;
            logic [63:0] cancel_commands [0:7];
            logic [7:0] cancel_asset_byte = '0;
            logic [31:0] cancel_tilemap_data = '0;
            logic [15:0] cancel_tile_size = 16'd16;
            logic cancel_write_valid;
            logic cancel_write_second_valid;
            logic [7:0] cancel_write_second_token;
            logic [15:0] observed_address;
            logic [7:0] observed_token;
            logic [15:0] cancel_write_address;
            logic [7:0] cancel_write_token;
            logic cancel_busy;
            logic cancel_done;
            logic [31:0] cancel_completed_seq;
            logic [31:0] cancel_completed_count;
            logic [31:0] cancel_completed_crc;
            logic [3:0] cancel_last_error;
            logic [3:0] cancel_sticky_error;
            logic [7:0] cancel_first_error;
            logic [15:0] short_addresses [0:3];
            logic [31:0] observed_crc = 32'hFFFFFFFF;
            logic [31:0] expected_short_crc;
            integer cancel_phase = 0;
            integer cancel_write_count = 0;
            integer cancelled_write_count = 0;
            logic saw_watchdog_boundary = 1'b0;

            scene2d_clear_fill_renderer #(
                .WATCHDOG_CYCLES(160),
                .TILE_DESCRIPTOR_CACHE_ENABLE(1'b1),
                .TILE_PIXEL_PIPELINE_ENABLE(1'b1),
                .TILE_PIXEL_PAIR_ENABLE(TILE_PIXEL_PAIR_ENABLE),
                .BLIT_PIXEL_PIPELINE_ENABLE(1'b1),
                .BLIT_PIXEL_PAIR_ENABLE(BLIT_PIXEL_PAIR_ENABLE)
            ) cancel_dut (
                .aclk(clk),
                .aresetn(cancel_resetn),
                .start(cancel_start),
                .submit_seq(cancel_submit_seq),
                .command_count(9'd2),
                .command_read_address(cancel_command_address),
                .command_read_data(cancel_command_data),
                .atlas_read_address(),
                .atlas_read_index(4'd0),
                .runtime_asset_enable(1'b1),
                .runtime_asset_valid(1'b1),
                .runtime_asset_width(16'd32),
                .runtime_asset_height(16'd32),
                .runtime_asset_stride_bytes(16'd16),
                .runtime_asset_id(),
                .runtime_asset_read_address(),
                .runtime_asset_read_byte(cancel_asset_byte),
                .runtime_tilemap_enable(1'b1),
                .runtime_tilemap_valid(1'b1),
                .runtime_tilemap_width_tiles(16'd1),
                .runtime_tilemap_height_tiles(16'd1),
                .runtime_tilemap_tile_size(cancel_tile_size),
                .runtime_tilemap_id(),
                .runtime_tilemap_read_word_address(),
                .runtime_tilemap_read_word_data(cancel_tilemap_data),
                .write_valid(cancel_write_valid),
                .write_address(cancel_write_address),
                .write_token(cancel_write_token),
                .write_second_valid(cancel_write_second_valid),
                .write_second_token(cancel_write_second_token),
                .busy(cancel_busy),
                .done(cancel_done),
                .completed_seq(cancel_completed_seq),
                .completed_write_count(cancel_completed_count),
                .completed_trace_crc32(cancel_completed_crc),
                .completed_cycles(),
                .maximum_cycles(),
                .last_error_flags(cancel_last_error),
                .sticky_error_flags(cancel_sticky_error),
                .first_error_command(cancel_first_error)
            );

            always_ff @(posedge clk) begin
                cancel_command_data <= cancel_commands[cancel_command_address];
                cancel_asset_byte <= 8'h33;
                cancel_tilemap_data <= 32'h00050000;
            end

            function automatic logic [31:0] cancel_crc_write(
                input logic [31:0] previous_crc,
                input logic [15:0] address_value,
                input logic [7:0] token_value
            );
                logic [31:0] result_crc;
                logic [31:0] trace_bits;
                begin
                    result_crc = previous_crc;
                    trace_bits = {8'd0, token_value, address_value};
                    for (integer bit_index = 0; bit_index < 32; bit_index = bit_index + 1) begin
                        if (result_crc[0] ^ trace_bits[bit_index]) begin
                            result_crc = (result_crc >> 1) ^ 32'hEDB88320;
                        end else begin
                            result_crc = result_crc >> 1;
                        end
                    end
                    return result_crc;
                end
            endfunction

            task automatic check_cancel_context;
                begin
                    if (TEST_BLIT_PAIR_CANCEL) begin
                        if (cancel_dut.runtime_blit.busy || cancel_dut.runtime_blit.write_valid ||
                            cancel_dut.runtime_blit.write_second_valid ||
                            cancel_dut.runtime_blit.request_context.valid || cancel_dut.runtime_blit.response_context.valid ||
                            cancel_write_valid || cancel_write_second_valid)
                            $fatal(1, "Blit cancel left context behind");
                    end else begin
                    if (cancel_dut.tile_layer.busy !== 1'b0 ||
                        cancel_dut.tile_layer.write_valid !== 1'b0 ||
                        cancel_dut.tile_layer.write_second_valid !== 1'b0 ||
                        cancel_dut.tile_layer.request_context.valid !== 1'b0 ||
                        cancel_dut.tile_layer.response_context.valid !== 1'b0 ||
                        cancel_dut.tile_layer.descriptor_cache_valid !== 1'b0 ||
                        cancel_write_valid !== 1'b0 || cancel_write_second_valid !== 1'b0) begin
                        $fatal(1, "Tile cancel left busy/write/context/cache state behind");
                    end
                    end
                end
            endtask

            task automatic submit_cancel_render(input logic [31:0] sequence_value);
                begin
                    cancel_submit_seq = sequence_value;
                    cancel_start = 1'b1;
                    @(negedge clk);
                    cancel_start = 1'b0;
                    for (integer wait_cycle = 0; wait_cycle < 192 &&
                        cancel_done !== 1'b1; wait_cycle = wait_cycle + 1) begin
                        @(negedge clk);
                    end
                    if (cancel_done !== 1'b1 || cancel_busy !== 1'b0 ||
                        cancel_completed_seq !== sequence_value) begin
                        $fatal(1, "Tile cancel bounded completion failed seq=%08x expected=%08x busy=%b done=%b",
                            cancel_completed_seq, sequence_value, cancel_busy, cancel_done);
                    end
                end
            endtask

            always @(posedge clk) begin
                if (cancel_resetn) begin
                    for (int lane = 0; lane < 2; lane++) begin
                    observed_address = cancel_write_address + 16'(lane);
                    observed_token = lane == 0 ? cancel_write_token : cancel_write_second_token;
                    if ((lane == 0 ? cancel_write_valid : cancel_write_second_valid) === 1'b1) begin
                        if (cancel_phase == 1) begin
                            if (cancel_write_count >= (TEST_BLIT_PAIR_CANCEL ? 1024 : 256) || observed_token !== 8'h53 ||
                                observed_address !==
                                    16'((cancel_write_count / (TEST_BLIT_PAIR_CANCEL ? 32 : 16)) * 320 +
                                        cancel_write_count % (TEST_BLIT_PAIR_CANCEL ? 32 : 16))) begin
                                $fatal(1, "Tile long write[%0d]=%04x:%02x mismatch",
                                    cancel_write_count, cancel_write_address, cancel_write_token);
                            end
                        end else if (cancel_phase == 2) begin
                            if (cancel_write_count >= 4) begin
                                $fatal(1, "Tile restart emitted more than four writes");
                            end
                            if (observed_address !== short_addresses[cancel_write_count] ||
                                observed_token !== 8'h53) begin
                                $fatal(1, "Tile restart write[%0d]=%04x:%02x expected=%04x:53",
                                    cancel_write_count, cancel_write_address, cancel_write_token,
                                    short_addresses[cancel_write_count]);
                            end
                        end else begin
                            $fatal(1, "Tile cancel residual write outside submitted render");
                        end
                        observed_crc = cancel_crc_write(observed_crc,
                            observed_address, observed_token);
                        cancel_write_count = cancel_write_count + 1;
                    end else if ((lane == 0 ? cancel_write_valid : cancel_write_second_valid) !== 1'b0) begin
                        $fatal(1, "Tile cancel write_valid is unknown");
                    end
                    end
                    if (cancel_phase == 1 && cancel_dut.busy &&
                        cancel_dut.active_cycles == 32'd159) begin
                        if (saw_watchdog_boundary || cancel_write_count == 0 ||
                            (TEST_BLIT_PAIR_CANCEL ? cancel_dut.runtime_blit_write_valid : cancel_dut.tile_write_valid) !== 1'b1 ||
                            cancel_write_valid !== 1'b0 || cancel_write_second_valid !== 1'b0) begin
                            $fatal(1, "Tile watchdog boundary did not suppress an actual pending write");
                        end
                        saw_watchdog_boundary = 1'b1;
                        #1ns;
                        check_cancel_context();
                    end
                end
            end

            initial begin
                #3ms;
                $fatal(1, "SCENE2D_TILE_CANCEL global 3ms watchdog expired");
            end

            initial begin
                short_addresses[0] = 16'd967;
                short_addresses[1] = 16'd968;
                short_addresses[2] = 16'd1287;
                short_addresses[3] = 16'd1288;
                expected_short_crc = 32'hFFFFFFFF;
                for (integer pixel_index = 0; pixel_index < 4; pixel_index = pixel_index + 1) begin
                    expected_short_crc = cancel_crc_write(expected_short_crc,
                        short_addresses[pixel_index], 8'h53);
                end
                expected_short_crc = ~expected_short_crc;
                cancel_commands[0] = {32'd0, 32'd2};
                cancel_commands[1] = {32'd0, 32'd0};
                cancel_commands[2] = {32'd16, 32'h00010001};
                cancel_commands[3] = 64'd0;
                cancel_commands[4] = {32'd0, 32'h000000FF};
                cancel_commands[5] = 64'd0;
                cancel_commands[6] = 64'd0;
                cancel_commands[7] = 64'd0;
                if (TEST_BLIT_PAIR_CANCEL) begin
                    cancel_commands[0] = {32'h00050000, 32'd3};
                    cancel_commands[1] = {32'h00200020, 32'd0};
                    cancel_commands[2] = 64'd0;
                end
                repeat (5) @(posedge clk);
                @(negedge clk);
                cancel_resetn = 1'b1;
                cancel_phase = 1;
                submit_cancel_render(32'hCA160001);
                if (cancel_last_error !== 4'b1000 || cancel_sticky_error !== 4'b1000 ||
                    cancel_first_error !== 8'd0 || !saw_watchdog_boundary ||
                    cancel_write_count == 0 || cancel_write_count >= (TEST_BLIT_PAIR_CANCEL ? 1024 : 256) ||
                    cancel_completed_count !== 32'(cancel_write_count) ||
                    cancel_completed_crc !== ~observed_crc) begin
                    $fatal(1, "Tile watchdog status errors=%x sticky=%x observed=%0d completed=%0d crc=%08x expected=%08x",
                        cancel_last_error, cancel_sticky_error, cancel_write_count,
                        cancel_completed_count, cancel_completed_crc, ~observed_crc);
                end
                check_cancel_context();
                cancelled_write_count = cancel_write_count;
                cancel_tile_size = 16'd2;
                cancel_commands[1] = {32'd3, 32'd7};
                cancel_commands[2] = {32'd2, 32'h00010001};
                if (TEST_BLIT_PAIR_CANCEL) begin
                    cancel_commands[1] = {32'h00020002, 32'h00030007};
                    cancel_commands[2] = 64'd0;
                end
                cancel_phase = 2;
                cancel_write_count = 0;
                observed_crc = 32'hFFFFFFFF;
                submit_cancel_render(32'hCA020002);
                if (cancel_last_error !== 4'd0 || cancel_sticky_error !== 4'b1000 ||
                    cancel_write_count != 4 || cancel_completed_count !== 32'd4 ||
                    cancel_completed_crc !== expected_short_crc ||
                    ~observed_crc !== expected_short_crc) begin
                    $fatal(1, "Tile restart status errors=%x sticky=%x observed=%0d completed=%0d crc=%08x expected=%08x",
                        cancel_last_error, cancel_sticky_error, cancel_write_count,
                        cancel_completed_count, cancel_completed_crc, expected_short_crc);
                end
                cancel_phase = 3;
                repeat (4) begin
                    @(posedge clk);
                    #1ns;
                    check_cancel_context();
                end
                if (cancel_write_count != 4) $fatal(1, "Tile restart left residual writes");
                tile_cancel_test_done = 1'b1;
                $display("SCENE2D_TILE_CANCEL=PASS cancelled_writes=%0d restart_writes=%0d trace_crc=%08x",
                    cancelled_write_count, cancel_write_count, cancel_completed_crc);
                if (TEST_BLIT_PAIR_CANCEL) $display("SCENE2D_BLIT_CANCEL=PASS pair=%0d cancelled=%0d retry=4", BLIT_PIXEL_PAIR_ENABLE, cancelled_write_count);
            end
        end
    endgenerate

    always_ff @(posedge clk) begin
        command_read_data <= command_memory[command_read_address];
        watchdog_read_data <= command_memory[watchdog_read_address];
        atlas_read_index <= atlas[atlas_read_address];
    end

    always @(posedge clk) begin
        for (int lane = 0; lane < 2; lane++) begin
        observed_lane_address = write_address + 16'(lane);
        observed_lane_token = lane == 0 ? write_token : write_second_token;
        if (lane == 0 ? write_valid : write_second_valid) begin
            if (lane == 1) observed_second_count++;
            if (lane == 1 && write_address[0]) $fatal(1, "unaligned second write");
            if (check_writes) begin
                if (observed_write_count >= EXPECTED_WRITE_COUNT) begin
                    $fatal(1, "renderer emitted too many writes");
                end
                if (
                    observed_lane_address != expected_writes[observed_write_count][15:0] ||
                    observed_lane_token != expected_writes[observed_write_count][23:16]
                ) begin
                    $fatal(
                        1,
                        "write[%0d]=%04x:%02x expected=%04x:%02x",
                        observed_write_count,
                        observed_lane_address,
                        observed_lane_token,
                        expected_writes[observed_write_count][15:0],
                        expected_writes[observed_write_count][23:16]
                    );
                end
            end else if (check_blit) begin
                case (observed_write_count)
                    0: if (observed_lane_address != 16'd320 || observed_lane_token != 8'hA4) $fatal(1, "BLIT write 0 mismatch");
                    1: if (observed_lane_address != 16'd321 || observed_lane_token != 8'hA3) $fatal(1, "BLIT write 1 mismatch");
                    2: if (observed_lane_address != 16'd641 || observed_lane_token != 8'hA1) $fatal(1, "BLIT write 2 mismatch");
                    default: $fatal(1, "BLIT emitted too many writes");
                endcase
            end else if (check_runtime_blit) begin
                case (observed_write_count)
                    0: if (observed_lane_address != 16'd330 || observed_lane_token != 8'hA1) $fatal(1, "runtime BLIT write 0 mismatch");
                    1: if (observed_lane_address != 16'd340 || observed_lane_token != 8'hB2) $fatal(1, "runtime BLIT write 1 mismatch");
                    default: $fatal(1, "runtime BLIT emitted too many writes");
                endcase
            end
            if (check_extra && (observed_write_count >= extra_count ||
                {observed_lane_token, observed_lane_address} !== extra_expected[observed_write_count]))
                $fatal(1, "extra oracle mismatch write=%0d addr=%0d token=%02x", observed_write_count, observed_lane_address, observed_lane_token);
            observed_crc = oracle_crc_write(observed_crc, observed_lane_address, observed_lane_token);
            observed_tokens[observed_lane_address] = observed_lane_token;
            observed_write_count = observed_write_count + 1;
        end
        end
    end

    always @(posedge clk) begin
        if (check_runtime_blit && dut.runtime_blit_start) begin
            runtime_blit_start_count = runtime_blit_start_count + 1;
        end
    end

    always @(posedge clk) begin
        if (watchdog_start) begin
            watchdog_observed_count = 0;
            watchdog_observed_crc = 32'hFFFFFFFF;
        end
        for (int lane = 0; lane < 2; lane++) begin
            if (lane == 0 ? watchdog_write_valid : watchdog_write_second_valid) begin
                if (watchdog_dut.write_address + lane != (watchdog_retry ? 57599 : watchdog_observed_count))
                    $fatal(1, "solid watchdog prefix/retry address mismatch");
                watchdog_observed_crc = oracle_crc_write(watchdog_observed_crc,
                    watchdog_dut.write_address + 16'(lane), 8'h66);
                watchdog_observed_count++;
            end
        end
    end

    scene2d_clear_fill_renderer #(
        .ATLAS_WIDTH(3),
        .ATLAS_HEIGHT(2),
        .BLIT_PIXEL_PIPELINE_ENABLE(1'b1),
        .BLIT_PIXEL_PAIR_ENABLE(BLIT_PIXEL_PAIR_ENABLE),
        .CLEAR_FILL_PIXEL_PAIR_ENABLE(CLEAR_FILL_PIXEL_PAIR_ENABLE)
    ) dut (
        .aclk(clk),
        .aresetn(resetn),
        .runtime_asset_enable,
        .runtime_asset_valid(1'b1),
        .runtime_asset_width(runtime_asset_width),
        .runtime_asset_height(runtime_asset_height),
        .runtime_asset_stride_bytes(runtime_asset_stride),
        .runtime_asset_id(),
        .runtime_asset_read_address(),
        .runtime_asset_read_byte(runtime_asset_byte),
        .runtime_tilemap_enable(1'b0),
        .runtime_tilemap_valid(1'b0),
        .runtime_tilemap_width_tiles(16'd0),
        .runtime_tilemap_height_tiles(16'd0),
        .runtime_tilemap_tile_size(16'd0),
        .runtime_tilemap_id(),
        .runtime_tilemap_read_word_address(),
        .runtime_tilemap_read_word_data(32'd0),
        .start,
        .submit_seq,
        .command_count,
        .command_read_address,
        .command_read_data,
        .atlas_read_address,
        .atlas_read_index,
        .write_valid,
        .write_address,
        .write_token,
        .write_second_valid,
        .write_second_token,
        .busy,
        .done,
        .completed_seq,
        .completed_write_count,
        .completed_trace_crc32,
        .completed_cycles,
        .maximum_cycles,
        .last_error_flags,
        .sticky_error_flags,
        .first_error_command
    );

    scene2d_clear_fill_renderer #(
        .WATCHDOG_CYCLES(20),
        .CLEAR_FILL_PIXEL_PAIR_ENABLE(CLEAR_FILL_PIXEL_PAIR_ENABLE)
    ) watchdog_dut (
        .aclk(clk),
        .aresetn(resetn),
        .runtime_asset_enable(1'b0),
        .runtime_asset_valid(1'b0),
        .runtime_asset_width(16'd0),
        .runtime_asset_height(16'd0),
        .runtime_asset_stride_bytes(16'd0),
        .runtime_asset_id(),
        .runtime_asset_read_address(),
        .runtime_asset_read_byte(8'd0),
        .runtime_tilemap_enable(1'b0),
        .runtime_tilemap_valid(1'b0),
        .runtime_tilemap_width_tiles(16'd0),
        .runtime_tilemap_height_tiles(16'd0),
        .runtime_tilemap_tile_size(16'd0),
        .runtime_tilemap_id(),
        .runtime_tilemap_read_word_address(),
        .runtime_tilemap_read_word_data(32'd0),
        .start(watchdog_start),
        .submit_seq(32'h0000DEAD),
        .command_count(9'd2),
        .command_read_address(watchdog_read_address),
        .command_read_data(watchdog_read_data),
        .atlas_read_address(),
        .atlas_read_index(4'd0),
        .write_valid(watchdog_write_valid),
        .write_second_valid(watchdog_write_second_valid),
        .write_address(),
        .write_token(),
        .busy(),
        .done(watchdog_done),
        .completed_seq(),
        .completed_write_count(watchdog_completed_write_count),
        .completed_trace_crc32(watchdog_completed_crc),
        .completed_cycles(),
        .maximum_cycles(),
        .last_error_flags(watchdog_last_error_flags),
        .sticky_error_flags(),
        .first_error_command()
    );

    task automatic set_command(
        input integer index,
        input logic [31:0] word0,
        input logic [31:0] word1,
        input logic [31:0] word2,
        input logic [31:0] word3,
        input logic [31:0] word4,
        input logic [31:0] word5,
        input logic [31:0] word6,
        input logic [31:0] word7
    );
        begin
            command_memory[index * 4] = {word1, word0};
            command_memory[index * 4 + 1] = {word3, word2};
            command_memory[index * 4 + 2] = {word5, word4};
            command_memory[index * 4 + 3] = {word7, word6};
        end
    endtask

    task automatic run_render(
        input logic [31:0] sequence_value,
        input logic [8:0] count_value
    );
        begin
            observed_write_count = 0;
            observed_second_count = 0;
            observed_crc = 32'hFFFFFFFF;
            @(negedge clk);
            submit_seq = sequence_value;
            command_count = count_value;
            start = 1'b1;
            @(negedge clk);
            start = 1'b0;
            wait (done);
            @(negedge clk);
            if (completed_seq != sequence_value) begin
                $fatal(1, "completed seq=%08x expected=%08x", completed_seq, sequence_value);
            end
        end
    endtask

    initial begin
        $readmemh("sim/scene2d_gpu/vectors/c4m2_commands.mem", command_memory);
        $readmemh("sim/scene2d_gpu/vectors/c4m2_writes.mem", expected_writes);
        $readmemh("sim/scene2d_gpu/vectors/c4m2_tokens.mem", expected_tokens);
        for (integer pixel = 0; pixel < 57600; pixel = pixel + 1) begin
            observed_tokens[pixel] = 8'd0;
        end

        repeat (5) @(posedge clk);
        @(negedge clk);
        resetn = 1'b1;

        check_writes = 1'b1;
        run_render(32'hC4020001, 9'd6);
        check_writes = 1'b0;
        if (last_error_flags != 0) begin
            $fatal(1, "canonical render errors=%x", last_error_flags);
        end
        if (observed_write_count != EXPECTED_WRITE_COUNT) begin
            $fatal(1, "writes=%0d expected=%0d", observed_write_count, EXPECTED_WRITE_COUNT);
        end
        if (completed_write_count != EXPECTED_WRITE_COUNT) begin
            $fatal(1, "completed writes=%0d", completed_write_count);
        end
        if (completed_trace_crc32 != EXPECTED_TRACE_CRC32) begin
            $fatal(
                1,
                "trace crc=%08x expected=%08x",
                completed_trace_crc32,
                EXPECTED_TRACE_CRC32
            );
        end
        if (completed_cycles <= (CLEAR_FILL_PIXEL_PAIR_ENABLE ? EXPECTED_WRITE_COUNT / 2 : EXPECTED_WRITE_COUNT) || completed_cycles >= 1200000) begin
            $fatal(1, "unexpected canonical cycle count %0d", completed_cycles);
        end
        if (CLEAR_FILL_PIXEL_PAIR_ENABLE && (completed_cycles >= EXPECTED_WRITE_COUNT || observed_second_count < 28800))
            $fatal(1, "CLEAR pair throughput missing");
        for (integer pixel = 0; pixel < 57600; pixel = pixel + 1) begin
            if (observed_tokens[pixel] != expected_tokens[pixel]) begin
                $fatal(
                    1,
                    "pixel[%0d]=%02x expected=%02x",
                    pixel,
                    observed_tokens[pixel],
                    expected_tokens[pixel]
                );
            end
        end

        set_command(0, 32'd3, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0);
        atlas[0] = 1; atlas[1] = 0; atlas[2] = 2;
        atlas[3] = 3; atlas[4] = 4; atlas[5] = 0;
        set_command(0, 32'h00000303, 32'h000A0000, 32'h0001FFFF, 32'h00020003, 32'd0, 32'd0, 32'd0, 32'd0);
        set_command(1, 32'h000000FF, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0);
        check_blit = 1'b1;
        run_render(32'hC4040010, 9'd2);
        check_blit = 1'b0;
        if (
            last_error_flags != 0 || observed_write_count != 3 ||
            completed_write_count != 3 || completed_trace_crc32 != 32'h173E26EB
        ) begin
            $fatal(
                1,
                "BLIT status errors=%x observed=%0d completed=%0d crc=%08x",
                last_error_flags,
                observed_write_count,
                completed_write_count,
                completed_trace_crc32
            );
        end

        set_command(0, 32'd3, 32'h000A0000, 32'h0001000A, 32'h00010001, 32'd0, 32'd0, 32'd0, 32'd0);
        set_command(1, 32'd3, 32'h000B0000, 32'h00010014, 32'h00010001, 32'd1, 32'd0, 32'd0, 32'd0);
        set_command(2, 32'h000000FF, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0);
        runtime_blit_start_count = 0;
        runtime_asset_enable = 1'b1;
        check_runtime_blit = 1'b1;
        run_render(32'hC4070010, 9'd3);
        check_runtime_blit = 1'b0;
        runtime_asset_enable = 1'b0;
        if (
            last_error_flags != 0 || runtime_blit_start_count != 2 ||
            observed_write_count != 2 || completed_write_count != 2
        ) begin
            $fatal(
                1,
                "runtime BLIT status errors=%x starts=%0d observed=%0d completed=%0d",
                last_error_flags,
                runtime_blit_start_count,
                observed_write_count,
                completed_write_count
            );
        end

        if (TEST_RASTER_PAIR_CASES) begin
            for (int rect_case = 0; rect_case < 8; rect_case++) begin
                case (rect_case)
                    0: expect_rectangle(0, 0, 64, 3, 8'h55);
                    1: expect_rectangle(1, 2, 5, 3, 8'h55);
                    2: expect_rectangle(-2, -1, 5, 3, 8'h55);
                    3: expect_rectangle(318, 179, 5, 3, 8'h55);
                    4: expect_rectangle(319, 179, 1, 1, 8'h55);
                    5: expect_rectangle(320, 0, 4, 2, 8'h55);
                    6: expect_rectangle(0, 0, 0, 2, 8'h55);
                    7: expect_rectangle(0, 3, 320, 3, 8'h55);
                endcase
                check_extra = 1'b1;
                run_render(32'hCF000000 + rect_case, 9'd2);
                check_extra = 1'b0;
                if (last_error_flags || completed_write_count != extra_count ||
                    observed_write_count != extra_count || completed_trace_crc32 !== ~extra_crc || observed_crc !== extra_crc)
                    $fatal(1, "rectangle status mismatch case=%0d", rect_case);
                if (CLEAR_FILL_PIXEL_PAIR_ENABLE && (rect_case == 0 || rect_case == 7) && observed_second_count != extra_count / 2)
                    $fatal(1, "FILL pair throughput missing case=%0d", rect_case);
            end
            runtime_asset_enable = 1'b1;
            runtime_asset_width = 16'd8; runtime_asset_height = 16'd1; runtime_asset_stride = 16'd4;
            for (int mask_case = 0; mask_case < 8; mask_case++) begin
                case (mask_case % 4)
                    0: runtime_asset_byte = 8'h00;
                    1: runtime_asset_byte = 8'h03;
                    2: runtime_asset_byte = 8'hA0;
                    3: runtime_asset_byte = 8'hA3;
                endcase
                extra_count = 0; extra_crc = 32'hFFFFFFFF;
                for (int pixel = 0; pixel < 8; pixel++) begin
                    if (mask_case < 4 ? (pixel % 2 == 0) : (pixel % 2 == 1)) begin
                        if (runtime_asset_byte[3:0]) append_extra(16'(pixel), {4'h5, runtime_asset_byte[3:0]});
                    end else begin
                        if (runtime_asset_byte[7:4]) append_extra(16'(pixel), {4'h5, runtime_asset_byte[7:4]});
                    end
                end
                set_command(0, mask_case < 4 ? 32'd3 : 32'h00000103, 32'h00050000, 32'd0, 32'h00010008, 32'd0, 32'd0, 32'd0, 32'd0);
                set_command(1, 32'hFF, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0);
                check_extra = 1'b1;
                run_render(32'hBF000000 + mask_case, 9'd2);
                check_extra = 1'b0;
                if (last_error_flags || completed_write_count != extra_count || observed_write_count != extra_count ||
                    completed_trace_crc32 !== ~extra_crc || observed_crc !== extra_crc)
                    $fatal(1, "Blit mask status mismatch case=%0d", mask_case);
                if (BLIT_PIXEL_PAIR_ENABLE && mask_case == 3 && observed_second_count != 4)
                    $fatal(1, "Blit paired mask throughput missing");
            end
            runtime_asset_enable = 1'b0;
            $display("SCENE2D_RASTER_PAIR=PASS blit=%0d solid=%0d rectangles=8 masks=8", BLIT_PIXEL_PAIR_ENABLE, CLEAR_FILL_PIXEL_PAIR_ENABLE);
        end

        set_command(0, 32'd3, 32'd1, 32'd0, 32'h00010001, 32'd0, 32'd0, 32'd0, 32'd0);
        run_render(32'hC4040011, 9'd1);
        if (last_error_flags != 4'b0010) $fatal(1, "unknown BLIT asset was accepted");

        set_command(0, 32'd1, 32'h00000044, 32'd1, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0);
        run_render(32'hC4020011, 9'd1);
        if (last_error_flags != 4'b0010 || first_error_command != 0) begin
            $fatal(1, "malformed command status mismatch");
        end

        set_command(0, 32'd4, 32'h00000055, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0);
        run_render(32'hC4020012, 9'd1);
        if (last_error_flags != 4'b0100 || first_error_command != 0) begin
            $fatal(1, "missing END_FRAME status mismatch");
        end

        set_command(0, 32'd1, 32'h00000066, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0);
        set_command(1, 32'h000000FF, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0);
        @(negedge clk);
        watchdog_start = 1'b1;
        @(negedge clk);
        watchdog_start = 1'b0;
        wait (watchdog_done);
        @(negedge clk);
        if (watchdog_last_error_flags != 4'b1000) begin
            $fatal(1, "watchdog status=%x expected=8", watchdog_last_error_flags);
        end
        if (
            watchdog_completed_write_count == 0 ||
            watchdog_completed_write_count >= 57600 ||
            watchdog_write_valid || watchdog_write_second_valid
        ) begin
            $fatal(1, "watchdog write termination mismatch");
        end

        if (TEST_RASTER_PAIR_CASES) begin
            if (watchdog_completed_write_count != watchdog_observed_count || watchdog_completed_crc !== ~watchdog_observed_crc)
                $fatal(1, "CLEAR watchdog count/CRC mismatch");
            set_command(0, 32'd4, 32'h66, 32'd0, 32'h00B40140, 32'd0, 32'd0, 32'd0, 32'd0);
            @(negedge clk); watchdog_start = 1'b1;
            @(negedge clk); watchdog_start = 1'b0;
            wait (watchdog_done); @(negedge clk);
            if (watchdog_last_error_flags != 8 || watchdog_completed_write_count != watchdog_observed_count ||
                watchdog_completed_crc !== ~watchdog_observed_crc || watchdog_observed_count == 0 || watchdog_write_valid || watchdog_write_second_valid)
                $fatal(1, "FILL watchdog count/CRC mismatch");
            set_command(0, 32'd4, 32'h66, 32'h00B3013F, 32'h00010001, 32'd0, 32'd0, 32'd0, 32'd0);
            watchdog_retry = 1'b1;
            watchdog_start = 1'b1;
            @(negedge clk); watchdog_start = 1'b0;
            wait (watchdog_done); @(negedge clk);
            if (watchdog_last_error_flags != 0 || watchdog_completed_write_count != 1 || watchdog_observed_count != 1 ||
                watchdog_completed_crc !== ~watchdog_observed_crc || watchdog_write_valid || watchdog_write_second_valid)
                $fatal(1, "solid watchdog immediate retry mismatch");
            repeat (4) @(negedge clk);
            if (watchdog_observed_count != 1) $fatal(1, "solid residual writes after done");
            $display("SCENE2D_SOLID_CANCEL=PASS pair=%0d clear_fill_prefix_crc=checked retry_last_byte=1", CLEAR_FILL_PIXEL_PAIR_ENABLE);
        end

        $display(
            "SCENE2D_CLEAR_FILL=PASS writes=%0d trace_crc=%08x cycles=%0d errors=%x",
            EXPECTED_WRITE_COUNT,
            completed_trace_crc32,
            maximum_cycles,
            sticky_error_flags
        );
        if (TEST_TILE_PIPELINE_CANCEL || TEST_BLIT_PAIR_CANCEL) wait (tile_cancel_test_done);
        $finish;
    end

    function automatic logic [31:0] oracle_crc_write(input logic [31:0] previous_crc, input logic [15:0] address_value, input logic [7:0] token_value);
        logic [31:0] result_crc, trace_bits;
        result_crc = previous_crc;
        trace_bits = {8'd0, token_value, address_value};
        for (int bit_index = 0; bit_index < 32; bit_index++)
            result_crc = (result_crc >> 1) ^ ((result_crc[0] ^ trace_bits[bit_index]) ? 32'hEDB88320 : 32'd0);
        return result_crc;
    endfunction

    task automatic append_extra(input logic [15:0] address_value, input logic [7:0] token_value);
        extra_expected[extra_count] = {token_value, address_value};
        extra_count++;
        extra_crc = oracle_crc_write(extra_crc, address_value, token_value);
    endtask

    task automatic expect_rectangle(input int target_x, input int target_y, input int rect_width, input int rect_height, input logic [7:0] token_value);
        extra_count = 0; extra_crc = 32'hFFFFFFFF;
        for (int row_index = 0; row_index < rect_height; row_index++)
            for (int column_index = 0; column_index < rect_width; column_index++)
                if (target_x + column_index >= 0 && target_x + column_index < 320 &&
                    target_y + row_index >= 0 && target_y + row_index < 180)
                    append_extra(16'((target_y + row_index) * 320 + target_x + column_index), token_value);
        set_command(0, 32'd4, {24'd0, token_value}, {16'(target_y), 16'(target_x)},
            {16'(rect_height), 16'(rect_width)}, 32'd0, 32'd0, 32'd0, 32'd0);
        set_command(1, 32'hFF, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0);
    endtask

endmodule