module tb_scene2d_command_upload #(
    parameter bit UPLOAD_RENDER_OVERLAP_ENABLE = 1'b0,
    parameter bit TEST_UPLOAD_OVERLAP = 1'b0
);

    timeunit 1ns;
    timeprecision 1ps;

    localparam int CORRUPT_NONE = 0;
    localparam int CORRUPT_MAGIC = 1;
    localparam int CORRUPT_ABI = 2;
    localparam int CORRUPT_COUNT = 3;
    localparam int CORRUPT_RESERVED = 4;
    localparam int CORRUPT_TKEEP = 5;
    localparam int CORRUPT_EARLY_LAST = 6;

    logic clk = 1'b0;
    logic resetn = 1'b0;
    logic [63:0] tdata = '0;
    logic [7:0] tkeep = '0;
    logic tlast = 1'b0;
    logic tvalid = 1'b0;
    logic tready;
    logic [8:0] read_address = '0;
    logic [63:0] read_data;
    logic [31:0] completed_crc32;
    logic [31:0] completed_byte_count;
    logic [31:0] completed_packet_count;
    logic [31:0] accepted_packet_count;
    logic [31:0] rejected_packet_count;
    logic [31:0] accepted_seq;
    logic [31:0] accepted_tilemap_generation;
    logic [8:0] accepted_command_count;
    logic [31:0] accepted_status;
    logic [5:0] sticky_error_flags;
    logic active_bank;
    logic bank_valid;
    logic render_bank_valid = 1'b0;
    logic render_bank_select = 1'b0;
    logic check_pinned_bank = 1'b0;
    logic pinned_handshake;
    integer concurrent_reads = 0;

    always #5ns clk = ~clk;

    scene2d_command_upload #(
        .UPLOAD_RENDER_OVERLAP_ENABLE(UPLOAD_RENDER_OVERLAP_ENABLE)
    ) dut (
        .aclk(clk),
        .aresetn(resetn),
        .s_axis_tdata(tdata),
        .s_axis_tkeep(tkeep),
        .s_axis_tlast(tlast),
        .s_axis_tvalid(tvalid),
        .s_axis_tready(tready),
        .command_read_address(read_address),
        .render_bank_valid,
        .render_bank_select,
        .generation_check_enable(3'd0),
        .resource_generation_valid(3'd0),
        .required_palette_generation(32'd0),
        .required_asset_generation(32'd0),
        .required_tilemap_generation(32'd0),
        .command_read_data(read_data),
        .completed_crc32,
        .completed_byte_count,
        .completed_packet_count,
        .accepted_packet_count,
        .rejected_packet_count,
        .accepted_seq,
        .accepted_tilemap_generation,
        .accepted_command_count,
        .accepted_status,
        .sticky_error_flags,
        .active_bank,
        .bank_valid
    );

    function automatic logic [63:0] payload_beat(
        input int beat,
        input logic [31:0] submit_sequence,
        input logic [31:0] command_count,
        input int corruption
    );
        logic [31:0] low_word;
        logic [31:0] high_word;
        begin
            low_word = 32'd0;
            high_word = 32'd0;
            case (beat)
                0: begin
                    low_word = corruption == CORRUPT_MAGIC ? 32'hDEADBEEF : 32'h47443253;
                    high_word = corruption == CORRUPT_ABI ? 32'h00020000 : 32'h00010000;
                end
                1: begin
                    low_word = 32'h01020304;
                    high_word = submit_sequence;
                end
                2: begin
                    low_word = corruption == CORRUPT_COUNT ? 32'd129 : command_count;
                    high_word = 32'd0;
                end
                3: begin
                    low_word = 32'd0;
                    high_word = 32'h00112233;
                end
                4: begin
                    low_word = 32'd7;
                    high_word = 32'd1000;
                end
                5: begin
                    low_word = 32'd0;
                    high_word = 32'hAABBCCDD;
                end
                6: begin
                    low_word = corruption == CORRUPT_RESERVED ? 32'd1 : 32'd0;
                    high_word = 32'd0;
                end
                7: begin
                    low_word = 32'd0;
                    high_word = 32'd0;
                end
                default: begin
                    low_word = 32'hC4000000 + (beat - 8) * 2;
                    if (TEST_UPLOAD_OVERLAP && submit_sequence == 32'h44) begin
                        low_word = 32'h55000000 + (beat - 8) * 2;
                    end
                    high_word = low_word + 1'b1;
                end
            endcase
            return {high_word, low_word};
        end
    endfunction

    task automatic send_payload(
        input logic [31:0] submit_sequence,
        input logic [31:0] command_count,
        input int corruption
    );
        int final_beat;
        begin
            final_beat = corruption == CORRUPT_EARLY_LAST ? 10 : 519;
            for (int beat = 0; beat <= final_beat; beat = beat + 1) begin
                @(negedge clk);
                tdata = payload_beat(beat, submit_sequence, command_count, corruption);
                tkeep = corruption == CORRUPT_TKEEP && beat == 20 ? 8'h0F : 8'hFF;
                tlast = beat == final_beat;
                tvalid = 1'b1;
                do @(posedge clk); while (!tready);
            end
            @(negedge clk);
            tvalid = 1'b0;
            tlast = 1'b0;
            tkeep = '0;
            tdata = '0;
            wait (completed_packet_count == accepted_packet_count + rejected_packet_count);
            @(posedge clk);
        end
    endtask

    task automatic expect_command_word(
        input logic [8:0] address,
        input logic [63:0] expected
    );
        begin
            @(negedge clk);
            read_address = address;
            @(posedge clk);
            #1ps;
            if (read_data != expected) begin
                $fatal(1, "command[%0d]=%016x expected=%016x", address, read_data, expected);
            end
        end
    endtask

    always @(posedge clk) begin
        pinned_handshake = check_pinned_bank && tvalid && tready;
        #1ps;
        if (check_pinned_bank) begin
            if (read_data != 64'hC4000001C4000000) begin
                $fatal(1, "pinned bank changed during upload: %016x", read_data);
            end
            if (pinned_handshake) concurrent_reads = concurrent_reads + 1;
        end
    end

    initial begin
        #1ms;
        $fatal(1, "command upload watchdog expired");
    end

    initial begin
        repeat (5) @(posedge clk);
        @(negedge clk);
        resetn = 1'b1;

        send_payload(32'h00000011, 32'd2, CORRUPT_NONE);
        if (!bank_valid || active_bank != 1'b1 || accepted_packet_count != 1) begin
            $fatal(1, "first valid upload did not activate bank 1");
        end
        if (accepted_seq != 32'h00000011 || accepted_tilemap_generation != 32'hAABBCCDD ||
            accepted_command_count != 2) begin
            $fatal(1, "first accepted header mismatch");
        end
        expect_command_word(0, 64'hC4000001C4000000);
        expect_command_word(511, 64'hC40003FFC40003FE);

        send_payload(32'h00000022, 32'd2, CORRUPT_MAGIC);
        send_payload(32'h00000023, 32'd2, CORRUPT_ABI);
        send_payload(32'h00000024, 32'd2, CORRUPT_COUNT);
        send_payload(32'h00000025, 32'd2, CORRUPT_RESERVED);
        send_payload(32'h00000026, 32'd2, CORRUPT_TKEEP);
        send_payload(32'h00000027, 32'd2, CORRUPT_EARLY_LAST);
        if (rejected_packet_count != 6 || accepted_packet_count != 1) begin
            $fatal(1, "invalid upload accounting mismatch");
        end
        if (sticky_error_flags != 6'b111111) begin
            $fatal(1, "sticky error flags=%02x expected=3f", sticky_error_flags);
        end
        if (active_bank != 1'b1 || accepted_seq != 32'h00000011) begin
            $fatal(1, "invalid upload changed accepted state");
        end
        expect_command_word(0, 64'hC4000001C4000000);

        send_payload(32'h00000033, 32'd128, CORRUPT_NONE);
        if (active_bank != 1'b0 || accepted_packet_count != 2) begin
            $fatal(1, "second valid upload did not activate bank 0");
        end
        if (accepted_seq != 32'h00000033 || accepted_command_count != 128) begin
            $fatal(1, "second accepted header mismatch");
        end
        if (accepted_status != 32'h00000480) begin
            $fatal(1, "accepted status=%08x expected=00000480", accepted_status);
        end
        expect_command_word(0, 64'hC4000001C4000000);
        expect_command_word(511, 64'hC40003FFC40003FE);

        if (TEST_UPLOAD_OVERLAP) begin
            @(negedge clk);
            render_bank_valid = 1'b1;
            render_bank_select = active_bank;
            read_address = 0;
            repeat (2) @(posedge clk);
            @(negedge clk);
            check_pinned_bank = UPLOAD_RENDER_OVERLAP_ENABLE;
            send_payload(32'h44, 32'd2, CORRUPT_NONE);
            if (accepted_packet_count != 3 || active_bank != 1'b1) begin
                $fatal(1, "queued upload did not commit independently");
            end
            if (UPLOAD_RENDER_OVERLAP_ENABLE) begin
                expect_command_word(0, 64'hC4000001C4000000);
                if (concurrent_reads != 520) begin
                    $fatal(1, "concurrent read coverage=%0d", concurrent_reads);
                end
            end else begin
                expect_command_word(0, 64'h5500000155000000);
            end
            @(negedge clk);
            check_pinned_bank = 1'b0;
            render_bank_valid = 1'b0;
            expect_command_word(0, 64'h5500000155000000);
            expect_command_word(511, 64'h550003FF550003FE);
            $display("SCENE2D_COMMAND_BANK_PIN=PASS overlap=%0d reads=%0d",
                UPLOAD_RENDER_OVERLAP_ENABLE, concurrent_reads);
        end

        $display(
            "SCENE2D_COMMAND_UPLOAD=PASS accepted=%0d rejected=%0d errors=%02x packets=%0d",
            accepted_packet_count,
            rejected_packet_count,
            sticky_error_flags,
            completed_packet_count
        );
        $finish;
    end

endmodule