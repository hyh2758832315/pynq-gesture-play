module tb_scene2d_index4_blit;
    timeunit 1ns;
    timeprecision 1ps;

    logic clk = 0;
    logic resetn = 0;
    logic start = 0;
    logic [15:0] atlas_address;
    logic [3:0] atlas_index;
    logic write_valid;
    logic [15:0] write_address;
    logic [7:0] write_token;
    logic busy;
    logic done;
    logic [3:0] atlas [0:5];
    integer writes = 0;

    always #5ns clk = ~clk;
    always_ff @(posedge clk) atlas_index <= atlas[atlas_address];

    scene2d_index4_blit #(.ATLAS_WIDTH(3)) dut (
        .aclk(clk), .aresetn(resetn), .start, .palette_bank(4'hA),
        .dst_x(-16'sd1), .dst_y(16'sd1), .width(16'd3), .height(16'd2),
        .src_x(16'd0), .src_y(16'd0), .flip_x(1'b1), .flip_y(1'b1),
        .atlas_address, .atlas_index, .write_valid, .write_address, .write_token, .busy, .done
    );

    always @(posedge clk) if (write_valid) begin
        case (writes)
            0: if (write_address != 16'd320 || write_token != 8'hA4) $fatal(1, "write 0 mismatch");
            1: if (write_address != 16'd321 || write_token != 8'hA3) $fatal(1, "write 1 mismatch");
            2: if (write_address != 16'd641 || write_token != 8'hA1) $fatal(1, "write 2 mismatch");
            default: $fatal(1, "unexpected write");
        endcase
        writes = writes + 1;
    end

    initial begin
        atlas[0] = 1; atlas[1] = 0; atlas[2] = 2;
        atlas[3] = 3; atlas[4] = 4; atlas[5] = 0;
        repeat (3) @(posedge clk);
        resetn = 1;
        @(negedge clk); start = 1;
        @(negedge clk); start = 0;
        wait (done);
        @(negedge clk);
        if (writes != 3 || busy) $fatal(1, "blit completion mismatch");
        $display("SCENE2D_INDEX4_BLIT=PASS writes=%0d", writes);
        $finish;
    end
endmodule