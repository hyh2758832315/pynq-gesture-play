module tb_scene2d_asset_store;

    timeunit 1ns;
    timeprecision 1ps;

    localparam logic [31:0] ASSET_MAGIC = 32'h41443253;
    localparam logic [31:0] ASSET_TYPE = 32'd1;
    localparam logic [31:0] PAYLOAD_BYTES = 32'd22;

    logic clk = 1'b0;
    logic resetn = 1'b0;
    logic renderer_idle = 1'b0;
    logic [63:0] s_tdata = '0;
    logic [7:0] s_tkeep = '0;
    logic s_tlast = 1'b0;
    logic s_tvalid = 1'b0;
    logic s_tready;
    logic [14:0] read_byte_address = '0;
    logic [7:0] read_byte;
    logic [31:0] accepted_packet_count;
    logic [31:0] rejected_packet_count;
    logic [31:0] committed_generation;
    logic [8:0] sticky_error_flags;
    logic asset_valid;
    logic commit_pending;
    logic active_bank;
    logic write_bank;
    logic [15:0] asset_width;
    logic [15:0] asset_height;
    logic [15:0] asset_stride_bytes;

    always #5ns clk = ~clk;

    scene2d_asset_store dut (
        .aclk(clk),
        .aresetn(resetn),
        .renderer_idle,
        .s_axis_tdata(s_tdata),
        .s_axis_tkeep(s_tkeep),
        .s_axis_tlast(s_tlast),
        .s_axis_tvalid(s_tvalid),
        .s_axis_tready(s_tready),
        .read_byte_address,
        .read_byte,
        .accepted_packet_count,
        .rejected_packet_count,
        .committed_generation,
        .sticky_error_flags,
        .asset_valid,
        .commit_pending,
        .active_bank,
        .write_bank,
        .asset_width,
        .asset_height,
        .asset_stride_bytes
    );

    function automatic logic [31:0] payload_word(input int index);
        case (index)
            0: return 32'd0;
            1: return 32'h00030003;
            2: return 32'hDE010002;
            3: return 32'd6;
            4: return 32'h4321A210;
            5: return 32'h00006554;
            default: return '0;
        endcase
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

    function automatic logic [31:0] payload_crc32;
        logic [31:0] crc;
        logic [31:0] word_data;
        int byte_limit;
        begin
            crc = 32'hFFFFFFFF;
            for (int word_index = 0; word_index < 6; word_index = word_index + 1) begin
                word_data = payload_word(word_index);
                byte_limit = word_index == 5 ? 2 : 4;
                for (int byte_index = 0; byte_index < byte_limit; byte_index = byte_index + 1) begin
                    crc = crc32_byte(crc, word_data[byte_index * 8 +: 8]);
                end
            end
            return ~crc;
        end
    endfunction

    function automatic logic [63:0] packet_beat(
        input int beat,
        input logic corrupt_crc
    );
        logic [31:0] low_word;
        logic [31:0] high_word;
        begin
            low_word = '0;
            high_word = '0;
            case (beat)
                0: begin
                    low_word = ASSET_MAGIC;
                    high_word = 32'h00010000;
                end
                1: begin
                    low_word = ASSET_TYPE;
                    high_word = 32'd0;
                end
                2: begin
                    low_word = 32'h001234DE;
                    high_word = PAYLOAD_BYTES;
                end
                3: begin
                    low_word = payload_crc32() ^ (corrupt_crc ? 32'h1 : 32'd0);
                    high_word = '0;
                end
                8: begin
                    low_word = payload_word(0);
                    high_word = payload_word(1);
                end
                9: begin
                    low_word = payload_word(2);
                    high_word = payload_word(3);
                end
                10: begin
                    low_word = payload_word(4);
                    high_word = payload_word(5);
                end
                default: begin
                end
            endcase
            return {high_word, low_word};
        end
    endfunction

    task automatic send_packet(input logic corrupt_crc);
        begin
            for (int beat = 0; beat <= 10; beat = beat + 1) begin
                @(negedge clk);
                s_tdata = packet_beat(beat, corrupt_crc);
                s_tkeep = beat == 10 ? 8'h3F : 8'hFF;
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

    task automatic expect_byte(input logic [14:0] address, input logic [7:0] expected);
        begin
            @(negedge clk);
            read_byte_address = address;
            repeat (2) @(posedge clk);
            #1ps;
            if (read_byte != expected) begin
                $fatal(1, "asset byte[%0d]=%02x expected=%02x", address, read_byte, expected);
            end
        end
    endtask

    initial begin
        repeat (5) @(posedge clk);
        @(negedge clk);
        resetn = 1'b1;

        send_packet(1'b0);
        repeat (3) @(posedge clk);
        if (
            accepted_packet_count != 1 || rejected_packet_count != 0 ||
            !commit_pending || asset_valid || active_bank != 0 || write_bank != 1
        ) begin
            $fatal(1, "asset commit was not staged correctly");
        end

        @(negedge clk);
        renderer_idle = 1'b1;
        @(posedge clk);
        @(negedge clk);
        renderer_idle = 1'b0;
        if (
            !asset_valid || commit_pending || active_bank != 1 || write_bank != 0 ||
            committed_generation != 32'h001234DE ||
            asset_width != 3 || asset_height != 3 || asset_stride_bytes != 2
        ) begin
            $fatal(1, "asset commit metadata mismatch");
        end
        expect_byte(0, 8'h10);
        expect_byte(1, 8'hA2);
        expect_byte(2, 8'h21);
        expect_byte(3, 8'h43);
        expect_byte(4, 8'h54);
        expect_byte(5, 8'h65);

        send_packet(1'b1);
        repeat (3) @(posedge clk);
        if (
            accepted_packet_count != 1 || rejected_packet_count != 1 ||
            committed_generation != 32'h001234DE || active_bank != 1 ||
            !asset_valid || sticky_error_flags[6] != 1'b1
        ) begin
            $fatal(
                1,
                "bad CRC state accepted=%0d rejected=%0d generation=%08x bank=%0d valid=%0d flags=%03x",
                accepted_packet_count,
                rejected_packet_count,
                committed_generation,
                active_bank,
                asset_valid,
                sticky_error_flags
            );
        end
        expect_byte(0, 8'h10);

        $display(
            "SCENE2D_ASSET_STORE=PASS accepted=%0d rejected=%0d generation=%08x",
            accepted_packet_count,
            rejected_packet_count,
            committed_generation
        );
        $finish;
    end

endmodule
