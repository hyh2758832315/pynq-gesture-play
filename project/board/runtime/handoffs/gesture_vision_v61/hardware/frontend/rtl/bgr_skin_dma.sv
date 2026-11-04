// PYNQ-Z2 / Vivado2026.1. Replaces the dedicated algorithm adapter ONLY.
// Request 5 u32 headers: SKN6, w|h<<16, fid, HL|HH|SL|SH, VL|VH.
// Payload tight B,G,R bytes, zero-padded to four-byte boundary, TKEEP=F.
// Reply ceil(N/4) padded mask words + 8 trailer words:
// SKN6, fid, dimensions, N, error, 0,0,0. One TLAST at final trailer word.
module bgr_skin_dma(
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF s_axis:m_axis, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000" *)
    input wire aclk,
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *) input wire aresetn,
    input wire [31:0] s_axis_tdata,
    input wire [3:0] s_axis_tkeep,
    input wire s_axis_tvalid,s_axis_tlast,
    output wire s_axis_tready,
    output wire [31:0] m_axis_tdata,
    output wire [3:0] m_axis_tkeep,
    output wire m_axis_tvalid,m_axis_tlast,
    input wire m_axis_tready
);
    localparam HEADER=0,FEED=1,DRAIN=2,WAIT_MASK=3,REPLY=4;
    reg [2:0] state,hi,ri;
    reg [31:0] dims,fid,hs,vbounds,total,word_total,word_count,pixel_count;
    reg [55:0] reservoir;
    reg [2:0] bytes_left;
    reg input_end,bad,mask_done;
    wire core_ready,mask_valid,mask_user,mask_last,mask_ready;
    wire [7:0] mask;
    wire [23:0] hsv_unused;
    wire pixel_valid=state==FEED && (bytes_left>=3 || input_end);
    wire pixel_accept=pixel_valid && core_ready;
    wire [23:0] pixel_data=bytes_left>=3 ? reservoir[23:0] : 24'd0;
    wire packed_valid,packed_last,packed_user;
    wire [31:0] packed_data;
    wire [3:0] packed_keep_unused;
    wire packed_ready=m_axis_tready && state!=REPLY;
    assign s_axis_tready=aresetn && (state==HEADER || state==DRAIN ||
        (state==FEED && !input_end && bytes_left<3));
    wire word_accept=s_axis_tvalid && s_axis_tready;
    reg [31:0] reply_word;
    always @* begin
        case(ri)
            0:reply_word=32'h534b4e36;
            1:reply_word=fid;
            2:reply_word=dims;
            3:reply_word=total;
            4:reply_word={31'd0,bad};
            default:reply_word=0;
        endcase
    end
    assign m_axis_tdata=state==REPLY ? reply_word : packed_data;
    assign m_axis_tkeep=4'hf; // padded mask bytes allow aligned trailer
    assign m_axis_tvalid=aresetn && (state==REPLY || packed_valid);
    assign m_axis_tlast=state==REPLY && ri==7;
    axis_bgr_hsv_skin color(
        .aclk(aclk),.aresetn(aresetn),.s_axis_tdata(pixel_data),
        .s_axis_tvalid(pixel_valid),.s_axis_tready(core_ready),
        .s_axis_tuser(pixel_count==0),.s_axis_tlast(pixel_count==total-1),
        .cfg_h_lo(hs[7:0]),.cfg_h_hi(hs[15:8]),.cfg_s_lo(hs[23:16]),.cfg_s_hi(hs[31:24]),
        .cfg_v_lo(vbounds[7:0]),.cfg_v_hi(vbounds[15:8]),
        .m_axis_hsv(hsv_unused),.m_axis_mask(mask),.m_axis_tvalid(mask_valid),
        .m_axis_tready(mask_ready),.m_axis_tuser(mask_user),.m_axis_tlast(mask_last));
    axis_mask_pack32 packer(
        .aclk(aclk),.aresetn(aresetn),.s_axis_tdata(mask),.s_axis_tvalid(mask_valid),
        .s_axis_tready(mask_ready),.s_axis_tuser(mask_user),.s_axis_tlast(mask_last),
        .m_axis_tdata(packed_data),.m_axis_tkeep(packed_keep_unused),
        .m_axis_tvalid(packed_valid),.m_axis_tready(packed_ready),
        .m_axis_tuser(packed_user),.m_axis_tlast(packed_last));
    always @(posedge aclk) begin
        if(!aresetn) begin
            state<=HEADER;hi<=0;ri<=0;dims<=0;fid<=0;hs<=0;vbounds<=0;
            total<=0;word_total<=0;word_count<=0;pixel_count<=0;
            reservoir<=0;bytes_left<=0;input_end<=0;bad<=0;mask_done<=0;
        end else begin
            if(packed_valid && packed_ready && packed_last) mask_done<=1;
            if(state==HEADER && word_accept) begin
                if(hi==0) bad<=s_axis_tdata!=32'h534b4e36 || s_axis_tkeep!=15;
                else if(s_axis_tkeep!=15) bad<=1;
                case(hi)
                    1:dims<=s_axis_tdata;
                    2:fid<=s_axis_tdata;
                    3:hs<=s_axis_tdata;
                    4:vbounds<=s_axis_tdata;
                endcase
                if(s_axis_tlast) begin bad<=1;total<=0;state<=REPLY;ri<=0;end
                else if(hi==4) begin
                    hi<=0;word_count<=0;pixel_count<=0;reservoir<=0;
                    bytes_left<=0;input_end<=0;mask_done<=0;
                    if(dims[15:0]==0 || dims[15:0]>1280 || dims[31:16]==0 || dims[31:16]>720 ||
                        hs[7:0]>hs[15:8] || hs[15:8]>179 || hs[23:16]>hs[31:24] ||
                        s_axis_tdata[7:0]>s_axis_tdata[15:8] || s_axis_tdata[31:16]!=0 || bad) begin
                        bad<=1;total<=0;mask_done<=1;state<=DRAIN;
                    end else begin
                        total<=dims[15:0]*dims[31:16];
                        word_total<=((dims[15:0]*dims[31:16])*3+3)>>2;
                        state<=FEED;
                    end
                end else hi<=hi+1'b1;
            end
            if(state==FEED && word_accept) begin
                reservoir<=reservoir | ({24'd0,s_axis_tdata}<<(bytes_left*8));
                bytes_left<=bytes_left+4;word_count<=word_count+1;
                if(s_axis_tkeep!=15 || (s_axis_tlast!=(word_count==word_total-1))) bad<=1;
                if(s_axis_tlast) input_end<=1;
            end
            if(pixel_accept) begin
                reservoir<=reservoir>>24;
                bytes_left<=bytes_left>=3 ? bytes_left-3 : 0;
                pixel_count<=pixel_count+1;
                if(bytes_left<3) bad<=1;
                if(pixel_count==total-1) begin
                    if(input_end) state<=WAIT_MASK;
                    else state<=DRAIN;
                end
            end
            if(state==DRAIN && word_accept && s_axis_tlast) begin
                bad<=1;input_end<=1;state<=WAIT_MASK;
            end
            if(state==WAIT_MASK && mask_done) begin state<=REPLY;ri<=0;end
            if(state==REPLY && m_axis_tready) begin
                if(ri==7) begin state<=HEADER;hi<=0;bad<=0;mask_done<=0;end
                else ri<=ri+1;
            end
        end
    end
endmodule
