// 720p final-output overlay, independent of Scene/GPU progress.
// Input word order is the existing scanout's {R,B,G}; choose RGB_PACKED=1 for RGB.
// Exactly three registered pixel cycles, including DE/HS/VS. No TREADY or DDR.
module input_osd_pixels #(
    parameter integer WIDTH=1280, HEIGHT=720, RGB_PACKED=0,
    parameter integer BAR_HEIGHT=240
)(
    input wire pclk, resetn,
    input wire [23:0] in_rgb, input wire in_de, in_hs, in_vs,
    input wire [191:0] cfg, input wire hand_fresh, audio_fresh,
    output reg [23:0] out_rgb, output reg out_de, out_hs, out_vs,
    output wire frame_boundary
);
    localparam integer BAR_BOTTOM=(HEIGHT+BAR_HEIGHT)/2;
    localparam integer BAR_TOP=BAR_BOTTOM-BAR_HEIGHT;
    localparam [23:0] GREEN=RGB_PACKED ? 24'h40e070 : 24'h4070e0;
    localparam [23:0] RED=RGB_PACKED ? 24'hff4848 : 24'hff4848;
    localparam [23:0] AMBER=RGB_PACKED ? 24'hffcc40 : 24'hff40cc;
    reg [10:0] x; reg [9:0] y;
    reg de_prev, vs_prev;
    assign frame_boundary=in_vs && !vs_prev; // input contract: positive 720p VS
    reg [23:0] rgb1,rgb2;
    reg de1,de2,hs1,hs2,vs1,vs2;
    reg [10:0] x1,dx1;reg [9:0] y1,dy1;
    reg fist1,hand1,audio1,enable1;
    reg [9:0] level1,soft1,loud1;
    reg [23:0] paint2;reg hit2;
    wire [10:0] cx=cfg[42:32];wire [9:0] cy=cfg[57:48];
    wire [9:0] level=cfg[73:64],soft_height=cfg[89:80],loud=cfg[105:96];
    // Integer-circle row extents. Constant lookup; no multiplies/DSP/BRAM.
    function automatic integer extent(input integer ay, radius);
        begin
            extent=-1;
            case(radius)
                12:case(ay)
                    0:extent=12;1,2,3,4:extent=11;5,6:extent=10;
                    7:extent=9;8:extent=8;9:extent=7;10:extent=6;11:extent=4;12:extent=0;
                endcase
                10:case(ay)
                    0:extent=10;1,2,3,4:extent=9;5,6:extent=8;7:extent=7;
                    8:extent=6;9:extent=4;10:extent=0;
                endcase
                8:case(ay)
                    0:extent=8;1,2,3:extent=7;4,5:extent=6;6:extent=5;7:extent=3;8:extent=0;
                endcase
                6:case(ay)
                    0:extent=6;1,2,3:extent=5;4:extent=4;5:extent=3;6:extent=0;
                endcase
            endcase
        end
    endfunction
    integer outer_extent,inner_extent;
    always @(posedge pclk) begin
        if(!resetn) begin
            x<=0;y<=0;de_prev<=0;vs_prev<=0;
            rgb1<=0;rgb2<=0;de1<=0;de2<=0;hs1<=0;hs2<=0;vs1<=0;vs2<=0;
            x1<=0;y1<=0;dx1<=0;dy1<=0;fist1<=0;hand1<=0;audio1<=0;enable1<=0;
            level1<=0;soft1<=0;loud1<=0;hit2<=0;paint2<=0;
            out_rgb<=0;out_de<=0;out_hs<=0;out_vs<=0;
        end else begin
            de_prev<=in_de;vs_prev<=in_vs;
            if(frame_boundary) begin x<=0;y<=0;end
            else if(in_de) begin
                if(x<WIDTH) x<=x+1'b1;
            end else begin
                x<=0;
                if(de_prev && y<HEIGHT) y<=y+1'b1;
            end
            // Stage 1: coordinate distance and sampled observation state.
            rgb1<=in_rgb;de1<=in_de;hs1<=in_hs;vs1<=in_vs;x1<=x;y1<=y;
            dx1<=x>=cx ? x-cx : cx-x;dy1<=y>=cy ? y-cy : cy-y;
            fist1<=cfg[2];hand1<=hand_fresh && cx<WIDTH && cy<HEIGHT;
            audio1<=audio_fresh;enable1<=cfg[0];
            level1<=level;soft1<=soft_height;loud1<=loud;
            // Stage 2: fixed-size circle and tiny vertical meter; opaque mask only.
            rgb2<=rgb1;de2<=de1;hs2<=hs1;vs2<=vs1;hit2<=0;paint2<=0;
            outer_extent=extent(dy1,fist1 ? 8 : 12);
            inner_extent=extent(dy1,fist1 ? 6 : 10);
            if(enable1 && de1) begin
                if(hand1 && ((dx1<=1 && dy1<=1) ||
                    (outer_extent>=0 && $signed({1'b0,dx1})<=outer_extent &&
                     $signed({1'b0,dx1})>inner_extent))) begin
                    hit2<=1;paint2<=fist1 ? RED : GREEN;
                end
                // Meter is topmost, leaving the centre of the picture unobscured.
                if(x1>=WIDTH-14 && x1<WIDTH-6 && y1>=BAR_TOP && y1<BAR_BOTTOM) begin
                    hit2<=1;paint2<=24'h202830;
                    if(audio1 && BAR_BOTTOM-y1<=level1)
                        paint2<=level1>=loud1 ? RED : (level1>=soft1 ? AMBER : GREEN);
                    if(x1==WIDTH-14 || x1==WIDTH-7 || y1==BAR_TOP || y1==BAR_BOTTOM-1)
                        paint2<=24'h707070;
                end
                if(x1>=WIDTH-18 && x1<WIDTH-3 &&
                   y1>=BAR_TOP && y1<BAR_BOTTOM &&
                   (BAR_BOTTOM-y1==soft1 || BAR_BOTTOM-y1==loud1)) begin
                    hit2<=1;paint2<=audio1 ? 24'he0e0e0 : 24'h505050;
                end
            end
            // Stage 3: one mux, sync delayed by exactly the same amount.
            out_rgb<=de2 ? (hit2 ? paint2 : rgb2) : rgb2;
            out_de<=de2;out_hs<=hs2;out_vs<=vs2;
        end
    end
endmodule
