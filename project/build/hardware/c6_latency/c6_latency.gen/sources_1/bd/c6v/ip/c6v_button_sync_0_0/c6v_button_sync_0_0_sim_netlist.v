// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Fri Oct 30 22:07:48 2026
// Host        : build-host running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_button_sync_0_0/c6v_button_sync_0_0_sim_netlist.v
// Design      : c6v_button_sync_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "c6v_button_sync_0_0,button_sync,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "button_sync,Vivado 2026.1" *) 
(* NotValidForBitStream *)
module c6v_button_sync_0_0
   (aclk,
    aresetn,
    btn,
    btn_sync);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input aresetn;
  input [1:0]btn;
  output [1:0]btn_sync;

  wire aclk;
  wire aresetn;
  wire [1:0]btn;
  wire [1:0]btn_sync;

  c6v_button_sync_0_0_button_sync inst
       (.aclk(aclk),
        .aresetn(aresetn),
        .btn(btn),
        .btn_sync(btn_sync));
endmodule

(* ORIG_REF_NAME = "button_sync" *) 
module c6v_button_sync_0_0_button_sync
   (btn_sync,
    btn,
    aclk,
    aresetn);
  output [1:0]btn_sync;
  input [1:0]btn;
  input aclk;
  input aresetn;

  wire aclk;
  wire aresetn;
  wire [1:0]btn;
  (* async_reg = "true" *) wire [1:0]meta;
  wire \meta[1]_i_1_n_0 ;
  (* async_reg = "true" *) wire [1:0]stable;

  assign btn_sync[1:0] = stable;
  LUT1 #(
    .INIT(2'h1)) 
    \meta[1]_i_1 
       (.I0(aresetn),
        .O(\meta[1]_i_1_n_0 ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \meta_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\meta[1]_i_1_n_0 ),
        .D(btn[0]),
        .Q(meta[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \meta_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\meta[1]_i_1_n_0 ),
        .D(btn[1]),
        .Q(meta[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \stable_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\meta[1]_i_1_n_0 ),
        .D(meta[0]),
        .Q(stable[0]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDCE \stable_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .CLR(\meta[1]_i_1_n_0 ),
        .D(meta[1]),
        .Q(stable[1]));
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
