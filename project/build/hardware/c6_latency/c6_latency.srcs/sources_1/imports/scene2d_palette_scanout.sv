module scene2d_palette_scanout #(
    parameter integer RUNTIME_PALETTE_ENABLE = 0
) (
    input  logic        clk_pixel,
    input  logic        resetn_pixel,
    input  logic [8:0]  logical_x,
    input  logic [7:0]  logical_y,
    input  logic        data_enable,
    input  logic        hsync,
    input  logic        vsync,
    output logic [15:0] framebuffer_address,
    input  logic [7:0]  framebuffer_token,
    output logic [7:0]  palette_read_address,
    input  logic [23:0] palette_read_rgb,
    output logic [23:0] vid_data,
    output logic        vid_de,
    output logic        vid_hsync,
    output logic        vid_vsync
);

    logic [7:0] token_stage;
    logic de_stage_1;
    logic de_stage_2;
    logic de_stage_3;
    logic hsync_stage_1;
    logic hsync_stage_2;
    logic hsync_stage_3;
    logic vsync_stage_1;
    logic vsync_stage_2;
    logic vsync_stage_3;

    function automatic logic [23:0] palette_color(input logic [7:0] token);
        logic [3:0] palette_bank;
        logic [3:0] color_index;
        begin
            palette_bank = token[7:4];
            color_index = token[3:0];
            palette_color = {
                {color_index, color_index},
                {palette_bank, palette_bank},
                {color_index ^ palette_bank, color_index ^ palette_bank}
            };
        end
    endfunction

    always_comb begin
        framebuffer_address = (logical_y << 8) + (logical_y << 6) + logical_x;
        palette_read_address = token_stage;
    end

    always_ff @(posedge clk_pixel) begin
        if (!resetn_pixel) begin
            token_stage <= '0;
            de_stage_1 <= 1'b0;
            de_stage_2 <= 1'b0;
            de_stage_3 <= 1'b0;
            hsync_stage_1 <= 1'b0;
            hsync_stage_2 <= 1'b0;
            hsync_stage_3 <= 1'b0;
            vsync_stage_1 <= 1'b0;
            vsync_stage_2 <= 1'b0;
            vsync_stage_3 <= 1'b0;
            vid_data <= '0;
            vid_de <= 1'b0;
            vid_hsync <= 1'b0;
            vid_vsync <= 1'b0;
        end else begin
            token_stage <= framebuffer_token;
            de_stage_1 <= data_enable;
            de_stage_2 <= de_stage_1;
            de_stage_3 <= de_stage_2;
            hsync_stage_1 <= hsync;
            hsync_stage_2 <= hsync_stage_1;
            hsync_stage_3 <= hsync_stage_2;
            vsync_stage_1 <= vsync;
            vsync_stage_2 <= vsync_stage_1;
            vsync_stage_3 <= vsync_stage_2;
            if (RUNTIME_PALETTE_ENABLE) begin
                vid_data <= de_stage_3
                    ? {palette_read_rgb[23:16], palette_read_rgb[7:0], palette_read_rgb[15:8]}
                    : '0;
                vid_de <= de_stage_3;
                vid_hsync <= hsync_stage_3;
                vid_vsync <= vsync_stage_3;
            end else begin
                vid_data <= de_stage_2
                    ? {palette_color(token_stage)[23:16], palette_color(token_stage)[7:0], palette_color(token_stage)[15:8]}
                    : '0;
                vid_de <= de_stage_2;
                vid_hsync <= hsync_stage_2;
                vid_vsync <= vsync_stage_2;
            end
        end
    end

endmodule