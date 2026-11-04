module vision_capture_drain #(
    parameter integer INPUT_WIDTH = 1280,
    parameter integer INPUT_HEIGHT = 720,
    parameter integer EPOCH_FRAMES = 1,
    parameter integer CONTINUOUS = 0
)(
    input wire aclk, aresetn,
    input wire source_valid, source_ready,
    input wire rgb_valid, rgb_ready,
    input wire packet_valid, packet_ready, packet_last,
    input wire [3:0] packet_keep,
    input wire capture_fault,
    input wire source_closed,
    input wire [31:0] closed_frame_count,
    output wire pipeline_drained,
    output reg integrity_fault
);
    localparam [63:0] SOURCE_PIXELS = 64'd1 * INPUT_WIDTH * INPUT_HEIGHT * EPOCH_FRAMES;
    localparam [63:0] MASK_PIXELS = 64'd1 * (INPUT_WIDTH / 2) * (INPUT_HEIGHT / 2);
    localparam [63:0] FRAME_WORDS = (MASK_PIXELS + 1) / 2 + 16;
    localparam [63:0] PACKET_WORDS = FRAME_WORDS * EPOCH_FRAMES;
    localparam integer SOURCE_BITS = CONTINUOUS ? 64 : $clog2(SOURCE_PIXELS + 1);
    localparam integer PACKET_BITS = CONTINUOUS ? 64 : $clog2(PACKET_WORDS + 1);
    localparam integer WORD_BITS = $clog2(FRAME_WORDS);
    reg [SOURCE_BITS-1:0] source_count, rgb_count;
    reg [PACKET_BITS-1:0] packet_count;
    reg [WORD_BITS-1:0] word_index;
    reg closure_held;
    reg [31:0] frames_held;
    reg [63:0] final_source_pixels, final_packet_words;
    wire [63:0] source_limit = CONTINUOUS ? final_source_pixels : SOURCE_PIXELS;
    wire [63:0] packet_limit = CONTINUOUS ? final_packet_words : PACKET_WORDS;
    wire limit_valid = !CONTINUOUS || closure_held;
    wire source_fire = source_valid && source_ready;
    wire rgb_fire = rgb_valid && rgb_ready;
    wire packet_fire = packet_valid && packet_ready;

    initial begin
        if (INPUT_WIDTH < 4 || INPUT_HEIGHT < 4 || INPUT_WIDTH > 1280 || INPUT_HEIGHT > 720 ||
            INPUT_WIDTH % 2 || INPUT_HEIGHT % 2 || EPOCH_FRAMES < 1 ||
            SOURCE_PIXELS > 64'hffffffff || PACKET_WORDS > 64'hffffffff)
            $fatal(1, "CAPTURE_DRAIN geometry/epoch outside capability");
    end
    assign pipeline_drained = aresetn && !integrity_fault && !capture_fault &&
        limit_valid && source_count == source_limit && rgb_count == source_limit && packet_count == packet_limit &&
        !source_valid && !rgb_valid && !packet_valid;

    always @(posedge aclk) begin
        if (!aresetn) begin
            source_count <= 0;
            rgb_count <= 0;
            packet_count <= 0;
            word_index <= 0;
            closure_held <= 0;
            frames_held <= 0;
            final_source_pixels <= 0;
            final_packet_words <= 0;
            integrity_fault <= 0;
        end else begin
            if (capture_fault) integrity_fault <= 1;
            if (CONTINUOUS) begin
                if (source_closed && !closure_held) begin
                    closure_held <= 1;
                    frames_held <= closed_frame_count;
                    final_source_pixels <= 64'd1 * INPUT_WIDTH * INPUT_HEIGHT * closed_frame_count;
                    final_packet_words <= FRAME_WORDS * closed_frame_count;
                end
                if (closure_held && (!source_closed || closed_frame_count != frames_held ||
                    source_count > source_limit || rgb_count > source_limit || packet_count > packet_limit))
                    integrity_fault <= 1;
            end
            if (source_fire) begin
                if (source_count == {SOURCE_BITS{1'b1}} || (limit_valid && source_count == source_limit)) integrity_fault <= 1;
                else source_count <= source_count + 1'b1;
            end
            if (rgb_fire) begin
                if (rgb_count == {SOURCE_BITS{1'b1}} || (limit_valid && rgb_count == source_limit)) integrity_fault <= 1;
                else rgb_count <= rgb_count + 1'b1;
                if (rgb_count >= source_count && !source_fire) integrity_fault <= 1;
            end
            if (packet_fire) begin
                if (packet_count == {PACKET_BITS{1'b1}} || (limit_valid && packet_count == packet_limit)) integrity_fault <= 1;
                else packet_count <= packet_count + 1'b1;
                if (packet_keep != 4'hf || packet_last != (word_index == FRAME_WORDS - 1) ||
                    (source_count == 0 && !source_fire)) integrity_fault <= 1;
                if (word_index == FRAME_WORDS - 1) word_index <= 0;
                else word_index <= word_index + 1'b1;
            end
        end
    end
endmodule