module scene2d_index4_blit #(
    parameter integer ATLAS_WIDTH = 256
) (
    input  logic        aclk,
    input  logic        aresetn,
    input  logic        start,
    input  logic [3:0]  palette_bank,
    input  logic signed [15:0] dst_x,
    input  logic signed [15:0] dst_y,
    input  logic [15:0] width,
    input  logic [15:0] height,
    input  logic [15:0] src_x,
    input  logic [15:0] src_y,
    input  logic        flip_x,
    input  logic        flip_y,
    output logic [15:0] atlas_address,
    input  logic [3:0]  atlas_index,
    output logic        write_valid,
    output logic [15:0] write_address,
    output logic [7:0]  write_token,
    output logic        busy,
    output logic        done
);

    typedef enum logic [1:0] {IDLE, READ, SAMPLE, WRITE} state_t;
    state_t state;
    logic [3:0] active_palette_bank;
    logic signed [15:0] active_dst_x;
    logic signed [15:0] active_dst_y;
    logic [15:0] active_width;
    logic [15:0] active_height;
    logic [15:0] active_src_x;
    logic [15:0] active_src_y;
    logic active_flip_x;
    logic active_flip_y;
    logic [15:0] local_x;
    logic [15:0] local_y;
    logic [3:0] sampled_index;
    logic signed [16:0] output_x;
    logic signed [16:0] output_y;
    logic [15:0] source_x;
    logic [15:0] source_y;
    logic [15:0] output_address;

    always_comb begin
        output_x = active_dst_x + $signed({1'b0, local_x});
        output_y = active_dst_y + $signed({1'b0, local_y});
        source_x = active_src_x + (active_flip_x ? active_width - 1'b1 - local_x : local_x);
        source_y = active_src_y + (active_flip_y ? active_height - 1'b1 - local_y : local_y);
        atlas_address = source_y * ATLAS_WIDTH + source_x;
        output_address = output_y * 320 + output_x;
    end

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            state <= IDLE;
            busy <= 1'b0;
            done <= 1'b0;
            local_x <= '0;
            local_y <= '0;
            sampled_index <= '0;
            write_valid <= 1'b0;
            write_address <= '0;
            write_token <= '0;
        end else begin
            done <= 1'b0;
            write_valid <= 1'b0;
            case (state)
                IDLE: if (start) begin
                    active_palette_bank <= palette_bank;
                    active_dst_x <= dst_x;
                    active_dst_y <= dst_y;
                    active_width <= width;
                    active_height <= height;
                    active_src_x <= src_x;
                    active_src_y <= src_y;
                    active_flip_x <= flip_x;
                    active_flip_y <= flip_y;
                    local_x <= '0;
                    local_y <= '0;
                    busy <= width != 0 && height != 0;
                    state <= width != 0 && height != 0 ? READ : IDLE;
                    done <= width == 0 || height == 0;
                end
                READ: state <= SAMPLE;
                SAMPLE: begin
                    sampled_index <= atlas_index;
                    write_valid <= atlas_index != 0 &&
                        output_x >= 0 && output_x < 320 && output_y >= 0 && output_y < 180;
                    write_address <= output_address;
                    write_token <= {active_palette_bank, atlas_index};
                    state <= WRITE;
                end
                WRITE: begin
                    if (local_x + 1'b1 >= active_width) begin
                        local_x <= '0;
                        if (local_y + 1'b1 >= active_height) begin
                            busy <= 1'b0;
                            done <= 1'b1;
                            state <= IDLE;
                        end else begin
                            local_y <= local_y + 1'b1;
                            state <= READ;
                        end
                    end else begin
                        local_x <= local_x + 1'b1;
                        state <= READ;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule