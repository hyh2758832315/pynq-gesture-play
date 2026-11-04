module tb_scene2d_c4m6_core;

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
    logic [31:0] accepted_packet_count;
    logic [31:0] render_completed_count;
    logic [31:0] render_write_count;
    logic [31:0] render_trace_crc32;
    logic [31:0] render_status;
    logic [31:0] present_completed_count;
    logic [31:0] palette_generation;
    logic [31:0] asset_accepted_packet_count;
    logic [31:0] asset_rejected_packet_count;
    logic [31:0] asset_generation;
    logic [8:0] asset_error_flags;
    logic [31:0] asset_status;
    logic [63:0] scene_payload [0:519];

    always #5ns clk = ~clk;
    always #7ns pixel_clk = ~pixel_clk;

    scene2d_c4m6_core #(
        .H_ACTIVE(16), .H_FRONT(2), .H_SYNC(2), .H_BACK(2),
        .V_ACTIVE(8), .V_FRONT(1), .V_SYNC(1), .V_BACK(2),
        .OUTPUT_SCALE(1)
    ) dut (
        .aclk(clk), .aresetn(resetn), .clk_pixel(pixel_clk), .resetn_pixel(pixel_resetn),
        .s_axis_tdata(tdata), .s_axis_tkeep(tkeep), .s_axis_tlast(tlast),
        .s_axis_tvalid(tvalid), .s_axis_tready(tready),
        .debug_command_read_address(9'd0), .debug_command_read_data_low(),
        .debug_command_read_data_high(), .upload_crc32(), .upload_byte_count(),
        .upload_packet_count(), .accepted_packet_count, .rejected_packet_count(),
        .accepted_seq(), .accepted_status(), .upload_error_flags(),
        .render_completed_seq(), .render_completed_count, .render_write_count,
        .render_trace_crc32, .render_cycles(), .render_maximum_cycles(), .render_status,
        .present_completed_seq(), .present_completed_count, .framebuffer_status(),
        .router_dropped_packet_count(), .unsupported_packet_count(),
        .palette_accepted_packet_count(), .palette_rejected_packet_count(),
        .palette_generation, .palette_error_flags(), .palette_status(),
        .asset_accepted_packet_count, .asset_rejected_packet_count, .asset_generation,
        .asset_error_flags, .asset_status,
        .vid_data(), .vid_de(), .vid_hsync(), .vid_vsync()
    );

    function automatic logic [31:0] crc32_byte(
        input logic [31:0] crc, input logic [7:0] data
    );
        logic [31:0] next_crc;
        begin
            next_crc = crc ^ data;
            for (int bit_index = 0; bit_index < 8; bit_index = bit_index + 1) begin
                next_crc = next_crc[0] ? (next_crc >> 1) ^ 32'hEDB88320 : next_crc >> 1;
            end
            return next_crc;
        end
    endfunction

    function automatic logic [31:0] update_crc32(
        input logic [31:0] crc, input logic [31:0] word, input int bytes
    );
        logic [31:0] next_crc;
        begin
            next_crc = crc;
            for (int byte_index = 0; byte_index < bytes; byte_index = byte_index + 1) begin
                next_crc = crc32_byte(next_crc, word[byte_index * 8 +: 8]);
            end
            return next_crc;
        end
    endfunction

    function automatic logic [31:0] asset_bundle_word(input int index);
        case (index)
            0: return 32'd0;
            1: return 32'h00020003;
            2: return 32'hEF010002;
            3: return 32'd4;
            4: return 32'd64;
            5: return 32'h00010002;
            6: return 32'hEF010001;
            7: return 32'd1;
            8: return 32'd128;
            9: return 32'h00010001;
            10: return 32'hEF010001;
            11: return 32'd1;
            12: return 32'h00430201;
            28: return 32'h00000087;
            44: return 32'h00000009;
            default: return '0;
        endcase
    endfunction

    function automatic logic [31:0] asset_bundle_crc32;
        logic [31:0] crc;
        int byte_count;
        begin
            crc = 32'hFFFFFFFF;
            for (int word_index = 0; word_index < 45; word_index = word_index + 1) begin
                byte_count = word_index == 44 ? 1 : 4;
                crc = update_crc32(crc, asset_bundle_word(word_index), byte_count);
            end
            return ~crc;
        end
    endfunction

    function automatic logic [31:0] palette_word(input int index);
        return {8'h00, 8'(index), 8'(index ^ 8'h5A), 8'(index * 3)};
    endfunction

    function automatic logic [31:0] palette_crc32;
        logic [31:0] crc;
        begin
            crc = 32'hFFFFFFFF;
            for (int index = 0; index < 256; index = index + 1) begin
                crc = update_crc32(crc, palette_word(index), 4);
            end
            return ~crc;
        end
    endfunction

    task automatic send_beat(input logic [63:0] data, input logic [7:0] keep, input logic last);
        begin
            @(negedge clk);
            tdata = data; tkeep = keep; tlast = last; tvalid = 1'b1;
            do @(posedge clk); while (!tready);
        end
    endtask

    task automatic finish_packet;
        begin
            @(negedge clk);
            tvalid = 1'b0; tlast = 1'b0; tkeep = '0; tdata = '0;
        end
    endtask

    task automatic send_asset;
        int word_index;
        begin
            send_beat({32'h00010000, 32'h41443253}, 8'hFF, 1'b0);
            send_beat({32'd0, 32'd1}, 8'hFF, 1'b0);
            send_beat({32'd177, 32'h001234EF}, 8'hFF, 1'b0);
            send_beat({32'd0, asset_bundle_crc32()}, 8'hFF, 1'b0);
            for (int beat = 4; beat < 8; beat = beat + 1) send_beat(64'd0, 8'hFF, 1'b0);
            for (int beat = 8; beat <= 30; beat = beat + 1) begin
                word_index = (beat - 8) * 2;
                send_beat(
                    {asset_bundle_word(word_index + 1), asset_bundle_word(word_index)},
                    beat == 30 ? 8'h01 : 8'hFF,
                    beat == 30
                );
            end
            finish_packet();
        end
    endtask

    task automatic send_palette(input logic [31:0] generation);
        int payload_index;
        begin
            send_beat({32'h00010000, 32'h50443253}, 8'hFF, 1'b0);
            send_beat({32'd0, 32'd3}, 8'hFF, 1'b0);
            send_beat({32'd1024, generation}, 8'hFF, 1'b0);
            send_beat({32'd0, palette_crc32()}, 8'hFF, 1'b0);
            for (int beat = 4; beat < 8; beat = beat + 1) send_beat(64'd0, 8'hFF, 1'b0);
            for (int beat = 8; beat < 136; beat = beat + 1) begin
                payload_index = (beat - 8) * 2;
                send_beat({palette_word(payload_index + 1), palette_word(payload_index)}, 8'hFF, beat == 135);
            end
            finish_packet();
        end
    endtask

    task automatic send_scene(
        input logic [31:0] palette_generation_value,
        input logic [31:0] asset_generation_value,
        input logic [15:0] asset_id,
        input logic [15:0] dst_x,
        input logic [15:0] dst_y,
        input logic [15:0] width,
        input logic [15:0] height
    );
        begin
            scene_payload[1][63:32] = 32'hC4060001;
            scene_payload[2][31:0] = 32'd2;
            scene_payload[4][31:0] = palette_generation_value;
            scene_payload[5][31:0] = asset_generation_value;
            scene_payload[8] = {{12'd0, 4'hA, asset_id}, 32'h00000303};
            scene_payload[9] = {{height, width}, {dst_y, dst_x}};
            scene_payload[10] = 64'd0;
            scene_payload[11] = 64'd0;
            scene_payload[12] = {32'd0, 32'h000000FF};
            scene_payload[13] = 64'd0;
            scene_payload[14] = 64'd0;
            scene_payload[15] = 64'd0;
            for (int beat = 0; beat < 520; beat = beat + 1) begin
                send_beat(scene_payload[beat], 8'hFF, beat == 519);
            end
            finish_packet();
        end
    endtask

    initial begin
        $readmemh("sim/scene2d_gpu/vectors/c4m2_payload.mem", scene_payload);
        repeat (5) @(posedge clk);
        resetn = 1'b1;
        repeat (5) @(posedge pixel_clk);
        pixel_resetn = 1'b1;

        send_palette(32'h00000011);
        wait (palette_generation == 32'h00000011);
        send_scene(32'h00000011, 32'h001234EF, 16'd0, 16'hFFFF, 16'd1, 16'd3, 16'd2);
        wait (accepted_packet_count == 1);
        repeat (100) @(posedge clk);
        if (render_completed_count != 0) begin
            $fatal(1, "scene rendered before matching asset generation");
        end
        send_asset();
        wait (asset_generation == 32'h001234EF);
        if (asset_accepted_packet_count != 1 || asset_rejected_packet_count != 0 ||
            asset_error_flags != 0 || asset_status[0] != 1'b1) begin
            $fatal(
                1,
                "asset status accepted=%0d rejected=%0d generation=%08x flags=%03x status=%08x",
                asset_accepted_packet_count,
                asset_rejected_packet_count,
                asset_generation,
                asset_error_flags,
                asset_status
            );
        end
        wait (render_completed_count == 1);
        wait (present_completed_count == 1);
        if (render_write_count != 3 || render_trace_crc32 != 32'h173E26EB) begin
            $fatal(1, "runtime asset render mismatch writes=%0d crc=%08x", render_write_count, render_trace_crc32);
        end
        send_scene(32'h00000011, 32'h001234EF, 16'd2, 16'd10, 16'd5, 16'd1, 16'd1);
        wait (accepted_packet_count == 2);
        wait (render_completed_count == 2);
        wait (present_completed_count == 2);
        if (render_write_count != 1) begin
            $fatal(
                1,
                "slot 2 writes=%0d status=%08x id=%0d width=%0d height=%0d stride=%0d",
                render_write_count,
                render_status,
                dut.asset_read_id,
                dut.asset_width,
                dut.asset_height,
                dut.asset_stride_bytes
            );
        end
        $display("SCENE2D_C4M6_CORE=PASS writes=%0d crc=%08x generation=%08x", render_write_count, render_trace_crc32, asset_generation);
        $finish;
    end

endmodule