module tb_scene2d_c4m3_core;

    timeunit 1ns;
    timeprecision 1ps;

    logic clk = 1'b0;
    logic resetn = 1'b0;
    logic pixel_clk = 1'b0;
    logic pixel_resetn = 1'b0;
    logic [63:0] tdata = '0;
    logic [7:0] tkeep = '0;
    logic tlast = 1'b0;
    logic tvalid = 1'b0;
    logic tready;
    logic [8:0] debug_read_address = '0;
    logic [31:0] debug_read_data_low;
    logic [31:0] debug_read_data_high;
    logic [31:0] upload_crc32;
    logic [31:0] upload_byte_count;
    logic [31:0] upload_packet_count;
    logic [31:0] accepted_packet_count;
    logic [31:0] rejected_packet_count;
    logic [31:0] accepted_seq;
    logic [31:0] accepted_status;
    logic [5:0] upload_error_flags;
    logic [31:0] render_completed_seq;
    logic [31:0] render_completed_count;
    logic [31:0] render_write_count;
    logic [31:0] render_trace_crc32;
    logic [31:0] render_cycles;
    logic [31:0] render_maximum_cycles;
    logic [31:0] render_status;
    logic [31:0] present_completed_seq;
    logic [31:0] present_completed_count;
    logic [31:0] framebuffer_status;
    logic [23:0] vid_data;
    logic vid_de;
    logic vid_hsync;
    logic vid_vsync;
    logic [63:0] payload [0:519];

    always #5ns clk = ~clk;
    always #7ns pixel_clk = ~pixel_clk;

    scene2d_c4m3_core #(
        .H_ACTIVE(16),
        .H_FRONT(2),
        .H_SYNC(2),
        .H_BACK(2),
        .V_ACTIVE(8),
        .V_FRONT(1),
        .V_SYNC(1),
        .V_BACK(2),
        .OUTPUT_SCALE(1)
    ) dut (
        .aclk(clk),
        .aresetn(resetn),
        .clk_pixel(pixel_clk),
        .resetn_pixel(pixel_resetn),
        .s_axis_tdata(tdata),
        .s_axis_tkeep(tkeep),
        .s_axis_tlast(tlast),
        .s_axis_tvalid(tvalid),
        .s_axis_tready(tready),
        .debug_command_read_address(debug_read_address),
        .debug_command_read_data_low(debug_read_data_low),
        .debug_command_read_data_high(debug_read_data_high),
        .upload_crc32,
        .upload_byte_count,
        .upload_packet_count,
        .accepted_packet_count,
        .rejected_packet_count,
        .accepted_seq,
        .accepted_status,
        .upload_error_flags,
        .render_completed_seq,
        .render_completed_count,
        .render_write_count,
        .render_trace_crc32,
        .render_cycles,
        .render_maximum_cycles,
        .render_status,
        .present_completed_seq,
        .present_completed_count,
        .framebuffer_status,
        .runtime_palette_valid(1'b0),
        .runtime_palette_generation('0),
        .runtime_palette_read_address(),
        .runtime_palette_read_rgb('0),
        .palette_vblank_start(),
        .runtime_asset_valid(1'b0),
        .runtime_asset_generation('0),
        .runtime_asset_width('0),
        .runtime_asset_height('0),
        .runtime_asset_stride_bytes('0),
        .runtime_asset_id(),
        .runtime_asset_read_address(),
        .runtime_asset_read_byte('0),
        .vid_data,
        .vid_de,
        .vid_hsync,
        .vid_vsync
    );

    task automatic send_payload(input logic [31:0] sequence_value);
        logic [63:0] beat_data;
        begin
            for (integer beat = 0; beat < 520; beat = beat + 1) begin
                beat_data = payload[beat];
                if (beat == 1) begin
                    beat_data[63:32] = sequence_value;
                end
                @(negedge clk);
                tdata = beat_data;
                tkeep = 8'hFF;
                tlast = beat == 519;
                tvalid = 1'b1;
                do @(posedge clk); while (!tready);
            end
            @(negedge clk);
            tvalid = 1'b0;
            tlast = 1'b0;
            tkeep = '0;
            tdata = '0;
        end
    endtask

    initial begin
        $readmemh("sim/scene2d_gpu/vectors/c4m2_payload.mem", payload);
        repeat (5) @(posedge clk);
        @(negedge clk);
        resetn = 1'b1;
        repeat (5) @(posedge pixel_clk);
        @(negedge pixel_clk);
        pixel_resetn = 1'b1;

        send_payload(32'hC4020001);
        wait (render_completed_count == 1);
        if (
            render_completed_seq != 32'hC4020001 ||
            render_write_count != 32'd57608 ||
            render_trace_crc32 != 32'hB62CC96A ||
            render_cycles != 32'd57644 ||
            render_status[11:4] != 0 ||
            framebuffer_status[2] != 1'b1
        ) begin
            $fatal(1, "render-to-present state mismatch");
        end
        wait (present_completed_count == 1);
        @(negedge clk);
        if (
            present_completed_seq != 32'hC4020001 ||
            framebuffer_status[2] != 1'b0 ||
            framebuffer_status[1] != 1'b0 ||
            framebuffer_status[0] != 1'b1
        ) begin
            $fatal(1, "present acknowledgement mismatch");
        end
        if (upload_crc32 != 32'hC277CACE || upload_byte_count != 32'd4160) begin
            $fatal(1, "upload status mismatch");
        end
        $display("SCENE2D_C4M3_CORE=PASS writes=%0d crc=%08x cycles=%0d presented=%0d", render_write_count, render_trace_crc32, render_cycles, present_completed_count);
        $finish;
    end

endmodule