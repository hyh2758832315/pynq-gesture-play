module tb_scene2d_resource_upload_variable;

    timeunit 1ns;
    timeprecision 1ps;

    localparam logic [31:0] ASSET_MAGIC = 32'h41443253;
    localparam logic [31:0] ASSET_TYPE = 32'd1;
    localparam logic [31:0] PAYLOAD_BYTES = 32'd22;

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
    logic packet_done;
    logic packet_valid;
    logic [31:0] completed_generation;
    logic [31:0] completed_crc32;
    logic [31:0] completed_payload_byte_count;
    logic [7:0] completed_error_flags;
    logic [31:0] observed_words [0:5];
    logic [3:0] observed_keeps [0:5];
    int observed_count = 0;

    always #5ns clk = ~clk;

    scene2d_resource_upload #(
        .EXPECTED_MAGIC(ASSET_MAGIC),
        .EXPECTED_TYPE(ASSET_TYPE),
        .EXPECTED_TARGET_ID(0),
        .MAX_TARGET_ID(15),
        .EXPECTED_PAYLOAD_BYTES(0),
        .MIN_PAYLOAD_BYTES(20),
        .MAX_PAYLOAD_BYTES(64)
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
        .payload_word_ready(1'b1),
        .packet_done,
        .packet_valid,
        .completed_generation,
        .completed_crc32,
        .completed_payload_byte_count,
        .completed_error_flags
    );

    function automatic logic [31:0] payload_word(input int index);
        case (index)
            0: return 32'd0;
            1: return 32'h00030003;
            2: return 32'h12010002;
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
        input logic [31:0] target_id
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
                    high_word = target_id;
                end
                2: begin
                    low_word = 32'h00ABCDEF;
                    high_word = PAYLOAD_BYTES;
                end
                3: begin
                    low_word = payload_crc32();
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

    always @(posedge clk) begin
        if (payload_word_valid) begin
            if (payload_word_index !== observed_count) begin
                $fatal(1, "payload index=%0d expected=%0d", payload_word_index, observed_count);
            end
            observed_words[observed_count] <= payload_word_data;
            observed_keeps[observed_count] <= payload_word_keep;
            observed_count <= observed_count + 1;
        end
    end

    task automatic send_packet(
        input logic [31:0] target_id,
        input logic [7:0] final_keep
    );
        begin
            for (int beat = 0; beat <= 10; beat = beat + 1) begin
                @(negedge clk);
                s_tdata = packet_beat(beat, target_id);
                s_tkeep = beat == 10 ? final_keep : 8'hFF;
                s_tlast = beat == 10;
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

    initial begin
        repeat (5) @(posedge clk);
        @(negedge clk);
        resetn = 1'b1;

        send_packet(32'd3, 8'h3F);
        if (
            !packet_valid || completed_error_flags != 0 ||
            completed_generation != 32'h00ABCDEF ||
            completed_payload_byte_count != PAYLOAD_BYTES ||
            completed_crc32 != payload_crc32() || observed_count != 6
        ) begin
            $fatal(1, "valid variable packet completion mismatch");
        end
        for (int index = 0; index < 6; index = index + 1) begin
            if (
                observed_words[index] != payload_word(index) ||
                observed_keeps[index] != (index == 5 ? 4'h3 : 4'hF)
            ) begin
                $fatal(1, "payload[%0d] data=%08x keep=%x", index, observed_words[index], observed_keeps[index]);
            end
        end

        observed_count = 0;
        send_packet(32'd16, 8'h3F);
        if (packet_valid || (completed_error_flags & 8'h04) == 0) begin
            $fatal(1, "out-of-range target was accepted");
        end

        observed_count = 0;
        send_packet(32'd3, 8'h5F);
        if (packet_valid || (completed_error_flags & 8'h20) == 0) begin
            $fatal(1, "sparse final TKEEP was accepted");
        end

        $display(
            "SCENE2D_RESOURCE_UPLOAD_VARIABLE=PASS crc=%08x generation=%08x",
            payload_crc32(),
            completed_generation
        );
        $finish;
    end

endmodule
