module vision_dma_write_pair #(
    parameter integer DATA_BYTES = 8,
    parameter [63:0] RGB_BYTES = 64'd2764800,
    parameter [63:0] PACKET_BYTES = 64'd460864,
    parameter integer CONTINUOUS = 0,
    parameter integer TRACK_FRAME_COMPLETIONS = 0,
    parameter integer SG_STATUS = 0
)(
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF MON_RGB:MON_PACKET:MON_STATUS, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
    input wire aclk,
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
    input wire aresetn,
    input wire capture_fault,
    input wire source_closed,
    input wire [31:0] closed_frame_count,
    (* X_INTERFACE_MODE = "monitor" *)
    (* X_INTERFACE_PARAMETER = "PROTOCOL AXI4, DATA_WIDTH 64, ADDR_WIDTH 32, ID_WIDTH 0, READ_WRITE_MODE WRITE_ONLY" *)
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB AWVALID" *)
    input wire rgb_address_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB AWREADY" *)
    input wire rgb_address_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB AWADDR" *)
    input wire [31:0] rgb_address,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB AWLEN" *)
    input wire [7:0] rgb_address_length,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WDATA" *)
    input wire [DATA_BYTES*8-1:0] rgb_write_data,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WVALID" *)
    input wire rgb_data_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WREADY" *)
    input wire rgb_data_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WLAST" *)
    input wire rgb_data_last,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB WSTRB" *)
    input wire [DATA_BYTES-1:0] rgb_data_strobes,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB BVALID" *)
    input wire rgb_response_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB BREADY" *)
    input wire rgb_response_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_RGB BRESP" *)
    input wire [1:0] rgb_response_status,
    (* X_INTERFACE_MODE = "monitor" *)
    (* X_INTERFACE_PARAMETER = "PROTOCOL AXI4, DATA_WIDTH 64, ADDR_WIDTH 32, ID_WIDTH 0, READ_WRITE_MODE WRITE_ONLY" *)
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET AWVALID" *)
    input wire packet_address_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET AWREADY" *)
    input wire packet_address_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET AWADDR" *)
    input wire [31:0] packet_address,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET AWLEN" *)
    input wire [7:0] packet_address_length,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WDATA" *)
    input wire [DATA_BYTES*8-1:0] packet_write_data,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WVALID" *)
    input wire packet_data_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WREADY" *)
    input wire packet_data_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WLAST" *)
    input wire packet_data_last,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET WSTRB" *)
    input wire [DATA_BYTES-1:0] packet_data_strobes,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET BVALID" *)
    input wire packet_response_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET BREADY" *)
    input wire packet_response_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_PACKET BRESP" *)
    input wire [1:0] packet_response_status,
    (* X_INTERFACE_MODE = "monitor" *)
    (* X_INTERFACE_PARAMETER = "PROTOCOL AXI4, DATA_WIDTH 32, ADDR_WIDTH 32, ID_WIDTH 0, READ_WRITE_MODE READ_WRITE" *)
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWVALID" *)
    input wire status_address_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWREADY" *)
    input wire status_address_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWADDR" *)
    input wire [31:0] status_address,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWLEN" *)
    input wire [7:0] status_address_length,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWSIZE" *)
    input wire [2:0] status_address_size,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWBURST" *)
    input wire [1:0] status_address_burst,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWPROT" *)
    input wire [2:0] status_address_protection,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS AWCACHE" *)
    input wire [3:0] status_address_cache,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WDATA" *)
    input wire [31:0] status_write_data,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WVALID" *)
    input wire status_data_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WREADY" *)
    input wire status_data_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WLAST" *)
    input wire status_data_last,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS WSTRB" *)
    input wire [3:0] status_data_strobes,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS BVALID" *)
    input wire status_response_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS BREADY" *)
    input wire status_response_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS BRESP" *)
    input wire [1:0] status_response_status,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARADDR" *)
    input wire [31:0] status_read_address,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARLEN" *)
    input wire [7:0] status_read_address_length,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARSIZE" *)
    input wire [2:0] status_read_address_size,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARBURST" *)
    input wire [1:0] status_read_address_burst,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARPROT" *)
    input wire [2:0] status_read_address_protection,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARCACHE" *)
    input wire [3:0] status_read_address_cache,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARVALID" *)
    input wire status_read_address_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS ARREADY" *)
    input wire status_read_address_ready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RDATA" *)
    input wire [31:0] status_read_data,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RRESP" *)
    input wire [1:0] status_read_response,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RLAST" *)
    input wire status_read_last,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RVALID" *)
    input wire status_read_valid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 MON_STATUS RREADY" *)
    input wire status_read_ready,
    output wire rgb_writes_drained, packet_writes_drained, status_writes_drained, writes_drained, status_fault,
    output wire [31:0] rgb_completed_frames, packet_completed_frames, status_completed_frames
);
    wire rgb_fault, packet_fault, sg_fault;
    reg budget_ready;
    reg [63:0] rgb_closed_bytes, packet_closed_bytes, status_closed_bytes;
    always @(posedge aclk) begin
        if (!aresetn) begin
            budget_ready <= 0;
            rgb_closed_bytes <= 0;
            packet_closed_bytes <= 0;
            status_closed_bytes <= 0;
        end else begin
            budget_ready <= source_closed;
            rgb_closed_bytes <= RGB_BYTES * closed_frame_count;
            packet_closed_bytes <= PACKET_BYTES * closed_frame_count;
            status_closed_bytes <= 64'd4 * closed_frame_count;
        end
    end
    assign writes_drained = rgb_writes_drained && packet_writes_drained && status_writes_drained;
    assign status_fault = capture_fault || rgb_fault || packet_fault || sg_fault;
    vision_axi_write_drain #(.DATA_BYTES(DATA_BYTES), .EXPECTED_BYTES(RGB_BYTES), .CONTINUOUS(CONTINUOUS),
        .TRACK_FRAME_COMPLETIONS(TRACK_FRAME_COMPLETIONS)) rgb (
        .aclk(aclk), .aresetn(aresetn), .awvalid(rgb_address_valid), .awready(rgb_address_ready),
        .awlen(rgb_address_length), .wvalid(rgb_data_valid), .wready(rgb_data_ready),
        .wlast(rgb_data_last), .wstrb(rgb_data_strobes), .bvalid(rgb_response_valid),
        .bready(rgb_response_ready), .bresp(rgb_response_status), .upstream_fault(capture_fault),
        .source_closed(budget_ready), .closed_byte_count(rgb_closed_bytes),
        .writes_drained(rgb_writes_drained), .integrity_fault(rgb_fault), .acknowledged_frames(rgb_completed_frames)
    );
    vision_axi_write_drain #(.DATA_BYTES(DATA_BYTES), .EXPECTED_BYTES(PACKET_BYTES), .CONTINUOUS(CONTINUOUS),
        .TRACK_FRAME_COMPLETIONS(TRACK_FRAME_COMPLETIONS)) packet (
        .aclk(aclk), .aresetn(aresetn), .awvalid(packet_address_valid), .awready(packet_address_ready),
        .awlen(packet_address_length), .wvalid(packet_data_valid), .wready(packet_data_ready),
        .wlast(packet_data_last), .wstrb(packet_data_strobes), .bvalid(packet_response_valid),
        .bready(packet_response_ready), .bresp(packet_response_status), .upstream_fault(capture_fault),
        .source_closed(budget_ready), .closed_byte_count(packet_closed_bytes),
        .writes_drained(packet_writes_drained), .integrity_fault(packet_fault), .acknowledged_frames(packet_completed_frames)
    );
    if (SG_STATUS) begin : descriptor_status
        vision_axi_write_drain #(.DATA_BYTES(4), .EXPECTED_BYTES(4), .CONTINUOUS(CONTINUOUS),
            .TRACK_FRAME_COMPLETIONS(TRACK_FRAME_COMPLETIONS)) status (
            .aclk(aclk), .aresetn(aresetn), .awvalid(status_address_valid), .awready(status_address_ready),
            .awlen(status_address_length), .wvalid(status_data_valid), .wready(status_data_ready),
            .wlast(status_data_last), .wstrb(status_data_strobes), .bvalid(status_response_valid),
            .bready(status_response_ready), .bresp(status_response_status), .upstream_fault(capture_fault),
            .source_closed(budget_ready), .closed_byte_count(status_closed_bytes),
            .writes_drained(status_writes_drained), .integrity_fault(sg_fault), .acknowledged_frames(status_completed_frames)
        );
    end else begin : no_descriptor_status
        assign status_writes_drained = 1;
        assign sg_fault = 0;
        assign status_completed_frames = 0;
    end
endmodule