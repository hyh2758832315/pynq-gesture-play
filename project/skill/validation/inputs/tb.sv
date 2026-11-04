module tb_scene2d_upload_sink;

    timeunit 1ns;
    timeprecision 1ps;

    logic clk = 1'b0;
    logic resetn = 1'b0;
    logic [63:0] tdata = '0;
    logic [7:0] tkeep = '0;
    logic tlast = 1'b0;
    logic tvalid = 1'b0;
    logic tready;
    logic [31:0] completed_crc32;
    logic [31:0] completed_byte_count;
    logic [31:0] completed_packet_count;

    always #5ns clk = ~clk;

    scene2d_upload_sink dut (
        .aclk(clk),
        .aresetn(resetn),
        .s_axis_tdata(tdata),
        .s_axis_tkeep(tkeep),
        .s_axis_tlast(tlast),
        .s_axis_tvalid(tvalid),
        .s_axis_tready(tready),
        .completed_crc32,
        .completed_byte_count,
        .completed_packet_count
    );

    task automatic send_beat(
        input logic [63:0] data,
        input logic [7:0] keep,
        input logic last
    );
        @(negedge clk);
        tdata = data;
        tkeep = keep;
        tlast = last;
        tvalid = 1'b1;
        do @(posedge clk); while (!tready);
        @(negedge clk);
        tvalid = 1'b0;
        tlast = 1'b0;
        tkeep = '0;
        tdata = '0;
    endtask

    initial begin
        repeat (5) @(posedge clk);
        @(negedge clk);
        resetn = 1'b1;

        send_beat(64'h3837363534333231, 8'hFF, 1'b0);
        send_beat(64'h0000000000000039, 8'h01, 1'b1);
        wait (completed_packet_count == 1);
        @(posedge clk);
        #1ps;

        if (completed_crc32 != 32'hCBF43926) begin
            $fatal(1, "CRC32 %08x != CBF43926", completed_crc32);
        end
        if (completed_byte_count != 9) begin
            $fatal(1, "byte count %0d != 9", completed_byte_count);
        end
        if (completed_packet_count != 1) begin
            $fatal(1, "packet count %0d != 1", completed_packet_count);
        end

        $display(
            "SCENE2D_UPLOAD_SINK=PASS crc=%08x bytes=%0d packets=%0d",
            completed_crc32,
            completed_byte_count,
            completed_packet_count
        );
        $finish;
    end

endmodule