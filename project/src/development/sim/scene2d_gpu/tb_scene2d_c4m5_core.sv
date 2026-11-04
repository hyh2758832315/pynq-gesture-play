module tb_scene2d_c4m5_core;

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
    logic [31:0] render_completed_seq;
    logic [31:0] render_completed_count;
    logic [31:0] render_write_count;
    logic [31:0] render_trace_crc32;
    logic [31:0] present_completed_count;
    logic [31:0] router_dropped_packet_count;
    logic [31:0] unsupported_packet_count;
    logic [31:0] palette_accepted_packet_count;
    logic [31:0] palette_rejected_packet_count;
    logic [31:0] palette_generation;
    logic [8:0] palette_error_flags;
    logic [31:0] palette_status;
    logic [63:0] scene_payload [0:519];

    always #5ns clk = ~clk;
    always #7ns pixel_clk = ~pixel_clk;

    scene2d_c4m5_core #(
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
        .upload_packet_count(), .accepted_packet_count, .rejected_packet_count(),
        .accepted_seq(), .accepted_status(), .upload_error_flags(),
        .render_completed_seq, .render_completed_count, .render_write_count,
        .render_trace_crc32, .render_cycles(), .render_maximum_cycles(), .render_status(),
        .present_completed_seq(), .present_completed_count, .framebuffer_status(),
        .router_dropped_packet_count, .unsupported_packet_count,
        .palette_accepted_packet_count, .palette_rejected_packet_count,
        .palette_generation, .palette_error_flags, .palette_status,
        .vid_data(), .vid_de(), .vid_hsync(), .vid_vsync()
    );

    function automatic logic [31:0] palette_word(
        input int seed,
        input int index
    );
        return {
            8'h00,
            8'(seed + index),
            8'(seed ^ index),
            8'(seed * 3 + index * 5)
        };
    endfunction

    function automatic logic [31:0] crc32_byte(
        input logic [31:0] crc,
        input logic [7:0] data
    );
        logic [31:0] next_crc;
        begin
            next_crc = crc ^ data;
            for (int bit_index = 0; bit_index < 8; bit_index = bit_index + 1) begin
                next_crc = next_crc[0]
                    ? (next_crc >> 1) ^ 32'hEDB88320
                    : next_crc >> 1;
            end
            return next_crc;
        end
    endfunction

    function automatic logic [31:0] palette_crc32(input int seed);
        logic [31:0] crc;
        logic [31:0] word_data;
        begin
            crc = 32'hFFFFFFFF;
            for (int index = 0; index < 256; index = index + 1) begin
                word_data = palette_word(seed, index);
                for (int byte_index = 0; byte_index < 4; byte_index = byte_index + 1) begin
                    crc = crc32_byte(crc, word_data[byte_index * 8 +: 8]);
                end
            end
            return ~crc;
        end
    endfunction

    function automatic logic [63:0] palette_beat(
        input int beat,
        input int seed,
        input logic [31:0] generation
    );
        int payload_index;
        begin
            case (beat)
                0: return {32'h00010000, 32'h50443253};
                1: return {32'd0, 32'd3};
                2: return {32'd1024, generation};
                3: return {32'd0, palette_crc32(seed)};
                4, 5, 6, 7: return 64'd0;
                default: begin
                    payload_index = (beat - 8) * 2;
                    return {
                        palette_word(seed, payload_index + 1),
                        palette_word(seed, payload_index)
                    };
                end
            endcase
        end
    endfunction

    task automatic send_beat(
        input logic [63:0] data,
        input logic last
    );
        begin
            @(negedge clk);
            tdata = data;
            tkeep = 8'hFF;
            tlast = last;
            tvalid = 1'b1;
            do @(posedge clk); while (!tready);
        end
    endtask

    task automatic finish_packet;
        begin
            @(negedge clk);
            tvalid = 1'b0;
            tlast = 1'b0;
            tkeep = '0;
            tdata = '0;
        end
    endtask

    task automatic send_palette(
        input int seed,
        input logic [31:0] generation
    );
        begin
            for (int beat = 0; beat < 136; beat = beat + 1) begin
                send_beat(palette_beat(beat, seed, generation), beat == 135);
            end
            finish_packet();
        end
    endtask

    task automatic send_scene(
        input logic [31:0] sequence_id,
        input logic [31:0] generation
    );
        begin
            scene_payload[1][63:32] = sequence_id;
            scene_payload[2][31:0] = 32'd2;
            scene_payload[4][31:0] = generation;
            scene_payload[8] = {32'h000A0000, 32'h00000303};
            scene_payload[9] = {32'h00020003, 32'h0001FFFF};
            scene_payload[10] = 64'd0;
            scene_payload[11] = 64'd0;
            scene_payload[12] = {32'd0, 32'h000000FF};
            scene_payload[13] = 64'd0;
            scene_payload[14] = 64'd0;
            scene_payload[15] = 64'd0;
            for (int beat = 0; beat < 520; beat = beat + 1) begin
                send_beat(scene_payload[beat], beat == 519);
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

        send_scene(32'hC4050001, 32'h00000011);
        wait (accepted_packet_count == 1);
        repeat (100) @(posedge clk);
        if (render_completed_count != 0) begin
            $fatal(1, "scene rendered before matching palette generation");
        end

        send_palette(3, 32'h00000011);
        wait (palette_generation == 32'h00000011);
        wait (render_completed_count == 1);
        if (
            render_completed_seq != 32'hC4050001 || render_write_count != 3 ||
            render_trace_crc32 != 32'h173E26EB
        ) begin
            $fatal(1, "first runtime-palette render mismatch");
        end
        wait (present_completed_count == 1);

        send_scene(32'hC4050002, 32'h00000022);
        wait (accepted_packet_count == 2);
        repeat (100) @(posedge clk);
        if (render_completed_count != 1) begin
            $fatal(1, "second scene rendered before palette update");
        end
        send_palette(12, 32'h00000022);
        wait (palette_generation == 32'h00000022);
        wait (render_completed_count == 2);
        wait (present_completed_count == 2);

        send_beat({32'd0, 32'h41443253}, 1'b1);
        finish_packet();
        wait (unsupported_packet_count == 1);
        send_beat({32'd0, 32'hDEADBEEF}, 1'b1);
        finish_packet();
        wait (router_dropped_packet_count == 1);

        if (
            palette_accepted_packet_count != 2 || palette_rejected_packet_count != 0 ||
            palette_error_flags != 0 || palette_status[0] != 1'b1
        ) begin
            $fatal(1, "palette integration status mismatch");
        end
        $display(
            "SCENE2D_C4M5_CORE=PASS renders=%0d presents=%0d palettes=%0d generation=%08x",
            render_completed_count,
            present_completed_count,
            palette_accepted_packet_count,
            palette_generation
        );
        $finish;
    end

endmodule