module scene2d_video_timing #(
    parameter int H_ACTIVE = 1280,
    parameter int H_FRONT = 110,
    parameter int H_SYNC = 40,
    parameter int H_BACK = 220,
    parameter int V_ACTIVE = 720,
    parameter int V_FRONT = 5,
    parameter int V_SYNC = 5,
    parameter int V_BACK = 20,
    parameter int OUTPUT_SCALE = 4
) (
    input  logic        clk_pixel,
    input  logic        resetn_pixel,
    output logic [10:0] pixel_x,
    output logic [9:0]  pixel_y,
    output logic [8:0]  logical_x,
    output logic [7:0]  logical_y,
    output logic        data_enable,
    output logic        hsync,
    output logic        vsync,
    output logic        frame_start,
    output logic        vblank_start,
    output logic        line_start
);

    localparam int H_TOTAL = H_ACTIVE + H_FRONT + H_SYNC + H_BACK;
    localparam int V_TOTAL = V_ACTIVE + V_FRONT + V_SYNC + V_BACK;
    localparam int H_SYNC_START = H_ACTIVE + H_FRONT;
    localparam int H_SYNC_END = H_SYNC_START + H_SYNC;
    localparam int V_SYNC_START = V_ACTIVE + V_FRONT;
    localparam int V_SYNC_END = V_SYNC_START + V_SYNC;

    always_ff @(posedge clk_pixel) begin
        if (!resetn_pixel) begin
            pixel_x <= '0;
            pixel_y <= '0;
        end else if (pixel_x == H_TOTAL - 1) begin
            pixel_x <= '0;
            if (pixel_y == V_TOTAL - 1) begin
                pixel_y <= '0;
            end else begin
                pixel_y <= pixel_y + 1'b1;
            end
        end else begin
            pixel_x <= pixel_x + 1'b1;
        end
    end

    always_comb begin
        data_enable = resetn_pixel && pixel_x < H_ACTIVE && pixel_y < V_ACTIVE;
        hsync = resetn_pixel && pixel_x >= H_SYNC_START && pixel_x < H_SYNC_END;
        vsync = resetn_pixel && pixel_y >= V_SYNC_START && pixel_y < V_SYNC_END;
        frame_start = resetn_pixel && pixel_x == 0 && pixel_y == 0;
        vblank_start = resetn_pixel && pixel_x == 0 && pixel_y == V_ACTIVE;
        line_start = resetn_pixel && pixel_x == 0;
        logical_x = data_enable ? pixel_x / OUTPUT_SCALE : '0;
        logical_y = data_enable ? pixel_y / OUTPUT_SCALE : '0;
    end

endmodule