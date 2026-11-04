module tb_scene2d_test_pattern;

    timeunit 1ns;
    timeprecision 1ps;

    logic clk_pixel = 1'b0;
    logic resetn_pixel = 1'b0;
    logic [23:0] vid_data;
    logic vid_de;
    logic vid_hsync;
    logic vid_vsync;
    logic [31:0] frame_counter;

    always #6.734ns clk_pixel = ~clk_pixel;

    scene2d_test_pattern dut (
        .clk_pixel,
        .resetn_pixel,
        .vid_data,
        .vid_de,
        .vid_hsync,
        .vid_vsync,
        .frame_counter
    );

    task automatic check_pixel(
        input int x,
        input int y,
        input logic [23:0] expected_data,
        input logic expected_de
    );
        while (dut.pixel_x != x || dut.pixel_y != y) begin
            @(posedge clk_pixel);
            #1ps;
        end
        if (vid_de !== expected_de || vid_data !== expected_data) begin
            $fatal(
                1,
                "pixel (%0d,%0d) de=%0b data=%06x expected de=%0b data=%06x",
                x,
                y,
                vid_de,
                vid_data,
                expected_de,
                expected_data
            );
        end
    endtask

    initial begin
        repeat (5) @(posedge clk_pixel);
        @(negedge clk_pixel);
        resetn_pixel = 1'b1;
        #1ps;

        check_pixel(0, 0, 24'hffffff, 1'b1);
        check_pixel(820, 0, 24'hff0000, 1'b1);
        check_pixel(580, 296, 24'hffffff, 1'b1);
        check_pixel(600, 320, 24'hff0080, 1'b1);
        check_pixel(1280, 720, 24'h000000, 1'b0);

        if (frame_counter != 1) begin
            $fatal(1, "frame_counter %0d != 1", frame_counter);
        end

        $display("SCENE2D_TEST_PATTERN=PASS frame_counter=%0d", frame_counter);
        $finish;
    end

endmodule