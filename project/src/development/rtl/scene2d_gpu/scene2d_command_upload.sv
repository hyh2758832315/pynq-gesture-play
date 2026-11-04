module scene2d_command_upload #(
    parameter bit UPLOAD_RENDER_OVERLAP_ENABLE = 1'b0
) (
    input  logic        aclk,
    input  logic        aresetn,
    input  logic [63:0] s_axis_tdata,
    input  logic [7:0]  s_axis_tkeep,
    input  logic        s_axis_tlast,
    input  logic        s_axis_tvalid,
    output logic        s_axis_tready,
    input  logic [8:0]  command_read_address,
    input  logic        render_bank_valid,
    input  logic        render_bank_select,
    input  logic [2:0]  generation_check_enable,
    input  logic [2:0]  resource_generation_valid,
    input  logic [31:0] required_palette_generation,
    input  logic [31:0] required_asset_generation,
    input  logic [31:0] required_tilemap_generation,
    output logic        generation_rejected,
    output logic [63:0] command_read_data,
    output logic [31:0] command_read_data_low,
    output logic [31:0] command_read_data_high,
    output logic [31:0] completed_crc32,
    output logic [31:0] completed_byte_count,
    output logic [31:0] completed_packet_count,
    output logic [31:0] accepted_packet_count,
    output logic [31:0] rejected_packet_count,
    output logic [31:0] accepted_seq,
    output logic [31:0] accepted_palette_generation,
    output logic [31:0] accepted_asset_generation,
    output logic [31:0] accepted_tilemap_generation,
    output logic [8:0]  accepted_command_count,
    output logic [31:0] accepted_status,
    output logic [5:0]  sticky_error_flags,
    output logic        active_bank,
    output logic        bank_valid
);

    localparam logic [31:0] SCENE_MAGIC = 32'h47443253;
    localparam logic [31:0] ABI_VERSION = 32'h00010000;
    localparam logic [9:0] EXPECTED_LAST_BEAT = 10'd519;

    localparam logic [5:0] ERROR_MAGIC = 6'b000001;
    localparam logic [5:0] ERROR_ABI = 6'b000010;
    localparam logic [5:0] ERROR_COMMAND_COUNT = 6'b000100;
    localparam logic [5:0] ERROR_RESERVED = 6'b001000;
    localparam logic [5:0] ERROR_LENGTH = 6'b010000;
    localparam logic [5:0] ERROR_TKEEP = 6'b100000;

    logic [31:0] header_words [0:15];
    logic [9:0] beat_index;
    logic [5:0] packet_error_flags;
    logic [5:0] completion_error_flags;
    logic sink_ready;
    logic upload_accepted;
    logic write_bank;
    logic command_write_enable;
    logic [8:0] command_write_address;
    logic [63:0] command_bank_0_read_data;
    logic [63:0] command_bank_1_read_data;
    logic command_read_bank;
    logic generation_mismatch;

    assign s_axis_tready = sink_ready;
    assign upload_accepted = s_axis_tvalid && sink_ready;
    assign write_bank = ~active_bank;
    assign command_write_enable =
        upload_accepted && beat_index >= 10'd8 && beat_index <= EXPECTED_LAST_BEAT;
    assign command_write_address = beat_index - 10'd8;
    assign command_read_bank = UPLOAD_RENDER_OVERLAP_ENABLE && render_bank_valid
        ? render_bank_select : active_bank;
    assign command_read_data = command_read_bank
        ? command_bank_1_read_data
        : command_bank_0_read_data;
    assign command_read_data_low = command_read_data[31:0];
    assign command_read_data_high = command_read_data[63:32];
    assign generation_mismatch = UPLOAD_RENDER_OVERLAP_ENABLE && (
        (generation_check_enable[0] && (!resource_generation_valid[0] || header_words[8] != required_palette_generation)) ||
        (generation_check_enable[1] && (!resource_generation_valid[1] || header_words[10] != required_asset_generation)) ||
        (generation_check_enable[2] && (!resource_generation_valid[2] || header_words[11] != required_tilemap_generation))
    );
    assign accepted_status = {
        21'd0,
        bank_valid,
        active_bank,
        accepted_command_count
    };

    scene2d_upload_sink upload_sink (
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tkeep(s_axis_tkeep),
        .s_axis_tlast(s_axis_tlast),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(sink_ready),
        .completed_crc32(completed_crc32),
        .completed_byte_count(completed_byte_count),
        .completed_packet_count(completed_packet_count)
    );

    xpm_memory_sdpram #(
        .ADDR_WIDTH_A(9),
        .ADDR_WIDTH_B(9),
        .BYTE_WRITE_WIDTH_A(64),
        .CLOCKING_MODE("common_clock"),
        .MEMORY_INIT_FILE("none"),
        .MEMORY_INIT_PARAM("0"),
        .MEMORY_OPTIMIZATION("true"),
        .MEMORY_PRIMITIVE("block"),
        .MEMORY_SIZE(32768),
        .READ_DATA_WIDTH_B(64),
        .READ_LATENCY_B(1),
        .READ_RESET_VALUE_B("0"),
        .RST_MODE_B("SYNC"),
        .USE_MEM_INIT(1),
        .WAKEUP_TIME("disable_sleep"),
        .WRITE_DATA_WIDTH_A(64),
        .WRITE_MODE_B("read_first")
    ) command_bank_0 (
        .addra(command_write_address),
        .addrb(command_read_address),
        .clka(aclk),
        .clkb(aclk),
        .dina(s_axis_tdata),
        .doutb(command_bank_0_read_data),
        .ena(1'b1),
        .enb(1'b1),
        .injectdbiterra(1'b0),
        .injectsbiterra(1'b0),
        .regceb(1'b1),
        .rstb(!aresetn),
        .sleep(1'b0),
        .wea(command_write_enable && !write_bank)
    );

    xpm_memory_sdpram #(
        .ADDR_WIDTH_A(9),
        .ADDR_WIDTH_B(9),
        .BYTE_WRITE_WIDTH_A(64),
        .CLOCKING_MODE("common_clock"),
        .MEMORY_INIT_FILE("none"),
        .MEMORY_INIT_PARAM("0"),
        .MEMORY_OPTIMIZATION("true"),
        .MEMORY_PRIMITIVE("block"),
        .MEMORY_SIZE(32768),
        .READ_DATA_WIDTH_B(64),
        .READ_LATENCY_B(1),
        .READ_RESET_VALUE_B("0"),
        .RST_MODE_B("SYNC"),
        .USE_MEM_INIT(1),
        .WAKEUP_TIME("disable_sleep"),
        .WRITE_DATA_WIDTH_A(64),
        .WRITE_MODE_B("read_first")
    ) command_bank_1 (
        .addra(command_write_address),
        .addrb(command_read_address),
        .clka(aclk),
        .clkb(aclk),
        .dina(s_axis_tdata),
        .doutb(command_bank_1_read_data),
        .ena(1'b1),
        .enb(1'b1),
        .injectdbiterra(1'b0),
        .injectsbiterra(1'b0),
        .regceb(1'b1),
        .rstb(!aresetn),
        .sleep(1'b0),
        .wea(command_write_enable && write_bank)
    );

    always_comb begin
        completion_error_flags = packet_error_flags;
        if (s_axis_tkeep != 8'hFF) begin
            completion_error_flags = completion_error_flags | ERROR_TKEEP;
        end
        if (beat_index != EXPECTED_LAST_BEAT) begin
            completion_error_flags = completion_error_flags | ERROR_LENGTH;
        end
        if (header_words[0] != SCENE_MAGIC) begin
            completion_error_flags = completion_error_flags | ERROR_MAGIC;
        end
        if (header_words[1] != ABI_VERSION) begin
            completion_error_flags = completion_error_flags | ERROR_ABI;
        end
        if (header_words[4] > 32'd128) begin
            completion_error_flags = completion_error_flags | ERROR_COMMAND_COUNT;
        end
        if (
            header_words[12] != 0 ||
            header_words[13] != 0 || header_words[14] != 0 ||
            header_words[15] != 0
        ) begin
            completion_error_flags = completion_error_flags | ERROR_RESERVED;
        end
    end

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            beat_index <= '0;
            packet_error_flags <= '0;
            accepted_packet_count <= '0;
            rejected_packet_count <= '0;
            accepted_seq <= '0;
            accepted_palette_generation <= '0;
            accepted_asset_generation <= '0;
            accepted_tilemap_generation <= '0;
            accepted_command_count <= '0;
            sticky_error_flags <= '0;
            active_bank <= 1'b0;
            bank_valid <= 1'b0;
            generation_rejected <= 1'b0;
        end else if (upload_accepted) begin
            if (beat_index < 10'd8) begin
                header_words[beat_index * 2] <= s_axis_tdata[31:0];
                header_words[beat_index * 2 + 1] <= s_axis_tdata[63:32];
            end

            if (s_axis_tkeep != 8'hFF) begin
                packet_error_flags <= packet_error_flags | ERROR_TKEEP;
            end
            if (beat_index == EXPECTED_LAST_BEAT && !s_axis_tlast) begin
                packet_error_flags <= packet_error_flags | ERROR_LENGTH;
            end

            if (s_axis_tlast) begin
                if (completion_error_flags == 0 && !generation_mismatch) begin
                    active_bank <= write_bank;
                    bank_valid <= 1'b1;
                    accepted_seq <= header_words[3];
                    accepted_palette_generation <= header_words[8];
                    accepted_asset_generation <= header_words[10];
                    accepted_tilemap_generation <= header_words[11];
                    accepted_command_count <= header_words[4][8:0];
                    accepted_packet_count <= accepted_packet_count + 1'b1;
                end else begin
                    rejected_packet_count <= rejected_packet_count + 1'b1;
                    sticky_error_flags <= sticky_error_flags | completion_error_flags;
                    if (generation_mismatch) generation_rejected <= 1'b1;
                end
                beat_index <= '0;
                packet_error_flags <= '0;
            end else if (beat_index != 10'h3FF) begin
                beat_index <= beat_index + 1'b1;
            end
        end
    end

endmodule