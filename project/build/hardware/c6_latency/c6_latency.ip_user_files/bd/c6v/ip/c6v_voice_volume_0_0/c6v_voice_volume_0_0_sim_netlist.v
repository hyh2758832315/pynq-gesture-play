// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Fri Oct 23 06:47:30 2026
// Host        : build-host running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/vvl/c0e/c6_latency.gen/sources_1/bd/c6v/ip/c6v_voice_volume_0_0/c6v_voice_volume_0_0_sim_netlist.v
// Design      : c6v_voice_volume_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "c6v_voice_volume_0_0,voice_volume_top,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "voice_volume_top,Vivado 2026.1" *) 
(* NotValidForBitStream *)
module c6v_voice_volume_0_0
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
    i2s_bclk,
    i2s_lrclk,
    i2s_sdata,
    codec_address,
    codec_mclk_locked);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axi_aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF s_axi, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input s_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axi_aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s_axi_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWADDR" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 12, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input [11:0]s_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWPROT" *) input [2:0]s_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWVALID" *) input s_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWREADY" *) output s_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WDATA" *) input [31:0]s_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WSTRB" *) input [3:0]s_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WVALID" *) input s_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WREADY" *) output s_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BRESP" *) output [1:0]s_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BVALID" *) output s_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BREADY" *) input s_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARADDR" *) input [11:0]s_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARPROT" *) input [2:0]s_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARVALID" *) input s_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARREADY" *) output s_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RDATA" *) output [31:0]s_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RRESP" *) output [1:0]s_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RVALID" *) output s_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RREADY" *) input s_axi_rready;
  output i2s_bclk;
  output i2s_lrclk;
  input i2s_sdata;
  output [1:0]codec_address;
  input codec_mclk_locked;

  wire \<const0> ;
  wire \<const1> ;
  wire codec_mclk_locked;
  wire i2s_bclk;
  wire i2s_lrclk;
  wire i2s_sdata;
  wire s_axi_aclk;
  wire [11:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [11:0]s_axi_awaddr;
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

  assign codec_address[1] = \<const1> ;
  assign codec_address[0] = \<const1> ;
  assign s_axi_bresp[1] = \^s_axi_bresp [1];
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_rresp[1] = \^s_axi_rresp [1];
  assign s_axi_rresp[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  c6v_voice_volume_0_0_voice_volume_top inst
       (.O115({i2s_lrclk,i2s_bclk}),
        .codec_mclk_locked(codec_mclk_locked),
        .i2s_sdata(i2s_sdata),
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
        .s_axi_bvalid_reg(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rready(s_axi_rready),
        .s_axi_rresp(\^s_axi_rresp ),
        .s_axi_rvalid_reg(s_axi_rvalid),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "axi_voice_volume" *) 
module c6v_voice_volume_0_0_axi_voice_volume
   (s_axi_rresp,
    SR,
    Q,
    s_axi_bvalid_reg_0,
    s_axi_rvalid_reg_0,
    s_axi_wready,
    s_axi_awready,
    s_axi_arready,
    s_axi_bresp,
    s_axi_rdata,
    dc_clipped0,
    s_axi_aclk,
    D,
    \difference_latched_reg[12] ,
    \difference_latched_reg[12]_0 ,
    S,
    \difference_latched_reg[20] ,
    \difference_latched_reg[24] ,
    input_fault,
    out,
    pcm_valid,
    s_axi_araddr,
    s_axi_aresetn,
    s_axi_wvalid,
    s_axi_awvalid,
    s_axi_arvalid,
    s_axi_bready,
    s_axi_rready,
    s_axi_wdata,
    s_axi_awaddr,
    s_axi_wstrb);
  output [0:0]s_axi_rresp;
  output [0:0]SR;
  output [14:0]Q;
  output s_axi_bvalid_reg_0;
  output s_axi_rvalid_reg_0;
  output s_axi_wready;
  output s_axi_awready;
  output s_axi_arready;
  output [0:0]s_axi_bresp;
  output [31:0]s_axi_rdata;
  input dc_clipped0;
  input s_axi_aclk;
  input [15:0]D;
  input [0:0]\difference_latched_reg[12] ;
  input [3:0]\difference_latched_reg[12]_0 ;
  input [3:0]S;
  input [3:0]\difference_latched_reg[20] ;
  input [1:0]\difference_latched_reg[24] ;
  input input_fault;
  input [0:0]out;
  input pcm_valid;
  input [11:0]s_axi_araddr;
  input s_axi_aresetn;
  input s_axi_wvalid;
  input s_axi_awvalid;
  input s_axi_arvalid;
  input s_axi_bready;
  input s_axi_rready;
  input [31:0]s_axi_wdata;
  input [11:0]s_axi_awaddr;
  input [3:0]s_axi_wstrb;

  wire [15:0]D;
  wire [14:0]Q;
  wire [3:0]S;
  wire [0:0]SR;
  wire [0:0]ack_epoch;
  wire \ack_epoch_reg_n_0_[0] ;
  wire \ack_epoch_reg_n_0_[10] ;
  wire \ack_epoch_reg_n_0_[11] ;
  wire \ack_epoch_reg_n_0_[12] ;
  wire \ack_epoch_reg_n_0_[13] ;
  wire \ack_epoch_reg_n_0_[14] ;
  wire \ack_epoch_reg_n_0_[15] ;
  wire \ack_epoch_reg_n_0_[16] ;
  wire \ack_epoch_reg_n_0_[17] ;
  wire \ack_epoch_reg_n_0_[18] ;
  wire \ack_epoch_reg_n_0_[19] ;
  wire \ack_epoch_reg_n_0_[1] ;
  wire \ack_epoch_reg_n_0_[20] ;
  wire \ack_epoch_reg_n_0_[21] ;
  wire \ack_epoch_reg_n_0_[22] ;
  wire \ack_epoch_reg_n_0_[23] ;
  wire \ack_epoch_reg_n_0_[24] ;
  wire \ack_epoch_reg_n_0_[25] ;
  wire \ack_epoch_reg_n_0_[26] ;
  wire \ack_epoch_reg_n_0_[27] ;
  wire \ack_epoch_reg_n_0_[28] ;
  wire \ack_epoch_reg_n_0_[29] ;
  wire \ack_epoch_reg_n_0_[2] ;
  wire \ack_epoch_reg_n_0_[30] ;
  wire \ack_epoch_reg_n_0_[31] ;
  wire \ack_epoch_reg_n_0_[3] ;
  wire \ack_epoch_reg_n_0_[4] ;
  wire \ack_epoch_reg_n_0_[5] ;
  wire \ack_epoch_reg_n_0_[6] ;
  wire \ack_epoch_reg_n_0_[7] ;
  wire \ack_epoch_reg_n_0_[8] ;
  wire \ack_epoch_reg_n_0_[9] ;
  wire [0:0]ack_sequence;
  wire \ack_sequence_reg_n_0_[0] ;
  wire \ack_sequence_reg_n_0_[10] ;
  wire \ack_sequence_reg_n_0_[11] ;
  wire \ack_sequence_reg_n_0_[12] ;
  wire \ack_sequence_reg_n_0_[13] ;
  wire \ack_sequence_reg_n_0_[14] ;
  wire \ack_sequence_reg_n_0_[15] ;
  wire \ack_sequence_reg_n_0_[16] ;
  wire \ack_sequence_reg_n_0_[17] ;
  wire \ack_sequence_reg_n_0_[18] ;
  wire \ack_sequence_reg_n_0_[19] ;
  wire \ack_sequence_reg_n_0_[1] ;
  wire \ack_sequence_reg_n_0_[20] ;
  wire \ack_sequence_reg_n_0_[21] ;
  wire \ack_sequence_reg_n_0_[22] ;
  wire \ack_sequence_reg_n_0_[23] ;
  wire \ack_sequence_reg_n_0_[24] ;
  wire \ack_sequence_reg_n_0_[25] ;
  wire \ack_sequence_reg_n_0_[26] ;
  wire \ack_sequence_reg_n_0_[27] ;
  wire \ack_sequence_reg_n_0_[28] ;
  wire \ack_sequence_reg_n_0_[29] ;
  wire \ack_sequence_reg_n_0_[2] ;
  wire \ack_sequence_reg_n_0_[30] ;
  wire \ack_sequence_reg_n_0_[31] ;
  wire \ack_sequence_reg_n_0_[3] ;
  wire \ack_sequence_reg_n_0_[4] ;
  wire \ack_sequence_reg_n_0_[5] ;
  wire \ack_sequence_reg_n_0_[6] ;
  wire \ack_sequence_reg_n_0_[7] ;
  wire \ack_sequence_reg_n_0_[8] ;
  wire \ack_sequence_reg_n_0_[9] ;
  wire ack_valid_i_1_n_0;
  wire ack_valid_reg_n_0;
  wire aw_held;
  wire aw_held0;
  wire aw_held09_out;
  wire aw_held_i_1_n_0;
  wire \config_epoch[0]_i_2_n_0 ;
  wire [31:0]config_epoch_reg;
  wire \config_epoch_reg[0]_i_1_n_0 ;
  wire \config_epoch_reg[0]_i_1_n_1 ;
  wire \config_epoch_reg[0]_i_1_n_2 ;
  wire \config_epoch_reg[0]_i_1_n_3 ;
  wire \config_epoch_reg[0]_i_1_n_4 ;
  wire \config_epoch_reg[0]_i_1_n_5 ;
  wire \config_epoch_reg[0]_i_1_n_6 ;
  wire \config_epoch_reg[0]_i_1_n_7 ;
  wire \config_epoch_reg[12]_i_1_n_0 ;
  wire \config_epoch_reg[12]_i_1_n_1 ;
  wire \config_epoch_reg[12]_i_1_n_2 ;
  wire \config_epoch_reg[12]_i_1_n_3 ;
  wire \config_epoch_reg[12]_i_1_n_4 ;
  wire \config_epoch_reg[12]_i_1_n_5 ;
  wire \config_epoch_reg[12]_i_1_n_6 ;
  wire \config_epoch_reg[12]_i_1_n_7 ;
  wire \config_epoch_reg[16]_i_1_n_0 ;
  wire \config_epoch_reg[16]_i_1_n_1 ;
  wire \config_epoch_reg[16]_i_1_n_2 ;
  wire \config_epoch_reg[16]_i_1_n_3 ;
  wire \config_epoch_reg[16]_i_1_n_4 ;
  wire \config_epoch_reg[16]_i_1_n_5 ;
  wire \config_epoch_reg[16]_i_1_n_6 ;
  wire \config_epoch_reg[16]_i_1_n_7 ;
  wire \config_epoch_reg[20]_i_1_n_0 ;
  wire \config_epoch_reg[20]_i_1_n_1 ;
  wire \config_epoch_reg[20]_i_1_n_2 ;
  wire \config_epoch_reg[20]_i_1_n_3 ;
  wire \config_epoch_reg[20]_i_1_n_4 ;
  wire \config_epoch_reg[20]_i_1_n_5 ;
  wire \config_epoch_reg[20]_i_1_n_6 ;
  wire \config_epoch_reg[20]_i_1_n_7 ;
  wire \config_epoch_reg[24]_i_1_n_0 ;
  wire \config_epoch_reg[24]_i_1_n_1 ;
  wire \config_epoch_reg[24]_i_1_n_2 ;
  wire \config_epoch_reg[24]_i_1_n_3 ;
  wire \config_epoch_reg[24]_i_1_n_4 ;
  wire \config_epoch_reg[24]_i_1_n_5 ;
  wire \config_epoch_reg[24]_i_1_n_6 ;
  wire \config_epoch_reg[24]_i_1_n_7 ;
  wire \config_epoch_reg[28]_i_1_n_1 ;
  wire \config_epoch_reg[28]_i_1_n_2 ;
  wire \config_epoch_reg[28]_i_1_n_3 ;
  wire \config_epoch_reg[28]_i_1_n_4 ;
  wire \config_epoch_reg[28]_i_1_n_5 ;
  wire \config_epoch_reg[28]_i_1_n_6 ;
  wire \config_epoch_reg[28]_i_1_n_7 ;
  wire \config_epoch_reg[4]_i_1_n_0 ;
  wire \config_epoch_reg[4]_i_1_n_1 ;
  wire \config_epoch_reg[4]_i_1_n_2 ;
  wire \config_epoch_reg[4]_i_1_n_3 ;
  wire \config_epoch_reg[4]_i_1_n_4 ;
  wire \config_epoch_reg[4]_i_1_n_5 ;
  wire \config_epoch_reg[4]_i_1_n_6 ;
  wire \config_epoch_reg[4]_i_1_n_7 ;
  wire \config_epoch_reg[8]_i_1_n_0 ;
  wire \config_epoch_reg[8]_i_1_n_1 ;
  wire \config_epoch_reg[8]_i_1_n_2 ;
  wire \config_epoch_reg[8]_i_1_n_3 ;
  wire \config_epoch_reg[8]_i_1_n_4 ;
  wire \config_epoch_reg[8]_i_1_n_5 ;
  wire \config_epoch_reg[8]_i_1_n_6 ;
  wire \config_epoch_reg[8]_i_1_n_7 ;
  wire configure;
  wire configure_i_1_n_0;
  wire core_n_126;
  wire core_n_127;
  wire core_n_128;
  wire core_n_129;
  wire core_n_130;
  wire core_n_131;
  wire core_n_132;
  wire core_n_133;
  wire core_n_134;
  wire core_n_135;
  wire core_n_136;
  wire core_n_235;
  wire core_n_300;
  wire core_n_301;
  wire core_n_302;
  wire core_n_303;
  wire core_n_304;
  wire core_n_305;
  wire core_n_306;
  wire core_n_307;
  wire core_n_308;
  wire core_n_309;
  wire core_n_310;
  wire core_n_311;
  wire core_n_312;
  wire core_n_313;
  wire core_n_314;
  wire core_n_315;
  wire core_n_316;
  wire core_n_317;
  wire core_n_318;
  wire core_n_319;
  wire core_n_32;
  wire core_n_320;
  wire core_n_321;
  wire core_n_322;
  wire core_n_323;
  wire core_n_324;
  wire core_n_325;
  wire core_n_326;
  wire core_n_327;
  wire core_n_328;
  wire core_n_329;
  wire core_n_33;
  wire core_n_330;
  wire core_n_331;
  wire core_n_34;
  wire core_n_35;
  wire core_n_36;
  wire core_n_37;
  wire core_n_38;
  wire core_n_39;
  wire core_n_40;
  wire core_n_41;
  wire core_n_42;
  wire core_n_43;
  wire core_n_44;
  wire core_n_45;
  wire core_n_46;
  wire core_n_47;
  wire core_n_48;
  wire core_n_49;
  wire core_n_50;
  wire core_n_51;
  wire core_n_52;
  wire core_n_53;
  wire core_n_54;
  wire core_n_55;
  wire core_n_56;
  wire core_n_57;
  wire core_n_58;
  wire core_n_59;
  wire core_n_60;
  wire core_n_61;
  wire core_n_62;
  wire core_n_63;
  wire dc_clipped0;
  wire [0:0]\difference_latched_reg[12] ;
  wire [3:0]\difference_latched_reg[12]_0 ;
  wire [3:0]\difference_latched_reg[20] ;
  wire [1:0]\difference_latched_reg[24] ;
  wire enable;
  wire [31:0]event_age;
  wire [31:0]event_epoch;
  wire [1:0]event_kind;
  wire [31:0]event_sequence;
  wire [31:0]event_window;
  wire [7:0]faults;
  wire input_fault;
  wire [31:0]last_sum;
  wire [31:0]loud_sum;
  wire [0:0]out;
  wire [31:0]p_15_in;
  wire [31:0]p_5_in;
  wire pcm_valid;
  wire [31:0]quiet_sum;
  wire s_axi_aclk;
  wire [11:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [11:0]s_axi_awaddr;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire [0:0]s_axi_bresp;
  wire s_axi_bresp3;
  wire s_axi_bresp3_carry__0_n_0;
  wire s_axi_bresp3_carry__0_n_1;
  wire s_axi_bresp3_carry__0_n_2;
  wire s_axi_bresp3_carry__0_n_3;
  wire s_axi_bresp3_carry__1_n_0;
  wire s_axi_bresp3_carry__1_n_1;
  wire s_axi_bresp3_carry__1_n_2;
  wire s_axi_bresp3_carry__1_n_3;
  wire s_axi_bresp3_carry__2_n_1;
  wire s_axi_bresp3_carry__2_n_2;
  wire s_axi_bresp3_carry__2_n_3;
  wire s_axi_bresp3_carry_i_1__0_n_0;
  wire s_axi_bresp3_carry_i_1__1_n_0;
  wire s_axi_bresp3_carry_i_1__2_n_0;
  wire s_axi_bresp3_carry_i_1_n_0;
  wire s_axi_bresp3_carry_i_2__0_n_0;
  wire s_axi_bresp3_carry_i_2__1_n_0;
  wire s_axi_bresp3_carry_i_2__2_n_0;
  wire s_axi_bresp3_carry_i_2_n_0;
  wire s_axi_bresp3_carry_i_3__0_n_0;
  wire s_axi_bresp3_carry_i_3__1_n_0;
  wire s_axi_bresp3_carry_i_3__2_n_0;
  wire s_axi_bresp3_carry_i_3_n_0;
  wire s_axi_bresp3_carry_i_4__0_n_0;
  wire s_axi_bresp3_carry_i_4__1_n_0;
  wire s_axi_bresp3_carry_i_4__2_n_0;
  wire s_axi_bresp3_carry_i_4_n_0;
  wire s_axi_bresp3_carry_i_5__0_n_0;
  wire s_axi_bresp3_carry_i_5__1_n_0;
  wire s_axi_bresp3_carry_i_5__2_n_0;
  wire s_axi_bresp3_carry_i_5_n_0;
  wire s_axi_bresp3_carry_i_6__0_n_0;
  wire s_axi_bresp3_carry_i_6__1_n_0;
  wire s_axi_bresp3_carry_i_6__2_n_0;
  wire s_axi_bresp3_carry_i_6_n_0;
  wire s_axi_bresp3_carry_i_7__0_n_0;
  wire s_axi_bresp3_carry_i_7__1_n_0;
  wire s_axi_bresp3_carry_i_7__2_n_0;
  wire s_axi_bresp3_carry_i_7_n_0;
  wire s_axi_bresp3_carry_i_8__0_n_0;
  wire s_axi_bresp3_carry_i_8__1_n_0;
  wire s_axi_bresp3_carry_i_8__2_n_0;
  wire s_axi_bresp3_carry_i_8_n_0;
  wire s_axi_bresp3_carry_n_0;
  wire s_axi_bresp3_carry_n_1;
  wire s_axi_bresp3_carry_n_2;
  wire s_axi_bresp3_carry_n_3;
  wire s_axi_bresp4;
  wire s_axi_bresp4_carry__0_i_1_n_0;
  wire s_axi_bresp4_carry__0_i_2_n_0;
  wire s_axi_bresp4_carry__0_i_3_n_0;
  wire s_axi_bresp4_carry__0_i_4_n_0;
  wire s_axi_bresp4_carry__0_i_5_n_0;
  wire s_axi_bresp4_carry__0_i_6_n_0;
  wire s_axi_bresp4_carry__0_i_7_n_0;
  wire s_axi_bresp4_carry__0_i_8_n_0;
  wire s_axi_bresp4_carry__0_n_0;
  wire s_axi_bresp4_carry__0_n_1;
  wire s_axi_bresp4_carry__0_n_2;
  wire s_axi_bresp4_carry__0_n_3;
  wire s_axi_bresp4_carry__1_i_1_n_0;
  wire s_axi_bresp4_carry__1_i_2_n_0;
  wire s_axi_bresp4_carry__1_i_3_n_0;
  wire s_axi_bresp4_carry__1_i_4_n_0;
  wire s_axi_bresp4_carry__1_i_5_n_0;
  wire s_axi_bresp4_carry__1_i_6_n_0;
  wire s_axi_bresp4_carry__1_i_7_n_0;
  wire s_axi_bresp4_carry__1_i_8_n_0;
  wire s_axi_bresp4_carry__1_n_0;
  wire s_axi_bresp4_carry__1_n_1;
  wire s_axi_bresp4_carry__1_n_2;
  wire s_axi_bresp4_carry__1_n_3;
  wire s_axi_bresp4_carry__2_i_1_n_0;
  wire s_axi_bresp4_carry__2_i_2_n_0;
  wire s_axi_bresp4_carry__2_i_3_n_0;
  wire s_axi_bresp4_carry__2_i_4_n_0;
  wire s_axi_bresp4_carry__2_i_5_n_0;
  wire s_axi_bresp4_carry__2_i_6_n_0;
  wire s_axi_bresp4_carry__2_i_7_n_0;
  wire s_axi_bresp4_carry__2_i_8_n_0;
  wire s_axi_bresp4_carry__2_n_1;
  wire s_axi_bresp4_carry__2_n_2;
  wire s_axi_bresp4_carry__2_n_3;
  wire s_axi_bresp4_carry_i_1_n_0;
  wire s_axi_bresp4_carry_i_2_n_0;
  wire s_axi_bresp4_carry_i_3_n_0;
  wire s_axi_bresp4_carry_i_4_n_0;
  wire s_axi_bresp4_carry_i_5_n_0;
  wire s_axi_bresp4_carry_i_6_n_0;
  wire s_axi_bresp4_carry_i_7_n_0;
  wire s_axi_bresp4_carry_i_8_n_0;
  wire s_axi_bresp4_carry_n_0;
  wire s_axi_bresp4_carry_n_1;
  wire s_axi_bresp4_carry_n_2;
  wire s_axi_bresp4_carry_n_3;
  wire \s_axi_bresp[1]_i_10_n_0 ;
  wire \s_axi_bresp[1]_i_11_n_0 ;
  wire \s_axi_bresp[1]_i_12_n_0 ;
  wire \s_axi_bresp[1]_i_13_n_0 ;
  wire \s_axi_bresp[1]_i_14_n_0 ;
  wire \s_axi_bresp[1]_i_15_n_0 ;
  wire \s_axi_bresp[1]_i_16_n_0 ;
  wire \s_axi_bresp[1]_i_2_n_0 ;
  wire \s_axi_bresp[1]_i_3_n_0 ;
  wire \s_axi_bresp[1]_i_4_n_0 ;
  wire \s_axi_bresp[1]_i_5_n_0 ;
  wire \s_axi_bresp[1]_i_6_n_0 ;
  wire \s_axi_bresp[1]_i_8_n_0 ;
  wire \s_axi_bresp[1]_i_9_n_0 ;
  wire s_axi_bvalid_i_1_n_0;
  wire s_axi_bvalid_reg_0;
  wire [31:0]s_axi_rdata;
  wire \s_axi_rdata[0]_i_10_n_0 ;
  wire \s_axi_rdata[0]_i_11_n_0 ;
  wire \s_axi_rdata[0]_i_12_n_0 ;
  wire \s_axi_rdata[0]_i_2_n_0 ;
  wire \s_axi_rdata[0]_i_3_n_0 ;
  wire \s_axi_rdata[0]_i_5_n_0 ;
  wire \s_axi_rdata[0]_i_9_n_0 ;
  wire \s_axi_rdata[10]_i_10_n_0 ;
  wire \s_axi_rdata[10]_i_11_n_0 ;
  wire \s_axi_rdata[10]_i_12_n_0 ;
  wire \s_axi_rdata[10]_i_2_n_0 ;
  wire \s_axi_rdata[10]_i_3_n_0 ;
  wire \s_axi_rdata[10]_i_5_n_0 ;
  wire \s_axi_rdata[10]_i_6_n_0 ;
  wire \s_axi_rdata[10]_i_9_n_0 ;
  wire \s_axi_rdata[11]_i_10_n_0 ;
  wire \s_axi_rdata[11]_i_1_n_0 ;
  wire \s_axi_rdata[11]_i_2_n_0 ;
  wire \s_axi_rdata[11]_i_3_n_0 ;
  wire \s_axi_rdata[11]_i_4_n_0 ;
  wire \s_axi_rdata[11]_i_5_n_0 ;
  wire \s_axi_rdata[11]_i_6_n_0 ;
  wire \s_axi_rdata[11]_i_7_n_0 ;
  wire \s_axi_rdata[11]_i_8_n_0 ;
  wire \s_axi_rdata[11]_i_9_n_0 ;
  wire \s_axi_rdata[12]_i_10_n_0 ;
  wire \s_axi_rdata[12]_i_1_n_0 ;
  wire \s_axi_rdata[12]_i_2_n_0 ;
  wire \s_axi_rdata[12]_i_3_n_0 ;
  wire \s_axi_rdata[12]_i_4_n_0 ;
  wire \s_axi_rdata[12]_i_5_n_0 ;
  wire \s_axi_rdata[12]_i_6_n_0 ;
  wire \s_axi_rdata[12]_i_8_n_0 ;
  wire \s_axi_rdata[12]_i_9_n_0 ;
  wire \s_axi_rdata[13]_i_10_n_0 ;
  wire \s_axi_rdata[13]_i_1_n_0 ;
  wire \s_axi_rdata[13]_i_2_n_0 ;
  wire \s_axi_rdata[13]_i_3_n_0 ;
  wire \s_axi_rdata[13]_i_4_n_0 ;
  wire \s_axi_rdata[13]_i_5_n_0 ;
  wire \s_axi_rdata[13]_i_6_n_0 ;
  wire \s_axi_rdata[13]_i_7_n_0 ;
  wire \s_axi_rdata[13]_i_8_n_0 ;
  wire \s_axi_rdata[13]_i_9_n_0 ;
  wire \s_axi_rdata[14]_i_10_n_0 ;
  wire \s_axi_rdata[14]_i_1_n_0 ;
  wire \s_axi_rdata[14]_i_2_n_0 ;
  wire \s_axi_rdata[14]_i_3_n_0 ;
  wire \s_axi_rdata[14]_i_4_n_0 ;
  wire \s_axi_rdata[14]_i_5_n_0 ;
  wire \s_axi_rdata[14]_i_6_n_0 ;
  wire \s_axi_rdata[14]_i_7_n_0 ;
  wire \s_axi_rdata[14]_i_8_n_0 ;
  wire \s_axi_rdata[14]_i_9_n_0 ;
  wire \s_axi_rdata[15]_i_10_n_0 ;
  wire \s_axi_rdata[15]_i_1_n_0 ;
  wire \s_axi_rdata[15]_i_2_n_0 ;
  wire \s_axi_rdata[15]_i_3_n_0 ;
  wire \s_axi_rdata[15]_i_4_n_0 ;
  wire \s_axi_rdata[15]_i_5_n_0 ;
  wire \s_axi_rdata[15]_i_6_n_0 ;
  wire \s_axi_rdata[15]_i_8_n_0 ;
  wire \s_axi_rdata[15]_i_9_n_0 ;
  wire \s_axi_rdata[16]_i_10_n_0 ;
  wire \s_axi_rdata[16]_i_1_n_0 ;
  wire \s_axi_rdata[16]_i_2_n_0 ;
  wire \s_axi_rdata[16]_i_3_n_0 ;
  wire \s_axi_rdata[16]_i_4_n_0 ;
  wire \s_axi_rdata[16]_i_5_n_0 ;
  wire \s_axi_rdata[16]_i_6_n_0 ;
  wire \s_axi_rdata[16]_i_7_n_0 ;
  wire \s_axi_rdata[16]_i_8_n_0 ;
  wire \s_axi_rdata[16]_i_9_n_0 ;
  wire \s_axi_rdata[17]_i_10_n_0 ;
  wire \s_axi_rdata[17]_i_1_n_0 ;
  wire \s_axi_rdata[17]_i_2_n_0 ;
  wire \s_axi_rdata[17]_i_3_n_0 ;
  wire \s_axi_rdata[17]_i_4_n_0 ;
  wire \s_axi_rdata[17]_i_5_n_0 ;
  wire \s_axi_rdata[17]_i_6_n_0 ;
  wire \s_axi_rdata[17]_i_8_n_0 ;
  wire \s_axi_rdata[17]_i_9_n_0 ;
  wire \s_axi_rdata[18]_i_10_n_0 ;
  wire \s_axi_rdata[18]_i_1_n_0 ;
  wire \s_axi_rdata[18]_i_2_n_0 ;
  wire \s_axi_rdata[18]_i_3_n_0 ;
  wire \s_axi_rdata[18]_i_4_n_0 ;
  wire \s_axi_rdata[18]_i_5_n_0 ;
  wire \s_axi_rdata[18]_i_6_n_0 ;
  wire \s_axi_rdata[18]_i_7_n_0 ;
  wire \s_axi_rdata[18]_i_8_n_0 ;
  wire \s_axi_rdata[18]_i_9_n_0 ;
  wire \s_axi_rdata[19]_i_10_n_0 ;
  wire \s_axi_rdata[19]_i_1_n_0 ;
  wire \s_axi_rdata[19]_i_2_n_0 ;
  wire \s_axi_rdata[19]_i_3_n_0 ;
  wire \s_axi_rdata[19]_i_4_n_0 ;
  wire \s_axi_rdata[19]_i_5_n_0 ;
  wire \s_axi_rdata[19]_i_6_n_0 ;
  wire \s_axi_rdata[19]_i_7_n_0 ;
  wire \s_axi_rdata[19]_i_8_n_0 ;
  wire \s_axi_rdata[19]_i_9_n_0 ;
  wire \s_axi_rdata[1]_i_10_n_0 ;
  wire \s_axi_rdata[1]_i_11_n_0 ;
  wire \s_axi_rdata[1]_i_12_n_0 ;
  wire \s_axi_rdata[1]_i_3_n_0 ;
  wire \s_axi_rdata[1]_i_4_n_0 ;
  wire \s_axi_rdata[1]_i_6_n_0 ;
  wire \s_axi_rdata[1]_i_9_n_0 ;
  wire \s_axi_rdata[20]_i_10_n_0 ;
  wire \s_axi_rdata[20]_i_1_n_0 ;
  wire \s_axi_rdata[20]_i_2_n_0 ;
  wire \s_axi_rdata[20]_i_3_n_0 ;
  wire \s_axi_rdata[20]_i_4_n_0 ;
  wire \s_axi_rdata[20]_i_5_n_0 ;
  wire \s_axi_rdata[20]_i_6_n_0 ;
  wire \s_axi_rdata[20]_i_7_n_0 ;
  wire \s_axi_rdata[20]_i_8_n_0 ;
  wire \s_axi_rdata[20]_i_9_n_0 ;
  wire \s_axi_rdata[21]_i_10_n_0 ;
  wire \s_axi_rdata[21]_i_1_n_0 ;
  wire \s_axi_rdata[21]_i_2_n_0 ;
  wire \s_axi_rdata[21]_i_3_n_0 ;
  wire \s_axi_rdata[21]_i_4_n_0 ;
  wire \s_axi_rdata[21]_i_5_n_0 ;
  wire \s_axi_rdata[21]_i_6_n_0 ;
  wire \s_axi_rdata[21]_i_7_n_0 ;
  wire \s_axi_rdata[21]_i_8_n_0 ;
  wire \s_axi_rdata[21]_i_9_n_0 ;
  wire \s_axi_rdata[22]_i_10_n_0 ;
  wire \s_axi_rdata[22]_i_1_n_0 ;
  wire \s_axi_rdata[22]_i_2_n_0 ;
  wire \s_axi_rdata[22]_i_3_n_0 ;
  wire \s_axi_rdata[22]_i_4_n_0 ;
  wire \s_axi_rdata[22]_i_5_n_0 ;
  wire \s_axi_rdata[22]_i_6_n_0 ;
  wire \s_axi_rdata[22]_i_8_n_0 ;
  wire \s_axi_rdata[22]_i_9_n_0 ;
  wire \s_axi_rdata[23]_i_10_n_0 ;
  wire \s_axi_rdata[23]_i_1_n_0 ;
  wire \s_axi_rdata[23]_i_2_n_0 ;
  wire \s_axi_rdata[23]_i_3_n_0 ;
  wire \s_axi_rdata[23]_i_4_n_0 ;
  wire \s_axi_rdata[23]_i_5_n_0 ;
  wire \s_axi_rdata[23]_i_6_n_0 ;
  wire \s_axi_rdata[23]_i_7_n_0 ;
  wire \s_axi_rdata[23]_i_8_n_0 ;
  wire \s_axi_rdata[23]_i_9_n_0 ;
  wire \s_axi_rdata[24]_i_10_n_0 ;
  wire \s_axi_rdata[24]_i_1_n_0 ;
  wire \s_axi_rdata[24]_i_2_n_0 ;
  wire \s_axi_rdata[24]_i_3_n_0 ;
  wire \s_axi_rdata[24]_i_4_n_0 ;
  wire \s_axi_rdata[24]_i_5_n_0 ;
  wire \s_axi_rdata[24]_i_6_n_0 ;
  wire \s_axi_rdata[24]_i_7_n_0 ;
  wire \s_axi_rdata[24]_i_8_n_0 ;
  wire \s_axi_rdata[24]_i_9_n_0 ;
  wire \s_axi_rdata[25]_i_10_n_0 ;
  wire \s_axi_rdata[25]_i_1_n_0 ;
  wire \s_axi_rdata[25]_i_2_n_0 ;
  wire \s_axi_rdata[25]_i_3_n_0 ;
  wire \s_axi_rdata[25]_i_4_n_0 ;
  wire \s_axi_rdata[25]_i_5_n_0 ;
  wire \s_axi_rdata[25]_i_6_n_0 ;
  wire \s_axi_rdata[25]_i_7_n_0 ;
  wire \s_axi_rdata[25]_i_8_n_0 ;
  wire \s_axi_rdata[25]_i_9_n_0 ;
  wire \s_axi_rdata[26]_i_10_n_0 ;
  wire \s_axi_rdata[26]_i_1_n_0 ;
  wire \s_axi_rdata[26]_i_2_n_0 ;
  wire \s_axi_rdata[26]_i_3_n_0 ;
  wire \s_axi_rdata[26]_i_4_n_0 ;
  wire \s_axi_rdata[26]_i_5_n_0 ;
  wire \s_axi_rdata[26]_i_6_n_0 ;
  wire \s_axi_rdata[26]_i_8_n_0 ;
  wire \s_axi_rdata[26]_i_9_n_0 ;
  wire \s_axi_rdata[27]_i_10_n_0 ;
  wire \s_axi_rdata[27]_i_1_n_0 ;
  wire \s_axi_rdata[27]_i_2_n_0 ;
  wire \s_axi_rdata[27]_i_3_n_0 ;
  wire \s_axi_rdata[27]_i_4_n_0 ;
  wire \s_axi_rdata[27]_i_5_n_0 ;
  wire \s_axi_rdata[27]_i_6_n_0 ;
  wire \s_axi_rdata[27]_i_7_n_0 ;
  wire \s_axi_rdata[27]_i_8_n_0 ;
  wire \s_axi_rdata[27]_i_9_n_0 ;
  wire \s_axi_rdata[28]_i_10_n_0 ;
  wire \s_axi_rdata[28]_i_1_n_0 ;
  wire \s_axi_rdata[28]_i_2_n_0 ;
  wire \s_axi_rdata[28]_i_3_n_0 ;
  wire \s_axi_rdata[28]_i_4_n_0 ;
  wire \s_axi_rdata[28]_i_5_n_0 ;
  wire \s_axi_rdata[28]_i_6_n_0 ;
  wire \s_axi_rdata[28]_i_8_n_0 ;
  wire \s_axi_rdata[28]_i_9_n_0 ;
  wire \s_axi_rdata[29]_i_10_n_0 ;
  wire \s_axi_rdata[29]_i_1_n_0 ;
  wire \s_axi_rdata[29]_i_2_n_0 ;
  wire \s_axi_rdata[29]_i_3_n_0 ;
  wire \s_axi_rdata[29]_i_4_n_0 ;
  wire \s_axi_rdata[29]_i_5_n_0 ;
  wire \s_axi_rdata[29]_i_6_n_0 ;
  wire \s_axi_rdata[29]_i_7_n_0 ;
  wire \s_axi_rdata[29]_i_8_n_0 ;
  wire \s_axi_rdata[29]_i_9_n_0 ;
  wire \s_axi_rdata[2]_i_10_n_0 ;
  wire \s_axi_rdata[2]_i_11_n_0 ;
  wire \s_axi_rdata[2]_i_12_n_0 ;
  wire \s_axi_rdata[2]_i_13_n_0 ;
  wire \s_axi_rdata[2]_i_3_n_0 ;
  wire \s_axi_rdata[2]_i_4_n_0 ;
  wire \s_axi_rdata[2]_i_6_n_0 ;
  wire \s_axi_rdata[2]_i_7_n_0 ;
  wire \s_axi_rdata[30]_i_10_n_0 ;
  wire \s_axi_rdata[30]_i_1_n_0 ;
  wire \s_axi_rdata[30]_i_2_n_0 ;
  wire \s_axi_rdata[30]_i_3_n_0 ;
  wire \s_axi_rdata[30]_i_4_n_0 ;
  wire \s_axi_rdata[30]_i_5_n_0 ;
  wire \s_axi_rdata[30]_i_6_n_0 ;
  wire \s_axi_rdata[30]_i_7_n_0 ;
  wire \s_axi_rdata[30]_i_8_n_0 ;
  wire \s_axi_rdata[30]_i_9_n_0 ;
  wire \s_axi_rdata[31]_i_10_n_0 ;
  wire \s_axi_rdata[31]_i_11_n_0 ;
  wire \s_axi_rdata[31]_i_12_n_0 ;
  wire \s_axi_rdata[31]_i_13_n_0 ;
  wire \s_axi_rdata[31]_i_15_n_0 ;
  wire \s_axi_rdata[31]_i_16_n_0 ;
  wire \s_axi_rdata[31]_i_17_n_0 ;
  wire \s_axi_rdata[31]_i_2_n_0 ;
  wire \s_axi_rdata[31]_i_3_n_0 ;
  wire \s_axi_rdata[31]_i_4_n_0 ;
  wire \s_axi_rdata[31]_i_5_n_0 ;
  wire \s_axi_rdata[31]_i_6_n_0 ;
  wire \s_axi_rdata[31]_i_7_n_0 ;
  wire \s_axi_rdata[31]_i_8_n_0 ;
  wire \s_axi_rdata[31]_i_9_n_0 ;
  wire \s_axi_rdata[3]_i_10_n_0 ;
  wire \s_axi_rdata[3]_i_11_n_0 ;
  wire \s_axi_rdata[3]_i_12_n_0 ;
  wire \s_axi_rdata[3]_i_13_n_0 ;
  wire \s_axi_rdata[3]_i_3_n_0 ;
  wire \s_axi_rdata[3]_i_4_n_0 ;
  wire \s_axi_rdata[3]_i_5_n_0 ;
  wire \s_axi_rdata[3]_i_6_n_0 ;
  wire \s_axi_rdata[3]_i_7_n_0 ;
  wire \s_axi_rdata[4]_i_10_n_0 ;
  wire \s_axi_rdata[4]_i_11_n_0 ;
  wire \s_axi_rdata[4]_i_12_n_0 ;
  wire \s_axi_rdata[4]_i_2_n_0 ;
  wire \s_axi_rdata[4]_i_3_n_0 ;
  wire \s_axi_rdata[4]_i_5_n_0 ;
  wire \s_axi_rdata[4]_i_9_n_0 ;
  wire \s_axi_rdata[5]_i_10_n_0 ;
  wire \s_axi_rdata[5]_i_2_n_0 ;
  wire \s_axi_rdata[5]_i_3_n_0 ;
  wire \s_axi_rdata[5]_i_5_n_0 ;
  wire \s_axi_rdata[5]_i_6_n_0 ;
  wire \s_axi_rdata[5]_i_7_n_0 ;
  wire \s_axi_rdata[5]_i_8_n_0 ;
  wire \s_axi_rdata[5]_i_9_n_0 ;
  wire \s_axi_rdata[6]_i_10_n_0 ;
  wire \s_axi_rdata[6]_i_11_n_0 ;
  wire \s_axi_rdata[6]_i_2_n_0 ;
  wire \s_axi_rdata[6]_i_3_n_0 ;
  wire \s_axi_rdata[6]_i_5_n_0 ;
  wire \s_axi_rdata[6]_i_8_n_0 ;
  wire \s_axi_rdata[6]_i_9_n_0 ;
  wire \s_axi_rdata[7]_i_10_n_0 ;
  wire \s_axi_rdata[7]_i_11_n_0 ;
  wire \s_axi_rdata[7]_i_3_n_0 ;
  wire \s_axi_rdata[7]_i_4_n_0 ;
  wire \s_axi_rdata[7]_i_5_n_0 ;
  wire \s_axi_rdata[7]_i_8_n_0 ;
  wire \s_axi_rdata[7]_i_9_n_0 ;
  wire \s_axi_rdata[8]_i_10_n_0 ;
  wire \s_axi_rdata[8]_i_11_n_0 ;
  wire \s_axi_rdata[8]_i_12_n_0 ;
  wire \s_axi_rdata[8]_i_13_n_0 ;
  wire \s_axi_rdata[8]_i_2_n_0 ;
  wire \s_axi_rdata[8]_i_3_n_0 ;
  wire \s_axi_rdata[8]_i_5_n_0 ;
  wire \s_axi_rdata[8]_i_6_n_0 ;
  wire \s_axi_rdata[8]_i_7_n_0 ;
  wire \s_axi_rdata[9]_i_10_n_0 ;
  wire \s_axi_rdata[9]_i_11_n_0 ;
  wire \s_axi_rdata[9]_i_2_n_0 ;
  wire \s_axi_rdata[9]_i_3_n_0 ;
  wire \s_axi_rdata[9]_i_5_n_0 ;
  wire \s_axi_rdata[9]_i_8_n_0 ;
  wire \s_axi_rdata[9]_i_9_n_0 ;
  wire \s_axi_rdata_reg[0]_i_7_n_0 ;
  wire \s_axi_rdata_reg[0]_i_8_n_0 ;
  wire \s_axi_rdata_reg[10]_i_7_n_0 ;
  wire \s_axi_rdata_reg[10]_i_8_n_0 ;
  wire \s_axi_rdata_reg[12]_i_7_n_0 ;
  wire \s_axi_rdata_reg[15]_i_7_n_0 ;
  wire \s_axi_rdata_reg[17]_i_7_n_0 ;
  wire \s_axi_rdata_reg[1]_i_7_n_0 ;
  wire \s_axi_rdata_reg[1]_i_8_n_0 ;
  wire \s_axi_rdata_reg[22]_i_7_n_0 ;
  wire \s_axi_rdata_reg[26]_i_7_n_0 ;
  wire \s_axi_rdata_reg[28]_i_7_n_0 ;
  wire \s_axi_rdata_reg[2]_i_8_n_0 ;
  wire \s_axi_rdata_reg[2]_i_9_n_0 ;
  wire \s_axi_rdata_reg[31]_i_14_n_0 ;
  wire \s_axi_rdata_reg[3]_i_8_n_0 ;
  wire \s_axi_rdata_reg[3]_i_9_n_0 ;
  wire \s_axi_rdata_reg[4]_i_7_n_0 ;
  wire \s_axi_rdata_reg[4]_i_8_n_0 ;
  wire \s_axi_rdata_reg[6]_i_6_n_0 ;
  wire \s_axi_rdata_reg[6]_i_7_n_0 ;
  wire \s_axi_rdata_reg[7]_i_6_n_0 ;
  wire \s_axi_rdata_reg[7]_i_7_n_0 ;
  wire \s_axi_rdata_reg[8]_i_4_n_0 ;
  wire \s_axi_rdata_reg[8]_i_8_n_0 ;
  wire \s_axi_rdata_reg[8]_i_9_n_0 ;
  wire \s_axi_rdata_reg[9]_i_6_n_0 ;
  wire \s_axi_rdata_reg[9]_i_7_n_0 ;
  wire s_axi_rready;
  wire [0:0]s_axi_rresp;
  wire \s_axi_rresp[1]_i_1_n_0 ;
  wire \s_axi_rresp[1]_i_2_n_0 ;
  wire \s_axi_rresp[1]_i_3_n_0 ;
  wire \s_axi_rresp[1]_i_4_n_0 ;
  wire \s_axi_rresp[1]_i_5_n_0 ;
  wire s_axi_rvalid06_out;
  wire s_axi_rvalid_i_1_n_0;
  wire s_axi_rvalid_reg_0;
  wire [31:0]s_axi_wdata;
  wire s_axi_wready;
  wire [3:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire [0:0]shadow_enable;
  wire \shadow_enable[31]_i_2_n_0 ;
  wire \shadow_enable_reg_n_0_[0] ;
  wire \shadow_enable_reg_n_0_[10] ;
  wire \shadow_enable_reg_n_0_[11] ;
  wire \shadow_enable_reg_n_0_[12] ;
  wire \shadow_enable_reg_n_0_[13] ;
  wire \shadow_enable_reg_n_0_[14] ;
  wire \shadow_enable_reg_n_0_[15] ;
  wire \shadow_enable_reg_n_0_[16] ;
  wire \shadow_enable_reg_n_0_[17] ;
  wire \shadow_enable_reg_n_0_[18] ;
  wire \shadow_enable_reg_n_0_[19] ;
  wire \shadow_enable_reg_n_0_[1] ;
  wire \shadow_enable_reg_n_0_[20] ;
  wire \shadow_enable_reg_n_0_[21] ;
  wire \shadow_enable_reg_n_0_[22] ;
  wire \shadow_enable_reg_n_0_[23] ;
  wire \shadow_enable_reg_n_0_[24] ;
  wire \shadow_enable_reg_n_0_[25] ;
  wire \shadow_enable_reg_n_0_[26] ;
  wire \shadow_enable_reg_n_0_[27] ;
  wire \shadow_enable_reg_n_0_[28] ;
  wire \shadow_enable_reg_n_0_[29] ;
  wire \shadow_enable_reg_n_0_[2] ;
  wire \shadow_enable_reg_n_0_[30] ;
  wire \shadow_enable_reg_n_0_[31] ;
  wire \shadow_enable_reg_n_0_[3] ;
  wire \shadow_enable_reg_n_0_[4] ;
  wire \shadow_enable_reg_n_0_[5] ;
  wire \shadow_enable_reg_n_0_[6] ;
  wire \shadow_enable_reg_n_0_[7] ;
  wire \shadow_enable_reg_n_0_[8] ;
  wire \shadow_enable_reg_n_0_[9] ;
  wire [31:0]shadow_loud;
  wire [0:0]shadow_loud_1;
  wire [31:0]shadow_quiet;
  wire [0:0]shadow_quiet_0;
  wire \shadow_soft[31]_i_1_n_0 ;
  wire \shadow_soft[31]_i_2_n_0 ;
  wire \shadow_soft_reg_n_0_[0] ;
  wire \shadow_soft_reg_n_0_[10] ;
  wire \shadow_soft_reg_n_0_[11] ;
  wire \shadow_soft_reg_n_0_[12] ;
  wire \shadow_soft_reg_n_0_[13] ;
  wire \shadow_soft_reg_n_0_[14] ;
  wire \shadow_soft_reg_n_0_[15] ;
  wire \shadow_soft_reg_n_0_[16] ;
  wire \shadow_soft_reg_n_0_[17] ;
  wire \shadow_soft_reg_n_0_[18] ;
  wire \shadow_soft_reg_n_0_[19] ;
  wire \shadow_soft_reg_n_0_[1] ;
  wire \shadow_soft_reg_n_0_[20] ;
  wire \shadow_soft_reg_n_0_[21] ;
  wire \shadow_soft_reg_n_0_[22] ;
  wire \shadow_soft_reg_n_0_[23] ;
  wire \shadow_soft_reg_n_0_[24] ;
  wire \shadow_soft_reg_n_0_[25] ;
  wire \shadow_soft_reg_n_0_[26] ;
  wire \shadow_soft_reg_n_0_[27] ;
  wire \shadow_soft_reg_n_0_[28] ;
  wire \shadow_soft_reg_n_0_[29] ;
  wire \shadow_soft_reg_n_0_[2] ;
  wire \shadow_soft_reg_n_0_[30] ;
  wire \shadow_soft_reg_n_0_[31] ;
  wire \shadow_soft_reg_n_0_[3] ;
  wire \shadow_soft_reg_n_0_[4] ;
  wire \shadow_soft_reg_n_0_[5] ;
  wire \shadow_soft_reg_n_0_[6] ;
  wire \shadow_soft_reg_n_0_[7] ;
  wire \shadow_soft_reg_n_0_[8] ;
  wire \shadow_soft_reg_n_0_[9] ;
  wire \snapshot[0][10]_i_1_n_0 ;
  wire \snapshot[0][10]_i_2_n_0 ;
  wire \snapshot[0][10]_i_3_n_0 ;
  wire [10:0]\snapshot_reg[0] ;
  wire [31:0]\snapshot_reg[10] ;
  wire [31:0]\snapshot_reg[11] ;
  wire [31:0]\snapshot_reg[12] ;
  wire [31:0]\snapshot_reg[13] ;
  wire [31:0]\snapshot_reg[14] ;
  wire [31:0]\snapshot_reg[15] ;
  wire [31:0]\snapshot_reg[16] ;
  wire [7:0]\snapshot_reg[1] ;
  wire [31:0]\snapshot_reg[2] ;
  wire [31:0]\snapshot_reg[3] ;
  wire [31:0]\snapshot_reg[4] ;
  wire [31:0]\snapshot_reg[5] ;
  wire [31:0]\snapshot_reg[6] ;
  wire [31:0]\snapshot_reg[7] ;
  wire [31:0]\snapshot_reg[8] ;
  wire [1:0]\snapshot_reg[9] ;
  wire \snapshot_sequence[0]_i_2_n_0 ;
  wire [31:0]snapshot_sequence_reg;
  wire \snapshot_sequence_reg[0]_i_1_n_0 ;
  wire \snapshot_sequence_reg[0]_i_1_n_1 ;
  wire \snapshot_sequence_reg[0]_i_1_n_2 ;
  wire \snapshot_sequence_reg[0]_i_1_n_3 ;
  wire \snapshot_sequence_reg[0]_i_1_n_4 ;
  wire \snapshot_sequence_reg[0]_i_1_n_5 ;
  wire \snapshot_sequence_reg[0]_i_1_n_6 ;
  wire \snapshot_sequence_reg[0]_i_1_n_7 ;
  wire \snapshot_sequence_reg[12]_i_1_n_0 ;
  wire \snapshot_sequence_reg[12]_i_1_n_1 ;
  wire \snapshot_sequence_reg[12]_i_1_n_2 ;
  wire \snapshot_sequence_reg[12]_i_1_n_3 ;
  wire \snapshot_sequence_reg[12]_i_1_n_4 ;
  wire \snapshot_sequence_reg[12]_i_1_n_5 ;
  wire \snapshot_sequence_reg[12]_i_1_n_6 ;
  wire \snapshot_sequence_reg[12]_i_1_n_7 ;
  wire \snapshot_sequence_reg[16]_i_1_n_0 ;
  wire \snapshot_sequence_reg[16]_i_1_n_1 ;
  wire \snapshot_sequence_reg[16]_i_1_n_2 ;
  wire \snapshot_sequence_reg[16]_i_1_n_3 ;
  wire \snapshot_sequence_reg[16]_i_1_n_4 ;
  wire \snapshot_sequence_reg[16]_i_1_n_5 ;
  wire \snapshot_sequence_reg[16]_i_1_n_6 ;
  wire \snapshot_sequence_reg[16]_i_1_n_7 ;
  wire \snapshot_sequence_reg[20]_i_1_n_0 ;
  wire \snapshot_sequence_reg[20]_i_1_n_1 ;
  wire \snapshot_sequence_reg[20]_i_1_n_2 ;
  wire \snapshot_sequence_reg[20]_i_1_n_3 ;
  wire \snapshot_sequence_reg[20]_i_1_n_4 ;
  wire \snapshot_sequence_reg[20]_i_1_n_5 ;
  wire \snapshot_sequence_reg[20]_i_1_n_6 ;
  wire \snapshot_sequence_reg[20]_i_1_n_7 ;
  wire \snapshot_sequence_reg[24]_i_1_n_0 ;
  wire \snapshot_sequence_reg[24]_i_1_n_1 ;
  wire \snapshot_sequence_reg[24]_i_1_n_2 ;
  wire \snapshot_sequence_reg[24]_i_1_n_3 ;
  wire \snapshot_sequence_reg[24]_i_1_n_4 ;
  wire \snapshot_sequence_reg[24]_i_1_n_5 ;
  wire \snapshot_sequence_reg[24]_i_1_n_6 ;
  wire \snapshot_sequence_reg[24]_i_1_n_7 ;
  wire \snapshot_sequence_reg[28]_i_1_n_1 ;
  wire \snapshot_sequence_reg[28]_i_1_n_2 ;
  wire \snapshot_sequence_reg[28]_i_1_n_3 ;
  wire \snapshot_sequence_reg[28]_i_1_n_4 ;
  wire \snapshot_sequence_reg[28]_i_1_n_5 ;
  wire \snapshot_sequence_reg[28]_i_1_n_6 ;
  wire \snapshot_sequence_reg[28]_i_1_n_7 ;
  wire \snapshot_sequence_reg[4]_i_1_n_0 ;
  wire \snapshot_sequence_reg[4]_i_1_n_1 ;
  wire \snapshot_sequence_reg[4]_i_1_n_2 ;
  wire \snapshot_sequence_reg[4]_i_1_n_3 ;
  wire \snapshot_sequence_reg[4]_i_1_n_4 ;
  wire \snapshot_sequence_reg[4]_i_1_n_5 ;
  wire \snapshot_sequence_reg[4]_i_1_n_6 ;
  wire \snapshot_sequence_reg[4]_i_1_n_7 ;
  wire \snapshot_sequence_reg[8]_i_1_n_0 ;
  wire \snapshot_sequence_reg[8]_i_1_n_1 ;
  wire \snapshot_sequence_reg[8]_i_1_n_2 ;
  wire \snapshot_sequence_reg[8]_i_1_n_3 ;
  wire \snapshot_sequence_reg[8]_i_1_n_4 ;
  wire \snapshot_sequence_reg[8]_i_1_n_5 ;
  wire \snapshot_sequence_reg[8]_i_1_n_6 ;
  wire \snapshot_sequence_reg[8]_i_1_n_7 ;
  wire snapshot_valid;
  wire snapshot_valid_i_2_n_0;
  wire \soft_sum[31]_i_10_n_0 ;
  wire \soft_sum[31]_i_11_n_0 ;
  wire \soft_sum[31]_i_12_n_0 ;
  wire \soft_sum[31]_i_13_n_0 ;
  wire \soft_sum[31]_i_14_n_0 ;
  wire \soft_sum[31]_i_15_n_0 ;
  wire \soft_sum[31]_i_16_n_0 ;
  wire \soft_sum[31]_i_17_n_0 ;
  wire \soft_sum[31]_i_18_n_0 ;
  wire \soft_sum[31]_i_19_n_0 ;
  wire \soft_sum[31]_i_20_n_0 ;
  wire \soft_sum[31]_i_21_n_0 ;
  wire \soft_sum[31]_i_2_n_0 ;
  wire \soft_sum[31]_i_3_n_0 ;
  wire \soft_sum[31]_i_4_n_0 ;
  wire \soft_sum[31]_i_5_n_0 ;
  wire \soft_sum[31]_i_6_n_0 ;
  wire \soft_sum[31]_i_7_n_0 ;
  wire \soft_sum[31]_i_8_n_0 ;
  wire \soft_sum[31]_i_9_n_0 ;
  wire \soft_sum_reg_n_0_[0] ;
  wire \soft_sum_reg_n_0_[10] ;
  wire \soft_sum_reg_n_0_[11] ;
  wire \soft_sum_reg_n_0_[12] ;
  wire \soft_sum_reg_n_0_[13] ;
  wire \soft_sum_reg_n_0_[14] ;
  wire \soft_sum_reg_n_0_[15] ;
  wire \soft_sum_reg_n_0_[16] ;
  wire \soft_sum_reg_n_0_[17] ;
  wire \soft_sum_reg_n_0_[18] ;
  wire \soft_sum_reg_n_0_[19] ;
  wire \soft_sum_reg_n_0_[1] ;
  wire \soft_sum_reg_n_0_[20] ;
  wire \soft_sum_reg_n_0_[21] ;
  wire \soft_sum_reg_n_0_[22] ;
  wire \soft_sum_reg_n_0_[23] ;
  wire \soft_sum_reg_n_0_[24] ;
  wire \soft_sum_reg_n_0_[25] ;
  wire \soft_sum_reg_n_0_[26] ;
  wire \soft_sum_reg_n_0_[27] ;
  wire \soft_sum_reg_n_0_[28] ;
  wire \soft_sum_reg_n_0_[29] ;
  wire \soft_sum_reg_n_0_[2] ;
  wire \soft_sum_reg_n_0_[30] ;
  wire \soft_sum_reg_n_0_[31] ;
  wire \soft_sum_reg_n_0_[3] ;
  wire \soft_sum_reg_n_0_[4] ;
  wire \soft_sum_reg_n_0_[5] ;
  wire \soft_sum_reg_n_0_[6] ;
  wire \soft_sum_reg_n_0_[7] ;
  wire \soft_sum_reg_n_0_[8] ;
  wire \soft_sum_reg_n_0_[9] ;
  wire [10:0]status;
  wire status0;
  wire w_held0;
  wire w_held_i_1_n_0;
  wire w_held_reg_n_0;
  wire [31:0]window_count;
  wire [11:0]write_address;
  wire [31:0]write_data;
  wire [3:0]write_strobe;
  wire [3:3]\NLW_config_epoch_reg[28]_i_1_CO_UNCONNECTED ;
  wire [3:0]NLW_s_axi_bresp3_carry_O_UNCONNECTED;
  wire [3:0]NLW_s_axi_bresp3_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_s_axi_bresp3_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_s_axi_bresp3_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_s_axi_bresp4_carry_O_UNCONNECTED;
  wire [3:0]NLW_s_axi_bresp4_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_s_axi_bresp4_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_s_axi_bresp4_carry__2_O_UNCONNECTED;
  wire [3:3]\NLW_snapshot_sequence_reg[28]_i_1_CO_UNCONNECTED ;

  LUT4 #(
    .INIT(16'h0800)) 
    \ack_epoch[31]_i_1 
       (.I0(\shadow_soft[31]_i_2_n_0 ),
        .I1(write_address[4]),
        .I2(write_address[3]),
        .I3(write_address[2]),
        .O(ack_epoch));
  FDRE \ack_epoch_reg[0] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[0]),
        .Q(\ack_epoch_reg_n_0_[0] ),
        .R(SR));
  FDRE \ack_epoch_reg[10] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[10]),
        .Q(\ack_epoch_reg_n_0_[10] ),
        .R(SR));
  FDRE \ack_epoch_reg[11] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[11]),
        .Q(\ack_epoch_reg_n_0_[11] ),
        .R(SR));
  FDRE \ack_epoch_reg[12] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[12]),
        .Q(\ack_epoch_reg_n_0_[12] ),
        .R(SR));
  FDRE \ack_epoch_reg[13] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[13]),
        .Q(\ack_epoch_reg_n_0_[13] ),
        .R(SR));
  FDRE \ack_epoch_reg[14] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[14]),
        .Q(\ack_epoch_reg_n_0_[14] ),
        .R(SR));
  FDRE \ack_epoch_reg[15] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[15]),
        .Q(\ack_epoch_reg_n_0_[15] ),
        .R(SR));
  FDRE \ack_epoch_reg[16] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[16]),
        .Q(\ack_epoch_reg_n_0_[16] ),
        .R(SR));
  FDRE \ack_epoch_reg[17] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[17]),
        .Q(\ack_epoch_reg_n_0_[17] ),
        .R(SR));
  FDRE \ack_epoch_reg[18] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[18]),
        .Q(\ack_epoch_reg_n_0_[18] ),
        .R(SR));
  FDRE \ack_epoch_reg[19] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[19]),
        .Q(\ack_epoch_reg_n_0_[19] ),
        .R(SR));
  FDRE \ack_epoch_reg[1] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[1]),
        .Q(\ack_epoch_reg_n_0_[1] ),
        .R(SR));
  FDRE \ack_epoch_reg[20] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[20]),
        .Q(\ack_epoch_reg_n_0_[20] ),
        .R(SR));
  FDRE \ack_epoch_reg[21] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[21]),
        .Q(\ack_epoch_reg_n_0_[21] ),
        .R(SR));
  FDRE \ack_epoch_reg[22] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[22]),
        .Q(\ack_epoch_reg_n_0_[22] ),
        .R(SR));
  FDRE \ack_epoch_reg[23] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[23]),
        .Q(\ack_epoch_reg_n_0_[23] ),
        .R(SR));
  FDRE \ack_epoch_reg[24] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[24]),
        .Q(\ack_epoch_reg_n_0_[24] ),
        .R(SR));
  FDRE \ack_epoch_reg[25] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[25]),
        .Q(\ack_epoch_reg_n_0_[25] ),
        .R(SR));
  FDRE \ack_epoch_reg[26] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[26]),
        .Q(\ack_epoch_reg_n_0_[26] ),
        .R(SR));
  FDRE \ack_epoch_reg[27] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[27]),
        .Q(\ack_epoch_reg_n_0_[27] ),
        .R(SR));
  FDRE \ack_epoch_reg[28] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[28]),
        .Q(\ack_epoch_reg_n_0_[28] ),
        .R(SR));
  FDRE \ack_epoch_reg[29] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[29]),
        .Q(\ack_epoch_reg_n_0_[29] ),
        .R(SR));
  FDRE \ack_epoch_reg[2] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[2]),
        .Q(\ack_epoch_reg_n_0_[2] ),
        .R(SR));
  FDRE \ack_epoch_reg[30] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[30]),
        .Q(\ack_epoch_reg_n_0_[30] ),
        .R(SR));
  FDRE \ack_epoch_reg[31] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[31]),
        .Q(\ack_epoch_reg_n_0_[31] ),
        .R(SR));
  FDRE \ack_epoch_reg[3] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[3]),
        .Q(\ack_epoch_reg_n_0_[3] ),
        .R(SR));
  FDRE \ack_epoch_reg[4] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[4]),
        .Q(\ack_epoch_reg_n_0_[4] ),
        .R(SR));
  FDRE \ack_epoch_reg[5] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[5]),
        .Q(\ack_epoch_reg_n_0_[5] ),
        .R(SR));
  FDRE \ack_epoch_reg[6] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[6]),
        .Q(\ack_epoch_reg_n_0_[6] ),
        .R(SR));
  FDRE \ack_epoch_reg[7] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[7]),
        .Q(\ack_epoch_reg_n_0_[7] ),
        .R(SR));
  FDRE \ack_epoch_reg[8] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[8]),
        .Q(\ack_epoch_reg_n_0_[8] ),
        .R(SR));
  FDRE \ack_epoch_reg[9] 
       (.C(s_axi_aclk),
        .CE(ack_epoch),
        .D(write_data[9]),
        .Q(\ack_epoch_reg_n_0_[9] ),
        .R(SR));
  LUT4 #(
    .INIT(16'h0800)) 
    \ack_sequence[31]_i_1 
       (.I0(\shadow_soft[31]_i_2_n_0 ),
        .I1(write_address[3]),
        .I2(write_address[2]),
        .I3(write_address[4]),
        .O(ack_sequence));
  FDRE \ack_sequence_reg[0] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[0]),
        .Q(\ack_sequence_reg_n_0_[0] ),
        .R(SR));
  FDRE \ack_sequence_reg[10] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[10]),
        .Q(\ack_sequence_reg_n_0_[10] ),
        .R(SR));
  FDRE \ack_sequence_reg[11] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[11]),
        .Q(\ack_sequence_reg_n_0_[11] ),
        .R(SR));
  FDRE \ack_sequence_reg[12] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[12]),
        .Q(\ack_sequence_reg_n_0_[12] ),
        .R(SR));
  FDRE \ack_sequence_reg[13] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[13]),
        .Q(\ack_sequence_reg_n_0_[13] ),
        .R(SR));
  FDRE \ack_sequence_reg[14] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[14]),
        .Q(\ack_sequence_reg_n_0_[14] ),
        .R(SR));
  FDRE \ack_sequence_reg[15] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[15]),
        .Q(\ack_sequence_reg_n_0_[15] ),
        .R(SR));
  FDRE \ack_sequence_reg[16] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[16]),
        .Q(\ack_sequence_reg_n_0_[16] ),
        .R(SR));
  FDRE \ack_sequence_reg[17] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[17]),
        .Q(\ack_sequence_reg_n_0_[17] ),
        .R(SR));
  FDRE \ack_sequence_reg[18] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[18]),
        .Q(\ack_sequence_reg_n_0_[18] ),
        .R(SR));
  FDRE \ack_sequence_reg[19] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[19]),
        .Q(\ack_sequence_reg_n_0_[19] ),
        .R(SR));
  FDRE \ack_sequence_reg[1] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[1]),
        .Q(\ack_sequence_reg_n_0_[1] ),
        .R(SR));
  FDRE \ack_sequence_reg[20] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[20]),
        .Q(\ack_sequence_reg_n_0_[20] ),
        .R(SR));
  FDRE \ack_sequence_reg[21] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[21]),
        .Q(\ack_sequence_reg_n_0_[21] ),
        .R(SR));
  FDRE \ack_sequence_reg[22] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[22]),
        .Q(\ack_sequence_reg_n_0_[22] ),
        .R(SR));
  FDRE \ack_sequence_reg[23] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[23]),
        .Q(\ack_sequence_reg_n_0_[23] ),
        .R(SR));
  FDRE \ack_sequence_reg[24] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[24]),
        .Q(\ack_sequence_reg_n_0_[24] ),
        .R(SR));
  FDRE \ack_sequence_reg[25] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[25]),
        .Q(\ack_sequence_reg_n_0_[25] ),
        .R(SR));
  FDRE \ack_sequence_reg[26] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[26]),
        .Q(\ack_sequence_reg_n_0_[26] ),
        .R(SR));
  FDRE \ack_sequence_reg[27] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[27]),
        .Q(\ack_sequence_reg_n_0_[27] ),
        .R(SR));
  FDRE \ack_sequence_reg[28] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[28]),
        .Q(\ack_sequence_reg_n_0_[28] ),
        .R(SR));
  FDRE \ack_sequence_reg[29] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[29]),
        .Q(\ack_sequence_reg_n_0_[29] ),
        .R(SR));
  FDRE \ack_sequence_reg[2] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[2]),
        .Q(\ack_sequence_reg_n_0_[2] ),
        .R(SR));
  FDRE \ack_sequence_reg[30] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[30]),
        .Q(\ack_sequence_reg_n_0_[30] ),
        .R(SR));
  FDRE \ack_sequence_reg[31] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[31]),
        .Q(\ack_sequence_reg_n_0_[31] ),
        .R(SR));
  FDRE \ack_sequence_reg[3] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[3]),
        .Q(\ack_sequence_reg_n_0_[3] ),
        .R(SR));
  FDRE \ack_sequence_reg[4] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[4]),
        .Q(\ack_sequence_reg_n_0_[4] ),
        .R(SR));
  FDRE \ack_sequence_reg[5] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[5]),
        .Q(\ack_sequence_reg_n_0_[5] ),
        .R(SR));
  FDRE \ack_sequence_reg[6] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[6]),
        .Q(\ack_sequence_reg_n_0_[6] ),
        .R(SR));
  FDRE \ack_sequence_reg[7] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[7]),
        .Q(\ack_sequence_reg_n_0_[7] ),
        .R(SR));
  FDRE \ack_sequence_reg[8] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[8]),
        .Q(\ack_sequence_reg_n_0_[8] ),
        .R(SR));
  FDRE \ack_sequence_reg[9] 
       (.C(s_axi_aclk),
        .CE(ack_sequence),
        .D(write_data[9]),
        .Q(\ack_sequence_reg_n_0_[9] ),
        .R(SR));
  LUT6 #(
    .INIT(64'h0000000002000000)) 
    ack_valid_i_1
       (.I0(write_data[2]),
        .I1(write_data[0]),
        .I2(write_data[1]),
        .I3(\soft_sum[31]_i_2_n_0 ),
        .I4(s_axi_aresetn),
        .I5(\soft_sum[31]_i_4_n_0 ),
        .O(ack_valid_i_1_n_0));
  FDRE ack_valid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ack_valid_i_1_n_0),
        .Q(ack_valid_reg_n_0),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT5 #(
    .INIT(32'hC0C008C8)) 
    aw_held_i_1
       (.I0(s_axi_awvalid),
        .I1(s_axi_aresetn),
        .I2(aw_held),
        .I3(w_held_reg_n_0),
        .I4(s_axi_bvalid_reg_0),
        .O(aw_held_i_1_n_0));
  FDRE aw_held_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(aw_held_i_1_n_0),
        .Q(aw_held),
        .R(1'b0));
  LUT1 #(
    .INIT(2'h1)) 
    \config_epoch[0]_i_2 
       (.I0(config_epoch_reg[0]),
        .O(\config_epoch[0]_i_2_n_0 ));
  FDRE \config_epoch_reg[0] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[0]_i_1_n_7 ),
        .Q(config_epoch_reg[0]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \config_epoch_reg[0]_i_1 
       (.CI(1'b0),
        .CO({\config_epoch_reg[0]_i_1_n_0 ,\config_epoch_reg[0]_i_1_n_1 ,\config_epoch_reg[0]_i_1_n_2 ,\config_epoch_reg[0]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\config_epoch_reg[0]_i_1_n_4 ,\config_epoch_reg[0]_i_1_n_5 ,\config_epoch_reg[0]_i_1_n_6 ,\config_epoch_reg[0]_i_1_n_7 }),
        .S({config_epoch_reg[3:1],\config_epoch[0]_i_2_n_0 }));
  FDRE \config_epoch_reg[10] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[8]_i_1_n_5 ),
        .Q(config_epoch_reg[10]),
        .R(SR));
  FDRE \config_epoch_reg[11] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[8]_i_1_n_4 ),
        .Q(config_epoch_reg[11]),
        .R(SR));
  FDRE \config_epoch_reg[12] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[12]_i_1_n_7 ),
        .Q(config_epoch_reg[12]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \config_epoch_reg[12]_i_1 
       (.CI(\config_epoch_reg[8]_i_1_n_0 ),
        .CO({\config_epoch_reg[12]_i_1_n_0 ,\config_epoch_reg[12]_i_1_n_1 ,\config_epoch_reg[12]_i_1_n_2 ,\config_epoch_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\config_epoch_reg[12]_i_1_n_4 ,\config_epoch_reg[12]_i_1_n_5 ,\config_epoch_reg[12]_i_1_n_6 ,\config_epoch_reg[12]_i_1_n_7 }),
        .S(config_epoch_reg[15:12]));
  FDRE \config_epoch_reg[13] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[12]_i_1_n_6 ),
        .Q(config_epoch_reg[13]),
        .R(SR));
  FDRE \config_epoch_reg[14] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[12]_i_1_n_5 ),
        .Q(config_epoch_reg[14]),
        .R(SR));
  FDRE \config_epoch_reg[15] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[12]_i_1_n_4 ),
        .Q(config_epoch_reg[15]),
        .R(SR));
  FDRE \config_epoch_reg[16] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[16]_i_1_n_7 ),
        .Q(config_epoch_reg[16]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \config_epoch_reg[16]_i_1 
       (.CI(\config_epoch_reg[12]_i_1_n_0 ),
        .CO({\config_epoch_reg[16]_i_1_n_0 ,\config_epoch_reg[16]_i_1_n_1 ,\config_epoch_reg[16]_i_1_n_2 ,\config_epoch_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\config_epoch_reg[16]_i_1_n_4 ,\config_epoch_reg[16]_i_1_n_5 ,\config_epoch_reg[16]_i_1_n_6 ,\config_epoch_reg[16]_i_1_n_7 }),
        .S(config_epoch_reg[19:16]));
  FDRE \config_epoch_reg[17] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[16]_i_1_n_6 ),
        .Q(config_epoch_reg[17]),
        .R(SR));
  FDRE \config_epoch_reg[18] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[16]_i_1_n_5 ),
        .Q(config_epoch_reg[18]),
        .R(SR));
  FDRE \config_epoch_reg[19] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[16]_i_1_n_4 ),
        .Q(config_epoch_reg[19]),
        .R(SR));
  FDRE \config_epoch_reg[1] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[0]_i_1_n_6 ),
        .Q(config_epoch_reg[1]),
        .R(SR));
  FDRE \config_epoch_reg[20] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[20]_i_1_n_7 ),
        .Q(config_epoch_reg[20]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \config_epoch_reg[20]_i_1 
       (.CI(\config_epoch_reg[16]_i_1_n_0 ),
        .CO({\config_epoch_reg[20]_i_1_n_0 ,\config_epoch_reg[20]_i_1_n_1 ,\config_epoch_reg[20]_i_1_n_2 ,\config_epoch_reg[20]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\config_epoch_reg[20]_i_1_n_4 ,\config_epoch_reg[20]_i_1_n_5 ,\config_epoch_reg[20]_i_1_n_6 ,\config_epoch_reg[20]_i_1_n_7 }),
        .S(config_epoch_reg[23:20]));
  FDRE \config_epoch_reg[21] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[20]_i_1_n_6 ),
        .Q(config_epoch_reg[21]),
        .R(SR));
  FDRE \config_epoch_reg[22] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[20]_i_1_n_5 ),
        .Q(config_epoch_reg[22]),
        .R(SR));
  FDRE \config_epoch_reg[23] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[20]_i_1_n_4 ),
        .Q(config_epoch_reg[23]),
        .R(SR));
  FDRE \config_epoch_reg[24] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[24]_i_1_n_7 ),
        .Q(config_epoch_reg[24]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \config_epoch_reg[24]_i_1 
       (.CI(\config_epoch_reg[20]_i_1_n_0 ),
        .CO({\config_epoch_reg[24]_i_1_n_0 ,\config_epoch_reg[24]_i_1_n_1 ,\config_epoch_reg[24]_i_1_n_2 ,\config_epoch_reg[24]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\config_epoch_reg[24]_i_1_n_4 ,\config_epoch_reg[24]_i_1_n_5 ,\config_epoch_reg[24]_i_1_n_6 ,\config_epoch_reg[24]_i_1_n_7 }),
        .S(config_epoch_reg[27:24]));
  FDRE \config_epoch_reg[25] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[24]_i_1_n_6 ),
        .Q(config_epoch_reg[25]),
        .R(SR));
  FDRE \config_epoch_reg[26] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[24]_i_1_n_5 ),
        .Q(config_epoch_reg[26]),
        .R(SR));
  FDRE \config_epoch_reg[27] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[24]_i_1_n_4 ),
        .Q(config_epoch_reg[27]),
        .R(SR));
  FDRE \config_epoch_reg[28] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[28]_i_1_n_7 ),
        .Q(config_epoch_reg[28]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \config_epoch_reg[28]_i_1 
       (.CI(\config_epoch_reg[24]_i_1_n_0 ),
        .CO({\NLW_config_epoch_reg[28]_i_1_CO_UNCONNECTED [3],\config_epoch_reg[28]_i_1_n_1 ,\config_epoch_reg[28]_i_1_n_2 ,\config_epoch_reg[28]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\config_epoch_reg[28]_i_1_n_4 ,\config_epoch_reg[28]_i_1_n_5 ,\config_epoch_reg[28]_i_1_n_6 ,\config_epoch_reg[28]_i_1_n_7 }),
        .S(config_epoch_reg[31:28]));
  FDRE \config_epoch_reg[29] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[28]_i_1_n_6 ),
        .Q(config_epoch_reg[29]),
        .R(SR));
  FDRE \config_epoch_reg[2] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[0]_i_1_n_5 ),
        .Q(config_epoch_reg[2]),
        .R(SR));
  FDRE \config_epoch_reg[30] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[28]_i_1_n_5 ),
        .Q(config_epoch_reg[30]),
        .R(SR));
  FDRE \config_epoch_reg[31] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[28]_i_1_n_4 ),
        .Q(config_epoch_reg[31]),
        .R(SR));
  FDRE \config_epoch_reg[3] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[0]_i_1_n_4 ),
        .Q(config_epoch_reg[3]),
        .R(SR));
  FDRE \config_epoch_reg[4] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[4]_i_1_n_7 ),
        .Q(config_epoch_reg[4]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \config_epoch_reg[4]_i_1 
       (.CI(\config_epoch_reg[0]_i_1_n_0 ),
        .CO({\config_epoch_reg[4]_i_1_n_0 ,\config_epoch_reg[4]_i_1_n_1 ,\config_epoch_reg[4]_i_1_n_2 ,\config_epoch_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\config_epoch_reg[4]_i_1_n_4 ,\config_epoch_reg[4]_i_1_n_5 ,\config_epoch_reg[4]_i_1_n_6 ,\config_epoch_reg[4]_i_1_n_7 }),
        .S(config_epoch_reg[7:4]));
  FDRE \config_epoch_reg[5] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[4]_i_1_n_6 ),
        .Q(config_epoch_reg[5]),
        .R(SR));
  FDRE \config_epoch_reg[6] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[4]_i_1_n_5 ),
        .Q(config_epoch_reg[6]),
        .R(SR));
  FDRE \config_epoch_reg[7] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[4]_i_1_n_4 ),
        .Q(config_epoch_reg[7]),
        .R(SR));
  FDRE \config_epoch_reg[8] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[8]_i_1_n_7 ),
        .Q(config_epoch_reg[8]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \config_epoch_reg[8]_i_1 
       (.CI(\config_epoch_reg[4]_i_1_n_0 ),
        .CO({\config_epoch_reg[8]_i_1_n_0 ,\config_epoch_reg[8]_i_1_n_1 ,\config_epoch_reg[8]_i_1_n_2 ,\config_epoch_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\config_epoch_reg[8]_i_1_n_4 ,\config_epoch_reg[8]_i_1_n_5 ,\config_epoch_reg[8]_i_1_n_6 ,\config_epoch_reg[8]_i_1_n_7 }),
        .S(config_epoch_reg[11:8]));
  FDRE \config_epoch_reg[9] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\config_epoch_reg[8]_i_1_n_6 ),
        .Q(config_epoch_reg[9]),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT4 #(
    .INIT(16'h0080)) 
    configure_i_1
       (.I0(\soft_sum[31]_i_2_n_0 ),
        .I1(\soft_sum[31]_i_3_n_0 ),
        .I2(s_axi_aresetn),
        .I3(\soft_sum[31]_i_4_n_0 ),
        .O(configure_i_1_n_0));
  FDRE configure_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(configure_i_1_n_0),
        .Q(configure),
        .R(1'b0));
  c6v_voice_volume_0_0_voice_volume_core core
       (.D(D),
        .Q(event_age),
        .S(S),
        .above_loud_carry__2_0(loud_sum),
        .ack_error_reg_0(ack_valid_reg_n_0),
        .config_epoch_reg(config_epoch_reg),
        .configure(configure),
        .dc_clipped0(dc_clipped0),
        .\dc_level_reg[22]_0 (Q),
        .\difference_latched_reg[12]_0 (\difference_latched_reg[12] ),
        .\difference_latched_reg[12]_1 (\difference_latched_reg[12]_0 ),
        .\difference_latched_reg[20]_0 (\difference_latched_reg[20] ),
        .\difference_latched_reg[24]_0 (\difference_latched_reg[24] ),
        .\event_epoch_reg[31]_0 (event_epoch),
        .\event_kind_reg[1]_0 (event_kind),
        .\event_sample_reg[63]_0 ({p_5_in,core_n_300,core_n_301,core_n_302,core_n_303,core_n_304,core_n_305,core_n_306,core_n_307,core_n_308,core_n_309,core_n_310,core_n_311,core_n_312,core_n_313,core_n_314,core_n_315,core_n_316,core_n_317,core_n_318,core_n_319,core_n_320,core_n_321,core_n_322,core_n_323,core_n_324,core_n_325,core_n_326,core_n_327,core_n_328,core_n_329,core_n_330,core_n_331}),
        .\event_sequence_reg[31]_0 (event_sequence),
        .\event_window_reg[31]_0 (event_window),
        .\faults[7]_i_10_0 ({\soft_sum_reg_n_0_[31] ,\soft_sum_reg_n_0_[30] ,\soft_sum_reg_n_0_[29] ,\soft_sum_reg_n_0_[28] ,\soft_sum_reg_n_0_[27] ,\soft_sum_reg_n_0_[26] ,\soft_sum_reg_n_0_[25] ,\soft_sum_reg_n_0_[24] ,\soft_sum_reg_n_0_[23] ,\soft_sum_reg_n_0_[22] ,\soft_sum_reg_n_0_[21] ,\soft_sum_reg_n_0_[20] ,\soft_sum_reg_n_0_[19] ,\soft_sum_reg_n_0_[18] ,\soft_sum_reg_n_0_[17] ,\soft_sum_reg_n_0_[16] ,\soft_sum_reg_n_0_[15] ,\soft_sum_reg_n_0_[14] ,\soft_sum_reg_n_0_[13] ,\soft_sum_reg_n_0_[12] ,\soft_sum_reg_n_0_[11] ,\soft_sum_reg_n_0_[10] ,\soft_sum_reg_n_0_[9] ,\soft_sum_reg_n_0_[8] ,\soft_sum_reg_n_0_[7] ,\soft_sum_reg_n_0_[6] ,\soft_sum_reg_n_0_[5] ,\soft_sum_reg_n_0_[4] ,\soft_sum_reg_n_0_[3] ,\soft_sum_reg_n_0_[2] ,\soft_sum_reg_n_0_[1] ,\soft_sum_reg_n_0_[0] }),
        .\faults_reg[0]_0 (status0),
        .\faults_reg[0]_1 (status[0]),
        .\faults_reg[1]_0 (out),
        .\faults_reg[7]_0 (faults),
        .input_fault(input_fault),
        .\last_sum_reg[31]_0 (last_sum),
        .matching_ack0_carry__1_0({\ack_sequence_reg_n_0_[31] ,\ack_sequence_reg_n_0_[30] ,\ack_sequence_reg_n_0_[29] ,\ack_sequence_reg_n_0_[28] ,\ack_sequence_reg_n_0_[27] ,\ack_sequence_reg_n_0_[26] ,\ack_sequence_reg_n_0_[25] ,\ack_sequence_reg_n_0_[24] ,\ack_sequence_reg_n_0_[23] ,\ack_sequence_reg_n_0_[22] ,\ack_sequence_reg_n_0_[21] ,\ack_sequence_reg_n_0_[20] ,\ack_sequence_reg_n_0_[19] ,\ack_sequence_reg_n_0_[18] ,\ack_sequence_reg_n_0_[17] ,\ack_sequence_reg_n_0_[16] ,\ack_sequence_reg_n_0_[15] ,\ack_sequence_reg_n_0_[14] ,\ack_sequence_reg_n_0_[13] ,\ack_sequence_reg_n_0_[12] ,\ack_sequence_reg_n_0_[11] ,\ack_sequence_reg_n_0_[10] ,\ack_sequence_reg_n_0_[9] ,\ack_sequence_reg_n_0_[8] ,\ack_sequence_reg_n_0_[7] ,\ack_sequence_reg_n_0_[6] ,\ack_sequence_reg_n_0_[5] ,\ack_sequence_reg_n_0_[4] ,\ack_sequence_reg_n_0_[3] ,\ack_sequence_reg_n_0_[2] ,\ack_sequence_reg_n_0_[1] ,\ack_sequence_reg_n_0_[0] }),
        .matching_ack1_carry__1_0({\ack_epoch_reg_n_0_[31] ,\ack_epoch_reg_n_0_[30] ,\ack_epoch_reg_n_0_[29] ,\ack_epoch_reg_n_0_[28] ,\ack_epoch_reg_n_0_[27] ,\ack_epoch_reg_n_0_[26] ,\ack_epoch_reg_n_0_[25] ,\ack_epoch_reg_n_0_[24] ,\ack_epoch_reg_n_0_[23] ,\ack_epoch_reg_n_0_[22] ,\ack_epoch_reg_n_0_[21] ,\ack_epoch_reg_n_0_[20] ,\ack_epoch_reg_n_0_[19] ,\ack_epoch_reg_n_0_[18] ,\ack_epoch_reg_n_0_[17] ,\ack_epoch_reg_n_0_[16] ,\ack_epoch_reg_n_0_[15] ,\ack_epoch_reg_n_0_[14] ,\ack_epoch_reg_n_0_[13] ,\ack_epoch_reg_n_0_[12] ,\ack_epoch_reg_n_0_[11] ,\ack_epoch_reg_n_0_[10] ,\ack_epoch_reg_n_0_[9] ,\ack_epoch_reg_n_0_[8] ,\ack_epoch_reg_n_0_[7] ,\ack_epoch_reg_n_0_[6] ,\ack_epoch_reg_n_0_[5] ,\ack_epoch_reg_n_0_[4] ,\ack_epoch_reg_n_0_[3] ,\ack_epoch_reg_n_0_[2] ,\ack_epoch_reg_n_0_[1] ,\ack_epoch_reg_n_0_[0] }),
        .out({p_15_in,core_n_32,core_n_33,core_n_34,core_n_35,core_n_36,core_n_37,core_n_38,core_n_39,core_n_40,core_n_41,core_n_42,core_n_43,core_n_44,core_n_45,core_n_46,core_n_47,core_n_48,core_n_49,core_n_50,core_n_51,core_n_52,core_n_53,core_n_54,core_n_55,core_n_56,core_n_57,core_n_58,core_n_59,core_n_60,core_n_61,core_n_62,core_n_63}),
        .pcm_valid(pcm_valid),
        .quiet_carry__2_0(quiet_sum),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_aresetn_0(SR),
        .\s_axi_rdata_reg[0] (\s_axi_rdata[0]_i_2_n_0 ),
        .\s_axi_rdata_reg[0]_0 (\s_axi_rdata[0]_i_3_n_0 ),
        .\s_axi_rdata_reg[10] (\s_axi_rdata[10]_i_2_n_0 ),
        .\s_axi_rdata_reg[10]_0 (\s_axi_rdata[10]_i_3_n_0 ),
        .\s_axi_rdata_reg[10]_1 (\s_axi_rdata[10]_i_6_n_0 ),
        .\s_axi_rdata_reg[1] (\s_axi_rdata[1]_i_3_n_0 ),
        .\s_axi_rdata_reg[1]_0 (\s_axi_rdata[1]_i_4_n_0 ),
        .\s_axi_rdata_reg[1]_1 (\s_axi_rdata[3]_i_5_n_0 ),
        .\s_axi_rdata_reg[2] (\s_axi_rdata[31]_i_3_n_0 ),
        .\s_axi_rdata_reg[2]_0 (\s_axi_rdata[31]_i_7_n_0 ),
        .\s_axi_rdata_reg[2]_1 (\s_axi_rdata[2]_i_3_n_0 ),
        .\s_axi_rdata_reg[2]_2 (\s_axi_rdata[31]_i_4_n_0 ),
        .\s_axi_rdata_reg[2]_3 (\s_axi_rdata[2]_i_4_n_0 ),
        .\s_axi_rdata_reg[2]_4 (\s_axi_rdata[2]_i_6_n_0 ),
        .\s_axi_rdata_reg[3] (\s_axi_rdata[3]_i_3_n_0 ),
        .\s_axi_rdata_reg[3]_0 (\s_axi_rdata[3]_i_4_n_0 ),
        .\s_axi_rdata_reg[3]_1 (\s_axi_rdata[3]_i_6_n_0 ),
        .\s_axi_rdata_reg[4] (\s_axi_rdata[4]_i_2_n_0 ),
        .\s_axi_rdata_reg[4]_0 (\s_axi_rdata[4]_i_3_n_0 ),
        .\s_axi_rdata_reg[4]_1 (\s_axi_rdata[31]_i_11_n_0 ),
        .\s_axi_rdata_reg[4]_2 (\s_axi_rdata[31]_i_10_n_0 ),
        .\s_axi_rdata_reg[5] (\s_axi_rdata[5]_i_2_n_0 ),
        .\s_axi_rdata_reg[5]_0 (\s_axi_rdata[5]_i_3_n_0 ),
        .\s_axi_rdata_reg[6] (\s_axi_rdata[6]_i_2_n_0 ),
        .\s_axi_rdata_reg[6]_0 (\s_axi_rdata[6]_i_3_n_0 ),
        .\s_axi_rdata_reg[7] (\s_axi_rdata[7]_i_3_n_0 ),
        .\s_axi_rdata_reg[7]_0 (\s_axi_rdata[7]_i_4_n_0 ),
        .\s_axi_rdata_reg[8] (\s_axi_rdata[8]_i_2_n_0 ),
        .\s_axi_rdata_reg[8]_0 (\s_axi_rdata[8]_i_3_n_0 ),
        .\s_axi_rdata_reg[8]_1 (\s_axi_rdata_reg[8]_i_4_n_0 ),
        .\s_axi_rdata_reg[9] ({\shadow_soft_reg_n_0_[9] ,\shadow_soft_reg_n_0_[7] ,\shadow_soft_reg_n_0_[6] ,\shadow_soft_reg_n_0_[5] ,\shadow_soft_reg_n_0_[4] ,\shadow_soft_reg_n_0_[2] ,\shadow_soft_reg_n_0_[1] ,\shadow_soft_reg_n_0_[0] }),
        .\s_axi_rdata_reg[9]_0 (\s_axi_rdata[9]_i_2_n_0 ),
        .\s_axi_rdata_reg[9]_1 (\s_axi_rdata[9]_i_3_n_0 ),
        .\snapshot_sequence_reg[10] ({core_n_126,core_n_127,core_n_128,core_n_129,core_n_130,core_n_131,core_n_132,core_n_133,core_n_134,core_n_135,core_n_136}),
        .snapshot_valid(snapshot_valid),
        .snapshot_valid_reg(core_n_235),
        .snapshot_valid_reg_0(snapshot_valid_i_2_n_0),
        .snapshot_valid_reg_1(\shadow_soft[31]_i_2_n_0 ),
        .snapshot_valid_reg_2(\snapshot[0][10]_i_2_n_0 ),
        .snapshot_valid_reg_3(write_data[1]),
        .status({status[10:8],status[4],status[1]}),
        .\window_count_reg[31]_0 (window_count));
  FDRE enable_reg
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_enable_reg_n_0_[0] ),
        .Q(status[0]),
        .R(SR));
  FDRE \loud_sum_reg[0] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[0]),
        .Q(loud_sum[0]),
        .R(SR));
  FDRE \loud_sum_reg[10] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[10]),
        .Q(loud_sum[10]),
        .R(SR));
  FDSE \loud_sum_reg[11] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[11]),
        .Q(loud_sum[11]),
        .S(SR));
  FDRE \loud_sum_reg[12] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[12]),
        .Q(loud_sum[12]),
        .R(SR));
  FDRE \loud_sum_reg[13] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[13]),
        .Q(loud_sum[13]),
        .R(SR));
  FDRE \loud_sum_reg[14] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[14]),
        .Q(loud_sum[14]),
        .R(SR));
  FDRE \loud_sum_reg[15] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[15]),
        .Q(loud_sum[15]),
        .R(SR));
  FDSE \loud_sum_reg[16] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[16]),
        .Q(loud_sum[16]),
        .S(SR));
  FDRE \loud_sum_reg[17] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[17]),
        .Q(loud_sum[17]),
        .R(SR));
  FDSE \loud_sum_reg[18] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[18]),
        .Q(loud_sum[18]),
        .S(SR));
  FDSE \loud_sum_reg[19] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[19]),
        .Q(loud_sum[19]),
        .S(SR));
  FDRE \loud_sum_reg[1] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[1]),
        .Q(loud_sum[1]),
        .R(SR));
  FDSE \loud_sum_reg[20] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[20]),
        .Q(loud_sum[20]),
        .S(SR));
  FDSE \loud_sum_reg[21] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[21]),
        .Q(loud_sum[21]),
        .S(SR));
  FDRE \loud_sum_reg[22] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[22]),
        .Q(loud_sum[22]),
        .R(SR));
  FDRE \loud_sum_reg[23] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[23]),
        .Q(loud_sum[23]),
        .R(SR));
  FDRE \loud_sum_reg[24] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[24]),
        .Q(loud_sum[24]),
        .R(SR));
  FDRE \loud_sum_reg[25] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[25]),
        .Q(loud_sum[25]),
        .R(SR));
  FDRE \loud_sum_reg[26] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[26]),
        .Q(loud_sum[26]),
        .R(SR));
  FDRE \loud_sum_reg[27] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[27]),
        .Q(loud_sum[27]),
        .R(SR));
  FDRE \loud_sum_reg[28] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[28]),
        .Q(loud_sum[28]),
        .R(SR));
  FDRE \loud_sum_reg[29] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[29]),
        .Q(loud_sum[29]),
        .R(SR));
  FDRE \loud_sum_reg[2] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[2]),
        .Q(loud_sum[2]),
        .R(SR));
  FDRE \loud_sum_reg[30] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[30]),
        .Q(loud_sum[30]),
        .R(SR));
  FDRE \loud_sum_reg[31] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[31]),
        .Q(loud_sum[31]),
        .R(SR));
  FDRE \loud_sum_reg[3] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[3]),
        .Q(loud_sum[3]),
        .R(SR));
  FDRE \loud_sum_reg[4] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[4]),
        .Q(loud_sum[4]),
        .R(SR));
  FDRE \loud_sum_reg[5] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[5]),
        .Q(loud_sum[5]),
        .R(SR));
  FDRE \loud_sum_reg[6] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[6]),
        .Q(loud_sum[6]),
        .R(SR));
  FDRE \loud_sum_reg[7] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[7]),
        .Q(loud_sum[7]),
        .R(SR));
  FDSE \loud_sum_reg[8] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[8]),
        .Q(loud_sum[8]),
        .S(SR));
  FDRE \loud_sum_reg[9] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_loud[9]),
        .Q(loud_sum[9]),
        .R(SR));
  FDRE \quiet_sum_reg[0] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[0]),
        .Q(quiet_sum[0]),
        .R(SR));
  FDRE \quiet_sum_reg[10] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[10]),
        .Q(quiet_sum[10]),
        .R(SR));
  FDRE \quiet_sum_reg[11] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[11]),
        .Q(quiet_sum[11]),
        .R(SR));
  FDRE \quiet_sum_reg[12] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[12]),
        .Q(quiet_sum[12]),
        .R(SR));
  FDSE \quiet_sum_reg[13] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[13]),
        .Q(quiet_sum[13]),
        .S(SR));
  FDRE \quiet_sum_reg[14] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[14]),
        .Q(quiet_sum[14]),
        .R(SR));
  FDSE \quiet_sum_reg[15] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[15]),
        .Q(quiet_sum[15]),
        .S(SR));
  FDSE \quiet_sum_reg[16] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[16]),
        .Q(quiet_sum[16]),
        .S(SR));
  FDSE \quiet_sum_reg[17] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[17]),
        .Q(quiet_sum[17]),
        .S(SR));
  FDSE \quiet_sum_reg[18] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[18]),
        .Q(quiet_sum[18]),
        .S(SR));
  FDRE \quiet_sum_reg[19] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[19]),
        .Q(quiet_sum[19]),
        .R(SR));
  FDRE \quiet_sum_reg[1] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[1]),
        .Q(quiet_sum[1]),
        .R(SR));
  FDRE \quiet_sum_reg[20] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[20]),
        .Q(quiet_sum[20]),
        .R(SR));
  FDRE \quiet_sum_reg[21] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[21]),
        .Q(quiet_sum[21]),
        .R(SR));
  FDRE \quiet_sum_reg[22] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[22]),
        .Q(quiet_sum[22]),
        .R(SR));
  FDRE \quiet_sum_reg[23] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[23]),
        .Q(quiet_sum[23]),
        .R(SR));
  FDRE \quiet_sum_reg[24] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[24]),
        .Q(quiet_sum[24]),
        .R(SR));
  FDRE \quiet_sum_reg[25] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[25]),
        .Q(quiet_sum[25]),
        .R(SR));
  FDRE \quiet_sum_reg[26] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[26]),
        .Q(quiet_sum[26]),
        .R(SR));
  FDRE \quiet_sum_reg[27] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[27]),
        .Q(quiet_sum[27]),
        .R(SR));
  FDRE \quiet_sum_reg[28] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[28]),
        .Q(quiet_sum[28]),
        .R(SR));
  FDRE \quiet_sum_reg[29] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[29]),
        .Q(quiet_sum[29]),
        .R(SR));
  FDRE \quiet_sum_reg[2] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[2]),
        .Q(quiet_sum[2]),
        .R(SR));
  FDRE \quiet_sum_reg[30] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[30]),
        .Q(quiet_sum[30]),
        .R(SR));
  FDRE \quiet_sum_reg[31] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[31]),
        .Q(quiet_sum[31]),
        .R(SR));
  FDRE \quiet_sum_reg[3] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[3]),
        .Q(quiet_sum[3]),
        .R(SR));
  FDRE \quiet_sum_reg[4] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[4]),
        .Q(quiet_sum[4]),
        .R(SR));
  FDSE \quiet_sum_reg[5] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[5]),
        .Q(quiet_sum[5]),
        .S(SR));
  FDRE \quiet_sum_reg[6] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[6]),
        .Q(quiet_sum[6]),
        .R(SR));
  FDRE \quiet_sum_reg[7] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[7]),
        .Q(quiet_sum[7]),
        .R(SR));
  FDSE \quiet_sum_reg[8] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[8]),
        .Q(quiet_sum[8]),
        .S(SR));
  FDRE \quiet_sum_reg[9] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(shadow_quiet[9]),
        .Q(quiet_sum[9]),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT2 #(
    .INIT(4'h2)) 
    s_axi_arready_INST_0
       (.I0(s_axi_aresetn),
        .I1(s_axi_rvalid_reg_0),
        .O(s_axi_arready));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'h04)) 
    s_axi_awready_INST_0
       (.I0(aw_held),
        .I1(s_axi_aresetn),
        .I2(s_axi_bvalid_reg_0),
        .O(s_axi_awready));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 s_axi_bresp3_carry
       (.CI(1'b0),
        .CO({s_axi_bresp3_carry_n_0,s_axi_bresp3_carry_n_1,s_axi_bresp3_carry_n_2,s_axi_bresp3_carry_n_3}),
        .CYINIT(1'b1),
        .DI({s_axi_bresp3_carry_i_1_n_0,s_axi_bresp3_carry_i_2_n_0,s_axi_bresp3_carry_i_3_n_0,s_axi_bresp3_carry_i_4_n_0}),
        .O(NLW_s_axi_bresp3_carry_O_UNCONNECTED[3:0]),
        .S({s_axi_bresp3_carry_i_5_n_0,s_axi_bresp3_carry_i_6_n_0,s_axi_bresp3_carry_i_7_n_0,s_axi_bresp3_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 s_axi_bresp3_carry__0
       (.CI(s_axi_bresp3_carry_n_0),
        .CO({s_axi_bresp3_carry__0_n_0,s_axi_bresp3_carry__0_n_1,s_axi_bresp3_carry__0_n_2,s_axi_bresp3_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({s_axi_bresp3_carry_i_1__0_n_0,s_axi_bresp3_carry_i_2__0_n_0,s_axi_bresp3_carry_i_3__0_n_0,s_axi_bresp3_carry_i_4__0_n_0}),
        .O(NLW_s_axi_bresp3_carry__0_O_UNCONNECTED[3:0]),
        .S({s_axi_bresp3_carry_i_5__0_n_0,s_axi_bresp3_carry_i_6__0_n_0,s_axi_bresp3_carry_i_7__0_n_0,s_axi_bresp3_carry_i_8__0_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 s_axi_bresp3_carry__1
       (.CI(s_axi_bresp3_carry__0_n_0),
        .CO({s_axi_bresp3_carry__1_n_0,s_axi_bresp3_carry__1_n_1,s_axi_bresp3_carry__1_n_2,s_axi_bresp3_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({s_axi_bresp3_carry_i_1__1_n_0,s_axi_bresp3_carry_i_2__1_n_0,s_axi_bresp3_carry_i_3__1_n_0,s_axi_bresp3_carry_i_4__1_n_0}),
        .O(NLW_s_axi_bresp3_carry__1_O_UNCONNECTED[3:0]),
        .S({s_axi_bresp3_carry_i_5__1_n_0,s_axi_bresp3_carry_i_6__1_n_0,s_axi_bresp3_carry_i_7__1_n_0,s_axi_bresp3_carry_i_8__1_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 s_axi_bresp3_carry__2
       (.CI(s_axi_bresp3_carry__1_n_0),
        .CO({s_axi_bresp3,s_axi_bresp3_carry__2_n_1,s_axi_bresp3_carry__2_n_2,s_axi_bresp3_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({s_axi_bresp3_carry_i_1__2_n_0,s_axi_bresp3_carry_i_2__2_n_0,s_axi_bresp3_carry_i_3__2_n_0,s_axi_bresp3_carry_i_4__2_n_0}),
        .O(NLW_s_axi_bresp3_carry__2_O_UNCONNECTED[3:0]),
        .S({s_axi_bresp3_carry_i_5__2_n_0,s_axi_bresp3_carry_i_6__2_n_0,s_axi_bresp3_carry_i_7__2_n_0,s_axi_bresp3_carry_i_8__2_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_1
       (.I0(\shadow_soft_reg_n_0_[7] ),
        .I1(shadow_quiet[7]),
        .I2(shadow_quiet[6]),
        .I3(\shadow_soft_reg_n_0_[6] ),
        .O(s_axi_bresp3_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_1__0
       (.I0(\shadow_soft_reg_n_0_[15] ),
        .I1(shadow_quiet[15]),
        .I2(shadow_quiet[14]),
        .I3(\shadow_soft_reg_n_0_[14] ),
        .O(s_axi_bresp3_carry_i_1__0_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_1__1
       (.I0(\shadow_soft_reg_n_0_[23] ),
        .I1(shadow_quiet[23]),
        .I2(shadow_quiet[22]),
        .I3(\shadow_soft_reg_n_0_[22] ),
        .O(s_axi_bresp3_carry_i_1__1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_1__2
       (.I0(\shadow_soft_reg_n_0_[31] ),
        .I1(shadow_quiet[31]),
        .I2(shadow_quiet[30]),
        .I3(\shadow_soft_reg_n_0_[30] ),
        .O(s_axi_bresp3_carry_i_1__2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_2
       (.I0(\shadow_soft_reg_n_0_[5] ),
        .I1(shadow_quiet[5]),
        .I2(shadow_quiet[4]),
        .I3(\shadow_soft_reg_n_0_[4] ),
        .O(s_axi_bresp3_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_2__0
       (.I0(\shadow_soft_reg_n_0_[13] ),
        .I1(shadow_quiet[13]),
        .I2(shadow_quiet[12]),
        .I3(\shadow_soft_reg_n_0_[12] ),
        .O(s_axi_bresp3_carry_i_2__0_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_2__1
       (.I0(\shadow_soft_reg_n_0_[21] ),
        .I1(shadow_quiet[21]),
        .I2(shadow_quiet[20]),
        .I3(\shadow_soft_reg_n_0_[20] ),
        .O(s_axi_bresp3_carry_i_2__1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_2__2
       (.I0(\shadow_soft_reg_n_0_[29] ),
        .I1(shadow_quiet[29]),
        .I2(shadow_quiet[28]),
        .I3(\shadow_soft_reg_n_0_[28] ),
        .O(s_axi_bresp3_carry_i_2__2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_3
       (.I0(\shadow_soft_reg_n_0_[3] ),
        .I1(shadow_quiet[3]),
        .I2(shadow_quiet[2]),
        .I3(\shadow_soft_reg_n_0_[2] ),
        .O(s_axi_bresp3_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_3__0
       (.I0(\shadow_soft_reg_n_0_[11] ),
        .I1(shadow_quiet[11]),
        .I2(shadow_quiet[10]),
        .I3(\shadow_soft_reg_n_0_[10] ),
        .O(s_axi_bresp3_carry_i_3__0_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_3__1
       (.I0(\shadow_soft_reg_n_0_[19] ),
        .I1(shadow_quiet[19]),
        .I2(shadow_quiet[18]),
        .I3(\shadow_soft_reg_n_0_[18] ),
        .O(s_axi_bresp3_carry_i_3__1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_3__2
       (.I0(\shadow_soft_reg_n_0_[27] ),
        .I1(shadow_quiet[27]),
        .I2(shadow_quiet[26]),
        .I3(\shadow_soft_reg_n_0_[26] ),
        .O(s_axi_bresp3_carry_i_3__2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_4
       (.I0(\shadow_soft_reg_n_0_[1] ),
        .I1(shadow_quiet[1]),
        .I2(shadow_quiet[0]),
        .I3(\shadow_soft_reg_n_0_[0] ),
        .O(s_axi_bresp3_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_4__0
       (.I0(\shadow_soft_reg_n_0_[9] ),
        .I1(shadow_quiet[9]),
        .I2(shadow_quiet[8]),
        .I3(\shadow_soft_reg_n_0_[8] ),
        .O(s_axi_bresp3_carry_i_4__0_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_4__1
       (.I0(\shadow_soft_reg_n_0_[17] ),
        .I1(shadow_quiet[17]),
        .I2(shadow_quiet[16]),
        .I3(\shadow_soft_reg_n_0_[16] ),
        .O(s_axi_bresp3_carry_i_4__1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    s_axi_bresp3_carry_i_4__2
       (.I0(\shadow_soft_reg_n_0_[25] ),
        .I1(shadow_quiet[25]),
        .I2(shadow_quiet[24]),
        .I3(\shadow_soft_reg_n_0_[24] ),
        .O(s_axi_bresp3_carry_i_4__2_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_5
       (.I0(shadow_quiet[7]),
        .I1(\shadow_soft_reg_n_0_[7] ),
        .I2(shadow_quiet[6]),
        .I3(\shadow_soft_reg_n_0_[6] ),
        .O(s_axi_bresp3_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_5__0
       (.I0(shadow_quiet[15]),
        .I1(\shadow_soft_reg_n_0_[15] ),
        .I2(shadow_quiet[14]),
        .I3(\shadow_soft_reg_n_0_[14] ),
        .O(s_axi_bresp3_carry_i_5__0_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_5__1
       (.I0(shadow_quiet[23]),
        .I1(\shadow_soft_reg_n_0_[23] ),
        .I2(shadow_quiet[22]),
        .I3(\shadow_soft_reg_n_0_[22] ),
        .O(s_axi_bresp3_carry_i_5__1_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_5__2
       (.I0(shadow_quiet[31]),
        .I1(\shadow_soft_reg_n_0_[31] ),
        .I2(shadow_quiet[30]),
        .I3(\shadow_soft_reg_n_0_[30] ),
        .O(s_axi_bresp3_carry_i_5__2_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_6
       (.I0(shadow_quiet[5]),
        .I1(\shadow_soft_reg_n_0_[5] ),
        .I2(shadow_quiet[4]),
        .I3(\shadow_soft_reg_n_0_[4] ),
        .O(s_axi_bresp3_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_6__0
       (.I0(shadow_quiet[13]),
        .I1(\shadow_soft_reg_n_0_[13] ),
        .I2(shadow_quiet[12]),
        .I3(\shadow_soft_reg_n_0_[12] ),
        .O(s_axi_bresp3_carry_i_6__0_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_6__1
       (.I0(shadow_quiet[21]),
        .I1(\shadow_soft_reg_n_0_[21] ),
        .I2(shadow_quiet[20]),
        .I3(\shadow_soft_reg_n_0_[20] ),
        .O(s_axi_bresp3_carry_i_6__1_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_6__2
       (.I0(shadow_quiet[29]),
        .I1(\shadow_soft_reg_n_0_[29] ),
        .I2(shadow_quiet[28]),
        .I3(\shadow_soft_reg_n_0_[28] ),
        .O(s_axi_bresp3_carry_i_6__2_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_7
       (.I0(shadow_quiet[3]),
        .I1(\shadow_soft_reg_n_0_[3] ),
        .I2(shadow_quiet[2]),
        .I3(\shadow_soft_reg_n_0_[2] ),
        .O(s_axi_bresp3_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_7__0
       (.I0(shadow_quiet[11]),
        .I1(\shadow_soft_reg_n_0_[11] ),
        .I2(shadow_quiet[10]),
        .I3(\shadow_soft_reg_n_0_[10] ),
        .O(s_axi_bresp3_carry_i_7__0_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_7__1
       (.I0(shadow_quiet[19]),
        .I1(\shadow_soft_reg_n_0_[19] ),
        .I2(shadow_quiet[18]),
        .I3(\shadow_soft_reg_n_0_[18] ),
        .O(s_axi_bresp3_carry_i_7__1_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_7__2
       (.I0(shadow_quiet[27]),
        .I1(\shadow_soft_reg_n_0_[27] ),
        .I2(shadow_quiet[26]),
        .I3(\shadow_soft_reg_n_0_[26] ),
        .O(s_axi_bresp3_carry_i_7__2_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_8
       (.I0(shadow_quiet[1]),
        .I1(\shadow_soft_reg_n_0_[1] ),
        .I2(shadow_quiet[0]),
        .I3(\shadow_soft_reg_n_0_[0] ),
        .O(s_axi_bresp3_carry_i_8_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_8__0
       (.I0(shadow_quiet[9]),
        .I1(\shadow_soft_reg_n_0_[9] ),
        .I2(shadow_quiet[8]),
        .I3(\shadow_soft_reg_n_0_[8] ),
        .O(s_axi_bresp3_carry_i_8__0_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_8__1
       (.I0(shadow_quiet[17]),
        .I1(\shadow_soft_reg_n_0_[17] ),
        .I2(shadow_quiet[16]),
        .I3(\shadow_soft_reg_n_0_[16] ),
        .O(s_axi_bresp3_carry_i_8__1_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp3_carry_i_8__2
       (.I0(shadow_quiet[25]),
        .I1(\shadow_soft_reg_n_0_[25] ),
        .I2(shadow_quiet[24]),
        .I3(\shadow_soft_reg_n_0_[24] ),
        .O(s_axi_bresp3_carry_i_8__2_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 s_axi_bresp4_carry
       (.CI(1'b0),
        .CO({s_axi_bresp4_carry_n_0,s_axi_bresp4_carry_n_1,s_axi_bresp4_carry_n_2,s_axi_bresp4_carry_n_3}),
        .CYINIT(1'b1),
        .DI({s_axi_bresp4_carry_i_1_n_0,s_axi_bresp4_carry_i_2_n_0,s_axi_bresp4_carry_i_3_n_0,s_axi_bresp4_carry_i_4_n_0}),
        .O(NLW_s_axi_bresp4_carry_O_UNCONNECTED[3:0]),
        .S({s_axi_bresp4_carry_i_5_n_0,s_axi_bresp4_carry_i_6_n_0,s_axi_bresp4_carry_i_7_n_0,s_axi_bresp4_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 s_axi_bresp4_carry__0
       (.CI(s_axi_bresp4_carry_n_0),
        .CO({s_axi_bresp4_carry__0_n_0,s_axi_bresp4_carry__0_n_1,s_axi_bresp4_carry__0_n_2,s_axi_bresp4_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({s_axi_bresp4_carry__0_i_1_n_0,s_axi_bresp4_carry__0_i_2_n_0,s_axi_bresp4_carry__0_i_3_n_0,s_axi_bresp4_carry__0_i_4_n_0}),
        .O(NLW_s_axi_bresp4_carry__0_O_UNCONNECTED[3:0]),
        .S({s_axi_bresp4_carry__0_i_5_n_0,s_axi_bresp4_carry__0_i_6_n_0,s_axi_bresp4_carry__0_i_7_n_0,s_axi_bresp4_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry__0_i_1
       (.I0(\shadow_soft_reg_n_0_[15] ),
        .I1(shadow_loud[15]),
        .I2(\shadow_soft_reg_n_0_[14] ),
        .I3(shadow_loud[14]),
        .O(s_axi_bresp4_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry__0_i_2
       (.I0(\shadow_soft_reg_n_0_[13] ),
        .I1(shadow_loud[13]),
        .I2(\shadow_soft_reg_n_0_[12] ),
        .I3(shadow_loud[12]),
        .O(s_axi_bresp4_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry__0_i_3
       (.I0(\shadow_soft_reg_n_0_[11] ),
        .I1(shadow_loud[11]),
        .I2(\shadow_soft_reg_n_0_[10] ),
        .I3(shadow_loud[10]),
        .O(s_axi_bresp4_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry__0_i_4
       (.I0(\shadow_soft_reg_n_0_[9] ),
        .I1(shadow_loud[9]),
        .I2(\shadow_soft_reg_n_0_[8] ),
        .I3(shadow_loud[8]),
        .O(s_axi_bresp4_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry__0_i_5
       (.I0(shadow_loud[15]),
        .I1(\shadow_soft_reg_n_0_[15] ),
        .I2(shadow_loud[14]),
        .I3(\shadow_soft_reg_n_0_[14] ),
        .O(s_axi_bresp4_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry__0_i_6
       (.I0(shadow_loud[13]),
        .I1(\shadow_soft_reg_n_0_[13] ),
        .I2(shadow_loud[12]),
        .I3(\shadow_soft_reg_n_0_[12] ),
        .O(s_axi_bresp4_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry__0_i_7
       (.I0(shadow_loud[11]),
        .I1(\shadow_soft_reg_n_0_[11] ),
        .I2(shadow_loud[10]),
        .I3(\shadow_soft_reg_n_0_[10] ),
        .O(s_axi_bresp4_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry__0_i_8
       (.I0(shadow_loud[9]),
        .I1(\shadow_soft_reg_n_0_[9] ),
        .I2(shadow_loud[8]),
        .I3(\shadow_soft_reg_n_0_[8] ),
        .O(s_axi_bresp4_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 s_axi_bresp4_carry__1
       (.CI(s_axi_bresp4_carry__0_n_0),
        .CO({s_axi_bresp4_carry__1_n_0,s_axi_bresp4_carry__1_n_1,s_axi_bresp4_carry__1_n_2,s_axi_bresp4_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({s_axi_bresp4_carry__1_i_1_n_0,s_axi_bresp4_carry__1_i_2_n_0,s_axi_bresp4_carry__1_i_3_n_0,s_axi_bresp4_carry__1_i_4_n_0}),
        .O(NLW_s_axi_bresp4_carry__1_O_UNCONNECTED[3:0]),
        .S({s_axi_bresp4_carry__1_i_5_n_0,s_axi_bresp4_carry__1_i_6_n_0,s_axi_bresp4_carry__1_i_7_n_0,s_axi_bresp4_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry__1_i_1
       (.I0(\shadow_soft_reg_n_0_[23] ),
        .I1(shadow_loud[23]),
        .I2(\shadow_soft_reg_n_0_[22] ),
        .I3(shadow_loud[22]),
        .O(s_axi_bresp4_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry__1_i_2
       (.I0(\shadow_soft_reg_n_0_[21] ),
        .I1(shadow_loud[21]),
        .I2(\shadow_soft_reg_n_0_[20] ),
        .I3(shadow_loud[20]),
        .O(s_axi_bresp4_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry__1_i_3
       (.I0(\shadow_soft_reg_n_0_[19] ),
        .I1(shadow_loud[19]),
        .I2(\shadow_soft_reg_n_0_[18] ),
        .I3(shadow_loud[18]),
        .O(s_axi_bresp4_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry__1_i_4
       (.I0(\shadow_soft_reg_n_0_[17] ),
        .I1(shadow_loud[17]),
        .I2(\shadow_soft_reg_n_0_[16] ),
        .I3(shadow_loud[16]),
        .O(s_axi_bresp4_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry__1_i_5
       (.I0(shadow_loud[23]),
        .I1(\shadow_soft_reg_n_0_[23] ),
        .I2(shadow_loud[22]),
        .I3(\shadow_soft_reg_n_0_[22] ),
        .O(s_axi_bresp4_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry__1_i_6
       (.I0(shadow_loud[21]),
        .I1(\shadow_soft_reg_n_0_[21] ),
        .I2(shadow_loud[20]),
        .I3(\shadow_soft_reg_n_0_[20] ),
        .O(s_axi_bresp4_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry__1_i_7
       (.I0(shadow_loud[19]),
        .I1(\shadow_soft_reg_n_0_[19] ),
        .I2(shadow_loud[18]),
        .I3(\shadow_soft_reg_n_0_[18] ),
        .O(s_axi_bresp4_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry__1_i_8
       (.I0(shadow_loud[17]),
        .I1(\shadow_soft_reg_n_0_[17] ),
        .I2(shadow_loud[16]),
        .I3(\shadow_soft_reg_n_0_[16] ),
        .O(s_axi_bresp4_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 s_axi_bresp4_carry__2
       (.CI(s_axi_bresp4_carry__1_n_0),
        .CO({s_axi_bresp4,s_axi_bresp4_carry__2_n_1,s_axi_bresp4_carry__2_n_2,s_axi_bresp4_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({s_axi_bresp4_carry__2_i_1_n_0,s_axi_bresp4_carry__2_i_2_n_0,s_axi_bresp4_carry__2_i_3_n_0,s_axi_bresp4_carry__2_i_4_n_0}),
        .O(NLW_s_axi_bresp4_carry__2_O_UNCONNECTED[3:0]),
        .S({s_axi_bresp4_carry__2_i_5_n_0,s_axi_bresp4_carry__2_i_6_n_0,s_axi_bresp4_carry__2_i_7_n_0,s_axi_bresp4_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry__2_i_1
       (.I0(\shadow_soft_reg_n_0_[31] ),
        .I1(shadow_loud[31]),
        .I2(\shadow_soft_reg_n_0_[30] ),
        .I3(shadow_loud[30]),
        .O(s_axi_bresp4_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry__2_i_2
       (.I0(\shadow_soft_reg_n_0_[29] ),
        .I1(shadow_loud[29]),
        .I2(\shadow_soft_reg_n_0_[28] ),
        .I3(shadow_loud[28]),
        .O(s_axi_bresp4_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry__2_i_3
       (.I0(\shadow_soft_reg_n_0_[27] ),
        .I1(shadow_loud[27]),
        .I2(\shadow_soft_reg_n_0_[26] ),
        .I3(shadow_loud[26]),
        .O(s_axi_bresp4_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry__2_i_4
       (.I0(\shadow_soft_reg_n_0_[25] ),
        .I1(shadow_loud[25]),
        .I2(\shadow_soft_reg_n_0_[24] ),
        .I3(shadow_loud[24]),
        .O(s_axi_bresp4_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry__2_i_5
       (.I0(shadow_loud[31]),
        .I1(\shadow_soft_reg_n_0_[31] ),
        .I2(shadow_loud[30]),
        .I3(\shadow_soft_reg_n_0_[30] ),
        .O(s_axi_bresp4_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry__2_i_6
       (.I0(shadow_loud[29]),
        .I1(\shadow_soft_reg_n_0_[29] ),
        .I2(shadow_loud[28]),
        .I3(\shadow_soft_reg_n_0_[28] ),
        .O(s_axi_bresp4_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry__2_i_7
       (.I0(shadow_loud[27]),
        .I1(\shadow_soft_reg_n_0_[27] ),
        .I2(shadow_loud[26]),
        .I3(\shadow_soft_reg_n_0_[26] ),
        .O(s_axi_bresp4_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry__2_i_8
       (.I0(shadow_loud[25]),
        .I1(\shadow_soft_reg_n_0_[25] ),
        .I2(shadow_loud[24]),
        .I3(\shadow_soft_reg_n_0_[24] ),
        .O(s_axi_bresp4_carry__2_i_8_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry_i_1
       (.I0(\shadow_soft_reg_n_0_[7] ),
        .I1(shadow_loud[7]),
        .I2(\shadow_soft_reg_n_0_[6] ),
        .I3(shadow_loud[6]),
        .O(s_axi_bresp4_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry_i_2
       (.I0(\shadow_soft_reg_n_0_[5] ),
        .I1(shadow_loud[5]),
        .I2(\shadow_soft_reg_n_0_[4] ),
        .I3(shadow_loud[4]),
        .O(s_axi_bresp4_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry_i_3
       (.I0(\shadow_soft_reg_n_0_[3] ),
        .I1(shadow_loud[3]),
        .I2(\shadow_soft_reg_n_0_[2] ),
        .I3(shadow_loud[2]),
        .O(s_axi_bresp4_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    s_axi_bresp4_carry_i_4
       (.I0(\shadow_soft_reg_n_0_[1] ),
        .I1(shadow_loud[1]),
        .I2(\shadow_soft_reg_n_0_[0] ),
        .I3(shadow_loud[0]),
        .O(s_axi_bresp4_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry_i_5
       (.I0(shadow_loud[7]),
        .I1(\shadow_soft_reg_n_0_[7] ),
        .I2(shadow_loud[6]),
        .I3(\shadow_soft_reg_n_0_[6] ),
        .O(s_axi_bresp4_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry_i_6
       (.I0(shadow_loud[5]),
        .I1(\shadow_soft_reg_n_0_[5] ),
        .I2(shadow_loud[4]),
        .I3(\shadow_soft_reg_n_0_[4] ),
        .O(s_axi_bresp4_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry_i_7
       (.I0(shadow_loud[3]),
        .I1(\shadow_soft_reg_n_0_[3] ),
        .I2(shadow_loud[2]),
        .I3(\shadow_soft_reg_n_0_[2] ),
        .O(s_axi_bresp4_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    s_axi_bresp4_carry_i_8
       (.I0(shadow_loud[1]),
        .I1(\shadow_soft_reg_n_0_[1] ),
        .I2(shadow_loud[0]),
        .I3(\shadow_soft_reg_n_0_[0] ),
        .O(s_axi_bresp4_carry_i_8_n_0));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \s_axi_bresp[1]_i_10 
       (.I0(write_data[1]),
        .I1(write_data[2]),
        .I2(write_data[0]),
        .O(\s_axi_bresp[1]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \s_axi_bresp[1]_i_11 
       (.I0(write_data[16]),
        .I1(write_data[23]),
        .I2(write_data[21]),
        .I3(write_data[28]),
        .O(\s_axi_bresp[1]_i_11_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \s_axi_bresp[1]_i_12 
       (.I0(write_data[12]),
        .I1(write_data[5]),
        .I2(write_data[31]),
        .I3(write_data[29]),
        .I4(\s_axi_bresp[1]_i_14_n_0 ),
        .O(\s_axi_bresp[1]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \s_axi_bresp[1]_i_13 
       (.I0(\s_axi_bresp[1]_i_15_n_0 ),
        .I1(\s_axi_bresp[1]_i_16_n_0 ),
        .I2(write_data[18]),
        .I3(write_data[27]),
        .I4(write_data[6]),
        .I5(write_data[7]),
        .O(\s_axi_bresp[1]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \s_axi_bresp[1]_i_14 
       (.I0(write_data[14]),
        .I1(write_data[22]),
        .I2(write_data[19]),
        .I3(write_data[26]),
        .O(\s_axi_bresp[1]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \s_axi_bresp[1]_i_15 
       (.I0(write_data[3]),
        .I1(write_data[30]),
        .I2(write_data[20]),
        .I3(write_data[13]),
        .I4(write_data[24]),
        .I5(write_data[10]),
        .O(\s_axi_bresp[1]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \s_axi_bresp[1]_i_16 
       (.I0(write_data[9]),
        .I1(write_data[25]),
        .I2(write_data[8]),
        .I3(write_data[11]),
        .O(\s_axi_bresp[1]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'hAEFFFFFFAEFF0000)) 
    \s_axi_bresp[1]_i_2 
       (.I0(\s_axi_bresp[1]_i_3_n_0 ),
        .I1(\s_axi_bresp[1]_i_4_n_0 ),
        .I2(\s_axi_bresp[1]_i_5_n_0 ),
        .I3(\s_axi_bresp[1]_i_6_n_0 ),
        .I4(aw_held09_out),
        .I5(s_axi_bresp),
        .O(\s_axi_bresp[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \s_axi_bresp[1]_i_3 
       (.I0(\s_axi_bresp[1]_i_8_n_0 ),
        .I1(write_address[9]),
        .I2(write_address[10]),
        .I3(write_address[8]),
        .I4(write_address[0]),
        .I5(write_address[1]),
        .O(\s_axi_bresp[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF00000000888A)) 
    \s_axi_bresp[1]_i_4 
       (.I0(write_address[4]),
        .I1(\s_axi_bresp[1]_i_9_n_0 ),
        .I2(\soft_sum[31]_i_3_n_0 ),
        .I3(\s_axi_bresp[1]_i_10_n_0 ),
        .I4(write_address[3]),
        .I5(write_address[2]),
        .O(\s_axi_bresp[1]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \s_axi_bresp[1]_i_5 
       (.I0(\shadow_enable[31]_i_2_n_0 ),
        .I1(write_address[4]),
        .O(\s_axi_bresp[1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h1000000000000000)) 
    \s_axi_bresp[1]_i_6 
       (.I0(write_address[0]),
        .I1(write_address[1]),
        .I2(write_strobe[0]),
        .I3(write_strobe[1]),
        .I4(write_strobe[3]),
        .I5(write_strobe[2]),
        .O(\s_axi_bresp[1]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \s_axi_bresp[1]_i_7 
       (.I0(aw_held),
        .I1(w_held_reg_n_0),
        .I2(s_axi_bvalid_reg_0),
        .O(aw_held09_out));
  LUT4 #(
    .INIT(16'hFFFD)) 
    \s_axi_bresp[1]_i_8 
       (.I0(write_address[5]),
        .I1(write_address[7]),
        .I2(write_address[11]),
        .I3(write_address[6]),
        .O(\s_axi_bresp[1]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \s_axi_bresp[1]_i_9 
       (.I0(write_data[17]),
        .I1(write_data[15]),
        .I2(write_data[4]),
        .I3(\s_axi_bresp[1]_i_11_n_0 ),
        .I4(\s_axi_bresp[1]_i_12_n_0 ),
        .I5(\s_axi_bresp[1]_i_13_n_0 ),
        .O(\s_axi_bresp[1]_i_9_n_0 ));
  FDRE \s_axi_bresp_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\s_axi_bresp[1]_i_2_n_0 ),
        .Q(s_axi_bresp),
        .R(SR));
  LUT4 #(
    .INIT(16'h7444)) 
    s_axi_bvalid_i_1
       (.I0(s_axi_bready),
        .I1(s_axi_bvalid_reg_0),
        .I2(w_held_reg_n_0),
        .I3(aw_held),
        .O(s_axi_bvalid_i_1_n_0));
  FDRE s_axi_bvalid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_bvalid_i_1_n_0),
        .Q(s_axi_bvalid_reg_0),
        .R(SR));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[0]_i_10 
       (.I0(\snapshot_reg[7] [0]),
        .I1(\snapshot_reg[6] [0]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [0]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [0]),
        .O(\s_axi_rdata[0]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[0]_i_11 
       (.I0(\snapshot_reg[11] [0]),
        .I1(\snapshot_reg[10] [0]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[9] [0]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[8] [0]),
        .O(\s_axi_rdata[0]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[0]_i_12 
       (.I0(\snapshot_reg[15] [0]),
        .I1(\snapshot_reg[14] [0]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [0]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [0]),
        .O(\s_axi_rdata[0]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[0]_i_2 
       (.I0(shadow_loud[0]),
        .I1(shadow_quiet[0]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[0] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[0] ),
        .O(\s_axi_rdata[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFAFCFC0AFA0CFC0)) 
    \s_axi_rdata[0]_i_3 
       (.I0(\ack_sequence_reg_n_0_[0] ),
        .I1(snapshot_sequence_reg[0]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\s_axi_rdata[0]_i_5_n_0 ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(snapshot_valid),
        .O(\s_axi_rdata[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8080808A808)) 
    \s_axi_rdata[0]_i_5 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\snapshot_reg[16] [0]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rdata_reg[0]_i_7_n_0 ),
        .I4(s_axi_araddr[5]),
        .I5(\s_axi_rdata_reg[0]_i_8_n_0 ),
        .O(\s_axi_rdata[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[0]_i_9 
       (.I0(\snapshot_reg[3] [0]),
        .I1(\snapshot_reg[2] [0]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[1] [0]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[0] [0]),
        .O(\s_axi_rdata[0]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[10]_i_10 
       (.I0(\snapshot_reg[7] [10]),
        .I1(\snapshot_reg[6] [10]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [10]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [10]),
        .O(\s_axi_rdata[10]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[10]_i_11 
       (.I0(\snapshot_reg[11] [10]),
        .I1(\snapshot_reg[10] [10]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[8] [10]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[10]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[10]_i_12 
       (.I0(\snapshot_reg[15] [10]),
        .I1(\snapshot_reg[14] [10]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [10]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [10]),
        .O(\s_axi_rdata[10]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFD5D5555)) 
    \s_axi_rdata[10]_i_2 
       (.I0(\s_axi_rdata[10]_i_5_n_0 ),
        .I1(snapshot_sequence_reg[10]),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(\ack_sequence_reg_n_0_[10] ),
        .I4(\s_axi_rdata[31]_i_10_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[10]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h505F3030505F3F3F)) 
    \s_axi_rdata[10]_i_3 
       (.I0(shadow_loud[10]),
        .I1(shadow_quiet[10]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[10] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[10] ),
        .O(\s_axi_rdata[10]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h575757F7F7F757F7)) 
    \s_axi_rdata[10]_i_5 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\snapshot_reg[16] [10]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rdata_reg[10]_i_7_n_0 ),
        .I4(s_axi_araddr[5]),
        .I5(\s_axi_rdata_reg[10]_i_8_n_0 ),
        .O(\s_axi_rdata[10]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hF1FD)) 
    \s_axi_rdata[10]_i_6 
       (.I0(\shadow_soft_reg_n_0_[10] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[10]),
        .O(\s_axi_rdata[10]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[10]_i_9 
       (.I0(\snapshot_reg[3] [10]),
        .I1(\snapshot_reg[2] [10]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[0] [10]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[10]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h888888888A8A888A)) 
    \s_axi_rdata[11]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[11]_i_2_n_0 ),
        .I2(\s_axi_rdata[11]_i_3_n_0 ),
        .I3(\s_axi_rdata[31]_i_4_n_0 ),
        .I4(\s_axi_rdata[11]_i_4_n_0 ),
        .I5(\s_axi_rdata[31]_i_7_n_0 ),
        .O(\s_axi_rdata[11]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[11]_i_10 
       (.I0(\snapshot_reg[7] [11]),
        .I1(\snapshot_reg[6] [11]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [11]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [11]),
        .O(\s_axi_rdata[11]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hC0C000000E020000)) 
    \s_axi_rdata[11]_i_2 
       (.I0(\shadow_soft_reg_n_0_[11] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[11]),
        .I4(\s_axi_rdata[31]_i_7_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[11]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h0000DDDF)) 
    \s_axi_rdata[11]_i_3 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\s_axi_rdata[11]_i_5_n_0 ),
        .I2(\snapshot_reg[16] [11]),
        .I3(s_axi_araddr[6]),
        .I4(\s_axi_rdata[11]_i_6_n_0 ),
        .O(\s_axi_rdata[11]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[11]_i_4 
       (.I0(shadow_loud[11]),
        .I1(shadow_quiet[11]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[11] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[11] ),
        .O(\s_axi_rdata[11]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h2EEE222200000000)) 
    \s_axi_rdata[11]_i_5 
       (.I0(\s_axi_rdata[11]_i_7_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[11]_i_8_n_0 ),
        .I3(s_axi_araddr[4]),
        .I4(\s_axi_rdata[11]_i_9_n_0 ),
        .I5(s_axi_araddr[6]),
        .O(\s_axi_rdata[11]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT5 #(
    .INIT(32'hEAEEEAAA)) 
    \s_axi_rdata[11]_i_6 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\ack_sequence_reg_n_0_[11] ),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(snapshot_sequence_reg[11]),
        .O(\s_axi_rdata[11]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h4747477777774777)) 
    \s_axi_rdata[11]_i_7 
       (.I0(\s_axi_rdata[11]_i_10_n_0 ),
        .I1(s_axi_araddr[4]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[2] [11]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[3] [11]),
        .O(\s_axi_rdata[11]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[11]_i_8 
       (.I0(\snapshot_reg[15] [11]),
        .I1(\snapshot_reg[14] [11]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [11]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [11]),
        .O(\s_axi_rdata[11]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAAEFBBEFEEEFFFEF)) 
    \s_axi_rdata[11]_i_9 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[8] [11]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[10] [11]),
        .I5(\snapshot_reg[11] [11]),
        .O(\s_axi_rdata[11]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h00200A2A00200222)) 
    \s_axi_rdata[12]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_7_n_0 ),
        .I3(\s_axi_rdata[12]_i_2_n_0 ),
        .I4(\s_axi_rdata[12]_i_3_n_0 ),
        .I5(\s_axi_rdata[12]_i_4_n_0 ),
        .O(\s_axi_rdata[12]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[12]_i_10 
       (.I0(\snapshot_reg[15] [12]),
        .I1(\snapshot_reg[14] [12]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [12]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [12]),
        .O(\s_axi_rdata[12]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'hF1FD)) 
    \s_axi_rdata[12]_i_2 
       (.I0(\shadow_soft_reg_n_0_[12] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[12]),
        .O(\s_axi_rdata[12]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000002A2AAAA)) 
    \s_axi_rdata[12]_i_3 
       (.I0(\s_axi_rdata[12]_i_5_n_0 ),
        .I1(snapshot_sequence_reg[12]),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(\ack_sequence_reg_n_0_[12] ),
        .I4(\s_axi_rdata[31]_i_10_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[12]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[12]_i_4 
       (.I0(shadow_loud[12]),
        .I1(shadow_quiet[12]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[12] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[12] ),
        .O(\s_axi_rdata[12]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h575757F7F7F757F7)) 
    \s_axi_rdata[12]_i_5 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\snapshot_reg[16] [12]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rdata[12]_i_6_n_0 ),
        .I4(s_axi_araddr[5]),
        .I5(\s_axi_rdata_reg[12]_i_7_n_0 ),
        .O(\s_axi_rdata[12]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hBBB888B888888888)) 
    \s_axi_rdata[12]_i_6 
       (.I0(\s_axi_rdata[12]_i_8_n_0 ),
        .I1(s_axi_araddr[4]),
        .I2(\snapshot_reg[2] [12]),
        .I3(s_axi_araddr[2]),
        .I4(\snapshot_reg[3] [12]),
        .I5(s_axi_araddr[3]),
        .O(\s_axi_rdata[12]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[12]_i_8 
       (.I0(\snapshot_reg[7] [12]),
        .I1(\snapshot_reg[6] [12]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [12]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [12]),
        .O(\s_axi_rdata[12]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[12]_i_9 
       (.I0(\snapshot_reg[11] [12]),
        .I1(\snapshot_reg[10] [12]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[8] [12]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[12]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h000000A2222200A2)) 
    \s_axi_rdata[13]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[13]_i_2_n_0 ),
        .I3(\s_axi_rdata[13]_i_3_n_0 ),
        .I4(\s_axi_rdata[31]_i_7_n_0 ),
        .I5(\s_axi_rdata[13]_i_4_n_0 ),
        .O(\s_axi_rdata[13]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[13]_i_10 
       (.I0(\snapshot_reg[7] [13]),
        .I1(\snapshot_reg[6] [13]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [13]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [13]),
        .O(\s_axi_rdata[13]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[13]_i_2 
       (.I0(shadow_loud[13]),
        .I1(shadow_quiet[13]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[13] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[13] ),
        .O(\s_axi_rdata[13]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h0000DDDF)) 
    \s_axi_rdata[13]_i_3 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\s_axi_rdata[13]_i_5_n_0 ),
        .I2(\snapshot_reg[16] [13]),
        .I3(s_axi_araddr[6]),
        .I4(\s_axi_rdata[13]_i_6_n_0 ),
        .O(\s_axi_rdata[13]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hF1FD)) 
    \s_axi_rdata[13]_i_4 
       (.I0(\shadow_soft_reg_n_0_[13] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[13]),
        .O(\s_axi_rdata[13]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h2EEE222200000000)) 
    \s_axi_rdata[13]_i_5 
       (.I0(\s_axi_rdata[13]_i_7_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[13]_i_8_n_0 ),
        .I3(s_axi_araddr[4]),
        .I4(\s_axi_rdata[13]_i_9_n_0 ),
        .I5(s_axi_araddr[6]),
        .O(\s_axi_rdata[13]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hEAEEEAAA)) 
    \s_axi_rdata[13]_i_6 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\ack_sequence_reg_n_0_[13] ),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(snapshot_sequence_reg[13]),
        .O(\s_axi_rdata[13]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h000057F7FFFF57F7)) 
    \s_axi_rdata[13]_i_7 
       (.I0(s_axi_araddr[3]),
        .I1(\snapshot_reg[2] [13]),
        .I2(s_axi_araddr[2]),
        .I3(\snapshot_reg[3] [13]),
        .I4(s_axi_araddr[4]),
        .I5(\s_axi_rdata[13]_i_10_n_0 ),
        .O(\s_axi_rdata[13]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[13]_i_8 
       (.I0(\snapshot_reg[15] [13]),
        .I1(\snapshot_reg[14] [13]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [13]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [13]),
        .O(\s_axi_rdata[13]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAAEFBBEFEEEFFFEF)) 
    \s_axi_rdata[13]_i_9 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[8] [13]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[10] [13]),
        .I5(\snapshot_reg[11] [13]),
        .O(\s_axi_rdata[13]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h888888888A8A888A)) 
    \s_axi_rdata[14]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[14]_i_2_n_0 ),
        .I2(\s_axi_rdata[14]_i_3_n_0 ),
        .I3(\s_axi_rdata[31]_i_4_n_0 ),
        .I4(\s_axi_rdata[14]_i_4_n_0 ),
        .I5(\s_axi_rdata[31]_i_7_n_0 ),
        .O(\s_axi_rdata[14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[14]_i_10 
       (.I0(\snapshot_reg[7] [14]),
        .I1(\snapshot_reg[6] [14]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [14]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [14]),
        .O(\s_axi_rdata[14]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hC0C000000E020000)) 
    \s_axi_rdata[14]_i_2 
       (.I0(\shadow_soft_reg_n_0_[14] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[14]),
        .I4(\s_axi_rdata[31]_i_7_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[14]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h0000DDDF)) 
    \s_axi_rdata[14]_i_3 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\s_axi_rdata[14]_i_5_n_0 ),
        .I2(\snapshot_reg[16] [14]),
        .I3(s_axi_araddr[6]),
        .I4(\s_axi_rdata[14]_i_6_n_0 ),
        .O(\s_axi_rdata[14]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[14]_i_4 
       (.I0(shadow_loud[14]),
        .I1(shadow_quiet[14]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[14] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[14] ),
        .O(\s_axi_rdata[14]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h2EEE222200000000)) 
    \s_axi_rdata[14]_i_5 
       (.I0(\s_axi_rdata[14]_i_7_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[14]_i_8_n_0 ),
        .I3(s_axi_araddr[4]),
        .I4(\s_axi_rdata[14]_i_9_n_0 ),
        .I5(s_axi_araddr[6]),
        .O(\s_axi_rdata[14]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hEAEEEAAA)) 
    \s_axi_rdata[14]_i_6 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\ack_sequence_reg_n_0_[14] ),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(snapshot_sequence_reg[14]),
        .O(\s_axi_rdata[14]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h000057F7FFFF57F7)) 
    \s_axi_rdata[14]_i_7 
       (.I0(s_axi_araddr[3]),
        .I1(\snapshot_reg[2] [14]),
        .I2(s_axi_araddr[2]),
        .I3(\snapshot_reg[3] [14]),
        .I4(s_axi_araddr[4]),
        .I5(\s_axi_rdata[14]_i_10_n_0 ),
        .O(\s_axi_rdata[14]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[14]_i_8 
       (.I0(\snapshot_reg[15] [14]),
        .I1(\snapshot_reg[14] [14]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [14]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [14]),
        .O(\s_axi_rdata[14]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAAEFBBEFEEEFFFEF)) 
    \s_axi_rdata[14]_i_9 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[8] [14]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[10] [14]),
        .I5(\snapshot_reg[11] [14]),
        .O(\s_axi_rdata[14]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h00200A2A00200222)) 
    \s_axi_rdata[15]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_7_n_0 ),
        .I3(\s_axi_rdata[15]_i_2_n_0 ),
        .I4(\s_axi_rdata[15]_i_3_n_0 ),
        .I5(\s_axi_rdata[15]_i_4_n_0 ),
        .O(\s_axi_rdata[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[15]_i_10 
       (.I0(\snapshot_reg[15] [15]),
        .I1(\snapshot_reg[14] [15]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [15]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [15]),
        .O(\s_axi_rdata[15]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'hF1FD)) 
    \s_axi_rdata[15]_i_2 
       (.I0(\shadow_soft_reg_n_0_[15] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[15]),
        .O(\s_axi_rdata[15]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000002A2AAAA)) 
    \s_axi_rdata[15]_i_3 
       (.I0(\s_axi_rdata[15]_i_5_n_0 ),
        .I1(snapshot_sequence_reg[15]),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(\ack_sequence_reg_n_0_[15] ),
        .I4(\s_axi_rdata[31]_i_10_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[15]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[15]_i_4 
       (.I0(shadow_loud[15]),
        .I1(shadow_quiet[15]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[15] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[15] ),
        .O(\s_axi_rdata[15]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h575757F7F7F757F7)) 
    \s_axi_rdata[15]_i_5 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\snapshot_reg[16] [15]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rdata[15]_i_6_n_0 ),
        .I4(s_axi_araddr[5]),
        .I5(\s_axi_rdata_reg[15]_i_7_n_0 ),
        .O(\s_axi_rdata[15]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hBBB888B888888888)) 
    \s_axi_rdata[15]_i_6 
       (.I0(\s_axi_rdata[15]_i_8_n_0 ),
        .I1(s_axi_araddr[4]),
        .I2(\snapshot_reg[2] [15]),
        .I3(s_axi_araddr[2]),
        .I4(\snapshot_reg[3] [15]),
        .I5(s_axi_araddr[3]),
        .O(\s_axi_rdata[15]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[15]_i_8 
       (.I0(\snapshot_reg[7] [15]),
        .I1(\snapshot_reg[6] [15]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [15]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [15]),
        .O(\s_axi_rdata[15]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[15]_i_9 
       (.I0(\snapshot_reg[11] [15]),
        .I1(\snapshot_reg[10] [15]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[8] [15]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[15]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFB80000)) 
    \s_axi_rdata[16]_i_1 
       (.I0(\s_axi_rdata[16]_i_2_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[16]_i_3_n_0 ),
        .I3(\s_axi_rdata[31]_i_7_n_0 ),
        .I4(\s_axi_rdata[31]_i_3_n_0 ),
        .I5(\s_axi_rdata[16]_i_4_n_0 ),
        .O(\s_axi_rdata[16]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[16]_i_10 
       (.I0(\snapshot_reg[7] [16]),
        .I1(\snapshot_reg[6] [16]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [16]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [16]),
        .O(\s_axi_rdata[16]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[16]_i_2 
       (.I0(shadow_loud[16]),
        .I1(shadow_quiet[16]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[16] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[16] ),
        .O(\s_axi_rdata[16]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF5400)) 
    \s_axi_rdata[16]_i_3 
       (.I0(\s_axi_rdata[16]_i_5_n_0 ),
        .I1(\snapshot_reg[16] [16]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rresp[1]_i_3_n_0 ),
        .I4(\s_axi_rdata[16]_i_6_n_0 ),
        .O(\s_axi_rdata[16]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000FF00FF001D00)) 
    \s_axi_rdata[16]_i_4 
       (.I0(\shadow_soft_reg_n_0_[16] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(config_epoch_reg[16]),
        .I3(\s_axi_rdata[31]_i_7_n_0 ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[16]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h2EEE222200000000)) 
    \s_axi_rdata[16]_i_5 
       (.I0(\s_axi_rdata[16]_i_7_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[16]_i_8_n_0 ),
        .I3(s_axi_araddr[4]),
        .I4(\s_axi_rdata[16]_i_9_n_0 ),
        .I5(s_axi_araddr[6]),
        .O(\s_axi_rdata[16]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \s_axi_rdata[16]_i_6 
       (.I0(snapshot_sequence_reg[16]),
        .I1(\s_axi_rdata[31]_i_11_n_0 ),
        .I2(\ack_sequence_reg_n_0_[16] ),
        .I3(\s_axi_rdata[31]_i_10_n_0 ),
        .O(\s_axi_rdata[16]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h4747477777774777)) 
    \s_axi_rdata[16]_i_7 
       (.I0(\s_axi_rdata[16]_i_10_n_0 ),
        .I1(s_axi_araddr[4]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[2] [16]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[3] [16]),
        .O(\s_axi_rdata[16]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[16]_i_8 
       (.I0(\snapshot_reg[15] [16]),
        .I1(\snapshot_reg[14] [16]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [16]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [16]),
        .O(\s_axi_rdata[16]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAAEFBBEFEEEFFFEF)) 
    \s_axi_rdata[16]_i_9 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[8] [16]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[10] [16]),
        .I5(\snapshot_reg[11] [16]),
        .O(\s_axi_rdata[16]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \s_axi_rdata[17]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[17]_i_2_n_0 ),
        .I2(\s_axi_rdata[31]_i_7_n_0 ),
        .I3(\s_axi_rdata[17]_i_3_n_0 ),
        .I4(\s_axi_rdata[31]_i_4_n_0 ),
        .I5(\s_axi_rdata[17]_i_4_n_0 ),
        .O(\s_axi_rdata[17]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[17]_i_10 
       (.I0(\snapshot_reg[15] [17]),
        .I1(\snapshot_reg[14] [17]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [17]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [17]),
        .O(\s_axi_rdata[17]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hC0C000000E020000)) 
    \s_axi_rdata[17]_i_2 
       (.I0(\shadow_soft_reg_n_0_[17] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[17]),
        .I4(\s_axi_rdata[31]_i_7_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[17]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT5 #(
    .INIT(32'h8A80FFFF)) 
    \s_axi_rdata[17]_i_3 
       (.I0(\s_axi_rdata[31]_i_10_n_0 ),
        .I1(\ack_sequence_reg_n_0_[17] ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(snapshot_sequence_reg[17]),
        .I4(\s_axi_rdata[17]_i_5_n_0 ),
        .O(\s_axi_rdata[17]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[17]_i_4 
       (.I0(shadow_loud[17]),
        .I1(shadow_quiet[17]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[17] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[17] ),
        .O(\s_axi_rdata[17]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h575757F7F7F757F7)) 
    \s_axi_rdata[17]_i_5 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\snapshot_reg[16] [17]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rdata[17]_i_6_n_0 ),
        .I4(s_axi_araddr[5]),
        .I5(\s_axi_rdata_reg[17]_i_7_n_0 ),
        .O(\s_axi_rdata[17]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hBBB888B888888888)) 
    \s_axi_rdata[17]_i_6 
       (.I0(\s_axi_rdata[17]_i_8_n_0 ),
        .I1(s_axi_araddr[4]),
        .I2(\snapshot_reg[2] [17]),
        .I3(s_axi_araddr[2]),
        .I4(\snapshot_reg[3] [17]),
        .I5(s_axi_araddr[3]),
        .O(\s_axi_rdata[17]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[17]_i_8 
       (.I0(\snapshot_reg[7] [17]),
        .I1(\snapshot_reg[6] [17]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [17]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [17]),
        .O(\s_axi_rdata[17]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[17]_i_9 
       (.I0(\snapshot_reg[11] [17]),
        .I1(\snapshot_reg[10] [17]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[8] [17]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[17]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFB80000)) 
    \s_axi_rdata[18]_i_1 
       (.I0(\s_axi_rdata[18]_i_2_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[18]_i_3_n_0 ),
        .I3(\s_axi_rdata[31]_i_7_n_0 ),
        .I4(\s_axi_rdata[31]_i_3_n_0 ),
        .I5(\s_axi_rdata[18]_i_4_n_0 ),
        .O(\s_axi_rdata[18]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[18]_i_10 
       (.I0(\snapshot_reg[7] [18]),
        .I1(\snapshot_reg[6] [18]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [18]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [18]),
        .O(\s_axi_rdata[18]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[18]_i_2 
       (.I0(shadow_loud[18]),
        .I1(shadow_quiet[18]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[18] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[18] ),
        .O(\s_axi_rdata[18]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF5400)) 
    \s_axi_rdata[18]_i_3 
       (.I0(\s_axi_rdata[18]_i_5_n_0 ),
        .I1(\snapshot_reg[16] [18]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rresp[1]_i_3_n_0 ),
        .I4(\s_axi_rdata[18]_i_6_n_0 ),
        .O(\s_axi_rdata[18]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0A0A0A0AAA02AAA2)) 
    \s_axi_rdata[18]_i_4 
       (.I0(\s_axi_rdata[31]_i_7_n_0 ),
        .I1(\shadow_soft_reg_n_0_[18] ),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(config_epoch_reg[18]),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[18]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h2EEE222200000000)) 
    \s_axi_rdata[18]_i_5 
       (.I0(\s_axi_rdata[18]_i_7_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[18]_i_8_n_0 ),
        .I3(s_axi_araddr[4]),
        .I4(\s_axi_rdata[18]_i_9_n_0 ),
        .I5(s_axi_araddr[6]),
        .O(\s_axi_rdata[18]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \s_axi_rdata[18]_i_6 
       (.I0(snapshot_sequence_reg[18]),
        .I1(\s_axi_rdata[31]_i_11_n_0 ),
        .I2(\ack_sequence_reg_n_0_[18] ),
        .I3(\s_axi_rdata[31]_i_10_n_0 ),
        .O(\s_axi_rdata[18]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h000057F7FFFF57F7)) 
    \s_axi_rdata[18]_i_7 
       (.I0(s_axi_araddr[3]),
        .I1(\snapshot_reg[2] [18]),
        .I2(s_axi_araddr[2]),
        .I3(\snapshot_reg[3] [18]),
        .I4(s_axi_araddr[4]),
        .I5(\s_axi_rdata[18]_i_10_n_0 ),
        .O(\s_axi_rdata[18]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[18]_i_8 
       (.I0(\snapshot_reg[15] [18]),
        .I1(\snapshot_reg[14] [18]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [18]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [18]),
        .O(\s_axi_rdata[18]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAAEFBBEFEEEFFFEF)) 
    \s_axi_rdata[18]_i_9 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[8] [18]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[10] [18]),
        .I5(\snapshot_reg[11] [18]),
        .O(\s_axi_rdata[18]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFB80000)) 
    \s_axi_rdata[19]_i_1 
       (.I0(\s_axi_rdata[19]_i_2_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[19]_i_3_n_0 ),
        .I3(\s_axi_rdata[31]_i_7_n_0 ),
        .I4(\s_axi_rdata[31]_i_3_n_0 ),
        .I5(\s_axi_rdata[19]_i_4_n_0 ),
        .O(\s_axi_rdata[19]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[19]_i_10 
       (.I0(\snapshot_reg[7] [19]),
        .I1(\snapshot_reg[6] [19]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [19]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [19]),
        .O(\s_axi_rdata[19]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[19]_i_2 
       (.I0(shadow_loud[19]),
        .I1(shadow_quiet[19]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[19] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[19] ),
        .O(\s_axi_rdata[19]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF5400)) 
    \s_axi_rdata[19]_i_3 
       (.I0(\s_axi_rdata[19]_i_5_n_0 ),
        .I1(\snapshot_reg[16] [19]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rresp[1]_i_3_n_0 ),
        .I4(\s_axi_rdata[19]_i_6_n_0 ),
        .O(\s_axi_rdata[19]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0A0A0A0AAA02AAA2)) 
    \s_axi_rdata[19]_i_4 
       (.I0(\s_axi_rdata[31]_i_7_n_0 ),
        .I1(\shadow_soft_reg_n_0_[19] ),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(config_epoch_reg[19]),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[19]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h2EEE222200000000)) 
    \s_axi_rdata[19]_i_5 
       (.I0(\s_axi_rdata[19]_i_7_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[19]_i_8_n_0 ),
        .I3(s_axi_araddr[4]),
        .I4(\s_axi_rdata[19]_i_9_n_0 ),
        .I5(s_axi_araddr[6]),
        .O(\s_axi_rdata[19]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \s_axi_rdata[19]_i_6 
       (.I0(snapshot_sequence_reg[19]),
        .I1(\s_axi_rdata[31]_i_11_n_0 ),
        .I2(\ack_sequence_reg_n_0_[19] ),
        .I3(\s_axi_rdata[31]_i_10_n_0 ),
        .O(\s_axi_rdata[19]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h000057F7FFFF57F7)) 
    \s_axi_rdata[19]_i_7 
       (.I0(s_axi_araddr[3]),
        .I1(\snapshot_reg[2] [19]),
        .I2(s_axi_araddr[2]),
        .I3(\snapshot_reg[3] [19]),
        .I4(s_axi_araddr[4]),
        .I5(\s_axi_rdata[19]_i_10_n_0 ),
        .O(\s_axi_rdata[19]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[19]_i_8 
       (.I0(\snapshot_reg[15] [19]),
        .I1(\snapshot_reg[14] [19]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [19]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [19]),
        .O(\s_axi_rdata[19]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAAEFBBEFEEEFFFEF)) 
    \s_axi_rdata[19]_i_9 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[8] [19]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[10] [19]),
        .I5(\snapshot_reg[11] [19]),
        .O(\s_axi_rdata[19]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[1]_i_10 
       (.I0(\snapshot_reg[15] [1]),
        .I1(\snapshot_reg[14] [1]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [1]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [1]),
        .O(\s_axi_rdata[1]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[1]_i_11 
       (.I0(\snapshot_reg[3] [1]),
        .I1(\snapshot_reg[2] [1]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[1] [1]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[0] [1]),
        .O(\s_axi_rdata[1]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[1]_i_12 
       (.I0(\snapshot_reg[7] [1]),
        .I1(\snapshot_reg[6] [1]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [1]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [1]),
        .O(\s_axi_rdata[1]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF8A808A808A80)) 
    \s_axi_rdata[1]_i_3 
       (.I0(\s_axi_rdata[31]_i_10_n_0 ),
        .I1(\ack_sequence_reg_n_0_[1] ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(snapshot_sequence_reg[1]),
        .I4(\s_axi_rdata[1]_i_6_n_0 ),
        .I5(\s_axi_rresp[1]_i_3_n_0 ),
        .O(\s_axi_rdata[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[1]_i_4 
       (.I0(shadow_loud[1]),
        .I1(shadow_quiet[1]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[1] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[1] ),
        .O(\s_axi_rdata[1]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \s_axi_rdata[1]_i_6 
       (.I0(\s_axi_rdata_reg[1]_i_7_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata_reg[1]_i_8_n_0 ),
        .I3(s_axi_araddr[6]),
        .I4(\snapshot_reg[16] [1]),
        .O(\s_axi_rdata[1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[1]_i_9 
       (.I0(\snapshot_reg[11] [1]),
        .I1(\snapshot_reg[10] [1]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[9] [1]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[8] [1]),
        .O(\s_axi_rdata[1]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h00200A2A00200222)) 
    \s_axi_rdata[20]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_7_n_0 ),
        .I3(\s_axi_rdata[20]_i_2_n_0 ),
        .I4(\s_axi_rdata[20]_i_3_n_0 ),
        .I5(\s_axi_rdata[20]_i_4_n_0 ),
        .O(\s_axi_rdata[20]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF35FF)) 
    \s_axi_rdata[20]_i_10 
       (.I0(\snapshot_reg[2] [20]),
        .I1(\snapshot_reg[3] [20]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .O(\s_axi_rdata[20]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'hF1FD)) 
    \s_axi_rdata[20]_i_2 
       (.I0(\shadow_soft_reg_n_0_[20] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[20]),
        .O(\s_axi_rdata[20]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h000047FF)) 
    \s_axi_rdata[20]_i_3 
       (.I0(\s_axi_rdata[20]_i_5_n_0 ),
        .I1(s_axi_araddr[6]),
        .I2(\snapshot_reg[16] [20]),
        .I3(\s_axi_rresp[1]_i_3_n_0 ),
        .I4(\s_axi_rdata[20]_i_6_n_0 ),
        .O(\s_axi_rdata[20]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[20]_i_4 
       (.I0(shadow_loud[20]),
        .I1(shadow_quiet[20]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[20] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[20] ),
        .O(\s_axi_rdata[20]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hBF30B030BF3FBF3F)) 
    \s_axi_rdata[20]_i_5 
       (.I0(\s_axi_rdata[20]_i_7_n_0 ),
        .I1(\s_axi_rdata[20]_i_8_n_0 ),
        .I2(s_axi_araddr[5]),
        .I3(s_axi_araddr[4]),
        .I4(\s_axi_rdata[20]_i_9_n_0 ),
        .I5(\s_axi_rdata[20]_i_10_n_0 ),
        .O(\s_axi_rdata[20]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hEAEEEAAA)) 
    \s_axi_rdata[20]_i_6 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\ack_sequence_reg_n_0_[20] ),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(snapshot_sequence_reg[20]),
        .O(\s_axi_rdata[20]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[20]_i_7 
       (.I0(\snapshot_reg[15] [20]),
        .I1(\snapshot_reg[14] [20]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [20]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [20]),
        .O(\s_axi_rdata[20]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAAEFBBEFEEEFFFEF)) 
    \s_axi_rdata[20]_i_8 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[8] [20]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[10] [20]),
        .I5(\snapshot_reg[11] [20]),
        .O(\s_axi_rdata[20]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[20]_i_9 
       (.I0(\snapshot_reg[7] [20]),
        .I1(\snapshot_reg[6] [20]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [20]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [20]),
        .O(\s_axi_rdata[20]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h00200A2A00200222)) 
    \s_axi_rdata[21]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_7_n_0 ),
        .I3(\s_axi_rdata[21]_i_2_n_0 ),
        .I4(\s_axi_rdata[21]_i_3_n_0 ),
        .I5(\s_axi_rdata[21]_i_4_n_0 ),
        .O(\s_axi_rdata[21]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[21]_i_10 
       (.I0(\snapshot_reg[7] [21]),
        .I1(\snapshot_reg[6] [21]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [21]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [21]),
        .O(\s_axi_rdata[21]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'hF1FD)) 
    \s_axi_rdata[21]_i_2 
       (.I0(\shadow_soft_reg_n_0_[21] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[21]),
        .O(\s_axi_rdata[21]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h0000DDDF)) 
    \s_axi_rdata[21]_i_3 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\s_axi_rdata[21]_i_5_n_0 ),
        .I2(\snapshot_reg[16] [21]),
        .I3(s_axi_araddr[6]),
        .I4(\s_axi_rdata[21]_i_6_n_0 ),
        .O(\s_axi_rdata[21]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[21]_i_4 
       (.I0(shadow_loud[21]),
        .I1(shadow_quiet[21]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[21] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[21] ),
        .O(\s_axi_rdata[21]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h2EEE222200000000)) 
    \s_axi_rdata[21]_i_5 
       (.I0(\s_axi_rdata[21]_i_7_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[21]_i_8_n_0 ),
        .I3(s_axi_araddr[4]),
        .I4(\s_axi_rdata[21]_i_9_n_0 ),
        .I5(s_axi_araddr[6]),
        .O(\s_axi_rdata[21]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hEAEEEAAA)) 
    \s_axi_rdata[21]_i_6 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\ack_sequence_reg_n_0_[21] ),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(snapshot_sequence_reg[21]),
        .O(\s_axi_rdata[21]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h000057F7FFFF57F7)) 
    \s_axi_rdata[21]_i_7 
       (.I0(s_axi_araddr[3]),
        .I1(\snapshot_reg[2] [21]),
        .I2(s_axi_araddr[2]),
        .I3(\snapshot_reg[3] [21]),
        .I4(s_axi_araddr[4]),
        .I5(\s_axi_rdata[21]_i_10_n_0 ),
        .O(\s_axi_rdata[21]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[21]_i_8 
       (.I0(\snapshot_reg[15] [21]),
        .I1(\snapshot_reg[14] [21]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [21]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [21]),
        .O(\s_axi_rdata[21]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAAEFBBEFEEEFFFEF)) 
    \s_axi_rdata[21]_i_9 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[8] [21]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[10] [21]),
        .I5(\snapshot_reg[11] [21]),
        .O(\s_axi_rdata[21]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h888888888A8A888A)) 
    \s_axi_rdata[22]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[22]_i_2_n_0 ),
        .I2(\s_axi_rdata[22]_i_3_n_0 ),
        .I3(\s_axi_rdata[31]_i_4_n_0 ),
        .I4(\s_axi_rdata[22]_i_4_n_0 ),
        .I5(\s_axi_rdata[31]_i_7_n_0 ),
        .O(\s_axi_rdata[22]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[22]_i_10 
       (.I0(\snapshot_reg[15] [22]),
        .I1(\snapshot_reg[14] [22]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [22]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [22]),
        .O(\s_axi_rdata[22]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hC0C000000E020000)) 
    \s_axi_rdata[22]_i_2 
       (.I0(\shadow_soft_reg_n_0_[22] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[22]),
        .I4(\s_axi_rdata[31]_i_7_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[22]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000002A2AAAA)) 
    \s_axi_rdata[22]_i_3 
       (.I0(\s_axi_rdata[22]_i_5_n_0 ),
        .I1(snapshot_sequence_reg[22]),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(\ack_sequence_reg_n_0_[22] ),
        .I4(\s_axi_rdata[31]_i_10_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[22]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[22]_i_4 
       (.I0(shadow_loud[22]),
        .I1(shadow_quiet[22]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[22] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[22] ),
        .O(\s_axi_rdata[22]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h575757F7F7F757F7)) 
    \s_axi_rdata[22]_i_5 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\snapshot_reg[16] [22]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rdata[22]_i_6_n_0 ),
        .I4(s_axi_araddr[5]),
        .I5(\s_axi_rdata_reg[22]_i_7_n_0 ),
        .O(\s_axi_rdata[22]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hBBB888B888888888)) 
    \s_axi_rdata[22]_i_6 
       (.I0(\s_axi_rdata[22]_i_8_n_0 ),
        .I1(s_axi_araddr[4]),
        .I2(\snapshot_reg[2] [22]),
        .I3(s_axi_araddr[2]),
        .I4(\snapshot_reg[3] [22]),
        .I5(s_axi_araddr[3]),
        .O(\s_axi_rdata[22]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[22]_i_8 
       (.I0(\snapshot_reg[7] [22]),
        .I1(\snapshot_reg[6] [22]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [22]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [22]),
        .O(\s_axi_rdata[22]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[22]_i_9 
       (.I0(\snapshot_reg[11] [22]),
        .I1(\snapshot_reg[10] [22]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[8] [22]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[22]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h000000A2222200A2)) 
    \s_axi_rdata[23]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[23]_i_2_n_0 ),
        .I3(\s_axi_rdata[23]_i_3_n_0 ),
        .I4(\s_axi_rdata[31]_i_7_n_0 ),
        .I5(\s_axi_rdata[23]_i_4_n_0 ),
        .O(\s_axi_rdata[23]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF35FF)) 
    \s_axi_rdata[23]_i_10 
       (.I0(\snapshot_reg[2] [23]),
        .I1(\snapshot_reg[3] [23]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .O(\s_axi_rdata[23]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[23]_i_2 
       (.I0(shadow_loud[23]),
        .I1(shadow_quiet[23]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[23] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[23] ),
        .O(\s_axi_rdata[23]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h000047FF)) 
    \s_axi_rdata[23]_i_3 
       (.I0(\s_axi_rdata[23]_i_5_n_0 ),
        .I1(s_axi_araddr[6]),
        .I2(\snapshot_reg[16] [23]),
        .I3(\s_axi_rresp[1]_i_3_n_0 ),
        .I4(\s_axi_rdata[23]_i_6_n_0 ),
        .O(\s_axi_rdata[23]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hF1FD)) 
    \s_axi_rdata[23]_i_4 
       (.I0(\shadow_soft_reg_n_0_[23] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[23]),
        .O(\s_axi_rdata[23]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hBF30B030BF3FBF3F)) 
    \s_axi_rdata[23]_i_5 
       (.I0(\s_axi_rdata[23]_i_7_n_0 ),
        .I1(\s_axi_rdata[23]_i_8_n_0 ),
        .I2(s_axi_araddr[5]),
        .I3(s_axi_araddr[4]),
        .I4(\s_axi_rdata[23]_i_9_n_0 ),
        .I5(\s_axi_rdata[23]_i_10_n_0 ),
        .O(\s_axi_rdata[23]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hEAEEEAAA)) 
    \s_axi_rdata[23]_i_6 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\ack_sequence_reg_n_0_[23] ),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(snapshot_sequence_reg[23]),
        .O(\s_axi_rdata[23]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[23]_i_7 
       (.I0(\snapshot_reg[15] [23]),
        .I1(\snapshot_reg[14] [23]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [23]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [23]),
        .O(\s_axi_rdata[23]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAAEFBBEFEEEFFFEF)) 
    \s_axi_rdata[23]_i_8 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[8] [23]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[10] [23]),
        .I5(\snapshot_reg[11] [23]),
        .O(\s_axi_rdata[23]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[23]_i_9 
       (.I0(\snapshot_reg[7] [23]),
        .I1(\snapshot_reg[6] [23]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [23]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [23]),
        .O(\s_axi_rdata[23]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h00200A2A00200222)) 
    \s_axi_rdata[24]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_7_n_0 ),
        .I3(\s_axi_rdata[24]_i_2_n_0 ),
        .I4(\s_axi_rdata[24]_i_3_n_0 ),
        .I5(\s_axi_rdata[24]_i_4_n_0 ),
        .O(\s_axi_rdata[24]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[24]_i_10 
       (.I0(\snapshot_reg[7] [24]),
        .I1(\snapshot_reg[6] [24]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [24]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [24]),
        .O(\s_axi_rdata[24]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'hF1FD)) 
    \s_axi_rdata[24]_i_2 
       (.I0(\shadow_soft_reg_n_0_[24] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[24]),
        .O(\s_axi_rdata[24]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h0000DDDF)) 
    \s_axi_rdata[24]_i_3 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\s_axi_rdata[24]_i_5_n_0 ),
        .I2(\snapshot_reg[16] [24]),
        .I3(s_axi_araddr[6]),
        .I4(\s_axi_rdata[24]_i_6_n_0 ),
        .O(\s_axi_rdata[24]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[24]_i_4 
       (.I0(shadow_loud[24]),
        .I1(shadow_quiet[24]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[24] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[24] ),
        .O(\s_axi_rdata[24]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h2EEE222200000000)) 
    \s_axi_rdata[24]_i_5 
       (.I0(\s_axi_rdata[24]_i_7_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[24]_i_8_n_0 ),
        .I3(s_axi_araddr[4]),
        .I4(\s_axi_rdata[24]_i_9_n_0 ),
        .I5(s_axi_araddr[6]),
        .O(\s_axi_rdata[24]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hEAEEEAAA)) 
    \s_axi_rdata[24]_i_6 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\ack_sequence_reg_n_0_[24] ),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(snapshot_sequence_reg[24]),
        .O(\s_axi_rdata[24]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h4747477777774777)) 
    \s_axi_rdata[24]_i_7 
       (.I0(\s_axi_rdata[24]_i_10_n_0 ),
        .I1(s_axi_araddr[4]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[2] [24]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[3] [24]),
        .O(\s_axi_rdata[24]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[24]_i_8 
       (.I0(\snapshot_reg[15] [24]),
        .I1(\snapshot_reg[14] [24]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [24]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [24]),
        .O(\s_axi_rdata[24]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAAEFBBEFEEEFFFEF)) 
    \s_axi_rdata[24]_i_9 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[8] [24]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[10] [24]),
        .I5(\snapshot_reg[11] [24]),
        .O(\s_axi_rdata[24]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \s_axi_rdata[25]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[25]_i_2_n_0 ),
        .I2(\s_axi_rdata[31]_i_7_n_0 ),
        .I3(\s_axi_rdata[25]_i_3_n_0 ),
        .I4(\s_axi_rdata[31]_i_4_n_0 ),
        .I5(\s_axi_rdata[25]_i_4_n_0 ),
        .O(\s_axi_rdata[25]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h0000B800)) 
    \s_axi_rdata[25]_i_10 
       (.I0(\snapshot_reg[3] [25]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[2] [25]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .O(\s_axi_rdata[25]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hC0C000000E020000)) 
    \s_axi_rdata[25]_i_2 
       (.I0(\shadow_soft_reg_n_0_[25] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[25]),
        .I4(\s_axi_rdata[31]_i_7_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[25]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h8A80FFFF)) 
    \s_axi_rdata[25]_i_3 
       (.I0(\s_axi_rdata[31]_i_10_n_0 ),
        .I1(\ack_sequence_reg_n_0_[25] ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(snapshot_sequence_reg[25]),
        .I4(\s_axi_rdata[25]_i_5_n_0 ),
        .O(\s_axi_rdata[25]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[25]_i_4 
       (.I0(shadow_loud[25]),
        .I1(shadow_quiet[25]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[25] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[25] ),
        .O(\s_axi_rdata[25]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hB1FF)) 
    \s_axi_rdata[25]_i_5 
       (.I0(s_axi_araddr[6]),
        .I1(\snapshot_reg[16] [25]),
        .I2(\s_axi_rdata[25]_i_6_n_0 ),
        .I3(\s_axi_rresp[1]_i_3_n_0 ),
        .O(\s_axi_rdata[25]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h2020A0A0202FAFAF)) 
    \s_axi_rdata[25]_i_6 
       (.I0(\s_axi_rdata[25]_i_7_n_0 ),
        .I1(\s_axi_rdata[25]_i_8_n_0 ),
        .I2(s_axi_araddr[5]),
        .I3(\s_axi_rdata[25]_i_9_n_0 ),
        .I4(s_axi_araddr[4]),
        .I5(\s_axi_rdata[25]_i_10_n_0 ),
        .O(\s_axi_rdata[25]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAAEFBBEFEEEFFFEF)) 
    \s_axi_rdata[25]_i_7 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[8] [25]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[10] [25]),
        .I5(\snapshot_reg[11] [25]),
        .O(\s_axi_rdata[25]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[25]_i_8 
       (.I0(\snapshot_reg[15] [25]),
        .I1(\snapshot_reg[14] [25]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [25]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [25]),
        .O(\s_axi_rdata[25]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[25]_i_9 
       (.I0(\snapshot_reg[7] [25]),
        .I1(\snapshot_reg[6] [25]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [25]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [25]),
        .O(\s_axi_rdata[25]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h888888888A8A888A)) 
    \s_axi_rdata[26]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[26]_i_2_n_0 ),
        .I2(\s_axi_rdata[26]_i_3_n_0 ),
        .I3(\s_axi_rdata[31]_i_4_n_0 ),
        .I4(\s_axi_rdata[26]_i_4_n_0 ),
        .I5(\s_axi_rdata[31]_i_7_n_0 ),
        .O(\s_axi_rdata[26]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[26]_i_10 
       (.I0(\snapshot_reg[15] [26]),
        .I1(\snapshot_reg[14] [26]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [26]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [26]),
        .O(\s_axi_rdata[26]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hC0C000000E020000)) 
    \s_axi_rdata[26]_i_2 
       (.I0(\shadow_soft_reg_n_0_[26] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[26]),
        .I4(\s_axi_rdata[31]_i_7_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[26]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000002A2AAAA)) 
    \s_axi_rdata[26]_i_3 
       (.I0(\s_axi_rdata[26]_i_5_n_0 ),
        .I1(snapshot_sequence_reg[26]),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(\ack_sequence_reg_n_0_[26] ),
        .I4(\s_axi_rdata[31]_i_10_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[26]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[26]_i_4 
       (.I0(shadow_loud[26]),
        .I1(shadow_quiet[26]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[26] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[26] ),
        .O(\s_axi_rdata[26]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h575757F7F7F757F7)) 
    \s_axi_rdata[26]_i_5 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\snapshot_reg[16] [26]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rdata[26]_i_6_n_0 ),
        .I4(s_axi_araddr[5]),
        .I5(\s_axi_rdata_reg[26]_i_7_n_0 ),
        .O(\s_axi_rdata[26]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hBBB888B888888888)) 
    \s_axi_rdata[26]_i_6 
       (.I0(\s_axi_rdata[26]_i_8_n_0 ),
        .I1(s_axi_araddr[4]),
        .I2(\snapshot_reg[2] [26]),
        .I3(s_axi_araddr[2]),
        .I4(\snapshot_reg[3] [26]),
        .I5(s_axi_araddr[3]),
        .O(\s_axi_rdata[26]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[26]_i_8 
       (.I0(\snapshot_reg[7] [26]),
        .I1(\snapshot_reg[6] [26]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [26]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [26]),
        .O(\s_axi_rdata[26]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[26]_i_9 
       (.I0(\snapshot_reg[11] [26]),
        .I1(\snapshot_reg[10] [26]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[8] [26]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[26]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h00200A2A00200222)) 
    \s_axi_rdata[27]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_7_n_0 ),
        .I3(\s_axi_rdata[27]_i_2_n_0 ),
        .I4(\s_axi_rdata[27]_i_3_n_0 ),
        .I5(\s_axi_rdata[27]_i_4_n_0 ),
        .O(\s_axi_rdata[27]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[27]_i_10 
       (.I0(\snapshot_reg[7] [27]),
        .I1(\snapshot_reg[6] [27]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [27]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [27]),
        .O(\s_axi_rdata[27]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'hF1FD)) 
    \s_axi_rdata[27]_i_2 
       (.I0(\shadow_soft_reg_n_0_[27] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[27]),
        .O(\s_axi_rdata[27]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h0000DDDF)) 
    \s_axi_rdata[27]_i_3 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\s_axi_rdata[27]_i_5_n_0 ),
        .I2(\snapshot_reg[16] [27]),
        .I3(s_axi_araddr[6]),
        .I4(\s_axi_rdata[27]_i_6_n_0 ),
        .O(\s_axi_rdata[27]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[27]_i_4 
       (.I0(shadow_loud[27]),
        .I1(shadow_quiet[27]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[27] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[27] ),
        .O(\s_axi_rdata[27]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h2EEE222200000000)) 
    \s_axi_rdata[27]_i_5 
       (.I0(\s_axi_rdata[27]_i_7_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[27]_i_8_n_0 ),
        .I3(s_axi_araddr[4]),
        .I4(\s_axi_rdata[27]_i_9_n_0 ),
        .I5(s_axi_araddr[6]),
        .O(\s_axi_rdata[27]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hFECCCECC)) 
    \s_axi_rdata[27]_i_6 
       (.I0(snapshot_sequence_reg[27]),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(\s_axi_rdata[31]_i_10_n_0 ),
        .I4(\ack_sequence_reg_n_0_[27] ),
        .O(\s_axi_rdata[27]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h000057F7FFFF57F7)) 
    \s_axi_rdata[27]_i_7 
       (.I0(s_axi_araddr[3]),
        .I1(\snapshot_reg[2] [27]),
        .I2(s_axi_araddr[2]),
        .I3(\snapshot_reg[3] [27]),
        .I4(s_axi_araddr[4]),
        .I5(\s_axi_rdata[27]_i_10_n_0 ),
        .O(\s_axi_rdata[27]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[27]_i_8 
       (.I0(\snapshot_reg[15] [27]),
        .I1(\snapshot_reg[14] [27]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [27]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [27]),
        .O(\s_axi_rdata[27]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAAEFBBEFEEEFFFEF)) 
    \s_axi_rdata[27]_i_9 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[8] [27]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[10] [27]),
        .I5(\snapshot_reg[11] [27]),
        .O(\s_axi_rdata[27]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h00008808AAAAAAAA)) 
    \s_axi_rdata[28]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[28]_i_2_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(\s_axi_rdata[28]_i_3_n_0 ),
        .I4(\s_axi_rdata[31]_i_7_n_0 ),
        .I5(\s_axi_rdata[28]_i_4_n_0 ),
        .O(\s_axi_rdata[28]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[28]_i_10 
       (.I0(\snapshot_reg[15] [28]),
        .I1(\snapshot_reg[14] [28]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [28]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [28]),
        .O(\s_axi_rdata[28]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFEAEAAAA)) 
    \s_axi_rdata[28]_i_2 
       (.I0(\s_axi_rdata[28]_i_5_n_0 ),
        .I1(snapshot_sequence_reg[28]),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(\ack_sequence_reg_n_0_[28] ),
        .I4(\s_axi_rdata[31]_i_10_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[28]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[28]_i_3 
       (.I0(shadow_loud[28]),
        .I1(shadow_quiet[28]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[28] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[28] ),
        .O(\s_axi_rdata[28]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0FFFFFFFFFFF3F5F)) 
    \s_axi_rdata[28]_i_4 
       (.I0(\shadow_soft_reg_n_0_[28] ),
        .I1(config_epoch_reg[28]),
        .I2(\s_axi_rdata[31]_i_7_n_0 ),
        .I3(\s_axi_rdata[31]_i_10_n_0 ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[28]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8080808A808)) 
    \s_axi_rdata[28]_i_5 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\snapshot_reg[16] [28]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rdata[28]_i_6_n_0 ),
        .I4(s_axi_araddr[5]),
        .I5(\s_axi_rdata_reg[28]_i_7_n_0 ),
        .O(\s_axi_rdata[28]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hBBB888B888888888)) 
    \s_axi_rdata[28]_i_6 
       (.I0(\s_axi_rdata[28]_i_8_n_0 ),
        .I1(s_axi_araddr[4]),
        .I2(\snapshot_reg[2] [28]),
        .I3(s_axi_araddr[2]),
        .I4(\snapshot_reg[3] [28]),
        .I5(s_axi_araddr[3]),
        .O(\s_axi_rdata[28]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[28]_i_8 
       (.I0(\snapshot_reg[7] [28]),
        .I1(\snapshot_reg[6] [28]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [28]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [28]),
        .O(\s_axi_rdata[28]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[28]_i_9 
       (.I0(\snapshot_reg[11] [28]),
        .I1(\snapshot_reg[10] [28]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[8] [28]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[28]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h00200A2A00200222)) 
    \s_axi_rdata[29]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_7_n_0 ),
        .I3(\s_axi_rdata[29]_i_2_n_0 ),
        .I4(\s_axi_rdata[29]_i_3_n_0 ),
        .I5(\s_axi_rdata[29]_i_4_n_0 ),
        .O(\s_axi_rdata[29]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[29]_i_10 
       (.I0(\snapshot_reg[7] [29]),
        .I1(\snapshot_reg[6] [29]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [29]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [29]),
        .O(\s_axi_rdata[29]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'hF1FD)) 
    \s_axi_rdata[29]_i_2 
       (.I0(\shadow_soft_reg_n_0_[29] ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(config_epoch_reg[29]),
        .O(\s_axi_rdata[29]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h0000DDDF)) 
    \s_axi_rdata[29]_i_3 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\s_axi_rdata[29]_i_5_n_0 ),
        .I2(\snapshot_reg[16] [29]),
        .I3(s_axi_araddr[6]),
        .I4(\s_axi_rdata[29]_i_6_n_0 ),
        .O(\s_axi_rdata[29]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[29]_i_4 
       (.I0(shadow_loud[29]),
        .I1(shadow_quiet[29]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[29] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[29] ),
        .O(\s_axi_rdata[29]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h2EEE222200000000)) 
    \s_axi_rdata[29]_i_5 
       (.I0(\s_axi_rdata[29]_i_7_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[29]_i_8_n_0 ),
        .I3(s_axi_araddr[4]),
        .I4(\s_axi_rdata[29]_i_9_n_0 ),
        .I5(s_axi_araddr[6]),
        .O(\s_axi_rdata[29]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hEAEEEAAA)) 
    \s_axi_rdata[29]_i_6 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .I2(\ack_sequence_reg_n_0_[29] ),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(snapshot_sequence_reg[29]),
        .O(\s_axi_rdata[29]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00005D7FFFFF5D7F)) 
    \s_axi_rdata[29]_i_7 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[3] [29]),
        .I3(\snapshot_reg[2] [29]),
        .I4(s_axi_araddr[4]),
        .I5(\s_axi_rdata[29]_i_10_n_0 ),
        .O(\s_axi_rdata[29]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[29]_i_8 
       (.I0(\snapshot_reg[15] [29]),
        .I1(\snapshot_reg[14] [29]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [29]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [29]),
        .O(\s_axi_rdata[29]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAAEFBBEFEEEFFFEF)) 
    \s_axi_rdata[29]_i_9 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[8] [29]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[10] [29]),
        .I5(\snapshot_reg[11] [29]),
        .O(\s_axi_rdata[29]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[2]_i_10 
       (.I0(\snapshot_reg[11] [2]),
        .I1(\snapshot_reg[10] [2]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[0] [1]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[8] [2]),
        .O(\s_axi_rdata[2]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[2]_i_11 
       (.I0(\snapshot_reg[15] [2]),
        .I1(\snapshot_reg[14] [2]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [2]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [2]),
        .O(\s_axi_rdata[2]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[2]_i_12 
       (.I0(\snapshot_reg[3] [2]),
        .I1(\snapshot_reg[2] [2]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[1] [2]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[0] [2]),
        .O(\s_axi_rdata[2]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[2]_i_13 
       (.I0(\snapshot_reg[7] [2]),
        .I1(\snapshot_reg[6] [2]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [2]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [2]),
        .O(\s_axi_rdata[2]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF8A808A808A80)) 
    \s_axi_rdata[2]_i_3 
       (.I0(\s_axi_rdata[31]_i_10_n_0 ),
        .I1(\ack_sequence_reg_n_0_[2] ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(snapshot_sequence_reg[2]),
        .I4(\s_axi_rdata[2]_i_7_n_0 ),
        .I5(\s_axi_rresp[1]_i_3_n_0 ),
        .O(\s_axi_rdata[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[2]_i_4 
       (.I0(shadow_loud[2]),
        .I1(shadow_quiet[2]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[2] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[2] ),
        .O(\s_axi_rdata[2]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \s_axi_rdata[2]_i_6 
       (.I0(\s_axi_rdata[31]_i_11_n_0 ),
        .I1(\s_axi_rdata[31]_i_10_n_0 ),
        .O(\s_axi_rdata[2]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \s_axi_rdata[2]_i_7 
       (.I0(\s_axi_rdata_reg[2]_i_8_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata_reg[2]_i_9_n_0 ),
        .I3(s_axi_araddr[6]),
        .I4(\snapshot_reg[16] [2]),
        .O(\s_axi_rdata[2]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFB80000)) 
    \s_axi_rdata[30]_i_1 
       (.I0(\s_axi_rdata[30]_i_2_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[30]_i_3_n_0 ),
        .I3(\s_axi_rdata[31]_i_7_n_0 ),
        .I4(\s_axi_rdata[31]_i_3_n_0 ),
        .I5(\s_axi_rdata[30]_i_4_n_0 ),
        .O(\s_axi_rdata[30]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[30]_i_10 
       (.I0(\snapshot_reg[7] [30]),
        .I1(\snapshot_reg[6] [30]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [30]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [30]),
        .O(\s_axi_rdata[30]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[30]_i_2 
       (.I0(shadow_loud[30]),
        .I1(shadow_quiet[30]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[30] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[30] ),
        .O(\s_axi_rdata[30]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF5400)) 
    \s_axi_rdata[30]_i_3 
       (.I0(\s_axi_rdata[30]_i_5_n_0 ),
        .I1(\snapshot_reg[16] [30]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rresp[1]_i_3_n_0 ),
        .I4(\s_axi_rdata[30]_i_6_n_0 ),
        .O(\s_axi_rdata[30]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000FF00CF00DD00)) 
    \s_axi_rdata[30]_i_4 
       (.I0(\shadow_soft_reg_n_0_[30] ),
        .I1(\s_axi_rdata[31]_i_11_n_0 ),
        .I2(config_epoch_reg[30]),
        .I3(\s_axi_rdata[31]_i_7_n_0 ),
        .I4(\s_axi_rdata[31]_i_10_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[30]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h2EEE222200000000)) 
    \s_axi_rdata[30]_i_5 
       (.I0(\s_axi_rdata[30]_i_7_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[30]_i_8_n_0 ),
        .I3(s_axi_araddr[4]),
        .I4(\s_axi_rdata[30]_i_9_n_0 ),
        .I5(s_axi_araddr[6]),
        .O(\s_axi_rdata[30]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \s_axi_rdata[30]_i_6 
       (.I0(snapshot_sequence_reg[30]),
        .I1(\s_axi_rdata[31]_i_11_n_0 ),
        .I2(\ack_sequence_reg_n_0_[30] ),
        .I3(\s_axi_rdata[31]_i_10_n_0 ),
        .O(\s_axi_rdata[30]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h4747477777774777)) 
    \s_axi_rdata[30]_i_7 
       (.I0(\s_axi_rdata[30]_i_10_n_0 ),
        .I1(s_axi_araddr[4]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[2] [30]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[3] [30]),
        .O(\s_axi_rdata[30]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[30]_i_8 
       (.I0(\snapshot_reg[15] [30]),
        .I1(\snapshot_reg[14] [30]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [30]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [30]),
        .O(\s_axi_rdata[30]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAAEFBBEFEEEFFFEF)) 
    \s_axi_rdata[30]_i_9 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(\snapshot_reg[8] [30]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[10] [30]),
        .I5(\snapshot_reg[11] [30]),
        .O(\s_axi_rdata[30]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \s_axi_rdata[31]_i_1 
       (.I0(s_axi_arvalid),
        .I1(s_axi_rvalid_reg_0),
        .O(s_axi_rvalid06_out));
  LUT5 #(
    .INIT(32'h8A0820A2)) 
    \s_axi_rdata[31]_i_10 
       (.I0(\s_axi_rdata[31]_i_9_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[4]),
        .I4(s_axi_araddr[3]),
        .O(\s_axi_rdata[31]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h0A0A0080A2A0000A)) 
    \s_axi_rdata[31]_i_11 
       (.I0(\s_axi_rresp[1]_i_4_n_0 ),
        .I1(s_axi_araddr[3]),
        .I2(s_axi_araddr[5]),
        .I3(s_axi_araddr[7]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[31]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h575757F7F7F757F7)) 
    \s_axi_rdata[31]_i_12 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\snapshot_reg[16] [31]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rdata[31]_i_13_n_0 ),
        .I4(s_axi_araddr[5]),
        .I5(\s_axi_rdata_reg[31]_i_14_n_0 ),
        .O(\s_axi_rdata[31]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hBBB888B888888888)) 
    \s_axi_rdata[31]_i_13 
       (.I0(\s_axi_rdata[31]_i_15_n_0 ),
        .I1(s_axi_araddr[4]),
        .I2(\snapshot_reg[2] [31]),
        .I3(s_axi_araddr[2]),
        .I4(\snapshot_reg[3] [31]),
        .I5(s_axi_araddr[3]),
        .O(\s_axi_rdata[31]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[31]_i_15 
       (.I0(\snapshot_reg[7] [31]),
        .I1(\snapshot_reg[6] [31]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [31]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [31]),
        .O(\s_axi_rdata[31]_i_15_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[31]_i_16 
       (.I0(\snapshot_reg[11] [31]),
        .I1(\snapshot_reg[10] [31]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[8] [31]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[31]_i_16_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[31]_i_17 
       (.I0(\snapshot_reg[15] [31]),
        .I1(\snapshot_reg[14] [31]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [31]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [31]),
        .O(\s_axi_rdata[31]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h000000A2AAAA00A2)) 
    \s_axi_rdata[31]_i_2 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_5_n_0 ),
        .I3(\s_axi_rdata[31]_i_6_n_0 ),
        .I4(\s_axi_rdata[31]_i_7_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[31]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h0001)) 
    \s_axi_rdata[31]_i_3 
       (.I0(s_axi_araddr[8]),
        .I1(s_axi_araddr[11]),
        .I2(s_axi_araddr[9]),
        .I3(s_axi_araddr[10]),
        .O(\s_axi_rdata[31]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h74170000)) 
    \s_axi_rdata[31]_i_4 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[3]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[5]),
        .I4(\s_axi_rdata[31]_i_9_n_0 ),
        .O(\s_axi_rdata[31]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[31]_i_5 
       (.I0(shadow_loud[31]),
        .I1(shadow_quiet[31]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[31] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[31] ),
        .O(\s_axi_rdata[31]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0000000002A2AAAA)) 
    \s_axi_rdata[31]_i_6 
       (.I0(\s_axi_rdata[31]_i_12_n_0 ),
        .I1(snapshot_sequence_reg[31]),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(\ack_sequence_reg_n_0_[31] ),
        .I4(\s_axi_rdata[31]_i_10_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[31]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h51570000)) 
    \s_axi_rdata[31]_i_7 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[3]),
        .I2(s_axi_araddr[4]),
        .I3(s_axi_araddr[2]),
        .I4(\s_axi_rdata[31]_i_9_n_0 ),
        .O(\s_axi_rdata[31]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF03F5)) 
    \s_axi_rdata[31]_i_8 
       (.I0(\shadow_soft_reg_n_0_[31] ),
        .I1(config_epoch_reg[31]),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(\s_axi_rdata[31]_i_10_n_0 ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .O(\s_axi_rdata[31]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h0001)) 
    \s_axi_rdata[31]_i_9 
       (.I0(s_axi_araddr[1]),
        .I1(s_axi_araddr[0]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[6]),
        .O(\s_axi_rdata[31]_i_9_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[3]_i_10 
       (.I0(\snapshot_reg[11] [3]),
        .I1(\snapshot_reg[10] [3]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[8] [3]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[3]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[3]_i_11 
       (.I0(\snapshot_reg[15] [3]),
        .I1(\snapshot_reg[14] [3]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [3]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [3]),
        .O(\s_axi_rdata[3]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[3]_i_12 
       (.I0(\snapshot_reg[3] [3]),
        .I1(\snapshot_reg[2] [3]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[1] [3]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[0] [3]),
        .O(\s_axi_rdata[3]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[3]_i_13 
       (.I0(\snapshot_reg[7] [3]),
        .I1(\snapshot_reg[6] [3]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [3]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [3]),
        .O(\s_axi_rdata[3]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF8A808A808A80)) 
    \s_axi_rdata[3]_i_3 
       (.I0(\s_axi_rdata[31]_i_10_n_0 ),
        .I1(\ack_sequence_reg_n_0_[3] ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(snapshot_sequence_reg[3]),
        .I4(\s_axi_rdata[3]_i_7_n_0 ),
        .I5(\s_axi_rresp[1]_i_3_n_0 ),
        .O(\s_axi_rdata[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[3]_i_4 
       (.I0(shadow_loud[3]),
        .I1(shadow_quiet[3]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[3] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[3] ),
        .O(\s_axi_rdata[3]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \s_axi_rdata[3]_i_5 
       (.I0(\s_axi_rdata[31]_i_7_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \s_axi_rdata[3]_i_6 
       (.I0(\s_axi_rdata[31]_i_10_n_0 ),
        .I1(\s_axi_rdata[31]_i_7_n_0 ),
        .I2(out),
        .I3(\s_axi_rdata[31]_i_4_n_0 ),
        .I4(\shadow_soft_reg_n_0_[3] ),
        .I5(\s_axi_rdata[31]_i_11_n_0 ),
        .O(\s_axi_rdata[3]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \s_axi_rdata[3]_i_7 
       (.I0(\s_axi_rdata_reg[3]_i_8_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata_reg[3]_i_9_n_0 ),
        .I3(s_axi_araddr[6]),
        .I4(\snapshot_reg[16] [3]),
        .O(\s_axi_rdata[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[4]_i_10 
       (.I0(\snapshot_reg[15] [4]),
        .I1(\snapshot_reg[14] [4]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [4]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [4]),
        .O(\s_axi_rdata[4]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[4]_i_11 
       (.I0(\snapshot_reg[3] [4]),
        .I1(\snapshot_reg[2] [4]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[1] [4]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[0] [4]),
        .O(\s_axi_rdata[4]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[4]_i_12 
       (.I0(\snapshot_reg[7] [4]),
        .I1(\snapshot_reg[6] [4]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [4]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [4]),
        .O(\s_axi_rdata[4]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFAFCFC0A0A0CFC0)) 
    \s_axi_rdata[4]_i_2 
       (.I0(shadow_loud[4]),
        .I1(shadow_quiet[4]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\ack_epoch_reg_n_0_[4] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\shadow_enable_reg_n_0_[4] ),
        .O(\s_axi_rdata[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF8A808A808A80)) 
    \s_axi_rdata[4]_i_3 
       (.I0(\s_axi_rdata[31]_i_10_n_0 ),
        .I1(\ack_sequence_reg_n_0_[4] ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(snapshot_sequence_reg[4]),
        .I4(\s_axi_rdata[4]_i_5_n_0 ),
        .I5(\s_axi_rresp[1]_i_3_n_0 ),
        .O(\s_axi_rdata[4]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \s_axi_rdata[4]_i_5 
       (.I0(\s_axi_rdata_reg[4]_i_7_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata_reg[4]_i_8_n_0 ),
        .I3(s_axi_araddr[6]),
        .I4(\snapshot_reg[16] [4]),
        .O(\s_axi_rdata[4]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[4]_i_9 
       (.I0(\snapshot_reg[11] [4]),
        .I1(\snapshot_reg[10] [4]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[8] [4]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[4]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[5]_i_10 
       (.I0(\snapshot_reg[7] [5]),
        .I1(\snapshot_reg[6] [5]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [5]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [5]),
        .O(\s_axi_rdata[5]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'h0000DF1F)) 
    \s_axi_rdata[5]_i_2 
       (.I0(\snapshot_reg[16] [5]),
        .I1(s_axi_araddr[6]),
        .I2(\s_axi_rresp[1]_i_3_n_0 ),
        .I3(\s_axi_rdata[5]_i_5_n_0 ),
        .I4(\s_axi_rdata[5]_i_6_n_0 ),
        .O(\s_axi_rdata[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h50505F5F303F303F)) 
    \s_axi_rdata[5]_i_3 
       (.I0(shadow_loud[5]),
        .I1(shadow_quiet[5]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\ack_epoch_reg_n_0_[5] ),
        .I4(\shadow_enable_reg_n_0_[5] ),
        .I5(\s_axi_rdata[31]_i_11_n_0 ),
        .O(\s_axi_rdata[5]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h10103F301F103F30)) 
    \s_axi_rdata[5]_i_5 
       (.I0(\s_axi_rdata[5]_i_7_n_0 ),
        .I1(\s_axi_rdata[5]_i_8_n_0 ),
        .I2(s_axi_araddr[5]),
        .I3(\s_axi_rdata[5]_i_9_n_0 ),
        .I4(s_axi_araddr[4]),
        .I5(\s_axi_rdata[5]_i_10_n_0 ),
        .O(\s_axi_rdata[5]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hE200)) 
    \s_axi_rdata[5]_i_6 
       (.I0(snapshot_sequence_reg[5]),
        .I1(\s_axi_rdata[31]_i_11_n_0 ),
        .I2(\ack_sequence_reg_n_0_[5] ),
        .I3(\s_axi_rdata[31]_i_10_n_0 ),
        .O(\s_axi_rdata[5]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[5]_i_7 
       (.I0(\snapshot_reg[15] [5]),
        .I1(\snapshot_reg[14] [5]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [5]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [5]),
        .O(\s_axi_rdata[5]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h00000000F4A45404)) 
    \s_axi_rdata[5]_i_8 
       (.I0(s_axi_araddr[2]),
        .I1(\snapshot_reg[8] [5]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[10] [5]),
        .I4(\snapshot_reg[11] [5]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[5]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAABFAFBFFABFFFBF)) 
    \s_axi_rdata[5]_i_9 
       (.I0(s_axi_araddr[4]),
        .I1(\snapshot_reg[1] [5]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(\snapshot_reg[2] [5]),
        .I5(\snapshot_reg[3] [5]),
        .O(\s_axi_rdata[5]_i_9_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[6]_i_10 
       (.I0(\snapshot_reg[11] [6]),
        .I1(\snapshot_reg[10] [6]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[8] [6]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[6]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[6]_i_11 
       (.I0(\snapshot_reg[15] [6]),
        .I1(\snapshot_reg[14] [6]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [6]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [6]),
        .O(\s_axi_rdata[6]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hFFEEEFEEFEEEEEEE)) 
    \s_axi_rdata[6]_i_2 
       (.I0(\s_axi_rdata[6]_i_5_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(\s_axi_rdata[31]_i_10_n_0 ),
        .I4(\ack_sequence_reg_n_0_[6] ),
        .I5(snapshot_sequence_reg[6]),
        .O(\s_axi_rdata[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[6]_i_3 
       (.I0(shadow_loud[6]),
        .I1(shadow_quiet[6]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[6] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[6] ),
        .O(\s_axi_rdata[6]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8080808A808)) 
    \s_axi_rdata[6]_i_5 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\snapshot_reg[16] [6]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rdata_reg[6]_i_6_n_0 ),
        .I4(s_axi_araddr[5]),
        .I5(\s_axi_rdata_reg[6]_i_7_n_0 ),
        .O(\s_axi_rdata[6]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hAFC0A0C0)) 
    \s_axi_rdata[6]_i_8 
       (.I0(\snapshot_reg[3] [6]),
        .I1(\snapshot_reg[2] [6]),
        .I2(s_axi_araddr[3]),
        .I3(s_axi_araddr[2]),
        .I4(\snapshot_reg[1] [6]),
        .O(\s_axi_rdata[6]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[6]_i_9 
       (.I0(\snapshot_reg[7] [6]),
        .I1(\snapshot_reg[6] [6]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [6]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [6]),
        .O(\s_axi_rdata[6]_i_9_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[7]_i_10 
       (.I0(\snapshot_reg[11] [7]),
        .I1(\snapshot_reg[10] [7]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[8] [7]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[7]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[7]_i_11 
       (.I0(\snapshot_reg[15] [7]),
        .I1(\snapshot_reg[14] [7]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [7]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [7]),
        .O(\s_axi_rdata[7]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h0000000002A2AAAA)) 
    \s_axi_rdata[7]_i_3 
       (.I0(\s_axi_rdata[7]_i_5_n_0 ),
        .I1(snapshot_sequence_reg[7]),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(\ack_sequence_reg_n_0_[7] ),
        .I4(\s_axi_rdata[31]_i_10_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[7]_i_4 
       (.I0(shadow_loud[7]),
        .I1(shadow_quiet[7]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[7] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[7] ),
        .O(\s_axi_rdata[7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h575757F7F7F757F7)) 
    \s_axi_rdata[7]_i_5 
       (.I0(\s_axi_rresp[1]_i_3_n_0 ),
        .I1(\snapshot_reg[16] [7]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rdata_reg[7]_i_6_n_0 ),
        .I4(s_axi_araddr[5]),
        .I5(\s_axi_rdata_reg[7]_i_7_n_0 ),
        .O(\s_axi_rdata[7]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hAFC0A0C0)) 
    \s_axi_rdata[7]_i_8 
       (.I0(\snapshot_reg[3] [7]),
        .I1(\snapshot_reg[2] [7]),
        .I2(s_axi_araddr[3]),
        .I3(s_axi_araddr[2]),
        .I4(\snapshot_reg[1] [7]),
        .O(\s_axi_rdata[7]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[7]_i_9 
       (.I0(\snapshot_reg[7] [7]),
        .I1(\snapshot_reg[6] [7]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [7]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [7]),
        .O(\s_axi_rdata[7]_i_9_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[8]_i_10 
       (.I0(\snapshot_reg[11] [8]),
        .I1(\snapshot_reg[10] [8]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[8] [8]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[8]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[8]_i_11 
       (.I0(\snapshot_reg[15] [8]),
        .I1(\snapshot_reg[14] [8]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [8]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [8]),
        .O(\s_axi_rdata[8]_i_11_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[8]_i_12 
       (.I0(\snapshot_reg[3] [8]),
        .I1(\snapshot_reg[2] [8]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[0] [8]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[8]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[8]_i_13 
       (.I0(\snapshot_reg[7] [8]),
        .I1(\snapshot_reg[6] [8]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [8]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [8]),
        .O(\s_axi_rdata[8]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h0404444000004440)) 
    \s_axi_rdata[8]_i_2 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_7_n_0 ),
        .I2(\s_axi_rdata[31]_i_11_n_0 ),
        .I3(\shadow_soft_reg_n_0_[8] ),
        .I4(\s_axi_rdata[31]_i_10_n_0 ),
        .I5(config_epoch_reg[8]),
        .O(\s_axi_rdata[8]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \s_axi_rdata[8]_i_3 
       (.I0(\s_axi_rdata[31]_i_10_n_0 ),
        .I1(\s_axi_rdata[31]_i_11_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[8]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hF8FFF88888888888)) 
    \s_axi_rdata[8]_i_5 
       (.I0(\s_axi_rdata[8]_i_7_n_0 ),
        .I1(\s_axi_rresp[1]_i_3_n_0 ),
        .I2(\ack_sequence_reg_n_0_[8] ),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(snapshot_sequence_reg[8]),
        .I5(\s_axi_rdata[31]_i_10_n_0 ),
        .O(\s_axi_rdata[8]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[8]_i_6 
       (.I0(shadow_loud[8]),
        .I1(shadow_quiet[8]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[8] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[8] ),
        .O(\s_axi_rdata[8]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \s_axi_rdata[8]_i_7 
       (.I0(\s_axi_rdata_reg[8]_i_8_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata_reg[8]_i_9_n_0 ),
        .I3(s_axi_araddr[6]),
        .I4(\snapshot_reg[16] [8]),
        .O(\s_axi_rdata[8]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[9]_i_10 
       (.I0(\snapshot_reg[3] [9]),
        .I1(\snapshot_reg[2] [9]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[0] [9]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[9]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[9]_i_11 
       (.I0(\snapshot_reg[7] [9]),
        .I1(\snapshot_reg[6] [9]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[5] [9]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[4] [9]),
        .O(\s_axi_rdata[9]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hF888F8F8F8888888)) 
    \s_axi_rdata[9]_i_2 
       (.I0(\s_axi_rdata[9]_i_5_n_0 ),
        .I1(\s_axi_rresp[1]_i_3_n_0 ),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\ack_sequence_reg_n_0_[9] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(snapshot_sequence_reg[9]),
        .O(\s_axi_rdata[9]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[9]_i_3 
       (.I0(shadow_loud[9]),
        .I1(shadow_quiet[9]),
        .I2(\s_axi_rdata[31]_i_10_n_0 ),
        .I3(\shadow_enable_reg_n_0_[9] ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\ack_epoch_reg_n_0_[9] ),
        .O(\s_axi_rdata[9]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \s_axi_rdata[9]_i_5 
       (.I0(\s_axi_rdata_reg[9]_i_6_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata_reg[9]_i_7_n_0 ),
        .I3(s_axi_araddr[6]),
        .I4(\snapshot_reg[16] [9]),
        .O(\s_axi_rdata[9]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hA0A0CFC0)) 
    \s_axi_rdata[9]_i_8 
       (.I0(\snapshot_reg[11] [9]),
        .I1(\snapshot_reg[10] [9]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[8] [9]),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[9]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[9]_i_9 
       (.I0(\snapshot_reg[15] [9]),
        .I1(\snapshot_reg[14] [9]),
        .I2(s_axi_araddr[3]),
        .I3(\snapshot_reg[13] [9]),
        .I4(s_axi_araddr[2]),
        .I5(\snapshot_reg[12] [9]),
        .O(\s_axi_rdata[9]_i_9_n_0 ));
  FDRE \s_axi_rdata_reg[0] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(core_n_136),
        .Q(s_axi_rdata[0]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[0]_i_7 
       (.I0(\s_axi_rdata[0]_i_9_n_0 ),
        .I1(\s_axi_rdata[0]_i_10_n_0 ),
        .O(\s_axi_rdata_reg[0]_i_7_n_0 ),
        .S(s_axi_araddr[4]));
  MUXF7 \s_axi_rdata_reg[0]_i_8 
       (.I0(\s_axi_rdata[0]_i_11_n_0 ),
        .I1(\s_axi_rdata[0]_i_12_n_0 ),
        .O(\s_axi_rdata_reg[0]_i_8_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[10] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(core_n_126),
        .Q(s_axi_rdata[10]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[10]_i_7 
       (.I0(\s_axi_rdata[10]_i_9_n_0 ),
        .I1(\s_axi_rdata[10]_i_10_n_0 ),
        .O(\s_axi_rdata_reg[10]_i_7_n_0 ),
        .S(s_axi_araddr[4]));
  MUXF7 \s_axi_rdata_reg[10]_i_8 
       (.I0(\s_axi_rdata[10]_i_11_n_0 ),
        .I1(\s_axi_rdata[10]_i_12_n_0 ),
        .O(\s_axi_rdata_reg[10]_i_8_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[11] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[11]_i_1_n_0 ),
        .Q(s_axi_rdata[11]),
        .R(SR));
  FDRE \s_axi_rdata_reg[12] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[12]_i_1_n_0 ),
        .Q(s_axi_rdata[12]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[12]_i_7 
       (.I0(\s_axi_rdata[12]_i_9_n_0 ),
        .I1(\s_axi_rdata[12]_i_10_n_0 ),
        .O(\s_axi_rdata_reg[12]_i_7_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[13] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[13]_i_1_n_0 ),
        .Q(s_axi_rdata[13]),
        .R(SR));
  FDRE \s_axi_rdata_reg[14] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[14]_i_1_n_0 ),
        .Q(s_axi_rdata[14]),
        .R(SR));
  FDRE \s_axi_rdata_reg[15] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[15]_i_1_n_0 ),
        .Q(s_axi_rdata[15]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[15]_i_7 
       (.I0(\s_axi_rdata[15]_i_9_n_0 ),
        .I1(\s_axi_rdata[15]_i_10_n_0 ),
        .O(\s_axi_rdata_reg[15]_i_7_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[16] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[16]_i_1_n_0 ),
        .Q(s_axi_rdata[16]),
        .R(SR));
  FDRE \s_axi_rdata_reg[17] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[17]_i_1_n_0 ),
        .Q(s_axi_rdata[17]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[17]_i_7 
       (.I0(\s_axi_rdata[17]_i_9_n_0 ),
        .I1(\s_axi_rdata[17]_i_10_n_0 ),
        .O(\s_axi_rdata_reg[17]_i_7_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[18] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[18]_i_1_n_0 ),
        .Q(s_axi_rdata[18]),
        .R(SR));
  FDRE \s_axi_rdata_reg[19] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[19]_i_1_n_0 ),
        .Q(s_axi_rdata[19]),
        .R(SR));
  FDRE \s_axi_rdata_reg[1] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(core_n_135),
        .Q(s_axi_rdata[1]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[1]_i_7 
       (.I0(\s_axi_rdata[1]_i_9_n_0 ),
        .I1(\s_axi_rdata[1]_i_10_n_0 ),
        .O(\s_axi_rdata_reg[1]_i_7_n_0 ),
        .S(s_axi_araddr[4]));
  MUXF7 \s_axi_rdata_reg[1]_i_8 
       (.I0(\s_axi_rdata[1]_i_11_n_0 ),
        .I1(\s_axi_rdata[1]_i_12_n_0 ),
        .O(\s_axi_rdata_reg[1]_i_8_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[20] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[20]_i_1_n_0 ),
        .Q(s_axi_rdata[20]),
        .R(SR));
  FDRE \s_axi_rdata_reg[21] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[21]_i_1_n_0 ),
        .Q(s_axi_rdata[21]),
        .R(SR));
  FDRE \s_axi_rdata_reg[22] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[22]_i_1_n_0 ),
        .Q(s_axi_rdata[22]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[22]_i_7 
       (.I0(\s_axi_rdata[22]_i_9_n_0 ),
        .I1(\s_axi_rdata[22]_i_10_n_0 ),
        .O(\s_axi_rdata_reg[22]_i_7_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[23] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[23]_i_1_n_0 ),
        .Q(s_axi_rdata[23]),
        .R(SR));
  FDRE \s_axi_rdata_reg[24] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[24]_i_1_n_0 ),
        .Q(s_axi_rdata[24]),
        .R(SR));
  FDRE \s_axi_rdata_reg[25] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[25]_i_1_n_0 ),
        .Q(s_axi_rdata[25]),
        .R(SR));
  FDRE \s_axi_rdata_reg[26] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[26]_i_1_n_0 ),
        .Q(s_axi_rdata[26]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[26]_i_7 
       (.I0(\s_axi_rdata[26]_i_9_n_0 ),
        .I1(\s_axi_rdata[26]_i_10_n_0 ),
        .O(\s_axi_rdata_reg[26]_i_7_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[27] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[27]_i_1_n_0 ),
        .Q(s_axi_rdata[27]),
        .R(SR));
  FDRE \s_axi_rdata_reg[28] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[28]_i_1_n_0 ),
        .Q(s_axi_rdata[28]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[28]_i_7 
       (.I0(\s_axi_rdata[28]_i_9_n_0 ),
        .I1(\s_axi_rdata[28]_i_10_n_0 ),
        .O(\s_axi_rdata_reg[28]_i_7_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[29] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[29]_i_1_n_0 ),
        .Q(s_axi_rdata[29]),
        .R(SR));
  FDRE \s_axi_rdata_reg[2] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(core_n_134),
        .Q(s_axi_rdata[2]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[2]_i_8 
       (.I0(\s_axi_rdata[2]_i_10_n_0 ),
        .I1(\s_axi_rdata[2]_i_11_n_0 ),
        .O(\s_axi_rdata_reg[2]_i_8_n_0 ),
        .S(s_axi_araddr[4]));
  MUXF7 \s_axi_rdata_reg[2]_i_9 
       (.I0(\s_axi_rdata[2]_i_12_n_0 ),
        .I1(\s_axi_rdata[2]_i_13_n_0 ),
        .O(\s_axi_rdata_reg[2]_i_9_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[30] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[30]_i_1_n_0 ),
        .Q(s_axi_rdata[30]),
        .R(SR));
  FDRE \s_axi_rdata_reg[31] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rdata[31]_i_2_n_0 ),
        .Q(s_axi_rdata[31]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[31]_i_14 
       (.I0(\s_axi_rdata[31]_i_16_n_0 ),
        .I1(\s_axi_rdata[31]_i_17_n_0 ),
        .O(\s_axi_rdata_reg[31]_i_14_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[3] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(core_n_133),
        .Q(s_axi_rdata[3]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[3]_i_8 
       (.I0(\s_axi_rdata[3]_i_10_n_0 ),
        .I1(\s_axi_rdata[3]_i_11_n_0 ),
        .O(\s_axi_rdata_reg[3]_i_8_n_0 ),
        .S(s_axi_araddr[4]));
  MUXF7 \s_axi_rdata_reg[3]_i_9 
       (.I0(\s_axi_rdata[3]_i_12_n_0 ),
        .I1(\s_axi_rdata[3]_i_13_n_0 ),
        .O(\s_axi_rdata_reg[3]_i_9_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[4] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(core_n_132),
        .Q(s_axi_rdata[4]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[4]_i_7 
       (.I0(\s_axi_rdata[4]_i_9_n_0 ),
        .I1(\s_axi_rdata[4]_i_10_n_0 ),
        .O(\s_axi_rdata_reg[4]_i_7_n_0 ),
        .S(s_axi_araddr[4]));
  MUXF7 \s_axi_rdata_reg[4]_i_8 
       (.I0(\s_axi_rdata[4]_i_11_n_0 ),
        .I1(\s_axi_rdata[4]_i_12_n_0 ),
        .O(\s_axi_rdata_reg[4]_i_8_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[5] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(core_n_131),
        .Q(s_axi_rdata[5]),
        .R(SR));
  FDRE \s_axi_rdata_reg[6] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(core_n_130),
        .Q(s_axi_rdata[6]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[6]_i_6 
       (.I0(\s_axi_rdata[6]_i_8_n_0 ),
        .I1(\s_axi_rdata[6]_i_9_n_0 ),
        .O(\s_axi_rdata_reg[6]_i_6_n_0 ),
        .S(s_axi_araddr[4]));
  MUXF7 \s_axi_rdata_reg[6]_i_7 
       (.I0(\s_axi_rdata[6]_i_10_n_0 ),
        .I1(\s_axi_rdata[6]_i_11_n_0 ),
        .O(\s_axi_rdata_reg[6]_i_7_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[7] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(core_n_129),
        .Q(s_axi_rdata[7]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[7]_i_6 
       (.I0(\s_axi_rdata[7]_i_8_n_0 ),
        .I1(\s_axi_rdata[7]_i_9_n_0 ),
        .O(\s_axi_rdata_reg[7]_i_6_n_0 ),
        .S(s_axi_araddr[4]));
  MUXF7 \s_axi_rdata_reg[7]_i_7 
       (.I0(\s_axi_rdata[7]_i_10_n_0 ),
        .I1(\s_axi_rdata[7]_i_11_n_0 ),
        .O(\s_axi_rdata_reg[7]_i_7_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[8] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(core_n_128),
        .Q(s_axi_rdata[8]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[8]_i_4 
       (.I0(\s_axi_rdata[8]_i_5_n_0 ),
        .I1(\s_axi_rdata[8]_i_6_n_0 ),
        .O(\s_axi_rdata_reg[8]_i_4_n_0 ),
        .S(\s_axi_rdata[31]_i_4_n_0 ));
  MUXF7 \s_axi_rdata_reg[8]_i_8 
       (.I0(\s_axi_rdata[8]_i_10_n_0 ),
        .I1(\s_axi_rdata[8]_i_11_n_0 ),
        .O(\s_axi_rdata_reg[8]_i_8_n_0 ),
        .S(s_axi_araddr[4]));
  MUXF7 \s_axi_rdata_reg[8]_i_9 
       (.I0(\s_axi_rdata[8]_i_12_n_0 ),
        .I1(\s_axi_rdata[8]_i_13_n_0 ),
        .O(\s_axi_rdata_reg[8]_i_9_n_0 ),
        .S(s_axi_araddr[4]));
  FDRE \s_axi_rdata_reg[9] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(core_n_127),
        .Q(s_axi_rdata[9]),
        .R(SR));
  MUXF7 \s_axi_rdata_reg[9]_i_6 
       (.I0(\s_axi_rdata[9]_i_8_n_0 ),
        .I1(\s_axi_rdata[9]_i_9_n_0 ),
        .O(\s_axi_rdata_reg[9]_i_6_n_0 ),
        .S(s_axi_araddr[4]));
  MUXF7 \s_axi_rdata_reg[9]_i_7 
       (.I0(\s_axi_rdata[9]_i_10_n_0 ),
        .I1(\s_axi_rdata[9]_i_11_n_0 ),
        .O(\s_axi_rdata_reg[9]_i_7_n_0 ),
        .S(s_axi_araddr[4]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFF1)) 
    \s_axi_rresp[1]_i_1 
       (.I0(\s_axi_rresp[1]_i_2_n_0 ),
        .I1(\s_axi_rresp[1]_i_3_n_0 ),
        .I2(s_axi_araddr[10]),
        .I3(s_axi_araddr[9]),
        .I4(s_axi_araddr[11]),
        .I5(s_axi_araddr[8]),
        .O(\s_axi_rresp[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A82088A8A8A8)) 
    \s_axi_rresp[1]_i_2 
       (.I0(\s_axi_rresp[1]_i_4_n_0 ),
        .I1(s_axi_araddr[2]),
        .I2(\s_axi_rdata[31]_i_9_n_0 ),
        .I3(s_axi_araddr[5]),
        .I4(s_axi_araddr[4]),
        .I5(s_axi_araddr[3]),
        .O(\s_axi_rresp[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0202020000000000)) 
    \s_axi_rresp[1]_i_3 
       (.I0(\s_axi_rresp[1]_i_5_n_0 ),
        .I1(s_axi_araddr[1]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[7]),
        .I4(s_axi_araddr[6]),
        .I5(\s_axi_rdata[31]_i_3_n_0 ),
        .O(\s_axi_rresp[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h000000000000010F)) 
    \s_axi_rresp[1]_i_4 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[4]),
        .I2(s_axi_araddr[6]),
        .I3(s_axi_araddr[7]),
        .I4(s_axi_araddr[0]),
        .I5(s_axi_araddr[1]),
        .O(\s_axi_rresp[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00000001FFFFFFFF)) 
    \s_axi_rresp[1]_i_5 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[5]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[7]),
        .O(\s_axi_rresp[1]_i_5_n_0 ));
  FDRE \s_axi_rresp_reg[1] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid06_out),
        .D(\s_axi_rresp[1]_i_1_n_0 ),
        .Q(s_axi_rresp),
        .R(SR));
  LUT3 #(
    .INIT(8'h3A)) 
    s_axi_rvalid_i_1
       (.I0(s_axi_arvalid),
        .I1(s_axi_rready),
        .I2(s_axi_rvalid_reg_0),
        .O(s_axi_rvalid_i_1_n_0));
  FDRE s_axi_rvalid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_rvalid_i_1_n_0),
        .Q(s_axi_rvalid_reg_0),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'h04)) 
    s_axi_wready_INST_0
       (.I0(w_held_reg_n_0),
        .I1(s_axi_aresetn),
        .I2(s_axi_bvalid_reg_0),
        .O(s_axi_wready));
  LUT5 #(
    .INIT(32'h20000000)) 
    \shadow_enable[31]_i_1 
       (.I0(\shadow_soft[31]_i_2_n_0 ),
        .I1(write_address[4]),
        .I2(\shadow_enable[31]_i_2_n_0 ),
        .I3(write_address[2]),
        .I4(write_address[3]),
        .O(shadow_enable));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'h01)) 
    \shadow_enable[31]_i_2 
       (.I0(\s_axi_bresp[1]_i_9_n_0 ),
        .I1(write_data[1]),
        .I2(write_data[2]),
        .O(\shadow_enable[31]_i_2_n_0 ));
  FDRE \shadow_enable_reg[0] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[0]),
        .Q(\shadow_enable_reg_n_0_[0] ),
        .R(SR));
  FDRE \shadow_enable_reg[10] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[10]),
        .Q(\shadow_enable_reg_n_0_[10] ),
        .R(SR));
  FDRE \shadow_enable_reg[11] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[11]),
        .Q(\shadow_enable_reg_n_0_[11] ),
        .R(SR));
  FDRE \shadow_enable_reg[12] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[12]),
        .Q(\shadow_enable_reg_n_0_[12] ),
        .R(SR));
  FDRE \shadow_enable_reg[13] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[13]),
        .Q(\shadow_enable_reg_n_0_[13] ),
        .R(SR));
  FDRE \shadow_enable_reg[14] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[14]),
        .Q(\shadow_enable_reg_n_0_[14] ),
        .R(SR));
  FDRE \shadow_enable_reg[15] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[15]),
        .Q(\shadow_enable_reg_n_0_[15] ),
        .R(SR));
  FDRE \shadow_enable_reg[16] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[16]),
        .Q(\shadow_enable_reg_n_0_[16] ),
        .R(SR));
  FDRE \shadow_enable_reg[17] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[17]),
        .Q(\shadow_enable_reg_n_0_[17] ),
        .R(SR));
  FDRE \shadow_enable_reg[18] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[18]),
        .Q(\shadow_enable_reg_n_0_[18] ),
        .R(SR));
  FDRE \shadow_enable_reg[19] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[19]),
        .Q(\shadow_enable_reg_n_0_[19] ),
        .R(SR));
  FDRE \shadow_enable_reg[1] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[1]),
        .Q(\shadow_enable_reg_n_0_[1] ),
        .R(SR));
  FDRE \shadow_enable_reg[20] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[20]),
        .Q(\shadow_enable_reg_n_0_[20] ),
        .R(SR));
  FDRE \shadow_enable_reg[21] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[21]),
        .Q(\shadow_enable_reg_n_0_[21] ),
        .R(SR));
  FDRE \shadow_enable_reg[22] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[22]),
        .Q(\shadow_enable_reg_n_0_[22] ),
        .R(SR));
  FDRE \shadow_enable_reg[23] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[23]),
        .Q(\shadow_enable_reg_n_0_[23] ),
        .R(SR));
  FDRE \shadow_enable_reg[24] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[24]),
        .Q(\shadow_enable_reg_n_0_[24] ),
        .R(SR));
  FDRE \shadow_enable_reg[25] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[25]),
        .Q(\shadow_enable_reg_n_0_[25] ),
        .R(SR));
  FDRE \shadow_enable_reg[26] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[26]),
        .Q(\shadow_enable_reg_n_0_[26] ),
        .R(SR));
  FDRE \shadow_enable_reg[27] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[27]),
        .Q(\shadow_enable_reg_n_0_[27] ),
        .R(SR));
  FDRE \shadow_enable_reg[28] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[28]),
        .Q(\shadow_enable_reg_n_0_[28] ),
        .R(SR));
  FDRE \shadow_enable_reg[29] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[29]),
        .Q(\shadow_enable_reg_n_0_[29] ),
        .R(SR));
  FDRE \shadow_enable_reg[2] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[2]),
        .Q(\shadow_enable_reg_n_0_[2] ),
        .R(SR));
  FDRE \shadow_enable_reg[30] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[30]),
        .Q(\shadow_enable_reg_n_0_[30] ),
        .R(SR));
  FDRE \shadow_enable_reg[31] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[31]),
        .Q(\shadow_enable_reg_n_0_[31] ),
        .R(SR));
  FDRE \shadow_enable_reg[3] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[3]),
        .Q(\shadow_enable_reg_n_0_[3] ),
        .R(SR));
  FDRE \shadow_enable_reg[4] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[4]),
        .Q(\shadow_enable_reg_n_0_[4] ),
        .R(SR));
  FDRE \shadow_enable_reg[5] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[5]),
        .Q(\shadow_enable_reg_n_0_[5] ),
        .R(SR));
  FDRE \shadow_enable_reg[6] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[6]),
        .Q(\shadow_enable_reg_n_0_[6] ),
        .R(SR));
  FDRE \shadow_enable_reg[7] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[7]),
        .Q(\shadow_enable_reg_n_0_[7] ),
        .R(SR));
  FDRE \shadow_enable_reg[8] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[8]),
        .Q(\shadow_enable_reg_n_0_[8] ),
        .R(SR));
  FDRE \shadow_enable_reg[9] 
       (.C(s_axi_aclk),
        .CE(shadow_enable),
        .D(write_data[9]),
        .Q(\shadow_enable_reg_n_0_[9] ),
        .R(SR));
  LUT4 #(
    .INIT(16'h0020)) 
    \shadow_loud[31]_i_1 
       (.I0(\shadow_soft[31]_i_2_n_0 ),
        .I1(write_address[4]),
        .I2(write_address[2]),
        .I3(write_address[3]),
        .O(shadow_loud_1));
  FDRE \shadow_loud_reg[0] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[0]),
        .Q(shadow_loud[0]),
        .R(SR));
  FDRE \shadow_loud_reg[10] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[10]),
        .Q(shadow_loud[10]),
        .R(SR));
  FDSE \shadow_loud_reg[11] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[11]),
        .Q(shadow_loud[11]),
        .S(SR));
  FDRE \shadow_loud_reg[12] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[12]),
        .Q(shadow_loud[12]),
        .R(SR));
  FDRE \shadow_loud_reg[13] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[13]),
        .Q(shadow_loud[13]),
        .R(SR));
  FDRE \shadow_loud_reg[14] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[14]),
        .Q(shadow_loud[14]),
        .R(SR));
  FDRE \shadow_loud_reg[15] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[15]),
        .Q(shadow_loud[15]),
        .R(SR));
  FDSE \shadow_loud_reg[16] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[16]),
        .Q(shadow_loud[16]),
        .S(SR));
  FDRE \shadow_loud_reg[17] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[17]),
        .Q(shadow_loud[17]),
        .R(SR));
  FDSE \shadow_loud_reg[18] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[18]),
        .Q(shadow_loud[18]),
        .S(SR));
  FDSE \shadow_loud_reg[19] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[19]),
        .Q(shadow_loud[19]),
        .S(SR));
  FDRE \shadow_loud_reg[1] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[1]),
        .Q(shadow_loud[1]),
        .R(SR));
  FDSE \shadow_loud_reg[20] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[20]),
        .Q(shadow_loud[20]),
        .S(SR));
  FDSE \shadow_loud_reg[21] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[21]),
        .Q(shadow_loud[21]),
        .S(SR));
  FDRE \shadow_loud_reg[22] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[22]),
        .Q(shadow_loud[22]),
        .R(SR));
  FDRE \shadow_loud_reg[23] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[23]),
        .Q(shadow_loud[23]),
        .R(SR));
  FDRE \shadow_loud_reg[24] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[24]),
        .Q(shadow_loud[24]),
        .R(SR));
  FDRE \shadow_loud_reg[25] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[25]),
        .Q(shadow_loud[25]),
        .R(SR));
  FDRE \shadow_loud_reg[26] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[26]),
        .Q(shadow_loud[26]),
        .R(SR));
  FDRE \shadow_loud_reg[27] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[27]),
        .Q(shadow_loud[27]),
        .R(SR));
  FDRE \shadow_loud_reg[28] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[28]),
        .Q(shadow_loud[28]),
        .R(SR));
  FDRE \shadow_loud_reg[29] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[29]),
        .Q(shadow_loud[29]),
        .R(SR));
  FDRE \shadow_loud_reg[2] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[2]),
        .Q(shadow_loud[2]),
        .R(SR));
  FDRE \shadow_loud_reg[30] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[30]),
        .Q(shadow_loud[30]),
        .R(SR));
  FDRE \shadow_loud_reg[31] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[31]),
        .Q(shadow_loud[31]),
        .R(SR));
  FDRE \shadow_loud_reg[3] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[3]),
        .Q(shadow_loud[3]),
        .R(SR));
  FDRE \shadow_loud_reg[4] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[4]),
        .Q(shadow_loud[4]),
        .R(SR));
  FDRE \shadow_loud_reg[5] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[5]),
        .Q(shadow_loud[5]),
        .R(SR));
  FDRE \shadow_loud_reg[6] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[6]),
        .Q(shadow_loud[6]),
        .R(SR));
  FDRE \shadow_loud_reg[7] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[7]),
        .Q(shadow_loud[7]),
        .R(SR));
  FDSE \shadow_loud_reg[8] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[8]),
        .Q(shadow_loud[8]),
        .S(SR));
  FDRE \shadow_loud_reg[9] 
       (.C(s_axi_aclk),
        .CE(shadow_loud_1),
        .D(write_data[9]),
        .Q(shadow_loud[9]),
        .R(SR));
  LUT4 #(
    .INIT(16'h0020)) 
    \shadow_quiet[31]_i_1 
       (.I0(\shadow_soft[31]_i_2_n_0 ),
        .I1(write_address[4]),
        .I2(write_address[3]),
        .I3(write_address[2]),
        .O(shadow_quiet_0));
  FDRE \shadow_quiet_reg[0] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[0]),
        .Q(shadow_quiet[0]),
        .R(SR));
  FDRE \shadow_quiet_reg[10] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[10]),
        .Q(shadow_quiet[10]),
        .R(SR));
  FDRE \shadow_quiet_reg[11] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[11]),
        .Q(shadow_quiet[11]),
        .R(SR));
  FDRE \shadow_quiet_reg[12] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[12]),
        .Q(shadow_quiet[12]),
        .R(SR));
  FDSE \shadow_quiet_reg[13] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[13]),
        .Q(shadow_quiet[13]),
        .S(SR));
  FDRE \shadow_quiet_reg[14] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[14]),
        .Q(shadow_quiet[14]),
        .R(SR));
  FDSE \shadow_quiet_reg[15] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[15]),
        .Q(shadow_quiet[15]),
        .S(SR));
  FDSE \shadow_quiet_reg[16] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[16]),
        .Q(shadow_quiet[16]),
        .S(SR));
  FDSE \shadow_quiet_reg[17] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[17]),
        .Q(shadow_quiet[17]),
        .S(SR));
  FDSE \shadow_quiet_reg[18] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[18]),
        .Q(shadow_quiet[18]),
        .S(SR));
  FDRE \shadow_quiet_reg[19] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[19]),
        .Q(shadow_quiet[19]),
        .R(SR));
  FDRE \shadow_quiet_reg[1] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[1]),
        .Q(shadow_quiet[1]),
        .R(SR));
  FDRE \shadow_quiet_reg[20] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[20]),
        .Q(shadow_quiet[20]),
        .R(SR));
  FDRE \shadow_quiet_reg[21] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[21]),
        .Q(shadow_quiet[21]),
        .R(SR));
  FDRE \shadow_quiet_reg[22] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[22]),
        .Q(shadow_quiet[22]),
        .R(SR));
  FDRE \shadow_quiet_reg[23] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[23]),
        .Q(shadow_quiet[23]),
        .R(SR));
  FDRE \shadow_quiet_reg[24] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[24]),
        .Q(shadow_quiet[24]),
        .R(SR));
  FDRE \shadow_quiet_reg[25] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[25]),
        .Q(shadow_quiet[25]),
        .R(SR));
  FDRE \shadow_quiet_reg[26] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[26]),
        .Q(shadow_quiet[26]),
        .R(SR));
  FDRE \shadow_quiet_reg[27] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[27]),
        .Q(shadow_quiet[27]),
        .R(SR));
  FDRE \shadow_quiet_reg[28] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[28]),
        .Q(shadow_quiet[28]),
        .R(SR));
  FDRE \shadow_quiet_reg[29] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[29]),
        .Q(shadow_quiet[29]),
        .R(SR));
  FDRE \shadow_quiet_reg[2] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[2]),
        .Q(shadow_quiet[2]),
        .R(SR));
  FDRE \shadow_quiet_reg[30] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[30]),
        .Q(shadow_quiet[30]),
        .R(SR));
  FDRE \shadow_quiet_reg[31] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[31]),
        .Q(shadow_quiet[31]),
        .R(SR));
  FDRE \shadow_quiet_reg[3] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[3]),
        .Q(shadow_quiet[3]),
        .R(SR));
  FDRE \shadow_quiet_reg[4] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[4]),
        .Q(shadow_quiet[4]),
        .R(SR));
  FDSE \shadow_quiet_reg[5] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[5]),
        .Q(shadow_quiet[5]),
        .S(SR));
  FDRE \shadow_quiet_reg[6] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[6]),
        .Q(shadow_quiet[6]),
        .R(SR));
  FDRE \shadow_quiet_reg[7] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[7]),
        .Q(shadow_quiet[7]),
        .R(SR));
  FDSE \shadow_quiet_reg[8] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[8]),
        .Q(shadow_quiet[8]),
        .S(SR));
  FDRE \shadow_quiet_reg[9] 
       (.C(s_axi_aclk),
        .CE(shadow_quiet_0),
        .D(write_data[9]),
        .Q(shadow_quiet[9]),
        .R(SR));
  LUT4 #(
    .INIT(16'h0002)) 
    \shadow_soft[31]_i_1 
       (.I0(\shadow_soft[31]_i_2_n_0 ),
        .I1(write_address[4]),
        .I2(write_address[3]),
        .I3(write_address[2]),
        .O(\shadow_soft[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \shadow_soft[31]_i_2 
       (.I0(\s_axi_bresp[1]_i_3_n_0 ),
        .I1(\soft_sum[31]_i_4_n_0 ),
        .O(\shadow_soft[31]_i_2_n_0 ));
  FDRE \shadow_soft_reg[0] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[0]),
        .Q(\shadow_soft_reg_n_0_[0] ),
        .R(SR));
  FDRE \shadow_soft_reg[10] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[10]),
        .Q(\shadow_soft_reg_n_0_[10] ),
        .R(SR));
  FDRE \shadow_soft_reg[11] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[11]),
        .Q(\shadow_soft_reg_n_0_[11] ),
        .R(SR));
  FDRE \shadow_soft_reg[12] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[12]),
        .Q(\shadow_soft_reg_n_0_[12] ),
        .R(SR));
  FDRE \shadow_soft_reg[13] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[13]),
        .Q(\shadow_soft_reg_n_0_[13] ),
        .R(SR));
  FDSE \shadow_soft_reg[14] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[14]),
        .Q(\shadow_soft_reg_n_0_[14] ),
        .S(SR));
  FDRE \shadow_soft_reg[15] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[15]),
        .Q(\shadow_soft_reg_n_0_[15] ),
        .R(SR));
  FDSE \shadow_soft_reg[16] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[16]),
        .Q(\shadow_soft_reg_n_0_[16] ),
        .S(SR));
  FDSE \shadow_soft_reg[17] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[17]),
        .Q(\shadow_soft_reg_n_0_[17] ),
        .S(SR));
  FDSE \shadow_soft_reg[18] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[18]),
        .Q(\shadow_soft_reg_n_0_[18] ),
        .S(SR));
  FDSE \shadow_soft_reg[19] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[19]),
        .Q(\shadow_soft_reg_n_0_[19] ),
        .S(SR));
  FDRE \shadow_soft_reg[1] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[1]),
        .Q(\shadow_soft_reg_n_0_[1] ),
        .R(SR));
  FDRE \shadow_soft_reg[20] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[20]),
        .Q(\shadow_soft_reg_n_0_[20] ),
        .R(SR));
  FDRE \shadow_soft_reg[21] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[21]),
        .Q(\shadow_soft_reg_n_0_[21] ),
        .R(SR));
  FDRE \shadow_soft_reg[22] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[22]),
        .Q(\shadow_soft_reg_n_0_[22] ),
        .R(SR));
  FDRE \shadow_soft_reg[23] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[23]),
        .Q(\shadow_soft_reg_n_0_[23] ),
        .R(SR));
  FDRE \shadow_soft_reg[24] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[24]),
        .Q(\shadow_soft_reg_n_0_[24] ),
        .R(SR));
  FDRE \shadow_soft_reg[25] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[25]),
        .Q(\shadow_soft_reg_n_0_[25] ),
        .R(SR));
  FDRE \shadow_soft_reg[26] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[26]),
        .Q(\shadow_soft_reg_n_0_[26] ),
        .R(SR));
  FDRE \shadow_soft_reg[27] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[27]),
        .Q(\shadow_soft_reg_n_0_[27] ),
        .R(SR));
  FDRE \shadow_soft_reg[28] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[28]),
        .Q(\shadow_soft_reg_n_0_[28] ),
        .R(SR));
  FDRE \shadow_soft_reg[29] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[29]),
        .Q(\shadow_soft_reg_n_0_[29] ),
        .R(SR));
  FDRE \shadow_soft_reg[2] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[2]),
        .Q(\shadow_soft_reg_n_0_[2] ),
        .R(SR));
  FDRE \shadow_soft_reg[30] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[30]),
        .Q(\shadow_soft_reg_n_0_[30] ),
        .R(SR));
  FDRE \shadow_soft_reg[31] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[31]),
        .Q(\shadow_soft_reg_n_0_[31] ),
        .R(SR));
  FDRE \shadow_soft_reg[3] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[3]),
        .Q(\shadow_soft_reg_n_0_[3] ),
        .R(SR));
  FDRE \shadow_soft_reg[4] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[4]),
        .Q(\shadow_soft_reg_n_0_[4] ),
        .R(SR));
  FDRE \shadow_soft_reg[5] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[5]),
        .Q(\shadow_soft_reg_n_0_[5] ),
        .R(SR));
  FDSE \shadow_soft_reg[6] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[6]),
        .Q(\shadow_soft_reg_n_0_[6] ),
        .S(SR));
  FDRE \shadow_soft_reg[7] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[7]),
        .Q(\shadow_soft_reg_n_0_[7] ),
        .R(SR));
  FDRE \shadow_soft_reg[8] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[8]),
        .Q(\shadow_soft_reg_n_0_[8] ),
        .R(SR));
  FDSE \shadow_soft_reg[9] 
       (.C(s_axi_aclk),
        .CE(\shadow_soft[31]_i_1_n_0 ),
        .D(write_data[9]),
        .Q(\shadow_soft_reg_n_0_[9] ),
        .S(SR));
  LUT6 #(
    .INIT(64'h0000000000010000)) 
    \snapshot[0][10]_i_1 
       (.I0(\snapshot[0][10]_i_2_n_0 ),
        .I1(\snapshot[0][10]_i_3_n_0 ),
        .I2(write_data[2]),
        .I3(write_data[0]),
        .I4(write_data[1]),
        .I5(\soft_sum[31]_i_4_n_0 ),
        .O(\snapshot[0][10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT4 #(
    .INIT(16'hFFEF)) 
    \snapshot[0][10]_i_2 
       (.I0(\s_axi_bresp[1]_i_9_n_0 ),
        .I1(write_address[2]),
        .I2(write_address[4]),
        .I3(write_address[3]),
        .O(\snapshot[0][10]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \snapshot[0][10]_i_3 
       (.I0(write_address[8]),
        .I1(write_address[10]),
        .I2(write_address[9]),
        .I3(\s_axi_bresp[1]_i_8_n_0 ),
        .O(\snapshot[0][10]_i_3_n_0 ));
  FDRE \snapshot_reg[0][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(status[0]),
        .Q(\snapshot_reg[0] [0]),
        .R(SR));
  FDRE \snapshot_reg[0][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(status[10]),
        .Q(\snapshot_reg[0] [10]),
        .R(SR));
  FDRE \snapshot_reg[0][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(status[1]),
        .Q(\snapshot_reg[0] [1]),
        .R(SR));
  FDRE \snapshot_reg[0][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(status0),
        .Q(\snapshot_reg[0] [2]),
        .R(SR));
  FDRE \snapshot_reg[0][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(out),
        .Q(\snapshot_reg[0] [3]),
        .R(SR));
  FDRE \snapshot_reg[0][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(status[4]),
        .Q(\snapshot_reg[0] [4]),
        .R(SR));
  FDRE \snapshot_reg[0][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(status[8]),
        .Q(\snapshot_reg[0] [8]),
        .R(SR));
  FDRE \snapshot_reg[0][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(status[9]),
        .Q(\snapshot_reg[0] [9]),
        .R(SR));
  FDRE \snapshot_reg[10][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_331),
        .Q(\snapshot_reg[10] [0]),
        .R(SR));
  FDRE \snapshot_reg[10][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_321),
        .Q(\snapshot_reg[10] [10]),
        .R(SR));
  FDRE \snapshot_reg[10][11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_320),
        .Q(\snapshot_reg[10] [11]),
        .R(SR));
  FDRE \snapshot_reg[10][12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_319),
        .Q(\snapshot_reg[10] [12]),
        .R(SR));
  FDRE \snapshot_reg[10][13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_318),
        .Q(\snapshot_reg[10] [13]),
        .R(SR));
  FDRE \snapshot_reg[10][14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_317),
        .Q(\snapshot_reg[10] [14]),
        .R(SR));
  FDRE \snapshot_reg[10][15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_316),
        .Q(\snapshot_reg[10] [15]),
        .R(SR));
  FDRE \snapshot_reg[10][16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_315),
        .Q(\snapshot_reg[10] [16]),
        .R(SR));
  FDRE \snapshot_reg[10][17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_314),
        .Q(\snapshot_reg[10] [17]),
        .R(SR));
  FDRE \snapshot_reg[10][18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_313),
        .Q(\snapshot_reg[10] [18]),
        .R(SR));
  FDRE \snapshot_reg[10][19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_312),
        .Q(\snapshot_reg[10] [19]),
        .R(SR));
  FDRE \snapshot_reg[10][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_330),
        .Q(\snapshot_reg[10] [1]),
        .R(SR));
  FDRE \snapshot_reg[10][20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_311),
        .Q(\snapshot_reg[10] [20]),
        .R(SR));
  FDRE \snapshot_reg[10][21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_310),
        .Q(\snapshot_reg[10] [21]),
        .R(SR));
  FDRE \snapshot_reg[10][22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_309),
        .Q(\snapshot_reg[10] [22]),
        .R(SR));
  FDRE \snapshot_reg[10][23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_308),
        .Q(\snapshot_reg[10] [23]),
        .R(SR));
  FDRE \snapshot_reg[10][24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_307),
        .Q(\snapshot_reg[10] [24]),
        .R(SR));
  FDRE \snapshot_reg[10][25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_306),
        .Q(\snapshot_reg[10] [25]),
        .R(SR));
  FDRE \snapshot_reg[10][26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_305),
        .Q(\snapshot_reg[10] [26]),
        .R(SR));
  FDRE \snapshot_reg[10][27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_304),
        .Q(\snapshot_reg[10] [27]),
        .R(SR));
  FDRE \snapshot_reg[10][28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_303),
        .Q(\snapshot_reg[10] [28]),
        .R(SR));
  FDRE \snapshot_reg[10][29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_302),
        .Q(\snapshot_reg[10] [29]),
        .R(SR));
  FDRE \snapshot_reg[10][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_329),
        .Q(\snapshot_reg[10] [2]),
        .R(SR));
  FDRE \snapshot_reg[10][30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_301),
        .Q(\snapshot_reg[10] [30]),
        .R(SR));
  FDRE \snapshot_reg[10][31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_300),
        .Q(\snapshot_reg[10] [31]),
        .R(SR));
  FDRE \snapshot_reg[10][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_328),
        .Q(\snapshot_reg[10] [3]),
        .R(SR));
  FDRE \snapshot_reg[10][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_327),
        .Q(\snapshot_reg[10] [4]),
        .R(SR));
  FDRE \snapshot_reg[10][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_326),
        .Q(\snapshot_reg[10] [5]),
        .R(SR));
  FDRE \snapshot_reg[10][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_325),
        .Q(\snapshot_reg[10] [6]),
        .R(SR));
  FDRE \snapshot_reg[10][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_324),
        .Q(\snapshot_reg[10] [7]),
        .R(SR));
  FDRE \snapshot_reg[10][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_323),
        .Q(\snapshot_reg[10] [8]),
        .R(SR));
  FDRE \snapshot_reg[10][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_322),
        .Q(\snapshot_reg[10] [9]),
        .R(SR));
  FDRE \snapshot_reg[11][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[0]),
        .Q(\snapshot_reg[11] [0]),
        .R(SR));
  FDRE \snapshot_reg[11][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[10]),
        .Q(\snapshot_reg[11] [10]),
        .R(SR));
  FDRE \snapshot_reg[11][11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[11]),
        .Q(\snapshot_reg[11] [11]),
        .R(SR));
  FDRE \snapshot_reg[11][12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[12]),
        .Q(\snapshot_reg[11] [12]),
        .R(SR));
  FDRE \snapshot_reg[11][13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[13]),
        .Q(\snapshot_reg[11] [13]),
        .R(SR));
  FDRE \snapshot_reg[11][14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[14]),
        .Q(\snapshot_reg[11] [14]),
        .R(SR));
  FDRE \snapshot_reg[11][15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[15]),
        .Q(\snapshot_reg[11] [15]),
        .R(SR));
  FDRE \snapshot_reg[11][16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[16]),
        .Q(\snapshot_reg[11] [16]),
        .R(SR));
  FDRE \snapshot_reg[11][17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[17]),
        .Q(\snapshot_reg[11] [17]),
        .R(SR));
  FDRE \snapshot_reg[11][18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[18]),
        .Q(\snapshot_reg[11] [18]),
        .R(SR));
  FDRE \snapshot_reg[11][19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[19]),
        .Q(\snapshot_reg[11] [19]),
        .R(SR));
  FDRE \snapshot_reg[11][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[1]),
        .Q(\snapshot_reg[11] [1]),
        .R(SR));
  FDRE \snapshot_reg[11][20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[20]),
        .Q(\snapshot_reg[11] [20]),
        .R(SR));
  FDRE \snapshot_reg[11][21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[21]),
        .Q(\snapshot_reg[11] [21]),
        .R(SR));
  FDRE \snapshot_reg[11][22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[22]),
        .Q(\snapshot_reg[11] [22]),
        .R(SR));
  FDRE \snapshot_reg[11][23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[23]),
        .Q(\snapshot_reg[11] [23]),
        .R(SR));
  FDRE \snapshot_reg[11][24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[24]),
        .Q(\snapshot_reg[11] [24]),
        .R(SR));
  FDRE \snapshot_reg[11][25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[25]),
        .Q(\snapshot_reg[11] [25]),
        .R(SR));
  FDRE \snapshot_reg[11][26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[26]),
        .Q(\snapshot_reg[11] [26]),
        .R(SR));
  FDRE \snapshot_reg[11][27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[27]),
        .Q(\snapshot_reg[11] [27]),
        .R(SR));
  FDRE \snapshot_reg[11][28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[28]),
        .Q(\snapshot_reg[11] [28]),
        .R(SR));
  FDRE \snapshot_reg[11][29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[29]),
        .Q(\snapshot_reg[11] [29]),
        .R(SR));
  FDRE \snapshot_reg[11][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[2]),
        .Q(\snapshot_reg[11] [2]),
        .R(SR));
  FDRE \snapshot_reg[11][30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[30]),
        .Q(\snapshot_reg[11] [30]),
        .R(SR));
  FDRE \snapshot_reg[11][31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[31]),
        .Q(\snapshot_reg[11] [31]),
        .R(SR));
  FDRE \snapshot_reg[11][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[3]),
        .Q(\snapshot_reg[11] [3]),
        .R(SR));
  FDRE \snapshot_reg[11][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[4]),
        .Q(\snapshot_reg[11] [4]),
        .R(SR));
  FDRE \snapshot_reg[11][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[5]),
        .Q(\snapshot_reg[11] [5]),
        .R(SR));
  FDRE \snapshot_reg[11][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[6]),
        .Q(\snapshot_reg[11] [6]),
        .R(SR));
  FDRE \snapshot_reg[11][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[7]),
        .Q(\snapshot_reg[11] [7]),
        .R(SR));
  FDRE \snapshot_reg[11][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[8]),
        .Q(\snapshot_reg[11] [8]),
        .R(SR));
  FDRE \snapshot_reg[11][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_5_in[9]),
        .Q(\snapshot_reg[11] [9]),
        .R(SR));
  FDRE \snapshot_reg[12][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[0]),
        .Q(\snapshot_reg[12] [0]),
        .R(SR));
  FDRE \snapshot_reg[12][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[10]),
        .Q(\snapshot_reg[12] [10]),
        .R(SR));
  FDRE \snapshot_reg[12][11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[11]),
        .Q(\snapshot_reg[12] [11]),
        .R(SR));
  FDRE \snapshot_reg[12][12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[12]),
        .Q(\snapshot_reg[12] [12]),
        .R(SR));
  FDRE \snapshot_reg[12][13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[13]),
        .Q(\snapshot_reg[12] [13]),
        .R(SR));
  FDRE \snapshot_reg[12][14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[14]),
        .Q(\snapshot_reg[12] [14]),
        .R(SR));
  FDRE \snapshot_reg[12][15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[15]),
        .Q(\snapshot_reg[12] [15]),
        .R(SR));
  FDRE \snapshot_reg[12][16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[16]),
        .Q(\snapshot_reg[12] [16]),
        .R(SR));
  FDRE \snapshot_reg[12][17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[17]),
        .Q(\snapshot_reg[12] [17]),
        .R(SR));
  FDRE \snapshot_reg[12][18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[18]),
        .Q(\snapshot_reg[12] [18]),
        .R(SR));
  FDRE \snapshot_reg[12][19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[19]),
        .Q(\snapshot_reg[12] [19]),
        .R(SR));
  FDRE \snapshot_reg[12][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[1]),
        .Q(\snapshot_reg[12] [1]),
        .R(SR));
  FDRE \snapshot_reg[12][20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[20]),
        .Q(\snapshot_reg[12] [20]),
        .R(SR));
  FDRE \snapshot_reg[12][21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[21]),
        .Q(\snapshot_reg[12] [21]),
        .R(SR));
  FDRE \snapshot_reg[12][22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[22]),
        .Q(\snapshot_reg[12] [22]),
        .R(SR));
  FDRE \snapshot_reg[12][23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[23]),
        .Q(\snapshot_reg[12] [23]),
        .R(SR));
  FDRE \snapshot_reg[12][24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[24]),
        .Q(\snapshot_reg[12] [24]),
        .R(SR));
  FDRE \snapshot_reg[12][25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[25]),
        .Q(\snapshot_reg[12] [25]),
        .R(SR));
  FDRE \snapshot_reg[12][26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[26]),
        .Q(\snapshot_reg[12] [26]),
        .R(SR));
  FDRE \snapshot_reg[12][27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[27]),
        .Q(\snapshot_reg[12] [27]),
        .R(SR));
  FDRE \snapshot_reg[12][28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[28]),
        .Q(\snapshot_reg[12] [28]),
        .R(SR));
  FDRE \snapshot_reg[12][29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[29]),
        .Q(\snapshot_reg[12] [29]),
        .R(SR));
  FDRE \snapshot_reg[12][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[2]),
        .Q(\snapshot_reg[12] [2]),
        .R(SR));
  FDRE \snapshot_reg[12][30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[30]),
        .Q(\snapshot_reg[12] [30]),
        .R(SR));
  FDRE \snapshot_reg[12][31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[31]),
        .Q(\snapshot_reg[12] [31]),
        .R(SR));
  FDRE \snapshot_reg[12][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[3]),
        .Q(\snapshot_reg[12] [3]),
        .R(SR));
  FDRE \snapshot_reg[12][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[4]),
        .Q(\snapshot_reg[12] [4]),
        .R(SR));
  FDRE \snapshot_reg[12][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[5]),
        .Q(\snapshot_reg[12] [5]),
        .R(SR));
  FDRE \snapshot_reg[12][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[6]),
        .Q(\snapshot_reg[12] [6]),
        .R(SR));
  FDRE \snapshot_reg[12][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[7]),
        .Q(\snapshot_reg[12] [7]),
        .R(SR));
  FDRE \snapshot_reg[12][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[8]),
        .Q(\snapshot_reg[12] [8]),
        .R(SR));
  FDRE \snapshot_reg[12][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_window[9]),
        .Q(\snapshot_reg[12] [9]),
        .R(SR));
  FDRE \snapshot_reg[13][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[0]),
        .Q(\snapshot_reg[13] [0]),
        .R(SR));
  FDRE \snapshot_reg[13][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[10]),
        .Q(\snapshot_reg[13] [10]),
        .R(SR));
  FDRE \snapshot_reg[13][11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[11]),
        .Q(\snapshot_reg[13] [11]),
        .R(SR));
  FDRE \snapshot_reg[13][12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[12]),
        .Q(\snapshot_reg[13] [12]),
        .R(SR));
  FDRE \snapshot_reg[13][13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[13]),
        .Q(\snapshot_reg[13] [13]),
        .R(SR));
  FDRE \snapshot_reg[13][14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[14]),
        .Q(\snapshot_reg[13] [14]),
        .R(SR));
  FDRE \snapshot_reg[13][15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[15]),
        .Q(\snapshot_reg[13] [15]),
        .R(SR));
  FDRE \snapshot_reg[13][16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[16]),
        .Q(\snapshot_reg[13] [16]),
        .R(SR));
  FDRE \snapshot_reg[13][17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[17]),
        .Q(\snapshot_reg[13] [17]),
        .R(SR));
  FDRE \snapshot_reg[13][18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[18]),
        .Q(\snapshot_reg[13] [18]),
        .R(SR));
  FDRE \snapshot_reg[13][19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[19]),
        .Q(\snapshot_reg[13] [19]),
        .R(SR));
  FDRE \snapshot_reg[13][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[1]),
        .Q(\snapshot_reg[13] [1]),
        .R(SR));
  FDRE \snapshot_reg[13][20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[20]),
        .Q(\snapshot_reg[13] [20]),
        .R(SR));
  FDRE \snapshot_reg[13][21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[21]),
        .Q(\snapshot_reg[13] [21]),
        .R(SR));
  FDRE \snapshot_reg[13][22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[22]),
        .Q(\snapshot_reg[13] [22]),
        .R(SR));
  FDRE \snapshot_reg[13][23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[23]),
        .Q(\snapshot_reg[13] [23]),
        .R(SR));
  FDRE \snapshot_reg[13][24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[24]),
        .Q(\snapshot_reg[13] [24]),
        .R(SR));
  FDRE \snapshot_reg[13][25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[25]),
        .Q(\snapshot_reg[13] [25]),
        .R(SR));
  FDRE \snapshot_reg[13][26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[26]),
        .Q(\snapshot_reg[13] [26]),
        .R(SR));
  FDRE \snapshot_reg[13][27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[27]),
        .Q(\snapshot_reg[13] [27]),
        .R(SR));
  FDRE \snapshot_reg[13][28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[28]),
        .Q(\snapshot_reg[13] [28]),
        .R(SR));
  FDRE \snapshot_reg[13][29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[29]),
        .Q(\snapshot_reg[13] [29]),
        .R(SR));
  FDRE \snapshot_reg[13][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[2]),
        .Q(\snapshot_reg[13] [2]),
        .R(SR));
  FDRE \snapshot_reg[13][30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[30]),
        .Q(\snapshot_reg[13] [30]),
        .R(SR));
  FDRE \snapshot_reg[13][31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[31]),
        .Q(\snapshot_reg[13] [31]),
        .R(SR));
  FDRE \snapshot_reg[13][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[3]),
        .Q(\snapshot_reg[13] [3]),
        .R(SR));
  FDRE \snapshot_reg[13][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[4]),
        .Q(\snapshot_reg[13] [4]),
        .R(SR));
  FDRE \snapshot_reg[13][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[5]),
        .Q(\snapshot_reg[13] [5]),
        .R(SR));
  FDRE \snapshot_reg[13][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[6]),
        .Q(\snapshot_reg[13] [6]),
        .R(SR));
  FDRE \snapshot_reg[13][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[7]),
        .Q(\snapshot_reg[13] [7]),
        .R(SR));
  FDRE \snapshot_reg[13][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[8]),
        .Q(\snapshot_reg[13] [8]),
        .R(SR));
  FDRE \snapshot_reg[13][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_age[9]),
        .Q(\snapshot_reg[13] [9]),
        .R(SR));
  FDRE \snapshot_reg[14][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[0] ),
        .Q(\snapshot_reg[14] [0]),
        .R(SR));
  FDRE \snapshot_reg[14][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[10] ),
        .Q(\snapshot_reg[14] [10]),
        .R(SR));
  FDRE \snapshot_reg[14][11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[11] ),
        .Q(\snapshot_reg[14] [11]),
        .R(SR));
  FDRE \snapshot_reg[14][12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[12] ),
        .Q(\snapshot_reg[14] [12]),
        .R(SR));
  FDRE \snapshot_reg[14][13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[13] ),
        .Q(\snapshot_reg[14] [13]),
        .R(SR));
  FDRE \snapshot_reg[14][14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[14] ),
        .Q(\snapshot_reg[14] [14]),
        .R(SR));
  FDRE \snapshot_reg[14][15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[15] ),
        .Q(\snapshot_reg[14] [15]),
        .R(SR));
  FDRE \snapshot_reg[14][16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[16] ),
        .Q(\snapshot_reg[14] [16]),
        .R(SR));
  FDRE \snapshot_reg[14][17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[17] ),
        .Q(\snapshot_reg[14] [17]),
        .R(SR));
  FDRE \snapshot_reg[14][18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[18] ),
        .Q(\snapshot_reg[14] [18]),
        .R(SR));
  FDRE \snapshot_reg[14][19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[19] ),
        .Q(\snapshot_reg[14] [19]),
        .R(SR));
  FDRE \snapshot_reg[14][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[1] ),
        .Q(\snapshot_reg[14] [1]),
        .R(SR));
  FDRE \snapshot_reg[14][20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[20] ),
        .Q(\snapshot_reg[14] [20]),
        .R(SR));
  FDRE \snapshot_reg[14][21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[21] ),
        .Q(\snapshot_reg[14] [21]),
        .R(SR));
  FDRE \snapshot_reg[14][22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[22] ),
        .Q(\snapshot_reg[14] [22]),
        .R(SR));
  FDRE \snapshot_reg[14][23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[23] ),
        .Q(\snapshot_reg[14] [23]),
        .R(SR));
  FDRE \snapshot_reg[14][24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[24] ),
        .Q(\snapshot_reg[14] [24]),
        .R(SR));
  FDRE \snapshot_reg[14][25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[25] ),
        .Q(\snapshot_reg[14] [25]),
        .R(SR));
  FDRE \snapshot_reg[14][26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[26] ),
        .Q(\snapshot_reg[14] [26]),
        .R(SR));
  FDRE \snapshot_reg[14][27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[27] ),
        .Q(\snapshot_reg[14] [27]),
        .R(SR));
  FDRE \snapshot_reg[14][28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[28] ),
        .Q(\snapshot_reg[14] [28]),
        .R(SR));
  FDRE \snapshot_reg[14][29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[29] ),
        .Q(\snapshot_reg[14] [29]),
        .R(SR));
  FDRE \snapshot_reg[14][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[2] ),
        .Q(\snapshot_reg[14] [2]),
        .R(SR));
  FDRE \snapshot_reg[14][30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[30] ),
        .Q(\snapshot_reg[14] [30]),
        .R(SR));
  FDRE \snapshot_reg[14][31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[31] ),
        .Q(\snapshot_reg[14] [31]),
        .R(SR));
  FDRE \snapshot_reg[14][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[3] ),
        .Q(\snapshot_reg[14] [3]),
        .R(SR));
  FDRE \snapshot_reg[14][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[4] ),
        .Q(\snapshot_reg[14] [4]),
        .R(SR));
  FDRE \snapshot_reg[14][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[5] ),
        .Q(\snapshot_reg[14] [5]),
        .R(SR));
  FDRE \snapshot_reg[14][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[6] ),
        .Q(\snapshot_reg[14] [6]),
        .R(SR));
  FDRE \snapshot_reg[14][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[7] ),
        .Q(\snapshot_reg[14] [7]),
        .R(SR));
  FDRE \snapshot_reg[14][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[8] ),
        .Q(\snapshot_reg[14] [8]),
        .R(SR));
  FDRE \snapshot_reg[14][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\soft_sum_reg_n_0_[9] ),
        .Q(\snapshot_reg[14] [9]),
        .R(SR));
  FDRE \snapshot_reg[15][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[0]),
        .Q(\snapshot_reg[15] [0]),
        .R(SR));
  FDRE \snapshot_reg[15][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[10]),
        .Q(\snapshot_reg[15] [10]),
        .R(SR));
  FDRE \snapshot_reg[15][11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[11]),
        .Q(\snapshot_reg[15] [11]),
        .R(SR));
  FDRE \snapshot_reg[15][12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[12]),
        .Q(\snapshot_reg[15] [12]),
        .R(SR));
  FDRE \snapshot_reg[15][13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[13]),
        .Q(\snapshot_reg[15] [13]),
        .R(SR));
  FDRE \snapshot_reg[15][14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[14]),
        .Q(\snapshot_reg[15] [14]),
        .R(SR));
  FDRE \snapshot_reg[15][15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[15]),
        .Q(\snapshot_reg[15] [15]),
        .R(SR));
  FDRE \snapshot_reg[15][16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[16]),
        .Q(\snapshot_reg[15] [16]),
        .R(SR));
  FDRE \snapshot_reg[15][17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[17]),
        .Q(\snapshot_reg[15] [17]),
        .R(SR));
  FDRE \snapshot_reg[15][18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[18]),
        .Q(\snapshot_reg[15] [18]),
        .R(SR));
  FDRE \snapshot_reg[15][19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[19]),
        .Q(\snapshot_reg[15] [19]),
        .R(SR));
  FDRE \snapshot_reg[15][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[1]),
        .Q(\snapshot_reg[15] [1]),
        .R(SR));
  FDRE \snapshot_reg[15][20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[20]),
        .Q(\snapshot_reg[15] [20]),
        .R(SR));
  FDRE \snapshot_reg[15][21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[21]),
        .Q(\snapshot_reg[15] [21]),
        .R(SR));
  FDRE \snapshot_reg[15][22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[22]),
        .Q(\snapshot_reg[15] [22]),
        .R(SR));
  FDRE \snapshot_reg[15][23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[23]),
        .Q(\snapshot_reg[15] [23]),
        .R(SR));
  FDRE \snapshot_reg[15][24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[24]),
        .Q(\snapshot_reg[15] [24]),
        .R(SR));
  FDRE \snapshot_reg[15][25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[25]),
        .Q(\snapshot_reg[15] [25]),
        .R(SR));
  FDRE \snapshot_reg[15][26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[26]),
        .Q(\snapshot_reg[15] [26]),
        .R(SR));
  FDRE \snapshot_reg[15][27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[27]),
        .Q(\snapshot_reg[15] [27]),
        .R(SR));
  FDRE \snapshot_reg[15][28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[28]),
        .Q(\snapshot_reg[15] [28]),
        .R(SR));
  FDRE \snapshot_reg[15][29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[29]),
        .Q(\snapshot_reg[15] [29]),
        .R(SR));
  FDRE \snapshot_reg[15][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[2]),
        .Q(\snapshot_reg[15] [2]),
        .R(SR));
  FDRE \snapshot_reg[15][30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[30]),
        .Q(\snapshot_reg[15] [30]),
        .R(SR));
  FDRE \snapshot_reg[15][31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[31]),
        .Q(\snapshot_reg[15] [31]),
        .R(SR));
  FDRE \snapshot_reg[15][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[3]),
        .Q(\snapshot_reg[15] [3]),
        .R(SR));
  FDRE \snapshot_reg[15][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[4]),
        .Q(\snapshot_reg[15] [4]),
        .R(SR));
  FDRE \snapshot_reg[15][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[5]),
        .Q(\snapshot_reg[15] [5]),
        .R(SR));
  FDRE \snapshot_reg[15][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[6]),
        .Q(\snapshot_reg[15] [6]),
        .R(SR));
  FDRE \snapshot_reg[15][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[7]),
        .Q(\snapshot_reg[15] [7]),
        .R(SR));
  FDRE \snapshot_reg[15][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[8]),
        .Q(\snapshot_reg[15] [8]),
        .R(SR));
  FDRE \snapshot_reg[15][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(loud_sum[9]),
        .Q(\snapshot_reg[15] [9]),
        .R(SR));
  FDRE \snapshot_reg[16][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[0]),
        .Q(\snapshot_reg[16] [0]),
        .R(SR));
  FDRE \snapshot_reg[16][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[10]),
        .Q(\snapshot_reg[16] [10]),
        .R(SR));
  FDRE \snapshot_reg[16][11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[11]),
        .Q(\snapshot_reg[16] [11]),
        .R(SR));
  FDRE \snapshot_reg[16][12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[12]),
        .Q(\snapshot_reg[16] [12]),
        .R(SR));
  FDRE \snapshot_reg[16][13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[13]),
        .Q(\snapshot_reg[16] [13]),
        .R(SR));
  FDRE \snapshot_reg[16][14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[14]),
        .Q(\snapshot_reg[16] [14]),
        .R(SR));
  FDRE \snapshot_reg[16][15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[15]),
        .Q(\snapshot_reg[16] [15]),
        .R(SR));
  FDRE \snapshot_reg[16][16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[16]),
        .Q(\snapshot_reg[16] [16]),
        .R(SR));
  FDRE \snapshot_reg[16][17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[17]),
        .Q(\snapshot_reg[16] [17]),
        .R(SR));
  FDRE \snapshot_reg[16][18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[18]),
        .Q(\snapshot_reg[16] [18]),
        .R(SR));
  FDRE \snapshot_reg[16][19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[19]),
        .Q(\snapshot_reg[16] [19]),
        .R(SR));
  FDRE \snapshot_reg[16][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[1]),
        .Q(\snapshot_reg[16] [1]),
        .R(SR));
  FDRE \snapshot_reg[16][20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[20]),
        .Q(\snapshot_reg[16] [20]),
        .R(SR));
  FDRE \snapshot_reg[16][21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[21]),
        .Q(\snapshot_reg[16] [21]),
        .R(SR));
  FDRE \snapshot_reg[16][22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[22]),
        .Q(\snapshot_reg[16] [22]),
        .R(SR));
  FDRE \snapshot_reg[16][23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[23]),
        .Q(\snapshot_reg[16] [23]),
        .R(SR));
  FDRE \snapshot_reg[16][24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[24]),
        .Q(\snapshot_reg[16] [24]),
        .R(SR));
  FDRE \snapshot_reg[16][25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[25]),
        .Q(\snapshot_reg[16] [25]),
        .R(SR));
  FDRE \snapshot_reg[16][26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[26]),
        .Q(\snapshot_reg[16] [26]),
        .R(SR));
  FDRE \snapshot_reg[16][27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[27]),
        .Q(\snapshot_reg[16] [27]),
        .R(SR));
  FDRE \snapshot_reg[16][28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[28]),
        .Q(\snapshot_reg[16] [28]),
        .R(SR));
  FDRE \snapshot_reg[16][29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[29]),
        .Q(\snapshot_reg[16] [29]),
        .R(SR));
  FDRE \snapshot_reg[16][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[2]),
        .Q(\snapshot_reg[16] [2]),
        .R(SR));
  FDRE \snapshot_reg[16][30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[30]),
        .Q(\snapshot_reg[16] [30]),
        .R(SR));
  FDRE \snapshot_reg[16][31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[31]),
        .Q(\snapshot_reg[16] [31]),
        .R(SR));
  FDRE \snapshot_reg[16][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[3]),
        .Q(\snapshot_reg[16] [3]),
        .R(SR));
  FDRE \snapshot_reg[16][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[4]),
        .Q(\snapshot_reg[16] [4]),
        .R(SR));
  FDRE \snapshot_reg[16][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[5]),
        .Q(\snapshot_reg[16] [5]),
        .R(SR));
  FDRE \snapshot_reg[16][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[6]),
        .Q(\snapshot_reg[16] [6]),
        .R(SR));
  FDRE \snapshot_reg[16][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[7]),
        .Q(\snapshot_reg[16] [7]),
        .R(SR));
  FDRE \snapshot_reg[16][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[8]),
        .Q(\snapshot_reg[16] [8]),
        .R(SR));
  FDRE \snapshot_reg[16][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(quiet_sum[9]),
        .Q(\snapshot_reg[16] [9]),
        .R(SR));
  FDRE \snapshot_reg[1][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(faults[0]),
        .Q(\snapshot_reg[1] [0]),
        .R(SR));
  FDRE \snapshot_reg[1][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(faults[1]),
        .Q(\snapshot_reg[1] [1]),
        .R(SR));
  FDRE \snapshot_reg[1][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(faults[2]),
        .Q(\snapshot_reg[1] [2]),
        .R(SR));
  FDRE \snapshot_reg[1][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(faults[3]),
        .Q(\snapshot_reg[1] [3]),
        .R(SR));
  FDRE \snapshot_reg[1][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(faults[4]),
        .Q(\snapshot_reg[1] [4]),
        .R(SR));
  FDRE \snapshot_reg[1][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(faults[5]),
        .Q(\snapshot_reg[1] [5]),
        .R(SR));
  FDRE \snapshot_reg[1][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(faults[6]),
        .Q(\snapshot_reg[1] [6]),
        .R(SR));
  FDRE \snapshot_reg[1][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(faults[7]),
        .Q(\snapshot_reg[1] [7]),
        .R(SR));
  FDRE \snapshot_reg[2][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[0]),
        .Q(\snapshot_reg[2] [0]),
        .R(SR));
  FDRE \snapshot_reg[2][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[10]),
        .Q(\snapshot_reg[2] [10]),
        .R(SR));
  FDRE \snapshot_reg[2][11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[11]),
        .Q(\snapshot_reg[2] [11]),
        .R(SR));
  FDRE \snapshot_reg[2][12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[12]),
        .Q(\snapshot_reg[2] [12]),
        .R(SR));
  FDRE \snapshot_reg[2][13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[13]),
        .Q(\snapshot_reg[2] [13]),
        .R(SR));
  FDRE \snapshot_reg[2][14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[14]),
        .Q(\snapshot_reg[2] [14]),
        .R(SR));
  FDRE \snapshot_reg[2][15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[15]),
        .Q(\snapshot_reg[2] [15]),
        .R(SR));
  FDRE \snapshot_reg[2][16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[16]),
        .Q(\snapshot_reg[2] [16]),
        .R(SR));
  FDRE \snapshot_reg[2][17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[17]),
        .Q(\snapshot_reg[2] [17]),
        .R(SR));
  FDRE \snapshot_reg[2][18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[18]),
        .Q(\snapshot_reg[2] [18]),
        .R(SR));
  FDRE \snapshot_reg[2][19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[19]),
        .Q(\snapshot_reg[2] [19]),
        .R(SR));
  FDRE \snapshot_reg[2][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[1]),
        .Q(\snapshot_reg[2] [1]),
        .R(SR));
  FDRE \snapshot_reg[2][20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[20]),
        .Q(\snapshot_reg[2] [20]),
        .R(SR));
  FDRE \snapshot_reg[2][21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[21]),
        .Q(\snapshot_reg[2] [21]),
        .R(SR));
  FDRE \snapshot_reg[2][22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[22]),
        .Q(\snapshot_reg[2] [22]),
        .R(SR));
  FDRE \snapshot_reg[2][23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[23]),
        .Q(\snapshot_reg[2] [23]),
        .R(SR));
  FDRE \snapshot_reg[2][24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[24]),
        .Q(\snapshot_reg[2] [24]),
        .R(SR));
  FDRE \snapshot_reg[2][25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[25]),
        .Q(\snapshot_reg[2] [25]),
        .R(SR));
  FDRE \snapshot_reg[2][26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[26]),
        .Q(\snapshot_reg[2] [26]),
        .R(SR));
  FDRE \snapshot_reg[2][27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[27]),
        .Q(\snapshot_reg[2] [27]),
        .R(SR));
  FDRE \snapshot_reg[2][28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[28]),
        .Q(\snapshot_reg[2] [28]),
        .R(SR));
  FDRE \snapshot_reg[2][29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[29]),
        .Q(\snapshot_reg[2] [29]),
        .R(SR));
  FDRE \snapshot_reg[2][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[2]),
        .Q(\snapshot_reg[2] [2]),
        .R(SR));
  FDRE \snapshot_reg[2][30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[30]),
        .Q(\snapshot_reg[2] [30]),
        .R(SR));
  FDRE \snapshot_reg[2][31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[31]),
        .Q(\snapshot_reg[2] [31]),
        .R(SR));
  FDRE \snapshot_reg[2][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[3]),
        .Q(\snapshot_reg[2] [3]),
        .R(SR));
  FDRE \snapshot_reg[2][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[4]),
        .Q(\snapshot_reg[2] [4]),
        .R(SR));
  FDRE \snapshot_reg[2][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[5]),
        .Q(\snapshot_reg[2] [5]),
        .R(SR));
  FDRE \snapshot_reg[2][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[6]),
        .Q(\snapshot_reg[2] [6]),
        .R(SR));
  FDRE \snapshot_reg[2][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[7]),
        .Q(\snapshot_reg[2] [7]),
        .R(SR));
  FDRE \snapshot_reg[2][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[8]),
        .Q(\snapshot_reg[2] [8]),
        .R(SR));
  FDRE \snapshot_reg[2][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(config_epoch_reg[9]),
        .Q(\snapshot_reg[2] [9]),
        .R(SR));
  FDRE \snapshot_reg[3][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_63),
        .Q(\snapshot_reg[3] [0]),
        .R(SR));
  FDRE \snapshot_reg[3][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_53),
        .Q(\snapshot_reg[3] [10]),
        .R(SR));
  FDRE \snapshot_reg[3][11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_52),
        .Q(\snapshot_reg[3] [11]),
        .R(SR));
  FDRE \snapshot_reg[3][12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_51),
        .Q(\snapshot_reg[3] [12]),
        .R(SR));
  FDRE \snapshot_reg[3][13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_50),
        .Q(\snapshot_reg[3] [13]),
        .R(SR));
  FDRE \snapshot_reg[3][14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_49),
        .Q(\snapshot_reg[3] [14]),
        .R(SR));
  FDRE \snapshot_reg[3][15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_48),
        .Q(\snapshot_reg[3] [15]),
        .R(SR));
  FDRE \snapshot_reg[3][16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_47),
        .Q(\snapshot_reg[3] [16]),
        .R(SR));
  FDRE \snapshot_reg[3][17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_46),
        .Q(\snapshot_reg[3] [17]),
        .R(SR));
  FDRE \snapshot_reg[3][18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_45),
        .Q(\snapshot_reg[3] [18]),
        .R(SR));
  FDRE \snapshot_reg[3][19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_44),
        .Q(\snapshot_reg[3] [19]),
        .R(SR));
  FDRE \snapshot_reg[3][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_62),
        .Q(\snapshot_reg[3] [1]),
        .R(SR));
  FDRE \snapshot_reg[3][20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_43),
        .Q(\snapshot_reg[3] [20]),
        .R(SR));
  FDRE \snapshot_reg[3][21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_42),
        .Q(\snapshot_reg[3] [21]),
        .R(SR));
  FDRE \snapshot_reg[3][22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_41),
        .Q(\snapshot_reg[3] [22]),
        .R(SR));
  FDRE \snapshot_reg[3][23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_40),
        .Q(\snapshot_reg[3] [23]),
        .R(SR));
  FDRE \snapshot_reg[3][24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_39),
        .Q(\snapshot_reg[3] [24]),
        .R(SR));
  FDRE \snapshot_reg[3][25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_38),
        .Q(\snapshot_reg[3] [25]),
        .R(SR));
  FDRE \snapshot_reg[3][26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_37),
        .Q(\snapshot_reg[3] [26]),
        .R(SR));
  FDRE \snapshot_reg[3][27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_36),
        .Q(\snapshot_reg[3] [27]),
        .R(SR));
  FDRE \snapshot_reg[3][28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_35),
        .Q(\snapshot_reg[3] [28]),
        .R(SR));
  FDRE \snapshot_reg[3][29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_34),
        .Q(\snapshot_reg[3] [29]),
        .R(SR));
  FDRE \snapshot_reg[3][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_61),
        .Q(\snapshot_reg[3] [2]),
        .R(SR));
  FDRE \snapshot_reg[3][30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_33),
        .Q(\snapshot_reg[3] [30]),
        .R(SR));
  FDRE \snapshot_reg[3][31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_32),
        .Q(\snapshot_reg[3] [31]),
        .R(SR));
  FDRE \snapshot_reg[3][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_60),
        .Q(\snapshot_reg[3] [3]),
        .R(SR));
  FDRE \snapshot_reg[3][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_59),
        .Q(\snapshot_reg[3] [4]),
        .R(SR));
  FDRE \snapshot_reg[3][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_58),
        .Q(\snapshot_reg[3] [5]),
        .R(SR));
  FDRE \snapshot_reg[3][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_57),
        .Q(\snapshot_reg[3] [6]),
        .R(SR));
  FDRE \snapshot_reg[3][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_56),
        .Q(\snapshot_reg[3] [7]),
        .R(SR));
  FDRE \snapshot_reg[3][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_55),
        .Q(\snapshot_reg[3] [8]),
        .R(SR));
  FDRE \snapshot_reg[3][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(core_n_54),
        .Q(\snapshot_reg[3] [9]),
        .R(SR));
  FDRE \snapshot_reg[4][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[0]),
        .Q(\snapshot_reg[4] [0]),
        .R(SR));
  FDRE \snapshot_reg[4][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[10]),
        .Q(\snapshot_reg[4] [10]),
        .R(SR));
  FDRE \snapshot_reg[4][11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[11]),
        .Q(\snapshot_reg[4] [11]),
        .R(SR));
  FDRE \snapshot_reg[4][12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[12]),
        .Q(\snapshot_reg[4] [12]),
        .R(SR));
  FDRE \snapshot_reg[4][13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[13]),
        .Q(\snapshot_reg[4] [13]),
        .R(SR));
  FDRE \snapshot_reg[4][14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[14]),
        .Q(\snapshot_reg[4] [14]),
        .R(SR));
  FDRE \snapshot_reg[4][15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[15]),
        .Q(\snapshot_reg[4] [15]),
        .R(SR));
  FDRE \snapshot_reg[4][16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[16]),
        .Q(\snapshot_reg[4] [16]),
        .R(SR));
  FDRE \snapshot_reg[4][17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[17]),
        .Q(\snapshot_reg[4] [17]),
        .R(SR));
  FDRE \snapshot_reg[4][18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[18]),
        .Q(\snapshot_reg[4] [18]),
        .R(SR));
  FDRE \snapshot_reg[4][19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[19]),
        .Q(\snapshot_reg[4] [19]),
        .R(SR));
  FDRE \snapshot_reg[4][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[1]),
        .Q(\snapshot_reg[4] [1]),
        .R(SR));
  FDRE \snapshot_reg[4][20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[20]),
        .Q(\snapshot_reg[4] [20]),
        .R(SR));
  FDRE \snapshot_reg[4][21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[21]),
        .Q(\snapshot_reg[4] [21]),
        .R(SR));
  FDRE \snapshot_reg[4][22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[22]),
        .Q(\snapshot_reg[4] [22]),
        .R(SR));
  FDRE \snapshot_reg[4][23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[23]),
        .Q(\snapshot_reg[4] [23]),
        .R(SR));
  FDRE \snapshot_reg[4][24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[24]),
        .Q(\snapshot_reg[4] [24]),
        .R(SR));
  FDRE \snapshot_reg[4][25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[25]),
        .Q(\snapshot_reg[4] [25]),
        .R(SR));
  FDRE \snapshot_reg[4][26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[26]),
        .Q(\snapshot_reg[4] [26]),
        .R(SR));
  FDRE \snapshot_reg[4][27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[27]),
        .Q(\snapshot_reg[4] [27]),
        .R(SR));
  FDRE \snapshot_reg[4][28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[28]),
        .Q(\snapshot_reg[4] [28]),
        .R(SR));
  FDRE \snapshot_reg[4][29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[29]),
        .Q(\snapshot_reg[4] [29]),
        .R(SR));
  FDRE \snapshot_reg[4][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[2]),
        .Q(\snapshot_reg[4] [2]),
        .R(SR));
  FDRE \snapshot_reg[4][30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[30]),
        .Q(\snapshot_reg[4] [30]),
        .R(SR));
  FDRE \snapshot_reg[4][31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[31]),
        .Q(\snapshot_reg[4] [31]),
        .R(SR));
  FDRE \snapshot_reg[4][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[3]),
        .Q(\snapshot_reg[4] [3]),
        .R(SR));
  FDRE \snapshot_reg[4][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[4]),
        .Q(\snapshot_reg[4] [4]),
        .R(SR));
  FDRE \snapshot_reg[4][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[5]),
        .Q(\snapshot_reg[4] [5]),
        .R(SR));
  FDRE \snapshot_reg[4][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[6]),
        .Q(\snapshot_reg[4] [6]),
        .R(SR));
  FDRE \snapshot_reg[4][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[7]),
        .Q(\snapshot_reg[4] [7]),
        .R(SR));
  FDRE \snapshot_reg[4][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[8]),
        .Q(\snapshot_reg[4] [8]),
        .R(SR));
  FDRE \snapshot_reg[4][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(p_15_in[9]),
        .Q(\snapshot_reg[4] [9]),
        .R(SR));
  FDRE \snapshot_reg[5][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[0]),
        .Q(\snapshot_reg[5] [0]),
        .R(SR));
  FDRE \snapshot_reg[5][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[10]),
        .Q(\snapshot_reg[5] [10]),
        .R(SR));
  FDRE \snapshot_reg[5][11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[11]),
        .Q(\snapshot_reg[5] [11]),
        .R(SR));
  FDRE \snapshot_reg[5][12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[12]),
        .Q(\snapshot_reg[5] [12]),
        .R(SR));
  FDRE \snapshot_reg[5][13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[13]),
        .Q(\snapshot_reg[5] [13]),
        .R(SR));
  FDRE \snapshot_reg[5][14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[14]),
        .Q(\snapshot_reg[5] [14]),
        .R(SR));
  FDRE \snapshot_reg[5][15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[15]),
        .Q(\snapshot_reg[5] [15]),
        .R(SR));
  FDRE \snapshot_reg[5][16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[16]),
        .Q(\snapshot_reg[5] [16]),
        .R(SR));
  FDRE \snapshot_reg[5][17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[17]),
        .Q(\snapshot_reg[5] [17]),
        .R(SR));
  FDRE \snapshot_reg[5][18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[18]),
        .Q(\snapshot_reg[5] [18]),
        .R(SR));
  FDRE \snapshot_reg[5][19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[19]),
        .Q(\snapshot_reg[5] [19]),
        .R(SR));
  FDRE \snapshot_reg[5][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[1]),
        .Q(\snapshot_reg[5] [1]),
        .R(SR));
  FDRE \snapshot_reg[5][20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[20]),
        .Q(\snapshot_reg[5] [20]),
        .R(SR));
  FDRE \snapshot_reg[5][21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[21]),
        .Q(\snapshot_reg[5] [21]),
        .R(SR));
  FDRE \snapshot_reg[5][22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[22]),
        .Q(\snapshot_reg[5] [22]),
        .R(SR));
  FDRE \snapshot_reg[5][23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[23]),
        .Q(\snapshot_reg[5] [23]),
        .R(SR));
  FDRE \snapshot_reg[5][24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[24]),
        .Q(\snapshot_reg[5] [24]),
        .R(SR));
  FDRE \snapshot_reg[5][25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[25]),
        .Q(\snapshot_reg[5] [25]),
        .R(SR));
  FDRE \snapshot_reg[5][26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[26]),
        .Q(\snapshot_reg[5] [26]),
        .R(SR));
  FDRE \snapshot_reg[5][27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[27]),
        .Q(\snapshot_reg[5] [27]),
        .R(SR));
  FDRE \snapshot_reg[5][28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[28]),
        .Q(\snapshot_reg[5] [28]),
        .R(SR));
  FDRE \snapshot_reg[5][29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[29]),
        .Q(\snapshot_reg[5] [29]),
        .R(SR));
  FDRE \snapshot_reg[5][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[2]),
        .Q(\snapshot_reg[5] [2]),
        .R(SR));
  FDRE \snapshot_reg[5][30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[30]),
        .Q(\snapshot_reg[5] [30]),
        .R(SR));
  FDRE \snapshot_reg[5][31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[31]),
        .Q(\snapshot_reg[5] [31]),
        .R(SR));
  FDRE \snapshot_reg[5][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[3]),
        .Q(\snapshot_reg[5] [3]),
        .R(SR));
  FDRE \snapshot_reg[5][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[4]),
        .Q(\snapshot_reg[5] [4]),
        .R(SR));
  FDRE \snapshot_reg[5][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[5]),
        .Q(\snapshot_reg[5] [5]),
        .R(SR));
  FDRE \snapshot_reg[5][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[6]),
        .Q(\snapshot_reg[5] [6]),
        .R(SR));
  FDRE \snapshot_reg[5][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[7]),
        .Q(\snapshot_reg[5] [7]),
        .R(SR));
  FDRE \snapshot_reg[5][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[8]),
        .Q(\snapshot_reg[5] [8]),
        .R(SR));
  FDRE \snapshot_reg[5][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(window_count[9]),
        .Q(\snapshot_reg[5] [9]),
        .R(SR));
  FDRE \snapshot_reg[6][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[0]),
        .Q(\snapshot_reg[6] [0]),
        .R(SR));
  FDRE \snapshot_reg[6][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[10]),
        .Q(\snapshot_reg[6] [10]),
        .R(SR));
  FDRE \snapshot_reg[6][11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[11]),
        .Q(\snapshot_reg[6] [11]),
        .R(SR));
  FDRE \snapshot_reg[6][12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[12]),
        .Q(\snapshot_reg[6] [12]),
        .R(SR));
  FDRE \snapshot_reg[6][13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[13]),
        .Q(\snapshot_reg[6] [13]),
        .R(SR));
  FDRE \snapshot_reg[6][14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[14]),
        .Q(\snapshot_reg[6] [14]),
        .R(SR));
  FDRE \snapshot_reg[6][15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[15]),
        .Q(\snapshot_reg[6] [15]),
        .R(SR));
  FDRE \snapshot_reg[6][16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[16]),
        .Q(\snapshot_reg[6] [16]),
        .R(SR));
  FDRE \snapshot_reg[6][17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[17]),
        .Q(\snapshot_reg[6] [17]),
        .R(SR));
  FDRE \snapshot_reg[6][18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[18]),
        .Q(\snapshot_reg[6] [18]),
        .R(SR));
  FDRE \snapshot_reg[6][19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[19]),
        .Q(\snapshot_reg[6] [19]),
        .R(SR));
  FDRE \snapshot_reg[6][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[1]),
        .Q(\snapshot_reg[6] [1]),
        .R(SR));
  FDRE \snapshot_reg[6][20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[20]),
        .Q(\snapshot_reg[6] [20]),
        .R(SR));
  FDRE \snapshot_reg[6][21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[21]),
        .Q(\snapshot_reg[6] [21]),
        .R(SR));
  FDRE \snapshot_reg[6][22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[22]),
        .Q(\snapshot_reg[6] [22]),
        .R(SR));
  FDRE \snapshot_reg[6][23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[23]),
        .Q(\snapshot_reg[6] [23]),
        .R(SR));
  FDRE \snapshot_reg[6][24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[24]),
        .Q(\snapshot_reg[6] [24]),
        .R(SR));
  FDRE \snapshot_reg[6][25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[25]),
        .Q(\snapshot_reg[6] [25]),
        .R(SR));
  FDRE \snapshot_reg[6][26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[26]),
        .Q(\snapshot_reg[6] [26]),
        .R(SR));
  FDRE \snapshot_reg[6][27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[27]),
        .Q(\snapshot_reg[6] [27]),
        .R(SR));
  FDRE \snapshot_reg[6][28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[28]),
        .Q(\snapshot_reg[6] [28]),
        .R(SR));
  FDRE \snapshot_reg[6][29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[29]),
        .Q(\snapshot_reg[6] [29]),
        .R(SR));
  FDRE \snapshot_reg[6][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[2]),
        .Q(\snapshot_reg[6] [2]),
        .R(SR));
  FDRE \snapshot_reg[6][30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[30]),
        .Q(\snapshot_reg[6] [30]),
        .R(SR));
  FDRE \snapshot_reg[6][31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[31]),
        .Q(\snapshot_reg[6] [31]),
        .R(SR));
  FDRE \snapshot_reg[6][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[3]),
        .Q(\snapshot_reg[6] [3]),
        .R(SR));
  FDRE \snapshot_reg[6][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[4]),
        .Q(\snapshot_reg[6] [4]),
        .R(SR));
  FDRE \snapshot_reg[6][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[5]),
        .Q(\snapshot_reg[6] [5]),
        .R(SR));
  FDRE \snapshot_reg[6][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[6]),
        .Q(\snapshot_reg[6] [6]),
        .R(SR));
  FDRE \snapshot_reg[6][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[7]),
        .Q(\snapshot_reg[6] [7]),
        .R(SR));
  FDRE \snapshot_reg[6][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[8]),
        .Q(\snapshot_reg[6] [8]),
        .R(SR));
  FDRE \snapshot_reg[6][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(last_sum[9]),
        .Q(\snapshot_reg[6] [9]),
        .R(SR));
  FDRE \snapshot_reg[7][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[0]),
        .Q(\snapshot_reg[7] [0]),
        .R(SR));
  FDRE \snapshot_reg[7][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[10]),
        .Q(\snapshot_reg[7] [10]),
        .R(SR));
  FDRE \snapshot_reg[7][11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[11]),
        .Q(\snapshot_reg[7] [11]),
        .R(SR));
  FDRE \snapshot_reg[7][12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[12]),
        .Q(\snapshot_reg[7] [12]),
        .R(SR));
  FDRE \snapshot_reg[7][13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[13]),
        .Q(\snapshot_reg[7] [13]),
        .R(SR));
  FDRE \snapshot_reg[7][14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[14]),
        .Q(\snapshot_reg[7] [14]),
        .R(SR));
  FDRE \snapshot_reg[7][15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[15]),
        .Q(\snapshot_reg[7] [15]),
        .R(SR));
  FDRE \snapshot_reg[7][16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[16]),
        .Q(\snapshot_reg[7] [16]),
        .R(SR));
  FDRE \snapshot_reg[7][17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[17]),
        .Q(\snapshot_reg[7] [17]),
        .R(SR));
  FDRE \snapshot_reg[7][18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[18]),
        .Q(\snapshot_reg[7] [18]),
        .R(SR));
  FDRE \snapshot_reg[7][19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[19]),
        .Q(\snapshot_reg[7] [19]),
        .R(SR));
  FDRE \snapshot_reg[7][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[1]),
        .Q(\snapshot_reg[7] [1]),
        .R(SR));
  FDRE \snapshot_reg[7][20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[20]),
        .Q(\snapshot_reg[7] [20]),
        .R(SR));
  FDRE \snapshot_reg[7][21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[21]),
        .Q(\snapshot_reg[7] [21]),
        .R(SR));
  FDRE \snapshot_reg[7][22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[22]),
        .Q(\snapshot_reg[7] [22]),
        .R(SR));
  FDRE \snapshot_reg[7][23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[23]),
        .Q(\snapshot_reg[7] [23]),
        .R(SR));
  FDRE \snapshot_reg[7][24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[24]),
        .Q(\snapshot_reg[7] [24]),
        .R(SR));
  FDRE \snapshot_reg[7][25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[25]),
        .Q(\snapshot_reg[7] [25]),
        .R(SR));
  FDRE \snapshot_reg[7][26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[26]),
        .Q(\snapshot_reg[7] [26]),
        .R(SR));
  FDRE \snapshot_reg[7][27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[27]),
        .Q(\snapshot_reg[7] [27]),
        .R(SR));
  FDRE \snapshot_reg[7][28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[28]),
        .Q(\snapshot_reg[7] [28]),
        .R(SR));
  FDRE \snapshot_reg[7][29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[29]),
        .Q(\snapshot_reg[7] [29]),
        .R(SR));
  FDRE \snapshot_reg[7][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[2]),
        .Q(\snapshot_reg[7] [2]),
        .R(SR));
  FDRE \snapshot_reg[7][30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[30]),
        .Q(\snapshot_reg[7] [30]),
        .R(SR));
  FDRE \snapshot_reg[7][31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[31]),
        .Q(\snapshot_reg[7] [31]),
        .R(SR));
  FDRE \snapshot_reg[7][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[3]),
        .Q(\snapshot_reg[7] [3]),
        .R(SR));
  FDRE \snapshot_reg[7][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[4]),
        .Q(\snapshot_reg[7] [4]),
        .R(SR));
  FDRE \snapshot_reg[7][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[5]),
        .Q(\snapshot_reg[7] [5]),
        .R(SR));
  FDRE \snapshot_reg[7][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[6]),
        .Q(\snapshot_reg[7] [6]),
        .R(SR));
  FDRE \snapshot_reg[7][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[7]),
        .Q(\snapshot_reg[7] [7]),
        .R(SR));
  FDRE \snapshot_reg[7][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[8]),
        .Q(\snapshot_reg[7] [8]),
        .R(SR));
  FDRE \snapshot_reg[7][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_sequence[9]),
        .Q(\snapshot_reg[7] [9]),
        .R(SR));
  FDRE \snapshot_reg[8][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[0]),
        .Q(\snapshot_reg[8] [0]),
        .R(SR));
  FDRE \snapshot_reg[8][10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[10]),
        .Q(\snapshot_reg[8] [10]),
        .R(SR));
  FDRE \snapshot_reg[8][11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[11]),
        .Q(\snapshot_reg[8] [11]),
        .R(SR));
  FDRE \snapshot_reg[8][12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[12]),
        .Q(\snapshot_reg[8] [12]),
        .R(SR));
  FDRE \snapshot_reg[8][13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[13]),
        .Q(\snapshot_reg[8] [13]),
        .R(SR));
  FDRE \snapshot_reg[8][14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[14]),
        .Q(\snapshot_reg[8] [14]),
        .R(SR));
  FDRE \snapshot_reg[8][15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[15]),
        .Q(\snapshot_reg[8] [15]),
        .R(SR));
  FDRE \snapshot_reg[8][16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[16]),
        .Q(\snapshot_reg[8] [16]),
        .R(SR));
  FDRE \snapshot_reg[8][17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[17]),
        .Q(\snapshot_reg[8] [17]),
        .R(SR));
  FDRE \snapshot_reg[8][18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[18]),
        .Q(\snapshot_reg[8] [18]),
        .R(SR));
  FDRE \snapshot_reg[8][19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[19]),
        .Q(\snapshot_reg[8] [19]),
        .R(SR));
  FDRE \snapshot_reg[8][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[1]),
        .Q(\snapshot_reg[8] [1]),
        .R(SR));
  FDRE \snapshot_reg[8][20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[20]),
        .Q(\snapshot_reg[8] [20]),
        .R(SR));
  FDRE \snapshot_reg[8][21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[21]),
        .Q(\snapshot_reg[8] [21]),
        .R(SR));
  FDRE \snapshot_reg[8][22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[22]),
        .Q(\snapshot_reg[8] [22]),
        .R(SR));
  FDRE \snapshot_reg[8][23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[23]),
        .Q(\snapshot_reg[8] [23]),
        .R(SR));
  FDRE \snapshot_reg[8][24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[24]),
        .Q(\snapshot_reg[8] [24]),
        .R(SR));
  FDRE \snapshot_reg[8][25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[25]),
        .Q(\snapshot_reg[8] [25]),
        .R(SR));
  FDRE \snapshot_reg[8][26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[26]),
        .Q(\snapshot_reg[8] [26]),
        .R(SR));
  FDRE \snapshot_reg[8][27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[27]),
        .Q(\snapshot_reg[8] [27]),
        .R(SR));
  FDRE \snapshot_reg[8][28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[28]),
        .Q(\snapshot_reg[8] [28]),
        .R(SR));
  FDRE \snapshot_reg[8][29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[29]),
        .Q(\snapshot_reg[8] [29]),
        .R(SR));
  FDRE \snapshot_reg[8][2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[2]),
        .Q(\snapshot_reg[8] [2]),
        .R(SR));
  FDRE \snapshot_reg[8][30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[30]),
        .Q(\snapshot_reg[8] [30]),
        .R(SR));
  FDRE \snapshot_reg[8][31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[31]),
        .Q(\snapshot_reg[8] [31]),
        .R(SR));
  FDRE \snapshot_reg[8][3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[3]),
        .Q(\snapshot_reg[8] [3]),
        .R(SR));
  FDRE \snapshot_reg[8][4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[4]),
        .Q(\snapshot_reg[8] [4]),
        .R(SR));
  FDRE \snapshot_reg[8][5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[5]),
        .Q(\snapshot_reg[8] [5]),
        .R(SR));
  FDRE \snapshot_reg[8][6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[6]),
        .Q(\snapshot_reg[8] [6]),
        .R(SR));
  FDRE \snapshot_reg[8][7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[7]),
        .Q(\snapshot_reg[8] [7]),
        .R(SR));
  FDRE \snapshot_reg[8][8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[8]),
        .Q(\snapshot_reg[8] [8]),
        .R(SR));
  FDRE \snapshot_reg[8][9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_epoch[9]),
        .Q(\snapshot_reg[8] [9]),
        .R(SR));
  FDRE \snapshot_reg[9][0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_kind[0]),
        .Q(\snapshot_reg[9] [0]),
        .R(SR));
  FDRE \snapshot_reg[9][1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(event_kind[1]),
        .Q(\snapshot_reg[9] [1]),
        .R(SR));
  LUT1 #(
    .INIT(2'h1)) 
    \snapshot_sequence[0]_i_2 
       (.I0(snapshot_sequence_reg[0]),
        .O(\snapshot_sequence[0]_i_2_n_0 ));
  FDRE \snapshot_sequence_reg[0] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[0]_i_1_n_7 ),
        .Q(snapshot_sequence_reg[0]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \snapshot_sequence_reg[0]_i_1 
       (.CI(1'b0),
        .CO({\snapshot_sequence_reg[0]_i_1_n_0 ,\snapshot_sequence_reg[0]_i_1_n_1 ,\snapshot_sequence_reg[0]_i_1_n_2 ,\snapshot_sequence_reg[0]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\snapshot_sequence_reg[0]_i_1_n_4 ,\snapshot_sequence_reg[0]_i_1_n_5 ,\snapshot_sequence_reg[0]_i_1_n_6 ,\snapshot_sequence_reg[0]_i_1_n_7 }),
        .S({snapshot_sequence_reg[3:1],\snapshot_sequence[0]_i_2_n_0 }));
  FDRE \snapshot_sequence_reg[10] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[8]_i_1_n_5 ),
        .Q(snapshot_sequence_reg[10]),
        .R(SR));
  FDRE \snapshot_sequence_reg[11] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[8]_i_1_n_4 ),
        .Q(snapshot_sequence_reg[11]),
        .R(SR));
  FDRE \snapshot_sequence_reg[12] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[12]_i_1_n_7 ),
        .Q(snapshot_sequence_reg[12]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \snapshot_sequence_reg[12]_i_1 
       (.CI(\snapshot_sequence_reg[8]_i_1_n_0 ),
        .CO({\snapshot_sequence_reg[12]_i_1_n_0 ,\snapshot_sequence_reg[12]_i_1_n_1 ,\snapshot_sequence_reg[12]_i_1_n_2 ,\snapshot_sequence_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\snapshot_sequence_reg[12]_i_1_n_4 ,\snapshot_sequence_reg[12]_i_1_n_5 ,\snapshot_sequence_reg[12]_i_1_n_6 ,\snapshot_sequence_reg[12]_i_1_n_7 }),
        .S(snapshot_sequence_reg[15:12]));
  FDRE \snapshot_sequence_reg[13] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[12]_i_1_n_6 ),
        .Q(snapshot_sequence_reg[13]),
        .R(SR));
  FDRE \snapshot_sequence_reg[14] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[12]_i_1_n_5 ),
        .Q(snapshot_sequence_reg[14]),
        .R(SR));
  FDRE \snapshot_sequence_reg[15] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[12]_i_1_n_4 ),
        .Q(snapshot_sequence_reg[15]),
        .R(SR));
  FDRE \snapshot_sequence_reg[16] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[16]_i_1_n_7 ),
        .Q(snapshot_sequence_reg[16]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \snapshot_sequence_reg[16]_i_1 
       (.CI(\snapshot_sequence_reg[12]_i_1_n_0 ),
        .CO({\snapshot_sequence_reg[16]_i_1_n_0 ,\snapshot_sequence_reg[16]_i_1_n_1 ,\snapshot_sequence_reg[16]_i_1_n_2 ,\snapshot_sequence_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\snapshot_sequence_reg[16]_i_1_n_4 ,\snapshot_sequence_reg[16]_i_1_n_5 ,\snapshot_sequence_reg[16]_i_1_n_6 ,\snapshot_sequence_reg[16]_i_1_n_7 }),
        .S(snapshot_sequence_reg[19:16]));
  FDRE \snapshot_sequence_reg[17] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[16]_i_1_n_6 ),
        .Q(snapshot_sequence_reg[17]),
        .R(SR));
  FDRE \snapshot_sequence_reg[18] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[16]_i_1_n_5 ),
        .Q(snapshot_sequence_reg[18]),
        .R(SR));
  FDRE \snapshot_sequence_reg[19] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[16]_i_1_n_4 ),
        .Q(snapshot_sequence_reg[19]),
        .R(SR));
  FDRE \snapshot_sequence_reg[1] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[0]_i_1_n_6 ),
        .Q(snapshot_sequence_reg[1]),
        .R(SR));
  FDRE \snapshot_sequence_reg[20] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[20]_i_1_n_7 ),
        .Q(snapshot_sequence_reg[20]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \snapshot_sequence_reg[20]_i_1 
       (.CI(\snapshot_sequence_reg[16]_i_1_n_0 ),
        .CO({\snapshot_sequence_reg[20]_i_1_n_0 ,\snapshot_sequence_reg[20]_i_1_n_1 ,\snapshot_sequence_reg[20]_i_1_n_2 ,\snapshot_sequence_reg[20]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\snapshot_sequence_reg[20]_i_1_n_4 ,\snapshot_sequence_reg[20]_i_1_n_5 ,\snapshot_sequence_reg[20]_i_1_n_6 ,\snapshot_sequence_reg[20]_i_1_n_7 }),
        .S(snapshot_sequence_reg[23:20]));
  FDRE \snapshot_sequence_reg[21] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[20]_i_1_n_6 ),
        .Q(snapshot_sequence_reg[21]),
        .R(SR));
  FDRE \snapshot_sequence_reg[22] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[20]_i_1_n_5 ),
        .Q(snapshot_sequence_reg[22]),
        .R(SR));
  FDRE \snapshot_sequence_reg[23] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[20]_i_1_n_4 ),
        .Q(snapshot_sequence_reg[23]),
        .R(SR));
  FDRE \snapshot_sequence_reg[24] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[24]_i_1_n_7 ),
        .Q(snapshot_sequence_reg[24]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \snapshot_sequence_reg[24]_i_1 
       (.CI(\snapshot_sequence_reg[20]_i_1_n_0 ),
        .CO({\snapshot_sequence_reg[24]_i_1_n_0 ,\snapshot_sequence_reg[24]_i_1_n_1 ,\snapshot_sequence_reg[24]_i_1_n_2 ,\snapshot_sequence_reg[24]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\snapshot_sequence_reg[24]_i_1_n_4 ,\snapshot_sequence_reg[24]_i_1_n_5 ,\snapshot_sequence_reg[24]_i_1_n_6 ,\snapshot_sequence_reg[24]_i_1_n_7 }),
        .S(snapshot_sequence_reg[27:24]));
  FDRE \snapshot_sequence_reg[25] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[24]_i_1_n_6 ),
        .Q(snapshot_sequence_reg[25]),
        .R(SR));
  FDRE \snapshot_sequence_reg[26] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[24]_i_1_n_5 ),
        .Q(snapshot_sequence_reg[26]),
        .R(SR));
  FDRE \snapshot_sequence_reg[27] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[24]_i_1_n_4 ),
        .Q(snapshot_sequence_reg[27]),
        .R(SR));
  FDRE \snapshot_sequence_reg[28] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[28]_i_1_n_7 ),
        .Q(snapshot_sequence_reg[28]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \snapshot_sequence_reg[28]_i_1 
       (.CI(\snapshot_sequence_reg[24]_i_1_n_0 ),
        .CO({\NLW_snapshot_sequence_reg[28]_i_1_CO_UNCONNECTED [3],\snapshot_sequence_reg[28]_i_1_n_1 ,\snapshot_sequence_reg[28]_i_1_n_2 ,\snapshot_sequence_reg[28]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\snapshot_sequence_reg[28]_i_1_n_4 ,\snapshot_sequence_reg[28]_i_1_n_5 ,\snapshot_sequence_reg[28]_i_1_n_6 ,\snapshot_sequence_reg[28]_i_1_n_7 }),
        .S(snapshot_sequence_reg[31:28]));
  FDRE \snapshot_sequence_reg[29] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[28]_i_1_n_6 ),
        .Q(snapshot_sequence_reg[29]),
        .R(SR));
  FDRE \snapshot_sequence_reg[2] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[0]_i_1_n_5 ),
        .Q(snapshot_sequence_reg[2]),
        .R(SR));
  FDRE \snapshot_sequence_reg[30] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[28]_i_1_n_5 ),
        .Q(snapshot_sequence_reg[30]),
        .R(SR));
  FDRE \snapshot_sequence_reg[31] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[28]_i_1_n_4 ),
        .Q(snapshot_sequence_reg[31]),
        .R(SR));
  FDRE \snapshot_sequence_reg[3] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[0]_i_1_n_4 ),
        .Q(snapshot_sequence_reg[3]),
        .R(SR));
  FDRE \snapshot_sequence_reg[4] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[4]_i_1_n_7 ),
        .Q(snapshot_sequence_reg[4]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \snapshot_sequence_reg[4]_i_1 
       (.CI(\snapshot_sequence_reg[0]_i_1_n_0 ),
        .CO({\snapshot_sequence_reg[4]_i_1_n_0 ,\snapshot_sequence_reg[4]_i_1_n_1 ,\snapshot_sequence_reg[4]_i_1_n_2 ,\snapshot_sequence_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\snapshot_sequence_reg[4]_i_1_n_4 ,\snapshot_sequence_reg[4]_i_1_n_5 ,\snapshot_sequence_reg[4]_i_1_n_6 ,\snapshot_sequence_reg[4]_i_1_n_7 }),
        .S(snapshot_sequence_reg[7:4]));
  FDRE \snapshot_sequence_reg[5] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[4]_i_1_n_6 ),
        .Q(snapshot_sequence_reg[5]),
        .R(SR));
  FDRE \snapshot_sequence_reg[6] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[4]_i_1_n_5 ),
        .Q(snapshot_sequence_reg[6]),
        .R(SR));
  FDRE \snapshot_sequence_reg[7] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[4]_i_1_n_4 ),
        .Q(snapshot_sequence_reg[7]),
        .R(SR));
  FDRE \snapshot_sequence_reg[8] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[8]_i_1_n_7 ),
        .Q(snapshot_sequence_reg[8]),
        .R(SR));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \snapshot_sequence_reg[8]_i_1 
       (.CI(\snapshot_sequence_reg[4]_i_1_n_0 ),
        .CO({\snapshot_sequence_reg[8]_i_1_n_0 ,\snapshot_sequence_reg[8]_i_1_n_1 ,\snapshot_sequence_reg[8]_i_1_n_2 ,\snapshot_sequence_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\snapshot_sequence_reg[8]_i_1_n_4 ,\snapshot_sequence_reg[8]_i_1_n_5 ,\snapshot_sequence_reg[8]_i_1_n_6 ,\snapshot_sequence_reg[8]_i_1_n_7 }),
        .S(snapshot_sequence_reg[11:8]));
  FDRE \snapshot_sequence_reg[9] 
       (.C(s_axi_aclk),
        .CE(\snapshot[0][10]_i_1_n_0 ),
        .D(\snapshot_sequence_reg[8]_i_1_n_6 ),
        .Q(snapshot_sequence_reg[9]),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT4 #(
    .INIT(16'h00EB)) 
    snapshot_valid_i_2
       (.I0(write_data[0]),
        .I1(write_data[2]),
        .I2(write_data[1]),
        .I3(\soft_sum[31]_i_3_n_0 ),
        .O(snapshot_valid_i_2_n_0));
  FDRE snapshot_valid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(core_n_235),
        .Q(snapshot_valid),
        .R(1'b0));
  LUT3 #(
    .INIT(8'h08)) 
    \soft_sum[31]_i_1 
       (.I0(\soft_sum[31]_i_2_n_0 ),
        .I1(\soft_sum[31]_i_3_n_0 ),
        .I2(\soft_sum[31]_i_4_n_0 ),
        .O(enable));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \soft_sum[31]_i_10 
       (.I0(\shadow_soft_reg_n_0_[5] ),
        .I1(\shadow_soft_reg_n_0_[4] ),
        .I2(\shadow_soft_reg_n_0_[7] ),
        .I3(\shadow_soft_reg_n_0_[6] ),
        .O(\soft_sum[31]_i_10_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \soft_sum[31]_i_11 
       (.I0(\shadow_soft_reg_n_0_[8] ),
        .I1(\shadow_soft_reg_n_0_[9] ),
        .I2(\shadow_soft_reg_n_0_[10] ),
        .I3(\shadow_soft_reg_n_0_[11] ),
        .I4(\soft_sum[31]_i_18_n_0 ),
        .O(\soft_sum[31]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \soft_sum[31]_i_12 
       (.I0(\shadow_soft_reg_n_0_[23] ),
        .I1(\shadow_soft_reg_n_0_[22] ),
        .I2(\shadow_soft_reg_n_0_[21] ),
        .I3(\shadow_soft_reg_n_0_[20] ),
        .O(\soft_sum[31]_i_12_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \soft_sum[31]_i_13 
       (.I0(\shadow_soft_reg_n_0_[24] ),
        .I1(\shadow_soft_reg_n_0_[27] ),
        .I2(\shadow_soft_reg_n_0_[25] ),
        .I3(\shadow_soft_reg_n_0_[26] ),
        .I4(\soft_sum[31]_i_19_n_0 ),
        .O(\soft_sum[31]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \soft_sum[31]_i_14 
       (.I0(config_epoch_reg[25]),
        .I1(config_epoch_reg[14]),
        .I2(config_epoch_reg[17]),
        .I3(config_epoch_reg[6]),
        .O(\soft_sum[31]_i_14_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    \soft_sum[31]_i_15 
       (.I0(config_epoch_reg[16]),
        .I1(config_epoch_reg[19]),
        .I2(config_epoch_reg[8]),
        .I3(config_epoch_reg[9]),
        .I4(\soft_sum[31]_i_20_n_0 ),
        .O(\soft_sum[31]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \soft_sum[31]_i_16 
       (.I0(config_epoch_reg[3]),
        .I1(config_epoch_reg[0]),
        .I2(config_epoch_reg[24]),
        .I3(config_epoch_reg[23]),
        .O(\soft_sum[31]_i_16_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    \soft_sum[31]_i_17 
       (.I0(config_epoch_reg[28]),
        .I1(config_epoch_reg[29]),
        .I2(config_epoch_reg[31]),
        .I3(config_epoch_reg[30]),
        .I4(\soft_sum[31]_i_21_n_0 ),
        .O(\soft_sum[31]_i_17_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \soft_sum[31]_i_18 
       (.I0(\shadow_soft_reg_n_0_[13] ),
        .I1(\shadow_soft_reg_n_0_[12] ),
        .I2(\shadow_soft_reg_n_0_[15] ),
        .I3(\shadow_soft_reg_n_0_[14] ),
        .O(\soft_sum[31]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \soft_sum[31]_i_19 
       (.I0(\shadow_soft_reg_n_0_[29] ),
        .I1(\shadow_soft_reg_n_0_[28] ),
        .I2(\shadow_soft_reg_n_0_[31] ),
        .I3(\shadow_soft_reg_n_0_[30] ),
        .O(\soft_sum[31]_i_19_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \soft_sum[31]_i_2 
       (.I0(\s_axi_bresp[1]_i_3_n_0 ),
        .I1(\snapshot[0][10]_i_2_n_0 ),
        .O(\soft_sum[31]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \soft_sum[31]_i_20 
       (.I0(config_epoch_reg[22]),
        .I1(config_epoch_reg[21]),
        .I2(config_epoch_reg[20]),
        .I3(config_epoch_reg[18]),
        .O(\soft_sum[31]_i_20_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \soft_sum[31]_i_21 
       (.I0(config_epoch_reg[27]),
        .I1(config_epoch_reg[26]),
        .I2(config_epoch_reg[15]),
        .I3(config_epoch_reg[13]),
        .O(\soft_sum[31]_i_21_n_0 ));
  LUT5 #(
    .INIT(32'h0000DD0D)) 
    \soft_sum[31]_i_3 
       (.I0(\soft_sum[31]_i_5_n_0 ),
        .I1(\soft_sum[31]_i_6_n_0 ),
        .I2(\soft_sum[31]_i_7_n_0 ),
        .I3(\soft_sum[31]_i_8_n_0 ),
        .I4(\soft_sum[31]_i_9_n_0 ),
        .O(\soft_sum[31]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT4 #(
    .INIT(16'hBFFF)) 
    \soft_sum[31]_i_4 
       (.I0(s_axi_bvalid_reg_0),
        .I1(w_held_reg_n_0),
        .I2(aw_held),
        .I3(\s_axi_bresp[1]_i_6_n_0 ),
        .O(\soft_sum[31]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \soft_sum[31]_i_5 
       (.I0(\soft_sum[31]_i_10_n_0 ),
        .I1(\shadow_soft_reg_n_0_[2] ),
        .I2(\shadow_soft_reg_n_0_[1] ),
        .I3(\shadow_soft_reg_n_0_[3] ),
        .I4(\shadow_soft_reg_n_0_[0] ),
        .I5(\soft_sum[31]_i_11_n_0 ),
        .O(\soft_sum[31]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \soft_sum[31]_i_6 
       (.I0(\soft_sum[31]_i_12_n_0 ),
        .I1(\shadow_soft_reg_n_0_[18] ),
        .I2(\shadow_soft_reg_n_0_[17] ),
        .I3(\shadow_soft_reg_n_0_[19] ),
        .I4(\shadow_soft_reg_n_0_[16] ),
        .I5(\soft_sum[31]_i_13_n_0 ),
        .O(\soft_sum[31]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040000000)) 
    \soft_sum[31]_i_7 
       (.I0(\soft_sum[31]_i_14_n_0 ),
        .I1(config_epoch_reg[11]),
        .I2(config_epoch_reg[10]),
        .I3(config_epoch_reg[12]),
        .I4(config_epoch_reg[1]),
        .I5(\soft_sum[31]_i_15_n_0 ),
        .O(\soft_sum[31]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFBFFFFFFF)) 
    \soft_sum[31]_i_8 
       (.I0(\soft_sum[31]_i_16_n_0 ),
        .I1(config_epoch_reg[7]),
        .I2(config_epoch_reg[4]),
        .I3(config_epoch_reg[5]),
        .I4(config_epoch_reg[2]),
        .I5(\soft_sum[31]_i_17_n_0 ),
        .O(\soft_sum[31]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT5 #(
    .INIT(32'hFFFFFEFF)) 
    \soft_sum[31]_i_9 
       (.I0(write_data[1]),
        .I1(write_data[2]),
        .I2(s_axi_bresp3),
        .I3(write_data[0]),
        .I4(s_axi_bresp4),
        .O(\soft_sum[31]_i_9_n_0 ));
  FDRE \soft_sum_reg[0] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[0] ),
        .Q(\soft_sum_reg_n_0_[0] ),
        .R(SR));
  FDRE \soft_sum_reg[10] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[10] ),
        .Q(\soft_sum_reg_n_0_[10] ),
        .R(SR));
  FDRE \soft_sum_reg[11] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[11] ),
        .Q(\soft_sum_reg_n_0_[11] ),
        .R(SR));
  FDRE \soft_sum_reg[12] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[12] ),
        .Q(\soft_sum_reg_n_0_[12] ),
        .R(SR));
  FDRE \soft_sum_reg[13] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[13] ),
        .Q(\soft_sum_reg_n_0_[13] ),
        .R(SR));
  FDSE \soft_sum_reg[14] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[14] ),
        .Q(\soft_sum_reg_n_0_[14] ),
        .S(SR));
  FDRE \soft_sum_reg[15] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[15] ),
        .Q(\soft_sum_reg_n_0_[15] ),
        .R(SR));
  FDSE \soft_sum_reg[16] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[16] ),
        .Q(\soft_sum_reg_n_0_[16] ),
        .S(SR));
  FDSE \soft_sum_reg[17] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[17] ),
        .Q(\soft_sum_reg_n_0_[17] ),
        .S(SR));
  FDSE \soft_sum_reg[18] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[18] ),
        .Q(\soft_sum_reg_n_0_[18] ),
        .S(SR));
  FDSE \soft_sum_reg[19] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[19] ),
        .Q(\soft_sum_reg_n_0_[19] ),
        .S(SR));
  FDRE \soft_sum_reg[1] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[1] ),
        .Q(\soft_sum_reg_n_0_[1] ),
        .R(SR));
  FDRE \soft_sum_reg[20] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[20] ),
        .Q(\soft_sum_reg_n_0_[20] ),
        .R(SR));
  FDRE \soft_sum_reg[21] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[21] ),
        .Q(\soft_sum_reg_n_0_[21] ),
        .R(SR));
  FDRE \soft_sum_reg[22] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[22] ),
        .Q(\soft_sum_reg_n_0_[22] ),
        .R(SR));
  FDRE \soft_sum_reg[23] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[23] ),
        .Q(\soft_sum_reg_n_0_[23] ),
        .R(SR));
  FDRE \soft_sum_reg[24] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[24] ),
        .Q(\soft_sum_reg_n_0_[24] ),
        .R(SR));
  FDRE \soft_sum_reg[25] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[25] ),
        .Q(\soft_sum_reg_n_0_[25] ),
        .R(SR));
  FDRE \soft_sum_reg[26] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[26] ),
        .Q(\soft_sum_reg_n_0_[26] ),
        .R(SR));
  FDRE \soft_sum_reg[27] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[27] ),
        .Q(\soft_sum_reg_n_0_[27] ),
        .R(SR));
  FDRE \soft_sum_reg[28] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[28] ),
        .Q(\soft_sum_reg_n_0_[28] ),
        .R(SR));
  FDRE \soft_sum_reg[29] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[29] ),
        .Q(\soft_sum_reg_n_0_[29] ),
        .R(SR));
  FDRE \soft_sum_reg[2] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[2] ),
        .Q(\soft_sum_reg_n_0_[2] ),
        .R(SR));
  FDRE \soft_sum_reg[30] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[30] ),
        .Q(\soft_sum_reg_n_0_[30] ),
        .R(SR));
  FDRE \soft_sum_reg[31] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[31] ),
        .Q(\soft_sum_reg_n_0_[31] ),
        .R(SR));
  FDRE \soft_sum_reg[3] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[3] ),
        .Q(\soft_sum_reg_n_0_[3] ),
        .R(SR));
  FDRE \soft_sum_reg[4] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[4] ),
        .Q(\soft_sum_reg_n_0_[4] ),
        .R(SR));
  FDRE \soft_sum_reg[5] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[5] ),
        .Q(\soft_sum_reg_n_0_[5] ),
        .R(SR));
  FDSE \soft_sum_reg[6] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[6] ),
        .Q(\soft_sum_reg_n_0_[6] ),
        .S(SR));
  FDRE \soft_sum_reg[7] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[7] ),
        .Q(\soft_sum_reg_n_0_[7] ),
        .R(SR));
  FDRE \soft_sum_reg[8] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[8] ),
        .Q(\soft_sum_reg_n_0_[8] ),
        .R(SR));
  FDSE \soft_sum_reg[9] 
       (.C(s_axi_aclk),
        .CE(enable),
        .D(\shadow_soft_reg_n_0_[9] ),
        .Q(\soft_sum_reg_n_0_[9] ),
        .S(SR));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT5 #(
    .INIT(32'hCC000C88)) 
    w_held_i_1
       (.I0(s_axi_wvalid),
        .I1(s_axi_aresetn),
        .I2(aw_held),
        .I3(w_held_reg_n_0),
        .I4(s_axi_bvalid_reg_0),
        .O(w_held_i_1_n_0));
  FDRE w_held_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(w_held_i_1_n_0),
        .Q(w_held_reg_n_0),
        .R(1'b0));
  LUT3 #(
    .INIT(8'h02)) 
    \write_address[11]_i_1 
       (.I0(s_axi_awvalid),
        .I1(s_axi_bvalid_reg_0),
        .I2(aw_held),
        .O(aw_held0));
  FDRE \write_address_reg[0] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[0]),
        .Q(write_address[0]),
        .R(SR));
  FDRE \write_address_reg[10] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[10]),
        .Q(write_address[10]),
        .R(SR));
  FDRE \write_address_reg[11] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[11]),
        .Q(write_address[11]),
        .R(SR));
  FDRE \write_address_reg[1] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[1]),
        .Q(write_address[1]),
        .R(SR));
  FDRE \write_address_reg[2] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[2]),
        .Q(write_address[2]),
        .R(SR));
  FDRE \write_address_reg[3] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[3]),
        .Q(write_address[3]),
        .R(SR));
  FDRE \write_address_reg[4] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[4]),
        .Q(write_address[4]),
        .R(SR));
  FDRE \write_address_reg[5] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[5]),
        .Q(write_address[5]),
        .R(SR));
  FDRE \write_address_reg[6] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[6]),
        .Q(write_address[6]),
        .R(SR));
  FDRE \write_address_reg[7] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[7]),
        .Q(write_address[7]),
        .R(SR));
  FDRE \write_address_reg[8] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[8]),
        .Q(write_address[8]),
        .R(SR));
  FDRE \write_address_reg[9] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[9]),
        .Q(write_address[9]),
        .R(SR));
  LUT3 #(
    .INIT(8'h02)) 
    \write_data[31]_i_1 
       (.I0(s_axi_wvalid),
        .I1(s_axi_bvalid_reg_0),
        .I2(w_held_reg_n_0),
        .O(w_held0));
  FDRE \write_data_reg[0] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[0]),
        .Q(write_data[0]),
        .R(SR));
  FDRE \write_data_reg[10] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[10]),
        .Q(write_data[10]),
        .R(SR));
  FDRE \write_data_reg[11] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[11]),
        .Q(write_data[11]),
        .R(SR));
  FDRE \write_data_reg[12] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[12]),
        .Q(write_data[12]),
        .R(SR));
  FDRE \write_data_reg[13] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[13]),
        .Q(write_data[13]),
        .R(SR));
  FDRE \write_data_reg[14] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[14]),
        .Q(write_data[14]),
        .R(SR));
  FDRE \write_data_reg[15] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[15]),
        .Q(write_data[15]),
        .R(SR));
  FDRE \write_data_reg[16] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[16]),
        .Q(write_data[16]),
        .R(SR));
  FDRE \write_data_reg[17] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[17]),
        .Q(write_data[17]),
        .R(SR));
  FDRE \write_data_reg[18] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[18]),
        .Q(write_data[18]),
        .R(SR));
  FDRE \write_data_reg[19] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[19]),
        .Q(write_data[19]),
        .R(SR));
  FDRE \write_data_reg[1] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[1]),
        .Q(write_data[1]),
        .R(SR));
  FDRE \write_data_reg[20] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[20]),
        .Q(write_data[20]),
        .R(SR));
  FDRE \write_data_reg[21] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[21]),
        .Q(write_data[21]),
        .R(SR));
  FDRE \write_data_reg[22] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[22]),
        .Q(write_data[22]),
        .R(SR));
  FDRE \write_data_reg[23] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[23]),
        .Q(write_data[23]),
        .R(SR));
  FDRE \write_data_reg[24] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[24]),
        .Q(write_data[24]),
        .R(SR));
  FDRE \write_data_reg[25] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[25]),
        .Q(write_data[25]),
        .R(SR));
  FDRE \write_data_reg[26] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[26]),
        .Q(write_data[26]),
        .R(SR));
  FDRE \write_data_reg[27] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[27]),
        .Q(write_data[27]),
        .R(SR));
  FDRE \write_data_reg[28] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[28]),
        .Q(write_data[28]),
        .R(SR));
  FDRE \write_data_reg[29] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[29]),
        .Q(write_data[29]),
        .R(SR));
  FDRE \write_data_reg[2] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[2]),
        .Q(write_data[2]),
        .R(SR));
  FDRE \write_data_reg[30] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[30]),
        .Q(write_data[30]),
        .R(SR));
  FDRE \write_data_reg[31] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[31]),
        .Q(write_data[31]),
        .R(SR));
  FDRE \write_data_reg[3] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[3]),
        .Q(write_data[3]),
        .R(SR));
  FDRE \write_data_reg[4] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[4]),
        .Q(write_data[4]),
        .R(SR));
  FDRE \write_data_reg[5] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[5]),
        .Q(write_data[5]),
        .R(SR));
  FDRE \write_data_reg[6] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[6]),
        .Q(write_data[6]),
        .R(SR));
  FDRE \write_data_reg[7] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[7]),
        .Q(write_data[7]),
        .R(SR));
  FDRE \write_data_reg[8] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[8]),
        .Q(write_data[8]),
        .R(SR));
  FDRE \write_data_reg[9] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[9]),
        .Q(write_data[9]),
        .R(SR));
  FDRE \write_strobe_reg[0] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wstrb[0]),
        .Q(write_strobe[0]),
        .R(SR));
  FDRE \write_strobe_reg[1] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wstrb[1]),
        .Q(write_strobe[1]),
        .R(SR));
  FDRE \write_strobe_reg[2] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wstrb[2]),
        .Q(write_strobe[2]),
        .R(SR));
  FDRE \write_strobe_reg[3] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wstrb[3]),
        .Q(write_strobe[3]),
        .R(SR));
endmodule

(* ORIG_REF_NAME = "voice_volume_core" *) 
module c6v_voice_volume_0_0_voice_volume_core
   (out,
    Q,
    \dc_level_reg[22]_0 ,
    status,
    \event_kind_reg[1]_0 ,
    \faults_reg[7]_0 ,
    \snapshot_sequence_reg[10] ,
    \faults_reg[0]_0 ,
    \window_count_reg[31]_0 ,
    \event_epoch_reg[31]_0 ,
    \event_sequence_reg[31]_0 ,
    s_axi_aresetn_0,
    snapshot_valid_reg,
    \last_sum_reg[31]_0 ,
    \event_sample_reg[63]_0 ,
    \event_window_reg[31]_0 ,
    dc_clipped0,
    s_axi_aclk,
    D,
    \difference_latched_reg[12]_0 ,
    \difference_latched_reg[12]_1 ,
    S,
    \difference_latched_reg[20]_0 ,
    \difference_latched_reg[24]_0 ,
    configure,
    \faults_reg[0]_1 ,
    input_fault,
    \faults_reg[1]_0 ,
    pcm_valid,
    ack_error_reg_0,
    s_axi_aresetn,
    \s_axi_rdata_reg[2] ,
    \s_axi_rdata_reg[2]_0 ,
    \s_axi_rdata_reg[2]_1 ,
    \s_axi_rdata_reg[2]_2 ,
    \s_axi_rdata_reg[2]_3 ,
    \s_axi_rdata_reg[9] ,
    \s_axi_rdata_reg[2]_4 ,
    above_loud_carry__2_0,
    \faults[7]_i_10_0 ,
    quiet_carry__2_0,
    matching_ack1_carry__1_0,
    matching_ack0_carry__1_0,
    \s_axi_rdata_reg[0] ,
    \s_axi_rdata_reg[0]_0 ,
    \s_axi_rdata_reg[1] ,
    \s_axi_rdata_reg[1]_0 ,
    \s_axi_rdata_reg[3] ,
    \s_axi_rdata_reg[3]_0 ,
    \s_axi_rdata_reg[4] ,
    \s_axi_rdata_reg[4]_0 ,
    \s_axi_rdata_reg[5] ,
    \s_axi_rdata_reg[5]_0 ,
    \s_axi_rdata_reg[6] ,
    \s_axi_rdata_reg[6]_0 ,
    \s_axi_rdata_reg[7] ,
    \s_axi_rdata_reg[7]_0 ,
    \s_axi_rdata_reg[8] ,
    \s_axi_rdata_reg[8]_0 ,
    \s_axi_rdata_reg[8]_1 ,
    \s_axi_rdata_reg[9]_0 ,
    \s_axi_rdata_reg[9]_1 ,
    \s_axi_rdata_reg[10] ,
    \s_axi_rdata_reg[10]_0 ,
    \s_axi_rdata_reg[4]_1 ,
    \s_axi_rdata_reg[4]_2 ,
    \s_axi_rdata_reg[10]_1 ,
    config_epoch_reg,
    \s_axi_rdata_reg[1]_1 ,
    \s_axi_rdata_reg[3]_1 ,
    snapshot_valid,
    snapshot_valid_reg_0,
    snapshot_valid_reg_1,
    snapshot_valid_reg_2,
    snapshot_valid_reg_3);
  output [63:0]out;
  output [31:0]Q;
  output [14:0]\dc_level_reg[22]_0 ;
  output [4:0]status;
  output [1:0]\event_kind_reg[1]_0 ;
  output [7:0]\faults_reg[7]_0 ;
  output [10:0]\snapshot_sequence_reg[10] ;
  output [0:0]\faults_reg[0]_0 ;
  output [31:0]\window_count_reg[31]_0 ;
  output [31:0]\event_epoch_reg[31]_0 ;
  output [31:0]\event_sequence_reg[31]_0 ;
  output s_axi_aresetn_0;
  output snapshot_valid_reg;
  output [31:0]\last_sum_reg[31]_0 ;
  output [63:0]\event_sample_reg[63]_0 ;
  output [31:0]\event_window_reg[31]_0 ;
  input dc_clipped0;
  input s_axi_aclk;
  input [15:0]D;
  input [0:0]\difference_latched_reg[12]_0 ;
  input [3:0]\difference_latched_reg[12]_1 ;
  input [3:0]S;
  input [3:0]\difference_latched_reg[20]_0 ;
  input [1:0]\difference_latched_reg[24]_0 ;
  input configure;
  input [0:0]\faults_reg[0]_1 ;
  input input_fault;
  input [0:0]\faults_reg[1]_0 ;
  input pcm_valid;
  input ack_error_reg_0;
  input s_axi_aresetn;
  input \s_axi_rdata_reg[2] ;
  input \s_axi_rdata_reg[2]_0 ;
  input \s_axi_rdata_reg[2]_1 ;
  input \s_axi_rdata_reg[2]_2 ;
  input \s_axi_rdata_reg[2]_3 ;
  input [7:0]\s_axi_rdata_reg[9] ;
  input \s_axi_rdata_reg[2]_4 ;
  input [31:0]above_loud_carry__2_0;
  input [31:0]\faults[7]_i_10_0 ;
  input [31:0]quiet_carry__2_0;
  input [31:0]matching_ack1_carry__1_0;
  input [31:0]matching_ack0_carry__1_0;
  input \s_axi_rdata_reg[0] ;
  input \s_axi_rdata_reg[0]_0 ;
  input \s_axi_rdata_reg[1] ;
  input \s_axi_rdata_reg[1]_0 ;
  input \s_axi_rdata_reg[3] ;
  input \s_axi_rdata_reg[3]_0 ;
  input \s_axi_rdata_reg[4] ;
  input \s_axi_rdata_reg[4]_0 ;
  input \s_axi_rdata_reg[5] ;
  input \s_axi_rdata_reg[5]_0 ;
  input \s_axi_rdata_reg[6] ;
  input \s_axi_rdata_reg[6]_0 ;
  input \s_axi_rdata_reg[7] ;
  input \s_axi_rdata_reg[7]_0 ;
  input \s_axi_rdata_reg[8] ;
  input \s_axi_rdata_reg[8]_0 ;
  input \s_axi_rdata_reg[8]_1 ;
  input \s_axi_rdata_reg[9]_0 ;
  input \s_axi_rdata_reg[9]_1 ;
  input \s_axi_rdata_reg[10] ;
  input \s_axi_rdata_reg[10]_0 ;
  input \s_axi_rdata_reg[4]_1 ;
  input \s_axi_rdata_reg[4]_2 ;
  input \s_axi_rdata_reg[10]_1 ;
  input [31:0]config_epoch_reg;
  input \s_axi_rdata_reg[1]_1 ;
  input \s_axi_rdata_reg[3]_1 ;
  input snapshot_valid;
  input snapshot_valid_reg_0;
  input snapshot_valid_reg_1;
  input snapshot_valid_reg_2;
  input [0:0]snapshot_valid_reg_3;

  wire [15:0]D;
  wire [31:0]Q;
  wire [3:0]S;
  wire above_loud;
  wire above_loud_carry__0_i_1_n_0;
  wire above_loud_carry__0_i_2_n_0;
  wire above_loud_carry__0_i_3_n_0;
  wire above_loud_carry__0_i_4_n_0;
  wire above_loud_carry__0_i_5_n_0;
  wire above_loud_carry__0_i_6_n_0;
  wire above_loud_carry__0_i_7_n_0;
  wire above_loud_carry__0_i_8_n_0;
  wire above_loud_carry__0_n_0;
  wire above_loud_carry__0_n_1;
  wire above_loud_carry__0_n_2;
  wire above_loud_carry__0_n_3;
  wire above_loud_carry__1_i_1_n_0;
  wire above_loud_carry__1_i_2_n_0;
  wire above_loud_carry__1_i_3_n_0;
  wire above_loud_carry__1_i_4_n_0;
  wire above_loud_carry__1_i_5_n_0;
  wire above_loud_carry__1_i_6_n_0;
  wire above_loud_carry__1_i_7_n_0;
  wire above_loud_carry__1_i_8_n_0;
  wire above_loud_carry__1_n_0;
  wire above_loud_carry__1_n_1;
  wire above_loud_carry__1_n_2;
  wire above_loud_carry__1_n_3;
  wire [31:0]above_loud_carry__2_0;
  wire above_loud_carry__2_i_1_n_0;
  wire above_loud_carry__2_i_2_n_0;
  wire above_loud_carry__2_i_3_n_0;
  wire above_loud_carry__2_i_4_n_0;
  wire above_loud_carry__2_i_5_n_0;
  wire above_loud_carry__2_i_6_n_0;
  wire above_loud_carry__2_i_7_n_0;
  wire above_loud_carry__2_i_8_n_0;
  wire above_loud_carry__2_n_0;
  wire above_loud_carry__2_n_1;
  wire above_loud_carry__2_n_2;
  wire above_loud_carry__2_n_3;
  wire above_loud_carry__3_i_1_n_0;
  wire above_loud_carry_i_1_n_0;
  wire above_loud_carry_i_2_n_0;
  wire above_loud_carry_i_3_n_0;
  wire above_loud_carry_i_4_n_0;
  wire above_loud_carry_i_5_n_0;
  wire above_loud_carry_i_6_n_0;
  wire above_loud_carry_i_7_n_0;
  wire above_loud_carry_i_8_n_0;
  wire above_loud_carry_n_0;
  wire above_loud_carry_n_1;
  wire above_loud_carry_n_2;
  wire above_loud_carry_n_3;
  wire above_soft_carry__0_i_1_n_0;
  wire above_soft_carry__0_i_2_n_0;
  wire above_soft_carry__0_i_3_n_0;
  wire above_soft_carry__0_i_4_n_0;
  wire above_soft_carry__0_i_5_n_0;
  wire above_soft_carry__0_i_6_n_0;
  wire above_soft_carry__0_i_7_n_0;
  wire above_soft_carry__0_i_8_n_0;
  wire above_soft_carry__0_n_0;
  wire above_soft_carry__0_n_1;
  wire above_soft_carry__0_n_2;
  wire above_soft_carry__0_n_3;
  wire above_soft_carry__1_i_1_n_0;
  wire above_soft_carry__1_i_2_n_0;
  wire above_soft_carry__1_i_3_n_0;
  wire above_soft_carry__1_i_4_n_0;
  wire above_soft_carry__1_i_5_n_0;
  wire above_soft_carry__1_i_6_n_0;
  wire above_soft_carry__1_i_7_n_0;
  wire above_soft_carry__1_i_8_n_0;
  wire above_soft_carry__1_n_0;
  wire above_soft_carry__1_n_1;
  wire above_soft_carry__1_n_2;
  wire above_soft_carry__1_n_3;
  wire above_soft_carry__2_i_1_n_0;
  wire above_soft_carry__2_i_2_n_0;
  wire above_soft_carry__2_i_3_n_0;
  wire above_soft_carry__2_i_4_n_0;
  wire above_soft_carry__2_i_5_n_0;
  wire above_soft_carry__2_i_6_n_0;
  wire above_soft_carry__2_i_7_n_0;
  wire above_soft_carry__2_i_8_n_0;
  wire above_soft_carry__2_n_0;
  wire above_soft_carry__2_n_1;
  wire above_soft_carry__2_n_2;
  wire above_soft_carry__2_n_3;
  wire above_soft_carry__3_i_2_n_0;
  wire above_soft_carry_i_1_n_0;
  wire above_soft_carry_i_2_n_0;
  wire above_soft_carry_i_3_n_0;
  wire above_soft_carry_i_4_n_0;
  wire above_soft_carry_i_5_n_0;
  wire above_soft_carry_i_6_n_0;
  wire above_soft_carry_i_7_n_0;
  wire above_soft_carry_i_8_n_0;
  wire above_soft_carry_n_0;
  wire above_soft_carry_n_1;
  wire above_soft_carry_n_2;
  wire above_soft_carry_n_3;
  wire [31:0]accumulation;
  wire \accumulation[11]_i_10_n_0 ;
  wire \accumulation[11]_i_2_n_0 ;
  wire \accumulation[11]_i_3_n_0 ;
  wire \accumulation[11]_i_4_n_0 ;
  wire \accumulation[11]_i_5_n_0 ;
  wire \accumulation[11]_i_7_n_0 ;
  wire \accumulation[11]_i_8_n_0 ;
  wire \accumulation[11]_i_9_n_0 ;
  wire \accumulation[15]_i_10_n_0 ;
  wire \accumulation[15]_i_2_n_0 ;
  wire \accumulation[15]_i_3_n_0 ;
  wire \accumulation[15]_i_4_n_0 ;
  wire \accumulation[15]_i_5_n_0 ;
  wire \accumulation[15]_i_7_n_0 ;
  wire \accumulation[15]_i_8_n_0 ;
  wire \accumulation[15]_i_9_n_0 ;
  wire \accumulation[19]_i_10_n_0 ;
  wire \accumulation[19]_i_2_n_0 ;
  wire \accumulation[19]_i_3_n_0 ;
  wire \accumulation[19]_i_6_n_0 ;
  wire \accumulation[19]_i_7_n_0 ;
  wire \accumulation[19]_i_8_n_0 ;
  wire \accumulation[19]_i_9_n_0 ;
  wire \accumulation[3]_i_2_n_0 ;
  wire \accumulation[3]_i_3_n_0 ;
  wire \accumulation[3]_i_4_n_0 ;
  wire \accumulation[3]_i_5_n_0 ;
  wire \accumulation[7]_i_10_n_0 ;
  wire \accumulation[7]_i_11_n_0 ;
  wire \accumulation[7]_i_2_n_0 ;
  wire \accumulation[7]_i_3_n_0 ;
  wire \accumulation[7]_i_4_n_0 ;
  wire \accumulation[7]_i_5_n_0 ;
  wire \accumulation[7]_i_7_n_0 ;
  wire \accumulation[7]_i_8_n_0 ;
  wire \accumulation[7]_i_9_n_0 ;
  wire \accumulation_reg[11]_i_1_n_0 ;
  wire \accumulation_reg[11]_i_1_n_1 ;
  wire \accumulation_reg[11]_i_1_n_2 ;
  wire \accumulation_reg[11]_i_1_n_3 ;
  wire \accumulation_reg[11]_i_1_n_4 ;
  wire \accumulation_reg[11]_i_1_n_5 ;
  wire \accumulation_reg[11]_i_1_n_6 ;
  wire \accumulation_reg[11]_i_1_n_7 ;
  wire \accumulation_reg[11]_i_6_n_0 ;
  wire \accumulation_reg[11]_i_6_n_1 ;
  wire \accumulation_reg[11]_i_6_n_2 ;
  wire \accumulation_reg[11]_i_6_n_3 ;
  wire \accumulation_reg[15]_i_1_n_0 ;
  wire \accumulation_reg[15]_i_1_n_1 ;
  wire \accumulation_reg[15]_i_1_n_2 ;
  wire \accumulation_reg[15]_i_1_n_3 ;
  wire \accumulation_reg[15]_i_1_n_4 ;
  wire \accumulation_reg[15]_i_1_n_5 ;
  wire \accumulation_reg[15]_i_1_n_6 ;
  wire \accumulation_reg[15]_i_1_n_7 ;
  wire \accumulation_reg[15]_i_6_n_0 ;
  wire \accumulation_reg[15]_i_6_n_1 ;
  wire \accumulation_reg[15]_i_6_n_2 ;
  wire \accumulation_reg[15]_i_6_n_3 ;
  wire \accumulation_reg[19]_i_1_n_0 ;
  wire \accumulation_reg[19]_i_1_n_1 ;
  wire \accumulation_reg[19]_i_1_n_2 ;
  wire \accumulation_reg[19]_i_1_n_3 ;
  wire \accumulation_reg[19]_i_1_n_4 ;
  wire \accumulation_reg[19]_i_1_n_5 ;
  wire \accumulation_reg[19]_i_1_n_6 ;
  wire \accumulation_reg[19]_i_1_n_7 ;
  wire \accumulation_reg[19]_i_5_n_0 ;
  wire \accumulation_reg[19]_i_5_n_1 ;
  wire \accumulation_reg[19]_i_5_n_2 ;
  wire \accumulation_reg[19]_i_5_n_3 ;
  wire \accumulation_reg[23]_i_1_n_0 ;
  wire \accumulation_reg[23]_i_1_n_1 ;
  wire \accumulation_reg[23]_i_1_n_2 ;
  wire \accumulation_reg[23]_i_1_n_3 ;
  wire \accumulation_reg[23]_i_1_n_4 ;
  wire \accumulation_reg[23]_i_1_n_5 ;
  wire \accumulation_reg[23]_i_1_n_6 ;
  wire \accumulation_reg[23]_i_1_n_7 ;
  wire \accumulation_reg[27]_i_1_n_0 ;
  wire \accumulation_reg[27]_i_1_n_1 ;
  wire \accumulation_reg[27]_i_1_n_2 ;
  wire \accumulation_reg[27]_i_1_n_3 ;
  wire \accumulation_reg[27]_i_1_n_4 ;
  wire \accumulation_reg[27]_i_1_n_5 ;
  wire \accumulation_reg[27]_i_1_n_6 ;
  wire \accumulation_reg[27]_i_1_n_7 ;
  wire \accumulation_reg[31]_i_1_n_0 ;
  wire \accumulation_reg[31]_i_1_n_1 ;
  wire \accumulation_reg[31]_i_1_n_2 ;
  wire \accumulation_reg[31]_i_1_n_3 ;
  wire \accumulation_reg[31]_i_1_n_4 ;
  wire \accumulation_reg[31]_i_1_n_5 ;
  wire \accumulation_reg[31]_i_1_n_6 ;
  wire \accumulation_reg[31]_i_1_n_7 ;
  wire \accumulation_reg[3]_i_1_n_0 ;
  wire \accumulation_reg[3]_i_1_n_1 ;
  wire \accumulation_reg[3]_i_1_n_2 ;
  wire \accumulation_reg[3]_i_1_n_3 ;
  wire \accumulation_reg[3]_i_1_n_4 ;
  wire \accumulation_reg[3]_i_1_n_5 ;
  wire \accumulation_reg[3]_i_1_n_6 ;
  wire \accumulation_reg[3]_i_1_n_7 ;
  wire \accumulation_reg[7]_i_1_n_0 ;
  wire \accumulation_reg[7]_i_1_n_1 ;
  wire \accumulation_reg[7]_i_1_n_2 ;
  wire \accumulation_reg[7]_i_1_n_3 ;
  wire \accumulation_reg[7]_i_1_n_4 ;
  wire \accumulation_reg[7]_i_1_n_5 ;
  wire \accumulation_reg[7]_i_1_n_6 ;
  wire \accumulation_reg[7]_i_1_n_7 ;
  wire \accumulation_reg[7]_i_6_n_0 ;
  wire \accumulation_reg[7]_i_6_n_1 ;
  wire \accumulation_reg[7]_i_6_n_2 ;
  wire \accumulation_reg[7]_i_6_n_3 ;
  wire ack_error_i_1_n_0;
  wire ack_error_i_2_n_0;
  wire ack_error_i_3_n_0;
  wire ack_error_reg_0;
  wire [2:0]candidate_count;
  wire \candidate_count[0]_i_1_n_0 ;
  wire \candidate_count[1]_i_1_n_0 ;
  wire \candidate_count[2]_i_2_n_0 ;
  wire \candidate_count[2]_i_3_n_0 ;
  wire \candidate_count[2]_i_4_n_0 ;
  wire \candidate_count[2]_i_5_n_0 ;
  wire [25:8]centered;
  wire centered_carry__0_n_0;
  wire centered_carry__0_n_1;
  wire centered_carry__0_n_2;
  wire centered_carry__0_n_3;
  wire centered_carry__1_n_0;
  wire centered_carry__1_n_1;
  wire centered_carry__1_n_2;
  wire centered_carry__1_n_3;
  wire centered_carry__2_n_0;
  wire centered_carry__2_n_1;
  wire centered_carry__2_n_2;
  wire centered_carry__2_n_3;
  wire centered_carry__3_n_0;
  wire centered_carry__3_n_1;
  wire centered_carry__3_n_2;
  wire centered_carry__3_n_3;
  wire centered_carry__4_n_0;
  wire centered_carry__4_n_1;
  wire centered_carry__4_n_2;
  wire centered_carry__4_n_3;
  wire centered_carry_i_1__0_n_0;
  wire centered_carry_i_1__1_n_0;
  wire centered_carry_i_1__2_n_0;
  wire centered_carry_i_1__3_n_0;
  wire centered_carry_i_1__4_n_0;
  wire centered_carry_i_1__5_n_0;
  wire centered_carry_i_1_n_0;
  wire centered_carry_i_2__0_n_0;
  wire centered_carry_i_2__1_n_0;
  wire centered_carry_i_2__2_n_0;
  wire centered_carry_i_2__3_n_0;
  wire centered_carry_i_2__4_n_0;
  wire centered_carry_i_2_n_0;
  wire centered_carry_i_3__0_n_0;
  wire centered_carry_i_3__1_n_0;
  wire centered_carry_i_3__2_n_0;
  wire centered_carry_i_3__3_n_0;
  wire centered_carry_i_3__4_n_0;
  wire centered_carry_i_3_n_0;
  wire centered_carry_i_4__0_n_0;
  wire centered_carry_i_4__1_n_0;
  wire centered_carry_i_4__2_n_0;
  wire centered_carry_i_4__3_n_0;
  wire centered_carry_i_4__4_n_0;
  wire centered_carry_i_4_n_0;
  wire centered_carry_i_5_n_0;
  wire centered_carry_n_0;
  wire centered_carry_n_1;
  wire centered_carry_n_2;
  wire centered_carry_n_3;
  wire [0:0]clipped_count;
  wire \clipped_count[15]_i_2_n_0 ;
  wire \clipped_count[15]_i_4_n_0 ;
  wire \clipped_count[3]_i_2_n_0 ;
  wire \clipped_count_reg[11]_i_1_n_0 ;
  wire \clipped_count_reg[11]_i_1_n_1 ;
  wire \clipped_count_reg[11]_i_1_n_2 ;
  wire \clipped_count_reg[11]_i_1_n_3 ;
  wire \clipped_count_reg[15]_i_3_n_0 ;
  wire \clipped_count_reg[15]_i_3_n_1 ;
  wire \clipped_count_reg[15]_i_3_n_2 ;
  wire \clipped_count_reg[15]_i_3_n_3 ;
  wire \clipped_count_reg[3]_i_1_n_0 ;
  wire \clipped_count_reg[3]_i_1_n_1 ;
  wire \clipped_count_reg[3]_i_1_n_2 ;
  wire \clipped_count_reg[3]_i_1_n_3 ;
  wire \clipped_count_reg[7]_i_1_n_0 ;
  wire \clipped_count_reg[7]_i_1_n_1 ;
  wire \clipped_count_reg[7]_i_1_n_2 ;
  wire \clipped_count_reg[7]_i_1_n_3 ;
  wire \clipped_count_reg_n_0_[0] ;
  wire \clipped_count_reg_n_0_[10] ;
  wire \clipped_count_reg_n_0_[11] ;
  wire \clipped_count_reg_n_0_[12] ;
  wire \clipped_count_reg_n_0_[13] ;
  wire \clipped_count_reg_n_0_[14] ;
  wire \clipped_count_reg_n_0_[15] ;
  wire \clipped_count_reg_n_0_[1] ;
  wire \clipped_count_reg_n_0_[2] ;
  wire \clipped_count_reg_n_0_[3] ;
  wire \clipped_count_reg_n_0_[4] ;
  wire \clipped_count_reg_n_0_[5] ;
  wire \clipped_count_reg_n_0_[6] ;
  wire \clipped_count_reg_n_0_[7] ;
  wire \clipped_count_reg_n_0_[8] ;
  wire \clipped_count_reg_n_0_[9] ;
  wire [31:0]config_epoch_reg;
  wire configure;
  wire dc_clipped;
  wire dc_clipped0;
  wire [25:10]dc_difference;
  wire dc_difference_carry__0_n_0;
  wire dc_difference_carry__0_n_1;
  wire dc_difference_carry__0_n_2;
  wire dc_difference_carry__0_n_3;
  wire dc_difference_carry__1_n_0;
  wire dc_difference_carry__1_n_1;
  wire dc_difference_carry__1_n_2;
  wire dc_difference_carry__1_n_3;
  wire dc_difference_carry__2_n_0;
  wire dc_difference_carry__2_n_1;
  wire dc_difference_carry__2_n_2;
  wire dc_difference_carry__2_n_3;
  wire dc_difference_carry__3_n_0;
  wire dc_difference_carry__3_n_1;
  wire dc_difference_carry__3_n_2;
  wire dc_difference_carry__3_n_3;
  wire dc_difference_carry__4_i_1_n_0;
  wire dc_difference_carry__4_i_2_n_0;
  wire dc_difference_carry__4_n_0;
  wire dc_difference_carry__4_n_1;
  wire dc_difference_carry__4_n_2;
  wire dc_difference_carry__4_n_3;
  wire dc_difference_carry_n_0;
  wire dc_difference_carry_n_1;
  wire dc_difference_carry_n_2;
  wire dc_difference_carry_n_3;
  wire [24:0]dc_level;
  wire dc_level0;
  wire [14:0]\dc_level_reg[22]_0 ;
  wire dc_valid;
  wire dc_valid_i_1_n_0;
  wire [0:0]\difference_latched_reg[12]_0 ;
  wire [3:0]\difference_latched_reg[12]_1 ;
  wire [3:0]\difference_latched_reg[20]_0 ;
  wire [1:0]\difference_latched_reg[24]_0 ;
  wire \difference_latched_reg_n_0_[10] ;
  wire \difference_latched_reg_n_0_[11] ;
  wire \difference_latched_reg_n_0_[12] ;
  wire \difference_latched_reg_n_0_[13] ;
  wire \difference_latched_reg_n_0_[14] ;
  wire \difference_latched_reg_n_0_[15] ;
  wire \difference_latched_reg_n_0_[16] ;
  wire \difference_latched_reg_n_0_[17] ;
  wire \difference_latched_reg_n_0_[18] ;
  wire \difference_latched_reg_n_0_[19] ;
  wire \difference_latched_reg_n_0_[20] ;
  wire \difference_latched_reg_n_0_[21] ;
  wire \difference_latched_reg_n_0_[22] ;
  wire \difference_latched_reg_n_0_[23] ;
  wire \difference_latched_reg_n_0_[24] ;
  wire event_age0_carry__0_n_0;
  wire event_age0_carry__0_n_1;
  wire event_age0_carry__0_n_2;
  wire event_age0_carry__0_n_3;
  wire event_age0_carry__0_n_4;
  wire event_age0_carry__0_n_5;
  wire event_age0_carry__0_n_6;
  wire event_age0_carry__0_n_7;
  wire event_age0_carry__1_n_0;
  wire event_age0_carry__1_n_1;
  wire event_age0_carry__1_n_2;
  wire event_age0_carry__1_n_3;
  wire event_age0_carry__1_n_4;
  wire event_age0_carry__1_n_5;
  wire event_age0_carry__1_n_6;
  wire event_age0_carry__1_n_7;
  wire event_age0_carry__2_n_0;
  wire event_age0_carry__2_n_1;
  wire event_age0_carry__2_n_2;
  wire event_age0_carry__2_n_3;
  wire event_age0_carry__2_n_4;
  wire event_age0_carry__2_n_5;
  wire event_age0_carry__2_n_6;
  wire event_age0_carry__2_n_7;
  wire event_age0_carry__3_n_0;
  wire event_age0_carry__3_n_1;
  wire event_age0_carry__3_n_2;
  wire event_age0_carry__3_n_3;
  wire event_age0_carry__3_n_4;
  wire event_age0_carry__3_n_5;
  wire event_age0_carry__3_n_6;
  wire event_age0_carry__3_n_7;
  wire event_age0_carry__4_n_0;
  wire event_age0_carry__4_n_1;
  wire event_age0_carry__4_n_2;
  wire event_age0_carry__4_n_3;
  wire event_age0_carry__4_n_4;
  wire event_age0_carry__4_n_5;
  wire event_age0_carry__4_n_6;
  wire event_age0_carry__4_n_7;
  wire event_age0_carry__5_n_0;
  wire event_age0_carry__5_n_1;
  wire event_age0_carry__5_n_2;
  wire event_age0_carry__5_n_3;
  wire event_age0_carry__5_n_4;
  wire event_age0_carry__5_n_5;
  wire event_age0_carry__5_n_6;
  wire event_age0_carry__5_n_7;
  wire event_age0_carry__6_n_2;
  wire event_age0_carry__6_n_3;
  wire event_age0_carry__6_n_5;
  wire event_age0_carry__6_n_6;
  wire event_age0_carry__6_n_7;
  wire event_age0_carry_n_0;
  wire event_age0_carry_n_1;
  wire event_age0_carry_n_2;
  wire event_age0_carry_n_3;
  wire event_age0_carry_n_4;
  wire event_age0_carry_n_5;
  wire event_age0_carry_n_6;
  wire event_age0_carry_n_7;
  wire \event_age[0]_i_1_n_0 ;
  wire \event_age[10]_i_1_n_0 ;
  wire \event_age[11]_i_1_n_0 ;
  wire \event_age[12]_i_1_n_0 ;
  wire \event_age[13]_i_1_n_0 ;
  wire \event_age[14]_i_1_n_0 ;
  wire \event_age[15]_i_1_n_0 ;
  wire \event_age[16]_i_1_n_0 ;
  wire \event_age[17]_i_1_n_0 ;
  wire \event_age[18]_i_1_n_0 ;
  wire \event_age[19]_i_1_n_0 ;
  wire \event_age[1]_i_1_n_0 ;
  wire \event_age[20]_i_1_n_0 ;
  wire \event_age[21]_i_1_n_0 ;
  wire \event_age[22]_i_1_n_0 ;
  wire \event_age[23]_i_1_n_0 ;
  wire \event_age[24]_i_1_n_0 ;
  wire \event_age[25]_i_1_n_0 ;
  wire \event_age[26]_i_1_n_0 ;
  wire \event_age[27]_i_1_n_0 ;
  wire \event_age[28]_i_1_n_0 ;
  wire \event_age[29]_i_1_n_0 ;
  wire \event_age[2]_i_1_n_0 ;
  wire \event_age[30]_i_1_n_0 ;
  wire \event_age[31]_i_1_n_0 ;
  wire \event_age[31]_i_2_n_0 ;
  wire \event_age[31]_i_3_n_0 ;
  wire \event_age[31]_i_4_n_0 ;
  wire \event_age[31]_i_5_n_0 ;
  wire \event_age[31]_i_6_n_0 ;
  wire \event_age[31]_i_7_n_0 ;
  wire \event_age[31]_i_8_n_0 ;
  wire \event_age[3]_i_1_n_0 ;
  wire \event_age[4]_i_1_n_0 ;
  wire \event_age[5]_i_1_n_0 ;
  wire \event_age[6]_i_1_n_0 ;
  wire \event_age[7]_i_1_n_0 ;
  wire \event_age[8]_i_1_n_0 ;
  wire \event_age[9]_i_1_n_0 ;
  wire \event_epoch[31]_i_1_n_0 ;
  wire [31:0]\event_epoch_reg[31]_0 ;
  wire \event_kind[0]_i_1_n_0 ;
  wire \event_kind[1]_i_1_n_0 ;
  wire \event_kind[1]_i_2_n_0 ;
  wire \event_kind[1]_i_3_n_0 ;
  wire [1:0]\event_kind_reg[1]_0 ;
  wire event_pending4_out;
  wire event_pending_i_1_n_0;
  wire event_pending_i_2_n_0;
  wire \event_sample[0]_i_1_n_0 ;
  wire \event_sample[63]_i_1_n_0 ;
  wire \event_sample_reg[12]_i_1_n_0 ;
  wire \event_sample_reg[12]_i_1_n_1 ;
  wire \event_sample_reg[12]_i_1_n_2 ;
  wire \event_sample_reg[12]_i_1_n_3 ;
  wire \event_sample_reg[12]_i_1_n_4 ;
  wire \event_sample_reg[12]_i_1_n_5 ;
  wire \event_sample_reg[12]_i_1_n_6 ;
  wire \event_sample_reg[12]_i_1_n_7 ;
  wire \event_sample_reg[16]_i_1_n_0 ;
  wire \event_sample_reg[16]_i_1_n_1 ;
  wire \event_sample_reg[16]_i_1_n_2 ;
  wire \event_sample_reg[16]_i_1_n_3 ;
  wire \event_sample_reg[16]_i_1_n_4 ;
  wire \event_sample_reg[16]_i_1_n_5 ;
  wire \event_sample_reg[16]_i_1_n_6 ;
  wire \event_sample_reg[16]_i_1_n_7 ;
  wire \event_sample_reg[20]_i_1_n_0 ;
  wire \event_sample_reg[20]_i_1_n_1 ;
  wire \event_sample_reg[20]_i_1_n_2 ;
  wire \event_sample_reg[20]_i_1_n_3 ;
  wire \event_sample_reg[20]_i_1_n_4 ;
  wire \event_sample_reg[20]_i_1_n_5 ;
  wire \event_sample_reg[20]_i_1_n_6 ;
  wire \event_sample_reg[20]_i_1_n_7 ;
  wire \event_sample_reg[24]_i_1_n_0 ;
  wire \event_sample_reg[24]_i_1_n_1 ;
  wire \event_sample_reg[24]_i_1_n_2 ;
  wire \event_sample_reg[24]_i_1_n_3 ;
  wire \event_sample_reg[24]_i_1_n_4 ;
  wire \event_sample_reg[24]_i_1_n_5 ;
  wire \event_sample_reg[24]_i_1_n_6 ;
  wire \event_sample_reg[24]_i_1_n_7 ;
  wire \event_sample_reg[28]_i_1_n_0 ;
  wire \event_sample_reg[28]_i_1_n_1 ;
  wire \event_sample_reg[28]_i_1_n_2 ;
  wire \event_sample_reg[28]_i_1_n_3 ;
  wire \event_sample_reg[28]_i_1_n_4 ;
  wire \event_sample_reg[28]_i_1_n_5 ;
  wire \event_sample_reg[28]_i_1_n_6 ;
  wire \event_sample_reg[28]_i_1_n_7 ;
  wire \event_sample_reg[32]_i_1_n_0 ;
  wire \event_sample_reg[32]_i_1_n_1 ;
  wire \event_sample_reg[32]_i_1_n_2 ;
  wire \event_sample_reg[32]_i_1_n_3 ;
  wire \event_sample_reg[32]_i_1_n_4 ;
  wire \event_sample_reg[32]_i_1_n_5 ;
  wire \event_sample_reg[32]_i_1_n_6 ;
  wire \event_sample_reg[32]_i_1_n_7 ;
  wire \event_sample_reg[36]_i_1_n_0 ;
  wire \event_sample_reg[36]_i_1_n_1 ;
  wire \event_sample_reg[36]_i_1_n_2 ;
  wire \event_sample_reg[36]_i_1_n_3 ;
  wire \event_sample_reg[36]_i_1_n_4 ;
  wire \event_sample_reg[36]_i_1_n_5 ;
  wire \event_sample_reg[36]_i_1_n_6 ;
  wire \event_sample_reg[36]_i_1_n_7 ;
  wire \event_sample_reg[40]_i_1_n_0 ;
  wire \event_sample_reg[40]_i_1_n_1 ;
  wire \event_sample_reg[40]_i_1_n_2 ;
  wire \event_sample_reg[40]_i_1_n_3 ;
  wire \event_sample_reg[40]_i_1_n_4 ;
  wire \event_sample_reg[40]_i_1_n_5 ;
  wire \event_sample_reg[40]_i_1_n_6 ;
  wire \event_sample_reg[40]_i_1_n_7 ;
  wire \event_sample_reg[44]_i_1_n_0 ;
  wire \event_sample_reg[44]_i_1_n_1 ;
  wire \event_sample_reg[44]_i_1_n_2 ;
  wire \event_sample_reg[44]_i_1_n_3 ;
  wire \event_sample_reg[44]_i_1_n_4 ;
  wire \event_sample_reg[44]_i_1_n_5 ;
  wire \event_sample_reg[44]_i_1_n_6 ;
  wire \event_sample_reg[44]_i_1_n_7 ;
  wire \event_sample_reg[48]_i_1_n_0 ;
  wire \event_sample_reg[48]_i_1_n_1 ;
  wire \event_sample_reg[48]_i_1_n_2 ;
  wire \event_sample_reg[48]_i_1_n_3 ;
  wire \event_sample_reg[48]_i_1_n_4 ;
  wire \event_sample_reg[48]_i_1_n_5 ;
  wire \event_sample_reg[48]_i_1_n_6 ;
  wire \event_sample_reg[48]_i_1_n_7 ;
  wire \event_sample_reg[4]_i_1_n_0 ;
  wire \event_sample_reg[4]_i_1_n_1 ;
  wire \event_sample_reg[4]_i_1_n_2 ;
  wire \event_sample_reg[4]_i_1_n_3 ;
  wire \event_sample_reg[4]_i_1_n_4 ;
  wire \event_sample_reg[4]_i_1_n_5 ;
  wire \event_sample_reg[4]_i_1_n_6 ;
  wire \event_sample_reg[4]_i_1_n_7 ;
  wire \event_sample_reg[52]_i_1_n_0 ;
  wire \event_sample_reg[52]_i_1_n_1 ;
  wire \event_sample_reg[52]_i_1_n_2 ;
  wire \event_sample_reg[52]_i_1_n_3 ;
  wire \event_sample_reg[52]_i_1_n_4 ;
  wire \event_sample_reg[52]_i_1_n_5 ;
  wire \event_sample_reg[52]_i_1_n_6 ;
  wire \event_sample_reg[52]_i_1_n_7 ;
  wire \event_sample_reg[56]_i_1_n_0 ;
  wire \event_sample_reg[56]_i_1_n_1 ;
  wire \event_sample_reg[56]_i_1_n_2 ;
  wire \event_sample_reg[56]_i_1_n_3 ;
  wire \event_sample_reg[56]_i_1_n_4 ;
  wire \event_sample_reg[56]_i_1_n_5 ;
  wire \event_sample_reg[56]_i_1_n_6 ;
  wire \event_sample_reg[56]_i_1_n_7 ;
  wire \event_sample_reg[60]_i_1_n_0 ;
  wire \event_sample_reg[60]_i_1_n_1 ;
  wire \event_sample_reg[60]_i_1_n_2 ;
  wire \event_sample_reg[60]_i_1_n_3 ;
  wire \event_sample_reg[60]_i_1_n_4 ;
  wire \event_sample_reg[60]_i_1_n_5 ;
  wire \event_sample_reg[60]_i_1_n_6 ;
  wire \event_sample_reg[60]_i_1_n_7 ;
  wire [63:0]\event_sample_reg[63]_0 ;
  wire \event_sample_reg[63]_i_2_n_2 ;
  wire \event_sample_reg[63]_i_2_n_3 ;
  wire \event_sample_reg[63]_i_2_n_5 ;
  wire \event_sample_reg[63]_i_2_n_6 ;
  wire \event_sample_reg[63]_i_2_n_7 ;
  wire \event_sample_reg[8]_i_1_n_0 ;
  wire \event_sample_reg[8]_i_1_n_1 ;
  wire \event_sample_reg[8]_i_1_n_2 ;
  wire \event_sample_reg[8]_i_1_n_3 ;
  wire \event_sample_reg[8]_i_1_n_4 ;
  wire \event_sample_reg[8]_i_1_n_5 ;
  wire \event_sample_reg[8]_i_1_n_6 ;
  wire \event_sample_reg[8]_i_1_n_7 ;
  wire \event_sequence[0]_i_2_n_0 ;
  wire \event_sequence_reg[0]_i_1_n_0 ;
  wire \event_sequence_reg[0]_i_1_n_1 ;
  wire \event_sequence_reg[0]_i_1_n_2 ;
  wire \event_sequence_reg[0]_i_1_n_3 ;
  wire \event_sequence_reg[0]_i_1_n_4 ;
  wire \event_sequence_reg[0]_i_1_n_5 ;
  wire \event_sequence_reg[0]_i_1_n_6 ;
  wire \event_sequence_reg[0]_i_1_n_7 ;
  wire \event_sequence_reg[12]_i_1_n_0 ;
  wire \event_sequence_reg[12]_i_1_n_1 ;
  wire \event_sequence_reg[12]_i_1_n_2 ;
  wire \event_sequence_reg[12]_i_1_n_3 ;
  wire \event_sequence_reg[12]_i_1_n_4 ;
  wire \event_sequence_reg[12]_i_1_n_5 ;
  wire \event_sequence_reg[12]_i_1_n_6 ;
  wire \event_sequence_reg[12]_i_1_n_7 ;
  wire \event_sequence_reg[16]_i_1_n_0 ;
  wire \event_sequence_reg[16]_i_1_n_1 ;
  wire \event_sequence_reg[16]_i_1_n_2 ;
  wire \event_sequence_reg[16]_i_1_n_3 ;
  wire \event_sequence_reg[16]_i_1_n_4 ;
  wire \event_sequence_reg[16]_i_1_n_5 ;
  wire \event_sequence_reg[16]_i_1_n_6 ;
  wire \event_sequence_reg[16]_i_1_n_7 ;
  wire \event_sequence_reg[20]_i_1_n_0 ;
  wire \event_sequence_reg[20]_i_1_n_1 ;
  wire \event_sequence_reg[20]_i_1_n_2 ;
  wire \event_sequence_reg[20]_i_1_n_3 ;
  wire \event_sequence_reg[20]_i_1_n_4 ;
  wire \event_sequence_reg[20]_i_1_n_5 ;
  wire \event_sequence_reg[20]_i_1_n_6 ;
  wire \event_sequence_reg[20]_i_1_n_7 ;
  wire \event_sequence_reg[24]_i_1_n_0 ;
  wire \event_sequence_reg[24]_i_1_n_1 ;
  wire \event_sequence_reg[24]_i_1_n_2 ;
  wire \event_sequence_reg[24]_i_1_n_3 ;
  wire \event_sequence_reg[24]_i_1_n_4 ;
  wire \event_sequence_reg[24]_i_1_n_5 ;
  wire \event_sequence_reg[24]_i_1_n_6 ;
  wire \event_sequence_reg[24]_i_1_n_7 ;
  wire \event_sequence_reg[28]_i_1_n_1 ;
  wire \event_sequence_reg[28]_i_1_n_2 ;
  wire \event_sequence_reg[28]_i_1_n_3 ;
  wire \event_sequence_reg[28]_i_1_n_4 ;
  wire \event_sequence_reg[28]_i_1_n_5 ;
  wire \event_sequence_reg[28]_i_1_n_6 ;
  wire \event_sequence_reg[28]_i_1_n_7 ;
  wire [31:0]\event_sequence_reg[31]_0 ;
  wire \event_sequence_reg[4]_i_1_n_0 ;
  wire \event_sequence_reg[4]_i_1_n_1 ;
  wire \event_sequence_reg[4]_i_1_n_2 ;
  wire \event_sequence_reg[4]_i_1_n_3 ;
  wire \event_sequence_reg[4]_i_1_n_4 ;
  wire \event_sequence_reg[4]_i_1_n_5 ;
  wire \event_sequence_reg[4]_i_1_n_6 ;
  wire \event_sequence_reg[4]_i_1_n_7 ;
  wire \event_sequence_reg[8]_i_1_n_0 ;
  wire \event_sequence_reg[8]_i_1_n_1 ;
  wire \event_sequence_reg[8]_i_1_n_2 ;
  wire \event_sequence_reg[8]_i_1_n_3 ;
  wire \event_sequence_reg[8]_i_1_n_4 ;
  wire \event_sequence_reg[8]_i_1_n_5 ;
  wire \event_sequence_reg[8]_i_1_n_6 ;
  wire \event_sequence_reg[8]_i_1_n_7 ;
  wire \event_window[0]_i_1_n_0 ;
  wire \event_window_reg[12]_i_1_n_0 ;
  wire \event_window_reg[12]_i_1_n_1 ;
  wire \event_window_reg[12]_i_1_n_2 ;
  wire \event_window_reg[12]_i_1_n_3 ;
  wire \event_window_reg[12]_i_1_n_4 ;
  wire \event_window_reg[12]_i_1_n_5 ;
  wire \event_window_reg[12]_i_1_n_6 ;
  wire \event_window_reg[12]_i_1_n_7 ;
  wire \event_window_reg[16]_i_1_n_0 ;
  wire \event_window_reg[16]_i_1_n_1 ;
  wire \event_window_reg[16]_i_1_n_2 ;
  wire \event_window_reg[16]_i_1_n_3 ;
  wire \event_window_reg[16]_i_1_n_4 ;
  wire \event_window_reg[16]_i_1_n_5 ;
  wire \event_window_reg[16]_i_1_n_6 ;
  wire \event_window_reg[16]_i_1_n_7 ;
  wire \event_window_reg[20]_i_1_n_0 ;
  wire \event_window_reg[20]_i_1_n_1 ;
  wire \event_window_reg[20]_i_1_n_2 ;
  wire \event_window_reg[20]_i_1_n_3 ;
  wire \event_window_reg[20]_i_1_n_4 ;
  wire \event_window_reg[20]_i_1_n_5 ;
  wire \event_window_reg[20]_i_1_n_6 ;
  wire \event_window_reg[20]_i_1_n_7 ;
  wire \event_window_reg[24]_i_1_n_0 ;
  wire \event_window_reg[24]_i_1_n_1 ;
  wire \event_window_reg[24]_i_1_n_2 ;
  wire \event_window_reg[24]_i_1_n_3 ;
  wire \event_window_reg[24]_i_1_n_4 ;
  wire \event_window_reg[24]_i_1_n_5 ;
  wire \event_window_reg[24]_i_1_n_6 ;
  wire \event_window_reg[24]_i_1_n_7 ;
  wire \event_window_reg[28]_i_1_n_0 ;
  wire \event_window_reg[28]_i_1_n_1 ;
  wire \event_window_reg[28]_i_1_n_2 ;
  wire \event_window_reg[28]_i_1_n_3 ;
  wire \event_window_reg[28]_i_1_n_4 ;
  wire \event_window_reg[28]_i_1_n_5 ;
  wire \event_window_reg[28]_i_1_n_6 ;
  wire \event_window_reg[28]_i_1_n_7 ;
  wire [31:0]\event_window_reg[31]_0 ;
  wire \event_window_reg[31]_i_1_n_2 ;
  wire \event_window_reg[31]_i_1_n_3 ;
  wire \event_window_reg[31]_i_1_n_5 ;
  wire \event_window_reg[31]_i_1_n_6 ;
  wire \event_window_reg[31]_i_1_n_7 ;
  wire \event_window_reg[4]_i_1_n_0 ;
  wire \event_window_reg[4]_i_1_n_1 ;
  wire \event_window_reg[4]_i_1_n_2 ;
  wire \event_window_reg[4]_i_1_n_3 ;
  wire \event_window_reg[4]_i_1_n_4 ;
  wire \event_window_reg[4]_i_1_n_5 ;
  wire \event_window_reg[4]_i_1_n_6 ;
  wire \event_window_reg[4]_i_1_n_7 ;
  wire \event_window_reg[8]_i_1_n_0 ;
  wire \event_window_reg[8]_i_1_n_1 ;
  wire \event_window_reg[8]_i_1_n_2 ;
  wire \event_window_reg[8]_i_1_n_3 ;
  wire \event_window_reg[8]_i_1_n_4 ;
  wire \event_window_reg[8]_i_1_n_5 ;
  wire \event_window_reg[8]_i_1_n_6 ;
  wire \event_window_reg[8]_i_1_n_7 ;
  wire \faults[0]_i_1_n_0 ;
  wire \faults[1]_i_1_n_0 ;
  wire \faults[1]_i_2_n_0 ;
  wire \faults[1]_i_3_n_0 ;
  wire \faults[1]_i_4_n_0 ;
  wire \faults[2]_i_1_n_0 ;
  wire \faults[2]_i_2_n_0 ;
  wire \faults[3]_i_1_n_0 ;
  wire \faults[4]_i_1_n_0 ;
  wire \faults[4]_i_2_n_0 ;
  wire \faults[4]_i_3_n_0 ;
  wire \faults[4]_i_4_n_0 ;
  wire \faults[4]_i_5_n_0 ;
  wire \faults[5]_i_10_n_0 ;
  wire \faults[5]_i_11_n_0 ;
  wire \faults[5]_i_12_n_0 ;
  wire \faults[5]_i_13_n_0 ;
  wire \faults[5]_i_14_n_0 ;
  wire \faults[5]_i_15_n_0 ;
  wire \faults[5]_i_16_n_0 ;
  wire \faults[5]_i_17_n_0 ;
  wire \faults[5]_i_18_n_0 ;
  wire \faults[5]_i_19_n_0 ;
  wire \faults[5]_i_1_n_0 ;
  wire \faults[5]_i_20_n_0 ;
  wire \faults[5]_i_21_n_0 ;
  wire \faults[5]_i_22_n_0 ;
  wire \faults[5]_i_2_n_0 ;
  wire \faults[5]_i_3_n_0 ;
  wire \faults[5]_i_4_n_0 ;
  wire \faults[5]_i_5_n_0 ;
  wire \faults[5]_i_6_n_0 ;
  wire \faults[5]_i_7_n_0 ;
  wire \faults[5]_i_8_n_0 ;
  wire \faults[5]_i_9_n_0 ;
  wire \faults[6]_i_10_n_0 ;
  wire \faults[6]_i_1_n_0 ;
  wire \faults[6]_i_2_n_0 ;
  wire \faults[6]_i_3_n_0 ;
  wire \faults[6]_i_4_n_0 ;
  wire \faults[6]_i_5_n_0 ;
  wire \faults[6]_i_6_n_0 ;
  wire \faults[6]_i_7_n_0 ;
  wire \faults[6]_i_8_n_0 ;
  wire \faults[6]_i_9_n_0 ;
  wire [31:0]\faults[7]_i_10_0 ;
  wire \faults[7]_i_10_n_0 ;
  wire \faults[7]_i_11_n_0 ;
  wire \faults[7]_i_12_n_0 ;
  wire \faults[7]_i_13_n_0 ;
  wire \faults[7]_i_14_n_0 ;
  wire \faults[7]_i_15_n_0 ;
  wire \faults[7]_i_16_n_0 ;
  wire \faults[7]_i_17_n_0 ;
  wire \faults[7]_i_1_n_0 ;
  wire \faults[7]_i_2_n_0 ;
  wire \faults[7]_i_3_n_0 ;
  wire \faults[7]_i_4_n_0 ;
  wire \faults[7]_i_5_n_0 ;
  wire \faults[7]_i_6_n_0 ;
  wire \faults[7]_i_7_n_0 ;
  wire \faults[7]_i_8_n_0 ;
  wire \faults[7]_i_9_n_0 ;
  wire [0:0]\faults_reg[0]_0 ;
  wire [0:0]\faults_reg[0]_1 ;
  wire [0:0]\faults_reg[1]_0 ;
  wire [7:0]\faults_reg[7]_0 ;
  wire filtered_clipped;
  wire [17:0]filtered_latched;
  wire filtered_valid;
  wire filtered_valid_i_1_n_0;
  wire high_seen_i_1_n_0;
  wire high_seen_reg_n_0;
  wire \i_/i_/i__carry__0_n_0 ;
  wire \i_/i_/i__carry__0_n_1 ;
  wire \i_/i_/i__carry__0_n_2 ;
  wire \i_/i_/i__carry__0_n_3 ;
  wire \i_/i_/i__carry__0_n_4 ;
  wire \i_/i_/i__carry__0_n_5 ;
  wire \i_/i_/i__carry__0_n_6 ;
  wire \i_/i_/i__carry__0_n_7 ;
  wire \i_/i_/i__carry__1_n_0 ;
  wire \i_/i_/i__carry__1_n_1 ;
  wire \i_/i_/i__carry__1_n_2 ;
  wire \i_/i_/i__carry__1_n_3 ;
  wire \i_/i_/i__carry__1_n_4 ;
  wire \i_/i_/i__carry__1_n_5 ;
  wire \i_/i_/i__carry__1_n_6 ;
  wire \i_/i_/i__carry__1_n_7 ;
  wire \i_/i_/i__carry__2_n_0 ;
  wire \i_/i_/i__carry__2_n_1 ;
  wire \i_/i_/i__carry__2_n_2 ;
  wire \i_/i_/i__carry__2_n_3 ;
  wire \i_/i_/i__carry__2_n_4 ;
  wire \i_/i_/i__carry__2_n_5 ;
  wire \i_/i_/i__carry__2_n_6 ;
  wire \i_/i_/i__carry__2_n_7 ;
  wire \i_/i_/i__carry__3_n_1 ;
  wire \i_/i_/i__carry__3_n_2 ;
  wire \i_/i_/i__carry__3_n_3 ;
  wire \i_/i_/i__carry__3_n_4 ;
  wire \i_/i_/i__carry__3_n_5 ;
  wire \i_/i_/i__carry__3_n_6 ;
  wire \i_/i_/i__carry__3_n_7 ;
  wire \i_/i_/i__carry_n_0 ;
  wire \i_/i_/i__carry_n_1 ;
  wire \i_/i_/i__carry_n_2 ;
  wire \i_/i_/i__carry_n_3 ;
  wire \i_/i_/i__carry_n_4 ;
  wire \i_/i_/i__carry_n_5 ;
  wire \i_/i_/i__carry_n_6 ;
  wire \i_/i_/i__carry_n_7 ;
  wire i__carry__0_i_1_n_0;
  wire i__carry__0_i_2_n_0;
  wire i__carry__0_i_3_n_0;
  wire i__carry__0_i_4_n_0;
  wire i__carry__1_i_1_n_0;
  wire i__carry__1_i_2_n_0;
  wire i__carry__1_i_3_n_0;
  wire i__carry__1_i_4_n_0;
  wire i__carry__2_i_1_n_0;
  wire i__carry__2_i_2_n_0;
  wire i__carry__2_i_3_n_0;
  wire i__carry__2_i_4_n_0;
  wire i__carry__3_i_1_n_0;
  wire i__carry__3_i_2_n_0;
  wire i__carry__3_i_3_n_0;
  wire i__carry__3_i_4_n_0;
  wire i__carry__4_i_1_n_0;
  wire i__carry_i_1__0_n_0;
  wire i__carry_i_1_n_0;
  wire i__carry_i_2_n_0;
  wire i__carry_i_3_n_0;
  wire i__carry_i_4_n_0;
  wire input_fault;
  wire \last_sum[31]_i_1_n_0 ;
  wire \last_sum[31]_i_2_n_0 ;
  wire [31:0]\last_sum_reg[31]_0 ;
  wire [2:0]loud_count;
  wire \loud_count[0]_i_1_n_0 ;
  wire \loud_count[1]_i_1_n_0 ;
  wire \loud_count[2]_i_1_n_0 ;
  wire [17:1]magnitude0;
  wire matching_ack0;
  wire matching_ack0_carry__0_i_1_n_0;
  wire matching_ack0_carry__0_i_2_n_0;
  wire matching_ack0_carry__0_i_3_n_0;
  wire matching_ack0_carry__0_i_4_n_0;
  wire matching_ack0_carry__0_n_0;
  wire matching_ack0_carry__0_n_1;
  wire matching_ack0_carry__0_n_2;
  wire matching_ack0_carry__0_n_3;
  wire [31:0]matching_ack0_carry__1_0;
  wire matching_ack0_carry__1_i_1_n_0;
  wire matching_ack0_carry__1_i_2_n_0;
  wire matching_ack0_carry__1_i_3_n_0;
  wire matching_ack0_carry__1_n_2;
  wire matching_ack0_carry__1_n_3;
  wire matching_ack0_carry_i_1_n_0;
  wire matching_ack0_carry_i_2_n_0;
  wire matching_ack0_carry_i_3_n_0;
  wire matching_ack0_carry_i_4_n_0;
  wire matching_ack0_carry_n_0;
  wire matching_ack0_carry_n_1;
  wire matching_ack0_carry_n_2;
  wire matching_ack0_carry_n_3;
  wire matching_ack1;
  wire matching_ack1_carry__0_i_1_n_0;
  wire matching_ack1_carry__0_i_2_n_0;
  wire matching_ack1_carry__0_i_3_n_0;
  wire matching_ack1_carry__0_i_4_n_0;
  wire matching_ack1_carry__0_n_0;
  wire matching_ack1_carry__0_n_1;
  wire matching_ack1_carry__0_n_2;
  wire matching_ack1_carry__0_n_3;
  wire [31:0]matching_ack1_carry__1_0;
  wire matching_ack1_carry__1_i_1_n_0;
  wire matching_ack1_carry__1_i_2_n_0;
  wire matching_ack1_carry__1_i_3_n_0;
  wire matching_ack1_carry__1_n_2;
  wire matching_ack1_carry__1_n_3;
  wire matching_ack1_carry_i_1_n_0;
  wire matching_ack1_carry_i_2_n_0;
  wire matching_ack1_carry_i_3_n_0;
  wire matching_ack1_carry_i_4_n_0;
  wire matching_ack1_carry_n_0;
  wire matching_ack1_carry_n_1;
  wire matching_ack1_carry_n_2;
  wire matching_ack1_carry_n_3;
  wire [15:0]next_clipped;
  wire [16:16]next_clipped__0;
  wire next_dc00;
  wire next_dc_carry__0_i_1_n_0;
  wire next_dc_carry__0_i_2_n_0;
  wire next_dc_carry__0_i_3_n_0;
  wire next_dc_carry__0_i_4_n_0;
  wire next_dc_carry__0_n_0;
  wire next_dc_carry__0_n_1;
  wire next_dc_carry__0_n_2;
  wire next_dc_carry__0_n_3;
  wire next_dc_carry__0_n_4;
  wire next_dc_carry__0_n_5;
  wire next_dc_carry__0_n_6;
  wire next_dc_carry__0_n_7;
  wire next_dc_carry__1_i_1_n_0;
  wire next_dc_carry__1_i_2_n_0;
  wire next_dc_carry__1_i_3_n_0;
  wire next_dc_carry__1_i_4_n_0;
  wire next_dc_carry__1_n_0;
  wire next_dc_carry__1_n_1;
  wire next_dc_carry__1_n_2;
  wire next_dc_carry__1_n_3;
  wire next_dc_carry__1_n_4;
  wire next_dc_carry__1_n_5;
  wire next_dc_carry__1_n_6;
  wire next_dc_carry__1_n_7;
  wire next_dc_carry__2_i_1_n_0;
  wire next_dc_carry__2_i_2_n_0;
  wire next_dc_carry__2_i_3_n_0;
  wire next_dc_carry__2_i_4_n_0;
  wire next_dc_carry__2_n_0;
  wire next_dc_carry__2_n_1;
  wire next_dc_carry__2_n_2;
  wire next_dc_carry__2_n_3;
  wire next_dc_carry__2_n_4;
  wire next_dc_carry__2_n_5;
  wire next_dc_carry__2_n_6;
  wire next_dc_carry__2_n_7;
  wire next_dc_carry__3_i_1_n_0;
  wire next_dc_carry__3_i_2_n_0;
  wire next_dc_carry__3_i_3_n_0;
  wire next_dc_carry__3_i_4_n_0;
  wire next_dc_carry__3_i_5_n_0;
  wire next_dc_carry__3_n_0;
  wire next_dc_carry__3_n_1;
  wire next_dc_carry__3_n_2;
  wire next_dc_carry__3_n_3;
  wire next_dc_carry__3_n_4;
  wire next_dc_carry__3_n_5;
  wire next_dc_carry__3_n_6;
  wire next_dc_carry__3_n_7;
  wire next_dc_carry__4_i_1_n_0;
  wire next_dc_carry__4_i_2_n_0;
  wire next_dc_carry__4_i_3_n_0;
  wire next_dc_carry__4_i_4_n_0;
  wire next_dc_carry__4_n_0;
  wire next_dc_carry__4_n_1;
  wire next_dc_carry__4_n_2;
  wire next_dc_carry__4_n_3;
  wire next_dc_carry__4_n_4;
  wire next_dc_carry__4_n_5;
  wire next_dc_carry__4_n_6;
  wire next_dc_carry__4_n_7;
  wire next_dc_carry__5_i_1_n_0;
  wire next_dc_carry__5_n_2;
  wire next_dc_carry__5_n_7;
  wire next_dc_carry_i_1_n_0;
  wire next_dc_carry_i_2_n_0;
  wire next_dc_carry_i_3_n_0;
  wire next_dc_carry_i_4_n_0;
  wire next_dc_carry_n_0;
  wire next_dc_carry_n_1;
  wire next_dc_carry_n_2;
  wire next_dc_carry_n_3;
  wire next_dc_carry_n_4;
  wire next_dc_carry_n_5;
  wire next_dc_carry_n_6;
  wire next_dc_carry_n_7;
  wire [63:0]out;
  wire p_0_in;
  wire [7:0]p_0_out;
  wire \p_0_out_inferred__3/i__carry__0_n_0 ;
  wire \p_0_out_inferred__3/i__carry__0_n_1 ;
  wire \p_0_out_inferred__3/i__carry__0_n_2 ;
  wire \p_0_out_inferred__3/i__carry__0_n_3 ;
  wire \p_0_out_inferred__3/i__carry__1_n_0 ;
  wire \p_0_out_inferred__3/i__carry__1_n_1 ;
  wire \p_0_out_inferred__3/i__carry__1_n_2 ;
  wire \p_0_out_inferred__3/i__carry__1_n_3 ;
  wire \p_0_out_inferred__3/i__carry__2_n_0 ;
  wire \p_0_out_inferred__3/i__carry__2_n_1 ;
  wire \p_0_out_inferred__3/i__carry__2_n_2 ;
  wire \p_0_out_inferred__3/i__carry__2_n_3 ;
  wire \p_0_out_inferred__3/i__carry__3_n_0 ;
  wire \p_0_out_inferred__3/i__carry__3_n_1 ;
  wire \p_0_out_inferred__3/i__carry__3_n_2 ;
  wire \p_0_out_inferred__3/i__carry__3_n_3 ;
  wire \p_0_out_inferred__3/i__carry__4_n_2 ;
  wire \p_0_out_inferred__3/i__carry__4_n_3 ;
  wire \p_0_out_inferred__3/i__carry_n_0 ;
  wire \p_0_out_inferred__3/i__carry_n_1 ;
  wire \p_0_out_inferred__3/i__carry_n_2 ;
  wire \p_0_out_inferred__3/i__carry_n_3 ;
  wire p_1_in;
  wire pcm_valid;
  wire quiet;
  wire quiet_carry__0_i_1_n_0;
  wire quiet_carry__0_i_2_n_0;
  wire quiet_carry__0_i_3_n_0;
  wire quiet_carry__0_i_4_n_0;
  wire quiet_carry__0_i_5_n_0;
  wire quiet_carry__0_i_6_n_0;
  wire quiet_carry__0_i_7_n_0;
  wire quiet_carry__0_i_8_n_0;
  wire quiet_carry__0_n_0;
  wire quiet_carry__0_n_1;
  wire quiet_carry__0_n_2;
  wire quiet_carry__0_n_3;
  wire quiet_carry__1_i_1_n_0;
  wire quiet_carry__1_i_2_n_0;
  wire quiet_carry__1_i_3_n_0;
  wire quiet_carry__1_i_4_n_0;
  wire quiet_carry__1_i_5_n_0;
  wire quiet_carry__1_i_6_n_0;
  wire quiet_carry__1_i_7_n_0;
  wire quiet_carry__1_i_8_n_0;
  wire quiet_carry__1_n_0;
  wire quiet_carry__1_n_1;
  wire quiet_carry__1_n_2;
  wire quiet_carry__1_n_3;
  wire [31:0]quiet_carry__2_0;
  wire quiet_carry__2_i_1_n_0;
  wire quiet_carry__2_i_2_n_0;
  wire quiet_carry__2_i_3_n_0;
  wire quiet_carry__2_i_4_n_0;
  wire quiet_carry__2_i_5_n_0;
  wire quiet_carry__2_i_6_n_0;
  wire quiet_carry__2_i_7_n_0;
  wire quiet_carry__2_i_8_n_0;
  wire quiet_carry__2_n_0;
  wire quiet_carry__2_n_1;
  wire quiet_carry__2_n_2;
  wire quiet_carry__2_n_3;
  wire quiet_carry__3_i_1_n_0;
  wire quiet_carry_i_1_n_0;
  wire quiet_carry_i_2_n_0;
  wire quiet_carry_i_3_n_0;
  wire quiet_carry_i_4_n_0;
  wire quiet_carry_i_5_n_0;
  wire quiet_carry_i_6_n_0;
  wire quiet_carry_i_7_n_0;
  wire quiet_carry_i_8_n_0;
  wire quiet_carry_n_0;
  wire quiet_carry_n_1;
  wire quiet_carry_n_2;
  wire quiet_carry_n_3;
  wire \quiet_count[0]_i_1_n_0 ;
  wire \quiet_count[1]_i_1_n_0 ;
  wire \quiet_count[2]_i_1_n_0 ;
  wire \quiet_count_reg_n_0_[0] ;
  wire \quiet_count_reg_n_0_[1] ;
  wire \quiet_count_reg_n_0_[2] ;
  wire s_axi_aclk;
  wire s_axi_aresetn;
  wire s_axi_aresetn_0;
  wire \s_axi_rdata[0]_i_4_n_0 ;
  wire \s_axi_rdata[0]_i_6_n_0 ;
  wire \s_axi_rdata[10]_i_4_n_0 ;
  wire \s_axi_rdata[1]_i_2_n_0 ;
  wire \s_axi_rdata[1]_i_5_n_0 ;
  wire \s_axi_rdata[2]_i_2_n_0 ;
  wire \s_axi_rdata[2]_i_5_n_0 ;
  wire \s_axi_rdata[3]_i_2_n_0 ;
  wire \s_axi_rdata[4]_i_4_n_0 ;
  wire \s_axi_rdata[4]_i_6_n_0 ;
  wire \s_axi_rdata[5]_i_4_n_0 ;
  wire \s_axi_rdata[6]_i_4_n_0 ;
  wire \s_axi_rdata[7]_i_2_n_0 ;
  wire \s_axi_rdata[9]_i_4_n_0 ;
  wire \s_axi_rdata_reg[0] ;
  wire \s_axi_rdata_reg[0]_0 ;
  wire \s_axi_rdata_reg[10] ;
  wire \s_axi_rdata_reg[10]_0 ;
  wire \s_axi_rdata_reg[10]_1 ;
  wire \s_axi_rdata_reg[1] ;
  wire \s_axi_rdata_reg[1]_0 ;
  wire \s_axi_rdata_reg[1]_1 ;
  wire \s_axi_rdata_reg[2] ;
  wire \s_axi_rdata_reg[2]_0 ;
  wire \s_axi_rdata_reg[2]_1 ;
  wire \s_axi_rdata_reg[2]_2 ;
  wire \s_axi_rdata_reg[2]_3 ;
  wire \s_axi_rdata_reg[2]_4 ;
  wire \s_axi_rdata_reg[3] ;
  wire \s_axi_rdata_reg[3]_0 ;
  wire \s_axi_rdata_reg[3]_1 ;
  wire \s_axi_rdata_reg[4] ;
  wire \s_axi_rdata_reg[4]_0 ;
  wire \s_axi_rdata_reg[4]_1 ;
  wire \s_axi_rdata_reg[4]_2 ;
  wire \s_axi_rdata_reg[5] ;
  wire \s_axi_rdata_reg[5]_0 ;
  wire \s_axi_rdata_reg[6] ;
  wire \s_axi_rdata_reg[6]_0 ;
  wire \s_axi_rdata_reg[7] ;
  wire \s_axi_rdata_reg[7]_0 ;
  wire \s_axi_rdata_reg[8] ;
  wire \s_axi_rdata_reg[8]_0 ;
  wire \s_axi_rdata_reg[8]_1 ;
  wire [7:0]\s_axi_rdata_reg[9] ;
  wire \s_axi_rdata_reg[9]_0 ;
  wire \s_axi_rdata_reg[9]_1 ;
  wire [0:0]sample_age;
  wire \sample_age[0]_i_1_n_0 ;
  wire \sample_age[0]_i_3_n_0 ;
  wire \sample_age[0]_i_4_n_0 ;
  wire \sample_age[0]_i_5_n_0 ;
  wire \sample_age[0]_i_6_n_0 ;
  wire [19:0]sample_age_reg;
  wire \sample_count[0]_i_1_n_0 ;
  wire \sample_count[0]_i_3_n_0 ;
  wire \sample_count_reg[0]_i_2_n_0 ;
  wire \sample_count_reg[0]_i_2_n_1 ;
  wire \sample_count_reg[0]_i_2_n_2 ;
  wire \sample_count_reg[0]_i_2_n_3 ;
  wire \sample_count_reg[0]_i_2_n_4 ;
  wire \sample_count_reg[0]_i_2_n_5 ;
  wire \sample_count_reg[0]_i_2_n_6 ;
  wire \sample_count_reg[0]_i_2_n_7 ;
  wire \sample_count_reg[12]_i_1_n_0 ;
  wire \sample_count_reg[12]_i_1_n_1 ;
  wire \sample_count_reg[12]_i_1_n_2 ;
  wire \sample_count_reg[12]_i_1_n_3 ;
  wire \sample_count_reg[12]_i_1_n_4 ;
  wire \sample_count_reg[12]_i_1_n_5 ;
  wire \sample_count_reg[12]_i_1_n_6 ;
  wire \sample_count_reg[12]_i_1_n_7 ;
  wire \sample_count_reg[16]_i_1_n_0 ;
  wire \sample_count_reg[16]_i_1_n_1 ;
  wire \sample_count_reg[16]_i_1_n_2 ;
  wire \sample_count_reg[16]_i_1_n_3 ;
  wire \sample_count_reg[16]_i_1_n_4 ;
  wire \sample_count_reg[16]_i_1_n_5 ;
  wire \sample_count_reg[16]_i_1_n_6 ;
  wire \sample_count_reg[16]_i_1_n_7 ;
  wire \sample_count_reg[20]_i_1_n_0 ;
  wire \sample_count_reg[20]_i_1_n_1 ;
  wire \sample_count_reg[20]_i_1_n_2 ;
  wire \sample_count_reg[20]_i_1_n_3 ;
  wire \sample_count_reg[20]_i_1_n_4 ;
  wire \sample_count_reg[20]_i_1_n_5 ;
  wire \sample_count_reg[20]_i_1_n_6 ;
  wire \sample_count_reg[20]_i_1_n_7 ;
  wire \sample_count_reg[24]_i_1_n_0 ;
  wire \sample_count_reg[24]_i_1_n_1 ;
  wire \sample_count_reg[24]_i_1_n_2 ;
  wire \sample_count_reg[24]_i_1_n_3 ;
  wire \sample_count_reg[24]_i_1_n_4 ;
  wire \sample_count_reg[24]_i_1_n_5 ;
  wire \sample_count_reg[24]_i_1_n_6 ;
  wire \sample_count_reg[24]_i_1_n_7 ;
  wire \sample_count_reg[28]_i_1_n_0 ;
  wire \sample_count_reg[28]_i_1_n_1 ;
  wire \sample_count_reg[28]_i_1_n_2 ;
  wire \sample_count_reg[28]_i_1_n_3 ;
  wire \sample_count_reg[28]_i_1_n_4 ;
  wire \sample_count_reg[28]_i_1_n_5 ;
  wire \sample_count_reg[28]_i_1_n_6 ;
  wire \sample_count_reg[28]_i_1_n_7 ;
  wire \sample_count_reg[32]_i_1_n_0 ;
  wire \sample_count_reg[32]_i_1_n_1 ;
  wire \sample_count_reg[32]_i_1_n_2 ;
  wire \sample_count_reg[32]_i_1_n_3 ;
  wire \sample_count_reg[32]_i_1_n_4 ;
  wire \sample_count_reg[32]_i_1_n_5 ;
  wire \sample_count_reg[32]_i_1_n_6 ;
  wire \sample_count_reg[32]_i_1_n_7 ;
  wire \sample_count_reg[36]_i_1_n_0 ;
  wire \sample_count_reg[36]_i_1_n_1 ;
  wire \sample_count_reg[36]_i_1_n_2 ;
  wire \sample_count_reg[36]_i_1_n_3 ;
  wire \sample_count_reg[36]_i_1_n_4 ;
  wire \sample_count_reg[36]_i_1_n_5 ;
  wire \sample_count_reg[36]_i_1_n_6 ;
  wire \sample_count_reg[36]_i_1_n_7 ;
  wire \sample_count_reg[40]_i_1_n_0 ;
  wire \sample_count_reg[40]_i_1_n_1 ;
  wire \sample_count_reg[40]_i_1_n_2 ;
  wire \sample_count_reg[40]_i_1_n_3 ;
  wire \sample_count_reg[40]_i_1_n_4 ;
  wire \sample_count_reg[40]_i_1_n_5 ;
  wire \sample_count_reg[40]_i_1_n_6 ;
  wire \sample_count_reg[40]_i_1_n_7 ;
  wire \sample_count_reg[44]_i_1_n_0 ;
  wire \sample_count_reg[44]_i_1_n_1 ;
  wire \sample_count_reg[44]_i_1_n_2 ;
  wire \sample_count_reg[44]_i_1_n_3 ;
  wire \sample_count_reg[44]_i_1_n_4 ;
  wire \sample_count_reg[44]_i_1_n_5 ;
  wire \sample_count_reg[44]_i_1_n_6 ;
  wire \sample_count_reg[44]_i_1_n_7 ;
  wire \sample_count_reg[48]_i_1_n_0 ;
  wire \sample_count_reg[48]_i_1_n_1 ;
  wire \sample_count_reg[48]_i_1_n_2 ;
  wire \sample_count_reg[48]_i_1_n_3 ;
  wire \sample_count_reg[48]_i_1_n_4 ;
  wire \sample_count_reg[48]_i_1_n_5 ;
  wire \sample_count_reg[48]_i_1_n_6 ;
  wire \sample_count_reg[48]_i_1_n_7 ;
  wire \sample_count_reg[4]_i_1_n_0 ;
  wire \sample_count_reg[4]_i_1_n_1 ;
  wire \sample_count_reg[4]_i_1_n_2 ;
  wire \sample_count_reg[4]_i_1_n_3 ;
  wire \sample_count_reg[4]_i_1_n_4 ;
  wire \sample_count_reg[4]_i_1_n_5 ;
  wire \sample_count_reg[4]_i_1_n_6 ;
  wire \sample_count_reg[4]_i_1_n_7 ;
  wire \sample_count_reg[52]_i_1_n_0 ;
  wire \sample_count_reg[52]_i_1_n_1 ;
  wire \sample_count_reg[52]_i_1_n_2 ;
  wire \sample_count_reg[52]_i_1_n_3 ;
  wire \sample_count_reg[52]_i_1_n_4 ;
  wire \sample_count_reg[52]_i_1_n_5 ;
  wire \sample_count_reg[52]_i_1_n_6 ;
  wire \sample_count_reg[52]_i_1_n_7 ;
  wire \sample_count_reg[56]_i_1_n_0 ;
  wire \sample_count_reg[56]_i_1_n_1 ;
  wire \sample_count_reg[56]_i_1_n_2 ;
  wire \sample_count_reg[56]_i_1_n_3 ;
  wire \sample_count_reg[56]_i_1_n_4 ;
  wire \sample_count_reg[56]_i_1_n_5 ;
  wire \sample_count_reg[56]_i_1_n_6 ;
  wire \sample_count_reg[56]_i_1_n_7 ;
  wire \sample_count_reg[60]_i_1_n_1 ;
  wire \sample_count_reg[60]_i_1_n_2 ;
  wire \sample_count_reg[60]_i_1_n_3 ;
  wire \sample_count_reg[60]_i_1_n_4 ;
  wire \sample_count_reg[60]_i_1_n_5 ;
  wire \sample_count_reg[60]_i_1_n_6 ;
  wire \sample_count_reg[60]_i_1_n_7 ;
  wire \sample_count_reg[8]_i_1_n_0 ;
  wire \sample_count_reg[8]_i_1_n_1 ;
  wire \sample_count_reg[8]_i_1_n_2 ;
  wire \sample_count_reg[8]_i_1_n_3 ;
  wire \sample_count_reg[8]_i_1_n_4 ;
  wire \sample_count_reg[8]_i_1_n_5 ;
  wire \sample_count_reg[8]_i_1_n_6 ;
  wire \sample_count_reg[8]_i_1_n_7 ;
  wire [9:0]sample_in_window;
  wire \sample_in_window[0]_i_2_n_0 ;
  wire \sample_in_window[6]_i_2_n_0 ;
  wire \sample_in_window[9]_i_1_n_0 ;
  wire \sample_in_window[9]_i_3_n_0 ;
  wire \sample_in_window[9]_i_4_n_0 ;
  wire \sample_in_window_reg_n_0_[0] ;
  wire \sample_in_window_reg_n_0_[1] ;
  wire \sample_in_window_reg_n_0_[2] ;
  wire \sample_in_window_reg_n_0_[3] ;
  wire \sample_in_window_reg_n_0_[4] ;
  wire \sample_in_window_reg_n_0_[5] ;
  wire \sample_in_window_reg_n_0_[6] ;
  wire \sample_in_window_reg_n_0_[7] ;
  wire \sample_in_window_reg_n_0_[8] ;
  wire \sample_in_window_reg_n_0_[9] ;
  wire [24:8]scaled_latched;
  wire scaled_latched0;
  wire [10:0]\snapshot_sequence_reg[10] ;
  wire snapshot_valid;
  wire snapshot_valid_reg;
  wire snapshot_valid_reg_0;
  wire snapshot_valid_reg_1;
  wire snapshot_valid_reg_2;
  wire [0:0]snapshot_valid_reg_3;
  wire [0:0]soft_count;
  wire \soft_count[0]_i_1_n_0 ;
  wire \soft_count[1]_i_1_n_0 ;
  wire \soft_count[2]_i_1_n_0 ;
  wire \soft_count_reg_n_0_[0] ;
  wire \soft_count_reg_n_0_[1] ;
  wire \soft_count_reg_n_0_[2] ;
  wire state20_in;
  wire state2_carry__0_i_1_n_0;
  wire state2_carry__0_i_2_n_0;
  wire state2_carry__0_i_3_n_0;
  wire state2_carry__0_i_4_n_0;
  wire state2_carry__0_i_5_n_0;
  wire state2_carry__0_i_6_n_0;
  wire state2_carry__0_i_7_n_0;
  wire state2_carry__0_i_8_n_0;
  wire state2_carry__0_n_0;
  wire state2_carry__0_n_1;
  wire state2_carry__0_n_2;
  wire state2_carry__0_n_3;
  wire state2_carry__1_i_1_n_0;
  wire state2_carry__1_i_2_n_0;
  wire state2_carry__1_i_3_n_0;
  wire state2_carry__1_i_4_n_0;
  wire state2_carry__1_i_5_n_0;
  wire state2_carry__1_i_6_n_0;
  wire state2_carry__1_i_7_n_0;
  wire state2_carry__1_i_8_n_0;
  wire state2_carry__1_n_0;
  wire state2_carry__1_n_1;
  wire state2_carry__1_n_2;
  wire state2_carry__1_n_3;
  wire state2_carry__2_i_1_n_0;
  wire state2_carry__2_i_2_n_0;
  wire state2_carry__2_i_3_n_0;
  wire state2_carry__2_i_4_n_0;
  wire state2_carry__2_i_5_n_0;
  wire state2_carry__2_i_6_n_0;
  wire state2_carry__2_i_7_n_0;
  wire state2_carry__2_i_8_n_0;
  wire state2_carry__2_n_1;
  wire state2_carry__2_n_2;
  wire state2_carry__2_n_3;
  wire state2_carry_i_1_n_0;
  wire state2_carry_i_2_n_0;
  wire state2_carry_i_3_n_0;
  wire state2_carry_i_4_n_0;
  wire state2_carry_i_5_n_0;
  wire state2_carry_i_6_n_0;
  wire state2_carry_i_7_n_0;
  wire state2_carry_i_8_n_0;
  wire state2_carry_n_0;
  wire state2_carry_n_1;
  wire state2_carry_n_2;
  wire state2_carry_n_3;
  wire state3;
  wire state3_carry__0_i_1_n_0;
  wire state3_carry__0_i_2_n_0;
  wire state3_carry__0_i_3_n_0;
  wire state3_carry__0_i_4_n_0;
  wire state3_carry__0_i_5_n_0;
  wire state3_carry__0_i_6_n_0;
  wire state3_carry__0_i_7_n_0;
  wire state3_carry__0_i_8_n_0;
  wire state3_carry__0_n_0;
  wire state3_carry__0_n_1;
  wire state3_carry__0_n_2;
  wire state3_carry__0_n_3;
  wire state3_carry__1_i_1_n_0;
  wire state3_carry__1_i_2_n_0;
  wire state3_carry__1_i_3_n_0;
  wire state3_carry__1_i_4_n_0;
  wire state3_carry__1_i_5_n_0;
  wire state3_carry__1_i_6_n_0;
  wire state3_carry__1_i_7_n_0;
  wire state3_carry__1_i_8_n_0;
  wire state3_carry__1_n_0;
  wire state3_carry__1_n_1;
  wire state3_carry__1_n_2;
  wire state3_carry__1_n_3;
  wire state3_carry__2_i_1_n_0;
  wire state3_carry__2_i_2_n_0;
  wire state3_carry__2_i_3_n_0;
  wire state3_carry__2_i_4_n_0;
  wire state3_carry__2_i_5_n_0;
  wire state3_carry__2_i_6_n_0;
  wire state3_carry__2_i_7_n_0;
  wire state3_carry__2_i_8_n_0;
  wire state3_carry__2_n_1;
  wire state3_carry__2_n_2;
  wire state3_carry__2_n_3;
  wire state3_carry_i_1_n_0;
  wire state3_carry_i_2_n_0;
  wire state3_carry_i_3_n_0;
  wire state3_carry_i_4_n_0;
  wire state3_carry_i_5_n_0;
  wire state3_carry_i_6_n_0;
  wire state3_carry_i_7_n_0;
  wire state3_carry_i_8_n_0;
  wire state3_carry_n_0;
  wire state3_carry_n_1;
  wire state3_carry_n_2;
  wire state3_carry_n_3;
  wire \state[0]_i_1_n_0 ;
  wire \state[1]_i_1_n_0 ;
  wire \state[1]_i_2_n_0 ;
  wire \state[2]_i_1_n_0 ;
  wire \state[2]_i_2_n_0 ;
  wire \state[2]_i_3_n_0 ;
  wire \state[2]_i_4_n_0 ;
  wire \state[2]_i_5_n_0 ;
  wire \state[2]_i_6_n_0 ;
  wire \state[2]_i_7_n_0 ;
  wire \state[2]_i_8_n_0 ;
  wire \state[2]_i_9_n_0 ;
  wire [4:0]status;
  wire \window_count[0]_i_2_n_0 ;
  wire \window_count_reg[0]_i_1_n_0 ;
  wire \window_count_reg[0]_i_1_n_1 ;
  wire \window_count_reg[0]_i_1_n_2 ;
  wire \window_count_reg[0]_i_1_n_3 ;
  wire \window_count_reg[0]_i_1_n_4 ;
  wire \window_count_reg[0]_i_1_n_5 ;
  wire \window_count_reg[0]_i_1_n_6 ;
  wire \window_count_reg[0]_i_1_n_7 ;
  wire \window_count_reg[12]_i_1_n_0 ;
  wire \window_count_reg[12]_i_1_n_1 ;
  wire \window_count_reg[12]_i_1_n_2 ;
  wire \window_count_reg[12]_i_1_n_3 ;
  wire \window_count_reg[12]_i_1_n_4 ;
  wire \window_count_reg[12]_i_1_n_5 ;
  wire \window_count_reg[12]_i_1_n_6 ;
  wire \window_count_reg[12]_i_1_n_7 ;
  wire \window_count_reg[16]_i_1_n_0 ;
  wire \window_count_reg[16]_i_1_n_1 ;
  wire \window_count_reg[16]_i_1_n_2 ;
  wire \window_count_reg[16]_i_1_n_3 ;
  wire \window_count_reg[16]_i_1_n_4 ;
  wire \window_count_reg[16]_i_1_n_5 ;
  wire \window_count_reg[16]_i_1_n_6 ;
  wire \window_count_reg[16]_i_1_n_7 ;
  wire \window_count_reg[20]_i_1_n_0 ;
  wire \window_count_reg[20]_i_1_n_1 ;
  wire \window_count_reg[20]_i_1_n_2 ;
  wire \window_count_reg[20]_i_1_n_3 ;
  wire \window_count_reg[20]_i_1_n_4 ;
  wire \window_count_reg[20]_i_1_n_5 ;
  wire \window_count_reg[20]_i_1_n_6 ;
  wire \window_count_reg[20]_i_1_n_7 ;
  wire \window_count_reg[24]_i_1_n_0 ;
  wire \window_count_reg[24]_i_1_n_1 ;
  wire \window_count_reg[24]_i_1_n_2 ;
  wire \window_count_reg[24]_i_1_n_3 ;
  wire \window_count_reg[24]_i_1_n_4 ;
  wire \window_count_reg[24]_i_1_n_5 ;
  wire \window_count_reg[24]_i_1_n_6 ;
  wire \window_count_reg[24]_i_1_n_7 ;
  wire \window_count_reg[28]_i_1_n_1 ;
  wire \window_count_reg[28]_i_1_n_2 ;
  wire \window_count_reg[28]_i_1_n_3 ;
  wire \window_count_reg[28]_i_1_n_4 ;
  wire \window_count_reg[28]_i_1_n_5 ;
  wire \window_count_reg[28]_i_1_n_6 ;
  wire \window_count_reg[28]_i_1_n_7 ;
  wire [31:0]\window_count_reg[31]_0 ;
  wire \window_count_reg[4]_i_1_n_0 ;
  wire \window_count_reg[4]_i_1_n_1 ;
  wire \window_count_reg[4]_i_1_n_2 ;
  wire \window_count_reg[4]_i_1_n_3 ;
  wire \window_count_reg[4]_i_1_n_4 ;
  wire \window_count_reg[4]_i_1_n_5 ;
  wire \window_count_reg[4]_i_1_n_6 ;
  wire \window_count_reg[4]_i_1_n_7 ;
  wire \window_count_reg[8]_i_1_n_0 ;
  wire \window_count_reg[8]_i_1_n_1 ;
  wire \window_count_reg[8]_i_1_n_2 ;
  wire \window_count_reg[8]_i_1_n_3 ;
  wire \window_count_reg[8]_i_1_n_4 ;
  wire \window_count_reg[8]_i_1_n_5 ;
  wire \window_count_reg[8]_i_1_n_6 ;
  wire \window_count_reg[8]_i_1_n_7 ;
  wire [3:0]NLW_above_loud_carry_O_UNCONNECTED;
  wire [3:0]NLW_above_loud_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_above_loud_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_above_loud_carry__2_O_UNCONNECTED;
  wire [3:1]NLW_above_loud_carry__3_CO_UNCONNECTED;
  wire [3:0]NLW_above_loud_carry__3_O_UNCONNECTED;
  wire [3:0]NLW_above_soft_carry_O_UNCONNECTED;
  wire [3:0]NLW_above_soft_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_above_soft_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_above_soft_carry__2_O_UNCONNECTED;
  wire [3:1]NLW_above_soft_carry__3_CO_UNCONNECTED;
  wire [3:0]NLW_above_soft_carry__3_O_UNCONNECTED;
  wire [3:1]NLW_above_soft_carry__3_i_1_CO_UNCONNECTED;
  wire [3:0]NLW_above_soft_carry__3_i_1_O_UNCONNECTED;
  wire [3:0]\NLW_accumulation_reg[19]_i_4_CO_UNCONNECTED ;
  wire [3:1]\NLW_accumulation_reg[19]_i_4_O_UNCONNECTED ;
  wire [3:0]NLW_centered_carry_O_UNCONNECTED;
  wire [2:0]NLW_centered_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_centered_carry__5_CO_UNCONNECTED;
  wire [3:1]NLW_centered_carry__5_O_UNCONNECTED;
  wire [3:0]NLW_dc_difference_carry_O_UNCONNECTED;
  wire [3:0]NLW_dc_difference_carry__0_O_UNCONNECTED;
  wire [0:0]NLW_dc_difference_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_dc_difference_carry__5_CO_UNCONNECTED;
  wire [3:1]NLW_dc_difference_carry__5_O_UNCONNECTED;
  wire [3:2]NLW_event_age0_carry__6_CO_UNCONNECTED;
  wire [3:3]NLW_event_age0_carry__6_O_UNCONNECTED;
  wire [3:2]\NLW_event_sample_reg[63]_i_2_CO_UNCONNECTED ;
  wire [3:3]\NLW_event_sample_reg[63]_i_2_O_UNCONNECTED ;
  wire [3:3]\NLW_event_sequence_reg[28]_i_1_CO_UNCONNECTED ;
  wire [3:2]\NLW_event_window_reg[31]_i_1_CO_UNCONNECTED ;
  wire [3:3]\NLW_event_window_reg[31]_i_1_O_UNCONNECTED ;
  wire [3:1]\NLW_faults_reg[6]_i_11_CO_UNCONNECTED ;
  wire [3:0]\NLW_faults_reg[6]_i_11_O_UNCONNECTED ;
  wire [3:3]\NLW_i_/i_/i__carry__3_CO_UNCONNECTED ;
  wire [3:0]NLW_matching_ack0_carry_O_UNCONNECTED;
  wire [3:0]NLW_matching_ack0_carry__0_O_UNCONNECTED;
  wire [3:3]NLW_matching_ack0_carry__1_CO_UNCONNECTED;
  wire [3:0]NLW_matching_ack0_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_matching_ack1_carry_O_UNCONNECTED;
  wire [3:0]NLW_matching_ack1_carry__0_O_UNCONNECTED;
  wire [3:3]NLW_matching_ack1_carry__1_CO_UNCONNECTED;
  wire [3:0]NLW_matching_ack1_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_next_dc_carry__5_CO_UNCONNECTED;
  wire [3:1]NLW_next_dc_carry__5_O_UNCONNECTED;
  wire [3:0]\NLW_p_0_out_inferred__3/i__carry_O_UNCONNECTED ;
  wire [3:0]\NLW_p_0_out_inferred__3/i__carry__0_O_UNCONNECTED ;
  wire [3:0]\NLW_p_0_out_inferred__3/i__carry__1_O_UNCONNECTED ;
  wire [3:0]\NLW_p_0_out_inferred__3/i__carry__2_O_UNCONNECTED ;
  wire [3:0]\NLW_p_0_out_inferred__3/i__carry__3_O_UNCONNECTED ;
  wire [3:2]\NLW_p_0_out_inferred__3/i__carry__4_CO_UNCONNECTED ;
  wire [3:0]\NLW_p_0_out_inferred__3/i__carry__4_O_UNCONNECTED ;
  wire [3:0]NLW_quiet_carry_O_UNCONNECTED;
  wire [3:0]NLW_quiet_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_quiet_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_quiet_carry__2_O_UNCONNECTED;
  wire [3:1]NLW_quiet_carry__3_CO_UNCONNECTED;
  wire [3:0]NLW_quiet_carry__3_O_UNCONNECTED;
  wire [3:3]\NLW_sample_count_reg[60]_i_1_CO_UNCONNECTED ;
  wire [3:0]NLW_state2_carry_O_UNCONNECTED;
  wire [3:0]NLW_state2_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_state2_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_state2_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_state3_carry_O_UNCONNECTED;
  wire [3:0]NLW_state3_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_state3_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_state3_carry__2_O_UNCONNECTED;
  wire [3:3]\NLW_window_count_reg[28]_i_1_CO_UNCONNECTED ;

  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 above_loud_carry
       (.CI(1'b0),
        .CO({above_loud_carry_n_0,above_loud_carry_n_1,above_loud_carry_n_2,above_loud_carry_n_3}),
        .CYINIT(1'b1),
        .DI({above_loud_carry_i_1_n_0,above_loud_carry_i_2_n_0,above_loud_carry_i_3_n_0,above_loud_carry_i_4_n_0}),
        .O(NLW_above_loud_carry_O_UNCONNECTED[3:0]),
        .S({above_loud_carry_i_5_n_0,above_loud_carry_i_6_n_0,above_loud_carry_i_7_n_0,above_loud_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 above_loud_carry__0
       (.CI(above_loud_carry_n_0),
        .CO({above_loud_carry__0_n_0,above_loud_carry__0_n_1,above_loud_carry__0_n_2,above_loud_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({above_loud_carry__0_i_1_n_0,above_loud_carry__0_i_2_n_0,above_loud_carry__0_i_3_n_0,above_loud_carry__0_i_4_n_0}),
        .O(NLW_above_loud_carry__0_O_UNCONNECTED[3:0]),
        .S({above_loud_carry__0_i_5_n_0,above_loud_carry__0_i_6_n_0,above_loud_carry__0_i_7_n_0,above_loud_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry__0_i_1
       (.I0(above_loud_carry__2_0[15]),
        .I1(\accumulation_reg[15]_i_1_n_4 ),
        .I2(\accumulation_reg[15]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[14]),
        .O(above_loud_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry__0_i_2
       (.I0(above_loud_carry__2_0[13]),
        .I1(\accumulation_reg[15]_i_1_n_6 ),
        .I2(\accumulation_reg[15]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[12]),
        .O(above_loud_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry__0_i_3
       (.I0(above_loud_carry__2_0[11]),
        .I1(\accumulation_reg[11]_i_1_n_4 ),
        .I2(\accumulation_reg[11]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[10]),
        .O(above_loud_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry__0_i_4
       (.I0(above_loud_carry__2_0[9]),
        .I1(\accumulation_reg[11]_i_1_n_6 ),
        .I2(\accumulation_reg[11]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[8]),
        .O(above_loud_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry__0_i_5
       (.I0(\accumulation_reg[15]_i_1_n_4 ),
        .I1(above_loud_carry__2_0[15]),
        .I2(\accumulation_reg[15]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[14]),
        .O(above_loud_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry__0_i_6
       (.I0(\accumulation_reg[15]_i_1_n_6 ),
        .I1(above_loud_carry__2_0[13]),
        .I2(\accumulation_reg[15]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[12]),
        .O(above_loud_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry__0_i_7
       (.I0(\accumulation_reg[11]_i_1_n_4 ),
        .I1(above_loud_carry__2_0[11]),
        .I2(\accumulation_reg[11]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[10]),
        .O(above_loud_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry__0_i_8
       (.I0(\accumulation_reg[11]_i_1_n_6 ),
        .I1(above_loud_carry__2_0[9]),
        .I2(\accumulation_reg[11]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[8]),
        .O(above_loud_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 above_loud_carry__1
       (.CI(above_loud_carry__0_n_0),
        .CO({above_loud_carry__1_n_0,above_loud_carry__1_n_1,above_loud_carry__1_n_2,above_loud_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({above_loud_carry__1_i_1_n_0,above_loud_carry__1_i_2_n_0,above_loud_carry__1_i_3_n_0,above_loud_carry__1_i_4_n_0}),
        .O(NLW_above_loud_carry__1_O_UNCONNECTED[3:0]),
        .S({above_loud_carry__1_i_5_n_0,above_loud_carry__1_i_6_n_0,above_loud_carry__1_i_7_n_0,above_loud_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry__1_i_1
       (.I0(above_loud_carry__2_0[23]),
        .I1(\accumulation_reg[23]_i_1_n_4 ),
        .I2(\accumulation_reg[23]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[22]),
        .O(above_loud_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry__1_i_2
       (.I0(above_loud_carry__2_0[21]),
        .I1(\accumulation_reg[23]_i_1_n_6 ),
        .I2(\accumulation_reg[23]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[20]),
        .O(above_loud_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry__1_i_3
       (.I0(above_loud_carry__2_0[19]),
        .I1(\accumulation_reg[19]_i_1_n_4 ),
        .I2(\accumulation_reg[19]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[18]),
        .O(above_loud_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry__1_i_4
       (.I0(above_loud_carry__2_0[17]),
        .I1(\accumulation_reg[19]_i_1_n_6 ),
        .I2(\accumulation_reg[19]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[16]),
        .O(above_loud_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry__1_i_5
       (.I0(\accumulation_reg[23]_i_1_n_4 ),
        .I1(above_loud_carry__2_0[23]),
        .I2(\accumulation_reg[23]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[22]),
        .O(above_loud_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry__1_i_6
       (.I0(\accumulation_reg[23]_i_1_n_6 ),
        .I1(above_loud_carry__2_0[21]),
        .I2(\accumulation_reg[23]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[20]),
        .O(above_loud_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry__1_i_7
       (.I0(\accumulation_reg[19]_i_1_n_4 ),
        .I1(above_loud_carry__2_0[19]),
        .I2(\accumulation_reg[19]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[18]),
        .O(above_loud_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry__1_i_8
       (.I0(\accumulation_reg[19]_i_1_n_6 ),
        .I1(above_loud_carry__2_0[17]),
        .I2(\accumulation_reg[19]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[16]),
        .O(above_loud_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 above_loud_carry__2
       (.CI(above_loud_carry__1_n_0),
        .CO({above_loud_carry__2_n_0,above_loud_carry__2_n_1,above_loud_carry__2_n_2,above_loud_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({above_loud_carry__2_i_1_n_0,above_loud_carry__2_i_2_n_0,above_loud_carry__2_i_3_n_0,above_loud_carry__2_i_4_n_0}),
        .O(NLW_above_loud_carry__2_O_UNCONNECTED[3:0]),
        .S({above_loud_carry__2_i_5_n_0,above_loud_carry__2_i_6_n_0,above_loud_carry__2_i_7_n_0,above_loud_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry__2_i_1
       (.I0(above_loud_carry__2_0[31]),
        .I1(\accumulation_reg[31]_i_1_n_4 ),
        .I2(\accumulation_reg[31]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[30]),
        .O(above_loud_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry__2_i_2
       (.I0(above_loud_carry__2_0[29]),
        .I1(\accumulation_reg[31]_i_1_n_6 ),
        .I2(\accumulation_reg[31]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[28]),
        .O(above_loud_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry__2_i_3
       (.I0(above_loud_carry__2_0[27]),
        .I1(\accumulation_reg[27]_i_1_n_4 ),
        .I2(\accumulation_reg[27]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[26]),
        .O(above_loud_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry__2_i_4
       (.I0(above_loud_carry__2_0[25]),
        .I1(\accumulation_reg[27]_i_1_n_6 ),
        .I2(\accumulation_reg[27]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[24]),
        .O(above_loud_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry__2_i_5
       (.I0(\accumulation_reg[31]_i_1_n_4 ),
        .I1(above_loud_carry__2_0[31]),
        .I2(\accumulation_reg[31]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[30]),
        .O(above_loud_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry__2_i_6
       (.I0(\accumulation_reg[31]_i_1_n_6 ),
        .I1(above_loud_carry__2_0[29]),
        .I2(\accumulation_reg[31]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[28]),
        .O(above_loud_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry__2_i_7
       (.I0(\accumulation_reg[27]_i_1_n_4 ),
        .I1(above_loud_carry__2_0[27]),
        .I2(\accumulation_reg[27]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[26]),
        .O(above_loud_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry__2_i_8
       (.I0(\accumulation_reg[27]_i_1_n_6 ),
        .I1(above_loud_carry__2_0[25]),
        .I2(\accumulation_reg[27]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[24]),
        .O(above_loud_carry__2_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 above_loud_carry__3
       (.CI(above_loud_carry__2_n_0),
        .CO({NLW_above_loud_carry__3_CO_UNCONNECTED[3:1],above_loud}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,p_0_in}),
        .O(NLW_above_loud_carry__3_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,1'b0,above_loud_carry__3_i_1_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    above_loud_carry__3_i_1
       (.I0(p_0_in),
        .O(above_loud_carry__3_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry_i_1
       (.I0(above_loud_carry__2_0[7]),
        .I1(\accumulation_reg[7]_i_1_n_4 ),
        .I2(\accumulation_reg[7]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[6]),
        .O(above_loud_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry_i_2
       (.I0(above_loud_carry__2_0[5]),
        .I1(\accumulation_reg[7]_i_1_n_6 ),
        .I2(\accumulation_reg[7]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[4]),
        .O(above_loud_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry_i_3
       (.I0(above_loud_carry__2_0[3]),
        .I1(\accumulation_reg[3]_i_1_n_4 ),
        .I2(\accumulation_reg[3]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[2]),
        .O(above_loud_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_loud_carry_i_4
       (.I0(above_loud_carry__2_0[1]),
        .I1(\accumulation_reg[3]_i_1_n_6 ),
        .I2(\accumulation_reg[3]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[0]),
        .O(above_loud_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry_i_5
       (.I0(\accumulation_reg[7]_i_1_n_4 ),
        .I1(above_loud_carry__2_0[7]),
        .I2(\accumulation_reg[7]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[6]),
        .O(above_loud_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry_i_6
       (.I0(\accumulation_reg[7]_i_1_n_6 ),
        .I1(above_loud_carry__2_0[5]),
        .I2(\accumulation_reg[7]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[4]),
        .O(above_loud_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry_i_7
       (.I0(\accumulation_reg[3]_i_1_n_4 ),
        .I1(above_loud_carry__2_0[3]),
        .I2(\accumulation_reg[3]_i_1_n_5 ),
        .I3(above_loud_carry__2_0[2]),
        .O(above_loud_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_loud_carry_i_8
       (.I0(\accumulation_reg[3]_i_1_n_6 ),
        .I1(above_loud_carry__2_0[1]),
        .I2(\accumulation_reg[3]_i_1_n_7 ),
        .I3(above_loud_carry__2_0[0]),
        .O(above_loud_carry_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 above_soft_carry
       (.CI(1'b0),
        .CO({above_soft_carry_n_0,above_soft_carry_n_1,above_soft_carry_n_2,above_soft_carry_n_3}),
        .CYINIT(1'b1),
        .DI({above_soft_carry_i_1_n_0,above_soft_carry_i_2_n_0,above_soft_carry_i_3_n_0,above_soft_carry_i_4_n_0}),
        .O(NLW_above_soft_carry_O_UNCONNECTED[3:0]),
        .S({above_soft_carry_i_5_n_0,above_soft_carry_i_6_n_0,above_soft_carry_i_7_n_0,above_soft_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 above_soft_carry__0
       (.CI(above_soft_carry_n_0),
        .CO({above_soft_carry__0_n_0,above_soft_carry__0_n_1,above_soft_carry__0_n_2,above_soft_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({above_soft_carry__0_i_1_n_0,above_soft_carry__0_i_2_n_0,above_soft_carry__0_i_3_n_0,above_soft_carry__0_i_4_n_0}),
        .O(NLW_above_soft_carry__0_O_UNCONNECTED[3:0]),
        .S({above_soft_carry__0_i_5_n_0,above_soft_carry__0_i_6_n_0,above_soft_carry__0_i_7_n_0,above_soft_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry__0_i_1
       (.I0(\faults[7]_i_10_0 [15]),
        .I1(\accumulation_reg[15]_i_1_n_4 ),
        .I2(\accumulation_reg[15]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [14]),
        .O(above_soft_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry__0_i_2
       (.I0(\faults[7]_i_10_0 [13]),
        .I1(\accumulation_reg[15]_i_1_n_6 ),
        .I2(\accumulation_reg[15]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [12]),
        .O(above_soft_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry__0_i_3
       (.I0(\faults[7]_i_10_0 [11]),
        .I1(\accumulation_reg[11]_i_1_n_4 ),
        .I2(\accumulation_reg[11]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [10]),
        .O(above_soft_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry__0_i_4
       (.I0(\faults[7]_i_10_0 [9]),
        .I1(\accumulation_reg[11]_i_1_n_6 ),
        .I2(\accumulation_reg[11]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [8]),
        .O(above_soft_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry__0_i_5
       (.I0(\accumulation_reg[15]_i_1_n_4 ),
        .I1(\faults[7]_i_10_0 [15]),
        .I2(\accumulation_reg[15]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [14]),
        .O(above_soft_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry__0_i_6
       (.I0(\accumulation_reg[15]_i_1_n_6 ),
        .I1(\faults[7]_i_10_0 [13]),
        .I2(\accumulation_reg[15]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [12]),
        .O(above_soft_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry__0_i_7
       (.I0(\accumulation_reg[11]_i_1_n_4 ),
        .I1(\faults[7]_i_10_0 [11]),
        .I2(\accumulation_reg[11]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [10]),
        .O(above_soft_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry__0_i_8
       (.I0(\accumulation_reg[11]_i_1_n_6 ),
        .I1(\faults[7]_i_10_0 [9]),
        .I2(\accumulation_reg[11]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [8]),
        .O(above_soft_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 above_soft_carry__1
       (.CI(above_soft_carry__0_n_0),
        .CO({above_soft_carry__1_n_0,above_soft_carry__1_n_1,above_soft_carry__1_n_2,above_soft_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({above_soft_carry__1_i_1_n_0,above_soft_carry__1_i_2_n_0,above_soft_carry__1_i_3_n_0,above_soft_carry__1_i_4_n_0}),
        .O(NLW_above_soft_carry__1_O_UNCONNECTED[3:0]),
        .S({above_soft_carry__1_i_5_n_0,above_soft_carry__1_i_6_n_0,above_soft_carry__1_i_7_n_0,above_soft_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry__1_i_1
       (.I0(\faults[7]_i_10_0 [23]),
        .I1(\accumulation_reg[23]_i_1_n_4 ),
        .I2(\accumulation_reg[23]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [22]),
        .O(above_soft_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry__1_i_2
       (.I0(\faults[7]_i_10_0 [21]),
        .I1(\accumulation_reg[23]_i_1_n_6 ),
        .I2(\accumulation_reg[23]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [20]),
        .O(above_soft_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry__1_i_3
       (.I0(\faults[7]_i_10_0 [19]),
        .I1(\accumulation_reg[19]_i_1_n_4 ),
        .I2(\accumulation_reg[19]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [18]),
        .O(above_soft_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry__1_i_4
       (.I0(\faults[7]_i_10_0 [17]),
        .I1(\accumulation_reg[19]_i_1_n_6 ),
        .I2(\accumulation_reg[19]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [16]),
        .O(above_soft_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry__1_i_5
       (.I0(\accumulation_reg[23]_i_1_n_4 ),
        .I1(\faults[7]_i_10_0 [23]),
        .I2(\accumulation_reg[23]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [22]),
        .O(above_soft_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry__1_i_6
       (.I0(\accumulation_reg[23]_i_1_n_6 ),
        .I1(\faults[7]_i_10_0 [21]),
        .I2(\accumulation_reg[23]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [20]),
        .O(above_soft_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry__1_i_7
       (.I0(\accumulation_reg[19]_i_1_n_4 ),
        .I1(\faults[7]_i_10_0 [19]),
        .I2(\accumulation_reg[19]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [18]),
        .O(above_soft_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry__1_i_8
       (.I0(\accumulation_reg[19]_i_1_n_6 ),
        .I1(\faults[7]_i_10_0 [17]),
        .I2(\accumulation_reg[19]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [16]),
        .O(above_soft_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 above_soft_carry__2
       (.CI(above_soft_carry__1_n_0),
        .CO({above_soft_carry__2_n_0,above_soft_carry__2_n_1,above_soft_carry__2_n_2,above_soft_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({above_soft_carry__2_i_1_n_0,above_soft_carry__2_i_2_n_0,above_soft_carry__2_i_3_n_0,above_soft_carry__2_i_4_n_0}),
        .O(NLW_above_soft_carry__2_O_UNCONNECTED[3:0]),
        .S({above_soft_carry__2_i_5_n_0,above_soft_carry__2_i_6_n_0,above_soft_carry__2_i_7_n_0,above_soft_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry__2_i_1
       (.I0(\faults[7]_i_10_0 [31]),
        .I1(\accumulation_reg[31]_i_1_n_4 ),
        .I2(\accumulation_reg[31]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [30]),
        .O(above_soft_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry__2_i_2
       (.I0(\faults[7]_i_10_0 [29]),
        .I1(\accumulation_reg[31]_i_1_n_6 ),
        .I2(\accumulation_reg[31]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [28]),
        .O(above_soft_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry__2_i_3
       (.I0(\faults[7]_i_10_0 [27]),
        .I1(\accumulation_reg[27]_i_1_n_4 ),
        .I2(\accumulation_reg[27]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [26]),
        .O(above_soft_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry__2_i_4
       (.I0(\faults[7]_i_10_0 [25]),
        .I1(\accumulation_reg[27]_i_1_n_6 ),
        .I2(\accumulation_reg[27]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [24]),
        .O(above_soft_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry__2_i_5
       (.I0(\accumulation_reg[31]_i_1_n_4 ),
        .I1(\faults[7]_i_10_0 [31]),
        .I2(\accumulation_reg[31]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [30]),
        .O(above_soft_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry__2_i_6
       (.I0(\accumulation_reg[31]_i_1_n_6 ),
        .I1(\faults[7]_i_10_0 [29]),
        .I2(\accumulation_reg[31]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [28]),
        .O(above_soft_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry__2_i_7
       (.I0(\accumulation_reg[27]_i_1_n_4 ),
        .I1(\faults[7]_i_10_0 [27]),
        .I2(\accumulation_reg[27]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [26]),
        .O(above_soft_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry__2_i_8
       (.I0(\accumulation_reg[27]_i_1_n_6 ),
        .I1(\faults[7]_i_10_0 [25]),
        .I2(\accumulation_reg[27]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [24]),
        .O(above_soft_carry__2_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 above_soft_carry__3
       (.CI(above_soft_carry__2_n_0),
        .CO({NLW_above_soft_carry__3_CO_UNCONNECTED[3:1],p_1_in}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,p_0_in}),
        .O(NLW_above_soft_carry__3_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,1'b0,above_soft_carry__3_i_2_n_0}));
  CARRY4 above_soft_carry__3_i_1
       (.CI(\accumulation_reg[31]_i_1_n_0 ),
        .CO({NLW_above_soft_carry__3_i_1_CO_UNCONNECTED[3:1],p_0_in}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_above_soft_carry__3_i_1_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  LUT1 #(
    .INIT(2'h1)) 
    above_soft_carry__3_i_2
       (.I0(p_0_in),
        .O(above_soft_carry__3_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry_i_1
       (.I0(\faults[7]_i_10_0 [7]),
        .I1(\accumulation_reg[7]_i_1_n_4 ),
        .I2(\accumulation_reg[7]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [6]),
        .O(above_soft_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry_i_2
       (.I0(\faults[7]_i_10_0 [5]),
        .I1(\accumulation_reg[7]_i_1_n_6 ),
        .I2(\accumulation_reg[7]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [4]),
        .O(above_soft_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry_i_3
       (.I0(\faults[7]_i_10_0 [3]),
        .I1(\accumulation_reg[3]_i_1_n_4 ),
        .I2(\accumulation_reg[3]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [2]),
        .O(above_soft_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    above_soft_carry_i_4
       (.I0(\faults[7]_i_10_0 [1]),
        .I1(\accumulation_reg[3]_i_1_n_6 ),
        .I2(\accumulation_reg[3]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [0]),
        .O(above_soft_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry_i_5
       (.I0(\accumulation_reg[7]_i_1_n_4 ),
        .I1(\faults[7]_i_10_0 [7]),
        .I2(\accumulation_reg[7]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [6]),
        .O(above_soft_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry_i_6
       (.I0(\accumulation_reg[7]_i_1_n_6 ),
        .I1(\faults[7]_i_10_0 [5]),
        .I2(\accumulation_reg[7]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [4]),
        .O(above_soft_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry_i_7
       (.I0(\accumulation_reg[3]_i_1_n_4 ),
        .I1(\faults[7]_i_10_0 [3]),
        .I2(\accumulation_reg[3]_i_1_n_5 ),
        .I3(\faults[7]_i_10_0 [2]),
        .O(above_soft_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    above_soft_carry_i_8
       (.I0(\accumulation_reg[3]_i_1_n_6 ),
        .I1(\faults[7]_i_10_0 [1]),
        .I2(\accumulation_reg[3]_i_1_n_7 ),
        .I3(\faults[7]_i_10_0 [0]),
        .O(above_soft_carry_i_8_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[11]_i_10 
       (.I0(filtered_latched[5]),
        .O(\accumulation[11]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[11]_i_2 
       (.I0(accumulation[11]),
        .I1(filtered_latched[11]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[11]),
        .O(\accumulation[11]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[11]_i_3 
       (.I0(accumulation[10]),
        .I1(filtered_latched[10]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[10]),
        .O(\accumulation[11]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[11]_i_4 
       (.I0(accumulation[9]),
        .I1(filtered_latched[9]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[9]),
        .O(\accumulation[11]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[11]_i_5 
       (.I0(accumulation[8]),
        .I1(filtered_latched[8]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[8]),
        .O(\accumulation[11]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[11]_i_7 
       (.I0(filtered_latched[8]),
        .O(\accumulation[11]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[11]_i_8 
       (.I0(filtered_latched[7]),
        .O(\accumulation[11]_i_8_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[11]_i_9 
       (.I0(filtered_latched[6]),
        .O(\accumulation[11]_i_9_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[15]_i_10 
       (.I0(filtered_latched[9]),
        .O(\accumulation[15]_i_10_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[15]_i_2 
       (.I0(accumulation[15]),
        .I1(filtered_latched[15]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[15]),
        .O(\accumulation[15]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[15]_i_3 
       (.I0(accumulation[14]),
        .I1(filtered_latched[14]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[14]),
        .O(\accumulation[15]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[15]_i_4 
       (.I0(accumulation[13]),
        .I1(filtered_latched[13]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[13]),
        .O(\accumulation[15]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[15]_i_5 
       (.I0(accumulation[12]),
        .I1(filtered_latched[12]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[12]),
        .O(\accumulation[15]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[15]_i_7 
       (.I0(filtered_latched[12]),
        .O(\accumulation[15]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[15]_i_8 
       (.I0(filtered_latched[11]),
        .O(\accumulation[15]_i_8_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[15]_i_9 
       (.I0(filtered_latched[10]),
        .O(\accumulation[15]_i_9_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[19]_i_10 
       (.I0(filtered_latched[13]),
        .O(\accumulation[19]_i_10_n_0 ));
  LUT3 #(
    .INIT(8'h6A)) 
    \accumulation[19]_i_2 
       (.I0(accumulation[17]),
        .I1(magnitude0[17]),
        .I2(filtered_latched[17]),
        .O(\accumulation[19]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[19]_i_3 
       (.I0(accumulation[16]),
        .I1(filtered_latched[16]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[16]),
        .O(\accumulation[19]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[19]_i_6 
       (.I0(filtered_latched[17]),
        .O(\accumulation[19]_i_6_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[19]_i_7 
       (.I0(filtered_latched[16]),
        .O(\accumulation[19]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[19]_i_8 
       (.I0(filtered_latched[15]),
        .O(\accumulation[19]_i_8_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[19]_i_9 
       (.I0(filtered_latched[14]),
        .O(\accumulation[19]_i_9_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[3]_i_2 
       (.I0(accumulation[3]),
        .I1(filtered_latched[3]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[3]),
        .O(\accumulation[3]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[3]_i_3 
       (.I0(accumulation[2]),
        .I1(filtered_latched[2]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[2]),
        .O(\accumulation[3]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[3]_i_4 
       (.I0(accumulation[1]),
        .I1(filtered_latched[1]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[1]),
        .O(\accumulation[3]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \accumulation[3]_i_5 
       (.I0(accumulation[0]),
        .I1(filtered_latched[0]),
        .O(\accumulation[3]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[7]_i_10 
       (.I0(filtered_latched[2]),
        .O(\accumulation[7]_i_10_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[7]_i_11 
       (.I0(filtered_latched[1]),
        .O(\accumulation[7]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[7]_i_2 
       (.I0(accumulation[7]),
        .I1(filtered_latched[7]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[7]),
        .O(\accumulation[7]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[7]_i_3 
       (.I0(accumulation[6]),
        .I1(filtered_latched[6]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[6]),
        .O(\accumulation[7]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[7]_i_4 
       (.I0(accumulation[5]),
        .I1(filtered_latched[5]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[5]),
        .O(\accumulation[7]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'h56A6)) 
    \accumulation[7]_i_5 
       (.I0(accumulation[4]),
        .I1(filtered_latched[4]),
        .I2(filtered_latched[17]),
        .I3(magnitude0[4]),
        .O(\accumulation[7]_i_5_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[7]_i_7 
       (.I0(filtered_latched[0]),
        .O(\accumulation[7]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[7]_i_8 
       (.I0(filtered_latched[4]),
        .O(\accumulation[7]_i_8_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \accumulation[7]_i_9 
       (.I0(filtered_latched[3]),
        .O(\accumulation[7]_i_9_n_0 ));
  FDRE \accumulation_reg[0] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[3]_i_1_n_7 ),
        .Q(accumulation[0]),
        .R(clipped_count));
  FDRE \accumulation_reg[10] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[11]_i_1_n_5 ),
        .Q(accumulation[10]),
        .R(clipped_count));
  FDRE \accumulation_reg[11] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[11]_i_1_n_4 ),
        .Q(accumulation[11]),
        .R(clipped_count));
  CARRY4 \accumulation_reg[11]_i_1 
       (.CI(\accumulation_reg[7]_i_1_n_0 ),
        .CO({\accumulation_reg[11]_i_1_n_0 ,\accumulation_reg[11]_i_1_n_1 ,\accumulation_reg[11]_i_1_n_2 ,\accumulation_reg[11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(accumulation[11:8]),
        .O({\accumulation_reg[11]_i_1_n_4 ,\accumulation_reg[11]_i_1_n_5 ,\accumulation_reg[11]_i_1_n_6 ,\accumulation_reg[11]_i_1_n_7 }),
        .S({\accumulation[11]_i_2_n_0 ,\accumulation[11]_i_3_n_0 ,\accumulation[11]_i_4_n_0 ,\accumulation[11]_i_5_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \accumulation_reg[11]_i_6 
       (.CI(\accumulation_reg[7]_i_6_n_0 ),
        .CO({\accumulation_reg[11]_i_6_n_0 ,\accumulation_reg[11]_i_6_n_1 ,\accumulation_reg[11]_i_6_n_2 ,\accumulation_reg[11]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(magnitude0[8:5]),
        .S({\accumulation[11]_i_7_n_0 ,\accumulation[11]_i_8_n_0 ,\accumulation[11]_i_9_n_0 ,\accumulation[11]_i_10_n_0 }));
  FDRE \accumulation_reg[12] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[15]_i_1_n_7 ),
        .Q(accumulation[12]),
        .R(clipped_count));
  FDRE \accumulation_reg[13] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[15]_i_1_n_6 ),
        .Q(accumulation[13]),
        .R(clipped_count));
  FDRE \accumulation_reg[14] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[15]_i_1_n_5 ),
        .Q(accumulation[14]),
        .R(clipped_count));
  FDRE \accumulation_reg[15] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[15]_i_1_n_4 ),
        .Q(accumulation[15]),
        .R(clipped_count));
  CARRY4 \accumulation_reg[15]_i_1 
       (.CI(\accumulation_reg[11]_i_1_n_0 ),
        .CO({\accumulation_reg[15]_i_1_n_0 ,\accumulation_reg[15]_i_1_n_1 ,\accumulation_reg[15]_i_1_n_2 ,\accumulation_reg[15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(accumulation[15:12]),
        .O({\accumulation_reg[15]_i_1_n_4 ,\accumulation_reg[15]_i_1_n_5 ,\accumulation_reg[15]_i_1_n_6 ,\accumulation_reg[15]_i_1_n_7 }),
        .S({\accumulation[15]_i_2_n_0 ,\accumulation[15]_i_3_n_0 ,\accumulation[15]_i_4_n_0 ,\accumulation[15]_i_5_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \accumulation_reg[15]_i_6 
       (.CI(\accumulation_reg[11]_i_6_n_0 ),
        .CO({\accumulation_reg[15]_i_6_n_0 ,\accumulation_reg[15]_i_6_n_1 ,\accumulation_reg[15]_i_6_n_2 ,\accumulation_reg[15]_i_6_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(magnitude0[12:9]),
        .S({\accumulation[15]_i_7_n_0 ,\accumulation[15]_i_8_n_0 ,\accumulation[15]_i_9_n_0 ,\accumulation[15]_i_10_n_0 }));
  FDRE \accumulation_reg[16] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[19]_i_1_n_7 ),
        .Q(accumulation[16]),
        .R(clipped_count));
  FDRE \accumulation_reg[17] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[19]_i_1_n_6 ),
        .Q(accumulation[17]),
        .R(clipped_count));
  FDRE \accumulation_reg[18] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[19]_i_1_n_5 ),
        .Q(accumulation[18]),
        .R(clipped_count));
  FDRE \accumulation_reg[19] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[19]_i_1_n_4 ),
        .Q(accumulation[19]),
        .R(clipped_count));
  CARRY4 \accumulation_reg[19]_i_1 
       (.CI(\accumulation_reg[15]_i_1_n_0 ),
        .CO({\accumulation_reg[19]_i_1_n_0 ,\accumulation_reg[19]_i_1_n_1 ,\accumulation_reg[19]_i_1_n_2 ,\accumulation_reg[19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,accumulation[17:16]}),
        .O({\accumulation_reg[19]_i_1_n_4 ,\accumulation_reg[19]_i_1_n_5 ,\accumulation_reg[19]_i_1_n_6 ,\accumulation_reg[19]_i_1_n_7 }),
        .S({accumulation[19:18],\accumulation[19]_i_2_n_0 ,\accumulation[19]_i_3_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \accumulation_reg[19]_i_4 
       (.CI(\accumulation_reg[19]_i_5_n_0 ),
        .CO(\NLW_accumulation_reg[19]_i_4_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_accumulation_reg[19]_i_4_O_UNCONNECTED [3:1],magnitude0[17]}),
        .S({1'b0,1'b0,1'b0,\accumulation[19]_i_6_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \accumulation_reg[19]_i_5 
       (.CI(\accumulation_reg[15]_i_6_n_0 ),
        .CO({\accumulation_reg[19]_i_5_n_0 ,\accumulation_reg[19]_i_5_n_1 ,\accumulation_reg[19]_i_5_n_2 ,\accumulation_reg[19]_i_5_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(magnitude0[16:13]),
        .S({\accumulation[19]_i_7_n_0 ,\accumulation[19]_i_8_n_0 ,\accumulation[19]_i_9_n_0 ,\accumulation[19]_i_10_n_0 }));
  FDRE \accumulation_reg[1] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[3]_i_1_n_6 ),
        .Q(accumulation[1]),
        .R(clipped_count));
  FDRE \accumulation_reg[20] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[23]_i_1_n_7 ),
        .Q(accumulation[20]),
        .R(clipped_count));
  FDRE \accumulation_reg[21] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[23]_i_1_n_6 ),
        .Q(accumulation[21]),
        .R(clipped_count));
  FDRE \accumulation_reg[22] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[23]_i_1_n_5 ),
        .Q(accumulation[22]),
        .R(clipped_count));
  FDRE \accumulation_reg[23] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[23]_i_1_n_4 ),
        .Q(accumulation[23]),
        .R(clipped_count));
  CARRY4 \accumulation_reg[23]_i_1 
       (.CI(\accumulation_reg[19]_i_1_n_0 ),
        .CO({\accumulation_reg[23]_i_1_n_0 ,\accumulation_reg[23]_i_1_n_1 ,\accumulation_reg[23]_i_1_n_2 ,\accumulation_reg[23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\accumulation_reg[23]_i_1_n_4 ,\accumulation_reg[23]_i_1_n_5 ,\accumulation_reg[23]_i_1_n_6 ,\accumulation_reg[23]_i_1_n_7 }),
        .S(accumulation[23:20]));
  FDRE \accumulation_reg[24] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[27]_i_1_n_7 ),
        .Q(accumulation[24]),
        .R(clipped_count));
  FDRE \accumulation_reg[25] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[27]_i_1_n_6 ),
        .Q(accumulation[25]),
        .R(clipped_count));
  FDRE \accumulation_reg[26] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[27]_i_1_n_5 ),
        .Q(accumulation[26]),
        .R(clipped_count));
  FDRE \accumulation_reg[27] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[27]_i_1_n_4 ),
        .Q(accumulation[27]),
        .R(clipped_count));
  CARRY4 \accumulation_reg[27]_i_1 
       (.CI(\accumulation_reg[23]_i_1_n_0 ),
        .CO({\accumulation_reg[27]_i_1_n_0 ,\accumulation_reg[27]_i_1_n_1 ,\accumulation_reg[27]_i_1_n_2 ,\accumulation_reg[27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\accumulation_reg[27]_i_1_n_4 ,\accumulation_reg[27]_i_1_n_5 ,\accumulation_reg[27]_i_1_n_6 ,\accumulation_reg[27]_i_1_n_7 }),
        .S(accumulation[27:24]));
  FDRE \accumulation_reg[28] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[31]_i_1_n_7 ),
        .Q(accumulation[28]),
        .R(clipped_count));
  FDRE \accumulation_reg[29] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[31]_i_1_n_6 ),
        .Q(accumulation[29]),
        .R(clipped_count));
  FDRE \accumulation_reg[2] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[3]_i_1_n_5 ),
        .Q(accumulation[2]),
        .R(clipped_count));
  FDRE \accumulation_reg[30] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[31]_i_1_n_5 ),
        .Q(accumulation[30]),
        .R(clipped_count));
  FDRE \accumulation_reg[31] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[31]_i_1_n_4 ),
        .Q(accumulation[31]),
        .R(clipped_count));
  CARRY4 \accumulation_reg[31]_i_1 
       (.CI(\accumulation_reg[27]_i_1_n_0 ),
        .CO({\accumulation_reg[31]_i_1_n_0 ,\accumulation_reg[31]_i_1_n_1 ,\accumulation_reg[31]_i_1_n_2 ,\accumulation_reg[31]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\accumulation_reg[31]_i_1_n_4 ,\accumulation_reg[31]_i_1_n_5 ,\accumulation_reg[31]_i_1_n_6 ,\accumulation_reg[31]_i_1_n_7 }),
        .S(accumulation[31:28]));
  FDRE \accumulation_reg[3] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[3]_i_1_n_4 ),
        .Q(accumulation[3]),
        .R(clipped_count));
  CARRY4 \accumulation_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\accumulation_reg[3]_i_1_n_0 ,\accumulation_reg[3]_i_1_n_1 ,\accumulation_reg[3]_i_1_n_2 ,\accumulation_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(accumulation[3:0]),
        .O({\accumulation_reg[3]_i_1_n_4 ,\accumulation_reg[3]_i_1_n_5 ,\accumulation_reg[3]_i_1_n_6 ,\accumulation_reg[3]_i_1_n_7 }),
        .S({\accumulation[3]_i_2_n_0 ,\accumulation[3]_i_3_n_0 ,\accumulation[3]_i_4_n_0 ,\accumulation[3]_i_5_n_0 }));
  FDRE \accumulation_reg[4] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[7]_i_1_n_7 ),
        .Q(accumulation[4]),
        .R(clipped_count));
  FDRE \accumulation_reg[5] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[7]_i_1_n_6 ),
        .Q(accumulation[5]),
        .R(clipped_count));
  FDRE \accumulation_reg[6] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[7]_i_1_n_5 ),
        .Q(accumulation[6]),
        .R(clipped_count));
  FDRE \accumulation_reg[7] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[7]_i_1_n_4 ),
        .Q(accumulation[7]),
        .R(clipped_count));
  CARRY4 \accumulation_reg[7]_i_1 
       (.CI(\accumulation_reg[3]_i_1_n_0 ),
        .CO({\accumulation_reg[7]_i_1_n_0 ,\accumulation_reg[7]_i_1_n_1 ,\accumulation_reg[7]_i_1_n_2 ,\accumulation_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(accumulation[7:4]),
        .O({\accumulation_reg[7]_i_1_n_4 ,\accumulation_reg[7]_i_1_n_5 ,\accumulation_reg[7]_i_1_n_6 ,\accumulation_reg[7]_i_1_n_7 }),
        .S({\accumulation[7]_i_2_n_0 ,\accumulation[7]_i_3_n_0 ,\accumulation[7]_i_4_n_0 ,\accumulation[7]_i_5_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \accumulation_reg[7]_i_6 
       (.CI(1'b0),
        .CO({\accumulation_reg[7]_i_6_n_0 ,\accumulation_reg[7]_i_6_n_1 ,\accumulation_reg[7]_i_6_n_2 ,\accumulation_reg[7]_i_6_n_3 }),
        .CYINIT(\accumulation[7]_i_7_n_0 ),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(magnitude0[4:1]),
        .S({\accumulation[7]_i_8_n_0 ,\accumulation[7]_i_9_n_0 ,\accumulation[7]_i_10_n_0 ,\accumulation[7]_i_11_n_0 }));
  FDRE \accumulation_reg[8] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[11]_i_1_n_7 ),
        .Q(accumulation[8]),
        .R(clipped_count));
  FDRE \accumulation_reg[9] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(\accumulation_reg[11]_i_1_n_6 ),
        .Q(accumulation[9]),
        .R(clipped_count));
  LUT6 #(
    .INIT(64'h4040404040444040)) 
    ack_error_i_1
       (.I0(configure),
        .I1(s_axi_aresetn),
        .I2(status[1]),
        .I3(ack_error_i_2_n_0),
        .I4(ack_error_reg_0),
        .I5(ack_error_i_3_n_0),
        .O(ack_error_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT3 #(
    .INIT(8'hBF)) 
    ack_error_i_2
       (.I0(configure),
        .I1(\faults_reg[0]_1 ),
        .I2(\event_age[31]_i_1_n_0 ),
        .O(ack_error_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    ack_error_i_3
       (.I0(ack_error_reg_0),
        .I1(status[0]),
        .I2(matching_ack0),
        .I3(matching_ack1),
        .O(ack_error_i_3_n_0));
  FDRE ack_error_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ack_error_i_1_n_0),
        .Q(status[1]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \candidate_count[0]_i_1 
       (.I0(status[3]),
        .I1(candidate_count[0]),
        .O(\candidate_count[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT3 #(
    .INIT(8'h60)) 
    \candidate_count[1]_i_1 
       (.I0(candidate_count[0]),
        .I1(candidate_count[1]),
        .I2(status[3]),
        .O(\candidate_count[1]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00002808)) 
    \candidate_count[2]_i_1 
       (.I0(\candidate_count[2]_i_3_n_0 ),
        .I1(status[3]),
        .I2(status[2]),
        .I3(p_1_in),
        .I4(status[4]),
        .O(soft_count));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \candidate_count[2]_i_2 
       (.I0(status[3]),
        .I1(candidate_count[1]),
        .I2(candidate_count[0]),
        .I3(candidate_count[2]),
        .O(\candidate_count[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000002)) 
    \candidate_count[2]_i_3 
       (.I0(\clipped_count[15]_i_4_n_0 ),
        .I1(\candidate_count[2]_i_4_n_0 ),
        .I2(\faults_reg[7]_0 [4]),
        .I3(\faults_reg[7]_0 [5]),
        .I4(\faults_reg[7]_0 [6]),
        .I5(\faults_reg[7]_0 [7]),
        .O(\candidate_count[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFEFFFEFFFFFFFEFF)) 
    \candidate_count[2]_i_4 
       (.I0(\candidate_count[2]_i_5_n_0 ),
        .I1(\faults_reg[7]_0 [0]),
        .I2(\faults_reg[7]_0 [5]),
        .I3(filtered_valid),
        .I4(\faults_reg[7]_0 [3]),
        .I5(\faults_reg[7]_0 [4]),
        .O(\candidate_count[2]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \candidate_count[2]_i_5 
       (.I0(\faults_reg[7]_0 [1]),
        .I1(\faults_reg[7]_0 [2]),
        .O(\candidate_count[2]_i_5_n_0 ));
  FDRE \candidate_count_reg[0] 
       (.C(s_axi_aclk),
        .CE(soft_count),
        .D(\candidate_count[0]_i_1_n_0 ),
        .Q(candidate_count[0]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \candidate_count_reg[1] 
       (.C(s_axi_aclk),
        .CE(soft_count),
        .D(\candidate_count[1]_i_1_n_0 ),
        .Q(candidate_count[1]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \candidate_count_reg[2] 
       (.C(s_axi_aclk),
        .CE(soft_count),
        .D(\candidate_count[2]_i_2_n_0 ),
        .Q(candidate_count[2]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 centered_carry
       (.CI(1'b0),
        .CO({centered_carry_n_0,centered_carry_n_1,centered_carry_n_2,centered_carry_n_3}),
        .CYINIT(centered_carry_i_1_n_0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_centered_carry_O_UNCONNECTED[3:0]),
        .S({centered_carry_i_2__0_n_0,centered_carry_i_3__0_n_0,centered_carry_i_4__0_n_0,centered_carry_i_5_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 centered_carry__0
       (.CI(centered_carry_n_0),
        .CO({centered_carry__0_n_0,centered_carry__0_n_1,centered_carry__0_n_2,centered_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({scaled_latched[8],1'b0,1'b0,1'b0}),
        .O({centered[8],NLW_centered_carry__0_O_UNCONNECTED[2:0]}),
        .S({centered_carry_i_1__5_n_0,centered_carry_i_2_n_0,centered_carry_i_3_n_0,centered_carry_i_4_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 centered_carry__1
       (.CI(centered_carry__0_n_0),
        .CO({centered_carry__1_n_0,centered_carry__1_n_1,centered_carry__1_n_2,centered_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI(scaled_latched[12:9]),
        .O(centered[12:9]),
        .S({centered_carry_i_1__4_n_0,centered_carry_i_2__4_n_0,centered_carry_i_3__4_n_0,centered_carry_i_4__4_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 centered_carry__2
       (.CI(centered_carry__1_n_0),
        .CO({centered_carry__2_n_0,centered_carry__2_n_1,centered_carry__2_n_2,centered_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI(scaled_latched[16:13]),
        .O(centered[16:13]),
        .S({centered_carry_i_1__3_n_0,centered_carry_i_2__3_n_0,centered_carry_i_3__3_n_0,centered_carry_i_4__3_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 centered_carry__3
       (.CI(centered_carry__2_n_0),
        .CO({centered_carry__3_n_0,centered_carry__3_n_1,centered_carry__3_n_2,centered_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI(scaled_latched[20:17]),
        .O(centered[20:17]),
        .S({centered_carry_i_1__2_n_0,centered_carry_i_2__2_n_0,centered_carry_i_3__2_n_0,centered_carry_i_4__2_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 centered_carry__4
       (.CI(centered_carry__3_n_0),
        .CO({centered_carry__4_n_0,centered_carry__4_n_1,centered_carry__4_n_2,centered_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI({next_dc_carry__5_n_7,scaled_latched[24],scaled_latched[22:21]}),
        .O(centered[24:21]),
        .S({centered_carry_i_1__0_n_0,centered_carry_i_2__1_n_0,centered_carry_i_3__1_n_0,centered_carry_i_4__1_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 centered_carry__5
       (.CI(centered_carry__4_n_0),
        .CO(NLW_centered_carry__5_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_centered_carry__5_O_UNCONNECTED[3:1],centered[25]}),
        .S({1'b0,1'b0,1'b0,centered_carry_i_1__1_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    centered_carry_i_1
       (.I0(next_dc_carry_n_7),
        .O(centered_carry_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_1__0
       (.I0(next_dc_carry__5_n_7),
        .I1(scaled_latched[24]),
        .O(centered_carry_i_1__0_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    centered_carry_i_1__1
       (.I0(next_dc_carry__5_n_7),
        .I1(next_dc_carry__5_n_2),
        .O(centered_carry_i_1__1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_1__2
       (.I0(scaled_latched[20]),
        .I1(next_dc_carry__4_n_7),
        .O(centered_carry_i_1__2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_1__3
       (.I0(scaled_latched[16]),
        .I1(next_dc_carry__3_n_7),
        .O(centered_carry_i_1__3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_1__4
       (.I0(scaled_latched[12]),
        .I1(next_dc_carry__2_n_7),
        .O(centered_carry_i_1__4_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_1__5
       (.I0(scaled_latched[8]),
        .I1(next_dc_carry__1_n_7),
        .O(centered_carry_i_1__5_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    centered_carry_i_2
       (.I0(next_dc_carry__0_n_4),
        .O(centered_carry_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    centered_carry_i_2__0
       (.I0(next_dc_carry__0_n_7),
        .O(centered_carry_i_2__0_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_2__1
       (.I0(scaled_latched[24]),
        .I1(next_dc_carry__4_n_4),
        .O(centered_carry_i_2__1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_2__2
       (.I0(scaled_latched[19]),
        .I1(next_dc_carry__3_n_4),
        .O(centered_carry_i_2__2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_2__3
       (.I0(scaled_latched[15]),
        .I1(next_dc_carry__2_n_4),
        .O(centered_carry_i_2__3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_2__4
       (.I0(scaled_latched[11]),
        .I1(next_dc_carry__1_n_4),
        .O(centered_carry_i_2__4_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    centered_carry_i_3
       (.I0(next_dc_carry__0_n_5),
        .O(centered_carry_i_3_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    centered_carry_i_3__0
       (.I0(next_dc_carry_n_4),
        .O(centered_carry_i_3__0_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_3__1
       (.I0(scaled_latched[22]),
        .I1(next_dc_carry__4_n_5),
        .O(centered_carry_i_3__1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_3__2
       (.I0(scaled_latched[18]),
        .I1(next_dc_carry__3_n_5),
        .O(centered_carry_i_3__2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_3__3
       (.I0(scaled_latched[14]),
        .I1(next_dc_carry__2_n_5),
        .O(centered_carry_i_3__3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_3__4
       (.I0(scaled_latched[10]),
        .I1(next_dc_carry__1_n_5),
        .O(centered_carry_i_3__4_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    centered_carry_i_4
       (.I0(next_dc_carry__0_n_6),
        .O(centered_carry_i_4_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    centered_carry_i_4__0
       (.I0(next_dc_carry_n_5),
        .O(centered_carry_i_4__0_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_4__1
       (.I0(scaled_latched[21]),
        .I1(next_dc_carry__4_n_6),
        .O(centered_carry_i_4__1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_4__2
       (.I0(scaled_latched[17]),
        .I1(next_dc_carry__3_n_6),
        .O(centered_carry_i_4__2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_4__3
       (.I0(scaled_latched[13]),
        .I1(next_dc_carry__2_n_6),
        .O(centered_carry_i_4__3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    centered_carry_i_4__4
       (.I0(scaled_latched[9]),
        .I1(next_dc_carry__1_n_6),
        .O(centered_carry_i_4__4_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    centered_carry_i_5
       (.I0(next_dc_carry_n_6),
        .O(centered_carry_i_5_n_0));
  LUT5 #(
    .INIT(32'hFFBFBFBF)) 
    \clipped_count[15]_i_1 
       (.I0(configure),
        .I1(s_axi_aresetn),
        .I2(\faults_reg[0]_1 ),
        .I3(\clipped_count[15]_i_2_n_0 ),
        .I4(\clipped_count[15]_i_4_n_0 ),
        .O(clipped_count));
  LUT2 #(
    .INIT(4'h8)) 
    \clipped_count[15]_i_2 
       (.I0(\event_age[31]_i_1_n_0 ),
        .I1(filtered_valid),
        .O(\clipped_count[15]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \clipped_count[15]_i_4 
       (.I0(\sample_in_window_reg_n_0_[9] ),
        .I1(\sample_in_window[9]_i_3_n_0 ),
        .O(\clipped_count[15]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \clipped_count[3]_i_2 
       (.I0(\clipped_count_reg_n_0_[0] ),
        .I1(filtered_clipped),
        .O(\clipped_count[3]_i_2_n_0 ));
  FDRE \clipped_count_reg[0] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[0]),
        .Q(\clipped_count_reg_n_0_[0] ),
        .R(clipped_count));
  FDRE \clipped_count_reg[10] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[10]),
        .Q(\clipped_count_reg_n_0_[10] ),
        .R(clipped_count));
  FDRE \clipped_count_reg[11] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[11]),
        .Q(\clipped_count_reg_n_0_[11] ),
        .R(clipped_count));
  CARRY4 \clipped_count_reg[11]_i_1 
       (.CI(\clipped_count_reg[7]_i_1_n_0 ),
        .CO({\clipped_count_reg[11]_i_1_n_0 ,\clipped_count_reg[11]_i_1_n_1 ,\clipped_count_reg[11]_i_1_n_2 ,\clipped_count_reg[11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(next_clipped[11:8]),
        .S({\clipped_count_reg_n_0_[11] ,\clipped_count_reg_n_0_[10] ,\clipped_count_reg_n_0_[9] ,\clipped_count_reg_n_0_[8] }));
  FDRE \clipped_count_reg[12] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[12]),
        .Q(\clipped_count_reg_n_0_[12] ),
        .R(clipped_count));
  FDRE \clipped_count_reg[13] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[13]),
        .Q(\clipped_count_reg_n_0_[13] ),
        .R(clipped_count));
  FDRE \clipped_count_reg[14] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[14]),
        .Q(\clipped_count_reg_n_0_[14] ),
        .R(clipped_count));
  FDRE \clipped_count_reg[15] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[15]),
        .Q(\clipped_count_reg_n_0_[15] ),
        .R(clipped_count));
  CARRY4 \clipped_count_reg[15]_i_3 
       (.CI(\clipped_count_reg[11]_i_1_n_0 ),
        .CO({\clipped_count_reg[15]_i_3_n_0 ,\clipped_count_reg[15]_i_3_n_1 ,\clipped_count_reg[15]_i_3_n_2 ,\clipped_count_reg[15]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(next_clipped[15:12]),
        .S({\clipped_count_reg_n_0_[15] ,\clipped_count_reg_n_0_[14] ,\clipped_count_reg_n_0_[13] ,\clipped_count_reg_n_0_[12] }));
  FDRE \clipped_count_reg[1] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[1]),
        .Q(\clipped_count_reg_n_0_[1] ),
        .R(clipped_count));
  FDRE \clipped_count_reg[2] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[2]),
        .Q(\clipped_count_reg_n_0_[2] ),
        .R(clipped_count));
  FDRE \clipped_count_reg[3] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[3]),
        .Q(\clipped_count_reg_n_0_[3] ),
        .R(clipped_count));
  CARRY4 \clipped_count_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\clipped_count_reg[3]_i_1_n_0 ,\clipped_count_reg[3]_i_1_n_1 ,\clipped_count_reg[3]_i_1_n_2 ,\clipped_count_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\clipped_count_reg_n_0_[0] }),
        .O(next_clipped[3:0]),
        .S({\clipped_count_reg_n_0_[3] ,\clipped_count_reg_n_0_[2] ,\clipped_count_reg_n_0_[1] ,\clipped_count[3]_i_2_n_0 }));
  FDRE \clipped_count_reg[4] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[4]),
        .Q(\clipped_count_reg_n_0_[4] ),
        .R(clipped_count));
  FDRE \clipped_count_reg[5] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[5]),
        .Q(\clipped_count_reg_n_0_[5] ),
        .R(clipped_count));
  FDRE \clipped_count_reg[6] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[6]),
        .Q(\clipped_count_reg_n_0_[6] ),
        .R(clipped_count));
  FDRE \clipped_count_reg[7] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[7]),
        .Q(\clipped_count_reg_n_0_[7] ),
        .R(clipped_count));
  CARRY4 \clipped_count_reg[7]_i_1 
       (.CI(\clipped_count_reg[3]_i_1_n_0 ),
        .CO({\clipped_count_reg[7]_i_1_n_0 ,\clipped_count_reg[7]_i_1_n_1 ,\clipped_count_reg[7]_i_1_n_2 ,\clipped_count_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(next_clipped[7:4]),
        .S({\clipped_count_reg_n_0_[7] ,\clipped_count_reg_n_0_[6] ,\clipped_count_reg_n_0_[5] ,\clipped_count_reg_n_0_[4] }));
  FDRE \clipped_count_reg[8] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[8]),
        .Q(\clipped_count_reg_n_0_[8] ),
        .R(clipped_count));
  FDRE \clipped_count_reg[9] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(next_clipped[9]),
        .Q(\clipped_count_reg_n_0_[9] ),
        .R(clipped_count));
  LUT4 #(
    .INIT(16'hBFFF)) 
    dc_clipped_i_1
       (.I0(configure),
        .I1(s_axi_aresetn),
        .I2(\faults_reg[0]_1 ),
        .I3(\event_age[31]_i_1_n_0 ),
        .O(dc_level0));
  LUT3 #(
    .INIT(8'h02)) 
    dc_clipped_i_2
       (.I0(pcm_valid),
        .I1(dc_valid),
        .I2(filtered_valid),
        .O(scaled_latched0));
  FDRE dc_clipped_reg
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_clipped0),
        .Q(dc_clipped),
        .R(dc_level0));
  CARRY4 dc_difference_carry
       (.CI(1'b0),
        .CO({dc_difference_carry_n_0,dc_difference_carry_n_1,dc_difference_carry_n_2,dc_difference_carry_n_3}),
        .CYINIT(p_0_out[0]),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_dc_difference_carry_O_UNCONNECTED[3:0]),
        .S(p_0_out[4:1]));
  CARRY4 dc_difference_carry__0
       (.CI(dc_difference_carry_n_0),
        .CO({dc_difference_carry__0_n_0,dc_difference_carry__0_n_1,dc_difference_carry__0_n_2,dc_difference_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({D[0],1'b0,1'b0,1'b0}),
        .O(NLW_dc_difference_carry__0_O_UNCONNECTED[3:0]),
        .S({\difference_latched_reg[12]_0 ,p_0_out[7:5]}));
  LUT1 #(
    .INIT(2'h1)) 
    dc_difference_carry__0_i_2
       (.I0(dc_level[7]),
        .O(p_0_out[7]));
  LUT1 #(
    .INIT(2'h1)) 
    dc_difference_carry__0_i_3
       (.I0(dc_level[6]),
        .O(p_0_out[6]));
  LUT1 #(
    .INIT(2'h1)) 
    dc_difference_carry__0_i_4
       (.I0(dc_level[5]),
        .O(p_0_out[5]));
  CARRY4 dc_difference_carry__1
       (.CI(dc_difference_carry__0_n_0),
        .CO({dc_difference_carry__1_n_0,dc_difference_carry__1_n_1,dc_difference_carry__1_n_2,dc_difference_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI(D[4:1]),
        .O({dc_difference[12:10],NLW_dc_difference_carry__1_O_UNCONNECTED[0]}),
        .S(\difference_latched_reg[12]_1 ));
  CARRY4 dc_difference_carry__2
       (.CI(dc_difference_carry__1_n_0),
        .CO({dc_difference_carry__2_n_0,dc_difference_carry__2_n_1,dc_difference_carry__2_n_2,dc_difference_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI(D[8:5]),
        .O(dc_difference[16:13]),
        .S(S));
  CARRY4 dc_difference_carry__3
       (.CI(dc_difference_carry__2_n_0),
        .CO({dc_difference_carry__3_n_0,dc_difference_carry__3_n_1,dc_difference_carry__3_n_2,dc_difference_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI(D[12:9]),
        .O(dc_difference[20:17]),
        .S(\difference_latched_reg[20]_0 ));
  CARRY4 dc_difference_carry__4
       (.CI(dc_difference_carry__3_n_0),
        .CO({dc_difference_carry__4_n_0,dc_difference_carry__4_n_1,dc_difference_carry__4_n_2,dc_difference_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI({dc_level[24:23],D[14:13]}),
        .O(dc_difference[24:21]),
        .S({dc_difference_carry__4_i_1_n_0,dc_difference_carry__4_i_2_n_0,\difference_latched_reg[24]_0 }));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__4_i_1
       (.I0(dc_level[23]),
        .I1(dc_level[24]),
        .O(dc_difference_carry__4_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__4_i_2
       (.I0(dc_level[23]),
        .I1(D[15]),
        .O(dc_difference_carry__4_i_2_n_0));
  CARRY4 dc_difference_carry__5
       (.CI(dc_difference_carry__4_n_0),
        .CO(NLW_dc_difference_carry__5_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_dc_difference_carry__5_O_UNCONNECTED[3:1],dc_difference[25]}),
        .S({1'b0,1'b0,1'b0,1'b1}));
  LUT1 #(
    .INIT(2'h1)) 
    dc_difference_carry_i_1
       (.I0(dc_level[0]),
        .O(p_0_out[0]));
  LUT1 #(
    .INIT(2'h1)) 
    dc_difference_carry_i_2
       (.I0(dc_level[4]),
        .O(p_0_out[4]));
  LUT1 #(
    .INIT(2'h1)) 
    dc_difference_carry_i_3
       (.I0(dc_level[3]),
        .O(p_0_out[3]));
  LUT1 #(
    .INIT(2'h1)) 
    dc_difference_carry_i_4
       (.I0(dc_level[2]),
        .O(p_0_out[2]));
  LUT1 #(
    .INIT(2'h1)) 
    dc_difference_carry_i_5
       (.I0(dc_level[1]),
        .O(p_0_out[1]));
  FDRE \dc_level_reg[0] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry_n_7),
        .Q(dc_level[0]),
        .R(dc_level0));
  FDRE \dc_level_reg[10] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__1_n_5),
        .Q(\dc_level_reg[22]_0 [2]),
        .R(dc_level0));
  FDRE \dc_level_reg[11] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__1_n_4),
        .Q(\dc_level_reg[22]_0 [3]),
        .R(dc_level0));
  FDRE \dc_level_reg[12] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__2_n_7),
        .Q(\dc_level_reg[22]_0 [4]),
        .R(dc_level0));
  FDRE \dc_level_reg[13] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__2_n_6),
        .Q(\dc_level_reg[22]_0 [5]),
        .R(dc_level0));
  FDRE \dc_level_reg[14] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__2_n_5),
        .Q(\dc_level_reg[22]_0 [6]),
        .R(dc_level0));
  FDRE \dc_level_reg[15] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__2_n_4),
        .Q(\dc_level_reg[22]_0 [7]),
        .R(dc_level0));
  FDRE \dc_level_reg[16] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__3_n_7),
        .Q(\dc_level_reg[22]_0 [8]),
        .R(dc_level0));
  FDRE \dc_level_reg[17] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__3_n_6),
        .Q(\dc_level_reg[22]_0 [9]),
        .R(dc_level0));
  FDRE \dc_level_reg[18] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__3_n_5),
        .Q(\dc_level_reg[22]_0 [10]),
        .R(dc_level0));
  FDRE \dc_level_reg[19] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__3_n_4),
        .Q(\dc_level_reg[22]_0 [11]),
        .R(dc_level0));
  FDRE \dc_level_reg[1] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry_n_6),
        .Q(dc_level[1]),
        .R(dc_level0));
  FDRE \dc_level_reg[20] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__4_n_7),
        .Q(\dc_level_reg[22]_0 [12]),
        .R(dc_level0));
  FDRE \dc_level_reg[21] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__4_n_6),
        .Q(\dc_level_reg[22]_0 [13]),
        .R(dc_level0));
  FDRE \dc_level_reg[22] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__4_n_5),
        .Q(\dc_level_reg[22]_0 [14]),
        .R(dc_level0));
  FDRE \dc_level_reg[23] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__4_n_4),
        .Q(dc_level[23]),
        .R(dc_level0));
  FDRE \dc_level_reg[24] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__5_n_7),
        .Q(dc_level[24]),
        .R(dc_level0));
  FDRE \dc_level_reg[2] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry_n_5),
        .Q(dc_level[2]),
        .R(dc_level0));
  FDRE \dc_level_reg[3] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry_n_4),
        .Q(dc_level[3]),
        .R(dc_level0));
  FDRE \dc_level_reg[4] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__0_n_7),
        .Q(dc_level[4]),
        .R(dc_level0));
  FDRE \dc_level_reg[5] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__0_n_6),
        .Q(dc_level[5]),
        .R(dc_level0));
  FDRE \dc_level_reg[6] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__0_n_5),
        .Q(dc_level[6]),
        .R(dc_level0));
  FDRE \dc_level_reg[7] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__0_n_4),
        .Q(dc_level[7]),
        .R(dc_level0));
  FDRE \dc_level_reg[8] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__1_n_7),
        .Q(\dc_level_reg[22]_0 [0]),
        .R(dc_level0));
  FDRE \dc_level_reg[9] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(next_dc_carry__1_n_6),
        .Q(\dc_level_reg[22]_0 [1]),
        .R(dc_level0));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT4 #(
    .INIT(16'h0010)) 
    dc_valid_i_1
       (.I0(filtered_valid),
        .I1(dc_valid),
        .I2(pcm_valid),
        .I3(dc_level0),
        .O(dc_valid_i_1_n_0));
  FDRE dc_valid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(dc_valid_i_1_n_0),
        .Q(dc_valid),
        .R(1'b0));
  FDRE \difference_latched_reg[10] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[10]),
        .Q(\difference_latched_reg_n_0_[10] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[11] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[11]),
        .Q(\difference_latched_reg_n_0_[11] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[12] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[12]),
        .Q(\difference_latched_reg_n_0_[12] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[13] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[13]),
        .Q(\difference_latched_reg_n_0_[13] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[14] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[14]),
        .Q(\difference_latched_reg_n_0_[14] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[15] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[15]),
        .Q(\difference_latched_reg_n_0_[15] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[16] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[16]),
        .Q(\difference_latched_reg_n_0_[16] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[17] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[17]),
        .Q(\difference_latched_reg_n_0_[17] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[18] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[18]),
        .Q(\difference_latched_reg_n_0_[18] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[19] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[19]),
        .Q(\difference_latched_reg_n_0_[19] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[20] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[20]),
        .Q(\difference_latched_reg_n_0_[20] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[21] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[21]),
        .Q(\difference_latched_reg_n_0_[21] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[22] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[22]),
        .Q(\difference_latched_reg_n_0_[22] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[23] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[23]),
        .Q(\difference_latched_reg_n_0_[23] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[24] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[24]),
        .Q(\difference_latched_reg_n_0_[24] ),
        .R(dc_level0));
  FDRE \difference_latched_reg[25] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(dc_difference[25]),
        .Q(next_dc00),
        .R(dc_level0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 event_age0_carry
       (.CI(1'b0),
        .CO({event_age0_carry_n_0,event_age0_carry_n_1,event_age0_carry_n_2,event_age0_carry_n_3}),
        .CYINIT(Q[0]),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({event_age0_carry_n_4,event_age0_carry_n_5,event_age0_carry_n_6,event_age0_carry_n_7}),
        .S(Q[4:1]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 event_age0_carry__0
       (.CI(event_age0_carry_n_0),
        .CO({event_age0_carry__0_n_0,event_age0_carry__0_n_1,event_age0_carry__0_n_2,event_age0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({event_age0_carry__0_n_4,event_age0_carry__0_n_5,event_age0_carry__0_n_6,event_age0_carry__0_n_7}),
        .S(Q[8:5]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 event_age0_carry__1
       (.CI(event_age0_carry__0_n_0),
        .CO({event_age0_carry__1_n_0,event_age0_carry__1_n_1,event_age0_carry__1_n_2,event_age0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({event_age0_carry__1_n_4,event_age0_carry__1_n_5,event_age0_carry__1_n_6,event_age0_carry__1_n_7}),
        .S(Q[12:9]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 event_age0_carry__2
       (.CI(event_age0_carry__1_n_0),
        .CO({event_age0_carry__2_n_0,event_age0_carry__2_n_1,event_age0_carry__2_n_2,event_age0_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({event_age0_carry__2_n_4,event_age0_carry__2_n_5,event_age0_carry__2_n_6,event_age0_carry__2_n_7}),
        .S(Q[16:13]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 event_age0_carry__3
       (.CI(event_age0_carry__2_n_0),
        .CO({event_age0_carry__3_n_0,event_age0_carry__3_n_1,event_age0_carry__3_n_2,event_age0_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({event_age0_carry__3_n_4,event_age0_carry__3_n_5,event_age0_carry__3_n_6,event_age0_carry__3_n_7}),
        .S(Q[20:17]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 event_age0_carry__4
       (.CI(event_age0_carry__3_n_0),
        .CO({event_age0_carry__4_n_0,event_age0_carry__4_n_1,event_age0_carry__4_n_2,event_age0_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({event_age0_carry__4_n_4,event_age0_carry__4_n_5,event_age0_carry__4_n_6,event_age0_carry__4_n_7}),
        .S(Q[24:21]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 event_age0_carry__5
       (.CI(event_age0_carry__4_n_0),
        .CO({event_age0_carry__5_n_0,event_age0_carry__5_n_1,event_age0_carry__5_n_2,event_age0_carry__5_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({event_age0_carry__5_n_4,event_age0_carry__5_n_5,event_age0_carry__5_n_6,event_age0_carry__5_n_7}),
        .S(Q[28:25]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 event_age0_carry__6
       (.CI(event_age0_carry__5_n_0),
        .CO({NLW_event_age0_carry__6_CO_UNCONNECTED[3:2],event_age0_carry__6_n_2,event_age0_carry__6_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_event_age0_carry__6_O_UNCONNECTED[3],event_age0_carry__6_n_5,event_age0_carry__6_n_6,event_age0_carry__6_n_7}),
        .S({1'b0,Q[31:29]}));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT4 #(
    .INIT(16'h0070)) 
    \event_age[0]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(Q[0]),
        .O(\event_age[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[10]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__1_n_6),
        .O(\event_age[10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[11]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__1_n_5),
        .O(\event_age[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[12]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__1_n_4),
        .O(\event_age[12]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[13]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__2_n_7),
        .O(\event_age[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[14]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__2_n_6),
        .O(\event_age[14]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[15]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__2_n_5),
        .O(\event_age[15]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[16]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__2_n_4),
        .O(\event_age[16]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[17]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__3_n_7),
        .O(\event_age[17]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[18]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__3_n_6),
        .O(\event_age[18]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[19]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__3_n_5),
        .O(\event_age[19]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[1]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry_n_7),
        .O(\event_age[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[20]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__3_n_4),
        .O(\event_age[20]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[21]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__4_n_7),
        .O(\event_age[21]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[22]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__4_n_6),
        .O(\event_age[22]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[23]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__4_n_5),
        .O(\event_age[23]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[24]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__4_n_4),
        .O(\event_age[24]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[25]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__5_n_7),
        .O(\event_age[25]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[26]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__5_n_6),
        .O(\event_age[26]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[27]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__5_n_5),
        .O(\event_age[27]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[28]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__5_n_4),
        .O(\event_age[28]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[29]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__6_n_7),
        .O(\event_age[29]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[2]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry_n_6),
        .O(\event_age[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[30]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__6_n_6),
        .O(\event_age[30]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \event_age[31]_i_1 
       (.I0(\event_age[31]_i_3_n_0 ),
        .I1(\faults_reg[7]_0 [0]),
        .I2(\faults_reg[7]_0 [3]),
        .I3(\faults_reg[7]_0 [1]),
        .I4(\faults_reg[7]_0 [2]),
        .O(\event_age[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[31]_i_2 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__6_n_5),
        .O(\event_age[31]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \event_age[31]_i_3 
       (.I0(\faults_reg[7]_0 [4]),
        .I1(\faults_reg[7]_0 [5]),
        .I2(\faults_reg[7]_0 [6]),
        .I3(\faults_reg[7]_0 [7]),
        .O(\event_age[31]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h00000004)) 
    \event_age[31]_i_4 
       (.I0(\event_age[31]_i_6_n_0 ),
        .I1(filtered_valid),
        .I2(\sample_in_window_reg_n_0_[2] ),
        .I3(\sample_in_window_reg_n_0_[0] ),
        .I4(\sample_in_window_reg_n_0_[1] ),
        .O(\event_age[31]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h5400540054004400)) 
    \event_age[31]_i_5 
       (.I0(status[4]),
        .I1(\event_kind[1]_i_3_n_0 ),
        .I2(\event_age[31]_i_7_n_0 ),
        .I3(\event_age[31]_i_8_n_0 ),
        .I4(candidate_count[1]),
        .I5(candidate_count[2]),
        .O(\event_age[31]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'hFB)) 
    \event_age[31]_i_6 
       (.I0(\sample_in_window[0]_i_2_n_0 ),
        .I1(\sample_in_window_reg_n_0_[9] ),
        .I2(\sample_in_window_reg_n_0_[3] ),
        .O(\event_age[31]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h00000E00)) 
    \event_age[31]_i_7 
       (.I0(\soft_count_reg_n_0_[2] ),
        .I1(\soft_count_reg_n_0_[1] ),
        .I2(above_loud),
        .I3(p_1_in),
        .I4(high_seen_reg_n_0),
        .O(\event_age[31]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \event_age[31]_i_8 
       (.I0(status[3]),
        .I1(status[2]),
        .O(\event_age[31]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[3]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry_n_5),
        .O(\event_age[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[4]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry_n_4),
        .O(\event_age[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[5]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__0_n_7),
        .O(\event_age[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[6]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__0_n_6),
        .O(\event_age[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[7]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__0_n_5),
        .O(\event_age[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[8]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__0_n_4),
        .O(\event_age[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT4 #(
    .INIT(16'h7000)) 
    \event_age[9]_i_1 
       (.I0(\event_age[31]_i_4_n_0 ),
        .I1(\event_age[31]_i_5_n_0 ),
        .I2(status[0]),
        .I3(event_age0_carry__1_n_7),
        .O(\event_age[9]_i_1_n_0 ));
  FDRE \event_age_reg[0] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[0]_i_1_n_0 ),
        .Q(Q[0]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[10] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[10]_i_1_n_0 ),
        .Q(Q[10]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[11] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[11]_i_1_n_0 ),
        .Q(Q[11]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[12] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[12]_i_1_n_0 ),
        .Q(Q[12]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[13] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[13]_i_1_n_0 ),
        .Q(Q[13]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[14] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[14]_i_1_n_0 ),
        .Q(Q[14]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[15] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[15]_i_1_n_0 ),
        .Q(Q[15]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[16] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[16]_i_1_n_0 ),
        .Q(Q[16]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[17] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[17]_i_1_n_0 ),
        .Q(Q[17]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[18] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[18]_i_1_n_0 ),
        .Q(Q[18]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[19] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[19]_i_1_n_0 ),
        .Q(Q[19]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[1] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[1]_i_1_n_0 ),
        .Q(Q[1]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[20] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[20]_i_1_n_0 ),
        .Q(Q[20]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[21] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[21]_i_1_n_0 ),
        .Q(Q[21]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[22] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[22]_i_1_n_0 ),
        .Q(Q[22]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[23] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[23]_i_1_n_0 ),
        .Q(Q[23]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[24] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[24]_i_1_n_0 ),
        .Q(Q[24]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[25] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[25]_i_1_n_0 ),
        .Q(Q[25]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[26] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[26]_i_1_n_0 ),
        .Q(Q[26]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[27] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[27]_i_1_n_0 ),
        .Q(Q[27]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[28] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[28]_i_1_n_0 ),
        .Q(Q[28]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[29] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[29]_i_1_n_0 ),
        .Q(Q[29]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[2] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[2]_i_1_n_0 ),
        .Q(Q[2]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[30] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[30]_i_1_n_0 ),
        .Q(Q[30]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[31] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[31]_i_2_n_0 ),
        .Q(Q[31]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[3] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[3]_i_1_n_0 ),
        .Q(Q[3]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[4] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[4]_i_1_n_0 ),
        .Q(Q[4]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[5] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[5]_i_1_n_0 ),
        .Q(Q[5]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[6] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[6]_i_1_n_0 ),
        .Q(Q[6]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[7] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[7]_i_1_n_0 ),
        .Q(Q[7]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[8] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[8]_i_1_n_0 ),
        .Q(Q[8]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \event_age_reg[9] 
       (.C(s_axi_aclk),
        .CE(\event_age[31]_i_1_n_0 ),
        .D(\event_age[9]_i_1_n_0 ),
        .Q(Q[9]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF80FF00FF00FF00)) 
    \event_epoch[31]_i_1 
       (.I0(filtered_valid),
        .I1(\event_age[31]_i_1_n_0 ),
        .I2(\faults_reg[0]_1 ),
        .I3(configure),
        .I4(\clipped_count[15]_i_4_n_0 ),
        .I5(\event_age[31]_i_5_n_0 ),
        .O(\event_epoch[31]_i_1_n_0 ));
  FDRE \event_epoch_reg[0] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[0]),
        .Q(\event_epoch_reg[31]_0 [0]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[10] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[10]),
        .Q(\event_epoch_reg[31]_0 [10]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[11] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[11]),
        .Q(\event_epoch_reg[31]_0 [11]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[12] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[12]),
        .Q(\event_epoch_reg[31]_0 [12]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[13] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[13]),
        .Q(\event_epoch_reg[31]_0 [13]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[14] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[14]),
        .Q(\event_epoch_reg[31]_0 [14]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[15] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[15]),
        .Q(\event_epoch_reg[31]_0 [15]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[16] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[16]),
        .Q(\event_epoch_reg[31]_0 [16]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[17] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[17]),
        .Q(\event_epoch_reg[31]_0 [17]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[18] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[18]),
        .Q(\event_epoch_reg[31]_0 [18]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[19] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[19]),
        .Q(\event_epoch_reg[31]_0 [19]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[1] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[1]),
        .Q(\event_epoch_reg[31]_0 [1]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[20] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[20]),
        .Q(\event_epoch_reg[31]_0 [20]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[21] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[21]),
        .Q(\event_epoch_reg[31]_0 [21]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[22] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[22]),
        .Q(\event_epoch_reg[31]_0 [22]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[23] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[23]),
        .Q(\event_epoch_reg[31]_0 [23]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[24] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[24]),
        .Q(\event_epoch_reg[31]_0 [24]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[25] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[25]),
        .Q(\event_epoch_reg[31]_0 [25]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[26] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[26]),
        .Q(\event_epoch_reg[31]_0 [26]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[27] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[27]),
        .Q(\event_epoch_reg[31]_0 [27]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[28] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[28]),
        .Q(\event_epoch_reg[31]_0 [28]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[29] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[29]),
        .Q(\event_epoch_reg[31]_0 [29]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[2] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[2]),
        .Q(\event_epoch_reg[31]_0 [2]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[30] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[30]),
        .Q(\event_epoch_reg[31]_0 [30]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[31] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[31]),
        .Q(\event_epoch_reg[31]_0 [31]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[3] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[3]),
        .Q(\event_epoch_reg[31]_0 [3]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[4] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[4]),
        .Q(\event_epoch_reg[31]_0 [4]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[5] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[5]),
        .Q(\event_epoch_reg[31]_0 [5]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[6] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[6]),
        .Q(\event_epoch_reg[31]_0 [6]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[7] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[7]),
        .Q(\event_epoch_reg[31]_0 [7]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[8] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[8]),
        .Q(\event_epoch_reg[31]_0 [8]),
        .R(s_axi_aresetn_0));
  FDRE \event_epoch_reg[9] 
       (.C(s_axi_aclk),
        .CE(\event_epoch[31]_i_1_n_0 ),
        .D(config_epoch_reg[9]),
        .Q(\event_epoch_reg[31]_0 [9]),
        .R(s_axi_aresetn_0));
  LUT6 #(
    .INIT(64'h7F777F7F00000008)) 
    \event_kind[0]_i_1 
       (.I0(\clipped_count[15]_i_2_n_0 ),
        .I1(\clipped_count[15]_i_4_n_0 ),
        .I2(status[4]),
        .I3(\event_kind[1]_i_2_n_0 ),
        .I4(\event_kind[1]_i_3_n_0 ),
        .I5(\event_kind_reg[1]_0 [0]),
        .O(\event_kind[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7F7F7F7700080000)) 
    \event_kind[1]_i_1 
       (.I0(\clipped_count[15]_i_2_n_0 ),
        .I1(\clipped_count[15]_i_4_n_0 ),
        .I2(status[4]),
        .I3(\event_kind[1]_i_2_n_0 ),
        .I4(\event_kind[1]_i_3_n_0 ),
        .I5(\event_kind_reg[1]_0 [1]),
        .O(\event_kind[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF0FFF0FFF1FFFFF)) 
    \event_kind[1]_i_2 
       (.I0(candidate_count[2]),
        .I1(candidate_count[1]),
        .I2(status[3]),
        .I3(status[2]),
        .I4(\event_age[31]_i_7_n_0 ),
        .I5(\event_kind[1]_i_3_n_0 ),
        .O(\event_kind[1]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'hAAA8)) 
    \event_kind[1]_i_3 
       (.I0(above_loud),
        .I1(loud_count[2]),
        .I2(loud_count[0]),
        .I3(loud_count[1]),
        .O(\event_kind[1]_i_3_n_0 ));
  FDRE \event_kind_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\event_kind[0]_i_1_n_0 ),
        .Q(\event_kind_reg[1]_0 [0]),
        .R(\state[1]_i_1_n_0 ));
  FDRE \event_kind_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\event_kind[1]_i_1_n_0 ),
        .Q(\event_kind_reg[1]_0 [1]),
        .R(\state[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000E2E200E2)) 
    event_pending_i_1
       (.I0(status[0]),
        .I1(event_pending_i_2_n_0),
        .I2(event_pending4_out),
        .I3(\event_age[31]_i_1_n_0 ),
        .I4(\faults[7]_i_5_n_0 ),
        .I5(\sample_in_window[9]_i_1_n_0 ),
        .O(event_pending_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'hA8AA8888)) 
    event_pending_i_2
       (.I0(\event_age[31]_i_1_n_0 ),
        .I1(ack_error_i_3_n_0),
        .I2(status[4]),
        .I3(\event_kind[1]_i_2_n_0 ),
        .I4(\event_age[31]_i_4_n_0 ),
        .O(event_pending_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT3 #(
    .INIT(8'h80)) 
    event_pending_i_3
       (.I0(\event_age[31]_i_5_n_0 ),
        .I1(\clipped_count[15]_i_4_n_0 ),
        .I2(filtered_valid),
        .O(event_pending4_out));
  FDRE event_pending_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(event_pending_i_1_n_0),
        .Q(status[0]),
        .R(1'b0));
  LUT1 #(
    .INIT(2'h1)) 
    \event_sample[0]_i_1 
       (.I0(out[0]),
        .O(\event_sample[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0080000000000000)) 
    \event_sample[63]_i_1 
       (.I0(filtered_valid),
        .I1(\event_age[31]_i_1_n_0 ),
        .I2(\faults_reg[0]_1 ),
        .I3(configure),
        .I4(\clipped_count[15]_i_4_n_0 ),
        .I5(\event_age[31]_i_5_n_0 ),
        .O(\event_sample[63]_i_1_n_0 ));
  FDRE \event_sample_reg[0] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample[0]_i_1_n_0 ),
        .Q(\event_sample_reg[63]_0 [0]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[10] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[12]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [10]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[11] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[12]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [11]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[12] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[12]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [12]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[12]_i_1 
       (.CI(\event_sample_reg[8]_i_1_n_0 ),
        .CO({\event_sample_reg[12]_i_1_n_0 ,\event_sample_reg[12]_i_1_n_1 ,\event_sample_reg[12]_i_1_n_2 ,\event_sample_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[12]_i_1_n_4 ,\event_sample_reg[12]_i_1_n_5 ,\event_sample_reg[12]_i_1_n_6 ,\event_sample_reg[12]_i_1_n_7 }),
        .S(out[12:9]));
  FDRE \event_sample_reg[13] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[16]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [13]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[14] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[16]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [14]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[15] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[16]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [15]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[16] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[16]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [16]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[16]_i_1 
       (.CI(\event_sample_reg[12]_i_1_n_0 ),
        .CO({\event_sample_reg[16]_i_1_n_0 ,\event_sample_reg[16]_i_1_n_1 ,\event_sample_reg[16]_i_1_n_2 ,\event_sample_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[16]_i_1_n_4 ,\event_sample_reg[16]_i_1_n_5 ,\event_sample_reg[16]_i_1_n_6 ,\event_sample_reg[16]_i_1_n_7 }),
        .S(out[16:13]));
  FDRE \event_sample_reg[17] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[20]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [17]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[18] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[20]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [18]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[19] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[20]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [19]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[1] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[4]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [1]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[20] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[20]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [20]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[20]_i_1 
       (.CI(\event_sample_reg[16]_i_1_n_0 ),
        .CO({\event_sample_reg[20]_i_1_n_0 ,\event_sample_reg[20]_i_1_n_1 ,\event_sample_reg[20]_i_1_n_2 ,\event_sample_reg[20]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[20]_i_1_n_4 ,\event_sample_reg[20]_i_1_n_5 ,\event_sample_reg[20]_i_1_n_6 ,\event_sample_reg[20]_i_1_n_7 }),
        .S(out[20:17]));
  FDRE \event_sample_reg[21] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[24]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [21]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[22] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[24]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [22]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[23] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[24]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [23]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[24] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[24]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [24]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[24]_i_1 
       (.CI(\event_sample_reg[20]_i_1_n_0 ),
        .CO({\event_sample_reg[24]_i_1_n_0 ,\event_sample_reg[24]_i_1_n_1 ,\event_sample_reg[24]_i_1_n_2 ,\event_sample_reg[24]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[24]_i_1_n_4 ,\event_sample_reg[24]_i_1_n_5 ,\event_sample_reg[24]_i_1_n_6 ,\event_sample_reg[24]_i_1_n_7 }),
        .S(out[24:21]));
  FDRE \event_sample_reg[25] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[28]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [25]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[26] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[28]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [26]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[27] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[28]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [27]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[28] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[28]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [28]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[28]_i_1 
       (.CI(\event_sample_reg[24]_i_1_n_0 ),
        .CO({\event_sample_reg[28]_i_1_n_0 ,\event_sample_reg[28]_i_1_n_1 ,\event_sample_reg[28]_i_1_n_2 ,\event_sample_reg[28]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[28]_i_1_n_4 ,\event_sample_reg[28]_i_1_n_5 ,\event_sample_reg[28]_i_1_n_6 ,\event_sample_reg[28]_i_1_n_7 }),
        .S(out[28:25]));
  FDRE \event_sample_reg[29] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[32]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [29]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[2] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[4]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [2]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[30] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[32]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [30]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[31] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[32]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [31]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[32] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[32]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [32]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[32]_i_1 
       (.CI(\event_sample_reg[28]_i_1_n_0 ),
        .CO({\event_sample_reg[32]_i_1_n_0 ,\event_sample_reg[32]_i_1_n_1 ,\event_sample_reg[32]_i_1_n_2 ,\event_sample_reg[32]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[32]_i_1_n_4 ,\event_sample_reg[32]_i_1_n_5 ,\event_sample_reg[32]_i_1_n_6 ,\event_sample_reg[32]_i_1_n_7 }),
        .S(out[32:29]));
  FDRE \event_sample_reg[33] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[36]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [33]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[34] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[36]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [34]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[35] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[36]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [35]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[36] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[36]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [36]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[36]_i_1 
       (.CI(\event_sample_reg[32]_i_1_n_0 ),
        .CO({\event_sample_reg[36]_i_1_n_0 ,\event_sample_reg[36]_i_1_n_1 ,\event_sample_reg[36]_i_1_n_2 ,\event_sample_reg[36]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[36]_i_1_n_4 ,\event_sample_reg[36]_i_1_n_5 ,\event_sample_reg[36]_i_1_n_6 ,\event_sample_reg[36]_i_1_n_7 }),
        .S(out[36:33]));
  FDRE \event_sample_reg[37] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[40]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [37]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[38] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[40]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [38]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[39] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[40]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [39]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[3] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[4]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [3]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[40] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[40]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [40]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[40]_i_1 
       (.CI(\event_sample_reg[36]_i_1_n_0 ),
        .CO({\event_sample_reg[40]_i_1_n_0 ,\event_sample_reg[40]_i_1_n_1 ,\event_sample_reg[40]_i_1_n_2 ,\event_sample_reg[40]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[40]_i_1_n_4 ,\event_sample_reg[40]_i_1_n_5 ,\event_sample_reg[40]_i_1_n_6 ,\event_sample_reg[40]_i_1_n_7 }),
        .S(out[40:37]));
  FDRE \event_sample_reg[41] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[44]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [41]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[42] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[44]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [42]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[43] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[44]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [43]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[44] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[44]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [44]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[44]_i_1 
       (.CI(\event_sample_reg[40]_i_1_n_0 ),
        .CO({\event_sample_reg[44]_i_1_n_0 ,\event_sample_reg[44]_i_1_n_1 ,\event_sample_reg[44]_i_1_n_2 ,\event_sample_reg[44]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[44]_i_1_n_4 ,\event_sample_reg[44]_i_1_n_5 ,\event_sample_reg[44]_i_1_n_6 ,\event_sample_reg[44]_i_1_n_7 }),
        .S(out[44:41]));
  FDRE \event_sample_reg[45] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[48]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [45]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[46] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[48]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [46]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[47] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[48]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [47]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[48] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[48]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [48]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[48]_i_1 
       (.CI(\event_sample_reg[44]_i_1_n_0 ),
        .CO({\event_sample_reg[48]_i_1_n_0 ,\event_sample_reg[48]_i_1_n_1 ,\event_sample_reg[48]_i_1_n_2 ,\event_sample_reg[48]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[48]_i_1_n_4 ,\event_sample_reg[48]_i_1_n_5 ,\event_sample_reg[48]_i_1_n_6 ,\event_sample_reg[48]_i_1_n_7 }),
        .S(out[48:45]));
  FDRE \event_sample_reg[49] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[52]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [49]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[4] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[4]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [4]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[4]_i_1 
       (.CI(1'b0),
        .CO({\event_sample_reg[4]_i_1_n_0 ,\event_sample_reg[4]_i_1_n_1 ,\event_sample_reg[4]_i_1_n_2 ,\event_sample_reg[4]_i_1_n_3 }),
        .CYINIT(out[0]),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[4]_i_1_n_4 ,\event_sample_reg[4]_i_1_n_5 ,\event_sample_reg[4]_i_1_n_6 ,\event_sample_reg[4]_i_1_n_7 }),
        .S(out[4:1]));
  FDRE \event_sample_reg[50] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[52]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [50]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[51] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[52]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [51]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[52] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[52]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [52]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[52]_i_1 
       (.CI(\event_sample_reg[48]_i_1_n_0 ),
        .CO({\event_sample_reg[52]_i_1_n_0 ,\event_sample_reg[52]_i_1_n_1 ,\event_sample_reg[52]_i_1_n_2 ,\event_sample_reg[52]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[52]_i_1_n_4 ,\event_sample_reg[52]_i_1_n_5 ,\event_sample_reg[52]_i_1_n_6 ,\event_sample_reg[52]_i_1_n_7 }),
        .S(out[52:49]));
  FDRE \event_sample_reg[53] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[56]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [53]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[54] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[56]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [54]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[55] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[56]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [55]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[56] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[56]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [56]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[56]_i_1 
       (.CI(\event_sample_reg[52]_i_1_n_0 ),
        .CO({\event_sample_reg[56]_i_1_n_0 ,\event_sample_reg[56]_i_1_n_1 ,\event_sample_reg[56]_i_1_n_2 ,\event_sample_reg[56]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[56]_i_1_n_4 ,\event_sample_reg[56]_i_1_n_5 ,\event_sample_reg[56]_i_1_n_6 ,\event_sample_reg[56]_i_1_n_7 }),
        .S(out[56:53]));
  FDRE \event_sample_reg[57] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[60]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [57]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[58] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[60]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [58]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[59] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[60]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [59]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[5] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[8]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [5]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[60] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[60]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [60]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[60]_i_1 
       (.CI(\event_sample_reg[56]_i_1_n_0 ),
        .CO({\event_sample_reg[60]_i_1_n_0 ,\event_sample_reg[60]_i_1_n_1 ,\event_sample_reg[60]_i_1_n_2 ,\event_sample_reg[60]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[60]_i_1_n_4 ,\event_sample_reg[60]_i_1_n_5 ,\event_sample_reg[60]_i_1_n_6 ,\event_sample_reg[60]_i_1_n_7 }),
        .S(out[60:57]));
  FDRE \event_sample_reg[61] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[63]_i_2_n_7 ),
        .Q(\event_sample_reg[63]_0 [61]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[62] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[63]_i_2_n_6 ),
        .Q(\event_sample_reg[63]_0 [62]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[63] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[63]_i_2_n_5 ),
        .Q(\event_sample_reg[63]_0 [63]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[63]_i_2 
       (.CI(\event_sample_reg[60]_i_1_n_0 ),
        .CO({\NLW_event_sample_reg[63]_i_2_CO_UNCONNECTED [3:2],\event_sample_reg[63]_i_2_n_2 ,\event_sample_reg[63]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_event_sample_reg[63]_i_2_O_UNCONNECTED [3],\event_sample_reg[63]_i_2_n_5 ,\event_sample_reg[63]_i_2_n_6 ,\event_sample_reg[63]_i_2_n_7 }),
        .S({1'b0,out[63:61]}));
  FDRE \event_sample_reg[6] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[8]_i_1_n_6 ),
        .Q(\event_sample_reg[63]_0 [6]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[7] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[8]_i_1_n_5 ),
        .Q(\event_sample_reg[63]_0 [7]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sample_reg[8] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[8]_i_1_n_4 ),
        .Q(\event_sample_reg[63]_0 [8]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sample_reg[8]_i_1 
       (.CI(\event_sample_reg[4]_i_1_n_0 ),
        .CO({\event_sample_reg[8]_i_1_n_0 ,\event_sample_reg[8]_i_1_n_1 ,\event_sample_reg[8]_i_1_n_2 ,\event_sample_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sample_reg[8]_i_1_n_4 ,\event_sample_reg[8]_i_1_n_5 ,\event_sample_reg[8]_i_1_n_6 ,\event_sample_reg[8]_i_1_n_7 }),
        .S(out[8:5]));
  FDRE \event_sample_reg[9] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sample_reg[12]_i_1_n_7 ),
        .Q(\event_sample_reg[63]_0 [9]),
        .R(\last_sum[31]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \event_sequence[0]_i_2 
       (.I0(\event_sequence_reg[31]_0 [0]),
        .O(\event_sequence[0]_i_2_n_0 ));
  FDRE \event_sequence_reg[0] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[0]_i_1_n_7 ),
        .Q(\event_sequence_reg[31]_0 [0]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sequence_reg[0]_i_1 
       (.CI(1'b0),
        .CO({\event_sequence_reg[0]_i_1_n_0 ,\event_sequence_reg[0]_i_1_n_1 ,\event_sequence_reg[0]_i_1_n_2 ,\event_sequence_reg[0]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\event_sequence_reg[0]_i_1_n_4 ,\event_sequence_reg[0]_i_1_n_5 ,\event_sequence_reg[0]_i_1_n_6 ,\event_sequence_reg[0]_i_1_n_7 }),
        .S({\event_sequence_reg[31]_0 [3:1],\event_sequence[0]_i_2_n_0 }));
  FDRE \event_sequence_reg[10] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[8]_i_1_n_5 ),
        .Q(\event_sequence_reg[31]_0 [10]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[11] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[8]_i_1_n_4 ),
        .Q(\event_sequence_reg[31]_0 [11]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[12] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[12]_i_1_n_7 ),
        .Q(\event_sequence_reg[31]_0 [12]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sequence_reg[12]_i_1 
       (.CI(\event_sequence_reg[8]_i_1_n_0 ),
        .CO({\event_sequence_reg[12]_i_1_n_0 ,\event_sequence_reg[12]_i_1_n_1 ,\event_sequence_reg[12]_i_1_n_2 ,\event_sequence_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sequence_reg[12]_i_1_n_4 ,\event_sequence_reg[12]_i_1_n_5 ,\event_sequence_reg[12]_i_1_n_6 ,\event_sequence_reg[12]_i_1_n_7 }),
        .S(\event_sequence_reg[31]_0 [15:12]));
  FDRE \event_sequence_reg[13] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[12]_i_1_n_6 ),
        .Q(\event_sequence_reg[31]_0 [13]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[14] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[12]_i_1_n_5 ),
        .Q(\event_sequence_reg[31]_0 [14]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[15] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[12]_i_1_n_4 ),
        .Q(\event_sequence_reg[31]_0 [15]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[16] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[16]_i_1_n_7 ),
        .Q(\event_sequence_reg[31]_0 [16]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sequence_reg[16]_i_1 
       (.CI(\event_sequence_reg[12]_i_1_n_0 ),
        .CO({\event_sequence_reg[16]_i_1_n_0 ,\event_sequence_reg[16]_i_1_n_1 ,\event_sequence_reg[16]_i_1_n_2 ,\event_sequence_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sequence_reg[16]_i_1_n_4 ,\event_sequence_reg[16]_i_1_n_5 ,\event_sequence_reg[16]_i_1_n_6 ,\event_sequence_reg[16]_i_1_n_7 }),
        .S(\event_sequence_reg[31]_0 [19:16]));
  FDRE \event_sequence_reg[17] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[16]_i_1_n_6 ),
        .Q(\event_sequence_reg[31]_0 [17]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[18] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[16]_i_1_n_5 ),
        .Q(\event_sequence_reg[31]_0 [18]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[19] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[16]_i_1_n_4 ),
        .Q(\event_sequence_reg[31]_0 [19]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[1] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[0]_i_1_n_6 ),
        .Q(\event_sequence_reg[31]_0 [1]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[20] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[20]_i_1_n_7 ),
        .Q(\event_sequence_reg[31]_0 [20]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sequence_reg[20]_i_1 
       (.CI(\event_sequence_reg[16]_i_1_n_0 ),
        .CO({\event_sequence_reg[20]_i_1_n_0 ,\event_sequence_reg[20]_i_1_n_1 ,\event_sequence_reg[20]_i_1_n_2 ,\event_sequence_reg[20]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sequence_reg[20]_i_1_n_4 ,\event_sequence_reg[20]_i_1_n_5 ,\event_sequence_reg[20]_i_1_n_6 ,\event_sequence_reg[20]_i_1_n_7 }),
        .S(\event_sequence_reg[31]_0 [23:20]));
  FDRE \event_sequence_reg[21] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[20]_i_1_n_6 ),
        .Q(\event_sequence_reg[31]_0 [21]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[22] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[20]_i_1_n_5 ),
        .Q(\event_sequence_reg[31]_0 [22]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[23] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[20]_i_1_n_4 ),
        .Q(\event_sequence_reg[31]_0 [23]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[24] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[24]_i_1_n_7 ),
        .Q(\event_sequence_reg[31]_0 [24]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sequence_reg[24]_i_1 
       (.CI(\event_sequence_reg[20]_i_1_n_0 ),
        .CO({\event_sequence_reg[24]_i_1_n_0 ,\event_sequence_reg[24]_i_1_n_1 ,\event_sequence_reg[24]_i_1_n_2 ,\event_sequence_reg[24]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sequence_reg[24]_i_1_n_4 ,\event_sequence_reg[24]_i_1_n_5 ,\event_sequence_reg[24]_i_1_n_6 ,\event_sequence_reg[24]_i_1_n_7 }),
        .S(\event_sequence_reg[31]_0 [27:24]));
  FDRE \event_sequence_reg[25] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[24]_i_1_n_6 ),
        .Q(\event_sequence_reg[31]_0 [25]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[26] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[24]_i_1_n_5 ),
        .Q(\event_sequence_reg[31]_0 [26]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[27] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[24]_i_1_n_4 ),
        .Q(\event_sequence_reg[31]_0 [27]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[28] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[28]_i_1_n_7 ),
        .Q(\event_sequence_reg[31]_0 [28]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sequence_reg[28]_i_1 
       (.CI(\event_sequence_reg[24]_i_1_n_0 ),
        .CO({\NLW_event_sequence_reg[28]_i_1_CO_UNCONNECTED [3],\event_sequence_reg[28]_i_1_n_1 ,\event_sequence_reg[28]_i_1_n_2 ,\event_sequence_reg[28]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sequence_reg[28]_i_1_n_4 ,\event_sequence_reg[28]_i_1_n_5 ,\event_sequence_reg[28]_i_1_n_6 ,\event_sequence_reg[28]_i_1_n_7 }),
        .S(\event_sequence_reg[31]_0 [31:28]));
  FDRE \event_sequence_reg[29] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[28]_i_1_n_6 ),
        .Q(\event_sequence_reg[31]_0 [29]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[2] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[0]_i_1_n_5 ),
        .Q(\event_sequence_reg[31]_0 [2]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[30] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[28]_i_1_n_5 ),
        .Q(\event_sequence_reg[31]_0 [30]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[31] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[28]_i_1_n_4 ),
        .Q(\event_sequence_reg[31]_0 [31]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[3] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[0]_i_1_n_4 ),
        .Q(\event_sequence_reg[31]_0 [3]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[4] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[4]_i_1_n_7 ),
        .Q(\event_sequence_reg[31]_0 [4]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sequence_reg[4]_i_1 
       (.CI(\event_sequence_reg[0]_i_1_n_0 ),
        .CO({\event_sequence_reg[4]_i_1_n_0 ,\event_sequence_reg[4]_i_1_n_1 ,\event_sequence_reg[4]_i_1_n_2 ,\event_sequence_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sequence_reg[4]_i_1_n_4 ,\event_sequence_reg[4]_i_1_n_5 ,\event_sequence_reg[4]_i_1_n_6 ,\event_sequence_reg[4]_i_1_n_7 }),
        .S(\event_sequence_reg[31]_0 [7:4]));
  FDRE \event_sequence_reg[5] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[4]_i_1_n_6 ),
        .Q(\event_sequence_reg[31]_0 [5]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[6] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[4]_i_1_n_5 ),
        .Q(\event_sequence_reg[31]_0 [6]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[7] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[4]_i_1_n_4 ),
        .Q(\event_sequence_reg[31]_0 [7]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_sequence_reg[8] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[8]_i_1_n_7 ),
        .Q(\event_sequence_reg[31]_0 [8]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_sequence_reg[8]_i_1 
       (.CI(\event_sequence_reg[4]_i_1_n_0 ),
        .CO({\event_sequence_reg[8]_i_1_n_0 ,\event_sequence_reg[8]_i_1_n_1 ,\event_sequence_reg[8]_i_1_n_2 ,\event_sequence_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_sequence_reg[8]_i_1_n_4 ,\event_sequence_reg[8]_i_1_n_5 ,\event_sequence_reg[8]_i_1_n_6 ,\event_sequence_reg[8]_i_1_n_7 }),
        .S(\event_sequence_reg[31]_0 [11:8]));
  FDRE \event_sequence_reg[9] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_sequence_reg[8]_i_1_n_6 ),
        .Q(\event_sequence_reg[31]_0 [9]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \event_window[0]_i_1 
       (.I0(\window_count_reg[31]_0 [0]),
        .O(\event_window[0]_i_1_n_0 ));
  FDRE \event_window_reg[0] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window[0]_i_1_n_0 ),
        .Q(\event_window_reg[31]_0 [0]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[10] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[12]_i_1_n_6 ),
        .Q(\event_window_reg[31]_0 [10]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[11] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[12]_i_1_n_5 ),
        .Q(\event_window_reg[31]_0 [11]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[12] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[12]_i_1_n_4 ),
        .Q(\event_window_reg[31]_0 [12]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_window_reg[12]_i_1 
       (.CI(\event_window_reg[8]_i_1_n_0 ),
        .CO({\event_window_reg[12]_i_1_n_0 ,\event_window_reg[12]_i_1_n_1 ,\event_window_reg[12]_i_1_n_2 ,\event_window_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_window_reg[12]_i_1_n_4 ,\event_window_reg[12]_i_1_n_5 ,\event_window_reg[12]_i_1_n_6 ,\event_window_reg[12]_i_1_n_7 }),
        .S(\window_count_reg[31]_0 [12:9]));
  FDRE \event_window_reg[13] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[16]_i_1_n_7 ),
        .Q(\event_window_reg[31]_0 [13]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[14] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[16]_i_1_n_6 ),
        .Q(\event_window_reg[31]_0 [14]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[15] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[16]_i_1_n_5 ),
        .Q(\event_window_reg[31]_0 [15]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[16] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[16]_i_1_n_4 ),
        .Q(\event_window_reg[31]_0 [16]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_window_reg[16]_i_1 
       (.CI(\event_window_reg[12]_i_1_n_0 ),
        .CO({\event_window_reg[16]_i_1_n_0 ,\event_window_reg[16]_i_1_n_1 ,\event_window_reg[16]_i_1_n_2 ,\event_window_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_window_reg[16]_i_1_n_4 ,\event_window_reg[16]_i_1_n_5 ,\event_window_reg[16]_i_1_n_6 ,\event_window_reg[16]_i_1_n_7 }),
        .S(\window_count_reg[31]_0 [16:13]));
  FDRE \event_window_reg[17] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[20]_i_1_n_7 ),
        .Q(\event_window_reg[31]_0 [17]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[18] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[20]_i_1_n_6 ),
        .Q(\event_window_reg[31]_0 [18]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[19] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[20]_i_1_n_5 ),
        .Q(\event_window_reg[31]_0 [19]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[1] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[4]_i_1_n_7 ),
        .Q(\event_window_reg[31]_0 [1]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[20] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[20]_i_1_n_4 ),
        .Q(\event_window_reg[31]_0 [20]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_window_reg[20]_i_1 
       (.CI(\event_window_reg[16]_i_1_n_0 ),
        .CO({\event_window_reg[20]_i_1_n_0 ,\event_window_reg[20]_i_1_n_1 ,\event_window_reg[20]_i_1_n_2 ,\event_window_reg[20]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_window_reg[20]_i_1_n_4 ,\event_window_reg[20]_i_1_n_5 ,\event_window_reg[20]_i_1_n_6 ,\event_window_reg[20]_i_1_n_7 }),
        .S(\window_count_reg[31]_0 [20:17]));
  FDRE \event_window_reg[21] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[24]_i_1_n_7 ),
        .Q(\event_window_reg[31]_0 [21]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[22] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[24]_i_1_n_6 ),
        .Q(\event_window_reg[31]_0 [22]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[23] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[24]_i_1_n_5 ),
        .Q(\event_window_reg[31]_0 [23]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[24] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[24]_i_1_n_4 ),
        .Q(\event_window_reg[31]_0 [24]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_window_reg[24]_i_1 
       (.CI(\event_window_reg[20]_i_1_n_0 ),
        .CO({\event_window_reg[24]_i_1_n_0 ,\event_window_reg[24]_i_1_n_1 ,\event_window_reg[24]_i_1_n_2 ,\event_window_reg[24]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_window_reg[24]_i_1_n_4 ,\event_window_reg[24]_i_1_n_5 ,\event_window_reg[24]_i_1_n_6 ,\event_window_reg[24]_i_1_n_7 }),
        .S(\window_count_reg[31]_0 [24:21]));
  FDRE \event_window_reg[25] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[28]_i_1_n_7 ),
        .Q(\event_window_reg[31]_0 [25]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[26] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[28]_i_1_n_6 ),
        .Q(\event_window_reg[31]_0 [26]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[27] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[28]_i_1_n_5 ),
        .Q(\event_window_reg[31]_0 [27]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[28] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[28]_i_1_n_4 ),
        .Q(\event_window_reg[31]_0 [28]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_window_reg[28]_i_1 
       (.CI(\event_window_reg[24]_i_1_n_0 ),
        .CO({\event_window_reg[28]_i_1_n_0 ,\event_window_reg[28]_i_1_n_1 ,\event_window_reg[28]_i_1_n_2 ,\event_window_reg[28]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_window_reg[28]_i_1_n_4 ,\event_window_reg[28]_i_1_n_5 ,\event_window_reg[28]_i_1_n_6 ,\event_window_reg[28]_i_1_n_7 }),
        .S(\window_count_reg[31]_0 [28:25]));
  FDRE \event_window_reg[29] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[31]_i_1_n_7 ),
        .Q(\event_window_reg[31]_0 [29]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[2] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[4]_i_1_n_6 ),
        .Q(\event_window_reg[31]_0 [2]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[30] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[31]_i_1_n_6 ),
        .Q(\event_window_reg[31]_0 [30]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[31] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[31]_i_1_n_5 ),
        .Q(\event_window_reg[31]_0 [31]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_window_reg[31]_i_1 
       (.CI(\event_window_reg[28]_i_1_n_0 ),
        .CO({\NLW_event_window_reg[31]_i_1_CO_UNCONNECTED [3:2],\event_window_reg[31]_i_1_n_2 ,\event_window_reg[31]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_event_window_reg[31]_i_1_O_UNCONNECTED [3],\event_window_reg[31]_i_1_n_5 ,\event_window_reg[31]_i_1_n_6 ,\event_window_reg[31]_i_1_n_7 }),
        .S({1'b0,\window_count_reg[31]_0 [31:29]}));
  FDRE \event_window_reg[3] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[4]_i_1_n_5 ),
        .Q(\event_window_reg[31]_0 [3]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[4] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[4]_i_1_n_4 ),
        .Q(\event_window_reg[31]_0 [4]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_window_reg[4]_i_1 
       (.CI(1'b0),
        .CO({\event_window_reg[4]_i_1_n_0 ,\event_window_reg[4]_i_1_n_1 ,\event_window_reg[4]_i_1_n_2 ,\event_window_reg[4]_i_1_n_3 }),
        .CYINIT(\window_count_reg[31]_0 [0]),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_window_reg[4]_i_1_n_4 ,\event_window_reg[4]_i_1_n_5 ,\event_window_reg[4]_i_1_n_6 ,\event_window_reg[4]_i_1_n_7 }),
        .S(\window_count_reg[31]_0 [4:1]));
  FDRE \event_window_reg[5] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[8]_i_1_n_7 ),
        .Q(\event_window_reg[31]_0 [5]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[6] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[8]_i_1_n_6 ),
        .Q(\event_window_reg[31]_0 [6]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[7] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[8]_i_1_n_5 ),
        .Q(\event_window_reg[31]_0 [7]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \event_window_reg[8] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[8]_i_1_n_4 ),
        .Q(\event_window_reg[31]_0 [8]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \event_window_reg[8]_i_1 
       (.CI(\event_window_reg[4]_i_1_n_0 ),
        .CO({\event_window_reg[8]_i_1_n_0 ,\event_window_reg[8]_i_1_n_1 ,\event_window_reg[8]_i_1_n_2 ,\event_window_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\event_window_reg[8]_i_1_n_4 ,\event_window_reg[8]_i_1_n_5 ,\event_window_reg[8]_i_1_n_6 ,\event_window_reg[8]_i_1_n_7 }),
        .S(\window_count_reg[31]_0 [8:5]));
  FDRE \event_window_reg[9] 
       (.C(s_axi_aclk),
        .CE(\event_sample[63]_i_1_n_0 ),
        .D(\event_window_reg[12]_i_1_n_7 ),
        .Q(\event_window_reg[31]_0 [9]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \faults[0]_i_1 
       (.I0(configure),
        .I1(\faults_reg[0]_1 ),
        .O(\faults[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hD0FFD0D0D0D0D0D0)) 
    \faults[1]_i_1 
       (.I0(\faults_reg[0]_1 ),
        .I1(configure),
        .I2(\faults_reg[7]_0 [1]),
        .I3(\faults[6]_i_4_n_0 ),
        .I4(\faults[1]_i_2_n_0 ),
        .I5(\faults[4]_i_2_n_0 ),
        .O(\faults[1]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h45)) 
    \faults[1]_i_2 
       (.I0(pcm_valid),
        .I1(\sample_age[0]_i_3_n_0 ),
        .I2(\faults[1]_i_3_n_0 ),
        .O(\faults[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hBFFFFFFFFFFFFFFF)) 
    \faults[1]_i_3 
       (.I0(\faults[1]_i_4_n_0 ),
        .I1(sample_age_reg[9]),
        .I2(sample_age_reg[0]),
        .I3(sample_age_reg[14]),
        .I4(sample_age_reg[2]),
        .I5(\sample_age[0]_i_4_n_0 ),
        .O(\faults[1]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \faults[1]_i_4 
       (.I0(sample_age_reg[3]),
        .I1(sample_age_reg[4]),
        .I2(sample_age_reg[1]),
        .I3(sample_age_reg[5]),
        .O(\faults[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hD0D0D0D0D0FFD0D0)) 
    \faults[2]_i_1 
       (.I0(\faults_reg[0]_1 ),
        .I1(configure),
        .I2(\faults_reg[7]_0 [2]),
        .I3(p_0_in),
        .I4(\faults[2]_i_2_n_0 ),
        .I5(\faults[6]_i_5_n_0 ),
        .O(\faults[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \faults[2]_i_2 
       (.I0(\faults[6]_i_10_n_0 ),
        .I1(\faults[6]_i_9_n_0 ),
        .I2(\faults[6]_i_8_n_0 ),
        .I3(next_clipped[12]),
        .I4(next_clipped[10]),
        .I5(next_clipped[11]),
        .O(\faults[2]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'hD0FFD0D0)) 
    \faults[3]_i_1 
       (.I0(\faults_reg[0]_1 ),
        .I1(configure),
        .I2(\faults_reg[7]_0 [3]),
        .I3(\faults[6]_i_5_n_0 ),
        .I4(p_0_in),
        .O(\faults[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'hD0D0D0FF)) 
    \faults[4]_i_1 
       (.I0(\faults_reg[0]_1 ),
        .I1(configure),
        .I2(\faults_reg[7]_0 [4]),
        .I3(\faults[6]_i_4_n_0 ),
        .I4(\faults[4]_i_2_n_0 ),
        .O(\faults[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAAAAABBBAFFFF)) 
    \faults[4]_i_2 
       (.I0(\faults[5]_i_11_n_0 ),
        .I1(\faults[5]_i_10_n_0 ),
        .I2(\faults[4]_i_3_n_0 ),
        .I3(\faults[4]_i_4_n_0 ),
        .I4(Q[23]),
        .I5(\faults[5]_i_8_n_0 ),
        .O(\faults[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h000000000111FFFF)) 
    \faults[4]_i_3 
       (.I0(Q[13]),
        .I1(Q[14]),
        .I2(\faults[4]_i_5_n_0 ),
        .I3(Q[12]),
        .I4(Q[15]),
        .I5(\faults[5]_i_17_n_0 ),
        .O(\faults[4]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h7)) 
    \faults[4]_i_4 
       (.I0(Q[20]),
        .I1(Q[19]),
        .O(\faults[4]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hBBBBBBBBBBBBABAA)) 
    \faults[4]_i_5 
       (.I0(Q[11]),
        .I1(\faults[5]_i_22_n_0 ),
        .I2(\faults[5]_i_21_n_0 ),
        .I3(\faults[5]_i_20_n_0 ),
        .I4(Q[7]),
        .I5(Q[8]),
        .O(\faults[4]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hD0D0D0FFD0D0D0D0)) 
    \faults[5]_i_1 
       (.I0(\faults_reg[0]_1 ),
        .I1(configure),
        .I2(\faults_reg[7]_0 [5]),
        .I3(\faults[6]_i_4_n_0 ),
        .I4(\faults[5]_i_2_n_0 ),
        .I5(\faults[5]_i_3_n_0 ),
        .O(\faults[5]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \faults[5]_i_10 
       (.I0(Q[22]),
        .I1(Q[21]),
        .O(\faults[5]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT4 #(
    .INIT(16'h80FF)) 
    \faults[5]_i_11 
       (.I0(matching_ack1),
        .I1(matching_ack0),
        .I2(ack_error_reg_0),
        .I3(status[0]),
        .O(\faults[5]_i_11_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \faults[5]_i_12 
       (.I0(\window_count_reg[31]_0 [18]),
        .I1(\window_count_reg[31]_0 [19]),
        .I2(\window_count_reg[31]_0 [16]),
        .I3(\window_count_reg[31]_0 [17]),
        .O(\faults[5]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \faults[5]_i_13 
       (.I0(\window_count_reg[31]_0 [31]),
        .I1(\window_count_reg[31]_0 [30]),
        .I2(\window_count_reg[31]_0 [28]),
        .I3(\window_count_reg[31]_0 [29]),
        .O(\faults[5]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \faults[5]_i_14 
       (.I0(\window_count_reg[31]_0 [14]),
        .I1(\window_count_reg[31]_0 [15]),
        .I2(\window_count_reg[31]_0 [12]),
        .I3(\window_count_reg[31]_0 [13]),
        .O(\faults[5]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \faults[5]_i_15 
       (.I0(\window_count_reg[31]_0 [6]),
        .I1(\window_count_reg[31]_0 [7]),
        .I2(\window_count_reg[31]_0 [4]),
        .I3(\window_count_reg[31]_0 [5]),
        .O(\faults[5]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \faults[5]_i_16 
       (.I0(Q[29]),
        .I1(Q[30]),
        .I2(Q[25]),
        .I3(Q[26]),
        .O(\faults[5]_i_16_n_0 ));
  LUT3 #(
    .INIT(8'hFE)) 
    \faults[5]_i_17 
       (.I0(Q[18]),
        .I1(Q[16]),
        .I2(Q[17]),
        .O(\faults[5]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h55555555FFFF7757)) 
    \faults[5]_i_18 
       (.I0(Q[12]),
        .I1(\faults[5]_i_19_n_0 ),
        .I2(\faults[5]_i_20_n_0 ),
        .I3(\faults[5]_i_21_n_0 ),
        .I4(\faults[5]_i_22_n_0 ),
        .I5(Q[11]),
        .O(\faults[5]_i_18_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \faults[5]_i_19 
       (.I0(Q[8]),
        .I1(Q[7]),
        .O(\faults[5]_i_19_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT5 #(
    .INIT(32'h55555455)) 
    \faults[5]_i_2 
       (.I0(\p_0_out_inferred__3/i__carry__4_n_2 ),
        .I1(\faults[5]_i_4_n_0 ),
        .I2(\faults[5]_i_5_n_0 ),
        .I3(\faults[5]_i_6_n_0 ),
        .I4(\faults[5]_i_7_n_0 ),
        .O(\faults[5]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h80)) 
    \faults[5]_i_20 
       (.I0(Q[5]),
        .I1(Q[1]),
        .I2(Q[3]),
        .O(\faults[5]_i_20_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \faults[5]_i_21 
       (.I0(Q[6]),
        .I1(Q[0]),
        .I2(Q[2]),
        .I3(Q[4]),
        .O(\faults[5]_i_21_n_0 ));
  LUT2 #(
    .INIT(4'h7)) 
    \faults[5]_i_22 
       (.I0(Q[10]),
        .I1(Q[9]),
        .O(\faults[5]_i_22_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFF1151)) 
    \faults[5]_i_3 
       (.I0(\faults[5]_i_8_n_0 ),
        .I1(Q[23]),
        .I2(\faults[5]_i_9_n_0 ),
        .I3(\faults[5]_i_10_n_0 ),
        .I4(\faults[5]_i_11_n_0 ),
        .I5(\faults[1]_i_2_n_0 ),
        .O(\faults[5]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    \faults[5]_i_4 
       (.I0(\window_count_reg[31]_0 [21]),
        .I1(\window_count_reg[31]_0 [20]),
        .I2(\window_count_reg[31]_0 [23]),
        .I3(\window_count_reg[31]_0 [22]),
        .I4(\faults[5]_i_12_n_0 ),
        .O(\faults[5]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    \faults[5]_i_5 
       (.I0(\window_count_reg[31]_0 [25]),
        .I1(\window_count_reg[31]_0 [24]),
        .I2(\window_count_reg[31]_0 [27]),
        .I3(\window_count_reg[31]_0 [26]),
        .I4(\faults[5]_i_13_n_0 ),
        .O(\faults[5]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h00008000)) 
    \faults[5]_i_6 
       (.I0(\window_count_reg[31]_0 [9]),
        .I1(\window_count_reg[31]_0 [8]),
        .I2(\window_count_reg[31]_0 [11]),
        .I3(\window_count_reg[31]_0 [10]),
        .I4(\faults[5]_i_14_n_0 ),
        .O(\faults[5]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    \faults[5]_i_7 
       (.I0(\window_count_reg[31]_0 [0]),
        .I1(\window_count_reg[31]_0 [1]),
        .I2(\window_count_reg[31]_0 [3]),
        .I3(\window_count_reg[31]_0 [2]),
        .I4(\faults[5]_i_15_n_0 ),
        .O(\faults[5]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \faults[5]_i_8 
       (.I0(Q[31]),
        .I1(Q[24]),
        .I2(Q[28]),
        .I3(Q[27]),
        .I4(\faults[5]_i_16_n_0 ),
        .O(\faults[5]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF11111151)) 
    \faults[5]_i_9 
       (.I0(\faults[5]_i_17_n_0 ),
        .I1(Q[15]),
        .I2(\faults[5]_i_18_n_0 ),
        .I3(Q[14]),
        .I4(Q[13]),
        .I5(\faults[4]_i_4_n_0 ),
        .O(\faults[5]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h7400FFFF74007400)) 
    \faults[6]_i_1 
       (.I0(\faults[6]_i_2_n_0 ),
        .I1(\faults[6]_i_3_n_0 ),
        .I2(\faults_reg[7]_0 [6]),
        .I3(\faults[6]_i_4_n_0 ),
        .I4(\faults[6]_i_5_n_0 ),
        .I5(\faults[6]_i_6_n_0 ),
        .O(\faults[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAAAAA8)) 
    \faults[6]_i_10 
       (.I0(next_clipped[5]),
        .I1(next_clipped[3]),
        .I2(next_clipped[2]),
        .I3(next_clipped[4]),
        .I4(next_clipped[0]),
        .I5(next_clipped[1]),
        .O(\faults[6]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hA8)) 
    \faults[6]_i_2 
       (.I0(pcm_valid),
        .I1(dc_valid),
        .I2(filtered_valid),
        .O(\faults[6]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \faults[6]_i_3 
       (.I0(\faults_reg[0]_1 ),
        .I1(configure),
        .O(\faults[6]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFBFBFBBBFFFFFFFF)) 
    \faults[6]_i_4 
       (.I0(input_fault),
        .I1(\faults_reg[1]_0 ),
        .I2(pcm_valid),
        .I3(dc_valid),
        .I4(filtered_valid),
        .I5(\faults[6]_i_3_n_0 ),
        .O(\faults[6]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'hBF)) 
    \faults[6]_i_5 
       (.I0(\faults[6]_i_4_n_0 ),
        .I1(\faults[5]_i_2_n_0 ),
        .I2(\faults[5]_i_3_n_0 ),
        .O(\faults[6]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \faults[6]_i_6 
       (.I0(p_0_in),
        .I1(\faults[6]_i_7_n_0 ),
        .I2(\faults[6]_i_8_n_0 ),
        .I3(\faults[6]_i_9_n_0 ),
        .I4(\faults[6]_i_10_n_0 ),
        .O(\faults[6]_i_6_n_0 ));
  LUT3 #(
    .INIT(8'hFE)) 
    \faults[6]_i_7 
       (.I0(next_clipped[12]),
        .I1(next_clipped[10]),
        .I2(next_clipped[11]),
        .O(\faults[6]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \faults[6]_i_8 
       (.I0(next_clipped[14]),
        .I1(next_clipped[15]),
        .I2(next_clipped[6]),
        .I3(next_clipped[13]),
        .O(\faults[6]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \faults[6]_i_9 
       (.I0(next_clipped[8]),
        .I1(next_clipped[9]),
        .I2(next_clipped[7]),
        .I3(next_clipped__0),
        .O(\faults[6]_i_9_n_0 ));
  LUT3 #(
    .INIT(8'h4F)) 
    \faults[7]_i_1 
       (.I0(\faults[7]_i_4_n_0 ),
        .I1(configure),
        .I2(s_axi_aresetn),
        .O(\faults[7]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \faults[7]_i_10 
       (.I0(\faults[7]_i_10_0 [25]),
        .I1(\faults[7]_i_10_0 [26]),
        .I2(\faults[7]_i_10_0 [24]),
        .I3(\faults[7]_i_10_0 [27]),
        .I4(\faults[7]_i_16_n_0 ),
        .O(\faults[7]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'hFFFFE0FF)) 
    \faults[7]_i_11 
       (.I0(filtered_valid),
        .I1(dc_valid),
        .I2(pcm_valid),
        .I3(\faults_reg[1]_0 ),
        .I4(input_fault),
        .O(\faults[7]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \faults[7]_i_12 
       (.I0(\faults[6]_i_10_n_0 ),
        .I1(\faults[6]_i_9_n_0 ),
        .I2(\faults[6]_i_8_n_0 ),
        .I3(\faults[6]_i_7_n_0 ),
        .I4(p_0_in),
        .I5(\faults[7]_i_17_n_0 ),
        .O(\faults[7]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \faults[7]_i_13 
       (.I0(\faults[7]_i_10_0 [5]),
        .I1(\faults[7]_i_10_0 [4]),
        .I2(\faults[7]_i_10_0 [7]),
        .I3(\faults[7]_i_10_0 [6]),
        .O(\faults[7]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \faults[7]_i_14 
       (.I0(\faults[7]_i_10_0 [13]),
        .I1(\faults[7]_i_10_0 [12]),
        .I2(\faults[7]_i_10_0 [15]),
        .I3(\faults[7]_i_10_0 [14]),
        .O(\faults[7]_i_14_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \faults[7]_i_15 
       (.I0(\faults[7]_i_10_0 [21]),
        .I1(\faults[7]_i_10_0 [20]),
        .I2(\faults[7]_i_10_0 [23]),
        .I3(\faults[7]_i_10_0 [22]),
        .O(\faults[7]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \faults[7]_i_16 
       (.I0(\faults[7]_i_10_0 [30]),
        .I1(\faults[7]_i_10_0 [29]),
        .I2(\faults[7]_i_10_0 [31]),
        .I3(\faults[7]_i_10_0 [28]),
        .O(\faults[7]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'h0004)) 
    \faults[7]_i_17 
       (.I0(\faults[5]_i_7_n_0 ),
        .I1(\faults[5]_i_6_n_0 ),
        .I2(\faults[5]_i_5_n_0 ),
        .I3(\faults[5]_i_4_n_0 ),
        .O(\faults[7]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'hBFBBAAAAAAAAAAAA)) 
    \faults[7]_i_2 
       (.I0(configure),
        .I1(\faults[7]_i_5_n_0 ),
        .I2(\faults[7]_i_6_n_0 ),
        .I3(status[4]),
        .I4(\event_age[31]_i_1_n_0 ),
        .I5(\faults_reg[0]_1 ),
        .O(\faults[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFA8FF0000A800)) 
    \faults[7]_i_3 
       (.I0(pcm_valid),
        .I1(dc_valid),
        .I2(filtered_valid),
        .I3(\faults_reg[0]_1 ),
        .I4(configure),
        .I5(\faults_reg[7]_0 [7]),
        .O(\faults[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF0010)) 
    \faults[7]_i_4 
       (.I0(\faults[7]_i_7_n_0 ),
        .I1(\faults[7]_i_8_n_0 ),
        .I2(\faults[7]_i_9_n_0 ),
        .I3(\faults[7]_i_10_n_0 ),
        .I4(state20_in),
        .I5(state3),
        .O(\faults[7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0222020202220222)) 
    \faults[7]_i_5 
       (.I0(\faults[5]_i_3_n_0 ),
        .I1(\faults[7]_i_11_n_0 ),
        .I2(filtered_valid),
        .I3(\p_0_out_inferred__3/i__carry__4_n_2 ),
        .I4(\faults[7]_i_12_n_0 ),
        .I5(\clipped_count[15]_i_4_n_0 ),
        .O(\faults[7]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \faults[7]_i_6 
       (.I0(filtered_valid),
        .I1(\clipped_count[15]_i_4_n_0 ),
        .O(\faults[7]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \faults[7]_i_7 
       (.I0(\faults[7]_i_10_0 [0]),
        .I1(\faults[7]_i_10_0 [3]),
        .I2(\faults[7]_i_10_0 [1]),
        .I3(\faults[7]_i_10_0 [2]),
        .I4(\faults[7]_i_13_n_0 ),
        .O(\faults[7]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \faults[7]_i_8 
       (.I0(\faults[7]_i_10_0 [8]),
        .I1(\faults[7]_i_10_0 [11]),
        .I2(\faults[7]_i_10_0 [9]),
        .I3(\faults[7]_i_10_0 [10]),
        .I4(\faults[7]_i_14_n_0 ),
        .O(\faults[7]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \faults[7]_i_9 
       (.I0(\faults[7]_i_10_0 [18]),
        .I1(\faults[7]_i_10_0 [19]),
        .I2(\faults[7]_i_10_0 [16]),
        .I3(\faults[7]_i_10_0 [17]),
        .I4(\faults[7]_i_15_n_0 ),
        .O(\faults[7]_i_9_n_0 ));
  FDRE \faults_reg[0] 
       (.C(s_axi_aclk),
        .CE(\faults[7]_i_2_n_0 ),
        .D(\faults[0]_i_1_n_0 ),
        .Q(\faults_reg[7]_0 [0]),
        .R(\faults[7]_i_1_n_0 ));
  FDRE \faults_reg[1] 
       (.C(s_axi_aclk),
        .CE(\faults[7]_i_2_n_0 ),
        .D(\faults[1]_i_1_n_0 ),
        .Q(\faults_reg[7]_0 [1]),
        .R(\faults[7]_i_1_n_0 ));
  FDRE \faults_reg[2] 
       (.C(s_axi_aclk),
        .CE(\faults[7]_i_2_n_0 ),
        .D(\faults[2]_i_1_n_0 ),
        .Q(\faults_reg[7]_0 [2]),
        .R(\faults[7]_i_1_n_0 ));
  FDRE \faults_reg[3] 
       (.C(s_axi_aclk),
        .CE(\faults[7]_i_2_n_0 ),
        .D(\faults[3]_i_1_n_0 ),
        .Q(\faults_reg[7]_0 [3]),
        .R(\faults[7]_i_1_n_0 ));
  FDRE \faults_reg[4] 
       (.C(s_axi_aclk),
        .CE(\faults[7]_i_2_n_0 ),
        .D(\faults[4]_i_1_n_0 ),
        .Q(\faults_reg[7]_0 [4]),
        .R(\faults[7]_i_1_n_0 ));
  FDRE \faults_reg[5] 
       (.C(s_axi_aclk),
        .CE(\faults[7]_i_2_n_0 ),
        .D(\faults[5]_i_1_n_0 ),
        .Q(\faults_reg[7]_0 [5]),
        .R(\faults[7]_i_1_n_0 ));
  FDRE \faults_reg[6] 
       (.C(s_axi_aclk),
        .CE(\faults[7]_i_2_n_0 ),
        .D(\faults[6]_i_1_n_0 ),
        .Q(\faults_reg[7]_0 [6]),
        .R(\faults[7]_i_1_n_0 ));
  CARRY4 \faults_reg[6]_i_11 
       (.CI(\clipped_count_reg[15]_i_3_n_0 ),
        .CO({\NLW_faults_reg[6]_i_11_CO_UNCONNECTED [3:1],next_clipped__0}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_faults_reg[6]_i_11_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  FDRE \faults_reg[7] 
       (.C(s_axi_aclk),
        .CE(\faults[7]_i_2_n_0 ),
        .D(\faults[7]_i_3_n_0 ),
        .Q(\faults_reg[7]_0 [7]),
        .R(\faults[7]_i_1_n_0 ));
  FDRE filtered_clipped_reg
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(dc_clipped),
        .Q(filtered_clipped),
        .R(dc_level0));
  FDRE \filtered_latched_reg[0] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[8]),
        .Q(filtered_latched[0]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[10] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[18]),
        .Q(filtered_latched[10]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[11] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[19]),
        .Q(filtered_latched[11]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[12] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[20]),
        .Q(filtered_latched[12]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[13] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[21]),
        .Q(filtered_latched[13]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[14] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[22]),
        .Q(filtered_latched[14]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[15] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[23]),
        .Q(filtered_latched[15]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[16] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[24]),
        .Q(filtered_latched[16]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[17] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[25]),
        .Q(filtered_latched[17]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[1] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[9]),
        .Q(filtered_latched[1]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[2] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[10]),
        .Q(filtered_latched[2]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[3] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[11]),
        .Q(filtered_latched[3]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[4] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[12]),
        .Q(filtered_latched[4]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[5] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[13]),
        .Q(filtered_latched[5]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[6] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[14]),
        .Q(filtered_latched[6]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[7] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[15]),
        .Q(filtered_latched[7]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[8] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[16]),
        .Q(filtered_latched[8]),
        .R(dc_level0));
  FDRE \filtered_latched_reg[9] 
       (.C(s_axi_aclk),
        .CE(dc_valid),
        .D(centered[17]),
        .Q(filtered_latched[9]),
        .R(dc_level0));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT2 #(
    .INIT(4'h2)) 
    filtered_valid_i_1
       (.I0(dc_valid),
        .I1(dc_level0),
        .O(filtered_valid_i_1_n_0));
  FDRE filtered_valid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(filtered_valid_i_1_n_0),
        .Q(filtered_valid),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT3 #(
    .INIT(8'hEA)) 
    high_seen_i_1
       (.I0(above_loud),
        .I1(high_seen_reg_n_0),
        .I2(status[3]),
        .O(high_seen_i_1_n_0));
  FDRE high_seen_reg
       (.C(s_axi_aclk),
        .CE(soft_count),
        .D(high_seen_i_1_n_0),
        .Q(high_seen_reg_n_0),
        .R(\sample_in_window[9]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \i_/i_/i__carry 
       (.CI(1'b0),
        .CO({\i_/i_/i__carry_n_0 ,\i_/i_/i__carry_n_1 ,\i_/i_/i__carry_n_2 ,\i_/i_/i__carry_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\i_/i_/i__carry_n_4 ,\i_/i_/i__carry_n_5 ,\i_/i_/i__carry_n_6 ,\i_/i_/i__carry_n_7 }),
        .S({sample_age_reg[3:1],i__carry_i_1__0_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \i_/i_/i__carry__0 
       (.CI(\i_/i_/i__carry_n_0 ),
        .CO({\i_/i_/i__carry__0_n_0 ,\i_/i_/i__carry__0_n_1 ,\i_/i_/i__carry__0_n_2 ,\i_/i_/i__carry__0_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_/i_/i__carry__0_n_4 ,\i_/i_/i__carry__0_n_5 ,\i_/i_/i__carry__0_n_6 ,\i_/i_/i__carry__0_n_7 }),
        .S(sample_age_reg[7:4]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \i_/i_/i__carry__1 
       (.CI(\i_/i_/i__carry__0_n_0 ),
        .CO({\i_/i_/i__carry__1_n_0 ,\i_/i_/i__carry__1_n_1 ,\i_/i_/i__carry__1_n_2 ,\i_/i_/i__carry__1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_/i_/i__carry__1_n_4 ,\i_/i_/i__carry__1_n_5 ,\i_/i_/i__carry__1_n_6 ,\i_/i_/i__carry__1_n_7 }),
        .S(sample_age_reg[11:8]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \i_/i_/i__carry__2 
       (.CI(\i_/i_/i__carry__1_n_0 ),
        .CO({\i_/i_/i__carry__2_n_0 ,\i_/i_/i__carry__2_n_1 ,\i_/i_/i__carry__2_n_2 ,\i_/i_/i__carry__2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_/i_/i__carry__2_n_4 ,\i_/i_/i__carry__2_n_5 ,\i_/i_/i__carry__2_n_6 ,\i_/i_/i__carry__2_n_7 }),
        .S(sample_age_reg[15:12]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \i_/i_/i__carry__3 
       (.CI(\i_/i_/i__carry__2_n_0 ),
        .CO({\NLW_i_/i_/i__carry__3_CO_UNCONNECTED [3],\i_/i_/i__carry__3_n_1 ,\i_/i_/i__carry__3_n_2 ,\i_/i_/i__carry__3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\i_/i_/i__carry__3_n_4 ,\i_/i_/i__carry__3_n_5 ,\i_/i_/i__carry__3_n_6 ,\i_/i_/i__carry__3_n_7 }),
        .S(sample_age_reg[19:16]));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__0_i_1
       (.I0(out[21]),
        .I1(out[22]),
        .I2(out[23]),
        .O(i__carry__0_i_1_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__0_i_2
       (.I0(out[18]),
        .I1(out[19]),
        .I2(out[20]),
        .O(i__carry__0_i_2_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__0_i_3
       (.I0(out[15]),
        .I1(out[16]),
        .I2(out[17]),
        .O(i__carry__0_i_3_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__0_i_4
       (.I0(out[12]),
        .I1(out[13]),
        .I2(out[14]),
        .O(i__carry__0_i_4_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__1_i_1
       (.I0(out[33]),
        .I1(out[34]),
        .I2(out[35]),
        .O(i__carry__1_i_1_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__1_i_2
       (.I0(out[30]),
        .I1(out[31]),
        .I2(out[32]),
        .O(i__carry__1_i_2_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__1_i_3
       (.I0(out[27]),
        .I1(out[28]),
        .I2(out[29]),
        .O(i__carry__1_i_3_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__1_i_4
       (.I0(out[24]),
        .I1(out[25]),
        .I2(out[26]),
        .O(i__carry__1_i_4_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__2_i_1
       (.I0(out[45]),
        .I1(out[46]),
        .I2(out[47]),
        .O(i__carry__2_i_1_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__2_i_2
       (.I0(out[42]),
        .I1(out[43]),
        .I2(out[44]),
        .O(i__carry__2_i_2_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__2_i_3
       (.I0(out[39]),
        .I1(out[40]),
        .I2(out[41]),
        .O(i__carry__2_i_3_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__2_i_4
       (.I0(out[36]),
        .I1(out[37]),
        .I2(out[38]),
        .O(i__carry__2_i_4_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__3_i_1
       (.I0(out[57]),
        .I1(out[58]),
        .I2(out[59]),
        .O(i__carry__3_i_1_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__3_i_2
       (.I0(out[54]),
        .I1(out[55]),
        .I2(out[56]),
        .O(i__carry__3_i_2_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__3_i_3
       (.I0(out[51]),
        .I1(out[52]),
        .I2(out[53]),
        .O(i__carry__3_i_3_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__3_i_4
       (.I0(out[48]),
        .I1(out[49]),
        .I2(out[50]),
        .O(i__carry__3_i_4_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry__4_i_1
       (.I0(out[60]),
        .I1(out[61]),
        .I2(out[62]),
        .O(i__carry__4_i_1_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry_i_1
       (.I0(out[9]),
        .I1(out[10]),
        .I2(out[11]),
        .O(i__carry_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    i__carry_i_1__0
       (.I0(sample_age_reg[0]),
        .O(i__carry_i_1__0_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry_i_2
       (.I0(out[6]),
        .I1(out[7]),
        .I2(out[8]),
        .O(i__carry_i_2_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry_i_3
       (.I0(out[3]),
        .I1(out[4]),
        .I2(out[5]),
        .O(i__carry_i_3_n_0));
  LUT3 #(
    .INIT(8'h80)) 
    i__carry_i_4
       (.I0(out[0]),
        .I1(out[1]),
        .I2(out[2]),
        .O(i__carry_i_4_n_0));
  LUT2 #(
    .INIT(4'hB)) 
    \last_sum[31]_i_1 
       (.I0(configure),
        .I1(s_axi_aresetn),
        .O(\last_sum[31]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00800000)) 
    \last_sum[31]_i_2 
       (.I0(filtered_valid),
        .I1(\event_age[31]_i_1_n_0 ),
        .I2(\faults_reg[0]_1 ),
        .I3(configure),
        .I4(\clipped_count[15]_i_4_n_0 ),
        .O(\last_sum[31]_i_2_n_0 ));
  FDRE \last_sum_reg[0] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[3]_i_1_n_7 ),
        .Q(\last_sum_reg[31]_0 [0]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[10] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[11]_i_1_n_5 ),
        .Q(\last_sum_reg[31]_0 [10]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[11] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[11]_i_1_n_4 ),
        .Q(\last_sum_reg[31]_0 [11]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[12] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[15]_i_1_n_7 ),
        .Q(\last_sum_reg[31]_0 [12]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[13] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[15]_i_1_n_6 ),
        .Q(\last_sum_reg[31]_0 [13]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[14] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[15]_i_1_n_5 ),
        .Q(\last_sum_reg[31]_0 [14]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[15] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[15]_i_1_n_4 ),
        .Q(\last_sum_reg[31]_0 [15]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[16] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[19]_i_1_n_7 ),
        .Q(\last_sum_reg[31]_0 [16]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[17] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[19]_i_1_n_6 ),
        .Q(\last_sum_reg[31]_0 [17]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[18] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[19]_i_1_n_5 ),
        .Q(\last_sum_reg[31]_0 [18]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[19] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[19]_i_1_n_4 ),
        .Q(\last_sum_reg[31]_0 [19]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[1] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[3]_i_1_n_6 ),
        .Q(\last_sum_reg[31]_0 [1]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[20] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[23]_i_1_n_7 ),
        .Q(\last_sum_reg[31]_0 [20]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[21] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[23]_i_1_n_6 ),
        .Q(\last_sum_reg[31]_0 [21]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[22] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[23]_i_1_n_5 ),
        .Q(\last_sum_reg[31]_0 [22]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[23] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[23]_i_1_n_4 ),
        .Q(\last_sum_reg[31]_0 [23]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[24] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[27]_i_1_n_7 ),
        .Q(\last_sum_reg[31]_0 [24]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[25] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[27]_i_1_n_6 ),
        .Q(\last_sum_reg[31]_0 [25]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[26] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[27]_i_1_n_5 ),
        .Q(\last_sum_reg[31]_0 [26]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[27] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[27]_i_1_n_4 ),
        .Q(\last_sum_reg[31]_0 [27]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[28] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[31]_i_1_n_7 ),
        .Q(\last_sum_reg[31]_0 [28]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[29] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[31]_i_1_n_6 ),
        .Q(\last_sum_reg[31]_0 [29]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[2] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[3]_i_1_n_5 ),
        .Q(\last_sum_reg[31]_0 [2]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[30] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[31]_i_1_n_5 ),
        .Q(\last_sum_reg[31]_0 [30]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[31] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[31]_i_1_n_4 ),
        .Q(\last_sum_reg[31]_0 [31]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[3] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[3]_i_1_n_4 ),
        .Q(\last_sum_reg[31]_0 [3]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[4] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[7]_i_1_n_7 ),
        .Q(\last_sum_reg[31]_0 [4]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[5] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[7]_i_1_n_6 ),
        .Q(\last_sum_reg[31]_0 [5]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[6] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[7]_i_1_n_5 ),
        .Q(\last_sum_reg[31]_0 [6]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[7] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[7]_i_1_n_4 ),
        .Q(\last_sum_reg[31]_0 [7]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[8] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[11]_i_1_n_7 ),
        .Q(\last_sum_reg[31]_0 [8]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \last_sum_reg[9] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\accumulation_reg[11]_i_1_n_6 ),
        .Q(\last_sum_reg[31]_0 [9]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT3 #(
    .INIT(8'h2A)) 
    \loud_count[0]_i_1 
       (.I0(above_loud),
        .I1(loud_count[0]),
        .I2(status[3]),
        .O(\loud_count[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT4 #(
    .INIT(16'h2800)) 
    \loud_count[1]_i_1 
       (.I0(status[3]),
        .I1(loud_count[0]),
        .I2(loud_count[1]),
        .I3(above_loud),
        .O(\loud_count[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'h28880000)) 
    \loud_count[2]_i_1 
       (.I0(status[3]),
        .I1(loud_count[2]),
        .I2(loud_count[1]),
        .I3(loud_count[0]),
        .I4(above_loud),
        .O(\loud_count[2]_i_1_n_0 ));
  FDRE \loud_count_reg[0] 
       (.C(s_axi_aclk),
        .CE(soft_count),
        .D(\loud_count[0]_i_1_n_0 ),
        .Q(loud_count[0]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \loud_count_reg[1] 
       (.C(s_axi_aclk),
        .CE(soft_count),
        .D(\loud_count[1]_i_1_n_0 ),
        .Q(loud_count[1]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \loud_count_reg[2] 
       (.C(s_axi_aclk),
        .CE(soft_count),
        .D(\loud_count[2]_i_1_n_0 ),
        .Q(loud_count[2]),
        .R(\sample_in_window[9]_i_1_n_0 ));
  CARRY4 matching_ack0_carry
       (.CI(1'b0),
        .CO({matching_ack0_carry_n_0,matching_ack0_carry_n_1,matching_ack0_carry_n_2,matching_ack0_carry_n_3}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_matching_ack0_carry_O_UNCONNECTED[3:0]),
        .S({matching_ack0_carry_i_1_n_0,matching_ack0_carry_i_2_n_0,matching_ack0_carry_i_3_n_0,matching_ack0_carry_i_4_n_0}));
  CARRY4 matching_ack0_carry__0
       (.CI(matching_ack0_carry_n_0),
        .CO({matching_ack0_carry__0_n_0,matching_ack0_carry__0_n_1,matching_ack0_carry__0_n_2,matching_ack0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_matching_ack0_carry__0_O_UNCONNECTED[3:0]),
        .S({matching_ack0_carry__0_i_1_n_0,matching_ack0_carry__0_i_2_n_0,matching_ack0_carry__0_i_3_n_0,matching_ack0_carry__0_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack0_carry__0_i_1
       (.I0(matching_ack0_carry__1_0[22]),
        .I1(\event_sequence_reg[31]_0 [22]),
        .I2(matching_ack0_carry__1_0[21]),
        .I3(\event_sequence_reg[31]_0 [21]),
        .I4(\event_sequence_reg[31]_0 [23]),
        .I5(matching_ack0_carry__1_0[23]),
        .O(matching_ack0_carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack0_carry__0_i_2
       (.I0(matching_ack0_carry__1_0[19]),
        .I1(\event_sequence_reg[31]_0 [19]),
        .I2(matching_ack0_carry__1_0[18]),
        .I3(\event_sequence_reg[31]_0 [18]),
        .I4(\event_sequence_reg[31]_0 [20]),
        .I5(matching_ack0_carry__1_0[20]),
        .O(matching_ack0_carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack0_carry__0_i_3
       (.I0(matching_ack0_carry__1_0[15]),
        .I1(\event_sequence_reg[31]_0 [15]),
        .I2(matching_ack0_carry__1_0[16]),
        .I3(\event_sequence_reg[31]_0 [16]),
        .I4(\event_sequence_reg[31]_0 [17]),
        .I5(matching_ack0_carry__1_0[17]),
        .O(matching_ack0_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack0_carry__0_i_4
       (.I0(matching_ack0_carry__1_0[12]),
        .I1(\event_sequence_reg[31]_0 [12]),
        .I2(matching_ack0_carry__1_0[13]),
        .I3(\event_sequence_reg[31]_0 [13]),
        .I4(\event_sequence_reg[31]_0 [14]),
        .I5(matching_ack0_carry__1_0[14]),
        .O(matching_ack0_carry__0_i_4_n_0));
  CARRY4 matching_ack0_carry__1
       (.CI(matching_ack0_carry__0_n_0),
        .CO({NLW_matching_ack0_carry__1_CO_UNCONNECTED[3],matching_ack0,matching_ack0_carry__1_n_2,matching_ack0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_matching_ack0_carry__1_O_UNCONNECTED[3:0]),
        .S({1'b0,matching_ack0_carry__1_i_1_n_0,matching_ack0_carry__1_i_2_n_0,matching_ack0_carry__1_i_3_n_0}));
  LUT4 #(
    .INIT(16'h9009)) 
    matching_ack0_carry__1_i_1
       (.I0(\event_sequence_reg[31]_0 [31]),
        .I1(matching_ack0_carry__1_0[31]),
        .I2(\event_sequence_reg[31]_0 [30]),
        .I3(matching_ack0_carry__1_0[30]),
        .O(matching_ack0_carry__1_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack0_carry__1_i_2
       (.I0(matching_ack0_carry__1_0[27]),
        .I1(\event_sequence_reg[31]_0 [27]),
        .I2(matching_ack0_carry__1_0[28]),
        .I3(\event_sequence_reg[31]_0 [28]),
        .I4(\event_sequence_reg[31]_0 [29]),
        .I5(matching_ack0_carry__1_0[29]),
        .O(matching_ack0_carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack0_carry__1_i_3
       (.I0(matching_ack0_carry__1_0[24]),
        .I1(\event_sequence_reg[31]_0 [24]),
        .I2(matching_ack0_carry__1_0[25]),
        .I3(\event_sequence_reg[31]_0 [25]),
        .I4(\event_sequence_reg[31]_0 [26]),
        .I5(matching_ack0_carry__1_0[26]),
        .O(matching_ack0_carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack0_carry_i_1
       (.I0(matching_ack0_carry__1_0[9]),
        .I1(\event_sequence_reg[31]_0 [9]),
        .I2(matching_ack0_carry__1_0[10]),
        .I3(\event_sequence_reg[31]_0 [10]),
        .I4(\event_sequence_reg[31]_0 [11]),
        .I5(matching_ack0_carry__1_0[11]),
        .O(matching_ack0_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack0_carry_i_2
       (.I0(matching_ack0_carry__1_0[7]),
        .I1(\event_sequence_reg[31]_0 [7]),
        .I2(matching_ack0_carry__1_0[6]),
        .I3(\event_sequence_reg[31]_0 [6]),
        .I4(\event_sequence_reg[31]_0 [8]),
        .I5(matching_ack0_carry__1_0[8]),
        .O(matching_ack0_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack0_carry_i_3
       (.I0(matching_ack0_carry__1_0[3]),
        .I1(\event_sequence_reg[31]_0 [3]),
        .I2(matching_ack0_carry__1_0[4]),
        .I3(\event_sequence_reg[31]_0 [4]),
        .I4(\event_sequence_reg[31]_0 [5]),
        .I5(matching_ack0_carry__1_0[5]),
        .O(matching_ack0_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack0_carry_i_4
       (.I0(\event_sequence_reg[31]_0 [0]),
        .I1(matching_ack0_carry__1_0[0]),
        .I2(matching_ack0_carry__1_0[2]),
        .I3(\event_sequence_reg[31]_0 [2]),
        .I4(matching_ack0_carry__1_0[1]),
        .I5(\event_sequence_reg[31]_0 [1]),
        .O(matching_ack0_carry_i_4_n_0));
  CARRY4 matching_ack1_carry
       (.CI(1'b0),
        .CO({matching_ack1_carry_n_0,matching_ack1_carry_n_1,matching_ack1_carry_n_2,matching_ack1_carry_n_3}),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_matching_ack1_carry_O_UNCONNECTED[3:0]),
        .S({matching_ack1_carry_i_1_n_0,matching_ack1_carry_i_2_n_0,matching_ack1_carry_i_3_n_0,matching_ack1_carry_i_4_n_0}));
  CARRY4 matching_ack1_carry__0
       (.CI(matching_ack1_carry_n_0),
        .CO({matching_ack1_carry__0_n_0,matching_ack1_carry__0_n_1,matching_ack1_carry__0_n_2,matching_ack1_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_matching_ack1_carry__0_O_UNCONNECTED[3:0]),
        .S({matching_ack1_carry__0_i_1_n_0,matching_ack1_carry__0_i_2_n_0,matching_ack1_carry__0_i_3_n_0,matching_ack1_carry__0_i_4_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack1_carry__0_i_1
       (.I0(matching_ack1_carry__1_0[22]),
        .I1(\event_epoch_reg[31]_0 [22]),
        .I2(matching_ack1_carry__1_0[21]),
        .I3(\event_epoch_reg[31]_0 [21]),
        .I4(\event_epoch_reg[31]_0 [23]),
        .I5(matching_ack1_carry__1_0[23]),
        .O(matching_ack1_carry__0_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack1_carry__0_i_2
       (.I0(matching_ack1_carry__1_0[18]),
        .I1(\event_epoch_reg[31]_0 [18]),
        .I2(matching_ack1_carry__1_0[19]),
        .I3(\event_epoch_reg[31]_0 [19]),
        .I4(\event_epoch_reg[31]_0 [20]),
        .I5(matching_ack1_carry__1_0[20]),
        .O(matching_ack1_carry__0_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack1_carry__0_i_3
       (.I0(matching_ack1_carry__1_0[15]),
        .I1(\event_epoch_reg[31]_0 [15]),
        .I2(matching_ack1_carry__1_0[16]),
        .I3(\event_epoch_reg[31]_0 [16]),
        .I4(\event_epoch_reg[31]_0 [17]),
        .I5(matching_ack1_carry__1_0[17]),
        .O(matching_ack1_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack1_carry__0_i_4
       (.I0(matching_ack1_carry__1_0[12]),
        .I1(\event_epoch_reg[31]_0 [12]),
        .I2(matching_ack1_carry__1_0[13]),
        .I3(\event_epoch_reg[31]_0 [13]),
        .I4(\event_epoch_reg[31]_0 [14]),
        .I5(matching_ack1_carry__1_0[14]),
        .O(matching_ack1_carry__0_i_4_n_0));
  CARRY4 matching_ack1_carry__1
       (.CI(matching_ack1_carry__0_n_0),
        .CO({NLW_matching_ack1_carry__1_CO_UNCONNECTED[3],matching_ack1,matching_ack1_carry__1_n_2,matching_ack1_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_matching_ack1_carry__1_O_UNCONNECTED[3:0]),
        .S({1'b0,matching_ack1_carry__1_i_1_n_0,matching_ack1_carry__1_i_2_n_0,matching_ack1_carry__1_i_3_n_0}));
  LUT4 #(
    .INIT(16'h9009)) 
    matching_ack1_carry__1_i_1
       (.I0(\event_epoch_reg[31]_0 [31]),
        .I1(matching_ack1_carry__1_0[31]),
        .I2(\event_epoch_reg[31]_0 [30]),
        .I3(matching_ack1_carry__1_0[30]),
        .O(matching_ack1_carry__1_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack1_carry__1_i_2
       (.I0(matching_ack1_carry__1_0[27]),
        .I1(\event_epoch_reg[31]_0 [27]),
        .I2(matching_ack1_carry__1_0[28]),
        .I3(\event_epoch_reg[31]_0 [28]),
        .I4(\event_epoch_reg[31]_0 [29]),
        .I5(matching_ack1_carry__1_0[29]),
        .O(matching_ack1_carry__1_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack1_carry__1_i_3
       (.I0(matching_ack1_carry__1_0[25]),
        .I1(\event_epoch_reg[31]_0 [25]),
        .I2(matching_ack1_carry__1_0[24]),
        .I3(\event_epoch_reg[31]_0 [24]),
        .I4(\event_epoch_reg[31]_0 [26]),
        .I5(matching_ack1_carry__1_0[26]),
        .O(matching_ack1_carry__1_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack1_carry_i_1
       (.I0(matching_ack1_carry__1_0[9]),
        .I1(\event_epoch_reg[31]_0 [9]),
        .I2(matching_ack1_carry__1_0[10]),
        .I3(\event_epoch_reg[31]_0 [10]),
        .I4(\event_epoch_reg[31]_0 [11]),
        .I5(matching_ack1_carry__1_0[11]),
        .O(matching_ack1_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack1_carry_i_2
       (.I0(matching_ack1_carry__1_0[7]),
        .I1(\event_epoch_reg[31]_0 [7]),
        .I2(matching_ack1_carry__1_0[6]),
        .I3(\event_epoch_reg[31]_0 [6]),
        .I4(\event_epoch_reg[31]_0 [8]),
        .I5(matching_ack1_carry__1_0[8]),
        .O(matching_ack1_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack1_carry_i_3
       (.I0(\event_epoch_reg[31]_0 [5]),
        .I1(matching_ack1_carry__1_0[5]),
        .I2(matching_ack1_carry__1_0[3]),
        .I3(\event_epoch_reg[31]_0 [3]),
        .I4(matching_ack1_carry__1_0[4]),
        .I5(\event_epoch_reg[31]_0 [4]),
        .O(matching_ack1_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    matching_ack1_carry_i_4
       (.I0(matching_ack1_carry__1_0[0]),
        .I1(\event_epoch_reg[31]_0 [0]),
        .I2(matching_ack1_carry__1_0[1]),
        .I3(\event_epoch_reg[31]_0 [1]),
        .I4(\event_epoch_reg[31]_0 [2]),
        .I5(matching_ack1_carry__1_0[2]),
        .O(matching_ack1_carry_i_4_n_0));
  CARRY4 next_dc_carry
       (.CI(1'b0),
        .CO({next_dc_carry_n_0,next_dc_carry_n_1,next_dc_carry_n_2,next_dc_carry_n_3}),
        .CYINIT(1'b0),
        .DI(dc_level[3:0]),
        .O({next_dc_carry_n_4,next_dc_carry_n_5,next_dc_carry_n_6,next_dc_carry_n_7}),
        .S({next_dc_carry_i_1_n_0,next_dc_carry_i_2_n_0,next_dc_carry_i_3_n_0,next_dc_carry_i_4_n_0}));
  CARRY4 next_dc_carry__0
       (.CI(next_dc_carry_n_0),
        .CO({next_dc_carry__0_n_0,next_dc_carry__0_n_1,next_dc_carry__0_n_2,next_dc_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI(dc_level[7:4]),
        .O({next_dc_carry__0_n_4,next_dc_carry__0_n_5,next_dc_carry__0_n_6,next_dc_carry__0_n_7}),
        .S({next_dc_carry__0_i_1_n_0,next_dc_carry__0_i_2_n_0,next_dc_carry__0_i_3_n_0,next_dc_carry__0_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry__0_i_1
       (.I0(dc_level[7]),
        .I1(\difference_latched_reg_n_0_[17] ),
        .O(next_dc_carry__0_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry__0_i_2
       (.I0(dc_level[6]),
        .I1(\difference_latched_reg_n_0_[16] ),
        .O(next_dc_carry__0_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry__0_i_3
       (.I0(dc_level[5]),
        .I1(\difference_latched_reg_n_0_[15] ),
        .O(next_dc_carry__0_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry__0_i_4
       (.I0(dc_level[4]),
        .I1(\difference_latched_reg_n_0_[14] ),
        .O(next_dc_carry__0_i_4_n_0));
  CARRY4 next_dc_carry__1
       (.CI(next_dc_carry__0_n_0),
        .CO({next_dc_carry__1_n_0,next_dc_carry__1_n_1,next_dc_carry__1_n_2,next_dc_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI(\dc_level_reg[22]_0 [3:0]),
        .O({next_dc_carry__1_n_4,next_dc_carry__1_n_5,next_dc_carry__1_n_6,next_dc_carry__1_n_7}),
        .S({next_dc_carry__1_i_1_n_0,next_dc_carry__1_i_2_n_0,next_dc_carry__1_i_3_n_0,next_dc_carry__1_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry__1_i_1
       (.I0(\dc_level_reg[22]_0 [3]),
        .I1(\difference_latched_reg_n_0_[21] ),
        .O(next_dc_carry__1_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry__1_i_2
       (.I0(\dc_level_reg[22]_0 [2]),
        .I1(\difference_latched_reg_n_0_[20] ),
        .O(next_dc_carry__1_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry__1_i_3
       (.I0(\dc_level_reg[22]_0 [1]),
        .I1(\difference_latched_reg_n_0_[19] ),
        .O(next_dc_carry__1_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry__1_i_4
       (.I0(\dc_level_reg[22]_0 [0]),
        .I1(\difference_latched_reg_n_0_[18] ),
        .O(next_dc_carry__1_i_4_n_0));
  CARRY4 next_dc_carry__2
       (.CI(next_dc_carry__1_n_0),
        .CO({next_dc_carry__2_n_0,next_dc_carry__2_n_1,next_dc_carry__2_n_2,next_dc_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({next_dc00,\dc_level_reg[22]_0 [6:4]}),
        .O({next_dc_carry__2_n_4,next_dc_carry__2_n_5,next_dc_carry__2_n_6,next_dc_carry__2_n_7}),
        .S({next_dc_carry__2_i_1_n_0,next_dc_carry__2_i_2_n_0,next_dc_carry__2_i_3_n_0,next_dc_carry__2_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry__2_i_1
       (.I0(next_dc00),
        .I1(\dc_level_reg[22]_0 [7]),
        .O(next_dc_carry__2_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry__2_i_2
       (.I0(\dc_level_reg[22]_0 [6]),
        .I1(\difference_latched_reg_n_0_[24] ),
        .O(next_dc_carry__2_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry__2_i_3
       (.I0(\dc_level_reg[22]_0 [5]),
        .I1(\difference_latched_reg_n_0_[23] ),
        .O(next_dc_carry__2_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry__2_i_4
       (.I0(\dc_level_reg[22]_0 [4]),
        .I1(\difference_latched_reg_n_0_[22] ),
        .O(next_dc_carry__2_i_4_n_0));
  CARRY4 next_dc_carry__3
       (.CI(next_dc_carry__2_n_0),
        .CO({next_dc_carry__3_n_0,next_dc_carry__3_n_1,next_dc_carry__3_n_2,next_dc_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({\dc_level_reg[22]_0 [10:8],next_dc_carry__3_i_1_n_0}),
        .O({next_dc_carry__3_n_4,next_dc_carry__3_n_5,next_dc_carry__3_n_6,next_dc_carry__3_n_7}),
        .S({next_dc_carry__3_i_2_n_0,next_dc_carry__3_i_3_n_0,next_dc_carry__3_i_4_n_0,next_dc_carry__3_i_5_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    next_dc_carry__3_i_1
       (.I0(next_dc00),
        .O(next_dc_carry__3_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    next_dc_carry__3_i_2
       (.I0(\dc_level_reg[22]_0 [10]),
        .I1(\dc_level_reg[22]_0 [11]),
        .O(next_dc_carry__3_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    next_dc_carry__3_i_3
       (.I0(\dc_level_reg[22]_0 [9]),
        .I1(\dc_level_reg[22]_0 [10]),
        .O(next_dc_carry__3_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    next_dc_carry__3_i_4
       (.I0(\dc_level_reg[22]_0 [8]),
        .I1(\dc_level_reg[22]_0 [9]),
        .O(next_dc_carry__3_i_4_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry__3_i_5
       (.I0(next_dc00),
        .I1(\dc_level_reg[22]_0 [8]),
        .O(next_dc_carry__3_i_5_n_0));
  CARRY4 next_dc_carry__4
       (.CI(next_dc_carry__3_n_0),
        .CO({next_dc_carry__4_n_0,next_dc_carry__4_n_1,next_dc_carry__4_n_2,next_dc_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI(\dc_level_reg[22]_0 [14:11]),
        .O({next_dc_carry__4_n_4,next_dc_carry__4_n_5,next_dc_carry__4_n_6,next_dc_carry__4_n_7}),
        .S({next_dc_carry__4_i_1_n_0,next_dc_carry__4_i_2_n_0,next_dc_carry__4_i_3_n_0,next_dc_carry__4_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    next_dc_carry__4_i_1
       (.I0(\dc_level_reg[22]_0 [14]),
        .I1(dc_level[23]),
        .O(next_dc_carry__4_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    next_dc_carry__4_i_2
       (.I0(\dc_level_reg[22]_0 [13]),
        .I1(\dc_level_reg[22]_0 [14]),
        .O(next_dc_carry__4_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    next_dc_carry__4_i_3
       (.I0(\dc_level_reg[22]_0 [12]),
        .I1(\dc_level_reg[22]_0 [13]),
        .O(next_dc_carry__4_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    next_dc_carry__4_i_4
       (.I0(\dc_level_reg[22]_0 [11]),
        .I1(\dc_level_reg[22]_0 [12]),
        .O(next_dc_carry__4_i_4_n_0));
  CARRY4 next_dc_carry__5
       (.CI(next_dc_carry__4_n_0),
        .CO({NLW_next_dc_carry__5_CO_UNCONNECTED[3:2],next_dc_carry__5_n_2,NLW_next_dc_carry__5_CO_UNCONNECTED[0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,dc_level[23]}),
        .O({NLW_next_dc_carry__5_O_UNCONNECTED[3:1],next_dc_carry__5_n_7}),
        .S({1'b0,1'b0,1'b1,next_dc_carry__5_i_1_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    next_dc_carry__5_i_1
       (.I0(dc_level[23]),
        .I1(dc_level[24]),
        .O(next_dc_carry__5_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry_i_1
       (.I0(dc_level[3]),
        .I1(\difference_latched_reg_n_0_[13] ),
        .O(next_dc_carry_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry_i_2
       (.I0(dc_level[2]),
        .I1(\difference_latched_reg_n_0_[12] ),
        .O(next_dc_carry_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry_i_3
       (.I0(dc_level[1]),
        .I1(\difference_latched_reg_n_0_[11] ),
        .O(next_dc_carry_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    next_dc_carry_i_4
       (.I0(dc_level[0]),
        .I1(\difference_latched_reg_n_0_[10] ),
        .O(next_dc_carry_i_4_n_0));
  CARRY4 \p_0_out_inferred__3/i__carry 
       (.CI(1'b0),
        .CO({\p_0_out_inferred__3/i__carry_n_0 ,\p_0_out_inferred__3/i__carry_n_1 ,\p_0_out_inferred__3/i__carry_n_2 ,\p_0_out_inferred__3/i__carry_n_3 }),
        .CYINIT(1'b1),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_p_0_out_inferred__3/i__carry_O_UNCONNECTED [3:0]),
        .S({i__carry_i_1_n_0,i__carry_i_2_n_0,i__carry_i_3_n_0,i__carry_i_4_n_0}));
  CARRY4 \p_0_out_inferred__3/i__carry__0 
       (.CI(\p_0_out_inferred__3/i__carry_n_0 ),
        .CO({\p_0_out_inferred__3/i__carry__0_n_0 ,\p_0_out_inferred__3/i__carry__0_n_1 ,\p_0_out_inferred__3/i__carry__0_n_2 ,\p_0_out_inferred__3/i__carry__0_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_p_0_out_inferred__3/i__carry__0_O_UNCONNECTED [3:0]),
        .S({i__carry__0_i_1_n_0,i__carry__0_i_2_n_0,i__carry__0_i_3_n_0,i__carry__0_i_4_n_0}));
  CARRY4 \p_0_out_inferred__3/i__carry__1 
       (.CI(\p_0_out_inferred__3/i__carry__0_n_0 ),
        .CO({\p_0_out_inferred__3/i__carry__1_n_0 ,\p_0_out_inferred__3/i__carry__1_n_1 ,\p_0_out_inferred__3/i__carry__1_n_2 ,\p_0_out_inferred__3/i__carry__1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_p_0_out_inferred__3/i__carry__1_O_UNCONNECTED [3:0]),
        .S({i__carry__1_i_1_n_0,i__carry__1_i_2_n_0,i__carry__1_i_3_n_0,i__carry__1_i_4_n_0}));
  CARRY4 \p_0_out_inferred__3/i__carry__2 
       (.CI(\p_0_out_inferred__3/i__carry__1_n_0 ),
        .CO({\p_0_out_inferred__3/i__carry__2_n_0 ,\p_0_out_inferred__3/i__carry__2_n_1 ,\p_0_out_inferred__3/i__carry__2_n_2 ,\p_0_out_inferred__3/i__carry__2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_p_0_out_inferred__3/i__carry__2_O_UNCONNECTED [3:0]),
        .S({i__carry__2_i_1_n_0,i__carry__2_i_2_n_0,i__carry__2_i_3_n_0,i__carry__2_i_4_n_0}));
  CARRY4 \p_0_out_inferred__3/i__carry__3 
       (.CI(\p_0_out_inferred__3/i__carry__2_n_0 ),
        .CO({\p_0_out_inferred__3/i__carry__3_n_0 ,\p_0_out_inferred__3/i__carry__3_n_1 ,\p_0_out_inferred__3/i__carry__3_n_2 ,\p_0_out_inferred__3/i__carry__3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_p_0_out_inferred__3/i__carry__3_O_UNCONNECTED [3:0]),
        .S({i__carry__3_i_1_n_0,i__carry__3_i_2_n_0,i__carry__3_i_3_n_0,i__carry__3_i_4_n_0}));
  CARRY4 \p_0_out_inferred__3/i__carry__4 
       (.CI(\p_0_out_inferred__3/i__carry__3_n_0 ),
        .CO({\NLW_p_0_out_inferred__3/i__carry__4_CO_UNCONNECTED [3:2],\p_0_out_inferred__3/i__carry__4_n_2 ,\p_0_out_inferred__3/i__carry__4_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(\NLW_p_0_out_inferred__3/i__carry__4_O_UNCONNECTED [3:0]),
        .S({1'b0,1'b0,out[63],i__carry__4_i_1_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 quiet_carry
       (.CI(1'b0),
        .CO({quiet_carry_n_0,quiet_carry_n_1,quiet_carry_n_2,quiet_carry_n_3}),
        .CYINIT(1'b1),
        .DI({quiet_carry_i_1_n_0,quiet_carry_i_2_n_0,quiet_carry_i_3_n_0,quiet_carry_i_4_n_0}),
        .O(NLW_quiet_carry_O_UNCONNECTED[3:0]),
        .S({quiet_carry_i_5_n_0,quiet_carry_i_6_n_0,quiet_carry_i_7_n_0,quiet_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 quiet_carry__0
       (.CI(quiet_carry_n_0),
        .CO({quiet_carry__0_n_0,quiet_carry__0_n_1,quiet_carry__0_n_2,quiet_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({quiet_carry__0_i_1_n_0,quiet_carry__0_i_2_n_0,quiet_carry__0_i_3_n_0,quiet_carry__0_i_4_n_0}),
        .O(NLW_quiet_carry__0_O_UNCONNECTED[3:0]),
        .S({quiet_carry__0_i_5_n_0,quiet_carry__0_i_6_n_0,quiet_carry__0_i_7_n_0,quiet_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry__0_i_1
       (.I0(quiet_carry__2_0[15]),
        .I1(\accumulation_reg[15]_i_1_n_4 ),
        .I2(quiet_carry__2_0[14]),
        .I3(\accumulation_reg[15]_i_1_n_5 ),
        .O(quiet_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry__0_i_2
       (.I0(quiet_carry__2_0[13]),
        .I1(\accumulation_reg[15]_i_1_n_6 ),
        .I2(quiet_carry__2_0[12]),
        .I3(\accumulation_reg[15]_i_1_n_7 ),
        .O(quiet_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry__0_i_3
       (.I0(quiet_carry__2_0[11]),
        .I1(\accumulation_reg[11]_i_1_n_4 ),
        .I2(quiet_carry__2_0[10]),
        .I3(\accumulation_reg[11]_i_1_n_5 ),
        .O(quiet_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry__0_i_4
       (.I0(quiet_carry__2_0[9]),
        .I1(\accumulation_reg[11]_i_1_n_6 ),
        .I2(quiet_carry__2_0[8]),
        .I3(\accumulation_reg[11]_i_1_n_7 ),
        .O(quiet_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry__0_i_5
       (.I0(\accumulation_reg[15]_i_1_n_4 ),
        .I1(quiet_carry__2_0[15]),
        .I2(\accumulation_reg[15]_i_1_n_5 ),
        .I3(quiet_carry__2_0[14]),
        .O(quiet_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry__0_i_6
       (.I0(\accumulation_reg[15]_i_1_n_6 ),
        .I1(quiet_carry__2_0[13]),
        .I2(\accumulation_reg[15]_i_1_n_7 ),
        .I3(quiet_carry__2_0[12]),
        .O(quiet_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry__0_i_7
       (.I0(\accumulation_reg[11]_i_1_n_4 ),
        .I1(quiet_carry__2_0[11]),
        .I2(\accumulation_reg[11]_i_1_n_5 ),
        .I3(quiet_carry__2_0[10]),
        .O(quiet_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry__0_i_8
       (.I0(\accumulation_reg[11]_i_1_n_6 ),
        .I1(quiet_carry__2_0[9]),
        .I2(\accumulation_reg[11]_i_1_n_7 ),
        .I3(quiet_carry__2_0[8]),
        .O(quiet_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 quiet_carry__1
       (.CI(quiet_carry__0_n_0),
        .CO({quiet_carry__1_n_0,quiet_carry__1_n_1,quiet_carry__1_n_2,quiet_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({quiet_carry__1_i_1_n_0,quiet_carry__1_i_2_n_0,quiet_carry__1_i_3_n_0,quiet_carry__1_i_4_n_0}),
        .O(NLW_quiet_carry__1_O_UNCONNECTED[3:0]),
        .S({quiet_carry__1_i_5_n_0,quiet_carry__1_i_6_n_0,quiet_carry__1_i_7_n_0,quiet_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry__1_i_1
       (.I0(quiet_carry__2_0[23]),
        .I1(\accumulation_reg[23]_i_1_n_4 ),
        .I2(quiet_carry__2_0[22]),
        .I3(\accumulation_reg[23]_i_1_n_5 ),
        .O(quiet_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry__1_i_2
       (.I0(quiet_carry__2_0[21]),
        .I1(\accumulation_reg[23]_i_1_n_6 ),
        .I2(quiet_carry__2_0[20]),
        .I3(\accumulation_reg[23]_i_1_n_7 ),
        .O(quiet_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry__1_i_3
       (.I0(quiet_carry__2_0[19]),
        .I1(\accumulation_reg[19]_i_1_n_4 ),
        .I2(quiet_carry__2_0[18]),
        .I3(\accumulation_reg[19]_i_1_n_5 ),
        .O(quiet_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry__1_i_4
       (.I0(quiet_carry__2_0[17]),
        .I1(\accumulation_reg[19]_i_1_n_6 ),
        .I2(quiet_carry__2_0[16]),
        .I3(\accumulation_reg[19]_i_1_n_7 ),
        .O(quiet_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry__1_i_5
       (.I0(\accumulation_reg[23]_i_1_n_4 ),
        .I1(quiet_carry__2_0[23]),
        .I2(\accumulation_reg[23]_i_1_n_5 ),
        .I3(quiet_carry__2_0[22]),
        .O(quiet_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry__1_i_6
       (.I0(\accumulation_reg[23]_i_1_n_6 ),
        .I1(quiet_carry__2_0[21]),
        .I2(\accumulation_reg[23]_i_1_n_7 ),
        .I3(quiet_carry__2_0[20]),
        .O(quiet_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry__1_i_7
       (.I0(\accumulation_reg[19]_i_1_n_4 ),
        .I1(quiet_carry__2_0[19]),
        .I2(\accumulation_reg[19]_i_1_n_5 ),
        .I3(quiet_carry__2_0[18]),
        .O(quiet_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry__1_i_8
       (.I0(\accumulation_reg[19]_i_1_n_6 ),
        .I1(quiet_carry__2_0[17]),
        .I2(\accumulation_reg[19]_i_1_n_7 ),
        .I3(quiet_carry__2_0[16]),
        .O(quiet_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 quiet_carry__2
       (.CI(quiet_carry__1_n_0),
        .CO({quiet_carry__2_n_0,quiet_carry__2_n_1,quiet_carry__2_n_2,quiet_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({quiet_carry__2_i_1_n_0,quiet_carry__2_i_2_n_0,quiet_carry__2_i_3_n_0,quiet_carry__2_i_4_n_0}),
        .O(NLW_quiet_carry__2_O_UNCONNECTED[3:0]),
        .S({quiet_carry__2_i_5_n_0,quiet_carry__2_i_6_n_0,quiet_carry__2_i_7_n_0,quiet_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry__2_i_1
       (.I0(quiet_carry__2_0[31]),
        .I1(\accumulation_reg[31]_i_1_n_4 ),
        .I2(quiet_carry__2_0[30]),
        .I3(\accumulation_reg[31]_i_1_n_5 ),
        .O(quiet_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry__2_i_2
       (.I0(quiet_carry__2_0[29]),
        .I1(\accumulation_reg[31]_i_1_n_6 ),
        .I2(quiet_carry__2_0[28]),
        .I3(\accumulation_reg[31]_i_1_n_7 ),
        .O(quiet_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry__2_i_3
       (.I0(quiet_carry__2_0[27]),
        .I1(\accumulation_reg[27]_i_1_n_4 ),
        .I2(quiet_carry__2_0[26]),
        .I3(\accumulation_reg[27]_i_1_n_5 ),
        .O(quiet_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry__2_i_4
       (.I0(quiet_carry__2_0[25]),
        .I1(\accumulation_reg[27]_i_1_n_6 ),
        .I2(quiet_carry__2_0[24]),
        .I3(\accumulation_reg[27]_i_1_n_7 ),
        .O(quiet_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry__2_i_5
       (.I0(\accumulation_reg[31]_i_1_n_4 ),
        .I1(quiet_carry__2_0[31]),
        .I2(\accumulation_reg[31]_i_1_n_5 ),
        .I3(quiet_carry__2_0[30]),
        .O(quiet_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry__2_i_6
       (.I0(\accumulation_reg[31]_i_1_n_6 ),
        .I1(quiet_carry__2_0[29]),
        .I2(\accumulation_reg[31]_i_1_n_7 ),
        .I3(quiet_carry__2_0[28]),
        .O(quiet_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry__2_i_7
       (.I0(\accumulation_reg[27]_i_1_n_4 ),
        .I1(quiet_carry__2_0[27]),
        .I2(\accumulation_reg[27]_i_1_n_5 ),
        .I3(quiet_carry__2_0[26]),
        .O(quiet_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry__2_i_8
       (.I0(\accumulation_reg[27]_i_1_n_6 ),
        .I1(quiet_carry__2_0[25]),
        .I2(\accumulation_reg[27]_i_1_n_7 ),
        .I3(quiet_carry__2_0[24]),
        .O(quiet_carry__2_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 quiet_carry__3
       (.CI(quiet_carry__2_n_0),
        .CO({NLW_quiet_carry__3_CO_UNCONNECTED[3:1],quiet}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_quiet_carry__3_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,1'b0,quiet_carry__3_i_1_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    quiet_carry__3_i_1
       (.I0(p_0_in),
        .O(quiet_carry__3_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry_i_1
       (.I0(quiet_carry__2_0[7]),
        .I1(\accumulation_reg[7]_i_1_n_4 ),
        .I2(quiet_carry__2_0[6]),
        .I3(\accumulation_reg[7]_i_1_n_5 ),
        .O(quiet_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry_i_2
       (.I0(quiet_carry__2_0[5]),
        .I1(\accumulation_reg[7]_i_1_n_6 ),
        .I2(quiet_carry__2_0[4]),
        .I3(\accumulation_reg[7]_i_1_n_7 ),
        .O(quiet_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry_i_3
       (.I0(quiet_carry__2_0[3]),
        .I1(\accumulation_reg[3]_i_1_n_4 ),
        .I2(quiet_carry__2_0[2]),
        .I3(\accumulation_reg[3]_i_1_n_5 ),
        .O(quiet_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    quiet_carry_i_4
       (.I0(quiet_carry__2_0[1]),
        .I1(\accumulation_reg[3]_i_1_n_6 ),
        .I2(quiet_carry__2_0[0]),
        .I3(\accumulation_reg[3]_i_1_n_7 ),
        .O(quiet_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry_i_5
       (.I0(\accumulation_reg[7]_i_1_n_4 ),
        .I1(quiet_carry__2_0[7]),
        .I2(\accumulation_reg[7]_i_1_n_5 ),
        .I3(quiet_carry__2_0[6]),
        .O(quiet_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry_i_6
       (.I0(\accumulation_reg[7]_i_1_n_6 ),
        .I1(quiet_carry__2_0[5]),
        .I2(\accumulation_reg[7]_i_1_n_7 ),
        .I3(quiet_carry__2_0[4]),
        .O(quiet_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry_i_7
       (.I0(\accumulation_reg[3]_i_1_n_4 ),
        .I1(quiet_carry__2_0[3]),
        .I2(\accumulation_reg[3]_i_1_n_5 ),
        .I3(quiet_carry__2_0[2]),
        .O(quiet_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    quiet_carry_i_8
       (.I0(\accumulation_reg[3]_i_1_n_6 ),
        .I1(quiet_carry__2_0[1]),
        .I2(\accumulation_reg[3]_i_1_n_7 ),
        .I3(quiet_carry__2_0[0]),
        .O(quiet_carry_i_8_n_0));
  LUT6 #(
    .INIT(64'h5D5D000855550808)) 
    \quiet_count[0]_i_1 
       (.I0(\candidate_count[2]_i_3_n_0 ),
        .I1(quiet),
        .I2(status[4]),
        .I3(\quiet_count_reg_n_0_[1] ),
        .I4(\quiet_count_reg_n_0_[0] ),
        .I5(\quiet_count_reg_n_0_[2] ),
        .O(\quiet_count[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h5D005D0055085D00)) 
    \quiet_count[1]_i_1 
       (.I0(\candidate_count[2]_i_3_n_0 ),
        .I1(quiet),
        .I2(status[4]),
        .I3(\quiet_count_reg_n_0_[1] ),
        .I4(\quiet_count_reg_n_0_[0] ),
        .I5(\quiet_count_reg_n_0_[2] ),
        .O(\quiet_count[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h5D5D5D5D08000000)) 
    \quiet_count[2]_i_1 
       (.I0(\candidate_count[2]_i_3_n_0 ),
        .I1(quiet),
        .I2(status[4]),
        .I3(\quiet_count_reg_n_0_[1] ),
        .I4(\quiet_count_reg_n_0_[0] ),
        .I5(\quiet_count_reg_n_0_[2] ),
        .O(\quiet_count[2]_i_1_n_0 ));
  FDRE \quiet_count_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\quiet_count[0]_i_1_n_0 ),
        .Q(\quiet_count_reg_n_0_[0] ),
        .R(\state[1]_i_1_n_0 ));
  FDRE \quiet_count_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\quiet_count[1]_i_1_n_0 ),
        .Q(\quiet_count_reg_n_0_[1] ),
        .R(\state[1]_i_1_n_0 ));
  FDRE \quiet_count_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\quiet_count[2]_i_1_n_0 ),
        .Q(\quiet_count_reg_n_0_[2] ),
        .R(\state[1]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \s_axi_bresp[1]_i_1 
       (.I0(s_axi_aresetn),
        .O(s_axi_aresetn_0));
  LUT6 #(
    .INIT(64'hFF00B8000000B800)) 
    \s_axi_rdata[0]_i_1 
       (.I0(\s_axi_rdata_reg[0] ),
        .I1(\s_axi_rdata_reg[2]_2 ),
        .I2(\s_axi_rdata_reg[0]_0 ),
        .I3(\s_axi_rdata_reg[2] ),
        .I4(\s_axi_rdata_reg[2]_0 ),
        .I5(\s_axi_rdata[0]_i_4_n_0 ),
        .O(\snapshot_sequence_reg[10] [0]));
  LUT6 #(
    .INIT(64'hFC33FC33FCBBFC88)) 
    \s_axi_rdata[0]_i_4 
       (.I0(\faults_reg[0]_1 ),
        .I1(\s_axi_rdata_reg[2]_2 ),
        .I2(\s_axi_rdata[0]_i_6_n_0 ),
        .I3(\s_axi_rdata_reg[4]_2 ),
        .I4(\s_axi_rdata_reg[9] [0]),
        .I5(\s_axi_rdata_reg[4]_1 ),
        .O(\s_axi_rdata[0]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \s_axi_rdata[0]_i_6 
       (.I0(\faults_reg[7]_0 [0]),
        .I1(\s_axi_rdata_reg[4]_1 ),
        .I2(config_epoch_reg[0]),
        .O(\s_axi_rdata[0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FF2A0000)) 
    \s_axi_rdata[10]_i_1 
       (.I0(\s_axi_rdata_reg[10] ),
        .I1(\s_axi_rdata_reg[2]_2 ),
        .I2(\s_axi_rdata_reg[10]_0 ),
        .I3(\s_axi_rdata_reg[2]_0 ),
        .I4(\s_axi_rdata_reg[2] ),
        .I5(\s_axi_rdata[10]_i_4_n_0 ),
        .O(\snapshot_sequence_reg[10] [10]));
  LUT6 #(
    .INIT(64'h3ACA00003AFA0000)) 
    \s_axi_rdata[10]_i_4 
       (.I0(\s_axi_rdata_reg[10]_1 ),
        .I1(\s_axi_rdata_reg[4]_1 ),
        .I2(\s_axi_rdata_reg[2]_2 ),
        .I3(\s_axi_rdata_reg[4]_2 ),
        .I4(\s_axi_rdata_reg[2]_0 ),
        .I5(status[4]),
        .O(\s_axi_rdata[10]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \s_axi_rdata[1]_i_1 
       (.I0(\s_axi_rdata_reg[2] ),
        .I1(\s_axi_rdata[1]_i_2_n_0 ),
        .I2(\s_axi_rdata_reg[2]_0 ),
        .I3(\s_axi_rdata_reg[1] ),
        .I4(\s_axi_rdata_reg[2]_2 ),
        .I5(\s_axi_rdata_reg[1]_0 ),
        .O(\snapshot_sequence_reg[10] [1]));
  LUT6 #(
    .INIT(64'hFFFFFFFFA8080000)) 
    \s_axi_rdata[1]_i_2 
       (.I0(\s_axi_rdata_reg[4]_2 ),
        .I1(config_epoch_reg[1]),
        .I2(\s_axi_rdata_reg[4]_1 ),
        .I3(\faults_reg[7]_0 [1]),
        .I4(\s_axi_rdata_reg[1]_1 ),
        .I5(\s_axi_rdata[1]_i_5_n_0 ),
        .O(\s_axi_rdata[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040444000)) 
    \s_axi_rdata[1]_i_5 
       (.I0(\s_axi_rdata_reg[4]_2 ),
        .I1(\s_axi_rdata_reg[2]_0 ),
        .I2(status[0]),
        .I3(\s_axi_rdata_reg[2]_2 ),
        .I4(\s_axi_rdata_reg[9] [1]),
        .I5(\s_axi_rdata_reg[4]_1 ),
        .O(\s_axi_rdata[1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \s_axi_rdata[2]_i_1 
       (.I0(\s_axi_rdata_reg[2] ),
        .I1(\s_axi_rdata[2]_i_2_n_0 ),
        .I2(\s_axi_rdata_reg[2]_0 ),
        .I3(\s_axi_rdata_reg[2]_1 ),
        .I4(\s_axi_rdata_reg[2]_2 ),
        .I5(\s_axi_rdata_reg[2]_3 ),
        .O(\snapshot_sequence_reg[10] [2]));
  LUT6 #(
    .INIT(64'h00D0F0D000500050)) 
    \s_axi_rdata[2]_i_2 
       (.I0(\s_axi_rdata[2]_i_5_n_0 ),
        .I1(\s_axi_rdata_reg[9] [2]),
        .I2(\s_axi_rdata_reg[2]_0 ),
        .I3(\s_axi_rdata_reg[2]_2 ),
        .I4(\event_age[31]_i_1_n_0 ),
        .I5(\s_axi_rdata_reg[2]_4 ),
        .O(\s_axi_rdata[2]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT4 #(
    .INIT(16'h57F7)) 
    \s_axi_rdata[2]_i_5 
       (.I0(\s_axi_rdata_reg[4]_2 ),
        .I1(config_epoch_reg[2]),
        .I2(\s_axi_rdata_reg[4]_1 ),
        .I3(\faults_reg[7]_0 [2]),
        .O(\s_axi_rdata[2]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h8A8A8A8888888A88)) 
    \s_axi_rdata[3]_i_1 
       (.I0(\s_axi_rdata_reg[2] ),
        .I1(\s_axi_rdata[3]_i_2_n_0 ),
        .I2(\s_axi_rdata_reg[2]_0 ),
        .I3(\s_axi_rdata_reg[3] ),
        .I4(\s_axi_rdata_reg[2]_2 ),
        .I5(\s_axi_rdata_reg[3]_0 ),
        .O(\snapshot_sequence_reg[10] [3]));
  LUT6 #(
    .INIT(64'hFFFFFFFFA8080000)) 
    \s_axi_rdata[3]_i_2 
       (.I0(\s_axi_rdata_reg[4]_2 ),
        .I1(config_epoch_reg[3]),
        .I2(\s_axi_rdata_reg[4]_1 ),
        .I3(\faults_reg[7]_0 [3]),
        .I4(\s_axi_rdata_reg[1]_1 ),
        .I5(\s_axi_rdata_reg[3]_1 ),
        .O(\s_axi_rdata[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFB80000)) 
    \s_axi_rdata[4]_i_1 
       (.I0(\s_axi_rdata_reg[4] ),
        .I1(\s_axi_rdata_reg[2]_2 ),
        .I2(\s_axi_rdata_reg[4]_0 ),
        .I3(\s_axi_rdata_reg[2]_0 ),
        .I4(\s_axi_rdata_reg[2] ),
        .I5(\s_axi_rdata[4]_i_4_n_0 ),
        .O(\snapshot_sequence_reg[10] [4]));
  LUT6 #(
    .INIT(64'h0AFAFA3A00000000)) 
    \s_axi_rdata[4]_i_4 
       (.I0(\s_axi_rdata[4]_i_6_n_0 ),
        .I1(status[1]),
        .I2(\s_axi_rdata_reg[2]_2 ),
        .I3(\s_axi_rdata_reg[4]_1 ),
        .I4(\s_axi_rdata_reg[4]_2 ),
        .I5(\s_axi_rdata_reg[2]_0 ),
        .O(\s_axi_rdata[4]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'h5050303F)) 
    \s_axi_rdata[4]_i_6 
       (.I0(\faults_reg[7]_0 [4]),
        .I1(config_epoch_reg[4]),
        .I2(\s_axi_rdata_reg[4]_2 ),
        .I3(\s_axi_rdata_reg[9] [3]),
        .I4(\s_axi_rdata_reg[4]_1 ),
        .O(\s_axi_rdata[4]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h000002A2AAAA02A2)) 
    \s_axi_rdata[5]_i_1 
       (.I0(\s_axi_rdata_reg[2] ),
        .I1(\s_axi_rdata_reg[5] ),
        .I2(\s_axi_rdata_reg[2]_2 ),
        .I3(\s_axi_rdata_reg[5]_0 ),
        .I4(\s_axi_rdata_reg[2]_0 ),
        .I5(\s_axi_rdata[5]_i_4_n_0 ),
        .O(\snapshot_sequence_reg[10] [5]));
  LUT6 #(
    .INIT(64'h05FFBBAA05FFBBFF)) 
    \s_axi_rdata[5]_i_4 
       (.I0(\s_axi_rdata_reg[2]_2 ),
        .I1(config_epoch_reg[5]),
        .I2(\faults_reg[7]_0 [5]),
        .I3(\s_axi_rdata_reg[4]_2 ),
        .I4(\s_axi_rdata_reg[4]_1 ),
        .I5(\s_axi_rdata_reg[9] [4]),
        .O(\s_axi_rdata[5]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h000088080A0A8808)) 
    \s_axi_rdata[6]_i_1 
       (.I0(\s_axi_rdata_reg[2] ),
        .I1(\s_axi_rdata_reg[6] ),
        .I2(\s_axi_rdata_reg[2]_2 ),
        .I3(\s_axi_rdata_reg[6]_0 ),
        .I4(\s_axi_rdata_reg[2]_0 ),
        .I5(\s_axi_rdata[6]_i_4_n_0 ),
        .O(\snapshot_sequence_reg[10] [6]));
  LUT5 #(
    .INIT(32'h5050303F)) 
    \s_axi_rdata[6]_i_4 
       (.I0(\faults_reg[7]_0 [6]),
        .I1(config_epoch_reg[6]),
        .I2(\s_axi_rdata_reg[4]_2 ),
        .I3(\s_axi_rdata_reg[9] [5]),
        .I4(\s_axi_rdata_reg[4]_1 ),
        .O(\s_axi_rdata[6]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00200A2A00200222)) 
    \s_axi_rdata[7]_i_1 
       (.I0(\s_axi_rdata_reg[2] ),
        .I1(\s_axi_rdata_reg[2]_2 ),
        .I2(\s_axi_rdata_reg[2]_0 ),
        .I3(\s_axi_rdata[7]_i_2_n_0 ),
        .I4(\s_axi_rdata_reg[7] ),
        .I5(\s_axi_rdata_reg[7]_0 ),
        .O(\snapshot_sequence_reg[10] [7]));
  LUT5 #(
    .INIT(32'h5050303F)) 
    \s_axi_rdata[7]_i_2 
       (.I0(\faults_reg[7]_0 [7]),
        .I1(config_epoch_reg[7]),
        .I2(\s_axi_rdata_reg[4]_2 ),
        .I3(\s_axi_rdata_reg[9] [6]),
        .I4(\s_axi_rdata_reg[4]_1 ),
        .O(\s_axi_rdata[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hA8AA88AAA8888888)) 
    \s_axi_rdata[8]_i_1 
       (.I0(\s_axi_rdata_reg[2] ),
        .I1(\s_axi_rdata_reg[8] ),
        .I2(status[2]),
        .I3(\s_axi_rdata_reg[2]_0 ),
        .I4(\s_axi_rdata_reg[8]_0 ),
        .I5(\s_axi_rdata_reg[8]_1 ),
        .O(\snapshot_sequence_reg[10] [8]));
  LUT6 #(
    .INIT(64'hAAAAA8080000A808)) 
    \s_axi_rdata[9]_i_1 
       (.I0(\s_axi_rdata_reg[2] ),
        .I1(\s_axi_rdata_reg[9]_0 ),
        .I2(\s_axi_rdata_reg[2]_2 ),
        .I3(\s_axi_rdata_reg[9]_1 ),
        .I4(\s_axi_rdata_reg[2]_0 ),
        .I5(\s_axi_rdata[9]_i_4_n_0 ),
        .O(\snapshot_sequence_reg[10] [9]));
  LUT6 #(
    .INIT(64'h000000F000FFAACC)) 
    \s_axi_rdata[9]_i_4 
       (.I0(config_epoch_reg[9]),
        .I1(\s_axi_rdata_reg[9] [7]),
        .I2(status[3]),
        .I3(\s_axi_rdata_reg[4]_2 ),
        .I4(\s_axi_rdata_reg[4]_1 ),
        .I5(\s_axi_rdata_reg[2]_2 ),
        .O(\s_axi_rdata[9]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hFFBFBFBF)) 
    \sample_age[0]_i_1 
       (.I0(configure),
        .I1(s_axi_aresetn),
        .I2(\faults_reg[0]_1 ),
        .I3(\event_age[31]_i_1_n_0 ),
        .I4(pcm_valid),
        .O(\sample_age[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \sample_age[0]_i_2 
       (.I0(\event_age[31]_i_1_n_0 ),
        .I1(\sample_age[0]_i_3_n_0 ),
        .O(sample_age));
  LUT5 #(
    .INIT(32'hA8AA8888)) 
    \sample_age[0]_i_3 
       (.I0(\sample_age[0]_i_4_n_0 ),
        .I1(sample_age_reg[15]),
        .I2(\sample_age[0]_i_5_n_0 ),
        .I3(\sample_age[0]_i_6_n_0 ),
        .I4(sample_age_reg[14]),
        .O(\sample_age[0]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \sample_age[0]_i_4 
       (.I0(sample_age_reg[16]),
        .I1(sample_age_reg[19]),
        .I2(sample_age_reg[17]),
        .I3(sample_age_reg[18]),
        .O(\sample_age[0]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \sample_age[0]_i_5 
       (.I0(sample_age_reg[11]),
        .I1(sample_age_reg[12]),
        .I2(sample_age_reg[10]),
        .I3(sample_age_reg[13]),
        .O(\sample_age[0]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h5557)) 
    \sample_age[0]_i_6 
       (.I0(sample_age_reg[9]),
        .I1(sample_age_reg[7]),
        .I2(sample_age_reg[6]),
        .I3(sample_age_reg[8]),
        .O(\sample_age[0]_i_6_n_0 ));
  FDRE \sample_age_reg[0] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry_n_7 ),
        .Q(sample_age_reg[0]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[10] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__1_n_5 ),
        .Q(sample_age_reg[10]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[11] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__1_n_4 ),
        .Q(sample_age_reg[11]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[12] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__2_n_7 ),
        .Q(sample_age_reg[12]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[13] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__2_n_6 ),
        .Q(sample_age_reg[13]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[14] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__2_n_5 ),
        .Q(sample_age_reg[14]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[15] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__2_n_4 ),
        .Q(sample_age_reg[15]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[16] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__3_n_7 ),
        .Q(sample_age_reg[16]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[17] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__3_n_6 ),
        .Q(sample_age_reg[17]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[18] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__3_n_5 ),
        .Q(sample_age_reg[18]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[19] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__3_n_4 ),
        .Q(sample_age_reg[19]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[1] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry_n_6 ),
        .Q(sample_age_reg[1]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[2] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry_n_5 ),
        .Q(sample_age_reg[2]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[3] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry_n_4 ),
        .Q(sample_age_reg[3]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[4] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__0_n_7 ),
        .Q(sample_age_reg[4]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[5] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__0_n_6 ),
        .Q(sample_age_reg[5]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[6] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__0_n_5 ),
        .Q(sample_age_reg[6]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[7] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__0_n_4 ),
        .Q(sample_age_reg[7]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[8] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__1_n_7 ),
        .Q(sample_age_reg[8]),
        .R(\sample_age[0]_i_1_n_0 ));
  FDRE \sample_age_reg[9] 
       (.C(s_axi_aclk),
        .CE(sample_age),
        .D(\i_/i_/i__carry__1_n_6 ),
        .Q(sample_age_reg[9]),
        .R(\sample_age[0]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0080)) 
    \sample_count[0]_i_1 
       (.I0(filtered_valid),
        .I1(\event_age[31]_i_1_n_0 ),
        .I2(\faults_reg[0]_1 ),
        .I3(configure),
        .O(\sample_count[0]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \sample_count[0]_i_3 
       (.I0(out[0]),
        .O(\sample_count[0]_i_3_n_0 ));
  FDRE \sample_count_reg[0] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[0]_i_2_n_7 ),
        .Q(out[0]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[0]_i_2 
       (.CI(1'b0),
        .CO({\sample_count_reg[0]_i_2_n_0 ,\sample_count_reg[0]_i_2_n_1 ,\sample_count_reg[0]_i_2_n_2 ,\sample_count_reg[0]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\sample_count_reg[0]_i_2_n_4 ,\sample_count_reg[0]_i_2_n_5 ,\sample_count_reg[0]_i_2_n_6 ,\sample_count_reg[0]_i_2_n_7 }),
        .S({out[3:1],\sample_count[0]_i_3_n_0 }));
  FDRE \sample_count_reg[10] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[8]_i_1_n_5 ),
        .Q(out[10]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[11] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[8]_i_1_n_4 ),
        .Q(out[11]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[12] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[12]_i_1_n_7 ),
        .Q(out[12]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[12]_i_1 
       (.CI(\sample_count_reg[8]_i_1_n_0 ),
        .CO({\sample_count_reg[12]_i_1_n_0 ,\sample_count_reg[12]_i_1_n_1 ,\sample_count_reg[12]_i_1_n_2 ,\sample_count_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[12]_i_1_n_4 ,\sample_count_reg[12]_i_1_n_5 ,\sample_count_reg[12]_i_1_n_6 ,\sample_count_reg[12]_i_1_n_7 }),
        .S(out[15:12]));
  FDRE \sample_count_reg[13] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[12]_i_1_n_6 ),
        .Q(out[13]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[14] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[12]_i_1_n_5 ),
        .Q(out[14]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[15] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[12]_i_1_n_4 ),
        .Q(out[15]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[16] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[16]_i_1_n_7 ),
        .Q(out[16]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[16]_i_1 
       (.CI(\sample_count_reg[12]_i_1_n_0 ),
        .CO({\sample_count_reg[16]_i_1_n_0 ,\sample_count_reg[16]_i_1_n_1 ,\sample_count_reg[16]_i_1_n_2 ,\sample_count_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[16]_i_1_n_4 ,\sample_count_reg[16]_i_1_n_5 ,\sample_count_reg[16]_i_1_n_6 ,\sample_count_reg[16]_i_1_n_7 }),
        .S(out[19:16]));
  FDRE \sample_count_reg[17] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[16]_i_1_n_6 ),
        .Q(out[17]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[18] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[16]_i_1_n_5 ),
        .Q(out[18]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[19] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[16]_i_1_n_4 ),
        .Q(out[19]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[1] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[0]_i_2_n_6 ),
        .Q(out[1]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[20] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[20]_i_1_n_7 ),
        .Q(out[20]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[20]_i_1 
       (.CI(\sample_count_reg[16]_i_1_n_0 ),
        .CO({\sample_count_reg[20]_i_1_n_0 ,\sample_count_reg[20]_i_1_n_1 ,\sample_count_reg[20]_i_1_n_2 ,\sample_count_reg[20]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[20]_i_1_n_4 ,\sample_count_reg[20]_i_1_n_5 ,\sample_count_reg[20]_i_1_n_6 ,\sample_count_reg[20]_i_1_n_7 }),
        .S(out[23:20]));
  FDRE \sample_count_reg[21] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[20]_i_1_n_6 ),
        .Q(out[21]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[22] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[20]_i_1_n_5 ),
        .Q(out[22]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[23] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[20]_i_1_n_4 ),
        .Q(out[23]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[24] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[24]_i_1_n_7 ),
        .Q(out[24]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[24]_i_1 
       (.CI(\sample_count_reg[20]_i_1_n_0 ),
        .CO({\sample_count_reg[24]_i_1_n_0 ,\sample_count_reg[24]_i_1_n_1 ,\sample_count_reg[24]_i_1_n_2 ,\sample_count_reg[24]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[24]_i_1_n_4 ,\sample_count_reg[24]_i_1_n_5 ,\sample_count_reg[24]_i_1_n_6 ,\sample_count_reg[24]_i_1_n_7 }),
        .S(out[27:24]));
  FDRE \sample_count_reg[25] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[24]_i_1_n_6 ),
        .Q(out[25]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[26] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[24]_i_1_n_5 ),
        .Q(out[26]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[27] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[24]_i_1_n_4 ),
        .Q(out[27]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[28] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[28]_i_1_n_7 ),
        .Q(out[28]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[28]_i_1 
       (.CI(\sample_count_reg[24]_i_1_n_0 ),
        .CO({\sample_count_reg[28]_i_1_n_0 ,\sample_count_reg[28]_i_1_n_1 ,\sample_count_reg[28]_i_1_n_2 ,\sample_count_reg[28]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[28]_i_1_n_4 ,\sample_count_reg[28]_i_1_n_5 ,\sample_count_reg[28]_i_1_n_6 ,\sample_count_reg[28]_i_1_n_7 }),
        .S(out[31:28]));
  FDRE \sample_count_reg[29] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[28]_i_1_n_6 ),
        .Q(out[29]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[2] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[0]_i_2_n_5 ),
        .Q(out[2]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[30] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[28]_i_1_n_5 ),
        .Q(out[30]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[31] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[28]_i_1_n_4 ),
        .Q(out[31]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[32] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[32]_i_1_n_7 ),
        .Q(out[32]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[32]_i_1 
       (.CI(\sample_count_reg[28]_i_1_n_0 ),
        .CO({\sample_count_reg[32]_i_1_n_0 ,\sample_count_reg[32]_i_1_n_1 ,\sample_count_reg[32]_i_1_n_2 ,\sample_count_reg[32]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[32]_i_1_n_4 ,\sample_count_reg[32]_i_1_n_5 ,\sample_count_reg[32]_i_1_n_6 ,\sample_count_reg[32]_i_1_n_7 }),
        .S(out[35:32]));
  FDRE \sample_count_reg[33] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[32]_i_1_n_6 ),
        .Q(out[33]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[34] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[32]_i_1_n_5 ),
        .Q(out[34]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[35] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[32]_i_1_n_4 ),
        .Q(out[35]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[36] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[36]_i_1_n_7 ),
        .Q(out[36]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[36]_i_1 
       (.CI(\sample_count_reg[32]_i_1_n_0 ),
        .CO({\sample_count_reg[36]_i_1_n_0 ,\sample_count_reg[36]_i_1_n_1 ,\sample_count_reg[36]_i_1_n_2 ,\sample_count_reg[36]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[36]_i_1_n_4 ,\sample_count_reg[36]_i_1_n_5 ,\sample_count_reg[36]_i_1_n_6 ,\sample_count_reg[36]_i_1_n_7 }),
        .S(out[39:36]));
  FDRE \sample_count_reg[37] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[36]_i_1_n_6 ),
        .Q(out[37]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[38] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[36]_i_1_n_5 ),
        .Q(out[38]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[39] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[36]_i_1_n_4 ),
        .Q(out[39]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[3] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[0]_i_2_n_4 ),
        .Q(out[3]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[40] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[40]_i_1_n_7 ),
        .Q(out[40]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[40]_i_1 
       (.CI(\sample_count_reg[36]_i_1_n_0 ),
        .CO({\sample_count_reg[40]_i_1_n_0 ,\sample_count_reg[40]_i_1_n_1 ,\sample_count_reg[40]_i_1_n_2 ,\sample_count_reg[40]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[40]_i_1_n_4 ,\sample_count_reg[40]_i_1_n_5 ,\sample_count_reg[40]_i_1_n_6 ,\sample_count_reg[40]_i_1_n_7 }),
        .S(out[43:40]));
  FDRE \sample_count_reg[41] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[40]_i_1_n_6 ),
        .Q(out[41]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[42] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[40]_i_1_n_5 ),
        .Q(out[42]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[43] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[40]_i_1_n_4 ),
        .Q(out[43]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[44] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[44]_i_1_n_7 ),
        .Q(out[44]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[44]_i_1 
       (.CI(\sample_count_reg[40]_i_1_n_0 ),
        .CO({\sample_count_reg[44]_i_1_n_0 ,\sample_count_reg[44]_i_1_n_1 ,\sample_count_reg[44]_i_1_n_2 ,\sample_count_reg[44]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[44]_i_1_n_4 ,\sample_count_reg[44]_i_1_n_5 ,\sample_count_reg[44]_i_1_n_6 ,\sample_count_reg[44]_i_1_n_7 }),
        .S(out[47:44]));
  FDRE \sample_count_reg[45] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[44]_i_1_n_6 ),
        .Q(out[45]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[46] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[44]_i_1_n_5 ),
        .Q(out[46]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[47] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[44]_i_1_n_4 ),
        .Q(out[47]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[48] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[48]_i_1_n_7 ),
        .Q(out[48]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[48]_i_1 
       (.CI(\sample_count_reg[44]_i_1_n_0 ),
        .CO({\sample_count_reg[48]_i_1_n_0 ,\sample_count_reg[48]_i_1_n_1 ,\sample_count_reg[48]_i_1_n_2 ,\sample_count_reg[48]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[48]_i_1_n_4 ,\sample_count_reg[48]_i_1_n_5 ,\sample_count_reg[48]_i_1_n_6 ,\sample_count_reg[48]_i_1_n_7 }),
        .S(out[51:48]));
  FDRE \sample_count_reg[49] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[48]_i_1_n_6 ),
        .Q(out[49]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[4] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[4]_i_1_n_7 ),
        .Q(out[4]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[4]_i_1 
       (.CI(\sample_count_reg[0]_i_2_n_0 ),
        .CO({\sample_count_reg[4]_i_1_n_0 ,\sample_count_reg[4]_i_1_n_1 ,\sample_count_reg[4]_i_1_n_2 ,\sample_count_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[4]_i_1_n_4 ,\sample_count_reg[4]_i_1_n_5 ,\sample_count_reg[4]_i_1_n_6 ,\sample_count_reg[4]_i_1_n_7 }),
        .S(out[7:4]));
  FDRE \sample_count_reg[50] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[48]_i_1_n_5 ),
        .Q(out[50]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[51] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[48]_i_1_n_4 ),
        .Q(out[51]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[52] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[52]_i_1_n_7 ),
        .Q(out[52]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[52]_i_1 
       (.CI(\sample_count_reg[48]_i_1_n_0 ),
        .CO({\sample_count_reg[52]_i_1_n_0 ,\sample_count_reg[52]_i_1_n_1 ,\sample_count_reg[52]_i_1_n_2 ,\sample_count_reg[52]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[52]_i_1_n_4 ,\sample_count_reg[52]_i_1_n_5 ,\sample_count_reg[52]_i_1_n_6 ,\sample_count_reg[52]_i_1_n_7 }),
        .S(out[55:52]));
  FDRE \sample_count_reg[53] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[52]_i_1_n_6 ),
        .Q(out[53]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[54] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[52]_i_1_n_5 ),
        .Q(out[54]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[55] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[52]_i_1_n_4 ),
        .Q(out[55]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[56] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[56]_i_1_n_7 ),
        .Q(out[56]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[56]_i_1 
       (.CI(\sample_count_reg[52]_i_1_n_0 ),
        .CO({\sample_count_reg[56]_i_1_n_0 ,\sample_count_reg[56]_i_1_n_1 ,\sample_count_reg[56]_i_1_n_2 ,\sample_count_reg[56]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[56]_i_1_n_4 ,\sample_count_reg[56]_i_1_n_5 ,\sample_count_reg[56]_i_1_n_6 ,\sample_count_reg[56]_i_1_n_7 }),
        .S(out[59:56]));
  FDRE \sample_count_reg[57] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[56]_i_1_n_6 ),
        .Q(out[57]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[58] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[56]_i_1_n_5 ),
        .Q(out[58]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[59] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[56]_i_1_n_4 ),
        .Q(out[59]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[5] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[4]_i_1_n_6 ),
        .Q(out[5]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[60] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[60]_i_1_n_7 ),
        .Q(out[60]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[60]_i_1 
       (.CI(\sample_count_reg[56]_i_1_n_0 ),
        .CO({\NLW_sample_count_reg[60]_i_1_CO_UNCONNECTED [3],\sample_count_reg[60]_i_1_n_1 ,\sample_count_reg[60]_i_1_n_2 ,\sample_count_reg[60]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[60]_i_1_n_4 ,\sample_count_reg[60]_i_1_n_5 ,\sample_count_reg[60]_i_1_n_6 ,\sample_count_reg[60]_i_1_n_7 }),
        .S(out[63:60]));
  FDRE \sample_count_reg[61] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[60]_i_1_n_6 ),
        .Q(out[61]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[62] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[60]_i_1_n_5 ),
        .Q(out[62]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[63] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[60]_i_1_n_4 ),
        .Q(out[63]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[6] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[4]_i_1_n_5 ),
        .Q(out[6]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[7] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[4]_i_1_n_4 ),
        .Q(out[7]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \sample_count_reg[8] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[8]_i_1_n_7 ),
        .Q(out[8]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \sample_count_reg[8]_i_1 
       (.CI(\sample_count_reg[4]_i_1_n_0 ),
        .CO({\sample_count_reg[8]_i_1_n_0 ,\sample_count_reg[8]_i_1_n_1 ,\sample_count_reg[8]_i_1_n_2 ,\sample_count_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\sample_count_reg[8]_i_1_n_4 ,\sample_count_reg[8]_i_1_n_5 ,\sample_count_reg[8]_i_1_n_6 ,\sample_count_reg[8]_i_1_n_7 }),
        .S(out[11:8]));
  FDRE \sample_count_reg[9] 
       (.C(s_axi_aclk),
        .CE(\sample_count[0]_i_1_n_0 ),
        .D(\sample_count_reg[8]_i_1_n_6 ),
        .Q(out[9]),
        .R(\last_sum[31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFFFEFF)) 
    \sample_in_window[0]_i_1 
       (.I0(\sample_in_window_reg_n_0_[1] ),
        .I1(\sample_in_window_reg_n_0_[2] ),
        .I2(\sample_in_window[0]_i_2_n_0 ),
        .I3(\sample_in_window_reg_n_0_[9] ),
        .I4(\sample_in_window_reg_n_0_[3] ),
        .I5(\sample_in_window_reg_n_0_[0] ),
        .O(sample_in_window[0]));
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    \sample_in_window[0]_i_2 
       (.I0(\sample_in_window_reg_n_0_[8] ),
        .I1(\sample_in_window_reg_n_0_[7] ),
        .I2(\sample_in_window_reg_n_0_[4] ),
        .I3(\sample_in_window_reg_n_0_[6] ),
        .I4(\sample_in_window_reg_n_0_[5] ),
        .O(\sample_in_window[0]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \sample_in_window[1]_i_1 
       (.I0(\sample_in_window_reg_n_0_[1] ),
        .I1(\sample_in_window_reg_n_0_[0] ),
        .O(sample_in_window[1]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \sample_in_window[2]_i_1 
       (.I0(\sample_in_window_reg_n_0_[2] ),
        .I1(\sample_in_window_reg_n_0_[0] ),
        .I2(\sample_in_window_reg_n_0_[1] ),
        .O(sample_in_window[2]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \sample_in_window[3]_i_1 
       (.I0(\sample_in_window_reg_n_0_[3] ),
        .I1(\sample_in_window_reg_n_0_[1] ),
        .I2(\sample_in_window_reg_n_0_[0] ),
        .I3(\sample_in_window_reg_n_0_[2] ),
        .O(sample_in_window[3]));
  LUT6 #(
    .INIT(64'h000000007FFF8000)) 
    \sample_in_window[4]_i_1 
       (.I0(\sample_in_window_reg_n_0_[3] ),
        .I1(\sample_in_window_reg_n_0_[1] ),
        .I2(\sample_in_window_reg_n_0_[0] ),
        .I3(\sample_in_window_reg_n_0_[2] ),
        .I4(\sample_in_window_reg_n_0_[4] ),
        .I5(\clipped_count[15]_i_4_n_0 ),
        .O(sample_in_window[4]));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \sample_in_window[5]_i_1 
       (.I0(\sample_in_window_reg_n_0_[5] ),
        .I1(\sample_in_window_reg_n_0_[2] ),
        .I2(\sample_in_window_reg_n_0_[0] ),
        .I3(\sample_in_window_reg_n_0_[1] ),
        .I4(\sample_in_window_reg_n_0_[4] ),
        .I5(\sample_in_window_reg_n_0_[3] ),
        .O(sample_in_window[5]));
  LUT6 #(
    .INIT(64'h1444444444444444)) 
    \sample_in_window[6]_i_1 
       (.I0(\clipped_count[15]_i_4_n_0 ),
        .I1(\sample_in_window_reg_n_0_[6] ),
        .I2(\sample_in_window[6]_i_2_n_0 ),
        .I3(\sample_in_window_reg_n_0_[4] ),
        .I4(\sample_in_window_reg_n_0_[3] ),
        .I5(\sample_in_window_reg_n_0_[5] ),
        .O(sample_in_window[6]));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \sample_in_window[6]_i_2 
       (.I0(\sample_in_window_reg_n_0_[2] ),
        .I1(\sample_in_window_reg_n_0_[0] ),
        .I2(\sample_in_window_reg_n_0_[1] ),
        .O(\sample_in_window[6]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'h14)) 
    \sample_in_window[7]_i_1 
       (.I0(\clipped_count[15]_i_4_n_0 ),
        .I1(\sample_in_window_reg_n_0_[7] ),
        .I2(\sample_in_window[9]_i_4_n_0 ),
        .O(sample_in_window[7]));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT4 #(
    .INIT(16'h0078)) 
    \sample_in_window[8]_i_1 
       (.I0(\sample_in_window[9]_i_4_n_0 ),
        .I1(\sample_in_window_reg_n_0_[7] ),
        .I2(\sample_in_window_reg_n_0_[8] ),
        .I3(\clipped_count[15]_i_4_n_0 ),
        .O(sample_in_window[8]));
  LUT3 #(
    .INIT(8'hBF)) 
    \sample_in_window[9]_i_1 
       (.I0(configure),
        .I1(s_axi_aresetn),
        .I2(\faults_reg[0]_1 ),
        .O(\sample_in_window[9]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'h58888888)) 
    \sample_in_window[9]_i_2 
       (.I0(\sample_in_window_reg_n_0_[9] ),
        .I1(\sample_in_window[9]_i_3_n_0 ),
        .I2(\sample_in_window_reg_n_0_[8] ),
        .I3(\sample_in_window_reg_n_0_[7] ),
        .I4(\sample_in_window[9]_i_4_n_0 ),
        .O(sample_in_window[9]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFEA)) 
    \sample_in_window[9]_i_3 
       (.I0(\sample_in_window[0]_i_2_n_0 ),
        .I1(\sample_in_window_reg_n_0_[4] ),
        .I2(\sample_in_window_reg_n_0_[3] ),
        .I3(\sample_in_window_reg_n_0_[2] ),
        .I4(\sample_in_window_reg_n_0_[0] ),
        .I5(\sample_in_window_reg_n_0_[1] ),
        .O(\sample_in_window[9]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h80000000)) 
    \sample_in_window[9]_i_4 
       (.I0(\sample_in_window_reg_n_0_[5] ),
        .I1(\sample_in_window_reg_n_0_[3] ),
        .I2(\sample_in_window_reg_n_0_[4] ),
        .I3(\sample_in_window[6]_i_2_n_0 ),
        .I4(\sample_in_window_reg_n_0_[6] ),
        .O(\sample_in_window[9]_i_4_n_0 ));
  FDRE \sample_in_window_reg[0] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(sample_in_window[0]),
        .Q(\sample_in_window_reg_n_0_[0] ),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \sample_in_window_reg[1] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(sample_in_window[1]),
        .Q(\sample_in_window_reg_n_0_[1] ),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \sample_in_window_reg[2] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(sample_in_window[2]),
        .Q(\sample_in_window_reg_n_0_[2] ),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \sample_in_window_reg[3] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(sample_in_window[3]),
        .Q(\sample_in_window_reg_n_0_[3] ),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \sample_in_window_reg[4] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(sample_in_window[4]),
        .Q(\sample_in_window_reg_n_0_[4] ),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \sample_in_window_reg[5] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(sample_in_window[5]),
        .Q(\sample_in_window_reg_n_0_[5] ),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \sample_in_window_reg[6] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(sample_in_window[6]),
        .Q(\sample_in_window_reg_n_0_[6] ),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \sample_in_window_reg[7] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(sample_in_window[7]),
        .Q(\sample_in_window_reg_n_0_[7] ),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \sample_in_window_reg[8] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(sample_in_window[8]),
        .Q(\sample_in_window_reg_n_0_[8] ),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \sample_in_window_reg[9] 
       (.C(s_axi_aclk),
        .CE(\clipped_count[15]_i_2_n_0 ),
        .D(sample_in_window[9]),
        .Q(\sample_in_window_reg_n_0_[9] ),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \scaled_latched_reg[10] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[2]),
        .Q(scaled_latched[10]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[11] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[3]),
        .Q(scaled_latched[11]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[12] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[4]),
        .Q(scaled_latched[12]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[13] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[5]),
        .Q(scaled_latched[13]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[14] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[6]),
        .Q(scaled_latched[14]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[15] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[7]),
        .Q(scaled_latched[15]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[16] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[8]),
        .Q(scaled_latched[16]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[17] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[9]),
        .Q(scaled_latched[17]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[18] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[10]),
        .Q(scaled_latched[18]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[19] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[11]),
        .Q(scaled_latched[19]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[20] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[12]),
        .Q(scaled_latched[20]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[21] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[13]),
        .Q(scaled_latched[21]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[22] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[14]),
        .Q(scaled_latched[22]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[24] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[15]),
        .Q(scaled_latched[24]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[8] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[0]),
        .Q(scaled_latched[8]),
        .R(dc_level0));
  FDRE \scaled_latched_reg[9] 
       (.C(s_axi_aclk),
        .CE(scaled_latched0),
        .D(D[1]),
        .Q(scaled_latched[9]),
        .R(dc_level0));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \snapshot[0][2]_i_1 
       (.I0(\event_age[31]_i_1_n_0 ),
        .O(\faults_reg[0]_0 ));
  LUT6 #(
    .INIT(64'h00000000AABAAA8A)) 
    snapshot_valid_i_1
       (.I0(snapshot_valid),
        .I1(snapshot_valid_reg_0),
        .I2(snapshot_valid_reg_1),
        .I3(snapshot_valid_reg_2),
        .I4(snapshot_valid_reg_3),
        .I5(dc_level0),
        .O(snapshot_valid_reg));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT3 #(
    .INIT(8'h4F)) 
    \soft_count[0]_i_1 
       (.I0(\soft_count_reg_n_0_[0] ),
        .I1(p_1_in),
        .I2(status[3]),
        .O(\soft_count[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT4 #(
    .INIT(16'h2800)) 
    \soft_count[1]_i_1 
       (.I0(status[3]),
        .I1(\soft_count_reg_n_0_[1] ),
        .I2(\soft_count_reg_n_0_[0] ),
        .I3(p_1_in),
        .O(\soft_count[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'h28880000)) 
    \soft_count[2]_i_1 
       (.I0(status[3]),
        .I1(\soft_count_reg_n_0_[2] ),
        .I2(\soft_count_reg_n_0_[0] ),
        .I3(\soft_count_reg_n_0_[1] ),
        .I4(p_1_in),
        .O(\soft_count[2]_i_1_n_0 ));
  FDRE \soft_count_reg[0] 
       (.C(s_axi_aclk),
        .CE(soft_count),
        .D(\soft_count[0]_i_1_n_0 ),
        .Q(\soft_count_reg_n_0_[0] ),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \soft_count_reg[1] 
       (.C(s_axi_aclk),
        .CE(soft_count),
        .D(\soft_count[1]_i_1_n_0 ),
        .Q(\soft_count_reg_n_0_[1] ),
        .R(\sample_in_window[9]_i_1_n_0 ));
  FDRE \soft_count_reg[2] 
       (.C(s_axi_aclk),
        .CE(soft_count),
        .D(\soft_count[2]_i_1_n_0 ),
        .Q(\soft_count_reg_n_0_[2] ),
        .R(\sample_in_window[9]_i_1_n_0 ));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 state2_carry
       (.CI(1'b0),
        .CO({state2_carry_n_0,state2_carry_n_1,state2_carry_n_2,state2_carry_n_3}),
        .CYINIT(1'b1),
        .DI({state2_carry_i_1_n_0,state2_carry_i_2_n_0,state2_carry_i_3_n_0,state2_carry_i_4_n_0}),
        .O(NLW_state2_carry_O_UNCONNECTED[3:0]),
        .S({state2_carry_i_5_n_0,state2_carry_i_6_n_0,state2_carry_i_7_n_0,state2_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 state2_carry__0
       (.CI(state2_carry_n_0),
        .CO({state2_carry__0_n_0,state2_carry__0_n_1,state2_carry__0_n_2,state2_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({state2_carry__0_i_1_n_0,state2_carry__0_i_2_n_0,state2_carry__0_i_3_n_0,state2_carry__0_i_4_n_0}),
        .O(NLW_state2_carry__0_O_UNCONNECTED[3:0]),
        .S({state2_carry__0_i_5_n_0,state2_carry__0_i_6_n_0,state2_carry__0_i_7_n_0,state2_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry__0_i_1
       (.I0(\faults[7]_i_10_0 [15]),
        .I1(quiet_carry__2_0[15]),
        .I2(quiet_carry__2_0[14]),
        .I3(\faults[7]_i_10_0 [14]),
        .O(state2_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry__0_i_2
       (.I0(\faults[7]_i_10_0 [13]),
        .I1(quiet_carry__2_0[13]),
        .I2(quiet_carry__2_0[12]),
        .I3(\faults[7]_i_10_0 [12]),
        .O(state2_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry__0_i_3
       (.I0(\faults[7]_i_10_0 [11]),
        .I1(quiet_carry__2_0[11]),
        .I2(quiet_carry__2_0[10]),
        .I3(\faults[7]_i_10_0 [10]),
        .O(state2_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry__0_i_4
       (.I0(\faults[7]_i_10_0 [9]),
        .I1(quiet_carry__2_0[9]),
        .I2(quiet_carry__2_0[8]),
        .I3(\faults[7]_i_10_0 [8]),
        .O(state2_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry__0_i_5
       (.I0(quiet_carry__2_0[15]),
        .I1(\faults[7]_i_10_0 [15]),
        .I2(quiet_carry__2_0[14]),
        .I3(\faults[7]_i_10_0 [14]),
        .O(state2_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry__0_i_6
       (.I0(quiet_carry__2_0[13]),
        .I1(\faults[7]_i_10_0 [13]),
        .I2(quiet_carry__2_0[12]),
        .I3(\faults[7]_i_10_0 [12]),
        .O(state2_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry__0_i_7
       (.I0(quiet_carry__2_0[11]),
        .I1(\faults[7]_i_10_0 [11]),
        .I2(quiet_carry__2_0[10]),
        .I3(\faults[7]_i_10_0 [10]),
        .O(state2_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry__0_i_8
       (.I0(quiet_carry__2_0[9]),
        .I1(\faults[7]_i_10_0 [9]),
        .I2(quiet_carry__2_0[8]),
        .I3(\faults[7]_i_10_0 [8]),
        .O(state2_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 state2_carry__1
       (.CI(state2_carry__0_n_0),
        .CO({state2_carry__1_n_0,state2_carry__1_n_1,state2_carry__1_n_2,state2_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({state2_carry__1_i_1_n_0,state2_carry__1_i_2_n_0,state2_carry__1_i_3_n_0,state2_carry__1_i_4_n_0}),
        .O(NLW_state2_carry__1_O_UNCONNECTED[3:0]),
        .S({state2_carry__1_i_5_n_0,state2_carry__1_i_6_n_0,state2_carry__1_i_7_n_0,state2_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry__1_i_1
       (.I0(\faults[7]_i_10_0 [23]),
        .I1(quiet_carry__2_0[23]),
        .I2(quiet_carry__2_0[22]),
        .I3(\faults[7]_i_10_0 [22]),
        .O(state2_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry__1_i_2
       (.I0(\faults[7]_i_10_0 [21]),
        .I1(quiet_carry__2_0[21]),
        .I2(quiet_carry__2_0[20]),
        .I3(\faults[7]_i_10_0 [20]),
        .O(state2_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry__1_i_3
       (.I0(\faults[7]_i_10_0 [19]),
        .I1(quiet_carry__2_0[19]),
        .I2(quiet_carry__2_0[18]),
        .I3(\faults[7]_i_10_0 [18]),
        .O(state2_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry__1_i_4
       (.I0(\faults[7]_i_10_0 [17]),
        .I1(quiet_carry__2_0[17]),
        .I2(quiet_carry__2_0[16]),
        .I3(\faults[7]_i_10_0 [16]),
        .O(state2_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry__1_i_5
       (.I0(quiet_carry__2_0[23]),
        .I1(\faults[7]_i_10_0 [23]),
        .I2(quiet_carry__2_0[22]),
        .I3(\faults[7]_i_10_0 [22]),
        .O(state2_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry__1_i_6
       (.I0(quiet_carry__2_0[21]),
        .I1(\faults[7]_i_10_0 [21]),
        .I2(quiet_carry__2_0[20]),
        .I3(\faults[7]_i_10_0 [20]),
        .O(state2_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry__1_i_7
       (.I0(quiet_carry__2_0[19]),
        .I1(\faults[7]_i_10_0 [19]),
        .I2(quiet_carry__2_0[18]),
        .I3(\faults[7]_i_10_0 [18]),
        .O(state2_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry__1_i_8
       (.I0(quiet_carry__2_0[17]),
        .I1(\faults[7]_i_10_0 [17]),
        .I2(quiet_carry__2_0[16]),
        .I3(\faults[7]_i_10_0 [16]),
        .O(state2_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 state2_carry__2
       (.CI(state2_carry__1_n_0),
        .CO({state20_in,state2_carry__2_n_1,state2_carry__2_n_2,state2_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({state2_carry__2_i_1_n_0,state2_carry__2_i_2_n_0,state2_carry__2_i_3_n_0,state2_carry__2_i_4_n_0}),
        .O(NLW_state2_carry__2_O_UNCONNECTED[3:0]),
        .S({state2_carry__2_i_5_n_0,state2_carry__2_i_6_n_0,state2_carry__2_i_7_n_0,state2_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry__2_i_1
       (.I0(\faults[7]_i_10_0 [31]),
        .I1(quiet_carry__2_0[31]),
        .I2(quiet_carry__2_0[30]),
        .I3(\faults[7]_i_10_0 [30]),
        .O(state2_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry__2_i_2
       (.I0(\faults[7]_i_10_0 [29]),
        .I1(quiet_carry__2_0[29]),
        .I2(quiet_carry__2_0[28]),
        .I3(\faults[7]_i_10_0 [28]),
        .O(state2_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry__2_i_3
       (.I0(\faults[7]_i_10_0 [27]),
        .I1(quiet_carry__2_0[27]),
        .I2(quiet_carry__2_0[26]),
        .I3(\faults[7]_i_10_0 [26]),
        .O(state2_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry__2_i_4
       (.I0(\faults[7]_i_10_0 [25]),
        .I1(quiet_carry__2_0[25]),
        .I2(quiet_carry__2_0[24]),
        .I3(\faults[7]_i_10_0 [24]),
        .O(state2_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry__2_i_5
       (.I0(quiet_carry__2_0[31]),
        .I1(\faults[7]_i_10_0 [31]),
        .I2(quiet_carry__2_0[30]),
        .I3(\faults[7]_i_10_0 [30]),
        .O(state2_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry__2_i_6
       (.I0(quiet_carry__2_0[29]),
        .I1(\faults[7]_i_10_0 [29]),
        .I2(quiet_carry__2_0[28]),
        .I3(\faults[7]_i_10_0 [28]),
        .O(state2_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry__2_i_7
       (.I0(quiet_carry__2_0[27]),
        .I1(\faults[7]_i_10_0 [27]),
        .I2(quiet_carry__2_0[26]),
        .I3(\faults[7]_i_10_0 [26]),
        .O(state2_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry__2_i_8
       (.I0(quiet_carry__2_0[25]),
        .I1(\faults[7]_i_10_0 [25]),
        .I2(quiet_carry__2_0[24]),
        .I3(\faults[7]_i_10_0 [24]),
        .O(state2_carry__2_i_8_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry_i_1
       (.I0(\faults[7]_i_10_0 [7]),
        .I1(quiet_carry__2_0[7]),
        .I2(quiet_carry__2_0[6]),
        .I3(\faults[7]_i_10_0 [6]),
        .O(state2_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry_i_2
       (.I0(\faults[7]_i_10_0 [5]),
        .I1(quiet_carry__2_0[5]),
        .I2(quiet_carry__2_0[4]),
        .I3(\faults[7]_i_10_0 [4]),
        .O(state2_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry_i_3
       (.I0(\faults[7]_i_10_0 [3]),
        .I1(quiet_carry__2_0[3]),
        .I2(quiet_carry__2_0[2]),
        .I3(\faults[7]_i_10_0 [2]),
        .O(state2_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h44D4)) 
    state2_carry_i_4
       (.I0(\faults[7]_i_10_0 [1]),
        .I1(quiet_carry__2_0[1]),
        .I2(quiet_carry__2_0[0]),
        .I3(\faults[7]_i_10_0 [0]),
        .O(state2_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry_i_5
       (.I0(quiet_carry__2_0[7]),
        .I1(\faults[7]_i_10_0 [7]),
        .I2(quiet_carry__2_0[6]),
        .I3(\faults[7]_i_10_0 [6]),
        .O(state2_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry_i_6
       (.I0(quiet_carry__2_0[5]),
        .I1(\faults[7]_i_10_0 [5]),
        .I2(quiet_carry__2_0[4]),
        .I3(\faults[7]_i_10_0 [4]),
        .O(state2_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry_i_7
       (.I0(quiet_carry__2_0[3]),
        .I1(\faults[7]_i_10_0 [3]),
        .I2(quiet_carry__2_0[2]),
        .I3(\faults[7]_i_10_0 [2]),
        .O(state2_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state2_carry_i_8
       (.I0(quiet_carry__2_0[1]),
        .I1(\faults[7]_i_10_0 [1]),
        .I2(quiet_carry__2_0[0]),
        .I3(\faults[7]_i_10_0 [0]),
        .O(state2_carry_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 state3_carry
       (.CI(1'b0),
        .CO({state3_carry_n_0,state3_carry_n_1,state3_carry_n_2,state3_carry_n_3}),
        .CYINIT(1'b1),
        .DI({state3_carry_i_1_n_0,state3_carry_i_2_n_0,state3_carry_i_3_n_0,state3_carry_i_4_n_0}),
        .O(NLW_state3_carry_O_UNCONNECTED[3:0]),
        .S({state3_carry_i_5_n_0,state3_carry_i_6_n_0,state3_carry_i_7_n_0,state3_carry_i_8_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 state3_carry__0
       (.CI(state3_carry_n_0),
        .CO({state3_carry__0_n_0,state3_carry__0_n_1,state3_carry__0_n_2,state3_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({state3_carry__0_i_1_n_0,state3_carry__0_i_2_n_0,state3_carry__0_i_3_n_0,state3_carry__0_i_4_n_0}),
        .O(NLW_state3_carry__0_O_UNCONNECTED[3:0]),
        .S({state3_carry__0_i_5_n_0,state3_carry__0_i_6_n_0,state3_carry__0_i_7_n_0,state3_carry__0_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry__0_i_1
       (.I0(\faults[7]_i_10_0 [15]),
        .I1(above_loud_carry__2_0[15]),
        .I2(\faults[7]_i_10_0 [14]),
        .I3(above_loud_carry__2_0[14]),
        .O(state3_carry__0_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry__0_i_2
       (.I0(\faults[7]_i_10_0 [13]),
        .I1(above_loud_carry__2_0[13]),
        .I2(\faults[7]_i_10_0 [12]),
        .I3(above_loud_carry__2_0[12]),
        .O(state3_carry__0_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry__0_i_3
       (.I0(\faults[7]_i_10_0 [11]),
        .I1(above_loud_carry__2_0[11]),
        .I2(\faults[7]_i_10_0 [10]),
        .I3(above_loud_carry__2_0[10]),
        .O(state3_carry__0_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry__0_i_4
       (.I0(\faults[7]_i_10_0 [9]),
        .I1(above_loud_carry__2_0[9]),
        .I2(\faults[7]_i_10_0 [8]),
        .I3(above_loud_carry__2_0[8]),
        .O(state3_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry__0_i_5
       (.I0(above_loud_carry__2_0[15]),
        .I1(\faults[7]_i_10_0 [15]),
        .I2(above_loud_carry__2_0[14]),
        .I3(\faults[7]_i_10_0 [14]),
        .O(state3_carry__0_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry__0_i_6
       (.I0(above_loud_carry__2_0[13]),
        .I1(\faults[7]_i_10_0 [13]),
        .I2(above_loud_carry__2_0[12]),
        .I3(\faults[7]_i_10_0 [12]),
        .O(state3_carry__0_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry__0_i_7
       (.I0(above_loud_carry__2_0[11]),
        .I1(\faults[7]_i_10_0 [11]),
        .I2(above_loud_carry__2_0[10]),
        .I3(\faults[7]_i_10_0 [10]),
        .O(state3_carry__0_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry__0_i_8
       (.I0(above_loud_carry__2_0[9]),
        .I1(\faults[7]_i_10_0 [9]),
        .I2(above_loud_carry__2_0[8]),
        .I3(\faults[7]_i_10_0 [8]),
        .O(state3_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 state3_carry__1
       (.CI(state3_carry__0_n_0),
        .CO({state3_carry__1_n_0,state3_carry__1_n_1,state3_carry__1_n_2,state3_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({state3_carry__1_i_1_n_0,state3_carry__1_i_2_n_0,state3_carry__1_i_3_n_0,state3_carry__1_i_4_n_0}),
        .O(NLW_state3_carry__1_O_UNCONNECTED[3:0]),
        .S({state3_carry__1_i_5_n_0,state3_carry__1_i_6_n_0,state3_carry__1_i_7_n_0,state3_carry__1_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry__1_i_1
       (.I0(\faults[7]_i_10_0 [23]),
        .I1(above_loud_carry__2_0[23]),
        .I2(\faults[7]_i_10_0 [22]),
        .I3(above_loud_carry__2_0[22]),
        .O(state3_carry__1_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry__1_i_2
       (.I0(\faults[7]_i_10_0 [21]),
        .I1(above_loud_carry__2_0[21]),
        .I2(\faults[7]_i_10_0 [20]),
        .I3(above_loud_carry__2_0[20]),
        .O(state3_carry__1_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry__1_i_3
       (.I0(\faults[7]_i_10_0 [19]),
        .I1(above_loud_carry__2_0[19]),
        .I2(\faults[7]_i_10_0 [18]),
        .I3(above_loud_carry__2_0[18]),
        .O(state3_carry__1_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry__1_i_4
       (.I0(\faults[7]_i_10_0 [17]),
        .I1(above_loud_carry__2_0[17]),
        .I2(\faults[7]_i_10_0 [16]),
        .I3(above_loud_carry__2_0[16]),
        .O(state3_carry__1_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry__1_i_5
       (.I0(above_loud_carry__2_0[23]),
        .I1(\faults[7]_i_10_0 [23]),
        .I2(above_loud_carry__2_0[22]),
        .I3(\faults[7]_i_10_0 [22]),
        .O(state3_carry__1_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry__1_i_6
       (.I0(above_loud_carry__2_0[21]),
        .I1(\faults[7]_i_10_0 [21]),
        .I2(above_loud_carry__2_0[20]),
        .I3(\faults[7]_i_10_0 [20]),
        .O(state3_carry__1_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry__1_i_7
       (.I0(above_loud_carry__2_0[19]),
        .I1(\faults[7]_i_10_0 [19]),
        .I2(above_loud_carry__2_0[18]),
        .I3(\faults[7]_i_10_0 [18]),
        .O(state3_carry__1_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry__1_i_8
       (.I0(above_loud_carry__2_0[17]),
        .I1(\faults[7]_i_10_0 [17]),
        .I2(above_loud_carry__2_0[16]),
        .I3(\faults[7]_i_10_0 [16]),
        .O(state3_carry__1_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 state3_carry__2
       (.CI(state3_carry__1_n_0),
        .CO({state3,state3_carry__2_n_1,state3_carry__2_n_2,state3_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({state3_carry__2_i_1_n_0,state3_carry__2_i_2_n_0,state3_carry__2_i_3_n_0,state3_carry__2_i_4_n_0}),
        .O(NLW_state3_carry__2_O_UNCONNECTED[3:0]),
        .S({state3_carry__2_i_5_n_0,state3_carry__2_i_6_n_0,state3_carry__2_i_7_n_0,state3_carry__2_i_8_n_0}));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry__2_i_1
       (.I0(\faults[7]_i_10_0 [31]),
        .I1(above_loud_carry__2_0[31]),
        .I2(\faults[7]_i_10_0 [30]),
        .I3(above_loud_carry__2_0[30]),
        .O(state3_carry__2_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry__2_i_2
       (.I0(\faults[7]_i_10_0 [29]),
        .I1(above_loud_carry__2_0[29]),
        .I2(\faults[7]_i_10_0 [28]),
        .I3(above_loud_carry__2_0[28]),
        .O(state3_carry__2_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry__2_i_3
       (.I0(\faults[7]_i_10_0 [27]),
        .I1(above_loud_carry__2_0[27]),
        .I2(\faults[7]_i_10_0 [26]),
        .I3(above_loud_carry__2_0[26]),
        .O(state3_carry__2_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry__2_i_4
       (.I0(\faults[7]_i_10_0 [25]),
        .I1(above_loud_carry__2_0[25]),
        .I2(\faults[7]_i_10_0 [24]),
        .I3(above_loud_carry__2_0[24]),
        .O(state3_carry__2_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry__2_i_5
       (.I0(above_loud_carry__2_0[31]),
        .I1(\faults[7]_i_10_0 [31]),
        .I2(above_loud_carry__2_0[30]),
        .I3(\faults[7]_i_10_0 [30]),
        .O(state3_carry__2_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry__2_i_6
       (.I0(above_loud_carry__2_0[29]),
        .I1(\faults[7]_i_10_0 [29]),
        .I2(above_loud_carry__2_0[28]),
        .I3(\faults[7]_i_10_0 [28]),
        .O(state3_carry__2_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry__2_i_7
       (.I0(above_loud_carry__2_0[27]),
        .I1(\faults[7]_i_10_0 [27]),
        .I2(above_loud_carry__2_0[26]),
        .I3(\faults[7]_i_10_0 [26]),
        .O(state3_carry__2_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry__2_i_8
       (.I0(above_loud_carry__2_0[25]),
        .I1(\faults[7]_i_10_0 [25]),
        .I2(above_loud_carry__2_0[24]),
        .I3(\faults[7]_i_10_0 [24]),
        .O(state3_carry__2_i_8_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry_i_1
       (.I0(\faults[7]_i_10_0 [7]),
        .I1(above_loud_carry__2_0[7]),
        .I2(\faults[7]_i_10_0 [6]),
        .I3(above_loud_carry__2_0[6]),
        .O(state3_carry_i_1_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry_i_2
       (.I0(\faults[7]_i_10_0 [5]),
        .I1(above_loud_carry__2_0[5]),
        .I2(\faults[7]_i_10_0 [4]),
        .I3(above_loud_carry__2_0[4]),
        .O(state3_carry_i_2_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry_i_3
       (.I0(\faults[7]_i_10_0 [3]),
        .I1(above_loud_carry__2_0[3]),
        .I2(\faults[7]_i_10_0 [2]),
        .I3(above_loud_carry__2_0[2]),
        .O(state3_carry_i_3_n_0));
  LUT4 #(
    .INIT(16'h22B2)) 
    state3_carry_i_4
       (.I0(\faults[7]_i_10_0 [1]),
        .I1(above_loud_carry__2_0[1]),
        .I2(\faults[7]_i_10_0 [0]),
        .I3(above_loud_carry__2_0[0]),
        .O(state3_carry_i_4_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry_i_5
       (.I0(above_loud_carry__2_0[7]),
        .I1(\faults[7]_i_10_0 [7]),
        .I2(above_loud_carry__2_0[6]),
        .I3(\faults[7]_i_10_0 [6]),
        .O(state3_carry_i_5_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry_i_6
       (.I0(above_loud_carry__2_0[5]),
        .I1(\faults[7]_i_10_0 [5]),
        .I2(above_loud_carry__2_0[4]),
        .I3(\faults[7]_i_10_0 [4]),
        .O(state3_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry_i_7
       (.I0(above_loud_carry__2_0[3]),
        .I1(\faults[7]_i_10_0 [3]),
        .I2(above_loud_carry__2_0[2]),
        .I3(\faults[7]_i_10_0 [2]),
        .O(state3_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    state3_carry_i_8
       (.I0(above_loud_carry__2_0[1]),
        .I1(\faults[7]_i_10_0 [1]),
        .I2(above_loud_carry__2_0[0]),
        .I3(\faults[7]_i_10_0 [0]),
        .O(state3_carry_i_8_n_0));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h02FF0300)) 
    \state[0]_i_1 
       (.I0(status[3]),
        .I1(configure),
        .I2(status[4]),
        .I3(\state[2]_i_4_n_0 ),
        .I4(status[2]),
        .O(\state[0]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hBFFFBFBF)) 
    \state[1]_i_1 
       (.I0(configure),
        .I1(s_axi_aresetn),
        .I2(\faults_reg[0]_1 ),
        .I3(\faults[7]_i_5_n_0 ),
        .I4(\event_age[31]_i_1_n_0 ),
        .O(\state[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h01FF0200)) 
    \state[1]_i_2 
       (.I0(status[2]),
        .I1(configure),
        .I2(status[4]),
        .I3(\state[2]_i_4_n_0 ),
        .I4(status[3]),
        .O(\state[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h2222F2FF22220200)) 
    \state[2]_i_1 
       (.I0(\state[2]_i_2_n_0 ),
        .I1(\state[2]_i_3_n_0 ),
        .I2(\faults[7]_i_5_n_0 ),
        .I3(\event_age[31]_i_1_n_0 ),
        .I4(\state[2]_i_4_n_0 ),
        .I5(status[4]),
        .O(\state[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \state[2]_i_2 
       (.I0(\faults[7]_i_4_n_0 ),
        .I1(configure),
        .I2(\faults_reg[0]_1 ),
        .O(\state[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000080000000000)) 
    \state[2]_i_3 
       (.I0(\faults[5]_i_2_n_0 ),
        .I1(\faults[5]_i_3_n_0 ),
        .I2(\faults[7]_i_11_n_0 ),
        .I3(\faults[6]_i_3_n_0 ),
        .I4(status[4]),
        .I5(\faults[6]_i_6_n_0 ),
        .O(\state[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAFFFFAAA8FFFF)) 
    \state[2]_i_4 
       (.I0(\state[2]_i_5_n_0 ),
        .I1(\state[2]_i_6_n_0 ),
        .I2(\state[2]_i_7_n_0 ),
        .I3(status[4]),
        .I4(\faults[6]_i_3_n_0 ),
        .I5(\state[2]_i_8_n_0 ),
        .O(\state[2]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \state[2]_i_5 
       (.I0(\clipped_count[15]_i_4_n_0 ),
        .I1(\clipped_count[15]_i_2_n_0 ),
        .O(\state[2]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h4444444444440040)) 
    \state[2]_i_6 
       (.I0(status[2]),
        .I1(status[3]),
        .I2(above_loud),
        .I3(\state[2]_i_9_n_0 ),
        .I4(candidate_count[1]),
        .I5(candidate_count[2]),
        .O(\state[2]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'h25000000)) 
    \state[2]_i_7 
       (.I0(status[3]),
        .I1(status[0]),
        .I2(status[2]),
        .I3(\quiet_count_reg_n_0_[2] ),
        .I4(quiet),
        .O(\state[2]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \state[2]_i_8 
       (.I0(p_1_in),
        .I1(status[2]),
        .I2(status[3]),
        .O(\state[2]_i_8_n_0 ));
  LUT3 #(
    .INIT(8'h01)) 
    \state[2]_i_9 
       (.I0(loud_count[1]),
        .I1(loud_count[0]),
        .I2(loud_count[2]),
        .O(\state[2]_i_9_n_0 ));
  FDRE \state_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\state[0]_i_1_n_0 ),
        .Q(status[2]),
        .R(\state[1]_i_1_n_0 ));
  FDRE \state_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\state[1]_i_2_n_0 ),
        .Q(status[3]),
        .R(\state[1]_i_1_n_0 ));
  FDRE \state_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\state[2]_i_1_n_0 ),
        .Q(status[4]),
        .R(s_axi_aresetn_0));
  LUT1 #(
    .INIT(2'h1)) 
    \window_count[0]_i_2 
       (.I0(\window_count_reg[31]_0 [0]),
        .O(\window_count[0]_i_2_n_0 ));
  FDRE \window_count_reg[0] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[0]_i_1_n_7 ),
        .Q(\window_count_reg[31]_0 [0]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \window_count_reg[0]_i_1 
       (.CI(1'b0),
        .CO({\window_count_reg[0]_i_1_n_0 ,\window_count_reg[0]_i_1_n_1 ,\window_count_reg[0]_i_1_n_2 ,\window_count_reg[0]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\window_count_reg[0]_i_1_n_4 ,\window_count_reg[0]_i_1_n_5 ,\window_count_reg[0]_i_1_n_6 ,\window_count_reg[0]_i_1_n_7 }),
        .S({\window_count_reg[31]_0 [3:1],\window_count[0]_i_2_n_0 }));
  FDRE \window_count_reg[10] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[8]_i_1_n_5 ),
        .Q(\window_count_reg[31]_0 [10]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[11] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[8]_i_1_n_4 ),
        .Q(\window_count_reg[31]_0 [11]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[12] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[12]_i_1_n_7 ),
        .Q(\window_count_reg[31]_0 [12]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \window_count_reg[12]_i_1 
       (.CI(\window_count_reg[8]_i_1_n_0 ),
        .CO({\window_count_reg[12]_i_1_n_0 ,\window_count_reg[12]_i_1_n_1 ,\window_count_reg[12]_i_1_n_2 ,\window_count_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\window_count_reg[12]_i_1_n_4 ,\window_count_reg[12]_i_1_n_5 ,\window_count_reg[12]_i_1_n_6 ,\window_count_reg[12]_i_1_n_7 }),
        .S(\window_count_reg[31]_0 [15:12]));
  FDRE \window_count_reg[13] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[12]_i_1_n_6 ),
        .Q(\window_count_reg[31]_0 [13]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[14] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[12]_i_1_n_5 ),
        .Q(\window_count_reg[31]_0 [14]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[15] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[12]_i_1_n_4 ),
        .Q(\window_count_reg[31]_0 [15]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[16] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[16]_i_1_n_7 ),
        .Q(\window_count_reg[31]_0 [16]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \window_count_reg[16]_i_1 
       (.CI(\window_count_reg[12]_i_1_n_0 ),
        .CO({\window_count_reg[16]_i_1_n_0 ,\window_count_reg[16]_i_1_n_1 ,\window_count_reg[16]_i_1_n_2 ,\window_count_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\window_count_reg[16]_i_1_n_4 ,\window_count_reg[16]_i_1_n_5 ,\window_count_reg[16]_i_1_n_6 ,\window_count_reg[16]_i_1_n_7 }),
        .S(\window_count_reg[31]_0 [19:16]));
  FDRE \window_count_reg[17] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[16]_i_1_n_6 ),
        .Q(\window_count_reg[31]_0 [17]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[18] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[16]_i_1_n_5 ),
        .Q(\window_count_reg[31]_0 [18]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[19] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[16]_i_1_n_4 ),
        .Q(\window_count_reg[31]_0 [19]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[1] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[0]_i_1_n_6 ),
        .Q(\window_count_reg[31]_0 [1]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[20] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[20]_i_1_n_7 ),
        .Q(\window_count_reg[31]_0 [20]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \window_count_reg[20]_i_1 
       (.CI(\window_count_reg[16]_i_1_n_0 ),
        .CO({\window_count_reg[20]_i_1_n_0 ,\window_count_reg[20]_i_1_n_1 ,\window_count_reg[20]_i_1_n_2 ,\window_count_reg[20]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\window_count_reg[20]_i_1_n_4 ,\window_count_reg[20]_i_1_n_5 ,\window_count_reg[20]_i_1_n_6 ,\window_count_reg[20]_i_1_n_7 }),
        .S(\window_count_reg[31]_0 [23:20]));
  FDRE \window_count_reg[21] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[20]_i_1_n_6 ),
        .Q(\window_count_reg[31]_0 [21]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[22] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[20]_i_1_n_5 ),
        .Q(\window_count_reg[31]_0 [22]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[23] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[20]_i_1_n_4 ),
        .Q(\window_count_reg[31]_0 [23]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[24] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[24]_i_1_n_7 ),
        .Q(\window_count_reg[31]_0 [24]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \window_count_reg[24]_i_1 
       (.CI(\window_count_reg[20]_i_1_n_0 ),
        .CO({\window_count_reg[24]_i_1_n_0 ,\window_count_reg[24]_i_1_n_1 ,\window_count_reg[24]_i_1_n_2 ,\window_count_reg[24]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\window_count_reg[24]_i_1_n_4 ,\window_count_reg[24]_i_1_n_5 ,\window_count_reg[24]_i_1_n_6 ,\window_count_reg[24]_i_1_n_7 }),
        .S(\window_count_reg[31]_0 [27:24]));
  FDRE \window_count_reg[25] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[24]_i_1_n_6 ),
        .Q(\window_count_reg[31]_0 [25]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[26] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[24]_i_1_n_5 ),
        .Q(\window_count_reg[31]_0 [26]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[27] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[24]_i_1_n_4 ),
        .Q(\window_count_reg[31]_0 [27]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[28] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[28]_i_1_n_7 ),
        .Q(\window_count_reg[31]_0 [28]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \window_count_reg[28]_i_1 
       (.CI(\window_count_reg[24]_i_1_n_0 ),
        .CO({\NLW_window_count_reg[28]_i_1_CO_UNCONNECTED [3],\window_count_reg[28]_i_1_n_1 ,\window_count_reg[28]_i_1_n_2 ,\window_count_reg[28]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\window_count_reg[28]_i_1_n_4 ,\window_count_reg[28]_i_1_n_5 ,\window_count_reg[28]_i_1_n_6 ,\window_count_reg[28]_i_1_n_7 }),
        .S(\window_count_reg[31]_0 [31:28]));
  FDRE \window_count_reg[29] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[28]_i_1_n_6 ),
        .Q(\window_count_reg[31]_0 [29]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[2] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[0]_i_1_n_5 ),
        .Q(\window_count_reg[31]_0 [2]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[30] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[28]_i_1_n_5 ),
        .Q(\window_count_reg[31]_0 [30]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[31] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[28]_i_1_n_4 ),
        .Q(\window_count_reg[31]_0 [31]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[3] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[0]_i_1_n_4 ),
        .Q(\window_count_reg[31]_0 [3]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[4] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[4]_i_1_n_7 ),
        .Q(\window_count_reg[31]_0 [4]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \window_count_reg[4]_i_1 
       (.CI(\window_count_reg[0]_i_1_n_0 ),
        .CO({\window_count_reg[4]_i_1_n_0 ,\window_count_reg[4]_i_1_n_1 ,\window_count_reg[4]_i_1_n_2 ,\window_count_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\window_count_reg[4]_i_1_n_4 ,\window_count_reg[4]_i_1_n_5 ,\window_count_reg[4]_i_1_n_6 ,\window_count_reg[4]_i_1_n_7 }),
        .S(\window_count_reg[31]_0 [7:4]));
  FDRE \window_count_reg[5] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[4]_i_1_n_6 ),
        .Q(\window_count_reg[31]_0 [5]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[6] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[4]_i_1_n_5 ),
        .Q(\window_count_reg[31]_0 [6]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[7] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[4]_i_1_n_4 ),
        .Q(\window_count_reg[31]_0 [7]),
        .R(\last_sum[31]_i_1_n_0 ));
  FDRE \window_count_reg[8] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[8]_i_1_n_7 ),
        .Q(\window_count_reg[31]_0 [8]),
        .R(\last_sum[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \window_count_reg[8]_i_1 
       (.CI(\window_count_reg[4]_i_1_n_0 ),
        .CO({\window_count_reg[8]_i_1_n_0 ,\window_count_reg[8]_i_1_n_1 ,\window_count_reg[8]_i_1_n_2 ,\window_count_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\window_count_reg[8]_i_1_n_4 ,\window_count_reg[8]_i_1_n_5 ,\window_count_reg[8]_i_1_n_6 ,\window_count_reg[8]_i_1_n_7 }),
        .S(\window_count_reg[31]_0 [11:8]));
  FDRE \window_count_reg[9] 
       (.C(s_axi_aclk),
        .CE(\last_sum[31]_i_2_n_0 ),
        .D(\window_count_reg[8]_i_1_n_6 ),
        .Q(\window_count_reg[31]_0 [9]),
        .R(\last_sum[31]_i_1_n_0 ));
endmodule

(* ORIG_REF_NAME = "voice_volume_i2s_rx" *) 
module c6v_voice_volume_0_0_voice_volume_i2s_rx
   (input_fault,
    pcm_valid,
    S,
    Q,
    \pcm_s16_reg[12]_0 ,
    \pcm_s16_reg[14]_0 ,
    \pcm_s16_reg[4]_0 ,
    \pcm_s16_reg[0]_0 ,
    dc_clipped0,
    SR,
    s_axi_aclk,
    \difference_latched_reg[24] ,
    s_axi_aresetn,
    O115,
    i2s_sdata);
  output input_fault;
  output pcm_valid;
  output [3:0]S;
  output [15:0]Q;
  output [3:0]\pcm_s16_reg[12]_0 ;
  output [1:0]\pcm_s16_reg[14]_0 ;
  output [3:0]\pcm_s16_reg[4]_0 ;
  output [0:0]\pcm_s16_reg[0]_0 ;
  output dc_clipped0;
  input [0:0]SR;
  input s_axi_aclk;
  input [14:0]\difference_latched_reg[24] ;
  input s_axi_aresetn;
  input [1:0]O115;
  input i2s_sdata;

  wire [1:0]O115;
  wire [15:0]Q;
  wire [3:0]S;
  wire [0:0]SR;
  wire bclk_previous;
  (* async_reg = "true" *) wire [1:0]bclk_sync;
  wire channel_i_1_n_0;
  wire channel_reg_n_0;
  wire dc_clipped0;
  wire dc_clipped_i_4_n_0;
  wire dc_clipped_i_5_n_0;
  wire dc_clipped_i_6_n_0;
  wire dc_clipped_i_7_n_0;
  wire dc_clipped_i_8_n_0;
  wire dc_clipped_i_9_n_0;
  wire [14:0]\difference_latched_reg[24] ;
  wire frame_fault1_out;
  wire frame_fault_i_2_n_0;
  wire frame_fault_i_3_n_0;
  wire i2s_sdata;
  wire input_fault;
  (* async_reg = "true" *) wire [1:0]lrclk_sync;
  wire [5:0]p_0_in__0;
  wire \pcm_s16[15]_i_1_n_0 ;
  wire [0:0]\pcm_s16_reg[0]_0 ;
  wire [3:0]\pcm_s16_reg[12]_0 ;
  wire [1:0]\pcm_s16_reg[14]_0 ;
  wire [3:0]\pcm_s16_reg[4]_0 ;
  wire pcm_valid;
  wire pcm_valid_i_1_n_0;
  wire pcm_valid_i_2_n_0;
  wire s_axi_aclk;
  wire s_axi_aresetn;
  (* async_reg = "true" *) wire [1:0]sdata_sync;
  wire [14:0]shift_data;
  wire \shift_data[14]_i_1_n_0 ;
  wire [0:0]shift_data_0;
  wire \slot_index[5]_i_1_n_0 ;
  wire [5:0]slot_index_reg;
  wire started;
  wire started_i_1_n_0;

  FDRE bclk_previous_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(bclk_sync[1]),
        .Q(bclk_previous),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \bclk_sync_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(O115[0]),
        .Q(bclk_sync[0]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \bclk_sync_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(bclk_sync[0]),
        .Q(bclk_sync[1]),
        .R(SR));
  LUT4 #(
    .INIT(16'hAACA)) 
    channel_i_1
       (.I0(channel_reg_n_0),
        .I1(lrclk_sync[1]),
        .I2(bclk_sync[1]),
        .I3(bclk_previous),
        .O(channel_i_1_n_0));
  FDRE channel_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(channel_i_1_n_0),
        .Q(channel_reg_n_0),
        .R(SR));
  LUT6 #(
    .INIT(64'hFF80808080808080)) 
    dc_clipped_i_3
       (.I0(dc_clipped_i_4_n_0),
        .I1(dc_clipped_i_5_n_0),
        .I2(dc_clipped_i_6_n_0),
        .I3(dc_clipped_i_7_n_0),
        .I4(dc_clipped_i_8_n_0),
        .I5(dc_clipped_i_9_n_0),
        .O(dc_clipped0));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    dc_clipped_i_4
       (.I0(Q[6]),
        .I1(Q[7]),
        .I2(Q[4]),
        .I3(Q[5]),
        .I4(Q[9]),
        .I5(Q[8]),
        .O(dc_clipped_i_4_n_0));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    dc_clipped_i_5
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[3]),
        .I3(Q[2]),
        .O(dc_clipped_i_5_n_0));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    dc_clipped_i_6
       (.I0(Q[12]),
        .I1(Q[13]),
        .I2(Q[10]),
        .I3(Q[11]),
        .I4(Q[14]),
        .I5(Q[15]),
        .O(dc_clipped_i_6_n_0));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    dc_clipped_i_7
       (.I0(Q[6]),
        .I1(Q[7]),
        .I2(Q[4]),
        .I3(Q[5]),
        .I4(Q[9]),
        .I5(Q[8]),
        .O(dc_clipped_i_7_n_0));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    dc_clipped_i_8
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[3]),
        .I3(Q[2]),
        .O(dc_clipped_i_8_n_0));
  LUT6 #(
    .INIT(64'h0000800000000000)) 
    dc_clipped_i_9
       (.I0(Q[12]),
        .I1(Q[13]),
        .I2(Q[10]),
        .I3(Q[11]),
        .I4(Q[15]),
        .I5(Q[14]),
        .O(dc_clipped_i_9_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__0_i_1
       (.I0(Q[0]),
        .I1(\difference_latched_reg[24] [0]),
        .O(\pcm_s16_reg[0]_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__1_i_1
       (.I0(Q[4]),
        .I1(\difference_latched_reg[24] [4]),
        .O(\pcm_s16_reg[4]_0 [3]));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__1_i_2
       (.I0(Q[3]),
        .I1(\difference_latched_reg[24] [3]),
        .O(\pcm_s16_reg[4]_0 [2]));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__1_i_3
       (.I0(Q[2]),
        .I1(\difference_latched_reg[24] [2]),
        .O(\pcm_s16_reg[4]_0 [1]));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__1_i_4
       (.I0(Q[1]),
        .I1(\difference_latched_reg[24] [1]),
        .O(\pcm_s16_reg[4]_0 [0]));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__2_i_1
       (.I0(Q[8]),
        .I1(\difference_latched_reg[24] [8]),
        .O(S[3]));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__2_i_2
       (.I0(Q[7]),
        .I1(\difference_latched_reg[24] [7]),
        .O(S[2]));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__2_i_3
       (.I0(Q[6]),
        .I1(\difference_latched_reg[24] [6]),
        .O(S[1]));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__2_i_4
       (.I0(Q[5]),
        .I1(\difference_latched_reg[24] [5]),
        .O(S[0]));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__3_i_1
       (.I0(Q[12]),
        .I1(\difference_latched_reg[24] [12]),
        .O(\pcm_s16_reg[12]_0 [3]));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__3_i_2
       (.I0(Q[11]),
        .I1(\difference_latched_reg[24] [11]),
        .O(\pcm_s16_reg[12]_0 [2]));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__3_i_3
       (.I0(Q[10]),
        .I1(\difference_latched_reg[24] [10]),
        .O(\pcm_s16_reg[12]_0 [1]));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__3_i_4
       (.I0(Q[9]),
        .I1(\difference_latched_reg[24] [9]),
        .O(\pcm_s16_reg[12]_0 [0]));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__4_i_3
       (.I0(Q[14]),
        .I1(\difference_latched_reg[24] [14]),
        .O(\pcm_s16_reg[14]_0 [1]));
  LUT2 #(
    .INIT(4'h9)) 
    dc_difference_carry__4_i_4
       (.I0(Q[13]),
        .I1(\difference_latched_reg[24] [13]),
        .O(\pcm_s16_reg[14]_0 [0]));
  LUT6 #(
    .INIT(64'h20008AAA8AAA2000)) 
    frame_fault_i_1
       (.I0(frame_fault_i_2_n_0),
        .I1(slot_index_reg[5]),
        .I2(frame_fault_i_3_n_0),
        .I3(slot_index_reg[4]),
        .I4(lrclk_sync[1]),
        .I5(channel_reg_n_0),
        .O(frame_fault1_out));
  LUT3 #(
    .INIT(8'h08)) 
    frame_fault_i_2
       (.I0(started),
        .I1(bclk_sync[1]),
        .I2(bclk_previous),
        .O(frame_fault_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    frame_fault_i_3
       (.I0(slot_index_reg[3]),
        .I1(slot_index_reg[0]),
        .I2(slot_index_reg[1]),
        .I3(slot_index_reg[2]),
        .O(frame_fault_i_3_n_0));
  FDRE frame_fault_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(frame_fault1_out),
        .Q(input_fault),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \lrclk_sync_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(O115[1]),
        .Q(lrclk_sync[0]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \lrclk_sync_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(lrclk_sync[0]),
        .Q(lrclk_sync[1]),
        .R(SR));
  LUT6 #(
    .INIT(64'h4000000000000000)) 
    \pcm_s16[15]_i_1 
       (.I0(lrclk_sync[1]),
        .I1(shift_data_0),
        .I2(slot_index_reg[3]),
        .I3(slot_index_reg[0]),
        .I4(slot_index_reg[1]),
        .I5(slot_index_reg[2]),
        .O(\pcm_s16[15]_i_1_n_0 ));
  FDRE \pcm_s16_reg[0] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(sdata_sync[1]),
        .Q(Q[0]),
        .R(SR));
  FDRE \pcm_s16_reg[10] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[9]),
        .Q(Q[10]),
        .R(SR));
  FDRE \pcm_s16_reg[11] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[10]),
        .Q(Q[11]),
        .R(SR));
  FDRE \pcm_s16_reg[12] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[11]),
        .Q(Q[12]),
        .R(SR));
  FDRE \pcm_s16_reg[13] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[12]),
        .Q(Q[13]),
        .R(SR));
  FDRE \pcm_s16_reg[14] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[13]),
        .Q(Q[14]),
        .R(SR));
  FDRE \pcm_s16_reg[15] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[14]),
        .Q(Q[15]),
        .R(SR));
  FDRE \pcm_s16_reg[1] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[0]),
        .Q(Q[1]),
        .R(SR));
  FDRE \pcm_s16_reg[2] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[1]),
        .Q(Q[2]),
        .R(SR));
  FDRE \pcm_s16_reg[3] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[2]),
        .Q(Q[3]),
        .R(SR));
  FDRE \pcm_s16_reg[4] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[3]),
        .Q(Q[4]),
        .R(SR));
  FDRE \pcm_s16_reg[5] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[4]),
        .Q(Q[5]),
        .R(SR));
  FDRE \pcm_s16_reg[6] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[5]),
        .Q(Q[6]),
        .R(SR));
  FDRE \pcm_s16_reg[7] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[6]),
        .Q(Q[7]),
        .R(SR));
  FDRE \pcm_s16_reg[8] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[7]),
        .Q(Q[8]),
        .R(SR));
  FDRE \pcm_s16_reg[9] 
       (.C(s_axi_aclk),
        .CE(\pcm_s16[15]_i_1_n_0 ),
        .D(shift_data[8]),
        .Q(Q[9]),
        .R(SR));
  LUT6 #(
    .INIT(64'h00000000FF9F0000)) 
    pcm_valid_i_1
       (.I0(channel_reg_n_0),
        .I1(lrclk_sync[1]),
        .I2(bclk_sync[1]),
        .I3(bclk_previous),
        .I4(s_axi_aresetn),
        .I5(pcm_valid_i_2_n_0),
        .O(pcm_valid_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h7FFFFFFF)) 
    pcm_valid_i_2
       (.I0(slot_index_reg[2]),
        .I1(slot_index_reg[1]),
        .I2(slot_index_reg[0]),
        .I3(slot_index_reg[3]),
        .I4(shift_data_0),
        .O(pcm_valid_i_2_n_0));
  FDRE pcm_valid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(pcm_valid_i_1_n_0),
        .Q(pcm_valid),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \sdata_sync_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(i2s_sdata),
        .Q(sdata_sync[0]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \sdata_sync_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(sdata_sync[0]),
        .Q(sdata_sync[1]),
        .R(SR));
  LUT5 #(
    .INIT(32'h0060FFFF)) 
    \shift_data[14]_i_1 
       (.I0(channel_reg_n_0),
        .I1(lrclk_sync[1]),
        .I2(bclk_sync[1]),
        .I3(bclk_previous),
        .I4(s_axi_aresetn),
        .O(\shift_data[14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000040)) 
    \shift_data[14]_i_2 
       (.I0(slot_index_reg[5]),
        .I1(started),
        .I2(bclk_sync[1]),
        .I3(bclk_previous),
        .I4(slot_index_reg[4]),
        .I5(channel_reg_n_0),
        .O(shift_data_0));
  FDRE \shift_data_reg[0] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(sdata_sync[1]),
        .Q(shift_data[0]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \shift_data_reg[10] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(shift_data[9]),
        .Q(shift_data[10]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \shift_data_reg[11] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(shift_data[10]),
        .Q(shift_data[11]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \shift_data_reg[12] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(shift_data[11]),
        .Q(shift_data[12]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \shift_data_reg[13] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(shift_data[12]),
        .Q(shift_data[13]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \shift_data_reg[14] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(shift_data[13]),
        .Q(shift_data[14]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \shift_data_reg[1] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(shift_data[0]),
        .Q(shift_data[1]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \shift_data_reg[2] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(shift_data[1]),
        .Q(shift_data[2]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \shift_data_reg[3] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(shift_data[2]),
        .Q(shift_data[3]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \shift_data_reg[4] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(shift_data[3]),
        .Q(shift_data[4]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \shift_data_reg[5] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(shift_data[4]),
        .Q(shift_data[5]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \shift_data_reg[6] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(shift_data[5]),
        .Q(shift_data[6]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \shift_data_reg[7] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(shift_data[6]),
        .Q(shift_data[7]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \shift_data_reg[8] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(shift_data[7]),
        .Q(shift_data[8]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \shift_data_reg[9] 
       (.C(s_axi_aclk),
        .CE(shift_data_0),
        .D(shift_data[8]),
        .Q(shift_data[9]),
        .R(\shift_data[14]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \slot_index[0]_i_1 
       (.I0(slot_index_reg[0]),
        .O(p_0_in__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \slot_index[1]_i_1 
       (.I0(slot_index_reg[0]),
        .I1(slot_index_reg[1]),
        .O(p_0_in__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \slot_index[2]_i_1 
       (.I0(slot_index_reg[2]),
        .I1(slot_index_reg[1]),
        .I2(slot_index_reg[0]),
        .O(p_0_in__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \slot_index[3]_i_1 
       (.I0(slot_index_reg[3]),
        .I1(slot_index_reg[0]),
        .I2(slot_index_reg[1]),
        .I3(slot_index_reg[2]),
        .O(p_0_in__0[3]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \slot_index[4]_i_1 
       (.I0(slot_index_reg[4]),
        .I1(slot_index_reg[2]),
        .I2(slot_index_reg[1]),
        .I3(slot_index_reg[0]),
        .I4(slot_index_reg[3]),
        .O(p_0_in__0[4]));
  LUT4 #(
    .INIT(16'h0040)) 
    \slot_index[5]_i_1 
       (.I0(bclk_previous),
        .I1(bclk_sync[1]),
        .I2(started),
        .I3(slot_index_reg[5]),
        .O(\slot_index[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \slot_index[5]_i_2 
       (.I0(slot_index_reg[3]),
        .I1(slot_index_reg[0]),
        .I2(slot_index_reg[1]),
        .I3(slot_index_reg[2]),
        .I4(slot_index_reg[4]),
        .O(p_0_in__0[5]));
  FDRE \slot_index_reg[0] 
       (.C(s_axi_aclk),
        .CE(\slot_index[5]_i_1_n_0 ),
        .D(p_0_in__0[0]),
        .Q(slot_index_reg[0]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \slot_index_reg[1] 
       (.C(s_axi_aclk),
        .CE(\slot_index[5]_i_1_n_0 ),
        .D(p_0_in__0[1]),
        .Q(slot_index_reg[1]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \slot_index_reg[2] 
       (.C(s_axi_aclk),
        .CE(\slot_index[5]_i_1_n_0 ),
        .D(p_0_in__0[2]),
        .Q(slot_index_reg[2]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \slot_index_reg[3] 
       (.C(s_axi_aclk),
        .CE(\slot_index[5]_i_1_n_0 ),
        .D(p_0_in__0[3]),
        .Q(slot_index_reg[3]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \slot_index_reg[4] 
       (.C(s_axi_aclk),
        .CE(\slot_index[5]_i_1_n_0 ),
        .D(p_0_in__0[4]),
        .Q(slot_index_reg[4]),
        .R(\shift_data[14]_i_1_n_0 ));
  FDRE \slot_index_reg[5] 
       (.C(s_axi_aclk),
        .CE(\slot_index[5]_i_1_n_0 ),
        .D(p_0_in__0[5]),
        .Q(slot_index_reg[5]),
        .R(\shift_data[14]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF0440)) 
    started_i_1
       (.I0(bclk_previous),
        .I1(bclk_sync[1]),
        .I2(lrclk_sync[1]),
        .I3(channel_reg_n_0),
        .I4(started),
        .O(started_i_1_n_0));
  FDRE started_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(started_i_1_n_0),
        .Q(started),
        .R(SR));
endmodule

(* ORIG_REF_NAME = "voice_volume_top" *) 
module c6v_voice_volume_0_0_voice_volume_top
   (O115,
    s_axi_bresp,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_wready,
    s_axi_bvalid_reg,
    s_axi_awready,
    s_axi_arready,
    s_axi_rvalid_reg,
    s_axi_araddr,
    s_axi_aresetn,
    s_axi_aclk,
    s_axi_wdata,
    i2s_sdata,
    s_axi_awaddr,
    s_axi_wstrb,
    codec_mclk_locked,
    s_axi_wvalid,
    s_axi_awvalid,
    s_axi_arvalid,
    s_axi_bready,
    s_axi_rready);
  output [1:0]O115;
  output [0:0]s_axi_bresp;
  output [31:0]s_axi_rdata;
  output [0:0]s_axi_rresp;
  output s_axi_wready;
  output s_axi_bvalid_reg;
  output s_axi_awready;
  output s_axi_arready;
  output s_axi_rvalid_reg;
  input [11:0]s_axi_araddr;
  input s_axi_aresetn;
  input s_axi_aclk;
  input [31:0]s_axi_wdata;
  input i2s_sdata;
  input [11:0]s_axi_awaddr;
  input [3:0]s_axi_wstrb;
  input codec_mclk_locked;
  input s_axi_wvalid;
  input s_axi_awvalid;
  input s_axi_arvalid;
  input s_axi_bready;
  input s_axi_rready;

  wire [1:0]O115;
  wire \audio_counter[10]_i_2_n_0 ;
  wire \audio_counter_reg_n_0_[0] ;
  wire \audio_counter_reg_n_0_[1] ;
  wire \audio_counter_reg_n_0_[2] ;
  wire \audio_counter_reg_n_0_[3] ;
  wire \audio_counter_reg_n_0_[5] ;
  wire \audio_counter_reg_n_0_[6] ;
  wire \audio_counter_reg_n_0_[7] ;
  wire \audio_counter_reg_n_0_[8] ;
  wire \audio_counter_reg_n_0_[9] ;
  wire codec_mclk_locked;
  wire \core/dc_clipped0 ;
  wire [22:8]\core/dc_level ;
  wire i2s_sdata;
  wire input_fault;
  (* async_reg = "true" *) wire [1:0]locked_sync;
  wire [10:0]p_0_in;
  wire [15:0]pcm_s16;
  wire pcm_valid;
  wire receiver_n_2;
  wire receiver_n_22;
  wire receiver_n_23;
  wire receiver_n_24;
  wire receiver_n_25;
  wire receiver_n_26;
  wire receiver_n_27;
  wire receiver_n_28;
  wire receiver_n_29;
  wire receiver_n_3;
  wire receiver_n_30;
  wire receiver_n_31;
  wire receiver_n_32;
  wire receiver_n_4;
  wire receiver_n_5;
  wire registers_n_1;
  wire s_axi_aclk;
  wire [11:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [11:0]s_axi_awaddr;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire [0:0]s_axi_bresp;
  wire s_axi_bvalid_reg;
  wire [31:0]s_axi_rdata;
  wire s_axi_rready;
  wire [0:0]s_axi_rresp;
  wire s_axi_rvalid_reg;
  wire [31:0]s_axi_wdata;
  wire s_axi_wready;
  wire [3:0]s_axi_wstrb;
  wire s_axi_wvalid;

  LUT1 #(
    .INIT(2'h1)) 
    \audio_counter[0]_i_1 
       (.I0(\audio_counter_reg_n_0_[0] ),
        .O(p_0_in[0]));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \audio_counter[10]_i_1 
       (.I0(O115[1]),
        .I1(\audio_counter_reg_n_0_[8] ),
        .I2(\audio_counter_reg_n_0_[6] ),
        .I3(\audio_counter[10]_i_2_n_0 ),
        .I4(\audio_counter_reg_n_0_[7] ),
        .I5(\audio_counter_reg_n_0_[9] ),
        .O(p_0_in[10]));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \audio_counter[10]_i_2 
       (.I0(\audio_counter_reg_n_0_[5] ),
        .I1(\audio_counter_reg_n_0_[3] ),
        .I2(\audio_counter_reg_n_0_[0] ),
        .I3(\audio_counter_reg_n_0_[1] ),
        .I4(\audio_counter_reg_n_0_[2] ),
        .I5(O115[0]),
        .O(\audio_counter[10]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \audio_counter[1]_i_1 
       (.I0(\audio_counter_reg_n_0_[0] ),
        .I1(\audio_counter_reg_n_0_[1] ),
        .O(p_0_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \audio_counter[2]_i_1 
       (.I0(\audio_counter_reg_n_0_[2] ),
        .I1(\audio_counter_reg_n_0_[1] ),
        .I2(\audio_counter_reg_n_0_[0] ),
        .O(p_0_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \audio_counter[3]_i_1 
       (.I0(\audio_counter_reg_n_0_[3] ),
        .I1(\audio_counter_reg_n_0_[0] ),
        .I2(\audio_counter_reg_n_0_[1] ),
        .I3(\audio_counter_reg_n_0_[2] ),
        .O(p_0_in[3]));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \audio_counter[4]_i_1 
       (.I0(O115[0]),
        .I1(\audio_counter_reg_n_0_[2] ),
        .I2(\audio_counter_reg_n_0_[1] ),
        .I3(\audio_counter_reg_n_0_[0] ),
        .I4(\audio_counter_reg_n_0_[3] ),
        .O(p_0_in[4]));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \audio_counter[5]_i_1 
       (.I0(\audio_counter_reg_n_0_[5] ),
        .I1(\audio_counter_reg_n_0_[3] ),
        .I2(\audio_counter_reg_n_0_[0] ),
        .I3(\audio_counter_reg_n_0_[1] ),
        .I4(\audio_counter_reg_n_0_[2] ),
        .I5(O115[0]),
        .O(p_0_in[5]));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \audio_counter[6]_i_1 
       (.I0(\audio_counter_reg_n_0_[6] ),
        .I1(\audio_counter[10]_i_2_n_0 ),
        .O(p_0_in[6]));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \audio_counter[7]_i_1 
       (.I0(\audio_counter_reg_n_0_[7] ),
        .I1(\audio_counter[10]_i_2_n_0 ),
        .I2(\audio_counter_reg_n_0_[6] ),
        .O(p_0_in[7]));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \audio_counter[8]_i_1 
       (.I0(\audio_counter_reg_n_0_[8] ),
        .I1(\audio_counter_reg_n_0_[6] ),
        .I2(\audio_counter[10]_i_2_n_0 ),
        .I3(\audio_counter_reg_n_0_[7] ),
        .O(p_0_in[8]));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \audio_counter[9]_i_1 
       (.I0(\audio_counter_reg_n_0_[9] ),
        .I1(\audio_counter_reg_n_0_[7] ),
        .I2(\audio_counter[10]_i_2_n_0 ),
        .I3(\audio_counter_reg_n_0_[6] ),
        .I4(\audio_counter_reg_n_0_[8] ),
        .O(p_0_in[9]));
  FDRE #(
    .INIT(1'b0)) 
    \audio_counter_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in[0]),
        .Q(\audio_counter_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \audio_counter_reg[10] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in[10]),
        .Q(O115[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \audio_counter_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in[1]),
        .Q(\audio_counter_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \audio_counter_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in[2]),
        .Q(\audio_counter_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \audio_counter_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in[3]),
        .Q(\audio_counter_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \audio_counter_reg[4] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in[4]),
        .Q(O115[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \audio_counter_reg[5] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in[5]),
        .Q(\audio_counter_reg_n_0_[5] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \audio_counter_reg[6] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in[6]),
        .Q(\audio_counter_reg_n_0_[6] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \audio_counter_reg[7] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in[7]),
        .Q(\audio_counter_reg_n_0_[7] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \audio_counter_reg[8] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in[8]),
        .Q(\audio_counter_reg_n_0_[8] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \audio_counter_reg[9] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in[9]),
        .Q(\audio_counter_reg_n_0_[9] ),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \locked_sync_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(codec_mclk_locked),
        .Q(locked_sync[0]),
        .R(registers_n_1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  FDRE \locked_sync_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(locked_sync[0]),
        .Q(locked_sync[1]),
        .R(registers_n_1));
  c6v_voice_volume_0_0_voice_volume_i2s_rx receiver
       (.O115(O115),
        .Q(pcm_s16),
        .S({receiver_n_2,receiver_n_3,receiver_n_4,receiver_n_5}),
        .SR(registers_n_1),
        .dc_clipped0(\core/dc_clipped0 ),
        .\difference_latched_reg[24] (\core/dc_level ),
        .i2s_sdata(i2s_sdata),
        .input_fault(input_fault),
        .\pcm_s16_reg[0]_0 (receiver_n_32),
        .\pcm_s16_reg[12]_0 ({receiver_n_22,receiver_n_23,receiver_n_24,receiver_n_25}),
        .\pcm_s16_reg[14]_0 ({receiver_n_26,receiver_n_27}),
        .\pcm_s16_reg[4]_0 ({receiver_n_28,receiver_n_29,receiver_n_30,receiver_n_31}),
        .pcm_valid(pcm_valid),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn));
  c6v_voice_volume_0_0_axi_voice_volume registers
       (.D(pcm_s16),
        .Q(\core/dc_level ),
        .S({receiver_n_2,receiver_n_3,receiver_n_4,receiver_n_5}),
        .SR(registers_n_1),
        .dc_clipped0(\core/dc_clipped0 ),
        .\difference_latched_reg[12] (receiver_n_32),
        .\difference_latched_reg[12]_0 ({receiver_n_28,receiver_n_29,receiver_n_30,receiver_n_31}),
        .\difference_latched_reg[20] ({receiver_n_22,receiver_n_23,receiver_n_24,receiver_n_25}),
        .\difference_latched_reg[24] ({receiver_n_26,receiver_n_27}),
        .input_fault(input_fault),
        .out(locked_sync[1]),
        .pcm_valid(pcm_valid),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid_reg_0(s_axi_bvalid_reg),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rready(s_axi_rready),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid_reg_0(s_axi_rvalid_reg),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid));
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
