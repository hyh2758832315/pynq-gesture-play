// Independent AXI-Lite observation mailbox. No gameplay event/ACK interface.
// AXI response state survives pixel reset; publication state does not.
module input_osd_ctrl #(
    parameter integer HAND_MAX_FRAMES=15, AUDIO_MAX_FRAMES=6
)(
    input wire aclk, resetn, pixel_resetn,
    input wire [6:0] awaddr, input wire awvalid, output wire awready,
    input wire [31:0] wdata, input wire [3:0] wstrb,
    input wire wvalid, output wire wready,
    output reg [1:0] bresp, output reg bvalid, input wire bready,
    input wire [6:0] araddr, input wire arvalid, output wire arready,
    output reg [31:0] rdata, output reg [1:0] rresp,
    output reg rvalid, input wire rready,
    input wire pclk, presetn, frame_boundary,
    output reg [191:0] active_cfg,
    output wire hand_fresh, audio_fresh
);
    reg [31:0] shadow[0:5];
    reg [191:0] mailbox, pending_cfg;
    reg req_toggle, ack_toggle;
    (* ASYNC_REG="TRUE" *) reg req_meta, req_sync;
    (* ASYNC_REG="TRUE" *) reg ack_meta, ack_sync;
    reg pending, aw_held, w_held;
    reg [6:0] aw_addr;
    reg [31:0] w_data;
    reg [3:0] w_strb;
    reg [7:0] hand_left, audio_left;
    wire busy=req_toggle!=ack_sync;
    wire take_write=aw_held && w_held && !bvalid;
    wire shadow_write=take_write && aw_addr[1:0]==0 &&
                      aw_addr>=7'h10 && aw_addr<=7'h24;
    wire commit_write=take_write && aw_addr==7'h08 &&
                      w_strb[0] && w_data[0];
    assign awready=!aw_held && !bvalid;
    assign wready=!w_held && !bvalid;
    assign arready=!rvalid;
    assign hand_fresh=active_cfg[0] && active_cfg[1] && hand_left!=0;
    assign audio_fresh=active_cfg[0] && active_cfg[3] && audio_left!=0;
    integer i, b;
    // Use a single reset condition for the publication registers.  This
    // keeps their reset as cheap as the original common-reset implementation.
    always @(posedge aclk) begin
        if(!resetn || !pixel_resetn) begin
            for(i=0;i<6;i=i+1) shadow[i]<=0;
            mailbox<=0;req_toggle<=0;ack_meta<=0;ack_sync<=0;
        end else begin
            ack_meta<=ack_toggle;ack_sync<=ack_meta;
            if(shadow_write)
                for(b=0;b<4;b=b+1)
                    if(w_strb[b]) shadow[(aw_addr-7'h10)>>2][b*8+:8]<=w_data[b*8+:8];
            if(commit_write && !busy) begin
                mailbox<={shadow[5],shadow[4],shadow[3],shadow[2],shadow[1],shadow[0]};
                req_toggle<=!req_toggle;
            end
        end
    end
    always @(posedge aclk) begin
        if(!resetn) begin
            aw_held<=0;w_held<=0;aw_addr<=0;w_data<=0;w_strb<=0;
            bvalid<=0;bresp<=0;rvalid<=0;rresp<=0;rdata<=0;
        end else begin
            if(bvalid && bready) bvalid<=0;
            if(rvalid && rready) rvalid<=0;
            if(awvalid && awready) begin aw_addr<=awaddr;aw_held<=1;end
            if(wvalid && wready) begin w_data<=wdata;w_strb<=wstrb;w_held<=1;end
            if(take_write) begin
                aw_held<=0;w_held<=0;bvalid<=1;bresp<=0;
                if(aw_addr[1:0]!=0) bresp<=2;
                else if(aw_addr>=7'h10 && aw_addr<=7'h24) begin
                    // Accepted writes are discarded while video is reset.
                end else if(aw_addr==7'h08) begin
                    if(w_strb[0] && w_data[0]) begin
                        if(!pixel_resetn) begin
                            // Acknowledge but discard while the pixel domain
                            // cannot consume the mailbox.
                        end else if(busy) bresp<=2;
                    end
                end else bresp<=2;
            end
            if(arvalid && arready) begin
                rvalid<=1;rresp<=0;rdata<=0;
                if(araddr[1:0]!=0) rresp<=2;
                else case(araddr)
                    7'h00:rdata<=32'h4f534401; // OSD v1, NOT a platform BUILD_ID
                    7'h04:rdata<={31'd0,busy};
                    7'h08:rdata<=0;
                    7'h10,7'h14,7'h18,7'h1c,7'h20,7'h24:rdata<=shadow[(araddr-7'h10)>>2];
                    default:rresp<=2;
                endcase
            end
        end
    end
    // Bundled payload remains frozen until the boundary ACK returns via 2FF.
    // One extra capture edge before use; constrained by osd_cdc.xdc.
    always @(posedge pclk) begin
        if(!presetn) begin
            req_meta<=0;req_sync<=0;ack_toggle<=0;pending<=0;
            pending_cfg<=0;active_cfg<=0;hand_left<=0;audio_left<=0;
        end else begin
            req_meta<=req_toggle;req_sync<=req_meta;
            if(!pending && req_sync!=ack_toggle) begin pending_cfg<=mailbox;pending<=1;end
            if(frame_boundary) begin
                if(hand_left!=0) hand_left<=hand_left-1'b1;
                if(audio_left!=0) audio_left<=audio_left-1'b1;
                if(pending) begin
                    active_cfg<=pending_cfg;ack_toggle<=req_sync;pending<=0;
                    // Repeated observation identities never renew their lifetimes.
                    if(pending_cfg[159:128]!=active_cfg[159:128])
                        hand_left<=pending_cfg[119:112]>HAND_MAX_FRAMES ? HAND_MAX_FRAMES : pending_cfg[119:112];
                    if(pending_cfg[191:160]!=active_cfg[191:160])
                        audio_left<=pending_cfg[127:120]>AUDIO_MAX_FRAMES ? AUDIO_MAX_FRAMES : pending_cfg[127:120];
                end
            end
        end
    end
endmodule
