module scene2d_palette_store (
    input  logic        aclk,
    input  logic        aresetn,
    input  logic        clk_pixel,
    input  logic        resetn_pixel,
    input  logic        vblank_start,
    input  logic [63:0] s_axis_tdata,
    input  logic [7:0]  s_axis_tkeep,
    input  logic        s_axis_tlast,
    input  logic        s_axis_tvalid,
    output logic        s_axis_tready,
    input  logic [7:0]  read_address,
    output logic [23:0] read_rgb,
    output logic [31:0] accepted_packet_count,
    output logic [31:0] rejected_packet_count,
    output logic [31:0] committed_generation,
    output logic [8:0]  sticky_error_flags,
    output logic        palette_valid,
    output logic        commit_pending,
    output logic        active_bank,
    output logic        write_bank
);

    localparam logic [8:0] ERROR_PALETTE_WORD = 9'b100000000;

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
    logic semantic_error;
    logic palette_write_enable;
    logic [23:0] bank_0_rgb;
    logic [23:0] bank_1_rgb;
    logic [31:0] pending_generation;
    logic request_toggle;
    (* ASYNC_REG = "TRUE" *) logic request_sync_1;
    (* ASYNC_REG = "TRUE" *) logic request_sync_2;
    logic request_seen;
    logic acknowledgement_toggle;
    (* ASYNC_REG = "TRUE" *) logic acknowledgement_sync_1;
    (* ASYNC_REG = "TRUE" *) logic acknowledgement_sync_2;
    logic acknowledgement_seen;

    assign upload_valid = s_axis_tvalid && !commit_pending && !upload_packet_done;
    assign s_axis_tready = upload_ready && !commit_pending && !upload_packet_done;
    assign payload_word_ready = !commit_pending;
    assign palette_write_enable = payload_word_valid && payload_word_ready;
    assign read_rgb = active_bank ? bank_1_rgb : bank_0_rgb;

    scene2d_resource_upload #(
        .EXPECTED_MAGIC(32'h50443253),
        .EXPECTED_TYPE(32'd3),
        .EXPECTED_TARGET_ID(32'd0),
        .EXPECTED_PAYLOAD_BYTES(1024)
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
        .ADDR_WIDTH_A(8),
        .ADDR_WIDTH_B(8),
        .AUTO_SLEEP_TIME(0),
        .BYTE_WRITE_WIDTH_A(24),
        .CLOCKING_MODE("independent_clock"),
        .ECC_MODE("no_ecc"),
        .MEMORY_INIT_FILE("none"),
        .MEMORY_INIT_PARAM("0"),
        .MEMORY_OPTIMIZATION("true"),
        .MEMORY_PRIMITIVE("block"),
        .MEMORY_SIZE(6144),
        .MESSAGE_CONTROL(0),
        .READ_DATA_WIDTH_B(24),
        .READ_LATENCY_B(1),
        .READ_RESET_VALUE_B("0"),
        .RST_MODE_A("SYNC"),
        .RST_MODE_B("SYNC"),
        .USE_EMBEDDED_CONSTRAINT(0),
        .USE_MEM_INIT(1),
        .WAKEUP_TIME("disable_sleep"),
        .WRITE_DATA_WIDTH_A(24),
        .WRITE_MODE_B("read_first")
    ) bank_0 (
        .clka(aclk),
        .ena(palette_write_enable && !write_bank),
        .wea(palette_write_enable && !write_bank),
        .addra(payload_word_index[7:0]),
        .dina(payload_word_data[23:0]),
        .injectdbiterra(1'b0),
        .injectsbiterra(1'b0),
        .clkb(clk_pixel),
        .enb(1'b1),
        .addrb(read_address),
        .doutb(bank_0_rgb),
        .rstb(!resetn_pixel),
        .regceb(1'b1),
        .sleep(1'b0),
        .dbiterrb(),
        .sbiterrb()
    );

    xpm_memory_sdpram #(
        .ADDR_WIDTH_A(8),
        .ADDR_WIDTH_B(8),
        .AUTO_SLEEP_TIME(0),
        .BYTE_WRITE_WIDTH_A(24),
        .CLOCKING_MODE("independent_clock"),
        .ECC_MODE("no_ecc"),
        .MEMORY_INIT_FILE("none"),
        .MEMORY_INIT_PARAM("0"),
        .MEMORY_OPTIMIZATION("true"),
        .MEMORY_PRIMITIVE("block"),
        .MEMORY_SIZE(6144),
        .MESSAGE_CONTROL(0),
        .READ_DATA_WIDTH_B(24),
        .READ_LATENCY_B(1),
        .READ_RESET_VALUE_B("0"),
        .RST_MODE_A("SYNC"),
        .RST_MODE_B("SYNC"),
        .USE_EMBEDDED_CONSTRAINT(0),
        .USE_MEM_INIT(1),
        .WAKEUP_TIME("disable_sleep"),
        .WRITE_DATA_WIDTH_A(24),
        .WRITE_MODE_B("read_first")
    ) bank_1 (
        .clka(aclk),
        .ena(palette_write_enable && write_bank),
        .wea(palette_write_enable && write_bank),
        .addra(payload_word_index[7:0]),
        .dina(payload_word_data[23:0]),
        .injectdbiterra(1'b0),
        .injectsbiterra(1'b0),
        .clkb(clk_pixel),
        .enb(1'b1),
        .addrb(read_address),
        .doutb(bank_1_rgb),
        .rstb(!resetn_pixel),
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
            palette_valid <= 1'b0;
            commit_pending <= 1'b0;
            write_bank <= 1'b1;
            semantic_error <= 1'b0;
            pending_generation <= '0;
            request_toggle <= 1'b0;
            acknowledgement_sync_1 <= 1'b0;
            acknowledgement_sync_2 <= 1'b0;
            acknowledgement_seen <= 1'b0;
        end else begin
            acknowledgement_sync_1 <= acknowledgement_toggle;
            acknowledgement_sync_2 <= acknowledgement_sync_1;
            if (acknowledgement_sync_2 != acknowledgement_seen) begin
                acknowledgement_seen <= acknowledgement_sync_2;
                commit_pending <= 1'b0;
                write_bank <= ~write_bank;
                committed_generation <= pending_generation;
                palette_valid <= 1'b1;
            end

            if (palette_write_enable && payload_word_data[31:24] != 0) begin
                semantic_error <= 1'b1;
            end

            if (upload_packet_done) begin
                if (upload_packet_valid && !semantic_error) begin
                    accepted_packet_count <= accepted_packet_count + 1'b1;
                    pending_generation <= upload_generation;
                    commit_pending <= 1'b1;
                    request_toggle <= ~request_toggle;
                end else begin
                    rejected_packet_count <= rejected_packet_count + 1'b1;
                    sticky_error_flags[7:0] <= sticky_error_flags[7:0]
                        | upload_error_flags;
                    if (semantic_error) begin
                        sticky_error_flags <= sticky_error_flags
                            | ERROR_PALETTE_WORD;
                    end
                end
                semantic_error <= 1'b0;
            end
        end
    end

    always_ff @(posedge clk_pixel) begin
        if (!resetn_pixel) begin
            active_bank <= 1'b0;
            request_sync_1 <= 1'b0;
            request_sync_2 <= 1'b0;
            request_seen <= 1'b0;
            acknowledgement_toggle <= 1'b0;
        end else begin
            request_sync_1 <= request_toggle;
            request_sync_2 <= request_sync_1;
            if (vblank_start && request_sync_2 != request_seen) begin
                request_seen <= request_sync_2;
                active_bank <= ~active_bank;
                acknowledgement_toggle <= ~acknowledgement_toggle;
            end
        end
    end

endmodule