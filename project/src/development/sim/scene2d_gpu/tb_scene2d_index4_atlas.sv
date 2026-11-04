module tb_scene2d_index4_atlas;
    timeunit 1ns;
    timeprecision 1ps;

    logic clk = 0;
    logic resetn = 0;
    logic [2:0] pixel_address = 0;
    logic [3:0] color_index;

    always #5ns clk = ~clk;

    scene2d_index4_atlas #(
        .PIXEL_COUNT(8),
        .PIXEL_ADDRESS_WIDTH(3),
        .BYTE_ADDRESS_WIDTH(2),
        .INIT_FILE("sim/scene2d_gpu/vectors/index4_atlas.mem")
    ) dut (
        .clk,
        .resetn,
        .pixel_address,
        .color_index
    );

    task automatic check_pixel(input logic [2:0] address, input logic [3:0] expected);
        begin
            @(negedge clk);
            pixel_address = address;
            @(posedge clk);
            @(negedge clk);
            if (color_index != expected) begin
                $fatal(1, "atlas[%0d]=%x expected=%x", address, color_index, expected);
            end
        end
    endtask

    initial begin
        repeat (3) @(posedge clk);
        @(negedge clk);
        resetn = 1;
        check_pixel(0, 1);
        check_pixel(1, 2);
        check_pixel(2, 3);
        check_pixel(3, 0);
        check_pixel(4, 4);
        check_pixel(5, 5);
        $display("SCENE2D_INDEX4_ATLAS=PASS");
        $finish;
    end
endmodule