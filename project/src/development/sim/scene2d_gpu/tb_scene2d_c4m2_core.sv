module tb_scene2d_c4m2_core;

    timeunit 1ns;
    timeprecision 1ps;

    logic clk = 1'b0;
    logic resetn = 1'b0;
    logic [63:0] tdata = '0;
    logic [7:0] tkeep = '0;
    logic tlast = 1'b0;
    logic tvalid = 1'b0;
    logic tready;
    logic [8:0] debug_read_address = '0;
    logic [31:0] debug_read_data_low;
    logic [31:0] debug_read_data_high;
    logic [31:0] upload_crc32;
    logic [31:0] upload_byte_count;
    logic [31:0] upload_packet_count;
    logic [31:0] accepted_packet_count;
    logic [31:0] rejected_packet_count;
    logic [31:0] accepted_seq;
    logic [31:0] accepted_status;
    logic [5:0] upload_error_flags;
    logic [31:0] render_completed_seq;
    logic [31:0] render_completed_count;
    logic [31:0] render_write_count;
    logic [31:0] render_trace_crc32;
    logic [31:0] render_cycles;
    logic [31:0] render_maximum_cycles;
    logic [31:0] render_status;
    logic [63:0] payload [0:519];

    always #5ns clk = ~clk;

    always @(posedge clk) begin
        if (resetn && render_status[0] && tready) begin
            $fatal(1, "DMA ready asserted while renderer busy");
        end
    end

    scene2d_c4m2_core dut (
        .aclk(clk),
        .aresetn(resetn),
        .s_axis_tdata(tdata),
        .s_axis_tkeep(tkeep),
        .s_axis_tlast(tlast),
        .s_axis_tvalid(tvalid),
        .s_axis_tready(tready),
        .debug_command_read_address(debug_read_address),
        .debug_command_read_data_low(debug_read_data_low),
        .debug_command_read_data_high(debug_read_data_high),
        .upload_crc32,
        .upload_byte_count,
        .upload_packet_count,
        .accepted_packet_count,
        .rejected_packet_count,
        .accepted_seq,
        .accepted_status,
        .upload_error_flags,
        .render_completed_seq,
        .render_completed_count,
        .render_write_count,
        .render_trace_crc32,
        .render_cycles,
        .render_maximum_cycles,
        .render_status
    );

    task automatic send_payload(input logic [31:0] sequence_value);
        logic [63:0] beat_data;
        begin
            for (integer beat = 0; beat < 520; beat = beat + 1) begin
                beat_data = payload[beat];
                if (beat == 1) begin
                    beat_data[63:32] = sequence_value;
                end
                @(negedge clk);
                tdata = beat_data;
                tkeep = 8'hFF;
                tlast = beat == 519;
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

    task automatic expect_debug_word(
        input logic [8:0] address,
        input logic [63:0] expected
    );
        begin
            @(negedge clk);
            debug_read_address = address;
            @(posedge clk);
            #1ps;
            if ({debug_read_data_high, debug_read_data_low} != expected) begin
                $fatal(1, "debug command[%0d] mismatch", address);
            end
        end
    endtask

    initial begin
        $readmemh("sim/scene2d_gpu/vectors/c4m2_payload.mem", payload);
        repeat (5) @(posedge clk);
        @(negedge clk);
        resetn = 1'b1;

        send_payload(32'hC4020001);
        wait (render_completed_count == 1);
        @(negedge clk);
        if (
            upload_crc32 != 32'hC277CACE || upload_byte_count != 32'd4160 ||
            upload_packet_count != 1 || accepted_packet_count != 1 ||
            rejected_packet_count != 0 || upload_error_flags != 0
        ) begin
            $fatal(1, "first upload status mismatch");
        end
        if (
            render_completed_seq != 32'hC4020001 ||
            render_write_count != 32'd57608 ||
            render_trace_crc32 != 32'hB62CC96A ||
            render_status[11:4] != 0 || render_cycles != 32'd57644
        ) begin
            $fatal(1, "first render status mismatch");
        end
        if (accepted_status[10:9] != 2'b11) begin
            $fatal(1, "first upload did not activate bank 1");
        end
        expect_debug_word(0, payload[8]);
        expect_debug_word(511, payload[519]);

        send_payload(32'hC4020002);
        wait (render_completed_count == 2);
        @(negedge clk);
        if (
            accepted_packet_count != 2 || render_completed_seq != 32'hC4020002 ||
            render_write_count != 32'd57608 ||
            render_trace_crc32 != 32'hB62CC96A ||
            render_maximum_cycles != 32'd57644
        ) begin
            $fatal(1, "second render status mismatch");
        end
        if (accepted_status[10:9] != 2'b10) begin
            $fatal(1, "second upload did not activate bank 0");
        end
        expect_debug_word(0, payload[8]);
        expect_debug_word(511, payload[519]);

        $display(
            "SCENE2D_C4M2_CORE=PASS uploads=%0d renders=%0d writes=%0d crc=%08x cycles=%0d",
            accepted_packet_count,
            render_completed_count,
            render_write_count,
            render_trace_crc32,
            render_cycles
        );
        $finish;
    end

endmodule