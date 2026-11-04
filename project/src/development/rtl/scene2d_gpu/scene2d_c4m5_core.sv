module scene2d_c4m5_core #(
    parameter integer H_ACTIVE = 1280,
    parameter integer H_FRONT = 110,
    parameter integer H_SYNC = 40,
    parameter integer H_BACK = 220,
    parameter integer V_ACTIVE = 720,
    parameter integer V_FRONT = 5,
    parameter integer V_SYNC = 5,
    parameter integer V_BACK = 20,
    parameter integer OUTPUT_SCALE = 4,
    parameter string ATLAS_INIT_FILE = "none"
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
    output logic [31:0] router_dropped_packet_count,
    output logic [31:0] unsupported_packet_count,
    output logic [31:0] palette_accepted_packet_count,
    output logic [31:0] palette_rejected_packet_count,
    output logic [31:0] palette_generation,
    output logic [8:0]  palette_error_flags,
    output logic [31:0] palette_status,
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
    logic palette_tready;
    logic palette_valid;
    logic palette_commit_pending;
    logic palette_active_bank;
    logic palette_write_bank;
    logic [7:0] palette_read_address;
    logic [23:0] palette_read_rgb;
    logic palette_vblank_start;

    assign routed_tready[0] = scene_tready;
    assign routed_tready[1] = 1'b1;
    assign routed_tready[2] = 1'b1;
    assign routed_tready[3] = palette_tready;
    assign routed_tready[4] = 1'b1;
    assign palette_status = {
        28'd0,
        palette_commit_pending,
        palette_write_bank,
        palette_active_bank,
        palette_valid
    };

    scene2d_packet_router packet_router (
        .aclk,
        .aresetn,
        .s_axis_tdata,
        .s_axis_tkeep,
        .s_axis_tlast,
        .s_axis_tvalid,
        .s_axis_tready,
        .m_axis_tdata(routed_tdata),
        .m_axis_tkeep(routed_tkeep),
        .m_axis_tlast(routed_tlast),
        .m_axis_tvalid(routed_tvalid),
        .m_axis_tready(routed_tready),
        .dropped_packet_count(router_dropped_packet_count)
    );

    scene2d_palette_store palette_store (
        .aclk,
        .aresetn,
        .clk_pixel,
        .resetn_pixel,
        .vblank_start(palette_vblank_start),
        .s_axis_tdata(routed_tdata[3 * 64 +: 64]),
        .s_axis_tkeep(routed_tkeep[3 * 8 +: 8]),
        .s_axis_tlast(routed_tlast[3]),
        .s_axis_tvalid(routed_tvalid[3]),
        .s_axis_tready(palette_tready),
        .read_address(palette_read_address),
        .read_rgb(palette_read_rgb),
        .accepted_packet_count(palette_accepted_packet_count),
        .rejected_packet_count(palette_rejected_packet_count),
        .committed_generation(palette_generation),
        .sticky_error_flags(palette_error_flags),
        .palette_valid,
        .commit_pending(palette_commit_pending),
        .active_bank(palette_active_bank),
        .write_bank(palette_write_bank)
    );

    scene2d_c4m3_core #(
        .H_ACTIVE(H_ACTIVE),
        .H_FRONT(H_FRONT),
        .H_SYNC(H_SYNC),
        .H_BACK(H_BACK),
        .V_ACTIVE(V_ACTIVE),
        .V_FRONT(V_FRONT),
        .V_SYNC(V_SYNC),
        .V_BACK(V_BACK),
        .OUTPUT_SCALE(OUTPUT_SCALE),
        .ATLAS_ENABLE(1),
        .ATLAS_INIT_FILE(ATLAS_INIT_FILE),
        .RUNTIME_PALETTE_ENABLE(1)
    ) core (
        .aclk,
        .aresetn,
        .clk_pixel,
        .resetn_pixel,
        .s_axis_tdata(routed_tdata[0 +: 64]),
        .s_axis_tkeep(routed_tkeep[0 +: 8]),
        .s_axis_tlast(routed_tlast[0]),
        .s_axis_tvalid(routed_tvalid[0]),
        .s_axis_tready(scene_tready),
        .debug_command_read_address,
        .debug_command_read_data_low,
        .debug_command_read_data_high,
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
        .runtime_palette_valid(palette_valid),
        .runtime_palette_generation(palette_generation),
        .runtime_palette_read_address(palette_read_address),
        .runtime_palette_read_rgb(palette_read_rgb),
        .palette_vblank_start,
        .runtime_asset_valid(1'b0),
        .runtime_asset_generation(32'd0),
        .runtime_asset_width(16'd0),
        .runtime_asset_height(16'd0),
        .runtime_asset_stride_bytes(16'd0),
        .runtime_asset_id(),
        .runtime_asset_read_address(),
        .runtime_asset_read_byte(8'd0),
        .runtime_tilemap_valid(1'b0),
        .runtime_tilemap_generation(32'd0),
        .runtime_tilemap_width_tiles(16'd0),
        .runtime_tilemap_height_tiles(16'd0),
        .runtime_tilemap_tile_size(16'd0),
        .runtime_tilemap_id(),
        .runtime_tilemap_read_word_address(),
        .runtime_tilemap_read_word_data(32'd0),
        .vid_data,
        .vid_de,
        .vid_hsync,
        .vid_vsync
    );

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            unsupported_packet_count <= '0;
        end else if (
            (routed_tvalid[1] && routed_tready[1] && routed_tlast[1]) ||
            (routed_tvalid[2] && routed_tready[2] && routed_tlast[2]) ||
            (routed_tvalid[4] && routed_tready[4] && routed_tlast[4])
        ) begin
            unsupported_packet_count <= unsupported_packet_count + 1'b1;
        end
    end

endmodule