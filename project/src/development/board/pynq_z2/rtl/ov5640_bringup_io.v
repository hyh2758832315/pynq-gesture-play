`timescale 1ns / 1ps

module ov5640_bringup_io (
    input  wire       clk,
    input  wire       resetn,
    input  wire [2:0] control,
    output wire [31:0] camera_status,
    output reg        camera_xclk,
    inout  wire       camera_scl,
    inout  wire       camera_sda,
    input  wire       camera_pclk,
    input  wire       camera_vsync,
    input  wire       camera_href,
    input  wire [7:0] camera_data
);
    reg [2:0] xclk_divider;
    wire [1:0] sccb_sample;
    (* ASYNC_REG = "TRUE" *) reg [1:0] pclk_sync;
    (* ASYNC_REG = "TRUE" *) reg [1:0] vsync_sync;
    (* ASYNC_REG = "TRUE" *) reg [1:0] href_sync;
    reg [7:0] data_sample;
    reg [5:0] pclk_edges;
    reg [5:0] vsync_edges;
    reg [5:0] href_edges;

    assign camera_status = {
        1'b0,
        href_edges,
        vsync_edges,
        pclk_edges,
        href_sync[1],
        vsync_sync[1],
        pclk_sync[1],
        data_sample,
        sccb_sample
    };

    always @(posedge clk) begin
        if (!resetn || !control[2]) begin
            xclk_divider <= 3'd0;
            camera_xclk <= 1'b0;
        end else if (xclk_divider == 3'd3) begin
            xclk_divider <= 3'd0;
            camera_xclk <= ~camera_xclk;
        end else begin
            xclk_divider <= xclk_divider + 1'b1;
        end
    end

    always @(posedge clk) begin
        if (!resetn) begin
            pclk_sync <= 2'b00;
            vsync_sync <= 2'b00;
            href_sync <= 2'b00;
            data_sample <= 8'h00;
            pclk_edges <= 6'h00;
            vsync_edges <= 6'h00;
            href_edges <= 6'h00;
        end else begin
            pclk_sync <= {pclk_sync[0], camera_pclk};
            vsync_sync <= {vsync_sync[0], camera_vsync};
            href_sync <= {href_sync[0], camera_href};
            data_sample <= camera_data;
            if (pclk_sync[0] && !pclk_sync[1] && !(&pclk_edges)) begin
                pclk_edges <= pclk_edges + 1'b1;
            end
            if (vsync_sync[0] && !vsync_sync[1] && !(&vsync_edges)) begin
                vsync_edges <= vsync_edges + 1'b1;
            end
            if (href_sync[0] && !href_sync[1] && !(&href_edges)) begin
                href_edges <= href_edges + 1'b1;
            end
        end
    end

    IOBUF scl_iobuf (
        .I(1'b0),
        .O(sccb_sample[0]),
        .T(~control[0]),
        .IO(camera_scl)
    );

    IOBUF sda_iobuf (
        .I(1'b0),
        .O(sccb_sample[1]),
        .T(~control[1]),
        .IO(camera_sda)
    );
endmodule
