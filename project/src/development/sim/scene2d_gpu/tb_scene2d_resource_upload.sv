module tb_scene2d_resource_upload;

    timeunit 1ns;
    timeprecision 1ps;

    localparam logic [31:0] MAGIC = 32'h50443253;
    localparam logic [31:0] PACKET_TYPE = 32'd3;
    localparam int CORRUPT_NONE = 0;
    localparam int CORRUPT_MAGIC = 1;
    localparam int CORRUPT_ABI = 2;
    localparam int CORRUPT_ROUTE = 3;
    localparam int CORRUPT_RESERVED = 4;
    localparam int CORRUPT_SIZE = 5;
    localparam int CORRUPT_CRC = 6;
    localparam int CORRUPT_TKEEP = 7;
    localparam int CORRUPT_SHORT = 8;
    localparam int CORRUPT_LONG = 9;

    logic clk = 1'b0;
    logic resetn = 1'b0;
    logic [63:0] s_tdata = '0;
    logic [7:0] s_tkeep = '0;
    logic s_tlast = 1'b0;
    logic s_tvalid = 1'b0;
    logic s_tready;
    logic [31:0] payload_word_data;
    logic [3:0] payload_word_keep;
    logic [31:0] payload_word_index;
    logic payload_word_valid;
    logic payload_word_ready = 1'b1;
    logic packet_done;
    logic packet_valid;
    logic [31:0] completed_generation;
    logic [31:0] completed_crc32;
    logic [31:0] completed_payload_byte_count;
    logic [7:0] completed_error_flags;
    logic [31:0] observed_words [0:63];
    int observed_count = 0;

    always #5ns clk = ~clk;

    scene2d_resource_upload #(
        .EXPECTED_MAGIC(MAGIC),
        .EXPECTED_TYPE(PACKET_TYPE),
        .EXPECTED_TARGET_ID(0),
        .EXPECTED_PAYLOAD_BYTES(16)
    ) dut (
        .aclk(clk),
        .aresetn(resetn),
        .s_axis_tdata(s_tdata),
        .s_axis_tkeep(s_tkeep),
        .s_axis_tlast(s_tlast),
        .s_axis_tvalid(s_tvalid),
        .s_axis_tready(s_tready),
        .payload_word_data,
        .payload_word_keep,
        .payload_word_index,
        .payload_word_valid,
        .payload_word_ready,
        .packet_done,
        .packet_valid,
        .completed_generation,
        .completed_crc32,
        .completed_payload_byte_count,
        .completed_error_flags
    );

    function automatic logic [31:0] payload_word(input int index);
        case (index)
            0: return 32'h00112233;
            1: return 32'h50443253;
            2: return 32'h00A5C35A;
            default: return 32'h00FEDCBA;
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
        begin
            crc = 32'hFFFFFFFF;
            for (int word_index = 0; word_index < 4; word_index = word_index + 1) begin
                word_data = payload_word(word_index);
                for (int byte_index = 0; byte_index < 4; byte_index = byte_index + 1) begin
                    crc = crc32_byte(crc, word_data[byte_index * 8 +: 8]);
                end
            end
            return ~crc;
        end
    endfunction

    function automatic logic [63:0] packet_beat(
        input int beat,
        input int corruption
    );
        logic [31:0] low_word;
        logic [31:0] high_word;
        begin
            low_word = '0;
            high_word = '0;
            case (beat)
                0: begin
                    low_word = corruption == CORRUPT_MAGIC ? 32'hDEADBEEF : MAGIC;
                    high_word = corruption == CORRUPT_ABI ? 32'h00020000 : 32'h00010000;
                end
                1: begin
                    low_word = corruption == CORRUPT_ROUTE ? 32'd4 : PACKET_TYPE;
                    high_word = 32'd0;
                end
                2: begin
                    low_word = 32'h12345678;
                    high_word = corruption == CORRUPT_SIZE ? 32'd12 : 32'd16;
                end
                3: begin
                    low_word = corruption == CORRUPT_CRC
                        ? payload_crc32() ^ 32'h1
                        : payload_crc32();
                    high_word = 32'd0;
                end
                4: begin
                    low_word = corruption == CORRUPT_RESERVED ? 32'd1 : 32'd0;
                    high_word = 32'd0;
                end
                8: begin
                    low_word = payload_word(0);
                    high_word = payload_word(1);
                end
                9: begin
                    low_word = payload_word(2);
                    high_word = payload_word(3);
                end
                default: begin
                    if (beat > 9) begin
                        low_word = 32'hAAAAAAAA;
                        high_word = 32'h55555555;
                    end
                end
            endcase
            return {high_word, low_word};
        end
    endfunction

    always @(posedge clk) begin
        if (payload_word_valid && payload_word_ready) begin
            if (payload_word_index !== observed_count) begin
                $fatal(
                    1,
                    "payload index=%0d expected=%0d",
                    payload_word_index,
                    observed_count
                );
            end
            observed_words[observed_count] <= payload_word_data;
            observed_count <= observed_count + 1;
        end
    end

    task automatic send_packet(input int corruption);
        int final_beat;
        begin
            final_beat = corruption == CORRUPT_SHORT ? 8 : 9;
            if (corruption == CORRUPT_LONG) begin
                final_beat = 10;
            end
            for (int beat = 0; beat <= final_beat; beat = beat + 1) begin
                @(negedge clk);
                s_tdata = packet_beat(beat, corruption);
                s_tkeep = corruption == CORRUPT_TKEEP && beat == final_beat
                    ? 8'h0F
                    : 8'hFF;
                s_tlast = beat == final_beat;
                s_tvalid = 1'b1;
                do @(posedge clk); while (!s_tready);
            end
            @(negedge clk);
            s_tvalid = 1'b0;
            s_tlast = 1'b0;
            s_tkeep = '0;
            s_tdata = '0;
            wait (packet_done);
            @(posedge clk);
        end
    endtask

    task automatic expect_rejected(
        input int corruption,
        input logic [7:0] expected_error
    );
        begin
            observed_count = 0;
            send_packet(corruption);
            if (packet_valid || (completed_error_flags & expected_error) == 0) begin
                $fatal(
                    1,
                    "corruption=%0d valid=%0d errors=%02x expected mask=%02x",
                    corruption,
                    packet_valid,
                    completed_error_flags,
                    expected_error
                );
            end
        end
    endtask

    initial begin
        repeat (5) @(posedge clk);
        @(negedge clk);
        resetn = 1'b1;

        send_packet(CORRUPT_NONE);
        if (
            !packet_valid || completed_error_flags != 0 ||
            completed_generation != 32'h12345678 ||
            completed_payload_byte_count != 16 ||
            completed_crc32 != payload_crc32() || observed_count != 4
        ) begin
            $fatal(1, "valid packet completion mismatch");
        end
        for (int index = 0; index < 4; index = index + 1) begin
            if (observed_words[index] != payload_word(index)) begin
                $fatal(1, "payload[%0d]=%08x", index, observed_words[index]);
            end
        end

        observed_count = 0;
        @(negedge clk);
        payload_word_ready = 1'b0;
        fork
            send_packet(CORRUPT_NONE);
            begin
                repeat (8) @(posedge clk);
                @(negedge clk);
                payload_word_ready = 1'b1;
            end
        join
        if (!packet_valid || observed_count != 4) begin
            $fatal(1, "backpressure packet mismatch");
        end

        expect_rejected(CORRUPT_MAGIC, 8'h01);
        expect_rejected(CORRUPT_ABI, 8'h02);
        expect_rejected(CORRUPT_ROUTE, 8'h04);
        expect_rejected(CORRUPT_RESERVED, 8'h08);
        expect_rejected(CORRUPT_SIZE, 8'h10);
        expect_rejected(CORRUPT_CRC, 8'h40);
        expect_rejected(CORRUPT_TKEEP, 8'h20);
        expect_rejected(CORRUPT_SHORT, 8'h10);
        expect_rejected(CORRUPT_LONG, 8'h10);

        $display(
            "SCENE2D_RESOURCE_UPLOAD=PASS crc=%08x generation=%08x",
            completed_crc32,
            completed_generation
        );
        $finish;
    end

endmodule