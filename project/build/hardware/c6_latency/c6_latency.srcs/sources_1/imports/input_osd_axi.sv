// Vivado module-reference wrapper; attach only in a NEW hardware candidate.
module input_osd_axi #(
    parameter integer WIDTH=1280, HEIGHT=720, RGB_PACKED=0
)(
    (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 s_axi_aclk CLK", X_INTERFACE_PARAMETER="XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000" *)
    input wire s_axi_aclk,
    (* X_INTERFACE_INFO="xilinx.com:signal:reset:1.0 s_axi_aresetn RST", X_INTERFACE_PARAMETER="POLARITY ACTIVE_LOW" *)
    input wire s_axi_aresetn,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI AWADDR", X_INTERFACE_PARAMETER="PROTOCOL AXI4LITE, DATA_WIDTH 32, ADDR_WIDTH 7, HAS_BURST 0, HAS_LOCK 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1" *)
    input wire [6:0] s_axi_awaddr,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI AWPROT" *) input wire [2:0] s_axi_awprot,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *) input wire s_axi_awvalid,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *) output wire s_axi_awready,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI WDATA" *) input wire [31:0] s_axi_wdata,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *) input wire [3:0] s_axi_wstrb,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI WVALID" *) input wire s_axi_wvalid,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI WREADY" *) output wire s_axi_wready,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI BRESP" *) output wire [1:0] s_axi_bresp,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI BVALID" *) output wire s_axi_bvalid,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI BREADY" *) input wire s_axi_bready,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *) input wire [6:0] s_axi_araddr,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI ARPROT" *) input wire [2:0] s_axi_arprot,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *) input wire s_axi_arvalid,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *) output wire s_axi_arready,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI RDATA" *) output wire [31:0] s_axi_rdata,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI RRESP" *) output wire [1:0] s_axi_rresp,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI RVALID" *) output wire s_axi_rvalid,
    (* X_INTERFACE_INFO="xilinx.com:interface:aximm:1.0 S_AXI RREADY" *) input wire s_axi_rready,
    (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 pclk CLK", X_INTERFACE_PARAMETER="XIL_INTERFACENAME pclk, ASSOCIATED_RESET presetn, FREQ_HZ 74250000" *) input wire pclk,
    (* X_INTERFACE_INFO="xilinx.com:signal:reset:1.0 presetn RST", X_INTERFACE_PARAMETER="POLARITY ACTIVE_LOW" *) input wire presetn,
    input wire [23:0] in_rgb, input wire in_de, in_hs, in_vs,
    output wire [23:0] out_rgb, output wire out_de, out_hs, out_vs
);
    input_osd_top #(.WIDTH(WIDTH),.HEIGHT(HEIGHT),.RGB_PACKED(RGB_PACKED)) impl(
        .aclk(s_axi_aclk),.aresetn(s_axi_aresetn),.pclk(pclk),.presetn(presetn),
        .awaddr(s_axi_awaddr),.awvalid(s_axi_awvalid),.awready(s_axi_awready),
        .wdata(s_axi_wdata),.wstrb(s_axi_wstrb),.wvalid(s_axi_wvalid),.wready(s_axi_wready),
        .bresp(s_axi_bresp),.bvalid(s_axi_bvalid),.bready(s_axi_bready),
        .araddr(s_axi_araddr),.arvalid(s_axi_arvalid),.arready(s_axi_arready),
        .rdata(s_axi_rdata),.rresp(s_axi_rresp),.rvalid(s_axi_rvalid),.rready(s_axi_rready),
        .in_rgb(in_rgb),.in_de(in_de),.in_hs(in_hs),.in_vs(in_vs),
        .out_rgb(out_rgb),.out_de(out_de),.out_hs(out_hs),.out_vs(out_vs));
endmodule
