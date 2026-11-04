// AXI-Lite shadow registers + bundled-data toggle mailbox to video clock.
// Both resets MUST be asserted together; release synchronously per domain.
// No independent-domain reset during a transaction. One software writer only.
// Commit is acknowledged only on an accepted video SOF, not on receipt.
module axi_hand_osd_ctrl #(
    parameter integer STALE_CYCLES=74250000
)(
    input wire s_axi_aclk, s_axi_aresetn,
    input wire [5:0] s_axi_awaddr, input wire s_axi_awvalid,
    output wire s_axi_awready,
    input wire [31:0] s_axi_wdata, input wire [3:0] s_axi_wstrb,
    input wire s_axi_wvalid, output wire s_axi_wready,
    output reg [1:0] s_axi_bresp, output reg s_axi_bvalid,
    input wire s_axi_bready,
    input wire [5:0] s_axi_araddr, input wire s_axi_arvalid,
    output wire s_axi_arready,
    output reg [31:0] s_axi_rdata, output reg [1:0] s_axi_rresp,
    output reg s_axi_rvalid, input wire s_axi_rready,
    input wire video_aclk, video_aresetn, video_sof_accept,
    output wire cfg_enable, cfg_bbox_valid, cfg_centroid_valid,
    output wire [1:0] cfg_state,
    output wire [15:0] cfg_x0,cfg_y0,cfg_x1,cfg_y1,cfg_cx,cfg_cy,
    output wire [31:0] cfg_result_frame_id
);
    reg [31:0] shadow [0:4];
    reg [159:0] mailbox, video_cfg;
    reg req_toggle, ack_toggle;
    (* ASYNC_REG="TRUE" *) reg req_meta,req_sync;
    (* ASYNC_REG="TRUE" *) reg ack_meta,ack_sync;
    reg pending;
    reg [31:0] age_cycles;
    reg aw_held,w_held;
    reg [5:0] aw_addr;
    reg [31:0] w_data;
    reg [3:0] w_strb;
    wire busy=req_toggle!=ack_sync;
    assign s_axi_awready=!aw_held && !s_axi_bvalid;
    assign s_axi_wready=!w_held && !s_axi_bvalid;
    assign s_axi_arready=!s_axi_rvalid;
    integer i,b;
    always @(posedge s_axi_aclk) begin
        if(!s_axi_aresetn) begin
            for(i=0;i<5;i=i+1) shadow[i]<=0;
            mailbox<=0; req_toggle<=0; ack_meta<=0;ack_sync<=0;
            aw_held<=0;w_held<=0;aw_addr<=0;w_data<=0;w_strb<=0;
            s_axi_bvalid<=0;s_axi_bresp<=0;
            s_axi_rvalid<=0;s_axi_rresp<=0;s_axi_rdata<=0;
        end else begin
            ack_meta<=ack_toggle;ack_sync<=ack_meta;
            if(s_axi_bvalid && s_axi_bready) s_axi_bvalid<=0;
            if(s_axi_rvalid && s_axi_rready) s_axi_rvalid<=0;
            if(s_axi_awvalid && s_axi_awready) begin aw_addr<=s_axi_awaddr;aw_held<=1;end
            if(s_axi_wvalid && s_axi_wready) begin w_data<=s_axi_wdata;w_strb<=s_axi_wstrb;w_held<=1;end
            if(aw_held && w_held && !s_axi_bvalid) begin
                aw_held<=0;w_held<=0;s_axi_bvalid<=1;s_axi_bresp<=0;
                if(aw_addr[1:0]!=0) s_axi_bresp<=2;
                else if(aw_addr>=6'h10 && aw_addr<=6'h20) begin
                    for(b=0;b<4;b=b+1)
                        if(w_strb[b]) shadow[(aw_addr-6'h10)>>2][8*b+:8]<=w_data[8*b+:8];
                end else if(aw_addr==6'h08) begin
                    if(w_strb[0] && w_data[0]) begin
                        if(busy) s_axi_bresp<=2;
                        else begin
                            mailbox<={shadow[4],shadow[3],shadow[2],shadow[1],shadow[0]};
                            req_toggle<=!req_toggle;
                        end
                    end
                end else s_axi_bresp<=2;
            end
            if(s_axi_arvalid && s_axi_arready) begin
                s_axi_rvalid<=1;s_axi_rresp<=0;s_axi_rdata<=0;
                if(s_axi_araddr[1:0]!=0) s_axi_rresp<=2;
                else case(s_axi_araddr)
                    6'h00:s_axi_rdata<=32'h484f5301; // HOS v1
                    6'h04:s_axi_rdata<={31'd0,busy};
                    6'h08:s_axi_rdata<=0;
                    6'h10,6'h14,6'h18,6'h1c,6'h20:
                        s_axi_rdata<=shadow[(s_axi_araddr-6'h10)>>2];
                    default:s_axi_rresp<=2;
                endcase
            end
        end
    end
    // The bus remains frozen from commit until ack has returned through 2FF.
    // Capture occurs after the request has crossed 2FF (three destination edges).
    // Constrain mailbox -> video_cfg with set_max_delay -datapath_only.
    always @(posedge video_aclk) begin
        if(!video_aresetn) begin
            req_meta<=0;req_sync<=0;ack_toggle<=0;pending<=0;
            video_cfg<=0;age_cycles<=STALE_CYCLES;
        end else begin
            req_meta<=req_toggle;req_sync<=req_meta;
            if(age_cycles<STALE_CYCLES) age_cycles<=age_cycles+1;
            if(!pending && req_sync!=ack_toggle) begin
                video_cfg<=mailbox;pending<=1;age_cycles<=0;
            end
            if(pending && video_sof_accept) begin
                ack_toggle<=req_sync;pending<=0;
            end
        end
    end
    // axis_hand_osd samples these only at accepted SOF; mid-frame changes do
    // not affect active pixels. Timeout clears on next SOF, not mid-frame.
    assign cfg_enable=video_cfg[0] && age_cycles<STALE_CYCLES;
    assign cfg_bbox_valid=video_cfg[1];
    assign cfg_centroid_valid=video_cfg[2];
    assign cfg_state=video_cfg[4:3];
    assign cfg_x0=video_cfg[47:32]; assign cfg_y0=video_cfg[63:48];
    assign cfg_x1=video_cfg[79:64]; assign cfg_y1=video_cfg[95:80];
    assign cfg_cx=video_cfg[111:96];assign cfg_cy=video_cfg[127:112];
    assign cfg_result_frame_id=video_cfg[159:128];
endmodule
