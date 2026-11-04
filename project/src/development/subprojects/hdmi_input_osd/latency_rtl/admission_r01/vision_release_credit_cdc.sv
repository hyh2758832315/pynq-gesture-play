// Three-slot protocol: at most three releases may be unobserved. Modulo eight
// preserves that distance across wrap. Only accepted owner releases are counted.
// Common reset must cover both domains; partial/run-time independent reset is illegal.
// Physical signoff must constrain source_gray -> gray_meta delay and bus skew.
module vision_release_credit_cdc (
    input wire aclk, vid_io_in_clk, common_aresetn,
    input wire [31:0] released_frames,
    output reg [2:0] released_sequence
);
    wire video_resetn;
    reg [2:0] source_gray;
    (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) reg [2:0] gray_meta, gray_sync, gray_settled;

    xpm_cdc_async_rst #(.DEST_SYNC_FF(3), .INIT_SYNC_FF(0), .RST_ACTIVE_HIGH(0)) video_reset (
        .src_arst(common_aresetn), .dest_clk(vid_io_in_clk), .dest_arst(video_resetn)
    );
    always @(posedge aclk) begin
        if (!common_aresetn) source_gray <= 0;
        else source_gray <= released_frames[2:0] ^ (released_frames[2:0] >> 1);
    end
    always @(posedge vid_io_in_clk or negedge video_resetn) begin
        if (!video_resetn) begin
            gray_meta <= 0;
            gray_sync <= 0;
            gray_settled <= 0;
            released_sequence <= 0;
        end else begin
            gray_meta <= source_gray;
            gray_sync <= gray_meta;
            gray_settled <= gray_sync;
            released_sequence <= {gray_settled[2],
                                  gray_settled[2] ^ gray_settled[1],
                                  ^gray_settled};
        end
    end
endmodule
