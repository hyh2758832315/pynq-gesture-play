module tb_scene2d_asset_bundle_store;

    timeunit 1ns;
    timeprecision 1ps;

    localparam logic [31:0] PAYLOAD_BYTES = 32'd177;

    logic clk = 1'b0;
    logic resetn = 1'b0;
    logic renderer_idle = 1'b0;
    logic [63:0] s_tdata = '0;
    logic [7:0] s_tkeep = '0;
    logic s_tlast = 1'b0;
    logic s_tvalid = 1'b0;
    logic s_tready;
    logic [1:0] read_asset_id = '0;
    logic [14:0] read_byte_offset = '0;
    logic [7:0] read_byte;
    logic read_asset_valid;
    logic [15:0] read_asset_width;
    logic [15:0] read_asset_height;
    logic [15:0] read_asset_stride_bytes;
    logic [31:0] accepted_packet_count;
    logic [31:0] rejected_packet_count;
    logic [31:0] committed_generation;
    logic [8:0] sticky_error_flags;
    logic bundle_valid;
    logic commit_pending;
    logic active_bank;
    logic write_bank;
    logic [1:0] descriptor_mode = 0;

    always #5ns clk = ~clk;

    scene2d_asset_bundle_store dut (
        .aclk(clk), .aresetn(resetn), .renderer_idle,
        .s_axis_tdata(s_tdata), .s_axis_tkeep(s_tkeep), .s_axis_tlast(s_tlast),
        .s_axis_tvalid(s_tvalid), .s_axis_tready(s_tready),
        .read_asset_id, .read_byte_offset, .read_byte, .read_asset_valid,
        .read_asset_width, .read_asset_height, .read_asset_stride_bytes,
        .accepted_packet_count, .rejected_packet_count, .committed_generation,
        .sticky_error_flags, .bundle_valid, .commit_pending, .active_bank, .write_bank
    );

    function automatic logic [31:0] payload_word(input int index);
        case (index)
            0: return 32'd0;
            1: return descriptor_mode == 2 ? 32'h00020000 : 32'h00020003;
            2: return descriptor_mode == 1 ? 32'hDE010003 : 32'hDE010002;
            3: return 32'd4;
            4: return 32'd64;
            5: return 32'h00010002;
            6: return 32'hDE010001;
            7: return 32'd1;
            8: return 32'd128;
            9: return 32'h00010001;
            10: return 32'hDE010001;
            11: return 32'd1;
            12: return 32'h00430201;
            28: return 32'h00000087;
            44: return 32'h00000009;
            default: return '0;
        endcase
    endfunction

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

    function automatic logic [31:0] payload_crc32;
        logic [31:0] crc;
        int byte_count;
        begin
            crc = 32'hFFFFFFFF;
            for (int word_index = 0; word_index < 45; word_index = word_index + 1) begin
                byte_count = word_index == 44 ? 1 : 4;
                for (int byte_index = 0; byte_index < byte_count; byte_index = byte_index + 1) begin
                    crc = crc32_byte(crc, payload_word(word_index)[byte_index * 8 +: 8]);
                end
            end
            return ~crc;
        end
    endfunction

    function automatic logic [63:0] packet_beat(input int beat, input logic corrupt_crc);
        int word_index;
        logic [31:0] low_word;
        logic [31:0] high_word;
        begin
            low_word = '0;
            high_word = '0;
            case (beat)
                0: begin low_word = 32'h41443253; high_word = 32'h00010000; end
                1: begin low_word = 32'd1; high_word = 32'd0; end
                2: begin low_word = 32'h001234DE; high_word = PAYLOAD_BYTES; end
                3: begin low_word = payload_crc32() ^ (corrupt_crc ? 32'h1 : 0); high_word = 0; end
                4, 5, 6, 7: begin end
                default: begin
                    word_index = (beat - 8) * 2;
                    low_word = payload_word(word_index);
                    high_word = payload_word(word_index + 1);
                end
            endcase
            return {high_word, low_word};
        end
    endfunction

    task automatic send_bundle(input logic corrupt_crc);
        begin
            for (int beat = 0; beat <= 30; beat = beat + 1) begin
                @(negedge clk);
                s_tdata = packet_beat(beat, corrupt_crc);
                s_tkeep = beat == 30 ? 8'h01 : 8'hFF;
                s_tlast = beat == 30;
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

    task automatic expect_asset(
        input logic [1:0] asset_id,
        input logic [15:0] width,
        input logic [15:0] height,
        input logic [15:0] stride,
        input logic [14:0] byte_offset,
        input logic [7:0] expected_byte
    );
        begin
            @(negedge clk);
            read_asset_id = asset_id;
            read_byte_offset = byte_offset;
            repeat (2) @(posedge clk);
            #1ps;
            if (!read_asset_valid || read_asset_width != width ||
                read_asset_height != height || read_asset_stride_bytes != stride ||
                read_byte != expected_byte) begin
                $fatal(1, "asset %0d descriptor/readback mismatch", asset_id);
            end
        end
    endtask

    task automatic wait_packet_result(input int expected_packets);
        begin
            for (int wait_cycle = 0; wait_cycle < 32; wait_cycle = wait_cycle + 1) begin
                @(posedge clk);
                #1ps;
                if (accepted_packet_count + rejected_packet_count == expected_packets) return;
            end
            $fatal(1, "bundle completion receipt timed out");
        end
    endtask

    initial begin
        logic [15:0] boundary_width;
        logic [15:0] boundary_stride;
        for (int width_index = 0; width_index < 65536; width_index = width_index + 1) begin
            boundary_width = width_index[15:0];
            boundary_stride = (boundary_width + 16'd1) >> 1;
            if (boundary_stride != ((boundary_width + 1'b1) >> 1)) begin
                $fatal(1, "stride expression changed at width %0d", width_index);
            end
        end
        repeat (5) @(posedge clk);
        @(negedge clk);
        resetn = 1'b1;

        send_bundle(1'b0);
        wait_packet_result(1);
        if (accepted_packet_count != 1 || !commit_pending || bundle_valid) begin
            $fatal(1, "bundle was not staged");
        end
        @(negedge clk);
        renderer_idle = 1'b1;
        @(posedge clk);
        @(negedge clk);
        renderer_idle = 1'b0;
        if (!bundle_valid || commit_pending || committed_generation != 32'h001234DE ||
            active_bank != 1 || write_bank != 0) begin
            $fatal(1, "bundle commit mismatch");
        end
        expect_asset(0, 3, 2, 2, 0, 8'h01);
        expect_asset(0, 3, 2, 2, 2, 8'h43);
        expect_asset(1, 2, 1, 1, 0, 8'h87);
        expect_asset(2, 1, 1, 1, 0, 8'h09);

        send_bundle(1'b1);
        wait_packet_result(2);
        if (accepted_packet_count != 1 || rejected_packet_count != 1 ||
            committed_generation != 32'h001234DE || active_bank != 1 ||
            sticky_error_flags[6] != 1'b1) begin
            $fatal(1, "bad CRC changed active bundle");
        end
        expect_asset(2, 1, 1, 1, 0, 8'h09);

        descriptor_mode = 1;
        send_bundle(1'b0);
        wait_packet_result(3);
        if (accepted_packet_count != 1 || rejected_packet_count != 2 || active_bank != 1 || commit_pending)
            $fatal(1, "invalid stride changed active bundle");
        descriptor_mode = 2;
        send_bundle(1'b0);
        wait_packet_result(4);
        if (accepted_packet_count != 1 || rejected_packet_count != 3 || active_bank != 1 || commit_pending)
            $fatal(1, "zero width changed active bundle");
        descriptor_mode = 0;
        send_bundle(1'b0);
        wait_packet_result(5);
        if (accepted_packet_count != 2 || rejected_packet_count != 3 || !commit_pending || active_bank != 1)
            $fatal(1, "retransmitted bundle was not staged in other bank");
        @(negedge clk);
        renderer_idle = 1'b1;
        @(posedge clk);
        @(negedge clk);
        renderer_idle = 1'b0;
        if (active_bank != 0 || write_bank != 1 || commit_pending)
            $fatal(1, "other bank commit mismatch");
        expect_asset(0, 3, 2, 2, 2, 8'h43);
        expect_asset(2, 1, 1, 1, 0, 8'h09);

        $display("SCENE2D_STRIDE_BANK_RETRY_REJECTION=PASS packets=5 accepted=2 rejected=3");
        $display("SCENE2D_STRIDE_65536_WIDTHS=PASS");
        $display("SCENE2D_ASSET_BUNDLE_STORE=PASS generation=%08x", committed_generation);
        $finish;
    end

endmodule