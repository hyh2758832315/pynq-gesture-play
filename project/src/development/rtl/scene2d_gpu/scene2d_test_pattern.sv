module scene2d_test_pattern (
    input  logic        clk_pixel,
    input  logic        resetn_pixel,
    output logic [23:0] vid_data,
    output logic        vid_de,
    output logic        vid_hsync,
    output logic        vid_vsync,
    output logic [31:0] frame_counter
);

    logic [10:0] pixel_x;
    logic [9:0] pixel_y;
    logic [8:0] logical_x;
    logic [7:0] logical_y;
    logic frame_start;
    logic vblank_start;
    logic line_start;
    logic [7:0] red;
    logic [7:0] green;
    logic [7:0] blue;

    scene2d_video_timing timing (
        .clk_pixel,
        .resetn_pixel,
        .pixel_x,
        .pixel_y,
        .logical_x,
        .logical_y,
        .data_enable(vid_de),
        .hsync(vid_hsync),
        .vsync(vid_vsync),
        .frame_start,
        .vblank_start,
        .line_start
    );

    always_ff @(posedge clk_pixel) begin
        if (!resetn_pixel) begin
            frame_counter <= '0;
        end else if (frame_start) begin
            frame_counter <= frame_counter + 1'b1;
        end
    end

    always_comb begin
        red = '0;
        green = '0;
        blue = '0;

        if (vid_de) begin
            if (logical_x < 40) begin
                red = 8'hff;
                green = 8'hff;
                blue = 8'hff;
            end else if (logical_x < 80) begin
                red = 8'hff;
                green = 8'hff;
            end else if (logical_x < 120) begin
                green = 8'hff;
                blue = 8'hff;
            end else if (logical_x < 160) begin
                green = 8'hff;
            end else if (logical_x < 200) begin
                red = 8'hff;
                blue = 8'hff;
            end else if (logical_x < 240) begin
                red = 8'hff;
            end else if (logical_x < 280) begin
                blue = 8'hff;
            end else begin
                red = 8'h40;
                green = 8'h40;
                blue = 8'h40;
            end

            if (logical_x >= 144 && logical_x < 176 &&
                logical_y >= 74 && logical_y < 106) begin
                red = 8'hff;
                green = 8'h80;
                blue = 8'h00;
                if (logical_x == 144 || logical_x == 175 ||
                    logical_y == 74 || logical_y == 105) begin
                    red = 8'hff;
                    green = 8'hff;
                    blue = 8'hff;
                end
            end
        end

        vid_data = {red, blue, green};
    end

endmodule