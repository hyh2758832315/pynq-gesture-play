module tb_scene2d_index4_asset_blit #(
    parameter bit TEST_BLIT_PAIR_CASES = 1'b0
);

    timeunit 1ns;
    timeprecision 1ps;

    logic clk = 1'b0, resetn = 1'b0, start = 1'b0;
    logic asset_valid = 1'b1;
    logic [3:0] palette_bank = 4'hA;
    logic signed [15:0] dst_x = 0, dst_y = 0;
    logic [15:0] width = 5, height = 3, src_x = 0, src_y = 0;
    logic [15:0] asset_width = 5, asset_height = 3, asset_stride_bytes = 3;
    logic flip_x = 1'b0, flip_y = 1'b0;
    logic [14:0] read_address [0:3];
    logic [7:0] read_byte [0:3];
    logic [3:0] write_valid, write_second_valid, busy, done;
    logic [15:0] write_address [0:3];
    logic [7:0] write_token [0:3], write_second_token [0:3];
    logic [7:0] asset_bytes [0:32767];
    logic [15:0] trace_address [0:3][0:4095];
    logic [7:0] trace_token [0:3][0:4095];
    integer trace_cycle [0:3][0:4095];
    integer writes [0:3];
    integer done_cycle [0:3];
    logic [3:0] done_seen = 0;
    integer pair_masks [0:3] = '{default:0};
    bit collecting = 0;
    integer cycles = 0, start_cycle = 0, cases = 0;

    always #5ns clk = ~clk;
    always @(posedge clk) cycles = cycles + 1;

    for (genvar mode_index = 0; mode_index < 4; mode_index++) begin : modes
        always_ff @(posedge clk) read_byte[mode_index] <= asset_bytes[read_address[mode_index]];
        scene2d_index4_asset_blit #(
            .BLIT_PIXEL_PIPELINE_ENABLE(mode_index % 2 == 1),
            .BLIT_PIXEL_PAIR_ENABLE(mode_index >= 2)
        ) dut (
            .aclk(clk), .aresetn(resetn), .start, .asset_valid, .palette_bank,
            .dst_x, .dst_y, .width, .height, .src_x, .src_y,
            .asset_width, .asset_height, .asset_stride_bytes, .flip_x, .flip_y,
            .asset_read_address(read_address[mode_index]), .asset_read_byte(read_byte[mode_index]),
            .write_valid(write_valid[mode_index]), .write_address(write_address[mode_index]),
            .write_token(write_token[mode_index]),
            .write_second_valid(write_second_valid[mode_index]),
            .write_second_token(write_second_token[mode_index]),
            .busy(busy[mode_index]), .done(done[mode_index])
        );
    end

    always @(posedge clk) if (resetn && collecting) begin
        for (int mode_index = 0; mode_index < 4; mode_index++) begin
            if (write_valid[mode_index]) begin
                if (done_seen[mode_index] || writes[mode_index] >= 4096)
                    $fatal(1, "late or excessive write mode=%0d", mode_index);
                trace_address[mode_index][writes[mode_index]] = write_address[mode_index];
                trace_token[mode_index][writes[mode_index]] = write_token[mode_index];
                trace_cycle[mode_index][writes[mode_index]] = cycles;
                writes[mode_index]++;
            end
            if (write_second_valid[mode_index]) begin
                if (mode_index != 3 || write_address[mode_index][0] ||
                    done_seen[mode_index] || writes[mode_index] >= 4096)
                    $fatal(1, "invalid second lane mode=%0d", mode_index);
                trace_address[mode_index][writes[mode_index]] = write_address[mode_index] + 16'd1;
                trace_token[mode_index][writes[mode_index]] = write_second_token[mode_index];
                trace_cycle[mode_index][writes[mode_index]] = cycles;
                writes[mode_index]++;
            end
        end
        if (modes[3].dut.response_context.valid && modes[3].dut.response_context.pair_valid)
            pair_masks[{modes[3].dut.response_second_index != 0, modes[3].dut.response_index != 0}]++;
    end

    always @(negedge clk) if (resetn && collecting) begin
        for (int mode_index = 0; mode_index < 4; mode_index++) begin
            if (done[mode_index] && !done_seen[mode_index]) begin
                if (busy[mode_index] || write_valid[mode_index] || write_second_valid[mode_index])
                    $fatal(1, "completion before drain mode=%0d", mode_index);
                done_seen[mode_index] = 1'b1;
                done_cycle[mode_index] = cycles - start_cycle;
            end
        end
    end

    task automatic configure_default;
        asset_valid = 1'b1; palette_bank = 4'hA;
        dst_x = 0; dst_y = 0;
        width = 7; height = 3; src_x = 1; src_y = 1;
        asset_width = 9; asset_height = 5; asset_stride_bytes = 5;
        flip_x = 0; flip_y = 0;
    endtask

    task automatic fill_opaque;
        for (int byte_index = 0; byte_index < 32768; byte_index++)
            asset_bytes[byte_index] = ((byte_index % 15 + 1) << 4) | ((byte_index * 7) % 15 + 1);
    endtask

    task automatic check_oracle(input string label);
        int expected_writes, target_x, target_y, source_column, source_row;
        int byte_address, pixel_index, expected_address, expected_token;
        expected_writes = 0;
        if (asset_valid && width != 0 && height != 0 &&
            int'(src_x) + int'(width) <= int'(asset_width) &&
            int'(src_y) + int'(height) <= int'(asset_height)) begin
            for (int row_index = 0; row_index < height; row_index++) begin
                for (int column_index = 0; column_index < width; column_index++) begin
                    target_x = int'(dst_x) + column_index;
                    target_y = int'(dst_y) + row_index;
                    source_column = int'(src_x) + (flip_x ? int'(width) - 1 - column_index : column_index);
                    source_row = int'(src_y) + (flip_y ? int'(height) - 1 - row_index : row_index);
                    byte_address = source_row * int'(asset_stride_bytes) + source_column / 2;
                    pixel_index = (asset_bytes[byte_address] >> ((source_column % 2) * 4)) & 15;
                    if (pixel_index != 0 && target_x >= 0 && target_x < 320 && target_y >= 0 && target_y < 180) begin
                        expected_address = target_y * 320 + target_x;
                        expected_token = int'(palette_bank) * 16 + pixel_index;
                        for (int mode_index = 0; mode_index < 4; mode_index++) begin
                            if (expected_writes >= writes[mode_index] ||
                                trace_address[mode_index][expected_writes] !== expected_address[15:0] ||
                                trace_token[mode_index][expected_writes] !== expected_token[7:0])
                                $fatal(1, "%s oracle mode=%0d write=%0d expected=%0d:%02x actual=%0d:%02x",
                                    label, mode_index, expected_writes, expected_address, expected_token,
                                    trace_address[mode_index][expected_writes], trace_token[mode_index][expected_writes]);
                        end
                        expected_writes++;
                    end
                end
            end
        end
        if (writes[0] != expected_writes || writes[1] != expected_writes ||
            writes[2] != expected_writes || writes[3] != expected_writes)
            $fatal(1, "%s count mismatch expected=%0d off=%0d on=%0d", label, expected_writes, writes[0], writes[1]);
        if (label == "original") begin
            if (writes[0] != 8) $fatal(1, "original golden count mismatch");
            for (int mode_index = 0; mode_index < 4; mode_index++) begin
                for (int write_index = 0; write_index < 8; write_index++) begin
                    case (write_index)
                        0: begin expected_address = 0; expected_token = 'hA3; end
                        1: begin expected_address = 1; expected_token = 'hA2; end
                        2: begin expected_address = 2; expected_token = 'hA1; end
                        3: begin expected_address = 320; expected_token = 'hA7; end
                        4: begin expected_address = 322; expected_token = 'hA6; end
                        5: begin expected_address = 640; expected_token = 'hA2; end
                        6: begin expected_address = 641; expected_token = 'hA1; end
                        7: begin expected_address = 642; expected_token = 'hA1; end
                    endcase
                    if (trace_address[mode_index][write_index] != expected_address ||
                        trace_token[mode_index][write_index] != expected_token)
                        $fatal(1, "original golden mismatch mode=%0d write=%0d", mode_index, write_index);
                end
            end
        end
        if (label == "long_opaque") begin
            if (writes[1] != 256) $fatal(1, "long opaque count mismatch");
            for (int write_index = 1; write_index < writes[1]; write_index++)
                if (trace_cycle[1][write_index] - trace_cycle[1][write_index - 1] != 1)
                    $fatal(1, "pipeline write II mismatch write=%0d", write_index);
        end
        if (label == "pair_long_opaque") begin
            if (writes[3] != 256 || done_cycle[3] >= done_cycle[1])
                $fatal(1, "pair throughput did not improve");
            for (int write_index = 1; write_index < writes[3]; write_index++)
                if (trace_cycle[3][write_index] - trace_cycle[3][write_index - 1] != (write_index % 2 == 1 ? 0 : 1))
                    $fatal(1, "pair throughput gap write=%0d", write_index);
        end
    endtask

    task automatic run_case(input string label, input bit inject_start = 0);
        logic [3:0] saved_palette;
        logic signed [15:0] saved_dst_x;
        @(negedge clk);
        for (int mode_index = 0; mode_index < 4; mode_index++) writes[mode_index] = 0;
        done_seen = 0;
        start_cycle = cycles; collecting = 1; start = 1;
        @(negedge clk); start = 0;
        if (inject_start) begin
            repeat (3) @(negedge clk);
            if (busy != 4'b1111) $fatal(1, "busy-start stimulus too late");
            saved_palette = palette_bank; saved_dst_x = dst_x;
            palette_bank = 4'hE; dst_x = -27; start = 1;
            @(negedge clk);
            start = 0; palette_bank = saved_palette; dst_x = saved_dst_x;
        end
        wait (&done_seen);
        @(negedge clk);
        check_oracle(label);
        if (done_cycle[1] > done_cycle[0]) $fatal(1, "%s pipeline slower", label);
        if (done_cycle[2] != done_cycle[0] || done_cycle[3] > done_cycle[1])
            $fatal(1, "%s pair fallback or latency mismatch", label);
        $display("BLIT_CASE=PASS name=%s off=%0d on=%0d writes=%0d", label, done_cycle[0], done_cycle[1], writes[0]);
        cases++;
        repeat (3) @(negedge clk);
        if (busy != 0 || write_valid != 0 || write_second_valid != 0) $fatal(1, "%s residual output", label);
        collecting = 0;
    endtask

    initial begin
        fill_opaque();
        asset_bytes[0] = 'h21; asset_bytes[1] = 'h43; asset_bytes[2] = 'h05;
        asset_bytes[3] = 'h06; asset_bytes[4] = 'h87; asset_bytes[5] = 'h09;
        asset_bytes[6] = 'h11; asset_bytes[7] = 'h22; asset_bytes[8] = 'h03;
        repeat (3) @(negedge clk); resetn = 1;
        dst_x = -2; flip_x = 1; run_case("original");
        fill_opaque();
        for (int flip_index = 0; flip_index < 4; flip_index++) begin
            configure_default(); flip_x = flip_index[0]; flip_y = flip_index[1];
            run_case($sformatf("odd_source_flip_%0d", flip_index));
        end
        configure_default(); asset_stride_bytes = 7; run_case("padded_stride_module_only");
        configure_default(); dst_x = -3; dst_y = -1; run_case("negative_xy");
        configure_default(); dst_x = 318; dst_y = 179; run_case("right_bottom_clip");
        configure_default(); dst_x = 321; run_case("fully_clipped");
        for (int byte_index = 0; byte_index < 32768; byte_index++) asset_bytes[byte_index] = 0;
        configure_default(); run_case("all_transparent");
        fill_opaque();
        configure_default(); asset_bytes[18] = 0; run_case("last_transparent");
        configure_default(); width = 1; height = 1; run_case("single_opaque");
        configure_default(); width = 1; height = 1; asset_bytes[5] = 0; run_case("single_transparent");
        fill_opaque();
        configure_default(); width = 0; run_case("zero_width");
        configure_default(); height = 0; run_case("zero_height");
        configure_default(); asset_valid = 0; run_case("missing_asset");
        configure_default(); src_x = 8; run_case("source_x_out_of_bounds");
        configure_default(); src_y = 4; run_case("source_y_out_of_bounds");
        configure_default(); run_case("busy_start_ignored", 1);
        configure_default(); src_x = 0; src_y = 0; width = 1; height = 1;
        asset_bytes[0] = 'hF1; run_case("same_address_asset_before");
        asset_bytes[0] = 'hE2; run_case("same_address_asset_after");
        palette_bank = 4'h4; run_case("new_palette");
        fill_opaque();
        configure_default(); width = 64; height = 4; src_x = 1; src_y = 0;
        asset_width = 65; asset_height = 4; asset_stride_bytes = 33;
        run_case("long_opaque");
        if (TEST_BLIT_PAIR_CASES) begin
            configure_default(); src_x = 0; src_y = 0; width = 8; height = 1;
            asset_width = 8; asset_height = 1; asset_stride_bytes = 4;
            asset_bytes[0] = 'h00; asset_bytes[1] = 'h03;
            asset_bytes[2] = 'hA0; asset_bytes[3] = 'hA3;
            run_case("four_pair_masks");
            flip_x = 1; run_case("four_pair_masks_flip_x");
            fill_opaque();
            configure_default(); src_x = 0; src_y = 0; width = 64; height = 4;
            asset_width = 64; asset_height = 4; asset_stride_bytes = 32;
            run_case("pair_long_opaque");
            dst_x = 1; run_case("odd_destination_single_fallback");
            for (int mask_index = 0; mask_index < 4; mask_index++)
                if (!pair_masks[mask_index]) $fatal(1, "pair mask missing %0d", mask_index);
            $display("BLIT_PAIR_MASKS=PASS counts=%0d,%0d,%0d,%0d", pair_masks[0], pair_masks[1], pair_masks[2], pair_masks[3]);
        end
        @(negedge clk); start = 1;
        @(negedge clk); start = 0;
        repeat (5) @(negedge clk); resetn = 0;
        @(posedge clk); #1ns;
        if (busy != 0 || write_valid != 0 || write_second_valid != 0 || done != 0) $fatal(1, "reset did not clear outputs");
        @(negedge clk); resetn = 1;
        repeat (4) @(negedge clk);
        if (busy != 0 || write_valid != 0 || write_second_valid != 0 || done != 0) $fatal(1, "reset left stale response");
        configure_default(); run_case("after_reset");
        $display("SCENE2D_INDEX4_ASSET_BLIT=PASS cases=%0d pipeline_II=1", cases);
        if (TEST_BLIT_PAIR_CASES) $display("SCENE2D_BLIT_PAIR=PASS cases=%0d pixels_per_clock=2", cases);
        $finish;
    end

    initial begin
        #2ms;
        $fatal(1, "asset blit watchdog expired");
    end

endmodule