module scene2d_asset_store #(
    parameter integer ASSET_BYTES = 32768
) (
    input  logic        aclk,
    input  logic        aresetn,
    input  logic        renderer_idle,
    input  logic [63:0] s_axis_tdata,
    input  logic [7:0]  s_axis_tkeep,
    input  logic        s_axis_tlast,
    input  logic        s_axis_tvalid,
    output logic        s_axis_tready,
    input  logic [14:0] read_byte_address,
    output logic [7:0]  read_byte,
    output logic [31:0] accepted_packet_count,
    output logic [31:0] rejected_packet_count,
    output logic [31:0] committed_generation,
    output logic [8:0]  sticky_error_flags,
    output logic        asset_valid,
    output logic        commit_pending,
    output logic        active_bank,
    output logic        write_bank,
    output logic [15:0] asset_width,
    output logic [15:0] asset_height,
    output logic [15:0] asset_stride_bytes
);

    localparam integer ADDRESS_WIDTH = $clog2(ASSET_BYTES);
    localparam integer ASSET_WORDS = ASSET_BYTES / 4;
    localparam logic [8:0] ERROR_DESCRIPTOR = 9'b100000000;

    logic upload_ready;
    logic upload_valid;
    logic [31:0] payload_word_data;
    logic [3:0] payload_word_keep;
    logic [31:0] payload_word_index;
    logic payload_word_valid;
    logic payload_word_ready;
    logic upload_packet_done;
    logic upload_packet_valid;
    logic [31:0] upload_generation;
    logic [7:0] upload_error_flags;
    logic write_enable;
    logic [31:0] descriptor_base_offset;
    logic [15:0] descriptor_width;
    logic [15:0] descriptor_height;
    logic [15:0] descriptor_stride_bytes;
    logic [7:0] descriptor_format;
    logic [7:0] descriptor_generation;
    logic [31:0] descriptor_payload_size;
    logic descriptor_error;
    logic [31:0] pending_generation;
    logic [ADDRESS_WIDTH - 3:0] write_word_address;
    logic [7:0] bank_0_byte;
    logic [7:0] bank_1_byte;

    initial begin
        if (ASSET_BYTES <= 0 || ASSET_BYTES % 4 != 0 ||
            (1 << ADDRESS_WIDTH) != ASSET_BYTES) begin
            $error("ASSET_BYTES must be a positive power of two and divisible by four");
            $finish;
        end
    end

    assign upload_valid = s_axis_tvalid && !commit_pending && !upload_packet_done;
    assign s_axis_tready = upload_ready && !commit_pending && !upload_packet_done;
    assign payload_word_ready = !commit_pending;
    assign write_enable = payload_word_valid && payload_word_ready &&
        payload_word_index >= 4 && payload_word_index < 4 + ASSET_WORDS &&
        payload_word_keep != 0;
    assign write_word_address = payload_word_index - 3'd4;
    assign read_byte = active_bank ? bank_1_byte : bank_0_byte;

    scene2d_resource_upload #(
        .EXPECTED_MAGIC(32'h41443253),
        .EXPECTED_TYPE(32'd1),
        .EXPECTED_TARGET_ID(0),
        .MAX_TARGET_ID(0),
        .EXPECTED_PAYLOAD_BYTES(0),
        .MIN_PAYLOAD_BYTES(16),
        .MAX_PAYLOAD_BYTES(ASSET_BYTES + 16)
    ) upload (
        .aclk,
        .aresetn,
        .s_axis_tdata,
        .s_axis_tkeep,
        .s_axis_tlast,
        .s_axis_tvalid(upload_valid),
        .s_axis_tready(upload_ready),
        .payload_word_data,
        .payload_word_keep,
        .payload_word_index,
        .payload_word_valid,
        .payload_word_ready,
        .packet_done(upload_packet_done),
        .packet_valid(upload_packet_valid),
        .completed_generation(upload_generation),
        .completed_crc32(),
        .completed_payload_byte_count(),
        .completed_error_flags(upload_error_flags)
    );

    xpm_memory_sdpram #(
        .ADDR_WIDTH_A(ADDRESS_WIDTH - 2),
        .ADDR_WIDTH_B(ADDRESS_WIDTH),
        .AUTO_SLEEP_TIME(0),
        .BYTE_WRITE_WIDTH_A(8),
        .CLOCKING_MODE("common_clock"),
        .ECC_MODE("no_ecc"),
        .MEMORY_INIT_FILE("none"),
        .MEMORY_INIT_PARAM("0"),
        .MEMORY_OPTIMIZATION("true"),
        .MEMORY_PRIMITIVE("block"),
        .MEMORY_SIZE(ASSET_BYTES * 8),
        .MESSAGE_CONTROL(0),
        .READ_DATA_WIDTH_B(8),
        .READ_LATENCY_B(1),
        .READ_RESET_VALUE_B("0"),
        .RST_MODE_A("SYNC"),
        .RST_MODE_B("SYNC"),
        .USE_EMBEDDED_CONSTRAINT(0),
        .USE_MEM_INIT(1),
        .WAKEUP_TIME("disable_sleep"),
        .WRITE_DATA_WIDTH_A(32),
        .WRITE_MODE_B("read_first")
    ) bank_0 (
        .clka(aclk),
        .ena(write_enable && !write_bank),
        .wea({4{write_enable && !write_bank}} & payload_word_keep),
        .addra(write_word_address),
        .dina(payload_word_data),
        .injectdbiterra(1'b0),
        .injectsbiterra(1'b0),
        .clkb(aclk),
        .enb(1'b1),
        .addrb(read_byte_address[ADDRESS_WIDTH - 1:0]),
        .doutb(bank_0_byte),
        .rstb(!aresetn),
        .regceb(1'b1),
        .sleep(1'b0),
        .dbiterrb(),
        .sbiterrb()
    );

    xpm_memory_sdpram #(
        .ADDR_WIDTH_A(ADDRESS_WIDTH - 2),
        .ADDR_WIDTH_B(ADDRESS_WIDTH),
        .AUTO_SLEEP_TIME(0),
        .BYTE_WRITE_WIDTH_A(8),
        .CLOCKING_MODE("common_clock"),
        .ECC_MODE("no_ecc"),
        .MEMORY_INIT_FILE("none"),
        .MEMORY_INIT_PARAM("0"),
        .MEMORY_OPTIMIZATION("true"),
        .MEMORY_PRIMITIVE("block"),
        .MEMORY_SIZE(ASSET_BYTES * 8),
        .MESSAGE_CONTROL(0),
        .READ_DATA_WIDTH_B(8),
        .READ_LATENCY_B(1),
        .READ_RESET_VALUE_B("0"),
        .RST_MODE_A("SYNC"),
        .RST_MODE_B("SYNC"),
        .USE_EMBEDDED_CONSTRAINT(0),
        .USE_MEM_INIT(1),
        .WAKEUP_TIME("disable_sleep"),
        .WRITE_DATA_WIDTH_A(32),
        .WRITE_MODE_B("read_first")
    ) bank_1 (
        .clka(aclk),
        .ena(write_enable && write_bank),
        .wea({4{write_enable && write_bank}} & payload_word_keep),
        .addra(write_word_address),
        .dina(payload_word_data),
        .injectdbiterra(1'b0),
        .injectsbiterra(1'b0),
        .clkb(aclk),
        .enb(1'b1),
        .addrb(read_byte_address[ADDRESS_WIDTH - 1:0]),
        .doutb(bank_1_byte),
        .rstb(!aresetn),
        .regceb(1'b1),
        .sleep(1'b0),
        .dbiterrb(),
        .sbiterrb()
    );

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            accepted_packet_count <= '0;
            rejected_packet_count <= '0;
            committed_generation <= '0;
            sticky_error_flags <= '0;
            asset_valid <= 1'b0;
            commit_pending <= 1'b0;
            active_bank <= 1'b0;
            write_bank <= 1'b1;
            descriptor_base_offset <= '0;
            descriptor_width <= '0;
            descriptor_height <= '0;
            descriptor_stride_bytes <= '0;
            descriptor_format <= '0;
            descriptor_generation <= '0;
            descriptor_payload_size <= '0;
            descriptor_error <= 1'b0;
            pending_generation <= '0;
            asset_width <= '0;
            asset_height <= '0;
            asset_stride_bytes <= '0;
        end else begin
            if (payload_word_valid && payload_word_ready) begin
                case (payload_word_index)
                    0: begin
                        descriptor_base_offset <= payload_word_data;
                        descriptor_error <= payload_word_data != 0 ||
                            payload_word_keep != 4'hF;
                    end
                    1: begin
                        descriptor_width <= payload_word_data[15:0];
                        descriptor_height <= payload_word_data[31:16];
                        if (payload_word_keep != 4'hF ||
                            payload_word_data[15:0] == 0 ||
                            payload_word_data[31:16] == 0) begin
                            descriptor_error <= 1'b1;
                        end
                    end
                    2: begin
                        descriptor_stride_bytes <= payload_word_data[15:0];
                        descriptor_format <= payload_word_data[23:16];
                        descriptor_generation <= payload_word_data[31:24];
                        if (payload_word_keep != 4'hF ||
                            payload_word_data[23:16] != 8'd1) begin
                            descriptor_error <= 1'b1;
                        end
                    end
                    3: begin
                        descriptor_payload_size <= payload_word_data;
                        if (payload_word_keep != 4'hF) begin
                            descriptor_error <= 1'b1;
                        end
                    end
                    default: begin
                    end
                endcase
            end

            if (upload_packet_done) begin
                if (
                    upload_packet_valid && !descriptor_error &&
                    descriptor_base_offset == 0 &&
                    descriptor_stride_bytes == ((descriptor_width + 1'b1) >> 1) &&
                    descriptor_generation == upload_generation[7:0] &&
                    descriptor_payload_size > 0 &&
                    descriptor_payload_size <= ASSET_BYTES &&
                    descriptor_payload_size == descriptor_stride_bytes * descriptor_height &&
                    descriptor_payload_size + 16 == upload.completed_payload_byte_count
                ) begin
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
                asset_valid <= 1'b1;
                asset_width <= descriptor_width;
                asset_height <= descriptor_height;
                asset_stride_bytes <= descriptor_stride_bytes;
                commit_pending <= 1'b0;
            end
        end
    end

endmodule
