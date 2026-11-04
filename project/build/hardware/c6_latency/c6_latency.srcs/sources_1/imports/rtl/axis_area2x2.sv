module axis_area2x2 #(
    parameter integer INPUT_WIDTH = 1280,
    parameter integer INPUT_HEIGHT = 720
)(
    input wire aclk,
    input wire aresetn,
    input wire [23:0] s_axis_tdata,
    input wire s_axis_tvalid,
    input wire s_axis_tuser,
    input wire s_axis_tlast,
    output wire s_axis_tready,
    output reg [23:0] m_axis_tdata,
    output reg m_axis_tvalid,
    output reg m_axis_tuser,
    output reg m_axis_tlast,
    input wire m_axis_tready,
    output reg frame_fault
);
    localparam integer COLUMN_BITS = INPUT_WIDTH <= 2 ? 1 : $clog2(INPUT_WIDTH);
    localparam integer ROW_BITS = INPUT_HEIGHT <= 2 ? 1 : $clog2(INPUT_HEIGHT);
    reg [COLUMN_BITS-1:0] column;
    reg [ROW_BITS-1:0] row;
    reg [23:0] left_pixel;
    (* ram_style = "block" *) reg [26:0] row_sums [0:INPUT_WIDTH/2-1];
    reg [26:0] upper_pair;
    wire accept_pixel = s_axis_tvalid && s_axis_tready;
    wire bad_framing = (s_axis_tuser != (column == 0 && row == 0)) ||
                       (s_axis_tlast != (column == INPUT_WIDTH-1));
    wire [9:0] sum_low = {1'b0, upper_pair[8:0]} + {2'b0, left_pixel[7:0]} + {2'b0, s_axis_tdata[7:0]} + 10'd2;
    wire [9:0] sum_mid = {1'b0, upper_pair[17:9]} + {2'b0, left_pixel[15:8]} + {2'b0, s_axis_tdata[15:8]} + 10'd2;
    wire [9:0] sum_high = {1'b0, upper_pair[26:18]} + {2'b0, left_pixel[23:16]} + {2'b0, s_axis_tdata[23:16]} + 10'd2;
    assign s_axis_tready = aresetn && !frame_fault && (!m_axis_tvalid || m_axis_tready);

    initial begin
        if (INPUT_WIDTH < 2 || INPUT_HEIGHT < 2 || INPUT_WIDTH % 2 || INPUT_HEIGHT % 2)
            $fatal(1, "AREA2X2 requires positive even dimensions");
    end

    always @(posedge aclk) begin
        if (accept_pixel && row[0] && !column[0]) upper_pair <= row_sums[column >> 1];
        if (accept_pixel && !row[0] && column[0]) begin
            row_sums[column >> 1][8:0] <= {1'b0, left_pixel[7:0]} + {1'b0, s_axis_tdata[7:0]};
            row_sums[column >> 1][17:9] <= {1'b0, left_pixel[15:8]} + {1'b0, s_axis_tdata[15:8]};
            row_sums[column >> 1][26:18] <= {1'b0, left_pixel[23:16]} + {1'b0, s_axis_tdata[23:16]};
        end
    end

    always @(posedge aclk) begin
        if (!aresetn) begin
            column <= 0;
            row <= 0;
            left_pixel <= 0;
            m_axis_tdata <= 0;
            m_axis_tvalid <= 0;
            m_axis_tuser <= 0;
            m_axis_tlast <= 0;
            frame_fault <= 0;
        end else begin
            if (m_axis_tready) m_axis_tvalid <= 0;
            if (accept_pixel) begin
                if (bad_framing) begin
                    frame_fault <= 1;
                    m_axis_tvalid <= 0;
                end else begin
                    if (!column[0]) left_pixel <= s_axis_tdata;
                    if (row[0] && column[0]) begin
                        m_axis_tdata <= {sum_high[9:2], sum_mid[9:2], sum_low[9:2]};
                        m_axis_tvalid <= 1;
                        m_axis_tuser <= row == 1 && column == 1;
                        m_axis_tlast <= row == INPUT_HEIGHT-1 && column == INPUT_WIDTH-1;
                    end
                    if (column == INPUT_WIDTH-1) begin
                        column <= 0;
                        row <= row == INPUT_HEIGHT-1 ? 0 : row + 1'b1;
                    end else column <= column + 1'b1;
                end
            end
        end
    end
endmodule