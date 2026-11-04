// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Fri Oct 30 22:04:32 2026
// Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/projects/fpga/voice-view-game/contest_v3/build/hardware/c6_latency/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_status_0/c6v_capture_status_0_sim_netlist.v
// Design      : c6v_capture_status_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "c6v_capture_status_0,axi_vision_capture_status,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "axi_vision_capture_status,Vivado 2026.1" *) 
(* NotValidForBitStream *)
module c6v_capture_status_0
   (s_axi_aclk,
    s_axi_aresetn,
    s_axi_awaddr,
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
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rvalid,
    s_axi_rready,
    monitor_ready,
    capture_armed,
    epoch_sealed,
    capture_epoch,
    fault_causes);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axi_aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF s_axi, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input s_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axi_aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s_axi_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWADDR" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 12, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input [11:0]s_axi_awaddr;
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
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARVALID" *) input s_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARREADY" *) output s_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RDATA" *) output [31:0]s_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RRESP" *) output [1:0]s_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RVALID" *) output s_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RREADY" *) input s_axi_rready;
  input monitor_ready;
  input capture_armed;
  input epoch_sealed;
  input [31:0]capture_epoch;
  input [2:0]fault_causes;

  wire \<const0> ;
  wire \<const1> ;
  wire capture_armed;
  wire [31:0]capture_epoch;
  wire epoch_sealed;
  wire [2:0]fault_causes;
  wire monitor_ready;
  wire s_axi_aclk;
  wire [11:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [31:0]s_axi_rdata;
  wire s_axi_rready;
  wire [1:1]\^s_axi_rresp ;
  wire s_axi_rvalid;
  wire s_axi_wready;
  wire s_axi_wvalid;

  assign s_axi_bresp[1] = \<const1> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_rresp[1] = \^s_axi_rresp [1];
  assign s_axi_rresp[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  c6v_capture_status_0_axi_vision_capture_status inst
       (.capture_armed(capture_armed),
        .capture_epoch(capture_epoch),
        .epoch_sealed(epoch_sealed),
        .fault_causes(fault_causes),
        .monitor_ready(monitor_ready),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid_reg_0(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rready(s_axi_rready),
        .s_axi_rresp(\^s_axi_rresp ),
        .s_axi_rvalid_reg_0(s_axi_rvalid),
        .s_axi_wready(s_axi_wready),
        .s_axi_wvalid(s_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "axi_vision_capture_status" *) 
module c6v_capture_status_0_axi_vision_capture_status
   (s_axi_rdata,
    s_axi_rresp,
    s_axi_wready,
    s_axi_bvalid_reg_0,
    s_axi_awready,
    s_axi_arready,
    s_axi_rvalid_reg_0,
    capture_armed,
    monitor_ready,
    epoch_sealed,
    s_axi_araddr,
    s_axi_aclk,
    capture_epoch,
    s_axi_aresetn,
    s_axi_arvalid,
    fault_causes,
    s_axi_bready,
    s_axi_awvalid,
    s_axi_wvalid,
    s_axi_rready);
  output [31:0]s_axi_rdata;
  output [0:0]s_axi_rresp;
  output s_axi_wready;
  output s_axi_bvalid_reg_0;
  output s_axi_awready;
  output s_axi_arready;
  output s_axi_rvalid_reg_0;
  input capture_armed;
  input monitor_ready;
  input epoch_sealed;
  input [11:0]s_axi_araddr;
  input s_axi_aclk;
  input [31:0]capture_epoch;
  input s_axi_aresetn;
  input s_axi_arvalid;
  input [2:0]fault_causes;
  input s_axi_bready;
  input s_axi_awvalid;
  input s_axi_wvalid;
  input s_axi_rready;

  wire aw_held;
  wire aw_held_i_1_n_0;
  wire capture_armed;
  wire [31:0]capture_epoch;
  wire [31:0]epoch_held;
  wire epoch_sealed;
  wire epoch_seen;
  wire epoch_seen_i_1_n_0;
  wire [2:0]fault_causes;
  wire [2:0]faults_held;
  wire monitor_ready;
  wire [2:0]p_0_in;
  wire [31:2]p_1_in;
  wire protocol_fault1_carry__0_n_0;
  wire protocol_fault1_carry__0_n_1;
  wire protocol_fault1_carry__0_n_2;
  wire protocol_fault1_carry__0_n_3;
  wire protocol_fault1_carry__1_n_1;
  wire protocol_fault1_carry__1_n_2;
  wire protocol_fault1_carry__1_n_3;
  wire protocol_fault1_carry_i_1__0_n_0;
  wire protocol_fault1_carry_i_1__1_n_0;
  wire protocol_fault1_carry_i_1_n_0;
  wire protocol_fault1_carry_i_2__0_n_0;
  wire protocol_fault1_carry_i_2__1_n_0;
  wire protocol_fault1_carry_i_2_n_0;
  wire protocol_fault1_carry_i_3__0_n_0;
  wire protocol_fault1_carry_i_3__1_n_0;
  wire protocol_fault1_carry_i_3_n_0;
  wire protocol_fault1_carry_i_4__0_n_0;
  wire protocol_fault1_carry_i_4_n_0;
  wire protocol_fault1_carry_n_0;
  wire protocol_fault1_carry_n_1;
  wire protocol_fault1_carry_n_2;
  wire protocol_fault1_carry_n_3;
  wire s_axi_aclk;
  wire [11:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_bvalid_i_1_n_0;
  wire s_axi_bvalid_i_2_n_0;
  wire s_axi_bvalid_reg_0;
  wire [31:0]s_axi_rdata;
  wire \s_axi_rdata[0]_i_1_n_0 ;
  wire \s_axi_rdata[0]_i_2_n_0 ;
  wire \s_axi_rdata[0]_i_3_n_0 ;
  wire \s_axi_rdata[1]_i_1_n_0 ;
  wire \s_axi_rdata[1]_i_2_n_0 ;
  wire \s_axi_rdata[1]_i_3_n_0 ;
  wire \s_axi_rdata[29]_i_2_n_0 ;
  wire \s_axi_rdata[2]_i_2_n_0 ;
  wire \s_axi_rdata[31]_i_3_n_0 ;
  wire \s_axi_rdata[31]_i_4_n_0 ;
  wire s_axi_rready;
  wire [0:0]s_axi_rresp;
  wire \s_axi_rresp[1]_i_1_n_0 ;
  wire s_axi_rvalid02_out;
  wire s_axi_rvalid_i_1_n_0;
  wire s_axi_rvalid_reg_0;
  wire s_axi_wready;
  wire s_axi_wvalid;
  wire w_held_i_1_n_0;
  wire w_held_reg_n_0;
  wire [3:0]NLW_protocol_fault1_carry_O_UNCONNECTED;
  wire [3:0]NLW_protocol_fault1_carry__0_O_UNCONNECTED;
  wire [3:3]NLW_protocol_fault1_carry__1_CO_UNCONNECTED;
  wire [3:0]NLW_protocol_fault1_carry__1_O_UNCONNECTED;

  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hCC0C0088)) 
    aw_held_i_1
       (.I0(s_axi_awvalid),
        .I1(s_axi_aresetn),
        .I2(w_held_reg_n_0),
        .I3(s_axi_bvalid_reg_0),
        .I4(aw_held),
        .O(aw_held_i_1_n_0));
  FDRE aw_held_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(aw_held_i_1_n_0),
        .Q(aw_held),
        .R(1'b0));
  FDRE \epoch_held_reg[0] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[0]),
        .Q(epoch_held[0]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[10] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[10]),
        .Q(epoch_held[10]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[11] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[11]),
        .Q(epoch_held[11]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[12] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[12]),
        .Q(epoch_held[12]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[13] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[13]),
        .Q(epoch_held[13]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[14] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[14]),
        .Q(epoch_held[14]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[15] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[15]),
        .Q(epoch_held[15]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[16] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[16]),
        .Q(epoch_held[16]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[17] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[17]),
        .Q(epoch_held[17]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[18] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[18]),
        .Q(epoch_held[18]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[19] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[19]),
        .Q(epoch_held[19]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[1] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[1]),
        .Q(epoch_held[1]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[20] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[20]),
        .Q(epoch_held[20]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[21] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[21]),
        .Q(epoch_held[21]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[22] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[22]),
        .Q(epoch_held[22]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[23] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[23]),
        .Q(epoch_held[23]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[24] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[24]),
        .Q(epoch_held[24]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[25] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[25]),
        .Q(epoch_held[25]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[26] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[26]),
        .Q(epoch_held[26]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[27] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[27]),
        .Q(epoch_held[27]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[28] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[28]),
        .Q(epoch_held[28]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[29] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[29]),
        .Q(epoch_held[29]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[2] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[2]),
        .Q(epoch_held[2]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[30] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[30]),
        .Q(epoch_held[30]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[31] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[31]),
        .Q(epoch_held[31]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[3] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[3]),
        .Q(epoch_held[3]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[4] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[4]),
        .Q(epoch_held[4]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[5] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[5]),
        .Q(epoch_held[5]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[6] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[6]),
        .Q(epoch_held[6]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[7] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[7]),
        .Q(epoch_held[7]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[8] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[8]),
        .Q(epoch_held[8]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \epoch_held_reg[9] 
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(capture_epoch[9]),
        .Q(epoch_held[9]),
        .R(s_axi_bvalid_i_1_n_0));
  LUT3 #(
    .INIT(8'h40)) 
    epoch_seen_i_1
       (.I0(epoch_seen),
        .I1(capture_armed),
        .I2(monitor_ready),
        .O(epoch_seen_i_1_n_0));
  FDRE epoch_seen_reg
       (.C(s_axi_aclk),
        .CE(epoch_seen_i_1_n_0),
        .D(1'b1),
        .Q(epoch_seen),
        .R(s_axi_bvalid_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \faults_held[0]_i_1 
       (.I0(faults_held[0]),
        .I1(fault_causes[0]),
        .O(p_0_in[0]));
  LUT2 #(
    .INIT(4'hE)) 
    \faults_held[1]_i_1 
       (.I0(fault_causes[1]),
        .I1(faults_held[1]),
        .O(p_0_in[1]));
  LUT6 #(
    .INIT(64'hFEEEFEFEFEFEFEFE)) 
    \faults_held[2]_i_1 
       (.I0(faults_held[2]),
        .I1(fault_causes[2]),
        .I2(epoch_seen),
        .I3(protocol_fault1_carry__1_n_1),
        .I4(capture_armed),
        .I5(monitor_ready),
        .O(p_0_in[2]));
  FDRE \faults_held_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in[0]),
        .Q(faults_held[0]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \faults_held_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in[1]),
        .Q(faults_held[1]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \faults_held_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(p_0_in[2]),
        .Q(faults_held[2]),
        .R(s_axi_bvalid_i_1_n_0));
  CARRY4 protocol_fault1_carry
       (.CI(1'b0),
        .CO({protocol_fault1_carry_n_0,protocol_fault1_carry_n_1,protocol_fault1_carry_n_2,protocol_fault1_carry_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_protocol_fault1_carry_O_UNCONNECTED[3:0]),
        .S({protocol_fault1_carry_i_1_n_0,protocol_fault1_carry_i_2_n_0,protocol_fault1_carry_i_3_n_0,protocol_fault1_carry_i_4_n_0}));
  CARRY4 protocol_fault1_carry__0
       (.CI(protocol_fault1_carry_n_0),
        .CO({protocol_fault1_carry__0_n_0,protocol_fault1_carry__0_n_1,protocol_fault1_carry__0_n_2,protocol_fault1_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b1,1'b1,1'b1,1'b1}),
        .O(NLW_protocol_fault1_carry__0_O_UNCONNECTED[3:0]),
        .S({protocol_fault1_carry_i_1__0_n_0,protocol_fault1_carry_i_2__0_n_0,protocol_fault1_carry_i_3__0_n_0,protocol_fault1_carry_i_4__0_n_0}));
  CARRY4 protocol_fault1_carry__1
       (.CI(protocol_fault1_carry__0_n_0),
        .CO({NLW_protocol_fault1_carry__1_CO_UNCONNECTED[3],protocol_fault1_carry__1_n_1,protocol_fault1_carry__1_n_2,protocol_fault1_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b1,1'b1,1'b1}),
        .O(NLW_protocol_fault1_carry__1_O_UNCONNECTED[3:0]),
        .S({1'b0,protocol_fault1_carry_i_1__1_n_0,protocol_fault1_carry_i_2__1_n_0,protocol_fault1_carry_i_3__1_n_0}));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    protocol_fault1_carry_i_1
       (.I0(epoch_held[10]),
        .I1(capture_epoch[10]),
        .I2(capture_epoch[11]),
        .I3(epoch_held[11]),
        .I4(capture_epoch[9]),
        .I5(epoch_held[9]),
        .O(protocol_fault1_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    protocol_fault1_carry_i_1__0
       (.I0(epoch_held[21]),
        .I1(capture_epoch[21]),
        .I2(capture_epoch[23]),
        .I3(epoch_held[23]),
        .I4(capture_epoch[22]),
        .I5(epoch_held[22]),
        .O(protocol_fault1_carry_i_1__0_n_0));
  LUT4 #(
    .INIT(16'h9009)) 
    protocol_fault1_carry_i_1__1
       (.I0(epoch_held[30]),
        .I1(capture_epoch[30]),
        .I2(epoch_held[31]),
        .I3(capture_epoch[31]),
        .O(protocol_fault1_carry_i_1__1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    protocol_fault1_carry_i_2
       (.I0(epoch_held[7]),
        .I1(capture_epoch[7]),
        .I2(capture_epoch[8]),
        .I3(epoch_held[8]),
        .I4(capture_epoch[6]),
        .I5(epoch_held[6]),
        .O(protocol_fault1_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    protocol_fault1_carry_i_2__0
       (.I0(epoch_held[19]),
        .I1(capture_epoch[19]),
        .I2(capture_epoch[20]),
        .I3(epoch_held[20]),
        .I4(capture_epoch[18]),
        .I5(epoch_held[18]),
        .O(protocol_fault1_carry_i_2__0_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    protocol_fault1_carry_i_2__1
       (.I0(epoch_held[27]),
        .I1(capture_epoch[27]),
        .I2(capture_epoch[29]),
        .I3(epoch_held[29]),
        .I4(capture_epoch[28]),
        .I5(epoch_held[28]),
        .O(protocol_fault1_carry_i_2__1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    protocol_fault1_carry_i_3
       (.I0(epoch_held[5]),
        .I1(capture_epoch[5]),
        .I2(capture_epoch[3]),
        .I3(epoch_held[3]),
        .I4(capture_epoch[4]),
        .I5(epoch_held[4]),
        .O(protocol_fault1_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    protocol_fault1_carry_i_3__0
       (.I0(epoch_held[15]),
        .I1(capture_epoch[15]),
        .I2(capture_epoch[17]),
        .I3(epoch_held[17]),
        .I4(capture_epoch[16]),
        .I5(epoch_held[16]),
        .O(protocol_fault1_carry_i_3__0_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    protocol_fault1_carry_i_3__1
       (.I0(epoch_held[26]),
        .I1(capture_epoch[26]),
        .I2(capture_epoch[25]),
        .I3(epoch_held[25]),
        .I4(capture_epoch[24]),
        .I5(epoch_held[24]),
        .O(protocol_fault1_carry_i_3__1_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    protocol_fault1_carry_i_4
       (.I0(capture_epoch[0]),
        .I1(epoch_held[0]),
        .I2(capture_epoch[1]),
        .I3(epoch_held[1]),
        .I4(epoch_held[2]),
        .I5(capture_epoch[2]),
        .O(protocol_fault1_carry_i_4_n_0));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    protocol_fault1_carry_i_4__0
       (.I0(epoch_held[13]),
        .I1(capture_epoch[13]),
        .I2(capture_epoch[14]),
        .I3(epoch_held[14]),
        .I4(capture_epoch[12]),
        .I5(epoch_held[12]),
        .O(protocol_fault1_carry_i_4__0_n_0));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h2)) 
    s_axi_arready_INST_0
       (.I0(s_axi_aresetn),
        .I1(s_axi_rvalid_reg_0),
        .O(s_axi_arready));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h04)) 
    s_axi_awready_INST_0
       (.I0(s_axi_bvalid_reg_0),
        .I1(s_axi_aresetn),
        .I2(aw_held),
        .O(s_axi_awready));
  LUT1 #(
    .INIT(2'h1)) 
    s_axi_bvalid_i_1
       (.I0(s_axi_aresetn),
        .O(s_axi_bvalid_i_1_n_0));
  LUT4 #(
    .INIT(16'h08F8)) 
    s_axi_bvalid_i_2
       (.I0(aw_held),
        .I1(w_held_reg_n_0),
        .I2(s_axi_bvalid_reg_0),
        .I3(s_axi_bready),
        .O(s_axi_bvalid_i_2_n_0));
  FDRE s_axi_bvalid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_bvalid_i_2_n_0),
        .Q(s_axi_bvalid_reg_0),
        .R(s_axi_bvalid_i_1_n_0));
  LUT6 #(
    .INIT(64'h4444454444444444)) 
    \s_axi_rdata[0]_i_1 
       (.I0(\s_axi_rdata[29]_i_2_n_0 ),
        .I1(\s_axi_rdata[0]_i_2_n_0 ),
        .I2(\s_axi_rdata[0]_i_3_n_0 ),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(s_axi_araddr[2]),
        .O(\s_axi_rdata[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h1140004000400040)) 
    \s_axi_rdata[0]_i_2 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_araddr[4]),
        .I2(epoch_held[0]),
        .I3(s_axi_araddr[3]),
        .I4(monitor_ready),
        .I5(epoch_seen),
        .O(\s_axi_rdata[0]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \s_axi_rdata[0]_i_3 
       (.I0(fault_causes[0]),
        .I1(faults_held[0]),
        .O(\s_axi_rdata[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[10]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[10]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[10]));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[11]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[11]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[11]));
  LUT5 #(
    .INIT(32'h01000101)) 
    \s_axi_rdata[12]_i_1 
       (.I0(s_axi_araddr[2]),
        .I1(\s_axi_rdata[29]_i_2_n_0 ),
        .I2(s_axi_araddr[3]),
        .I3(epoch_held[12]),
        .I4(s_axi_araddr[4]),
        .O(p_1_in[12]));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[13]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[13]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[13]));
  LUT5 #(
    .INIT(32'h01000101)) 
    \s_axi_rdata[14]_i_1 
       (.I0(s_axi_araddr[2]),
        .I1(\s_axi_rdata[29]_i_2_n_0 ),
        .I2(s_axi_araddr[3]),
        .I3(epoch_held[14]),
        .I4(s_axi_araddr[4]),
        .O(p_1_in[14]));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[15]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[15]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[15]));
  LUT5 #(
    .INIT(32'h00000064)) 
    \s_axi_rdata[16]_i_1 
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_araddr[2]),
        .I2(epoch_held[16]),
        .I3(\s_axi_rdata[29]_i_2_n_0 ),
        .I4(s_axi_araddr[3]),
        .O(p_1_in[16]));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[17]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[17]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[17]));
  LUT5 #(
    .INIT(32'h01000101)) 
    \s_axi_rdata[18]_i_1 
       (.I0(s_axi_araddr[2]),
        .I1(\s_axi_rdata[29]_i_2_n_0 ),
        .I2(s_axi_araddr[3]),
        .I3(epoch_held[18]),
        .I4(s_axi_araddr[4]),
        .O(p_1_in[18]));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[19]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[19]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[19]));
  LUT5 #(
    .INIT(32'h44444544)) 
    \s_axi_rdata[1]_i_1 
       (.I0(\s_axi_rdata[29]_i_2_n_0 ),
        .I1(\s_axi_rdata[1]_i_2_n_0 ),
        .I2(\s_axi_rdata[1]_i_3_n_0 ),
        .I3(epoch_sealed),
        .I4(s_axi_araddr[2]),
        .O(\s_axi_rdata[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0C230C230C230023)) 
    \s_axi_rdata[1]_i_2 
       (.I0(epoch_held[1]),
        .I1(s_axi_araddr[2]),
        .I2(s_axi_araddr[4]),
        .I3(s_axi_araddr[3]),
        .I4(fault_causes[1]),
        .I5(faults_held[1]),
        .O(\s_axi_rdata[1]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hBF)) 
    \s_axi_rdata[1]_i_3 
       (.I0(s_axi_araddr[4]),
        .I1(epoch_seen),
        .I2(monitor_ready),
        .O(\s_axi_rdata[1]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h01000101)) 
    \s_axi_rdata[20]_i_1 
       (.I0(s_axi_araddr[2]),
        .I1(\s_axi_rdata[29]_i_2_n_0 ),
        .I2(s_axi_araddr[3]),
        .I3(epoch_held[20]),
        .I4(s_axi_araddr[4]),
        .O(p_1_in[20]));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[21]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[21]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[21]));
  LUT5 #(
    .INIT(32'h01000101)) 
    \s_axi_rdata[22]_i_1 
       (.I0(s_axi_araddr[2]),
        .I1(\s_axi_rdata[29]_i_2_n_0 ),
        .I2(s_axi_araddr[3]),
        .I3(epoch_held[22]),
        .I4(s_axi_araddr[4]),
        .O(p_1_in[22]));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[23]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[23]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[23]));
  LUT5 #(
    .INIT(32'h01000101)) 
    \s_axi_rdata[24]_i_1 
       (.I0(s_axi_araddr[2]),
        .I1(\s_axi_rdata[29]_i_2_n_0 ),
        .I2(s_axi_araddr[3]),
        .I3(epoch_held[24]),
        .I4(s_axi_araddr[4]),
        .O(p_1_in[24]));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[25]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[25]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[25]));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[26]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[26]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[26]));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[27]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[27]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[27]));
  LUT5 #(
    .INIT(32'h01000101)) 
    \s_axi_rdata[28]_i_1 
       (.I0(s_axi_araddr[2]),
        .I1(\s_axi_rdata[29]_i_2_n_0 ),
        .I2(s_axi_araddr[3]),
        .I3(epoch_held[28]),
        .I4(s_axi_araddr[4]),
        .O(p_1_in[28]));
  LUT5 #(
    .INIT(32'h01000101)) 
    \s_axi_rdata[29]_i_1 
       (.I0(s_axi_araddr[2]),
        .I1(\s_axi_rdata[29]_i_2_n_0 ),
        .I2(s_axi_araddr[3]),
        .I3(epoch_held[29]),
        .I4(s_axi_araddr[4]),
        .O(p_1_in[29]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \s_axi_rdata[29]_i_2 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_araddr[1]),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(s_axi_araddr[10]),
        .I4(s_axi_araddr[8]),
        .I5(s_axi_araddr[9]),
        .O(\s_axi_rdata[29]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h000000000EAA0E0A)) 
    \s_axi_rdata[2]_i_1 
       (.I0(\s_axi_rdata[2]_i_2_n_0 ),
        .I1(p_0_in[2]),
        .I2(s_axi_araddr[4]),
        .I3(s_axi_araddr[3]),
        .I4(epoch_held[2]),
        .I5(\s_axi_rdata[29]_i_2_n_0 ),
        .O(p_1_in[2]));
  LUT6 #(
    .INIT(64'h00000000FFFFFFFD)) 
    \s_axi_rdata[2]_i_2 
       (.I0(s_axi_araddr[3]),
        .I1(faults_held[0]),
        .I2(fault_causes[0]),
        .I3(faults_held[1]),
        .I4(fault_causes[1]),
        .I5(s_axi_araddr[2]),
        .O(\s_axi_rdata[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[30]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[30]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[30]));
  LUT2 #(
    .INIT(4'h4)) 
    \s_axi_rdata[31]_i_1 
       (.I0(s_axi_rvalid_reg_0),
        .I1(s_axi_arvalid),
        .O(s_axi_rvalid02_out));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[31]_i_2 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[31]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[31]));
  LUT5 #(
    .INIT(32'h00000002)) 
    \s_axi_rdata[31]_i_3 
       (.I0(s_axi_araddr[4]),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(s_axi_araddr[10]),
        .I3(s_axi_araddr[8]),
        .I4(s_axi_araddr[9]),
        .O(\s_axi_rdata[31]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \s_axi_rdata[31]_i_4 
       (.I0(s_axi_araddr[7]),
        .I1(s_axi_araddr[5]),
        .I2(s_axi_araddr[11]),
        .I3(s_axi_araddr[6]),
        .O(\s_axi_rdata[31]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[3]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[3]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[3]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h01000101)) 
    \s_axi_rdata[4]_i_1 
       (.I0(s_axi_araddr[2]),
        .I1(\s_axi_rdata[29]_i_2_n_0 ),
        .I2(s_axi_araddr[3]),
        .I3(epoch_held[4]),
        .I4(s_axi_araddr[4]),
        .O(p_1_in[4]));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[5]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[5]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[5]));
  LUT5 #(
    .INIT(32'h01000101)) 
    \s_axi_rdata[6]_i_1 
       (.I0(s_axi_araddr[2]),
        .I1(\s_axi_rdata[29]_i_2_n_0 ),
        .I2(s_axi_araddr[3]),
        .I3(epoch_held[6]),
        .I4(s_axi_araddr[4]),
        .O(p_1_in[6]));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \s_axi_rdata[7]_i_1 
       (.I0(\s_axi_rdata[31]_i_3_n_0 ),
        .I1(epoch_held[7]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(p_1_in[7]));
  LUT5 #(
    .INIT(32'h01000101)) 
    \s_axi_rdata[8]_i_1 
       (.I0(s_axi_araddr[2]),
        .I1(\s_axi_rdata[29]_i_2_n_0 ),
        .I2(s_axi_araddr[3]),
        .I3(epoch_held[8]),
        .I4(s_axi_araddr[4]),
        .O(p_1_in[8]));
  LUT5 #(
    .INIT(32'h01000101)) 
    \s_axi_rdata[9]_i_1 
       (.I0(s_axi_araddr[2]),
        .I1(\s_axi_rdata[29]_i_2_n_0 ),
        .I2(s_axi_araddr[3]),
        .I3(epoch_held[9]),
        .I4(s_axi_araddr[4]),
        .O(p_1_in[9]));
  FDRE \s_axi_rdata_reg[0] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(\s_axi_rdata[0]_i_1_n_0 ),
        .Q(s_axi_rdata[0]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[10] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[10]),
        .Q(s_axi_rdata[10]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[11] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[11]),
        .Q(s_axi_rdata[11]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[12] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[12]),
        .Q(s_axi_rdata[12]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[13] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[13]),
        .Q(s_axi_rdata[13]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[14] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[14]),
        .Q(s_axi_rdata[14]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[15] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[15]),
        .Q(s_axi_rdata[15]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[16] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[16]),
        .Q(s_axi_rdata[16]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[17] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[17]),
        .Q(s_axi_rdata[17]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[18] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[18]),
        .Q(s_axi_rdata[18]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[19] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[19]),
        .Q(s_axi_rdata[19]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[1] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(\s_axi_rdata[1]_i_1_n_0 ),
        .Q(s_axi_rdata[1]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[20] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[20]),
        .Q(s_axi_rdata[20]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[21] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[21]),
        .Q(s_axi_rdata[21]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[22] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[22]),
        .Q(s_axi_rdata[22]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[23] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[23]),
        .Q(s_axi_rdata[23]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[24] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[24]),
        .Q(s_axi_rdata[24]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[25] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[25]),
        .Q(s_axi_rdata[25]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[26] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[26]),
        .Q(s_axi_rdata[26]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[27] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[27]),
        .Q(s_axi_rdata[27]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[28] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[28]),
        .Q(s_axi_rdata[28]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[29] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[29]),
        .Q(s_axi_rdata[29]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[2] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[2]),
        .Q(s_axi_rdata[2]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[30] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[30]),
        .Q(s_axi_rdata[30]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[31] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[31]),
        .Q(s_axi_rdata[31]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[3] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[3]),
        .Q(s_axi_rdata[3]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[4] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[4]),
        .Q(s_axi_rdata[4]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[5] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[5]),
        .Q(s_axi_rdata[5]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[6] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[6]),
        .Q(s_axi_rdata[6]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[7] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[7]),
        .Q(s_axi_rdata[7]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[8] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[8]),
        .Q(s_axi_rdata[8]),
        .R(s_axi_bvalid_i_1_n_0));
  FDRE \s_axi_rdata_reg[9] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(p_1_in[9]),
        .Q(s_axi_rdata[9]),
        .R(s_axi_bvalid_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hFFE0)) 
    \s_axi_rresp[1]_i_1 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[2]),
        .I2(s_axi_araddr[4]),
        .I3(\s_axi_rdata[29]_i_2_n_0 ),
        .O(\s_axi_rresp[1]_i_1_n_0 ));
  FDRE \s_axi_rresp_reg[1] 
       (.C(s_axi_aclk),
        .CE(s_axi_rvalid02_out),
        .D(\s_axi_rresp[1]_i_1_n_0 ),
        .Q(s_axi_rresp),
        .R(s_axi_bvalid_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h2E)) 
    s_axi_rvalid_i_1
       (.I0(s_axi_arvalid),
        .I1(s_axi_rvalid_reg_0),
        .I2(s_axi_rready),
        .O(s_axi_rvalid_i_1_n_0));
  FDRE s_axi_rvalid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_rvalid_i_1_n_0),
        .Q(s_axi_rvalid_reg_0),
        .R(s_axi_bvalid_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h04)) 
    s_axi_wready_INST_0
       (.I0(s_axi_bvalid_reg_0),
        .I1(s_axi_aresetn),
        .I2(w_held_reg_n_0),
        .O(s_axi_wready));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hC008C0C8)) 
    w_held_i_1
       (.I0(s_axi_wvalid),
        .I1(s_axi_aresetn),
        .I2(w_held_reg_n_0),
        .I3(s_axi_bvalid_reg_0),
        .I4(aw_held),
        .O(w_held_i_1_n_0));
  FDRE w_held_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(w_held_i_1_n_0),
        .Q(w_held_reg_n_0),
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
