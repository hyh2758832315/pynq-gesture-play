`timescale 1ns / 1ps

module test_ov5640_frame_capture;
    reg camera_pclk = 1'b0;
    reg clk = 1'b0;
    reg resetn = 1'b0;
    reg capture_enable = 1'b0;
    reg camera_vsync = 1'b0;
    reg camera_href = 1'b0;
    reg [7:0] camera_data = 8'd0;
    wire frame_done;
    wire frame_error;
    wire write_enable;
    wire [14:0] write_address;
    wire [7:0] write_data;
    reg [15:0] frame_control = 16'h8000;
    wire [31:0] read_status;
    integer sample_number = 0;
    reg check_pixels = 1'b1;
    integer line_number;
    integer byte_number;

    ov5640_frame_capture capture (
        .camera_pclk(camera_pclk),
        .resetn(resetn),
        .capture_enable(capture_enable),
        .camera_vsync(camera_vsync),
        .camera_href(camera_href),
        .camera_data(camera_data),
        .frame_done(frame_done),
        .frame_error(frame_error),
        .write_enable(write_enable),
        .write_address(write_address),
        .write_data(write_data)
    );

    ov5640_frame_buffer buffer (
        .camera_pclk(camera_pclk),
        .clk(clk),
        .resetn(resetn),
        .camera_vsync(camera_vsync),
        .camera_href(camera_href),
        .camera_data(camera_data),
        .frame_control(frame_control),
        .read_status(read_status)
    );

    always #5 camera_pclk = ~camera_pclk;
    always #3 clk = ~clk;

    task check_read;
        input [14:0] address;
        reg [7:0] expected;
        begin
            expected = ((address / 160) + (address % 160)) & 255;
            @(negedge clk);
            frame_control = 16'h8000 | address;
            repeat (3) @(posedge clk);
            #1;
            if (read_status[9:8] !== 2'b01 || read_status[7:0] !== expected)
                $fatal(1, "Frame read mismatch: address=%0d status=%h expected=%h",
                       address, read_status, expected);
        end
    endtask

    task tick;
        input vsync_value;
        input href_value;
        input [7:0] data_value;
        begin
            @(negedge camera_pclk);
            camera_vsync = vsync_value;
            camera_href = href_value;
            camera_data = data_value;
            @(posedge camera_pclk);
            #1;
            if (write_enable && check_pixels) begin
                if (write_address !== sample_number ||
                    write_data !== ((sample_number / 160 + sample_number % 160) & 255)) begin
                    $fatal(1, "Pixel mismatch: index=%0d address=%0d data=%0d",
                           sample_number, write_address, write_data);
                end
                sample_number = sample_number + 1;
            end
        end
    endtask

    initial begin
        tick(0, 0, 0);
        resetn = 1'b1;
        capture_enable = 1'b1;
        repeat (4) tick(0, 0, 0);
        repeat (4) tick(1, 0, 0);
        tick(0, 0, 0);

        for (line_number = 0; line_number < 480; line_number = line_number + 1) begin
            for (byte_number = 0; byte_number < 1280; byte_number = byte_number + 1)
                tick(0, 1, ((line_number >> 2) + (byte_number >> 3)) & 255);
            repeat (4) tick(0, 0, 0);
        end
        repeat (4) tick(1, 0, 0);
        if (!frame_done || frame_error || sample_number != 19200)
            $fatal(1, "Valid frame rejected: done=%0d error=%0d samples=%0d",
                   frame_done, frame_error, sample_number);
        check_read(15'd0);
        check_read(15'd1);
        check_read(15'd159);
        check_read(15'd160);
        check_read(15'd19199);

        check_pixels = 1'b0;
        capture_enable = 1'b0;
        frame_control = 16'd0;
        repeat (4) tick(0, 0, 0);
        if (frame_done || frame_error)
            $fatal(1, "Capture did not rearm");
        capture_enable = 1'b1;
        frame_control = 16'h8000;
        repeat (4) tick(1, 0, 0);
        tick(0, 0, 0);
        for (byte_number = 0; byte_number < 1279; byte_number = byte_number + 1)
            tick(0, 1, 0);
        repeat (4) tick(0, 0, 0);
        repeat (4) tick(1, 0, 0);
        if (frame_done || !frame_error)
            $fatal(1, "Truncated frame accepted");
        repeat (3) @(posedge clk);
        #1;
        if (read_status[9:8] !== 2'b10)
            $fatal(1, "Truncated buffer frame accepted: status=%h", read_status);

        $display("CAMERA_FRAME_CAPTURE_TEST=PASS samples=%0d", sample_number);
        $finish;
    end
endmodule