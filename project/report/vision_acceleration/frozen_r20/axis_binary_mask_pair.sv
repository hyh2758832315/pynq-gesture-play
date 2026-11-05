module axis_binary_mask_pair #(
    parameter integer WIDTH = 640,
    parameter integer HEIGHT = 360
)(
    input wire aclk,
    input wire aresetn,
    input wire [7:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,
    input wire s_axis_tuser,
    input wire s_axis_tlast,
    output reg [15:0] m_axis_tdata,
    output reg m_axis_tvalid,
    input wire m_axis_tready,
    output reg m_axis_tuser,
    output reg m_axis_tlast,
    output reg frame_fault
);
    localparam integer FIFO_DEPTH = 1 << $clog2(8 * WIDTH + 32);
    localparam integer COUNT_BITS = $clog2(FIFO_DEPTH) + 1;
    wire full, empty, write_busy, read_busy, overflow, underflow;
    wire [2:0] raw_word;
    wire [COUNT_BITS-1:0] raw_count;
    wire [7:0] dilated_data, filtered_data;
    wire dilated_valid, dilated_ready, dilated_user, dilated_last, dilation_fault;
    wire filtered_valid, filtered_ready, filtered_user, filtered_last, gaussian_fault;
    wire dilation_ready;
    wire fifo_ready = !full && !write_busy && !read_busy && aresetn;
    wire source_valid = s_axis_tvalid && fifo_ready && !frame_fault;
    wire raw_valid = !empty && !write_busy && !read_busy && aresetn;
    wire advance = !m_axis_tvalid || m_axis_tready;
    wire aligned = raw_word[2] == filtered_user && raw_word[1] == filtered_last;
    wire pair_take = raw_valid && filtered_valid && aligned && advance && !frame_fault;
    assign s_axis_tready = dilation_ready && fifo_ready && !frame_fault;
    assign filtered_ready = raw_valid && aligned && advance && !frame_fault;

    axis_binary_dilate9 #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) dilation (
        .aclk(aclk), .aresetn(aresetn), .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(source_valid), .s_axis_tready(dilation_ready),
        .s_axis_tuser(s_axis_tuser), .s_axis_tlast(s_axis_tlast),
        .m_axis_tdata(dilated_data), .m_axis_tvalid(dilated_valid),
        .m_axis_tready(dilated_ready), .m_axis_tuser(dilated_user),
        .m_axis_tlast(dilated_last), .frame_fault(dilation_fault)
    );
    axis_binary_gaussian5 #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) gaussian (
        .aclk(aclk), .aresetn(aresetn), .s_axis_tdata(dilated_data),
        .s_axis_tvalid(dilated_valid), .s_axis_tready(dilated_ready),
        .s_axis_tuser(dilated_user), .s_axis_tlast(dilated_last),
        .m_axis_tdata(filtered_data), .m_axis_tvalid(filtered_valid),
        .m_axis_tready(filtered_ready), .m_axis_tuser(filtered_user),
        .m_axis_tlast(filtered_last), .frame_fault(gaussian_fault)
    );
    xpm_fifo_sync #(
        .FIFO_MEMORY_TYPE("block"), .FIFO_WRITE_DEPTH(FIFO_DEPTH),
        .WRITE_DATA_WIDTH(3), .READ_DATA_WIDTH(3),
        .READ_MODE("fwft"), .FIFO_READ_LATENCY(0), .USE_ADV_FEATURES("0707"),
        .WR_DATA_COUNT_WIDTH(COUNT_BITS), .RD_DATA_COUNT_WIDTH(COUNT_BITS), .SIM_ASSERT_CHK(1)
    ) raw_fifo (
        .sleep(1'b0), .rst(!aresetn), .wr_clk(aclk),
        .wr_en(s_axis_tvalid && s_axis_tready), .din({s_axis_tuser, s_axis_tlast, s_axis_tdata[0]}),
        .full(full), .prog_full(), .wr_data_count(raw_count), .overflow(overflow),
        .wr_rst_busy(write_busy), .almost_full(), .wr_ack(),
        .rd_en(pair_take), .dout(raw_word), .empty(empty), .prog_empty(),
        .rd_data_count(), .underflow(underflow), .rd_rst_busy(read_busy),
        .almost_empty(), .data_valid(), .injectsbiterr(1'b0), .injectdbiterr(1'b0),
        .sbiterr(), .dbiterr()
    );

    always @(posedge aclk) begin
        if (!aresetn) begin
            m_axis_tdata <= 0;
            m_axis_tvalid <= 0;
            m_axis_tuser <= 0;
            m_axis_tlast <= 0;
            frame_fault <= 0;
        end else begin
            if (dilation_fault || gaussian_fault || overflow || underflow ||
                (raw_valid && filtered_valid && !aligned)) frame_fault <= 1;
            if (frame_fault) begin
                if (m_axis_tready) m_axis_tvalid <= 0;
            end else if (advance) begin
                m_axis_tvalid <= pair_take;
                if (pair_take) begin
                    m_axis_tdata <= {filtered_data, raw_word[0] ? 8'hff : 8'h00};
                    m_axis_tuser <= filtered_user;
                    m_axis_tlast <= filtered_last;
                end
            end
        end
    end
endmodule