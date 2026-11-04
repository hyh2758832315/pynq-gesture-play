module vision_source_admission (
    input wire vid_io_in_clk, common_aresetn,
    input wire request_open, request_close,
    input wire [2:0] released_sequence,
    input wire vid_active_video, vid_vsync,
    output wire axis_enable, source_quiescent,
    output reg boundary_fault,
    output reg [31:0] admitted_frames,
    output reg [63:0] admitted_pixels
);
    localparam [1:0] WAIT_START = 2'd0, RUNNING = 2'd1, CLOSING = 2'd2, CLOSED = 2'd3;
    wire video_resetn;
    reg [1:0] state;
    reg vsync_held;
    reg frame_present;
    reg pixel_event_pending, frame_event_pending;
    reg frame_selected;
    reg [2:0] reserved_sequence;
    wire [2:0] reserved_unreleased = reserved_sequence - released_sequence;
    wire slot_available = reserved_unreleased < 3;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) reg [2:0] open_sync, close_sync;
    wire frame_boundary = vid_vsync && !vsync_held;
    wire pixel_admitted = axis_enable && vid_active_video;
    wire frame_admitted = axis_enable && frame_boundary && !vid_active_video && frame_present;

    xpm_cdc_async_rst #(
        .DEST_SYNC_FF(3), .INIT_SYNC_FF(0), .RST_ACTIVE_HIGH(0)
    ) source_reset (
        .src_arst(common_aresetn), .dest_clk(vid_io_in_clk), .dest_arst(video_resetn)
    );

    // Reserve before pixels enter video_in, including frames still upstream of owner.
    // The decision is held for the complete physical frame. No slot means no writes.
    assign axis_enable = video_resetn && frame_selected && (state == RUNNING || state == CLOSING);
    assign source_quiescent = video_resetn && state == CLOSED &&
        !pixel_event_pending && !frame_event_pending;

    always @(posedge vid_io_in_clk or negedge video_resetn) begin
        if (!video_resetn) begin
            state <= WAIT_START;
            vsync_held <= 0;
            open_sync <= 0;
            close_sync <= 0;
            boundary_fault <= 0;
            admitted_frames <= 0;
            admitted_pixels <= 0;
            frame_present <= 0;
            pixel_event_pending <= 0;
            frame_event_pending <= 0;
            frame_selected <= 0;
            reserved_sequence <= 0;
        end else begin
            open_sync <= {open_sync[1:0], request_open};
            close_sync <= {close_sync[1:0], request_close};
            vsync_held <= vid_vsync;
            pixel_event_pending <= pixel_admitted;
            frame_event_pending <= frame_admitted;
            if (reserved_unreleased > 3) boundary_fault <= 1;
            if (frame_boundary && !vid_active_video) begin
                if (!close_sync[2] && !boundary_fault && slot_available &&
                    ((state == WAIT_START && open_sync[2]) || state == RUNNING)) begin
                    reserved_sequence <= reserved_sequence + 1'b1;
                    frame_selected <= 1;
                end else frame_selected <= 0;
            end
            if (frame_boundary && vid_active_video) boundary_fault <= 1;
            if (pixel_admitted) frame_present <= 1;
            if (pixel_event_pending) begin
                if (admitted_pixels == 64'hffffffffffffffff) boundary_fault <= 1;
                else admitted_pixels <= admitted_pixels + 1'b1;
            end
            if (frame_admitted) frame_present <= 0;
            if (frame_event_pending) begin
                if (admitted_frames == 32'hffffffff) boundary_fault <= 1;
                else admitted_frames <= admitted_frames + 1'b1;
            end
            case (state)
                WAIT_START: begin
                    if (close_sync[2]) state <= CLOSED;
                    else if (open_sync[2] && frame_boundary && !vid_active_video) state <= RUNNING;
                end
                RUNNING: begin
                    if (close_sync[2]) begin
                        if (frame_boundary && !vid_active_video) state <= CLOSED;
                        else state <= CLOSING;
                    end
                end
                CLOSING: if (frame_boundary && !vid_active_video) state <= CLOSED;
                CLOSED: state <= CLOSED;
                default: begin
                    state <= CLOSED;
                    boundary_fault <= 1;
                end
            endcase
        end
    end
endmodule
