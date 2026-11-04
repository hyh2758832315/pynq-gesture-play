module axis_dual_mask_packet #(
    parameter integer WIDTH = 640,
    parameter integer HEIGHT = 360
)(
    input wire aclk,
    input wire aresetn,
    input wire [15:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,
    input wire s_axis_tuser,
    input wire s_axis_tlast,
    input wire [143:0] s_frame_context,
    input wire upstream_fault,
    output wire [31:0] m_axis_tdata,
    output wire [3:0] m_axis_tkeep,
    output wire m_axis_tvalid,
    input wire m_axis_tready,
    output wire m_axis_tlast,
    output reg frame_fault
);
    localparam [1:0] PAYLOAD = 0, TRAILER = 1, ABORT = 2;
    localparam integer PIXELS = WIDTH * HEIGHT;
    reg [1:0] state;
    reg [143:0] context_word;
    reg [31:0] pixel_count, status_word, crc;
    reg [3:0] trailer_index;
    reg [15:0] half_word;
    reg half_valid;
    reg [31:0] payload_word;
    reg payload_valid, payload_last;
    reg [31:0] trailer_word;
    wire advance = !payload_valid || m_axis_tready;
    wire [31:0] input_status =
        ((s_axis_tuser != (pixel_count == 0) || s_axis_tlast != (pixel_count == PIXELS-1)) ? 32'd1 : 32'd0) |
        ((s_axis_tdata[7:0] != 0 && s_axis_tdata[7:0] != 255) ? 32'd2 : 32'd0) |
        ((pixel_count != 0 && s_frame_context != context_word) ? 32'd4 : 32'd0);
    wire input_end = s_axis_tlast || pixel_count == PIXELS-1 || input_status != 0;

    function automatic [31:0] crc_word(input [31:0] previous_crc, value);
        reg [31:0] work;
        integer bit_index;
        begin
            work = previous_crc ^ value;
            for (bit_index = 0; bit_index < 32; bit_index = bit_index + 1)
                work = (work >> 1) ^ (work[0] ? 32'hedb88320 : 32'd0);
            crc_word = work;
        end
    endfunction

    assign s_axis_tready = aresetn && state == PAYLOAD && !frame_fault && !upstream_fault &&
                           (!payload_valid || (m_axis_tready && !payload_last));
    assign m_axis_tdata = state == TRAILER ? trailer_word : payload_word;
    assign m_axis_tkeep = 4'hf;
    assign m_axis_tvalid = aresetn && (state == TRAILER || payload_valid);
    assign m_axis_tlast = state == TRAILER && trailer_index == 15;

    initial begin
        if (WIDTH < 1 || HEIGHT < 1 || WIDTH > 640 || HEIGHT > 360)
            $fatal(1, "DMS1 packet geometry outside capability");
    end
    always @* begin
        case (trailer_index)
            0: trailer_word = 32'h31534d44;
            1: trailer_word = 32'h00100001;
            2: trailer_word = context_word[79:48];
            3: trailer_word = context_word[111:80];
            4: trailer_word = context_word[143:112];
            5: trailer_word = (HEIGHT << 16) | WIDTH;
            6: trailer_word = pixel_count;
            7: trailer_word = ((pixel_count + 1) >> 1) << 2;
            8: trailer_word = status_word;
            9: trailer_word = context_word[31:0];
            10: trailer_word = {16'd0, context_word[47:32]};
            11: trailer_word = 32'h00010802;
            15: trailer_word = ~crc;
            default: trailer_word = 0;
        endcase
    end

    always @(posedge aclk) begin
        if (!aresetn) begin
            state <= PAYLOAD;
            context_word <= 0;
            pixel_count <= 0;
            status_word <= 0;
            crc <= 32'hffffffff;
            trailer_index <= 0;
            half_word <= 0;
            half_valid <= 0;
            payload_word <= 0;
            payload_valid <= 0;
            payload_last <= 0;
            frame_fault <= 0;
        end else begin
            if (payload_valid && m_axis_tready && state != TRAILER) begin
                payload_valid <= 0;
                crc <= crc_word(crc, payload_word);
                if (payload_last) begin
                    state <= TRAILER;
                    trailer_index <= 0;
                end
            end
            if (s_axis_tvalid && s_axis_tready) begin
                if (pixel_count == 0) context_word <= s_frame_context;
                pixel_count <= pixel_count + 1'b1;
                if (input_status != 0) begin
                    status_word <= input_status;
                    frame_fault <= 1;
                end
                if (half_valid || input_end) begin
                    payload_word <= half_valid ? {s_axis_tdata, half_word} : {16'd0, s_axis_tdata};
                    payload_valid <= 1;
                    payload_last <= input_end;
                    half_valid <= 0;
                end else begin
                    half_word <= s_axis_tdata;
                    half_valid <= 1;
                end
            end
            if (state == TRAILER && m_axis_tready) begin
                if (trailer_index == 15) begin
                    state <= PAYLOAD;
                    pixel_count <= 0;
                    status_word <= 0;
                    crc <= 32'hffffffff;
                    trailer_index <= 0;
                end else begin
                    crc <= crc_word(crc, trailer_word);
                    trailer_index <= trailer_index + 1'b1;
                end
            end
            if (state == ABORT && advance) begin
                if (half_valid) begin
                    payload_word <= {16'd0, half_word};
                    payload_valid <= 1;
                    payload_last <= 1;
                    half_valid <= 0;
                end else begin
                    state <= TRAILER;
                    trailer_index <= 0;
                end
            end
            if (upstream_fault && !frame_fault) begin
                frame_fault <= 1;
                if (state == PAYLOAD) begin
                    state <= ABORT;
                    status_word <= status_word | 32'd8;
                end
            end
        end
    end
endmodule