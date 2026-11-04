module axis_binary_dilate9 #(
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
    output reg [7:0] m_axis_tdata,
    output reg m_axis_tvalid,
    input wire m_axis_tready,
    output reg m_axis_tuser,
    output reg m_axis_tlast,
    output reg frame_fault
);
    localparam integer PAD_WIDTH = WIDTH + 8;
    localparam integer PAD_HEIGHT = HEIGHT + 8;
    localparam integer COLUMN_BITS = $clog2(PAD_WIDTH);
    localparam integer ROW_BITS = $clog2(PAD_HEIGHT);
    (* ram_style = "block" *) reg [7:0] line_store [0:PAD_WIDTH-1];
    reg [7:0] previous_rows;
    reg [COLUMN_BITS-1:0] scan_column, pipe_column;
    reg [ROW_BITS-1:0] scan_row, pipe_row;
    reg active, scan_done, pipe_valid, pipe_pixel;
    reg [71:0] column_history;
    wire advance = !m_axis_tvalid || m_axis_tready;
    wire real_pixel = scan_column >= 4 && scan_column < WIDTH + 4 &&
                      scan_row >= 4 && scan_row < HEIGHT + 4;
    wire issue = active && !scan_done && (!real_pixel || s_axis_tvalid);
    wire first_pixel = scan_column == 4 && scan_row == 4;
    wire final_pixel = scan_column == WIDTH + 3 && scan_row == HEIGHT + 3;
    wire [8:0] column_values = {previous_rows, pipe_pixel};
    assign s_axis_tready = aresetn && !frame_fault && active && !scan_done && real_pixel && advance;

    initial begin
        if (WIDTH < 2 || HEIGHT < 2) $fatal(1, "DILATE9 dimensions must be at least 2");
    end

    always @(posedge aclk) begin
        if (aresetn && advance && !frame_fault) begin
            if (issue) previous_rows <= line_store[scan_column];
            if (pipe_valid) line_store[pipe_column] <= {previous_rows[6:0], pipe_pixel};
        end
    end

    always @(posedge aclk) begin
        if (!aresetn) begin
            scan_column <= 0;
            scan_row <= 0;
            pipe_column <= 0;
            pipe_row <= 0;
            active <= 0;
            scan_done <= 0;
            pipe_valid <= 0;
            pipe_pixel <= 0;
            column_history <= 0;
            m_axis_tdata <= 0;
            m_axis_tvalid <= 0;
            m_axis_tuser <= 0;
            m_axis_tlast <= 0;
            frame_fault <= 0;
        end else if (frame_fault) begin
            pipe_valid <= 0;
            if (m_axis_tready) m_axis_tvalid <= 0;
        end else if (advance) begin
            pipe_valid <= 0;
            m_axis_tvalid <= pipe_valid && pipe_column >= 8 && pipe_row >= 8;
            if (pipe_valid) begin
                column_history <= {column_history[62:0], column_values};
                m_axis_tdata <= (|{column_history, column_values}) ? 8'hff : 8'h00;
                m_axis_tuser <= pipe_column == 8 && pipe_row == 8;
                m_axis_tlast <= pipe_column == PAD_WIDTH-1 && pipe_row == PAD_HEIGHT-1;
            end
            if (!active && s_axis_tvalid) begin
                if (!s_axis_tuser) frame_fault <= 1;
                else begin
                    active <= 1;
                    scan_done <= 0;
                    scan_column <= 0;
                    scan_row <= 0;
                end
            end
            if (issue) begin
                if (real_pixel && (s_axis_tuser != first_pixel || s_axis_tlast != final_pixel ||
                                   (s_axis_tdata != 0 && s_axis_tdata != 255))) begin
                    frame_fault <= 1;
                end else begin
                    pipe_valid <= 1;
                    pipe_pixel <= real_pixel && s_axis_tdata[0];
                    pipe_column <= scan_column;
                    pipe_row <= scan_row;
                    if (scan_column == PAD_WIDTH-1) begin
                        scan_column <= 0;
                        if (scan_row == PAD_HEIGHT-1) scan_done <= 1;
                        else scan_row <= scan_row + 1'b1;
                    end else scan_column <= scan_column + 1'b1;
                end
            end
            if (m_axis_tvalid && m_axis_tlast && m_axis_tready) active <= 0;
        end
    end
endmodule