module axis_binary_gaussian5 #(
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
    localparam integer COLUMN_BITS = $clog2(WIDTH + 2);
    localparam integer ROW_BITS = $clog2(HEIGHT + 2);
    (* ram_style = "block" *) reg [35:0] line_store [0:WIDTH-1];
    reg [35:0] previous_rows;
    reg [3:0] horizontal_history;
    reg [COLUMN_BITS-1:0] scan_column, pipe_column;
    reg [ROW_BITS-1:0] scan_row, pipe_row;
    reg active, scan_done, pipe_valid;
    reg [8:0] pipe_horizontal;
    reg [10:0] sum_stage;
    reg [8:0] center_stage;
    reg [16:0] weight_stage;
    reg sum_valid, sum_user, sum_last;
    reg weight_valid, weight_user, weight_last;
    wire advance = !m_axis_tvalid || m_axis_tready;
    wire real_pixel = scan_row < HEIGHT && scan_column < WIDTH;
    wire issue = active && !scan_done && (!real_pixel || s_axis_tvalid);
    wire first_pixel = scan_row == 0 && scan_column == 0;
    wire final_pixel = scan_row == HEIGHT-1 && scan_column == WIDTH-1;
    wire pixel = scan_column < WIDTH ? s_axis_tdata[0] :
                 scan_column == WIDTH || WIDTH == 2 ? horizontal_history[1] : horizontal_history[3];
    wire horizontal_first = scan_column == 2 ? pixel :
                            scan_column == 3 ? horizontal_history[1] : horizontal_history[3];
    wire horizontal_second = scan_column == 2 ? horizontal_history[0] : horizontal_history[2];
    wire [2:0] ones = {2'd0, horizontal_first} + {2'd0, horizontal_second} +
                      {2'd0, horizontal_history[1]} + {2'd0, horizontal_history[0]} + {2'd0, pixel};
    wire [8:0] ones_wide = {6'd0, ones};
    wire [8:0] horizontal_sum = (ones_wide << 5) + (ones_wide << 4) +
                               (ones_wide << 1) + ones_wide + {8'd0, horizontal_history[1]};
    wire [8:0] column_value = pipe_row < HEIGHT ? pipe_horizontal :
                              pipe_row == HEIGHT || HEIGHT == 2 ? previous_rows[17:9] : previous_rows[35:27];
    wire [8:0] tap_first = pipe_row == 2 ? column_value :
                           pipe_row == 3 ? previous_rows[17:9] : previous_rows[35:27];
    wire [8:0] tap_second = pipe_row == 2 ? previous_rows[8:0] : previous_rows[26:18];
    wire [8:0] tap_center = previous_rows[17:9];
    wire [10:0] row_sum = {2'd0, tap_first} + {2'd0, tap_second} + {2'd0, tap_center} +
                          {2'd0, previous_rows[8:0]} + {2'd0, column_value};
    wire [16:0] row_wide = {6'd0, sum_stage};
    wire [16:0] vertical_sum = (row_wide << 5) + (row_wide << 4) +
                               (row_wide << 1) + row_wide + {8'd0, center_stage};
    wire [24:0] rounded = ({8'd0, weight_stage} << 8) - {8'd0, weight_stage} + 25'd32768;
    assign s_axis_tready = aresetn && !frame_fault && active && !scan_done && real_pixel && advance;

    initial begin
        if (WIDTH < 2 || HEIGHT < 2) $fatal(1, "GAUSSIAN dimensions must be at least 2");
    end

    always @(posedge aclk) begin
        if (aresetn && advance && !frame_fault) begin
            if (issue && scan_column >= 2) previous_rows <= line_store[scan_column-2];
            if (pipe_valid) line_store[pipe_column] <= {previous_rows[26:0], column_value};
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
            pipe_horizontal <= 0;
            sum_stage <= 0;
            center_stage <= 0;
            weight_stage <= 0;
            sum_valid <= 0;
            sum_user <= 0;
            sum_last <= 0;
            weight_valid <= 0;
            weight_user <= 0;
            weight_last <= 0;
            horizontal_history <= 0;
            m_axis_tdata <= 0;
            m_axis_tvalid <= 0;
            m_axis_tuser <= 0;
            m_axis_tlast <= 0;
            frame_fault <= 0;
        end else if (frame_fault) begin
            pipe_valid <= 0;
            sum_valid <= 0;
            weight_valid <= 0;
            if (m_axis_tready) m_axis_tvalid <= 0;
        end else if (advance) begin
            pipe_valid <= 0;
            m_axis_tvalid <= weight_valid;
            if (weight_valid) begin
                m_axis_tdata <= rounded[23:16];
                m_axis_tuser <= weight_user;
                m_axis_tlast <= weight_last;
            end
            weight_valid <= sum_valid;
            if (sum_valid) begin
                weight_stage <= vertical_sum;
                weight_user <= sum_user;
                weight_last <= sum_last;
            end
            sum_valid <= pipe_valid && pipe_row >= 2;
            if (pipe_valid) begin
                sum_stage <= row_sum;
                center_stage <= tap_center;
                sum_user <= pipe_row == 2 && pipe_column == 0;
                sum_last <= pipe_row == HEIGHT+1 && pipe_column == WIDTH-1;
            end
            if (!active && s_axis_tvalid) begin
                if (!s_axis_tuser) frame_fault <= 1;
                else begin
                    active <= 1;
                    scan_done <= 0;
                    scan_column <= 0;
                    scan_row <= 0;
                    horizontal_history <= 0;
                end
            end
            if (issue) begin
                if (real_pixel && (s_axis_tuser != first_pixel || s_axis_tlast != final_pixel ||
                                   (s_axis_tdata != 0 && s_axis_tdata != 255))) begin
                    frame_fault <= 1;
                end else begin
                    pipe_valid <= scan_column >= 2;
                    pipe_column <= scan_column - 2;
                    pipe_row <= scan_row;
                    pipe_horizontal <= horizontal_sum;
                    if (scan_row < HEIGHT) horizontal_history <= {horizontal_history[2:0], pixel};
                    if (scan_column == WIDTH+1) begin
                        scan_column <= 0;
                        horizontal_history <= 0;
                        if (scan_row == HEIGHT+1) scan_done <= 1;
                        else scan_row <= scan_row + 1'b1;
                    end else scan_column <= scan_column + 1'b1;
                end
            end
            if (m_axis_tvalid && m_axis_tlast && m_axis_tready) active <= 0;
        end
    end
endmodule