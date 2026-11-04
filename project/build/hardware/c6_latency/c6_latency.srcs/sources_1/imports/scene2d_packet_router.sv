module scene2d_packet_router (
    input  logic         aclk,
    input  logic         aresetn,
    input  logic [63:0]  s_axis_tdata,
    input  logic [7:0]   s_axis_tkeep,
    input  logic         s_axis_tlast,
    input  logic         s_axis_tvalid,
    output logic         s_axis_tready,
    output logic [319:0] m_axis_tdata,
    output logic [39:0]  m_axis_tkeep,
    output logic [4:0]   m_axis_tlast,
    output logic [4:0]   m_axis_tvalid,
    input  logic [4:0]   m_axis_tready,
    output logic [31:0]  dropped_packet_count
);

    localparam logic [31:0] SCENE_MAGIC = 32'h47443253;
    localparam logic [31:0] ASSET_MAGIC = 32'h41443253;
    localparam logic [31:0] TILEMAP_MAGIC = 32'h54443253;
    localparam logic [31:0] PALETTE_MAGIC = 32'h50443253;
    localparam logic [31:0] FRAME8_MAGIC = 32'h46443253;

    logic [2:0] route_select;
    logic route_drop;
    logic packet_active;
    logic [39:0] unused_tid;
    logic [39:0] unused_tdest;
    logic [4:0] unused_tuser;

    always_comb begin
        route_select = 3'd0;
        route_drop = 1'b0;
        case (s_axis_tdata[31:0])
            SCENE_MAGIC: route_select = 3'd0;
            ASSET_MAGIC: route_select = 3'd1;
            TILEMAP_MAGIC: route_select = 3'd2;
            PALETTE_MAGIC: route_select = 3'd3;
            FRAME8_MAGIC: route_select = 3'd4;
            default: route_drop = 1'b1;
        endcase
    end

    axis_demux #(
        .M_COUNT(5),
        .DATA_WIDTH(64),
        .KEEP_ENABLE(1),
        .KEEP_WIDTH(8),
        .ID_ENABLE(0),
        .ID_WIDTH(8),
        .DEST_ENABLE(0),
        .M_DEST_WIDTH(8),
        .S_DEST_WIDTH(11),
        .USER_ENABLE(0),
        .USER_WIDTH(1),
        .TDEST_ROUTE(0)
    ) demux (
        .clk(aclk),
        .rst(!aresetn),
        .s_axis_tdata,
        .s_axis_tkeep,
        .s_axis_tvalid,
        .s_axis_tready,
        .s_axis_tlast,
        .s_axis_tid(8'd0),
        .s_axis_tdest(11'd0),
        .s_axis_tuser(1'b0),
        .m_axis_tdata,
        .m_axis_tkeep,
        .m_axis_tvalid,
        .m_axis_tready,
        .m_axis_tlast,
        .m_axis_tid(unused_tid),
        .m_axis_tdest(unused_tdest),
        .m_axis_tuser(unused_tuser),
        .enable(1'b1),
        .drop(route_drop),
        .select(route_select)
    );

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            packet_active <= 1'b0;
            dropped_packet_count <= '0;
        end else if (s_axis_tvalid && s_axis_tready) begin
            if (!packet_active) begin
                if (route_drop) begin
                    dropped_packet_count <= dropped_packet_count + 1'b1;
                end
            end
            if (s_axis_tlast) begin
                packet_active <= 1'b0;
            end else begin
                packet_active <= 1'b1;
            end
        end
    end

endmodule