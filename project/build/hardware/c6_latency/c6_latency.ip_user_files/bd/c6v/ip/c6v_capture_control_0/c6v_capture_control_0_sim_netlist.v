// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Fri Oct 23 06:47:56 2026
// Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/vvl/c0e/c6_latency.gen/sources_1/bd/c6v/ip/c6v_capture_control_0/c6v_capture_control_0_sim_netlist.v
// Design      : c6v_capture_control_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "c6v_capture_control_0,axi_vision_capture_control,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "axi_vision_capture_control,Vivado 2026.1" *) 
(* NotValidForBitStream *)
module c6v_capture_control_0
   (s_axi_aclk,
    s_axi_aresetn,
    common_aresetn,
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
    cfg_frame_context,
    capture_aresetn,
    armed,
    abort_requested,
    barrier_request,
    owner_available,
    owner_cpu_held,
    owner_drained,
    owner_fault,
    owner_claim_accepted,
    owner_release_accepted,
    owner_epoch,
    owner_frame_id,
    owner_slot,
    owner_granted_frames,
    owner_released_frames,
    owner_fault_causes,
    owner_cpu_claim,
    owner_cpu_release,
    owner_command_fault,
    owner_cpu_epoch,
    owner_cpu_frame_id);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axi_aclk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn:common_aresetn:capture_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input s_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axi_aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s_axi_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 common_aresetn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME common_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input common_aresetn;
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
  output [143:0]cfg_frame_context;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 capture_aresetn RST" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME capture_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) output capture_aresetn;
  output armed;
  output abort_requested;
  output barrier_request;
  input owner_available;
  input owner_cpu_held;
  input owner_drained;
  input owner_fault;
  input owner_claim_accepted;
  input owner_release_accepted;
  input [31:0]owner_epoch;
  input [31:0]owner_frame_id;
  input [31:0]owner_slot;
  input [31:0]owner_granted_frames;
  input [31:0]owner_released_frames;
  input [3:0]owner_fault_causes;
  output owner_cpu_claim;
  output owner_cpu_release;
  output owner_command_fault;
  output [31:0]owner_cpu_epoch;
  output [31:0]owner_cpu_frame_id;

  wire \<const0> ;
  wire abort_requested;
  wire armed;
  wire barrier_request;
  wire capture_aresetn;
  wire [143:0]cfg_frame_context;
  wire common_aresetn;
  wire owner_available;
  wire owner_claim_accepted;
  wire owner_command_fault;
  wire owner_cpu_claim;
  wire [31:0]owner_cpu_epoch;
  wire [31:0]owner_cpu_frame_id;
  wire owner_cpu_held;
  wire owner_cpu_release;
  wire owner_drained;
  wire [31:0]owner_epoch;
  wire owner_fault;
  wire [3:0]owner_fault_causes;
  wire [31:0]owner_frame_id;
  wire [31:0]owner_granted_frames;
  wire owner_release_accepted;
  wire [31:0]owner_released_frames;
  wire [31:0]owner_slot;
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

  assign s_axi_bresp[1] = \^s_axi_bresp [1];
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_rresp[1] = \^s_axi_rresp [1];
  assign s_axi_rresp[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  c6v_capture_control_0_axi_vision_capture_control inst
       (.D({owner_drained,owner_cpu_held,owner_available}),
        .abort_requested_reg_0(abort_requested),
        .armed_reg_0(armed),
        .barrier_request_reg_0(barrier_request),
        .capture_aresetn(capture_aresetn),
        .cfg_frame_context(cfg_frame_context),
        .common_aresetn(common_aresetn),
        .owner_claim_accepted(owner_claim_accepted),
        .owner_command_fault_reg_0(owner_command_fault),
        .owner_cpu_claim(owner_cpu_claim),
        .owner_cpu_epoch(owner_cpu_epoch),
        .owner_cpu_frame_id(owner_cpu_frame_id),
        .owner_cpu_release(owner_cpu_release),
        .owner_epoch(owner_epoch),
        .owner_fault(owner_fault),
        .owner_fault_causes(owner_fault_causes),
        .owner_frame_id(owner_frame_id),
        .owner_granted_frames(owner_granted_frames),
        .owner_release_accepted(owner_release_accepted),
        .owner_released_frames(owner_released_frames),
        .owner_slot(owner_slot),
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
        .s_axi_bvalid_reg_0(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rready(s_axi_rready),
        .s_axi_rresp(\^s_axi_rresp ),
        .s_axi_rvalid_reg_0(s_axi_rvalid),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "axi_vision_capture_control" *) 
module c6v_capture_control_0_axi_vision_capture_control
   (owner_command_fault_reg_0,
    armed_reg_0,
    cfg_frame_context,
    owner_cpu_epoch,
    owner_cpu_frame_id,
    s_axi_rdata,
    capture_aresetn,
    s_axi_wready,
    s_axi_bvalid_reg_0,
    s_axi_awready,
    barrier_request_reg_0,
    abort_requested_reg_0,
    s_axi_arready,
    s_axi_rvalid_reg_0,
    s_axi_bresp,
    s_axi_rresp,
    owner_cpu_claim,
    owner_cpu_release,
    s_axi_aresetn,
    owner_fault,
    s_axi_araddr,
    owner_release_accepted,
    owner_claim_accepted,
    s_axi_awaddr,
    s_axi_aclk,
    s_axi_wdata,
    s_axi_wstrb,
    D,
    common_aresetn,
    s_axi_arvalid,
    owner_released_frames,
    owner_fault_causes,
    owner_granted_frames,
    owner_slot,
    owner_frame_id,
    owner_epoch,
    s_axi_awvalid,
    s_axi_wvalid,
    s_axi_bready,
    s_axi_rready);
  output owner_command_fault_reg_0;
  output armed_reg_0;
  output [143:0]cfg_frame_context;
  output [31:0]owner_cpu_epoch;
  output [31:0]owner_cpu_frame_id;
  output [31:0]s_axi_rdata;
  output capture_aresetn;
  output s_axi_wready;
  output s_axi_bvalid_reg_0;
  output s_axi_awready;
  output barrier_request_reg_0;
  output abort_requested_reg_0;
  output s_axi_arready;
  output s_axi_rvalid_reg_0;
  output [0:0]s_axi_bresp;
  output [0:0]s_axi_rresp;
  output owner_cpu_claim;
  output owner_cpu_release;
  input s_axi_aresetn;
  input owner_fault;
  input [11:0]s_axi_araddr;
  input owner_release_accepted;
  input owner_claim_accepted;
  input [11:0]s_axi_awaddr;
  input s_axi_aclk;
  input [31:0]s_axi_wdata;
  input [3:0]s_axi_wstrb;
  input [2:0]D;
  input common_aresetn;
  input s_axi_arvalid;
  input [31:0]owner_released_frames;
  input [3:0]owner_fault_causes;
  input [31:0]owner_granted_frames;
  input [31:0]owner_slot;
  input [31:0]owner_frame_id;
  input [31:0]owner_epoch;
  input s_axi_awvalid;
  input s_axi_wvalid;
  input s_axi_bready;
  input s_axi_rready;

  wire [2:0]D;
  wire abort_requested0;
  wire abort_requested2;
  wire abort_requested_i_1_n_0;
  wire abort_requested_i_3_n_0;
  wire abort_requested_i_4_n_0;
  wire abort_requested_i_5_n_0;
  wire abort_requested_reg_0;
  wire \address_held_reg_n_0_[0] ;
  wire \address_held_reg_n_0_[10] ;
  wire \address_held_reg_n_0_[11] ;
  wire \address_held_reg_n_0_[1] ;
  wire \address_held_reg_n_0_[4] ;
  wire \address_held_reg_n_0_[5] ;
  wire \address_held_reg_n_0_[6] ;
  wire \address_held_reg_n_0_[7] ;
  wire \address_held_reg_n_0_[8] ;
  wire \address_held_reg_n_0_[9] ;
  wire armed0;
  wire armed_i_10_n_0;
  wire armed_i_11_n_0;
  wire armed_i_12_n_0;
  wire armed_i_13_n_0;
  wire armed_i_1_n_0;
  wire armed_i_3_n_0;
  wire armed_i_4_n_0;
  wire armed_i_5_n_0;
  wire armed_i_6_n_0;
  wire armed_i_7_n_0;
  wire armed_i_8_n_0;
  wire armed_i_9_n_0;
  wire armed_reg_0;
  wire aw_held;
  wire aw_held0;
  wire aw_held_i_1_n_0;
  wire barrier_request0;
  wire barrier_request_i_1_n_0;
  wire barrier_request_reg_0;
  wire capture_aresetn;
  wire capture_aresetn0;
  wire capture_aresetn_i_2_n_0;
  wire [143:0]cfg_frame_context;
  wire [95:0]cfg_frame_context0;
  wire \cfg_frame_context[127]_i_1_n_0 ;
  wire \cfg_frame_context[127]_i_2_n_0 ;
  wire \cfg_frame_context[127]_i_3_n_0 ;
  wire \cfg_frame_context[143]_i_1_n_0 ;
  wire \cfg_frame_context[143]_i_3_n_0 ;
  wire \cfg_frame_context[31]_i_1_n_0 ;
  wire \cfg_frame_context[31]_i_3_n_0 ;
  wire \cfg_frame_context[63]_i_1_n_0 ;
  wire \cfg_frame_context[95]_i_1_n_0 ;
  wire \cfg_frame_context[95]_i_3_n_0 ;
  wire common_aresetn;
  wire \configured[0]_i_1_n_0 ;
  wire \configured[1]_i_1_n_0 ;
  wire \configured[2]_i_1_n_0 ;
  wire \configured[3]_i_1_n_0 ;
  wire \configured[4]_i_1_n_0 ;
  wire \configured[4]_i_2_n_0 ;
  wire \configured[4]_i_3_n_0 ;
  wire \configured[4]_i_4_n_0 ;
  wire \configured[4]_i_5_n_0 ;
  wire \configured[4]_i_6_n_0 ;
  wire \configured_reg_n_0_[0] ;
  wire \configured_reg_n_0_[1] ;
  wire \configured_reg_n_0_[2] ;
  wire \configured_reg_n_0_[3] ;
  wire \configured_reg_n_0_[4] ;
  wire [31:0]data_held;
  wire owner_claim_accepted;
  wire owner_command_fault_i_1_n_0;
  wire owner_command_fault_i_2_n_0;
  wire owner_command_fault_reg_0;
  wire owner_command_is_release_i_1_n_0;
  wire owner_command_is_release_reg_n_0;
  wire owner_command_pending18_out;
  wire owner_command_pending_i_1_n_0;
  wire owner_command_pending_reg_n_0;
  wire \owner_command_wait[0]_i_1_n_0 ;
  wire \owner_command_wait[1]_i_1_n_0 ;
  wire \owner_command_wait[1]_i_2_n_0 ;
  wire \owner_command_wait[1]_i_3_n_0 ;
  wire \owner_command_wait[1]_i_4_n_0 ;
  wire \owner_command_wait_reg_n_0_[0] ;
  wire \owner_command_wait_reg_n_0_[1] ;
  wire owner_cpu_claim;
  wire owner_cpu_claim_i_1_n_0;
  wire owner_cpu_claim_i_2_n_0;
  wire owner_cpu_claim_i_3_n_0;
  wire owner_cpu_claim_i_4_n_0;
  wire owner_cpu_claim_i_5_n_0;
  wire owner_cpu_claim_i_6_n_0;
  wire owner_cpu_claim_i_7_n_0;
  wire owner_cpu_claim_i_8_n_0;
  wire owner_cpu_claim_i_9_n_0;
  wire [31:0]owner_cpu_epoch;
  wire \owner_cpu_epoch[31]_i_1_n_0 ;
  wire \owner_cpu_epoch[31]_i_2_n_0 ;
  wire \owner_cpu_epoch[31]_i_3_n_0 ;
  wire \owner_cpu_epoch[31]_i_4_n_0 ;
  wire [31:0]owner_cpu_frame_id;
  wire \owner_cpu_frame_id[31]_i_1_n_0 ;
  wire owner_cpu_release;
  wire owner_cpu_release_i_1_n_0;
  wire [31:0]owner_epoch;
  wire owner_fault;
  wire [3:0]owner_fault_causes;
  wire [31:0]owner_frame_id;
  wire [31:0]owner_granted_frames;
  wire owner_release_accepted;
  wire [31:0]owner_released_frames;
  wire [31:0]owner_slot;
  wire \owner_status_held[6]_i_2_n_0 ;
  wire \owner_status_held[6]_i_3_n_0 ;
  wire \owner_status_held[6]_i_4_n_0 ;
  wire \owner_status_held[6]_i_5_n_0 ;
  wire \owner_status_held_reg_n_0_[0] ;
  wire \owner_status_held_reg_n_0_[1] ;
  wire \owner_status_held_reg_n_0_[2] ;
  wire \owner_status_held_reg_n_0_[3] ;
  wire \owner_status_held_reg_n_0_[4] ;
  wire \owner_status_held_reg_n_0_[5] ;
  wire \owner_status_held_reg_n_0_[6] ;
  wire owner_status_pending1;
  wire owner_status_pending3_out;
  wire owner_status_pending_i_1_n_0;
  wire owner_status_pending_reg_n_0;
  wire \owner_token_configured[0]_i_1_n_0 ;
  wire \owner_token_configured[1]_i_1_n_0 ;
  wire \owner_token_configured[1]_i_2_n_0 ;
  wire \owner_token_configured[1]_i_3_n_0 ;
  wire \owner_token_configured[1]_i_4_n_0 ;
  wire \owner_token_configured[1]_i_5_n_0 ;
  wire \owner_token_configured_reg_n_0_[0] ;
  wire \owner_token_configured_reg_n_0_[1] ;
  wire [1:0]p_0_in;
  wire [3:3]p_0_out;
  wire [143:128]p_2_in;
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
  wire \s_axi_bresp[1]_i_10_n_0 ;
  wire \s_axi_bresp[1]_i_11_n_0 ;
  wire \s_axi_bresp[1]_i_12_n_0 ;
  wire \s_axi_bresp[1]_i_13_n_0 ;
  wire \s_axi_bresp[1]_i_14_n_0 ;
  wire \s_axi_bresp[1]_i_15_n_0 ;
  wire \s_axi_bresp[1]_i_16_n_0 ;
  wire \s_axi_bresp[1]_i_17_n_0 ;
  wire \s_axi_bresp[1]_i_18_n_0 ;
  wire \s_axi_bresp[1]_i_19_n_0 ;
  wire \s_axi_bresp[1]_i_1_n_0 ;
  wire \s_axi_bresp[1]_i_20_n_0 ;
  wire \s_axi_bresp[1]_i_21_n_0 ;
  wire \s_axi_bresp[1]_i_22_n_0 ;
  wire \s_axi_bresp[1]_i_23_n_0 ;
  wire \s_axi_bresp[1]_i_24_n_0 ;
  wire \s_axi_bresp[1]_i_25_n_0 ;
  wire \s_axi_bresp[1]_i_26_n_0 ;
  wire \s_axi_bresp[1]_i_27_n_0 ;
  wire \s_axi_bresp[1]_i_2_n_0 ;
  wire \s_axi_bresp[1]_i_3_n_0 ;
  wire \s_axi_bresp[1]_i_4_n_0 ;
  wire \s_axi_bresp[1]_i_5_n_0 ;
  wire \s_axi_bresp[1]_i_6_n_0 ;
  wire \s_axi_bresp[1]_i_7_n_0 ;
  wire \s_axi_bresp[1]_i_9_n_0 ;
  wire s_axi_bvalid_i_1_n_0;
  wire s_axi_bvalid_i_3_n_0;
  wire s_axi_bvalid_i_4_n_0;
  wire s_axi_bvalid_reg_0;
  wire [31:0]s_axi_rdata;
  wire \s_axi_rdata[0]_i_1_n_0 ;
  wire \s_axi_rdata[0]_i_2_n_0 ;
  wire \s_axi_rdata[0]_i_3_n_0 ;
  wire \s_axi_rdata[0]_i_4_n_0 ;
  wire \s_axi_rdata[0]_i_5_n_0 ;
  wire \s_axi_rdata[0]_i_6_n_0 ;
  wire \s_axi_rdata[0]_i_7_n_0 ;
  wire \s_axi_rdata[0]_i_8_n_0 ;
  wire \s_axi_rdata[10]_i_1_n_0 ;
  wire \s_axi_rdata[10]_i_2_n_0 ;
  wire \s_axi_rdata[10]_i_3_n_0 ;
  wire \s_axi_rdata[10]_i_4_n_0 ;
  wire \s_axi_rdata[10]_i_5_n_0 ;
  wire \s_axi_rdata[10]_i_6_n_0 ;
  wire \s_axi_rdata[11]_i_1_n_0 ;
  wire \s_axi_rdata[11]_i_2_n_0 ;
  wire \s_axi_rdata[11]_i_3_n_0 ;
  wire \s_axi_rdata[11]_i_4_n_0 ;
  wire \s_axi_rdata[11]_i_5_n_0 ;
  wire \s_axi_rdata[12]_i_1_n_0 ;
  wire \s_axi_rdata[12]_i_2_n_0 ;
  wire \s_axi_rdata[12]_i_3_n_0 ;
  wire \s_axi_rdata[12]_i_4_n_0 ;
  wire \s_axi_rdata[12]_i_5_n_0 ;
  wire \s_axi_rdata[12]_i_6_n_0 ;
  wire \s_axi_rdata[13]_i_1_n_0 ;
  wire \s_axi_rdata[13]_i_2_n_0 ;
  wire \s_axi_rdata[13]_i_3_n_0 ;
  wire \s_axi_rdata[13]_i_4_n_0 ;
  wire \s_axi_rdata[13]_i_5_n_0 ;
  wire \s_axi_rdata[14]_i_1_n_0 ;
  wire \s_axi_rdata[14]_i_2_n_0 ;
  wire \s_axi_rdata[14]_i_3_n_0 ;
  wire \s_axi_rdata[14]_i_4_n_0 ;
  wire \s_axi_rdata[14]_i_5_n_0 ;
  wire \s_axi_rdata[14]_i_6_n_0 ;
  wire \s_axi_rdata[15]_i_1_n_0 ;
  wire \s_axi_rdata[15]_i_2_n_0 ;
  wire \s_axi_rdata[15]_i_3_n_0 ;
  wire \s_axi_rdata[15]_i_4_n_0 ;
  wire \s_axi_rdata[15]_i_5_n_0 ;
  wire \s_axi_rdata[16]_i_1_n_0 ;
  wire \s_axi_rdata[16]_i_2_n_0 ;
  wire \s_axi_rdata[16]_i_3_n_0 ;
  wire \s_axi_rdata[16]_i_4_n_0 ;
  wire \s_axi_rdata[16]_i_5_n_0 ;
  wire \s_axi_rdata[17]_i_1_n_0 ;
  wire \s_axi_rdata[17]_i_2_n_0 ;
  wire \s_axi_rdata[17]_i_3_n_0 ;
  wire \s_axi_rdata[17]_i_4_n_0 ;
  wire \s_axi_rdata[17]_i_5_n_0 ;
  wire \s_axi_rdata[17]_i_6_n_0 ;
  wire \s_axi_rdata[18]_i_1_n_0 ;
  wire \s_axi_rdata[18]_i_2_n_0 ;
  wire \s_axi_rdata[18]_i_3_n_0 ;
  wire \s_axi_rdata[18]_i_4_n_0 ;
  wire \s_axi_rdata[18]_i_5_n_0 ;
  wire \s_axi_rdata[19]_i_1_n_0 ;
  wire \s_axi_rdata[19]_i_2_n_0 ;
  wire \s_axi_rdata[19]_i_3_n_0 ;
  wire \s_axi_rdata[19]_i_4_n_0 ;
  wire \s_axi_rdata[19]_i_5_n_0 ;
  wire \s_axi_rdata[1]_i_1_n_0 ;
  wire \s_axi_rdata[1]_i_2_n_0 ;
  wire \s_axi_rdata[1]_i_3_n_0 ;
  wire \s_axi_rdata[1]_i_4_n_0 ;
  wire \s_axi_rdata[1]_i_5_n_0 ;
  wire \s_axi_rdata[1]_i_6_n_0 ;
  wire \s_axi_rdata[1]_i_7_n_0 ;
  wire \s_axi_rdata[1]_i_8_n_0 ;
  wire \s_axi_rdata[20]_i_1_n_0 ;
  wire \s_axi_rdata[20]_i_2_n_0 ;
  wire \s_axi_rdata[20]_i_3_n_0 ;
  wire \s_axi_rdata[20]_i_4_n_0 ;
  wire \s_axi_rdata[20]_i_5_n_0 ;
  wire \s_axi_rdata[21]_i_1_n_0 ;
  wire \s_axi_rdata[21]_i_2_n_0 ;
  wire \s_axi_rdata[21]_i_3_n_0 ;
  wire \s_axi_rdata[21]_i_4_n_0 ;
  wire \s_axi_rdata[21]_i_5_n_0 ;
  wire \s_axi_rdata[22]_i_1_n_0 ;
  wire \s_axi_rdata[22]_i_2_n_0 ;
  wire \s_axi_rdata[22]_i_3_n_0 ;
  wire \s_axi_rdata[22]_i_4_n_0 ;
  wire \s_axi_rdata[22]_i_5_n_0 ;
  wire \s_axi_rdata[23]_i_1_n_0 ;
  wire \s_axi_rdata[23]_i_2_n_0 ;
  wire \s_axi_rdata[23]_i_3_n_0 ;
  wire \s_axi_rdata[23]_i_4_n_0 ;
  wire \s_axi_rdata[23]_i_5_n_0 ;
  wire \s_axi_rdata[24]_i_1_n_0 ;
  wire \s_axi_rdata[24]_i_2_n_0 ;
  wire \s_axi_rdata[24]_i_3_n_0 ;
  wire \s_axi_rdata[24]_i_4_n_0 ;
  wire \s_axi_rdata[24]_i_5_n_0 ;
  wire \s_axi_rdata[25]_i_1_n_0 ;
  wire \s_axi_rdata[25]_i_2_n_0 ;
  wire \s_axi_rdata[25]_i_3_n_0 ;
  wire \s_axi_rdata[25]_i_4_n_0 ;
  wire \s_axi_rdata[25]_i_5_n_0 ;
  wire \s_axi_rdata[26]_i_1_n_0 ;
  wire \s_axi_rdata[26]_i_2_n_0 ;
  wire \s_axi_rdata[26]_i_3_n_0 ;
  wire \s_axi_rdata[26]_i_4_n_0 ;
  wire \s_axi_rdata[26]_i_5_n_0 ;
  wire \s_axi_rdata[27]_i_1_n_0 ;
  wire \s_axi_rdata[27]_i_2_n_0 ;
  wire \s_axi_rdata[27]_i_3_n_0 ;
  wire \s_axi_rdata[27]_i_4_n_0 ;
  wire \s_axi_rdata[27]_i_5_n_0 ;
  wire \s_axi_rdata[28]_i_1_n_0 ;
  wire \s_axi_rdata[28]_i_2_n_0 ;
  wire \s_axi_rdata[28]_i_3_n_0 ;
  wire \s_axi_rdata[28]_i_4_n_0 ;
  wire \s_axi_rdata[28]_i_5_n_0 ;
  wire \s_axi_rdata[29]_i_1_n_0 ;
  wire \s_axi_rdata[29]_i_2_n_0 ;
  wire \s_axi_rdata[29]_i_3_n_0 ;
  wire \s_axi_rdata[29]_i_4_n_0 ;
  wire \s_axi_rdata[29]_i_5_n_0 ;
  wire \s_axi_rdata[29]_i_6_n_0 ;
  wire \s_axi_rdata[2]_i_1_n_0 ;
  wire \s_axi_rdata[2]_i_2_n_0 ;
  wire \s_axi_rdata[2]_i_3_n_0 ;
  wire \s_axi_rdata[2]_i_4_n_0 ;
  wire \s_axi_rdata[2]_i_5_n_0 ;
  wire \s_axi_rdata[2]_i_6_n_0 ;
  wire \s_axi_rdata[2]_i_7_n_0 ;
  wire \s_axi_rdata[2]_i_8_n_0 ;
  wire \s_axi_rdata[30]_i_1_n_0 ;
  wire \s_axi_rdata[30]_i_2_n_0 ;
  wire \s_axi_rdata[30]_i_3_n_0 ;
  wire \s_axi_rdata[30]_i_4_n_0 ;
  wire \s_axi_rdata[30]_i_5_n_0 ;
  wire \s_axi_rdata[30]_i_6_n_0 ;
  wire \s_axi_rdata[31]_i_10_n_0 ;
  wire \s_axi_rdata[31]_i_11_n_0 ;
  wire \s_axi_rdata[31]_i_12_n_0 ;
  wire \s_axi_rdata[31]_i_1_n_0 ;
  wire \s_axi_rdata[31]_i_2_n_0 ;
  wire \s_axi_rdata[31]_i_3_n_0 ;
  wire \s_axi_rdata[31]_i_4_n_0 ;
  wire \s_axi_rdata[31]_i_5_n_0 ;
  wire \s_axi_rdata[31]_i_6_n_0 ;
  wire \s_axi_rdata[31]_i_7_n_0 ;
  wire \s_axi_rdata[31]_i_8_n_0 ;
  wire \s_axi_rdata[31]_i_9_n_0 ;
  wire \s_axi_rdata[3]_i_1_n_0 ;
  wire \s_axi_rdata[3]_i_2_n_0 ;
  wire \s_axi_rdata[3]_i_3_n_0 ;
  wire \s_axi_rdata[3]_i_5_n_0 ;
  wire \s_axi_rdata[3]_i_6_n_0 ;
  wire \s_axi_rdata[3]_i_7_n_0 ;
  wire \s_axi_rdata[3]_i_8_n_0 ;
  wire \s_axi_rdata[3]_i_9_n_0 ;
  wire \s_axi_rdata[4]_i_1_n_0 ;
  wire \s_axi_rdata[4]_i_2_n_0 ;
  wire \s_axi_rdata[4]_i_3_n_0 ;
  wire \s_axi_rdata[4]_i_4_n_0 ;
  wire \s_axi_rdata[4]_i_5_n_0 ;
  wire \s_axi_rdata[4]_i_6_n_0 ;
  wire \s_axi_rdata[4]_i_7_n_0 ;
  wire \s_axi_rdata[4]_i_8_n_0 ;
  wire \s_axi_rdata[4]_i_9_n_0 ;
  wire \s_axi_rdata[5]_i_1_n_0 ;
  wire \s_axi_rdata[5]_i_2_n_0 ;
  wire \s_axi_rdata[5]_i_3_n_0 ;
  wire \s_axi_rdata[5]_i_4_n_0 ;
  wire \s_axi_rdata[5]_i_5_n_0 ;
  wire \s_axi_rdata[5]_i_6_n_0 ;
  wire \s_axi_rdata[6]_i_1_n_0 ;
  wire \s_axi_rdata[6]_i_2_n_0 ;
  wire \s_axi_rdata[6]_i_3_n_0 ;
  wire \s_axi_rdata[6]_i_4_n_0 ;
  wire \s_axi_rdata[6]_i_5_n_0 ;
  wire \s_axi_rdata[6]_i_6_n_0 ;
  wire \s_axi_rdata[7]_i_1_n_0 ;
  wire \s_axi_rdata[7]_i_2_n_0 ;
  wire \s_axi_rdata[7]_i_3_n_0 ;
  wire \s_axi_rdata[7]_i_4_n_0 ;
  wire \s_axi_rdata[7]_i_5_n_0 ;
  wire \s_axi_rdata[8]_i_1_n_0 ;
  wire \s_axi_rdata[8]_i_2_n_0 ;
  wire \s_axi_rdata[8]_i_3_n_0 ;
  wire \s_axi_rdata[8]_i_4_n_0 ;
  wire \s_axi_rdata[8]_i_5_n_0 ;
  wire \s_axi_rdata[9]_i_1_n_0 ;
  wire \s_axi_rdata[9]_i_2_n_0 ;
  wire \s_axi_rdata[9]_i_3_n_0 ;
  wire \s_axi_rdata[9]_i_4_n_0 ;
  wire \s_axi_rdata[9]_i_5_n_0 ;
  wire s_axi_rready;
  wire [0:0]s_axi_rresp;
  wire \s_axi_rresp[1]_i_1_n_0 ;
  wire \s_axi_rresp[1]_i_2_n_0 ;
  wire \s_axi_rresp[1]_i_3_n_0 ;
  wire \s_axi_rresp[1]_i_4_n_0 ;
  wire \s_axi_rresp[1]_i_5_n_0 ;
  wire s_axi_rvalid_i_1_n_0;
  wire s_axi_rvalid_i_2_n_0;
  wire s_axi_rvalid_reg_0;
  wire [31:0]s_axi_wdata;
  wire s_axi_wready;
  wire [3:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire [3:0]strobes_held;
  wire w_held0;
  wire w_held_i_1_n_0;
  wire w_held_reg_n_0;

  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'hAAAAAAEA)) 
    abort_requested_i_1
       (.I0(abort_requested_reg_0),
        .I1(armed_reg_0),
        .I2(abort_requested2),
        .I3(armed_i_3_n_0),
        .I4(armed0),
        .O(abort_requested_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT4 #(
    .INIT(16'h0010)) 
    abort_requested_i_2
       (.I0(\configured[4]_i_2_n_0 ),
        .I1(data_held[2]),
        .I2(data_held[1]),
        .I3(abort_requested_i_3_n_0),
        .O(abort_requested2));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    abort_requested_i_3
       (.I0(abort_requested_i_4_n_0),
        .I1(data_held[13]),
        .I2(data_held[9]),
        .I3(data_held[14]),
        .I4(data_held[12]),
        .I5(abort_requested_i_5_n_0),
        .O(abort_requested_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    abort_requested_i_4
       (.I0(data_held[15]),
        .I1(data_held[11]),
        .I2(data_held[8]),
        .I3(data_held[10]),
        .O(abort_requested_i_4_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    abort_requested_i_5
       (.I0(data_held[4]),
        .I1(data_held[7]),
        .I2(data_held[5]),
        .I3(data_held[6]),
        .I4(data_held[0]),
        .I5(data_held[3]),
        .O(abort_requested_i_5_n_0));
  FDRE abort_requested_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(abort_requested_i_1_n_0),
        .Q(abort_requested_reg_0),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0002)) 
    \address_held[11]_i_1 
       (.I0(s_axi_awvalid),
        .I1(s_axi_bvalid_reg_0),
        .I2(owner_command_pending_reg_n_0),
        .I3(aw_held),
        .O(aw_held0));
  FDRE \address_held_reg[0] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[0]),
        .Q(\address_held_reg_n_0_[0] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \address_held_reg[10] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[10]),
        .Q(\address_held_reg_n_0_[10] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \address_held_reg[11] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[11]),
        .Q(\address_held_reg_n_0_[11] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \address_held_reg[1] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[1]),
        .Q(\address_held_reg_n_0_[1] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \address_held_reg[2] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[2]),
        .Q(p_0_in[0]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \address_held_reg[3] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[3]),
        .Q(p_0_in[1]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \address_held_reg[4] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[4]),
        .Q(\address_held_reg_n_0_[4] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \address_held_reg[5] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[5]),
        .Q(\address_held_reg_n_0_[5] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \address_held_reg[6] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[6]),
        .Q(\address_held_reg_n_0_[6] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \address_held_reg[7] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[7]),
        .Q(\address_held_reg_n_0_[7] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \address_held_reg[8] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[8]),
        .Q(\address_held_reg_n_0_[8] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \address_held_reg[9] 
       (.C(s_axi_aclk),
        .CE(aw_held0),
        .D(s_axi_awaddr[9]),
        .Q(\address_held_reg_n_0_[9] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hF2)) 
    armed_i_1
       (.I0(armed0),
        .I1(armed_i_3_n_0),
        .I2(armed_reg_0),
        .O(armed_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    armed_i_10
       (.I0(cfg_frame_context[129]),
        .I1(cfg_frame_context[130]),
        .I2(cfg_frame_context[128]),
        .I3(cfg_frame_context[131]),
        .I4(\s_axi_bresp[1]_i_22_n_0 ),
        .O(armed_i_10_n_0));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    armed_i_11
       (.I0(cfg_frame_context[138]),
        .I1(cfg_frame_context[139]),
        .I2(cfg_frame_context[136]),
        .I3(cfg_frame_context[137]),
        .I4(\s_axi_bresp[1]_i_20_n_0 ),
        .O(armed_i_11_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    armed_i_12
       (.I0(cfg_frame_context[69]),
        .I1(cfg_frame_context[68]),
        .I2(cfg_frame_context[71]),
        .I3(cfg_frame_context[70]),
        .O(armed_i_12_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    armed_i_13
       (.I0(cfg_frame_context[53]),
        .I1(cfg_frame_context[52]),
        .I2(cfg_frame_context[55]),
        .I3(cfg_frame_context[54]),
        .O(armed_i_13_n_0));
  LUT5 #(
    .INIT(32'h04040004)) 
    armed_i_2
       (.I0(armed_i_4_n_0),
        .I1(owner_cpu_claim_i_3_n_0),
        .I2(armed_i_5_n_0),
        .I3(armed_i_6_n_0),
        .I4(armed_i_7_n_0),
        .O(armed0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFDFFFF)) 
    armed_i_3
       (.I0(\s_axi_bresp[1]_i_5_n_0 ),
        .I1(\address_held_reg_n_0_[5] ),
        .I2(p_0_in[0]),
        .I3(p_0_in[1]),
        .I4(\address_held_reg_n_0_[4] ),
        .I5(\address_held_reg_n_0_[6] ),
        .O(armed_i_3_n_0));
  LUT6 #(
    .INIT(64'hDFFFFFFFFFFFFFFF)) 
    armed_i_4
       (.I0(\configured_reg_n_0_[0] ),
        .I1(armed_reg_0),
        .I2(\configured_reg_n_0_[2] ),
        .I3(\configured_reg_n_0_[1] ),
        .I4(\configured_reg_n_0_[4] ),
        .I5(\configured_reg_n_0_[3] ),
        .O(armed_i_4_n_0));
  LUT4 #(
    .INIT(16'h0004)) 
    armed_i_5
       (.I0(armed_i_8_n_0),
        .I1(armed_i_9_n_0),
        .I2(armed_i_10_n_0),
        .I3(armed_i_11_n_0),
        .O(armed_i_5_n_0));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    armed_i_6
       (.I0(armed_i_12_n_0),
        .I1(cfg_frame_context[67]),
        .I2(cfg_frame_context[66]),
        .I3(cfg_frame_context[65]),
        .I4(cfg_frame_context[64]),
        .I5(\s_axi_bresp[1]_i_15_n_0 ),
        .O(armed_i_6_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    armed_i_7
       (.I0(armed_i_13_n_0),
        .I1(cfg_frame_context[50]),
        .I2(cfg_frame_context[49]),
        .I3(cfg_frame_context[51]),
        .I4(cfg_frame_context[48]),
        .I5(\s_axi_bresp[1]_i_13_n_0 ),
        .O(armed_i_7_n_0));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    armed_i_8
       (.I0(cfg_frame_context[112]),
        .I1(cfg_frame_context[113]),
        .I2(cfg_frame_context[114]),
        .I3(cfg_frame_context[115]),
        .I4(\s_axi_bresp[1]_i_26_n_0 ),
        .O(armed_i_8_n_0));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    armed_i_9
       (.I0(cfg_frame_context[121]),
        .I1(cfg_frame_context[122]),
        .I2(cfg_frame_context[120]),
        .I3(cfg_frame_context[123]),
        .I4(\s_axi_bresp[1]_i_24_n_0 ),
        .O(armed_i_9_n_0));
  FDRE armed_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(armed_i_1_n_0),
        .Q(armed_reg_0),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0000020F0F00020)) 
    aw_held_i_1
       (.I0(s_axi_awvalid),
        .I1(owner_command_pending_reg_n_0),
        .I2(s_axi_aresetn),
        .I3(s_axi_bvalid_reg_0),
        .I4(aw_held),
        .I5(w_held_reg_n_0),
        .O(aw_held_i_1_n_0));
  FDRE aw_held_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(aw_held_i_1_n_0),
        .Q(aw_held),
        .R(1'b0));
  LUT4 #(
    .INIT(16'hFF02)) 
    barrier_request_i_1
       (.I0(barrier_request0),
        .I1(armed_i_3_n_0),
        .I2(armed0),
        .I3(barrier_request_reg_0),
        .O(barrier_request_i_1_n_0));
  LUT6 #(
    .INIT(64'h0000000001000000)) 
    barrier_request_i_2
       (.I0(\configured[4]_i_2_n_0 ),
        .I1(barrier_request_reg_0),
        .I2(data_held[1]),
        .I3(data_held[2]),
        .I4(armed_reg_0),
        .I5(abort_requested_i_3_n_0),
        .O(barrier_request0));
  FDRE barrier_request_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(barrier_request_i_1_n_0),
        .Q(barrier_request_reg_0),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    capture_aresetn_i_1
       (.I0(armed_reg_0),
        .I1(s_axi_aresetn),
        .O(capture_aresetn0));
  LUT1 #(
    .INIT(2'h1)) 
    capture_aresetn_i_2
       (.I0(common_aresetn),
        .O(capture_aresetn_i_2_n_0));
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 capture_aresetn RST" *) 
  (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *) 
  FDCE capture_aresetn_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .CLR(capture_aresetn_i_2_n_0),
        .D(capture_aresetn0),
        .Q(capture_aresetn));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[0]_i_1 
       (.I0(data_held[0]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[0]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[10]_i_1 
       (.I0(data_held[10]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[10]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[11]_i_1 
       (.I0(data_held[11]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[11]));
  LUT6 #(
    .INIT(64'h0000000400000000)) 
    \cfg_frame_context[127]_i_1 
       (.I0(\cfg_frame_context[127]_i_2_n_0 ),
        .I1(p_0_in[1]),
        .I2(\cfg_frame_context[127]_i_3_n_0 ),
        .I3(\address_held_reg_n_0_[0] ),
        .I4(\address_held_reg_n_0_[1] ),
        .I5(p_0_in[0]),
        .O(\cfg_frame_context[127]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBFFFFFFFFFFFFFFF)) 
    \cfg_frame_context[127]_i_2 
       (.I0(owner_cpu_claim_i_5_n_0),
        .I1(strobes_held[1]),
        .I2(strobes_held[3]),
        .I3(strobes_held[0]),
        .I4(strobes_held[2]),
        .I5(s_axi_bvalid_i_4_n_0),
        .O(\cfg_frame_context[127]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT4 #(
    .INIT(16'hFFFD)) 
    \cfg_frame_context[127]_i_3 
       (.I0(\address_held_reg_n_0_[5] ),
        .I1(\address_held_reg_n_0_[6] ),
        .I2(\address_held_reg_n_0_[4] ),
        .I3(armed_reg_0),
        .O(\cfg_frame_context[127]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[128]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[0]),
        .O(p_2_in[128]));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[129]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[1]),
        .O(p_2_in[129]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[12]_i_1 
       (.I0(data_held[12]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[12]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[130]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[2]),
        .O(p_2_in[130]));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[131]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[3]),
        .O(p_2_in[131]));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[132]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[4]),
        .O(p_2_in[132]));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[133]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[5]),
        .O(p_2_in[133]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[134]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[6]),
        .O(p_2_in[134]));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[135]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[7]),
        .O(p_2_in[135]));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[136]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[8]),
        .O(p_2_in[136]));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[137]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[9]),
        .O(p_2_in[137]));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[138]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[10]),
        .O(p_2_in[138]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[139]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[11]),
        .O(p_2_in[139]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[13]_i_1 
       (.I0(data_held[13]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[13]));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[140]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[12]),
        .O(p_2_in[140]));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[141]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[13]),
        .O(p_2_in[141]));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[142]_i_1 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[14]),
        .O(p_2_in[142]));
  LUT3 #(
    .INIT(8'h80)) 
    \cfg_frame_context[143]_i_1 
       (.I0(\cfg_frame_context[143]_i_3_n_0 ),
        .I1(\s_axi_bresp[1]_i_5_n_0 ),
        .I2(\address_held_reg_n_0_[5] ),
        .O(\cfg_frame_context[143]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cfg_frame_context[143]_i_2 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(data_held[15]),
        .O(p_2_in[143]));
  LUT6 #(
    .INIT(64'h0000000000000004)) 
    \cfg_frame_context[143]_i_3 
       (.I0(\address_held_reg_n_0_[6] ),
        .I1(\address_held_reg_n_0_[4] ),
        .I2(p_0_in[1]),
        .I3(p_0_in[0]),
        .I4(\configured[4]_i_2_n_0 ),
        .I5(armed_reg_0),
        .O(\cfg_frame_context[143]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[14]_i_1 
       (.I0(data_held[14]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[14]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[15]_i_1 
       (.I0(data_held[15]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[15]));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[16]_i_1 
       (.I0(data_held[16]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[16]));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[17]_i_1 
       (.I0(data_held[17]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[17]));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[18]_i_1 
       (.I0(data_held[18]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[18]));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[19]_i_1 
       (.I0(data_held[19]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[19]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[1]_i_1 
       (.I0(data_held[1]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[1]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[20]_i_1 
       (.I0(data_held[20]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[20]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[21]_i_1 
       (.I0(data_held[21]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[21]));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[22]_i_1 
       (.I0(data_held[22]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[22]));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[23]_i_1 
       (.I0(data_held[23]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[23]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[24]_i_1 
       (.I0(data_held[24]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[24]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[25]_i_1 
       (.I0(data_held[25]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[25]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[26]_i_1 
       (.I0(data_held[26]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[26]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[27]_i_1 
       (.I0(data_held[27]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[27]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[28]_i_1 
       (.I0(data_held[28]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[28]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[29]_i_1 
       (.I0(data_held[29]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[29]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[2]_i_1 
       (.I0(data_held[2]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[2]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[30]_i_1 
       (.I0(data_held[30]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[30]));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    \cfg_frame_context[31]_i_1 
       (.I0(\s_axi_bresp[1]_i_5_n_0 ),
        .I1(\address_held_reg_n_0_[5] ),
        .I2(\address_held_reg_n_0_[6] ),
        .I3(\address_held_reg_n_0_[4] ),
        .I4(armed_reg_0),
        .I5(\cfg_frame_context[31]_i_3_n_0 ),
        .O(\cfg_frame_context[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[31]_i_2 
       (.I0(data_held[31]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[31]));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \cfg_frame_context[31]_i_3 
       (.I0(p_0_in[1]),
        .I1(p_0_in[0]),
        .O(\cfg_frame_context[31]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[3]_i_1 
       (.I0(data_held[3]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[3]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[4]_i_1 
       (.I0(data_held[4]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[4]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[5]_i_1 
       (.I0(data_held[5]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[5]));
  LUT6 #(
    .INIT(64'h0000000000010000)) 
    \cfg_frame_context[63]_i_1 
       (.I0(\cfg_frame_context[127]_i_2_n_0 ),
        .I1(\cfg_frame_context[127]_i_3_n_0 ),
        .I2(\address_held_reg_n_0_[0] ),
        .I3(\address_held_reg_n_0_[1] ),
        .I4(p_0_in[0]),
        .I5(p_0_in[1]),
        .O(\cfg_frame_context[63]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[64]_i_1 
       (.I0(data_held[0]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[64]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[65]_i_1 
       (.I0(data_held[1]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[65]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[66]_i_1 
       (.I0(data_held[2]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[66]));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[67]_i_1 
       (.I0(data_held[3]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[67]));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[68]_i_1 
       (.I0(data_held[4]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[68]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[69]_i_1 
       (.I0(data_held[5]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[69]));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[6]_i_1 
       (.I0(data_held[6]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[6]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[70]_i_1 
       (.I0(data_held[6]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[70]));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[71]_i_1 
       (.I0(data_held[7]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[71]));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[72]_i_1 
       (.I0(data_held[8]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[72]));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[73]_i_1 
       (.I0(data_held[9]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[73]));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[74]_i_1 
       (.I0(data_held[10]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[74]));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[75]_i_1 
       (.I0(data_held[11]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[75]));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[76]_i_1 
       (.I0(data_held[12]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[76]));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[77]_i_1 
       (.I0(data_held[13]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[77]));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[78]_i_1 
       (.I0(data_held[14]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[78]));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[79]_i_1 
       (.I0(data_held[15]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[79]));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[7]_i_1 
       (.I0(data_held[7]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[7]));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[80]_i_1 
       (.I0(data_held[16]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[80]));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[81]_i_1 
       (.I0(data_held[17]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[81]));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[82]_i_1 
       (.I0(data_held[18]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[82]));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[83]_i_1 
       (.I0(data_held[19]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[83]));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[84]_i_1 
       (.I0(data_held[20]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[84]));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[85]_i_1 
       (.I0(data_held[21]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[85]));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[86]_i_1 
       (.I0(data_held[22]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[86]));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[87]_i_1 
       (.I0(data_held[23]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[87]));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[88]_i_1 
       (.I0(data_held[24]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[88]));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[89]_i_1 
       (.I0(data_held[25]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[89]));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[8]_i_1 
       (.I0(data_held[8]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[8]));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[90]_i_1 
       (.I0(data_held[26]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[90]));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[91]_i_1 
       (.I0(data_held[27]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[91]));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[92]_i_1 
       (.I0(data_held[28]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[92]));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[93]_i_1 
       (.I0(data_held[29]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[93]));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[94]_i_1 
       (.I0(data_held[30]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[94]));
  LUT6 #(
    .INIT(64'h0000000000000020)) 
    \cfg_frame_context[95]_i_1 
       (.I0(\s_axi_bresp[1]_i_5_n_0 ),
        .I1(\cfg_frame_context[95]_i_3_n_0 ),
        .I2(\address_held_reg_n_0_[5] ),
        .I3(\address_held_reg_n_0_[6] ),
        .I4(\address_held_reg_n_0_[4] ),
        .I5(armed_reg_0),
        .O(\cfg_frame_context[95]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cfg_frame_context[95]_i_2 
       (.I0(data_held[31]),
        .I1(p_0_in[1]),
        .I2(p_0_in[0]),
        .O(cfg_frame_context0[95]));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \cfg_frame_context[95]_i_3 
       (.I0(p_0_in[0]),
        .I1(p_0_in[1]),
        .O(\cfg_frame_context[95]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \cfg_frame_context[9]_i_1 
       (.I0(data_held[9]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(cfg_frame_context0[9]));
  FDRE \cfg_frame_context_reg[0] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[0]),
        .Q(cfg_frame_context[0]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[100] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[4]),
        .Q(cfg_frame_context[100]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[101] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[5]),
        .Q(cfg_frame_context[101]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[102] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[6]),
        .Q(cfg_frame_context[102]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[103] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[7]),
        .Q(cfg_frame_context[103]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[104] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[8]),
        .Q(cfg_frame_context[104]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[105] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[9]),
        .Q(cfg_frame_context[105]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[106] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[10]),
        .Q(cfg_frame_context[106]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[107] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[11]),
        .Q(cfg_frame_context[107]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[108] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[12]),
        .Q(cfg_frame_context[108]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[109] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[13]),
        .Q(cfg_frame_context[109]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[10] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[10]),
        .Q(cfg_frame_context[10]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[110] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[14]),
        .Q(cfg_frame_context[110]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[111] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[15]),
        .Q(cfg_frame_context[111]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[112] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[16]),
        .Q(cfg_frame_context[112]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[113] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[17]),
        .Q(cfg_frame_context[113]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[114] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[18]),
        .Q(cfg_frame_context[114]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[115] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[19]),
        .Q(cfg_frame_context[115]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[116] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[20]),
        .Q(cfg_frame_context[116]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[117] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[21]),
        .Q(cfg_frame_context[117]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[118] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[22]),
        .Q(cfg_frame_context[118]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[119] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[23]),
        .Q(cfg_frame_context[119]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[11] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[11]),
        .Q(cfg_frame_context[11]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[120] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[24]),
        .Q(cfg_frame_context[120]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[121] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[25]),
        .Q(cfg_frame_context[121]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[122] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[26]),
        .Q(cfg_frame_context[122]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[123] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[27]),
        .Q(cfg_frame_context[123]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[124] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[28]),
        .Q(cfg_frame_context[124]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[125] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[29]),
        .Q(cfg_frame_context[125]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[126] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[30]),
        .Q(cfg_frame_context[126]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[127] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[31]),
        .Q(cfg_frame_context[127]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[128] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[128]),
        .Q(cfg_frame_context[128]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[129] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[129]),
        .Q(cfg_frame_context[129]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[12] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[12]),
        .Q(cfg_frame_context[12]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[130] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[130]),
        .Q(cfg_frame_context[130]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[131] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[131]),
        .Q(cfg_frame_context[131]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[132] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[132]),
        .Q(cfg_frame_context[132]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[133] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[133]),
        .Q(cfg_frame_context[133]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[134] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[134]),
        .Q(cfg_frame_context[134]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[135] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[135]),
        .Q(cfg_frame_context[135]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[136] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[136]),
        .Q(cfg_frame_context[136]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[137] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[137]),
        .Q(cfg_frame_context[137]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[138] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[138]),
        .Q(cfg_frame_context[138]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[139] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[139]),
        .Q(cfg_frame_context[139]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[13] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[13]),
        .Q(cfg_frame_context[13]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[140] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[140]),
        .Q(cfg_frame_context[140]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[141] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[141]),
        .Q(cfg_frame_context[141]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[142] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[142]),
        .Q(cfg_frame_context[142]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[143] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(p_2_in[143]),
        .Q(cfg_frame_context[143]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[14] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[14]),
        .Q(cfg_frame_context[14]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[15] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[15]),
        .Q(cfg_frame_context[15]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[16] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[16]),
        .Q(cfg_frame_context[16]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[17] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[17]),
        .Q(cfg_frame_context[17]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[18] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[18]),
        .Q(cfg_frame_context[18]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[19] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[19]),
        .Q(cfg_frame_context[19]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[1] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[1]),
        .Q(cfg_frame_context[1]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[20] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[20]),
        .Q(cfg_frame_context[20]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[21] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[21]),
        .Q(cfg_frame_context[21]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[22] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[22]),
        .Q(cfg_frame_context[22]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[23] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[23]),
        .Q(cfg_frame_context[23]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[24] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[24]),
        .Q(cfg_frame_context[24]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[25] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[25]),
        .Q(cfg_frame_context[25]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[26] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[26]),
        .Q(cfg_frame_context[26]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[27] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[27]),
        .Q(cfg_frame_context[27]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[28] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[28]),
        .Q(cfg_frame_context[28]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[29] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[29]),
        .Q(cfg_frame_context[29]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[2] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[2]),
        .Q(cfg_frame_context[2]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[30] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[30]),
        .Q(cfg_frame_context[30]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[31] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[31]),
        .Q(cfg_frame_context[31]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[32] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[0]),
        .Q(cfg_frame_context[32]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[33] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[1]),
        .Q(cfg_frame_context[33]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[34] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[2]),
        .Q(cfg_frame_context[34]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[35] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[3]),
        .Q(cfg_frame_context[35]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[36] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[4]),
        .Q(cfg_frame_context[36]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[37] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[5]),
        .Q(cfg_frame_context[37]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[38] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[6]),
        .Q(cfg_frame_context[38]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[39] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[7]),
        .Q(cfg_frame_context[39]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[3] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[3]),
        .Q(cfg_frame_context[3]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[40] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[8]),
        .Q(cfg_frame_context[40]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[41] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[9]),
        .Q(cfg_frame_context[41]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[42] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[10]),
        .Q(cfg_frame_context[42]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[43] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[11]),
        .Q(cfg_frame_context[43]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[44] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[12]),
        .Q(cfg_frame_context[44]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[45] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[13]),
        .Q(cfg_frame_context[45]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[46] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[14]),
        .Q(cfg_frame_context[46]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[47] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[15]),
        .Q(cfg_frame_context[47]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[48] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[16]),
        .Q(cfg_frame_context[48]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[49] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[17]),
        .Q(cfg_frame_context[49]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[4] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[4]),
        .Q(cfg_frame_context[4]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[50] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[18]),
        .Q(cfg_frame_context[50]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[51] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[19]),
        .Q(cfg_frame_context[51]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[52] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[20]),
        .Q(cfg_frame_context[52]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[53] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[21]),
        .Q(cfg_frame_context[53]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[54] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[22]),
        .Q(cfg_frame_context[54]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[55] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[23]),
        .Q(cfg_frame_context[55]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[56] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[24]),
        .Q(cfg_frame_context[56]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[57] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[25]),
        .Q(cfg_frame_context[57]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[58] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[26]),
        .Q(cfg_frame_context[58]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[59] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[27]),
        .Q(cfg_frame_context[59]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[5] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[5]),
        .Q(cfg_frame_context[5]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[60] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[28]),
        .Q(cfg_frame_context[60]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[61] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[29]),
        .Q(cfg_frame_context[61]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[62] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[30]),
        .Q(cfg_frame_context[62]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[63] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[63]_i_1_n_0 ),
        .D(data_held[31]),
        .Q(cfg_frame_context[63]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[64] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[64]),
        .Q(cfg_frame_context[64]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[65] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[65]),
        .Q(cfg_frame_context[65]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[66] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[66]),
        .Q(cfg_frame_context[66]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[67] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[67]),
        .Q(cfg_frame_context[67]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[68] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[68]),
        .Q(cfg_frame_context[68]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[69] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[69]),
        .Q(cfg_frame_context[69]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[6] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[6]),
        .Q(cfg_frame_context[6]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[70] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[70]),
        .Q(cfg_frame_context[70]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[71] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[71]),
        .Q(cfg_frame_context[71]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[72] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[72]),
        .Q(cfg_frame_context[72]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[73] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[73]),
        .Q(cfg_frame_context[73]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[74] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[74]),
        .Q(cfg_frame_context[74]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[75] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[75]),
        .Q(cfg_frame_context[75]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[76] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[76]),
        .Q(cfg_frame_context[76]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[77] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[77]),
        .Q(cfg_frame_context[77]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[78] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[78]),
        .Q(cfg_frame_context[78]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[79] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[79]),
        .Q(cfg_frame_context[79]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[7] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[7]),
        .Q(cfg_frame_context[7]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[80] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[80]),
        .Q(cfg_frame_context[80]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[81] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[81]),
        .Q(cfg_frame_context[81]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[82] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[82]),
        .Q(cfg_frame_context[82]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[83] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[83]),
        .Q(cfg_frame_context[83]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[84] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[84]),
        .Q(cfg_frame_context[84]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[85] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[85]),
        .Q(cfg_frame_context[85]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[86] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[86]),
        .Q(cfg_frame_context[86]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[87] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[87]),
        .Q(cfg_frame_context[87]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[88] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[88]),
        .Q(cfg_frame_context[88]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[89] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[89]),
        .Q(cfg_frame_context[89]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[8] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[8]),
        .Q(cfg_frame_context[8]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[90] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[90]),
        .Q(cfg_frame_context[90]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[91] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[91]),
        .Q(cfg_frame_context[91]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[92] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[92]),
        .Q(cfg_frame_context[92]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[93] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[93]),
        .Q(cfg_frame_context[93]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[94] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[94]),
        .Q(cfg_frame_context[94]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[95] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[95]_i_1_n_0 ),
        .D(cfg_frame_context0[95]),
        .Q(cfg_frame_context[95]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[96] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[0]),
        .Q(cfg_frame_context[96]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[97] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[1]),
        .Q(cfg_frame_context[97]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[98] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[2]),
        .Q(cfg_frame_context[98]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[99] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[127]_i_1_n_0 ),
        .D(data_held[3]),
        .Q(cfg_frame_context[99]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \cfg_frame_context_reg[9] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[31]_i_1_n_0 ),
        .D(cfg_frame_context0[9]),
        .Q(cfg_frame_context[9]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \configured[0]_i_1 
       (.I0(\cfg_frame_context[31]_i_1_n_0 ),
        .I1(\configured_reg_n_0_[0] ),
        .O(\configured[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \configured[1]_i_1 
       (.I0(\cfg_frame_context[63]_i_1_n_0 ),
        .I1(\configured_reg_n_0_[1] ),
        .O(\configured[1]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \configured[2]_i_1 
       (.I0(\cfg_frame_context[95]_i_1_n_0 ),
        .I1(\configured_reg_n_0_[2] ),
        .O(\configured[2]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \configured[3]_i_1 
       (.I0(\cfg_frame_context[127]_i_1_n_0 ),
        .I1(\configured_reg_n_0_[3] ),
        .O(\configured[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'hFF1F)) 
    \configured[4]_i_1 
       (.I0(armed_reg_0),
        .I1(\configured[4]_i_2_n_0 ),
        .I2(\address_held_reg_n_0_[4] ),
        .I3(p_0_in[1]),
        .O(\configured[4]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \configured[4]_i_2 
       (.I0(\configured[4]_i_3_n_0 ),
        .I1(\configured[4]_i_4_n_0 ),
        .I2(\configured[4]_i_5_n_0 ),
        .I3(\configured[4]_i_6_n_0 ),
        .O(\configured[4]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \configured[4]_i_3 
       (.I0(data_held[19]),
        .I1(data_held[20]),
        .I2(data_held[28]),
        .I3(data_held[27]),
        .O(\configured[4]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \configured[4]_i_4 
       (.I0(data_held[31]),
        .I1(data_held[26]),
        .I2(data_held[30]),
        .I3(data_held[24]),
        .O(\configured[4]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \configured[4]_i_5 
       (.I0(data_held[22]),
        .I1(data_held[23]),
        .I2(data_held[25]),
        .I3(data_held[16]),
        .O(\configured[4]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \configured[4]_i_6 
       (.I0(data_held[18]),
        .I1(data_held[21]),
        .I2(data_held[29]),
        .I3(data_held[17]),
        .O(\configured[4]_i_6_n_0 ));
  FDRE \configured_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\configured[0]_i_1_n_0 ),
        .Q(\configured_reg_n_0_[0] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \configured_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\configured[1]_i_1_n_0 ),
        .Q(\configured_reg_n_0_[1] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \configured_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\configured[2]_i_1_n_0 ),
        .Q(\configured_reg_n_0_[2] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \configured_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\configured[3]_i_1_n_0 ),
        .Q(\configured_reg_n_0_[3] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \configured_reg[4] 
       (.C(s_axi_aclk),
        .CE(\cfg_frame_context[143]_i_1_n_0 ),
        .D(\configured[4]_i_1_n_0 ),
        .Q(\configured_reg_n_0_[4] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0002)) 
    \data_held[31]_i_1 
       (.I0(s_axi_wvalid),
        .I1(s_axi_bvalid_reg_0),
        .I2(owner_command_pending_reg_n_0),
        .I3(w_held_reg_n_0),
        .O(w_held0));
  FDRE \data_held_reg[0] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[0]),
        .Q(data_held[0]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[10] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[10]),
        .Q(data_held[10]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[11] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[11]),
        .Q(data_held[11]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[12] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[12]),
        .Q(data_held[12]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[13] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[13]),
        .Q(data_held[13]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[14] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[14]),
        .Q(data_held[14]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[15] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[15]),
        .Q(data_held[15]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[16] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[16]),
        .Q(data_held[16]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[17] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[17]),
        .Q(data_held[17]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[18] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[18]),
        .Q(data_held[18]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[19] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[19]),
        .Q(data_held[19]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[1] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[1]),
        .Q(data_held[1]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[20] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[20]),
        .Q(data_held[20]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[21] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[21]),
        .Q(data_held[21]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[22] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[22]),
        .Q(data_held[22]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[23] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[23]),
        .Q(data_held[23]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[24] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[24]),
        .Q(data_held[24]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[25] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[25]),
        .Q(data_held[25]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[26] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[26]),
        .Q(data_held[26]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[27] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[27]),
        .Q(data_held[27]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[28] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[28]),
        .Q(data_held[28]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[29] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[29]),
        .Q(data_held[29]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[2] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[2]),
        .Q(data_held[2]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[30] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[30]),
        .Q(data_held[30]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[31] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[31]),
        .Q(data_held[31]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[3] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[3]),
        .Q(data_held[3]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[4] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[4]),
        .Q(data_held[4]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[5] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[5]),
        .Q(data_held[5]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[6] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[6]),
        .Q(data_held[6]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[7] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[7]),
        .Q(data_held[7]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[8] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[8]),
        .Q(data_held[8]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \data_held_reg[9] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wdata[9]),
        .Q(data_held[9]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF44404040)) 
    owner_command_fault_i_1
       (.I0(owner_command_fault_i_2_n_0),
        .I1(owner_command_pending_reg_n_0),
        .I2(owner_fault),
        .I3(\owner_command_wait_reg_n_0_[1] ),
        .I4(\owner_command_wait_reg_n_0_[0] ),
        .I5(owner_command_fault_reg_0),
        .O(owner_command_fault_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h00E2)) 
    owner_command_fault_i_2
       (.I0(owner_claim_accepted),
        .I1(owner_command_is_release_reg_n_0),
        .I2(owner_release_accepted),
        .I3(owner_fault),
        .O(owner_command_fault_i_2_n_0));
  FDRE owner_command_fault_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(owner_command_fault_i_1_n_0),
        .Q(owner_command_fault_reg_0),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    owner_command_is_release_i_1
       (.I0(abort_requested2),
        .I1(owner_command_pending18_out),
        .I2(owner_command_is_release_reg_n_0),
        .O(owner_command_is_release_i_1_n_0));
  FDRE owner_command_is_release_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(owner_command_is_release_i_1_n_0),
        .Q(owner_command_is_release_reg_n_0),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hBA88)) 
    owner_command_pending_i_1
       (.I0(owner_command_pending18_out),
        .I1(\owner_command_wait[1]_i_2_n_0 ),
        .I2(s_axi_bvalid_i_3_n_0),
        .I3(owner_command_pending_reg_n_0),
        .O(owner_command_pending_i_1_n_0));
  FDRE owner_command_pending_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(owner_command_pending_i_1_n_0),
        .Q(owner_command_pending_reg_n_0),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FF00FD22)) 
    \owner_command_wait[0]_i_1 
       (.I0(owner_command_pending_reg_n_0),
        .I1(owner_fault),
        .I2(\owner_command_wait_reg_n_0_[1] ),
        .I3(\owner_command_wait_reg_n_0_[0] ),
        .I4(owner_command_fault_i_2_n_0),
        .I5(\owner_command_wait[1]_i_2_n_0 ),
        .O(\owner_command_wait[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000F0F0F2F0)) 
    \owner_command_wait[1]_i_1 
       (.I0(owner_command_pending_reg_n_0),
        .I1(owner_fault),
        .I2(\owner_command_wait_reg_n_0_[1] ),
        .I3(\owner_command_wait_reg_n_0_[0] ),
        .I4(owner_command_fault_i_2_n_0),
        .I5(\owner_command_wait[1]_i_2_n_0 ),
        .O(\owner_command_wait[1]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0054)) 
    \owner_command_wait[1]_i_2 
       (.I0(owner_cpu_claim_i_2_n_0),
        .I1(abort_requested2),
        .I2(owner_cpu_claim_i_3_n_0),
        .I3(\owner_command_wait[1]_i_3_n_0 ),
        .O(\owner_command_wait[1]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hEFEEEFEF)) 
    \owner_command_wait[1]_i_3 
       (.I0(\cfg_frame_context[127]_i_2_n_0 ),
        .I1(\owner_command_wait[1]_i_4_n_0 ),
        .I2(\address_held_reg_n_0_[0] ),
        .I3(\address_held_reg_n_0_[4] ),
        .I4(\address_held_reg_n_0_[6] ),
        .O(\owner_command_wait[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFEFFFFFFFF)) 
    \owner_command_wait[1]_i_4 
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(\address_held_reg_n_0_[0] ),
        .I2(\address_held_reg_n_0_[1] ),
        .I3(\address_held_reg_n_0_[5] ),
        .I4(p_0_in[0]),
        .I5(p_0_in[1]),
        .O(\owner_command_wait[1]_i_4_n_0 ));
  FDRE \owner_command_wait_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\owner_command_wait[0]_i_1_n_0 ),
        .Q(\owner_command_wait_reg_n_0_[0] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_command_wait_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\owner_command_wait[1]_i_1_n_0 ),
        .Q(\owner_command_wait_reg_n_0_[1] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00000004)) 
    owner_cpu_claim_i_1
       (.I0(owner_cpu_claim_i_2_n_0),
        .I1(owner_cpu_claim_i_3_n_0),
        .I2(owner_cpu_claim_i_4_n_0),
        .I3(owner_cpu_claim_i_5_n_0),
        .I4(owner_cpu_claim_i_6_n_0),
        .O(owner_cpu_claim_i_1_n_0));
  LUT6 #(
    .INIT(64'hFDFFFFFFFFFFFFFF)) 
    owner_cpu_claim_i_2
       (.I0(armed_reg_0),
        .I1(owner_command_fault_reg_0),
        .I2(owner_fault),
        .I3(p_0_in[1]),
        .I4(\owner_token_configured_reg_n_0_[1] ),
        .I5(\owner_token_configured_reg_n_0_[0] ),
        .O(owner_cpu_claim_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h01)) 
    owner_cpu_claim_i_3
       (.I0(\configured[4]_i_2_n_0 ),
        .I1(owner_cpu_claim_i_7_n_0),
        .I2(owner_cpu_claim_i_8_n_0),
        .O(owner_cpu_claim_i_3_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFB)) 
    owner_cpu_claim_i_4
       (.I0(\address_held_reg_n_0_[4] ),
        .I1(\address_held_reg_n_0_[6] ),
        .I2(\address_held_reg_n_0_[0] ),
        .I3(\address_held_reg_n_0_[1] ),
        .I4(p_0_in[0]),
        .I5(\address_held_reg_n_0_[5] ),
        .O(owner_cpu_claim_i_4_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    owner_cpu_claim_i_5
       (.I0(\address_held_reg_n_0_[7] ),
        .I1(\address_held_reg_n_0_[8] ),
        .I2(\address_held_reg_n_0_[11] ),
        .I3(\address_held_reg_n_0_[9] ),
        .I4(\address_held_reg_n_0_[10] ),
        .O(owner_cpu_claim_i_5_n_0));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    owner_cpu_claim_i_6
       (.I0(strobes_held[1]),
        .I1(strobes_held[3]),
        .I2(strobes_held[0]),
        .I3(strobes_held[2]),
        .I4(s_axi_bvalid_i_4_n_0),
        .I5(s_axi_aresetn),
        .O(owner_cpu_claim_i_6_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFEF)) 
    owner_cpu_claim_i_7
       (.I0(owner_cpu_claim_i_9_n_0),
        .I1(data_held[1]),
        .I2(data_held[0]),
        .I3(data_held[3]),
        .I4(data_held[2]),
        .O(owner_cpu_claim_i_7_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    owner_cpu_claim_i_8
       (.I0(data_held[12]),
        .I1(data_held[14]),
        .I2(data_held[9]),
        .I3(data_held[13]),
        .I4(abort_requested_i_4_n_0),
        .O(owner_cpu_claim_i_8_n_0));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    owner_cpu_claim_i_9
       (.I0(data_held[6]),
        .I1(data_held[5]),
        .I2(data_held[7]),
        .I3(data_held[4]),
        .O(owner_cpu_claim_i_9_n_0));
  FDRE owner_cpu_claim_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(owner_cpu_claim_i_1_n_0),
        .Q(owner_cpu_claim),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \owner_cpu_epoch[31]_i_1 
       (.I0(\owner_cpu_epoch[31]_i_2_n_0 ),
        .I1(\owner_cpu_epoch[31]_i_3_n_0 ),
        .I2(\address_held_reg_n_0_[10] ),
        .I3(\address_held_reg_n_0_[9] ),
        .I4(\address_held_reg_n_0_[11] ),
        .I5(\address_held_reg_n_0_[8] ),
        .O(\owner_cpu_epoch[31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFEFFFFFFFFFF)) 
    \owner_cpu_epoch[31]_i_2 
       (.I0(\address_held_reg_n_0_[5] ),
        .I1(p_0_in[1]),
        .I2(\address_held_reg_n_0_[4] ),
        .I3(\address_held_reg_n_0_[6] ),
        .I4(\owner_token_configured[1]_i_3_n_0 ),
        .I5(\s_axi_bresp[1]_i_5_n_0 ),
        .O(\owner_cpu_epoch[31]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \owner_cpu_epoch[31]_i_3 
       (.I0(\address_held_reg_n_0_[5] ),
        .I1(\address_held_reg_n_0_[7] ),
        .I2(\address_held_reg_n_0_[4] ),
        .I3(\address_held_reg_n_0_[0] ),
        .I4(\cfg_frame_context[31]_i_3_n_0 ),
        .I5(\owner_cpu_epoch[31]_i_4_n_0 ),
        .O(\owner_cpu_epoch[31]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \owner_cpu_epoch[31]_i_4 
       (.I0(\address_held_reg_n_0_[1] ),
        .I1(\address_held_reg_n_0_[6] ),
        .O(\owner_cpu_epoch[31]_i_4_n_0 ));
  FDRE \owner_cpu_epoch_reg[0] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[0]),
        .Q(owner_cpu_epoch[0]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[10] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[10]),
        .Q(owner_cpu_epoch[10]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[11] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[11]),
        .Q(owner_cpu_epoch[11]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[12] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[12]),
        .Q(owner_cpu_epoch[12]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[13] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[13]),
        .Q(owner_cpu_epoch[13]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[14] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[14]),
        .Q(owner_cpu_epoch[14]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[15] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[15]),
        .Q(owner_cpu_epoch[15]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[16] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[16]),
        .Q(owner_cpu_epoch[16]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[17] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[17]),
        .Q(owner_cpu_epoch[17]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[18] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[18]),
        .Q(owner_cpu_epoch[18]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[19] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[19]),
        .Q(owner_cpu_epoch[19]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[1] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[1]),
        .Q(owner_cpu_epoch[1]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[20] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[20]),
        .Q(owner_cpu_epoch[20]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[21] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[21]),
        .Q(owner_cpu_epoch[21]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[22] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[22]),
        .Q(owner_cpu_epoch[22]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[23] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[23]),
        .Q(owner_cpu_epoch[23]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[24] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[24]),
        .Q(owner_cpu_epoch[24]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[25] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[25]),
        .Q(owner_cpu_epoch[25]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[26] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[26]),
        .Q(owner_cpu_epoch[26]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[27] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[27]),
        .Q(owner_cpu_epoch[27]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[28] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[28]),
        .Q(owner_cpu_epoch[28]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[29] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[29]),
        .Q(owner_cpu_epoch[29]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[2] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[2]),
        .Q(owner_cpu_epoch[2]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[30] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[30]),
        .Q(owner_cpu_epoch[30]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[31] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[31]),
        .Q(owner_cpu_epoch[31]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[3] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[3]),
        .Q(owner_cpu_epoch[3]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[4] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[4]),
        .Q(owner_cpu_epoch[4]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[5] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[5]),
        .Q(owner_cpu_epoch[5]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[6] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[6]),
        .Q(owner_cpu_epoch[6]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[7] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[7]),
        .Q(owner_cpu_epoch[7]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[8] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[8]),
        .Q(owner_cpu_epoch[8]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_epoch_reg[9] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_epoch[31]_i_1_n_0 ),
        .D(data_held[9]),
        .Q(owner_cpu_epoch[9]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \owner_cpu_frame_id[31]_i_1 
       (.I0(p_0_in[0]),
        .I1(\owner_cpu_epoch[31]_i_2_n_0 ),
        .O(\owner_cpu_frame_id[31]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[0] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[0]),
        .Q(owner_cpu_frame_id[0]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[10] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[10]),
        .Q(owner_cpu_frame_id[10]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[11] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[11]),
        .Q(owner_cpu_frame_id[11]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[12] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[12]),
        .Q(owner_cpu_frame_id[12]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[13] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[13]),
        .Q(owner_cpu_frame_id[13]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[14] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[14]),
        .Q(owner_cpu_frame_id[14]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[15] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[15]),
        .Q(owner_cpu_frame_id[15]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[16] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[16]),
        .Q(owner_cpu_frame_id[16]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[17] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[17]),
        .Q(owner_cpu_frame_id[17]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[18] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[18]),
        .Q(owner_cpu_frame_id[18]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[19] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[19]),
        .Q(owner_cpu_frame_id[19]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[1] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[1]),
        .Q(owner_cpu_frame_id[1]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[20] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[20]),
        .Q(owner_cpu_frame_id[20]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[21] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[21]),
        .Q(owner_cpu_frame_id[21]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[22] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[22]),
        .Q(owner_cpu_frame_id[22]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[23] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[23]),
        .Q(owner_cpu_frame_id[23]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[24] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[24]),
        .Q(owner_cpu_frame_id[24]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[25] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[25]),
        .Q(owner_cpu_frame_id[25]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[26] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[26]),
        .Q(owner_cpu_frame_id[26]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[27] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[27]),
        .Q(owner_cpu_frame_id[27]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[28] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[28]),
        .Q(owner_cpu_frame_id[28]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[29] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[29]),
        .Q(owner_cpu_frame_id[29]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[2] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[2]),
        .Q(owner_cpu_frame_id[2]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[30] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[30]),
        .Q(owner_cpu_frame_id[30]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[31] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[31]),
        .Q(owner_cpu_frame_id[31]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[3] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[3]),
        .Q(owner_cpu_frame_id[3]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[4] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[4]),
        .Q(owner_cpu_frame_id[4]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[5] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[5]),
        .Q(owner_cpu_frame_id[5]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[6] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[6]),
        .Q(owner_cpu_frame_id[6]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[7] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[7]),
        .Q(owner_cpu_frame_id[7]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[8] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[8]),
        .Q(owner_cpu_frame_id[8]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_cpu_frame_id_reg[9] 
       (.C(s_axi_aclk),
        .CE(\owner_cpu_frame_id[31]_i_1_n_0 ),
        .D(data_held[9]),
        .Q(owner_cpu_frame_id[9]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00000004)) 
    owner_cpu_release_i_1
       (.I0(owner_cpu_claim_i_2_n_0),
        .I1(abort_requested2),
        .I2(owner_cpu_claim_i_4_n_0),
        .I3(owner_cpu_claim_i_5_n_0),
        .I4(owner_cpu_claim_i_6_n_0),
        .O(owner_cpu_release_i_1_n_0));
  FDRE owner_cpu_release_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(owner_cpu_release_i_1_n_0),
        .Q(owner_cpu_release),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \owner_status_held[3]_i_1 
       (.I0(owner_command_fault_reg_0),
        .I1(owner_fault),
        .O(p_0_out));
  LUT6 #(
    .INIT(64'h0000000000010000)) 
    \owner_status_held[6]_i_1 
       (.I0(\owner_status_held[6]_i_2_n_0 ),
        .I1(\owner_status_held[6]_i_3_n_0 ),
        .I2(s_axi_araddr[5]),
        .I3(s_axi_araddr[4]),
        .I4(\owner_status_held[6]_i_4_n_0 ),
        .I5(\owner_status_held[6]_i_5_n_0 ),
        .O(owner_status_pending3_out));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT4 #(
    .INIT(16'hFFFB)) 
    \owner_status_held[6]_i_2 
       (.I0(\s_axi_rresp[1]_i_4_n_0 ),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .O(\owner_status_held[6]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \owner_status_held[6]_i_3 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_araddr[3]),
        .O(\owner_status_held[6]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000002)) 
    \owner_status_held[6]_i_4 
       (.I0(owner_status_pending1),
        .I1(s_axi_araddr[7]),
        .I2(s_axi_araddr[11]),
        .I3(s_axi_araddr[8]),
        .I4(s_axi_araddr[9]),
        .I5(s_axi_araddr[10]),
        .O(\owner_status_held[6]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFEFEFEFEFEEFEEEE)) 
    \owner_status_held[6]_i_5 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_araddr[1]),
        .I2(s_axi_araddr[5]),
        .I3(s_axi_araddr[2]),
        .I4(s_axi_araddr[3]),
        .I5(s_axi_araddr[4]),
        .O(\owner_status_held[6]_i_5_n_0 ));
  FDRE \owner_status_held_reg[0] 
       (.C(s_axi_aclk),
        .CE(owner_status_pending3_out),
        .D(D[0]),
        .Q(\owner_status_held_reg_n_0_[0] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_status_held_reg[1] 
       (.C(s_axi_aclk),
        .CE(owner_status_pending3_out),
        .D(D[1]),
        .Q(\owner_status_held_reg_n_0_[1] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_status_held_reg[2] 
       (.C(s_axi_aclk),
        .CE(owner_status_pending3_out),
        .D(D[2]),
        .Q(\owner_status_held_reg_n_0_[2] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_status_held_reg[3] 
       (.C(s_axi_aclk),
        .CE(owner_status_pending3_out),
        .D(p_0_out),
        .Q(\owner_status_held_reg_n_0_[3] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_status_held_reg[4] 
       (.C(s_axi_aclk),
        .CE(owner_status_pending3_out),
        .D(owner_command_pending_reg_n_0),
        .Q(\owner_status_held_reg_n_0_[4] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_status_held_reg[5] 
       (.C(s_axi_aclk),
        .CE(owner_status_pending3_out),
        .D(\owner_token_configured_reg_n_0_[0] ),
        .Q(\owner_status_held_reg_n_0_[5] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_status_held_reg[6] 
       (.C(s_axi_aclk),
        .CE(owner_status_pending3_out),
        .D(\owner_token_configured_reg_n_0_[1] ),
        .Q(\owner_status_held_reg_n_0_[6] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000010000)) 
    owner_status_pending_i_1
       (.I0(\owner_status_held[6]_i_2_n_0 ),
        .I1(\owner_status_held[6]_i_3_n_0 ),
        .I2(s_axi_araddr[5]),
        .I3(s_axi_araddr[4]),
        .I4(\owner_status_held[6]_i_4_n_0 ),
        .I5(\owner_status_held[6]_i_5_n_0 ),
        .O(owner_status_pending_i_1_n_0));
  FDRE owner_status_pending_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(owner_status_pending_i_1_n_0),
        .Q(owner_status_pending_reg_n_0),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h3735373704050404)) 
    \owner_token_configured[0]_i_1 
       (.I0(\owner_cpu_epoch[31]_i_2_n_0 ),
        .I1(\owner_token_configured[1]_i_2_n_0 ),
        .I2(p_0_in[0]),
        .I3(\owner_token_configured[1]_i_3_n_0 ),
        .I4(\owner_token_configured[1]_i_4_n_0 ),
        .I5(\owner_token_configured_reg_n_0_[0] ),
        .O(\owner_token_configured[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7533773345004400)) 
    \owner_token_configured[1]_i_1 
       (.I0(\owner_cpu_epoch[31]_i_2_n_0 ),
        .I1(\owner_token_configured[1]_i_2_n_0 ),
        .I2(\owner_token_configured[1]_i_3_n_0 ),
        .I3(p_0_in[0]),
        .I4(\owner_token_configured[1]_i_4_n_0 ),
        .I5(\owner_token_configured_reg_n_0_[1] ),
        .O(\owner_token_configured[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h45400000)) 
    \owner_token_configured[1]_i_2 
       (.I0(owner_fault),
        .I1(owner_release_accepted),
        .I2(owner_command_is_release_reg_n_0),
        .I3(owner_claim_accepted),
        .I4(owner_command_pending_reg_n_0),
        .O(\owner_token_configured[1]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hEF)) 
    \owner_token_configured[1]_i_3 
       (.I0(owner_fault),
        .I1(owner_command_fault_reg_0),
        .I2(armed_reg_0),
        .O(\owner_token_configured[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000202200000000)) 
    \owner_token_configured[1]_i_4 
       (.I0(\s_axi_bresp[1]_i_5_n_0 ),
        .I1(\owner_token_configured[1]_i_5_n_0 ),
        .I2(\address_held_reg_n_0_[0] ),
        .I3(\address_held_reg_n_0_[4] ),
        .I4(\address_held_reg_n_0_[1] ),
        .I5(\address_held_reg_n_0_[6] ),
        .O(\owner_token_configured[1]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \owner_token_configured[1]_i_5 
       (.I0(p_0_in[1]),
        .I1(\address_held_reg_n_0_[5] ),
        .O(\owner_token_configured[1]_i_5_n_0 ));
  FDRE \owner_token_configured_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\owner_token_configured[0]_i_1_n_0 ),
        .Q(\owner_token_configured_reg_n_0_[0] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \owner_token_configured_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\owner_token_configured[1]_i_1_n_0 ),
        .Q(\owner_token_configured_reg_n_0_[1] ),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'h04)) 
    s_axi_arready_INST_0
       (.I0(owner_status_pending_reg_n_0),
        .I1(s_axi_aresetn),
        .I2(s_axi_rvalid_reg_0),
        .O(s_axi_arready));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'h0010)) 
    s_axi_awready_INST_0
       (.I0(aw_held),
        .I1(owner_command_pending_reg_n_0),
        .I2(s_axi_aresetn),
        .I3(s_axi_bvalid_reg_0),
        .O(s_axi_awready));
  LUT1 #(
    .INIT(2'h1)) 
    \s_axi_bresp[1]_i_1 
       (.I0(s_axi_aresetn),
        .O(\s_axi_bresp[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0010FFFF00100010)) 
    \s_axi_bresp[1]_i_10 
       (.I0(\s_axi_bresp[1]_i_12_n_0 ),
        .I1(\s_axi_bresp[1]_i_13_n_0 ),
        .I2(\s_axi_bresp[1]_i_14_n_0 ),
        .I3(\s_axi_bresp[1]_i_15_n_0 ),
        .I4(\s_axi_bresp[1]_i_16_n_0 ),
        .I5(\s_axi_bresp[1]_i_17_n_0 ),
        .O(\s_axi_bresp[1]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFA8FFFF)) 
    \s_axi_bresp[1]_i_11 
       (.I0(\address_held_reg_n_0_[5] ),
        .I1(armed_reg_0),
        .I2(\configured[4]_i_2_n_0 ),
        .I3(\cfg_frame_context[31]_i_3_n_0 ),
        .I4(\address_held_reg_n_0_[4] ),
        .I5(\address_held_reg_n_0_[6] ),
        .O(\s_axi_bresp[1]_i_11_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \s_axi_bresp[1]_i_12 
       (.I0(cfg_frame_context[48]),
        .I1(cfg_frame_context[51]),
        .I2(cfg_frame_context[49]),
        .I3(cfg_frame_context[50]),
        .I4(armed_i_13_n_0),
        .O(\s_axi_bresp[1]_i_12_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \s_axi_bresp[1]_i_13 
       (.I0(cfg_frame_context[56]),
        .I1(cfg_frame_context[57]),
        .I2(cfg_frame_context[58]),
        .I3(cfg_frame_context[59]),
        .I4(\s_axi_bresp[1]_i_18_n_0 ),
        .O(\s_axi_bresp[1]_i_13_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \s_axi_bresp[1]_i_14 
       (.I0(cfg_frame_context[64]),
        .I1(cfg_frame_context[65]),
        .I2(cfg_frame_context[66]),
        .I3(cfg_frame_context[67]),
        .I4(armed_i_12_n_0),
        .O(\s_axi_bresp[1]_i_14_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \s_axi_bresp[1]_i_15 
       (.I0(cfg_frame_context[72]),
        .I1(cfg_frame_context[73]),
        .I2(cfg_frame_context[74]),
        .I3(cfg_frame_context[75]),
        .I4(\s_axi_bresp[1]_i_19_n_0 ),
        .O(\s_axi_bresp[1]_i_15_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \s_axi_bresp[1]_i_16 
       (.I0(\s_axi_bresp[1]_i_20_n_0 ),
        .I1(\s_axi_bresp[1]_i_21_n_0 ),
        .I2(\s_axi_bresp[1]_i_22_n_0 ),
        .I3(\s_axi_bresp[1]_i_23_n_0 ),
        .O(\s_axi_bresp[1]_i_16_n_0 ));
  LUT4 #(
    .INIT(16'h0004)) 
    \s_axi_bresp[1]_i_17 
       (.I0(\s_axi_bresp[1]_i_24_n_0 ),
        .I1(\s_axi_bresp[1]_i_25_n_0 ),
        .I2(\s_axi_bresp[1]_i_26_n_0 ),
        .I3(\s_axi_bresp[1]_i_27_n_0 ),
        .O(\s_axi_bresp[1]_i_17_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \s_axi_bresp[1]_i_18 
       (.I0(cfg_frame_context[61]),
        .I1(cfg_frame_context[60]),
        .I2(cfg_frame_context[63]),
        .I3(cfg_frame_context[62]),
        .O(\s_axi_bresp[1]_i_18_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \s_axi_bresp[1]_i_19 
       (.I0(cfg_frame_context[77]),
        .I1(cfg_frame_context[76]),
        .I2(cfg_frame_context[78]),
        .I3(cfg_frame_context[79]),
        .O(\s_axi_bresp[1]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'h004FFFFF004F0000)) 
    \s_axi_bresp[1]_i_2 
       (.I0(\s_axi_bresp[1]_i_3_n_0 ),
        .I1(\s_axi_bresp[1]_i_4_n_0 ),
        .I2(\s_axi_bresp[1]_i_5_n_0 ),
        .I3(\s_axi_bresp[1]_i_6_n_0 ),
        .I4(\s_axi_bresp[1]_i_7_n_0 ),
        .I5(s_axi_bresp),
        .O(\s_axi_bresp[1]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \s_axi_bresp[1]_i_20 
       (.I0(cfg_frame_context[143]),
        .I1(cfg_frame_context[141]),
        .I2(cfg_frame_context[142]),
        .I3(cfg_frame_context[140]),
        .O(\s_axi_bresp[1]_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \s_axi_bresp[1]_i_21 
       (.I0(cfg_frame_context[137]),
        .I1(cfg_frame_context[136]),
        .I2(cfg_frame_context[139]),
        .I3(cfg_frame_context[138]),
        .O(\s_axi_bresp[1]_i_21_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \s_axi_bresp[1]_i_22 
       (.I0(cfg_frame_context[133]),
        .I1(cfg_frame_context[132]),
        .I2(cfg_frame_context[135]),
        .I3(cfg_frame_context[134]),
        .O(\s_axi_bresp[1]_i_22_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \s_axi_bresp[1]_i_23 
       (.I0(cfg_frame_context[131]),
        .I1(cfg_frame_context[128]),
        .I2(cfg_frame_context[130]),
        .I3(cfg_frame_context[129]),
        .O(\s_axi_bresp[1]_i_23_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \s_axi_bresp[1]_i_24 
       (.I0(cfg_frame_context[125]),
        .I1(cfg_frame_context[124]),
        .I2(cfg_frame_context[127]),
        .I3(cfg_frame_context[126]),
        .O(\s_axi_bresp[1]_i_24_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    \s_axi_bresp[1]_i_25 
       (.I0(cfg_frame_context[123]),
        .I1(cfg_frame_context[120]),
        .I2(cfg_frame_context[122]),
        .I3(cfg_frame_context[121]),
        .O(\s_axi_bresp[1]_i_25_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \s_axi_bresp[1]_i_26 
       (.I0(cfg_frame_context[119]),
        .I1(cfg_frame_context[118]),
        .I2(cfg_frame_context[117]),
        .I3(cfg_frame_context[116]),
        .O(\s_axi_bresp[1]_i_26_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \s_axi_bresp[1]_i_27 
       (.I0(cfg_frame_context[115]),
        .I1(cfg_frame_context[114]),
        .I2(cfg_frame_context[113]),
        .I3(cfg_frame_context[112]),
        .O(\s_axi_bresp[1]_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h0000000F00110000)) 
    \s_axi_bresp[1]_i_3 
       (.I0(p_0_in[1]),
        .I1(\owner_token_configured[1]_i_3_n_0 ),
        .I2(armed_reg_0),
        .I3(\address_held_reg_n_0_[4] ),
        .I4(\address_held_reg_n_0_[6] ),
        .I5(\address_held_reg_n_0_[5] ),
        .O(\s_axi_bresp[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF01010001)) 
    \s_axi_bresp[1]_i_4 
       (.I0(abort_requested0),
        .I1(barrier_request0),
        .I2(\address_held_reg_n_0_[5] ),
        .I3(\s_axi_bresp[1]_i_9_n_0 ),
        .I4(\s_axi_bresp[1]_i_10_n_0 ),
        .I5(\s_axi_bresp[1]_i_11_n_0 ),
        .O(\s_axi_bresp[1]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'h01)) 
    \s_axi_bresp[1]_i_5 
       (.I0(\address_held_reg_n_0_[1] ),
        .I1(\address_held_reg_n_0_[0] ),
        .I2(\cfg_frame_context[127]_i_2_n_0 ),
        .O(\s_axi_bresp[1]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h00004540)) 
    \s_axi_bresp[1]_i_6 
       (.I0(owner_fault),
        .I1(owner_release_accepted),
        .I2(owner_command_is_release_reg_n_0),
        .I3(owner_claim_accepted),
        .I4(s_axi_bvalid_i_4_n_0),
        .O(\s_axi_bresp[1]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h08FF0808)) 
    \s_axi_bresp[1]_i_7 
       (.I0(w_held_reg_n_0),
        .I1(aw_held),
        .I2(s_axi_bvalid_reg_0),
        .I3(s_axi_bvalid_i_3_n_0),
        .I4(owner_command_pending_reg_n_0),
        .O(\s_axi_bresp[1]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000040000)) 
    \s_axi_bresp[1]_i_8 
       (.I0(abort_requested_i_3_n_0),
        .I1(data_held[1]),
        .I2(data_held[2]),
        .I3(\configured[4]_i_2_n_0 ),
        .I4(armed_reg_0),
        .I5(abort_requested_reg_0),
        .O(abort_requested0));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    \s_axi_bresp[1]_i_9 
       (.I0(owner_cpu_claim_i_8_n_0),
        .I1(owner_cpu_claim_i_7_n_0),
        .I2(\configured[4]_i_2_n_0 ),
        .I3(armed_i_4_n_0),
        .O(\s_axi_bresp[1]_i_9_n_0 ));
  FDRE \s_axi_bresp_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\s_axi_bresp[1]_i_2_n_0 ),
        .Q(s_axi_bresp),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h5555555530301530)) 
    s_axi_bvalid_i_1
       (.I0(owner_command_pending18_out),
        .I1(s_axi_bready),
        .I2(s_axi_bvalid_reg_0),
        .I3(owner_command_pending_reg_n_0),
        .I4(s_axi_bvalid_i_3_n_0),
        .I5(s_axi_bvalid_i_4_n_0),
        .O(s_axi_bvalid_i_1_n_0));
  LUT5 #(
    .INIT(32'h00000054)) 
    s_axi_bvalid_i_2
       (.I0(owner_cpu_claim_i_4_n_0),
        .I1(owner_cpu_claim_i_3_n_0),
        .I2(abort_requested2),
        .I3(owner_cpu_claim_i_2_n_0),
        .I4(\cfg_frame_context[127]_i_2_n_0 ),
        .O(owner_command_pending18_out));
  LUT6 #(
    .INIT(64'h0007000000070707)) 
    s_axi_bvalid_i_3
       (.I0(\owner_command_wait_reg_n_0_[1] ),
        .I1(\owner_command_wait_reg_n_0_[0] ),
        .I2(owner_fault),
        .I3(owner_release_accepted),
        .I4(owner_command_is_release_reg_n_0),
        .I5(owner_claim_accepted),
        .O(s_axi_bvalid_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h40)) 
    s_axi_bvalid_i_4
       (.I0(s_axi_bvalid_reg_0),
        .I1(aw_held),
        .I2(w_held_reg_n_0),
        .O(s_axi_bvalid_i_4_n_0));
  FDRE s_axi_bvalid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_bvalid_i_1_n_0),
        .Q(s_axi_bvalid_reg_0),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFEFEFEEEFEFEFEFE)) 
    \s_axi_rdata[0]_i_1 
       (.I0(\s_axi_rdata[0]_i_2_n_0 ),
        .I1(\s_axi_rdata[0]_i_3_n_0 ),
        .I2(\owner_status_held_reg_n_0_[0] ),
        .I3(s_axi_rvalid_reg_0),
        .I4(\s_axi_rdata[31]_i_1_n_0 ),
        .I5(s_axi_arvalid),
        .O(\s_axi_rdata[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8888888A888)) 
    \s_axi_rdata[0]_i_2 
       (.I0(\s_axi_rdata[31]_i_6_n_0 ),
        .I1(\s_axi_rdata[0]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(cfg_frame_context[128]),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[0]_i_5_n_0 ),
        .O(\s_axi_rdata[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h1010100000001000)) 
    \s_axi_rdata[0]_i_3 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[4]_i_4_n_0 ),
        .I2(\owner_status_held[6]_i_4_n_0 ),
        .I3(\configured_reg_n_0_[0] ),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(armed_reg_0),
        .O(\s_axi_rdata[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h00000000F4000000)) 
    \s_axi_rdata[0]_i_4 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[0]_i_6_n_0 ),
        .I3(\s_axi_rdata[31]_i_5_n_0 ),
        .I4(\s_axi_rdata[0]_i_7_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFAACCF000AACCF0)) 
    \s_axi_rdata[0]_i_5 
       (.I0(cfg_frame_context[32]),
        .I1(cfg_frame_context[64]),
        .I2(cfg_frame_context[0]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[96]),
        .O(\s_axi_rdata[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[0]_i_6 
       (.I0(\s_axi_rdata[0]_i_8_n_0 ),
        .I1(owner_cpu_epoch[0]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[0]),
        .O(\s_axi_rdata[0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hF3F3FFFFFBFBFFF3)) 
    \s_axi_rdata[0]_i_7 
       (.I0(owner_fault_causes[0]),
        .I1(s_axi_araddr[5]),
        .I2(s_axi_araddr[0]),
        .I3(owner_released_frames[0]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[3]),
        .O(\s_axi_rdata[0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[0]_i_8 
       (.I0(owner_granted_frames[0]),
        .I1(owner_slot[0]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[0]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[0]),
        .O(\s_axi_rdata[0]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'hFBAA)) 
    \s_axi_rdata[10]_i_1 
       (.I0(\s_axi_rdata[29]_i_2_n_0 ),
        .I1(\s_axi_rdata[10]_i_2_n_0 ),
        .I2(\s_axi_rdata[10]_i_3_n_0 ),
        .I3(\s_axi_rdata[31]_i_6_n_0 ),
        .O(\s_axi_rdata[10]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h57F7)) 
    \s_axi_rdata[10]_i_2 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(cfg_frame_context[138]),
        .I2(\s_axi_rdata[31]_i_5_n_0 ),
        .I3(\s_axi_rdata[10]_i_4_n_0 ),
        .O(\s_axi_rdata[10]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[10]_i_3 
       (.I0(\s_axi_rdata[10]_i_5_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[10]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[10]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFAACCF000AACCF0)) 
    \s_axi_rdata[10]_i_4 
       (.I0(cfg_frame_context[42]),
        .I1(cfg_frame_context[74]),
        .I2(cfg_frame_context[10]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[106]),
        .O(\s_axi_rdata[10]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[10]_i_5 
       (.I0(\s_axi_rdata[10]_i_6_n_0 ),
        .I1(owner_cpu_epoch[10]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[10]),
        .O(\s_axi_rdata[10]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[10]_i_6 
       (.I0(owner_granted_frames[10]),
        .I1(owner_slot[10]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[10]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[10]),
        .O(\s_axi_rdata[10]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8888888A888)) 
    \s_axi_rdata[11]_i_1 
       (.I0(\s_axi_rdata[31]_i_6_n_0 ),
        .I1(\s_axi_rdata[11]_i_2_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(cfg_frame_context[139]),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[11]_i_3_n_0 ),
        .O(\s_axi_rdata[11]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[11]_i_2 
       (.I0(\s_axi_rdata[11]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[11]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[11]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCAAFFF0CCAA00F0)) 
    \s_axi_rdata[11]_i_3 
       (.I0(cfg_frame_context[43]),
        .I1(cfg_frame_context[107]),
        .I2(cfg_frame_context[11]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[75]),
        .O(\s_axi_rdata[11]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[11]_i_4 
       (.I0(\s_axi_rdata[11]_i_5_n_0 ),
        .I1(owner_cpu_epoch[11]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[11]),
        .O(\s_axi_rdata[11]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[11]_i_5 
       (.I0(owner_granted_frames[11]),
        .I1(owner_slot[11]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[11]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[11]),
        .O(\s_axi_rdata[11]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT4 #(
    .INIT(16'hFBAA)) 
    \s_axi_rdata[12]_i_1 
       (.I0(\s_axi_rdata[29]_i_2_n_0 ),
        .I1(\s_axi_rdata[12]_i_2_n_0 ),
        .I2(\s_axi_rdata[12]_i_3_n_0 ),
        .I3(\s_axi_rdata[31]_i_6_n_0 ),
        .O(\s_axi_rdata[12]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h57F7)) 
    \s_axi_rdata[12]_i_2 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(cfg_frame_context[140]),
        .I2(\s_axi_rdata[31]_i_5_n_0 ),
        .I3(\s_axi_rdata[12]_i_4_n_0 ),
        .O(\s_axi_rdata[12]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[12]_i_3 
       (.I0(\s_axi_rdata[12]_i_5_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[12]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[12]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFAACCF000AACCF0)) 
    \s_axi_rdata[12]_i_4 
       (.I0(cfg_frame_context[44]),
        .I1(cfg_frame_context[76]),
        .I2(cfg_frame_context[12]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[108]),
        .O(\s_axi_rdata[12]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[12]_i_5 
       (.I0(\s_axi_rdata[12]_i_6_n_0 ),
        .I1(owner_cpu_epoch[12]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[12]),
        .O(\s_axi_rdata[12]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[12]_i_6 
       (.I0(owner_granted_frames[12]),
        .I1(owner_slot[12]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[12]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[12]),
        .O(\s_axi_rdata[12]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8888888A888)) 
    \s_axi_rdata[13]_i_1 
       (.I0(\s_axi_rdata[31]_i_6_n_0 ),
        .I1(\s_axi_rdata[13]_i_2_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(cfg_frame_context[141]),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[13]_i_3_n_0 ),
        .O(\s_axi_rdata[13]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000004044004440)) 
    \s_axi_rdata[13]_i_2 
       (.I0(\s_axi_rdata[31]_i_8_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[13]),
        .I3(\s_axi_rdata[30]_i_5_n_0 ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\s_axi_rdata[13]_i_4_n_0 ),
        .O(\s_axi_rdata[13]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCAAFFF0CCAA00F0)) 
    \s_axi_rdata[13]_i_3 
       (.I0(cfg_frame_context[45]),
        .I1(cfg_frame_context[109]),
        .I2(cfg_frame_context[13]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[77]),
        .O(\s_axi_rdata[13]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h5555FF035555FFF3)) 
    \s_axi_rdata[13]_i_4 
       (.I0(\s_axi_rdata[13]_i_5_n_0 ),
        .I1(owner_cpu_epoch[13]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[13]),
        .O(\s_axi_rdata[13]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[13]_i_5 
       (.I0(owner_granted_frames[13]),
        .I1(owner_slot[13]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[13]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[13]),
        .O(\s_axi_rdata[13]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hBA)) 
    \s_axi_rdata[14]_i_1 
       (.I0(\s_axi_rdata[29]_i_2_n_0 ),
        .I1(\s_axi_rdata[14]_i_2_n_0 ),
        .I2(\s_axi_rdata[31]_i_6_n_0 ),
        .O(\s_axi_rdata[14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h5F5F3F3F5F003F3F)) 
    \s_axi_rdata[14]_i_2 
       (.I0(\s_axi_rdata[14]_i_3_n_0 ),
        .I1(cfg_frame_context[142]),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(\s_axi_rdata[14]_i_4_n_0 ),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[14]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCAAFFF0CCAA00F0)) 
    \s_axi_rdata[14]_i_3 
       (.I0(cfg_frame_context[46]),
        .I1(cfg_frame_context[110]),
        .I2(cfg_frame_context[14]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[78]),
        .O(\s_axi_rdata[14]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAFCAAAAAAFFAA)) 
    \s_axi_rdata[14]_i_4 
       (.I0(\s_axi_rdata[14]_i_5_n_0 ),
        .I1(s_axi_araddr[3]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[5]),
        .I4(s_axi_araddr[0]),
        .I5(owner_released_frames[14]),
        .O(\s_axi_rdata[14]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h5555FF035555FFF3)) 
    \s_axi_rdata[14]_i_5 
       (.I0(\s_axi_rdata[14]_i_6_n_0 ),
        .I1(owner_cpu_epoch[14]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[14]),
        .O(\s_axi_rdata[14]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[14]_i_6 
       (.I0(owner_granted_frames[14]),
        .I1(owner_slot[14]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[14]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[14]),
        .O(\s_axi_rdata[14]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8888888A888)) 
    \s_axi_rdata[15]_i_1 
       (.I0(\s_axi_rdata[31]_i_6_n_0 ),
        .I1(\s_axi_rdata[15]_i_2_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(cfg_frame_context[143]),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[15]_i_3_n_0 ),
        .O(\s_axi_rdata[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[15]_i_2 
       (.I0(\s_axi_rdata[15]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[15]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[15]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFF0AACC00F0AA)) 
    \s_axi_rdata[15]_i_3 
       (.I0(cfg_frame_context[15]),
        .I1(cfg_frame_context[111]),
        .I2(cfg_frame_context[47]),
        .I3(s_axi_araddr[2]),
        .I4(s_axi_araddr[3]),
        .I5(cfg_frame_context[79]),
        .O(\s_axi_rdata[15]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[15]_i_4 
       (.I0(\s_axi_rdata[15]_i_5_n_0 ),
        .I1(owner_cpu_epoch[15]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[15]),
        .O(\s_axi_rdata[15]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[15]_i_5 
       (.I0(owner_granted_frames[15]),
        .I1(owner_slot[15]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[15]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[15]),
        .O(\s_axi_rdata[15]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFF0F8F0F0F0F0)) 
    \s_axi_rdata[16]_i_1 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(\s_axi_rdata[29]_i_2_n_0 ),
        .I3(\s_axi_rdata[16]_i_2_n_0 ),
        .I4(\s_axi_rdata[16]_i_3_n_0 ),
        .I5(\s_axi_rdata[31]_i_6_n_0 ),
        .O(\s_axi_rdata[16]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0F3300550F33FF55)) 
    \s_axi_rdata[16]_i_2 
       (.I0(cfg_frame_context[16]),
        .I1(cfg_frame_context[48]),
        .I2(cfg_frame_context[112]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[80]),
        .O(\s_axi_rdata[16]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000004044004440)) 
    \s_axi_rdata[16]_i_3 
       (.I0(\s_axi_rdata[31]_i_8_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[16]),
        .I3(\s_axi_rdata[30]_i_5_n_0 ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\s_axi_rdata[16]_i_4_n_0 ),
        .O(\s_axi_rdata[16]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h5555FF035555FFF3)) 
    \s_axi_rdata[16]_i_4 
       (.I0(\s_axi_rdata[16]_i_5_n_0 ),
        .I1(owner_cpu_epoch[16]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[16]),
        .O(\s_axi_rdata[16]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[16]_i_5 
       (.I0(owner_granted_frames[16]),
        .I1(owner_slot[16]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[16]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[16]),
        .O(\s_axi_rdata[16]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFF0FFF0F0F0F8F0F)) 
    \s_axi_rdata[17]_i_1 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(\s_axi_rdata[17]_i_2_n_0 ),
        .I3(\s_axi_rdata[31]_i_6_n_0 ),
        .I4(\s_axi_rdata[17]_i_3_n_0 ),
        .I5(\s_axi_rdata[17]_i_4_n_0 ),
        .O(\s_axi_rdata[17]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'hEFFF)) 
    \s_axi_rdata[17]_i_2 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[4]),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(\owner_status_held[6]_i_4_n_0 ),
        .O(\s_axi_rdata[17]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0F3300550F33FF55)) 
    \s_axi_rdata[17]_i_3 
       (.I0(cfg_frame_context[17]),
        .I1(cfg_frame_context[49]),
        .I2(cfg_frame_context[113]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[81]),
        .O(\s_axi_rdata[17]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000004044004440)) 
    \s_axi_rdata[17]_i_4 
       (.I0(\s_axi_rdata[31]_i_8_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[17]),
        .I3(\s_axi_rdata[30]_i_5_n_0 ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\s_axi_rdata[17]_i_5_n_0 ),
        .O(\s_axi_rdata[17]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h5555FF035555FFF3)) 
    \s_axi_rdata[17]_i_5 
       (.I0(\s_axi_rdata[17]_i_6_n_0 ),
        .I1(owner_cpu_epoch[17]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[17]),
        .O(\s_axi_rdata[17]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[17]_i_6 
       (.I0(owner_granted_frames[17]),
        .I1(owner_slot[17]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[17]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[17]),
        .O(\s_axi_rdata[17]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h00200020A0A00020)) 
    \s_axi_rdata[18]_i_1 
       (.I0(\s_axi_rdata[31]_i_6_n_0 ),
        .I1(\s_axi_rdata[31]_i_8_n_0 ),
        .I2(\s_axi_rdata[31]_i_5_n_0 ),
        .I3(\s_axi_rdata[18]_i_2_n_0 ),
        .I4(\s_axi_rdata[31]_i_4_n_0 ),
        .I5(\s_axi_rdata[18]_i_3_n_0 ),
        .O(\s_axi_rdata[18]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAFCAAAAAAFFAA)) 
    \s_axi_rdata[18]_i_2 
       (.I0(\s_axi_rdata[18]_i_4_n_0 ),
        .I1(s_axi_araddr[3]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[5]),
        .I4(s_axi_araddr[0]),
        .I5(owner_released_frames[18]),
        .O(\s_axi_rdata[18]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h3355000F3355FF0F)) 
    \s_axi_rdata[18]_i_3 
       (.I0(cfg_frame_context[50]),
        .I1(cfg_frame_context[114]),
        .I2(cfg_frame_context[18]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[82]),
        .O(\s_axi_rdata[18]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h5555FF035555FFF3)) 
    \s_axi_rdata[18]_i_4 
       (.I0(\s_axi_rdata[18]_i_5_n_0 ),
        .I1(owner_cpu_epoch[18]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[18]),
        .O(\s_axi_rdata[18]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[18]_i_5 
       (.I0(owner_granted_frames[18]),
        .I1(owner_slot[18]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[18]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[18]),
        .O(\s_axi_rdata[18]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hF000F080)) 
    \s_axi_rdata[19]_i_1 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(\s_axi_rdata[31]_i_6_n_0 ),
        .I3(\s_axi_rdata[19]_i_2_n_0 ),
        .I4(\s_axi_rdata[19]_i_3_n_0 ),
        .O(\s_axi_rdata[19]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[19]_i_2 
       (.I0(\s_axi_rdata[19]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[19]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[19]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h000F3355FF0F3355)) 
    \s_axi_rdata[19]_i_3 
       (.I0(cfg_frame_context[19]),
        .I1(cfg_frame_context[51]),
        .I2(cfg_frame_context[83]),
        .I3(s_axi_araddr[2]),
        .I4(s_axi_araddr[3]),
        .I5(cfg_frame_context[115]),
        .O(\s_axi_rdata[19]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[19]_i_4 
       (.I0(\s_axi_rdata[19]_i_5_n_0 ),
        .I1(owner_cpu_epoch[19]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[19]),
        .O(\s_axi_rdata[19]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[19]_i_5 
       (.I0(owner_granted_frames[19]),
        .I1(owner_slot[19]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[19]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[19]),
        .O(\s_axi_rdata[19]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFEFEFEEEFEFEFEFE)) 
    \s_axi_rdata[1]_i_1 
       (.I0(\s_axi_rdata[1]_i_2_n_0 ),
        .I1(\s_axi_rdata[1]_i_3_n_0 ),
        .I2(\owner_status_held_reg_n_0_[1] ),
        .I3(s_axi_rvalid_reg_0),
        .I4(\s_axi_rdata[31]_i_1_n_0 ),
        .I5(s_axi_arvalid),
        .O(\s_axi_rdata[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8888888A888)) 
    \s_axi_rdata[1]_i_2 
       (.I0(\s_axi_rdata[31]_i_6_n_0 ),
        .I1(\s_axi_rdata[1]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(cfg_frame_context[129]),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[1]_i_5_n_0 ),
        .O(\s_axi_rdata[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h3030000030002020)) 
    \s_axi_rdata[1]_i_3 
       (.I0(\configured_reg_n_0_[1] ),
        .I1(\s_axi_rdata[4]_i_4_n_0 ),
        .I2(\owner_status_held[6]_i_4_n_0 ),
        .I3(abort_requested_reg_0),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h00000000F4000000)) 
    \s_axi_rdata[1]_i_4 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[1]_i_6_n_0 ),
        .I3(\s_axi_rdata[31]_i_5_n_0 ),
        .I4(\s_axi_rdata[1]_i_7_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFAACCF000AACCF0)) 
    \s_axi_rdata[1]_i_5 
       (.I0(cfg_frame_context[33]),
        .I1(cfg_frame_context[65]),
        .I2(cfg_frame_context[1]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[97]),
        .O(\s_axi_rdata[1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[1]_i_6 
       (.I0(\s_axi_rdata[1]_i_8_n_0 ),
        .I1(owner_cpu_epoch[1]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[1]),
        .O(\s_axi_rdata[1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hBBFFBBFFFBFFFBBB)) 
    \s_axi_rdata[1]_i_7 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_araddr[5]),
        .I2(owner_fault_causes[1]),
        .I3(s_axi_araddr[2]),
        .I4(owner_released_frames[1]),
        .I5(s_axi_araddr[3]),
        .O(\s_axi_rdata[1]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[1]_i_8 
       (.I0(owner_granted_frames[1]),
        .I1(owner_slot[1]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[1]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[1]),
        .O(\s_axi_rdata[1]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hF000F080)) 
    \s_axi_rdata[20]_i_1 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(\s_axi_rdata[31]_i_6_n_0 ),
        .I3(\s_axi_rdata[20]_i_2_n_0 ),
        .I4(\s_axi_rdata[20]_i_3_n_0 ),
        .O(\s_axi_rdata[20]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[20]_i_2 
       (.I0(\s_axi_rdata[20]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[20]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[20]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h000F3355FF0F3355)) 
    \s_axi_rdata[20]_i_3 
       (.I0(cfg_frame_context[20]),
        .I1(cfg_frame_context[52]),
        .I2(cfg_frame_context[84]),
        .I3(s_axi_araddr[2]),
        .I4(s_axi_araddr[3]),
        .I5(cfg_frame_context[116]),
        .O(\s_axi_rdata[20]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[20]_i_4 
       (.I0(\s_axi_rdata[20]_i_5_n_0 ),
        .I1(owner_cpu_epoch[20]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[20]),
        .O(\s_axi_rdata[20]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[20]_i_5 
       (.I0(owner_granted_frames[20]),
        .I1(owner_slot[20]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[20]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[20]),
        .O(\s_axi_rdata[20]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h00200020A0A00020)) 
    \s_axi_rdata[21]_i_1 
       (.I0(\s_axi_rdata[31]_i_6_n_0 ),
        .I1(\s_axi_rdata[31]_i_8_n_0 ),
        .I2(\s_axi_rdata[31]_i_5_n_0 ),
        .I3(\s_axi_rdata[21]_i_2_n_0 ),
        .I4(\s_axi_rdata[31]_i_4_n_0 ),
        .I5(\s_axi_rdata[21]_i_3_n_0 ),
        .O(\s_axi_rdata[21]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAFCAAAAAAFFAA)) 
    \s_axi_rdata[21]_i_2 
       (.I0(\s_axi_rdata[21]_i_4_n_0 ),
        .I1(s_axi_araddr[3]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[5]),
        .I4(s_axi_araddr[0]),
        .I5(owner_released_frames[21]),
        .O(\s_axi_rdata[21]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h3355000F3355FF0F)) 
    \s_axi_rdata[21]_i_3 
       (.I0(cfg_frame_context[53]),
        .I1(cfg_frame_context[117]),
        .I2(cfg_frame_context[21]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[85]),
        .O(\s_axi_rdata[21]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h5555FF035555FFF3)) 
    \s_axi_rdata[21]_i_4 
       (.I0(\s_axi_rdata[21]_i_5_n_0 ),
        .I1(owner_cpu_epoch[21]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[21]),
        .O(\s_axi_rdata[21]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[21]_i_5 
       (.I0(owner_granted_frames[21]),
        .I1(owner_slot[21]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[21]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[21]),
        .O(\s_axi_rdata[21]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFF0F8F0F0F0F0)) 
    \s_axi_rdata[22]_i_1 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(\s_axi_rdata[29]_i_2_n_0 ),
        .I3(\s_axi_rdata[22]_i_2_n_0 ),
        .I4(\s_axi_rdata[22]_i_3_n_0 ),
        .I5(\s_axi_rdata[31]_i_6_n_0 ),
        .O(\s_axi_rdata[22]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0055330FFF55330F)) 
    \s_axi_rdata[22]_i_2 
       (.I0(cfg_frame_context[54]),
        .I1(cfg_frame_context[86]),
        .I2(cfg_frame_context[22]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[118]),
        .O(\s_axi_rdata[22]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000004044004440)) 
    \s_axi_rdata[22]_i_3 
       (.I0(\s_axi_rdata[31]_i_8_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[22]),
        .I3(\s_axi_rdata[30]_i_5_n_0 ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\s_axi_rdata[22]_i_4_n_0 ),
        .O(\s_axi_rdata[22]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h5555FF035555FFF3)) 
    \s_axi_rdata[22]_i_4 
       (.I0(\s_axi_rdata[22]_i_5_n_0 ),
        .I1(owner_cpu_epoch[22]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[22]),
        .O(\s_axi_rdata[22]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[22]_i_5 
       (.I0(owner_granted_frames[22]),
        .I1(owner_slot[22]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[22]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[22]),
        .O(\s_axi_rdata[22]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hF000F080)) 
    \s_axi_rdata[23]_i_1 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(\s_axi_rdata[31]_i_6_n_0 ),
        .I3(\s_axi_rdata[23]_i_2_n_0 ),
        .I4(\s_axi_rdata[23]_i_3_n_0 ),
        .O(\s_axi_rdata[23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[23]_i_2 
       (.I0(\s_axi_rdata[23]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[23]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[23]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0055330FFF55330F)) 
    \s_axi_rdata[23]_i_3 
       (.I0(cfg_frame_context[55]),
        .I1(cfg_frame_context[87]),
        .I2(cfg_frame_context[23]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[119]),
        .O(\s_axi_rdata[23]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[23]_i_4 
       (.I0(\s_axi_rdata[23]_i_5_n_0 ),
        .I1(owner_cpu_epoch[23]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[23]),
        .O(\s_axi_rdata[23]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[23]_i_5 
       (.I0(owner_granted_frames[23]),
        .I1(owner_slot[23]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[23]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[23]),
        .O(\s_axi_rdata[23]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFF0F8F0F0F0F0)) 
    \s_axi_rdata[24]_i_1 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(\s_axi_rdata[29]_i_2_n_0 ),
        .I3(\s_axi_rdata[24]_i_2_n_0 ),
        .I4(\s_axi_rdata[24]_i_3_n_0 ),
        .I5(\s_axi_rdata[31]_i_6_n_0 ),
        .O(\s_axi_rdata[24]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0055330FFF55330F)) 
    \s_axi_rdata[24]_i_2 
       (.I0(cfg_frame_context[56]),
        .I1(cfg_frame_context[88]),
        .I2(cfg_frame_context[24]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[120]),
        .O(\s_axi_rdata[24]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[24]_i_3 
       (.I0(\s_axi_rdata[24]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[24]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[24]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[24]_i_4 
       (.I0(\s_axi_rdata[24]_i_5_n_0 ),
        .I1(owner_cpu_epoch[24]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[24]),
        .O(\s_axi_rdata[24]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[24]_i_5 
       (.I0(owner_granted_frames[24]),
        .I1(owner_slot[24]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[24]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[24]),
        .O(\s_axi_rdata[24]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hF000F080)) 
    \s_axi_rdata[25]_i_1 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(\s_axi_rdata[31]_i_6_n_0 ),
        .I3(\s_axi_rdata[25]_i_2_n_0 ),
        .I4(\s_axi_rdata[25]_i_3_n_0 ),
        .O(\s_axi_rdata[25]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[25]_i_2 
       (.I0(\s_axi_rdata[25]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[25]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[25]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h000F3355FF0F3355)) 
    \s_axi_rdata[25]_i_3 
       (.I0(cfg_frame_context[25]),
        .I1(cfg_frame_context[57]),
        .I2(cfg_frame_context[89]),
        .I3(s_axi_araddr[2]),
        .I4(s_axi_araddr[3]),
        .I5(cfg_frame_context[121]),
        .O(\s_axi_rdata[25]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[25]_i_4 
       (.I0(\s_axi_rdata[25]_i_5_n_0 ),
        .I1(owner_cpu_epoch[25]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[25]),
        .O(\s_axi_rdata[25]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[25]_i_5 
       (.I0(owner_granted_frames[25]),
        .I1(owner_slot[25]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[25]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[25]),
        .O(\s_axi_rdata[25]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hF000F080)) 
    \s_axi_rdata[26]_i_1 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(\s_axi_rdata[31]_i_6_n_0 ),
        .I3(\s_axi_rdata[26]_i_2_n_0 ),
        .I4(\s_axi_rdata[26]_i_3_n_0 ),
        .O(\s_axi_rdata[26]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[26]_i_2 
       (.I0(\s_axi_rdata[26]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[26]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[26]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0055330FFF55330F)) 
    \s_axi_rdata[26]_i_3 
       (.I0(cfg_frame_context[58]),
        .I1(cfg_frame_context[90]),
        .I2(cfg_frame_context[26]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[122]),
        .O(\s_axi_rdata[26]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[26]_i_4 
       (.I0(\s_axi_rdata[26]_i_5_n_0 ),
        .I1(owner_cpu_epoch[26]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[26]),
        .O(\s_axi_rdata[26]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[26]_i_5 
       (.I0(owner_granted_frames[26]),
        .I1(owner_slot[26]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[26]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[26]),
        .O(\s_axi_rdata[26]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hF000F080)) 
    \s_axi_rdata[27]_i_1 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(\s_axi_rdata[31]_i_6_n_0 ),
        .I3(\s_axi_rdata[27]_i_2_n_0 ),
        .I4(\s_axi_rdata[27]_i_3_n_0 ),
        .O(\s_axi_rdata[27]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[27]_i_2 
       (.I0(\s_axi_rdata[27]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[27]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[27]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h3355000F3355FF0F)) 
    \s_axi_rdata[27]_i_3 
       (.I0(cfg_frame_context[59]),
        .I1(cfg_frame_context[123]),
        .I2(cfg_frame_context[27]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[91]),
        .O(\s_axi_rdata[27]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[27]_i_4 
       (.I0(\s_axi_rdata[27]_i_5_n_0 ),
        .I1(owner_cpu_epoch[27]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[27]),
        .O(\s_axi_rdata[27]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[27]_i_5 
       (.I0(owner_granted_frames[27]),
        .I1(owner_slot[27]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[27]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[27]),
        .O(\s_axi_rdata[27]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFF0F8F0F0F0F0)) 
    \s_axi_rdata[28]_i_1 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(\s_axi_rdata[29]_i_2_n_0 ),
        .I3(\s_axi_rdata[28]_i_2_n_0 ),
        .I4(\s_axi_rdata[28]_i_3_n_0 ),
        .I5(\s_axi_rdata[31]_i_6_n_0 ),
        .O(\s_axi_rdata[28]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h000F3355FF0F3355)) 
    \s_axi_rdata[28]_i_2 
       (.I0(cfg_frame_context[28]),
        .I1(cfg_frame_context[60]),
        .I2(cfg_frame_context[92]),
        .I3(s_axi_araddr[2]),
        .I4(s_axi_araddr[3]),
        .I5(cfg_frame_context[124]),
        .O(\s_axi_rdata[28]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[28]_i_3 
       (.I0(\s_axi_rdata[28]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[28]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[28]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[28]_i_4 
       (.I0(\s_axi_rdata[28]_i_5_n_0 ),
        .I1(owner_cpu_epoch[28]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[28]),
        .O(\s_axi_rdata[28]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[28]_i_5 
       (.I0(owner_granted_frames[28]),
        .I1(owner_slot[28]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[28]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[28]),
        .O(\s_axi_rdata[28]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFF0F8F0F0F0F0)) 
    \s_axi_rdata[29]_i_1 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(\s_axi_rdata[29]_i_2_n_0 ),
        .I3(\s_axi_rdata[29]_i_3_n_0 ),
        .I4(\s_axi_rdata[29]_i_4_n_0 ),
        .I5(\s_axi_rdata[31]_i_6_n_0 ),
        .O(\s_axi_rdata[29]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h00000080)) 
    \s_axi_rdata[29]_i_2 
       (.I0(\s_axi_rdata[31]_i_5_n_0 ),
        .I1(\owner_status_held[6]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(s_axi_araddr[4]),
        .I4(s_axi_araddr[5]),
        .O(\s_axi_rdata[29]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h3355000F3355FF0F)) 
    \s_axi_rdata[29]_i_3 
       (.I0(cfg_frame_context[61]),
        .I1(cfg_frame_context[125]),
        .I2(cfg_frame_context[29]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[93]),
        .O(\s_axi_rdata[29]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000004044004440)) 
    \s_axi_rdata[29]_i_4 
       (.I0(\s_axi_rdata[31]_i_8_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[29]),
        .I3(\s_axi_rdata[30]_i_5_n_0 ),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(\s_axi_rdata[29]_i_5_n_0 ),
        .O(\s_axi_rdata[29]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h5555FF035555FFF3)) 
    \s_axi_rdata[29]_i_5 
       (.I0(\s_axi_rdata[29]_i_6_n_0 ),
        .I1(owner_cpu_epoch[29]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[29]),
        .O(\s_axi_rdata[29]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[29]_i_6 
       (.I0(owner_granted_frames[29]),
        .I1(owner_slot[29]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[29]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[29]),
        .O(\s_axi_rdata[29]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hFEFEFEEEFEFEFEFE)) 
    \s_axi_rdata[2]_i_1 
       (.I0(\s_axi_rdata[2]_i_2_n_0 ),
        .I1(\s_axi_rdata[2]_i_3_n_0 ),
        .I2(\owner_status_held_reg_n_0_[2] ),
        .I3(s_axi_rvalid_reg_0),
        .I4(\s_axi_rdata[31]_i_1_n_0 ),
        .I5(s_axi_arvalid),
        .O(\s_axi_rdata[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8888888A888)) 
    \s_axi_rdata[2]_i_2 
       (.I0(\s_axi_rdata[31]_i_6_n_0 ),
        .I1(\s_axi_rdata[2]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(cfg_frame_context[130]),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[2]_i_5_n_0 ),
        .O(\s_axi_rdata[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h3030000030002020)) 
    \s_axi_rdata[2]_i_3 
       (.I0(\configured_reg_n_0_[2] ),
        .I1(\s_axi_rdata[4]_i_4_n_0 ),
        .I2(\owner_status_held[6]_i_4_n_0 ),
        .I3(barrier_request_reg_0),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h00000000F4000000)) 
    \s_axi_rdata[2]_i_4 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[2]_i_6_n_0 ),
        .I3(\s_axi_rdata[31]_i_5_n_0 ),
        .I4(\s_axi_rdata[2]_i_7_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCCAAFFF0CCAA00F0)) 
    \s_axi_rdata[2]_i_5 
       (.I0(cfg_frame_context[34]),
        .I1(cfg_frame_context[98]),
        .I2(cfg_frame_context[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[66]),
        .O(\s_axi_rdata[2]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[2]_i_6 
       (.I0(\s_axi_rdata[2]_i_8_n_0 ),
        .I1(owner_cpu_epoch[2]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[2]),
        .O(\s_axi_rdata[2]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hCFCFFFCFCFCFEFEF)) 
    \s_axi_rdata[2]_i_7 
       (.I0(owner_released_frames[2]),
        .I1(s_axi_araddr[0]),
        .I2(s_axi_araddr[5]),
        .I3(owner_fault_causes[2]),
        .I4(s_axi_araddr[3]),
        .I5(s_axi_araddr[2]),
        .O(\s_axi_rdata[2]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[2]_i_8 
       (.I0(owner_granted_frames[2]),
        .I1(owner_slot[2]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[2]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[2]),
        .O(\s_axi_rdata[2]_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hF000F080)) 
    \s_axi_rdata[30]_i_1 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(\s_axi_rdata[31]_i_6_n_0 ),
        .I3(\s_axi_rdata[30]_i_2_n_0 ),
        .I4(\s_axi_rdata[30]_i_3_n_0 ),
        .O(\s_axi_rdata[30]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[30]_i_2 
       (.I0(\s_axi_rdata[30]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[30]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[30]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h000F3355FF0F3355)) 
    \s_axi_rdata[30]_i_3 
       (.I0(cfg_frame_context[30]),
        .I1(cfg_frame_context[62]),
        .I2(cfg_frame_context[94]),
        .I3(s_axi_araddr[2]),
        .I4(s_axi_araddr[3]),
        .I5(cfg_frame_context[126]),
        .O(\s_axi_rdata[30]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[30]_i_4 
       (.I0(\s_axi_rdata[30]_i_6_n_0 ),
        .I1(owner_cpu_epoch[30]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[30]),
        .O(\s_axi_rdata[30]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \s_axi_rdata[30]_i_5 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_araddr[5]),
        .O(\s_axi_rdata[30]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[30]_i_6 
       (.I0(owner_granted_frames[30]),
        .I1(owner_slot[30]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[30]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[30]),
        .O(\s_axi_rdata[30]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'hB)) 
    \s_axi_rdata[31]_i_1 
       (.I0(owner_status_pending_reg_n_0),
        .I1(s_axi_aresetn),
        .O(\s_axi_rdata[31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[31]_i_10 
       (.I0(\s_axi_rdata[31]_i_12_n_0 ),
        .I1(owner_cpu_epoch[31]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[31]),
        .O(\s_axi_rdata[31]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \s_axi_rdata[31]_i_11 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_araddr[3]),
        .O(\s_axi_rdata[31]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[31]_i_12 
       (.I0(owner_granted_frames[31]),
        .I1(owner_slot[31]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[31]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[31]),
        .O(\s_axi_rdata[31]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'hF4F0)) 
    \s_axi_rdata[31]_i_2 
       (.I0(s_axi_rvalid_reg_0),
        .I1(s_axi_aresetn),
        .I2(owner_status_pending_reg_n_0),
        .I3(s_axi_arvalid),
        .O(\s_axi_rdata[31]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h8080F0800000F000)) 
    \s_axi_rdata[31]_i_3 
       (.I0(\s_axi_rdata[31]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(\s_axi_rdata[31]_i_6_n_0 ),
        .I3(\s_axi_rdata[31]_i_7_n_0 ),
        .I4(\s_axi_rdata[31]_i_8_n_0 ),
        .I5(\s_axi_rdata[31]_i_9_n_0 ),
        .O(\s_axi_rdata[31]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0101000001110101)) 
    \s_axi_rdata[31]_i_4 
       (.I0(s_axi_araddr[6]),
        .I1(\s_axi_rresp[1]_i_2_n_0 ),
        .I2(s_axi_araddr[4]),
        .I3(s_axi_araddr[2]),
        .I4(s_axi_araddr[5]),
        .I5(s_axi_araddr[3]),
        .O(\s_axi_rdata[31]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00000000070FCCC7)) 
    \s_axi_rdata[31]_i_5 
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[4]),
        .I3(s_axi_araddr[2]),
        .I4(s_axi_araddr[5]),
        .I5(\s_axi_rresp[1]_i_2_n_0 ),
        .O(\s_axi_rdata[31]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAAAAA8)) 
    \s_axi_rdata[31]_i_6 
       (.I0(\owner_status_held[6]_i_4_n_0 ),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[1]),
        .I3(s_axi_araddr[0]),
        .I4(s_axi_araddr[4]),
        .I5(s_axi_araddr[5]),
        .O(\s_axi_rdata[31]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hA2AEA2A200000000)) 
    \s_axi_rdata[31]_i_7 
       (.I0(\s_axi_rdata[31]_i_10_n_0 ),
        .I1(s_axi_araddr[5]),
        .I2(s_axi_araddr[0]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(owner_released_frames[31]),
        .I5(\s_axi_rdata[31]_i_5_n_0 ),
        .O(\s_axi_rdata[31]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFEFFFEFFFEF)) 
    \s_axi_rdata[31]_i_8 
       (.I0(s_axi_araddr[1]),
        .I1(s_axi_araddr[0]),
        .I2(s_axi_araddr[6]),
        .I3(\s_axi_rresp[1]_i_4_n_0 ),
        .I4(s_axi_araddr[5]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[31]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hF0CCFFAAF0CC00AA)) 
    \s_axi_rdata[31]_i_9 
       (.I0(cfg_frame_context[31]),
        .I1(cfg_frame_context[63]),
        .I2(cfg_frame_context[127]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[95]),
        .O(\s_axi_rdata[31]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAAEAAAEAFFFFAAEA)) 
    \s_axi_rdata[3]_i_1 
       (.I0(\s_axi_rdata[3]_i_2_n_0 ),
        .I1(\s_axi_rdata[3]_i_3_n_0 ),
        .I2(\configured_reg_n_0_[3] ),
        .I3(\s_axi_rdata[31]_i_5_n_0 ),
        .I4(\owner_status_held_reg_n_0_[3] ),
        .I5(owner_status_pending1),
        .O(\s_axi_rdata[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8888888A888)) 
    \s_axi_rdata[3]_i_2 
       (.I0(\s_axi_rdata[31]_i_6_n_0 ),
        .I1(\s_axi_rdata[3]_i_5_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(cfg_frame_context[131]),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[3]_i_6_n_0 ),
        .O(\s_axi_rdata[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \s_axi_rdata[3]_i_3 
       (.I0(\owner_status_held[6]_i_4_n_0 ),
        .I1(\s_axi_rdata[4]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .O(\s_axi_rdata[3]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT4 #(
    .INIT(16'h0020)) 
    \s_axi_rdata[3]_i_4 
       (.I0(s_axi_arvalid),
        .I1(owner_status_pending_reg_n_0),
        .I2(s_axi_aresetn),
        .I3(s_axi_rvalid_reg_0),
        .O(owner_status_pending1));
  LUT6 #(
    .INIT(64'h00000000F4000000)) 
    \s_axi_rdata[3]_i_5 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_araddr[5]),
        .I2(\s_axi_rdata[3]_i_7_n_0 ),
        .I3(\s_axi_rdata[31]_i_5_n_0 ),
        .I4(\s_axi_rdata[3]_i_8_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFAACCF000AACCF0)) 
    \s_axi_rdata[3]_i_6 
       (.I0(cfg_frame_context[35]),
        .I1(cfg_frame_context[67]),
        .I2(cfg_frame_context[3]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[99]),
        .O(\s_axi_rdata[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[3]_i_7 
       (.I0(\s_axi_rdata[3]_i_9_n_0 ),
        .I1(owner_cpu_epoch[3]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[3]),
        .O(\s_axi_rdata[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hCFCFFFCFCFCFEFEF)) 
    \s_axi_rdata[3]_i_8 
       (.I0(owner_released_frames[3]),
        .I1(s_axi_araddr[0]),
        .I2(s_axi_araddr[5]),
        .I3(owner_fault_causes[3]),
        .I4(s_axi_araddr[3]),
        .I5(s_axi_araddr[2]),
        .O(\s_axi_rdata[3]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[3]_i_9 
       (.I0(owner_granted_frames[3]),
        .I1(owner_slot[3]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[3]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[3]),
        .O(\s_axi_rdata[3]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hFD00FFFFFD00FD00)) 
    \s_axi_rdata[4]_i_1 
       (.I0(s_axi_arvalid),
        .I1(\s_axi_rdata[31]_i_1_n_0 ),
        .I2(s_axi_rvalid_reg_0),
        .I3(\owner_status_held_reg_n_0_[4] ),
        .I4(\s_axi_rdata[4]_i_2_n_0 ),
        .I5(\s_axi_rdata[4]_i_3_n_0 ),
        .O(\s_axi_rdata[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'h555577DF)) 
    \s_axi_rdata[4]_i_2 
       (.I0(\owner_status_held[6]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_4_n_0 ),
        .I2(\configured_reg_n_0_[4] ),
        .I3(\s_axi_rdata[31]_i_5_n_0 ),
        .I4(\s_axi_rdata[4]_i_4_n_0 ),
        .O(\s_axi_rdata[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFBFBFBBBBBBBFBBB)) 
    \s_axi_rdata[4]_i_3 
       (.I0(\s_axi_rdata[4]_i_5_n_0 ),
        .I1(\s_axi_rdata[4]_i_4_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(cfg_frame_context[132]),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[4]_i_6_n_0 ),
        .O(\s_axi_rdata[4]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \s_axi_rdata[4]_i_4 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[4]),
        .I2(s_axi_araddr[0]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[6]),
        .O(\s_axi_rdata[4]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000080808880)) 
    \s_axi_rdata[4]_i_5 
       (.I0(\s_axi_rdata[31]_i_5_n_0 ),
        .I1(\s_axi_rdata[4]_i_7_n_0 ),
        .I2(\s_axi_rdata[4]_i_8_n_0 ),
        .I3(s_axi_araddr[5]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[4]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFAACCF000AACCF0)) 
    \s_axi_rdata[4]_i_6 
       (.I0(cfg_frame_context[36]),
        .I1(cfg_frame_context[68]),
        .I2(cfg_frame_context[4]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[100]),
        .O(\s_axi_rdata[4]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hCFCFFFCFCFCFEFEF)) 
    \s_axi_rdata[4]_i_7 
       (.I0(owner_released_frames[4]),
        .I1(s_axi_araddr[0]),
        .I2(s_axi_araddr[5]),
        .I3(owner_command_fault_reg_0),
        .I4(s_axi_araddr[3]),
        .I5(s_axi_araddr[2]),
        .O(\s_axi_rdata[4]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[4]_i_8 
       (.I0(\s_axi_rdata[4]_i_9_n_0 ),
        .I1(owner_cpu_epoch[4]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[4]),
        .O(\s_axi_rdata[4]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[4]_i_9 
       (.I0(owner_granted_frames[4]),
        .I1(owner_slot[4]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[4]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[4]),
        .O(\s_axi_rdata[4]_i_9_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFD00)) 
    \s_axi_rdata[5]_i_1 
       (.I0(s_axi_arvalid),
        .I1(owner_status_pending_reg_n_0),
        .I2(s_axi_rvalid_reg_0),
        .I3(\owner_status_held_reg_n_0_[5] ),
        .I4(\s_axi_rdata[5]_i_2_n_0 ),
        .O(\s_axi_rdata[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8888888A888)) 
    \s_axi_rdata[5]_i_2 
       (.I0(\s_axi_rdata[31]_i_6_n_0 ),
        .I1(\s_axi_rdata[5]_i_3_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(cfg_frame_context[133]),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[5]_i_4_n_0 ),
        .O(\s_axi_rdata[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[5]_i_3 
       (.I0(\s_axi_rdata[5]_i_5_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[5]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[5]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFAACCF000AACCF0)) 
    \s_axi_rdata[5]_i_4 
       (.I0(cfg_frame_context[37]),
        .I1(cfg_frame_context[69]),
        .I2(cfg_frame_context[5]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[101]),
        .O(\s_axi_rdata[5]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[5]_i_5 
       (.I0(\s_axi_rdata[5]_i_6_n_0 ),
        .I1(owner_cpu_epoch[5]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[5]),
        .O(\s_axi_rdata[5]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[5]_i_6 
       (.I0(owner_granted_frames[5]),
        .I1(owner_slot[5]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[5]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[5]),
        .O(\s_axi_rdata[5]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFEEEAEEEE)) 
    \s_axi_rdata[6]_i_1 
       (.I0(\s_axi_rdata[6]_i_2_n_0 ),
        .I1(\owner_status_held_reg_n_0_[6] ),
        .I2(s_axi_rvalid_reg_0),
        .I3(\s_axi_rdata[31]_i_1_n_0 ),
        .I4(s_axi_arvalid),
        .I5(\s_axi_rdata[29]_i_2_n_0 ),
        .O(\s_axi_rdata[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8888888A888)) 
    \s_axi_rdata[6]_i_2 
       (.I0(\s_axi_rdata[31]_i_6_n_0 ),
        .I1(\s_axi_rdata[6]_i_3_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(cfg_frame_context[134]),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[6]_i_4_n_0 ),
        .O(\s_axi_rdata[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[6]_i_3 
       (.I0(\s_axi_rdata[6]_i_5_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[6]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[6]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFAACCF000AACCF0)) 
    \s_axi_rdata[6]_i_4 
       (.I0(cfg_frame_context[38]),
        .I1(cfg_frame_context[70]),
        .I2(cfg_frame_context[6]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[102]),
        .O(\s_axi_rdata[6]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[6]_i_5 
       (.I0(\s_axi_rdata[6]_i_6_n_0 ),
        .I1(owner_cpu_epoch[6]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[6]),
        .O(\s_axi_rdata[6]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[6]_i_6 
       (.I0(owner_granted_frames[6]),
        .I1(owner_slot[6]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[6]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[6]),
        .O(\s_axi_rdata[6]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8888888A888)) 
    \s_axi_rdata[7]_i_1 
       (.I0(\s_axi_rdata[31]_i_6_n_0 ),
        .I1(\s_axi_rdata[7]_i_2_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(cfg_frame_context[135]),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[7]_i_3_n_0 ),
        .O(\s_axi_rdata[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[7]_i_2 
       (.I0(\s_axi_rdata[7]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[7]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCAAFFF0CCAA00F0)) 
    \s_axi_rdata[7]_i_3 
       (.I0(cfg_frame_context[39]),
        .I1(cfg_frame_context[103]),
        .I2(cfg_frame_context[7]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[71]),
        .O(\s_axi_rdata[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[7]_i_4 
       (.I0(\s_axi_rdata[7]_i_5_n_0 ),
        .I1(owner_cpu_epoch[7]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[7]),
        .O(\s_axi_rdata[7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[7]_i_5 
       (.I0(owner_granted_frames[7]),
        .I1(owner_slot[7]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[7]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[7]),
        .O(\s_axi_rdata[7]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8888888A888)) 
    \s_axi_rdata[8]_i_1 
       (.I0(\s_axi_rdata[31]_i_6_n_0 ),
        .I1(\s_axi_rdata[8]_i_2_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(cfg_frame_context[136]),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[8]_i_3_n_0 ),
        .O(\s_axi_rdata[8]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[8]_i_2 
       (.I0(\s_axi_rdata[8]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[8]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[8]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFCCF0AA00CCF0AA)) 
    \s_axi_rdata[8]_i_3 
       (.I0(cfg_frame_context[8]),
        .I1(cfg_frame_context[72]),
        .I2(cfg_frame_context[40]),
        .I3(s_axi_araddr[2]),
        .I4(s_axi_araddr[3]),
        .I5(cfg_frame_context[104]),
        .O(\s_axi_rdata[8]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[8]_i_4 
       (.I0(\s_axi_rdata[8]_i_5_n_0 ),
        .I1(owner_cpu_epoch[8]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[8]),
        .O(\s_axi_rdata[8]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[8]_i_5 
       (.I0(owner_granted_frames[8]),
        .I1(owner_slot[8]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[8]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[8]),
        .O(\s_axi_rdata[8]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hA8A8A8888888A888)) 
    \s_axi_rdata[9]_i_1 
       (.I0(\s_axi_rdata[31]_i_6_n_0 ),
        .I1(\s_axi_rdata[9]_i_2_n_0 ),
        .I2(\s_axi_rdata[31]_i_4_n_0 ),
        .I3(cfg_frame_context[137]),
        .I4(\s_axi_rdata[31]_i_5_n_0 ),
        .I5(\s_axi_rdata[9]_i_3_n_0 ),
        .O(\s_axi_rdata[9]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000888800C0)) 
    \s_axi_rdata[9]_i_2 
       (.I0(\s_axi_rdata[9]_i_4_n_0 ),
        .I1(\s_axi_rdata[31]_i_5_n_0 ),
        .I2(owner_released_frames[9]),
        .I3(\s_axi_rdata[31]_i_11_n_0 ),
        .I4(\s_axi_rdata[30]_i_5_n_0 ),
        .I5(\s_axi_rdata[31]_i_8_n_0 ),
        .O(\s_axi_rdata[9]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCCAAFFF0CCAA00F0)) 
    \s_axi_rdata[9]_i_3 
       (.I0(cfg_frame_context[41]),
        .I1(cfg_frame_context[105]),
        .I2(cfg_frame_context[9]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(cfg_frame_context[73]),
        .O(\s_axi_rdata[9]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA00FCAAAA000C)) 
    \s_axi_rdata[9]_i_4 
       (.I0(\s_axi_rdata[9]_i_5_n_0 ),
        .I1(owner_cpu_epoch[9]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[4]),
        .I5(owner_cpu_frame_id[9]),
        .O(\s_axi_rdata[9]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s_axi_rdata[9]_i_5 
       (.I0(owner_granted_frames[9]),
        .I1(owner_slot[9]),
        .I2(s_axi_araddr[3]),
        .I3(owner_frame_id[9]),
        .I4(s_axi_araddr[2]),
        .I5(owner_epoch[9]),
        .O(\s_axi_rdata[9]_i_5_n_0 ));
  FDRE \s_axi_rdata_reg[0] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[0]_i_1_n_0 ),
        .Q(s_axi_rdata[0]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[10] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[10]_i_1_n_0 ),
        .Q(s_axi_rdata[10]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[11] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[11]_i_1_n_0 ),
        .Q(s_axi_rdata[11]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[12] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[12]_i_1_n_0 ),
        .Q(s_axi_rdata[12]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[13] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[13]_i_1_n_0 ),
        .Q(s_axi_rdata[13]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[14] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[14]_i_1_n_0 ),
        .Q(s_axi_rdata[14]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[15] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[15]_i_1_n_0 ),
        .Q(s_axi_rdata[15]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[16] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[16]_i_1_n_0 ),
        .Q(s_axi_rdata[16]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[17] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[17]_i_1_n_0 ),
        .Q(s_axi_rdata[17]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[18] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[18]_i_1_n_0 ),
        .Q(s_axi_rdata[18]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[19] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[19]_i_1_n_0 ),
        .Q(s_axi_rdata[19]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[1] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[1]_i_1_n_0 ),
        .Q(s_axi_rdata[1]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[20] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[20]_i_1_n_0 ),
        .Q(s_axi_rdata[20]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[21] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[21]_i_1_n_0 ),
        .Q(s_axi_rdata[21]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[22] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[22]_i_1_n_0 ),
        .Q(s_axi_rdata[22]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[23] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[23]_i_1_n_0 ),
        .Q(s_axi_rdata[23]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[24] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[24]_i_1_n_0 ),
        .Q(s_axi_rdata[24]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[25] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[25]_i_1_n_0 ),
        .Q(s_axi_rdata[25]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[26] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[26]_i_1_n_0 ),
        .Q(s_axi_rdata[26]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[27] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[27]_i_1_n_0 ),
        .Q(s_axi_rdata[27]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[28] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[28]_i_1_n_0 ),
        .Q(s_axi_rdata[28]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[29] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[29]_i_1_n_0 ),
        .Q(s_axi_rdata[29]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[2] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[2]_i_1_n_0 ),
        .Q(s_axi_rdata[2]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[30] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[30]_i_1_n_0 ),
        .Q(s_axi_rdata[30]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[31] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[31]_i_3_n_0 ),
        .Q(s_axi_rdata[31]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[3] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[3]_i_1_n_0 ),
        .Q(s_axi_rdata[3]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[4] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[4]_i_1_n_0 ),
        .Q(s_axi_rdata[4]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[5] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[5]_i_1_n_0 ),
        .Q(s_axi_rdata[5]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[6] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[6]_i_1_n_0 ),
        .Q(s_axi_rdata[6]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[7] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[7]_i_1_n_0 ),
        .Q(s_axi_rdata[7]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[8] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[8]_i_1_n_0 ),
        .Q(s_axi_rdata[8]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  FDRE \s_axi_rdata_reg[9] 
       (.C(s_axi_aclk),
        .CE(\s_axi_rdata[31]_i_2_n_0 ),
        .D(\s_axi_rdata[9]_i_1_n_0 ),
        .Q(s_axi_rdata[9]),
        .R(\s_axi_rdata[31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000EEEEEEE2)) 
    \s_axi_rresp[1]_i_1 
       (.I0(s_axi_rresp),
        .I1(owner_status_pending1),
        .I2(\s_axi_rresp[1]_i_2_n_0 ),
        .I3(\s_axi_rresp[1]_i_3_n_0 ),
        .I4(\s_axi_rresp[1]_i_4_n_0 ),
        .I5(\s_axi_rdata[31]_i_1_n_0 ),
        .O(\s_axi_rresp[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \s_axi_rresp[1]_i_2 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_araddr[1]),
        .O(\s_axi_rresp[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hBFB0B0B0BFB0BFB0)) 
    \s_axi_rresp[1]_i_3 
       (.I0(\owner_status_held[6]_i_5_n_0 ),
        .I1(\s_axi_rresp[1]_i_5_n_0 ),
        .I2(s_axi_araddr[6]),
        .I3(s_axi_araddr[4]),
        .I4(\s_axi_rdata[31]_i_11_n_0 ),
        .I5(s_axi_araddr[5]),
        .O(\s_axi_rresp[1]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \s_axi_rresp[1]_i_4 
       (.I0(s_axi_araddr[10]),
        .I1(s_axi_araddr[9]),
        .I2(s_axi_araddr[8]),
        .I3(s_axi_araddr[11]),
        .I4(s_axi_araddr[7]),
        .O(\s_axi_rresp[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000010)) 
    \s_axi_rresp[1]_i_5 
       (.I0(s_axi_araddr[8]),
        .I1(s_axi_araddr[9]),
        .I2(s_axi_araddr[6]),
        .I3(s_axi_araddr[7]),
        .I4(s_axi_araddr[11]),
        .I5(s_axi_araddr[10]),
        .O(\s_axi_rresp[1]_i_5_n_0 ));
  FDRE \s_axi_rresp_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\s_axi_rresp[1]_i_1_n_0 ),
        .Q(s_axi_rresp),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hF0FFF4F4)) 
    s_axi_rvalid_i_1
       (.I0(s_axi_rvalid_i_2_n_0),
        .I1(s_axi_arvalid),
        .I2(owner_status_pending_reg_n_0),
        .I3(s_axi_rready),
        .I4(s_axi_rvalid_reg_0),
        .O(s_axi_rvalid_i_1_n_0));
  LUT6 #(
    .INIT(64'h0000000000000002)) 
    s_axi_rvalid_i_2
       (.I0(\s_axi_rresp[1]_i_5_n_0 ),
        .I1(s_axi_araddr[1]),
        .I2(s_axi_araddr[0]),
        .I3(\owner_status_held[6]_i_3_n_0 ),
        .I4(s_axi_araddr[4]),
        .I5(s_axi_araddr[5]),
        .O(s_axi_rvalid_i_2_n_0));
  FDRE s_axi_rvalid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_rvalid_i_1_n_0),
        .Q(s_axi_rvalid_reg_0),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'h0010)) 
    s_axi_wready_INST_0
       (.I0(w_held_reg_n_0),
        .I1(owner_command_pending_reg_n_0),
        .I2(s_axi_aresetn),
        .I3(s_axi_bvalid_reg_0),
        .O(s_axi_wready));
  FDRE \strobes_held_reg[0] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wstrb[0]),
        .Q(strobes_held[0]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \strobes_held_reg[1] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wstrb[1]),
        .Q(strobes_held[1]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \strobes_held_reg[2] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wstrb[2]),
        .Q(strobes_held[2]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  FDRE \strobes_held_reg[3] 
       (.C(s_axi_aclk),
        .CE(w_held0),
        .D(s_axi_wstrb[3]),
        .Q(strobes_held[3]),
        .R(\s_axi_bresp[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF000F0F000200020)) 
    w_held_i_1
       (.I0(s_axi_wvalid),
        .I1(owner_command_pending_reg_n_0),
        .I2(s_axi_aresetn),
        .I3(s_axi_bvalid_reg_0),
        .I4(aw_held),
        .I5(w_held_reg_n_0),
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
