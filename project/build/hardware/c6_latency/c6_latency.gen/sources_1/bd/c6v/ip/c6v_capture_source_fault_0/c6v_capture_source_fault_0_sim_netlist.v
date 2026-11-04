// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Fri Oct 30 22:05:57 2026
// Host        : build-host running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_source_fault_0/c6v_capture_source_fault_0_sim_netlist.v
// Design      : c6v_capture_source_fault_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "c6v_capture_source_fault_0,vision_source_fault_cdc,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "vision_source_fault_cdc,Vivado 2026.1" *) 
(* NotValidForBitStream *)
module c6v_capture_source_fault_0
   (vid_io_in_clk,
    aclk,
    common_aresetn,
    video_overflow,
    aclk_underflow,
    capture_aresetn,
    source_fault,
    fault_status);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 vid_io_in_clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vid_io_in_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input vid_io_in_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_RESET capture_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 common_aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME common_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input common_aresetn;
  input video_overflow;
  input aclk_underflow;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 capture_aresetn RST" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME capture_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) output capture_aresetn;
  output source_fault;
  output [1:0]fault_status;

  wire aclk;
  wire aclk_underflow;
  wire capture_aresetn;
  wire common_aresetn;
  wire [1:0]fault_status;
  wire source_fault;
  wire vid_io_in_clk;
  wire video_overflow;

  c6v_capture_source_fault_0_vision_source_fault_cdc inst
       (.aclk(aclk),
        .aclk_underflow(aclk_underflow),
        .capture_aresetn(capture_aresetn),
        .common_aresetn(common_aresetn),
        .fault_status(fault_status),
        .source_fault(source_fault),
        .vid_io_in_clk(vid_io_in_clk),
        .video_overflow(video_overflow));
endmodule

(* ORIG_REF_NAME = "vision_source_fault_cdc" *) 
module c6v_capture_source_fault_0_vision_source_fault_cdc
   (fault_status,
    capture_aresetn,
    source_fault,
    common_aresetn,
    vid_io_in_clk,
    aclk,
    aclk_underflow,
    video_overflow);
  output [1:0]fault_status;
  output capture_aresetn;
  output source_fault;
  input common_aresetn;
  input vid_io_in_clk;
  input aclk;
  input aclk_underflow;
  input video_overflow;

  wire aclk;
  wire aclk_resetn;
  wire aclk_underflow;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]armed_sync;
  wire capture_aresetn;
  wire capture_aresetn_i_1_n_0;
  wire common_aresetn;
  wire [1:1]\^fault_status ;
  wire overflow_latched_i_1_n_0;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]overflow_sync;
  wire [0:0]p_0_in;
  wire [0:0]p_0_in__0;
  wire source_fault;
  wire underflow_latched_i_1_n_0;
  wire vid_io_in_clk;
  wire video_armed_i_1_n_0;
  wire video_overflow;
  wire video_resetn;

  assign fault_status[1] = \^fault_status [1];
  assign fault_status[0] = overflow_sync[2];
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \armed_sync_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(p_0_in),
        .Q(armed_sync[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \armed_sync_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(armed_sync[0]),
        .Q(armed_sync[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \armed_sync_reg[2] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(armed_sync[1]),
        .Q(armed_sync[2]));
  LUT1 #(
    .INIT(2'h1)) 
    capture_aresetn_i_1
       (.I0(aclk_resetn),
        .O(capture_aresetn_i_1_n_0));
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 capture_aresetn RST" *) 
  (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *) 
  FDCE capture_aresetn_reg
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(armed_sync[2]),
        .Q(capture_aresetn));
  LUT2 #(
    .INIT(4'hE)) 
    overflow_latched_i_1
       (.I0(video_overflow),
        .I1(p_0_in__0),
        .O(overflow_latched_i_1_n_0));
  FDCE overflow_latched_reg
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(video_armed_i_1_n_0),
        .D(overflow_latched_i_1_n_0),
        .Q(p_0_in__0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \overflow_sync_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(p_0_in__0),
        .Q(overflow_sync[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \overflow_sync_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(overflow_sync[0]),
        .Q(overflow_sync[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "NO" *) 
  FDCE \overflow_sync_reg[2] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(overflow_sync[1]),
        .Q(overflow_sync[2]));
  (* DEF_VAL = "1'b1" *) 
  (* DEST_SYNC_FF = "3" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* INV_DEF_VAL = "1'b0" *) 
  (* RST_ACTIVE_HIGH = "0" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  (* XPM_MODULE = "TRUE" *) 
  c6v_capture_source_fault_0_xpm_cdc_async_rst processing_reset
       (.dest_arst(aclk_resetn),
        .dest_clk(aclk),
        .src_arst(common_aresetn));
  LUT4 #(
    .INIT(16'hAAA8)) 
    source_fault__0
       (.I0(aclk_resetn),
        .I1(aclk_underflow),
        .I2(overflow_sync[2]),
        .I3(\^fault_status ),
        .O(source_fault));
  LUT2 #(
    .INIT(4'hE)) 
    underflow_latched_i_1
       (.I0(aclk_underflow),
        .I1(\^fault_status ),
        .O(underflow_latched_i_1_n_0));
  FDCE underflow_latched_reg
       (.C(aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_1_n_0),
        .D(underflow_latched_i_1_n_0),
        .Q(\^fault_status ));
  LUT1 #(
    .INIT(2'h1)) 
    video_armed_i_1
       (.I0(video_resetn),
        .O(video_armed_i_1_n_0));
  FDCE video_armed_reg
       (.C(vid_io_in_clk),
        .CE(1'b1),
        .CLR(video_armed_i_1_n_0),
        .D(1'b1),
        .Q(p_0_in));
  (* DEF_VAL = "1'b1" *) 
  (* DEST_SYNC_FF = "3" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* INV_DEF_VAL = "1'b0" *) 
  (* RST_ACTIVE_HIGH = "0" *) 
  (* VERSION = "0" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  (* XPM_MODULE = "TRUE" *) 
  c6v_capture_source_fault_0_xpm_cdc_async_rst__1 video_reset
       (.dest_arst(video_resetn),
        .dest_clk(vid_io_in_clk),
        .src_arst(common_aresetn));
endmodule

(* DEF_VAL = "1'b1" *) (* DEST_SYNC_FF = "3" *) (* INIT_SYNC_FF = "0" *) 
(* INV_DEF_VAL = "1'b0" *) (* ORIG_REF_NAME = "xpm_cdc_async_rst" *) (* RST_ACTIVE_HIGH = "0" *) 
(* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "soft" *) 
(* xpm_cdc = "ASYNC_RST" *) 
module c6v_capture_source_fault_0_xpm_cdc_async_rst
   (src_arst,
    dest_clk,
    dest_arst);
  input src_arst;
  input dest_clk;
  output dest_arst;

  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ASYNC_RST" *) wire [2:0]arststages_ff;
  wire dest_clk;
  wire reset_pol;
  wire src_arst;

  assign dest_arst = arststages_ff[2];
  LUT1 #(
    .INIT(2'h1)) 
    \arststages_ff[2]_i_1 
       (.I0(src_arst),
        .O(reset_pol));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(1'b1),
        .Q(arststages_ff[0]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[0]),
        .Q(arststages_ff[1]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[1]),
        .Q(arststages_ff[2]));
endmodule

(* DEF_VAL = "1'b1" *) (* DEST_SYNC_FF = "3" *) (* INIT_SYNC_FF = "0" *) 
(* INV_DEF_VAL = "1'b0" *) (* ORIG_REF_NAME = "xpm_cdc_async_rst" *) (* RST_ACTIVE_HIGH = "0" *) 
(* VERSION = "0" *) (* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "soft" *) 
(* xpm_cdc = "ASYNC_RST" *) 
module c6v_capture_source_fault_0_xpm_cdc_async_rst__1
   (src_arst,
    dest_clk,
    dest_arst);
  input src_arst;
  input dest_clk;
  output dest_arst;

  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ASYNC_RST" *) wire [2:0]arststages_ff;
  wire dest_clk;
  wire reset_pol;
  wire src_arst;

  assign dest_arst = arststages_ff[2];
  LUT1 #(
    .INIT(2'h1)) 
    \arststages_ff[2]_i_1 
       (.I0(src_arst),
        .O(reset_pol));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(1'b1),
        .Q(arststages_ff[0]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[0]),
        .Q(arststages_ff[1]));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ASYNC_RST" *) 
  FDCE #(
    .INIT(1'b1)) 
    \arststages_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .CLR(reset_pol),
        .D(arststages_ff[1]),
        .Q(arststages_ff[2]));
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
