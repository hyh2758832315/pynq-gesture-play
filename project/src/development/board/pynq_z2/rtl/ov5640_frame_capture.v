`timescale 1ns / 1ps

module ov5640_frame_capture #(
    parameter Y_BYTE_PHASE = 1'b0
) (
    input  wire        camera_pclk,
    input  wire        resetn,
    input  wire        capture_enable,
    input  wire        camera_vsync,
    input  wire        camera_href,
    input  wire [7:0]  camera_data,
    output reg         frame_done,
    output reg         frame_error,
    output reg         write_enable,
    output reg  [14:0] write_address,
    output reg  [7:0]  write_data
);
    reg [1:0] enable_sync;
    reg previous_vsync;
    reg previous_href;
    reg saw_vsync;
    reg capturing;
    reg invalid_frame;
    reg [10:0] byte_index;
    reg [8:0] line_index;
    reg [14:0] row_base;
    reg [14:0] sample_count;

    always @(posedge camera_pclk or negedge resetn) begin
        if (!resetn) begin
            enable_sync <= 2'b00;
            previous_vsync <= 1'b0;
            previous_href <= 1'b0;
            saw_vsync <= 1'b0;
            capturing <= 1'b0;
            invalid_frame <= 1'b0;
            byte_index <= 11'd0;
            line_index <= 9'd0;
            row_base <= 15'd0;
            sample_count <= 15'd0;
            frame_done <= 1'b0;
            frame_error <= 1'b0;
            write_enable <= 1'b0;
            write_address <= 15'd0;
            write_data <= 8'd0;
        end else begin
            enable_sync <= {enable_sync[0], capture_enable};
            previous_vsync <= camera_vsync;
            previous_href <= camera_href;
            write_enable <= 1'b0;

            if (!enable_sync[1]) begin
                saw_vsync <= 1'b0;
                capturing <= 1'b0;
                frame_done <= 1'b0;
                frame_error <= 1'b0;
            end else if (!frame_done && !frame_error) begin
                if (camera_vsync) begin
                    saw_vsync <= 1'b1;
                    if (!previous_vsync && capturing) begin
                        capturing <= 1'b0;
                        if (!invalid_frame && !previous_href &&
                            line_index == 9'd480 && sample_count == 15'd19200)
                            frame_done <= 1'b1;
                        else
                            frame_error <= 1'b1;
                    end
                end else if (previous_vsync && saw_vsync && !capturing) begin
                    capturing <= 1'b1;
                    invalid_frame <= 1'b0;
                    byte_index <= 11'd0;
                    line_index <= 9'd0;
                    row_base <= 15'd0;
                    sample_count <= 15'd0;
                end else if (capturing) begin
                    if (camera_href) begin
                        if (!previous_href)
                            byte_index <= 11'd1;
                        else if (byte_index < 11'd1280)
                            byte_index <= byte_index + 1'b1;
                        else
                            invalid_frame <= 1'b1;

                        if (line_index < 9'd480 &&
                            (!previous_href || byte_index < 11'd1280) &&
                            line_index[1:0] == 2'b00 &&
                            (previous_href ? byte_index[2:0] : 3'b000) ==
                                {2'b00, Y_BYTE_PHASE}) begin
                            write_enable <= 1'b1;
                            write_address <= row_base +
                                (previous_href ? byte_index[10:3] : 8'd0);
                            write_data <= camera_data;
                            sample_count <= sample_count + 1'b1;
                        end
                    end else if (previous_href) begin
                        if (byte_index != 11'd1280 || line_index == 9'd480)
                            invalid_frame <= 1'b1;
                        else begin
                            line_index <= line_index + 1'b1;
                            if (line_index[1:0] == 2'b00)
                                row_base <= row_base + 15'd160;
                        end
                    end
                end
            end
        end
    end
endmodule

module ov5640_frame_buffer #(
    parameter Y_BYTE_PHASE = 1'b0
) (
    input  wire        camera_pclk,
    input  wire        clk,
    input  wire        resetn,
    input  wire        camera_vsync,
    input  wire        camera_href,
    input  wire [7:0]  camera_data,
    input  wire [15:0] frame_control,
    output wire [31:0] read_status
);
    wire frame_done;
    wire frame_error;
    wire write_enable;
    wire [14:0] write_address;
    wire [7:0] write_data;
    (* ASYNC_REG = "TRUE" *) reg [1:0] done_sync;
    (* ASYNC_REG = "TRUE" *) reg [1:0] error_sync;
    reg [7:0] read_data;
    (* ram_style = "block" *) reg [7:0] pixels [0:19199];

    ov5640_frame_capture #(.Y_BYTE_PHASE(Y_BYTE_PHASE)) capture (
        .camera_pclk(camera_pclk),
        .resetn(resetn),
        .capture_enable(frame_control[15]),
        .camera_vsync(camera_vsync),
        .camera_href(camera_href),
        .camera_data(camera_data),
        .frame_done(frame_done),
        .frame_error(frame_error),
        .write_enable(write_enable),
        .write_address(write_address),
        .write_data(write_data)
    );

    always @(posedge camera_pclk) begin
        if (write_enable)
            pixels[write_address] <= write_data;
    end

    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            done_sync <= 2'b00;
            error_sync <= 2'b00;
            read_data <= 8'd0;
        end else begin
            done_sync <= {done_sync[0], frame_done};
            error_sync <= {error_sync[0], frame_error};
            read_data <= pixels[frame_control[14:0]];
        end
    end

    assign read_status = {22'd0, error_sync[1], done_sync[1], read_data};
endmodule