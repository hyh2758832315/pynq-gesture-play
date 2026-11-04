module scene2d_c4m3_core #(
    parameter integer H_ACTIVE = 1280,
    parameter integer H_FRONT = 110,
    parameter integer H_SYNC = 40,
    parameter integer H_BACK = 220,
    parameter integer V_ACTIVE = 720,
    parameter integer V_FRONT = 5,
    parameter integer V_SYNC = 5,
    parameter integer V_BACK = 20,
    parameter integer OUTPUT_SCALE = 4,
    parameter integer ATLAS_ENABLE = 0,
    parameter string ATLAS_INIT_FILE = "none",
    parameter integer RUNTIME_PALETTE_ENABLE = 0,
    parameter integer RUNTIME_ASSET_ENABLE = 0,
    parameter integer RUNTIME_TILEMAP_ENABLE = 0,
    parameter bit TILE_DESCRIPTOR_CACHE_ENABLE = 1'b0,
    parameter bit BLIT_PIXEL_PIPELINE_ENABLE = 1'b0,
    parameter bit TILE_PIXEL_PIPELINE_ENABLE = 1'b0,
    parameter bit TILE_PIXEL_PAIR_ENABLE = 1'b0,
    parameter bit BLIT_PIXEL_PAIR_ENABLE = 1'b0,
    parameter bit CLEAR_FILL_PIXEL_PAIR_ENABLE = 1'b0,
    parameter bit UPLOAD_RENDER_OVERLAP_ENABLE = 1'b0
) (
    input  logic        aclk,
    input  logic        aresetn,
    input  logic        clk_pixel,
    input  logic        resetn_pixel,
    input  logic [63:0] s_axis_tdata,
    input  logic [7:0]  s_axis_tkeep,
    input  logic        s_axis_tlast,
    input  logic        s_axis_tvalid,
    output logic        s_axis_tready,
    input  logic [8:0]  debug_command_read_address,
    output logic [31:0] debug_command_read_data_low,
    output logic [31:0] debug_command_read_data_high,
    output logic [31:0] upload_crc32,
    output logic [31:0] upload_byte_count,
    output logic [31:0] upload_packet_count,
    output logic [31:0] accepted_packet_count,
    output logic [31:0] rejected_packet_count,
    output logic [31:0] accepted_seq,
    output logic [31:0] accepted_status,
    output logic [5:0]  upload_error_flags,
    output logic [31:0] render_completed_seq,
    output logic [31:0] render_completed_count,
    output logic [31:0] render_write_count,
    output logic [31:0] render_trace_crc32,
    output logic [31:0] render_cycles,
    output logic [31:0] render_maximum_cycles,
    output logic [31:0] render_status,
    output logic [31:0] present_completed_seq,
    output logic [31:0] present_completed_count,
    output logic [31:0] framebuffer_status,
    input  logic        overlap_release_toggle,
    output logic [31:0] overlap_status,
    output logic        resource_upload_idle,
    input  logic        runtime_palette_valid,
    input  logic [31:0] runtime_palette_generation,
    output logic [7:0]  runtime_palette_read_address,
    input  logic [23:0] runtime_palette_read_rgb,
    output logic        palette_vblank_start,
    input  logic        runtime_asset_valid,
    input  logic [31:0] runtime_asset_generation,
    input  logic [15:0] runtime_asset_width,
    input  logic [15:0] runtime_asset_height,
    input  logic [15:0] runtime_asset_stride_bytes,
    output logic [1:0]  runtime_asset_id,
    output logic [14:0] runtime_asset_read_address,
    input  logic [7:0]  runtime_asset_read_byte,
    input  logic        runtime_tilemap_valid,
    input  logic [31:0] runtime_tilemap_generation,
    input  logic [15:0] runtime_tilemap_width_tiles,
    input  logic [15:0] runtime_tilemap_height_tiles,
    input  logic [15:0] runtime_tilemap_tile_size,
    output logic [1:0]  runtime_tilemap_id,
    output logic [9:0]  runtime_tilemap_read_word_address,
    input  logic [31:0] runtime_tilemap_read_word_data,
    output logic [23:0] vid_data,
    output logic        vid_de,
    output logic        vid_hsync,
    output logic        vid_vsync
);

    logic upload_axis_ready;
    logic upload_axis_valid;
    logic [8:0] accepted_command_count;
    logic [63:0] command_read_data;
    logic [8:0] renderer_command_read_address;
    logic renderer_start;
    logic renderer_busy;
    logic renderer_done;
    logic [15:0] renderer_write_address;
    logic [7:0] renderer_write_token;
    logic renderer_write_valid;
    logic renderer_write_second_valid;
    logic [7:0] renderer_write_second_token;
    logic [3:0] renderer_last_errors;
    logic [3:0] renderer_sticky_errors;
    logic [7:0] renderer_first_error_command;
    logic [31:0] observed_accepted_count;
    logic [31:0] accepted_palette_generation;
    logic [31:0] accepted_asset_generation;
    logic [31:0] accepted_tilemap_generation;
    logic render_pending;
    logic palette_ready;
    logic asset_ready;
    logic tilemap_ready;
    logic upload_enabled;
    logic write_bank;
    logic present_pending;
    logic present_done;
    logic display_bank;
    logic swap_pulse;
    logic [10:0] pixel_x;
    logic [9:0] pixel_y;
    logic [8:0] logical_x;
    logic [7:0] logical_y;
    logic data_enable;
    logic hsync;
    logic vsync;
    logic frame_start;
    logic vblank_start;
    logic line_start;
    logic [15:0] framebuffer_read_address;
    logic [7:0] framebuffer_read_token;
    logic [15:0] atlas_read_address;
    logic [3:0] atlas_read_index;
    logic command_active_bank;
    logic renderer_bank;
    logic upload_in_progress;
    logic completion_hold;
    logic completion_presented;
    logic release_observed;
    logic generation_rejected;

    assign render_pending = accepted_packet_count != observed_accepted_count;
    assign palette_ready = !RUNTIME_PALETTE_ENABLE || (
        runtime_palette_valid &&
        runtime_palette_generation == accepted_palette_generation
    );
    assign asset_ready = !RUNTIME_ASSET_ENABLE || (
        runtime_asset_valid &&
        runtime_asset_generation == accepted_asset_generation
    );
    assign tilemap_ready = !RUNTIME_TILEMAP_ENABLE || (
        runtime_tilemap_valid &&
        runtime_tilemap_generation == accepted_tilemap_generation
    );
    assign renderer_start =
        render_pending && !renderer_busy && !present_pending && palette_ready &&
        asset_ready && tilemap_ready &&
        (!UPLOAD_RENDER_OVERLAP_ENABLE || (!completion_hold && !renderer_done));
    assign upload_enabled = UPLOAD_RENDER_OVERLAP_ENABLE
        ? upload_in_progress || !render_pending
        : !renderer_busy && !render_pending && !present_pending;
    assign resource_upload_idle = !renderer_busy && !render_pending && !present_pending &&
        (!UPLOAD_RENDER_OVERLAP_ENABLE || (!completion_hold && !upload_in_progress));
    assign overlap_status = UPLOAD_RENDER_OVERLAP_ENABLE ? {
        24'd0, generation_rejected, resource_upload_idle, release_observed,
        completion_presented, completion_hold, upload_in_progress,
        render_pending, upload_enabled && !upload_in_progress
    } : 32'd0;
    assign upload_axis_valid = s_axis_tvalid && upload_enabled;
    assign s_axis_tready = upload_axis_ready && upload_enabled;
    assign debug_command_read_data_low = command_read_data[31:0];
    assign debug_command_read_data_high = command_read_data[63:32];
    assign render_status = {
        8'd0,
        renderer_first_error_command,
        4'd0,
        renderer_sticky_errors,
        renderer_last_errors,
        3'd0,
        renderer_busy
    };
    assign framebuffer_status = {
        29'd0,
        present_pending,
        write_bank,
        display_bank
    };
    assign palette_vblank_start = vblank_start;

    scene2d_command_upload #(
        .UPLOAD_RENDER_OVERLAP_ENABLE(UPLOAD_RENDER_OVERLAP_ENABLE)
    ) command_upload (
        .aclk,
        .aresetn,
        .s_axis_tdata,
        .s_axis_tkeep,
        .s_axis_tlast,
        .s_axis_tvalid(upload_axis_valid),
        .s_axis_tready(upload_axis_ready),
        .command_read_address(renderer_busy || renderer_start ? renderer_command_read_address : debug_command_read_address),
        .render_bank_valid(renderer_busy || renderer_start),
        .render_bank_select(renderer_start ? command_active_bank : renderer_bank),
        .generation_check_enable({RUNTIME_TILEMAP_ENABLE != 0,
            RUNTIME_ASSET_ENABLE != 0, RUNTIME_PALETTE_ENABLE != 0}),
        .resource_generation_valid({runtime_tilemap_valid, runtime_asset_valid, runtime_palette_valid}),
        .required_palette_generation(runtime_palette_generation),
        .required_asset_generation(runtime_asset_generation),
        .required_tilemap_generation(runtime_tilemap_generation),
        .generation_rejected,
        .command_read_data,
        .command_read_data_low(),
        .command_read_data_high(),
        .completed_crc32(upload_crc32),
        .completed_byte_count(upload_byte_count),
        .completed_packet_count(upload_packet_count),
        .accepted_packet_count,
        .rejected_packet_count,
        .accepted_seq,
        .accepted_palette_generation,
        .accepted_asset_generation,
        .accepted_tilemap_generation,
        .accepted_command_count,
        .accepted_status,
        .sticky_error_flags(upload_error_flags),
        .active_bank(command_active_bank),
        .bank_valid()
    );

    scene2d_clear_fill_renderer #(
        .TILE_DESCRIPTOR_CACHE_ENABLE(TILE_DESCRIPTOR_CACHE_ENABLE),
        .BLIT_PIXEL_PIPELINE_ENABLE(BLIT_PIXEL_PIPELINE_ENABLE),
        .TILE_PIXEL_PIPELINE_ENABLE(TILE_PIXEL_PIPELINE_ENABLE),
        .TILE_PIXEL_PAIR_ENABLE(TILE_PIXEL_PAIR_ENABLE),
        .BLIT_PIXEL_PAIR_ENABLE(BLIT_PIXEL_PAIR_ENABLE),
        .CLEAR_FILL_PIXEL_PAIR_ENABLE(CLEAR_FILL_PIXEL_PAIR_ENABLE)
    ) renderer (
        .aclk,
        .aresetn,
        .start(renderer_start),
        .submit_seq(accepted_seq),
        .command_count(accepted_command_count),
        .command_read_address(renderer_command_read_address),
        .command_read_data,
        .atlas_read_address,
        .atlas_read_index,
        .runtime_asset_enable(RUNTIME_ASSET_ENABLE != 0),
        .runtime_asset_valid,
        .runtime_asset_width,
        .runtime_asset_height,
        .runtime_asset_stride_bytes,
        .runtime_asset_id,
        .runtime_asset_read_address,
        .runtime_asset_read_byte,
        .runtime_tilemap_enable(RUNTIME_TILEMAP_ENABLE != 0),
        .runtime_tilemap_valid,
        .runtime_tilemap_width_tiles,
        .runtime_tilemap_height_tiles,
        .runtime_tilemap_tile_size,
        .runtime_tilemap_id,
        .runtime_tilemap_read_word_address,
        .runtime_tilemap_read_word_data,
        .write_valid(renderer_write_valid),
        .write_address(renderer_write_address),
        .write_token(renderer_write_token),
        .write_second_valid(renderer_write_second_valid),
        .write_second_token(renderer_write_second_token),
        .busy(renderer_busy),
        .done(renderer_done),
        .completed_seq(render_completed_seq),
        .completed_write_count(render_write_count),
        .completed_trace_crc32(render_trace_crc32),
        .completed_cycles(render_cycles),
        .maximum_cycles(render_maximum_cycles),
        .last_error_flags(renderer_last_errors),
        .sticky_error_flags(renderer_sticky_errors),
        .first_error_command(renderer_first_error_command)
    );

    scene2d_frame_swap frame_swap (
        .write_clk(aclk),
        .write_resetn(aresetn),
        .render_done(renderer_done),
        .write_bank,
        .present_pending,
        .present_done,
        .pixel_clk(clk_pixel),
        .pixel_resetn(resetn_pixel),
        .frame_start(vblank_start),
        .display_bank,
        .swap_pulse
    );

    generate
        if (ATLAS_ENABLE) begin : resident_atlas
            scene2d_index4_atlas #(
                .INIT_FILE(ATLAS_INIT_FILE)
            ) atlas (
                .clk(aclk),
                .resetn(aresetn),
                .pixel_address(atlas_read_address),
                .color_index(atlas_read_index)
            );
        end else begin : no_resident_atlas
            assign atlas_read_index = 4'd0;
        end
    endgenerate

    scene2d_framebuffer #(
        .DUAL_PIXEL_WRITE_ENABLE(TILE_PIXEL_PAIR_ENABLE || BLIT_PIXEL_PAIR_ENABLE || CLEAR_FILL_PIXEL_PAIR_ENABLE)
    ) framebuffer (
        .write_clk(aclk),
        .write_resetn(aresetn),
        .write_bank,
        .write_enable(renderer_write_valid),
        .write_address(renderer_write_address),
        .write_token(renderer_write_token),
        .write_second_enable(renderer_write_second_valid),
        .write_second_token(renderer_write_second_token),
        .read_clk(clk_pixel),
        .read_resetn(resetn_pixel),
        .read_bank(display_bank),
        .read_address(framebuffer_read_address),
        .read_token(framebuffer_read_token)
    );

    scene2d_video_timing #(
        .H_ACTIVE(H_ACTIVE),
        .H_FRONT(H_FRONT),
        .H_SYNC(H_SYNC),
        .H_BACK(H_BACK),
        .V_ACTIVE(V_ACTIVE),
        .V_FRONT(V_FRONT),
        .V_SYNC(V_SYNC),
        .V_BACK(V_BACK),
        .OUTPUT_SCALE(OUTPUT_SCALE)
    ) timing (
        .clk_pixel,
        .resetn_pixel,
        .pixel_x,
        .pixel_y,
        .logical_x,
        .logical_y,
        .data_enable,
        .hsync,
        .vsync,
        .frame_start,
        .vblank_start,
        .line_start
    );

    scene2d_palette_scanout #(
        .RUNTIME_PALETTE_ENABLE(RUNTIME_PALETTE_ENABLE)
    ) scanout (
        .clk_pixel,
        .resetn_pixel,
        .logical_x,
        .logical_y,
        .data_enable,
        .hsync,
        .vsync,
        .framebuffer_address(framebuffer_read_address),
        .framebuffer_token(framebuffer_read_token),
        .palette_read_address(runtime_palette_read_address),
        .palette_read_rgb(runtime_palette_read_rgb),
        .vid_data,
        .vid_de,
        .vid_hsync,
        .vid_vsync
    );

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            observed_accepted_count <= '0;
            render_completed_count <= '0;
            present_completed_seq <= '0;
            present_completed_count <= '0;
            renderer_bank <= 1'b0;
            upload_in_progress <= 1'b0;
            completion_hold <= 1'b0;
            completion_presented <= 1'b0;
            release_observed <= 1'b0;
        end else begin
            if (UPLOAD_RENDER_OVERLAP_ENABLE) begin
                if (upload_axis_valid && upload_axis_ready) upload_in_progress <= !s_axis_tlast;
                if (renderer_start) begin
                    renderer_bank <= command_active_bank;
                    completion_presented <= 1'b0;
                end
                if (renderer_done) completion_hold <= 1'b1;
                if (present_done) completion_presented <= 1'b1;
                if (overlap_release_toggle != release_observed) begin
                    release_observed <= overlap_release_toggle;
                    if (completion_hold && completion_presented) completion_hold <= 1'b0;
                end
            end
            if (renderer_start) begin
                observed_accepted_count <= accepted_packet_count;
            end
            if (renderer_done) begin
                render_completed_count <= render_completed_count + 1'b1;
            end
            if (renderer_start) begin
                present_completed_seq <= accepted_seq;
            end
            if (present_done) begin
                present_completed_count <= present_completed_count + 1'b1;
            end
        end
    end

endmodule