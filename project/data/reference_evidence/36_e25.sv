module scene2d_c4m7_core #(
    parameter integer H_ACTIVE = 1280,
    parameter integer H_FRONT = 110,
    parameter integer H_SYNC = 40,
    parameter integer H_BACK = 220,
    parameter integer V_ACTIVE = 720,
    parameter integer V_FRONT = 5,
    parameter integer V_SYNC = 5,
    parameter integer V_BACK = 20,
    parameter integer OUTPUT_SCALE = 4,
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
    output logic [31:0] router_dropped_packet_count,
    output logic [31:0] unsupported_packet_count,
    output logic [31:0] palette_accepted_packet_count,
    output logic [31:0] palette_rejected_packet_count,
    output logic [31:0] palette_generation,
    output logic [8:0]  palette_error_flags,
    output logic [31:0] palette_status,
    output logic [31:0] asset_accepted_packet_count,
    output logic [31:0] asset_rejected_packet_count,
    output logic [31:0] asset_generation,
    output logic [8:0]  asset_error_flags,
    output logic [31:0] asset_status,
    output logic [31:0] tilemap_accepted_packet_count,
    output logic [31:0] tilemap_rejected_packet_count,
    output logic [31:0] tilemap_generation,
    output logic [8:0]  tilemap_error_flags,
    output logic [31:0] tilemap_status,
    output logic [23:0] vid_data,
    output logic        vid_de,
    output logic        vid_hsync,
    output logic        vid_vsync
);

    logic [319:0] routed_tdata;
    logic [39:0] routed_tkeep;
    logic [4:0] routed_tlast;
    logic [4:0] routed_tvalid;
    logic [4:0] routed_tready;
    logic scene_tready;
    logic asset_tready;
    logic tilemap_tready;
    logic palette_tready;
    logic palette_valid;
    logic palette_commit_pending;
    logic palette_active_bank;
    logic palette_write_bank;
    logic [7:0] palette_read_address;
    logic [23:0] palette_read_rgb;
    logic palette_vblank_start;
    logic asset_bundle_valid;
    logic asset_commit_pending;
    logic asset_active_bank;
    logic asset_write_bank;
    logic [1:0] asset_read_id;
    logic [14:0] asset_read_address;
    logic [7:0] asset_read_byte;
    logic [15:0] asset_width;
    logic [15:0] asset_height;
    logic [15:0] asset_stride_bytes;
    logic [1:0] tilemap_read_id;
    logic [9:0] tilemap_read_word_address;
    logic [31:0] tilemap_read_word_data;
    logic tilemap_read_valid;
    logic [15:0] tilemap_width_tiles;
    logic [15:0] tilemap_height_tiles;
    logic [15:0] tilemap_tile_size;
    logic [31:0] tilemap_read_generation;
    logic [3:0] tilemap_valid;
    logic [3:0] tilemap_commit_pending;
    logic [3:0] tilemap_active_bank;
    logic [3:0] tilemap_write_bank;
    logic resource_upload_idle;
    logic resource_packet_active;
    logic resource_upload_allowed;

    assign routed_tready[0] = scene_tready;
    assign resource_upload_allowed = !UPLOAD_RENDER_OVERLAP_ENABLE ||
        resource_upload_idle || resource_packet_active;
    assign routed_tready[1] = asset_tready && resource_upload_allowed;
    assign routed_tready[2] = tilemap_tready && resource_upload_allowed;
    assign routed_tready[3] = palette_tready && resource_upload_allowed;
    assign routed_tready[4] = 1'b1;
    assign palette_status = {28'd0, palette_commit_pending, palette_write_bank,
        palette_active_bank, palette_valid};
    assign asset_status = {28'd0, asset_commit_pending, asset_write_bank,
        asset_active_bank, asset_bundle_valid};
    assign tilemap_status = {16'd0, tilemap_write_bank, tilemap_active_bank,
        tilemap_commit_pending, tilemap_valid};

    scene2d_packet_router packet_router (
        .aclk, .aresetn, .s_axis_tdata, .s_axis_tkeep, .s_axis_tlast,
        .s_axis_tvalid, .s_axis_tready, .m_axis_tdata(routed_tdata),
        .m_axis_tkeep(routed_tkeep), .m_axis_tlast(routed_tlast),
        .m_axis_tvalid(routed_tvalid), .m_axis_tready(routed_tready),
        .dropped_packet_count(router_dropped_packet_count)
    );

    scene2d_palette_store palette_store (
        .aclk, .aresetn, .clk_pixel, .resetn_pixel,
        .vblank_start(palette_vblank_start),
        .s_axis_tdata(routed_tdata[3 * 64 +: 64]),
        .s_axis_tkeep(routed_tkeep[3 * 8 +: 8]),
        .s_axis_tlast(routed_tlast[3]), .s_axis_tvalid(routed_tvalid[3] && resource_upload_allowed),
        .s_axis_tready(palette_tready), .read_address(palette_read_address),
        .read_rgb(palette_read_rgb), .accepted_packet_count(palette_accepted_packet_count),
        .rejected_packet_count(palette_rejected_packet_count),
        .committed_generation(palette_generation), .sticky_error_flags(palette_error_flags),
        .palette_valid, .commit_pending(palette_commit_pending),
        .active_bank(palette_active_bank), .write_bank(palette_write_bank)
    );

    scene2d_asset_bundle_store asset_store (
        .aclk, .aresetn, .renderer_idle(!render_status[0]),
        .s_axis_tdata(routed_tdata[1 * 64 +: 64]),
        .s_axis_tkeep(routed_tkeep[1 * 8 +: 8]), .s_axis_tlast(routed_tlast[1]),
        .s_axis_tvalid(routed_tvalid[1] && resource_upload_allowed), .s_axis_tready(asset_tready),
        .read_asset_id(asset_read_id), .read_byte_offset(asset_read_address),
        .read_byte(asset_read_byte), .read_asset_valid(),
        .read_asset_width(asset_width), .read_asset_height(asset_height),
        .read_asset_stride_bytes(asset_stride_bytes),
        .accepted_packet_count(asset_accepted_packet_count),
        .rejected_packet_count(asset_rejected_packet_count),
        .committed_generation(asset_generation), .sticky_error_flags(asset_error_flags),
        .bundle_valid(asset_bundle_valid), .commit_pending(asset_commit_pending),
        .active_bank(asset_active_bank), .write_bank(asset_write_bank)
    );

    scene2d_tilemap_store tilemap_store (
        .aclk, .aresetn, .renderer_idle(!render_status[0]),
        .s_axis_tdata(routed_tdata[2 * 64 +: 64]),
        .s_axis_tkeep(routed_tkeep[2 * 8 +: 8]), .s_axis_tlast(routed_tlast[2]),
        .s_axis_tvalid(routed_tvalid[2] && resource_upload_allowed), .s_axis_tready(tilemap_tready),
        .read_tilemap_id(tilemap_read_id), .read_word_address(tilemap_read_word_address),
        .read_word_data(tilemap_read_word_data), .read_tilemap_valid(tilemap_read_valid),
        .read_width_tiles(tilemap_width_tiles), .read_height_tiles(tilemap_height_tiles),
        .read_origin_x(), .read_origin_y(), .read_tile_size(tilemap_tile_size),
        .read_generation(tilemap_read_generation),
        .accepted_packet_count(tilemap_accepted_packet_count),
        .rejected_packet_count(tilemap_rejected_packet_count),
        .committed_generation(tilemap_generation), .sticky_error_flags(tilemap_error_flags),
        .tilemap_valid, .commit_pending(tilemap_commit_pending),
        .active_bank(tilemap_active_bank), .write_bank(tilemap_write_bank)
    );

    scene2d_c4m3_core #(
        .H_ACTIVE(H_ACTIVE), .H_FRONT(H_FRONT), .H_SYNC(H_SYNC),
        .H_BACK(H_BACK), .V_ACTIVE(V_ACTIVE), .V_FRONT(V_FRONT),
        .V_SYNC(V_SYNC), .V_BACK(V_BACK), .OUTPUT_SCALE(OUTPUT_SCALE),
        .RUNTIME_PALETTE_ENABLE(1), .RUNTIME_ASSET_ENABLE(1),
        .RUNTIME_TILEMAP_ENABLE(1),
        .TILE_DESCRIPTOR_CACHE_ENABLE(TILE_DESCRIPTOR_CACHE_ENABLE),
        .BLIT_PIXEL_PIPELINE_ENABLE(BLIT_PIXEL_PIPELINE_ENABLE),
        .TILE_PIXEL_PIPELINE_ENABLE(TILE_PIXEL_PIPELINE_ENABLE),
        .TILE_PIXEL_PAIR_ENABLE(TILE_PIXEL_PAIR_ENABLE),
        .BLIT_PIXEL_PAIR_ENABLE(BLIT_PIXEL_PAIR_ENABLE),
        .CLEAR_FILL_PIXEL_PAIR_ENABLE(CLEAR_FILL_PIXEL_PAIR_ENABLE),
        .UPLOAD_RENDER_OVERLAP_ENABLE(UPLOAD_RENDER_OVERLAP_ENABLE)
    ) core (
        .aclk, .aresetn, .clk_pixel, .resetn_pixel,
        .s_axis_tdata(routed_tdata[0 +: 64]),
        .s_axis_tkeep(routed_tkeep[0 +: 8]), .s_axis_tlast(routed_tlast[0]),
        .s_axis_tvalid(routed_tvalid[0]), .s_axis_tready(scene_tready),
        .debug_command_read_address, .debug_command_read_data_low,
        .debug_command_read_data_high, .upload_crc32, .upload_byte_count,
        .upload_packet_count, .accepted_packet_count, .rejected_packet_count,
        .accepted_seq, .accepted_status, .upload_error_flags,
        .render_completed_seq, .render_completed_count, .render_write_count,
        .render_trace_crc32, .render_cycles, .render_maximum_cycles,
        .render_status, .present_completed_seq, .present_completed_count,
        .overlap_release_toggle, .overlap_status, .resource_upload_idle,
        .framebuffer_status, .runtime_palette_valid(palette_valid),
        .runtime_palette_generation(palette_generation),
        .runtime_palette_read_address(palette_read_address),
        .runtime_palette_read_rgb(palette_read_rgb), .palette_vblank_start,
        .runtime_asset_valid(asset_bundle_valid), .runtime_asset_generation(asset_generation),
        .runtime_asset_width(asset_width), .runtime_asset_height(asset_height),
        .runtime_asset_stride_bytes(asset_stride_bytes), .runtime_asset_id(asset_read_id),
        .runtime_asset_read_address(asset_read_address), .runtime_asset_read_byte(asset_read_byte),
        .runtime_tilemap_valid(tilemap_read_valid),
        .runtime_tilemap_generation(tilemap_read_generation),
        .runtime_tilemap_width_tiles(tilemap_width_tiles),
        .runtime_tilemap_height_tiles(tilemap_height_tiles),
        .runtime_tilemap_tile_size(tilemap_tile_size),
        .runtime_tilemap_id(tilemap_read_id),
        .runtime_tilemap_read_word_address(tilemap_read_word_address),
        .runtime_tilemap_read_word_data(tilemap_read_word_data),
        .vid_data, .vid_de, .vid_hsync, .vid_vsync
    );

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            unsupported_packet_count <= '0;
        end else if (routed_tvalid[4] && routed_tready[4] && routed_tlast[4]) begin
            unsupported_packet_count <= unsupported_packet_count + 1'b1;
        end
    end

    always_ff @(posedge aclk) begin
        if (!aresetn) resource_packet_active <= 1'b0;
        else if (UPLOAD_RENDER_OVERLAP_ENABLE) begin
            for (int resource_index = 1; resource_index <= 3; resource_index++) begin
                if (routed_tvalid[resource_index] && routed_tready[resource_index])
                    resource_packet_active <= !routed_tlast[resource_index];
            end
        end
    end

endmodule