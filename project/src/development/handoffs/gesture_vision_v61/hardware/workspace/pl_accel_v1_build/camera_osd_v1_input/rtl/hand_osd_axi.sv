// Vivado module-reference wrapper. Either external reset resets BOTH domains.
// AXI address window is 128 bytes; unused upper half returns SLVERR, no aliases.
module hand_osd_axi #(
    parameter integer WIDTH=1280, HEIGHT=720,
    parameter integer BOX_THICKNESS=2, CROSS_RADIUS=8,
    parameter integer BGR_PACKED=0, STALE_CYCLES=74250000
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
    (* X_INTERFACE_INFO="xilinx.com:signal:clock:1.0 video_aclk CLK", X_INTERFACE_PARAMETER="XIL_INTERFACENAME video_aclk, ASSOCIATED_BUSIF S_AXIS:M_AXIS, ASSOCIATED_RESET video_aresetn, FREQ_HZ 74250000" *) input wire video_aclk,
    (* X_INTERFACE_INFO="xilinx.com:signal:reset:1.0 video_aresetn RST", X_INTERFACE_PARAMETER="POLARITY ACTIVE_LOW" *) input wire video_aresetn,
    (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TDATA", X_INTERFACE_PARAMETER="TDATA_NUM_BYTES 3, HAS_TREADY 1, HAS_TLAST 1, TUSER_WIDTH 1" *) input wire [23:0] s_axis_tdata,
    (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TVALID" *) input wire s_axis_tvalid,
    (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TREADY" *) output wire s_axis_tready,
    (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TUSER" *) input wire s_axis_tuser,
    (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 S_AXIS TLAST" *) input wire s_axis_tlast,
    (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 M_AXIS TDATA", X_INTERFACE_PARAMETER="TDATA_NUM_BYTES 3, HAS_TREADY 1, HAS_TLAST 1, TUSER_WIDTH 1" *) output wire [23:0] m_axis_tdata,
    (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 M_AXIS TVALID" *) output wire m_axis_tvalid,
    (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 M_AXIS TREADY" *) input wire m_axis_tready,
    (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 M_AXIS TUSER" *) output wire m_axis_tuser,
    (* X_INTERFACE_INFO="xilinx.com:interface:axis:1.0 M_AXIS TLAST" *) output wire m_axis_tlast,
    output wire [31:0] displayed_result_frame_id
);
    // Synchronize each reset source independently BEFORE combining them.
    // No combinational logic precedes any asynchronous CLR input. Either
    // source asserts both domains; release requires two destination edges.
    (* ASYNC_REG="TRUE" *) reg [1:0] control_axi_release,control_video_release;
    (* ASYNC_REG="TRUE" *) reg [1:0] video_axi_release,video_video_release;
    always @(posedge s_axi_aclk or negedge s_axi_aresetn)
        if(!s_axi_aresetn) control_axi_release<=0;
        else control_axi_release<={control_axi_release[0],1'b1};
    always @(posedge s_axi_aclk or negedge video_aresetn)
        if(!video_aresetn) control_video_release<=0;
        else control_video_release<={control_video_release[0],1'b1};
    always @(posedge video_aclk or negedge s_axi_aresetn)
        if(!s_axi_aresetn) video_axi_release<=0;
        else video_axi_release<={video_axi_release[0],1'b1};
    always @(posedge video_aclk or negedge video_aresetn)
        if(!video_aresetn) video_video_release<=0;
        else video_video_release<={video_video_release[0],1'b1};
    wire control_resetn=control_axi_release[1] && control_video_release[1];
    wire video_resetn=video_axi_release[1] && video_video_release[1];
    wire en,bv,cv; wire [1:0] state;
    wire [15:0] x0,y0,x1,y1,cx,cy; wire [31:0] fid;
    axi_hand_osd_ctrl #(.STALE_CYCLES(STALE_CYCLES)) ctrl(
        .s_axi_aclk(s_axi_aclk),.s_axi_aresetn(control_resetn),
        .s_axi_awaddr(s_axi_awaddr[6] ? 6'h24 : s_axi_awaddr[5:0]),.s_axi_awvalid(s_axi_awvalid),.s_axi_awready(s_axi_awready),
        .s_axi_wdata(s_axi_wdata),.s_axi_wstrb(s_axi_wstrb),.s_axi_wvalid(s_axi_wvalid),.s_axi_wready(s_axi_wready),
        .s_axi_bresp(s_axi_bresp),.s_axi_bvalid(s_axi_bvalid),.s_axi_bready(s_axi_bready),
        .s_axi_araddr(s_axi_araddr[6] ? 6'h24 : s_axi_araddr[5:0]),.s_axi_arvalid(s_axi_arvalid),.s_axi_arready(s_axi_arready),
        .s_axi_rdata(s_axi_rdata),.s_axi_rresp(s_axi_rresp),.s_axi_rvalid(s_axi_rvalid),.s_axi_rready(s_axi_rready),
        .video_aclk(video_aclk),.video_aresetn(video_resetn),
        .video_sof_accept(s_axis_tvalid && s_axis_tready && s_axis_tuser),
        .cfg_enable(en),.cfg_bbox_valid(bv),.cfg_centroid_valid(cv),.cfg_state(state),
        .cfg_x0(x0),.cfg_y0(y0),.cfg_x1(x1),.cfg_y1(y1),.cfg_cx(cx),.cfg_cy(cy),.cfg_result_frame_id(fid));
    axis_hand_osd #(.WIDTH(WIDTH),.HEIGHT(HEIGHT),.BOX_THICKNESS(BOX_THICKNESS),.CROSS_RADIUS(CROSS_RADIUS),.BGR_PACKED(BGR_PACKED)) osd(
        .aclk(video_aclk),.aresetn(video_resetn),
        .s_axis_tdata(s_axis_tdata),.s_axis_tvalid(s_axis_tvalid),.s_axis_tready(s_axis_tready),.s_axis_tuser(s_axis_tuser),.s_axis_tlast(s_axis_tlast),
        .m_axis_tdata(m_axis_tdata),.m_axis_tvalid(m_axis_tvalid),.m_axis_tready(m_axis_tready),.m_axis_tuser(m_axis_tuser),.m_axis_tlast(m_axis_tlast),
        .cfg_enable(en),.cfg_bbox_valid(bv),.cfg_centroid_valid(cv),.cfg_state(state),
        .cfg_x0(x0),.cfg_y0(y0),.cfg_x1(x1),.cfg_y1(y1),.cfg_cx(cx),.cfg_cy(cy),
        .cfg_result_frame_id(fid),.displayed_result_frame_id(displayed_result_frame_id));
endmodule
