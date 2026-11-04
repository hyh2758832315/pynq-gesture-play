module tb_scene2d_draw_tile_layer #(
    parameter bit TILE_PIXEL_PIPELINE_ENABLE = 1'b0,
    parameter bit CACHED_DESCRIPTOR_ENABLE = 1'b1,
    parameter bit TILE_PIXEL_PAIR_ENABLE = 1'b0,
    parameter bit TEST_TILE_PIPELINE_CASES = 1'b0
);

    timeunit 1ns;
    timeprecision 1ps;

    logic clk = 1'b0;
    logic resetn = 1'b0;
    logic start = 1'b0;
    logic asset_valid = 1'b1;
    logic signed [31:0] screen_x = -32'sd1;
    logic signed [31:0] screen_y = 32'sd0;
    logic [15:0] width_tiles = 16'd2;
    logic [15:0] height_tiles = 16'd1;
    logic [15:0] tile_size = 16'd2;
    logic [15:0] asset_width = 16'd4;
    logic [15:0] asset_height = 16'd2;
    logic [15:0] asset_stride_bytes = 16'd2;
    logic [15:0] tilemap_width_tiles = 16'd2;
    logic [9:0] tilemap_read_word_address;
    logic [31:0] tilemap_read_word_data;
    logic [14:0] asset_read_address;
    logic [7:0] asset_read_byte;
    logic write_valid;
    logic [15:0] write_address;
    logic [7:0] write_token;
    logic busy;
    logic done;
    logic malformed;
    logic [9:0] cached_tilemap_address;
    logic [31:0] cached_tilemap_data;
    logic [14:0] cached_asset_address;
    logic [7:0] cached_asset_byte;
    logic cached_write_valid;
    logic [15:0] cached_write_address;
    logic [7:0] cached_write_token;
    logic cached_write_second_valid;
    logic [7:0] cached_write_second_token;
    logic cached_busy;
    logic cached_done;
    logic cached_malformed;
    logic cached_completed = 1'b0;
    logic cached_failed = 1'b0;
    logic baseline_completed = 1'b0;
    logic baseline_failed = 1'b0;
    logic golden_case = 1'b1;
    logic poison_unused_data = 1'b0;
    logic [15:0] reference_addresses [0:57599];
    logic [7:0] reference_tokens [0:57599];
    logic [15:0] cached_addresses [0:57599];
    logic [7:0] cached_tokens [0:57599];
    logic [31:0] tilemap_words [0:1023];
    logic [7:0] asset_bytes [0:32767];
    integer writes = 0;
    integer cached_writes = 0;
    integer elapsed_cycles = 0;
    integer baseline_cycles = 0;
    integer cached_cycles = 0;
    integer command_start_cycle = 0;
    integer cached_fetches = 0;
    integer cases_run = 0;
    integer baseline_fetches = 0;
    integer cached_write_cycles [0:57599];
    integer pair_masks [0:3] = '{0, 0, 0, 0};
    logic collecting = 1'b0;

    always #5ns clk = ~clk;
    always_ff @(posedge clk) begin
        tilemap_read_word_data <= tilemap_words[tilemap_read_word_address];
        asset_read_byte <= asset_bytes[asset_read_address];
        cached_tilemap_data <= poison_unused_data && cached_dut.state == cached_dut.READ_ASSET
            ? 32'hFFC00000 : tilemap_words[cached_tilemap_address];
        cached_asset_byte <= asset_bytes[cached_asset_address];
    end

    always @(posedge clk) begin
        elapsed_cycles = elapsed_cycles + 1;
        if (resetn && collecting && dut.state == dut.SAMPLE_TILE) baseline_fetches = baseline_fetches + 1;
        if (resetn && cached_dut.state == cached_dut.SAMPLE_TILE) cached_fetches = cached_fetches + 1;
        if (resetn && cached_dut.response_context.valid && cached_dut.response_context.pair_valid)
            pair_masks[{cached_dut.response_second_index != 0, cached_dut.response_index != 0}]++;
    end
    always @(negedge clk) begin
        if (done) begin
            if (busy || write_valid) $fatal(1, "baseline done before drain");
            baseline_cycles = elapsed_cycles - command_start_cycle;
            baseline_completed = 1'b1;
            baseline_failed = malformed;
        end
        if (cached_done) begin
            if (cached_busy || cached_write_valid || cached_write_second_valid) $fatal(1, "tested done before drain");
            cached_completed = 1'b1;
            cached_failed = cached_malformed;
            cached_cycles = elapsed_cycles - command_start_cycle;
        end
    end

    scene2d_draw_tile_layer dut (
        .aclk(clk), .aresetn(resetn), .start,
        .asset_valid, .tilemap_valid(1'b1),
        .screen_x, .screen_y, .width_tiles, .height_tiles, .tile_size,
        .asset_width, .asset_height, .asset_stride_bytes,
        .tilemap_width_tiles, .tilemap_height_tiles(height_tiles), .tilemap_tile_size(tile_size),
        .tilemap_read_word_address, .tilemap_read_word_data,
        .asset_read_address, .asset_read_byte,
        .write_valid, .write_address, .write_token, .busy, .done, .malformed
    );

    scene2d_draw_tile_layer #(
        .TILE_DESCRIPTOR_CACHE_ENABLE(CACHED_DESCRIPTOR_ENABLE),
        .TILE_PIXEL_PIPELINE_ENABLE(TILE_PIXEL_PIPELINE_ENABLE),
        .TILE_PIXEL_PAIR_ENABLE(TILE_PIXEL_PAIR_ENABLE)
    ) cached_dut (
        .aclk(clk), .aresetn(resetn), .start,
        .asset_valid, .tilemap_valid(1'b1),
        .screen_x, .screen_y, .width_tiles, .height_tiles, .tile_size,
        .asset_width, .asset_height, .asset_stride_bytes,
        .tilemap_width_tiles, .tilemap_height_tiles(height_tiles), .tilemap_tile_size(tile_size),
        .tilemap_read_word_address(cached_tilemap_address), .tilemap_read_word_data(cached_tilemap_data),
        .asset_read_address(cached_asset_address), .asset_read_byte(cached_asset_byte),
        .write_valid(cached_write_valid), .write_address(cached_write_address),
        .write_second_valid(cached_write_second_valid), .write_second_token(cached_write_second_token),
        .write_token(cached_write_token), .busy(cached_busy), .done(cached_done),
        .malformed(cached_malformed)
    );

    always @(posedge clk) if (collecting && write_valid) begin
        if (baseline_completed) $fatal(1, "baseline write after done");
        if (writes >= 57600) $fatal(1, "too many baseline writes");
        if (golden_case) case (writes)
            0: if (write_address != 16'd0 || write_token != 8'h32) $fatal(1, "write 0 mismatch");
            1: if (write_address != 16'd1 || write_token != 8'h46) $fatal(1, "write 1 mismatch");
            2: if (write_address != 16'd2 || write_token != 8'h45) $fatal(1, "write 2 mismatch");
            3: if (write_address != 16'd320 || write_token != 8'h34) $fatal(1, "write 3 mismatch");
            4: if (write_address != 16'd322 || write_token != 8'h47) $fatal(1, "write 4 mismatch");
            default: $fatal(1, "unexpected write");
        endcase
        reference_addresses[writes] = write_address;
        reference_tokens[writes] = write_token;
        writes = writes + 1;
    end

    always @(posedge clk) if (collecting && (cached_write_valid || cached_write_second_valid)) begin
        if (cached_completed) $fatal(1, "tested write after done");
        if (cached_writes >= 57600) $fatal(1, "too many cached writes");
        if (cached_write_valid) begin
            cached_addresses[cached_writes] = cached_write_address;
            cached_tokens[cached_writes] = cached_write_token;
            cached_write_cycles[cached_writes] = elapsed_cycles;
            cached_writes = cached_writes + 1;
        end
        if (cached_write_second_valid) begin
            if (cached_write_address[0]) $fatal(1, "unaligned pair write");
            cached_addresses[cached_writes] = cached_write_address + 16'd1;
            cached_tokens[cached_writes] = cached_write_second_token;
            cached_write_cycles[cached_writes] = elapsed_cycles;
            cached_writes = cached_writes + 1;
        end
    end

    initial begin
        #3ms;
        $fatal(1, "tile layer watchdog expired");
    end

    task automatic configure_layer(
        input integer size, input integer columns, input integer rows,
        input integer left, input integer top
    );
        begin
            tile_size = size;
            width_tiles = columns;
            tilemap_width_tiles = columns;
            height_tiles = rows;
            screen_x = left;
            screen_y = top;
            asset_width = 2 * size;
            asset_height = 2 * size;
            asset_stride_bytes = size;
            asset_valid = 1'b1;
            for (int index = 0; index < 1024; index = index + 1) begin
                tilemap_words[index] = ((index % 4) << 20) | (((index % 3) + 1) << 16) | (index % 4);
            end
            for (int index = 0; index < 32768; index = index + 1) begin
                asset_bytes[index] = (((index + 4) % 16) << 4) | ((index + 1) % 16);
            end
        end
    endtask

    task automatic check_oracle;
        integer expected_count;
        integer local_column;
        integer local_row;
        integer source_column;
        integer source_row;
        integer byte_offset;
        logic [31:0] descriptor;
        logic [3:0] source_nibble;
        begin
            expected_count = 0;
            for (int row = 0; row < 180; row = row + 1) begin
                for (int column = 0; column < 320; column = column + 1) begin
                    local_column = column - screen_x;
                    local_row = row - screen_y;
                    if (local_column >= 0 && local_row >= 0 &&
                        local_column < width_tiles * tile_size && local_row < height_tiles * tile_size) begin
                        descriptor = tilemap_words[(4 + (local_row / tile_size) * width_tiles + local_column / tile_size) % 1024];
                        source_column = (descriptor[15:0] % (asset_width / tile_size)) * tile_size +
                            (descriptor[20] ? tile_size - 1 - local_column % tile_size : local_column % tile_size);
                        source_row = (descriptor[15:0] / (asset_width / tile_size)) * tile_size +
                            (descriptor[21] ? tile_size - 1 - local_row % tile_size : local_row % tile_size);
                        byte_offset = source_row * asset_stride_bytes + source_column / 2;
                        source_nibble = source_column % 2 ? asset_bytes[byte_offset][7:4] : asset_bytes[byte_offset][3:0];
                        if (source_nibble != 0) begin
                            if (expected_count >= writes || reference_addresses[expected_count] !== row * 320 + column ||
                                reference_tokens[expected_count] !== {descriptor[19:16], source_nibble})
                                $fatal(1, "oracle mismatch at pixel %0d,%0d", column, row);
                            expected_count = expected_count + 1;
                        end
                    end
                end
            end
            if (expected_count != writes) $fatal(1, "oracle write count mismatch");
        end
    endtask

    task automatic run_case(
        input string label, input logic expected_error,
        input logic require_gain, input integer expected_fetches,
        input logic busy_probe = 1'b0
    );
        begin
            @(negedge clk);
            #1ns;
            writes = 0;
            cached_writes = 0;
            cached_fetches = 0;
            baseline_fetches = 0;
            collecting = 1'b1;
            baseline_completed = 1'b0;
            cached_completed = 1'b0;
            command_start_cycle = elapsed_cycles;
            start = 1'b1;
            @(negedge clk);
            #1ns;
            start = 1'b0;
            if (dut.state != dut.SETUP_TILE || !busy) $fatal(1, "tile layer did not enter setup state");
            @(negedge clk);
            #1ns;
            if (dut.state != dut.VALIDATE_TILE) $fatal(1, "tile layer setup did not enter validation state");
            if (busy_probe) begin
                repeat (5) @(negedge clk);
                if (!busy || !cached_busy) $fatal(1, "busy probe requires active DUTs");
                screen_x = -99; width_tiles = 0; start = 1;
                @(negedge clk); start = 0; screen_x = 0; width_tiles = 1;
            end
            while (!baseline_completed || !cached_completed) begin
                @(negedge clk);
                #1ns;
            end
            if (busy || cached_busy || baseline_failed !== expected_error || cached_failed !== expected_error ||
                writes != cached_writes || cached_cycles > baseline_cycles ||
                (CACHED_DESCRIPTOR_ENABLE && require_gain && cached_cycles >= baseline_cycles)) $fatal(1, "completion mismatch: %s", label);
            if (!CACHED_DESCRIPTOR_ENABLE && cached_fetches != baseline_fetches)
                $fatal(1, "uncached fetch mismatch: %s", label);
            if (CACHED_DESCRIPTOR_ENABLE && expected_fetches >= 0 && cached_fetches != expected_fetches)
                $fatal(1, "descriptor fetch mismatch: %s expected=%0d actual=%0d", label, expected_fetches, cached_fetches);
            for (int index = 0; index < writes; index = index + 1) begin
                if (cached_addresses[index] !== reference_addresses[index] || cached_tokens[index] !== reference_tokens[index])
                    $fatal(1, "cached trace mismatch: %s at %0d", label, index);
            end
            if (!expected_error) check_oracle();
            cases_run = cases_run + 1;
            $display("TILE_CACHE_CASE=PASS name=%s writes=%0d baseline=%0d cached=%0d fetches=%0d error=%0d",
                label, writes, baseline_cycles, cached_cycles, cached_fetches, expected_error);
            repeat (3) @(negedge clk);
            if (busy || cached_busy || write_valid || cached_write_valid || cached_write_second_valid) $fatal(1, "residual tile output");
            collecting = 1'b0;
        end
    endtask

    initial begin
        tilemap_words[0] = 32'h00010002;
        tilemap_words[1] = 32'hFFFFFFFF;
        tilemap_words[2] = 32'd0;
        tilemap_words[3] = 32'd2;
        tilemap_words[4] = 32'h00030000;
        tilemap_words[5] = 32'h00140001;
        asset_bytes[0] = 8'h21;
        asset_bytes[1] = 8'h65;
        asset_bytes[2] = 8'h43;
        asset_bytes[3] = 8'h07;
        repeat (3) @(negedge clk);
        #1ns;
        resetn = 1'b1;
        run_case("original_golden", 1'b0, 1'b1, 4);
        if (writes != 5) $fatal(1, "golden write count mismatch");
        golden_case = 1'b0;
        poison_unused_data = 1'b1;
        for (int size = 1; size <= 16; size = size * 2) begin
            configure_layer(size, 3, 2, 0, 0);
            run_case($sformatf("size_%0d_flip_xy_transparent", size), 1'b0, size > 1, -1);
            configure_layer(size, 3, 2, -1, -1);
            run_case($sformatf("size_%0d_negative_xy", size), 1'b0, size > 1, -1);
        end
        configure_layer(16, 2, 2, 311, 173);
        run_case("right_bottom_clip", 1'b0, 1'b1, -1);
        configure_layer(4, 1, 1, 0, 0);
        run_case("single_tile", 1'b0, 1'b1, 1);
        tilemap_words[4] = 32'h00370003;
        run_case("same_address_new_descriptor", 1'b0, 1'b1, 1);
        asset_bytes[18] = 8'hFE;
        asset_bytes[31] = 8'hED;
        run_case("same_address_new_asset", 1'b0, 1'b1, 1);
        if (writes != 16) $fatal(1, "asset mutation did not affect rendered pixels");
        tilemap_words[4] = 32'h00400000;
        run_case("reserved_descriptor", 1'b1, 1'b0, 1);
        tilemap_words[4] = 32'h00000004;
        run_case("source_out_of_bounds", 1'b1, 1'b0, 1);
        configure_layer(4, 2, 1, 0, 0);
        tilemap_words[5] = 32'h00400000;
        run_case("malformed_after_partial_write", 1'b1, 1'b1, 2);
        configure_layer(2, 1024, 2, 319, 0);
        run_case("full_address_tag", 1'b0, 1'b1, 2);
        configure_layer(2, 2, 1, 0, 0);
        asset_valid = 1'b0;
        run_case("missing_asset", 1'b1, 1'b0, 0);
        asset_valid = 1'b1;
        tilemap_width_tiles = 3;
        run_case("shape_mismatch", 1'b1, 1'b0, 0);
        configure_layer(2, 2, 1, 320, 0);
        run_case("fully_clipped", 1'b1, 1'b0, 0);
        if (TEST_TILE_PIPELINE_CASES) begin
            configure_layer(16, 1, 1, 0, 0);
            tilemap_words[4] = 32'h00050000;
            for (int byte_index = 0; byte_index < 32768; byte_index++) asset_bytes[byte_index] = 8'hA3;
            run_case("long_opaque_run", 0, 1, 1);
            if (CACHED_DESCRIPTOR_ENABLE && TILE_PIXEL_PIPELINE_ENABLE) begin
                for (int write_index = 1; write_index < cached_writes; write_index++) begin
                    if (cached_addresses[write_index] / 320 == cached_addresses[write_index - 1] / 320 &&
                        cached_write_cycles[write_index] - cached_write_cycles[write_index - 1] !=
                            (TILE_PIXEL_PAIR_ENABLE && cached_addresses[write_index][0] ? 0 : 1))
                        $fatal(1, "tile write II mismatch at %0d", write_index);
                end
                $display("TILE_WRITE_PIXELS_PER_CLOCK=%0d writes=%0d cycles=%0d",
                    TILE_PIXEL_PAIR_ENABLE ? 2 : 1, cached_writes, cached_cycles);
            end
            run_case("busy_start_ignored", 0, 1, 1, 1);
            for (int byte_index = 0; byte_index < 32768; byte_index++) asset_bytes[byte_index] = 0;
            run_case("all_transparent", 0, 1, 1);
            for (int byte_index = 0; byte_index < 32768; byte_index++) asset_bytes[byte_index] = 8'hA3;
            asset_bytes[247] = 8'h03;
            run_case("last_transparent", 0, 1, 1);
            if (writes != 255) $fatal(1, "last transparent pixel not exercised");
            configure_layer(1, 1, 1, 0, 0);
            tilemap_words[4] = 32'h00050000;
            run_case("single_pixel", 0, 0, 1);
            asset_bytes[0] = 0;
            run_case("single_transparent", 0, 0, 1);
            configure_layer(2, 2, 2, 0, 0);
            tilemap_words[4] = 32'h00010000; tilemap_words[5] = 32'h00150001;
            tilemap_words[6] = 32'h00290002; tilemap_words[7] = 32'h003D0003;
            run_case("cross_descriptor_row_palette_flip", 0, 1, -1);
            if (TILE_PIXEL_PAIR_ENABLE) begin
            configure_layer(4, 1, 1, 0, 0);
            tilemap_words[4] = 32'h00050000;
            asset_bytes[0] = 8'h00; asset_bytes[1] = 8'h03;
            asset_bytes[4] = 8'hA0; asset_bytes[5] = 8'hA3;
            run_case("four_pair_masks", 0, 1, 1);
            tilemap_words[4] = 32'h00150000;
            run_case("four_pair_masks_flip_x", 0, 1, 1);
            configure_layer(4, 1, 1, 1, 0);
            tilemap_words[4] = 32'h00050000;
            run_case("odd_destination_single_fallback", 0, 1, 1);
            if (TILE_PIXEL_PAIR_ENABLE && CACHED_DESCRIPTOR_ENABLE && TILE_PIXEL_PIPELINE_ENABLE) begin
                for (int mask_index = 0; mask_index < 4; mask_index++)
                    if (pair_masks[mask_index] == 0) $fatal(1, "pair mask %0d not exercised", mask_index);
                $display("TILE_PAIR_MASKS=PASS zero=%0d first=%0d second=%0d both=%0d",
                    pair_masks[0], pair_masks[1], pair_masks[2], pair_masks[3]);
            end
            end
            configure_layer(4, 1, 1, 0, 0);
            asset_height = 6; tilemap_words[4] = 32'h00050002;
            run_case("source_error_after_valid_rows", 1, 1, 1);
            if (writes == 0) $fatal(1, "source prefix was not exercised");
            configure_layer(16, 1, 1, 0, 0);
            @(negedge clk); start = 1;
            @(negedge clk); start = 0;
            repeat (12) @(negedge clk); resetn = 0;
            @(posedge clk); #1ns;
            if (busy || cached_busy || write_valid || cached_write_valid || cached_write_second_valid || done || cached_done ||
                cached_dut.request_context.valid || cached_dut.response_context.valid)
                $fatal(1, "tile reset did not clear pipeline");
            @(negedge clk); resetn = 1;
            repeat (4) @(negedge clk);
            if (write_valid || cached_write_valid || done || cached_done) $fatal(1, "tile reset stale response");
            configure_layer(4, 1, 1, 0, 0);
            run_case("after_reset", 0, 1, 1);
            $display("SCENE2D_TILE_PIPELINE=PASS cache=%0d pipeline=%0d cases=%0d",
                CACHED_DESCRIPTOR_ENABLE, TILE_PIXEL_PIPELINE_ENABLE, cases_run);
            $display("SCENE2D_TILE_PAIR=PASS cache=%0d pipeline=%0d pair=%0d cases=%0d",
                CACHED_DESCRIPTOR_ENABLE, TILE_PIXEL_PIPELINE_ENABLE, TILE_PIXEL_PAIR_ENABLE, cases_run);
        end
        $display("SCENE2D_DRAW_TILE_LAYER=PASS cases=%0d", cases_run);
        $finish;
    end

endmodule