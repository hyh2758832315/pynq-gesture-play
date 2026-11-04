// PYNQ-Z2 / Vivado 2026.1, single 100MHz clock.
// One DMA packet: magic, dimensions, frame_id, HS bounds, V bounds, N pixels.
// Reply: N zero-extended mask words, magic, area, sx lo/hi, sy lo/hi, id, flags.
// TLAST is packet end externally; generated EOL/SOF internally.
// Malformed short packets are padded (and rejected); long packets drained.
module hsv_moments_dma(
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
    localparam HEADER=0,PIXELS=1,PAD=2,DRAIN=3,WAIT_RESULT=4,RESULT=5;
    reg [2:0] state,hi,ri;
    reg [15:0] width,height,x;
    reg [31:0] fid,hs,vbounds,total,count;
    reg packet_bad;
    reg [191:0] result;
    reg result_bad;
    wire core_ready,mask_valid,mask_sof,mask_eol,stat_valid,stat_error;
    wire [7:0] mask;
    wire [191:0] stats;
    wire feed=state==PIXELS || state==PAD;
    wire core_valid=feed && (state==PAD || s_axis_tvalid);
    wire final_input=count==total-1;
    wire mask_ready=m_axis_tready && state!=RESULT;
    wire stat_ready=state==WAIT_RESULT && !mask_valid;
    assign s_axis_tready=aresetn && (state==HEADER || state==DRAIN ||
        (state==PIXELS && core_ready));
    assign m_axis_tkeep=4'hf;
    reg [31:0] result_word;
    always @* begin
        case(ri)
            0:result_word=32'h48534d32;
            1:result_word=result[31:0];
            2:result_word=result[63:32];
            3:result_word=result[95:64];
            4:result_word=result[127:96];
            5:result_word=result[159:128];
            6:result_word=result[191:160];
            default:result_word={31'd0,result_bad};
        endcase
    end
    assign m_axis_tdata=state==RESULT ? result_word : {24'd0,mask};
    assign m_axis_tvalid=aresetn && (state==RESULT || mask_valid);
    assign m_axis_tlast=state==RESULT && ri==7;
    axis_hsv_moments core(
        .aclk(aclk),.aresetn(aresetn),.cfg_width(width),.cfg_height(height),
        .cfg_frame_id(fid),.cfg_h_lo(hs[7:0]),.cfg_h_hi(hs[15:8]),
        .cfg_s_lo(hs[23:16]),.cfg_s_hi(hs[31:24]),
        .cfg_v_lo(vbounds[7:0]),.cfg_v_hi(vbounds[15:8]),
        .s_axis_tdata(state==PAD ? 32'd0 : s_axis_tdata),
        .s_axis_tvalid(core_valid),.s_axis_tready(core_ready),
        .s_axis_tuser(count==0),.s_axis_tlast(x==width-1),
        .m_axis_tdata(mask),.m_axis_tvalid(mask_valid),.m_axis_tready(mask_ready),
        .m_axis_tuser(mask_sof),.m_axis_tlast(mask_eol),
        .stat_data(stats),.stat_valid(stat_valid),.stat_error(stat_error),
        .stat_ready(stat_ready)
    );
    always @(posedge aclk) begin
        if(!aresetn) begin
            state<=HEADER;hi<=0;ri<=0;width<=1;height<=1;x<=0;
            fid<=0;hs<=0;vbounds<=0;total<=1;count<=0;
            packet_bad<=0;result<=0;result_bad<=0;
        end else begin
            if(state==HEADER && s_axis_tvalid && s_axis_tready) begin
                if(hi==0) packet_bad<=s_axis_tdata!=32'h48534d32 || s_axis_tkeep!=15;
                else if(s_axis_tkeep!=15) packet_bad<=1;
                case(hi)
                    1:begin width<=s_axis_tdata[15:0];height<=s_axis_tdata[31:16];end
                    2:fid<=s_axis_tdata;
                    3:hs<=s_axis_tdata;
                    4:vbounds<=s_axis_tdata;
                endcase
                // Invalid headers produce an error-only response, never run core.
                if(s_axis_tlast) begin
                    result<=0;result_bad<=1;ri<=0;state<=RESULT;
                end else if(hi==4) begin
                    hi<=0;count<=0;x<=0;
                    if(width==0 || height==0 || width>1280 || height>720 ||
                        hs[7:0]>hs[15:8] || hs[15:8]>179 ||
                        hs[23:16]>hs[31:24] || s_axis_tdata[7:0]>s_axis_tdata[15:8]) begin
                        result<=0;result_bad<=1;state<=DRAIN;total<=0;
                    end else begin
                        total<=width*height;state<=PIXELS;
                    end
                end else hi<=hi+1'b1;
            end
            if(feed && core_valid && core_ready) begin
                count<=count+1'b1;
                x<=x==width-1 ? 16'd0 : x+1'b1;
                if(state==PIXELS && (s_axis_tkeep!=15 || s_axis_tlast!=final_input)) packet_bad<=1;
                if(final_input) begin
                    if(state==PIXELS && !s_axis_tlast) state<=DRAIN;
                    else state<=WAIT_RESULT;
                end else if(state==PIXELS && s_axis_tlast) state<=PAD;
            end
            if(state==DRAIN && s_axis_tvalid && s_axis_tready && s_axis_tlast) begin
                if(total==0) begin state<=RESULT;ri<=0;end
                else state<=WAIT_RESULT;
            end
            if(stat_valid && stat_ready) begin
                result<=stats;result_bad<=packet_bad || stat_error;
                ri<=0;state<=RESULT;
            end
            if(state==RESULT && m_axis_tready) begin
                if(ri==7) begin state<=HEADER;hi<=0;packet_bad<=0;end
                else ri<=ri+1'b1;
            end
        end
    end
endmodule
