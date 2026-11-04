// 720p final-output overlay, independent of Scene/GPU progress.
// Input word order is the existing scanout's {R,B,G}; choose RGB_PACKED=1 for RGB.
// Exactly three registered pixel cycles, including DE/HS/VS. No TREADY or DDR.
module input_osd_pixels #(
    parameter integer WIDTH=1280, HEIGHT=720, RGB_PACKED=0
)(
    input wire pclk, resetn,
    input wire [23:0] in_rgb, input wire in_de, in_hs, in_vs,
    input wire [191:0] cfg, input wire hand_fresh,
    output reg [23:0] out_rgb, output reg out_de, out_hs, out_vs,
    output wire frame_boundary
);
    localparam [23:0] HAND_GREEN=RGB_PACKED ? 24'h00ff00 : 24'h0000ff;
    localparam [23:0] HAND_RED=24'hff0000;
    reg [10:0] x; reg [9:0] y;
    reg de_prev, vs_prev;
    assign frame_boundary=in_vs && !vs_prev; // input contract: positive 720p VS
    reg [23:0] rgb1,rgb2;
    reg de1,de2,hs1,hs2,vs1,vs2;
    reg [10:0] x1,dx1;reg [9:0] y1,dy1;
    reg fist1,hand1,enable1;
    reg [23:0] paint2;reg hit2;
    wire [10:0] cx=cfg[42:32];wire [9:0] cy=cfg[57:48];
    // Integer-circle row extents. Constant lookup; no multiplies/DSP/BRAM.
    function automatic integer extent(input integer ay, radius);
        begin
            extent=-1;
            case(radius)
                48:case(ay)
                    0:extent=48;
                    1:extent=47;
                    2:extent=47;
                    3:extent=47;
                    4:extent=47;
                    5:extent=47;
                    6:extent=47;
                    7:extent=47;
                    8:extent=47;
                    9:extent=47;
                    10:extent=46;
                    11:extent=46;
                    12:extent=46;
                    13:extent=46;
                    14:extent=45;
                    15:extent=45;
                    16:extent=45;
                    17:extent=44;
                    18:extent=44;
                    19:extent=44;
                    20:extent=43;
                    21:extent=43;
                    22:extent=42;
                    23:extent=42;
                    24:extent=41;
                    25:extent=40;
                    26:extent=40;
                    27:extent=39;
                    28:extent=38;
                    29:extent=38;
                    30:extent=37;
                    31:extent=36;
                    32:extent=35;
                    33:extent=34;
                    34:extent=33;
                    35:extent=32;
                    36:extent=31;
                    37:extent=30;
                    38:extent=29;
                    39:extent=27;
                    40:extent=26;
                    41:extent=24;
                    42:extent=23;
                    43:extent=21;
                    44:extent=19;
                    45:extent=16;
                    46:extent=13;
                    47:extent=9;
                    48:extent=0;
                endcase
                42:case(ay)
                    0:extent=42;
                    1:extent=41;
                    2:extent=41;
                    3:extent=41;
                    4:extent=41;
                    5:extent=41;
                    6:extent=41;
                    7:extent=41;
                    8:extent=41;
                    9:extent=41;
                    10:extent=40;
                    11:extent=40;
                    12:extent=40;
                    13:extent=39;
                    14:extent=39;
                    15:extent=39;
                    16:extent=38;
                    17:extent=38;
                    18:extent=37;
                    19:extent=37;
                    20:extent=36;
                    21:extent=36;
                    22:extent=35;
                    23:extent=35;
                    24:extent=34;
                    25:extent=33;
                    26:extent=32;
                    27:extent=32;
                    28:extent=31;
                    29:extent=30;
                    30:extent=29;
                    31:extent=28;
                    32:extent=27;
                    33:extent=25;
                    34:extent=24;
                    35:extent=23;
                    36:extent=21;
                    37:extent=19;
                    38:extent=17;
                    39:extent=15;
                    40:extent=12;
                    41:extent=9;
                    42:extent=0;
                endcase
                32:case(ay)
                    0:extent=32;
                    1:extent=31;
                    2:extent=31;
                    3:extent=31;
                    4:extent=31;
                    5:extent=31;
                    6:extent=31;
                    7:extent=31;
                    8:extent=30;
                    9:extent=30;
                    10:extent=30;
                    11:extent=30;
                    12:extent=29;
                    13:extent=29;
                    14:extent=28;
                    15:extent=28;
                    16:extent=27;
                    17:extent=27;
                    18:extent=26;
                    19:extent=25;
                    20:extent=24;
                    21:extent=24;
                    22:extent=23;
                    23:extent=22;
                    24:extent=21;
                    25:extent=19;
                    26:extent=18;
                    27:extent=17;
                    28:extent=15;
                    29:extent=13;
                    30:extent=11;
                    31:extent=7;
                    32:extent=0;
                endcase
                26:case(ay)
                    0:extent=26;
                    1:extent=25;
                    2:extent=25;
                    3:extent=25;
                    4:extent=25;
                    5:extent=25;
                    6:extent=25;
                    7:extent=25;
                    8:extent=24;
                    9:extent=24;
                    10:extent=24;
                    11:extent=23;
                    12:extent=23;
                    13:extent=22;
                    14:extent=21;
                    15:extent=21;
                    16:extent=20;
                    17:extent=19;
                    18:extent=18;
                    19:extent=17;
                    20:extent=16;
                    21:extent=15;
                    22:extent=13;
                    23:extent=12;
                    24:extent=10;
                    25:extent=7;
                    26:extent=0;
                endcase
            endcase
        end
    endfunction
    integer outer_extent,inner_extent;
    always @(posedge pclk) begin
        if(!resetn) begin
            x<=0;y<=0;de_prev<=0;vs_prev<=0;
            rgb1<=0;rgb2<=0;de1<=0;de2<=0;hs1<=0;hs2<=0;vs1<=0;vs2<=0;
            x1<=0;y1<=0;dx1<=0;dy1<=0;fist1<=0;hand1<=0;enable1<=0;
            hit2<=0;paint2<=0;
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
            enable1<=cfg[0];
            // Stage 2: fixed-size hand marker; opaque mask only.
            rgb2<=rgb1;de2<=de1;hs2<=hs1;vs2<=vs1;hit2<=0;paint2<=0;
            outer_extent=extent(dy1,fist1 ? 32 : 48);
            inner_extent=extent(dy1,fist1 ? 26 : 42);
            if(enable1 && de1) begin
                if(hand1 && ((dx1<=4 && dy1<=4) ||
                    (outer_extent>=0 && $signed({1'b0,dx1})<=outer_extent &&
                     $signed({1'b0,dx1})>inner_extent))) begin
                    hit2<=1;paint2<=fist1 ? HAND_RED : HAND_GREEN;
                end
            end
            // Stage 3: one mux, sync delayed by exactly the same amount.
            out_rgb<=de2 ? (hit2 ? paint2 : rgb2) : rgb2;
            out_de<=de2;out_hs<=hs2;out_vs<=vs2;
        end
    end
endmodule
