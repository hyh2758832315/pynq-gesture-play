module tb_scene2d_runtime_palette_scanout;

    timeunit 1ns;
    timeprecision 1ps;

    logic clk_pixel = 1'b0;
    logic resetn_pixel = 1'b0;
    logic [8:0] logical_x = '0;
    logic [7:0] logical_y = '0;
    logic data_enable = 1'b0;
    logic hsync = 1'b0;
    logic vsync = 1'b0;
    logic [15:0] framebuffer_address;
    logic [7:0] framebuffer_token = '0;
    logic [7:0] palette_read_address;
    logic [23:0] palette_read_rgb = '0;
    logic [23:0] vid_data;
    logic vid_de;
    logic vid_hsync;
    logic vid_vsync;

    always #5ns clk_pixel = ~clk_pixel;

    function automatic logic [7:0] framebuffer_value(input logic [15:0] address);
        case (address)
            16'd643: framebuffer_value = 8'hA5;
            16'd644: framebuffer_value = 8'h7E;
            default: framebuffer_value = 8'h00;
        endcase
    endfunction

    function automatic logic [23:0] palette_value(input logic [7:0] address);
        case (address)
            8'hA5: palette_value = 24'h123456;
            8'h7E: palette_value = 24'hABCDEF;
            default: palette_value = 24'h000000;
        endcase
    endfunction

    always_ff @(posedge clk_pixel) begin
        framebuffer_token <= framebuffer_value(framebuffer_address);
        palette_read_rgb <= palette_value(palette_read_address);
    end

    scene2d_palette_scanout #(
        .RUNTIME_PALETTE_ENABLE(1)
    ) dut (
        .clk_pixel,
        .resetn_pixel,
        .logical_x,
        .logical_y,
        .data_enable,
        .hsync,
        .vsync,
        .framebuffer_address,
        .framebuffer_token,
        .palette_read_address,
        .palette_read_rgb,
        .vid_data,
        .vid_de,
        .vid_hsync,
        .vid_vsync
    );

    task automatic check_sample(
        input logic [8:0] x,
        input logic [7:0] y,
        input logic de,
        input logic sample_hsync,
        input logic sample_vsync,
        input logic [15:0] expected_address,
        input logic [23:0] expected_rgb
    );
        begin
            @(negedge clk_pixel);
            logical_x = x;
            logical_y = y;
            data_enable = de;
            hsync = sample_hsync;
            vsync = sample_vsync;
            #1ps;
            if (framebuffer_address != expected_address) begin
                $fatal(1, "framebuffer address=%0d expected=%0d", framebuffer_address, expected_address);
            end

            @(negedge clk_pixel);
            logical_x = '0;
            logical_y = '0;
            data_enable = 1'b0;
            hsync = 1'b0;
            vsync = 1'b0;
            repeat (3) @(posedge clk_pixel);
            #1ps;
            if (
                vid_data != expected_rgb ||
                vid_de != de ||
                vid_hsync != sample_hsync ||
                vid_vsync != sample_vsync
            ) begin
                $fatal(
                    1,
                    "runtime scanout rgb=%06x de=%b hsync=%b vsync=%b",
                    vid_data,
                    vid_de,
                    vid_hsync,
                    vid_vsync
                );
            end
        end
    endtask

    initial begin
        repeat (4) @(posedge clk_pixel);
        @(negedge clk_pixel);
        resetn_pixel = 1'b1;

        check_sample(9'd3, 8'd2, 1'b1, 1'b1, 1'b0, 16'd643, 24'h125634);
        check_sample(9'd4, 8'd2, 1'b1, 1'b0, 1'b1, 16'd644, 24'hABEFCD);
        check_sample(9'd3, 8'd2, 1'b0, 1'b0, 1'b0, 16'd643, 24'h000000);

        $display("SCENE2D_RUNTIME_PALETTE_SCANOUT=PASS");
        $finish;
    end

endmodule
