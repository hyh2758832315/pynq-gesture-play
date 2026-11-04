module tb_scene2d_tilemap_store;

    timeunit 1ns;
    timeprecision 1ps;

    logic clk = 1'b0;
    logic resetn = 1'b0;
    logic renderer_idle = 1'b0;
    logic [63:0] s_tdata = '0;
    logic [7:0] s_tkeep = '0;
    logic s_tlast = 1'b0;
    logic s_tvalid = 1'b0;
    logic s_tready;
    logic [1:0] read_tilemap_id = '0;
    logic [9:0] read_word_address = '0;
    logic [31:0] read_word_data;
    logic read_tilemap_valid;
    logic [15:0] read_width_tiles;
    logic [15:0] read_height_tiles;
    logic signed [31:0] read_origin_x;
    logic signed [31:0] read_origin_y;
    logic [15:0] read_tile_size;
    logic [31:0] read_generation;
    logic [31:0] accepted_packet_count;
    logic [31:0] rejected_packet_count;
    logic [31:0] committed_generation;
    logic [8:0] sticky_error_flags;
    logic [3:0] tilemap_valid;
    logic [3:0] commit_pending;
    logic [3:0] active_bank;
    logic [3:0] write_bank;

    always #5ns clk = ~clk;

    scene2d_tilemap_store dut (
        .aclk(clk), .aresetn(resetn), .renderer_idle,
        .s_axis_tdata(s_tdata), .s_axis_tkeep(s_tkeep), .s_axis_tlast(s_tlast),
        .s_axis_tvalid(s_tvalid), .s_axis_tready(s_tready),
        .read_tilemap_id, .read_word_address, .read_word_data, .read_tilemap_valid,
        .read_width_tiles, .read_height_tiles, .read_origin_x, .read_origin_y,
        .read_tile_size, .read_generation, .accepted_packet_count,
        .rejected_packet_count, .committed_generation, .sticky_error_flags,
        .tilemap_valid, .commit_pending, .active_bank, .write_bank
    );

    function automatic logic [31:0] crc32_byte(
        input logic [31:0] crc, input logic [7:0] data
    );
        logic [31:0] next_crc;
        begin
            next_crc = crc ^ data;
            for (int bit_index = 0; bit_index < 8; bit_index = bit_index + 1) begin
                next_crc = next_crc[0] ? (next_crc >> 1) ^ 32'hEDB88320 : next_crc >> 1;
            end
            return next_crc;
        end
    endfunction

    function automatic logic [31:0] payload_word(input int index);
        case (index)
            0: return 32'h00010002;
            1: return 32'hFFFFFFFC;
            2: return 32'd7;
            3: return 32'd16;
            4: return 32'h00100003;
            5: return 32'h00200004;
            default: return '0;
        endcase
    endfunction

    function automatic logic [31:0] payload_crc32;
        logic [31:0] crc;
        begin
            crc = 32'hFFFFFFFF;
            for (int word_index = 0; word_index < 6; word_index = word_index + 1) begin
                for (int byte_index = 0; byte_index < 4; byte_index = byte_index + 1) begin
                    crc = crc32_byte(crc, payload_word(word_index)[byte_index * 8 +: 8]);
                end
            end
            return ~crc;
        end
    endfunction

    task automatic send_tilemap(input logic corrupt_crc);
        logic [31:0] low_word;
        logic [31:0] high_word;
        begin
            for (int beat = 0; beat < 11; beat = beat + 1) begin
                low_word = '0;
                high_word = '0;
                case (beat)
                    0: begin low_word = 32'h54443253; high_word = 32'h00010000; end
                    1: begin low_word = 32'd2; high_word = 32'd0; end
                    2: begin low_word = 32'h00123456; high_word = 32'd24; end
                    3: begin low_word = payload_crc32() ^ (corrupt_crc ? 32'h1 : 0); end
                    8, 9, 10: begin
                        low_word = payload_word((beat - 8) * 2);
                        high_word = payload_word((beat - 8) * 2 + 1);
                    end
                    default: begin end
                endcase
                @(negedge clk);
                s_tdata = {high_word, low_word};
                s_tkeep = 8'hFF;
                s_tlast = beat == 10;
                s_tvalid = 1'b1;
                do @(posedge clk); while (!s_tready);
            end
            @(negedge clk);
            s_tvalid = 1'b0;
            s_tlast = 1'b0;
            s_tkeep = '0;
            s_tdata = '0;
        end
    endtask

    task automatic expect_word(input logic [9:0] address, input logic [31:0] expected);
        begin
            @(negedge clk);
            read_word_address = address;
            repeat (2) @(posedge clk);
            #1ps;
            if (read_word_data != expected) begin
                $fatal(1, "tilemap readback mismatch address=%0d", address);
            end
        end
    endtask

    initial begin
        repeat (5) @(posedge clk);
        @(negedge clk);
        resetn = 1'b1;

        send_tilemap(1'b0);
        repeat (3) @(posedge clk);
        if (accepted_packet_count != 1 || !commit_pending[0] || tilemap_valid[0]) begin
            $fatal(1, "tilemap was not staged");
        end
        @(negedge clk);
        renderer_idle = 1'b1;
        @(posedge clk);
        @(negedge clk);
        renderer_idle = 1'b0;
        if (!tilemap_valid[0] || commit_pending[0] || committed_generation != 32'h00123456 ||
            !read_tilemap_valid || read_width_tiles != 2 || read_height_tiles != 1 ||
            read_origin_x != -4 || read_origin_y != 7 || read_tile_size != 16 ||
            read_generation != 32'h00123456) begin
            $fatal(1, "tilemap commit metadata mismatch");
        end
        expect_word(10'd4, 32'h00100003);
        expect_word(10'd5, 32'h00200004);

        send_tilemap(1'b1);
        repeat (3) @(posedge clk);
        if (accepted_packet_count != 1 || rejected_packet_count != 1 ||
            committed_generation != 32'h00123456 || sticky_error_flags[6] != 1'b1) begin
            $fatal(1, "bad CRC changed active tilemap");
        end
        expect_word(10'd4, 32'h00100003);

        $display("SCENE2D_TILEMAP_STORE=PASS generation=%08x", committed_generation);
        $finish;
    end

endmodule