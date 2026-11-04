module tb_scene2d_video_timing;

    timeunit 1ns;
    timeprecision 1ps;

    localparam int H_ACTIVE = 1280;
    localparam int H_TOTAL = 1650;
    localparam int V_ACTIVE = 720;
    localparam int V_TOTAL = 750;
    localparam int FRAME_CYCLES = H_TOTAL * V_TOTAL;

    logic clk_pixel = 1'b0;
    logic resetn_pixel = 1'b0;
    logic [10:0] pixel_x;
    logic [9:0] pixel_y;
    logic [8:0] logical_x;
    logic [7:0] logical_y;
    logic data_enable;
    logic hsync;
    logic vsync;
    logic frame_start;
    logic line_start;

    int cycle_count;
    int active_count;
    int hsync_count;
    int vsync_count;
    int line_count;

    always #6.734ns clk_pixel = ~clk_pixel;

    scene2d_video_timing dut (
        .clk_pixel,
        .resetn_pixel,
        .pixel_x,
        .pixel_y,
        .logical_x,
        .logical_y,
        .data_enable,
        .hsync,
        .vsync,
        .frame_start,
        .line_start
    );

    initial begin
        repeat (5) @(posedge clk_pixel);
        @(negedge clk_pixel);
        resetn_pixel = 1'b1;

        cycle_count = 0;
        active_count = 0;
        hsync_count = 0;
        vsync_count = 0;
        line_count = 0;

        forever begin
            @(posedge clk_pixel);
            #1ps;
            cycle_count++;
            active_count += data_enable;
            hsync_count += hsync;
            vsync_count += vsync;
            line_count += line_start;

            if (data_enable !== (pixel_x < H_ACTIVE && pixel_y < V_ACTIVE)) begin
                $fatal(1, "data_enable mismatch at (%0d,%0d)", pixel_x, pixel_y);
            end
            if (hsync !== (pixel_x >= 1390 && pixel_x < 1430)) begin
                $fatal(1, "hsync mismatch at x=%0d", pixel_x);
            end
            if (vsync !== (pixel_y >= 725 && pixel_y < 730)) begin
                $fatal(1, "vsync mismatch at y=%0d", pixel_y);
            end
            if (data_enable && logical_x != pixel_x / 4) begin
                $fatal(1, "logical_x mismatch at x=%0d", pixel_x);
            end
            if (data_enable && logical_y != pixel_y / 4) begin
                $fatal(1, "logical_y mismatch at y=%0d", pixel_y);
            end

            if (frame_start && cycle_count > 1) begin
                break;
            end
        end

        if (cycle_count != FRAME_CYCLES) begin
            $fatal(1, "frame cycles %0d != %0d", cycle_count, FRAME_CYCLES);
        end
        if (active_count != H_ACTIVE * V_ACTIVE) begin
            $fatal(1, "active pixels %0d != %0d", active_count, H_ACTIVE * V_ACTIVE);
        end
        if (hsync_count != 40 * V_TOTAL) begin
            $fatal(1, "hsync cycles %0d != %0d", hsync_count, 40 * V_TOTAL);
        end
        if (vsync_count != 5 * H_TOTAL) begin
            $fatal(1, "vsync cycles %0d != %0d", vsync_count, 5 * H_TOTAL);
        end
        if (line_count != V_TOTAL) begin
            $fatal(1, "line starts %0d != %0d", line_count, V_TOTAL);
        end

        $display(
            "SCENE2D_TIMING=PASS cycles=%0d active=%0d hsync=%0d vsync=%0d lines=%0d",
            cycle_count,
            active_count,
            hsync_count,
            vsync_count,
            line_count
        );
        $finish;
    end

endmodule