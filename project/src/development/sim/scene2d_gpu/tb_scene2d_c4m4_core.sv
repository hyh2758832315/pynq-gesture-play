module tb_scene2d_c4m4_core;
    timeunit 1ns;
    timeprecision 1ps;

    logic clk = 0;
    logic resetn = 0;
    logic pixel_clk = 0;
    logic pixel_resetn = 0;
    logic [63:0] tdata = 0;
    logic [7:0] tkeep = 0;
    logic tlast = 0;
    logic tvalid = 0;
    logic tready;
    logic [31:0] render_completed_seq;
    logic [31:0] render_completed_count;
    logic [31:0] render_write_count;
    logic [31:0] render_trace_crc32;
    logic [31:0] render_cycles;
    logic [31:0] render_status;
    logic [31:0] present_completed_seq;
    logic [31:0] present_completed_count;
    logic [31:0] framebuffer_status;
    logic [63:0] payload [0:519];

    always #5ns clk = ~clk;
    always #7ns pixel_clk = ~pixel_clk;

    scene2d_c4m4_core #(
        .H_ACTIVE(16), .H_FRONT(2), .H_SYNC(2), .H_BACK(2),
        .V_ACTIVE(8), .V_FRONT(1), .V_SYNC(1), .V_BACK(2),
        .OUTPUT_SCALE(1),
        .ATLAS_INIT_FILE("sim/scene2d_gpu/vectors/c4m4_atlas.mem")
    ) dut (
        .aclk(clk), .aresetn(resetn), .clk_pixel(pixel_clk), .resetn_pixel(pixel_resetn),
        .s_axis_tdata(tdata), .s_axis_tkeep(tkeep), .s_axis_tlast(tlast),
        .s_axis_tvalid(tvalid), .s_axis_tready(tready),
        .debug_command_read_address(9'd0), .debug_command_read_data_low(),
        .debug_command_read_data_high(), .upload_crc32(), .upload_byte_count(),
        .upload_packet_count(), .accepted_packet_count(), .rejected_packet_count(),
        .accepted_seq(), .accepted_status(), .upload_error_flags(),
        .render_completed_seq, .render_completed_count, .render_write_count,
        .render_trace_crc32, .render_cycles, .render_maximum_cycles(), .render_status,
        .present_completed_seq, .present_completed_count, .framebuffer_status,
        .vid_data(), .vid_de(), .vid_hsync(), .vid_vsync()
    );

    task automatic send_payload;
        begin
            for (integer beat = 0; beat < 520; beat = beat + 1) begin
                @(negedge clk);
                tdata = payload[beat];
                tkeep = 8'hFF;
                tlast = beat == 519;
                tvalid = 1'b1;
                do @(posedge clk); while (!tready);
            end
            @(negedge clk);
            tvalid = 0;
            tlast = 0;
        end
    endtask

    initial begin
        $readmemh("sim/scene2d_gpu/vectors/c4m2_payload.mem", payload);
        payload[1][63:32] = 32'hC4040001;
        payload[2][31:0] = 32'd2;
        payload[8] = {32'h000A0000, 32'h00000303};
        payload[9] = {32'h00020003, 32'h0001FFFF};
        payload[10] = 64'd0;
        payload[11] = 64'd0;
        payload[12] = {32'd0, 32'h000000FF};
        payload[13] = 64'd0;
        payload[14] = 64'd0;
        payload[15] = 64'd0;

        repeat (5) @(posedge clk);
        resetn = 1;
        repeat (5) @(posedge pixel_clk);
        pixel_resetn = 1;
        send_payload();
        wait (render_completed_count == 1);
        if (
            render_completed_seq != 32'hC4040001 || render_write_count != 3 ||
            render_trace_crc32 != 32'h173E26EB || render_status[11:4] != 0
        ) begin
            $fatal(1, "C4M4 render mismatch writes=%0d crc=%08x status=%08x", render_write_count, render_trace_crc32, render_status);
        end
        wait (present_completed_count == 1);
        @(negedge clk);
        if (present_completed_seq != 32'hC4040001 || framebuffer_status[2:0] != 3'b001) begin
            $fatal(1, "C4M4 present mismatch");
        end
        $display("SCENE2D_C4M4_CORE=PASS writes=%0d crc=%08x cycles=%0d presented=%0d", render_write_count, render_trace_crc32, render_cycles, present_completed_count);
        $finish;
    end
endmodule