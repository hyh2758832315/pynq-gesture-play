module scene2d_tilemap_store #(
    parameter integer TILEMAP_SLOT_COUNT = 4,
    parameter integer TILEMAP_SLOT_BYTES = 4096
) (
    input  logic        aclk,
    input  logic        aresetn,
    input  logic        renderer_idle,
    input  logic [63:0] s_axis_tdata,
    input  logic [7:0]  s_axis_tkeep,
    input  logic        s_axis_tlast,
    input  logic        s_axis_tvalid,
    output logic        s_axis_tready,
    input  logic [1:0]  read_tilemap_id,
    input  logic [9:0]  read_word_address,
    output logic [31:0] read_word_data,
    output logic        read_tilemap_valid,
    output logic [15:0] read_width_tiles,
    output logic [15:0] read_height_tiles,
    output logic signed [31:0] read_origin_x,
    output logic signed [31:0] read_origin_y,
    output logic [15:0] read_tile_size,
    output logic [31:0] read_generation,
    output logic [31:0] accepted_packet_count,
    output logic [31:0] rejected_packet_count,
    output logic [31:0] committed_generation,
    output logic [8:0]  sticky_error_flags,
    output logic [TILEMAP_SLOT_COUNT - 1:0] tilemap_valid,
    output logic [TILEMAP_SLOT_COUNT - 1:0] commit_pending,
    output logic [TILEMAP_SLOT_COUNT - 1:0] active_bank,
    output logic [TILEMAP_SLOT_COUNT - 1:0] write_bank
);

    localparam integer SLOT_ADDRESS_WIDTH = $clog2(TILEMAP_SLOT_BYTES);
    localparam logic [8:0] ERROR_TILEMAP = 9'b100000000;

    logic upload_ready;
    logic [31:0] payload_word_data;
    logic [3:0] payload_word_keep;
    logic [31:0] payload_word_index;
    logic payload_word_valid;
    logic [31:0] payload_target_id;
    logic upload_packet_done;
    logic upload_packet_valid;
    logic [31:0] upload_generation;
    logic [31:0] upload_target_id;
    logic [31:0] upload_payload_byte_count;
    logic [7:0] upload_error_flags;
    logic semantic_error;
    logic descriptor_shape_error;
    logic [15:0] descriptor_width;
    logic [15:0] descriptor_row_remaining;
    logic [15:0] descriptor_rows_remaining;
    logic [31:0] pending_generation [0:TILEMAP_SLOT_COUNT - 1];
    logic [31:0] bank_0_generation [0:TILEMAP_SLOT_COUNT - 1];
    logic [31:0] bank_1_generation [0:TILEMAP_SLOT_COUNT - 1];
    logic [15:0] bank_0_width [0:TILEMAP_SLOT_COUNT - 1];
    logic [15:0] bank_1_width [0:TILEMAP_SLOT_COUNT - 1];
    logic [15:0] bank_0_height [0:TILEMAP_SLOT_COUNT - 1];
    logic [15:0] bank_1_height [0:TILEMAP_SLOT_COUNT - 1];
    logic signed [31:0] bank_0_origin_x [0:TILEMAP_SLOT_COUNT - 1];
    logic signed [31:0] bank_1_origin_x [0:TILEMAP_SLOT_COUNT - 1];
    logic signed [31:0] bank_0_origin_y [0:TILEMAP_SLOT_COUNT - 1];
    logic signed [31:0] bank_1_origin_y [0:TILEMAP_SLOT_COUNT - 1];
    logic [15:0] bank_0_tile_size [0:TILEMAP_SLOT_COUNT - 1];
    logic [15:0] bank_1_tile_size [0:TILEMAP_SLOT_COUNT - 1];
    logic [31:0] bank_0_read_data [0:TILEMAP_SLOT_COUNT - 1];
    logic [31:0] bank_1_read_data [0:TILEMAP_SLOT_COUNT - 1];
    logic write_enable;
    logic upload_descriptor_error;
    integer slot_index;

    initial begin
        if (TILEMAP_SLOT_COUNT != 4 || TILEMAP_SLOT_BYTES <= 16 ||
            TILEMAP_SLOT_BYTES % 4 != 0 ||
            (1 << SLOT_ADDRESS_WIDTH) != TILEMAP_SLOT_BYTES) begin
            $error("Tilemap store requires four power-of-two slots larger than 16 bytes");
            $finish;
        end
    end

    assign s_axis_tready = upload_ready && ~|commit_pending;
    assign write_enable = payload_word_valid && ~|commit_pending &&
        payload_target_id < TILEMAP_SLOT_COUNT &&
        payload_word_index < TILEMAP_SLOT_BYTES / 4;
    assign committed_generation = active_bank[0]
        ? bank_1_generation[0] : bank_0_generation[0];

    always_comb begin
        read_word_data = '0;
        read_tilemap_valid = 1'b0;
        read_width_tiles = '0;
        read_height_tiles = '0;
        read_origin_x = '0;
        read_origin_y = '0;
        read_tile_size = '0;
        read_generation = '0;
        if (read_tilemap_id < TILEMAP_SLOT_COUNT) begin
            read_tilemap_valid = tilemap_valid[read_tilemap_id];
            if (active_bank[read_tilemap_id]) begin
                read_word_data = bank_1_read_data[read_tilemap_id];
                read_width_tiles = bank_1_width[read_tilemap_id];
                read_height_tiles = bank_1_height[read_tilemap_id];
                read_origin_x = bank_1_origin_x[read_tilemap_id];
                read_origin_y = bank_1_origin_y[read_tilemap_id];
                read_tile_size = bank_1_tile_size[read_tilemap_id];
                read_generation = bank_1_generation[read_tilemap_id];
            end else begin
                read_word_data = bank_0_read_data[read_tilemap_id];
                read_width_tiles = bank_0_width[read_tilemap_id];
                read_height_tiles = bank_0_height[read_tilemap_id];
                read_origin_x = bank_0_origin_x[read_tilemap_id];
                read_origin_y = bank_0_origin_y[read_tilemap_id];
                read_tile_size = bank_0_tile_size[read_tilemap_id];
                read_generation = bank_0_generation[read_tilemap_id];
            end
        end
    end

    always_comb begin
        upload_descriptor_error = semantic_error || descriptor_shape_error ||
            descriptor_row_remaining != 0 || descriptor_rows_remaining != 0 ||
            upload_target_id >= TILEMAP_SLOT_COUNT;
        if (upload_target_id < TILEMAP_SLOT_COUNT) begin
            if (write_bank[upload_target_id]) begin
                upload_descriptor_error = upload_descriptor_error ||
                    bank_1_width[upload_target_id] == 0 ||
                    bank_1_height[upload_target_id] == 0 ||
                    bank_1_tile_size[upload_target_id] == 0 ||
                    (bank_1_tile_size[upload_target_id] &
                        (bank_1_tile_size[upload_target_id] - 1'b1)) != 0;
            end else begin
                upload_descriptor_error = upload_descriptor_error ||
                    bank_0_width[upload_target_id] == 0 ||
                    bank_0_height[upload_target_id] == 0 ||
                    bank_0_tile_size[upload_target_id] == 0 ||
                    (bank_0_tile_size[upload_target_id] &
                        (bank_0_tile_size[upload_target_id] - 1'b1)) != 0;
            end
        end
    end

    scene2d_resource_upload #(
        .EXPECTED_MAGIC(32'h54443253),
        .EXPECTED_TYPE(32'd2),
        .EXPECTED_TARGET_ID(0),
        .MAX_TARGET_ID(TILEMAP_SLOT_COUNT - 1),
        .EXPECTED_PAYLOAD_BYTES(0),
        .MIN_PAYLOAD_BYTES(20),
        .MAX_PAYLOAD_BYTES(TILEMAP_SLOT_BYTES)
    ) upload (
        .aclk, .aresetn, .s_axis_tdata, .s_axis_tkeep, .s_axis_tlast,
        .s_axis_tvalid(s_axis_tvalid && ~|commit_pending), .s_axis_tready(upload_ready),
        .payload_word_data, .payload_word_keep, .payload_word_index,
        .payload_word_valid, .payload_word_ready(~|commit_pending),
        .packet_done(upload_packet_done), .packet_valid(upload_packet_valid),
        .payload_target_id, .completed_generation(upload_generation),
        .completed_target_id(upload_target_id), .completed_crc32(),
        .completed_payload_byte_count(upload_payload_byte_count),
        .completed_error_flags(upload_error_flags)
    );

    genvar memory_slot;
    generate
        for (memory_slot = 0; memory_slot < TILEMAP_SLOT_COUNT; memory_slot = memory_slot + 1) begin : tilemap_memory
            xpm_memory_sdpram #(
                .ADDR_WIDTH_A(SLOT_ADDRESS_WIDTH - 2), .ADDR_WIDTH_B(SLOT_ADDRESS_WIDTH - 2),
                .AUTO_SLEEP_TIME(0), .BYTE_WRITE_WIDTH_A(8), .CLOCKING_MODE("common_clock"),
                .ECC_MODE("no_ecc"), .MEMORY_INIT_FILE("none"), .MEMORY_INIT_PARAM("0"),
                .MEMORY_OPTIMIZATION("true"), .MEMORY_PRIMITIVE("block"),
                .MEMORY_SIZE(TILEMAP_SLOT_BYTES * 8), .MESSAGE_CONTROL(0), .READ_DATA_WIDTH_B(32),
                .READ_LATENCY_B(1), .READ_RESET_VALUE_B("0"), .RST_MODE_A("SYNC"),
                .RST_MODE_B("SYNC"), .USE_EMBEDDED_CONSTRAINT(0), .USE_MEM_INIT(1),
                .WAKEUP_TIME("disable_sleep"), .WRITE_DATA_WIDTH_A(32), .WRITE_MODE_B("read_first")
            ) bank_0 (
                .clka(aclk), .ena(write_enable && payload_target_id == memory_slot && !write_bank[memory_slot]),
                .wea({4{write_enable && payload_target_id == memory_slot && !write_bank[memory_slot]}} & payload_word_keep),
                .addra(payload_word_index[SLOT_ADDRESS_WIDTH - 3:0]), .dina(payload_word_data),
                .injectdbiterra(1'b0), .injectsbiterra(1'b0), .clkb(aclk), .enb(1'b1),
                .addrb(read_word_address), .doutb(bank_0_read_data[memory_slot]), .rstb(!aresetn),
                .regceb(1'b1), .sleep(1'b0), .dbiterrb(), .sbiterrb()
            );

            xpm_memory_sdpram #(
                .ADDR_WIDTH_A(SLOT_ADDRESS_WIDTH - 2), .ADDR_WIDTH_B(SLOT_ADDRESS_WIDTH - 2),
                .AUTO_SLEEP_TIME(0), .BYTE_WRITE_WIDTH_A(8), .CLOCKING_MODE("common_clock"),
                .ECC_MODE("no_ecc"), .MEMORY_INIT_FILE("none"), .MEMORY_INIT_PARAM("0"),
                .MEMORY_OPTIMIZATION("true"), .MEMORY_PRIMITIVE("block"),
                .MEMORY_SIZE(TILEMAP_SLOT_BYTES * 8), .MESSAGE_CONTROL(0), .READ_DATA_WIDTH_B(32),
                .READ_LATENCY_B(1), .READ_RESET_VALUE_B("0"), .RST_MODE_A("SYNC"),
                .RST_MODE_B("SYNC"), .USE_EMBEDDED_CONSTRAINT(0), .USE_MEM_INIT(1),
                .WAKEUP_TIME("disable_sleep"), .WRITE_DATA_WIDTH_A(32), .WRITE_MODE_B("read_first")
            ) bank_1 (
                .clka(aclk), .ena(write_enable && payload_target_id == memory_slot && write_bank[memory_slot]),
                .wea({4{write_enable && payload_target_id == memory_slot && write_bank[memory_slot]}} & payload_word_keep),
                .addra(payload_word_index[SLOT_ADDRESS_WIDTH - 3:0]), .dina(payload_word_data),
                .injectdbiterra(1'b0), .injectsbiterra(1'b0), .clkb(aclk), .enb(1'b1),
                .addrb(read_word_address), .doutb(bank_1_read_data[memory_slot]), .rstb(!aresetn),
                .regceb(1'b1), .sleep(1'b0), .dbiterrb(), .sbiterrb()
            );
        end
    endgenerate

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            accepted_packet_count <= '0;
            rejected_packet_count <= '0;
            sticky_error_flags <= '0;
            tilemap_valid <= '0;
            commit_pending <= '0;
            active_bank <= '0;
            write_bank <= {TILEMAP_SLOT_COUNT{1'b1}};
            semantic_error <= 1'b0;
            descriptor_shape_error <= 1'b0;
            descriptor_width <= '0;
            descriptor_row_remaining <= '0;
            descriptor_rows_remaining <= '0;
            for (slot_index = 0; slot_index < TILEMAP_SLOT_COUNT; slot_index = slot_index + 1) begin
                pending_generation[slot_index] <= '0;
                bank_0_generation[slot_index] <= '0; bank_1_generation[slot_index] <= '0;
                bank_0_width[slot_index] <= '0; bank_1_width[slot_index] <= '0;
                bank_0_height[slot_index] <= '0; bank_1_height[slot_index] <= '0;
                bank_0_origin_x[slot_index] <= '0; bank_1_origin_x[slot_index] <= '0;
                bank_0_origin_y[slot_index] <= '0; bank_1_origin_y[slot_index] <= '0;
                bank_0_tile_size[slot_index] <= '0; bank_1_tile_size[slot_index] <= '0;
            end
        end else begin
            if (payload_word_valid && payload_target_id < TILEMAP_SLOT_COUNT) begin
                if (payload_word_keep != 4'hF ||
                    (payload_word_index >= 4 && payload_word_data[31:22] != 0)) begin
                    semantic_error <= 1'b1;
                end
                if (payload_word_index == 0) begin
                    descriptor_width <= payload_word_data[15:0];
                    descriptor_row_remaining <= payload_word_data[15:0];
                    descriptor_rows_remaining <= payload_word_data[31:16];
                    descriptor_shape_error <= payload_word_data[15:0] == 0 ||
                        payload_word_data[31:16] == 0;
                end else if (payload_word_index >= 4) begin
                    if (descriptor_row_remaining == 0 || descriptor_rows_remaining == 0) begin
                        descriptor_shape_error <= 1'b1;
                    end else if (descriptor_row_remaining == 1) begin
                        if (descriptor_rows_remaining == 1) begin
                            descriptor_row_remaining <= '0;
                            descriptor_rows_remaining <= '0;
                        end else begin
                            descriptor_row_remaining <= descriptor_width;
                            descriptor_rows_remaining <= descriptor_rows_remaining - 1'b1;
                        end
                    end else begin
                        descriptor_row_remaining <= descriptor_row_remaining - 1'b1;
                    end
                end
                if (write_bank[payload_target_id]) begin
                    case (payload_word_index)
                        0: begin bank_1_width[payload_target_id] <= payload_word_data[15:0]; bank_1_height[payload_target_id] <= payload_word_data[31:16]; end
                        1: bank_1_origin_x[payload_target_id] <= payload_word_data;
                        2: bank_1_origin_y[payload_target_id] <= payload_word_data;
                        3: bank_1_tile_size[payload_target_id] <= payload_word_data[15:0];
                        default: begin end
                    endcase
                end else begin
                    case (payload_word_index)
                        0: begin bank_0_width[payload_target_id] <= payload_word_data[15:0]; bank_0_height[payload_target_id] <= payload_word_data[31:16]; end
                        1: bank_0_origin_x[payload_target_id] <= payload_word_data;
                        2: bank_0_origin_y[payload_target_id] <= payload_word_data;
                        3: bank_0_tile_size[payload_target_id] <= payload_word_data[15:0];
                        default: begin end
                    endcase
                end
            end

            if (upload_packet_done) begin
                if (upload_packet_valid && !upload_descriptor_error) begin
                    accepted_packet_count <= accepted_packet_count + 1'b1;
                    pending_generation[upload_target_id] <= upload_generation;
                    if (write_bank[upload_target_id]) begin
                        bank_1_generation[upload_target_id] <= upload_generation;
                    end else begin
                        bank_0_generation[upload_target_id] <= upload_generation;
                    end
                    commit_pending[upload_target_id] <= 1'b1;
                end else begin
                    rejected_packet_count <= rejected_packet_count + 1'b1;
                    sticky_error_flags <= sticky_error_flags |
                        {1'b0, upload_error_flags} | ERROR_TILEMAP;
                end
                semantic_error <= 1'b0;
            end

            for (slot_index = 0; slot_index < TILEMAP_SLOT_COUNT; slot_index = slot_index + 1) begin
                if (commit_pending[slot_index] && renderer_idle) begin
                    active_bank[slot_index] <= write_bank[slot_index];
                    write_bank[slot_index] <= ~write_bank[slot_index];
                    tilemap_valid[slot_index] <= 1'b1;
                    commit_pending[slot_index] <= 1'b0;
                end
            end
        end
    end

endmodule