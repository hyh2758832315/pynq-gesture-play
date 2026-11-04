module tb_scene2d_c4m7_core #(
    parameter bit TILE_DESCRIPTOR_CACHE_ENABLE = 1'b0,
    parameter bit BLIT_PIXEL_PIPELINE_ENABLE = 1'b0,
    parameter bit TEST_BLIT_SCENES = 1'b0,
    parameter bit TILE_PIXEL_PIPELINE_ENABLE = 1'b0,
    parameter bit TEST_TILE_PIPELINE_SCENES = 1'b0,
    parameter bit TILE_PIXEL_PAIR_ENABLE = 1'b0,
    parameter bit TEST_TILE_PAIR_SCENES = 1'b0,
    parameter bit BLIT_PIXEL_PAIR_ENABLE = 1'b0,
    parameter bit CLEAR_FILL_PIXEL_PAIR_ENABLE = 1'b0,
    parameter bit TEST_RASTER_PAIR_SCENES = 1'b0,
    parameter bit UPLOAD_RENDER_OVERLAP_ENABLE = 1'b0,
    parameter bit TEST_UPLOAD_OVERLAP = 1'b0
);

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
    logic [31:0] render_completed_count;
    logic [31:0] render_write_count;
    logic [31:0] render_trace_crc32;
    logic [31:0] render_cycles;
    logic [31:0] render_status;
    logic [31:0] present_completed_count;
    logic [31:0] palette_generation;
    logic [31:0] asset_generation;
    logic [31:0] tilemap_generation;
    logic [31:0] tilemap_rejected_packet_count;
    logic overlap_release_toggle = 1'b0;
    logic [31:0] overlap_status;
    integer overlap_beats = 0;
    logic [63:0] scene_payload [0:519];
    logic [23:0] expected_writes [0:57999];
    logic [7:0] expected_framebuffer [0:115199];
    logic [15:0] previous_read_address;
    logic previous_read_bank;
    logic [15:0] sampled_read_address;
    logic sampled_read_bank;
    logic read_started = 1'b0;
    integer nonzero_readbacks = 0;
    integer last_byte_readbacks = 0;
    integer observed_second_count = 0;
    logic pair_scenes_active = 1'b0;
    logic pair_mask_scene = 1'b0;
    logic [15:0] observed_address;
    logic [7:0] observed_token;
    integer expected_write_count = 12;
    logic [31:0] current_asset_generation = 32'h001234EF;
    logic [31:0] current_tilemap_generation = 32'h00123456;
    logic tile_scenes_active = 1'b0;
    logic tile_error_scene = 1'b0;
    integer observed_write_count = 0;
    integer total_cycles = 0;

    always #5ns clk = ~clk;
    always #7ns pixel_clk = ~pixel_clk;

    scene2d_c4m7_core #(
        .H_ACTIVE(TEST_RASTER_PAIR_SCENES || TEST_UPLOAD_OVERLAP ? 320 : TEST_TILE_PAIR_SCENES ? 32 : 16), .H_FRONT(2), .H_SYNC(2), .H_BACK(2),
        .V_ACTIVE(TEST_RASTER_PAIR_SCENES || TEST_UPLOAD_OVERLAP ? 180 : TEST_TILE_PAIR_SCENES ? 16 : 8), .V_FRONT(1), .V_SYNC(1), .V_BACK(2),
        .OUTPUT_SCALE(1), .TILE_DESCRIPTOR_CACHE_ENABLE(TILE_DESCRIPTOR_CACHE_ENABLE),
        .BLIT_PIXEL_PIPELINE_ENABLE(BLIT_PIXEL_PIPELINE_ENABLE),
        .TILE_PIXEL_PIPELINE_ENABLE(TILE_PIXEL_PIPELINE_ENABLE),
        .TILE_PIXEL_PAIR_ENABLE(TILE_PIXEL_PAIR_ENABLE),
        .BLIT_PIXEL_PAIR_ENABLE(BLIT_PIXEL_PAIR_ENABLE),
        .CLEAR_FILL_PIXEL_PAIR_ENABLE(CLEAR_FILL_PIXEL_PAIR_ENABLE),
        .UPLOAD_RENDER_OVERLAP_ENABLE(UPLOAD_RENDER_OVERLAP_ENABLE)
    ) dut (
        .aclk(clk), .aresetn(resetn), .clk_pixel(pixel_clk), .resetn_pixel(pixel_resetn),
        .s_axis_tdata(tdata), .s_axis_tkeep(tkeep), .s_axis_tlast(tlast),
        .s_axis_tvalid(tvalid), .s_axis_tready(tready),
        .debug_command_read_address(9'd0), .render_completed_count, .render_write_count,
        .render_trace_crc32, .render_cycles, .render_status, .present_completed_count,
        .palette_generation, .asset_generation, .tilemap_generation, .tilemap_rejected_packet_count,
        .overlap_release_toggle, .overlap_status
    );

    always @(posedge clk) begin
        if (dut.core.renderer_busy && dut.core.upload_axis_valid && dut.core.upload_axis_ready)
            overlap_beats++;
        for (int lane = 0; lane < 2; lane++) begin
        if (lane == 0 ? dut.core.renderer.write_valid : dut.core.renderer.write_second_valid) begin
        observed_address = dut.core.renderer.write_address + 16'(lane);
        observed_token = lane == 0 ? dut.core.renderer.write_token : dut.core.renderer.write_second_token;
        if (lane == 1) observed_second_count++;
        if (observed_write_count >= expected_write_count ||
            {observed_token, observed_address} !== expected_writes[observed_write_count])
            $fatal(1, "C4M7 ordered write mismatch at %0d", observed_write_count);
        expected_framebuffer[int'(dut.core.write_bank) * 57600 + observed_address] = observed_token;
        observed_write_count = observed_write_count + 1;
        end
        end
    end

    always @(posedge pixel_clk) begin
        if (pixel_resetn) begin
            sampled_read_address = dut.core.framebuffer_read_address;
            sampled_read_bank = dut.core.display_bank;
            #1ps;
            if (read_started && previous_read_bank == sampled_read_bank) begin
                if (dut.core.framebuffer_read_token !==
                    expected_framebuffer[int'(previous_read_bank) * 57600 + previous_read_address])
                    $fatal(1, "C4M7 framebuffer readback bank=%0d address=%0d actual=%02x expected=%02x",
                        previous_read_bank, previous_read_address, dut.core.framebuffer_read_token,
                        expected_framebuffer[int'(previous_read_bank) * 57600 + previous_read_address]);
                if (dut.core.framebuffer_read_token != 0) nonzero_readbacks++;
                if (previous_read_address == 57599) last_byte_readbacks++;
            end
            previous_read_address = sampled_read_address;
            previous_read_bank = sampled_read_bank;
            read_started = 1;
        end else read_started = 0;
    end

    function automatic logic [31:0] crc32_word(
        input logic [31:0] crc, input logic [31:0] word, input integer bytes
    );
        logic [31:0] next_crc;
        begin
            next_crc = crc;
            for (int byte_index = 0; byte_index < bytes; byte_index = byte_index + 1) begin
                next_crc = next_crc ^ word[byte_index * 8 +: 8];
                for (int bit_index = 0; bit_index < 8; bit_index = bit_index + 1)
                    next_crc = next_crc[0] ? (next_crc >> 1) ^ 32'hEDB88320 : next_crc >> 1;
            end
            return next_crc;
        end
    endfunction

    function automatic logic [31:0] asset_word(input integer index);
        if (pair_scenes_active) begin
            case (index)
                5: return 32'h00100010;
                6: return {current_asset_generation[7:0], 8'h01, 16'd8};
                7: return 32'd128;
                8: return 32'd256;
                76: return 32'h00000009;
                default: if (index >= 28 && index < 60)
                    return pair_mask_scene ? 32'hA303A000 : 32'hA3A3A3A3;
            endcase
        end
        case (index)
            0: return 32'd0;
            1: return 32'h00020004;
            2: return {current_asset_generation[7:0], 8'h01, 16'd2};
            3: return 32'd4;
            4: return 32'd64;
            5: return tile_error_scene ? 32'h00030004 : tile_scenes_active ? 32'h00020004 : TEST_BLIT_SCENES ? 32'h00030005 : 32'h00010002;
            6: return {current_asset_generation[7:0], 8'h01, tile_scenes_active ? 16'd2 : TEST_BLIT_SCENES ? 16'd3 : 16'd1};
            7: return tile_error_scene ? 32'd6 : tile_scenes_active ? 32'd4 : TEST_BLIT_SCENES ? 32'd9 : 32'd1;
            8: return 32'd128;
            9: return 32'h00010001;
            10: return {current_asset_generation[7:0], 8'h01, 16'd1};
            11: return 32'd1;
            12: return 32'h07436521 ^ (current_asset_generation[0] ? 32'd0 : 32'h00001000);
            28: return tile_scenes_active ? (current_asset_generation[0] ? 32'h87654321 : 32'h43218765) :
                TEST_BLIT_SCENES ? 32'h06054321 : 32'h00000087;
            29: return TEST_BLIT_SCENES ? 32'h22110987 : 32'd0;
            30: return TEST_BLIT_SCENES ? 32'h00000003 : 32'd0;
            44: return current_asset_generation[0] ? 32'h00000009 : 32'h0000000A;
            default: return '0;
        endcase
    endfunction

    function automatic logic [31:0] tilemap_word(input integer index);
        if (pair_scenes_active) begin
            case (index)
                0: return 32'h00010002;
                1, 2: return 0;
                3: return 16;
                4, 5: return pair_mask_scene ? 32'h00350000 : 32'h00050000;
                default: return 0;
            endcase
        end
        if (tile_error_scene && index >= 4 && index <= 7)
            return 32'h00020000 | 32'(index - 4);
        if (tile_scenes_active) begin
            case (index)
                0: return 32'h00020002;
                1: return 32'd0;
                2: return 32'd0;
                3: return 32'd2;
                4, 5, 6, 7: return 32'(((index - 4) % 2) |
                    (((index + int'(current_tilemap_generation[0])) % 4 + 1) << 16) |
                    (((index + int'(current_tilemap_generation[0])) % 4) << 20));
                default: return '0;
            endcase
        end
        case (index)
            0: return 32'h00010002;
            1: return 32'hFFFFFFFF;
            2: return 32'd0;
            3: return 32'd2;
            4: return 32'h00030000;
            5: return 32'h00140001;
            default: return '0;
        endcase
    endfunction

    function automatic logic [31:0] palette_word(input integer index);
        return {8'h00, 8'(index), 8'(index ^ 8'h5A), 8'(index * 3)};
    endfunction

    task automatic send_beat(input logic [63:0] data, input logic [7:0] keep, input logic last);
        begin
            @(negedge clk);
            tdata = data;
            tkeep = keep;
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

    task automatic send_resource(input integer kind);
        integer words;
        integer bytes;
        logic [31:0] magic;
        logic [31:0] generation;
        logic [31:0] crc;
        logic [31:0] low_word;
        logic [31:0] high_word;
        begin
            words = kind == 0 ? 256 : kind == 1 ? (pair_scenes_active ? 77 : 45) : pair_scenes_active ? 6 : tile_scenes_active ? 8 : 6;
            bytes = kind == 0 ? 1024 : kind == 1 ? (pair_scenes_active ? 305 : 177) : pair_scenes_active ? 24 : tile_scenes_active ? 32 : 24;
            magic = kind == 0 ? 32'h50443253 : kind == 1 ? 32'h41443253 : 32'h54443253;
            generation = kind == 0 ? 32'h11 : kind == 1 ? current_asset_generation : current_tilemap_generation;
            crc = 32'hFFFFFFFF;
            for (int index = 0; index < words; index = index + 1) begin
                low_word = kind == 0 ? palette_word(index) : kind == 1 ? asset_word(index) : tilemap_word(index);
                crc = crc32_word(crc, low_word, kind == 1 && index == words - 1 ? 1 : 4);
            end
            send_beat({32'h00010000, magic}, 8'hFF, 1'b0);
            send_beat({32'd0, kind == 0 ? 32'd3 : kind == 1 ? 32'd1 : 32'd2}, 8'hFF, 1'b0);
            send_beat({32'(bytes), generation}, 8'hFF, 1'b0);
            send_beat({32'd0, ~crc}, 8'hFF, 1'b0);
            for (int beat = 4; beat < 8; beat = beat + 1) send_beat(64'd0, 8'hFF, 1'b0);
            for (int index = 0; index < words; index = index + 2) begin
                low_word = kind == 0 ? palette_word(index) : kind == 1 ? asset_word(index) : tilemap_word(index);
                high_word = kind == 0 ? palette_word(index + 1) : kind == 1 ? asset_word(index + 1) : tilemap_word(index + 1);
                send_beat({high_word, low_word}, kind == 1 && index == words - 1 ? 8'h01 : 8'hFF, index + 2 >= words);
            end
            finish_packet();
        end
    endtask

    task automatic release_completed;
        if (UPLOAD_RENDER_OVERLAP_ENABLE) begin
            wait (overlap_status[3] && overlap_status[4]);
            @(negedge clk);
            overlap_release_toggle = !overlap_release_toggle;
            wait (overlap_status[5] == overlap_release_toggle);
        end
    endtask

    task automatic run_overlap_scenes;
        logic [31:0] clear_crc, fill_crc;
        int completed_base, present_base, overlap_base;
        completed_base = int'(render_completed_count);
        present_base = int'(present_completed_count);
        overlap_base = overlap_beats;
        expected_write_count = 57602;
        observed_write_count = 0;
        clear_crc = 32'hFFFFFFFF;
        for (int address_value = 0; address_value < 57600; address_value++) begin
            expected_writes[address_value] = {8'h55, 16'(address_value)};
            clear_crc = crc32_word(clear_crc, {8'd0, expected_writes[address_value]}, 4);
        end
        clear_crc = ~clear_crc;
        expected_writes[57600] = {8'h66, 16'd0};
        expected_writes[57601] = {8'h66, 16'd1};
        fill_crc = crc32_word(32'hFFFFFFFF, {8'd0, expected_writes[57600]}, 4);
        fill_crc = ~crc32_word(fill_crc, {8'd0, expected_writes[57601]}, 4);
        for (int frame_index = 0; frame_index < 2; frame_index++) begin
            for (int beat = 0; beat < 520; beat++) scene_payload[beat] = 0;
            scene_payload[0] = {32'h00010000, 32'h47443253};
            scene_payload[1] = {32'hC4070500, 32'hC4070001};
            scene_payload[2] = {32'd0, 32'd2};
            scene_payload[4] = {32'd0, 32'h11};
            scene_payload[5] = {current_tilemap_generation, current_asset_generation};
            set_command(0, frame_index == 0 ? 1 : 4, frame_index == 0 ? 32'h55 : 32'h66,
                0, 0, frame_index == 0 ? 0 : 2, frame_index == 0 ? 0 : 1, 0, 0);
            set_command(1, 32'hFF, 0, 0, 0, 0, 0, 0, 0);
            for (int beat = 0; beat < 520; beat++) send_beat(scene_payload[beat], 8'hFF, beat == 519);
            finish_packet();
            if (frame_index == 0 && !UPLOAD_RENDER_OVERLAP_ENABLE) begin
                wait (render_completed_count == completed_base + 1);
                wait (present_completed_count == present_base + 1);
                if (render_trace_crc32 != clear_crc || render_write_count != 57600)
                    $fatal(1, "serial CLEAR completion mismatch");
            end
        end
        if (UPLOAD_RENDER_OVERLAP_ENABLE) begin
            wait (dut.accepted_packet_count == completed_base + 2);
            if (overlap_beats - overlap_base != 520 || render_completed_count != completed_base)
                $fatal(1, "next Scene upload did not overlap long render beats=%0d completed=%0d base=%0d",
                    overlap_beats - overlap_base, render_completed_count, completed_base);
            wait (render_completed_count == completed_base + 1);
            wait (present_completed_count == present_base + 1);
            repeat (20) @(posedge clk);
            if (render_trace_crc32 != clear_crc || render_write_count != 57600 ||
                render_completed_count != completed_base + 1 || !overlap_status[1])
                $fatal(1, "held completion was overwritten by READY frame");
            release_completed();
        end
        wait (render_completed_count == completed_base + 2);
        wait (present_completed_count == present_base + 2);
        if (render_trace_crc32 != fill_crc || render_write_count != 2 ||
            observed_write_count != expected_write_count || render_status[11:4] != 0)
            $fatal(1, "queued FILL completion mismatch");
        release_completed();
        repeat (2) @(posedge dut.core.frame_start);
        $display("SCENE2D_UPLOAD_OVERLAP=PASS overlap=%0d beats=%0d writes=%0d clear_crc=%08x fill_crc=%08x",
            UPLOAD_RENDER_OVERLAP_ENABLE, overlap_beats - overlap_base,
            observed_write_count, clear_crc, fill_crc);
    endtask

    task automatic run_overlap_boundaries;
        int render_base, present_base, accepted_base, rejected_base, resource_base;
        logic saved_bank;
        render_base = int'(render_completed_count);
        present_base = int'(present_completed_count);
        accepted_base = int'(dut.accepted_packet_count);
        expected_write_count = 57604;
        observed_write_count = 0;
        for (int address_value = 0; address_value < 57600; address_value++)
            expected_writes[address_value] = {8'h77, 16'(address_value)};
        for (int tail_index = 0; tail_index < 4; tail_index++)
            expected_writes[57600 + tail_index] = {8'h88, 16'(tail_index % 2)};
        for (int frame_index = 0; frame_index < 2; frame_index++) begin
            set_command(0, frame_index == 0 ? 1 : 4, frame_index == 0 ? 32'h77 : 32'h88,
                0, 0, frame_index == 0 ? 0 : 2, frame_index == 0 ? 0 : 1, 0, 0);
            for (int beat = 0; beat < 520; beat++) send_beat(scene_payload[beat], 8'hFF, beat == 519);
            finish_packet();
        end
        wait (dut.accepted_packet_count == accepted_base + 2);
        @(negedge clk);
        overlap_release_toggle = !overlap_release_toggle;
        wait (overlap_status[5] == overlap_release_toggle);
        fork
            begin
                for (int beat = 0; beat < 520; beat++) send_beat(scene_payload[beat], 8'hFF, beat == 519);
                finish_packet();
            end
            begin
                repeat (20) @(negedge clk);
                if (dut.scene_tready || dut.accepted_packet_count != accepted_base + 2 ||
                    !overlap_status[1] || overlap_status[0])
                    $fatal(1, "full Scene queue did not apply core backpressure");
                wait (render_completed_count == render_base + 1);
                wait (present_completed_count == present_base + 1);
                repeat (20) @(negedge clk);
                if (!overlap_status[3] || render_completed_count != render_base + 1)
                    $fatal(1, "early or repeated release freed a future completion");
                release_completed();
                wait (render_completed_count == render_base + 2);
                wait (present_completed_count == present_base + 2);
                release_completed();
            end
        join
        wait (render_completed_count == render_base + 3);
        wait (present_completed_count == present_base + 3);
        if (observed_write_count != expected_write_count || render_status[11:4] != 0)
            $fatal(1, "three Scene queue write trace mismatch");
        resource_base = int'(dut.asset_accepted_packet_count);
        fork
            send_resource(1);
            begin
                repeat (20) @(negedge clk);
                if (dut.routed_tready[1] || dut.asset_accepted_packet_count != resource_base ||
                    overlap_status[6])
                    $fatal(1, "resource upload crossed unreleased completion fence");
                release_completed();
            end
        join
        wait (dut.asset_accepted_packet_count == resource_base + 1);
        wait (dut.resource_upload_idle && !dut.resource_packet_active && !dut.asset_commit_pending);
        saved_bank = dut.core.command_active_bank;
        rejected_base = int'(dut.rejected_packet_count);
        for (int resource_index = 0; resource_index < 3; resource_index++) begin
            scene_payload[4] = {32'd0, 32'h11};
            scene_payload[5] = {current_tilemap_generation, current_asset_generation};
            case (resource_index)
                0: scene_payload[4][31:0] = 32'h12;
                1: scene_payload[5][31:0] = current_asset_generation + 1;
                2: scene_payload[5][63:32] = current_tilemap_generation + 1;
            endcase
            for (int beat = 0; beat < 520; beat++) send_beat(scene_payload[beat], 8'hFF, beat == 519);
            finish_packet();
            wait (dut.rejected_packet_count == rejected_base + resource_index + 1);
            if (!overlap_status[7] || dut.core.command_active_bank != saved_bank ||
                dut.accepted_packet_count != accepted_base + 3 ||
                render_completed_count != render_base + 3 || !overlap_status[0])
                $fatal(1, "generation mismatch corrupted ownership or credit");
        end
        repeat (2) @(posedge dut.core.frame_start);
        if (last_byte_readbacks == 0) $fatal(1, "overlap full framebuffer last byte was not scanned");
        for (int beat = 0; beat < 10; beat++) send_beat(scene_payload[beat], 8'hFF, 1'b0);
        finish_packet();
        repeat (4) @(negedge clk);
        resetn = 0;
        pixel_resetn = 0;
        repeat (4) @(negedge clk);
        resetn = 1;
        pixel_resetn = 1;
        repeat (20) @(negedge clk);
        if (dut.accepted_packet_count != 0 || render_completed_count != 0 ||
            present_completed_count != 0 || overlap_status[7:1] != 7'b0100000 || !overlap_status[0])
            $fatal(1, "partial Scene reset left queued ownership");
        $display("SCENE2D_UPLOAD_BOUNDARIES=PASS full_queue=1 early_release=1 resource_fence=1 generation_rejects=3 partial_reset=1 last_byte=%0d", last_byte_readbacks);
    endtask

    function automatic logic [3:0] model_pixel(input int slot, input int column, input int row_index);
        int base, stride, offset;
        logic [31:0] word;
        base = slot == 0 ? 0 : slot == 1 ? 64 : pair_scenes_active ? 256 : 128;
        stride = slot == 0 ? 2 : slot == 1 ? (pair_scenes_active ? 8 : tile_scenes_active ? 2 : 3) : 1;
        offset = base + row_index * stride + column / 2;
        word = asset_word(12 + offset / 4);
        return 4'(word >> ((offset % 4) * 8 + (column % 2) * 4));
    endfunction

    task automatic append_pixel(input int target_x, input int target_y, input int bank, input logic [3:0] pixel_index);
        if (pixel_index != 0 && target_x >= 0 && target_x < 320 && target_y >= 0 && target_y < 180) begin
            if (expected_write_count >= 58000) $fatal(1, "core oracle capacity exceeded");
            expected_writes[expected_write_count] = {4'(bank), pixel_index, 16'(target_y * 320 + target_x)};
            expected_write_count++;
        end
    endtask

    task automatic append_blit(input int slot, input int bank, input int target_x, input int target_y,
        input int columns, input int rows, input int source_x, input int source_y, input bit flip_x, input bit flip_y);
        for (int row_index = 0; row_index < rows; row_index++) begin
            for (int column = 0; column < columns; column++) begin
                append_pixel(target_x + column, target_y + row_index, bank,
                    model_pixel(slot, source_x + (flip_x ? columns - 1 - column : column),
                        source_y + (flip_y ? rows - 1 - row_index : row_index)));
            end
        end
    endtask

    task automatic append_tile;
        int tile_id, source_x, source_y;
        logic [31:0] descriptor;
        for (int row_index = 0; row_index < 2; row_index++) begin
            for (int column = 0; column < 4; column++) begin
                descriptor = tilemap_word(4 + column / 2);
                tile_id = int'(descriptor[15:0]);
                source_x = (tile_id % 2) * 2 + (descriptor[20] ? 1 - column % 2 : column % 2);
                source_y = (tile_id / 2) * 2 + (descriptor[21] ? 1 - row_index : row_index);
                append_pixel(column - 1, row_index, int'(descriptor[19:16]), model_pixel(0, source_x, source_y));
            end
        end
    endtask

    task automatic set_command(input int command_index, input logic [31:0] opcode,
        input logic [31:0] identity, input int target_x, input int target_y,
        input int columns, input int rows, input int source_x, input int source_y);
        int beat;
        beat = 8 + command_index * 4;
        scene_payload[beat] = {identity, opcode};
        scene_payload[beat + 1] = {16'(rows), 16'(columns), 16'(target_y), 16'(target_x)};
        scene_payload[beat + 2] = {32'd0, 16'(source_y), 16'(source_x)};
    endtask

    task automatic run_blit_scenes;
        logic [31:0] expected_crc;
        bit mixed;
        int commands;
        for (int extra_frame = 0; extra_frame < 4; extra_frame++) begin
            mixed = extra_frame >= 2;
            commands = mixed ? 4 : 3;
            current_asset_generation = 32'h001234F0 + extra_frame;
            send_resource(1);
            wait (asset_generation == current_asset_generation);
            for (int beat = 0; beat < 520; beat++) scene_payload[beat] = '0;
            scene_payload[0] = {32'h00010000, 32'h47443253};
            scene_payload[1] = {32'(32'hC4070003 + extra_frame), 32'hC4070001};
            scene_payload[2] = {32'd0, 32'(commands)};
            scene_payload[4] = {32'd0, 32'h11};
            scene_payload[5] = {32'h00123456, current_asset_generation};
            expected_write_count = 0;
            if (mixed) begin
                set_command(0, 32'd3, 32'h00070002, 8, 4, 1, 1, 0, 0);
                append_blit(2, 7, 8, 4, 1, 1, 0, 0, 0, 0);
                scene_payload[12] = {32'd0, 32'd2};
                scene_payload[13] = {32'd0, 32'hFFFFFFFF};
                scene_payload[14] = {32'd2, 32'h00010002};
                append_tile();
            end else begin
                set_command(0, 32'd3, 32'h00030000, -1, 0, 3, 2, 1, 0);
                append_blit(0, 3, -1, 0, 3, 2, 1, 0, 0, 0);
            end
            set_command(mixed ? 2 : 1, 32'h00000303, 32'h00040001, 4, 2, 3, 3, 1, 0);
            append_blit(1, 4, 4, 2, 3, 3, 1, 0, 1, 1);
            set_command(commands - 1, 32'hFF, 32'd0, 0, 0, 0, 0, 0, 0);
            expected_crc = 32'hFFFFFFFF;
            for (int write_index = 0; write_index < expected_write_count; write_index++)
                expected_crc = crc32_word(expected_crc, {8'd0, expected_writes[write_index]}, 4);
            expected_crc = ~expected_crc;
            observed_write_count = 0;
            for (int beat = 0; beat < 520; beat++) send_beat(scene_payload[beat], 8'hFF, beat == 519);
            finish_packet();
            wait (render_completed_count == extra_frame + 3);
            wait (present_completed_count == extra_frame + 3);
            if (observed_write_count != expected_write_count || render_write_count != expected_write_count ||
                render_trace_crc32 !== expected_crc || render_status[11:4] != 0 || tilemap_rejected_packet_count != 0)
                $fatal(1, "C4M7 BLIT mismatch frame=%0d observed=%0d expected=%0d rendered=%0d crc=%08x expected_crc=%08x status=%08x tilemap_rejected=%0d",
                    extra_frame, observed_write_count, expected_write_count, render_write_count,
                    render_trace_crc32, expected_crc, render_status, tilemap_rejected_packet_count);
            $display("C4M7_BLIT_FRAME=PASS mixed=%0d frame=%0d writes=%0d crc=%08x cycles=%0d generation=%08x",
                mixed, extra_frame, render_write_count, render_trace_crc32, render_cycles, asset_generation);
            release_completed();
        end
    endtask

    task automatic append_tile_scene(input int slot, input int target_x, input int target_y, input int rows = 4);
        int source_x, source_y;
        logic [31:0] descriptor;
        for (int row_index = 0; row_index < rows; row_index++) begin
            for (int column = 0; column < 4; column++) begin
                descriptor = tilemap_word(4 + (row_index / 2) * 2 + column / 2);
                source_x = (int'(descriptor[15:0]) % 2) * 2 + (descriptor[20] ? 1 - column % 2 : column % 2);
                source_y = (int'(descriptor[15:0]) / 2) * 2 + (descriptor[21] ? 1 - row_index % 2 : row_index % 2);
                append_pixel(target_x + column, target_y + row_index,
                    int'(descriptor[19:16]), model_pixel(slot, source_x, source_y));
            end
        end
    endtask

    task automatic set_tile_command(input int command_index, input int slot, input int target_x, input int target_y);
        int beat;
        beat = 8 + command_index * 4;
        scene_payload[beat] = {32'(slot), 32'd2};
        scene_payload[beat + 1] = {32'(target_y), 32'(target_x)};
        scene_payload[beat + 2] = {32'd2, 32'h00020002};
    endtask

    task automatic run_tile_scenes;
        logic [31:0] expected_crc;
        int completed_base;
        completed_base = int'(render_completed_count);
        tile_scenes_active = 1;
        for (int tile_frame = 0; tile_frame < 4; tile_frame++) begin
            current_asset_generation = 32'h001234F4 + tile_frame;
            current_tilemap_generation = 32'h00123460 + tile_frame;
            send_resource(1); wait (asset_generation == current_asset_generation);
            send_resource(2); wait (tilemap_generation == current_tilemap_generation);
            for (int beat = 0; beat < 520; beat++) scene_payload[beat] = 0;
            scene_payload[0] = {32'h00010000, 32'h47443253};
            scene_payload[1] = {32'(32'hC4070100 + tile_frame), 32'hC4070001};
            scene_payload[2] = {32'd0, 32'd4};
            scene_payload[4] = {32'd0, 32'h11};
            scene_payload[5] = {current_tilemap_generation, current_asset_generation};
            expected_write_count = 0;
            set_tile_command(0, 0, -1, 0); append_tile_scene(0, -1, 0);
            set_command(1, 32'd3, 32'h00070002, 8, 4, 1, 1, 0, 0);
            append_blit(2, 7, 8, 4, 1, 1, 0, 0, 0, 0);
            set_tile_command(2, 1, 4, 2); append_tile_scene(1, 4, 2);
            set_command(3, 32'hFF, 0, 0, 0, 0, 0, 0, 0);
            expected_crc = 32'hFFFFFFFF;
            for (int write_index = 0; write_index < expected_write_count; write_index++)
                expected_crc = crc32_word(expected_crc, {8'd0, expected_writes[write_index]}, 4);
            expected_crc = ~expected_crc;
            observed_write_count = 0;
            for (int beat = 0; beat < 520; beat++) send_beat(scene_payload[beat], 8'hFF, beat == 519);
            finish_packet();
            wait (render_completed_count == completed_base + tile_frame + 1);
            wait (present_completed_count == completed_base + tile_frame + 1);
            if (observed_write_count != expected_write_count || render_write_count != expected_write_count ||
                render_trace_crc32 !== expected_crc || render_status[11:4] != 0 || tilemap_rejected_packet_count != 0)
                $fatal(1, "Tile core frame %0d count/CRC/status mismatch", tile_frame);
            $display("C4M7_TILE_FRAME=PASS frame=%0d writes=%0d crc=%08x cycles=%0d asset=%08x tilemap=%08x",
                tile_frame, render_write_count, render_trace_crc32, render_cycles, asset_generation, tilemap_generation);
            release_completed();
        end
        tile_error_scene = 1;
        current_asset_generation = 32'h001234F8;
        current_tilemap_generation = 32'h00123470;
        send_resource(1); wait (asset_generation == current_asset_generation);
        send_resource(2); wait (tilemap_generation == current_tilemap_generation);
        for (int beat = 0; beat < 520; beat++) scene_payload[beat] = 0;
        scene_payload[0] = {32'h00010000, 32'h47443253};
        scene_payload[1] = {32'hC4070200, 32'hC4070001};
        scene_payload[2] = {32'd0, 32'd3};
        scene_payload[4] = {32'd0, 32'h11};
        scene_payload[5] = {current_tilemap_generation, current_asset_generation};
        expected_write_count = 0;
        set_tile_command(0, 1, 0, 0); append_tile_scene(1, 0, 0, 3);
        set_command(1, 32'd3, 32'h00070002, 100, 20, 1, 1, 0, 0);
        set_command(2, 32'hFF, 0, 0, 0, 0, 0, 0, 0);
        expected_crc = 32'hFFFFFFFF;
        for (int write_index = 0; write_index < expected_write_count; write_index++)
            expected_crc = crc32_word(expected_crc, {8'd0, expected_writes[write_index]}, 4);
        expected_crc = ~expected_crc;
        observed_write_count = 0;
        for (int beat = 0; beat < 520; beat++) send_beat(scene_payload[beat], 8'hFF, beat == 519);
        finish_packet();
        wait (render_completed_count == completed_base + 5);
        repeat (4) @(negedge clk);
        if (expected_write_count != 11 || observed_write_count != expected_write_count ||
            render_write_count != expected_write_count || render_trace_crc32 !== expected_crc ||
            render_status[7:4] != 4'b0010 || tilemap_rejected_packet_count != 0)
            $fatal(1, "Tile core error prefix count/CRC/status mismatch");
        $display("SCENE2D_C4M7_TILE_ERROR=PASS pipeline=%0d writes=%0d crc=%08x", TILE_PIXEL_PIPELINE_ENABLE,
            render_write_count, render_trace_crc32);
        if (UPLOAD_RENDER_OVERLAP_ENABLE) begin
            wait (present_completed_count == completed_base + 5);
            release_completed();
        end
        $display("SCENE2D_C4M7_TILE_PIPELINE=PASS pipeline=%0d frames=4", TILE_PIXEL_PIPELINE_ENABLE);
    endtask

    initial begin
        #(TEST_RASTER_PAIR_SCENES || TEST_UPLOAD_OVERLAP ? 25ms : 2ms);
        $fatal(1, "C4M7 watchdog expired pair_active=%b asset=%08x wanted=%08x asset_rejected=%0d asset_errors=%x tilemap=%08x wanted=%08x tile_rejected=%0d tile_errors=%x render=%0d present=%0d status=%08x",
            pair_scenes_active, asset_generation, current_asset_generation,
            dut.asset_rejected_packet_count, dut.asset_error_flags,
            tilemap_generation, current_tilemap_generation, tilemap_rejected_packet_count,
            dut.tilemap_error_flags, render_completed_count, present_completed_count, render_status);
    end

    task automatic run_pair_scenes;
        logic [31:0] expected_crc;
        integer completed_base;
        completed_base = int'(render_completed_count);
        tile_error_scene = 0;
        pair_scenes_active = 1;
        for (int pair_frame = 0; pair_frame < 2; pair_frame++) begin
            pair_mask_scene = pair_frame == 1;
            current_asset_generation = 32'h00123500 + pair_frame;
            current_tilemap_generation = 32'h00123510 + pair_frame;
            send_resource(1); wait (asset_generation == current_asset_generation);
            send_resource(2); wait (tilemap_generation == current_tilemap_generation);
            for (int beat = 0; beat < 520; beat++) scene_payload[beat] = 0;
            scene_payload[0] = {32'h00010000, 32'h47443253};
            scene_payload[1] = {32'(32'hC4070300 + pair_frame), 32'hC4070001};
            scene_payload[2] = {32'd0, 32'd3};
            scene_payload[4] = {32'd0, 32'h11};
            scene_payload[5] = {current_tilemap_generation, current_asset_generation};
            scene_payload[8] = {32'd1, 32'd2};
            scene_payload[9] = 0;
            scene_payload[10] = {32'd16, 32'h00010002};
            expected_write_count = 0;
            for (int row_index = 0; row_index < 16; row_index++)
                for (int column = 0; column < 32; column++)
                    append_pixel(column, row_index, 5, model_pixel(1,
                        pair_mask_scene ? 15 - column % 16 : column % 16,
                        pair_mask_scene ? 15 - row_index : row_index));
            set_command(1, 3, 32'h00070002, 1, 1, 1, 1, 0, 0);
            append_blit(2, 7, 1, 1, 1, 1, 0, 0, 0, 0);
            set_command(2, 32'hFF, 0, 0, 0, 0, 0, 0, 0);
            expected_crc = 32'hFFFFFFFF;
            for (int write_index = 0; write_index < expected_write_count; write_index++)
                expected_crc = crc32_word(expected_crc, {8'd0, expected_writes[write_index]}, 4);
            expected_crc = ~expected_crc;
            observed_write_count = 0;
            for (int beat = 0; beat < 520; beat++) send_beat(scene_payload[beat], 8'hFF, beat == 519);
            finish_packet();
            wait (render_completed_count == completed_base + pair_frame + 1);
            wait (present_completed_count == completed_base + pair_frame + 1);
            if (observed_write_count != expected_write_count || render_write_count != expected_write_count ||
                render_trace_crc32 !== expected_crc || render_status[7:4] != 0)
                $fatal(1, "core pair frame count/CRC/status mismatch");
            repeat (2) @(posedge dut.core.frame_start);
            if (nonzero_readbacks == 0) $fatal(1, "core pair real readback not exercised");
            $display("C4M7_PAIR_FRAME=PASS pair=%0d mask=%0d writes=%0d crc=%08x cycles=%0d readbacks=%0d",
                TILE_PIXEL_PAIR_ENABLE, pair_mask_scene, render_write_count, render_trace_crc32,
                render_cycles, nonzero_readbacks);
            release_completed();
        end
        $display("SCENE2D_C4M7_TILE_PAIR=PASS pair=%0d frames=2", TILE_PIXEL_PAIR_ENABLE);
    endtask

    task automatic run_raster_scenes;
        logic [31:0] expected_crc;
        int completed_base, readback_base;
        completed_base = int'(render_completed_count);
        tile_error_scene = 0;
        pair_scenes_active = 1;
        for (int raster_frame = 0; raster_frame < 3; raster_frame++) begin
            pair_mask_scene = raster_frame == 2;
            current_asset_generation = 32'h00123600 + raster_frame;
            send_resource(1); wait (asset_generation == current_asset_generation);
            for (int beat = 0; beat < 520; beat++) scene_payload[beat] = 0;
            scene_payload[0] = {32'h00010000, 32'h47443253};
            scene_payload[1] = {32'(32'hC4070400 + raster_frame), 32'hC4070001};
            scene_payload[2] = {32'd0, 32'd5};
            scene_payload[4] = {32'd0, 32'h11};
            scene_payload[5] = {current_tilemap_generation, current_asset_generation};
            expected_write_count = 0;
            set_command(0, 1, 32'h55, 0, 0, 0, 0, 0, 0);
            for (int address_value = 0; address_value < 57600; address_value++) begin
                expected_writes[expected_write_count] = {8'h55, 16'(address_value)};
                expected_write_count++;
            end
            set_command(1, raster_frame == 0 ? 3 : 32'h00000303, 32'h00050001, 0, 0, 16, 16, 0, 0);
            append_blit(1, 5, 0, 0, 16, 16, 0, 0, raster_frame != 0, raster_frame != 0);
            set_command(2, 4, 32'h66, 1, 17, 5, 3, 0, 0);
            for (int row_index = 17; row_index < 20; row_index++)
                for (int column = 1; column < 6; column++) append_pixel(column, row_index, 6, 6);
            set_command(3, 4, 32'h77, 318, 179, 5, 3, 0, 0);
            append_pixel(318, 179, 7, 7); append_pixel(319, 179, 7, 7);
            set_command(4, 32'hFF, 0, 0, 0, 0, 0, 0, 0);
            expected_crc = 32'hFFFFFFFF;
            for (int write_index = 0; write_index < expected_write_count; write_index++)
                expected_crc = crc32_word(expected_crc, {8'd0, expected_writes[write_index]}, 4);
            expected_crc = ~expected_crc;
            observed_write_count = 0; observed_second_count = 0;
            for (int beat = 0; beat < 520; beat++) send_beat(scene_payload[beat], 8'hFF, beat == 519);
            finish_packet();
            wait (render_completed_count == completed_base + raster_frame + 1);
            wait (present_completed_count == completed_base + raster_frame + 1);
            if (observed_write_count != expected_write_count || render_write_count != expected_write_count ||
                render_trace_crc32 !== expected_crc || render_status[11:4] != 0)
                $fatal(1, "raster core count/CRC/status mismatch frame=%0d", raster_frame);
            if (CLEAR_FILL_PIXEL_PAIR_ENABLE && (observed_second_count < 28800 || render_cycles >= 57600))
                $fatal(1, "raster core solid throughput missing");
            readback_base = last_byte_readbacks;
            repeat (2) @(posedge dut.core.frame_start);
            if (last_byte_readbacks <= readback_base) $fatal(1, "last framebuffer byte not read back");
            $display("C4M7_RASTER_FRAME=PASS frame=%0d blit=%0d solid=%0d writes=%0d crc=%08x cycles=%0d second=%0d last_reads=%0d",
                raster_frame, BLIT_PIXEL_PAIR_ENABLE, CLEAR_FILL_PIXEL_PAIR_ENABLE, render_write_count,
                render_trace_crc32, render_cycles, observed_second_count, last_byte_readbacks);
            release_completed();
        end
        $display("SCENE2D_C4M7_RASTER_PAIR=PASS blit=%0d solid=%0d frames=3", BLIT_PIXEL_PAIR_ENABLE, CLEAR_FILL_PIXEL_PAIR_ENABLE);
    endtask

    initial begin
        logic [31:0] expected_crc;
        for (int byte_index = 0; byte_index < 115200; byte_index++) expected_framebuffer[byte_index] = 0;
        expected_writes[0] = {8'h32, 16'd0};
        expected_writes[1] = {8'h46, 16'd1};
        expected_writes[2] = {8'h45, 16'd2};
        expected_writes[3] = {8'h34, 16'd320};
        expected_writes[4] = {8'h47, 16'd322};
        expected_writes[5] = {8'h31, 16'd965};
        expected_writes[6] = {8'h32, 16'd966};
        expected_writes[7] = {8'h46, 16'd967};
        expected_writes[8] = {8'h45, 16'd968};
        expected_writes[9] = {8'h33, 16'd1285};
        expected_writes[10] = {8'h34, 16'd1286};
        expected_writes[11] = {8'h47, 16'd1288};
        expected_crc = 32'hFFFFFFFF;
        for (int index = 0; index < 12; index = index + 1)
            expected_crc = crc32_word(expected_crc, {8'd0, expected_writes[index]}, 4);
        expected_crc = ~expected_crc;
        for (int beat = 0; beat < 520; beat = beat + 1) scene_payload[beat] = '0;
        scene_payload[0] = {32'h00010000, 32'h47443253};
        scene_payload[1] = {32'hC4070001, 32'hC4070001};
        scene_payload[2] = {32'd0, 32'd3};
        scene_payload[4] = {32'd0, 32'h11};
        scene_payload[5] = {32'h00123456, 32'h001234EF};
        scene_payload[8] = {32'd0, 32'd2};
        scene_payload[9] = {32'd0, 32'hFFFFFFFF};
        scene_payload[10] = {32'd2, 32'h00010002};
        scene_payload[12] = {32'd0, 32'd2};
        scene_payload[13] = {32'd3, 32'd5};
        scene_payload[14] = {32'd2, 32'h00010002};
        scene_payload[16] = {32'd0, 32'hFF};
        repeat (5) @(negedge clk);
        resetn = 1'b1;
        repeat (5) @(negedge pixel_clk);
        pixel_resetn = 1'b1;
        send_resource(0);
        wait (palette_generation == 32'h11);
        send_resource(1);
        wait (asset_generation == 32'h001234EF);
        send_resource(2);
        wait (tilemap_generation == 32'h00123456);
        for (int frame = 0; frame < 2; frame = frame + 1) begin
            observed_write_count = 0;
            scene_payload[1][63:32] = 32'hC4070001 + frame;
            for (int beat = 0; beat < 520; beat = beat + 1) send_beat(scene_payload[beat], 8'hFF, beat == 519);
            finish_packet();
            wait (render_completed_count == frame + 1);
            wait (present_completed_count == frame + 1);
            if (observed_write_count != 12 || render_write_count != 12 || render_trace_crc32 !== expected_crc ||
                render_status[11:4] != 0 || tilemap_rejected_packet_count != 0)
                $fatal(1, "C4M7 completion count/CRC/error mismatch");
            if (frame != 0 && render_cycles != total_cycles) $fatal(1, "C4M7 repeated scene cycles changed");
            total_cycles = render_cycles;
            release_completed();
        end
        if (TEST_BLIT_SCENES) begin
            run_blit_scenes();
            $display("SCENE2D_C4M7_BLIT=PASS cache=%0d pipeline=%0d frames=6",
                TILE_DESCRIPTOR_CACHE_ENABLE, BLIT_PIXEL_PIPELINE_ENABLE);
        end else begin
            $display("SCENE2D_C4M7_CORE=PASS cache=%0d frames=2 writes=%0d crc=%08x cycles=%0d",
                TILE_DESCRIPTOR_CACHE_ENABLE, render_write_count, render_trace_crc32, total_cycles);
        end
        if (TEST_TILE_PIPELINE_SCENES) run_tile_scenes();
        if (TEST_TILE_PAIR_SCENES) run_pair_scenes();
        if (TEST_RASTER_PAIR_SCENES) run_raster_scenes();
        if (TEST_UPLOAD_OVERLAP) run_overlap_scenes();
        if (TEST_UPLOAD_OVERLAP && UPLOAD_RENDER_OVERLAP_ENABLE) run_overlap_boundaries();
        $finish;
    end

endmodule