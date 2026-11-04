module scene2d_resource_upload #(
    parameter logic [31:0] EXPECTED_MAGIC = 32'h50443253,
    parameter logic [31:0] EXPECTED_TYPE = 32'd3,
    parameter logic [31:0] EXPECTED_TARGET_ID = 32'd0,
    parameter integer MAX_TARGET_ID = EXPECTED_TARGET_ID,
    parameter integer EXPECTED_PAYLOAD_BYTES = 1024,
    parameter integer MIN_PAYLOAD_BYTES = EXPECTED_PAYLOAD_BYTES,
    parameter integer MAX_PAYLOAD_BYTES = EXPECTED_PAYLOAD_BYTES
) (
    input  logic        aclk,
    input  logic        aresetn,
    input  logic [63:0] s_axis_tdata,
    input  logic [7:0]  s_axis_tkeep,
    input  logic        s_axis_tlast,
    input  logic        s_axis_tvalid,
    output logic        s_axis_tready,
    output logic [31:0] payload_word_data,
    output logic [3:0]  payload_word_keep,
    output logic [31:0] payload_word_index,
    output logic        payload_word_valid,
    input  logic        payload_word_ready,
    output logic        packet_done,
    output logic        packet_valid,
    output logic [31:0] payload_target_id,
    output logic [31:0] completed_generation,
    output logic [31:0] completed_target_id,
    output logic [31:0] completed_crc32,
    output logic [31:0] completed_payload_byte_count,
    output logic [7:0]  completed_error_flags
);

    localparam logic [31:0] ABI_VERSION = 32'h00010000;
    localparam integer HEADER_WORDS = 16;
    localparam integer FIXED_LENGTH = EXPECTED_PAYLOAD_BYTES != 0;
    localparam integer EXPECTED_PAYLOAD_WORDS = EXPECTED_PAYLOAD_BYTES / 4;
    localparam integer EXPECTED_FINAL_LOW_WORD =
        HEADER_WORDS + EXPECTED_PAYLOAD_WORDS - 2;

    localparam logic [7:0] ERROR_MAGIC = 8'b00000001;
    localparam logic [7:0] ERROR_ABI = 8'b00000010;
    localparam logic [7:0] ERROR_ROUTE = 8'b00000100;
    localparam logic [7:0] ERROR_RESERVED = 8'b00001000;
    localparam logic [7:0] ERROR_LENGTH = 8'b00010000;
    localparam logic [7:0] ERROR_TKEEP = 8'b00100000;
    localparam logic [7:0] ERROR_CRC = 8'b01000000;

    logic [31:0] header_words [0:15];
    logic [31:0] word_index;
    logic [31:0] active_crc32;
    logic [31:0] active_payload_byte_count;
    logic [7:0] packet_error_flags;
    logic [31:0] pending_data;
    logic [3:0] pending_keep;
    logic pending_last;
    logic pending_valid;
    logic [31:0] pending_word_index;
    logic [31:0] pending_crc32;
    logic [31:0] pending_payload_byte_count;
    logic finalizing;
    logic [31:0] final_crc32;
    logic [31:0] final_payload_byte_count;
    logic [31:0] lower_crc32;
    logic [31:0] lower_payload_byte_count;
    logic [31:0] upper_crc32;
    logic [31:0] upper_payload_byte_count;
    logic [7:0] input_error_flags;
    logic [7:0] completion_error_flags;
    integer header_index;

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

    function automatic logic [31:0] update_crc32(
        input logic [31:0] crc,
        input logic [31:0] data,
        input logic [3:0] keep
    );
        logic [31:0] next_crc;
        integer byte_index;
        begin
            next_crc = crc;
            for (byte_index = 0; byte_index < 4; byte_index = byte_index + 1) begin
                if (keep[byte_index]) begin
                    next_crc = crc32_byte(
                        next_crc,
                        data[byte_index * 8 +: 8]
                    );
                end
            end
            return next_crc;
        end
    endfunction

    function automatic logic [2:0] keep_count(input logic [3:0] keep);
        begin
            keep_count = keep[0] + keep[1] + keep[2] + keep[3];
        end
    endfunction

    function automatic logic valid_last_keep(input logic [7:0] keep);
        begin
            case (keep)
                8'h01, 8'h03, 8'h07, 8'h0F,
                8'h1F, 8'h3F, 8'h7F, 8'hFF: valid_last_keep = 1'b1;
                default: valid_last_keep = 1'b0;
            endcase
        end
    endfunction

    initial begin
        if (
            (FIXED_LENGTH && (
                EXPECTED_PAYLOAD_BYTES <= 0 || EXPECTED_PAYLOAD_BYTES % 8 != 0
            )) ||
            MIN_PAYLOAD_BYTES < 0 || MAX_PAYLOAD_BYTES < MIN_PAYLOAD_BYTES ||
            MAX_TARGET_ID < EXPECTED_TARGET_ID
        ) begin
            $error("invalid resource upload parameter bounds");
            $finish;
        end
    end

    assign s_axis_tready = !pending_valid && !finalizing && (
        word_index < HEADER_WORDS || payload_word_ready
    );
    assign payload_word_data = pending_valid
        ? pending_data
        : s_axis_tdata[31:0];
    assign payload_word_keep = pending_valid
        ? pending_keep
        : s_axis_tkeep[3:0];
    assign payload_word_index = pending_valid
        ? pending_word_index - HEADER_WORDS
        : word_index - HEADER_WORDS;
    assign payload_word_valid = pending_valid
        ? pending_word_index >= HEADER_WORDS
        : s_axis_tvalid && word_index >= HEADER_WORDS;
    assign payload_target_id = header_words[3];

    always_comb begin
        lower_crc32 = active_crc32;
        lower_payload_byte_count = active_payload_byte_count;
        if (word_index >= HEADER_WORDS) begin
            lower_crc32 = update_crc32(
                active_crc32,
                s_axis_tdata[31:0],
                s_axis_tkeep[3:0]
            );
            lower_payload_byte_count = active_payload_byte_count
                + keep_count(s_axis_tkeep[3:0]);
        end

        upper_crc32 = pending_crc32;
        upper_payload_byte_count = pending_payload_byte_count;
        if (pending_word_index >= HEADER_WORDS) begin
            upper_crc32 = update_crc32(
                pending_crc32,
                pending_data,
                pending_keep
            );
            upper_payload_byte_count = pending_payload_byte_count
                + keep_count(pending_keep);
        end

        input_error_flags = packet_error_flags;
        if (
            (FIXED_LENGTH && s_axis_tkeep != 8'hFF) ||
            (word_index < HEADER_WORDS && s_axis_tkeep != 8'hFF) ||
            (!s_axis_tlast && s_axis_tkeep != 8'hFF) ||
            (s_axis_tlast && !valid_last_keep(s_axis_tkeep))
        ) begin
            input_error_flags = input_error_flags | ERROR_TKEEP;
        end
        if (
            (FIXED_LENGTH && s_axis_tlast != (
                word_index == EXPECTED_FINAL_LOW_WORD
            )) ||
            (!FIXED_LENGTH && s_axis_tlast && word_index < HEADER_WORDS)
        ) begin
            input_error_flags = input_error_flags | ERROR_LENGTH;
        end

        completion_error_flags = packet_error_flags;
        if (header_words[0] != EXPECTED_MAGIC) begin
            completion_error_flags = completion_error_flags | ERROR_MAGIC;
        end
        if (header_words[1] != ABI_VERSION) begin
            completion_error_flags = completion_error_flags | ERROR_ABI;
        end
        if (
            header_words[2] != EXPECTED_TYPE ||
            header_words[3] < EXPECTED_TARGET_ID ||
            header_words[3] > MAX_TARGET_ID
        ) begin
            completion_error_flags = completion_error_flags | ERROR_ROUTE;
        end
        if (
            header_words[7] != 0 || header_words[8] != 0 ||
            header_words[9] != 0 || header_words[10] != 0 ||
            header_words[11] != 0 || header_words[12] != 0 ||
            header_words[13] != 0 || header_words[14] != 0 ||
            header_words[15] != 0
        ) begin
            completion_error_flags = completion_error_flags | ERROR_RESERVED;
        end
        if (
            (FIXED_LENGTH && header_words[5] != EXPECTED_PAYLOAD_BYTES) ||
            header_words[5] < MIN_PAYLOAD_BYTES ||
            header_words[5] > MAX_PAYLOAD_BYTES ||
            final_payload_byte_count != header_words[5] ||
            (FIXED_LENGTH && pending_word_index !=
                HEADER_WORDS + EXPECTED_PAYLOAD_WORDS - 1)
        ) begin
            completion_error_flags = completion_error_flags | ERROR_LENGTH;
        end
        if (~final_crc32 != header_words[6]) begin
            completion_error_flags = completion_error_flags | ERROR_CRC;
        end
    end

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            for (header_index = 0; header_index < 16; header_index = header_index + 1) begin
                header_words[header_index] <= '0;
            end
            word_index <= '0;
            active_crc32 <= 32'hFFFFFFFF;
            active_payload_byte_count <= '0;
            packet_error_flags <= '0;
            pending_data <= '0;
            pending_keep <= '0;
            pending_last <= 1'b0;
            pending_valid <= 1'b0;
            pending_word_index <= '0;
            pending_crc32 <= '0;
            pending_payload_byte_count <= '0;
            finalizing <= 1'b0;
            final_crc32 <= '0;
            final_payload_byte_count <= '0;
            packet_done <= 1'b0;
            packet_valid <= 1'b0;
            completed_target_id <= '0;
            completed_generation <= '0;
            completed_crc32 <= '0;
            completed_payload_byte_count <= '0;
            completed_error_flags <= '0;
        end else begin
            packet_done <= 1'b0;
            packet_valid <= 1'b0;

            if (finalizing) begin
                packet_done <= 1'b1;
                packet_valid <= completion_error_flags == 0;
                completed_generation <= header_words[4];
                completed_target_id <= header_words[3];
                completed_crc32 <= ~final_crc32;
                completed_payload_byte_count <= final_payload_byte_count;
                completed_error_flags <= completion_error_flags;
                word_index <= '0;
                active_crc32 <= 32'hFFFFFFFF;
                active_payload_byte_count <= '0;
                packet_error_flags <= '0;
                finalizing <= 1'b0;
            end else if (pending_valid && (
                pending_word_index < HEADER_WORDS || payload_word_ready
            )) begin
                pending_valid <= 1'b0;
                if (pending_word_index < HEADER_WORDS) begin
                    header_words[pending_word_index] <= pending_data;
                end
                if (pending_last) begin
                    finalizing <= 1'b1;
                    final_crc32 <= upper_crc32;
                    final_payload_byte_count <= upper_payload_byte_count;
                end else begin
                    word_index <= pending_word_index + 1'b1;
                    active_crc32 <= upper_crc32;
                    active_payload_byte_count <= upper_payload_byte_count;
                end
            end else if (s_axis_tvalid && s_axis_tready) begin
                if (word_index < HEADER_WORDS) begin
                    header_words[word_index] <= s_axis_tdata[31:0];
                end
                active_crc32 <= lower_crc32;
                active_payload_byte_count <= lower_payload_byte_count;
                packet_error_flags <= input_error_flags;
                pending_data <= s_axis_tdata[63:32];
                pending_keep <= s_axis_tkeep[7:4];
                pending_last <= s_axis_tlast;
                pending_valid <= 1'b1;
                pending_word_index <= word_index + 1'b1;
                pending_crc32 <= lower_crc32;
                pending_payload_byte_count <= lower_payload_byte_count;
            end
        end
    end

endmodule