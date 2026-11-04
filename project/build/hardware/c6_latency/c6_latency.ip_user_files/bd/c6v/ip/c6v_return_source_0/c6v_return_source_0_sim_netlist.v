// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Fri Oct 23 06:46:42 2026
// Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/vvl/c0e/c6_latency.gen/sources_1/bd/c6v/ip/c6v_return_source_0/c6v_return_source_0_sim_netlist.v
// Design      : c6v_return_source_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "c6v_return_source_0,scene2d_return_source,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "scene2d_return_source,Vivado 2026.1" *) 
(* NotValidForBitStream *)
module c6v_return_source_0
   (aclk,
    aresetn,
    start,
    requested_byte_count,
    seed,
    m_axis_tdata,
    m_axis_tkeep,
    m_axis_tlast,
    m_axis_tvalid,
    m_axis_tready,
    busy,
    completed_byte_count,
    completed_packet_count,
    rejected_start_count);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aclk, ASSOCIATED_BUSIF M_AXIS, ASSOCIATED_RESET aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input aresetn;
  input start;
  input [31:0]requested_byte_count;
  input [31:0]seed;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TDATA" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS, TDATA_NUM_BYTES 8, HAS_TKEEP 1, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 0, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, LAYERED_METADATA undef, INSERT_VIP 0" *) output [63:0]m_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TKEEP" *) output [7:0]m_axis_tkeep;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TLAST" *) output m_axis_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TVALID" *) output m_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TREADY" *) input m_axis_tready;
  output busy;
  output [31:0]completed_byte_count;
  output [31:0]completed_packet_count;
  output [31:0]rejected_start_count;

  wire aclk;
  wire aresetn;
  wire [31:0]completed_byte_count;
  wire [31:0]completed_packet_count;
  wire [63:26]\^m_axis_tdata ;
  wire [7:0]m_axis_tkeep;
  wire m_axis_tlast;
  wire m_axis_tready;
  wire m_axis_tvalid;
  wire [31:0]rejected_start_count;
  wire [31:0]requested_byte_count;
  wire [31:0]seed;
  wire start;

  assign busy = m_axis_tvalid;
  assign m_axis_tdata[63:56] = \^m_axis_tdata [63:56];
  assign m_axis_tdata[55:49] = \^m_axis_tdata [63:57];
  assign m_axis_tdata[48] = \^m_axis_tdata [48];
  assign m_axis_tdata[47:42] = \^m_axis_tdata [63:58];
  assign m_axis_tdata[41] = \^m_axis_tdata [41];
  assign m_axis_tdata[40] = \^m_axis_tdata [56];
  assign m_axis_tdata[39:34] = \^m_axis_tdata [63:58];
  assign m_axis_tdata[33] = \^m_axis_tdata [41];
  assign m_axis_tdata[32] = \^m_axis_tdata [48];
  assign m_axis_tdata[31:27] = \^m_axis_tdata [63:59];
  assign m_axis_tdata[26] = \^m_axis_tdata [26];
  assign m_axis_tdata[25:24] = \^m_axis_tdata [57:56];
  assign m_axis_tdata[23:19] = \^m_axis_tdata [63:59];
  assign m_axis_tdata[18] = \^m_axis_tdata [26];
  assign m_axis_tdata[17] = \^m_axis_tdata [57];
  assign m_axis_tdata[16] = \^m_axis_tdata [48];
  assign m_axis_tdata[15:11] = \^m_axis_tdata [63:59];
  assign m_axis_tdata[10] = \^m_axis_tdata [26];
  assign m_axis_tdata[9] = \^m_axis_tdata [41];
  assign m_axis_tdata[8] = \^m_axis_tdata [56];
  assign m_axis_tdata[7:3] = \^m_axis_tdata [63:59];
  assign m_axis_tdata[2] = \^m_axis_tdata [26];
  assign m_axis_tdata[1] = \^m_axis_tdata [41];
  assign m_axis_tdata[0] = \^m_axis_tdata [48];
  c6v_return_source_0_scene2d_return_source inst
       (.aclk(aclk),
        .aresetn(aresetn),
        .busy_reg_0(m_axis_tvalid),
        .completed_byte_count(completed_byte_count),
        .completed_packet_count(completed_packet_count),
        .m_axis_tdata({\^m_axis_tdata [63:56],\^m_axis_tdata [48],\^m_axis_tdata [41],\^m_axis_tdata [26]}),
        .m_axis_tkeep(m_axis_tkeep),
        .m_axis_tlast(m_axis_tlast),
        .m_axis_tready(m_axis_tready),
        .rejected_start_count(rejected_start_count),
        .requested_byte_count(requested_byte_count),
        .seed(seed),
        .start(start));
endmodule

(* ORIG_REF_NAME = "scene2d_return_source" *) 
module c6v_return_source_0_scene2d_return_source
   (busy_reg_0,
    m_axis_tdata,
    completed_byte_count,
    completed_packet_count,
    rejected_start_count,
    m_axis_tkeep,
    m_axis_tlast,
    start,
    aresetn,
    requested_byte_count,
    aclk,
    seed,
    m_axis_tready);
  output busy_reg_0;
  output [10:0]m_axis_tdata;
  output [31:0]completed_byte_count;
  output [31:0]completed_packet_count;
  output [31:0]rejected_start_count;
  output [7:0]m_axis_tkeep;
  output m_axis_tlast;
  input start;
  input aresetn;
  input [31:0]requested_byte_count;
  input aclk;
  input [31:0]seed;
  input m_axis_tready;

  wire aclk;
  wire [31:0]active_byte_count;
  wire [0:0]active_byte_count_0;
  wire [31:0]active_seed;
  wire aresetn;
  wire busy_i_10_n_0;
  wire busy_i_1_n_0;
  wire busy_i_2_n_0;
  wire busy_i_3_n_0;
  wire busy_i_4_n_0;
  wire busy_i_5_n_0;
  wire busy_i_6_n_0;
  wire busy_i_7_n_0;
  wire busy_i_8_n_0;
  wire busy_i_9_n_0;
  wire busy_reg_0;
  wire [0:0]byte_offset;
  wire byte_offset3_carry__0_i_1_n_0;
  wire byte_offset3_carry__0_i_2_n_0;
  wire byte_offset3_carry__0_i_3_n_0;
  wire byte_offset3_carry__0_i_4_n_0;
  wire byte_offset3_carry__0_n_0;
  wire byte_offset3_carry__0_n_1;
  wire byte_offset3_carry__0_n_2;
  wire byte_offset3_carry__0_n_3;
  wire byte_offset3_carry__0_n_4;
  wire byte_offset3_carry__0_n_5;
  wire byte_offset3_carry__0_n_6;
  wire byte_offset3_carry__0_n_7;
  wire byte_offset3_carry__1_i_1_n_0;
  wire byte_offset3_carry__1_i_2_n_0;
  wire byte_offset3_carry__1_i_3_n_0;
  wire byte_offset3_carry__1_i_4_n_0;
  wire byte_offset3_carry__1_n_0;
  wire byte_offset3_carry__1_n_1;
  wire byte_offset3_carry__1_n_2;
  wire byte_offset3_carry__1_n_3;
  wire byte_offset3_carry__1_n_4;
  wire byte_offset3_carry__1_n_5;
  wire byte_offset3_carry__1_n_6;
  wire byte_offset3_carry__1_n_7;
  wire byte_offset3_carry__2_i_1_n_0;
  wire byte_offset3_carry__2_i_2_n_0;
  wire byte_offset3_carry__2_i_3_n_0;
  wire byte_offset3_carry__2_i_4_n_0;
  wire byte_offset3_carry__2_n_0;
  wire byte_offset3_carry__2_n_1;
  wire byte_offset3_carry__2_n_2;
  wire byte_offset3_carry__2_n_3;
  wire byte_offset3_carry__2_n_4;
  wire byte_offset3_carry__2_n_5;
  wire byte_offset3_carry__2_n_6;
  wire byte_offset3_carry__2_n_7;
  wire byte_offset3_carry__3_i_1_n_0;
  wire byte_offset3_carry__3_i_2_n_0;
  wire byte_offset3_carry__3_i_3_n_0;
  wire byte_offset3_carry__3_i_4_n_0;
  wire byte_offset3_carry__3_n_0;
  wire byte_offset3_carry__3_n_1;
  wire byte_offset3_carry__3_n_2;
  wire byte_offset3_carry__3_n_3;
  wire byte_offset3_carry__3_n_4;
  wire byte_offset3_carry__3_n_5;
  wire byte_offset3_carry__3_n_6;
  wire byte_offset3_carry__3_n_7;
  wire byte_offset3_carry__4_i_1_n_0;
  wire byte_offset3_carry__4_i_2_n_0;
  wire byte_offset3_carry__4_i_3_n_0;
  wire byte_offset3_carry__4_i_4_n_0;
  wire byte_offset3_carry__4_n_0;
  wire byte_offset3_carry__4_n_1;
  wire byte_offset3_carry__4_n_2;
  wire byte_offset3_carry__4_n_3;
  wire byte_offset3_carry__4_n_4;
  wire byte_offset3_carry__4_n_5;
  wire byte_offset3_carry__4_n_6;
  wire byte_offset3_carry__4_n_7;
  wire byte_offset3_carry__5_i_1_n_0;
  wire byte_offset3_carry__5_i_2_n_0;
  wire byte_offset3_carry__5_i_3_n_0;
  wire byte_offset3_carry__5_i_4_n_0;
  wire byte_offset3_carry__5_n_0;
  wire byte_offset3_carry__5_n_1;
  wire byte_offset3_carry__5_n_2;
  wire byte_offset3_carry__5_n_3;
  wire byte_offset3_carry__5_n_4;
  wire byte_offset3_carry__5_n_5;
  wire byte_offset3_carry__5_n_6;
  wire byte_offset3_carry__5_n_7;
  wire byte_offset3_carry__6_i_1_n_0;
  wire byte_offset3_carry__6_i_2_n_0;
  wire byte_offset3_carry__6_i_3_n_0;
  wire byte_offset3_carry__6_i_4_n_0;
  wire byte_offset3_carry__6_n_1;
  wire byte_offset3_carry__6_n_2;
  wire byte_offset3_carry__6_n_3;
  wire byte_offset3_carry__6_n_4;
  wire byte_offset3_carry__6_n_5;
  wire byte_offset3_carry__6_n_6;
  wire byte_offset3_carry__6_n_7;
  wire byte_offset3_carry_i_1_n_0;
  wire byte_offset3_carry_i_2_n_0;
  wire byte_offset3_carry_i_3_n_0;
  wire byte_offset3_carry_i_4_n_0;
  wire byte_offset3_carry_n_0;
  wire byte_offset3_carry_n_1;
  wire byte_offset3_carry_n_2;
  wire byte_offset3_carry_n_3;
  wire byte_offset3_carry_n_4;
  wire byte_offset3_carry_n_5;
  wire byte_offset3_carry_n_6;
  wire byte_offset3_carry_n_7;
  wire \byte_offset[3]_i_1_n_0 ;
  wire \byte_offset[3]_i_4_n_0 ;
  wire [31:3]byte_offset_reg;
  wire \byte_offset_reg[11]_i_1_n_0 ;
  wire \byte_offset_reg[11]_i_1_n_1 ;
  wire \byte_offset_reg[11]_i_1_n_2 ;
  wire \byte_offset_reg[11]_i_1_n_3 ;
  wire \byte_offset_reg[11]_i_1_n_4 ;
  wire \byte_offset_reg[11]_i_1_n_5 ;
  wire \byte_offset_reg[11]_i_1_n_6 ;
  wire \byte_offset_reg[11]_i_1_n_7 ;
  wire \byte_offset_reg[15]_i_1_n_0 ;
  wire \byte_offset_reg[15]_i_1_n_1 ;
  wire \byte_offset_reg[15]_i_1_n_2 ;
  wire \byte_offset_reg[15]_i_1_n_3 ;
  wire \byte_offset_reg[15]_i_1_n_4 ;
  wire \byte_offset_reg[15]_i_1_n_5 ;
  wire \byte_offset_reg[15]_i_1_n_6 ;
  wire \byte_offset_reg[15]_i_1_n_7 ;
  wire \byte_offset_reg[19]_i_1_n_0 ;
  wire \byte_offset_reg[19]_i_1_n_1 ;
  wire \byte_offset_reg[19]_i_1_n_2 ;
  wire \byte_offset_reg[19]_i_1_n_3 ;
  wire \byte_offset_reg[19]_i_1_n_4 ;
  wire \byte_offset_reg[19]_i_1_n_5 ;
  wire \byte_offset_reg[19]_i_1_n_6 ;
  wire \byte_offset_reg[19]_i_1_n_7 ;
  wire \byte_offset_reg[23]_i_1_n_0 ;
  wire \byte_offset_reg[23]_i_1_n_1 ;
  wire \byte_offset_reg[23]_i_1_n_2 ;
  wire \byte_offset_reg[23]_i_1_n_3 ;
  wire \byte_offset_reg[23]_i_1_n_4 ;
  wire \byte_offset_reg[23]_i_1_n_5 ;
  wire \byte_offset_reg[23]_i_1_n_6 ;
  wire \byte_offset_reg[23]_i_1_n_7 ;
  wire \byte_offset_reg[27]_i_1_n_0 ;
  wire \byte_offset_reg[27]_i_1_n_1 ;
  wire \byte_offset_reg[27]_i_1_n_2 ;
  wire \byte_offset_reg[27]_i_1_n_3 ;
  wire \byte_offset_reg[27]_i_1_n_4 ;
  wire \byte_offset_reg[27]_i_1_n_5 ;
  wire \byte_offset_reg[27]_i_1_n_6 ;
  wire \byte_offset_reg[27]_i_1_n_7 ;
  wire \byte_offset_reg[31]_i_1_n_7 ;
  wire \byte_offset_reg[3]_i_3_n_0 ;
  wire \byte_offset_reg[3]_i_3_n_1 ;
  wire \byte_offset_reg[3]_i_3_n_2 ;
  wire \byte_offset_reg[3]_i_3_n_3 ;
  wire \byte_offset_reg[3]_i_3_n_4 ;
  wire \byte_offset_reg[3]_i_3_n_5 ;
  wire \byte_offset_reg[3]_i_3_n_6 ;
  wire \byte_offset_reg[3]_i_3_n_7 ;
  wire \byte_offset_reg[7]_i_1_n_0 ;
  wire \byte_offset_reg[7]_i_1_n_1 ;
  wire \byte_offset_reg[7]_i_1_n_2 ;
  wire \byte_offset_reg[7]_i_1_n_3 ;
  wire \byte_offset_reg[7]_i_1_n_4 ;
  wire \byte_offset_reg[7]_i_1_n_5 ;
  wire \byte_offset_reg[7]_i_1_n_6 ;
  wire \byte_offset_reg[7]_i_1_n_7 ;
  wire clear;
  wire [31:0]completed_byte_count;
  wire \completed_byte_count[31]_i_2_n_0 ;
  wire \completed_byte_count[31]_i_3_n_0 ;
  wire \completed_byte_count[31]_i_4_n_0 ;
  wire [31:0]completed_packet_count;
  wire \completed_packet_count[3]_i_2_n_0 ;
  wire \completed_packet_count_reg[11]_i_1_n_0 ;
  wire \completed_packet_count_reg[11]_i_1_n_1 ;
  wire \completed_packet_count_reg[11]_i_1_n_2 ;
  wire \completed_packet_count_reg[11]_i_1_n_3 ;
  wire \completed_packet_count_reg[11]_i_1_n_4 ;
  wire \completed_packet_count_reg[11]_i_1_n_5 ;
  wire \completed_packet_count_reg[11]_i_1_n_6 ;
  wire \completed_packet_count_reg[11]_i_1_n_7 ;
  wire \completed_packet_count_reg[15]_i_1_n_0 ;
  wire \completed_packet_count_reg[15]_i_1_n_1 ;
  wire \completed_packet_count_reg[15]_i_1_n_2 ;
  wire \completed_packet_count_reg[15]_i_1_n_3 ;
  wire \completed_packet_count_reg[15]_i_1_n_4 ;
  wire \completed_packet_count_reg[15]_i_1_n_5 ;
  wire \completed_packet_count_reg[15]_i_1_n_6 ;
  wire \completed_packet_count_reg[15]_i_1_n_7 ;
  wire \completed_packet_count_reg[19]_i_1_n_0 ;
  wire \completed_packet_count_reg[19]_i_1_n_1 ;
  wire \completed_packet_count_reg[19]_i_1_n_2 ;
  wire \completed_packet_count_reg[19]_i_1_n_3 ;
  wire \completed_packet_count_reg[19]_i_1_n_4 ;
  wire \completed_packet_count_reg[19]_i_1_n_5 ;
  wire \completed_packet_count_reg[19]_i_1_n_6 ;
  wire \completed_packet_count_reg[19]_i_1_n_7 ;
  wire \completed_packet_count_reg[23]_i_1_n_0 ;
  wire \completed_packet_count_reg[23]_i_1_n_1 ;
  wire \completed_packet_count_reg[23]_i_1_n_2 ;
  wire \completed_packet_count_reg[23]_i_1_n_3 ;
  wire \completed_packet_count_reg[23]_i_1_n_4 ;
  wire \completed_packet_count_reg[23]_i_1_n_5 ;
  wire \completed_packet_count_reg[23]_i_1_n_6 ;
  wire \completed_packet_count_reg[23]_i_1_n_7 ;
  wire \completed_packet_count_reg[27]_i_1_n_0 ;
  wire \completed_packet_count_reg[27]_i_1_n_1 ;
  wire \completed_packet_count_reg[27]_i_1_n_2 ;
  wire \completed_packet_count_reg[27]_i_1_n_3 ;
  wire \completed_packet_count_reg[27]_i_1_n_4 ;
  wire \completed_packet_count_reg[27]_i_1_n_5 ;
  wire \completed_packet_count_reg[27]_i_1_n_6 ;
  wire \completed_packet_count_reg[27]_i_1_n_7 ;
  wire \completed_packet_count_reg[31]_i_1_n_1 ;
  wire \completed_packet_count_reg[31]_i_1_n_2 ;
  wire \completed_packet_count_reg[31]_i_1_n_3 ;
  wire \completed_packet_count_reg[31]_i_1_n_4 ;
  wire \completed_packet_count_reg[31]_i_1_n_5 ;
  wire \completed_packet_count_reg[31]_i_1_n_6 ;
  wire \completed_packet_count_reg[31]_i_1_n_7 ;
  wire \completed_packet_count_reg[3]_i_1_n_0 ;
  wire \completed_packet_count_reg[3]_i_1_n_1 ;
  wire \completed_packet_count_reg[3]_i_1_n_2 ;
  wire \completed_packet_count_reg[3]_i_1_n_3 ;
  wire \completed_packet_count_reg[3]_i_1_n_4 ;
  wire \completed_packet_count_reg[3]_i_1_n_5 ;
  wire \completed_packet_count_reg[3]_i_1_n_6 ;
  wire \completed_packet_count_reg[3]_i_1_n_7 ;
  wire \completed_packet_count_reg[7]_i_1_n_0 ;
  wire \completed_packet_count_reg[7]_i_1_n_1 ;
  wire \completed_packet_count_reg[7]_i_1_n_2 ;
  wire \completed_packet_count_reg[7]_i_1_n_3 ;
  wire \completed_packet_count_reg[7]_i_1_n_4 ;
  wire \completed_packet_count_reg[7]_i_1_n_5 ;
  wire \completed_packet_count_reg[7]_i_1_n_6 ;
  wire \completed_packet_count_reg[7]_i_1_n_7 ;
  wire [10:0]m_axis_tdata;
  wire \m_axis_tdata[17]_INST_0_i_1_n_0 ;
  wire \m_axis_tdata[34]_INST_0_i_1_n_0 ;
  wire \m_axis_tdata[3]_INST_0_i_1_n_0 ;
  wire \m_axis_tdata[4]_INST_0_i_1_n_0 ;
  wire \m_axis_tdata[5]_INST_0_i_1_n_0 ;
  wire \m_axis_tdata[6]_INST_0_i_1_n_0 ;
  wire \m_axis_tdata[7]_INST_0_i_1_n_0 ;
  wire \m_axis_tdata[8]_INST_0_i_1_n_0 ;
  wire [7:0]m_axis_tkeep;
  wire \m_axis_tkeep[7]_INST_0_i_1_n_0 ;
  wire \m_axis_tkeep[7]_INST_0_i_2_n_0 ;
  wire \m_axis_tkeep[7]_INST_0_i_3_n_0 ;
  wire \m_axis_tkeep[7]_INST_0_i_4_n_0 ;
  wire \m_axis_tkeep[7]_INST_0_i_5_n_0 ;
  wire \m_axis_tkeep[7]_INST_0_i_6_n_0 ;
  wire \m_axis_tkeep[7]_INST_0_i_7_n_0 ;
  wire \m_axis_tkeep[7]_INST_0_i_8_n_0 ;
  wire m_axis_tlast;
  wire m_axis_tready;
  wire [31:0]rejected_start_count;
  wire \rejected_start_count[31]_i_1_n_0 ;
  wire \rejected_start_count[3]_i_2_n_0 ;
  wire \rejected_start_count_reg[11]_i_1_n_0 ;
  wire \rejected_start_count_reg[11]_i_1_n_1 ;
  wire \rejected_start_count_reg[11]_i_1_n_2 ;
  wire \rejected_start_count_reg[11]_i_1_n_3 ;
  wire \rejected_start_count_reg[11]_i_1_n_4 ;
  wire \rejected_start_count_reg[11]_i_1_n_5 ;
  wire \rejected_start_count_reg[11]_i_1_n_6 ;
  wire \rejected_start_count_reg[11]_i_1_n_7 ;
  wire \rejected_start_count_reg[15]_i_1_n_0 ;
  wire \rejected_start_count_reg[15]_i_1_n_1 ;
  wire \rejected_start_count_reg[15]_i_1_n_2 ;
  wire \rejected_start_count_reg[15]_i_1_n_3 ;
  wire \rejected_start_count_reg[15]_i_1_n_4 ;
  wire \rejected_start_count_reg[15]_i_1_n_5 ;
  wire \rejected_start_count_reg[15]_i_1_n_6 ;
  wire \rejected_start_count_reg[15]_i_1_n_7 ;
  wire \rejected_start_count_reg[19]_i_1_n_0 ;
  wire \rejected_start_count_reg[19]_i_1_n_1 ;
  wire \rejected_start_count_reg[19]_i_1_n_2 ;
  wire \rejected_start_count_reg[19]_i_1_n_3 ;
  wire \rejected_start_count_reg[19]_i_1_n_4 ;
  wire \rejected_start_count_reg[19]_i_1_n_5 ;
  wire \rejected_start_count_reg[19]_i_1_n_6 ;
  wire \rejected_start_count_reg[19]_i_1_n_7 ;
  wire \rejected_start_count_reg[23]_i_1_n_0 ;
  wire \rejected_start_count_reg[23]_i_1_n_1 ;
  wire \rejected_start_count_reg[23]_i_1_n_2 ;
  wire \rejected_start_count_reg[23]_i_1_n_3 ;
  wire \rejected_start_count_reg[23]_i_1_n_4 ;
  wire \rejected_start_count_reg[23]_i_1_n_5 ;
  wire \rejected_start_count_reg[23]_i_1_n_6 ;
  wire \rejected_start_count_reg[23]_i_1_n_7 ;
  wire \rejected_start_count_reg[27]_i_1_n_0 ;
  wire \rejected_start_count_reg[27]_i_1_n_1 ;
  wire \rejected_start_count_reg[27]_i_1_n_2 ;
  wire \rejected_start_count_reg[27]_i_1_n_3 ;
  wire \rejected_start_count_reg[27]_i_1_n_4 ;
  wire \rejected_start_count_reg[27]_i_1_n_5 ;
  wire \rejected_start_count_reg[27]_i_1_n_6 ;
  wire \rejected_start_count_reg[27]_i_1_n_7 ;
  wire \rejected_start_count_reg[31]_i_2_n_1 ;
  wire \rejected_start_count_reg[31]_i_2_n_2 ;
  wire \rejected_start_count_reg[31]_i_2_n_3 ;
  wire \rejected_start_count_reg[31]_i_2_n_4 ;
  wire \rejected_start_count_reg[31]_i_2_n_5 ;
  wire \rejected_start_count_reg[31]_i_2_n_6 ;
  wire \rejected_start_count_reg[31]_i_2_n_7 ;
  wire \rejected_start_count_reg[3]_i_1_n_0 ;
  wire \rejected_start_count_reg[3]_i_1_n_1 ;
  wire \rejected_start_count_reg[3]_i_1_n_2 ;
  wire \rejected_start_count_reg[3]_i_1_n_3 ;
  wire \rejected_start_count_reg[3]_i_1_n_4 ;
  wire \rejected_start_count_reg[3]_i_1_n_5 ;
  wire \rejected_start_count_reg[3]_i_1_n_6 ;
  wire \rejected_start_count_reg[3]_i_1_n_7 ;
  wire \rejected_start_count_reg[7]_i_1_n_0 ;
  wire \rejected_start_count_reg[7]_i_1_n_1 ;
  wire \rejected_start_count_reg[7]_i_1_n_2 ;
  wire \rejected_start_count_reg[7]_i_1_n_3 ;
  wire \rejected_start_count_reg[7]_i_1_n_4 ;
  wire \rejected_start_count_reg[7]_i_1_n_5 ;
  wire \rejected_start_count_reg[7]_i_1_n_6 ;
  wire \rejected_start_count_reg[7]_i_1_n_7 ;
  wire [31:0]requested_byte_count;
  wire [31:0]seed;
  wire start;
  wire start_delayed;
  wire start_delayed_i_1_n_0;
  wire [3:3]NLW_byte_offset3_carry__6_CO_UNCONNECTED;
  wire [3:0]\NLW_byte_offset_reg[31]_i_1_CO_UNCONNECTED ;
  wire [3:1]\NLW_byte_offset_reg[31]_i_1_O_UNCONNECTED ;
  wire [3:3]\NLW_completed_packet_count_reg[31]_i_1_CO_UNCONNECTED ;
  wire [3:3]\NLW_rejected_start_count_reg[31]_i_2_CO_UNCONNECTED ;

  LUT4 #(
    .INIT(16'h0200)) 
    \active_byte_count[31]_i_1 
       (.I0(busy_i_2_n_0),
        .I1(busy_reg_0),
        .I2(start_delayed),
        .I3(start),
        .O(active_byte_count_0));
  FDRE \active_byte_count_reg[0] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[0]),
        .Q(active_byte_count[0]),
        .R(clear));
  FDRE \active_byte_count_reg[10] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[10]),
        .Q(active_byte_count[10]),
        .R(clear));
  FDRE \active_byte_count_reg[11] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[11]),
        .Q(active_byte_count[11]),
        .R(clear));
  FDRE \active_byte_count_reg[12] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[12]),
        .Q(active_byte_count[12]),
        .R(clear));
  FDRE \active_byte_count_reg[13] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[13]),
        .Q(active_byte_count[13]),
        .R(clear));
  FDRE \active_byte_count_reg[14] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[14]),
        .Q(active_byte_count[14]),
        .R(clear));
  FDRE \active_byte_count_reg[15] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[15]),
        .Q(active_byte_count[15]),
        .R(clear));
  FDRE \active_byte_count_reg[16] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[16]),
        .Q(active_byte_count[16]),
        .R(clear));
  FDRE \active_byte_count_reg[17] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[17]),
        .Q(active_byte_count[17]),
        .R(clear));
  FDRE \active_byte_count_reg[18] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[18]),
        .Q(active_byte_count[18]),
        .R(clear));
  FDRE \active_byte_count_reg[19] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[19]),
        .Q(active_byte_count[19]),
        .R(clear));
  FDRE \active_byte_count_reg[1] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[1]),
        .Q(active_byte_count[1]),
        .R(clear));
  FDRE \active_byte_count_reg[20] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[20]),
        .Q(active_byte_count[20]),
        .R(clear));
  FDRE \active_byte_count_reg[21] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[21]),
        .Q(active_byte_count[21]),
        .R(clear));
  FDRE \active_byte_count_reg[22] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[22]),
        .Q(active_byte_count[22]),
        .R(clear));
  FDRE \active_byte_count_reg[23] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[23]),
        .Q(active_byte_count[23]),
        .R(clear));
  FDRE \active_byte_count_reg[24] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[24]),
        .Q(active_byte_count[24]),
        .R(clear));
  FDRE \active_byte_count_reg[25] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[25]),
        .Q(active_byte_count[25]),
        .R(clear));
  FDRE \active_byte_count_reg[26] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[26]),
        .Q(active_byte_count[26]),
        .R(clear));
  FDRE \active_byte_count_reg[27] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[27]),
        .Q(active_byte_count[27]),
        .R(clear));
  FDRE \active_byte_count_reg[28] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[28]),
        .Q(active_byte_count[28]),
        .R(clear));
  FDRE \active_byte_count_reg[29] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[29]),
        .Q(active_byte_count[29]),
        .R(clear));
  FDRE \active_byte_count_reg[2] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[2]),
        .Q(active_byte_count[2]),
        .R(clear));
  FDRE \active_byte_count_reg[30] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[30]),
        .Q(active_byte_count[30]),
        .R(clear));
  FDRE \active_byte_count_reg[31] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[31]),
        .Q(active_byte_count[31]),
        .R(clear));
  FDRE \active_byte_count_reg[3] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[3]),
        .Q(active_byte_count[3]),
        .R(clear));
  FDRE \active_byte_count_reg[4] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[4]),
        .Q(active_byte_count[4]),
        .R(clear));
  FDRE \active_byte_count_reg[5] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[5]),
        .Q(active_byte_count[5]),
        .R(clear));
  FDRE \active_byte_count_reg[6] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[6]),
        .Q(active_byte_count[6]),
        .R(clear));
  FDRE \active_byte_count_reg[7] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[7]),
        .Q(active_byte_count[7]),
        .R(clear));
  FDRE \active_byte_count_reg[8] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[8]),
        .Q(active_byte_count[8]),
        .R(clear));
  FDRE \active_byte_count_reg[9] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(requested_byte_count[9]),
        .Q(active_byte_count[9]),
        .R(clear));
  FDRE \active_seed_reg[0] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[0]),
        .Q(active_seed[0]),
        .R(clear));
  FDRE \active_seed_reg[10] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[10]),
        .Q(active_seed[10]),
        .R(clear));
  FDRE \active_seed_reg[11] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[11]),
        .Q(active_seed[11]),
        .R(clear));
  FDRE \active_seed_reg[12] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[12]),
        .Q(active_seed[12]),
        .R(clear));
  FDRE \active_seed_reg[13] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[13]),
        .Q(active_seed[13]),
        .R(clear));
  FDRE \active_seed_reg[14] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[14]),
        .Q(active_seed[14]),
        .R(clear));
  FDRE \active_seed_reg[15] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[15]),
        .Q(active_seed[15]),
        .R(clear));
  FDRE \active_seed_reg[16] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[16]),
        .Q(active_seed[16]),
        .R(clear));
  FDRE \active_seed_reg[17] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[17]),
        .Q(active_seed[17]),
        .R(clear));
  FDRE \active_seed_reg[18] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[18]),
        .Q(active_seed[18]),
        .R(clear));
  FDRE \active_seed_reg[19] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[19]),
        .Q(active_seed[19]),
        .R(clear));
  FDRE \active_seed_reg[1] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[1]),
        .Q(active_seed[1]),
        .R(clear));
  FDRE \active_seed_reg[20] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[20]),
        .Q(active_seed[20]),
        .R(clear));
  FDRE \active_seed_reg[21] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[21]),
        .Q(active_seed[21]),
        .R(clear));
  FDRE \active_seed_reg[22] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[22]),
        .Q(active_seed[22]),
        .R(clear));
  FDRE \active_seed_reg[23] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[23]),
        .Q(active_seed[23]),
        .R(clear));
  FDRE \active_seed_reg[24] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[24]),
        .Q(active_seed[24]),
        .R(clear));
  FDRE \active_seed_reg[25] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[25]),
        .Q(active_seed[25]),
        .R(clear));
  FDRE \active_seed_reg[26] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[26]),
        .Q(active_seed[26]),
        .R(clear));
  FDRE \active_seed_reg[27] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[27]),
        .Q(active_seed[27]),
        .R(clear));
  FDRE \active_seed_reg[28] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[28]),
        .Q(active_seed[28]),
        .R(clear));
  FDRE \active_seed_reg[29] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[29]),
        .Q(active_seed[29]),
        .R(clear));
  FDRE \active_seed_reg[2] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[2]),
        .Q(active_seed[2]),
        .R(clear));
  FDRE \active_seed_reg[30] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[30]),
        .Q(active_seed[30]),
        .R(clear));
  FDRE \active_seed_reg[31] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[31]),
        .Q(active_seed[31]),
        .R(clear));
  FDRE \active_seed_reg[3] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[3]),
        .Q(active_seed[3]),
        .R(clear));
  FDRE \active_seed_reg[4] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[4]),
        .Q(active_seed[4]),
        .R(clear));
  FDRE \active_seed_reg[5] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[5]),
        .Q(active_seed[5]),
        .R(clear));
  FDRE \active_seed_reg[6] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[6]),
        .Q(active_seed[6]),
        .R(clear));
  FDRE \active_seed_reg[7] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[7]),
        .Q(active_seed[7]),
        .R(clear));
  FDRE \active_seed_reg[8] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[8]),
        .Q(active_seed[8]),
        .R(clear));
  FDRE \active_seed_reg[9] 
       (.C(aclk),
        .CE(active_byte_count_0),
        .D(seed[9]),
        .Q(active_seed[9]),
        .R(clear));
  LUT6 #(
    .INIT(64'h0F00CECC00000000)) 
    busy_i_1
       (.I0(busy_i_2_n_0),
        .I1(busy_reg_0),
        .I2(start_delayed),
        .I3(start),
        .I4(\completed_byte_count[31]_i_2_n_0 ),
        .I5(aresetn),
        .O(busy_i_1_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    busy_i_10
       (.I0(requested_byte_count[21]),
        .I1(requested_byte_count[20]),
        .I2(requested_byte_count[23]),
        .I3(requested_byte_count[22]),
        .O(busy_i_10_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    busy_i_2
       (.I0(busy_i_3_n_0),
        .I1(busy_i_4_n_0),
        .I2(busy_i_5_n_0),
        .I3(busy_i_6_n_0),
        .O(busy_i_2_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    busy_i_3
       (.I0(requested_byte_count[10]),
        .I1(requested_byte_count[11]),
        .I2(requested_byte_count[8]),
        .I3(requested_byte_count[9]),
        .I4(busy_i_7_n_0),
        .O(busy_i_3_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    busy_i_4
       (.I0(requested_byte_count[2]),
        .I1(requested_byte_count[3]),
        .I2(requested_byte_count[0]),
        .I3(requested_byte_count[1]),
        .I4(busy_i_8_n_0),
        .O(busy_i_4_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    busy_i_5
       (.I0(requested_byte_count[26]),
        .I1(requested_byte_count[27]),
        .I2(requested_byte_count[24]),
        .I3(requested_byte_count[25]),
        .I4(busy_i_9_n_0),
        .O(busy_i_5_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    busy_i_6
       (.I0(requested_byte_count[18]),
        .I1(requested_byte_count[19]),
        .I2(requested_byte_count[16]),
        .I3(requested_byte_count[17]),
        .I4(busy_i_10_n_0),
        .O(busy_i_6_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    busy_i_7
       (.I0(requested_byte_count[13]),
        .I1(requested_byte_count[12]),
        .I2(requested_byte_count[15]),
        .I3(requested_byte_count[14]),
        .O(busy_i_7_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    busy_i_8
       (.I0(requested_byte_count[5]),
        .I1(requested_byte_count[4]),
        .I2(requested_byte_count[7]),
        .I3(requested_byte_count[6]),
        .O(busy_i_8_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    busy_i_9
       (.I0(requested_byte_count[29]),
        .I1(requested_byte_count[28]),
        .I2(requested_byte_count[31]),
        .I3(requested_byte_count[30]),
        .O(busy_i_9_n_0));
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TVALID" *) 
  FDRE busy_reg
       (.C(aclk),
        .CE(1'b1),
        .D(busy_i_1_n_0),
        .Q(busy_reg_0),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 byte_offset3_carry
       (.CI(1'b0),
        .CO({byte_offset3_carry_n_0,byte_offset3_carry_n_1,byte_offset3_carry_n_2,byte_offset3_carry_n_3}),
        .CYINIT(1'b1),
        .DI(active_byte_count[3:0]),
        .O({byte_offset3_carry_n_4,byte_offset3_carry_n_5,byte_offset3_carry_n_6,byte_offset3_carry_n_7}),
        .S({byte_offset3_carry_i_1_n_0,byte_offset3_carry_i_2_n_0,byte_offset3_carry_i_3_n_0,byte_offset3_carry_i_4_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 byte_offset3_carry__0
       (.CI(byte_offset3_carry_n_0),
        .CO({byte_offset3_carry__0_n_0,byte_offset3_carry__0_n_1,byte_offset3_carry__0_n_2,byte_offset3_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI(active_byte_count[7:4]),
        .O({byte_offset3_carry__0_n_4,byte_offset3_carry__0_n_5,byte_offset3_carry__0_n_6,byte_offset3_carry__0_n_7}),
        .S({byte_offset3_carry__0_i_1_n_0,byte_offset3_carry__0_i_2_n_0,byte_offset3_carry__0_i_3_n_0,byte_offset3_carry__0_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__0_i_1
       (.I0(active_byte_count[7]),
        .I1(byte_offset_reg[7]),
        .O(byte_offset3_carry__0_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__0_i_2
       (.I0(active_byte_count[6]),
        .I1(byte_offset_reg[6]),
        .O(byte_offset3_carry__0_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__0_i_3
       (.I0(active_byte_count[5]),
        .I1(byte_offset_reg[5]),
        .O(byte_offset3_carry__0_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__0_i_4
       (.I0(active_byte_count[4]),
        .I1(byte_offset_reg[4]),
        .O(byte_offset3_carry__0_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 byte_offset3_carry__1
       (.CI(byte_offset3_carry__0_n_0),
        .CO({byte_offset3_carry__1_n_0,byte_offset3_carry__1_n_1,byte_offset3_carry__1_n_2,byte_offset3_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI(active_byte_count[11:8]),
        .O({byte_offset3_carry__1_n_4,byte_offset3_carry__1_n_5,byte_offset3_carry__1_n_6,byte_offset3_carry__1_n_7}),
        .S({byte_offset3_carry__1_i_1_n_0,byte_offset3_carry__1_i_2_n_0,byte_offset3_carry__1_i_3_n_0,byte_offset3_carry__1_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__1_i_1
       (.I0(active_byte_count[11]),
        .I1(byte_offset_reg[11]),
        .O(byte_offset3_carry__1_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__1_i_2
       (.I0(active_byte_count[10]),
        .I1(byte_offset_reg[10]),
        .O(byte_offset3_carry__1_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__1_i_3
       (.I0(active_byte_count[9]),
        .I1(byte_offset_reg[9]),
        .O(byte_offset3_carry__1_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__1_i_4
       (.I0(active_byte_count[8]),
        .I1(byte_offset_reg[8]),
        .O(byte_offset3_carry__1_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 byte_offset3_carry__2
       (.CI(byte_offset3_carry__1_n_0),
        .CO({byte_offset3_carry__2_n_0,byte_offset3_carry__2_n_1,byte_offset3_carry__2_n_2,byte_offset3_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI(active_byte_count[15:12]),
        .O({byte_offset3_carry__2_n_4,byte_offset3_carry__2_n_5,byte_offset3_carry__2_n_6,byte_offset3_carry__2_n_7}),
        .S({byte_offset3_carry__2_i_1_n_0,byte_offset3_carry__2_i_2_n_0,byte_offset3_carry__2_i_3_n_0,byte_offset3_carry__2_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__2_i_1
       (.I0(active_byte_count[15]),
        .I1(byte_offset_reg[15]),
        .O(byte_offset3_carry__2_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__2_i_2
       (.I0(active_byte_count[14]),
        .I1(byte_offset_reg[14]),
        .O(byte_offset3_carry__2_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__2_i_3
       (.I0(active_byte_count[13]),
        .I1(byte_offset_reg[13]),
        .O(byte_offset3_carry__2_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__2_i_4
       (.I0(active_byte_count[12]),
        .I1(byte_offset_reg[12]),
        .O(byte_offset3_carry__2_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 byte_offset3_carry__3
       (.CI(byte_offset3_carry__2_n_0),
        .CO({byte_offset3_carry__3_n_0,byte_offset3_carry__3_n_1,byte_offset3_carry__3_n_2,byte_offset3_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI(active_byte_count[19:16]),
        .O({byte_offset3_carry__3_n_4,byte_offset3_carry__3_n_5,byte_offset3_carry__3_n_6,byte_offset3_carry__3_n_7}),
        .S({byte_offset3_carry__3_i_1_n_0,byte_offset3_carry__3_i_2_n_0,byte_offset3_carry__3_i_3_n_0,byte_offset3_carry__3_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__3_i_1
       (.I0(active_byte_count[19]),
        .I1(byte_offset_reg[19]),
        .O(byte_offset3_carry__3_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__3_i_2
       (.I0(active_byte_count[18]),
        .I1(byte_offset_reg[18]),
        .O(byte_offset3_carry__3_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__3_i_3
       (.I0(active_byte_count[17]),
        .I1(byte_offset_reg[17]),
        .O(byte_offset3_carry__3_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__3_i_4
       (.I0(active_byte_count[16]),
        .I1(byte_offset_reg[16]),
        .O(byte_offset3_carry__3_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 byte_offset3_carry__4
       (.CI(byte_offset3_carry__3_n_0),
        .CO({byte_offset3_carry__4_n_0,byte_offset3_carry__4_n_1,byte_offset3_carry__4_n_2,byte_offset3_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI(active_byte_count[23:20]),
        .O({byte_offset3_carry__4_n_4,byte_offset3_carry__4_n_5,byte_offset3_carry__4_n_6,byte_offset3_carry__4_n_7}),
        .S({byte_offset3_carry__4_i_1_n_0,byte_offset3_carry__4_i_2_n_0,byte_offset3_carry__4_i_3_n_0,byte_offset3_carry__4_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__4_i_1
       (.I0(active_byte_count[23]),
        .I1(byte_offset_reg[23]),
        .O(byte_offset3_carry__4_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__4_i_2
       (.I0(active_byte_count[22]),
        .I1(byte_offset_reg[22]),
        .O(byte_offset3_carry__4_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__4_i_3
       (.I0(active_byte_count[21]),
        .I1(byte_offset_reg[21]),
        .O(byte_offset3_carry__4_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__4_i_4
       (.I0(active_byte_count[20]),
        .I1(byte_offset_reg[20]),
        .O(byte_offset3_carry__4_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 byte_offset3_carry__5
       (.CI(byte_offset3_carry__4_n_0),
        .CO({byte_offset3_carry__5_n_0,byte_offset3_carry__5_n_1,byte_offset3_carry__5_n_2,byte_offset3_carry__5_n_3}),
        .CYINIT(1'b0),
        .DI(active_byte_count[27:24]),
        .O({byte_offset3_carry__5_n_4,byte_offset3_carry__5_n_5,byte_offset3_carry__5_n_6,byte_offset3_carry__5_n_7}),
        .S({byte_offset3_carry__5_i_1_n_0,byte_offset3_carry__5_i_2_n_0,byte_offset3_carry__5_i_3_n_0,byte_offset3_carry__5_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__5_i_1
       (.I0(active_byte_count[27]),
        .I1(byte_offset_reg[27]),
        .O(byte_offset3_carry__5_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__5_i_2
       (.I0(active_byte_count[26]),
        .I1(byte_offset_reg[26]),
        .O(byte_offset3_carry__5_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__5_i_3
       (.I0(active_byte_count[25]),
        .I1(byte_offset_reg[25]),
        .O(byte_offset3_carry__5_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__5_i_4
       (.I0(active_byte_count[24]),
        .I1(byte_offset_reg[24]),
        .O(byte_offset3_carry__5_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 byte_offset3_carry__6
       (.CI(byte_offset3_carry__5_n_0),
        .CO({NLW_byte_offset3_carry__6_CO_UNCONNECTED[3],byte_offset3_carry__6_n_1,byte_offset3_carry__6_n_2,byte_offset3_carry__6_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,active_byte_count[30:28]}),
        .O({byte_offset3_carry__6_n_4,byte_offset3_carry__6_n_5,byte_offset3_carry__6_n_6,byte_offset3_carry__6_n_7}),
        .S({byte_offset3_carry__6_i_1_n_0,byte_offset3_carry__6_i_2_n_0,byte_offset3_carry__6_i_3_n_0,byte_offset3_carry__6_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__6_i_1
       (.I0(active_byte_count[31]),
        .I1(byte_offset_reg[31]),
        .O(byte_offset3_carry__6_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__6_i_2
       (.I0(active_byte_count[30]),
        .I1(byte_offset_reg[30]),
        .O(byte_offset3_carry__6_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__6_i_3
       (.I0(active_byte_count[29]),
        .I1(byte_offset_reg[29]),
        .O(byte_offset3_carry__6_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry__6_i_4
       (.I0(active_byte_count[28]),
        .I1(byte_offset_reg[28]),
        .O(byte_offset3_carry__6_i_4_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    byte_offset3_carry_i_1
       (.I0(active_byte_count[3]),
        .I1(byte_offset_reg[3]),
        .O(byte_offset3_carry_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    byte_offset3_carry_i_2
       (.I0(active_byte_count[2]),
        .O(byte_offset3_carry_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    byte_offset3_carry_i_3
       (.I0(active_byte_count[1]),
        .O(byte_offset3_carry_i_3_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    byte_offset3_carry_i_4
       (.I0(active_byte_count[0]),
        .O(byte_offset3_carry_i_4_n_0));
  LUT5 #(
    .INIT(32'h0200FFFF)) 
    \byte_offset[3]_i_1 
       (.I0(busy_i_2_n_0),
        .I1(busy_reg_0),
        .I2(start_delayed),
        .I3(start),
        .I4(aresetn),
        .O(\byte_offset[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF0000FE000000)) 
    \byte_offset[3]_i_2 
       (.I0(byte_offset3_carry_n_5),
        .I1(byte_offset3_carry_n_7),
        .I2(byte_offset3_carry_n_6),
        .I3(byte_offset3_carry_n_4),
        .I4(\completed_byte_count[31]_i_3_n_0 ),
        .I5(\m_axis_tkeep[7]_INST_0_i_1_n_0 ),
        .O(byte_offset));
  LUT1 #(
    .INIT(2'h1)) 
    \byte_offset[3]_i_4 
       (.I0(byte_offset_reg[3]),
        .O(\byte_offset[3]_i_4_n_0 ));
  FDRE \byte_offset_reg[10] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[7]_i_1_n_4 ),
        .Q(byte_offset_reg[10]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[11] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[11]_i_1_n_7 ),
        .Q(byte_offset_reg[11]),
        .R(\byte_offset[3]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \byte_offset_reg[11]_i_1 
       (.CI(\byte_offset_reg[7]_i_1_n_0 ),
        .CO({\byte_offset_reg[11]_i_1_n_0 ,\byte_offset_reg[11]_i_1_n_1 ,\byte_offset_reg[11]_i_1_n_2 ,\byte_offset_reg[11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\byte_offset_reg[11]_i_1_n_4 ,\byte_offset_reg[11]_i_1_n_5 ,\byte_offset_reg[11]_i_1_n_6 ,\byte_offset_reg[11]_i_1_n_7 }),
        .S(byte_offset_reg[14:11]));
  FDRE \byte_offset_reg[12] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[11]_i_1_n_6 ),
        .Q(byte_offset_reg[12]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[13] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[11]_i_1_n_5 ),
        .Q(byte_offset_reg[13]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[14] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[11]_i_1_n_4 ),
        .Q(byte_offset_reg[14]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[15] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[15]_i_1_n_7 ),
        .Q(byte_offset_reg[15]),
        .R(\byte_offset[3]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \byte_offset_reg[15]_i_1 
       (.CI(\byte_offset_reg[11]_i_1_n_0 ),
        .CO({\byte_offset_reg[15]_i_1_n_0 ,\byte_offset_reg[15]_i_1_n_1 ,\byte_offset_reg[15]_i_1_n_2 ,\byte_offset_reg[15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\byte_offset_reg[15]_i_1_n_4 ,\byte_offset_reg[15]_i_1_n_5 ,\byte_offset_reg[15]_i_1_n_6 ,\byte_offset_reg[15]_i_1_n_7 }),
        .S(byte_offset_reg[18:15]));
  FDRE \byte_offset_reg[16] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[15]_i_1_n_6 ),
        .Q(byte_offset_reg[16]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[17] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[15]_i_1_n_5 ),
        .Q(byte_offset_reg[17]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[18] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[15]_i_1_n_4 ),
        .Q(byte_offset_reg[18]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[19] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[19]_i_1_n_7 ),
        .Q(byte_offset_reg[19]),
        .R(\byte_offset[3]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \byte_offset_reg[19]_i_1 
       (.CI(\byte_offset_reg[15]_i_1_n_0 ),
        .CO({\byte_offset_reg[19]_i_1_n_0 ,\byte_offset_reg[19]_i_1_n_1 ,\byte_offset_reg[19]_i_1_n_2 ,\byte_offset_reg[19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\byte_offset_reg[19]_i_1_n_4 ,\byte_offset_reg[19]_i_1_n_5 ,\byte_offset_reg[19]_i_1_n_6 ,\byte_offset_reg[19]_i_1_n_7 }),
        .S(byte_offset_reg[22:19]));
  FDRE \byte_offset_reg[20] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[19]_i_1_n_6 ),
        .Q(byte_offset_reg[20]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[21] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[19]_i_1_n_5 ),
        .Q(byte_offset_reg[21]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[22] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[19]_i_1_n_4 ),
        .Q(byte_offset_reg[22]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[23] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[23]_i_1_n_7 ),
        .Q(byte_offset_reg[23]),
        .R(\byte_offset[3]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \byte_offset_reg[23]_i_1 
       (.CI(\byte_offset_reg[19]_i_1_n_0 ),
        .CO({\byte_offset_reg[23]_i_1_n_0 ,\byte_offset_reg[23]_i_1_n_1 ,\byte_offset_reg[23]_i_1_n_2 ,\byte_offset_reg[23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\byte_offset_reg[23]_i_1_n_4 ,\byte_offset_reg[23]_i_1_n_5 ,\byte_offset_reg[23]_i_1_n_6 ,\byte_offset_reg[23]_i_1_n_7 }),
        .S(byte_offset_reg[26:23]));
  FDRE \byte_offset_reg[24] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[23]_i_1_n_6 ),
        .Q(byte_offset_reg[24]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[25] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[23]_i_1_n_5 ),
        .Q(byte_offset_reg[25]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[26] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[23]_i_1_n_4 ),
        .Q(byte_offset_reg[26]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[27] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[27]_i_1_n_7 ),
        .Q(byte_offset_reg[27]),
        .R(\byte_offset[3]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \byte_offset_reg[27]_i_1 
       (.CI(\byte_offset_reg[23]_i_1_n_0 ),
        .CO({\byte_offset_reg[27]_i_1_n_0 ,\byte_offset_reg[27]_i_1_n_1 ,\byte_offset_reg[27]_i_1_n_2 ,\byte_offset_reg[27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\byte_offset_reg[27]_i_1_n_4 ,\byte_offset_reg[27]_i_1_n_5 ,\byte_offset_reg[27]_i_1_n_6 ,\byte_offset_reg[27]_i_1_n_7 }),
        .S(byte_offset_reg[30:27]));
  FDRE \byte_offset_reg[28] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[27]_i_1_n_6 ),
        .Q(byte_offset_reg[28]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[29] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[27]_i_1_n_5 ),
        .Q(byte_offset_reg[29]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[30] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[27]_i_1_n_4 ),
        .Q(byte_offset_reg[30]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[31] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[31]_i_1_n_7 ),
        .Q(byte_offset_reg[31]),
        .R(\byte_offset[3]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \byte_offset_reg[31]_i_1 
       (.CI(\byte_offset_reg[27]_i_1_n_0 ),
        .CO(\NLW_byte_offset_reg[31]_i_1_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_byte_offset_reg[31]_i_1_O_UNCONNECTED [3:1],\byte_offset_reg[31]_i_1_n_7 }),
        .S({1'b0,1'b0,1'b0,byte_offset_reg[31]}));
  FDRE \byte_offset_reg[3] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[3]_i_3_n_7 ),
        .Q(byte_offset_reg[3]),
        .R(\byte_offset[3]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \byte_offset_reg[3]_i_3 
       (.CI(1'b0),
        .CO({\byte_offset_reg[3]_i_3_n_0 ,\byte_offset_reg[3]_i_3_n_1 ,\byte_offset_reg[3]_i_3_n_2 ,\byte_offset_reg[3]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\byte_offset_reg[3]_i_3_n_4 ,\byte_offset_reg[3]_i_3_n_5 ,\byte_offset_reg[3]_i_3_n_6 ,\byte_offset_reg[3]_i_3_n_7 }),
        .S({byte_offset_reg[6:4],\byte_offset[3]_i_4_n_0 }));
  FDRE \byte_offset_reg[4] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[3]_i_3_n_6 ),
        .Q(byte_offset_reg[4]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[5] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[3]_i_3_n_5 ),
        .Q(byte_offset_reg[5]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[6] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[3]_i_3_n_4 ),
        .Q(byte_offset_reg[6]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[7] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[7]_i_1_n_7 ),
        .Q(byte_offset_reg[7]),
        .R(\byte_offset[3]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \byte_offset_reg[7]_i_1 
       (.CI(\byte_offset_reg[3]_i_3_n_0 ),
        .CO({\byte_offset_reg[7]_i_1_n_0 ,\byte_offset_reg[7]_i_1_n_1 ,\byte_offset_reg[7]_i_1_n_2 ,\byte_offset_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\byte_offset_reg[7]_i_1_n_4 ,\byte_offset_reg[7]_i_1_n_5 ,\byte_offset_reg[7]_i_1_n_6 ,\byte_offset_reg[7]_i_1_n_7 }),
        .S(byte_offset_reg[10:7]));
  FDRE \byte_offset_reg[8] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[7]_i_1_n_6 ),
        .Q(byte_offset_reg[8]),
        .R(\byte_offset[3]_i_1_n_0 ));
  FDRE \byte_offset_reg[9] 
       (.C(aclk),
        .CE(byte_offset),
        .D(\byte_offset_reg[7]_i_1_n_5 ),
        .Q(byte_offset_reg[9]),
        .R(\byte_offset[3]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \completed_byte_count[31]_i_1 
       (.I0(aresetn),
        .O(clear));
  LUT5 #(
    .INIT(32'h00000008)) 
    \completed_byte_count[31]_i_2 
       (.I0(\completed_byte_count[31]_i_3_n_0 ),
        .I1(\completed_byte_count[31]_i_4_n_0 ),
        .I2(\m_axis_tkeep[7]_INST_0_i_4_n_0 ),
        .I3(\m_axis_tkeep[7]_INST_0_i_3_n_0 ),
        .I4(\m_axis_tkeep[7]_INST_0_i_2_n_0 ),
        .O(\completed_byte_count[31]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'h8808)) 
    \completed_byte_count[31]_i_3 
       (.I0(m_axis_tready),
        .I1(busy_reg_0),
        .I2(start),
        .I3(start_delayed),
        .O(\completed_byte_count[31]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h01FF)) 
    \completed_byte_count[31]_i_4 
       (.I0(byte_offset3_carry_n_7),
        .I1(byte_offset3_carry_n_6),
        .I2(byte_offset3_carry_n_5),
        .I3(byte_offset3_carry_n_4),
        .O(\completed_byte_count[31]_i_4_n_0 ));
  FDRE \completed_byte_count_reg[0] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[0]),
        .Q(completed_byte_count[0]),
        .R(clear));
  FDRE \completed_byte_count_reg[10] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[10]),
        .Q(completed_byte_count[10]),
        .R(clear));
  FDRE \completed_byte_count_reg[11] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[11]),
        .Q(completed_byte_count[11]),
        .R(clear));
  FDRE \completed_byte_count_reg[12] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[12]),
        .Q(completed_byte_count[12]),
        .R(clear));
  FDRE \completed_byte_count_reg[13] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[13]),
        .Q(completed_byte_count[13]),
        .R(clear));
  FDRE \completed_byte_count_reg[14] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[14]),
        .Q(completed_byte_count[14]),
        .R(clear));
  FDRE \completed_byte_count_reg[15] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[15]),
        .Q(completed_byte_count[15]),
        .R(clear));
  FDRE \completed_byte_count_reg[16] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[16]),
        .Q(completed_byte_count[16]),
        .R(clear));
  FDRE \completed_byte_count_reg[17] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[17]),
        .Q(completed_byte_count[17]),
        .R(clear));
  FDRE \completed_byte_count_reg[18] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[18]),
        .Q(completed_byte_count[18]),
        .R(clear));
  FDRE \completed_byte_count_reg[19] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[19]),
        .Q(completed_byte_count[19]),
        .R(clear));
  FDRE \completed_byte_count_reg[1] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[1]),
        .Q(completed_byte_count[1]),
        .R(clear));
  FDRE \completed_byte_count_reg[20] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[20]),
        .Q(completed_byte_count[20]),
        .R(clear));
  FDRE \completed_byte_count_reg[21] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[21]),
        .Q(completed_byte_count[21]),
        .R(clear));
  FDRE \completed_byte_count_reg[22] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[22]),
        .Q(completed_byte_count[22]),
        .R(clear));
  FDRE \completed_byte_count_reg[23] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[23]),
        .Q(completed_byte_count[23]),
        .R(clear));
  FDRE \completed_byte_count_reg[24] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[24]),
        .Q(completed_byte_count[24]),
        .R(clear));
  FDRE \completed_byte_count_reg[25] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[25]),
        .Q(completed_byte_count[25]),
        .R(clear));
  FDRE \completed_byte_count_reg[26] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[26]),
        .Q(completed_byte_count[26]),
        .R(clear));
  FDRE \completed_byte_count_reg[27] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[27]),
        .Q(completed_byte_count[27]),
        .R(clear));
  FDRE \completed_byte_count_reg[28] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[28]),
        .Q(completed_byte_count[28]),
        .R(clear));
  FDRE \completed_byte_count_reg[29] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[29]),
        .Q(completed_byte_count[29]),
        .R(clear));
  FDRE \completed_byte_count_reg[2] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[2]),
        .Q(completed_byte_count[2]),
        .R(clear));
  FDRE \completed_byte_count_reg[30] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[30]),
        .Q(completed_byte_count[30]),
        .R(clear));
  FDRE \completed_byte_count_reg[31] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[31]),
        .Q(completed_byte_count[31]),
        .R(clear));
  FDRE \completed_byte_count_reg[3] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[3]),
        .Q(completed_byte_count[3]),
        .R(clear));
  FDRE \completed_byte_count_reg[4] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[4]),
        .Q(completed_byte_count[4]),
        .R(clear));
  FDRE \completed_byte_count_reg[5] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[5]),
        .Q(completed_byte_count[5]),
        .R(clear));
  FDRE \completed_byte_count_reg[6] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[6]),
        .Q(completed_byte_count[6]),
        .R(clear));
  FDRE \completed_byte_count_reg[7] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[7]),
        .Q(completed_byte_count[7]),
        .R(clear));
  FDRE \completed_byte_count_reg[8] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[8]),
        .Q(completed_byte_count[8]),
        .R(clear));
  FDRE \completed_byte_count_reg[9] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(active_byte_count[9]),
        .Q(completed_byte_count[9]),
        .R(clear));
  LUT1 #(
    .INIT(2'h1)) 
    \completed_packet_count[3]_i_2 
       (.I0(completed_packet_count[0]),
        .O(\completed_packet_count[3]_i_2_n_0 ));
  FDRE \completed_packet_count_reg[0] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[3]_i_1_n_7 ),
        .Q(completed_packet_count[0]),
        .R(clear));
  FDRE \completed_packet_count_reg[10] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[11]_i_1_n_5 ),
        .Q(completed_packet_count[10]),
        .R(clear));
  FDRE \completed_packet_count_reg[11] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[11]_i_1_n_4 ),
        .Q(completed_packet_count[11]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \completed_packet_count_reg[11]_i_1 
       (.CI(\completed_packet_count_reg[7]_i_1_n_0 ),
        .CO({\completed_packet_count_reg[11]_i_1_n_0 ,\completed_packet_count_reg[11]_i_1_n_1 ,\completed_packet_count_reg[11]_i_1_n_2 ,\completed_packet_count_reg[11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\completed_packet_count_reg[11]_i_1_n_4 ,\completed_packet_count_reg[11]_i_1_n_5 ,\completed_packet_count_reg[11]_i_1_n_6 ,\completed_packet_count_reg[11]_i_1_n_7 }),
        .S(completed_packet_count[11:8]));
  FDRE \completed_packet_count_reg[12] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[15]_i_1_n_7 ),
        .Q(completed_packet_count[12]),
        .R(clear));
  FDRE \completed_packet_count_reg[13] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[15]_i_1_n_6 ),
        .Q(completed_packet_count[13]),
        .R(clear));
  FDRE \completed_packet_count_reg[14] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[15]_i_1_n_5 ),
        .Q(completed_packet_count[14]),
        .R(clear));
  FDRE \completed_packet_count_reg[15] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[15]_i_1_n_4 ),
        .Q(completed_packet_count[15]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \completed_packet_count_reg[15]_i_1 
       (.CI(\completed_packet_count_reg[11]_i_1_n_0 ),
        .CO({\completed_packet_count_reg[15]_i_1_n_0 ,\completed_packet_count_reg[15]_i_1_n_1 ,\completed_packet_count_reg[15]_i_1_n_2 ,\completed_packet_count_reg[15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\completed_packet_count_reg[15]_i_1_n_4 ,\completed_packet_count_reg[15]_i_1_n_5 ,\completed_packet_count_reg[15]_i_1_n_6 ,\completed_packet_count_reg[15]_i_1_n_7 }),
        .S(completed_packet_count[15:12]));
  FDRE \completed_packet_count_reg[16] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[19]_i_1_n_7 ),
        .Q(completed_packet_count[16]),
        .R(clear));
  FDRE \completed_packet_count_reg[17] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[19]_i_1_n_6 ),
        .Q(completed_packet_count[17]),
        .R(clear));
  FDRE \completed_packet_count_reg[18] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[19]_i_1_n_5 ),
        .Q(completed_packet_count[18]),
        .R(clear));
  FDRE \completed_packet_count_reg[19] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[19]_i_1_n_4 ),
        .Q(completed_packet_count[19]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \completed_packet_count_reg[19]_i_1 
       (.CI(\completed_packet_count_reg[15]_i_1_n_0 ),
        .CO({\completed_packet_count_reg[19]_i_1_n_0 ,\completed_packet_count_reg[19]_i_1_n_1 ,\completed_packet_count_reg[19]_i_1_n_2 ,\completed_packet_count_reg[19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\completed_packet_count_reg[19]_i_1_n_4 ,\completed_packet_count_reg[19]_i_1_n_5 ,\completed_packet_count_reg[19]_i_1_n_6 ,\completed_packet_count_reg[19]_i_1_n_7 }),
        .S(completed_packet_count[19:16]));
  FDRE \completed_packet_count_reg[1] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[3]_i_1_n_6 ),
        .Q(completed_packet_count[1]),
        .R(clear));
  FDRE \completed_packet_count_reg[20] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[23]_i_1_n_7 ),
        .Q(completed_packet_count[20]),
        .R(clear));
  FDRE \completed_packet_count_reg[21] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[23]_i_1_n_6 ),
        .Q(completed_packet_count[21]),
        .R(clear));
  FDRE \completed_packet_count_reg[22] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[23]_i_1_n_5 ),
        .Q(completed_packet_count[22]),
        .R(clear));
  FDRE \completed_packet_count_reg[23] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[23]_i_1_n_4 ),
        .Q(completed_packet_count[23]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \completed_packet_count_reg[23]_i_1 
       (.CI(\completed_packet_count_reg[19]_i_1_n_0 ),
        .CO({\completed_packet_count_reg[23]_i_1_n_0 ,\completed_packet_count_reg[23]_i_1_n_1 ,\completed_packet_count_reg[23]_i_1_n_2 ,\completed_packet_count_reg[23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\completed_packet_count_reg[23]_i_1_n_4 ,\completed_packet_count_reg[23]_i_1_n_5 ,\completed_packet_count_reg[23]_i_1_n_6 ,\completed_packet_count_reg[23]_i_1_n_7 }),
        .S(completed_packet_count[23:20]));
  FDRE \completed_packet_count_reg[24] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[27]_i_1_n_7 ),
        .Q(completed_packet_count[24]),
        .R(clear));
  FDRE \completed_packet_count_reg[25] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[27]_i_1_n_6 ),
        .Q(completed_packet_count[25]),
        .R(clear));
  FDRE \completed_packet_count_reg[26] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[27]_i_1_n_5 ),
        .Q(completed_packet_count[26]),
        .R(clear));
  FDRE \completed_packet_count_reg[27] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[27]_i_1_n_4 ),
        .Q(completed_packet_count[27]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \completed_packet_count_reg[27]_i_1 
       (.CI(\completed_packet_count_reg[23]_i_1_n_0 ),
        .CO({\completed_packet_count_reg[27]_i_1_n_0 ,\completed_packet_count_reg[27]_i_1_n_1 ,\completed_packet_count_reg[27]_i_1_n_2 ,\completed_packet_count_reg[27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\completed_packet_count_reg[27]_i_1_n_4 ,\completed_packet_count_reg[27]_i_1_n_5 ,\completed_packet_count_reg[27]_i_1_n_6 ,\completed_packet_count_reg[27]_i_1_n_7 }),
        .S(completed_packet_count[27:24]));
  FDRE \completed_packet_count_reg[28] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[31]_i_1_n_7 ),
        .Q(completed_packet_count[28]),
        .R(clear));
  FDRE \completed_packet_count_reg[29] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[31]_i_1_n_6 ),
        .Q(completed_packet_count[29]),
        .R(clear));
  FDRE \completed_packet_count_reg[2] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[3]_i_1_n_5 ),
        .Q(completed_packet_count[2]),
        .R(clear));
  FDRE \completed_packet_count_reg[30] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[31]_i_1_n_5 ),
        .Q(completed_packet_count[30]),
        .R(clear));
  FDRE \completed_packet_count_reg[31] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[31]_i_1_n_4 ),
        .Q(completed_packet_count[31]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \completed_packet_count_reg[31]_i_1 
       (.CI(\completed_packet_count_reg[27]_i_1_n_0 ),
        .CO({\NLW_completed_packet_count_reg[31]_i_1_CO_UNCONNECTED [3],\completed_packet_count_reg[31]_i_1_n_1 ,\completed_packet_count_reg[31]_i_1_n_2 ,\completed_packet_count_reg[31]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\completed_packet_count_reg[31]_i_1_n_4 ,\completed_packet_count_reg[31]_i_1_n_5 ,\completed_packet_count_reg[31]_i_1_n_6 ,\completed_packet_count_reg[31]_i_1_n_7 }),
        .S(completed_packet_count[31:28]));
  FDRE \completed_packet_count_reg[3] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[3]_i_1_n_4 ),
        .Q(completed_packet_count[3]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \completed_packet_count_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\completed_packet_count_reg[3]_i_1_n_0 ,\completed_packet_count_reg[3]_i_1_n_1 ,\completed_packet_count_reg[3]_i_1_n_2 ,\completed_packet_count_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\completed_packet_count_reg[3]_i_1_n_4 ,\completed_packet_count_reg[3]_i_1_n_5 ,\completed_packet_count_reg[3]_i_1_n_6 ,\completed_packet_count_reg[3]_i_1_n_7 }),
        .S({completed_packet_count[3:1],\completed_packet_count[3]_i_2_n_0 }));
  FDRE \completed_packet_count_reg[4] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[7]_i_1_n_7 ),
        .Q(completed_packet_count[4]),
        .R(clear));
  FDRE \completed_packet_count_reg[5] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[7]_i_1_n_6 ),
        .Q(completed_packet_count[5]),
        .R(clear));
  FDRE \completed_packet_count_reg[6] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[7]_i_1_n_5 ),
        .Q(completed_packet_count[6]),
        .R(clear));
  FDRE \completed_packet_count_reg[7] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[7]_i_1_n_4 ),
        .Q(completed_packet_count[7]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \completed_packet_count_reg[7]_i_1 
       (.CI(\completed_packet_count_reg[3]_i_1_n_0 ),
        .CO({\completed_packet_count_reg[7]_i_1_n_0 ,\completed_packet_count_reg[7]_i_1_n_1 ,\completed_packet_count_reg[7]_i_1_n_2 ,\completed_packet_count_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\completed_packet_count_reg[7]_i_1_n_4 ,\completed_packet_count_reg[7]_i_1_n_5 ,\completed_packet_count_reg[7]_i_1_n_6 ,\completed_packet_count_reg[7]_i_1_n_7 }),
        .S(completed_packet_count[7:4]));
  FDRE \completed_packet_count_reg[8] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[11]_i_1_n_7 ),
        .Q(completed_packet_count[8]),
        .R(clear));
  FDRE \completed_packet_count_reg[9] 
       (.C(aclk),
        .CE(\completed_byte_count[31]_i_2_n_0 ),
        .D(\completed_packet_count_reg[11]_i_1_n_6 ),
        .Q(completed_packet_count[9]),
        .R(clear));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h9669)) 
    \m_axis_tdata[0]_INST_0 
       (.I0(\m_axis_tdata[8]_INST_0_i_1_n_0 ),
        .I1(byte_offset_reg[8]),
        .I2(active_seed[16]),
        .I3(active_seed[24]),
        .O(m_axis_tdata[2]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \m_axis_tdata[17]_INST_0 
       (.I0(\m_axis_tdata[17]_INST_0_i_1_n_0 ),
        .I1(byte_offset_reg[9]),
        .I2(active_seed[17]),
        .I3(active_seed[25]),
        .O(m_axis_tdata[4]));
  LUT4 #(
    .INIT(16'h9669)) 
    \m_axis_tdata[17]_INST_0_i_1 
       (.I0(byte_offset_reg[25]),
        .I1(byte_offset_reg[17]),
        .I2(active_seed[9]),
        .I3(active_seed[1]),
        .O(\m_axis_tdata[17]_INST_0_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h9669)) 
    \m_axis_tdata[1]_INST_0 
       (.I0(\m_axis_tdata[17]_INST_0_i_1_n_0 ),
        .I1(byte_offset_reg[9]),
        .I2(active_seed[17]),
        .I3(active_seed[25]),
        .O(m_axis_tdata[1]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h9669)) 
    \m_axis_tdata[2]_INST_0 
       (.I0(\m_axis_tdata[34]_INST_0_i_1_n_0 ),
        .I1(byte_offset_reg[10]),
        .I2(active_seed[18]),
        .I3(active_seed[26]),
        .O(m_axis_tdata[0]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \m_axis_tdata[34]_INST_0 
       (.I0(\m_axis_tdata[34]_INST_0_i_1_n_0 ),
        .I1(byte_offset_reg[10]),
        .I2(active_seed[18]),
        .I3(active_seed[26]),
        .O(m_axis_tdata[5]));
  LUT4 #(
    .INIT(16'h9669)) 
    \m_axis_tdata[34]_INST_0_i_1 
       (.I0(byte_offset_reg[26]),
        .I1(byte_offset_reg[18]),
        .I2(active_seed[10]),
        .I3(active_seed[2]),
        .O(\m_axis_tdata[34]_INST_0_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h69969669)) 
    \m_axis_tdata[3]_INST_0 
       (.I0(byte_offset_reg[19]),
        .I1(byte_offset_reg[27]),
        .I2(byte_offset_reg[3]),
        .I3(byte_offset_reg[11]),
        .I4(\m_axis_tdata[3]_INST_0_i_1_n_0 ),
        .O(m_axis_tdata[6]));
  LUT4 #(
    .INIT(16'h9669)) 
    \m_axis_tdata[3]_INST_0_i_1 
       (.I0(active_seed[11]),
        .I1(active_seed[3]),
        .I2(active_seed[27]),
        .I3(active_seed[19]),
        .O(\m_axis_tdata[3]_INST_0_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h69969669)) 
    \m_axis_tdata[4]_INST_0 
       (.I0(byte_offset_reg[20]),
        .I1(byte_offset_reg[28]),
        .I2(byte_offset_reg[4]),
        .I3(byte_offset_reg[12]),
        .I4(\m_axis_tdata[4]_INST_0_i_1_n_0 ),
        .O(m_axis_tdata[7]));
  LUT4 #(
    .INIT(16'h9669)) 
    \m_axis_tdata[4]_INST_0_i_1 
       (.I0(active_seed[12]),
        .I1(active_seed[4]),
        .I2(active_seed[28]),
        .I3(active_seed[20]),
        .O(\m_axis_tdata[4]_INST_0_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h69969669)) 
    \m_axis_tdata[5]_INST_0 
       (.I0(byte_offset_reg[21]),
        .I1(byte_offset_reg[29]),
        .I2(byte_offset_reg[5]),
        .I3(byte_offset_reg[13]),
        .I4(\m_axis_tdata[5]_INST_0_i_1_n_0 ),
        .O(m_axis_tdata[8]));
  LUT4 #(
    .INIT(16'h9669)) 
    \m_axis_tdata[5]_INST_0_i_1 
       (.I0(active_seed[13]),
        .I1(active_seed[5]),
        .I2(active_seed[29]),
        .I3(active_seed[21]),
        .O(\m_axis_tdata[5]_INST_0_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h69969669)) 
    \m_axis_tdata[6]_INST_0 
       (.I0(byte_offset_reg[22]),
        .I1(byte_offset_reg[30]),
        .I2(byte_offset_reg[6]),
        .I3(byte_offset_reg[14]),
        .I4(\m_axis_tdata[6]_INST_0_i_1_n_0 ),
        .O(m_axis_tdata[9]));
  LUT4 #(
    .INIT(16'h9669)) 
    \m_axis_tdata[6]_INST_0_i_1 
       (.I0(active_seed[14]),
        .I1(active_seed[6]),
        .I2(active_seed[30]),
        .I3(active_seed[22]),
        .O(\m_axis_tdata[6]_INST_0_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h69969669)) 
    \m_axis_tdata[7]_INST_0 
       (.I0(byte_offset_reg[23]),
        .I1(byte_offset_reg[31]),
        .I2(byte_offset_reg[7]),
        .I3(byte_offset_reg[15]),
        .I4(\m_axis_tdata[7]_INST_0_i_1_n_0 ),
        .O(m_axis_tdata[10]));
  LUT4 #(
    .INIT(16'h9669)) 
    \m_axis_tdata[7]_INST_0_i_1 
       (.I0(active_seed[15]),
        .I1(active_seed[7]),
        .I2(active_seed[31]),
        .I3(active_seed[23]),
        .O(\m_axis_tdata[7]_INST_0_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \m_axis_tdata[8]_INST_0 
       (.I0(\m_axis_tdata[8]_INST_0_i_1_n_0 ),
        .I1(byte_offset_reg[8]),
        .I2(active_seed[16]),
        .I3(active_seed[24]),
        .O(m_axis_tdata[3]));
  LUT4 #(
    .INIT(16'h9669)) 
    \m_axis_tdata[8]_INST_0_i_1 
       (.I0(byte_offset_reg[24]),
        .I1(byte_offset_reg[16]),
        .I2(active_seed[8]),
        .I3(active_seed[0]),
        .O(\m_axis_tdata[8]_INST_0_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \m_axis_tkeep[0]_INST_0 
       (.I0(byte_offset3_carry_n_5),
        .I1(byte_offset3_carry_n_7),
        .I2(byte_offset3_carry_n_6),
        .I3(byte_offset3_carry_n_4),
        .I4(\m_axis_tkeep[7]_INST_0_i_1_n_0 ),
        .O(m_axis_tkeep[0]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \m_axis_tkeep[1]_INST_0 
       (.I0(byte_offset3_carry_n_5),
        .I1(\m_axis_tkeep[7]_INST_0_i_1_n_0 ),
        .I2(byte_offset3_carry_n_4),
        .I3(byte_offset3_carry_n_6),
        .O(m_axis_tkeep[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFFFFFFF8)) 
    \m_axis_tkeep[2]_INST_0 
       (.I0(byte_offset3_carry_n_6),
        .I1(byte_offset3_carry_n_7),
        .I2(byte_offset3_carry_n_5),
        .I3(\m_axis_tkeep[7]_INST_0_i_1_n_0 ),
        .I4(byte_offset3_carry_n_4),
        .O(m_axis_tkeep[2]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \m_axis_tkeep[3]_INST_0 
       (.I0(byte_offset3_carry_n_4),
        .I1(\m_axis_tkeep[7]_INST_0_i_1_n_0 ),
        .I2(byte_offset3_carry_n_5),
        .O(m_axis_tkeep[3]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFFFFFFA8)) 
    \m_axis_tkeep[4]_INST_0 
       (.I0(byte_offset3_carry_n_5),
        .I1(byte_offset3_carry_n_7),
        .I2(byte_offset3_carry_n_6),
        .I3(byte_offset3_carry_n_4),
        .I4(\m_axis_tkeep[7]_INST_0_i_1_n_0 ),
        .O(m_axis_tkeep[4]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'hFFF8)) 
    \m_axis_tkeep[5]_INST_0 
       (.I0(byte_offset3_carry_n_5),
        .I1(byte_offset3_carry_n_6),
        .I2(byte_offset3_carry_n_4),
        .I3(\m_axis_tkeep[7]_INST_0_i_1_n_0 ),
        .O(m_axis_tkeep[5]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFFFFFF80)) 
    \m_axis_tkeep[6]_INST_0 
       (.I0(byte_offset3_carry_n_7),
        .I1(byte_offset3_carry_n_6),
        .I2(byte_offset3_carry_n_5),
        .I3(byte_offset3_carry_n_4),
        .I4(\m_axis_tkeep[7]_INST_0_i_1_n_0 ),
        .O(m_axis_tkeep[6]));
  LUT2 #(
    .INIT(4'hE)) 
    \m_axis_tkeep[7]_INST_0 
       (.I0(\m_axis_tkeep[7]_INST_0_i_1_n_0 ),
        .I1(byte_offset3_carry_n_4),
        .O(m_axis_tkeep[7]));
  LUT3 #(
    .INIT(8'hFE)) 
    \m_axis_tkeep[7]_INST_0_i_1 
       (.I0(\m_axis_tkeep[7]_INST_0_i_2_n_0 ),
        .I1(\m_axis_tkeep[7]_INST_0_i_3_n_0 ),
        .I2(\m_axis_tkeep[7]_INST_0_i_4_n_0 ),
        .O(\m_axis_tkeep[7]_INST_0_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \m_axis_tkeep[7]_INST_0_i_2 
       (.I0(byte_offset3_carry__3_n_5),
        .I1(byte_offset3_carry__3_n_4),
        .I2(byte_offset3_carry__3_n_7),
        .I3(byte_offset3_carry__3_n_6),
        .I4(\m_axis_tkeep[7]_INST_0_i_5_n_0 ),
        .O(\m_axis_tkeep[7]_INST_0_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \m_axis_tkeep[7]_INST_0_i_3 
       (.I0(byte_offset3_carry__1_n_5),
        .I1(byte_offset3_carry__1_n_4),
        .I2(byte_offset3_carry__1_n_7),
        .I3(byte_offset3_carry__1_n_6),
        .I4(\m_axis_tkeep[7]_INST_0_i_6_n_0 ),
        .O(\m_axis_tkeep[7]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \m_axis_tkeep[7]_INST_0_i_4 
       (.I0(\m_axis_tkeep[7]_INST_0_i_7_n_0 ),
        .I1(byte_offset3_carry__5_n_6),
        .I2(byte_offset3_carry__5_n_7),
        .I3(byte_offset3_carry__5_n_4),
        .I4(byte_offset3_carry__5_n_5),
        .I5(\m_axis_tkeep[7]_INST_0_i_8_n_0 ),
        .O(\m_axis_tkeep[7]_INST_0_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \m_axis_tkeep[7]_INST_0_i_5 
       (.I0(byte_offset3_carry__4_n_6),
        .I1(byte_offset3_carry__4_n_7),
        .I2(byte_offset3_carry__4_n_4),
        .I3(byte_offset3_carry__4_n_5),
        .O(\m_axis_tkeep[7]_INST_0_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \m_axis_tkeep[7]_INST_0_i_6 
       (.I0(byte_offset3_carry__2_n_6),
        .I1(byte_offset3_carry__2_n_7),
        .I2(byte_offset3_carry__2_n_4),
        .I3(byte_offset3_carry__2_n_5),
        .O(\m_axis_tkeep[7]_INST_0_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \m_axis_tkeep[7]_INST_0_i_7 
       (.I0(byte_offset3_carry__6_n_6),
        .I1(byte_offset3_carry__6_n_7),
        .I2(byte_offset3_carry__6_n_4),
        .I3(byte_offset3_carry__6_n_5),
        .O(\m_axis_tkeep[7]_INST_0_i_7_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \m_axis_tkeep[7]_INST_0_i_8 
       (.I0(byte_offset3_carry__0_n_6),
        .I1(byte_offset3_carry__0_n_7),
        .I2(byte_offset3_carry__0_n_4),
        .I3(byte_offset3_carry__0_n_5),
        .O(\m_axis_tkeep[7]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h000000000002AAAA)) 
    m_axis_tlast_INST_0
       (.I0(busy_reg_0),
        .I1(byte_offset3_carry_n_7),
        .I2(byte_offset3_carry_n_6),
        .I3(byte_offset3_carry_n_5),
        .I4(byte_offset3_carry_n_4),
        .I5(\m_axis_tkeep[7]_INST_0_i_1_n_0 ),
        .O(m_axis_tlast));
  LUT4 #(
    .INIT(16'h3010)) 
    \rejected_start_count[31]_i_1 
       (.I0(busy_i_2_n_0),
        .I1(start_delayed),
        .I2(start),
        .I3(busy_reg_0),
        .O(\rejected_start_count[31]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \rejected_start_count[3]_i_2 
       (.I0(rejected_start_count[0]),
        .O(\rejected_start_count[3]_i_2_n_0 ));
  FDRE \rejected_start_count_reg[0] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[3]_i_1_n_7 ),
        .Q(rejected_start_count[0]),
        .R(clear));
  FDRE \rejected_start_count_reg[10] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[11]_i_1_n_5 ),
        .Q(rejected_start_count[10]),
        .R(clear));
  FDRE \rejected_start_count_reg[11] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[11]_i_1_n_4 ),
        .Q(rejected_start_count[11]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \rejected_start_count_reg[11]_i_1 
       (.CI(\rejected_start_count_reg[7]_i_1_n_0 ),
        .CO({\rejected_start_count_reg[11]_i_1_n_0 ,\rejected_start_count_reg[11]_i_1_n_1 ,\rejected_start_count_reg[11]_i_1_n_2 ,\rejected_start_count_reg[11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\rejected_start_count_reg[11]_i_1_n_4 ,\rejected_start_count_reg[11]_i_1_n_5 ,\rejected_start_count_reg[11]_i_1_n_6 ,\rejected_start_count_reg[11]_i_1_n_7 }),
        .S(rejected_start_count[11:8]));
  FDRE \rejected_start_count_reg[12] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[15]_i_1_n_7 ),
        .Q(rejected_start_count[12]),
        .R(clear));
  FDRE \rejected_start_count_reg[13] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[15]_i_1_n_6 ),
        .Q(rejected_start_count[13]),
        .R(clear));
  FDRE \rejected_start_count_reg[14] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[15]_i_1_n_5 ),
        .Q(rejected_start_count[14]),
        .R(clear));
  FDRE \rejected_start_count_reg[15] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[15]_i_1_n_4 ),
        .Q(rejected_start_count[15]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \rejected_start_count_reg[15]_i_1 
       (.CI(\rejected_start_count_reg[11]_i_1_n_0 ),
        .CO({\rejected_start_count_reg[15]_i_1_n_0 ,\rejected_start_count_reg[15]_i_1_n_1 ,\rejected_start_count_reg[15]_i_1_n_2 ,\rejected_start_count_reg[15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\rejected_start_count_reg[15]_i_1_n_4 ,\rejected_start_count_reg[15]_i_1_n_5 ,\rejected_start_count_reg[15]_i_1_n_6 ,\rejected_start_count_reg[15]_i_1_n_7 }),
        .S(rejected_start_count[15:12]));
  FDRE \rejected_start_count_reg[16] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[19]_i_1_n_7 ),
        .Q(rejected_start_count[16]),
        .R(clear));
  FDRE \rejected_start_count_reg[17] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[19]_i_1_n_6 ),
        .Q(rejected_start_count[17]),
        .R(clear));
  FDRE \rejected_start_count_reg[18] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[19]_i_1_n_5 ),
        .Q(rejected_start_count[18]),
        .R(clear));
  FDRE \rejected_start_count_reg[19] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[19]_i_1_n_4 ),
        .Q(rejected_start_count[19]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \rejected_start_count_reg[19]_i_1 
       (.CI(\rejected_start_count_reg[15]_i_1_n_0 ),
        .CO({\rejected_start_count_reg[19]_i_1_n_0 ,\rejected_start_count_reg[19]_i_1_n_1 ,\rejected_start_count_reg[19]_i_1_n_2 ,\rejected_start_count_reg[19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\rejected_start_count_reg[19]_i_1_n_4 ,\rejected_start_count_reg[19]_i_1_n_5 ,\rejected_start_count_reg[19]_i_1_n_6 ,\rejected_start_count_reg[19]_i_1_n_7 }),
        .S(rejected_start_count[19:16]));
  FDRE \rejected_start_count_reg[1] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[3]_i_1_n_6 ),
        .Q(rejected_start_count[1]),
        .R(clear));
  FDRE \rejected_start_count_reg[20] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[23]_i_1_n_7 ),
        .Q(rejected_start_count[20]),
        .R(clear));
  FDRE \rejected_start_count_reg[21] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[23]_i_1_n_6 ),
        .Q(rejected_start_count[21]),
        .R(clear));
  FDRE \rejected_start_count_reg[22] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[23]_i_1_n_5 ),
        .Q(rejected_start_count[22]),
        .R(clear));
  FDRE \rejected_start_count_reg[23] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[23]_i_1_n_4 ),
        .Q(rejected_start_count[23]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \rejected_start_count_reg[23]_i_1 
       (.CI(\rejected_start_count_reg[19]_i_1_n_0 ),
        .CO({\rejected_start_count_reg[23]_i_1_n_0 ,\rejected_start_count_reg[23]_i_1_n_1 ,\rejected_start_count_reg[23]_i_1_n_2 ,\rejected_start_count_reg[23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\rejected_start_count_reg[23]_i_1_n_4 ,\rejected_start_count_reg[23]_i_1_n_5 ,\rejected_start_count_reg[23]_i_1_n_6 ,\rejected_start_count_reg[23]_i_1_n_7 }),
        .S(rejected_start_count[23:20]));
  FDRE \rejected_start_count_reg[24] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[27]_i_1_n_7 ),
        .Q(rejected_start_count[24]),
        .R(clear));
  FDRE \rejected_start_count_reg[25] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[27]_i_1_n_6 ),
        .Q(rejected_start_count[25]),
        .R(clear));
  FDRE \rejected_start_count_reg[26] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[27]_i_1_n_5 ),
        .Q(rejected_start_count[26]),
        .R(clear));
  FDRE \rejected_start_count_reg[27] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[27]_i_1_n_4 ),
        .Q(rejected_start_count[27]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \rejected_start_count_reg[27]_i_1 
       (.CI(\rejected_start_count_reg[23]_i_1_n_0 ),
        .CO({\rejected_start_count_reg[27]_i_1_n_0 ,\rejected_start_count_reg[27]_i_1_n_1 ,\rejected_start_count_reg[27]_i_1_n_2 ,\rejected_start_count_reg[27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\rejected_start_count_reg[27]_i_1_n_4 ,\rejected_start_count_reg[27]_i_1_n_5 ,\rejected_start_count_reg[27]_i_1_n_6 ,\rejected_start_count_reg[27]_i_1_n_7 }),
        .S(rejected_start_count[27:24]));
  FDRE \rejected_start_count_reg[28] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[31]_i_2_n_7 ),
        .Q(rejected_start_count[28]),
        .R(clear));
  FDRE \rejected_start_count_reg[29] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[31]_i_2_n_6 ),
        .Q(rejected_start_count[29]),
        .R(clear));
  FDRE \rejected_start_count_reg[2] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[3]_i_1_n_5 ),
        .Q(rejected_start_count[2]),
        .R(clear));
  FDRE \rejected_start_count_reg[30] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[31]_i_2_n_5 ),
        .Q(rejected_start_count[30]),
        .R(clear));
  FDRE \rejected_start_count_reg[31] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[31]_i_2_n_4 ),
        .Q(rejected_start_count[31]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \rejected_start_count_reg[31]_i_2 
       (.CI(\rejected_start_count_reg[27]_i_1_n_0 ),
        .CO({\NLW_rejected_start_count_reg[31]_i_2_CO_UNCONNECTED [3],\rejected_start_count_reg[31]_i_2_n_1 ,\rejected_start_count_reg[31]_i_2_n_2 ,\rejected_start_count_reg[31]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\rejected_start_count_reg[31]_i_2_n_4 ,\rejected_start_count_reg[31]_i_2_n_5 ,\rejected_start_count_reg[31]_i_2_n_6 ,\rejected_start_count_reg[31]_i_2_n_7 }),
        .S(rejected_start_count[31:28]));
  FDRE \rejected_start_count_reg[3] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[3]_i_1_n_4 ),
        .Q(rejected_start_count[3]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \rejected_start_count_reg[3]_i_1 
       (.CI(1'b0),
        .CO({\rejected_start_count_reg[3]_i_1_n_0 ,\rejected_start_count_reg[3]_i_1_n_1 ,\rejected_start_count_reg[3]_i_1_n_2 ,\rejected_start_count_reg[3]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\rejected_start_count_reg[3]_i_1_n_4 ,\rejected_start_count_reg[3]_i_1_n_5 ,\rejected_start_count_reg[3]_i_1_n_6 ,\rejected_start_count_reg[3]_i_1_n_7 }),
        .S({rejected_start_count[3:1],\rejected_start_count[3]_i_2_n_0 }));
  FDRE \rejected_start_count_reg[4] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[7]_i_1_n_7 ),
        .Q(rejected_start_count[4]),
        .R(clear));
  FDRE \rejected_start_count_reg[5] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[7]_i_1_n_6 ),
        .Q(rejected_start_count[5]),
        .R(clear));
  FDRE \rejected_start_count_reg[6] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[7]_i_1_n_5 ),
        .Q(rejected_start_count[6]),
        .R(clear));
  FDRE \rejected_start_count_reg[7] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[7]_i_1_n_4 ),
        .Q(rejected_start_count[7]),
        .R(clear));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \rejected_start_count_reg[7]_i_1 
       (.CI(\rejected_start_count_reg[3]_i_1_n_0 ),
        .CO({\rejected_start_count_reg[7]_i_1_n_0 ,\rejected_start_count_reg[7]_i_1_n_1 ,\rejected_start_count_reg[7]_i_1_n_2 ,\rejected_start_count_reg[7]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\rejected_start_count_reg[7]_i_1_n_4 ,\rejected_start_count_reg[7]_i_1_n_5 ,\rejected_start_count_reg[7]_i_1_n_6 ,\rejected_start_count_reg[7]_i_1_n_7 }),
        .S(rejected_start_count[7:4]));
  FDRE \rejected_start_count_reg[8] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[11]_i_1_n_7 ),
        .Q(rejected_start_count[8]),
        .R(clear));
  FDRE \rejected_start_count_reg[9] 
       (.C(aclk),
        .CE(\rejected_start_count[31]_i_1_n_0 ),
        .D(\rejected_start_count_reg[11]_i_1_n_6 ),
        .Q(rejected_start_count[9]),
        .R(clear));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h8)) 
    start_delayed_i_1
       (.I0(start),
        .I1(aresetn),
        .O(start_delayed_i_1_n_0));
  FDRE start_delayed_reg
       (.C(aclk),
        .CE(1'b1),
        .D(start_delayed_i_1_n_0),
        .Q(start_delayed),
        .R(1'b0));
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
