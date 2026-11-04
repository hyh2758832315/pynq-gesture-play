module vision_axi_write_drain #(
    parameter integer DATA_BYTES = 8,
    parameter [63:0] EXPECTED_BYTES = 64'd460864,
    parameter [63:0] MAX_WRITE_BEATS = EXPECTED_BYTES,
    parameter integer CONTINUOUS = 0,
    parameter integer TRACK_FRAME_COMPLETIONS = 0,
    parameter integer RESPONSE_DEPTH = 16
)(
    input wire aclk, aresetn,
    input wire awvalid, awready,
    input wire [7:0] awlen,
    input wire wvalid, wready, wlast,
    input wire [DATA_BYTES-1:0] wstrb,
    input wire bvalid, bready,
    input wire [1:0] bresp,
    input wire upstream_fault,
    input wire source_closed,
    input wire [63:0] closed_byte_count,
    output wire writes_drained,
    output wire [31:0] acknowledged_frames,
    output reg integrity_fault
);
    localparam integer BYTE_BITS = CONTINUOUS ? 64 : $clog2(EXPECTED_BYTES + 1);
    localparam integer BEAT_BITS = CONTINUOUS ? 64 : $clog2(MAX_WRITE_BEATS + 1);
    reg [BYTE_BITS-1:0] byte_count;
    reg [BEAT_BITS-1:0] aw_count, aw_beats, w_beats, last_count, response_count;
    reg closure_held;
    reg [63:0] final_bytes;
    wire [63:0] byte_limit = CONTINUOUS ? final_bytes : EXPECTED_BYTES;
    wire [63:0] beat_limit = CONTINUOUS ? 64'hffffffffffffffff : MAX_WRITE_BEATS;
    wire limit_valid = !CONTINUOUS || closure_held;
    wire aw_fire = awvalid && awready;
    wire w_fire = wvalid && wready;
    wire b_fire = bvalid && bready;

    function automatic [63:0] enabled_bytes(input [DATA_BYTES-1:0] strobes);
        integer lane;
        begin
            enabled_bytes = 0;
            for (lane = 0; lane < DATA_BYTES; lane = lane + 1)
                enabled_bytes = enabled_bytes + strobes[lane];
        end
    endfunction
    wire [64:0] next_bytes = 65'd0 + byte_count + enabled_bytes(wstrb);
    wire [64:0] next_aw_beats = 65'd1 + aw_beats + awlen;
    wire response_has_address = response_count < aw_count ||
        (response_count == aw_count && aw_fire);
    wire response_has_last = response_count < last_count ||
        (response_count == last_count && w_fire && wlast);
    wire ledger_complete = limit_valid && byte_count == byte_limit && (aw_count != 0 || (CONTINUOUS && byte_limit == 0)) &&
        aw_count == last_count && aw_count == response_count && aw_beats == w_beats;
    wire frame_tracking_fault;
    assign writes_drained = aresetn && !upstream_fault && !integrity_fault && !frame_tracking_fault &&
        ledger_complete && !awvalid && !wvalid && !bvalid;

    generate if (TRACK_FRAME_COMPLETIONS) begin : frame_completion
        localparam integer POINTER_BITS = $clog2(RESPONSE_DEPTH);
        reg [7:0] pending_lengths [0:RESPONSE_DEPTH-1];
        reg [POINTER_BITS-1:0] read_pointer, write_pointer;
        reg [POINTER_BITS:0] pending_count;
        reg [31:0] frame_bytes, completed_frames;
        reg tracking_fault;
        wire push_address = aw_fire && (pending_count < RESPONSE_DEPTH || b_fire);
        wire pop_response = b_fire && (pending_count != 0 || aw_fire);
        wire [7:0] response_length = pending_count == 0 ? awlen : pending_lengths[read_pointer];
        wire [32:0] next_frame_bytes = {1'b0,frame_bytes} + (33'd1 + response_length)*DATA_BYTES;
        wire frame_too_large = EXPECTED_BYTES == DATA_BYTES ? response_length != 0 :
            next_frame_bytes > EXPECTED_BYTES;
        wire frame_complete = EXPECTED_BYTES == DATA_BYTES ? response_length == 0 :
            next_frame_bytes == EXPECTED_BYTES;
        assign acknowledged_frames = completed_frames;
        assign frame_tracking_fault = tracking_fault;
        initial begin
            if (RESPONSE_DEPTH < 2 || (RESPONSE_DEPTH & (RESPONSE_DEPTH-1)) ||
                EXPECTED_BYTES % DATA_BYTES != 0)
                $fatal(1,"AXI_WRITE_FRAME completion requires aligned frames and power-of-two response capacity");
        end
        always @(posedge aclk) begin
            if (!aresetn) begin
                read_pointer <= 0;
                write_pointer <= 0;
                pending_count <= 0;
                frame_bytes <= 0;
                completed_frames <= 0;
                tracking_fault <= 0;
            end else begin
                if ((aw_fire && !push_address) || (b_fire && !pop_response) ||
                    (w_fire && !(&wstrb))) tracking_fault <= 1;
                if (push_address) begin
                    pending_lengths[write_pointer] <= awlen;
                    write_pointer <= write_pointer + 1'b1;
                end
                if (pop_response) read_pointer <= read_pointer + 1'b1;
                case ({push_address,pop_response})
                    2'b10: pending_count <= pending_count + 1'b1;
                    2'b01: pending_count <= pending_count - 1'b1;
                    default: pending_count <= pending_count;
                endcase
                if (pop_response && !tracking_fault && !integrity_fault && !upstream_fault &&
                    bresp == 0 && response_has_address && response_has_last &&
                    (!w_fire || (&wstrb))) begin
                    if (frame_too_large) tracking_fault <= 1;
                    else if (frame_complete) begin
                        if (completed_frames == 32'hffffffff) tracking_fault <= 1;
                        else begin
                            completed_frames <= completed_frames + 1'b1;
                            frame_bytes <= 0;
                        end
                    end else frame_bytes <= next_frame_bytes[31:0];
                end
            end
        end
    end else begin : no_frame_completion
        assign acknowledged_frames = 0;
        assign frame_tracking_fault = 0;
    end endgenerate

    initial begin
        if (DATA_BYTES < 1 || DATA_BYTES > 16 || (DATA_BYTES & (DATA_BYTES - 1)) ||
            EXPECTED_BYTES < 1 || EXPECTED_BYTES > 64'hffffffff ||
            MAX_WRITE_BEATS < 1 || MAX_WRITE_BEATS > 64'hffffffff)
            $fatal(1, "AXI_WRITE_DRAIN parameters outside capability");
    end
    always @(posedge aclk) begin
        if (!aresetn) begin
            byte_count <= 0;
            aw_count <= 0;
            aw_beats <= 0;
            w_beats <= 0;
            last_count <= 0;
            response_count <= 0;
            closure_held <= 0;
            final_bytes <= 0;
            integrity_fault <= 0;
        end else begin
            if (upstream_fault || frame_tracking_fault || (ledger_complete && (aw_fire || w_fire || b_fire))) integrity_fault <= 1;
            if (CONTINUOUS) begin
                if (source_closed && !closure_held) begin
                    closure_held <= 1;
                    final_bytes <= closed_byte_count;
                end
                if (closure_held && (!source_closed || closed_byte_count != final_bytes || byte_count > byte_limit))
                    integrity_fault <= 1;
                if (limit_valid && byte_count == byte_limit && (w_fire || (aw_fire && next_aw_beats > w_beats)))
                    integrity_fault <= 1;
            end
            if (aw_fire) begin
                if (aw_count == beat_limit) integrity_fault <= 1;
                else aw_count <= aw_count + 1'b1;
                if (next_aw_beats > beat_limit) integrity_fault <= 1;
                else aw_beats <= next_aw_beats[BEAT_BITS-1:0];
            end
            if (w_fire) begin
                if (w_beats == beat_limit) integrity_fault <= 1;
                else w_beats <= w_beats + 1'b1;
                if (next_bytes > 65'h0ffffffffffffffff || (limit_valid && next_bytes > byte_limit)) integrity_fault <= 1;
                else byte_count <= next_bytes[BYTE_BITS-1:0];
                if (wlast) begin
                    if (last_count == beat_limit) integrity_fault <= 1;
                    else last_count <= last_count + 1'b1;
                end
            end
            if (b_fire) begin
                if (response_count == beat_limit) integrity_fault <= 1;
                else response_count <= response_count + 1'b1;
                if (bresp != 2'b00 || !response_has_address || !response_has_last)
                    integrity_fault <= 1;
            end
        end
    end
endmodule