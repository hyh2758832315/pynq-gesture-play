module scene2d_index4_asset_blit #(
    parameter bit BLIT_PIXEL_PIPELINE_ENABLE = 1'b0,
    parameter bit BLIT_PIXEL_PAIR_ENABLE = 1'b0
) (
    input  logic        aclk,
    input  logic        aresetn,
    input  logic        start,
    input  logic        asset_valid,
    input  logic [3:0]  palette_bank,
    input  logic signed [15:0] dst_x,
    input  logic signed [15:0] dst_y,
    input  logic [15:0] width,
    input  logic [15:0] height,
    input  logic [15:0] src_x,
    input  logic [15:0] src_y,
    input  logic [15:0] asset_width,
    input  logic [15:0] asset_height,
    input  logic [15:0] asset_stride_bytes,
    input  logic        flip_x,
    input  logic        flip_y,
    output logic [14:0] asset_read_address,
    input  logic [7:0]  asset_read_byte,
    output logic        write_valid,
    output logic [15:0] write_address,
    output logic [7:0]  write_token,
    output logic        write_second_valid,
    output logic [7:0]  write_second_token,
    output logic        busy,
    output logic        done
);

    typedef enum logic [2:0] {IDLE, READ, WAIT_ADDRESS, WAIT_DATA, SAMPLE, WRITE} state_t;

    state_t state;
    logic [3:0] active_palette_bank;
    logic signed [15:0] active_dst_x;
    logic signed [15:0] active_dst_y;
    logic [15:0] active_width;
    logic [15:0] active_height;
    logic [15:0] active_src_x;
    logic [15:0] active_src_y;
    logic [15:0] active_asset_stride_bytes;
    logic active_flip_x;
    logic active_flip_y;
    logic [15:0] local_x;
    logic [15:0] local_y;
    logic signed [16:0] output_x;
    logic signed [16:0] output_y;
    logic [15:0] source_x;
    logic [15:0] source_y;
    logic [14:0] source_byte_address;
    logic [3:0] source_index;
    logic [15:0] output_address;
    logic source_in_bounds;
    logic pair_source_compatible;
    logic [15:0] last_local_x;
    logic [15:0] last_pair_local_x;
    logic output_row_done;
    logic issue_pair;
    logic [15:0] candidate_step;
    typedef struct packed {
        logic valid;
        logic drawable;
        logic pair_valid;
        logic high_nibble;
        logic [15:0] address;
    } pixel_context_t;
    pixel_context_t request_context;
    pixel_context_t response_context;
    logic [3:0] response_index;
    logic [3:0] response_second_index;

    always_comb begin
        output_x = active_dst_x + $signed({1'b0, local_x});
        output_y = active_dst_y + $signed({1'b0, local_y});
        source_x = active_src_x + (
            active_flip_x ? active_width - 1'b1 - local_x : local_x
        );
        source_y = active_src_y + (
            active_flip_y ? active_height - 1'b1 - local_y : local_y
        );
        source_byte_address = source_y * active_asset_stride_bytes +
            (source_x >> 1);
        source_index = source_x[0]
            ? asset_read_byte[7:4]
            : asset_read_byte[3:0];
        output_address = output_y * 320 + output_x;
        source_in_bounds = source_x < active_src_x + active_width &&
            source_y < active_src_y + active_height;
        response_index = response_context.high_nibble
            ? asset_read_byte[7:4] : asset_read_byte[3:0];
        response_second_index = response_context.high_nibble
            ? asset_read_byte[3:0] : asset_read_byte[7:4];
        issue_pair = BLIT_PIXEL_PAIR_ENABLE && BLIT_PIXEL_PIPELINE_ENABLE &&
            pair_source_compatible && local_x < last_local_x && !output_x[0] &&
            output_x >= 0 && output_x < 319 && output_y >= 0 && output_y < 180;
        candidate_step = issue_pair ? 16'd2 : 16'd1;
        output_row_done = local_x == last_local_x ||
            (issue_pair && local_x == last_pair_local_x);
    end

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            state <= IDLE;
            busy <= 1'b0;
            done <= 1'b0;
            local_x <= '0;
            local_y <= '0;
            write_valid <= 1'b0;
            write_address <= '0;
            write_token <= '0;
            write_second_valid <= 1'b0;
            write_second_token <= '0;
            active_palette_bank <= '0;
            active_dst_x <= '0;
            active_dst_y <= '0;
            active_width <= '0;
            active_height <= '0;
            active_src_x <= '0;
            active_src_y <= '0;
            active_asset_stride_bytes <= '0;
            active_flip_x <= 1'b0;
            active_flip_y <= 1'b0;
            pair_source_compatible <= 1'b0;
            last_local_x <= '0;
            last_pair_local_x <= '0;
            asset_read_address <= '0;
            request_context <= '0;
            response_context <= '0;
        end else begin
            done <= 1'b0;
            write_valid <= 1'b0;
            write_second_valid <= 1'b0;
            if (BLIT_PIXEL_PIPELINE_ENABLE) begin
                request_context.valid <= 1'b0;
                response_context <= request_context;
                if (response_context.valid) begin
                    write_valid <= response_context.drawable && response_index != 0;
                    write_address <= response_context.address;
                    write_token <= {active_palette_bank, response_index};
                    write_second_valid <= response_context.pair_valid && response_second_index != 0;
                    write_second_token <= {active_palette_bank, response_second_index};
                end
            end
            case (state)
                IDLE: if (start) begin
                    active_palette_bank <= palette_bank;
                    active_dst_x <= dst_x;
                    active_dst_y <= dst_y;
                    active_width <= width;
                    active_height <= height;
                    active_src_x <= src_x;
                    active_src_y <= src_y;
                    active_asset_stride_bytes <= asset_stride_bytes;
                    active_flip_x <= flip_x;
                    active_flip_y <= flip_y;
                    pair_source_compatible <=
                        (dst_x[0] ^ src_x[0] ^ (flip_x && width[0])) == 1'b0 &&
                        ({1'b0, src_x} + {1'b0, width}) <= 17'h0FFFF &&
                        ({1'b0, src_y} + {1'b0, height}) <= 17'h0FFFF;
                    last_local_x <= width - 16'd1;
                    last_pair_local_x <= width - 16'd2;
                    local_x <= '0;
                    local_y <= '0;
                    busy <= asset_valid && width != 0 && height != 0 &&
                        src_x + width <= asset_width &&
                        src_y + height <= asset_height;
                    done <= !asset_valid || width == 0 || height == 0 ||
                        src_x + width > asset_width ||
                        src_y + height > asset_height;
                    state <= asset_valid && width != 0 && height != 0 &&
                        src_x + width <= asset_width &&
                        src_y + height <= asset_height ? READ : IDLE;
                end
                READ: begin
                    asset_read_address <= source_byte_address;
                    if (BLIT_PIXEL_PIPELINE_ENABLE) begin
                        request_context.valid <= 1'b1;
                        request_context.drawable <= source_in_bounds &&
                            output_x >= 0 && output_x < 320 &&
                            output_y >= 0 && output_y < 180;
                        request_context.high_nibble <= source_x[0];
                        request_context.pair_valid <= issue_pair;
                        request_context.address <= output_address;
                        if (BLIT_PIXEL_PAIR_ENABLE ? output_row_done : local_x + 16'd1 >= active_width) begin
                            local_x <= '0;
                            if (local_y + 1'b1 >= active_height) begin
                                state <= WRITE;
                            end else begin
                                local_y <= local_y + 1'b1;
                            end
                        end else begin
                            local_x <= local_x + candidate_step;
                        end
                    end else begin
                        state <= WAIT_ADDRESS;
                    end
                end
                WAIT_ADDRESS: state <= WAIT_DATA;
                WAIT_DATA: state <= SAMPLE;
                SAMPLE: begin
                    write_valid <= source_in_bounds && source_index != 0 &&
                        output_x >= 0 && output_x < 320 &&
                        output_y >= 0 && output_y < 180;
                    write_address <= output_address;
                    write_token <= {active_palette_bank, source_index};
                    state <= WRITE;
                end
                WRITE: begin
                    if (BLIT_PIXEL_PIPELINE_ENABLE) begin
                        if (!request_context.valid && !response_context.valid && !write_valid && !write_second_valid) begin
                            busy <= 1'b0;
                            done <= 1'b1;
                            state <= IDLE;
                        end
                    end else if (local_x + 1'b1 >= active_width) begin
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