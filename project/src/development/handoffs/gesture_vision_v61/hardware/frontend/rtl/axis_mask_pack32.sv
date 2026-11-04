// Compact 8-bit mask stream into little-endian 32-bit AXI DMA words.
// Input TLAST MUST mark end of DMA packet/frame, not end of video line.
// Last incomplete word has zero high bytes and contiguous TKEEP.
// Caller appends frame ID/status separately and validates DMA BTT.
module axis_mask_pack32(
    input wire aclk,aresetn,
    input wire [7:0] s_axis_tdata,
    input wire s_axis_tvalid,s_axis_tuser,s_axis_tlast,
    output wire s_axis_tready,
    output reg [31:0] m_axis_tdata,
    output reg [3:0] m_axis_tkeep,
    output reg m_axis_tvalid,m_axis_tuser,m_axis_tlast,
    input wire m_axis_tready
);
    reg [1:0] count;
    reg [31:0] partial;
    reg first_user;
    wire advance=!m_axis_tvalid || m_axis_tready;
    reg [31:0] assembled;
    always @* begin
        assembled=partial;
        case(count)
            0:assembled={24'd0,s_axis_tdata};
            1:assembled[15:8]=s_axis_tdata;
            2:assembled[23:16]=s_axis_tdata;
            3:assembled[31:24]=s_axis_tdata;
        endcase
    end
    assign s_axis_tready=aresetn && advance;
    always @(posedge aclk) begin
        if(!aresetn) begin
            count<=0;partial<=0;first_user<=0;
            m_axis_tdata<=0;m_axis_tkeep<=0;m_axis_tvalid<=0;
            m_axis_tuser<=0;m_axis_tlast<=0;
        end else begin
            if(m_axis_tready) m_axis_tvalid<=0;
            if(s_axis_tvalid && s_axis_tready) begin
                if(count==0) first_user<=s_axis_tuser;
                if(count==3 || s_axis_tlast) begin
                    m_axis_tdata<=assembled;
                    case(count)
                        0:m_axis_tkeep<=4'b0001;
                        1:m_axis_tkeep<=4'b0011;
                        2:m_axis_tkeep<=4'b0111;
                        3:m_axis_tkeep<=4'b1111;
                    endcase
                    m_axis_tvalid<=1;m_axis_tlast<=s_axis_tlast;
                    m_axis_tuser<=count==0 ? s_axis_tuser : first_user;
                    count<=0;partial<=0;first_user<=0;
                end else begin
                    partial<=assembled;count<=count+1'b1;
                end
            end
        end
    end
endmodule
