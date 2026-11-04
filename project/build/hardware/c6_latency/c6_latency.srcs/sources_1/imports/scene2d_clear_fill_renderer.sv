module scene2d_clear_fill_renderer #(
    parameter integer WATCHDOG_CYCLES = 1200000,
    parameter integer ATLAS_WIDTH = 256,
    parameter integer ATLAS_HEIGHT = 256,
    parameter bit TILE_DESCRIPTOR_CACHE_ENABLE = 1'b0,
    parameter bit BLIT_PIXEL_PIPELINE_ENABLE = 1'b0,
    parameter bit TILE_PIXEL_PIPELINE_ENABLE = 1'b0,
    parameter bit TILE_PIXEL_PAIR_ENABLE = 1'b0,
    parameter bit BLIT_PIXEL_PAIR_ENABLE = 1'b0,
    parameter bit CLEAR_FILL_PIXEL_PAIR_ENABLE = 1'b0
) (
    input  logic        aclk,
    input  logic        aresetn,
    input  logic        start,
    input  logic [31:0] submit_seq,
    input  logic [8:0]  command_count,
    output logic [8:0]  command_read_address,
    input  logic [63:0] command_read_data,
    output logic [15:0] atlas_read_address,
    input  logic [3:0]  atlas_read_index,
    input  logic        runtime_asset_enable,
    input  logic        runtime_asset_valid,
    input  logic [15:0] runtime_asset_width,
    input  logic [15:0] runtime_asset_height,
    input  logic [15:0] runtime_asset_stride_bytes,
    output logic [1:0]  runtime_asset_id,
    output logic [14:0] runtime_asset_read_address,
    input  logic [7:0]  runtime_asset_read_byte,
    input  logic        runtime_tilemap_enable,
    input  logic        runtime_tilemap_valid,
    input  logic [15:0] runtime_tilemap_width_tiles,
    input  logic [15:0] runtime_tilemap_height_tiles,
    input  logic [15:0] runtime_tilemap_tile_size,
    output logic [1:0]  runtime_tilemap_id,
    output logic [9:0]  runtime_tilemap_read_word_address,
    input  logic [31:0] runtime_tilemap_read_word_data,
    output logic        write_valid,
    output logic [15:0] write_address,
    output logic [7:0]  write_token,
    output logic        write_second_valid,
    output logic [7:0]  write_second_token,
    output logic        busy,
    output logic        done,
    output logic [31:0] completed_seq,
    output logic [31:0] completed_write_count,
    output logic [31:0] completed_trace_crc32,
    output logic [31:0] completed_cycles,
    output logic [31:0] maximum_cycles,
    output logic [3:0]  last_error_flags,
    output logic [3:0]  sticky_error_flags,
    output logic [7:0]  first_error_command
);

    localparam logic [7:0] OPCODE_CLEAR = 8'd1;
    localparam logic [7:0] OPCODE_DRAW_TILE_LAYER = 8'd2;
    localparam logic [7:0] OPCODE_BLIT_INDEX4 = 8'd3;
    localparam logic [7:0] OPCODE_FILL_RECT = 8'd4;
    localparam logic [7:0] OPCODE_END_FRAME = 8'hFF;
    localparam logic [3:0] ERROR_UNSUPPORTED = 4'b0001;
    localparam logic [3:0] ERROR_MALFORMED = 4'b0010;
    localparam logic [3:0] ERROR_MISSING_END = 4'b0100;
    localparam logic [3:0] ERROR_WATCHDOG = 4'b1000;
    localparam logic [15:0] FRAME_PIXELS = 16'd57600;
    localparam logic [15:0] CLEAR_STEP = CLEAR_FILL_PIXEL_PAIR_ENABLE ? 16'd2 : 16'd1;
    localparam logic [31:0] WATCHDOG_LAST_CYCLE = WATCHDOG_CYCLES - 1;
    localparam bit PIXEL_PAIR_ENABLE = TILE_PIXEL_PAIR_ENABLE || BLIT_PIXEL_PAIR_ENABLE || CLEAR_FILL_PIXEL_PAIR_ENABLE;

    typedef enum logic [3:0] {
        STATE_IDLE,
        STATE_FETCH_PRIME,
        STATE_FETCH_WORD0,
        STATE_FETCH_WORD1,
        STATE_FETCH_WORD2,
        STATE_FETCH_WORD3,
        STATE_DECODE,
        STATE_CLEAR,
        STATE_FILL,
        STATE_FINISH
    } state_t;

    state_t state;
    logic [31:0] command_words [0:7];
    logic [7:0] command_index;
    logic [8:0] latched_command_count;
    logic [31:0] latched_submit_seq;
    logic [15:0] clear_address;
    logic [15:0] fill_x;
    logic [15:0] fill_right;
    logic [15:0] fill_y;
    logic [15:0] fill_bottom;
    logic [15:0] fill_address;
    logic [7:0] active_token;
    logic [31:0] active_write_count;
    logic [31:0] active_trace_crc32;
    logic [31:0] active_cycles;
    logic [31:0] trace_crc32_next;
    logic [15:0] write_second_address;
    logic [1:0] write_pixel_count;
    logic [31:0] crc_single_word;
    logic [63:0] crc_pair_words;
    wire [31:0] parallel_single_crc;
    wire [31:0] parallel_pair_crc;
    logic [3:0] pending_error_flags;
    logic blit_start;
    logic runtime_blit_start;
    logic blit_busy;
    logic blit_done;
    logic blit_write_valid;
    logic [15:0] blit_write_address;
    logic [7:0] blit_write_token;
    logic runtime_blit_busy;
    logic runtime_blit_done;
    logic runtime_blit_write_valid;
    logic runtime_blit_write_second_valid;
    logic [7:0] runtime_blit_write_second_token;
    logic [15:0] runtime_blit_write_address;
    logic [7:0] runtime_blit_write_token;
    logic [14:0] runtime_blit_asset_read_address;
    logic tile_start;
    logic tile_busy;
    logic tile_done;
    logic tile_malformed;
    logic tile_write_valid;
    logic tile_write_second_valid;
    logic [7:0] tile_write_second_token;
    logic [15:0] tile_write_address;
    logic [7:0] tile_write_token;
    logic [14:0] tile_asset_read_address;
    logic [15:0] fill_step;

    scene2d_index4_blit #(
        .ATLAS_WIDTH(ATLAS_WIDTH)
    ) blit (
        .aclk,
        .aresetn,
        .start(blit_start),
        .palette_bank(command_words[1][19:16]),
        .dst_x(command_words[2][15:0]),
        .dst_y(command_words[2][31:16]),
        .width(command_words[3][15:0]),
        .height(command_words[3][31:16]),
        .src_x(command_words[4][15:0]),
        .src_y(command_words[4][31:16]),
        .flip_x(command_words[0][8]),
        .flip_y(command_words[0][9]),
        .atlas_address(atlas_read_address),
        .atlas_index(atlas_read_index),
        .write_valid(blit_write_valid),
        .write_address(blit_write_address),
        .write_token(blit_write_token),
        .busy(blit_busy),
        .done(blit_done)
    );

    scene2d_index4_asset_blit #(
        .BLIT_PIXEL_PIPELINE_ENABLE(BLIT_PIXEL_PIPELINE_ENABLE),
        .BLIT_PIXEL_PAIR_ENABLE(BLIT_PIXEL_PAIR_ENABLE)
    ) runtime_blit (
        .aclk,
        .aresetn(aresetn && (!BLIT_PIXEL_PIPELINE_ENABLE ||
            (state == STATE_FILL && command_words[0][7:0] == OPCODE_BLIT_INDEX4 &&
                active_cycles != WATCHDOG_LAST_CYCLE))),
        .start(runtime_blit_start),
        .asset_valid(runtime_asset_valid),
        .palette_bank(command_words[1][19:16]),
        .dst_x(command_words[2][15:0]),
        .dst_y(command_words[2][31:16]),
        .width(command_words[3][15:0]),
        .height(command_words[3][31:16]),
        .src_x(command_words[4][15:0]),
        .src_y(command_words[4][31:16]),
        .asset_width(runtime_asset_width),
        .asset_height(runtime_asset_height),
        .asset_stride_bytes(runtime_asset_stride_bytes),
        .flip_x(command_words[0][8]),
        .flip_y(command_words[0][9]),
        .asset_read_address(runtime_blit_asset_read_address),
        .asset_read_byte(runtime_asset_read_byte),
        .write_valid(runtime_blit_write_valid),
        .write_address(runtime_blit_write_address),
        .write_token(runtime_blit_write_token),
        .write_second_valid(runtime_blit_write_second_valid),
        .write_second_token(runtime_blit_write_second_token),
        .busy(runtime_blit_busy),
        .done(runtime_blit_done)
    );

    scene2d_draw_tile_layer #(
        .TILE_DESCRIPTOR_CACHE_ENABLE(TILE_DESCRIPTOR_CACHE_ENABLE),
        .TILE_PIXEL_PIPELINE_ENABLE(TILE_PIXEL_PIPELINE_ENABLE),
        .TILE_PIXEL_PAIR_ENABLE(TILE_PIXEL_PAIR_ENABLE)
    ) tile_layer (
        .aclk,
        .aresetn(aresetn && (!TILE_PIXEL_PIPELINE_ENABLE ||
            (state == STATE_FILL && command_words[0][7:0] == OPCODE_DRAW_TILE_LAYER &&
                active_cycles != WATCHDOG_LAST_CYCLE))),
        .start(tile_start),
        .asset_valid(runtime_asset_valid),
        .tilemap_valid(runtime_tilemap_valid),
        .screen_x(command_words[2]),
        .screen_y(command_words[3]),
        .width_tiles(command_words[4][15:0]),
        .height_tiles(command_words[4][31:16]),
        .tile_size(command_words[5][15:0]),
        .asset_width(runtime_asset_width),
        .asset_height(runtime_asset_height),
        .asset_stride_bytes(runtime_asset_stride_bytes),
        .tilemap_width_tiles(runtime_tilemap_width_tiles),
        .tilemap_height_tiles(runtime_tilemap_height_tiles),
        .tilemap_tile_size(runtime_tilemap_tile_size),
        .tilemap_read_word_address(runtime_tilemap_read_word_address),
        .tilemap_read_word_data(runtime_tilemap_read_word_data),
        .asset_read_address(tile_asset_read_address),
        .asset_read_byte(runtime_asset_read_byte),
        .write_valid(tile_write_valid),
        .write_address(tile_write_address),
        .write_token(tile_write_token),
        .write_second_valid(tile_write_second_valid),
        .write_second_token(tile_write_second_token),
        .busy(tile_busy),
        .done(tile_done),
        .malformed(tile_malformed)
    );

    function automatic logic [31:0] crc32_byte(
        input logic [31:0] crc,
        input logic [7:0] data
    );
        logic [31:0] next_crc;
        integer bit_index;
        begin
            next_crc = crc ^ data;
            for (bit_index = 0; bit_index < 8; bit_index = bit_index + 1) begin
                if (next_crc[0]) begin
                    next_crc = (next_crc >> 1) ^ 32'hEDB88320;
                end else begin
                    next_crc = next_crc >> 1;
                end
            end
            return next_crc;
        end
    endfunction

    function automatic logic [95:0] crc32_mask(input integer output_bit, input integer byte_count);
        logic [31:0] basis_crc;
        logic [63:0] basis_data;
        logic [95:0] result_mask;
        begin
            result_mask = '0;
            for (integer input_bit = 0; input_bit < 96; input_bit++) begin
                basis_crc = input_bit < 32 ? 32'd1 << input_bit : 32'd0;
                basis_data = input_bit >= 32 ? 64'd1 << (input_bit - 32) : 64'd0;
                for (integer byte_index = 0; byte_index < byte_count; byte_index++)
                    basis_crc = crc32_byte(basis_crc, basis_data[byte_index * 8 +: 8]);
                result_mask[input_bit] = basis_crc[output_bit];
            end
            return result_mask;
        end
    endfunction

    generate
        if (PIXEL_PAIR_ENABLE) begin : parallel_crc
            for (genvar output_bit = 0; output_bit < 32; output_bit++) begin : crc_bit
                localparam logic [95:0] SINGLE_MASK = crc32_mask(output_bit, 4);
                localparam logic [95:0] PAIR_MASK = crc32_mask(output_bit, 8);
                assign parallel_single_crc[output_bit] = ^({crc_single_word, active_trace_crc32} & SINGLE_MASK[63:0]);
                assign parallel_pair_crc[output_bit] = ^({crc_pair_words, active_trace_crc32} & PAIR_MASK);
            end
        end else begin : legacy_crc
            assign parallel_single_crc = '0;
            assign parallel_pair_crc = '0;
        end
    endgenerate

    function automatic logic [15:0] clamp_x(input logic signed [17:0] value);
        if (value < 0) begin
            return 16'd0;
        end
        if (value > 18'sd320) begin
            return 16'd320;
        end
        return value[15:0];
    endfunction

    function automatic logic [15:0] clamp_y(input logic signed [17:0] value);
        if (value < 0) begin
            return 16'd0;
        end
        if (value > 18'sd180) begin
            return 16'd180;
        end
        return value[15:0];
    endfunction

    logic signed [17:0] decoded_x;
    logic signed [17:0] decoded_y;
    logic signed [17:0] decoded_right;
    logic signed [17:0] decoded_bottom;
    logic [15:0] clipped_left;
    logic [15:0] clipped_top;
    logic [15:0] clipped_right;
    logic [15:0] clipped_bottom;
    logic command_malformed;

    always_comb begin
        runtime_asset_id = command_words[1][1:0];
        runtime_tilemap_id = command_words[1][17:16];
        runtime_asset_read_address =
            state == STATE_FILL && command_words[0][7:0] == OPCODE_DRAW_TILE_LAYER
                ? tile_asset_read_address : runtime_blit_asset_read_address;
        decoded_x = {{2{command_words[2][15]}}, command_words[2][15:0]};
        decoded_y = {{2{command_words[2][31]}}, command_words[2][31:16]};
        decoded_right = decoded_x + $signed({2'b00, command_words[3][15:0]});
        decoded_bottom = decoded_y + $signed({2'b00, command_words[3][31:16]});
        clipped_left = clamp_x(decoded_x);
        clipped_top = clamp_y(decoded_y);
        clipped_right = clamp_x(decoded_right);
        clipped_bottom = clamp_y(decoded_bottom);

        command_malformed = command_words[0][31:16] != 0;
        case (command_words[0][7:0])
            OPCODE_CLEAR: begin
                command_malformed = command_malformed ||
                    command_words[0][15:8] != 0 ||
                    command_words[1][31:8] != 0 ||
                    command_words[2] != 0 || command_words[3] != 0 ||
                    command_words[4] != 0 || command_words[5] != 0 ||
                    command_words[6] != 0 || command_words[7] != 0;
            end
            OPCODE_FILL_RECT: begin
                command_malformed = command_malformed ||
                    command_words[0][15:8] != 0 ||
                    command_words[1][31:8] != 0 ||
                    command_words[4] != 0 || command_words[5] != 0 ||
                    command_words[6] != 0 || command_words[7] != 0;
            end
            OPCODE_BLIT_INDEX4: begin
                command_malformed = command_malformed ||
                    command_words[0][15:10] != 0 ||
                    command_words[1][31:20] != 0 ||
                    (runtime_asset_enable
                        ? command_words[1][15:0] > 16'd2
                        : command_words[1][15:0] != 0) ||
                    {1'b0, command_words[4][15:0]} + {1'b0, command_words[3][15:0]} >
                        (runtime_asset_enable ? runtime_asset_width : ATLAS_WIDTH) ||
                    {1'b0, command_words[4][31:16]} + {1'b0, command_words[3][31:16]} >
                        (runtime_asset_enable ? runtime_asset_height : ATLAS_HEIGHT) ||
                    command_words[5] != 0 || command_words[6] != 0 ||
                    command_words[7] != 0;
            end
                    OPCODE_DRAW_TILE_LAYER: begin
                    command_malformed = command_malformed ||
                        command_words[0][15:8] != 0 ||
                        !runtime_tilemap_enable || !runtime_asset_enable ||
                        command_words[1][15:0] > 16'd2 ||
                        command_words[1][31:18] != 0 ||
                        command_words[5][31:16] != 0 ||
                        command_words[6] != 0 || command_words[7] != 0;
                    end
            OPCODE_END_FRAME: begin
                command_malformed = command_malformed ||
                    command_words[0][15:8] != 0 ||
                    command_words[1] != 0 || command_words[2] != 0 ||
                    command_words[3] != 0 || command_words[4] != 0 ||
                    command_words[5] != 0 || command_words[6] != 0 ||
                    command_words[7] != 0;
            end
            default: begin
            end
        endcase
    end

    always_comb begin
        command_read_address = {command_index[6:0], 2'b00};
        case (state)
            STATE_FETCH_WORD0: command_read_address = {command_index[6:0], 2'b00} + 1'b1;
            STATE_FETCH_WORD1: command_read_address = {command_index[6:0], 2'b00} + 2'd2;
            STATE_FETCH_WORD2: command_read_address = {command_index[6:0], 2'b00} + 2'd3;
            default: begin
            end
        endcase

        write_valid = 1'b0;
        write_second_valid = 1'b0;
        write_second_token = tile_write_second_token;
        write_address = 16'd0;
        write_token = active_token;
        fill_step = CLEAR_FILL_PIXEL_PAIR_ENABLE && !fill_address[0] &&
            fill_x + 16'd1 < fill_right ? 16'd2 : 16'd1;
        if (state == STATE_FILL && command_words[0][7:0] == OPCODE_DRAW_TILE_LAYER &&
            (tile_write_valid || tile_write_second_valid) &&
            (PIXEL_PAIR_ENABLE || active_cycles != WATCHDOG_LAST_CYCLE)) begin
            write_valid = tile_write_valid;
            write_second_valid = tile_write_second_valid;
            write_address = tile_write_address;
            write_token = tile_write_token;
        end else if (state == STATE_FILL && command_words[0][7:0] == OPCODE_BLIT_INDEX4 &&
            (runtime_asset_enable ? (runtime_blit_write_valid || runtime_blit_write_second_valid) : blit_write_valid) &&
            (PIXEL_PAIR_ENABLE || active_cycles != WATCHDOG_LAST_CYCLE)
        ) begin
            write_valid = runtime_asset_enable ? runtime_blit_write_valid : blit_write_valid;
            write_second_valid = runtime_asset_enable && runtime_blit_write_second_valid;
            write_second_token = runtime_blit_write_second_token;
            write_address = runtime_asset_enable
                ? runtime_blit_write_address : blit_write_address;
            write_token = runtime_asset_enable
                ? runtime_blit_write_token : blit_write_token;
        end else if (state == STATE_CLEAR && active_cycles != WATCHDOG_LAST_CYCLE) begin
            write_valid = 1'b1;
            write_address = clear_address;
            write_second_valid = CLEAR_FILL_PIXEL_PAIR_ENABLE;
            write_second_token = active_token;
        end else if (
            state == STATE_FILL &&
            command_words[0][7:0] == OPCODE_FILL_RECT &&
            active_cycles != WATCHDOG_LAST_CYCLE
        ) begin
            write_valid = 1'b1;
            write_address = fill_address;
            write_second_valid = fill_step == 16'd2;
            write_second_token = active_token;
        end

        write_pixel_count = {1'b0, write_valid} + {1'b0, write_second_valid};
        write_second_address = {write_address[15:1], 1'b1};
        crc_single_word = write_valid ? {8'd0, write_token, write_address} :
            {8'd0, write_second_token, write_second_address};
        crc_pair_words = {8'd0, write_second_token, write_second_address, 8'd0, write_token, write_address};
        trace_crc32_next = active_trace_crc32;
        if (PIXEL_PAIR_ENABLE) begin
            if (write_valid && write_second_valid) trace_crc32_next = parallel_pair_crc;
            else if (write_valid || write_second_valid) trace_crc32_next = parallel_single_crc;
        end else begin
            trace_crc32_next = crc32_byte(trace_crc32_next, write_address[7:0]);
            trace_crc32_next = crc32_byte(trace_crc32_next, write_address[15:8]);
            trace_crc32_next = crc32_byte(trace_crc32_next, write_token);
            trace_crc32_next = crc32_byte(trace_crc32_next, 8'd0);
        end
        if (active_cycles == WATCHDOG_LAST_CYCLE) begin
            write_valid = 1'b0;
            write_second_valid = 1'b0;
        end
    end

    task automatic complete_with_error(input logic [3:0] error_flags);
        begin
            pending_error_flags <= error_flags;
            first_error_command <= command_index;
            state <= STATE_FINISH;
        end
    endtask

    task automatic advance_command;
        begin
            if ({1'b0, command_index} + 1'b1 >= latched_command_count) begin
                complete_with_error(ERROR_MISSING_END);
            end else begin
                command_index <= command_index + 1'b1;
                state <= STATE_FETCH_PRIME;
            end
        end
    endtask

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            state <= STATE_IDLE;
            command_index <= '0;
            latched_command_count <= '0;
            latched_submit_seq <= '0;
            clear_address <= '0;
            fill_x <= '0;
            fill_right <= '0;
            fill_y <= '0;
            fill_bottom <= '0;
            fill_address <= '0;
            active_token <= '0;
            active_write_count <= '0;
            active_trace_crc32 <= 32'hFFFFFFFF;
            active_cycles <= '0;
            pending_error_flags <= '0;
            busy <= 1'b0;
            done <= 1'b0;
            completed_seq <= '0;
            completed_write_count <= '0;
            completed_trace_crc32 <= '0;
            completed_cycles <= '0;
            maximum_cycles <= '0;
            last_error_flags <= '0;
            sticky_error_flags <= '0;
            first_error_command <= '0;
            blit_start <= 1'b0;
            tile_start <= 1'b0;
            runtime_blit_start <= 1'b0;
            for (integer word_index = 0; word_index < 8; word_index = word_index + 1) begin
                command_words[word_index] <= '0;
            end
        end else begin
            done <= 1'b0;
            blit_start <= 1'b0;
            tile_start <= 1'b0;
            runtime_blit_start <= 1'b0;
            if (busy) begin
                active_cycles <= active_cycles + 1'b1;
                if (state == STATE_FINISH) begin
                    busy <= 1'b0;
                    done <= 1'b1;
                    state <= STATE_IDLE;
                    completed_seq <= latched_submit_seq;
                    completed_write_count <= active_write_count;
                    completed_trace_crc32 <= ~active_trace_crc32;
                    completed_cycles <= active_cycles;
                    if (active_cycles > maximum_cycles) begin
                        maximum_cycles <= active_cycles;
                    end
                    last_error_flags <= pending_error_flags;
                    sticky_error_flags <=
                        sticky_error_flags | pending_error_flags;
                end else if (active_cycles == WATCHDOG_LAST_CYCLE) begin
                    complete_with_error(ERROR_WATCHDOG);
                end else begin
                    case (state)
                        STATE_FETCH_PRIME: state <= STATE_FETCH_WORD0;
                        STATE_FETCH_WORD0: begin
                            command_words[0] <= command_read_data[31:0];
                            command_words[1] <= command_read_data[63:32];
                            state <= STATE_FETCH_WORD1;
                        end
                        STATE_FETCH_WORD1: begin
                            command_words[2] <= command_read_data[31:0];
                            command_words[3] <= command_read_data[63:32];
                            state <= STATE_FETCH_WORD2;
                        end
                        STATE_FETCH_WORD2: begin
                            command_words[4] <= command_read_data[31:0];
                            command_words[5] <= command_read_data[63:32];
                            fill_x <= clipped_left;
                            fill_right <= clipped_right;
                            fill_y <= clipped_top;
                            fill_bottom <= clipped_bottom;
                            fill_address <=
                                (clipped_top << 8) +
                                (clipped_top << 6) +
                                clipped_left;
                            state <= STATE_FETCH_WORD3;
                        end
                        STATE_FETCH_WORD3: begin
                            command_words[6] <= command_read_data[31:0];
                            command_words[7] <= command_read_data[63:32];
                            state <= STATE_DECODE;
                        end
                        STATE_DECODE: begin
                            if (command_malformed) begin
                                complete_with_error(ERROR_MALFORMED);
                            end else begin
                                case (command_words[0][7:0])
                                    OPCODE_CLEAR: begin
                                        active_token <= command_words[1][7:0];
                                        clear_address <= '0;
                                        state <= STATE_CLEAR;
                                    end
                                    OPCODE_FILL_RECT: begin
                                        active_token <= command_words[1][7:0];
                                        if (fill_x >= fill_right || fill_y >= fill_bottom) begin
                                            advance_command();
                                        end else begin
                                            state <= STATE_FILL;
                                        end
                                    end
                                    OPCODE_BLIT_INDEX4: begin
                                        if (runtime_asset_enable) begin
                                            runtime_blit_start <= 1'b1;
                                        end else begin
                                            blit_start <= 1'b1;
                                        end
                                        state <= STATE_FILL;
                                    end
                                    OPCODE_DRAW_TILE_LAYER: begin
                                        tile_start <= 1'b1;
                                        state <= STATE_FILL;
                                    end
                                    OPCODE_END_FRAME: begin
                                        pending_error_flags <= '0;
                                        state <= STATE_FINISH;
                                    end
                                    default: begin
                                        complete_with_error(ERROR_UNSUPPORTED);
                                    end
                                endcase
                            end
                        end
                        STATE_CLEAR: begin
                            active_write_count <= active_write_count + CLEAR_STEP;
                            active_trace_crc32 <= trace_crc32_next;
                            if (clear_address == FRAME_PIXELS - CLEAR_STEP) begin
                                advance_command();
                            end else begin
                                clear_address <= clear_address + CLEAR_STEP;
                            end
                        end
                        STATE_FILL: begin
                            if (command_words[0][7:0] == OPCODE_BLIT_INDEX4) begin
                                if (write_valid || write_second_valid) begin
                                    active_write_count <= active_write_count + write_pixel_count;
                                    active_trace_crc32 <= trace_crc32_next;
                                end
                                if (runtime_asset_enable
                                    ? runtime_blit_done : blit_done) begin
                                    advance_command();
                                end
                            end else if (command_words[0][7:0] == OPCODE_DRAW_TILE_LAYER) begin
                                if (write_valid || write_second_valid) begin
                                    active_write_count <= active_write_count + write_pixel_count;
                                    active_trace_crc32 <= trace_crc32_next;
                                end
                                if (tile_done) begin
                                    if (tile_malformed) begin
                                        complete_with_error(ERROR_MALFORMED);
                                    end else begin
                                        advance_command();
                                    end
                                end
                            end else begin
                                active_write_count <= active_write_count + write_pixel_count;
                                active_trace_crc32 <= trace_crc32_next;
                            if (fill_x + fill_step >= fill_right) begin
                                if (fill_y + 1'b1 >= fill_bottom) begin
                                    advance_command();
                                end else begin
                                    fill_x <= clipped_left;
                                    fill_y <= fill_y + 1'b1;
                                    fill_address <= fill_address +
                                        16'd320 + fill_step - (fill_right - clipped_left);
                                end
                            end else begin
                                fill_x <= fill_x + fill_step;
                                fill_address <= fill_address + fill_step;
                            end
                            end
                        end
                        default: begin
                            complete_with_error(ERROR_MALFORMED);
                        end
                    endcase
                end
            end else if (start) begin
                latched_submit_seq <= submit_seq;
                latched_command_count <= command_count;
                command_index <= '0;
                active_write_count <= '0;
                active_trace_crc32 <= 32'hFFFFFFFF;
                active_cycles <= '0;
                pending_error_flags <= '0;
                last_error_flags <= '0;
                if (command_count == 0 || command_count > 9'd128) begin
                    busy <= 1'b0;
                    done <= 1'b1;
                    state <= STATE_IDLE;
                    completed_seq <= submit_seq;
                    completed_write_count <= '0;
                    completed_trace_crc32 <= 32'd0;
                    completed_cycles <= '0;
                    last_error_flags <= ERROR_MISSING_END;
                    sticky_error_flags <= sticky_error_flags | ERROR_MISSING_END;
                    first_error_command <= '0;
                end else begin
                    busy <= 1'b1;
                    state <= STATE_FETCH_PRIME;
                end
            end
        end
    end

endmodule