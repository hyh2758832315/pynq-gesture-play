module tb_scene2d_palette_store;

    timeunit 1ns;
    timeprecision 1ps;

    logic clk = 1'b0;
    logic resetn = 1'b0;
    logic pixel_clk = 1'b0;
    logic pixel_resetn = 1'b0;
    logic vblank_start = 1'b0;
    logic [63:0] tdata = '0;
    logic [7:0] tkeep = '0;
    logic tlast = 1'b0;
    logic tvalid = 1'b0;
    logic tready;
    logic [7:0] read_address = '0;
    logic [23:0] read_rgb;
    logic [31:0] accepted_packet_count;
    logic [31:0] rejected_packet_count;
    logic [31:0] committed_generation;
    logic [8:0] sticky_error_flags;
    logic palette_valid;
    logic commit_pending;
    logic active_bank;
    logic write_bank;

    always #5ns clk = ~clk;
    always #7ns pixel_clk = ~pixel_clk;

    scene2d_palette_store dut (
        .aclk(clk),
        .aresetn(resetn),
        .clk_pixel(pixel_clk),
        .resetn_pixel(pixel_resetn),
        .vblank_start,
        .s_axis_tdata(tdata),
        .s_axis_tkeep(tkeep),
        .s_axis_tlast(tlast),
        .s_axis_tvalid(tvalid),
        .s_axis_tready(tready),
        .read_address,
        .read_rgb,
        .accepted_packet_count,
        .rejected_packet_count,
        .committed_generation,
        .sticky_error_flags,
        .palette_valid,
        .commit_pending,
        .active_bank,
        .write_bank
    );

    function automatic logic [31:0] palette_word(
        input int seed,
        input int index,
        input bit invalid_word
    );
        logic [7:0] red;
        logic [7:0] green;
        logic [7:0] blue;
        begin
            red = seed + index;
            green = seed ^ index;
            blue = seed * 3 + index * 5;
            return {
                invalid_word && index == 17 ? 8'hA5 : 8'h00,
                red,
                green,
                blue
            };
        end
    endfunction

    function automatic logic [31:0] crc32_byte(
        input logic [31:0] crc,
        input logic [7:0] data
    );
        logic [31:0] next_crc;
        begin
            next_crc = crc ^ data;
            for (int bit_index = 0; bit_index < 8; bit_index = bit_index + 1) begin
                next_crc = next_crc[0]
                    ? (next_crc >> 1) ^ 32'hEDB88320
                    : next_crc >> 1;
            end
            return next_crc;
        end
    endfunction

    function automatic logic [31:0] palette_crc32(
        input int seed,
        input bit invalid_word
    );
        logic [31:0] crc;
        logic [31:0] word_data;
        begin
            crc = 32'hFFFFFFFF;
            for (int index = 0; index < 256; index = index + 1) begin
                word_data = palette_word(seed, index, invalid_word);
                for (int byte_index = 0; byte_index < 4; byte_index = byte_index + 1) begin
                    crc = crc32_byte(crc, word_data[byte_index * 8 +: 8]);
                end
            end
            return ~crc;
        end
    endfunction

    function automatic logic [63:0] packet_beat(
        input int beat,
        input int seed,
        input logic [31:0] generation,
        input bit corrupt_crc,
        input bit invalid_word
    );
        logic [31:0] low_word;
        logic [31:0] high_word;
        int payload_index;
        begin
            low_word = '0;
            high_word = '0;
            case (beat)
                0: begin
                    low_word = 32'h50443253;
                    high_word = 32'h00010000;
                end
                1: begin
                    low_word = 32'd3;
                    high_word = 32'd0;
                end
                2: begin
                    low_word = generation;
                    high_word = 32'd1024;
                end
                3: begin
                    low_word = corrupt_crc
                        ? palette_crc32(seed, invalid_word) ^ 32'h1
                        : palette_crc32(seed, invalid_word);
                    high_word = 32'd0;
                end
                default: begin
                    if (beat >= 8) begin
                        payload_index = (beat - 8) * 2;
                        low_word = palette_word(seed, payload_index, invalid_word);
                        high_word = palette_word(seed, payload_index + 1, invalid_word);
                    end
                end
            endcase
            return {high_word, low_word};
        end
    endfunction

    task automatic send_palette(
        input int seed,
        input logic [31:0] generation,
        input bit corrupt_crc,
        input bit invalid_word
    );
        begin
            for (int beat = 0; beat < 136; beat = beat + 1) begin
                @(negedge clk);
                tdata = packet_beat(
                    beat,
                    seed,
                    generation,
                    corrupt_crc,
                    invalid_word
                );
                tkeep = 8'hFF;
                tlast = beat == 135;
                tvalid = 1'b1;
                do @(posedge clk); while (!tready);
            end
            @(negedge clk);
            tvalid = 1'b0;
            tlast = 1'b0;
            tkeep = '0;
            tdata = '0;
        end
    endtask

    task automatic pulse_vblank;
        begin
            @(negedge pixel_clk);
            vblank_start = 1'b1;
            @(negedge pixel_clk);
            vblank_start = 1'b0;
        end
    endtask

    task automatic expect_palette(input int seed);
        begin
            for (int index = 0; index < 256; index = index + 1) begin
                @(negedge pixel_clk);
                read_address = index[7:0];
                @(posedge pixel_clk);
                #1ps;
                if (read_rgb != palette_word(seed, index, 1'b0)[23:0]) begin
                    $fatal(
                        1,
                        "palette[%0d]=%06x expected=%06x",
                        index,
                        read_rgb,
                        palette_word(seed, index, 1'b0)[23:0]
                    );
                end
            end
        end
    endtask

    initial begin
        repeat (5) @(posedge clk);
        resetn = 1'b1;
        repeat (5) @(posedge pixel_clk);
        pixel_resetn = 1'b1;

        send_palette(3, 32'h00000011, 1'b0, 1'b0);
        wait (commit_pending);
        if (palette_valid || committed_generation != 0 || active_bank != 0 || tready) begin
            $fatal(1, "palette committed before vblank");
        end
        repeat (4) @(posedge pixel_clk);
        if (active_bank != 0) begin
            $fatal(1, "active palette changed without vblank");
        end
        pulse_vblank();
        wait (!commit_pending);
        if (
            !palette_valid || committed_generation != 32'h00000011 ||
            accepted_packet_count != 1 || active_bank != 1 || write_bank != 0
        ) begin
            $fatal(1, "first palette commit mismatch");
        end
        expect_palette(3);

        send_palette(7, 32'h00000022, 1'b1, 1'b0);
        wait (rejected_packet_count == 1);
        if (
            commit_pending || committed_generation != 32'h00000011 ||
            active_bank != 1 || sticky_error_flags[6] != 1'b1
        ) begin
            $fatal(1, "bad CRC changed committed palette");
        end
        expect_palette(3);

        send_palette(9, 32'h00000033, 1'b0, 1'b1);
        wait (rejected_packet_count == 2);
        if (
            commit_pending || committed_generation != 32'h00000011 ||
            active_bank != 1 || sticky_error_flags[8] != 1'b1
        ) begin
            $fatal(1, "invalid RGB word changed committed palette");
        end

        send_palette(12, 32'h00000044, 1'b0, 1'b0);
        wait (commit_pending);
        expect_palette(3);
        pulse_vblank();
        wait (!commit_pending);
        if (
            committed_generation != 32'h00000044 ||
            accepted_packet_count != 2 || active_bank != 0 || write_bank != 1
        ) begin
            $fatal(1, "second palette commit mismatch");
        end
        expect_palette(12);

        $display(
            "SCENE2D_PALETTE_STORE=PASS accepted=%0d rejected=%0d generation=%08x",
            accepted_packet_count,
            rejected_packet_count,
            committed_generation
        );
        $finish;
    end

endmodule