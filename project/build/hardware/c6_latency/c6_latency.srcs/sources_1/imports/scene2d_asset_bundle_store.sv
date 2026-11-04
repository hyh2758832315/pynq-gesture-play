module scene2d_asset_bundle_store #(
    parameter integer ASSET_BYTES = 32768,
    parameter integer ASSET_SLOT_COUNT = 3
) (
    input  logic        aclk,
    input  logic        aresetn,
    input  logic        renderer_idle,
    input  logic [63:0] s_axis_tdata,
    input  logic [7:0]  s_axis_tkeep,
    input  logic        s_axis_tlast,
    input  logic        s_axis_tvalid,
    output logic        s_axis_tready,
    input  logic [1:0]  read_asset_id,
    input  logic [14:0] read_byte_offset,
    output logic [7:0]  read_byte,
    output logic        read_asset_valid,
    output logic [15:0] read_asset_width,
    output logic [15:0] read_asset_height,
    output logic [15:0] read_asset_stride_bytes,
    output logic [31:0] accepted_packet_count,
    output logic [31:0] rejected_packet_count,
    output logic [31:0] committed_generation,
    output logic [8:0]  sticky_error_flags,
    output logic        bundle_valid,
    output logic        commit_pending,
    output logic        active_bank,
    output logic        write_bank
);

    localparam integer ADDRESS_WIDTH = $clog2(ASSET_BYTES);
    localparam integer DESCRIPTOR_WORDS = ASSET_SLOT_COUNT * 4;
    localparam integer ASSET_WORDS = ASSET_BYTES / 4;
    localparam logic [8:0] ERROR_DESCRIPTOR = 9'b100000000;

    logic upload_ready;
    logic [31:0] payload_word_data;
    logic [3:0] payload_word_keep;
    logic [31:0] payload_word_index;
    logic payload_word_valid;
    logic upload_packet_done;
    logic upload_packet_valid;
    logic [31:0] upload_generation;
    logic [31:0] upload_payload_byte_count;
    logic [7:0] upload_error_flags;
    logic write_enable;
    logic [ADDRESS_WIDTH - 3:0] write_word_address;
    logic [7:0] bank_0_byte;
    logic [7:0] bank_1_byte;
    logic [31:0] bank_0_base [0:ASSET_SLOT_COUNT - 1];
    logic [31:0] bank_1_base [0:ASSET_SLOT_COUNT - 1];
    logic [15:0] bank_0_width [0:ASSET_SLOT_COUNT - 1];
    logic [15:0] bank_1_width [0:ASSET_SLOT_COUNT - 1];
    logic [15:0] bank_0_expected_stride [0:ASSET_SLOT_COUNT - 1];
    logic [15:0] bank_1_expected_stride [0:ASSET_SLOT_COUNT - 1];
    logic [15:0] bank_0_height [0:ASSET_SLOT_COUNT - 1];
    logic [15:0] bank_1_height [0:ASSET_SLOT_COUNT - 1];
    logic [15:0] bank_0_stride [0:ASSET_SLOT_COUNT - 1];
    logic [15:0] bank_1_stride [0:ASSET_SLOT_COUNT - 1];
    logic [7:0] bank_0_format [0:ASSET_SLOT_COUNT - 1];
    logic [7:0] bank_1_format [0:ASSET_SLOT_COUNT - 1];
    logic [7:0] bank_0_generation [0:ASSET_SLOT_COUNT - 1];
    logic [7:0] bank_1_generation [0:ASSET_SLOT_COUNT - 1];
    logic [31:0] bank_0_size [0:ASSET_SLOT_COUNT - 1];
    logic [31:0] bank_1_size [0:ASSET_SLOT_COUNT - 1];
    logic descriptor_error;
    logic bundle_descriptor_error;
    logic [31:0] pending_generation;
    logic [31:0] read_byte_address;
    integer slot_index;

    initial begin
        if (ASSET_BYTES <= 0 || ASSET_BYTES % 4 != 0 ||
            (1 << ADDRESS_WIDTH) != ASSET_BYTES || ASSET_SLOT_COUNT != 3) begin
            $error("Asset bundle store requires three slots and power-of-two bytes");
            $finish;
        end
    end

    assign s_axis_tready = upload_ready && !commit_pending;
    assign write_enable = payload_word_valid && !commit_pending &&
        payload_word_index >= DESCRIPTOR_WORDS &&
        payload_word_index < DESCRIPTOR_WORDS + ASSET_WORDS &&
        payload_word_keep != 0;
    assign write_word_address = payload_word_index - DESCRIPTOR_WORDS;
    assign read_byte = active_bank ? bank_1_byte : bank_0_byte;

    always_comb begin
        read_asset_valid = bundle_valid && read_asset_id < ASSET_SLOT_COUNT;
        read_asset_width = '0;
        read_asset_height = '0;
        read_asset_stride_bytes = '0;
        read_byte_address = read_byte_offset;
        if (read_asset_id < ASSET_SLOT_COUNT) begin
            if (active_bank) begin
                read_asset_width = bank_1_width[read_asset_id];
                read_asset_height = bank_1_height[read_asset_id];
                read_asset_stride_bytes = bank_1_stride[read_asset_id];
                read_byte_address = bank_1_base[read_asset_id] + read_byte_offset;
            end else begin
                read_asset_width = bank_0_width[read_asset_id];
                read_asset_height = bank_0_height[read_asset_id];
                read_asset_stride_bytes = bank_0_stride[read_asset_id];
                read_byte_address = bank_0_base[read_asset_id] + read_byte_offset;
            end
        end
    end

    always_comb begin
        bundle_descriptor_error = descriptor_error;
        for (int index = 0; index < ASSET_SLOT_COUNT; index = index + 1) begin
            if (write_bank) begin
                bundle_descriptor_error = bundle_descriptor_error ||
                    bank_1_base[index][5:0] != 0 ||
                    bank_1_width[index] == 0 || bank_1_height[index] == 0 ||
                    bank_1_stride[index] != bank_1_expected_stride[index] ||
                    bank_1_format[index] != 8'd1 ||
                    bank_1_generation[index] != upload_generation[7:0] ||
                    bank_1_size[index] == 0 ||
                    bank_1_base[index] + bank_1_size[index] > ASSET_BYTES;
            end else begin
                bundle_descriptor_error = bundle_descriptor_error ||
                    bank_0_base[index][5:0] != 0 ||
                    bank_0_width[index] == 0 || bank_0_height[index] == 0 ||
                    bank_0_stride[index] != bank_0_expected_stride[index] ||
                    bank_0_format[index] != 8'd1 ||
                    bank_0_generation[index] != upload_generation[7:0] ||
                    bank_0_size[index] == 0 ||
                    bank_0_base[index] + bank_0_size[index] > ASSET_BYTES;
            end
        end
    end

    scene2d_resource_upload #(
        .EXPECTED_MAGIC(32'h41443253),
        .EXPECTED_TYPE(32'd1),
        .EXPECTED_TARGET_ID(0),
        .MAX_TARGET_ID(0),
        .EXPECTED_PAYLOAD_BYTES(0),
        .MIN_PAYLOAD_BYTES(DESCRIPTOR_WORDS * 4 + 1),
        .MAX_PAYLOAD_BYTES(DESCRIPTOR_WORDS * 4 + ASSET_BYTES)
    ) upload (
        .aclk, .aresetn, .s_axis_tdata, .s_axis_tkeep, .s_axis_tlast,
        .s_axis_tvalid(s_axis_tvalid && !commit_pending), .s_axis_tready(upload_ready),
        .payload_word_data, .payload_word_keep, .payload_word_index,
        .payload_word_valid, .payload_word_ready(!commit_pending),
        .packet_done(upload_packet_done), .packet_valid(upload_packet_valid),
        .completed_generation(upload_generation), .completed_crc32(),
        .completed_payload_byte_count(upload_payload_byte_count),
        .completed_error_flags(upload_error_flags)
    );

    xpm_memory_sdpram #(
        .ADDR_WIDTH_A(ADDRESS_WIDTH - 2), .ADDR_WIDTH_B(ADDRESS_WIDTH),
        .AUTO_SLEEP_TIME(0), .BYTE_WRITE_WIDTH_A(8), .CLOCKING_MODE("common_clock"),
        .ECC_MODE("no_ecc"), .MEMORY_INIT_FILE("none"), .MEMORY_INIT_PARAM("0"),
        .MEMORY_OPTIMIZATION("true"), .MEMORY_PRIMITIVE("block"),
        .MEMORY_SIZE(ASSET_BYTES * 8), .MESSAGE_CONTROL(0), .READ_DATA_WIDTH_B(8),
        .READ_LATENCY_B(1), .READ_RESET_VALUE_B("0"), .RST_MODE_A("SYNC"),
        .RST_MODE_B("SYNC"), .USE_EMBEDDED_CONSTRAINT(0), .USE_MEM_INIT(1),
        .WAKEUP_TIME("disable_sleep"), .WRITE_DATA_WIDTH_A(32), .WRITE_MODE_B("read_first")
    ) bank_0 (
        .clka(aclk), .ena(write_enable && !write_bank),
        .wea({4{write_enable && !write_bank}} & payload_word_keep),
        .addra(write_word_address), .dina(payload_word_data), .injectdbiterra(1'b0),
        .injectsbiterra(1'b0), .clkb(aclk), .enb(1'b1),
        .addrb(read_byte_address[ADDRESS_WIDTH - 1:0]), .doutb(bank_0_byte),
        .rstb(!aresetn), .regceb(1'b1), .sleep(1'b0), .dbiterrb(), .sbiterrb()
    );

    xpm_memory_sdpram #(
        .ADDR_WIDTH_A(ADDRESS_WIDTH - 2), .ADDR_WIDTH_B(ADDRESS_WIDTH),
        .AUTO_SLEEP_TIME(0), .BYTE_WRITE_WIDTH_A(8), .CLOCKING_MODE("common_clock"),
        .ECC_MODE("no_ecc"), .MEMORY_INIT_FILE("none"), .MEMORY_INIT_PARAM("0"),
        .MEMORY_OPTIMIZATION("true"), .MEMORY_PRIMITIVE("block"),
        .MEMORY_SIZE(ASSET_BYTES * 8), .MESSAGE_CONTROL(0), .READ_DATA_WIDTH_B(8),
        .READ_LATENCY_B(1), .READ_RESET_VALUE_B("0"), .RST_MODE_A("SYNC"),
        .RST_MODE_B("SYNC"), .USE_EMBEDDED_CONSTRAINT(0), .USE_MEM_INIT(1),
        .WAKEUP_TIME("disable_sleep"), .WRITE_DATA_WIDTH_A(32), .WRITE_MODE_B("read_first")
    ) bank_1 (
        .clka(aclk), .ena(write_enable && write_bank),
        .wea({4{write_enable && write_bank}} & payload_word_keep),
        .addra(write_word_address), .dina(payload_word_data), .injectdbiterra(1'b0),
        .injectsbiterra(1'b0), .clkb(aclk), .enb(1'b1),
        .addrb(read_byte_address[ADDRESS_WIDTH - 1:0]), .doutb(bank_1_byte),
        .rstb(!aresetn), .regceb(1'b1), .sleep(1'b0), .dbiterrb(), .sbiterrb()
    );

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            accepted_packet_count <= '0;
            rejected_packet_count <= '0;
            committed_generation <= '0;
            sticky_error_flags <= '0;
            bundle_valid <= 1'b0;
            commit_pending <= 1'b0;
            active_bank <= 1'b0;
            write_bank <= 1'b1;
            descriptor_error <= 1'b0;
            pending_generation <= '0;
            for (slot_index = 0; slot_index < ASSET_SLOT_COUNT; slot_index = slot_index + 1) begin
                bank_0_base[slot_index] <= '0; bank_1_base[slot_index] <= '0;
                bank_0_width[slot_index] <= '0; bank_1_width[slot_index] <= '0;
                bank_0_expected_stride[slot_index] <= '0; bank_1_expected_stride[slot_index] <= '0;
                bank_0_height[slot_index] <= '0; bank_1_height[slot_index] <= '0;
                bank_0_stride[slot_index] <= '0; bank_1_stride[slot_index] <= '0;
                bank_0_format[slot_index] <= '0; bank_1_format[slot_index] <= '0;
                bank_0_generation[slot_index] <= '0; bank_1_generation[slot_index] <= '0;
                bank_0_size[slot_index] <= '0; bank_1_size[slot_index] <= '0;
            end
        end else begin
            if (payload_word_valid && !commit_pending && payload_word_index < DESCRIPTOR_WORDS) begin
                if (write_bank) begin
                    case (payload_word_index[1:0])
                        0: bank_1_base[payload_word_index >> 2] <= payload_word_data;
                        1: begin bank_1_width[payload_word_index >> 2] <= payload_word_data[15:0]; bank_1_height[payload_word_index >> 2] <= payload_word_data[31:16]; bank_1_expected_stride[payload_word_index >> 2] <= (payload_word_data[15:0] + 16'd1) >> 1; end
                        2: begin bank_1_stride[payload_word_index >> 2] <= payload_word_data[15:0]; bank_1_format[payload_word_index >> 2] <= payload_word_data[23:16]; bank_1_generation[payload_word_index >> 2] <= payload_word_data[31:24]; end
                        3: bank_1_size[payload_word_index >> 2] <= payload_word_data;
                    endcase
                end else begin
                    case (payload_word_index[1:0])
                        0: bank_0_base[payload_word_index >> 2] <= payload_word_data;
                        1: begin bank_0_width[payload_word_index >> 2] <= payload_word_data[15:0]; bank_0_height[payload_word_index >> 2] <= payload_word_data[31:16]; bank_0_expected_stride[payload_word_index >> 2] <= (payload_word_data[15:0] + 16'd1) >> 1; end
                        2: begin bank_0_stride[payload_word_index >> 2] <= payload_word_data[15:0]; bank_0_format[payload_word_index >> 2] <= payload_word_data[23:16]; bank_0_generation[payload_word_index >> 2] <= payload_word_data[31:24]; end
                        3: bank_0_size[payload_word_index >> 2] <= payload_word_data;
                    endcase
                end
                if (payload_word_keep != 4'hF) descriptor_error <= 1'b1;
            end
            if (upload_packet_done) begin
                if (upload_packet_valid && !bundle_descriptor_error &&
                    upload_payload_byte_count > DESCRIPTOR_WORDS * 4) begin
                    accepted_packet_count <= accepted_packet_count + 1'b1;
                    pending_generation <= upload_generation;
                    commit_pending <= 1'b1;
                end else begin
                    rejected_packet_count <= rejected_packet_count + 1'b1;
                    sticky_error_flags <= sticky_error_flags |
                        {1'b0, upload_error_flags} | ERROR_DESCRIPTOR;
                end
                descriptor_error <= 1'b0;
            end
            if (commit_pending && renderer_idle) begin
                active_bank <= write_bank;
                write_bank <= ~write_bank;
                committed_generation <= pending_generation;
                bundle_valid <= 1'b1;
                commit_pending <= 1'b0;
            end
        end
    end

endmodule