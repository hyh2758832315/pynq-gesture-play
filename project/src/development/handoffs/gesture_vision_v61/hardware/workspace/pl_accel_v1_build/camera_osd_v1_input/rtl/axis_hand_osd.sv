// One-pixel/cycle registered RGB888 overlay; no frame buffer or divider.
// PS publishes one atomic metadata snapshot before accepted SOF.
// bbox uses HALF-OPEN boundaries. Coordinates refer to input display raster.
// state: 0 pending/unknown, 1 ROCK, 2 PAPER, 3 SCISSORS.
module axis_hand_osd #(
    parameter integer WIDTH=1280, HEIGHT=720,
    parameter integer BOX_THICKNESS=2, CROSS_RADIUS=8,
    parameter integer BGR_PACKED=0
)(
    input wire aclk, input wire aresetn,
    input wire [23:0] s_axis_tdata,
    input wire s_axis_tvalid, output wire s_axis_tready,
    input wire s_axis_tuser, input wire s_axis_tlast,
    output reg [23:0] m_axis_tdata,
    output reg m_axis_tvalid, input wire m_axis_tready,
    output reg m_axis_tuser, output reg m_axis_tlast,
    input wire cfg_enable, input wire cfg_bbox_valid,
    input wire [1:0] cfg_state,
    input wire [15:0] cfg_x0, cfg_y0, cfg_x1, cfg_y1,
    input wire cfg_centroid_valid,
    input wire [15:0] cfg_cx, cfg_cy,
    input wire [31:0] cfg_result_frame_id,
    output reg [31:0] displayed_result_frame_id
);
    reg [15:0] x,y;
    reg en,bv,cv;
    reg [1:0] state;
    reg [15:0] x0,y0,x1,y1,cx,cy;
    wire [15:0] px=s_axis_tuser ? 16'd0 : x;
    wire [15:0] py=s_axis_tuser ? 16'd0 : y;
    wire ae=s_axis_tuser ? cfg_enable : en;
    wire ab=s_axis_tuser ? cfg_bbox_valid : bv;
    wire ac=s_axis_tuser ? cfg_centroid_valid : cv;
    wire [1:0] ast=s_axis_tuser ? cfg_state : state;
    wire [15:0] ax0=s_axis_tuser ? cfg_x0 : x0;
    wire [15:0] ay0=s_axis_tuser ? cfg_y0 : y0;
    wire [15:0] ax1=s_axis_tuser ? cfg_x1 : x1;
    wire [15:0] ay1=s_axis_tuser ? cfg_y1 : y1;
    wire [15:0] axc=s_axis_tuser ? cfg_cx : cx;
    wire [15:0] ayc=s_axis_tuser ? cfg_cy : cy;
    wire inside_box=ab && ax0<ax1 && ay0<ay1 && ax1<=WIDTH && ay1<=HEIGHT
                    && px>=ax0 && px<ax1 && py>=ay0 && py<ay1;
    // Subtractions only on inside_box; 16-bit coordinates with int extension.
    wire border=inside_box && ((px-ax0)<BOX_THICKNESS || (ax1-1-px)<BOX_THICKNESS
                         || (py-ay0)<BOX_THICKNESS || (ay1-1-py)<BOX_THICKNESS);
    wire [15:0] dx=px>=axc ? px-axc : axc-px;
    wire [15:0] dy=py>=ayc ? py-ayc : ayc-py;
    wire cross_hit=ab && ac && axc<WIDTH && ayc<HEIGHT
                   && ((dx==0 && dy<=CROSS_RADIUS) || (dy==0 && dx<=CROSS_RADIUS));
    wire [23:0] box_rgb=ast==1 ? 24'hff0000 : ast==0 ? 24'hffb400 : 24'h00ff00;
    wire [23:0] box_packed=BGR_PACKED ? {box_rgb[7:0],box_rgb[15:8],box_rgb[23:16]} : box_rgb;
    assign s_axis_tready=~m_axis_tvalid || m_axis_tready;
    always @(posedge aclk) begin
        if(!aresetn) begin
            x<=0; y<=0; en<=0; bv<=0; cv<=0; state<=0;
            x0<=0; y0<=0; x1<=0; y1<=0; cx<=0; cy<=0;
            m_axis_tvalid<=0; m_axis_tdata<=0; m_axis_tuser<=0; m_axis_tlast<=0;
            displayed_result_frame_id<=0;
        end else if(s_axis_tready) begin
            m_axis_tvalid<=s_axis_tvalid;
            if(s_axis_tvalid) begin
                m_axis_tdata<=ae && cross_hit ? 24'hffffff : ae && border ? box_packed : s_axis_tdata;
                m_axis_tuser<=s_axis_tuser; m_axis_tlast<=s_axis_tlast;
                if(s_axis_tuser) begin
                    en<=cfg_enable; bv<=cfg_bbox_valid; cv<=cfg_centroid_valid;
                    state<=cfg_state; x0<=cfg_x0; y0<=cfg_y0; x1<=cfg_x1; y1<=cfg_y1;
                    cx<=cfg_cx; cy<=cfg_cy;
                    displayed_result_frame_id<=cfg_result_frame_id;
                end
                if(s_axis_tlast) begin
                    x<=0; y<=py==HEIGHT-1 ? 16'd0 : py+16'd1;
                end else begin
                    x<=px+16'd1; y<=py;
                end
            end
        end
    end
endmodule
