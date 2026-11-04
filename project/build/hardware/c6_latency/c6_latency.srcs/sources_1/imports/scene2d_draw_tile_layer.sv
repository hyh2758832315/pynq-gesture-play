module scene2d_draw_tile_layer #(
    parameter bit TILE_DESCRIPTOR_CACHE_ENABLE = 1'b0,
    parameter bit TILE_PIXEL_PIPELINE_ENABLE = 1'b0,
    parameter bit TILE_PIXEL_PAIR_ENABLE = 1'b0
) (
    input  logic        aclk,
    input  logic        aresetn,
    input  logic        start,
    input  logic        asset_valid,
    input  logic        tilemap_valid,
    input  logic signed [31:0] screen_x,
    input  logic signed [31:0] screen_y,
    input  logic [15:0] width_tiles,
    input  logic [15:0] height_tiles,
    input  logic [15:0] tile_size,
    input  logic [15:0] asset_width,
    input  logic [15:0] asset_height,
    input  logic [15:0] asset_stride_bytes,
    input  logic [15:0] tilemap_width_tiles,
    input  logic [15:0] tilemap_height_tiles,
    input  logic [15:0] tilemap_tile_size,
    output logic [9:0]  tilemap_read_word_address,
    input  logic [31:0] tilemap_read_word_data,
    output logic [14:0] asset_read_address,
    input  logic [7:0]  asset_read_byte,
    output logic        write_valid,
    output logic [15:0] write_address,
    output logic [7:0]  write_token,
    output logic        write_second_valid,
    output logic [7:0]  write_second_token,
    output logic        busy,
    output logic        done,
    output logic        malformed
);

    typedef enum logic [3:0] {
        IDLE, SETUP_TILE, VALIDATE_TILE, PREPARE_TILE_ROW, READ_TILE, WAIT_TILE_ADDRESS,
        WAIT_TILE_DATA, SAMPLE_TILE, READ_ASSET, WAIT_ASSET_ADDRESS,
        WAIT_ASSET_DATA, SAMPLE_ASSET, WRITE, PIPE_STREAM, PIPE_DRAIN
    } state_t;

    state_t state;
    state_t drain_resume;
    typedef struct packed {
        logic valid;
        logic high_nibble;
        logic pair_valid;
        logic [15:0] address;
    } pixel_context_t;
    pixel_context_t request_context;
    pixel_context_t response_context;
    logic pipeline_error;
    logic sampled_source_in_bounds;
    logic [3:0] response_index;
    logic [3:0] response_second_index;
    logic issue_pair;
    logic [15:0] candidate_step;
    logic [15:0] last_output_x;
    logic output_row_done;
    logic active_asset_valid;
    logic active_tilemap_valid;
    logic signed [31:0] active_screen_x;
    logic signed [31:0] active_screen_y;
    logic [15:0] active_width_tiles;
    logic [15:0] active_height_tiles;
    logic [15:0] active_tile_size;
    logic [15:0] active_asset_width;
    logic [15:0] active_asset_height;
    logic [15:0] active_asset_stride_bytes;
    logic [15:0] active_tilemap_width_tiles;
    logic [15:0] active_tilemap_height_tiles;
    logic [15:0] active_tilemap_tile_size;
    logic [4:0] tile_shift;
    logic [4:0] tiles_per_row_shift;
    logic [4:0] asset_stride_shift;
    logic [15:0] active_tiles_per_row;
    logic [15:0] output_x;
    logic [15:0] output_y;
    logic [15:0] output_left;
    logic [15:0] output_right;
    logic [15:0] output_bottom;
    logic [15:0] tilemap_row_base;
    logic [15:0] prepared_tile_y;
    logic [15:0] framebuffer_row_base;
    logic [31:0] active_tile_descriptor;
    logic descriptor_cache_valid;
    logic [31:0] descriptor_cache_address;
    logic [31:0] descriptor_address;
    logic [15:0] local_x;
    logic [15:0] local_y;
    logic [15:0] tile_x;
    logic [15:0] tile_y;
    logic [15:0] pixel_x;
    logic [15:0] pixel_y;
    logic [15:0] source_x;
    logic [15:0] source_y;
    logic [3:0] source_index;
    logic [15:0] source_tile_id;
    logic [15:0] source_tile_column;
    logic [15:0] source_tile_row;
    logic [15:0] source_origin_x;
    logic [15:0] source_origin_y;
    logic [15:0] descriptor_run_right;
    logic [3:0] source_palette_bank;
    logic source_flip_x;
    logic source_flip_y;
    logic descriptor_in_bounds;
    logic source_in_bounds;

    function automatic logic is_power_of_two(input logic [15:0] value);
        begin
            is_power_of_two = value != 0 && (value & (value - 1'b1)) == 0;
        end
    endfunction

    function automatic logic [4:0] power_of_two_shift(input logic [15:0] value);
        begin
            power_of_two_shift = '0;
            for (int index = 0; index < 16; index = index + 1) begin
                if (value == (16'd1 << index)) begin
                    power_of_two_shift = index;
                end
            end
        end
    endfunction

    function automatic logic [15:0] clip_x(input logic signed [31:0] value);
        begin
            if (value < 0) begin
                clip_x = 0;
            end else if (value > 320) begin
                clip_x = 320;
            end else begin
                clip_x = value[15:0];
            end
        end
    endfunction

    function automatic logic [15:0] clip_y(input logic signed [31:0] value);
        begin
            if (value < 0) begin
                clip_y = 0;
            end else if (value > 180) begin
                clip_y = 180;
            end else begin
                clip_y = value[15:0];
            end
        end
    endfunction

    function automatic logic signed [31:0] tile_extent(
        input logic [15:0] tile_count,
        input logic [4:0] shift_amount
    );
        begin
            tile_extent = $signed({16'd0, tile_count} << shift_amount);
        end
    endfunction

    always_comb begin
        local_x = output_x - active_screen_x;
        local_y = output_y - active_screen_y;
        tile_x = local_x >> tile_shift;
        tile_y = local_y >> tile_shift;
        descriptor_address = 32'd4 + {16'd0, tilemap_row_base} + {16'd0, tile_x};
        pixel_x = local_x & (active_tile_size - 1'b1);
        pixel_y = local_y & (active_tile_size - 1'b1);
        source_tile_id = active_tile_descriptor[15:0];
        source_palette_bank = active_tile_descriptor[19:16];
        source_flip_x = active_tile_descriptor[20];
        source_flip_y = active_tile_descriptor[21];
        source_tile_column = source_tile_id & (active_tiles_per_row - 1'b1);
        source_tile_row = source_tile_id >> tiles_per_row_shift;
        if (TILE_PIXEL_PIPELINE_ENABLE) begin
            source_x = source_origin_x | (pixel_x ^ (source_flip_x ? active_tile_size - 1'b1 : 16'd0));
            source_y = source_origin_y | (pixel_y ^ (source_flip_y ? active_tile_size - 1'b1 : 16'd0));
        end else begin
            source_x = (source_tile_column << tile_shift) +
                (source_flip_x ? active_tile_size - 1'b1 - pixel_x : pixel_x);
            source_y = (source_tile_row << tile_shift) +
                (source_flip_y ? active_tile_size - 1'b1 - pixel_y : pixel_y);
        end
        source_index = source_x[0] ? asset_read_byte[7:4] : asset_read_byte[3:0];
        response_index = response_context.high_nibble ? asset_read_byte[7:4] : asset_read_byte[3:0];
        response_second_index = response_context.high_nibble ? asset_read_byte[3:0] : asset_read_byte[7:4];
        issue_pair = TILE_PIXEL_PAIR_ENABLE && TILE_PIXEL_PIPELINE_ENABLE &&
            TILE_DESCRIPTOR_CACHE_ENABLE && descriptor_cache_valid && active_tile_size > 1 &&
            !output_x[0] && !active_screen_x[0] &&
            output_x < last_output_x && output_x < descriptor_run_right;
        candidate_step = issue_pair ? 16'd2 : 16'd1;
        output_row_done = output_x[15:1] == last_output_x[15:1] &&
            (issue_pair || output_x[0] == last_output_x[0]);
        descriptor_in_bounds = tile_x < active_width_tiles && tile_y < active_height_tiles &&
            tilemap_read_word_data[31:22] == 0;
        source_in_bounds = source_x < active_asset_width && source_y < active_asset_height;
    end

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            sampled_source_in_bounds <= 1'b0;
            state <= IDLE;
            drain_resume <= IDLE;
            request_context <= '0;
            response_context <= '0;
            pipeline_error <= 1'b0;
            busy <= 1'b0;
            done <= 1'b0;
            malformed <= 1'b0;
            write_valid <= 1'b0;
            write_second_valid <= 1'b0;
            write_second_token <= '0;
            write_address <= '0;
            write_token <= '0;
            tilemap_read_word_address <= '0;
            asset_read_address <= '0;
            active_asset_valid <= 1'b0;
            active_tilemap_valid <= 1'b0;
            active_screen_x <= '0;
            active_screen_y <= '0;
            active_width_tiles <= '0;
            active_height_tiles <= '0;
            active_tile_size <= '0;
            active_asset_width <= '0;
            active_asset_height <= '0;
            active_asset_stride_bytes <= '0;
            active_tilemap_width_tiles <= '0;
            active_tilemap_height_tiles <= '0;
            active_tilemap_tile_size <= '0;
            tile_shift <= '0;
            tiles_per_row_shift <= '0;
            asset_stride_shift <= '0;
            active_tiles_per_row <= '0;
            output_x <= '0;
            output_y <= '0;
            output_left <= '0;
            output_right <= '0;
            output_bottom <= '0;
            tilemap_row_base <= '0;
            prepared_tile_y <= '0;
            framebuffer_row_base <= '0;
            active_tile_descriptor <= '0;
            source_origin_x <= '0;
            source_origin_y <= '0;
            descriptor_run_right <= '0;
            last_output_x <= '0;
            descriptor_cache_valid <= 1'b0;
            descriptor_cache_address <= '0;
        end else begin
            done <= 1'b0;
            write_valid <= 1'b0;
            write_second_valid <= 1'b0;
            malformed <= 1'b0;
            if (TILE_PIXEL_PIPELINE_ENABLE) begin
                request_context.valid <= 1'b0;
                response_context <= request_context;
                if (response_context.valid) begin
                    write_valid <= response_index != 0;
                    write_address <= response_context.address;
                    write_token <= {source_palette_bank, response_index};
                    write_second_valid <= response_context.pair_valid && response_second_index != 0;
                    write_second_token <= {source_palette_bank, response_second_index};
                end
            end
            case (state)
                IDLE: if (start) begin
                    descriptor_cache_valid <= 1'b0;
                    pipeline_error <= 1'b0;
                    active_asset_valid <= asset_valid;
                    active_tilemap_valid <= tilemap_valid;
                    active_screen_x <= screen_x;
                    active_screen_y <= screen_y;
                    active_width_tiles <= width_tiles;
                    active_height_tiles <= height_tiles;
                    active_tile_size <= tile_size;
                    active_asset_width <= asset_width;
                    active_asset_height <= asset_height;
                    active_asset_stride_bytes <= asset_stride_bytes;
                    active_tilemap_width_tiles <= tilemap_width_tiles;
                    active_tilemap_height_tiles <= tilemap_height_tiles;
                    active_tilemap_tile_size <= tilemap_tile_size;
                    tilemap_row_base <= '0;
                    prepared_tile_y <= '0;
                    busy <= 1'b1;
                    state <= SETUP_TILE;
                end
                SETUP_TILE: begin
                    active_tiles_per_row <= active_asset_width >>
                        power_of_two_shift(active_tile_size);
                    tile_shift <= power_of_two_shift(active_tile_size);
                    tiles_per_row_shift <= power_of_two_shift(
                        active_asset_width >> power_of_two_shift(active_tile_size)
                    );
                    asset_stride_shift <= power_of_two_shift(active_asset_stride_bytes);
                    output_left <= clip_x(active_screen_x);
                    output_right <= clip_x(active_screen_x + tile_extent(
                        active_width_tiles, power_of_two_shift(active_tile_size)
                    ));
                    last_output_x <= clip_x(active_screen_x + tile_extent(
                        active_width_tiles, power_of_two_shift(active_tile_size)
                    )) - 16'd1;
                    output_bottom <= clip_y(active_screen_y + tile_extent(
                        active_height_tiles, power_of_two_shift(active_tile_size)
                    ));
                    output_x <= clip_x(active_screen_x);
                    output_y <= clip_y(active_screen_y);
                    framebuffer_row_base <= (clip_y(active_screen_y) << 8) +
                        (clip_y(active_screen_y) << 6);
                    state <= VALIDATE_TILE;
                end
                VALIDATE_TILE: begin
                    if (!active_asset_valid || !active_tilemap_valid || active_width_tiles == 0 ||
                        active_height_tiles == 0 || !is_power_of_two(active_tile_size) ||
                        active_tile_size != active_tilemap_tile_size ||
                        active_width_tiles != active_tilemap_width_tiles ||
                        active_height_tiles != active_tilemap_height_tiles ||
                        (active_asset_width & (active_tile_size - 1'b1)) != 0 ||
                        active_asset_stride_bytes != (active_asset_width >> 1) ||
                        !is_power_of_two(active_asset_stride_bytes) ||
                        !is_power_of_two(active_tiles_per_row) ||
                        active_asset_height < active_tile_size ||
                        output_left >= output_right || output_y >= output_bottom) begin
                        done <= 1'b1;
                        busy <= 1'b0;
                        malformed <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= PREPARE_TILE_ROW;
                    end
                end
                PREPARE_TILE_ROW: begin
                    if (prepared_tile_y < tile_y) begin
                        tilemap_row_base <= tilemap_row_base + active_width_tiles;
                        prepared_tile_y <= prepared_tile_y + 1'b1;
                    end else begin
                        state <= READ_TILE;
                    end
                end
                READ_TILE: begin
                    if (TILE_DESCRIPTOR_CACHE_ENABLE && descriptor_cache_valid &&
                        descriptor_cache_address == descriptor_address &&
                        tile_x < active_width_tiles && tile_y < active_height_tiles) begin
                        state <= READ_ASSET;
                    end else begin
                        tilemap_read_word_address <= descriptor_address[9:0];
                        state <= WAIT_TILE_ADDRESS;
                    end
                end
                WAIT_TILE_ADDRESS: state <= WAIT_TILE_DATA;
                WAIT_TILE_DATA: state <= SAMPLE_TILE;
                SAMPLE_TILE: begin
                    active_tile_descriptor <= tilemap_read_word_data;
                    if (!descriptor_in_bounds) begin
                        busy <= 1'b0;
                        done <= 1'b1;
                        malformed <= 1'b1;
                        state <= IDLE;
                    end else begin
                        if (TILE_PIXEL_PIPELINE_ENABLE) begin
                            source_origin_x <= (tilemap_read_word_data[15:0] & (active_tiles_per_row - 1'b1)) << tile_shift;
                            source_origin_y <= (tilemap_read_word_data[15:0] >> tiles_per_row_shift) << tile_shift;
                            descriptor_run_right <= output_x + active_tile_size - pixel_x;
                        end
                        descriptor_cache_valid <= TILE_DESCRIPTOR_CACHE_ENABLE;
                        descriptor_cache_address <= descriptor_address;
                        state <= READ_ASSET;
                    end
                end
                READ_ASSET, PIPE_STREAM: begin
                    if (TILE_PIXEL_PIPELINE_ENABLE) begin
                        if (state == PIPE_STREAM && (!descriptor_cache_valid ||
                            output_x >= descriptor_run_right)) begin
                            drain_resume <= READ_TILE;
                            state <= PIPE_DRAIN;
                        end else if (!source_in_bounds) begin
                            pipeline_error <= 1'b1;
                            drain_resume <= IDLE;
                            state <= PIPE_DRAIN;
                        end else begin
                            asset_read_address <= (source_y << asset_stride_shift) + (source_x >> 1);
                            request_context.valid <= 1'b1;
                            request_context.high_nibble <= source_x[0];
                            request_context.pair_valid <= issue_pair;
                            request_context.address <= framebuffer_row_base + output_x;
                            if (TILE_PIXEL_PAIR_ENABLE ? output_row_done : output_x + 1'b1 >= output_right) begin
                                output_x <= output_left;
                                state <= PIPE_DRAIN;
                                if (output_y + 1'b1 >= output_bottom) begin
                                    drain_resume <= IDLE;
                                end else begin
                                    output_y <= output_y + 1'b1;
                                    framebuffer_row_base <= framebuffer_row_base + 16'd320;
                                    drain_resume <= PREPARE_TILE_ROW;
                                end
                            end else begin
                                output_x <= output_x + candidate_step;
                                if (TILE_DESCRIPTOR_CACHE_ENABLE) begin
                                    state <= PIPE_STREAM;
                                end else begin
                                    drain_resume <= READ_TILE;
                                    state <= PIPE_DRAIN;
                                end
                            end
                        end
                    end else begin
                        asset_read_address <= (source_y << asset_stride_shift) + (source_x >> 1);
                        state <= WAIT_ASSET_ADDRESS;
                    end
                end
                PIPE_DRAIN: begin
                    if (!request_context.valid && !response_context.valid && !write_valid && !write_second_valid) begin
                        state <= drain_resume;
                        if (drain_resume == IDLE) begin
                            busy <= 1'b0;
                            done <= 1'b1;
                            malformed <= pipeline_error;
                        end
                    end
                end
                WAIT_ASSET_ADDRESS: begin
                    sampled_source_in_bounds <= source_in_bounds;
                    state <= WAIT_ASSET_DATA;
                end
                WAIT_ASSET_DATA: state <= SAMPLE_ASSET;
                SAMPLE_ASSET: begin
                    if (!sampled_source_in_bounds) begin
                        busy <= 1'b0;
                        done <= 1'b1;
                        malformed <= 1'b1;
                        state <= IDLE;
                    end else begin
                        write_valid <= source_index != 0;
                        write_address <= framebuffer_row_base + output_x;
                        write_token <= {source_palette_bank, source_index};
                        state <= WRITE;
                    end
                end
                WRITE: begin
                    if (output_x + 1'b1 >= output_right) begin
                        output_x <= output_left;
                        if (output_y + 1'b1 >= output_bottom) begin
                            busy <= 1'b0;
                            done <= 1'b1;
                            state <= IDLE;
                        end else begin
                            output_y <= output_y + 1'b1;
                            framebuffer_row_base <= framebuffer_row_base + 16'd320;
                            state <= PREPARE_TILE_ROW;
                        end
                    end else begin
                        output_x <= output_x + 1'b1;
                        state <= READ_TILE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
