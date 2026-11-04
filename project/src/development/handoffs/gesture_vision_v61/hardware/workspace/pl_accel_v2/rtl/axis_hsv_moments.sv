// PYNQ-Z2 / xc7z020clg400-1. One synchronous clock domain.
// Input 32b: H[7:0], S[15:8], V[23:16], selected-contour gate bit24.
// Input is HSV8, NOT RGB: PS color conversion/target selection remain upstream.
// Inclusive threshold AND per-pixel gate; default gate must not be 'all skin'
// when multiple blobs exist. Result is segmented-area moments, NOT palm center.
// SOF=tuser, TLAST=end of line. Config sampled ONLY on accepted SOF.
// Result {frame_id[31:0],sum_y[63:0],sum_x[63:0],area[31:0]}.
// stat_error means malformed line length/config/resync: consumer must reject it.
module axis_hsv_moments #(
    parameter integer MAX_WIDTH=1280, MAX_HEIGHT=720
)(
    input wire aclk, aresetn,
    input wire [15:0] cfg_width, cfg_height,
    input wire [7:0] cfg_h_lo,cfg_h_hi,cfg_s_lo,cfg_s_hi,cfg_v_lo,cfg_v_hi,
    input wire [31:0] cfg_frame_id,
    input wire [31:0] s_axis_tdata,
    input wire s_axis_tvalid,s_axis_tuser,s_axis_tlast,
    output wire s_axis_tready,
    output reg [7:0] m_axis_tdata,
    output reg m_axis_tvalid,m_axis_tuser,m_axis_tlast,
    input wire m_axis_tready,
    output reg [191:0] stat_data,
    output reg stat_valid,stat_error,
    input wire stat_ready
);
    reg active, bad,publish_pending;
    reg [15:0] x,y,last_x,last_y;
    reg [7:0] h_lo,h_hi,s_lo,s_hi,v_lo,v_hi;
    reg [31:0] frame_id,area;
    // 1280x720 maximum: sum_x <=589363200 and sum_y <=331315200.
    // 32-bit accumulators are exact; widen only the published 64-bit ABI.
    reg [31:0] sum_x,sum_y;
    wire sof=s_axis_tuser;
    wire config_bad=cfg_width==0 || cfg_width>MAX_WIDTH ||
        cfg_height==0 || cfg_height>MAX_HEIGHT || cfg_h_lo>cfg_h_hi ||
        cfg_s_lo>cfg_s_hi || cfg_v_lo>cfg_v_hi || cfg_h_hi>179;
    wire [15:0] w=config_bad ? 16'd1 : cfg_width;
    wire [15:0] h=config_bad ? 16'd1 : cfg_height;
    wire [15:0] px=sof ? 16'd0 : x;
    wire [15:0] py=sof ? 16'd0 : y;
    wire keep=s_axis_tdata[24] &&
        s_axis_tdata[7:0]>=(sof ? cfg_h_lo : h_lo) &&
        s_axis_tdata[7:0]<=(sof ? cfg_h_hi : h_hi) &&
        s_axis_tdata[15:8]>=(sof ? cfg_s_lo : s_lo) &&
        s_axis_tdata[15:8]<=(sof ? cfg_s_hi : s_hi) &&
        s_axis_tdata[23:16]>=(sof ? cfg_v_lo : v_lo) &&
        s_axis_tdata[23:16]<=(sof ? cfg_v_hi : v_hi);
    wire [31:0] next_area=(sof ? 32'd0 : area)+(keep ? 32'd1 : 32'd0);
    wire [31:0] next_sx=(sof ? 32'd0 : sum_x)+(keep ? {16'd0,px} : 32'd0);
    wire [31:0] next_sy=(sof ? 32'd0 : sum_y)+(keep ? {16'd0,py} : 32'd0);
    // Precompute terminal coordinates on SOF: removes config validation +
    // dimension subtract + terminal compare from every pixel's result CE path.
    wire line_end=sof ? (config_bad || cfg_width==1) : x==last_x;
    wire final_pixel=sof ? (config_bad || (cfg_width==1 && cfg_height==1)) :
        (line_end && y==last_y);
    wire this_bad=(sof ? (config_bad || active) : bad) ||
        (s_axis_tlast!=line_end);
    assign s_axis_tready=aresetn && !publish_pending && (!m_axis_tvalid || m_axis_tready) &&
        (!stat_valid || stat_ready);
    always @(posedge aclk) begin
        if (!aresetn) begin
            active<=0;bad<=0;publish_pending<=0;x<=0;y<=0;last_x<=0;last_y<=0;
            h_lo<=0;h_hi<=0;s_lo<=0;s_hi<=0;v_lo<=0;v_hi<=0;
            frame_id<=0;area<=0;sum_x<=0;sum_y<=0;
            m_axis_tvalid<=0;m_axis_tdata<=0;m_axis_tuser<=0;m_axis_tlast<=0;
            stat_valid<=0;stat_data<=0;stat_error<=0;
        end else begin
            if(stat_ready) stat_valid<=0;
            if(m_axis_tready) m_axis_tvalid<=0;
            // Publish a registered accumulator snapshot on the following cycle,
            // separating terminal control from the output data/enable fanout.
            if(publish_pending) begin
                stat_data<={frame_id,32'd0,sum_y,32'd0,sum_x,area};
                stat_error<=bad;stat_valid<=1;publish_pending<=0;
            end
            if(s_axis_tvalid && s_axis_tready && (active || sof)) begin
                if(sof) begin
                    last_x<=w-16'd1;last_y<=h-16'd1;frame_id<=cfg_frame_id;
                    h_lo<=cfg_h_lo;h_hi<=cfg_h_hi;s_lo<=cfg_s_lo;
                    s_hi<=cfg_s_hi;v_lo<=cfg_v_lo;v_hi<=cfg_v_hi;
                end
                m_axis_tvalid<=1;m_axis_tdata<=keep ? 8'hff : 8'h00;
                m_axis_tuser<=sof;m_axis_tlast<=s_axis_tlast;
                area<=next_area;sum_x<=next_sx;sum_y<=next_sy;bad<=this_bad;
                active<=!final_pixel;
                if(line_end) begin x<=0;y<=py+1'b1;end
                else begin x<=px+1'b1;y<=py;end
                if(final_pixel) begin
                    publish_pending<=1;
                end
            end
        end
    end
endmodule
