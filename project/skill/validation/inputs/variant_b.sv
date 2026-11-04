module scene2d_upload_sink (
    input  logic        aclk,
    input  logic        aresetn,
    input  logic [63:0] s_axis_tdata,
    input  logic [7:0]  s_axis_tkeep,
    input  logic        s_axis_tlast,
    input  logic        s_axis_tvalid,
    output logic        s_axis_tready,
    output logic [31:0] completed_crc32,
    output logic [31:0] completed_byte_count,
    output logic [31:0] completed_packet_count
);

    logic [31:0] active_crc32;
    logic [31:0] active_byte_count;
    logic [31:0] pending_crc32;
    logic [31:0] pending_byte_count;
    logic [31:0] held_upper_word;
    logic [3:0]  pending_keep;
    logic        pending_last;
    logic        pending_valid;

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

    assign s_axis_tready = !pending_valid;

    integer byte_index;
    logic [31:0] lower_crc32;
    logic [31:0] lower_byte_count;
    logic [31:0] upper_crc32;
    logic [31:0] upper_byte_count;
    always_comb begin
        lower_crc32 = active_crc32;
        lower_byte_count = active_byte_count;
        for (byte_index = 0; byte_index < 4; byte_index = byte_index + 1) begin
            if (s_axis_tkeep[byte_index]) begin
                lower_crc32 = crc32_byte(
                    lower_crc32,
                    s_axis_tdata[byte_index * 8 +: 8]
                );
                lower_byte_count = lower_byte_count + 1'b1;
            end
        end

        upper_crc32 = pending_crc32;
        upper_byte_count = pending_byte_count;
        for (byte_index = 0; byte_index < 4; byte_index = byte_index + 1) begin
            if (pending_keep[byte_index]) begin
                upper_crc32 = crc32_byte(
                    upper_crc32,
                    held_upper_word[byte_index * 8 +: 8]
                );
                upper_byte_count = upper_byte_count + 1'b1;
            end
        end
    end

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            active_crc32 <= 32'hFFFFFFFF;
            active_byte_count <= '0;
            pending_crc32 <= '0;
            pending_byte_count <= '0;
            held_upper_word <= '0;
            pending_keep <= '0;
            pending_last <= 1'b0;
            pending_valid <= 1'b0;
            completed_crc32 <= 32'd1;
            completed_byte_count <= '0;
            completed_packet_count <= '0;
        end else if (pending_valid) begin
            pending_valid <= 1'b0;
            if (pending_last) begin
                completed_crc32 <= ~upper_crc32;
                completed_byte_count <= upper_byte_count;
                completed_packet_count <= completed_packet_count + 1'b1;
                active_crc32 <= 32'hFFFFFFFF;
                active_byte_count <= '0;
            end else begin
                active_crc32 <= upper_crc32;
                active_byte_count <= upper_byte_count;
            end
        end else if (s_axis_tvalid && s_axis_tready) begin
            pending_crc32 <= lower_crc32;
            pending_byte_count <= lower_byte_count;
            held_upper_word <= s_axis_tdata[63:32];
            pending_keep <= s_axis_tkeep[7:4];
            pending_last <= s_axis_tlast;
            pending_valid <= 1'b1;
        end
    end

endmodule