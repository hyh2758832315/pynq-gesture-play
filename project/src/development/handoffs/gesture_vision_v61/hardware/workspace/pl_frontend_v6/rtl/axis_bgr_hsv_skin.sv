// PYNQ-Z2 xc7z020clg400-1, Vivado 2026.1.
// BGR8 -> OpenCV-compatible HSV8 (H range 180) and inclusive skin threshold.
// Low byte B, next G, next R. Metadata travels with each accepted pixel.
// This is a pixel primitive: its caller must snapshot thresholds per frame.
// Global pipeline clock-enable preserves ALL outputs under backpressure.
module axis_bgr_hsv_skin(
    input wire aclk, aresetn,
    input wire [23:0] s_axis_tdata,
    input wire s_axis_tvalid, s_axis_tuser, s_axis_tlast,
    output wire s_axis_tready,
    input wire [7:0] cfg_h_lo,cfg_h_hi,cfg_s_lo,cfg_s_hi,cfg_v_lo,cfg_v_hi,
    output reg [23:0] m_axis_hsv,
    output reg [7:0] m_axis_mask,
    output wire m_axis_tvalid,
    output reg m_axis_tuser,m_axis_tlast,
    input wire m_axis_tready
);
    // Generated reciprocal ROMs use nearest-even rounding, shift=12.
    `include "hsv_reciprocal.svh"
    wire [7:0] b=s_axis_tdata[7:0],g=s_axis_tdata[15:8],r=s_axis_tdata[23:16];
    wire [7:0] max_rg=r>g ? r : g;
    wire [7:0] min_rg=r<g ? r : g;
    wire [7:0] vmax=max_rg>b ? max_rg : b;
    wire [7:0] vmin=min_rg<b ? min_rg : b;
    wire [7:0] diff=vmax-vmin;
    wire signed [11:0] bs=$signed({4'd0,b}),gs=$signed({4'd0,g}),rs=$signed({4'd0,r});
    wire signed [11:0] ds=$signed({4'd0,diff});
    // Tie priority R, then G, then B matches OpenCV's scalar/SIMD path.
    wire signed [11:0] hue_num=vmax==r ? gs-bs :
        vmax==g ? bs-rs+(ds<<<1) : rs-gs+(ds<<<2);
    reg [3:0] valid;
    reg [7:0] v0,d0,v1,v2,h2,s2;
    reg signed [11:0] hn0;
    reg [27:0] sp1;
    reg signed [29:0] hp1;
    reg [47:0] c0,c1,c2;
    reg [2:0] user_pipe,last_pipe;
    wire advance=!valid[3] || m_axis_tready;
    wire signed [29:0] hq=($signed(hp1)+30'sd2048)>>>12;
    wire signed [29:0] hw=hq<0 ? hq+30'sd180 : hq;
    wire [27:0] sq=(sp1+28'd2048)>>12;
    assign s_axis_tready=aresetn && advance;
    assign m_axis_tvalid=aresetn && valid[3];
    always @(posedge aclk) begin
        if(!aresetn) begin
            valid<=0;
            m_axis_hsv<=0;m_axis_mask<=0;m_axis_tuser<=0;m_axis_tlast<=0;
            user_pipe<=0;last_pipe<=0;
            v0<=0;d0<=0;hn0<=0;v1<=0;v2<=0;h2<=0;s2<=0;
            sp1<=0;hp1<=0;c0<=0;c1<=0;c2<=0;
        end else if(advance) begin
            valid<={valid[2:0],s_axis_tvalid};
            v0<=vmax;d0<=diff;hn0<=hue_num;
            c0<={cfg_v_hi,cfg_v_lo,cfg_s_hi,cfg_s_lo,cfg_h_hi,cfg_h_lo};
            sp1<=d0*sdiv(d0==0 ? 8'd0 : v0);
            hp1<=hn0*$signed({1'b0,hdiv(d0)});
            v1<=v0;c1<=c0;
            h2<=hw[7:0];s2<=sq[7:0];v2<=v1;c2<=c1;
            m_axis_hsv<={v2,s2,h2};
            m_axis_mask<=h2>=c2[7:0] && h2<=c2[15:8] &&
                s2>=c2[23:16] && s2<=c2[31:24] &&
                v2>=c2[39:32] && v2<=c2[47:40] ? 8'hff : 8'h00;
            user_pipe<={user_pipe[1:0],s_axis_tuser};
            last_pipe<={last_pipe[1:0],s_axis_tlast};
            m_axis_tuser<=user_pipe[2];m_axis_tlast<=last_pipe[2];
        end
    end
endmodule
