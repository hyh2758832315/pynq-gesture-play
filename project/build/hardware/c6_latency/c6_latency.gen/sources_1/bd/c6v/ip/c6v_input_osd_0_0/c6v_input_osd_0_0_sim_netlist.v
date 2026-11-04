// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Fri Oct 30 22:03:43 2026
// Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_input_osd_0_0/c6v_input_osd_0_0_sim_netlist.v
// Design      : c6v_input_osd_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "c6v_input_osd_0_0,input_osd_axi,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "input_osd_axi,Vivado 2026.1" *) 
(* NotValidForBitStream *)
module c6v_input_osd_0_0
   (s_axi_aclk,
    s_axi_aresetn,
    s_axi_awaddr,
    s_axi_awprot,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_araddr,
    s_axi_arprot,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rvalid,
    s_axi_rready,
    pclk,
    presetn,
    in_rgb,
    in_de,
    in_hs,
    in_vs,
    out_rgb,
    out_de,
    out_hs,
    out_vs);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axi_aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input s_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axi_aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s_axi_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI, PROTOCOL AXI4LITE, DATA_WIDTH 32, ADDR_WIDTH 7, HAS_BURST 0, HAS_LOCK 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, FREQ_HZ 100000000, ID_WIDTH 0, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_PROT 1, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input [6:0]s_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWPROT" *) input [2:0]s_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *) input s_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *) output s_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *) input [31:0]s_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *) input [3:0]s_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *) input s_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *) output s_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *) output [1:0]s_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *) output s_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *) input s_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *) input [6:0]s_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARPROT" *) input [2:0]s_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *) input s_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *) output s_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *) output [31:0]s_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *) output [1:0]s_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *) output s_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *) input s_axi_rready;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 pclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME pclk, ASSOCIATED_RESET presetn, FREQ_HZ 74250000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /pixel_clock_clk_out1, INSERT_VIP 0" *) input pclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 presetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME presetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input presetn;
  input [23:0]in_rgb;
  input in_de;
  input in_hs;
  input in_vs;
  output [23:0]out_rgb;
  output out_de;
  output out_hs;
  output out_vs;

  wire \<const0> ;
  wire in_de;
  wire in_hs;
  wire [23:0]in_rgb;
  wire in_vs;
  wire out_de;
  wire out_hs;
  wire [23:0]out_rgb;
  wire out_vs;
  wire pclk;
  wire presetn;
  wire s_axi_aclk;
  wire [6:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [6:0]s_axi_awaddr;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire [1:1]\^s_axi_bresp ;
  wire s_axi_bvalid;
  wire [31:0]s_axi_rdata;
  wire s_axi_rready;
  wire [1:1]\^s_axi_rresp ;
  wire s_axi_rvalid;
  wire [31:0]s_axi_wdata;
  wire s_axi_wready;
  wire [3:0]s_axi_wstrb;
  wire s_axi_wvalid;

  assign s_axi_bresp[1] = \^s_axi_bresp [1];
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_rresp[1] = \^s_axi_rresp [1];
  assign s_axi_rresp[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  c6v_input_osd_0_0_input_osd_axi inst
       (.bvalid_reg(s_axi_bvalid),
        .in_de(in_de),
        .in_hs(in_hs),
        .in_rgb(in_rgb),
        .in_vs(in_vs),
        .out_de(out_de),
        .out_hs(out_hs),
        .out_rgb(out_rgb),
        .out_vs(out_vs),
        .pclk(pclk),
        .presetn(presetn),
        .rvalid_reg(s_axi_rvalid),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bresp(\^s_axi_bresp ),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rready(s_axi_rready),
        .s_axi_rresp(\^s_axi_rresp ),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "input_osd_axi" *) 
module c6v_input_osd_0_0_input_osd_axi
   (rvalid_reg,
    bvalid_reg,
    s_axi_rdata,
    s_axi_rresp,
    out_rgb,
    out_de,
    out_hs,
    out_vs,
    s_axi_awready,
    s_axi_wready,
    s_axi_arready,
    s_axi_bresp,
    s_axi_araddr,
    s_axi_arvalid,
    s_axi_wvalid,
    s_axi_awvalid,
    in_vs,
    in_de,
    s_axi_awaddr,
    s_axi_aclk,
    s_axi_wdata,
    s_axi_wstrb,
    pclk,
    in_rgb,
    in_hs,
    presetn,
    s_axi_aresetn,
    s_axi_bready,
    s_axi_rready);
  output rvalid_reg;
  output bvalid_reg;
  output [31:0]s_axi_rdata;
  output [0:0]s_axi_rresp;
  output [23:0]out_rgb;
  output out_de;
  output out_hs;
  output out_vs;
  output s_axi_awready;
  output s_axi_wready;
  output s_axi_arready;
  output [0:0]s_axi_bresp;
  input [6:0]s_axi_araddr;
  input s_axi_arvalid;
  input s_axi_wvalid;
  input s_axi_awvalid;
  input in_vs;
  input in_de;
  input [6:0]s_axi_awaddr;
  input s_axi_aclk;
  input [31:0]s_axi_wdata;
  input [3:0]s_axi_wstrb;
  input pclk;
  input [23:0]in_rgb;
  input in_hs;
  input presetn;
  input s_axi_aresetn;
  input s_axi_bready;
  input s_axi_rready;

  wire \bresp[1]_i_2_n_0 ;
  wire bvalid_i_1_n_0;
  wire bvalid_reg;
  wire [1:0]\ctrl/aw_addr ;
  wire \ctrl/aw_held ;
  wire \ctrl/mailbox116_out ;
  wire \ctrl/p_0_in ;
  wire \ctrl/pending ;
  wire impl_n_1;
  wire impl_n_7;
  wire impl_n_72;
  wire impl_n_76;
  wire in_de;
  wire in_hs;
  wire [23:0]in_rgb;
  wire in_vs;
  wire out_de;
  wire out_hs;
  wire [23:0]out_rgb;
  wire out_vs;
  wire pclk;
  wire pending_i_1_n_0;
  wire \pixels/vs_prev ;
  wire presetn;
  wire rvalid_i_1_n_0;
  wire rvalid_reg;
  wire s_axi_aclk;
  wire [6:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [6:0]s_axi_awaddr;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire [0:0]s_axi_bresp;
  wire [31:0]s_axi_rdata;
  wire s_axi_rready;
  wire [0:0]s_axi_rresp;
  wire [31:0]s_axi_wdata;
  wire s_axi_wready;
  wire [3:0]s_axi_wstrb;
  wire s_axi_wvalid;

  LUT6 #(
    .INIT(64'hEFEEFFFFEFEE0000)) 
    \bresp[1]_i_2 
       (.I0(\ctrl/aw_addr [1]),
        .I1(\ctrl/aw_addr [0]),
        .I2(impl_n_76),
        .I3(impl_n_72),
        .I4(\ctrl/mailbox116_out ),
        .I5(s_axi_bresp),
        .O(\bresp[1]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h7444)) 
    bvalid_i_1
       (.I0(s_axi_bready),
        .I1(bvalid_reg),
        .I2(impl_n_7),
        .I3(\ctrl/aw_held ),
        .O(bvalid_i_1_n_0));
  c6v_input_osd_0_0_input_osd_top impl
       (.Q(\ctrl/aw_addr ),
        .ack_toggle_reg(impl_n_1),
        .\aw_addr_reg[5] (impl_n_72),
        .aw_held(\ctrl/aw_held ),
        .\bresp_reg[1] (\bresp[1]_i_2_n_0 ),
        .bvalid_reg(bvalid_reg),
        .bvalid_reg_0(bvalid_i_1_n_0),
        .in_de(in_de),
        .in_hs(in_hs),
        .in_rgb(in_rgb),
        .in_vs(in_vs),
        .mailbox116_out(\ctrl/mailbox116_out ),
        .out(\ctrl/p_0_in ),
        .out_de(out_de),
        .out_hs(out_hs),
        .out_rgb(out_rgb),
        .out_vs(out_vs),
        .pclk(pclk),
        .pending(\ctrl/pending ),
        .pending_reg(pending_i_1_n_0),
        .presetn(presetn),
        .rvalid_reg(rvalid_reg),
        .rvalid_reg_0(rvalid_i_1_n_0),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .vs_prev(\pixels/vs_prev ),
        .\w_data_reg[0] (impl_n_76),
        .w_held_reg(impl_n_7));
  LUT5 #(
    .INIT(32'hFF0F6666)) 
    pending_i_1
       (.I0(\ctrl/p_0_in ),
        .I1(impl_n_1),
        .I2(in_vs),
        .I3(\pixels/vs_prev ),
        .I4(\ctrl/pending ),
        .O(pending_i_1_n_0));
  LUT3 #(
    .INIT(8'h74)) 
    rvalid_i_1
       (.I0(s_axi_rready),
        .I1(rvalid_reg),
        .I2(s_axi_arvalid),
        .O(rvalid_i_1_n_0));
endmodule

(* ORIG_REF_NAME = "input_osd_ctrl" *) 
module c6v_input_osd_0_0_input_osd_ctrl
   (out,
    \pp_release_reg[1] ,
    ack_toggle_reg_0,
    bvalid_reg_0,
    w_held_reg_0,
    aw_held_reg_0,
    pending_reg_0,
    s_axi_bresp,
    rvalid_reg_0,
    hand10,
    Q,
    S,
    \active_cfg_reg[57]_0 ,
    \active_cfg_reg[57]_1 ,
    \active_cfg_reg[39]_0 ,
    \active_cfg_reg[42]_0 ,
    \aw_addr_reg[1]_0 ,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_awready,
    \aw_addr_reg[5]_0 ,
    mailbox116_out,
    s_axi_wready,
    s_axi_arready,
    \w_data_reg[0]_0 ,
    pclk,
    s_axi_aclk,
    bvalid_reg_1,
    pending_reg_1,
    \bresp_reg[1]_0 ,
    rvalid_reg_1,
    s_axi_araddr,
    rvalid_reg_2,
    rvalid_reg_3,
    s_axi_arvalid,
    s_axi_wvalid,
    s_axi_awvalid,
    \hand_left_reg[0]_0 ,
    \hand_left_reg[0]_1 ,
    in_vs,
    ack_toggle_reg_1,
    \dy1_reg[9] ,
    dx12_carry__0,
    s_axi_awaddr,
    s_axi_wdata,
    s_axi_wstrb);
  output out;
  output \pp_release_reg[1] ;
  output ack_toggle_reg_0;
  output bvalid_reg_0;
  output w_held_reg_0;
  output aw_held_reg_0;
  output pending_reg_0;
  output [0:0]s_axi_bresp;
  output rvalid_reg_0;
  output hand10;
  output [22:0]Q;
  output [3:0]S;
  output [0:0]\active_cfg_reg[57]_0 ;
  output [0:0]\active_cfg_reg[57]_1 ;
  output [3:0]\active_cfg_reg[39]_0 ;
  output [1:0]\active_cfg_reg[42]_0 ;
  output [1:0]\aw_addr_reg[1]_0 ;
  output [31:0]s_axi_rdata;
  output [0:0]s_axi_rresp;
  output s_axi_awready;
  output \aw_addr_reg[5]_0 ;
  output mailbox116_out;
  output s_axi_wready;
  output s_axi_arready;
  output \w_data_reg[0]_0 ;
  input pclk;
  input s_axi_aclk;
  input bvalid_reg_1;
  input pending_reg_1;
  input \bresp_reg[1]_0 ;
  input rvalid_reg_1;
  input [6:0]s_axi_araddr;
  input [0:0]rvalid_reg_2;
  input [0:0]rvalid_reg_3;
  input s_axi_arvalid;
  input s_axi_wvalid;
  input s_axi_awvalid;
  input [0:0]\hand_left_reg[0]_0 ;
  input [0:0]\hand_left_reg[0]_1 ;
  input in_vs;
  input ack_toggle_reg_1;
  input [9:0]\dy1_reg[9] ;
  input [10:0]dx12_carry__0;
  input [6:0]s_axi_awaddr;
  input [31:0]s_axi_wdata;
  input [3:0]s_axi_wstrb;

  wire [22:0]Q;
  wire [3:0]S;
  (* async_reg = "true" *) wire ack_meta;
  (* async_reg = "true" *) wire ack_sync;
  wire ack_toggle_reg_0;
  wire ack_toggle_reg_1;
  wire \active_cfg[159]_i_1_n_0 ;
  wire [3:0]\active_cfg_reg[39]_0 ;
  wire [1:0]\active_cfg_reg[42]_0 ;
  wire [0:0]\active_cfg_reg[57]_0 ;
  wire [0:0]\active_cfg_reg[57]_1 ;
  wire [6:2]aw_addr;
  wire [1:0]\aw_addr_reg[1]_0 ;
  wire \aw_addr_reg[5]_0 ;
  wire aw_held0;
  wire aw_held_i_1_n_0;
  wire aw_held_reg_0;
  wire \bresp[1]_i_1_n_0 ;
  wire \bresp[1]_i_6_n_0 ;
  wire \bresp_reg[1]_0 ;
  wire bvalid_reg_0;
  wire bvalid_reg_1;
  wire [159:1]cfg;
  wire [10:0]dx12_carry__0;
  wire [9:0]\dy1_reg[9] ;
  wire hand10;
  wire hand1_i_2_n_0;
  wire hand1_i_3_n_0;
  wire [0:0]hand_left;
  wire hand_left1_carry__0_i_1_n_0;
  wire hand_left1_carry__0_i_2_n_0;
  wire hand_left1_carry__0_i_3_n_0;
  wire hand_left1_carry__0_i_4_n_0;
  wire hand_left1_carry__0_n_0;
  wire hand_left1_carry__0_n_1;
  wire hand_left1_carry__0_n_2;
  wire hand_left1_carry__0_n_3;
  wire hand_left1_carry__1_i_1_n_0;
  wire hand_left1_carry__1_i_2_n_0;
  wire hand_left1_carry__1_i_3_n_0;
  wire hand_left1_carry__1_n_1;
  wire hand_left1_carry__1_n_2;
  wire hand_left1_carry__1_n_3;
  wire hand_left1_carry_i_1_n_0;
  wire hand_left1_carry_i_2_n_0;
  wire hand_left1_carry_i_3_n_0;
  wire hand_left1_carry_i_4_n_0;
  wire hand_left1_carry_n_0;
  wire hand_left1_carry_n_1;
  wire hand_left1_carry_n_2;
  wire hand_left1_carry_n_3;
  wire \hand_left[0]_i_1_n_0 ;
  wire \hand_left[1]_i_1_n_0 ;
  wire \hand_left[2]_i_1_n_0 ;
  wire \hand_left[3]_i_1_n_0 ;
  wire \hand_left[3]_i_2_n_0 ;
  wire \hand_left[3]_i_3_n_0 ;
  wire \hand_left[3]_i_4_n_0 ;
  wire \hand_left[4]_i_2_n_0 ;
  wire \hand_left[5]_i_2_n_0 ;
  wire \hand_left[7]_i_1_n_0 ;
  wire \hand_left[7]_i_4_n_0 ;
  wire \hand_left[7]_i_5_n_0 ;
  wire \hand_left[7]_i_6_n_0 ;
  wire \hand_left[7]_i_7_n_0 ;
  wire [0:0]\hand_left_reg[0]_0 ;
  wire [0:0]\hand_left_reg[0]_1 ;
  wire \hand_left_reg_n_0_[0] ;
  wire \hand_left_reg_n_0_[1] ;
  wire \hand_left_reg_n_0_[2] ;
  wire \hand_left_reg_n_0_[3] ;
  wire \hand_left_reg_n_0_[4] ;
  wire \hand_left_reg_n_0_[5] ;
  wire \hand_left_reg_n_0_[6] ;
  wire \hand_left_reg_n_0_[7] ;
  wire in_vs;
  wire mailbox116_out;
  wire \mailbox[159]_i_2_n_0 ;
  wire \mailbox[159]_i_3_n_0 ;
  wire \mailbox_reg_n_0_[0] ;
  wire \mailbox_reg_n_0_[112] ;
  wire \mailbox_reg_n_0_[113] ;
  wire \mailbox_reg_n_0_[114] ;
  wire \mailbox_reg_n_0_[115] ;
  wire \mailbox_reg_n_0_[116] ;
  wire \mailbox_reg_n_0_[117] ;
  wire \mailbox_reg_n_0_[118] ;
  wire \mailbox_reg_n_0_[119] ;
  wire \mailbox_reg_n_0_[128] ;
  wire \mailbox_reg_n_0_[129] ;
  wire \mailbox_reg_n_0_[130] ;
  wire \mailbox_reg_n_0_[131] ;
  wire \mailbox_reg_n_0_[132] ;
  wire \mailbox_reg_n_0_[133] ;
  wire \mailbox_reg_n_0_[134] ;
  wire \mailbox_reg_n_0_[135] ;
  wire \mailbox_reg_n_0_[136] ;
  wire \mailbox_reg_n_0_[137] ;
  wire \mailbox_reg_n_0_[138] ;
  wire \mailbox_reg_n_0_[139] ;
  wire \mailbox_reg_n_0_[140] ;
  wire \mailbox_reg_n_0_[141] ;
  wire \mailbox_reg_n_0_[142] ;
  wire \mailbox_reg_n_0_[143] ;
  wire \mailbox_reg_n_0_[144] ;
  wire \mailbox_reg_n_0_[145] ;
  wire \mailbox_reg_n_0_[146] ;
  wire \mailbox_reg_n_0_[147] ;
  wire \mailbox_reg_n_0_[148] ;
  wire \mailbox_reg_n_0_[149] ;
  wire \mailbox_reg_n_0_[150] ;
  wire \mailbox_reg_n_0_[151] ;
  wire \mailbox_reg_n_0_[152] ;
  wire \mailbox_reg_n_0_[153] ;
  wire \mailbox_reg_n_0_[154] ;
  wire \mailbox_reg_n_0_[155] ;
  wire \mailbox_reg_n_0_[156] ;
  wire \mailbox_reg_n_0_[157] ;
  wire \mailbox_reg_n_0_[158] ;
  wire \mailbox_reg_n_0_[159] ;
  wire \mailbox_reg_n_0_[1] ;
  wire \mailbox_reg_n_0_[2] ;
  wire \mailbox_reg_n_0_[32] ;
  wire \mailbox_reg_n_0_[33] ;
  wire \mailbox_reg_n_0_[34] ;
  wire \mailbox_reg_n_0_[35] ;
  wire \mailbox_reg_n_0_[36] ;
  wire \mailbox_reg_n_0_[37] ;
  wire \mailbox_reg_n_0_[38] ;
  wire \mailbox_reg_n_0_[39] ;
  wire \mailbox_reg_n_0_[40] ;
  wire \mailbox_reg_n_0_[41] ;
  wire \mailbox_reg_n_0_[42] ;
  wire \mailbox_reg_n_0_[48] ;
  wire \mailbox_reg_n_0_[49] ;
  wire \mailbox_reg_n_0_[50] ;
  wire \mailbox_reg_n_0_[51] ;
  wire \mailbox_reg_n_0_[52] ;
  wire \mailbox_reg_n_0_[53] ;
  wire \mailbox_reg_n_0_[54] ;
  wire \mailbox_reg_n_0_[55] ;
  wire \mailbox_reg_n_0_[56] ;
  wire \mailbox_reg_n_0_[57] ;
  wire [31:0]p_1_in;
  wire [7:4]p_2_in;
  wire pclk;
  wire \pending_cfg[159]_i_1_n_0 ;
  wire \pending_cfg_reg_n_0_[0] ;
  wire \pending_cfg_reg_n_0_[112] ;
  wire \pending_cfg_reg_n_0_[113] ;
  wire \pending_cfg_reg_n_0_[114] ;
  wire \pending_cfg_reg_n_0_[115] ;
  wire \pending_cfg_reg_n_0_[116] ;
  wire \pending_cfg_reg_n_0_[117] ;
  wire \pending_cfg_reg_n_0_[118] ;
  wire \pending_cfg_reg_n_0_[119] ;
  wire \pending_cfg_reg_n_0_[1] ;
  wire \pending_cfg_reg_n_0_[2] ;
  wire \pending_cfg_reg_n_0_[32] ;
  wire \pending_cfg_reg_n_0_[33] ;
  wire \pending_cfg_reg_n_0_[34] ;
  wire \pending_cfg_reg_n_0_[35] ;
  wire \pending_cfg_reg_n_0_[36] ;
  wire \pending_cfg_reg_n_0_[37] ;
  wire \pending_cfg_reg_n_0_[38] ;
  wire \pending_cfg_reg_n_0_[39] ;
  wire \pending_cfg_reg_n_0_[40] ;
  wire \pending_cfg_reg_n_0_[41] ;
  wire \pending_cfg_reg_n_0_[42] ;
  wire \pending_cfg_reg_n_0_[48] ;
  wire \pending_cfg_reg_n_0_[49] ;
  wire \pending_cfg_reg_n_0_[50] ;
  wire \pending_cfg_reg_n_0_[51] ;
  wire \pending_cfg_reg_n_0_[52] ;
  wire \pending_cfg_reg_n_0_[53] ;
  wire \pending_cfg_reg_n_0_[54] ;
  wire \pending_cfg_reg_n_0_[55] ;
  wire \pending_cfg_reg_n_0_[56] ;
  wire \pending_cfg_reg_n_0_[57] ;
  wire pending_reg_0;
  wire pending_reg_1;
  wire \pp_release_reg[1] ;
  wire \rdata[0]_i_1_n_0 ;
  wire \rdata[0]_i_2_n_0 ;
  wire \rdata[0]_i_3_n_0 ;
  wire \rdata[0]_i_4_n_0 ;
  wire \rdata[0]_i_5_n_0 ;
  wire \rdata[10]_i_1_n_0 ;
  wire \rdata[10]_i_2_n_0 ;
  wire \rdata[10]_i_3_n_0 ;
  wire \rdata[10]_i_4_n_0 ;
  wire \rdata[10]_i_5_n_0 ;
  wire \rdata[11]_i_1_n_0 ;
  wire \rdata[11]_i_2_n_0 ;
  wire \rdata[11]_i_3_n_0 ;
  wire \rdata[12]_i_1_n_0 ;
  wire \rdata[12]_i_2_n_0 ;
  wire \rdata[12]_i_3_n_0 ;
  wire \rdata[13]_i_1_n_0 ;
  wire \rdata[13]_i_2_n_0 ;
  wire \rdata[13]_i_3_n_0 ;
  wire \rdata[14]_i_1_n_0 ;
  wire \rdata[14]_i_2_n_0 ;
  wire \rdata[14]_i_3_n_0 ;
  wire \rdata[14]_i_4_n_0 ;
  wire \rdata[15]_i_1_n_0 ;
  wire \rdata[15]_i_2_n_0 ;
  wire \rdata[15]_i_3_n_0 ;
  wire \rdata[16]_i_1_n_0 ;
  wire \rdata[16]_i_2_n_0 ;
  wire \rdata[16]_i_3_n_0 ;
  wire \rdata[16]_i_4_n_0 ;
  wire \rdata[17]_i_1_n_0 ;
  wire \rdata[17]_i_2_n_0 ;
  wire \rdata[17]_i_3_n_0 ;
  wire \rdata[18]_i_1_n_0 ;
  wire \rdata[18]_i_2_n_0 ;
  wire \rdata[18]_i_3_n_0 ;
  wire \rdata[19]_i_1_n_0 ;
  wire \rdata[19]_i_2_n_0 ;
  wire \rdata[19]_i_3_n_0 ;
  wire \rdata[1]_i_1_n_0 ;
  wire \rdata[1]_i_2_n_0 ;
  wire \rdata[1]_i_3_n_0 ;
  wire \rdata[20]_i_1_n_0 ;
  wire \rdata[20]_i_2_n_0 ;
  wire \rdata[20]_i_3_n_0 ;
  wire \rdata[20]_i_4_n_0 ;
  wire \rdata[21]_i_1_n_0 ;
  wire \rdata[21]_i_2_n_0 ;
  wire \rdata[21]_i_3_n_0 ;
  wire \rdata[22]_i_1_n_0 ;
  wire \rdata[22]_i_2_n_0 ;
  wire \rdata[22]_i_3_n_0 ;
  wire \rdata[22]_i_4_n_0 ;
  wire \rdata[23]_i_1_n_0 ;
  wire \rdata[23]_i_2_n_0 ;
  wire \rdata[23]_i_3_n_0 ;
  wire \rdata[24]_i_1_n_0 ;
  wire \rdata[24]_i_2_n_0 ;
  wire \rdata[24]_i_3_n_0 ;
  wire \rdata[25]_i_1_n_0 ;
  wire \rdata[25]_i_2_n_0 ;
  wire \rdata[25]_i_3_n_0 ;
  wire \rdata[26]_i_1_n_0 ;
  wire \rdata[26]_i_2_n_0 ;
  wire \rdata[26]_i_3_n_0 ;
  wire \rdata[27]_i_1_n_0 ;
  wire \rdata[27]_i_2_n_0 ;
  wire \rdata[27]_i_3_n_0 ;
  wire \rdata[27]_i_4_n_0 ;
  wire \rdata[27]_i_5_n_0 ;
  wire \rdata[28]_i_1_n_0 ;
  wire \rdata[28]_i_2_n_0 ;
  wire \rdata[28]_i_3_n_0 ;
  wire \rdata[29]_i_1_n_0 ;
  wire \rdata[29]_i_2_n_0 ;
  wire \rdata[29]_i_3_n_0 ;
  wire \rdata[2]_i_1_n_0 ;
  wire \rdata[2]_i_2_n_0 ;
  wire \rdata[2]_i_3_n_0 ;
  wire \rdata[30]_i_1_n_0 ;
  wire \rdata[30]_i_2_n_0 ;
  wire \rdata[30]_i_3_n_0 ;
  wire \rdata[30]_i_4_n_0 ;
  wire \rdata[31]_i_1_n_0 ;
  wire \rdata[31]_i_3_n_0 ;
  wire \rdata[31]_i_4_n_0 ;
  wire \rdata[31]_i_5_n_0 ;
  wire \rdata[31]_i_6_n_0 ;
  wire \rdata[3]_i_1_n_0 ;
  wire \rdata[3]_i_2_n_0 ;
  wire \rdata[3]_i_3_n_0 ;
  wire \rdata[4]_i_1_n_0 ;
  wire \rdata[4]_i_2_n_0 ;
  wire \rdata[4]_i_3_n_0 ;
  wire \rdata[5]_i_1_n_0 ;
  wire \rdata[5]_i_2_n_0 ;
  wire \rdata[5]_i_3_n_0 ;
  wire \rdata[6]_i_1_n_0 ;
  wire \rdata[6]_i_2_n_0 ;
  wire \rdata[6]_i_3_n_0 ;
  wire \rdata[7]_i_1_n_0 ;
  wire \rdata[7]_i_2_n_0 ;
  wire \rdata[7]_i_3_n_0 ;
  wire \rdata[8]_i_1_n_0 ;
  wire \rdata[8]_i_2_n_0 ;
  wire \rdata[8]_i_3_n_0 ;
  wire \rdata[9]_i_1_n_0 ;
  wire \rdata[9]_i_2_n_0 ;
  wire \rdata[9]_i_3_n_0 ;
  (* async_reg = "true" *) wire req_meta;
  (* async_reg = "true" *) wire req_sync;
  wire req_toggle6_out;
  wire req_toggle_i_1_n_0;
  wire req_toggle_reg_n_0;
  wire \rresp[1]_i_1_n_0 ;
  wire \rresp[1]_i_2_n_0 ;
  wire rvalid010_out;
  wire rvalid_reg_0;
  wire rvalid_reg_1;
  wire [0:0]rvalid_reg_2;
  wire [0:0]rvalid_reg_3;
  wire s_axi_aclk;
  wire [6:0]s_axi_araddr;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [6:0]s_axi_awaddr;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire [0:0]s_axi_bresp;
  wire [31:0]s_axi_rdata;
  wire [0:0]s_axi_rresp;
  wire [31:0]s_axi_wdata;
  wire s_axi_wready;
  wire [3:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire \shadow[0][15]_i_1_n_0 ;
  wire \shadow[0][23]_i_1_n_0 ;
  wire \shadow[0][31]_i_1_n_0 ;
  wire \shadow[0][31]_i_2_n_0 ;
  wire \shadow[0][31]_i_3_n_0 ;
  wire \shadow[0][7]_i_1_n_0 ;
  wire \shadow[1][15]_i_1_n_0 ;
  wire \shadow[1][23]_i_1_n_0 ;
  wire \shadow[1][31]_i_1_n_0 ;
  wire \shadow[1][31]_i_2_n_0 ;
  wire \shadow[1][7]_i_1_n_0 ;
  wire \shadow[2][15]_i_1_n_0 ;
  wire \shadow[2][23]_i_1_n_0 ;
  wire \shadow[2][31]_i_1_n_0 ;
  wire \shadow[2][31]_i_2_n_0 ;
  wire \shadow[2][7]_i_1_n_0 ;
  wire \shadow[3][15]_i_1_n_0 ;
  wire \shadow[3][23]_i_1_n_0 ;
  wire \shadow[3][31]_i_1_n_0 ;
  wire \shadow[3][31]_i_2_n_0 ;
  wire \shadow[3][7]_i_1_n_0 ;
  wire \shadow[4][15]_i_1_n_0 ;
  wire \shadow[4][23]_i_1_n_0 ;
  wire \shadow[4][31]_i_1_n_0 ;
  wire \shadow[4][31]_i_2_n_0 ;
  wire \shadow[4][7]_i_1_n_0 ;
  wire \shadow[5][15]_i_1_n_0 ;
  wire \shadow[5][23]_i_1_n_0 ;
  wire \shadow[5][31]_i_1_n_0 ;
  wire \shadow[5][31]_i_2_n_0 ;
  wire \shadow[5][7]_i_1_n_0 ;
  wire \shadow_reg_n_0_[0][0] ;
  wire \shadow_reg_n_0_[0][10] ;
  wire \shadow_reg_n_0_[0][11] ;
  wire \shadow_reg_n_0_[0][12] ;
  wire \shadow_reg_n_0_[0][13] ;
  wire \shadow_reg_n_0_[0][14] ;
  wire \shadow_reg_n_0_[0][15] ;
  wire \shadow_reg_n_0_[0][16] ;
  wire \shadow_reg_n_0_[0][17] ;
  wire \shadow_reg_n_0_[0][18] ;
  wire \shadow_reg_n_0_[0][19] ;
  wire \shadow_reg_n_0_[0][1] ;
  wire \shadow_reg_n_0_[0][20] ;
  wire \shadow_reg_n_0_[0][21] ;
  wire \shadow_reg_n_0_[0][22] ;
  wire \shadow_reg_n_0_[0][23] ;
  wire \shadow_reg_n_0_[0][24] ;
  wire \shadow_reg_n_0_[0][25] ;
  wire \shadow_reg_n_0_[0][26] ;
  wire \shadow_reg_n_0_[0][27] ;
  wire \shadow_reg_n_0_[0][28] ;
  wire \shadow_reg_n_0_[0][29] ;
  wire \shadow_reg_n_0_[0][2] ;
  wire \shadow_reg_n_0_[0][30] ;
  wire \shadow_reg_n_0_[0][31] ;
  wire \shadow_reg_n_0_[0][3] ;
  wire \shadow_reg_n_0_[0][4] ;
  wire \shadow_reg_n_0_[0][5] ;
  wire \shadow_reg_n_0_[0][6] ;
  wire \shadow_reg_n_0_[0][7] ;
  wire \shadow_reg_n_0_[0][8] ;
  wire \shadow_reg_n_0_[0][9] ;
  wire \shadow_reg_n_0_[1][0] ;
  wire \shadow_reg_n_0_[1][10] ;
  wire \shadow_reg_n_0_[1][11] ;
  wire \shadow_reg_n_0_[1][12] ;
  wire \shadow_reg_n_0_[1][13] ;
  wire \shadow_reg_n_0_[1][14] ;
  wire \shadow_reg_n_0_[1][15] ;
  wire \shadow_reg_n_0_[1][16] ;
  wire \shadow_reg_n_0_[1][17] ;
  wire \shadow_reg_n_0_[1][18] ;
  wire \shadow_reg_n_0_[1][19] ;
  wire \shadow_reg_n_0_[1][1] ;
  wire \shadow_reg_n_0_[1][20] ;
  wire \shadow_reg_n_0_[1][21] ;
  wire \shadow_reg_n_0_[1][22] ;
  wire \shadow_reg_n_0_[1][23] ;
  wire \shadow_reg_n_0_[1][24] ;
  wire \shadow_reg_n_0_[1][25] ;
  wire \shadow_reg_n_0_[1][26] ;
  wire \shadow_reg_n_0_[1][27] ;
  wire \shadow_reg_n_0_[1][28] ;
  wire \shadow_reg_n_0_[1][29] ;
  wire \shadow_reg_n_0_[1][2] ;
  wire \shadow_reg_n_0_[1][30] ;
  wire \shadow_reg_n_0_[1][31] ;
  wire \shadow_reg_n_0_[1][3] ;
  wire \shadow_reg_n_0_[1][4] ;
  wire \shadow_reg_n_0_[1][5] ;
  wire \shadow_reg_n_0_[1][6] ;
  wire \shadow_reg_n_0_[1][7] ;
  wire \shadow_reg_n_0_[1][8] ;
  wire \shadow_reg_n_0_[1][9] ;
  wire \shadow_reg_n_0_[2][0] ;
  wire \shadow_reg_n_0_[2][10] ;
  wire \shadow_reg_n_0_[2][11] ;
  wire \shadow_reg_n_0_[2][12] ;
  wire \shadow_reg_n_0_[2][13] ;
  wire \shadow_reg_n_0_[2][14] ;
  wire \shadow_reg_n_0_[2][15] ;
  wire \shadow_reg_n_0_[2][16] ;
  wire \shadow_reg_n_0_[2][17] ;
  wire \shadow_reg_n_0_[2][18] ;
  wire \shadow_reg_n_0_[2][19] ;
  wire \shadow_reg_n_0_[2][1] ;
  wire \shadow_reg_n_0_[2][20] ;
  wire \shadow_reg_n_0_[2][21] ;
  wire \shadow_reg_n_0_[2][22] ;
  wire \shadow_reg_n_0_[2][23] ;
  wire \shadow_reg_n_0_[2][24] ;
  wire \shadow_reg_n_0_[2][25] ;
  wire \shadow_reg_n_0_[2][26] ;
  wire \shadow_reg_n_0_[2][27] ;
  wire \shadow_reg_n_0_[2][28] ;
  wire \shadow_reg_n_0_[2][29] ;
  wire \shadow_reg_n_0_[2][2] ;
  wire \shadow_reg_n_0_[2][30] ;
  wire \shadow_reg_n_0_[2][31] ;
  wire \shadow_reg_n_0_[2][3] ;
  wire \shadow_reg_n_0_[2][4] ;
  wire \shadow_reg_n_0_[2][5] ;
  wire \shadow_reg_n_0_[2][6] ;
  wire \shadow_reg_n_0_[2][7] ;
  wire \shadow_reg_n_0_[2][8] ;
  wire \shadow_reg_n_0_[2][9] ;
  wire \shadow_reg_n_0_[3][0] ;
  wire \shadow_reg_n_0_[3][10] ;
  wire \shadow_reg_n_0_[3][11] ;
  wire \shadow_reg_n_0_[3][12] ;
  wire \shadow_reg_n_0_[3][13] ;
  wire \shadow_reg_n_0_[3][14] ;
  wire \shadow_reg_n_0_[3][15] ;
  wire \shadow_reg_n_0_[3][16] ;
  wire \shadow_reg_n_0_[3][17] ;
  wire \shadow_reg_n_0_[3][18] ;
  wire \shadow_reg_n_0_[3][19] ;
  wire \shadow_reg_n_0_[3][1] ;
  wire \shadow_reg_n_0_[3][20] ;
  wire \shadow_reg_n_0_[3][21] ;
  wire \shadow_reg_n_0_[3][22] ;
  wire \shadow_reg_n_0_[3][23] ;
  wire \shadow_reg_n_0_[3][24] ;
  wire \shadow_reg_n_0_[3][25] ;
  wire \shadow_reg_n_0_[3][26] ;
  wire \shadow_reg_n_0_[3][27] ;
  wire \shadow_reg_n_0_[3][28] ;
  wire \shadow_reg_n_0_[3][29] ;
  wire \shadow_reg_n_0_[3][2] ;
  wire \shadow_reg_n_0_[3][30] ;
  wire \shadow_reg_n_0_[3][31] ;
  wire \shadow_reg_n_0_[3][3] ;
  wire \shadow_reg_n_0_[3][4] ;
  wire \shadow_reg_n_0_[3][5] ;
  wire \shadow_reg_n_0_[3][6] ;
  wire \shadow_reg_n_0_[3][7] ;
  wire \shadow_reg_n_0_[3][8] ;
  wire \shadow_reg_n_0_[3][9] ;
  wire \shadow_reg_n_0_[4][0] ;
  wire \shadow_reg_n_0_[4][10] ;
  wire \shadow_reg_n_0_[4][11] ;
  wire \shadow_reg_n_0_[4][12] ;
  wire \shadow_reg_n_0_[4][13] ;
  wire \shadow_reg_n_0_[4][14] ;
  wire \shadow_reg_n_0_[4][15] ;
  wire \shadow_reg_n_0_[4][16] ;
  wire \shadow_reg_n_0_[4][17] ;
  wire \shadow_reg_n_0_[4][18] ;
  wire \shadow_reg_n_0_[4][19] ;
  wire \shadow_reg_n_0_[4][1] ;
  wire \shadow_reg_n_0_[4][20] ;
  wire \shadow_reg_n_0_[4][21] ;
  wire \shadow_reg_n_0_[4][22] ;
  wire \shadow_reg_n_0_[4][23] ;
  wire \shadow_reg_n_0_[4][24] ;
  wire \shadow_reg_n_0_[4][25] ;
  wire \shadow_reg_n_0_[4][26] ;
  wire \shadow_reg_n_0_[4][27] ;
  wire \shadow_reg_n_0_[4][28] ;
  wire \shadow_reg_n_0_[4][29] ;
  wire \shadow_reg_n_0_[4][2] ;
  wire \shadow_reg_n_0_[4][30] ;
  wire \shadow_reg_n_0_[4][31] ;
  wire \shadow_reg_n_0_[4][3] ;
  wire \shadow_reg_n_0_[4][4] ;
  wire \shadow_reg_n_0_[4][5] ;
  wire \shadow_reg_n_0_[4][6] ;
  wire \shadow_reg_n_0_[4][7] ;
  wire \shadow_reg_n_0_[4][8] ;
  wire \shadow_reg_n_0_[4][9] ;
  wire \shadow_reg_n_0_[5][0] ;
  wire \shadow_reg_n_0_[5][10] ;
  wire \shadow_reg_n_0_[5][11] ;
  wire \shadow_reg_n_0_[5][12] ;
  wire \shadow_reg_n_0_[5][13] ;
  wire \shadow_reg_n_0_[5][14] ;
  wire \shadow_reg_n_0_[5][15] ;
  wire \shadow_reg_n_0_[5][16] ;
  wire \shadow_reg_n_0_[5][17] ;
  wire \shadow_reg_n_0_[5][18] ;
  wire \shadow_reg_n_0_[5][19] ;
  wire \shadow_reg_n_0_[5][1] ;
  wire \shadow_reg_n_0_[5][20] ;
  wire \shadow_reg_n_0_[5][21] ;
  wire \shadow_reg_n_0_[5][22] ;
  wire \shadow_reg_n_0_[5][23] ;
  wire \shadow_reg_n_0_[5][24] ;
  wire \shadow_reg_n_0_[5][25] ;
  wire \shadow_reg_n_0_[5][26] ;
  wire \shadow_reg_n_0_[5][27] ;
  wire \shadow_reg_n_0_[5][28] ;
  wire \shadow_reg_n_0_[5][29] ;
  wire \shadow_reg_n_0_[5][2] ;
  wire \shadow_reg_n_0_[5][30] ;
  wire \shadow_reg_n_0_[5][31] ;
  wire \shadow_reg_n_0_[5][3] ;
  wire \shadow_reg_n_0_[5][4] ;
  wire \shadow_reg_n_0_[5][5] ;
  wire \shadow_reg_n_0_[5][6] ;
  wire \shadow_reg_n_0_[5][7] ;
  wire \shadow_reg_n_0_[5][8] ;
  wire \shadow_reg_n_0_[5][9] ;
  wire \w_data_reg[0]_0 ;
  wire \w_data_reg_n_0_[0] ;
  wire \w_data_reg_n_0_[10] ;
  wire \w_data_reg_n_0_[11] ;
  wire \w_data_reg_n_0_[12] ;
  wire \w_data_reg_n_0_[13] ;
  wire \w_data_reg_n_0_[14] ;
  wire \w_data_reg_n_0_[15] ;
  wire \w_data_reg_n_0_[16] ;
  wire \w_data_reg_n_0_[17] ;
  wire \w_data_reg_n_0_[18] ;
  wire \w_data_reg_n_0_[19] ;
  wire \w_data_reg_n_0_[1] ;
  wire \w_data_reg_n_0_[20] ;
  wire \w_data_reg_n_0_[21] ;
  wire \w_data_reg_n_0_[22] ;
  wire \w_data_reg_n_0_[23] ;
  wire \w_data_reg_n_0_[24] ;
  wire \w_data_reg_n_0_[25] ;
  wire \w_data_reg_n_0_[26] ;
  wire \w_data_reg_n_0_[27] ;
  wire \w_data_reg_n_0_[28] ;
  wire \w_data_reg_n_0_[29] ;
  wire \w_data_reg_n_0_[2] ;
  wire \w_data_reg_n_0_[30] ;
  wire \w_data_reg_n_0_[31] ;
  wire \w_data_reg_n_0_[3] ;
  wire \w_data_reg_n_0_[4] ;
  wire \w_data_reg_n_0_[5] ;
  wire \w_data_reg_n_0_[6] ;
  wire \w_data_reg_n_0_[7] ;
  wire \w_data_reg_n_0_[8] ;
  wire \w_data_reg_n_0_[9] ;
  wire w_held0;
  wire w_held_i_1_n_0;
  wire w_held_reg_0;
  wire \w_strb_reg_n_0_[0] ;
  wire \w_strb_reg_n_0_[1] ;
  wire \w_strb_reg_n_0_[2] ;
  wire \w_strb_reg_n_0_[3] ;
  wire [3:0]NLW_hand_left1_carry_O_UNCONNECTED;
  wire [3:0]NLW_hand_left1_carry__0_O_UNCONNECTED;
  wire [3:3]NLW_hand_left1_carry__1_CO_UNCONNECTED;
  wire [3:0]NLW_hand_left1_carry__1_O_UNCONNECTED;

  assign out = req_sync;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE ack_meta_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ack_toggle_reg_0),
        .Q(ack_meta),
        .R(\bresp[1]_i_1_n_0 ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE ack_sync_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ack_meta),
        .Q(ack_sync),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE ack_toggle_reg
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(req_sync),
        .Q(ack_toggle_reg_0),
        .R(\pp_release_reg[1] ));
  LUT3 #(
    .INIT(8'h20)) 
    \active_cfg[159]_i_1 
       (.I0(pending_reg_0),
        .I1(ack_toggle_reg_1),
        .I2(in_vs),
        .O(\active_cfg[159]_i_1_n_0 ));
  FDRE \active_cfg_reg[0] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[0] ),
        .Q(Q[0]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[128] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[0]),
        .Q(cfg[128]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[129] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[1]),
        .Q(cfg[129]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[130] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[2]),
        .Q(cfg[130]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[131] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[3]),
        .Q(cfg[131]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[132] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[4]),
        .Q(cfg[132]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[133] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[5]),
        .Q(cfg[133]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[134] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[6]),
        .Q(cfg[134]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[135] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[7]),
        .Q(cfg[135]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[136] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[8]),
        .Q(cfg[136]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[137] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[9]),
        .Q(cfg[137]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[138] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[10]),
        .Q(cfg[138]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[139] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[11]),
        .Q(cfg[139]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[140] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[12]),
        .Q(cfg[140]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[141] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[13]),
        .Q(cfg[141]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[142] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[14]),
        .Q(cfg[142]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[143] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[15]),
        .Q(cfg[143]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[144] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[16]),
        .Q(cfg[144]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[145] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[17]),
        .Q(cfg[145]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[146] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[18]),
        .Q(cfg[146]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[147] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[19]),
        .Q(cfg[147]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[148] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[20]),
        .Q(cfg[148]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[149] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[21]),
        .Q(cfg[149]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[150] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[22]),
        .Q(cfg[150]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[151] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[23]),
        .Q(cfg[151]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[152] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[24]),
        .Q(cfg[152]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[153] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[25]),
        .Q(cfg[153]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[154] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[26]),
        .Q(cfg[154]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[155] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[27]),
        .Q(cfg[155]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[156] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[28]),
        .Q(cfg[156]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[157] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[29]),
        .Q(cfg[157]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[158] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[30]),
        .Q(cfg[158]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[159] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(p_1_in[31]),
        .Q(cfg[159]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[1] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[1] ),
        .Q(cfg[1]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[2] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[2] ),
        .Q(Q[1]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[32] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[32] ),
        .Q(Q[2]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[33] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[33] ),
        .Q(Q[3]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[34] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[34] ),
        .Q(Q[4]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[35] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[35] ),
        .Q(Q[5]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[36] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[36] ),
        .Q(Q[6]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[37] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[37] ),
        .Q(Q[7]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[38] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[38] ),
        .Q(Q[8]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[39] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[39] ),
        .Q(Q[9]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[40] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[40] ),
        .Q(Q[10]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[41] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[41] ),
        .Q(Q[11]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[42] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[42] ),
        .Q(Q[12]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[48] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[48] ),
        .Q(Q[13]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[49] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[49] ),
        .Q(Q[14]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[50] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[50] ),
        .Q(Q[15]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[51] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[51] ),
        .Q(Q[16]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[52] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[52] ),
        .Q(Q[17]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[53] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[53] ),
        .Q(Q[18]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[54] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[54] ),
        .Q(Q[19]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[55] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[55] ),
        .Q(Q[20]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[56] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[56] ),
        .Q(Q[21]),
        .R(\pp_release_reg[1] ));
  FDRE \active_cfg_reg[57] 
       (.C(pclk),
        .CE(\active_cfg[159]_i_1_n_0 ),
        .D(\pending_cfg_reg_n_0_[57] ),
        .Q(Q[22]),
        .R(\pp_release_reg[1] ));
  LUT3 #(
    .INIT(8'h02)) 
    \aw_addr[6]_i_1 
       (.I0(s_axi_awvalid),
        .I1(aw_held_reg_0),
        .I2(bvalid_reg_0),
        .O(aw_held0));
  FDRE \aw_addr_reg[0] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[0]),
        .Q(\aw_addr_reg[1]_0 [0]),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \aw_addr_reg[1] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[1]),
        .Q(\aw_addr_reg[1]_0 [1]),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \aw_addr_reg[2] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[2]),
        .Q(aw_addr[2]),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \aw_addr_reg[3] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[3]),
        .Q(aw_addr[3]),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \aw_addr_reg[4] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[4]),
        .Q(aw_addr[4]),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \aw_addr_reg[5] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[5]),
        .Q(aw_addr[5]),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \aw_addr_reg[6] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[6]),
        .Q(aw_addr[6]),
        .R(\bresp[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8800880000808880)) 
    aw_held_i_1
       (.I0(rvalid_reg_2),
        .I1(rvalid_reg_3),
        .I2(s_axi_awvalid),
        .I3(aw_held_reg_0),
        .I4(w_held_reg_0),
        .I5(bvalid_reg_0),
        .O(aw_held_i_1_n_0));
  FDRE aw_held_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(aw_held_i_1_n_0),
        .Q(aw_held_reg_0),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h7)) 
    \bresp[1]_i_1 
       (.I0(rvalid_reg_2),
        .I1(rvalid_reg_3),
        .O(\bresp[1]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hAA2A2AAA)) 
    \bresp[1]_i_3 
       (.I0(\mailbox[159]_i_2_n_0 ),
        .I1(\w_data_reg_n_0_[0] ),
        .I2(\w_strb_reg_n_0_[0] ),
        .I3(req_toggle_reg_n_0),
        .I4(ack_sync),
        .O(\w_data_reg[0]_0 ));
  LUT6 #(
    .INIT(64'hFBFBFBF9FBF9FBF9)) 
    \bresp[1]_i_4 
       (.I0(aw_addr[5]),
        .I1(aw_addr[4]),
        .I2(aw_addr[6]),
        .I3(aw_addr[3]),
        .I4(aw_addr[2]),
        .I5(\bresp[1]_i_6_n_0 ),
        .O(\aw_addr_reg[5]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \bresp[1]_i_5 
       (.I0(aw_held_reg_0),
        .I1(w_held_reg_0),
        .I2(bvalid_reg_0),
        .O(mailbox116_out));
  LUT2 #(
    .INIT(4'hE)) 
    \bresp[1]_i_6 
       (.I0(\aw_addr_reg[1]_0 [0]),
        .I1(\aw_addr_reg[1]_0 [1]),
        .O(\bresp[1]_i_6_n_0 ));
  FDRE \bresp_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\bresp_reg[1]_0 ),
        .Q(s_axi_bresp),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE bvalid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(bvalid_reg_1),
        .Q(bvalid_reg_0),
        .R(\bresp[1]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    dx12_carry__0_i_3
       (.I0(Q[12]),
        .I1(dx12_carry__0[10]),
        .O(\active_cfg_reg[42]_0 [1]));
  LUT4 #(
    .INIT(16'h9009)) 
    dx12_carry__0_i_4
       (.I0(Q[11]),
        .I1(dx12_carry__0[9]),
        .I2(Q[10]),
        .I3(dx12_carry__0[8]),
        .O(\active_cfg_reg[42]_0 [0]));
  LUT4 #(
    .INIT(16'h9009)) 
    dx12_carry_i_5
       (.I0(Q[9]),
        .I1(dx12_carry__0[7]),
        .I2(Q[8]),
        .I3(dx12_carry__0[6]),
        .O(\active_cfg_reg[39]_0 [3]));
  LUT4 #(
    .INIT(16'h9009)) 
    dx12_carry_i_6
       (.I0(Q[7]),
        .I1(dx12_carry__0[5]),
        .I2(Q[6]),
        .I3(dx12_carry__0[4]),
        .O(\active_cfg_reg[39]_0 [2]));
  LUT4 #(
    .INIT(16'h9009)) 
    dx12_carry_i_7
       (.I0(Q[5]),
        .I1(dx12_carry__0[3]),
        .I2(Q[4]),
        .I3(dx12_carry__0[2]),
        .O(\active_cfg_reg[39]_0 [1]));
  LUT4 #(
    .INIT(16'h9009)) 
    dx12_carry_i_8
       (.I0(Q[3]),
        .I1(dx12_carry__0[1]),
        .I2(Q[2]),
        .I3(dx12_carry__0[0]),
        .O(\active_cfg_reg[39]_0 [0]));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry__1_i_2
       (.I0(Q[22]),
        .I1(\dy1_reg[9] [9]),
        .O(\active_cfg_reg[57]_0 ));
  LUT4 #(
    .INIT(16'h9009)) 
    dy12_carry__0_i_2
       (.I0(Q[22]),
        .I1(\dy1_reg[9] [9]),
        .I2(Q[21]),
        .I3(\dy1_reg[9] [8]),
        .O(\active_cfg_reg[57]_1 ));
  LUT4 #(
    .INIT(16'h9009)) 
    dy12_carry_i_5
       (.I0(Q[20]),
        .I1(\dy1_reg[9] [7]),
        .I2(Q[19]),
        .I3(\dy1_reg[9] [6]),
        .O(S[3]));
  LUT4 #(
    .INIT(16'h9009)) 
    dy12_carry_i_6
       (.I0(Q[18]),
        .I1(\dy1_reg[9] [5]),
        .I2(Q[17]),
        .I3(\dy1_reg[9] [4]),
        .O(S[2]));
  LUT4 #(
    .INIT(16'h9009)) 
    dy12_carry_i_7
       (.I0(Q[16]),
        .I1(\dy1_reg[9] [3]),
        .I2(Q[15]),
        .I3(\dy1_reg[9] [2]),
        .O(S[1]));
  LUT4 #(
    .INIT(16'h9009)) 
    dy12_carry_i_8
       (.I0(Q[14]),
        .I1(\dy1_reg[9] [1]),
        .I2(Q[13]),
        .I3(\dy1_reg[9] [0]),
        .O(S[0]));
  LUT5 #(
    .INIT(32'h000000FD)) 
    hand1_i_1
       (.I0(\hand_left[7]_i_5_n_0 ),
        .I1(\hand_left_reg_n_0_[6] ),
        .I2(\hand_left_reg_n_0_[7] ),
        .I3(hand1_i_2_n_0),
        .I4(hand1_i_3_n_0),
        .O(hand10));
  LUT5 #(
    .INIT(32'hE0FFFFFF)) 
    hand1_i_2
       (.I0(Q[10]),
        .I1(Q[11]),
        .I2(Q[12]),
        .I3(Q[0]),
        .I4(cfg[1]),
        .O(hand1_i_2_n_0));
  LUT6 #(
    .INIT(64'hA888A888A8888888)) 
    hand1_i_3
       (.I0(Q[22]),
        .I1(Q[21]),
        .I2(Q[20]),
        .I3(Q[19]),
        .I4(Q[18]),
        .I5(Q[17]),
        .O(hand1_i_3_n_0));
  CARRY4 hand_left1_carry
       (.CI(1'b0),
        .CO({hand_left1_carry_n_0,hand_left1_carry_n_1,hand_left1_carry_n_2,hand_left1_carry_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_hand_left1_carry_O_UNCONNECTED[3:0]),
        .S({hand_left1_carry_i_1_n_0,hand_left1_carry_i_2_n_0,hand_left1_carry_i_3_n_0,hand_left1_carry_i_4_n_0}));
  CARRY4 hand_left1_carry__0
       (.CI(hand_left1_carry_n_0),
        .CO({hand_left1_carry__0_n_0,hand_left1_carry__0_n_1,hand_left1_carry__0_n_2,hand_left1_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_hand_left1_carry__0_O_UNCONNECTED[3:0]),
        .S({hand_left1_carry__0_i_1_n_0,hand_left1_carry__0_i_2_n_0,hand_left1_carry__0_i_3_n_0,hand_left1_carry__0_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    hand_left1_carry__0_i_1
       (.I0(p_1_in[21]),
        .I1(cfg[149]),
        .I2(p_1_in[22]),
        .I3(cfg[150]),
        .I4(cfg[151]),
        .I5(p_1_in[23]),
        .O(hand_left1_carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    hand_left1_carry__0_i_2
       (.I0(p_1_in[18]),
        .I1(cfg[146]),
        .I2(p_1_in[19]),
        .I3(cfg[147]),
        .I4(cfg[148]),
        .I5(p_1_in[20]),
        .O(hand_left1_carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    hand_left1_carry__0_i_3
       (.I0(p_1_in[15]),
        .I1(cfg[143]),
        .I2(p_1_in[16]),
        .I3(cfg[144]),
        .I4(cfg[145]),
        .I5(p_1_in[17]),
        .O(hand_left1_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    hand_left1_carry__0_i_4
       (.I0(p_1_in[12]),
        .I1(cfg[140]),
        .I2(p_1_in[13]),
        .I3(cfg[141]),
        .I4(cfg[142]),
        .I5(p_1_in[14]),
        .O(hand_left1_carry__0_i_4_n_0));
  CARRY4 hand_left1_carry__1
       (.CI(hand_left1_carry__0_n_0),
        .CO({NLW_hand_left1_carry__1_CO_UNCONNECTED[3],hand_left1_carry__1_n_1,hand_left1_carry__1_n_2,hand_left1_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b1,1'b1,1'b1}),
        .O(NLW_hand_left1_carry__1_O_UNCONNECTED[3:0]),
        .S({1'b0,hand_left1_carry__1_i_1_n_0,hand_left1_carry__1_i_2_n_0,hand_left1_carry__1_i_3_n_0}));
  LUT4 #(
    .INIT(16'h9009)) 
    hand_left1_carry__1_i_1
       (.I0(cfg[159]),
        .I1(p_1_in[31]),
        .I2(cfg[158]),
        .I3(p_1_in[30]),
        .O(hand_left1_carry__1_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    hand_left1_carry__1_i_2
       (.I0(p_1_in[29]),
        .I1(cfg[157]),
        .I2(p_1_in[27]),
        .I3(cfg[155]),
        .I4(cfg[156]),
        .I5(p_1_in[28]),
        .O(hand_left1_carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    hand_left1_carry__1_i_3
       (.I0(p_1_in[24]),
        .I1(cfg[152]),
        .I2(p_1_in[25]),
        .I3(cfg[153]),
        .I4(cfg[154]),
        .I5(p_1_in[26]),
        .O(hand_left1_carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    hand_left1_carry_i_1
       (.I0(p_1_in[9]),
        .I1(cfg[137]),
        .I2(p_1_in[10]),
        .I3(cfg[138]),
        .I4(cfg[139]),
        .I5(p_1_in[11]),
        .O(hand_left1_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    hand_left1_carry_i_2
       (.I0(p_1_in[6]),
        .I1(cfg[134]),
        .I2(p_1_in[7]),
        .I3(cfg[135]),
        .I4(cfg[136]),
        .I5(p_1_in[8]),
        .O(hand_left1_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    hand_left1_carry_i_3
       (.I0(p_1_in[3]),
        .I1(cfg[131]),
        .I2(p_1_in[4]),
        .I3(cfg[132]),
        .I4(cfg[133]),
        .I5(p_1_in[5]),
        .O(hand_left1_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    hand_left1_carry_i_4
       (.I0(p_1_in[1]),
        .I1(cfg[129]),
        .I2(p_1_in[0]),
        .I3(cfg[128]),
        .I4(cfg[130]),
        .I5(p_1_in[2]),
        .O(hand_left1_carry_i_4_n_0));
  LUT5 #(
    .INIT(32'hFFFFD515)) 
    \hand_left[0]_i_1 
       (.I0(\hand_left_reg_n_0_[0] ),
        .I1(hand_left1_carry__1_n_1),
        .I2(pending_reg_0),
        .I3(\pending_cfg_reg_n_0_[112] ),
        .I4(\hand_left[7]_i_4_n_0 ),
        .O(\hand_left[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFF9990999)) 
    \hand_left[1]_i_1 
       (.I0(\hand_left_reg_n_0_[0] ),
        .I1(\hand_left_reg_n_0_[1] ),
        .I2(hand_left1_carry__1_n_1),
        .I3(pending_reg_0),
        .I4(\pending_cfg_reg_n_0_[113] ),
        .I5(\hand_left[7]_i_4_n_0 ),
        .O(\hand_left[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFA900A9)) 
    \hand_left[2]_i_1 
       (.I0(\hand_left_reg_n_0_[2] ),
        .I1(\hand_left_reg_n_0_[0] ),
        .I2(\hand_left_reg_n_0_[1] ),
        .I3(\hand_left[7]_i_6_n_0 ),
        .I4(\pending_cfg_reg_n_0_[114] ),
        .I5(\hand_left[7]_i_4_n_0 ),
        .O(\hand_left[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF0000FB00)) 
    \hand_left[3]_i_1 
       (.I0(\hand_left[7]_i_6_n_0 ),
        .I1(\hand_left[3]_i_3_n_0 ),
        .I2(\hand_left_reg_n_0_[7] ),
        .I3(in_vs),
        .I4(ack_toggle_reg_1),
        .I5(\hand_left[7]_i_4_n_0 ),
        .O(\hand_left[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFF9990999)) 
    \hand_left[3]_i_2 
       (.I0(\hand_left_reg_n_0_[3] ),
        .I1(\hand_left[3]_i_4_n_0 ),
        .I2(pending_reg_0),
        .I3(hand_left1_carry__1_n_1),
        .I4(\pending_cfg_reg_n_0_[115] ),
        .I5(\hand_left[7]_i_4_n_0 ),
        .O(\hand_left[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \hand_left[3]_i_3 
       (.I0(\hand_left[7]_i_5_n_0 ),
        .I1(\hand_left_reg_n_0_[6] ),
        .O(\hand_left[3]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hFE)) 
    \hand_left[3]_i_4 
       (.I0(\hand_left_reg_n_0_[2] ),
        .I1(\hand_left_reg_n_0_[0] ),
        .I2(\hand_left_reg_n_0_[1] ),
        .O(\hand_left[3]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hAAC3C3C3)) 
    \hand_left[4]_i_1 
       (.I0(\pending_cfg_reg_n_0_[116] ),
        .I1(\hand_left_reg_n_0_[4] ),
        .I2(\hand_left[4]_i_2_n_0 ),
        .I3(hand_left1_carry__1_n_1),
        .I4(pending_reg_0),
        .O(p_2_in[4]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \hand_left[4]_i_2 
       (.I0(\hand_left_reg_n_0_[3] ),
        .I1(\hand_left_reg_n_0_[1] ),
        .I2(\hand_left_reg_n_0_[0] ),
        .I3(\hand_left_reg_n_0_[2] ),
        .O(\hand_left[4]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hAA3C3C3C)) 
    \hand_left[5]_i_1 
       (.I0(\pending_cfg_reg_n_0_[117] ),
        .I1(\hand_left[5]_i_2_n_0 ),
        .I2(\hand_left_reg_n_0_[5] ),
        .I3(hand_left1_carry__1_n_1),
        .I4(pending_reg_0),
        .O(p_2_in[5]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \hand_left[5]_i_2 
       (.I0(\hand_left_reg_n_0_[4] ),
        .I1(\hand_left_reg_n_0_[2] ),
        .I2(\hand_left_reg_n_0_[0] ),
        .I3(\hand_left_reg_n_0_[1] ),
        .I4(\hand_left_reg_n_0_[3] ),
        .O(\hand_left[5]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hAA3C3C3C)) 
    \hand_left[6]_i_1 
       (.I0(\pending_cfg_reg_n_0_[118] ),
        .I1(\hand_left[7]_i_5_n_0 ),
        .I2(\hand_left_reg_n_0_[6] ),
        .I3(hand_left1_carry__1_n_1),
        .I4(pending_reg_0),
        .O(p_2_in[6]));
  LUT3 #(
    .INIT(8'hF7)) 
    \hand_left[7]_i_1 
       (.I0(\hand_left_reg[0]_0 ),
        .I1(\hand_left_reg[0]_1 ),
        .I2(\hand_left[7]_i_4_n_0 ),
        .O(\hand_left[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h4444444444404444)) 
    \hand_left[7]_i_2 
       (.I0(ack_toggle_reg_1),
        .I1(in_vs),
        .I2(\hand_left_reg_n_0_[7] ),
        .I3(\hand_left_reg_n_0_[6] ),
        .I4(\hand_left[7]_i_5_n_0 ),
        .I5(\hand_left[7]_i_6_n_0 ),
        .O(hand_left));
  LUT6 #(
    .INIT(64'hBF8080BFBF80BF80)) 
    \hand_left[7]_i_3 
       (.I0(\pending_cfg_reg_n_0_[119] ),
        .I1(pending_reg_0),
        .I2(hand_left1_carry__1_n_1),
        .I3(\hand_left_reg_n_0_[7] ),
        .I4(\hand_left_reg_n_0_[6] ),
        .I5(\hand_left[7]_i_5_n_0 ),
        .O(p_2_in[7]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h00000080)) 
    \hand_left[7]_i_4 
       (.I0(pending_reg_0),
        .I1(hand_left1_carry__1_n_1),
        .I2(in_vs),
        .I3(ack_toggle_reg_1),
        .I4(\hand_left[7]_i_7_n_0 ),
        .O(\hand_left[7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \hand_left[7]_i_5 
       (.I0(\hand_left_reg_n_0_[3] ),
        .I1(\hand_left_reg_n_0_[1] ),
        .I2(\hand_left_reg_n_0_[0] ),
        .I3(\hand_left_reg_n_0_[2] ),
        .I4(\hand_left_reg_n_0_[4] ),
        .I5(\hand_left_reg_n_0_[5] ),
        .O(\hand_left[7]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \hand_left[7]_i_6 
       (.I0(pending_reg_0),
        .I1(hand_left1_carry__1_n_1),
        .O(\hand_left[7]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h0001)) 
    \hand_left[7]_i_7 
       (.I0(\pending_cfg_reg_n_0_[117] ),
        .I1(\pending_cfg_reg_n_0_[118] ),
        .I2(\pending_cfg_reg_n_0_[116] ),
        .I3(\pending_cfg_reg_n_0_[119] ),
        .O(\hand_left[7]_i_7_n_0 ));
  FDRE \hand_left_reg[0] 
       (.C(pclk),
        .CE(\hand_left[3]_i_1_n_0 ),
        .D(\hand_left[0]_i_1_n_0 ),
        .Q(\hand_left_reg_n_0_[0] ),
        .R(\pp_release_reg[1] ));
  FDRE \hand_left_reg[1] 
       (.C(pclk),
        .CE(\hand_left[3]_i_1_n_0 ),
        .D(\hand_left[1]_i_1_n_0 ),
        .Q(\hand_left_reg_n_0_[1] ),
        .R(\pp_release_reg[1] ));
  FDRE \hand_left_reg[2] 
       (.C(pclk),
        .CE(\hand_left[3]_i_1_n_0 ),
        .D(\hand_left[2]_i_1_n_0 ),
        .Q(\hand_left_reg_n_0_[2] ),
        .R(\pp_release_reg[1] ));
  FDRE \hand_left_reg[3] 
       (.C(pclk),
        .CE(\hand_left[3]_i_1_n_0 ),
        .D(\hand_left[3]_i_2_n_0 ),
        .Q(\hand_left_reg_n_0_[3] ),
        .R(\pp_release_reg[1] ));
  FDRE \hand_left_reg[4] 
       (.C(pclk),
        .CE(hand_left),
        .D(p_2_in[4]),
        .Q(\hand_left_reg_n_0_[4] ),
        .R(\hand_left[7]_i_1_n_0 ));
  FDRE \hand_left_reg[5] 
       (.C(pclk),
        .CE(hand_left),
        .D(p_2_in[5]),
        .Q(\hand_left_reg_n_0_[5] ),
        .R(\hand_left[7]_i_1_n_0 ));
  FDRE \hand_left_reg[6] 
       (.C(pclk),
        .CE(hand_left),
        .D(p_2_in[6]),
        .Q(\hand_left_reg_n_0_[6] ),
        .R(\hand_left[7]_i_1_n_0 ));
  FDRE \hand_left_reg[7] 
       (.C(pclk),
        .CE(hand_left),
        .D(p_2_in[7]),
        .Q(\hand_left_reg_n_0_[7] ),
        .R(\hand_left[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000080080000)) 
    \mailbox[159]_i_1 
       (.I0(\w_strb_reg_n_0_[0] ),
        .I1(\w_data_reg_n_0_[0] ),
        .I2(ack_sync),
        .I3(req_toggle_reg_n_0),
        .I4(\mailbox[159]_i_2_n_0 ),
        .I5(\mailbox[159]_i_3_n_0 ),
        .O(req_toggle6_out));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00000002)) 
    \mailbox[159]_i_2 
       (.I0(aw_addr[3]),
        .I1(aw_addr[6]),
        .I2(aw_addr[4]),
        .I3(aw_addr[5]),
        .I4(aw_addr[2]),
        .O(\mailbox[159]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'hFEFFFFFF)) 
    \mailbox[159]_i_3 
       (.I0(\aw_addr_reg[1]_0 [1]),
        .I1(\aw_addr_reg[1]_0 [0]),
        .I2(bvalid_reg_0),
        .I3(w_held_reg_0),
        .I4(aw_held_reg_0),
        .O(\mailbox[159]_i_3_n_0 ));
  FDRE \mailbox_reg[0] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[0][0] ),
        .Q(\mailbox_reg_n_0_[0] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[112] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[3][16] ),
        .Q(\mailbox_reg_n_0_[112] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[113] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[3][17] ),
        .Q(\mailbox_reg_n_0_[113] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[114] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[3][18] ),
        .Q(\mailbox_reg_n_0_[114] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[115] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[3][19] ),
        .Q(\mailbox_reg_n_0_[115] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[116] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[3][20] ),
        .Q(\mailbox_reg_n_0_[116] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[117] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[3][21] ),
        .Q(\mailbox_reg_n_0_[117] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[118] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[3][22] ),
        .Q(\mailbox_reg_n_0_[118] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[119] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[3][23] ),
        .Q(\mailbox_reg_n_0_[119] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[128] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][0] ),
        .Q(\mailbox_reg_n_0_[128] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[129] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][1] ),
        .Q(\mailbox_reg_n_0_[129] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[130] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][2] ),
        .Q(\mailbox_reg_n_0_[130] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[131] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][3] ),
        .Q(\mailbox_reg_n_0_[131] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[132] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][4] ),
        .Q(\mailbox_reg_n_0_[132] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[133] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][5] ),
        .Q(\mailbox_reg_n_0_[133] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[134] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][6] ),
        .Q(\mailbox_reg_n_0_[134] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[135] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][7] ),
        .Q(\mailbox_reg_n_0_[135] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[136] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][8] ),
        .Q(\mailbox_reg_n_0_[136] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[137] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][9] ),
        .Q(\mailbox_reg_n_0_[137] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[138] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][10] ),
        .Q(\mailbox_reg_n_0_[138] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[139] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][11] ),
        .Q(\mailbox_reg_n_0_[139] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[140] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][12] ),
        .Q(\mailbox_reg_n_0_[140] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[141] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][13] ),
        .Q(\mailbox_reg_n_0_[141] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[142] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][14] ),
        .Q(\mailbox_reg_n_0_[142] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[143] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][15] ),
        .Q(\mailbox_reg_n_0_[143] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[144] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][16] ),
        .Q(\mailbox_reg_n_0_[144] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[145] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][17] ),
        .Q(\mailbox_reg_n_0_[145] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[146] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][18] ),
        .Q(\mailbox_reg_n_0_[146] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[147] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][19] ),
        .Q(\mailbox_reg_n_0_[147] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[148] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][20] ),
        .Q(\mailbox_reg_n_0_[148] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[149] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][21] ),
        .Q(\mailbox_reg_n_0_[149] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[150] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][22] ),
        .Q(\mailbox_reg_n_0_[150] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[151] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][23] ),
        .Q(\mailbox_reg_n_0_[151] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[152] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][24] ),
        .Q(\mailbox_reg_n_0_[152] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[153] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][25] ),
        .Q(\mailbox_reg_n_0_[153] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[154] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][26] ),
        .Q(\mailbox_reg_n_0_[154] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[155] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][27] ),
        .Q(\mailbox_reg_n_0_[155] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[156] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][28] ),
        .Q(\mailbox_reg_n_0_[156] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[157] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][29] ),
        .Q(\mailbox_reg_n_0_[157] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[158] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][30] ),
        .Q(\mailbox_reg_n_0_[158] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[159] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[4][31] ),
        .Q(\mailbox_reg_n_0_[159] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[1] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[0][1] ),
        .Q(\mailbox_reg_n_0_[1] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[2] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[0][2] ),
        .Q(\mailbox_reg_n_0_[2] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[32] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][0] ),
        .Q(\mailbox_reg_n_0_[32] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[33] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][1] ),
        .Q(\mailbox_reg_n_0_[33] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[34] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][2] ),
        .Q(\mailbox_reg_n_0_[34] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[35] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][3] ),
        .Q(\mailbox_reg_n_0_[35] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[36] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][4] ),
        .Q(\mailbox_reg_n_0_[36] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[37] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][5] ),
        .Q(\mailbox_reg_n_0_[37] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[38] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][6] ),
        .Q(\mailbox_reg_n_0_[38] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[39] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][7] ),
        .Q(\mailbox_reg_n_0_[39] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[40] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][8] ),
        .Q(\mailbox_reg_n_0_[40] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[41] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][9] ),
        .Q(\mailbox_reg_n_0_[41] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[42] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][10] ),
        .Q(\mailbox_reg_n_0_[42] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[48] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][16] ),
        .Q(\mailbox_reg_n_0_[48] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[49] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][17] ),
        .Q(\mailbox_reg_n_0_[49] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[50] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][18] ),
        .Q(\mailbox_reg_n_0_[50] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[51] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][19] ),
        .Q(\mailbox_reg_n_0_[51] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[52] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][20] ),
        .Q(\mailbox_reg_n_0_[52] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[53] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][21] ),
        .Q(\mailbox_reg_n_0_[53] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[54] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][22] ),
        .Q(\mailbox_reg_n_0_[54] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[55] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][23] ),
        .Q(\mailbox_reg_n_0_[55] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[56] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][24] ),
        .Q(\mailbox_reg_n_0_[56] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \mailbox_reg[57] 
       (.C(s_axi_aclk),
        .CE(req_toggle6_out),
        .D(\shadow_reg_n_0_[1][25] ),
        .Q(\mailbox_reg_n_0_[57] ),
        .R(\bresp[1]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h7)) 
    \out_rgb[23]_i_1 
       (.I0(\hand_left_reg[0]_0 ),
        .I1(\hand_left_reg[0]_1 ),
        .O(\pp_release_reg[1] ));
  LUT3 #(
    .INIT(8'h06)) 
    \pending_cfg[159]_i_1 
       (.I0(ack_toggle_reg_0),
        .I1(req_sync),
        .I2(pending_reg_0),
        .O(\pending_cfg[159]_i_1_n_0 ));
  FDRE \pending_cfg_reg[0] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[0] ),
        .Q(\pending_cfg_reg_n_0_[0] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[112] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[112] ),
        .Q(\pending_cfg_reg_n_0_[112] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[113] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[113] ),
        .Q(\pending_cfg_reg_n_0_[113] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[114] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[114] ),
        .Q(\pending_cfg_reg_n_0_[114] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[115] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[115] ),
        .Q(\pending_cfg_reg_n_0_[115] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[116] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[116] ),
        .Q(\pending_cfg_reg_n_0_[116] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[117] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[117] ),
        .Q(\pending_cfg_reg_n_0_[117] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[118] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[118] ),
        .Q(\pending_cfg_reg_n_0_[118] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[119] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[119] ),
        .Q(\pending_cfg_reg_n_0_[119] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[128] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[128] ),
        .Q(p_1_in[0]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[129] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[129] ),
        .Q(p_1_in[1]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[130] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[130] ),
        .Q(p_1_in[2]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[131] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[131] ),
        .Q(p_1_in[3]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[132] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[132] ),
        .Q(p_1_in[4]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[133] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[133] ),
        .Q(p_1_in[5]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[134] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[134] ),
        .Q(p_1_in[6]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[135] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[135] ),
        .Q(p_1_in[7]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[136] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[136] ),
        .Q(p_1_in[8]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[137] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[137] ),
        .Q(p_1_in[9]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[138] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[138] ),
        .Q(p_1_in[10]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[139] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[139] ),
        .Q(p_1_in[11]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[140] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[140] ),
        .Q(p_1_in[12]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[141] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[141] ),
        .Q(p_1_in[13]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[142] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[142] ),
        .Q(p_1_in[14]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[143] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[143] ),
        .Q(p_1_in[15]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[144] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[144] ),
        .Q(p_1_in[16]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[145] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[145] ),
        .Q(p_1_in[17]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[146] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[146] ),
        .Q(p_1_in[18]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[147] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[147] ),
        .Q(p_1_in[19]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[148] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[148] ),
        .Q(p_1_in[20]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[149] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[149] ),
        .Q(p_1_in[21]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[150] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[150] ),
        .Q(p_1_in[22]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[151] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[151] ),
        .Q(p_1_in[23]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[152] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[152] ),
        .Q(p_1_in[24]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[153] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[153] ),
        .Q(p_1_in[25]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[154] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[154] ),
        .Q(p_1_in[26]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[155] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[155] ),
        .Q(p_1_in[27]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[156] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[156] ),
        .Q(p_1_in[28]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[157] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[157] ),
        .Q(p_1_in[29]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[158] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[158] ),
        .Q(p_1_in[30]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[159] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[159] ),
        .Q(p_1_in[31]),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[1] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[1] ),
        .Q(\pending_cfg_reg_n_0_[1] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[2] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[2] ),
        .Q(\pending_cfg_reg_n_0_[2] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[32] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[32] ),
        .Q(\pending_cfg_reg_n_0_[32] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[33] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[33] ),
        .Q(\pending_cfg_reg_n_0_[33] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[34] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[34] ),
        .Q(\pending_cfg_reg_n_0_[34] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[35] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[35] ),
        .Q(\pending_cfg_reg_n_0_[35] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[36] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[36] ),
        .Q(\pending_cfg_reg_n_0_[36] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[37] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[37] ),
        .Q(\pending_cfg_reg_n_0_[37] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[38] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[38] ),
        .Q(\pending_cfg_reg_n_0_[38] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[39] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[39] ),
        .Q(\pending_cfg_reg_n_0_[39] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[40] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[40] ),
        .Q(\pending_cfg_reg_n_0_[40] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[41] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[41] ),
        .Q(\pending_cfg_reg_n_0_[41] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[42] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[42] ),
        .Q(\pending_cfg_reg_n_0_[42] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[48] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[48] ),
        .Q(\pending_cfg_reg_n_0_[48] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[49] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[49] ),
        .Q(\pending_cfg_reg_n_0_[49] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[50] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[50] ),
        .Q(\pending_cfg_reg_n_0_[50] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[51] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[51] ),
        .Q(\pending_cfg_reg_n_0_[51] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[52] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[52] ),
        .Q(\pending_cfg_reg_n_0_[52] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[53] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[53] ),
        .Q(\pending_cfg_reg_n_0_[53] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[54] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[54] ),
        .Q(\pending_cfg_reg_n_0_[54] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[55] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[55] ),
        .Q(\pending_cfg_reg_n_0_[55] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[56] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[56] ),
        .Q(\pending_cfg_reg_n_0_[56] ),
        .R(\pp_release_reg[1] ));
  FDRE \pending_cfg_reg[57] 
       (.C(pclk),
        .CE(\pending_cfg[159]_i_1_n_0 ),
        .D(\mailbox_reg_n_0_[57] ),
        .Q(\pending_cfg_reg_n_0_[57] ),
        .R(\pp_release_reg[1] ));
  FDRE pending_reg
       (.C(pclk),
        .CE(1'b1),
        .D(pending_reg_1),
        .Q(pending_reg_0),
        .R(\pp_release_reg[1] ));
  LUT6 #(
    .INIT(64'h0000001010100010)) 
    \rdata[0]_i_1 
       (.I0(\rdata[27]_i_5_n_0 ),
        .I1(\rdata[0]_i_2_n_0 ),
        .I2(\rdata[0]_i_3_n_0 ),
        .I3(\rdata[0]_i_4_n_0 ),
        .I4(s_axi_araddr[2]),
        .I5(\rdata[0]_i_5_n_0 ),
        .O(\rdata[0]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h10000010)) 
    \rdata[0]_i_2 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[5]),
        .I2(s_axi_araddr[2]),
        .I3(ack_sync),
        .I4(req_toggle_reg_n_0),
        .O(\rdata[0]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hD800FFFF)) 
    \rdata[0]_i_3 
       (.I0(s_axi_araddr[2]),
        .I1(\shadow_reg_n_0_[3][0] ),
        .I2(\shadow_reg_n_0_[2][0] ),
        .I3(s_axi_araddr[4]),
        .I4(s_axi_araddr[3]),
        .O(\rdata[0]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h04FF0404)) 
    \rdata[0]_i_4 
       (.I0(\shadow_reg_n_0_[0][0] ),
        .I1(s_axi_araddr[4]),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[4][0] ),
        .I4(s_axi_araddr[5]),
        .O(\rdata[0]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'h04FF0404)) 
    \rdata[0]_i_5 
       (.I0(\shadow_reg_n_0_[1][0] ),
        .I1(s_axi_araddr[4]),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[5][0] ),
        .I4(s_axi_araddr[5]),
        .O(\rdata[0]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h000D)) 
    \rdata[10]_i_1 
       (.I0(s_axi_araddr[2]),
        .I1(\rdata[10]_i_2_n_0 ),
        .I2(\rdata[10]_i_3_n_0 ),
        .I3(\rdata[10]_i_4_n_0 ),
        .O(\rdata[10]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF0FA8080000A808)) 
    \rdata[10]_i_2 
       (.I0(s_axi_araddr[4]),
        .I1(\shadow_reg_n_0_[1][10] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[3][10] ),
        .I4(s_axi_araddr[5]),
        .I5(\shadow_reg_n_0_[5][10] ),
        .O(\rdata[10]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFCCCCFF04)) 
    \rdata[10]_i_3 
       (.I0(\shadow_reg_n_0_[4][10] ),
        .I1(s_axi_araddr[5]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(\rdata[10]_i_5_n_0 ),
        .O(\rdata[10]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h04150404)) 
    \rdata[10]_i_4 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_araddr[3]),
        .I2(\shadow_reg_n_0_[2][10] ),
        .I3(\shadow_reg_n_0_[0][10] ),
        .I4(s_axi_araddr[4]),
        .O(\rdata[10]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \rdata[10]_i_5 
       (.I0(s_axi_araddr[6]),
        .I1(s_axi_araddr[1]),
        .I2(s_axi_araddr[0]),
        .O(\rdata[10]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[11]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[11]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[11]_i_3_n_0 ),
        .O(\rdata[11]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[11]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][11] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][11] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[11]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[11]_i_3 
       (.I0(\shadow_reg_n_0_[3][11] ),
        .I1(\shadow_reg_n_0_[2][11] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][11] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][11] ),
        .O(\rdata[11]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[12]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[12]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[12]_i_3_n_0 ),
        .O(\rdata[12]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[12]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][12] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][12] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[12]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[12]_i_3 
       (.I0(\shadow_reg_n_0_[3][12] ),
        .I1(\shadow_reg_n_0_[2][12] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][12] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][12] ),
        .O(\rdata[12]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[13]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[13]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[13]_i_3_n_0 ),
        .O(\rdata[13]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[13]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][13] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][13] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[13]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[13]_i_3 
       (.I0(\shadow_reg_n_0_[3][13] ),
        .I1(\shadow_reg_n_0_[2][13] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][13] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][13] ),
        .O(\rdata[13]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h0002)) 
    \rdata[14]_i_1 
       (.I0(\rdata[14]_i_2_n_0 ),
        .I1(\rdata[14]_i_3_n_0 ),
        .I2(\rdata[14]_i_4_n_0 ),
        .I3(\rdata[27]_i_5_n_0 ),
        .O(\rdata[14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF000F0F0F8F8FFFF)) 
    \rdata[14]_i_2 
       (.I0(\shadow_reg_n_0_[5][14] ),
        .I1(s_axi_araddr[5]),
        .I2(s_axi_araddr[4]),
        .I3(\shadow_reg_n_0_[3][14] ),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(\rdata[14]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h00044404)) 
    \rdata[14]_i_3 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[4]),
        .I2(\shadow_reg_n_0_[0][14] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[1][14] ),
        .O(\rdata[14]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h04550404)) 
    \rdata[14]_i_4 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[4][14] ),
        .I3(\shadow_reg_n_0_[2][14] ),
        .I4(s_axi_araddr[3]),
        .O(\rdata[14]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[15]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[15]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[15]_i_3_n_0 ),
        .O(\rdata[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[15]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][15] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][15] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[15]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[15]_i_3 
       (.I0(\shadow_reg_n_0_[3][15] ),
        .I1(\shadow_reg_n_0_[2][15] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][15] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][15] ),
        .O(\rdata[15]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h000000000D000D0D)) 
    \rdata[16]_i_1 
       (.I0(s_axi_araddr[2]),
        .I1(\rdata[16]_i_2_n_0 ),
        .I2(\rdata[27]_i_5_n_0 ),
        .I3(\shadow_reg_n_0_[4][16] ),
        .I4(\rdata[16]_i_3_n_0 ),
        .I5(\rdata[16]_i_4_n_0 ),
        .O(\rdata[16]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFA0AF8080000F808)) 
    \rdata[16]_i_2 
       (.I0(s_axi_araddr[4]),
        .I1(\shadow_reg_n_0_[1][16] ),
        .I2(s_axi_araddr[5]),
        .I3(\shadow_reg_n_0_[5][16] ),
        .I4(s_axi_araddr[3]),
        .I5(\shadow_reg_n_0_[3][16] ),
        .O(\rdata[16]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h8A)) 
    \rdata[16]_i_3 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[4]),
        .I2(s_axi_araddr[2]),
        .O(\rdata[16]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h0C0C4C7C)) 
    \rdata[16]_i_4 
       (.I0(\shadow_reg_n_0_[2][16] ),
        .I1(s_axi_araddr[3]),
        .I2(s_axi_araddr[4]),
        .I3(\shadow_reg_n_0_[0][16] ),
        .I4(s_axi_araddr[2]),
        .O(\rdata[16]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000005111)) 
    \rdata[17]_i_1 
       (.I0(\rdata[17]_i_2_n_0 ),
        .I1(\rdata[27]_i_3_n_0 ),
        .I2(s_axi_araddr[5]),
        .I3(\shadow_reg_n_0_[5][17] ),
        .I4(\rdata[17]_i_3_n_0 ),
        .I5(\rdata[27]_i_5_n_0 ),
        .O(\rdata[17]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h04550404)) 
    \rdata[17]_i_2 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[4][17] ),
        .I3(\shadow_reg_n_0_[2][17] ),
        .I4(s_axi_araddr[3]),
        .O(\rdata[17]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h5050FFFF303F0000)) 
    \rdata[17]_i_3 
       (.I0(\shadow_reg_n_0_[3][17] ),
        .I1(\shadow_reg_n_0_[1][17] ),
        .I2(s_axi_araddr[2]),
        .I3(\shadow_reg_n_0_[0][17] ),
        .I4(s_axi_araddr[4]),
        .I5(s_axi_araddr[3]),
        .O(\rdata[17]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[18]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[18]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[18]_i_3_n_0 ),
        .O(\rdata[18]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[18]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][18] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][18] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[18]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[18]_i_3 
       (.I0(\shadow_reg_n_0_[3][18] ),
        .I1(\shadow_reg_n_0_[2][18] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][18] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][18] ),
        .O(\rdata[18]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[19]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[19]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[19]_i_3_n_0 ),
        .O(\rdata[19]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[19]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][19] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][19] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[19]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[19]_i_3 
       (.I0(\shadow_reg_n_0_[3][19] ),
        .I1(\shadow_reg_n_0_[2][19] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][19] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][19] ),
        .O(\rdata[19]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[1]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[1]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[1]_i_3_n_0 ),
        .O(\rdata[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[1]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][1] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][1] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[1]_i_3 
       (.I0(\shadow_reg_n_0_[3][1] ),
        .I1(\shadow_reg_n_0_[2][1] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][1] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][1] ),
        .O(\rdata[1]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h0002)) 
    \rdata[20]_i_1 
       (.I0(\rdata[20]_i_2_n_0 ),
        .I1(\rdata[20]_i_3_n_0 ),
        .I2(\rdata[20]_i_4_n_0 ),
        .I3(\rdata[27]_i_5_n_0 ),
        .O(\rdata[20]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF000F0F0F8F8FFFF)) 
    \rdata[20]_i_2 
       (.I0(\shadow_reg_n_0_[5][20] ),
        .I1(s_axi_araddr[5]),
        .I2(s_axi_araddr[4]),
        .I3(\shadow_reg_n_0_[3][20] ),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(\rdata[20]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h00044404)) 
    \rdata[20]_i_3 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[4]),
        .I2(\shadow_reg_n_0_[0][20] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[1][20] ),
        .O(\rdata[20]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h04550404)) 
    \rdata[20]_i_4 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[4][20] ),
        .I3(\shadow_reg_n_0_[2][20] ),
        .I4(s_axi_araddr[3]),
        .O(\rdata[20]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[21]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[21]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[21]_i_3_n_0 ),
        .O(\rdata[21]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[21]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][21] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][21] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[21]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[21]_i_3 
       (.I0(\shadow_reg_n_0_[3][21] ),
        .I1(\shadow_reg_n_0_[2][21] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][21] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][21] ),
        .O(\rdata[21]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000055454545)) 
    \rdata[22]_i_1 
       (.I0(\rdata[22]_i_2_n_0 ),
        .I1(s_axi_araddr[4]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[5]),
        .I4(\shadow_reg_n_0_[5][22] ),
        .I5(\rdata[22]_i_3_n_0 ),
        .O(\rdata[22]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00044404)) 
    \rdata[22]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[4]),
        .I2(\shadow_reg_n_0_[0][22] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[1][22] ),
        .O(\rdata[22]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEEEEFEEEFEFEFEFE)) 
    \rdata[22]_i_3 
       (.I0(\rdata[27]_i_5_n_0 ),
        .I1(\rdata[22]_i_4_n_0 ),
        .I2(s_axi_araddr[3]),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[3][22] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[22]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h04550404)) 
    \rdata[22]_i_4 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[4][22] ),
        .I3(\shadow_reg_n_0_[2][22] ),
        .I4(s_axi_araddr[3]),
        .O(\rdata[22]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[23]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[23]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[23]_i_3_n_0 ),
        .O(\rdata[23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[23]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][23] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][23] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[23]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[23]_i_3 
       (.I0(\shadow_reg_n_0_[3][23] ),
        .I1(\shadow_reg_n_0_[2][23] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][23] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][23] ),
        .O(\rdata[23]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000005111)) 
    \rdata[24]_i_1 
       (.I0(\rdata[24]_i_2_n_0 ),
        .I1(\rdata[27]_i_3_n_0 ),
        .I2(s_axi_araddr[5]),
        .I3(\shadow_reg_n_0_[5][24] ),
        .I4(\rdata[24]_i_3_n_0 ),
        .I5(\rdata[27]_i_5_n_0 ),
        .O(\rdata[24]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h04550404)) 
    \rdata[24]_i_2 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[4][24] ),
        .I3(\shadow_reg_n_0_[2][24] ),
        .I4(s_axi_araddr[3]),
        .O(\rdata[24]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h5050FFFF303F0000)) 
    \rdata[24]_i_3 
       (.I0(\shadow_reg_n_0_[3][24] ),
        .I1(\shadow_reg_n_0_[1][24] ),
        .I2(s_axi_araddr[2]),
        .I3(\shadow_reg_n_0_[0][24] ),
        .I4(s_axi_araddr[4]),
        .I5(s_axi_araddr[3]),
        .O(\rdata[24]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000005111)) 
    \rdata[25]_i_1 
       (.I0(\rdata[25]_i_2_n_0 ),
        .I1(\rdata[27]_i_3_n_0 ),
        .I2(s_axi_araddr[5]),
        .I3(\shadow_reg_n_0_[5][25] ),
        .I4(\rdata[25]_i_3_n_0 ),
        .I5(\rdata[27]_i_5_n_0 ),
        .O(\rdata[25]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h04550404)) 
    \rdata[25]_i_2 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[4][25] ),
        .I3(\shadow_reg_n_0_[2][25] ),
        .I4(s_axi_araddr[3]),
        .O(\rdata[25]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h5050FFFF303F0000)) 
    \rdata[25]_i_3 
       (.I0(\shadow_reg_n_0_[3][25] ),
        .I1(\shadow_reg_n_0_[1][25] ),
        .I2(s_axi_araddr[2]),
        .I3(\shadow_reg_n_0_[0][25] ),
        .I4(s_axi_araddr[4]),
        .I5(s_axi_araddr[3]),
        .O(\rdata[25]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000005111)) 
    \rdata[26]_i_1 
       (.I0(\rdata[26]_i_2_n_0 ),
        .I1(\rdata[27]_i_3_n_0 ),
        .I2(s_axi_araddr[5]),
        .I3(\shadow_reg_n_0_[5][26] ),
        .I4(\rdata[26]_i_3_n_0 ),
        .I5(\rdata[27]_i_5_n_0 ),
        .O(\rdata[26]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h04550404)) 
    \rdata[26]_i_2 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[4][26] ),
        .I3(\shadow_reg_n_0_[2][26] ),
        .I4(s_axi_araddr[3]),
        .O(\rdata[26]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h5050FFFF303F0000)) 
    \rdata[26]_i_3 
       (.I0(\shadow_reg_n_0_[3][26] ),
        .I1(\shadow_reg_n_0_[1][26] ),
        .I2(s_axi_araddr[2]),
        .I3(\shadow_reg_n_0_[0][26] ),
        .I4(s_axi_araddr[4]),
        .I5(s_axi_araddr[3]),
        .O(\rdata[26]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000005111)) 
    \rdata[27]_i_1 
       (.I0(\rdata[27]_i_2_n_0 ),
        .I1(\rdata[27]_i_3_n_0 ),
        .I2(s_axi_araddr[5]),
        .I3(\shadow_reg_n_0_[5][27] ),
        .I4(\rdata[27]_i_4_n_0 ),
        .I5(\rdata[27]_i_5_n_0 ),
        .O(\rdata[27]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h04550404)) 
    \rdata[27]_i_2 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[4][27] ),
        .I3(\shadow_reg_n_0_[2][27] ),
        .I4(s_axi_araddr[3]),
        .O(\rdata[27]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \rdata[27]_i_3 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_araddr[4]),
        .O(\rdata[27]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h5050FFFF303F0000)) 
    \rdata[27]_i_4 
       (.I0(\shadow_reg_n_0_[3][27] ),
        .I1(\shadow_reg_n_0_[1][27] ),
        .I2(s_axi_araddr[2]),
        .I3(\shadow_reg_n_0_[0][27] ),
        .I4(s_axi_araddr[4]),
        .I5(s_axi_araddr[3]),
        .O(\rdata[27]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'hFFFEFEFE)) 
    \rdata[27]_i_5 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_araddr[1]),
        .I2(s_axi_araddr[6]),
        .I3(s_axi_araddr[5]),
        .I4(s_axi_araddr[4]),
        .O(\rdata[27]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[28]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[28]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[28]_i_3_n_0 ),
        .O(\rdata[28]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[28]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][28] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][28] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[28]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[28]_i_3 
       (.I0(\shadow_reg_n_0_[3][28] ),
        .I1(\shadow_reg_n_0_[2][28] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][28] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][28] ),
        .O(\rdata[28]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[29]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[29]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[29]_i_3_n_0 ),
        .O(\rdata[29]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[29]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][29] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][29] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[29]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[29]_i_3 
       (.I0(\shadow_reg_n_0_[3][29] ),
        .I1(\shadow_reg_n_0_[2][29] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][29] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][29] ),
        .O(\rdata[29]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[2]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[2]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[2]_i_3_n_0 ),
        .O(\rdata[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[2]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][2] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][2] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[2]_i_3 
       (.I0(\shadow_reg_n_0_[3][2] ),
        .I1(\shadow_reg_n_0_[2][2] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][2] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][2] ),
        .O(\rdata[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000054005555)) 
    \rdata[30]_i_1 
       (.I0(\rdata[30]_i_2_n_0 ),
        .I1(s_axi_araddr[2]),
        .I2(\shadow_reg_n_0_[2][30] ),
        .I3(s_axi_araddr[4]),
        .I4(s_axi_araddr[3]),
        .I5(\rdata[30]_i_3_n_0 ),
        .O(\rdata[30]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'hFFFF0070)) 
    \rdata[30]_i_2 
       (.I0(\shadow_reg_n_0_[5][30] ),
        .I1(s_axi_araddr[5]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[4]),
        .I4(\rdata[27]_i_5_n_0 ),
        .O(\rdata[30]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h5530FFFF55300000)) 
    \rdata[30]_i_3 
       (.I0(\shadow_reg_n_0_[3][30] ),
        .I1(\shadow_reg_n_0_[1][30] ),
        .I2(s_axi_araddr[4]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(\rdata[30]_i_4_n_0 ),
        .O(\rdata[30]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h44444F44)) 
    \rdata[30]_i_4 
       (.I0(\shadow_reg_n_0_[4][30] ),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[0][30] ),
        .I3(s_axi_araddr[4]),
        .I4(s_axi_araddr[3]),
        .O(\rdata[30]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h77777777FFF77777)) 
    \rdata[31]_i_1 
       (.I0(rvalid_reg_2),
        .I1(rvalid_reg_3),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_arvalid),
        .I5(rvalid_reg_0),
        .O(\rdata[31]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \rdata[31]_i_2 
       (.I0(s_axi_arvalid),
        .I1(rvalid_reg_0),
        .O(rvalid010_out));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[31]_i_3 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[31]_i_5_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[31]_i_6_n_0 ),
        .O(\rdata[31]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0001000100010101)) 
    \rdata[31]_i_4 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_araddr[1]),
        .I2(s_axi_araddr[6]),
        .I3(s_axi_araddr[5]),
        .I4(s_axi_araddr[3]),
        .I5(s_axi_araddr[4]),
        .O(\rdata[31]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[31]_i_5 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][31] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][31] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[31]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[31]_i_6 
       (.I0(\shadow_reg_n_0_[3][31] ),
        .I1(\shadow_reg_n_0_[2][31] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][31] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][31] ),
        .O(\rdata[31]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[3]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[3]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[3]_i_3_n_0 ),
        .O(\rdata[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[3]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][3] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][3] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[3]_i_3 
       (.I0(\shadow_reg_n_0_[3][3] ),
        .I1(\shadow_reg_n_0_[2][3] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][3] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][3] ),
        .O(\rdata[3]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[4]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[4]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[4]_i_3_n_0 ),
        .O(\rdata[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[4]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][4] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][4] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[4]_i_3 
       (.I0(\shadow_reg_n_0_[3][4] ),
        .I1(\shadow_reg_n_0_[2][4] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][4] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][4] ),
        .O(\rdata[4]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[5]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[5]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[5]_i_3_n_0 ),
        .O(\rdata[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[5]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][5] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][5] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[5]_i_3 
       (.I0(\shadow_reg_n_0_[3][5] ),
        .I1(\shadow_reg_n_0_[2][5] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][5] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][5] ),
        .O(\rdata[5]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[6]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[6]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[6]_i_3_n_0 ),
        .O(\rdata[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[6]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][6] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][6] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[6]_i_3 
       (.I0(\shadow_reg_n_0_[3][6] ),
        .I1(\shadow_reg_n_0_[2][6] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][6] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][6] ),
        .O(\rdata[6]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[7]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[7]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[7]_i_3_n_0 ),
        .O(\rdata[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[7]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][7] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][7] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[7]_i_3 
       (.I0(\shadow_reg_n_0_[3][7] ),
        .I1(\shadow_reg_n_0_[2][7] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][7] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][7] ),
        .O(\rdata[7]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[8]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[8]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[8]_i_3_n_0 ),
        .O(\rdata[8]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[8]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][8] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][8] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[8]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[8]_i_3 
       (.I0(\shadow_reg_n_0_[3][8] ),
        .I1(\shadow_reg_n_0_[2][8] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][8] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][8] ),
        .O(\rdata[8]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hA888)) 
    \rdata[9]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[9]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(\rdata[9]_i_3_n_0 ),
        .O(\rdata[9]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \rdata[9]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[5]),
        .I2(\shadow_reg_n_0_[5][9] ),
        .I3(s_axi_araddr[2]),
        .I4(\shadow_reg_n_0_[4][9] ),
        .I5(s_axi_araddr[4]),
        .O(\rdata[9]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rdata[9]_i_3 
       (.I0(\shadow_reg_n_0_[3][9] ),
        .I1(\shadow_reg_n_0_[2][9] ),
        .I2(s_axi_araddr[3]),
        .I3(\shadow_reg_n_0_[1][9] ),
        .I4(s_axi_araddr[2]),
        .I5(\shadow_reg_n_0_[0][9] ),
        .O(\rdata[9]_i_3_n_0 ));
  FDRE \rdata_reg[0] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[0]_i_1_n_0 ),
        .Q(s_axi_rdata[0]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[10] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[10]_i_1_n_0 ),
        .Q(s_axi_rdata[10]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[11] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[11]_i_1_n_0 ),
        .Q(s_axi_rdata[11]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[12] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[12]_i_1_n_0 ),
        .Q(s_axi_rdata[12]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[13] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[13]_i_1_n_0 ),
        .Q(s_axi_rdata[13]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[14] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[14]_i_1_n_0 ),
        .Q(s_axi_rdata[14]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[15] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[15]_i_1_n_0 ),
        .Q(s_axi_rdata[15]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[16] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[16]_i_1_n_0 ),
        .Q(s_axi_rdata[16]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[17] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[17]_i_1_n_0 ),
        .Q(s_axi_rdata[17]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[18] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[18]_i_1_n_0 ),
        .Q(s_axi_rdata[18]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[19] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[19]_i_1_n_0 ),
        .Q(s_axi_rdata[19]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[1] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[1]_i_1_n_0 ),
        .Q(s_axi_rdata[1]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[20] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[20]_i_1_n_0 ),
        .Q(s_axi_rdata[20]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[21] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[21]_i_1_n_0 ),
        .Q(s_axi_rdata[21]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[22] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[22]_i_1_n_0 ),
        .Q(s_axi_rdata[22]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[23] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[23]_i_1_n_0 ),
        .Q(s_axi_rdata[23]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[24] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[24]_i_1_n_0 ),
        .Q(s_axi_rdata[24]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[25] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[25]_i_1_n_0 ),
        .Q(s_axi_rdata[25]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[26] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[26]_i_1_n_0 ),
        .Q(s_axi_rdata[26]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[27] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[27]_i_1_n_0 ),
        .Q(s_axi_rdata[27]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[28] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[28]_i_1_n_0 ),
        .Q(s_axi_rdata[28]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[29] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[29]_i_1_n_0 ),
        .Q(s_axi_rdata[29]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[2] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[2]_i_1_n_0 ),
        .Q(s_axi_rdata[2]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[30] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[30]_i_1_n_0 ),
        .Q(s_axi_rdata[30]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[31] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[31]_i_3_n_0 ),
        .Q(s_axi_rdata[31]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[3] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[3]_i_1_n_0 ),
        .Q(s_axi_rdata[3]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[4] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[4]_i_1_n_0 ),
        .Q(s_axi_rdata[4]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[5] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[5]_i_1_n_0 ),
        .Q(s_axi_rdata[5]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[6] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[6]_i_1_n_0 ),
        .Q(s_axi_rdata[6]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[7] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[7]_i_1_n_0 ),
        .Q(s_axi_rdata[7]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[8] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[8]_i_1_n_0 ),
        .Q(s_axi_rdata[8]),
        .R(\rdata[31]_i_1_n_0 ));
  FDRE \rdata_reg[9] 
       (.C(s_axi_aclk),
        .CE(rvalid010_out),
        .D(\rdata[9]_i_1_n_0 ),
        .Q(s_axi_rdata[9]),
        .R(\rdata[31]_i_1_n_0 ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE req_meta_reg
       (.C(pclk),
        .CE(1'b1),
        .D(req_toggle_reg_n_0),
        .Q(req_meta),
        .R(\pp_release_reg[1] ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE req_sync_reg
       (.C(pclk),
        .CE(1'b1),
        .D(req_meta),
        .Q(req_sync),
        .R(\pp_release_reg[1] ));
  LUT6 #(
    .INIT(64'hFF00FF007F08FF00)) 
    req_toggle_i_1
       (.I0(\w_strb_reg_n_0_[0] ),
        .I1(\w_data_reg_n_0_[0] ),
        .I2(ack_sync),
        .I3(req_toggle_reg_n_0),
        .I4(\mailbox[159]_i_2_n_0 ),
        .I5(\mailbox[159]_i_3_n_0 ),
        .O(req_toggle_i_1_n_0));
  FDRE req_toggle_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(req_toggle_i_1_n_0),
        .Q(req_toggle_reg_n_0),
        .R(\bresp[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFD5FFFFFFD500)) 
    \rresp[1]_i_1 
       (.I0(\rdata[31]_i_4_n_0 ),
        .I1(\rdata[27]_i_3_n_0 ),
        .I2(s_axi_araddr[3]),
        .I3(rvalid010_out),
        .I4(\rresp[1]_i_2_n_0 ),
        .I5(s_axi_rresp),
        .O(\rresp[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'h4440)) 
    \rresp[1]_i_2 
       (.I0(rvalid_reg_0),
        .I1(s_axi_arvalid),
        .I2(s_axi_araddr[1]),
        .I3(s_axi_araddr[0]),
        .O(\rresp[1]_i_2_n_0 ));
  FDRE \rresp_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\rresp[1]_i_1_n_0 ),
        .Q(s_axi_rresp),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE rvalid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(rvalid_reg_1),
        .Q(rvalid_reg_0),
        .R(\bresp[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT1 #(
    .INIT(2'h1)) 
    s_axi_arready_INST_0
       (.I0(rvalid_reg_0),
        .O(s_axi_arready));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h1)) 
    s_axi_awready_INST_0
       (.I0(bvalid_reg_0),
        .I1(aw_held_reg_0),
        .O(s_axi_awready));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h1)) 
    s_axi_wready_INST_0
       (.I0(bvalid_reg_0),
        .I1(w_held_reg_0),
        .O(s_axi_wready));
  LUT3 #(
    .INIT(8'h20)) 
    \shadow[0][15]_i_1 
       (.I0(\shadow[0][31]_i_2_n_0 ),
        .I1(\shadow[0][31]_i_3_n_0 ),
        .I2(\w_strb_reg_n_0_[1] ),
        .O(\shadow[0][15]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \shadow[0][23]_i_1 
       (.I0(\shadow[0][31]_i_2_n_0 ),
        .I1(\shadow[0][31]_i_3_n_0 ),
        .I2(\w_strb_reg_n_0_[2] ),
        .O(\shadow[0][23]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \shadow[0][31]_i_1 
       (.I0(\shadow[0][31]_i_2_n_0 ),
        .I1(\shadow[0][31]_i_3_n_0 ),
        .I2(\w_strb_reg_n_0_[3] ),
        .O(\shadow[0][31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'h00000100)) 
    \shadow[0][31]_i_2 
       (.I0(aw_addr[6]),
        .I1(aw_addr[3]),
        .I2(aw_addr[5]),
        .I3(aw_addr[4]),
        .I4(aw_addr[2]),
        .O(\shadow[0][31]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFF7)) 
    \shadow[0][31]_i_3 
       (.I0(aw_held_reg_0),
        .I1(w_held_reg_0),
        .I2(bvalid_reg_0),
        .I3(\aw_addr_reg[1]_0 [0]),
        .I4(\aw_addr_reg[1]_0 [1]),
        .I5(\aw_addr_reg[5]_0 ),
        .O(\shadow[0][31]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \shadow[0][7]_i_1 
       (.I0(\shadow[0][31]_i_2_n_0 ),
        .I1(\shadow[0][31]_i_3_n_0 ),
        .I2(\w_strb_reg_n_0_[0] ),
        .O(\shadow[0][7]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[1][15]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[1] ),
        .I2(\shadow[1][31]_i_2_n_0 ),
        .O(\shadow[1][15]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[1][23]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[2] ),
        .I2(\shadow[1][31]_i_2_n_0 ),
        .O(\shadow[1][23]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[1][31]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[3] ),
        .I2(\shadow[1][31]_i_2_n_0 ),
        .O(\shadow[1][31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'hFFEFFFFF)) 
    \shadow[1][31]_i_2 
       (.I0(aw_addr[6]),
        .I1(aw_addr[3]),
        .I2(aw_addr[2]),
        .I3(aw_addr[5]),
        .I4(aw_addr[4]),
        .O(\shadow[1][31]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[1][7]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[0] ),
        .I2(\shadow[1][31]_i_2_n_0 ),
        .O(\shadow[1][7]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[2][15]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[1] ),
        .I2(\shadow[2][31]_i_2_n_0 ),
        .O(\shadow[2][15]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[2][23]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[2] ),
        .I2(\shadow[2][31]_i_2_n_0 ),
        .O(\shadow[2][23]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[2][31]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[3] ),
        .I2(\shadow[2][31]_i_2_n_0 ),
        .O(\shadow[2][31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'hFFFFFDFF)) 
    \shadow[2][31]_i_2 
       (.I0(aw_addr[3]),
        .I1(aw_addr[6]),
        .I2(aw_addr[5]),
        .I3(aw_addr[4]),
        .I4(aw_addr[2]),
        .O(\shadow[2][31]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[2][7]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[0] ),
        .I2(\shadow[2][31]_i_2_n_0 ),
        .O(\shadow[2][7]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[3][15]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[1] ),
        .I2(\shadow[3][31]_i_2_n_0 ),
        .O(\shadow[3][15]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[3][23]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[2] ),
        .I2(\shadow[3][31]_i_2_n_0 ),
        .O(\shadow[3][23]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[3][31]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[3] ),
        .I2(\shadow[3][31]_i_2_n_0 ),
        .O(\shadow[3][31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'hFFDFFFFF)) 
    \shadow[3][31]_i_2 
       (.I0(aw_addr[3]),
        .I1(aw_addr[6]),
        .I2(aw_addr[2]),
        .I3(aw_addr[5]),
        .I4(aw_addr[4]),
        .O(\shadow[3][31]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[3][7]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[0] ),
        .I2(\shadow[3][31]_i_2_n_0 ),
        .O(\shadow[3][7]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[4][15]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[1] ),
        .I2(\shadow[4][31]_i_2_n_0 ),
        .O(\shadow[4][15]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[4][23]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[2] ),
        .I2(\shadow[4][31]_i_2_n_0 ),
        .O(\shadow[4][23]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[4][31]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[3] ),
        .I2(\shadow[4][31]_i_2_n_0 ),
        .O(\shadow[4][31]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFEFFFF)) 
    \shadow[4][31]_i_2 
       (.I0(aw_addr[2]),
        .I1(aw_addr[3]),
        .I2(aw_addr[6]),
        .I3(aw_addr[4]),
        .I4(aw_addr[5]),
        .O(\shadow[4][31]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[4][7]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[0] ),
        .I2(\shadow[4][31]_i_2_n_0 ),
        .O(\shadow[4][7]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[5][15]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[1] ),
        .I2(\shadow[5][31]_i_2_n_0 ),
        .O(\shadow[5][15]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[5][23]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[2] ),
        .I2(\shadow[5][31]_i_2_n_0 ),
        .O(\shadow[5][23]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[5][31]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[3] ),
        .I2(\shadow[5][31]_i_2_n_0 ),
        .O(\shadow[5][31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFEFFFFFF)) 
    \shadow[5][31]_i_2 
       (.I0(aw_addr[3]),
        .I1(aw_addr[6]),
        .I2(aw_addr[4]),
        .I3(aw_addr[5]),
        .I4(aw_addr[2]),
        .O(\shadow[5][31]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \shadow[5][7]_i_1 
       (.I0(\shadow[0][31]_i_3_n_0 ),
        .I1(\w_strb_reg_n_0_[0] ),
        .I2(\shadow[5][31]_i_2_n_0 ),
        .O(\shadow[5][7]_i_1_n_0 ));
  FDRE \shadow_reg[0][0] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[0] ),
        .Q(\shadow_reg_n_0_[0][0] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][10] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[10] ),
        .Q(\shadow_reg_n_0_[0][10] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][11] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[11] ),
        .Q(\shadow_reg_n_0_[0][11] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][12] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[12] ),
        .Q(\shadow_reg_n_0_[0][12] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][13] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[13] ),
        .Q(\shadow_reg_n_0_[0][13] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][14] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[14] ),
        .Q(\shadow_reg_n_0_[0][14] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][15] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[15] ),
        .Q(\shadow_reg_n_0_[0][15] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][16] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[16] ),
        .Q(\shadow_reg_n_0_[0][16] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][17] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[17] ),
        .Q(\shadow_reg_n_0_[0][17] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][18] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[18] ),
        .Q(\shadow_reg_n_0_[0][18] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][19] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[19] ),
        .Q(\shadow_reg_n_0_[0][19] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][1] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[1] ),
        .Q(\shadow_reg_n_0_[0][1] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][20] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[20] ),
        .Q(\shadow_reg_n_0_[0][20] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][21] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[21] ),
        .Q(\shadow_reg_n_0_[0][21] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][22] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[22] ),
        .Q(\shadow_reg_n_0_[0][22] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][23] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[23] ),
        .Q(\shadow_reg_n_0_[0][23] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][24] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[24] ),
        .Q(\shadow_reg_n_0_[0][24] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][25] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[25] ),
        .Q(\shadow_reg_n_0_[0][25] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][26] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[26] ),
        .Q(\shadow_reg_n_0_[0][26] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][27] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[27] ),
        .Q(\shadow_reg_n_0_[0][27] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][28] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[28] ),
        .Q(\shadow_reg_n_0_[0][28] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][29] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[29] ),
        .Q(\shadow_reg_n_0_[0][29] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][2] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[2] ),
        .Q(\shadow_reg_n_0_[0][2] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][30] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[30] ),
        .Q(\shadow_reg_n_0_[0][30] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][31] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[31] ),
        .Q(\shadow_reg_n_0_[0][31] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][3] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[3] ),
        .Q(\shadow_reg_n_0_[0][3] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][4] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[4] ),
        .Q(\shadow_reg_n_0_[0][4] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][5] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[5] ),
        .Q(\shadow_reg_n_0_[0][5] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][6] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[6] ),
        .Q(\shadow_reg_n_0_[0][6] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][7] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[7] ),
        .Q(\shadow_reg_n_0_[0][7] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][8] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[8] ),
        .Q(\shadow_reg_n_0_[0][8] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[0][9] 
       (.C(s_axi_aclk),
        .CE(\shadow[0][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[9] ),
        .Q(\shadow_reg_n_0_[0][9] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][0] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[0] ),
        .Q(\shadow_reg_n_0_[1][0] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][10] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[10] ),
        .Q(\shadow_reg_n_0_[1][10] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][11] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[11] ),
        .Q(\shadow_reg_n_0_[1][11] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][12] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[12] ),
        .Q(\shadow_reg_n_0_[1][12] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][13] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[13] ),
        .Q(\shadow_reg_n_0_[1][13] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][14] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[14] ),
        .Q(\shadow_reg_n_0_[1][14] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][15] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[15] ),
        .Q(\shadow_reg_n_0_[1][15] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][16] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[16] ),
        .Q(\shadow_reg_n_0_[1][16] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][17] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[17] ),
        .Q(\shadow_reg_n_0_[1][17] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][18] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[18] ),
        .Q(\shadow_reg_n_0_[1][18] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][19] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[19] ),
        .Q(\shadow_reg_n_0_[1][19] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][1] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[1] ),
        .Q(\shadow_reg_n_0_[1][1] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][20] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[20] ),
        .Q(\shadow_reg_n_0_[1][20] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][21] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[21] ),
        .Q(\shadow_reg_n_0_[1][21] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][22] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[22] ),
        .Q(\shadow_reg_n_0_[1][22] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][23] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[23] ),
        .Q(\shadow_reg_n_0_[1][23] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][24] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[24] ),
        .Q(\shadow_reg_n_0_[1][24] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][25] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[25] ),
        .Q(\shadow_reg_n_0_[1][25] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][26] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[26] ),
        .Q(\shadow_reg_n_0_[1][26] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][27] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[27] ),
        .Q(\shadow_reg_n_0_[1][27] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][28] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[28] ),
        .Q(\shadow_reg_n_0_[1][28] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][29] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[29] ),
        .Q(\shadow_reg_n_0_[1][29] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][2] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[2] ),
        .Q(\shadow_reg_n_0_[1][2] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][30] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[30] ),
        .Q(\shadow_reg_n_0_[1][30] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][31] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[31] ),
        .Q(\shadow_reg_n_0_[1][31] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][3] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[3] ),
        .Q(\shadow_reg_n_0_[1][3] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][4] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[4] ),
        .Q(\shadow_reg_n_0_[1][4] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][5] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[5] ),
        .Q(\shadow_reg_n_0_[1][5] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][6] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[6] ),
        .Q(\shadow_reg_n_0_[1][6] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][7] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[7] ),
        .Q(\shadow_reg_n_0_[1][7] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][8] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[8] ),
        .Q(\shadow_reg_n_0_[1][8] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[1][9] 
       (.C(s_axi_aclk),
        .CE(\shadow[1][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[9] ),
        .Q(\shadow_reg_n_0_[1][9] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][0] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[0] ),
        .Q(\shadow_reg_n_0_[2][0] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][10] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[10] ),
        .Q(\shadow_reg_n_0_[2][10] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][11] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[11] ),
        .Q(\shadow_reg_n_0_[2][11] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][12] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[12] ),
        .Q(\shadow_reg_n_0_[2][12] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][13] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[13] ),
        .Q(\shadow_reg_n_0_[2][13] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][14] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[14] ),
        .Q(\shadow_reg_n_0_[2][14] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][15] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[15] ),
        .Q(\shadow_reg_n_0_[2][15] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][16] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[16] ),
        .Q(\shadow_reg_n_0_[2][16] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][17] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[17] ),
        .Q(\shadow_reg_n_0_[2][17] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][18] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[18] ),
        .Q(\shadow_reg_n_0_[2][18] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][19] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[19] ),
        .Q(\shadow_reg_n_0_[2][19] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][1] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[1] ),
        .Q(\shadow_reg_n_0_[2][1] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][20] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[20] ),
        .Q(\shadow_reg_n_0_[2][20] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][21] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[21] ),
        .Q(\shadow_reg_n_0_[2][21] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][22] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[22] ),
        .Q(\shadow_reg_n_0_[2][22] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][23] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[23] ),
        .Q(\shadow_reg_n_0_[2][23] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][24] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[24] ),
        .Q(\shadow_reg_n_0_[2][24] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][25] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[25] ),
        .Q(\shadow_reg_n_0_[2][25] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][26] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[26] ),
        .Q(\shadow_reg_n_0_[2][26] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][27] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[27] ),
        .Q(\shadow_reg_n_0_[2][27] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][28] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[28] ),
        .Q(\shadow_reg_n_0_[2][28] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][29] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[29] ),
        .Q(\shadow_reg_n_0_[2][29] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][2] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[2] ),
        .Q(\shadow_reg_n_0_[2][2] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][30] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[30] ),
        .Q(\shadow_reg_n_0_[2][30] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][31] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[31] ),
        .Q(\shadow_reg_n_0_[2][31] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][3] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[3] ),
        .Q(\shadow_reg_n_0_[2][3] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][4] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[4] ),
        .Q(\shadow_reg_n_0_[2][4] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][5] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[5] ),
        .Q(\shadow_reg_n_0_[2][5] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][6] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[6] ),
        .Q(\shadow_reg_n_0_[2][6] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][7] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[7] ),
        .Q(\shadow_reg_n_0_[2][7] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][8] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[8] ),
        .Q(\shadow_reg_n_0_[2][8] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[2][9] 
       (.C(s_axi_aclk),
        .CE(\shadow[2][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[9] ),
        .Q(\shadow_reg_n_0_[2][9] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][0] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[0] ),
        .Q(\shadow_reg_n_0_[3][0] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][10] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[10] ),
        .Q(\shadow_reg_n_0_[3][10] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][11] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[11] ),
        .Q(\shadow_reg_n_0_[3][11] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][12] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[12] ),
        .Q(\shadow_reg_n_0_[3][12] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][13] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[13] ),
        .Q(\shadow_reg_n_0_[3][13] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][14] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[14] ),
        .Q(\shadow_reg_n_0_[3][14] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][15] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[15] ),
        .Q(\shadow_reg_n_0_[3][15] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][16] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[16] ),
        .Q(\shadow_reg_n_0_[3][16] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][17] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[17] ),
        .Q(\shadow_reg_n_0_[3][17] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][18] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[18] ),
        .Q(\shadow_reg_n_0_[3][18] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][19] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[19] ),
        .Q(\shadow_reg_n_0_[3][19] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][1] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[1] ),
        .Q(\shadow_reg_n_0_[3][1] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][20] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[20] ),
        .Q(\shadow_reg_n_0_[3][20] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][21] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[21] ),
        .Q(\shadow_reg_n_0_[3][21] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][22] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[22] ),
        .Q(\shadow_reg_n_0_[3][22] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][23] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[23] ),
        .Q(\shadow_reg_n_0_[3][23] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][24] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[24] ),
        .Q(\shadow_reg_n_0_[3][24] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][25] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[25] ),
        .Q(\shadow_reg_n_0_[3][25] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][26] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[26] ),
        .Q(\shadow_reg_n_0_[3][26] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][27] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[27] ),
        .Q(\shadow_reg_n_0_[3][27] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][28] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[28] ),
        .Q(\shadow_reg_n_0_[3][28] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][29] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[29] ),
        .Q(\shadow_reg_n_0_[3][29] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][2] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[2] ),
        .Q(\shadow_reg_n_0_[3][2] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][30] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[30] ),
        .Q(\shadow_reg_n_0_[3][30] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][31] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[31] ),
        .Q(\shadow_reg_n_0_[3][31] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][3] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[3] ),
        .Q(\shadow_reg_n_0_[3][3] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][4] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[4] ),
        .Q(\shadow_reg_n_0_[3][4] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][5] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[5] ),
        .Q(\shadow_reg_n_0_[3][5] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][6] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[6] ),
        .Q(\shadow_reg_n_0_[3][6] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][7] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[7] ),
        .Q(\shadow_reg_n_0_[3][7] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][8] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[8] ),
        .Q(\shadow_reg_n_0_[3][8] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[3][9] 
       (.C(s_axi_aclk),
        .CE(\shadow[3][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[9] ),
        .Q(\shadow_reg_n_0_[3][9] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][0] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[0] ),
        .Q(\shadow_reg_n_0_[4][0] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][10] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[10] ),
        .Q(\shadow_reg_n_0_[4][10] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][11] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[11] ),
        .Q(\shadow_reg_n_0_[4][11] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][12] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[12] ),
        .Q(\shadow_reg_n_0_[4][12] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][13] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[13] ),
        .Q(\shadow_reg_n_0_[4][13] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][14] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[14] ),
        .Q(\shadow_reg_n_0_[4][14] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][15] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[15] ),
        .Q(\shadow_reg_n_0_[4][15] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][16] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[16] ),
        .Q(\shadow_reg_n_0_[4][16] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][17] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[17] ),
        .Q(\shadow_reg_n_0_[4][17] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][18] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[18] ),
        .Q(\shadow_reg_n_0_[4][18] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][19] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[19] ),
        .Q(\shadow_reg_n_0_[4][19] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][1] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[1] ),
        .Q(\shadow_reg_n_0_[4][1] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][20] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[20] ),
        .Q(\shadow_reg_n_0_[4][20] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][21] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[21] ),
        .Q(\shadow_reg_n_0_[4][21] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][22] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[22] ),
        .Q(\shadow_reg_n_0_[4][22] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][23] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[23] ),
        .Q(\shadow_reg_n_0_[4][23] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][24] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[24] ),
        .Q(\shadow_reg_n_0_[4][24] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][25] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[25] ),
        .Q(\shadow_reg_n_0_[4][25] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][26] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[26] ),
        .Q(\shadow_reg_n_0_[4][26] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][27] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[27] ),
        .Q(\shadow_reg_n_0_[4][27] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][28] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[28] ),
        .Q(\shadow_reg_n_0_[4][28] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][29] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[29] ),
        .Q(\shadow_reg_n_0_[4][29] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][2] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[2] ),
        .Q(\shadow_reg_n_0_[4][2] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][30] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[30] ),
        .Q(\shadow_reg_n_0_[4][30] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][31] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[31] ),
        .Q(\shadow_reg_n_0_[4][31] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][3] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[3] ),
        .Q(\shadow_reg_n_0_[4][3] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][4] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[4] ),
        .Q(\shadow_reg_n_0_[4][4] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][5] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[5] ),
        .Q(\shadow_reg_n_0_[4][5] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][6] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[6] ),
        .Q(\shadow_reg_n_0_[4][6] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][7] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[7] ),
        .Q(\shadow_reg_n_0_[4][7] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][8] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[8] ),
        .Q(\shadow_reg_n_0_[4][8] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[4][9] 
       (.C(s_axi_aclk),
        .CE(\shadow[4][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[9] ),
        .Q(\shadow_reg_n_0_[4][9] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][0] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[0] ),
        .Q(\shadow_reg_n_0_[5][0] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][10] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[10] ),
        .Q(\shadow_reg_n_0_[5][10] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][11] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[11] ),
        .Q(\shadow_reg_n_0_[5][11] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][12] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[12] ),
        .Q(\shadow_reg_n_0_[5][12] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][13] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[13] ),
        .Q(\shadow_reg_n_0_[5][13] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][14] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[14] ),
        .Q(\shadow_reg_n_0_[5][14] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][15] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[15] ),
        .Q(\shadow_reg_n_0_[5][15] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][16] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[16] ),
        .Q(\shadow_reg_n_0_[5][16] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][17] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[17] ),
        .Q(\shadow_reg_n_0_[5][17] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][18] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[18] ),
        .Q(\shadow_reg_n_0_[5][18] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][19] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[19] ),
        .Q(\shadow_reg_n_0_[5][19] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][1] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[1] ),
        .Q(\shadow_reg_n_0_[5][1] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][20] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[20] ),
        .Q(\shadow_reg_n_0_[5][20] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][21] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[21] ),
        .Q(\shadow_reg_n_0_[5][21] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][22] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[22] ),
        .Q(\shadow_reg_n_0_[5][22] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][23] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][23]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[23] ),
        .Q(\shadow_reg_n_0_[5][23] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][24] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[24] ),
        .Q(\shadow_reg_n_0_[5][24] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][25] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[25] ),
        .Q(\shadow_reg_n_0_[5][25] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][26] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[26] ),
        .Q(\shadow_reg_n_0_[5][26] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][27] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[27] ),
        .Q(\shadow_reg_n_0_[5][27] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][28] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[28] ),
        .Q(\shadow_reg_n_0_[5][28] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][29] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[29] ),
        .Q(\shadow_reg_n_0_[5][29] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][2] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[2] ),
        .Q(\shadow_reg_n_0_[5][2] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][30] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[30] ),
        .Q(\shadow_reg_n_0_[5][30] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][31] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][31]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[31] ),
        .Q(\shadow_reg_n_0_[5][31] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][3] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[3] ),
        .Q(\shadow_reg_n_0_[5][3] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][4] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[4] ),
        .Q(\shadow_reg_n_0_[5][4] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][5] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[5] ),
        .Q(\shadow_reg_n_0_[5][5] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][6] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[6] ),
        .Q(\shadow_reg_n_0_[5][6] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][7] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][7]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[7] ),
        .Q(\shadow_reg_n_0_[5][7] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][8] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[8] ),
        .Q(\shadow_reg_n_0_[5][8] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \shadow_reg[5][9] 
       (.C(s_axi_aclk),
        .CE(\shadow[5][15]_i_1_n_0 ),
        .D(\w_data_reg_n_0_[9] ),
        .Q(\shadow_reg_n_0_[5][9] ),
        .R(\bresp[1]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h02)) 
    \w_data[31]_i_1 
       (.I0(s_axi_wvalid),
        .I1(w_held_reg_0),
        .I2(bvalid_reg_0),
        .O(w_held0));
  FDRE \w_data_reg[0] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[0]),
        .Q(\w_data_reg_n_0_[0] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[10] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[10]),
        .Q(\w_data_reg_n_0_[10] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[11] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[11]),
        .Q(\w_data_reg_n_0_[11] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[12] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[12]),
        .Q(\w_data_reg_n_0_[12] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[13] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[13]),
        .Q(\w_data_reg_n_0_[13] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[14] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[14]),
        .Q(\w_data_reg_n_0_[14] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[15] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[15]),
        .Q(\w_data_reg_n_0_[15] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[16] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[16]),
        .Q(\w_data_reg_n_0_[16] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[17] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[17]),
        .Q(\w_data_reg_n_0_[17] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[18] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[18]),
        .Q(\w_data_reg_n_0_[18] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[19] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[19]),
        .Q(\w_data_reg_n_0_[19] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[1] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[1]),
        .Q(\w_data_reg_n_0_[1] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[20] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[20]),
        .Q(\w_data_reg_n_0_[20] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[21] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[21]),
        .Q(\w_data_reg_n_0_[21] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[22] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[22]),
        .Q(\w_data_reg_n_0_[22] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[23] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[23]),
        .Q(\w_data_reg_n_0_[23] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[24] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[24]),
        .Q(\w_data_reg_n_0_[24] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[25] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[25]),
        .Q(\w_data_reg_n_0_[25] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[26] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[26]),
        .Q(\w_data_reg_n_0_[26] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[27] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[27]),
        .Q(\w_data_reg_n_0_[27] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[28] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[28]),
        .Q(\w_data_reg_n_0_[28] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[29] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[29]),
        .Q(\w_data_reg_n_0_[29] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[2] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[2]),
        .Q(\w_data_reg_n_0_[2] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[30] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[30]),
        .Q(\w_data_reg_n_0_[30] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[31] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[31]),
        .Q(\w_data_reg_n_0_[31] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[3] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[3]),
        .Q(\w_data_reg_n_0_[3] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[4] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[4]),
        .Q(\w_data_reg_n_0_[4] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[5] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[5]),
        .Q(\w_data_reg_n_0_[5] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[6] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[6]),
        .Q(\w_data_reg_n_0_[6] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[7] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[7]),
        .Q(\w_data_reg_n_0_[7] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[8] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[8]),
        .Q(\w_data_reg_n_0_[8] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_data_reg[9] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[9]),
        .Q(\w_data_reg_n_0_[9] ),
        .R(\bresp[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8888000000888080)) 
    w_held_i_1
       (.I0(rvalid_reg_2),
        .I1(rvalid_reg_3),
        .I2(s_axi_wvalid),
        .I3(aw_held_reg_0),
        .I4(w_held_reg_0),
        .I5(bvalid_reg_0),
        .O(w_held_i_1_n_0));
  FDRE w_held_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(w_held_i_1_n_0),
        .Q(w_held_reg_0),
        .R(1'b0));
  FDRE \w_strb_reg[0] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wstrb[0]),
        .Q(\w_strb_reg_n_0_[0] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_strb_reg[1] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wstrb[1]),
        .Q(\w_strb_reg_n_0_[1] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_strb_reg[2] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wstrb[2]),
        .Q(\w_strb_reg_n_0_[2] ),
        .R(\bresp[1]_i_1_n_0 ));
  FDRE \w_strb_reg[3] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wstrb[3]),
        .Q(\w_strb_reg_n_0_[3] ),
        .R(\bresp[1]_i_1_n_0 ));
endmodule

(* ORIG_REF_NAME = "input_osd_pixels" *) 
module c6v_input_osd_0_0_input_osd_pixels
   (vs_prev_reg_0,
    out_de,
    out_hs,
    out_vs,
    \y_reg[9]_0 ,
    \x_reg[10]_0 ,
    out_rgb,
    \paint2_reg[23]_0 ,
    in_de,
    pclk,
    Q,
    in_vs,
    hand10,
    in_hs,
    S,
    dy10_carry__1_i_1_0,
    \dy1_reg[9]_0 ,
    dx12_carry__0_0,
    dx10_carry__1_i_1_0,
    out,
    \paint2_reg[7]_0 ,
    in_rgb);
  output vs_prev_reg_0;
  output out_de;
  output out_hs;
  output out_vs;
  output [9:0]\y_reg[9]_0 ;
  output [10:0]\x_reg[10]_0 ;
  output [23:0]out_rgb;
  input \paint2_reg[23]_0 ;
  input in_de;
  input pclk;
  input [22:0]Q;
  input in_vs;
  input hand10;
  input in_hs;
  input [3:0]S;
  input [0:0]dy10_carry__1_i_1_0;
  input [0:0]\dy1_reg[9]_0 ;
  input [3:0]dx12_carry__0_0;
  input [1:0]dx10_carry__1_i_1_0;
  input [0:0]out;
  input [0:0]\paint2_reg[7]_0 ;
  input [23:0]in_rgb;

  wire [22:0]Q;
  wire [3:0]S;
  wire [9:0]ay;
  wire de2;
  wire de_prev;
  wire [10:0]dx10;
  wire dx10_carry__0_i_1_n_0;
  wire dx10_carry__0_i_2_n_0;
  wire dx10_carry__0_i_3_n_0;
  wire dx10_carry__0_i_4_n_0;
  wire dx10_carry__0_i_5_n_0;
  wire dx10_carry__0_i_6_n_0;
  wire dx10_carry__0_i_7_n_0;
  wire dx10_carry__0_i_8_n_0;
  wire dx10_carry__0_n_0;
  wire dx10_carry__0_n_1;
  wire dx10_carry__0_n_2;
  wire dx10_carry__0_n_3;
  wire [1:0]dx10_carry__1_i_1_0;
  wire dx10_carry__1_i_1_n_0;
  wire dx10_carry__1_i_2_n_0;
  wire dx10_carry__1_i_3_n_0;
  wire dx10_carry__1_i_4_n_0;
  wire dx10_carry__1_i_5_n_0;
  wire dx10_carry__1_n_2;
  wire dx10_carry__1_n_3;
  wire dx10_carry_i_1_n_0;
  wire dx10_carry_i_2_n_0;
  wire dx10_carry_i_3_n_0;
  wire dx10_carry_i_4_n_0;
  wire dx10_carry_i_5_n_0;
  wire dx10_carry_i_6_n_0;
  wire dx10_carry_i_7_n_0;
  wire dx10_carry_i_8_n_0;
  wire dx10_carry_n_0;
  wire dx10_carry_n_1;
  wire dx10_carry_n_2;
  wire dx10_carry_n_3;
  wire dx12;
  wire [3:0]dx12_carry__0_0;
  wire dx12_carry__0_i_1_n_0;
  wire dx12_carry__0_i_2_n_0;
  wire dx12_carry__0_n_3;
  wire dx12_carry_i_1_n_0;
  wire dx12_carry_i_2_n_0;
  wire dx12_carry_i_3_n_0;
  wire dx12_carry_i_4_n_0;
  wire dx12_carry_n_0;
  wire dx12_carry_n_1;
  wire dx12_carry_n_2;
  wire dx12_carry_n_3;
  wire [9:0]dy10;
  wire dy10_carry__0_i_1_n_0;
  wire dy10_carry__0_i_2_n_0;
  wire dy10_carry__0_i_3_n_0;
  wire dy10_carry__0_i_4_n_0;
  wire dy10_carry__0_i_5_n_0;
  wire dy10_carry__0_i_6_n_0;
  wire dy10_carry__0_i_7_n_0;
  wire dy10_carry__0_i_8_n_0;
  wire dy10_carry__0_n_0;
  wire dy10_carry__0_n_1;
  wire dy10_carry__0_n_2;
  wire dy10_carry__0_n_3;
  wire [0:0]dy10_carry__1_i_1_0;
  wire dy10_carry__1_i_1_n_0;
  wire dy10_carry__1_i_3_n_0;
  wire dy10_carry__1_n_3;
  wire dy10_carry_i_1_n_0;
  wire dy10_carry_i_2_n_0;
  wire dy10_carry_i_3_n_0;
  wire dy10_carry_i_4_n_0;
  wire dy10_carry_i_5_n_0;
  wire dy10_carry_i_6_n_0;
  wire dy10_carry_i_7_n_0;
  wire dy10_carry_i_8_n_0;
  wire dy10_carry_n_0;
  wire dy10_carry_n_1;
  wire dy10_carry_n_2;
  wire dy10_carry_n_3;
  wire dy12;
  wire dy12_carry__0_i_1_n_0;
  wire dy12_carry_i_1_n_0;
  wire dy12_carry_i_2_n_0;
  wire dy12_carry_i_3_n_0;
  wire dy12_carry_i_4_n_0;
  wire dy12_carry_n_0;
  wire dy12_carry_n_1;
  wire dy12_carry_n_2;
  wire dy12_carry_n_3;
  wire [0:0]\dy1_reg[9]_0 ;
  wire enable1;
  wire fist1;
  wire g0_b0__0_n_0;
  wire g0_b0__1_n_0;
  wire g0_b0_n_0;
  wire g0_b1__0_n_0;
  wire g0_b1__1_n_0;
  wire g0_b1_n_0;
  wire g0_b2__0_n_0;
  wire g0_b2__1_n_0;
  wire g0_b2_n_0;
  wire g0_b3__0_n_0;
  wire g0_b3__1_n_0;
  wire g0_b3_n_0;
  wire g0_b4__0_n_0;
  wire g0_b4__1_n_0;
  wire g0_b4_n_0;
  wire g0_b5__0_n_0;
  wire g0_b5__1_n_0;
  wire g0_b5_n_0;
  wire g0_b6__0_n_0;
  wire g0_b6_n_0;
  wire hand1;
  wire hand10;
  wire hit2;
  wire hit23;
  wire hit23_carry__0_n_3;
  wire hit23_carry_i_10_n_0;
  wire hit23_carry_i_11_n_0;
  wire hit23_carry_i_12_n_0;
  wire hit23_carry_i_13_n_0;
  wire hit23_carry_i_14_n_0;
  wire hit23_carry_i_15_n_0;
  wire hit23_carry_i_16_n_0;
  wire hit23_carry_i_17_n_0;
  wire hit23_carry_i_18_n_0;
  wire hit23_carry_i_1__0_n_0;
  wire hit23_carry_i_1_n_0;
  wire hit23_carry_i_2__0_n_0;
  wire hit23_carry_i_2_n_0;
  wire hit23_carry_i_3__0_n_0;
  wire hit23_carry_i_3_n_0;
  wire hit23_carry_i_4__0_n_0;
  wire hit23_carry_i_4_n_0;
  wire hit23_carry_i_5__0_n_0;
  wire hit23_carry_i_5_n_0;
  wire hit23_carry_i_6_n_0;
  wire hit23_carry_i_7_n_0;
  wire hit23_carry_i_8_n_0;
  wire hit23_carry_i_9_n_0;
  wire hit23_carry_n_0;
  wire hit23_carry_n_1;
  wire hit23_carry_n_2;
  wire hit23_carry_n_3;
  wire hit24;
  wire hit24_carry__0_i_1_n_0;
  wire hit24_carry__0_i_2_n_0;
  wire hit24_carry__0_i_3_n_0;
  wire hit24_carry__0_n_3;
  wire hit24_carry_i_10_n_0;
  wire hit24_carry_i_11_n_0;
  wire hit24_carry_i_12_n_0;
  wire hit24_carry_i_13_n_0;
  wire hit24_carry_i_14_n_0;
  wire hit24_carry_i_15_n_0;
  wire hit24_carry_i_16_n_0;
  wire hit24_carry_i_17_n_0;
  wire hit24_carry_i_18_n_0;
  wire hit24_carry_i_19_n_0;
  wire hit24_carry_i_1_n_0;
  wire hit24_carry_i_20_n_0;
  wire hit24_carry_i_21_n_0;
  wire hit24_carry_i_22_n_0;
  wire hit24_carry_i_23_n_0;
  wire hit24_carry_i_24_n_0;
  wire hit24_carry_i_25_n_0;
  wire hit24_carry_i_2_n_0;
  wire hit24_carry_i_3_n_0;
  wire hit24_carry_i_4_n_0;
  wire hit24_carry_i_5_n_0;
  wire hit24_carry_i_6_n_0;
  wire hit24_carry_i_7_n_0;
  wire hit24_carry_i_8_n_0;
  wire hit24_carry_i_9_n_0;
  wire hit24_carry_n_0;
  wire hit24_carry_n_1;
  wire hit24_carry_n_2;
  wire hit24_carry_n_3;
  wire hit2_i_1_n_0;
  wire hs1;
  wire hs2;
  wire in_de;
  wire in_hs;
  wire [23:0]in_rgb;
  wire in_vs;
  wire [0:0]out;
  wire out_de;
  wire out_hs;
  wire [23:0]out_rgb;
  wire \out_rgb[0]_i_1_n_0 ;
  wire \out_rgb[10]_i_1_n_0 ;
  wire \out_rgb[11]_i_1_n_0 ;
  wire \out_rgb[12]_i_1_n_0 ;
  wire \out_rgb[13]_i_1_n_0 ;
  wire \out_rgb[14]_i_1_n_0 ;
  wire \out_rgb[15]_i_1_n_0 ;
  wire \out_rgb[16]_i_1_n_0 ;
  wire \out_rgb[17]_i_1_n_0 ;
  wire \out_rgb[18]_i_1_n_0 ;
  wire \out_rgb[19]_i_1_n_0 ;
  wire \out_rgb[1]_i_1_n_0 ;
  wire \out_rgb[20]_i_1_n_0 ;
  wire \out_rgb[21]_i_1_n_0 ;
  wire \out_rgb[22]_i_1_n_0 ;
  wire \out_rgb[23]_i_2_n_0 ;
  wire \out_rgb[2]_i_1_n_0 ;
  wire \out_rgb[3]_i_1_n_0 ;
  wire \out_rgb[4]_i_1_n_0 ;
  wire \out_rgb[5]_i_1_n_0 ;
  wire \out_rgb[6]_i_1_n_0 ;
  wire \out_rgb[7]_i_1_n_0 ;
  wire \out_rgb[8]_i_1_n_0 ;
  wire \out_rgb[9]_i_1_n_0 ;
  wire out_vs;
  wire [9:1]p_0_in;
  wire [10:0]p_0_in_0;
  wire [10:1]p_0_in__0;
  wire [23:23]paint2;
  wire \paint2[23]_i_2_n_0 ;
  wire \paint2[23]_i_3_n_0 ;
  wire \paint2[23]_i_4_n_0 ;
  wire \paint2[23]_i_5_n_0 ;
  wire \paint2[23]_i_6_n_0 ;
  wire \paint2[23]_i_7_n_0 ;
  wire \paint2[23]_i_8_n_0 ;
  wire \paint2[7]_i_1_n_0 ;
  wire \paint2_reg[23]_0 ;
  wire [0:0]\paint2_reg[7]_0 ;
  wire \paint2_reg_n_0_[23] ;
  wire \paint2_reg_n_0_[7] ;
  wire pclk;
  wire [23:0]rgb1;
  wire [23:0]rgb2;
  wire vs2;
  wire vs_prev_reg_0;
  wire \x[0]_i_1_n_0 ;
  wire \x[10]_i_1_n_0 ;
  wire \x[10]_i_2_n_0 ;
  wire \x[10]_i_4_n_0 ;
  wire \x[2]_i_1_n_0 ;
  wire \x[3]_i_1_n_0 ;
  wire \x[4]_i_1_n_0 ;
  wire \x[5]_i_1_n_0 ;
  wire \x[6]_i_1_n_0 ;
  wire \x[7]_i_1_n_0 ;
  wire \x[8]_i_1_n_0 ;
  wire [10:0]\x_reg[10]_0 ;
  wire y;
  wire \y[0]_i_1_n_0 ;
  wire \y[2]_i_1_n_0 ;
  wire \y[3]_i_1_n_0 ;
  wire \y[4]_i_1_n_0 ;
  wire \y[5]_i_1_n_0 ;
  wire \y[6]_i_1_n_0 ;
  wire \y[9]_i_1_n_0 ;
  wire \y[9]_i_4_n_0 ;
  wire \y[9]_i_5_n_0 ;
  wire [9:0]\y_reg[9]_0 ;
  wire [3:2]NLW_dx10_carry__1_CO_UNCONNECTED;
  wire [3:3]NLW_dx10_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_dx12_carry_O_UNCONNECTED;
  wire [3:2]NLW_dx12_carry__0_CO_UNCONNECTED;
  wire [3:0]NLW_dx12_carry__0_O_UNCONNECTED;
  wire [3:1]NLW_dy10_carry__1_CO_UNCONNECTED;
  wire [3:2]NLW_dy10_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_dy12_carry_O_UNCONNECTED;
  wire [3:1]NLW_dy12_carry__0_CO_UNCONNECTED;
  wire [3:0]NLW_dy12_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_hit23_carry_O_UNCONNECTED;
  wire [3:2]NLW_hit23_carry__0_CO_UNCONNECTED;
  wire [3:0]NLW_hit23_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_hit24_carry_O_UNCONNECTED;
  wire [3:2]NLW_hit24_carry__0_CO_UNCONNECTED;
  wire [3:0]NLW_hit24_carry__0_O_UNCONNECTED;

  FDRE de2_reg
       (.C(pclk),
        .CE(1'b1),
        .D(de_prev),
        .Q(de2),
        .R(\paint2_reg[23]_0 ));
  FDRE de_prev_reg
       (.C(pclk),
        .CE(1'b1),
        .D(in_de),
        .Q(de_prev),
        .R(\paint2_reg[23]_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 dx10_carry
       (.CI(1'b0),
        .CO({dx10_carry_n_0,dx10_carry_n_1,dx10_carry_n_2,dx10_carry_n_3}),
        .CYINIT(1'b1),
        .DI({dx10_carry_i_1_n_0,dx10_carry_i_2_n_0,dx10_carry_i_3_n_0,dx10_carry_i_4_n_0}),
        .O(dx10[3:0]),
        .S({dx10_carry_i_5_n_0,dx10_carry_i_6_n_0,dx10_carry_i_7_n_0,dx10_carry_i_8_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 dx10_carry__0
       (.CI(dx10_carry_n_0),
        .CO({dx10_carry__0_n_0,dx10_carry__0_n_1,dx10_carry__0_n_2,dx10_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({dx10_carry__0_i_1_n_0,dx10_carry__0_i_2_n_0,dx10_carry__0_i_3_n_0,dx10_carry__0_i_4_n_0}),
        .O(dx10[7:4]),
        .S({dx10_carry__0_i_5_n_0,dx10_carry__0_i_6_n_0,dx10_carry__0_i_7_n_0,dx10_carry__0_i_8_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry__0_i_1
       (.I0(dx12),
        .I1(\x_reg[10]_0 [7]),
        .O(dx10_carry__0_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry__0_i_2
       (.I0(dx12),
        .I1(\x_reg[10]_0 [6]),
        .O(dx10_carry__0_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry__0_i_3
       (.I0(dx12),
        .I1(\x_reg[10]_0 [5]),
        .O(dx10_carry__0_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry__0_i_4
       (.I0(dx12),
        .I1(\x_reg[10]_0 [4]),
        .O(dx10_carry__0_i_4_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry__0_i_5
       (.I0(\x_reg[10]_0 [7]),
        .I1(Q[9]),
        .O(dx10_carry__0_i_5_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry__0_i_6
       (.I0(\x_reg[10]_0 [6]),
        .I1(Q[8]),
        .O(dx10_carry__0_i_6_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry__0_i_7
       (.I0(\x_reg[10]_0 [5]),
        .I1(Q[7]),
        .O(dx10_carry__0_i_7_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry__0_i_8
       (.I0(\x_reg[10]_0 [4]),
        .I1(Q[6]),
        .O(dx10_carry__0_i_8_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 dx10_carry__1
       (.CI(dx10_carry__0_n_0),
        .CO({NLW_dx10_carry__1_CO_UNCONNECTED[3:2],dx10_carry__1_n_2,dx10_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,dx10_carry__1_i_1_n_0,dx10_carry__1_i_2_n_0}),
        .O({NLW_dx10_carry__1_O_UNCONNECTED[3],dx10[10:8]}),
        .S({1'b0,dx10_carry__1_i_3_n_0,dx10_carry__1_i_4_n_0,dx10_carry__1_i_5_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry__1_i_1
       (.I0(dx12),
        .I1(\x_reg[10]_0 [9]),
        .O(dx10_carry__1_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry__1_i_2
       (.I0(dx12),
        .I1(\x_reg[10]_0 [8]),
        .O(dx10_carry__1_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry__1_i_3
       (.I0(\x_reg[10]_0 [10]),
        .I1(Q[12]),
        .O(dx10_carry__1_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry__1_i_4
       (.I0(\x_reg[10]_0 [9]),
        .I1(Q[11]),
        .O(dx10_carry__1_i_4_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry__1_i_5
       (.I0(\x_reg[10]_0 [8]),
        .I1(Q[10]),
        .O(dx10_carry__1_i_5_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry_i_1
       (.I0(dx12),
        .I1(\x_reg[10]_0 [3]),
        .O(dx10_carry_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry_i_2
       (.I0(dx12),
        .I1(\x_reg[10]_0 [2]),
        .O(dx10_carry_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry_i_3
       (.I0(dx12),
        .I1(\x_reg[10]_0 [1]),
        .O(dx10_carry_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry_i_4
       (.I0(dx12),
        .I1(\x_reg[10]_0 [0]),
        .O(dx10_carry_i_4_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry_i_5
       (.I0(\x_reg[10]_0 [3]),
        .I1(Q[5]),
        .O(dx10_carry_i_5_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry_i_6
       (.I0(\x_reg[10]_0 [2]),
        .I1(Q[4]),
        .O(dx10_carry_i_6_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry_i_7
       (.I0(\x_reg[10]_0 [1]),
        .I1(Q[3]),
        .O(dx10_carry_i_7_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dx10_carry_i_8
       (.I0(\x_reg[10]_0 [0]),
        .I1(Q[2]),
        .O(dx10_carry_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 dx12_carry
       (.CI(1'b0),
        .CO({dx12_carry_n_0,dx12_carry_n_1,dx12_carry_n_2,dx12_carry_n_3}),
        .CYINIT(1'b1),
        .DI({dx12_carry_i_1_n_0,dx12_carry_i_2_n_0,dx12_carry_i_3_n_0,dx12_carry_i_4_n_0}),
        .O(NLW_dx12_carry_O_UNCONNECTED[3:0]),
        .S(dx12_carry__0_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 dx12_carry__0
       (.CI(dx12_carry_n_0),
        .CO({NLW_dx12_carry__0_CO_UNCONNECTED[3:2],dx12,dx12_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,dx12_carry__0_i_1_n_0,dx12_carry__0_i_2_n_0}),
        .O(NLW_dx12_carry__0_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,dx10_carry__1_i_1_0}));
  LUT2 #(
    .INIT(4'h2)) 
    dx12_carry__0_i_1
       (.I0(\x_reg[10]_0 [10]),
        .I1(Q[12]),
        .O(dx12_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    dx12_carry__0_i_2
       (.I0(\x_reg[10]_0 [9]),
        .I1(Q[11]),
        .I2(\x_reg[10]_0 [8]),
        .I3(Q[10]),
        .O(dx12_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    dx12_carry_i_1
       (.I0(\x_reg[10]_0 [7]),
        .I1(Q[9]),
        .I2(\x_reg[10]_0 [6]),
        .I3(Q[8]),
        .O(dx12_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    dx12_carry_i_2
       (.I0(\x_reg[10]_0 [5]),
        .I1(Q[7]),
        .I2(\x_reg[10]_0 [4]),
        .I3(Q[6]),
        .O(dx12_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    dx12_carry_i_3
       (.I0(\x_reg[10]_0 [3]),
        .I1(Q[5]),
        .I2(\x_reg[10]_0 [2]),
        .I3(Q[4]),
        .O(dx12_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    dx12_carry_i_4
       (.I0(\x_reg[10]_0 [1]),
        .I1(Q[3]),
        .I2(\x_reg[10]_0 [0]),
        .I3(Q[2]),
        .O(dx12_carry_i_4_n_0));
  FDRE \dx1_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(dx10[0]),
        .Q(p_0_in_0[0]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dx1_reg[10] 
       (.C(pclk),
        .CE(1'b1),
        .D(dx10[10]),
        .Q(p_0_in_0[10]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dx1_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(dx10[1]),
        .Q(p_0_in_0[1]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dx1_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(dx10[2]),
        .Q(p_0_in_0[2]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dx1_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(dx10[3]),
        .Q(p_0_in_0[3]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dx1_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .D(dx10[4]),
        .Q(p_0_in_0[4]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dx1_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .D(dx10[5]),
        .Q(p_0_in_0[5]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dx1_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .D(dx10[6]),
        .Q(p_0_in_0[6]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dx1_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .D(dx10[7]),
        .Q(p_0_in_0[7]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dx1_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .D(dx10[8]),
        .Q(p_0_in_0[8]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dx1_reg[9] 
       (.C(pclk),
        .CE(1'b1),
        .D(dx10[9]),
        .Q(p_0_in_0[9]),
        .R(\paint2_reg[23]_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 dy10_carry
       (.CI(1'b0),
        .CO({dy10_carry_n_0,dy10_carry_n_1,dy10_carry_n_2,dy10_carry_n_3}),
        .CYINIT(1'b1),
        .DI({dy10_carry_i_1_n_0,dy10_carry_i_2_n_0,dy10_carry_i_3_n_0,dy10_carry_i_4_n_0}),
        .O(dy10[3:0]),
        .S({dy10_carry_i_5_n_0,dy10_carry_i_6_n_0,dy10_carry_i_7_n_0,dy10_carry_i_8_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 dy10_carry__0
       (.CI(dy10_carry_n_0),
        .CO({dy10_carry__0_n_0,dy10_carry__0_n_1,dy10_carry__0_n_2,dy10_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({dy10_carry__0_i_1_n_0,dy10_carry__0_i_2_n_0,dy10_carry__0_i_3_n_0,dy10_carry__0_i_4_n_0}),
        .O(dy10[7:4]),
        .S({dy10_carry__0_i_5_n_0,dy10_carry__0_i_6_n_0,dy10_carry__0_i_7_n_0,dy10_carry__0_i_8_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry__0_i_1
       (.I0(dy12),
        .I1(\y_reg[9]_0 [7]),
        .O(dy10_carry__0_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry__0_i_2
       (.I0(dy12),
        .I1(\y_reg[9]_0 [6]),
        .O(dy10_carry__0_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry__0_i_3
       (.I0(dy12),
        .I1(\y_reg[9]_0 [5]),
        .O(dy10_carry__0_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry__0_i_4
       (.I0(dy12),
        .I1(\y_reg[9]_0 [4]),
        .O(dy10_carry__0_i_4_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry__0_i_5
       (.I0(\y_reg[9]_0 [7]),
        .I1(Q[20]),
        .O(dy10_carry__0_i_5_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry__0_i_6
       (.I0(\y_reg[9]_0 [6]),
        .I1(Q[19]),
        .O(dy10_carry__0_i_6_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry__0_i_7
       (.I0(\y_reg[9]_0 [5]),
        .I1(Q[18]),
        .O(dy10_carry__0_i_7_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry__0_i_8
       (.I0(\y_reg[9]_0 [4]),
        .I1(Q[17]),
        .O(dy10_carry__0_i_8_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 dy10_carry__1
       (.CI(dy10_carry__0_n_0),
        .CO({NLW_dy10_carry__1_CO_UNCONNECTED[3:1],dy10_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,dy10_carry__1_i_1_n_0}),
        .O({NLW_dy10_carry__1_O_UNCONNECTED[3:2],dy10[9:8]}),
        .S({1'b0,1'b0,\dy1_reg[9]_0 ,dy10_carry__1_i_3_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry__1_i_1
       (.I0(dy12),
        .I1(\y_reg[9]_0 [8]),
        .O(dy10_carry__1_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry__1_i_3
       (.I0(\y_reg[9]_0 [8]),
        .I1(Q[21]),
        .O(dy10_carry__1_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry_i_1
       (.I0(dy12),
        .I1(\y_reg[9]_0 [3]),
        .O(dy10_carry_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry_i_2
       (.I0(dy12),
        .I1(\y_reg[9]_0 [2]),
        .O(dy10_carry_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry_i_3
       (.I0(dy12),
        .I1(\y_reg[9]_0 [1]),
        .O(dy10_carry_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry_i_4
       (.I0(dy12),
        .I1(\y_reg[9]_0 [0]),
        .O(dy10_carry_i_4_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry_i_5
       (.I0(\y_reg[9]_0 [3]),
        .I1(Q[16]),
        .O(dy10_carry_i_5_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry_i_6
       (.I0(\y_reg[9]_0 [2]),
        .I1(Q[15]),
        .O(dy10_carry_i_6_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry_i_7
       (.I0(\y_reg[9]_0 [1]),
        .I1(Q[14]),
        .O(dy10_carry_i_7_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dy10_carry_i_8
       (.I0(\y_reg[9]_0 [0]),
        .I1(Q[13]),
        .O(dy10_carry_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 dy12_carry
       (.CI(1'b0),
        .CO({dy12_carry_n_0,dy12_carry_n_1,dy12_carry_n_2,dy12_carry_n_3}),
        .CYINIT(1'b1),
        .DI({dy12_carry_i_1_n_0,dy12_carry_i_2_n_0,dy12_carry_i_3_n_0,dy12_carry_i_4_n_0}),
        .O(NLW_dy12_carry_O_UNCONNECTED[3:0]),
        .S(S));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 dy12_carry__0
       (.CI(dy12_carry_n_0),
        .CO({NLW_dy12_carry__0_CO_UNCONNECTED[3:1],dy12}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,dy12_carry__0_i_1_n_0}),
        .O(NLW_dy12_carry__0_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,1'b0,dy10_carry__1_i_1_0}));
  LUT4 #(
    .INIT(16'h2B22)) 
    dy12_carry__0_i_1
       (.I0(\y_reg[9]_0 [9]),
        .I1(Q[22]),
        .I2(Q[21]),
        .I3(\y_reg[9]_0 [8]),
        .O(dy12_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    dy12_carry_i_1
       (.I0(\y_reg[9]_0 [7]),
        .I1(Q[20]),
        .I2(\y_reg[9]_0 [6]),
        .I3(Q[19]),
        .O(dy12_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    dy12_carry_i_2
       (.I0(\y_reg[9]_0 [5]),
        .I1(Q[18]),
        .I2(\y_reg[9]_0 [4]),
        .I3(Q[17]),
        .O(dy12_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    dy12_carry_i_3
       (.I0(\y_reg[9]_0 [3]),
        .I1(Q[16]),
        .I2(\y_reg[9]_0 [2]),
        .I3(Q[15]),
        .O(dy12_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    dy12_carry_i_4
       (.I0(\y_reg[9]_0 [1]),
        .I1(Q[14]),
        .I2(\y_reg[9]_0 [0]),
        .I3(Q[13]),
        .O(dy12_carry_i_4_n_0));
  FDRE \dy1_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(dy10[0]),
        .Q(ay[0]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dy1_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(dy10[1]),
        .Q(ay[1]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dy1_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(dy10[2]),
        .Q(ay[2]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dy1_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(dy10[3]),
        .Q(ay[3]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dy1_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .D(dy10[4]),
        .Q(ay[4]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dy1_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .D(dy10[5]),
        .Q(ay[5]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dy1_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .D(dy10[6]),
        .Q(ay[6]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dy1_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .D(dy10[7]),
        .Q(ay[7]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dy1_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .D(dy10[8]),
        .Q(ay[8]),
        .R(\paint2_reg[23]_0 ));
  FDRE \dy1_reg[9] 
       (.C(pclk),
        .CE(1'b1),
        .D(dy10[9]),
        .Q(ay[9]),
        .R(\paint2_reg[23]_0 ));
  FDRE enable1_reg
       (.C(pclk),
        .CE(1'b1),
        .D(Q[0]),
        .Q(enable1),
        .R(\paint2_reg[23]_0 ));
  FDRE fist1_reg
       (.C(pclk),
        .CE(1'b1),
        .D(Q[1]),
        .Q(fist1),
        .R(\paint2_reg[23]_0 ));
  LUT6 #(
    .INIT(64'hFFFEDCD54931C3FE)) 
    g0_b0
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .I5(ay[5]),
        .O(g0_b0_n_0));
  LUT6 #(
    .INIT(64'hFFFFFAFB52CCE3FE)) 
    g0_b0__0
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .I5(ay[5]),
        .O(g0_b0__0_n_0));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT5 #(
    .INIT(32'hFA6AD8FE)) 
    g0_b0__1
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .O(g0_b0__1_n_0));
  LUT6 #(
    .INIT(64'hFFFE15B338F03FFE)) 
    g0_b1
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .I5(ay[5]),
        .O(g0_b1_n_0));
  LUT6 #(
    .INIT(64'hFFFFF8A931C3E001)) 
    g0_b1__0
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .I5(ay[5]),
        .O(g0_b1__0_n_0));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'hFB263801)) 
    g0_b1__1
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .O(g0_b1__1_n_0));
  LUT6 #(
    .INIT(64'hFFFE4C70F80FFFFE)) 
    g0_b2
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .I5(ay[5]),
        .O(g0_b2_n_0));
  LUT6 #(
    .INIT(64'hFFFFF998F03FE000)) 
    g0_b2__0
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .I5(ay[5]),
        .O(g0_b2__0_n_0));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'hFAE1F800)) 
    g0_b2__1
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .O(g0_b2__1_n_0));
  LUT6 #(
    .INIT(64'hFFFEC3F007FFFFFE)) 
    g0_b3
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .I5(ay[5]),
        .O(g0_b3_n_0));
  LUT6 #(
    .INIT(64'hFFFFFB87F0001FFF)) 
    g0_b3__0
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .I5(ay[5]),
        .O(g0_b3__0_n_0));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'hF9E007FF)) 
    g0_b3__1
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .O(g0_b3__1_n_0));
  LUT6 #(
    .INIT(64'hFFFE3FF000000001)) 
    g0_b4
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .I5(ay[5]),
        .O(g0_b4_n_0));
  LUT6 #(
    .INIT(64'hFFFFF87FF0000000)) 
    g0_b4__0
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .I5(ay[5]),
        .O(g0_b4__0_n_0));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'hF81FFFFF)) 
    g0_b4__1
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .O(g0_b4__1_n_0));
  LUT6 #(
    .INIT(64'hFFFE000FFFFFFFFF)) 
    g0_b5
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .I5(ay[5]),
        .O(g0_b5_n_0));
  LUT6 #(
    .INIT(64'hFFFFF8000FFFFFFF)) 
    g0_b5__0
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .I5(ay[5]),
        .O(g0_b5__0_n_0));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'hF8000000)) 
    g0_b5__1
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .O(g0_b5__1_n_0));
  LUT6 #(
    .INIT(64'hFFFE000000000000)) 
    g0_b6
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .I5(ay[5]),
        .O(g0_b6_n_0));
  LUT6 #(
    .INIT(64'hFFFFF80000000000)) 
    g0_b6__0
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[2]),
        .I3(ay[3]),
        .I4(ay[4]),
        .I5(ay[5]),
        .O(g0_b6__0_n_0));
  FDRE hand1_reg
       (.C(pclk),
        .CE(1'b1),
        .D(hand10),
        .Q(hand1),
        .R(\paint2_reg[23]_0 ));
  (* COMPARATOR_THRESHOLD = "11" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 hit23_carry
       (.CI(1'b0),
        .CO({hit23_carry_n_0,hit23_carry_n_1,hit23_carry_n_2,hit23_carry_n_3}),
        .CYINIT(1'b0),
        .DI({hit23_carry_i_1__0_n_0,hit23_carry_i_2__0_n_0,hit23_carry_i_3_n_0,hit23_carry_i_4__0_n_0}),
        .O(NLW_hit23_carry_O_UNCONNECTED[3:0]),
        .S({hit23_carry_i_5_n_0,hit23_carry_i_6_n_0,hit23_carry_i_7_n_0,hit23_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 hit23_carry__0
       (.CI(hit23_carry_n_0),
        .CO({NLW_hit23_carry__0_CO_UNCONNECTED[3:2],hit23,hit23_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,hit23_carry_i_1_n_0,hit23_carry_i_2_n_0}),
        .O(NLW_hit23_carry__0_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,hit23_carry_i_3__0_n_0,hit23_carry_i_4_n_0}));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFEFE0)) 
    hit23_carry_i_1
       (.I0(g0_b5__1_n_0),
        .I1(ay[5]),
        .I2(fist1),
        .I3(g0_b6__0_n_0),
        .I4(hit23_carry_i_5__0_n_0),
        .I5(p_0_in_0[10]),
        .O(hit23_carry_i_1_n_0));
  LUT5 #(
    .INIT(32'hFFFFEFE0)) 
    hit23_carry_i_10
       (.I0(g0_b5__1_n_0),
        .I1(ay[5]),
        .I2(fist1),
        .I3(g0_b5__0_n_0),
        .I4(hit23_carry_i_5__0_n_0),
        .O(hit23_carry_i_10_n_0));
  LUT5 #(
    .INIT(32'hFFFFEFE0)) 
    hit23_carry_i_11
       (.I0(g0_b4__1_n_0),
        .I1(ay[5]),
        .I2(fist1),
        .I3(g0_b4__0_n_0),
        .I4(hit23_carry_i_5__0_n_0),
        .O(hit23_carry_i_11_n_0));
  LUT5 #(
    .INIT(32'hFFFFEFE0)) 
    hit23_carry_i_12
       (.I0(g0_b3__1_n_0),
        .I1(ay[5]),
        .I2(fist1),
        .I3(g0_b3__0_n_0),
        .I4(hit23_carry_i_5__0_n_0),
        .O(hit23_carry_i_12_n_0));
  LUT5 #(
    .INIT(32'hFFFFEFE0)) 
    hit23_carry_i_13
       (.I0(g0_b2__1_n_0),
        .I1(ay[5]),
        .I2(fist1),
        .I3(g0_b2__0_n_0),
        .I4(hit23_carry_i_5__0_n_0),
        .O(hit23_carry_i_13_n_0));
  LUT5 #(
    .INIT(32'hFFFFEFE0)) 
    hit23_carry_i_14
       (.I0(g0_b1__1_n_0),
        .I1(ay[5]),
        .I2(fist1),
        .I3(g0_b1__0_n_0),
        .I4(hit23_carry_i_5__0_n_0),
        .O(hit23_carry_i_14_n_0));
  LUT5 #(
    .INIT(32'hFFFFEFE0)) 
    hit23_carry_i_15
       (.I0(g0_b0__1_n_0),
        .I1(ay[5]),
        .I2(fist1),
        .I3(g0_b0__0_n_0),
        .I4(hit23_carry_i_5__0_n_0),
        .O(hit23_carry_i_15_n_0));
  LUT6 #(
    .INIT(64'hAAA9AAA9AAA999A9)) 
    hit23_carry_i_16
       (.I0(p_0_in_0[5]),
        .I1(hit23_carry_i_5__0_n_0),
        .I2(g0_b5__0_n_0),
        .I3(fist1),
        .I4(ay[5]),
        .I5(g0_b5__1_n_0),
        .O(hit23_carry_i_16_n_0));
  LUT6 #(
    .INIT(64'hAAA9AAA9AAA999A9)) 
    hit23_carry_i_17
       (.I0(p_0_in_0[3]),
        .I1(hit23_carry_i_5__0_n_0),
        .I2(g0_b3__0_n_0),
        .I3(fist1),
        .I4(ay[5]),
        .I5(g0_b3__1_n_0),
        .O(hit23_carry_i_17_n_0));
  LUT6 #(
    .INIT(64'hAAA9AAA9AAA999A9)) 
    hit23_carry_i_18
       (.I0(p_0_in_0[1]),
        .I1(hit23_carry_i_5__0_n_0),
        .I2(g0_b1__0_n_0),
        .I3(fist1),
        .I4(ay[5]),
        .I5(g0_b1__1_n_0),
        .O(hit23_carry_i_18_n_0));
  LUT3 #(
    .INIT(8'h0E)) 
    hit23_carry_i_1__0
       (.I0(p_0_in_0[7]),
        .I1(p_0_in_0[6]),
        .I2(hit23_carry_i_9_n_0),
        .O(hit23_carry_i_1__0_n_0));
  LUT3 #(
    .INIT(8'h0E)) 
    hit23_carry_i_2
       (.I0(p_0_in_0[9]),
        .I1(p_0_in_0[8]),
        .I2(hit23_carry_i_9_n_0),
        .O(hit23_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    hit23_carry_i_2__0
       (.I0(p_0_in_0[5]),
        .I1(hit23_carry_i_10_n_0),
        .I2(p_0_in_0[4]),
        .I3(hit23_carry_i_11_n_0),
        .O(hit23_carry_i_2__0_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    hit23_carry_i_3
       (.I0(p_0_in_0[3]),
        .I1(hit23_carry_i_12_n_0),
        .I2(p_0_in_0[2]),
        .I3(hit23_carry_i_13_n_0),
        .O(hit23_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h0001000100011101)) 
    hit23_carry_i_3__0
       (.I0(p_0_in_0[10]),
        .I1(hit23_carry_i_5__0_n_0),
        .I2(g0_b6__0_n_0),
        .I3(fist1),
        .I4(ay[5]),
        .I5(g0_b5__1_n_0),
        .O(hit23_carry_i_3__0_n_0));
  LUT3 #(
    .INIT(8'h81)) 
    hit23_carry_i_4
       (.I0(hit23_carry_i_9_n_0),
        .I1(p_0_in_0[9]),
        .I2(p_0_in_0[8]),
        .O(hit23_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    hit23_carry_i_4__0
       (.I0(p_0_in_0[1]),
        .I1(hit23_carry_i_14_n_0),
        .I2(p_0_in_0[0]),
        .I3(hit23_carry_i_15_n_0),
        .O(hit23_carry_i_4__0_n_0));
  LUT3 #(
    .INIT(8'h81)) 
    hit23_carry_i_5
       (.I0(hit23_carry_i_9_n_0),
        .I1(p_0_in_0[6]),
        .I2(p_0_in_0[7]),
        .O(hit23_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    hit23_carry_i_5__0
       (.I0(ay[8]),
        .I1(ay[9]),
        .I2(ay[6]),
        .I3(ay[7]),
        .O(hit23_carry_i_5__0_n_0));
  LUT3 #(
    .INIT(8'h82)) 
    hit23_carry_i_6
       (.I0(hit23_carry_i_16_n_0),
        .I1(hit23_carry_i_11_n_0),
        .I2(p_0_in_0[4]),
        .O(hit23_carry_i_6_n_0));
  LUT3 #(
    .INIT(8'h82)) 
    hit23_carry_i_7
       (.I0(hit23_carry_i_17_n_0),
        .I1(hit23_carry_i_13_n_0),
        .I2(p_0_in_0[2]),
        .O(hit23_carry_i_7_n_0));
  LUT3 #(
    .INIT(8'h82)) 
    hit23_carry_i_8
       (.I0(hit23_carry_i_18_n_0),
        .I1(hit23_carry_i_15_n_0),
        .I2(p_0_in_0[0]),
        .O(hit23_carry_i_8_n_0));
  LUT5 #(
    .INIT(32'hFFFFEFE0)) 
    hit23_carry_i_9
       (.I0(g0_b5__1_n_0),
        .I1(ay[5]),
        .I2(fist1),
        .I3(g0_b6__0_n_0),
        .I4(hit23_carry_i_5__0_n_0),
        .O(hit23_carry_i_9_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 hit24_carry
       (.CI(1'b0),
        .CO({hit24_carry_n_0,hit24_carry_n_1,hit24_carry_n_2,hit24_carry_n_3}),
        .CYINIT(1'b1),
        .DI({hit24_carry_i_1_n_0,hit24_carry_i_2_n_0,hit24_carry_i_3_n_0,hit24_carry_i_4_n_0}),
        .O(NLW_hit24_carry_O_UNCONNECTED[3:0]),
        .S({hit24_carry_i_5_n_0,hit24_carry_i_6_n_0,hit24_carry_i_7_n_0,hit24_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-8 {cell *THIS*}}" *) 
  CARRY4 hit24_carry__0
       (.CI(hit24_carry_n_0),
        .CO({NLW_hit24_carry__0_CO_UNCONNECTED[3:2],hit24,hit24_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,hit24_carry__0_i_1_n_0}),
        .O(NLW_hit24_carry__0_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,hit24_carry__0_i_2_n_0,hit24_carry__0_i_3_n_0}));
  LUT3 #(
    .INIT(8'h2A)) 
    hit24_carry__0_i_1
       (.I0(hit24_carry_i_9_n_0),
        .I1(p_0_in_0[9]),
        .I2(p_0_in_0[8]),
        .O(hit24_carry__0_i_1_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    hit24_carry__0_i_2
       (.I0(p_0_in_0[10]),
        .I1(hit24_carry_i_9_n_0),
        .O(hit24_carry__0_i_2_n_0));
  LUT3 #(
    .INIT(8'h81)) 
    hit24_carry__0_i_3
       (.I0(hit24_carry_i_9_n_0),
        .I1(p_0_in_0[9]),
        .I2(p_0_in_0[8]),
        .O(hit24_carry__0_i_3_n_0));
  LUT3 #(
    .INIT(8'h2A)) 
    hit24_carry_i_1
       (.I0(hit24_carry_i_9_n_0),
        .I1(p_0_in_0[7]),
        .I2(p_0_in_0[6]),
        .O(hit24_carry_i_1_n_0));
  LUT5 #(
    .INIT(32'h0000909F)) 
    hit24_carry_i_10
       (.I0(hit24_carry_i_18_n_0),
        .I1(ay[5]),
        .I2(fist1),
        .I3(g0_b5_n_0),
        .I4(hit23_carry_i_5__0_n_0),
        .O(hit24_carry_i_10_n_0));
  LUT6 #(
    .INIT(64'h00000000F2F200F2)) 
    hit24_carry_i_11
       (.I0(hit24_carry_i_19_n_0),
        .I1(hit24_carry_i_20_n_0),
        .I2(hit24_carry_i_17_n_0),
        .I3(g0_b4_n_0),
        .I4(fist1),
        .I5(hit23_carry_i_5__0_n_0),
        .O(hit24_carry_i_11_n_0));
  LUT4 #(
    .INIT(16'h00A3)) 
    hit24_carry_i_12
       (.I0(hit24_carry_i_21_n_0),
        .I1(g0_b2_n_0),
        .I2(fist1),
        .I3(hit23_carry_i_5__0_n_0),
        .O(hit24_carry_i_12_n_0));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT4 #(
    .INIT(16'h00A3)) 
    hit24_carry_i_13
       (.I0(hit24_carry_i_22_n_0),
        .I1(g0_b3_n_0),
        .I2(fist1),
        .I3(hit23_carry_i_5__0_n_0),
        .O(hit24_carry_i_13_n_0));
  LUT4 #(
    .INIT(16'hAEFE)) 
    hit24_carry_i_14
       (.I0(hit23_carry_i_5__0_n_0),
        .I1(g0_b1_n_0),
        .I2(fist1),
        .I3(hit24_carry_i_23_n_0),
        .O(hit24_carry_i_14_n_0));
  LUT5 #(
    .INIT(32'h0000EE0E)) 
    hit24_carry_i_15
       (.I0(hit24_carry_i_24_n_0),
        .I1(hit24_carry_i_25_n_0),
        .I2(g0_b0_n_0),
        .I3(fist1),
        .I4(hit23_carry_i_5__0_n_0),
        .O(hit24_carry_i_15_n_0));
  LUT6 #(
    .INIT(64'h99A9AAA9AAA999A9)) 
    hit24_carry_i_16
       (.I0(p_0_in_0[5]),
        .I1(hit23_carry_i_5__0_n_0),
        .I2(g0_b5_n_0),
        .I3(fist1),
        .I4(ay[5]),
        .I5(hit24_carry_i_18_n_0),
        .O(hit24_carry_i_16_n_0));
  LUT6 #(
    .INIT(64'h00000001FFFFFFFF)) 
    hit24_carry_i_17
       (.I0(ay[4]),
        .I1(ay[2]),
        .I2(ay[3]),
        .I3(ay[1]),
        .I4(ay[0]),
        .I5(fist1),
        .O(hit24_carry_i_17_n_0));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    hit24_carry_i_18
       (.I0(ay[0]),
        .I1(ay[1]),
        .I2(ay[3]),
        .I3(ay[2]),
        .I4(ay[4]),
        .O(hit24_carry_i_18_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    hit24_carry_i_19
       (.I0(ay[4]),
        .I1(ay[5]),
        .O(hit24_carry_i_19_n_0));
  LUT4 #(
    .INIT(16'h1117)) 
    hit24_carry_i_2
       (.I0(p_0_in_0[5]),
        .I1(hit24_carry_i_10_n_0),
        .I2(p_0_in_0[4]),
        .I3(hit24_carry_i_11_n_0),
        .O(hit24_carry_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT2 #(
    .INIT(4'h7)) 
    hit24_carry_i_20
       (.I0(ay[3]),
        .I1(ay[2]),
        .O(hit24_carry_i_20_n_0));
  LUT6 #(
    .INIT(64'h0004400444444047)) 
    hit24_carry_i_21
       (.I0(ay[5]),
        .I1(ay[4]),
        .I2(ay[1]),
        .I3(ay[3]),
        .I4(ay[0]),
        .I5(ay[2]),
        .O(hit24_carry_i_21_n_0));
  LUT6 #(
    .INIT(64'h4050500000500003)) 
    hit24_carry_i_22
       (.I0(ay[5]),
        .I1(ay[0]),
        .I2(ay[4]),
        .I3(ay[2]),
        .I4(ay[3]),
        .I5(ay[1]),
        .O(hit24_carry_i_22_n_0));
  LUT6 #(
    .INIT(64'h1120222000201225)) 
    hit24_carry_i_23
       (.I0(ay[2]),
        .I1(ay[5]),
        .I2(ay[3]),
        .I3(ay[4]),
        .I4(ay[1]),
        .I5(ay[0]),
        .O(hit24_carry_i_23_n_0));
  LUT6 #(
    .INIT(64'h00000D00FFFFFFFF)) 
    hit24_carry_i_24
       (.I0(ay[2]),
        .I1(ay[1]),
        .I2(ay[4]),
        .I3(ay[3]),
        .I4(ay[5]),
        .I5(fist1),
        .O(hit24_carry_i_24_n_0));
  LUT6 #(
    .INIT(64'h0100000009000A11)) 
    hit24_carry_i_25
       (.I0(ay[2]),
        .I1(ay[0]),
        .I2(ay[5]),
        .I3(ay[4]),
        .I4(ay[1]),
        .I5(ay[3]),
        .O(hit24_carry_i_25_n_0));
  LUT4 #(
    .INIT(16'h011F)) 
    hit24_carry_i_3
       (.I0(p_0_in_0[2]),
        .I1(hit24_carry_i_12_n_0),
        .I2(p_0_in_0[3]),
        .I3(hit24_carry_i_13_n_0),
        .O(hit24_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h444D)) 
    hit24_carry_i_4
       (.I0(p_0_in_0[1]),
        .I1(hit24_carry_i_14_n_0),
        .I2(p_0_in_0[0]),
        .I3(hit24_carry_i_15_n_0),
        .O(hit24_carry_i_4_n_0));
  LUT3 #(
    .INIT(8'h81)) 
    hit24_carry_i_5
       (.I0(hit24_carry_i_9_n_0),
        .I1(p_0_in_0[6]),
        .I2(p_0_in_0[7]),
        .O(hit24_carry_i_5_n_0));
  LUT3 #(
    .INIT(8'h28)) 
    hit24_carry_i_6
       (.I0(hit24_carry_i_16_n_0),
        .I1(hit24_carry_i_11_n_0),
        .I2(p_0_in_0[4]),
        .O(hit24_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h0660)) 
    hit24_carry_i_7
       (.I0(p_0_in_0[3]),
        .I1(hit24_carry_i_13_n_0),
        .I2(hit24_carry_i_12_n_0),
        .I3(p_0_in_0[2]),
        .O(hit24_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h0990)) 
    hit24_carry_i_8
       (.I0(p_0_in_0[1]),
        .I1(hit24_carry_i_14_n_0),
        .I2(hit24_carry_i_15_n_0),
        .I3(p_0_in_0[0]),
        .O(hit24_carry_i_8_n_0));
  LUT5 #(
    .INIT(32'hFFFF44F4)) 
    hit24_carry_i_9
       (.I0(hit24_carry_i_17_n_0),
        .I1(ay[5]),
        .I2(g0_b6_n_0),
        .I3(fist1),
        .I4(hit23_carry_i_5__0_n_0),
        .O(hit24_carry_i_9_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    hit2_i_1
       (.I0(\paint2[23]_i_2_n_0 ),
        .O(hit2_i_1_n_0));
  FDRE hit2_reg
       (.C(pclk),
        .CE(1'b1),
        .D(hit2_i_1_n_0),
        .Q(hit2),
        .R(\paint2_reg[23]_0 ));
  FDRE hs1_reg
       (.C(pclk),
        .CE(1'b1),
        .D(in_hs),
        .Q(hs1),
        .R(\paint2_reg[23]_0 ));
  FDRE hs2_reg
       (.C(pclk),
        .CE(1'b1),
        .D(hs1),
        .Q(hs2),
        .R(\paint2_reg[23]_0 ));
  FDRE out_de_reg
       (.C(pclk),
        .CE(1'b1),
        .D(de2),
        .Q(out_de),
        .R(\paint2_reg[23]_0 ));
  FDRE out_hs_reg
       (.C(pclk),
        .CE(1'b1),
        .D(hs2),
        .Q(out_hs),
        .R(\paint2_reg[23]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[0]_i_1 
       (.I0(\paint2_reg_n_0_[7] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[0]),
        .O(\out_rgb[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'h70)) 
    \out_rgb[10]_i_1 
       (.I0(hit2),
        .I1(de2),
        .I2(rgb2[10]),
        .O(\out_rgb[10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'h70)) 
    \out_rgb[11]_i_1 
       (.I0(hit2),
        .I1(de2),
        .I2(rgb2[11]),
        .O(\out_rgb[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT3 #(
    .INIT(8'h70)) 
    \out_rgb[12]_i_1 
       (.I0(hit2),
        .I1(de2),
        .I2(rgb2[12]),
        .O(\out_rgb[12]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT3 #(
    .INIT(8'h70)) 
    \out_rgb[13]_i_1 
       (.I0(hit2),
        .I1(de2),
        .I2(rgb2[13]),
        .O(\out_rgb[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT3 #(
    .INIT(8'h70)) 
    \out_rgb[14]_i_1 
       (.I0(hit2),
        .I1(de2),
        .I2(rgb2[14]),
        .O(\out_rgb[14]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT3 #(
    .INIT(8'h70)) 
    \out_rgb[15]_i_1 
       (.I0(hit2),
        .I1(de2),
        .I2(rgb2[15]),
        .O(\out_rgb[15]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[16]_i_1 
       (.I0(\paint2_reg_n_0_[23] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[16]),
        .O(\out_rgb[16]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[17]_i_1 
       (.I0(\paint2_reg_n_0_[23] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[17]),
        .O(\out_rgb[17]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[18]_i_1 
       (.I0(\paint2_reg_n_0_[23] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[18]),
        .O(\out_rgb[18]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[19]_i_1 
       (.I0(\paint2_reg_n_0_[23] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[19]),
        .O(\out_rgb[19]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[1]_i_1 
       (.I0(\paint2_reg_n_0_[7] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[1]),
        .O(\out_rgb[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[20]_i_1 
       (.I0(\paint2_reg_n_0_[23] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[20]),
        .O(\out_rgb[20]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[21]_i_1 
       (.I0(\paint2_reg_n_0_[23] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[21]),
        .O(\out_rgb[21]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[22]_i_1 
       (.I0(\paint2_reg_n_0_[23] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[22]),
        .O(\out_rgb[22]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[23]_i_2 
       (.I0(\paint2_reg_n_0_[23] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[23]),
        .O(\out_rgb[23]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[2]_i_1 
       (.I0(\paint2_reg_n_0_[7] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[2]),
        .O(\out_rgb[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[3]_i_1 
       (.I0(\paint2_reg_n_0_[7] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[3]),
        .O(\out_rgb[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[4]_i_1 
       (.I0(\paint2_reg_n_0_[7] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[4]),
        .O(\out_rgb[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[5]_i_1 
       (.I0(\paint2_reg_n_0_[7] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[5]),
        .O(\out_rgb[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[6]_i_1 
       (.I0(\paint2_reg_n_0_[7] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[6]),
        .O(\out_rgb[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \out_rgb[7]_i_1 
       (.I0(\paint2_reg_n_0_[7] ),
        .I1(hit2),
        .I2(de2),
        .I3(rgb2[7]),
        .O(\out_rgb[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'h70)) 
    \out_rgb[8]_i_1 
       (.I0(hit2),
        .I1(de2),
        .I2(rgb2[8]),
        .O(\out_rgb[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'h70)) 
    \out_rgb[9]_i_1 
       (.I0(hit2),
        .I1(de2),
        .I2(rgb2[9]),
        .O(\out_rgb[9]_i_1_n_0 ));
  FDRE \out_rgb_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[0]_i_1_n_0 ),
        .Q(out_rgb[0]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[10] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[10]_i_1_n_0 ),
        .Q(out_rgb[10]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[11] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[11]_i_1_n_0 ),
        .Q(out_rgb[11]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[12] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[12]_i_1_n_0 ),
        .Q(out_rgb[12]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[13] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[13]_i_1_n_0 ),
        .Q(out_rgb[13]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[14] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[14]_i_1_n_0 ),
        .Q(out_rgb[14]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[15] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[15]_i_1_n_0 ),
        .Q(out_rgb[15]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[16] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[16]_i_1_n_0 ),
        .Q(out_rgb[16]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[17] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[17]_i_1_n_0 ),
        .Q(out_rgb[17]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[18] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[18]_i_1_n_0 ),
        .Q(out_rgb[18]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[19] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[19]_i_1_n_0 ),
        .Q(out_rgb[19]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[1]_i_1_n_0 ),
        .Q(out_rgb[1]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[20] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[20]_i_1_n_0 ),
        .Q(out_rgb[20]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[21] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[21]_i_1_n_0 ),
        .Q(out_rgb[21]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[22] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[22]_i_1_n_0 ),
        .Q(out_rgb[22]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[23] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[23]_i_2_n_0 ),
        .Q(out_rgb[23]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[2]_i_1_n_0 ),
        .Q(out_rgb[2]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[3]_i_1_n_0 ),
        .Q(out_rgb[3]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[4]_i_1_n_0 ),
        .Q(out_rgb[4]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[5]_i_1_n_0 ),
        .Q(out_rgb[5]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[6]_i_1_n_0 ),
        .Q(out_rgb[6]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[7]_i_1_n_0 ),
        .Q(out_rgb[7]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[8]_i_1_n_0 ),
        .Q(out_rgb[8]),
        .R(\paint2_reg[23]_0 ));
  FDRE \out_rgb_reg[9] 
       (.C(pclk),
        .CE(1'b1),
        .D(\out_rgb[9]_i_1_n_0 ),
        .Q(out_rgb[9]),
        .R(\paint2_reg[23]_0 ));
  FDRE out_vs_reg
       (.C(pclk),
        .CE(1'b1),
        .D(vs2),
        .Q(out_vs),
        .R(\paint2_reg[23]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \paint2[23]_i_1 
       (.I0(fist1),
        .I1(\paint2[23]_i_2_n_0 ),
        .O(paint2));
  LUT6 #(
    .INIT(64'hFFFFFFFFD0DDDDDD)) 
    \paint2[23]_i_2 
       (.I0(\paint2[23]_i_3_n_0 ),
        .I1(\paint2[23]_i_4_n_0 ),
        .I2(hit24_carry_i_9_n_0),
        .I3(hit23),
        .I4(hit24),
        .I5(\paint2[23]_i_5_n_0 ),
        .O(\paint2[23]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000010)) 
    \paint2[23]_i_3 
       (.I0(p_0_in_0[5]),
        .I1(p_0_in_0[10]),
        .I2(\paint2[23]_i_6_n_0 ),
        .I3(p_0_in_0[4]),
        .I4(ay[3]),
        .I5(\paint2[23]_i_7_n_0 ),
        .O(\paint2[23]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFEEEA)) 
    \paint2[23]_i_4 
       (.I0(\paint2[23]_i_8_n_0 ),
        .I1(ay[2]),
        .I2(ay[0]),
        .I3(ay[1]),
        .I4(hit23_carry_i_5__0_n_0),
        .O(\paint2[23]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'h7F)) 
    \paint2[23]_i_5 
       (.I0(de_prev),
        .I1(hand1),
        .I2(enable1),
        .O(\paint2[23]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h1)) 
    \paint2[23]_i_6 
       (.I0(p_0_in_0[6]),
        .I1(p_0_in_0[7]),
        .O(\paint2[23]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \paint2[23]_i_7 
       (.I0(p_0_in_0[8]),
        .I1(p_0_in_0[9]),
        .O(\paint2[23]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFE0)) 
    \paint2[23]_i_8 
       (.I0(p_0_in_0[0]),
        .I1(p_0_in_0[1]),
        .I2(p_0_in_0[2]),
        .I3(p_0_in_0[3]),
        .I4(ay[5]),
        .I5(ay[4]),
        .O(\paint2[23]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h0008)) 
    \paint2[7]_i_1 
       (.I0(out),
        .I1(\paint2_reg[7]_0 ),
        .I2(\paint2[23]_i_2_n_0 ),
        .I3(fist1),
        .O(\paint2[7]_i_1_n_0 ));
  FDRE \paint2_reg[23] 
       (.C(pclk),
        .CE(1'b1),
        .D(paint2),
        .Q(\paint2_reg_n_0_[23] ),
        .R(\paint2_reg[23]_0 ));
  FDRE \paint2_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .D(\paint2[7]_i_1_n_0 ),
        .Q(\paint2_reg_n_0_[7] ),
        .R(1'b0));
  FDRE \rgb1_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[0]),
        .Q(rgb1[0]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[10] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[10]),
        .Q(rgb1[10]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[11] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[11]),
        .Q(rgb1[11]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[12] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[12]),
        .Q(rgb1[12]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[13] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[13]),
        .Q(rgb1[13]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[14] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[14]),
        .Q(rgb1[14]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[15] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[15]),
        .Q(rgb1[15]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[16] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[16]),
        .Q(rgb1[16]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[17] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[17]),
        .Q(rgb1[17]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[18] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[18]),
        .Q(rgb1[18]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[19] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[19]),
        .Q(rgb1[19]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[1]),
        .Q(rgb1[1]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[20] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[20]),
        .Q(rgb1[20]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[21] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[21]),
        .Q(rgb1[21]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[22] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[22]),
        .Q(rgb1[22]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[23] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[23]),
        .Q(rgb1[23]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[2]),
        .Q(rgb1[2]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[3]),
        .Q(rgb1[3]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[4]),
        .Q(rgb1[4]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[5]),
        .Q(rgb1[5]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[6]),
        .Q(rgb1[6]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[7]),
        .Q(rgb1[7]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[8]),
        .Q(rgb1[8]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb1_reg[9] 
       (.C(pclk),
        .CE(1'b1),
        .D(in_rgb[9]),
        .Q(rgb1[9]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[0]),
        .Q(rgb2[0]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[10] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[10]),
        .Q(rgb2[10]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[11] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[11]),
        .Q(rgb2[11]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[12] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[12]),
        .Q(rgb2[12]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[13] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[13]),
        .Q(rgb2[13]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[14] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[14]),
        .Q(rgb2[14]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[15] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[15]),
        .Q(rgb2[15]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[16] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[16]),
        .Q(rgb2[16]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[17] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[17]),
        .Q(rgb2[17]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[18] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[18]),
        .Q(rgb2[18]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[19] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[19]),
        .Q(rgb2[19]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[1]),
        .Q(rgb2[1]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[20] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[20]),
        .Q(rgb2[20]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[21] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[21]),
        .Q(rgb2[21]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[22] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[22]),
        .Q(rgb2[22]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[23] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[23]),
        .Q(rgb2[23]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[2]),
        .Q(rgb2[2]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[3]),
        .Q(rgb2[3]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[4]),
        .Q(rgb2[4]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[5]),
        .Q(rgb2[5]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[6]),
        .Q(rgb2[6]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[7]),
        .Q(rgb2[7]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[8]),
        .Q(rgb2[8]),
        .R(\paint2_reg[23]_0 ));
  FDRE \rgb2_reg[9] 
       (.C(pclk),
        .CE(1'b1),
        .D(rgb1[9]),
        .Q(rgb2[9]),
        .R(\paint2_reg[23]_0 ));
  FDRE vs2_reg
       (.C(pclk),
        .CE(1'b1),
        .D(vs_prev_reg_0),
        .Q(vs2),
        .R(\paint2_reg[23]_0 ));
  FDRE vs_prev_reg
       (.C(pclk),
        .CE(1'b1),
        .D(in_vs),
        .Q(vs_prev_reg_0),
        .R(\paint2_reg[23]_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \x[0]_i_1 
       (.I0(\x_reg[10]_0 [0]),
        .O(\x[0]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h77F7FFFF)) 
    \x[10]_i_1 
       (.I0(out),
        .I1(\paint2_reg[7]_0 ),
        .I2(in_vs),
        .I3(vs_prev_reg_0),
        .I4(in_de),
        .O(\x[10]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h1F)) 
    \x[10]_i_2 
       (.I0(\x_reg[10]_0 [9]),
        .I1(\x_reg[10]_0 [8]),
        .I2(\x_reg[10]_0 [10]),
        .O(\x[10]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA6AAAAAAAAAAA)) 
    \x[10]_i_3 
       (.I0(\x_reg[10]_0 [10]),
        .I1(\x_reg[10]_0 [9]),
        .I2(\x_reg[10]_0 [8]),
        .I3(\x_reg[10]_0 [7]),
        .I4(\x[10]_i_4_n_0 ),
        .I5(\x_reg[10]_0 [6]),
        .O(p_0_in__0[10]));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \x[10]_i_4 
       (.I0(\x_reg[10]_0 [4]),
        .I1(\x_reg[10]_0 [2]),
        .I2(\x_reg[10]_0 [1]),
        .I3(\x_reg[10]_0 [0]),
        .I4(\x_reg[10]_0 [3]),
        .I5(\x_reg[10]_0 [5]),
        .O(\x[10]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \x[1]_i_1 
       (.I0(\x_reg[10]_0 [1]),
        .I1(\x_reg[10]_0 [0]),
        .O(p_0_in__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \x[2]_i_1 
       (.I0(\x_reg[10]_0 [2]),
        .I1(\x_reg[10]_0 [0]),
        .I2(\x_reg[10]_0 [1]),
        .O(\x[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \x[3]_i_1 
       (.I0(\x_reg[10]_0 [3]),
        .I1(\x_reg[10]_0 [2]),
        .I2(\x_reg[10]_0 [1]),
        .I3(\x_reg[10]_0 [0]),
        .O(\x[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \x[4]_i_1 
       (.I0(\x_reg[10]_0 [4]),
        .I1(\x_reg[10]_0 [3]),
        .I2(\x_reg[10]_0 [0]),
        .I3(\x_reg[10]_0 [1]),
        .I4(\x_reg[10]_0 [2]),
        .O(\x[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \x[5]_i_1 
       (.I0(\x_reg[10]_0 [5]),
        .I1(\x_reg[10]_0 [4]),
        .I2(\x_reg[10]_0 [2]),
        .I3(\x_reg[10]_0 [1]),
        .I4(\x_reg[10]_0 [0]),
        .I5(\x_reg[10]_0 [3]),
        .O(\x[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \x[6]_i_1 
       (.I0(\x_reg[10]_0 [6]),
        .I1(\x[10]_i_4_n_0 ),
        .O(\x[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'hA6)) 
    \x[7]_i_1 
       (.I0(\x_reg[10]_0 [7]),
        .I1(\x_reg[10]_0 [6]),
        .I2(\x[10]_i_4_n_0 ),
        .O(\x[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT4 #(
    .INIT(16'hA6AA)) 
    \x[8]_i_1 
       (.I0(\x_reg[10]_0 [8]),
        .I1(\x_reg[10]_0 [7]),
        .I2(\x[10]_i_4_n_0 ),
        .I3(\x_reg[10]_0 [6]),
        .O(\x[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'hA6AAAAAA)) 
    \x[9]_i_1 
       (.I0(\x_reg[10]_0 [9]),
        .I1(\x_reg[10]_0 [6]),
        .I2(\x[10]_i_4_n_0 ),
        .I3(\x_reg[10]_0 [7]),
        .I4(\x_reg[10]_0 [8]),
        .O(p_0_in__0[9]));
  FDRE \x_reg[0] 
       (.C(pclk),
        .CE(\x[10]_i_2_n_0 ),
        .D(\x[0]_i_1_n_0 ),
        .Q(\x_reg[10]_0 [0]),
        .R(\x[10]_i_1_n_0 ));
  FDRE \x_reg[10] 
       (.C(pclk),
        .CE(\x[10]_i_2_n_0 ),
        .D(p_0_in__0[10]),
        .Q(\x_reg[10]_0 [10]),
        .R(\x[10]_i_1_n_0 ));
  FDRE \x_reg[1] 
       (.C(pclk),
        .CE(\x[10]_i_2_n_0 ),
        .D(p_0_in__0[1]),
        .Q(\x_reg[10]_0 [1]),
        .R(\x[10]_i_1_n_0 ));
  FDRE \x_reg[2] 
       (.C(pclk),
        .CE(\x[10]_i_2_n_0 ),
        .D(\x[2]_i_1_n_0 ),
        .Q(\x_reg[10]_0 [2]),
        .R(\x[10]_i_1_n_0 ));
  FDRE \x_reg[3] 
       (.C(pclk),
        .CE(\x[10]_i_2_n_0 ),
        .D(\x[3]_i_1_n_0 ),
        .Q(\x_reg[10]_0 [3]),
        .R(\x[10]_i_1_n_0 ));
  FDRE \x_reg[4] 
       (.C(pclk),
        .CE(\x[10]_i_2_n_0 ),
        .D(\x[4]_i_1_n_0 ),
        .Q(\x_reg[10]_0 [4]),
        .R(\x[10]_i_1_n_0 ));
  FDRE \x_reg[5] 
       (.C(pclk),
        .CE(\x[10]_i_2_n_0 ),
        .D(\x[5]_i_1_n_0 ),
        .Q(\x_reg[10]_0 [5]),
        .R(\x[10]_i_1_n_0 ));
  FDRE \x_reg[6] 
       (.C(pclk),
        .CE(\x[10]_i_2_n_0 ),
        .D(\x[6]_i_1_n_0 ),
        .Q(\x_reg[10]_0 [6]),
        .R(\x[10]_i_1_n_0 ));
  FDRE \x_reg[7] 
       (.C(pclk),
        .CE(\x[10]_i_2_n_0 ),
        .D(\x[7]_i_1_n_0 ),
        .Q(\x_reg[10]_0 [7]),
        .R(\x[10]_i_1_n_0 ));
  FDRE \x_reg[8] 
       (.C(pclk),
        .CE(\x[10]_i_2_n_0 ),
        .D(\x[8]_i_1_n_0 ),
        .Q(\x_reg[10]_0 [8]),
        .R(\x[10]_i_1_n_0 ));
  FDRE \x_reg[9] 
       (.C(pclk),
        .CE(\x[10]_i_2_n_0 ),
        .D(p_0_in__0[9]),
        .Q(\x_reg[10]_0 [9]),
        .R(\x[10]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \y[0]_i_1 
       (.I0(\y_reg[9]_0 [0]),
        .O(\y[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \y[1]_i_1 
       (.I0(\y_reg[9]_0 [1]),
        .I1(\y_reg[9]_0 [0]),
        .O(p_0_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \y[2]_i_1 
       (.I0(\y_reg[9]_0 [2]),
        .I1(\y_reg[9]_0 [0]),
        .I2(\y_reg[9]_0 [1]),
        .O(\y[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \y[3]_i_1 
       (.I0(\y_reg[9]_0 [3]),
        .I1(\y_reg[9]_0 [2]),
        .I2(\y_reg[9]_0 [1]),
        .I3(\y_reg[9]_0 [0]),
        .O(\y[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \y[4]_i_1 
       (.I0(\y_reg[9]_0 [4]),
        .I1(\y_reg[9]_0 [3]),
        .I2(\y_reg[9]_0 [0]),
        .I3(\y_reg[9]_0 [1]),
        .I4(\y_reg[9]_0 [2]),
        .O(\y[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \y[5]_i_1 
       (.I0(\y_reg[9]_0 [5]),
        .I1(\y_reg[9]_0 [4]),
        .I2(\y_reg[9]_0 [2]),
        .I3(\y_reg[9]_0 [1]),
        .I4(\y_reg[9]_0 [0]),
        .I5(\y_reg[9]_0 [3]),
        .O(\y[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \y[6]_i_1 
       (.I0(\y_reg[9]_0 [6]),
        .I1(\y[9]_i_5_n_0 ),
        .O(\y[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'h9A)) 
    \y[7]_i_1 
       (.I0(\y_reg[9]_0 [7]),
        .I1(\y[9]_i_5_n_0 ),
        .I2(\y_reg[9]_0 [6]),
        .O(p_0_in[7]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT4 #(
    .INIT(16'hAA6A)) 
    \y[8]_i_1 
       (.I0(\y_reg[9]_0 [8]),
        .I1(\y_reg[9]_0 [7]),
        .I2(\y_reg[9]_0 [6]),
        .I3(\y[9]_i_5_n_0 ),
        .O(p_0_in[8]));
  LUT4 #(
    .INIT(16'h7F77)) 
    \y[9]_i_1 
       (.I0(out),
        .I1(\paint2_reg[7]_0 ),
        .I2(vs_prev_reg_0),
        .I3(in_vs),
        .O(\y[9]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h08)) 
    \y[9]_i_2 
       (.I0(\y[9]_i_4_n_0 ),
        .I1(de_prev),
        .I2(in_de),
        .O(y));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'hA6AAAAAA)) 
    \y[9]_i_3 
       (.I0(\y_reg[9]_0 [9]),
        .I1(\y_reg[9]_0 [8]),
        .I2(\y[9]_i_5_n_0 ),
        .I3(\y_reg[9]_0 [6]),
        .I4(\y_reg[9]_0 [7]),
        .O(p_0_in[9]));
  LUT6 #(
    .INIT(64'h555555557F7F7FFF)) 
    \y[9]_i_4 
       (.I0(\y_reg[9]_0 [9]),
        .I1(\y_reg[9]_0 [7]),
        .I2(\y_reg[9]_0 [6]),
        .I3(\y_reg[9]_0 [5]),
        .I4(\y_reg[9]_0 [4]),
        .I5(\y_reg[9]_0 [8]),
        .O(\y[9]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \y[9]_i_5 
       (.I0(\y_reg[9]_0 [4]),
        .I1(\y_reg[9]_0 [2]),
        .I2(\y_reg[9]_0 [1]),
        .I3(\y_reg[9]_0 [0]),
        .I4(\y_reg[9]_0 [3]),
        .I5(\y_reg[9]_0 [5]),
        .O(\y[9]_i_5_n_0 ));
  FDRE \y_reg[0] 
       (.C(pclk),
        .CE(y),
        .D(\y[0]_i_1_n_0 ),
        .Q(\y_reg[9]_0 [0]),
        .R(\y[9]_i_1_n_0 ));
  FDRE \y_reg[1] 
       (.C(pclk),
        .CE(y),
        .D(p_0_in[1]),
        .Q(\y_reg[9]_0 [1]),
        .R(\y[9]_i_1_n_0 ));
  FDRE \y_reg[2] 
       (.C(pclk),
        .CE(y),
        .D(\y[2]_i_1_n_0 ),
        .Q(\y_reg[9]_0 [2]),
        .R(\y[9]_i_1_n_0 ));
  FDRE \y_reg[3] 
       (.C(pclk),
        .CE(y),
        .D(\y[3]_i_1_n_0 ),
        .Q(\y_reg[9]_0 [3]),
        .R(\y[9]_i_1_n_0 ));
  FDRE \y_reg[4] 
       (.C(pclk),
        .CE(y),
        .D(\y[4]_i_1_n_0 ),
        .Q(\y_reg[9]_0 [4]),
        .R(\y[9]_i_1_n_0 ));
  FDRE \y_reg[5] 
       (.C(pclk),
        .CE(y),
        .D(\y[5]_i_1_n_0 ),
        .Q(\y_reg[9]_0 [5]),
        .R(\y[9]_i_1_n_0 ));
  FDRE \y_reg[6] 
       (.C(pclk),
        .CE(y),
        .D(\y[6]_i_1_n_0 ),
        .Q(\y_reg[9]_0 [6]),
        .R(\y[9]_i_1_n_0 ));
  FDRE \y_reg[7] 
       (.C(pclk),
        .CE(y),
        .D(p_0_in[7]),
        .Q(\y_reg[9]_0 [7]),
        .R(\y[9]_i_1_n_0 ));
  FDRE \y_reg[8] 
       (.C(pclk),
        .CE(y),
        .D(p_0_in[8]),
        .Q(\y_reg[9]_0 [8]),
        .R(\y[9]_i_1_n_0 ));
  FDRE \y_reg[9] 
       (.C(pclk),
        .CE(y),
        .D(p_0_in[9]),
        .Q(\y_reg[9]_0 [9]),
        .R(\y[9]_i_1_n_0 ));
endmodule

(* ORIG_REF_NAME = "input_osd_top" *) 
module c6v_input_osd_0_0_input_osd_top
   (out,
    ack_toggle_reg,
    vs_prev,
    out_de,
    out_hs,
    out_vs,
    bvalid_reg,
    w_held_reg,
    aw_held,
    pending,
    s_axi_bresp,
    rvalid_reg,
    Q,
    s_axi_rdata,
    s_axi_rresp,
    out_rgb,
    s_axi_awready,
    \aw_addr_reg[5] ,
    mailbox116_out,
    s_axi_wready,
    s_axi_arready,
    \w_data_reg[0] ,
    pclk,
    s_axi_aclk,
    in_de,
    in_vs,
    in_hs,
    bvalid_reg_0,
    pending_reg,
    \bresp_reg[1] ,
    rvalid_reg_0,
    s_axi_araddr,
    s_axi_arvalid,
    s_axi_wvalid,
    s_axi_awvalid,
    s_axi_awaddr,
    s_axi_wdata,
    s_axi_wstrb,
    in_rgb,
    presetn,
    s_axi_aresetn);
  output out;
  output ack_toggle_reg;
  output vs_prev;
  output out_de;
  output out_hs;
  output out_vs;
  output bvalid_reg;
  output w_held_reg;
  output aw_held;
  output pending;
  output [0:0]s_axi_bresp;
  output rvalid_reg;
  output [1:0]Q;
  output [31:0]s_axi_rdata;
  output [0:0]s_axi_rresp;
  output [23:0]out_rgb;
  output s_axi_awready;
  output \aw_addr_reg[5] ;
  output mailbox116_out;
  output s_axi_wready;
  output s_axi_arready;
  output \w_data_reg[0] ;
  input pclk;
  input s_axi_aclk;
  input in_de;
  input in_vs;
  input in_hs;
  input bvalid_reg_0;
  input pending_reg;
  input \bresp_reg[1] ;
  input rvalid_reg_0;
  input [6:0]s_axi_araddr;
  input s_axi_arvalid;
  input s_axi_wvalid;
  input s_axi_awvalid;
  input [6:0]s_axi_awaddr;
  input [31:0]s_axi_wdata;
  input [3:0]s_axi_wstrb;
  input [23:0]in_rgb;
  input presetn;
  input s_axi_aresetn;

  wire [1:0]Q;
  wire ack_toggle_reg;
  wire \aw_addr_reg[5] ;
  wire aw_held;
  wire \bresp_reg[1] ;
  wire bvalid_reg;
  wire bvalid_reg_0;
  (* async_reg = "true" *) wire [1:0]ca_release;
  wire \ca_release[1]_i_1_n_0 ;
  wire [57:0]cfg;
  (* async_reg = "true" *) wire [1:0]cp_release;
  wire \cp_release[1]_i_1_n_0 ;
  wire ctrl_n_1;
  wire ctrl_n_33;
  wire ctrl_n_34;
  wire ctrl_n_35;
  wire ctrl_n_36;
  wire ctrl_n_37;
  wire ctrl_n_38;
  wire ctrl_n_39;
  wire ctrl_n_40;
  wire ctrl_n_41;
  wire ctrl_n_42;
  wire ctrl_n_43;
  wire ctrl_n_44;
  wire hand10;
  wire in_de;
  wire in_hs;
  wire [23:0]in_rgb;
  wire in_vs;
  wire mailbox116_out;
  wire out;
  wire out_de;
  wire out_hs;
  wire [23:0]out_rgb;
  wire out_vs;
  (* async_reg = "true" *) wire [1:0]pa_release;
  wire pclk;
  wire pending;
  wire pending_reg;
  (* async_reg = "true" *) wire [1:0]pp_release;
  wire presetn;
  wire rvalid_reg;
  wire rvalid_reg_0;
  wire s_axi_aclk;
  wire [6:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [6:0]s_axi_awaddr;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire [0:0]s_axi_bresp;
  wire [31:0]s_axi_rdata;
  wire [0:0]s_axi_rresp;
  wire [31:0]s_axi_wdata;
  wire s_axi_wready;
  wire [3:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire vs_prev;
  wire \w_data_reg[0] ;
  wire w_held_reg;
  wire [10:0]x_reg;
  wire [9:0]y_reg;

  LUT1 #(
    .INIT(2'h1)) 
    \ca_release[1]_i_1 
       (.I0(s_axi_aresetn),
        .O(\ca_release[1]_i_1_n_0 ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \ca_release_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .CLR(\ca_release[1]_i_1_n_0 ),
        .D(1'b1),
        .Q(ca_release[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \ca_release_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .CLR(\ca_release[1]_i_1_n_0 ),
        .D(ca_release[0]),
        .Q(ca_release[1]));
  LUT1 #(
    .INIT(2'h1)) 
    \cp_release[1]_i_1 
       (.I0(presetn),
        .O(\cp_release[1]_i_1_n_0 ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \cp_release_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .CLR(\cp_release[1]_i_1_n_0 ),
        .D(1'b1),
        .Q(cp_release[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \cp_release_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .CLR(\cp_release[1]_i_1_n_0 ),
        .D(cp_release[0]),
        .Q(cp_release[1]));
  c6v_input_osd_0_0_input_osd_ctrl ctrl
       (.Q({cfg[57:48],cfg[42:32],cfg[2],cfg[0]}),
        .S({ctrl_n_33,ctrl_n_34,ctrl_n_35,ctrl_n_36}),
        .ack_toggle_reg_0(ack_toggle_reg),
        .ack_toggle_reg_1(vs_prev),
        .\active_cfg_reg[39]_0 ({ctrl_n_39,ctrl_n_40,ctrl_n_41,ctrl_n_42}),
        .\active_cfg_reg[42]_0 ({ctrl_n_43,ctrl_n_44}),
        .\active_cfg_reg[57]_0 (ctrl_n_37),
        .\active_cfg_reg[57]_1 (ctrl_n_38),
        .\aw_addr_reg[1]_0 (Q),
        .\aw_addr_reg[5]_0 (\aw_addr_reg[5] ),
        .aw_held_reg_0(aw_held),
        .\bresp_reg[1]_0 (\bresp_reg[1] ),
        .bvalid_reg_0(bvalid_reg),
        .bvalid_reg_1(bvalid_reg_0),
        .dx12_carry__0(x_reg),
        .\dy1_reg[9] (y_reg),
        .hand10(hand10),
        .\hand_left_reg[0]_0 (pp_release[1]),
        .\hand_left_reg[0]_1 (pa_release[1]),
        .in_vs(in_vs),
        .mailbox116_out(mailbox116_out),
        .out(out),
        .pclk(pclk),
        .pending_reg_0(pending),
        .pending_reg_1(pending_reg),
        .\pp_release_reg[1] (ctrl_n_1),
        .rvalid_reg_0(rvalid_reg),
        .rvalid_reg_1(rvalid_reg_0),
        .rvalid_reg_2(cp_release[1]),
        .rvalid_reg_3(ca_release[1]),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .\w_data_reg[0]_0 (\w_data_reg[0] ),
        .w_held_reg_0(w_held_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \pa_release_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\ca_release[1]_i_1_n_0 ),
        .D(1'b1),
        .Q(pa_release[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \pa_release_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\ca_release[1]_i_1_n_0 ),
        .D(pa_release[0]),
        .Q(pa_release[1]));
  c6v_input_osd_0_0_input_osd_pixels pixels
       (.Q({cfg[57:48],cfg[42:32],cfg[2],cfg[0]}),
        .S({ctrl_n_33,ctrl_n_34,ctrl_n_35,ctrl_n_36}),
        .dx10_carry__1_i_1_0({ctrl_n_43,ctrl_n_44}),
        .dx12_carry__0_0({ctrl_n_39,ctrl_n_40,ctrl_n_41,ctrl_n_42}),
        .dy10_carry__1_i_1_0(ctrl_n_38),
        .\dy1_reg[9]_0 (ctrl_n_37),
        .hand10(hand10),
        .in_de(in_de),
        .in_hs(in_hs),
        .in_rgb(in_rgb),
        .in_vs(in_vs),
        .out(pp_release[1]),
        .out_de(out_de),
        .out_hs(out_hs),
        .out_rgb(out_rgb),
        .out_vs(out_vs),
        .\paint2_reg[23]_0 (ctrl_n_1),
        .\paint2_reg[7]_0 (pa_release[1]),
        .pclk(pclk),
        .vs_prev_reg_0(vs_prev),
        .\x_reg[10]_0 (x_reg),
        .\y_reg[9]_0 (y_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \pp_release_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\cp_release[1]_i_1_n_0 ),
        .D(1'b1),
        .Q(pp_release[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \pp_release_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\cp_release[1]_i_1_n_0 ),
        .D(pp_release[0]),
        .Q(pp_release[1]));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
