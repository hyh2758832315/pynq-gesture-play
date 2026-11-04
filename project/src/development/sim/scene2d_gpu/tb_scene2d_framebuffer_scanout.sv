module tb_scene2d_framebuffer_scanout #(
    parameter bit DUAL_PIXEL_WRITE_ENABLE = 1'b0
);

    timeunit 1ns;
    timeprecision 1ps;

    logic write_clk = 1'b0;
    logic write_resetn = 1'b0;
    logic pixel_clk = 1'b0;
    logic pixel_resetn = 1'b0;
    logic render_done = 1'b0;
    logic write_bank;
    logic present_pending;
    logic present_done;
    logic frame_start = 1'b0;
    logic display_bank;
    logic swap_pulse;
    logic write_enable = 1'b0;
    logic [15:0] write_address = '0;
    logic [7:0] write_token = '0;
    logic write_second_enable = 1'b0;
    logic [7:0] write_second_token = '0;
    logic [15:0] read_address = '0;
    logic [7:0] read_token;
    logic [7:0] scanout_token = '0;
    logic [8:0] logical_x = '0;
    logic [7:0] logical_y = '0;
    logic data_enable = 1'b0;
    logic hsync = 1'b0;
    logic vsync = 1'b0;
    logic [15:0] scanout_address;
    logic [23:0] vid_data;
    logic vid_de;
    logic vid_hsync;
    logic vid_vsync;
    logic observed_present_done = 1'b0;
    logic observed_swap_pulse = 1'b0;

    always #5ns write_clk = ~write_clk;
    always #7ns pixel_clk = ~pixel_clk;

    always_ff @(posedge write_clk) begin
        if (!write_resetn) begin
            observed_present_done <= 1'b0;
        end else if (present_done) begin
            observed_present_done <= 1'b1;
        end
    end

    always_ff @(posedge pixel_clk) begin
        if (!pixel_resetn) begin
            observed_swap_pulse <= 1'b0;
        end else if (swap_pulse) begin
            observed_swap_pulse <= 1'b1;
        end
    end

    scene2d_frame_swap swap_dut (
        .write_clk,
        .write_resetn,
        .render_done,
        .write_bank,
        .present_pending,
        .present_done,
        .pixel_clk,
        .pixel_resetn,
        .frame_start,
        .display_bank,
        .swap_pulse
    );

    scene2d_framebuffer #(
        .DUAL_PIXEL_WRITE_ENABLE(DUAL_PIXEL_WRITE_ENABLE)
    ) framebuffer_dut (
        .write_clk,
        .write_resetn,
        .write_bank,
        .write_enable,
        .write_address,
        .write_token,
        .write_second_enable,
        .write_second_token,
        .read_clk(pixel_clk),
        .read_resetn(pixel_resetn),
        .read_bank(display_bank),
        .read_address,
        .read_token
    );

    scene2d_palette_scanout scanout_dut (
        .clk_pixel(pixel_clk),
        .resetn_pixel(pixel_resetn),
        .logical_x,
        .logical_y,
        .data_enable,
        .hsync,
        .vsync,
        .framebuffer_address(scanout_address),
        .framebuffer_token(scanout_token),
        .vid_data,
        .vid_de,
        .vid_hsync,
        .vid_vsync
    );

    task automatic write_pixel(input logic [15:0] address, input logic [7:0] token);
        begin
            @(negedge write_clk);
            write_address = address;
            write_token = token;
            write_enable = 1'b1;
            @(negedge write_clk);
            write_enable = 1'b0;
        end
    endtask

    task automatic write_pair(input logic [15:0] address,
                              input logic [1:0] mask,
                              input logic [7:0] low_token,
                              input logic [7:0] high_token);
        begin
            if (DUAL_PIXEL_WRITE_ENABLE) begin
                @(negedge write_clk);
                write_address = address;
                write_token = low_token;
                write_second_token = high_token;
                write_enable = mask[0];
                write_second_enable = mask[1];
                @(negedge write_clk);
                write_enable = 1'b0;
                write_second_enable = 1'b0;
            end else begin
                if (mask[0]) write_pixel(address, low_token);
                if (mask[1]) write_pixel(address + 16'd1, high_token);
            end
        end
    endtask

    task automatic check_pixel(input logic [15:0] address,
                               input logic [7:0] expected);
        begin
            @(negedge pixel_clk);
            read_address = address;
            repeat (2) @(posedge pixel_clk);
            #1ps;
            if (read_token !== expected)
                $fatal(1, "bank=%0d address=%0d token=%02x expected=%02x",
                       display_bank, address, read_token, expected);
        end
    endtask

    task automatic request_present;
        begin
            @(negedge write_clk);
            render_done = 1'b1;
            @(negedge write_clk);
            render_done = 1'b0;
        end
    endtask

    task automatic vblank_boundary;
        begin
            @(negedge pixel_clk);
            frame_start = 1'b1;
            @(negedge pixel_clk);
            frame_start = 1'b0;
        end
    endtask

    initial begin
        repeat (4) @(posedge write_clk);
        @(negedge write_clk);
        write_resetn = 1'b1;
        repeat (4) @(posedge pixel_clk);
        @(negedge pixel_clk);
        pixel_resetn = 1'b1;

        if (write_bank != 1'b1 || display_bank != 1'b0 || present_pending) begin
            $fatal(1, "unexpected reset bank ownership");
        end

        write_pixel(16'd0, 8'hA5);
        write_pixel(16'd1, 8'h7E);
        write_pair(16'd2046, 2'b11, 8'h21, 8'h43);
        write_pair(16'd2048, 2'b11, 8'h65, 8'h87);
        write_pair(16'd2046, 2'b00, 8'hFF, 8'hFF);
        write_pair(16'd2048, 2'b01, 8'hA1, 8'hFF);
        write_pair(16'd57598, 2'b11, 8'hB2, 8'hC3);
        write_pair(16'd57598, 2'b10, 8'hFF, 8'hD4);
        request_present();
        repeat (4) @(posedge pixel_clk);
        if (!present_pending || display_bank != 1'b0 || swap_pulse) begin
            $fatal(1, "swap happened outside vblank boundary");
        end
        vblank_boundary();
        @(negedge pixel_clk);
        if (display_bank != 1'b1 || !observed_swap_pulse) begin
            $fatal(1, "vblank did not swap display bank");
        end
        repeat (4) @(posedge write_clk);
        if (present_pending || write_bank != 1'b0 || !observed_present_done) begin
            $fatal(1, "write-side acknowledgement mismatch");
        end

        @(negedge pixel_clk);
        read_address = 16'd0;
        repeat (3) @(posedge pixel_clk);
        if (read_token != 8'hA5) begin
            $fatal(1, "bank 1 token=%02x expected=A5", read_token);
        end
        @(negedge pixel_clk);
        read_address = 16'd1;
        repeat (3) @(posedge pixel_clk);
        if (read_token != 8'h7E) begin
            $fatal(1, "bank 1 token=%02x expected=7E", read_token);
        end
        check_pixel(16'd2046, 8'h21);
        check_pixel(16'd2047, 8'h43);
        check_pixel(16'd2048, 8'hA1);
        check_pixel(16'd2049, 8'h87);
        check_pixel(16'd57598, 8'hB2);
        check_pixel(16'd57599, 8'hD4);
        @(negedge pixel_clk); read_address = 16'd2046;
        @(posedge pixel_clk);
        @(negedge pixel_clk); read_address = 16'd2047;
        @(posedge pixel_clk); #1ps;
        if (read_token !== 8'h21) $fatal(1, "stream read latency 0");
        @(negedge pixel_clk); read_address = 16'd2048;
        @(posedge pixel_clk); #1ps;
        if (read_token !== 8'h43) $fatal(1, "stream read latency 1");
        @(negedge pixel_clk); read_address = 16'd2049;
        @(posedge pixel_clk); #1ps;
        if (read_token !== 8'hA1) $fatal(1, "stream read latency 2");
        @(posedge pixel_clk); #1ps;
        if (read_token !== 8'h87) $fatal(1, "stream read latency 3");

        write_pixel(16'd0, 8'h12);
        write_pixel(16'd1, 8'h34);
        write_pair(16'd0, 2'b10, 8'hFF, 8'h56);
        write_pair(16'd57598, 2'b11, 8'h78, 8'h9A);
        write_pixel(16'd57599, 8'hBC);
        request_present();
        repeat (4) @(posedge pixel_clk);
        vblank_boundary();
        @(negedge pixel_clk);
        if (display_bank != 1'b0 || !observed_swap_pulse) begin
            $fatal(1, "second vblank did not swap display bank");
        end
        repeat (4) @(posedge write_clk);
        if (present_pending || write_bank != 1'b1 || !observed_present_done) begin
            $fatal(1, "second write-side acknowledgement mismatch");
        end

        @(negedge pixel_clk);
        read_address = 16'd0;
        repeat (3) @(posedge pixel_clk);
        if (read_token != 8'h12) begin
            $fatal(1, "bank 0 token=%02x expected=12", read_token);
        end
        check_pixel(16'd1, 8'h56);
        check_pixel(16'd57598, 8'h78);
        check_pixel(16'd57599, 8'hBC);

        @(negedge pixel_clk);
        logical_x = 9'd3;
        logical_y = 8'd2;
        data_enable = 1'b1;
        scanout_token = 8'hA5;
        #1ps;
        if (scanout_address != 16'd643) begin
            $fatal(1, "scanout address=%0d expected=643", scanout_address);
        end
        repeat (3) @(posedge pixel_clk);
        @(negedge pixel_clk);
        if (vid_data != 24'h55FFAA || !vid_de) begin
            $fatal(1, "palette output=%06x de=%b", vid_data, vid_de);
        end

        $display("SCENE2D_FRAMEBUFFER_SCANOUT=PASS dual=%0d display_bank=%0d write_bank=%0d", DUAL_PIXEL_WRITE_ENABLE, display_bank, write_bank);
        $finish;
    end

    initial begin
        #100us;
        $fatal(1, "framebuffer watchdog");
    end

endmodule